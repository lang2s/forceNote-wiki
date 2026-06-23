---
tags: [field-service, fsl, metadata-api, tooling-api, 현장서비스, FieldServiceSettings, Skill, TimeSheetTemplate, CleanRule]
source: field_service_dev.pdf (Field Service Developer Guide v67.0 Summer '26)
created: 2026-06-23
aliases: [FieldServiceSettings, CleanRule, TimeSheetTemplate, FS Metadata API, FS Tooling API, Field Service Metadata API, Field Service Tooling API, Skill metadata, ObjectMappingItem, ObjectMapping, ObjectMappingField, Field Service 메타데이터, Field Service 툴링 API]
---

# Field Service Metadata·Tooling API

> Field Service에서 사용하는 Metadata API 타입(FieldServiceSettings · Skill · TimeSheetTemplate)과 Tooling API 오브젝트(CleanRule · TimeSheetTemplate)의 전체 필드·타입·enum 레퍼런스. 동명 타입 `TimeSheetTemplate`이 Metadata와 Tooling 양쪽에 존재하므로(필드 구성·대소문자·레이아웃이 다름) 반드시 구분해서 사용한다.

---

# 1. Field Service Metadata API

> "The following Metadata types are used in Field Service."
> 포함 타입: **FieldServiceSettings**, **Skill**, **TimeSheetTemplate**

---

## 1.1 FieldServiceSettings

**설명:** 조직의 Field Service 설정(Represents an organization's Field Service settings)을 나타낸다.

- 패키지 manifest에서는 모든 organization settings 메타데이터 타입을 `Settings` 이름으로 접근한다. ("In the package manifest, all organization settings metadata types are accessed using the Settings name.")
- Field Service 설정 활성화는 Salesforce Help의 *Enable Field Service* 참조.

**Version:** API version **40.0** 이상에서 사용 가능.

**Fields (전수, 알파벳순 — Field / Field Type / Description):**

| Field | Field Type | Description |
|---|---|---|
| apptAssistantExpiration | int | `apptAssistantInfoUrl`의 만료 시간. 만료 후 고객은 모바일 워커의 위치·예상 도착 시각을 더 이상 볼 수 없다. API version 50.0 이상. |
| apptAssistantInfoUrl | string | 고객이 모바일 워커의 예상 도착 시각·추적 정보를 볼 수 있게 돕는 추적 URL. API version 50.0 이상. |
| apptAssistantRadiusUnitValue | ApptAssistantRadiusUnit (enumeration of type string) | geofence 반경 단위. 모바일 워커가 이 영역에 진입하면 Last Mile 알림이 자동 전송된다. 유효 값: • Kilometer • Meter • Mile • Yard. API version 50.0 이상. |
| apptAssistantRadiusValue | int | 서비스 약속 주소를 기준으로 한 geofence 반경. 모바일 워커가 주소에 접근할 때 고객에게 알림을 보내는 데 사용. API version 50.0 이상. |
| apptAssistantStatus | string | En Route 알림을 트리거하는 데 사용되는 서비스 약속의 상태. 값은 서비스 약속의 Status 필드 옵션 중 하나와 일치해야 한다. 모바일 워커가 이 상태를 선택하면 고객은 추적 정보가 포함된 En Route 알림을 받는다. API version 50.0 이상. |
| canceledDefaultStatus | string | 서비스 약속이 취소될 때의 기본 상태 값. API version 65.0 이상. |
| cannotCompleteDefaultStatus | string | 서비스 약속을 완료할 수 없을 때의 기본 상태 값. API version 65.0 이상. |
| canPopulateGoogleAddress | boolean | 데스크톱·모바일이 Google·Apple에 geolocation 및 지도 데이터를 전송하도록 허용한다. API version 57.0 이상. |
| canSendAppCenterCrashReports | boolean | Salesforce가 Microsoft App Center에 crash report를 전송하도록 허용한다. API version 57.0 이상. |
| canStoreMobileAnalytics | boolean | 서드파티가 모바일 analytics를 저장하도록 허용한다. API version 57.0 이상. |
| completedDefaultStatus | string | 서비스 약속이 완료될 때의 기본 상태 값. API version 65.0 이상. |
| deepLinkPublicSecurityKey | string | Field Service 모바일 앱에서 deep link action에 접근하는 사용자에게 public security key를 제공한다. deep link URL을 security key로 구성하면 redirection warning을 숨기며, deep link URL이 보안 검사를 처리한다. API version 54.0 이상. |
| dispatchedDefaultStatus | string | 서비스 약속이 dispatch될 때의 기본 상태 값. API version 65.0 이상. |
| doesAllowEditSaForCrew | boolean | 서비스 crew 멤버가 자신의 서비스 약속을 편집하도록 허용한다. 이 설정은 `doesShareSaWithAr`가 선택된 경우에만 적용된다. Crew 타입의 할당 리소스의 경우 crew 멤버는 서비스 약속에 대한 Read-Write 접근을 얻으며, `doesShareSaParentWoWithAr`가 선택되면 서비스 약속의 상위 work order에도 접근한다. |
| doesShareSaParentWoWithAr | boolean | 서비스 약속의 상위 work order를 할당 리소스와 공유한다. `doesShareSaWithAr`가 선택되고 work order의 sharing access가 Private 또는 Public Read Only로 설정된 경우에만 적용된다. Technician 할당 리소스는 work order에 대한 Read-Write 접근을 얻는다. Crew 타입의 경우 crew leader는 Read-Write, crew 멤버는 Read 접근을 얻는다. 서비스 약속의 상위가 work order line item이면 할당 리소스는 연관 work order에 접근한다. |
| doesShareSaWithAr | boolean | dispatch된 서비스 약속을 할당 리소스와 공유한다. 서비스 약속의 sharing access가 Private 또는 Public Read Only로 설정된 경우에만 적용된다. Technician 할당 리소스는 Read-Write 접근을 얻는다. Crew 타입의 경우 crew leader는 Read-Write, crew 멤버는 Read 접근을 얻는다. |
| enableDocumentBuilder | boolean | Document Builder 기능 접근을 활성화한다. |
| enableFloatingWorkOrder | boolean | 조직의 floating work order를 활성화한다. 이전 work order의 완료를 기준으로 한 floating recurrence cadence로 work order를 생성할 수 있게 한다. |
| enableLsdkMode | boolean | Field Service 모바일 앱에서 Lightning SDK를 활성화한다. |
| enablePopulateWorkOrderAddress | boolean | maintenance plan에서 work order가 생성될 때 주소가 채워지도록 허용한다. |
| enableStandbyMode | boolean | Field Service 모바일 앱에서 standby mode를 켠다. 활성화 시 활동하지 않을 때 알림을 일시 중지하고 데이터 동기화를 비활성화하여 모바일 워커가 배터리를 절약하고 방해를 줄이도록 돕는다. |
| enableWorkOrders | boolean | 조직의 Work Orders를 활성화한다. Field Service 활성화 여부와 무관하게 Work Order 오브젝트를 사용할 수 있게 한다. Field Service가 활성화되면 Work Orders를 끌 수 없다. |
| enableWorkPlansAutoGeneration | boolean | work order 또는 work order line item이 새로 생성될 때 work plan과 그 work step이 자동 생성되도록 허용한다. 생성될 구체적 work plan·work step은 Work Plan Selection Rules에 지정된 matching criteria에 따른다. API version 52.0 이상. |
| enableWorkStepManualStatusUpdate | boolean | work step 상태를 수동 업데이트하도록 허용한다. 프롬프트가 상태 업데이트를 제안하며 사용자는 수락 또는 보류할 수 있다. |
| fieldServiceNotificationsOrgPref | boolean | Salesforce 모바일 앱·Lightning Experience 사용자에 대한 in-app 알림을 켠다. 사용자가 소유하거나 팔로우하는 work order/work order line item에서 다음 중 하나가 발생할 때 알림이 전송된다: • text 또는 file post 추가 • tracked field 업데이트 • record owner 변경 • 관련 서비스 약속의 리소스 할당 변경. work order의 feed tracking 설정에서 모든 관련 오브젝트 추적 옵션이 선택되면 work order의 자식 레코드(예: 서비스 약속) 생성·삭제 시에도 알림을 받는다. |
| fieldServiceOrgPref | boolean | Field Service 활성화 여부를 나타낸다. |
| inProgressDefaultStatus | string | 서비스 약속이 in progress일 때의 기본 상태 값. API version 65.0 이상. |
| isGeoCodeSyncEnabled | boolean | Service Resource의 위치를 Inventory 오브젝트로 동기화한다. |
| isLocationHistoryEnabled | boolean | Service Resource의 위치 이력을 추적한다. |
| mobileFeedbackEmails | string | 사용자가 Field Service 모바일 앱에서 피드백을 남길 때 피드백 이메일이 전송될 이메일 주소를 저장한다. API version 54.0 이상. |
| noneDefaultStatus | string | 서비스 약속에 특정 상태가 없을 때의 기본 상태 값. API version 65.0 이상. |
| o2EngineEnabled | boolean | Field Service Enhanced Scheduling and Optimization을 활성화한다. 기본값은 false. API version 55.0 이상. |
| objectMappingItem | ObjectMappingItem (§1.1.1) | Work Plan 또는 Work Step 생성을 위한 조직의 custom field mapping을 나타낸다. Custom Field는 WorkPlanTemplate→WorkPlan, WorkStepTemplate→WorkStep, 또는 WorkPlanTemplateEntry→WorkStep으로 매핑할 수 있다. API version 52.0 이상. |
| optimizationServiceAccess | boolean | optimization service가 Salesforce 조직의 데이터에 접근하도록 허용한다. |
| overrideDefaultLwcStyling | boolean | Field Service 모바일 앱이 기본 Lightning Web Component(LWC) 스타일을 custom·branded 스타일로 override하도록 허용한다. 활성화 시 모바일 앱 내 LWC에 custom 스타일링 구성(brand color·theme·visual element 등)을 적용한다. |
| scheduledDefaultStatus | string | 서비스 약속이 scheduled일 때의 기본 상태 값. API version 65.0 이상. |
| serviceAppointmentsDueDateOffsetOrgValue | int | 자동 생성되는 서비스 약속의 Due Date가 Created Date로부터 며칠 뒤가 되어야 하는지를 나타낸다. Work type에는 해당 work type을 사용하는 새 work order·work order line item에 서비스 약속을 자동 추가하는 옵션이 있다. |
| workOrderDurationSource | WorkOrderDurationSource (enumeration of type string) | work order duration 값의 소스. 가능한 값: • WorkType • TotalFromWorkPlan • Custom. API version 55.0 이상. |
| workOrderLineItemSearchFields | string | 검색 엔진이 work order line item에서 knowledge article을 제안하기 위해 스캔할 work order line item 필드. |
| workOrderSearchFields | string | 검색 엔진이 work order에서 knowledge article을 제안하기 위해 스캔할 work order 필드. |

### 1.1.1 ObjectMappingItem (서브타입)

**설명:** Work Plan 또는 Work Step 생성을 위한 조직의 custom field mapping을 나타낸다. Custom Field는 WorkPlanTemplate→WorkPlan, WorkStepTemplate→WorkStep, 또는 WorkPlanTemplateEntry→WorkStep으로 매핑할 수 있다. API version 52.0 이상.

| Field Name | Field Type | Description |
|---|---|---|
| mappingType | string | object mapping의 타입. 유효 값: • WorkPlans_WorkPlanTemplate_WorkPlan — WorkPlanTemplate을 WorkPlan에 매핑 • WorkPlans_WorkStepTemplate_WorkStep — WorkStepTemplate을 WorkStep에 매핑 • WorkPlans_WorkPlanTemplateEntry_WorkStep — WorkPlanTemplateEntry를 WorkStep에 매핑 |
| objectMapping | ObjectMapping (§1.1.2) | object mapping 상세. |

### 1.1.2 ObjectMapping (서브타입)

**설명:** input 오브젝트의 필드를 output 오브젝트의 필드로 매핑한 map을 나타낸다.

| Field Name | Field Type | Description |
|---|---|---|
| inputObject | string | **Required.** 매핑의 source 필드를 포함하는 오브젝트 타입 이름. 유효 값: • WorkPlanTemplate • WorkStepTemplate • WorkPlanTemplateEntry |
| mappingFields | [ObjectMappingField (§1.1.3)] | **Required.** source 오브젝트 필드를 target 오브젝트 필드로의 매핑. |
| outputObject | string | **Required.** source 필드로부터 데이터를 받는 오브젝트 타입 이름. 유효 값: • WorkPlan • WorkStep |

### 1.1.3 ObjectMappingField (서브타입)

**설명:** input 오브젝트의 필드 이름과 그에 대응하는 output 오브젝트의 필드 이름.

| Field Name | Field Type | Description |
|---|---|---|
| inputField | string | **Required.** source 데이터를 공급하는 custom field 이름. `inputObject`에 지정된 오브젝트의 필드다. |
| outputField | string | **Required.** `inputField`에 지정된 source 필드로부터 데이터를 받는 custom field 이름. `outputObject`에 지정된 오브젝트의 필드다. |

### 1.1.4 Declarative Metadata Sample Definition (FieldServiceSettings)

> "This sample file shows a subset of the possible field service settings that you can customize."

> ⚠️ **[sic] — 원문 오타 보존:** 아래 XML의 `WokStepTemplate_...`, `WokStep_...`(예: `WokStep_CustomNumberField__c`, `WokStep_CustomDateField__c`)은 'r'이 빠진 **PDF 원문 오타 그대로**다(정상 철자는 WorkStep). 그대로 인용한다.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<FieldServiceSettings xmlns="http://soap.sforce.com/2006/04/metadata">
   <doesAllowEditSaForCrew>false</doesAllowEditSaForCrew>
   <doesShareSaParentWoWithAr>false</doesShareSaParentWoWithAr>
   <doesShareSaWithAr>false</doesShareSaWithAr>
   <enableWorkOrders>false</enableWorkOrders>
   <enableWorkPlansAutoGeneration>true</enableWorkPlansAutoGeneration>
   <fieldServiceNotificationsOrgPref>false</fieldServiceNotificationsOrgPref>
   <fieldServiceOrgPref>true</fieldServiceOrgPref>
   <isGeoCodeSyncEnabled>false</isGeoCodeSyncEnabled>
   <isLocationHistoryEnabled>false</isLocationHistoryEnabled>
   <o2EngineEnabled>false</o2EngineEnabled>
   <objectMappingItem>
      <mappingType>WorkPlans_WorkPlanTemplate_WorkPlan</mappingType>
      <objectMapping>
         <inputObject>WorkPlanTemplate</inputObject>
         <mappingFields>
            <inputField>WorkPlanTemplate_CustomNumberField__c</inputField>
            <outputField>WorkPlan_CustomNumberField__c</outputField>
         </mappingFields>
         <mappingFields>
            <inputField>WorkPlanTemplate_CustomTextField__c</inputField>
            <outputField>WorkPlan_CustomPicklistField__c</outputField>
         </mappingFields>
         <outputObject>WorkPlan</outputObject>
      </objectMapping>
   </objectMappingItem>
   <objectMappingItem>
      <mappingType>WorkPlans_WorkStepTemplate_WorkStep</mappingType>
      <objectMapping>
         <inputObject>WorkStepTemplate</inputObject>
         <mappingFields>
            <inputField>WokStepTemplate_CustomNumberField__c</inputField>
            <outputField>WokStep_CustomNumberField__c</outputField>
         </mappingFields>
         <mappingFields>
            <inputField>WokStepTemplate_CustomTextField__c</inputField>
            <outputField>WokStep_CustomTextField__c</outputField>
         </mappingFields>
         <outputObject>WorkStep</outputObject>
      </objectMapping>
   </objectMappingItem>
   <objectMappingItem>
      <mappingType>WorkPlans_WorkPlanTemplateEntry_WorkStep</mappingType>
      <objectMapping>
         <inputObject>WorkPlanTemplateEntry</inputObject>
         <mappingFields>
            <inputField>WorkPlanTemplateEntry_CustomDateField__c</inputField>
            <outputField>WokStep_CustomDateField__c</outputField>
         </mappingFields>
         <outputObject>WorkStep</outputObject>
      </objectMapping>
   </objectMappingItem>
   <optimizationServiceAccess>false</optimizationServiceAccess>
   <serviceAppointmentsDueDateOffsetOrgValue>7</serviceAppointmentsDueDateOffsetOrgValue>
   <workOrderLineItemSearchFields>Subject</workOrderLineItemSearchFields>
   <workOrderSearchFields>Subject</workOrderSearchFields>
</FieldServiceSettings>
```

### 1.1.5 Wildcard Support in the Manifest File (FieldServiceSettings)

`package.xml` manifest의 wildcard 문자 `*`(asterisk)는 feature settings 메타데이터 타입에는 적용되지 않는다. wildcard는 모든 설정을 retrieve할 때만 적용되고 개별 설정에는 적용되지 않는다. ("The wildcard character * (asterisk) in the package.xml manifest file doesn't apply to metadata types for feature settings. The wildcard applies only when retrieving all settings, not for an individual setting.")

---

## 1.2 Skill

**설명:** field service에 사용하거나 Chat에서 채팅을 agent로 라우팅하는 데 사용하는 skill의 설정(skill 이름, skill이 할당된 agent 등)을 나타낸다.

- 이 타입은 Metadata 메타데이터 타입을 확장하며 그 `fullName` 필드를 상속한다.

**File Suffix and Directory Location:** Skill 값은 `skills` 디렉터리의 `<developer_name>.skill` 파일에 저장된다.
**Version:** API version **28.0** 이상에서 사용 가능.

**Fields (Field Name / Field Type / Description):**

| Field Name | Field Type | Description |
|---|---|---|
| assignments | SkillAssignments | skill이 Chat 사용자에게 어떻게 할당되는지 지정한다. Skill은 사용자 집합 또는 프로파일 집합에 할당할 수 있다. |
| description | string | skill의 description을 지정한다. API version 38.0 이상. |
| label | string | skill의 이름을 지정한다. |
| skillType | string | skill과 연관된 skill 타입(예: language 또는 department)을 지정한다. API version 58.0 이상. |

### 1.2.1 SkillAssignments (서브타입)

**설명:** 특정 skill이 어떤 사용자·사용자 프로파일에 할당되는지를 나타낸다.

| Field Name | Field Type | Description |
|---|---|---|
| profiles | SkillProfileAssignments | 특정 skill과 연관된 프로파일을 지정한다. |
| users | SkillUserAssignments | 특정 skill과 연관된 사용자를 지정한다. |

### 1.2.2 SkillProfileAssignments (서브타입)

**설명:** 특정 skill과 연관된 프로파일을 나타낸다.

| Field Name | Field Type | Description |
|---|---|---|
| profile | string | 특정 skill과 연관된 프로파일의 custom 이름을 지정한다. |

### 1.2.3 SkillUserAssignments (서브타입)

**설명:** 특정 skill과 연관된 사용자를 나타낸다.

| Field Name | Field Type | Description |
|---|---|---|
| user | string | 특정 skill과 연관된 사용자의 username을 지정한다. |

### 1.2.4 Declarative Metadata Sample Definition (Skill)

> "This is a sample of a skill file."

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Skill xmlns="http://soap.sforce.com/2006/04/metadata">
    <label>My Skill 1</label>
    <assignments>
        <profiles>
            <profile>LiveAgentOperator</profile>
            <profile>LiveAgentSupervisor</profile>
        </profiles>
        <users>
            <user>jdoe@acme.com</user>
        </users>
    </assignments>
</Skill>
```

### 1.2.5 Wildcard Support in the Manifest File (Skill)

이 메타데이터 타입은 `package.xml` manifest의 wildcard 문자 `*`(asterisk)를 지원한다.

---

## 1.3 TimeSheetTemplate [Metadata]

> ⚠️ **이것은 Metadata API 버전이다.** Tooling API 동명 타입은 [§2.2](#22-timesheettemplate-tooling)를 참조한다. 두 타입은 필드명 대소문자(Metadata=camelCase / Tooling=PascalCase)·구성·레이아웃이 **다르다**.

**설명:** Field Service에서 time sheet를 생성하기 위한 템플릿을 나타낸다. 이 타입은 Metadata 메타데이터 타입을 확장하며 그 `fullName` 필드를 상속한다.

> **Important (원문 callout):** "Where possible, we changed noninclusive terms to align with our company value of Equality. We maintained certain terms to avoid any effect on customer implementations."

**File Suffix and Directory Location:** TimeSheetTemplate 컴포넌트는 `timeSheetTemplate` suffix를 가지며 `timeSheetTemplates` 폴더에 저장된다.
**Version:** API version **46.0** 이상에서 사용 가능.
**Special Access Rules:** Field Service가 활성화되어야 한다. 사용자는 Customize Application 및 Time Sheet Template 권한이 있어야 한다.

**Fields (camelCase — Field Name / Field Type / Description):**

| Field Name | Field Type | Description |
|---|---|---|
| active | boolean | **Required.** time sheet 템플릿이 active(true)인지 아닌지(false)를 나타낸다. |
| description | string | time sheet 템플릿의 description. |
| frequency | TimeSheetFrequency (enumeration of type string) | **Required.** time sheet 생성 주기를 정의한다. 다음 값 중 하나: • Daily • Weekly • EveryTwoWeeks • TwiceAMonth • Monthly |
| masterLabel | string | **Required.** time sheet 템플릿의 이름. |
| startDate | date | **Required.** time sheet가 적용되기 시작하는 날짜. |
| timeSheetTemplateAssignments | TimeSheetTemplateAssignment | 템플릿이 할당된 프로파일 목록. |
| workWeekEndDay | DaysOfWeek (enumeration of type string) | **Required.** 템플릿 work week의 종료일. 다음 값 중 하나: • Monday • Tuesday • Wednesday • Thursday • Friday • Saturday • Sunday |
| workWeekStartDay | DaysOfWeek (enumeration of type string) | **Required.** 템플릿 work week의 시작일. 다음 값 중 하나: • Monday • Tuesday • Wednesday • Thursday • Friday • Saturday • Sunday |

### 1.3.1 TimeSheetTemplateAssignment (서브타입)

> ⚠️ **[sic] — 원문 설명 오류 보존:** 아래 타입 설명문은 명백히 EmbeddedServiceLiveAgent의 quick action을 설명하는 잘못된 복붙으로 보이지만 **PDF 원문 그대로**다. 실제 이 서브타입은 `assignedTo` 필드 하나만 가지므로 필드 표를 사용하고, 설명문은 오류 가능성을 표기한 채 원문대로 둔다.

**설명 (원문 그대로, [sic]):** "Returns a quick action that's associated with an EmbeddedServiceLiveAgent setup. The quick action includes the pre-chat form fields that the embedded chat window displays and shows the order in which the fields are displayed."

| Field Name | Field Type | Description |
|---|---|---|
| assignedTo | string | time sheet 템플릿이 할당된 사용자 프로파일의 ID. |

### 1.3.2 Declarative Metadata Sample Definition (TimeSheetTemplate Metadata)

> "The following is an example of a TimeSheetTemplate file."

> ⚠️ **[sic]:** PDF 원문 XML에는 curly/smart quote(`"` `"`)와 straight quote가 섞여 있다. 아래는 위키 코드블록 규칙에 따라 straight quote(`"`)로 정규화한 것이다(표기 아티팩트 정규화).

```xml
<?xml version="1.0" encoding="UTF-8"?>
<TimeSheetTemplate xmlns="http://soap.sforce.com/2006/04/metadata">
   <active>true</active>
   <description>Time Sheet Template description</description>
   <frequency>Daily</frequency>
   <masterLabel>label</masterLabel>
   <startDate>2018-10-18</startDate>
   <timeSheetTemplateAssignments>
       <assignedTo>admin</assignedTo>
   </timeSheetTemplateAssignments>
   <timeSheetTemplateAssignments>
       <assignedTo>standard</assignedTo>
   </timeSheetTemplateAssignments>
   <workWeekEndDay>Tuesday</workWeekEndDay>
   <workWeekStartDay>Monday</workWeekStartDay>
</TimeSheetTemplate>
```

> "The following is an example package.xml that references the previous definition."

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
   <types>
       <members>*</members>
       <name>TimeSheetTemplate</name>
   </types>
   <version>46.0</version>
</Package>
```

### 1.3.3 Wildcard Support in the Manifest File (TimeSheetTemplate Metadata)

이 메타데이터 타입은 `package.xml` manifest의 wildcard 문자 `*`(asterisk)를 지원한다.

---

# 2. Field Service Tooling API

> "The following Tooling objects are used in Field Service."
> 포함 오브젝트: **CleanRule**, **TimeSheetTemplate**

---

## 2.1 CleanRule

**설명:** 조직의 기존 레코드에 대해 data service가 데이터를 추가·업데이트하는 방식을 제어하는 data integration rule을 나타낸다.

**Version:** API version **38.0** 이상에서 사용 가능.
**Supported SOAP Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
**Supported REST HTTP Methods:** `GET`

**Fields (세로 레이아웃 — Field / Type / Properties / Description):**

| Field | Type | Properties | Description |
|---|---|---|---|
| CleanDataServiceId | reference | Create, Filter, Group, Sort | 이 CleanRule을 처리하는 CleanDataService에 대한 foreign key 참조. |
| DataAssessmentStatus | picklist | Create, Defaulted on create, Filter, Group, Nillable | data assessment의 상태. 유효 값: • Hidden (default) • Not Started • In Progress • Pending Aggregation • Aggregation Complete • Failed Aggregation • Aborted. 이 필드는 read only다. |
| Description | textarea | Create, Filter, Group, Nillable, Sort, Update | data integration rule을 설명하는 user-friendly 텍스트. |
| DeveloperName | string | Create, Filter, Group, Sort, Update | 이 이름은 밑줄과 alphanumeric 문자만 포함할 수 있고 조직에서 고유해야 한다. 문자로 시작해야 하며, 공백을 포함하지 않고, 밑줄로 끝나지 않고, 연속된 두 밑줄을 포함하지 않는다. 이 고유 이름은 같은 MasterLabel을 가진 다른 패키지의 rule과의 충돌을 방지한다. **Note:** View DeveloperName 또는 View Setup and Configuration 권한을 가진 사용자만 이 필드를 보고·group·sort·filter할 수 있다. |
| IsBulkEnabled | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | true이면 rule이 업데이트·저장될 때마다 시스템이 기존 레코드에 자동으로 rule을 적용한다. false이면 자동 적용하지 않는다. 항상 수동으로 rule을 적용할 수 있다. |
| IsSilentSaveEnabled | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | false이면 이 rule 적용 시 LastModifiedDate·LastModifiedById를 수정하지 않는다. 그렇지 않으면 업데이트가 현재 날짜·현재 사용자를 삽입한다. |
| Language | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | data integration rule의 언어. 허용 값: • Chinese (Simplified): zh_CN • Chinese (Traditional): zh_TW • Danish: da • Dutch: nl_NL • English: en_US • Finnish: fi • French: fr • German: de • Italian: it • Japanese: ja • Korean: ko • Norwegian: no • Portuguese (Brazil): pt_BR • Russian: ru • Spanish: es • Spanish (Mexico): es_MX [Spanish (Mexico)는 customer-defined translation에서는 Spanish로 기본 설정됨] • Swedish: sv • Thai: th [Salesforce UI는 Thai로 완전 번역되었으나 Help는 영어임]. |
| MatchConfidence | double | Create, Filter, Nillable, Sort, Update | Lightning Data 레코드가 Salesforce 레코드와 얼마나 일치하는지를 나타낸다. 최소값이 높을수록 더 정밀한 매치다. 서드파티 데이터의 match score를 지원하는 패키지에 사용. 유효 값은 data service provider가 결정하는 정수다. 값이 null이면 data service provider의 기본값이 사용된다. API version 45.0 이상. |
| MasterLabel | string | Create, Filter, Group, Sort, Update | 이 오브젝트의 master label. 이 표시 값은 번역되지 않는 internal label이다. |
| MatchRule | string | Create, Filter, Group, Nillable, Sort | 이 CleanRule과 연관된 data service의 matching rule에 대한 internal label. |
| ShouldBypassTriggers | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | true이면 이 rule 적용 시 시스템이 trigger를 적용하지 않음을 나타낸다. 그렇지 않으면 trigger를 적용한다. |
| ShouldBypassWorkflow | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | true이면 data integration rule 적용 시 시스템이 workflow rule을 우회한다. 그렇지 않으면 workflow rule을 적용한다. |
| SobjectType | picklist | Create, Filter, Group, Restricted picklist, Sort | 이 CleanRule이 작동하는 조직의 표준 또는 custom 오브젝트. 가능한 값: • Account • Address • Contact • CustomEntityDefinition • Lead • ResourceAbsence • ServiceAppointment • ServiceTerritory • ServiceTerritoryMember • WorkOrder • WorkOrderLineItem. 또한 data integration rule을 가진 custom 오브젝트도 가능하다. **Note:** 표준 오브젝트는 기본 data integration rule과 함께 설치되지만, account·contact·lead에 대한 기본 rule만 수정할 수 있다. |
| SourceSobjectType | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort | 이 CleanRule과 연관된 data service 오브젝트. picklist 값 집합은 data service에 정의된 모든 오브젝트 타입을 포함한다. 단, 존재하지 않는 오브젝트를 지정하면 API 호출이 에러를 반환한다. Salesforce data service를 활성화하면 다음 값이 나타난다. **CustomEntityDefinition:** external object 형태로 external source에서 retrieve한 정보로 account·contact·lead를 enrich한다. external object 필드를 account·contact·lead lookup 및 detail에 매핑한다. **DataCloudAddress:** Geolocation data service. **DatacloudDandBCompany:** Data.com data service. 이 서비스는 Professional·Enterprise·Unlimited·Performance Edition에서만, 그리고 Premium Clean 라이선스에서만 사용 가능하다. 관리자가 account·lead에 대한 data integration rule을 활성화하여 이 data service를 켜야 한다. data service를 포함하는 Marketplace 패키지를 설치하면 그 오브젝트 이름도 picklist 값 집합에 나타난다. |
| Status | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | data integration rule의 상태. 유효 값은 Active 및 Inactive다. |

> ✅ **DeveloperName Properties 검증 노트:** pdftotext 원문 추출은 `Create, Filter, Group, , Sort, Update`(이중 콤마)였으나, p.558(물리 562) 이미지 확인 결과 실제 값은 **`Create, Filter, Group, Sort, Update`**(이중 콤마 아님)이다. 위 표는 이미지-검증값을 반영했다.

---

## 2.2 TimeSheetTemplate [Tooling]

> ⚠️ **이것은 Tooling API 버전이다.** Metadata API 동명 타입은 [§1.3](#13-timesheettemplate-metadata)를 참조한다. 두 타입은 필드명 대소문자(Tooling=PascalCase / Metadata=camelCase)·구성·레이아웃이 **다르다**. Tooling 버전은 PascalCase 시스템 필드(Fullname·Metadata·ManageableState·NamespacePrefix 등)를 포함한다.

**설명:** Field Service에서 time sheet를 생성하기 위한 템플릿을 나타낸다. API version 46.0 이상에서 사용 가능.

**Supported SOAP Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
**Supported REST HTTP Methods:** `GET, POST, PATCH, DELETE`
**Special Access Rules:** TimeSheetTemplate에 접근하려면 Field Service가 활성화되어야 한다. 사용자는 Customize Application 및 Time Sheet Template 권한이 있어야 한다.
**Limitations:** SOQL Limitations

**Fields (PascalCase — Field / Type / Properties / Description):**

| Field | Type | Properties | Description |
|---|---|---|---|
| Active | boolean | Defaulted On Create, Filter, Group, Sort | time sheet 템플릿이 active(true)인지 아닌지(false)를 나타낸다. |
| Description | textarea | Nillable | time sheet 템플릿의 description. |
| DeveloperName | string | Filter, Group, Sort | time sheet 템플릿의 API name. alphanumeric 문자와 밑줄을 포함할 수 있고 문자로 시작해야 한다. View DeveloperName 또는 View Setup and Configuration 권한을 가진 사용자만 이 필드를 보고·group·sort·filter할 수 있다. |
| Frequency | picklist | Filter, Group, Restricted picklist, Sort | time sheet 생성 주기를 정의한다. 다음 값 중 하나: • Daily • Weekly • EveryTwoWeeks • TwiceAMonth • Monthly |
| Fullname | string | Create, Group, Nillable | Metadata API의 연관 메타데이터 오브젝트의 full name. query 결과가 1개 레코드 이하일 때만 이 필드를 query한다. 그렇지 않으면 에러가 반환된다. 1개를 초과하면 여러 query로 나눠 레코드를 retrieve한다. 이 제한은 성능을 보호한다. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | time sheet 템플릿과 연관된 언어. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | 패키지에 포함된 지정 컴포넌트의 manageable 상태를 나타낸다: • beta • deleted • deprecated • deprecatedEditable • installed • installedEditable • released • unmanaged. API version 48.0 이상. |
| MasterLabel | string | Filter, Group, Sort | time sheet 템플릿의 이름. |
| Metadata | mns:TimeSheetTemplate ([§1.3](#13-timesheettemplate-metadata)) | Create, Nillable, Update | TimeSheetTemplate 메타데이터. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | time sheet 템플릿을 관리하는 패키지를 식별하는 namespace. API version 48.0 이상. |
| StartDate | date | Filter, Group, Sort | time sheet가 적용되기 시작하는 날짜. |
| TimeSheetTemplateAssignments | QueryResult | Nillable | 템플릿이 할당된 프로파일 목록. 이 필드는 템플릿이 최소 1개 사용자 프로파일에 할당된 경우에만 보인다. API version 48.0 이상. |
| WorkWeekEndDay | picklist | Defaulted On Create, Filter, Group, Restricted picklist, Sort | 템플릿 work week의 종료일. 다음 값 중 하나: • Monday • Tuesday • Wednesday • Thursday • Friday • Saturday • Sunday (default) |
| WorkWeekStartDay | picklist | Defaulted On Create, Filter, Group, Restricted picklist, Sort | 템플릿 work week의 시작일. 다음 값 중 하나: • Monday • Tuesday • Wednesday • Thursday • Friday • Saturday • Sunday (default) |

> 참고: `WorkWeekEndDay`·`WorkWeekStartDay`의 마지막 두 값(Saturday, Sunday(default))은 물리 p.569(인쇄 565)에 이어지며, 별도 추출로 확인 완료. 두 필드 모두 동일한 7개 값을 가지며 Sunday가 (default)다.

---

## Metadata vs Tooling TimeSheetTemplate 비교 (동명 타입 구분)

| 구분 | [Metadata] TimeSheetTemplate (§1.3) | [Tooling] TimeSheetTemplate (§2.2) |
|---|---|---|
| 필드 표기 | camelCase (`active`, `masterLabel`, `workWeekStartDay`) | PascalCase (`Active`, `MasterLabel`, `WorkWeekStartDay`) |
| 필드 수 | 8 | 14 (시스템 필드 포함) |
| 시스템 필드 | 없음 | `Fullname`, `Metadata`, `ManageableState`, `NamespacePrefix`, `TimeSheetTemplateAssignments`(QueryResult) |
| 접근 방식 | declarative metadata(`.timeSheetTemplate` 파일) | SOAP/REST CRUD 호출 |
| Version | 46.0 이상 | 46.0 이상 (시스템 필드 일부는 48.0 이상) |

---

## 관련 노트
- [[Field Service 개요와 데이터 모델]]
- [[Field Service Objects]] — Skill·TimeSheet 등 FSL 표준 오브젝트 레퍼런스 카탈로그
- [[Field Service REST API]] — 같은 가이드의 REST 리소스(Flow·Mobile Settings·Service Report Template·Appointment Bundling)
