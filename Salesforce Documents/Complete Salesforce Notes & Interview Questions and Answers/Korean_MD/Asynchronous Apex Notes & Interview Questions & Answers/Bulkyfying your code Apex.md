---
tags: [apex, async, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Bulkyfying your code Apex]
---

# Apex 코드 벌크화

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## 1. 코드 벌크화
**이유:** 대량 데이터를 효과적으로 처리. **방법:** List·Set·Map 컬렉션 사용.
```apex
// 잘못된 예: 단일 레코드 처리
for (Account acc : Trigger.new) {
    acc.Name = acc.Name + '-Updated';
    update acc;
}
// 올바른 예: 벌크 처리
List<Account> accountsToUpdate = new List<Account>();
for (Account acc : Trigger.new) {
    acc.Name = acc.Name + '-Updated';
    accountsToUpdate.add(acc);
}
update accountsToUpdate;
```

## 2. 루프 안 SOQL/DML 회피
**이유:** 거버너 한도 초과 방지. **방법:** 루프 밖에서 쿼리, 컬렉션 사용.
```apex
// 잘못된 예: 루프 안 SOQL
for (Contact c : contacts) {
    Account acc = [SELECT Name FROM Account WHERE Id = :c.AccountId];
    acc.Name = 'Updated Name';
    update acc;
}
// 올바른 예: 루프 밖 SOQL
Map<Id, Account> accountsMap = new Map<Id, Account>(
    [SELECT Id, Name FROM Account WHERE Id IN :contactAccountIds]);
for (Contact c : contacts) {
    Account acc = accountsMap.get(c.AccountId);
    acc.Name = 'Updated Name';
}
update accountsMap.values();
```

## 3. 하드코딩 대신 Custom Metadata/Settings
**이유:** 코드를 동적·유지보수 용이하게. **방법:** 하드코딩 값을 구성 가능한 메타데이터로.
```apex
// 잘못된 예: 하드코딩
if (opp.StageName == 'Closed-Won') opp.Discount__c = 10;
// 올바른 예: Custom Metadata
List<Discount__mdt> discounts = [SELECT Stage__c, Discount__c FROM Discount__mdt];
for (Discount__mdt discount : discounts) {
    if (opp.StageName == discount.Stage__c) opp.Discount__c = discount.Discount__c;
}
```

## 4. 100% 커버리지 테스트 클래스
**이유:** 신뢰성 보장, 배포 오류 방지. **방법:** 벌크·긍정·부정·거버너 한도 케이스 테스트.
```apex
@IsTest
public class AccountTriggerTest {
    @IsTest
    static void testBulkAccounts() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 200; i++) accounts.add(new Account(Name = 'Test ' + i));
        insert accounts;
        Test.startTest();
        update accounts;
        Test.stopTest();
        System.assertEquals(200, [SELECT COUNT() FROM Account WHERE Name LIKE 'Test%']);
    }
}
```

## 5. 예외 우아하게 처리
**이유:** 런타임 오류 방지, 의미 있는 피드백. **방법:** try-catch.
```apex
try {
    insert new Account(Name = null);
} catch (DmlException e) {
    System.debug('Error: ' + e.getMessage());
}
```

## 6. Apex 디자인 패턴 사용
**이유:** 코드 구조·재사용성 개선. **예: 유틸리티 클래스의 Singleton 패턴**
```apex
public class MySingleton {
    private static MySingleton instance;
    private MySingleton() { }
    public static MySingleton getInstance() {
        if (instance == null) instance = new MySingleton();
        return instance;
    }
}
```

## 7. 공유 규칙 준수
**이유:** 데이터 보안·조직 공유 설정 준수. **방법:** with/without sharing 적절히 사용.
```apex
public with sharing class AccountController {
    public List<Account> getVisibleAccounts() {
        return [SELECT Id, Name FROM Account];
    }
}
```

## 8. 코드 문서화
**이유:** 타인(과 미래의 나)이 로직 이해. **방법:** 효과적인 주석.
```apex
// 각 Opportunity의 할인 계산
public static Decimal calculateDiscount(Opportunity opp) {
    // 메타데이터에서 할인율 조회
    ...
}
```
