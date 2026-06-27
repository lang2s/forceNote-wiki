---
tags: [agent-skill, sf-skills, reference, platform, data, cleanup]
source: forcedotcom/sf-skills (skills/platform-data-manage/references/cleanup-rollback-guide.md, 공식 Salesforce)
created: 2026-06-27
aliases: [Cleanup and Rollback Guide, 정리 및 롤백 가이드, Savepoint 롤백, 테스트 데이터 정리]
---

# Cleanup and Rollback Guide — 정리 및 롤백 가이드

> 테스트 데이터 격리·정리를 위한 Savepoint 롤백, 이름 패턴·날짜 기반 삭제, sf CLI 벌크 삭제 전략.

Strategies for test data isolation and cleanup.

## Savepoint/Rollback Pattern

Best for synchronous test isolation.

```apex
// Create savepoint BEFORE any DML
Savepoint sp = Database.setSavepoint();

try {
    // Create test data
    List<Account> accounts = TestDataFactory_Account.create(100);

    // Run your tests
    Test.startTest();
    MyClass.processAccounts(accounts);
    Test.stopTest();

    // Assert results
    System.assertEquals(expected, actual);

} finally {
    // Always rollback
    Database.rollback(sp);
}
```

**Limitations:**
- Does not roll back async operations
- Maximum 5 savepoints per transaction

## Cleanup by Name Pattern

```apex
String pattern = 'Test%';

DELETE [SELECT Id FROM Opportunity WHERE Name LIKE :pattern];
DELETE [SELECT Id FROM Contact WHERE LastName LIKE :pattern];
DELETE [SELECT Id FROM Account WHERE Name LIKE :pattern];
```

**Order matters:** Delete children before parents.

## Cleanup by Date

```apex
DateTime startTime = DateTime.now().addHours(-1);

DELETE [
    SELECT Id FROM Account
    WHERE CreatedDate >= :startTime
    AND Name LIKE 'Test%'
];
```

## Cleanup via sf CLI

```bash
# Export IDs to delete
sf data query \
  --query "SELECT Id FROM Account WHERE Name LIKE 'Test%'" \
  --target-org myorg \
  --result-format csv \
  > delete.csv

# Bulk delete
sf data delete bulk \
  --file delete.csv \
  --sobject Account \
  --target-org myorg \
  --wait 30
```

## Best Practices

1. **Track created IDs** - Store in Set<Id>
2. **Delete in order** - Children first, parents last
3. **Use test prefixes** - 'Test', 'BulkTest'
4. **Preview before delete** - Verify records first
5. **Use @isTest** - Auto-rollback in tests

## 관련 노트
- [[platform-data-manage]]
- [[cleanup-rollback-example]]
- [[test-data-best-practices]]
