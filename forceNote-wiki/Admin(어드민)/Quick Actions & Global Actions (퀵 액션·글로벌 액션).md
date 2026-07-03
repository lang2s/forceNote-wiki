---
tags: [admin, ui-customization, quick-actions, global-actions, publisher-layout]
source: help.salesforce.com (Salesforce Help — Quick Actions / Global Quick Actions; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=sf.actions_overview.htm&type=5
created: 2026-07-03
aliases: [Quick Actions, 퀵 액션, 빠른 실행, Global Actions, 글로벌 액션, Global Publisher Layout, Object-Specific Action]
---

# Quick Actions & Global Actions (퀵 액션·글로벌 액션)

> 사용자가 레코드 생성·업데이트·통화 로그 등을 빠르게 하도록 하는 액션. **Object-specific**(특정 오브젝트) vs **Global**(컨텍스트 무관, global publisher layout·액션 바)으로 나뉘며, Lightning 컴포넌트·flow·VF·canvas를 호출할 수 있다.

---

## Quick Actions 개요

**Quick Actions**는 사용자가 Salesforce 및 모바일 앱에서 **더 많은 작업**을 빠르게 수행하도록 한다. 대표적으로 레코드 생성·업데이트, 통화 로그(log a call) 등이 있다.

custom quick action은 다음 기능을 **호출**할 수 있다:

- **Lightning 컴포넌트**
- **Flow**
- **Visualforce 페이지**
- **Canvas 앱**

즉, 표준 레코드 생성/업데이트뿐 아니라 커스텀 로직·화면을 액션으로 노출할 수 있다.

---

## 두 가지 유형 — Object-specific vs Global

### Object-specific Actions

- 특정 **오브젝트의 레코드**에서 동작하는 액션.
- 오브젝트의 **page layout**에 추가한다.
- 현재 레코드의 컨텍스트(예: 부모 레코드) 안에서 관련 레코드를 생성·업데이트하는 데 사용.

### Global Actions

- 현재 레코드 컨텍스트와 **무관**하게 동작하는 액션(예: 레코드 생성, 통화 로그).
- **Global Publisher Layout**이 어떤 global action이 어디에 나타날지를 정한다.
- 표시 위치:
  - **Home** 페이지 및 **Chatter** 페이지
  - Lightning Experience의 **Global Actions 메뉴**
  - 모바일 앱의 **Feed·People** 페이지 **action bar**

---

## 배정(Assignment) 요약

| 유형 | 배정 대상 |
|---|---|
| Object-specific Action | 오브젝트 **page layout** |
| Global Action | **Global Publisher Layout** |

- object action → 해당 오브젝트의 **page layout**에 추가.
- global action → **global publisher layout**에 추가.

---

## 구조 요약

```
// 구조 예시 — Quick Actions & Global Actions(실제 동작 코드 아님)
Object-specific Action: 특정 오브젝트 레코드 → page layout에 추가
Global Action: 컨텍스트 무관(레코드 생성·통화 로그) → Global Publisher Layout
   표시: Global Actions 메뉴(LEX) · Home/Chatter · 모바일 action bar
호출 가능: Lightning 컴포넌트 · Flow · Visualforce · Canvas
```

---

## 관련 노트
- [[Lightning App Builder & Pages (라이트닝 앱 빌더·페이지)]] — 페이지·액션 바에 액션 배치.
- [[Page Layouts (페이지 레이아웃)]] — object-specific action을 page layout에 추가.
- [[Custom Buttons & Links (커스텀 버튼·링크)]] — 레거시 JavaScript 버튼의 현대적 대체 대상.
- [[List Views (리스트 뷰)]] — 리스트 뷰에서 mass quick action으로 실행되는 액션 정의.
