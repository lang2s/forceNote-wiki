---
tags: [apex, org, sandbox, environment, pattern]
source: apex-recipes/OrgShape.cls
created: 2026-05-17
aliases: [OrgShape, 조직 환경 확인, Sandbox 확인]
---

# OrgShape — 조직 환경 정보

> `OrgShape`는 현재 Salesforce Org의 환경 정보(Sandbox/Production, Multi-Currency, Person Account 등)를 캡슐화하는 유틸리티.

---

## 주요 메서드

```apex
// Sandbox 여부
if (OrgShape.isSandbox()) {
    // 개발/테스트 환경 전용 로직
}

// 멀티 커런시 활성화 여부
if (OrgShape.isMultiCurrencyEnabled()) {
    // CurrencyIsoCode 필드 처리
}

// Person Account 활성화 여부
if (OrgShape.isPersonAccountEnabled()) {
    // IsPersonAccount 필드 처리
}

// 현재 API 버전
Decimal apiVersion = OrgShape.getApiVersion();
```

---

## 내부 구현

```apex
// isSandbox — Organization SObject 쿼리
public static Boolean isSandbox() {
    return [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
}

// 멀티 커런시 — Schema describe
public static Boolean isMultiCurrencyEnabled() {
    return UserInfo.isMultiCurrencyOrganization();
}

// Person Account — SObjectType describe
public static Boolean isPersonAccountEnabled() {
    return Schema.SObjectType.Account.fields.getMap()
        .containsKey('isPersonAccount');
}
```

---

## 활용 패턴

```apex
// 환경별 로그 레벨 조정
public void process() {
    if (OrgShape.isSandbox()) {
        Log.get().add('Sandbox 환경 — 상세 로깅 활성화', LogSeverity.DEBUG);
    }
    // 실제 로직...
}

// 멀티 커런시 조건 처리
public List<String> getFieldsToQuery() {
    List<String> fields = new List<String>{ 'Id', 'Name', 'Amount' };
    if (OrgShape.isMultiCurrencyEnabled()) {
        fields.add('CurrencyIsoCode');
    }
    return fields;
}
```

---

## 테스트에서의 주의

> [!warning] Organization SObject 조회
> `OrgShape.isSandbox()`는 `Organization` 레코드를 쿼리. `@isTest`에서는 실제 조직 정보가 반환되므로 테스트 환경에서의 결과는 조직 유형에 따라 다름.

---

## 관련 노트

- [[QuiddityGuard]]
- [[Log 싱글턴 패턴]]

