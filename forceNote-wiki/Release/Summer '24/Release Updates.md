---
tags: [release, summer_24, release-updates, mandatory]
source: salesforce_summer24_release_notes.pdf
created: 2026-06-16
aliases: [Summer '24 Release Updates, 서머 24 강제 적용, Release Update 시점 맵]
---

# Summer '24 — Release Updates (강제 적용 시점 맵)

> Summer '24 릴리즈 노트에서 검증된 31개 Release Update를 **실제 강제(enforcement) 시점별**로 정리한 맵. 각 업데이트가 "지금 강제됐는지 / 언제 강제되는지 / 무엇을 해야 하는지"를 한눈에 본다.
> 허브: [[Summer '24]]

> [!warning] Release Update는 강제 시점에 자동 ON. 강제 전 Setup → Release Updates에서 점검·테스트·활성화.

---

## 시점 표기 주의 — "available" ≠ "enforced" ≠ "GA"

릴리즈 노트는 한 업데이트에 대해 여러 시점을 언급한다. 혼동을 피하기 위해 이 노트는 **강제(enforced) 시점**을 기준으로 그룹을 나눈다.

- **first available** — 업데이트가 org에서 켤 수 있게 처음 제공된 릴리즈
- **enforced** — Salesforce가 강제로 켜는(되돌릴 수 없는) 릴리즈 ← **이 노트의 그룹 기준**
- **re-enforce** — 과거에 한 번 강제됐으나 일부 org에서 설정이 의도치 않게 되돌려져 다시 강제하는 경우
- **GA** — 기능이 정식 출시(Generally Available)된 시점. 강제 시점과 다를 수 있다(예: 그룹 3의 Email-to-Case Lightning Editor)

아래 모든 제목은 릴리즈 노트 영문 verbatim이며, PDF의 `(Release Update)` 접미사를 그대로 유지한다.

---

## 그룹 1 — Summer '24에 강제됨 (Enforced in Summer '24)

p.120. 단, 이 그룹 헤더 아래에 묶여 있어도 **모든 항목이 "Summer '24 강제"인 것은 아니다.** ICU와 Label Object는 시점이 다르므로 When 셀의 verbatim 문구를 그대로 따른다.

| 항목 (verbatim) | 에디션 / Where | When (available vs enforced 구분) | 조치 |
|---|---|---|---|
| Allow Only Trusted Cross-Org Redirections (Release Update) | All editions | **first available in Winter '24**; "Salesforce enforces this update in Summer '24." (Security p.764). Winter '24를 2023-10 이전에 받은 org은 **기본 활성화(enabled by default)** | 일부 org은 자동 — org 간 리디렉션 대상을 Trusted URLs allowlist에 등록 점검 |
| Enable EmailSimple Invocable Action to Respect Organization-Wide Profile Settings (Release Update) | Essentials / Pro / Ent / Perf / Unl / Dev | **first made available in Summer '23**, scheduled for Spring '24, **postponed to Summer '24**; "enforces in Summer '24." (Flow p.726) | `EmailSimple`을 호출하는 Flow·Apex·REST의 org-wide email address profile 설정 점검 |
| Enable ICU Locale Formats (Release Update) | All except Database.com | ⚠️ **Summer '24 단일 강제 아님.** "enforced on a **rolling basis starting in Spring '24**"; **Spring '25까지 연기(deferrable) 가능** (Customization p.194) | ICU 포맷과 비호환인 커스터마이징(하드코딩된 날짜/통화 파싱 등) 점검. 연기 옵션 검토 |
| Grant Access to the Label Object In Custom Profiles To Continue Using To Do List Labels (Release Update) | Ent / Pro / Unl w/ Sales Cloud | ⚠️ **강제 시점 명시 없음.** "listed in Summer '24 group; no explicit enforcement date stated." (어디에도 "When"·"enforce" 문구 없음) | To Do List label을 계속 쓰려면 custom profile에 Label object 접근 부여 |

---

## 그룹 2 — Winter '25 강제 예정 (Enforced in Winter '25)

p.120–122.

| 항목 (verbatim) | 에디션 / Where | When (available vs enforced 구분) | 조치 |
|---|---|---|---|
| Create and Verify Your Default No-Reply Organization-Wide Email Address to Send Email (Release Update) | — | **After Winter '25** ("enforce" 동사 없음; Winter '25 그룹에 분류됨) | 기본 No-Reply org-wide email address를 생성·검증 |
| Disable Access to Session IDs in Flows (Release Update) | Ent / Perf / Unl / Dev | **previously enforced in Winter '24**; **re-enforce in Winter '25** (Flow p.730) | 재강제 — flow에서 세션 ID에 의존하는 로직 제거 |
| Enable Partial Save for Invocable Actions (Release Update) | — | **previously enforced Spring '20**; **re-enforce in Winter '25** (Flow p.731) | 재강제 — bulk invocable 호출의 부분 성공/실패 처리 로직 점검 |
| Enforce Sharing Rules when Apex Launches a Flow (Release Update) | — | **available Spring '24**; **enforces in Winter '25** (Flow p.727) | flow를 launch하는 Apex 클래스의 sharing 선언(`with sharing`) 점검 |
| Make Flows Respect Access Modifiers for Legacy Apex Actions (Release Update) | — | **previously enforced Spring '21**; **re-enforce in Winter '25** (Flow p.730) | 재강제 — legacy Apex action을 호출하는 flow 점검 |
| Migrate from Maintenance Plan Frequency Fields to Maintenance Work Rules (Release Update) | — | **first available Summer '22**, scheduled Winter '22, **postponed to Winter '25** | maintenance plan frequency 기반 설정을 work rule로 전환 |
| Pass the Conversation Intelligence Rule Name as Input to a Flow (Release Update) | Ent / Unl w/ Service Cloud Voice | **available Spring '24**; **enforces in Winter '25** (Service p.819) | 대상 flow에서 신규 rule name input 변수 처리 추가 |
| Prevent Guest User from Editing or Deleting Approval Requests (Release Update) | — | **first available Winter '23**, postponed Summer '23 → Spring '24 → Winter '25; **enforces in Winter '25** (Flow p.728) | guest user가 승인 요청(approval request)에 관여하는 흐름 점검 |
| Restrict User Access to Run Flows (Release Update) | — | **available Winter '24**; **enforces in Winter '25** (Flow p.728). `FlowSites` org permission deprecate | flow 실행 사용자에게 적절한 profile·permission set 부여. `FlowSites` 의존 제거 |
| Run Flows in User Context via REST API (Release Update) | — | **previously enforced Spring '22**; **re-enforce in Winter '25** (Flow p.729) | 재강제 — REST API로 flow를 실행하는 통합의 running user 권한 범위 점검 |
| Turn On Lightning Article Editor and Article Personalization for Knowledge (Release Update) | — | **enforces in Winter '25** (Service/Knowledge p.825) | Knowledge article 편집 흐름이 Lightning Article Editor에서 정상 동작하는지 점검 |
| Use REST API for Access to External Client App OAuth Consumer Credentials (Release Update) | — | **enforces in Winter '25** (Security p.746) | External Client App OAuth consumer credential을 REST API 경유로 접근하도록 통합 전환 |
| Run Flows in Bot User Context (Release Update) | Einstein Bots | **first available Summer '23**; **enforces in Winter '25** (Einstein Bots p.318) | bot이 시작하는 flow의 권한·공유 동작이 bot user 기준으로 바뀌므로 권한 점검 |

---

## 그룹 3 — Spring '25 강제 예정 (Enforced in Spring '25)

p.122–123.

| 항목 (verbatim) | 에디션 / Where | When (available vs enforced 구분) | 조치 |
|---|---|---|---|
| Adopt Updated Content Security Policy (CSP) Directives (Release Update) | — | **available Summer '24**, scheduled Winter '25, **postponed until Spring '25**; **Summer '24 이후 생성된 org은 기본 활성화(enabled by default)** (Security p.765) | Summer '24+ org은 자동 — 그 외엔 갱신된 CSP directive와 호환되는지 점검 |
| Disable Ref ID and Transition to New Email Threading Behavior (Release Update) | — | **first available Winter '21**; **enforces in Spring '25** (Service p.788) | Ref ID 기반 스레딩 의존 merge field·custom code 교체 |
| Enable LWC Stacked Modals (Release Update) | — | **available Summer '24**, **will be enforced in Spring '25** | LWC stacked modal 동작과의 호환성 사전 테스트 |
| Enable New Order Save Behavior (Release Update) | — | **first available Winter '20**, **enforced in Spring '25** (Sales/Order p.689). (참고: OmniStudio default-on은 Winter '25부터 시작되는 별개 사안) | order/order product 저장 시 parent order에서 발생하는 custom logic 영향 점검 |
| Enable Secure Redirection for Flows (Release Update) | — | **available Spring '25**; **enforces starting in Spring '25** (Flow p.728) | screen flow의 리디렉션 대상 URL을 trusted URL 목록에 등록 |
| Enforce Permission Requirements Defined on Built-In Apex Classes Used as Inputs (Release Update) | — | **enforces in Spring '25** (Flow Orchestration p.732) | built-in Apex 클래스를 input으로 쓰는 orchestration의 권한 요건 점검 |
| Enforce Rollbacks for Apex Action Exceptions in REST API (Release Update) | — | 구 이름 *Enforce Rollbacks for Custom Invocable Action Exceptions in Connect REST API*; **first available Spring '23**, **postponed to Spring '25**; **enforces in Spring '25** (Flow p.728) | REST API로 호출되는 Apex action에서 예외 시 부분 커밋에 의존하던 로직 점검 |
| Enforce View Roles and Role Hierarchy Permission When Editing Public List View Visibility (Release Update) | — | **first available Spring '24**, scheduled Winter '25, **postponed to Spring '25**; **enforces in Spring '25** (Customization p.198) | public list view 가시성을 편집하는 사용자에게 해당 권한 부여 |
| Sort Apex Batch Action Results by Request Order (Release Update) | — | **enforces in Spring '25** (Flow Orchestration p.732) | batch Apex action 결과를 request 순서로 처리하는 로직 점검 |
| Transition to the Lightning Editor for Email Composers in Email-to-Case (Generally Available) (Release Update) | — | **generally available in Lightning Experience in Spring '24**; **enforces in Spring '25** (Service p.787) | GA(Spring '24)와 강제(Spring '25)가 다름에 유의. Lightning Editor 동작 사전 테스트 |
| Use an Apex-Defined Variable for All Intelligence Signal Types (Release Update) | — | **available Summer '24**; **enforces in Spring '25** (Service p.818) | 모든 intelligence signal type을 Apex-defined variable로 처리하도록 전환 |
| Migrate to a Multiple-Configuration SAML Framework (Release Update) | — | ⚠️ **분할 시점.** "enforced for **production instances in Spring '25** and enforced for **sandboxes in Summer '24**." (Security p.745) | 미적용 시 SSO 중단 — sandbox는 Summer '24 전, production은 Spring '25 전에 multiple-config로 전환 |

### Disable Ref ID — merge field·메서드 교체

위 표의 *Disable Ref ID and Transition to New Email Threading Behavior*(Spring '25 강제)가 명시한 교체 대상:

```apex
// 구조 예시 — 실제 동작 코드 아님

// 1) 이메일 템플릿의 merge field 교체
//    Case.Thread_Id  →  Case.Thread_Token

// 2) custom Apex 코드의 메서드 교체
//    Cases.getCaseIdFromEmailThreadId(...)
//      ↓ 아래 중 하나(또는 조합)로 교체
//    Cases.getCaseIdFromEmailHeaders(...)
//    EmailMessages.getRecordIdFromEmail(...)
```

> Lightning 스레딩 활성화 후에는 이메일 헤더 기반으로 case에 스레딩된다. Ref ID로 되돌리면 이전에 생성된 case에 스레딩되지 않아 새 case가 중복 생성될 수 있다.

---

## 그룹 4 — Summer '25 강제 예정 (Enforced in Summer '25)

p.123.

| 항목 (verbatim) | 에디션 / Where | When (available vs enforced 구분) | 조치 |
|---|---|---|---|
| Evaluate Criteria Based on Original Record Values in Process Builder (Release Update) | — | **first available Summer '19**; **enforces in Summer '25** (Flow p.729) | 다중 criteria + record update를 쓰는 Process Builder의 평가 결과가 바뀔 수 있으므로 점검 |
| Salesforce Platform API Versions 21.0 Through 30.0 Retirement (Release Update) | Pro (w/ API) / Ent / Perf / Unl / Dev + sandbox/scratch | **first scheduled Summer '23**, **postponed to Summer '25**; **won't be available starting Summer '25** | Bulk/SOAP/REST v21.0–30.0 + 모든 `/services/data/vXX.X` REST(Connect·Metadata·Tooling 등) 호출을 상위 버전으로 업그레이드 |

---

## 비-RU 은퇴/폐기 일정 (Release Update 아님)

아래 항목은 릴리즈 노트가 **Release Update로 태그하지 않은** 은퇴/폐기 일정이다. Setup → Release Updates 페이지에 나타나지 않으므로 별도로 추적한다. (Platform API v21–30 retirement는 RU로 태그되어 위 그룹 4에 포함됨 — 혼동 주의)

| 항목 | When (verbatim) | 출처 |
|---|---|---|
| Salesforce Functions Is Being Retired | "retiring on **January 31, 2025**." | Dev p.296 |
| Standard-Volume Platform Events Are Being Retired | "scheduled for retirement in **Summer '25**." | Dev / Platform Events |
| Streaming API Versions 23.0 Through 36.0 Are Being Retired | "scheduled for retirement in **Winter '25**; **upgrade to ≥ v37.0** = Durable Streaming." | Dev / Platform Events |

---

## 빠른 요약 — 강제 시점별 개수

| 강제 시점 | 개수 | 그룹 |
|---|---|---|
| Summer '24 | 4 | 그룹 1 |
| Winter '25 | 13 | 그룹 2 |
| Spring '25 | 12 | 그룹 3 |
| Summer '25 | 2 | 그룹 4 |
| **합계** | **31** | |

> 그룹 1의 ICU(rolling Spring '24 시작 + Spring '25 연기 가능)·Label Object(강제 시점 명시 없음), 그룹 3의 SAML(sandbox Summer '24 / production Spring '25 분할)은 헤더의 단일 시점으로 가정하지 말고 위 표의 When 셀을 그대로 따른다. 다수 항목이 **재강제(re-enforce)** 또는 **연기(postponed)** 이력을 가지므로 "first available" 시점만 보고 "이미 적용됐다"고 가정하지 않는다.

---

## 관련 노트
- [[Summer '24]] — 상위 릴리즈 허브
- [[Summer '24/Automation]] — Flow·Flow Orchestration 변경. 다수 Release Update(Flow 관련)의 영향 영역
- [[Summer '24/Development]] — 개발자 대상 변경(Apex·LWC·API 등)
- [[Summer '24/Platform]] — 플랫폼·보안·설정 변경
- [[Summer '24/Clouds]] — 클라우드별 변경. Order Save·Email-to-Case Lightning Editor·Disable Ref ID·Intelligence Signal·Knowledge 등 Sales/Service RU의 기능 맥락
- [[Release MOC]] — 릴리즈 섹션 목차
