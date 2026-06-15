---
tags: [release, spring_26, release-updates]
source: salesforce_spring26_release_notes.pdf (Salesforce Spring '26 Release Notes, Tier 2)
created: 2026-06-15
aliases: [Spring 26 Release Updates, 스프링26 릴리즈업데이트, Spring 26 강제 적용, Release Update enforcement Spring 26, 릴리즈 업데이트 강제 시점, enforced with this release]
---

# Spring '26 — Release Updates (강제 적용 항목 · 시점 맵)

> Spring '26 Release Notes의 **Release Updates** 섹션 전수 정리. 어떤 Release Update가 **언제(어느 릴리즈에) 강제(enforced)**되는지를 시점별로 정리한 단일 권위 출처다. Spring '26에서 강제되는 항목 2건 + Summer '26 ~ Summer '27에 강제 예정인 항목 12건 + 연기(postponed)된 항목 1건을 포함한다.

---

## Release Update란

> PDF 원문: *"Salesforce periodically provides release updates that improve the performance, logic, security, and usability of our products. The Release Updates page provides a list of updates that can be necessary for your organization to enable. Some release updates affect existing customizations."*

- 모든 Release Update는 생성 시 **향후 어느 릴리즈에 강제(enforced)될지** 스케줄이 잡힌다. 일정이 정해지면 릴리즈 노트에 공지하지만, **간혹 연기(postponed)되거나 취소(canceled)**될 수 있고 그 경우 해당 update 설명에 고지된다.
- 대부분의 Release Update는 **Test Run** 옵션을 제공해, `Complete Steps By` 날짜 전에 update를 켜고 org(커스터마이징 포함)에 미치는 변화를 미리 검토할 수 있다.
- 확인 경로: **Setup → Quick Find에 `Release Updates` 입력 → Release Updates** 선택.

---

## 시점별 강제 맵 (핵심)

각 항목 = 제목 / 강제 시점 / 최초 제공·연기 여부 / 한 줄 설명. 모든 항목은 Release Updates 섹션(인쇄 p.187–189)에서 전수 추출.

### 🔴 Spring '26 강제 — "Enforced with This Release" (2건)

> PDF 원문: *"These updates are scheduled to be enforced this release."*

| # | 제목 | 최초 제공 | 설명 |
|---|---|---|---|
| 1 | **Escape the Label Attribute of `<apex:inputField>` Elements to Prevent Cross-Site Scripting in Visualforce Pages** | Spring '23 | Visualforce 페이지의 XSS 공격에서 악성 코드 실행을 막기 위해, `<apex:inputField>` 태그의 `label` 속성을 이스케이프한다. |
| 2 | **Update References to Legacy Host Names** | Spring '25 | 레거시(non-enhanced) Salesforce host name의 **임시 리다이렉션이 모든 org에서 종료**된다. 고객·최종 사용자 중단 방지를 위해 레거시 host name 참조를 갱신해야 한다. |

> PDF 원문(#1): *"...this release update escapes the label attribute of your `<apex:inputField>` tags. First available in Spring ’23, this update is enforced in Spring ’26."*
>
> PDF 원문(#2): *"...those redirections end in all orgs. First available in Spring ’25, this update is enforced in Spring ’26."*

### 🟠 Summer '26 강제 (5건)

> PDF 원문: *"These updates are scheduled to be enforced in Summer ’26. The list can include new, previously announced, and previously postponed release updates."*

| # | 제목 | 비고 | 설명 |
|---|---|---|---|
| 3 | **Enable Accessibility Enhancements for Date Pickers, Popovers, Bottom Utility Bars, Record Headers** | #4에 **의존** | WCAG 2.2 Resize/Reflow 준수를 위해, 고배율 확대 시 date picker·popover·bottom utility bar·record header의 동작을 Lightning Experience가 조정하도록 한다. |
| 4 | **Enable Accessibility Enhancements for Page Headers and Modal Windows When Zoom Is Greater Than 200%** | WCAG 2.2 준수의 **시작점** | 고배율 확대 시 page header·modal window 동작을 조정한다. PDF 원문: *"This is the beginning of our effort to comply with WCAG 2.2 Resize and Reflow guidelines."* |
| 5 | **Migrate to a Multiple-Configuration SAML Framework** | — | 단일 구성(single-configuration) SAML 프레임워크(IdP **1개만** 지원) 지원이 종료된다. multiple-configuration SAML(여러 IdP 지원)로 마이그레이션하지 않으면, 강제 시 **SAML SSO 구성이 동작을 멈춘다**. |
| 6 | **Salesforce-Managed X (Formerly Twitter) Authentication Provider Retirement** | — | Salesforce 관리형 X(구 Twitter) 인증 공급자 앱이 은퇴한다. 이 앱을 쓰는 SSO 구성이 깨지므로, **커스텀 X 앱을 생성**하고 SSO 구성을 갱신해야 한다. |
| 7 | **Use Visualforce PDF Rendering Service with Apex `Blob.toPdf()`** | — | Apex `Blob.toPdf()`의 PDF 렌더링이 Visualforce와 **동일한 렌더링 서비스**를 사용한다. 추가 폰트·멀티바이트 문자 지원 등 개선 제공. |

### 🟡 Winter '27 강제 (4건)

> PDF 원문: *"These updates are scheduled to be enforced in Winter ’27. The list can include new, previously announced, and previously postponed release updates."*

| # | 제목 | 비고 | 설명 |
|---|---|---|---|
| 8 | **Adopt Authorized Email Domains** | — | email change verification을 비활성화하던 기존 예외(exemption) 프로세스가 은퇴한다. 대신 **authorized email domain**을 설정하라(동일 이점 제공). |
| 9 | **Enable Accessibility Enhancements for Cards, Docked Containers, Menu Lists, and Panels** | #4에 **의존** | WCAG 2.2 Resize/Reflow 준수를 위해, 고배율 확대 시 card·docked container·menu list·panel 동작을 Lightning Experience가 조정하도록 한다. |
| 10 | **Retirement of OAuth 2.0 Username-Password Flow for Connected Apps** | — | connected app의 OAuth 2.0 **username-password flow** 지원이 종료된다. 이 flow를 쓰는 모든 connected app 연동이 깨지므로, OAuth 2.0 **web-server flow** 또는 **client credentials flow**로 전환하라. |
| 11 | **Update Instanced URLs in API Traffic** | 최초 Summer '25 · **연기(postponed)** | org의 **My Domain login URL** 사용을 보장해야 한다. **원래 Spring '26 강제 예정이었으나 Winter '27로 연기**되었다. (이 섹션에서 유일하게 명시적으로 연기된 항목) |

> PDF 원문(#11): *"First available in Summer ’25, this release update was scheduled to be enforced in Spring ’26, but we postponed the enforcement to Winter ’27."*

### 🟢 Spring '27 강제 (2건)

> PDF 원문: *"These updates are scheduled to be enforced in Spring ’27. The list can include new, previously announced, and previously postponed release updates."*

| # | 제목 | 비고 | 설명 |
|---|---|---|---|
| 12 | **Salesforce to Salesforce Is Being Retired** | — | Salesforce to Salesforce 제품이 Spring '27에 은퇴한다. 권장 마이그레이션 대상: **Partner Cloud, Data Cloud One, MuleSoft Anypoint, MuleSoft for Flow**. |
| 13 | **Update Apex Code and Flows for Changed Sharing Recalculation Behavior** | **Spring '26부터 available** | 그룹·역할 대규모 갱신 후 성능 최적화를 위해 일부 sharing recalculation이 **비동기**로 수행된다. share 레코드 즉시 갱신에 의존하는 Apex/flow는 강제 시 깨질 수 있으므로, **동기 sharing recalc에 의존하는 Apex 클래스·테스트·flow를 갱신**해야 한다. |

> PDF 원문(#13): *"This update is available starting in Spring ’26."*

### 🔵 Summer '27 강제 (1건)

> PDF 원문: *"These updates are scheduled to be enforced in Summer ’27. The list can include new, previously announced, and previously postponed release updates."*

| # | 제목 | 비고 | 설명 |
|---|---|---|---|
| 14 | **SOAP API login() Call in SOAP API Versions 31.0 Through 64.0 Is Being Retired** | — | SOAP API 버전 **31.0 ~ 64.0**의 `login()` 호출이 지원·제공되지 않는다. |

---

## 시점별 요약

| 강제 시점 | 항목 수 | 항목 # |
|---|---|---|
| 🔴 Spring '26 (this release) | 2 | 1, 2 |
| 🟠 Summer '26 | 5 | 3, 4, 5, 6, 7 |
| 🟡 Winter '27 | 4 | 8, 9, 10, 11 |
| 🟢 Spring '27 | 2 | 12, 13 |
| 🔵 Summer '27 | 1 | 14 |
| **합계** | **14** | — |

- **Spring '26에 실제 강제되는 항목: 2건** (#1, #2).
- **이후 강제 예정: 12건** (Summer '26 5 + Winter '27 4 + Spring '27 2 + Summer '27 1).
- **연기(postponed)된 항목: 1건** (#11 — Spring '26 → Winter '27).
- **Spring '26부터 available(준비 가능)이나 강제는 이후**: #13(Spring '27 강제).
- **의존 관계**: #3, #9 는 #4(Page Headers and Modal Windows…200%) update에 의존한다.

---

## 코드 관점 영향 (Apex / Visualforce)

```apex
// 구조 예시 — 실제 동작 코드 아님
// #7: Blob.toPdf() — 강제 후 Visualforce와 동일한 렌더링 서비스 사용 (추가 폰트·멀티바이트 지원)
Blob pdfBlob = Blob.toPdf('Hello, <b>PDF</b>');
// #14: SOAP API 31.0~64.0의 login() 호출은 Summer '27부터 미지원
```

```html
<!-- 구조 예시 — 실제 동작 코드 아님 -->
<!-- #1: <apex:inputField>의 label 속성이 Spring '26부터 자동 이스케이프됨 (XSS 방지) -->
<apex:inputField value="{!account.Name}" label="{!someUserControlledLabel}" />
```

- **#13**: 동기 sharing recalculation에 의존하는 Apex 클래스·트리거·테스트·flow를 검토하라. 그룹/역할 멤버십을 갱신한 뒤 share 레코드가 즉시 반영됐다고 가정하는 코드는 비동기 전환 시 깨질 수 있다.
- **#1**: `<apex:inputField>`의 `label` 속성에 사용자 제어 가능 값을 직접 넣던 페이지는, 이스케이프로 인해 렌더링 결과가 달라질 수 있으니 검토.

---

## 이 섹션에 **없는** 항목 (오인 방지)

다음 두 항목은 다른 곳에서 자주 언급되지만, **이 Release Updates 섹션의 Release Update가 아니다.** 동일 항목으로 단정하지 말 것.

- **"새 Connected App 생성 기본 비활성"** — 이 Release Updates 섹션에 RU로 존재하지 않는다.
- **"Email 도메인 소유권 검증 의무화"** — 가장 근접한 항목은 #8 **Adopt Authorized Email Domains**(Winter '27)지만, 이는 *email change verification*의 예외 프로세스 은퇴에 관한 것으로, "도메인 소유권 검증 의무화"와는 표현·범위가 다르다. **동일 항목으로 취급하지 말 것.**
- 위 두 변경의 정확한 출처는 Release Updates가 아니라 **Platform(Salesforce Overall / Security) 섹션**이다 → [[Spring '26/Platform]] 참조.

---

## 관련 노트

- [[Spring '26]] — Spring '26 릴리즈 허브
- [[Spring '26/index]] — Spring '26 폴더 인덱스
- [[Spring '26/Platform]] — Connected App·Email 도메인·보안 관련 변경 (이 섹션에 없는 항목의 출처)
- [[Spring '26/Development]] — Apex `Blob.toPdf()`·sharing recalculation·Visualforce 등 개발자 영향 항목의 상세
- [[Release MOC]] — 릴리즈 노트 전체 목차
