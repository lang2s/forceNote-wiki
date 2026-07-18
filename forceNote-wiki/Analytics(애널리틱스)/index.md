---
tags: [index, analytics, crm-analytics, data-prep, recipe-rest-api, reports-dashboards-rest-api]
created: 2026-06-21
---

# Analytics(애널리틱스) — 로컬 인덱스

> Salesforce Analytics 도메인 — 세 개발자 가이드 기반 24노트 + 오리엔테이션 synthesis 1노트(총 25):
> (1) **CRM Analytics(Tableau CRM) Data Prep Recipe REST API**(Summer '26) — 레시피로 데이터를 변환·정제하는 REST API의 개요·인증·엔드포인트, 노드 Input 표현형, Response 표현형, Enum까지 10노트
> (2) **Reports and Dashboards REST API**(v67.0 Summer '26) — 리포트·대시보드 데이터에 프로그래밍 방식으로 접근하는 REST API의 예제 2노트 + 표현형 Reference 9노트
> (3) **CRM Analytics REST API**(v67.0 Summer '26) — CRM Analytics(Wave) 플랫폼을 프로그램적으로 다루는 REST API(`/wave/*`)의 asset 엔드포인트 지도 + Datasets·XMD·Query 3노트
>
> ℹ️ Data Prep Recipe는 CRM Analytics에서 dataflow의 후속으로 데이터를 변환·정제하는 파이프라인이다. Reports and Dashboards REST API는 리포트/대시보드 메타데이터·결과 데이터·폴더·알림을 REST로 다룬다. CRM Analytics REST API(`/wave/*`)는 CRM Analytics의 dataset·lens·dashboard asset과 SAQL/SQL 쿼리를 다룬다(표준 리포팅의 `/analytics/*`와 별개).

**상위:** [[00 Home]]

---

## 시작 — 도메인 오리엔테이션 (여기부터)

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Analytics 개요 — 표준 리포팅 vs CRM Analytics·API 선택 가이드]] | ★오리엔테이션 허브 — 두 애널리틱스 세계(표준 리포팅 vs CRM Analytics/Tableau CRM) 구분 + "무엇을 코드로 하려는가 → 어느 API/도구" 프로그래밍 표면 선택 결정표. 표준 리포팅 개념은 Admin으로 위임 | #overview #decision-guide |

> 처음이라면 여기서 시작해 두 세계를 구분한 뒤, 아래 상세(Recipe REST / Reports&Dashboards REST)로 내려간다.

---

## Data Prep Recipe REST API (10노트) — 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Data Prep Recipe REST API — 개요·인증·엔드포인트]] | 진입 허브 — Recipe REST API 6개 엔드포인트·OAuth 인증·Examples 워크플로(레시피 생성→실행)·API 버전·EOL | #overview |
| [[Recipe REST API — Bucket·Cluster 노드 Input]] | Bucket 계열 노드 Input 표현형 26개(버킷팅·구간화·클러스터링 — 값을 범주로 묶는 변환) | #reference |
| [[Recipe REST API — Aggregate·Append·Join·Compute·Pivot Input]] | Aggregate·Append·Join·Compute·Pivot 노드 Input 표현형 20개(집계·결합·조인·계산·피벗) | #reference |
| [[Recipe REST API — Formula·Format·Typecast·Update Input]] | Formula·Format·Typecast·Update 노드 Input 표현형 23개(수식·서식·타입 변환·필드 갱신) | #reference |
| [[Recipe REST API — Filter·Flatten·Extract·Schema Input]] | Filter·Flatten·Extract·Schema 노드 Input 표현형 23개(필터·평탄화·추출·스키마) | #reference |
| [[Recipe REST API — Load·Save·Output·ML 노드 Input]] | Load·Save·Output·ML(머신러닝) 노드 Input 표현형 38개(소스 로드·저장·출력·예측) | #reference |
| [[Recipe REST API — Recipe 구성 Input]] | Recipe·Definition·Node 등 레시피 최상위 구성 Input 표현형 11개 | #reference |
| [[Recipe REST API — Response 표현형 (Bucket~Output)]] | Bucket부터 Output까지 노드 Response 표현형 86개(API 응답 JSON 구조) | #reference |
| [[Recipe REST API — Response 표현형 (Recipe~Update)]] | Recipe부터 Update까지 Response 표현형 50개 | #reference |
| [[Recipe REST API — Enums]] | API 전반에서 쓰이는 enum 47개(노드 타입·액션·데이터 타입·조인 타입 등 허용값 목록) | #reference |

---

## 빠른 선택

- 처음 시작 / Recipe REST API 엔드포인트·인증·레시피 생성·실행 워크플로 큰 그림 → [[Data Prep Recipe REST API — 개요·인증·엔드포인트]]
- 값을 버킷/구간/클러스터로 묶는 노드를 JSON으로 정의 → [[Recipe REST API — Bucket·Cluster 노드 Input]]
- 집계·여러 데이터셋 결합·조인·계산 컬럼·피벗 노드 정의 → [[Recipe REST API — Aggregate·Append·Join·Compute·Pivot Input]]
- 수식 컬럼·서식·데이터 타입 변환·필드 값 갱신 노드 정의 → [[Recipe REST API — Formula·Format·Typecast·Update Input]]
- 행 필터·중첩 평탄화·문자열 추출·스키마 조정 노드 정의 → [[Recipe REST API — Filter·Flatten·Extract·Schema Input]]
- 데이터 소스 로드·결과 저장·출력·ML 예측 노드 정의 → [[Recipe REST API — Load·Save·Output·ML 노드 Input]]
- 레시피 자체(Recipe/Definition/Node) 최상위 구조 정의 → [[Recipe REST API — Recipe 구성 Input]]
- API가 돌려주는 응답 JSON 구조(노드별 Response, Bucket~Output) → [[Recipe REST API — Response 표현형 (Bucket~Output)]]
- 응답 JSON 구조(Recipe~Update) → [[Recipe REST API — Response 표현형 (Recipe~Update)]]
- 필드에 들어갈 수 있는 허용값(노드 타입·액션·데이터/조인 타입 enum) → [[Recipe REST API — Enums]]

---

## Reports and Dashboards REST API (11노트)

> 리포트·대시보드 데이터에 REST로 접근. **예제(N1·N2)** = 실제 호출 워크플로 / **표현형 Reference(N3~N11)** = 요청·응답 JSON 구조. `reportMetadata` 정본은 N4(Describe) — 다른 표현형 노트가 이리로 링크한다.

### 예제(Examples)

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Reports and Dashboards REST API — 개요·Reports 예제]] | (N1) 진입 허브 — Overview(Resource URL·제약·EOL) + Reports Examples 전수: Create / Run sync·async / Filter / Fact Map decode / Query(미저장) / Save / Clone / Delete | #overview #example |
| [[Reports and Dashboards REST API — Dashboards·Downloads·Notifications 예제]] | (N2) Dashboard Results·Save(LWC Beta·CRM Analytics) / 리포트 PDF·PNG Download / Notification CRUD 예제 | #example |

### 표현형 Reference

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Reports and Dashboards REST API — Report 표현형]] | (N3) Report resource 표현형 — PATCH/DELETE 속성 | #reference |
| [[Reports and Dashboards REST API — Describe(reportMetadata) 표현형]] | (N4) ★정본 — `reportMetadata` 34속성·`reportTypeMetadata`·`reportExtendedMetadata`. 다른 표현형 노트가 이리로 링크 | #reference #canonical |
| [[Reports and Dashboards REST API — Execute·Instances·Report List 표현형]] | (N5) Execute Sync/Async·Report Instances·Instance Results·Report List 표현형 | #reference |
| [[Reports and Dashboards REST API — Query 표현형]] | (N6) query resource 표현형 — 저장 없이 리포트 실행 | #reference |
| [[Reports and Dashboards REST API — Report Fields·Error Codes 표현형]] | (N7) Report Fields 표현형 + Error Codes 47행 | #reference |
| [[Reports and Dashboards REST API — Report Types 표현형]] | (N8) Report Type List/Type/Recently Used·Created·Hide-Unhide 표현형 | #reference |
| [[Reports and Dashboards REST API — Dashboards 표현형]] | (N9) Dashboard List/Results/Describe/Status/Filter Options/Error Codes 표현형 | #reference |
| [[Reports and Dashboards REST API — Folders 표현형]] | (N10) Analytics Folders API — Collections/Operations/Shares/Recipients/Child 표현형 | #reference |
| [[Reports and Dashboards REST API — Analytics Download·Notifications·Filter Operators 표현형]] | (N11) Analytics Download·Notification List/Limits·Filter Operator List 표현형 | #reference |

### 빠른 선택 — Reports and Dashboards REST API

- 처음 시작 / API 개요·제약·리포트를 코드로 실행·저장·삭제하는 예제 → [[Reports and Dashboards REST API — 개요·Reports 예제]]
- 대시보드 데이터 조회·리포트 PDF/PNG 다운로드·알림 CRUD 예제 → [[Reports and Dashboards REST API — Dashboards·Downloads·Notifications 예제]]
- `reportMetadata`에 어떤 속성이 있나 (정본) → [[Reports and Dashboards REST API — Describe(reportMetadata) 표현형]]
- 동기/비동기 실행·인스턴스·인스턴스 결과·리포트 목록 응답 구조 → [[Reports and Dashboards REST API — Execute·Instances·Report List 표현형]]
- 저장 안 하고 리포트 돌리기(query) → [[Reports and Dashboards REST API — Query 표현형]]
- 리포트 필드·에러 코드 → [[Reports and Dashboards REST API — Report Fields·Error Codes 표현형]]
- 리포트 유형(Report Type) 목록·숨기기 → [[Reports and Dashboards REST API — Report Types 표현형]]
- 대시보드 표현형 전체(목록·결과·describe·상태·필터·에러) → [[Reports and Dashboards REST API — Dashboards 표현형]]
- 리포트 폴더·공유·수신자·하위 폴더 REST → [[Reports and Dashboards REST API — Folders 표현형]]
- 다운로드·알림 목록·한도·필터 연산자 목록 → [[Reports and Dashboards REST API — Analytics Download·Notifications·Filter Operators 표현형]]

---

## CRM Analytics REST API (3노트)

> CRM Analytics(구 Tableau CRM/Wave) 플랫폼을 프로그램적으로 다루는 REST API(`/services/data/vXX.0/wave/*`). **지도** 노트가 진입점(asset 엔드포인트 요약 + 경계 구분)이고, 데이터셋·XMD·쿼리 상세는 스포크로 위임한다. 표준 리포팅의 `/analytics/*`(위 Reports and Dashboards REST API)와 혼동 금지.

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[CRM Analytics REST API — 개요·인증·asset 엔드포인트 지도]] | ★진입점 — 두 Analytics REST API(`/wave` vs `/analytics`) 경계 + 인증 + asset 리소스(Lens·Dashboard·Folder·Template·Limits·Dependencies) 지도. 데이터셋·XMD·쿼리는 스포크로 위임 | #overview #map |
| [[CRM Analytics REST API — Datasets·Versions·XMD 표현형]] | Dataset·Dataset Version·확장 메타데이터(XMD) 리소스 엔드포인트·응답 표현형·enum 전수 | #reference |
| [[CRM Analytics REST API — Query 실행 (SAQL·SQL)]] | `POST /wave/query`로 SAQL/SQL 쿼리 직접 실행 — SaqlQueryInput 요청·Literal JSON 응답, Apex Wave 빌더 경로와 대비 | #reference |

### 빠른 선택 — CRM Analytics REST API

- 처음 시작 / `/wave` vs `/analytics` 구분·인증·asset 엔드포인트 큰 그림 → [[CRM Analytics REST API — 개요·인증·asset 엔드포인트 지도]]
- 데이터셋·데이터셋 버전·XMD 속성을 REST로 조회 → [[CRM Analytics REST API — Datasets·Versions·XMD 표현형]]
- SAQL/SQL 쿼리를 REST로 실행 (`/wave/query`) → [[CRM Analytics REST API — Query 실행 (SAQL·SQL)]]

---

## 관련 폴더

- 동일 폴더: Reports and Dashboards REST API(ING-08) — 위 섹션 11노트로 수용 완료
- 표준/커스텀 sObject·데이터 소스 객체 레퍼런스 → [[sObject/index|sObject Reference]]
- Apex에서의 외부 데이터 연동 → [[Apex/Integration(통합)/index|Apex Integration(통합)]]
