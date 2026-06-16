---
tags: [release, summer_24, automation, flow, orchestration]
source: salesforce_summer24_release_notes.pdf
created: 2026-06-16
aliases: [Summer '24 Automation, 서머 24 플로우, Flow Builder Transform Repeater Einstein Draft Flow]
---

# Summer '24 — Automation (Flow & Flow Orchestration)

> 허브: [[Summer '24]]

> Summer '24 Automation spoke: Einstein generative AI가 초안 flow를 작성(Beta, 2024-07-16부터)하고, Transform·Repeater element가 Generally Available로 승격, Create Records의 중복 체크, Address 컴포넌트 검색·ISO 코드, Reactive Collection Choice Set, Action Button(Beta), Is Blank/Is Empty 연산자, Lock Record action, paused/waiting flow 한도 제거, Automation Lightning app + 세분화 권한, v61.0 런타임 변경, 그리고 Flow Orchestration의 수동 Suspend/Resume·실패 복구·Omni-Channel 라우팅을 다룬다.

---

## 개요

이 노트는 Summer '24 Release Notes의 **Salesforce Flow** 챕터(인쇄 p.693–735, API v61.0)를 다룬다. PDF의 9개 IN THIS SECTION 하위 구획(Flow Integration, Flow Builder Updates, Flow Marketing Cloud Updates, Flow Testing and Debugging, Flow Runtime, Flow Management, Flow Actions, Flow and Process Release Updates, Flow Orchestration)을 독자 경로에 맞춰 **신규 / 변경 / Orchestration / Deprecated**로 재배치했다.

성숙도 표기는 PDF 원문을 그대로 따른다. Summer '24 Flow 챕터는 `(GA)` 약어를 쓰지 않고 항상 **`(Generally Available)`** 로 풀어 쓴다.

### 성숙도 범례 (Maturity legend)

| 표기 | 의미 |
|---|---|
| **(Generally Available)** | 정식 출시 — 모든 적격 org에서 프로덕션 사용 가능 |
| **(Beta)** | 베타 서비스 — 명시적 Beta Services Terms 적용, 임의 사용 |
| (태그 없음) | 기존 기능의 동작 변경 / 향상 |
| **(Release Update)** | 향후 릴리즈에 강제(enforce)되는 릴리즈 업데이트 |

> 이 챕터에는 `(Pilot)` · `(Developer Preview)` 항목이 없다. PDF 원문 확인 결과 **Transform element와 Repeater 컴포넌트는 둘 다 (Generally Available)**, **Action Button 컴포넌트와 Let Einstein Build a Draft Flow는 둘 다 (Beta)** 다.

---

## Flow Builder — 신규

### Let Einstein Build a Draft Flow for You (Beta)

> PDF 원문(When): *"You can use Einstein to build draft flows (beta) starting on **July 16, 2024**."*

Einstein generative AI에게 자동화하려는 내용을 설명하면, 그 설명을 바탕으로 **draft screen / record-triggered / schedule-triggered / autolaunched flow**를 생성한다. Einstein은 거의 모든 element와 대부분의 resource(org의 **custom object 포함**)를 사용할 수 있다.

- PDF 원문: *"Most Einstein draft flows can have up to **six elements**."*
- **Where:** Lightning Experience.
- **Editions:** All Einstein 1 Editions / Enterprise, Performance, Unlimited Editions + **Einstein for Sales, Einstein for Service, 또는 Einstein for Platform add-on**.
- **Beta note (verbatim):** *"This feature is a Beta Service. Customer may opt to try such Beta Service in its sole discretion. Any use of the Beta Service is subject to the applicable Beta Services Terms provided at Agreements and Terms."*
- **How:** Setup에서 Einstein generative AI를 켜고 **Einstein for Flow (Beta)** 를 찾아 활성화 → Flows에서 New Flow(또는 Automation Lightning app의 New) → **Let Einstein Help You Build** 선택 → Next. 처음부터 지시문을 작성하거나 샘플 지시문 사용. 활성화 전 정확성·안전성 점검·디버그·테스트. Einstein 메시지의 thumbs up/down으로 피드백 제공.
- Einstein / 생성형 AI 영역과 상호 관계 → [[Summer '24/Einstein]]

### Transform Element (Generally Available)

> PDF 검증: 제목 *"Transform Your Data in Flows (**Generally Available**)"* (p.709). 본문 *"the new Transform element in Flow Builder. **Now generally available**…"*

flow resource 간 데이터를 비즈니스 프로세스에 맞는 형태로 변환하는 element. 이번 GA에서 변경점:

- **Mapping tips** — 저장 전에 misconfiguration 오류를 알려준다. 이전에는 flow 저장 시점에만 Transform 오류가 표시됐다.
- **접근성** — 키보드·스크린 리더로 source/target 데이터 탐색 및 매핑 설명 청취 가능(이전 불가).
- **Where:** Lightning Experience / Salesforce Classic — Essentials, Professional, Enterprise, Performance, Unlimited, Developer.
- **How:** target 데이터 필드/컬렉션 옆 error 아이콘에 hover하면 misconfiguration mapping tip 표시. 사용 불가한 target 필드 옆 공간에 hover하면 mapping tip 표시.

### Repeater Component (Generally Available)

> PDF 검증: TOC *"IdeaExchange Delivered: Collect User Input to Build a List of Records from a Screen (**Generally Available**)"* (p.696), 본문 p.698. *"This feature, **now generally available**, includes some changes since the last release."*

화면에서 같은 타입 항목을 여러 개 수집하는 컴포넌트. 예: 보험 정책의 beneficiary 정보를 필요한 만큼 추가하고, 그 리스트를 loop로 순회해 레코드를 생성.

- **Where:** Lightning Experience / Salesforce Classic — Essentials, Professional, Enterprise, Performance, Unlimited, Developer. PDF 원문: *"It's not supported in Classic runtime for flows."*
- **베타 이후 향상점 (verbatim list):**
  - *"Use custom components and all standard generally available screen components as child components."*
  - *"Reference the output of a child component in a different child component in a Repeater component."*
  - *"Apply conditional field visibility, input validation, and help text."*
  - *"When you debug a flow that includes a Repeater component, view information about the component in the debugger."*
  - *"Configure the component to react to user input on the same screen."*
- **How:** Screen element에 Repeater 컴포넌트 추가 → child 컴포넌트(first name, last name, DOB, relationship 등) 추가 → Screen 뒤에서 Repeater 출력을 loop로 순회해 collection variable에 저장.

### Empower Users to Fill in Addresses More Quickly with the New Search Field in the Address Screen Component

Address screen 컴포넌트에 **Google Maps 기반 검색 필드**를 포함한다. 사용자가 검색 필드에서 주소를 선택하면 flow가 주소 필드를 자동으로 채운다(IdeaExchange).

- **Where:** Lightning Experience / Salesforce Classic — Essentials, Professional, Enterprise, Performance, Unlimited, Developer. Classic runtime 미지원. PDF 원문: *"It's also not supported in Playground, Experience Builder sites, Lightning Out, Lightning Components for Visualforce, and standalone apps."*
- **How:** Screen에 Address 컴포넌트 추가 → **Enable Google Maps Search Field** 필드에 `{!$GlobalConstant.True}` 또는 true로 평가되는 formula resource 입력 → 검색 필드 label 지정 → 저장·실행.

### Require User Input in the Address Screen Component

Address 컴포넌트의 **Required** 필드로 다음 화면 이동 전 입력을 필수화한다. Required를 true로 설정하면 각 입력 필드 label 옆에 빨간 별표가 표시된다(IdeaExchange).

- **Where:** Lightning Experience / Salesforce Classic — Essentials, Professional, Enterprise, Performance, Unlimited, Developer. Classic runtime 미지원.
- **How:** Address 컴포넌트의 Required 필드를 `{!$GlobalConstant.True}` 또는 true 평가 formula resource로 설정.

### Reactive Collection Choice Sets

> PDF 제목: *"Update Choices on a Screen in Real Time with Reactive Collection Choice Sets"* (p.700)

Collection Choice Set resource를 input으로 받는 화면 컴포넌트가 같은 화면의 다른 컴포넌트 변경에 반응한다.

- PDF 원문 예시: *"you can now use the output of a Data Table component to populate a collection choice set resource, and then use that resource to configure a Choice Lookup component on the same screen. Each time a user updates a selection in the Data Table component, the Choice Lookup component reflects the change."* 이전에는 collection choice set resource가 같은 화면 변경에 반응하지 못했다.
- **Where:** Lightning Experience / Salesforce Classic — Essentials, Professional, Enterprise, Performance, Unlimited, Developer. Classic runtime 미지원.
- **How:** collection choice set을 채우는 컴포넌트를 화면에 추가 → choice 컴포넌트(예: Choice Lookup) 추가 후 그 Choice 값을 collection choice set으로 설정.

### Restrict User Input on Screen Components with the Disabled and Read Only Fields

화면 컴포넌트에 두 개의 새 필드를 도입.

- **Disabled = true:** 사용자가 컴포넌트의 어떤 필드로도 이동·수정 불가. 입력 필드에 회색 배경이 시각적 단서로 표시.
- **Read Only = true:** 사용자가 필드를 수정할 수 없으나, **이동·값 복사는 가능**.
- **Where:** Lightning Experience / Salesforce Classic — Essentials, Professional, Enterprise, Performance, Unlimited, Developer. Classic runtime 미지원.
- **How:** Disabled 또는 Read Only 필드를 `{!$GlobalConstant.True}` 또는 true 평가 formula resource로 설정.

#### 어떤 화면 컴포넌트가 Disabled / Read Only 필드를 갖는가 (p.701–702, verbatim)

> PDF 원문은 행=Screen Component, 열=속성(Has Disabled Field / Has Read Only Field). 셀 unique 값 3종을 그대로 표기한다: **Yes** / **No** / **Not applicable** (압축하지 않음 — "No"와 "Not applicable"은 다른 의미). Read Only 열은 choice 계열 컴포넌트에 "Not applicable", Address/Lookup에 "No"를 쓴다.

| Screen Component | Has Disabled Field | Has Read Only Field |
|---|---|---|
| Action Button (Beta) | No | Not applicable |
| Address | Yes | No |
| Checkbox | Yes | Not applicable |
| Checkbox Group | Yes | Not applicable |
| Choice Lookup | Yes | Not applicable |
| Currency | Yes | Yes |
| Date | Yes | Yes |
| Date & Time | Yes | Yes |
| Dependent Picklist | No | Not applicable |
| Email | Yes | Yes |
| File Upload | Yes | Not applicable |
| Long Text Area | Yes | Yes |
| Lookup | No | No |
| Multi-Select Picklist | Yes | Not applicable |
| Name | Yes | Yes |
| Number | Yes | Yes |
| Password | Yes | Yes |
| Phone | No | Yes |
| Picklist | Yes | Not applicable |
| Radio Buttons | Yes | Not applicable |
| Slider | No | Not applicable |
| Text | Yes | Yes |
| Toggle | Yes | Not applicable |
| URL | Yes | Yes |

### Address Component improvements — Update Records Using the State and Country Codes

Address screen 컴포넌트가 사용자가 선택한 국가/지역·주/도의 **ISO code**를 저장하는 두 개의 새 필드를 포함한다. 이전에는 선택 항목의 **이름만** 저장했다. ISO code 지원으로 레코드의 국가·주 필드를 이름 대신 ISO code로 업데이트할 수 있다.

- **Where:** Lightning Experience / Salesforce Classic — Essentials, Professional, Enterprise, Performance, Unlimited, Developer. Classic runtime 미지원.
- **How:** Setup → State and Country/Territory Picklists에서 **Enable Picklists for Address Fields** 활성화 → Address 컴포넌트 추가, 필요 시 **Country Code** / **State or Province Code** 필드에 기본값 지정 → 이후 flow에서 `StateCode`·`CountryCode` 값으로 레코드 업데이트·생성.

### Action Button Component (Beta)

> PDF 검증: *"Run and Use the Results of an Autolaunched Flow on the Same Screen with the New Action Button Component (**Beta**)"* (p.704). Beta — GA 아님.

flow 화면에 **Action Button** 컴포넌트를 추가해, 화면을 떠나지 않고 active autolaunched flow를 실행·결과 조회한다. 버튼 클릭 시 flow가 호출된다.

- PDF 원문 예시: Lookup으로 Contact를 검색·선택하는 화면에 Action Button을 추가해, 해당 Contact의 Account·Case·Opportunity 레코드를 조회하는 flow를 실행하고 같은 화면의 다른 필드를 채운다.
- **Beta note (verbatim):** *"This feature is a Beta Service. Customer may opt to try such Beta Service in its sole discretion. Any use of the Beta Service is subject to the applicable Beta Services Terms provided at Agreements and Terms."*
- **Where:** Lightning Experience / Salesforce Classic — Essentials, Professional, Enterprise, Performance, Unlimited, Developer. Classic runtime 미지원.
- **How:** 데이터를 조회해 outputs로 저장하는 autolaunched flow 생성·활성화 → screen flow 생성, 화면에 Action Button 추가, autolaunched flow 호출하도록 구성 → 조회 데이터를 받는 element 추가 → 저장·실행.

### Other Improvements in Screen Flow Components

- PDF 원문: *"See improved formatting when you reference Action Button or Data Table component outputs in Display Text components. Specifically, the Display Text component now renders Decimal and Date record variable outputs with the correct formatting. **Currency values are still rendered without a currency symbol. To avoid this issue, wrap the reference in a formula.**"*
- 스크린 리더가 Long Text Area·Picklist 컴포넌트에 포커스 시 label을 읽어준다(이전 미지원).
- 스크린 리더가 Data Table 컴포넌트에 선택 항목이 없을 때 이를 안내한다.
- **Where:** Lightning Experience / Salesforce Classic — Essentials, Professional, Enterprise, Performance, Unlimited, Developer. **Lightning runtime 전용.**

### Is Blank / Is Empty Operators

> PDF 제목: *"Configure Conditions More Easily with Is Blank and Is Empty Operators in Flows"* (p.710)

- **Is Blank:** text 값이 문자가 없거나 공백뿐인지 검사. text 외 데이터 타입은 값이 null인지 검사. 이전에는 Equals 연산자 + **Blank Value (Empty String)** global constant 사용.
- **Is Empty:** 컬렉션이 비었는지 검사. 이전에는 Assignment·Decision element로 컬렉션 크기를 확인.
- **Where:** **Lightning Experience** — Essentials, Professional, Enterprise, Performance, Unlimited, Developer. (이 항목은 Lightning Experience 전용, Salesforce Classic 없음.)
- **How:** Decision / Wait for Conditions / Collection Filter element 추가. Is Blank는 값을 참조하는 resource 입력 후 선택, Is Empty는 컬렉션 참조 resource 입력 후 선택.

### Check for Duplicates Before Creating Records in a Flow

중복 레코드 방지를 위해 **Create Records** element에서 조건에 맞는 레코드를 검사하고, 일치 레코드를 **skip** 또는 **update**할지 지정한다.

- PDF 원문: *"If you choose to skip matching records, the flow doesn't create or modify any records. If you choose to update matching records, the flow modifies the records with the values that you provide. Some field-level configurations and validations in your org override the settings in the Create Records element."*
- **Where:** Lightning Experience / Salesforce Classic — Essentials, Professional, Enterprise, Performance, Unlimited, Developer.
- **How:** Create Records pane에서 **Check for Matching Records** 활성화 → 조건 추가 → 일치 레코드 update/skip 선택 → 저장.

### Reuse Prompt Flows to Boost Efficiency

단일 **template-triggered prompt flow**를 prompt template 타입과 무관하게 여러 template에 적용할 수 있다. template과 flow의 input이 일치해야 한다.

- PDF 원문 예시: account input을 받는 Field Generation template과 account input을 받는 Record Summary template이 동일한 flow를 사용할 수 있다.
- **Where:** Lightning Experience — Enterprise, Performance, Unlimited. *"Einstein generative AI is available in Lightning Experience."*
- Prompt Builder / 생성형 AI 영역 → [[Summer '24/Einstein]]

### Find the Type of Automation to Build with Ease

자동화 유형 생성 프로세스 간소화. 모든 유형·template을 한 창에서 스크롤하는 대신, 처음부터 시작할지 template을 쓸지 먼저 묻고, 다음 창에 관련 정보만 표시한다. template 검색도 가능.

- **Where:** Lightning Experience / Salesforce Classic — Essentials, Professional, Enterprise, Unlimited, Developer. (이 항목은 **Performance 누락** — PDF 원문 그대로.)
- **How:** Flows → New Flow(또는 Automation app의 New) → 유형 선택 → Next. **Start From Scratch** → flow·orchestration 표시. **Use a Template** → template 표시(검색 가능).

### Flow Builder Toolbox — View Your Elements by Label

Flow Builder toolbox의 element가 API name 대신 **label**로 표시된다. tooltip에 hover하면 API name 확인. label 또는 API name으로 검색 가능.

- **Where:** Lightning Experience / Salesforce Classic — Essentials, Professional, Enterprise, Unlimited, Developer. (**Performance 누락** — PDF 그대로.)

### Build Flows More Easily with Auto-Generated Element Names

Auto-Layout 모드에서 element 추가 시 Label 값이 자동 생성·선택되어 바로 편집 가능. **Screen을 제외한 모든 element**에 적용. Decision·Wait element는 path도 자동 명명.

- **Where:** Lightning Experience / Salesforce Classic — Essentials, Professional, Enterprise, Unlimited, Developer. (**Performance 누락** — PDF 그대로.)

### Find and Select Flow Resources More Easily in More Elements

향상된 resource selection이 **Collection Filter, Collection Sort, Decision, Loop, Subflows, Recommendation Assignment, Orchestration Stages and Steps** element로 확장된다. custom property editor가 없는 Action에도 적용.

- PDF 원문: *"This enhanced selection is available only where an expression builder isn't present with the exception of the Decision element."*
- PDF 원문(주의): *"Previously, you could search for a screen component by its name without having to drill into the specific screen. **Now, you must select the screen it was created from first.**"* (Decision outcomes, Wait events, Orchestration Steps 같은 중첩 항목 검색도 동일하게 영향.)
- **Where:** Lightning Experience / Salesforce Classic — Essentials, Professional, Enterprise, Unlimited, Developer. (**Performance 누락** — PDF 그대로.)

### Use the Enhanced Action and Subflow Panel in Flow Builder

기존 Action·Subflow window를 새 **Action·Subflow panel**이 대체한다. Category·Custom Action Type로 검색하며 invocable action 탐색·구성·HTTP Callout action 생성.

- **Where:** Lightning Experience / Salesforce Classic — Essentials, Enterprise, Performance, Unlimited, Developer. (이 항목은 **Professional 누락** — PDF 그대로.)

### Lock and Unlock Records with an Action

flow의 Action element에서 **Lock Record** action으로 레코드를 잠그거나 풀고, 잠긴 동안 누가 편집할 수 있는지 지정한다.

- **Where:** Lightning Experience, Salesforce Classic(일부 org 미제공), 모든 버전의 mobile app — Essentials, Professional, Enterprise, Performance, Unlimited, Developer.

### Use the New Toggle for Flow Action Inputs with Explicit Default Values

flow action input의 명시적 기본값을 볼 수 있다. **Included with Default Value** toggle로 런타임에 전송되는 기본값 확인, **Included with Specified Value**로 값 직접 지정. 정의된 placeholder text도 표시.

- PDF 원문: *"This update doesn't impact actions that were created or updated before Summer '24."*
- **Where:** Lightning Experience / Salesforce Classic — Performance, Unlimited, Developer, Enterprise, Database.com.

### Configure a Secure Connection with MuleSoft in Setup (Generally Available)

이제 GA로, **MuleSoft Services Setup** 페이지에서 MuleSoft와의 보안 연결을 직접 구성한다. 제공된 MuleSoft·Salesforce org 코드를 교환하는 간소화된 절차로 연결을 수동 추가하면, MuleSoft가 asset을 Salesforce에 게시해 호출에 필요한 entity를 생성한다.

- **Where:** Lightning Experience — Enterprise, Performance, Unlimited, Developer.
- **How:** Setup → Quick Find "MuleSoft" → MuleSoft > Services → **Manage** → dialog에서 **Connect**.

### Use Threading Tokens in Emails

자동화 이메일도 토큰 기반 threading을 지원한다. 이메일 reply를 올바른 레코드에 안전하게 연결하려면 이메일 subject 또는 body에 **threading token**을 넣는다.

- PDF 원문: *"If the related record is a case, Email-to-Case processes email replies automatically. Salesforce now also supports threading for other types of objects. To process incoming emails containing tokens that aren't cases, create an Apex Email Service and use the `EmailMessages.getRecordIdFromEmail` function to find the record that matches the token."*
- **Where:** Lightning Experience — Essentials, Professional, Enterprise, Performance, Unlimited, Developer.
- **How:** Flow Builder의 **Send Email** core action에서 input 값 설정 시 subject/body에 threading token 추가 + Related Record ID 포함. case가 아닌 객체는 Apex Email Service로 처리. Apex 통합 상세 → [[Summer '24/Development]]

### Flow Marketing Cloud Updates (segment-triggered flow)

PDF의 Flow Marketing Cloud Updates 하위 구획. 아래는 모두 **Lightning Experience — Enterprise, Unlimited + Marketing Cloud Growth edition**.

- **End a Flow for a User at Any Point with Exit Rules** — segment-triggered flow에서 최대 **10개**의 rule을 만들어 flow 실행을 종료할 조건을 지정. 각 exit rule은 global attribute / Data Cloud data graph attribute / related attribute / calculated insight 기반 조건을 가진다. PDF 원문: flow는 사용자가 flow를 시작할 때, pause 후 재개할 때, action을 호출할 때마다 exit rule을 평가한다.
- **Wait for Specific Link Clicks with the Wait Until Event Element** — Wait Until Event element가 이메일·SMS의 **특정 링크 클릭**까지 대기하도록 업데이트.
- **Access Data Graph Attributes in Your Campaign Flows** — segment-triggered flow의 exit rule·Decision element 조건에서 Data Cloud **data graph attribute** 사용. (data graph = 기존 Data Cloud DMO 필드를 묶어 빠르게 접근하는 컬렉션.)
- **View Detailed Flow Execution Data** — triggering individual 기준으로 flow run/element 결과를 집계하는 리포트. Reports → New Report → **Flow** category → **Flow History by Individual**(개인별 전체 결과) 또는 **Flow Run Details by Individual**(element별 결과).
- **Debug Segment-Triggered Flows** — Flow Builder debug 도구로 segment-triggered flow 동작 테스트. **Debug** 클릭.
- **Package Segment and Form-Triggered Flow Templates** — draft 상태의 segment·form-triggered flow를 패키징해 사용자가 template으로 사용. (이 항목만 **all editions**.)

### Run Tests for Data Cloud-Triggered Flows

Data Cloud-triggered flow를 테스트할 시나리오를 생성·관리한다. 각 debug run마다 debug parameter를 수동 구성하지 않고도 flow 동작을 검증.

- **Where:** Lightning Experience / Salesforce Classic — all editions.
- **How:** Flow Builder에서 **View Tests** 클릭.

---

## Flow Builder — 변경

### Flow and Process Run-Time Changes in API Version 61.0

> PDF 원문: *"These updates affect only flows and processes that are configured to run on API version 61.0 or later."*

versioned update로 각 flow·process마다 런타임 동작 변경을 원할 때 채택한다. flow는 Flow Builder에서 version property를, process는 Process Builder에서 property를 편집해 런타임 API 버전을 변경한다.

- **Where:** Lightning Experience, Salesforce Classic, 모든 버전의 mobile app — Essentials, Professional, Enterprise, Performance, Unlimited, Developer.

v61.0의 3개 하위 변경(verbatim 제목 + 설명):

- **Run the Active Instead of the Latest Version of Subflows** — *"This versioned update enables screen flows to call the active version of any subflows. Previously, a screen flow called the latest version of a subflow regardless of whether it was also the active version."*
- **Fields Available Only for Input in Screen Flow Components Are Reactive When the Screen Loads** — *"This versioned update ensures that input-only fields such as the Source Collection field of the Data Table component are reactive the first time a screen loads. This change also ensures that any Lightning web components configured to provide data to other components on the same screen do so when the screen loads."*
- **Screen Component Conditional Visibility Works With Choice Values Using Display Text Input** — *"This versioned update ensures that component conditional visibility works as expected when a conditional visibility condition depends on a choice value that uses display text input."*

### Einstein for Flow (Beta) enablement

위 [Let Einstein Build a Draft Flow for You (Beta)](#let-einstein-build-a-draft-flow-for-you-beta)를 사용하려면 Setup에서 Einstein generative AI를 켜고 **Einstein for Flow (Beta)** 를 활성화해야 한다. 활성화 위치·절차는 신규 섹션 참조. 생성형 AI 영역 → [[Summer '24/Einstein]]

### Troubleshoot Screen Flows Faster with More Detailed Error Messages

많은 screen flow 런타임 오류 메시지에 네트워크 연결 문제·reactivity 문제·LWC 글자 수 초과 같은 원인 세부 정보가 추가된다.

- PDF 원문(이전): 일반 메시지 `Hmm, that didn't work. Check your internet connection and try again, or refresh the page.`
- PDF 원문(현재 예시): 클라이언트가 비호환 navigation action을 보내면 `Action not available for interview: NEXT.` 처럼 원인 세부가 포함된다.
- **Where:** Lightning Experience / Salesforce Classic — Essentials, Professional, Enterprise, Performance, Unlimited, Developer. Classic runtime 미지원.

### Debug Scheduled Flows More Successfully

scheduled flow 디버그 시 새 옵션: flow의 start condition 요구사항을 건너뛸 수 있고, 첫 번째 가용 레코드에 제한되지 않고 **특정 레코드를 선택**해 실행한다. 서로 다른 triggering record로 여러 시나리오 테스트 가능.

- PDF Why: scheduled flow 디버그가 자동으로 첫 가용 레코드를 입력으로 써서 부정확한 결과·실패를 유발할 수 있었다.
- **Where:** Lightning Experience / Salesforce Classic — Essentials, Professional, Enterprise, Performance, Unlimited, Developer.
- **How:** Setup → Flows → scheduled flow 열기 → Debug → debug 옵션·triggering record 선택 → Run. Debug Details panel에 (1) 디버그가 실행된 레코드 ID, (2) scheduled flow 트리거 시 영향받는 레코드 수가 표시된다.
  > PDF에 (1)/(2) callout이 가리키는 스크린샷이 있으나 본 wiki에는 텍스트 설명만 둔다.

### Have Unlimited Paused and Waiting Flows

> PDF 원문: *"We've removed the per-org usage-based limit for paused and waiting flow interviews. While there's no limit now for paused and waiting flow interviews, the number of paused and waiting flows can still be limited by the amount of storage available to your org. If you need more storage, call your Salesforce account rep."*

paused/waiting flow interview의 **org당 usage 한도가 제거**됐다. 단, **storage 한도는 남는다.**

- **Where:** Lightning Experience — Enterprise, Performance, Unlimited, Developer.

### Manage Your Flows More Efficiently with the Automation Lightning App

flow를 보고 모니터링하는 **Automation Lightning app**이 모든 flow admin과 권한이 부여된 사용자에게 제공된다. 새 list view로 최근 수정 flow·오류 포함 flow definition 확인, label 키워드 검색, 유형·progress status·수정일·수정자·연관 레코드 필드로 필터/정렬, Trailblazer Community·Trailhead 링크 제공.

- **Where:** Lightning Experience / Salesforce Classic — Essentials, Professional, Enterprise, Unlimited, Developer.
- **How:** App Launcher → "Automation" 검색 → Automation app. 보이지 않으면 Setup → Process Automation Settings → **Enable the Automation Lightning App**.

### Fine-Tune Access to Elements in Flow Builder (granular permissions)

Manage Flows 권한이 없는 사용자도 segment-triggered·form-triggered flow에서 **Assignment, Collection Filter, Collection Sort, Delete Records, Get Records, Loop, Subflow** element에 접근할 수 있는 새 권한.

- **Where:** Lightning Experience — Enterprise, Unlimited + Marketing Cloud Growth.
- **How:** Setup → Permission Sets → permission set(예: Marketing Cloud Admin) → App Permissions → 선택.

#### 신규 권한 7개 (p.720, verbatim)

| Permission Name | Description |
|---|---|
| Add Assignment Element to Flows | Allow users without the Manage Flow user permission to add the Assignment element to segment-triggered and form-triggered flows in the Automation or Marketing apps. |
| Add Collection Filter Element to Flows | Allow users without the Manage Flow user permission to add the Collection Filter element to segment-triggered and form-triggered flows in the Automation or Marketing apps. |
| Add Collection Sort Element to Flows | Allow users without the Manage Flow user permission to add the Collection Sort element to segment-triggered and form-triggered flows in the Automation or Marketing apps. |
| Add Delete Records Element to Flows | Allow users without the Manage Flow user permission to add the Delete Records element to segment-triggered and form-triggered flows in the Automation or Marketing apps. |
| Add Get Records Element to Flows | Allow users without the Manage Flow user permission to add the Get Records element to segment-triggered and form-triggered flows in the Automation or Marketing apps. |
| Add Loop Element to Flows | Allow users without the Manage Flow user permission to add the Loop element to segment-triggered and form-triggered flows in the Automation or Marketing apps. |
| Add Subflow Element to Flows | Allow users without the Manage Flow user permission to add the Subflow element to segment-triggered and form-triggered flows in the Automation or Marketing apps. |

### Organize Your Flows Based on Categories and Subcategories That You Define

flow record Details 페이지의 두 새 필드(**Category** / **Subcategory**)로 flow를 분류·하위분류한다. Automation app에서 custom list view 생성에 사용.

- PDF 원문: *"Because Category and Subcategory are text fields, we recommend maintaining a list of any values that you create."*
- **Where:** Lightning Experience / Salesforce Classic — Essentials, Professional, Enterprise, Unlimited, Developer.
- **How:** Automation app에서 Flow Label 클릭 → Details → Category/Subcategory 편집(예: Category = Service) → Flows tab에서 Category·Subcategory를 필터로 새 list view 생성.

### Use the Enhanced Action and Subflow Panel — see 신규

(위 [신규] 섹션의 Enhanced Action and Subflow Panel 참조 — PDF에서는 User Experience Updates 변경 항목이나 독자 경로상 신규에 함께 배치.)

---

## Flow Orchestration

PDF p.732–735. 아래는 별도 표기가 없으면 모두 **Lightning Experience — Enterprise, Performance, Unlimited, Developer**.

### Suspend and Resume an Orchestration (수동 Suspend/Resume)

실행 중인 orchestration을 **수동으로 suspend**하고, 준비되면 다시 **resume**한다.

- PDF 원문 예시: 대출 처리 orchestration을 진행하다 고객이 문서 보강을 위해 일시정지를 원하면 suspend하고, 문서가 갱신되면 resume.
- **Who:** *"Users with the Manage Orchestration Runs user permission or the Manage Orchestration Runs and Work Items user permission."*
- **How:** Orchestration Runs list view → Quick Action 메뉴 → **Suspend Run**. 재개는 Quick Action → **Resume Run**.

### Resume a Failed Orchestration (실패 복구)

step이 호출한 flow/action 실패로 orchestration run이 **지난 14일 이내**에 실패했다면, 오류를 고치고 run을 재개할 수 있다.

- PDF 원문(verbatim, 어색한 표현 포함): *"Resume Run isn't available for an orchestration run when its failure wasn't due to a called flow or when action or the failure occurred more than 14 days in the past."*
- **Who:** *"Users with the Manage Orchestration Runs user permission or the Manage Orchestration Runs and Work Items user permission."*
- **How:** Orchestration Runs list view → Quick Action 메뉴 → **Resume Run**.

### Select the Orchestration Work Item to Complete (Work Item priority)

레코드에 할당된 모든 work item을 연관 레코드 페이지의 **Orchestration Work Guide** 컴포넌트에서 보고, 먼저 완료할 항목을 선택한다.

- PDF 원문: *"When you've completed a work item, the work item list refreshes automatically."*

### Use Omni-Channel Routing with Work Items (Omni-Channel routing)

interactive step이 group/queue에 할당되면 orchestration run이 모든 할당 사용자에게 알림 이메일을 보낸다. 이제 **Omni-Channel**로 정의한 라우팅 로직에 따라 work item을 라우팅할 수 있다.

- PDF 원문: *"To use Omni-Channel routing, assign an interactive step to a queue that's associated with the Orchestration Work Item object. With Omni-Channel routing, queue members still receive notification emails, but they're also notified via the Omni-Channel widget based on your routing logic."*

### Configure Conditions More Easily with the Is Blank Operator in Orchestrations

orchestration 조건에서 **Is Blank** 연산자로 text 값이 문자 없음/공백뿐인지 검사한다. text 외 타입은 null 검사. 이전에는 Equals + Blank Value (Empty String) global constant 사용.

- **How:** Stage element / Decision element / Step resource 추가 → string을 담을 수 있는 resource로 조건 구성 → Is Blank 선택.

### Other Changes to Flow Orchestration

- **Enhanced Flow Orchestration Object Relationships** — PDF 원문: *"We've enhanced the relationships between Flow Orchestration objects. This change means that you can add relationships to custom reports and use those reports in more robust dashboards."*

---

## Flow and Process Release Updates

PDF p.724–733의 Flow and Process Release Updates. 각 항목 상세(평가·활성화 단계)는 [[Summer '24/Release Updates]]에 위임하고, 여기서는 1줄 요약 + enforce 시점을 둔다. 특별 표기 없으면 모두 `(Release Update)`.

| Release Update | enforce | 요지 |
|---|---|---|
| Enable EmailSimple Invocable Action to Respect Organization-Wide Profile Settings | **Summer '24** | Send Email invocable action이 org-wide 이메일 주소 profile 설정을 따른다 (Summer '23 도입, Spring '24→Summer '24로 연기). |
| Enforce Sharing Rules when Apex Launches a Flow | **Winter '25** | `with sharing` Apex 클래스가 default-context autolaunched flow를 시작하면 sharing rule을 적용 (Spring '24 도입). |
| Prevent Guest User from Editing or Deleting Approval Requests | **Winter '25** | guest user는 승인/거부만 가능, 편집·재할당·삭제 불가 (Winter '23 도입, 여러 차례 연기). |
| Restrict User Access to Run Flows | **Winter '25** | flow 실행에 올바른 profile/permission set 필요, **FlowSites org permission deprecate** (Winter '24 도입). |
| Enable Secure Redirection for Flows | **Spring '25** | screen flow 완료 후 redirect URL 파라미터에 엄격한 검증 적용, 신뢰 URL 외 차단 (Spring '25 도입). |
| Enforce Rollbacks for Apex Action Exceptions in REST API | **Spring '25** | REST API로 Apex action 실행 중 예외 시 트랜잭션 롤백 (Spring '23 도입, Winter '24→Spring '25 연기). |
| Run Flows in User Context via REST API | **Winter '25 (re-enforce)** | REST API 실행 flow가 실행 사용자의 profile·permission set으로 객체·필드 접근 결정 (Spring '22 enforce 후 일부 revert → 재enforce). |
| Evaluate Criteria Based on Original Record Values in Process Builder | **Summer '25** | 다중 criteria + record update가 있는 process가 시작 필드의 원래 값을 null로 평가하던 버그 수정 (Summer '19 도입). |
| Make Flows Respect Access Modifiers for Legacy Apex Actions | **Winter '25 (re-enforce)** | public legacy Apex action 포함 flow를 실패시켜 managed package 외부 노출 방지 (Spring '21 enforce 후 revert → 재enforce). |
| Disable Access to Session IDs in Flows | **Winter '25 (re-enforce)** | flow interview가 `$Api.Session_ID` 변수를 런타임에 해석하지 않도록 차단 (Winter '24 enforce 후 revert → 재enforce). |
| Enable Partial Save for Invocable Actions | **Winter '25 (re-enforce)** | bulk REST API 호출에서 단일 invocable action 실패가 전체 트랜잭션을 실패시키지 않음(partial save) (Spring '20 enforce 후 revert → 재enforce). |
| Sort Apex Batch Action Results by Request Order | **Spring '25** | Apex batch action 결과를 요청 수신 순서대로 반환. |
| Enforce Permission Requirements Defined on Built-In Apex Classes Used as Inputs | **Spring '25** | Apex action input으로 쓰인 built-in Apex 클래스의 권한 요구사항 강제 + 현재 컴포넌트 컨텍스트 보장. |

> 위 표는 `(Release Update)` 태그 항목만 담는다. **Improve Scheduled Flow Performance with Updated Limits** (p.732)는 태그 없는 변경으로, scheduled flow API를 v61.0으로 올려 변경된 async 한도를 활용한다.

**Make Flows Respect Access Modifiers** 보강 (verbatim):
- PDF 원문: *"Legacy Apex actions were formerly known as Apex plug-ins. When you define an Apex class that implements the `Process.Plugin` interface in your org, it's available in Flow Builder as a legacy Apex action."*
- PDF 원문(권장): *"For new Apex integrations, we recommend using the `InvocableMethod` annotation instead of the `Process.Plugin` interface. This update doesn't affect invocable Apex methods."*

**Run Flows in User Context via REST API** — PDF에 포함된 verbatim 엔드포인트:

```
POST /v54.0/actions/custom/flow/Update_Account_Type
```

**Enable Partial Save for Invocable Actions** — partial save를 지원하지 **않는** action type (verbatim, p.731): Cancel Fulfillment Order, Cancellation Orders, Capture Funds, Content Workspaces, Create Fulfillment Order, Create Invoice from Fulfillment Order, Create Service Report, External Services, Generate Work Orders, Invocable Apex, Skills-based Routing, Submit Digital Form Response.

> 릴리즈 업데이트 전체 상세는 [[Summer '24/Release Updates]] 참조.

---

## Deprecated

### Cadence Builder Classic — retirement (Sales Engagement 기능, Flow 챕터 외부)

> [!note] **이 항목은 Summer '24 Release Notes의 Salesforce Flow 챕터(p.693–735)에 없다.** Researcher가 해당 페이지 범위 전수 grep 결과 "Cadence" 무발견을 확인했다. Cadence Builder는 Sales Engagement / High Velocity Sales 기능으로, 그 retirement는 **Sales 챕터**에 속한다.

**Cadence Builder Classic의 retirement는 제품 맥락상 Sales Cloud / Sales Engagement에 해당하며, 본 Automation(Flow) 노트의 페이지 범위에서 추출되지 않았다.** 따라서 Flow 챕터 표현을 fabricate하지 않으며, 제품 맥락은 [[Summer '24/Clouds]]에 위임한다. 정확한 retirement 문구·시점이 필요하면 Sales Engagement 챕터에 대한 별도 추출 패스가 필요하다.

### FlowSites org permission (deprecate)

Flow 챕터 내 deprecation: **Restrict User Access to Run Flows** 릴리즈 업데이트(Winter '25 enforce)가 활성화되면 **FlowSites org permission이 deprecate**된다. 상세 → 위 [Flow and Process Release Updates](#flow-and-process-release-updates) 표 및 [[Summer '24/Release Updates]].

---

## 동작 예시 (구조 참고)

PDF에 포함된 verbatim 문자열·엔드포인트는 위 본문에 그대로 인용했다. 아래는 Transform element의 집계 의미를 설명하기 위한 **구조 예시**(PDF에 동작 코드 없음).

```apex
// 구조 예시 — 실제 동작 코드 아님
// Transform element (Generally Available)의 sum / count 개념을 Apex 유사 코드로 표현.
// 실제 Flow Builder에서는 캔버스에 Transform element를 추가해 선언적으로 매핑한다.
Integer locationCount = companyLocations.size();          // count
Decimal totalEmployees = 0;                               // sum
for (Location__c loc : companyLocations) {
    totalEmployees += loc.Employee_Count__c;
}
```

threading token용 Apex Email Service 참조도 PDF가 함수명만 언급한다(동작 코드 미포함):

```apex
// 구조 예시 — 실제 동작 코드 아님
// Use Threading Tokens in Emails: case가 아닌 객체는 Apex Email Service에서
// EmailMessages.getRecordIdFromEmail로 토큰에 매칭되는 레코드를 찾는다.
Id recordId = EmailMessages.getRecordIdFromEmail(emailBodyOrSubject);
```

---

## 관련 패턴 노트 (업데이트 필요)

아래 기존 wiki 패턴 노트들이 Summer '24 변경으로 보완이 필요하다 (cross-linker / 후속 작업 위임):

- Flow Transform element 패턴 노트 — Beta → **Generally Available** 승격 + mapping tips·접근성 반영 필요.
- Flow Repeater 컴포넌트 패턴 노트 — Beta → **Generally Available** 승격 + custom/standard child 컴포넌트, child output 상호참조, debugger 정보 반영 필요.
- Flow Orchestration 패턴 노트 — 수동 Suspend/Resume, 14일 실패 복구, Omni-Channel 라우팅 추가 반영 필요.
- Flow 거버너 한도 패턴 노트 — paused/waiting flow interview org당 usage 한도 제거 반영 필요.

> 어떤 패턴 노트가 실재하는지 및 역링크 보강은 cross-linker에 위임한다.

---

## 관련 노트
- [[Summer '24]]
- [[Summer '24/Einstein]] — Let Einstein Build a Draft Flow (Beta)·Reuse Prompt Flows의 생성형 AI / Prompt Builder 영역
- [[Summer '24/Development]] — threading token Apex Email Service, InvocableMethod·Process.Plugin 등 개발자 통합
- [[Summer '24/Clouds]] — Cadence Builder Classic retirement의 제품(Sales/Sales Engagement) 맥락
- [[Summer '24/Release Updates]] — Flow and Process Release Updates 13개 상세
- [[Release MOC]]
