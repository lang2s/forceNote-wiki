---
tags: [security, permissions, object-permissions, crud, view-all, modify-all, access-control]
source: help.salesforce.com (Salesforce Help — Manage Users and Data Access; Object Permissions; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=platform.users_profiles_object_perms.htm&type=5
created: 2026-07-03
aliases: [Object Permissions, 오브젝트 권한, CRUD, Create Read Edit Delete, View All Records, Modify All Records, View All Fields, Object Access]
---

# Object Permissions (오브젝트 권한 — CRUD·View All·Modify All)

> 오브젝트별로 레코드를 create·read·edit·delete 하는 **base-level 접근**을 정하는 권한. CRUD는 공유(sharing)를 **존중(respect)**하고, View All/Modify All Records는 공유를 **무시(override)**한다.

---

## 개념

Object permissions는 각 오브젝트에 대해 사용자가 레코드를 create·read·edit·delete 할 수 있는 **base-level access(기본 수준 접근)** 를 지정한다. 즉 "이 사용자가 이 오브젝트 타입의 레코드를 다룰 수 있는가"를 결정하는 가장 밑바닥의 권한 계층이다.

- **Available in:** Salesforce Classic + Lightning Experience
- **Editions:** Professional, Enterprise, Performance, Unlimited, Developer, Database.com
- **권장 관리 방법:** object 권한은 **permission set**과 **permission set group**으로 관리하는 것을 권장한다. (profile에도 존재하나 permission set 기반 관리가 권장 흐름)

핵심 성질은 **object 권한이 sharing rules·settings를 존중(respect)하거나 무시(override)** 한다는 점이다. CRUD 계열은 공유를 존중하고, View All / Modify All Records는 공유를 넘어선다. 이 respect/override 구분이 이 권한을 이해하는 가장 중요한 축이다.

---

## 권한 표 (전수)

| Permission | Description | Sharing |
|---|---|---|
| **Read** | Users can only view records of this type. (레코드 조회만) | Respects sharing |
| **Create** | Users can read and create records. (읽기 + 생성) | Respects sharing |
| **Edit** | Users can read and update records. (읽기 + 수정) | Respects sharing |
| **Delete** | Users can read, edit, and delete records. (읽기 + 수정 + 삭제) | Respects sharing |
| **View All Records** | Users can view **all** records associated with this object, regardless of sharing settings. (공유 설정과 무관하게 해당 오브젝트의 **모든** 레코드 조회) | **Overrides sharing** |
| **Modify All Records** | Users can read, edit, delete, **transfer, and approve** all records associated with this object. (읽기·수정·삭제에 더해 **소유권 이전(transfer)·승인(approve)** 까지, 모든 레코드 대상) | **Overrides sharing** |
| **View All Fields** | Users can view all fields and field data in records of this type, regardless of assigned **field-level security**. (할당된 필드 수준 보안과 무관하게 모든 필드·필드 데이터 조회) | Respects sharing |

### CRUD의 누적 관계

Read → Create → Edit → Delete 는 **누적적(cumulative)** 이다. 상위 권한이 하위를 포함한다.

- **Read** = 조회
- **Create** = read + create
- **Edit** = read + update
- **Delete** = read + edit + delete

즉 Delete 권한을 부여하면 그 오브젝트에 대한 read·edit·delete가 모두 가능하다.

### Modify All Records — 문서(documents)의 특이 케이스

문서(documents) 오브젝트에 대한 **Modify All Records**는 모든 공유 폴더 및 공개(public) 폴더에 대한 접근을 허용한다. **단, 비공개(private) 폴더는 제외**한다.

---

## respect / override 관계도

```
// 구조 예시 — 오브젝트 권한과 공유의 관계(실제 원본 다이어그램 아님)
Read/Create/Edit/Delete ──respects──▶ Sharing(OWD·공유 규칙)이 접근 범위 제한
View All Records / Modify All Records ──overrides──▶ Sharing 무시, 모든 레코드
View All Fields ──overrides──▶ Field-Level Security 무시(단 Sharing은 존중)
```

- **CRUD (Read/Create/Edit/Delete):** sharing을 **존중**한다. 오브젝트 권한이 있어도 실제로 볼 수 있는 레코드 범위는 OWD·공유 규칙 등 레코드 수준 공유가 결정한다.
- **View All Records / Modify All Records:** sharing을 **무시**한다. 공유 설정과 무관하게 해당 오브젝트의 모든 레코드에 접근한다.
- **View All Fields:** **field-level security를 무시**하고 모든 필드를 조회한다. 다만 이 권한은 **sharing 자체는 존중**하므로, 볼 수 있는 레코드 범위는 여전히 공유가 제한한다.

---

## master-detail 관계 주의 (Note)

profile 또는 permission set에서 어떤 오브젝트(예: Account)가 다른 오브젝트와 **master-detail 관계**에 있을 때, object 권한이 서로 **상호작용**한다. 구체 규칙은 공식 문서에서 확인해야 하며, 확인된 범위를 넘어선 세부 동작은 여기서 추측하지 않는다.

> 위 문장은 공식 문서 Note의 요약이다. master-detail 상호작용의 정확한 규칙은 official_doc을 참조.

---

## Object Access 뷰

**Object Access** 화면에서는 어떤 permission set·permission set group·profile이 특정 오브젝트에 대한 접근을 부여하는지 확인할 수 있다. 특정 오브젝트 권한이 어디에서 왔는지 역추적할 때 사용한다.

---

## 주의 — 오브젝트별 권한 vs 시스템 권한

⚠️ **View All Records / Modify All Records는 sharing을 무시**하므로 사용자에게 폭넓은 접근을 부여한다.

이 두 권한은 **오브젝트별(per-object)** 권한이라는 점이 중요하다. org 전체에 걸쳐 모든 데이터에 적용되는 **"View All Data" / "Modify All Data"** 는 별개의 **시스템 권한(system permission)** 이며, 이는 사용자·시스템 권한 노트에서 다룬다.

| 구분 | 적용 범위 | 성격 |
|---|---|---|
| View All Records / Modify All Records | **특정 오브젝트** | object permission |
| View All Data / Modify All Data | **org 전체 모든 데이터** | system permission |

---

## 관련 노트
- [[Salesforce 권한 모델 개요]] — 권한 시리즈 허브
- [[조직 전체 공유 기본값(OWD)과 공유 규칙]] — CRUD가 respect하고 View All/Modify All이 override하는 레코드 수준 공유
- [[CanTheUser]] — Apex에서 object CRUD 권한을 코드로 점검
- [[Permission Sets (권한 집합)]] — object 권한을 담아 관리하는 권장 그릇
- [[Field-Level Security (FLS, 필드 수준 보안)]] — 오브젝트 수준 vs 필드 수준 (짝). "View All Fields"가 FLS를 override
- [[User and System Permissions (사용자·시스템 권한)]] — "Records"(오브젝트별) vs "Data"(시스템 전역) 구분
