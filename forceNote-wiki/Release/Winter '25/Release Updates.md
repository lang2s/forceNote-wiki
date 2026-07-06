---
tags: [release, winter_25, release-updates, deprecated, enforcement]
api_version: v62.0
release_date: 2024-10
created: 2026-06-16
source: salesforce_winter25_release_notes.pdf (Salesforce Winter '25 Release Notes, Tier 2)
aliases: [Winter '25 Release Updates, 윈터25 릴리즈 업데이트, 강제 적용 항목, Enforcement, Deprecated v62, 윈터25 폐기 일정]
---

# Winter '25 — Release Updates

> Winter '25 (API v62.0)의 Release Updates 섹션 전수 기록 — 이번 릴리즈에 강제된 항목, Spring '25 / Summer '25 / Winter '26 강제 예정 클러스터, 권장(미강제) 항목, 취소 항목, 강제 시점 미정 항목. 핵심 정확도: "Restrict User Access to Run Flows"는 Winter '25 스케줄이었으나 **Winter '26으로 연기**됨; "Maintenance Work Rules" 마이그레이션은 Winter '26 스케줄(아직 미강제).

---

## 개요

이 노트는 Winter '25 릴리즈 노트의 통합 **Release Updates** 섹션(PDF p.135–139)을 전수 전사한 spoke다. 허브 [[Winter '25]]에서 진입하며, 형제 spoke [[Winter '25/Development]]·[[Winter '25/Platform]]과 함께 Winter '25을 구성한다.

> Release Updates 섹션 preamble (PDF 원문): "Salesforce periodically provides release updates… Every time a release update is created, it gets scheduled to be enforced in a future release… occasionally, updates are postponed or canceled… Often, release updates provide a Test Run option."

각 항목은 **이름 + 최초 도입 릴리즈 + 강제 시점/상태(연기 포함)** 형식으로 기록한다. 빠른 조회는 본 노트 하단의 [강제 시점 매핑 표](#강제-시점-매핑-표)를 참조.

---

## 이번 릴리즈 강제 적용 (Enforced with This Release)

> Winter '25에 강제된 항목 (PDF line 7089).

| Release Update | First available | Status |
|---|---|---|
| **Create and Verify Your Default No-Reply Org-Wide Email Address to Send Email** | Summer '24 | Winter '25 강제 |
| **Disable Access to Session IDs in Flows** | (재출시; 이전 Winter '24) | Winter '25 재강제 |
| **Enable EmailSimple Invocable Action to Respect Org-Wide Profile Settings** | Summer '23, Spring '24 스케줄 | 연기 → Winter '25 강제 |
| **Enable Partial Save for Invocable Actions** | (재출시; 이전 Spring '20) | Winter '25 재강제 |
| **Make Flows Respect Access Modifiers for Legacy Apex Actions** | (재출시; 이전 Spring '21) | Winter '25 재강제 |
| **Pass the Conversation Intelligence Rule Name as Input to a Flow** | Spring '24 | 이번 릴리즈 강제(신규 `ruleDevName` 파라미터) |
| **Prevent Guest User from Editing or Deleting Approval Requests** | Winter '23, Summer '23 스케줄 | Spring '24 연기 → Winter '25 강제 |
| **Review and Update Settings to Capture Leads from LinkedIn** | Winter '25 | LinkedIn이 legacy Ads Lead Sync API를 2024-12-16에 폐기 |
| **Run Flows in Bot User Context** | Summer '23 | Winter '25 강제 |
| **Run Flows in User Context via REST API** | (재출시; 이전 Spring '22) | Winter '25 재강제 |
| **Turn On Lightning Article Editor and Article Personalization for Knowledge** | — | (Knowledge editor) |
| **Use REST API for Access to External Client App OAuth Consumer Credentials** | — | (PDF p.823, Winter '25 강제) |

### "Default No-Reply" / "Verify Return Email" / "LWC Stacked Modals" 전체 항목

이 항목들은 섹션 상단(PDF line 6585–7076)에 full 항목으로 등장한다.

**Create and Verify Your Default No-Reply Org-Wide Email Address (Release Update)** — LEX+Classic 전 edition(Database.com 제외). Summer '24 도입, **Winter '25 강제.** Org-Wide Email Address 설정에서 Default No-reply 주소 생성+검증 필수. 없으면 일부 이메일 발송 실패.

**Verify Your Return Email Address for Sender Verification (Release Update)** — LEX+Classic 전 edition(Database.com 제외). **Spring '25 강제.** Spring '25 이후 My Email Settings에서 Email Address 검증 필수. 사용자는 Spring '25 전까지 릴리즈당 한 번 verification 이메일을 받는다.

**Enable LWC Stacked Modals (Release Update)** — LEX 전 edition. **Spring '25 강제.** Summer '24 최초 제공. 더 많은 modal이 LWC로 렌더링.

> **post-save navigation 표 (PDF 원문 verbatim, lines 6635–6685):**
>
> 표 구조: 5개 데이터 행 × 2개 status 컬럼(+ 1개 Example 컬럼). 행 = action/scenario type; 컬럼 = "Enable LWC Stacked Modal Release Update Enabled" vs "...NOT Enabled". 셀의 unique 값은 둘뿐: "Returns back" / "Redirects to newly created record page". **Aura Quick Action (not stacked)** 행만 enabled/not-enabled 사이에서 다르다.

| Example | Release Update ENABLED | Release Update NOT enabled |
|---|---|---|
| Create from Lookup | Returns back | Returns back |
| Default Action | Returns back | Returns back |
| LWC Quick Action (stacked) | Returns back | Returns back |
| LWC Quick Action (not stacked) | Redirects to newly created record page | Redirects to newly created record page |
| Aura Quick Action (not stacked) | Redirects to newly created record page | Returns back |

추가 노트: `force:createRecord`는 LWC 활성화 object를 넘기면 LWC 기반 modal을 띄운다; `force:createRecord`를 LWC quick action으로 교체 고려; LWC quick action은 `lightning/navigation`을 사용하고 이전 modal을 닫으려면 `replace`를 true로 설정.

```js
// 구조 예시 — 실제 동작 코드 아님 (PDF의 LWC Stacked Modals 가이드를 코드 형태로 정리)
// 이전 modal을 닫으려면 lightning/navigation의 navigate에 replace: true 전달
import { NavigationMixin } from 'lightning/navigation';
// this[NavigationMixin.Navigate](pageReference, /* replace */ true);
```

---

## 향후 강제 예정 (Spring '25 / Summer '25 / Winter '26 클러스터)

### Spring '25 강제 예정 (PDF line 7163)

| Release Update | First available | Note |
|---|---|---|
| **Change Einstein Activity Capture Permissions for Sales Engagement Basic Users** | — | Sales Engagement Basic User PSL이 더 이상 EAC 미포함 |
| **Enable ICU Locale Formats** | Winter '20 | Spring '24부터 롤링 |
| **Enable LWC Stacked Modals** | Summer '24 | Spring '25 강제 |
| **Enable Secure Redirection for Flows** | Spring '25 | (이후 미강제 전환 — 아래 권장 항목 참조) |
| **Enforce View Roles and Role Hierarchy Permission When Editing Public List View Visibility** | Spring '24 | |
| **Migrate to a Multiple-Configuration SAML Framework** | Spring '24, Summer '24 스케줄 | 샌드박스 Summer '24; 프로덕션 Spring '25 연기 |
| **Sort Apex Batch Action Results by Request Order** | — | |
| **Use an Apex-Defined Variable for All Intelligence Signal Types** | Summer '24 | 신규 `intelligenceSignals` 파라미터 |
| **Verify Your Return Email Address for Sender Verification** | — | |
| **Enhance Flexibility and Reusability in Prompt Flows** | Winter '25 | |

### Summer '25 강제 예정 (PDF line 7220)

| Release Update | First available | Note |
|---|---|---|
| **Evaluate Criteria Based on Original Record Values in Process Builder** | Summer '19 | |
| **Salesforce Platform API Versions 21.0 Through 30.0 Retirement** | 최초 Summer '23 스케줄 | **Summer '25로 연기.** 요청이 "endpoint is deactivated"로 실패. |
| **Verify SAML Integrations** | Winter '25, Spring '25 스케줄 | **Summer '25로 연기.** |

### Winter '26 강제 예정 (PDF line 7239)

| Release Update | First available | Note |
|---|---|---|
| **Enforce Permission Requirements Defined on Built-In Apex Classes Used as Inputs** | Summer '24, Spring '25 스케줄 | **Winter '26으로 연기.** (이 항목은 "file-based Apex classes"라 표기되어 있고 Flow 섹션 항목은 "built-in"이라 표기 — PDF 내 불일치, 양쪽 모두 존재.) |
| **Migrate from Maintenance Plan Frequency Fields to Maintenance Work Rules** | Summer '22, Winter '22 스케줄 | **Winter '26으로 연기.** Maintenance Plan의 Frequency + Frequency Type 필드가 폐기 중; maintenance work rule로 마이그레이션. **확인: Winter '26 스케줄, 아직 강제되지 않음.** |
| **Restrict User Access to Run Flows** | Winter '24, Winter '25 스케줄 | **Winter '26으로 연기.** (Winter '25 스케줄이었으나 연기됨 — 확인.) |

> **정확도 강조 — Restrict User Access to Run Flows:** 이 업데이트는 Winter '25에 강제될 예정이었으나 **Winter '26으로 연기**되었다. FlowSites org 권한을 deprecate하며, perm set에 Run Flows 권한을 추가해야 한다. (자세한 Flow 항목은 [[Winter '25/Platform]]의 Flow and Process Release Updates 클러스터 참조.)
>
> **정확도 강조 — Maintenance Work Rules 마이그레이션:** Maintenance Plan Frequency 필드 → Maintenance Work Rules 마이그레이션은 **Winter '26 스케줄이며, Winter '25에 강제되지 않았다.** Summer '22 최초 도입, Winter '22 스케줄에서 연기됨.

---

## 권장 (Recommended But Not Enforced)

> PDF line 7266.

| Release Update | Note |
|---|---|
| **Capture Prompt and Accurate Order Details with New Order Save Behavior** | Winter '25부터 신규 고객 org에 기본 활성화. parent order에 custom application logic(validation rule, apex trigger/class, workflow rule, flow) 사용. |
| **Enforce Rollbacks for Apex Action Exceptions in REST API** | Spring '25 스케줄 → Spring '25부터 **더 이상 강제 안 함**(recommended). |
| **Enforce Sharing Rules When Apex Launches a Flow** | Winter '25 스케줄 → Winter '25부터 **더 이상 강제 안 함**(recommended). 대안: API v62.0+. |

---

## 취소 (Canceled Updates)

> PDF line ~7291.

| Release Update | Note |
|---|---|
| **Adopt Updated Content Security Policy (CSP) Directives** | **취소됨.** Release Updates 노드에서 제거. 강제되지 않음. |

---

## 강제 시점 미정 (No Scheduled Enforcement Date)

> PDF line 7302.

| Release Update | First available | Note |
|---|---|---|
| **Disable Ref ID and Transition to New Email Threading Behavior** | Winter '21 | 강제 시점 미정. Email-to-Case: 제목/본문의 secure token으로 매칭, 그다음 email 헤더 metadata. (PDF p.864) |
| **Transition to the Lightning Editor for Email Composers in Email-to-Case (GA)** | Spring '24 | LEX에서 Spring '24 GA; 강제 시점 미정. (PDF p.863) |
| **Manage Multiple Currencies with the Currency Data Type** | — | Data Cloud Currency data type. **2024-09 스케줄이었으나 2024-11~12로 연기.** |

---

## 강제 시점 매핑 표

> 본 릴리즈 노트에 등장한 Release Update 전체의 도입·강제 매핑(연기 이력 포함).

| Release Update | 도입 | 강제 시점 | 조치 |
|---|---|---|---|
| Create and Verify Your Default No-Reply Org-Wide Email Address | Summer '24 | **Winter '25 강제** | Default No-reply 주소 생성+검증 |
| Disable Access to Session IDs in Flows | Winter '24 | **Winter '25 재강제** | flow의 session ID 의존 제거 |
| Enable EmailSimple Invocable Action to Respect Org-Wide Profile Settings | Summer '23 | Spring '24 연기 → **Winter '25 강제** | org-wide profile 설정 검토 |
| Enable Partial Save for Invocable Actions | Spring '20 | **Winter '25 재강제** | 미지원 action 11종 확인 |
| Make Flows Respect Access Modifiers for Legacy Apex Actions | Spring '21 | **Winter '25 재강제** | legacy Apex action 접근 제어 검토 |
| Pass the Conversation Intelligence Rule Name as Input to a Flow | Spring '24 | **Winter '25 강제** | `ruleDevName` 파라미터 사용 |
| Prevent Guest User from Editing or Deleting Approval Requests | Winter '23 | Summer '23/Spring '24 연기 → **Winter '25 강제** | guest user 승인 요청 제한 |
| Run Flows in Bot User Context | Summer '23 | **Winter '25 강제** | bot user context flow 검토 |
| Run Flows in User Context via REST API | Spring '22 | **Winter '25 재강제** | REST API flow context 검토 |
| Use REST API for Access to External Client App OAuth Consumer Credentials | — | **Winter '25 강제** | `credentials` Connect REST API로 이전 |
| Verify Your Return Email Address for Sender Verification | — | **Spring '25 강제** | My Email Settings에서 Email Address 검증 |
| Enable LWC Stacked Modals | Summer '24 | **Spring '25 강제** | post-save navigation 동작 검토 |
| Enforce View Roles and Role Hierarchy Permission When Editing Public List View Visibility | Spring '24 | **Spring '25 강제** | 해당 권한 부여 검토 |
| Migrate to a Multiple-Configuration SAML Framework | Spring '24 | 샌드박스 Summer '24, 프로덕션 **Spring '25 연기** | multiple-config SAML 전환 |
| Sort Apex Batch Action Results by Request Order | — | **Spring '25 강제** | batch action 결과 순서 검토 |
| Use an Apex-Defined Variable for All Intelligence Signal Types | Summer '24 | **Spring '25 강제** | `intelligenceSignals` 파라미터 사용 |
| Enhance Flexibility and Reusability in Prompt Flows | Winter '25 | **Spring '25 강제** | flex prompt template 제거, manual input |
| Change Einstein Activity Capture Permissions for Sales Engagement Basic Users | — | **Spring '25 강제** | EAC 권한 변경 검토 |
| Enable ICU Locale Formats | Winter '20 | Spring '24부터 롤링(**Summer '25까지 연기 가능**) | ICU locale 형식 검토, en_CA 별도 활성화 |
| Evaluate Criteria Based on Original Record Values in Process Builder | Summer '19 | **Summer '25 강제** | original record value 기준 검토 |
| Salesforce Platform API Versions 21.0 Through 30.0 Retirement | Summer '23 스케줄 | **Summer '25로 연기** | API 21.0~30.0 호출 마이그레이션 |
| Verify SAML Integrations | Winter '25 | Spring '25 스케줄 → **Summer '25로 연기** | Summer '25 샌드박스에서 SSO/single logout 테스트 |
| Enforce Permission Requirements Defined on Built-In/File-Based Apex Classes Used as Inputs | Summer '24 | Spring '25 스케줄 → **Winter '26으로 연기** | Apex class input 권한 요구 검토 |
| Migrate from Maintenance Plan Frequency Fields to Maintenance Work Rules | Summer '22 | Winter '22 스케줄 → **Winter '26으로 연기** | maintenance work rule로 마이그레이션 |
| Restrict User Access to Run Flows | Winter '24 | Winter '25 스케줄 → **Winter '26으로 연기** | perm set에 Run Flows 권한 추가 (FlowSites deprecate) |
| Enforce Sharing Rules When Apex Launches a Flow | Spring '24 | Winter '25 스케줄 → **미강제(recommended)** | API v62.0+ 사용 |
| Enable Secure Redirection for Flows | Summer '24 | Spring '25 스케줄 → **미강제(recommended)** | secure redirection 권장 검토 |
| Enforce Rollbacks for Apex Action Exceptions in REST API | Spring '23 | Spring '25 스케줄 → **미강제(recommended)** | rollback 동작 권장 검토 |
| Capture Prompt and Accurate Order Details with New Order Save Behavior | — | **미강제** (신규 org 기본 On) | parent order custom logic 검토 |
| Adopt Updated Content Security Policy (CSP) Directives | — | **취소** | 조치 불필요 |
| Disable Ref ID and Transition to New Email Threading Behavior | Winter '21 | **미정** | secure token 매칭 검토 |
| Transition to the Lightning Editor for Email Composers in Email-to-Case | Spring '24 | **미정** (LEX GA) | Lightning editor 전환 검토 |
| Manage Multiple Currencies with the Currency Data Type | — | **미정** (2024-11~12로 연기) | Data Cloud Currency data type 검토 |

---

## 관련 노트

- [[Winter '25]] — Winter '25 허브
- [[Winter '25/Development]] — Apex·LWC·API 개발자 항목 형제 spoke
- [[Winter '25/Platform]] — Platform 형제 spoke (Flow and Process Release Updates 클러스터 상세 포함)
- [[Email-to-Case & Web-to-Case (이메일·웹 투 케이스)]] — Disable Ref ID 스레딩 전환 RU의 대상 기능 (secure token 매칭 순서 상세)
