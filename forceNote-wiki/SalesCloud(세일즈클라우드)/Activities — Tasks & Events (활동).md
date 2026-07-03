---
tags: [sales-cloud, activities, tasks, events, calendar]
source: help.salesforce.com (Salesforce Help — Sales Basics; Activities: Tasks, Events, and Calendars; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=sales.activities.htm&type=5
created: 2026-07-03
aliases: [Activities, 활동, Tasks, Events, Calendar, 태스크, 이벤트, 캘린더]
---

# Activities — Tasks & Events (활동)

> **Task**(할 일)와 **Event**(미팅)를 묶어 목록·리포트로 추적하는 Sales Cloud 기능. 두 오브젝트를 합쳐 Activities라 하며 lead·contact·opportunity 등 레코드에 연결된다.

---

## 개념 — Activities란

Salesforce로 **task와 meeting을 목록·리포트로 함께 추적**해 시간을 우선순위화하고 account·campaign·contact·lead·opportunity를 관리하는 기능이다. 진행 중인 영업 관계 전반에서 "무엇을 해야 하는가(task)"와 "누구와 언제 만나는가(event)"를 한곳에서 본다.

**Activities = Tasks + Events + Calendars.** Task와 Event 두 오브젝트를 총칭해 Activities라 부른다.

---

## Tasks (할 일)

Salesforce에 **to-do 목록**을 유지하는 기능이다.

- 모든 task를 **lead·contact·campaign·contract 등 레코드에 쉽게 연결**한다.
- **빠른 생성·업데이트** — task를 신속히 만들고 갱신.
- **prefiltered task 목록** — 미리 필터링된 목록으로 우선순위 확인.
- **task notification 옵션** — task 알림을 받도록 설정 가능.

---

## Events & Calendars (미팅·캘린더)

고객·prospect·동료와의 **meeting을 추적**하는 기능이다.

- event에서 **관련 레코드·feed·file·contract 등으로 drill down**한다.
- event를 **리포트로 추적**한다.

---

## 할당 (Assignment)

Task·Event(총칭 Activities)는 **자신 또는 조직의 다른 active 사용자에게 생성·할당**할 수 있다.

- **Task는 여러 사람에게 동시 할당** 가능하다.

---

## 구조

```
// 구조 예시 — Activities(실제 원본 다이어그램 아님)
Activities
 ├─ Task (할 일)   → lead·contact·campaign·contract 연결 · 다중 할당 가능 · 알림
 └─ Event (미팅)  → 관련 레코드·feed·file·contract drill-down · Calendar
할당: 자신 또는 다른 active 사용자
```

---

## 관련 노트
- [[Sales Cloud 개요]] — Sales Cloud 시리즈 허브
- [[Opportunities (기회)]] — opportunity에 task·event 연결
