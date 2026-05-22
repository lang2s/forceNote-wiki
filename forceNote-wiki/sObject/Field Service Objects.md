---
tags: [sobject-reference, standard-objects, field-service, fsl, service-appointment, work-order, service-resource, service-territory]
source: object_reference.pdf (v67.0 Summer '26)
created: 2026-05-22
aliases: [Field Service Objects, FSL Objects, ServiceAppointment, WorkOrder, ServiceResource, ServiceTerritory, MaintenancePlan, Skill]
---

# Field Service Objects — 현장 서비스(FSL) 오브젝트

> Object Reference v67.0 Ch6 — Field Service Lightning(FSL) 도메인 표준 오브젝트 목록

---

## ServiceAppointment(서비스 예약) 계열

| Object | 설명 |
|---|---|
| `ServiceAppointment` | 서비스 예약 — FSL의 핵심 스케줄링 Object |
| `ServiceAppointmentStatus` | 서비스 예약 상태 피클리스트 |
| `AssignedResource` | 예약에 배정된 리소스 |
| `ServiceSetupProvisioning` | 서비스 설정 프로비저닝 |

---

## ServiceResource(서비스 리소스) 계열

| Object | 설명 |
|---|---|
| `ServiceResource` | 서비스 리소스 (현장 직원·장비·승무원) |
| `ServiceResourceCapacity` | 서비스 리소스 용량 |
| `ServiceResourceCapacityHistory` | 서비스 리소스 용량 이력 |
| `ServiceResourceDataTranslation` | 서비스 리소스 데이터 번역 |
| `ServiceResourceOwnerSharingRule` | ServiceResource 소유자 공유 규칙 |
| `ServiceResourcePreference` | 서비스 리소스 선호도 |
| `ServiceResourceSkill` | 서비스 리소스 스킬 |
| `ResourceAbsence` | 리소스 부재 |
| `ResourcePreference` | 리소스 선호도 (고객별 선호 기사) |
| `ServiceCrew` | 서비스 승무원 (다수 리소스 그룹) |
| `ServiceCrewMember` | 서비스 승무원 멤버 |
| `ServiceCrewOwnerSharingRule` | ServiceCrew 소유자 공유 규칙 |

---

## ServiceTerritory(서비스 영역) 계열

| Object | 설명 |
|---|---|
| `ServiceTerritory` | 서비스 영역 |
| `ServiceTerritoryDataTranslation` | 서비스 영역 데이터 번역 |
| `ServiceTerritoryLocation` | 서비스 영역 위치 |
| `ServiceTerritoryMember` | 영역 멤버 |
| `ServiceTerritoryWorkType` | 영역 작업 유형 |
| `OperatingHours` | 운영 시간 |
| `OperatingHoursHistory` | 운영 시간 이력 |
| `OperatingHoursHoliday` | 운영 시간 휴일 |

---

## WorkOrder(작업 지시서) 계열

| Object | 설명 |
|---|---|
| `WorkOrder` | 작업 지시서 |
| `WorkOrderLineItem` | 작업 지시서 라인 |
| `ServiceReport` | 서비스 보고서 |
| `ServiceReportLayout` | 서비스 보고서 레이아웃 |
| `ServiceRequest` | 서비스 요청 (표준 서비스 요청 관리) |

---

## MaintenancePlan(유지보수 계획) 계열

| Object | 설명 |
|---|---|
| `MaintenancePlan` | 유지보수 계획 |
| `MaintenanceAsset` | 유지보수 자산 |
| `MaintenanceWorkRule` | 유지보수 작업 규칙 |
| `ProductServiceCampaign` | 제품 서비스 캠페인 |
| `ProductServiceCampaignItem` | 제품 서비스 캠페인 항목 |
| `ProductServiceCampaignItemStatus` | 제품 서비스 캠페인 항목 상태 |
| `ProductServiceCampaignStatus` | 제품 서비스 캠페인 상태 |

---

## Skill(기술·역량) 계열

| Object | 설명 |
|---|---|
| `Skill` | 기술/역량 정의 |
| `SkillLevelDefinition` | 기술 레벨 정의 |
| `SkillLevelProgress` | 기술 레벨 진척도 |
| `SkillProfile` | 기술 프로필 |
| `SkillRequirement` | 작업 기술 요구사항 |
| `SkillUser` | 기술 보유 사용자 |

---

## Scheduling(스케줄링) 계열

| Object | 설명 |
|---|---|
| `AppointmentScheduleAggr` | 예약 스케줄 집계 |
| `AppointmentScheduleLog` | 예약 스케줄 로그 |
| `AppointmentSchedulingPolicy` | 스케줄링 정책 |
| `AppointmentAssignmentPolicy` | 예약 배정 정책 |
| `AppointmentTopicTimeSlot` | 예약 주제 타임 슬롯 |
| `ApptBundleAggrDurDnscale` | 예약 번들 집계 기간 다운스케일 |
| `ApptBundleAggrPolicy` | 예약 번들 집계 정책 |
| `ApptBundleConfig` | 예약 번들 설정 |
| `ApptBundlePolicy` | 예약 번들 정책 |
| `ApptBundlePolicySvcTerr` | 예약 번들 정책-서비스 영역 |
| `ApptBundlePropagatePolicy` | 예약 번들 전파 정책 |
| `ApptBundleRestrictPolicy` | 예약 번들 제한 정책 |
| `ApptBundleSortPolicy` | 예약 번들 정렬 정책 |
| `SchedulingAdherenceDetail` | 스케줄링 준수 상세 |
| `SchedulingAdherenceSummary` | 스케줄링 준수 요약 |
| `SchedulingConstraint` | 스케줄링 제약 |
| `SchedulingObjective` | 스케줄링 목표 |
| `SchedulingRule` | 스케줄링 규칙 |
| `SchedulingRuleParameter` | 스케줄링 규칙 매개변수 |

---

## Asset(자산) 계열

| Object | 설명 |
|---|---|
| `Asset` | 자산 (설치된 제품) |
| `AssetAction` | 자산 액션 (상태 변경 기록) |
| `AssetActionSource` | 자산 액션 소스 |
| `AssetAttribute` | 자산 속성 |
| `AssetContractRelationship` | 자산-계약 관계 |
| `AssetDowntimePeriod` | 자산 다운타임 기간 |
| `AssetOwnerSharingRule` | Asset 소유자 공유 규칙 |
| `AssetRateAdjustment` | 자산 요율 조정 |
| `AssetRateCardEntry` | 자산 요율 카드 항목 |
| `AssetRelationship` | 자산 관계 |
| `AssetShare` | Asset 공유 |
| `AssetStatePeriod` | 자산 상태 기간 |
| `AssetStatePeriodAttribute` | 자산 상태 기간 속성 |
| `AssetTag` | Asset 태그 |
| `AssetTokenEvent` | 자산 토큰 이벤트 |
| `AssetWarranty` | 자산 보증 |
| `ProductWarrantyTerm` | 제품 보증 조건 |

---

## Shift(교대 근무) 계열

| Object | 설명 |
|---|---|
| `Shift` | 교대 근무 |
| `ShiftHistory` | 교대 근무 이력 |
| `ShiftOwnerSharingRule` | Shift 소유자 공유 규칙 |
| `ShiftPattern` | 교대 근무 패턴 |
| `ShiftPatternEntry` | 교대 근무 패턴 항목 |
| `ShiftSegment` | 교대 근무 세그먼트 |
| `ShiftSegmentType` | 교대 근무 세그먼트 타입 |
| `ShiftShare` | Shift 공유 |
| `ShiftStatus` | Shift 상태 |
| `ShiftTemplate` | 교대 근무 템플릿 |
| `JobProfile` | 직무 프로필 |
| `JobProfileQueueGroup` | 직무 프로필 큐 그룹 |

---

## Field Service 설정 Object

| Object | 설명 |
|---|---|
| `FieldServiceMobileSettings` | FSL 모바일 설정 |
| `FieldServiceOrgSettings` | FSL Org 설정 |
| `FldSvcObjChg` | FSL Object 변경 감지 |
| `FldSvcObjChgDtl` | FSL Object 변경 감지 상세 |

---

## SOQL 패턴

```apex
// ServiceAppointment + AssignedResource 조회
List<ServiceAppointment> appointments = [
    SELECT Id, AppointmentNumber, Status, ArrivalWindowStartTime,
           ArrivalWindowEndTime, WorkTypeId, ServiceTerritoryId,
           (SELECT Id, ServiceResourceId, ServiceResource.Name
            FROM ServiceAppointmentResources)
    FROM ServiceAppointment
    WHERE Status IN ('Scheduled', 'Dispatched')
    AND SchedStartTime >= :System.today()
    ORDER BY SchedStartTime ASC
    WITH USER_MODE
    LIMIT 200
];

// WorkOrder + 관련 ProductConsumed 조회
List<WorkOrder> workOrders = [
    SELECT Id, WorkOrderNumber, Status, Subject,
           AccountId, Account.Name,
           (SELECT Id, Product2Id, Product2.Name, QuantityConsumed
            FROM ProductsConsumed)
    FROM WorkOrder
    WHERE Status != 'Completed'
    WITH USER_MODE
];

// ServiceResource + Skill 조회
List<ServiceResource> resources = [
    SELECT Id, Name, IsActive, ResourceType,
           (SELECT Id, Skill.MasterLabel, SkillLevel
            FROM ServiceResourceSkills
            WHERE IsActive = true)
    FROM ServiceResource
    WHERE IsActive = true
    AND RelatedRecordId IN :technicianIds
    WITH USER_MODE
];
```

---

## 관련 노트

- [[6 Standard Objects]] — Ch6 전체 도메인 카탈로그 (상위 파일)
- [[Service Cloud Objects]] — Case·Entitlement·SLA 서비스 클라우드
- [[Core CRM Objects]] — Account·Contact 기반 데이터
- [[B2B Commerce Objects]] — ProductItem·ProductRequest 공용
- [[4 Custom Objects]] — FSL__Time_Dependency__c 관리 패키지
