---
tags: [admin, licenses, user-license, permission-set-license, feature-license, provisioning]
source: help.salesforce.com — Licenses Overview / User Licenses / Standard User Licenses / Permission Set Licenses / Feature Licenses Overview / Available Feature Licenses (라이브 공식 문서, Tier 2, 접속 2026-07-11)
official_doc: https://help.salesforce.com/s/articleView?id=platform.users_licenses_overview.htm&type=5
created: 2026-07-11
aliases: [User License, 사용자 라이선스, Permission Set License, PSL, 권한집합 라이선스, Feature License, 기능 라이선스, License Types, 라이선스 유형, Salesforce Platform License, Salesforce license]
---

# User Licenses · Permission Set Licenses · Feature Licenses (라이선스 유형)

> Salesforce 라이선스는 **3층**이다. **User License**는 사용자당 정확히 1개(배타)로 기능·오브젝트의 **기준선(baseline)** 을 정하고, 그 위에 **Permission Set License(PSL)** 와 **Feature License** 를 **몇 개든 가산**해 추가 기능을 연다. 공식 비유: *"권한은 자물쇠, 라이선스는 열쇠 꾸러미"* — 권한을 할당하려면 그 열쇠를 담은 라이선스가 먼저 있어야 한다.

> [!note] 근거: help.salesforce.com **Licenses Overview / User Licenses / Standard User Licenses / Permission Set Licenses / Feature Licenses Overview / Available Feature Licenses** (Tier 2, 접속 2026-07-11). 📖 [Licenses Overview](https://help.salesforce.com/s/articleView?id=platform.users_licenses_overview.htm&type=5)

---

## 자물쇠와 열쇠 — 라이선스와 권한의 관계

> "Think of permissions as locks and of licenses as rings of keys. Before you can assign users a specific permission, they must have a license that includes the key to unlock that permission."

- 어떤 권한(예: 계약 Read)을 사용자에 부여하려면, 그 사용자의 **라이선스가 그 권한을 지원(support)** 해야 한다. 하나의 권한을 여러 라이선스가 지원할 수 있다.
- 예: **Salesforce** user license는 Contracts Read 권한의 열쇠를 포함하지만 **Chatter Free** license는 포함하지 않는다 → Chatter Free 사용자에게 그 권한을 할당하면 오류가 난다.
- **핵심 규칙:** 사용자는 **user license를 정확히 1개**만 갖는다. 그 위에 **PSL·Feature License는 여러 개** 붙여 권한을 점진적으로(incrementally) 확장한다.

### 3층 요약

| 층위 | 개수 규칙 | 역할 | 할당 방식 |
|---|---|---|---|
| **User License** | 사용자당 **정확히 1개**(배타·exclusive) | 기능·오브젝트 **기준선(baseline)** 을 정함 | 사용자 생성 시 배정 / 기존 사용자는 프로파일 편집으로 변경 |
| **Permission Set License (PSL)** | **몇 개든** 가산(additive) | user license에 **없는 기능**을 추가로 여는 자격 | PSL 배정 + 그 기능 권한을 담은 **Permission Set** 를 함께 할당 |
| **Feature License** | **몇 개든** 가산(additive) | user license에 없는 **개별 기능** 활성화 | 사용자 레코드에서 해당 기능 **체크박스** 활성화 |

> ⚠️ 사용자의 **user license를 변경**하면, 그 라이선스에 종속돼 있던 **permission set·permission set license 할당이 함께 제거**된다. 라이선스 교체는 파괴적 작업이므로 주의.

---

## 1. User License — 사용자당 1개 (배타)

User license는 "사용자가 Salesforce에서 접근하는 기능·기능성의 **기준선**"을 제공한다. **각 사용자는 user license를 오직 하나만** 가질 수 있다. 배정 시 그 사람의 직무와 필요한 권한을 기준으로 유형을 고른다.

### Salesforce User Licenses (주요)

| License Type | 여는 것(기능·오브젝트 범위) | 제공 에디션 |
|---|---|---|
| **Salesforce** | 표준 CRM·AppExchange 앱에 **완전 접근**. 표준·커스텀 앱 **모두** 사용 가능(accounts, contacts, opportunities, cases, reports & dashboards 등 종합 CRM). EE·UE·PE에선 스토리지 추가 | All editions |
| **Knowledge Only User** | **Salesforce Knowledge 앱만**. 커스텀 오브젝트·탭 + 일부 표준 탭(Articles·Article Management·Chatter·Files·Home·Profile·Reports). 기사 열람에 `AllowViewKnowledge` 권한 필요(기본 프로파일엔 꺼져 있음) | EE·UE·PE |
| **Identity Only** | **Identity 서비스만**(SSO 등). 전 솔루션이 필요 없지만 org에서 SSO로 커스텀 웹앱에 로그인해야 하는 직원용 | EE·UE·PE·Developer (신규 DE org마다 **무료 10개**) |
| **External Identity** | **Salesforce Customer Identity** — 고객·파트너가 self-register·로그인·프로필 갱신하고 웹/모바일 앱에 단일 ID로 접근 | EE·UE·PE·Developer (신규 DE org마다 **무료 5개**) |
| **Salesforce Integration** | **API 전용** — 시스템 간(system-to-system) 통합 전용. UI로는 데이터·기능 접근 불가 | EE·UE·PE·Developer (EE·UE·PE **무료 5개**, DE **1개**) |
| **WDC Only User** | Salesforce license 없이 **WDC** 접근이 필요한 사용자용(WDC 기능엔 Chatter 활성화 필요) | PE·EE·UE·PE·Developer |
| **Unified Employee** | 회사 **전 직원용** — Slack·Experience Cloud site의 employee agent 접근. 기본 employee 프로파일에서 add-on으로 확장 | (자세한 사항은 공식 문서) |

### Salesforce Platform User License

| License Type | 여는 것 | 여는 것 아님(주의) |
|---|---|---|
| **Salesforce Platform** | Seat 기반. **커스텀 앱**(org 개발/AppExchange 설치) + 핵심 플랫폼: **accounts, contacts, reports, dashboards, documents, custom tabs**. Connect Offline·(활성화 시) Lightning Console 앱 사용 가능 | ❌ **forecasts, leads, campaigns, opportunities** 및 다수 표준 탭·오브젝트. 즉 **표준 CRM 기능은 제외** |

> **Salesforce vs Salesforce Platform 선택**: 표준 CRM(기회·리드·캠페인 등) 전 범위가 필요하면 **Salesforce**, 커스텀 앱 중심이고 CRM 오브젝트는 불필요하면 더 저렴한 **Salesforce Platform**.

> 통합 전용 사용자(Salesforce Integration license·API-Only)는 [[Integration User & API-Only User (통합 사용자)]]에서 최소권한 설계 패턴과 함께 상세히 다룬다.

---

## 2. Permission Set License (PSL) — user license 위에 가산

> "Permission set licenses entitle users to access additional features not included in their assigned user license. Users can be assigned any number of permission set licenses."

PSL은 **user license에 없는 기능을 추가로 여는 자격**이다. user license가 "최대 기능성의 상한"을 정하면, PSL은 그 상한을 **끌어올린다**.

- **동작 예:** Salesforce Platform user license 사용자에게 **Lightning Console** 접근을 주려면 → **Lightning Console PSL** 을 구매·배정 → 이제 `Lightning Console User` 권한을 permission set로 부여 가능 → 사용자가 Lightning Console 앱 사용.
- **필수 조합:** 추가 기능을 실제로 쓰려면 사용자는 **(1) PSL 배정 + (2) 그 기능 권한을 담은 Permission Set** 를 **둘 다** 가져야 한다. 라이선스 없이 권한만 permission set로 할당하면 **assignment error**.
- 일부 PSL은 **auto-generated 표준 permission set** 와 함께 제공돼 관리가 쉬워진다.
- **예시 PSL:** `Sales Console User`(Salesforce Console for Sales 접근에 필요), `Salesforce API Integration`(통합 사용자에 표준 오브젝트 permission set 할당), Lightning Console 등.

> PSL과 permission set의 역할 분리: **PSL = 기능 상한을 올림**, **permission set = 그 안에서 실제 권한 부여**. 상세는 [[Permission Sets (권한 집합)]] 참조.

---

## 3. Feature License — 사용자별 개별 기능 활성화

> "A feature license entitles a user to access an additional feature that isn't included with his or her user license, such as Marketing or WDC. Users can be assigned any number of feature licenses."

Feature license는 사용자 레코드에서 **체크박스 하나로 개별 기능을 켠다**(사용자 생성·편집 시). 여러 개 배정 가능.

### Available Feature Licenses (공식 전수)

| Feature License | 사용자가 할 수 있게 되는 것 |
|---|---|
| **Marketing User** | 캠페인 생성·편집·삭제, 고급 캠페인 설정, Data Import Wizard로 캠페인 멤버 추가·상태 갱신 |
| **Knowledge User** | Salesforce Knowledge 접근 |
| **Flow User** | Flow 실행(Run flows) |
| **Service Cloud User** | **Salesforce Console for Service** 접근 (※ Console for **Sales** 는 `Sales Console User` **PSL** 필요) |
| **Salesforce CRM Content User** | Salesforce CRM Content 접근 |
| **Chat User** | Chat 접근 |
| **Chatter Answers User** | Chatter Answers 접근(Chatter Answers self-register 고volume 포털 사용자에 자동 배정) |
| **Offline User** | Connect Offline 접근 |
| **Site.com Contributor User** | Site.com Studio에서 사이트 콘텐츠 편집 |
| **Site.com Publisher User** | Site.com Studio에서 웹사이트 생성·스타일·레이아웃·콘텐츠 편집 |
| **WDC User** | WDC 오브젝트·권한 접근 |

가용 에디션: Professional·Enterprise·Performance·Unlimited·Developer.

---

## 소진·할당량 확인 — Company Information

구매한 라이선스 개수와 **사용량(used/total)** 은 **Setup → Company Information** 페이지에서 확인한다. User License·Permission Set License·Feature License가 각각 별도 관련 리스트로 표시된다. (Setup 라벨은 릴리스에 따라 다를 수 있음 — 2026-07-11 기준.)

- 사용자를 **deactivate** 하면 점유하던 user license가 **반환**되어 재사용 가능하다([[Users (사용자 관리)]] 참조). **freeze** 는 로그인만 막고 라이선스는 반환하지 않는다.
- 구매 후 **라이선스 이름**(SKU 이름 아님)이 Company Information에 나타난다. 더 이상 구매 불가하지만 지원되는(legacy) 라이선스도 함께 나열된다.

```text
// 구조 예시 — 3층 라이선스 조립(실제 화면 아님)
User "Rep A"
├─ User License:  Salesforce            ← 정확히 1개(배타), CRM 기준선
├─ Permission Set License: Sales Console User   ← 가산, Console for Sales 상한 개방
│    └─ + Permission Set (Sales Console User 권한 포함)   ← 실제 권한 부여
└─ Feature License: Marketing User (체크박스)   ← 가산, 캠페인 기능 활성화

확인: Setup → Company Information → (User/Permission Set/Feature) Licenses 사용량
```

---

## 관련 노트
- [[Users (사용자 관리)]] — 사용자 생성 시 user license 배정, deactivate로 라이선스 반환
- [[Integration User & API-Only User (통합 사용자)]] — Salesforce Integration license(무료 5개)·`Salesforce API Integration` PSL 실제 적용 사례
- [[Permission Sets (권한 집합)]] — PSL과 짝을 이뤄 실제 권한을 부여하는 그릇
- [[Profiles (프로파일)]] — user license와 함께 배정하는 권한·기본값 그릇
- [[Company Information & Fiscal Year (회사 정보·회계연도)]] — 라이선스 사용량 확인 위치
