---
tags: [Service, Knowledge, LightningKnowledge, 다국어, 번역, Translation, Multilingual, ArticleManagement, Publish, Archive, Admin, Localization]
source: lightning_knowledge_guide.pdf (Spring '26, p.62–74)
created: 2026-06-17
aliases: [Knowledge 다국어, Knowledge 번역, Multilingual Knowledge Base, Translate Articles, Export Articles for Translation, Import Translated Articles, Publish Translations, Article Management 탭, Side-By-Side View, 번역 내보내기, 번역용 export, 아티클 언어 추가, Knowledge 언어 설정, localization vendor 번역, 아티클 발행과 아카이브, 아티클 archive 하기, 번역 아티클 import, 지원 언어 추가하는 방법]
---

# Lightning Knowledge 다국어 & 번역

> 여러 언어로 Knowledge 아티클을 지원하기 — 언어 추가, Article Management 탭, 번역 export/import, 발행·번역·아카이브, primary/translation 나란히 보기까지.

> 본 노트는 독자가 따라가는 작업 순서(개요 → 셋업 → 아티클 작업 → export → import → publish → translate → archive → side-by-side)로 재배열했다. PDF의 섹션 등장 순서와는 다소 다르다.

---

## 다국어 Knowledge 지원 개요

> **Editions:** standard block (Classic and Lightning).

Salesforce가 지원하는 언어로 아티클을 제공하여 더 넓은 청중에 도달한다. 언어를 추가하기 전에, 각 언어에 대해 Salesforce에서 직접 번역할지 translation vendor에게 export할지 결정한다. 작성자·리뷰어·translation manager·publisher에게 전달한다. 언어마다 다른 방법을 쓸 수 있다. **언어를 추가하면 삭제할 수 없다; inactive로 만들어 숨길 수만 있다.** 비활성화하면 New Article이나 Submit for Translation 대화상자에 더 이상 나타나지 않고, 비활성화 시 그 언어의 published 아티클이 reader에게 더 이상 보이지 않는다. 특정 언어를 숨기려면 Settings 페이지에서 언어 옆 **Active**를 해제한다.

하위 단계: Work with Articles and Translations; Publish Articles and Translations; Translate Articles in Lightning Knowledge; Archive Articles and Translations; Set Up Primary Article and Translation Side-By-Side View; Support a Multilingual Knowledge Base; Export Articles for Translation; Import Translated Articles.

---

## 다국어 Knowledge Base 셋업 (Support a Multilingual Knowledge Base)

> **Editions (deviation):** Available in: Salesforce Classic (not available in all orgs) and Lightning Experience. **Essentials and the Unlimited Edition** with Service Cloud; 추가 비용 others.
> **USER PERMISSIONS:** 여러 언어 셋업 — **Customize Application AND Manage Salesforce Knowledge.**

**Steps (전수):**

1. In Setup, Quick Find에 `Knowledge Settings`를 입력하고 `Knowledge Settings`를 선택.
2. `Edit`를 클릭.
3. **Multiple Languages**를 선택하고 언어를 추가.
   > Important: 인스턴스가 지원하는 언어를 추가할 수 있다. 하지만 지식베이스에 추가된 언어는 제거할 수 없다.
4. 언어별 설정을 선택:

   | Setting | Description |
   |---|---|
   | Active | Active languages appear in the New Article and Submit for Translation dialog boxes. Active/inactive status determines whether a published article is visible. E.g., if Spanish articles are published to your partner portal and you then make Spanish inactive, the articles no longer appear. |
   | Default Assignee | Automatically assigned articles submitted for translation. Can be an individual person or a queue. |
   | Default Reviewer | Automatically assigned finished translations ready to be reviewed or published. Can be an individual person or a queue. |

5. 변경을 저장.
6. (선택) 아티클을 번역하거나 완성된 번역을 리뷰하는 그룹에 아티클을 분배·배정하는 queue를 만든다. queue 셋업 시 **Knowledge Article Version** 객체를 쓴다.

---

## Article Management 탭 — 아티클과 번역 작업

> **Editions:** standard block (Classic and Lightning).
> **USER PERMISSIONS (전수):**

| To… | Permission |
|---|---|
| To create, edit, or delete articles | Manage Articles **AND** Create, Read, Edit, or Delete on the article type |
| To publish or archive articles | Manage Articles **AND** Create, Read, Edit, and Delete on the article type |
| To submit articles for translation | Manage Articles **AND** Create, Read, and Edit on the article type |
| To submit articles for approval | Permissions vary depending on the approval process settings |

**Article Management 탭**은 publishing 사이클(create, assign, translate, publish, archive, delete)을 통해 아티클을 작업하는 home 페이지다. 상담원은 아티클의 article type과 article action에 올바른 권한이 필요하다; Assign Article Actions to Public Groups 참조.

**List view 사이드바 옵션 (전수):**

- **View** 영역에서 Draft Articles, Published Articles, Archived Articles를 선택. draft 아티클을 자신에게 배정된 것 또는 누구에게나 배정된 것으로 필터링.
- 해당되면, View 영역의 **Translations** 탭을 클릭하고 Draft Translations 또는 Published Translations를 선택. 자신에게 배정된 것, translation queue에 배정된 것, 누구에게나 배정된 것으로 필터링.
- 현재 view를 정제하려면, article language 필터를 선택하고 **Find in View**에 키워드/구를 입력(archived 아티클에서는 비활성화됨).
- **Filter** 영역에서 드롭다운으로 카테고리를 선택하여 필터링.
- 표시되는 컬럼을 수정하려면 **Columns**를 클릭.

### Article Management 컬럼표 (전수 — Column / Description / View)

| Column | Description | View |
|---|---|---|
| Action | Displays the actions available for the article or translation. | All articles and translations |
| All User Ratings | Average ratings from users of your internal Salesforce org, Customer Portal, partner portal, and your public knowledge base. | Published and archived articles and published translations |
| Archived Date | Date the article was archived. | Archived articles |
| Article Number | Unique number automatically assigned to the article. | All articles and translations |
| Article Title | Click to view the article. | All articles |
| Assigned to | The user who is assigned work on the article. | Draft articles and translations |
| Assignment Details | Instructions for the assignment. | Draft articles and translations |
| Assignment Due Date | Date to complete work on the article. If the date has passed, it displays in red. | Draft articles and translations |
| Created Date | Date the article was written. | Draft articles and translations |
| Customer Ratings | Average ratings from users on the Customer Portal and the public knowledge base. | Published and archived articles and published translations |
| Language | The language an article is translated into. | Draft and published translations |
| Last Action | The date and type of the last action taken on a translation. | Draft and published translations |
| Last Modified by | Last person to update the article. | Draft articles and translations |
| Last Modified Date | Last date the article was edited. | All articles and translations |
| Most Viewed by all Users | Average views from users of your internal Salesforce org, Customer Portal, partner portal, and your public knowledge base. | Published and archived articles and published translations |
| Most Viewed by Customers | Average views from users on the Customer Portal and the public knowledge base. | Published and archived articles and published translations |
| Most Viewed by Partners | Average views from users on the partner portal and the public knowledge base. | Published and archived articles and published translations |
| Partner Ratings | Average ratings from users of your partner portal and public knowledge base. | Published and archived articles and published translations |
| Published Date | Date the article was published. | Published articles and translations |
| Source Article | The original article before translation. Click the article title to view. | Draft and published translations |
| Translated Article | The title of the translated article. Click the translation title to edit. | Draft and published translations |
| Translation Status | Status in the translation cycle. Hover over the icon to view status for each translation. If published, separate tabs for draft and published translations. | Articles submitted for translation |
| Type | The article's type (e.g., FAQ or Product Description) that determines what information the article contains. | All articles |
| Validation Status | Shows whether the content of the article has been validated. | All articles and translations, when enabled |
| Version | The article's version. Hover over the version number to view details about other versions. | All articles |

**Article Management 탭에서 할 수 있는 작업 (전수):**

- 검색어나 카테고리 드롭다운으로 아티클/번역을 찾는다.
- **New**를 클릭하여 아티클을 만든다.
- 선택 후 **Publish...**를 클릭하여 발행. "Publish Articles" article action이 있고 approval process가 셋업되어 있으면 **Publish...**와 **Submit for Approval** 버튼이 둘 다 보인다.
- 옆의 **Edit**를 클릭하여 수정.
- **Preview**를 클릭하여 end user에게 어떻게 보이는지 미리보기. Channel 드롭다운에서 public knowledge base를 제외하고 visible한 어떤 채널이든 선택.
  > Note: Knowledge 아티클을 preview할 때 Voting과 Chatter 정보는 사용 불가.
- 버전 번호를 클릭하여 다른 버전 목록을 본다.
- 선택 후 **Assign...**을 클릭하여 owner를 변경.
  > Note: 모든 draft 아티클은 assignee가 있어야 한다.
- 선택 후 **Delete**를 클릭하여 Recycle Bin으로 보낸다.
- 선택 후 **Archive...**를 클릭하여 published 아티클/번역을 archive.
- 선택 후 **Submit for Translation**을 클릭하여 번역 제출. 각 언어에 due date를 설정하고 다른 상담원이나 queue에 배정하여 translation vendor로 export.
- Related Links 영역의 **Export Articles for Translation**과 **Import Article Translations**로 export/import Setup 페이지로 이동.

---

## 번역용 아티클 Export

> **Editions (deviation):** Available in: Salesforce Classic (not available in all orgs) and Lightning Experience. **Essentials and the Unlimited Edition** with Service Cloud; 추가 비용 others.
> **USER PERMISSIONS:** 아티클 export — Manage Salesforce Knowledge AND Manage Articles AND Manage Knowledge Article Import/Export. 아티클 보기 — Read on the article type. 아티클 생성 — Read and Create on the article type.

아티클을 translation queue에 넣는다. 하나 이상의 queue를 만든다; 작성자/리뷰어가 번역 제출 시 queue를 선택한다.

> [!note] Note (verbatim)
> 24시간에 최대 **50 exports**, 그리고 최대 **15 pending exports**(Completed, Failed, Canceled 같은 final state에 진입하지 않은 export)를 가질 수 있다.

**Steps (전수):**

1. 번역할 아티클이 있는 translation queue를 만든다.
2. Article Management 탭에서 아티클을 선택하고 **Submit for Translation**을 클릭.
3. 어떤 언어로 번역할지 지정하고, 번역을 해당 language translation queue에 배정.
4. From Setup, Quick Find에 `Export Articles for Translation`을 입력하고 선택.
5. 아티클이 있는 queue를 선택.
6. **All articles**(queue의 모든 아티클 export) 또는 **Updated articles**(수정/추가된 아티클만) 중 선택.
7. **Continue**를 클릭.
8. source/target 언어 쌍을 선택. Salesforce는 각 언어 쌍의 모든 article type에 대해 별도의 .zip 파일을 만든다. **성공적 import를 위해 .zip 파일 구조를 유지하라.**
9. 번역 후 리뷰/발행하려면 user나 queue를 선택.
10. 파일 **character encoding**을 선택 (전수):
    - ISO-8859-1 (General US & Western European, ISO-LATIN-1)
    - Unicode
    - Unicode (UTF-8) **default**
    - Japanese (Windows)
    - Japanese (Shift_JIIS) *(sic — PDF 인쇄 그대로)*
    - Chinese National Standard (GB18030)
    - Chinese Simplified (GB2312)
    - Chinese Traditional (Big5)
    - Korean
    - Unicode (UTF-16, Big Endian)
11. .csv 파일의 delimiter(표 형식으로 변환 시 separator)를 선택: **tab (default)** 또는 **comma**.
12. **Export Now**를 클릭.

- 완료 시 이메일로 통지받는다. Article Import and Export Queue(Setup → **Article Imports and Exports**)로 상태를 확인. **export된 파일을 unzip하되, 성공적 import를 위해 파일 구조를 유지하라.**

---

## 번역된 아티클 Import

> **Editions:** standard block (Classic and Lightning).
> **USER PERMISSIONS:** 아티클 export — Manage Salesforce Knowledge AND Manage Articles AND Manage Knowledge Article Import/Export. 아티클 보기 — Read on the article type. 아티클 생성 — Read and Create on the article type.

Setup의 Import Article Translations를 쓴다. **같은 Salesforce org**에서 export된 아티클만 import할 수 있다(test/sandbox에서 export하여 production으로 import 불가).

**Steps (전수):**

1. From Setup, Quick Find에 `Import Article Translations`를 입력하고 선택.
2. import 후 Salesforce가 번역을 어떻게 처리할지 선택:

   | Option | Description |
   |---|---|
   | Review imported translations on the Article Management tab before publishing | Add imported translations to a queue from which agents can review them. |
   | Publish translations immediately on import | Publish imported translations without reviews. |

3. import하는 아티클의 언어를 선택.
4. 발행 전 리뷰하는 경우, 파일을 보낼 user나 queue를 선택.
5. **Browse**를 클릭하고 translation .zip 파일을 선택한 뒤 **Open**을 클릭. 모든 번역 파일을 **language code**와 같은 이름의 폴더(예: 프랑스어 아티클은 `fr` 폴더)에 넣는다. 이 폴더를 zip하여 import 파일을 만든다.

import .zip 파일 구조 (verbatim — 아래 `fr`/`articletypearticlename`/`articlename`은 placeholder 예시값. target 언어가 French인 경우 구조의 시작):

```
import.properties
-fr
--articletypearticlename_kav
---articlename.csv
---[Article collateral, html, images, etc.]
```

   > [!important] Important — 파일 구조 (verbatim)
   > export된 파일 구조와 확장자가 Salesforce에서 export한 것과 일치하는지 확인하라.
6. **Import Now**를 클릭. (업로드할 번역 아티클이 더 있으면 4–6단계 반복.)
7. **Finish**를 클릭.

- import가 끝나면 이메일 통지가 발송된다. Setup → **Article Imports and Exports**로 상태를 본다.

---

## 아티클과 번역 발행 (Publish)

> **Editions (deviation):** Available in: Salesforce Classic (not available in all orgs) and Lightning Experience. **Essentials and Unlimited Editions** with Service Cloud; 추가 비용 others.

발행은 아티클/번역을 선택된 모든 채널에서 visible하게 만든다. translation이 있는 아티클을 발행하면 모든 translation도 발행된다. Article Management 탭이나 detail 페이지에서 발행한다. Classic에서는 article type의 publish 권한과 "Publish Articles" 또는 "Publish Translated Articles" article action이 필요하다. Lightning에서는 연관된 User Profile 권한이 필요하다.

**Considerations (전수):**

- 직접 발행하거나 미래 날짜와 (선택) 시간으로 발행을 **schedule**할 수 있다. 예약된 아티클은 Salesforce Classic의 title 옆 **pending icon(orange clock)**과 함께 Draft Articles 필터에 계속 나타난다. 호버하여 발행 날짜를 본다. **pending icon은 Lightning Experience에서 사용 불가.**
  > Tip: 예약 발행을 취소하려면 아티클/번역 detail이나 edit 페이지에서 **Cancel Publication**을 클릭.
- **발행 시각은 15분 간격으로 발생**; 발행이 지정한 정확한 시각과 일치하지 않을 수 있다.
- 예약된 아티클의 pending icon은 list view에서 지원되지 않는다.
- pending icon은 Salesforce Classic의 Article Management 탭에서만 표시된다.
- **Cancel Publication** 버튼은 Lightning Experience의 draft 아티클에서 사용 불가.
- approval process에 있는 아티클은 즉시 발행 예약되어 있어도 발행을 위해 queue로 보내질 수 있다(아티클이 매우 크거나, active 언어가 많거나, 그 시각에 발행되는 다른 아티클이 많을 때). **Last Modified By** 필드에 **Automated Process**가 표시된다.
- 발행되는 draft가 현재 published 아티클의 working copy면, 원본의 새 버전으로 발행된다.
- 이미 발행된 아티클/번역의 경우, **Flag as new version**을 선택하여 선택된 채널에서 아티클 옆에 new article 아이콘이 표시되게 한다. 이 체크박스는 아티클을 처음 발행할 때는 사용 불가(새 아티클은 기본으로 아이콘이 표시됨).
- 발행 예약된 아티클을 배정하면, 예약 발행도 취소된다.
- 발행을 예약하면 배정 정보가 제거되고, 예약한 사용자가 아티클에 배정된다.
- 다른 상담원이 같은 아티클을 동시에 작업하면 충돌이 발생할 수 있다. 그 아티클은 잠시 표시되더라도 후속 사용자에게 사용 불가하며, 액션 수행 시 conflict error가 발생한다.
- "Publish Articles" article action이 있고 approval process가 셋업되어 있으면 **Publish...**와 **Submit for Approval** 버튼이 둘 다 보인다.

### Table 5 — Translated Article에서 사용 가능한 Publishing 액션

| Action | Translated Article Version Where Action is Exposed |
|---|---|
| Assign | Draft Primary, Draft Translation |
| Submit for Translation | Draft Primary, Published Primary |
| Publish | Draft Primary, Draft Translation |
| Archive | Published Primary |
| Edit | Draft Primary, Draft Translation |
| Edit as Draft | Published Primary |
| Delete | Draft Primary, Draft Translation |
| Change Record Type | Draft Primary |
| Submit for Approval | Draft Primary |

---

## Lightning Knowledge에서 아티클 번역 (Translate Articles)

> **Editions (deviation):** Available in: Lightning Experience; 나머지 standard.
> **USER PERMISSIONS:** 번역 아티클 작업 — **Manage Articles AND Create, Read, Edit, Delete, or Article Translation-Submit for Translation** (user profile에 배정된 액션에 따라).

상담원/작성자에게 번역 아티클 접근을 부여한다. user profile에 authoring action을 추가하여 상담원이 primary language 버전과 translation draft에 접근하게 한다.

### Translate Articles 액션표 (Action / Description / Article Status)

| Action | Description | Article Status |
|---|---|---|
| Archive | Archiving an article permanently deletes its published translations, so obsolete articles don't display to agents and customers on your org's Salesforce Knowledge channels. (To archive a translation, archive its primary article.) | To archive a translation, archive its primary article. |
| Assign... | Assigns changes to the owner of the translation | Draft translations |
| Delete | Deleting a translation permanently removes it from the knowledge base. You can't undelete a draft translation. | Draft translations |
| Edit | Editing modifies the translation's content or properties. | Draft and published translations |
| Preview | Previewing shows how the translation appears to end users. (Voting and Chatter information isn't available when previewing.) | Draft and published translations |
| Publish... | Publishing translations makes them visible in all channels selected. | Draft translations |
| Submit for Translation | Creates translation drafts for the current Primary Language Version | *(status 셀 미인쇄)* |

**추가 notes (전수):**

- 아티클 translation의 채널을 변경한 뒤 아티클을 발행할 수 없다(에러 발생). 채널을 변경할 때, 아티클 translation의 채널이 일치하는지 확인하고, primary language 버전보다 먼저 translation을 발행하라.
- URL로 translation이 있는 draft 아티클에 접근할 때, 아티클은 조직의 primary language로 기본 설정된다. primary language가 설정되지 않았으면, draft 아티클은 가능한 경우 보는 사용자의 언어로 표시된다.
- draft 아티클을 approval로 보내면 잠기고 authoring action을 수행할 수 없다.
- **번역 전용으로 만든 페이지 레이아웃에 authoring action을 추가하려면:**
  1. **Object Manager** 탭을 클릭하고 **Knowledge** 객체를 선택.
  2. Page Layout 목록에서 페이지 레이아웃을 선택.
  3. **Mobile and Lightning Actions**에서 **Publish, Edit, Delete, Assign, Submit for Translation** 액션을 페이지로 드래그.
  4. 변경을 저장.

---

## 아티클과 번역 아카이브 (Archive)

> **Editions (deviation):** Available in: Salesforce Classic (not available in all orgs) and Lightning Experience. **Essentials and Unlimited Editions** with Service Cloud; 추가 비용 others.

아카이브는 obsolete한 published 아티클/번역을 제거한다. Article Management 탭에서 published 아티클/번역을 archive할 수 있다 — real time(now) 또는 scheduled. now로 archive → **Archived Articles** view로 바로 이동. scheduled → Published Articles view에 **pending icon(orange clock)**과 함께 계속 표시; 호버하여 archive 날짜를 본다; archive 날짜에 자동으로 Archived Articles로 이동.

> [!note] Note (전수)
> - 다른 상담원이 같은 아티클을 동시에 작업하면 충돌이 발생할 수 있다(publish와 같은 conflict-error 동작).
> - 아카이브 예약된 published 아티클을 편집하면, 아카이브도 취소된다.
> - 아티클에 draft 버전이 있는 published translation이 있으면, 아카이브 시 draft 버전이 삭제된다.
> - **Lightning Experience에서 Knowledge 아티클을 아카이브하면 그 아티클의 published translation도 영구 삭제된다.**
> - 연관된 draft 버전이 아직 있는 아티클의 primary 버전은 아카이브할 수 없다.

> [!tip] Tip
> 예약된 아카이브를 취소하려면 아티클 detail 페이지에서 **Cancel Archive**를 클릭.

---

## Primary Article과 Translation 나란히 보기 셋업 (Side-By-Side View)

> **Editions (deviation — 특히 다름):** Available in: Salesforce Classic (not available in all orgs) and Lightning Experience. **Salesforce Knowledge is available in the Unlimited Edition with Service Cloud.** 추가 비용으로 **Essentials, Professional, Enterprise, Performance, and Developer Editions.** *(Note: 여기서는 Essentials가 추가비용 목록으로 이동했다.)*
> **USER PERMISSIONS:** 셋업 — **Manage Salesforce Knowledge AND Manage Articles**. 아티클 보기 — **Allow View Knowledge**.

> [!important] Important (verbatim)
> Where possible, we changed noninclusive terms to align with our company value of Equality. We maintained certain terms to avoid any effect on customer implementations.

**Steps (전수):**

1. From Setup, **Object Manager** 탭을 선택.
2. **Knowledge** 객체를 선택. 그다음 **Lightning Record Page**를 선택.
3. **Edit**를 클릭 (Lightning App Builder로 이동).
4. 오른쪽 컬럼에 **Translations** 탭을 만들고 "Translations"로 이름 짓는다.
5. **Translation Primary Article** 컴포넌트를 새 Translations 페이지로 드래그.
6. 필요에 따라 컴포넌트 visibility 필터를 설정. 예: 필터를 **Is Primary Language Equal False**로 설정하면, primary language 레코드에 있을 때 primary article 컴포넌트가 표시되지 않는다(두 컬럼에서 같은 버전의 아티클을 보지 않게 됨).
7. 페이지를 저장하고 활성화.

---

## 관련 노트

- [[Knowledge REST API — Actions & Manage]]
- [[Lightning Knowledge 아티클 임포트]]
