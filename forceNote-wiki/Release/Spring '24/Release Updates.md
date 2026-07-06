---
tags: [release, spring_24, release-updates, mandatory]
source: salesforce_spring24_release_notes.pdf
created: 2026-06-16
aliases: [Spring '24 Release Updates, 스프링 24 강제 적용, Release Update 시점 맵]
---

# Spring '24 — Release Updates (강제 적용 시점 맵)

> Spring '24 릴리즈 노트에서 검증된 27개 Release Update를 **실제 강제(enforcement) 시점별**로 정리한 맵. 각 업데이트가 "지금 강제됐는지 / 언제 강제되는지 / 무엇을 해야 하는지"를 한눈에 본다.
> 허브: [[Spring '24]]

> [!warning] Release Update는 강제 시점이 되면 자동으로 켜진다. 강제 시점이 되기 **전에** Setup → Quick Find → **Release Updates** 페이지에서 각 업데이트를 점검·테스트·활성화하라. 강제 후 영향이 발견되면 롤백이 불가능하거나 어려운 경우가 많다.

---

## 시점 표기 주의 — "available" ≠ "enforced" ≠ "GA"

릴리즈 노트는 한 업데이트에 대해 여러 시점을 언급한다. 혼동을 피하기 위해 이 노트는 **강제(enforced) 시점**을 기준으로 그룹을 나눈다.

- **first available** — 업데이트가 org에서 켤 수 있게 처음 제공된 릴리즈
- **enforced** — Salesforce가 강제로 켜는(되돌릴 수 없는) 릴리즈 ← **이 노트의 그룹 기준**
- **re-enforce** — 과거에 한 번 강제됐으나 일부 org에서 설정이 의도치 않게 되돌려져 다시 강제하는 경우
- **GA** — 기능이 정식 출시(Generally Available)된 시점. 강제 시점과 다를 수 있다(예: 그룹 4의 Email-to-Case Lightning Editor)

아래 모든 제목은 릴리즈 노트 영문 verbatim이다.

---

## 그룹 1 — Spring '24에 강제됨 (Enforced in Spring '24)

| 제목 (verbatim) | 무엇을 바꾸나 | 강제 시점 | 조치 |
|---|---|---|---|
| Enable Faster Account Sharing Recalculation by Not Storing Opportunity Implicit Child Shares | opportunity의 implicit child share를 더 이상 저장하지 않고, 접근 시점에 판정한다. account sharing 재계산이 빨라진다 | **Spring '24 강제** (Winter '24 first available). Winter '24 이전부터 운영된 prod org은 Spring '24부터 순차(rolling) 적용 | Apex 테스트·코드에서 opportunity의 implicit share를 직접 조회·검증하는 부분 점검 |
| Enable ICU Locale Formats | 날짜·시간·통화·주소·이름·숫자 포맷을 JDK에서 ICU(International Components for Unicode) locale 포맷으로 전환 | **Spring '24부터 rolling 강제** (Winter '20 first available) | ICU 포맷과 비호환인 커스터마이징(하드코딩된 날짜/통화 파싱 등) 점검 |
| Enable JsonAccess Annotation Validation for the Visualforce JavaScript Remoting API | VF JavaScript Remoting API에서 namespace 간 무단 직렬화를 방지하기 위해 `@JsonAccess` 어노테이션을 검증 | **Spring '24 강제** (Winter '23 first available) | 다른 namespace로 직렬화되는 Apex 클래스에 적절한 `@JsonAccess` 적용 여부 확인 |
| Enforce RFC 7230 Validation for Apex RestResponse Headers | `RestResponse.addHeader`의 헤더 이름을 RFC 7230 규격으로 검증한다. API 버전과 무관하게 적용 | **Spring '24 강제** (Spring '23 available) | `RestResponse.addHeader(name, value)` 호출의 헤더 이름이 RFC 7230 규격(제어문자·구분자 미포함)을 만족하는지 점검 |

---

## 그룹 2 — Spring '24에 자동 활성화 (Automatically Enabled)

강제(enforced)와는 별개로, Spring '24 롤아웃 시 자동으로 켜지는 항목.

| 제목 (verbatim) | 무엇을 바꾸나 | 시점 | 조치 |
|---|---|---|---|
| MFA Auto-Enablement Concludes for All Remaining Orgs | MFA(다단계 인증) 자동 활성화 4단계 중 **마지막 단계**. 남은 모든 org에서 "Require MFA for all direct UI logins" 설정이 켜진다 | **Spring '24 롤아웃 시 발효** | 모든 직접 UI 로그인 사용자가 MFA를 등록했는지 사전 확인. SSO·예외 사용자 정책 점검 |

---

## 그룹 3 — Summer '24 강제 예정 (Enforced in Summer '24)

| 제목 (verbatim) | 무엇을 바꾸나 | 강제 시점 | 조치 |
|---|---|---|---|
| Allow Only Trusted Cross-Org Redirections | cross-org 리디렉션을 Setup의 **Trusted URLs for Redirects** allowlist에 등록된 URL로 제한 | **Summer '24 강제** (Winter '24 first available) | org 간 리디렉션 대상 URL을 Trusted URLs allowlist에 등록 |
| Enable EmailSimple Invocable Action to Respect Organization-Wide Profile Settings | `EmailSimple` invocable action이 org-wide email address profile 설정을 준수한다. 잘못된 profile 설정으로 호출 시 오류 발생 | **Summer '24 강제** (Spring '24에서 연기됨. Summer '23 first available) | Flow·Apex·REST API에서 `EmailSimple`을 호출하는 곳의 org-wide email address profile 설정 점검 |
| Migrate to a Multiple-Configuration SAML Framework | single-configuration SAML에서 multiple-configuration SAML 프레임워크로 마이그레이션 | **Summer '24 강제** (Spring '24 available) | 미적용 시 SSO가 중단되므로 강제 전에 SAML 설정을 multiple-config로 전환 |
| Pass the Conversation Intelligence Rule Name as Input to a Flow | Conversation Intelligence가 트리거하는 flow에 신규 `ruleDevName` input을 전달 | **Summer '24 강제** (Spring '24 available) | 대상 flow에서 신규 `ruleDevName` input 변수 처리 추가 |
| Run Flows in Bot User Context | bot이 시작한 flow가 **bot user의 컨텍스트**에서 실행된다 | **Summer '24 강제** (Summer '23 first available) | bot이 시작하는 flow의 권한·공유 동작이 bot user 기준으로 바뀌므로 권한 점검 |

---

## 그룹 4 — Winter '25 강제 예정 (Enforced in Winter '25)

| 제목 (verbatim) | 무엇을 바꾸나 | 강제 시점 | 조치 |
|---|---|---|---|
| Disable Access to Session IDs in Flows | flow에서 `$Api.Session_ID` 병합 필드가 실제 세션 ID로 resolve되지 않도록 차단 | **Winter '25 재강제(re-enforce)** (Winter '24에 강제됐으나 일부 org에서 설정이 되돌려져 재강제) | flow에서 `$Api.Session_ID`에 의존하는 로직 제거 |
| Enable New Order Save Behavior | order product를 추가·업데이트할 때 parent order에 custom logic(trigger·flow 등)이 실행되도록 저장 동작 변경 | **Winter '25 강제** (Winter '20 first available) | order/order product 저장 시 parent order에서 발생하는 custom logic 영향 점검 |
| Enable Partial Save for Invocable Actions | bulk REST invocable 호출에서 단일 action의 실패가 전체 요청을 롤백하지 않도록 partial save 적용 | **Winter '25 재강제(re-enforce)** (Spring '20에 강제됐다가 재강제) | partial save로 인해 일부 성공·일부 실패가 공존할 수 있으므로 호출자의 결과 처리 로직 점검 |
| Enforce Sharing Rules when Apex Launches a Flow | Apex가 launch한 autolaunched flow가 sharing rule을 강제한다. Apex가 `with sharing`이어야 flow도 sharing 적용 | **Winter '25 강제** | flow를 launch하는 Apex 클래스의 sharing 선언(`with sharing`) 점검 |
| Enforce View Roles and Role Hierarchy Permission When Editing Public List View Visibility | public list view의 가시성(공유 대상)을 편집할 때 "View Roles and Role Hierarchy" 권한을 요구 | **Winter '25 강제** (Spring '24 available) | public list view 가시성을 편집하는 사용자에게 해당 권한 부여 |
| Make Flows Respect Access Modifiers for Legacy Apex Actions | public legacy Apex action을 포함한 flow가 실패하도록 access modifier를 강제. 관리형 패키지 내부에서만 호출되도록 보호 | **Winter '25 재강제(re-enforce)** (Spring '21에 강제됐다가 재강제) | 신규 통합은 `@InvocableMethod` 사용 권장. legacy Apex action을 호출하는 flow 점검 |
| Migrate from Maintenance Plan Frequency Fields to Maintenance Work Rules | Maintenance Plan의 frequency 필드에서 Maintenance Work Rule로 마이그레이션 | **Winter '25 강제** (Winter '22에서 연기됨) | maintenance plan frequency 기반 설정을 work rule로 전환 |
| Prevent Guest User from Editing or Deleting Approval Requests | guest user가 승인 요청(approval request)을 편집·삭제하지 못하도록 차단 | **Winter '25 강제** (Summer '23 → Spring '24 → Winter '25로 2회 연기) | guest user가 승인 요청에 관여하는 흐름이 있는지 점검 |
| Restrict User Access to Run Flows | flow 실행에 올바른 profile/permission set이 필요하도록 제한. `FlowSites` org permission deprecate | **Winter '25 강제** | flow를 실행하는 사용자에게 적절한 profile·permission set 부여. `FlowSites` 의존 제거 |
| Run Flows in User Context via REST API | REST API로 실행되는 flow가 **running user의 profile·permission set** 기준으로 object/field 접근을 판정 | **Winter '25 재강제(re-enforce)** (Spring '22에 강제됐다가 재강제) | REST API로 flow를 실행하는 통합의 running user 권한 범위 점검 |
| Transition to the Lightning Editor for Email Composers in Email-to-Case (Generally Available) | Email-to-Case의 이메일 작성기가 Lightning Editor로 전환 | **Winter '25 강제** (**Spring '24 GA**) | GA 시점(Spring '24)과 강제 시점(Winter '25)이 다름에 유의. Lightning Editor 동작 사전 테스트 |
| Turn On Lightning Article Editor and Article Personalization for Knowledge | Knowledge에서 Lightning Article Editor와 Article Personalization 활성화 | **Winter '25 강제** | Knowledge article 편집 흐름이 Lightning Article Editor에서 정상 동작하는지 점검 |

---

## 그룹 5 — Spring '25 강제 예정 (Enforced in Spring '25)

| 제목 (verbatim) | 무엇을 바꾸나 | 강제 시점 | 조치 |
|---|---|---|---|
| Disable Ref ID and Transition to New Email Threading Behavior | Email-to-Case의 스레딩을 Ref ID에서 **보안 토큰 기반(Lightning) 스레딩**으로 전환. 새 outbound email에 Ref ID 미포함 | **Spring '25 강제** | merge field·custom code 교체 (아래 코드 참조) |
| Enable Secure Redirection for Flows | screen flow 완료 후 리디렉션 URL에 더 엄격한 검증 적용. trusted URL 목록에 없으면 invalid-page 오류 | **Spring '25부터 강제** (Spring '25 available) | screen flow의 리디렉션 대상 URL을 Setup의 trusted URL 목록에 등록 |
| Enforce Rollbacks for Apex Action Exceptions in REST API | REST API로 실행한 Apex action에서 예외 발생 시 트랜잭션을 롤백하여 데이터 무결성 보존 (구 이름: *Enforce Rollbacks for Custom Invocable Action Exceptions in Connect REST API*) | **Spring '25 강제** (Spring '23 first available, Winter '24 예정이었으나 Spring '25로 연기) | REST API로 호출되는 Apex action에서 예외 시 부분 커밋에 의존하던 로직 점검 |

### Disable Ref ID — merge field·메서드 교체

릴리즈 노트가 명시한 교체 대상:

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

## 그룹 6 — Summer '25 강제 예정 (Enforced in Summer '25)

| 제목 (verbatim) | 무엇을 바꾸나 | 강제 시점 | 조치 |
|---|---|---|---|
| Evaluate Criteria Based on Original Record Values in Process Builder | 다중 criteria + record update를 가진 process에서, 프로세스를 시작시킨 필드의 **원래(null) 값**을 평가하도록 버그 수정 | **Summer '25 강제** (Summer '19 first available) | 다중 criteria + record update를 쓰는 Process Builder의 평가 결과가 바뀔 수 있으므로 점검 |
| Salesforce Platform API Versions 21.0 Through 30.0 Retirement | Platform API v21.0–v30.0 retirement. 해당 endpoint 비활성화 | **Summer '25부터 endpoint deactivated** (Summer '23에서 Summer '25로 연기) | v21.0–v30.0 API를 호출하는 통합·미들웨어를 v31.0 이상으로 업그레이드 |

---

## 빠른 요약 — 강제 시점별 개수

| 강제 시점 | 개수 | 그룹 |
|---|---|---|
| Spring '24 (강제) | 4 | 그룹 1 |
| Spring '24 (자동 활성화) | 1 | 그룹 2 |
| Summer '24 | 5 | 그룹 3 |
| Winter '25 | 12 | 그룹 4 |
| Spring '25 | 3 | 그룹 5 |
| Summer '25 | 2 | 그룹 6 |
| **합계** | **27** | |

> 다수 항목이 **재강제(re-enforce)** 또는 **연기(postponed)** 이력을 가진다. "first available" 시점만 보고 "이미 적용됐다"고 가정하지 말고, 위 표의 **강제 시점**을 기준으로 점검 일정을 세운다.

---

## 관련 노트
- [[Spring '24]] — 상위 릴리즈 허브
- [[Spring '24/Development]] — 개발자 대상 변경(Apex·Flow·API 등). 다수 Release Update의 영향 영역
- [[Spring '24/Einstein]] — AI/Einstein 관련 변경. Conversation Intelligence·EmailSimple 등과 연계
- [[Email-to-Case & Web-to-Case (이메일·웹 투 케이스)]] — Disable Ref ID 스레딩 전환 RU의 대상 기능 (스레딩 동작 원리·원인 체크리스트)
