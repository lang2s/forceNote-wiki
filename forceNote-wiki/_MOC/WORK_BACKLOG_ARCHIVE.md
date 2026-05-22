---
tags: [backlog, coverage, work-tracking]
created: 2026-05-18
updated: 2026-05-23
---

# WORK_BACKLOG_ARCHIVE — 완료 작업 영속 대장

> 완료된(✅) 작업의 append-only 기록이다. **활성 백로그(열린 항목·lint 이력·프로토콜 개선)는 [[WORK_BACKLOG]] 참조.**
> 이 파일은 위에서 아래로 통독하지 않는다 — 특정 완료 항목의 근거(소스 페이지·완료일)를 조회할 때만 본다.

---

## 커버리지 현황 (2026-05-22 재산출 ✅)

| 소스 | 공개 대상 | 커버됨 | 작성 대상 누락 | 커버리지 |
|---|---|---|---|---|
| Apex Reference v67.0 (~70 네임스페이스) | 68개 (내부 전용 2개 제외) | 68개 | 0개 | **~100%** |

> ⚠️ 이전 수치("29개 / 42%")는 낡았음. 2026-05-22 PDF↔위키 재대조 결과 핵심 네임스페이스(System·Database·Schema·Auth·ConnectApi 등) 전부 커버. 누락은 니치 산업/커머스 6개뿐. 상세는 아래 "C — 커버리지 재산출".

---

## 사용 방법

- 새 항목 추가: wiki-retrospective(모드 B)가 추가
- 상태 업데이트: 해당 작업을 완료한 에이전트 또는 PM이 업데이트
- 완료 항목 정리: 분기마다 (약 30개 누적 시) archive 섹션으로 이동

---

## 완료 백로그 (아카이브)

### P1 — 즉시 작성 권장 (Apex Ref v67.0)

| # | 네임스페이스 | PDF 페이지 | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| P1-04 | Flow | p.2880 | `Apex/Integration(통합)/Flow Namespace.md` | ✅ 완료(2026-05-19) | 2026-05-19 |
| P1-05 | TxnSecurity | p.4445 | `Apex/Security(보안)/TxnSecurity Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 |
| P1-06 | Support | p.3580 | `Apex/Integration(통합)/Support Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 |
| P1-07 | Context | p.2688 | `Architecture(아키텍처)/Context Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 |
| P1-08 | Datacloud | p.2741 | `Apex/Data(데이터)/Datacloud Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 |

---

### P2 — 다음 사이클 (Apex Ref v67.0)

| # | 네임스페이스 | PDF 페이지 | 권장 파일 경로 | 상태 | 추가일 | 완료일 |
|---|---|---|---|---|---|---|
| P2-05 | ApexPages | p.10 | `Architecture(아키텍처)/ApexPages Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 | 2026-05-20 |
| P2-06 | AppLauncher | p.43 | `Architecture(아키텍처)/AppLauncher Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 | 2026-05-20 |
| P2-07 | LxScheduler | p.2980 | `Apex/Integration(통합)/LxScheduler Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 | 2026-05-20 |
| P2-08 | VisualEditor | p.4462 | `Architecture(아키텍처)/VisualEditor Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 | 2026-05-20 |
| P2-09 | Wave | p.4476 | `Apex/Data(데이터)/Wave Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 | 2026-05-20 |
| P2-10 | UserProvisioning | p.4454 | `Apex/Security(보안)/UserProvisioning Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 | 2026-05-20 |
| P2-11 | TerritoryMgmt | p.4441 | `Apex/Integration(통합)/TerritoryMgmt Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 | 2026-05-20 |
| P2-12 | Slack | p.3578 | `Apex/Integration(통합)/Slack Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 | 2026-05-20 |
| P2-13 | PlaceQuote | p.3208 | `Apex/Integration(통합)/PlaceQuote Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 | 2026-05-20 |

---

### P3 — 장기 계획 (Apex Ref v67.0 — 특수/Industries)

| # | 네임스페이스 | PDF 페이지 | 대상 | 상태 | 추가일 |
|---|---|---|---|---|---|
| P3-06 | Canvas | p.279 | `Architecture(아키텍처)/Canvas Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 |
| P3-07 | ChatterAnswers | p.299 | `Apex/Integration(통합)/ChatterAnswers Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 |
| P3-08 | CommerceBuyGrp | p.301 | `Apex/Integration(통합)/CommerceBuyGrp Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 |
| P3-09 | CommerceExtension | p.307 | `Apex/Integration(통합)/CommerceExtension Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 |
| P3-10 | CommerceOrders | p.316 | `Apex/Integration(통합)/CommerceOrders Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 |
| P3-11 | CommercePayments | p.317 | `Apex/Integration(통합)/CommercePayments Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 |
| P3-12 | CommerceTax | p.527 | Tax Integration ISV | ✅ 완료(2026-05-20) | 2026-05-19 |
| P3-13 | ComplianceMgmt | p.646 | Financial Services Cloud | ✅ 완료(2026-05-20) — 스텁(PDF 클래스 인벤토리만 수록, FSC 가이드 참조 필요) | 2026-05-19 |
| P3-14 | embeddedai | p.2859 | Einstein 내장 개발자 | ✅ 완료(2026-05-20) | 2026-05-19 |
| P3-15 | Functions | p.2905 | Salesforce Functions org | ✅ 완료(2026-05-20) | 2026-05-19 |
| P3-16 | ise_bots_apex | p.2921 | Einstein Bot 고급 커스텀 | ✅ 완료(2026-05-20) | 2026-05-19 |
| P3-17 | IssueCreditMemo | p.2925 | Revenue Cloud | ✅ 완료(2026-05-20) — 스텁(3개 클래스 인벤토리, Revenue Cloud 개발자 가이드 참조) | 2026-05-19 |
| P3-18 | InvoiceWriteOff | p.2966 | Revenue Cloud | ✅ 완료(2026-05-20) — 스텁(5개 클래스 인벤토리, Revenue Cloud 개발자 가이드 참조) | 2026-05-19 |
| P3-19 | IsvPartners | p.2966 | AppExchange ISV | ✅ 완료(2026-05-20) | 2026-05-19 |
| P3-20 | IndustriesDigitalLending | p.2928 | Financial Services Cloud | ✅ 완료(2026-05-20) — 스텁(5개 callable 클래스 인벤토리, industriesDigitalLending 공식 문서 참조) | 2026-05-19 |
| P3-21 | industriesNlpSvc | p.2926 | Industries AI | ✅ 완료(2026-05-20) | 2026-05-19 |
| P3-22 | Pref_center | p.3208 | Privacy Center org | ✅ 완료(2026-05-20) | 2026-05-19 |
| P3-23 | RichMessaging | p.3408 | Messaging for Web/In-App | ✅ 완료(2026-05-21) | 2026-05-19 |
| P3-24 | RevSignaling | p.3408 | Revenue Lifecycle Mgmt | ✅ 완료(2026-05-21) | 2026-05-19 |
| P3-25 | RevSalesTrxn | p.3408 | Revenue Cloud / CPQ | ✅ 완료(2026-05-21) | 2026-05-19 |
| P3-26 | RulesAppIn | p.3457 | Revenue Cloud | ✅ 완료(2026-05-21) | 2026-05-19 |
| P3-27 | runtime_industries_cpq | p.3458 | Industries CPQ | ✅ 완료(2026-05-21) | 2026-05-19 |
| P3-28 | runtime_industries_insurance | p.3458 | Insurance Cloud | ✅ 완료(2026-05-21) | 2026-05-19 |
| P3-29 | Sfc | p.3554 | Files 커스텀 처리 | ✅ 완료(2026-05-21) | 2026-05-19 |
| P3-30 | Sfdc_Checkout | p.3558 | B2B Commerce 전문 | ✅ 완료(2026-05-21) | 2026-05-19 |
| P3-31 | Sfdc_Enablement | p.3563 | Enablement 앱 | ✅ 완료(2026-05-21) | 2026-05-19 |
| P3-32 | sfdc_surveys | p.3573 | Surveys 기능 | ✅ 완료(2026-05-21) | 2026-05-19 |
| P3-33 | renew_assets_summary | p.3285 | Revenue Cloud | ✅ 완료(2026-05-21) — 스텁(2개 클래스 인벤토리, Revenue Cloud 개발자 가이드 참조) | 2026-05-19 |
| P3-34 | fsccashflow | p.2894 | Financial Services Cloud | ✅ 완료(2026-05-21) | 2026-05-19 |
| P3-35 | ind_mfg_sample_mgmt_apex | p.2925 | Manufacturing Cloud | ✅ 완료(2026-05-20) — 스텁(3개 클래스 인벤토리, Manufacturing Cloud 개발자 가이드 참조) | 2026-05-19 |

---

### 신규 소스 PDF — 즉시 작성 권장

> **배경:** 2026-05-21 `Salesforce Documents/` 신규 PDF 13개 발견. Apex Reference 외 첫 대규모 소스 확장.

| # | 주제 | 소스 PDF | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| N1-01 | SOQL/SOSL 기초 문법 (SELECT, WHERE, 관계 쿼리, 집계 함수, SOSL 구문 전체) | `salesforce_soql_sosl.pdf` (v67.0 Summer '26) | `Apex/Data(데이터)/SOQL 문법 레퍼런스.md` | ✅ 완료(2026-05-21) | 2026-05-21 |
| N1-02 | Governor Limits 빠른 참조 (SOQL 한도, DML 한도, Heap, CPU, Callout, API 한도 전체) | `salesforce_app_limits_cheatsheet.pdf` (Summer '26) | `Architecture(아키텍처)/Governor Limits 빠른 참조.md` | ✅ 완료(2026-05-21) | 2026-05-21 |

---

### 신규 소스 PDF — 다음 사이클

| # | 주제 | 소스 PDF | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| N2-01 | Change Data Capture — 변경 이벤트 구독·처리·갭 이벤트 | `salesforce_change_data_capture.pdf` (v66.0 Spring '26) | `Apex/PlatformEvents(플랫폼이벤트)/Change Data Capture.md` | ✅ 완료(2026-05-21) | 2026-05-21 |
| N2-02 | Validation Rules 예제 모음 (Account, Contact, Opportunity 등 주요 객체) | `salesforce_useful_validation_formulas.pdf` (Spring '26) | `Architecture(아키텍처)/Validation Rules 예제.md` | ✅ 완료(2026-05-21) | 2026-05-21 |
| N2-03 | UI API 개요 (getRecord, getFieldValue, wire 어댑터 전체 목록 + LWC 통합) | `api_ui.pdf` (v67.0 Summer '26) | `LWC/LDS/UI API 개요.md` | ✅ 완료(2026-05-22) | 2026-05-21 |

---


### L — 깨진 wikilink — 신규 파일 필요 (wiki-linter 2026-05-21)

> 2026-05-21 `/lint` 결과. 6개 링크는 즉시 수정 완료. 아래 9개는 대상 파일 없어 신규 작성 필요.
> `[[Spring '26]]`은 P2-02와 동일 항목.

| # | 깨진 링크 | 참조 위치 | 권장 파일 경로 | 우선순위 | 상태 | 추가일 |
|---|---|---|---|---|---|---|
| L-02 | `[[LWC API 버전 관리]]` | `Release/Winter '24.md` | `LWC/ComponentAPI(컴포넌트API)/LWC API 버전 관리.md` | P2 | ✅ 완료(2026-05-22) | 2026-05-21 |
| L-03 | `[[Custom Metadata Types]]` | `Release/Winter '24.md` 외 | `Architecture(아키텍처)/Custom Metadata Types.md` | P2 | ✅ 완료(2026-05-22) | 2026-05-21 |
| L-04 | `[[lightning-tabset]]` | LWC BaseComponents index | `LWC/BaseComponents(베이스컴포넌트)/lightning-tabset.md` | P3 (→ P3-05 연관) | ✅ 완료(2026-05-22) | 2026-05-21 |
| L-05 | `[[DevOps Center]]` | Release 노트 | `Architecture(아키텍처)/DevOps Center.md` | P3 | ✅ 완료(2026-05-23) | 2026-05-21 |
| L-06 | `[[Enhanced Domains]]` | Release 노트 | `Architecture(아키텍처)/Enhanced Domains.md` | P3 | ✅ 완료(2026-05-23) | 2026-05-21 |
| L-07 | `[[External Services]]` | `Release/Winter '26.md` | `Integration(통합)/External Services.md` | P3 | ✅ 완료(2026-05-23) | 2026-05-21 |
| L-08 | `[[Platform Encryption]]` | Release 노트 | `Apex/Security(보안)/Platform Encryption.md` | P3 | ✅ 완료(2026-05-23) | 2026-05-21 |
| L-09 | `[[SLDS LWC 디자인 시스템]]` | LWC 관련 노트 | `LWC/UIPatterns(UI패턴)/SLDS LWC 디자인 시스템.md` | P3 | ✅ 완료(2026-05-23) | 2026-05-21 |

---

### I — 깨진 인덱스 경로 — 샤드 등재됐으나 파일 없음 (lint 2026-05-21)

> 2026-05-21 `/lint` 결과. 키워드 샤드가 존재하지 않는 파일을 가리키던 8건.
> 2건은 실존 유사 파일로 **재연결 완료**(백로그 불필요): `Governor Limits 빠른 참조` → `Apex/ExecutionContext(실행컨텍스트)/Governor Limits.md`, `Change Data Capture` → `Apex/PlatformEvents(플랫폼이벤트)/ChangeEventHeader.md`.
> 아래 6건은 대상 파일 없어 샤드에서 행 제거 + 신규 작성 대기. (제거된 키워드는 작성 시 복원)

| # | 제거된 항목 | 제거 위치 | 권장 파일 경로 | 우선순위 | 상태 | 추가일 |
|---|---|---|---|---|---|---|
| I-01 | Validation Rules 예제 (키워드 7행: REGEX/SSN/우편번호/날짜/숫자/소유자 검증 등) | `_index/apex-core.md` | `Architecture(아키텍처)/Validation Rules 예제.md` | P2 | ✅ 완료(2026-05-22) — 파일 신규 작성 + 키워드 복원 | 2026-05-21 |
| I-02 | fsccashflow Namespace | `_index/apex-namespaces.md` | `Apex/Integration(통합)/fsccashflow Namespace.md` | P3 | ✅ 완료(2026-05-23) | 2026-05-21 |
| I-03 | renew_assets_summary Namespace | `_index/apex-namespaces.md` | `Apex/Integration(통합)/renew_assets_summary Namespace.md` | P3 | ✅ 완료(2026-05-23) | 2026-05-21 |
| I-04 | Sfdc_Checkout Namespace | `_index/apex-namespaces.md` | `Apex/Integration(통합)/Sfdc_Checkout Namespace.md` | P3 | ✅ 완료(2026-05-23) | 2026-05-21 |
| I-05 | Sfdc_Enablement Namespace | `_index/apex-namespaces.md` | `Apex/Integration(통합)/Sfdc_Enablement Namespace.md` | P3 | ✅ 완료(2026-05-23) | 2026-05-21 |
| I-06 | sfdc_surveys Namespace | `_index/apex-namespaces.md` | `Apex/Integration(통합)/sfdc_surveys Namespace.md` | P3 | ✅ 완료(2026-05-23) | 2026-05-21 |

---

### C — 커버리지 재산출 (2026-05-22, wiki-retrospective 모드 B)

> `pdftotext "Salesforce Documents/salesforce_apex_reference_guide.pdf"` → 네임스페이스 헤딩(`^X Namespace$`) 추출 ↔ `find forceNote-wiki -name "*Namespace*.md"` 대조.
> **~70개 중 63개 커버(~93%).** 핵심은 전부 있음. 누락은 니치뿐.

**내부 전용 — 작성 제외** (PDF가 "reserved for internal use only" 명시):
- `flowuiruntime`, `setup_flow_performance`

**작성 대상 누락 네임스페이스 6개:**

| # | 네임스페이스 | 설명 (PDF) | 우선순위 | 권장 경로 | 비고 |
|---|---|---|---|---|---|
| C-01 | DataRetrieval | 상담원-고객 engagement 상세 + 대화 transcript (Engagement·RecordTranscripts 등) | P2 | `Apex/Integration(통합)/DataRetrieval Namespace.md` | ✅ 완료(2026-05-22) — 스텁(PDF p.2761 클래스 인벤토리만 수록, 상세는 Service Cloud 개발자 가이드 참조) |
| C-02 | Sfdc_Checkout | B2B Commerce 체크아웃 (AsyncCartProcessor·B2BCheckoutController 등) | P2 | `Apex/Integration(통합)/Sfdc_Checkout Namespace.md` | ✅ 완료(2026-05-23) — = I-04 |
| C-03 | fsccashflow | FSC CashFlow Flexcard 유틸 (FSCCashFlowUtil) | P3 | `Apex/Integration(통합)/fsccashflow Namespace.md` | ✅ 완료(2026-05-23) — = I-02 |
| C-04 | renew_assets_summary | 갱신 가능 자산 → 갱신 Opportunity (Revenue Cloud) | P3 | `Apex/Integration(통합)/renew_assets_summary Namespace.md` | ✅ 완료(2026-05-23) — = I-03 |
| C-05 | Sfdc_Enablement | Enablement/Sales Programs 학습 평가 (LearningEvaluation 등) | P3 | `Apex/Integration(통합)/Sfdc_Enablement Namespace.md` | ✅ 완료(2026-05-23) — = I-05 |
| C-06 | sfdc_surveys | 설문 초대 링크 단축 (SurveyInvitationLinkShortener) | P3 | `Apex/Integration(통합)/sfdc_surveys Namespace.md` | ✅ 완료(2026-05-23) — = I-06 |

**확인 사항:**
- `industriesNlpSvc`: 위키 커버 확인됨 (헤딩 추출엔 안 잡혔으나 페이지 존재).
- `RulesAppIn Namespace.md`: PDF 표기는 `RulesAppln` (Rules Application). 위키 파일명이 오타(`I`↔`l`)일 수 있음 — 내용은 커버됨. **파일명 검토 권장**.

**배치 실행 계획 (Step 2/3):**
- **배치 A (P2, 2개):** C-01 DataRetrieval, C-02 Sfdc_Checkout
- **배치 B (P3, 4개):** C-03 fsccashflow, C-04 renew_assets_summary, C-05 Sfdc_Enablement, C-06 sfdc_surveys
- 각 페이지: 표준 파이프라인 1회전 (scout→researcher→classifier→writer ∥ coverage-checker→completeness-validator(깊이)→source-verifier→index-manager(샤드 `apex-namespaces`)→cross-linker→qa→wiki-retrospective A). PDF 소스 라인은 위 grep 기준 — DataRetrieval≈98786, Sfdc_Checkout≈117968, fsccashflow≈101997, renew_assets_summary≈111194, Sfdc_Enablement≈118087, sfdc_surveys≈118337.

> ✅ **2026-05-22 깊이 감사 완료:** Database·Schema 두 파일 전수 보완 완료.
> - **Schema** (306 → 692줄): SObjectType·SObjectField·SObjectDescribeOptions·FieldDescribeOptions·SOAPType(전수)·DisplayType(누락 14개)·DescribeSObjectResult 누락 메서드 13개·DescribeFieldResult 누락 메서드 15개·DataCategory·DataCategoryGroupSobjectTypePair·DescribeColorResult·DescribeDataCategoryGroupResult·DescribeDataCategoryGroupStructureResult·DescribeIconResult·DescribeTabResult·DescribeTabSetResult 추가
> - **Database** (519 → 604줄): DMLOptions.localeOptions·AssignmentRuleHeader.assignmentRuleId·DuplicateRuleHeader.runAsCurrentUser·DMLOptions 프로퍼티 전수 표·QueryLocatorIterator 클래스 메서드 문서화 추가
> - System(V-09)·ConnectApi(V-10)·Auth 는 기존 검증 완료로 이번 사이클 스킵.
> 🔎 **다음 권장:** ConnectApi Namespace 개요(V-10)는 2,000페이지 분량 — 깊이보다 breadth 우선이므로 현재 유지. N2-03(UI API 개요), L-02·L-03(깨진 링크) 작성이 다음 P2.

---

### SO — sObject Reference 챕터 세부 페이지 확장 (object_reference.pdf v67.0)

> **배경:** 2026-05-22. 기존 `sObject/Ch1~Ch6` 챕터 요약 페이지를 PDF 원문 기준 세부 서브페이지로 분화.
> Ch1~Ch5는 각 개념·오브젝트별 개별 세부 페이지(문서 많아도 OK), Ch6는 서비스 클라우드 도메인별 분류 페이지.
> 소스: `Salesforce Documents/object_reference.pdf` (v67.0) — 물리 페이지 = 문서 페이지 + 42 (오프셋).
> **작성 순서:** Ch1 → Ch2 → Ch3 → Ch4 → Ch5 순서로 진행. Ch6는 도메인 분류만 (상세 설명 불필요).

---
> #### ▶ 다음 세션 재개 지점
>
> **sObject Reference 전체 완료 (Ch1~Ch6, 31개 서브페이지)**
>
> - Ch1 (10개) ✅ · Ch2 (3개) ✅ · Ch3 (4개) ✅ · Ch4 (3개) ✅ · Ch5 (3개) ✅ · Ch6 (8개) ✅
>
> **다음 권장 작업:** 백로그 N3 시리즈 (Experience Cloud·Reports API·Tooling API 등) 또는 `/lint` 전체 점검
---

#### SO-Ch1 — Overview of Salesforce Objects and Fields (doc pp.1–39 / 물리 pp.43–81)

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| SO-C1-01 | Primitive Data Types — base64·boolean·byte·date·dateTime·double·int·long·string·time 10개 타입 전수 설명 | p.1–3 | `sObject/Primitive Data Types.md` | ✅ 완료 | 2026-05-22 |
| SO-C1-02 | Field Types — address·anyType·calculated·combobox·currency·DataCategoryGroupReference·email·encryptedstring·ID·JunctionIdList·location·masterrecord·multipicklist·percent·phone·picklist·reference·textarea·url + reserved 2개 전수 | p.4–10 | `sObject/Field Types.md` | ✅ 완료 | 2026-05-22 |
| SO-C1-03 | API Field Properties — Aggregatable·Autonumber·Create·Defaulted on create·Delete·Filter·Group·idLookup·Namepointing·Nillable·Query·Restricted picklist·Retrieve·Sort·Update 15개 전수 | p.11–12 | `sObject/API Field Properties.md` | ✅ 완료 | 2026-05-22 |
| SO-C1-04 | System Fields & Required Fields — Id·IsDeleted·LastReferencedDate·LastViewedDate·CreatedById·CreatedDate·LastModifiedById·LastModifiedDate·SystemModstamp + Audit Fields 규칙 + Frequently Occurring Fields (OwnerId·RecordTypeId·CurrencyIsoCode) | p.12–15 | `sObject/System Fields.md` | ✅ 완료 | 2026-05-22 |
| SO-C1-05 | Compound Fields — Address 복합 필드 (서브필드 전수·SOQL GEOLOCATION 활용·DISTANCE 예제), Geolocation 복합 필드 (Location 타입·`__latitude__s`/`__longitude__s` 표기), 복합 필드 제한사항 전수 | p.15–20 | `sObject/Compound Fields.md` | ✅ 완료 | 2026-05-22 |
| SO-C1-06 | Custom Objects — 이름 규칙·관계(Master-Detail 불가 표준 오브젝트 목록)·Audit Fields 설정 절차·Sharing 오브젝트(__Share)·Tags 오브젝트(__Tag)·Required Fields(nillable)·Managed Packages 네임스페이스 prefix | p.21–23 | `sObject/Custom Objects.md` | ✅ 완료 | 2026-05-22 |
| SO-C1-07 | Custom Fields — 이름 규칙·External ID(text/number/email 전용)·Uniqueness(caseSensitive)·Default Values 수식 제한·Managed Packages prefix 변환 | p.24–25 | `sObject/Custom Fields.md` | ✅ 완료 | 2026-05-22 |
| SO-C1-08 | Object Relationships & Data Access — Master-Detail·Many-to-many(Junction)·Lookup 비교표, 데이터 접근 팩터(OLS·FLS·User Permissions·Sharing·Referential Integrity·Page Layouts 비적용), View All / Modify All 권한 | p.25–29 | `sObject/Object Relationships.md` | ✅ 완료 | 2026-05-22 |
| SO-C1-09 | External Objects — Salesforce Connect 어댑터(Cross-org·OData 2.0·OData 4.0·Custom Apex), Files Connect 어댑터(Google Drive·Box·SharePoint·OneDrive), External Object 관계(External Lookup·Indirect Lookup) | p.29–31 | `sObject/External Objects.md` | ✅ 완료 | 2026-05-22 |
| SO-C1-10 | Big Objects — Standard(__b) vs Custom(__b), Use Cases(360° 뷰·감사·Historical Archive), sObject와 차이(비트랜잭션·분산DB), Metadata 정의 XML 전수(CustomObject·CustomField·Index·IndexField), Deploy·View 절차 | p.31–38 | `sObject/Big Objects.md` | ✅ 완료 | 2026-05-22 |

#### SO-Ch2 — Salesforce Object Behavior (doc pp.40–54 / 물리 pp.82–96)

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| SO-C2-01 | Object Groups — Common Objects (Original·Base Platform·Setup Platform·Custom), Cloud Objects, High-Scale Objects, External Data; 데이터 도메인별·트랜잭션 유형별(ACID/OLTP/OLAP) 분류 | p.40–44 | `sObject/Object Groups.md` | ✅ 완료(2026-05-22) | 2026-05-22 |
| SO-C2-02 | Data Cloud Objects — DLO·DMO·UDLO·UDMO·CIO·Data Graphs·Unified Objects·Zero Copy 정의 + DMO/UDMO 생성 흐름(DLO→DMO→Identity Resolution→UDMO→CIO→DG) | p.44–51 | `sObject/Data Cloud Objects.md` | ✅ 완료(2026-05-22) | 2026-05-22 |
| SO-C2-03 | Object Types Reference & Cheatsheet — suffix 표 전수(__b·__c·__ChangeEvent·__chn·__cio·__dg·__DataCategorySelection·__dlm·__dlo·__dmo·__dso·__e·__Feed·__hd·__History·__mdt·__x 등), 오브젝트 타입별 Cheatsheet(Customizable·Cloud·Packaging·Documentation) | p.51–54 | `sObject/Object Types Reference.md` | ✅ 완료(2026-05-22) | 2026-05-22 |

#### SO-Ch3 — Associated Objects (doc pp.55–77 / 물리 pp.97–119)

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| SO-C3-01 | Feed Objects (StandardObjectNameFeed) — 전체 필드 참조표(BestCommentId·Body·CommentCount·ConnectionId·ContentData·ContentFileName·ContentSize·ContentType·FeedPostId·InsertedById·IsRichText 지원 HTML 태그·LikeCount·LinkUrl·NetworkScope·ParentId·RelatedRecordId·Title·Type·Visibility), Type picklist 20+개 값 전수, SOQL 제한 | p.55–62 | `sObject/Feed Objects.md` | ✅ 완료(2026-05-22) | 2026-05-22 |
| SO-C3-02 | History Objects (StandardObjectNameHistory) — 필드 참조표(StandardObjectNameId·DataType·Field·NewValue·OldValue), 지원 호출 전수, v42.0+ delete() 활성화 방법 | p.63–64 | `sObject/History Objects.md` | ✅ 완료(2026-05-22) | 2026-05-22 |
| SO-C3-03 | Share & OwnerSharingRule Objects — Share 필드(AccessLevel·ParentId·RowCause·UserOrGroupId)·OwnerSharingRule 필드(AccessLevel·Description·DeveloperName·GroupId·Name·UserOrGroupId), RowCause=Manual 전용 쓰기 규칙 | p.65–67 | `sObject/Share Objects.md` | ✅ 완료(2026-05-22) | 2026-05-22 |
| SO-C3-04 | ChangeEvent Objects (CDC) — 전체 필드·ChangeEventHeader 상세(entityName·recordIds·changeType·changeOrigin·transactionKey·sequenceNumber·commitTimestamp·commitUser), JSON 이벤트 메시지 예제, CDC 지원 오브젝트 목록 전수(100+개), replayId·schema 필드 | p.68–77 | `sObject/ChangeEvent Objects.md` | ✅ 완료(2026-05-22) | 2026-05-22 |

#### SO-Ch4 — Custom Objects (doc pp.78–94 / 물리 pp.120–136)

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| SO-C4-01 | Custom Metadata Type (__mdt) — 전체 필드 참조표(Custom Field__c·DeveloperName·isProtected·Label·Language·MasterLabel·NamespacePrefix·QualifiedApiName·SystemModStamp), isProtected 관리 패키지 접근 규칙(동일 패키지·타 패키지·구독자 코드 규칙) | p.80–82 | `sObject/Custom Metadata Type (__mdt).md` | ✅ 완료(2026-05-22) | 2026-05-22 |
| SO-C4-02 | Custom Object Standard Fields (__c) — 전체 표준 필드 참조표(ConnectionReceivedId·ConnectionSentId·CreatedById·CreatedDate·CurrencyIsoCode·Id·IsDeleted·LastActivityDate·LastModifiedDate·LastModifiedById·LastReferencedDate·LastViewedDate·Name·OwnerId·RecordTypeId·SystemModStamp) + 지원 호출 전수 | p.83–87 | `sObject/Custom Object Standard Fields (__c).md` | ✅ 완료(2026-05-22) | 2026-05-22 |
| SO-C4-03 | Custom Object Feed (__Feed) — 전체 필드 참조표(BestCommentId·Body·CommentCount·ConnectionId·ContentData·ContentFileName·ContentSize·ContentType·FeedPostId·InsertedById·IsRichText·LikeCount·LinkUrl·NetworkScope·ParentId·RelatedRecordId·Title·Type·Visibility), SOQL 제한, 삭제 접근 규칙 | p.87–94 | `sObject/Custom Object Feed (__Feed).md` | ✅ 완료(2026-05-22) | 2026-05-22 |

#### SO-Ch5 — Object Interfaces (doc pp.95–104 / 물리 pp.137–146)

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| SO-C5-01 | PriceAdjustmentGroup Interface — 전체 필드 참조표(AdjustmentSource·AdjustmentType·AdjustmentValue·Description·ImplementorType·PriceAdjustmentCauseId·Priority·SalesTransactionId·TotalAmount), AdjustmentSource picklist 값(Discretionary·Promotion·Rule·System), 사용 조건(Subscription Management / B2B Commerce) | p.96–97 | `sObject/PriceAdjustmentGroup.md` | ✅ 완료(2026-05-22) | 2026-05-22 |
| SO-C5-02 | PriceAdjustmentItem Interface — 전체 필드 참조표(AdjustmentAmountScope·AdjustmentSource·AdjustmentType·AdjustmentValue·Description·ImplementorType·PriceAdjustmentCauseId·PriceAdjustmentGroupId·Priority·SalesTransactionItemId·TotalAmount), AdjustmentAmountScope (Total vs Unit) 수식 계산 예제 | p.98–102 | `sObject/PriceAdjustmentItem.md` | ✅ 완료(2026-05-22) | 2026-05-22 |
| SO-C5-03 | SalesTransaction Interface — 전체 필드 참조표(ImplementorType·TotalAdjustmentAmount·TotalAdjustmentDistAmount·TotalAmount·TotalListAmount·TotalProductAmount), 사용 조건(Subscription Management / B2B Commerce), 구현체 오브젝트 패턴(Order·WebCart 등) | p.103–104 | `sObject/SalesTransaction.md` | ✅ 완료(2026-05-22) | 2026-05-22 |

#### SO-Ch6 — Standard Objects 도메인 분류 (object_reference.pdf — Ch6 범위)

> Ch6는 각 Standard Object별 상세 설명 없이 **서비스 클라우드 도메인별 오브젝트 목록 분류**만 작성.

| # | 도메인 | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|
| SO-C6-01 | Core CRM — Account·Contact·Lead·Opportunity·Campaign·Case·Contract·Pricebook2·Product2·Quote 등 | `sObject/Core CRM Objects.md` | ✅ 완료(2026-05-22) | 2026-05-22 |
| SO-C6-02 | Service Cloud — Entitlement·ServiceContract·SocialPost·LiveChatTranscript·MessagingSession·Knowledge__kav 등 | `sObject/Service Cloud Objects.md` | ✅ 완료(2026-05-22) | 2026-05-22 |
| SO-C6-03 | B2B Commerce & Revenue — WebCart·CartItem·WebStore·OrderSummary·PendingOrderSummary 등 | `sObject/B2B Commerce Objects.md` | ✅ 완료(2026-05-22) | 2026-05-22 |
| SO-C6-04 | Field Service — ServiceAppointment·ServiceResource·ServiceTerritory·WorkOrder·MaintenancePlan 등 | `sObject/Field Service Objects.md` | ✅ 완료(2026-05-22) | 2026-05-22 |
| SO-C6-05 | Platform & Admin — User·Group·Profile·PermissionSet·RecordType·FlowRecord·CustomField·CustomObject 등 | `sObject/Platform Admin Objects.md` | ✅ 완료(2026-05-22) | 2026-05-22 |
| SO-C6-06 | Files & Content — ContentDocument·ContentVersion·ContentDocumentLink·ContentFolder 등 | `sObject/Files Objects.md` | ✅ 완료(2026-05-22) | 2026-05-22 |
| SO-C6-07 | Analytics & Data Cloud — WaveAutoInstallRequest·DataUsePurpose·DataUseLegalBasis 등 | `sObject/Analytics Objects.md` | ✅ 완료(2026-05-22) | 2026-05-22 |
| SO-C6-08 | Experience Cloud & Collaboration — Network·CollaborationGroup·Topic·FeedItem 등 | `sObject/Experience Cloud Objects.md` | ✅ 완료(2026-05-22) | 2026-05-22 |

---

### DX — Salesforce DX Developer Guide 전수 작성 (sfdx_dev.pdf v67.0 Summer '26)

> **배경:** 2026-05-22. 소스: `Salesforce Documents/sfdx_dev.pdf` = *Salesforce DX Developer Guide* Version 67.0 (Summer '26), 364페이지, 16개 챕터. 추출 텍스트 `/tmp/sfdx_dev.txt` (세션 간 미유지 — 재추출은 scout 담당). PDF에 stream length 경고가 있어 일부 페이지는 재추출 필요할 수 있음.
> **오프셋 주의:** 위 페이지(p.)는 모두 **문서(doc) 페이지** 기준. 추출 텍스트 라인 기준 챕터 시작: Ch1≈L231·Ch2≈L897·Ch3≈L1323·Ch4≈L2779·Ch5≈L3479·Ch6≈L3494·Ch7≈L10025·Ch8≈L10463·Ch9≈L10973·Ch10≈L11512·Ch11≈L12335·Ch12≈L13100·Ch13≈L13375·Ch14≈L16765·Ch15≈L17561·Ch16≈L17992.
> **기존 커버리지(중복 분석):** `DevOps(데브옵스)/` 4개 노트(`Salesforce DX 개요`·`Scratch Org 패턴`·`Unlocked Package 패턴`·`CI CD 패턴`)는 모두 **핵심 명령만 발췌한 패턴 요약 수준**으로, 깊이 원칙(전수)을 충족하지 못한다. 전략: 기존 4개 노트는 각 도메인 **허브/요약**으로 유지(중복 키워드 행 금지), 세부는 신규 심층 서브페이지로 분화. `1 페이지 = 1 홈 샤드` 규칙 준수.
> **폴더:** 전부 `DevOps(데브옵스)/` 하위(English(한글) 규칙). 대형 챕터(Ch6 Scratch Orgs, Ch13 Unlocked Packages)는 한 파일이 커지면 아래 제안대로 서브 분할.
> **우선순위:** P1 = 핵심 워크플로우(Project Setup·Authorization·Scratch Orgs·Source Tracking·Development). P2 = 보조 워크플로우(Access·Sandboxes·Data·Build/Release·Packages·CI). P3 = 주변(How DX·Metadata Coverage·MCP Beta·Troubleshoot·Limitations).
> **작성 순서 권장:** P1(DX-C3 → DX-C4 → DX-C6 → DX-C8 → DX-C11) → P2 → P3.

#### DX-C1 — How DX Tooling Changes the Way You Work (doc p.1–14 / ~L231)

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| DX-C1-01 | DX 도구가 바꾸는 개발 방식 — Get Started/Sample Repo, Create App, Migrate Source, Release Notes 개요. 기존 `Salesforce DX 개요`의 도입부 보완 또는 신규 개요 페이지 | p.1–14 | `DevOps(데브옵스)/DX 도구 개요와 워크플로 전환.md` (신규) | ✅ 완료(2026-05-23) | 2026-05-22 |

#### DX-C2 — Provide Developers Access to DX Tools (doc p.15–23 / ~L897)

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| DX-C2-01 | DX 도구 접근 권한 — Dev Hub 활성화, Source Tracking 활성화, DX 사용자/라이선스/Permission Set 부여 전수 | p.15–23 | `DevOps(데브옵스)/DX 도구 접근 권한.md` (신규) | ✅ 완료(2026-05-23) | 2026-05-22 |

#### DX-C3 — Project Setup (doc p.24–56 / ~L1323) — P1

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| DX-C3-01 | DX Project 구조 & Source Format — 프로젝트 생성, 소스 포맷 개념, 프로젝트 디렉토리 구조. 기존 `Salesforce DX 개요`와 일부 중복(요약 수준) → 심층 신규 | p.24–35 | `DevOps(데브옵스)/DX 프로젝트 구조와 소스 포맷.md` (신규) | ✅ 완료(2026-05-22) | 2026-05-22 |
| DX-C3-02 | Decomposed Metadata Types & .forceignore — 기본/선택 분해(Beta) 전수, decompose 동작 명령, `.forceignore` 문법·예제 전수. 기존 `Salesforce DX 개요` 요약분 → 심층 신규 | p.35–45 | `DevOps(데브옵스)/메타데이터 분해와 forceignore.md` (신규) | ✅ 완료(2026-05-22) | 2026-05-22 |
| DX-C3-03 | sfdx-project.json 전체 설정 — 모든 필드 전수(packageDirectories·namespace·sourceApiVersion·sfdcLoginUrl·plugins·packageAliases 등), Multiple Package Directories, String Replacement, namespace 링크 | p.45–56 | `DevOps(데브옵스)/sfdx-project.json 레퍼런스.md` (신규) | ✅ 완료(2026-05-22) | 2026-05-22 |

#### DX-C4 — Authorization (doc p.57–70 / ~L2779) — P1

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| DX-C4-01 | DX 인증 전수 — 브라우저 로그인, JWT Flow(Private Key/Cert 생성 절차 포함), External Client App, Connected App, SFDX Auth URL, Logout. 기존 `Salesforce DX 개요`·`CI CD 패턴`의 JWT 요약분 → 심층 통합 신규 | p.57–70 | `DevOps(데브옵스)/DX 인증 방식.md` (신규) | ✅ 완료(2026-05-22) | 2026-05-22 |

#### DX-C5 — Metadata Coverage (doc p.71 / ~L3479) — P3

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| DX-C5-01 | Metadata Coverage Report — 메타데이터 커버리지 보고서 사용법(짧은 챕터). DX-C1 개요 페이지에 통합 또는 단독 짧은 페이지 | p.71 | `DevOps(데브옵스)/Metadata Coverage 보고서.md` (신규, 짧음) | ✅ 완료(2026-05-23) | 2026-05-22 |

#### DX-C6 — Scratch Orgs (doc p.72–202 / ~L3494) — P1 · 대형 챕터 → 서브 분할

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| DX-C6-01 | Scratch Org 개요 & 생성 — Editions/Allocations, 생성 명령, Definition File 전수, Features 전수 목록. 기존 `Scratch Org 패턴`(요약) → 심층 분화/보완 | p.72–120 | `DevOps(데브옵스)/Scratch Org 생성과 정의 파일.md` (신규/보완) | ✅ 완료(2026-05-22) | 2026-05-22 |
| DX-C6-02 | Scratch Org Settings (전수) — project-scratch-def.json `settings` 블록 전체 옵션 전수 (doc p.168 영역) | p.120–180 | `DevOps(데브옵스)/Scratch Org Settings 레퍼런스.md` (신규) | ✅ 완료(2026-05-22) | 2026-05-22 |
| DX-C6-03 | Org Shape & Snapshots — Org Shape 생성/사용, Snapshot 생성/관리/활용 전수. 기존 `Scratch Org 패턴` 요약분 → 심층 신규 | p.180–195 | `DevOps(데브옵스)/Org Shape와 Snapshot.md` (신규) | ✅ 완료(2026-05-22) | 2026-05-22 |
| DX-C6-04 | Scratch Org 배포/유저/에러 — Deploy/Retrieve, Scratch Org Users 관리, Error Codes 전수표 | p.195–202 | `DevOps(데브옵스)/Scratch Org 배포·유저·에러코드.md` (신규) | ✅ 완료(2026-05-22) | 2026-05-22 |

#### DX-C7 — Sandboxes (doc p.203–210 / ~L10025) — P2

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| DX-C7-01 | Sandbox 관리 — Authorize Prod, Sandbox Definition File 전수, Create/Clone/Refresh 전수 | p.203–210 | `DevOps(데브옵스)/Sandbox 관리.md` (신규) | ✅ 완료(2026-05-23) | 2026-05-22 |

#### DX-C8 — Track Changes / Source Tracking (doc p.211–220 / ~L10463) — P1

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| DX-C8-01 | Source Tracking 전수 — Preview, Deploy/Retrieve, Profiles, Conflicts 해결, Best Practices, Performance. 기존 `Salesforce DX 개요`의 Source Tracking 요약분 → 심층 신규 | p.211–220 | `DevOps(데브옵스)/Source Tracking 변경 추적.md` (신규) | ✅ 완료(2026-05-22) | 2026-05-22 |

#### DX-C9 — Work with Data (doc p.221–231 / ~L10973) — P2

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| DX-C9-01 | DX 데이터 작업 — Small/Large Datasets(tree import/export, bulk), Individual Records(data create/get/update/delete record), SOQL/SOSL(data query), Upload File 전수 | p.221–231 | `DevOps(데브옵스)/DX 데이터 작업.md` (신규) | ✅ 완료(2026-05-23) | 2026-05-22 |

#### DX-C10 — Salesforce DX MCP Server and Tools (Beta) (doc p.232–245 / ~L11512) — P3

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| DX-C10-01 | DX MCP Server (Beta) — VS Code+Copilot Quick Start, Install/Configure, Core Tools 전수. (Metadata API MCP Tool과 별개 — DX CLI MCP) | p.232–245 | `DevOps(데브옵스)/DX MCP Server (Beta).md` (신규) | ✅ 완료(2026-05-23) | 2026-05-22 |

#### DX-C11 — Development (doc p.246–261 / ~L12335) — P1

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| DX-C11-01 | DX 개발 워크플로 — Develop Against Any Org, Permission Set, Lightning/LWC/Apex/Trigger/Custom Object 생성 명령 전수, Anon Apex 실행, Run Tests, Debug Apex, Debug Logs 전수 | p.246–261 | `DevOps(데브옵스)/DX 개발 워크플로.md` | ✅ 완료(2026-05-22) | 2026-05-22 |

#### DX-C12 — Build and Release Your App (doc p.262–268 / ~L13100) — P2

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| DX-C12-01 | Metadata API 빌드/릴리스 워크플로 — Local Dev, Build/Test Artifact, Staging, Production, Cancel Deployment 전수. (MetadataAPI 서브폴더와 인접하나 소스 다름 — 워크플로 관점) | p.262–268 | `DevOps(데브옵스)/Metadata API 빌드·릴리스 워크플로.md` (신규) | ✅ 완료(2026-05-23) | 2026-05-22 |

#### DX-C13 — Unlocked Packages (doc p.269–325 / ~L13375) — P2 · 대형 챕터 → 서브 분할

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| DX-C13-01 | Unlocked Package 개념 & 준비 — 개념, Before You Create, Org-Dependent 패키지. 기존 `Unlocked Package 패턴`(요약) → 심층 분화/보완 | p.269–285 | `DevOps(데브옵스)/Unlocked Package 개념과 준비.md` (신규/보완) | ✅ 완료(2026-05-23) | 2026-05-22 |
| DX-C13-02 | 패키지 생성·설정·의존성 — Workflow, Configure, Keywords, Dependencies, Profile Settings 전수 | p.285–300 | `DevOps(데브옵스)/Unlocked Package 생성과 설정.md` (신규) | ✅ 완료(2026-05-23) | 2026-05-22 |
| DX-C13-03 | 패키지 개발·버전·코드커버리지 — Develop, Versions, Code Coverage 전수 | p.300–312 | `DevOps(데브옵스)/Unlocked Package 개발과 버전.md` (신규) | ✅ 완료(2026-05-23) | 2026-05-22 |
| DX-C13-04 | 패키지 릴리스·설치·전환 — Release, Push Upgrade, Install, Migrate Deprecated, Uninstall, Transfer 전수 | p.312–325 | `DevOps(데브옵스)/Unlocked Package 릴리스와 설치.md` (신규) | ✅ 완료(2026-05-23) | 2026-05-22 |

#### DX-C14 — Continuous Integration (doc p.326–343 / ~L16765) — P2

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| DX-C14-01 | CI 통합 전수 — CircleCI, Jenkins+Jenkinsfile, Travis CI, Sample CI Repos 전수. 기존 `CI CD 패턴`(Jenkins/CircleCI 요약) → 심층 분화/보완(Travis·샘플 레포 추가) | p.326–343 | `DevOps(데브옵스)/CI 통합 전수 (CircleCI·Jenkins·Travis).md` (신규/보완) | ✅ 완료(2026-05-23) | 2026-05-22 |

#### DX-C15 — Troubleshoot Salesforce DX (doc p.344–353 / ~L17561) — P3

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| DX-C15-01 | DX 트러블슈팅 — org login web/jwt Errors, No default dev hub, Consumer key taken, CLI Version 문제 전수 | p.344–353 | `DevOps(데브옵스)/DX 트러블슈팅.md` (신규) | ✅ 완료(2026-05-23) | 2026-05-22 |

#### DX-C16 — Limitations for Salesforce DX (doc p.354 / ~L17992) — P3

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| DX-C16-01 | DX 제약사항 — Salesforce DX 한계 전수(짧은 챕터) | p.354–364 | `DevOps(데브옵스)/DX 제약사항.md` (신규, 짧음) | ✅ 완료(2026-05-23) | 2026-05-22 |


---

### 보완 필요 기존 파일

| # | 파일 | 부족한 부분 | 상태 | 추가일 | 완료일 |
|---|---|---|---|---|---|
| F-01 | `Apex/Integration(통합)/ConnectApi Chatter 패턴.md` | Chatter만 있음. Communities/UserProfiles 미커버 | ✅ 완료 | 2026-05-18 | 2026-05-19 |
| F-02 | `Apex/Async(비동기)/비동기 컨텍스트 선택.md` | Apex Cursor(Summer '24 GA)와 비교 없음 | ✅ 완료 | 2026-05-18 | 2026-05-19 |

---

### V — 기존 파일 Apex Reference 검증 대기

> **규칙:** Apex Reference v67.0 PDF **하나만** 보면서 순서대로 검증. 다른 PDF 병행 금지.
> 검증 기준: 클래스 전체 포함 여부 / 메서드 시그니처 정확성 / 예제 코드 원문 수록 여부

| # | 파일 | Apex Ref PDF 페이지 | 상태 | 추가일 | 완료일 |
|---|---|---|---|---|---|
| V-01 | `Apex/Security(보안)/TxnSecurity Namespace.md` | p.4445~4453 | ✅ 완료 | 2026-05-20 | 2026-05-20 |
| V-02 | `Apex/Integration(통합)/Support Namespace.md` | p.3580~3583 | ✅ 완료 | 2026-05-20 | 2026-05-20 |
| V-03 | `Architecture(아키텍처)/Context Namespace.md` | p.2688 | ✅ 완료 | 2026-05-20 | 2026-05-20 |
| V-04 | `Apex/Data(데이터)/Datacloud Namespace.md` | p.2741~2760 | ✅ 완료 | 2026-05-20 | 2026-05-20 |
| V-05 | `Apex/Integration(통합)/Flow Namespace.md` | p.2880~2884 | ✅ 완료 | 2026-05-20 | 2026-05-20 |
| V-06 | `Apex/Testing(테스트)/Flowtesting Namespace.md` | p.2885~2892 | ✅ 완료 | 2026-05-20 | 2026-05-20 |
| V-07 | `Architecture(아키텍처)/Site Namespace.md` | p.3576~3580 | ✅ 완료 | 2026-05-20 | 2026-05-20 |
| V-08 | `Apex/Integration(통합)/KbManagement Namespace.md` | p.2968~2979 | ✅ 완료 | 2026-05-20 | 2026-05-20 |
| V-09 | `Architecture(아키텍처)/System Namespace.md` | p.3584~4440 | ✅ 완료 | 2026-05-20 | 2026-05-20 |
| V-10 | `Apex/Integration(통합)/ConnectApi Namespace 개요.md` | p.663~2687 | ✅ 완료 | 2026-05-20 | 2026-05-20 |
| V-11 | `Apex/PlatformEvents(플랫폼이벤트)/EventBus Namespace.md` | p.2865~2879 | ✅ 완료 | 2026-05-20 | 2026-05-20 |
| V-12 | `Apex/Integration(통합)/DataWeave Namespace.md` | p.2841~2858 | ✅ 완료 | 2026-05-20 | 2026-05-20 |
| V-13 | `Apex/Integration(통합)/Compression Namespace.md` | p.646~662 | ✅ 완료 | 2026-05-20 | 2026-05-20 |

---

## 상태 범례

| 아이콘 | 의미 |
|---|---|
| 🔲 대기 | 아직 작업 시작 전 |
| 🟡 진행중 | 현재 작업 중 |
| ✅ 완료 | 작업 완료 + wiki 반영 확인 |
| ❌ 보류 | 소스 미확보 등의 이유로 보류 |

---

## 완료 아카이브

| # | 주제 | 완료일 | 비고 |
|---|---|---|---|
| P1-01 | `Apex/Integration(통합)/Compression Namespace.md` | 2026-05-18 | Apex Ref v67.0 p.646 |
| P1-02 | `LWC/Testing(테스트)/` Jest 테스트 3종 | 2026-05-18 | Tier 3 (외부 지식) |
| P1-03 | `Apex/Integration(통합)/DataWeave Namespace.md` | 2026-05-18 | Apex Ref v67.0 p.2841 |
| P2-01 | `Release/Winter '25.md` (v62.0) | 2026-05-18 | Tier 3 (external-knowledge) |
| P2-03 | `Apex/PlatformEvents(플랫폼이벤트)/EventBus Namespace.md` | 2026-05-18 | Apex Ref v67.0 p.2865 |
| P2-04 | `Apex/Integration(통합)/ConnectApi Namespace 개요.md` | 2026-05-18 | Apex Ref v67.0 p.663 |
| P3-01 | `Architecture(아키텍처)/System Namespace.md` | 2026-05-19 | Apex Ref v67.0 p.3584 |
| P3-02 | `Apex/Integration(통합)/KbManagement Namespace.md` | 2026-05-19 | Apex Ref v67.0 p.2968 |
| P3-03 | `Architecture(아키텍처)/Site Namespace.md` | 2026-05-19 | Apex Ref v67.0 p.3576 |
| P3-04 | `Apex/Testing(테스트)/Flowtesting Namespace.md` | 2026-05-19 | Apex Ref v67.0 p.2885 |
| F-01 | ConnectApi Communities/UserProfiles 보완 | 2026-05-19 | Apex Ref v67.0 p.1499, 1972 |
| F-02 | 비동기 컨텍스트 선택 — Apex Cursor 추가 | 2026-05-19 | Apex Ref v67.0 p.2692 |
| P1-04 | `Apex/Integration(통합)/Flow Namespace.md` | 2026-05-19 | Apex Ref v67.0 p.2880~2884 |
| P1-05 | `Apex/Security(보안)/TxnSecurity Namespace.md` | 2026-05-20 | Apex Ref v67.0 p.4445~4453 |
| P1-06 | `Apex/Integration(통합)/Support Namespace.md` | 2026-05-20 | Apex Ref v67.0 p.3580~3583 |
| P1-07 | `Architecture(아키텍처)/Context Namespace.md` | 2026-05-20 | Apex Ref v67.0 p.2688 (Industries Cloud 전용) |
| P1-08 | `Apex/Data(데이터)/Datacloud Namespace.md` | 2026-05-20 | Apex Ref v67.0 p.2741~2760 (Duplicate Management) |
| P2-05 | `Architecture(아키텍처)/ApexPages Namespace.md` | 2026-05-20 | Apex Ref v67.0 p.10~42 (Visualforce 컨트롤러 8개 클래스) |
| P2-06 | `Architecture(아키텍처)/AppLauncher Namespace.md` | 2026-05-20 | Apex Ref v67.0 p.43~47 (AppMenu 3개 메서드, 나머지 8개 internal only) |
| P2-07 | `Apex/Integration(통합)/LxScheduler Namespace.md` | 2026-05-20 | Apex Ref v67.0 p.2980~3022 (14개 클래스/인터페이스, Salesforce Scheduler 외부 캘린더 연동) |

---

## 관련 에이전트

- [[wiki-retrospective]] — 모드 B에서 이 백로그를 읽고 업데이트하며 에이전트 프로토콜 개선
- [[pm]] — 백로그 항목을 실제 작업으로 스케줄링
