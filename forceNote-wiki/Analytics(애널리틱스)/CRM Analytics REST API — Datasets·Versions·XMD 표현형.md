---
tags: [Analytics, CRMAnalytics, REST, Wave, Dataset, XMD, ExtendedMetadata]
source: developer.salesforce.com/docs/atlas.en-us.bi_dev_guide_rest.meta/bi_dev_guide_rest/ — CRM Analytics REST API Developer Guide v67.0 Summer '26, 2026-07-18 접속, Tier 2
created: 2026-07-18
aliases: [CRM Analytics dataset REST, Wave dataset, XMD, Extended Metadata, 데이터셋 REST, 확장 메타데이터]
---

# CRM Analytics REST API — Datasets·Versions·XMD 표현형

> CRM Analytics(Wave) 데이터셋·데이터셋 버전·확장 메타데이터(XMD) 리소스의 엔드포인트와 응답 표현형(property·enum)을 전수 정리한다. 프리픽스는 `/services/data/vXX.0/wave/*`이며, 이 노트는 지도 노트 [[CRM Analytics REST API — 개요·인증·asset 엔드포인트 지도]]의 데이터셋 스포크다.

---

## 1. Dataset 리소스 (엔드포인트)

Analytics 데이터셋과 데이터셋 버전을 관리한다.

| Resource | 설명 | HTTP Method | Resource URL |
| --- | --- | --- | --- |
| Datasets List Resource | Analytics 데이터셋 컬렉션 반환·데이터셋 생성 | GET POST | `/wave/datasets` |
| Dataset Resource | 지정 ID/API name의 데이터셋 반환·삭제·수정 | GET, DELETE, PATCH | `/wave/datasets/<datasetIdOrApiName>` |
| Dataset Versions List Resource | 특정 데이터셋의 버전 컬렉션 반환 | GET | `/wave/datasets/<datasetIdOrApiName>/versions` |
| Dataset Version Resource | Analytics 데이터셋 버전 반환·predicate 수정 | GET, PATCH | `/wave/datasets/<datasetIdOrApiName>/versions/<versionId>` |
| Dataset Version File Resource | 데이터셋 파일의 바이너리 콘텐츠 접근 | GET | `/wave/datasets/<datasetIdOrApiName>/versions/<versionId>/files/<fileId>` |

- **Datasets List** — Formats: JSON · Available Version: GET 36.0 / POST 50.0. Response(GET) = Dataset Collection · Request(POST) = Dataset Input · Response(POST) = Dataset. LWC: `getDatasets()`, Aura: `listDatasets()`.
- **Dataset** — Available Version 36.0. Response(GET/PATCH) = Dataset · Request(PATCH) = Dataset Input. LWC: `getDataset()`, `createDataset()`, `deleteDataset()`, `updateDataset()`. Aura: `describeDataset()`, `getDatasetFields()`.
- **Dataset Versions List** — Available Version 36.0. Response(GET) = Dataset Version Collection · Request(POST) = Restore Dataset Version Input · Response(POST) = Restore Dataset Version. LWC: `getDatasetVersions()`, `createDatasetVersion()`.
- **Dataset Version** — Available Version 36.0. Response(GET/PATCH) = Dataset Version · Request(PATCH) = Dataset Version Input. LWC: `getDatasetVersion()`, `updateDatasetVersion()`.
- **Dataset Version File** — Available Version 36.0, GET only. **Integration User만 접근 가능**. GET Response = 데이터셋 파일의 바이너리 콘텐츠.

### Datasets List — GET Request Parameters (전수)

| Parameter | Type | 설명 | 필수 | Ver |
| --- | --- | --- | --- | --- |
| createdAfter | String | 특정 타임스탬프 이후 생성된 콘텐츠만 포함 | Optional | 56.0 |
| createdBefore | String | 특정 타임스탬프 이전 생성된 콘텐츠만 포함 | Optional | 56.0 |
| datasetTypes | ConnectWaveDatasetTypeEnum | 데이터셋 타입. 유효값: `Default` · `Live` · `StagedData` · `Trended` | Optional | 50.0 |
| folderId | ID | 특정 폴더의 콘텐츠만 포함. id는 사용자 개인 폴더 항목의 경우 요청 사용자 ID일 수 있음 | Optional | 36.0 |
| hasCurrentOnly | Boolean | current 버전이 있는 데이터셋만 필터(true)/아님(false). 기본 false | Optional | 52.0 |
| ids | ID[] | 지정 ids의 데이터셋만 포함 | Optional | 53.0 |
| includeCurrentVersion | Boolean | current 버전 메타데이터를 컬렉션에 포함(true)/아님(false). 기본 false | Optional | 52.0 |
| lastQueriedAfter | String | 특정 타임스탬프 이후 마지막 쿼리된 콘텐츠만 포함 | Optional | 56.0 |
| lastQueriedBefore | String | 특정 타임스탬프 이전 마지막 쿼리된 콘텐츠만 포함 | Optional | 56.0 |
| licenseType | ConnectAnalyticsLicenseTypeEnum | Analytics 라이선스 타입으로 필터. 유효값: `Cdp` (Data 360) · `DataPipelineQuery` (Data Pipeline Query) · `EinsteinAnalytics` (CRM Analytics) · `IntelligentApps` (Intelligent Apps) · `Sonic` (Salesforce Data Pipeline) | Optional | 52.0 |
| order | Enum | 결과에 적용되는 정렬. 유효값: `Ascending` · `Descending` | Optional | 42.0 |
| page | String | 반환할 데이터셋 view를 나타내는 생성 토큰 | Optional | 36.0 |
| pageSize | Int | 단일 페이지 반환 항목 수. 최소 1, 최대 200, 기본 25 | Optional | 36.0 |
| q | String | 검색어. 개별 term은 공백으로 구분. 마지막 토큰에 와일드카드 자동 추가 | Optional | 36.0 |
| scope | ConnectWaveScopeTypeEnum | 반환 컬렉션에 적용할 scope 타입. 유효값: `Browse` · `CreatedByMe` · `InsightsApplicationsIsCansEdit` · `Mru` (Most Recently Used) · `SharedWithMe` | Optional | 38.0 |
| sort | ConnectWaveDatasetSortOrderTypeEnum | 반환 데이터셋 컬렉션에 적용할 정렬 순서. 유효값: `ConnectionName` (Live Dataset일 때만 유효) · `CreatedBy` · `CreatedDate` · `LastArchivedBy` · `LastArchivedDate` · `LastModified` · `LastQueried` · `LastRefreshed` · `Mru` (Most Recently Used, last viewed date) · `Name` · `TotalRows` | Optional | 38.0 |
| supportsNewDates | Boolean | new dates를 지원하는 데이터셋만 필터(true)/아님(false). 기본 false | Optional | 52.0 |
| typeOfDataflow | String | 지정 타입의 dataflow를 가진 데이터셋만 필터 | Optional | 61.0 |

`hasCurrentOnly`로 current 버전이 있는 데이터셋만 필터할 수 있고, `filterGroup` 파라미터로 보충 정보를 요청할 수 있다. 예: `/wave/datasets?hasCurrentOnly=true&filterGroup=Supplemental` 은 다음 보충 필드를 출력에 추가한다 — `currentVersionCreatedBy`, `currentVersionCreatedDate`, `currentVersionLastModifiedBy`, `currentVersionLastModifiedDate`.

### Dataset Versions List — GET Request Parameters

| Parameter | Type | 설명 | 필수 | Ver |
| --- | --- | --- | --- | --- |
| createdAfter | String | 특정 타임스탬프 이후 생성된 데이터셋 버전만 포함 | Optional | 62.0 |
| createdBefore | String | 특정 타임스탬프 이전 생성된 데이터셋 버전만 포함 | Optional | 62.0 |
| includeArchived | Boolean | 아카이브된 데이터셋 버전 포함(true)/아님(false) | Optional | 62.0 |

### Dataset PATCH / Dataset Version PATCH 예제 (소스 예제 그대로 — bi_resources_dataset_id / bi_resources_datasets_id_versions_id)

```json
// Dataset PATCH — 기존 데이터셋 description 편집
{
  "description": "This is my dataset",
  "label": "Test Dataset"
}
```

```json
// Dataset Version PATCH — 기존 데이터셋 버전 predicate 편집
{
  "predicate" : "<predicate value>"
}
```

---

## 2. Dataset 표현형 (property 전수)

### Dataset

An Analytics dataset. 추상 `BaseWaveAsset`의 속성을 상속하며, 아래 표의 속성이 함께 나타난다.

| Property | Type | 설명 | Filter Group, Ver | Ver |
| --- | --- | --- | --- | --- |
| clientShardsUrl | String | 데이터셋 shards의 URL | Small, 36.0 | 36.0 |
| currentVersionCreatedBy | WaveUser | current 버전 생성자. `filterGroup`=Supplemental일 때만 반환 | Supplemental, 36.0 | 36.0 |
| currentVersionCreatedDate | Date | current 버전 생성 시각(ISO8601). Supplemental일 때만 반환 | Supplemental, 36.0 | 36.0 |
| currentVersionId | ID | current 데이터셋 버전의 18자 ID | Small, 36.0 | 36.0 |
| currentVersionLastModifiedBy | WaveUser | current 버전을 마지막 갱신한 사용자. Supplemental일 때만 반환 | Supplemental, 36.0 | 36.0 |
| currentVersionLastModifiedDate | Date | current 버전 마지막 수정 시각(ISO8601). Supplemental일 때만 반환 | Supplemental, 36.0 | 36.0 |
| currentVersionPredicate | SecurityPredicate | current 버전의 보안 predicate 정보 | Small, 59.0 | 59.0 |
| currentVersionSharingInheritance | SharingInheritance | current 버전의 공유 상속 정보 | Small, 59.0 | 59.0 |
| currentVersionSupportsNewDates | Boolean | current 버전이 new date 포맷 지원(true)/아님(false) | Supplemental, 52.0 | 52.0 |
| currentVersionTotalRows | Integer | 데이터셋 총 행 수 | Supplemental, 42.0 | 42.0-52.0 |
| currentVersionTotalRowCount | Integer | 데이터셋 총 행 수 | Small, 53.0 | 53.0 |
| currentVersionUrl | String | current 데이터셋 버전 URL | Small, 36.0 | 36.0 |
| dataRefreshDate | Date | 이 데이터셋이 마지막 갱신된 시각 | Small, 40.0 | 40.0 |
| datasetType | ConnectWaveDatasetTypeEnum | 데이터셋 타입. 유효값: `Default` · `Live` · `StagedData` · `Trended` | Small, 41.0 | 41.0 |
| folder | AssetReference | 이 데이터셋이 저장된 폴더 참조 | Small, 36.0 | 36.0 |
| lastMetadataChangedDate | Date | 메타데이터(folder·label·current·sharing·security predicate) 마지막 변경 시각 | Small, 51.0 | 51.0 |
| lastQueriedDate | Date | 이 데이터셋이 마지막 쿼리된 시각 | Small, 39.0 | 39.0 |
| licenseAttributes | LicenseAttributes | 이 데이터셋과 연관된 Analytics 라이선스 속성 | Small, 52.0 | 52.0 |
| liveConnection | LiveConnection | 데이터셋의 live connection 세부 | Small, 50.0 | 50.0 |
| userXmd | Xmd | 연관된 user XMD | Medium, 36.0 | 36.0 |
| versionsUrl | String | 데이터셋 버전 URL | Small, 36.0 | 36.0 |
| visibility | ConnectWaveAssetVisibilityType | 데이터셋이 view 접근 사용자로부터 숨겨지는지. 유효값: `All` (Show all assets) · `Limited` (Hide assets from viewers with view access) | Small, 51.0 | 51.0 |

### Dataset Collection

| Property | Type | 설명 | Filter Group, Ver | Ver |
| --- | --- | --- | --- | --- |
| datasets | Dataset[] | 현재 사용자에게 가용한 데이터셋 목록 | Small, 36.0 | 36.0 |
| nextPageUrl | String | 컬렉션의 다음 페이지를 가져오는 URL | Small, 36.0 | 36.0 |
| totalSize | Integer | 모든 페이지 포함 컬렉션 요소 총 개수 | Medium, 36.0 | 36.0 |
| url | String | 컬렉션을 가져오는 URL | Small, 36.0 | 36.0 |

### Dataset Version

A specific version of an Analytics dataset. 추상 `BaseWaveAsset` 속성을 상속.

| Property | Type | 설명 | Filter Group, Ver | Ver |
| --- | --- | --- | --- | --- |
| dataset | AssetReference | 데이터셋 참조 | Small, 36.0 | 36.0 |
| files | WaveFileMetadata[] | 데이터셋 버전을 구성하는 데이터 파일 정보 목록 | Medium, 36.0 | 36.0 |
| filesUrl | String | 이 데이터셋 버전 files 리소스의 URL | Small, 36.0 | 36.0 |
| predicate | String | 행 수준 보안 predicate. 입력 요청에 predicate가 설정된 경우만 반환 | Small, 36.0 | 36.0 |
| predicateVersion | Double | 행 수준 보안 predicate 버전. 입력 요청에 predicate가 설정된 경우만 반환 | Small, 36.0 | 36.0 |
| securityCoverageUrl | String | 데이터셋 공유 상속 coverage 정보 리소스 | Small, 41.0 | 41.0 |
| sharingSource | AssetReference | 데이터셋 버전이 공유 규칙을 상속받는 엔티티 | Small, 40.0 | 40.0 |
| source | AssetReference | 데이터셋 버전의 부모 dataflow 또는 파일 | Small, 44.0 | 44.0 |
| totalRows | Integer | 데이터셋 버전 총 행 수 | Small, 40.0 | 40.0-52.0 |
| totalRowCount | Integer | 데이터셋 버전 총 행 수 | Small, 53.0 | 53.0 |
| xmdMain | Xmd | 이 데이터셋 버전의 Xmd | Medium, 36.0 | 36.0 |
| xmdsUrl | String | 이 데이터셋 버전 Xmd 컬렉션 리소스의 URL | Small, 36.0 | 36.0 |

### Dataset Version Collection

| Property | Type | 설명 | Filter Group, Ver | Ver |
| --- | --- | --- | --- | --- |
| url | String | 컬렉션을 가져오는 URL | Small, 36.0 | 36.0 |
| versions | DatasetVersion[] | 특정 데이터셋의 데이터셋 버전 컬렉션 | Small, 36.0 | 36.0 |

### Dataset Version Reference

coverage 정보가 적용되는 데이터셋 버전.

| Property | Type | 설명 | Filter Group, Ver | Ver |
| --- | --- | --- | --- | --- |
| dataset | AssetReference | 데이터셋 참조 | Small, 41.0 | 41.0 |
| id | String | 데이터셋 버전의 18자 ID | Small, 41.0 | 41.0 |
| url | String | asset URL | Small, 41.0 | 41.0 |

### Dataset Coverage

특정 데이터셋 버전의 보안 coverage.

| Property | Type | 설명 | Filter Group, Ver | Ver |
| --- | --- | --- | --- | --- |
| datasetVersion | DatasetVersionReference | coverage 정보가 적용되는 데이터셋 버전 | Small, 41.0 | 41.0 |
| sources | DatasetSource[] | 데이터셋 버전의 source 객체 | Small, 41.0 | 41.0 |
| url | String | 이 정보를 가져오는 URL | Small, 41.0 | 41.0 |

### Dataset Source

데이터셋 생성에 사용된 source 객체.

| Property | Type | 설명 | Filter Group, Ver | Ver |
| --- | --- | --- | --- | --- |
| object | ObjectCoverage | 데이터셋의 source 객체 | Small, 41.0 | 41.0 |
| securityFields | String[] | 객체의 보안 관련 데이터셋 필드 | Small, 41.0 | 41.0 |

### 템플릿 변수용 Dataset 타입 (BaseObjectType 상속)

다음 표현형은 Analytics 템플릿 변수의 dataset 타입이며 모두 `BaseObjectType`에서 속성을 상속한다(고유 property 없음).

- **Dataset Type** — Analytics 템플릿 변수의 dataset 타입
- **Dataset Dimension Type** — dataset 타입 내 dimension
- **Dataset Measure Type** — dataset 타입 내 measure
- **Dataset Date Type** — dataset 타입 내 date
- **Dataset Any Field Type** — dataset 타입의 generic field 타입

---

## 3. Xmd 리소스 (엔드포인트)

Analytics 데이터셋과 asset의 Xmd를 관리한다.

| Resource | 설명 | HTTP Method | Resource URL |
| --- | --- | --- | --- |
| Xmd List Resource | 데이터셋 버전의 Xmd 컬렉션 반환(main·system·user 타입) | GET | `/wave/datasets/<datasetID>/versions/<versionId>/xmds` |
| Xmd Resource | 데이터셋 버전의 확장 메타데이터(XMD) 반환·user XMD 파일 수정 | GET PUT | `/wave/datasets/<datasetID>/versions/<versionId>/xmds/<xmdType>` |
| Asset Xmd Resource | asset(예: dashboard)과 연관된 확장 메타데이터(Xmd) 반환 | GET | `/wave/assets/<assetID>/xmds/asset` |

- **Xmd List** — Available Version 36.0, GET only. Response = Xmd Metadata Collection.
- **Xmd Resource** — Available Version 36.0. URL은 `.../xmds/main` · `.../xmds/system` · `.../xmds/user`. HTTP Methods: **GET, PUT (Xmd User type만)**. GET Response = Xmd · PUT Request = Xmd Input · PUT Response = Xmd. **PUT은 System·Main Xmd 타입 갱신에 사용 불가.** LWC: `getXmd()`, `updateXmd()`.
- **Asset Xmd** — Available Version 42.0, GET only. GET Response = Xmd.

```json
// Xmd List — Example Response Body (소스 예제 그대로 — bi_resources_xmds)
{
  "url" : "/services/data/v36.0/wave/datasets/0Fb4000000000FtCAI/versions/0Fc4000000001VOCAY/xmds",
  "xmds" : [ {
    "type" : "main",
    "url" : "/services/data/v36.0/wave/datasets/0Fb4000000000FtCAI/versions/0Fc4000000001VOCAY/xmds/main"
  }, {
    "type" : "user",
    "url" : "/services/data/v36.0/wave/datasets/0Fb4000000000FtCAI/versions/0Fc4000000001VOCAY/xmds/user"
  }, {
    "type" : "system",
    "url" : "/services/data/v36.0/wave/datasets/0Fb4000000000FtCAI/versions/0Fc4000000001VOCAY/xmds/system"
  } ]
}
```

```json
// Xmd Resource PUT Request — User Xmd measures 갱신 (소스 예제 그대로 — bi_resources_xmd_main)
{
  "measures" : [ {
    "conditionalFormatting" : { },
    "field" : "LastModifiedDate_day_epoch",
    "format" : {
      "delimiters" : { }
    },
    "label" : "LastModDate_day_epoch",
    "showInExplorer" : true
  }, {
    "conditionalFormatting" : { },
    "field" : "LastModifiedDate_sec_epoch",
    "format" : {
      "delimiters" : { }
    },
    "label" : "LastModDate_sec_epoch",
    "showInExplorer" : true
  } ]
}
```

---

## 4. XMD 표현형 (property·enum 전수)

### Xmd

An Analytics 데이터셋 버전의 확장 메타데이터(Xmd).

| Property | Type | 설명 | Filter Group, Ver | Ver |
| --- | --- | --- | --- | --- |
| createdBy | WaveUser | Xmd를 생성한 사용자 | Small, 36.0 | 36.0 |
| createdDate | Date | Xmd 생성 시각(ISO8601) | Small, 36.0 | 36.0 |
| dataset | XmdDataset | 이 Xmd가 표현하는 데이터셋의 locale-specific 정보 | Small, 36.0 | 36.0 |
| dates | XmdDate[] | 포맷 정보가 있는 date 목록 | Small, 36.0 | 36.0 |
| derivedDimensions | XmdDimension[] | 포맷 정보가 있는 derived dimension 목록 | Small, 36.0 | 36.0 |
| derivedMeasures | XmdMeasure[] | 포맷 정보가 있는 derived measure 목록 | Small, 36.0 | 36.0 |
| dimensions | XmdDimension[] | 포맷 정보가 있는 dimension 목록 | Small, 36.0 | 36.0 |
| errorMessage | String | current 버전의 user Xmd를 신규 생성 버전으로 복사할 때 오류 발생 시 메시지 | Small, 37.0 | 37.0 |
| language | ConnectWaveLanguageEnum | 이 Xmd가 지역화된 언어 (아래 enum 전수 참조) | Small, 36.0 | 36.0 |
| lastModifiedBy | WaveUser | Xmd를 마지막 갱신한 사용자 | Small, 36.0 | 36.0 |
| lastModifiedDate | Date | Xmd 마지막 수정 시각(ISO8601) | Small, 36.0 | 36.0 |
| measures | XmdMeasure[] | 포맷 정보가 있는 measure 목록 | Small, 36.0 | 36.0 |
| organizations | XmdOrganization[] | 멀티-조직 지원을 위한 organization 목록 | Small, 36.0 | 36.0 |
| showDetailsDefaultFields | String[] | dimension·measure의 정렬된 목록. UI에서 dimension·measure를 보여줄 기본 순서를 정의 | Small, 36.0 | 36.0 |
| type | ConnectWaveXmdTypeEnum | Xmd 타입. 값: `asset` · `main` · `system` · `user` | Small, 36.0 | 36.0 |
| url | String | 이 Xmd가 저장된 위치 | Small, 36.0 | 36.0 |

**`language` (ConnectWaveLanguageEnum) 전수 값:** `bg` Bulgarian · `zh_CN` Chinese Simplified · `zh_TW` Chinese Traditional · `hr` Croatian · `cs` Czech · `da` Danish · `nl_NL` Dutch · `en` English · `en_GB` English (United Kingdom) · `fi` Finnish · `fr` French · `de` German · `el` Greek · `hu` Hungarian · `in` Indonesian · `it` Italian · `ja` Japanese · `ko` Korean · `no` Norwegian · `pl` Polish · `pt_PT` Portuguese (Portugal) · `pt_BR` Portuguese (Brazil) · `ro` Romanian · `ru` Russian · `sk` Slovak · `sl` Slovenian · `es` Spanish · `es_MX` Spanish (Mexico) · `sv` Swedish · `th` Thai · `tr` Turkish · `uk` Ukrainian · `vi` Vietnamese

### Xmd Metadata

An Analytics Xmd의 메타데이터.

| Property | Type | 설명 | Filter Group, Ver | Ver |
| --- | --- | --- | --- | --- |
| type | ConnectWaveXmdTypeEnum | Xmd 타입. 값: `asset` · `main` · `system` · `user` | Small, 36.0 | 36.0 |
| url | String | 이 Xmd의 위치 | Small, 36.0 | 36.0 |

### Xmd Metadata Collection

A collection of Analytics Xmd metadata.

| Property | Type | 설명 | Filter Group, Ver | Ver |
| --- | --- | --- | --- | --- |
| url | String | Xmd 컬렉션 위치 | Small, 36.0 | 36.0 |
| xmds | XmdMetadata[] | Xmd 리소스 목록 | Small, 36.0 | 36.0 |

### Xmd Dimension

An Analytics 데이터셋 내 dimension의 확장 메타데이터(Xmd).

| Property | Type | 설명 | Filter Group, Ver | Ver |
| --- | --- | --- | --- | --- |
| conditionalFormatting | ConditionalFormattingProperty | dimension의 조건부 서식 | Small, 42.0 | 42.0 |
| customActions | XmdDimensionCustomAction | 이 dimension에 연결된 custom action | Small, 36.0 | 36.0 |
| customActionsEnabled | Boolean | dimension에 custom action 활성화(true)/아님(false) | Small, 36.0 | 36.0 |
| defaultAction | String | dimension의 기본 action | Small, 50.0 | 50 |
| field | String | dimension의 필드명(쿼리에서 사용) | Small, 36.0 | 36.0 |
| label | String | 데이터셋 필드의 표시 이름. 최대 40자 | Small, 36.0 | 36.0 |
| linkTemplate | String | 사용자가 actions 메뉴 링크를 클릭할 때 열 URL. 기본 URL 링크 `/{{row.recordIdField}}`를 오버라이드. 기본은 recordIdField Xmd 파라미터에 지정된 record ID의 Salesforce 레코드를 찾음. 255자 이하 필수. 멀티-org 환경 레코드를 열려면 `{{instanceUrl}}` 입력(Xmd organizations 섹션에 지정된 org URL로 채워짐). 예: `/{{row.dimensionNameId}}` | Small, 36.0 | 36.0 |
| linkTemplateEnabled | Boolean | Salesforce 레코드/URL 링크 표시(true)/아님(false). false 또는 미설정 시 Open Record 링크 미표시 | Small, 36.0 | 36.0 |
| linkTooltip | String | Analytics lens·dashboard에서 링크에 hover할 때 보이는 tooltip | Small, 36.0 | 36.0 |
| members | XmdDimensionMember[] | 데이터셋 필드의 특정 값에 대한 커스터마이징. 예: "Country" 필드의 "USA" 레이블을 "United States"로 변경, 차트 색상을 blue로 변경. Note: 레이블 변경 시 새 레이블은 UI에만 나타나며 쿼리 필터 등에서 사용 불가 | Small, 36.0 | 36.0 |
| recordDisplayFields | String[] | dimension·measure의 정렬 목록. dashboard viewer가 여러 레코드 매칭 시 Salesforce 레코드 식별을 돕는 필드. 각 필드의 API name 지정 | Small, 36.0 | 36.0 |
| recordIdField | String | action을 수행할 Salesforce 객체의 record ID를 담은 데이터셋 필드 | Small, 36.0 | 36.0 |
| recordOrganizationIdField | String | 이 dimension의 record organization ID | Small, 36.0 | 36.0 |
| salesforceActions | XmdDimensionSalesforceAction[] | action 메뉴에 나타나는 action. 해당 Salesforce 객체 page layout에 정의된 action만 추가 가능. 비우면 모든 action 표시 | Small, 36.0 | 36.0 |
| salesforceActionsEnabled | Boolean | Salesforce actions 메뉴 활성화(true)/아님(false). false 또는 미설정 시 action 미표시 | Small, 36.0 | 36.0 |
| showInExplorer | Boolean | dashboard designer·explorer에서 필드 선택 가능(true)/아님(false). false여도 SAQL 쿼리·JSON 수동 추가·REST API 접근은 가능 | Small, 36.0 | 36.0 |

### Xmd Measure

An Analytics 데이터셋 내 measure의 확장 메타데이터(Xmd).

| Property | Type | 설명 | Filter Group, Ver | Ver |
| --- | --- | --- | --- | --- |
| conditionalFormatting | ConditionalFormattingProperty | measure의 조건부 서식 | Small, 42.0 | 42.0 |
| currencySettings | XmdCurrencySettings | currency 필드에 지원되는 통화의 currency 설정 | Small, 57.0 | 57.0 |
| field | String | 데이터셋 필드의 식별자(API name) | Small, 36.0 | 36.0 |
| format | XmdMeasureFormat | measure의 포맷 세부 | Small, 36.0 | 36.0 |
| label | String | 데이터셋 필드의 표시 이름. 최대 40자. 예: "Sales Amount" | Small, 36.0 | 36.0 |
| showInExplorer | Boolean | dashboard designer·explorer에서 필드 선택 가능(true)/아님(false). false여도 SAQL·JSON·REST API 접근 가능 | Small, 36.0 | 36.0 |

### Xmd Date

An Analytics date의 확장 메타데이터(Xmd).

| Property | Type | 설명 | Filter Group, Ver | Ver |
| --- | --- | --- | --- | --- |
| alias | String | Date 컬럼의 alias | Small, 36.0 | 36.0 |
| compact | Boolean | date를 compact로 표시할지 여부 | Small, 36.0 | 36.0 |
| description | String | Date 컬럼의 description | Small, 36.0 | 36.0 |
| fields | XmdDateField | date 필드의 포맷 정보 | Small, 36.0 | 36.0 |
| firstDayOfWeek | Integer | 주의 첫 날 | Small, 36.0 | 36.0 |
| fiscalMonthOffset | Integer | 회계연도의 offset 월 수(달력연도 대비) | Small, 36.0 | 36.0 |
| format | String | date 필드의 포맷 | Small, 53.0 | 53.0 |
| fullyQualifiedName | String | date의 fully qualified name | Small, 39.0 | 39.0 |
| isConvertedDateTime | Boolean | DateTime 타입이 timezone 자동 변환 결과인지 여부 | Small, 44.0 | 44.0 |
| isYearEndFiscalYear | Boolean | 연말이 회계연도인지 여부 | Small, 36.0 | 36.0 |
| label | String | Date 컬럼의 label | Small, 36.0 | 36.0 |
| showInExplorer | Boolean | dashboard designer·explorer에서 필드 선택 가능(true)/아님(false). false여도 SAQL·JSON·REST API 접근 가능 | Small, 36.0 | 36.0 |
| type | ConnectWaveDateType | Date 타입. 유효값: `Date` · `DateOnly` · `DateTime` | Small, 43.0 | 43.0 |

### Xmd Date Field

date 필드 포맷팅의 확장 메타데이터(Xmd).

| Property | Type | 설명 | Filter Group, Ver | Ver |
| --- | --- | --- | --- | --- |
| day | String | 일(day of month) | Small, 36.0 | 36.0 |
| epochDay | String | 1970-01-01(midnight UTC) 이후 경과 일수 | Small, 36.0 | 36.0 |
| epochSecond | String | 1970-01-01(midnight UTC) 이후 경과 초. 데이터셋의 `_sec_epoch`에 대응 | Small, 36.0 | 36.0 |
| fiscalMonth | String | 회계연도 월 번호. `_Month_Fiscal`에 대응 | Small, 36.0 | 36.0 |
| fiscalQuarter | String | 회계연도 분기 번호. `_Quarter_Fiscal`에 대응 | Small, 36.0 | 36.0 |
| fiscalWeek | String | 회계연도 주 번호. `_Week_Fiscal`에 대응 | Small, 36.0 | 36.0 |
| fiscalYear | String | 회계연도. `_Year_Fiscal`에 대응 | Small, 36.0 | 36.0 |
| fullField | String | full-field 필드 | Small, 36.0 | 36.0 |
| hour | String | 시(hour). 시가 없으면 '0'. `_Hour`에 대응 | Small, 36.0 | 36.0 |
| minute | String | 분(minute). 분이 없으면 '0'. `_Minute`에 대응 | Small, 36.0 | 36.0 |
| month | String | 달력연도 월 번호. `_Month`에 대응 | Small, 36.0 | 36.0 |
| quarter | String | 달력연도 분기 번호. `_Quarter`에 대응 | Small, 36.0 | 36.0 |
| second | String | 초(second). 초가 없으면 '0'. `_Second`에 대응 | Small, 36.0 | 36.0 |
| week | String | 달력연도 주 번호. `_Week`에 대응 | Small, 36.0 | 36.0 |
| year | String | 달력연도. `_Year`에 대응 | Small, 36.0 | 36.0 |

### Xmd Dimension Member

An Analytics 데이터셋 dimension에 연결된 member의 확장 메타데이터(Xmd).

| Property | Type | 설명 | Filter Group, Ver | Ver |
| --- | --- | --- | --- | --- |
| color | String | member의 색상. 예: "Blue" | Small, 36.0 | 36.0 |
| label | String | member의 레이블. 예: "United States" | Small, 36.0 | 36.0 |
| member | String | member 값. 예: "USA" | Small, 36.0 | 36.0 |

### Xmd Measure Format

An Analytics 데이터셋 measure 포맷의 확장 메타데이터(Xmd).

| Property | Type | 설명 | Filter Group, Ver | Ver |
| --- | --- | --- | --- | --- |
| customFormat | String | 표시 커스터마이징 시 prefix·suffix·grouping separator·decimal separator·leading/trailing zero 추가 가능. 자릿수 설정 가능. prefix·suffix에 minus·통화기호 등 포함 가능. 포맷 심볼: `0` 한 자릿수(leading/trailing 0 추가용, 예 `#,###.00`을 56375에 적용 → `56,375.00`) · `#` 0 또는 1자릿수(예 `#,###.##`을 56375.56 → `56,375.56`) · `.`(period) 소수점 구분자(Analytics는 `.`만 지원) · `,`(comma) 그룹 구분자(Analytics는 `,`만 지원). 예: `["-$#,###.00$",1]` | Small, 36.0 | 36.0 |
| delimiters | NumericSeparators | 포맷의 천단위·소수점 자리 구분자 | Small, 48.0 | 48.0 |
| unitMultiplier | Double | unit의 multiplier. 필드 값을 동일 factor로 변경(예: 100 곱해 소수→퍼센트). 양수 필수 | Small, 36.0 | 36.0 |

### Xmd Dimension Custom Action

An Analytics 데이터셋 dimension의 custom action 확장 메타데이터(Xmd).

| Property | Type | 설명 | Filter Group, Ver | Ver |
| --- | --- | --- | --- | --- |
| icon | String | custom action의 icon | Small, 36.0 | 36.0 |
| method | String | custom action의 method | Small, 36.0 | 36.0 |
| target | String | custom action의 target | Small, 36.0 | 36.0 |
| tooltip | String | custom action의 tooltip | Small, 36.0 | 36.0 |
| url | String | custom action의 URL | Small, 36.0 | 36.0 |

### Xmd Dimension Salesforce Action

An Analytics 데이터셋 dimension의 Salesforce Action 확장 메타데이터(Xmd).

| Property | Type | 설명 | Filter Group, Ver | Ver |
| --- | --- | --- | --- | --- |
| enabled | Boolean | 특정 dimension에 action 활성화 여부 | Small, 36.0 | 36.0 |
| name | String | action의 이름 | Small, 36.0 | 36.0 |

### Xmd Dataset

데이터셋의 locale-specific 정보(소스 설명: currency 필드의 currency 설정 확장 메타데이터).

| Property | Type | 설명 | Filter Group, Ver | Ver |
| --- | --- | --- | --- | --- |
| basecurrency | String | 데이터셋의 base currency | Small, 57.0 | 57.0 |
| connector | String | 데이터셋의 connector source | Small, 36.0 | 36.0 |
| description | String | 데이터셋의 description | Small, 36.0 | 36.0 |
| fullyQualifiedName | String | 데이터셋 버전의 fully qualified name | Small, 36.0 | 36.0 |
| origin | String | 데이터셋 버전의 origin | Small, 36.0 | 36.0 |
| supportedCurrencies | String[] | 데이터셋에 지원되는 통화 목록 | Small, 57.0 | 57.0 |

### Xmd Currency Settings

currency 필드의 currency 설정 확장 메타데이터(Xmd).

| Property | Type | 설명 | Filter Group, Ver | Ver |
| --- | --- | --- | --- | --- |
| conversionRateDateField | String | 통화 변환 시 사용된 conversion rate date 필드 | Small, 57.0 | 57.0 |
| currencies | Map<String, XmdMeasure> | 지원 통화 map | Small, 57.0 | 57.0 |

### Xmd Organization

An Analytics 데이터셋의 organization 확장 메타데이터(Xmd).

| Property | Type | 설명 | Filter Group, Ver | Ver |
| --- | --- | --- | --- | --- |
| id | String | org의 ID | Small, 36.0 | 36.0 |
| instanceUrl | String | org의 My Domain 로그인 URL. 형식 `https://MyDomainName.my.salesforce.com` | Small, 36.0 | 36.0 |
| label | String | Salesforce org의 표시 이름. 최대 40자 | Small, 36.0 | 36.0 |

---

## 관련 노트

- [[CRM Analytics REST API — 개요·인증·asset 엔드포인트 지도]] — 이 스포크의 지도 노트(asset 리소스 맵·인증·경계)
- [[CRM Analytics REST API — Query 실행 (SAQL·SQL)]] — `/wave/query`로 데이터셋을 SAQL/SQL 쿼리
- [[Wave Namespace]] — Apex `Wave` 네임스페이스(SAQL 빌더). REST 직접 호출과 대비되는 Apex 경로
- [[Analytics 개요 — 표준 리포팅 vs CRM Analytics·API 선택 가이드]]
