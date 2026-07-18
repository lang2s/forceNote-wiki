---
tags: [admin, reports, report-builder, report-types, analytics, customization]
source: help.salesforce.com (Salesforce Help — Analyze Your Data; Reports; 라이브 공식 문서, Tier 2, 접속 2026-07-03) + salesforce_reports_enhanced_reports_tab_tipsheet.pdf (Tier 2, Last updated 2026-03-31)
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

## 리포트 탭 UI 절차 (생성·폴더·공유·검색·구독) — Salesforce Classic

> 출처: `salesforce_reports_enhanced_reports_tab_tipsheet.pdf` ("Using the Reports Tab", Last updated 2026-03-31, Tier 2).
> 아래는 **Salesforce Classic**의 **Reports 탭** 화면 조작 절차다. Reports 탭은 report와 dashboard를 한곳에서 찾고·정리·관리하는 중심 허브다.

**전제/환경**
- Reports 탭은 **accessibility mode**를 지원한다. **Salesforce Classic 2010 user interface theme**을 활성화하지 않아도 사용할 수 있다.
- 여기 설명된 기능이 보이지 않으면 **지원되는 브라우저**를 쓰고 있는지 확인한다(Salesforce Help의 "Supported Browsers and Devices" 검색).
- Reports 탭에서 할 수 있는 작업: 리포트/대시보드 생성 · 표준 리포트 접근 · 폴더로 정리·공유 · 폴더 간 이동 · 목록 뷰 커스터마이즈 · 검색·필터 · 리포트/대시보드 관리 · 예약(schedule)·팔로우.

> [!note] 스크린샷 라벨 안내 (Pattern C)
> tipsheet 본문은 화면 요소를 번호 **(1)~(6)** 로 가리키며 이는 PDF의 **스크린샷 이미지 참조**다. 본 위키에는 텍스트 절차만 옮기고, 원본 이미지의 정확한 아이콘 위치는 재현하지 않는다(아이콘 라벨은 "생성 아이콘", "폴더 편집 아이콘" 등으로 표기).

### 리포트/대시보드 생성
1. Reports 탭에서 **New Report** 또는 **New Dashboard** 버튼(스크린샷 라벨 1)을 클릭한다.
2. 자세한 절차는 온라인 도움말에서 "Create a Report", "Build a Salesforce Classic Dashboard"를 검색한다.

### 표준(standard) 리포트 접근
- 템플릿에 준하는 **표준 리포트** 여러 개가 Reports 탭에 제공되며, **Folders 창(pane)** 에서 접근한다.
- 이 리포트는 **그대로 사용**하거나 비즈니스에 맞게 **커스터마이즈**할 수 있다. 예: **Account and Contacts Reports** 폴더(라벨 2)의 표준 리포트는 조직의 account·contact 정보를 수집하는 데 쓴다.
- 참고: 온라인 도움말 "Standard Report Types".

### 폴더로 정리·공유
리포트와 대시보드는 **report/dashboard folder**를 통해 저장·공유된다.
1. **Folders 창**에서 **생성 아이콘**을 클릭해 report folder 또는 dashboard folder를 만든다.
2. Folders 창은 모든 폴더를 나열하며, 기본 폴더로 **Unfiled Public Reports**, **My Personal Custom Reports**, **My Personal Dashboards** 등 표준 리포트 폴더가 포함된다.
   - **Unfiled Public Reports** — 관리자가 만들어 조직 전체와 공유한 리포트가 들어있다.
   - **My Personal Custom Reports / My Personal Dashboards** — 본인에게만 비공개(private)인 리포트·대시보드.
3. **폴더 편집 아이콘**을 클릭하면 (권한이 있는 경우) 폴더 이름 변경, 삭제, 공유(sharing) 변경을 할 수 있다.
4. 참고: 온라인 도움말 "Managing Folders".

### 검색·필터
1. Reports 탭의 **검색(라벨 3)** 으로 **모든 폴더**에서 리포트/대시보드를 찾는다.
2. 검색 가능한 필드: **Name**, **Description**, **Last Modified By**, **Created By**.
3. 결과를 정제하려면 **필터(라벨 4)**, **정렬(sort)**, 또는 **선택한 폴더 안에서 검색**을 사용한다.
4. 참고: 온라인 도움말 "Search for Reports and Dashboards from the Reports Tab in Salesforce Classic".

### 폴더 간 이동
1. 목록 뷰(list view)에서 리포트나 대시보드를 **Folders 창의 폴더로 드래그**해 이동한다.
2. **한 번에 한 항목**만 드래그할 수 있다.
3. 설치된 **AppExchange 패키지**나 **표준 리포트 폴더**의 항목은 다른 폴더로 이동할 수 **없다**.
4. 참고: 온라인 도움말 "Move a Report or Dashboard Between Folders in Salesforce Classic".

### 목록 뷰 커스터마이즈
- 열(column)을 **크기 조절·숨기기(라벨 5)·재정렬·정렬**하고, 목록 뷰에 표시할 **레코드 수(라벨 6)** 를 선택한다.
- 참고: 온라인 도움말 "Get the Information You Need From the Reports Tab List View in Salesforce Classic".

### 리포트/대시보드 관리 (보기·편집·삭제·내보내기)
1. 목록 뷰에서 리포트나 대시보드를 **클릭**하면 열어서 볼 수 있다.
2. 접근 수준에 따라 **Action 열**에서 리포트/대시보드를 **편집(edit)** 하거나 **삭제(delete)** 할 수 있다.
3. **Export**를 선택하면 리포트 데이터를 **Excel 스프레드시트** 또는 **.CSV(comma-separated values)** 형식으로 내보낼 수 있다.
4. 참고: 온라인 도움말 "Build a Report in Salesforce Classic", "Delete a Report", "Export a Report".

### 예약(schedule)·팔로우
- Reports 탭에서 즐겨찾는 리포트·대시보드를 **팔로우(follow)** 하고, **예약된 갱신(scheduled refreshes)** 을 볼 수 있다.
- 목록 뷰에서 항목을 팔로우하려면 **먼저 리포트·대시보드에 대한 Chatter feed tracking을 활성화**해야 한다.
- 예약된 리포트·대시보드 갱신은 **예약 아이콘**으로 표시되며, 아이콘 위에 마우스를 올리면(hover) **다음 예약 갱신 시각**을 확인할 수 있다.
- 참고: 온라인 도움말 "Schedule a Report for Refresh", "Schedule a Dashboard Refresh in Salesforce Classic", "Customize Chatter Feed Tracking".

---

## 관련 노트
- [[Dashboards (대시보드)]] — report 데이터를 시각 컴포넌트로 표시. Reports 탭에서 대시보드도 함께 생성·정리·예약한다.
