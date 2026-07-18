---
tags: [omnistudio, epc, industries-cpq, cme, vlocity, product2, datapack, catalog]
source: forcedotcom/sf-skills (skills/omnistudio-epc-catalog-generate/references/ — epc-field-guide.md · naming-conventions.md · scoring-model.md, 공식 Salesforce)
created: 2026-07-18
aliases: [Enterprise Product Catalog, EPC, EPC 데이터 모델, Product2 offer, ProductChildItem, CME EPC, Industries CPQ 카탈로그, 오퍼 번들]
---

# Enterprise Product Catalog (EPC) — 데이터 모델·명명·번들

> Industries CPQ(CME) 제품 카탈로그의 데이터 모델 지식 — Product2 오퍼·속성 메타데이터·ProductChildItem 번들·결정적 명명 규칙·DataPack 무결성. 이 노트는 **지식**(EPC가 무엇이고 어떤 필드로 구성되나)이고, 실제 **카탈로그 생성·채점**은 대응 sf-skill `omnistudio-epc-catalog-generate`가 수행한다.

---

## EPC란 — 위치와 경계

**Enterprise Product Catalog(EPC)** 는 Salesforce **Industries CPQ**(구 Vlocity, CME = Communications·Media·Energy 버티컬)의 제품 카탈로그 데이터 모델이다. 통신·미디어·에너지의 복잡한 오퍼(번들·구성 가능 제품·속성 기반 가격)를 `Product2` 확장 필드와 Vlocity 관리형 오브젝트로 모델링한다.

> [!note] 문서세트 경계 (OMNISTUDIO-1 실측)
> EPC와 Calculation Procedures/Matrices는 **OmniStudio Standard 문서세트에 없다** — Industries CPQ / CME Vlocity **관리형 패키지** 소속이다. 그래서 [[OmniStudio 개요·오리엔테이션]]의 8노트(OmniScript·FlexCard·DataMapper·IP 등)와 별개로, 이 노트는 **sf-skill 레퍼런스(Tier 1)** 를 지식 소스로 삼는다. 필드는 `%vlocity_namespace%` 접두사(관리형 네임스페이스)를 쓴다.

- **지식 ↔ 실행:** 이 노트(지식) ↔ `omnistudio-epc-catalog-generate`(실행 — DataPack 스타일 메타데이터로 오퍼 번들 생성·120점 채점).
- **DataPack 관점:** 아래 필드·오브젝트는 **DataPack 스타일 메타데이터**(환경 간 이식 가능한 카탈로그 정의) 기준이다. [[OmniStudio 메타데이터·DataPack 배포]]와 같은 DataPack 배포 메커니즘을 공유한다.

---

## Product2 — 오퍼 최소 필드 세트

EPC 제품·오퍼는 표준 `Product2`에 Vlocity 관리형 필드를 얹어 정의한다. 오퍼 번들 생성의 **최소 권장 필드**:

| 필드 | 목적 | 예시 |
|---|---|---|
| `Name` | 사람이 읽는 카탈로그 이름 | `Business Internet Essential (VPL)` |
| `ProductCode` | 안정적 기술 식별자 | `VEPC_OFFERING_BUSINESS_INTERNET_ESSENTIAL` |
| `%vlocity_namespace%__GlobalKey__c` | 환경 간 안정 키(cross-environment) | UUID-like 값 |
| `%vlocity_namespace%__SpecificationType__c` | 제품 분류 | `Offer` |
| `%vlocity_namespace%__SpecificationSubType__c` | 제품 서브타입 | `Bundle` |
| `%vlocity_namespace%__Status__c` | EPC 상태 | `Active` |
| `%vlocity_namespace%__IsOrderable__c` | 주문 가능 여부 | `true` |
| `IsActive` | 제품 가용성 | `true` |
| `%vlocity_namespace%__SellingStartDate__c` | 판매 라이프사이클 시작 | `2021-07-31T04:00:00.000Z` |

> `SpecificationType=Offer` + `SpecificationSubType=Bundle` 이 "구성 가능한 오퍼 번들"의 핵심 분류다. 단순 오퍼(simple offer)는 자식 아이템 없이 오퍼 자체가 판매 단위다.

---

## 속성 메타데이터 블록 (Attribute Metadata)

EPC 제품은 **속성(attribute)** 으로 구성 가능성(configurability)을 표현한다.

### `%vlocity_namespace%__AttributeMetadata__c`

카테고리/그룹 메타데이터 + 제품 속성 레코드를 담는다:

- 카테고리: `Code__c`, `Name`, `displaySequence`
- 속성별: `code`, `label`, `inputType`, `required`, `values[]`

### `%vlocity_namespace%__AttributeDefaultValues__c`

속성 코드 → 기본값 매핑:

```json
// 소스 예시 (forcedotcom/sf-skills epc-field-guide.md) — 실제 카탈로그 값 아님
{
  "VEPC_ATTR_DOWNLOAD_SPEED": "50 Mbps",
  "VEPC_ATTR_CONTRACT_TERM": "Month-to-Month"
}
```

> ⚠️ **함정:** 기본값은 반드시 그 속성의 `values[]` 유효 값 집합 **안에** 있어야 한다 — 없으면 런타임 구성 오류.

---

## 오퍼 번들 모델링 (`%vlocity_namespace%__ProductChildItem__c`)

오퍼 번들은 **child item 행**으로 조립된다:

- **루트 행 1개:** `IsRootProductChildItem = true`
- **자식 행들:** parent·child 참조 + sequence·quantity 설정

수량(quantity) 핵심 필드:

| 필드 | 의미 |
|---|---|
| `%vlocity_namespace%__MinQuantity__c` | 최소 수량 |
| `%vlocity_namespace%__MaxQuantity__c` | 최대 수량 |
| `%vlocity_namespace%__Quantity__c` | 기본 수량 |
| `%vlocity_namespace%__MinMaxDefaultQty__c` | min/max/default 축약 (예: `"0, 1, 1"`) |

> optional vs required 의미는 min/max/default 값으로 표현한다(예: `"0, 1, 1"` = 선택적, 최대 1, 기본 1).

---

## 결정적 명명 규칙 (Naming Conventions)

제품·속성·번들 전반에 **결정적(deterministic)** 명명을 쓴다 — 환경·릴리스 간 안정적이어야 한다.

| 대상 | 형식 | 예시 |
|---|---|---|
| Product Name | `<Business Domain> <Tier/Variant> (<Channel/Variant Tag>)` | `Business Internet Essential (VPL)` |
| Product Code | `<PREFIX>_<ENTITY>_<DOMAIN>_<VARIANT>` | `VEPC_OFFERING_BUSINESS_INTERNET_ESSENTIAL` |
| Attribute Code | `VEPC_ATTR_<DOMAIN>_<ATTRIBUTE_NAME>` | `VEPC_ATTR_DOWNLOAD_SPEED` |
| Attribute Category Code | `VEPC_ATTRIBUTE_CATEGORY_<DOMAIN_BLOCK>` | `VEPC_ATTRIBUTE_CATEGORY_INTERNET_DETAILS` |

**ProductCode 규칙:** 대문자+언더스코어만 · 환경 접미사(`_DEV`·`_UAT`·`_PROD`) 금지 · go-live 후 불변.

**번들 구성 명명:** 번들 parent는 `VEPC_OFFERING_*`(오퍼 의도), 자식은 재사용 spec `VEPC_SPEC_*` 권장. `SeqNumber`·`ChildLineNumber`는 parent별 유일 + 향후 삽입 대비 간격을 둔다(10, 20, 30…).

### 안티패턴

| 나쁜 패턴 | 이유 |
|---|---|
| `Product1`·`Offer_New`·`CatalogItemA` | 비서술적·불안정 |
| glossary 없는 혼합 약어 | 유지·검색 곤란 |
| `ProductCode`에 날짜/버전 | 장기 참조 깨짐 |
| 여러 제품에 동일 `ProductCode` | 다운스트림(cart·quote) 모호성 |

---

## DataPack 템플릿 세트

EPC 오퍼 번들은 DataPack 스타일 파일 세트로 이식된다. skill `assets/`의 정본 템플릿(Business Internet Essential VPL 번들 기준):

```text
// 소스 목록 (forcedotcom/sf-skills) — 템플릿 파일명
product2-offer-template.json
attribute-assignment-template.json
product-child-item-template.json
pricebook-entries-template.json
price-list-entries-template.json
object-field-attributes-template.json
orchestration-scenarios-template.json
decomposition-relationships-template.json
compiled-attribute-overrides-template.json
override-definitions-template.json
parent-keys-template.json
```

**DataPack 무결성 규칙:** 모든 파일에서 `%vlocity_namespace%` 플레이스홀더 일관 · lookup 참조는 GlobalKey/source key 사용(하드코딩 org ID 금지) · 환경 종속 필드 금지.

### 흔한 필드 함정

| 함정 | 영향 | 해결 |
|---|---|---|
| 여러 제품이 `ProductCode` 재사용 | cart·quote 모호성 | 카탈로그 코드 유일성 강제 |
| 기본 속성값이 values 목록에 없음 | 런타임 구성 오류 | 기본값을 유효 값 집합 안에 유지 |
| 루트 ProductChildItem 누락 | 오퍼 순회 깨짐 | 항상 루트 행 추가 |
| DataPack에 org 종속 ID 직접 사용 | 조직 간 배포 실패 | lookup source key·global key 사용 |

---

## EPC 번들 채점 루브릭 (120점)

기존 EPC 오퍼 번들을 채점·검토할 때 쓰는 120점 루브릭. 카테고리별 채점 후 합산. **임계값: `≥95` Deploy-ready · `70–94` Needs review · `<70` Block and fix.**

| # | 카테고리 | 배점 | 핵심 점검 |
|---|---|---|---|
| 1 | Catalog Identity & Naming | 20 | 이름 유일·명명 규칙 준수·`SpecificationType/SubType/Family` 일관·`GlobalKey` UUID·source key 일관 |
| 2 | EPC Product Structure | 20 | 필수 Product2·EPC 필드 존재·라이프사이클 날짜(`EffectiveDate`·`SellingStartDate`) 순서·`IsActive`/`IsOrderable` 일관·record type 일관 |
| 3 | Attribute Modeling | 25 | 카테고리 그룹핑·모든 기본값이 `values[]` 안·required/read-only/filterable 정확·display sequence 유일+간격(10,20,30…) |
| 4 | Offer Bundle Composition | 25 | 루트 `ProductChildItem`(`IsRootProductChildItem=true`) 존재·자식 참조 유효+sequence 유일·min/max/default quantity 정확·optional/required 반영 |
| 5 | DataPack Integrity | 15 | `%vlocity_namespace%` 일관·lookup은 GlobalKey/source key·환경 종속 필드 없음 |
| 6 | Documentation & Handoff | 15 | 모델 의도 설명·테스트 체크리스트·리스크/가정 명시 |

```text
// 구조 예시 — 실제 동작 코드 아님 (채점 합산 형식)
EPC Bundle Score: XXX/120  (>=95 Deploy-ready | 70-94 Review | <70 Block)
|- Catalog Identity & Naming: XX/20
|- EPC Product Structure:     XX/20
|- Attribute Modeling:        XX/25
|- Offer Bundle Composition:  XX/25
|- DataPack Integrity:        XX/15
|- Documentation & Handoff:   XX/15
```

---

## 커버리지 경계 (남은 갭)

이 노트는 sf-skill 레퍼런스(Tier 1) 기반 **DataPack/메타데이터 모델** 지식이다. 아래는 이 소스 범위 밖 — 별도 Industries CPQ 문서세트 소싱이 필요(OMNISTUDIO-2b 후속):

- **Calculation Procedures / Calculation Matrices** (속성 기반 동적 가격·수식) — 로컬 소스 없음, Industries CPQ 문서 필요.
- Pricing(Price List·Pricebook Entry) 상세 런타임 동작, Product Configuration(Cardinality·Rules), Order/Quote 통합(CPQ 런타임).

---

## 관련 노트
- [[OmniStudio 개요·오리엔테이션]] — OmniStudio 지식 계층 진입점(EPC는 Industries CPQ 소속 별도 경계)
- [[OmniStudio 메타데이터·DataPack 배포]] — DataPack 배포 메커니즘(EPC 카탈로그도 DataPack으로 이식)
- [[omnistudio-epc-catalog-generate]] — 대응 sf-skill(실행: 카탈로그 생성·120점 채점). 지식↔실행 짝
- [[epc-field-guide]] · [[naming-conventions]] · [[scoring-model]] — sf-skill 레퍼런스(이 노트의 Tier 1 소스)
