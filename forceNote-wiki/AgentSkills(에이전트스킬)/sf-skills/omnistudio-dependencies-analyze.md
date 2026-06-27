---
tags: [agent-skill, sf-skills, omnistudio, dependency-analysis, namespace-detection, mermaid]
source: forcedotcom/sf-skills (skills/omnistudio-dependencies-analyze/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [omnistudio-dependencies-analyze, OmniStudio 의존성 분석 스킬, 네임스페이스 감지, 영향 분석, Mermaid 의존성 그래프]
---

# omnistudio-dependencies-analyze — OmniStudio 교차 컴포넌트 분석 스킬

> OmniScript·FlexCard·Integration Procedure·Data Mapper 전반에 걸친 네임스페이스 감지·의존성 그래프 구성·영향 분석·Mermaid 시각화를 수행하는 에이전트 스킬.

---

## 목적과 활성화 조건

네임스페이스 감지·의존성 매핑·영향 분석에 특화된 OmniStudio 분석가. OmniScript/FlexCard/IP/Data Mapper의 org-wide 인벤토리를 수행하고 BFS 기반 의존성 그래프와 Mermaid 시각화를 자동 구성한다.

**TRIGGER:** OmniStudio 의존성 질문, 네임스페이스 감지(Core vs vlocity_cmt vs vlocity_ins), 영향 분석, 의존성 그래프·Mermaid 다이어그램 요청, 변경 영향 컴포넌트 파악.
**DO NOT TRIGGER:** OmniScript 작성 → `omnistudio-omniscript-generate` / FlexCard 빌드 → `omnistudio-flexcard-generate` / IP 생성 → `omnistudio-integration-procedure-generate` / Data Mapper 구성 → `omnistudio-datamapper-generate`.

### Required Inputs
| Input | Default if not provided |
|-------|------------------------|
| Target org alias | 사용자에게 질문 |
| Analysis scope | Full org (모든 OmniStudio 타입) |
| 특정 impact-analyze 컴포넌트 | None (먼저 full inventory) |
| Output 형식 | 셋 다: Mermaid + JSON summary + human-readable report |

### CRITICAL: Orchestration Order
`omnistudio-dependencies-analyze → omnistudio-datamapper-generate → omnistudio-integration-procedure-generate → omnistudio-omniscript-generate → omnistudio-flexcard-generate`. 이 스킬이 **가장 먼저** 실행되어 네임스페이스 컨텍스트·의존성 맵을 확립하면 downstream 스킬이 이를 소비.

### Key Insights
| Insight | Detail |
|---------|--------|
| 세 네임스페이스 공존 | Core(OmniProcess), vlocity_cmt(vlocity_cmt__OmniScript__c), vlocity_ins(vlocity_ins__OmniScript__c) |
| 의존성은 JSON에 저장 | PropertySetConfig(elements), Definition(FlexCards), InputObjectName/OutputObjectName(Data Mappers) |
| 순환 참조 가능 | OmniScript A → IP B → OmniScript A (embedded call) |
| FlexCard data source는 typed | DataSourceConfig JSON의 `dataSource.type === 'IntegrationProcedures'`(복수) |
| Active vs Draft 구분 | active 컴포넌트만 런타임 의존성 체인에 참여 |

---

## 워크플로 / 단계 (4-Phase 패턴)

### Phase 1 — Namespace Detection
컴포넌트 메타데이터 조회 전 org 네임스페이스를 결정. 순서대로 COUNT() 성공할 때까지 probe:
```soql
SELECT COUNT() FROM OmniProcess                       -- 성공 시 Core (API 234.0+ / Spring '22+)
SELECT COUNT() FROM vlocity_cmt__OmniScript__c        -- vlocity_cmt (Communications, Media & Energy)
SELECT COUNT() FROM vlocity_ins__OmniScript__c        -- vlocity_ins (Insurance & Health)
```
모두 실패하면 OmniStudio 미설치. CLI:
```bash
sf data query --query "SELECT COUNT() FROM OmniProcess" --target-org myorg --json 2>/dev/null
sf data query --query "SELECT COUNT() FROM vlocity_cmt__OmniScript__c" --target-org myorg --json 2>/dev/null
sf data query --query "SELECT COUNT() FROM vlocity_ins__OmniScript__c" --target-org myorg --json 2>/dev/null
```
exit code 0 + `totalSize` = 네임스페이스 확정. `INVALID_TYPE`/`sObject type not found` = 미존재. 전체 매핑은 `references/namespace-guide.md`.

### Phase 2 — Component Discovery
감지된 네임스페이스로 각 타입 조회(Core 예시):
```soql
-- OmniScripts (대형 org는 LIMIT/OFFSET 페이지네이션)
SELECT Id, Type, SubType, Language, IsActive, VersionNumber, PropertySetConfig, LastModifiedDate
FROM OmniProcess WHERE IsIntegrationProcedure = false
ORDER BY Type, SubType, Language, VersionNumber DESC LIMIT 200
-- Integration Procedures: 동일 쿼리 + WHERE IsIntegrationProcedure = true
-- FlexCards
SELECT Id, Name, IsActive, DataSourceConfig, PropertySetConfig, AuthorName, LastModifiedDate
FROM OmniUiCard ORDER BY Name LIMIT 200
-- Data Mappers
SELECT Id, Name, IsActive, Type, LastModifiedDate FROM OmniDataTransform ORDER BY Name LIMIT 200
-- Data Mapper Items
SELECT Id, OmniDataTransformationId, InputObjectName, OutputObjectName, InputObjectQuerySequence
FROM OmniDataTransformItem WHERE OmniDataTransformationId IN ({datamapper_ids})
```
**IMPORTANT:** `OmniUiCard`에는 `Definition` 필드 없음 — 데이터 소스는 `DataSourceConfig`, 레이아웃/상태는 `PropertySetConfig`. 외래키는 `OmniDataTransformationId`(full word "Transformation"), `OmniDataTransformId` 아님.

### Phase 3 — Dependency Analysis (BFS + 순환 감지)
```
1. 빈 그래프 G·visited set V 초기화
2. 각 root 컴포넌트 C:
   a. C를 work queue Q에 enqueue
   b. Q 비지 않은 동안:
      i.   X dequeue
      ii.  X가 V에 있으면 순환 참조 기록 후 skip
      iii. X를 V에 추가
      iv.  X 메타데이터에서 의존성 참조 파싱
      v.   각 의존성 D: edge X→D 추가; D가 V에 없으면 Q에 enqueue
3. G와 감지된 순환 참조 반환
```

**Element Type → Dependency 추출** (PropertySetConfig JSON):
| Element Type | JSON Path | Dependency Target |
|-------------|-----------|-------------------|
| DataRaptor Transform/Turbo Action | `bundle`, `bundleName` | Data Mapper (by name) |
| Remote Action | `remoteClass`, `remoteMethod` | Apex Class.Method |
| Integration Procedure Action | `integrationProcedureKey` | IP (Type_SubType) |
| OmniScript Action | `omniScriptKey` or `Type/SubType` | OmniScript (Type_SubType) |
| HTTP Action | `httpUrl`, `httpMethod` | External endpoint (URL) |
| DocuSign Envelope Action | `docuSignTemplateId` | DocuSign template |
| Apex Remote Action | `remoteClass` | Apex Class |

**FlexCard data source 파싱:** `DataSourceConfig` JSON에서 `dataSource`(singular) 접근 → `type === 'IntegrationProcedures'`(복수, 대문자 P)면 `dataSource.value.ipMethod` 추출 후 edge → `type === 'ApexRemote'`면 `dataSource.value.className` → childCard는 PropertySetConfig 파싱. **Data Mapper 객체 의존성:** OmniDataTransformItem의 `InputObjectName`(read)·`OutputObjectName`(write)로 sObject edge.

### Phase 4 — Visualization & Reporting
출력 3종: **Mermaid `graph LR`**(컬러 코딩 — OmniScript blue `#dbeafe`/`#1d4ed8`, IP amber `#fef3c7`/`#b45309`, Data Mapper green `#d1fae5`/`#047857`, FlexCard pink `#fce7f3`/`#be185d`, Apex purple `#e9d5ff`/`#7c3aed`, External slate `#f1f5f9`/`#475569`), **JSON summary**(namespace·components·dependencies·circularReferences·impactAnalysis), **Human-readable report**(component inventory active/draft, dependency summary, 순환 참조, most-depended 컴포넌트).

---

## 핵심 규칙·가드레일

### Output Expectations
namespace 감지 결과 / component inventory(타입별 active vs draft) / 의존성 그래프(edge type label) / Mermaid `graph LR` 블록 / JSON summary / human-readable report / 순환 참조 경고(cycle path + risk).

### Namespace 핵심 discriminator
- Core: `OmniProcess` / `OmniUiCard` / `OmniDataTransform`
- vlocity_cmt: `vlocity_cmt__OmniScript__c` / `vlocity_cmt__VlocityUITemplate__c` / `vlocity_cmt__DRBundle__c`
- vlocity_ins: `vlocity_ins__OmniScript__c` / `vlocity_ins__VlocityUITemplate__c` / `vlocity_ins__DRBundle__c`
- `IsIntegrationProcedure` boolean·`DataSourceConfig`(not `Definition`)는 Core 전용

### Gotchas (발췌)
- 혼합 네임스페이스 org(마이그레이션 중) → 셋 다 probe, 다수 결과 시 보고
- inactive 컴포넌트 → 그래프 포함하되 inactive 표시, active가 inactive 의존 시 경고
- 대형 org(1000+) → SOQL 페이지네이션(LIMIT/OFFSET·queryMore), 200씩 배치
- PropertySetConfig SOQL 길이 초과 → Tooling/REST API로 full JSON
- 순환 의존성 → cycle path 로깅(A→B→C→A), 참여 edge 표시, 나머지 branch 계속
- `IsIntegrationProcedure`가 discriminator(`TypeCategory` 없음); `OmniProcessType` picklist은 boolean에서 computed, create 시 직접 set 불가
- `sf data create record --values`는 JSON textarea 불가 → `sf api request rest --method POST --body @file.json`

---

## 번들 파일

| 경로 | 용도 |
|------|------|
| `references/namespace-guide.md` | Phase 1 — 세 네임스페이스 전체 object/field 매핑, deploy용 메타데이터 타입명, 혼합 네임스페이스 마이그레이션 시나리오 |
| `references/dependency-patterns.md` | Phase 3 — element별 의존성 추출 규칙, FlexCard data source 파싱, Data Mapper item 파싱, 순환 참조 감지 알고리즘, 영향 분석 패턴 |

**Dependencies:** `sf` CLI + org 인증 필요. (선택) `external-diagram-mermaid-generate`로 styled 시각화.

---

## 관련 노트
- [[omnistudio-datamapper-generate]]
- [[omnistudio-integration-procedure-generate]]
- [[omnistudio-omniscript-generate]]
- [[omnistudio-flexcard-generate]]
