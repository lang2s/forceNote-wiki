---
tags: [admin, user-management, setup, login-access, login-as-user, security]
source: help.salesforce.com (Salesforce Help — Enable User Access Policies(User Management Settings) / Control Login Access Policies / Enhanced Profile User Interface; 라이브 공식 문서, Tier 2, 접속 2026-07-11)
official_doc: https://help.salesforce.com/s/articleView?id=xcloud.controlling_login_access.htm&type=5
created: 2026-07-11
aliases: [User Management Settings, 사용자 관리 설정, Login Access Policies, 로그인 액세스 정책, Login as user, 사용자로 로그인, Grant Login Access, 로그인 대행, Administrators Can Log in as Any User]
---

# User Management Settings · Login Access Policies (사용자 관리 설정·로그인 대행)

> **User Management Settings**는 다른 사용자 관리 기능들을 켜는 상위 토글 페이지이고, **Login Access Policies**는 관리자·지원사에게 다른 사용자 계정으로 **로그인 대행(log in as)**을 허용하는 정책 페이지다. 두 페이지 모두 Setup의 사용자 관리 영역에 있다.

---

## 1. User Management Settings — 전제 활성화 허브

Setup → Quick Find에 **User Management Settings** 입력 → **User Management Settings** 선택. 이 페이지는 자체 기능이라기보다, **다른 사용자 관리 기능들을 활성화(전제 조건 on/off)하는 토글 모음**이다.

여기서 켜는 주요 설정:

| 설정 | 켜면 활성화되는 것 | 필요 권한 |
|---|---|---|
| **User Access Policies** | 규칙 기반 액세스 자동 프로비저닝 기능 → [[User Access Policies (사용자 액세스 정책)]] | Manage Users |
| **Enhanced Interface for User Access Policies** | UAP 켜면 자동 활성화(권장 유지) | — |
| **Enhanced Profile User Interface** | profile을 탐색·검색·편집하는 streamlined UI. 켜면 **Enhanced Profile List Views**(list view에서 최대 200개 profile 일괄 편집)도 사용 가능 | Customize Application |

```text
// 구조 예시 — 실제 Setup 화면 아님
Setup > User Management Settings
  [x] User Access Policies                         (Manage Users)
  [x] Enhanced Interface for User Access Policies   (UAP와 함께 자동 on)
  [ ] Enhanced Profile User Interface               (Customize Application)
        └ 켜면 Enhanced Profile List Views 사용 가능
```

> [!note] Enhanced Profile User Interface 제약
> 조직이 IE6를 쓰거나, site guest profile에 category group을 적용하거나, partner portal 관리를 portal 사용자에게 위임한 경우 사용할 수 없다.

---

## 2. Login Access Policies — 로그인 대행 정책

Setup → Quick Find에 **Login Access Policies** 입력 → **Login Access Policies** 선택. 관리자·지원사(Salesforce Support·managed package publisher)가 **다른 사용자로 로그인**하는 것을 허용/제한하는 정책이다.

필요 권한: **Manage Login Access Policies**.

### 2-1. 관리자의 사용자 로그인 대행

- 기본적으로 이 페이지의 설정을 통해 관리자가 조직 내 **아무 사용자로도(as any user) 사전 동의 없이 로그인**하도록 허용할 수 있다("Administrators Can Log in as Any User").
- 이 설정을 **제거(비활성화)하려면 Salesforce Support에 문의**해야 하며, 제거 후에는 사용자가 명시적으로 로그인 액세스를 grant해야 관리자가 로그인할 수 있다.
- **MFA 상호작용:** MFA가 켜져 있어도 관리자는 다른 사용자로 로그인할 수 있다. 예외 — 대상 사용자의 profile이 **High Assurance 세션**을 요구하는데 관리자가 표준 보안 세션을 쓰는 경우, MFA 챌린지를 위해 사용자와의 협조가 필요하다.

### 2-2. Publisher / Managed Package 로그인 액세스

- 각 managed package publisher에 대해 **"Available to Administrators Only"**를 선택하면, 일반 사용자는 그 publisher에게 로그인 액세스를 grant할 수 없고 **Manage Users 권한을 가진 관리자만** 승인할 수 있다.
- 조직 전체에 라이선스된 managed package에는 사용자가 로그인 액세스를 grant할 수 없다.
- 일부 managed package는 로그인 액세스 기능 자체가 없다.
- **Support Organization** 열은 각 managed package를 소유한 License Management Org를 식별한다.

### 2-3. Grant Login Access (사용자 측 동작)

로그인 대행이 사전 동의를 요구하도록 설정된 경우, 사용자는 문제 해결을 위해 관리자나 Salesforce Support에 **직접 로그인 액세스를 부여**한다.

- 개인 설정 → Quick Find에 **Grant** 입력 → **Grant Account Login Access**.
- **Access Duration** picklist에서 만료일 지정. 보안상 최대 부여 기간은 **1년**.
- 제약: 이 기능으로 일반 사용자에게 계정 접근을 부여할 수는 없다. System Administrator가 end user로 로그인한 뒤 그 사용자를 대신해 Salesforce Support에 로그인 액세스를 부여할 수 없다. "Organization Admins Can Log in as Any User"가 켜져 있어도, Salesforce Support는 관리자로 로그인한 상태에서 이를 이용해 다른 사용자에 접근할 수 없다.

---

## User Management Settings vs Login Access Policies

| | User Management Settings | Login Access Policies |
|---|---|---|
| 목적 | 다른 사용자 관리 기능 **활성화** 허브 | 사용자 계정 **로그인 대행** 허용/제한 |
| Setup 경로 | Quick Find "User Management Settings" | Quick Find "Login Access Policies" |
| 필요 권한 | Manage Users / Customize Application | Manage Login Access Policies |
| 대표 항목 | User Access Policies · Enhanced Profile UI | Administrators Can Log in as Any User · Available to Administrators Only |

---

## 관련 노트
- [[User Access Policies (사용자 액세스 정책)]] — 이 페이지에서 활성화하는 규칙 기반 프로비저닝 기능
- [[Users (사용자 관리)]] — 사용자 레코드·profile·라이선스 관리
- [[Permission Set Groups (권한 집합 그룹)]] — 권한 집합 그룹
- [[Delegated Administration (위임 관리)]] — 관리 업무 위임
- [[Session Settings (세션 설정)]] — High Assurance 세션 등 세션 보안 설정
