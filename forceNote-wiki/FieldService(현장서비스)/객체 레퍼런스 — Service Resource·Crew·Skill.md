---
tags: [field-service, fsl, sobject, object-reference, service-resource, skill, crew, resource-absence, travel-mode, 현장서비스, 객체레퍼런스]
source: field_service_dev.pdf (Field Service Developer Guide v67.0 Summer '26)
created: 2026-06-23
aliases: [ServiceResource, ServiceResourceCapacity, ServiceResourceSkill, ServiceCrew, ServiceCrewMember, ResourceAbsence, ResourcePreference, Skill, SkillRequirement, TravelMode, 서비스 리소스, 리소스 용량, 크루, 크루 멤버, 리소스 부재, 스킬, 스킬 요구사항, 이동 모드]
---

# 객체 레퍼런스 — Service Resource·Crew·Skill

> Field Service의 인적 자원 클러스터 10객체 — 서비스 리소스·용량·스킬·크루·부재·이동 모드의 표준 필드 전수 레퍼런스.

---

이 노트는 **Field Service Developer Guide v67.0 (Summer '26)** 의 Object Reference 챕터 중 **Service Resource·Crew·Skill 클러스터 10객체**의 데이터 모델(표준 필드·Supported Calls·접근 규칙·연관 객체)을 정리한다.

- 전체 데이터 모델 지도와 객체 간 관계는 허브 노트 [[Field Service 개요와 데이터 모델]]에서, FSL 객체 카탈로그 요약은 [[Field Service Objects]]에서 본다.
- **★ 도메인 공유 주의:** `ServiceResource`·`Skill`·`SkillRequirement`·`ResourceAbsence` 등 여러 객체는 Field Service뿐 아니라 **Salesforce Scheduler·Omni-Channel·Workforce Engagement** 와 객체를 공유한다. 이 노트는 **객체/필드 데이터 모델 관점**만 다룬다 — 예약(booking) 흐름은 Scheduler 도메인, 옴니채널 스킬 기반 라우팅 흐름은 Service Cloud(Omni-Channel) 도메인 노트를 참조한다(혼동 방지).

아래는 본 클러스터 객체들의 관계 필드(아래 표의 Relationship Name·Refers To 기반)를 활용한 SOQL 예시다.

```sql
// 구조 예시 — 실제 동작 코드 아님 (필드·관계명은 아래 표 기준)
// 특정 스킬을 일정 레벨 이상 보유한 활성 서비스 리소스 조회
SELECT Id, Name, ResourceType, IsCapacityBased,
       (SELECT Skill.MasterLabel, SkillLevel FROM ServiceResourceSkills WHERE SkillLevel >= 50)
FROM ServiceResource
WHERE IsActive = true AND ResourceType = 'T'
```

---

## ServiceResource

Field Service 및 Salesforce Scheduler의 서비스 기술자 또는 서비스 크루, 또는 Workforce Engagement의 상담원을 나타낸다. API 버전 38.0 이상에서 사용 가능.

**Supported Calls:** `create()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `update()`, `upsert()`

**Special Access Rules:** Field Service 또는 Workforce Engagement가 활성화되어 있어야 한다.

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| Description | textarea | Create, Nillable, Update | The description of the resource. |
| IsActive | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | When selected, this option means that the resource can be assigned to work orders. For service tracking purposes, resources can't be deleted, so deactivating a resource is the best way to send them into retirement. Deactivating a user doesn't deactivate the related service resource. You can't create a service resource that is linked to an inactive user. |
| IsCapacityBased | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Capacity-based resources are limited to a certain number of hours or appointments in a specified time period. The Capacities related list shows a resource's capacity. |
| IsOptimizationCapable | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | This field is reserved for Field Service and the managed package. Create a custom field instead of using this field to include a service resource in optimization. |
| LastKnownLatitude | double | Create, Filter, Nillable, Sort, Update | The latitude of the last known location. |
| LastKnownLongitude | double | Create, Filter, Nillable, Sort, Update | The longitude of the last known location. |
| LastKnownLocation | location | Nillable | The service resource's last known location. You can configure this field to display data collected from a custom mobile app. This field isn't visible in the user interface, but you can expose it on service resource page layouts or set up field tracking to be able to view a resource's location history. |
| LastKnownLocationDate | dateTime | Filter, Nillable, Sort, Update | The date and time of the last known location. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The date when the service resource was last modified. Its label in the user interface is Last Modified Date. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The date when the service resource was last viewed. |
| LocationId | reference | Create, Filter, Group, Sort, Nillable, Update | The location associated with the service resource. For example, a service vehicle driven by the service resource. LocationId is a relationship field. Relationship Name: Location · Type: Lookup · Refers To: Location. |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | The resource's name, for example the name or title of the associated user or service crew. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | The owner of the service resource. OwnerId is a polymorphic relationship field. Relationship Name: Owner · Type: Lookup · Refers To: Group, User. |
| RelatedRecordId | reference | Create, Filter, Group, Sort, Nillable, Update | The associated user. Its label in the UI is User. If the service resource represents a service crew rather than a user, leave the User field blank and select the related crew in the ServiceCrewId field. RelatedRecordId is a relationship field. Relationship Name: RelatedRecord · Type: Lookup · Refers To: User. |
| ResourceType | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Indicates whether the resource is a Technician (T), Dispatcher (D), Crew (C), Asset (S), Agent (A), or Planner (P). The default value is Technician (T). Resources who are dispatchers can't be capacity-based or included in scheduling optimization. Only users with the Field Service Dispatcher permission-set license can be dispatchers. You can't add additional resource types. To create a dependent lookup filter with ServiceResource.ResourceType, use only the first letter of the picklist value, for example T for Technician. |
| ServiceCrewId | reference | Create, Filter, Group, Sort, Nillable, Update | The associated service crew. If the service resource represents a crew, select the crew. This field is hidden for all users by default. To use it, update its field-level security settings in Setup and add it to your service resource page layouts. |

**Associated Objects:** ServiceResourceChangeEvent (API version 48.0) — Change events; ServiceResourceFeed — Feed tracking; ServiceResourceHistory — History; ServiceResourceOwnerSharingRule — Sharing rules; ServiceResourceShare — Sharing.

(Usage 섹션 없음 [sic] — 원문에 Usage 헤딩 부재.)

---

## ServiceResourceCapacity

용량 기반(capacity-based) 서비스 리소스가 특정 기간 동안 완료할 수 있는 최대 예약 시간 수 또는 서비스 약속 수를 나타낸다. API 버전 38.0 이상에서 사용 가능.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `update()`, `upsert()`

**Special Access Rules:** Field Service가 활성화되어 있어야 한다.

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| CapacityInHours | double | Create, Filter, Nillable, Sort, Update | The number of hours that the resource can work per time period. You must fill out this field, the CapacityInWorkItems field, or both. |
| CapacityInWorkItems | int | Create, Filter, Group, Nillable, Sort, Update | The total number of service appointments that the resource can complete per time period. You must fill out this field, the CapacityInHours field, or both. |
| CapacityNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | (Read only) An auto-generated number identifying the capacity record. |
| EndDate | date | Create, Filter, Group, Nillable, Sort, Update | The date the capacity ends; for example, the end date of a contract. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The timestamp for when the current user last viewed a record related to this record. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The timestamp for when the current user last viewed this record. If this value is null, this record might only have been referenced (LastReferencedDate) and not viewed. |
| ServiceResourceId | reference | Create, Filter, Group, Sort | The associated service resource. You can set multiple capacities for a resource as long as their start and end dates do not overlap. |
| StartDate | date | Create, Filter, Group, Sort | The date the capacity goes into effect. |
| TimePeriod | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Days, Hours, or Months. For example, if a resource can work 80 hours per month, the capacity's Time Period would be Month and Hours per Time Period would be 80. |

**Usage:** Service resources who are capacity-based can only work a certain number of hours or complete a certain number of service appointments within a specified time period. Contractors tend to be capacity-based. To indicate that a service resource is capacity-based, select Capacity-Based on the service resource record, then create a capacity record for the service resource. You must fill out at least one of these fields: CapacityInWorkItems and CapacityInHours. If you're using the Field Service managed package and would like to measure capacity both in hours and in number of work items, enter a value for both. The resource is considered to reach their capacity based on whichever term is met first—hours or number of work items.

> [!important] If you aren't using the Field Service managed package, capacity serves more as a suggestion than a rule. Resources can still be as scheduled beyond their capacity [sic], and you aren't notified when a resource exceeds their capacity.

**Associated Objects:** ServiceResourceCapacityChangeEvent (API version 54.0) — Change events; ServiceResourceCapacityFeed — Feed tracking; ServiceResourceCapacityHistory — History.

---

## ServiceResourceSkill

Field Service 및 Lightning Scheduler에서 서비스 리소스가 보유한 스킬을 나타낸다. API 버전 38.0 이상에서 사용 가능.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `update()`, `upsert()`

**Special Access Rules:** Field Service가 활성화되어 있어야 한다.

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| EffectiveEndDate | datetime | Create, Filter, Nillable, Sort, Update | The date when the skill expires. For example, if a service resource needs to be re-certified after six months, the end date would be the date their certification expires. |
| EffectiveStartDate | datetime | Create, Filter, Sort, Update | The date when the service resource gains the skill. For example, if the skill represents a certification, the start date would be the date of certification. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The date when the resource skill was last modified. Its label in the user interface is Last Modified Date. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The date when the resource skill was last viewed. |
| ServiceResourceId | reference | Create, Filter, Group, Sort | The service resource who possesses the skill. This is a relationship field. Relationship Name: ServiceResource · Type: Lookup · Refers To: ServiceResource. |
| SkillId | reference | Create, Filter, Group, Sort, Update | The skill the service resource possesses. This is a relationship field. Relationship Name: Skill · Type: Lookup · Refers To: Skill. |
| SkillLevel | double | Create, Defaulted on create, Filter, Nillable, Sort, Update | The service resource's skill level. Skill level can range from zero to 99.99. |
| SkillNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | An auto-generated number identifying the resource skill assignment. |

**Usage:** You can assign skills to all service resources in your org to indicate their certifications and areas of expertise, and specify each resource's skill level from 0 to 99.99. For example, you can assign Maria the "Welding" skill, level 50. If you intend to use the skills feature, determine which skills you want to track and how skill level should be determined. For example, you may want the skill level to reflect years of experience, certification levels, or license classes.

**Associated Objects:** ServiceResourceSkillChangeEvent (API version 54.0) — Change events; ServiceResourceSkillFeed — Feed tracking; ServiceResourceSkillHistory — History.

---

## ServiceCrew

서비스 약속에 하나의 단위로 배정될 수 있는 서비스 리소스 그룹을 나타낸다. 서비스 크루는 결합된 스킬과 경험으로 약속에서 함께 일하기에 적합한 서비스 리소스 그룹이다. 예를 들어 유정(wellhead) 수리 크루에는 수문학자, 기계 엔지니어, 전기 기술자가 포함될 수 있다. 서비스 약속은 서비스 리소스에만 배정될 수 있다. 서비스 크루를 서비스 약속에 배정하려면, 크루를 나타내는 리소스 타입 Crew의 서비스 리소스를 만든 뒤 그 리소스를 배정 목적으로 사용해야 한다.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

**Special Access Rules:** Field Service가 활성화되어 있어야 한다.

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| CrewSize | int | Create, Filter, Group, Sort, Update | The number of members on the crew. This field is manual, so it doesn't auto-update when you add or remove members. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The date when the service crew was last modified. Its label in the user interface is Last Modified Date. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The date when the service crew was last viewed. |
| Name | string | Create, Filter, Group, Sort, Update | The name of the service crew. For example, Repair Crew. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | The crew owner. By default, the owner is the person who created the service crew. |

**Associated Objects:** ServiceCrewChangeEvent (API version 48.0) — Change events; ServiceCrewFeed — Feed tracking; ServiceCrewHistory — History; ServiceCrewOwnerSharingRule — Sharing rules; ServiceCrewShare — Sharing.

(Usage 섹션 없음 [sic].)

---

## ServiceCrewMember

서비스 크루에 속한 기술자(Technician) 서비스 리소스를 나타낸다.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

**Special Access Rules:** Field Service가 활성화되어 있어야 한다.

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| EndDate | dateTime | Create, Filter, Nillable, Sort, Update | The last day that the service resource belongs to the crew. You can use this field to track employment dates for contractors. |
| IsLeader | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates that the member is the crew leader. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The date when the service crew member was last modified. Its label in the user interface is Last Modified Date. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The date when the service crew member was last viewed. |
| ServiceCrewId | reference | Create, Filter, Group, Sort | The crew that the service resource belongs to. |
| ServiceCrewMemberNumber | string | Autonumber, Defaulted on create, Filter, Sort | An auto-generated number identifying the service crew member. |
| ServiceResourceId | reference | Create, Filter, Group, Sort, Update | The service resource that belongs to the crew. Only service resources whose resource type is Technician can be added to service crews. |
| StartDate | dateTime | Create, Filter, Sort, Update | Required. The day the service resource joins the crew. Service resources can belong to multiple crews as long as their start and end dates don't overlap. |

**Associated Objects:** ServiceCrewMemberChangeEvent (API version 48.0) — Change events; ServiceCrewMemberFeed — Feed tracking; ServiceCrewMemberHistory — History.

(Usage 섹션 없음 [sic].)

---

## ResourceAbsence

Field Service, Salesforce Scheduler, 또는 Workforce Engagement에서 서비스 리소스가 일할 수 없는 기간을 나타낸다. API 버전 38.0 이상에서 사용 가능.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `update()`, `upsert()`

**Special Access Rules:** Field Service 또는 Workforce Engagement가 활성화되어 있어야 한다.

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| AbsenceNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | (Read only) An auto-generated number identifying the absence. |
| Address | address | Filter | The compound form of the address associated with the absence. |
| City | string | Create, Filter, Group, Nillable, Sort, Update | The city of the address associated with the absence. Maximum length is 40 characters. |
| Country | string | Create, Filter, Group, Nillable, Sort, Update | The country of the address associated with the absence. Maximum length is 80 characters. |
| Description | textarea | Create, Nillable, Update | The description of the absence. |
| End | dateTime | Create, Filter, Sort, Update | The date and time when the absence ends. |
| GeocodeAccuracy | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The level of accuracy of a location's geographical coordinates compared with its physical address. Usually provided by a geocoding service based on the address's latitude and longitude coordinates. This field is available in the API only. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The date when the resource absence was last modified. Its label in the user interface is Last Modified Date. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The date when the resource absence was last viewed. |
| Latitude | double | Create, Filter, Nillable, Sort, Update | Used with Longitude to specify the precise geolocation of the address associated with the absence. Acceptable values are numbers between –90 and 90 with up to 15 decimal places. Note: This field is available in the API only. |
| Longitude | double | Create, Filter, Nillable, Sort, Update | Used with Latitude to specify the precise geolocation of the address associated with the absence. Acceptable values are numbers between –180 and 180 with up to 15 decimal places. Note: This field is available in the API only. |
| Postal Code | string | Create, Filter, Group, Nillable, Sort, Update | The postal code of the address associated with the absence. Maximum length is 20 characters. ([sic] 필드 레이블 "Postal Code"에 공백 포함 — PDF 원문 표기 그대로 보존. API명은 통상 PostalCode.) |
| ResourceId | reference | Create, Filter, Group, Sort, Update | The absent service resource. This is a relationship field. Relationship Name: Resource · Type: Lookup · Refers To: ServiceResource. |
| Start | dateTime | Create, Filter, Sort, Update | The date and time when the absence begins. |
| State | string | Create, Filter, Group, Nillable, Sort, Update | The state of the address associated with the absence. Maximum length is 80 characters. |
| Street | textarea | Create, Filter, Group, Nillable, Sort, Update | The street number and name of the address associated with the absence. |
| Type | picklist | Create, Defaulted on create, Filter, Group, Sort, Update | The type of absence: Meeting, Training, Medical, or Vacation. The default value is Vacation. You can add custom values if needed, but the name Break is reserved for the Field Service managed package. |

**Usage:** Resource absences you define periods of time when a service resource is unavailable to work [sic — 원문 문법 그대로]. Unless you're using the Field Service managed package, service resources can still be assigned to appointments that conflict with their absences.

> [!tip] Create a trigger that sends an approval request to a supervisor when a service resource creates an absence.

If you're not using the Field Service managed package, a calendar view isn't available for individual service resources.

**Associated Objects:** ResourceAbsenceChangeEvent (API version 48.0) — Change events; ResourceAbsenceFeed — Feed tracking; ResourceAbsenceHistory — History.

---

## ResourcePreference

지정된 서비스 리소스에 대한 계정의 선호도를 나타낸다. 리소스 선호도는 어떤 서비스 리소스가 현장 서비스 작업에 배정될 수 있는지를 나타낸다. 특정 계정·자산·위치·작업 지시·작업 지시 라인 항목에서 서비스 리소스를 preferred, required, excluded로 지정할 수 있다. 작업 지시는 연관된 계정의 리소스 선호도를 상속한다.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `update()`, `upsert()`

**Special Access Rules:** Field Service가 활성화되어 있어야 한다.

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The date when the resource preference was last modified. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The date when the resource preference was last viewed. |
| PreferenceType | picklist | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort, Update | Resource preference type. Values include: • Preferred: Indicates that the customer would like their field service work assigned to the resource. • Required: Indicates that the resource must be assigned to the customer's field service work. • Excluded: Indicates that the customer doesn't want their field service work assigned to the resource. Resource preferences serve more as a suggestion than a requirement. You can still assign a service appointment to any resource regardless of the related work order's resource preferences. |
| RelatedRecordId | reference | Create, Filter, Group, Sort | The work order or account with the resource preference. This field is a polymorphic relationship. Relationship Name: RelatedRecord · Type: Lookup · Refers To: Accounts, Assets, Locations, Work Orders, or Work Order Line Items. |
| ResourcePreferenceNumber | string | Autonumber, Defaulted on create, Filter, Sort | An auto-generated number identifying the resource preference. |
| ServiceResourceId | reference | Create, Filter, Group, Sort, Update | The service resource that is preferred, required, or excluded. This is a relationship field. Relationship Name: ServiceResource · Type: Lookup · Refers To: ServiceResource. |

**Associated Objects:** ResourcePreferenceChangeEvent (API version 54.0) — Change events; ResourcePreferenceFeed — Feed tracking; ResourcePreferenceHistory — History.

(Usage 섹션 없음 [sic] — 객체 설명 단락 외 별도 Usage 없음.)

---

## Skill

Field Service 또는 Workforce Engagement에서 Chat 사용자 또는 서비스 리소스의 카테고리 또는 그룹을 나타낸다. API 버전 24.0 이상에서 사용 가능.

> [!note] WDC skills on a user's profile에 대한 정보는 ProfileSkill topic을 참조한다.

**Supported Calls:** `create()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`

**Special Access Rules:** (섹션 없음 [sic] — Skill 객체에는 Special Access Rules 헤딩이 없고 위 Note만 있음.)

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| Description | textarea | Create, Nillable, Update | The description of the skill. |
| DeveloperName | string | Create, Filter, Group, Sort, Update | The unique name of the object in the API. This name can contain only underscores and alphanumeric characters, and must be unique in your org. It must begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. In managed packages, this field prevents naming conflicts on package installations. With this field, a developer can change the object's name in a managed package and the changes are reflected in a subscriber's organization. When creating large sets of data, always specify a unique DeveloperName for each record. If no DeveloperName is specified, performance slows down while Salesforce generates one for each record. |
| Language | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The language of the skill. |
| LastViewedDate | datetime | Filter, Nillable, Sort | The timestamp for when the current user last viewed the skill. |
| MasterLabel | string | Create, Filter, Group, idLookup, Sort, Update | The name of the skill. |
| TypeId | reference | Create, Filter, Group, Nillable, Sort, Update | The skill type associated with the skill. This field is a relationship field. This field is available in API version 58.0 and later. Relationship Name: Type · Refers To: SkillType. (Relationship Type 미표기 [sic].) |

**Usage:**
- **Chat:** Use this object to assign Chat users to groups based on their abilities. The skills associated with a LiveChatButton determine which agents receive chat requests that come in through that button.
- **Field Service:** Use this object to track certifications and areas of expertise in your workforce. After you create a skill, you can: • Assign it to a service resource via the Skills related list on the resource's detail page. When you assign a skill to a service resource, you can specify their skill level and the duration of the skill. • Add it as a required skill via the Skill Requirements related list on any work type, work order, or work order line item. When you add a required skill to a work record, you can specify the skill level.
- **Workforce Engagement:** Use this object to specify areas of expertise in your workforce. After you create a skill, you can: • Assign it to a service resource via the Skills related list on the resource's detail page. • Add it as a required skill via the Skill Requirements related list on a job profile.

(Associated Objects 섹션 없음 [sic].)

---

## SkillRequirement

Field Service, Omni-Channel, Salesforce Scheduler, 또는 Workforce Engagement에서 특정 작업을 완료하는 데 필요한 스킬을 나타낸다. 스킬 요구사항은 Omni-Channel의 pending service routing 객체에 추가될 수 있다. Field Service 및 Lightning Scheduler에서는 work type·work order·work order line item에 추가될 수 있다. Workforce Engagement에서는 job profile에 추가될 수 있다. API 버전 38.0 이상에서 사용 가능. API 버전 42.0 이상에서 Omni-Channel skills-based routing의 work item에도 스킬 요구사항을 추가할 수 있다.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `update()`, `upsert()`

**Special Access Rules:** If you want to use SkillRequirement for Field Service use cases, then Field Service must be enabled. If you want to use SkillRequirement only for Omni-Channel skills-based routing use cases, then you don't need Field Service to be enabled. If you want to use SkillRequirement for Workforce Engagement use cases, then Workforce Engagement must be enabled.

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| IsAdditionalSkill | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates that a skill is additional. After a designated timeout period, a skill marked as additional is dropped from Omni-Channel routing. The case is then routed to the best-matched agent even if they don't have all the skills. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The timestamp for when the current user last viewed a record related to this record. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The timestamp when the current user last viewed this record. If this value is null, this record might only have been referenced (LastReferencedDate) and not viewed. |
| RelatedRecordId | reference | Create, Filter, Group, Sort | The record that the skill is required for. The related record can be a work order, work order line item, work type, or pending service routing record. This is a polymorphic relationship field. Relationship Name: RelatedRecord · Type: Lookup · Refers To: WorkOrder, WorkOrderLineItem, WorkType. |
| SkillId | reference | Create, Filter, Group, Sort, Update | The skill that is required. This is a relationship field. Relationship Name: Skill · Type: Lookup · Refers To: Skill. |
| SkillLevel | double | Create, Defaulted on create, Filter, Nillable, Sort, Update | The level of the skill required. Skill levels can range from zero to 99.99. Depending on your business needs, you can have the skill level to reflect years of experience, certification levels, or license classes. |
| SkillNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | An auto-generated number identifying the skill requirement. |
| SkillPriority | int | Aggregatable, Create, Filter, Group, Nillable, Sort, Update | For additional skills, specify the order in which skills are dropped if after the specified timeout no agent with that skill is available. Higher priority-value skills are dropped first. Lower priority-value skills, for example 0, are dropped last. Skills with the same priority value are dropped as a group. You can set skill priority using skills-based routing rules or Apex code. |

**Usage:**
- **Field Service:** Skill requirements help dispatchers assign work orders to service resources with the proper expertise. You can still assign a work order, work order line item, or related service appointment to a service resource that does not have the specified skills, so skill requirements serve more as a suggestion than a rule.
  > [!note] If you're using the Field Service managed package, use matching rules to ensure that appointments are only assigned to service resources who possess the skills listed on the parent work order.

  If many of your work orders require the same skills, add skill requirements to work types to save time and keep your processes consistent. When you add a skill requirement to a work type, work orders and work order line items that use that type automatically inherit the skill requirement. For example, if all annual maintenance visits for your Classic Refrigerator product require a Refrigerator Maintenance skill level of at least 50, add that skill requirement to the Annual Maintenance Visit work type. When you create a work order for a customer's annual fridge maintenance, applying that work type adds the skill requirement as well.
- **Omni-Channel:** We recommend that you use Omni-Channel flow or skills-based routing rules to create skills-based routing requests. When you do so, work items are routed by creating a PendingServiceRouting object. The PendingServiceRouting object can have multiple SkillRequirements objects associated with it. When a work item requires multiple skills, it's routed to an agent who has all of the required skills. The PendingServiceRouting object adds attributes to the work item that represent the skill (skill id), priority, skill proficiency, and timestamp.
- **Workforce Engagement:** Workforce Engagement uses skill requirements to assign shifts to agents who have the right skills. You can still assign shifts to service resources if they don't have those skills. In a non-Omni workflow, create a scheduling rule that matches agents to shifts based on their skills and the job profile's skill requirements. Shift scheduling tools can then assign agents with the right skills.

**Associated Objects:** SkillRequirementChangeEvent (API version 54.0) — Change events; SkillRequirementFeed — Feed tracking; SkillRequirementHistory — History.

---

## TravelMode

이동 시간 계산에 사용되는 이동 모드(travel mode)를 나타낸다. 레코드에는 운송 수단 유형(Car·Walking 등), 차량의 유료 도로 통행 가능 여부, 위험물(hazardous materials) 운송 여부 정보가 포함된다. API 버전 54.0 이상에서 사용 가능.

**Supported Calls:** (섹션 없음 [sic] — TravelMode 객체에는 Supported Calls 헤딩이 본문에 표기되지 않음. 설명 직후 바로 Fields.)

**Special Access Rules:** (섹션 없음 [sic].)

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| CanUseTollRoads | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates if the vehicle is allowed to drive on toll roads. The default value is false. |
| IsLocked | boolean | Defaulted on create, Filter, Group, Sort | Indicates whether the travel model record is locked or not. The default value is false. |
| IsTransportingHazmat | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates if the vehicle is transporting hazardous materials. The default value is false. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The timestamp when the current user last accessed this record, a record related to this record, or a list view. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The timestamp when the current user last viewed this record or list view. If this value is null, the user might have only accessed this record or list view (LastReferencedDate=) but not viewed it. [sic — 원문 "LastReferencedDate=" 등호 포함] |
| MayEdit | boolean | Defaulted on create, Filter, Group, Sort | Indicates whether the travel model record can be edited or not. The default value is false. |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | Name of the travel mode. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | ID of the owner of this object. This field is a polymorphic relationship field. Relationship Name: Owner · Type: Lookup · Refers To: Group, User. |
| TransportType | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Type of transportation. Possible values are: • Bicycle • Car-Default. • Heavy Truck • Light Truck • Walking ([sic] "Car-Default." 표기 그대로) |

**Associated Objects:** TravelModeFeed — Feed tracking; TravelModeOwnerSharingRule — Sharing rules; TravelModeShare — Sharing.

(Usage 섹션 없음 [sic].)

---

## 관련 노트
- [[Field Service 개요와 데이터 모델]] — FSL 데이터 모델 지도와 도메인 진입점
- [[Field Service Objects]] — 전체 FSL 객체 카탈로그 요약 (sObject 도메인)
- [[객체 레퍼런스 — Service Appointment·Resource]] — 서비스 약속·배정 리소스(AssignedResource) 객체
- [[객체 레퍼런스 — Service Territory·OperatingHours·Shift]] — ServiceTerritoryMember·Shift가 ServiceResource를 참조하는 영역·교대 객체
- [[객체 레퍼런스 — Asset·Attribute·Warranty]] — 자산·속성·워런티 객체
- [[객체 레퍼런스 — Service Contract·Entitlement·Milestone]] — 서비스 계약·엔타이틀먼트 객체
- [[객체 레퍼런스 — Appointment Bundling]] — 약속 번들링 객체
- [[객체 레퍼런스 — Custom Fields on Standard Objects]] — 관리패키지가 ServiceResource·ResourceAbsence·ServiceResourceCapacity에 추가하는 FSL__ 커스텀필드
