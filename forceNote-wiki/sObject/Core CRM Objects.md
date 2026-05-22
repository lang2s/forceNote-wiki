---
tags: [sobject-reference, standard-objects, core-crm, account, contact, lead, opportunity, campaign]
source: object_reference.pdf (v67.0 Summer '26)
created: 2026-05-22
aliases: [Core CRM Objects, Sales Cloud Objects, Account, Contact, Lead, Opportunity, Campaign, Task, Event, Contract, Quote, Pricebook2, Product2]
---

# Core CRM Objects — 핵심 CRM 및 Sales Cloud 오브젝트

> Object Reference v67.0 Ch6 — 핵심 CRM(Sales Cloud) 도메인 표준 오브젝트 목록

---

## Account 계열

| Object | 설명 |
|---|---|
| `Account` | 회사·조직 레코드. CRM의 핵심 Object |
| `AccountBrand` | 계정 브랜드 정보 |
| `AccountCleanInfo` | Data.com 정리 정보 |
| `AccountContactRelation` | Account-Contact 다대다 관계 |
| `AccountContactRole` | Account의 Contact 역할 |
| `AccountInsight` | Einstein 기반 Account 인사이트 |
| `AccountOwnerSharingRule` | Account 소유자 공유 규칙 |
| `AccountPartner` | Account 간 파트너 관계 |
| `AccountPlan` | 계정 플랜 (Account Plan) |
| `AccountPlanObjective` | 계정 플랜 목표 |
| `AccountPlanObjectiveMeasure` | 계정 플랜 목표 측정값 |
| `AccountPlanObjMeasCalcCond` | 목표 측정 계산 조건 |
| `AccountPlanObjMeasCalcDef` | 목표 측정 계산 정의 |
| `AccountPlanObjMeasCalcDefLocalization` | 목표 측정 계산 정의 현지화 |
| `AccountPlanObjMeasRela` | 목표 측정 관계 |
| `AccountRelationship` | Account 간 관계 |
| `AccountRelationshipShareRule` | Account 관계 공유 규칙 |
| `AccountShare` | Account 공유 항목 |
| `AccountTag` | Account 태그 |
| `AccountTeamMember` | 계정 팀 구성원 |
| `AccountTerritoryAssignmentRule` | 영역 배정 규칙 |
| `AccountTerritoryAssignmentRuleItem` | 영역 배정 규칙 항목 |
| `AccountTerritorySharingRule` | 영역 공유 규칙 |
| `AccountUserTerritory2View` | 사용자 영역 뷰 |

---

## Contact 계열

| Object | 설명 |
|---|---|
| `Contact` | 개인 연락처 |
| `ContactCleanInfo` | Data.com 정리 정보 |
| `ContactDailyMetric` | Contact 일일 지표 |
| `ContactMonthlyMetric` | Contact 월별 지표 |
| `ContactOwnerSharingRule` | Contact 소유자 공유 규칙 |
| `ContactPointAddress` | Contact 포인트 주소 |
| `ContactPointConsent` | Contact 포인트 동의 |
| `ContactPointEmail` | Contact 포인트 이메일 |
| `ContactPointPhone` | Contact 포인트 전화 |
| `ContactPointTypeConsent` | Contact 포인트 타입 동의 |
| `ContactRequest` | Contact 요청 |
| `ContactRequestShare` | Contact 요청 공유 |
| `ContactShare` | Contact 공유 |
| `ContactSuggestionInsight` | Contact 제안 인사이트 |
| `ContactTag` | Contact 태그 |

---

## Lead 계열

| Object | 설명 |
|---|---|
| `Lead` | 잠재 고객 |
| `LeadCleanInfo` | Data.com Lead 정리 정보 |
| `LeadDailyMetric` | Lead 일일 지표 |
| `LeadMonthlyMetric` | Lead 월별 지표 |
| `LeadOwnerSharingRule` | Lead 소유자 공유 규칙 |
| `LeadShare` | Lead 공유 |
| `LeadStatus` | Lead 상태 피클리스트 |
| `LeadTag` | Lead 태그 |

---

## Opportunity 계열

| Object | 설명 |
|---|---|
| `Opportunity` | 영업 기회 |
| `OpportunityCompetitor` | Opportunity 경쟁사 |
| `OpportunityContactRole` | Opportunity의 Contact 역할 |
| `OpportunityContactRoleSuggestionInsight` | Contact 역할 제안 인사이트 |
| `OpportunityFieldHistory` | Opportunity 필드 변경 이력 |
| `OpportunityHistory` | Opportunity Stage 변경 이력 |
| `OpportunityInsight` | Einstein 기반 Opportunity 인사이트 |
| `OpportunityLineItem` | Opportunity 제품 라인 아이템 |
| `OpportunityLineItemSchedule` | 라인 아이템 매출 일정 |
| `OpportunityLineItemSplit` | 라인 아이템 분할 |
| `OpportunityOwnerSharingRule` | Opportunity 소유자 공유 규칙 |
| `OpportunityPartner` | Opportunity 파트너 |
| `OpportunityRelatedDeleteLog` | Opportunity 관련 삭제 로그 |
| `OpportunityShare` | Opportunity 공유 |
| `OpportunitySplit` | Opportunity 수익 분할 |
| `OpportunitySplitType` | Opportunity 분할 타입 |
| `OpportunityStage` | Opportunity Stage 피클리스트 |
| `OpportunityTag` | Opportunity 태그 |
| `OpportunityTeamMember` | 영업 팀 구성원 |
| `OpptyLineItemSplitType` | 라인 아이템 분할 타입 |

---

## Campaign 계열 (Marketing)

| Object | 설명 |
|---|---|
| `Campaign` | 마케팅 캠페인 |
| `CampaignInfluence` | 캠페인 영향 (Attribution) |
| `CampaignInfluenceModel` | Attribution 모델 |
| `CampaignMember` | 캠페인 멤버 |
| `CampaignMemberStatus` | 캠페인 멤버 상태 값 |
| `CampaignOwnerSharingRule` | Campaign 소유자 공유 규칙 |
| `CampaignShare` | Campaign 공유 |
| `CampaignTag` | Campaign 태그 |
| `AttribModel` | Attribution 모델 |
| `AttribModelStage` | Attribution 단계 |
| `AttribModelStageMetric` | Attribution 단계 지표 |

---

## Contract · Quote · Order 계열

| Object | 설명 |
|---|---|
| `Contract` | 계약서 |
| `ContractContactRole` | Contract의 Contact 역할 |
| `ContractStatus` | Contract 상태 피클리스트 |
| `ContractTag` | Contract 태그 |
| `Quote` | 견적서 |
| `QuoteAction` | 견적 작업 |
| `QuoteAdjustmentGroup` | 견적 가격 조정 그룹 |
| `QuoteDocument` | 견적 문서 |
| `QuoteLineGroup` | 견적 라인 그룹 |
| `QuoteLineItem` | 견적 라인 아이템 |
| `QuoteLineItemRecipient` | 견적 라인 아이템 수령인 |
| `QuoteLinePriceAdjustment` | 견적 라인 가격 조정 |
| `QuoteLineRelationship` | 견적 라인 관계 |
| `QuoteItemTaxItem` | 견적 세금 항목 |
| `QuoteLineWorkSource` | 견적 라인 작업 소스 |
| `QuoteRecipientGroup` | 견적 수령인 그룹 |
| `QuoteRecipientGroupMember` | 견적 수령인 그룹 멤버 |
| `Order` | 주문 |
| `OrderItem` | 주문 라인 아이템 |
| `OrderHistory` | 주문 이력 |
| `OrderOwnerSharingRule` | Order 소유자 공유 규칙 |
| `OrderShare` | Order 공유 |
| `OrderStatus` | Order 상태 피클리스트 |

---

## Pricebook · Product 계열

| Object | 설명 |
|---|---|
| `Pricebook2` | 가격표 |
| `Pricebook2History` | 가격표 이력 |
| `PricebookEntry` | 가격표 항목 |
| `PricebookEntryAdjustment` | 가격표 항목 조정 |
| `Product2` | 제품 카탈로그 |
| `Product2DataTranslation` | 제품 데이터 번역 |
| `ProductAttribute` | 제품 속성 |
| `ProductAttributeSet` | 제품 속성 집합 |
| `ProductAttributeSetItem` | 제품 속성 집합 항목 |
| `ProductAttributeSetProduct` | 제품 속성 집합 제품 |
| `ProductCatalog` | 제품 카탈로그 |
| `ProductCategory` | 제품 카테고리 |
| `ProductCategoryProduct` | 제품 카테고리 제품 |
| `ProductCategoryDataTranslation` | 제품 카테고리 번역 |
| `ProductComponentGroup` | 제품 컴포넌트 그룹 |
| `ProductDetectedPriceChange` | 제품 가격 변경 감지 |
| `ProductEntitlementTemplate` | 제품 권한 템플릿 |
| `ProductFeaturedProduct` | 추천 제품 |
| `ProductMedia` | 제품 미디어 |
| `ProductQuantityRule` | 제품 수량 규칙 |
| `ProductRelatedComponent` | 제품 관련 컴포넌트 |
| `ProductRelationshipType` | 제품 관계 타입 |
| `ProductSellingModel` | 제품 판매 모델 |
| `ProductSellingModelOption` | 제품 판매 모델 옵션 |

---

## Activity 계열 (Task · Event)

| Object | 설명 |
|---|---|
| `Task` | 활동 (To-Do) |
| `TaskPriority` | Task 우선순위 피클리스트 |
| `TaskRelation` | Task 관계 |
| `TaskStatus` | Task 상태 피클리스트 |
| `TaskTag` | Task 태그 |
| `TaskWhoRelation` | Task Who 관계 |
| `Event` | 일정·미팅 |
| `EventRelation` | Event 관계 |
| `EventTag` | Event 태그 |
| `EventWhoRelation` | Event Who 관계 |
| `AcceptedEventRelation` | 수락된 Event 관계 |
| `DeclinedEventRelation` | 거절된 Event 관계 |
| `ActivityHistory` | 완료된 활동 이력 |
| `ActivityFieldHistory` | 활동 필드 이력 |
| `ActivityMetric` | 활동 지표 |
| `ActivityUsrConnectionStatus` | 활동 사용자 연결 상태 |
| `OpenActivity` | 미완료 활동 |
| `LookedUpFromActivity` | 활동에서 참조된 레코드 |
| `ActionCadence` | Sales Engagement 카덴스 |
| `ActionCadenceRule` | 카덴스 규칙 |
| `ActionCadenceRuleCondition` | 카덴스 규칙 조건 |
| `ActionCadenceStep` | 카덴스 단계 |
| `ActionCadenceStepTracker` | 카덴스 단계 추적기 |
| `ActionCadenceStepVariant` | 카덴스 단계 변형 |
| `ActionCadenceTracker` | 카덴스 추적기 |
| `ActionCdncStpMonthlyMetric` | 카덴스 단계 월별 지표 |

---

## Territory 계열

| Object | 설명 |
|---|---|
| `UserTerritory` | 사용자-영역 매핑 |
| `Territory2` | 영역 관리 (Enterprise Territory Management) |
| `ObjectTerritory2AssignmentRule` | Object 영역 배정 규칙 |
| `ObjectTerritory2AssignmentRuleItem` | Object 영역 배정 규칙 항목 |
| `ObjectTerritory2Association` | Object 영역 연결 |
| `ObjectUserTerritory2View` | Object 사용자 영역 뷰 |
| `RuleTerritory2Association` | 규칙 영역 연결 |

---

## Forecasting 계열

| Object | 설명 |
|---|---|
| `ForecastingAdjustment` | 예측 조정 |
| `ForecastingColumnDefinition` | 예측 열 정의 |
| `ForecastingColumnDefinitionLocalization` | 예측 열 정의 현지화 |
| `ForecastingCustomCategory` | 커스텀 예측 카테고리 |
| `ForecastingCustomData` | 커스텀 예측 데이터 |
| `ForecastingDisplayedFamily` | 예측 표시 제품 패밀리 |
| `ForecastingFact` | 예측 팩트 |
| `ForecastingFilter` | 예측 필터 |
| `ForecastingFilterCondition` | 예측 필터 조건 |
| `ForecastingGroup` | 예측 그룹 |
| `ForecastingGroupItem` | 예측 그룹 항목 |
| `ForecastingItem` | 예측 항목 |
| `ForecastingOwnerAdjustment` | 예측 소유자 조정 |
| `ForecastingQuota` | 예측 할당량 |
| `ForecastingShare` | 예측 공유 |
| `ForecastingSourceDefinition` | 예측 소스 정의 |
| `ForecastingSrcRecJudgment` | 예측 소스 레코드 판단 |
| `ForecastingSubmission` | 예측 제출 |
| `ForecastingSubmissionItem` | 예측 제출 항목 |
| `ForecastingType` | 예측 타입 |
| `ForecastingTypeSource` | 예측 타입 소스 |
| `ForecastingUserPreference` | 예측 사용자 기본 설정 |
| `FrcstCustmCatgRampRateSrc` | 커스텀 카테고리 램프 비율 소스 |
| `FrcstCustmzAdjustment` | 커스텀 예측 조정 |
| `FrcstCustmzOwnerAdjustment` | 커스텀 예측 소유자 조정 |

---

## 기타 Sales Cloud Objects

| Object | 설명 |
|---|---|
| `Partner` | 파트너 관계 |
| `PartnerFundAllocation` | 파트너 펀드 배정 |
| `PartnerFundClaim` | 파트너 펀드 청구 |
| `PartnerFundRequest` | 파트너 펀드 요청 |
| `PartnerMarketingBudget` | 파트너 마케팅 예산 |
| `PartnerRole` | 파트너 역할 |
| `ChannelProgram` | 채널 프로그램 |
| `ChannelProgramLevel` | 채널 프로그램 레벨 |
| `ChannelProgramMember` | 채널 프로그램 멤버 |
| `DealIndirectPartner` | 간접 파트너 딜 |
| `Scorecard` | 스코어카드 |
| `ScorecardAssociation` | 스코어카드 연결 |
| `ScorecardMetric` | 스코어카드 지표 |
| `PipelineInspectionListView` | 파이프라인 인스펙션 리스트 뷰 |
| `PipelineInspectionSumField` | 파이프라인 인스펙션 요약 필드 |
| `PipelineInspMetricConfig` | 파이프라인 지표 설정 |
| `PipelineInspMetricConfigLocalization` | 파이프라인 지표 설정 현지화 |

---

## SOQL 패턴

```apex
// Account + 관련 Opportunity 쿼리
List<Account> accounts = [
    SELECT Id, Name, Industry, AnnualRevenue,
           (SELECT Id, Name, StageName, Amount, CloseDate FROM Opportunities
            WHERE IsClosed = false ORDER BY CloseDate ASC)
    FROM Account
    WHERE OwnerId = :UserInfo.getUserId()
    WITH USER_MODE
    LIMIT 200
];

// Lead → Contact 변환 후 Opportunity 추적
List<Lead> convertedLeads = [
    SELECT Id, Name, Email, ConvertedDate,
           ConvertedContactId, ConvertedAccountId, ConvertedOpportunityId
    FROM Lead
    WHERE IsConverted = true
    AND ConvertedDate = LAST_N_DAYS:30
    WITH USER_MODE
];

// Campaign 멤버 응답률 집계
AggregateResult[] results = [
    SELECT CampaignId, Status, COUNT(Id) memberCount
    FROM CampaignMember
    WHERE CampaignId = :campaignId
    GROUP BY CampaignId, Status
    WITH USER_MODE
];
```

---

## 관련 노트

- [[6 Standard Objects]] — Ch6 전체 도메인 카탈로그 (상위 파일)
- [[Service Cloud Objects]] — 케이스·서비스 도메인
- [[Platform Admin Objects]] — User·권한 관리
- [[B2B Commerce Objects]] — 상거래 도메인
- [[Object Groups]] — Object 그룹 분류 체계
- [[2 Object Behavior]] — Object 행동 규칙
