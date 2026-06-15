---
tags: [release, winter_26, release-updates, security, deprecation]
api_version: v65.0
release_date: 2025-10
created: 2026-06-15
source: salesforce_release_notes_5-17-2026 (2).pdf (Salesforce Winter '26 Release Notes, Tier 2)
aliases: [Winter '26 Release Updates, 윈터26 강제적용, Secure Roles Behavior, Restrict User Access to Run Flows, SOAP API login 은퇴, ICU Locale Formats, Multiple-Configuration SAML]
---

# Winter '26 — Release Updates (강제 적용 항목 · 시점 맵)

> Winter '26 강제 적용 4건 + 자동 활성화 + Spring '26/Summer '26/Summer '27 강제 예정 + 강제 시점 미정 항목까지, Setup → Release Updates 페이지 항목 전수와 시점 맵.
> **이 노트가 Winter '26 릴리즈의 강제 시점(Enforced) 표 단일 출처(authoritative)다.** 허브 노트나 다른 spoke가 강제 시점을 인용할 때는 이 표를 기준으로 한다.

> [!warning] Release Update는 **Setup → Quick Find → "Release Updates"** 페이지에서 확인한다. 강제일(Complete Steps By) 이전에 **Test Run** 옵션으로 조직·커스터마이제이션 영향을 미리 검증하고 적용하라. 강제 시점이 지나면 자동으로 적용되며 일부는 기존 커스터마이제이션을 깨뜨릴 수 있다.

```text
// 구조 예시 — 실제 동작 코드 아님 (Setup 탐색 경로)
Setup → Quick Find: "Release Updates"
  → 항목 선택 → [Get Started] 탭에서 영향·조치 확인
  → [Test Run] 으로 강제 전 영향 검증
  → "Complete Steps By" (강제일) 이전에 조치 완료
```

---

## 라우팅

- **상위 허브:** [[Winter '26]] — Winter '26 (v65.0, 2025-10) 릴리즈 노트 전체 진입점
- **형제 스포크:** [[Winter '26/Development]] · [[Winter '26/Platform]] · [[Winter '26/Clouds]] · [[Winter '26/Agentforce]]

> 5개 형제 스포크([[Winter '26/Development]] · [[Winter '26/Platform]] · [[Winter '26/Clouds]] · [[Winter '26/Agentforce]])가 모두 작성 완료되었다.

---

## 강제 시점 요약표

| 강제 시점 | 항목 수 | 성격 |
|---|---|---|
| **Winter '26 강제됨** | 4건 | 지금 즉시 영향 — 미적용 시 이메일 발송·사이트 접근·Flow 실행·Agentforce 접근 중단 위험 |
| **Automatically Enabled (강제 아님)** | 1건 (Legacy Host Names) | 자동 활성화되나 강제 시점은 Spring '26 |
| **Spring '26 강제 예정** | 3건 | — |
| **Summer '26 강제 예정** | 5건 | — |
| **Summer '27 강제 예정** | 1건 (SOAP API login()) | — |
| **No Scheduled Enforcement Date (강제 시점 미정)** | 3건 | 강제일 없음 — 활성화·전환 권장이나 강제 안 됨 |

> **그룹 6 (강제 시점 미정) 주의:** ICU Locale Formats · Single Domain Certificate(CDN) · NBA Widget Refresh 세 항목은 현재 강제 예정일이 없다. 특히 **Switch to a Single Domain Certificate**는 Spring '26 강제 예정에서 무기한 연기(postponed indefinitely)된 항목이다 — Summer '25 노트에서 Spring '26 집계되던 것과 달리 이번 릴리즈에는 미정 그룹으로 이동했다.

---

## 그룹 1 — Winter '26에 강제 적용됨 (지금 필수) — 4건

> PDF "Enforced with This Release" 섹션. 이번 릴리즈에 강제 적용된다.

| 항목 (PDF 정식 제목) | 영향 | 조치 | 강제 시점 |
|---|---|---|---|
| **Confirm Verified Email Addresses for Users Created in 2016 and Earlier (Release Update)** | 최신 이메일 보안 표준 준수를 위해 검증된(verified) 이메일 주소를 가진 사용자만 Salesforce에서 이메일 발송 가능. **2016년 11월 1일 이전(on or before)에 생성된 사용자 계정**에 영향. | 2016-11-01 이전 생성 사용자 계정의 이메일을 검증(verify) | Winter '26 |
| **Enable Secure Roles Behavior and Update Sharing Group References in Production (Release Update)** | 디지털 익스피리언스 활성화 시 외부 사이트 사용자의 의도치 않은 레코드 접근 방지를 위해 **프로덕션** 레코드 접근을 보호. 기본 공유 그룹이 "Roles and Subordinates" → **"Roles and Internal Subordinates"**로 표시. (Summer '25에 처음 제공, Winter '26에 강제) | 구 그룹명을 참조하는 모든 코드·커스터마이제이션 업데이트 | Winter '26 (first available Summer '25) |
| **Restrict User Access to Run Flows (Release Update)** | 활성화 시 사용자의 Flow 실행 권한을 제한 — 올바른 프로파일/Permission Set이 부여된 사용자만 Flow 실행 가능. **FlowSites org permission**이 deprecate됨. (Winter '24에 처음 제공, Winter '25 강제 예정 → Winter '26으로 연기) | 사용자에게 Flow 실행 권한을 프로파일/Permission Set으로 명시 부여 | Winter '26 (first available Winter '24) |
| **Update Licenses for Agentforce Service Assistant Users (Release Update)** | Winter '26부터 Service Assistant 접근이 **Service Planner User permission set license**를 통해서만 제공됨. | admin은 Service Assistant permission set license로 사용자에게 기능 접근 권한을 할당 | Winter '26 (starting Winter '26) |

> PDF 원문(Restrict Flows): *"When enabled, this release update restricts which users can run flows so that only users with the correct profile or permission set can run them."*

> 표기 정정: PDF 원문의 오타("Service Assistnat permssion")는 정상 표기("Service Assistant permission set license")로 옮겨 적었다.

---

## 그룹 2 — Automatically Enabled in This Release (자동 활성화, 강제 시점 Spring '26) — 1건

> PDF "Automatically Enabled in This Release" 섹션. 이번 릴리즈에 자동 활성화되지만 강제는 아니다. 강제 시점은 Spring '26이다.

| 항목 (PDF 정식 제목) | 영향 | 조치 | 강제 시점 |
|---|---|---|---|
| **Update References to Legacy Host Names (Release Update)** | 레거시(non-enhanced) Salesforce 호스트명의 임시 리다이렉션이 종료될 때 중단 방지. 이 릴리즈 업데이트로 **프로덕션·데모 조직**에서 레거시 호스트명 리다이렉션이 종료됨(다른 조직은 Winter '25에 이미 종료). (Spring '25에 처음 제공, Winter '26에 자동 활성화, Spring '26에 강제) | 레거시 호스트명 참조를 모두 업데이트 | Spring '26 (auto-enabled Winter '26) |

---

## 그룹 3 — Scheduled to Be Enforced in Spring '26 — 3건

> PDF "Scheduled to Be Enforced in Spring '26" 섹션.

| 항목 (PDF 정식 제목) | 영향 | 준비 사항 | 강제 시점 |
|---|---|---|---|
| **Calculate Tax-Only and Product-Only Price Adjustments (Release Update)** | 주문 처리 중 tax rate 계산에 tax-only 및 product-only price adjustment를 반영. | 주문 처리·세금 계산에 의존하는 구성에서 tax-only·product-only adjustment 반영 결과 확인 | Spring '26 |
| **Escape the Label Attribute of `<apex:inputField>` Elements to Prevent Cross-Site Scripting in Visualforce Pages (Release Update)** | Cross-Site Scripting(XSS) 방지를 위해 `<apex:inputField>` 요소의 **label attribute**를 escape 처리. (Winter '23에 처음 제공) | `<apex:inputField>`의 label에 의존하는 Visualforce 페이지 렌더링·동작 확인 | Spring '26 (first available Winter '23) |
| **Migrate to a Multiple-Configuration SAML Framework (Release Update)** | 원래의 단일 구성(single-configuration) SAML 프레임워크는 외부 IdP **하나**와의 SSO만 지원. 단일 구성 지원이 제거되고 **다중 구성(multiple-configuration)** SAML 프레임워크만 지원됨. 기존 구성을 보존하지 않으면 Spring '26 강제 시점에 SSO가 중단됨. | 기존 구성 보존을 위해 업데이트 단계를 따라 다중 구성 SAML로 마이그레이션 | Spring '26 |

> PDF 원문(Multiple-Config SAML): *"Otherwise, your SSO configuration stops working when this update is enforced in Spring '26."*

---

## 그룹 4 — Scheduled to Be Enforced in Summer '26 — 5건

> PDF "Scheduled to Be Enforced in Summer '26" 섹션.

| 항목 (PDF 정식 제목) | 영향 | 준비 사항 | 강제 시점 |
|---|---|---|---|
| **Enable Accessibility Enhancements for Page Headers and Modal Windows When Zoom Is Greater Than 200% (Release Update)** | WCAG 2.2 Resize and Reflow 가이드라인 준수를 위해 고배율(200% 초과) 보기 시 페이지 헤더·모달 창 동작을 적응시킴. (Summer '25에 처음 제공, Spring '26 강제 예정 → Summer '26으로 연기) | 고배율 환경에서 페이지 헤더·모달 창 레이아웃 확인 | Summer '26 (first available Summer '25) |
| **Enable Accessibility Enhancements for Date Pickers, Popovers, Bottom Utility Bars, and Record Headers (Release Update)** | 고배율 보기 시 **date picker·popover·bottom utility bar·record header** 동작을 적응시킴. 위 "Page Headers and Modal Windows" 업데이트에 **종속** — 그것을 먼저 활성화해야 한다. (Winter '26에 제공, Summer '26에 강제) | 선행 업데이트(Page Headers and Modal Windows) 활성화 후 date picker·popover·bottom utility bar·record header 레이아웃 확인 | Summer '26 (available Winter '26) |
| **Enforcing No-Argument Constructor on Apex Classes Used for Invocable Action Parameters (Release Update)** | invocable action 파라미터로 사용 가능한 빌트인 Apex 액션에 대한 변경을 강제하며, **no-argument 생성자 가시성**도 강제함. (Summer '24에 처음 제공, Winter '26 강제 예정 → Summer '26으로 연기) | invocable action 파라미터로 사용되는 클래스에 가시적인 no-argument 생성자가 있는지 확인 | Summer '26 (first available Summer '24) |
| **Sort Apex Batch Action Results by Request Order (Release Update)** | Apex batch action 결과를 **요청 수신 순서**대로 표시. (현재는 error-prone 결과가 우선 상단에 표시됨) | Apex batch action 결과 순서에 의존하는 처리 로직 확인 | Summer '26 |
| **Update Instanced URLs in API Traffic (Release Update)** | 조직 API 트래픽이 조직의 **My Domain 로그인 URL**을 사용하도록 보장. (Summer '25에 처음 제공, Spring '26 강제 예정 → Summer '26으로 연기) | API 트래픽이 My Domain 로그인 URL을 사용하도록 전환 | Summer '26 (first available Summer '25) |

> **이전 이름 (No-Argument Constructor):** Summer '25 노트에서 이 항목은 *"Enforce Permission Requirements Defined on Built-In Apex Classes Used as Inputs (Release Update)"*라는 구 명칭으로 등장했다. 동일 업데이트이며 별개 항목이 아니다.

> **종속 관계 (Accessibility):** 위 두 Accessibility 항목은 독립 항목이지만 두 번째(Date Pickers, Popovers...)가 첫 번째(Page Headers and Modal Windows)에 종속한다 — 선행 항목을 먼저 활성화해야 한다.

---

## 그룹 5 — Scheduled to Be Enforced in Summer '27 — 1건

> PDF "Scheduled to Be Enforced in Summer '27" 섹션.

| 항목 (PDF 정식 제목) | 영향 | 준비 사항 | 강제 시점 |
|---|---|---|---|
| **SOAP API login() Call in SOAP API Versions 31.0 Through 64.0 Is Being Retired (Release Update)** | Summer '27에 **SOAP API v31.0~64.0의 `login()` call**이 더 이상 지원되지 않으며 사용 불가가 됨. | 해당 버전 범위의 SOAP API `login()` call에 의존하는 통합을 점검·전환 | Summer '27 |

> 이 항목은 강제 시점이 가장 멀지만(Summer '27), v31.0~64.0이라는 광범위한 버전 대역을 포괄하므로 SOAP 기반 로그인 통합이 있는 조직은 조기 점검이 필요하다.

---

## 그룹 6 — No Scheduled Enforcement Date (강제 시점 미정) — 3건

> PDF "No Scheduled Enforcement Date" 섹션. 강제 예정일이 없으므로 강제되지 않으나, 활성화·전환이 권장된다.

| 항목 (PDF 정식 제목) | 영향 | 조치 | 강제 시점 |
|---|---|---|---|
| **Enable ICU Locale Formats (Release Update)** | International Components for Unicode(ICU) 로케일 형식이 Oracle JDK 로케일 형식을 대체. 로케일은 날짜·시간·통화·주소·이름·숫자값·주 시작 요일 형식을 제어. (Winter '20에 처음 제공) | 아직 ICU로 전환하지 않은 조직은 로케일 의존 코드·통합을 테스트 후 수동으로 업데이트 권장 | 미정 (first available Winter '20) |
| **Switch to a Single Domain Certificate for Your Salesforce Content Delivery Network (Release Update)** | Salesforce CDN의 공유 도메인 인증서(shared domain certificate)를 단일 도메인 인증서(single domain certificate)로 전환. 공유 인증서는 폐기(retire)됨. 전환에 **다운타임 없음**. (Summer '24에 처음 제공, Spring '25 강제 예정 → Spring '26 연기 → 현재 **무기한 연기(postponed indefinitely)**) | 공유 도메인 인증서를 단일 도메인 인증서로 전환 | 미정 — 무기한 연기 (first available Summer '24) |
| **Control NBA Widget Refresh in Lightning Console Tabs (Release Update)** | Next Best Action(NBA) widget이 console tab을 전환할 때마다 새로고침되던 동작을, **관련 탭으로 전환하고 페이지가 변경될 때에만** 새로고침하도록 제어. | NBA widget을 Lightning Console 탭에서 사용하는 경우 새로고침 동작 변화 확인 | 미정 |

> PDF 원문(Single Domain Certificate): 전환은 *"with no downtime"*으로 진행되며, 강제 시점은 현재 무기한 연기 상태다.

---

## 관련 노트

- [[Winter '26]] — Winter '26 릴리즈 노트 허브
- [[Winter '26/Development]] — Apex(No-Argument Constructor·Batch Action 결과 순서)·LWC·API 개발자 전수 영향 상세
- [[Winter '26/Platform]] — Secure Roles·SAML 다중 구성·CDN 인증서·Legacy Host Names 등 플랫폼/보안 맥락
- [[Release MOC]] — 릴리즈 노트 전체 목차
