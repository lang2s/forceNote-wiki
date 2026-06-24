---
tags: [index, field-service, 현장서비스]
created: 2026-06-23
---

# Field Service(현장서비스) — 로컬 인덱스

> Salesforce Field Service(FSL) 개발자 가이드 기반 — 멀티플랫폼·모바일 서비스 운영의 데이터 모델·오브젝트 레퍼런스·API·Apex·모바일 앱.

**상위:** [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Field Service 개요와 데이터 모델]] | Field Service 개요 + 6개 데이터 모델(Core / Inventory / Preventive Maintenance / Product Service Campaign / Warranty / Pricing)의 오브젝트 관계도(ER) | #field-service |
| [[Field Service REST API]] | Field Service 전용 REST 엔드포인트 — Field Service Flow / Mobile Settings / Service Report Template / Appointment Bundling(Create·Unbundle·Start Batch 등 6 서브 리소스) | #field-service #rest-api |
| [[Field Service Metadata·Tooling API]] | Metadata API 타입(FieldServiceSettings · Skill · TimeSheetTemplate)과 Tooling API 오브젝트(CleanRule · TimeSheetTemplate) 전체 필드·enum 레퍼런스 | #field-service #metadata-api #tooling-api |
| [[FSL Apex Namespace]] | managed package `FSL` Apex 네임스페이스 19개 클래스 전수 — appointment booking·scheduling·optimization(OAAS)·recurring appointment | #field-service #apex-namespace |
| [[Field Service Custom Triggers·Code Examples]] | managed package 24개 트리거 동작 가이드(전수) + Apex 코드 예제 4개(서비스 리포트·작업오더 생성·디스패처 콘솔 커스텀 액션 등) | #field-service #apex-trigger |
| [[Field Service Mobile App (LWC)]] | 모바일 앱 LWC 개발·디버그, Document Builder 커스텀 컴포넌트·딥링킹·플러그인(바코드 스캐너·AR SpaceCapture) | #field-service #mobile #lwc |

### 객체 레퍼런스 (필드 전수)

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[객체 레퍼런스 — Service Appointment·Resource\|객체 레퍼런스 — Service Appointment·Resource]] | Address·AssignedResource·AssociatedLocation·ServiceAppointment·ServiceAppointmentStatus 5개 객체 필드 전수 (약속·리소스 배정·위치 연결) | #field-service #sobject #object-reference |
| [[객체 레퍼런스 — Asset·Attribute·Warranty\|객체 레퍼런스 — Asset·Attribute·Warranty]] | Asset·AssetWarranty·AssetRelationship·AttributeDefinition·WarrantyTerm 등 자산·속성·보증 12개 객체 필드 전수 | #field-service #sobject #object-reference |
| [[객체 레퍼런스 — Service Contract·Entitlement·Milestone\|객체 레퍼런스 — Service Contract·Entitlement·Milestone]] | ServiceContract·ContractLineItem·Entitlement·EntityMilestone 등 서비스 계약·엔타이틀먼트·마일스톤 6개 객체 필드 전수 | #field-service #sobject #object-reference |
| [[객체 레퍼런스 — Appointment Bundling\|객체 레퍼런스 — Appointment Bundling]] | ApptBundlePolicy 허브 중심 집계·전파·제한·정렬·서비스영역 정책 8개 객체 필드 전수 (예약 번들링) | #field-service #sobject #object-reference |
| [[객체 레퍼런스 — Service Resource·Crew·Skill\|객체 레퍼런스 — Service Resource·Crew·Skill]] | ServiceResource·ServiceResourceCapacity·ServiceResourceSkill·ServiceCrew·ServiceCrewMember·ResourceAbsence·ResourcePreference·Skill·SkillRequirement·TravelMode 10개 객체 필드 전수 (인적 자원·용량·스킬·크루·부재) | #field-service #sobject #object-reference |
| [[객체 레퍼런스 — Service Territory·OperatingHours·Shift\|객체 레퍼런스 — Service Territory·OperatingHours·Shift]] | OperatingHours·OperatingHoursHoliday·ServiceTerritory·ServiceTerritoryLocation·ServiceTerritoryMember·Shift·ShiftPattern·ShiftPatternEntry·ShiftTemplate·TimeSlot 10개 객체 필드 전수 (시간·영역·시프트) | #field-service #sobject #object-reference |
| [[객체 레퍼런스 — Inventory (Product·ReturnOrder·Shipment)\|객체 레퍼런스 — Inventory (Product·ReturnOrder·Shipment)]] | Pricebook2·Product2·ProductConsumed·ProductItem·ProductRequest·ProductTransfer·ReturnOrder·SerializedProduct·Shipment 등 재고관리 15개 객체 필드 전수 | #field-service #sobject #object-reference |
| [[객체 레퍼런스 — Maintenance·PSC·Location\|객체 레퍼런스 — Maintenance·PSC·Location]] | Location·MaintenanceAsset·MaintenancePlan·MaintenanceWorkRule·ProductServiceCampaign·ProductServiceCampaignItem 등 예방유지보수·제품서비스캠페인·위치 8개 객체 필드 전수 | #field-service #sobject #object-reference |
| [[객체 레퍼런스 — Work Order·WorkOrderLineItem·Status\|객체 레퍼런스 — Work Order·WorkOrderLineItem·Status]] | WorkOrder·WorkOrderLineItem·WorkOrderLineItemStatus·WorkOrderStatus 4개 객체 필드 전수 (작업지시·라인항목·상태) | #field-service #sobject #object-reference |
| [[객체 레퍼런스 — WorkPlan·WorkStep·WorkType\|객체 레퍼런스 — WorkPlan·WorkStep·WorkType]] | WorkPlan·WorkPlanSelectionRule·WorkPlanTemplate·WorkStep·WorkStepStatus·WorkStepTemplate·WorkType·WorkTypeGroup·WorkTypeGroupMember 등 10개 객체 필드 전수 (작업계획·작업단계·작업유형) | #field-service #sobject #object-reference |
| [[객체 레퍼런스 — Service Report·Layout·DigitalSignature\|객체 레퍼런스 — Service Report·Layout·DigitalSignature]] | ServiceReport·ServiceReportLayout·DigitalSignature 3개 객체 필드 전수 (서비스 리포트·레이아웃·전자서명) | #field-service #sobject #object-reference |
| [[객체 레퍼런스 — Expense·TimeSheet\|객체 레퍼런스 — Expense·TimeSheet]] | Expense·ExpenseReport·ExpenseReportEntry·TimeSheet·TimeSheetEntry 5개 객체 필드 전수 (경비·경비보고서·타임시트) | #field-service #sobject #object-reference |
| [[객체 레퍼런스 — WorkCapacity·RecordsetFilterCriteria\|객체 레퍼런스 — WorkCapacity·RecordsetFilterCriteria]] | WorkCapacityAvailability·WorkCapacityLimit·WorkCapacityUsage·RecordsetFilterCriteria·RecordsetFilterCriteriaRule·RecordsetFltrCritMonitor 6개 객체 필드 전수 (작업가용량·레코드셋 필터) | #field-service #sobject #object-reference |
| [[객체 레퍼런스 — Mobile·Geolocation·LinkedArticle·ObjChange\|객체 레퍼런스 — Mobile·Geolocation·LinkedArticle·ObjChange]] | AppExtension·FieldServiceMobileSettings·MobileSettingsAssignment·GeolocationBasedAction·LinkedArticle·FldSvcObjChg·FldSvcObjChgDtl 7개 객체 필드 전수 (모바일 설정·지오로케이션·연결 지식문서·객체변경) | #field-service #sobject #object-reference |
| [[객체 레퍼런스 — Custom Fields on Standard Objects\|객체 레퍼런스 — Custom Fields on Standard Objects]] | FS 관리패키지가 9개 표준객체(AssignedResource·ResourceAbsence·ServiceAppointment·ServiceResource·ServiceResourceCapacity·ServiceTerritory·TimeSlot·WorkOrder·WorkOrderLineItem)에 추가하는 FSL__ 커스텀필드 전수 | #field-service #sobject #object-reference |
| [[객체 레퍼런스 — Supplementary Objects (History·Feed·Share)\|객체 레퍼런스 — Supplementary Objects (History·Feed·Share)]] | History·Feed·Share·OwnerSharingRule 패턴 57개 보조객체 목록 | #field-service #sobject #object-reference |

---

## 빠른 선택

- Field Service가 뭔지·어떤 오브젝트로 구성되는지 알고 싶다? → [[Field Service 개요와 데이터 모델]]
- work order / service appointment / inventory 객체 관계도가 필요하다? → [[Field Service 개요와 데이터 모델]]
- Appointment Bundling·Field Service Flow를 REST로 호출하고 싶다? → [[Field Service REST API]]
- FieldServiceSettings·Skill·TimeSheetTemplate 메타데이터/툴링 필드가 필요하다? → [[Field Service Metadata·Tooling API]]
- Apex로 예약·스케줄링·최적화(OAAS)를 호출하고 싶다? → [[FSL Apex Namespace]]
- managed package 트리거 동작·Apex 코드 예제가 필요하다? → [[Field Service Custom Triggers·Code Examples]]
- 모바일 앱 LWC·딥링킹·플러그인을 개발하고 싶다? → [[Field Service Mobile App (LWC)]]
- ServiceAppointment·AssignedResource 객체 필드가 필요하다? → [[객체 레퍼런스 — Service Appointment·Resource]]
- Asset·AssetWarranty·WarrantyTerm 객체 필드가 필요하다? → [[객체 레퍼런스 — Asset·Attribute·Warranty]]
- ServiceContract·Entitlement·Milestone 객체 필드가 필요하다? → [[객체 레퍼런스 — Service Contract·Entitlement·Milestone]]
- ApptBundlePolicy 등 Appointment Bundling 정책 객체 필드가 필요하다? → [[객체 레퍼런스 — Appointment Bundling]]
- ServiceResource·ServiceCrew·Skill 등 인적 자원 객체 필드가 필요하다? → [[객체 레퍼런스 — Service Resource·Crew·Skill]]
- ServiceTerritory·OperatingHours·Shift 등 시간·영역 객체 필드가 필요하다? → [[객체 레퍼런스 — Service Territory·OperatingHours·Shift]]
- ProductItem·ReturnOrder·Shipment 등 재고관리 객체 필드가 필요하다? → [[객체 레퍼런스 — Inventory (Product·ReturnOrder·Shipment)]]
- MaintenancePlan·ProductServiceCampaign·Location 등 예방유지보수 객체 필드가 필요하다? → [[객체 레퍼런스 — Maintenance·PSC·Location]]
- WorkOrder·WorkOrderLineItem·상태 객체 필드가 필요하다? → [[객체 레퍼런스 — Work Order·WorkOrderLineItem·Status]]
- WorkPlan·WorkStep·WorkType 등 작업계획·단계·유형 객체 필드가 필요하다? → [[객체 레퍼런스 — WorkPlan·WorkStep·WorkType]]
- ServiceReport·전자서명(DigitalSignature) 객체 필드가 필요하다? → [[객체 레퍼런스 — Service Report·Layout·DigitalSignature]]
- Expense·TimeSheet 등 경비·타임시트 객체 필드가 필요하다? → [[객체 레퍼런스 — Expense·TimeSheet]]
- WorkCapacity·RecordsetFilterCriteria 등 작업가용량·필터 객체 필드가 필요하다? → [[객체 레퍼런스 — WorkCapacity·RecordsetFilterCriteria]]
- 모바일 설정·지오로케이션·LinkedArticle·객체변경 객체 필드가 필요하다? → [[객체 레퍼런스 — Mobile·Geolocation·LinkedArticle·ObjChange]]
- 표준객체에 추가되는 FSL__ 관리패키지 커스텀필드가 필요하다? → [[객체 레퍼런스 — Custom Fields on Standard Objects]]
- History·Feed·Share 등 보조객체 전체 목록이 필요하다? → [[객체 레퍼런스 — Supplementary Objects (History·Feed·Share)]]

---

## 관련 폴더

- 예약(부킹) 스케줄링 → [[Scheduler(스케줄러)/index|Scheduler(스케줄러)]] (ServiceResource·ServiceTerritory·OperatingHours·WorkType 등 객체 공유)
- 옴니채널 라우팅 → [[Service(서비스)/index|Service Cloud]]
