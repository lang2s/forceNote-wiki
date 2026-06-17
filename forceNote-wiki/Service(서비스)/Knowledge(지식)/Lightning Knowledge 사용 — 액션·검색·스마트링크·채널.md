---
tags: [Service, Knowledge, LightningKnowledge, 액션, 검색, SmartLink, 채널, AuthoringActions, KnowledgeComponent, PersistentLink, CaseFeed, Admin]
source: lightning_knowledge_guide.pdf (Spring '26, p.23–39)
created: 2026-06-17
aliases: [Lightning Knowledge 사용, Authoring Actions, Knowledge 검색, Smart Links, Knowledge 채널 공유, Insert Article into Channel, Persistent Link, Lightning Knowledge Component, Communication Channel Mapping, 스마트링크와 영구링크 차이, Smart Link vs Persistent Link, 아티클 URL 공유, Share Article URL, 케이스에서 아티클 공유, case feed 아티클 링크, 케이스에 아티클 첨부, 아티클 검색 방법, global search 아티클, Knowledge Home 액션, Knowledge 컴포넌트 사용, 채널에 아티클 삽입]
---

# Lightning Knowledge 사용 — 액션·검색·스마트링크·채널

> 채널에 아티클 삽입/URL 공유 셋업, 아티클 검색, authoring action, Knowledge 컴포넌트, 스마트 링크, 영구 링크까지 Lightning Knowledge를 실제로 사용하는 방법.

> [!note] Pattern C — 시각 자료
> 이 가이드의 일부 화면(Knowledge home의 bulk action "(1)"·record-level dropdown "(2)" 콜아웃 등)은 PDF에 스크린샷으로만 존재하며 pdftotext로 추출되지 않았다. 본 위키는 본문 텍스트 설명만 담고 스크린샷은 재현하지 않는다.

---

## 채널에 아티클 삽입 액션 셋업

**Title (본문 H1):** Set Up Actions to Insert Articles into Channels in Lightning Knowledge

> **Editions (deviation):** Available in: Lightning Experience and all editions with Knowledge except Essentials. Salesforce Knowledge는 Essentials와 Unlimited Edition with Service Cloud에서 사용 가능; 추가 비용으로 Professional/Enterprise/Performance/Developer.

**USER PERMISSIONS (전수):**

| To… | Permission |
|---|---|
| To administer Salesforce Knowledge and create, edit, and delete page layouts | Customize Application **AND** Manage Salesforce Knowledge |
| To send article content in emails | Edit on cases **AND** Read on knowledge articles |
| To send article content in social, chat, and messaging channels | Edit on cases **AND** Edit on the social, chat, or messaging object **AND** Read on knowledge articles |
| To share internal articles externally | Share internal Knowledge articles externally (under Administrative Permissions) |

- Lightning Knowledge 컴포넌트와 related list 액션으로, 상담원이 아티클 콘텐츠를 고객 이메일 본문과 social·chat·messaging 대화에 직접 임베드할 수 있다. 각 record type과 채널에 대해 어떤 아티클 필드가 포함될지 선택하는 **communication channel mapping**을 만든다.
- Setup 요구사항:
  - 이메일에서 공유하려면 **Email-to-case**가 활성화되어야 한다. case 페이지 레이아웃에 **SendEmail** 액션이 있어야 한다. SendEmail 레이아웃에 **HTML Body or Text**가 있어야 한다.
  - social 포스트에서 공유하려면 **Social Customer Service** 활성화, social account, case 페이지 레이아웃의 Social 채널이 필요하다.
  - chat/messaging에서 공유하려면 **Chat** 또는 **Messaging**을 구성하고 채널을 페이지 레이아웃에 추가한다.
  > Note: Lightning 페이지에 **CaseArticle** related list가 있으면, Insert Article into Email 사용 중에 페이지가 reload되어 email publisher action이 reload되고 저장 안 된 콘텐츠를 잃을 수 있다. Case Article related list를 제거하거나, 아티클을 먼저 첨부한 뒤 email publisher를 시작하라.
  > Note: 이 기능은 Essentials edition에서 사용 불가하다 — communication channel mapping을 구성하려면 record type이 활성화되어야 하기 때문이다.

**Steps (전수):**

1. Object Manager에서 **Knowledge** 객체를 선택.
2. **Communication Channel Mappings** 아래에서 **New**를 클릭.
3. label과 name을 입력.
4. 원하는 채널을 **Selected Channels** 목록에 추가. (각 채널은 다른 컨텍스트를 갖는다. 동일한 콘텐츠 필요가 있을 때만 여러 채널용 매핑을 만들라. 예: 이메일에서는 rich text 필드를 공유하지만 다른 채널에서는 안 함. 채널용으로 지정된 text 필드를 선택/생성할 것을 권장.)
5. 아티클 공유 시 포함할 필드를 추가.
   - social, chat, messaging에서는 **plain text**만 지원된다. rich text 필드는 스타일/포맷이 제거되고 텍스트만 삽입된다.
   - **이메일에 smart link를 포함하거나 동영상을 임베드할 수 없다.** HTML iframe은 이메일 발송 전에 제거된다.
   - 다음 필드는 communication channel에서 지원되지 않는다: **isDeleted, Language, MultiPicklist and picklist fields, Publication Status, Source, Validation Status.**
6. 필드 레이블과 관련 파일을 포함할지 선택. 기본적으로 필드 레이블은 모든 채널에 포함되고 관련 파일은 이메일에 첨부된다. 필드 레이블을 숨기려면 **Omit field labels**를 선택. 파일 첨부를 건너뛰려면 **Don't attach related files to emails**를 선택.
7. **Save**를 클릭. 액션이 case의 Knowledge 컴포넌트와 article related list에 나타난다.
8. (선택) 사용자가 **internal** 아티클의 콘텐츠를 공유하게 하려면, 프로필이나 permission set의 App Permissions에서 **Share internal Knowledge articles externally**를 활성화.

---

## 채널·Case Publisher에서 아티클 URL 공유 액션 셋업

> **Editions:** standard block (Classic and Lightning).
> **USER PERMISSIONS:** Salesforce Knowledge 관리 — Customize Application **AND** Manage Salesforce Knowledge. case feed에서 아티클 링크 공유 — Edit on Case **AND** Read on Knowledge.

상담원은 Salesforce Site나 Experience Cloud 사이트의 아티클 링크를 case feed에 삽입할 수 있다. Lightning에서는 email, social posts, chat, messaging에서 아티클 URL을 공유한다. Classic에서는 email, social, Experience Cloud publisher에서 아티클 URL을 보낸다. Lightning 페이지(또는 Classic에서는 Service Console)에 Knowledge 컴포넌트가 있어야 하고, Salesforce Site나 Experience Cloud가 셋업되어 있어야 한다. 조직에 관련 채널(email, Social Customer Service, Chat)이 구성되어 있어야 한다.

**Steps (전수):**

1. From Setup, Quick Find 박스에 `Knowledge`를 입력하고 `Knowledge Settings`를 선택.
2. `Edit`를 클릭.
3. **Share Article via URL Settings** 아래에서 **Allow users to share articles via public URLs**를 선택.
4. **Available Sites** 목록에서 상담원이 볼 Salesforce Sites와 Experience Cloud 사이트를 선택하여 **Selected Sites** 목록에 추가.
5. `Save`를 클릭.

---

## Use Your Lightning Knowledge Base 개요

> **Editions (deviation):** Available in: Lightning Experience; 나머지 standard.

아티클 검색, 아티클 작성·관리, Lightning Service Console의 Knowledge 컴포넌트 사용, Knowledge 리포트 생성을 한다. (리포트는 [[Lightning Knowledge 아티클 리포팅]] 참조)

---

## 아티클 검색 (Search for Knowledge Articles)

> **Editions (deviation):** Available in: Lightning Experience; 나머지 standard.

global search 박스나 Lightning Service Console용 Knowledge 컴포넌트에서 아티클을 검색한다. Knowledge용 **advanced search**로 결과를 정제(language, publishing status, validation status, record type, data category group으로 prefilter).

> [!note] Note (verbatim)
> Setup에서 Knowledge 검색 필터를 구성해도, global search의 Knowledge용 advanced search 필터는 바뀌지 않는다.

**Steps (전수):**

1. global search 박스 옆 드롭다운에서 **Knowledge**를 선택. 드롭다운 상단에 `knowledge`를 입력한 뒤 Knowledge를 선택할 수도 있다.
2. 선택적으로, 결과 목록 하단의 **Advanced Search**를 클릭. **Einstein Search**가 활성화되어 있으면, 검색 박스 옆 **Filters**를 선택하여 Advanced Search 페이지에 접근; 사용 가능한 필터에서 선택.
3. 검색어를 입력, 최대 **100자**. 100자를 초과하면 처음 100자만 사용된다.
4. 검색을 실행하려면 **Enter**를 누른다.

- Lightning Service Console용 Knowledge 컴포넌트로도 검색할 수 있다. Advanced Search도 거기서 사용 가능.

**SEE ALSO:** How Einstein Search Works.

---

## Authoring Actions

> **Editions (deviation):** Available in: Lightning Experience; 나머지 standard.

edit, publish, restore 같은 authoring action으로 Knowledge home과 아티클 record 페이지에서 아티클을 관리한다. 올바른 profile 권한이 있는 관리자·상담원·내부 직원이 액션을 수행할 수 있다.

### Actions in Knowledge Home

Knowledge list view(Knowledge home 포함)에서, 하나 또는 여러 레코드에 영향을 주는 record action을 수행한다. 사용자에게 권한이 있으면 액션이 나타난다. 여러 레코드를 업데이트하려면 **bulk actions (1)**를 쓰고, record-level 액션은 각 아티클 옆 **dropdown (2)**을 쓴다. *(UI 스크린샷 콜아웃 — 이미지 미추출)*

### Actions in Record Pages

아티클 record 페이지의 경우, 페이지 레이아웃과 사용자 권한으로 어떤 authoring action이 사용 가능한지 제어한다. 나타나는 액션은 아티클의 publishing status에도 의존한다. **page layout editor**에서 authoring action을 추가한다.

### When Are Lightning Authoring Actions Available?

> **Editions (deviation):** Available in: Lightning Experience; 나머지 standard.

Lightning Knowledge 페이지 레이아웃에서, 액션은 아티클의 publication status 기준으로 표시/숨김된다. Knowledge home에서는 적절한 권한이 있는 사용자에게 모든 list view에 bulk action이 나타난다. 아티클의 publication status와 사용자 권한이 가용성을 결정한다.

각 행 = 액션, Record Status = 그 액션이 노출되는 publication status.

| Action | Description | Record Status |
|---|---|---|
| New | Create an article. | Knowledge home only |
| Edit | Edit a draft article. | Draft |
| Edit as Draft | Create a draft from a published article. If a draft exists, you don't see this button. | Published |
| Assign | Change the Assigned To field for an article or translation. | Draft |
| Publish | Publish a draft article. When you publish a primary-language article, any translations in the publication queue are also submitted. | Draft |
| Delete Draft | Permanently delete drafts of primary-language or translated articles. You can't recover deleted drafts. | Draft |
| Delete Article | Delete an archived article. | Archived |
| Change Owner | Set the article version's owner. The owner can be a user or a queue. Owners must have permission to read articles. | Draft |
| Change Record Type | Assign a new record type. This action can affect the page layout and available fields. | Draft |
| Archive | Archive a published article. Archive translations by archiving the primary-language article. | Published |
| Restore | Restore a draft from an archived article. You can restore the latest version of an archived article. You can also restore past versions of published articles from the record page while viewing the version you want to restore. | Archived |
| Submit for Approval | Send the article for approval and assign an approver. Approvals must be enabled. | Draft |
| Submit for Translation | Submit the article to the translation queue or assign to a user. Multiple languages must be enabled. | Draft, Published |

**Knowledge home에서 사용 가능한 Bulk actions (전수):** Assign; Archive; Delete Draft; Delete Article; Publish; Restore; Submit for Translation.

**SEE ALSO:** Lightning Knowledge User Access.

---

## Lightning Knowledge 컴포넌트 사용 가이드라인

> **Editions (deviation):** Available in: Lightning Experience; 나머지 standard.

- Knowledge 컴포넌트는 Salesforce 어디에서나 팀을 지식베이스와 연결한다. 팀/상담원은 cases와 다른 객체에서 service console에서 쓴다. 아티클을 검색·첨부하고, follow/unfollow한다. cases에서 상담원은 case에 대한 suggested article을 보거나 컴포넌트에서 검색한다.
- 컴포넌트는 샘플 Lightning Service Console에 자동 추가된다. **Lightning App Builder**로 custom Lightning console app에 추가할 수 있다.
  > Tip: 콘솔에 국한되지 않는다 — 표준 navigation이 있는 앱에도 추가할 수 있다. Lightning App Builder로 레코드 페이지에 추가하라.
- **Article Suggestions** — 두 도구 중 선택:
  - **Suggested Articles** — 키워드 기반 검색. Lightning Knowledge 활성화 시 자동 활성화.
  - **Einstein Article Recommendations** — 과거 cases와 case-article 첨부를 분석; AI(용어 중첩)에 의존하며, 상담원 피드백과 새 case 데이터 기반으로 지속 정제. 활성화하면 모든 Lightning Knowledge 사용자가 추천을 본다.
  - suggested article은 검색 없이 컴포넌트로 바로 전달된다. 과거 case와 article 데이터 기반의 지능적 제안을 보려면 Einstein Article Recommendations를 켠다.
- **Search and Sort Your Results** — 검색 박스를 쓰고, pre-filtering은 Advanced Search를 쓴다. sort 아이콘을 클릭하여 선택: relevance, publish date(published), last modified date(drafts), A to Z, Z to A. **정렬은 suggested article에 적용되지 않는다.** 기본은 relevance 정렬. suggested article로 돌아가거나 새 case로 가면 정렬이 relevance로 리셋된다.
- **Attach and remove articles** — 상담원이 아티클을 case에 첨부하고, 각 아티클 옆 드롭다운으로 제거한다.
- **Follow and Unfollow** — 상담원이 드롭다운으로 컴포넌트에서 follow/unfollow한다. follow는 나중에 읽을 아티클을 저장하는 데 도움. read 접근이 있는 관리자·상담원·내부 직원은 어떤 상태(published 또는 draft)의 아티클도 follow할 수 있다. follow/unfollow를 활성화하려면 **Setup > Chatter > Feed Tracking**에서 feed tracking을 활성화하라.
- **Share articles in Case Emails and Other Channels** — 이메일·social posts·대화에 아티클 텍스트를 삽입하거나, Salesforce Sites와 Experience Cloud 사이트의 아티클 링크를 삽입한다. 컴포넌트에서 액션을 수행하면 service console이 모든 컴포넌트를 새로고침한다.

### 채널에서 아티클 공유 (Share Articles in Channels)

> **Editions (deviation):** Available in: Lightning Experience and all editions with Knowledge except Essentials. Essentials and Unlimited Edition with Service Cloud; 추가 비용 others.
> **USER PERMISSIONS:** case feed에서 아티클 콘텐츠 공유 — Edit on cases AND Read on knowledge articles. case feed에서 internal 아티클 공유 — **Allow user to share internal knowledge articles externally**.

email, Social Post, Chat, Messaging에서 아티클 콘텐츠를 공유한다. Lightning 페이지에 Knowledge 컴포넌트가 필요하다. 조직에 관련 채널이 셋업되어 있어야 한다. translation의 채널을 변경한 뒤 발행할 수 없다 — 에러가 발생한다. 채널을 변경할 때, 아티클의 translation 채널이 일치하는지 확인하고, primary language 버전보다 먼저 translation을 발행하라.

**Steps (전수):**

1. Knowledge 컴포넌트나 article related list에서 다음 중 하나를 선택:
   a. **Insert Article into Social Post** (case origin이 social post여야 함).
   b. **Insert Article into Email**.
   c. **Insert Article into Conversation** (Chat 또는 Messaging).
2. **Insert**를 클릭.

- Email과 Social Post의 경우, 아티클이 case에 첨부되지 않았다면 이 액션이 case의 related list에 추가한다. 콘텐츠는 커서 위치에 삽입된다. Social Post record home의 **Insert Action**으로 아티클을 (case 레코드가 아닌) Social Post 레코드에 첨부할 수도 있다. **Chat과 Messaging의 경우, case에서 생성했더라도 아티클은 case에 첨부되지 않는다.**

**SEE ALSO:** Set Up Actions to Insert Articles into Channels in Lightning Knowledge.

### 채널에서 아티클 URL 공유 (Share Article URLs in Channels)

> **Editions:** standard block (Classic and Lightning).
> **USER PERMISSIONS:** case feed에서 아티클 링크 공유 — Edit on Case **AND** Read on Knowledge.

Salesforce나 Experience Cloud 사이트의 아티클 링크를 case feed에 삽입한다. Lightning: email, social, chat/messaging. Classic: email, social, Experience Cloud publisher. Lightning 페이지(또는 Classic에서는 Service Console)에 Knowledge 컴포넌트가 필요하고, Salesforce Site나 Experience Cloud 사이트가 구성되어 있어야 하며, 관련 채널이 필요하다.

**Steps (전수):**

1. Knowledge 컴포넌트나 article related list에서 선택:
   a. **Salesforce Classic:** 원하는 사이트에 대해 **Attach and share article** 또는 **Share article**를 선택. Email이 default 액션; 삽입 전에 case feed에서 social이나 Experience Cloud로 전환할 수 있다.
   b. **Lightning (email):** **Insert URL into Email** 후 사이트를 선택.
   c. **Lightning (chat/messaging):** **Insert URL into Conversation** 후 사이트를 선택.
   d. **Lightning (social):** **Insert URL into Social Post** 후 사이트를 선택.
2. **Insert URL**을 클릭.

**Considerations (전수):**

- 아티클은 **published**여야 한다. draft와 archived는 사용 불가.
- 아티클은 **공개적으로(publicly)** 공유되어야 한다(Public Knowledge Base에 visible, 또는 customer/partner에게 visible).
- 선택된 목록의 어떤 사이트에서든 아티클 링크를 포스트할 수 있다 — 아티클이 거기 visible하지 않거나 고객이 접근권이 없어도. 상담원은 공유 전에 가용성을 확인해야 한다.
- 아티클이 이전에 case에 첨부되지 않았다면, 이 액션이 related list에 추가한다.

---

## Smart Links

> **Editions:** standard block (Classic and Lightning).
> **USER PERMISSIONS (parent):** 아티클 생성 — **Manage Articles AND Read and Create on the article type.** *(하위 Insert 변형은 "Read and Create in the user profile")*

아티클 간 링크를 걸거나 외부 웹사이트/리소스에 아티클 링크를 임베드한다. smart link를 쓰면 링크가 아티클 **channel, version, URL name** 기준으로 자동 업데이트되므로 사용자는 항상 올바른 버전을 받는다.

### Insert Smart Links into Articles

> **USER PERMISSIONS:** 아티클 생성 — Manage Articles AND **Read and Create in the user profile**.

**Steps (전수):**

1. 아티클을 편집.
2. rich text editor 툴바에서 **Smart Link 아이콘**을 클릭.
3. (선택) publication status를 선택하고, 여러 언어가 있으면 언어를 선택.
4. **Link to Article** 목록에서 아티클을 선택.
5. (선택) public site와 Salesforce Classic에서 smart link가 열리는 방식을 지정하려면, 드롭다운에서 **target**을 선택.
6. (선택) Lightning Experience 앱과 콘솔에서 링크가 열리는 방식을 지정하려면, **Lightning target**을 선택.
7. **Insert Link**를 클릭.

- smart link는 editor에 표시되는 것보다 더 많은 문자를 사용한다. 문자 제한을 초과하면 관리자에게 제한 증가를 요청하라. (rich text 필드가 활성화되어 있어야 함)

### Target Behavior for Smart Links

**Target Options** (링크의 `target` 속성; Salesforce Classic과 Salesforce 외부에서 열리는 방식 결정) — 전수:

- **Not set** — target을 선택하지 않으면, 아티클 저장 시 시스템이 속성을 **`_blank`**로 설정.
- **Frame** — 지정된 frame에서 링크된 아티클을 연다.
- **New Window (`_blank`)** — 새 창이나 탭에서 연다.
- **Topmost Window (`_top`)** — 창의 full body에서 연다.
- **Same Window (`_self`)** — 같은 frame에서 연다.
- **Parent Window (`_parent`)** — parent frame에서 연다.

**Lightning Target Options** (링크의 `data-lightning-target` 속성; Lightning Experience 앱과 콘솔에서 열리는 방식 결정) — 전수:

- **Not set** — 시스템이 default `_blank`를 사용(새 브라우저 탭).
- **Lightning App Default (`_new`)** — console 앱에서 새 workspace tab이나 subtab을 연다(사용자 컨텍스트별). 표준 navigation 앱에서는 새 브라우저 탭을 연다.
- **Same Tab or Workspace (`_self`)** — console 앱에서 새 workspace tab이나 subtab을 연다(사용자 컨텍스트별). 표준 navigation 앱에서는 같은 탭에서 연다.
- **New Browser Tab (`_blank`)** — 새 브라우저 탭을 연다.
- **New Workspace (`_workspaceTab`)** — console 앱에서 새 workspace tab을 연다. 표준 navigation 앱에서는 새 브라우저 탭을 연다.
- **New Subtab (`_subtab`)** — console 앱에서 새 탭을 연다. 표준 navigation 앱에서는 같은 탭에서 연다.

**Lightning Target이 설정되지 않으면 Lightning에서 무슨 일이 일어나는가? (전수):**

- `target` 속성이 설정되지 않으면, Lightning에서 열린 smart link는 새 브라우저 탭에서 열린다(`data-lightning-target`이 `_blank`로 가정됨).
- `target`은 지정되었지만 `data-lightning-target`은 아닐 때의 default 동작:
  - `target`이 `_blank` → Lightning target은 **Lightning App Default (`_new`)** 사용.
  - `target`이 `_self`, `_top`, `_parent` → Lightning target은 **Same Tab or Workspace (`_self`)**.
  - `target`이 custom frame name → Lightning target은 **New Browser Tab (`_blank`)**.

### Smart Link Considerations

- smart link는 표시되는 것보다 더 많은 문자를 사용한다; 제한을 초과하면 관리자에게 증가를 요청하라.
- Experience Cloud 사이트의 smart link는 **Article Content** 컴포넌트를 써야 한다. custom 컴포넌트로는 제대로 resolve되지 않는다.
- 언어를 선택하지 않으면, 링크할 아티클을 검색할 때 Salesforce가 조직의 default 언어로 아티클을 반환한다.
- **legacy Knowledge subscription**의 경우, smart link는 아티클이 속한 채널 기반이다; legacy 고객은 다른 채널의 아티클에 smart link를 추가할 수 없다(예: public KB 아티클이 internal-only 아티클로 링크할 수 없음). **신규 Knowledge 고객**의 경우, 모든 아티클이 internal 채널에 속하므로 이 제약이 적용되지 않는다.

### 영구 링크 (Create Persistent Links to Lightning Knowledge Articles)

> **Editions (deviation):** Available in: Lightning Experience; 나머지 standard.
> **USER PERMISSIONS:** 아티클 보기 — **Lightning Knowledge User AND Read on the Knowledge Base object AND Read on URL Name field.**

영구/정적 링크는 사용자의 선호 언어로 된 아티클의 최신 버전을 가리킨다. 외부 사이트/문서에 임베드한다. Salesforce 내부에서 링크하려면 Smart Links를 쓰고, 외부 리소스에 링크를 발행하려면 정적 포맷을 쓴다. 정적 링크는 버전 전반에 걸쳐 유지되며 아티클의 URL name, Salesforce 도메인, 기타 정보 기반이다.

> [!warning] Warning (verbatim)
> 아티클 레코드에서 URL name을 변경하면, 원래 URL name을 쓰는 모든 링크를 업데이트해야 한다.

정적(영구) 링크 URL 포맷 (아래 `example.*` / `My-knowledge-article` / `shipping-faq` 등은 PDF 본문의 placeholder 예시값):

```
SalesforceDomain/lightning/articles/KnowledgeBaseName/URLName
SalesforceDomain/lightning/articles/KnowledgeBaseName/URLName?language=xx_XX
https://example.lightning.force.com/lightning/articles/Knowledge/My-knowledge-article
https://example.lightning.force.com/lightning/articles/Knowledge/shipping-faq?language=fr_FR
```

**Steps (전수, 정확한 URL 포맷 — 아래 URL의 `example.*` / `My-knowledge-article` / `shipping-faq` 등은 PDF 본문의 placeholder 예시값):**

1. URL을 구성할 text 파일을 연다.
2. 링크할 아티클을 연다.
3. 주소창에서 Salesforce 도메인을 복사. 예시 URL:
   ```
   https://example.lightning.force.com/lightning/o/Knowledge__kav/list?filterName=00BB00028DpSU
   ```
   → 도메인은 `example.lightning.force.com`.
4. 도메인 뒤에 경로를 추가: `/lightning/articles/KnowledgeBaseName/` (KnowledgeBaseName은 아티클을 담는 객체의 레이블, 기본값은 **Knowledge**). 도메인이 `.com`으로 끝나면 URL은 다음과 같다:
   ```
   https://example.lightning.force.com/lightning/articles/Knowledge/
   ```
5. **URL Name** 필드를 찾아 그 내용을 끝에 복사.
   > Note: 아티클 URL은 대소문자 구분이다; `/lightning/articles/KnowledgeBaseName/` 부분과 URL name의 대소문자를 확인하라.
   정적 URL 예시:
   ```
   https://example.lightning.force.com/lightning/articles/Knowledge/My-knowledge-article
   ```
6. (선택) ISO 코드로 아티클의 언어를 지정. 포맷:
   ```
   SalesforceDomain/lightning/articles/KnowledgeBaseName/URLName?language=xx_XX
   ```
   예시 (`shipping-faq`의 French 버전):
   ```
   https://example.lightning.force.com/lightning/articles/Knowledge/shipping-faq?language=fr_FR
   ```
   언어별로 URL name이 다르면, 버전별 name을 쓰고 언어 코드를 추가하지 마라.
7. 정적 아티클 URL을 외부 문서나 페이지에 추가.

---

## 관련 노트

- [[Knowledge REST API — Search & Support]]
- [[Knowledge UI API 제약]]
- [[Lightning Knowledge 셋업 & 구성]]
- [[Lightning Knowledge 아티클 리포팅]]
