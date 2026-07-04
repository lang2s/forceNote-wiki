---
tags: [agent-skill, sf-skills, omnistudio, omniscript, omniprocess, guided-flow]
source: forcedotcom/sf-skills (skills/omnistudio-omniscript-generate/SKILL.md, 공식 Salesforce); help.salesforce.com Enable OmniStudio Metadata API Support (sf.os_enable_omnistudio_metadata_api_support.htm) — Tier 2
created: 2026-06-26
aliases: [omnistudio-omniscript-generate, OmniStudio OmniScript 생성 스킬, 가이드형 디지털 경험, OmniProcess element, Type SubType Language]
---

# omnistudio-omniscript-generate — OmniStudio OmniScript 생성·검증 스킬

> 입력 수집·서버 로직(IP·DataRaptor) orchestration·결과 표시를 코드 없이 수행하는 다단계 가이드형 디지털 경험(OmniScript)을 생성·검증하고 120점 루브릭(6 category)으로 채점하는 에이전트 스킬.

---

## 목적과 활성화 조건

선언적·단계 기반 가이드형 디지털 경험을 위한 OmniStudio OmniScript 빌더. OmniScript는 OmniStudio의 Screen Flow 대응 — 다단계 interactive 프로세스로 입력 수집·서버 로직(IP·DataRaptor) orchestration·결과 표시를 모두 코드 없이 수행한다.

**TRIGGER:** OmniScript 생성, step flow 설계, element 타입 구성, 기존 OmniScript 검토.
**DO NOT TRIGGER:** FlexCard 빌드 → `omnistudio-flexcard-generate` / IP 직접 생성 → `omnistudio-integration-procedure-generate` / 의존성 분석 → `omnistudio-dependencies-analyze` / 메타데이터 배포 → `platform-metadata-deploy`.

### Required Inputs
| Input | Description | Default |
|-------|-------------|---------|
| Type | 프로세스 카테고리(예: `ServiceRequest`, `Enrollment`) | None — 필수 |
| SubType | 구체 variation(예: `NewCase`, `UpdateAddress`) | None — 필수 |
| Language | locale | `English` |
| Purpose | 가이드하는 비즈니스 프로세스 | None — 필수 |
| Target org | 배포 org alias | 현 default org |
| Data sources | 조회·갱신할 객체/API | 요구에서 식별 |

### Quick Reference
**Scoring:** 120점, 6 category. **Thresholds:** ✅ 90+ (Deploy) / ⚠️ 67-89 (Review) / ❌ <67 (Block).

### CRITICAL: Orchestration Order
`omnistudio-dependencies-analyze → omnistudio-datamapper-generate → omnistudio-integration-procedure-generate → omnistudio-omniscript-generate → omnistudio-flexcard-generate` (현 위치). OmniScript는 IP·DataRaptor를 소비 — 먼저 빌드. FlexCard는 OmniScript를 실행할 수 있음 — 나중. 시작 전 `omnistudio-dependencies-analyze`로 의존성 트리 매핑.

### Key Insights
| Insight | Details |
|---------|---------|
| Type/SubType/Language triplet | OmniScript를 고유 식별. 세 값 모두 필수·composite key. |
| PropertySetConfig | 모든 element 구성(layout·data binding·validation·conditional visibility)을 담는 JSON blob. 실제 로직이 여기 있음 |
| Core namespace | `IsIntegrationProcedure = false`인 OmniProcess(=`OmniProcessType='OmniScript'`). element는 child OmniProcessElement |
| Element hierarchy | Level/Order 필드로 tree. Level 0=Steps, Level 1+=step 내 element. Order가 level 내 순서 |
| Version management | 여러 버전 가능, triplet당 한 버전만 active. `IsActive`로 활성화 |
| Data JSON | 단일 JSON 데이터 구조가 모든 step 통과. element는 merge 필드로 공유 JSON read/write |

---

## 워크플로 / 단계 (5-Phase 패턴)

### Phase 1 — Requirements Gathering
**대안 평가 먼저:** OmniScript는 복잡한 다단계 가이드 프로세스에 최적. 단순 single-screen 입력은 Screen Flow, interaction 없는 데이터 표시는 FlexCard. 묻는다: Type·SubType·Language·Purpose·target org·data sources. 그다음 중복 회피 위해 기존 OmniScript 확인, 재사용 IP/DataRaptor 식별, 의존성 체인 매핑.

### Phase 2 — Design & Element Selection
**Container Elements:** Step(wizard 페이지 — `chartLabel`·`knowledgeOptions`·`show`) / Conditional Block(`conditionType`·`show`) / Loop Block(`loopData`) / Edit Block(`editFields`·`dataSource`).

**Input Elements:** Text(`pattern`)·Text Area(`maxLength`·`rows`)·Number(`min`·`max`·`step`·`format`)·Date·Date/Time·Checkbox·Radio(`options`)·Select(`optionSource`)·Multi-select(`maxSelections`)·Type Ahead(`dataSource`·`searchField`·`minCharacters`)·Signature(`penColor`)·File(`maxFileSize`·`allowedExtensions`)·Currency(`currencyCode`)·Email·Telephone(`mask`)·URL·Password(`minLength`)·Range·Time.

**Display Elements:** Text Block(`textContent`·`HTMLTemplateId`)·Headline(`level` h1-h6)·Aggregate(`aggregateExpression`)·Disclosure(`defaultExpanded`)·Image(`imageURL`·`altText`)·Chart(`chartType`).

**Action Elements:** DataRaptor Extract Action(`bundle`·`inputMap`·`outputMap`)·DataRaptor Load Action·Integration Procedure Action(`ipMethod`=Type_SubType·`inputMap`·`outputMap`·`remoteOptions`)·Remote Action(`remoteClass`·`remoteMethod`)·Navigate Action(`targetType`·`targetId`·`URL`)·DocuSign Envelope Action(`templateId`·`recipientMap`)·Email Action(`emailTemplateId`).

**Logic Elements:** Set Values(`elementValueMap`)·Validation(`validationFormula`·`errorMessage`)·Formula(`expression`·`dataType`)·Submit Action(`postMessage`·`preTransformBundle`·`postTransformBundle`).

### Phase 3 — Generation & Validation
중복 확인:
```bash
scripts/check-duplicate-omniscript.sh <Type> <SubType> <Language> <org>
```
빌드: 1. OmniProcess 레코드 생성(Type·SubType·Language·OmniProcessType='OmniScript') 2. Step별 OmniProcessElement(Level=0) 3. step 내 element OmniProcessElement(Level=1+, Order 정렬) 4. element별 PropertySetConfig JSON 5. action element를 IP/DataRaptor에 wire.

**Validation (STRICT MODE):**
- **BLOCK:** Type/SubType/Language 누락, 순환 OmniScript 임베딩, broken IP/DataRaptor 참조, 필수 PropertySetConfig 누락
- **WARN:** element 없는 Step, validation 없는 input, action error handling 누락, 미사용 data path, 깊은 nesting(>4 level)

리포트 형식(6-Category 0-120):
```
Score: 102/120 ---- Very Good
-- Design & Structure: 22/25 (88%)
-- Data Integration: 18/20 (90%)
-- Error Handling: 17/20 (85%)
-- Performance: 18/20 (90%)
-- User Experience: 17/20 (85%)
-- Security: 10/15 (67%)
```

### Phase 4 — Deployment

#### ⚠️ 전제조건 — OmniStudio Metadata API Support 활성화
`OmniProcess`/`OmniProcessElement` 메타데이터를 **Metadata API로 배포·retrieve하려면** 먼저 **Setup → OmniStudio Settings**에서 **OmniStudio Metadata**(Metadata API Support) 토글을 활성화해야 한다. 이 토글이 꺼진(managed-package runtime만 있는) 조직에서는 OmniProcess를 Metadata API로 다룰 수 없어 배포가 막힌다.

활성화 자체가 선행 조건을 요구한다 — 하나라도 불충족이면 활성화 실패:
1. 조직이 **standard object model**을 사용해야 함
2. 모든 컴포넌트가 **유효한 unique name**을 가져야 함 — 하나라도 무효면 활성화 실패 + 이메일 통지
3. **OmniStudio configuration 테이블에 기존 레코드가 없어야** 함(empty config tables)

> REST API로 직접 생성(Phase 3)하는 경로와 별개로, `platform-metadata-deploy`를 통한 메타데이터 배포·retrieve 흐름에는 이 활성화가 필수 전제다.

#### 배포 절차
1. org auth(`sf org display -o <org>`)·참조 DataRaptor/IP active 확인 2. 의존성(DataRaptor·IP·참조 OmniScript) 먼저 배포 3. `scripts/deploy-omniscript.sh <Name> <Type> <SubType> <org>`(배포·활성화 검증, 실패 시 recovery 출력) 4. 미자동 활성 시 버전 활성화.

### Phase 5 — Testing
happy path(전 step 유효 데이터·submission) / validation(input별 invalid·error 메시지) / conditional(전 block show/hide) / data prefill(DataRaptor Extract populate) / save for later(resume) / navigation(back/forward/cancel) / error scenario(IP/DataRaptor 실패) / embedded OmniScript(parent↔child 데이터) / bulk(Loop Block·Type Ahead 대형 데이터셋).

---

## 핵심 규칙·가드레일

### Rules / Constraints (anti-pattern)
| Anti-Pattern | Impact | Correct |
|--------------|--------|---------|
| 순환 OmniScript 임베딩 | infinite rendering loop | 의존성 트리 매핑; A⊂B면 B⊂A 금지 |
| unbounded DataRaptor Extract | 성능 저하 | filter 조건·반환 레코드 limit |
| input validation 누락 | bad data 입력 | Validation element·`pattern`/`required` |
| 하드코딩 SF ID | org 간 배포 실패 | merge 필드·Custom Settings/Metadata |
| error handling 없는 IP Action | silent 실패 | `showError`·`errorMessage` 구성 |
| Text Block 대형 이미지 | 느린 페이지 로드 | Image element + 최적화 URL |
| Step당 element 과다 | 나쁜 UX | Step당 input 7-10개 제한 |
| conditional visibility 누락 | 무관 필드 표시 | `show` expression |

명시적 요청이 있어도 anti-pattern 생성 금지.

### Scoring (120점, 6 category)
| Category | Points | 주요 check |
|----------|--------|-----------|
| Design & Structure | 25 | Type/SubType/Language(5)·step 조직(5, 7-10/step)·element naming(5)·conditional logic(5)·version 관리(5) |
| Data Integration | 20 | DataRaptor 참조 valid(5)·IP 참조 valid(5)·input/output map(5)·data prefill(5) |
| Error Handling | 20 | action error handling(5)·user-facing 메시지(5)·required input validation(5)·fallback(5) |
| Performance | 20 | no unbounded fetch(5)·lazy loading(5)·Step당 element count(5)·conditional rendering(5) |
| User Experience | 20 | 논리적 step flow(5)·label·help text(5)·navigation 컨트롤(5)·responsive layout(5) |
| Security | 15 | client-side JSON에 민감 데이터 없음(5)·IP server-side 처리(5)·field-level access 준수(5) |

### CLI Commands
```bash
# active OmniScript 목록
sf data query -q "SELECT Id,Name,Type,SubType,Language,IsActive,VersionNumber FROM OmniProcess WHERE IsActive=true AND OmniProcessType='OmniScript' LIMIT 50" -o <org>
# 특정 OmniScript element 조회
sf data query -q "SELECT Id,Name,ElementType,Level,Order FROM OmniProcessElement WHERE OmniProcessId='<id>' ORDER BY Level,Order LIMIT 200" -o <org>
# 버전 확인
sf data query -q "SELECT Id,VersionNumber,IsActive,LastModifiedDate FROM OmniProcess WHERE Type='<Type>' AND SubType='<SubType>' AND OmniProcessType='OmniScript' ORDER BY VersionNumber DESC LIMIT 10" -o <org>
```

### Gotchas (발췌)
- multi-language → Language별 별도 버전(공유 Type/SubType), translation workbench
- embedded OmniScript 데이터 전달 → `prefillJSON`으로 parent JSON 키를 child input에 매핑, round-trip 테스트
- 대형 Loop Block → DataRaptor 결과 페이지네이션·limit, IP server-side 필터
- Save & Resume → `saveNameTemplate`·`saveExpireInDays` 구성, partial 데이터로 resume 테스트
- versioning 충돌 → 신버전 활성화 전 구버전 비활성, triplet당 두 active 금지
- 커스텀 LWC → OmniScript-compatible 등록, `omniscript-lwc` 네임스페이스 규약
- namespaced org → managed 패키지 배포 시 bundle·API 이름에 prefix(예: `omnistudio__`)
- `OmniProcessType`은 create 시 set 불가 → `IsIntegrationProcedure`에서 computed(OmniScript는 false)

### Notes (핵심)
- API: 66.0 / Mode: Strict(warning이 block) / 점수 <67이면 배포 block
- **프로그램 생성:** REST API. 필수 필드 `Name`·`Type`·`SubType`·`Language`·`VersionNumber`. OmniScript는 `IsIntegrationProcedure=false` default — `OmniProcessType` 직접 set 금지(computed). 각 Step·element마다 child `OmniProcessElement` REST API 생성.

---

## 번들 파일

| 경로 | 용도 |
|------|------|
| `references/element-types.md` | Phase 2 — element 선택, PropertySetConfig 구성 전 필독 |
| `references/best-practices.md` | Phase 2-5 — step 설계·data prefill·validation·navigation·성능·troubleshooting |
| `assets/omni-process-omniscript.json` | Phase 3 — OmniProcess 레코드 템플릿 |
| `assets/omni-process-element-step.json` | Phase 3 — Step(Level=0) OmniProcessElement 템플릿 |
| `assets/omni-process-element-text-block.json` | Phase 3 — Text Block element 템플릿(다른 display element용 adapt) |
| `scripts/check-duplicate-omniscript.sh` | Phase 3 — 중복 Type/SubType/Language 확인 |
| `scripts/deploy-omniscript.sh` | Phase 4 — 배포·활성화 검증, 선행 체크·error recovery 포함 |
| `scripts/cli-reference.sh` | 전 phase — query·retrieve·deploy·verify CLI 전체 |

**Output:** OmniScript JSON / Step element JSON / 자식 element JSON / 120점 검증 리포트.

---

## 관련 노트
- [[omnistudio-integration-procedure-generate]]
- [[omnistudio-datamapper-generate]]
- [[omnistudio-flexcard-generate]]
- [[omnistudio-dependencies-analyze]]
