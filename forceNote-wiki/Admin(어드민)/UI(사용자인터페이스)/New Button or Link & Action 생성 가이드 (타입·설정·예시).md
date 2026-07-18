---
tags: [admin, ui-customization, custom-buttons, custom-links, quick-actions, action-types]
source: help.salesforce.com + developer.salesforce.com (Custom Button and Link Fields / Edit Window Open Properties / Action Types / Quick Actions / Construct Effective Custom URL Buttons and Links[custom_links_constructing] / URLFOR[customize_functions_urlfor] / Custom Button and Link Considerations[links_considerations] / Custom Button and Link Limitations[custom_button_link_limitations] / Merge Fields for Custom Buttons and Links / Navigate to a URL-Addressable Component[LWC Dev Guide]; 라이브 공식 문서·브라우저 렌더, Tier 2, 접속 2026-07-04)
official_doc: https://help.salesforce.com/s/articleView?id=platform.defining_custom_links_fields.htm&type=5
created: 2026-07-04
aliases: [New Button or Link, 버튼 링크 생성, Display Type, Content Source, Behavior, Window Open Properties, Action Type, 액션 타입, Create a Record, Log a Call, merge field 버튼, URLFOR, $Action, URLENCODE, Lightning 컴포넌트 URL, url-addressable, 모바일 미지원, OnClick JavaScript, 버튼 제약, 지원 매트릭스]
---

# New Button or Link & Action 생성 가이드 (타입·설정·예시)

> Object Manager의 **Buttons, Links, and Actions**에서 커스텀 버튼·링크·액션을 만들 때 타입·설정·예시를 전수 정리한 생성 심화 가이드. 개요는 [[Custom Buttons & Links (커스텀 버튼·링크)]]·[[Quick Actions & Global Actions (퀵 액션·글로벌 액션)]] 참조.

**진입점:** Object Manager → (오브젝트) → **Buttons, Links, and Actions**
**Editions:** 커스텀 버튼/링크 = Salesforce Classic, 전 에디션. Visualforce/s-controls 기반 = Contact Manager·Group·Professional·Enterprise·Performance·Unlimited·Developer.

---

## Part 1 — New Button or Link (커스텀 버튼·링크 생성)

> "Custom buttons and links define the action that occurs when a user clicks them." — Salesforce 내 동작을 간소화하거나 Salesforce 데이터를 외부 URL·앱·시스템과 통합한다.

### 필드 전수 (Custom Button and Link Fields)

| 필드 | 설명 |
|---|---|
| **Label** | UI에 표시되는 텍스트. |
| **Name** | API에서 참조할 고유 이름(자동 생성 또는 입력). |
| **Namespace Prefix** | 패키지를 고유 식별하는 접두(패키징 org). |
| **Protected Component** | 구독자 org에서 사용 제한(선택). Protected component는 다른 패키지 컴포넌트가 링크·참조할 수 없다. |
| **Description** | 다른 버튼·링크와 구분하는 설명 텍스트. |
| **Display Type** | 페이지 레이아웃에서 버튼/링크가 나타나는 위치(아래 3종). |
| **Behavior** | 클릭 시 결과(창 열림 방식, 아래). |
| **Content Source** | URL / s-control / JavaScript action(OnClick JavaScript, 레거시) / Visualforce 중 선택. |
| **Content** | URL·링크 유형의 콘텐츠(merge field·operator·function 삽입). |
| **Link Encoding** | 인코딩. 기본 **Unicode (UTF-8)**. |

### Display Type (3종) — 버튼/링크가 나타나는 위치

- **Detail Page Link** — 레코드 상세 페이지의 **Custom Links 섹션**에 링크를 추가한다.
- **Detail Page Button** — 레코드 상세 페이지에 버튼을 추가한다.
- **List Button** — list view·search result layout·related list에 버튼을 추가한다. **"Display Checkboxes (for Multi-Record Selection)"** 옵션을 켜면 다중 레코드 선택이 가능해져 mass action으로 동작한다.

### Behavior (창 열림 방식)

문서화된 옵션:

- Display in existing window without sidebar or header
- Display in existing window with sidebar
- Display in existing window without sidebar
- **Display in new window** — Window Open Properties 적용 가능
- Display in sidebar
- **Execute JavaScript** — ⚠️ Content Source가 **OnClick JavaScript**일 때만 표시된다.

> ⚠️ **일부 behavior는 변경 불가:**
> ① URL로 Visualforce 페이지를 링크하는 커스텀 버튼은 강제로 **Display in new window**로 설정된다.
> ② Experience Builder 사이트에서 커스텀 버튼 링크는 "Display in existing window" 설정이어도 **새 탭**에서 열린다.

### Content Source (4종)

- **URL** — 외부 URL·인트라넷·상대 경로. 저장 시 Salesforce가 URL의 정확성을 검증한다. 허용 프로토콜: `http://`, `https://`, `file://`, `ftp://`, `mailto://`.
- **Visualforce Page** — 커스텀 페이지/코드를 실행한다. Experience Builder 사이트에서도 동작(클릭 시 연결된 VF 페이지 표시).
- **JavaScript (OnClick JavaScript)** — ⚠️ **레거시**. Lightning Experience 미지원, Salesforce Classic 전용. Execute JavaScript behavior와 함께 사용한다.
- **s-control** — ⚠️ 레거시(사실상 은퇴).

> 💡 **의존 관계:** Content Source가 Behavior 옵션을 제약한다. `Execute JavaScript` behavior는 Content Source가 `OnClick JavaScript`일 때만 나타나고, URL로 VF 페이지를 링크하면 behavior가 `Display in new window`로 강제된다.

### Content — merge field · operator · function

URL/링크 유형에서 Content 필드에 삽입한다:

- **Merge field**: `{!Object.Field}` 토큰으로 레코드 값을 삽입한다. Select Field Type에서 필드를 선택. Activity merge field는 Event / Task 중 선택.
- **Operator**: Insert Operator에서 삽입.
- **Function**: Functions 목록에서 더블클릭하거나 Insert Selected Function.

**⚠️ URL 인코딩:** 인터넷 표준상 특수 인코딩이 필요하며, Salesforce가 merge field 값을 자동 인코딩한다.

```text
// 구조 예시 — URL 버튼 콘텐츠(실제 동작 코드 아님)

// 예시 1: 공백 → +, 퍼센트(%) → %25 자동 인코딩
입력한 URL:
  http://www.google.com/search?q={!user.name} Steve Mark 50%
Salesforce가 사용하는 URL:
  http://www.google.com/search?q={!user.name}+Steve+Mark+50%25

// 예시 2: Content Source가 URL이면 큰따옴표(") 제거 후 %22로 인코딩
입력한 URL:
  ...?q="salesforce foundation"
Salesforce가 사용하는 URL:
  ...?q=%22salesforce+foundation%22

// 예시 3: Yahoo 검색 (merge field 사용)
  http://search.yahoo.com/bin/search?p={!Account_Name}
```

- 공백 → `+`, `%` → `%25`로 자동 변환된다.
- Content Source가 URL이면 Salesforce가 URL의 **큰따옴표를 제거**한 뒤 `%22`로 인코딩한다.

### URL 버튼 콘텐츠 심층 (Content Source = URL일 때 넣는 것 전수)

> 소스: *Construct Effective Custom URL Buttons and Links*(`platform.custom_links_constructing.htm`) · *URLFOR*(`platform.customize_functions_urlfor.htm`) · *Merge Fields for Custom Buttons and Links* · LWC Dev Guide *Navigate to a URL-Addressable Component* · *New URL Format for Lightning FAQ*.

#### 1) Merge field로 Salesforce 데이터 전달

URL에 `{!Object.Field}` 토큰을 넣어 레코드 값을 삽입한다.

```text
// 공식 예시 — 외부 URL에 merge field 삽입
계정명 구글 검색:   http://google.com/search?q={!Account.Name}
배송지 지도:        http://maps.google.com?q={!Account.ShippingStreet} {!Account.ShippingCity} {!Account.ShippingState}
```

- ⚠️ **Note: custom link는 data type 변환을 지원하지 않는다.** merge field로 값을 전달할 때 타입 변환이 일어나지 않는다.

#### 2) 특수 문자 인코딩 — URLENCODE()

W3C URL 인코딩 표준상 unsafe 문자는 인코딩이 필요하다. merge field를 `{!URLENCODE(text)}`로 감싼다.

```text
// 공식 예시 — merge field foo__c 값이 <B>Mark's page<b> 인 경우
{!URLENCODE(foo__c)}
→ %3CB%3EMark%27s%20page%3C%2Fb%3E
```

#### 3) Visualforce 페이지 링크 — URLFOR() + /apex/

상대 경로 `/apex/PageName`을 URLFOR로 감싼다.

```text
// 공식 예시
페이지 이동:      {! URLFOR( "/apex/MissionList" ) }
레코드 ID 전달:   {! URLFOR( "/apex/Mission", null, [id=Mission__c.Id] ) }
```

#### 4) Salesforce 페이지 가리키기 — $Action + URLFOR()

`$Action` 글로벌 변수로 표준 액션(new·clone·view·edit·list·delete + 오브젝트별 액션)을 참조한다. `$Action`/`$ObjectType`은 **record ID 또는 `$ObjectType`**를 기대한다.

```text
// 공식 예시
New Case(계정 연관):     {!URLFOR( $Action.Case.NewCase, Account.Id )}
New Case($ObjectType):   {!URLFOR( $Action.Case.NewCase, $ObjectType.Case )}
Account 탭 홈:           {!URLFOR( $Action.Account.Tab, $ObjectType.Account )}
lookup 레코드 view:      {!URLFOR( $Action.Account.View, Some_Account_Lookup__c.Id )}
파라미터 전달(override): {!URLFOR( $Action.Case.CloseCase, Case.Id, [ actualDeliveryDate=TODAY() ] )}
```

- 마지막 예시처럼 추가 파라미터를 URL 쿼리로 넘기면, Close Case를 Visualforce로 override해 그 값을 처리할 수 있다.

#### 5) URLFOR() 함수 전체 시그니처

```text
{!URLFOR(target, [id], [inputs], [no override])}
```

| 인자 | 설명 |
|---|---|
| **target** | URL 또는 action/s-control/static resource merge 변수(예 `$Action.Account.New`). |
| **id** | 레코드 ID(선택). |
| **inputs** | URL 파라미터(선택). 브래킷 `[ ]`로 묶는다. 동적 값 가능. |
| **no override** | `true`면 오버라이드를 무시하고 표준 페이지로. 기본 `false`. |

```text
// 공식 예시
동적 입력:
  {!URLFOR($Page.myVisualforcePage, null, [accountId=Account.Id])}
  → https://MyDomainName--PackageName.vf.force.com/apex/myVisualforcePage?accountId=001B0000002txol
비-string(SObject) 변수:
  [myAccountParam=Account]  → ?MyAccountParam=001B0000002txol
  [param1=55]
static resource(zip 내 파일):
  <apex:image url="{!URLFOR($Resource.TestZip, 'images/Bluehills.jpg')}" width="50" height="50"/>
```

- ⚠️ **Note: 파라미터 이름은 static이다** — 변수로 파라미터 이름을 결정할 수 없다.

**Tips:**
- 액션·s-control·static resource는 글로벌 변수(`$Action`·`$Resource` 등)로 접근한다.
- 입력 파라미터 이름이 letter/`$` 외 문자로 시작하면 **따옴표로 감싼다**.
- 다중 입력은 하나의 브래킷에 함께 넣는다: `{!URLFOR($Action.Case.View, Case.Id, [param1="A", param2="B"])}`
- 입력 없이 no override만 쓰려면 `inputs`를 `null`로: `{!URLFOR($Action.Case.View, Case.Id, null, true)}`
- **표준 액션을 override하면 그 액션은 Salesforce에서 사라진다.**
- 탭 홈 override는 탭 글로벌 변수를 쓴다: `URLFOR($Action.Account.Tab, $ObjectType.Account)`
- ⚠️ Winter '25부터 Visualforce 페이지는 `force.com`/site 도메인에서 제공된다.

#### 6) Lightning Experience에서 다른 페이지 가리키기 (LEX 동작 표)

| 커스텀 URL 버튼/링크 | LEX 동작 |
|---|---|
| External URL: `www.google.com` | URL이 **새 탭**에서 열림 |
| Relative Salesforce URL, View: `/{!Account.Id}` | 레코드 홈이 **기존 탭**에서 열림 |
| Relative Salesforce URL, Edit: `/{!Account.Id}/e` | **편집 오버레이**가 기존 페이지에 팝업 |
| Relative Salesforce URL, List: `/001/o` | 객체 홈이 기존 탭에서 열림 (`001` = key prefix) |
| $Action URL, View: `{!URLFOR($Action.Account.View, Account.Id)}` | 레코드 홈이 기존 탭에서 열림 |
| $Action URL, Edit: `{!URLFOR($Action.Account.Edit, Account.Id)}` | 편집 오버레이 팝업 |

> ⚠️ **Note: Salesforce Classic에서 표준 페이지에 파라미터를 넘기는 URL 커스텀 버튼은 Lightning Experience에서 미지원**(동작이 다르다). Classic URL 해킹은 LEX에서 대부분 동작하지 않는다.

#### 7) ⭐ Lightning 컴포넌트를 URL로 지정

Content Source = URL 버튼에서 **URL-addressable Lightning 컴포넌트**(Aura/LWC)로 이동할 수 있다.

```text
// URL 형식 (공식)
/lightning/cmp/{namespace}__{componentName}?{namespace}__{state}=value
// 예: /lightning/cmp/c__myComponent?c__recordId={!Account.Id}
```

- **`c__` = 기본(default) 네임스페이스:** 등록된 네임스페이스가 없는 org의 커스텀 컴포넌트는 URL 접두 **`c__`**(마크업은 `c:`)를 쓴다. 관리형 패키지 컴포넌트면 `c__` 대신 **패키지 네임스페이스**(예 `mypkg__myComponent`)를 쓴다.
- **컴포넌트 요건(개발자 설정):**
  - LWC `.js-meta.xml`에 **`lightning__UrlAddressable` 타깃** 지정 + **`<isExposed>true</isExposed>`**.
  - Aura는 `implements="lightning:isUrlAddressable"`.
  - 상태 파라미터는 컴포넌트가 `CurrentPageReference`의 `state`로 받는다(URL의 `c__` 접두 파라미터).
- **표준 네비게이션 대안(권장):** 컴포넌트 JS는 `NavigationMixin.Navigate(pageReference)` + `standard__component` 타입(`componentName: "c__myComponent"`)으로 이동한다. Salesforce는 UI URL 하드코딩을 **공식 지원하지 않으므로**(변경될 수 있음), 커스텀 버튼에서 `/lightning/cmp/c__`를 직접 하드코딩하는 것은 동작하나 컴포넌트 내부 네비게이션은 PageReference를 권장한다.

#### 8) LEX URL 세그먼트 (새 URL 포맷 — 커스텀 버튼 상대 URL로 사용 가능)

`https://<MyDomain>.lightning.force.com` 뒤에 붙인다.

| 세그먼트 | 대상 | 예 |
|---|---|---|
| `/lightning/o/{ObjectApiName}/home` | 객체 홈(리스트뷰) | `/lightning/o/Account/home` |
| `/lightning/r/{ObjectApiName}/{recordId}/view` | 레코드 상세 | `/lightning/r/Account/001.../view` |
| `/lightning/r/{ObjectApiName}/{recordId}/edit` | 레코드 편집 | — |
| `/lightning/o/{ObjectApiName}/new` | 레코드 생성 | — |
| `/lightning/n/{tabApiName}` | 네비게이션 항목(커스텀 탭) | `/lightning/n/My_Custom_Tab` |
| `/lightning/cmp/{ns}__{component}` | URL-addressable 컴포넌트 | `/lightning/cmp/c__myComponent` |

> ⚠️ **공식 미지원(변경 가능):** 이 UI URL들은 Salesforce가 공식 지원하지 않아 릴리즈에서 바뀔 수 있다. 안정성이 필요하면 `$Action`·`URLFOR`(선언적) 또는 컴포넌트 `PageReference`/`NavigationMixin`(프로그래밍)을 권장한다.

### Window Open Properties (Behavior = Display in new window일 때)

버튼/링크 편집 화면에서 **Window Open Properties**를 클릭한다. 필요 권한: **Customize Application**.

| 속성 | 설명 |
|---|---|
| **Width** | 창 너비(픽셀). |
| **Height** | 창 높이(픽셀). |
| **Window Position** | 창이 열릴 화면 위치. |
| **Resizeable** | 사용자가 창 크기를 조정하도록 허용. |
| **Show Address Bar** | URL이 담긴 주소 표시줄 표시. |
| **Show Scrollbars** | 스크롤바 표시. |
| **Show Toolbars** | 도구 모음(Back/Forward 등) 표시. |
| **Show Menu Bar** | 메뉴(File/Edit 등) 표시. |
| **Show Status Bar** | 하단 상태 표시줄 표시. |

> ⚠️ behavior에 따라 일부 속성이 제공되지 않는다(예: Execute JavaScript).

### 페이지 레이아웃 배치 (자동 노출 안 됨)

생성한 버튼/링크는 자동으로 노출되지 않는다.

- **Detail Page Button / Link** → **page layout**의 Custom Buttons / Custom Links 섹션에 추가해야 표시된다.
- **List Button** → **List View Button Layout**·related list에 추가해야 표시된다.

> 배치 위치는 [[Page Layouts (페이지 레이아웃)]] 참조.

---

## Part 2 — Actions (액션)

> 어떤 액션이 사용 가능한지는 org의 나이·구성에 따라 다르다.

> ⚠️ **Summer '26부터 신규 org는 Chatter가 기본 OFF.** Standard Chatter Actions 등 Chatter가 필요한 기능은 Setup → Chatter Settings → Enable로 켜야 사용할 수 있다.

### Action 카테고리 (Action Types) — 6종

- **Standard Chatter Actions** — Post·Poll·Question·Announcements(그룹 전용). Chatter가 활성화된 경우에만 제공.
- **Default Actions** — 시작용으로 사전 정의된 액션 세트.
- **Mobile Smart Actions** — 사전 구성된 quick action 세트(account·case·contact·lead·opportunity).
- **Productivity Actions** — 사전 정의되어 제한된 오브젝트에 부착된다(Send Email·Log a Call 등). ⚠️ **편집·삭제 불가.**
- **Quick Actions** — object-specific + global(아래 유형 참조).
- **Mass Quick Actions** — list view/related list에서 **최대 100 레코드**를 생성·업데이트.

표시 위치: Lightning Experience(Global Actions 메뉴·related list·record page), Salesforce Mobile App Action Bar.

### Quick Action 유형 (action type 드롭다운)

| Action Type | 설명 | 범위 |
|---|---|---|
| **Create a Record** | 레코드 생성(New Contact·New Opportunity·New Lead 등). | object-specific 또는 global |
| **Update a Record** | 레코드 수정. | ⚠️ **반드시 object-specific** (global 불가) |
| **Log a Call** | 통화·상호작용 기록. 완료된 task로 저장. | object-specific 또는 global |
| **Custom (Lightning / Flow / Visualforce / Canvas)** | 사용자 정의 기능 호출(Lightning 컴포넌트·flow·Visualforce 페이지·canvas 앱). | object-specific 또는 global |
| **Send Email** | ⚠️ **case 전용** object-specific. Salesforce 모바일 앱의 간소화된 Case Feed Email 액션. | object-specific(case) |

> 그 외 Send Notification 등 기능별 액션 타입이 org 구성에 따라 나타날 수 있다.

### Object-specific vs Global

- **Object-specific actions** — 특정 오브젝트 레코드 컨텍스트에서 동작하며, 관련 레코드와 **자동으로 관계**가 맺어진다. 해당 object의 page layout에 추가한다.
- **Global actions** — 컨텍스트(현재 레코드)와 무관하게 어디서나 배치 가능. 레코드 생성·통화 로그·이메일을 페이지 이탈 없이 수행. **Global Publisher Layout**에 추가한다.

> 💡 **의존 관계 (범위 규약):**
> - **Create a Record / Log a Call / Custom** = object-specific 또는 global 둘 다 가능.
> - **Update a Record** = object-specific만 (global로 만들 수 없다).

### 예시 (how-to)

- **Create 액션** — Case object → (New Button or Link가 아니라) **Actions → New Action → Action Type = Create a Record, Target Object = Task** → layout 지정 → page layout에 추가.
- **Custom(Flow) 액션** — Action Type = Custom → Lightning Component 또는 Flow 선택. 호출되는 Flow는 [[Flow — 선언적 자동화 개요 (플로우)]] 참조.
- **Log a Call** — Action Type = Log a Call → 완료된 task로 저장.

### 버튼/링크 vs Quick Action (구분)

- 커스텀 **버튼/링크**(Part 1) = 주로 Salesforce Classic·URL/VF 통합·목록 버튼.
- **Quick Action**(Part 2) = Lightning·모바일·publisher/action bar.
- 현대 Lightning UI에서는 Quick Action이 권장되며, JavaScript 버튼은 Quick Action/Flow로 대체한다.

---

## 고려사항·제약·환경별 지원 (Considerations & Limitations)

> 소스: *Custom Button and Link Considerations*(`platform.links_considerations.htm`) · *Custom Button and Link Limitations*(`platform.custom_button_link_limitations.htm`). 생성·변경 권한: **Customize Application**.

### Considerations (고려사항)

**구현 팁 (Implementation Tips)**
- 커스텀 버튼은 detail 페이지 **상단·하단**에 표준 버튼 오른쪽으로 표시되며, 표준 버튼과 **시각적으로 구분되지 않는다**.
- 버튼 바가 너무 넓으면 브라우저가 오버플로를 처리한다.
- 커스텀 버튼은 **Task·Event(활동)**용으로 개별 setup 링크에서 사용 가능하다.
- **Person Account** 레코드는 Account용 커스텀 버튼·링크를 사용한다.
- Console 탭을 쓰는 org는 list button을 **Mass Action**에서 사용할 수 있다.
- ⚠️ 커스텀 버튼 생성 시 **validation rule**에 주의한다(액션이 rule에 걸릴 수 있음).
- 표준 버튼을 커스텀으로 교체하려면 **먼저 커스텀 버튼을 정의한 뒤 override**한다.
- ⚠️ detail 페이지의 커스텀 버튼·링크로 쓰는 **Visualforce 페이지는 standard controller 지정이 필수**다.
- ⚠️ **custom list button으로 쓰는 Visualforce 페이지는 standard list controller 사용이 필수**다.
- Web tab/커스텀 링크가 빈 페이지로 뜨는 경우: 임베드 사이트가 ① frame 로딩 거부 ② same-origin frame만 허용 ③ secure+unsecure 혼합 콘텐츠 중 하나일 수 있다. 해결: 새 창 또는 기존 창 표시로 설정하거나, URL을 web tab에서 커스텀 링크로 옮긴다.

**베스트 프랙티스 (Best Practices)**
- ⚠️ 커스텀 버튼의 **formula function은 신중히** 쓴다(서버에서 실행된다).
- content source로는 **상대/절대 URL**을 권장한다.
- 사용자의 특정 액션(생성·편집)을 막을 때는 버튼 제거가 아니라 **권한**으로 제한한다.
- 글로벌 변수(`$Request` 등)로 특수 merge field에 접근한다.
- **custom list button**의 **Display Checkboxes (for Multi-Record Selection)**는 사용자가 레코드를 선택해야 하는 경우에만 켠다.
- ⚠️ **Lightning Experience에서 Display Checkboxes를 켜면, related list type을 반드시 `Enhanced List`로 설정**해야 한다.

**action 아이콘용 커스텀 이미지는 1 MB 미만**이어야 한다.

### ⭐ Salesforce Mobile App 지원 매트릭스 (Content Source × 환경)

모바일에서 되는 것과 안 되는 것을 정확히 구분한다.

- **모바일 앱에서 지원되는 것:** page layout의 **Button 섹션**에 추가되고 content source가 **URL 또는 Visualforce**인 커스텀 버튼.
- **모바일 앱에서 지원 안 되는 것:** ❌ **커스텀 링크(custom links)**, ❌ **list view에 추가된 커스텀 버튼(list button)**, ❌ content source가 **OnClick JavaScript**인 커스텀 버튼.

| Content Source / 유형 | Salesforce Classic | Lightning Experience | Mobile App |
|---|---|---|---|
| URL (detail page button) | ✅ | ✅ (단 Classic URL 파라미터 해킹은 대부분 ❌) | ✅ |
| Visualforce (detail page button) | ✅ | ✅ | ✅ |
| **OnClick JavaScript** | ✅ | ❌ 미지원 | ❌ 미지원 |
| s-control | ✅ (레거시) | ❌ | ❌ |
| Custom **Link** | ✅ | ✅ | ❌ 미지원 |
| **List Button** | ✅ | ✅ (체크박스는 Enhanced List) | ❌ 미지원 |
| Search results page 버튼 | ✅ | ❌ 미지원 | — |

> 매트릭스 셀 값은 덤프 §11 표를 그대로 옮긴 것이다. `✅`=지원, `❌`=미지원, `—`=해당 없음.

### Limitations (하드 제약)

- 커스텀 링크 **label 최대 1,024자**.
- 링크 **URL 최대 2,048 bytes**(토큰 치환 후 기준).
- ⚠️ **JavaScript를 호출하는 커스텀 버튼은 Lightning Experience 미지원.**
- ⚠️ **OnClick JavaScript content source 커스텀 버튼은 Salesforce 모바일 앱 미지원.**
- Salesforce Classic에서 표준 페이지에 파라미터를 넘기는 URL 커스텀 버튼은 **LEX 미지원**.
- high-data-volume 외부 데이터소스에 연관된 external object 레코드 detail 페이지에는 제약이 있다.
- 커스텀 버튼은 **Web-to-Lead·Web-to-Case·Case Teams related list**에서 사용 불가.
- ⚠️ **검색 결과 페이지의 커스텀 버튼은 Lightning Experience 미지원.**
- 외부 웹사이트로 merge field를 리다이렉트할 때는 **Text 필드 데이터 타입**을 사용한다.
- 일부 URL 커스텀 버튼은 behavior가 새 창이어도 **같은 탭**에서 열린다.
- **홈 페이지의 커스텀 링크로 쓰는 Visualforce 페이지는 controller를 지정할 수 없다.**

### 은퇴/현대화 방향 (EOL 신호)

- **s-control = 은퇴** — 신규 생성 불가, Visualforce로 대체.
- **OnClick JavaScript 버튼 = 레거시** — LEX·모바일 미지원. Lightning에서는 다음으로 대체한다:
  - 선언적 UI → **Quick Action(LWC/Flow)**
  - 페이지 이동 → **URL 버튼($Action/URLFOR)**
  - 커스텀 UI → **Lightning 컴포넌트 URL**(URL-addressable) 또는 Quick Action
- 현대 Lightning UI 권장: 선언적은 Quick Action + Flow, URL 이동은 `$Action`/`URLFOR`, 커스텀 UI는 LWC(URL-addressable 또는 Quick Action).

---

## 관련 노트
- [[Custom Buttons & Links (커스텀 버튼·링크)]] — 버튼·링크 개요(이 노트는 생성 심화).
- [[Quick Actions & Global Actions (퀵 액션·글로벌 액션)]] — 액션 개요.
- [[Page Layouts (페이지 레이아웃)]] — 버튼·액션 배치.
- [[Flow — 선언적 자동화 개요 (플로우)]] — Custom 액션이 호출하는 Flow.
- [[XML Config File Elements (js-meta.xml) 레퍼런스]] — URL 버튼 대상 LWC의 `lightning__UrlAddressable` 타깃·`isExposed` 설정.
