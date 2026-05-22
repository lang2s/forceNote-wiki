---
tags: [sobject-reference, standard-objects, service-cloud, case, entitlement, knowledge, livechat, messaging, omnichannel]
source: object_reference.pdf (v67.0 Summer '26)
created: 2026-05-22
aliases: [Service Cloud Objects, Case, Entitlement, Knowledge, LiveChat, Messaging, Omni-Channel, AgentWork, SLA, ServiceContract]
---

# Service Cloud Objects — 서비스 클라우드 오브젝트

> Object Reference v67.0 Ch6 — Service Cloud 도메인 표준 오브젝트 목록

---

## Case 계열

| Object | 설명 |
|---|---|
| `Case` | 고객 지원 케이스 |
| `CaseArticle` | 케이스 관련 Knowledge 아티클 |
| `CaseComment` | 케이스 댓글 |
| `CaseContactRole` | 케이스의 Contact 역할 |
| `CaseHistory` | 케이스 필드 변경 이력 |
| `CaseHistory2` | 케이스 이력 v2 |
| `CaseMilestone` | 케이스 마일스톤 (Entitlement 기반) |
| `CaseOwnerSharingRule` | Case 소유자 공유 규칙 |
| `CaseParticipant` | 케이스 참여자 |
| `CaseRelatedIssue` | 케이스 관련 이슈 (Incident/Problem 연결) |
| `CaseShare` | Case 공유 |
| `CaseSolution` | 케이스 솔루션 |
| `CaseStatus` | Case 상태 피클리스트 |
| `CaseSubjectParticle` | 케이스 제목 파티클 |
| `CaseTag` | Case 태그 |
| `CaseTeamMember` | 케이스 팀 구성원 |
| `CaseTeamRole` | 케이스 팀 역할 |
| `CaseTeamTemplate` | 케이스 팀 템플릿 |
| `CaseTeamTemplateMember` | 케이스 팀 템플릿 멤버 |
| `CaseTeamTemplateRecord` | 케이스 팀 템플릿 레코드 |

---

## Entitlement · SLA · 서비스 계약

| Object | 설명 |
|---|---|
| `Entitlement` | 지원 권한 정의 |
| `EntitlementContact` | 지원 권한 Contact 연결 |
| `EntitlementTemplate` | 지원 권한 템플릿 |
| `EntityMilestone` | 엔티티 마일스톤 |
| `MilestoneType` | 마일스톤 타입 |
| `SlaProcess` | SLA 프로세스 |
| `BusinessHours` | 비즈니스 시간 설정 |
| `Holiday` | 휴일 설정 |
| `ServiceContract` | 서비스 계약 |
| `ContractLineItem` | 서비스 계약 라인 |
| `ContractLineOutcome` | 계약 라인 결과 |
| `ContractLineOutcomeData` | 계약 라인 결과 데이터 |
| `ServiceContractOwnerSharingRule` | ServiceContract 소유자 공유 규칙 |

---

## Knowledge 계열

| Object | 설명 |
|---|---|
| `Knowledge__ka` | Knowledge 아티클 (마스터) |
| `Knowledge__kav` | Knowledge 아티클 버전 |
| `Knowledge__Feed` | Knowledge 피드 |
| `Knowledge__DataCategorySelection` | Knowledge 데이터 카테고리 선택 |
| `KnowledgeableUser` | 지식 보유 사용자 |
| `KnowledgeArticle` | Knowledge 아티클 (API 접근용) |
| `KnowledgeArticleFeedback` | Knowledge 아티클 피드백 |
| `KnowledgeArticleVersion` | Knowledge 아티클 버전 관리 |
| `KnowledgeArticleVersionHistory` | 아티클 버전 이력 |
| `KnowledgeArticleViewStat` | 아티클 조회 통계 |
| `KnowledgeArticleVoteStat` | 아티클 투표 통계 |
| `ArticleType __DataCategorySelection` | 아티클 타입 데이터 카테고리 선택 |
| `CategoryData` | 카테고리 데이터 |
| `CategoryNode` | 카테고리 노드 |
| `CategoryNodeLocalization` | 카테고리 노드 현지화 |
| `LinkedArticle` | 연결된 아티클 |
| `LinkedArticleFeed` | 연결된 아티클 피드 |
| `LinkedArticleHistory` | 연결된 아티클 이력 |
| `ExtKnowledgeConnector` | 외부 Knowledge 커넥터 |

---

## Omni-Channel · AgentWork

| Object | 설명 |
|---|---|
| `AgentWork` | Omni-Channel 에이전트 업무 배정 |
| `AgentWorkConversationalData` | 에이전트 업무 대화 데이터 |
| `AgentWorkSkill` | 에이전트 업무 스킬 |
| `ServicePresenceStatus` | 에이전트 현재 상태 |
| `QueueRoutingConfig` | 큐 라우팅 설정 |
| `OmniSupervisorConfig` | Omni-Channel 수퍼바이저 설정 |
| `OmniSupervisorConfigAction` | 수퍼바이저 설정 액션 |
| `OmniSupervisorConfigGroup` | 수퍼바이저 설정 그룹 |
| `OmniSupervisorConfigProfile` | 수퍼바이저 설정 프로필 |
| `OmniSupervisorConfigQueue` | 수퍼바이저 설정 큐 |
| `OmniSupervisorConfigSkill` | 수퍼바이저 설정 스킬 |
| `OmniSupervisorConfigTab` | 수퍼바이저 설정 탭 |
| `OmniSupervisorConfigUser` | 수퍼바이저 설정 사용자 |
| `PendingServiceRouting` | 대기 서비스 라우팅 |
| `PendingServiceRoutingInteractionInfo` | 대기 라우팅 인터랙션 정보 |
| `PresenceConfigDeclineReason` | 거절 사유 설정 |
| `PresenceDeclineReason` | 거절 사유 |
| `PresenceUserConfig` | Presence 사용자 설정 |
| `PresenceUserConfigProfile` | Presence 사용자 설정 프로필 |
| `PresenceUserConfigUser` | Presence 사용자 설정 사용자 |
| `ServiceChannel` | 서비스 채널 |
| `ServiceChannelFieldPriority` | 서비스 채널 필드 우선순위 |
| `ServiceChannelStatus` | 서비스 채널 상태 |
| `ServiceChannelStatusField` | 서비스 채널 상태 필드 |

---

## Live Agent · Live Chat

| Object | 설명 |
|---|---|
| `LiveAgentSession` | Live Agent 세션 |
| `LiveAgentSessionHistory` | Live Agent 세션 이력 |
| `LiveAgentSessionShare` | Live Agent 세션 공유 |
| `LiveChatBlockingRule` | Live Chat 차단 규칙 |
| `LiveChatButton` | Live Chat 버튼 설정 |
| `LiveChatButtonDeployment` | Live Chat 버튼 배포 |
| `LiveChatButtonSkill` | Live Chat 버튼 스킬 |
| `LiveChatDeployment` | Live Chat 배포 설정 |
| `LiveChatObjectAccessConfig` | Live Chat Object 접근 설정 |
| `LiveChatObjectAccessDefinition` | Live Chat Object 접근 정의 |
| `LiveChatSensitiveDataRule` | Live Chat 민감 데이터 규칙 |
| `LiveChatTranscript` | Live Chat 기록 |
| `LiveChatTranscriptEvent` | Live Chat 기록 이벤트 |
| `LiveChatTranscriptShare` | Live Chat 기록 공유 |
| `LiveChatTranscriptSkill` | Live Chat 기록 스킬 |
| `LiveChatUserConfig` | Live Chat 사용자 설정 |
| `LiveChatUserConfigProfile` | Live Chat 사용자 설정 프로필 |
| `LiveChatUserConfigUser` | Live Chat 사용자 설정 사용자 |
| `LiveChatVisitor` | Live Chat 방문자 |

---

## Messaging 계열

| Object | 설명 |
|---|---|
| `MessagingChannel` | 메시징 채널 |
| `MessagingChannelSkill` | 메시징 채널 스킬 |
| `MessagingChannelUsage` | 메시징 채널 사용량 |
| `MessagingConfiguration` | 메시징 설정 |
| `MessagingDeliveryError` | 메시징 전달 오류 |
| `MessagingEndUser` | 메시징 최종 사용자 |
| `MessagingLink` | 메시징 링크 |
| `MessagingSession` | Messaging 세션 |
| `MessagingSessionMetrics` | 메시징 세션 지표 |
| `MessagingTemplate` | 메시징 템플릿 |
| `MsgChannelLanguageKeyword` | 메시징 채널 언어 키워드 |
| `MsgChannelUsageExternalOrg` | 메시징 채널 외부 Org 사용 |
| `ConversationChannelDefinition` | 대화 채널 정의 |
| `Conversation` | 대화 레코드 |
| `ConversationEntry` | 대화 항목 |
| `ConversationParticipant` | 대화 참여자 |
| `ConversationContextEntry` | 대화 컨텍스트 항목 |
| `ConvMessageSendRequest` | 메시지 발송 요청 |
| `ConversationVendorInfo` | 대화 벤더 정보 |
| `ExtConvParticipantIntegDef` | 외부 대화 참여자 통합 정의 |
| `ContactCenterChannel` | 컨택 센터 채널 |

---

## VoiceCall · Call Center

| Object | 설명 |
|---|---|
| `VoiceCall` | Voice 통화 기록 |
| `CallCenter` | 콜 센터 설정 |
| `CallCenterRoutingMap` | 콜 센터 라우팅 맵 |
| `CallCoachingMediaProvider` | 통화 코칭 미디어 공급자 |
| `CallCtrAgentFavTrfrDest` | 에이전트 즐겨찾기 전환 목적지 |
| `CallCtrAgentFavTrfrDestShare` | 에이전트 즐겨찾기 전환 목적지 공유 |
| `CallDisposition` | 통화 처리 결과 |
| `CallDispositionCategory` | 통화 처리 결과 카테고리 |
| `CallTemplate` | 통화 템플릿 |
| `ConvAnalysisSummary` | 대화 분석 요약 |
| `ConvAnalysisTopic` | 대화 분석 주제 |
| `ConvAnalysisTopicEntry` | 대화 분석 주제 항목 |
| `ConvIntelligenceSignalRule` | 대화 인텔리전스 신호 규칙 |
| `ConvIntelligenceSignalSubRule` | 대화 인텔리전스 신호 서브 규칙 |
| `ConferenceNumber` | 콘퍼런스 번호 |
| `AdditionalNumber` | 추가 전화번호 |

---

## Survey 계열

| Object | 설명 |
|---|---|
| `Survey` | 설문 조사 |
| `SurveyEmailBranding` | 설문 이메일 브랜딩 |
| `SurveyEngagementContext` | 설문 참여 컨텍스트 |
| `SurveyInvitation` | 설문 초대 |
| `SurveyPage` | 설문 페이지 |
| `SurveyQuestion` | 설문 질문 |
| `SurveyQuestionChoice` | 설문 질문 선택지 |
| `SurveyQuestionResponse` | 설문 질문 응답 |
| `SurveyQuestionScore` | 설문 질문 점수 |
| `SurveyResponse` | 설문 응답 |
| `SurveySubject` | 설문 대상 |
| `SurveyVersion` | 설문 버전 |
| `SurveyVersionAddlInfo` | 설문 버전 추가 정보 |

---

## Incident · Problem · Change Request (ITSM)

| Object | 설명 |
|---|---|
| `Incident` | 인시던트 |
| `IncidentRelatedItem` | 인시던트 관련 항목 |
| `Problem` | 문제 |
| `ProblemIncident` | 문제-인시던트 연결 |
| `ProblemRelatedItem` | 문제 관련 항목 |
| `ChangeRequest` | 변경 요청 |
| `ChangeRequestRelatedIssue` | 변경 요청 관련 이슈 |
| `ChangeRequestRelatedItem` | 변경 요청 관련 항목 |

---

## Macro · Quick Text · Email 서비스

| Object | 설명 |
|---|---|
| `Macro` | 에이전트 매크로 |
| `MacroInstruction` | 매크로 명령 |
| `MacroUsage` | 매크로 사용 통계 |
| `QuickText` | 빠른 답변 텍스트 |
| `QuickTextUsage` | 빠른 답변 사용 통계 |
| `EmailMessage` | 이메일 메시지 |
| `EmailMessageRelation` | 이메일 메시지 관계 |
| `EmailRoutingAddress` | 이메일 라우팅 주소 |
| `EmailServicesAddress` | Apex 이메일 서비스 주소 |
| `EmailServicesFunction` | Apex 이메일 서비스 함수 |
| `EmailStatus` | 이메일 발송 상태 |

---

## Service Catalog

| Object | 설명 |
|---|---|
| `SvcCatalogCategory` | 서비스 카탈로그 카테고리 |
| `SvcCatalogCategoryItem` | 서비스 카탈로그 카테고리 항목 |
| `SvcCatalogFilterCriteria` | 서비스 카탈로그 필터 조건 |
| `SvcCatalogItemDef` | 서비스 카탈로그 항목 정의 |
| `SvcCatalogRequest` | 서비스 카탈로그 요청 |
| `SvcCatalogReqRelatedItem` | 서비스 카탈로그 요청 관련 항목 |

---

## Swarm (Slack / Collaboration)

| Object | 설명 |
|---|---|
| `Swarm` | Swarm (Slack 기반 에스컬레이션) |
| `SwarmMember` | Swarm 멤버 |

---

## Social 계열

| Object | 설명 |
|---|---|
| `SocialPersona` | 소셜 미디어 페르소나 |
| `SocialPost` | 소셜 미디어 포스트 |
| `ExternalSocialAccount` | 외부 소셜 계정 |

---

## SOQL 패턴

```apex
// Case + 첨부 아티클 + 팀 조회
List<Case> cases = [
    SELECT Id, CaseNumber, Subject, Status, Priority, Origin,
           Account.Name, Contact.Name,
           (SELECT ArticleNumber, Title FROM CaseArticles),
           (SELECT Id, MemberId FROM CaseTeamMembers)
    FROM Case
    WHERE IsClosed = false
    AND Priority = 'High'
    ORDER BY CreatedDate DESC
    LIMIT 200
    WITH USER_MODE
];

// Entitlement 유효성 확인
List<Entitlement> entitlements = [
    SELECT Id, Name, Status, StartDate, EndDate,
           AccountId, Account.Name
    FROM Entitlement
    WHERE AccountId = :accountId
    AND Status = 'Active'
    WITH USER_MODE
];

// 오픈 MessagingSession 조회
List<MessagingSession> sessions = [
    SELECT Id, Status, Channel.Name, EndUserAccountId,
           AgentMessageCount, EndUserMessageCount, StartTime
    FROM MessagingSession
    WHERE Status IN ('Active', 'Waiting')
    WITH USER_MODE
];
```

---

## 관련 노트

- [[6 Standard Objects]] — Ch6 전체 도메인 카탈로그 (상위 파일)
- [[Core CRM Objects]] — Account·Contact·Lead·Opportunity
- [[Field Service Objects]] — FSL 서비스 현장 관리
- [[Platform Admin Objects]] — User·권한 관리
- [[Object Groups]] — Object 그룹 분류 체계
