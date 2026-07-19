---
tags: [backlog, coverage, work-tracking]
created: 2026-05-18
updated: 2026-07-17
---

> **세션 인계 메모 (2026-07-12 세션 종료 시점):**
> **3층(Diátaxis) 커버리지 파일럿 프로그램 전체 완료** — 위키 전 도메인(Integration·Apex·LWC·Flow·Aura·VF·Security·Admin·DevOps·Service·Analytics·sObject·Architecture + 클라우드/산업 9소도메인)을 개념·레퍼런스·절차 3층으로 진단하고 실질 갭을 선별 보충. 정본은 [[Interface 답변 커버리지 검증 - Verification Harness]]. 후기 파일럿일수록 신규 콘텐츠가 도메인당 1건으로 수렴하고 findability·결정 가이드 synthesis가 주가 됨. **남은 파일럿 0.** 위키 전체 lint(2026-07-12) 콘텐츠 무결성 5항목 전부 0건. 다음 세션 후보는 아래 열린 항목의 개별 콘텐츠 갭(COVERAGE-GAP: AGENT-CONCEPT-1·ANALYTICS-1·AI-CLASSIC-1·OMNISTUDIO-2[EPC/Calc] 등) — 방법론 2가 아니라 각각 독립 인제스트. **✅ 2026-07-13 세션 완료분:** CDC-1(Change Data Capture 5노트)·INT-DEEP-1(Salesforce Connect·Outbound Messaging 2노트)·OMNISTUDIO-1(OmniStudio 8노트+신규 샤드) → 전부 [[WORK_BACKLOG_ARCHIVE]] 이관. **false gap 정리:** EXP-DEV-1(이미 완료)·SEC-MON-1(ADMIN-EXH W2 해소). **라이브 문서 소싱 하네스 확립**: developer.salesforce.com=콘텐츠 API fetch, help.salesforce.com=H1→컨테이너 deepText, 대량은 general-purpose 서브에이전트 위임(표시 한도 우회). 병렬 브라우저는 탭 hijack 위험 → 순차 권장.

> **세션 인계 메모 (2026-07-17):** **구조 감사 STRUCT-AUDIT-1 완료** — 4축 병렬 감사(탐색 아키텍처/팀 시스템/폴더 구조/문서 정합성). 총평: 핵심 설계 건전(라우터↔샤드 33개 완전 정합·고아 0%·Windows 파일명 0건). 발견 결함은 당일 전부 수정(AP-11 일괄) + `_index/frontend.md` 분할·00 Home 최신화(index-manager). 남은 중기 발전 항목은 **STRUCT-1~8** 섹션 참조 — 최우선 추천: STRUCT-1(CLAUDE.md 감량)·STRUCT-4(Admin↔Security 경계, 비용 극소).

> **세션 인계 메모 (2026-07-18):** **STRUCT/PIPE/DEC 발전 항목 일괄 처리(B→C 순)** — 완료: STRUCT-1(CLAUDE.md −25%·Layer3표→`_MOC/NAV_MAP.md`·Windows상세 분리)·STRUCT-4(Admin↔Security 경계 3파일)·STRUCT-5(파이프라인 슬림화 보수적: 기계적 wikilink 존재검사만 훅 위임)·STRUCT-6(questions.md 분할 규칙)·STRUCT-8(신규 `scripts/wiki-structure-check.sh` 결정적 게이트)·STRUCT-9(scout.md −42%·규칙 전수 보존)·PIPE-3/4/5(researcher dump·scout↔researcher 계약·classifier depth 한계)·DEC-2(이미지 선별 첨부 정책 정본화, 사용자 결정) → 전부 [[WORK_BACKLOG_ARCHIVE]] 이관. **부수:** AP-06이 실제로는 scout.md 미적용이었음을 발견→반영(AP 이력 갱신). 신규 나브 파일 2개(`_MOC/NAV_MAP.md`·`_MOC/Windows 파일명 제한 (상세).md`). **A그룹 착수:** **AI-CLASSIC-1 ✅ + ANALYTICS-1 ✅ 완료** — ①`Einstein(아인슈타인)/` 4노트+샤드 `_index/einstein.md`(라우터 36) ②`Analytics(애널리틱스)/` CRM Analytics REST 3노트(developer.salesforce.com `bi_dev_guide_rest` v67.0, 이름 함정 배제, 표현형·enum 전수). ③**ING-25 ✅**: extend_click_automate 1027p → 챕터 diff로 스코프 축소, 진짜 갭은 Approval 운영·레퍼런스 심화 1노트(`Admin/Approval Process — 운영·엔드유저·레퍼런스`). ④**OMNISTUDIO-2 ✅(EPC)**: `OmniStudio(옴니스튜디오)/Enterprise Product Catalog (EPC) — 데이터 모델·명명·번들.md` — **로컬 Tier-1 sf-skill refs로 소싱**(세션 한도 fallback, 브라우저 대신). 스킬맵 OmniStudio 갭 1→0. **A그룹 4개 전부 완료**(단 OMNISTUDIO-2는 EPC만·Calculation은 2b 분리). 넷 다 파이프라인 PASS. → [[WORK_BACKLOG_ARCHIVE]]. **남은 열린 항목:** STRUCT-2·3·7(설계상 지연)·PIPE-1·PIPE-6(인프라)·SUM26-FU-1/2/3(소스 게이트)·QA-GAP-1(저가치)·**신규 심화: AI-CLASSIC-2·ANALYTICS-2·OMNISTUDIO-2b(Calculation, 로컬소스 없음)**·(선택)ING-25 각주² 복구. **⚠️ 세션 한도 도달**(8:40pm KST 리셋)로 ING-25·OMNISTUDIO-2 후반은 메인 세션 직접 수행(서브에이전트 스폰 실패 대비 로컬소스·직접검증).

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

> 현재 열린 항목 없음. **PIPE-2**(writer `Bash` 도구 부여 + 본문 도구설명 동기화) ✅ 완료(2026-06-27) → [[WORK_BACKLOG_ARCHIVE]]. frontmatter엔 이미 `Bash` 존재했으나 본문 "사용 가능한 도구"가 Read/Write/Edit만 설명해 불일치였음 → Bash 행 추가 + Pattern A 재추출 용도(AP-09 절단 차단) 명시.

### 🟡 P1 — Task #4(대형 카탈로그) 전 필요

> 전 항목(PIPE-3·4·5) ✅ 완료(2026-07-18) → [[WORK_BACKLOG_ARCHIVE]] STRUCT·PIPE·DEC 섹션. researcher 대형 PDF dump 정책·scout↔researcher 시각자료 계약·classifier depth-balance 한계 전부 반영. 신규 파이프라인 갭 발생 시 이 표에 🔲로 추가.

### 🟢 P2 — 2GP 시리즈 연속 작업 (Task #3 통과 후 본격 진행)

> 전 항목(2GP-3~2GP-13) ✅ 완료 → [[WORK_BACKLOG_ARCHIVE]] 이관(2026-06-27). pkg2_dev.pdf 2GP 시리즈 전수 위키화 종료. 신규 열린 항목 발생 시 이 섹션에 🔲로 추가.

### 🔵 P3 — 중기 (다른 작업 사이에 의식적 실험)

| # | 항목 | 소스/사유 | 상태 | 추가일 |
|---|---|---|---|---|
| PIPE-1 | 강화된 pipeline agent 실제 invocation 1회 시도 | 6개 agent 정의가 모두 강화됐으나 Task #1·#2 모두 manual 작성 → 실제 PM 호출로 파이프라인 작동 데이터 1회 확보. (2026-07-18 STRUCT/PIPE 배치에서 index-manager·wiki-retrospective 실제 위임으로 부분 충족) | 🔲 대기 | 2026-05-23 |
| ~~DEC-2~~ | ~~위키 이미지 첨부 정책 결정~~ | ✅ **완료 (2026-07-18)** — 사용자 결정 "선별 첨부 허용". CLAUDE.md 0-2에 정본 정책(첨부 3조건·`_assets/`·Windows 안전 파일명·`![[]]` 임베드), 에이전트 정의 4곳 포인터. → [[WORK_BACKLOG_ARCHIVE]] | ✅ 완료 | 2026-05-23 |

### 🔵 P3 — 선언적 어드민 도메인 공백 (갭 분석 2026-06-14)

> **출처:** `Salesforce Documents/Complete Salesforce Notes & Interview Questions and Answers/`(제3자 학습노트·면접 Q&A 321 PDF) **vs 위키** 갭 분석 결과.
> **⚠️ Tier 주의:** 그 컬렉션은 **Tier 3**(제3자 노트)이므로 **갭 식별용으로만** 쓴다. 실제 작성은 공식 소스(Tier 2: `help.salesforce.com` 어드민 가이드, 공식 PDF)로 채운다 — 컬렉션 본문을 그대로 옮기지 않는다.
> **배경:** 위키는 개발(Apex 106·LWC 128노트) 영역은 깊으나 **선언적 어드민**은 `Admin(어드민)/` 3개 파일뿐. CLAUDE.md 스코프(Admin/Setup·Sales/Service Cloud)와 실제 콘텐츠의 불균형.
> **🆕 소싱 경로 확장 (2026-07-03, 사용자 승인):** ADMIN-4·6을 **help.salesforce.com 라이브 공식 문서를 Tier 2로 채택**해 완료. WebFetch 정적 추출이 SPA 본문에서 실패하면 **브라우저 렌더링(claude-in-chrome)으로 본문 verbatim 확보**(절차·한도표). source frontmatter에 URL+접속일 명시(라이브 문서는 버전 변동 → 재검증 가능하게). ⇒ **남은 ADMIN 갭(1·2·3·5·7·8·9)은 더 이상 공식 PDF 게이트가 아니다** — 동일 방식으로 진행 가능.

| # | 항목 | 사유/현황 | 상태 | 추가일 |
|---|---|---|---|---|
| ADMIN-1 | **Approval Process** (선언적 승인 워크플로) | ✅ **완료 (2026-07-03)** — `Admin(어드민)/Approval Process (승인 프로세스).md`(help.salesforce.com Tier 2). Classic 개요·용어 15종·2 마법사·자동화 액션 4그룹×4타입·Record Locking·Flow 대안. Apex `Approval Namespace`와 declarative↔programmatic 양방향. qa PASS | ✅ 완료 | 2026-06-14 |
| ADMIN-2 | **Formula / Roll-Up Summary 필드** | ✅ **완료 (2026-07-03)** — `Admin(어드민)/Formula 필드.md` + `Roll-Up Summary 필드.md`(help.salesforce.com Tier 2). 자동계산·cross-object·COUNT/SUM/MIN/MAX·master-detail 전수. qa PASS | ✅ 완료 | 2026-06-14 |
| ADMIN-3 | **Profiles · Page Layouts · Record Types** | ✅ **완료 (2026-07-03)** — Profiles는 권한시리즈 `Security(보안)/Profiles (프로파일).md`, 신규 `Admin(어드민)/Page Layouts (페이지 레이아웃).md` + `Record Types (레코드 타입).md`(help.salesforce.com Tier 2). qa PASS | ✅ 완료 | 2026-06-14 |
| ADMIN-4 | **OWD · Sharing Rules** (선언적 공유 모델 전체) | ✅ **완료 (2026-07-03)** — `Admin(어드민)/조직 전체 공유 기본값(OWD)과 공유 규칙.md`(help.salesforce.com Tier 2 라이브). OWD 접근수준 4종·내부/외부 설정 절차·소유기반 8단계·기준기반 9단계·criteria 필드타입 13종 전수. draes 노트와 "설정↔성능 짝" 양방향. `_index/security.md` 신규 "공유 모델" 섹션. qa PASS | ✅ 완료 | 2026-06-14 |
| ADMIN-5 | **Reports & Dashboards** (선언적) | ✅ **완료 (2026-07-03)** — `Admin(어드민)/Reports (리포트).md` + `Dashboards (대시보드).md`(help.salesforce.com Tier 2). Report Builder·4포맷·컴포넌트 6종·한도 전수. `_index/analytics.md` 등재. qa PASS | ✅ 완료 | 2026-06-14 |
| ADMIN-6 | **Data Loader**(✅) · Import Wizard(✅) | ✅ **완료** — Data Loader(2026-06-14) + **Data Import Wizard(2026-07-03)** `Admin(어드민)/Data Import Wizard.md`(help.salesforce.com Tier 2). 8단계 절차·지원/미지원 객체·Import Limits 표(50,000건·100MB·400KB·90필드·32KB) 전수. Data Loader 비교표로 위임(중복0). `_index/platform.md` 등재. qa PASS | ✅ 완료 | 2026-06-14 |
| ADMIN-7 | **Duplicate · Matching Rules** | ✅ **완료 (2026-07-03)** — `Admin(어드민)/Duplicate & Matching Rules (중복·매칭 규칙).md`(help.salesforce.com Tier 2). match key·matching equation·한도 5/3/1/5·안도는 조건 7·오버라이드 3 전수. qa PASS | ✅ 완료 | 2026-06-14 |
| ADMIN-8 | **Schema Builder** | ✅ **완료 (2026-07-03)** — `Admin(어드민)/Schema Builder (스키마 빌더).md`(help.salesforce.com Tier 2). 시각 데이터모델·커스텀오브젝트·lookup/master-detail·Geolocation 제외. qa PASS | ✅ 완료 | 2026-06-14 |
| ADMIN-9 | **Sales Cloud · Service Cloud** (기능 레벨 가이드) | ✅ **완료 (2026-07-03)** — 신규 `SalesCloud(세일즈클라우드)/`(11) + `Service(서비스)/` 확장(9) + `DataCloud(데이터클라우드)/`(8) + `Clouds(클라우드)/` 개요(7) = 35노트. help.salesforce.com Tier 2. 기존 CPQ·FieldService·Knowledge·OmniChannel·Chat·Datacloud Namespace 링크 흡수. qa PASS. **ADMIN 갭 1~9 전부 완료** | ✅ 완료 | 2026-06-14 |
| QA-GAP-1 | 면접 Q&A → `_index/questions.md` 보강 검토 | 컬렉션의 회사별(TCS·Deloitte 등)·시나리오 면접 Q&A. reference 아님 + Tier 3 → 보존 가치 낮음. 자연어 질문 라우팅 키워드만 선별 흡수 검토 | 🔲 대기 | 2026-06-14 |

### 🟢 INGEST — Salesforce Documents 공식 PDF 인제스트 (2026-06-14 시작)

> **목표:** 로컬 `Salesforce Documents/`의 공식 PDF(Tier 2)를 한 개씩 위키화. 파이프라인: 버전 내용 검증 → 전수 추출 → 구조 매칭 작성 → 네비 → 링크 검증 → 커밋.
> **이미 채굴됨(제외):** apex_reference_guide(57노트)·object_reference(38)·sfdx_dev(28)·pkg2_dev(28)·api_meta(19)·soql_sosl·lightningAura·basics·apex_developer_guide·large_data_volumes_bp·릴리즈노트. **대형(분할 필요):** chatter_rest(2350p)·extend_click_automate(1027p)·api_tooling(1006p)·pages_dev(817p)·lightning(553p).

| # | PDF (페이지) | 도메인 | 상태 |
|---|---|---|---|
| ING-13b | salesforce_chatter_rest_api (2350, **분할 필요**) = **Connect REST API Developer Guide** (v67.0 Summer '26) | Chatter/Connect/Integration | 🟢 **Phase 1+2 완료(2026-07-04)** — `Integration(통합)/ConnectREST(커넥트REST)/` 총 18노트. **Phase 1 협업코어 11**(Foundation 2·Feed Elements·Feeds·Comments/Likes/Mentions·Groups·Users×3·Profiles/Subscriptions/Followers·Topics/Announcements/Q&A). **Phase 2 플랫폼갭 7**(Files & Folders·Files Connect Repository·Notifications·Topics 일반·Managed Topics·Action Links). 샤드 `_index/connect-rest.md`. Apex ConnectApi 짝. 상세 [[project_connect_rest_ingest]]. **Phase 3 불필요** — 남은 도메인(Recommendation Definitions·Personalization·CMS·Commerce·Payments 등)은 별도 제품/이미 커버. 핵심 플랫폼 갭 소진 |
| ING-18 | esm_developer_guide (55) = **Enterprise Sales Management** (Industries CME) | Sales/Industries | ⏸️ 후순위(niche) — 파일명과 달리 Embedded Service 아님. Industries CME 버티컬의 네임드 API(b2bExpress_*·ESM_* 수십 개) 솔루션. 일반 dev 가치 낮아 보류 |
| ~~ING-25~~ | extend_click_automate (1027p, "Automate Your Business Processes" Spring '26) | Automation/Flow | ✅ **완료 (2026-07-18)** — **챕터 단위 커버리지 diff로 스코프 축소**: 1027p 중 ~95% 기커버(Flow 31노트·Orchestration은 이 PDF에서 이미 채굴[2026-07-11]·NBA는 AI-CLASSIC-1·Legacy 저가치 제외). 진짜 갭=**Approval 운영·엔드유저·레퍼런스 심화(물리 846–886)** 1노트: `Admin(어드민)/Approval Process — 운영·엔드유저·레퍼런스.md`(547줄). Limits 표(1000/2000/300/500/30/25/40/4000·CJK1333 PDF원문 대조)·Sample 4종·History Reports(PI 13·PIN 8필드)·Respond 매트릭스(pdftoppm 복원)·엔드유저. 개요 노트와 companion 양방향. 오프셋 −4 실측(AP-05)으로 878–881 꼬리 보정 추출. → [[WORK_BACKLOG_ARCHIVE]] |
| ING-28 | ~~lightning (553, 분할)~~ | Aura/LWC | ❌ **de-scope (2026-07-11, 상태 정정 2026-07-17)** — Aura 3층 파일럿에서 `lightning.pdf` = `lightningAura.pdf` **md5 동일 복제본** 확인(아래 COVERAGE-GAP 각주 참조). 별도 소스 아님 — 표 행 상태가 🔲로 남아 있던 내부 모순을 구조 감사에서 정정 |


#### 🆕 신규 수령 PDF (2026-06-17 origin/main 머지로 입수 — 미착수, 페이지수 검증됨)

> 다른 머신에서 GitHub 웹 업로드된 공식 PDF 8개(Tier 2 추정, 작성 전 내용으로 버전 확인). `Salesforce Documents/`에 디스크 실재 확인됨. 도메인 가치·분량 기준으로 다음 사이클에 ING 번호 승격.

| # | PDF (페이지) | 도메인 | 상태 |
|---|---|---|---|
| ING-44 | **Embedded Service SDK (iOS/Android) · Messaging for In-App and Web 마이그레이션 노트** | Service/Chat (마이그레이션 대상) | ❌ 보류 (입수 게이트) — ING-13a·ING-36 후속. 은퇴한 레거시 Chat(2026-02-14)의 **권장 마이그레이션 대상**이나 해당 공식 가이드 PDF가 `Salesforce Documents/`에 **디스크 미보유** → PDF 입수 전 작성 불가. 입수 시 ING 번호 승격. (2026-06-18 ING-36 인라인 메모를 전용 행으로 승격) |

> ADMIN 갭(ADMIN-1~9)은 별도 — 공식 Admin 가이드 PDF 확보 시 진행. 위 INGEST는 이미 보유한 PDF 대상.
> **(선택/저우선) 레거시 호출 표면 메모** (RECON-6 작업 중 식별, 등재 보류 — 우선순위 낮음): `apex_developer_guide.pdf` "Invoking Apex" 챕터의 잔여 레거시 호출 표면 — Visualforce Classes 컨트롤러 10종(③)·JavaScript Remoting `@RemoteAction`(⑤)·Email Service 설정 측면(⑦~⑨). Visualforce는 레거시(LWC 권장)라 가치 낮음. 전용 ING/RECON 번호 부여는 보류하고, ING-27/37(pages_dev 전체 분할) 진행 시 함께 흡수 검토.

### 🟧 PARTIAL — 부분 인용 공식 PDF 보완 (커버리지 맵 직접 판정, 2026-06-16)

> **배경:** PDF별 위키 source 인용 수 집계에서 1~5건으로 "부분 의심" 분류된 PDF를 **카운트가 아니라 직접 판정**(인용 페이지 내용 + PDF 목차/분량 대조)한 결과. 카운트 1건이어도 INGEST에서 이미 "전수 완료"인 경우(api_rest/api_action/api_asynch/platform_events/api_console/exp_cloud_lwr/mobile_offline/bi_dev_guide/draes/data_loader/Flow백서)는 **거짓 부분 신호**(source 인용이 1페이지뿐이라 카운트만 낮음)라 제외. 작은 PDF가 사실상 완전 커버된 것(soql_sosl·validation_formulas·basics)도 제외. 아래는 **진짜로 많이 남은 것**만.

> 전 항목(LDV-1·APEXLANG-1·UIAPI-1) ✅ 완료 → [[WORK_BACKLOG_ARCHIVE]] PARTIAL 섹션 이관(2026-06-27). 완료 상세는 아래 카드 1~3 + ARCHIVE 참조. 신규 부분 인용분 발생 시 이 섹션에 🔲로 추가.

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

> 등재된 RECON 항목 전부 ✅ 완료/de-scoped → [[WORK_BACKLOG_ARCHIVE]] RECON 섹션 이관(2026-06-27). apex_developer_guide·대형 5종 챕터 재감사 종료, 미커버 잔여 0. 신규 미커버 챕터 발견 시 이 표에 RECON-N 🔲로 추가.

### 🟩 COVERAGE-GAP — 큰 그림 커버리지 갭 (갭 분석 2026-07-03, "뭐가 더 없어?")

> **배경:** ADMIN 1~9·권한 10노트·클라우드 도메인 35노트 완료 후 위키 전체(1,198 콘텐츠 노트) 도메인 지도 재훑기. 로컬 PDF 65종 대비 위키 source 인용 교차확인 + 핵심 개발/통합 주제 전용 노트 존재 여부 판정. 아래는 **신규 발견 갭**(기존 INGEST/ADMIN 대형 항목과 중복 아님). Tier 주의: 로컬 PDF=Tier 2 그대로, 로컬 PDF 없는 도메인=help.salesforce.com Tier 2(라이브 렌더) 방식.

| # | 항목 | 소스/사유 | 크기(추정) | 상태 | 추가일 |
|---|---|---|---|---|---|
| SVC-DEV-1 | ~~Service Cloud 개발자 가이드 소형 클러스터~~ | ✅ **CLOSE — stale (2026-07-12, Service 파일럿 스카우트)**. "부분 인용" 판정이 2026-07-03 전용 노트 생성 이전 기준으로 낡음. **파일명 함정 4건** 확인: `case_feed_dev_guide`=실은 Publisher/Quick Action Dev Guide(→`Aura/Quick Action·Publisher JS API`+`Case Feed VF 커스터마이즈` 전수)·`service_presence_developer`=Omni-Channel Dev Guide(→OmniChannel 객체·External Routing 2노트 전수)·`salesforce_guided_engagement`=Flow for Service(→`Lightning Flow for Service` 전수)·`caf_dev`=Custom Address Fields(Service 아닌 sObject 도메인, →`sObject/Custom Address Fields` Ch1-10 전수). **4종 전부 이미 전수 채굴 완료**. 유일 미채굴 `omnichannel_supervisor.pdf`(32p)는 개발자 API 아닌 슈퍼바이저 어드민 UX·저가치 → 아래 각주. | — | ✅ CLOSE | 2026-07-03 |
| INT-DEEP-1 | ~~통합 패턴 심화 — Salesforce Connect · Outbound Messaging~~ | ✅ **완료 (2026-07-13)** — 신규 **2노트**. `Integration(통합)/Salesforce Connect — 어댑터·Cross-Org·writable·External CDC.md`(213줄, help.salesforce.com 7페이지: 어댑터 카탈로그·Cross-Org 9트리거·writable·External CDC[OData 4.0 전용·5–30분 폴링]·한도 5종·라이선스 connections) + `Integration(통합)/Outbound Messaging (아웃바운드 메시지) — SOAP 콜백·WSDL·리스너.md`(293줄, SOAP API Dev Guide 6페이지: notifications()·100/msg·24h 큐+2h 재시도·WSDL 3블록·`<Ack>true</Ack>` 리스너 계약). **경계 실측 결과 스코프 축소**: Streaming API·External Objects 기초·OData no-code·DataSource NS(Custom 어댑터)·Apex 트리거/gRPC 구독은 이미 커버 → 링크 위임. 신규는 심화 갭만. External CDC↔내부 CDC 혼동 주의 양방향. source-verifier 셀별 오류0·qa PASS. 소싱 하네스: developer.salesforce.com=콘텐츠 API fetch, help.salesforce.com=H1→컨테이너 deepText(브라우저). 상세 [[project_int_deep_ingest]]. | — | ✅ 완료 | 2026-07-03 |
| EXP-DEV-1 | ~~Experience Cloud 개발자 가이드 통합~~ | ✅ **CLOSE — false gap (2026-07-13, EXP 스카우트 실측)**. 백로그 설명(네트워크 멤버·모더레이션·평판·CMS Connect)이 **파일명 함정** — 실제 `communities_dev.pdf`(Experience Cloud Developer Guide v66.0)는 Aura 컴포넌트 구성·브랜딩·게스트 보안·CSP/LWS·CMS·Deflection·ExperienceBundle 가이드다. **이미 2026-06-21에 5 전용 노트로 전수 인제스트됨**: `Aura/Experience Builder Aura 사이트 개발`(Ch2-3)·`Aura/Experience Builder 사이트 — Pardot·CMS·Deflection`(Ch6-8)·`Security/Experience Cloud 사이트 보안 — 인증·게스트 사용자`(Ch4)·`Security/Experience Cloud 사이트 — CSP·Locker·LWS`(Ch5)·`DevOps/ExperienceBundle — Experience Builder 사이트 메타데이터`(Ch9-11). 11챕터 중 10 COVERED·1 PARTIAL(Ch1 저가치 개념글루). 백로그 항목이 노트 생성(6/21) 이후 날짜(7/3)에 등재된 false gap. SVC-DEV-1·SEC-HC-1과 동류. | — | ✅ CLOSE | 2026-07-03 |
| OMNISTUDIO-1 | ~~OmniStudio 위키 지식 계층~~ | ✅ **완료 (2026-07-13)** — 신규 폴더 `OmniStudio(옴니스튜디오)/` **8노트** + 신규 샤드 `_index/omnistudio.md`. 개요·오리엔테이션(허브)·셋업/권한/활성화·OmniScript(element 카탈로그 input21·action13·group6)·FlexCard(display9·data source10·action7·states)·Data Mapper(4타입·DRGlobal·REST)·Integration Procedure(action19·block4·호출4)·메타데이터/DataPack 배포(CLI vs Build Tool)·Formula Functions 레퍼런스(54함수). 소스=help.salesforce.com `xcloud.os_*` 문서세트(Tier 2, 브라우저 렌더). **실측 스코프 조정**: Calculation·EPC는 OmniStudio Standard 문서에 없음(Industries CPQ/Vlocity 관리형 소속) → 셋업·Formula로 대체, EPC/Calc는 아래 OMNISTUDIO-2로 분리. source-verifier 8 전수 검증(카탈로그 카운트·코드 무결성 오류0, 경미 2건 즉시 수정)·qa PASS. 스킬맵 갭 7→1(EPC만). Omni-Channel 이름충돌 disambiguation 3곳. 상세 [[project_omnistudio_ingest]]. | — | ✅ 완료 | 2026-07-03 |
| ~~OMNISTUDIO-2~~ | ~~OmniStudio EPC~~ (Industries CPQ) | ✅ **완료 — EPC (2026-07-18)** — `OmniStudio(옴니스튜디오)/Enterprise Product Catalog (EPC) — 데이터 모델·명명·번들.md`. **소싱 전환**: Vlocity 관리형 문서(브라우저) 대신 **로컬 Tier-1 sf-skill refs**(`omnistudio-epc-catalog-generate/references/` epc-field-guide·naming-conventions·scoring-model) 사용 — 세션 한도 상황에서 로컬 소싱 fallback. Product2 offer 필드·AttributeMetadata·ProductChildItem 번들(min/max/default quantity)·결정적 명명·DataPack 11템플릿·함정표·120점 루브릭 전수. 지식↔실행 스킬 양방향. 스킬맵 OmniStudio 갭 1→0. 메인 세션 직접 작성·nav·검증(구조 ✅·고아0·링크0). → [[WORK_BACKLOG_ARCHIVE]] | ✅ 완료 | 2026-07-13 |
| OMNISTUDIO-2b | **OmniStudio EPC Calculation Procedures/Matrices** (Industries CPQ) | OMNISTUDIO-2에서 분리: Calculation Procedures/Matrices(속성 기반 동적 가격·수식)는 **로컬 소스 없음**(sf-skill refs에도 없음, EPC와 달리) → Industries CPQ 문서세트 브라우저 소싱 필요(세션 한도 리셋 후). 니치·저우선. + EPC 심화(Pricing 런타임·Product Configuration Rules·Order/Quote CPQ 통합)도 여기. | ~1–3노트 | 🔲 대기 | 2026-07-18 |
| ~~AI-CLASSIC-1~~ | ~~Einstein 예측형 AI(비-생성형)~~ | ✅ **완료 (2026-07-18)** — 신규 폴더 `Einstein(아인슈타인)/` **4노트** + 신규 샤드 `_index/einstein.md`(라우터 36샤드). 개요 허브(예측형↔생성형 경계·도구 지도 + Lead/Opp Scoring·Forecasting 흡수)·Prediction Builder(400레코드·2년·27표준객체·16단계)·Next Best Action 저작(Strategy Builder 10요소·Recommendation 객체, 표시측 Service A&R 양방향)·Einstein Discovery(stories→models 리브랜딩·3모델타입·CRM Analytics 양방향). help.salesforce.com Tier 2 브라우저 소싱. source-verifier 셀단위 PASS·completeness ✅·qa PASS. false gap 없음(예측형 전용노트 0 실측). → [[WORK_BACKLOG_ARCHIVE]] | ✅ 완료 | 2026-07-03 |
| ~~AI-CLASSIC-2~~ | ~~Einstein 예측형 AI 심화~~ (품질·편향 지표 코어) | ✅ **완료 — 코어 (2026-07-18)** — **2노트, 로컬 소싱 전환으로 완료**. ①`Apex/Integration(통합)/ConnectApi CdpMachineLearning — Data 360 ML 예측.md`(로컬 Apex Reference Tier 2 — Data 360/CdpMl 예측 소비 Apex, Einstein Discovery `SmartDataDiscovery.predict`와 별개 계열 disambiguation) ②`Einstein(아인슈타인)/Einstein Discovery REST — 모델 품질·편향 지표 표현형.md`(표현형 13종: 회귀 mae·rmse·rsquared / 분류 auc·gini·mcc·TP/FP/TN/FN rate / Training Metrics / Disparate Impact·adverseRatio·Story Potential Bias). **소싱 전환기록**: 브라우저(help/dev SPA)가 get_page_text·a11y·쿠키배너로 차단(rabbit hole)→**사용자 승인 하에 공식 PDF `bi_dev_guide_rest_sdd.pdf`(203p) 다운로드→로컬 pdftotext 신뢰 소싱**(ANALYTICS-1식). 두 노트 파이프라인 PASS(source-verifier 셀단위·completeness 전수·qa). researcher 정직 정정: "Training Metrics"엔 mae·rowCount·value 3개뿐(RMSE 등은 예측타입별 Metrics에 분산), holdout 부재. 원문 anomaly 4건(storyHistory·중복 details·narrative 복붙·url:Integer) 보존. → [[WORK_BACKLOG_ARCHIVE]] | 2노트 | ✅ 완료 | 2026-07-18 |
| AI-CLASSIC-2b | **Einstein Discovery REST 잔여 심화** | 🟡 **진행 (2026-07-19)** — **엔드포인트 2노트 완료** (로컬 `bi_dev_guide_rest_sdd.pdf` Ch1–3, Tier 2): `Einstein/Einstein Discovery REST — 개요·인증·예측 소비 흐름`(Area A 8섹션·Get Predictions·Manage X·요청/응답 JSON 전수) + `Einstein/Einstein Discovery REST — 리소스 엔드포인트 레퍼런스`(리소스 32개 URI·메서드·파라미터·버전·enum·anomaly 4·typo 2 보존). 파이프라인 PASS(source-verifier 오류0·completeness 32/32·qa). **잔여**: ①**Ch4 Request/Response Bodies 60+ Input/Output 표현형 필드 상세**(대형 — 별도 표현형 노트, 지표 표현형 노트는 이미 존재) ②Prediction Builder **Scorecard**(impact/correlation/weight)·**Forecasting 채널 매트릭스**(help.salesforce.com Tier 2 별도). 니치·저우선. | 엔드포인트 2노트 완료·표현형 잔여 | 🟡 진행중 | 2026-07-18 |
| CUSTOM-BTN-1 | **Custom Buttons & Links 트리 보강** (사용자 요청) | 🟡 **대부분 완료 (2026-07-19)** — 신규 2노트: `Admin/UI/표준 버튼·탭 홈 페이지 재정의 (Override Standard Buttons).md`(재정의 타입 7종·전역 동작·5단계·모바일 제약·Viewing References 전수) + `Admin/UI/Custom Button & Link 샘플 예제.md`(샘플 11종: Documents·Files·Reports 3종 절차 전수 + 8종 설명·공식링크 + Add Default). **기존 커버 재확인**: #1 개요=`Custom Buttons & Links`, #2 정의·#6 고려·#7 제한=`New Button or Link 가이드`(389줄)가 이미 커버 → 중복 안 만들고 링크. 파이프라인 PASS(source-verifier 코드 fabrication 0·qa). **소싱 하네스 확립**: help.salesforce.com 본문은 **shadow DOM**(`div.slds-text-longform`) → get_page_text 무효, **shadow 관통 deepText + 900자 슬라이스** 레시피(메모리 반영). **⚠️ 미완(잔여)**: Samples JS 코드 8종(Mass Delete·Display Alerts·Clone·Get/Pass Record IDs·DFV·Reopen·International Maps) + Override leaf 3종(Standard Action Overrides·Considerations·Remove)은 **콘텐츠 출력 필터 오탐**(`sforce.*`·URL을 cookie/query로 오판)으로 본문 미확보 → 공식 문서 링크로 안내. **필터 우회 금지**(서브에이전트 우회 시도가 세션 안전 차단 유발함 — 재시도 시 non-code 부분만 또는 사용자가 직접 열람). | 2노트 완료 | 🟡 대부분완료 | 2026-07-18 |
| CUSTOM-BTN-1b | **잔여 leaf 추출 (A+B, 새 세션)** — 사용자 결정 2026-07-19 | **새 대화(세션 안전차단 해제)에서 필터 우회 없이 추출·보강.** 소싱=help shadow deepText 레시피([[reference_browser_doc_sourcing]]: shadow 관통 walk + `div.slds-text-longform` deepText·900자 슬라이스·URL은 `.htm`+`language=en_US`). **A. Override 산문 3 → `표준 버튼·탭 홈 페이지 재정의` 노트 보강**(현재 설명+링크만): `platform.standard_actions_overrides.htm`·`platform.links_override_considerations.htm`·`platform.links_customize_override_remove.htm`(sforce.* 코드 없어 필터 위험 낮음). **B. URL/VF 샘플 3 → `Custom Button & Link 샘플 예제` 노트 보강**: `platform.links_useful_custom_buttons_passing_record_ids.htm`(VF)·`platform.links_useful_custom_buttons_create_record_dfv.htm`(URL/LEX)·`platform.links_useful_custom_buttons_international_maps.htm`(링크). **C(제외·링크 유지)**: 순수 OnClick JS 5종(mass_delete·displaying_alerts·clone_records·record_ids·reopening_cases)=Classic 레거시·필터 오탐 高·저가치. ⚠️ 코드가 `[BLOCKED]` 뜨면 non-code만 추출, **우회 금지**. | 기존 2노트 보강 | 🔲 대기 | 2026-07-19 |
| AGENT-CONCEPT-1 | ~~Agentforce 제품 개념 오리엔테이션~~ | ✅ **완료 (2026-07-14)** — 신규 `Agentforce(에이전트포스)/Agentforce 개요 — 제품·에이전트 유형·구성요소.md`(194줄). Building Blocks 6(Agent·Subagents&Actions·Data/RAG·Connections&Channels·Reasoning Engine·LLM)·Atlas Reasoning Engine(graph-based·Agent Script·hybrid·최대 7 loop)·agent types 8(활성6+은퇴2: Default 2025-06-17·Agent for Setup 2026-04)·Studio/Builder·Prompt Builder 대비·결정 가이드. **보강 아닌 신규**: 실측 결과 백로그가 가정한 "Agentforce 개요 노트"는 없었고 기존 개요는 "Agent Script 언어" 노트라, 제품 개념을 얹으면 고도 혼재 → 신규 제품 오리엔테이션 노트 + 언어 노트와 양방향 링크(altitude 분리). 소스 help.salesforce.com `ai.*` 9페이지(Tier 2, 브라우저). **synthesis 규율**: Flow 비교·Copilot 리브랜드는 dump 밖이라 "추정·비단정" 명시 라벨. source-verifier 오류0·qa PASS. 상세 [[project_agent_concept_ingest]]. | — | ✅ 완료 | 2026-07-12 |
| SEC-MON-1 | ~~Event Monitoring & 보안 감사(관찰 축)~~ | ✅ **CLOSE — 해소 (2026-07-12, 상태 정정 2026-07-17)**. ADMIN-EXH **W2**(감사·모니터링·프라이버시, 커밋 `7cc30c6`·`04e72dd`)가 Event Monitoring·RTEM·Login History/Email Log 등 신규 6+보강 1로 해소 — W2 행과 세션 인계 메모에는 "SEC-MON-1 해소"로 기록됐으나 이 표 행이 🔲로 남아 있던 내부 모순을 구조 감사에서 정정 | — | ✅ CLOSE | 2026-07-11 |
| SEC-HC-1 | ~~Security Health Check~~ | ❌ **취소 — 오탐 (2026-07-11)**. Admin 전수 커버리지 이니셔티브 갭매핑에서 확인: `Admin(어드민)/Security Health Check (보안 상태 점검).md`가 **이미 존재**. Security 파일럿 진단 B가 Admin 폴더를 못 봐서 생긴 false gap. | — | ❌ 취소 | 2026-07-11 |
| ~~ANALYTICS-1~~ | ~~CRM Analytics(Tableau CRM) asset REST API~~ | ✅ **완료 (2026-07-18)** — `Analytics(애널리틱스)/` **3노트**(개요·인증·asset 엔드포인트 지도 / Datasets·Versions·XMD 표현형 / Query 실행 SAQL·SQL). 소스 developer.salesforce.com **CRM Analytics REST API Developer Guide v67.0**(`bi_dev_guide_rest`, `/wave/*`) — **이름 함정 실측 배제**(로컬 `salesforce_analytics_rest_api.pdf`=Reports&Dashboards `api_analytics` 별개 확정). 표현형 26 전수·enum 전수(language 33·AssetType 27·LimitType 17). Apex `Wave Namespace`(REST↔빌더 대비 양방향)·Recipe REST·Reports&Dashboards REST와 형제 링크. source-verifier 셀단위 PASS·completeness ✅·qa PASS. → [[WORK_BACKLOG_ARCHIVE]] | ✅ 완료 | 2026-07-12 |
| ANALYTICS-2 | **CRM Analytics REST 미커버 리소스 계열** — Data Connector·Dataflow Job·Collection·Subscription·Watchlist·Eclair Chart·Replicated Dataset·Lens/Dashboard/Folder/Template CRUD 상세 등 (`bi_dev_guide_rest` ToC 114노드 중 datasets/xmd/query·6 asset 요약 외) | ANALYTICS-1 완료 시 validator·qa가 "소스에 속성 표현형 없어 추가 브라우저 소싱 필요"로 분리 권고. 대형 계열(Data Connector 10·Dataflow Job 8·Collection 6)이라 별도 이니셔티브감. 니치. developer.salesforce.com Tier 2. | ~3–5노트 | 🔲 대기 | 2026-07-18 |

> **재확인(신규 아님, 이미 등재됨):** ING-13b(Connect/Chatter REST 2350p 초대형)·ING-25(extend_click_automate 1027p 선언적 자동화 레퍼런스)·pages_dev(817p Visualforce 부분)는 위 INGEST 표에 이미 있음. **ING-28(lightning 553p)은 de-scope** — Aura 3층 파일럿(2026-07-11)에서 `lightning.pdf` = `lightningAura.pdf` **바이트 동일 복제본**(md5 일치) 확인, 별도 소스 아님. Marketing Cloud는 `Clouds/Marketing Cloud 개요.md`만 존재(심화는 로컬 PDF 없음·대형 별도 이니셔티브라 미등재 보류). Slack은 `Apex/Integration/Slack Namespace.md`로 Apex측 커버(앱 SDK는 스코프 밖).

### 🟨 ADMIN-EXH — Admin/Setup 전수 커버리지 이니셔티브 (갭 매핑 2026-07-11, 사용자 요청 "전부 다")

> **배경:** 사용자가 "org 설정을 전수 조사해 전부 위키화" 요청. 전체 Salesforce Setup 트리를 7슬라이스(사용자·접근 / 보안·아이덴티티 / 오브젝트·필드 / 데이터관리 / UI·앱 / 자동화·이메일 / 회사·모니터링)로 나눠 "있어야 할 것 전수 → 위키 커버 대조" 병렬 갭매핑 수행. **결과: 기존 커버 넓음(Admin 48 + Security 권한 13 + 타폴더)이나, 위키의 구조적 편향 확인 — "객체·로직 만드는 법"은 깊고 "org 설정(전역 토글·인프라·현지화·인바운드 아이덴티티·감사)"은 얇음.** 갭을 6테마 웨이브로 정리. 소스: 로컬 PDF 거의 없음 → help.salesforce.com Tier 2(SPA는 브라우저 렌더).
> **규율:** 신규 남발 금지 — 이미 있는 것 건드리지 않음. 각 노트 완결성 검증(source-verifier) 필수. index-manager로 admin 샤드 findability 개선(Queues·Territory·Scoping이 admin 샤드 미노출).

| 웨이브 | 테마 | 결과 | 커밋 |
|---|---|---|---|
| ~~W1~~ | 아이덴티티·접근 | ✅ **완료** 신규 9 + 보강 2 (My Domain·SAML SSO·SF as IdP·Login Flows/OAuth Scopes·Certificate·Restriction Rules·User Access Policies·User Mgmt Settings·Licenses / PG vs Queue). 정확성 재검증 PASS | `3da6021`·`a45e61c` |
| ~~W2~~ | 감사·모니터링·프라이버시 | ✅ **완료** 신규 6 + 보강 1 (Event Monitoring·RTEM·Login History/Email Log·작업 모니터링·Connected Apps OAuth Usage·Data Protection & Privacy / TxnSecurity). **SEC-MON-1 해소** | `7cc30c6`·`04e72dd` |
| ~~W3~~ | 어드민 빌드타임 | ✅ **완료** 신규 5 + 보강 1 (Field Sets·Lookup Filters·Object & Field Limits·필드타입 선택·CMDT vs Custom Setting / FLS Field Accessibility) | `a293ef6`·`7df96e2` |
| ~~W4~~ | UI·현지화·검색 | ✅ **완료** 신규 7 + 보강 2 (User Interface Settings·Translation Workbench·Search Settings·Path·Themes/Rename·Utility Bar·Notification Types / Lightning Apps·Service Console deferral 닫음) | `1bddd83`·`4b8c3a7` |
| ~~W5~~ | 이메일 인프라 | ✅ **완료** 신규 3 (이메일 전달성 인프라·Letterheads/Mail Merge/Email to SF·Process Automation Settings) | `576201d`·`52760a6` |
| ~~W6~~ | 회사·조직·운영 | ✅ **완료** 신규 3 + 보강 4 (Release Updates 처리·System Overview & Optimizer·Installed Packages / Duplicate Jobs·Mass 도구·Storage 계산·커스텀 회계연도) | `816dd30`·`a7c6c33` |

> ✅ **ADMIN-EXH 전체 완료 (2026-07-12).** 총 **신규 33 + 보강 10**. 위키 4대 구조적 공백(인바운드 아이덴티티·감사 관찰축·어드민 빌드타임·전역 UI 설정) + 이메일 인프라 + 운영 도구 완결. 소싱: help.salesforce.com Tier 2 — SPA는 3경로 우회(Chrome shadow-DOM verbatim 추출·Metadata API 정적문서·전용 PDF). **규율 성과**: 오케스트레이터 프롬프트의 부정확 힌트를 에이전트들이 공식 근거로 다수 정정(테마 6→3종·"32개 IP"·필드 라벨 등), 미확인 값은 창작 대신 캐비엇. 부수: SEC-MON-1 해소·SEC-HC-1 오탐 취소·ING-28 de-scope. **잔여 저우선 갭**(별도 등재 불요, 필요 시): Files Connect 셋업·Activity Settings·Maps and Location·Streaming Channels·Data.com·1GP Package Manager·Lightning Bolt — 니치·저가치.

### 🛠️ STRUCT — 구조·거버넌스 발전 계획 (구조 감사 STRUCT-AUDIT-1, 2026-07-17)

> **배경:** 전체 설계·구조 감사(4축 병렬: 탐색 아키텍처 / 팀 시스템 / 폴더 구조 / 문서 정합성) 결과. **핵심 설계는 건전** — 라우터↔샤드 33개 양방향 완전 정합, 표본 고아율 0%, Windows 파일명 위반 0, 폴더 경계 대부분 명확. 발견된 실질 결함 + 임박 이슈는 **감사 당일 전부 즉시 수정 완료**(하단 AP-11 참조): SEAM_MAP↔writer 죽은 계약 폐기, pm=메인 세션 명문화(3문서), WIKI_RULES.md 정본 동기화, lint 훅 `문서/`·`_active/` 제외+Tier3 경고 검사, 빠른 파이프라인 B에 qa 게이트, writer.md 날짜 하드코딩 제거, 샤드 상한 "300줄 OR 40k chars" 일원화, `_index/frontend.md` 분할, 00 Home OmniStudio/Agentforce 반영, 루트 CLAUDE.md 수치 정정, Layer 3 표 누락 13건 보충, index-manager에 Home 갱신 의무 추가, retro 규칙 가지치기 출구, 파일 이동 RACI 행. 아래는 **남은 중기 발전 항목**(감사가 권고했으나 즉시 수행 범위 밖).
> **공통 근본 원인(감사의 일관 패턴):** 정합성이 "단일 쓰기 주체" 구조로 보장되는 영역(샤드·index)은 드리프트 0, 주체가 없던 영역(Home 큐레이션·문서 수치·파일 이동)에서만 드리프트 발생 → 각 항목은 "주체 지정"을 포함해야 완결.

| # | 항목 | 내용/사유 | 예상 효과 | 상태 | 추가일 |
|---|---|---|---|---|---|
| STRUCT-7 | **apex-core.md 샤드 분할 예약** | 229줄/39.3k chars — chars 기준 상한 언저리(frontend 다음 순위). 다음 Apex 이니셔티브 때 `apex-core-async.md` 등 절단선으로 분할 | 샤드 상한 예방 | 🔲 대기 | 2026-07-17 |
> ✅ **STRUCT-1·4·5·6·8·9 완료 (2026-07-18)** → [[WORK_BACKLOG_ARCHIVE]] "STRUCT·PIPE·DEC" 섹션.
> ✅ **STRUCT-2·3 완료 (2026-07-18, 사용자 요청 "구조 정돈")** → [[WORK_BACKLOG_ARCHIVE]]. **STRUCT-2**: `Admin(어드민)/` 70노트를 허브 8도메인 정합 서브폴더로(OrgSetup 9·Users 8·LoginSecurity 9·Data 5·ObjectsFields 12·UI 16·Automation 6·EmailAnalytics 5). **STRUCT-3**: `DevOps(데브옵스)/` 63노트를 3서브폴더로(Packaging2GP 32[2GP+Unlocked]·DX 21·Deploy 10). 총 133 `git mv`. 실측: 경로 기반 링크는 소수(Admin 5·DevOps 15)뿐이고 대다수 bare `[[파일명]]`이라 **깨진 링크 0건**(파일명 기반 링크 무손상 실증). Python 리터럴 치환으로 샤드 경로 행 + 경로 링크만 갱신(역사 로그 3종 제외), index-manager가 신규 11 서브폴더 index.md + 부모 index.md 2개 재구성 + NAV_MAP 11행. 구조검사·고아·깨진링크 전부 0. 남은 STRUCT-7만 설계상 지연(다음 Apex 이니셔티브와 묶음).

### ⚪ P4 — 장기 (큰 인프라 결정)

| # | 항목 | 소스/사유 | 상태 | 추가일 |
|---|---|---|---|---|
| PIPE-6 | Phase 2 — LLM-level source-verifier 자동 invocation 도입 | L1 훅은 구조만 검사 → 의미 오류(Snapshot 할당량 같은 numeric error)는 사용자 평가로만 발견. settings.json에 SubagentStop 훅으로 source-verifier 자동 호출 검토. ROI 시뮬레이션 필요. | 🔲 대기 | 2026-05-23 |

> **다음 후보(미등록):** N3 시리즈 — Experience Cloud · Reports API · Tooling API 등. 소스 PDF 확보 시 행으로 승격.

### 🟤 P5 — 장기 검증 (소스 출처 확인)

> 현재 열린 항목 없음. **VERIFY-1**(Winter '24 `sf project deploy pipeline` 출처 검증) ✅ 완료(2026-06-21) → [[WORK_BACKLOG_ARCHIVE]] RECON 섹션. 결과: **fabrication 아님 — `salesforce_winter24_release_notes.pdf` p.227에서 출처 확인(Tier 2)**. "게이트(PDF 미보유)" 가정은 false였고, 초기 "52개 grep 0건"은 `ReleaseNote/` 서브폴더 누락에 따른 false negative였음.

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
| AP-06 | **최상위 TOC 불완전 가능성 — 리소스 하위 중첩 항목 교차검증 절차** 추가 — ING-13a에서 최상위 TOC가 Ch6 "Messages Response Objects"의 **14개 하위 응답 객체**를 누락(리소스 1개 아래 중첩됨). 최상위 TOC만 신뢰하면 source-coverage 누락이 **추출 성공·구조상 멀쩡으로 위장**(AP-05와 동류의 silent gap). scout는 매 reference-PDF에서 TOC뿐 아니라 **PDF 뒤쪽 색인(index)·각 리소스 본문의 "Response Objects/Sub-resources" 헤딩**도 1회 훑어 중첩 항목 목록을 완성→researcher/coverage-checker에 전달, completeness-validator는 "리소스 N개" 카운트가 아니라 **중첩 하위 항목 전수**로 판정. Why 첨부(reference 가이드는 리소스 아래 응답객체·서브리소스를 TOC에 펼치지 않는 구조가 흔함). ING-13a에서 scout가 캐치·validator 14개 확인했으나, 예방 가치 높아 additive 규칙화 | `scout.md`, `completeness-validator.md` | ✅ **완료 (2026-07-18)** — scout.md는 STRUCT-9 다이어트 중 §3 신규 반영, completeness-validator.md §7에 "중첩 하위 항목 카운트 판정" 블록 신규 추가. (2026-06-18 작성 후 미적용이던 것을 이번 세션에 발견·양쪽 반영) | 2026-06-18 |
| AP-08 | **소스 문서 완전성 — 전수 grep + 챕터 단위 커버리지 추적** 도입 (모드 B, RECONCILE 신설 동반) — 두 실패 반영: (A) **부재 단정 전 전체 PDF 집합 전수 grep + 인접 도메인 문서 확인** 규칙(DevOps Center를 PDF 2개만 grep하고 "없다"고 단정→49개 전수에서 apex_developer_guide·api_meta 실재). 부정 단정에 전수 검색 증거 첨부 의무화 → `scout.md`·`source-coverage-checker.md`. (B) **멀티토픽 대형 PDF의 챕터/섹션 단위 커버리지 추적**(apex_developer_guide "Deploying Apex" 챕터가 위키화된 PDF인데 통째로 미추출) — scout/researcher는 추출 전 ToC로 커버/미커버 챕터 명시, source-coverage-checker는 동일 PDF 내 미추출 챕터를 누락 소스로 보고, completeness-validator는 노트 단위 충실도뿐 아니라 **문서 레벨 커버리지**(미추출 챕터)도 점검 → `scout.md`·`researcher.md`·`source-coverage-checker.md`·`completeness-validator.md`. Why 첨부, additive(기존 규칙 약화 없음). 증명 사례 RECON-1로 백로그 등재 | `scout.md`, `researcher.md`, `source-coverage-checker.md`, `completeness-validator.md` | ✅ 완료 | 2026-06-19 |
| AP-07 | **`questions.md` 교차 도메인 보조 샤드 예외 명문화** (LINT-4) — `_index/questions.md`는 "교차 도메인 질문 라우팅 보조 샤드"로, 설계 의도상 다른 도메인 샤드에 이미 등재된 파일을 자연어 질문 형태로 재등재한다. "1 페이지 = 1 홈 샤드"(중복 행 금지) 규칙을 그대로 적용하면 wiki-linter가 이를 중복/고아 위반으로 **오탐**하므로, (a) CLAUDE.md "탐색 인덱스 구조" 표 "1 페이지 = 1 홈 샤드" 행 비고에 공식 예외 문구 추가, (b) wiki-linter.md 고아 탐지(check #2)·샤드 건강/중복(check #3b) 판정에 questions.md 제외 안내 추가. Why 첨부(보조 샤드는 라우팅 목적상 의도된 재등재이므로 중복 금지 규칙의 적용 대상이 아님). additive — 기존 규칙 약화 없음 | `CLAUDE.md`, `wiki-linter.md` | ✅ 완료 | 2026-06-18 |
| AP-10 | **멀티사이클 단일-PDF 인제스트 — 기작성 객체 중복 제외** (ING-26 발견) — 한 대형 PDF를 여러 사이클로 도메인 그룹 분할 인제스트할 때(Tooling API Ch4 C4-1~C4-9 알파벳 카탈로그 슬라이스) 한 객체가 여러 도메인에 정당히 속해 나중 그룹 로스터에 다시 잡히는데, 그 객체가 이미 앞 사이클 노트에 작성됐으면 writer가 재작성→두 노트에 중복 객체 섹션. 증명: C4-7 로스터에 Certificate(C4-5)·IconDefinition(C4-4)·ProcessFlowMigration(C4-3) **3종 중복** · C4-8 로스터에 PlatformEventMigration(C4-7a) 중복 — 둘 다 writer 투입 전 수동 grep으로만 잡힘(메인 세션 즉석 조치, 프로토콜 아님→메모리 안 읽는 새 scout가 chatter_rest·extend_click_automate·lightning·pages_dev 돌리면 재발). → (a) `scout.md`에 "멀티사이클 단일-PDF 인제스트 — 기작성 객체 중복 제외" 규칙 추가: 로스터 확정 전 각 후보를 형제 노트에 `grep -l "^### <Obj>"` 교차확인, REWRITE/(기작성→링크만)/(DELEGATE) 표식 명시, 제외 목록 소스맵 보고, 계획 추정치는 신호일 뿐 PDF 로스터 실측·불일치 보고(추정 강제 금지). (b) `completeness-validator.md` §8에 형제 노트 객체 중복 backstop 1줄(방어심층) 추가. Why 첨부, additive(기존 규칙 약화 없음) | `scout.md`, `completeness-validator.md` | ✅ 완료 | 2026-06-28 |
| AP-11 | **구조 감사 STRUCT-AUDIT-1 즉시 조치 일괄** (2026-07-17) — 4축 병렬 감사(탐색 아키텍처/팀 시스템/폴더 구조/문서 정합성)에서 발견된 결함 전부 당일 수정: ①`SEAM_MAP.md` §1.3·§2·§3 "writer 잠정 샤드/index 행" 죽은 계약 폐기(writer.md 절대 금지와 모순) → "키워드 후보 보고"로 대체 + "파일 이동·rename" 무주공산 RACI 행 신설 ②**pm=메인 세션 직접 수행 명문화**(pm.md·TEAM_PROTOCOL.md·양쪽 CLAUDE.md — 서브에이전트 pm은 스폰 불가 제약으로 파이프라인 정지, 실사고 재발 방지) ③`WIKI_RULES.md` 전면 재작성 — 샤드 이전 시대 유물("SEARCH_INDEX에 키워드 행 추가" = 라우터 불변 원칙과 정면 모순)을 정본 포인터+요약으로 동기화, 순영어 폴더 예외 명문화 ④`lint-md-file.sh`에 `문서/`·`_active/` 스코프 제외(오탐 차단) + Tier3 경고 블록 검사 추가 ⑤TEAM_PROTOCOL 파이프라인 B에 qa 게이트 추가(retro "qa 통과 후 실행" 전제·RACI 승인과 정합, v1.3) ⑥writer.md 체크리스트 하드코딩 날짜(2026-05-18) 제거 ⑦샤드 상한 "~300줄 OR ~40k chars 중 선도달" 일원화(CLAUDE.md 2곳+index-manager.md — 한국어 행은 토큰이 먼저 터짐, frontend.md 273줄/47k가 실증) ⑧index-manager.md에 "새 폴더 → 00 Home 갱신" 의무 추가(OmniStudio Home 누락의 근본 원인) ⑨wiki-retrospective.md append-only에 "PM 승인 시 폐기·통합 허용" 출구 신설 ⑩wiki-linter.md에 `문서/`·`_active/` 제외 명문화 ⑪루트 CLAUDE.md 수치 정정(~1,000→1,200+ 하한 표기·PDF 50여 종·AgentScriptDocs 예외·문서/ 표기) ⑫vault CLAUDE.md Layer 3 표 누락 13건 보충 + 새 폴더 필수 작업 4·5번(Home·CLAUDE.md 표) 추가. 나머지 중기 권고는 STRUCT-1~8로 등재 | `SEAM_MAP.md`, `pm.md`, `TEAM_PROTOCOL.md`, `CLAUDE.md`(루트·vault), `_MOC/WIKI_RULES.md`, `scripts/lint-md-file.sh`, `writer.md`, `index-manager.md`, `wiki-retrospective.md`, `wiki-linter.md` | ✅ 완료 | 2026-07-17 |
| AP-12 | **STRUCT-5·PIPE-3/4/5·DEC-2 파이프라인 프로토콜 배치** (2026-07-18) — B→C 발전 항목 처리 중 에이전트 정의 5+1건 반영: ①**STRUCT-5 보수적 슬림화** — wikilink **기계적 존재검사**를 source-verifier §7·qa 체크리스트에서 L1 훅 위임(제거)하되 **의미 검사(올바른 노트 지시)·최종 verdict·인덱스 등재 확인은 보존**. classifier 통합(15→14)·writer 사전검증은 아키텍처 변경/예방가치 이유로 **보류·보존** ②**PIPE-3** researcher.md 대형 PDF dump 정책(청크 분할/파일참조+핵심발췌 하이브리드·전수성 불변·경로 명시 의무) ③**PIPE-4** scout↔researcher 시각자료 handoff를 동일 4필드(페이지/유형/pdftotext실패/이미지화필요) 미니 계약 표로 양쪽 정렬 ④**PIPE-5** classifier.md D-3에 "미작성 단계 분량 예측 부정확→completeness-validator 사후 깊이 판정 병행" 한계 명시 ⑤**DEC-2 포인터** scout·researcher·writer·source-verifier 시각자료 규칙에 "CLAUDE.md DEC-2 이미지 선별 첨부 정책 참조" 1줄(기준 복제 금지, 정본은 CLAUDE.md). 전부 additive 또는 안전한 중복 제거(기존 규칙 약화 없음) | `source-verifier.md`, `qa.md`, `researcher.md`, `scout.md`, `classifier.md`, `writer.md` | ✅ 완료 | 2026-07-18 |
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
| 2026-06-22 | LINT-ELASTIC·LINT-BOM 정비. (1) Governor Limits.md Platform Apex 표에 `DailyAsyncApexElasticExecutions`(beta) 1행 보강 — app_limits 치트시트 `pdftotext -layout` 셀 재추출(컬럼 collapse 우회), source frontmatter에 출처 추가. (2) UTF-8 BOM 제거 — 점검 결과 2건(SOQL 문법 레퍼런스.md + `_index/sobject-reference.md`, 예상 1건보다 많음). | LINT-ELASTIC·LINT-BOM 둘 다 ✅(2026-06-22). wiki-linter에 BOM 검사 추가는 retrospective 권고로 잔존. | 없음 |
| 2026-06-27 | **백로그 전체 정합화**(mode B, 2단계). "열린 항목"에 🔲/🟡(+❌/⏸️ 블록드)만 남기고 ✅·⛔ 상태 행을 전부 ARCHIVE로 이관. **(1단계)** stale 15행(P0 7: LINT-ELASTIC·LINT-BOM·LINT-1~4 ✅잔존 + 2GP-3 stale→✅ / P2 8: 2GP-4·4b~4h stale→✅, 파일 실재 검증) + 신규 세션 완료분 3건(ING-DC DevOpsCenter 6노트·LINT-SHARD-DEVOPS 샤드분할·LINT-SLDS-CATALOG 코드블록). **(2단계 확장)** ✅/⛔ 64행 추가 이관 — DEC-1·2GP-5~12·기존P2-02·기존P3-05·DEV-GAP-1/2·INGEST ✅ 다수·PARTIAL(APEXLANG-1·UIAPI-1)·RECON 12행·de-scoped 4행(ING-20/30/35/38). 활성 inline-only 35행은 verbatim 보존, 기보존 25행은 제거만, ⛔ 4행은 ARCHIVE de-scoped 섹션. P2/PARTIAL/RECONCILE 빈 표는 archive 포인터 노트로 치환. **결과: 활성 "열린 항목" ✅/⛔ 0건, 최종 26행(🔲 22·🟡 2[ADMIN-4·6]·❌ 1[ING-44]·⏸️ 1[ING-18]).** 활성 총 제거 79행, 신규 archive 항목 그룹 8(1단계)+39행(2단계). | 0(이관/정합 작업, 신규 깨진 링크 없음) | 없음 |
| 2026-07-12 | **위키 전체 lint**(3층 파일럿 프로그램 완료 직후). 콘텐츠 무결성 5항목 전부 **0건**: 깨진 wikilink 0(12,300 링크)·고아 0(콘텐츠 1,271 전수 샤드 등재)·오래된 경로 0(1,294 경로 실존)·MOC 누락 0·frontmatter 4필드 0. 샤드 건강 ✅(최대 273줄<300·라우터↔샤드 32/32 정합). 단방향: genuine peer 후보 30(콘텐츠 섬 0), 그중 큐레이션 4건 검토→**1건 보강**(이메일 전달성↔Login/Email Log), 3건 hub-spoke 정상 스킵. 오탐 제외: Release MOC 파이프이스케이프·템플릿 예시 링크. | peer 역링크 1건 + `문서/` 트리 lint 스코프 공식 제외(CLAUDE.md 명문화, 비-Salesforce 사내 문서) | 없음 |

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
