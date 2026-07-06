---
tags: [apex, data, dml, mixed-dml, setup-object, troubleshooting, testing, async]
source: salesforce_apex_developer_guide.pdf — "sObjects That Can't Be Used Together in DML Operations" · "Mixed DML Operations in Test Methods" · "Future Methods" 섹션
created: 2026-07-05
aliases: [Mixed DML, MIXED_DML_OPERATION, Setup Object, 세트업 오브젝트, 믹스드 DML, User Account 같이 insert]
---

# Mixed DML 제약과 우회

> User·PermissionSet 같은 **setup 오브젝트**와 Account 같은 일반 오브젝트를 **같은 트랜잭션**에서 DML하면 `MIXED_DML_OPERATION` 에러가 난다 — 테스트에서는 `System.runAs` 블록 분리, 런타임에서는 `@future`/Queueable 비동기 분리로 우회한다.

---

## 왜 발생하는가 (원리)

일부 sObject(이른바 **setup 오브젝트**)에 대한 DML은 같은 트랜잭션 안에서 non-setup sObject DML과 섞을 수 없다.

- **이유:** setup 오브젝트는 **조직 내 레코드에 대한 사용자의 접근 권한 자체를 바꾼다.** 권한을 바꾸는 연산과 그 권한의 영향을 받는 데이터 연산이 한 트랜잭션에 섞이면, **잘못된 접근 레벨 권한으로 연산이 수행될 수 있기 때문에** 별도 트랜잭션으로 강제 분리된다.
- 예: Account 업데이트와 UserRole 업데이트는 한 트랜잭션에서 불가.
- 이 제약은 Apex DML뿐 아니라 **Metadata API 사용 시에도** 동일하게 적용된다.
- setup 오브젝트는 **`@IsTest(IsParallel=true)` 어노테이션과도 함께 쓸 수 없다** — 이런 연산은 별도 트랜잭션으로 분리해야 한다.
- **Visualforce 커스텀 컨트롤러:** 단일 request/action 안에서는 setup·non-setup을 섞을 수 없지만, **연속된 별개 request에서는 각각 DML 가능**하다 (예: save 버튼으로 Account 생성 → submit 버튼으로 role 있는 User 생성).

전형적인 에러 메시지:

```text
// 구조 예시 — 메시지 문구는 상황(오브젝트·순서)에 따라 달라짐
MIXED_DML_OPERATION, DML operation on setup object is not permitted
after you have updated a non-setup object (or vice versa): User, original object: Account
```

---

## Setup 오브젝트 목록

> PDF 원문 note: *"This list includes sObjects that cannot be used together in the same DML transaction, but is not an exhaustive list."* — 즉 아래는 공식 문서가 제시한 목록이지만 **전체를 망라한 목록은 아니다.**

| Setup 오브젝트 | 비고 (공식 문서 각주) |
|---|---|
| AuthSession | |
| ContentWorkspace | |
| FieldPermissions | |
| ForecastingShare | |
| Group | **insert·update만** 다른 sObject와 같은 트랜잭션에서 허용. 그 외 DML(delete 등)은 불가 |
| GroupMember | 레거시 예외: **API v14.0 이하로 저장된 Apex**에서는 다른 sObject와 같은 트랜잭션에서 insert·update 가능 |
| ObjectPermissions | |
| ObjectTerritory2AssignmentRule | |
| ObjectTerritory2AssignmentRuleItem | |
| PermissionSet | |
| PermissionSetAssignment | |
| QueueSObject | |
| RuleTerritory2Association | |
| SetupEntityAccess | |
| Territory | |
| Territory2 | |
| Territory2Model | |
| User | 예외 조건 상세 — 아래 "User의 예외 조건" 참조 |
| UserPackageLicense | |
| UserRole | |
| UserTerritory | |
| UserTerritory2Association | |

### User의 예외 조건 (섞어도 되는 경우)

User는 조건부로 다른 sObject와 같은 트랜잭션에서 DML이 허용된다:

- **insert**
  - API v14.0 이하로 저장된 Apex: 다른 sObject와 같은 트랜잭션에서 insert 가능.
  - API v15.0 이상: **`UserRoleId`가 null로 지정된 경우에만** 다른 sObject와 같은 트랜잭션에서 insert 가능. (→ role 있는 User insert가 Mixed DML의 대표 사례인 이유)
- **update**
  - API v14.0 이하로 저장된 Apex: 다른 sObject와 같은 트랜잭션에서 update 가능.
  - API v15.0 이상: 해당 User가 **Lightning Sync 또는 Einstein Activity Capture 구성(활성·비활성 불문)에 포함되지 않고**, 아래 필드를 업데이트하지 않는 경우에만 가능:
    - `UserRoleId` · `IsActive` · `ForecastEnabled` · `IsPortalEnabled` · `Username` · `ProfileId`

---

## 우회 1 — 테스트: System.runAs 블록으로 분리

테스트 메서드에서는 **DML을 `System.runAs` 블록으로 감싸면** setup sObject와 일반 sObject의 mixed DML이 허용된다. `System.runAs`는 현재 사용자 컨텍스트로 실행해도 된다(사용자를 바꿀 필요 없음) — 블록 경계 자체가 트랜잭션 컨텍스트를 분리해 주는 효과.

공식 예제 — role 있는 테스트 User와 Account를 같은 테스트에서 생성:

```apex
@isTest
private class MixedDML {
    static testMethod void mixedDMLExample() {
        User u;
        Account a;
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        // Insert account as current user
        System.runAs (thisUser) {
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
            UserRole r = [SELECT Id FROM UserRole WHERE Name='COO'];
            u = new User(alias = 'jsmith', email='jsmith@acme.com',
                emailencodingkey='UTF-8', lastname='Smith',
                languagelocalekey='en_US',
                localesidkey='en_US', profileid = p.Id, userroleid = r.Id,
                timezonesidkey='America/Los_Angeles',
                username='jsmith@acme.com');
            insert u;
            a = new Account(name='Acme');
            insert a;
        }
    }
}
```

> [!note] 배포 시 검증 스킵
> PDF 원문: *"Because validation for mixed DML operations is skipped during deployment, there can be a difference in the number of test failures when tests are deployed versus when run in the user interface."* — 배포 중에는 mixed DML 검증이 스킵되므로, **배포 시 테스트 실패 수와 UI에서 직접 실행한 테스트 실패 수가 다를 수 있다.**

---

## 우회 2 — 테스트: @future 비동기 잡으로 분리

테스트 메서드가 호출하는 **비동기 잡 안에서 DML을 수행**하는 방법도 허용된다. 한 종류의 DML은 비동기 잡에서, 나머지는 원래 트랜잭션(또는 다른 비동기 잡)에서 수행한다.

공식 예제 — `@future`에서 role 있는 User insert, 테스트 본문에서 Contact insert:

```apex
public class InsertFutureUser {
    @future
    public static void insertUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        UserRole r = [SELECT Id FROM UserRole WHERE Name='COO'];
        User futureUser = new User(firstname = 'Future', lastname = 'User',
            alias = 'future', defaultgroupnotificationfrequency = 'N',
            digestfrequency = 'N', email = 'test@test.org',
            emailencodingkey = 'UTF-8', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id,
            timezonesidkey = 'America/Los_Angeles',
            username = 'futureuser@test.org',
            userpermissionsmarketinguser = false,
            userpermissionsofflineuser = false, userroleid = r.Id);
        insert(futureUser);
    }
}
```

```apex
@isTest
public class UserAndContactTest {
    public testmethod static void testUserAndContact() {
        InsertFutureUser.insertUser();
        Contact currentContact = new Contact(
            firstName = String.valueOf(System.currentTimeMillis()),
            lastName = 'Contact');
        insert(currentContact);
    }
}
```

---

## 우회 3 — 런타임(비테스트): @future / Queueable 분리 패턴

런타임 코드에서는 `System.runAs` 우회가 없다(테스트 전용). 공식 프로세스는:

1. 한 sObject 타입에 DML을 수행하는 메서드를 만든다.
2. **`@future` 어노테이션을 단 두 번째 메서드**에서 다른 sObject 타입을 조작한다.

공식 예제 (Future Methods 챕터 버전 — `WITH USER_MODE`·`insert as user` 사용):

```apex
public with sharing class Util {
    @Future
    public static void insertUserWithRole(
            String uname, String al, String em, String lname) {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User' WITH USER_MODE];
        UserRole r = [SELECT Id FROM UserRole WHERE Name='COO' WITH USER_MODE];
        // Create new user with a non-null user role ID
        User newUser = new User(alias = al, email=em,
            emailencodingkey='UTF-8', lastname=lname,
            languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id, userroleid = r.Id,
            timezonesidkey='America/Los_Angeles',
            username=uname);
        insert as user newUser;
    }
}
```

```apex
public with sharing class MixedDMLFuture {
    public static void useFutureMethod() {
        // First DML operation
        Account a = new Account(Name='Acme');
        insert as user a;
        // This next operation (insert a user with a role)
        // can't be mixed with the previous insert unless
        // it is within a future method.
        // Call future method to insert a user with a role.
        Util.insertUserWithRole(
            'mruiz@awcomputing.com', 'mruiz',
            'mruiz@awcomputing.com', 'Ruiz');
    }
}
```

### Queueable 권장

공식 문서는 future 대신 **Queueable Apex 사용을 권장**한다 (잡 ID·비원시 타입 파라미터·체이닝 지원). Mixed DML 관점에서는 `System.enqueueJob`으로 setup DML을 별도 Queueable 잡에 넣거나, [[Queueable 체이닝]]으로 setup 오브젝트 DML 단계와 일반 오브젝트 DML 단계를 잡 단위로 분리하면 같은 효과를 얻는다. Queueable 구현 상세는 [[Queueable]] 참조.

### 런타임 분리 패턴의 테스트

future로 분리한 mixed DML을 테스트할 때는 `Test.startTest()/stopTest()` 블록 + `System.runAs`를 함께 쓴다:

```apex
@IsTest
private class MixedDMLFutureTest {
    @IsTest static void test1() {
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() WITH
            USER_MODE];
        // System.runAs() allows mixed DML operations in test context
        System.runAs(thisUser) {
            // startTest/stopTest block to run future method synchronously
            Test.startTest();
            MixedDMLFuture.useFutureMethod();
            Test.stopTest();
        }
        // The future method will run after Test.stopTest();
        // Verify account is inserted
        Account[] accts = [SELECT Id from Account WHERE Name='Acme' WITH USER_MODE];
        Assert.areEqual(1, accts.size());
        // Verify user is inserted
        List<User> users = [SELECT Id from User WHERE username='mruiz@awcomputing.com'
            WITH USER_MODE];
        Assert.areEqual(1, users.size());
    }
}
```

---

## 선택 기준 요약

| 상황 | 우회 방법 |
|---|---|
| **테스트**에서 setup + 일반 오브젝트를 같이 만들어야 함 | `System.runAs(user) { ... }` 블록으로 감싸기 (가장 간단) |
| **테스트**에서 비동기 경로까지 검증하고 싶음 | `@future`/Queueable 호출 + `Test.startTest()/stopTest()` (+ runAs) |
| **런타임** 코드에서 setup + 일반 DML이 한 흐름에 필요 | setup DML을 `@future` 또는 Queueable 잡으로 분리 (공식 권장: Queueable) |
| **Visualforce 커스텀 컨트롤러** | 한 action에서 섞지 말고 연속된 별개 request로 분리 |
| `@IsTest(IsParallel=true)` 테스트 | setup 오브젝트 사용 불가 — 트랜잭션 분리 또는 병렬 해제 |

## 관련 노트

- [[DML 패턴]] — DML 기본 패턴·Database 메서드 (이 노트는 그중 트랜잭션 혼합 제약 상세)
- [[Queueable]] — 런타임 분리 패턴의 권장 수단 (Mixed DML 경고 원문 보유)
- [[Queueable 체이닝]] — setup/일반 DML을 잡 단위로 나누는 체이닝
- [[Future 메서드]] — `@future` 분리 패턴의 기반 문법·한계
- [[테스트 전략]] — `System.runAs` 일반 용법·테스트 데이터 전략
