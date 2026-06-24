---
tags: [field-service, fsl, sobject, object-reference, mobile-settings, geolocation, linked-article, 현장서비스, 모바일설정, 지오로케이션]
source: field_service_dev.pdf (Field Service Developer Guide v67.0 Summer '26)
created: 2026-06-24
aliases: [AppExtension, FieldServiceMobileSettings, MobileSettingsAssignment, GeolocationBasedAction, LinkedArticle, FldSvcObjChg, FldSvcObjChgDtl, Field Service Mobile Settings, App Extension, Geolocation Based Action, Linked Article, 모바일 설정, 앱 익스텐션, 지오로케이션 액션, 연결 문서, 서비스 약속 변경 추적]
---

# 객체 레퍼런스 — Mobile·Geolocation·LinkedArticle·ObjChange

> Field Service 모바일 앱 경험·지오펜스 액션·지식 문서 연결·서비스 약속 변경 추적 클러스터의 SOAP API 객체 7종 전수 레퍼런스 — 앱 익스텐션(AppExtension)·모바일 설정(FieldServiceMobileSettings 53필드)과 프로필 할당(MobileSettingsAssignment), 지오로케이션 기반 액션(GeolocationBasedAction), 지식 문서 연결(LinkedArticle), 서비스 약속 변경 추적(FldSvcObjChg·FldSvcObjChgDtl)까지. 각 객체의 설명·Supported Calls·전 필드·enum·Special Access Rules·Usage·Associated Objects를 담는다.

> 이 노트는 Field Service의 **모바일·지오로케이션·지식 문서·변경 추적** 도메인 SOAP API 객체 정의를 다룬다. 전체 데이터 모델 개요와 객체 간 관계도(ER diagram)는 [[Field Service 개요와 데이터 모델]], 객체 카탈로그 요약은 [[Field Service Objects]]를 참조한다. 모바일 앱 자체의 LWC 확장·동작은 [[Field Service Mobile App (LWC)]], Mobile Settings를 다루는 REST 연계는 [[Field Service REST API]]를 참조한다.

---

## 객체 한눈에 (7)

| # | 객체 | 한 줄 | 필드 수(전수) | API 도입 |
|---|---|---|---|---|
| 1 | AppExtension | Field Service 모바일 앱과 다른 앱 간 연결(레코드 데이터 전달) | 7 | v41.0+ |
| 2 | FieldServiceMobileSettings | iOS/Android 모바일 앱 경험을 제어하는 설정 구성 | 53 | v38.0+ |
| 3 | MobileSettingsAssignment | 모바일 설정 구성을 사용자 프로필에 할당 | 2 | v41.0+ |
| 4 | GeolocationBasedAction | 지오펜스 진입/이탈 시 트리거되는 액션 | 12 | v61.0+ |
| 5 | LinkedArticle | 작업 주문/라인 항목/작업 유형에 첨부된 지식 문서 | 7 | v37.0+ |
| 6 | FldSvcObjChg | 서비스 약속의 추적 필드에 가해진 변경 | 9 | v63.0+ |
| 7 | FldSvcObjChgDtl | 서비스 약속의 추적 필드 변경의 상세 | 3 | v63.0+ |

> 필드 표 형식: PDF는 2열(Field Name | Details)이고 Details 셀 안에 Type/Properties/Description/Relationship Name/Relationship Type/Refers To가 세로 나열돼 있다. 본 노트는 이를 4열(Field · Type · Properties · Description)로 펼치고, 관계 필드는 Description 끝에 `RelName / RelType / Refers To`를 표기했다.
>
> **[sic] 보존:** PDF 원문의 오타·오기를 의도적으로 그대로 둔 곳에 `[sic]`을 달았다(FieldServiceMobileSettings의 단수 `DayAfterCurrentServiceDate` 필드명, 그리고 `MaxNumberOfServiceAppointments` 설명의 동일 필드명 중복 2건).

---

## 1. AppExtension

Field Service 모바일 앱과 다른 앱 간의 **연결**을 나타낸다. 앱 익스텐션은 현재 보고 있는 레코드의 필드 정보를 다른 앱으로 전달할 수 있다. v41.0+.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
**Special Access Rules:** Field Service must be enabled.

**Fields (7):**

| Field | Type | Properties | Description |
|---|---|---|---|
| AppExtensionLabel | string | Create, Filter, Group, Sort, Update | The label in the UI for the app extension. |
| AppExtensionName | string | Create, Filter, Group, Sort, Update | The API name of the app extension. |
| FieldServiceMobileSettingsId | reference | Create, Filter, Group, Sort | The ID of a set of field service mobile settings. |
| InstallationUrl | string | Create, Filter, Group, Nillable, Sort, Update | The URL that takes the user to the app install location, such as the App Store or Google Play. |
| LaunchValue | string | Create, Filter, Group, Sort, Update | A value directing the Field Service app to the appropriate app extension. The Launch Value can be a static URL or a dynamic value that you can represent with certain tokens. These tokens pass field information from the record that the user is currently viewing. The basic format for these tokens is based on the field names; for example: {!$Name}. |
| ScopedToObjectTypes | string | Create, Filter, Group, Nillable, Sort, Update | Indicates the types of records from which the app extension can be activated. Scoping an app extension to an object lets users activate the app extension from records of the specified type. For example, to scope to both work orders and service appointments you would use the value WorkOrder,ServiceAppointment. |
| Type | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | A picklist of types of app extensions: iOS, Android, Flow, and Lightning Apps. |

**Associated Objects:** `AppExtensionChangeEvent` (v55.0) — change events are available for the object.

---

## 2. FieldServiceMobileSettings

Field Service iOS/Android **모바일 앱 경험을 제어하는 설정 구성**을 나타낸다. v38.0+.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
**Special Access Rules:** Field Service must be enabled.

**Fields (53 — 전수):**

| Field | Type | Properties | Description |
|---|---|---|---|
| AscAutomaticMode | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Describes how status changes are handled. Possible values: Off—No automatic status changes; Manual—The mobile worker can cancel or update the status change; Timed—The mobile worker has a time period to prevent the status change. When the timer ends, the status changes; Automated—The mobile worker is notified that the status has changed. |
| AscCancellationTimerInSec | int | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | For the Timed mode only. Time that the user has to cancel the appointment status change. |
| AscCompletedStatus | picklist | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | Status that indicates that a mobile worker completed a service appointment. Possible values: Canceled, Cannot Complete, Completed, Dispatched, In Progress, None, Scheduled. |
| AscOnSiteStatus | picklist | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | Status that indicates that a mobile worker is at a service appointment. Possible values: Canceled, Cannot Complete, Completed, Dispatched, In Progress, None, Scheduled. |
| AscRadiusInMeters | int | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | Service appointment radius that can trigger a status change. |
| AscTimeLimitationInMin | int | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | A time period when status changes can occur, before an appointment’s scheduled start time and after the scheduled end time. The time is applied only if IsAscTimeLimitEnabled is true. |
| AscTravelStatus | picklist | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | Status that indicates that a mobile worker is traveling to a service appointment. Possible values: Canceled, Cannot Complete, Completed, Dispatched, In Progress, None, Scheduled. |
| BgGeoLocationAccuracy | picklist | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort, Update | The accuracy of geolocation tracking of services resources while the app is running in the background. Lowering accuracy reduces battery consumption for mobile devices. Available in API version 41.0 and later. Picklist options: Medium—Accurate to within about 100 meters; Coarse—Accurate to within about 1 kilometer; Very Coarse—Accurate to within about 3 kilometers. The default value is Coarse. |
| BgGeoLocationMinUpdateFreqMins | int | Create, Defaulted on create, Filter, Group, Sort, Update | The frequency of geolocation poling of services resources while the app is running in the background. Less frequent poling decreases battery consumption for mobile devices. The label in the UI is Minimum Update Frequency of Geo Location in Minutes (Background). Available in API version 41.0 and later. |
| BrandInvertedColor | string | Create, Defaulted on create, Filter, Group, Sort, Update | The color of toasts and the contrast color of the floating action button. |
| ContrastInvertedColor | string | Create, Defaulted on create, Filter, Group, Sort, Update | The color of secondary backgrounds in the UI. |
| ContrastPrimaryColor | string | Create, Defaulted on create, Filter, Group, Sort, Update | The color of primary text. |
| ContrastQuaternaryColor | string | Create, Defaulted on create, Filter, Group, Sort, Update | The color of secondary lines that delineate different areas of the UI. |
| ContrastQuinaryColor | string | Create, Defaulted on create, Filter, Group, Sort, Update | The color of primary backgrounds in the UI. |
| ContrastSecondaryColor | string | Create, Defaulted on create, Filter, Group, Sort, Update | The color of secondary text. |
| ContrastTertiaryColor | string | Create, Defaulted on create, Filter, Group, Sort, Update | The color of the icons on the settings screen and of primary lines that delineate different areas of the UI. |
| DaysBeforeCurrentServiceDate | int | Create, Defaulted on create, Filter, Group, Sort, Update | Days before the current service date during which to prime service documents for offline use. |
| DayAfterCurrentServiceDate [sic — 단수 Day] | int | Create, Defaulted on create, Filter, Group, Sort, Update | Days after the current service date during which to prime service documents for offline use. |
| DefaultListViewDeveloperName | string | Create, Filter, Group, Nillable, Sort, Update | The API name of the default service appointment list view on the schedule screen. |
| DestinationType | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Determines if the mobile worker navigates to the destination based on the address or based on the latitude and longitude. Possible values: Address; Latitude and Longitude. The default value is Address. |
| DeveloperName | string | Create, Filter, Group, Sort, Update | The API name of the set of field service mobile settings. Only users with View DeveloperName OR View Setup and Configuration permission can view, group, sort, and filter this field. |
| FeedbackPrimaryColor | string | Create, Defaulted on create, Filter, Group, Sort, Update | The color of error messages. |
| FeedbackSecondaryColor | string | Create, Defaulted on create, Filter, Group, Sort, Update | The color of success messages. |
| FeedbackSelectedColor | string | Create, Defaulted on create, Group, Sort, Update | The color indicating the user’s current selection. |
| FutureDaysInDatePicker | int | Create, Defaulted on create, Filter, Group, Sort, Update | The number of days into the future that a user can select from the date picker on the schedule screen. |
| GeoLocationAccuracy | picklist | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort, Update | The accuracy of service resource geolocation tracking. Lowering accuracy reduces battery consumption for mobile devices. Picklist values: Fine—Accurate to within 10 meters; Medium—Accurate to within 100 meters; Coarse—Accurate to within 1 kilometer. The default value is Medium. |
| GeoLocationMinUpdateFreqMins | int | Create, Defaulted on create, Filter, Group, Sort, Update | The minimum number of minutes between attempts to poll geolocation. |
| IsAscTimeLimitEnabled | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether AscTimeLimitationInMin is applied. Default is true. |
| IsAssignmentNotification | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Controls whether service appointment notifications are sent when the service resource is assigned the appointment. Default is false. This field is available in API version 46.0 and later. |
| IsDefault | boolean | Defaulted on create, Filter, Group, Sort | Indicates that the set of field service mobile settings is the default set that is automatically assigned to users. You can’t make a different settings record the default, but you can modify the default settings record. Default is false. Available in API version 41.0 and later. |
| IsDispatchNotification | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Controls whether service appointment notifications are sent when the service resource is dispatched for the appointment. Default is false. This field is available in API version 46.0 and later. |
| IsLimitedLocTrackingEnabled | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | When limited tracking for Appointment Assistant is enabled, the mobile worker’s location is shown only on the way to a service appointment. The default value is false. |
| IsOptimizedImageUploadEnabled | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether to configure the size of images uploaded by your mobile workers. To optimize upload speeds, you can limit your file size to a defined maximum size using the OptimizeImageSizeInMb field. Resizing your images affects the resolution of your images. The default value is false. |
| IsScheduleViewResourceAbsences | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Determines whether resource absences appear in the Schedule tab of the mobile app. This field is available in API version 55.0 and later. |
| IsSendLocationHistory | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Controls whether geolocation tracking of services resources is enabled. Default is false. |
| IsShowEditFullRecord | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Controls whether users can edit records with the field service mobile app. Default is false. |
| IsTimeSheetEnabled | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Controls whether users can access time sheets on their mobile devices (Beta). Default is false. |
| IsTimeZoneEnabled | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Controls whether the time zone of timesheet entries on the mobile app is recorded. The current time zone is recorded in the LocationTimeZone field of the TimeSheetEntry object. Default is false. Available in API version 50.0 and later. |
| IsUseSalesforceMobileActions | boolean | Defaulted on create, Filter, Group, Sort | Reserved for future use. |
| Language | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The localization preference for a user. The format is a two letter language code and, if there’s a dialect, followed by the two letter dialect, for example, fr for French, and fr_BE for Belgian French. |
| MasterLabel | string | Create, Filter, Group, Sort, Update | The label in the UI for the set of field service mobile settings. Available in API version 41.0 and later. |
| MaxNumberOfServiceAppointments | int | Create, Defaulted on create, Filter, Group, Sort, Update | Sets the maximum number of service appointments to use for offline priming of service documents. If you don’t have dates on your service appointments, this setting helps to optimize offline priming in place of DaysBeforeCurrentServiceDate and DaysBeforeCurrentServiceDate [sic — 두 번째는 DayAfterCurrentServiceDate여야 맥락상 맞음] fields. |
| MetadataCacheTimeDays | int | Create, Defaulted on create, Filter, Group, Sort, Update | The number of days that org metadata, such as layouts, is kept in the app’s local cache of memory. |
| NavbarBackgroundColor | string | Create, Defaulted on create, Filter, Group, Sort, Update | The color of the top bar in the app. |
| NavbarInvertedColor | string | Create, Defaulted on create, Group, Sort, Update | The secondary color of the tap bar in the app. |
| OptimizeImageSizeInMb | string | Create, Filter, Group, Nillable, Sort, Update | Configure the size of images uploaded by your mobile workers. To optimize upload speeds, you can limit your file size to a defined maximum size. Resizing your images affects the resolution of your images. Enter 0.2 or higher. Used only if IsOptimizedImageUploadEnabled is true. |
| PastDaysInDatePicker | int | Create, Defaulted on create, Filter, Group, Sort, Update | The number of days into the past that a user can select from the date picker on the schedule screen. |
| PrimaryBrandColor | string | Create, Defaulted on create, Filter, Group, Sort, Update | The main branding color used throughout the UI. |
| QuickStatusChangeFlowName | string | Create, Filter, Group, Nillable, Sort, Update | The name of an existing Field Service flow with a Quick Status Change action to change the work order or service appointment status or both. This applies to flows invoked on the mobile app only. This field is available in API version 51.0 and later. |
| RecordDataCacheTimeMins | int | Create, Defaulted on create, Filter, Group, Sort, Update | The number of minutes that record data is kept in the app’s local cache of memory. |
| SecondaryBrandColor | string | Create, Defaulted on create, Filter, Group, Sort, Update | The color of action buttons. |
| TimeIntervalSetupMins | picklist | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort, Update | Controls the spacing of picklist options for time values such as when creating resource absences. |
| UpdateScheduleTimeMins | int | Create, Defaulted on create, Filter, Group, Sort, Update | The minimum number of minutes between attempts to update a user’s schedule. The user’s schedule might not refresh on this cadence if the user’s device isn’t connected to a network or doesn’t have adequate battery life. |

**Usage:** Field Service Mobile settings allow you to create sets of settings to apply to different field service mobile users. The settings apply to both the Android and iOS versions of the app. For example, suppose you want to accommodate workers that are color blind, or who work in dark or bright conditions. You can choose different branding options for different workers to suit their needs, and assign them to their profiles.

**Associated Objects:** `FieldServiceMobileSettingsChangeEvent` (v55.0) — change events are available for the object.

---

## 3. MobileSettingsAssignment

특정 Field Service **모바일 설정 구성을 사용자 프로필에 할당**한다. v41.0+.

**Supported Calls:** `create()`, `delete()`, `describeLayout()` (available in API version 51.0 and later), `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
**Special Access Rules:** Field Service must be enabled.

**Fields (2):**

| Field | Type | Properties | Description |
|---|---|---|---|
| FieldServiceMobileSettingsId | reference | Create, Filter, Group, Sort, Update | The ID of a set of field service mobile settings. |
| ProfileId | reference | Create, Filter, Group, Nillable, Sort, Update | The ID of the profile to associate with the set of field service mobile settings. |

---

## 4. GeolocationBasedAction

사용자가 연결 객체의 영역에 **진입/이탈/내부에 있을 때 트리거되는 지오로케이션 기반 액션**을 나타낸다. v61.0+.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`
**Special Access Rules:** Field Service must be enabled.

**Fields (12):**

| Field | Type | Properties | Description |
|---|---|---|---|
| ActionData | textarea | Create, Nillable, Update | The details of the selected action type. |
| ActionType | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | The type of action. Possible values: PlatformAlert; QuickAction; ViewRecord. |
| Description | textarea | Create, Nillable, Update | The description of the action. |
| InitialTimeInvoked | dateTime | Create, Filter, Nillable, Sort, Update | Captures the first time the mobile worker invoked this action. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The timestamp when the current user last accessed this record indirectly, for example, through a list view or related record. |
| LastTimeInvoked | dateTime | Create, Filter, Nillable, Sort, Update | Captures the last time the mobile worker invoked this action. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The timestamp when the current user last viewed this record or list view. If this value is null, and LastReferenceDate isn’t null, the user accessed this record or list view indirectly. |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | The name of the action. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | ID of the owner of this object. This field is a polymorphic relationship field. Relationship Name: Owner. Relationship Type: Lookup. Refers To: Group, User. |
| Radius | int | Create, Filter, Group, Sort, Update | The distance in meters from the location of the associated object that triggers the action. |
| ReferenceRecordId | reference | Create, Filter, Group, Sort, Update | The ID of the record that the action is associated with. Relationship Name: ReferenceRecord. Relationship Type: Lookup. Refers To: ServiceAppointment. |
| TriggerType | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | The event that triggered this action. Possible values: GeoFenceEnter—Enter; GeoFenceExit—Exit. |

---

## 5. LinkedArticle

작업 주문(work order)/작업 주문 라인 항목(work order line item)/작업 유형(work type)에 첨부된 **지식 문서(Knowledge article)**를 나타낸다. v37.0+.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `undelete()`, `update()`, `upsert()`
**Special Access Rules:** Knowledge must be enabled in your org. Field Service must be enabled. Only users that have access to the Knowledge article and the parent record linked to it can access this object. In Knowledge in Salesforce Classic, only Field Service objects such as Work Order, Work Type, and Work Order Line Item are supported for linked articles. In Lightning Knowledge, other social objects such as Chat, Messaging, Voice Call, and Social Post are supported for linked articles. To call `update()` to attach or detach articles, enable the Read user permission on the Knowledge object and the Edit user permission on the object whose article you update. Available in API version 58.0 and later.

**Fields (7):**

| Field | Type | Properties | Description |
|---|---|---|---|
| CurrencyIsoCode | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Available only for orgs with the multicurrency feature enabled. Contains the ISO code for any currency allowed by the organization. |
| KnowledgeArticleId | reference | Create, Filter, Group, Nillable, Sort | The ID of the Knowledge article attached to the record. The label in the user interface is Knowledge Article ID. |
| KnowledgeArticleVersionId | reference | Create, Filter, Group, Nillable, Sort | The version of the Knowledge article attached to the record. This field lists the title of the attached version and links to the version. The label in the user interface is Article Version. When you attach an article to a work order, that version of the article stays associated with the work order, even if later versions are published. If needed, you can detach and reattach an article to a work order to link the latest version. |
| LinkedEntityId | reference | Create, Filter, Group, Nillable, Sort | The ID of the record that the Knowledge article is attached to. The label in the user interface is Linked Record ID. |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | The title of the article. The label in the user interface is Article Title. |
| RecordTypeId | reference | Create, Filter, Group, Nillable, Sort, Update | The ID of the article’s record type, if used. This field is only available for Lightning Knowledge. |
| Type | string | Filter, Group, Nillable, Sort | (Read only) The type of record that the Knowledge article is attached to. For example, work order. The label in the user interface is Linked Object Type. |

**Usage:** Admins can customize linked articles’ page layouts, fields, validation rules, and more from the Linked Articles page in Setup.

**Associated Objects:**
- `LinkedArticleChangeEvent` (v62.0) — change events are available for the object.
- `LinkedArticleFeed` — feed tracking is available for the object.
- `LinkedArticleHistory` — history is available for tracked fields of the object.

---

## 6. FldSvcObjChg

서비스 약속(service appointment)의 **추적 필드(tracked fields)에 가해진 변경**을 나타낸다. v63.0+.

**Supported Calls:** `describeLayout()`, `describeSObjects()`, `query()`, `retrieve()`
**Special Access Rules:**
- Field Service must be enabled.
- The Field Service managed package must be installed.
- The Track the lifecycle of service appointments setting in Setup > Field Service Settings must be enabled.
- The Platform Integration User must have the Manage Service Appointment Lifecycle and the View Service Appointment Lifecycle permissions.
- To view this object, users must have the View Service Appointment Lifecycle user permission.

**Fields (9):**

| Field | Type | Properties | Description |
|---|---|---|---|
| Activity | picklist | Filter, Group, Nillable, Restricted picklist, Sort | The available scheduling activities for the service appointment. Possible values: AddedToBundle—Currently not supported; BundleMemberAdded—Currently not supported; BundleMemberRemoved—Currently not supported; Created; Deleted; RemovedFromBundle—Currently not supported; Rescheduled—An appointment is considered rescheduled if a change is made to its assigned service resource or to its scheduled start time; Scheduled; ServiceResourceAssigned; StatusChanged—The service appointment status was changed. The manual activities of scheduling, rescheduling, and unscheduling are also reported as status changes because they change the status of an appointment; Unscheduled; Updated—Captures changes made to one or more of the tracked scheduling fields that aren’t associated with another activity. |
| ActivityDetails | string | Filter, Nillable, Sort | Details about the scheduling activity such as the scheduling policy that was used and the unscheduling reason (when applicable). |
| ActivityTimeStamp | dateTime | Filter, Nillable, Sort | Date and time of when the change to the service appointment was made. |
| IsPrimary | boolean | Defaulted on create, Filter, Group, Sort | Indicates whether the change was made directly to the service appointment or indirectly. If the change was made directly to the appointment, it’s flagged as Primary. If it was made to another appointment and affected this one, it’s flagged as Secondary. |
| OriginalSvcAppointment | string | Filter, Group, Nillable, Sort | The ID of the service appointment that was changed. The field value isn’t deleted when the Service Appointment object is deleted. |
| ServiceAppointmentId | reference | Filter, Group, Nillable, Sort | The ID of the service appointment that was changed. Because this is a relationship field, the field value is deleted when the Service Appointment object is deleted. Relationship Name: ServiceAppointment. Relationship Type: Lookup. Refers To: ServiceAppointment. |
| TimeZone | picklist | Filter, Group, Nillable, Restricted picklist, Sort | The time zone of the service appointment or the assigned resource. |
| Transaction | string | Filter, Nillable, Sort | The last transaction ID of the scheduling and optimization request that updated this object. The transaction ID is automatically generated and populated by the Enhanced Scheduling and Optimization engine. |
| UserId | reference | Filter, Group, Nillable, Sort | The user who made the change to the service appointment. If an activity is a scheduled job, it’s registered with the System Administrator user who configured it. Relationship Name: User. Relationship Type: Lookup. Refers To: User. |

**SEE ALSO:** [[#7. FldSvcObjChgDtl]]

---

## 7. FldSvcObjChgDtl

서비스 약속의 추적 필드 **변경의 상세**를 나타낸다. 각 FldSvcObjChg(부모)는 여러 개의 FldSvcObjChgDtl(상세) 레코드를 가질 수 있다. v63.0+.

**Supported Calls:** `describeLayout()`, `describeSObjects()`, `query()`, `retrieve()`
**Special Access Rules:** (FldSvcObjChg와 동일 5항목)
- Field Service must be enabled.
- The Field Service managed package must be installed.
- The Track the lifecycle of service appointments setting in Setup > Field Service Settings must be enabled.
- The Platform Integration User must have the Manage Service Appointment Lifecycle and the View Service Appointment Lifecycle permissions.
- To view this object, users must have the View Service Appointment Lifecycle user permission.

**Fields (3):**

| Field | Type | Properties | Description |
|---|---|---|---|
| FieldChangedName | string | Filter, Group, Sort | The API name of the field that was changed. |
| FieldChangedValue | string | Filter, Nillable, Sort | The updated value of the field that was changed. |
| FldSvcObjChgId | reference | Filter, Group, Sort | The parent record associated with the details of the change. The parent record has multiple detail records associated with it. Each record includes the name and the current value of the tracked fields. Relationship Name: FldSvcObjChg. Relationship Type: Lookup. Refers To: FldSvcObjChg. |

**SEE ALSO:** [[#6. FldSvcObjChg]]

> 부모(FldSvcObjChg)–상세(FldSvcObjChgDtl) 관계는 `FldSvcObjChgId` 룩업으로 연결된다. 두 객체 모두 `query()`·`retrieve()`만 지원하는 읽기 전용 추적 객체다.

```sql
-- 구조 예시 — 실제 동작 쿼리 아님 (FldSvcObjChg → FldSvcObjChgDtl 부모-상세 관계 SOQL)
SELECT Id, Activity, ActivityTimeStamp, IsPrimary, ServiceAppointmentId,
       (SELECT FieldChangedName, FieldChangedValue FROM FldSvcObjChgDtls)
FROM FldSvcObjChg
WHERE ServiceAppointmentId = :appointmentId
ORDER BY ActivityTimeStamp DESC
```

---

## 관련 노트

- [[Field Service 개요와 데이터 모델]] — 전체 데이터 모델 개요와 객체 간 관계도(ER diagram), 이 클러스터의 데이터 모델상 위치
- [[Field Service Objects]] — FSL 표준 객체(ServiceAppointment·WorkOrder·ServiceResource 등) 색인
- [[Field Service Mobile App (LWC)]] — 모바일 앱의 LWC 확장·동작(이 노트의 FieldServiceMobileSettings·AppExtension이 제어하는 앱 자체)
- [[Field Service REST API]] — Field Service REST 리소스(Mobile Settings REST 연계 포함)
