---
tags: [admin, ui, custom-buttons, override, standard-actions, visualforce, lightning-component]
source: help.salesforce.com (Override Standard Buttons and Tab Home Pages[platform.links_customize_override] · Standard Action Overrides[platform.standard_actions_overrides] · Considerations for Overriding[platform.links_override_considerations] · Remove Overrides[platform.links_customize_override_remove] · Viewing References[platform.links_viewing_references]; 라이브 공식 문서·브라우저 렌더, Tier 2, 접속 2026-07-19)
created: 2026-07-19
aliases: [Override Standard Buttons, 표준 버튼 재정의, 표준 액션 재정의, Standard Action Overrides, Tab Home Page Override, 탭 홈 재정의, Visualforce 버튼 재정의, Lightning component override, Where is this used, Viewing References]
---

# 표준 버튼·탭 홈 페이지 재정의 (Override Standard Buttons)

> 표준 버튼(New·View·Edit·Delete·Clone 등)과 탭 홈 페이지의 동작을 Salesforce Classic·Lightning Experience·모바일별로 s-control·Lightning 컴포넌트·Lightning 페이지·Visualforce로 재정의하는 방법 — 전역 재정의 동작·재정의 타입·제약.

---

## 개요

표준 버튼(New·View·Edit 등)의 동작을 **Salesforce Classic·Lightning Experience·모바일에서 독립적으로** 재정의할 수 있다. 또한 사용자가 표준·커스텀·external 오브젝트 탭을 클릭할 때 표시되는 **탭 홈 페이지**도 재정의할 수 있다.

**Required Editions**

- Available in: Salesforce Classic and Lightning Experience
- Available in: **Enterprise, Performance, Unlimited, and Developer Editions**
- Visualforce overrides also available in: **Contact Manager, Group, and Professional Editions**
- Record types available in: **Professional, Enterprise, Performance, Unlimited, and Developer Editions**

**User Permissions Needed**

- To override standard buttons and tab home pages: **Customize Application**
- To reset button and tab home page overrides: **Customize Application**

---

## 전역 재정의 동작 (Button overrides are global)

버튼 재정의는 **global** 하다. 예를 들어 Opportunity의 New 버튼을 재정의하면, 대체 액션이 그 액션이 사용 가능한 **모든 위치**에서 적용된다. 여기에는 다음이 포함된다.

- Opportunities home page
- 다른 오브젝트(예: accounts)의 모든 opportunities related lists
- Salesforce Classic 사이드바의 **Create New** 드롭다운 리스트
- 이 Salesforce 페이지에 대한 모든 브라우저 북마크

---

## 재정의 절차

```text
// 구조 예시 — 실제 동작 코드 아님 (Setup UI 흐름을 텍스트로 표현)
[오브젝트 관리 설정] → Buttons, Links, and Actions
        │
        ▼
[재정의할 버튼 / 탭 홈 페이지] 옆의 Edit 클릭
        │
        ▼
경험별(Salesforce Classic · Lightning Experience · mobile)로
재정의 타입 선택:
  ○ No override (use default)
  ○ Standard page
  ○ Custom s-control
  ○ Lightning component
  ○ Lightning page
  ○ Visualforce page
  ○ Use the Salesforce Classic override
        │
        ▼
실행할 s-control / Lightning component / Lightning page /
Visualforce page 이름 선택
        │
        ▼
Save
```

1. 재정의를 설정할 오브젝트의 object management settings에서 **Buttons, Links, and Actions** 로 이동한다.
2. 재정의할 버튼 또는 탭 홈 페이지 옆의 **Edit** 를 클릭한다.
3. 각 경험(Salesforce Classic·Lightning Experience·mobile)에 대해 해당 액션에 연결할 재정의 타입을 클릭한다. 몇 가지 옵션이 있다(아래 "재정의 타입" 참조).
   > **Important** 표준 버튼을 Lightning component 또는 Visualforce page로 재정의하기 전에, 각각의 developer guide에서 구현 세부사항을 검토한다.
4. 사용자가 버튼 또는 탭을 클릭할 때 실행할 s-control, Lightning component, Lightning page, 또는 Visualforce page의 이름을 선택한다.
5. 변경사항을 저장한다.

---

## 재정의 타입 (7종)

| 타입 | 동작 | 지원 경험 제약 |
|---|---|---|
| **No override (use default)** | 설치된 패키지가 제공하는 custom override를 사용. 설치된 것이 없으면 standard Salesforce behavior가 사용됨. | — |
| **Standard page** | (선택 시) standard Salesforce behavior가 사용됨. | **installed custom object의 액션을 재정의하는 subscribers에게만** 사용 가능 |
| **Custom s-control** | s-control의 동작 사용. | **mobile에서 미지원** |
| **Lightning component** | Lightning component의 동작 사용. | **Edit, New, New Event, Tab, and View 액션에만** 지원. **Salesforce Classic에서 미지원** |
| **Lightning page** | 오브젝트의 org default로 지정된 Lightning record page의 동작 사용. | **Lightning Experience의 View 액션에만** 사용 가능 |
| **Visualforce page** | Visualforce page의 동작 사용. | — |
| **Use the Salesforce Classic override** | Salesforce Classic Override 설정의 동작을 상속. | — |

> **Important (s-control)** Visualforce pages가 s-controls를 supersede(대체)한다. 이전에 s-controls를 사용하지 않은 조직은 s-control을 **새로 생성할 수 없다**. 기존 s-controls는 영향을 받지 않으며 계속 편집할 수 있다.

### New 버튼을 Visualforce로 재정의 — 레코드 타입 선택 스킵

New 버튼을 Visualforce page로 재정의할 때, **record type selection page를 스킵**하도록 선택할 수 있다. 스킵하면 새로 생성하는 레코드가 record type selection page로 forwarding되지 않는다. Salesforce는 해당 Visualforce page가 이미 레코드 타입을 처리한다고 가정한다.

> **Important (모바일 product 생성)** Salesforce mobile app 사용자가 **product**를 생성하기 위해 New를 클릭하면, Setup에서 Skip record type selection page 옵션이 선택되어 있더라도 사용자는 record type을 선택해야 한다.

> New 재정의 시 레코드 타입 선택 흐름 전반은 [[Record Types (레코드 타입)]] 참조.

---

## 모바일 / 제약 (Note)

> **Note** Visualforce page로 재정의된 표준 버튼(**New, Edit, View, Delete, and Clone**)은, 해당 Visualforce page가 Salesforce mobile apps용으로 활성화(enabled)되지 않으면 **Salesforce mobile app에 표시되지 않는다**. 표준 list 및 tab controls의 재정의는 **mobile에서 미지원**이다.

---

## 하위 심화 항목 (본문 미추출 — 공식 문서 참조)

아래 3개 leaf 항목은 이번 추출에서 본문이 확보되지 않았다. 덤프의 "IN THIS SECTION" 설명 1줄과 공식 문서 링크만 정직하게 안내한다(내용 창작 없음).

- **Standard Action Overrides** — For standard actions, such as Delete, Edit, List, New, Tab, and View, you can provide a custom user interface for the action, called an action override. Use action overrides when your business model requires a more customized user experience than the Salesforce standard page provides.
  → https://help.salesforce.com/s/articleView?id=platform.standard_actions_overrides.htm&type=5
- **Considerations for Overriding Standard Buttons** — Before you override a standard button, review these considerations.
  → https://help.salesforce.com/s/articleView?id=platform.links_override_considerations.htm&type=5
- **Remove Overrides for Standard Buttons and Tab Home Pages** — Remove applied overrides for standard buttons and links in Salesforce Classic, Lightning Experience, and the Salesforce mobile app.
  → https://help.salesforce.com/s/articleView?id=platform.links_customize_override_remove.htm&type=5

---

## Viewing References — "Where is this used?"

컴포넌트가 참조되는 Salesforce 내 **모든 영역의 목록**을 볼 수 있다. 예를 들어 Visualforce page나 static resource 같은 다른 컴포넌트를 참조하는 custom links, custom buttons, page layouts를 볼 수 있다. (재정의나 Visualforce 삭제 전에 영향 범위를 파악하는 데 유용하다.)

컴포넌트의 detail page에서 **Where is this used?** 를 클릭하면, Salesforce가 해당 컴포넌트를 참조하는 컴포넌트의 **타입**과 그 컴포넌트의 **label**을 나열한다. 목록의 항목을 클릭하면 해당 항목을 직접 볼 수 있다.

**Required Editions**

- Available in: Salesforce Classic
- Custom buttons and links are available in: **All Editions**
- Visualforce pages and custom components available in: **Contact Manager, Group, Professional, Enterprise, Performance, Unlimited, and Developer Editions**

**User Permissions Needed**

- To create or change custom buttons or links: **Customize Application**
- To create, edit, and delete Visualforce pages and custom components: **Customize Application**
- To clone, edit, or delete static resources: **Customize Application**

---

## See Also (개발자 가이드 — 외부 참고 링크)

- **Visualforce Developer Guide** — Overriding Buttons, Links, and Tabs with Visualforce
- **Lightning Aura Components Developer Guide** — Standard Actions and Overrides Basics

---

## 관련 노트
- [[Custom Buttons & Links (커스텀 버튼·링크)]] — 커스텀 버튼·링크 개요(상위 허브)
- [[New Button or Link & Action 생성 가이드 (타입·설정·예시)]] — 신규 버튼/링크 생성(재정의와 대비)
- [[Record Types (레코드 타입)]] — New 재정의 시 record type selection page 스킵 관련
