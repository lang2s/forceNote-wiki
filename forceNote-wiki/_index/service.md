---
tags: [index, search, navigation, service, knowledge]
created: 2026-06-17
---

# SEARCH INDEX — Service Cloud (Knowledge)
> Salesforce Service Cloud 키워드 → 파일. 현재는 Knowledge(지식) 전반(데이터모델·SOAP/REST/Metadata/UI API + Lightning Knowledge 어드민/셋업/사용)을 다룬다.
> 루트 라우터: `00 SEARCH_INDEX.md` · 다른 도메인은 라우터에서 이동.
> 향후 Service Cloud 확장(Case·Entitlement·OmniChannel·Messaging 등) 시 이 샤드에 누적, 상한 초과 시 하위 샤드로 분할.
> Chat(채팅) = 레거시 Live Agent REST API (2026-02-14 은퇴, 마이그레이션/이력 참조용).

---

## Knowledge — 데이터 모델 & API 개요 (진입 허브)

| 키워드 | 파일 |
|---|---|
| Knowledge Object Model, Knowledge 데이터 모델, 지식 객체 모델, abstract concrete object, Knowledge__ka Knowledge__kav 차이, Lightning Knowledge vs Classic, Salesforce Knowledge 어떻게 시작해, Knowledge API 어떤 게 있어 | `Service(서비스)/Knowledge(지식)/Knowledge 데이터 모델 & API 개요.md` |
| audience channel, 채널, Internal App Customer Partner Pkb, publishing cycle, 발행 주기, draft published archived, data category, 데이터 카테고리 개념, API End-of-Life, API EOL, Knowledge 채널이 뭐야, 아티클 발행 어떻게 돼 | `Service(서비스)/Knowledge(지식)/Knowledge 데이터 모델 & API 개요.md` |

## Knowledge — SOAP API 객체

| 키워드 | 파일 |
|---|---|
| KnowledgeArticle, KnowledgeArticleVersion, __kav, __ka, 아티클 버전, 아티클 객체, 지식 객체 필드, Knowledge__kav 필드, Knowledge 객체 필드 뭐 있어, PublishStatus, IsMasterLanguage, ArchivedById | `Service(서비스)/Knowledge(지식)/Knowledge SOAP API 객체 — 핵심 아티클 객체.md` |
| Knowledge__DataCategorySelection, Knowledge__Feed, 데이터 카테고리 선택, 아티클 피드 객체, 아티클에 데이터 카테고리 어떻게 붙여, Knowledge 핵심 객체 | `Service(서비스)/Knowledge(지식)/Knowledge SOAP API 객체 — 핵심 아티클 객체.md` |
| KnowledgeArticleVersionHistory, KnowledgeArticleViewStat, KnowledgeArticleVoteStat, 아티클 조회수, 아티클 투표 통계, 아티클 버전 히스토리, 아티클 통계 객체 뭐 있어, view vote 통계 | `Service(서비스)/Knowledge(지식)/Knowledge SOAP API 객체 — 통계·연관·주변 객체.md` |
| CaseArticle, LinkedArticle, RecentlyViewed, SearchPromotionRule, TopicAssignment, 케이스 아티클 연관, 연결된 아티클, 검색 프로모션 규칙, 토픽 할당, 케이스에 아티클 어떻게 연결해, 최근 본 아티클 | `Service(서비스)/Knowledge(지식)/Knowledge SOAP API 객체 — 통계·연관·주변 객체.md` |

## Knowledge — SOAP API 호출

| 키워드 | 파일 |
|---|---|
| describeKnowledge, describeKnowledgeSettings, describeDataCategoryGroups, describeDataCategoryGroupStructures, search SOSL, Knowledge SOAP 호출, 데이터 카테고리 그룹 describe, SearchResult, KnowledgeSettings 호출, Knowledge 검색 SOAP 어떻게 해, 데이터 카테고리 구조 어떻게 조회해 | `Service(서비스)/Knowledge(지식)/Knowledge SOAP API 호출.md` |

## Knowledge — REST API

| 키워드 | 파일 |
|---|---|
| Knowledge invocable actions, knowledgeManagement REST, archiveKnowledgeArticles, publishKnowledgeArticles, assignKnowledgeArticles, Manage Knowledge REST, 아티클 발행 REST, 아티클 아카이브 REST, Submit for Translation, 아티클 관리 REST API, masterVersions, translations, Knowledge 아티클 REST로 어떻게 발행해 | `Service(서비스)/Knowledge(지식)/Knowledge REST API — Actions & Manage.md` |
| Knowledge search REST, Parameterized Search, Suggested Articles, suggestTitleMatches, suggestSearchQueries, Autocomplete, Support Knowledge REST, dataCategoryGroups REST, knowledgeArticles REST, articles list detail, 아티클 검색 REST, 추천 아티클 자동완성, Knowledge 검색 자동완성 어떻게 해 | `Service(서비스)/Knowledge(지식)/Knowledge REST API — Search & Support.md` |

## Knowledge — Metadata API 타입

| 키워드 | 파일 |
|---|---|
| ArticleType, ArticleType Layout, ChannelLayout, ArticleType CustomField, KnowledgeSettings, 아티클 타입 메타데이터, 채널 레이아웃, Knowledge 설정 메타데이터, suggestedArticles, 아티클 타입 어떻게 정의해, Knowledge Metadata 타입 뭐 있어 | `Service(서비스)/Knowledge(지식)/Knowledge Metadata API 타입 — 아티클·채널·설정.md` |
| DataCategoryGroup, SearchSettings, SearchLayouts, SynonymDictionary, ExternalDataSource, 데이터 카테고리 그룹 메타데이터, 검색 설정 메타데이터, 동의어 사전, 외부 데이터 소스, Salesforce Connect adapter, 데이터 카테고리 그룹 어떻게 만들어, 동의어 어떻게 설정해 | `Service(서비스)/Knowledge(지식)/Knowledge Metadata API 타입 — 데이터카테고리·검색·외부소스.md` |

## Knowledge — UI API 제약

| 키워드 | 파일 |
|---|---|
| Knowledge UI API, UI API Limitations, Lightning Knowledge UI API, LinkedArticle UI API, CaseArticle UI API, RecordTypeId null, optionalFields, Knowledge UI API 제약, UI API로 아티클 만들 수 있어, Knowledge UI API 한계 뭐야 | `Service(서비스)/Knowledge(지식)/Knowledge UI API 제약.md` |

## Lightning Knowledge — 어드민/셋업/사용 (lightning_knowledge_guide, Spring '26)

| 키워드 | 파일 |
|---|---|
| Lightning Knowledge, Create Knowledge Base, Plan Knowledge, Scalability, Lightning vs Classic, Knowledge Limitations, 지식베이스 계획, 라이트닝 지식 개요, 확장성, 클래식 비교, 지식 한계, Lightning Knowledge 어떻게 계획해, 라이트닝 지식과 클래식 차이가 뭐야, Knowledge 한계가 뭐야 | `Service(서비스)/Knowledge(지식)/Lightning Knowledge 개요 — 계획·비교·한계.md` |
| Enable Lightning Knowledge, Guided Setup, Knowledge Record Type, Page Layout, User Access, Knowledge permissions, Article History, Validation Status, 지식 셋업, Lightning Knowledge 활성화, 가이드 셋업, 레코드 타입, 페이지 레이아웃, 사용자 권한, 검증 상태, 아티클 히스토리, Lightning Knowledge 어떻게 켜, Knowledge 권한 어떻게 줘, 검증 상태 어떻게 켜 | `Service(서비스)/Knowledge(지식)/Lightning Knowledge 셋업 & 구성.md` |
| Authoring Actions, Knowledge Component, Insert into Channels, Share Article URLs, Smart Links, Persistent Links, Search Articles, 작성 액션, 지식 컴포넌트, 채널 삽입, 아티클 URL 공유, 스마트링크, 영구링크, 아티클 검색, Knowledge 컴포넌트 어떻게 써, 스마트링크가 뭐야, 아티클을 채널에 어떻게 삽입해 | `Service(서비스)/Knowledge(지식)/Lightning Knowledge 사용 — 액션·검색·스마트링크·채널.md` |
| Report on Knowledge Articles, Custom Report Type, Knowledge report fields, View Statistics, Vote Statistics, 지식 리포트, 아티클 리포팅, 커스텀 리포트 타입, 조회 통계, 투표 통계, 아티클 리포트 어떻게 만들어, 아티클 조회수 어떻게 봐 | `Service(서비스)/Knowledge(지식)/Lightning Knowledge 아티클 리포팅.md` |
| Import External Content, Knowledge Import, .csv, .zip, import parameters, .properties, Import Export Status, 아티클 임포트, 외부 콘텐츠 가져오기, csv 파일, zip 파일, 임포트 파라미터, properties 파일, 임포트 상태, 외부 아티클 어떻게 임포트해, csv로 아티클 어떻게 올려 | `Service(서비스)/Knowledge(지식)/Lightning Knowledge 아티클 임포트.md` |
| Multiple Languages, Knowledge Translation, Article Management tab, Export for Translation, Publish Translate Archive, Side-By-Side, 다국어, 번역, 아티클 관리 탭, 번역용 내보내기, 발행, 아카이브, 나란히 보기, Knowledge 다국어 어떻게 설정해, 아티클 번역 어떻게 해, 아티클 어떻게 발행하고 아카이브해 | `Service(서비스)/Knowledge(지식)/Lightning Knowledge 다국어 & 번역.md` |
| Data Categories, Category Groups, Data Category Visibility, Category Mapping, Knowledge Sharing, sharing model, 데이터 카테고리, 카테고리 그룹, 데이터 카테고리 가시성, 카테고리 매핑, 공유 모델, 데이터 카테고리 어떻게 만들어, 카테고리 가시성 어떻게 설정해, Knowledge 공유 모델이 뭐야 | `Service(서비스)/Knowledge(지식)/Lightning Knowledge 데이터 카테고리 & 공유.md` |

## Chat — REST API (chat_rest, 레거시 Live Agent · 2026-02-14 은퇴)

| 키워드 | 파일 |
|---|---|
| Chat REST API, Live Agent, Live Agent REST, Chasitor, 채시터, 채팅 REST API, 라이브에이전트, 채팅 세션 시작, Request Headers, 요청 헤더, X-LIVEAGENT-API-VERSION, X-LIVEAGENT-AFFINITY, X-LIVEAGENT-SESSION-KEY, X-LIVEAGENT-SEQUENCE, 세션 시작 확인 종료, Chat REST 어떻게 시작해, Chat 요청 헤더 뭐가 필요해, 네이티브 모바일 앱 채팅, Chat 은퇴, Live Agent 종료, Chat retirement, Messaging for In-App and Web 마이그레이션 | `Service(서비스)/Chat(채팅)/Chat REST API 개요 & 시작.md` |
| long polling, 롱폴링, 메시지 롱폴링, clientPollTimeout, Live Agent, Live Agent REST, Chasitor, 채시터, Messages 폴링, message loop, Estimated Wait Time, 예상 대기시간, EWT Beta, 대기시간 추정, Chat 메시지 어떻게 받아, 새 메시지 어떻게 폴링해, 채팅 대기시간 어떻게 보여줘, Chat 은퇴, Live Agent 종료, Chat retirement, Messaging for In-App and Web 마이그레이션 | `Service(서비스)/Chat(채팅)/Chat REST API 메시지 롱폴링 & 대기시간.md` |
| SessionId, ChasitorInit, ReconnectSession, ChasitorResyncState, Live Agent, Live Agent REST, Chasitor, 채시터, 세션 생성, 방문자 세션, 채팅 세션 초기화, 재연결, resync, Chat 세션 어떻게 생성해, ChasitorInit이 뭐야, 끊긴 채팅 어떻게 재연결해, 방문자 세션 동기화, Chat 은퇴, Live Agent 종료, Chat retirement, Messaging for In-App and Web 마이그레이션 | `Service(서비스)/Chat(채팅)/Chat REST API 리소스 — 세션 생성 & 방문자 세션.md` |
| Monitor Chat Activity, Live Agent, Live Agent REST, Chasitor, 채시터, 채팅 모니터링, Supervisor monitoring, Messages Response Objects, Messages 응답 객체, ChatMessage, ChatEnd, ChasitorTyping, ChasitorNotTyping, ChasitorSneakPeek, CustomEvent, MultiNoun, ChatRequestSuccess, ChatRequestFail, AgentTyping, 슈퍼바이저 모니터링, 채팅 활동 모니터링 어떻게 해, Messages 응답에 뭐가 와, 상담원 타이핑 이벤트, Chat 은퇴, Live Agent 종료, Chat retirement, Messaging for In-App and Web 마이그레이션 | `Service(서비스)/Chat(채팅)/Chat REST API 리소스 — 채팅 모니터링 & Messages 응답 객체.md` |
| Settings, Availability, Breadcrumb, VisitorId, SensitiveDataRuleTriggered, Live Agent, Live Agent REST, Chasitor, 채시터, 방문자 경험, 가용성, 에이전트 가용성, 브레드크럼, 방문자 ID, 민감데이터 규칙, 채팅 가능 여부 어떻게 확인해, 방문자 페이지 추적 breadcrumb, 민감정보 마스킹 규칙, Chat 은퇴, Live Agent 종료, Chat retirement, Messaging for In-App and Web 마이그레이션 | `Service(서비스)/Chat(채팅)/Chat REST API 리소스 — 방문자 경험 커스터마이즈.md` |
| Chat request bodies, Chat response bodies, Live Agent, Live Agent REST, Chasitor, 채시터, 요청 바디, 응답 바디, request body 9종, response body 19종, ChasitorInit body, JSON 바디 필드, Chat REST 요청 바디 뭐가 있어, 응답 바디 필드 전수, POST 바디 구조, Chat 은퇴, Live Agent 종료, Chat retirement, Messaging for In-App and Web 마이그레이션 | `Service(서비스)/Chat(채팅)/Chat REST API 요청 & 응답 바디.md` |
| Chat data types, Live Agent, Live Agent REST, Chasitor, 채시터, 데이터 타입, status codes, 상태 코드, HTTP status, 200 403 503, GeoLocation, Entity, EntityFieldsMaps, 데이터 타입 11종, 상태 코드 10종, Chat REST 상태 코드가 뭐야, Chat 데이터 타입 정의, 403 503 의미, Chat 은퇴, Live Agent 종료, Chat retirement, Messaging for In-App and Web 마이그레이션 | `Service(서비스)/Chat(채팅)/Chat REST API 데이터 타입 & 상태 코드.md` |

## Chat — Developer Guide (chat_dev_guide, Deployment/Pre-Chat/VF · 레거시 Live Agent · 2026-02-14 은퇴)

| 키워드 | 파일 |
|---|---|
| Chat Developer Guide, Deployment API, enableLogging, showWhenOnline, showWhenOffline, startChat, addButtonEventHandler, setChatWindowHeight, 채팅 배포 API, 채팅 로깅·윈도우·버튼, Chat Deployment API 로깅 어떻게 켜, 채팅 버튼 이벤트 핸들러, Chat 은퇴, Live Agent 종료, Messaging for In-App and Web 마이그레이션 | `Service(서비스)/Chat(채팅)/Chat 개발자 가이드 개요 & Deployment API — 로깅·윈도우·버튼.md` |
| Deployment API findOrCreate, doKnowledgeSearch, addCustomDetail, 자동 채팅 초대, 레코드 자동 검색·생성, 코드 샘플, 채팅에서 레코드 자동으로 찾거나 만들기, 자동 채팅 초대 어떻게 띄워, Chat 은퇴, Live Agent 종료, Messaging for In-App and Web 마이그레이션 | `Service(서비스)/Chat(채팅)/Deployment API — 레코드 자동 검색·생성·자동 채팅 초대 & 코드 샘플.md` |
| Pre-Chat API, doFind, isExactMatch, doCreate, displayToAgent, preChatInit, detailCallback, 프리챗, 방문자 정보 수집, Pre-Chat 폼으로 방문자 정보 어떻게 수집해, 채팅 시작 전 컨텍스트 설정, Chat 은퇴, Live Agent 종료, Messaging for In-App and Web 마이그레이션 | `Service(서비스)/Chat(채팅)/Pre-Chat API — 방문자 정보 수집 & 컨텍스트 설정.md` |
| Custom Chat Window, liveAgent components, clientChatQueuePosition, clientChatMessages, clientChatInput, clientChatEndButton, post-chat page, disconnectedBy, direct-to-agent routing, fallback routing, domainMatcher, startChatWithWindow, 커스텀 채팅 윈도우, 포스트챗, 에이전트 직접 라우팅, VF로 채팅창 만들기, 폴백 라우팅, Visualforce로 커스텀 채팅 창 어떻게 만들어, 특정 상담원에게 직접 채팅 보내기, Chat 은퇴, Live Agent 종료, Messaging for In-App and Web 마이그레이션 | `Service(서비스)/Chat(채팅)/커스텀 Chat 윈도우(Visualforce) · Post-Chat · Direct-to-Agent 라우팅.md` |
