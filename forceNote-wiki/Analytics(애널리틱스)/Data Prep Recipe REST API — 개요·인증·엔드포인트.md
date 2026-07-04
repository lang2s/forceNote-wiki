---
tags: [analytics, crm-analytics, data-prep, recipe, rest-api, connect-rest]
source: salesforce_recipes_api.pdf (Data Prep Recipe REST API Developer Guide, Summer '26) · help.salesforce.com — Enable CRM Analytics and Create Permission Sets (sf.bi_setup_enable_create_permset.htm), CRM Analytics Permission Set Licenses and User Permissions (bi_setup_user_permissions.htm) [Tier 2]
created: 2026-06-21
aliases: [Data Prep Recipe REST API, CRM Analytics Recipe API, 레시피 REST API, wave recipes 엔드포인트, 레시피 실행 스케줄, dataflowjobs]
---

# Data Prep Recipe REST API — 개요·인증·엔드포인트

> CDP·Salesforce Data Pipelines·CRM Analytics의 **Data Prep recipe**를 프로그래밍적으로 조회·수정·스케줄·실행하는 Connect REST API 기반 엔드포인트 모음. recipe 메타데이터 조회/수정, 버전 히스토리 revert, 스케줄·실행·알림까지 자동화한다.

---

## 개요 (Overview)

Recipe REST API로 CDP, Salesforce Data Pipelines, CRM Analytics용 Data Prep recipe에 프로그래밍적으로 접근할 수 있다. 이 API로 할 수 있는 일:

- **Run, schedule, and sync recipes** — recipe 실행·스케줄·동기화 (*Run, Schedule, and Sync CRM Analytics Data with REST APIs* 참조)
- **Retrieve or update recipe metadata** — recipe 메타데이터 조회·수정 (*Build, Manage, Schedule, and Run Recipes with REST APIs* 참조)

Recipe REST API는 **Connect REST API 기반**이며 그 규약(conventions)을 따른다. Connect REST API 자세한 내용은 *Connect REST API Developer Guide* 참조. connector·dataset 같은 Analytics asset 리소스는 *Analytics REST API Developer Guide* 참조.

### Release Notes

Data Prep Recipes Connect REST API의 최신 업데이트·변경은 Salesforce Release Notes로 확인한다. 신규·변경된 REST 리소스·request/response body는 Release Notes의 **CRM Analytics** 섹션에서 *Data Prep Recipes REST API* 항목을 찾는다.

> [!note] Release Notes에 *API: New and Changed Items* 섹션이 없으면, 그 릴리스에 업데이트가 없다는 뜻이다.

---

## ⚠️ 전제조건 (Prerequisites — org 활성화·사용자 라이선스)

OAuth 인증만으로는 `/wave/recipes` 등 recipe 엔드포인트가 동작하지 않는다. 아래 org 활성화와 사용자 라이선스/퍼미션이 **먼저** 갖춰져야 하며, 없으면 첫 recipe 호출부터 접근이 막힌다.

**1. org에서 CRM Analytics(Tableau CRM) 활성화**

- Setup → **Analytics / CRM Analytics → Enable** 로 org 차원에서 CRM Analytics를 먼저 활성화해야 한다. 활성화 전에는 모든 recipe(및 Data Prep) 엔드포인트 접근 불가.

**2. 호출 사용자에게 CRM Analytics 퍼미션셋 라이선스(PSL) 할당**

- 각 CRM Analytics 사용자는 **CRM Analytics Growth**(또는 CRM Analytics Plus) 퍼미션셋 라이선스가 필요하다.
- PSL을 담은 퍼미션셋을 만들어 사용자에게 할당한다. recipe를 만들고 관리하려면 **`Manage CRM Analytics`**, 조회/사용만 하려면 **`Use CRM Analytics`** + 외부 데이터 업로드가 필요하면 **`Upload External Data to CRM Analytics`** 시스템 퍼미션을 부여한다.

> [!important] 위 org 활성화와 사용자 라이선스/퍼미션이 없으면 OAuth 토큰이 유효해도 recipe 리소스 요청이 실패한다. `licenseType`(`EinsteinAnalytics`·`Cdp` 등) 파라미터는 결과 **필터링용**일 뿐, 사용자 라이선스 전제를 대체하지 않는다.
>
> 상세: Salesforce Help *Enable CRM Analytics and Create Permission Sets* · *CRM Analytics Permission Set Licenses and User Permissions* 참조.

---

## 인증 (Connect REST API Authorization)

Connect REST API는 **OAuth**를 사용해 Salesforce에 연결하기 전 애플리케이션을 안전하게 식별한다.

> OAuth 메커니즘 본문은 이 노트 범위 밖이다. 최신 OAuth 정보는 *Connect REST API Developer Guide*의 **OAuth and Connect REST API** 참조.

### More Resources (커넥티드 앱·OAuth 탐색용)

- Salesforce Help: Connected Apps
- Salesforce Help: Authorize Apps with OAuth
- Salesforce Help: OpenID Connect Token Introspection
- Trailhead: Build Integrations Using Connected Apps

---

## API End-of-Life Policy

Salesforce는 각 API 버전을 **최초 릴리스일로부터 최소 3년간** 지원한다. API의 품질·성능을 개선하기 위해, 3년이 넘은 버전은 지원이 중단될 수 있다.

- API 버전이 deprecate 예정일 때는 **지원 종료 최소 1년 전에** 사전 통지한다. Salesforce는 deprecate 예정 버전을 사용하는 고객에게 직접 통지한다.
- retired API 버전의 리소스를 요청하거나 작업을 사용하면 REST API는 **`410:GONE`** 오류 코드를 반환한다.
- 오래되거나 미지원 API 버전에서 온 요청을 식별하려면 무료 **API Total Usage event type**에 접근한다.

### Version Support Status

| API 버전 | Retirement 정보 |
|---|---|
| Versions 31.0 through 66.0 | **Supported.** |
| Versions 21.0 through 30.0 | **Summer '25 기준 retired** 되어 사용 불가 (Salesforce Platform API Versions 21.0 through 30.0 Retirement) |
| Versions 7.0 through 20.0 | **Summer '22 기준 retired** 되어 사용 불가 (Salesforce Platform API Versions 7.0 through 20.0 Retirement) |

---

## Examples — Manage, Schedule, and Run Recipes with REST APIs

Connect REST API로 recipe를 다루고 자동화한다. 기존 recipe 탐색(discover), recipe 버전 revert, recipe 스케줄·실행이 가능하다.

> Recipe REST API 사용 시 유의:
> - request parameter는 리소스 URL의 일부로 포함할 수 있다. 예: `/wave/recipes?q=searchtext`
> - request body는 request에 포함하는 rich input이다. 리소스에 접근할 때 **request body 또는 request parameter 중 하나만** 사용할 수 있다 — 둘 다는 불가.
> - request body 사용 시 `Content-Type: application/json` 또는 `Content-Type: application/xml`
> - request parameter 사용 시 `Content-Type: application/x-www-form-urlencoded`

### Describe and Discover Recipes

`GET wave/recipes` 엔드포인트로 모든 recipe를 조회한다. 반환되는 collection은 다음으로 필터링할 수 있다 (Examples 섹션의 필터 설명 — 전체 파라미터 표는 아래 [Recipes List Resource](#recipes-list-resource-waverecipes) 참조):

- **format** — 현재 Data Prep recipe(R3) 또는 Data Prep Classic recipe(R2) 지정

```
/wave/recipes?format=R2
```

- **licenseType** — 라이선스 타입 지정: `EinsteinAnalytics`, `Sonic`, `MulesoftDataPath`, `Cdp`

```
/wave/recipes?licenseType=EinsteinAnalytics
```

- **pageSize** — 페이지네이션 시 collection에 반환할 항목 수. 최소 `1`, 최대 `200`, 기본 `25`

```
/wave/recipes?pageSize=50
```

- **q** — 검색어로 name·label 기준 recipe 검색. 개별 토큰은 공백으로 구분. 쿼리 문자열의 마지막 토큰에 wildcard가 자동 추가됨

```
/wave/recipes?q=My Recipe
```

- **sort** — 반환 collection에 적용할 정렬 순서. 유효 값(Examples 기준): `App`, `CreatedBy`, `CreatedDate`, `LastModified`, `LastModifiedBy`, `Mru`, `Name`, `Type`

```
/wave/recipes?sort=Name
```

> [!tip] LWC wire adapter `lightning/analyticsWaveApi` `getRecipes()`가 Lightning Experience 내부에서 동일 기능을 제공한다.

### Describe an Existing Recipe

`recipeId`(`05vB`로 시작)와 recipe format(`R3` 또는 `R2`)을 지정해 특정 recipe를 조회한다.

```
/wave/recipes/05vB0000000xxxxxxx?format=R3
```

> [!important] v48 이상에서 생성된 recipe는 **R3만** 가능하며 R2로 변환할 수 없다.

GET 요청은 **Recipe** response를 반환한다 — recipe definition(nodes + UI metadata), schedule attributes, validation details 포함. recipe 실행에 쓰이는 `targetDataflowId`도 포함된다.

```json
{
  ...
  "format" : "R3",
  "id" : "05vB0000000xxxxxxx",
  "label" : "MyTestRecipe",
  "name" : "MyTestRecipe",
  ...
  "recipeDefinition" : {
    ...
  },
  "scheduleAttributes" : {
    ...
  },
  "targetDataflowId" : "02KB000000xxxxxxxx",
  ...
  "validationDetails" : [ ]
}
```

> [!tip] LWC wire adapter `lightning/analyticsWaveApi` `getRecipe()`가 동일 기능 제공.

### Inspect Recipe Nodes

Recipe Definition은 recipe name, recipe API version, (Data Manager가 쓰는) 표시용 UI metadata, 그리고 **Recipe Node 객체의 Map**을 담는다.

아래는 Opportunities sObject로 만든 데이터를 로드 → Closed Won으로 필터 → `Opptys Closed Won`이라는 새 dataset으로 저장하는 간단한 recipe의 Recipe Node Map 예시다.

```json
{
  ...
  "recipeDefinition": {
    "nodes" : {
      "LOAD_DATASET0" : {
        "action" : "load",
        "parameters": {
          "dataset" : {
            "label" : "Opportunities",
            "name" : "opportunity",
            "type" : "analyticsDataset"
          },
          "fields" : ["AccountId", "Amount", "OpenClosedWonLost", ...]
        },
        "sources" : []
      },
      "FILTER0" : {
        "action" : "filter",
        "parameters" : {
          "filterExpressions" : [ {
            "field" : "OpenClosedWonLost",
            "operands" : [ "Closed Won" ],
            "operator" : "EQUAL",
            "type" : "TEXT"
          } ]
        },
        "sources": [ "LOAD_DATASET0" ]
      },
      "OUTPUT0" : {
        "action" : "save",
        "parameters": {
          "dataset" : {
            "folderName" : "SharedApp",
            "label" : "Opptys Closed Won",
            "name" : "OpptysClosedWon",
            "type" : "analyticsDataset"
          },
          "fields" : []
        },
        "sources" : [ "FILTER0" ]
      }
    },
    "ui" : { ... },
    "version" : "52.0"
  },
  ...
}
```

Map의 각 node 엔트리는 string name과 Recipe Node로 구성된다. Recipe Node는 node `action`, `parameters`, `sources`를 담는다. 각 node 타입은 action에 따라 다른 parameter를 갖는다 (node 타입별 세부는 *Recipe Node reference* 참조).

> [!important] save action의 `dataset` 속성의 `label` 속성은 사용자가 Analytics Studio에서 탐색하는 dataset의 **표시 이름**이다.

### Delete a Recipe

`DELETE /wave/recipes/<recipeId>` 엔드포인트로 recipe를 삭제한다. 이 작업은 recipe와 연관된 모든 dataflow job을 함께 삭제한다. request body는 필요 없고, response는 성공/오류 메시지다.

> [!tip] LWC wire adapter `lightning/analyticsWaveApi` `deleteRecipe()`가 동일 기능 제공.

### Work with Recipe Histories

사용자가 recipe를 수정·저장할 때마다 version history가 생성되어 변경 이력을 추적한다. recipe의 모든 history를 보려면 `GET /wave/recipes/<recipeId>/histories` 엔드포인트를 쓴다.

현재 recipe를 이전 버전으로 revert하려면, revert할 history의 id를 얻어 `PUT /wave/recipes/<recipeId>` 엔드포인트에 revert request를 보낸다.

> [sic] Examples 섹션은 이 revert request body를 **"Asset Review History Input"** 으로 표기하지만, Resource 섹션은 동일한 PUT revert를 **"Asset Revert History Input"** 으로 표기한다. (같은 작업의 표기 불일치 — 원문 그대로)

```json
{
  "historyId" : "0RmB0000000xxxxxxx",
  "historyLabel" : "Reverting to version x"
}
```

asset version history 자세한 내용은 *Backup and Restore Previous Versions of CRM Analytics Assets with History API* 참조.

### Schedule a Recipe

`scheduleAttributes`는 Recipe의 일부이지만, 스케줄을 **업데이트**하려면 `/wave/asset/<assetId>/schedule` 엔드포인트를 써야 한다. (`<assetId>`는 recipe id)

- 현재 스케줄 조회: `GET /wave/asset/<assetId>/schedule` → **Schedule** response 반환
- 스케줄 생성/업데이트: `PUT /wave/asset/<assetId>/schedule` (예시 Schedule Input은 *Schedule Dataflows, Recipes, and Data Syncs* 참조)
- 스케줄 삭제: `DELETE /wave/asset/<assetId>/schedule`

### Run a Recipe

스케줄 유무와 무관하게 recipe를 실행하려면 `/wave/dataflowjobs` **POST** 엔드포인트를 쓴다.

POST는 dataflow job을 start하기 위해 `dataflowId`와 `command`를 받는다. recipe의 경우 `dataflowId`는 Recipe의 `targetDataflowId`이며, recipe의 `targetDataflowId`는 **`02KB`**로 시작한다.

`GET /wave/recipes/05vB0000000xxxxxxx?format=R3` response에서 `targetDataflowId`를 얻은 뒤 `POST /wave/dataflowjobs` request body에 사용한다.

```json
{
  "dataflowId": "02KB000000xxxxxxxx",
  "command": "start"
}
```

실행 중인 recipe dataflow job을 중지하려면 `/wave/dataflowjobs/<dataflowjobId>` **PATCH** 엔드포인트에 stop command를 보낸다.

```json
{
  "command": "stop"
}
```

### Recipe Notifications

Recipe notification은 job이 장시간 실행되거나 실패할 때 사용자에게 알린다. 모든 recipe는 기본 notification level **`warnings`**로 생성된다.

- notification level 조회: `GET /wave/recipes/<recipeId>/notification`
- notification level 또는 long running alert 타이밍 업데이트: `PUT /wave/recipes/<recipeId>/notification` (Recipe Notification Input request 사용)

```json
{
  "notificationLevel" : "Always",
  "longRunningAlertInMins" : 90
}
```

---

## Resources — Recipes REST Resources

REST API 리소스는 endpoint라고도 부른다. Recipe는 변환(transformation)으로 데이터를 가공해 dataset을 만들거나 sObject를 업데이트하는 데 쓰인다.

### Available Resources (개요표)

> [!warning] 개요표와 각 리소스 상세 섹션 사이에 **HTTP Method·URL 불일치**가 있다. 아래 표는 개요표 값이며, **실제 구현은 상세 섹션을 우선**한다 (상세 섹션 컬럼에 병기). 특히 Recipe Configurations List의 URL은 개요표가 `/wave/recipes-configurations`로 [sic] 표기되어 있다.

| Resource | 설명 | 개요표 HTTP Method | 개요표 URL | 상세 섹션 HTTP Method (우선) |
|---|---|---|---|---|
| Recipes List Resource | Data Prep recipe collection 반환 및 recipe 생성 | `GET POST` | `/wave/recipes` | **`GET`** (POST 미지원 — 아래 주석) |
| Recipe Resource | Data Prep recipe 반환·수정·삭제 | `GET DELETE PATCH` | `/wave/recipes/<id>` | **`DELETE GET PATCH PUT`** (PUT 추가) |
| Recipe File Resource | recipe 파일 내용을 JSON으로 반환 | `GET` | `/wave/recipes/<id>/file` | **`GET`** |
| Recipe Notification Resource | recipe job notification 반환·생성·수정 | `GET PATCH` | `/wave/recipes/<id>/notification` | **`GET PUT`** (PATCH 아님 — PUT) |
| Recipe Configurations List Resource | recipe configuration collection 반환·수정 및 configuration 생성 | `GET PATCH POST` | `/wave/recipes-configurations` [sic] | **`GET POST PATCH`**, URL `/wave/recipe-configurations` |
| Recipe Configuration Resource | recipe configuration 반환·수정·삭제 | `GET DELETE PATCH` | `/wave/recipe-configurations/<id>` | **`GET DELETE PATCH`** |

---

### Recipes List Resource — `/wave/recipes`

| 속성 | 값 |
|---|---|
| Resource URL | `/wave/recipes` |
| Formats | JSON |
| Available Version | 38.0 |
| Available in Postman | `getRecipeCollection` (인증은 *CRM Analytics Rest API Quickstart* 참조) |
| Available Components | LWC — `lightning/analyticsWaveApi` `getRecipes()` |
| HTTP Methods | **GET** |

> [!important] Recipe는 생성을 위해 recipe editor UI가 필요하며, **이 API 엔드포인트에서 POST로 생성하는 것은 지원되지 않는다.** (개요표는 `GET POST`로 표기되어 있으나 상세는 GET만 — [sic])

#### Request Parameters for GET

| Parameter Name | Type | 설명 | Required/Optional | Available Version |
|---|---|---|---|---|
| `folderId` | `Id` | 지정한 folder ID에 속한 recipe로 필터링된 collection 반환 | Optional | 61.0 |
| `format` | `ConnectRecipeFormatTypeEnum` | 현재 recipe definition의 format으로 필터링. 유효 값: `R2` (Data Prep Classic), `R3` (Data Prep) | Optional | 48.0 |
| `lastModifiedAfter` | `String` | 지정 값 **이후** last modified date인 recipe로 필터링 | Optional | 55.0 |
| `lastModifiedBefore` | `String` | 지정 값 **이전** last modified date인 recipe로 필터링 | Optional | 55.0 |
| `licenseType` | `ConnectAnalyticsLicenseTypeEnum` | Analytics license type으로 필터링 (값은 아래 enum) | Optional | 52.0 |
| `nextScheduledAfter` | `String` | 지정 값 **이후** scheduled run인 recipe로 필터링 | Optional | 55.0 |
| `nextScheduledBefore` | `String` | 지정 값 **이전** scheduled run인 recipe로 필터링 | Optional | 55.0 |
| `page` | `String` | 반환할 객체 view를 나타내는 generated token | Optional | 38.0 |
| `pageSize` | `Int` | 한 페이지에 반환할 항목 수. 최소 1, 최대 200, 기본 25 | Optional | 38.0 |
| `q` | `String` | 검색어. 개별 토큰은 공백 구분, 마지막 토큰에 wildcard 자동 추가. 따옴표·wildcard 등 특수문자는 URI의 쿼리 문자열에서 자동 제거됨 | Optional | 38.0 |
| `sort` | `ConnectWaveSortOrderTypeEnum` | 반환 collection에 적용할 정렬 순서 (값은 아래 enum) | Optional | 38.0 |
| `status` | `ConnectRecipeStatusEnum[]` | recipe의 status로 필터링 (값은 아래 enum) | Optional | 55.0 |

**`licenseType` 유효 값 (`ConnectAnalyticsLicenseTypeEnum`, 6값):**

- `Cdp` (Data 360)
- `DataPipelineQuery` (Data Pipeline Query)
- `EinsteinAnalytics` (CRM Analytics)
- `IntelligentApps` (Intelligent Apps)
- `MulesoftDataPath` (Mulesoft Data Works)
- `Sonic` (Salesforce Data Pipeline)

> Examples 섹션의 `licenseType` 설명은 4값(`EinsteinAnalytics`, `Sonic`, `MulesoftDataPath`, `Cdp`)만 나열하지만, 상세 파라미터 표는 위 6값 전체를 정의한다.

**`sort` 유효 값 (`ConnectWaveSortOrderTypeEnum`, 원문 bullet 18값 전수):**

`App`, `CreatedBy`, `CreatedById`, `CreatedDate`, `FolderName`, `LastModified`, `LastModifiedBy`, `LastModifiedById`, `LastModifiedDate`, `Location`, `Mru` (Most Recently Used, 마지막 조회일), `Name`, `Outcome`, `RefreshDate` (dataset 같은 asset용), `RunDate` (report 같은 asset용), `Status`, `Title`, `Type`

> 위는 원문 PDF의 bullet 목록을 그대로 옮긴 것으로 18개 토큰이다. (Examples 섹션은 동일 `sort`의 일부 값 8개 — `App`·`CreatedBy`·`CreatedDate`·`LastModified`·`LastModifiedBy`·`Mru`·`Name`·`Type` — 만 예시로 든다.)

**`status` 유효 값 (`ConnectRecipeStatusEnum[]`, 7값):**

`Cancelled`, `Failure`, `New` (한 번도 실행 안 됐거나 최근 실행 없음), `Queued`, `Running`, `Success`, `Warning`

`q` 파라미터를 GET 검색 쿼리로 쓰는 URL 예:

```
/wave/recipes?q=MyRecipe
```

#### Response Body for GET

**Recipe Collection**

---

### Recipe Resource — `/wave/recipes/<id>`

| 속성 | 값 |
|---|---|
| Resource URL | `/wave/recipes/<id>` |
| Formats | JSON |
| Available Version | 38.0 |
| Available in Postman | `getRecipe` (인증은 *CRM Analytics Rest API Quickstart* 참조) |
| HTTP Methods | **DELETE GET PATCH PUT** (개요표는 PUT 누락 — [sic]) |

**Available Components (LWC, 3개):**

- LWC — `lightning/analyticsWaveApi` `deleteRecipe()`
- LWC — `lightning/analyticsWaveApi` `getRecipe()`
- LWC — `lightning/analyticsWaveApi` `updateRecipe()`

> recipe **실행**은 Dataflow Jobs Resource API 사용 (*Start and Stop a Dataflow Job or Recipe* 참조). recipe **스케줄**은 Schedule Resource API 사용 (*Schedule Dataflows, Recipes, and Data Syncs* 참조).

#### Request Parameters for GET

| Parameter Name | Type | 설명 | Required/Optional | Available Version |
|---|---|---|---|---|
| `format` | `ConnectRecipeFormatTypeEnum` | 반환할 recipe의 format 지정. 유효 값: `R2` (Data Prep Classic), `R3` (Data Prep) | **Required** (Data Prep recipe), Optional (Data Prep Classic recipe) | 49.0 |
| `historyId` | `Id` | 특정 recipe 버전을 요청할 history ID | Optional | 51.0 |

`format` request parameter를 GET에 쓰는 URL 예:

```
/wave/recipes/<05vS7000000xxxxxxx>?format=R3
```

> [!note] API 버전 49.0 이상에서, Data Prep format으로 생성된 recipe는 `format` 파라미터가 **필수**다. Data Prep Classic format으로 생성된 recipe는 `format` 파라미터가 필요 없다. Data Prep Classic을 Data Prep format으로 up-convert하려면 `format=R3`으로 설정한다.

#### Response Body for GET, PATCH, and PUT

**Recipe**

#### Request Body for PATCH

| Property Name | Type | 설명 | Required/Optional | Available Version |
|---|---|---|---|---|
| `enableEditorValidation` | `Boolean` | recipe의 editor validation 활성(`true`)/비활성(`false`) 여부 | Required | 53.0 |
| `recipeFile` | `Binary` | recipe 파일 | Required | 38.0 |
| `recipeObject` | `RecipeInput[]` | recipe definition | Required | 38.0 |
| `validationContext` | `ConnectRecipeValidationContextEnum` | recipe validation context. 유효 값: `Default`, `Editor` | Required | 53.0 |

recipe의 license type을 업데이트하는 PATCH JSON 예:

```json
{
  "recipeObject" : {
    "licenseAttributes": { "type": "Sonic" }
  }
}
```

> [!note] recipe가 Data Prep Classic format으로 생성된 뒤 Data Prep format으로 조회된 상태에서 Data Prep format으로 PATCH하면, recipe가 Data Prep format으로 **영구 up-convert** 된다.

#### Request Body for PUT

PUT 요청은 이전 historical version으로 revert할 때 사용한다. (**Asset Revert History Input** — Examples 섹션은 같은 입력을 *Asset Review History Input*으로 [sic] 표기) recipe 버전 revert request JSON 예:

```json
{
  "historyId" : "0RmRM000000xxxxxxx"
}
```

---

### Recipe File Resource — `/wave/recipes/<id>/file`

Data Prep recipe의 파일 내용을 JSON으로 반환한다. **이 API 엔드포인트는 recipe UI용 내부(internal) 엔드포인트로, 디버깅·참조 목적으로만 제공된다. 이 내용의 수정은 지원되지 않는다.**

| 속성 | 값 |
|---|---|
| Resource URL | `/wave/recipes/<id>/file` |
| Formats | JSON |
| Available Version | 38.0 |
| HTTP Methods | **GET** |

#### Response Body for GET

**Streamed Representation** — 지정 파일의 JSON 내용을 binary stream으로 반환한다. 이 표현형은 recipe 2.0과 recipe 3.0에서 서로 다르다.

---

### Recipe Notification Resource — `/wave/recipes/<id>/notification`

Data Prep recipe job notification을 반환·생성·수정한다.

| 속성 | 값 |
|---|---|
| Resource URL | `/wave/recipes/<id>/notification` |
| Formats | JSON |
| Available Version | 49.0 |
| Available in Postman | `getRecipeNotification` (인증은 *CRM Analytics Rest API Quickstart* 참조) |
| Available Components | LWC — `lightning/analyticsWaveApi` `getRecipeNotification()` |
| HTTP Methods | **GET PUT** (개요표는 `GET PATCH`로 [sic] 표기) |

#### Response Body for GET and PUT

**Recipe Notification**

#### Request Body for PUT

**Recipe Notification Input** — 기존 recipe notification을 업데이트하는 JSON 예:

```json
{
  "longRunningAlertInMins" : 60,
  "notificationLevel": "Warnings"
}
```

---

### Recipe Configurations List Resource — `/wave/recipe-configurations`

Data Prep recipe configuration collection을 반환·수정하고 recipe configuration을 생성한다.

| 속성 | 값 |
|---|---|
| Resource URL | `/wave/recipe-configurations` (개요표는 `/wave/recipes-configurations`로 [sic] — 상세 우선) |
| Formats | JSON |
| Available Version | 54.0 |
| HTTP Methods | **GET POST PATCH** |

- **Response Body for GET and PATCH** — Recipe Configuration Collection
- **Request Body for POST** — Recipe Configuration Input
- **Response Body for POST** — Recipe Configuration
- **Request Body for PATCH** — Recipe Configuration Collection Input

---

### Recipe Configuration Resource — `/wave/recipe-configurations/<id>`

Data Prep recipe configuration을 반환하고 수정·삭제한다.

| 속성 | 값 |
|---|---|
| Resource URL | `/wave/recipe-configurations/<id>` |
| Formats | JSON |
| Available Version | 54.0 |
| HTTP Methods | **GET DELETE PATCH** |

- **Response Body for GET and PATCH** — Recipe Configuration
- **Request Body for PATCH** — Recipe Configuration Input

---

## 관련 노트

- [[Wave Namespace]] — Apex에서 SAQL 쿼리를 빌드·실행하는 CRM Analytics Analytics SDK (이 REST API의 Apex 카운터파트)
- [[CRM Analytics 대시보드용 LWC]] — `lightning/analyticsWaveApi` wire adapter(`getRecipes`/`getRecipe`/`deleteRecipe` 등)가 동작하는 LWC 환경
- [[Recipe REST API — Recipe 구성 Input]] — RecipeInput·Recipe Configuration Input 등 request body 표현형 (모든 노드 Input의 부모 Recipe Node Input)
- [[Recipe REST API — Bucket·Cluster 노드 Input]] — Bucket·Bucket V2·Cluster 노드 Input 표현형
- [[Recipe REST API — Aggregate·Append·Join·Compute·Pivot Input]] — Aggregate·Append·Join·Compute·Pivot 노드 Input 표현형
- [[Recipe REST API — Formula·Format·Typecast·Update Input]] — Formula·Format·Typecast·Update 노드 Input 표현형
- [[Recipe REST API — Filter·Flatten·Extract·Schema Input]] — Filter·Flatten·Extract·Schema 노드 Input 표현형
- [[Recipe REST API — Load·Save·Output·ML 노드 Input]] — Load·Save·Output·ML 노드 Input 표현형
- [[Recipe REST API — Response 표현형 (Bucket~Output)]] — Bucket~Output 범위 response body 표현형
- [[Recipe REST API — Response 표현형 (Recipe~Update)]] — Recipe·Recipe Collection·Recipe Notification 등 response body 표현형
- [[Recipe REST API — Enums]] — ConnectRecipeFormatTypeEnum·ConnectAnalyticsLicenseTypeEnum·ConnectWaveSortOrderTypeEnum·ConnectRecipeStatusEnum·ConnectRecipeValidationContextEnum 등 enum 전수
