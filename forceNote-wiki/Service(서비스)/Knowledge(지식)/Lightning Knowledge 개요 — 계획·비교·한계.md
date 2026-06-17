---
tags: [Service, Knowledge, LightningKnowledge, 계획, 비교, 한계, Scalability, Mobile, ClassicKnowledge, Admin, Setup, NoCode]
source: lightning_knowledge_guide.pdf (Spring '26, p.1–13)
created: 2026-06-17
aliases: [Lightning Knowledge 개요, Knowledge 계획, Lightning vs Classic Knowledge, Knowledge Scalability, Lightning Knowledge Limitations, Knowledge 모바일 한계, 지식베이스 계획, Knowledge 어드민 가이드, Knowledge admin guide, 지식 어드민, Knowledge 셋업 가이드, 코드 없이 Knowledge, Knowledge 시작하기 어드민, 지식베이스 만들기, Create a Knowledge Base, Knowledge 도입]
---

# Lightning Knowledge 개요 — 계획·비교·한계

> Salesforce Knowledge 지식베이스를 시작하기 위한 큰 그림: 무엇을 계획하고, 확장성을 어떻게 계산하며, Lightning vs Classic이 어떻게 다르고, Lightning Knowledge에 어떤 한계가 있는지.

---

## Salesforce Knowledge란

Salesforce Knowledge 지식베이스는 **knowledge articles**(정보 문서)로 구성된다. 아티클은 프로세스 정보(예: 제품을 기본값으로 재설정하는 방법)나 FAQ(예: 제품이 지원하는 저장 용량)를 담을 수 있다.

- 경험 많은 서비스 상담원과 내부 작성자가 아티클을 작성한다. 아티클은 발행(publish)되어 여러 **채널**에서 내부적·외부적으로 사용된다. 고객/파트너 사이트와 공개 웹사이트에 발행하거나, 소셜 포스트와 이메일에서 공유할 수 있다. 무엇을 어디에 발행할지는 아티클 페이지 레이아웃, 사용자 프로필, 액션, 기타 설정으로 제어한다.
- Knowledge는 Salesforce Classic과 Lightning Experience 양쪽에서 쓸 수 있다. Knowledge를 새로 도입하는 조직은 generally available인 **Lightning Knowledge**를 쓴다. 이미 Salesforce Classic에서 Knowledge를 쓰는 조직은 **Lightning Knowledge Migration Tool**과 Lightning Knowledge로의 전환을 고려해야 한다.

> [!note] Note (verbatim)
> Lightning Knowledge를 활성화하면 조직의 데이터 모델이 **article types** 대신 **record types**를 사용하도록 바뀐다. **활성화한 후에는 비활성화할 수 없다.** 활성화 전에, 여러 article type을 가진 조직은 article type을 통합하기 위해 데이터 마이그레이션이 필요하다. 운영(production)에서 활성화하기 전에 sandbox나 trial org에서 테스트하라.

> **Editions (standard block):** Available in: Salesforce Classic (not available in all orgs) and Lightning Experience. Salesforce Knowledge는 Service Cloud와 함께 **Essentials**와 **Unlimited** Edition에서 사용 가능. 추가 비용으로 **Professional, Enterprise, Performance, Developer** Edition에서 사용 가능.

---

## 도움말 & 리소스

PDF의 "Salesforce Knowledge Help and Resources"(sheets 6–8) 절은 help/developer docs/Trailhead로 가는 큐레이션된 외부 링크 카탈로그다. 본 위키는 링크 목록 대신 핵심 포인터만 남긴다.

- 개발자 리소스(sheet 9): Salesforce Knowledge Developers Guide, REST API Developer Guide, SOAP API Developer Guide, Metadata API Developers Guide, Visualforce Developers Guide, Lightning Platform Apex Code Developers Guide(Apex `KnowledgeArticleVersionStandardController` Class). 이 위키의 API 노트로 연결 → [[Knowledge 데이터 모델 & API 개요]] 참조.
- 셋업/사용/번역/데이터 카테고리/공유 관련 how-to 링크들은 본 Lightning Knowledge 노트 시리즈가 직접 다룬다(형제 노트 참조).

---

## 지식베이스 계획 (Plan Your Knowledge Base)

> **Editions (deviation):** **Available in: Lightning Experience** (Classic 아님); 나머지는 standard block.

회사 고유의 필요를 고려하며 지원팀의 전문성을 포착·발행하는 전략을 세우는 것이 중요하다. 견고한 지식베이스가 있으면 고객은 더 빠르게 서비스를 받거나 스스로 문제를 해결할 수 있다.

### 계획 고려사항표 (Consideration / Further Information)

| Consideration | Further Information |
|---|---|
| 지식베이스에 어떤 유형의 아티클과 정보를 포함하고 싶은가? | Set Up and Configure Lightning Knowledge; Record Type Considerations for Lightning Knowledge; Page Layout Considerations for Lightning Knowledge; Custom Fields on Articles |
| 누가 아티클을 작성하는가? 누가 정보를 읽을 접근 권한이 필요한가? | Lightning Knowledge User Access; Authoring Actions in Lightning Knowledge |
| 정보를 분류(categorize)할 필요가 있는가? | Work with Data Categories; Data Category Visibility |
| 검색을 향상시킬 필요가 있는가? | Improve the Article Search Experience; Enable Topics for Articles |
| 아티클 작성·발행을 관리할 workflow나 approval 프로세스가 필요한가? | Workflow and Approvals for Articles; Validation Rules |
| 임포트해야 할 기존 Knowledge 베이스나 문서가 있는가? | Import Existing Information into Salesforce Knowledge |
| 둘 이상의 언어를 지원하는가? | Support a Multilingual Knowledge Base |
| 상담원이 Chatter에서 아티클을 팔로우해야 하는가? | Feed Tracking |
| 지식베이스를 외부로 공유해야 하는가? | Give Customers Access to Your Knowledge Base Through Help Center |
| 지식 지향 서비스의 진화에 대한 가이드라인·리소스·최신 논의가 필요한가? | Salesforce Knowledge는 Consortium for Service Innovation에 의해 "KCS Verified" 되어 있으며, 이는 고객 지원 방법론의 모범 사례를 인정한다. Knowledge-Centered Support(KCS) 기능을 구현하면 팀 내 더 효율적인 협업을 만들고 고객에게 적절하고 정확한 정보를 제공할 수 있다. |

### 계획 팁 (전수)

- Salesforce Knowledge에서 **synonym group**을 만든다. Synonym은 아티클 검색에서 동등하게 취급되는 단어/구절로, 검색 결과를 최적화한다.
- 데이터 카테고리를 셋업하기 전에, category group과 그 계층을 신중히 계획하라. 카테고리 계층이 역할(role) 계층에 어떻게 매핑되는지 고려하라. Data Category Visibility 참조.
- Salesforce Knowledge 데이터에 대한 custom report를 만든다. AppExchange에서 **Knowledge Base Dashboards and Reports** 앱(24개 이상의 리포트)을 설치할 수도 있다.
- 여러 상담원이 같은 아티클을 동시에 편집할 수 있다. 자주 저장해도 동료가 경고 없이 변경을 덮어쓸 수 있다. 우발적 데이터 손실을 피하려면 모든 사용자에게 자신에게 배정된 아티클만 편집하도록 지시하라.
- 저장 공간 부족을 피하려면 사용량을 정기적으로 검토하라: Setup에서 Quick Find 박스에 **Storage Usage**를 입력하고 **Storage Usage**를 선택.
- 공개 지식베이스 사용자는 아티클을 평가(rate)할 수 없다.
- **Salesforce Files**로 상담원이 아티클에 문서를 첨부할 수 있다.
- article type의 custom 필드를 다른 필드 타입으로 변환하면 데이터를 잃는다. 해당 필드에 데이터가 없는 경우가 아니면 custom 필드를 변환하지 마라.
- Salesforce Knowledge 레이블을 이름 변경할 때: **Title**, **URL Name** 같은 표준 필드 이름은 고정이다. 아티클 생성/편집 페이지에서 이 필드의 레이블을 바꿀 수 없다. 조직이 다른 언어로 설정되어 있어도 이 필드는 해당 언어의 고정 레이블로 유지된다.
- 검색 엔진은 **lemmatization**(단어를 어근으로 환원)을 지원한다. *running* 검색은 *run, running, ran*과 매칭된다.
- record type이 지식베이스에 어떻게 영향을 주는지, 그리고 서로 다른 아티클에 다른 레이아웃을 표시하는 데 어떻게 쓰는지 이해하라. Record Type Considerations for Lightning Knowledge 참조.
- 일부 record type에 automation(quick action, process builder, flow)이 필요한지 결정하라. 예: 상담원이 closed case에서 아티클을 만들면 article manager에게 이메일을 보내는 규칙.
- 일부 record type에 approval 프로세스가 필요한지 결정하라. 예: 외부 발행 전 법무 + 경영진 승인이 필요한 아티클. Workflow and Approvals for Articles 참조.

---

## Knowledge Scalability (확장성)

> **Editions (deviation):** **Available in: All Editions** (추가 editions block 없음).

- 모든 Salesforce Knowledge 아티클은 여러 버전을 가질 수 있다: draft 1개, published 1개, archived 여러 개. 각 버전은 여러 translation을 가질 수 있다. 총 아티클 버전 수는 아티클 수보다 훨씬 많을 수 있다. 확장 시 **총 아티클 버전 수**와 **edition별 아티클 한도** 둘 다에 주의하라.
- 각 Salesforce edition은 Knowledge 아티클·버전·언어 번역에 대한 고유 한도를 갖는다. 모든 edition은 허용되는 **총 아티클 버전**의 최대 한도를 공유한다. **Classic Knowledge는 최대 100개의 article type**, **Lightning Knowledge는 객체당 최대 200개의 record type**을 사용한다.

### 버전 계산식

```
// 구조 예시 — 실제 동작 코드 아님 (PDF 본문의 계산식 표기)
Total # of versions = (# of articles) × (# of retained¹ versions per article) × (# of translations per version)
```

예시: 100,000 articles × 5 versions(1 draft, 1 published, 3 archived) × 5 translations = **2,500,000 total article versions.**

¹ Footnote: "Retained" 아티클에는 직접 만든 버전뿐 아니라 cases나 work items 같은 다른 객체에 첨부된 버전도 포함될 수 있다.

### Edition별 할당량 (Knowledge Base Allocations by Edition)

이 표는 각 Salesforce edition에 default로 허용되는 언어·아티클·아티클당 버전의 **최소** 수를 나열한다. 각 edition은 default **최대**도 갖는다(문서 링크로 default maximum 확인 가능). **Spring '18 릴리스 이전에 생성된 조직은 모든 edition의 default 한도가 16 languages다.** 확장을 요청하려면 Salesforce support에 연락하라.

> [!note] Note (verbatim)
> 할당된 default maximum보다 더 필요하면 Salesforce Support에 아티클 한도 증가를 요청할 수 있다.

| Edition | Article, Version, and Language Allocations |
|---|---|
| Essentials | 500 articles, 10 versions per article, 1 language |
| Professional | 500 articles, 10 versions per article, 1 language |
| Enterprise | 50,000 articles, 10 versions per article, 5 languages |
| Developer | 50,000 articles, 10 versions per article, 5 languages |
| Unlimited | 150,000 articles, 10 versions per article, 10 languages |

표 아래(verbatim): 할당된 default maximum보다 더 필요하면 Salesforce Support에 아티클 한도 증가를 요청할 수 있다. 아티클당 retained 버전 한도에는 cases, work items, undeletable lookup 필드 같은 객체에 연결된 버전은 포함되지 않는다. 예를 들어, default 한도가 아티클당 10 versions여도, 그중 15개가 cases에 연결되어 있다면 아티클이 25 versions를 가질 수 있다. 단, cases 같은 객체에 첨부된 버전은 조직당 총 버전 수에는 계산된다.

---

## Lightning Knowledge vs Classic Knowledge 비교

> **Editions:** standard block (Classic and Lightning).

Lightning Knowledge는 Salesforce에서 Knowledge가 동작하는 방식을 바꾸었다. 예를 들어, 표준 record type이 article type을 대체하고, Lightning Service Console용 Knowledge 컴포넌트가 Salesforce Classic의 Service Console용 Knowledge One을 대체한다.

> 아래 표의 각 셀은 서술 텍스트이며 Yes/No 기호가 아니다 — ✅/❌ 압축 불가. 모든 unique 셀값을 전수로 옮긴다.

| Feature | Classic Knowledge | Lightning Knowledge |
|---|---|---|
| Access and permissions | CRUD, profile permissions, page layouts, and custom article actions per public group | CRUD, profile permissions, and page layouts |
| Files | Files are attached in custom file fields | Files are stored in the standard Files object and attached in the Files related list |
| Object home | Knowledge One and Article Management tab | Knowledge home page with list views |
| Page layouts | Fields only, per article type and user profile | Fields, actions, and related lists, per record type and user profile |
| Record home (articles) | Custom record home | Default Record Home and Record Home that is configurable via the Lightning App Builder |
| Setup | Salesforce Classic Setup | Lightning Knowledge Setup |
| Sharing | Sharing by data category | Standard Salesforce sharing is also available |
| Types of articles | Article Types | Standard Record Types |
| Use Knowledge in the console | Add Knowledge One to the Service Console | Add the Lightning Knowledge component via the Lightning App Builder |

**SEE ALSO:** Sharing Considerations for Lightning Knowledge; Lightning Knowledge Migration Tool.

---

## Lightning Knowledge 한계 (Limitations)

> **Editions:** standard block (Classic and Lightning).

Lightning Experience의 Knowledge는 Salesforce Classic과 다르게 동작한다. Lightning Knowledge를 활성화하면 데이터 모델이 article type 대신 record type로 바뀐다. 활성화 후에는 비활성화할 수 없다. Classic에서 Lightning으로 이동하려면 **Lightning Knowledge Migration Tool**을 쓴다. 운영에서 마이그레이션 도구를 실행하기 전에 최근에 refresh한 **full-copy sandbox**에서 테스트하고 모든 커스터마이징·통합을 검증하라. 신중히 준비된 마이그레이션 계획이 운영 영향을 최소화한다.

### Lightning Knowledge 활성화 시 중요 고려사항 (전수)

- Classic의 지식베이스를 Lightning으로 옮기려면 Lightning Knowledge Migration Tool을 쓴다. 마이그레이션은 수동 단계와 검증을 요구하며, 일부 데이터는 마이그레이션되지 않을 수 있다. sandbox나 production에서 마이그레이션 도구를 활성화하려면 Salesforce support에 연락하라.
- Lightning Knowledge에서는 권한과 사용자 접근이 다르게 동작한다. Lightning Knowledge User Access 참조. 활성화하면 user profile 권한이 public group과 함께 쓰던 article action을 대체한다. Classic에서는 article type별로 독립적인 객체 권한을 배정하지만, Lightning에서는 article type이 **Knowledge object**에 통합된다. Lightning Knowledge용 sharing을 써서 record type 기반의 독립 권한을 user profile에 배정하라.
- Lightning Knowledge 활성화 조직에서 archived 아티클을 삭제하려면 **Modify All** 권한이 있어야 한다.
- 활성화 후 **Article Type 필드는 SOQL이나 API로 더 이상 접근할 수 없다.** ArticleType을 쿼리하는 custom code에 영향을 준다.
- Lightning Knowledge 활성화 전에, article type을 포함하는 설치된 패키지를 모두 삭제하라.
- Lightning Knowledge는 **federated search를 지원하지 않는다.** Salesforce Classic으로 전환하라.
- Classic의 lookup 검색은 Publish status(Draft, Published, Archive)와 무관하게 Knowledge 레코드를 찾는다. Lightning에서 lookup 검색은 **published** Knowledge 레코드만 찾는다.
- 조직에 *Knowledge*라는 이름의 Visualforce 탭이 있으면 Lightning Knowledge의 Knowledge 탭 접근 시 Insufficient Privileges 에러가 난다. 기존 Visualforce 탭을 이름변경/삭제하거나 Knowledge 객체 이름을 바꿔라.
- Classic의 custom File 필드 안의 파일은 Lightning에서 지원되지 않는다. Lightning에서는 **Files related list**를 써라. Migration Tool로 File 필드의 파일을 Files object와 related list로 옮겨라.
- URL 형식이 다르다: Lightning에서는 URL이 **Knowledge Article Version ID**와 기타 파라미터를 포함하고, Classic에서는 URL이 **Knowledge Article ID**를 포함한다.
- Lightning Knowledge에서는 **Public Knowledge Base 패키지(PKB)**를 쓸 수 없다. Lightning Knowledge 아티클은 Experience Cloud와 Salesforce Sites에서 공유할 수 있다. 비인증 사용자와 아티클을 공유하려면 **Help Center**를 써라.
- 하나의 rich text 필드 안에 서로 다른 Salesforce Knowledge 아티클로의 링크를 최대 **100개**까지 둘 수 있다.

### 일반 사용 한계 (전수)

- 일부 authoring action이 다르게 동작하거나 사용 불가:
  - 편집 중에 published 아티클을 제거할 수 없다. 새 버전을 draft로 편집하는 동안 아티클은 published 상태를 유지한다. archive로 제거한 뒤 restore하여 draft를 편집할 수 있다.
  - **Archiving은 미래 날짜로 예약할 수 없다.** date 필드 기준으로 아티클을 주기적으로 archive하는 Flow를 만들 수 있다.
  - 미래 날짜로 발행을 예약해도 아티클에 알림이 없다. Lightning Knowledge에서는 발행 예약된 아티클 목록을 볼 수 없고, 예약된 발행을 취소할 수 없다.
- **Printable View** 액션은 Lightning Knowledge에서 사용 불가.
- 버전이 30개 초과인 아티클의 경우, 30번을 넘는 버전은 Salesforce Classic에 표시되지만 Lightning Experience에는 표시되지 않는다.
- 데이터 카테고리는 Lightning이나 Classic의 Knowledge list view에 표시되지 않는다. 우회: 데이터 카테고리로 아티클을 필터링하는 리포트를 만든다.
- 아티클의 published 버전이 있을 때만 ratings 컴포넌트에서 투표(vote) 정보를 볼 수 있다. 따라서 archived 아티클의 투표는 볼 수 없다(published 버전이 존재하지 않으므로).
- 번역을 위해 아티클을 내보낼 때, 첨부된 파일은 내보내지지 않는다. 번역이 다시 임포트될 때도 파일은 첨부 Files로 임포트되지 않는다.
- **Tab**과 **Table of Contents** 아티클 뷰는 지원되지 않는다.
- translation 상태 위에 호버해도 제출일 같은 관련 정보가 표시되지 않는다.
- approval 프로세스에 있는 아티클 레코드는 잠금 해제할 수 없다.
- Knowledge 아티클에 **macro**를 쓸 수 없다.
- (이미지 히스토리 note, verbatim) 2017년 12월 이전에는 Lightning Experience에서 이미지가 포함된 아티클이 작성되면 작성자만 이미지를 볼 수 있었다. 2017년 12월부로 이 문제가 해결되었고, 2017년 12월 이후 업로드된 사진은 Read 권한이 있는 모든 사용자에게 보인다. 2017년 12월 이전에 업로드된 사진은 다시 업로드해야 한다.
- **별점(Star ratings) 미지원** — Lightning Knowledge는 thumbs up과 thumbs down만 지원한다. 기존 Classic 조직의 별점은 자동 변환된다: **3, 4, 5 stars → thumbs up; 1 또는 2 stars → thumbs down.**
- 편집 중에 published translation을 제거할 수 없다. 새 버전을 draft로 편집하는 동안 translation은 published 상태를 유지한다.

### Cases와 함께 사용할 때의 한계 (전수)

- **case를 닫을 때(closing a case)** 아티클을 만드는 옵션은 Salesforce Classic에서만 사용 가능하다. Lightning에서는 Knowledge 컴포넌트에서 아티클을 만들 수 있다. case의 필드를 새 아티클로 매핑하여 draft를 만드는 quick action을 만들고 case 레이아웃에 추가할 수도 있다.
- Knowledge 컴포넌트에서 만든 아티클은 case에 자동으로 연결되지 않는다.
- case의 subject가 바뀌면, Knowledge 컴포넌트의 제안 아티클 목록이 새로고침되기 전에 업데이트가 저장되어야 한다.
- Lightning Experience의 case feed는 Knowledge action을 지원하지 않는다. 우회: 아티클 related list나 Knowledge 컴포넌트의 suggested articles 목록의 액션을 쓴다. related list가 좁은 컬럼에 있으면 액션이 표시되지 않지만 **View All**을 클릭할 수 있다.
- 아티클의 PDF를 case 이메일에 첨부하는 액션은 Lightning Experience의 Knowledge 컴포넌트에서 사용 불가.

### Console 한계 (전수)

- **Knowledge footer**는 Lightning Service Console에 없다. 대신 어떤 객체의 record home 페이지에든 Knowledge 컴포넌트를 추가하라. 어떤 객체에서든 knowledge 아티클을 만드는 global action이나 object-specific quick action도 만들 수 있다. 단, suggested article과 관련 액션은 cases에서만 사용 가능하다.
- Knowledge 컴포넌트를 pop out하여 새 화면으로 드래그할 수 없다.

### Lightning Knowledge 활성화 후 Salesforce Classic에서의 한계 (전수)

Lightning Knowledge 활성화 후 Salesforce Classic에서 사용 불가한 항목:

- Knowledge list view는 Lightning Experience에서만 사용 가능.
- record type이 article type을 대체하므로 article type 검색은 Lightning이나 Classic에서 사용 불가.
- 새 아티클의 default record type 설정: default 설정은 Lightning Knowledge에서 동작하고, Classic에서는 사용자가 record type을 수동으로 변경할 수 있다.
- Knowledge record type별 검색 필터링은 Lightning Experience에서만 사용 가능.
- Archived Articles별 검색 필터링은 Lightning Experience에서만 사용 가능(단, Article Management를 통한 것은 Salesforce Classic에서만 사용 가능).
- Lightning의 Files related list 안 파일은 Salesforce Classic에 표시되지 않는다.
- Salesforce Classic의 Knowledge 아티클 record 페이지에서 사용 불가: action과 related list의 페이지 레이아웃 선택; 2-column 페이지 레이아웃; Change Record Type 같은 일부 액션.
- Knowledge 객체에서 하나의 record type에만 배정된 picklist 값은 Salesforce Classic의 레코드에 표시되지 않는다.

### 다른 Salesforce 제품과 함께 사용할 때의 한계 (전수)

- Knowledge 아티클은 macro에 삽입할 수 없다.
- Salesforce for Android나 iOS를 쓰면 recent article이 object home에 표시되지 않는다.
- **Title**과 **URL Name** 필드는 필수이므로 페이지 레이아웃에서 제거할 수 없다. Experience Cloud 사이트는 페이지 레이아웃으로 Lightning Knowledge 아티클을 표시하므로, Experience Cloud 사이트에서 필수 필드를 제거할 수 없다.

---

## Salesforce Mobile App에서의 Knowledge 한계

Knowledge 아티클은 **Android v8.0+**와 **iOS v10.0+**의 Salesforce 앱에서 사용 가능하다. 아래 한계와 함께 지원된다.

> 마커(red square)는 그 한계가 해당 플랫폼에 **적용됨**을 의미한다. blank는 그 플랫폼에 적용되지 않음(한계가 아님)을 의미한다. 셀 검증: Android-only(iOS blank)인 행은 정확히 2개뿐 — "Tables are sometimes cut off…"와 "In global search, search results show articles in the language specified for the device…". 나머지 11개 행은 두 컬럼 모두 적용.

| Issue (한계) | Android v8.0+ | iOS v10.0+ |
|---|---|---|
| Only published articles are available—not draft or archived articles. | ✓ | ✓ |
| Articles can't be created, edited, translated, or archived. | ✓ | ✓ |
| Articles can't be linked to cases. (But links set up from the desktop site can be viewed on the Related tab.) | ✓ | ✓ |
| Smart links aren't supported. | ✓ | ✓ |
| Article ratings aren't supported. | ✓ | ✓ |
| Tables are sometimes cut off on the right side when included in article rich text fields. | ✓ | (blank) |
| Compact layouts display the article type API name instead of the article type name. So users see the article type API name in the highlights area when viewing an article. | ✓ | ✓ |
| When searching from the Articles home page, only articles in the user's language are returned and only if that language is an active Knowledge language (from Setup, **Customize > Knowledge > Knowledge Settings**). To see articles in another language, users can change to an active Knowledge language. From **My Settings**, use the Quick Find search box to locate the Language & Time Zone page. | ✓ | ✓ |
| In global search, search results show articles in the language specified for the device, regardless of the active Knowledge language. | ✓ | (blank) |
| Filtering search results by data categories, article type, validation status, or language isn't available. | ✓ | ✓ |
| In global search, articles don't appear in the list of recent records. | ✓ | ✓ |
| In global search results, search highlights and snippets don't appear. *(같은 행 sub-note: "이 기능들은 Articles home page에서 검색할 때 모든 버전의 Salesforce mobile app에서 사용 가능하다.")* | ✓ | ✓ |
| Knowledge articles aren't available when accessing Experience Cloud sites via the Salesforce mobile app. | ✓ | ✓ |

---

## 관련 노트

- [[Knowledge 데이터 모델 & API 개요]]
- [[Lightning Knowledge 셋업 & 구성]]
- [[Lightning Knowledge 데이터 카테고리 & 공유]]
