---
tags: [Service, Knowledge, LightningKnowledge, 리포팅, Report, ReportType, KnowledgeReports, 통계, Views, Votes, Searches, Admin]
source: lightning_knowledge_guide.pdf (Spring '26, p.39–52)
created: 2026-06-17
aliases: [Knowledge 리포팅, Knowledge Reports, Article Report Type, Knowledge 리포트 필드, Report on Salesforce Knowledge Articles, Knowledge Article Views Votes Searches, Custom Report Type Knowledge, 아티클 조회수 리포트, 아티클 투표 리포트, Knowledge 대시보드, Knowledge Base Dashboards and Reports, 아티클 사용 통계 리포트, Knowledge 리포트 폴더, 아티클 리포트 만드는 방법]
---

# Lightning Knowledge 아티클 리포팅

> Knowledge 아티클이 어떻게 생성·유지·전달되는지 추적하는 custom report 만들기 — 폴더·report type·리포트 생성, 그리고 각 primary object별 사용 가능 필드 전수.

---

## Report on Salesforce Knowledge Articles 개요

**Title (본문 H1):** Report on Salesforce Knowledge Articles

> **Editions (deviation):** Available in: Salesforce Classic (not available in all orgs) and Lightning Experience. Essentials and the Unlimited Edition with Service Cloud; 추가 비용으로 Professional/Enterprise/Performance/Developer.
> **USER PERMISSIONS (parent):** custom report type 생성/업데이트 — **Manage Custom Report Types**. public reports 폴더 생성 — **Manage Public Reports**.

custom report로 아티클이 어떻게 생성·유지·전달되는지 추적한다. **custom report type이 아티클 리포트를 사용 가능하게 하는 유일한 방법**이다. Salesforce는 샘플 아티클 리포트나 아티클용 표준 report 폴더를 제공하지 않는다.

> [!tip] Tip
> **Knowledge Base Dashboards and Reports** AppExchange 패키지가 24개 이상의 리포트를 제공한다.

하위 단계: Create a Folder for Article Reports; Create a Report Type for Article Reports; Create an Article Report; Fields Available on Salesforce Knowledge Reports.

---

## 아티클 리포트용 폴더 만들기

**Steps (전수):**

1. Reports 탭의 **Report Folder** 섹션에서 **Create New Folder**를 클릭.
2. Folder Label 필드에 **Article Reports**를 입력.
3. 선택적으로 **Group Unique Name**을 수정.
4. **Public Folder Access** 옵션을 선택(사용자가 리포트를 추가/제거하게 하려면 read/write 선택).
5. 폴더 visibility 옵션을 선택.
6. **Save**를 클릭. 여기 저장된 리포트는 Reports 탭에서 사용 가능하다.

---

## 아티클 리포트용 Report Type 만들기

**Steps (전수):**

1. From Setup, Quick Find 박스에 `Report Types`를 입력하고 `Report Types`를 선택.
2. **New Custom Report Type**을 클릭. (Create a Custom Report Type 참조.)
3. **Primary Object** 드롭다운에서 아티클 관련 객체를 선택.
4. 필수 필드를 완성하고 **Save**를 클릭.
5. (sheet 47) **Store in Category** 드롭다운에서 **Customer Support Reports**나 **Other Reports**를 선택할 것을 권장.
6. **Define Report Records Set** 페이지에서 선택. **Save**를 클릭.
7. 필요에 따라, 리포트 레이아웃에서 필드를 제거·재배열.

> [!note] Note
> 아티클의 score는 API와 custom report에서 약간 다르게 계산된다. 둘 다가 아니라 하나로 표준화하라.

### Secondary Relationship이 있는 Report Type

| Primary Object | Related Objects | Description |
|---|---|---|
| Knowledge (Lightning Knowledge) | • Knowledge Versions • Feed: Knowledge | Compare information, such as creation dates, audience visibility, and the number of associated cases across record types. To access history and custom fields, add Knowledge Versions as a secondary object. If you changed the name of your knowledge base, the custom label shows here. |
| Knowledge Articles | • Knowledge Article Versions • Article View Statistics • Article Vote Statistics • Case Article (– Articles; – There are many additional relationships from Case Article, including Work Orders and Case Comments.) | Report on information about individual published articles, such as their creation date and published channels. When you build this custom report type, you can include article view statistics, article vote statistics, and case associations. In reports using the Knowledge Articles primary object, **each article has five records (rows), one for each channel (All Channels, Internal App, Customer, Partner, and Public Knowledge Base).** |
| Knowledge Article Versions | • Article View Statistics • Article Vote Statistics • Case Article (– Articles; – many additional relationships from Case Article, including Work Orders and Case Comments.) | Compare information about individual versions and translations, such as creation date, published channels, and number of associated cases. You can also include article view and vote statistics. |
| Article types (Knowledge in Salesforce Classic) | • Article Type Versions. You can then choose a relationship to Article Type_DataCategorySelection. | Compare information, such as creation dates, published channels, and number of associated cases, for your custom article type, such as an FAQ. To access version history and custom fields, add the article type's version as a secondary object. If you have multiple article types, each is listed separately, e.g., FAQs, Issues, and Procedures. |

> (sheet 46) "Report types for the search, view, vote, and version history objects don't have secondary relationships."

채널당 행(row) 구조는 다음과 같다(Knowledge Articles primary object 사용 시 아티클당 5개 행):

```
// 구조 예시 — 실제 동작 코드 아님 (아티클당 채널별 행 구조)
Article "Reset to Defaults"
  ├─ Row 1: All Channels
  ├─ Row 2: Internal App
  ├─ Row 3: Customer
  ├─ Row 4: Partner
  └─ Row 5: Public Knowledge Base
```

### Search, Views, Votes, Version History용 Report Type (Table 2)

| Primary Object | Description |
|---|---|
| Knowledge Search Activity | • Analyze the number of searches per day, month, or year for each channel and language. • For each search, see the date, ID, and title of the article that was clicked. • See which keywords users are looking for in your knowledge base. • For each keyword, see the average number of results, and articles that appear in the search results. • For each article, see the average number of clicks, and unique users who clicked it. |
| Knowledge Keyword Search | See which keywords users are looking for in your knowledge base. Keyword data is only available for Salesforce Classic. |
| Article Version History | Compare information about individual article versions, such as their creation dates, published channels, and number of associated cases. |
| Knowledge Article Views | Analyze the number of views per day, month, or year for each channel and role. |
| Knowledge Article Votes | Analyze the number of votes per day, month, or year for each channel and role. |
| Knowledge Article Searches | Analyze the number of searches per day, month, or year for each channel and role. Searches aren't differentiated between internal and external, and all searches are logged as Internal App. Searches in Experience Cloud sites aren't checked. Knowledge Article Searches' report results are limited to searches performed using Classic Knowledge. |

### Report Type — 한계와 고려사항

- 리포트 생성에 **24시간**이 걸린다.
- relevancy 기준으로, 리포트는 일일 최대 **300 results**, 현재 월의 지난 **30일**까지 표시한다. (새 월이 시작되면, 과거 일일 데이터가 해당 연도의 월별 상위 300 results로 집계된다. 새 연도가 시작되면, 과거 월별 데이터가 연도별 상위 300으로 집계된다.)
- Knowledge Search Activity에 대해 필드와 custom report type이 지원된다.
- custom report에서 필드를 추가/제거할 수 있다.

---

## 아티클 리포트 만들기

**Steps (전수):**

1. Reports 탭에서 **New Report**를 클릭.
2. 카테고리를 선택(예: Customer Support Reports 또는 Other Reports). **Cases with Articles** 리포트는 Customer Support Reports 폴더에 default로 사용 가능하다.
3. report type을 찾아 **Create**를 클릭.
4. 리포트를 볼 때 **Save As**를 클릭하여 새 Article Reports 폴더에 저장.

**Notes (전수):**

- Knowledge Article custom report type을 쓰는 리포트에는 **아티클당 최소 5개 행**(All Channels 포함 채널당 하나)이 있다.
- **Daily 값**은 지난 **90일**에 대해 독립적으로 보고되고, **Monthly 값**은 지난 **18개월**에 대해 보고된다. 그 기간 이후에는 각각 monthly aggregate와 yearly aggregate 값을 쓴다.
- Knowledge Article Votes / Views / Searches custom report type을 쓰는 리포트에서, 각 행은 **day, channel, role 조합**을 나타낸다.
- Knowledge Article Version(KAV)을 쓰는 리포트에서, Knowledge Article Version History를 제외하고, data category로 필터링할 수 있다. 최대 **4개 필터**를 추가하고 logic을 **AT, ABOVE, BELOW, 또는 ABOVE OR BELOW**로 설정한다. 필터 간 logic은 **OR**이다. 같은 category group을 여러 번 쓸 수 있지만, 매번 같은 operator를 써야 한다.
- Knowledge 아티클의 Approval Process를 리포트하려면, custom report type 생성 시 **Process Instance**와 **Process Instance Node**를 쓰고, object type(article type)으로 필터링한다.
- Cases with/without articles로 cross-filter하여 Case용 custom report type을 만들 수 있다. 이렇게 하면, 아티클을 archive할 때 그것에 연결된 case 레코드는 리포트에 아티클 정보를 더 이상 나열하지 않는다(사용자가 category group의 모든 data category에 접근권이 없는 경우).

---

## 리포트에서 사용 가능한 필드 (Fields Available)

> [!important] Important (verbatim, 섹션 시작)
> Where possible, we changed noninclusive terms to align with our company value of Equality. We maintained certain terms to avoid any effect on customer implementations.

아래 모든 필드 표는 2-column **Field / Description** 형식이며, primary object별로 나열한다.

### Table 3 — Article Type Report Primary Object Fields (Knowledge in Salesforce Classic)

| Field | Description |
|---|---|
| Archived By | User who archived the article. |
| Archived Date | Date the article was archived. |
| Article Number | Unique number automatically assigned to the article. |
| Article Type ID | The ID associated with the article type. |
| Case Association Count | Number of cases attached to the article. |
| Created By | User who created the article. |
| Created Date | Date the current article version was created. If published more than once, Created Date is the latest draft date. To use the original creation date, create a Custom Report Type that joins the Knowledge Article (__ka) and Knowledge Article Version (__kav) objects. |
| Custom fields | Any custom fields created on the article types. Add the article type's version as a secondary object to access custom fields. |
| First Published Date | Date the article was originally published. |
| Knowledge Article Version | The article's version number. |
| Last Modified By | User who changed the article most recently. |
| Last Modified Date | Date the article was last changed. Draft = time the draft was saved; published = time most recently published. |
| Last Published Date | Date the article was last published. |
| Next Review Date | The date when the article must next be reviewed for accuracy. |
| Primary Language | The original language of the article. |

> [!note] Note (verbatim)
> Currently you can't use **Knowledge Article Version** and **Last Modified Date** in the same report.

### Table 4 — Article Type Report Secondary Object Fields

| Field | Description |
|---|---|
| Archived By | User who archived the article. |
| Article Type | The article type associated with the article. |
| Created By | User who created the article. |
| Created Date | Date the current article version was created. If published more than once, Created Date is the latest draft date. To use the original creation date, create a Custom Report Type that joins the Knowledge Article (__ka) and Knowledge Article Version (__kav) objects. |
| Custom fields | Any custom fields created on the article types. Add the article type's version as a secondary object to access custom fields. **File fields aren't supported for reports and report types with Knowledge.** |
| Is Latest Version | Indicates if the article is the most recent version. |
| Is Primary Language | Indicates that the article is not a translation, but the original article. |
| Knowledge Article Version ID | Unique ID automatically assigned to the article translation. |
| Language | The article's language. |
| Last Modified By | User who changed the article most recently. |
| Last Modified Date | Date the article was last changed. Draft = time the draft was saved; published = time most recently published. |
| Out of Date | Indicates that the primary article has been updated since this translation was published. |
| Publication Status | Indicates whether the article or translation is in progress (draft), published, or archived. |
| Summary | Description of the article provided by the author. |
| Title | The article's title. |
| Translation Completed Date | Date the translation was completed. |
| Translation Exported Date | Date the article was exported for translation. |
| Translation Imported Date | Date the translation was imported. |
| URL Name | Text used as hyperlink for the article. |
| Validation Status | Indicates if the article is valid or not. |
| Version Number | The version number of the article. |
| Visible in Customer | Indicates that the article is published in the Customer Portal. |
| Visible in Internal App | Indicates that the article is published in the internal app (Articles tab). |
| Visible in Partner | Indicates that the article is published in the partner portal. |
| Visible in Public Knowledge Base | Indicates that the article is published in the public knowledge base. |

### Fields Available on Knowledge Articles Reports

| Field | Description |
|---|---|
| Article Number | Unique number automatically assigned to the article. |
| Article Type | The article type associated with the article. |
| Case Association Count | Number of cases attached to the article. |
| Created By | User who created the article. |
| Created Date | Date the current article version was created. If published more than once, Created Date is the latest draft date. To use the original creation date, create a Custom Report Type that joins the Knowledge Article (__ka) and Knowledge Article Version (__kav) objects. |
| First Published Date | Date the article was originally published. |
| Is Latest Version | Indicates if the article is the most recent version. |
| Knowledge Article Version ID | Unique ID automatically assigned to the article translation. |
| Last Modified By | User who changed the article most recently. |
| Last Modified Date | Date the article was last changed. Draft = time the draft was saved; published = time most recently published. |
| Last Published Date | Date the article was last published. |
| Published Version Owner | The user or queue that owns the published version of an article. |
| Summary | Description of the article provided by the author. |
| Title | The article's title. |
| URL Name | Text used as hyperlink for the article. |
| Validation Status | Indicates if the article is valid or not. |
| Version Number | The version number of the article. |
| Visible in Customer | Indicates that the article is published in the Customer Portal. |
| Visible in Internal App | Indicates that the article is published in the internal app (Articles tab). |
| Visible in Partner | Indicates that the article is published in the partner portal. |
| Visible in Public Knowledge Base | Indicates that the article is published in the public knowledge base. |

### Fields Available on Knowledge Article Searches Reports

| Field | Description |
|---|---|
| Channel | The channel applicable to the article. Possible values: **All Channels, Internal App, Customer, Partner, Public Knowledge Base.** |
| Count | The number of article searches applicable to the duration shown (day, month, or year). |
| Cumulative Count | The total number of article searches for the history of the record. |
| Date | Last date on which an article search took place for the record. All rows represent a date, channel, and role combination. |
| Duration | The time period the search count is applied to. Possible values: **Daily, Monthly, Yearly.** E.g., Count=70, Duration=Monthly → 70 searches over the past month. Totals aggregated daily for the current month, monthly from the past full month through the past full year, and yearly beyond that. |
| Related Role | Name of the role that applies to the record. Each row represents searches per channel per role. |

### Fields Available on Knowledge Article Versions Reports

| Field | Description |
|---|---|
| Archived By | User who archived the article. |
| Archived Date | Date the article was archived. |
| Article Number | Unique number automatically assigned to the article. |
| Article Type | The article type associated with the article. |
| Case Association Count | Number of cases attached to the article. |
| Created By | User who created the article. |
| Created Date | Date the current article version was created. If published more than once, Created Date is the latest draft date. To use the original creation date, create a Custom Report Type that joins the Knowledge Article (__ka) and Knowledge Article Version (__kav) objects. |
| External Reference | The ID of the article in the external system. |
| First Published Date | Date the article was originally published. |
| Is External Data | Indicates that the article came in from (or was sourced from) an external system. |
| Is Latest Version | Indicates if the article is the most recent version. |
| Is Primary Language | Indicates that the article is not a translation, but the original article. |
| Knowledge Article Version ID | Unique ID automatically assigned to the article translation. |
| Language | The article's language. |
| Last Modified By | User who changed the article most recently. |
| Last Modified Date | Date the article was last changed. Draft = time the draft was saved; published = time most recently published. |
| Last Published Date | Date the article was last published. |
| Next Review Date | The date when the article must next be reviewed for accuracy. |
| Primary Language | The original language of the article. |
| Out of Date | Indicates that the primary article has been updated since this translation was published. |
| Owner | The user or queue that owns a published, draft, or archived version of an article. |
| Publication Status | Indicates whether the article or translation is in progress (draft), published, or archived. |
| Summary | Description of the article provided by the author. |
| Title | The article's title. |
| Translation Completed Date | Date the translation was completed. |
| Translation Exported Date | Date the article was exported for translation. |
| Translation Imported Date | Date the translation was imported. |
| URL Name | Text used as hyperlink for the article. |
| Validation Status | Indicates if the article is valid or not. |
| Version Number | The version number of the article. |
| Visible in Customer | Indicates that the article is published in the Customer Portal. |
| Visible in Internal App | Indicates that the article is published in the internal app (Articles tab). |
| Visible in Partner | Indicates that the article is published in the partner portal. |
| Visible in Public Knowledge Base | Indicates that the article is published in the public knowledge base. |

### Fields Available on Knowledge Article Views Reports

> (verbatim) You can add up to **six of these eight** fields.

| Field | Description |
|---|---|
| Channel | The channel applicable. Possible values: All Channels, Internal App, Customer, Partner, Public Knowledge Base. |
| Count | The number of article views applicable to the duration shown (day, month, year). |
| Cumulative Count | The total number of article views for the history of the record. |
| Date | Last date on which an article view took place. All rows represent a date, channel, and role combination. |
| Duration | Possible values: Daily, Monthly, Yearly. (Totals aggregated daily for the current month, monthly from the past full month through the past full year, and yearly beyond that.) |
| Related Role | Name of the role that applies to the record. |
| Score | The article's average view rating. Scores take into account a half-life calculation. **Every 15 days, if an article has not been viewed, its average rating moves up or down.** Ensures older/outdated articles don't maintain artificially high or low ratings vs newer, more frequently viewed articles. |
| Total Views | Number of times a published article has been viewed. |

### Fields Available on Knowledge Article Votes Reports

| Field | Description |
|---|---|
| Channel | All Channels, Internal App, Customer, Partner, Public Knowledge Base. |
| Count | The number of article votes applicable to the duration shown (day, month, year). |
| Cumulative Count | The total number of article votes for the history of the record. |
| Date | Last date on which an article vote took place. All rows = date, channel, role combination. |
| Duration | Daily, Monthly, Yearly. (Totals aggregated daily for the current month, monthly from the past full month through the past full year, and yearly beyond that.) |
| Related Role | Name of the role that applies to the record. |

### Fields Available on Knowledge Keyword Search Reports

> (verbatim) Knowledge Keyword Search reports are designed for use with the Salesforce Knowledge in Salesforce Classic data model. These reports include searches from the **Knowledge One widget.**

| Field | Description |
|---|---|
| Channel | All Channels, Internal App, Customer, Partner, Public Knowledge Base. |
| Count | The number of keyword searches applicable to the duration shown (day, month, year). |
| Date | Last date on which a keyword search took place. All rows = date, channel, role combination. |
| Duration | Daily, Monthly, Yearly. (Totals aggregated daily for the current month, monthly from the past full month through the past full year, and yearly beyond that.) |
| Found | Indicates whether the keyword shown was found during a search of the knowledge base. |
| Keyword | Search term used to search published articles in the knowledge base. |

### Fields Available on Knowledge Search Activity Reports

| Field | Description |
|---|---|
| Average Click Rank | The order in which the article appeared in search results when results are sorted by relevance and when readers clicked it from the list of results. |
| Channel | All Channels, Internal App, Customer, Partner, Public Knowledge Base. |
| Clicked Article Title | The title of the clicked article taken when the search results are sorted by relevance by the reader. |
| Duration | Daily, Monthly, Yearly. (Totals aggregated daily for the current month, monthly from the past full month through the past full year, and yearly beyond that. Activity totals are collected nightly and aren't in real time.) |
| Language | The language filter applied to the reader's search. |
| Number of Results | The number of search results returned for the search term. If Duration is included, this value is aggregated based on the time period. |
| Number of Searches | The number of searches for the duration shown (day, month, or year). |
| Number of Users | The number of individual users who clicked the article. |
| Search Date | The date of the search. |
| Search Term | The first 100 characters of the search term used to search published articles. |

---

## 관련 노트

- [[Knowledge SOAP API 객체 — 통계·연관·주변 객체]]
- [[Lightning Knowledge 사용 — 액션·검색·스마트링크·채널]]
