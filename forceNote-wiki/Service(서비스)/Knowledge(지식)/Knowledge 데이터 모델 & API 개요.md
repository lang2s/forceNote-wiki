---
tags: [Service, Knowledge, 지식, 데이터모델, API개요, abstract-concrete, data-category]
source: salesforce_knowledge_dev_guide.pdf (v67.0 Summer '26, Ch1 PDF p6–13)
created: 2026-06-17
aliases: [Knowledge Object Model, Knowledge 데이터 모델, abstract concrete object, KnowledgeArticle KnowledgeArticleVersion, Lightning Knowledge vs Classic, audience channel, publishing cycle, data category API, API End-of-Life]
---

# Knowledge 데이터 모델 & API 개요

> Salesforce Knowledge는 abstract 객체(KnowledgeArticle / KnowledgeArticleVersion)와 그로부터 파생된 concrete 객체(Knowledge__ka / Knowledge__kav)로 구성되며, Lightning Knowledge와 Salesforce Classic 양쪽을 지원한다. 이 노트는 객체 모델·채널·발행 주기·데이터 카테고리·API EOL 정책을 다룬다.

---

## 1. Developing with Salesforce Knowledge (Ch1 인트로)

Salesforce Knowledge는 웹사이트 방문자·고객·파트너·서비스 상담원에게 지원을 제공한다. 회사 정보를 만들고 관리하며 필요할 때 안전하게 공유할 수 있다. 대부분 기능은 declarative(point-and-click)이지만, API를 통해 케이스 deflection·고객 만족·상담원 생산성을 코드로 구현할 수 있다. 이 가이드는 **Lightning Knowledge**와 **Knowledge in Salesforce Classic** 양쪽을 다룬다.

Ch1 하위 주제: Knowledge Object Model · Knowledge Articles and Data Categories in the API · API End-of-Life Policy.

---

## 2. Knowledge Object Model

Knowledge 객체 모델은 다른 기능 영역과 약간 다르다. 아티클을 만들 때 직접 사용하지 않는 **abstract Salesforce 객체** 집합을 노출하고, 이 abstract 객체가 실제로 사용하는 **concrete 파생(derivation)** 을 포함한다. 이 아키텍처는 Lightning Knowledge와 Salesforce Classic을 지원하기 위해 검색 동작에 더 많은 유연성을 준다.

### Core Knowledge Objects (abstract)

| 객체 | 설명 |
|---|---|
| **KnowledgeArticle** | abstract Knowledge article 객체. 아티클의 버전·번역·상태와 무관하게 아티클에 대한 metadata를 담는다. |
| **KnowledgeArticleVersion** | abstract Knowledge article version 객체. 아티클 초안을 만들 때마다 새 version 번호와 고유 ID가 부여된다. 각 번역도 version과 ID를 가진다. 각 version은 KnowledgeArticle 레코드를 부모로 갖는 KnowledgeArticleVersion 레코드다. |

### Concrete 객체

아티클을 만들 때는 **concrete Salesforce 객체**로 레코드를 생성한다. 이 객체들은 abstract 객체로부터 상속한다. Lightning Knowledge에서 기본 이름은 아티클이 **`Knowledge__ka`**, 아티클 버전이 **`Knowledge__kav`** 이다.

- 기본 이름은 Lightning Knowledge의 concrete 구현이며 변경 가능하다. 접미사 **`__ka`**(article)·**`__kav`**(article version)는 항상 유지된다. `Knowledge` 접두사는 Object Manager에서 Knowledge__kav 객체의 Object Name을 변경해 바꿀 수 있다.
- concrete 구현은 아티클의 custom field를 포함한다. Knowledge__kav 객체는 또한 **`RecordTypeId`** field를 포함한다 — 아티클 구조(FAQ, Tutorial 등)를 기술하는 record type. 각 record type은 자체 layout을 가질 수 있다(예: FAQ record type은 `Question__c`, `Answer__c` 같은 custom field를 표시하는 special layout).
- **Salesforce Classic** 에서는 아티클 구조가 **article type**으로 결정된다. 각 article type은 다른 concrete 구현을 가진다(예: `FAQ__kav`, `Tutorial__kav`). **Lightning Knowledge** 에서는 하나의 concrete object(예: Knowledge__kav)를 쓰고, 대신 record type으로 아티클을 고유한 구조와 연결한다.

### Abstract ↔ Concrete 매핑

```
// 구조 예시 — 실제 원본 다이어그램 아님 (PDF p7–8 이미지를 텍스트화. pdftoppm 렌더 + Read로 직접 판독)

[Abstract Object]            derived from →   [Concrete Object]
 Id                                            Id
 Other Fields...                               Inherits Abstract Object Fields...
                                               Includes Additional Fields...

KnowledgeArticle         ── derived from ─→  Knowledge__ka
  Id / ArticleNumber / ...                    Id / ArticleNumber / ...

KnowledgeArticleVersion  ── derived from ─→  Knowledge__kav
  Id / KnowledgeArticleId / ...               Id / KnowledgeArticleId /
                                              RecordTypeId (for article type) / ...

(KnowledgeArticle ← parent ─ KnowledgeArticleVersion)
```

### Complete Knowledge Object Diagram

PDF p9–10에는 아티클과 다른 객체들의 관계를 보여주는 다이어그램이 있다(3색 범례: **파란색 = Abstract Knowledge Object, 노란색 = Concrete Knowledge Object, 주황색 = Other Salesforce Object**). 아래는 그 이미지를 직접 판독해 텍스트화한 것이다.

```
// 구조 예시 — 실제 원본 다이어그램 아님 (PDF p10 이미지를 pdftoppm 400dpi 4분할 + Read로 직접 판독해 텍스트화)

Vote (주황) ───────────────────────────────────────────→ Knowledge__ka
KnowledgeArticleVoteStat (파랑)        ─ derived from ─→  Knowledge__VoteStat (노랑)
KnowledgeArticleViewStat (파랑)        ─ derived from ─→  Knowledge__ViewStat (노랑)
KnowledgeArticleVersionHistory (파랑)  ─ derived from ─→  Knowledge__VersionHistory (노랑)
KnowledgeArticle (파랑)                ─ derived from ─→  Knowledge__ka (노랑)
KnowledgeArticleVersion (파랑)         ─ derived from ─→  Knowledge__kav (노랑)

Case (주황) ──CaseId──→ CaseArticle (노랑) ──KnowledgeArticleId──→ Knowledge__ka
WorkOrder or WorkOrderLineItem (주황) ──LinkedEntityId──→ LinkedArticle (노랑)
LinkedArticle ──ParentId──→ LinkedArticleFeed (노랑)
LinkedArticle ──LinkedArticleId──→ LinkedArticleHistory (노랑)
FeedComment (주황) ──ParentId──→ Knowledge__Feed (노랑) ──ParentId──→ Knowledge__ka
Knowledge__DataCategorySelection (노랑) ──ParentId──→ Knowledge__ka

관계 라벨 키: ParentId, KnowledgeArticleId, CaseId, LinkedEntityId, LinkedArticleId
```

> 위 다이어그램의 박스 내 `...`으로 생략된 필드는 이미지에서 읽히지 않는다. 각 객체의 전체 필드는 [[Knowledge SOAP API 객체 — 핵심 아티클 객체]] · [[Knowledge SOAP API 객체 — 통계·연관·주변 객체]]의 Fields 표를 참조.

다이어그램 본문에 등장하는 객체 목록(각각 reference 문서로 연결됨):

- **Case** — 고객 이슈/문제. 모든 아티클은 CaseArticle 객체를 통해 케이스와 연관될 수 있다.
- **CaseArticle** — Case와 KnowledgeArticle의 연관.
- **FeedComment** — knowledge article의 feed에 추가된 comment.
- **Knowledge__DataCategorySelection** — 아티클을 분류하는 data category.
- **Knowledge__Feed** — knowledge article의 feed.
- **Knowledge__ka** — KnowledgeArticle의 concrete 객체.
- **Knowledge__kav** — KnowledgeArticleVersion의 concrete 객체.
- **Knowledge__VersionHistory** — KnowledgeArticleVersionHistory의 concrete 객체.
- **Knowledge__ViewStat** — KnowledgeArticleViewStat의 concrete 객체.
- **Knowledge__VoteStat** — KnowledgeArticleVoteStat의 concrete 객체.
- **KnowledgeArticle** — abstract Knowledge article 객체.
- **KnowledgeArticleVersion** — abstract Knowledge article version 객체.
- **KnowledgeArticleVersionHistory** — 아티클의 전체 히스토리에 대한 read-only 접근.
- **KnowledgeArticleViewStat** — 지정 아티클의 view 수 통계.
- **KnowledgeArticleVoteStat** — 지정 아티클의 가중 rating.
- **LinkedArticle** — work order, work order line item, work type에 첨부된 knowledge article.
- **LinkedArticleFeed** — linked article의 comment feed.
- **LinkedArticleHistory** — linked article의 tracked field 변경 히스토리.
- **WorkOrder** — 고객을 위한 field service 작업.
- **WorkOrderLineItem** — field service의 work order 하위 작업(subtask).
- **Vote** — 사용자가 knowledge article에 한 vote.
  - Vote 사용은 Knowledge Article 객체에는 허용되지만 Knowledge Article Version 객체에는 허용되지 않는다.
  - knowledge article·사용자당 하나의 vote 레코드만 존재할 수 있다. Site Guest User는 투표할 수 없다.
  - Vote는 `Type` field에 여러 종류의 값을 허용하지만, Knowledge Article에는 **`Up`** 과 **`Down`** 만 허용된다.

---

## 3. Articles and Data Categories in the API

> **Important:** 가능한 경우 Equality 가치에 맞춰 noninclusive 용어를 변경했다. 고객 구현에 영향을 주지 않기 위해 일부 용어는 유지했다.

아티클은 knowledge base에서 제공하려는 제품·서비스 정보를 담는다. 아티클은 **data category**로 분류할 수 있고, 관리자는 data category로 아티클 접근을 제어할 수 있다.

- **Knowledge Articles vs. Knowledge Article Versions:** KnowledgeArticle은 모든 아티클 버전의 부모 레코드다. KnowledgeArticleVersion 레코드는 주어진 아티클의 각 version을 나타낸다.
- **Record Types vs. Article Types:** **Lightning Knowledge** 에서는 record type(Knowledge__kav의 RecordTypeId field)으로 아티클 유형을 구조화한다. **Salesforce Classic** 에서는 article type(KnowledgeArticleVersion의 ArticleType field)으로 한다. Classic은 유형마다 고유 객체(예: `FAQ__kav`)를 갖지만, Lightning Knowledge는 유형별 고유 객체가 없고 record type으로 처리한다.

### Audience Channel (4개)

| 채널 | 설명 |
|---|---|
| **Internal App** | Salesforce 사용자가 역할 visibility에 따라 아티클에 접근. |
| **Customer** | community·site·customer portal에서 고객이 접근. Customer 사용자는 account의 manager의 역할 visibility를 상속. community에서는 Customer Community 또는 Customer Community Plus 라이선스 사용자만 사용 가능. |
| **Partner** | community·site·partner portal에서 파트너가 접근. Partner 사용자는 account manager의 역할 visibility를 상속. community에서는 Partner Community 라이선스 사용자만 사용 가능. |
| **Public Knowledge Base** | public knowledge base를 통해 익명 사용자에게 제공. Lightning Knowledge에서는 대부분 Communities를 쓴다. Salesforce Classic에서 public KB를 만들려면 Sites와 Visualforce가 필요하다. |

### Publishing Cycle (3개 상태)

| 상태 | 설명 |
|---|---|
| **Draft** | 새 아티클이 생성 중이거나 기존 아티클이 갱신 중인 단계. |
| **Online** | 발행되어 각 채널에서 사용 가능한 draft 아티클. |
| **Archived** | 발행된 아티클이 수명 종료에 다다르면 Archived로 옮기거나 후속 version에서 갱신하기 위해 Draft로 되돌릴 수 있다. |

### Working with Articles in the API

**KnowledgeArticleVersion** — 모든 새 draft는 version 번호를 가지며 각 version은 자체 ID를 가진다. KnowledgeArticleVersion 객체로 콘텐츠에 접근하고 Draft/Online 상태로 필터링한다. 아티클은 자동으로 **Article Number**를 부여받는다(개별 아티클의 고유 식별자가 아니라, 주 아티클과 그에 딸린 모든 번역을 가리키는 식별자).

> **Note:** 주 version(IsMasterLanguage = 1인 knowledge article)과 번역 모두 KnowledgeArticleVersion 객체다.

```sql
SELECT Title
FROM KnowledgeArticleVersion
WHERE PublishStatus='Draft'
AND language ='en_US'
```

**KnowledgeArticle** — KnowledgeArticleVersion과 달리, KnowledgeArticle 레코드의 ID는 아티클의 version(상태)과 무관하게 동일하다. KnowledgeArticleVersion은 custom field 값에 대한 API 접근을, KnowledgeArticle은 metadata field에 대한 API 접근을 제공한다. Article 레코드는 모든 version(draft/published/archived)과 언어의 부모 컨테이너다. concrete 기본값은 Lightning에서 Knowledge__ka(article)·Knowledge__kav(article version), Classic에서 `<Article Type>__ka`·`<Article Type>__kav`다.

```sql
SELECT Title
FROM Knowledge__kav
WHERE PublishStatus='online'
AND Language = 'en_US'
AND RecordTypeId = '<specify RecordTypeId for FAQ here>'
```

```sql
SELECT ID, Title, UrlName, RTA2__c
FROM Knowledge_kav
```

```sql
SELECT Title
FROM FAQ__kav
WHERE PublishStatus='online'
AND language ='en_US'
```

> 위 두 번째 예제의 `FROM Knowledge_kav`(언더스코어 1개)와 `RTA2__c`는 PDF 원문 그대로다. 정식 객체명은 `Knowledge__kav`(언더스코어 2개)임에 유의.

### Data Categories Overview

Data category는 category group으로 조직되어, 사용자가 레코드를 분류·검색하고 관리자가 레코드 접근을 제어하게 한다. 예: 아티클을 판매 지역과 제품으로 분류 → 두 category group: Sales Regions(All Sales Regions → North America, Europe, Asia), Products(All Products → Phones, Computers, Printers).

### Working with Data Categories in the API

| Name | Type | 설명 |
|---|---|---|
| `Knowledge__DataCategorySelection` | Object | Lightning Knowledge의 아티클 분류 접근. |
| `ArticleType__DataCategorySelection` | Object | Salesforce Classic Knowledge의 아티클 분류 접근. |
| `QuestionDataCategorySelection` | Object | question 분류 접근. |
| `WITH DATA CATEGORY filteringExpression` | SOQL clause | 발행 주기 상태와 data category에 따라 아티클을 필터링. → [[SOQL WITH DATA CATEGORY]] 참조 |
| `WITH DATA CATEGORY DataCategorySpec` | SOSL clause | 분류 기준으로 아티클을 검색. → [[SOSL 패턴]] 참조 |
| `describeDataCategoryGroups()` | Call | 요청에 지정된 객체에 대한 사용 가능한 category group 조회. → [[Knowledge SOAP API 호출]] |
| `describeDataCategoryGroupStructures()` | Call | category group과 그 data category 구조를 조회. → [[Knowledge SOAP API 호출]] |
| `describeDataCategoryGroups` | Apex method | 지정된 객체에 연관된 category group 목록 반환. (Apex Developer Guide) |
| `describeDataCategoryGroupStructures` | Apex method | category group과 data category 구조 반환. (Apex Developer Guide) |

> SOQL `WITH DATA CATEGORY` 문법(ABOVE/BELOW/AT/ABOVE_OR_BELOW 등)의 상세는 [[SOQL WITH DATA CATEGORY]] 소관이다. 이 노트는 API 리소스 카탈로그만 다룬다.

---

## 4. API End-of-Life Policy

Salesforce는 각 API version을 최초 릴리즈일로부터 **최소 3년** 지원한다. 품질·성능 향상을 위해 3년 넘은 version은 더 이상 지원되지 않을 수 있다. Salesforce는 deprecation 예정인 API version을 사용하는 고객에게 지원 종료 **최소 1년 전** 통지한다.

> **Note:** REST API와 SOAP API의 Version 20.0은 deprecate되어 더 이상 지원되지 않는다. Summer '22 릴리즈 전까지는 이 legacy 버전에 계속 접근할 수 있었고, 그 시점에 retire되어 사용 불가가 되었다. (Knowledge Article: *Salesforce Platform API Versions 7.0 through 20.0 Retirement*.)

> **Note:** REST API와 SOAP API의 Version 21.0~30.0은 Summer '22 릴리즈에서 deprecate되었다. (Knowledge Article: *Salesforce Platform API Versions 21.0 through 30.0 Retirement*.)

---

## 관련 노트

- [[Knowledge SOAP API 객체 — 핵심 아티클 객체]]
- [[Knowledge SOAP API 객체 — 통계·연관·주변 객체]]
- [[Knowledge SOAP API 호출]]
- [[Knowledge REST API — Actions & Manage]]
- [[Knowledge REST API — Search & Support]]
- [[Knowledge Metadata API 타입 — 아티클·채널·설정]]
- [[Knowledge Metadata API 타입 — 데이터카테고리·검색·외부소스]]
- [[Knowledge UI API 제약]]
- [[Service Cloud Objects]]
- [[SOQL WITH DATA CATEGORY]]
- [[SOSL 패턴]]
- [[KbManagement Namespace]]
