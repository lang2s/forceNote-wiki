---
tags: [meta, qa, verification, integration, interface, harness, diataxis, three-layer]
source: 위키 자가검증 (2026-07-07 세션, 라우터→샤드→파일 네비게이션 대조)
created: 2026-07-07
aliases: [인터페이스 검증, Interface Coverage Verification, 통합 답변 검증, verification harness, 위키 검증 하네스, 3층 감사, Diátaxis 커버리지, three-layer coverage audit, 레이어 커버리지]
---

# Interface(통합/연결) 답변 커버리지 검증 — Verification Harness

> 위키 품질을 두 축으로 반복 점검하는 QA 하네스: **① 답변 커버리지 검증**(위키가 실무 질문의 정답을 실제로 추출해 주는가) + **② 3층(Diátaxis) 커버리지 감사**(핵심 토픽이 개념·레퍼런스·절차 3층을 갖췄는가). 도메인·질문을 바꿔가며 재실행한다.

---

## 이 노트의 용도

이 문서는 위키 지식 노트가 아니라 **메타/검증 도구**다(`_MOC/WIKI_RULES.md`와 같은 시스템 파일). 목적:

1. 도메인의 "답변 커버리지"를 주기적으로 재측정한다(**방법론 1**).
2. 핵심 토픽의 "3층(개념·레퍼런스·절차) 커버리지"를 감사한다(**방법론 2**).
3. 질문 세트·대상 도메인을 교체하며 새 사각지대를 찾는다.
4. 발견된 갭 → 보충 이력을 남겨 회귀(regression)를 방지한다.

---

## 방법론 1 — 답변 커버리지 검증 (핵심 규율)

```text
// 절차 — 재실행 시 그대로 따른다
1. 질문을 위키에서 역산하지 않는다.  ← 가장 중요
   · 위키에 뭐가 있는지 보고 질문을 만들면 100% 통과라는 착시만 남는다.
   · 질문은 (a) 실무 admin/dev/architect 관점에서 독립 생성 + (b) 웹의 실제 Q&A(Stack Exchange·Trailblazer·Reddit)에서 수집한다.
   · 일부러 "위키에 없을 법한" 질문을 섞는다(아키텍처 판단·운영·거버넌스).
2. 각 질문을 위키 네비게이션 경로로만 답한다:
   00 SEARCH_INDEX.md(라우터) → _index/{샤드}.md → 실제 노트.md 를 열어 섹션을 읽고 판정.
   · 검사관의 외부 지식은 "위키 내용의 정확성/완결성 평가"에만 쓴다. 빈틈을 채워 ✅ 주면 안 된다.
3. 판정: ✅ 정답 명확 / ⚠️ 토픽은 있으나 핵심 답·수치·절차 누락·얕음 / ❌ 위키에 없음.
4. 배치를 토픽 단위로 잘라 병렬 검증(각 에이전트가 관련 샤드 1~2개만 로드).
5. 확정 갭(⚠️·❌)은 출처 Tier(로컬 PDF=Tier1/2, 공식 웹=Tier2)를 지켜 보충 → 재검증.
```

- 범위(이번 라운드): REST/SOAP API · Connected App · Auth Provider · Named Credential · OAuth 플로우 · Apex Callout/REST · External Services · CORS · External Objects · Apex 시스템 인터페이스(Batchable·Schedulable·Queueable·Comparable·Callable·Mock).
- **제외**: Bulk API · Pub/Sub API(gRPC) — 별도 노트로 최근 검증됨.

---

## 방법론 2 — 3층(Diátaxis) 커버리지 감사

> "위키가 답을 주는가"(방법론 1)와 별개로, **"핵심 토픽이 세 종류의 문서를 갖췄는가"**를 본다. 없는 문서 유형이 있으면 실무가 특정 상황에서 막힌다.

### 3층 정의
| 층 | 답하는 질문 | 목적 |
|---|---|---|
| 개념(Concept) | "이게 뭐고 왜?" | 이해 |
| 레퍼런스(Reference) | "뭐가 있지?"(메서드·필드·enum·한도 전수) | 찾아보기 |
| 절차(How-to) | "어떻게 처음부터?" | 따라하기 |

한 노트가 여러 층을 겸할 수 있다(대개 개념+레퍼런스 혼합).

### 감사 절차

```text
1. 도메인을 토픽 단위 클러스터로 나눠 병렬 진단(각 에이전트가 한 클러스터의 노트를 Read).
2. 토픽 × 3층 매트릭스로 판정: ✅충분 / 🟡부분·얕음·타 노트에 파묻힘 / ❌없음 + 근거 파일.
3. ⚠️ 모든 토픽을 3개 노트로 쪼개지 않는다 — 빈 껍데기 양산은 안티패턴.
   빠져서 실무가 막히는 층만 선별 보충. 이미 3층이면 건드리지 않는다.
4. 신규 노트는 단일 목적(개념 OR 레퍼런스 OR 절차)으로 쓰고 서로 링크한다.
5. 보충 → writer(콘텐츠) → index-manager(탐색) → QA. 부수로 낡은 사실·오류도 정정한다.
```

### 적용 이력
| 도메인 | 진단 클러스터 | 결과 | 커밋 |
|---|---|---|---|
| Integration | 3 (인증/API/이벤트) | "서버간은 3층 완성, 대화형(Web Server+PKCE)·인바운드 SSO(Auth Provider)·Streaming(CometD)은 절차/개념 결손" → 신규 7 + 보강 3 | `7c9627e` |
| Apex (언어/코어) | 8 (언어·데이터·비동기·컬렉션·트리거·테스트·보안·플랫폼) | "보안 최대 공백, 데이터·트리거·이벤트 완결" → 신규 10 + 보강 13 | `7c787c4` |
| LWC | 7 (기초·데이터·이벤트·UI/모바일·내부구조·테스트·SLDS) | "이벤트·데이터는 완결, 테스트·절차·SLDS 층 결손" → 신규 20 + 보강 8 | `67278f7` |
| Flow | 4 (타입·개념 / 설계·운영 / UI·절차 / 연동·액션) | "레퍼런스·설계는 성숙, **운영·수명주기 층이 최대 공백**(배포·버전·테스트·디버깅·한도)·Record-Triggered/Orchestration 전용 노트 부재·표준 Screen 컴포넌트 카탈로그 결손" → 신규 13 + 보강 7 | `c5ff5d2` |
| Aura (레거시) | 2 (코어·실전 / 마이그레이션) | "**레거시 기준 적용**(신규 앱 아닌 유지보수·이관 관점). 정적 매핑(번들·ui컴포넌트)은 탄탄, **서버 액션 데이터층**(action state·setStorable 캐시)과 **동적 이관축**(이벤트 모델·force:* → LWC 등가·역방향 상호운용)이 공백" → 신규 1 + 보강 4 | `bfa7b2d` |
| Visualforce (레거시·성숙) | 2 (코어·테스트·보안 / 현대화·이관) | "**이미 전수 인제스트된 성숙 도메인**(18노트). 진단 결과 콘텐츠 갭 거의 0 — 유일한 진짜 갭은 **Aura엔 있고 VF엔 없던 이관 결정 노트**(구조적 비대칭). 나머지는 findability(흩어진 사실 잇기)" → 신규 1 + 보강 4 | `53d904f` |
| Security (크로스커팅) | 2 (위협·시큐어코딩 / 플랫폼·강제) | "3-way 분산(Security·Apex/Security·LWC/Security). 개별 위협 방어법·강제 API는 성숙, **크로스커팅 절차 층이 공백** — 위협별 리뷰 체크리스트·접근제어 5수단 결정 가이드. 관찰축(Event Monitoring)은 별도 이니셔티브로 백로그(SEC-MON-1)" → 신규 2 + 후속 백로그 2 | `cb64d21` |
| DevOps (성숙·대형) | 3 (DX워크플로 / CI·CD·배포 / 패키징) | "**105노트 성숙 도메인**. 레퍼런스 카탈로그(Metadata/Tooling API·2GP 컴포넌트) 진단 제외. 개별 사실은 이미 전수 — 남은 갭이 **전부 크로스커팅 결정층·색인**(3진단이 독립적으로 '결정 가이드' 지목): 배포방법·패키징유형·환경선택 결정 + sf CLI 카탈로그(흩어진 명령 색인 + sfdx→sf 매핑)" → 신규 4 + 보강 5 (전부 synthesis) | `267da0a` |
| Service (성숙) | 3 (케이스·채널 / 라우팅·Knowledge / 개발자PDF 스카우트) | "**43노트 성숙 도메인**. 케이스 코어·라우팅(Queue/Skills/External)·Knowledge는 3층 완비 — 핵심 갭은 **은퇴 채널의 공식 후속이 통째로 미커버**(forward-looking 공백): Chat(2026-02 은퇴)→MIAW 0커버·Open CTI(2028-02)→Voice 0커버. + 채널 결정표·Cases 라이프사이클. 부수: 백로그 SVC-DEV-1 stale CLOSE(파일명 함정, 이미 전수 채굴). Einstein for Service는 Agentforce 귀속 보류" → 신규 2 + 보강 2 | `3f90c9c` |
| Analytics·sObject·Architecture (3도메인 묶음) | 3 병렬 (도메인별 토픽×3층) | "**세 도메인이 3층 분포 극단으로 다름**. ① **sObject**(태생 레퍼런스 카탈로그) → 방법론상 진단 제외, 결정층이 이미 `Object Groups`(7축)+CMT-vs-CustomSetting에 분산 완비 → **콘텐츠 갭 0**(과잉생산 회피). ② **Analytics**(21노트 전부 REST 덤프) → 레퍼런스만 두껍고 개념·결정층 부재, 표준 리포팅 개념은 이미 Admin에 존재(중복 회피) → 진짜 갭은 **두 애널리틱스 세계(표준 vs CRM Analytics) 라우팅 synthesis 1** + Admin Reports UI 절차(미채굴 tipsheet). ③ **Architecture**(3층 성숙) → 갭은 콘텐츠 아닌 **findability**: 핵심 결정노트(자동화·거버너·오브젝트타입·비동기·환경)가 타 폴더에 완성됐는데 아키텍트 허브에서 도달 불가 → MOC 결정 가이드 라우팅표(7노트) 신설. **전 도메인 신규 콘텐츠 단 1건**, 나머지는 nav/synthesis" → 신규 1 + 보강 1 + findability(교차링크 6·MOC 결정섹션·샤드) | `022c178` |
| 클라우드/산업 소도메인 (9묶음) | 3 병렬 클러스터 (판매·견적 / 현장·데이터·클라우드 / AI·에이전트·통합) | "**9소도메인 대부분 이미 전용 인제스트 완료**(FieldService 109객체·ConnectREST 18·AgentScript 10·클라우드 35). 자체 3층 완비 → 갭은 전부 **cross-domain findability + 결정 1건**. 유일 신규 콘텐츠 = **견적 3제품 결정 가이드**(표준 Quote vs CPQ〔end-of-sale 2025-03-27〕 vs Revenue Cloud/RLM, synthesis). findability 5갭: CPQ→표준Quote reverse island·Commerce OM↔표준Order 명명혼동·DataCloudObjects→개념·**DataCloud↔Agentforce 그라운딩(클러스터2·3 독립 지목=교차검증)**. **완비 판정(건드리지 않음)**: FieldService↔Scheduler 구분 3중 명시·ConnectREST↔ConnectApi 양방향·AgentSkills 358 디스패처. Agentforce 개념 오리엔테이션은 help.Tier2 필요라 AGENT-CONCEPT-1 백로그 분리" → 신규 1 + findability 9링크 | `a618374` |

- **재사용**: 새 도메인마다 "클러스터 분할 → 토픽×3층 매트릭스 → 선별 보충"을 반복. 부수 효과로 Tier 3 노트의 오류·낡은 사실이 함께 잡힌다(예: External Services Tier 3→2 오류 정정).
- **Flow 파일럿 부수 성과**: source-verifier가 pdftotext 붕괴 구간(Orchestration Resume 매트릭스·Entitlements 이례 수치)을 이미지 대조로 확정 / writer가 오케스트레이터 페이지 지시 3건을 소스 우선으로 정정(Actions API의 flow-invoke body는 ECA가 아니라 api_action.pdf 소관 등) / `extend_click_automate.pdf`(Spring '26, 1,027p Flow 종합 가이드)가 위키 콘텐츠 첫 인용 — 그간 미채굴 소스였음.
- **Aura 파일럿 교훈(레거시 도메인 규율)**: 레거시는 "기능 미문서화"가 아니라 "**유지보수·이관에서 실제로 막히는 층**"만 갭으로 잡는다 — 진단이 런타임 에러 사전·LTS·SLDS를 명시적 "건드리지 않음"으로 처리하고 신규 노트를 1개로 억제(빈 껍데기 양산 회피). 부수 발견: `lightning.pdf`는 `lightningAura.pdf`의 **바이트 동일 복제본**(md5 일치) — 로컬 Aura 소스는 사실상 1종, LWC 가이드로 오인 금지. LWC-in-Aura 임베딩 문법은 원 소스가 LWC Dev Guide(로컬 미보유)라 writer가 합성+마커+위임으로 정직 처리.
- **Visualforce 파일럿 교훈(성숙 도메인의 갭 성격)**: 이미 전수 인제스트된 도메인에서 남는 갭은 "**없는 사실**"이 아니라 (1) **구조적 비대칭**(Aura엔 이관 결정 노트가 있는데 VF엔 없음 → 신규 1) (2) **findability**(getContentAsPDF 테스트 실패 함정이 Apex 노트엔 있으나 VF PDF 노트에서 도달 불가 → 백링크·체크리스트 보강). 진단이 VF 테스트·보안·Appendix B Data Access를 전부 "이미 커버, 신규 만들면 빈 껍데기"로 정직 판정 → 신규 노트 바를 높게 유지. 두 레거시 도메인(Aura·VF)의 마이그레이션 결정 노트를 상호 링크로 대칭화.
- **Security 파일럿 교훈(크로스커팅 절차 층 + 범위 규율)**: 개별 위협의 방어법(개념·레퍼런스·절차)이 모두 전수여도, **실무 흐름(리뷰·결정)으로 묶는 크로스커팅 절차 층**이 비어 있을 수 있다 — 리뷰 체크리스트(8위협 hub)·접근제어 5수단 결정 매트릭스가 그 갭. 둘 다 재추출 없이 기존 검증 노트 조합(synthesis). **범위 규율**: 진단이 발굴한 Event Monitoring(관찰축)·Health Check는 "빠진 3층"이 아니라 **새 토픽(reference)**이고 help.salesforce.com Tier 2가 필요해, 파일럿 초점(절차·체크리스트)에서 분리하고 백로그(SEC-MON-1·SEC-HC-1)로 등재 — 과잉생산 회피. Event Monitoring은 이 파일럿과 Integration 하네스가 독립적으로 같은 갭을 지목(교차 검증).
- **클라우드/산업 소도메인 파일럿 교훈(이미 인제스트된 도메인 묶음 = 순수 findability)**: 9개 소도메인이 대부분 전용 인제스트 이니셔티브로 이미 전수 커버된 상태 → 3층 파일럿의 산출이 **신규 콘텐츠 1건 + 링크 9건**으로 수렴. 핵심 패턴 셋: (1) **reverse island**: A→B 정방향 링크는 있는데 B→A가 0인 단방향 섬(SalesCloud Quotes→CPQ는 있으나 CPQ 7노트→표준 Quote 0). 정방향만 보고 "연결됨"으로 오판하지 말 것 — 양방향 grep 필수. (2) **명명 혼동 disambiguation**: 표준 `Order` 객체(SalesCloud) vs Order Management(SOM/OrderSummary, Commerce)처럼 이름이 겹치는 별개 개념은 상호 링크 + 1줄 구분으로 실무 혼동 해소(신규 노트 불요). (3) **교차검증**: 두 클러스터가 독립적으로 같은 갭(DataCloud↔Agentforce 그라운딩)을 지목 = 실재 확실(Security의 Event Monitoring 이중 지목과 동형). **범위 규율 재확인**: Agentforce 개념 오리엔테이션(설명층 공백)은 진짜 갭이나 help.salesforce.com Tier 2가 필요해 링크·synthesis 위주인 이 파일럿과 성격이 달라 AGENT-CONCEPT-1로 분리(Security SEC-MON-1과 동형). **완비 판정의 가치**: FieldService↔Scheduler(FSL≠LxScheduler 3중 명시)·ConnectREST↔ConnectApi 양방향은 오히려 모범 사례로 "건드리지 않음" 확정.
- **Analytics·sObject·Architecture 파일럿 교훈(성숙 도메인 묶음 = findability가 갭)**: 3층이 성숙할수록 갭은 "**없는 사실**"이 아니라 "**도달 불가한 사실**"이다. 세 도메인이 같은 진실을 다른 각도로 보였다 — (1) **태생 레퍼런스 규율의 실증**: sObject는 결정층(`Object Groups` 7축·CMT-vs-CustomSetting)·개념층(`1 Overview`·`Object Types Reference`)이 이미 완비라 **콘텐츠 갭 0**으로 정직 판정, 통합 결정 노트 만들면 재합성 중복(빈 껍데기). Platform Event를 저장-선택축에 넣으면 카테고리 오류라는 지적까지(이벤트≠저장 오브젝트). (2) **중복 회피**: Analytics 폴더에 개념층이 없어도 표준 리포팅 개념은 이미 `Admin`에 존재 → 폴더에 개념 노트 신설 금지, 링크로 연결. 진짜 갭은 **두 애널리틱스 세계(표준 vs CRM Analytics) API 라우팅 synthesis**뿐. (3) **findability = index-manager/cross-linker가 최대 가치**: Architecture는 자동화(Flow vs Trigger)·거버너·오브젝트타입·비동기·환경 결정노트가 전부 타 폴더에 완성됐는데 아키텍트 허브(MOC)에서 링크 안 됨 → MOC "아키텍처 결정 가이드" 라우팅표(7노트)로 해소. **전 파일럿 신규 콘텐츠 단 1건**(Analytics synthesis), 나머지는 nav·교차링크. Security의 "결정 매트릭스 synthesis" 갭과 동형이 반복 확인. 부수: 로컬 `salesforce_analytics_rest_api.pdf`는 이름과 달리 Reports&Dashboards 가이드(이미 채굴), CRM Analytics asset REST API는 로컬 미보유 → 백로그(ANALYTICS-1).

### 남은 파일럿 (백로그 — 우선순위순, 2026-07-08 등록 / Flow·Aura·VF·Security 완료 2026-07-11)

✅ **전 도메인 파일럿 완료** — Integration·Apex·LWC·**Flow**·**Aura**·**Visualforce**·**Security**·**Admin**(ADMIN-EXH)·**DevOps**·**Service**·**Analytics·sObject·Architecture**·**클라우드/산업 9소도메인** 전부 소진. 남은 파일럿 0. 새 도메인 추가 시 같은 방법론으로 재진단(괄호=콘텐츠 노트 수).

| # | 도메인 | 규모 | 진단 착안점(예상) |
|---|---|---|---|
| ~~–~~ | ~~**Flow**~~ | ~~중~~ | ✅ **완료(2026-07-11, `c5ff5d2`)** — 신규 13 + 보강 7. 운영·수명주기 층·Record-Triggered/Orchestration 전용 노트·Screen 컴포넌트 카탈로그 |
| ~~–~~ | ~~**Aura(오라)**~~ | ~~소~~ | ✅ **완료(2026-07-11, `bfa7b2d`)** — 신규 1 + 보강 4. 레거시 규율: 서버 액션 데이터층 + 이벤트 모델/force:* 이관 매핑 |
| ~~–~~ | ~~**Visualforce(비주얼포스)**~~ | ~~중~~ | ✅ **완료(2026-07-11, `53d904f`)** — 신규 1 + 보강 4. 성숙 도메인 → VF→LWC 이관 결정 노트(Aura 대칭) + findability 보강 |
| ~~–~~ | ~~**Security(보안)**~~ | ~~중~~ | ✅ **완료(2026-07-11)** — 신규 2 + 백로그 2. 크로스커팅 절차 층: 시큐어 코드 리뷰 체크리스트 + 접근제어 5수단 결정 가이드. 관찰축(Event Monitoring)·Health Check는 SEC-MON-1·SEC-HC-1로 분리 |
| ~~–~~ | ~~**Admin(어드민)**~~ | ~~대~~ | ✅ **완료(2026-07-12)** — 3층 파일럿을 넘어선 **ADMIN-EXH 전수 커버리지 이니셔티브**(사용자 "전부 다" 요청). 6웨이브 신규 33 + 보강 10. 위키 4대 구조적 공백(인바운드 아이덴티티·감사 관찰축·어드민 빌드타임·전역 UI) + 이메일 인프라 + 운영. 상세 [[WORK_BACKLOG]] ADMIN-EXH |
| ~~–~~ | ~~**DevOps(데브옵스)**~~ | ~~대~~ | ✅ **완료(2026-07-12, `267da0a`)** — 신규 4 + 보강 5. 105노트 성숙 도메인. 레퍼런스 카탈로그 진단 제외, 워크플로·배포·패키징 3클러스터 → 남은 갭은 결정층·색인(배포방법·패키징유형·환경선택 결정 + sf CLI 카탈로그). 전부 synthesis |
| ~~–~~ | ~~**Service(서비스)**~~ | ~~대~~ | ✅ **완료(2026-07-12, `3f90c9c`)** — 신규 2 + 보강 2. 은퇴 채널 후속(MIAW·Voice) 0커버 해소 + 채널 결정표·Cases 라이프사이클. SVC-DEV-1 백로그 stale CLOSE |
| ~~–~~ | ~~**Analytics·sObject·Architecture**~~ | ~~중~~ | ✅ **완료(2026-07-12)** — 신규 1 + 보강 1 + findability. 성숙 도메인 묶음 → 갭은 "도달 불가한 사실". sObject 콘텐츠 갭 0(태생 레퍼런스·결정층 분산 완비). Analytics=두 세계 API 라우팅 synthesis + Admin Reports UI 절차(tipsheet). Architecture=MOC 결정 가이드 라우팅표(7노트) findability. 미커버 CRM Analytics asset REST는 ANALYTICS-1 백로그 |
| ~~1~~ | ~~클라우드/산업: Commerce·Scheduler·FieldService·CPQ·SalesCloud·DataCloud·Agentforce·AgentSkills·ConnectREST~~ | ~~소~~ | ✅ **완료(2026-07-12, `a618374`)** — 신규 1 + findability 9. 9소도메인 대부분 이미 인제스트 완료 → 순수 cross-domain findability + 견적 3제품 결정 가이드. reverse island·명명 혼동·교차검증 패턴. Agentforce 개념층은 AGENT-CONCEPT-1 백로그 분리 |

- **재실행법**: 다음 세션에서 "[도메인] 3층 파일럿 진행"이라고 하면 방법론 2(클러스터 분할 → 토픽×3층 매트릭스 → 선별 보충)를 그대로 적용. BaseComponents류 "태생이 레퍼런스"인 대량 카탈로그는 진단 제외.
- ✅ **3층 파일럿 프로그램 전체 완료(2026-07-12)**: 위키 전 도메인 진단 완료 — Integration·Apex·LWC·Flow·Aura·VF·Security·Admin·DevOps·Service·Analytics·sObject·Architecture + 클라우드/산업 9소도메인. **남은 파일럿 0.** 후속 콘텐츠 갭은 방법론 2가 아니라 개별 백로그(COVERAGE-GAP: ANALYTICS-1·AGENT-CONCEPT-1·SEC-MON-1·CDC-1·INT-DEEP-1·EXP-DEV-1·OMNISTUDIO-1·AI-CLASSIC-1 등)로 관리한다. 새 도메인 추가 시 이 하네스로 재진단.

---

## 라운드 1 결과 — 독립 생성 질문 70개 (2026-07-07)

| 배치 | 주제 | ✅ | ⚠️ | ❌ |
|---|---|---|---|---|
| A | REST API | 7 | 2 | – |
| B | SOAP API + Platform Events/CDC | 11 | – | – |
| C | Connected App / OAuth | 10 | – | – |
| D | Auth Provider / Named Credential | 7 | 1 | – |
| E | Callout / Custom REST / External Services / CORS / External Objects | 11 | 1 | – |
| F | Apex 시스템 인터페이스 | 8 | 2 | – |
| G | 아키텍처 / 어드민 크로스 | 5 | 3 | 2 |
| **합계** | | **59** | **9** | **2** |

## 라운드 2 결과 — 웹 실제 질문 33개 (Stack Exchange·Trailblazer·Reddit, URL 인용)

| 배치 | ✅ | ⚠️ | 대표 실제 에러/질문 |
|---|---|---|---|
| REST/SOAP | 4 | 4 | INVALID_SESSION_ID, sObject tree 본문, 버전 선택 |
| 인증/OAuth | 6 | 2 | invalid_grant 만료 토큰, Invalid JWT Signature |
| Callout/외부연동 | 8 | 1 | Unauthorized endpoint, uncommitted work, CORS 403, External Objects OData |
| Apex 인터페이스 | 4 | 4 | Too many queueable, cron `?`, Comparable, WebServiceMock |
| **합계** | **22** | **11** | |

**총계 103문항: 81✅ / 20⚠️ / 2❌** (중복 제외 시 고유 갭 13건)

### 진단 패턴
- **"무엇을/어떻게"(레퍼런스·시그니처·설정 경로)는 거의 완벽** — API 엔드포인트·수치·OAuth 정책·콜아웃 제약을 공식문서급으로 답한다.
- **갭은 두 축에 집중**: ① "언제 무엇을 고르나"(아키텍처 결정) ② "운영·거버넌스"(라이선스·모니터링·멱등성·에러 진단). 지식 베이스가 "사전"으로는 성숙, "설계 안내서"로는 성장 중이었다.

---

## 확정 갭 → 보충 이력 (2026-07-07 세션, 13건 전부 처리)

| # | 갭(질문) | 처리 | 대상 노트 | 출처 |
|---|---|---|---|---|
| 1 | WebServiceMock(SOAP 콜아웃 테스트) 부재 | **신규** | [[WebServiceMock]] (+[[HttpCalloutMock]] 교차링크) | apex PDF Tier2 |
| 2 | Comparable 직접 구현 코드 없음 | augment | [[Comparator 인터페이스]] | apex PDF |
| 3 | Scheduled cron `?` 상호배타 규칙 | augment | [[Scheduled Apex]] | apex PDF |
| 4 | Batch Stateful의 static 변수 함정 | augment | [[Batch Apex]] | apex PDF |
| 5 | REST 호출 전제/API Enabled 최소권한 | augment | [[REST API]] | api_rest.pdf |
| 6 | REST 버전 하위호환/은퇴(410 GONE) | augment | [[REST API]] | api_rest.pdf |
| 7 | sObject Tree 요청 본문 예시(200·5레벨) | augment | [[REST API]] | api_rest.pdf |
| 8 | INVALID_SESSION_ID(401) 실제 원인 | augment | [[REST API]] | api_rest.pdf + 웹 |
| 9 | invalid_grant 만료 토큰(5-grant 한도·비번변경 폐기) | augment | [[Connected App (연결된 앱) — OAuth 클라이언트]] | help.salesforce.com |
| 10 | Invalid JWT Signature / 외부키 JKS import | augment | [[Connected App (연결된 앱) — OAuth 클라이언트]] | help.salesforce.com |
| 11 | Per-User vs Named Principal + mutual TLS/two-way SSL | augment | [[Named Credential]] · [[Secure Communications (TLS)]] | 공식 웹 |
| 12 | Salesforce Connect vs 복제 결정표 + OData 노코드/트러블슈팅 | augment | [[External Objects]] | 공식 웹 |
| 13 | 미들웨어 vs point-to-point + 재시도·멱등성 / 통합 사용자 라이선스 | **신규 2** | [[통합 아키텍처 결정 - 미들웨어·재시도·멱등성]] · [[Integration User & API-Only User (통합 사용자)]] | architect.salesforce.com |

### 남은 백로그
- **Event Monitoring / EventLogFile 전용 노트** (라운드1 Q65) — API usage 모니터링·`/limits`·Setup 위치는 이미 [[Salesforce 한도·할당량 레퍼런스 (API·Bulk·Metadata·SOQL·VF)]]에 있으나, EventLogFile(ApiEvent·LoginEvent 로그) 콘텐츠는 별도 이니셔티브 규모라 미착수.
- SOAP `sessionId`를 REST Bearer로 재사용 가능 여부의 명시 서술(웹 REST Q5) — INVALID_SESSION_ID 보충으로 대부분 해소, 경미.

---

---

## 라운드 3 결과 — ERP·미들웨어·포맷·벤더 통신 (2026-07-07, 59문항)

더 구체적/벤더 지향 토픽. 독립 질문 35 + 웹 실제 질문 24.

| 배치 | ✅ | ⚠️ | ❌ | 주제 |
|---|---|---|---|---|
| R3-A | 7 | 1 | 1 | Named Credential(심화) · Remote Site 등록 |
| R3-B | 4 | 3 | 2 | Middleware · WSDL 등록 |
| R3-C | 7 | 2 | – | JSON 형식 · XML 형식 |
| R3-D | 2 | 5 | 1 | ERP/벤더 · 운영 |
| 웹 WSDL/JSON/XML | 3 | 5 | – | 실제 Q&A |
| 웹 NamedCred 콜아웃 | 6 | 1 | 1 | 실제 Q&A |
| 웹 미들웨어/ERP | 4 | 3 | 1 | 실제 Q&A |
| **합계** | **33** | **20** | **6** | |

**누적 3라운드 총계: 162문항 (114✅ / 40⚠️ / 8❌)**

### 라운드 3 진단
- **최근 보충 노트가 앵커로 작동** — JSON·Named Credential·Dom·통합 아키텍처 결정이 실제 질문의 진입점 역할을 잘 했다(라운드1 보충 효과 확인).
- **갭 3축**: ① WSDL2Apex **소비**(위키가 "노출"만 강했음) ② 스트리밍 XML(DOM만 있었음) ③ 서드파티 제품(SAP·Informatica) 연동.
- **정확성 버그 1건 발견·정정** — 웹 검증이 `wsdl2apex-guide.md`의 "RPC/encoded 지원" 오기를 잡음(공식은 document literal wrapped 전용). 커버리지 검증이 정확성 감사를 겸했다.

### 라운드 3 확정 갭 → 보충 이력 (13갭, 7클러스터 전부 처리)

| # | 갭 | 처리 | 대상 노트 | 출처 |
|---|---|---|---|---|
| R3-1 | WSDL2Apex 외부 SOAP 소비(스텁 구조·미지원 스키마·1M자 한도) | **신규** | [[WSDL2Apex — 외부 SOAP 소비 (스텁 생성·구조·한도)]] | apex PDF |
| R3-2 | `wsdl2apex-guide` rpc "지원" 오기 | **정정** | AgentSkills/…/wsdl2apex-guide.md | apex PDF |
| R3-3 | 스트리밍 XML(XmlStreamReader/Writer 메서드 전수) | **신규** | [[XmlStreamReader·XmlStreamWriter (스트리밍 XML)]] | apex PDF |
| R3-4 | Named Credential Custom 인증 프로토콜·named param + Profile 배포 함정 | augment | [[Named Credential]] | 공식 웹 |
| R3-5 | 아웃바운드 IP allowlist·Private Connect | **신규** | [[아웃바운드 연결 - IP allowlist·Private Connect]] | help.salesforce.com |
| R3-6 | SAP·Oracle·NetSuite·Informatica·MuleSoft 연동 라우팅 + API-led + 실시간/배치 | **신규** | [[ERP·서드파티 제품 연동 지도]] | architect + 벤더(Tier3 격리) |
| R3-7 | JSON 방어적 역직렬화(instanceof·TypeException·typed List) | augment | [[JSON 직렬화 심화 — JSONParser·JSONGenerator·예약어 충돌]] | apex PDF |
| R3-8 | Outbound Message vs PE vs REST 비교·실시간vs배치·미들웨어 한도관리 | augment | [[통합 아키텍처 결정 - 미들웨어·재시도·멱등성]] | architect |

### 라운드 3 남은 백로그
- **Event Monitoring / EventLogFile 전용 노트**(라운드1부터 이월) — 별도 이니셔티브 규모.
- **통합 감사 how-to**(Setup Audit Trail·Field History·Login History로 "누가 무엇을 sync") — 통합 사용자 노트에 개념은 있으나 도구별 절차는 미보강.
- **서드파티 제품 내부 설정**(MuleSoft API-led 상세·Informatica IICS 커넥터 옵션·SAP PI/PO) — Salesforce 지식베이스 성격상 **의도된 경계**. [[ERP·서드파티 제품 연동 지도]]가 포인터로 라우팅, 상세는 각 벤더 문서.

---

## 재실행 방법 (질문을 바꿔 재검증)

```text
// 다음 라운드 실행 절차
1. 이 노트의 "검증 방법론"을 그대로 지킨다(위키 역산 금지).
2. 질문 세트를 새로 만든다:
   · 관점 태그 [A]dmin [D]ev [Arch] 를 섞는다.
   · 웹에서 최신 실제 Q&A를 다시 수집한다(에러 문자열·버전 함정 위주).
3. 토픽별 배치로 나눠 검증 에이전트에 위임:
   "위키 네비게이션(라우터→샤드→파일)만으로 답이 나오는가"를 ✅/⚠️/❌ + 파일:섹션 인용으로.
4. 결과표를 이 노트에 라운드로 누적하고, 새 갭은 위 "보충 이력" 표에 이어 기록.
5. 보충은 writer(콘텐츠) → index-manager(탐색 파일) → lint/qa 순서. writer는 탐색 파일 수정 금지.
```

- 직전 질문 세트 전문은 세션 작업 파일(`scratchpad/interface_qset.md`)에 v2로 보존. 다음 라운드는 v3로 교체.

---

## 관련 노트
- [[통합 MOC]] — 통합 도메인 인덱스(방향·동기/비동기)
- [[통합 아키텍처 결정 - 미들웨어·재시도·멱등성]] — 이번 검증에서 신설된 아키텍처 결정 노트
- [[Integration User & API-Only User (통합 사용자)]] — 통합 실행 주체 설계
- [[WebServiceMock]] — 라운드1에서 신설된 SOAP 콜아웃 테스트 노트
- [[WSDL2Apex — 외부 SOAP 소비 (스텁 생성·구조·한도)]] · [[XmlStreamReader·XmlStreamWriter (스트리밍 XML)]] · [[아웃바운드 연결 - IP allowlist·Private Connect]] · [[ERP·서드파티 제품 연동 지도]] — 라운드3 신설 노트
- [[REST API]] · [[Connected App (연결된 앱) — OAuth 클라이언트]] · [[Named Credential]] · [[External Objects]] — 보충된 핵심 노트
