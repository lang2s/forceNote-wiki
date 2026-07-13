---
tags: [omnistudio, data-mapper, dataraptor, omnidatatransformation, extract, load, transform, integration]
source: help.salesforce.com — OmniStudio Data Mappers (xcloud.os_dataraptor_or_integration_procedure_8166·os_omnistudio_dataraptors_45587·os_standard_data_mapper_workflow·os_build_data_mapper·os_inputs_outputs_for_data_mappers·os_dataraptor_output_data_types_47661·os_configure_a_dataraptor_turbo_extract_45667·os_use_formulas_in_dataraptors_47540·os_invoke_data_mappers·os_dataraptor_calls_from_apex_47779·os_dataraptor_rest_api_47730·os_omnistudio_data_mapper_and_integration_procedure_functions·os_dataraptor_best_practices_47412, 접속일 2026-07-13) [Tier 2]
created: 2026-07-13
aliases: [Data Mapper, DataRaptor, 데이터 매퍼, OmniDataTransformation, Extract, Turbo Extract, Load, Transform, DRGlobal, executeDataMapper, Data Mapper REST API]
---

# Data Mapper (DataRaptor)

> Salesforce 데이터와 OmniStudio 컴포넌트 간에 데이터를 선언적으로 읽기/쓰기/변환하는 서버측 프로세스. **DataRaptor**는 구 이름이고 **Data Mapper**가 현 이름이며, 메타데이터 객체는 여전히 **OmniDataTransformation**이다.

---

## Data Mapper란

Data Mapper(구 DataRaptor)는 **Salesforce와 다른 OmniStudio 컴포넌트 사이에서 데이터를 선언적으로 검색·기록·수정**하는 재사용 가능한 서버측 프로세스다. Apex 같은 커스텀 코드로도 데이터를 처리할 수 있지만, Data Mapper는 만들기 빠르고 업데이트가 쉽고 관리가 단순하며, 재사용이 가능해 개발에서 프로덕션으로 솔루션을 빠르게 이동시킨다.

- Data Mapper는 **external object, custom metadata, Salesforce object**에 접근할 수 있으며, 이를 위한 특별한 구문이나 설정이 필요 없다.
- 워크플로에서 Data Mapper는 일반적으로 **OmniScript·Integration Procedure·FlexCard·Apex 클래스에 Salesforce 데이터를 공급**하고, 관련 업데이트를 Salesforce에 기록한다.

예시 워크플로 (계정 업데이트 OmniScript):
- OmniScript가 **Data Mapper Extract**를 호출해 Account 등 Salesforce 데이터를 읽는다.
- 고객이 OmniScript에서 데이터를 수정·추가한다.
- **Data Mapper Transform**이 입력 데이터를 점검하고 필요한 형식으로 변경한다.
- OmniScript가 **Data Mapper Load**를 호출해 신규·수정 데이터를 Salesforce에 기록한다.

---

## 4가지 타입 (핵심 전수)

검색·기록·변환 각 작업마다 별도 타입이 있다. Extract·Turbo Extract·Load는 Custom Input/Output을 처리할 수 있다.

| 타입 | 방향 | 데이터 소스 | SOQL | Formula/Mapping | 용도 |
|---|---|---|---|---|---|
| **Extract** | 읽기 | 1개 이상의 Salesforce object | 사용 | 사용 가능 | JSON/XML/custom으로 데이터 반환, 필터·필드 선택·formula·기본값·번역 |
| **Turbo Extract** | 읽기 | 단일 Salesforce object + 관련 object 필드 | 사용(단순) | **불가** | 단순 추출, 런타임 성능·설정 우수 |
| **Load** | 쓰기 | JSON/XML/custom 입력 → Salesforce object | 사용 | 사용 가능(formula·attribute) | Salesforce 데이터 생성·업데이트 |
| **Transform** | 인메모리 변환 | 이전 스텝의 데이터(읽기/쓰기 없음) | **불가** | 사용 가능 | 구조 재편·필드 rename·값 치환·PDF/DocuSign 변환 |

- **Data Mapper Extract** — 하나 이상의 Salesforce object에서 데이터를 읽어 JSON output·custom data·XML로 필드 매핑과 함께 반환한다. 데이터를 필터링하고 반환 필드를 선택하며, formula·기본값·번역을 적용할 수 있다. OmniScript·Integration Procedure·FlexCard에 필요한 데이터를 제공한다.
- **Data Mapper Turbo Extract** — 단일 Salesforce object 타입에서 데이터를 읽으며 관련 object의 필드를 포함한다. 쿼리나 복잡한 output 매핑이 필요 없는 단순 추출에 유용하고 런타임이 더 빠르다. **formula·custom JSON·기본값·transformation을 사용할 수 없다.**
- **Data Mapper Load** — JSON·XML·custom 입력을 받아 Salesforce object에 데이터를 생성·업데이트한다. formula와 attribute를 사용할 수 있다.
- **Data Mapper Transform** — Salesforce object를 읽거나 쓰지 않고 중간 데이터를 변환한다. **메모리에서 동작하므로 SOQL 쿼리 등으로 Salesforce object를 읽지 않는다.**
  - 입력 데이터 ↔ 출력 데이터 변환 (JSON 또는 XML)
  - 입력 데이터 재구조화 및 필드 rename
  - 필드 값 치환 (값 치환은 모든 Data Mapper가 가능)
  - PDF·DocuSign·document template 형식으로 변환 — DocuSign 템플릿 채우기, PDF 필드 채우기에 필수

> **설정 가용성:** Extract는 모든 설정(query·formula·mapping) 사용. Transform·Load는 query 없음(이전 스텝의 데이터 사용). Turbo Extract는 단순 타입이라 formula·mapping 없음.

---

## Turbo Extract 상세

App Launcher → **Data Mappers** → Turbo Extract 선택 → extraction object 검색·선택 → extraction object path 입력 → 필터 추가.

**필터:**
- 가장 기본 필터는 `Id = Id` — object의 ID를 입력 파라미터 ID로 설정한다.
- **INCLUDES / EXCLUDES** 연산자는 multiselect picklist 필드에만 적용된다.
- **IN** (Turbo Extract 추가 연산자) — 배열의 항목과 값을 매칭. 예: 필터가 `LastName IN Names`이고 JSON 입력이 `{"Names": ["Miller", "Torres"]}`이면 LastName이 Miller 또는 Torres인 레코드를 모두 반환한다.
- null 값 필터링에는 `$Vlocity.NULL` 변수를 사용한다.

> Turbo Extract는 **필드 값에 작은따옴표가 포함된 다중 입력 필드를 지원하지 않는다** (예: FirstName=`T'an`, LastName=`C'os`). 이런 경우 Data Mapper Extract를 사용한다.

**추가 필터 옵션 (down arrow):**

| 옵션 | 설명 |
|---|---|
| AND | 필터를 추가하고 두 필터가 모두 true여야 함을 지정 |
| OR | 필터를 추가하고 두 필터 중 하나만 true면 됨을 지정 |
| LIMIT | 반환 최대 레코드 수. 유효값 1~50000, 기본값 50000 |
| OFFSET | 페이징 로직. 입력 payload의 노드명(예: offsetValue)을 지정. LIMIT와 함께 사용해 다중 페이지 시작 레코드 지정. offset은 정수. LIMIT=5면 페이지별 offset은 0, 5, 10…. **Salesforce는 OFFSET 사용 쿼리에 2000-record 한도를 부과한다. 허용 OFFSET 값은 0~2000.** |
| ORDER BY | 지정 필드로 정렬. 다중 정렬은 우선순위 순 콤마 구분 리스트(예: `LastName,FirstName`). 선택적으로 ASC/DESC, NULLS FIRST/NULLS LAST 지정 가능. 예: `NumberOfEmployees ASC NULLS FIRST` |
| DELETE | 필터 제거 |

**관계 순회 (5-level):**
- 기본 object의 부모에서 데이터를 검색하려면 관련 object를 선택한다(예: `Contact.Account`). Data Mapper는 **child-to-parent 관계 쿼리만** 지원한다.
- 관련 object를 선택하면 그 필드가 Available Fields에 나타난다. 이 필드를 클릭하면 second-level 관계가 드러나며, **최대 5개 관계 레벨까지 순회**할 수 있다. 한 레벨 뒤로 가려면 리스트를 클릭해 이전 레벨을 선택한다.
- Field Mapping에서 필드를 검색한다(managed package designer에서는 미제공). Available → Selected Fields로 이동해 추출할 필드를 선택하며, **Id 필드는 항상 Selected Fields에 포함**된다.

**Options (캐시):**
- 캐시 값 유지 시간(분) 지정 — 최소 5분.
- **Salesforce Platform Cache Type** picklist:
  - **None** — 이 Data Mapper의 데이터 캐시 비활성화
  - **Session Cache** — 사용자·로그인 세션 관련 데이터
  - **Org Cache** — 그 외 모든 데이터
- **Check field level security before execution** — 실행 전 필드 접근 권한 확인. 선택 시 **Org Cache는 비활성화되지만 Session Cache는 비활성화되지 않는다.**
- **Include null values in the response** — 응답에 null 값 포함.
- 캐시 효과를 테스트하려면 **Ignore Cache**를 해제한다.

---

## Inputs / Outputs

입출력 설정은 매우 유연하며 주 형식은 **JSON과 XML**이다.

- **JSON (native)** — OmniStudio 전반에서 가장 흔한 기본 형식. Extract·Load·Transform 모두 IP·OmniScript·외부 REST API에서 전달된 JSON payload를 수용한다. Extract·Transform의 기본·기본 출력 형식이기도 하다.
- **XML (legacy)** — XML 기반 메시징에 의존하는 레거시/엔터프라이즈 시스템 통합용. Load·Transform이 XML payload를 수용(IP callout 응답 처리에 유용). Extract·Transform이 XML 출력을 쓰면 외부 XML 의존 시스템에 데이터 전송 가능. XML 형식은 순서 없는 key-value의 JSON-like 구조다.
- **Custom (Apex) I/O** — JSON/XML로 처리 불가한 비표준 구조용. Load·Transform은 custom **input**, Extract·Transform은 custom **output**을 Apex 커스텀 클래스로 구현한다. 예: CSV 입력을 받아 JSON으로 출력하는 Transform.
- **Document generation** — Transform은 구조화된 JSON을 PDF 생성 형식으로 변환하거나, DocuSign envelope·document template 필드를 채우는 구조로 변환한다.

### Output Data Types (전수)

Output JSON의 데이터에 할당할 수 있는 데이터 타입:

| 타입 | 설명 |
|---|---|
| **Boolean** | — |
| **Currency** | Salesforce org의 currency code를 사용해 Currency로 변환 |
| **CurrencyRounded** | Currency로 변환 후 반올림하고 소수 제거 |
| **Double** | — |
| **Integer** | — |
| **JSON** | JSON으로 직렬화. transform output type이 JSON이면 생략(JSON 안에 JSON 임베드가 필요한 드문 경우 제외) |
| **List\<Double>** | — |
| **List\<Integer>** | — |
| **List\<Map>** | `Map<String,Object>`를 `List<Map<String, Object>>`로 변환 |
| **List\<String>** | — |
| **Number** | — |
| **Number(3)** | 괄호 안 정밀도만큼 소수를 갖는 숫자로 변환. 예: `Number(3)`은 소수 3자리 |
| **Object** | String을 `Map<String, Object>` 또는 `List<Object>`로 역직렬화 |
| **String** | 처리·제한은 Apex Developer Guide의 Primitive Data Types 참조 |
| **Multi-Select** | Salesforce multi-select 문자열(세미콜론 구분 리스트)로 변환 |
| **Date** | 아래 표 참조 |

> **Note:** 값의 리스트를 Double·Integer·String·Boolean 같은 primitive 타입으로 cast하면 **리스트의 첫 번째 요소만** 출력된다.

**Date 포맷:** 입력 Date 값의 형식은 `mm/dd/yyyy` 또는 ISO 호환 date-time(`YYYY-MM-DD hh:mm:ss`, GMT)이어야 한다. 출력 date-time은 Oracle Java가 지원하는 date-time 템플릿으로 포맷할 수 있으며, 형식은 `DATE()` output data type에 문자열 인자로 지정한다.

```
Date("EEE, d MMM yyyy HH:mm:ss Z")
```

동일 date-time 값에 대한 출력 형식 예시:

| Format | Output |
|---|---|
| `Date(MM/dd/YYYY)` (기본) | 07/04/2001 |
| `Date("yyyy.MMMMM.dd GGG hh:mm aaa")` | 2001.July.04 AD 12:08 PM |
| `Date("EEE, d MMM yyyy HH:mm:ss Z")` | Wed, 4 Jul 2001 12:08:56 +0000 |

---

## Formulas

출력에 데이터를 추가하려면 formula를 정의한다. **Extract·Transform·Load**가 formula를 지원한다(Turbo Extract 제외). formula 출력을 output JSON(extract/transform) 또는 Salesforce object 필드(load)에 매핑한다.

- formula 결과는 key-value 쌍으로 저장된다: **Formula Result Path**가 key, **formula**가 value.
- formula 결과를 다른 formula나 매핑에서 재사용할 수 있다.
- 변수명에 공백·비영숫자 문자가 있으면 큰따옴표로 감싸고 앞에 `var:`를 붙인다. 예: JSON 노드명이 `Primary Guardian`이면 formula에서 `var:"Primary Guardian"`.
- standard runtime에서 잘못된 query formula는 error log 없이 null을 반환한다 — null 응답이면 query를 점검한다.
- 매핑에서 입력/출력 경로의 레벨 구분에는 콜론(`:`)을 사용한다.

**예제 (Transform + SUM formula):** 가격 리스트를 받아 총액을 계산.
- Formula: `SUM(Products:Price)`
- Formula Result Path: `TotalPrice`

입력 JSON:

```json
{
"CustomerName": "Bob Smith",
"Products": [
{
"Name": "iPhone",
"Price": 600
},
{
"Name": "iPhone Case",
"Price": 30
},
{
"Name": "Ear Buds",
"Price": 200
}
]
}
```

기대 출력 JSON (`TotalPrice`: 830):

```json
{
"CustomerName": "Bob Smith",
"TotalPrice": 830,
"Products": [
{
"Name": "iPhone",
"Price": 600
},
{
"Name": "iPhone Case",
"Price": 30
},
{
"Name": "Ear Buds",
"Price": 200
}
]
}
```

---

## 호출 방법 (전수)

Data Mapper는 **Integration Procedure·OmniScript·FlexCard**에서 호출할 수 있으며, **Apex 클래스·batch job·REST API**도 호출할 수 있다. Data Mapper로 데이터 트랜잭션을 중앙 관리해 여러 애플리케이션에서 재사용한다.

- 예: XML 형식의 사용자 정보 파일을 정기 수신 → Data Mapper Load로 파싱·변환해 Account·User·Contact 등 여러 관련 object에 로드.
- 예: Flow가 사용자 입력에서 Account·Contact·custom Policy 레코드를 한 번에 생성/업데이트 → Flow에서 여러 스텝 대신 단일 Data Mapper Load로 multi-object upsert 처리(Flow → 간단한 IP → Data Mapper Load).

Data Mapper Load는 입력 데이터를 3가지 방식으로 받는다:
- **OmniScript / Integration Procedure** — 실행 중 JSON을 빌드해 Load 호출 시 입력으로 전달
- **Data Mapper REST API** — POST action의 payload에 JSON 포함
- **Apex code** — Apex에서 JSON을 파라미터로 지정

### Apex 호출 (DRGlobal → Connect API)

**Summer '25부터** Apex에서 Data Mapper를 호출하려면 `ConnectApi.OmniDesignerConnect.executeDataMapper(bundleName, apexInput)` Connect API를 호출한다. Data Mapper 이름과 필요 입력 데이터를 지정한다. **이 API가 구 `vlocity_ins.DRGlobal.processObjectsJSON()` 메서드를 대체**한다. Connect API는 managed package 의존성을 제거하고, 이전 방식 대비 Apex 클래스에서의 Data Mapper 호출 성능을 **최대 60%까지 개선**한다.

> **성능 관련 주의:** 문서의 성능 수치는 특정 조건에서의 내부 검증·테스트 기반 참고용이며, 컴포넌트 설계·프로덕션 환경 등에 따라 실제 결과는 달라질 수 있다. 일반 지침일 뿐 성능 보장이 아니다.

입력 지정:
- JSON object → `Map<String, Object>` (String=JSON key, Object=JSON value)
- JSON object 배열 → `List<Map<String, Object>>`
- 대안으로 Data Mapper가 요구하는 JSON 입력을 담은 문자열로 지정 가능.

**Data Mapper Extract 또는 Transform 예제** — extract/transform 결과를 Apex에서 처리하려면 output을 `Map<String, Object>` 또는 `List<Map<String, Object>>`로 역직렬화한다.

```apex
/* Specify Data Mapper extract or transform to call */
String bundleName = 'DataMapperName';
/* Populate the input JSON */
Map<String, Object> objectList = new Map<String, Object>{'MyKey'=>'MyValue'};
/* Call the Data Mapper */
String jsonString = JSON.serialize(objectList);
List<String> jsonInputData = new List<String>();
jsonInputData.add(jsonString);
ConnectApi.DataMapperExecuteInputRepresentation apexInput = new ConnectApi.DataMapperExecuteInputRepresentation();
apexInput.dataMapperInput = jsonInputData;
apexInput.inputType = 'JSON';
ConnectApi.DataMapperExecuteOptionsRepresentation options = new ConnectApi.DataMapperExecuteOptionsRepresentation();
options.locale = null;
options.shouldSendLegacyResponse = true;
apexInput.options = options;
ConnectApi.DataMapperExecuteOutputRepresentation output = ConnectApi.OmniDesignerConnect.executeDataMapper(bundleName, apexInput);
/* Process the results returned by a Data Mapper Extract or Transform */
List<String> innerResponse = output.response;
for (String currentResponse : innerResponse){
Map<String, Object> outerMap = (Map<String, Object>) JSON.deserializeUntyped(currentResponse);
List<String> keys = new List<String>(outerMap.keySet());
System.debug(outerMap.get('response'));
}
```

**Data Mapper Load 예제** — load는 생성·업데이트된 Salesforce object 데이터를 담은 JSON을 반환한다. 결과를 map으로 역직렬화해 생성된 object·오류 정보를 추출한다.

```apex
String objectList = '{"accountName":"Vlocity", "contractCode":"SKS9181"}';
List<String> jsonInputData = new List<String>();
jsonInputData.add(objectList);
ConnectApi.DataMapperExecuteInputRepresentation apexInput = new ConnectApi.DataMapperExecuteInputRepresentation();
apexInput.dataMapperInput = jsonInputData;
apexInput.inputType = 'JSON';
ConnectApi.DataMapperExecuteOptionsRepresentation options = new ConnectApi.DataMapperExecuteOptionsRepresentation();
options.ignoreCache = false;
options.shouldSendLegacyResponse = true;
apexInput.options = options;
ConnectApi.DataMapperExecuteOutputRepresentation output =ConnectApi.OmniDesignerConnect.executeDataMapper(bundleName, apexInput);
List<String> innerResponse = output.response;
String currentResponse = innerResponse[0];
System.debug(currentResponse);
Map<String, Object> outerMap = (Map<String, Object>) JSON.deserializeUntyped(currentResponse);
List<String> keys = new List<String>(outerMap.keySet());
System.debug(outerMap.get('drSObjectResults'));
/*
Process the results of the load: these methods return details about objects affected by the Data Mapper Load, in addition to any errors that occured
*/
Map<String, Object> createdObjectsByType = (Map<String, Object>)resultMap.get('createdObjectsByType');
Map<String, Object> createdObjectsByTypeForBundle = (Map<String, Object>)createdObjectsByType.get('bundleName');
Map<String, Object> createdObjectsByOrder = (Map<String, Object>)resultMap.get('createdObjectsByOrder');
Map<String, Object> errors = (Map<String, Object>)resultMap.get('errors');
Map<String, Object> errorsByField = (Map<String, Object>)resultMap.get('errorsByField');
List<Object> errorsAsJson = (List<Object>)outerMap.get('errorsAsJson'); // Returns input JSON plus per-node errors
```

**Data Mapper Load 예제 — bulkUpload 파라미터** — batch Apex로 로드.

```apex
String objectList = '[{"ProductCode__c": 11050665},{"ProductCode__c": 11070100}]'; // replace this with the input for your Data Mapper Load
String bundleName = 'DRLoadPrice'; // replace this with your Data Mapper name
Map<String,Object> bodyData = new Map<String,Object>();
bodyData.put('bundleName',bundleName);
bodyData.put('objectList',objectList);
List<String> jsonInputData = new List<String>();
jsonInputData.add(bodyData.get('objectList'));
ConnectApi.DataMapperExecuteInputRepresentation apexInput = new ConnectApi.DataMapperExecuteInputRepresentation();
apexInput.dataMapperInput = jsonInputData;
apexInput.inputType = 'JSON';
ConnectApi.DataMapperExecuteOptionsRepresentation options = new ConnectApi.DataMapperExecuteOptionsRepresentation();
options.ignoreCache = false;
apexInput.options = options;
options.shouldSendLegacyResponse = true;
ConnectApi.DataMapperExecuteOutputRepresentation output = ConnectApi.OmniDesignerConnect.executeDataMapper(bodyData.get('bundleName'), apexInput);
List<String> innerResponse = output.response;
Map<String, Object> outerMap = (Map<String, Object>) JSON.deserializeUntyped(innerResponse[0]);
List<String> keys = new List<String>(outerMap.keySet());
System.debug(outerMap.get('drSObjectResults'));
```

> **DRGlobal 클래스:** Apex에서 Data Mapper를 호출하던 구 방식은 `DRGlobal` Apex 클래스를 통했다. Summer '25부터 DRGlobal의 기존 메서드를 위 Connect API로 대체한다.

### REST API

모든 타입의 Data Mapper를 Data Mapper REST API로 호출할 수 있다. Load 업데이트는 **POST**(입력 JSON payload), Extract 검색은 **GET**(Id 또는 파라미터 지정, JSON 응답).

**Extract — ID로 검색:**

```
/services/apexrest/{myOrgNamespace}/v2/DataRaptor/{DataMapperName}/Id
```

요청 예 (Contact의 Id로 열린 Case 검색):

```
GET /services/apexrest/vlocity_cmt/v2/DataRaptor/OpenCases/a10o00000022xVE
```

응답 예:

```json
{
"Contact": {
"Contact Name" : "Dennis Reynolds",
"Case Information": [
{
"Title": "Wrong widget shipped..."},
{
"Title": "Overcharged for gizmo..."},
{
"Title": "Damaged item..."}
]
}
}
```

**Extract — 파라미터로 검색:**

```
GET /services/apexrest/{myOrgNamespace}/v2/DataRaptor/{DataMapperName}/?${Param1}=${Val1}&${Param2}=${Val2}...
```

요청 예:

```
GET /services/apexrest/vlocity_cmt/v2/DataRaptor/Open_Cases/?FirstName=Dennis&LastName=Reynolds
```

**Load — POST:**

```
/services/apexrest/{myOrgNamespace}/v2/DataRaptor/
```

POST data 파라미터:
- **bundleName** — 호출할 Data Mapper Load의 이름
- **objectList** — 로드할 JSON 데이터. Load가 기대하는 형식과 일치해야 함
- **filesList** — (선택) key → base64 인코딩 파일의 Map
- **bulkUpload** — batch Apex 사용 시 TRUE

POST 요청/응답 예:

```json
{
"bundleName" : "AccountUpload",
"objectList" : {
"Agency Information": {
"Agency Name": "Vlocity",
"Agency Address": "50 Fremont",
"Agency City": "San Francisco",
"Agency State": "CA",
"Agency Zip": "94110",
}
},
"bulkUpload" : false
}
```

```json
{
"createdObjectsByOrder": {
"Open Account": {
"1": [
"a10o00000022xVEAAY"
]
}
},
"createdObjectsByType": {
"Open Account": {
"Account": [
"a10o00000022xVEAAY"
]
}
},
"errors": {},
"returnResultsData": []
}
```

---

## 지원 함수 (Data Mapper & Integration Procedure)

formula에서 데이터를 평가·조작하는 함수. 조건 연산, 쿼리·타 함수 호출, 숫자·날짜/시간·문자열·리스트/배열·JSON object 연산을 수행한다. (OmniScript formula/aggregate 전용 함수와는 별개 — 그쪽은 Create a Formula or Aggregate in an Omniscript 참조.)

| 카테고리 | 함수 |
|---|---|
| **Conditional** | `IF(expression, trueResult, falseResult)`; `ISBLANK(expression)`; `ISNOTBLANK(expression)` |
| **Mathematical** | `ABS(expression)`; `ROUND(expression, precision, direction)`; `SQRT(expression)` |
| **Date and Time** | `ADDDAY(date, days)`; `ADDMONTH(date, months)`; `ADDYEAR(date, years)`; `AGE(birthDate)`; `AGEON(birthDate, date)`; `DATEDIFF(firstDate, secondDate)`; `DATETIMETOUNIX(datetime)`; `DAY(date)`; `EOM(date)`; `FORMATDATETIME(datetime, format, timezone)`; `FORMATDATETIMEGMT(datetime, timezone, format)`; `HOUR(time)`; `MINUTE(time)`; `MONTH(date)`; `NOW(format)`; `SECOND(time)`; `TIMEDIFF(firstTime, secondTime)`; `TODAY()`; `UNIXTODATETIME(timestamp)`; `YEAR(date)` |
| **String** | `BASE64ENCODE(data)`; `CONCAT(string...)`; `JOIN(string..., token)`; `MAXSTRING(string...)`; `SPLIT(string, token)`; `STRINGINDEXOF(string, substring)`; `SUBSTRING(string, startIndex, endIndex)`; `TOSTRING(data)` |
| **List and Array** | `AVG(list)`; `FILTER(LIST(list), condition)`; `LIST(expression)`; `LISTMERGE(mergeKey..., LIST(list)...)`; `LISTMERGEPRIMARY(mergeKey..., LIST(list)...)`; `LISTSIZE(list)`; `MAPTOLIST(jsonObject)`; `MAX(list)`; `MIN(list...)`; `SORTBY(LIST(list), key..., [:DSC])`; `SUM(list)` |
| **JSON Object** | `DESERIALIZE(jsonString)`; `RESERIALIZE(jsonString)`; `SERIALIZE(jsonObject)`; `VALUELOOKUP(startNode, node...)` |
| **Invocation** | `COUNTQUERY(query)`; `FUNCTION(class, method, input...)`; `GENERATEGLOBALKEY(prefix)`; `QUERY(query)` |

**구문 규칙:**
- `expression` = 변수·연산자·함수를 포함하는 단일 값 또는 구성. 파라미터 데이터 타입으로 resolve되어야 함.
- `value` = 파라미터 데이터 타입과 일치하는 단일 값.
- `data` = 여러 데이터 타입(값·expression·값 리스트 수용).
- `...` (ellipses) = 콤마 구분 다중 인자.
- **formula는 단일 연산만 포함**할 수 있다(중첩 함수·연산자는 가능, 독립된 두 연산은 불가). formula editor는 line continuation 문자(백슬래시)나 termination 문자(세미콜론 `;`)를 독립 연산 사이에 지원하지 않는다.

**Summer '25 함수 변경:**
- 파라미터명·구문이 일관성·명확성을 위해 변경됨.
- 추가된 date/time 함수: `DAY(date)`, `HOUR(time)`, `MINUTE(time)`, `SECOND(time)`, `TIMEDIFF(firstTime, secondTime)`
- `TODAY()`는 더 이상 format 파라미터를 받지 않음.
- 추가된 string 함수: `JOIN(string..., token)`, `SPLIT(string, token)`
- 추가된 list/array 함수: `MAPTOLIST(jsonObject)`
- 제거된 함수: `BASEURL`, `InvokeIP`, `ORDERITEMATTRIBUTES`

---

## When to use — Data Mapper vs Integration Procedure

Data Mapper는 SObject 데이터를 읽거나 쓰거나 단일 스텝 데이터 구조 변환을 한다. Integration Procedure는 REST API·Apex 클래스 등 다양한 데이터를 다단계로 처리한다. IP는 보통 하나 이상의 Data Mapper를 호출하며 더 유연·강력하다.

**단일 Data Mapper 사용 조건:**
- SObject를 읽거나 쓰거나 (둘 다 아님)
- 읽/쓸 SObject가 정의된 관계를 가짐 (예: Account ↔ Contact의 AccountId)
- JSON/XML 데이터만 다루고 SObject가 관여하지 않음
- 필터·계산·재포맷을 하나 또는 일련의 formula로 처리 가능
- input JSON 노드 → output JSON 노드 매핑으로 데이터 구조 변경 가능
- CSV·Apex·REST API·external object를 읽/쓰지 않음
- 이메일 발송·리스트 병합·오류 처리를 하지 않음

**Integration Procedure 사용 조건:**
- 하나 이상의 SObject를 **읽고 동시에 써야** 함 (Data Mapper 2개 이상 호출 필요)
- 읽/쓸 SObject 간 정의된 관계가 없음
- formula만으로 변환 불가 (예: 조건에 따라 필터/계산 수행 여부가 달라짐)
- JSON 노드 매핑이 단순하지 않거나 일련의 스텝이 필요
- SObject·CSV·external object·Apex·REST API 등 **다중 데이터 소스 타입** 읽/쓰기
- 이메일 발송·리스트 병합·오류 처리 수행

---

## Best Practices

- OmniScript 요소와 Data Mapper response 노드에 **고유한 이름** 사용.
- 한 작업에 필요한 데이터만 추출/로드하는 **targeted Data Mapper** 생성.
- 다른 SObject 데이터를 가져올 땐 **relationship notation(query)** 을 최대한 사용.
- 암호화 필드의 복호화 값을 표시/처리하기 전 사용자에게 **View Encrypted Data** 권한이 있는지 항상 확인(암호화 접근 제어 준수).
- 서버 성능 문제를 피하려면 **SObject 수를 3개 이하**로 유지.
- 모든 필터·정렬(ORDER BY)은 **indexed 필드**에서 수행. Id·Name 필드는 항상 인덱싱됨.
- 자주 접근하지만 드물게 업데이트되는 데이터는 **caching**으로 저장.
- **null-filter 우회:** Extract에서 Equals 필터(`=`)를 null 값과 쓰면 known limitation으로 필터가 올바르게 동작하지 않는다. 추가로 Not Equal To(`!=`) 필터를 넣어 회피한다. 예: 전화번호가 있는 null account 값 필터링 → `accountId = null AND phone != null`.
- Data Mapper vs IP 판단은 위 "When to use" 섹션 참조.

> **버전 관리 Note:** version 240~242.7에서는 Data Mapper versioning이 Setup > Omnistudio Settings에서 제공됐으나, **version 242.8부터는 제공되지 않는다.** Data Mapper versioning은 권장되지 않으며, 활성화하면 동작은 하지만, 비활성화하려면 org의 모든 Data Mapper가 버전을 하나만 갖도록 한 뒤 Salesforce support에 문의한다. (활성화·저장 시 활성 버전은 한 번에 하나만 가능 — 새 버전을 활성화하면 다른 모든 버전이 비활성화됨.)

---

## 관련 노트

- [[OmniStudio 개요·오리엔테이션]] — 시리즈 허브·오리엔테이션
- [[OmniScript]] — Data Mapper Action element로 Data Mapper를 호출하는 UI 프로세스
- [[FlexCard]] — 데이터 소스로 Data Mapper를 사용하는 카드 컴포넌트
- [[Integration Procedure]] — Data Mapper Extract/Post/Transform/Turbo 액션을 오케스트레이션
- [[OmniStudio Formula Functions 레퍼런스]] — Data Mapper Transform·formula에서 쓰는 공용 함수
- [[ConnectApi Namespace 개요]] — `ConnectApi.OmniDesignerConnect.executeDataMapper` Apex 호출
