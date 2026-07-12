# Salesforce 개발자 위키

Salesforce 공식 오픈소스 프로젝트 + 공식 PDF 문서를 직접 분석해 추출한 검증된 패턴 모음.  
[Obsidian](https://obsidian.md)에서 열면 `[[wikilink]]` 연결과 그래프 뷰를 활용할 수 있습니다.

---

## 현황 (2026-07-12 기준)

| 섹션 | 노트 수 | 상태 |
|---|---|---|
| AgentSkills(에이전트스킬) | 353 | ✅ sf-skills 85 + refs 252 + sf-mcp 10 + 샘플·Starter Kit 6 |
| LWC (SLDS·Internals 포함) | 197 | ✅ BaseComponents 66 + SLDS 디자인시스템 + Reference·CreateComponents 갭 + 패턴 |
| Apex | 142 | ✅ 네임스페이스 레퍼런스 + 패턴 |
| DevOps(데브옵스) | 105 | ✅ DX·2GP 시리즈·Metadata API·DevOps Center·Tooling API(v67.0 전수 17) |
| Admin(어드민) | 70 | ✅ 어드민 종합 인제스트 + ADMIN-EXH 전수 커버리지(인바운드 아이덴티티·감사 관찰축·이메일 인프라·전역 UI 등) |
| Release | 61 | ✅ 9개 릴리즈 (Winter '24 ~ Summer '26) |
| Service(서비스) | 42 | ✅ Omni-Channel·MIAW·Service Cloud Voice(은퇴 채널 후속)·Cases 라이프사이클 등 |
| Integration(통합) | 40 | ✅ REST·Bulk·Actions·Named Credential + Connect REST API 18노트(협업코어+플랫폼갭) |
| sObject | 38 | ✅ 표준 오브젝트·관계·필드 |
| Security(보안) | 37 | ✅ Secure Coding·권한 모델 10노트·My Domain/SAML/IdP/Certificate 등 |
| Flow | 30 | ✅ 운영·수명주기·Record-Triggered/Orchestration 전용 노트 |
| Architecture(아키텍처) | 24 | ✅ 플랫폼·공유·레코드 액세스 |
| FieldService(현장서비스) | 22 | ✅ Field Service Developer Guide 전수 |
| Analytics(애널리틱스) | 22 | ✅ Reports/Dashboards·Data Prep Recipe REST API + Analytics 개요(표준 리포팅 vs CRM Analytics API 선택 가이드) |
| Visualforce(비주얼포스) | 19 | ✅ 개념 + 표준 컴포넌트 레퍼런스 전수 |
| Scheduler(스케줄러) | 12 | ✅ Salesforce Scheduler Developer Guide 전수 |
| SalesCloud(세일즈클라우드) | 12 | ✅ Sales Cloud 표준 기능(기회·제품·견적·리드·활동·예측·영역·계약주문) + 견적 제품 선택 결정 가이드 |
| Agentforce(에이전트포스) | 12 | ✅ Agent Script 전수 + 인접(Custom Lightning Type·Prompt Template 그라운딩) |
| Aura(오라) | 10 | ✅ 완료 |
| DataCloud(데이터클라우드) | 8 | ✅ Data Cloud(Data 360) 파이프라인(스트림·DLO/DMO·Identity Resolution·세그먼트·액티베이션) |
| Clouds(클라우드) | 7 | ✅ 제품 클라우드 지도(Experience·Commerce·Marketing·CRM Analytics·Revenue·Net Zero 개요) |
| CPQ(견적) | 6 | ✅ CPQ Developer Guide 전수 |
| Commerce(커머스) | 4 | ✅ Order Management |
| **합계** | **~1,270** | |

> 노트 수치는 index.md·MOC 같은 탐색 파일을 제외한 콘텐츠 노트 기준(2026-07-12 집계). 트리의 폴더별 수치는 참고용.

> Apex 레퍼런스 네임스페이스 커버리지 **~93%** (~70개 중 63개, 핵심 전부 커버). 누락·우선순위는 `_MOC/WORK_BACKLOG.md` 참조.

---

## 에이전트 팀 시스템

`.claude/agents/` 에 15개 전문 서브에이전트 정의 (Claude Code 공식 custom agents 스펙 준수).

| 역할 | 에이전트 | 도구 |
|---|---|---|
| PM / 오케스트레이터 | `pm` | Read, Bash, Agent |
| 질문 명확화 | `question-clarifier` | Read |
| 계획 수립 | `planner` | Read, Bash |
| 소스 탐색 | `scout` | Bash, Read |
| 소스 커버리지 확인 | `source-coverage-checker` | Bash, Read |
| 자료 조사 | `researcher` | Bash, Read |
| 분류 | `classifier` | Read, Bash |
| **파일 작성** | `writer` | Read, Write, Edit |
| 완결성 검증 | `completeness-validator` | Read, Bash |
| 소스 검증 | `source-verifier` | Read, Bash |
| **인덱스 관리** | `index-manager` | Read, Edit, Write |
| 위키링크 연결 | `cross-linker` | Read, Bash, Edit |
| 린트 | `wiki-linter` | Read, Bash |
| 품질 검증 | `qa` | Read, Bash |
| 회고·개선 (회고 A / 커버리지·에이전트개선 B) | `wiki-retrospective` | Read, Bash, Edit |

파이프라인 설명: `TEAM_PROTOCOL.md` 참조.

---

## 완료된 작업

### 공식 프로젝트 분석 (Tier 1)

| 프로젝트 | 결과 |
|---|---|
| [apex-recipes](https://github.com/trailheadapps/apex-recipes) — 74개 클래스 | `Apex/` 주요 패턴 노트 |
| [lwc-recipes](https://github.com/trailheadapps/lwc-recipes) — 133개 컴포넌트 | `LWC/` 전 섹션 |
| [automation-components](https://github.com/trailheadapps/automation-components) — Flow Action 30개 | `Flow/` 전 섹션 |
| [dreamhouse-lwc](https://github.com/trailheadapps/dreamhouse-lwc) | 모바일, PagedResult, 파일 업로드 |

### 공식 PDF 분석 (Tier 2)

| PDF | 완료된 wiki |
|---|---|
| `salesforce_apex_reference_guide.pdf` v67.0 | Apex 네임스페이스 레퍼런스 63개 (System·Database·Schema·Auth·ConnectApi 등 핵심 + 커머스·산업 네임스페이스 다수) |
| `sfdx_dev.pdf` v67.0 | `DevOps(데브옵스)/` 74개 노트 (DX 개요, Scratch Org, Unlocked Package, CI/CD, 2GP 시리즈, Metadata API 등) |
| `lightningAura.pdf` | `LWC/BaseComponents(베이스컴포넌트)/` 66개 노트 |
| `api_tooling.pdf` v67.0 (1006p) | `DevOps(데브옵스)/ToolingAPI(툴링API)/` 17개 노트 (Tooling API 전수 — 개요·REST/SOAP·객체 카탈로그·C4-9 버티컬) |
| `AgentScriptDocs/` (Agent Script Developer Guide, Markdown 34파일) | `Agentforce(에이전트포스)/` 10개 노트 (언어·블록·실행흐름·레퍼런스·패턴·메타데이터 배포) |

### 최근 이니셔티브 (2026-07)

| 이니셔티브 | 결과 |
|---|---|
| 클라우드 도메인 위키화 | Sales Cloud 11 · Service · Data Cloud 8 · 제품 클라우드 개요 7 — 리브랜딩 병기(Agentforce Sales/Service·Data 360). 소스 help.salesforce.com Tier 2 |
| 어드민 전수 커버리지 (ADMIN-EXH) | 신규 33 + 보강 10, 6웨이브(인바운드 아이덴티티·감사 관찰축·어드민 빌드타임·전역 UI·이메일 인프라·운영) |
| Connect REST API | `salesforce_chatter_rest_api.pdf`(2,350p) → 18노트. Apex ConnectApi 짝 |
| 권한 모델 시리즈 | Security 10노트(Profile·PermissionSet·PSG·Object·FLS·Session 등) |
| 3층(Diátaxis) 커버리지 파일럿 프로그램 (2026-07-12 전체 완료) | 전 도메인을 개념·레퍼런스·절차 3층으로 진단, 실질 갭 선별 보충. 후기엔 findability·결정 가이드 synthesis 중심. 정본 `_MOC/Interface 답변 커버리지 검증 - Verification Harness.md` |

### Release Notes

| 릴리즈 | API | 상태 |
|---|---|---|
| Summer '26 | v67.0 | ✅ |
| Spring '26 | v66.0 | ✅ |
| Winter '26 | v65.0 | ✅ |
| Summer '25 | v64.0 | ✅ |
| Spring '25 | v63.0 | ✅ |
| Winter '25 | v62.0 | ✅ |
| Summer '24 | v61.0 | ✅ |
| Spring '24 | v60.0 | ✅ |
| Winter '24 | v59.0 | ✅ |

---

## 진행 중 / 미완료

| 항목 | 상태 |
|---|---|
| 3층(Diátaxis) 커버리지 파일럿 프로그램 | ✅ 전체 완료 (남은 파일럿 0) |
| 남은 콘텐츠 갭 — COVERAGE-GAP 개별 백로그(ANALYTICS-1·AGENT-CONCEPT-1·SEC-MON-1·CDC-1·INT-DEEP-1·OMNISTUDIO-1 등) | 🔲 |
| 누락 네임스페이스 6개 (DataRetrieval 등) — `WORK_BACKLOG.md` 참조 | 🔲 |

> 상세한 열린 항목·게이트 조건은 `_MOC/WORK_BACKLOG.md`(정본)를 참조.

---

## 노트 구조

```
forceNote-wiki/
├── 00 Home.md              ← 전체 진입점
├── 00 SEARCH_INDEX.md      ← 키워드 라우터 (도메인 → 샤드)
├── _index/                 ← 키워드 검색 샤드 32개 (도메인별 + agent-skills-refs 7 + platform-devops-tooling·agentforce·admin·sales·clouds·data-cloud·connect-rest 등)
├── Apex/                   ← 142개 노트 (네임스페이스 레퍼런스 포함)
│   ├── Security(보안)/         Safely, CanTheUser, Auth Namespace, WITH USER_MODE
│   ├── Async(비동기)/          Future, Queueable, Batch, Scheduled
│   ├── Data(데이터)/           SOQL, DML, Database NS, Search NS, FormulaEval, Reports NS
│   ├── Integration(통합)/      RestClient, Custom REST, Dom, DataSource, ExternalService,
│   │                           Invocable, Process, QuickAction, Metadata Namespace
│   ├── Testing(테스트)/        StubProvider, HttpCalloutMock, testVisible, SOSL
│   ├── Trigger(트리거)/        TriggerHandler, CMDT 트리거
│   ├── Collections(컬렉션)/    Comparator, Iterable, CollectionUtils
│   ├── ExecutionContext(실행컨텍스트)/ QuiddityGuard, OrgShape
│   ├── Logging(로깅)/          Log 싱글턴 패턴
│   ├── PlatformEvents(플랫폼이벤트)/ Platform Event, CDC, Publish Callbacks
│   ├── PlatformCache(플랫폼캐시)/   Platform Cache
│   └── Messaging(메시징)/      SingleEmailMessage, CustomNotification
├── LWC/                    ← 197개 노트
│   ├── ApexIntegration(Apex통합)/  Wire, Imperative 호출
│   ├── BaseComponents(베이스컴포넌트)/ 66개 컴포넌트 상세 레퍼런스
│   ├── SLDS(디자인시스템)/        27개 디자인시스템 노트
│   ├── Internals(내부구조)/      9개 LWC 엔진·런타임 내부구조 노트
│   ├── ComponentAPI(컴포넌트API)/  @api, 컴포지션
│   ├── Events(이벤트)/            CustomEvent, LMS, 상태 관리
│   ├── LDS/                       Record Form, uiRecordApi, getRecord, Picklist
│   ├── Navigation(네비게이션)/    NavigationMixin
│   ├── UIPatterns(UI패턴)/        Toast, 모달, Static Resource, 파일 업로드
│   ├── Mobile(모바일)/            getBarcodeScanner, getLocationService
│   ├── Testing(테스트)/           Jest 테스트
│   └── Security(보안)/            customPermission, CSP, DOM XSS
├── Flow/                   ← 30개 노트 (운영·수명주기·Record-Triggered/Orchestration 전용 노트)
├── Architecture(아키텍처)/  ← 24개 노트 (System/Schema/ApexPages/Site/Canvas NS, Governor Limits, 서비스 레이어 등)
├── DevOps(데브옵스)/        ← 105개 노트 (DX 개요, Scratch Org, Unlocked Package, CI/CD, 2GP 시리즈, Metadata API, DevOps Center, Tooling API)
│   ├── DevOpsCenter(데브옵스센터)/  DevOps Center 데이터 모델·객체 레퍼런스·플랫폼 이벤트 (6노트)
│   ├── MetadataAPI(메타데이터API)/  Metadata 타입 레퍼런스
│   └── ToolingAPI(툴링API)/        Tooling API Reference v67.0 전수 (17노트 — 개요·객체 카탈로그·C4-9 버티컬)
├── Agentforce(에이전트포스)/ ← 12개 노트 (Agent Script 전수 + 인접 — Custom Lightning Type·Prompt Template 그라운딩)
├── AgentSkills(에이전트스킬)/ ← 353개 노트 (sf-skills 85 + refs 252 + sf-mcp 10 + 샘플·Starter Kit)
├── Admin(어드민)/          ← 70개 노트 (어드민 종합 인제스트 + ADMIN-EXH 전수 커버리지 — 인바운드 아이덴티티·감사 관찰축·이메일 인프라·전역 UI 등)
├── Service(서비스)/         ← 42개 노트 (Omni-Channel, MIAW, Service Cloud Voice, Cases 라이프사이클 등)
├── Integration(통합)/      ← 40개 노트 (Named Credential, CSP/RemoteSite, Queueable+Callout, Platform Event 등)
│   └── ConnectREST(커넥트REST)/  Connect REST API 18노트 (Feed·Group·User·Files·Notifications 등 협업코어+플랫폼갭)
├── sObject/               ← 38개 노트 (표준 오브젝트·관계·필드)
├── Security(보안)/          ← 37개 노트 (Secure Coding·권한 모델 10노트·My Domain/SAML/IdP/Certificate 등)
├── FieldService(현장서비스)/ ← 22개 노트 (Field Service Developer Guide 전수)
├── Analytics(애널리틱스)/    ← 22개 노트 (Reports/Dashboards·Data Prep Recipe REST API + Analytics 개요)
├── Visualforce(비주얼포스)/  ← 19개 노트 (개념 + 표준 컴포넌트 레퍼런스 전수)
├── Scheduler(스케줄러)/      ← 12개 노트 (Salesforce Scheduler Developer Guide 전수)
├── SalesCloud(세일즈클라우드)/ ← 12개 노트 (Sales Cloud 표준 기능 — 기회·제품·견적·리드·활동·예측·영역·계약주문 + 견적 제품 선택 결정 가이드)
├── DataCloud(데이터클라우드)/  ← 8개 노트 (Data Cloud/Data 360 파이프라인 — 스트림·DLO/DMO·Identity Resolution·세그먼트·액티베이션)
├── Clouds(클라우드)/        ← 7개 노트 (제품 클라우드 지도 — Experience·Commerce·Marketing·CRM Analytics·Revenue·Net Zero 개요)
├── Aura(오라)/             ← 10개 노트
├── CPQ(견적)/              ← 6개 노트 (CPQ Developer Guide 전수)
├── Commerce(커머스)/        ← 4개 노트 (Order Management)
└── Release/                ← 61개 노트 (9개 릴리즈 완료)
```

---

## Obsidian에서 열기

1. Obsidian 실행 → **Open folder as vault**
2. `forceNote-wiki/` 폴더 선택 (저장소 루트가 아니라 위키 본체 폴더)
3. `00 Home.md` 를 시작점으로 탐색
4. **Graph View** (Ctrl/Cmd + G) 에서 노트 연결망 확인

---

## 탐색 원칙 (5층 아키텍처)

| Layer | 파일 | 용도 |
|---|---|---|
| 0 | `00 Home.md` | 전체 진입점 |
| 1 | `00 SEARCH_INDEX.md` | **라우터** — 도메인 → 샤드 매핑 (개별 페이지 나열 X) |
| 2 | `_index/{도메인}.md` | 키워드 → 파일 경로 샤드 32개 (frontend·frontend-basecomponents·visualforce·apex-core·apex-namespaces·platform·platform-devops·platform-devops-2gp·platform-devops-tooling·release·sobject-reference·service·scheduler·field-service·cpq·analytics·security·admin·sales·clouds·data-cloud·connect-rest·agentforce·agent-skills·agent-skills-refs-{7}·questions) |
| 2 | `*/MOC.md` | 섹션 목차 (사람용 브라우즈) |
| 3 | `*/index.md` | 폴더 로컬 인덱스 |
| 4 | 개별 `.md` | 패턴 상세 |

> 키워드 검색: 라우터에서 도메인 판단 → 해당 샤드 1개만 읽기. 단일 인덱스가 비대해져 truncation 나는 것을 방지. 상세 규칙은 `CLAUDE.md`.
