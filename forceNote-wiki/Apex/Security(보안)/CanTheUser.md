---
tags: [apex, security, crud, fls, pattern]
source: apex-recipes/CanTheUser.cls
created: 2026-05-17
aliases: [CanTheUser, CRUD 체크, FLS 체크]
---

# CanTheUser — CRUD/FLS 권한 확인

> `CanTheUser`는 현재 사용자의 CRUD/FLS 권한을 읽기 쉬운 API로 확인하는 유틸리티. `Schema.SObjectType.getDescribe()` 래퍼.

---

## CRUD 확인 메서드

```apex
// 생성 권한
if (CanTheUser.create(new Account())) { ... }

// 읽기 권한
if (CanTheUser.read(new Account())) { ... }

// 수정 권한
if (CanTheUser.edit(new Account())) { ... }

// 삭제 권한
if (CanTheUser.destroy(new Account())) { ... }
```

---

## FLS 확인 (필드 수준)

```apex
// 단일 필드
if (CanTheUser.flsEnabled(new Account(), 'BillingCity')) { ... }

// 여러 필드
if (CanTheUser.flsEnabled(new Account(), new List<String>{ 'Name', 'Phone', 'BillingCity' })) { ... }

// 또는 직접 SOQL WITH USER_MODE로 대체 가능
[SELECT Id, BillingCity FROM Account WITH USER_MODE]
```

---

## Custom Permission 확인

```apex
// 커스텀 퍼미션 보유 여부
if (CanTheUser.has(new Permissions__c())) { ... }

// 또는 내장 API 사용
if (FeatureManagement.checkPermission('Admin_Tools')) { ... }
```

---

## 언제 CRUD/FLS를 명시적으로 확인하나?

> [!tip] WITH USER_MODE와 역할 분담
> 대부분의 SOQL은 `WITH USER_MODE`로 충분. `CanTheUser`는 **사전 검사(early return)** 나 **조건 분기**가 필요할 때 사용.

```apex
// 패턴: 삭제 권한 없으면 403 반환 (Custom REST Endpoint)
if (!CanTheUser.destroy(new Contact())) {
    RestContext.response.statusCode = 403;
    return 'Permission denied';
}

// 패턴: 권한에 따라 다른 UI 제공
Boolean canEdit = CanTheUser.edit(new Opportunity());
```

---

## 내부 구현 원리

```apex
// CanTheUser.create 내부
public static Boolean create(SObject obj) {
    return obj.getSObjectType().getDescribe().isCreateable();
}

// CanTheUser.flsEnabled 내부
public static Boolean flsEnabled(SObject obj, String field) {
    return obj.getSObjectType()
              .getDescribe()
              .fields.getMap()
              .get(field)
              .getDescribe()
              .isAccessible();
}
```

---

## 관련 노트

- [[Safely]]
- [[StripInaccessible]]
- [[WITH USER_MODE]]
- [[Custom REST Endpoint]] — 삭제 권한 체크 예시

