---
tags: [admin, ui-customization, list-views, mass-quick-actions, records]
source: help.salesforce.com (Salesforce Help — List Views / List View Button Layout; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=sf.customviews.htm&type=5
created: 2026-07-03
aliases: [List Views, 리스트 뷰, 목록 보기, List View Button Layout, Mass Quick Action, Kanban]
---

# List Views (리스트 뷰)

> 오브젝트 레코드를 필터·정렬해 보는 목록 뷰. 사용자가 만들고 공유하며, **List View Button Layout**으로 버튼을, mass quick action으로 다중 레코드 일괄 작업을 제어한다.

---

## 개념

**List view**는 오브젝트 레코드의 **필터·정렬된 목록**이다. 사용자가 직접 생성하고 다른 사용자·그룹과 공유할 수 있으며, 목록을 벗어나지 않고 inline 편집을 하거나 차트·Kanban 보기로 전환할 수 있다.

| 요소 | 설명 |
|---|---|
| List View | 오브젝트 레코드의 필터·정렬된 목록. inline 편집·차트·**Kanban** 보기 지원. 사용자가 생성·공유. |
| List View Button Layout | 오브젝트의 management settings에서 선택·편집. 그 오브젝트의 **모든 list view에 표시될 액션 버튼**을 제어. |
| Mass Quick Action | list view button layout에 추가하는 액션. 여러 레코드를 선택해 **한 번에 일괄 작업**. |

## List View Button Layout

오브젝트의 **management settings**에서 **List View Button Layout**을 선택·편집하면, 해당 오브젝트의 **모든 list view에 표시되는 액션 버튼**을 제어할 수 있다. 즉 버튼 노출은 개별 list view가 아니라 오브젝트 단위의 button layout에서 관리한다.

## Mass Quick Actions

list view에 **mass quick action**을 추가하려면 그 오브젝트의 **list view button layout을 커스터마이즈**한다. mass quick action은 목록에서 **여러 레코드를 선택해 한 번에 작업**을 실행하게 해 준다.

> mass quick action이 실행하는 액션 자체(생성·업데이트 등)의 정의는 [[Quick Actions & Global Actions (퀵 액션·글로벌 액션)]] 참조.

## 구조

```
// 구조 예시 — List Views(실제 동작 코드 아님)
List View(필터·정렬된 레코드 목록) — inline 편집·차트·Kanban
   List View Button Layout(오브젝트 management settings): 표시 버튼 제어
      + Mass Quick Action: 다중 레코드 선택 → 일괄 작업
```

## 관련 노트
- [[Quick Actions & Global Actions (퀵 액션·글로벌 액션)]] — mass quick action이 실행하는 액션 정의
- [[Page Layouts (페이지 레이아웃)]] — 버튼·레이아웃 개념(관련)
