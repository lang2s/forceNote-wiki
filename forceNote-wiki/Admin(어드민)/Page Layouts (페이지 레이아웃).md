---
tags: [admin, page-layouts, record-page, ui-customization, customization]
source: help.salesforce.com (Salesforce Help — Extend Salesforce with Clicks, Not Code; Page Layouts; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=platform.customize_layout.htm&type=5
created: 2026-07-03
aliases: [Page Layouts, 페이지 레이아웃, Enhanced Page Layout Editor, Mini Page Layout, Feed-Based Layout, Page Layout Assignment]
---

# Page Layouts (페이지 레이아웃)

> 레코드 페이지의 버튼·필드·관련 목록·Visualforce 등의 **배치와 구성**을 제어하는 도구. 필드 접근을 막는 FLS와 달리 레이아웃은 **표현(배치)**만 담당하며, 사용자가 보는 레이아웃은 프로파일(+레코드 타입)이 결정한다.

---

## 정의 — page layout이 제어하는 것

Page layout은 레코드 페이지에서 다음 요소들의 **배치(layout)와 구성(organization)**을 제어한다:

- **Buttons** (표준·커스텀 버튼)
- **Fields** (필드)
- **s-controls**
- **Visualforce** 페이지
- **Custom links** (커스텀 링크)
- **Related lists** (관련 목록)

Page layout은 field section 안에 s-control과 Visualforce 페이지를 **렌더링**할 수 있다.

> 핵심 구분: page layout은 요소의 **배치·구성**만 담당한다. 어떤 필드에 사용자가 접근할 수 있는지는 page layout이 아니라 **field-level security**가 통제한다. (아래 [FLS와의 구분](#fls와의-구분-배치-vs-접근) 참조)

---

## Available in (에디션·인터페이스)

| 기능 | 지원 범위 |
|---|---|
| Page layout **사용** | All editions (모든 에디션) |
| Page layout **생성·삭제** | Professional, Enterprise, Performance, Unlimited, Developer |
| 인터페이스 | Salesforce Classic **및** Lightning Experience (LEX) |

---

## 두 가지 편집기

Salesforce는 page layout 편집을 위해 두 편집기를 제공한다.

| 편집기 | 특징 | 활성화 |
|---|---|---|
| **Enhanced page layout editor** | 기본 편집기, **drag-and-drop** 방식 | 기본 제공 |
| **Original page layout editor** | 원래(구) 편집기 | **User Interface 설정**에서 활성화 |

두 편집기 모두 page layout 안의 field section에 s-control·Visualforce 페이지를 배치할 수 있다.

---

## Mini page layout

**Mini page layout**은 page layout **안에서** 접근한다. hover(마우스 오버) 뷰와 콘솔의 미니 뷰(mini view)에 표시할 **필드를 정의**한다.

---

## 기본 레이아웃 (default page layout)

**커스텀 오브젝트를 생성하면** Salesforce가 해당 오브젝트에 대한 **default page layout을 자동으로 생성**한다. 즉, 새 커스텀 오브젝트는 항상 최소 1개의 page layout을 가진 상태로 시작한다.

---

## 레이아웃 할당 (Page Layout Assignment)

Page layout을 정의한 뒤에는 **사용자에게 어떤 레이아웃을 보여줄지 할당**한다.

- **사용자의 프로파일(profile)**이 그 사용자가 어떤 page layout을 보는지 결정한다.
- **레코드 타입을 사용하는 경우**, 표시되는 레이아웃은 **프로파일 + 레코드 타입의 조합(Profile × Record Type)**이 결정한다.

```
// 구조 예시 — Page Layout 할당(실제 원본 다이어그램 아님)
사용자 → Profile ─┐
                   ├─▶ Page Layout Assignment ─▶ 표시되는 레이아웃
Record Type ──────┘   (레코드 타입 사용 시 Profile × Record Type)
편집기: Enhanced(기본, drag&drop) | Original(User Interface에서 활성화)
구분: 배치=Page Layout · 필드 접근=Field-Level Security
```

---

## 커스터마이즈할 수 있는 대상

Page layout 편집을 통해 다음을 커스터마이즈한다.

- **Related lists (관련 목록)** — 표시할 버튼, 표시 컬럼, 컬럼 순서, 정렬(sort) 순서
- **버튼** — 표시할 표준(standard) 및 커스텀(custom) 버튼
- **Mobile Cards 섹션** — expanded lookup, component, Visualforce 페이지 배치
- **Feed-based page layout** — **피드 뷰(feed view)와 상세 뷰(detail view)** 2개로 분리된 레이아웃
- **Home 탭 커스터마이즈** — (Salesforce Classic)

---

## FLS와의 구분 (배치 vs 접근)

| 구분 | 담당 도구 | 통제 대상 |
|---|---|---|
| **배치·구성** | **Page layout** | 요소를 어디에·어떻게 배치할지 |
| **필드 접근 통제** | **Field-level security (FLS)** | 사용자가 필드에 접근할 수 있는지 |

> ⚠️ page layout에서 필드를 **빼도** 필드 접근 자체가 막히는 것은 아니다. 필드 접근을 실제로 제한하려면 **FLS**로 통제해야 한다. 레이아웃은 어디까지나 **표현(배치)**만 담당한다.

---

## 관련 노트
- [[Record Types (레코드 타입)]] — 프로파일 × 레코드 타입으로 표시 레이아웃 결정
- [[Field-Level Security (FLS, 필드 수준 보안)]] — 필드 접근 통제 (레이아웃은 배치만 담당)
- [[Profiles (프로파일)]] — 사용자가 어떤 레이아웃을 볼지 결정
- [[Compact Layouts (컴팩트 레이아웃)]] — 핵심 필드만 하이라이트 패널·모바일에 요약 표시
- [[Custom Buttons & Links (커스텀 버튼·링크)]] — 버튼·링크를 배치하는 대상 레이아웃
