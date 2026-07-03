---
tags: [security, permissions, user-permissions, system-permissions, view-all-data, modify-all-data, access-control]
source: help.salesforce.com (Salesforce Help — Manage Users and Data Access; User Permissions + "View All" and "Modify All" Permissions Overview; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=platform.admin_userperms.htm&type=5
created: 2026-07-03
aliases: [User Permissions, System Permissions, App Permissions, 사용자 권한, 시스템 권한, View All Data, Modify All Data, View All Records, Modify All Records, View All Users, API Enabled]
---

# User and System Permissions (사용자·시스템 권한)

> 사용자가 **수행할 수 있는 작업과 접근할 수 있는 기능**을 정하는 권한. permission set·프로파일에서 App Permissions와 System Permissions 두 범주로 나뉘며, View All/Modify All Data 같은 관리자급 권한은 공유·오브젝트 권한을 무시(override)한다.

---

## 개요

**User permission**은 사용자가 무엇을 할 수 있고 어떤 기능에 접근할 수 있는지를 지정한다.

> 공식 정의: *"User permissions specify what tasks users can perform and what features users can access."*

예:
- **View Setup and Configuration** — Setup 페이지를 열람할 수 있다.
- **API Enabled** — 모든 Salesforce API에 접근할 수 있다.

- **Available in:** Salesforce Classic + Lightning Experience. 사용 가능한 user 권한의 종류는 **edition에 따라 다르다.**
- **두 범주:** permission set과 enhanced profile UI에서 user 권한은 **App Permissions**와 **System Permissions**로 분류된다.
- **의존성(dependency):** 일부 user 권한은 다른 user 권한 또는 object 권한과 **의존 관계**가 있다. 즉 한 권한을 켜려면 선행 권한이 필요할 수 있다.
- **활성화 위치:** user 권한은 **permission set**과 **custom profile**에서 활성화한다. Salesforce 권장 방식은 **permission set·permission set group**으로 관리하는 것이다. → [[Permission Sets (권한 집합)]]

### 권한과 설명 확인 경로

```
Setup → Quick Find "Permission Sets"
      → (permission set 선택)
      → App Permissions  /  System Permissions
```

각 권한 옆의 설명에서 해당 권한이 무엇을 허용하는지 확인할 수 있다.

---

## "View All" / "Modify All" 권한 패밀리

관리자급 광범위 접근을 부여하는 권한 묶음. 아래 표는 공식 문서의 *Permissions / Used for / Users who need them* 3열을 전수 반영한 것이다.

| 권한 | 용도 (Used for) | 필요한 사용자 |
|---|---|---|
| **View All Records / Modify All Records** | 특정 **오브젝트**의 모든 레코드를 보거나 수정 | 특정 오브젝트의 레코드를 관리하는 사용자 |
| **View All Fields** | 특정 **오브젝트**의 모든 필드와 필드 데이터를 열람 | 특정 오브젝트 필드에 폭넓은 view 접근이 필요한 사용자 |
| **View All Data / Modify All Data** | **조직 전체의 모든 데이터**를 관리 (data cleansing, deduplication, mass update 등). View All Data(또는 Modify All Data) 보유자는 모든 레코드를 보거나 수정할 수 있다 | 광범위 접근이 필요한 **조직 전체 관리자**. 배포용 메타데이터 접근만 필요하다면 대신 **Modify Metadata Through Metadata API Functions** 권한을 활성화할 수 있다 |
| **View All Fields (Global)** | **모든 오브젝트**의 필드와 필드 데이터를 열람 (오브젝트의 필드를 보려면 해당 오브젝트 접근도 함께 필요) | **Platform Integration User** 전용 |
| **View All Users** | 조직의 모든 사용자를 열람 (모든 사용자 레코드에 Read 부여) | 모든 사용자를 봐야 하는 사용자. user OWD가 Private일 때 유용하다 (User Sharing 필요) |
| **View All Lookup Record Names** | 모든 lookup·system 필드의 레코드 이름을 열람 | 레코드의 모든 정보(예: 참조된 레코드의 이름)를 봐야 하는 관리자·사용자 |

---

## Considerations (고려사항)

공식 문서의 고려사항 목록을 전수 반영한다.

- View All Data·Modify All Data와, 특정 오브젝트의 View All Records·Modify All Records는 서로 **상호작용**한다.
- profile 또는 permission set에서 **View All Data** 또는 **Modify All Data** user 권한을 활성화하면, 관련 권한이 **함께 적용**된다.
- 오브젝트 수가 많으면 View All Data / Modify All Data를 **활성·비활성화하는 데 시간이 걸릴 수 있다.**
- View All Records·Modify All Records는 **ideas, price books, articles** [등 일부 오브젝트]에는 제공되지 않는다.
- View All Records·Modify All Records는 **object 권한의 위임(delegation)만** 허용한다.
- 특정 오브젝트에 대한 View All Records가 그 오브젝트의 **표준 detail 페이지 접근을 자동으로 부여하지는 않는다.**
- **View All Users**는 조직에 **User Sharing**이 있을 때 제공된다 (사용자 가시성 제어).
- **View All Data, Modify All Data, View All Records/Modify All Records, View All Fields**는 **sharing을 무시(override)**한다.
- **View All Records**는 **Query All Files** 권한을 활성화하는 데 필요하다.

---

## 핵심 구분 — "Data" vs "Records" (혼동 주의)

가장 자주 혼동되는 지점이다. 이름이 비슷하지만 **적용 범위가 다르다.**

| 구분 | 범위 | 종류 | 다루는 노트 |
|---|---|---|---|
| **View All / Modify All Data** | **조직 전역 · 모든 오브젝트** | System 권한 | (이 노트) |
| **View All / Modify All Records** | **특정 오브젝트 1개** | Object 권한 | [[Object Permissions (오브젝트 권한 — CRUD·View All·Modify All)]] |

- **"Data"** = org 전체 (모든 오브젝트, 모든 공유를 무시)
- **"Records"** = 오브젝트 1개 (그 오브젝트 안에서만 공유를 무시)

### 범위 개념도

```
// 구조 예시 — View All/Modify All 범위(실제 원본 다이어그램 아님)
오브젝트 1개 범위:  View All Records / Modify All Records / View All Fields
조직 전역 범위:     View All Data / Modify All Data   (모든 오브젝트·모든 공유 무시)
전 오브젝트 필드:   View All Fields (Global)          (Platform Integration User 전용)
사용자 가시성:      View All Users                    (User Sharing 필요)
```

이 권한들은 [[조직 전체 공유 기본값(OWD)과 공유 규칙]]으로 설정된 레코드 공유를 무시하므로, 부여 시 최소 권한 원칙에 특히 유의해야 한다.

---

## 관련 노트
- [[Salesforce 권한 모델 개요]] — 권한 시리즈 허브
- [[Object Permissions (오브젝트 권한 — CRUD·View All·Modify All)]] — "Records" 범위(오브젝트별) 권한
- [[조직 전체 공유 기본값(OWD)과 공유 규칙]] — View All/Modify All이 무시(override)하는 레코드 공유
- [[Permission Sets (권한 집합)]] — user/system 권한을 담는 권장 그릇
