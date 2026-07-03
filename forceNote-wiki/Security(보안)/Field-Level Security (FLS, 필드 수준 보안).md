---
tags: [security, permissions, field-level-security, fls, access-control]
source: help.salesforce.com (Salesforce Help — Manage Users and Data Access; Field Permissions; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=platform.users_profiles_field_perms.htm&type=5
created: 2026-07-03
aliases: [Field-Level Security, FLS, 필드 수준 보안, Field Permissions, 필드 권한, Read-Only field, Visible]
---

# Field-Level Security (FLS, 필드 수준 보안)

> 오브젝트의 각 필드를 사용자가 **볼 수(view)/편집할 수(edit)** 있는지 정하는 보안. 페이지 레이아웃이 "배치"라면 FLS는 API·리포트·리스트뷰까지 전 채널을 막는 "보안 경계"다.

---

## 정의

**Field permissions**(= **field-level security**, FLS)는 오브젝트의 각 필드에 대해 사용자가 **볼 수(view) 있는지, 편집할 수(edit) 있는지**를 지정하는 보안이다.

> 원문: *"Field permissions, or field-level security, lets you specify whether users can view or edit each field for an object."*

오브젝트 권한(CRUD)이 "레코드 전체"에 대한 접근을 정한다면, FLS는 그 레코드 안의 **개별 필드 단위**로 접근을 좁힌다. FLS는 **permission set·permission set group으로 관리하는 것이 권장**된다.

**Available in:** Salesforce Classic + Lightning Experience. Professional, Enterprise, Performance, Unlimited, Developer, Database.com editions.

---

## FLS가 필드 가시성을 통제하는 범위 (전 채널)

FLS로 필드를 숨기면 그 필드는 다음 **모든 채널**에서 가려진다. 페이지 레이아웃과 달리 UI 한 곳이 아니라 데이터에 접근하는 전 경로를 막는 것이 핵심이다.

- Detail and edit pages (상세·편집 페이지)
- Related lists (관련 목록)
- List views (리스트 뷰)
- Reports (리포트)
- Connect Offline
- Email and mail merge templates (이메일·메일 병합 템플릿)
- Custom links (커스텀 링크)
- Experience Cloud sites and portals (Experience Cloud 사이트·포털)
- Synchronized data (동기화 데이터)
- Imported data (가져온 데이터)
- Salesforce APIs (Salesforce API)

> 이것이 페이지 레이아웃과의 결정적 차이다. 레이아웃에서 필드를 빼도 API·리포트·리스트뷰 등으로는 여전히 보일 수 있지만, **FLS로 숨기면 위 채널 전부에서 가려진다.**

---

## 접근 레벨 (3단계)

FLS로 지정 가능한 접근은 3단계다. 주의할 점은 **동일한 접근인데도 UI에 따라 레이블이 다르다**는 것 — permission set·enhanced profile UI와 원본 profile·field-level security UI에서 표기가 갈린다.

| 접근 | Permission Sets · Enhanced Profile UI | Original Profile · Field-Level Security UI |
|---|---|---|
| 필드 읽기 + 편집 | **Read** and **Edit** | **Visible** |
| 필드 읽기만 (편집 불가) | **Read** | **Visible** and **Read-Only** |
| 읽기·편집 모두 불가 | **None** | **None** |

- 예를 들어 "읽기 전용"을 만들려면 permission set UI에서는 **Read만** 체크하고, 원본 FLS UI에서는 **Visible + Read-Only**를 함께 체크한다 — 결과는 동일하다.
- "None"은 양쪽 UI에서 표기가 같으며, 사용자에게 필드가 완전히 가려진다.

---

## FLS vs 페이지 레이아웃 (역할 구분)

FLS와 페이지 레이아웃은 자주 혼동되지만 역할이 다르다.

- **접근을 제한(restrict)하는 것 = FLS**
- **필드를 detail/edit 페이지에 배치(organize)하는 것 = page layout**

> 원문: *"Use field-level security to restrict users' access to fields, and then use page layouts to organize [detail and edit pages]."*

즉 순서는 **FLS로 접근을 먼저 제한한 뒤, page layout으로 배치**한다. 레이아웃에서 필드를 제거해도 API 등 다른 채널로는 필드가 노출될 수 있으므로, **진짜로 숨기려면 반드시 FLS를 써야 한다.**

```
// 구조 예시 — FLS와 페이지 레이아웃의 구분(실제 원본 다이어그램 아님)
Field-Level Security (보안 경계) ──▶ 전 채널 차단: UI·API·Report·List View·Export
Page Layout (표현/배치)         ──▶ 레코드 페이지에서 필드 배치·표시 (API 접근은 못 막음)
규칙: FLS로 접근 제한 → page layout으로 배치
참고: Object 권한의 "View All Fields"는 FLS를 override(무시)
```

### 함께 쓰는 커스터마이즈 도구

- **Page layout** — 필드를 상세·편집 페이지의 어디에 배치할지 결정
- **Search layout** — 검색 결과·lookup 대화상자에 표시할 필드 결정

---

## 주의 사항 (Note)

- **Roll-up summary 필드와 formula 필드**는 detail 페이지에서 **read-only**이며, edit 페이지에는 아예 나타나지 않는다.
- **relationship group wizard**는 FLS와 무관하게 레코드 생성·편집을 허용한다.

---

## Field accessibility (필드 접근성 확인)

특정 필드의 접근이 제한되었는지, 그리고 **어느 레벨에서 제한되었는지**를 확인할 수 있다.

- 제한이 걸릴 수 있는 레벨: **record type · user profile · permission set**
- **field accessibility grid**에서 각 필드의 접근성을 확인하고, **page layout 수준** 또는 **field-level security 수준**에서 접근성을 변경할 수 있다.

---

## 관련 노트
- [[Salesforce 권한 모델 개요]] — 권한 시리즈 허브
- [[Object Permissions (오브젝트 권한 — CRUD·View All·Modify All)]] — "View All Fields"가 FLS를 override
- [[StripInaccessible]] — Apex에서 FLS/공유 위반 필드를 런타임에 제거
- [[Permission Sets (권한 집합)]] — FLS를 담아 관리하는 권장 그릇
