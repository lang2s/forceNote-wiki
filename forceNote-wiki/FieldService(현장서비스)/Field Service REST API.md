---
tags: [field-service, fsl, rest-api, 현장서비스, appointment-bundling, mobile-settings, service-report, field-service-flow]
source: field_service_dev.pdf (Field Service Developer Guide v67.0 Summer '26)
created: 2026-06-23
aliases: [Field Service REST API, FS REST, Appointment Bundling API, Field Service Flow REST, Field Service Mobile Settings REST, Service Report Template REST, Create Bundle, Unbundle, Start Batch, FieldServiceMobileSettings userSettings]
---

# Field Service REST API

> Field Service 구현을 관리하는 전용 REST 엔드포인트 모음 — ① Field Service Flow ② Field Service Mobile Settings ③ Service Report Template ④ Appointment Bundling REST APIs(6 서브 리소스). 일반 sObject CRUD·SOQL은 [[REST API]] 참조.

> [!note] *Field Service Developer Guide v67.0 (Summer '26)* "Field Service REST API" 챕터 전수. 원문 `[sic]` 오타·이상 표기는 의도적으로 보존했다(아래 본문 주석 참조). 같은 가이드의 "Field Service Metadata API" 챕터(FieldServiceSettings·Skill·TimeSheetTemplate)는 이 노트 범위 밖.

---

## 개요 — 4개 리소스 그룹

> The following endpoints can be used to manage your field service implementation.

| 리소스 | 설명 | REST API 버전 |
|---|---|---|
| Field Service Flow | 필드 서비스 플로우에 대응하는 정보를 반환한다. | 42.0 이상 |
| Field Service Mobile Settings | 컨텍스트 사용자 프로필에 할당된 Field Service 모바일 앱 설정 정보를 반환한다. | 42.0 이상 |
| Service Report Template | 하나 이상의 서비스 리포트 템플릿에 대응하는 정보를 반환한다. | 40.0 이상 |
| Appointment Bundling REST APIs | 번들 생성·번들 멤버 제거·자동 번들링 배치 시작·언번들(단건/다건)·번들 업데이트. | 서브 리소스별 54.0 이상 |

---

## 1. Field Service Flow

> 필드 서비스 플로우에 대응하는 정보를 반환한다. REST API 버전 **42.0 이상**.

이 리소스는 플로우 정의의 API 이름을 받아 **활성 플로우 버전** 정보를 반환한다. 활성 버전이 없으면 가장 최신 버전을 반환한다. 플로우 요소는 Translation Workbench를 통해 호출 사용자의 언어로 번역될 수 있다 — 특정 플로우 버전의 요소가 번역돼 있으면, 반환 데이터는 질의 언어를 사용한다.

이 리소스는 **Field Service mobile app user 권한**과 **Run Flows** 사용자 권한을 가진 API 사용자에게 제공된다.

| 항목 | 값 |
|---|---|
| **URI** | `/services/data/vXX.X/support/fieldservice/Flow?developerNames=Flow Unique Name` |
| **Formats** | JSON, XML |
| **HTTP Method** | GET |
| **Authentication** | `Authorization: Bearer token` |

**Parameters**

| Parameter | Description |
|---|---|
| developerNames | 플로우 정의의 고유 이름. 현재 이 파라미터로는 **하나의 고유 이름만** 지정할 수 있다. |

**Response Body (주요 요소)**

| Field | Type | Description |
|---|---|---|
| Flows | Array | 플로우 목록 |
| CreatedDate | String | 플로우 생성 일자 |
| Description | String | 플로우 설명 |
| FullName | String | 플로우 전체 이름 |
| Id | String | 플로우 고유 ID |
| LastModifiedDate | String | 마지막 수정 일자 |
| Metadata | (객체) | 중첩 — 아래 |
| &nbsp;&nbsp;Choices | Array | 필드에서 사용하는 choice 목록 |
| &nbsp;&nbsp;&nbsp;&nbsp;ChoiceText | String | choice 텍스트 |
| &nbsp;&nbsp;&nbsp;&nbsp;DataType | String | choice 데이터 타입 |
| &nbsp;&nbsp;&nbsp;&nbsp;Name | String | choice 이름 |
| &nbsp;&nbsp;Screens | Array of objects | 플로우의 화면 목록 |
| &nbsp;&nbsp;&nbsp;&nbsp;AllowBack | Boolean | 화면에서 뒤로 갈 수 있는지 |
| &nbsp;&nbsp;&nbsp;&nbsp;AllowFinish | Boolean | 화면에서 플로우를 끝낼 수 있는지 |
| &nbsp;&nbsp;&nbsp;&nbsp;AllowPause | Boolean | 화면에서 일시중지할 수 있는지 |
| &nbsp;&nbsp;&nbsp;&nbsp;Fields | Array of objects | 화면이 사용하는 필드 목록 |
| &nbsp;&nbsp;&nbsp;&nbsp;HelpText | String | 화면의 도움말 텍스트 |
| &nbsp;&nbsp;&nbsp;&nbsp;Label | String | 화면 레이블 |
| &nbsp;&nbsp;&nbsp;&nbsp;LocationX | Number | 화면 X 좌표 |
| &nbsp;&nbsp;&nbsp;&nbsp;LocationY | Number | 화면 Y 좌표 |
| &nbsp;&nbsp;&nbsp;&nbsp;Name | String | 화면 이름 |
| ProcessType | String | 플로우의 프로세스 타입; 여기서는 `"FieldServiceMobile"` |
| Status | String | 플로우 상태 |
| VersionNumber | Number | 플로우 버전 번호 |

**Example** — 플로우 정의 고유 이름 `FS_Flow`. 응답에는 두 화면(Screen 1, Screen 2)이 들어 있다. Screen 1은 두 필드(text 필드 Field 1, choice 두 개를 가진 RadioButton), Screen 2는 한 필드(text 필드 Field 2)를 가진다.

```
GET
/services/data/v42.0/support/fieldservice/Flow?developerNames=FS_Flow
```

```json
{
    "flows" : [ {
      "Id" : "301R000000008grIAA",
      "DefinitionId" : "300R00000004OLFIA2",
      "MasterLabel" : "FS_Flow",
      "ManageableState" : "unmanaged",
      "VersionNumber" : 1,
      "Status" : "Draft",
      "Description" : "FS Flow",
      "ProcessType" : "FieldServiceMobile",
      "CreatedDate" : "2017-12-05T19:22:16.000+0000",
      "CreatedById" : "005R0000000J2glIAC",
      "LastModifiedDate" : "2017-12-05T19:22:16.000+0000",
      "LastModifiedById" : "005R0000000J2glIAC",
      "Metadata" : {
        "actionCalls" : null,
        "apexPluginCalls" : null,
        "assignments" : null,
        "choices" : [ {
          "choiceText" : "Choice A",
          "dataType" : "String",
          "description" : null,
          "name" : "Choice_A",
          "processMetadataValues" : null,
          "userInput" : null,
          "value" : null
        }, {
          "choiceText" : "Choice B",
          "dataType" : "String",
          "description" : null,
          "name" : "Choice_B",
          "processMetadataValues" : null,
          "userInput" : null,
          "value" : null
        } ],
        "constants" : null,
        "decisions" : null,
        "description" : "FS Flow",
        "dynamicChoiceSets" : null,
        "formulas" : null,
        "fullName" : "FS_Flow-1",
        "interviewLabel" : "FS_Flow {!$Flow.CurrentDateTime}",
        "label" : "FS Flow",
        "loops" : null,
        "module" : null,
        "processMetadataValues" : null,
        "processType" : "FieldServiceMobile",
        "recordCreates" : null,
        "recordDeletes" : null,
        "recordLookups" : null,
        "recordUpdates" : null,
        "screens" : [ {
          "allowBack" : true,
          "allowFinish" : true,
          "allowPause" : true,
          "connector" : {
            "processMetadataValues" : null,
            "targetReference" : "Screen_2"
          },
          "description" : null,
          "fields" : [ {
            "choiceReferences" : null,
            "dataType" : "String",
            "defaultSelectedChoiceReference" : null,
            "defaultValue" : null,
            "description" : null,
            "extensionName" : null,
            "fieldText" : "Field 1",
            "fieldType" : "InputField",
            "helpText" : "Help Text 1",
            "inputParameters" : [ ],
            "isRequired" : false,
            "isVisible" : null,
            "name" : "Field_1",
            "outputParameters" : [ ],
            "processMetadataValues" : null,
            "scale" : null,
            "validationRule" : null
          }, {
            "choiceReferences" : [ "Choice_A", "Choice_B" ],
            "dataType" : "String",
            "defaultSelectedChoiceReference" : null,
            "defaultValue" : null,
            "description" : null,
            "extensionName" : null,
            "fieldText" : "Pick a choice",
            "fieldType" : "RadioButtons",
            "helpText" : "Pick a Choice help text",
            "inputParameters" : [ ],
            "isRequired" : false,
            "isVisible" : null,
            "name" : "Pick_a_choice",
            "outputParameters" : [ ],
            "processMetadataValues" : null,
            "scale" : null,
            "validationRule" : null
          } ],
          "helpText" : null,
          "label" : "Screen 1",
          "locationX" : 189,
          "locationY" : 178,
          "name" : "Screen_1",
          "pausedText" : null,
          "processMetadataValues" : null,
          "rules" : null,
          "showFooter" : true,
          "showHeader" : true
        }, {
          "allowBack" : true,
          "allowFinish" : true,
          "allowPause" : true,
          "connector" : null,
          "description" : null,
          "fields" : [ {
            "choiceReferences" : null,
            "dataType" : "String",
            "defaultSelectedChoiceReference" : null,
            "defaultValue" : null,
            "description" : null,
            "extensionName" : null,
            "fieldText" : "Field 1",
            "fieldType" : "InputField",
            "helpText" : null,
            "inputParameters" : [ ],
            "isRequired" : false,
            "isVisible" : null,
            "name" : "Field_1",
            "outputParameters" : [ ],
            "processMetadataValues" : null,
            "scale" : null,
            "validationRule" : null
          } ],
          "helpText" : null,
          "label" : "Screen 2",
          "locationX" : 437,
          "locationY" : 289,
          "name" : "Screen_2",
          "pausedText" : null,
          "processMetadataValues" : null,
          "rules" : null,
          "showFooter" : true,
          "showHeader" : true
        } ],
        "startElementReference" : "Screen_1",
        "steps" : null,
        "subflows" : null,
        "textTemplates" : null,
        "urls" : null,
        "variables" : null,
        "waits" : null
      },
      "FullName" : "FS_Flow-1"
    } ]
}
```

---

## 2. Field Service Mobile Settings

> 컨텍스트 사용자 프로필에 할당된 Field Service 모바일 앱 설정 정보를 반환한다. REST API 버전 **42.0 이상**.

Android·iOS용 Field Service 모바일 앱은 브랜딩 색상, 지오로케이션 정확도, 앱 익스텐션, 날짜 선택기 표시 등 다양한 커스터마이즈 설정을 제공한다. 이 설정의 고유 구성을 사용자 프로필에 할당해 맞춤형 모바일 경험을 만들 수 있다(예: 협력업체·등급별 기술자·서비스 크루 리더별 분리 설정).

- `FieldServiceMobileSettings` 객체는 모바일 앱 설정 구성을 나타낸다.
- 설정 구성과 사용자 프로필 간 할당은 자식 객체 `MobileSettingsAssignment`에 저장된다.
- `FieldServiceMobileSettings` 레코드는 0개 이상의 자식 `AppExtension` 레코드를 가질 수 있다.
- `userSettings` 익스텐션은 사용자 프로필 설정 정보를 반환하게 한다.
- 각 사용자 프로필은 **단 하나의** `FieldServiceMobileSettings` 레코드와만 연결된다. 프로필에 설정 레코드가 명시적으로 할당되지 않으면 **기본 설정(default)**을 사용한다.

이 리소스는 호출이 일어나는 컨텍스트 사용자에게 할당된 FieldServiceMobileApp 설정 정보를 반환한다. Field Service가 활성화된 org에서 다음 중 하나 이상을 가진 사용자에게 사용 가능하다:

- Field Service Mobile permission set license
- View Setup 사용자 권한
- Customize Application 사용자 권한
- System Administrator 프로필

또한 **Field Service Mobile permission set license**를 가진 Experience Builder 사이트 사용자의 컨텍스트에서도 실행될 수 있다.

| 항목 | 값 |
|---|---|
| **URI** | `/services/data/vXX.X/sobjects/FieldServiceMobileSettings/userSettings` |
| **Formats** | JSON, XML |
| **HTTP Method** | GET |
| **Authentication** | `Authorization: Bearer token` |
| **Parameters** | None. |

**Response Body** — FieldServiceMobileSettings 레코드는 아래 속성을 가진다. **별도 명시가 없는 한 모든 String 속성의 최대 길이는 7자**다. 설명은 Salesforce Object Reference의 FieldServiceMobileSettings 참조.

| Field | Type | Enum 값 / 비고 |
|---|---|---|
| BgGeoLocationAccuracy | Enum | Values: Medium, Coarse, VeryCoarse |
| BgGeoLocationMinUpdateFreqMins | Integer | |
| BrandInvertedColor | String | |
| ContrastInvertedColor | String | |
| ContrastPrimaryColor | String | |
| ContrastQuaternaryColor | String | |
| ContrastQuinaryColor | String | |
| ContrastSecondaryColor | String | |
| ContrastTertiaryColor | String | |
| DefaultListViewDeveloperName | String | maximum length: 255 |
| FeedbackPrimaryColor | String | |
| FeedbackSecondaryColor | String | |
| FeedbackSelectedColor | String | |
| FutureDaysInDatePicker | Integer | |
| GeoLocationAccuracy | Enum | Values: Fine, Medium, Coarse |
| GeoLocationMinUpdateFreqMins | Integer | |
| Id | String | |
| IsAssignmentNotification | Boolean | |
| IsDefault | Boolean | |
| IsDispatchNotification | Boolean | |
| IsScheduleViewResourceAbsences | Boolean | API 버전 55.0 이상에서 사용 가능 |
| IsSendLocationHistory | Boolean | |
| IsShowEditFullRecord | Boolean | |
| IsUseSalesforceMobileActions | Boolean | |
| MetadataCacheTimeDays | Integer | |
| NavbarBackgroundColor | String | |
| NavbarInvertedColor | String | |
| PastDaysInDatePicker | Integer | |
| PrimaryBrandColor | String | |
| RecordDataCacheTimeMins | Integer | |
| SecondaryBrandColor | String | |
| TimeIntervalSetupMins | Enum | Values: 1, 5, 15, 20, 30, 60 |
| UpdateScheduleTimeMins | Integer | |

**에러 조건** — 다음 중 하나라도 참이면 에러 메시지가 반환된다:

- 사용자가 FieldServiceMobileSettings에 접근 권한이 없음
- org에서 Field Service가 활성화되지 않음
- 내부 서버 오류 발생

**Example**

```
GET
/services/data/v56.0/sobjects/FieldServiceMobileSettings/userSettings
```

```json
{
  "attributes" : {
    "type" : "FieldServiceMobileSettings",
    "url" : "/services/data/v46.0/sobjects/FieldServiceMobileSettings/0MfRM0000000rpR0AQ"
  },
  "Id" : "0MfRM0000000rpR0AQ",
  "IsDeleted" : false,
  "DeveloperName" : "Field_Service_Mobile_Settings",
  "Language" : "en_US",
  "MasterLabel" : "Field Service Mobile Settings",
  "CreatedDate" : "2019-02-17T05:20:47.000+0000",
  "CreatedById" : "005RM000001hTsLYAU",
  "LastModifiedDate" : "2019-03-22T22:48:17.000+0000",
  "LastModifiedById" : "005RM000001k2kpYAA",
  "SystemModstamp" : "2019-03-22T22:48:17.000+0000",
  "NavbarBackgroundColor" : "#803ABE",
  "BrandInvertedColor" : "#FFFFFF",
  "FeedbackPrimaryColor" : "#C23934",
  "FeedbackSecondaryColor" : "#13C4A3",
  "PrimaryBrandColor" : "#803ABE",
  "SecondaryBrandColor" : "#2A7AB0",
  "ContrastPrimaryColor" : "#000000",
  "ContrastSecondaryColor" : "#444444",
  "ContrastTertiaryColor" : "#9FAAB5",
  "ContrastQuaternaryColor" : "#E6E6EB",
  "ContrastQuinaryColor" : "#EEEEEE",
  "ContrastInvertedColor" : "#FFFFFF",
  "IsScheduleViewResourceAbsences" : true,
  "IsSendLocationHistory" : false,
  "GeoLocationMinUpdateFreqMins" : 10,
  "GeoLocationAccuracy" : "Medium",
  "RecordDataCacheTimeMins" : 240,
  "MetadataCacheTimeDays" : 7,
  "UpdateScheduleTimeMins" : 30,
  "IsShowEditFullRecord" : false,
  "TimeIntervalSetupMins" : "15",
  "DefaultListViewDeveloperName" : null,
  "NavbarInvertedColor" : "#FFFFFF",
  "FeedbackSelectedColor" : "#FFFFFF",
  "FutureDaysInDatePicker" : 45,
  "PastDaysInDatePicker" : 45,
  "IsDefault" : true,
  "BgGeoLocationMinUpdateFreqMins" : 60,
  "BgGeoLocationAccuracy" : "Coarse",
  "IsUseSalesforceMobileActions" : false,
  "IsAssignmentNotification" : false,
  "IsDispatchNotification" : true
}
```

---

## 3. Service Report Template

> 하나 이상의 서비스 리포트 템플릿에 대응하는 정보를 반환한다. REST API 버전 **40.0 이상**.

이 리소스는 하나 이상의 서비스 리포트 템플릿 ID를 입력받아 템플릿 정보를 응답한다. 서비스 리포트는 **work order, work order line item, service appointment**에 대해 생성될 수 있다. ServiceReportTemplate은 Field Service가 활성화된 org의 API 사용자에게 제공되며, Experience Builder 사이트에서도 활성화된다.

| 항목 | 값 |
|---|---|
| **URI** | `/services/data/vXX.X/support/fieldservice/ServiceReportTemplate` |
| **Formats** | JSON |
| **HTTP Method** | GET |
| **Authentication** | `Authorization: Bearer token` |

**Parameters**

| Parameter | Description |
|---|---|
| templateIds | 서비스 리포트 템플릿 ID 목록(콤마 구분 문자열). 유효하지 않은 ID가 하나라도 있으면 응답에 실패가 표시된다. |
| showDefault | 기본 서비스 리포트 템플릿을 응답에 포함할지 나타내는 boolean. `true`면 기본 템플릿 포함, `false`(default)면 미포함. 예: 비기본 템플릿 2개의 ID를 나열하고 `showDefault=true`면 응답에 3개 템플릿 정보가 포함된다. |
| templateTypes | 리포트 템플릿이 사용될 수 있는 레코드 타입: `ServiceAppointment`, `WorkOrder`, `WorkOrderLineItem`. 서비스 리포트 템플릿은 4개의 커스터마이즈 가능한 서브 템플릿을 포함한다: • **WO** — Work Order • **WOLI** — Work Order Line Item • **WO_SA** — Service Appointment for Work Order • **WOLI_SA** — Service Appointment for Work Order Line Item |

**Response Body** — 서비스 리포트는 삭제 불가능한 3개 메인 영역을 가진다: **Header, Body, Footer**. 각 영역은 최소 하나의 컴포넌트(section, related list, signature) — 비어 있어도 됨 — 를 포함해야 한다. Header와 Footer는 미리 정의된 section을 가지며 추가 컴포넌트를 더할 수 없다. Body는 각 컴포넌트를 하나 이상 포함할 수 있다.

**Section 컴포넌트** 속성:

- `title`: String
- `hideTitle`: Boolean
- `hideFieldLabels`: Boolean
- `columns`: Enum { 1, 2 }
- `rightAlignment`: Enum { true, false }
- `fields`: Array of {Field}

**Field 컴포넌트** — 필드는 section, related list, signature에 추가될 수 있다. related list의 column은 API에서 field로 변환된다. 속성:

- `fieldType`: Enum { rta, entityField, blank }
- Attributes:
  - `rta`면 `{"richTextValue" : "<html value>"}` 포함
  - `entityField`면 `{"entityName" : "<WorkOrder>", "fieldName" : "Account"}` 포함
  - `blank`면 추가 정보 불필요
- Position: `row`, `column`

**Related list 컴포넌트** 속성:

- `title`: String
- `hideTitle`: Boolean
- `entityName`: String
- `relatedListName`: String
- `relatedEntityName`: String
- `fields`: Array of {Field Name (String), Column Position (Integer)}

**Signature 컴포넌트** 속성:

- `title`: String
- `hideTitle`: Boolean
- `hideFieldLabels`: Boolean
- `columns`: Enum { 1, 2 }
- `rightAlignment`: Enum { true, false }
- `signatureType`: Dynamic Enum { <technician 1>, <dispatcher 1> }
- `fields`: Array of {Field Name (String), Position (Row, Column)}

**Example** — 서비스 리포트 템플릿 ID 2개 사용.

```
GET
/services/data/v42.0/support/fieldservice/ServiceReportTemplate?templateIds=0SLxx0000000ABC,0SLR000000001QtOAI&showDefault=false&templateTypes=ServiceAppointment
```

아래 응답은 **원문에 `...` 생략 마커가 그대로 포함된 발췌**다(전체 필드 아님 — 원문이 의도적으로 줄인 부분). fabricate 없이 원문대로 보존했다.

```json
{
    "serviceReportTemplates": [
      {
        "defaultTemplate": false,
        "error": {
          "errorCode": "INVALID_TEMPLATE_ID",
          "errorMessage": "The Service Report Template ID is invalid."
        },
        "subTemplates": [],
        "templateId": "0SLxx0000000ABC"
      },
      {
        "defaultTemplate": false,
        "error": null,
        "subTemplates": [
          {
            "regions": [
              {
                "sections": [
                  {
                    "columns": 2,
                    "hideFieldLabels": false,
                    "hideTitle": false,
                    "items": [
                        {
                           "position": {
                              "column": 0,
                              "row": 0
                           },
                           "richText": "<img alt=\"User-added image\" src=\"https://mobile1.file.force.com/servlet/rtaImage?eid=0QRR000000008oZ&amp;feoid=Data&amp;refid=0EMR00000000DGK\"></img>",
                           "type": "rta"
                        },
                        {
                          "position": {
                            "column": 1,
                            "row": 0
                          },
                          "richText": "<u><i>Salesforce.com</i></u>",
                          "type": "rta"
                        }
                      ],
                      "position": 0,
                      "rightAlign": false,
                      "title": "Service Report",
                      "type": "section"
                 }
               ],
               "type": "HEADER"
             },
             {
               "sections": [
                 {
                   "columns": 2,
                   "hideFieldLabels": false,
                   "hideTitle": true,
                   "items": [],
                   "position": 0,
                   "rightAlign": false,
                   "showPageNumber": false,
                   "title": "Footer Section",
                   "type": "section"
                 }
               ],
               "type": "FOOTER"
             },
             {
               "sections": [
                 {
                   "columns": 2,
                   "hideFieldLabels": false,
                   "hideTitle": false,
                   "items": [
                     {
                        "entityName": "ServiceAppointment",
                        "label": "Account",
                        "name": "AccountId",
                        "position": {
                          "column": 0,
                          "row": 0
                        },
                        "type": "entityField"
                      },
                      ...
                      {
                        "position": {
                          "column": 1,
                          "row": 0
                        },
                        "richText": "Prepared By:",
                        "type": "rta"
                      }
                    ],
                    "position": 0,
                    "rightAlign": false,
                    "title": "Account & Contact Information",
                    "type": "section"
                  },
                  {
                    "entityName": "WorkOrder",
                    "filterCriteria": {
                      "conditions": [
                        {
                          "field": "Status",
                          "operation": "includes",
                          "position": 0,
                          "values": [
                            "In Progress",
                            "Completed"
                          ]
                        }
                      ]
                    },
                    "hideTitle": false,
                    "items": [
                      {
                        "column": 0,
                        "label": "Work Order Line Item Number",
                        "name": "LineItemNumber"
                      },
                      ...
                      {
                        "column": 6,
                        "label": "Unit Price",
                        "name": "UnitPrice"
                      }
                    ],
                    "position": 5,
                    "relatedEntityName": "WorkOrderLineItem",
                    "relatedListName": "WorkOrderLineItems",
                    "title": "Work Order Line Items",
                    "type": "relatedList"
                  },
                  {
                    "columns": 1,
                    "hideFieldLabels": false,
                    "hideTitle": false,
                    "items": [
                      {
                        "entityName": "DigitalSignature",
                        "label": "Signature",
                        "name": "Document",
                        "position": {
                          "column": 0,
                          "row": 0
                        },
                        "type": "entityField"
                      },
                      {
                        "entityName": "DigitalSignature",
                        "label": "Signed By",
                        "name": "SignedBy",
                        "position": {
                          "column": 0,
                          "row": 1
                        },
                        "type": "entityField"
                      },
                      {
                        "entityName": "DigitalSignature",
                        "label": "Date",
                        "name": "SignedDate",
                        "position": {
                          "column": 0,
                          "row": 2
                        },
                        "type": "entityField"
                      }
                    ],
                    "position": 9,
                    "rightAlign": false,
                    "signatureType": "Default",
                    "signatureTypeLabel": "Default",
                    "title": "Customer Signature",
                    "type": "signature"
                  }
                ],
                "type": "BODY"
               }
             ],
             "subTemplateType": "WO_SA"
           },
           {
             ...
             "subTemplateType": "WOLI_SA"
           }
         ],
         "templateId": "0SLR000000001QtOAI"
     }
   ]
}
```

---

## 4. Appointment Bundling REST APIs

> 번들 생성, 번들 멤버 제거, 자동 번들링 프로세스 시작, 단/다건 언번들, 번들 업데이트에 사용하는 REST API 모음. 6개 서브 리소스. 모두 **API 버전 54.0 이상**, **Gov Cloud 미지원**.

번들이 다루는 `ApptBundlePolicy`·`ApptBundleConfig` 등 객체 레퍼런스는 별도 노트 예정 — `Field Service 번들 객체 레퍼런스` (미작성).

### Limitations

**Create Bundle / Remove Bundle Members / Unbundle / Unbundle Multiple / Update Bundle:**

- 24시간 내 **1,000 API calls**.
- 엔지니어 라이선스당 24시간 내 **50 API calls** (위 1,000 calls에 **추가**).
- **10 concurrent API calls**.

**Start Batch:**

- territory당, **시간당 1 API call**.

### 6개 서브 리소스 요약

| 리소스 | HTTP | URI | 설명 | 버전 |
|---|---|---|---|---|
| Create Bundle | POST | `<host>/bundleflow/api/v1.0/bundle` | 서비스 약속을 수동으로 번들 생성. SA ID + manual bundling policy ID를 받아 번들 SA의 ID를 반환. | 54.0+ |
| Remove Bundle Members | PATCH | `<host>/bundleflow/api/v1.0/bundle/remove` | 기존 번들에서 하나 이상의 SA 제거. SA ID를 받음. | 54.0+ |
| Start Batch | POST | `<host>/bundleflow/api/v1.0/startbatch` | 자동 번들링용 정책을 사용해 SA 번들을 자동 생성. 수동 번들된 SA는 영향받지 않음. 배치 시작의 성공/실패 메시지 반환. | 54.0+ |
| Unbundle | DELETE | `<host>/bundleflow/api/v1.0/bundle/<ID>?initiate=manual` | 하나의 SA 번들 언번들. bundle ID를 받음. | 54.0+ |
| Unbundle Multiple | POST | `<host>/bundleflow/api/v1.0/unbundleMultiple` | 하나 이상의 번들 언번들. 하나 이상의 bundle ID를 받음. | 54.0+ |
| Update Bundle | PATCH | `<host>/bundleflow/api/v1.0/bundle/{ID}` | 기존 번들에 SA 추가. bundle ID + SA ID를 받음. | 54.0+ |

### 공통 사항 (6개 서브 리소스 모두에 반복 적용)

**Add a Remote Site (전제 설정):**

1. Setup → Quick Find에 `Security` 입력 → **Remote Site Settings** 선택.
2. **New Remote Site** 클릭.
3. 이름 입력.
4. Remote Site URL에 `https://api.salesforce.com/` 입력.
5. 저장.

- **Format:** JSON
- **Authentication:** `Authorization: Bearer <token>` — 인증 토큰이 유효하지 않으면 **401 HTTP status**가 반환된다.
- **Headers (5개, 공통):**

| Header | 설명 |
|---|---|
| `x-sfdc-tenant-id` | Field Service functional domain. 예: `request.setHeader('x-sfdc-tenant-id', 'core/prod/ORG-ID_18_Characters');` |
| `sf_api_version` | Salesforce API 버전. **최소 버전 53.0**. |
| `Authorization` | Authorization token. |
| `Content-Type` | 파일 포맷. 유효 값은 JSON. |
| `Referer` | Org domain URL. |

### Error Responses 표 (5개 서브 리소스 공통)

> 아래 표는 **Create Bundle / Remove Bundle Members / Unbundle / Unbundle Multiple / Update Bundle** 5개 리소스 각각에 붙어 있는 Error Responses 표(원문 Table 1–5)이며, **5개 모두 내용이 완전히 동일**(코드 0~44, 58, -500)하다. 원문 cross-check 완료. 한 번만 작성한다. **Start Batch에는 별도 Error Responses 표가 없다**(Fail Response 예제로만 에러 형태 제시).
>
> NOTE: 코드 **45~57은 원문 표에 존재하지 않는다**(44 다음 바로 58). fabricate 없이 원문 그대로다.

| Code | Name | Message |
|---|---|---|
| 0 | NONE | `<Service Appointment ID#>`: Success. |
| 1 | UNSUPPORTED_VERSION | Ask your admin to check the API version, then try again. |
| 2 | SA_PAYLOAD_SHOULD_CONTAIN_ADD_ACTIONS_ONLY | Create bundles using add actions only. |
| 3 | EMPTY_BUNDLE_POLICY | Enter an ID for the bundlePolicyId. |
| 4 | EMPTY_BUNDLE_INITIATE | Specify manual or auto for the initiate entry. |
| 5 | EMPTY_BUNDLE_SERVICE_APPOINTMENT | Add a bundle service appointment. |
| 6 | SA_PAYLOAD_DUPLICATED_SAS | Remove duplicate service appointment IDs. |
| 7 | SA_IS_BUNDLE | `<Service Appointment ID#>`: Is already a bundle service appointment. |
| 8 | SA_ALREADY_BUNDLED | `<Service Appointment ID#>`: Is a bundle member service appointment in another bundle. |
| 9 | STATUS_FORBIDDEN | `<Service Appointment ID#>`: Can't be bundled in the current status. |
| 10 | SA_PAYLOAD_SHOULD_NOT_CONTAIN_MIX_ACTIONS | Send separate requests for add and remove actions. |
| 11 | SA_IS_NOT_BUNDLE | Select a bundle service appointment and try again. |
| 12 | EXCEEDED_BUNDLE_MEMBERS_LIMIT | You reached the maximum number of service appointments for this bundle. Remove some of them and try again. |
| 13 | SA_PAYLOAD_SHOULD_CONTAIN_ONLY_BUNDLE_MEMBERS | To remove bundle members from a bundle, include only service appointments that are bundle members. |
| 14 | ERROR_IN_BASIC_VALIDATIONS | We couldn't bundle the service appointments. |
| 15 | ERROR_IN_LIMIT_VALIDATIONS | N/A |
| 16 | ERROR_IN_CRITERIA_VALIDATIONS | N/A |
| 17 | ERROR_IN_SERVICE_TERRITORY_VALIDATIONS | Confirm or revise the service territories of the selected service appointments. Or ask your admin for help. |
| 18 | ERROR_IN_RESTRICTION_VALIDATIONS | Confirm or revise the selected service appointments. Or ask your admin to check the restriction policies. |
| 19 | EXCEEDED_BUNDLE_DURATION_LIMIT | N/A |
| 20 | EMPTY_BODY | Fill in the request. |
| 21 | SA_IS_NOT_BUNDLED | `<Service Appointment ID#>`: Can't remove a service appointment that isn't in the bundle. |
| 22 | ERROR_IN_AGGREGATION | Confirm or revise the selected service appointments. Or ask your admin to check the aggregation policies. |
| 23 | ERROR_IN_PROPAGATION | Confirm or revise the selected service appointments. Or ask your admin to check the propagation policies. |
| 24 | GET_POLICY_FAILURE | Ask your admin to check the bundle policies, then try again. |
| 25 | GET_CONFIG_FAILURE | Ask your admin to check the bundle config, then try again. |
| 26 | GET_BUNDLE_INFO_FAILURE | Try again later. |
| 27 | ERROR_IN_LOGIC | We couldn't bundle the service appointments. |
| 28 | EMPTY_BUNDLE_MEMBERS | Add bundle member service appointments. |
| 29 | EMPTY_BUNDLE_PARENT_WORK_ORDER_ID | Add the work order ID for the bundle service appointment. |
| 30 | UNBUNDLE_REQUEST_ASSIGNED_RESOURCES_NOT_COMPATiBLE _[sic — 원문 소문자 i]_ | To unbundle a scheduled bundle, send assigned resources for each service appointment. |
| 31 | EMPTY_OLD_VALUES | To update a bundle, send the current values. |
| 32 | EMPTY_NEW_VALUES | To update a bundle, send the new values. |
| 33 | SA_PAYLOAD_SHOULD_CONTAIN_AT_LEAST_ONE_ADD_OR_REMOVE_ACTION | To update a bundle, send at least one add or remove action. |
| 34 | FORBIDDEN_FIELDS_IN_POLICY_OBJECT | Confirm or revise the selected service appointments. Or ask your admin to check the field names selected in the related policies. |
| 35 | EMPTY_SERVICE_TERRITORY | Add a Service Territory ID. |
| 36 | EMPTY_START_TIME | Add the interval's start time. |
| 37 | EMPTY_END_TIME | Add the interval's end time. |
| 38 | ERROR_IN_BUNDLE_POLICY_RFC | Confirm or revise the selected service appointments. Or ask your admin to check the recordset filter criteria in the bundle policy. |
| 39 | ERROR_IN_TIME_ZONE_VALIDATION | Select service appointments that are in the same time zone. Or ask your admin for help. |
| 40 | ERROR_IN_LOGIC_UNBUNDLE | We couldn't unbundle the service appointment. |
| 41 | ERROR_CREATING_BUNDLE | We couldn't bundle the service appointments. |
| 42 | ERROR_ADDING_TO_BUNDLE | We couldn't add the service appointment to the bundle. |
| 43 | ERROR_REMOVING_FROM_BUNDLE | We couldn't remove the service appointment from the bundle. |
| 44 | ERROR_UNBUNDLING | We couldn't unbundle the service appointment. |
| 58 | ERROR_IN_MSW_VALIDATIONS | We can't bundle service appointments with dependencies. Remove the dependencies and try again. |
| -500 | http error | Hmm… Something went wrong. Try again. |

---

### 4.1 Create Bundle

> 서비스 약속을 수동으로 번들 생성한다. SA ID와 manual bundling policy ID를 받는다. manual bundling policy는 번들링 규칙을 지정하며 manual bundling용으로 표시돼 있어야 한다. 이 리소스는 번들 서비스 약속의 ID를 반환한다. **Gov Cloud 미지원.**

| 항목 | 값 |
|---|---|
| **URI** | `<host>/bundleflow/api/v1.0/bundle` |
| **Format** | JSON |
| **HTTP Method** | POST |
| **Authentication / Headers** | 공통 사항 참조 |

**Request Body Properties**

| Field | Type | Description |
|---|---|---|
| user | String | Optional. 요청을 보내는 사용자 이름. |
| initiate | String | 번들 요청 타입. 유효 값: `manual` |
| bundlePolicyId | String | 번들링 규칙을 담은 관련 bundle policy의 ID. |
| saRequestPayloads | Array | 번들되는 서비스 약속들의 상세. |
| &nbsp;&nbsp;serviceAppointmentId | String | 번들될 서비스 약속의 ID. |
| &nbsp;&nbsp;action | String | 이 SA에 수행되는 번들링 동작. 유효 값: `add` |

**Example (Request)** — 서비스 약속 2개의 수동 번들 요청.

```json
{
      "user": "Misha1",
      "initiate": "manual",
      "bundlePolicyId": "7sTx00000000006EAA",
      "saRequestPayloads": [
          {
              "serviceAppointmentId": "08px000000NzbmsAAB",
              "action": "add"
          },
          {
              "serviceAppointmentId": "08pT300000006LLIAY",
              "action": "add"
          }
      ]
}
```

**Response Body Properties**

| Field | Type | Description |
|---|---|---|
| bundleId | String | 새 번들의 ID. 번들이 생성되지 않으면 null. |
| responsePayloads | Array | 번들된 객체들의 상세. |
| &nbsp;&nbsp;objectName | String | 객체 타입. Output: ServiceAppointment |
| &nbsp;&nbsp;objectId | String | 서비스 약속 ID. |
| &nbsp;&nbsp;action | String | 객체에 수행된 동작. |
| &nbsp;&nbsp;status | String | 이 객체가 올바르게 번들됐는지. Output: SUCCESS 또는 FAIL |
| &nbsp;&nbsp;messageCode | Number | SA 번들링의 성공/에러 코드. 0이면 성공. 에러 코드는 위 Error Responses 표 참조. |
| &nbsp;&nbsp;message | String | 객체 번들링의 성공/에러 메시지. |
| status | String | 요청 상태. Output: SUCCESS 또는 FAIL |
| messageCode | Number | 요청의 성공/에러 코드. 0이면 성공. 위 Error Responses 표 참조. |
| message | String | 요청의 성공/에러 메시지. |
| messageAdditionalInfo | String | Salesforce가 제공하는 추가 정보. |

**Example (Successful Response)** — 서비스 약속 2개가 성공적으로 번들된 출력.

```json
{
    "bundleId": "08px000000NzdH8AAJ",
    "responsePayloads": [
      {
        "objectName": "ServiceAppointment",
        "objectId": "08px000000NzbmsAAB",
        "action": "add",
        "status": "SUCCESS",
        "messageCode": "NONE",
        "message": "Success",
        "messageParams": [

        ]
      },
      {
        "objectName": "ServiceAppointment",
        "objectId": "08pT300000006LLIAY",
        "action": "add",
        "status": "SUCCESS",
        "messageCode": "NONE",
        "message": "Success",
        "messageParams": [

        ]
      }
    ],
    "status": "SUCCESS",
    "messageCode": "NONE",
    "message": "Success"
}
```

**Example (Fail Response)** — 이미 번들 서비스 약속인 SA를 번들하려 한 경우. SA는 두 번들에 속할 수 없으므로 status는 FAIL.

```json
{
     "bundleId":null,
     "responsePayloads":[
        {
           "objectName":"ServiceAppointment",
           "objectId":"08px000000NzdH8AAJ",
           "action":"add",
           "status":"FAIL",
           "messageCode":"SA_ALREADY_BUNDLED",
           "message":"Is already a bundle service appointment.",
           "messageParams":[

                ]
          }
     ],
     "status":"FAIL",
     "messageCode":"ERROR_CREATING_BUNDLE",
     "message":"We couldn't bundle the service appointment.",
     "messageAdditionalInfo": ""
}
```

**Code Sample from Apex (Create Bundle)** — 원본 가이드 발췌.

```apex
public static Map<String, String> createSABundle() {
    String apiVersion = '54.0'; // Spring '22
    String bundleApi = '/bundleflow/api/v1.0/bundle';
    String host = {Namespace}.BundleLogic.getBundlerFalconEnvironment();
    String ref = URL.getOrgDomainUrl().toExternalForm();

    String bundleService = host + bundleApi;

    // Create HTTP request
    HttpRequest request = new HttpRequest();
    request.setEndpoint(bundleService);
    request.setMethod('POST');
    request.setHeader('sf_api_version', apiVersion);
    request.setHeader('Content-Type', 'application/json' );
    // NOTE: This user must have 'Field Service Integration' permissions.
    request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
    request.setHeader('Referer', ref);
    request.setHeader('x-sfdc-tenant-id', 'core/prod/ORG-ID_18_Characters');
    request.setTimeout(120000);

    // Create the body
    Map<String, Object> body = new Map<String, Object>();
    body.put('initiate','manual');
    body.put('bundlePolicyId','7sT9A0000004DX6UAM'); // NOTE: Use a real bundle policy ID.

    Map<String, Object> saList = new Map<String, Object>();
    saList.put('serviceAppointmentId', '08p9A0000005LEGQA2'); // NOTE: Use a real Service Appointment ID.
    saList.put('action', 'add');

    List<Object> objectsList =     new List<Object>();
    objectsList.add(saList);

    body.put('saRequestPayloads', objectsList);

    String reqBody = JSON.serialize(body);
    System.debug(body);
    request.setBody(reqBody);

    HttpResponse response = new Http().send(request);

    // Parse the JSON response

    // Handle a redirect message
    while (response.getStatusCode() == 302) {
        request.setEndpoint(response.getHeader('Location'));
        response = new Http().send(request);
    }

    Map<String, String> returnValue = new Map<String, String>();
    returnValue.put('statusCode', String.valueOf(response.getStatusCode()));

    // Return value when we don't get a success response
    if (response.getStatusCode() != 200) {
        returnValue.put('message', 'The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
        System.debug(returnValue.get('message'));
        return (returnValue);

    // Return value when we do get a success response
    } else {
        returnValue.put('message', response.getBody());
        System.debug(response.getBody());
        return (returnValue);
    }
}

Map<String, String> response = createSABundle();
System.debug(response);
```

---

### 4.2 Remove Bundle Members

> 기존 번들에서 하나 이상의 서비스 약속을 제거한다. SA ID를 받는다. **Gov Cloud 미지원.** Salesforce API 버전 **54.0 이상**.

| 항목 | 값 |
|---|---|
| **URI** | `<host>/bundleflow/api/v1.0/bundle/remove` |
| **Format** | JSON |
| **HTTP Method** | PATCH |
| **Authentication / Headers** | 공통 사항 참조 |

**Request Body Properties**

| Field | Type | Description |
|---|---|---|
| user | String | Optional. 요청을 보내는 사용자 이름. |
| initiate | String | 번들 요청 타입. 유효 값: `manual` |
| saRequestPayloads | Array | 번들에서 제거될 서비스 약속들의 상세. |
| &nbsp;&nbsp;serviceAppointmentId | String | 서비스 약속 ID. |
| &nbsp;&nbsp;action | String | 이 SA에 수행되는 번들링 동작. 유효 값: `remove` |

**Example (Request)** — 번들에서 SA 2개를 제거하는 수동 요청.

```json
{
    "user":"Misha",
    "initiate":"manual",
    "saRequestPayloads":[
       {
          "serviceAppointmentId":"08px000000NzbmkAAB",
          "action":"remove"
       },
       {
          "serviceAppointmentId":"08pT300000006LLIAY",
          "action":"remove"
       }
    ]
}
```

**Response Body Properties**

| Field | Type | Description |
|---|---|---|
| bundleId | String | 업데이트할 번들 ID. 업데이트가 성공하지 못하면 null. |
| responsePayloads | Array | 번들 요청에 포함된 서비스 약속 객체들의 상세. |
| &nbsp;&nbsp;objectName | String | 객체 타입. Output: ServiceAppointment |
| &nbsp;&nbsp;objectId | String | 서비스 약속 ID. |
| &nbsp;&nbsp;action | String | 이 SA에 수행된 번들링 동작. 유효 값: `remove` |
| &nbsp;&nbsp;status | String | SA 업데이트 상태. Output: SUCCESS 또는 FAIL |
| &nbsp;&nbsp;messageCode | Number | SA 업데이트의 성공/에러 코드. 0이면 성공. 위 Error Responses 표 참조. |
| &nbsp;&nbsp;message | String | SA 업데이트의 성공/에러 메시지. |
| status | String | 요청 상태. Output: SUCCESS 또는 FAIL |
| messageCode | Number | 요청의 성공/에러 코드. 0이면 성공. 위 Error Responses 표 참조. |
| message | String | 요청의 성공/에러 메시지. |
| messageAddionalInfo _[sic — 원문 오타, "Additional"의 d 누락]_ | String | Salesforce가 제공하는 추가 정보. |

**Example (Successful Response)** — 번들에서 SA 제거 성공.

```json
{
      "bundleId": "08px000000OAkUXAA1",
      "responsePayloads": [
          {
              "objectName": "ServiceAppointment",
              "objectId": "08px000000OAjPRAA1",
              "action": "remove",
              "status": "SUCCESS",
              "messageCode": "NONE",
              "message": "Success",
              "messageParams": []
      }
  ],
  "status": "SUCCESS",
  "messageCode": "NONE",
  "message": "Success"
}
```

**Example (Fail Response)** — 잘못된 SA ID 입력. (원문에서 `"message"` 줄 끝 콤마 누락 _[sic]_ — 원문대로 보존)

```json
{
      "bundleId": null,
      "responsePayloads": [
          {
              "status": "FAIL",
              "messageCode": "GET_BUNDLE_INFO_FAILURE",
              "message": "Try again later.",
              "messageParams": []
          }
      ],
      "status": "FAIL",
      "messageCode": "ERROR_REMOVING_FROM_BUNDLE",
      "message": "We couldn't remove the service appointment from the bundle."
     "messageAdditionalInfo": ""
}
```

> Error Responses: 위 공통 Error Responses 표(Table 2 = Table 1과 동일)를 따른다.

---

### 4.3 Start Batch

> 자동 번들링용으로 표시된 appointment bundle policy를 사용해 SA 번들을 **자동 생성**한다. 이미 수동으로 번들된 SA는 이 API의 영향을 받지 않는다. 자동 번들링 배치 프로세스 시작의 성공/실패 메시지를 반환한다. **Gov Cloud 미지원.** Salesforce API 버전 **54.0 이상**.

| 항목 | 값 |
|---|---|
| **URI** | `<host>/bundleflow/api/v1.0/startbatch` |
| **Format** | JSON |
| **HTTP Method** | POST |
| **Authentication / Headers** | 공통 사항 참조 |

**Request Body Properties**

| Field | Type | Description |
|---|---|---|
| operation | String | 번들링 operation. 유효 값: `start-batch-processing` |

**Example (Request)** — 서비스 약속의 자동 번들링 요청.

```json
{
     "operation": "start-batch-processing"
}
```

**Response Body Properties**

| Field | Type | Description |
|---|---|---|
| httpStatus | Number | 응답 HTTP status. |
| statusDescription | String | 응답 상태 설명. |
| responsePayload | String | 배치 상태 메시지. 성공하면 payload는 null. 배치 번들링 실패 시 payload는 에러 메시지(예: "Wrong API version", "Failed to start batch agent")를 보여줌. |
| messageCode | Number | Message code는 **항상 0**. |
| messageAdditionalInfo | String | Salesforce가 제공하는 추가 정보. |

**Example (Successful Response)** — 배치 프로세스 시작 성공. (원문에 닫는 중괄호가 하나 더 있음 _[sic]_ — `"messageCode":"NONE"}` 뒤 `}` — 원문대로 보존)

```json
{
    "httpStatus":200,
    "statusDescription":null,
    "responsePayload":null,
    "messageCode":"NONE"}
}
```

**Example (Fail Response)** — 요청의 operation 파라미터가 null이거나 비어 있어 배치 시작 실패. (`"messageCode":"NONE"` 뒤 콤마 누락 _[sic]_)

```json
{
     "httpStatus":400,
     "statusDescription":null,
     "responsePayload":"Failed to start batch agent",
     "messageCode":"NONE"
     "messageAdditionalInfo": ""
}
```

> NOTE: Start Batch에는 **별도 Error Responses 표가 없다**(원문에 없음). 위 Fail Response 예제로만 에러 형태를 제시한다.

---

### 4.4 Unbundle

> 하나의 서비스 약속 번들을 언번들한다. bundle ID를 받는다. **Gov Cloud 미지원.** Salesforce API 버전 **54.0 이상**.

| 항목 | 값 |
|---|---|
| **URI** | `<host>/bundleflow/api/v1.0/bundle/<ID>?initiate=manual` |
| **Format** | JSON |
| **HTTP Method** | DELETE |
| **Authentication / Headers** | 공통 사항 참조 |

**Parameters**

| Parameter | Description |
|---|---|
| ID | 번들의 고유 ID. |

**Response Body Properties**

| Field | Type | Description |
|---|---|---|
| bundleId | String | 번들 ID. 언번들 실패 시 null. |
| responsePayloads | Array | 서비스 약속 언번들 응답 상세. 성공하면 payload는 null. 실패하면 에러 상세를 보여줌. |
| &nbsp;&nbsp;status | String | SA 언번들 상태. Output: FAIL |
| &nbsp;&nbsp;messageCode | Number | 에러 코드. 위 Error Responses 표 참조. |
| &nbsp;&nbsp;message | String | 에러 메시지. |
| status | String | 요청 상태. Output: SUCCESS 또는 FAIL |
| messageCode | Number | 요청의 성공/에러 코드. 0이면 성공. 위 Error Responses 표 참조. |
| message | String | 요청의 성공/에러 메시지. |
| messageAdditionalInfo | String | Salesforce가 제공하는 추가 정보. |

**Example (Successful Response)** — 서비스 약속 언번들 성공.

```json
{
    "bundleId":"08px000000NzdMXAAZ",
    "responsePayloads":null,
    "status":"SUCCESS",
    "messageCode":"NONE",
    "message":"Success"
}
```

**Example (Fail Response)** — bundle ID 대신 SA ID를 입력. 요청은 bundle ID로만 동작하므로 status는 FAIL.

```json
{
     "bundleId":null,
     "responsePayloads":[
        {
           "status":"FAIL",
           "messageCode":"GET_BUNDLE_INFO_FAILURE",
          "message":"Replace the service appointment with a bundle service appointment.",
             "messageParams":[

             ]
         }
     ],
     "status":"FAIL",
     "messageCode":"ERROR_UNBUNDLING",
     "message":"We couldn't unbundle the service appointment.",
     "messageAdditionalInfo": ""
}
```

> Error Responses: 위 공통 Error Responses 표(Table 3 = Table 1과 동일)를 따른다.

---

### 4.5 Unbundle Multiple

> 하나 이상의 서비스 약속 번들을 언번들한다. 하나 이상의 bundle ID를 받는다. **Gov Cloud 미지원.** Salesforce API 버전 **54.0 이상**.

| 항목 | 값 |
|---|---|
| **URI** | `<host>/bundleflow/api/v1.0/unbundleMultiple` |
| **Format** | JSON |
| **HTTP Method** | POST |
| **Authentication / Headers** | 공통 사항 참조 |

**Request Body Properties**

| Field | Type | Description |
|---|---|---|
| user | String | Optional. 요청을 보내는 사용자 이름. |
| initiate | String | 번들 요청 타입. 유효 값: `manual` |
| saRequestPayloads | Array | 언번들할 번들 서비스 약속들의 ID. |
| &nbsp;&nbsp;serviceAppointmentId | String | 번들 서비스 약속의 ID. |

**Example (Request)** — 번들 2개를 언번들하는 요청.

```json
{
     "user":"Misha",
     "initiate":"manual",
     "saRequestPayloads":[
        {
           "serviceAppointmentId":"08px000000NzdLFAAZ"
        },
        {
           "serviceAppointmentId":"08px000000NzdH8AAJ"
        }
     ]
}
```

**Response Body Properties** — 응답 바디는 객체 배열이며 각 객체는 언번들 요청한 번들 SA의 응답 상세를 담는다.

| Field | Type | Description |
|---|---|---|
| headers | Object | 향후 사용 예정. |
| body | Object | 서비스 약속 번들 언번들 상세. |
| &nbsp;&nbsp;bundle id _[sic — 원문 표기 "bundle id" 공백 포함; JSON 키는 bundleId]_ | String | 언번들된 번들의 ID. 언번들 실패 시 null. |
| &nbsp;&nbsp;responsePayloads | Array | SA 언번들 응답 상세. 성공하면 null. 실패하면 에러 상세를 보여줌. |
| &nbsp;&nbsp;&nbsp;&nbsp;status | String | SA 언번들 실패 상태. Output: FAIL |
| &nbsp;&nbsp;&nbsp;&nbsp;messageCode | Number | 에러 코드. 위 Error Responses 표 참조. |
| &nbsp;&nbsp;&nbsp;&nbsp;message | String | 에러 메시지. |
| &nbsp;&nbsp;status | String | SA 언번들 상태. Output: SUCCESS 또는 FAIL |
| &nbsp;&nbsp;messageCode | Number | 번들 언번들의 성공/에러 코드. 0이면 성공. 위 Error Responses 표 참조. |
| &nbsp;&nbsp;message | String | 번들 언번들의 성공/에러 메시지. |
| statusCode | String | 요청의 성공/에러 코드. |
| statusCodeValue | Number | 요청의 성공/에러 코드 번호. 0이면 성공. 위 Error Responses 표 참조. |

**Example (Successful Response)** — 번들 2개 언번들 성공. (참고: `responsePayload`가 escape된 JSON 문자열로 들어 있음 — 원문대로 보존)

```json
{
    "httpStatus": 200,
    "statusDescription": "OK",
    "responsePayload": "[ {\n \"headers\" : { },\n \"body\" : {\n      \"bundleId\" : \"08px000000OAph4AAD\",\n    \"responsePayloads\" : null,\n    \"status\" : \"SUCCESS\",\n    \"messageCode\" : \"NONE\",\n    \"message\" : \"Success\"\n },\n \"statusCode\" : \"OK\",\n \"statusCodeValue\" : 200\n} ]",
    "messageCode": "NONE"
}
```

**Example (Fail Response)** — bundle ID 대신 SA ID 입력. 요청은 bundle ID로만 동작하므로 status는 FAIL. (참고: 바깥 배열 `[`로 시작하나 닫는 `]` 없이 끝나고, `"messageCode": "NONE"` 뒤 콤마 누락 _[sic]_. 원문대로 보존)

```json
[
    {
    "httpStatus": 200,
    "statusDescription": "OK",
    "responsePayload": "[ {\n \"headers\" : { },\n \"body\" : {\n          \"bundleId\" : null,\n     \"responsePayloads\" : [ {\n       \"status\" : \"FAIL\",\n \"messageCode\" : \"GET_BUNDLE_INFO_FAILURE\",\n         \"message\" : \"Try again later.\",\n       \"messageParams\" : [ ]\n     } ],\n     \"status\" : \"FAIL\",\n \"messageCode\" : \"ERROR_UNBUNDLING\",\n      \"message\" : \"We couldn't unbundle the service appointment.\",\n    \"messageAdditionalInfo\" : \"(bundleSaRef)\\n errorCode: NOT_FOUND\\n message:    Provided external ID field does not exist or is not accessible: 123\"\n },\n \"statusCode\" : \"OK\",\n \"statusCodeValue\" : 200\n} ]",
    "messageCode": "NONE"
    "messageAdditionalInfo": "(bundleSaRef)\n errorCode: NOT_FOUND\n message: Provided external ID field does not exist or is not accessible: 123"
}
```

> Error Responses: 위 공통 Error Responses 표(Table 4 = Table 1과 동일)를 따른다.

---

### 4.6 Update Bundle

> 기존 번들에 서비스 약속을 추가한다. bundle ID와 SA ID를 받는다. **Gov Cloud 미지원.** Salesforce API 버전 **54.0 이상**.

| 항목 | 값 |
|---|---|
| **URI** | `<host>/bundleflow/api/v1.0/bundle/{ID}` |
| **Format** | JSON |
| **HTTP Method** | PATCH |
| **Authentication / Headers** | 공통 사항 참조 |

**Parameters**

| Parameter | Description |
|---|---|
| ID | 번들의 고유 ID. |

**Request Body Properties**

| Field | Type | Description |
|---|---|---|
| user | String | Optional. 요청을 보내는 사용자 이름. |
| initiate | String | 번들 요청 타입. 유효 값: `manual` |
| saRequestPayloads | Array | 이 번들에 추가될 서비스 약속들의 상세. |
| &nbsp;&nbsp;serviceAppointmentId | String | 서비스 약속 ID. |
| &nbsp;&nbsp;action | String | 이 SA에 수행되는 번들링 동작. 유효 값: `add` |

**Example (Request)** — 번들에 SA 2개를 추가하는 수동 요청.

```json
{
    "user":"Misha",
    "initiate":"manual",
    "saRequestPayloads":[
       {
          "serviceAppointmentId":"08px000000NzbmkAAB",
          "action":"add"
       },
       {
          "serviceAppointmentId":"08pT300000006LLIAY",
          "action":"add"
       }
    ]
}
```

**Response Body Properties**

| Field | Type | Description |
|---|---|---|
| bundleId | String | 업데이트할 번들 ID. 업데이트가 성공하지 못하면 null. |
| responsePayloads | Array | 번들 요청에 포함된 서비스 약속 객체들의 상세. |
| &nbsp;&nbsp;objectName | String | 객체 타입. Output: ServiceAppointment |
| &nbsp;&nbsp;objectId | String | 서비스 약속 ID. |
| &nbsp;&nbsp;action | String | 이 SA에 수행된 번들링 동작. 유효 값: `add` |
| &nbsp;&nbsp;status | String | SA 업데이트 상태. Output: SUCCESS 또는 FAIL |
| &nbsp;&nbsp;messageCode | Number | SA 업데이트의 성공/에러 코드. 0이면 성공. 위 Error Responses 표 참조. |
| &nbsp;&nbsp;message | String | SA 업데이트의 성공/에러 메시지. |
| status | String | 요청 상태. Output: SUCCESS 또는 FAIL |
| messageCode | Number | 요청의 성공/에러 코드. 0이면 성공. 위 Error Responses 표 참조. |
| message | String | 요청의 성공/에러 메시지. |
| messageAdditionalInfo | String | Salesforce가 제공하는 추가 정보. |

**Example (Successful Response)** — 번들에 SA 추가 성공.

```json
{
      "bundleId": "08px000000OAkUXAA1",
      "responsePayloads": [
          {
              "objectName": "ServiceAppointment",
              "objectId": "08px000000OAjPRAA1",
              "action": "add",
              "status": "SUCCESS",
              "messageCode": "NONE",
              "message": "Success",
              "messageParams": []
          }
      ],
      "status": "SUCCESS",
      "messageCode": "NONE",
      "message": "Success"
}
```

**Example (Fail Response)** — 잘못된 SA ID 입력. (참고: 원문에 `"bundleId": *null*` 처럼 별표가 붙어 있음 _[sic — 원문 표기 그대로]_. `"message"` 뒤 콤마 누락 _[sic]_)

```json
{
      "bundleId": *null*,
      "responsePayloads": [
          {
              "status": "FAIL",
              "messageCode": "GET_BUNDLE_INFO_FAILURE",
              "message": "Try again later.",
              "messageParams": []
          }
      ],
      "status": "FAIL",
      "messageCode": "ERROR_ADDING_TO_BUNDLE",
      "message": "We couldn't add the service appointment to the bundle.",
     "messageAdditionalInfo": ""
}
```

> Error Responses: 위 공통 Error Responses 표(Table 5 = Table 1과 동일, 물리 p546~548에 걸쳐 분할 출력; 끝까지 -500 확인됨)를 따른다.

---

## 관련 노트

- [[Field Service 개요와 데이터 모델]] — Field Service 데이터 모델·오브젝트 관계(ServiceAppointment·WorkOrder·WorkOrderLineItem 등)
- [[REST API]] — 일반 sObject CRUD·SOQL·Composite 등 표준 Salesforce REST API
- [[객체 레퍼런스 — Appointment Bundling]] — ApptBundlePolicy·ApptBundleConfig 등 번들링 8객체 89필드 전수
