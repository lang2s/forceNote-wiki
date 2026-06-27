# Salesforce 개발자 위키

Salesforce 공식 오픈소스 프로젝트 + 공식 PDF 문서를 직접 분석해 추출한 검증된 패턴 모음.  
[Obsidian](https://obsidian.md)에서 열면 `[[wikilink]]` 연결과 그래프 뷰를 활용할 수 있습니다.

---

## 현황 (2026-06-27 기준)

| 섹션 | 노트 수 | 상태 |
|---|---|---|
| AgentSkills(에이전트스킬) | 352 | ✅ sf-skills 85 + refs 252 + sf-mcp 10 + 샘플·Starter Kit 5 |
| LWC (SLDS·Internals 포함) | 160 | ✅ BaseComponents 66 + SLDS 디자인시스템 + 패턴 |
| Apex | 124 | ✅ 네임스페이스 레퍼런스 + 패턴 |
| DevOps(데브옵스) | 84 | ✅ DX·2GP 시리즈·Metadata API·DevOps Center |
| Release | 61 | ✅ 9개 릴리즈 (Winter '24 ~ Summer '26) |
| sObject | 38 | ✅ 표준 오브젝트·관계·필드 |
| Service(서비스) | 30 | ✅ Omni-Channel·Lightning Flow for Service 등 |
| Architecture(아키텍처) | 23 | ✅ 플랫폼·공유·레코드 액세스 |
| FieldService(현장서비스) | 22 | ✅ Field Service Developer Guide 전수 |
| Analytics(애널리틱스) | 21 | ✅ Reports/Dashboards·Data Prep Recipe REST API |
| Visualforce(비주얼포스) | 16 | ✅ 개념 + 표준 컴포넌트 레퍼런스 전수 |
| Security(보안) | 15 | ✅ LWS·CSP·Experience Cloud 보안 등 |
| Flow | 15 | ✅ 완료 |
| Scheduler(스케줄러) | 12 | ✅ Salesforce Scheduler Developer Guide 전수 |
| Integration(통합) | 8 | ✅ REST·Bulk·Actions·Named Credential 등 |
| Aura(오라) | 7 | ✅ 완료 |
| CPQ(견적) | 6 | ✅ CPQ Developer Guide 전수 |
| Admin(어드민) | 4 | 🟡 선언적 어드민 일부 (Data Loader 등) |
| Commerce(커머스) | 4 | ✅ Order Management |
| **합계** | **~1,000** | |

> 노트 수치는 index.md·MOC 같은 탐색 파일을 제외한 콘텐츠 노트 기준(2026-06-27 집계). 트리의 폴더별 수치는 참고용.

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
| 대형 PDF 미위키화 — api_tooling·extend_click_automate·Connect REST (분할 전략 선결) | 🔲 |
| ADMIN 갭 (Approval·Formula·Profiles 등 선언적 어드민 how-to) — 공식 Admin PDF 확보 시 | 🔲 |
| 누락 네임스페이스 6개 (DataRetrieval 등) — `WORK_BACKLOG.md` 참조 | 🔲 |

> 상세한 열린 항목·게이트 조건은 `_MOC/WORK_BACKLOG.md`(정본)를 참조.

---

## 노트 구조

```
forceNote-wiki/
├── 00 Home.md              ← 전체 진입점
├── 00 SEARCH_INDEX.md      ← 키워드 라우터 (도메인 → 샤드)
├── _index/                 ← 키워드 검색 샤드 25개 (도메인별 + agent-skills-refs 7)
├── Apex/                   ← 124개 노트 (네임스페이스 레퍼런스 포함)
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
├── LWC/                    ← 160개 노트
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
├── Flow/                   ← 15개 노트
├── Architecture(아키텍처)/  ← 23개 노트 (System/Schema/ApexPages/Site/Canvas NS, Governor Limits, 서비스 레이어 등)
├── DevOps(데브옵스)/        ← 84개 노트 (DX 개요, Scratch Org, Unlocked Package, CI/CD, 2GP 시리즈, Metadata API, DevOps Center)
│   └── DevOpsCenter(데브옵스센터)/  DevOps Center 데이터 모델·객체 레퍼런스·플랫폼 이벤트 (6노트)
├── AgentSkills(에이전트스킬)/ ← 352개 노트 (sf-skills 85 + refs 252 + sf-mcp 10 + 샘플·Starter Kit)
├── Service(서비스)/         ← 30개 노트 (Omni-Channel, Lightning Flow for Service 등)
├── FieldService(현장서비스)/ ← 22개 노트 (Field Service Developer Guide 전수)
├── Analytics(애널리틱스)/    ← 21개 노트 (Reports/Dashboards·Data Prep Recipe REST API)
├── Visualforce(비주얼포스)/  ← 16개 노트 (개념 + 표준 컴포넌트 레퍼런스 전수)
├── Security(보안)/          ← 15개 노트 (LWS, CSP, Experience Cloud 보안 등)
├── Scheduler(스케줄러)/      ← 12개 노트 (Salesforce Scheduler Developer Guide 전수)
├── Integration(통합)/      ← 8개 노트 (Named Credential, CSP/RemoteSite, Queueable+Callout, Platform Event 등)
├── Aura(오라)/             ← 7개 노트
├── CPQ(견적)/              ← 6개 노트 (CPQ Developer Guide 전수)
├── Admin(어드민)/          ← 4개 노트
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
| 2 | `_index/{도메인}.md` | 키워드 → 파일 경로 샤드 25개 (frontend·frontend-basecomponents·visualforce·apex-core·apex-namespaces·platform·platform-devops·platform-devops-2gp·release·sobject-reference·service·scheduler·field-service·cpq·analytics·security·agent-skills·agent-skills-refs-{7}·questions) |
| 2 | `*/MOC.md` | 섹션 목차 (사람용 브라우즈) |
| 3 | `*/index.md` | 폴더 로컬 인덱스 |
| 4 | 개별 `.md` | 패턴 상세 |

> 키워드 검색: 라우터에서 도메인 판단 → 해당 샤드 1개만 읽기. 단일 인덱스가 비대해져 truncation 나는 것을 방지. 상세 규칙은 `CLAUDE.md`.
