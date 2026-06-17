---
tags: [index, service, knowledge, 지식]
created: 2026-06-17
---

# Knowledge(지식) — 로컬 인덱스

> Salesforce Knowledge 위키 — (A) 개발자/API: 개발 가이드(v67.0 Summer '26) 기반 데이터 모델·SOAP/REST/Metadata/UI API 9개 + (B) 어드민/셋업: Lightning Knowledge 가이드(Spring '26) 기반 계획·셋업·사용·리포팅·임포트·번역·데이터 카테고리 7개 = 총 16개 위키

**상위:** [[Service(서비스)/index|Service Cloud]] → [[00 Home]]

---

## 파일 목록 — (A) 개발자 / API (데이터 모델·SOAP·REST·Metadata·UI API)

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Knowledge 데이터 모델 & API 개요]] | abstract/concrete 객체 모델·채널·발행 주기·데이터 카테고리·API EOL — 진입 허브 | #overview |
| [[Knowledge SOAP API 객체 — 핵심 아티클 객체]] | KnowledgeArticle·KnowledgeArticleVersion·Knowledge__DataCategorySelection·Knowledge__Feed·Knowledge__kav·Knowledge__ka 6개 객체 필드 전수 | #reference |
| [[Knowledge SOAP API 객체 — 통계·연관·주변 객체]] | VersionHistory·ViewStat·VoteStat·CaseArticle·LinkedArticle·RecentlyViewed·SearchPromotionRule·TopicAssignment 8개 객체 | #reference |
| [[Knowledge SOAP API 호출]] | describeKnowledge·describeDataCategoryGroups·describeDataCategoryGroupStructures·search 4개 호출 시그니처·예제 | #reference |
| [[Knowledge REST API — Actions & Manage]] | invocable action 8종 + knowledgeManagement REST 19종 — 아티클·번역 관리(Archive/Publish/Edit/Delete/Restore/Submit for Translation) | #reference |
| [[Knowledge REST API — Search & Support]] | Parameterized Search·Suggestions·Autocomplete + Support Knowledge(Data Category Groups·Articles List/Details) | #reference |
| [[Knowledge Metadata API 타입 — 아티클·채널·설정]] | ArticleType(+Layout, +CustomField)·ChannelLayout·KnowledgeSettings 메타데이터 타입 | #reference |
| [[Knowledge Metadata API 타입 — 데이터카테고리·검색·외부소스]] | DataCategoryGroup·SearchSettings·SearchLayouts·SynonymDictionary·ExternalDataSource | #reference |
| [[Knowledge UI API 제약]] | Lightning Knowledge용 UI API의 4가지 알려진 제약 (Classic 미지원) | #limitation |

---

## 파일 목록 — (B) 어드민 / 셋업 (Lightning Knowledge 가이드, Spring '26)

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Lightning Knowledge 개요 — 계획·비교·한계]] | Knowledge Base 계획·확장성·Lightning vs Classic 비교·Limitations | #overview |
| [[Lightning Knowledge 셋업 & 구성]] | 활성화·Guided Setup·레코드 타입·페이지 레이아웃·사용자 권한·Article History·Validation Status | #setup |
| [[Lightning Knowledge 사용 — 액션·검색·스마트링크·채널]] | 작성 액션·Knowledge 컴포넌트·채널 삽입·아티클 URL 공유·Smart/Persistent Links·검색 | #howto |
| [[Lightning Knowledge 아티클 리포팅]] | Knowledge 아티클 리포트·Custom Report Type·리포트 필드·조회/투표 통계 | #howto |
| [[Lightning Knowledge 아티클 임포트]] | 외부 콘텐츠 임포트(.csv/.zip)·import 파라미터·.properties·Import/Export Status | #howto |
| [[Lightning Knowledge 다국어 & 번역]] | Multiple Languages·Article Management 탭·Export for Translation·Publish/Translate/Archive·Side-By-Side | #howto |
| [[Lightning Knowledge 데이터 카테고리 & 공유]] | Data Categories·Category Groups·가시성·매핑·sharing model | #howto |

---

## 빠른 선택

### 어드민 / 셋업 (계획 → 셋업 → 사용 → 운영)

- 도입 계획·확장성·Classic 비교·한계 큰 그림 → [[Lightning Knowledge 개요 — 계획·비교·한계]]
- Lightning Knowledge 활성화·권한·레코드 타입·검증 상태 설정 → [[Lightning Knowledge 셋업 & 구성]]
- 작성 액션·Knowledge 컴포넌트·스마트링크·채널 삽입·검색 사용법 → [[Lightning Knowledge 사용 — 액션·검색·스마트링크·채널]]
- 아티클 조회/투표 통계·커스텀 리포트 타입 → [[Lightning Knowledge 아티클 리포팅]]
- 외부 콘텐츠 .csv/.zip 임포트·import 파라미터·상태 → [[Lightning Knowledge 아티클 임포트]]
- 다국어·번역·발행/아카이브·나란히 보기 → [[Lightning Knowledge 다국어 & 번역]]
- 데이터 카테고리·그룹·가시성·공유 모델 → [[Lightning Knowledge 데이터 카테고리 & 공유]]

### 개발자 / API (데이터모델 → SOAP객체 → SOAP호출 → REST → Metadata → UI)

- 처음 시작 / 객체 모델·채널·발행 주기·EOL 큰 그림 → [[Knowledge 데이터 모델 & API 개요]]
- 아티클 객체 필드(__kav·__ka·PublishStatus 등) 찾을 때 → [[Knowledge SOAP API 객체 — 핵심 아티클 객체]]
- 통계·연관(ViewStat·CaseArticle·LinkedArticle 등) 객체 → [[Knowledge SOAP API 객체 — 통계·연관·주변 객체]]
- SOAP 호출(describe·search SOSL)로 메타데이터·검색 → [[Knowledge SOAP API 호출]]
- REST로 아티클 발행·아카이브·번역 관리 → [[Knowledge REST API — Actions & Manage]]
- REST로 아티클 검색·추천·자동완성 → [[Knowledge REST API — Search & Support]]
- 아티클 타입·채널 레이아웃·설정 메타데이터 정의 → [[Knowledge Metadata API 타입 — 아티클·채널·설정]]
- 데이터 카테고리 그룹·동의어·외부 소스 메타데이터 → [[Knowledge Metadata API 타입 — 데이터카테고리·검색·외부소스]]
- UI API로 Lightning Knowledge UI 만들 때 제약 확인 → [[Knowledge UI API 제약]]

---

## 관련 폴더

- 서비스 도메인 허브 → [[Service(서비스)/index|Service Cloud]]
- Knowledge 표준 Object 카탈로그 → [[Service Cloud Objects]]
- Knowledge VF 컨트롤러(KnowledgeArticleVersionStandardController) → [[Architecture(아키텍처)/ApexPages Namespace]]
