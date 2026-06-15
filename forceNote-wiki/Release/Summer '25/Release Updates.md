---
tags: [release, summer_25, release-update]
api_version: v64.0
release_date: 2025-06
created: 2026-06-15
source: salesforce_release_notes_5-17-2026 (3).pdf (Salesforce Summer '25 Release Notes, Tier 2)
aliases: [Summer '25 Release Updates, 서머25 릴리즈 업데이트, 릴리즈 강제 적용 항목, v64 강제 적용, 강제 시점 Enforced, API v21-30 폐기 강제, Release Update 일정]
---

# Summer '25 — Release Updates (강제 적용 항목 + 시점 매핑)

> Summer '25 (API v64.0)에서 강제 적용되었거나 향후 릴리즈에 강제 예정인 모든 Release Update를 강제 시점별로 정리한다.
> **이 노트가 Summer '25 릴리즈의 강제 시점(Enforced) 표 단일 출처(authoritative)다.** 허브 노트나 다른 spoke가 강제 시점을 인용할 때는 이 표를 기준으로 한다.

> [!warning] Release Update는 **Setup → Quick Find → "Release Updates"** 페이지에서 확인한다. 강제일(Complete Steps By) 이전에 **Test Run** 옵션으로 조직·커스터마이제이션 영향을 미리 검증하고 적용하라. 강제 시점이 지나면 자동으로 적용되며 일부는 기존 커스터마이제이션을 깨뜨릴 수 있다.

---

## 강제 시점 요약표

| 강제 시점 | 항목 수 | 성격 |
|---|---|---|
| **Summer '25 강제됨** | 5건 | 지금 즉시 영향 — 미적용 시 통합/사이트 중단 위험 |
| **Automatically Enabled (강제 아님)** | 1건 (ICU) | 자동 활성화되나 강제일까지 비활성화 가능 |
| **Winter '26 강제 예정** | 4건 | — |
| **Spring '26 강제 예정** | 6건 | — |
| **Summer '26 강제 예정** | 1건 | — |
| **취소됨** | 3건 | Release Updates 노드에서 제거됨, 강제 안 함 |

> **항목 수 주의:** Summer '26은 PDF 원문상 **1건**이다. "Requirements Defined on Built-In Apex Classes Used as Inputs"는 별개 항목이 아니라 동일 업데이트의 *이전 이름*이다(하단 Summer '26 섹션 참조). Spring '26은 "Update References to Legacy Host Names"가 Automatically Enabled 섹션에 함께 나열되지만 **강제 시점은 Spring '26**이라 6건으로 집계한다.

---

## Summer '25에 강제 적용됨 (지금 필수) — 5건

> PDF "Enforced with This Release" 섹션. 이번 릴리즈에 강제 적용된다.

| 항목 | 영향 | 조치 |
|---|---|---|
| **Enable a Modernized Record Experience in Aura Sites** | Create Record Form, Record Banner, Record Detail 컴포넌트가 Lightning Web Component 기술로 업그레이드되어 접근성·성능이 개선됨. Summer '25에 모든 조직에 강제 적용. | 업그레이드 후 사이트의 레코드 폼·배너·상세 컴포넌트 동작 확인 |
| **Enable Secure Roles Behavior and Update Sharing Group References in Sandboxes** | 디지털 익스피리언스 활성화 시 외부 사이트 사용자의 의도치 않은 접근 방지를 위해 non-preview Sandbox 조직의 레코드 접근을 보호. 기본 공유 그룹이 "Roles and Subordinates" → **"Roles and Internal Subordinates"**로 표시됨. (Spring '25에 처음 제공, Summer '25에 강제) | 구 그룹명을 참조하는 코드·커스터마이제이션을 업데이트 |
| **Review and Update Settings to Capture Leads from LinkedIn** | LinkedIn Lead Forms → Salesforce 리드 동기화 중. LinkedIn이 레거시 Ads Lead Sync API를 폐기하면 동기화가 중단됨. (Winter '25에 처음 제공·강제 예정이었으나 Summer '25로 연기) | LinkedIn 계정을 수동으로 끊고 → 신규 설정을 활성화해 기능 재구성 → 계정 재연결 |
| **Salesforce Platform API Versions 21.0 Through 30.0 Retirement** | Salesforce Platform API v21.0~30.0이 지원 종료되어 Summer '25부터 사용 불가. 해당 버전을 사용하는 애플리케이션은 중단되고, 요청이 "endpoint is deactivated" 오류로 실패. (Summer '23 예정 → Summer '25로 연기됨) | 레거시 API 버전을 사용하는 모든 애플리케이션을 현재 버전으로 업그레이드 (breaking change 발생 전) |
| **Verify SAML Integrations** | Salesforce가 정기 유지보수의 일환으로 SAML 프레임워크를 업그레이드. SSO(single sign-on)·SLO(single logout) 등 SAML 사용 통합에 영향 가능. (Winter '25에 처음 발표, Summer '25에 강제) | 서비스 중단 방지를 위해 **Summer '25 Sandbox 제공 즉시** SAML 통합을 테스트 |

> PDF 원문(API 폐기): *"These API versions are not supported and won't be available starting in Summer '25. Applications consuming them are then disrupted. Requests fail with an error message indicating that the endpoint is deactivated."*

### API v21.0–30.0 폐기 — 코드 영향 점검

레거시 API 버전을 호출하는 통합 코드는 엔드포인트 URL의 버전 세그먼트를 점검한다. 아래는 점검 대상 패턴의 **구조 예시**다.

```bash
// 구조 예시 — 실제 동작 코드 아님
# REST/SOAP/Bulk 엔드포인트의 버전 세그먼트(/vXX.0/)가 21.0~30.0 범위면 폐기 대상
# 예) /services/data/v30.0/...  → /services/data/v31.0 이상으로 교체
# Apex 콜아웃·외부 미들웨어·named credential·연결된 앱의 WSDL 버전 모두 확인
```

> Apex 콜아웃·외부 통합 코드의 구체 패턴은 [[Summer '25/Development]] 및 Apex/Integration(통합) 노트를 참고하라. (메서드 시그니처는 본 노트에서 임의 생성하지 않는다.)

---

## Summer '25 자동 활성화 (강제 아님) — ICU

> PDF "Automatically Enabled in This Release" 섹션. 이번 릴리즈에 자동 활성화되지만 강제는 아니다. 강제일까지 해당 동작을 비활성화할 수 있다.

| 항목 | 영향 | 조치 |
|---|---|---|
| **Enable ICU Locale Formats** | International Components for Unicode(ICU) 로케일 형식이 Oracle JDK 로케일 형식을 대체. 로케일은 날짜·시간·통화·주소·이름·숫자값·주 시작 요일 형식을 제어. ICU는 이들 형식의 국제 표준으로, 플랫폼 전반의 일관성과 ICU 호환 애플리케이션 연동을 개선. | 로케일 형식에 의존하는 코드·통합을 테스트. 강제일 전까지 비활성화 가능 |

> **함께 나열된 항목:** PDF의 Automatically Enabled 섹션에는 **"Update References to Legacy Host Names"** 도 함께 등장한다. 단 이 항목의 **강제 시점은 Spring '26**이므로 본 노트에서는 아래 Spring '26 섹션에 집계한다(자동 활성화 ≠ 강제).

---

## Winter '26 강제 예정 — 4건

> PDF "Scheduled to Be Enforced in Winter '26" 섹션.

| 항목 | 영향 | 준비 사항 |
|---|---|---|
| **Confirm Verified Email Addresses for Users Created in 2016 and Earlier** | 최신 이메일 보안 표준 준수를 위해 검증된 이메일 주소를 가진 사용자만 Salesforce에서 이메일 발송 가능. **2016년 11월 1일 이전 생성된 사용자 계정**에 영향. (이후 생성 계정은 이미 미검증 시 발송 불가) | 2016-11-01 이전 생성 사용자 계정의 이메일 검증 여부 확인 |
| **Enable Secure Roles Behavior and Update Sharing Group References in Production** | 디지털 익스피리언스 활성화 시 외부 사이트 사용자의 의도치 않은 접근 방지를 위해 **프로덕션** 레코드 접근을 보호. 기본 공유 그룹이 "Roles and Subordinates" → **"Roles and Internal Subordinates"**로 표시. Salesforce가 전환 기간 동안 구 참조를 동적 변환하지만, 오류 방지를 위해 모든 코드·커스터마이제이션을 업데이트해야 함. (Summer '25부터 제공 시작) | 구 그룹명을 참조하는 모든 코드·커스터마이제이션 업데이트 |
| **Restrict User Access to Run Flows** | 활성화 시 사용자의 Flow 실행 권한을 제한 — 올바른 프로파일/Permission Set이 있어야 Flow 실행 가능. **FlowSites org permission**(모든 사용자에게 모든 Flow 실행 권한 부여)이 deprecate됨. (Winter '24에 처음 제공, Winter '25 강제 예정이었으나 Winter '26으로 연기) | 사용자에게 Flow 실행 권한을 프로파일/Permission Set으로 명시 부여. 이미 활성화한 admin은 영향 없음 |
| **Update Permissions for Agentforce Service Assistant Users** | Winter '26부터 Service Assistant 접근이 **Service Planner User permission set license(PSL)**를 통해서만 제공됨. 이때 Service Assistant 권한이 Salesforce 라이선스에서 제거되어 해당 라이선스로는 기능 접근 불가. | admin은 Service Assistant PSL로 사용자에게 기능 접근 권한을 할당 |

> PDF 원문(Restrict Flows): *"When enabled, this release update deprecates the FlowSites org permission, which gave all users in the org access to run any flow."*

---

## Spring '26 강제 예정 — 6건

> PDF "Scheduled to Be Enforced in Spring '26" 섹션 (5건) + Automatically Enabled 섹션에 나열되었으나 강제 시점이 Spring '26인 "Update References to Legacy Host Names" 1건.

| 항목 | 영향 | 준비 사항 |
|---|---|---|
| **Update References to Legacy Host Names** | 레거시(non-enhanced) Salesforce 호스트명의 임시 리다이렉션이 종료될 때 고객·엔드유저 중단 방지. 이 릴리즈 업데이트로 **프로덕션·데모 조직**에서 레거시 호스트명 리다이렉션이 종료됨(다른 조직은 Winter '25에 이미 종료). (Spring '25에 처음 제공, Spring '26에 강제) | 레거시 호스트명 참조를 모두 업데이트 |
| **Enable Accessibility Enhancements for Page Headers and Modal Windows When Zoom Is Greater Than 200%** | WCAG 2.2 Resize and Reflow 가이드라인 준수를 위해 고배율(200% 초과) 보기 시 페이지 헤더·모달 창 동작을 적응시킴. WCAG 2.2 Resize/Reflow 준수 노력의 시작이며 향후 다른 UI 요소로 확대 예정. (Summer '25에 처음 제공, Spring '26에 강제) | 고배율 환경에서 페이지 헤더·모달 창 레이아웃 확인 |
| **Migrate to a Multiple-Configuration SAML Framework** | 원래의 단일 구성(single-configuration) SAML 프레임워크는 외부 IdP **하나**와의 SSO만 지원. 단일 구성 지원이 제거되고 **다중 구성(multiple-configuration)** SAML 프레임워크만 지원됨. 미적용 시 프로덕션 인스턴스 강제(Spring '26) 시점에 SSO 구성이 중단됨. | 기존 구성 보존을 위해 업데이트 단계를 따라 다중 구성 SAML로 마이그레이션 |
| **Switch to a Single Domain Certificate for Your Salesforce Content Delivery Network (CDN)** | 공유 도메인 인증서를 사용하는 CDN을 단일 도메인 인증서로 전환. 최신 보안 업데이트 준수를 위해 공유 도메인 인증서가 폐기됨. 강제 시 공유 도메인 인증서는 non-HTTPS로 갱신되어 단일 도메인 인증서보다 보안이 약함. 전환에 다운타임 없음. (Summer '24에 처음 제공, Spring '25 강제 예정이었으나 Spring '26으로 연기) | 공유 도메인 인증서를 단일 도메인 인증서로 전환 |
| **Upgrade to Enhanced LWR Sites** | 기존 LWR 사이트를 Enhanced LWR 사이트로 업그레이드해 최신 기능(부분 배포, 향상된 CMS 워크스페이스·채널, 표현식 기반 가시성 등) 활용. 현재 GA이며 지난 릴리즈 이후 일부 변경 포함. (Spring '25부터 업데이트로 제공) | 기존 LWR 사이트를 Enhanced LWR로 업그레이드 |
| **Update Instanced URLs in API Traffic** | Salesforce가 잘못된 instanced URL을 사용하는 API 트래픽 지원을 종료할 때 중단 방지 — 조직 API 트래픽이 조직의 **My Domain 로그인 URL**을 사용하도록 보장. (Summer '25부터 제공 시작) | API 트래픽이 My Domain 로그인 URL을 사용하도록 전환 |

> PDF 원문(Multiple-Config SAML): *"Otherwise, your SSO configuration stops working when this update is enforced for production instances in Spring '26."*

---

## Summer '26 강제 예정 — 1건

> PDF "Scheduled to Be Enforced in Summer '26" 섹션.

| 항목 | 영향 | 준비 사항 |
|---|---|---|
| **Enforcing No-Argument Constructor on Apex Classes Used for Invocable Action Parameters** | invocable action 파라미터로 사용 가능한 특정 표준 클래스에 접근을 허용하기 위해, 빌트인 Apex 액션에 대한 변경을 강제하며 이는 **모든 클래스의 no-argument 생성자 가시성**도 강제함. (Summer '24에 처음 제공, Winter '26 강제 예정이었으나 Summer '26으로 연기) | invocable action 파라미터로 사용되는 클래스에 가시적인 no-argument 생성자가 있는지 확인 |

> **이전 이름:** PDF 원문 — *"This release update was previously named Enforce Permission Requirements Defined on Built-In Apex Classes Used as Inputs (Release Update)."* 즉 "Requirements Defined on Built-In Apex Classes Used as Inputs"는 별개 항목이 아니라 **동일 업데이트의 구 명칭**이다. 따라서 Summer '26 강제 항목은 1건이다.

---

## 취소된 업데이트 — 3건

> PDF "Canceled Updates" 섹션. 이전 릴리즈에 발표되었으나 취소되어 Release Updates 노드에서 제거되었고 강제되지 않는다.

| 항목 | 비고 |
|---|---|
| **Migrate from Maintenance Plan Frequency Fields to Maintenance Work Rules** | 취소됨. Maintenance Plan의 **Frequency / Frequency Type** 필드가 더 이상 폐기되지 않음. 조직 필요에 따라 frequency 필드 또는 maintenance work rule을 계속 사용 가능 |
| **Update Your Trusted URLs for the Latest CSP Directives** | 취소됨. Setup의 Trusted URL and Browser Policy Violations 목록을 처리하고 Session Settings에서 "Adopt updated CSP directives"를 활성화하도록 계속 권장. 이 설정은 신규 조직에서 기본 활성화로 유지됨 |
| **Use Your Org's My Domain Login URL in API Calls** | 취소됨. **"Update Instanced URLs in API Traffic"** Release Update(위 Spring '26 강제 항목)로 대체됨 |

> **참고 — No Scheduled Enforcement Date:** PDF에는 강제 예정일이 없는 항목(예: *Disable Ref ID and Transition to New Email Threading Behavior*, *Transition to the Lightning Editor for Email Composers in Email-to-Case*)도 별도 섹션으로 존재한다. 강제 시점 매핑 대상이 아니므로 본 강제 시점 표에는 포함하지 않는다.

---

## 관련 노트

- [[Summer '25]] — Summer '25 릴리즈 노트 허브
- [[Summer '25/Development]] — Apex API v21–30 폐기·Flow 관련 개발 영향 상세
- [[Summer '25/Platform]] — SAML 프레임워크 마이그레이션·보안·CDN 인증서 등 플랫폼/보안 맥락
