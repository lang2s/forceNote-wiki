---
tags: [SOQL, Metadata, EntityDefinition, FieldDefinition, ToolingAPI, Schema, Introspection]
source: apex-recipes-main/force-app/main/default/classes/Data Recipes/MetadataCatalogRecipes.cls (실전 예시) + developer.salesforce.com/docs/atlas.en-us.api_tooling.meta/api_tooling/tooling_api_objects_entitydefinition.htm · tooling_api_objects_fielddefinition.htm (레퍼런스)
created: 2026-07-04
aliases: [Metadata Catalog SOQL, EntityDefinition, FieldDefinition, 메타데이터 카탈로그, 스키마 인트로스펙션, SOQL로 스키마 조회, QualifiedApiName, IsCalculated, RelationshipName]
---

# 메타데이터 카탈로그 SOQL — EntityDefinition · FieldDefinition

> 오브젝트·필드의 스키마를 `Schema.describe*` 대신 **SOQL 쿼리**로 인트로스펙션한다. 대형·복잡한 조직에서 describe보다 빠르고, `WHERE`·서브쿼리·집계로 "포뮬러 필드 전부", "Account를 룩업하는 필드" 같은 스키마 질문을 선언적으로 던질 수 있다.

---

## 왜 이 기술인가 — describe vs 메타데이터 카탈로그

Apex의 `Schema.getGlobalDescribe()` / `SObjectType.getDescribe().fields.getMap()` 은 조직의 **모든** 오브젝트·필드를 힙에 로드한다. 오브젝트가 수천 개인 대형 조직에서는 느리고 힙 한도를 압박한다. **메타데이터 카탈로그**(EntityDefinition·FieldDefinition 등)는 스키마를 **가상 SObject 행**으로 노출하므로, `WHERE`로 필요한 부분만 골라 쿼리한다 — DB가 필터링을 대신 해 주므로 대형 조직일수록 유리하다.

apex-recipes의 클래스 설명이 이 트레이드오프를 명시한다:
> *"Demonstrates how to query the Metadata Catalog. This is sometimes faster than Schema Describe calls especially for large complex orgs."*

| 관점 | `Schema.describe*` | 메타데이터 카탈로그 SOQL |
|---|---|---|
| 접근 방식 | 명령형 — Map 전체 로드 후 순회 | 선언형 — SOQL `WHERE`/서브쿼리/집계 |
| 대형 조직 성능 | 전수 로드로 느림·힙 압박 | 필요한 행만 → 빠름 |
| 필터링 | Apex 루프에서 직접 | DB가 처리 |
| 반환 위치 | 힙(메모리) | SOQL 결과(쿼리 로우 한도 적용) |
| 세션 한도 | 힙 사이즈 | SOQL 쿼리 수·로우 수 |
| 접근 가능 메타데이터 | describe가 노출하는 것 | 카탈로그 오브젝트가 노출하는 것(+ Tooling으로 Metadata 필드) |
| 실시간성 | 항상 최신 | 대부분 최신(일부 Durable ID 릴리즈 간 변동) |

> 카탈로그가 describe를 완전 대체하진 않는다 — describe만 주는 정보(예: 픽리스트 엔트리 전량, 계산된 접근성)도 있다. **스키마를 "쿼리"하고 싶을 때** 카탈로그를 쓴다.

---

## EntityDefinition — 오브젝트 메타데이터 (API v32.0+)

표준·커스텀 오브젝트 하나당 1행. 일반 Apex SOQL에서 바로 쿼리 가능(단 `Metadata`·`FullName` 필드는 Tooling API 한정).

### 핵심 식별 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `QualifiedApiName` | string | 네임스페이스+개발자명 결합. **유니크** — 쿼리 키로 이걸 쓴다 |
| `DeveloperName` | string | 오브젝트 내부명. 유니크하지 않음 |
| `Label` | string | 사용자 로케일 라벨 |
| `MasterLabel` | string | 기본(en_US) 라벨 — Setup 표시용 |
| `PluralLabel` | string | 복수형 라벨 |
| `KeyPrefix` | string | 레코드 ID 앞 3자리 |
| `Description` | string | 오브젝트 설명 (v37.0+) |
| `NamespacePrefix` | string | 관리형 패키지 네임스페이스 |
| `DurableId` | string | 유니크 ID — 릴리즈 간 변동 가능하므로 사용 직전 재조회 |

### 역량 플래그 (boolean)

| 필드 | 의미 |
|---|---|
| `IsQueryable` | 레코드 쿼리 가능 |
| `IsApexTriggerable` / `IsTriggerable` | Apex 트리거 정의 가능 (v35.0+) |
| `IsWorkflowEnabled` | 워크플로 규칙 지원 |
| `IsCustomizable` | 커스텀 필드 추가 가능 |
| `IsCustomSetting` | 커스텀 세팅 여부 (v35.0+) |
| `IsFlsEnabled` | 필드 레벨 보안 적용 (v35.0+) |
| `IsFeedEnabled` | Chatter 피드 활성 (v34.0+) |
| `IsLayoutable` / `IsCompactLayoutable` | (컴팩트)레이아웃 지원 |
| `IsSearchable` | 검색 인덱싱됨 (v35.0+) |
| `IsEverCreatable` / `IsEverUpdatable` / `IsEverDeletable` | API로 생성·수정·삭제 가능 (v35.0+) |
| `IsActivityTrackable` · `IsFieldHistoryTracked` · `IsReportingEnabled` | 커스텀 오브젝트 활동·이력·리포팅 (v37.0+) |
| `IsMruEnabled` | 최근 사용 목록 (v37.0+) |
| `IsDeprecatedAndHidden` | 현재 버전에서 비가용 (v35.0+) |

> `IsCreatable`/`IsDeletable`는 v35.0부터 deprecated → `RunningUserEntityAccess`(UserEntityAccess)로 현재 사용자 접근을 확인한다.

### 공유·상태 필드

| 필드 | 값 |
|---|---|
| `InternalSharingModel` / `ExternalSharingModel` | None · Read · Edit · ControlledByLeadOrContact · ControlledByCampaign (v38.0+) |
| `DeploymentStatus` | InDevelopment · Deployed (v37.0+) |
| `DetailUrl` · `EditUrl` · `NewUrl` · `HelpSettingPageUrl` | Setup URL들 (v34.0+) |

### 서브쿼리 전용 자식 관계 (주요)

EntityDefinition에서 아래는 **서브쿼리로만** 접근한다. `getSObjects('관계명')`으로 부모 행에서 자식 컬렉션을 꺼낸다.

| 관계 | 자식 오브젝트 | 버전 |
|---|---|---|
| `Fields` | FieldDefinition | v32.0+ |
| `CustomFields` | CustomField | v34.0+ |
| `FieldSets` | FieldSet | v32.0+ |
| `Layouts` · `CompactLayouts` · `SearchLayouts` | (각) | v34.0+ |
| `RecordTypes` | RecordType | v34.0+ |
| `ValidationRules` · `WebLinks` · `ApexTriggers` | (각) | v34.0+ |
| `ChildRelationships` · `RelationshipDomains` | QueryResult / RelationshipDomain | v34.0+ |
| `Particles` | EntityParticle | v34.0+ |
| `Limits` | EntityLimit | v34.0+ |
| `RelatedListDefinitions` | RelatedListDefinition | v55.0+ |

### 복합/메타데이터 필드 (Tooling API)

`Metadata`(mns:CustomObject), `FullName`, `Publisher`, `RunningUserEntityAccess`, `RecordTypesSupported`. **`Metadata`·`FullName`은 결과가 1행 이하일 때만** 쿼리 가능(성능 보호).

---

## FieldDefinition — 필드 메타데이터 (API v32.0+)

필드 하나당 1행. EntityParticle(=UI에 표시되는 필드 요소)와 달리 **저장된 필드**를 나타낸다.

> ⚠️ **필수 필터:** FieldDefinition 쿼리는 반드시 부모 오브젝트를 특정해야 한다.
> `WHERE EntityDefinition.QualifiedApiName = 'Account'` (또는 `EntityDefinition.DeveloperName = '...'`) 없이 전체를 훑을 수 없다.

### 핵심 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `QualifiedApiName` | string | 유니크 필드 식별자 |
| `DeveloperName` | string | API 안전명(영숫자+`_`, 문자로 시작) |
| `DataType` | string | **UI 표시 타입 문자열** — 예: `Text(40)`, `Date/Time`, `Lookup(Account)` |
| `Label` / `MasterLabel` | string | 라벨 / 번역 독립 내부 라벨(40자) |
| `Description` | string | 필드 설명 |
| `EntityDefinitionId` | string | 부모 오브젝트 Durable ID |
| `EntityDefinition` | reference | 부모 오브젝트 메타데이터로의 참조(필터에 사용) |
| `DurableId` | string | 유니크 필드 ID(사용 직전 재조회) |
| `NamespacePrefix` | string | 관리형 패키지 네임스페이스 |

### 속성 플래그 (boolean)

| 필드 | 의미 |
|---|---|
| `IsCalculated` | **계산 필드(포뮬러/롤업 등) 여부** — 포뮬러 필드 찾기의 핵심 |
| `IsCompound` | 복합 필드(주소·이름 등) (v38.0+) |
| `IsIndexed` | DB 인덱스 존재 (v35.0+) |
| `IsNillable` | 값 생략 가능(nullable) |
| `IsFieldHistoryTracked` | 이력 추적 활성 |
| `IsApiFilterable` / `IsApiSortable` / `IsApiGroupable` | SOQL `WHERE`/`ORDER BY`/`GROUP BY` 적격 |
| `IsFlsEnabled` | 필드 레벨 보안 적용 |
| `IsNameField` | 기본 Name 필드 여부 |
| `IsPolymorphicForeignKey` | 다형 참조(OwnerId 등) (v41.0+) |
| `IsHtmlFormatted` | HTML 콘텐츠 |
| `IsHighScaleNumber` | 고정밀 소수(8자리) |
| `IsEverApiAccessible` | API describe 가능 (v49.0+) |
| `IsSearchPrefilterable` | SOSL 프리필터 지원 (v40.0+) |

### 수치 속성

| 필드 | 설명 |
|---|---|
| `Length` | 최대 바이트 |
| `Precision` | 총 자릿수 |
| `Scale` | 소수 자릿수 |
| `ValueTypeId` | 데이터 타입 식별자 (v35.0+) |

### 관계·참조 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `RelationshipName` | string | 룩업/마스터-디테일의 관계명(자식→부모 traversal 이름) |
| `ReferenceTo` | RelationshipReferenceTo | 참조 대상 오브젝트 배열(다형 지원) |
| `ReferenceTargetField` | string | 외부 오브젝트 간접 룩업 매칭 필드 |
| `ControllingFieldDefinitionId` / `ControllingFieldDefinition` | string / FieldDefinition | 의존 픽리스트의 컨트롤링 필드 |
| `ExtraTypeInfo` | string | 타입 정제: plaintextarea · richtextarea · externallookup · indirectlookup · switchablepersonname |

### 거버넌스 분류 (v45.0+)

| 필드 | 값 |
|---|---|
| `BusinessStatus` | Active · DeprecateCandidate · Hidden |
| `SecurityClassification` | Public · Internal · Confidential · Restricted · MissionCritical |
| `ComplianceGroup` | CCPA · COPPA · GDPR · HIPAA · PCI · PII · PersonalInfo (멀티픽리스트) |
| `BusinessOwnerId` | 필드 담당자 |

### Metadata 필드 (Tooling API 한정)

`Metadata`는 CustomField 메타데이터(`type`·`required`·`unique`·`externalId`·`defaultValue`·`formula`·`trackHistory`…)를 담는다. **일반 Apex SOQL에서는 접근 불가 — Tooling API 호출로만** 조회하고, 결과가 1행일 때만 쿼리 가능. `FullName`도 단일 행 쿼리 전용.

---

## DataType 값 참조 (v34.0+)

`FieldDefinition.DataType`(및 EntityParticle의 동명 필드)은 UI 표시 문자열이다. 대표 값: `Text` · `Text(길이)` · `Text Area` · `Text Area (Long)` · `Text Area (Rich)` · `Number(p,s)` · `Currency` · `Percent` · `Date` · `Date/Time` · `Checkbox` · `Picklist` · `Picklist (Multi-Select)` · `Email` · `Phone` · `URL` · `Lookup(대상)` · `Master-Detail(대상)` · `Formula (반환타입)` · `Roll-Up Summary` · `Auto Number` · `Geolocation` 등. 문자열 매칭이므로 파싱 시 주의(길이·대상이 괄호로 붙는다).

---

## 실전 예시 — apex-recipes `MetadataCatalogRecipes.cls` (Tier 1)

아래는 **실제 소스 코드 그대로**다(마커 불필요).

### 1) 조직 전체 포뮬러(계산) 필드 찾기 — 부모+서브쿼리 패턴

`EntityDefinition`을 부모로, `Fields` 서브쿼리로 `IsCalculated = TRUE`인 필드만 뽑는다. 부모 행에서 자식은 `getSObjects('Fields')`로 꺼낸다(서브쿼리 관계는 점 표기 대신 이 메서드로 접근).

```apex
@SuppressWarnings('PMD.ApexCRUDViolation')
public static Map<String, Map<String, String>> findAllFormulaFields() {
    List<EntityDefinition> objects = [
        SELECT
            QualifiedApiName,
            (
                SELECT DeveloperName, DataType
                FROM Fields
                WHERE IsCalculated = TRUE
            )
        FROM EntityDefinition
    ];
    Map<String, Map<String, String>> objectToFormulaFieldsToDataTypeMap =
        new Map<String, Map<String, String>>();
    for (EntityDefinition e : objects) {
        for (FieldDefinition f : e.getSObjects('Fields')) {
            if (objectToFormulaFieldsToDataTypeMap.containsKey(String.valueOf(e))) {
                objectToFormulaFieldsToDataTypeMap
                    .get(String.valueOf(e.QualifiedApiName))
                    .put(f.DeveloperName, f.DataType);
            } else {
                objectToFormulaFieldsToDataTypeMap.put(
                    String.valueOf(e.QualifiedApiName),
                    new Map<String, String>{ f.DeveloperName => f.DataType }
                );
            }
        }
    }
    return objectToFormulaFieldsToDataTypeMap;
}
```

반환: `오브젝트 QualifiedApiName → (필드명 → DataType)`. 즉 조직의 모든 계산 필드 인벤토리.

> 자식 컬렉션을 부모에서 꺼낼 때 **`e.getSObjects('Fields')`** 를 쓴다 — 일반 SObject의 `e.Fields`가 아니라 문자열 관계명을 넘기는 동적 접근이다. 이것이 메타데이터 카탈로그 서브쿼리의 특징적 문법이다.

### 2) Contact에서 Account를 룩업하는 필드 찾기 — FieldDefinition 직접 쿼리

FieldDefinition을 직접 조회하며 **필수 필터**(`EntityDefinition.DeveloperName = 'Contact'`)와 `RelationshipName`으로 관계 필드를 좁힌다.

```apex
@SuppressWarnings('PMD.ApexCRUDViolation')
public static List<MetadataCatalogRecipes.LookupRelationshipDefinition>
        findAllContactFieldsThatLookupToAccount() {
    List<FieldDefinition> looksUpToAccount = [
        SELECT
            EntityDefinition.DeveloperName,
            DeveloperName,
            RelationshipName,
            DataType
        FROM FieldDefinition
        WHERE
            EntityDefinition.DeveloperName = 'Contact'
            AND RelationshipName = 'Account'
    ];
    List<LookupRelationshipDefinition> relationships =
        new List<LookupRelationshipDefinition>();
    for (FieldDefinition f : looksUpToAccount) {
        relationships.add(new LookupRelationshipDefinition(f));
    }
    return relationships;
}
```

관계 traversal — `f.EntityDefinition.DeveloperName`으로 부모 오브젝트명을 SELECT 절에서 바로 읽는다(참조 필드 dot-walk).

### 3) FieldDefinition → DTO 매핑 (관계 필드 dot-walk)

```apex
public class LookupRelationshipDefinition {
    public String looksUpTo { get; set; }
    public String developerName { get; set; }
    public String relationshipName { get; set; }
    public String dataType { get; set; }

    public LookupRelationshipDefinition(FieldDefinition fd) {
        this.looksUpTo = String.valueOf(fd.EntityDefinition.DeveloperName);
        this.developerName = String.valueOf(fd.DeveloperName);
        this.relationshipName = String.valueOf(fd.RelationshipName);
        this.dataType = String.valueOf(fd.DataType);
    }
}
```

---

## 응용 쿼리 모음 (구조 예시)

아래는 위 API 표를 조합한 예시다.

```apex
// 구조 예시 — 특정 오브젝트의 모든 필드 이름+타입 (필수 필터 준수)
List<FieldDefinition> fields = [
    SELECT QualifiedApiName, Label, DataType, IsCalculated, IsNillable
    FROM FieldDefinition
    WHERE EntityDefinition.QualifiedApiName = 'Account'
    ORDER BY QualifiedApiName
];

// 구조 예시 — 커스텀 오브젝트만 (KeyPrefix로 필터 불가; NamespacePrefix/QualifiedApiName 접미사 활용)
List<EntityDefinition> customObjs = [
    SELECT QualifiedApiName, Label, KeyPrefix
    FROM EntityDefinition
    WHERE QualifiedApiName LIKE '%__c'
    ORDER BY Label
];

// 구조 예시 — GDPR 컴플라이언스로 분류된 필드 감사 (v45.0+)
List<FieldDefinition> pii = [
    SELECT EntityDefinition.QualifiedApiName, QualifiedApiName, ComplianceGroup, SecurityClassification
    FROM FieldDefinition
    WHERE EntityDefinition.QualifiedApiName = 'Contact'
      AND ComplianceGroup INCLUDES ('GDPR')
];
```

> ⚠️ 위는 API 스펙에 기반한 예시이며 조직 스키마·권한에 따라 결과가 달라진다. `IsApiFilterable`이 false인 필드로는 `WHERE`를 걸 수 없다.

---

## 제약·주의사항

| 제약 | 내용 |
|---|---|
| FieldDefinition 필수 필터 | 반드시 `EntityDefinition.QualifiedApiName`(또는 `DeveloperName`) `=` 단일 값. 없으면 쿼리 실패 |
| `Metadata`·`FullName` 단일 행 | 두 필드는 결과 1행 이하일 때만 SELECT 가능(성능 보호). `Metadata`는 Tooling API 전용 |
| 일반 Apex vs Tooling | EntityDefinition·FieldDefinition은 일반 Apex SOQL 가능. 단 `Metadata` 필드값은 **Tooling API 호출**로만 |
| 권한 | Tooling API 접근 시 `View Setup and Configuration` 권한 필요(v45.0+) |
| Durable ID 변동 | `DurableId`는 릴리즈 간 바뀔 수 있어 캐싱 금지 — 사용 직전 재조회 |
| Guest User | v44.0 이하 게스트 모드는 필드 레벨 메타데이터 접근에 SOAP API 필요 |
| SOQL 한도 | 카탈로그도 SOQL 쿼리 수·로우 한도에 포함(단 힙은 describe보다 절약) |
| `IsCreatable`/`IsDeletable` | v35.0+ deprecated → `RunningUserEntityAccess` 사용 |
| CRUD/FLS | 카탈로그 쿼리 전에도 접근 검사 권장(apex-recipes는 `CanTheUser.*`로 확인 후 `@SuppressWarnings('PMD.ApexCRUDViolation')`) |

---

## 관련 노트

- [[Dynamic SOQL]] — 런타임 쿼리 조립. 카탈로그로 얻은 필드명으로 동적 SELECT 구성
- [[SOQL 문법 레퍼런스]] — 서브쿼리·관계 traversal·`INCLUDES` 문법
- [[Schema Namespace 상세]] — 명령형 describe(`getGlobalDescribe`·`DescribeSObjectResult`) — 카탈로그의 대안
- [[Database Namespace 상세]] — 동적 쿼리 실행(`Database.query`)
- [[Tooling API 객체 — Entity·Field·스키마]] — 같은 오브젝트를 Tooling API(REST/SOAP)로 다루는 관점
- [[SOQL 패턴]] — 실전 SOQL 패턴 모음
