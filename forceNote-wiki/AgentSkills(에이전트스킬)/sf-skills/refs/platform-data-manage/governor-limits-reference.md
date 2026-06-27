---
tags: [agent-skill, sf-skills, reference, platform, data, governor-limits]
source: forcedotcom/sf-skills (skills/platform-data-manage/references/governor-limits-reference.md, 공식 Salesforce)
created: 2026-06-27
aliases: [Governor Limits Reference, 거버너 한도 레퍼런스, SOQL DML 한도, Limits 모니터링]
---

# Governor Limits Reference — 거버너 한도 레퍼런스

> SOQL·DML·CPU·Heap·Bulk API의 동기/비동기 한도 표와 한도 내에서 작동하기 위한 모범 사례.

Essential limits for Salesforce data operations.

## SOQL Limits

| Limit | Synchronous | Asynchronous |
|-------|-------------|--------------|
| Total queries | 100 | 200 |
| Rows retrieved | 50,000 | 50,000 |
| QueryLocator rows | N/A | 50,000,000 |
| Query timeout | 120 seconds | 120 seconds |

## DML Limits

| Limit | Synchronous | Asynchronous |
|-------|-------------|--------------|
| DML statements | 150 | 150 |
| Rows processed | 10,000 | 10,000 |

## CPU and Memory

| Limit | Synchronous | Asynchronous |
|-------|-------------|--------------|
| CPU time | 10,000 ms | 60,000 ms |
| Heap size | 6 MB | 12 MB |

## Bulk API Limits

| Limit | Value |
|-------|-------|
| Batches per 24 hours | 10,000 |
| Records per 24 hours | 10,000,000 |
| Max file size | 100 MB |
| Concurrent jobs | 100 |

## Staying Within Limits

### SOQL Best Practices
```apex
// BAD: Query in loop
for (Account acc : accounts) {
    List<Contact> cons = [SELECT Id FROM Contact WHERE AccountId = :acc.Id];  // ❌
}

// GOOD: Single query with relationship
List<Account> accs = [
    SELECT Id, (SELECT Id FROM Contacts)
    FROM Account
    WHERE Id IN :accountIds
];  // ✓
```

### DML Best Practices
```apex
// BAD: DML in loop
for (Account acc : accounts) {
    update acc;  // ❌
}

// GOOD: Bulk DML
update accounts;  // ✓
```

## Monitoring Limits

```apex
System.debug('SOQL Queries: ' + Limits.getQueries() + '/' + Limits.getLimitQueries());
System.debug('DML Statements: ' + Limits.getDmlStatements() + '/' + Limits.getLimitDmlStatements());
System.debug('DML Rows: ' + Limits.getDmlRows() + '/' + Limits.getLimitDmlRows());
System.debug('CPU Time: ' + Limits.getCpuTime() + '/' + Limits.getLimitCpuTime());
System.debug('Heap Size: ' + Limits.getHeapSize() + '/' + Limits.getLimitHeapSize());
```

## 관련 노트
- [[platform-data-manage]]
- [[bulk-operations-guide]]
- [[anonymous-apex-guide]]
