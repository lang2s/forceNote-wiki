---
tags: [apex, security, crud, fls, pattern]
source: apex-recipes/CanTheUser.cls
created: 2026-05-17
aliases: [CanTheUser, CRUD 체크, FLS 체크]
---

# CanTheUser — CRUD/FLS 권한 확인

> `CanTheUser`는 현재 사용자의 CRUD/FLS 권한을 읽기 쉬운 API로 확인하는 유틸리티. `Schema.SObjectType.getDescribe()` 래퍼.

---

## 개념

Apex는 기본적으로 **시스템 컨텍스트(System Mode)**에서 실행된다. 즉, 코드를 실행하는 사용자의 Object/Field 권한과 무관하게 모든 레코드와 필드에 접근할 수 있다. 이는 자동화나 배치 처리에는 필요하지만, 사용자 요청을 처리하는 서비스 레이어에서는 **권한 초과 접근(privilege escalation)** 문제가 된다.

`CanTheUser`는 이 문제를 해결하기 위한 유틸리티다. 원시 Describe API(`getSObjectType().getDescribe().isCreateable()` 등)를 읽기 쉬운 메서드명으로 래핑해, 서비스 레이어에서 **DML 실행 전 권한을 명시적으로 확인**하는 early-return 패턴을 가능하게 한다.

### 언제 필요한가

`WITH USER_MODE`나 `insert as user`가 FLS/CRUD를 자동으로 적용한다면, 별도로 `CanTheUser`가 필요한 이유는 무엇인가?

- **사전 분기(early return)**: DML을 시도하기 전에 권한을 확인하고 의미 있는 오류 메시지나 HTTP 상태 코드를 반환해야 할 때
- **조건부 UI 렌더링**: 사용자의 권한에 따라 서버에서 다른 데이터 구조나 플래그를 내려보내야 할 때  
- **Custom Permission 확인**: 프로파일·권한 집합 기반이 아닌 커스텀 퍼미션 보유 여부를 체크할 때
- **테스트 가능성**: `WITH USER_MODE`는 쿼리 레벨에서 작동하지만, `CanTheUser`는 Boolean을 반환하므로 테스트에서 모킹이 더 용이함

### 제한사항 / 주의사항

- `getDescribe()` 호출은 **Apex Describe Call Limit**(일반적으로 동일 트랜잭션 내 실질적 제한 없음)에 포함되지만, 내부적으로 Schema 정보를 캐시하므로 성능 부담은 낮다
- `CanTheUser.flsEnabled()`는 필드의 **read 접근성(`isAccessible()`)** 을 확인한다. 쓰기 가능 여부는 `isUpdateable()` / `isCreateable()`이 별도로 필요하며, FLS 확인 후 실제 DML 접근 모드(`as user`)도 함께 적용해야 이중 보호가 된다
- **공유 규칙(Sharing Rules)은 확인하지 않는다.** `CanTheUser`는 Object/Field 수준(열) 권한만 다루며, 레코드 가시성(행)은 `with sharing` 키워드와 공유 규칙이 처리한다

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

`WITH USER_MODE`를 쓰면 FLS 위반 시 해당 필드가 쿼리 결과에서 자동으로 제거된다. 그러나 **DML 이전**에 권한을 확인하고 흐름을 제어해야 하는 상황에서는 `CanTheUser`가 필요하다. 예를 들어 REST Endpoint에서 권한 없는 사용자에게 403을 반환하거나, LWC 컴포넌트에 "편집" 버튼을 보여줄지를 서버 측에서 결정하는 경우다.

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
- [[Permission Set 설계]] — 권한 세트 설계와 런타임 CRUD/FLS 체크 연계

