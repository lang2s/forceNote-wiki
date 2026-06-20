---
tags: [backlog, coverage, work-tracking]
created: 2026-05-18
updated: 2026-06-20
---

> **세션 인계 메모 (2026-05-25 세션 종료 시점):**
> 2GP-12(AppExchange App Analytics, pkg2_dev.pdf p.428-504) 완료 — 4분할(Part1 Overview&Setup·Part2 Best Practices&Query·Part3 Data Types&Schemas·Part4 Developer Cookbook). 전체 스키마 필드 전수(Package Usage Logs ~65개·Summaries 13개·Subscriber Snapshots 12개), log_record_type 20종, SAQL 6개, CRM Analytics 레시피 2개. 역링크 5건·platform.md(4행)·index.md 업데이트. 다음 세션은 **2GP-13**(1GP vs 2GP Feature Gaps, p.505-517)부터 시작.

# WORK_BACKLOG — 활성 작업 추적

> **wiki-retrospective(모드 B)는 분석 시작 전 이 파일을 반드시 읽는다.**
> 이 파일에는 **열린 항목(🔲/🟡)·lint 이력·프로토콜 개선만** 둔다. 완료된(✅) 작업은 즉시 [[WORK_BACKLOG_ARCHIVE]]로 이동한다 → 파일이 무한정 길어지지 않게 유지.

---

## 커버리지 현황 (2026-05-22 재산출 ✅)

| 소스 | 공개 대상 | 커버됨 | 누락 | 커버리지 |
|---|---|---|---|---|
| Apex Reference v67.0 (~70 네임스페이스) | 68개 (내부 전용 2개 제외) | 68개 | 0개 | **~100%** |
| sObject Reference v67.0 (object_reference.pdf) | Ch1~Ch6 | 31개 서브페이지 | 0개 | **완료** |
| Salesforce DX Guide v67.0 (sfdx_dev.pdf) | 16개 챕터 | 16개 챕터 | 0개 | **완료** |

> 완료 상세(네임스페이스별·챕터별 행, 소스 페이지, 완료일)는 [[WORK_BACKLOG_ARCHIVE]] 참조.

---

## 사용 방법

- 새 항목 추가: wiki-retrospective(모드 B)가 추가 — **🔲/🟡 열린 항목만**
- 완료 시: 상태를 ✅로 표시한 뒤 **즉시 [[WORK_BACKLOG_ARCHIVE]]로 이동** (이 파일에 ✅ 누적 금지)
- lint 실행: 아래 "Lint 실행 이력"에 **실행 1회당 1행** 추가 (발견 세부는 행 안에 압축, 미해결분만 "열린 항목"으로 승격)

---

## 열린 항목 (🔲 대기 / 🟡 진행중)

### 🔴 P0 — 즉시 (다음 작업 진행을 위해 필요)

| # | 항목 | 소스/사유 | 상태 | 추가일 |
|---|---|---|---|---|
| PIPE-2 | `writer.md` frontmatter에 `Bash` 도구 추가 | 강화된 Pattern A의 "메이저 섹션 직전 sed 재추출"을 writer가 직접 실행할 수 있게 함. 현재 writer는 Read/Write/Edit만 가능 → researcher dump의 raw 인용에 강제 의존. | 🔲 대기 | 2026-05-23 |
| 2GP-3 | `2GP Managed Package — Workflow.md` 작성 (pkg2_dev.pdf p.23-25) | 강화된 protocol(6 카테고리 spot check + Pattern B-2 산문형 numeric mapping)의 소형 페이지 validation 기회. | 🔲 대기 | 2026-05-23 |
| LINT-1 | **깨진 wikilink 수정** — `MetadataAPI(...)` 경로 prefix 누락 20건 | 2026-05-25 lint 발견. `DevOps(데브옵스)/index.md`(13건)·`CI CD 패턴.md`(2건)·`Metadata Coverage 보고서.md`(1건)·`Apex/Integration(통합)/Metadata Namespace.md`(2건)에서 `[[MetadataAPI(메타데이터API)/...]]`를 `[[DevOps(데브옵스)/MetadataAPI(메타데이터API)/...]]`로 수정. **✅ 완료(2026-06-18)** — 이번 lint 수정 워크리스트에서 index-manager+cross-linker가 경로 prefix 보정. | ✅ 완료 | 2026-05-25 |
| LINT-2 | **MOC 누락 항목 추가** — SLDS 디자인 시스템·Enhanced Domains | `LWC/LWC MOC.md`에 `SLDS LWC 디자인 시스템` 행 추가, `Architecture(아키텍처)/Architecture MOC.md`에 `Enhanced Domains` 행 추가. **✅ 완료(2026-06-18)** — 2026-06-18 lint 재확인으로 기해소 확인: LWC MOC L136 `## 🎨 SLDS 디자인 시스템` 섹션·L138 `[[SLDS LWC 디자인 시스템]]` 링크 + Architecture MOC L44 `[[Enhanced Domains]]` 행 모두 존재. | ✅ 완료 | 2026-05-25 |
| LINT-3 | **peer 노트 역링크 3건** | `파일 업로드와 이미지 처리.md`←`[[lightning-input]]`, `Approval Namespace.md`←`[[Context Namespace]]`, `모바일 기능 패턴.md`←`[[quickChoice Screen Component]]` 추가. **✅ 완료(2026-06-18)** — 이번 lint 수정 워크리스트에서 cross-linker가 3건 양방향 역링크 보완. | ✅ 완료 | 2026-05-25 |
| LINT-4 | **`questions.md` 예외 규칙 명문화** — CLAUDE.md + wiki-linter.md 수정 | `_index/questions.md`는 "교차 도메인 질문 라우팅 보조 샤드"로 설계 의도상 다른 도메인 샤드에 등재된 파일을 재등재할 수 있음. "1 페이지 = 1 홈 샤드" 규칙의 공식 예외로 명문화 필요. CLAUDE.md 샤드 규칙 표에 각주 추가 + wiki-linter.md check #3(고아)·#6(중복) 판정 로직에 `questions.md` 제외 처리 안내 추가. **✅ 완료(2026-06-18)** — wiki-retrospective가 CLAUDE.md "1 페이지 = 1 홈 샤드" 행 비고에 예외 명문화 + wiki-linter.md 고아(#2)·샤드 건강/중복(#3b) 섹션에 questions.md 제외 안내 삽입. (AP-07로 프로토콜 개선 이력에도 기록) | ✅ 완료 | 2026-05-25 |

### 🟡 P1 — Task #4(대형 카탈로그) 전 필요

| # | 항목 | 소스/사유 | 상태 | 추가일 |
|---|---|---|---|---|
| DEC-1 | ~~Components Available 카탈로그(288쪽) 분할 전략 결정~~ | **✅ 결정 완료 (2026-05-23)**: 도메인 8분할 — MetadataAPI/Metadata Types 구조 미러. 파일명: `2GP — Components - Apex & Code.md` 등 8개. MetadataAPI는 API 구조, 2GP Components는 패키징 동작(Manageability+Editable Properties) 역할 분업. | ✅ 완료 | 2026-05-23 |
| PIPE-3 | researcher dump 정책 — large PDF 시 raw inline vs file reference | 강화 protocol이 "raw sed 출력을 dump에 포함" 의무인데 큰 PDF에서 LLM context 한계 초과 위험. file reference 방식 보완 필요. | 🔲 대기 | 2026-05-23 |
| PIPE-4 | scout ↔ researcher handoff contract 명시 | 두 agent 모두 강화됐지만 "시각 자료 경고" 정확한 출력 형식과 researcher의 ⚠️ 표시 형식 사이 인터페이스 계약이 별도 문서로 정리 안 됨. | 🔲 대기 | 2026-05-23 |
| PIPE-5 | classifier `D-3 depth balance` 한계 명시 | classifier는 콘텐츠 미작성 단계라 섹션 분량 예측 정확도가 낮음. protocol에 "writer 사후 점검과 함께 운영"이라는 안내 필요. | 🔲 대기 | 2026-05-23 |

### 🟢 P2 — 2GP 시리즈 연속 작업 (Task #3 통과 후 본격 진행)

| # | 항목 | 소스 | 상태 | 추가일 |
|---|---|---|---|---|
| 2GP-4 | `2GP — Components - Apex & Code.md` (도메인 8분할 중 1번째) | pkg2_dev.pdf p.25-313 전체에서 Apex Class·Trigger·Sharing Reason 등 추출 | 🔲 대기 | 2026-05-23 |
| 2GP-4b | `2GP — Components - Automation.md` (Flow/Process/Workflow) | pkg2_dev.pdf p.25-313 | 🔲 대기 | 2026-05-23 |
| 2GP-4c | `2GP — Components - Einstein & Analytics.md` | pkg2_dev.pdf p.25-313 | 🔲 대기 | 2026-05-23 |
| 2GP-4d | `2GP — Components - Integration & Platform.md` | pkg2_dev.pdf p.25-313 | 🔲 대기 | 2026-05-23 |
| 2GP-4e | `2GP — Components - Objects & Fields.md` | pkg2_dev.pdf p.25-313 | 🔲 대기 | 2026-05-23 |
| 2GP-4f | `2GP — Components - Security & Access.md` | pkg2_dev.pdf p.25-313 | 🔲 대기 | 2026-05-23 |
| 2GP-4g | `2GP — Components - UI & Layout.md` | pkg2_dev.pdf p.25-313 | 🔲 대기 | 2026-05-23 |
| 2GP-4h | `2GP — Components - Other.md` | pkg2_dev.pdf p.25-313 | 🔲 대기 | 2026-05-23 |
| 2GP-5 | `2GP — Specific Metadata Behavior` (Apex/Protected/Permission Sets/Profile) | pkg2_dev.pdf p.314-333 | ✅ 완료 | 2026-05-23 |
| 2GP-6 | `2GP — Develop (Apex·버전 생성)` | pkg2_dev.pdf p.334-347 | ✅ 완료 | 2026-05-23 |
| 2GP-7 | `2GP — Install · Uninstall` | pkg2_dev.pdf p.348-359 | ✅ 완료 | 2026-05-23 |
| 2GP-8 | `2GP — Prepare to Distribute` | pkg2_dev.pdf p.360-363 | ✅ 완료 | 2026-05-23 |
| 2GP-9 | `2GP — Push Upgrade` | pkg2_dev.pdf p.364-373 | ✅ 완료 | 2026-05-23 |
| 2GP-10 | `2GP — Advanced Features` | pkg2_dev.pdf p.374-406 | ✅ 완료 | 2026-05-23 |
| 2GP-11 | `2GP — Best Practices + License Management + Feature Management` | pkg2_dev.pdf p.407-427 | ✅ 완료 | 2026-05-23 |
| 2GP-12 | `2GP — AppExchange App Analytics` (~76쪽 — 분할 검토) | pkg2_dev.pdf p.428-504 | ✅ 완료 | 2026-05-23 |

### 🔵 P3 — 중기 (다른 작업 사이에 의식적 실험)

| # | 항목 | 소스/사유 | 상태 | 추가일 |
|---|---|---|---|---|
| PIPE-1 | 강화된 pipeline agent 실제 invocation 1회 시도 | 6개 agent 정의가 모두 강화됐으나 Task #1·#2 모두 manual 작성 → 실제 PM 호출로 파이프라인 작동 데이터 1회 확보. PIPE-3·4·5의 가설 검증. | 🔲 대기 | 2026-05-23 |
| DEC-2 | 위키 이미지 첨부 정책 결정 | pdftotext가 못 잡는 다이어그램을 정말 보존해야 할 페이지가 있다면 PDF figure 캡처 첨부 정책 필요. 현재 없음 → 모든 시각 자료는 "마커 + skip" 또는 "텍스트 재현" 만. | 🔲 대기 | 2026-05-23 |
| 기존 P2-02 | ~~`Release/Spring '26.md` (v66.0) 작성~~ | **✅ 완료 (2026-06-14)**: salesforce_spring26_release_notes.pdf(Spring '26, v66.0, Tier 2)에서 개발자 섹션 발췌. 댕글링 링크 3건 해소. | ✅ 완료 | 2026-05-18 |
| 기존 P3-05 | ~~LWC BaseComponents 확장 (lightning-tree·tab·pill 등)~~ | **✅ 완료 (2026-06-13)**: SLDS2-Docs cx-router 메타데이터(Tier 2)로 신규 55 + 기존 11 패밀리 명세 병합 = 66개. 카탈로그 역링크 + SLDS 디자인시스템 폴더 27노트도 함께. | ✅ 완료 | 2026-05-18 |

### 🔵 P3 — 선언적 어드민 도메인 공백 (갭 분석 2026-06-14)

> **출처:** `Salesforce Documents/Complete Salesforce Notes & Interview Questions and Answers/`(제3자 학습노트·면접 Q&A 321 PDF) **vs 위키** 갭 분석 결과.
> **⚠️ Tier 주의:** 그 컬렉션은 **Tier 3**(제3자 노트)이므로 **갭 식별용으로만** 쓴다. 실제 작성은 공식 소스(Tier 2: `help.salesforce.com` 어드민 가이드, 공식 PDF)로 채운다 — 컬렉션 본문을 그대로 옮기지 않는다.
> **배경:** 위키는 개발(Apex 106·LWC 128노트) 영역은 깊으나 **선언적 어드민**은 `Admin(어드민)/` 3개 파일뿐. CLAUDE.md 스코프(Admin/Setup·Sales/Service Cloud)와 실제 콘텐츠의 불균형.

| # | 항목 | 사유/현황 | 상태 | 추가일 |
|---|---|---|---|---|
| ADMIN-1 | **Approval Process** (선언적 승인 워크플로) | `Approval Namespace`(Apex)만 존재, 선언적 설정 how-to 없음. 공식 소스 필요 | 🔲 대기 | 2026-06-14 |
| ADMIN-2 | **Formula / Roll-Up Summary 필드** | 전용 노트 없음 | 🔲 대기 | 2026-06-14 |
| ADMIN-3 | **Profiles · Page Layouts · Record Types** | 전용 노트 없음 | 🔲 대기 | 2026-06-14 |
| ADMIN-4 | **OWD · Sharing Rules** (선언적 공유 모델 전체) | `Permission Set 설계` + **`레코드 액세스 설계 (Enterprise Scale)`(공유 재계산·implicit sharing·skew, draes Tier 2)** 추가. 선언적 OWD/Sharing Rule **설정 how-to**(공유 규칙 유형·기준 기반/소유 기반)는 여전히 미작성 | 🟡 부분 | 2026-06-14 |
| ADMIN-5 | **Reports & Dashboards** (선언적) | 전용 노트 없음 | 🔲 대기 | 2026-06-14 |
| ADMIN-6 | **Data Loader**(~~완료~~) · Import Wizard | **Data Loader ✅ 완료 (2026-06-14)**: `Admin(어드민)/Data Loader.md` (salesforce_data_loader.pdf v67.0, Tier 2 — UI/CLI·Bulk API·작업·process-conf.xml·vs Import Wizard 비교). Import Wizard 전용 노트는 미작성(현재 비교표로만 커버) | 🟡 부분 | 2026-06-14 |
| ADMIN-7 | **Duplicate · Matching Rules** | 전용 노트 없음 | 🔲 대기 | 2026-06-14 |
| ADMIN-8 | **Schema Builder** | 전용 노트 없음 | 🔲 대기 | 2026-06-14 |
| ADMIN-9 | **Sales Cloud · Service Cloud** (기능 레벨 가이드) | `Service Cloud Objects`(sObject)만, 기능 가이드 없음 | 🔲 대기 | 2026-06-14 |
| DEV-GAP-1 | ~~**Data Skew** (account/lookup/ownership skew)~~ | **✅ 완료 (2026-06-14)**: `Architecture(아키텍처)/Data Skew.md` — LDV 가이드(Tier 2)에서 account data/ownership skew 1만 건 임계값·record-locking·defer sharing·케이스 스터디 추출. lookup skew는 메커니즘만(가이드 미명시 명시). | ✅ 완료 | 2026-06-14 |
| DEV-GAP-2 | ~~**Trigger 재귀 방지** 전용 노트~~ | **✅ 완료 (2026-06-14)**: `Apex/Trigger(트리거)/Trigger 재귀 방지.md` — Apex Dev Guide(Tier 2)의 static 변수 재귀 제어(firstRun 원문 예제)·스택 깊이 16·롤백 캐비엇 + TriggerHandler setMaxLoopCount(Tier 1) 교차참조. | ✅ 완료 | 2026-06-14 |
| QA-GAP-1 | 면접 Q&A → `_index/questions.md` 보강 검토 | 컬렉션의 회사별(TCS·Deloitte 등)·시나리오 면접 Q&A. reference 아님 + Tier 3 → 보존 가치 낮음. 자연어 질문 라우팅 키워드만 선별 흡수 검토 | 🔲 대기 | 2026-06-14 |

### 🟢 INGEST — Salesforce Documents 공식 PDF 인제스트 (2026-06-14 시작)

> **목표:** 로컬 `Salesforce Documents/`의 공식 PDF(Tier 2)를 한 개씩 위키화. 파이프라인: 버전 내용 검증 → 전수 추출 → 구조 매칭 작성 → 네비 → 링크 검증 → 커밋.
> **이미 채굴됨(제외):** apex_reference_guide(57노트)·object_reference(38)·sfdx_dev(28)·pkg2_dev(28)·api_meta(19)·soql_sosl·lightningAura·basics·apex_developer_guide·large_data_volumes_bp·릴리즈노트. **대형(분할 필요):** chatter_rest(2350p)·extend_click_automate(1027p)·api_tooling(1006p)·pages_dev(817p)·lightning(553p).

| # | PDF (페이지) | 도메인 | 상태 |
|---|---|---|---|
| ING-01 | ~~salesforce_data_loader (58)~~ | Admin/Data | **✅ 완료 (2026-06-14)** → `Admin(어드민)/Data Loader.md` |
| ING-02 | ~~Salesforce-Flow-Best-Practices 백서 (19)~~ | Flow | **✅ 이미 완료(기존)** — `Flow 설계 베스트 프랙티스`·`Flow 네이밍 컨벤션`·`Flow 에러 처리` 3노트가 이 백서 출처. (※ source에 `.pdf` 미기재라 초기 탐지서 누락됐던 거짓양성) |
| ING-03 | platform_events (628) | Apex/PlatformEvents (분할) | **✅ 전수 완료 (2026-06-14)** — 3노트 심화: 정의와구독에 Pub/Sub API(gRPC·Avro·Publish/PublishStream·11언어)·CometD·이벤트 스트림 그룹/필터(커스텀 채널) 추가, 한도노트에 표준 PE 객체(EventUuid/ReplayId/LoginKey)·발행 상태코드(OPERATION_ENQUEUED) 추가. 7노트 전부 공식 링크 |
| ING-04 | api_rest (430) = REST API Developer Guide | Integration | **✅ 전수 완료 (2026-06-14)** → `REST API.md` 119→177줄. 헤더 10종·sObject 리소스 전체·Composite(25/500 subreq)·Graph/Batch/Tree/Collections·status codes·날짜형식 + 공식 링크. (Composite 세부가 더 커지면 분할 여지) |
| ING-05 | api_action (151) = Actions Developer Guide | Integration/Actions | **✅ 전수 완료 (2026-06-14)** → `Actions API.md` — 액션 유형·호출 프레임워크·**표준 액션 50+종 전수 목록**(카테고리별)·Apex 액션 + 공식 링크. (개별 액션 입력필드 전체는 공식 가이드 각 페이지) |
| ING-06 | api_asynch (182) = Bulk API 2.0 and Bulk API | Integration/Bulk·Async | **✅ 전수 완료 (2026-06-14)** → `Bulk API 2.0.md` 99→196줄. Create Job 요청/응답 전 필드·enum, 잡 상태 6종, Job Info 메트릭, 결과 3종 엔드포인트, Query Locator 헤더, limits 수치, status/error codes |
| ING-07 | salesforce_recipes_api (180) | Data 360 | 🔲 대기 |
| ING-08 | salesforce_analytics_rest_api (310) | Analytics | 🔲 대기 |
| ING-09 | ~~salesforce_knowledge_dev_guide (209)~~ | Service/Knowledge (신규 폴더) | **✅ 전수 완료 (2026-06-17)** → 신규 `Service(서비스)/Knowledge(지식)/` 9노트(4,297줄): 데이터모델&API개요·SOAP객체(핵심6/주변8=14종)·SOAP호출4종·REST(Actions+Manage19)·REST(Search7+Support4)·Metadata타입(아티클설정5/데이터카테고리외부5=10종)·UI API제약. 신규 샤드 `_index/service.md`·라우터·Home·역링크 5건. Ch5 SOQL/SOSL·Ch6 PublishingService는 기존 노트(SOQL WITH DATA CATEGORY·SOSL 패턴·KbManagement) 역링크로 중복 회피. completeness/source-verifier 셀단위 통과 |
| ING-10a | ~~exp_cloud_lwr (106)~~ = LWR Sites for Experience Cloud | LWC/Experience | **✅ 전수 완료 (2026-06-14)** → `LWC/UIPatterns(UI패턴)/LWR Sites (Experience Cloud).md` (LWR 템플릿·lightningCommunity__ 타깃 4종·@salesforce 모듈·--dxp 훅·다국어) + 공식 링크 |
| ING-10b | communities_dev (105) = Experience Cloud Developer Guide | Experience Cloud | 🔲 대기 |
| ING-11 | mobile_offline (258) = Mobile and Offline Developer Guide | Mobile | **✅ 전수 완료 (2026-06-14)** → `LWC/Mobile(모바일)/모바일 & 오프라인 (LWC).md` (mobileCapabilities 10종·LWC Offline·Offline GraphQL·Briefcase·draft records·제약) + 공식 링크. 기존 모바일 기능 패턴(Tier1)과 상호 링크 |
| ING-12 | ~~lightning_knowledge_guide (91)~~ = Lightning Knowledge Guide (Spring '26) | Service/Knowledge (admin) | **✅ 전수 완료 (2026-06-17)** → 기존 `Service(서비스)/Knowledge(지식)/`에 admin-facing 7노트(~1,936줄, ING-09의 9개 개발자/API 노트와 viewpoint 구분): 개요(계획·Lightning vs Classic 비교·한계 6하위그룹)·셋업&구성(가이드/수동·권한표)·사용(작성액션 가용성·검색·스마트링크/영구링크·채널 액션)·아티클 리포팅(9필드표)·아티클 임포트(csv/zip·.properties 파라미터)·다국어&번역(ArticleManagement 25행 컬럼표·발행/번역/아카이브/나란히보기)·데이터카테고리&공유(선언적·공유 모델). 다단 표 6개 pdftoppm 이미지검증. **중복 회피:** Metadata 데이터카테고리 스키마·데이터모델·SOAP 통계객체·REST Search/Actions·UI API 제약은 ING-09 노트로 역링크(스키마 재작성 0). cross-linker가 기존 API 노트 6개에 역링크 7건. nav: `_index/service.md` 7행·`_index/questions.md` 어드민 자연어 7행·Service/Knowledge index.md A/B 그룹 재편·Service 허브 갱신. completeness/source-verifier/qa 통과, Tier 3 노트 0 |
| ING-13a | ~~chat_rest (66) = **Chat REST API Developer Guide** (v66.0 Spring '26)~~ | Service/Chat (Live Agent visitor REST) | **✅ 완료 (2026-06-18)** → [[WORK_BACKLOG_ARCHIVE]] ING-13a. 신규 `Service(서비스)/Chat(채팅)/` 폴더 7노트(~1,797줄), source chat_rest(Tier 2), 7노트 전부 은퇴 [!warning] 배너. ★ TOC가 Ch6 14개 Messages 응답 객체 누락 → scout 색인 캐치·validator 전수 확인. 형제 후속 **ING-36(chat_dev_guide) P1** 식별 |
| ING-13b | salesforce_chatter_rest_api (2350, **분할 필요**) = **Connect REST API Developer Guide** (v67.0 Summer '26) | Chatter/Connect/Integration | 🔲 대기 — ★ 분리(2026-06-18 내용확인): 파일명과 달리 Connect REST API(Chatter 피드·커뮤니티 등 수백 리소스). **2,350p 초대형 → 단일 파이프라인 불가, DEC-1식 도메인 분할 전략 선결 필요**. 별도 대형 이니셔티브로 취급 |
| ING-14 | ~~case_feed_dev_guide (45)~~ = **Publisher and Quick Action Developer Guide** (Summer '26) | LWC/Aura·Visualforce (Quick Action JS API) | **✅ 전수 완료 (2026-06-18)** → 신규 2노트: `Aura(오라)/Quick Action·Publisher JS API 레퍼런스.md`(~530줄, p.5-22 — `lightning:quickActionAPI` 8메서드[getAvailableActions·getAvailableActionFields·getCustomAction·getSelectedActions·invokeAction·selectAction·setActionFieldValues 등] + `Sfdc.canvas.publisher` 5메서드[selectAction·setActionInputValues·invokeAction·customActionMessage·refresh] + LEX↔Classic 패리티 표) + `Aura(오라)/Case Feed Visualforce 커스터마이즈.md`(~670줄, p.23-45 — VF 컴포넌트 6개 속성표 89행[`apex:emailPublisher`·`apex:logCallPublisher`·`support:portalPublisher`·`support:caseArticles`·`support:CaseFeed`·`chatter:feed`] + Apex 4클래스). source: `case_feed_dev_guide.pdf` Tier 2. **★ 정체 정정:** 파일명 `case_feed`는 함정 — 실제 내용은 Quick Action JS API·Publisher API·VF 액션 커스터마이즈. **동명이의 3구분 명시:** 이 JS API ≠ Apex `QuickAction` 네임스페이스(서버측 performQuickAction) ≠ Lightning Console JS API(workspaceAPI). 교차링크 양방향: QuickAction Namespace·Lightning Console JS API(ING-24, 별개 명시)·Lightning Knowledge 사용(ING-12)·ApexPages Namespace·Support Namespace(coverage-checker 발견). completeness/source-verifier/qa ✅, Tier 3 노트 0. retrospective(모드 A): 양 노트 aliases에 `case feed`·동명이의 구분·VF 컴포넌트 속성 자연어 표현 보강 |
| ING-15 | caf_dev (27) = **Custom Address Fields Developer Guide** (v66.0 Spring '26) | Data/Schema (sObject·필드) | **✅ 완료 (2026-06-18)** → [[WORK_BACKLOG_ARCHIVE]] ING-15. 신규 `sObject/Custom Address Fields.md`(791줄). 10챕터 전수·CRUD 5-API·geocode 수동·State/Country picklist. Compound Fields 양방향. 중복위험 PDF 유형(동일 기능 5-API 반복)을 비교표+셀단위 고유표기로 처리. 원문 오타 8건 보존 |
| ING-16 | ~~bi_dev_guide_lwc_in_db (23)~~ = LWC in CRM Analytics Dashboards | Analytics/LWC | **✅ 완료 (2026-06-14)** → `LWC/UIPatterns(UI패턴)/CRM Analytics 대시보드용 LWC.md` |
| ING-17 | ~~draes (15)~~ = Designing Record Access for Enterprise Scale | Architecture/Security | **✅ 완료 (2026-06-14)** → `Architecture(아키텍처)/레코드 액세스 설계 (Enterprise Scale).md`. ADMIN-4 부분 충족 |
| ING-18 | esm_developer_guide (55) = **Enterprise Sales Management** (Industries CME) | Sales/Industries | ⏸️ 후순위(niche) — 파일명과 달리 Embedded Service 아님. Industries CME 버티컬의 네임드 API(b2bExpress_*·ESM_* 수십 개) 솔루션. 일반 dev 가치 낮아 보류 |
| ING-19 | service_presence_developer_guide (23) / _administrators (124) | Service (Omni-Presence) | 🔲 대기 |
| ING-20 | omnichannel_supervisor (32) | Service | 🔲 대기 |
| ING-21 | salesforce_guided_engagement (40) | Service | 🔲 대기 |
| ING-22 | cpq_developer_guide (112) | Revenue/CPQ | 🔲 대기 |
| ING-23 | salesforce_mobile_push_notifications_implementation (57) | Mobile/Notification | 🔲 대기 — 위키 source 인용 0건·과거 파일명 접미사(`_implementation`) 누락으로 미추적이었음(정정 2026-06-16) |
| ING-24 | api_console (346) = Salesforce Console Developer Guide | LWC/Navigation | **✅ 전수 완료 (2026-06-14)** → `LWC/Navigation(네비게이션)/Lightning Console JS API.md` (Lightning Console API: workspaceAPI/utilityBarAPI/navigationItemAPI 메서드 전수·Aura/LWC·LMS 탭이벤트·Classic 레거시) + 공식 링크 |
| ING-25 | extend_click_automate (1027, 분할) | Automation/Flow | 🔲 대기 |
| ING-26 | api_tooling (1006, 분할) | Dev Tools | 🔲 대기 |
| ING-27 | salesforce_pages_developers_guide (817, 분할) | Visualforce | 🔲 대기 |
| ING-28 | lightning (553, 분할) | Aura/LWC | 🔲 대기 |
| ING-29 | salesforce_app_limits_cheatsheet (23) | Architecture/Limits | 🔲 **미착수(되살림 2026-06-16)** — ARCHIVE N1-02가 ✅로 잘못 기록됐으나 위키화된 적 없음(거버너 한도 페이지의 실제 source는 Apex Dev Guide apex_gov_limits.htm). 이 치트시트는 org/feature/edition별 **앱·API·storage·이메일·process 한도 표**라 기존 `Governor Limits.md`(Apex 트랜잭션 한도)와 **별개 도메인** → 신규 페이지 가치 있음 |
| ING-30 | service_presence_administrators (124) / service_presence_developer_guide (23) | Service (Omni-Presence) | 🔲 대기 — ★ admin 가이드는 인용 0건·백로그 미등록이었음(2026-06-16 신규 등록). dev guide는 기존 ING-19와 동일 묶음 |

#### 🆕 신규 수령 PDF (2026-06-17 origin/main 머지로 입수 — 미착수, 페이지수 검증됨)

> 다른 머신에서 GitHub 웹 업로드된 공식 PDF 8개(Tier 2 추정, 작성 전 내용으로 버전 확인). `Salesforce Documents/`에 디스크 실재 확인됨. 도메인 가치·분량 기준으로 다음 사이클에 ING 번호 승격.

| # | PDF (페이지) | 도메인 | 상태 |
|---|---|---|---|
| ING-31 | ~~secure_coding (97) = Secure Coding Guidelines~~ | Security(보안) | **✅ 완료 (2026-06-18)** → [[WORK_BACKLOG_ARCHIVE]] ING-31. 신규 최상위 `Security(보안)/` 폴더 + 위협모델 12노트(Ch1~15 전수), 신규 샤드 `_index/security.md`·라우터·Home, 17 역링크, 메커니즘 노트 deep-link 중복회피. 차기 ING-43 파생 |
| ING-32 | salesforce_scheduler_dev_guide (434, 분할) | Sales/Scheduler | 🔲 대기 — 대형, 분할 필요 |
| ING-33 | order_management_developer_guide_html (69) | Commerce/OM | 🔲 대기 |
| ING-34 | scoping_rules_dev_guide (31) | Security/Sharing | 🔲 대기 — 소형 |
| ING-35 | salesforce1_admin_guide (86) | Admin/Mobile | 🔲 대기 |
| ING-36 | chat_dev_guide (61) = Live Agent/Chat (Service Cloud Chat Developer Guide, v67.0) | Service | **✅ 완료 (2026-06-18)** → [[WORK_BACKLOG_ARCHIVE]] ING-36. ING-13a(chat_rest, 방문자측 REST) 형제 후속 — 에이전트/구현 가이드(Deployment·VF 컴포넌트·라우팅). 신규 노트 1개(Ch6-8) + 기존 3노트(Ch1-5) = `Service(서비스)/Chat(채팅)/` 4 dev-guide 노트, 전부 은퇴 배너. ⚠️ 후속 **ING-44**(Embedded Service SDK·Messaging for In-App and Web 마이그레이션 노트 — PDF 디스크 미보유, **입수 게이트**) 식별 |
| ING-37 | salesforce_pages_developers_guide (817, 분할) | Visualforce | 🔲 **ING-27과 동일 PDF** — 머지로 내용 갱신됨(중복 행, 통합 정리 필요) |
| ING-38 | salesforce_reports_enhanced_reports_tab_tipsheet (3) | Reports | 🔲 대기 — 초소형 팁시트, ADMIN-5(Reports)와 함께 검토 |
| ING-41 | `object_reference.pdf` — **표준 Address compound 서브필드 전수표 + Compound Field Considerations/Limitations** | Data/Schema (sObject) | ✅ **기실재 검증(2026-06-19, RECON-3 ⑤ 감사)** — object_reference.pdf Ch1 Compound Fields 섹션 셀단위 대조 결과 `sObject/Compound Fields.md`가 **표준 Address 서브필드 10행(Accuracy·City·Country·CountryCode·Latitude·Longitude·PostalCode·State·StateCode·Street)·Geolocation·Considerations/Limitations를 이미 전수 보유**. "반쪽 비어있음"은 2026-06-18 coverage-checker 오판정(또는 ING-15로 백필됨). 신규/보강 불필요 → ARCHIVE 이관 권고 |
| ING-39 | salesforce_pages_developers_guide (817, 분할) — **퍼블리셔/Case Feed VF 컴포넌트 속성 레퍼런스 추출** | Visualforce/Component Reference | **✅ 완료 (2026-06-19)** → [[WORK_BACKLOG_ARCHIVE]] ING-39. ING-14 후속(source-coverage-checker 2026-06-18 발견). Visualforce Developer Guide의 퍼블리셔·Case Feed VF 컴포넌트 5개 **속성 완전 명세**: `apex:emailPublisher`(p.470)·`apex:logCallPublisher`(p.520)·`support:caseArticles`(p.670)·`support:caseFeed`(p.672)·`support:portalPublisher`(p.674). **공백 근거:** 위키에 VF 컴포넌트 속성 전수 레퍼런스가 **전무** — ING-14 노트는 이 컴포넌트들을 **예제/사용 맥락으로만** 다뤘고 전체 attribute 표(타입·필수·API버전·Access)는 미작성. 이 5개 속성 명세를 ING-14의 2노트에 보강하거나 별도 `Component Reference` 노트로 분리 판단. ※ ING-27/ING-37(같은 PDF 전체 817p 분할)의 일부지만, 이 5컴포넌트 속성만 먼저 떼어내는 소형 작업으로 우선 진행 가능 |
| ING-44 | **Embedded Service SDK (iOS/Android) · Messaging for In-App and Web 마이그레이션 노트** | Service/Chat (마이그레이션 대상) | ❌ 보류 (입수 게이트) — ING-13a·ING-36 후속. 은퇴한 레거시 Chat(2026-02-14)의 **권장 마이그레이션 대상**이나 해당 공식 가이드 PDF가 `Salesforce Documents/`에 **디스크 미보유** → PDF 입수 전 작성 불가. 입수 시 ING 번호 승격. (2026-06-18 ING-36 인라인 메모를 전용 행으로 승격) |
| ING-43 | `exp_cloud_lwr.pdf` (LWR Sites for Experience Cloud, 106p, Tier 2) — **Lightning Web Security(LWS) 노트** | Security(보안) / LWC | **✅ 완료 (2026-06-20)** → [[WORK_BACKLOG_ARCHIVE]] ING-43. 신규 `Security(보안)/Lightning Web Security (LWS).md`. ★ 제목 정정: "vs Locker"가 아닌 "Lightning Web Security (LWS)"(소스가 대칭 비교 못 채움 — Locker 직접 서술 0, 함의뿐). ★ 백로그 전제 오류 정정: 보강 대상이라던 `Lightning Web Security` 노트는 **부재**였고, `Lightning Security 모델` L20이 "LWS 격리모델은 [[LWC 보안 패턴]] 참조"로 보냈으나 그 목적지에 LWS 0 — **깨진 약속**을 신규 노트로 재지정. ★ fabricate 0: distortion·secure wrapper 내부동작·정식 비교표는 코퍼스 부재 → "소스 범위" 섹션에서 외부 deep-link 고지. completeness 갭 0·source-verifier 불일치 0·qa PASS. 버전 v66.0 Spring '26(본문 텍스트 확정, "Summer '26"은 표지 그래픽뿐) |
| ING-45 | `api_tooling.pdf` (1006p 분할, Tier 2) — **Tooling API 디버그 sObject 묶음** (ApexLog·TraceFlag·DebugLevel·ApexExecutionOverlayAction/Result·HeapDump + `/tooling/executeAnonymous/` 리소스) | Dev Tools / Debugging | **✅ 완료 (2026-06-20)** → [[WORK_BACKLOG_ARCHIVE]] ING-45. 신규 `Apex/Logging(로깅)/Tooling API 디버그·로그·리플레이 sObject.md`(~320줄) — 7객체+복합타입 100% 전수(TraceFlag 14필드·DebugLevel 카테고리 8×레벨 8 매트릭스·Language 18값·ApexLog·Overlay Action/Result·HeapDump complex type·executeAnonymous REST·ExecuteAnonymousResult). RECON-4(UI/선언적) ↔ ING-45(프로그래밍 방식) 양방향. RECON-11 line 16 예약 충족. completeness 갭 0·source-verifier 불일치 0·qa PASS. ★ scout 맵 오류 3건 researcher 정정(ApexLog/TraceFlag SAR 오귀속 배제·HeapDump 중첩타입 PDF 미정의 fabricate 금지) |

> ADMIN 갭(ADMIN-1~9)은 별도 — 공식 Admin 가이드 PDF 확보 시 진행. 위 INGEST는 이미 보유한 PDF 대상.
> **(선택/저우선) 레거시 호출 표면 메모** (RECON-6 작업 중 식별, 등재 보류 — 우선순위 낮음): `apex_developer_guide.pdf` "Invoking Apex" 챕터의 잔여 레거시 호출 표면 — Visualforce Classes 컨트롤러 10종(③)·JavaScript Remoting `@RemoteAction`(⑤)·Email Service 설정 측면(⑦~⑨). Visualforce는 레거시(LWC 권장)라 가치 낮음. 전용 ING/RECON 번호 부여는 보류하고, ING-27/37(pages_dev 전체 분할) 진행 시 함께 흡수 검토.

### 🟧 PARTIAL — 부분 인용 공식 PDF 보완 (커버리지 맵 직접 판정, 2026-06-16)

> **배경:** PDF별 위키 source 인용 수 집계에서 1~5건으로 "부분 의심" 분류된 PDF를 **카운트가 아니라 직접 판정**(인용 페이지 내용 + PDF 목차/분량 대조)한 결과. 카운트 1건이어도 INGEST에서 이미 "전수 완료"인 경우(api_rest/api_action/api_asynch/platform_events/api_console/exp_cloud_lwr/mobile_offline/bi_dev_guide/draes/data_loader/Flow백서)는 **거짓 부분 신호**(source 인용이 1페이지뿐이라 카운트만 낮음)라 제외. 작은 PDF가 사실상 완전 커버된 것(soql_sosl·validation_formulas·basics)도 제외. 아래는 **진짜로 많이 남은 것**만.

| # | 항목 | 소스/판정 근거 (이미 있는 페이지 / 빠진 범위) | 우선순위 | 상태 | 추가일 |
|---|---|---|---|---|---|
| ~~APEXLANG-1~~ | ✅ **완료(2026-06-17)** → [[WORK_BACKLOG_ARCHIVE]] PARTIAL-APEXLANG. 3분할 작성. 상세는 카드 2(아래) 참조 | — | ✅ 완료 | 2026-06-16 |
| ~~UIAPI-1~~ | ✅ **완료(2026-06-17)** → [[WORK_BACKLOG_ARCHIVE]] PARTIAL-UIAPI. spoke 분리(`LWC/LDS/UI API 리소스 레퍼런스.md` 신규). 상세는 카드 3(아래) 참조 | — | ✅ 완료 | 2026-06-16 |

> **부분 의심이었으나 제외(완전 커버/저가치 잔여):**
> · `salesforce_soql_sosl.pdf`(133p) — SOQL 폴더 7노트(문법 레퍼런스 915줄·SOSL 패턴 628줄 등)가 Ch2 SOQL·Ch3 SOSL 깊게 커버 → **사실상 완전.**
> · `salesforce_useful_validation_formulas.pdf`(35p, 79예제) — `Validation Rules 예제.md`(462줄, 40+예제)가 전 카테고리(REGEX·날짜·cross-object·PRIORVALUE 등) 커버, 단순 변형만 압축 → **사실상 완전.**
> · `basics.pdf`(269p) — 일반 사용자 입문서(로그인·검색·개인화). 개발 위키 가치 있는 부분(네비게이션·ID 인증·플랫폼 개요·컴포지션)은 4노트로 이미 흡수, 잔여는 저가치 → **제외.**
> · `lightningAura.pdf`(553p) — Aura는 레거시(Salesforce가 LWC 권장). Aura 폴더 3노트(구조·이벤트·vs LWC, 각 ~170줄)가 핵심 커버. 553p 전수는 저가치 → **의도적 부분 인정, 등록 보류.**

### ▶️ 실행 계획 — 부분 인용분 먼저 마무리 (2026-06-16 신설)

> **우선순위 원칙(명문화):** **이미 부분 착수된 공식 PDF(🟧 PARTIAL: LDV-1·APEXLANG-1·UIAPI-1)를 INGEST 미착수(🔲)보다 먼저 완료한다.** 부분 인용분은 "절반 열린 문"이라 방치 시 중복 작성·커버리지 착시를 유발하므로, 새 PDF 인제스트를 시작하기 전에 닫는다. (cf. MEMORY: "부분 완성 먼저 끝내기")
>
> **실행 순서:** ~~`LDV-1` (P2)~~ ✅ → ~~`APEXLANG-1` (P2)~~ ✅ → ~~`UIAPI-1` (P3)~~ ✅ → **🟧 PARTIAL 전부 완료(2026-06-17) → 이제 INGEST 단계로.** 다음 작업: INGEST 미착수(🔲) — ING-07·08·09 … (이미 보유한 PDF 대상). 우선순위는 도메인 가치·분량 고려해 선정.

#### 카드 1 — LDV-1 (우선순위 1) — ✅ 완료 (2026-06-17, → [[WORK_BACKLOG_ARCHIVE]] PARTIAL-LDV)

> **완료:** 2분할 — `Architecture(아키텍처)/대용량 데이터 (LDV) — 쿼리 옵티마이저·인덱싱.md` / `Architecture(아키텍처)/대용량 데이터 (LDV) — 대량 로드·삭제.md`. Query Optimizer 6동작·인덱스 selectivity 임계값 전수·Skinny 13필드타입·Divisions·대량 로드/삭제/추출·case study 6건. Data Skew와 양방향. source-verifier 셀단위 ✅·completeness 전수 ✅. 상세 행은 ARCHIVE 참조. (DoD 충족.)

#### 카드 2 — APEXLANG-1 (우선순위 2) — ✅ 완료 (2026-06-17, → [[WORK_BACKLOG_ARCHIVE]] PARTIAL-APEXLANG)

> **완료:** 3분할 — `Apex/Apex 언어 기초 — 데이터타입과 변수.md`(595줄) / `Apex/Apex 언어 기초 — 제어 흐름과 클래스.md`(1373줄) / `Apex/Apex 언어 기초 — 예외 처리와 예약어.md`(334줄). 소스 `salesforce_apex_developer_guide.pdf` v67.0 Summer '26. Primitive 12종 전수·연산자 전수표·Operator Precedence 15단계·Safe Navigation `?.`·Null Coalescing `??`·Switch 6패턴·접근제어자 4종·Properties 3종·상속/인터페이스/Custom Iterator·sharing 3종·try/catch/finally·커스텀 예외 4 implicit 생성자·예약어 121개+특수 키워드 10개. completeness 깊이 판정 ✅(갭 0, 예약어 기계 대조 IDENTICAL)·source-verifier 셀단위 ✅·qa ✅. namespace/메서드 레퍼런스·async/test/soql 중복 0(위임 링크). webservice 키워드 상세·Annotations 카탈로그는 차기 작업 분류. 상세 행은 ARCHIVE 참조. (DoD 전 항목 충족.)

#### 카드 3 — UIAPI-1 (우선순위 3) — ✅ 완료 (2026-06-17, → [[WORK_BACKLOG_ARCHIVE]] PARTIAL-UIAPI)

> **완료:** **보완→spoke 분리**로 귀결. 신규 `LWC/LDS/UI API 리소스 레퍼런스.md`(1865줄, Tier 2 `api_ui.pdf` v67.0 Summer '26 Ch3-5) 생성. 기존 `UI API 개요.md`(엔드포인트·wire 매핑·상태코드 허브)는 보존하고 §2·§3에 레퍼런스 포인터 2줄 + 관련노트 역링크 삽입(분량 폭증 1865줄이라 단일 파일 보완이 아니라 깊이 보존형 spoke 분리 선택; 요청/응답 2분할 fallback은 불필요 판단). 157항목 전수 — Ch3 Request Parameters 16리소스 + Ch4 Request Bodies 27종 + Ch5 Response Bodies 114종(Top-Level 37·Nested 77). enum 418값 전수·Filter Group/Available Version 2컬럼 보존·원문 오타 보존·67.0 신규필드 4종. completeness 깊이 ✅(갭 0)·source-verifier 셀단위 ✅(Location Field `maybe null` 1건 정정)·qa ✅. 개요 엔드포인트표·wire 매핑·상태코드와 중복 0. getPicklistValues 패턴↔레퍼런스 역링크. `_index/frontend.md`·`LWC MOC`·`LWC/LDS/index.md` 등록. 상세 행은 ARCHIVE 참조. (DoD 전 항목 충족.)

### 🟦 SUM26-FU — Summer '26 릴리즈 후속 (source-coverage-checker "차기" 분류, 2026-06-15)

> **배경:** Summer '26 릴리즈 노트 재작성(허브+5스포크) 중 source-coverage-checker가 "이번 범위 밖이지만 GA로 명시된 신규 개발자 API"로 분류한 항목. 릴리즈 노트가 GA 신규 네임스페이스를 알려주면 후속 reference 작성을 트리거한다(릴리즈 writer→후속 작업 큐). 실제 작성은 해당 도메인 공식 가이드/Apex Reference(Tier 2)로 채운다 — 릴리즈 노트 한 줄을 그대로 옮기지 않는다.

| # | 항목 | 소스/사유 | 상태 | 추가일 |
|---|---|---|---|---|
| SUM26-FU-1 | Industries 도메인 개발자 API 보강 (Connect REST·Invocable) | Summer '26에서 Industries 버티컬 신규 Connect REST·Invocable 액션 다수. 공식 Industries 개발자 가이드 확보 시 진행 | 🔲 대기 | 2026-06-15 |
| SUM26-FU-2 | Revenue Management REST/sObject v67.0 엔드포인트 코드 | Summer '26 Revenue Management 신규 REST/sObject 엔드포인트. 코드 예제는 공식 REST 가이드 발췌 | 🔲 대기 | 2026-06-15 |
| SUM26-FU-3 | DocumentAI · hlthcrbilling 신규 Apex 네임스페이스 reference | Summer '26 GA 신규 Apex 네임스페이스(GA 신규 클래스 다수). Apex Reference v67.0에서 클래스·메서드 전수 추출 | 🔲 대기 | 2026-06-15 |

### 🟪 RECONCILE — 소스 문서 완전성 재감사 (2026-06-19 신설)

> **배경:** 두 실패에서 드러난 구조적 공백 — (A) 부분 검색에 근거한 '없음' 단정(DevOps Center를 PDF 2개만 grep하고 "공식 문서에 없다"고 단정 → 49개 전수 grep에서 `apex_developer_guide`·`api_meta`에 실재 확인), (B) **이미 위키화된 PDF의 불완전 챕터 커버리지**(`apex_developer_guide`의 "Deploying Apex" 챕터가 통째로 미추출). 기존 어느 에이전트도 'PDF 전체 챕터/섹션 단위 커버리지'를 추적하지 않았다(completeness-validator는 작성된 노트의 충실도만, 아예 추출 안 된 챕터는 못 잡음).
> **에이전트 프로토콜 반영:** scout.md·source-coverage-checker.md(전수 grep + 동일 PDF 미추출 챕터 보고)·researcher.md(추출 전 챕터 범위 명시)·completeness-validator.md(문서 레벨 커버리지 점검) — 아래 "프로토콜 개선 이력" AP-08 참조.

**재감사 방법론(PDF 1개당):**
```
(1) 목차/챕터 구조 추출    — pdftotext -f 1 -l 12 "...pdf" - | grep -niE "chapter|\.\.\."
(2) source 인용 노트 수집  — grep -rl "<pdf 식별자>" forceNote-wiki/ --include="*.md"
(3) 챕터별 커버 여부 매핑  — 각 챕터를 다루는 노트가 1개라도 있는지
(4) 미커버 챕터를 백로그 항목으로 등재 — INGEST/PARTIAL 형식으로 ING-/RECON- 번호 부여
```

| # | 항목 | 소스/판정 근거 | 우선순위 | 상태 | 추가일 |
|---|---|---|---|---|---|
| RECON-1 | **`apex_developer_guide.pdf` "Deploying Apex" 챕터 미커버** (AP-08 증명 사례) | **✅ 완료 (2026-06-19)** → [[WORK_BACKLOG_ARCHIVE]] RECON. 신규 `DevOps(데브옵스)/Apex 배포 방법.md` — 챕터-깊이 커버 완료. 더 깊은 per-method 단독 자료는 scope discipline으로 RECON-10·11 분리, apex_developer_guide 미커버 잔여 챕터는 RECON-4~9로 등재. | **P1** | ✅ 완료 | 2026-06-19 |
| RECON-3 | **대형/멀티토픽 PDF 챕터 커버리지 재감사 — 우선순위 초안** | 위 4단계 방법론을 source 자주 인용되는 대형 PDF에 순차 적용. **진행:** ①✅·②✅·③✅·④✅·⑤✅ — **RECON-3 전체 마감(2026-06-19).** 대형 5종 챕터 커버리지 재감사 완료. **① `apex_developer_guide.pdf`** ✅ — 다도메인 언어 가이드(Deploying Apex 외 Debugging/ApexDoc/Invoking/Triggers 챕터 점검). RECON-1 첫 발견, **RECON-4~9·12·13이 이 ① 산출물 — completeness-validator 문서 레벨 커버리지 맵 2026-06-19**(고가치 챕터 RECON-1/4/5/6/12 닫힘; RECON-7/8/10/13 ✅·RECON-9 de-scoped 2026-06-19·RECON-11[Tooling API 배포] ✅ 2026-06-20·RECON-16[Chatter/Knowledge 트리거 고려사항] ✅ 2026-06-20 → **apex_developer_guide.pdf 전 챕터 커버 완료, 잔여 미커버 0**). **② `pkg2_dev.pdf`** ✅ (2GP, **2026-06-19 닫힘**) — 4단계 감사 결과 단일 "Chapter 1"에 17개 H2 구조, 16개 H2는 기존 ~28개 2GP 노트가 전부 커버, **유일 미커버 H2 "Gaps Between First- and Second-Generation Managed Packaging"(print p.505)** = 2GP-13으로 닫음(`2GP Managed Package 개념과 1GP 비교.md` §9 추가). **이 PDF에서 새로 발견된 미커버 잔여 챕터 없음 → 전 H2 닫힘, 신규 RECON-N 등재 불필요.** (★ 백로그 page "p.505-517"은 과대추정 — 실측 print p.505 단일 페이지뿐, p.506-517은 PDF back-matter/index였음.) **③ `sfdx_dev.pdf`** ✅ (2026-06-19 닫힘) — v67.0 Summer '26 ToC 실측 16챕터, H2 레벨 전수 grep 대조 결과 28노트가 전 H2 커버. "16챕터 완료" 표기 **참 검증**. DevOps Center scratch feature/setting·Org Shape 활성화·DX MCP `devops` 툴셋·source tracking 규칙 모두 기존 노트 커버 확인. 신규 미커버 0 → RECON-N 등재 불필요(read-only 감사). **④ `api_meta.pdf`** ✅ (2026-06-19 닫힘) — 메타데이터 타입 전수 vs 위키 인용 재감사 + closure. (a) 메커니즘 챕터(Ch0 — File-Based/CRUD 호출 등) 미커버 0, (b) Metadata Types 도메인그룹 미커버 0, (c) RECON-2(DevOps Center DevHubSettings 2필드 `enableALMDevopsCorePref`/`enableDevOpsCenterGA` — `DevOps Center.md`에 이미 반영, 재감사 확인) / ING-40(CustomAddressFieldSettings delta) / ING-42(AddressSettings) 전부 닫힘. 신규 미커버 잔여는 저위험 1건(RECON-14, Ch4 Run Relevant Apex Tests in a Deployment Beta)으로 분리 등재 후 ✅ 완료(2026-06-19, 재검증 결과 실제 공백 발견 → File-Based 호출 노트에 §RunRelevantTests Beta 신설). **⑤ `object_reference.pdf`** ✅ (2026-06-19 닫힘) — v67.0 Summer '26, Ch1-6 "완료" 표기 **참 검증**(32 서브페이지 전수 커버). ING-41(표준 Address compound)은 **기실재**(Compound Fields.md가 이미 전수 보유 — 오판정). 유일 미커버는 Ch1 "Field and Type Differences"(저가치) → RECON-15 분리. **→ RECON-3 ①~⑤ 전부 완료, 항목 마감.** 잔여 저가치 챕터(RECON-7/8/9/10/11/13/14/15)는 별도 P3 sweep. | **P2** | ✅ 완료 (①~⑤) | 2026-06-19 |
| RECON-4 | ~~`apex_developer_guide.pdf` "Debugging Apex" → Debug Log 서브섹션 미커버~~ | **✅ 완료 (2026-06-19)** → [[WORK_BACKLOG_ARCHIVE]] RECON-4. 신규 `Apex/Logging(로깅)/Apex Debug Log.md` — 로그 카테고리 10종·레벨 8종 전수·Event Type 매트릭스·DebuggingHeader·Order of Precedence. ★ planner 이미지추정(8/7)→텍스트 실측 정정(10/8). 프로그래밍 로그 제어는 ING-45로 분리 | **P2** | ✅ 완료 | 2026-06-19 |
| RECON-5 | ~~`apex_developer_guide.pdf` "Document Your Apex Code / ApexDoc" 챕터 미커버~~ | **✅ 완료 (2026-06-19)** → [[WORK_BACKLOG_ARCHIVE]] RECON-5. 신규 `Apex/ApexDoc 주석 작성 가이드.md` — ApexDoc 태그 전수(`@description`·`@param`·`@return`·`@throws`·`@see`·`@link`) | **P2** | ✅ 완료 | 2026-06-19 |
| RECON-6 | ~~`apex_developer_guide.pdf` "Invoking Apex" PARTIAL — Anonymous Apex·@WebService~~ | **✅ 완료 (2026-06-19)** → [[WORK_BACKLOG_ARCHIVE]] RECON-6. 신규 2노트(`Anonymous Apex 실행.md`·`SOAP Web Services 노출 (webservice 키워드).md`). ★ dump 코드 페이지경계 절단 검증 갭 발견→source-verifier/completeness-validator 프로토콜 보강(AP-09). Triggers(②)는 RECON-12로 분리 | **P2** | ✅ 완료 | 2026-06-19 |
| RECON-7 | ~~`apex_developer_guide.pdf` "Introducing Apex" + "Apex Development Process" 개념 개요~~ | **✅ 완료 (2026-06-19)** → [[WORK_BACKLOG_ARCHIVE]] RECON-7. 신규 `Apex/Introducing Apex — 개요와 개발 프로세스.md`(둘을 1노트 결합: What is Apex·언제·동작 방식 + 개발→테스트→배포 프로세스). 언어 문법은 언어 기초 노트로 위임 | **P3** | ✅ 완료 | 2026-06-19 |
| RECON-8 | ~~`apex_developer_guide.pdf` "Apex Versioned Behavior Changes" 부록~~ | **✅ 완료 (2026-06-19)** → [[WORK_BACKLOG_ARCHIVE]] RECON-8. 신규 `Apex/Apex 버전별 동작 변경 레퍼런스.md` — version-gated lookup 인덱스(v15~v67, 32버전·API Ref 23행 전수, 버전 내림차순). 개별 메커니즘은 deep-link 위임. ※ 본문 자기기술 "22행" → 실제 23행(콘텐츠 누락 아님, 숫자 표기만 writer 후속 정정 예정) | **P3** | ✅ 완료 | 2026-06-19 |
| RECON-9 | ~~`apex_developer_guide.pdf` "Apex Quick Start"·"Shipping Invoice Example" 튜토리얼/샘플~~ | **de-scoped (2026-06-19)** → [[WORK_BACKLOG_ARCHIVE]] RECON-9. 명시적 de-scope: 고유 레퍼런스 가치 0 — "Deploy to Production"은 RECON-10(Change Sets deep 노트)으로 흡수, 나머지(Quick Start 튜토리얼·Shipping Invoice 샘플 워크스루)는 언어 기초·트리거·테스트 노트가 이미 커버. 튜토리얼/샘플 자체는 위키화 가치 최소 | **P3 (de-scoped)** | ✅ de-scoped | 2026-06-19 |
| RECON-10 | ~~**Change Sets 단독 deep 노트** (outbound/inbound step-by-step·deployment connections·permissions)~~ | **✅ 완료 (2026-06-19)** → [[WORK_BACKLOG_ARCHIVE]] RECON-10. 신규 `DevOps(데브옵스)/Change Sets 배포.md` — outbound/inbound 단계 전수(컴포넌트 담기·Upload·연결된 org Deploy). deployment connection 설정 등 apex_developer_guide 미수록분은 Salesforce Help SEE ALSO 위임. RECON-1 `Apex 배포 방법`(챕터-깊이 비교)에서 분리한 deep 노트 | **P3** | ✅ 완료 | 2026-06-19 |
| RECON-12 | ~~`apex_developer_guide.pdf` "Invoking Apex" 챕터 ② Triggers — 언어 레퍼런스 공백~~ | **✅ 완료 (2026-06-19)** → [[WORK_BACKLOG_ARCHIVE]] RECON-12. 신규 2노트: `Apex/Trigger(트리거)/Trigger 컨텍스트 변수와 이벤트.md`(컨텍스트 변수 13종·TriggerOperation enum 7종·이벤트 7×3 매트릭스·문법·merge/recovered) + `Architecture(아키텍처)/Trigger Order of Execution.md`(20단계 save lifecycle·재귀 skip 9~17). 기존 핸들러/재귀/System Namespace 양방향 역링크. retrospective(모드 A): aliases 매트릭스 자연어 질문·operationType switch·저장 순서 몇 번째 보강 | **P2~P3** | ✅ 완료 | 2026-06-19 |
| RECON-13 | ~~**`apex_developer_guide.pdf` "Triggers" 챕터 잔여 서브섹션** — Trigger Exceptions + Common Bulk Trigger Idioms + Operations That Don't Invoke Triggers~~ | **✅ 완료 (2026-06-19)** → [[WORK_BACKLOG_ARCHIVE]] RECON-13. 신규 `Apex/Trigger(트리거)/Trigger 벌크 관용구·미발생 작업·예외.md` — 벌크 Map/Set 관용구·트리거 미발생 시스템 작업 전수·before/after 갱신 불가 필드·addError() 예외 마킹/부분 저장. 기존 컨텍스트변수/핸들러/재귀/Order of Execution 노트와 deep-link(중복 회피) | **P2~P3** | ✅ 완료 | 2026-06-19 |
| RECON-17 | ~~**`exp_cloud_lwr.pdf` (LWR Sites, 106p) 챕터 커버리지 — ING-10a "완료"였으나 H2 단위 대부분 미커버**~~ | **✅ 전체 완료 (2026-06-20)** → [[WORK_BACKLOG_ARCHIVE]] RECON-17·17a~d. ING-43(LWS) scout 발견(ToC 위키화됨이나 H2 단위 완전커버 0·부분 6·미커버 2). 1차(허브 확장+spoke 2: 다국어·Expressions) + **deferred 4 spoke 전수**: 17a `LWR 동작·캐싱·제약`(Ch2)·17b `LWR 컴포넌트 개발 심화`(Ch3)·17c `LWR --dxp 스타일링 훅 레퍼런스`(Ch4, 8p 거대표 pdftoppm)·17d `LWR Tag Manager 데이터 관리`(Ch7+Ch6, 이벤트 9종 pdftoppm·동명이의 2종). **exp_cloud_lwr.pdf(106p) 완전 위키화 완료.** ★ 교훈: "ING 완료" 표기도 H2 단위로는 thin slice일 수 있음(ToC 레벨 ≠ H2 레벨). 4 spoke 전부 completeness 갭0·source-verifier 불일치0·qa PASS·Tier3 0 | **P3** | ✅ 완료 | 2026-06-20 |

### ⚪ P4 — 장기 (큰 인프라 결정)

| # | 항목 | 소스/사유 | 상태 | 추가일 |
|---|---|---|---|---|
| PIPE-6 | Phase 2 — LLM-level source-verifier 자동 invocation 도입 | L1 훅은 구조만 검사 → 의미 오류(Snapshot 할당량 같은 numeric error)는 사용자 평가로만 발견. settings.json에 SubagentStop 훅으로 source-verifier 자동 호출 검토. ROI 시뮬레이션 필요. | 🔲 대기 | 2026-05-23 |

> **다음 후보(미등록):** N3 시리즈 — Experience Cloud · Reports API · Tooling API 등. 소스 PDF 확보 시 행으로 승격.

### 🟤 P5 — 장기 검증 (소스 출처 확인)

| # | 항목 | 소스/사유 | 상태 | 추가일 |
|---|---|---|---|---|
| VERIFY-1 | **Winter '24 `sf project deploy pipeline` 출처 검증** | `Release/Winter '24/Development.md`가 `sf project deploy pipeline`을 "Deploy Changes Using Salesforce CLI (Beta)" 실기능으로 서술 중이나, 로컬 52개 PDF 전수 grep에서 이 명령은 **0건**(DevOps Center 조사 중 source-verifier 발견). `salesforce_winter24_release_notes.pdf`가 출처일 가능성 → 해당 PDF로 대조 검증. **출처 확인 시** Tier 2 유지·DevOps Center 노트의 `sf project deploy pipeline` 미검증 경고 해제 가능. **미확인 시** fabrication 여부 판정 후 조치. RECON 프로젝트와 연계(같은 DevOps Center 조사에서 파생) | 🔲 대기 | 2026-06-19 |

---

## 에이전트 프로토콜 개선 이력

> 커버리지 공백이 아닌 **에이전트 규칙 수정**(wiki-retrospective 모드 B)을 기록한다. (누적되어도 작으므로 활성 파일에 유지)

| # | 개선 | 수정 파일 | 상태 | 일자 |
|---|---|---|---|---|
| AP-01 | 단방향 링크 재발(콘텐츠 섬) 차단 — writer 자가 체크리스트에 형제 노트 역링크 규칙 추가(진짜 상호 관계만, specific→일반 허브는 단방향 유지), wiki-retrospective 모드 B 근본원인 표에 해당 행 추가 | `writer.md`, `wiki-retrospective.md` | ✅ 완료 | 2026-05-23 |
| AP-02 | fan-in 허브 휴리스틱이 nav 링크(index·MOC·00 Home·SEARCH_INDEX)로 오염돼 실패(진짜 허브도 nav 포함 시 raw 3~4, nav 제외 spoke fan-in은 2~3뿐이라 "≥5" 밴드가 오분류) → 이름/역할 1차 + nav 제외 spoke fan-in(≥2 형제) 2차로 정정, raw 단방향 총량 헤드라인 금지(실행마다 흔들려 비교 불가)·3분류 보고 규칙 추가. check #6 일관성 잠금(writer↔linter) 유지 | `wiki-linter.md` | ✅ 완료 | 2026-05-23 |
| AP-03 | PDF 기반 작성 4 패턴(A·B·C·D) protocol 도입 — Pattern A(섹션별 재추출 + 6 카테고리 spot check), B(격자형 매트릭스 + 산문형 numeric mapping), C(pdftotext 시각자료 blind spot 대응), D(structure rigidity 회피) — 6개 agent에 역할별 protocol 분배. 1차(Task #1 발견)+2차 진화(Task #2 Snapshot 할당량 오류로 spot check를 무작위→6 카테고리, Pattern B를 산문형까지 확장) 적용. | `writer.md`, `scout.md`, `researcher.md`, `classifier.md`, `source-verifier.md`, `completeness-validator.md`, `CLAUDE.md` 0-2 표 | ✅ 완료 | 2026-05-23 |
| AP-04 | L1 wiki lint 훅 도입 — `.claude/settings.json` PostToolUse 훅이 `scripts/lint-md-file.sh` 호출, `.md` 파일 Write/Edit 시 자동 검증(frontmatter·요약·코드블록·관련 노트·source값·깨진 wikilink). 순수 bash(Mac/Win 공통). 의미 오류는 못 잡고 구조만 검사 — Phase 2(LLM source-verifier 자동 호출)는 PIPE-6 백로그. | `.claude/settings.json`, `scripts/lint-md-file.sh` | ✅ 완료 | 2026-05-23 |
| AP-05 | PDF 페이지 오프셋(ToC 인쇄번호 ≠ PDF 물리페이지) 확인 절차 추가 — ING-31에서 표지/목차 4p로 +4 오프셋 발견(scout가 캐치). ToC 번호를 그대로 `pdftotext -f/-l`에 넣으면 **틀린 챕터를 에러 없이 추출**(추출 성공→source-verifier 전까지 미발견)하므로, scout가 매 PDF 1회 오프셋 실측→물리페이지 환산 범위를 researcher에 전달. Why 첨부. (첫 발견·캐치 성공이나, silent-error 성격상 예방 가치 높아 additive 규칙화) | `scout.md` | ✅ 완료 | 2026-06-18 |
| AP-06 | **최상위 TOC 불완전 가능성 — 리소스 하위 중첩 항목 교차검증 절차** 추가 — ING-13a에서 최상위 TOC가 Ch6 "Messages Response Objects"의 **14개 하위 응답 객체**를 누락(리소스 1개 아래 중첩됨). 최상위 TOC만 신뢰하면 source-coverage 누락이 **추출 성공·구조상 멀쩡으로 위장**(AP-05와 동류의 silent gap). scout는 매 reference-PDF에서 TOC뿐 아니라 **PDF 뒤쪽 색인(index)·각 리소스 본문의 "Response Objects/Sub-resources" 헤딩**도 1회 훑어 중첩 항목 목록을 완성→researcher/coverage-checker에 전달, completeness-validator는 "리소스 N개" 카운트가 아니라 **중첩 하위 항목 전수**로 판정. Why 첨부(reference 가이드는 리소스 아래 응답객체·서브리소스를 TOC에 펼치지 않는 구조가 흔함). ING-13a에서 scout가 캐치·validator 14개 확인했으나, 예방 가치 높아 additive 규칙화 | `scout.md`, `completeness-validator.md` | 🔲 권고(다음 모드 B에서 반영) | 2026-06-18 |
| AP-08 | **소스 문서 완전성 — 전수 grep + 챕터 단위 커버리지 추적** 도입 (모드 B, RECONCILE 신설 동반) — 두 실패 반영: (A) **부재 단정 전 전체 PDF 집합 전수 grep + 인접 도메인 문서 확인** 규칙(DevOps Center를 PDF 2개만 grep하고 "없다"고 단정→49개 전수에서 apex_developer_guide·api_meta 실재). 부정 단정에 전수 검색 증거 첨부 의무화 → `scout.md`·`source-coverage-checker.md`. (B) **멀티토픽 대형 PDF의 챕터/섹션 단위 커버리지 추적**(apex_developer_guide "Deploying Apex" 챕터가 위키화된 PDF인데 통째로 미추출) — scout/researcher는 추출 전 ToC로 커버/미커버 챕터 명시, source-coverage-checker는 동일 PDF 내 미추출 챕터를 누락 소스로 보고, completeness-validator는 노트 단위 충실도뿐 아니라 **문서 레벨 커버리지**(미추출 챕터)도 점검 → `scout.md`·`researcher.md`·`source-coverage-checker.md`·`completeness-validator.md`. Why 첨부, additive(기존 규칙 약화 없음). 증명 사례 RECON-1로 백로그 등재 | `scout.md`, `researcher.md`, `source-coverage-checker.md`, `completeness-validator.md` | ✅ 완료 | 2026-06-19 |
| AP-07 | **`questions.md` 교차 도메인 보조 샤드 예외 명문화** (LINT-4) — `_index/questions.md`는 "교차 도메인 질문 라우팅 보조 샤드"로, 설계 의도상 다른 도메인 샤드에 이미 등재된 파일을 자연어 질문 형태로 재등재한다. "1 페이지 = 1 홈 샤드"(중복 행 금지) 규칙을 그대로 적용하면 wiki-linter가 이를 중복/고아 위반으로 **오탐**하므로, (a) CLAUDE.md "탐색 인덱스 구조" 표 "1 페이지 = 1 홈 샤드" 행 비고에 공식 예외 문구 추가, (b) wiki-linter.md 고아 탐지(check #2)·샤드 건강/중복(check #3b) 판정에 questions.md 제외 안내 추가. Why 첨부(보조 샤드는 라우팅 목적상 의도된 재등재이므로 중복 금지 규칙의 적용 대상이 아님). additive — 기존 규칙 약화 없음 | `CLAUDE.md`, `wiki-linter.md` | ✅ 완료 | 2026-06-18 |
| AP-09 | **researcher dump 코드 블록 페이지 경계 절단 — dump↔노트 대조만으로 미검출되는 silent gap 차단** (RECON-6 발견) — RECON-6 External Reference 예제에서 researcher dump가 **PDF 페이지 브레이크 지점에서 코드 블록을 끊은 채** 끝났는데, writer가 그 잘림을 "원문 끝"으로 오판했고 completeness-validator는 **dump만 대조**(노트↔dump 일치)했기에 통과시켰다. dump↔노트 대조는 dump 자체의 절단을 **구조상 절대 드러내지 못한다**(둘 다 같은 지점에서 끝나면 일치). source-verifier만 PDF 원문을 추가로 떠서 코드가 다음 페이지로 이어짐을 발견했다. → (a) source-verifier.md §3에 "코드 블록이 닫히지 않은 채/페이지 경계 근처에서 멈추면 PDF 원문(해당+다음 1~2p) 추가 추출로 이어짐 확인" 규칙 추가, (b) completeness-validator.md §7에 "코드 블록 절단 의심 시 dump만으로 '완전' 판정 금지·불완전 의심 표시 후 source-verifier/PDF로 위임" 규칙 추가. Why 첨부(dump↔노트 대조는 dump의 절단을 못 잡는 구조적 한계). additive — 기존 코드 대조·충실도 규칙 약화 없음 | `source-verifier.md`, `completeness-validator.md` | ✅ 완료 | 2026-06-19 |

---

## Lint 실행 이력

> `/lint` 실행 1회당 1행. 발견 세부는 행 안에 압축한다. 미해결 항목만 위 "열린 항목"으로 승격하고, 신규 작성이 필요한 깨진 링크 상세는 [[WORK_BACKLOG_ARCHIVE]]의 L·I 섹션에 보존.

| 일자 | 발견 | 수정/조치 | 남은 open |
|---|---|---|---|
| 2026-05-21 | 깨진 wikilink 15건 · 깨진 샤드 경로 8건 | 즉시 6건 수정 + 2건 재연결, 신규 작성 필요분은 아카이브 L·I 섹션으로 분류 | Spring '26 |
| 2026-05-23 | 깨진 링크 2건(SLDS 슬래시·Metadata 경로 prefix) · MOC 누락 5건 · 단방향 링크 317건 | 8건 수정(SLDS×2·경로×1·Apex MOC 신규 5) · 단방향 분석→신규 클러스터 18 역링크 추가, hub-spoke 다수는 의도적 단방향 보존 · 근본원인 프로토콜화(→AP-01) | Spring '26 |
| 2026-05-23 (3차) | ❌ genuine peer 36→0 확인(cross-linker 16건 역링크 후) · 잔여 단방향 17건은 전부 의도적(spoke→hub + 약한 관계, 휴리스틱-판단 일치) · fan-in 허브 휴리스틱 결함 발견(nav 링크 오염으로 진짜 허브 오분류) | ❌ 0 도달 확인 · fan-in 휴리스틱 정정(이름/역할 1차 + nav 제외 spoke fan-in 2차, raw 총량 헤드라인 금지·3분류 보고)→AP-02 | Spring '26 |
| 2026-06-18 | LINT-1~4 해소 워크리스트. 깨진 wikilink(MetadataAPI 경로 prefix 누락 20건, LINT-1)·peer 역링크 3건(LINT-3)은 index-manager/cross-linker가 수정. MOC 누락(SLDS·Enhanced Domains, LINT-2)은 재확인 결과 기해소(LWC MOC L136·138, Architecture MOC L44 존재). questions.md 보조 샤드의 중복/고아 오탐(LINT-4)은 거버넌스 예외 명문화로 해소. | LINT-1·2·3·4 전부 ✅(2026-06-18) → 열린 항목 P0에서 상태 갱신. LINT-4 예외는 AP-07로 프로토콜 이력화(CLAUDE.md + wiki-linter.md). | 없음 |

---

## 상태 범례

| 아이콘 | 의미 |
|---|---|
| 🔲 대기 | 아직 작업 시작 전 |
| 🟡 진행중 | 현재 작업 중 |
| ✅ 완료 | 작업 완료 + wiki 반영 확인 → [[WORK_BACKLOG_ARCHIVE]]로 이동 |
| ❌ 보류 | 소스 미확보 등의 이유로 보류 |

---

## 관련 파일·에이전트

- [[WORK_BACKLOG_ARCHIVE]] — 완료 항목 영속 대장 (append-only, 통독용 아님)
- [[wiki-retrospective]] — 모드 B에서 이 백로그를 읽고 업데이트하며 에이전트 프로토콜 개선
- [[pm]] — 백로그 항목을 실제 작업으로 스케줄링
