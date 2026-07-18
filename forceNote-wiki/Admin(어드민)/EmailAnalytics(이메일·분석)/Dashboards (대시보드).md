---
tags: [admin, dashboards, dashboard-components, analytics, customization]
source: help.salesforce.com (Salesforce Help — Analyze Your Data; Dashboard Component Types; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=analytics.dashboards_component_types.htm&type=5
created: 2026-07-03
aliases: [Dashboards, 대시보드, Dashboard Component, Chart Gauge Metric Table, Dynamic Dashboard]
---

# Dashboards (대시보드)

> 소스 report의 데이터를 **차트·게이지·메트릭·테이블·Visualforce** 컴포넌트로 시각화하는 도구. 각 컴포넌트는 하나의 report에서 데이터를 가져온다.

---

## 개념

dashboard **component**는 report 데이터의 **시각적 표현(visual representation)**이다. 하나의 dashboard는 여러 컴포넌트로 구성되며, 각 컴포넌트는 chart, table, gauge, metric, 또는 Visualforce로 만드는 기타 컴포넌트일 수 있다.

핵심 원칙: **각 dashboard 컴포넌트는 하나의 report에서 데이터를 가져온다.** 즉 dashboard의 데이터 소스는 report이며, dashboard 자체는 그 report 데이터를 다양한 형태로 시각화하는 계층이다.

```
// 구조 예시 — Dashboard 구성(실제 원본 다이어그램 아님)
Source Report(들) ──▶ Dashboard
   ├─ Chart      (그래픽)
   ├─ Gauge      (단일 값 + Min/Breakpoint/Max)
   ├─ Metric     (핵심 값 1개)
   ├─ Table      (컬럼 형태)
   └─ Visualforce / S-Control (Classic 전용)
Dynamic Dashboard: 보는 사람의 접근 권한 기준 (Manage Dynamic Dashboards 권한)
```

---

## 사용 가능 환경 (Available in)

- **Salesforce Classic**
- Editions:
  - **Group** — **View Only**
  - **Professional**
  - **Enterprise**
  - **Performance**
  - **Unlimited**
  - **Developer**

---

## 필요 권한 (User Permissions)

| 작업 | 필요 권한 |
|---|---|
| dashboard 생성 | **Run Reports** AND **Create and Customize Dashboards** |
| 본인이 만든 dashboard 편집·삭제 | **Run Reports** AND **Create and Customize Dashboards** |
| public folder의 본인 dashboard 편집·삭제 | **Edit My Dashboards** |
| public folder의 타인 dashboard 편집·삭제 | **Manage Dashboards in Public Folders** |
| dynamic dashboard 생성·편집·삭제 | **Manage Dynamic Dashboards** |

---

## 컴포넌트 타입 (Dashboard Component Types)

| 타입 | 설명 |
|---|---|
| **Chart** | 데이터를 그래픽으로 표시한다. 다양한 chart 유형을 선택할 수 있다. |
| **Gauge** | 단일 값을 커스텀 값 범위 안에 표시한다. **Minimum Value · Breakpoint #1 · Breakpoint #2 · Maximum Value**를 설정하고, **Show Percentage / Show Total**을 선택할 수 있다. 최대값(Maximum Value)을 초과하는 값은 초과로 표시된다. |
| **Metric** | 표시할 핵심 값 하나를 보여준다. |
| **Table** | report 데이터를 컬럼(column) 형태로 표시한다. **Maximum Values Displayed · Customize Table** 옵션이 있다. |
| **Visualforce Page** | 표준 컴포넌트에서 제공되지 않는 커스텀 컴포넌트/정보를 표시한다. 특정 요건을 충족해야 한다. **Salesforce Classic 전용**이며, 브라우저가 서드파티 쿠키를 차단하면 표시되지 않는다. |
| **Custom S-Control** | 브라우저에 표시 가능한 모든 콘텐츠를 담을 수 있다. ⚠️ **Visualforce가 s-control을 대체(supersede)한다.** |

### 컴포넌트별 세부 옵션

- **Gauge** — 단일 지표를 눈금 범위 안에서 보여줄 때 사용한다. 설정값:
  - Minimum Value (최소값)
  - Breakpoint #1
  - Breakpoint #2
  - Maximum Value (최대값)
  - Show Percentage / Show Total 선택
  - 최대값을 넘는 값은 "초과"로 표시된다.
- **Table** — report 데이터를 컬럼 형태로 나열한다. Maximum Values Displayed(표시할 최대 행 수)와 Customize Table을 조정할 수 있다.
- **Visualforce Page** — 표준 컴포넌트로 표현할 수 없는 커스텀 정보를 넣을 때 사용한다. Salesforce Classic 전용이며 서드파티 쿠키 차단 시 미표시라는 제약이 있다.
- **Custom S-Control** — 레거시 방식. **Visualforce로 대체되었으므로** 신규 구성 시 Visualforce Page 사용이 권장된다.

---

## Dynamic Dashboard

**dynamic dashboard**는 dashboard를 **보는 사람(viewer)의 접근 권한**을 기준으로 데이터를 표시하는 dashboard다. 생성·편집·삭제에는 **Manage Dynamic Dashboards** 권한이 필요하다.

---

## 관련 노트
- [[Reports (리포트)]] — dashboard 컴포넌트의 소스 데이터.
