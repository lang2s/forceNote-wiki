---
tags: [apex, testing, test-data, factory, testsetup, loaddata, seealldata]
source: salesforce_apex_developer_guide.pdf
created: 2026-07-08
aliases: [Test Data Factory, 테스트 데이터 팩토리, TestDataFactory, createTestRecords, TestSetup, Test.loadData, 테스트 데이터 생성]
---

# Test Data Factory 패턴

> 테스트마다 데이터 생성 코드를 복붙하지 않고, 재사용 가능한 팩토리 클래스·@TestSetup·Test.loadData로 결정적(deterministic) 테스트 데이터를 한 곳에서 만든다.

---

## 개념 — 왜 팩토리인가

Apex 테스트는 배포 시 **코드 커버리지 75%**를 요구하고, 그 검증을 위해 거의 모든 테스트가 데이터를 필요로 한다. 각 테스트 메서드마다 `insert new Account(...)`를 반복하면 세 가지 문제가 생긴다.

| 문제 | 팩토리로 해결 |
|---|---|
| **중복** — 같은 데이터 생성 코드가 수십 개 테스트에 흩어짐 | create* 메서드 하나로 집약 |
| **유지보수** — 새 필수 필드(required field)나 validation rule이 생기면 모든 테스트가 깨짐 | 팩토리 한 곳만 고치면 전체 반영 |
| **격리(isolation)** — org 데이터에 의존하면 조직마다 다르게 실패 | 테스트가 쓸 데이터를 스스로 생성 → 어느 org에서든 동일 |

핵심 원칙은 **`SeeAllData=false`(기본값, API 24.0+)** 이다. 테스트는 org의 기존 레코드를 보지 못하고 **자기가 만든 데이터만** 본다. 따라서 데이터를 "가정"하지 말고 "생성"해야 하며, 팩토리는 그 생성을 표준화한다. (data silo 상세·SeeAllData 오버라이드 규칙은 [[테스트 전략]] 참조.)

> [!warning] data silo에서 record Id를 공유하지 말 것
> 공식 문서 권고: data silo 테스트에서는 **테스트 데이터와 org 데이터가 record Id를 공유하지 않도록** 한다(하드코딩 Id로 org 레코드에 접근 시도 금지). 또한 data silo에서는 `Owner` 관계를 통한 cross-object 필드 참조가 지원되지 않는다 — 예: `SELECT Owner.IsActive FROM Account`는 data silo 테스트에서 `null`을 반환한다.

---

## 패턴 1 — 재사용 팩토리 클래스 (`@IsTest` 유틸리티)

**공용 테스트 유틸리티 클래스**는 `@IsTest`로 선언한 public 클래스로, 데이터 생성 코드를 재사용한다. `@IsTest`를 붙이면 **조직 코드 크기 한도(org code size limit)에서 제외**되고 테스트 컨텍스트에서 실행된다. 메서드는 다른 테스트 클래스에서 보이도록 **`public` 또는 `global`** 이어야 하며, **테스트 메서드(또는 테스트가 호출한 코드)만** 호출할 수 있다(비테스트 코드는 호출 불가).

```apex
// 공식 문서 발췌 (Apex Developer Guide) — Common Test Utility Class
@IsTest
public class TestDataFactory {
    public static void createTestRecords(Integer numAccts, Integer numContactsPerAcct) {
        List<Account> accts = new List<Account>();

        for(Integer i=0;i<numAccts;i++) {
            Account a = new Account(Name='TestAccount' + i);
            accts.add(a);
        }
        insert accts;

        List<Contact> cons = new List<Contact>();
        for (Integer j=0;j<numAccts;j++) {
            Account acct = accts[j];
            // For each account just inserted, add contacts
            for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
                cons.add(new Contact(firstname='Test'+k,
                                     lastname='Test'+k,
                                     AccountId=acct.Id));
            }
        }
        // Insert all contacts for all accounts
        insert cons;
    }
}
```

호출하는 테스트 메서드 — 계정 5개 × 연락처 3개를 한 줄로 생성:

```apex
// 공식 문서 발췌
@IsTest
private class MyTestClass {
    static testmethod void test1() {
        TestDataFactory.createTestRecords(5,3);
        // Run some tests
    }
}
```

> `@IsTest` 클래스는 interface나 enum이 될 수 없다. 공용 메서드를 `@IsTest` 없이 일반 클래스에 두면 조직 코드 크기 한도 제외 혜택을 받지 못한다.

### 팩토리 설계 — 필수필드 기본값·오버로드·벌크

실무 팩토리는 위 골격에 **필수필드 기본값**(빠뜨리면 required-field 오류로 전 테스트가 깨짐), **오버로드**(간단/상세 시그니처), **벌크 생성 헬퍼**(200건 이상 테스트용), **RecordType·다형(polymorphic) 처리**를 얹는다. 아래는 그 확장 골격이다.

```apex
// 구조 예시 — 실제 동작 코드 아님 (공식 골격에 필수필드·오버로드·RecordType·벌크를 확장한 설계 예)
@IsTest
public class OpportunityTestFactory {

    // (1) 필수필드 기본값 — 호출부는 이름만 넘기면 됨. StageName·CloseDate는 Opportunity 필수필드.
    public static Opportunity buildOpp(String name) {
        return new Opportunity(
            Name      = name,
            StageName = 'Prospecting',                 // 필수: 유효한 stage
            CloseDate = Date.today().addDays(30)       // 필수
        );
    }

    // (2) 오버로드 — 상위 Account와 금액까지 지정하는 상세 시그니처
    public static Opportunity buildOpp(String name, Id accountId, Decimal amount) {
        Opportunity o = buildOpp(name);
        o.AccountId = accountId;
        o.Amount    = amount;
        return o;
    }

    // (3) 벌크 생성 — 200건 테스트용. insert는 호출부에서 1회(DML limit 절약)
    public static List<Opportunity> buildOpps(Integer count, Id accountId) {
        List<Opportunity> opps = new List<Opportunity>();
        for (Integer i = 0; i < count; i++) {
            opps.add(buildOpp('BulkOpp ' + i, accountId, 1000));
        }
        return opps;
    }

    // (4) RecordType — data silo에서 RecordType은 metadata 오브젝트라 조회 가능(생성 불필요)
    public static Id recordTypeId(String developerName) {
        return [SELECT Id FROM RecordType
                WHERE SObjectType = 'Opportunity'
                  AND DeveloperName = :developerName
                LIMIT 1].Id;
    }

    // (4') 다형(polymorphic) 관계 — Task.WhatId는 Account·Opportunity 등 여러 부모를 가리킴
    public static Task buildTask(Id whatId) {
        return new Task(Subject = 'Follow up', WhatId = whatId);
    }
}
```

> [!tip] build vs create 관례
> - `build*` (또는 `make*`) = 메모리에 sObject를 만들되 **insert 안 함** → 호출부가 필드를 더 세팅하거나 여러 종류를 모아 **한 번에 벌크 insert**(DML limit 절약).
> - `create*` = 만들고 **insert까지** → 호출부는 바로 쿼리·검증.
> 둘을 나누면 "200건 벌크 insert 1회"와 "곧바로 쓸 레코드" 두 요구를 모두 만족한다.

---

## 패턴 2 — `@TestSetup` (클래스당 1회 공유 데이터)

`@testSetup` 메서드는 **인자 없음·반환 없음**이며, 테스트 프레임워크가 **클래스의 어떤 테스트 메서드보다 먼저** 1회 실행한다. 여기서 만든 레코드는 모든 테스트 메서드에서 접근 가능하고, **클래스 전체 실행이 끝날 때** 롤백된다. 어떤 테스트가 그 레코드를 수정·삭제해도 그 변경은 **그 메서드 종료 시 롤백**되어, 다음 테스트는 원래 상태를 다시 받는다.

```apex
// 공식 문서 발췌 — @testSetup으로 1회 생성 후 각 테스트가 원본 상태를 공유
@isTest
private class CommonTestSetup {
    @testSetup static void setup() {
        // Create common test accounts
        List<Account> testAccts = new List<Account>();
        for(Integer i=0;i<2;i++) {
            testAccts.add(new Account(Name = 'TestAcct'+i));
        }
        insert testAccts;
    }
    @isTest static void testMethod1() {
        Account acct = [SELECT Id FROM Account WHERE Name='TestAcct0' LIMIT 1];
        acct.Phone = '555-1212';
        update acct;                 // 이 변경은 이 메서드에만 국한
        Account acct2 = [SELECT Id FROM Account WHERE Name='TestAcct1' LIMIT 1];
        delete acct2;                // 이 삭제도 이 메서드에만 국한
    }
    @isTest static void testMethod2() {
        // testMethod1()의 변경은 롤백되어 여기서 보이지 않음
        Account acct = [SELECT Phone FROM Account WHERE Name='TestAcct0' LIMIT 1];
        System.assertEquals(null, acct.Phone);   // Phone 변경이 롤백됨
        Account acct2 = [SELECT Id FROM Account WHERE Name='TestAcct1' LIMIT 1];
        System.assertNotEquals(null, acct2);     // 삭제도 롤백됨
    }
}
```

**팩토리 + @TestSetup 결합** — 팩토리로 데이터를 만들고 `@TestSetup`에서 1회 호출하는 것이 가장 흔한 조합이다.

```apex
// 구조 예시 — 실제 동작 코드 아님 (패턴 1 팩토리를 @TestSetup에서 호출)
@isTest
private class OpportunityServiceTest {
    @testSetup static void makeData() {
        Account a = new Account(Name = 'Factory Acct');
        insert a;
        insert OpportunityTestFactory.buildOpps(5, a.Id);   // 팩토리 재사용
    }
    @isTest static void testProcessing() {
        List<Opportunity> opps = [SELECT Id, StageName FROM Opportunity];
        System.assertEquals(5, opps.size());
        // ... 테스트 대상 로직 검증
    }
}
```

### @TestSetup 고려사항 (공식)

- **기본 격리 모드에서만 지원** — 클래스나 메서드가 `@isTest(SeeAllData=true)`이면 test setup 메서드는 지원되지 않는다(API 24.0+ 에서만 가능).
- **클래스당 test setup 메서드는 1개만.**
- test setup 실행 중 **치명적 오류**(DML 예외·assertion 실패)가 나면 **클래스 전체가 실패**하고 이후 테스트가 실행되지 않는다.
- test setup이 **다른 클래스의 비테스트 메서드**를 호출하면 그 메서드는 코드 커버리지가 계산되지 않는다.
- static 변수를 test setup에서 만들고 테스트 메서드에서 바꿔도 그 변경은 다음 메서드로 **전파되지 않는다**(매 메서드가 별도 트랜잭션, static 컨텍스트 재초기화).

> [!tip] 성능
> 레코드가 많을수록 `@TestSetup`이 유리하다. 클래스당 1회 생성 → 각 메서드마다 재생성하지 않고, 롤백도 클래스 종료 시 1회라 시스템 자원 사용이 효율적이다.

---

## 패턴 3 — `Test.loadData` + 정적 리소스 CSV

코드가 아니라 **CSV 파일**로 데이터를 정의하고 싶을 때 사용한다. 절차:

1. 데이터를 **`.csv` 파일**에 넣는다(첫 줄 = 필드명, 이후 줄 = 값).
2. 그 파일로 **정적 리소스(static resource)** 를 만든다.
3. 테스트 메서드에서 `Test.loadData`에 **sObject 타입 토큰**과 **정적 리소스 이름**을 넘겨 호출한다.

```apex
List<sObject> ls = Test.loadData(Account.sObjectType, 'myResource');
```

`Test.loadData`는 **삽입된 각 레코드에 대응하는 sObject 리스트**를 반환한다. 정적 리소스는 이 메서드 호출 **전에** 만들어야 하며, 확장자 `.csv`인 콤마 구분 파일이다. 지원 MIME 타입: **`text/csv` · `application/vnd.ms-excel` · `application/octet-stream` · `text/plain`**.

CSV 예 (계정 3건):

```csv
Name,Website,Phone,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry
sForceTest1,http://www.sforcetest1.com,(415) 901-7000,The Landmark @ One Market,San Francisco,CA,94105,US
sForceTest2,http://www.sforcetest2.com,(415) 901-7000,The Landmark @ One Market Suite 300,San Francisco,CA,94105,US
sForceTest3,http://www.sforcetest3.com,(415) 901-7000,1 Market St,San Francisco,CA,94105,US
```

호출 (정적 리소스 이름 `testAccounts`):

```apex
// 공식 문서 발췌
@isTest
private class DataUtil {
    static testmethod void testLoadData() {
        // Load the test accounts from the static resource
        List<sObject> ls = Test.loadData(Account.sObjectType, 'testAccounts');
        // Verify that all 3 test accounts were created
        System.assert(ls.size() == 3);
        // Get first test account
        Account a1 = (Account)ls[0];
        String acctName = a1.Name;
        System.debug(acctName);
    }
}
```

> [!tip] 언제 CSV 방식인가
> 필드가 많고 값이 고정된 **대량 참조 데이터**(예: 국가·요율·제품 카탈로그)에 적합하다. 관계(부모 Id)는 CSV로 표현하기 어려우므로, 관계가 복잡한 데이터는 코드 팩토리(패턴 1)가 낫다.

---

## 관계·필수필드·RecordType·다형 처리

data silo 테스트에서 데이터를 만들 때 자주 막히는 지점:

| 상황 | 처리 |
|---|---|
| **필수필드(required field)** | 팩토리에서 항상 기본값을 채운다(예: Opportunity의 `StageName`·`CloseDate`). 누락 시 required-field 오류로 전 테스트가 깨짐 |
| **부모 관계(lookup/master-detail)** | 부모를 먼저 insert → 반환된 `Id`를 자식 필드에 세팅(위 Account→Contact 예처럼) |
| **RecordType** | `RecordType`은 metadata 오브젝트라 data silo에서도 **SOQL 조회 가능**(생성 불필요). `DeveloperName`으로 `Id`를 얻어 세팅 |
| **다형(polymorphic) 관계** | `Task.WhatId`/`Event.WhatId`처럼 여러 부모를 가리키는 필드는 대상 부모를 먼저 만들고 그 `Id`를 넣는다 |
| **일부 표준 오브젝트는 생성 불가** | Object Reference 참고. 생성 불가·커밋 후에만 생기는 레코드(Chatter `FeedTrackedChange`, 필드 히스토리 `AccountHistory` 등)는 테스트에서 만들 수 없음 |
| **unique 제약 충돌** | 같은 이름의 `CollaborationGroup` 등 unique 필드를 가진 sObject 중복 insert 시 오류(SeeAllData 여부와 무관) |
| **Mixed DML** | `User`·`PermissionSet` 등 setup 오브젝트와 일반 오브젝트를 한 트랜잭션에서 insert하면 오류 → 블록 분리 필요(System.runAs 테스트 실행 컨텍스트 참조) |

---

## 팩토리 안티패턴 (피할 것)

| ❌ 안티패턴 | 문제 | ✅ 대안 |
|---|---|---|
| **하드코딩 record Id** (`'001xx000003DGb2'`) | org마다 Id가 다름 → 다른 org·배포에서 즉시 실패. data silo에선 애초에 그 레코드가 안 보임 | 테스트 안에서 부모를 insert하고 반환된 `Id` 사용 |
| **`@isTest(SeeAllData=true)`로 org 데이터 의존** | 특정 레코드 존재를 가정 → 그 데이터가 없는 조직에서 실패, `@TestSetup` 사용 불가, `IsParallel=true` 병용 불가 | 팩토리·`@TestSetup`으로 필요한 데이터를 직접 생성 |
| **각 테스트마다 데이터 생성 코드 복붙** | 필수필드 추가 시 전 테스트가 동시에 깨짐 | create* 팩토리 한 곳에 집약 |
| **팩토리에서 필수필드 누락** | 호출부마다 required-field 오류를 따로 처리 | 팩토리가 안전한 기본값을 채움 |
| **루프 안에서 insert** | DML statement governor limit 소진 | 리스트에 모아 루프 밖 1회 insert(벌크) |

> data silo(`SeeAllData=false`)를 유지하는 것이 팩토리 패턴의 존재 이유다 — 어떤 org에서든 동일한 데이터로 **결정적**으로 실행되고, 배포 시에도 깨지지 않는다.

---

## 세 방식 선택 기준

| | 재사용 팩토리 클래스 | `@TestSetup` | `Test.loadData` (CSV) |
|---|---|---|---|
| 정의 위치 | `@IsTest` public 클래스 | 테스트 클래스 내 1개 메서드 | 정적 리소스 `.csv` |
| 재사용 범위 | 모든 테스트 클래스 | **한 클래스 내** 모든 메서드 | 모든 테스트(리소스 참조) |
| 관계·로직 표현 | 강함(코드) | 강함(코드) | 약함(평면 CSV) |
| 대량 고정 데이터 | 보통 | 보통 | 강함 |
| 조합 | @TestSetup에서 호출해 결합 | 팩토리를 호출해 채움 | 팩토리 대신/보완 |

실무 조합: **팩토리 클래스**로 생성 로직을 표준화 → **`@TestSetup`** 에서 1회 호출해 클래스 공유 → 대량 참조 데이터만 **`Test.loadData`**.

---

## 관련 노트

- [[테스트 전략]] — data silo·SeeAllData 오버라이드 규칙, Test.startTest/stopTest, 모킹 전략 전반
- [[System.runAs (테스트 실행 컨텍스트)]] — Mixed DML 우회·권한 컨텍스트에서의 테스트 데이터 생성
- [[Apex MOC]]
