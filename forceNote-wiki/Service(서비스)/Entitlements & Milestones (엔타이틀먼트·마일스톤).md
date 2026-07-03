---
tags: [service-cloud, entitlements, milestones, sla, entitlement-process]
source: help.salesforce.com (Salesforce Help — Service; Entitlements and Milestones / Work with Milestones; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=service.entitlements_milestones_parent.htm&type=5
created: 2026-07-03
aliases: [Entitlements, Milestones, 엔타이틀먼트, 마일스톤, SLA, Entitlement Process, Milestone Tracker]
---

# Entitlements & Milestones (엔타이틀먼트·마일스톤)

> Service Cloud의 **SLA 엔진**. Entitlement가 고객이 받을 수 있는 지원 수준을, Milestone이 시간 기준 단계(첫 응답·해결 시간)를 정의하며, Entitlement Process가 이들을 타임라인으로 묶는다(최대 10 마일스톤).

---

## 개념

Service Cloud에서 **SLA(Service-Level Agreement)** 를 시스템으로 강제하는 세 가지 구성요소가 맞물려 동작한다.

| 구성요소 | 역할 |
|---|---|
| **Entitlement** | 고객이 받을 수 있는 **지원 수준(support level)** 을 정의 |
| **Entitlement Process** | milestone을 담는 **타임라인** — 최대 10개 milestone 보유 |
| **Milestone** | 지원 프로세스의 **필수·시간 종속 단계** (예: first response, case resolution) |

지원 담당자(support rep)가 지원 레코드를 **정확하고 제때** 해결하도록, milestone이 entitlement process에 추가되어 각 단계의 시한을 관리한다.

---

## Milestones (마일스톤)

- 지원 프로세스의 **필수(required)·시간 종속(time-dependent) 단계**다.
- 대표 예시: **first response**(첫 응답) 시간, **case resolution**(케이스 해결) 시간.
- support rep가 지원 레코드를 **정확하고 제때** 해결하도록 entitlement process에 추가된다.

### 반복(recurrence)

milestone은 entitlement process에서 두 가지 방식으로 발생하도록 설정할 수 있다.

- **Once** — process에서 **한 번** 발생.
- **Recur** — process가 종료될 때까지 **반복** 발생.

---

## Entitlement Process (엔타이틀먼트 프로세스)

- milestone을 담는 **타임라인**이다.
- **최대 10개 milestone**을 가질 수 있다.

---

## Milestone Tracker (마일스톤 트래커)

- support rep에게 **다가오는·완료된 milestone의 전체 뷰**를 제공한다.
- **active·overdue milestone의 카운트다운**을 표시한다.
- 추가할 수 있는 위치: **case feed**, **work order feed**, **커스텀 페이지**, **Service Console**.

---

## 리포트

milestone 관련 데이터를 조회하는 커스텀 리포트 타입이 있다.

| 리포트 타입 | 조회 대상 |
|---|---|
| **Cases with Milestones** | milestone이 있는 **case** |
| **Object Milestones** | milestone이 있는 **work order** |

---

## SLA 구조

```
// 구조 예시 — Entitlements & Milestones(실제 원본 다이어그램 아님)
Entitlement(지원 수준) → Entitlement Process(타임라인, 최대 10 milestone)
   Milestone: First Response(시간) · Case Resolution(시간) …
      once 또는 recur
   Milestone Tracker: active/overdue 카운트다운 (case feed·console 표시)
   리포트: Cases with Milestones · Object Milestones
```

---

## 관련 노트
- [[Service Cloud 개요]] — Service Cloud 시리즈 허브
- [[Cases (케이스)]] — milestone이 붙는 지원 레코드
