---
tags: [Analytics, CRMAnalytics, REST, Wave, TableauCRM, 지도]
source: developer.salesforce.com/docs/atlas.en-us.bi_dev_guide_rest.meta/bi_dev_guide_rest/ — CRM Analytics REST API Developer Guide v67.0 Summer '26, 2026-07-18 접속, Tier 2
created: 2026-07-18
aliases: [CRM Analytics REST API, Tableau CRM REST, Wave REST, /wave, analytics asset API, CRM 애널리틱스 REST]
---

# CRM Analytics REST API — 개요·인증·asset 엔드포인트 지도

> CRM Analytics(구 Tableau CRM/Wave) 플랫폼을 프로그램적으로 다루는 REST API의 지도 노트. 모든 리소스는 프리픽스 `/services/data/vXX.0/wave/*`를 쓴다. 표준 리포트·대시보드를 다루는 별개의 "Reports and Dashboards REST API"(`/analytics/*`)와 혼동하지 말 것. asset 리소스(Lens·Dashboard·Folder·Template·Limits·Dependencies)는 여기서 요약하고, 데이터셋·XMD·쿼리는 스포크 노트로 위임한다.

---

## 1. 두 Analytics REST API의 경계 (첫 문단 — 필수 구분)

Salesforce에는 이름이 비슷한 두 Analytics REST API가 있고 **서로 별개의 문서·엔드포인트 프리픽스**를 쓴다. 이 노트는 앞의 것이다.

| | **CRM Analytics REST API** (이 노트) | Reports and Dashboards REST API (별개) |
| --- | --- | --- |
| 대상 | CRM Analytics / Tableau CRM / Wave 플랫폼 | 표준 Reports & Dashboards 기능 |
| deliverable(문서) | `atlas.en-us.bi_dev_guide_rest.meta` | `atlas.en-us.api_analytics.meta` |
| 엔드포인트 프리픽스 | **`/wave/*`** (datasets·datasetversions·xmd·query·lenses·dashboards·folders 등) | **`/analytics/*`** (`/analytics/reports`, `/analytics/dashboards`) |
| 위키 노트 | 이 지도 + 스포크 2개 | [[Reports and Dashboards REST API — 개요·Reports 예제]] 등 |

> 여기서 말하는 "Dashboard/Lens"는 `/wave/dashboards`·`/wave/lenses`(CRM Analytics asset)이고, `/analytics/dashboards`(표준 대시보드)와 다르다. 다운로드(이미지/PDF)나 표준 리포트는 Reports and Dashboards REST API 소관이다.

---

## 2. 가이드 정체성 · 할 수 있는 것

CRM Analytics REST API로 datasets·dashboards·lenses 등 CRM Analytics 기능을 프로그램적으로 접근한다. 이 API는 **Connect REST API 기반**이며 그 규약을 따른다. 대표 기능(소스 Overview 발췌):

- CRM Analytics Platform에 쿼리 직접 전송 · 임포트된 데이터셋 접근
- lens 생성·조회, 앱 template 생성·검증·수정, dashboard·lens·dataflow 이전 버전 백업/복원(History API)
- dataflow·recipe·connection 실행·스케줄·동기화, dataflow job node 목록·상세 조회
- XMD 정보 접근, 표준 데이터셋 생성·조회, 데이터셋 버전 목록 조회
- Data 360 data model object를 데이터셋으로 변환, 앱 생성·조회, 의존성 목록 조회
- 사용자에게 가용한 기능 판별(Feature Configuration), Trend 리포트 스냅샷 작업/스케줄
- synced 데이터셋(connected object) 조작, 'eclair' geo map 차트 CRUD, data connector 작업
- recipe 메타데이터 조회·수정, 공유 상속 지원 여부 판별, auto-install request CRUD, collection CRUD
- email subscription CRUD, watchlist 생성·조회, JSON template 변환 규칙 테스트, asset·asset 파일 조회

> **API End-of-Life:** Salesforce는 각 API 버전을 최초 릴리즈로부터 최소 3년 지원한다. 3년 초과 버전은 지원 종료될 수 있다.

---

## 3. 인증 (OAuth — Connect REST API 위임)

Connect REST API는 OAuth로 앱을 식별한 뒤 Salesforce에 연결한다. **CRM Analytics REST API 가이드의 인증 페이지는 OAuth 세부를 Connect REST API Developer Guide의 "OAuth and Connect REST API"로 위임**한다(현재 OAuth 정보는 그쪽 참조). 참고 리소스: Connected Apps, Authorize Apps with OAuth, OpenID Connect Token Introspection, Trailhead "Build Integrations Using Connected Apps".

---

## 4. 베이스 URL · 18자 ID 규칙

모든 리소스는 세 부분으로 접근한다:

```
https://yourInstance.salesforce.com   ← 베이스 URL(회사 인스턴스)
  + /services/data/v53.0              ← 버전 정보
  + /wave                             ← 명명 리소스
= https://yourInstance.salesforce.com/services/data/v53.0/wave
```

**Org·Object 식별자:** Salesforce와 CRM Analytics UI의 Id는 보통 15자·base-62·case-sensitive 문자열이다(JSON XMD도 그렇다). 그러나 CRM Analytics REST API를 포함한 많은 Salesforce API는 **18자·case-insensitive** 문자열을 쓴다(예: Dataset 리소스의 Id `/wave/datasets/<dataset ID>`). 마지막 3자리는 앞 15자의 checksum이다. 18자 Id를 15자로 되돌리려면 마지막 3자를 제거한다.

**응답 필터링:** CRM Analytics REST API 입력 파라미터 외에 Connect REST API 입력 파라미터 `filterGroup`, `external`, `internal`로 결과를 필터할 수 있다("Specifying Response Sizes" 참조).

---

## 5. General Resources (최상위)

| Resource | 설명 | HTTP Method | Resource URL |
| --- | --- | --- | --- |
| Actions Resource | Analytics에서 사용자에게 가용한 Salesforce action 반환 | GET | `/wave` |
| Dependencies Resource | asset의 의존성 반환 | GET | `/wave/dependencies/<folderId>` |
| Feature Configuration Resource | 사용자에게 가용한 CRM Analytics 기능 반환 | GET | `/wave/config/features` |
| JsonXform Transformation Resource | JSON 변환 수행 | POST | `/jsonxform/transformation` |
| Limits Resource | org의 Analytics 한도 조회 | GET | `/wave/limits` |
| Query Resource | SAQL(또는 SQL)로 작성된 쿼리 실행 | POST | `/wave/query` |
| Security Resources | object·데이터셋 버전의 공유 상속 지원 여부 판별 | GET | `/wave/security/coverage/datasets/<datasetIdOrApiName>/versions/<versionId>` · `/wave/security/coverage/objects/<objectApiName>` |
| Wave Resource | CRM Analytics 최상위 리소스 나열 | GET | `/wave` |

- **Wave Resource** — `/wave`, GET, Available Version 36.0. GET Response = Directory Item Collection.

---

## 6. Asset 리소스 맵 (엔드포인트 · HTTP 메서드)

CRM Analytics asset 리소스의 진입점 지도. 데이터셋·XMD·쿼리는 스포크로 위임하고(아래 12절), Lens·Dashboard·Folder·Template·Limits·Dependencies는 여기서 요약 흡수한다.

| 도메인 | 대표 엔드포인트 | HTTP Method | 표현형(요청/응답) |
| --- | --- | --- | --- |
| Datasets | `/wave/datasets` · `/wave/datasets/<id>` · `.../versions` · `.../versions/<vId>` · `.../files/<fId>` | GET POST / GET DELETE PATCH / GET / GET PATCH / GET | Dataset(Collection)·DatasetVersion — 스포크 위임 |
| Xmd | `/wave/datasets/<id>/versions/<vId>/xmds` · `.../xmds/<type>` · `/wave/assets/<id>/xmds/asset` | GET / GET PUT / GET | Xmd·XmdMetadata Collection — 스포크 위임 |
| Query | `/wave/query` | POST | SaqlQueryInput / Literal JSON — 스포크 위임 |
| Lenses | `/wave/lenses` · `/wave/lenses/<id>` · `.../bundle` · `.../files/<fId>` | GET POST / GET DELETE PATCH / GET PUT / GET PUT | Lens(Collection)·Lens Input |
| Dashboards | `/wave/dashboards` · `/wave/dashboards/<id>` (+ bundle·histories·publishers·savedviews·image) | GET POST / GET DELETE PATCH | Dashboard(Collection)·Dashboard Input |
| Folders (=App) | `/wave/folders` · `/wave/folders/<id>` · `.../schedule` · `.../settings` | GET POST / GET DELETE PATCH PUT / GET PATCH DELETE / GET PUT | Wave Folder(Collection)·(Template) Input |
| Templates | `/wave/templates` · `/wave/templates/<id>` (+ configuration·lint·releasenotes·validate) | GET POST / DELETE GET PUT | Template(Collection)·Template Input |
| Limits | `/wave/limits` | GET | Wave Analytics Limit Collection |
| Dependencies | `/wave/dependencies/<assetId>` | GET | Dependency |

### Lens (요약 흡수)

Analytics lens는 사용자가 데이터셋의 데이터를 보는 방식이며 dashboard 구축의 기반이다.

| Resource | 설명 | HTTP Method | URL |
| --- | --- | --- | --- |
| Lenses List | lens 컬렉션 반환·lens 생성 | GET POST | `/wave/lenses` |
| Lens | lens 구조 JSON 반환·삭제·수정 | GET DELETE PATCH | `/wave/lenses/<lensIdOrApiName>` |
| Lens Bundle | lens bundle 구조 JSON 반환·수정 | GET PUT | `/wave/lenses/<lensIdOrApiName>/bundle` |
| Lens File | lens의 일부 파일 반환 | GET PUT | `/wave/lenses/<lensIdOrApiName>/files/<files ID>` |

- Lenses List GET 파라미터: `folderId`(ID) · `page`(String) · `pageSize`(Integer, 1~200, 기본 25) · `q`(String) · `scope`(ConnectWaveScopeTypeEnum: `CreatedByMe`·`Mru`·`SharedWithMe`) · `sort`(ConnectWaveSortOrderTypeEnum: `App`·`CreatedBy`·`CreatedDate`·`LastModified`·`LastModifiedBy`·`Mru`·`Name`·`Type`). Apex: `Wave.Lenses.getLenses()`.

### Dashboard (asset) — 요약 흡수

Analytics dashboard 리소스: collection·individual·saved view·histories·publisher를 관리한다. 추가 하위 리소스 — Dashboard Bundle(`.../bundle`, GET PUT), Dashboard Histories(`.../histories`, GET), Dashboard Publishers List(`.../publishers`, GET DELETE POST), Dashboard Publisher(`.../publishers/<assetPublisherId>`, GET DELETE), Dashboard Image(`.../image`, asset reference 반환), Dashboard Saved Views List(`.../savedviews`, GET POST), Dashboard Saved View(`.../savedviews/<viewID>`, GET DELETE PATCH), Dashboard Saved Views Initial(`.../savedviews/initial`, GET).

- Dashboards List GET 파라미터: `folderId` · `ids`(52.0) · `mobileOnly`(Boolean, 41.0) · `page` · `pageSize`(1~200, 기본 25) · `q` · `scope`(`CreatedByMe`·`Mru`·`SharedWithMe`) · `sort`(위 Lens와 동일 enum) · `templateApiName`(String) · `type`(ConnectWaveAssetTypeEnum, 기본 `Dashboard`).
- **ConnectWaveAssetTypeEnum 전수:** `Collection` · `Component` · `Dashboard` · `DashboardSavedView` · `DashboardSnapshot` · `DataConnector` · `Dataflow` · `DataflowJob` · `DataflowJobNode` · `Dataset` · `DatasetShard` · `DatasetVersion` · `ExternalData` · `Folder` · `Lens` · `LightningComponent` · `LightningDashboard` · `LightningDashboardFolder` · `Recipe` · `RecipeConfiguration` · `RecipeModel` · `ReplicatedDataset` · `Report` · `ReportFolder` · `Story` · `Widget` · `Workflow`.

### Folder (=App) — 요약 흡수

Analytics folder는 app(asset 모음)을 나타낸다. 사용자 또는 Analytics template이 생성한다. 하위: Folders List(`/wave/folders`, GET POST), Folder(`/wave/folders/<id>`, GET DELETE PATCH PUT), Folder Schedule(`.../schedule`, GET PATCH DELETE), Folder Settings(`.../settings`, GET PUT).

- Folders List GET 파라미터: `isPinned`(Boolean) · `mobileOnlyFeaturedAssets`(Boolean, 43.0) · `page` · `pageSize`(1~200, 기본 25) · `q` · `scope`(`Browse`·`CreatedByMe`·`InsightsApplicationsIsCansEdit`·`Mru`·`SharedWithMe`) · `sort`(ConnectWaveSortOrderTypeEnum: `App`·`CreatedBy`·`CreatedById`·`CreatedDate`·`FolderName`·`LastModified`·`LastModifiedBy`·`LastModifiedById`·`LastModifiedDate`·`Location`·`Mru`·`Name`·`Outcome`·`Owner`·`RefreshDate`·`RunDate`·`Status`·`Title`·`Type`) · `templateFilters`(ConnectWaveTemplateSearchFiltersEnum: `AppsConstructedByTemplate`·`AppsWithInstallHistory`, 57.0) · `templateSourceId`(String). Request(POST) = Wave Folder Input 또는 Wave Folder Template Input(둘 다 Base Wave Folder Input 구현).

### Template — 요약 흡수

Analytics template·구성·release note를 관리한다. 하위: Templates List(`/wave/templates`, GET POST), Template(`/wave/templates/<id>`, GET PATCH DELETE), Template Configuration(`.../configuration`, GET), Template Lint(`.../lint`, GET DELETE PUT), Template Release Notes(`.../releasenotes`, GET), Template Validate(`.../validate`, POST — org readiness check).

- Templates List GET 파라미터: `options`(ConnectWaveTemplateVisibilityOptionsEnum: `CreateApp`·`ManageableOnly`·`OrgCanViewOnly`·`ViewOnly`, 52.0) · `type`(ConnectWaveTemplateTypeEnum: `App`·`Dashboard`·`Data`·`Embedded`·`Lens`, 36.0).

### Limits — 요약 흡수

`/wave/limits`, GET, Available Version 51.0. Response = Wave Analytics Limit Collection. LWC: `getAnalyticsLimits()`.

- **`licenseType` (ConnectAnalyticsLicenseTypeEnum) 전수:** `Cdp` (Data 360) · `DataPipelineQuery` (Data Pipeline Query) · `EinsteinAnalytics` (CRM Analytics) · `IntelligentApps` (Intelligent Apps) · `Sonic` (Salesforce Data Pipeline).
- **`types` (ConnectAnalyticsLimitTypeEnum) 전수:** `BatchTransformationHours` (월별 최대 dataflow 실행 시간) · `DatasetQueries` (전체 사용자 데이터셋 최대 쿼리 수) · `DatasetRowCount` (전체 데이터셋 합산 최대 행) · `MaxDailyRowsDataCloudOutputCon` (rolling 24h당 Data 360 output 최대 행) · `MaxDailyRowsHighOutputCon` (rolling 24h당 high volume tier output connector 최대 행) · `MaxDailyRowsLowOutputCon` (low volume tier) · `MaxDailyRowsMedOutputCon` (medium volume tier) · `MaxDailySizeHighOutputCon` (high volume tier 최대 데이터 크기) · `MaxDailySizeLowOutputCon` (low volume tier) · `MaxDailySizeMedOutputCon` (medium volume tier) · `MaxDailySizeVirtualPrivateCloudCon` (rolling 24h당 VPC connection 누적 바이트) · `MaxDailyUploadVolume` (rolling 24h당 업로드 데이터 파일 누적 바이트) · `MaxDailyWorkflowExecutions` (rolling 24h당 dataflow·recipe 실행 수) · `MaxRecipeOutRowsPerMonth` (월별 전체 recipe output 최대 행) · `MaxReplicatedObjects` (최대 connected object 수) · `OutputLocalConnectorVolume` (rolling 24h당 Salesforce 기록 데이터 파일 누적 바이트) · `StagedDatasetRowCount` (staged 데이터셋 최대 행).

### Dependencies — 요약 흡수

`/wave/dependencies/<assetId>`, GET, Available Version 36.0. Response = Dependency. **view 접근이 있는 asset만** 반환. LWC: `getDependencies()`.

---

## 7. 인접 API와의 경계

- **Recipe(Data Prep) REST** — recipe 메타데이터 조회·수정, 스케줄·실행은 별도 Recipe 리소스 세트로 다룬다 → [[Data Prep Recipe REST API — 개요·인증·엔드포인트]].
- **Apex Wave 네임스페이스** — Apex 안에서 SAQL 빌더로 쿼리·lens·template을 다루는 경로 → [[Wave Namespace]]. REST 직접 호출과 대비된다.
- **Reports and Dashboards REST API** — 표준 리포트·대시보드·다운로드(`/analytics/*`) → [[Reports and Dashboards REST API — 개요·Reports 예제]].
- Backup/Restore(History API)·dataflow·connector·watchlist·subscription·eclair chart 등은 이 가이드의 다른 리소스 섹션에 있으며 본 위키에는 미커버(콘텐츠 갭).

---

## 8. 위임 스포크

이 지도의 세부는 두 스포크가 property·enum 전수로 보유한다:

- **Datasets·Versions·XMD** — Dataset/DatasetVersion/Xmd 및 14개 XMD 표현형(총 26 표현형) 전수 → [[CRM Analytics REST API — Datasets·Versions·XMD 표현형]]
- **Query 실행(SAQL·SQL)** — `POST /wave/query`, SaqlQueryInput, SAQL/SQL 모드 예제 → [[CRM Analytics REST API — Query 실행 (SAQL·SQL)]]

---

## 관련 노트

- [[CRM Analytics REST API — Datasets·Versions·XMD 표현형]] — 데이터셋·버전·XMD 스포크
- [[CRM Analytics REST API — Query 실행 (SAQL·SQL)]] — `/wave/query` 스포크
- [[Wave Namespace]] — Apex `Wave` 네임스페이스(SAQL 빌더)
- [[Data Prep Recipe REST API — 개요·인증·엔드포인트]] — Recipe REST 경계
- [[Reports and Dashboards REST API — 개요·Reports 예제]] — `/analytics/*` 표준 리포팅 API 경계
- [[Analytics 개요 — 표준 리포팅 vs CRM Analytics·API 선택 가이드]] — Analytics API 선택 지도
