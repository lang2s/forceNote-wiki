---
tags: [agent-skill, sf-skills, reference, platform, apex-test, test-data]
source: forcedotcom/sf-skills (skills/platform-apex-test-generate/references/test-data-factory.md, 공식 Salesforce)
created: 2026-06-27
aliases: [TestDataFactory Patterns, 테스트 데이터 팩토리, doInsert flag, duplicate rules, record type, field override]
---
# TestDataFactory Patterns — 테스트 데이터 팩토리 패턴

> TestDataFactory 설계 규칙(doInsert 플래그·중복 규칙 회피·벌크 위임)과 필드 오버라이드·레코드 타입·Duplicate Rule 처리 패턴.

For the base class template, see [assets/test-data-factory-template.cls](../assets/test-data-factory-template.cls).

## Design Rules

1. **Always accept a `doInsert` flag** — lets callers modify records before insert
2. **Append loop index to all fields that participate in matching rules** — prevents `DUPLICATES_DETECTED` errors from active Duplicate Rules
3. **Single-record methods delegate to bulk** — e.g., `createAccount(doInsert)` calls `createAccounts(1, doInsert)[0]`
4. **Return created records** — enables chaining and further manipulation
5. **Set all required fields** — include fields enforced by validation rules, not just schema-required fields

## Field Override Pattern

Allow callers to override default values without creating new factory methods:

```apex
public static Account createAccount(Map<String, Object> fieldOverrides, Boolean doInsert) {
    Account acc = new Account(
        Name = 'Test Account',
        Industry = 'Technology'
    );
    for (String fieldName : fieldOverrides.keySet()) {
        acc.put(fieldName, fieldOverrides.get(fieldName));
    }
    if (doInsert) insert acc;
    return acc;
}

// Usage:
Account acc = TestDataFactory.createAccount(new Map<String, Object>{
    'Name' => 'Custom Name',
    'Industry' => 'Healthcare'
}, true);
```

## Record Type Support

```apex
public static Account createAccountByRecordType(String recordTypeName, Boolean doInsert) {
    Id recordTypeId = Schema.SObjectType.Account
        .getRecordTypeInfosByDeveloperName()
        .get(recordTypeName)
        .getRecordTypeId();

    Account acc = new Account(
        Name = 'Test Account',
        RecordTypeId = recordTypeId
    );
    if (doInsert) insert acc;
    return acc;
}
```

## Handling Duplicate Rules

When unique field values alone are not sufficient, use `Database.insert()` with a `DuplicateRuleHeader`:

```apex
public static List<Account> createAccountsAllowDuplicates(Integer count, Boolean doInsert) {
    List<Account> accounts = new List<Account>();
    for (Integer i = 0; i < count; i++) {
        accounts.add(new Account(
            Name = 'Test Account ' + i,
            Phone = '555-000-' + String.valueOf(i).leftPad(4, '0')
        ));
    }
    if (doInsert) {
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;
        Database.insert(accounts, dml);
    }
    return accounts;
}
```

## 관련 노트
- [[platform-apex-test-generate]]
- [[async-testing]]
- [[assertion-patterns]]
