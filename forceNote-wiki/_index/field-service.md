---
tags: [index, search, navigation, field-service]
created: 2026-06-23
---

# SEARCH INDEX — Field Service(현장서비스) (Field Service Developer Guide v67.0 Summer '26)
> Salesforce Field Service(FSL) — 멀티플랫폼·모바일 서비스 운영을 구성·관리하는 고도로 커스터마이즈 가능한 기능 모음. 개요·6개 데이터 모델(Core / Inventory Management / Preventive Maintenance / Product Service Campaign / Warranty Management / Pricing)·오브젝트 관계도·REST/Metadata/Tooling API·FSL Apex Namespace·Custom Triggers·Code Examples·Mobile App LWC. (Object References 108객체 필드 전수는 후속 Cycle에서 추가 예정)
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
