---
tags: [index, search, navigation, field-service]
created: 2026-06-23
---

# SEARCH INDEX — Field Service(현장서비스) (Field Service Developer Guide v67.0 Summer '26)
> Salesforce Field Service(FSL) — 멀티플랫폼·모바일 서비스 운영을 구성·관리하는 고도로 커스터마이즈 가능한 기능 모음. 개요·6개 데이터 모델(Core / Inventory Management / Preventive Maintenance / Product Service Campaign / Warranty Management / Pricing)·오브젝트 관계도·REST/Metadata/Tooling API·FSL Apex Namespace·Custom Triggers·Code Examples·Mobile App LWC. Object References 전 객체 필드 전수 완료(Cycle 2~4로 109개 표준객체 + 9개 표준객체의 FSL__ 관리패키지 커스텀필드 + 57개 보조객체 위키화).
> 루트 라우터: `00 SEARCH_INDEX.md` · 다른 샤드는 라우터에서 이동.
>
> ℹ️ Scheduler(`_index/scheduler.md`)·Service Cloud(`_index/service.md`)와 객체를 공유한다(ServiceResource·ServiceTerritory·OperatingHours·WorkType·ServiceAppointment 등). 데이터 모델·관계도는 이 샤드, 예약(부킹) 흐름은 scheduler 샤드, 옴니채널 라우팅은 service 샤드.

---

## 개요·데이터 모델

| 키워드 | 파일 |
|---|---|
| Field Service, FSL, Field Service Lightning, data model, 데이터 모델, 현장서비스, 필드 서비스, Core Data Model, Inventory Management, Preventive Maintenance, Product Service Campaign, Warranty Management, Pricing, Work Order, Work Order Line Item, Service Appointment, Service Resource, Service Territory, Operating Hours, Maintenance Plan, Product Item, Product Consumed, Warranty Term, Asset Relationship, ER 관계도, 오브젝트 관계도, Field Service가 뭐야, FSL 데이터 모델 구조, work order와 service appointment 관계, field service 오브젝트 어떻게 연결되나 | `FieldService(현장서비스)/Field Service 개요와 데이터 모델.md` |

## REST API

| 키워드 | 파일 |
|---|---|
| Field Service REST API, FS REST, Field Service Flow REST, Field Service Mobile Settings REST, Service Report Template REST, Appointment Bundling API, Create Bundle, Unbundle, Start Batch, FieldServiceMobileSettings userSettings, 현장서비스 REST API, 어포인트먼트 번들링, 서비스 리포트 템플릿, 모바일 설정 REST, Field Service를 REST로 어떻게 호출하나, appointment bundling REST 엔드포인트, 번들 생성·해제 API | `FieldService(현장서비스)/Field Service REST API.md` |

## Metadata·Tooling API

| 키워드 | 파일 |
|---|---|
| FieldServiceSettings, CleanRule, TimeSheetTemplate, Skill metadata, ObjectMapping, ObjectMappingItem, ObjectMappingField, Field Service Metadata API, Field Service Tooling API, FS Metadata API, FS Tooling API, 현장서비스 메타데이터, 현장서비스 툴링 API, Field Service 설정 메타데이터, FieldServiceSettings 필드, TimeSheetTemplate은 Metadata와 Tooling 중 뭐, Skill 메타데이터 타입, Field Service 메타데이터 어떻게 배포하나 | `FieldService(현장서비스)/Field Service Metadata·Tooling API.md` |

## Apex Namespace

| 키워드 | 파일 |
|---|---|
| FSL Namespace, FSL Apex, ScheduleService, OAAS, AppointmentBookingService, GradeSlotsService, ScheduleJobsApi, RecurringAppointmentsManager, managed package Apex, FSL 네임스페이스, 현장서비스 Apex, 예약 스케줄링 Apex, optimization as a service, Apex로 appointment booking 어떻게, FSL 스케줄링 클래스, recurring appointment Apex, FSL과 lxscheduler 차이 | `FieldService(현장서비스)/FSL Apex Namespace.md` |

## Custom Triggers·Code Examples

| 키워드 | 파일 |
|---|---|
| Field Service Triggers, FSL Triggers, Field Service Custom Triggers, Dispatcher Console Custom Actions, CreateFilterEvent__e, createServiceReport, generateWorkOrders, 현장서비스 트리거, 디스패처 콘솔 커스텀 액션, FSL 코드 예제, managed package 트리거 목록, Field Service 트리거 동작, 서비스 리포트 생성 Apex, 작업오더 생성 코드, 디스패처 콘솔에 커스텀 액션 추가 | `FieldService(현장서비스)/Field Service Custom Triggers·Code Examples.md` |

## Mobile App (LWC)

| 키워드 | 파일 |
|---|---|
| Field Service Mobile, FS Mobile LWC, Field Service LWC, Deep Linking, Plug-Ins, BarcodeScanner, AR SpaceCapture, Document Builder LWC, offline, mobile capabilities, 현장서비스 모바일 앱, 딥링킹, 바코드 스캐너, 공간 캡처, 도큐먼트 빌더, Field Service 모바일에서 LWC 어떻게 개발, FS 모바일 플러그인, 오프라인 모바일 워커 컴포넌트 | `FieldService(현장서비스)/Field Service Mobile App (LWC).md` |

## 객체 레퍼런스 (필드 전수)

| 키워드 | 파일 |
|---|---|
| ServiceAppointment, AssignedResource, AssociatedLocation, Address, ServiceAppointmentStatus, 서비스 예약, 배정 리소스, 연결된 위치, 주소 객체, ServiceAppointment 필드, AssignedResource 필드, 서비스 약속 객체 필드가 뭐야, 리소스 배정 객체 필드, 현장서비스 예약 SOAP 객체 | `FieldService(현장서비스)/객체 레퍼런스 — Service Appointment·Resource.md` |
| Asset, AssetWarranty, AssetRelationship, AssetAttribute, AssetDowntimePeriod, AssetAccountParticipant, AssetContactParticipant, AttributeDefinition, AttributePicklist, AttributePicklistValue, WarrantyTerm, ProductWarrantyTerm, 자산, 보증, 자산 속성, 보증 조건, 자산 다운타임, Asset 필드, AssetWarranty 필드, WarrantyTerm 필드, 자산 객체 필드가 뭐야, 보증 조건 객체 필드 | `FieldService(현장서비스)/객체 레퍼런스 — Asset·Attribute·Warranty.md` |
| ServiceContract, ContractLineItem, ContractLineOutcome, ContractLineOutcomeData, Entitlement, EntityMilestone, 서비스 계약, 계약 라인 항목, 엔타이틀먼트, 객체 마일스톤, ServiceContract 필드, Entitlement 필드, 서비스 계약 객체 필드가 뭐야, 엔타이틀먼트 마일스톤 객체 필드 | `FieldService(현장서비스)/객체 레퍼런스 — Service Contract·Entitlement·Milestone.md` |
| ApptBundlePolicy, ApptBundleAggrPolicy, ApptBundleAggrDurDnscale, ApptBundleConfig, ApptBundlePropagatePolicy, ApptBundleRestrictPolicy, ApptBundleSortPolicy, ApptBundlePolicySvcTerr, Appointment Bundling 객체, 예약 번들, 번들 정책, 번들 집계 정책, 번들 정렬 정책, ApptBundlePolicy 필드, appointment bundling 정책 객체 필드가 뭐야, 번들 정책 객체 구조 | `FieldService(현장서비스)/객체 레퍼런스 — Appointment Bundling.md` |
| ServiceResource, ServiceResourceCapacity, ServiceResourceSkill, ServiceCrew, ServiceCrewMember, ResourceAbsence, ResourcePreference, Skill, SkillRequirement, TravelMode, 서비스 리소스, 리소스 용량, 리소스 스킬, 서비스 크루, 크루 멤버, 리소스 부재, 리소스 선호, 스킬, 스킬 요구사항, 이동 모드, ServiceResource 필드, ServiceCrew 필드, Skill 필드, 서비스 리소스 객체 필드가 뭐야, 리소스 스킬·부재 객체 필드, 크루 객체 구조 | `FieldService(현장서비스)/객체 레퍼런스 — Service Resource·Crew·Skill.md` |
| OperatingHours, OperatingHoursHoliday, ServiceTerritory, ServiceTerritoryLocation, ServiceTerritoryMember, Shift, ShiftPattern, ShiftPatternEntry, ShiftTemplate, TimeSlot, 운영 시간, 운영시간 휴일, 서비스 영역, 영역 위치, 영역 멤버, 시프트, 시프트 패턴, 시프트 템플릿, 타임슬롯, ServiceTerritory 필드, OperatingHours 필드, Shift 필드, 서비스 영역 객체 필드가 뭐야, 운영시간·시프트 객체 필드, 타임슬롯 객체 구조 | `FieldService(현장서비스)/객체 레퍼런스 — Service Territory·OperatingHours·Shift.md` |
| Pricebook2, Product2, ProductConsumed, ProductConsumedState, ProductItem, ProductItemTransaction, ProductRequest, ProductRequestLineItem, ProductRequired, ProductTransfer, ReturnOrder, ReturnOrderLineItem, SerializedProduct, SerializedProductTransaction, Shipment, 재고 관리, 제품 항목, 소비 제품, 제품 요청, 제품 이전, 반품 오더, 직렬화 제품, 배송, ProductItem 필드, ReturnOrder 필드, Shipment 필드, 재고 관리 객체 필드가 뭐야, 제품 요청·이전 객체 필드, 반품 오더 객체 구조 | `FieldService(현장서비스)/객체 레퍼런스 — Inventory (Product·ReturnOrder·Shipment).md` |
| Location, MaintenanceAsset, MaintenancePlan, MaintenanceWorkRule, ProductServiceCampaign, ProductServiceCampaignItem, ProductServiceCampaignItemStatus, ProductServiceCampaignStatus, 위치, 유지보수 자산, 유지보수 계획, 유지보수 작업 규칙, 제품 서비스 캠페인, 예방 유지보수, PSC, MaintenancePlan 필드, ProductServiceCampaign 필드, Location 필드, 유지보수 계획 객체 필드가 뭐야, 제품 서비스 캠페인 객체 필드, 위치 객체 구조 | `FieldService(현장서비스)/객체 레퍼런스 — Maintenance·PSC·Location.md` |
| WorkOrder, WorkOrderLineItem, WorkOrderLineItemStatus, WorkOrderStatus, 작업 지시, 작업오더, 작업지시 라인 항목, 작업오더 상태, WorkOrder 필드, WorkOrderLineItem 필드, 작업오더 객체 필드가 뭐야, 작업 지시 라인 항목 객체 필드, 작업오더 상태 객체 구조 | `FieldService(현장서비스)/객체 레퍼런스 — Work Order·WorkOrderLineItem·Status.md` |
| WorkPlan, WorkPlanSelectionRule, WorkPlanTemplate, WorkPlanTemplateEntry, WorkStep, WorkStepStatus, WorkStepTemplate, WorkType, WorkTypeGroup, WorkTypeGroupMember, 작업 계획, 작업 단계, 작업 유형, 작업유형 그룹, 작업계획 템플릿, 작업단계 템플릿, WorkPlan 필드, WorkStep 필드, WorkType 필드, 작업계획 객체 필드가 뭐야, 작업단계·작업유형 객체 필드, 작업유형 그룹 객체 구조 | `FieldService(현장서비스)/객체 레퍼런스 — WorkPlan·WorkStep·WorkType.md` |
| ServiceReport, ServiceReportLayout, DigitalSignature, 서비스 리포트, 서비스 리포트 레이아웃, 전자 서명, 디지털 서명, ServiceReport 필드, ServiceReportLayout 필드, DigitalSignature 필드, 서비스 리포트 객체 필드가 뭐야, 전자서명 객체 필드, 서비스 리포트 레이아웃 객체 구조 | `FieldService(현장서비스)/객체 레퍼런스 — Service Report·Layout·DigitalSignature.md` |
| Expense, ExpenseReport, ExpenseReportEntry, TimeSheet, TimeSheetEntry, 경비, 경비 보고서, 경비보고서 항목, 타임시트, 타임시트 항목, Expense 필드, TimeSheet 필드, ExpenseReport 필드, 경비 객체 필드가 뭐야, 타임시트 객체 필드, 경비보고서 항목 객체 구조 | `FieldService(현장서비스)/객체 레퍼런스 — Expense·TimeSheet.md` |
| WorkCapacityAvailability, WorkCapacityLimit, WorkCapacityUsage, RecordsetFilterCriteria, RecordsetFilterCriteriaRule, RecordsetFltrCritMonitor, 작업 가용량, 작업 용량 한도, 작업 용량 사용량, 레코드셋 필터 기준, 레코드셋 필터 규칙, WorkCapacityLimit 필드, RecordsetFilterCriteria 필드, 작업 가용량 객체 필드가 뭐야, 레코드셋 필터 기준 객체 필드, 작업 용량 사용량 객체 구조 | `FieldService(현장서비스)/객체 레퍼런스 — WorkCapacity·RecordsetFilterCriteria.md` |
| AppExtension, FieldServiceMobileSettings, MobileSettingsAssignment, GeolocationBasedAction, LinkedArticle, FldSvcObjChg, FldSvcObjChgDtl, 모바일 설정, 앱 확장, 지오로케이션 기반 액션, 연결된 지식 문서, 객체 변경, FieldServiceMobileSettings 필드, GeolocationBasedAction 필드, LinkedArticle 필드, 모바일 설정 객체 필드가 뭐야, 지오로케이션 액션 객체 필드, 연결 지식문서·객체변경 객체 구조 | `FieldService(현장서비스)/객체 레퍼런스 — Mobile·Geolocation·LinkedArticle·ObjChange.md` |
| FSL__ custom fields, managed package custom fields, Custom Fields on Standard Objects, AssignedResource FSL 필드, ResourceAbsence FSL 필드, ServiceAppointment FSL 필드, ServiceResource FSL 필드, ServiceResourceCapacity FSL 필드, ServiceTerritory FSL 필드, TimeSlot FSL 필드, WorkOrder FSL 필드, WorkOrderLineItem FSL 필드, FSL 관리패키지 커스텀필드, 표준 객체에 추가되는 FSL 필드, FSL__ 필드가 뭐야, Field Service 관리패키지가 표준객체에 추가하는 필드 | `FieldService(현장서비스)/객체 레퍼런스 — Custom Fields on Standard Objects.md` |
| Supplementary Objects, History, Feed, Share, OwnerSharingRule, 보조 객체, History 객체, Feed 객체, Share 객체, 공유 규칙 객체, Field Service History Feed Share 보조객체, FSL 보조객체 목록, 히스토리·피드·공유 객체가 뭐야, Field Service 보조 객체 전체 목록 | `FieldService(현장서비스)/객체 레퍼런스 — Supplementary Objects (History·Feed·Share).md` |
