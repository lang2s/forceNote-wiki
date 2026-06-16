---
tags: [release, winter_24]
api_version: v59.0
release_date: 2023-10
created: 2026-05-17
source: salesforce_winter24_release_notes.pdf
aliases: [Winter '24, 윈터 24, v59.0, 윈터24 릴리즈 노트, 2023 겨울 릴리즈, Winter 24 허브, Winter 24 GA, Winter '24 GA 기능, API v59 GA]
---

# Winter '24 릴리즈 노트

> API v59.0 | 출시: 2023년 10월
> 공식 문서: [Release Notes](https://help.salesforce.com/s/articleView?id=release-notes.salesforce_release_notes.htm)
> 이 릴리즈는 분량이 커서 도메인별 spoke로 분리되어 있다. 아래 라우팅에서 도메인을 골라 상세로 이동한다.

---

## 하위 노트 (도메인별 라우팅)

| Spoke | 다루는 범위 |
|---|---|
| [[Winter '24/Development]] | Apex(Queueable stack depth GA·중복 enqueue 방지·DataWeave in Apex GA·Comparator/Collator·Iterable·permission-set user mode) · LWC(Toast GA·Workspace API/third-party WC Beta·apiVersion) · Visualforce · API v59.0(GraphQL mutation·Bulk API 2.0·JWT) · Packaging · DevOps Center |
| [[Winter '24/Automation]] | Salesforce Flow(Reactive Screen GA·HTTP Callout GA·Transform Beta·Custom Error Message·Data Cloud-Triggered Flow·Wait 확대·Advanced Pause→Wait for Conditions) · Flow Orchestration |
| [[Winter '24/Platform]] | Salesforce Overall(MFA 자동 활성화 3단계) · Customization(Dynamic Forms·User Access Policy Beta) · Security(Enhanced Domains 강제·Named Credentials JWT·Headless Identity·Shield·Event Monitoring) · Mobile · Hyperforce |
| [[Winter '24/Clouds]] | Sales · Service · Data Cloud · Experience Cloud · Commerce · Analytics · Revenue · Marketing · CMS · Slack (Industries는 서브 노트 [[Winter '24/Clouds-Industries]]로 분리) |
| [[Winter '24/Einstein]] | (PRE-Agentforce) Einstein Trust Layer · Prompt Builder(Pilot) · Work Summaries GA · Service Replies GA · Grounding GA · Article Answers GA · Cross-Lingual Intent Model GA · Vision/Language 은퇴 |
| [[Winter '24/Release Updates]] | Release Update 강제 적용 시점 맵 — Winter '24 강제 8건 + MFA 자동 활성화 + Spring '24~Summer '25 예정 + enforcement-date 변경 기록 |

---

## ⭐ 주요 신기능

- **Queueable 체이닝 최대 깊이 설정 (GA)** — Developer/Trial Edition 기본 한도 5를 `AsyncOptions.MaximumQueueableStackDepth`로 override. runaway recursive job 방지. → [[Winter '24/Development]]
- **DataWeave in Apex (GA)** — MuleSoft DataWeave 라이브러리를 Apex 런타임에 통합, JSON/XML/CSV 변환 스크립트를 metadata로 생성·invoke. → [[Winter '24/Development]]
- **Screen Flow Reactive Components (GA)** — 같은 화면 내 컴포넌트 간 실시간 반응(single-page app 경험). → [[Winter '24/Automation]]
- **HTTP Callout in Flow (GA)** — POST/PUT/PATCH/DELETE 지원, 코드 없이 외부 서버에 Salesforce 데이터 전송. → [[Winter '24/Automation]]
- **Code Builder (GA)** — 웹 기반 개발 환경, 로컬 다운로드 불필요(VS Code + Salesforce Extensions + CLI). → [[Winter '24/Development]]
- **Einstein Work Summaries with Generative AI (GA)** — agent-고객 Chat 대화로 case summary·issue·resolution 자동 생성. → [[Winter '24/Einstein]]
- **Hyperforce Assistant (GA)** — Hyperforce로의 마이그레이션을 돕는 어시스턴트 GA. → [[Winter '24/Platform]]
- **Outcome Management · Context Service (GA)** — Industries 핵심 두 기능이 GA. → [[Winter '24/Clouds-Industries]]

---

## ⚠️ 파괴적 / 주의 변경

> 상세·코드·이관 가이드는 각 spoke에 있음.

- **Enhanced Domains 강제 적용 (Winter '24)** — Summer '21 first available → **Winter '24 enforced.** 회사별 My Domain 이름이 모든 Salesforce URL(Experience Cloud·Sites·Visualforce 포함)에 포함된다. 미배포 시 이 릴리즈 전에 배포 권장. → [[Winter '24/Platform]] · [[Winter '24/Release Updates]]
- **MFA — 자동 활성화 3단계, 강제는 Summer '24 시작** — Winter '24는 **3번째 phase 자동 활성화**이고, **강제(enforcement)는 Summer '24에 시작**된다(Spring '24가 자동 활성화 마지막 phase). Winter '24를 강제 시점으로 오해하지 않도록 주의. → [[Winter '24/Platform]]
- **`getSalesforceBaseUrl()` 폐기** — API v59.0+에서 사용 시 컴파일 에러. `getOrgDomainUrl()`/`getCurrentRequestUrl()`로 대체. → [[Winter '24/Development]]

```apex
// 영향받는 식별자 요약 — 코드·이관 가이드는 [[Winter '24/Development]] 참조
// getSalesforceBaseUrl()  // v59.0+: deprecated, 사용 시 컴파일 에러
// 대체 (PDF 명시):
//   getOrgDomainUrl()        — org URL 조회
//   getCurrentRequestUrl()   — 전체 요청 URL 조회
```

- **Winter '24 강제 Release Update 8건** — Deploy Enhanced Domains · Disable Access to Session IDs in Flows · Faster Account Sharing Recalculation(Case/Contact) · Make Paused Flow Interviews Resume in the Same Context · Japanese Katakana Style Change · Require an Email Address to Send Chatter Email Notifications · Salesforce Object ID 3-character Server IDs · CSRF Tokens for Lightning Apps. 시점 맵 전체는 → [[Winter '24/Release Updates]]

---

## 섹션별 GA 하이라이트

- **Development** — Queueable stack depth GA(`AsyncOptions.MaximumQueueableStackDepth`)·중복 enqueue 방지·DataWeave in Apex GA·Comparator/Collator·Iterable for-loop·permission-set user mode(Dev Preview). LWC Toast GA·Workspace API/third-party WC/Custom Component Instrumentation Beta. API v59.0·GraphQL mutation·Bulk API 2.0·Code Builder GA. → [[Winter '24/Development]]
- **Automation** — Reactive Screen 컴포넌트 GA, HTTP Callout(POST/PUT/PATCH/DELETE) GA, Transform element Beta, Record-Triggered Flow Custom Error Message, Data Cloud-Triggered Flow, Wait element 확대, Flow Orchestration requirement 제어. → [[Winter '24/Automation]]
- **Platform** — Dynamic Forms on hundreds of LWC-enabled standard objects, 모바일 Dynamic Forms GA, User Access Policy Beta, Enhanced Domains 강제, Named Credentials JWT/Client Credentials, Headless Identity, Event Monitoring 신규 event type(Group Membership·Insufficient Access·Lightning Logger), Hyperforce Assistant GA. → [[Winter '24/Platform]]
- **Clouds** — Sales(Buyer Assistant GA·Revenue Intelligence·Pipeline Inspection), Service(Enhanced Omni Supervisor/Wallboard GA·Enhanced Apple Messages for Business GA·Enhanced WhatsApp), Data Cloud(Data Graphs·Snowflake OAuth·Batch Data Transform), Experience(Enhanced LWR 기본·Actions Bar/Record Detail/Dynamic Redirect GA), Analytics(Staged Data·GA4·Tableau views GA). → [[Winter '24/Clouds]] · Industries(Outcome Management·Context Service GA) → [[Winter '24/Clouds-Industries]]
- **Einstein** — (PRE-Agentforce) Work Summaries GA, Service Replies GA(grounded·email 포함), Einstein for Service Grounding GA, Article Answers for Bots GA, Cross-Lingual Intent Model GA(19개 추가 언어 beta), Prompt Builder는 Pilot, Vision/Language 2024년 5월 은퇴. → [[Winter '24/Einstein]]
- **Release Updates** — Winter '24 강제 8건 + MFA 자동 활성화 3단계 + Spring '24~Summer '25 예정 + enforcement-date 변경 기록(EmailSimple→Summer '24, Apex Action Rollback→Spring '25, ICU rolling, Cross-Org Redirection 테스트 기본 활성화). → [[Winter '24/Release Updates]]

---

## 거버너 한도 변경

| 한도 항목 | 변경 내용 |
|---|---|
| Queueable 체이닝 최대 깊이 | Developer/Trial Edition 기본 5를 `AsyncOptions.MaximumQueueableStackDepth` property로 override (GA). `System.AsyncInfo.getMaximumQueueableStackDepth()` / `getCurrentQueueableStackDepth()` / `getMinimumQueueableDelayInMinutes()` / `hasMaxStackDepth()`로 조회. enqueue는 `System.enqueueJob(queueable, asyncOptions)` overload 사용 |
| Apex Jobs list view 레코드 수 | 10,000 records 한도 강제 |
| Bulk API 2.0 — PK chunking 객체 | 4,800개 초과 객체로 확대 |
| Bulk API 2.0 — SELECT 문자 수 | 이전 32,000자 한도 제거 |
| Migrate to Flow 한도 (Essentials/Professional) | active+total flow 한도 증가 |

> Queueable 체이닝 깊이 API는 `AsyncOptions.MaximumQueueableStackDepth`와 `System.AsyncInfo` 메서드들이다. `System.maxQueueableDepth`라는 API는 존재하지 않는다. 상세 → [[Winter '24/Development]] · 일반 참조 → [[Governor Limits]] · [[Queueable]] · [[Queueable 체이닝]]

---

## 관련 노트

- [[Release MOC]]
- [[Spring '24]] — 다음 릴리즈 (v60.0)
- [[Winter '24/Development]]
- [[Winter '24/Automation]]
- [[Winter '24/Platform]]
- [[Winter '24/Clouds]]
- [[Winter '24/Clouds-Industries]]
- [[Winter '24/Einstein]]
- [[Winter '24/Release Updates]]
- [[Governor Limits]] · [[Queueable]] · [[Queueable 체이닝]]
