---
tags: [index, search, navigation, analytics]
created: 2026-06-21
---

# SEARCH INDEX — Analytics(애널리틱스) (CRM Analytics Data Prep Recipe REST API + Reports and Dashboards REST API)
> Salesforce Analytics 도메인 키워드 샤드 — (1) CRM Analytics Data Prep Recipe REST API 10노트, (2) Reports and Dashboards REST API 11노트.
> 루트 라우터: `00 SEARCH_INDEX.md` · 다른 샤드는 라우터에서 이동.
> source: salesforce_recipes_api.pdf (Data Prep Recipe REST API Developer Guide Summer '26, Tier 2) · salesforce_analytics_rest_api.pdf (Reports and Dashboards REST API Developer Guide v67.0 Summer '26, Tier 2)

---

## 🗺️ 도메인 오리엔테이션 — 표준 리포팅 vs CRM Analytics·API 선택 (여기부터 시작)

> Analytics 도메인 진입점(synthesis). "표준 리포팅(Reports/Dashboards)과 CRM Analytics 두 세계 구분 + 무엇을 코드로 하려는가 → 어느 API/도구"를 라우팅하는 오리엔테이션 허브. 개별 API 상세는 아래 섹션들로 내려간다.

| 키워드 | 파일 |
|---|---|
| Analytics overview, Reports API vs Recipe API, CRM Analytics vs 표준 리포팅, Tableau CRM vs Reports, Einstein Analytics, Wave vs Reports, SAQL vs Report, dataset, Data Prep Recipe, Reports&Dashboards REST vs Wave NS, Analytics API 선택, 애널리틱스 개요, 애널리틱스 오리엔테이션, 분석 도구 선택, 어느 API를 언제 써야 하나, 리포트 API 선택, 리포트를 코드로 실행 어떤 API, SAQL/Wave/Recipe 구분, 대시보드 임베드 LWC, 표준 리포팅과 CRM Analytics 차이가 뭐야, CRM Analytics 활성화 전제조건, 표준 리포팅 API 한도 | `Analytics(애널리틱스)/Analytics 개요 — 표준 리포팅 vs CRM Analytics·API 선택 가이드.md` |

---

## 개요·인증·엔드포인트 — 진입 허브

| 키워드 | 파일 |
|---|---|
| Data Prep Recipe REST API, Recipe REST API, CRM Analytics REST API, Tableau CRM Recipe API, recipe endpoint, /wave/recipes, /wave/dataprepRecipes, OAuth 인증, access token, Examples workflow, 레시피 생성 API, 레시피 실행 API, 레시피 REST API 개요, 데이터 프렙 레시피 API, CRM Analytics에서 데이터 변환 API, 레시피를 REST로 만드는 법, 레시피 엔드포인트가 뭐야, Recipe API 인증 방법, Recipe API 버전, EOL, retirement | `Analytics(애널리틱스)/Data Prep Recipe REST API — 개요·인증·엔드포인트.md` |

## 노드 Input 표현형 — 데이터 변환 노드 JSON

| 키워드 | 파일 |
|---|---|
| Bucket node, Cluster node, BucketInput, bucketing, 구간화, 클러스터링, 값을 범주로 묶기, 버킷 노드 Input, 클러스터 노드 입력, 버킷팅 어떻게 정의해, Bucket 노드 JSON | `Analytics(애널리틱스)/Recipe REST API — Bucket·Cluster 노드 Input.md` |
| Aggregate node, Append node, Join node, Compute node, Pivot node, AggregateInput, JoinInput, 집계 노드, 데이터셋 결합, 조인 노드, 계산 컬럼, 피벗 노드, 두 데이터셋 합치기, 레시피에서 조인하는 법, 집계 노드 입력 정의 | `Analytics(애널리틱스)/Recipe REST API — Aggregate·Append·Join·Compute·Pivot Input.md` |
| Formula node, Format node, Typecast node, Update node, FormulaInput, 수식 노드, 서식 노드, 타입 변환, 필드 값 갱신, 계산식 컬럼 추가, 데이터 타입 바꾸기, 필드 업데이트 노드, 수식 컬럼 정의 | `Analytics(애널리틱스)/Recipe REST API — Formula·Format·Typecast·Update Input.md` |
| Filter node, Flatten node, Extract node, Schema node, FilterInput, 필터 노드, 평탄화, 문자열 추출, 스키마 조정, 행 거르기, 중첩 데이터 평탄화, 정규식 추출, 필터 노드 정의 | `Analytics(애널리틱스)/Recipe REST API — Filter·Flatten·Extract·Schema Input.md` |
| Load node, Save node, Output node, ML node, machine learning node, LoadInput, SaveInput, 소스 로드, 결과 저장, 출력 노드, 머신러닝 예측 노드, 데이터셋 불러오기, 레시피 결과 저장, 예측 노드 정의, ML 노드 입력 | `Analytics(애널리틱스)/Recipe REST API — Load·Save·Output·ML 노드 Input.md` |
| Recipe input, Definition input, Node input, RecipeInput, DefinitionInput, NodeInput, 레시피 구성, 레시피 최상위 구조, 노드 정의 컨테이너, 레시피 정의 JSON, Recipe Definition Node 차이 | `Analytics(애널리틱스)/Recipe REST API — Recipe 구성 Input.md` |

## Response 표현형 — API 응답 JSON

| 키워드 | 파일 |
|---|---|
| Recipe Response, node Response, BucketRepresentation, Output Representation, 노드 응답 표현형, API 응답 구조, Bucket부터 Output까지 응답, 레시피 API 응답 JSON, 노드 Response 구조, 응답 표현형 Bucket Output | `Analytics(애널리틱스)/Recipe REST API — Response 표현형 (Bucket~Output).md` |
| Recipe Representation, Update Representation, RecipeRepresentation, 레시피 응답 표현형, Recipe부터 Update까지 응답, 레시피 자체 응답 구조, 응답 표현형 Recipe Update, 레시피 메타데이터 응답 | `Analytics(애널리틱스)/Recipe REST API — Response 표현형 (Recipe~Update).md` |

## Enums — 허용값 목록

| 키워드 | 파일 |
|---|---|
| Recipe API enums, node type enum, action enum, data type enum, join type enum, 47개 enum, 노드 타입 열거형, 액션 열거형, 데이터 타입 허용값, 조인 타입 허용값, 레시피 API enum 목록, 필드에 들어갈 수 있는 값, Recipe enum 전체 | `Analytics(애널리틱스)/Recipe REST API — Enums.md` |

---

# Reports and Dashboards REST API (v67.0) — 리포트·대시보드 데이터 REST

> 리포트·대시보드 데이터에 프로그래밍 방식으로 접근하는 REST API. /analytics/reports·/dashboards·/folders·/notifications 엔드포인트. 예제(Examples) 2노트 + 표현형(Representation) Reference 9노트. reportMetadata 정본은 N4(Describe).

## 예제(Examples) — 실제 호출 워크플로

| 키워드 | 파일 |
|---|---|
| Reports REST API, Reports and Dashboards REST API, /analytics/reports, 리포트 REST API, 리포트 API 예제, Create Report REST, Run Report sync, Run Report async, 리포트 동기 실행, 리포트 비동기 실행, Report Filter, Fact Map, factMap decode, 팩트맵 디코딩, Save Report, Clone Report, Delete Report, 리포트 저장·복제·삭제, Report Types 조회, Excel export, 리포트 데이터 REST로 가져오기, 리포트를 코드로 실행하는 법, REST로 리포트 실행하는 법, 리포트 결과 JSON | `Analytics(애널리틱스)/Reports and Dashboards REST API — 개요·Reports 예제.md` |
| Dashboards REST example, Dashboard Results, Get Dashboard Data, 대시보드 결과 조회, 대시보드 데이터 REST, Save Dashboard, dashboard LWC Beta, CRM Analytics dashboard, Download report PDF, Download report PNG, 리포트 PDF 다운로드, 리포트 PNG 다운로드, Notification CRUD, 리포트 알림 생성, Analytics Notification 예제, 대시보드를 REST로 조회하는 법, 리포트를 이미지로 다운로드하는 법 | `Analytics(애널리틱스)/Reports and Dashboards REST API — Dashboards·Downloads·Notifications 예제.md` |

## 표현형(Representation) Reference — 응답·요청 JSON 구조

| 키워드 | 파일 |
|---|---|
| Report resource, Report Representation, Report PATCH, Report DELETE, 리포트 리소스 속성, 리포트 표현형, 리포트 PATCH 속성, 리포트 수정 REST, 리포트 자체 표현형 | `Analytics(애널리틱스)/Reports and Dashboards REST API — Report 표현형.md` |
| Describe resource, reportMetadata, reportTypeMetadata, reportExtendedMetadata, reportMetadata 34속성, Describe report REST, Column map, Detail column information, 리포트 메타데이터 표현형, reportMetadata 정본, 리포트 describe 응답, 리포트 메타데이터 속성 전체, 어떤 속성이 reportMetadata에 있나 | `Analytics(애널리틱스)/Reports and Dashboards REST API — Describe(reportMetadata) 표현형.md` |
| Execute Sync, Execute Async, Report Instances, Instance Results, Report List, 동기 실행 표현형, 비동기 실행 표현형, 리포트 인스턴스, 인스턴스 결과, 리포트 목록 표현형, async 리포트 결과 폴링, 리포트 실행 결과 표현형 | `Analytics(애널리틱스)/Reports and Dashboards REST API — Execute·Instances·Report List 표현형.md` |
| query resource, Query Representation, run report without saving, 저장 없이 리포트 실행, query 표현형, 임시 리포트 실행, 저장 안 하고 리포트 돌리기, query 리소스 표현형 | `Analytics(애널리틱스)/Reports and Dashboards REST API — Query 표현형.md` |
| Report Fields, /fields, Error Codes, 리포트 필드 표현형, 에러 코드 47행, Reports API 에러 코드, 리포트에 쓸 수 있는 필드, 리포트 필드 목록, REST 에러 코드 목록 | `Analytics(애널리틱스)/Reports and Dashboards REST API — Report Fields·Error Codes 표현형.md` |
| reportTypes, Report Type List, Report Type, Recently Used Report Types, Recently Created Report Types, Hide Report Type, Unhide Report Type, 리포트 유형 목록, 리포트 타입 표현형, 최근 사용 리포트 유형, 리포트 유형 숨기기, 리포트 타입 조회 REST | `Analytics(애널리틱스)/Reports and Dashboards REST API — Report Types 표현형.md` |
| Dashboard List, Dashboard Results, Dashboard Describe, Dashboard Status, Dashboard Filter Options, Dashboard Error Codes, 대시보드 목록, 대시보드 결과 표현형, 대시보드 describe, 대시보드 상태, 대시보드 필터 옵션, 대시보드 표현형 전체, 대시보드 에러 코드 | `Analytics(애널리틱스)/Reports and Dashboards REST API — Dashboards 표현형.md` |
| Analytics Folders API, Folder Collections, Folder Operations, Folder Shares, Folder Recipients, Folder Child, /folders, 폴더 API, 폴더 컬렉션, 폴더 공유, 폴더 수신자, 하위 폴더, 리포트 폴더 REST, 폴더 권한 REST | `Analytics(애널리틱스)/Reports and Dashboards REST API — Folders 표현형.md` |
| Analytics Download, Report Download, Notification List, Notification Limits, Filter Operator List, filteroperators, 다운로드 표현형, 알림 목록 표현형, 알림 한도, 필터 연산자 목록, 필드별 필터 연산자, 리포트 다운로드 표현형, 어떤 필터 연산자를 쓸 수 있나 | `Analytics(애널리틱스)/Reports and Dashboards REST API — Analytics Download·Notifications·Filter Operators 표현형.md` |

---

# Admin — 선언적 리포트·대시보드 (Report Builder / Dashboard 빌더)

> 코드 없이 Setup UI에서 만드는 리포트·대시보드. REST API(위 섹션)와 달리 클릭 기반 어드민 관점.

| 키워드 | 파일 |
|---|---|
| Reports, 리포트, 보고서, Report Builder, Report Type, Report Format, tabular summary matrix joined, 리포트 만들기, 리포트 유형, 요약 리포트, 매트릭스 리포트, 조인 리포트, 데이터 조회 분석, "리포트 어떻게 만들어", "Report Builder 사용법", "리포트 포맷 종류", 리포트 탭 UI, Reports 탭, 리포트 폴더, 폴더 공유, folder sharing, 리포트 구독, report subscription, 예약 갱신, scheduled refresh, Export Excel, Export CSV, 리포트 내보내기, 리포트 검색, 폴더 간 이동, Unfiled Public Reports, 리포트 폴더 어떻게 공유, 리포트를 엑셀로 내보내기 | `Admin(어드민)/Reports (리포트).md` |
| Dashboards, 대시보드, dashboard component, chart gauge metric table, dynamic dashboard, Visualforce 컴포넌트, 대시보드 만들기, 동적 대시보드, 차트 게이지 지표, 데이터 시각화, "대시보드 만드는 법", "대시보드 컴포넌트 종류", "리포트를 차트로 시각화" | `Admin(어드민)/Dashboards (대시보드).md` |
