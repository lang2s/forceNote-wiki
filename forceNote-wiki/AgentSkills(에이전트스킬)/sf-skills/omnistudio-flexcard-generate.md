---
tags: [agent-skill, sf-skills, omnistudio, flexcard, omni-ui-card, slds]
source: forcedotcom/sf-skills (skills/omnistudio-flexcard-generate/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [omnistudio-flexcard-generate, OmniStudio FlexCard 생성 스킬, OmniUiCard, DataSourceConfig, FlexCard data source]
---

# omnistudio-flexcard-generate — OmniStudio FlexCard 생성·검증 스킬

> at-a-glance UI 카드(`OmniUiCard`)를 선언적 데이터 바인딩·Integration Procedure 데이터 소스·조건부 렌더링·SLDS 스타일로 생성하고 130점 루브릭(7 category)으로 채점하는 에이전트 스킬.

---

## 목적과 활성화 조건

Salesforce Industries용 FlexCard UI 컴포넌트 전문 OmniStudio 엔지니어. 선언적 데이터 바인딩으로 한눈에 보는 정보를 표시하는 production-ready FlexCard 정의를 생성한다.

**TRIGGER:** FlexCard 생성, 데이터 소스 구성, 카드 레이아웃 설계, OmniUiCard 메타데이터 질문.
**DO NOT TRIGGER:** OmniScript 빌드 → `omnistudio-omniscript-generate` / IP 생성 → `omnistudio-integration-procedure-generate` / 의존성 분석 → `omnistudio-dependencies-analyze` / 메타데이터 배포 → `platform-metadata-deploy`.

### Key Insights
| Insight | Detail |
|---------|--------|
| Configuration 필드 | `OmniUiCard`는 데이터 소스 바인딩에 `DataSourceConfig`, 카드 레이아웃·states·actions에 `PropertySetConfig` 사용. Core 네임스페이스에 `Definition` 필드 **없음**. |
| 데이터 소스 바인딩 | 데이터 소스는 live data를 위해 IP에 바인딩 — FlexCard가 데이터를 가져오기 전 IP가 active·deploy 되어야 함 |
| Child card 임베딩 | FlexCard는 다른 FlexCard를 child card로 임베딩(composite 레이아웃) |
| OmniScript 실행 | action 버튼으로 OmniScript 실행, 카드 데이터 소스 컨텍스트를 OmniScript input으로 전달 |
| Designer virtual object | Designer는 `OmniFlexCardView`를 virtual list object(`/lightning/o/OmniFlexCardView/home`)로 사용, 레코드 저장 sObject `OmniUiCard`와 별개. API 생성 카드는 Designer에서 열기 전까지 "Recently Viewed"에 안 보일 수 있음 |

### CRITICAL: Orchestration Order
`omnistudio-dependencies-analyze → omnistudio-datamapper-generate → omnistudio-integration-procedure-generate → omnistudio-omniscript-generate → omnistudio-flexcard-generate` (현 위치). FlexCard는 **presentation layer** — IP에서 데이터를 소비하고 OmniScript를 실행. 데이터 계층 먼저, 표현 계층 나중.

---

## 워크플로 / 단계 (5-Phase 패턴)

### Phase 1 — Requirements Gathering
명확화: 카드 목적(레이아웃·데이터 밀도) / 필요 데이터 소스(IP 식별) / 실행 객체 컨텍스트(record-level vs list-level) / 노출 action(버튼·OmniScript 통합) / 적합 레이아웃(single/list/tabbed/flyout) / 조건부 표시 규칙.

### Phase 2 — Design & Layout
설계 전 `references/best-practices.md`(레이아웃 패턴·SLDS·접근성·성능) 읽기.

**Card Layout 옵션:** Single Card(레코드 요약) / Card List(배열 데이터 소스 반복) / Tabbed Card(다중 컨텍스트 tab) / Flyout Card(요약→상세 확장 패널).

**Data Source 구성:**
```
// 구조 예시 — 실제 동작 설정 아님
FlexCard → Data Source (type: IntegrationProcedure)
         → IP Name + Input Mapping
         → Response Field Mapping → Card Elements
```
IP 응답 필드를 `{datasource.fieldName}` merge 문법으로 매핑 / `{recordId}` 등 컨텍스트를 input parameter로 IP에 전달 / 다중 소스 시 data source 순서 설정.

**Action Button:** Launch OmniScript(Type+SubType·컨텍스트 param) / Navigate(레코드 ID·URL template) / Custom Action(platform event·LWC·payload mapping).

**Conditional Visibility:** 데이터 값 기반 필드·카드 state show/hide / 데이터 없을 때 empty-state 메시지.

### Phase 3 — Generation & Validation
`references/data-binding-guide.md`(merge 문법·소스 타입·다중 소스), `references/scoring-rubric.md`(130점) 읽기. 1. FlexCard 정의 JSON 생성 2. 모든 data source 참조가 active IP로 resolve 검증 3. 130점 채점 4. merge 필드 문법이 IP 응답 구조와 일치 검증 5. 모든 interactive element 접근성 속성 체크.

### Phase 4 — Deployment
1. upstream IP 전부 deploy·active 확인 2. `platform-metadata-deploy` 스킬 `--dry-run` 3. FlexCard 메타데이터(`OmniUiCard`) deploy(`sf project deploy start` 재실행 안전 — upsert) 4. target org 활성화 5. Lightning page·OmniScript·부모 FlexCard에 임베딩 6. 배포 실패 시: upstream IP 미배포(`Cannot find OmniIntegrationProcedure`), namespace prefix 누락(`Entity not found`), Draft 상태(retrieve 전 활성화).

### Phase 5 — Testing
| Scenario | Verify |
|----------|--------|
| Populated data | 전 필드 렌더링, merge 필드 resolve |
| Empty data | empty-state 표시, broken merge 필드 없음 |
| Error state | IP 오류·timeout 시 graceful 처리 |
| Multi-record | card list 항목 수·페이지네이션 |
| Action buttons | OmniScript가 pre-populated 데이터로 실행 |
| Conditional fields | 데이터 값 기반 visibility 토글 |
| Mobile | 작은 viewport 적응 |

---

## 핵심 규칙·가드레일

### Generation Guardrails — 피할 패턴
| Anti-Pattern | Why Wrong | Correct |
|--------------|-----------|---------|
| 존재하지 않는 IP 데이터 소스 참조 | 런타임 데이터 로드 실패 | 바인딩 전 IP 존재·active 검증 |
| 스타일에 하드코딩 색상 | SLDS theming·dark mode 깨짐 | SLDS design token·CSS custom property |
| 접근성 속성 누락 | WCAG 위반 | `aria-label`·`role`·keyboard handler |
| 과도한 nested child card | 깊은 nesting 성능 저하 | 최대 2 level, 가능하면 flatten |
| empty state 무시 | 데이터 없을 때 broken UI | 명시적 empty-state 메시지 |
| 하드코딩 레코드 ID | 환경 간 깨짐 | merge 필드·context 기반 param |

### Scoring Rubric (130점, 7 category)
**Thresholds:** ✅ 90+ (Deploy) / ⚠️ 67-89 (Review) / ❌ <67 (Block)
| Category | Points | Criteria |
|----------|--------|----------|
| Design & Layout | 25 | 적합 레이아웃, 논리적 필드 그룹, responsive, 일관 spacing, 시각 위계 |
| Data Binding | 20 | 올바른 IP 참조, merge 문법, input param 매핑, 다중 소스 조정 |
| Actions & Navigation | 20 | action 버튼 구성, OmniScript launch param, navigation target, 서술적 label |
| Styling | 20 | SLDS token(no 하드코딩 색상), 일관 typography, card/tile 패턴, dark mode |
| Accessibility | 15 | interactive element `aria-label`, keyboard navigable, color contrast, screen reader label |
| Testing | 15 | populated·empty·error·multi-record·mobile 검증 |
| Performance | 15 | 데이터 소스 호출 최소화, child nesting max 2, redundant IP 호출 없음, 비표시 state lazy load |

### Data Source Types
| Type | `dataSource.type` | When |
|------|-------------------|------|
| Integration Procedure | `IntegrationProcedures` (복수, 대문자 P) | 주 패턴; live data IP 호출 |
| SOQL | `SOQL` | 직접 쿼리(드물게; IP 선호) |
| Apex Remote | `ApexRemote` | 커스텀 Apex 호출 |
| REST | `REST` | Named Credential 외부 API |
| Custom | `Custom` | 커스텀 데이터 provider(JSON body 직접) |

**Field Mapping merge 문법:** `{ "Name": "Acme" }` → `{Name}` / `{ "Account": { "Name": ... } }` → `{Account.Name}` / `{ "records": [...] }` → `{records[0].Name}` 또는 Card List로 iterate. **Input param:** `{recordId}`(현 레코드 페이지), `{userId}`(running user), `{param.customKey}`(URL·부모 카드).

### Notes / Dependencies (핵심)
- OmniStudio(Industries Cloud) 라이선스 + `sf` CLI 인증 / 데이터 소스용 active IP / action용 active OmniScript / 점수 <67이면 배포 block
- **Idempotency:** `sf project deploy start`는 upsert — 재실행 안전
- **Namespace:** managed 패키지 org는 `omnistudio__OmniUiCard` prefix 가능(`sfdx-project.json` 확인)
- **프로그램 생성:** REST API(`sf api request rest --method POST --body @file.json`). 필수 필드 `Name`·`VersionNumber`·`OmniUiCardType`(예: `Child`), `DataSourceConfig`·`PropertySetConfig`는 JSON 문자열. `sf data create record --values`는 JSON textarea 불가. 생성 후 `IsActive=true`로 활성화.

### FlexCard vs LWC (요약)
FlexCard = 선언적·IP merge 필드·at-a-glance 정보·OmniStudio 프레임워크 한정 / LWC = 코드(JS/HTML/CSS)·wire·Apex·GraphQL·복잡 interactive UI·full 유연성. 표준 카드 레이아웃 + IP 데이터면 FlexCard, 커스텀 동작·애니메이션·복잡 state면 LWC.

---

## 번들 파일

| 경로 | 용도 |
|------|------|
| `assets/omni-ui-card.json` | Phase 3 — DataSourceConfig JSON 구조 포함 OmniUiCard 레코드 템플릿 |
| `references/best-practices.md` | Phase 2 — 레이아웃·SLDS·접근성·성능 가이드 |
| `references/data-binding-guide.md` | Phase 2-3 — 소스 타입·merge 문법·input param·다중 소스 조정 |
| `references/scoring-rubric.md` | Phase 3 — 7 category 130점 per-criterion 분해 |
| `scripts/flexcard-commands.sh` | Phase 4 — query·retrieve·deploy CLI 명령 |

**Output:** FlexCard JSON 정의 / DataSourceConfig 바인딩 블록 / PropertySetConfig 레이아웃 config / 130점 검증 리포트 / 배포 체크리스트.

---

## 관련 노트
- [[omnistudio-integration-procedure-generate]]
- [[omnistudio-omniscript-generate]]
- [[omnistudio-datamapper-generate]]
- [[omnistudio-dependencies-analyze]]
