---
tags: [apex, testing, runAs, security, sharing, mixed-dml, package-version]
source: salesforce_apex_developer_guide.pdf
created: 2026-07-08
aliases: [System.runAs, runAs, runAs 메서드, 테스트 실행 컨텍스트, 사용자 컨텍스트 테스트, runAs Version]
---

# System.runAs (테스트 실행 컨텍스트)

> 테스트 메서드 안에서 코드를 **다른 사용자의 컨텍스트**로 실행해 그 사용자의 공유 규칙·오브젝트/필드 권한을 검증하거나, 특정 패키지 버전 컨텍스트로 전환한다. 오직 테스트 메서드에서만 쓸 수 있다.

---

## 개념

일반적으로 모든 Apex 코드는 **user mode**에서 실행되며 현재 사용자의 오브젝트/필드 권한이 적용된다. 시스템 메서드 `runAs`를 쓰면 테스트 메서드에서 실행 컨텍스트를 기존 사용자나 새 사용자로 바꿀 수 있고, 그러면 **그 사용자의 공유 규칙 + 오브젝트/필드 권한이 적용**된다.

핵심 규칙(공식 문서):

- `runAs` 블록 안에서는 테스트 클래스의 sharing 모드(`with sharing` / `without sharing`)와 **무관하게** 대상 사용자의 공유 규칙과 오브젝트/필드 권한이 강제된다.
- 단, `runAs` 블록 안에서 **사용자 정의 메서드를 호출**하면, 적용되는 sharing 모드는 테스트 클래스가 아니라 **그 메서드가 정의된 클래스**의 sharing 모드다.
- `runAs`는 **테스트 메서드에서만** 사용 가능하다. 모든 `runAs` 테스트 메서드가 끝나면 원래의 현재 사용자 컨텍스트로 복귀한다.
- `runAs`는 **user license 한도를 무시**한다. 조직에 추가 라이선스가 없어도 `runAs`로 사용자를 생성할 수 있다.
- `runAs` 호출 1회는 프로세스에서 발생한 **전체 DML 문 수에 카운트**된다.

```apex
@isTest
private class TestRunAs {
    public static testMethod void testRunAs() {
        // 이 코드는 시스템(현재) 사용자로 실행됨
        // 유니크한 UserName 생성
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles',
            UserName=uniqueUserName);

        System.runAs(u) {
            // 이 안의 코드는 사용자 'u'로 실행됨 — u의 레코드 공유 접근이 적용됨
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId());
        }
    }
}
```

---

## 레퍼런스 — 오버로드·문법

| 시그니처 | 인자 | 효과 |
|---|---|---|
| `System.runAs(User userSObject)` | 기존/신규 `User` sObject | 블록 내 코드를 해당 사용자 컨텍스트로 실행 (공유 규칙·오브젝트/필드 권한 적용) |
| `System.runAs(System.Version version)` | 관리형 패키지 버전 | 블록 내 코드가 지정한 **패키지 버전의 코드**를 사용하도록 컨텍스트 전환 |

- **블록 문법**: `System.runAs(대상) { ... }` — 중괄호 블록 안의 코드만 대상 컨텍스트로 실행되고, 블록을 벗어나면 이전 컨텍스트로 돌아온다.
- **반환값 없음**: `runAs`는 값을 반환하지 않는다. 블록 스코프로만 컨텍스트를 한정한다.
- **중첩 가능**: `runAs` 블록을 다른 `runAs` 블록 안에 중첩할 수 있다. 안쪽 블록이 끝나면 바로 바깥 블록의 사용자 컨텍스트로 복귀한다.

---

## 절차·용례

### (1) 권한·FLS·공유 규칙 테스트

특정 프로필/권한 세트를 가진 사용자가 실제로 레코드에 접근/수정할 수 있는지, 또는 접근이 **차단**되는지를 그 사용자 컨텍스트에서 검증한다. `runAs` 블록 안에서는 테스트 클래스의 sharing 모드와 무관하게 대상 사용자의 공유 규칙과 오브젝트/필드 권한이 강제되므로, 실제 사용자 경험에 가깝게 검증할 수 있다.

```apex
System.runAs(u) {
    // u의 FLS/공유 규칙으로 쿼리·DML이 강제됨
    // 접근 불가 필드/레코드면 예외 또는 빈 결과가 나는지 assert
    System.debug('Current User: ' + UserInfo.getUserName());
    System.debug('Current Profile: ' + UserInfo.getProfileId());
}
```

### (2) Mixed DML 우회 (setup vs non-setup)

`User`·`UserRole`·`Profile` 같은 **setup sObject**와 `Account` 같은 non-setup sObject를 한 트랜잭션에서 함께 DML하면 mixed DML 에러가 난다. 테스트 메서드에서는 DML을 `System.runAs` 블록으로 감싸면 이 에러를 우회할 수 있다. 아래 예제는 role을 가진 User(setup)와 Account(non-setup)를 같은 테스트에서 생성하는 mixed DML 작업이다.

```apex
@isTest
private class MixedDML {
    static testMethod void mixedDMLExample() {
        User u;
        Account a;
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        // 현재 사용자 컨텍스트로 실행 — mixed DML 에러 우회
        System.runAs (thisUser) {
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
            UserRole r = [SELECT Id FROM UserRole WHERE Name='COO'];
            u = new User(alias = 'jsmith', email='jsmith@acme.com',
                emailencodingkey='UTF-8', lastname='Smith',
                languagelocalekey='en_US',
                localesidkey='en_US', profileid = p.Id, userroleid = r.Id,
                timezonesidkey='America/Los_Angeles',
                username='jsmith@acme.com');
            insert u;              // setup sObject
            a = new Account(name='Acme');
            insert a;              // non-setup sObject — 같은 블록에서 OK
        }
    }
}
```

> 배포 시에는 mixed DML 검증이 스킵되므로, UI 실행 때와 배포 때 테스트 실패 수가 달라질 수 있다(공식 주의사항).

### (3) 중첩 runAs

`runAs`를 중첩하면 안쪽 블록이 더 안쪽 사용자 컨텍스트로 실행되고, 블록을 벗어날 때마다 한 단계 바깥 컨텍스트로 복귀한다.

```apex
System.runAs(u2) {
    // u2 컨텍스트
    System.debug('Current User: ' + UserInfo.getUserName());

    User u3 = [SELECT Id FROM User WHERE UserName='newuser@testorg.com'];
    System.runAs(u3) {
        // u3 컨텍스트
        System.debug('Current User: ' + UserInfo.getUserName());
    }
    // 여기부터 다시 u2 컨텍스트
}
```

### (4) 패키지 버전 컨텍스트 — runAs(Version)

`runAs(System.Version)` 오버로드는 관리형 패키지의 특정 버전 코드를 사용하도록 컨텍스트를 바꾼다. 패키지 개발자가 버전 간 동작 차이(하위 호환)를 단위 테스트로 검증할 때 쓴다. 이 역시 **테스트 메서드에서만** 가능하다.

```apex
// 버전 2.0은 배송비 계산 포함
System.runAs(new Version(2, 0)) {
    Decimal totalPrice = calculator.getTotalPrice(cart);
    Assert.areEqual(80.0, totalPrice, 'The total price should be 80.0');
}
// 버전 1.0은 배송비 계산 미포함
System.runAs(new Version(1, 0)) {
    Decimal totalPrice = calculator.getTotalPrice(cart);
    Assert.areEqual(60.0, totalPrice, 'The total price should be 60.0');
}
```

---

## 제약 (반드시 인지)

| 제약 | 내용 |
|---|---|
| 테스트 전용 | `runAs`는 **오직 테스트 메서드**에서만 호출 가능. 프로덕션 코드에서는 사용 불가. |
| DML 한도 우회 안 됨 | `runAs` 호출 1회는 전체 **DML 문 수에 카운트**된다. governor DML 한도를 회피하는 수단이 아니다. |
| 시스템 메서드 한계 | `runAs`는 **오브젝트/필드 권한과 공유 규칙만** 사용자별로 강제한다. 그 밖의 시스템 메서드·권한(예: 일부 시스템 레벨 동작)까지 완전히 사용자로 전환하지는 않는다. |
| 사용자 정의 메서드의 sharing | `runAs` 블록에서 호출한 사용자 정의 메서드는 그 메서드가 **정의된 클래스**의 sharing 모드를 따른다(테스트 클래스가 아님). |
| 라이선스 무시 | user license 한도를 무시하므로 라이선스 없이도 테스트 사용자를 만들 수 있다(제약이자 편의). |

---

## 관련 노트
- [[Mixed DML 제약과 우회]]
- [[Test Data Factory 패턴]]
- [[테스트 전략]]
