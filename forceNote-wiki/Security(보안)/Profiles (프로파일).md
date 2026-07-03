---
tags: [security, permissions, profiles, access-control, admin]
source: help.salesforce.com (Salesforce Help — Manage Users and Data Access; Profiles; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=platform.admin_userprofiles.htm&type=5
created: 2026-07-03
aliases: [Profiles, 프로파일, Standard Profile, Custom Profile, Minimum Access - Salesforce, User License, Login Hours, Login IP Ranges]
---

# Profiles (프로파일)

> 사용자에게 **기본 설정(default)**을 부여하는 그릇. 사용자당 정확히 하나 배정되며 user license type 1개에 묶인다. 오늘날은 최소 권한 프로파일 + permission set 조합이 권장된다.

---

## 정의

> "Profiles define default settings for users. When you create users, you assign a profile to each one."

프로파일은 사용자의 **기본 설정(default settings)** 을 정의한다. 사용자를 생성할 때 각 사용자에게 프로파일을 배정하며, **모든 사용자는 프로파일을 정확히 하나** 가진다.

- **Every profile belongs to exactly one user license type.** 즉 프로파일 1개는 user license type 1개에 묶인다. 프로파일에 배정할 수 있는 사용자는 그 license type을 가진 사용자로 한정된다.

### Available in

| 항목 | 지원 에디션 |
|---|---|
| **Profiles** | Salesforce Classic + Lightning Experience — Essentials, Professional, Enterprise, Performance, Unlimited, Developer, Database.com |
| **Custom Profiles** | Essentials, Professional, Enterprise, Performance, Unlimited, Developer |

> Custom Profiles는 Database.com에서 제공되지 않는다(Profiles 자체는 Database.com 포함).

---

## Standard vs Custom Profile

| 구분 | 설명 |
|---|---|
| **Standard profiles** | org에 여러 표준 프로파일이 기본 포함된다. 편집 가능한 설정 수가 **제한적**이다. |
| **Custom profiles** | API로 생성하거나, 기존 프로파일을 **clone**해 커스터마이즈한다. |

> [!note] Best practice — 최소 권한 원칙
> 가능하면 사용자에게 **Minimum Access - Salesforce** 프로파일(또는 그 clone)을 배정하고, 필요한 접근은 **permission set**으로 부여한다(최소 권한, least privilege). 프로파일은 기본값 관리에 집중시키고, 권한 부여는 permission set으로 확장하는 방식이 권장된다.

---

## 프로파일이 관리하는 것

프로파일은 **기본값(default)** 을 담는 그릇이다. 아래 항목 중 일부는 프로파일 전용이고, 나머지는 프로파일에도 담을 수 있으나 permission set 사용이 권장된다.

### 기본값 / 프로파일 전용

| 설정 | 성격 |
|---|---|
| Assigned apps | 기본(default) |
| Record type assignments | 기본(default) |
| **Page layout assignments** | **프로파일 전용** |
| **Login hours** | **프로파일 전용** |
| **Login IP ranges** | **프로파일 전용** |

### 프로파일에 담을 수 있으나 permission set 권장

- Object 권한
- Field 권한
- Tab settings
- User 권한 (app 권한 / system 권한)
- Custom permissions
- Apex class / Visualforce page access

> 이들은 프로파일에도 설정 가능하지만, 프로파일은 **기본값 관리에 집중**시키고 위 권한들은 permission set으로 부여하는 것이 권장된다. → [[Permission Set 설계]]

---

## Setup 경로 및 구조

```
// 구조 예시 — Setup 경로 표기(실제 동작 코드 아님)
Setup → Quick Find: "Profiles" → Profiles
  └ (표준/커스텀 프로파일) → Clone → 편집
     └ 기본값: Assigned Apps · Record Types · Page Layouts · Login Hours · Login IP Ranges
     └ 권한(권장: permission set): Object · Field · System · Custom Permissions · Apex/VF Access
```

---

## 관리 기능

- **Enhanced profile list views** (활성화 시): 프로파일 list view를 생성할 수 있고, list view에서 **여러 프로파일의 권한을 한 번에 변경**할 수 있다.
- **배정된 사용자 조회·관리:** 프로파일 overview 페이지에서 그 프로파일에 배정된 **모든 사용자를 조회·관리**한다.
- **Default experience:** 프로파일에 **default experience**(커뮤니티/사이트)를 연결할 수 있다.
- **검색 팁:** 프로파일 페이지에서 object / tab / permission / setting 이름을 찾으려면 이름의 **연속 3자 이상**을 입력해야 한다.

---

## 관련 노트
- [[Salesforce 권한 모델 개요]] — 권한 시리즈 허브(그릇·대상 격자, Profile vs Permission Set 역할)
- [[Permission Sets (권한 집합)]] — 기본값(profile) vs 추가 부여(permission set), 짝.
- [[Permission Set 설계]] — permission set 기반 접근 설계(프로파일 대신 권장되는 방식)
