---
tags: [apex, security, crud, fls, pattern]
source: apex-recipes/CanTheUser.cls
created: 2026-05-17
aliases: [CanTheUser, CRUD 체크, FLS 체크, isAccessible, isCreateable, DescribeSObjectResult, DescribeFieldResult]
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

## 원시 Describe API — CRUD/FLS 직접 검사

`CanTheUser`는 결국 Apex의 **Schema Describe API** 위에 얹은 래퍼다. 커스텀 유틸리티 없이 CRUD/FLS를 직접 확인해야 할 때(또는 `CanTheUser`가 없는 org에서) 아래 원시 메서드를 쓴다. 모든 메서드는 `Schema.DescribeSObjectResult`·`Schema.DescribeFieldResult`의 인스턴스 메서드이며, 이름 그대로 현재 사용자 권한을 Boolean으로 돌려준다.

### Object 수준 — `Schema.DescribeSObjectResult`

`Account.SObjectType.getDescribe()` 또는 `describeSObjects()`가 반환하는 객체의 메서드다.

| 메서드 | 반환 의미 (현재 사용자 기준) |
|---|---|
| `isAccessible()` | 이 오브젝트를 **볼 수** 있으면 `true` |
| `isCreateable()` | 이 오브젝트를 **생성**할 수 있으면 `true` |
| `isUpdateable()` | 이 오브젝트를 **수정**할 수 있으면 `true` |
| `isDeletable()` | 이 오브젝트를 **삭제**할 수 있으면 `true` |
| `isUndeletable()` | 이 오브젝트를 **복원(undelete)**할 수 있으면 `true` |
| `isMergeable()` | 이 타입의 다른 레코드와 **병합(merge)**할 수 있으면 `true` (lead·contact·account에서 `true`) |
| `isQueryable()` | 이 오브젝트를 **SOQL 쿼리**할 수 있으면 `true` |
| `isSearchable()` | 이 오브젝트를 **SOSL 검색**할 수 있으면 `true` |

```apex
Schema.DescribeSObjectResult dsr = Account.SObjectType.getDescribe();
if (dsr.isCreateable() && dsr.isUpdateable()) {
    // Account에 대한 생성·수정 권한 보유
}

// 삭제 전 가드
if (!Contact.SObjectType.getDescribe().isDeletable()) {
    throw new AuraHandledException('삭제 권한이 없습니다.');
}
```

> [!note] `isAccessible()` 버전별 동작 변화
> API 54.0 이상에서는 **Custom Setting·Custom Metadata Type** 오브젝트에 대해, 사용자가 접근 권한이 없으면 `isAccessible()`이 `false`를 반환한다. API 53.0 이하에서는 권한이 없어도 `true`를 반환했다. (출처: Apex Reference Guide — DescribeSObjectResult Class)

### Field 수준 (FLS) — `Schema.DescribeFieldResult`

필드 토큰의 `getDescribe()`가 반환한다. FLS 검사의 핵심은 `isAccessible()`(읽기)·`isCreateable()`(입력)·`isUpdateable()`(수정) 세 가지다.

| 메서드 | 반환 의미 |
|---|---|
| `isAccessible()` | 이 필드를 **볼 수(read)** 있으면 `true` — FLS read |
| `isCreateable()` | 이 필드를 **생성 시 입력**할 수 있으면 `true` |
| `isUpdateable()` | 이 필드를 **수정**할 수 있으면 `true` (master-detail 재부모화 가능도 포함) |
| `isNillable()` | 필드가 **nillable**(빈 값 허용)이면 `true`. non-nillable이면 저장 시 값 필수 |
| `isPermissionable()` | 이 필드에 대해 **필드 권한을 지정할 수 있으면** `true` |
| `isCalculated()` | **커스텀 수식(formula) 필드**면 `true` (수식 필드는 항상 read-only) |
| `isEncrypted()` | **Shield Platform Encryption**으로 암호화된 필드면 `true` |
| `getType()` | 필드 타입에 해당하는 **`Schema.DisplayType`** enum 값 반환 |

```apex
Schema.DescribeFieldResult dfr =
    Account.SObjectType.getDescribe().fields.getMap()
           .get('AnnualRevenue').getDescribe();

if (dfr.isUpdateable()) {
    acct.AnnualRevenue = newValue;   // 쓰기 FLS 통과 시에만 대입
}

// 필드 토큰에서 직접 (더 짧은 관용구)
if (Schema.SObjectType.Account.fields.AnnualRevenue.isAccessible()) {
    // 읽기 FLS OK
}
```

### 획득 경로 — describe 토큰 얻는 3가지 관용구

```apex
// (1) 오브젝트 이름을 정적으로 아는 경우 — SObjectType 토큰에서
Schema.DescribeSObjectResult d1 = Account.SObjectType.getDescribe();
Schema.DescribeSObjectResult d2 = Schema.SObjectType.Account;   // 프로퍼티 접근도 가능

// (2) SObject 인스턴스에서 (CanTheUser 래퍼가 쓰는 방식)
SObject rec = new Account();
Schema.DescribeSObjectResult d3 = rec.getSObjectType().getDescribe();

// (3) 오브젝트 이름이 런타임 문자열일 때 — Schema.getGlobalDescribe()
Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
Schema.DescribeSObjectResult d4 = gd.get('Account').getDescribe();
```

- `getSObjectType()`는 `SObject`·`DescribeSObjectResult` 양쪽에 있어, 인스턴스 → 토큰 → describe로 이어지는 관용구(`obj.getSObjectType().getDescribe()`)가 `CanTheUser.create()` 내부와 정확히 같다.
- 필드 맵은 `describe.fields.getMap()` → `Map<String, Schema.SObjectField>`. 각 `SObjectField` 토큰의 `getDescribe()`가 `DescribeFieldResult`를 준다.
- **로드 옵션:** `getDescribe(SObjectDescribeOptions.FULL)`은 child relationship까지 eager-load, `DEFERRED`는 lazy-load(첫 사용 시 로드). CRUD/FLS 플래그만 필요하면 기본값으로 충분하다.

> [!tip] describe 호출 비용과 캐싱
> `getDescribe()` 결과는 트랜잭션 내에서 캐시되므로 같은 오브젝트를 반복 describe해도 부담이 크지 않다. (예전에는 트랜잭션당 누적 describe 호출 한도가 있었으나 현재는 실질적으로 완화됨.) 그럼에도 루프 안에서 반복 호출하지 말고 **한 번 describe해 변수/맵에 담아** 재사용하는 것이 관용이다. `CanTheUser`가 정적 캐시를 두는 이유가 이것이다.

### CanTheUser 래퍼와의 관계

`CanTheUser`의 각 메서드는 위 원시 API를 1:1로 감싼 것이다.

| CanTheUser | 감싸는 원시 호출 |
|---|---|
| `CanTheUser.create(obj)` | `obj.getSObjectType().getDescribe().isCreateable()` |
| `CanTheUser.read(obj)` | `...getDescribe().isAccessible()` |
| `CanTheUser.edit(obj)` | `...getDescribe().isUpdateable()` |
| `CanTheUser.destroy(obj)` | `...getDescribe().isDeletable()` |
| `CanTheUser.flsEnabled(obj, field)` | `...fields.getMap().get(field).getDescribe().isAccessible()` |

래퍼는 여기에 **읽기 쉬운 이름 + describe 결과 캐시**를 더한다. 원시 API는 `isMergeable()`·`isUndeletable()`·`isQueryable()` 같은 래퍼에 없는 검사나, FLS의 `isCreateable()`/`isUpdateable()`(쓰기 FLS)까지 세분해 확인할 때 직접 쓴다.

---

## 관련 노트

- [[Safely]]
- [[StripInaccessible]]
- [[WITH USER_MODE]]
- [[Custom REST Endpoint]] — 삭제 권한 체크 예시
- [[SOAP Web Services 노출 (webservice 키워드)]] — 인바운드 SOAP 요청 CRUD/FLS 체크
- [[Permission Set 설계]] — 권한 세트 설계와 런타임 CRUD/FLS 체크 연계
- [[권한과 접근 제어 위협]] — CRUD/FLS·공유 우회 위협 모델 (CanTheUser가 방어하는 대상)
- [[platform-permission-set-generate]] (sf-skill — 실행형) — 런타임 CRUD/FLS 체크 대상 권한 세트를 생성하는 실행형 스킬

