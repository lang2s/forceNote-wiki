---
tags: [sobject-reference, standard-objects, analytics, reports, dashboard, einstein-analytics, wave]
source: object_reference.pdf (v67.0 Summer '26)
created: 2026-05-22
aliases: [Analytics Objects, Report, Dashboard, AnalyticsDashboard, AnalyticsWorkspace, WaveAutoInstallRequest, DataUsePurpose, DataUseLegalBasis]
---

# Analytics Objects — 분석·리포트 오브젝트

> Object Reference v67.0 Ch6 — Analytics(보고서·대시보드·Einstein Analytics) 도메인 표준 오브젝트 목록

---

## Report · Dashboard (표준 리포트·대시보드)

| Object | 설명 |
|---|---|
| `Report` | 보고서 |
| `ReportTag` | 보고서 태그 |
| `Dashboard` | 대시보드 |
| `DashboardComponent` | 대시보드 컴포넌트 |
| `DashboardTag` | 대시보드 태그 |
| `Folder` | 보고서·대시보드 폴더 |
| `FolderedContentDocument` | 폴더 내 ContentDocument 뷰 |
| `ListView` | 목록 뷰 |
| `ListViewChart` | 목록 뷰 차트 |
| `ListViewChartInstance` | 목록 뷰 차트 인스턴스 |

---

## Einstein Analytics (Tableau CRM / CRM Analytics)

| Object | 설명 |
|---|---|
| `AnalyticsDashboard` | Einstein Analytics 대시보드 |
| `AnalyticsDashboardWidget` | Analytics 대시보드 위젯 |
| `AnalyticsWorkspace` | Analytics 워크스페이스 (App) |
| `AnalyticsWorkspaceAsset` | Analytics 워크스페이스 에셋 |
| `AnalyticsVisualization` | Analytics 시각화 |
| `AnalyticsVizField` | Analytics 시각화 필드 |
| `AnalyticsVizViewDef` | Analytics 시각화 뷰 정의 |
| `AnalyticsAssetAction` | Analytics 에셋 액션 |
| `AnalyticsContainerWidgetDef` | Analytics 컨테이너 위젯 정의 |
| `AnalyticsLicensedAsset` | Analytics 라이선스 에셋 |
| `DatasetExport` | 데이터셋 내보내기 |
| `DatasetExportPart` | 데이터셋 내보내기 파트 |

---

## Einstein Analytics EventLog

| Object | 설명 |
|---|---|
| `AnalyticsChangeEventLog` | Analytics 변경 이벤트 로그 |
| `AnalyticsDownloadEventLog` | Analytics 다운로드 이벤트 로그 |
| `AnalyticsInteractEventLog` | Analytics 인터랙션 이벤트 로그 |
| `AnalyticsPerfEventLog` | Analytics 성능 이벤트 로그 |

---

## Data Quality / Privacy (데이터 품질·프라이버시)

| Object | 설명 |
|---|---|
| `DataUsePurpose` | 데이터 사용 목적 (동의 관리) |
| `DataUseLegalBasis` | 데이터 사용 법적 근거 |
| `Individual` | 개인 레코드 (GDPR 동의 관리) |
| `IndividualApplicationItem` | 개인 앱 항목 |
| `IndividualHistory` | 개인 이력 |
| `IndividualShare` | 개인 공유 |
| `PartyConsent` | 파티 동의 |
| `AuthorizationForm` | 인증 양식 |
| `AuthorizationFormConsent` | 인증 양식 동의 |
| `AuthorizationFormDataUse` | 인증 양식 데이터 사용 |
| `AuthorizationFormText` | 인증 양식 텍스트 |
| `CommSubscription` | 커뮤니케이션 구독 |
| `CommSubscriptionChannelType` | 커뮤니케이션 구독 채널 타입 |
| `CommSubscriptionConsent` | 커뮤니케이션 구독 동의 |
| `CommSubscriptionTiming` | 커뮤니케이션 구독 시기 |
| `EngagementChannelType` | 참여 채널 타입 |
| `EngagementSignal` | 참여 신호 |
| `EngagementSignalCmpndMetric` | 참여 신호 복합 지표 |
| `EngagementSignalMetric` | 참여 신호 지표 |
| `DsarPolicy` | DSAR 정책 (데이터 주체 접근 요청) |
| `DsarPolicyLog` | DSAR 정책 로그 |
| `PrivacyHold` | 프라이버시 보류 |
| `PrivacyHoldReason` | 프라이버시 보류 사유 |
| `PrivacyJobSession` | 프라이버시 작업 세션 |
| `PrivacyObjectSession` | 프라이버시 Object 세션 |
| `PrivacyRequest` | 프라이버시 요청 |
| `PrivacyRTBFRequest` | 삭제 권리(RTBF) 요청 |
| `PrivacySessionRecordFailure` | 프라이버시 세션 레코드 실패 |

---

## Data Assessment / Datacloud (데이터 품질 측정)

| Object | 설명 |
|---|---|
| `DataAssessmentFieldMetric` | 데이터 품질 필드 지표 |
| `DataAssessmentMetric` | 데이터 품질 지표 |
| `DataAssessmentValueMetric` | 데이터 품질 값 지표 |
| `DataStatistics` | 데이터 통계 |
| `DatacloudCompany` | Datacloud 회사 데이터 |
| `DatacloudContact` | Datacloud Contact 데이터 |
| `DatacloudDandBCompany` | Datacloud D&B 회사 데이터 |
| `DatacloudOwnedEntity` | Datacloud 소유 엔티티 |
| `DatacloudPurchaseUsage` | Datacloud 구매 사용량 |
| `DandBCompany` | D&B 회사 정보 |

---

## Data Detection / Masking (데이터 탐지·마스킹)

| Object | 설명 |
|---|---|
| `DataDetectJobObjectSession` | 데이터 탐지 작업 Object 세션 |
| `DataDetectJobSession` | 데이터 탐지 작업 세션 |
| `DataDetectJobSessSummary` | 데이터 탐지 작업 세션 요약 |
| `DataDetectPolicy` | 데이터 탐지 정책 |
| `DataDetectPolicyObject` | 데이터 탐지 정책 Object |
| `DataDetectScanResult` | 데이터 탐지 스캔 결과 |
| `DataDetectPolicyObjField` | 데이터 탐지 정책 Object 필드 |
| `DataDetectPolicySnapshot` | 데이터 탐지 정책 스냅샷 |
| `DataDetPlcyDataSrchExps` | 데이터 탐지 정책 데이터 검색 표현식 |
| `DataDetPlcyMdatScanCrit` | 데이터 탐지 정책 메타데이터 스캔 기준 |
| `DataDetPlcySstvDataCatg` | 데이터 탐지 정책 민감 데이터 카테고리 |
| `DataMaskCustomValueLibrary` | 데이터 마스킹 커스텀 값 라이브러리 |

---

## ML / Einstein Prediction (머신러닝)

| Object | 설명 |
|---|---|
| `AIApplication` | AI 앱 설정 |
| `AIApplicationConfig` | AI 앱 설정 상세 |
| `AiGenActionItem` | AI 생성 액션 항목 |
| `AIInsightAction` | AI 인사이트 실행 |
| `AIInsightFeedback` | AI 인사이트 피드백 |
| `AIInsightReason` | AI 인사이트 근거 |
| `AIInsightValue` | AI 인사이트 값 |
| `AiJobRun` | AI 작업 실행 |
| `AiJobRunItem` | AI 작업 실행 항목 |
| `AiModelLanguage` | AI 모델 언어 |
| `AIRecordInsight` | 레코드 기반 AI 인사이트 |
| `AIResearchPromptResult` | AI 리서치 프롬프트 결과 |
| `MLField` | ML 필드 |
| `MlIntentUtteranceSuggestion` | ML 의도 발화 제안 |
| `MLPredictionDefinition` | ML 예측 정의 |
| `MLModel` | ML 모델 |
| `MLModelFactor` | ML 모델 팩터 |
| `MLModelFactorComponent` | ML 모델 팩터 컴포넌트 |
| `MLModelMetric` | ML 모델 지표 |
| `MLRecommendationDefinition` | ML 추천 정의 |
| `SalesAIScoreCycle` | Sales AI 점수 사이클 |
| `SalesAIScoreModelFactor` | Sales AI 점수 모델 팩터 |
| `ScoreIntelligence` | 점수 인텔리전스 |

---

## GenAI (생성형 AI)

| Object | 설명 |
|---|---|
| `GenAIConversationSummary` | GenAI 대화 요약 |
| `GenAiFunctionDefinition` | GenAI 함수 정의 |
| `GenAiPlannerDefinition` | GenAI 플래너 정의 |
| `GenAiPlannerFunctionDef` | GenAI 플래너 함수 정의 |
| `GenAiPluginDefinition` | GenAI 플러그인 정의 |
| `GenOpPlanRequest` | GenOp 계획 요청 |

---

## ABN Experiment (A/B 테스트)

| Object | 설명 |
|---|---|
| `AbnExperiment` | A/B/N 실험 |
| `AbnExperimentCohort` | A/B/N 실험 코호트 |

---

## SearchActivity / FileSearch

| Object | 설명 |
|---|---|
| `SearchActivity` | 검색 활동 |
| `FileSearchActivity` | 파일 검색 활동 |
| `SearchLayout` | 검색 레이아웃 |
| `SearchPromotionRule` | 검색 프로모션 규칙 |
| `RecentlyViewed` | 최근 조회 항목 |

---

## SOQL 패턴

```apex
// 보고서 목록 조회
List<Report> reports = [
    SELECT Id, Name, DeveloperName, Description,
           FolderName, Format, LastRunDate
    FROM Report
    WHERE FolderName != null
    ORDER BY LastRunDate DESC NULLS LAST
    LIMIT 50
    WITH USER_MODE
];

// Einstein Analytics 워크스페이스 조회
List<AnalyticsWorkspace> workspaces = [
    SELECT Id, Name, Type, SharedWithUser, SharedWithGroup
    FROM AnalyticsWorkspace
    WHERE Namespace = null
    ORDER BY Name ASC
    WITH USER_MODE
];

// Individual + 동의 정보 조회 (GDPR 동의 관리)
List<Individual> individuals = [
    SELECT Id, FirstName, LastName,
           HasOptedOutTracking, HasOptedOutProfiling,
           HasOptedOutGeoTracking
    FROM Individual
    WHERE HasOptedOutTracking = true
    WITH USER_MODE
    LIMIT 200
];
```

---

## 관련 노트

- [[6 Standard Objects]] — Ch6 전체 도메인 카탈로그 (상위 파일)
- [[Platform Admin Objects]] — EventLogFile·LightningUsageMetrics
- [[Data Cloud Objects]] — DLO·DMO·CIO·DG 데이터 클라우드 Object
- [[Files Objects]] — ContentDocument (Report·Dashboard 첨부)
- [[Core CRM Objects]] — 분석 대상 핵심 데이터
