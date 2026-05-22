---
tags: [sobject-reference, custom-objects, custom-metadata, mdt, managed-package, apex]
source: object_reference.pdf pp.122-124 (v67.0 Summer '26)
created: 2026-05-22
aliases: [Custom Metadata Type, __mdt, 커스텀 메타데이터, 메타데이터 타입, Custom Metadata Record, isProtected]
---

# Custom Metadata Type `__mdt`

> 커스텀 메타데이터 레코드를 나타내는 Object — API v34.0+. DML 없이 SOQL/retrieve로만 읽는 설정 저장소.

---

## 개요

Object 이름은 `CustomMetadataType__mdt` 형식이다. 예를 들어 `PicklistUsage` 커스텀 메타데이터 타입에 기반한 레코드는 `PicklistUsage__mdt`로 참조한다.

```
Custom Metadata Type__mdt 형식
예: PicklistUsage__mdt, MyConfig__mdt
```

**지원 호출**: `describeSObjects()`, `describeLayout()`, `query()`, `retrieve()`

> [!note] 배포(Deploy)와 패키지로만 레코드를 관리한다. API에서는 읽기 전용 — `create()`, `update()`, `delete()`, `upsert()` 없음.

---

## 필드 참조표

| 필드 | 타입 | 속성 | 설명 |
|---|---|---|---|
| `Custom Field__c` | Any Type | Filter, Group, Nillable, Sort | 레코드의 커스텀 필드 값 |
| `DeveloperName` | string | Defaulted on create, Filter, Group, Sort | API 이름. 영문자·숫자·언더스코어만 허용. 공백·연속 언더스코어·끝 언더스코어 불가. 관리 패키지에서 명칭 변경 가능 |
| `isProtected` | boolean | Defaulted on create, Filter, Group, Sort | 보호 여부. 관리 패키지 릴리즈 시 접근을 제한. `true`이면 같은 패키지 코드만 읽기 가능 |
| `Label` | picklist | Filter, Group, Nillable, Sort | 레코드 레이블. 항상 MasterLabel과 동일 |
| `Language` | string | Filter, Group, restrictedPicklist, Sort | 레코드 언어. 항상 개발 Org의 기본 언어 |
| `MasterLabel` | string | Filter, Group, Sort | 기본 레이블 |
| `NamespacePrefix` | string | Filter, Group, Nillable, Sort | 네임스페이스 접두사. 최대 15자. 관리 패키지의 컴포넌트는 `namespacePrefix__componentName`으로 참조 |
| `QualifiedApiName` | string | Filter, Group, Nillable, Sort | `NamespacePrefix__DeveloperName` 형식 연결 |
| `SystemModStamp` | dateTime | Defaulted on create, Filter, Sort | 트리거·자동화 포함 마지막 수정 일시. API v56.0+ |

---

## `isProtected` 동작 규칙

관리 패키지에서 릴리즈된 커스텀 메타데이터 레코드에 대한 접근 제어.

```
접근 가능:
  · 같은 관리 패키지 내 코드 (레코드와 같은 패키지)
  · 같은 관리 패키지 내 타입 코드 (타입과 같은 패키지)

접근 불가:
  · 해당 타입이나 보호 레코드를 포함하지 않는 다른 관리 패키지 코드
  · 구독자가 작성한 코드
  · 비관리 패키지 코드

추가 규칙:
  · 보호 레코드는 REST·SOAP·SOQL·Setup에서도 동일하게 숨겨짐
  · 개발자는 패키지 업그레이드로만 보호 레코드 수정 가능
  · 구독자는 보호 레코드를 읽거나 수정할 수 없음
  · 보호 레코드의 DeveloperName은 릴리즈 후 변경 불가
```

---

## 사용 패턴

### SOQL 조회

```apex
// 활성화된 커스텀 메타데이터 전수 조회
List<MyConfig__mdt> configs = [
    SELECT DeveloperName, MasterLabel, IsActive__c, Value__c
    FROM MyConfig__mdt
    WHERE IsActive__c = true
];

// QualifiedApiName으로 특정 레코드 조회 (Apex 인스턴스 메서드)
MyConfig__mdt config = MyConfig__mdt.getInstance('MyRecord');

// NamespacePrefix 포함 QualifiedApiName 조회
MyConfig__mdt nsConfig = [
    SELECT QualifiedApiName, MasterLabel, NamespacePrefix
    FROM MyConfig__mdt
    WHERE QualifiedApiName = 'MyNamespace__MyRecord'
    LIMIT 1
];
```

### 관리 패키지에서 isProtected 설정

```apex
// 보호 레코드 조회 시도 — 같은 패키지 코드에서만 성공
List<ProtectedConfig__mdt> records = [
    SELECT DeveloperName, MasterLabel
    FROM ProtectedConfig__mdt
    // isProtected = true인 레코드는 같은 패키지 코드에서만 반환됨
];
```

---

## 제약 사항

- `create()`, `update()`, `delete()`, `upsert()` 호출 불가 — 배포 전용
- DML로 레코드 생성·수정 불가. Metadata API Deploy나 Setup UI 또는 패키지를 통해서만 관리
- `SystemModStamp` 필드는 API v56.0 이상에서만 사용 가능

---

## 관련 노트

- [[4 Custom Objects]] — Custom Metadata·Custom Object·Custom Feed 개요 (부모 챕터)
- [[Custom Objects]] — __c 네이밍·Audit Fields·Managed Package prefix
- [[Custom Fields]] — External ID·Uniqueness·Default Values
- [[Custom Object Standard Fields (__c)]] — __c 표준 필드 참조표 (동일 챕터 형제 Object)
- [[Custom Object Feed (__Feed)]] — __Feed 표준 필드 참조표 (동일 챕터 형제 Object)
- [[API Field Properties]] — Filter·Group·Sort 등 필드 속성 정의
- [[System Fields]] — SystemModStamp·CreatedDate 등 시스템 필드 상세
