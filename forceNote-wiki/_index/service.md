---
tags: [index, search, navigation, service, knowledge]
created: 2026-06-17
---

# SEARCH INDEX — Service Cloud (Knowledge)
> Salesforce Service Cloud 키워드 → 파일. 현재는 Knowledge(지식) 전반(데이터모델·SOAP/REST/Metadata/UI API)을 다룬다.
> 루트 라우터: `00 SEARCH_INDEX.md` · 다른 도메인은 라우터에서 이동.
> 향후 Service Cloud 확장(Case·Entitlement·OmniChannel·Messaging 등) 시 이 샤드에 누적, 상한 초과 시 하위 샤드로 분할.

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
