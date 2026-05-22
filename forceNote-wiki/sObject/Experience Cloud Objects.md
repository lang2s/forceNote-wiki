---
tags: [sobject-reference, standard-objects, experience-cloud, network, community, chatter, collaboration-group, topic, feed-item]
source: object_reference.pdf (v67.0 Summer '26)
created: 2026-05-22
aliases: [Experience Cloud Objects, Network, CollaborationGroup, Topic, FeedItem, Community, Chatter, Idea, Question]
---

# Experience Cloud Objects — Experience Cloud·Chatter·Collaboration 오브젝트

> Object Reference v67.0 Ch6 — Experience Cloud(Communities), Chatter, Collaboration 도메인 표준 오브젝트 목록

---

## Network(Experience Cloud 사이트) 계열

| Object | 설명 |
|---|---|
| `Network` | Experience Cloud 사이트 설정 |
| `NetworkActivityAudit` | 사이트 활동 감사 |
| `NetworkAffinity` | 네트워크 친밀도 |
| `NetworkAuthApiSettings` | 네트워크 인증 API 설정 |
| `NetworkDataCategory` | 네트워크 데이터 카테고리 |
| `NetworkDiscoverableLogin` | 네트워크 검색 가능 로그인 |
| `NetworkEmailTmplAllowlist` | 네트워크 이메일 템플릿 허용 목록 |
| `NetworkFeedResponseMetric` | 네트워크 피드 응답 지표 |
| `NetworkMember` | 사이트 멤버 |
| `NetworkMemberGroup` | 사이트 멤버 그룹 |
| `NetworkModeration` | 네트워크 모더레이션 |
| `NetworkPageOverride` | 네트워크 페이지 재정의 |
| `NetworkSelfRegistration` | 자가 등록 설정 |
| `NetworkUserHistoryRecent` | 네트워크 사용자 최근 이력 |
| `Community (Zone)` | 커뮤니티(Zone) — 구형 Chatter Answers |

---

## CollaborationGroup(Chatter 그룹) 계열

| Object | 설명 |
|---|---|
| `CollaborationGroup` | Chatter 그룹 |
| `CollaborationGroupMember` | Chatter 그룹 멤버 |
| `CollaborationGroupMemberRequest` | Chatter 그룹 멤버 요청 |
| `CollaborationGroupRecord` | Chatter 그룹 레코드 연결 |
| `CollaborationInvitation` | Chatter 초대 |
| `CollaborationRoom` | Slack 연결 Collaboration Room |
| `CollabDocumentMetric` | Collaboration 문서 지표 |
| `CollabDocumentMetricRecord` | Collaboration 문서 지표 레코드 |
| `CollabTemplateMetric` | Collaboration 템플릿 지표 |
| `CollabTemplateMetricRecord` | Collaboration 템플릿 지표 레코드 |
| `CollabUserEngagementMetric` | Collaboration 사용자 참여 지표 |
| `CollabUserEngmtRecordLink` | Collaboration 참여 레코드 링크 |

---

## FeedItem · FeedComment (Chatter 피드)

| Object | 설명 |
|---|---|
| `FeedItem` | Chatter 피드 아이템 |
| `FeedAttachment` | 피드 아이템 첨부 |
| `FeedComment` | Chatter 댓글 |
| `FeedLike` | 좋아요 |
| `FeedPollChoice` | 피드 투표 선택지 |
| `FeedPollVote` | 피드 투표 |
| `FeedPost` | 피드 포스트 (구형) |
| `FeedRevision` | 피드 수정 이력 |
| `feedSignal` | 피드 신호 |
| `FeedTrackedChange` | 피드 추적 변경 |
| `ChatterActivity` | Chatter 활동 통계 |

---

## Topic (주제) 계열

| Object | 설명 |
|---|---|
| `HashtagDefinition` | 해시태그 정의 |

---

## Idea (아이디어)

| Object | 설명 |
|---|---|
| `Idea` | 아이디어 |
| `IdeaComment` | 아이디어 댓글 |
| `IdeaReputation` | 아이디어 명성 |
| `IdeaReputationLevel` | 아이디어 명성 레벨 |
| `IdeaTheme` | 아이디어 테마 |

---

## Question · Reply (Q&A)

| Object | 설명 |
|---|---|
| `Question` | 질문 |
| `QuestionDataCategorySelection` | 질문 데이터 카테고리 선택 |
| `QuestionReportAbuse` | 질문 신고 |
| `QuestionSubscription` | 질문 구독 |
| `Reply` | 답변 |
| `ReplyEmailSettings` | 답변 이메일 설정 |
| `ReplyReportAbuse` | 답변 신고 |
| `ReplyText` | 답변 텍스트 |
| `ChatterAnswersActivity` | Chatter Answers 활동 |
| `ChatterAnswersReputationLevel` | Chatter Answers 명성 레벨 |

---

## Chatter DM (다이렉트 메시지)

| Object | 설명 |
|---|---|
| `ChatterConversation` | Chatter DM 대화 |
| `ChatterConversationMember` | Chatter DM 참여자 |
| `ChatterMessage` | Chatter DM 메시지 |
| `ChatterExtension` | Chatter 확장 앱 |
| `ChatterExtensionConfig` | Chatter 확장 앱 설정 |
| `DirectMessage` | 다이렉트 메시지 (구형) |

---

## Audience · Recommendation (대상 세그먼트·추천)

| Object | 설명 |
|---|---|
| `Audience` | 대상 고객 세그먼트 |
| `Recommendation` | 추천 |
| `RecommendationResponse` | 추천 응답 |
| `ReputationLevel` | 명성 레벨 |
| `ReputationLevelLocalization` | 명성 레벨 현지화 |
| `ReputationPointsRule` | 명성 점수 규칙 |

---

## ManagedContent (CMS)

| Object | 설명 |
|---|---|
| `ManagedContent` | CMS 관리 콘텐츠 |
| `ManagedContentChannel` | CMS 채널 |
| `ManagedContentInfo` | CMS 콘텐츠 정보 |
| `ManagedContentSpace` | CMS 공간 |
| `ManagedContentVariant` | CMS 콘텐츠 변형 |

---

## Navigation · Site 설정

| Object | 설명 |
|---|---|
| `NavigationLinkSet` | 네비게이션 링크 집합 |
| `NavigationMenuItem` | 네비게이션 메뉴 항목 |
| `NavigationMenuItemLocalization` | 네비게이션 메뉴 항목 현지화 |
| `Site` | Experience/Force.com 사이트 |
| `SiteDetail` | 사이트 상세 |
| `SiteDomain` | 사이트 도메인 |
| `SiteHistory` | 사이트 이력 |
| `SiteIframeWhitelistUrl` | 사이트 iframe 허용 URL |
| `SiteRedirectMapping` | 사이트 리다이렉트 매핑 |
| `Domain` | 도메인 |
| `DomainSite` | 도메인-사이트 연결 |

---

## BriefcaseDefinition (Mobile Offline)

| Object | 설명 |
|---|---|
| `BriefcaseDefinition` | 브리프케이스 정의 (모바일 오프라인 데이터 세트) |
| `BriefcaseAssignment` | 브리프케이스 배정 |
| `BriefcaseRule` | 브리프케이스 규칙 |
| `BriefcaseRuleFilter` | 브리프케이스 규칙 필터 |

---

## BroadcastCommunication (브로드캐스트)

| Object | 설명 |
|---|---|
| `BroadcastCommAudience` | 브로드캐스트 커뮤니케이션 대상 |
| `BroadcastCommunication` | 브로드캐스트 커뮤니케이션 |
| `BroadcastTopic` | 브로드캐스트 주제 |
| `BroadcastTopicGroup` | 브로드캐스트 주제 그룹 |
| `BroadcastTopicNetwork` | 브로드캐스트 주제 네트워크 |

---

## Slack 연동

| Object | 설명 |
|---|---|
| `SlackChannelRelatedRecord` | Slack 채널 관련 레코드 |

---

## SOQL 패턴

```apex
// Network(Experience Cloud 사이트) 목록 조회
List<Network> networks = [
    SELECT Id, Name, UrlPathPrefix, Status,
           GuestMemberVisibility, NewSenderAddress
    FROM Network
    WHERE Status = 'Live'
    ORDER BY Name ASC
];

// CollaborationGroup 멤버 조회
List<CollaborationGroupMember> members = [
    SELECT Id, MemberId, Member.Name, Member.Email,
           Role, NotificationFrequency
    FROM CollaborationGroupMember
    WHERE CollaborationGroupId = :groupId
    ORDER BY Member.Name ASC
    WITH USER_MODE
];

// 특정 레코드의 Chatter FeedItem 조회
List<FeedItem> feedItems = [
    SELECT Id, Body, Type, CreatedDate,
           CreatedBy.Name,
           (SELECT Id, CommentBody, CreatedBy.Name
            FROM FeedComments
            ORDER BY CreatedDate ASC)
    FROM FeedItem
    WHERE ParentId = :recordId
    ORDER BY CreatedDate DESC
    LIMIT 50
    WITH USER_MODE
];
```

---

## 관련 노트

- [[6 Standard Objects]] — Ch6 전체 도메인 카탈로그 (상위 파일)
- [[Platform Admin Objects]] — User·Group·권한
- [[Files Objects]] — ContentDocument (Experience Cloud 파일)
- [[Service Cloud Objects]] — Idea·Question (Service Cloud 연계)
- [[Analytics Objects]] — Community 사용 지표
