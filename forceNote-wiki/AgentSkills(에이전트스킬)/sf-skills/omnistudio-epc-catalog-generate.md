---
tags: [agent-skill, sf-skills, omnistudio, epc, product2, cme, datapack]
source: forcedotcom/sf-skills (skills/omnistudio-epc-catalog-generate/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [omnistudio-epc-catalog-generate, EPC 제품 카탈로그 생성 스킬, Product2 offer bundle, ProductChildItem, CME Enterprise Product Catalog]
---

# omnistudio-epc-catalog-generate — CME EPC 제품·오퍼 모델링 스킬

> Salesforce Industries CME EPC의 Product2 기반 카탈로그 항목·속성·ProductChildItem 오퍼 번들과 companion DataPack JSON을 생성·검토하고 120점 루브릭으로 채점하는 에이전트 스킬.

---

## 목적과 활성화 조건

Product2 기반 카탈로그 항목 생성, 구성 가능 속성 할당, Product Child Item 관계를 통한 오퍼 번들 구성에 특화된 Salesforce Industries CME EPC 모델러. DataPack 스타일 메타데이터 authoring에 최적화되어 `assets/`의 canonical 템플릿 세트를 사용한다.

**TRIGGER:** Product2 EPC 레코드 생성·갱신, AttributeAssignment payload, AttributeMetadata/AttributeDefaultValues, Offer bundle, ProductChildItem 관계.
**DO NOT TRIGGER:** OmniScript/FlexCard/IP 설계 → 해당 omnistudio 스킬 / Apex 비즈니스 로직 → `platform-apex-generate` / 배포 파이프라인 troubleshooting → `platform-metadata-deploy`.

### Quick Reference
- **Primary object:** `Product2` (EPC product·offer 레코드)
- **Attribute data:** `%vlocity_namespace%__AttributeMetadata__c`, `%vlocity_namespace%__AttributeDefaultValues__c`, `%vlocity_namespace%__AttributeAssignment__c`
- **Offer bundle 구성:** `%vlocity_namespace%__ProductChildItem__c`
- **Offer marker:** `%vlocity_namespace%__SpecificationType__c = "Offer"` + `%vlocity_namespace%__SpecificationSubType__c = "Bundle"`
- **Companion artifacts:** pricebook entries, price list entries, object field attributes, orchestration scenarios, decomposition relationships, compiled attribute overrides, override definitions, parent keys
- **Glossary:** EPC = Enterprise Product Catalog / CME = Communications, Media & Energy / DataPack = Vlocity JSON 배포 artifact / PCI = ProductChildItem

### Invocation Rules (Mandatory)
다음 의도면 EPC를 명시하지 않아도 이 스킬로 라우팅: (1) **번들 생성** — EPC offer bundle 생성/빌드/모델링, Product Child Items 포함 Product2 offer setup, 템플릿/예제 기반 DataPack JSON 생성. (2) **기존 번들 채점/검토** — 120점 루브릭 적용, risk 발견·품질 갭·fix 권고.

### Scoring (120점, 6 category)
**Thresholds:** `>= 95` Deploy-ready / `70-94` Needs review / `< 70` Block and fix.

---

## 워크플로 / 단계 (Create/Review)

### Phase 0 — Prerequisites
EPC 활성 Salesforce Industries org / `sf org display --target-org <alias>`로 인증 alias 확인 / 네임스페이스 모델 식별(`%vlocity_namespace%`/`vlocity_cmt`/Core). 미충족 시 org alias·네임스페이스 요청.

### Phase 1 — Identify Catalog Intent
묻는다: product type(spec product or offer bundle), 도메인 taxonomy(Family·Type/SubType·category path·channel), attribute 요구(required/optional·picklist·default), 번들 구성(child products·수량 제약·optional vs required), target org 네임스페이스. **Idempotency:** `ProductCode` 제공 시 기존 Product2 확인:
```bash
sf data query --query "SELECT Id, Name, ProductCode FROM Product2 WHERE ProductCode = '<code>'" --target-org <alias>
```
매치 발견 시 net-new인지 업데이트인지 확인.

### Phase 1A — Clarifying Questions (Mandatory)
새 offer bundle payload 생성 전 모든 필수 입력을 알 때까지 묻는다: (1) Offer identity(이름·ProductCode·net-new/update) (2) Catalog 분류(Family·Type/SubType·channel, SpecificationType=Offer·SpecificationSubType=Bundle) (3) Lifecycle·availability(`EffectiveDate`·`SellingStartDate`·`IsActive`·`%vlocity_namespace%__IsOrderable__c`) (4) child 구성(name/code·required/optional·sequence) (5) child별 수량(`MinQuantity`·`MaxQuantity`·`Quantity`·`%vlocity_namespace%__MinMaxDefaultQty__c`) (6) attribute 모델(required vs optional·valid values·defaults·display type·sequence) (7) pricing·companion artifacts (8) namespace·keying(global key/source key 보존). 미답 항목이 있으면 final 번들 파일 생성 보류, focused 후속 질문 먼저.

### Phase 2 — Build Product2 Backbone
모든 EPC 레코드에 정의: `Name`, `ProductCode`(unique·stable·환경 무관), `%vlocity_namespace%__GlobalKey__c`(stable UUID-style), `%vlocity_namespace%__SpecificationType__c`·`SpecificationSubType__c`, `%vlocity_namespace%__Status__c`·날짜(`EffectiveDate`·`SellingStartDate`), `IsActive`·`%vlocity_namespace%__IsOrderable__c`. baseline: `assets/product2-offer-template.json`.

### Phase 3 — Add Attributes
1. `%vlocity_namespace%__AttributeMetadata__c` category·`productAttributes` 채움 2. `%vlocity_namespace%__AttributeDefaultValues__c`에 attribute code → default value 매핑 3. `%vlocity_namespace%__AttributeAssignment__c` 레코드 생성(category linkage·attribute linkage·UI display type·valid values·default marker). baseline: `assets/attribute-assignment-template.json`.

### Phase 4 — Build Offer Bundles
1. 부모 `Product2`를 offer로 유지(`SpecificationType=Offer`·`SpecificationSubType=Bundle`) 2. root `%vlocity_namespace%__ProductChildItem__c` 행 생성(`IsRootProductChildItem=true`) 3. 컴포넌트별 child 행(parent·child 참조, sequence·line number, `MinMaxDefaultQty`·`MinQuantity`·`MaxQuantity`·`Quantity`) 4. inherited/default와 다를 때만 override 행. structure: `assets/product-child-item-template.json`.

### Phase 4B — Generate Companion Metadata Files
번들 생성 요청 시 모든 companion 파일을 하나의 일관된 세트로 함께 생성/갱신: pricebook·price list entries(Product2 GlobalKey/ProductCode 정렬) / object field attributes(object class·field 매핑 정렬) / orchestration·decomposition(child item과 일관) / compiled attribute overrides·override definitions(attribute metadata와 정렬) / parent keys(생성 artifact key와 동기화). **Mandatory rule:** full 번들 payload 요청 시 사용자가 명시적으로 제한 scope를 요청하지 않는 한 부분 subset만 생성하지 않는다.

### Phase 5 — Validate and Handoff
`assets/completion-block-template.txt`를 읽어 각 필드를 채워 handoff 요약 블록 생성.

### Output Expectations (full offer bundle)
| File pattern | Content |
|---|---|
| `*_DataPack.json` | Product2 offer 레코드 |
| `*_AttributeAssignments.json` | Attribute category·assignment payload |
| `*_ProductChildItems.json` | Root·child PCI 행 |
| `*_PricebookEntries.json` | Standard·custom pricebook entries |
| `*_PriceListEntries.json` | Price list entries |
| `*_ObjectFieldAttributes.json` | Object field mapping |
| `*_OrchestrationScenarios.json` | Orchestration metadata |
| `*_DecompositionRelationships.json` | Decomposition metadata |
| `*_CompiledAttributeOverrides.json` | Compiled attribute override payload |
| `*_OverrideDefinitions.json` | Override definition payload |
| `*_ParentKeys.json` | Parent key linkage |

spec product(non-bundle)는 DataPack·AttributeAssignments·PricebookEntries·PriceListEntries만 필요. **생성 중 어떤 파일이라도 실패하면 즉시 중단** — 성공 파일 목록을 보고하고 partial set 삭제 후 재시도 지시(partial 번들은 DataPack import 시 GlobalKey mismatch 유발).

---

## 핵심 규칙·가드레일

### Generation Guardrails (Mandatory) — anti-pattern 발견 시 STOP 후 확인
| Anti-pattern | Why it fails | Required correction |
|---|---|---|
| `ProductCode` 누락·불안정 코드 | quote/cart 참조·package diff 깨짐 | 결정적 코드 규약 |
| 관계에 org-specific 하드코딩 ID | org/환경 간 실패 | matching key/global key의 lookup object |
| root PCI 행 없는 offer bundle | 런타임 bundle traversal 이슈 | root `ProductChildItem__c` 추가 |
| attribute default가 valid values에 없음 | 잘못된 cart 구성 기본값 | default가 allowed value set에 존재 보장 |
| 동일 attribute category 내 중복 display sequence | UI ordering 충돌 | unique·spaced sequence(10,20,30) |
| 불완전 child 참조로 active offer | 런타임 broken bundle | 활성화 전 child link 완성·검증 |
| mixed naming style | 유지보수성 저하 | references doc naming 규약 강제 |

### Scoring Model (120점)
| Category | Points |
|---|---|
| Catalog Identity and Naming | 20 |
| EPC Product Structure | 20 |
| Attribute Modeling | 25 |
| Offer Bundle Composition | 25 |
| DataPack Integrity | 15 |
| Documentation and Handoff | 15 |
| **Total** | **120** |

전체 6-category 루브릭: `references/scoring-model.md`.

### Gotchas (발췌)
- attribute default가 valid values에 없음 → `values[]` 배열에 존재 보장(cart가 런타임 거부)
- root ProductChildItem 행 누락 → `IsRootProductChildItem=true` 항상 먼저 생성
- 한 payload에 혼합 네임스페이스 → 하나의 style(`%vlocity_namespace%` vs `vlocity_cmt`) 전 파일 일관 적용
- `ProductCode`에 환경 suffix(`_DEV`/`_UAT`/`_PROD`) → 제거(cross-org 참조 깨짐)
- companion 파일이 다른 offer 이름으로 생성 → 동일 baseline 이름·GlobalKey로 생성
- DataPack import `Key not found` → lookup object 참조가 target org에 없는 GlobalKey, 정렬 검증
- DataPack import silent rollback → `--verbose`로 배포해 rollback 유발 레코드·필드 검사

---

## 번들 파일

| 경로 | 용도 |
|------|------|
| `assets/product2-offer-template.json` | Phase 2 — 모든 새 Product2 offer baseline |
| `assets/attribute-assignment-template.json` | Phase 3 — attribute assignment 구조 |
| `assets/product-child-item-template.json` | Phase 4 — root·child PCI 행 구조 |
| `assets/pricebook-entries-template.json` 외 companion 템플릿 | Phase 4B — pricing·object field·orchestration·decomposition·override·parent-keys |
| `assets/completion-block-template.txt` | Phase 5 — handoff 요약 블록 |
| `assets/examples/` (samsung-galaxy-s22-bundle, business-internet-premium-fttc, business-internet-pro-vpl, static-ip) | Phase 4 — bundle·simple offer 예제 |
| `examples/business-internet-plus-bundle/` | Phase 4 — TRANSCRIPT 포함 생성 번들 예제 |
| `references/epc-field-guide.md` | Phase 2·3 — EPC 필드 가이드·minimum required fields |
| `references/naming-conventions.md` | Phase 2·3 — naming·keying 규약 |
| `references/scoring-model.md` | Phase 5 — 6-category 루브릭 |
| `scripts/cli-validation-commands.sh` | Phase 5 — EPC artifact 검증 sf CLI 쿼리 |
| `scripts/sample-invocations.sh` | On Start — 공통 EPC task 예제 invocation |

---

## 관련 노트
- [[omnistudio-datapacks-deploy]]
- [[omnistudio-dependencies-analyze]]
- [[omnistudio-integration-procedure-generate]]
- [[omnistudio-omniscript-generate]]
