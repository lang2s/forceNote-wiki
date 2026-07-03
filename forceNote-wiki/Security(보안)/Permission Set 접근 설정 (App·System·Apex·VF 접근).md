---
tags: [security, permissions, permission-sets, apex-class-access, visualforce-page-access, setup-entity-access]
source: help.salesforce.com (Salesforce Help — Manage Users and Data Access; App and System Settings in Permission Sets + Permissions and Access Settings 매트릭스; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=platform.perm_sets_about_app_and_system.htm&type=5
created: 2026-07-03
aliases: [App Settings, System Settings, Apex Class Access, Visualforce Page Access, Setup Entity Access, Connected App Access, External Data Source Access, 접근 설정]
---

# Permission Set 접근 설정 (App·System·Apex·VF 접근)

> permission set의 권한·설정은 **App**과 **System** 두 범주로 조직된다. 오브젝트/필드 권한 외에 Apex 클래스·Visualforce 페이지·외부 데이터소스·connected app 실행/접근을 여는 "접근 설정(access settings)"이 여기에 담긴다.

---

## 개요 — App and System 두 범주

Salesforce 공식 문서(*App and System Settings in Permission Sets*)에 따르면:

> "In permission sets, permissions and settings are organized into **app and system categories**."

이 두 범주는 사용자가 시스템 리소스와 앱 리소스를 관리·사용하는 데 필요한 권리(rights)를 반영한다. 즉 permission set overview 페이지에서 만나는 모든 권한·설정은 **App** 또는 **System** 중 하나로 분류된다.

**Available in:** Salesforce Classic + Lightning Experience.
Essentials, Contact Manager, Professional, Group, Enterprise, Performance, Unlimited, Developer, Database.com.

---

## App Settings — 앱 관련 설정

Apps는 사용자가 **헤더 드롭다운**으로 전환하는 **탭 묶음(sets of tabs)**이다. 사용자는 서로 다른 앱 사이를 전환하며 각기 다른 탭 집합을 사용한다.

permission set overview 페이지의 **Apps 섹션**은 앱과 직접적으로 연관된 설정을 담는다:

- **Assigned Apps** — 사용자가 접근할 수 있는 앱
- **Tab Settings** — 앱과 함께 표시되는 탭 설정
- 앱과 연관된 **Object 권한 · Field 권한 · App Permissions**

즉, 오브젝트/필드 수준의 데이터 권한도 앱 컨텍스트와 연관되어 App Settings 아래에서 관리된다.

---

## System Settings — 조직 전체 시스템 설정

일부 시스템 기능은 단일 앱에 국한되지 않고 **조직 전체(entire organization)**에 적용된다. 예:

- **"View Setup and Configuration"** — Setup 페이지 열람 권한. 특정 앱이 아니라 조직 전반에 걸친 시스템 기능이다.

이런 **System Permissions**와 함께, **접근 설정(access settings)** 도 System Settings 범주에 속한다. 대표적으로 **Apex class access**와 **Visualforce page access** 가 여기에 담긴다.

---

## 접근 설정 (Access Settings)

permission set(및 profile)이 부여할 수 있는 접근 설정 항목은 다음과 같다(권한 모델 허브 매트릭스 기준):

| 접근 설정 | 부여 대상 |
|---|---|
| **Apex class access** | 사용자가 **실행 가능한 Apex 클래스** |
| **Visualforce page access** | 사용자가 **접근 가능한 Visualforce 페이지** |
| **External data source access** | 외부 데이터소스 접근 |
| **Connected app access** | connected app 접근 |
| **Legacy SAML service provider access** | connected app으로 만들지 않은 레거시 SAML 서비스 제공자 접근 |

이 항목들은 **profile과 permission set 양쪽 모두에서 지정 가능**하지만, 공식 문서는 **permission set으로 관리하는 것을 권장**한다.

### Setup Entity Access 개념

- **Apex class access** 는 사용자가 실행할 수 있는 Apex 클래스를 지정한다.
- **Visualforce page access** 는 사용자가 접근할 수 있는 VF 페이지를 지정한다.

즉, 어떤 **Setup 엔티티(setup entity)** 에 접근할지를 permission set 또는 profile을 통해 부여하는 것이다.

---

## 설정 범주 트리

```
// 구조 예시 — Permission Set 설정 범주(실제 원본 다이어그램 아님)
Permission Set
 ├─ App Settings
 │    ├─ Assigned Apps · Tab Settings
 │    └─ (앱 연관) Object 권한 · Field 권한 · App Permissions
 └─ System Settings
      ├─ System Permissions (예: View Setup and Configuration)
      └─ 접근 설정(Setup Entity Access):
           Apex Class Access · Visualforce Page Access
           External Data Source Access · Connected App Access
           Legacy SAML Service Provider Access
```

---

## 관련 노트
- [[Salesforce 권한 모델 개요]] — 권한 시리즈 허브(접근 설정 매트릭스 원본)
- [[Permission Sets (권한 집합)]] — 이 접근 설정을 담는 그릇
- [[User and System Permissions (사용자·시스템 권한)]] — System Settings에 함께 담기는 system 권한
