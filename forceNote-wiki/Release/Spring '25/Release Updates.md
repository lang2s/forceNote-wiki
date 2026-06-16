---
tags: [release, spring_25, release-update]
api_version: v63.0
release_date: 2025-02
created: 2026-06-16
source: salesforce_spring25_release_notes.pdf (Salesforce Spring '25 Release Notes, Tier 2)
aliases: [Spring '25 Release Updates, 스프링25 릴리즈 업데이트, 릴리즈 강제 적용, v63 강제 적용, LWC Stacked Modals, API v21-30 폐기, Restrict User Access to Run Flows, Flex Prompt Template 제거]
---

# Spring '25 — Release Updates (강제 적용 항목 + 시점 매핑)

> Spring '25(API v63.0)에서 강제 적용되었거나 향후 릴리즈에 강제 예정인 모든 Release Update를 강제 시점별로 정리한다.
> **이 노트가 Spring '25 릴리즈의 강제 시점(Enforced) 표 단일 출처(authoritative)다.** 허브 [[Spring '25]] 나 다른 spoke가 강제 시점을 인용할 때는 이 표를 기준으로 한다.

> [!warning] Release Update는 **Setup → Quick Find → "Release Updates"** 페이지에서 확인한다. 강제일(Complete Steps By) 이전에 **Test Run** 옵션으로 조직·커스터마이제이션 영향을 미리 검증하고 적용하라. 강제 시점이 지나면 자동 적용되며 일부는 기존 커스터마이제이션을 깨뜨릴 수 있다.

---

## 개요

Spring '25 릴리즈 노트는 **강제일을 산문(prose)으로만 표기**하며 통합 강제 표가 없다. 본 노트의 요약표는 PDF 산문 문장에서 강제일을 **그대로 인용**해 재구성한 것이다(line ref 병기). PDF는 다음 하위 섹션으로 구분한다.

- **Enforced with This Release** (@12524) — *"These updates are scheduled to be enforced this release."*
- **Scheduled to Be Enforced in Summer '25** (@12572)
- **Scheduled to Be Enforced in Winter '26** (@12624)
- **Scheduled to Be Enforced in Spring '26** (@12659)
- **Scheduled to Be Enforced in Summer '26** (@12681)
- **Canceled Updates** (@12700)
- **Recommended But Not Enforced** (@12716)

> [!important] 두 가지 PDF 데이터 품질 이슈(작성자가 정정하지 않고 그대로 표기 + 주석)
> 1. **이중 등재(item 14 vs 20):** *Enforce Permission Requirements Defined on Built-In Apex Classes Used as Inputs*가 Winter '26 섹션(@12627)과 Summer '26 섹션(@12684)에 동시에 등장한다. Flow 상세(@43040/43092)가 **Summer '26**을 권위 있는 강제 시점으로 확정한다.
> 2. **복붙 아티팩트(items 23–25):** master "Recommended But Not Enforced" 섹션의 세 항목(@12719–12745)이 동일 본문 단락(Omni Supervisor/Raise Flag)을 공유한다. 이 본문은 item 24에만 해당하며, items 23·25의 올바른 설명은 각 상세 섹션(@46390, @46411)에 있다. 본 노트는 **상세 섹션 본문을 사용**한다.

---

## 강제 시점 요약표

> 각 강제일은 PDF 산문 그대로 인용(verbatim). number-vs-word 주의: Spring '25 노트는 **버전 숫자("v64")가 아니라 릴리즈 이름("Summer '25") 또는 달력 날짜**만 사용한다. 유일한 숫자 버전 참조는 API v21.0–30.0(폐기), API v55.0/v54(Evaluate Criteria), CLI 2.80.6/2.53.6 뿐이다.

| # | Release Update | 강제 시점 (PDF 원문 인용) | 성격 | line ref |
|---|---|---|---|---|
| 1 | Change Einstein Activity Capture Permissions for Sales Engagement Basic Users | *"In Spring '25, the Sales Engagement Basic User permission set no longer includes access..."* | **Spring '25 강제** | 12524 |
| 2 | Enable LWC Stacked Modals | *"This update was first available in Summer '24."* (Enforced with This Release) | **Spring '25 강제** (최초 Summer '24) | 12529 |
| 3 | Enable ICU Locale Formats | *"...first made available in Winter '20 and is enforced in Spring '25."* | **Spring '25 강제** (최초 Winter '20) | 12537 |
| 4 | Enforce View Roles and Role Hierarchy Permission When Editing Public List View Visibility | *"This update was first available in Spring '24."* (Enforced with This Release) | **Spring '25 강제** | 12544 |
| 5 | Enhance Flexibility and Reusability in Prompt Flows | master: *"available starting in Winter '25"*; 상세 @43137: *"Salesforce enforces this update in Spring '25."* | **Spring '25 강제** | 12550 / 43130 |
| 6 | Use an Apex-Defined Variable for All Intelligence Signal Types | *"This update first made available in Summer '24."* (Enforced with This Release) | **Spring '25 강제** | 12563 |
| 7 | Verify Your Return Email Address for Sender Verification | *"After Spring '25, to comply with increased email security standards, you're required to verify the Email Address in My Email Settings."* | **Spring '25 / After Spring '25** | 12568 |
| 8 | Enable a Modernized Record Experience in Aura Sites | *"Starting in Winter '25... In Summer '25, the upgrade is enforced for all orgs."* | **Summer '25 강제** | 12575 |
| 9 | Enable Secure Roles Behavior and Update Sharing Group References in Sandboxes | 상세 @17570: *"for these changes for production orgs in Summer '25 and enforce it in Winter '26."* | **Summer '25**(sandbox 준비) | 12581 / 17570 |
| 10 | Run the Lightning Knowledge Migration Tool | (Summer '25 섹션에 나열; 산문에 명시 강제일 없음) | **Summer '25**(섹션 배치) | 12589 |
| 11 | Salesforce Platform API Versions 21.0 Through 30.0 Retirement | *"...first scheduled for Summer '23. The retirement is now postponed to Summer '25... won't be available starting in Summer '25."* | **Summer '25 강제** (최초 Summer '23) | 12595 |
| 12 | Sort Apex Batch Action Results by Request Order | *"...first available in Summer '24 and was scheduled to be enforced in Spring '25, but we postponed the enforcement date to Summer '25."* (이후 **취소** — #21 참조) | **Summer '25 → CANCELED** | 12609 |
| 13 | Verify SAML Integrations | *"...visible starting in Winter '25 and was scheduled to be enforced in Spring '25, but we postponed the enforcement date to Summer '25."* | **Summer '25 강제** | 12615 |
| 14 | Enforce Permission Requirements Defined on Built-In Apex Classes Used as Inputs (Winter '26 등재) | *"...postponed the enforcement date to Winter '26."* (→ item 20과 모순; 권위본은 Summer '26) | **Winter '26**(이후 Summer '26으로 정정) | 12627 |
| 15 | Migrate from Maintenance Plan Frequency Fields to Maintenance Work Rules | *"...first available in Summer '22 and was scheduled to be enforced in Winter '22, but we postponed the enforcement date to Winter '26."* | **Winter '26 강제** | 12635 |
| 16 | Restrict User Access to Run Flows | *"...first made available in Winter '24 and was scheduled to be enforced in Winter '25, but we postponed the enforcement to Winter '26."* | **Winter '26 강제** | 12641 / 43191 |
| 17 | Migrate to a Multiple-Configuration SAML Framework | *"...your SSO configuration stops working when this update is enforced for production instances in Spring '26."* | **Spring '26 강제** | 12662 |
| 18 | Upgrade to Enhanced LWR Sites | *"This feature, now generally available... is available as an update starting in Spring '25."* | **Spring '26 강제** (Spring '25 제공) | 12669 |
| 19 | Update References to Legacy Host Names | master: *"available starting in Spring '25"*; 상세 @43800: *"...Salesforce enforces this update in Spring '26."* | **Spring '26 강제** (Spring '25 제공) | 12674 / 43791 |
| 20 | Enforce Permission Requirements Defined on Built-In Apex Classes Used as Inputs (Summer '26 등재) | *"...first available in Summer '24 and was scheduled to be enforced in Winter '26, but we postponed the enforcement date to Summer '26."* / 상세 @43092: *"Salesforce enforces this update in Summer '26."* | **Summer '26 강제** (권위본) | 12684 / 43085 |
| 21 | Sort Apex Batch Action Results by Request Order (CANCELED) | *"Due to potential performance concerns, Salesforce is postponing this update until further notice... no new scheduled enforcement date."* | **취소 / 강제일 없음** | 12704 / 43077 |
| 22 | Update Your Trusted URLs for the Latest CSP Directives (CANCELED) | *"This update has been canceled."* | **취소** | 12711 |
| 23 | Disable Ref ID and Transition to New Email Threading Behavior | 상세 @46394: *"...first available in Winter '21 and has no scheduled enforcement date."* | **강제일 없음 — 권고만** | 12719 / 46390 |
| 24 | Monitor Real-time Conversations Between Agentforce Service Agents and Customers | (Recommended But Not Enforced 섹션; 강제일 없음) | **강제일 없음 — 권고만** | 12725 |
| 25 | Transition to the Lightning Editor for Email Composers in Email-to-Case (GA) | 상세 @46414: *"...generally available in Lightning Experience in Spring '24 and has no scheduled enforcement date."* | **강제일 없음 — GA, 권고만** | 12739 / 46411 |
| 26 | Evaluate Criteria Based on Original Record Values in Process Builder | *"This update was scheduled to be enforced in Summer '25. Starting Spring '25, Salesforce no longer enforces this update."* | **더 이상 강제 안 함**(원래 Summer '25) | 12746 / 43168 |
| 27 | Enforce Rollbacks for Apex Action Exceptions in REST API (Flow) | 상세 @43120: *"...first made available in Spring '23 and was scheduled to be enforced in Spring '25. Salesforce is no longer enforcing this update."* | **더 이상 강제 안 함**(원래 Spring '25) | 43041 / 43106 |

---

## Spring '25에 강제 적용됨 (지금 필수)

> PDF "Enforced with This Release" 섹션(items 1–7) + Flow 상세에서 Spring '25 강제로 확정된 항목.

| 항목 | 영향 | 조치 |
|---|---|---|
| **Enable LWC Stacked Modals** | Aura → LWC 모달 마이그레이션. Dynamic Forms 지원 확대. (Summer '24 최초 제공, Spring '25 강제) | Aura 기반 모달·중첩 모달 동작을 LWC 전환 후 확인 |
| **Verify Your Return Email Address for Sender Verification** (발신자 이메일 주소 인증) | *"After Spring '25"* 부로 증가된 이메일 보안 표준 준수를 위해 **My Email Settings의 Email Address를 검증**해야 한다 | My Email Settings에서 발신 이메일 주소를 검증 |
| **Enhance Flexibility and Reusability in Prompt Flows** (Flex Prompt Template 제거) | template-triggered prompt flow에서 **flex prompt template 타입을 제거**하고 manual input으로 전환. (Winter '25 제공, 상세 @43137 Spring '25 강제) | flex prompt template를 manual input으로 마이그레이션(@43146–43166 단계) |
| **Enable ICU Locale Formats** | ICU 로케일 형식이 Oracle JDK 로케일 형식을 대체(Winter '20 최초, Spring '25 강제) | 로케일 의존 코드·통합 테스트 |
| **Change Einstein Activity Capture Permissions for Sales Engagement Basic Users** | Sales Engagement Basic User permission set에서 Einstein Activity Capture 접근 제거 | EAC가 필요한 사용자에게 별도 권한 부여 |
| **Enforce View Roles and Role Hierarchy Permission When Editing Public List View Visibility** | Public List View 가시성 편집 시 View Roles and Role Hierarchy 권한 요구(Spring '24 최초) | 해당 작업 수행자에게 권한 확인 |
| **Use an Apex-Defined Variable for All Intelligence Signal Types** | 모든 Intelligence Signal 유형에 Apex-Defined 변수 사용(Summer '24 최초) | 관련 signal 구성 점검 |

> PDF 원문(Prompt Flows, @43137): *"Salesforce enforces this update in Spring '25. To get the major release upgrade date for your instance, go to Trust Status..."*

### API v21.0–30.0 폐기 — 코드 영향 점검 (Summer '25 강제, 지금 업그레이드)

> Spring '25 노트는 이 항목을 **Summer '25 강제 예정**으로 둔다(아래 Summer '25 섹션 참조). 그러나 breaking change이므로 **Spring '25 시점에 미리 코드를 점검**해야 한다.

레거시 API 버전을 호출하는 통합 코드는 엔드포인트 URL의 버전 세그먼트를 점검한다. 아래는 점검 대상 패턴의 **구조 예시**다.

```bash
// 구조 예시 — 실제 동작 코드 아님
# REST/SOAP/Bulk 엔드포인트의 버전 세그먼트(/vXX.0/)가 21.0~30.0 범위면 폐기 대상
# 예) /services/data/v30.0/...  → /services/data/v31.0 이상으로 교체
# Apex 콜아웃·외부 미들웨어·named credential·연결된 앱의 WSDL 버전 모두 확인
# PDF: "These API versions ... won't be available starting in Summer '25."
```

> Apex 콜아웃·외부 통합 코드의 구체 패턴은 → [[Spring '25/Development]]. 메서드 시그니처는 본 노트에서 임의 생성하지 않는다.

---

## 미정 / 자발적 (강제 안 함, 권고만)

> PDF "Recommended But Not Enforced" 섹션 + Flow 상세에서 "더 이상 강제하지 않음"으로 명시된 항목. **강제일이 없으므로 미정/자발적**이다.

| 항목 | 강제 상태 (PDF 원문) | 비고 |
|---|---|---|
| **Salesforce 쿠키 first-party 사용** | 미정 (서드파티 쿠키 차단 대응) | 허브 [[Spring '25]]에 "미정"으로 표기된 항목; Spring '25 강제 표에 강제일 없음 |
| **Enforce Rollbacks for Apex Action Exceptions in REST API** | *"...scheduled to be enforced in Spring '25. Salesforce is no longer enforcing this update."* (@43120) | REST API Apex 액션 예외 시 트랜잭션 롤백. 자발적 활성화 권고 |
| **Disable Ref ID and Transition to New Email Threading Behavior** | *"...first available in Winter '21 and has no scheduled enforcement date."* (@46394) | Ref ID는 maintenance mode; 토큰 기반 threading 권고 |
| **Monitor Real-time Conversations Between Agentforce Service Agents and Customers** | (강제일 없음) | Omni Supervisor에서 라이브 메시징 모니터링 + Raise Flag 액션 |
| **Transition to the Lightning Editor for Email Composers in Email-to-Case (GA)** | *"...generally available in Lightning Experience in Spring '24 and has no scheduled enforcement date."* (@46414) | Winter '24 이후 생성 org는 기본 신규 에디터 |
| **Evaluate Criteria Based on Original Record Values in Process Builder** | *"...scheduled to be enforced in Summer '25. Starting Spring '25, Salesforce no longer enforces this update."* (@43180) | 원래 Summer '25 강제 예정이었으나 Spring '25부 강제 철회. API v55.0+ per-process 활성화 |

---

## Winter '26 강제 예정

> PDF "Scheduled to Be Enforced in Winter '26" 섹션.

| 항목 | 강제 시점 (PDF 원문) | 준비 사항 |
|---|---|---|
| **Restrict User Access to Run Flows** | *"...first made available in Winter '24 and was scheduled to be enforced in Winter '25, but we postponed the enforcement to Winter '26."* (@43192) | 사용자에게 Flow 실행 권한을 프로파일/Permission Set으로 명시 부여 |
| **Migrate from Maintenance Plan Frequency Fields to Maintenance Work Rules** | *"...scheduled to be enforced in Winter '22, but we postponed the enforcement date to Winter '26."* | Frequency 필드 → Maintenance Work Rule로 마이그레이션 |
| **Enforce Permission Requirements Defined on Built-In Apex Classes Used as Inputs** (Winter '26 등재 — item 14) | *"...postponed the enforcement date to Winter '26."* (@12633) **→ 단, Summer '26 섹션에 재등재되어 권위본은 Summer '26** | 아래 Summer '26 섹션 참조 |

> PDF 원문(Restrict Flows, @43192): *"This update was first made available in Winter '24 and was scheduled to be enforced in Winter '25, but we postponed the enforcement to Winter '26."* FlowSites org permission이 deprecate된다.

---

## Summer '26 강제 예정

> PDF "Scheduled to Be Enforced in Summer '26" 섹션(item 20). **이중 등재 항목 — 권위 있는 강제 시점은 Summer '26.**

| 항목 | 강제 시점 (PDF 원문) | 준비 사항 |
|---|---|---|
| **Enforce Permission Requirements Defined on Built-In Apex Classes Used as Inputs** | *"...first available in Summer '24 and was scheduled to be enforced in Winter '26, but we postponed the enforcement date to Summer '26."* / 상세 @43092: *"Salesforce enforces this update in Summer '26."* | Flow 내 Apex 액션에서 내장 Apex 클래스를 입력으로 쓸 때 권한 요구사항을 점검 |

> [!important] 이중 등재 주의: 동일 업데이트가 Winter '26 섹션(@12627)과 Summer '26 섹션(@12684)에 모두 나온다. Flow 상세(@43040/43092/43095)가 **Summer '26**을 권위 있는 강제 시점으로 확정한다. Winter '26 표의 항목은 전환기 중복으로 본다.

---

## Summer '25 강제 예정 (Platform API v21.0–30.0 폐기 포함)

> PDF "Scheduled to Be Enforced in Summer '25" 섹션(items 8–13).

| 항목 | 강제 시점 (PDF 원문) | 준비 사항 |
|---|---|---|
| **Salesforce Platform API Versions 21.0 Through 30.0 Retirement** | *"...first scheduled for Summer '23. The retirement is now postponed to Summer '25... won't be available starting in Summer '25."* | 레거시 API 버전 사용 애플리케이션을 현재 버전으로 업그레이드 |
| **Enable a Modernized Record Experience in Aura Sites** | *"Starting in Winter '25... In Summer '25, the upgrade is enforced for all orgs."* | Aura 사이트의 레코드 폼·배너·상세 컴포넌트 동작 확인 |
| **Verify SAML Integrations** | *"...visible starting in Winter '25 and was scheduled to be enforced in Spring '25, but we postponed the enforcement date to Summer '25."* | Summer '25 Sandbox 제공 즉시 SAML 통합 테스트 |
| **Sort Apex Batch Action Results by Request Order** | *"...scheduled to be enforced in Spring '25, but we postponed the enforcement date to Summer '25."* → 이후 *"postponing this update until further notice... no new scheduled enforcement date."* (취소) | 취소됨 — 별도 조치 불필요 |
| **Enable Secure Roles Behavior and Update Sharing Group References in Sandboxes** | 상세 @17570: *"...for production orgs in Summer '25 and enforce it in Winter '26."* | 구 공유 그룹명("Roles and Subordinates") 참조 코드 업데이트 |
| **Run the Lightning Knowledge Migration Tool** | (Summer '25 섹션 배치; 명시 강제일 없음) | Lightning Knowledge 마이그레이션 도구 실행 |

> PDF 원문(API 폐기, @12605): *"These API versions are not supported and won't be available starting in Summer '25."*

---

## Spring '26 강제 예정 (참고)

> Spring '25 노트가 Spring '26 강제로 명시한 항목(items 17–19). 상세 매핑은 → [[Spring '25/Platform]].

| 항목 | 강제 시점 (PDF 원문) |
|---|---|
| **Migrate to a Multiple-Configuration SAML Framework** | *"...your SSO configuration stops working when this update is enforced for production instances in Spring '26."* |
| **Upgrade to Enhanced LWR Sites** | *"...is available as an update starting in Spring '25."* (Spring '26 섹션 배치) |
| **Update References to Legacy Host Names** | 상세 @43800: *"In Summer '25 and in Winter '26, Salesforce automatically disables legacy host name redirections... Salesforce enforces this update in Spring '26."* |

---

## 관련 노트

- [[Spring '25]] — Spring '25 릴리즈 노트 허브
- [[Spring '25/Development]] — Apex API v21–30 폐기·Flow 관련 개발 영향 상세
- [[Spring '25/Platform]] — SAML 프레임워크·LWR 사이트·레거시 호스트명 등 플랫폼/보안 맥락
