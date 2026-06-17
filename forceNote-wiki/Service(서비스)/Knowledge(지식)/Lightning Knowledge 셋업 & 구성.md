---
tags: [Service, Knowledge, LightningKnowledge, Setup, 셋업, 구성, RecordType, PageLayout, UserAccess, 권한, ValidationStatus, Admin, NoCode]
source: lightning_knowledge_guide.pdf (Spring '26, p.13–22)
created: 2026-06-17
aliases: [Lightning Knowledge 셋업, Enable Lightning Knowledge, Knowledge Record Type, Knowledge Page Layout, Knowledge User Access, Knowledge 권한표, Article History Tracking, Validation Status, Guided Setup Flow, Lightning Knowledge 활성화, Lightning Knowledge 켜기, Knowledge 셋업 방법, 지식 셋업, Knowledge 권한 부여, Knowledge 라이선스, Knowledge 사용자 추가, 검증 상태 켜기, Knowledge 어드민 셋업]
---

# Lightning Knowledge 셋업 & 구성

> Lightning Knowledge를 활성화하고 record type·페이지 레이아웃·사용자 접근·히스토리 추적·검증 상태까지 구성하는 전체 셋업 과정.

---

## Guided Setup Flow로 셋업하기

> **Editions (deviation):** Service Setup은 Lightning Experience에서 사용 가능. Available in: All editions with the Service Cloud.

- Lightning Knowledge setup flow는 지식베이스를 빠르게 시작하는 방법이다. Lightning Knowledge를 활성화하고, 아티클 작성자를 선택하고, 몇 개의 data category group을 만든다. 그 뒤 페이지 레이아웃·record type·프로세스를 구성하여 추진력을 얻는다.
- Lightning Knowledge를 콘솔에 임베드하면 지원 상담원이 답을 찾고 접근하고 전달할 수 있으며, 상담원이 지식베이스에 기여할 수도 있다.

> [!important] Important (verbatim)
> Lightning Knowledge를 활성화한 후에는 비활성화할 수 없다.

### Setup Flow 접근 위치

- Lightning Experience의 **Service Setup**에서 사용 가능. gear 아이콘을 클릭하고 **Service Setup**을 선택하여 Service Setup에 들어간다.
- Service Setup에서, 지금까지 셋업한 내용 기반으로 추천 setup flow·콘텐츠·팁을 찾을 수 있다. flow가 보이지 않으면 **View All**을 클릭하여 전체 목록을 본다. 타일을 선택하여 flow를 실행한다.

### 이 Flow가 하는 일

다음을 안내한다:

- Enabling Lightning Knowledge
- Choosing knowledge article authors
- Creating data categories and data category groups

> [!tip] Tip (verbatim)
> Data Category Group은 아티클을 분류하고 찾는 데 도움이 된다. 데이터 카테고리로 아티클·질문·아이디어 집합에 대한 접근을 제어할 수 있다.

또한 백그라운드에서 여러 가지를 켠다:

- **Enabling Lightning Knowledge** — flow 중 활성화되며 되돌릴 수 없다. Lightning Knowledge는 Salesforce Classic Knowledge와 다르므로, 이미 Classic을 쓰고 있다면 일부 계획이 필요하다.
- **Default Page Layouts and Record Types** — default **FAQ** 페이지 레이아웃과 record type이 자동 활성화된다. 페이지 레이아웃은 아티클이 표시되는 방식을 결정한다. 이 단계가 페이지 레이아웃과 record type을 연결한다. flow 이후, Object Manager로 가서 페이지 레이아웃을 만들거나 수정한다.
  > [!note] Note (verbatim)
  > setup flow를 시작하기 전에 이미 페이지 레이아웃과 record type을 만들었다면, 새로 만들지 않는다 — 초기 설정의 무결성은 변경되지 않는다.
- **Knowledge Permission Sets** — 선택한 작성자는 **Knowledge LSF** permission set을 통해 full read, write, publishing 접근과 Knowledge Object 접근을 얻는다. flow가 이 프로필에 대해 페이지 레이아웃과 record type을 자동 활성화한다. 작성자로 지정된 모두가 **Knowledge User License**를 얻는다. flow는 **Choose Author** 화면에서 선택된 프로필에 **data category visibility**를 부여한다.

---

## Set Up and Configure 개요

> **Editions (deviation):** Available in: Lightning Experience; 나머지 standard.

Lightning Knowledge를 활성화하고, Knowledge record type을 만들고, record type 페이지 레이아웃을 커스터마이즈하고, Knowledge 사용자의 접근을 설정하고, Lightning Knowledge 프로세스를 만든다.

하위 단계: Enable Lightning Knowledge; Record Type Considerations; Page Layout Considerations; Lightning Knowledge Home and Record Pages; Lightning Knowledge User Access; Article History Tracking; Define Validation Status Picklist Values; Set Up Actions to Insert Articles into Channels; Set Up Actions to Share Article URLs. (액션 셋업은 [[Lightning Knowledge 사용 — 액션·검색·스마트링크·채널]] 참조)

---

## Enable Lightning Knowledge

> **Editions (deviation):** Available in: Lightning Experience; 나머지 standard.
> **USER PERMISSIONS:** Setup에서 Knowledge Settings를 보려면 **Knowledge User license**.

> [!note] Note (verbatim)
> Salesforce Classic의 Knowledge가 이미 활성화되어 있다면, 여기서 Knowledge를 활성화하는 대신 **Lightning Knowledge Migration Tool**을 써라.

Setup 내비게이션 경로(구조 예시):

```
// 구조 예시 — 실제 동작 코드 아님 (Setup 메뉴 경로)
Setup → Quick Find: "Knowledge" → Knowledge Settings → Edit → ☑ Enable Lightning Knowledge → Save
Setup → Object Manager → Knowledge   (활성화 후 설정·페이지 레이아웃 제어)
```

**Steps (전수):**

1. From Setup, Quick Find 박스에 `Knowledge`를 입력하고 `Knowledge Settings`를 클릭.
2. Knowledge Settings 페이지에서 `Edit`를 클릭.
3. `Enable Lightning Knowledge`를 선택.
   > Note: Lightning Knowledge를 활성화하려면 article type이 하나 있어야 한다. 활성화 후에는 비활성화할 수 없다.
4. 원하는 다른 Knowledge 설정을 활성화.
5. `Save`를 클릭.

- 활성화 후 **Knowledge가 Object Manager에 나타난다** — 거기서 설정과 페이지 레이아웃을 제어한다.
- Object Manager에서 Knowledge Base의 이름과 API name을 변경할 때마다, 서버 에러를 피하려면 브라우저 하드 새로고침을 하라. 지식베이스 이름 변경은 customization, Apex, SOQL 쿼리에도 영향을 준다.

> [!important] Important (verbatim)
> Lightning Knowledge를 활성화하면 조직의 데이터 모델이 article type 대신 record type을 사용하도록 바뀐다. 여러 article type을 가진 조직은 활성화 전에 article type을 통합하기 위한 데이터 마이그레이션이 필요하다. 활성화 후에는 비활성화할 수 없다. 운영에서 활성화하기 전에 Sandbox나 Trial org에서 테스트하라.

---

## Record Type Considerations

> **Editions (deviation):** Available in: Lightning Experience; 나머지 standard.

서로 다른 콘텐츠는 서로 다른 필요를 갖는다(FAQ vs 튜토리얼 vs 정책 설명). record type은 아티클의 콘텐츠와 레이아웃을 제어한다. 아티클을 구분하기 위해 다른 record type을 만든다. Lightning Knowledge에서 표준 record type이 custom article type을 대체한다. 구축 시, 프로필·페이지 레이아웃·기타 기능을 커스터마이즈하여 record type을 최대한 활용하도록 계획하라.

- Create record types
- Customize Page Layouts
- Page Layout Considerations for Lightning Knowledge
- Lightning Knowledge User Access

**SEE ALSO:** Tailor Business Processes to Different Record Types Users; Create Custom Fields.

---

## Page Layout Considerations

> **Editions (deviation):** Available in: Lightning Experience; 나머지 standard.
> **USER PERMISSIONS:** 페이지 레이아웃을 커스터마이즈하려면 **Customize Application**.

- 페이지 레이아웃은 아티클 데이터 입력 시 상담원이 보고/편집할 수 있는 필드, 그리고 사용자가 아티클을 볼 때 나타나는 섹션을 결정한다. 각 record type과 user profile별로 필드·액션·related list를 커스터마이즈한다. 예: 민감한 데이터의 경우, user profile별로 페이지 레이아웃을 커스터마이즈하여 배정된 상담원만 민감 필드를 보게 한다.
- Tips:
  - 페이지 레이아웃의 **Salesforce Mobile and Lightning Experience Actions** 섹션에 추가된 authoring action은 Lightning Experience와 Salesforce mobile app의 record 페이지 **highlights panel**에 나타난다.
  - Knowledge에서 **inline edit**를 쓰려면 표준 페이지 레이아웃에 **Publication Status** 필드를 추가하라(compact layout이 아니라 표준 페이지 레이아웃에 있어야 함; 단 둘 다에 나타날 수 있음).
    > [!tip] Tip
    > Publication Status 필드가 collapse된 레이아웃 섹션에 있으면, inline editing 전에 섹션을 펼쳐 edit 아이콘을 로드하라. 접근성을 위해 항상 열려 있을 만한 섹션에 추가하라.
  - **Title**과 **URL Name** 표준 필드는 필수이며 레이아웃에서 제거할 수 없다.
  - 어떤 audience가 아티클을 볼 수 있는지 제어하려면 다음 필드를 페이지 레이아웃에 추가하라: **Visible in Internal App; Visible to Customer; Visible to Partner; Visible in Public Knowledge base.** 레코드에서 체크박스로 나타난다.

**SEE ALSO:** Page Layout Tips.

---

## Knowledge Home & Record Pages

> **Editions (deviation):** Available in: Lightning Experience; 나머지 standard.

Lightning Experience의 Knowledge home 페이지에서 아티클을 검색·보기·생성·관리한다. Knowledge home을 떠나지 않고 authoring action(restore, archive, delete, publish, submit for translation or approval)을 수행한다.

> [!note] Note (verbatim)
> Lightning Experience에서 Knowledge에 접근하려면 Lightning Knowledge home 페이지를 만들고 커스터마이즈하라. Spring '17 이후에 Lightning Knowledge를 켰다면 home 페이지가 자동 생성된다.

### Knowledge Home

- Lightning Knowledge home은 Salesforce의 다른 곳과 같은 list view를 쓴다. 기본적으로 draft, published, archived 아티클용 list view가 있다. list view를 커스터마이즈하여 어떤 필드를 표시하고 정렬할지 선택한다. custom list view에서는 아티클 레코드에 없는 필드를 선택할 수 없다. 따라서 **data categories, ratings, view count, cases는 list view에서 사용 가능한 필드가 아니다.**
- 기본적으로 Lightning의 list view는 사용 가능한 모든 언어를 표시한다. Lightning Knowledge가 활성화되면 **Salesforce Classic의 Article Management 탭**의 list view는 기본적으로 사용자 언어의 아티클(사용자 언어가 없으면 Knowledge의 primary language)을 표시한다.

### Article Record Pages

- **Lightning App Builder**로 default record 페이지를 구성한다. Lightning 페이지는 아티클 페이지 레이아웃과 선택한 컴포넌트로 구성된다. partner/developer/AppExchange 컴포넌트를 추가하거나 직접 만들 수도 있다. Lightning 페이지로 ratings, versions, data category, translation 컴포넌트를 이동할 수 있다.
- record 페이지에 추가할 수 있는 컴포넌트 (전수):
  - **Article Data Categories** — 데이터 카테고리 관리 권한이 있는 사용자가 아티클의 카테고리를 변경할 수 있다.
  - **Article Thumb Vote (Ratings)** — thumbs-up/thumbs-down으로 피드백 수집. 자동 활성화됨.
  - **Article Version Comparison** — 아티클의 두 버전을 비교.
  - **Article Versions** — Object Manager에서 **Track Field History**와 **Set History Tracking**을 선택한다. 이로써 Article Versions 컴포넌트에서 아티클 버전 히스토리와 필드 변경을 사용할 수 있다.
  - **Files** — record type 페이지 레이아웃에 Files related list를 추가.
  - **Translation Primary Article** — primary 아티클과 translation을 같은 페이지 레이아웃에 표시하여 번역자를 돕는다. 번역자와 지식베이스 관리자만 side-by-side view를 보도록 visibility 조건을 설정.
  - **Translation Switcher** — 모든 언어에서 아티클의 draft와 published 버전 사이를 전환.

---

## Lightning Knowledge User Access

> **Editions (deviation):** Available in: Lightning Experience; 나머지 standard.
> **USER PERMISSIONS:** 사용자 생성/편집 — **Manage Internal Users**. Knowledge 권한 배정 — **Customize Application**.

- 사용자 권한이 작업 접근을 제어한다. 기본적으로 Read 권한이 있는 모든 internal user는 published 아티클을 읽을 수 있다. 발행·archive·삭제·관리하는 상담원/작성자에게 권한을 배정한다.
- permission set이나 custom profile을 쓴다. 예: *Article Manager* permission set(create, edit, publish, assign articles)을 만들고, *Knowledge Base Manager* profile(archive and delete articles)을 만든다.
- **Draft** 아티클과 연결된 카테고리를 보려면, 표준 User는 **Knowledge User**와 **Manage Article** 권한이 있어야 한다.

> [!tip] Tip (verbatim)
> Lightning Knowledge는 user profile 권한이나 permission set을 써서 상담원에게 authoring action 접근을 부여한다. Salesforce Classic의 Knowledge는 public group과 article action을 쓴다.

> [!note] Note (verbatim)
> 아티클 읽기 이상의 작업을 하려면, 상담원은 **Knowledge User license**가 필요하다.

**사용자를 Knowledge user로 만드는 Steps (전수):**

- From Setup, Quick Find 박스에 `Users`를 입력하고 `Users`를 선택.
- 사용자 이름 옆 `Edit`를 클릭하거나, 사용자 생성은 `New`를 클릭.
- 사용자를 생성하는 경우 모든 필수 필드를 완성.
- `Knowledge User`를 선택.
- `Save`를 클릭.

### Lightning Knowledge 권한표 (Table 1)

각 셀은 서술 텍스트(기호 아님)다. col 2 = 필요한 profile/app 권한, col 3 = 필요한 object-level CRUD.

| Lightning Knowledge Task | User Permissions | Knowledge Object Permissions |
|---|---|---|
| Read and search published knowledge articles | Allow View Knowledge | Read |
| Read and search draft knowledge articles | Allow View Knowledge, View Draft Articles | Read |
| Read and search archived knowledge articles | Allow View Knowledge, View Archived Articles² | Read |
| Attach or detach published articles to objects and search articles | Allow View Knowledge | Read on Knowledge, Read and Edit on objects to which you attach or detach the article |
| Create articles | Manage Articles **AND** Manage Salesforce Knowledge | Create, Read |
| Edit draft articles | Manage Articles | Read, Edit |
| Delete draft articles | Manage Articles | Read, Edit, Delete |
| Change the record type | Manage Articles | Create, Read, Edit |
| Change the article owner | Manage Articles | Read, Edit |
| Be an article owner | View Draft Articles | Read, Edit |
| Publish articles | Manage Articles, Publish Articles | Create, Read, Edit, Delete |
| Archive articles | Manage Articles, Archive Articles | Create, Read, Edit, Delete |
| Restore archived articles | Manage Articles, Archive Articles | Create, Read, Edit |
| Delete archived articles | Manage Articles, Archive Articles | Modify All |
| Assign articles | Manage Articles | Read, Edit |
| Edit published articles | Manage Articles | Create, Read, Edit |
| Submit articles for translation | Manage Articles, Article Translation–Submit for Translation | Create, Read, Edit |
| Delete draft translations | Manage Articles | Read, Edit, Delete |
| Edit translations | Manage Articles, Article Translation–Edit | Read, Edit |
| Publish translations | Manage Articles, Article Translation–Publish | Create, Read, Edit, Delete |
| Import articles | Manage Salesforce Knowledge, Manage Articles, Manage Knowledge Article Import/Export | Create, Read, Edit, Delete |
| Import and export articles for translation | Manage Salesforce Knowledge, Manage Articles, Manage Article Import/Export | Create, Read, Edit, Delete |
| Create data categories | Manage Data Categories, View Data Categories in Setup | None |

> ² **Footnote (verbatim):** The View Archived Articles permission controls access only to articles where the latest or current version is archived. Read permission for Knowledge allows users to view past archived versions associated with articles currently in Published status.

---

## Article History Tracking (Lightning Experience)

> **Editions (deviation):** Available in: Salesforce Classic (not available in all orgs) and Lightning Experience. Essentials and the Unlimited Edition with Service Cloud; 추가 비용으로 Professional/Enterprise/Performance/Developer.

- 아티클의 특정 필드 히스토리를 추적한다. history tracking이 활성화되면, 아티클을 열고 **Version**을 클릭하여 버전 히스토리 목록을 본다. article type에 대해 추적을 설정하여 아티클과 그 버전의 전체 히스토리를 추적할 수 있다. **Article event는 최대 18개월까지 추적된다.**
- 시스템은 primary 아티클과 translation에 대해 필드 업데이트, publishing workflow event, 언어 버전을 기록·표시한다. old/new 값을 추적하면 두 값과 날짜·시간·변경 성격·사용자를 기록한다. 변경된 값만 추적하면 변경된 필드를 edited로 표시한다(old/new 값 없음). **Version History** 목록에서 사용 가능하며, 필드는 **Article Version History report**에서 사용 가능하다.
- 아티클 히스토리는 field, entity, record-level 보안을 준수한다. 히스토리에 접근하려면 article type이나 필드에 최소 Read 권한이 있어야 한다. data category 보안의 경우, Salesforce는 online 버전의 분류 기반으로 접근을 결정한다. online 버전이 없으면 archived 버전, 그다음 draft 버전 기준으로 보안이 적용된다.

**Steps (전수):**

1. From Setup, **Object Manager**로 간다.
2. **Knowledge**를 선택.
3. Knowledge object home에서 **Edit**를 클릭.
4. **Track Field History** 체크박스를 체크.
5. 변경을 저장.

- Salesforce는 그 날짜/시각부터 히스토리 추적을 시작한다. 그 이전 변경은 추적되지 않는다.

---

## Define Validation Status Picklist Values

> **Editions (deviation):** Available in: Salesforce Classic (not available in all orgs) and Lightning Experience. Essentials and the Unlimited Edition with Service Cloud; 추가 비용으로 Professional/Enterprise/Performance/Developer.
> **USER PERMISSIONS:** validation status picklist 값을 만들거나 변경하려면 **Customize Application**.

Knowledge Settings 페이지에서 **Validation Status** 필드가 활성화되면, 아티클의 상태를 보여주는 picklist 값을 만들 수 있다. 예시 값: Validated, Not Validated, Needs Review.

> [!note] Note (verbatim)
> Salesforce Classic에서, validation status picklist 값은 번역을 위해 아티클을 내보낼 때 유지되지 않는다. picklist 값이 있는 아티클은 임포트될 수 있으며, 그 값이 조직에 존재하는 한 값은 유지된다.

**Steps (전수):**

1. **Salesforce Classic** Setup에서, Quick Find 박스에 `Validation Statuses`를 입력하고 `Validation Statuses`를 선택.
2. picklist edit 페이지에서 `New`를 클릭하여 새 값을 추가. 값을 편집·삭제·재정렬·교체할 수도 있다. 값을 교체하면, 시스템은 archived를 포함한 모든 버전에서 교체한다.
3. text 영역에 하나 이상의 picklist 값을 추가(한 줄에 하나).
4. default로 설정하려면 **Default** 체크박스를 선택.
5. `Save`를 클릭.

**SEE ALSO:** Validation Rules.

---

## 관련 노트

- [[Lightning Knowledge 개요 — 계획·비교·한계]]
- [[Lightning Knowledge 사용 — 액션·검색·스마트링크·채널]]
- [[Knowledge 데이터 모델 & API 개요]]
