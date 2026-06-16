---
tags: [release, winter_24, release-updates, mandatory]
source: salesforce_winter24_release_notes.pdf
created: 2026-06-16
aliases: [Winter '24 Release Updates, 윈터 24 강제 적용, Release Update 시점 맵]
---

# Winter '24 — Release Updates (강제 적용 시점 맵)

> Winter '24 릴리즈 노트의 Release Update를 **실제 강제(enforcement) 시점별**로 정리한 맵. 각 업데이트가 "지금 강제됐는지 / 언제 강제되는지 / 무엇을 해야 하는지"를 한눈에 본다.
> 허브: [[Winter '24]]

> [!warning] Release Update는 강제 시점이 되면 자동으로 켜진다. 강제 시점 **전에** Setup → Quick Find → **Release Updates** 페이지에서 각 업데이트를 점검·테스트·활성화하라. 강제 후 영향이 발견되면 롤백이 불가능하거나 어려운 경우가 많다.

---

## 시점 표기 주의 — "available" ≠ "enforced" ≠ "auto-enabled" ≠ "GA"

- **first available** — org에서 켤 수 있게 처음 제공된 릴리즈
- **enforced** — Salesforce가 강제로 켜는(되돌릴 수 없는) 릴리즈 ← **이 노트의 그룹 기준**
- **auto-enabled** — 강제와 별개로 롤아웃 시 자동으로 켜지는 경우(예: MFA)
- **postponed** — 예정 시점이 연기된 경우
- **GA** — 기능 정식 출시 시점(강제 시점과 다를 수 있음)

아래 모든 제목은 릴리즈 노트 영문 verbatim이다.

---

## 그룹 1 — Winter '24에 강제됨 (Enforced with This Release)

| 제목 (verbatim) | 무엇을 바꾸나 | 이력 | 조치 |
|---|---|---|---|
| Deploy Enhanced Domains | 회사별 My Domain 이름을 Salesforce가 호스팅하는 URL에 포함. third-party cookie 차단 브라우저에서도 접근 가능. (원 이름: Enable Enhanced Domains) | Summer '21 first available → **Winter '24 enforced** | Experience Cloud·Sites·Visualforce URL 영향. 미배포 시 즉시 배포. → [[Winter '24/Platform]] |
| Disable Access to Session IDs in Flows | flow에서 `$Api.Session_ID`가 실제 세션 ID로 resolve되지 않도록 차단(Setup 이름: "Disable Access to Browser Session IDs in Flows") | Winter '23 → Summer '23 → **Winter '24 enforced** | flow에서 `$Api.Session_ID` 의존 로직 제거. Enterprise/Performance/Unlimited/Developer |
| Enable Faster Account Sharing Recalculation by Not Storing Case and Contact Implicit Child Shares | Case·Contact의 implicit child share를 더 이상 저장하지 않음 | Summer '23 first available → **Winter '24 enforced** | 공유 관련 커스터마이즈·테스트 점검 |
| Make Paused Flow Interviews Resume in the Same Context | paused autolaunched flow가 동일 컨텍스트에서 재개. API 57.0+는 run permission 검증 | Winter '21 → Winter '22 → Spring '23 → **Winter '24 enforced** | Process Builder→Flow 실행 흐름 점검 |
| Prepare for the Japanese Katakana Style Change | JIS 스타일을 1991 Cabinet Notification Directive 스타일로 교체 | **Winter '24 enforced** | 일본어 사용 org 검토 |
| Require an Email Address to Send Chatter Email Notifications | admin이 verified Email Address를 제공해야 함. Winter '24부터 Email Address가 비면 Chatter 이메일 미발송 | **Winter '24 enforced** | Setup → Chatter → Email Settings에서 이메일 주소 확인 |
| Salesforce Object ID Is Refined to Use Three Characters for Server IDs | 기존 2자리 Server/Instance ID(4~5번째 자)를 **3자리 Server ID(4·5·6번째 자)**로 변경. 기존 Object ID와 전체 길이(15~18자)는 불변 | Summer '23 first available → **Winter '24 enforced** | ID 구조에 의존하는 테스트 코드 수정(테스트 실패 유발 가능) |
| Security Enhancements for CSRF Tokens for Lightning Apps | Lightning 앱마다 다른 CSRF token 생성. invalid/expired token 처리 개선 | Spring '23 → Summer '23 → **Winter '24 enforced(postponed)** | Lightning 앱 테스트 실행 |

---

## 그룹 2 — Winter '24에 자동 활성화 (Automatically Enabled in This Release)

| 제목 (verbatim) | 무엇을 바꾸나 | 시점 | 조치 |
|---|---|---|---|
| MFA Auto-Enablement Continues: Find Out When and How Your Org Is Affected | Winter '24에 **3번째 phase** org에서 MFA 자동 활성화. 마지막 phase는 Spring '24 | **Winter '24 auto-enabled (3rd phase)**. 강제(enforcement)는 Summer '24 시작 | 모든 직접 UI 로그인 사용자가 MFA를 등록했는지 사전 확인 → [[Winter '24/Platform]] |

> ⚠️ Winter '24의 MFA는 **자동 활성화(3단계)**이지 강제(enforcement)가 아니다. 강제는 Summer '24에 시작된다.

---

## 그룹 3 — Spring '24 강제/자동 예정 (Scheduled for Spring '24)

| 제목 (verbatim) | 무엇을 바꾸나 | 이력 | 조치 |
|---|---|---|---|
| Enable Faster Account Sharing Recalculation by Not Storing Opportunity Implicit Child Shares | Opportunity의 implicit child share 미저장. Winter '24부터 self-enable 가능 | Winter '24 first available → **Spring '24 enforced** | 공유 관련 커스터마이즈 점검 |
| Enable ICU Locale Formats | Oracle JDK locale 포맷을 ICU locale 포맷으로 교체 | Winter '20 first available → **Spring '24부터 rolling enforcement** | 날짜·통화·숫자 포맷 비호환 커스터마이징 점검 |
| Enable JsonAccess Annotation Validation for the Visualforce JavaScript Remoting API | VF JS Remoting API에서 `JsonAccess` annotation 검증 | Winter '23, Winter '24 예정 → **Spring '24로 연기(postponed)** | 다른 namespace로 직렬화되는 Apex 클래스에 `@JsonAccess` 적용 확인 |
| Enforce RFC 7230 Validation for Apex RestResponse Headers | `RestResponse.addHeader(name, value)` 헤더 이름을 RFC 7230 기준으로 검증(API 버전 무관) | Spring '23 first available → **Spring '24 enforced** | 헤더 이름이 RFC 7230(제어문자·구분자 미포함)을 만족하는지 점검 → [[Winter '24/Development]] |
| Prevent Guest User from Editing or Deleting Approval Requests | guest user가 approval request를 편집/reassign/삭제 불가(승인·거절만 가능) | Winter '23 → Summer '23 → **Spring '24로 연기(postponed)** | guest user가 승인 요청에 관여하는 흐름 점검 |
| Turn On Lightning Article Editor and Article Personalization for Knowledge | Knowledge에서 Lightning Article Editor·Article Personalization 활성화 | **Spring '24 list** | Knowledge article 편집 흐름 점검 |
| MFA Auto-Enablement Continues (final phase) | 이전에 자동 활성화되지 않은 모든 org에서 MFA 자동 활성화 | **Spring '24 자동 활성화(final phase)** | MFA 미등록 사용자 사전 점검 |

---

## 그룹 4 — Summer '24 강제 예정 (Scheduled to Be Enforced in Summer '24)

| 제목 (verbatim) | 무엇을 바꾸나 | 이력 | 조치 |
|---|---|---|---|
| Allow Only Trusted Cross-Org Redirections | cross-org redirection을 Setup의 **Trusted URLs for Redirects** allowlist에 등록된 URL로 제한 | Winter '24 first available → **Summer '24 enforced** (Oct 2 변경: Winter '24를 October 2023 전에 받은 org는 **테스트용으로 기본 활성화**) | org 간 redirect 대상 URL을 allowlist에 등록 → [[Winter '24/Platform]] |
| Enable EmailSimple Invocable Action to Respect Organization-Wide Profile Settings | `EmailSimple` invocable action이 org-wide email address profile 설정을 준수 | Summer '23, Spring '24 예정 → **Summer '24로 연기(postponed)** (Dec 4 변경) | Flow·Apex·REST에서 `EmailSimple` 호출처의 org-wide email address profile 점검 |
| Enable New Order Save Behavior | order product 업데이트가 parent order를 변경할 때 custom application logic 실행 | **신규 RU note**. Summer '24 enforced | order/order product 저장 시 parent order의 custom logic 영향 점검 |
| Run Flows in Bot User Context | 봇이 시작한 flow가 봇의 profile/perm set으로 실행 | Summer '23 first available → **Summer '24 enforced** | 봇이 시작하는 flow의 권한·공유 동작 점검 |
| Transition to the Lightning Editor for Email Composers in Email-to-Case (Beta) | Email-to-Case의 docked·case feed composer 이메일 에디터를 Lightning Editor로 교체. **새 에디터는 Beta** | **Summer '24 enforced** | Lightning Editor 동작 사전 테스트 |

---

## 그룹 5 — Winter '25 강제 예정 (Scheduled to Be Enforced in Winter '25)

| 제목 (verbatim) | 무엇을 바꾸나 | 이력 | 조치 |
|---|---|---|---|
| Migrate from Maintenance Plan Frequency Fields to Maintenance Work Rules | Maintenance Plan의 Frequency·Frequency Type 필드 은퇴 | Summer '22 → Winter '22 → **Winter '25로 연기(postponed)** | maintenance plan frequency 설정을 work rule로 전환 |
| Restrict User Access to Run Flows | flow 실행에 올바른 profile/perm set 필요. `FlowSites` license deprecate | **Winter '25 enforced** | flow 실행 사용자에 적절한 profile·perm set 부여. `FlowSites` 의존 제거 |

---

## 그룹 6 — Spring '25 강제 예정 (Scheduled to Be Enforced in Spring '25)

| 제목 (verbatim) | 무엇을 바꾸나 | 이력 | 조치 |
|---|---|---|---|
| Enforce Rollbacks for Apex Action Exceptions in REST API | REST API로 실행한 Apex action에서 예외 시 트랜잭션 롤백(구 이름: Enforce Rollbacks for Custom Invocable Action Exceptions in Connect REST API) | Spring '23 first available, Spring '24 예정 → **Spring '25로 연기(postponed)** (Oct 16 변경) | REST API로 호출되는 Apex action의 부분 커밋 의존 로직 점검 → [[Winter '24/Development]] |

---

## 그룹 7 — Summer '25 강제 예정 (Scheduled to Be Enforced in Summer '25)

| 제목 (verbatim) | 무엇을 바꾸나 | 이력 | 조치 |
|---|---|---|---|
| Evaluate Criteria Based on Original Record Values in Process Builder | 다중 criteria + record update process에서 시작 필드의 원래(null) 값을 평가하도록 버그 수정 | Summer '19 first available → **Summer '25 enforced** | 해당 Process Builder의 평가 결과 변경 점검 |
| Salesforce Platform API Versions 21.0 Through 30.0 Retirement | Platform API v21.0~30.0 retirement. endpoint 비활성화 | Summer '23 예정 → **Summer '25로 연기(postponed)** | v21.0~30.0 호출 통합을 v31.0 이상으로 업그레이드. 요청이 "endpoint is deactivated"로 실패 |

---

## "Release Note Changes" — 강제 시점 변경 기록 (verbatim 시점 델타)

> 아래는 릴리즈 노트의 "Release Note Changes" 섹션이 기록한 강제(enforcement) 일정 **변경**이다. 잘못된 값은 오정보이므로 정확히 기록한다.

| 항목 | 변경 내용 (verbatim 날짜) |
|---|---|
| Enable EmailSimple Invocable Action to Respect Organization-Wide Profile Settings | Dec 4, 2023: 강제 시점을 **Spring '24 → Summer '24**로 변경 |
| Enforce Rollbacks for Apex Action Exceptions in REST API | Oct 16, 2023: 강제 시점을 **Spring '24 → Spring '25**로 변경 |
| Allow Only Trusted Cross-Org Redirections | Oct 2, 2023: Winter '24를 October 2023 전에 받은 org에서 **테스트용으로 기본 활성화** |
| Enable ICU Locale Formats | Nov 13, 2023: **Spring '24부터 rolling enforcement 일정** 포함하도록 갱신 |
| Streaming API Versions 23.0 Through 36.0 Are Being Retired | Sep 25, 2023: retirement plan 추가 |
| (Sandbox) Select Who Has Access To a Sandbox | Nov 20 / Jan 1, 2024: **Winter '24 릴리즈 연기(delayed)** |

> ⚠️ **Winter '24에서 빠진 항목(아래는 Winter '24 신기능이 아니다):**
> - **Select Who Has Access To a Sandbox** (Selective Sandbox Access) — Winter '24 릴리즈가 연기됨.
> - **Tooling API의 `ActivationUserGroupId` 필드**(SandboxInfo/SandboxProcess) — 함께 지연됨.

---

## 거버너 / 한도 변경

- **Queueable 체이닝 stack depth (정정)** — Developer/Trial Edition org의 기본 한도 **5**를 `AsyncOptions.MaximumQueueableStackDepth`(GA)로 override할 수 있다. governor-aware 테스트를 사용한다. (전체 API는 [[Winter '24/Development]].) **`System.maxQueueableDepth`라는 API는 존재하지 않는다** — 실제 API는 `AsyncOptions.MaximumQueueableStackDepth` + `System.AsyncInfo.getMaximumQueueableStackDepth()` / `getCurrentQueueableStackDepth()` / `getMinimumQueueableDelayInMinutes()` / `hasMaxStackDepth()` + `System.enqueueJob(queueable, asyncOptions)` overload다.
- **API 버전 은퇴:** SOAP/REST/Bulk API v21.0~30.0 retirement → **Summer '25**(Summer '23에서 연기). Streaming API v23.0~36.0 은퇴 예정. API 58.0 이하 LWC 컴포넌트는 v58.0으로 매핑.
- Apex Jobs list view는 10,000 records로 제한.

```text
// 구조 예시 — 실제 PDF 다이어그램 아님
// "available" → "enforced" 생명주기 (Enhanced Domains 예)
Summer '21  first available  ──► (org에서 켤 수 있음)
   …                              (점검·테스트·배포 기간)
Winter '24  ENFORCED          ──► (강제로 켜짐 — 되돌리기 어려움)
```

> 위 타임라인은 first available과 enforced의 차이를 설명하기 위한 구조 예시다. PDF의 실제 다이어그램이 아니다.

---

## 빠른 요약 — 강제 시점별

| 강제/자동 시점 | 그룹 |
|---|---|
| Winter '24 (강제) | 그룹 1 (8건) |
| Winter '24 (자동 활성화) | 그룹 2 (MFA 3rd phase) |
| Spring '24 | 그룹 3 |
| Summer '24 | 그룹 4 |
| Winter '25 | 그룹 5 |
| Spring '25 | 그룹 6 |
| Summer '25 | 그룹 7 |

> 다수 항목이 **연기(postponed)** 이력을 가진다. "first available" 시점만 보고 "이미 적용됐다"고 가정하지 말고, 위 표의 **강제 시점**을 기준으로 점검 일정을 세운다.

---

## 관련 노트

- [[Winter '24]] — 상위 릴리즈 허브
- [[Winter '24/Development]] — RFC 7230·Apex Action Rollback·API 은퇴 등 개발자 대상 Release Update의 영향 영역
- [[Winter '24/Automation]] — Flow·Process 컨텍스트 Release Update(Session IDs·Paused Flow·EmailSimple·Bot Context 등)
- [[Winter '24/Platform]] — Enhanced Domains·CSRF·MFA·Cross-Org Redirection
- [[Spring '24/Release Updates]] — 다음 릴리즈의 강제 시점 맵
- [[Release MOC]]
