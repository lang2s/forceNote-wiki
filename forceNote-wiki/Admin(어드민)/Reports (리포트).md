---
tags: [admin, reports, report-builder, report-types, analytics, customization]
source: help.salesforce.com (Salesforce Help — Analyze Your Data; Reports; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=analytics.rd_reports_overview.htm&type=5
created: 2026-07-03
aliases: [Reports, 리포트, 보고서, Report Builder, Report Type, Report Format, Tabular Summary Matrix Joined]
---

# Reports (리포트)

> Salesforce 데이터를 필드·필터·그룹핑으로 조회·분석하는 도구. **Report Builder**(드래그앤드롭)로 만들며, **Report Type**이 사용 가능한 필드를, **Report Format**(tabular/summary/matrix/joined)이 결과 배치를 결정한다.

---

## 개념

Reports는 Salesforce 데이터에 대한 접근을 제공하며, 데이터를 거의 원하는 방식으로(examine) 살펴볼 수 있게 한다. 필드를 열로 선택하고, 필터로 반환 데이터를 제한하며, 그룹핑으로 데이터를 요약해 조직의 지표를 분석한다.

**Available in:** Salesforce Classic + Lightning Experience.
**Editions:** Essentials, Group, Professional, Enterprise, Performance, Unlimited, Developer. (Enhanced Folder Sharing 적용.)

**공유:** report는 **folder**로 공유된다. report가 저장된 folder에 대한 권한을 가진 사람이 그 report에 접근할 수 있다. 즉 접근 제어의 단위는 개별 report가 아니라 폴더 권한이다.

---

## Report Builder

**Report Builder**는 report를 만들고 기존 report를 편집하는 **visual, drag-and-drop 도구**다. **Analytics 탭** 또는 **Reports 탭**에서 실행한다.

report를 만들 때는 다음 핵심 구성 요소를 다룬다.

| 개념 | 설명 |
|---|---|
| **Fields** | 각 report 결과를 설명하는 열(컬럼). report에 포함할 필드를 선택한다. |
| **Filters** | report가 반환하는 데이터를 제한한다. |
| **Report Types** | report에서 **사용 가능한 필드를 좌우**한다. report를 만들 때 **가장 먼저** report type을 고른다. 예: File and Content report type을 고르면 File ID·File Name·Total Downloads·Account 같은 필드를 사용할 수 있다. |
| **Report Format** | 결과가 배치되는 방식. 포맷: **tabular**(그룹 없음, 기본) · **summary**(행으로 그룹) · **matrix**(행·열로 그룹) · **joined**(여러 report 블록). |

### Report Format 4종

- **Tabular** — 그룹핑이 없는 단순 목록. 기본 포맷.
- **Summary** — 행 기준으로 그룹핑해 데이터를 요약.
- **Matrix** — 행과 열 양방향으로 그룹핑.
- **Joined** — 여러 report 블록을 하나로 결합해 나란히 표시.

---

## 포맷 한도 (공식)

- summary formula가 1개인 **matrix report**는 최대 **400,000 요약 값**을 가질 수 있으며, 이는 최대 **2,000 행 · 200 열**에 해당한다. summary formula를 추가할수록 가질 수 있는 값·행·열 수가 줄어든다.
- **Report Builder 미리보기(preview)** 표시 행 수: summary·matrix report는 **20행**, tabular report는 **50행**.
- 요약 필드는 최대 **21자리(digits)**까지 표시된다.

---

## 주요 기능

- **Inline 편집** — tabular·summary·matrix report에서 필드 값을 인라인으로 편집.
- **Filter** — 필터로 데이터를 축소해 원하는 레코드만 조회.
- **Subscription** — report subscription으로 관심 지표에 대한 알림을 받는다.
- **Export·연결** — Quip 등으로 export하거나 연결.
- **Drill-down** — report에서 개별 레코드 상세로 파고들어 조회.
- **정리** — report를 folder로 정리하거나 삭제.
- **Einstein Discovery for Reports** — 구 Einstein Data Insights. report를 스캔해 인사이트를 제공한다.

---

## 구성 흐름

```
// 구조 예시 — Report 구성(실제 원본 다이어그램 아님)
1) Report Type 선택   → 사용 가능한 필드 집합 결정
2) Report Builder에서 Fields 선택 + Filters 적용
3) Report Format:  Tabular(그룹없음) | Summary(행) | Matrix(행×열) | Joined(블록)
4) 저장 → Folder로 공유(폴더 권한 = 접근 권한)
한도: Matrix 400,000값 / 2,000행 / 200열
```

---

## 관련 노트
- [[Dashboards (대시보드)]] — report 데이터를 시각 컴포넌트로 표시.
