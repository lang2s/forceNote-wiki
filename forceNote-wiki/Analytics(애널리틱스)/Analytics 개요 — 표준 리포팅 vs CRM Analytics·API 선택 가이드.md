---
tags: [analytics, crm-analytics, reports, dashboards, orientation, api-selection, wave, recipe, reports-dashboards-rest]
source: 위키 내부 노트 synthesis (Reports&Dashboards REST·Recipe REST·Apex Reports/Wave NS·CRM Analytics LWC 노트 조합 — 각 노트의 Tier 2 소스 계승)
created: 2026-07-12
aliases: [Analytics 개요, 애널리틱스 오리엔테이션, 표준 리포팅 vs CRM Analytics, Tableau CRM vs Reports, Analytics API 선택, 분석 도구 선택, SAQL vs Report, Wave vs Reports]
---

# Analytics 개요 — 표준 리포팅 vs CRM Analytics·API 선택 가이드

> Salesforce에는 **두 개의 분석 세계**가 병존한다 — 오브젝트 위에서 바로 도는 **표준 리포팅**(Reports/Dashboards)과, 별도 데이터셋·SAQL 엔진 위에서 도는 **CRM Analytics**(구 Tableau CRM/Einstein Analytics/Wave). 이 노트는 둘을 구분하고, "무엇을 코드로 하려는가 → 어느 API/도구"를 라우팅한다.

---

## 두 애널리틱스 세계 구분

Salesforce 개발자·어드민이 "분석"이라 부르는 것은 실제로는 서로 다른 스택 두 개다. 아무거나 골라 쓰면 라이선스·데이터 규모·탐색 방식에서 막힌다.

- **표준 리포팅 (Reports/Dashboards)** — Salesforce 오브젝트(Opportunity·Case·Account 등) 데이터를 **Report Builder**로 필드·필터·그룹핑해 조회하고, **Dashboard**로 시각화한다. 별도 데이터 적재가 없다(오브젝트를 실시간으로 읽는다). 모든 에디션에서 기본 제공된다. 개념층은 Admin 소관 → [[Reports (리포트)]] · [[Dashboards (대시보드)]].
- **CRM Analytics (구 Tableau CRM / Einstein Analytics / Wave)** — 데이터를 **dataset**으로 적재·정제(Data Prep/Recipe)한 뒤 **SAQL** 엔진으로 대규모·대화형 탐색을 한다. 별도 **라이선스(Growth/Plus)** 와 org 활성화·권한 세트가 전제된다. lens·app·대시보드가 별도 스튜디오(Analytics Studio)에서 산다.

### 축별 비교

> 아래 비교의 라이선스·한도·전제조건은 각 조합 노트에서 인용했다(도구별 상세 링크는 결정표 참조). 판단이 애매하면 "실시간 오브젝트 데이터를 그대로 본다 = 표준, 적재·정제한 대량 데이터를 대화형으로 판다 = CRM Analytics"로 나눈다.

| 축 | 표준 리포팅 (Reports/Dashboards) | CRM Analytics (Tableau CRM) |
|---|---|---|
| 데이터 소스 | Salesforce 오브젝트를 실시간 조회 | dataset(적재·정제된 스냅샷) |
| 데이터 규모 | REST/Apex 실행 시 **최대 2,000 report row**·**100 필드**로 잘림 | dataset은 대규모 행을 담고 SAQL로 집계 |
| 대화형 탐색 | 정적 리포트/대시보드(필터·드릴다운 제한적) | lens·faceting으로 대화형 탐색이 핵심 |
| 실시간성 | 오브젝트를 그때 읽으므로 실시간 | Recipe/dataflow 실행 시점의 스냅샷(스케줄 갱신) |
| 라이선스 | 모든 에디션 기본 제공 | **CRM Analytics Growth 또는 Plus** PSL 필요 |
| 활성화 전제 | API만 켜져 있으면 됨(OAuth) | Setup에서 CRM Analytics **Enable** + 권한 세트 배정 |
| 쿼리 언어 | 리포트 메타데이터(필터/그룹핑) | **SAQL** |
| 학습 곡선 | 낮음(어드민 도구) | 높음(데이터셋 모델링·SAQL·Recipe) |
| 개념층 노트 | [[Reports (리포트)]] · [[Dashboards (대시보드)]] | 아래 "CRM Analytics 개요" |

---

## CRM Analytics(구 Tableau CRM) 개요

표준 리포팅과 달리 CRM Analytics는 **자체 데이터 계층**을 가진다. 큰 그림만 짚는다(각 요소의 프로그래밍 표면은 아래 결정표).

- **dataset** — 분석 대상 데이터를 담는 최적화된 스토리지 단위. SAQL·lens·대시보드가 여기서 데이터를 읽는다. sObject로도 노출됨(`AnalyticsWorkspaceAsset` 등, [[Analytics Objects]]).
- **app (workspace)** — dataset·lens·대시보드를 묶는 컨테이너. sObject `AnalyticsWorkspace`.
- **lens** — dataset을 대화형으로 탐색하는 단일 뷰(탐색 세션).
- **dashboard** — 여러 쿼리(step)·위젯을 캔버스에 배치한 시각화. 커스텀 위젯을 LWC로 얹을 수 있다(→ [[CRM Analytics 대시보드용 LWC]]).
- **SAQL (Salesforce Analytics Query Language)** — dataset을 load→group→foreach로 집계·투영하는 쿼리 언어. Apex에서는 `Wave.QueryBuilder`가 SAQL 문자열을 빌드·실행한다(→ [[Wave Namespace]]).
- **Data Prep (Recipe)** — 소스 데이터를 load→transform(filter·join·aggregate·formula 등)→save 노드 그래프로 정제해 dataset을 만들거나 sObject를 갱신하는 파이프라인. REST로 조회·스케줄·실행한다(→ [[Data Prep Recipe REST API — 개요·인증·엔드포인트]]).

> [!important] CRM Analytics 계열 API(Recipe REST·Wave Apex·대시보드 LWC)는 **OAuth 토큰이 유효해도** org에 CRM Analytics가 활성화되고 사용자에게 CRM Analytics PSL(Growth/Plus) + `Manage/Use CRM Analytics` 권한이 없으면 첫 호출부터 막힌다. 표준 리포팅 API에는 없는 전제조건이다. (출처: [[Data Prep Recipe REST API — 개요·인증·엔드포인트]] 전제조건 · [[Wave Namespace]] 전제조건)

---

## ⭐ 프로그래밍 표면 선택 결정표

"무엇을 코드로 하려는가 → 어느 도구". **표준 세계**(위쪽)와 **CRM Analytics 세계**(아래쪽)를 섞지 않도록 세계를 병기했다. 대표 호출은 각 상세 노트에서 인용한 1줄이다(전체 시그니처·엔드포인트·한도는 링크 참조).

| 하려는 일 | 세계 | 도구 | 대표 호출/엔드포인트 (출처 노트) | 언제 |
|---|---|---|---|---|
| 리포트를 REST로 실행·결과(factMap) 조회 | 표준 | **Reports&Dashboards REST** | `GET .../analytics/reports/<id>?includeDetails=true` (Execute Sync) · 장시간이면 `POST .../instances`(Async) | 외부 앱·웹/모바일에서 리포트 데이터를 REST로 소비 |
| 리포트를 **Apex**에서 실행·결과 조회 | 표준 | **Apex Reports NS** | `Reports.ReportManager.runReport(reportId, true)` / `runAsyncReport(reportId, true)` | Apex 트리거·배치·스케줄에서 리포트 결과를 코드로 처리 |
| 리포트 메타데이터 CRUD(생성·저장·클론·삭제) | 표준 | **Reports&Dashboards REST** | `POST .../analytics/reports`(Create) · `PATCH`(Save) · `POST ?cloneId=`(Clone) · `DELETE`(→204) | 리포트를 코드로 프로비저닝·복제·정리 |
| 리포트 타입·필드·필터 가능값 조회 | 표준 | **Reports&Dashboards REST** / Apex Reports NS | `GET .../analytics/reports/<id>/describe` · Apex `describeReport(reportId)` | 동적 필터 UI·차트 빌드 전 메타데이터 확인 |
| 대시보드 데이터·상태·새로고침 조회 | 표준 | **Reports&Dashboards REST** | Dashboard resource(recently used·results·status·refresh) — [[Reports and Dashboards REST API — Dashboards·Downloads·Notifications 예제]] | 대시보드 데이터를 외부에서 조회/갱신 |
| 리포트·대시보드를 **SOQL로 목록** 조회 | 표준 | **Analytics Objects (sObject)** | `SELECT Id, Name, DeveloperName, Format, LastRunDate FROM Report` | 리포트/대시보드 자체를 메타데이터로 탐색·관리 |
| 리포트 구독·알림(Analytics Notification) | 표준 | **Reports&Dashboards REST** / Apex Reports NS | `.../analytics/notifications?source=...` · Apex `Reports.NotificationAction` 인터페이스 | 임계값 도달 시 Chatter 게시·알림 자동화 |
| CRM Analytics **dataset에 데이터 적재·변환**(Recipe 실행) | CRM Analytics | **Recipe (Data Prep) REST** | `POST /wave/dataflowjobs {"dataflowId":"02KB…","command":"start"}` (`targetDataflowId`는 `GET /wave/recipes/<id>?format=R3`에서 취득) | recipe로 데이터를 정제해 dataset 생성/갱신을 자동화 |
| Recipe 조회·스케줄·버전 revert·알림 | CRM Analytics | **Recipe (Data Prep) REST** | `GET /wave/recipes?format=R3` · `PUT /wave/asset/<id>/schedule` · `PUT /wave/recipes/<id>`(revert) | recipe 파이프라인을 프로그래밍적으로 관리 |
| **SAQL 쿼리** 실행(CRM Analytics dataset 집계) | CRM Analytics | **Apex Wave NS** | `Wave.QueryBuilder.load(dsId, dsVerId).group().foreach(projs).execute('q')` | Apex/LWC에서 dataset을 SAQL로 집계·조회 |
| CRM Analytics 템플릿 조회 | CRM Analytics | **Apex Wave NS** | `Wave.Templates.getTemplates(new Wave.TemplatesSearchOptions())` | 앱 템플릿 목록·설정을 코드로 조회 |
| **대시보드를 페이지에 임베드**(커스텀 위젯) | CRM Analytics | **대시보드용 LWC** | `.js-meta.xml`에 `<target>analytics__Dashboard</target>` + `<hasStep>` | CRM Analytics/Lightning 대시보드 캔버스에 커스텀 LWC 위젯 |
| Recipe를 LWC에서 조회·삭제(wire) | CRM Analytics | **대시보드용 LWC / wire** | `lightning/analyticsWaveApi` `getRecipes()`/`getRecipe()`/`deleteRecipe()` | Lightning Experience 내부에서 recipe UI 구성 |

### 대표 호출 한눈에 (각 상세 노트에서 인용)

```apex
// ── 표준 리포팅 세계 ──────────────────────────────
// Apex Reports NS (출처: [[Reports Namespace]])
Reports.ReportResults r = Reports.ReportManager.runReport(reportId, true);           // 동기
Reports.ReportInstance i = Reports.ReportManager.runAsyncReport(reportId, true);     // 비동기
// Reports&Dashboards REST (출처: 개요·Reports 예제)
//   GET  /services/data/v67.0/analytics/reports/<id>?includeDetails=true
//   POST /services/data/v67.0/analytics/reports                 (Create)
// SOQL로 리포트 목록 (출처: [[Analytics Objects]])
List<Report> reps = [SELECT Id, Name, Format, LastRunDate FROM Report];

// ── CRM Analytics 세계 ────────────────────────────
// Apex Wave NS — SAQL (출처: [[Wave Namespace]])
ConnectApi.LiteralJson res = Wave.QueryBuilder
    .load('datasetId', 'datasetVersionId').group().foreach(projs).execute('q');
// Recipe(Data Prep) REST (출처: 개요·인증·엔드포인트)
//   GET  /wave/recipes?format=R3
//   POST /wave/dataflowjobs   { "dataflowId":"02KB…", "command":"start" }
// 대시보드 LWC (출처: [[CRM Analytics 대시보드용 LWC]])
//   .js-meta.xml: <target>analytics__Dashboard</target> + <hasStep>
```

### 한도 주의 — 표준 리포팅 API (REST·Apex 공통)

표준 리포트를 코드로 실행할 때는 `includeDetails`/`getAllData()=true`여도 **무제한이 아니다.** Reports & Dashboards API(Apex `Reports` 포함)에 하드 한도가 걸린다. (출처: [[Reports Namespace]] · [[Reports and Dashboards REST API — 개요·Reports 예제]])

| 한도 | 값 |
|---|---|
| 반환 report row | 최대 **2,000행** (초과분은 필터로 분할 재실행) |
| 처리 컬럼(필드) | 최대 **100개 필드** |
| 커스텀 필드 필터 | 최대 **20개** |
| 동기 실행 빈도 | 시간당 **500회**, 동시 **20개** |
| 비동기 실행 | 시간당 **1,200회**, 결과는 **24시간 rolling** 보관 |

---

## 표준 리포팅 개념은 Admin으로 위임

이 노트의 고유 가치는 **두 세계 구분 + API 라우팅**이다. Report Builder 사용법·Report Type·Report Format(tabular/summary/matrix/joined)·Dashboard 컴포넌트 종류 같은 **표준 리포팅 개념·사용법**은 여기서 재서술하지 않는다.

- 리포트 개념·Report Builder·Report Type·Format → [[Reports (리포트)]]
- 대시보드 컴포넌트·Dynamic Dashboard·에디션별 가용성 → [[Dashboards (대시보드)]]

> [!note] 소스
> 이 노트는 새 사실 추출이 아니라 **위키에 이미 있는 검증된 노트들을 처음으로 묶은 synthesis(오리엔테이션 + API 선택 가이드)** 다. 표·비교·결정표의 사실은 아래 조합 대상 노트에서 그대로 가져왔으며, 각 노트의 Tier 2 소스(공식 REST API Dev Guide·Apex Reference·help.salesforce.com)를 계승한다. 외부(훈련데이터) 지식을 새로 넣지 않았다.
> - [[Reports and Dashboards REST API — 개요·Reports 예제]] (Reports&Dashboards REST)
> - [[Data Prep Recipe REST API — 개요·인증·엔드포인트]] (Recipe/Data Prep, 전제조건)
> - [[Reports Namespace]] (Apex 리포트 실행·한도)
> - [[Wave Namespace]] (Apex SAQL·CRM Analytics 전제조건)
> - [[CRM Analytics 대시보드용 LWC]] (대시보드 임베드 LWC)
> - [[Analytics Objects]] (Report·Dashboard·Analytics* sObject)
> - [[Reports (리포트)]] · [[Dashboards (대시보드)]] (표준 리포팅 개념층 — 위임)

---

## 관련 노트

- [[Reports and Dashboards REST API — 개요·Reports 예제]] — 표준 리포트를 REST로 실행·생성·삭제
- [[Data Prep Recipe REST API — 개요·인증·엔드포인트]] — CRM Analytics Recipe(Data Prep) REST
- [[CRM Analytics REST API — 개요·인증·asset 엔드포인트 지도]] — CRM Analytics(Wave) dataset·asset·SAQL query를 `/wave/*`로 직접 다루는 REST (Recipe REST의 형제 가이드)
- [[Reports Namespace]] — Apex에서 리포트 실행·factMap 탐색
- [[Wave Namespace]] — Apex SAQL 빌더(CRM Analytics)
- [[CRM Analytics 대시보드용 LWC]] — 대시보드 캔버스에 LWC 위젯 임베드
- [[Analytics Objects]] — Report·Dashboard·AnalyticsWorkspace 등 sObject
- [[Reports (리포트)]] — 표준 리포트 개념·Report Builder (Admin)
- [[Dashboards (대시보드)]] — 표준 대시보드 컴포넌트 (Admin)
