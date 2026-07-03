---
tags: [security, permissions, access-control, profiles, permission-sets, admin]
source: help.salesforce.com (Salesforce Help — Manage Users and Data Access; Permissions and Access Settings; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=platform.permissions_about_users_access.htm&type=5
created: 2026-07-03
aliases: [권한 모델, Permissions and Access Settings, 권한과 접근 설정, User Permissions, Object Permissions, Field Permissions, Profiles vs Permission Sets, grant not deny]
---

# Salesforce 권한 모델 개요

> Salesforce 권한은 "무엇을 허용하는가"(User·Object·Field·Custom 권한 + Apex/VF 등 접근 설정)를 "담는 그릇"(Profile·Permission Set·Permission Set Group)에 넣어 부여한다. 이 노트는 그 전체 격자와 grant-only 원칙을 정리하는 허브다.

---

## 개요 — 권한은 "그릇"에 담아 부여한다

User, object, and field permissions and access settings can be specified in **profiles and permission sets**. 즉, "무엇을 허용하는가"(권한·접근 설정)를 정의한 뒤, 이를 담는 그릇(profile / permission set)에 넣어 사용자에게 부여한다.

- **사용 가능 환경:** Salesforce Classic + Lightning Experience. 사용 가능한 권한·설정은 edition에 따라 다르다.
- **Permission sets available in:** Essentials, Contact Manager, Professional, Group, Enterprise, Performance, Unlimited, Developer, Database.com.

권한과 접근 설정이 정하는 것은 두 축으로 나뉜다.

| 축 | 무엇을 결정하는가 |
|---|---|
| **Permissions** | 사용자가 오브젝트 레코드에 접근하고 특정 작업을 수행하는 능력을 결정 |
| **Access settings** | Apex 클래스 접근, 앱 가시성 등 다른 기능을 결정 |

그릇의 배정 규칙:

- **모든 사용자는 profile을 하나만** 배정받는다.
- 반면 **permission set은 여러 개** 가질 수 있다 — 기본값 위에 추가 권한을 얹는 방식.

---

## 권한 모델 개념도

```
// 구조 예시 — 권한 모델 개념도(실제 원본 다이어그램 아님)
담는 그릇(Container)                무엇을 허용(Target)
  Profile (user당 1개, 기본값)  ─┐    ┌─ Object 권한 (CRUD + View All/Modify All)
  Permission Set (다중)         ─┼──▶ ┼─ Field 권한 (FLS)
  Permission Set Group          ─┘    ├─ User/System 권한 (View All Data 등)
  (+ Muting / Session-based)          ├─ Custom Permission
  ───────────────────────────         └─ 접근 설정(Apex/VF/앱/커넥티드앱)
  Record 수준은 별도 축: OWD·공유 규칙(→ 조직 전체 공유 기본값 노트)
```

Record(레코드) 수준 접근은 이 권한 격자와 **별개의 축**이다 — OWD와 공유 규칙이 담당하며 [[조직 전체 공유 기본값(OWD)과 공유 규칙]]에서 다룬다.

---

## 권한·설정 타입 매트릭스

각 권한/설정 타입이 Profile 또는 Permission Set에서 지정 가능한지, 그리고 어느 기능으로 관리하는 것이 권장되는지 전수 정리.

| Permission or Setting Type | In Profiles? | In Permission Sets? | Recommended Feature |
|---|:---:|:---:|---|
| Assigned apps | ✅ | ✅ | Profiles for default assigned apps, permission sets for additional assignments |
| Tab settings | ✅ | ✅ | Permission sets |
| Record type assignments | ✅ | ✅ | Profiles for default record types, permission sets for additional assignments |
| Page layout assignments | ✅ | ❌ | Profiles |
| Object permissions | ✅ | ✅ | Permission sets |
| Field permissions | ✅ | ✅ | Permission sets |
| User permissions (app and system) | ✅ | ✅ | Permission sets |
| Custom permissions | ✅ | ✅ | Permission sets |
| Apex class access | ✅ | ✅ | Permission sets |
| Visualforce page access | ✅ | ✅ | Permission sets |
| External data source access | ✅ | ✅ | Permission sets |
| Connected app access | ✅ | ✅ | Permission sets |
| Legacy SAML service provider access (not created via connected apps) | ✅ | ✅ | Permission sets |
| Login hours | ✅ | ❌ | Profiles |
| Login IP ranges | ✅ | ❌ | Profiles |

> ✅ = 해당 그릇에서 지정 가능 / ❌ = 지정 불가. **Page layout assignments · Login hours · Login IP ranges** 세 가지만 permission set에서 지정할 수 없고 profile 전용이다.

---

## 권한 종류 정의

- **User permissions**: 사용자가 수행할 수 있는 작업과 접근할 수 있는 기능을 지정한다.
  - 예: **View Setup and Configuration** → Setup 페이지 열람.
  - 예: **API Enabled** → 모든 Salesforce API 접근.
- **Object permissions**: 각 오브젝트에 대해 레코드를 create·read·edit·delete 하는 base-level 접근을 지정한다.
- **Field permissions (= field-level security)**: 오브젝트의 각 필드를 사용자가 view / edit 할 수 있는지 지정한다.
- **Custom permissions**: 사용자에게 커스텀 프로세스나 앱에 대한 접근을 부여한다.

### 권한 종속성(dependency)

일부 object 권한과 user(app·system) 권한은 서로 의존한다. 데이터 무결성을 보장하기 위한 것으로, 한 권한을 부여/해제할 때 종속된 다른 권한도 함께 영향을 받는다.

### grant-only 원칙 (거부는 불가)

> ⚠️ profiles · permission sets · permission set groups는 **접근을 부여(grant)할 뿐 거부(deny)할 수는 없다.**

이는 OWD/sharing과 동일한 **additive(누적) 모델**이다. 여러 그릇에서 부여된 권한은 합집합으로 적용되며, 어느 그릇도 다른 그릇이 준 권한을 빼앗지 못한다.

---

## Profile vs Permission Set — 역할 분담

| 그릇 | 주 용도 |
|---|---|
| **Profile** | default 설정 관리 — assigned apps · record types · page layouts 등 "기본값" |
| **Permission Set / Permission Set Group** | 권한·접근 설정 구성. **필드 권한 관리는 profile보다 permission set/PSG 사용이 강력 권장** |

권장 패턴: profile은 사용자당 하나뿐이라 최소한의 기본값만 담고, 추가 권한은 permission set / permission set group으로 조합해 부여한다. 이렇게 하면 profile 수를 줄이고 권한을 모듈처럼 재사용할 수 있다.

---

## 권한 시리즈 노트

이 허브가 라우터 역할을 한다. 권한을 담는 "그릇", 부여 "대상", 그릇의 세부 접근 설정으로 그룹핑한다.

- **그릇(권한을 담아 부여):** [[Profiles (프로파일)]] · [[Permission Sets (권한 집합)]] · [[Permission Set Groups (권한 집합 그룹)]] · [[Session-Based Permission Sets (세션 기반 권한 집합)]]
- **대상(무엇에 대한 권한인가):** [[Object Permissions (오브젝트 권한 — CRUD·View All·Modify All)]] · [[Field-Level Security (FLS, 필드 수준 보안)]] · [[User and System Permissions (사용자·시스템 권한)]] · [[Custom Permissions (커스텀 권한)]]
- **접근 설정(그릇 안의 App·System·Apex·VF 접근):** [[Permission Set 접근 설정 (App·System·Apex·VF 접근)]]

---

## 관련 노트
- [[조직 전체 공유 기본값(OWD)과 공유 규칙]] — 레코드 수준 접근(공유 모델). 이 허브의 "무엇을" 축 중 Record 층
- [[Permission Set 설계]] — permission set 기반 접근 설계 패턴
- [[레코드 액세스 설계 (Enterprise Scale)]] — 공유 재계산·대규모 접근 성능
- [[권한과 접근 제어 위협]] — 권한 오구성이 낳는 보안 위협(위협 관점)
- [[CanTheUser]] — Apex에서 object/field 권한을 코드로 점검
- [[StripInaccessible]] — FLS/공유 위반 필드를 런타임에 제거
