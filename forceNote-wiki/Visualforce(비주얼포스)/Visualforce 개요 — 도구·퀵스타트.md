---
tags: [visualforce, vf, apex-page, controller, legacy]
source: salesforce_pages_developers_guide.pdf (Visualforce Developer Guide, v67.0 Summer '26); Adobe Flash Player EOL 정정 근거 (Tier 2) https://www.adobe.com/products/flashplayer/end-of-life.html
created: 2026-06-21
aliases: [Visualforce 개요, apex:page, Visualforce 퀵스타트, VF 개발 도구, Visualforce vs LWC]
---

# Visualforce 개요 — 도구·퀵스타트

> [!note] Visualforce는 레거시 기술이다. 신규 개발은 Lightning Web Components(LWC) 권장 — 단 기존 자산 유지·PDF 렌더·표준 페이지 오버라이드엔 여전히 유효.

> Lightning Platform에 네이티브 호스팅되는 태그 기반 마크업 언어로 커스텀 UI를 빌드하는 프레임워크. 마크업(`<apex:page>` 안)과 컨트롤러(표준/커스텀/확장)로 구성되며, 본 노트는 v67.0 가이드 Ch1–Ch3(개념·개발 도구·퀵스타트 예제)을 전수 정리한다.

---

## 1. Visualforce란?

Visualforce는 개발자가 Lightning Platform에 네이티브 호스팅되는 커스텀 UI를 빌드하도록 하는 프레임워크다. HTML과 유사한 태그 기반 마크업 언어를 포함하며, 쿼리·저장 같은 기본 DB 작업을 간단히 수행하는 서버사이드 "standard controllers" 세트를 제공한다.

- 각 Visualforce 태그는 coarse/fine-grained UI 컴포넌트(페이지 섹션, 관련 목록, 필드 등)에 대응한다.
- 컴포넌트 동작은 표준 Salesforce 페이지와 동일한 로직으로 제어하거나, Apex로 작성한 controller 클래스에 자체 로직을 연결할 수 있다.

가능한 작업:
- 위저드·멀티스텝 프로세스 빌드
- 앱 전반의 커스텀 흐름 제어
- 최적·효율적 앱 상호작용을 위한 네비게이션 패턴·데이터별 규칙 정의

**가용성:** 데스크톱 브라우저(Lightning Experience + Salesforce Classic 양쪽)와 Salesforce 모바일 앱. **iPad Safari의 Lightning Experience에서는 Visualforce 페이지·커스텀 iframe이 미지원이다.** 가용 에디션: Contact Manager, Group, Professional, Enterprise, Unlimited, Performance, Developer Editions.

> **(PDF 스크린샷 — 텍스트만)** "Sample of Visualforce Components and Their Corresponding Tags" — 컴포넌트↔태그 대응을 보여주는 다이어그램이 PDF에 있으나 텍스트로는 캡션만 추출됨.

### Visualforce 페이지의 구성

Visualforce **page definition**은 두 가지 주요 요소로 구성된다.

- **Visualforce Markup** — 단일 `<apex:page>` 태그 안에 임베드된 Visualforce 태그 + HTML + JavaScript + 기타 웹 코드. 페이지에 포함되는 UI 컴포넌트와 표시 방식을 정의한다.
- **Visualforce Controller** — 사용자가 마크업의 컴포넌트와 상호작용할 때(예: 버튼·링크 클릭) 일어나는 일에 대한 명령 세트. 페이지 데이터 접근을 제공하고 컴포넌트 동작을 수정할 수 있다.

### Controller 4종

> 컨트롤러 4종의 상세 메커니즘·메서드·`ApexPages.StandardController` 등 API는 [[ApexPages Namespace]] 및 형제 노트 `표준 컨트롤러·표준 리스트 컨트롤러`, `커스텀 컨트롤러·컨트롤러 확장` 참조. 아래는 개요 수준의 4종 구분이다.

| Controller 종류 | 정의 | 실행 모드 |
|---|---|---|
| **Standard controller** | 표준 Salesforce 페이지와 동일한 기능·로직. 예: 표준 Accounts controller 사용 시 Visualforce의 Save 버튼 클릭이 표준 Account edit 페이지의 Save와 동일 동작. 객체 접근 권한이 없으면 insufficient privileges 에러 표시. | user mode (현재 사용자의 권한·FLS·공유 규칙 적용) |
| **Standard list controller** | 레코드 집합(set)을 표시·처리하는 페이지 생성. 기존 예: list pages, related lists, mass action pages. | — |
| **Custom controller** | Apex 클래스로 페이지의 모든 로직 구현(standard controller 미사용). 새 네비게이션/동작 정의 가능하나 standard controller가 제공하던 기능을 모두 재구현해야 함. | system mode (현재 사용자의 객체·FLS 무시). 사용자 프로필 기반으로 메서드 실행 가능 여부 지정. |
| **Controller extension** | standard/custom controller 동작에 추가·오버라이드하는 Apex 클래스. 다른 controller 기능을 쓰면서 자체 로직 추가. standard controller 확장 시 사용자 권한 존중 가능. | extension 클래스는 system mode 실행이나, standard controller는 user mode 실행. |

> **Note (원문):** "Custom controllers and controller extension classes execute in system mode, so they ignore user permissions and field-level security. However, you can choose whether they respect a user's organization-wide defaults, role hierarchy, and sharing rules by using the `with sharing` keywords in the class definition. For information, see "Using the `with sharing`, `without sharing`, and `inherited sharing` Keywords" in the Apex Developer Guide."

### Visualforce 페이지 사용처

- 표준 버튼 오버라이드 (예: account의 New 버튼, contact의 Edit 버튼)
- tab overview 페이지 오버라이드 (예: Accounts tab home page)
- 커스텀 탭 정의
- detail page layout에 컴포넌트 임베드
- dashboard 컴포넌트 또는 커스텀 help 페이지 생성
- Salesforce console의 사이드바 커스터마이즈·확장·통합 (custom console components)
- Salesforce 모바일 앱에 네비게이션 메뉴 항목·액션 추가

---

## 2. 왜 LWC를 써야 하나? (Visualforce vs LWC)

신규 개발은 Lightning Experience low-code 도구 + Lightning Web Components 사용을 권장한다 (most modern, performant, responsive). Lightning Platform은 Visualforce로는 불가능한 더 새롭고 복잡한 비즈니스 프로세스를 지원한다.

기존 Visualforce를 LWC로 변환하면 앱 개선 기회가 된다. 다음을 원할 때 **재빌드(rebuild)** 고려:
- 더 매력적·반응적인 UX
- 최신 WCAG(Web Content Accessibility Guidelines) 지원
- 다양한 디바이스 form factor 최적화 용이
- 더 나은 성능

**Lightning Web Components** = HTML + 모던 JavaScript로 빌드한 커스텀 HTML 요소. 코어 Web Components 표준을 사용하며 브라우저에서 네이티브 실행 → 경량·고성능.

### Standard Visualforce Component ↔ Base Lightning Web Component 매핑

이 표로 특정 표준 Visualforce 컴포넌트의 등가 base Lightning web component를 찾는다. (PDF 방향 유지: 왼쪽 = Visualforce 컴포넌트, 오른쪽 = 대응 LWC. VF→LWC 단방향 매핑.)

| Visualforce component | Lightning web component |
|---|---|
| `apex:pageBlock` | `lightning-card` |
| `apex:pageBlockButtons` | Set actions slot on `lightning-card` |
| `apex:pageBlockSection` | `lightning-accordion` and `lightning-accordion-section` |
| `apex:pageBlockSectionItem` | `lightning-layout` and `lightning-layout-item` |
| `apex:toolbarGroup` | `lightning-layout` and `lightning-layout-item` |
| `apex:panelGrid` | `lightning-layout` and `lightning-layout-item` |
| `apex:panelGroup` | `lightning-layout` and `lightning-layout-item` |
| `apex:tabPanel` | `lightning-tabset` |
| `apex:tab` | `lightning-tab` |
| `apex:repeat` | `template for:each` or `iterator` |
| `apex:pageBlockTable` | `lightning-datatable` |
| `apex:dataTable` | `lightning-datatable` |
| `apex:inlineEditSupport` | `lightning-datatable` with inline editing in editable columns |
| `apex:image` | `lightning-platform-resource-loader` |
| `apex:stylesheet` | `lightning-platform-resource-loader` |
| `apex:includeScript` | `lightning-platform-resource-loader` |
| `apex:map` | `lightning-map` |
| `apex:form` | `lightning-record-form` / `lightning-record-view-form` / `lightning-record-edit-form` |
| `apex:input` | `lightning-input` / `lightning-slider` |
| `apex:inputCheckbox` | `lightning-input type="checkbox"` / `lightning-input type="checkbox-button"` |
| `apex:inputFile` | `lightning-input type="file"` / `lightning-file-upload` |
| `apex:inputHidden` | `lightning-input class="slds-hide"` |
| `apex:inputSecret` | `lightning-input type="password"` |
| `apex:inputText` | `lightning-input type="text"` |
| `apex:inputTextArea` | `lightning-textarea` |
| `apex:inputField` | `lightning-input-field` |
| `apex:selectCheckboxes` | `lightning-checkbox-group` |
| `apex:selectList` | `lightning-combobox` or `lightning-dual-listbox` |
| `apex:selectRadio` | `lightning-radio-group` |
| `apex:outputLabel` | Set `label` attribute on `lightning-input` |
| `apex:outputField` | `lightning-output-field` |
| `apex:outputLink` | `lightning-formatted-url` |
| `apex:outputText` | `lightning-formatted-datetime` / `lightning-formatted-number` / `lightning-formatted-rich-text` / `lightning-formatted-text` / `lightning-formatted-time` |
| `apex:commandButton` | `lightning-button` / `lightning-button-stateful` / `lightning-button-icon` / `lightning-button-icon-stateful` |
| `apex:commandLink` | `lightning-button` with bare variant |
| `apex:pageMessage` | `lightning-platform-show-toast-event` |
| `apex:messages` | Custom validity on `lightning-input` |
| `apex:message` | Use `lightning-messages` in `lightning-record-view-form` or `lightning-record-edit-form` |
| `apex:pageMessages` | Automatic for `lightning-record-form` |

### AJAX·rerender 패턴 대응 (컴포넌트 매핑 표 밖의 동작 패턴)

위 표는 **컴포넌트** 단위 매핑이다. VF의 AJAX/부분 새로고침 **패턴**(예: `apex:inputField` + `reRender` 조합)은 컴포넌트 치환이 아니라 모델 전환으로 대응한다.

| VF 패턴 | LWC 대응 |
|---|---|
| `reRender` (부분 새로고침) | **반응형 프로퍼티 자동 리렌더** — 템플릿이 참조하는 프로퍼티가 바뀌면 프레임워크가 해당 부분만 다시 그림. rerender 대상 지정 코드 자체가 불필요 |
| `apex:actionFunction` / `apex:actionSupport` | 템플릿 **이벤트 핸들러**(`onchange` 등) + **imperative Apex 호출** |
| 서버 데이터 재조회 후 반영 | `refreshApex()` (Apex `@wire` 재조회) · `RefreshViewEvent` (뷰 계층 갱신) — [[RefreshView API]] |

> 각 패턴의 전체 코드·폴링(`apex:actionPoller`→`setInterval`/`empApi`)·`actionStatus`·`actionRegion` 대응 상세는 [[VF AJAX 패턴 → LWC 대응]] 참조.

---

## 3. 권한·아키텍처·버전 관리

### Visualforce 개발에 필요한 권한

| 활동 | 필요 권한 |
|---|---|
| Visualforce development mode 활성화 | "Customize Application" |
| Visualforce 페이지 생성·편집·삭제 | "Customize Application" |
| 커스텀 Visualforce 컴포넌트 생성·편집 | "Customize Application" |
| 커스텀 Visualforce controller 또는 Apex 편집 | "Author Apex" |
| Visualforce 페이지 보안 설정 | "Manage Profiles and Permission Sets" |
| Visualforce 페이지 version settings 설정 | "Customize Application" |
| static resources 생성·편집·삭제 | "Customize Application" |
| Visualforce Tabs 생성 | "Customize Application" |

### 아키텍처

모든 Visualforce 페이지는 (개발 시·엔드유저 요청 시 모두) Lightning platform에서 전적으로 실행된다.

- **Development Mode 흐름:** 개발자 저장 → application server가 마크업을 Visualforce renderer가 이해하는 abstract instruction 세트로 compile 시도 → compile 에러 시 save 중단·에러 반환 / 정상 시 instructions를 metadata repository에 저장 후 renderer로 전송 → renderer가 instructions를 HTML로 변환 → 개발자 view 새로고침(즉각 피드백).
- **Standard User Mode 흐름:** non-developer 사용자 요청 시, 이미 instruction으로 compile되어 있으므로 application server가 metadata repository에서 페이지를 가져와 renderer로 전송 → HTML 변환.

> **(PDF 다이어그램 — 텍스트만)** PDF에 "Visualforce System Architecture - Development Mode"와 "Visualforce System Architecture - Standard User Mode" 두 개의 아키텍처 다이어그램이 있으나 텍스트로는 캡션만 추출됨. 위 흐름 설명이 텍스트로 추출된 내용 전부다 (다이어그램 재현 안 함).

> **Note (원문):** "Your Visualforce pages may be run on one of the force.com servers instead of a salesforce.com server."

### Visualforce vs S-Controls

> **Important (원문):** "Visualforce pages supersede s-controls. Organizations that haven't previously used s-controls can't create them. Existing s-controls are unaffected and can still be edited."

| 비교 항목 | Visualforce Pages | S-Controls |
|---|---|---|
| Required technical skills | HTML, XML | HTML, JavaScript, Ajax Toolkit |
| Language style | Tag markup | Procedural code |
| Page override model | Assemble standard and custom components using tags | Write HTML and JavaScript for entire page |
| Standard Salesforce component library | Yes | No |
| Access to built-in platform behavior | Yes, through the standard controller | No |
| Data binding | Yes — 입력 컴포넌트(텍스트 박스 등)를 특정 필드(Account Name 등)에 바인딩 가능. 사용자가 입력 컴포넌트에 값 저장 시 DB에도 저장됨. | No — 입력 컴포넌트를 특정 필드에 바인딩 불가. 대신 API로 DB를 갱신하는 JavaScript 코드 작성 필요. |
| Stylesheet inheritance | Yes | No, Salesforce 스타일시트를 수동으로 가져와야 함 |
| Respect for field metadata, such as uniqueness | Yes, by default | Yes, JavaScript에서 describe API call로 코딩한 경우 |
| Interaction with Apex | Direct, custom controller에 바인딩 | Indirect, API를 통한 Apex webService 메서드 사용 |
| Performance | 마크업이 Lightning Platform에서 생성되어 더 반응적 | 덜 반응적 — 모든 API 호출이 서버 왕복 필요, 성능 튜닝 부담이 개발자에게 있음 |
| Page container | Native | In an iFrame |
| uniqueness/requiredness 위반 저장 시 | 에러 메시지 자동 표시, 사용자 재시도 가능 | s-control 개발자가 속성 체크 코드를 작성한 경우에만 에러 메시지 표시 |

### 버전 관리

- Visualforce 페이지·컴포넌트는 버전 관리된다. 버전 번호가 있으면 새 구현이 도입돼도 기존 요소의 기능은 불변이다.
- **버전 시작: 15.0.** 15.0보다 이른 버전으로 설정 시도 시 자동으로 15.0으로 변경된다.
- 하위 호환을 위해 각 페이지·커스텀 컴포넌트는 지정된 API 버전 + Visualforce 버전의 version settings로 저장된다. 설치된 managed package 참조 시 각 패키지의 version settings도 저장된다.
- 커스텀 컴포넌트는 항상 자체 버전 번호로 동작한다. (예: 컴포넌트가 15.0이면, 16.0 페이지에서 실행돼도 15.0 동작.)
- VF 페이지 버전 = 내부 사용 API 버전 (예: 16.0 페이지는 내부적으로 API 16.0 사용). 단 이는 VF 프레임워크·내장 컴포넌트에 한한다. 외부 Platform API 호출(REST 등)은 컴포넌트와 함께 버전 관리되지 않으며, 호출 파라미터(보통 URL)에 버전이 임베드되어 개발자 책임으로 업데이트한다.

**버전 설정 절차:** 1) 페이지/컴포넌트 편집 후 **Version Settings** 클릭. 2) Salesforce API **Version** 선택(= 사용될 Visualforce 버전). 3) **Save** 클릭.

> **Important (원문):** "Visualforce internal behavior is not affected by the Salesforce Platform API Versions 21.0 through 30.0 Retirement. However, if your pages or components make external calls to the SOAP, REST, or Bulk API versions prior to API 31.0, they are affected by the retirement of those API versions. It's your responsibility to update your pages and components to use supported API versions."

> **Note (원문):** "You can only modify the version settings for a page or custom component on the Version Settings tab when editing the page or component in Setup."

---

## 4. 개발 도구

Visualforce 페이지·컴포넌트를 만드는 세 가지 위치:

1. **Visualforce development mode** (Customize Application 권한자만). 제공: (a) 모든 VF 페이지에 special development footer (view state, 연결된 controller, component reference 문서 링크, highlighting·find-replace·auto-suggest 지원 페이지 마크업 에디터), (b) unique URL 입력만으로 새 VF 페이지 정의, (c) 표준 사용자보다 상세한 stack trace 포함 에러 메시지.
2. **Salesforce UI:** Setup → Quick Find에 `Visualforce Pages` 입력 → Visualforce Pages 선택. 컴포넌트는 `Components` 입력 → Visualforce Components.
3. **Visual Studio Code:** 경량·확장형 코드 에디터. Salesforce Extensions for VS Code = development orgs(scratch orgs, sandboxes, DE orgs)·Apex·Aura·Visualforce 작업 기능 제공.

**development mode 활성화 절차:**
1. personal settings → Quick Find에 `Advanced User Details` 입력 → Advanced User Details 선택. (결과 없으면 `Personal Information` 입력 → Personal Information 선택.)
2. **Edit** 클릭.
3. **Development Mode** 체크박스 선택.
4. (선택) **Show View State in Development Mode** 체크박스 선택 → development footer의 View State 탭 활성화. 성능 모니터링에 유용.
5. **Save** 클릭.

### Development Mode Footer

development mode 활성화 시 페이지 URL로 이동하면 내용 조회·편집이 가능하다. 예: 페이지명 `HelloWorld`, 인스턴스 `MyDomain_login_URL` → 주소창에 `https://MyDomain_login_URL/apex/HelloWorld` 입력. 모든 VF 페이지 하단에 development mode footer가 표시된다.

- 페이지명 탭 클릭 → page editor에서 Setup으로 돌아가지 않고 마크업 조회·편집. 저장 즉시 변경 반영.
- custom controller 사용 시 controller 클래스명이 탭으로 제공 → 클릭하여 Apex 편집.
- controller extensions 사용 시 각 extension명이 탭으로 제공 → 클릭하여 Apex 편집.
- Setup에서 활성화 시 **View State** 탭이 view state 기여 항목 정보 표시.
- **Save** (edit pane 바로 위) → 저장 + 페이지 내용 새로고침.
- **Component Reference** → 지원되는 모든 VF 컴포넌트 문서 조회.
- **Where is this used?** → 해당 페이지를 참조하는 모든 Salesforce 항목 목록(커스텀 탭·controller·기타 페이지 등) 조회.
- **Collapse** / **Expand** 버튼 → footer 패널 접기·펼치기.
- **Disable Development Mode** 버튼 → development mode 완전 끄기. personal settings의 personal information 페이지에서 재활성화 전까지 꺼진 상태 유지.

> **(PDF 아이콘 — 텍스트만)** Collapse/Expand/Disable 버튼 옆 인라인 아이콘 이미지는 텍스트 추출에서 빈 괄호로만 나타남. 버튼명만 사용.

### View State 탭

**View state** = 서버 요청(송수신) 중 controller 상태 유지에 필요한 모든 데이터. 페이지 전체 크기에 기여하므로 성능은 view state 효율 관리에 의존한다.

활성화 절차: 1) personal settings → Quick Find `Advanced User Details` → 선택 (없으면 `Personal Information`). 2) **Edit**. 3) **Development Mode** 체크(미선택 시). 4) **Show View State in Development Mode** 체크. 5) **Save**.

View State 탭은 folder node로 구성된다. folder 클릭 시 Content 탭이 있는 pie chart 표시(자식 custom controllers/Apex objects/fields). 그래프 hover로 parent 전체 크기 기여 요소 확인.

> [!warning] 낡은 요구사항 — Flash 의존 서술
> 원본 문서는 "chart는 브라우저에 Flash version 6 이상이 필요하다"고 서술하나, **Adobe Flash Player는 2020-12-31에 end-of-life** 되었고 이후 모든 주요 브라우저에서 실행이 차단되었다. 따라서 이 Flash 요구사항은 현재 성립하지 않는다(현행 pie chart는 Flash 없이 렌더). 브라우저에 Flash를 설치해야 한다는 전제는 무시한다.
> 근거: [Adobe Flash Player EOL 2020-12-31](https://www.adobe.com/products/flashplayer/end-of-life.html)

**최대 view state 크기: 170KB.** 작을수록 로드가 빠르다. 최소화 방법: (a) controller/extension의 objects가 큰 비중이면 SOQL을 VF 페이지 관련 데이터만 반환하도록 정제, (b) component tree가 크면 의존 컴포넌트 수 감소.

View State 탭 컬럼 (알파벳순):

| Column | Description |
|---|---|
| % of Parent | custom controller / Apex object / field가 parent 전체 크기에서 차지하는 비율 |
| Name | custom controller / Apex object / field의 이름 |
| Size | custom controller / Apex object / field의 view state 크기 |
| Type | custom controller / Apex object / field의 타입 |
| Value | field의 값 |

Name 컬럼 node (알파벳순):

| Node | Description |
|---|---|
| Component Tree | 페이지 전체 구조 표현. 페이지 컴포넌트 수에 따라 크기 영향. |
| Internal | VF 페이지가 사용하는 internal Salesforce 데이터 표현. 개발자가 제어 불가. |
| Expressions | VF 페이지에 정의된 formula expression이 사용하는 데이터 표현. |
| State | 모든 VF custom controllers/Apex objects/fields 포함 폴더. 자식 Controller·Controller Extension 폴더 확장 시 페이지의 각 object·필드·필드 값 확인. |
| View State | 모든 node 포함 폴더. 클릭 시 VF 페이지 view state 전체 정보 확인. Capacity 탭이 할당된 view state 크기 사용량 표시. 초과 시 몇 KB 초과했는지도 표시. |

> **Note (원문):** "The View State tab should be used by developers that understand the page request process. Familiarize yourself with the order of execution in a Visualforce page before using the tab."

> **Note (원문):** "Since the view state is linked to form data, the View State tab only appears if your page contains an `<apex:form>` tag. In addition, the View State tab displays only on pages using custom controllers or controller extensions."

### Visualforce Editor

development mode footer 또는 Setup에서 VF 페이지 편집 시 다음 기능의 에디터를 사용할 수 있다.

- **Syntax highlighting:** 키워드·함수·연산자 자동 하이라이트.
- **Search:** 현재 페이지/클래스/트리거 내 텍스트 검색. Search 텍스트박스에 문자열 입력 → **Find Next**.
  - 치환: Replace 텍스트박스에 새 문자열 → **replace**(해당 인스턴스만) 또는 **Replace All**(모든 인스턴스).
  - **Match Case** 옵션 → 대소문자 구분.
  - **Regular Expressions** 옵션 → JavaScript 정규식 규칙. 여러 줄에 걸친 문자열 검색 가능. replace 시 group 변수(`$1`, `$2` …) 바인딩 가능. 예: `<h1>`을 속성 유지하며 `<h2>`로 치환하려면 `<h1(\s+)(.*)>` 검색, `<h2$1$2>`로 치환.
- **Go to line:** 지정 줄 번호 하이라이트. 미표시 줄이면 해당 줄로 스크롤.
- **Undo / Redo:** 편집 동작 되돌리기·다시 실행.
- **Font size:** 드롭다운에서 에디터 표시 문자 크기 선택.
- **Line and column position:** 커서의 줄·열 위치를 에디터 하단 상태바에 표시.
- **Line and character count:** 총 줄 수·문자 수를 하단 상태바에 표시.

키보드 단축키:

| 단축키 | 동작 |
|---|---|
| Tab | 커서에 탭 추가 |
| SHIFT+Tab | 탭 제거 |
| CTRL+f | 검색 다이얼로그 열기 / 현재 검색의 다음 항목 검색 |
| CTRL+r | 검색 다이얼로그 열기 / 현재 검색의 다음 항목을 지정 문자열로 치환 |
| CTRL+g | go to line 다이얼로그 열기 |
| CTRL+s | quick save 수행 |
| CTRL+z | 마지막 편집 동작 되돌리기 |
| CTRL+y | 되돌린 마지막 편집 동작 다시 실행 |

### Visualforce 페이지 metrics 접근

VF 페이지 metrics 쿼리는 Salesforce SOAP API의 `VisualforceAccessMetrics` 객체를 사용한다. Developer Console의 Query Editor로 쿼리하며, VS Code 사용 시 Salesforce Extension Pack의 SOQL Builder로도 가능하다.

```sql
SELECT ApexPageId, DailyPageViewCount, Id, ProfileId, MetricsDate, LogDate FROM VisualforceAccessMetrics
```

| Parameter | Description |
|---|---|
| LogDate | 페이지 접근이 로깅된 날짜 제공. release 216 이상에서 사용 가능. |
| ProfileId | 페이지에 접근한 사용자와 연결된 profile의 ID. release 216 이상에서 사용 가능. |
| ApexPageId | 추적되는 Visualforce 페이지의 ID |
| DailyPageView [sic — 표는 `DailyPageView`로 출력, 본문 필드명은 `DailyPageViewCount`] | 각 VisualforceAccessMetrics 객체가 `DailyPageViewCount` 필드에 일일 페이지뷰 카운트 추적 |
| MetricsDate | metrics 수집 날짜를 `MetricsDate`에 지정 |

org의 각 VF 페이지가 24시간 동안 받은 view 수를 추적한다. 여러 날의 합계는 같은 `ApexPageId`로 다수의 VisualforceAccessMetrics 객체를 쿼리한다.

> **Note (원문):** "Page views are tallied the day after the page is viewed, and each VisualforceAccessMetrics object is removed after 90 days."

---

## 5. 퀵스타트 — 컴파일 요건

페이지·컴포넌트는 올바르게 compile되지 않으면 저장할 수 없다. 작성 시 확인 사항:

- 컴포넌트 태그가 올바른 namespace 식별자(`apex:` 등 — apex 뒤 콜론)로 시작하는지 확인.
- API 20.0 이상에서는 Visualforce 컴포넌트·HTML 요소만 지원. `soapenv` 등 다른 prefix 마크업 태그는 미지원.
- 모든 여는 따옴표·괄호에 닫는 짝 확인.
- controller / controller extension 명명 정확성 확인.
- API 19.0 이상 생성 페이지·컴포넌트는 well-formed XML이어야 함(올바른 중첩, non-empty 요소는 end tag, empty 요소는 closing slash `/`로 종료 등).

**허용 예외:**
- JavaScript 내부에서는 well-formed XML 위반 허용 (VF에서 `<![CDATA[]]>` 태그 불필요).
- expression 내부에서도 위반 허용 (formula 내 따옴표 escape 불필요).
- 페이지 시작에 보통 필요한 XML directive(`<?xml version="1.0" encoding="UTF-8"?>` 등)는 `<apex:page>`·`<apex:component>` 같은 top-level container 태그 안에 위치 가능.

---

## 6. 퀵스타트 — 첫 페이지와 데이터 표시

### 첫 페이지 만들기

development mode 활성화 시 주소창에 다음 형식 URL을 입력해 첫 페이지를 만든다.

```
https://MyDomain_login_URL/apex/myNewPageName
```

예: 페이지명 "HelloWorld" → `http://MyDomain_login_URL/apex/HelloWorld`. 페이지가 아직 없으면 중간 페이지로 이동 → **Create Page <myNewPageName>** 클릭으로 자동 생성. 하단 **Page Editor** bar로 확장·편집.

기본 생성 마크업:

```html
<apex:page>
<!-- Begin Default Content REMOVE THIS -->
<h1>Congratulations</h1>
This is your new Apex Page: HelloWorld
<!-- End Default Content REMOVE THIS -->
</apex:page>
```

"Hello World!" 예제:

```html
<apex:page>
<b>Hello World!</b>
</apex:page>
```

필수 태그는 `<apex:page>`로, 모든 페이지 마크업의 시작·끝을 이룬다. 이 태그를 유지하면 내부에 plain text·valid HTML을 자유롭게 추가할 수 있다.

> **Note (원문):** "If you do not have Visualforce development mode enabled, you can also create a new page from Setup by entering `Visualforce Pages` in the Quick Find box, then selecting Visualforce Pages, and then clicking New. Visualforce pages can always be edited from this part of setup, but to see the results of your edits you have to navigate to the URL of your page. For that reason, most developers prefer to work with development mode enabled so they can view and edit pages in a single window."

> **Tip (원문):** "Pay attention to warnings—the Visualforce editor displays a warning if you save a page with HTML that does not include a matching end tag for every opened tag. Although the page saves, this malformed HTML might cause problems in your rendered page."

### 필드 값 표시

VF 페이지는 formula와 동일한 expression 언어를 사용한다 — `{! }` 안의 모든 것은 현재 컨텍스트 레코드 값에 접근하는 expression으로 평가된다.

```html
<apex:page>
Hello {!$User.FirstName}!
</apex:page>
```

`$User`는 항상 현재 사용자 레코드를 나타내는 global variable이며, 모든 global variable은 `$` 기호로 참조한다.

전역 비가용 레코드(특정 account/contact/custom object)의 필드에 접근하려면 페이지를 controller에 연결한다. Apex로 custom controller를 정의할 수 있으나, Salesforce는 모든 표준·커스텀 객체에 standard controller를 제공한다. `standardController` 속성을 `<apex:page>`에 추가하고 객체명을 할당한다.

```html
<apex:page standardController="Account">
Hello {!$User.FirstName}!
</apex:page>
```

저장 후 Accounts 탭이 하이라이트되고 컴포넌트 look-and-feel이 Accounts 탭과 일치한다. `{!account.<fieldName>}` 구문으로 컨텍스트 account 레코드 필드에 접근한다.

```html
<apex:page standardController="Account">
Hello {!$User.FirstName}!
<p>You are viewing the {!account.name} account.</p>
</apex:page>
```

`{!account.name}`은 standard Account controller의 `getAccount()` 메서드를 호출해 컨텍스트 account 레코드 ID를 반환한 뒤, dot notation으로 name 필드에 접근한다. 컨텍스트로 account 레코드를 가져오려면 페이지 URL에 레코드 ID query parameter를 추가한다 — 예: account detail URL `https://MyDomain_login_URL/001D000000IRt53`에서 `001D000000IRt53`를 복사해 `https://MyDomain_login_URL/apex/HelloWorld2?id=001D000000IRt53`.

> **Note (원문):** "When you save a page, the value attribute of all input components—`<apex:inputField>`, `<apex:inputText>`, and so on—is validated to ensure it's a single expression, with no literal text or white space, and is a valid reference to a single controller method or object property. An error will prevent saving the page."

> **Note (원문):** "If you use the id parameter in a URL, it must refer to the same entity referred to in the standard controller."

> **Note (원문):** "Field-level help for Visualforce pages is only available in Salesforce Classic with the page's `showHeader` attribute set to `true`. Otherwise, the help text doesn't render when the user hovers over the help icon. See Field-Level Help in Salesforce Help."

### 컴포넌트 라이브러리 사용

HTML의 `<img>`·`<table>`처럼, Visualforce component library의 태그로 UI 컴포넌트를 추가한다.

```html
<apex:page standardController="Account">
<apex:pageBlock title="Hello {!$User.FirstName}!">
You are viewing the {!account.name} account.
</apex:pageBlock>
</apex:page>
```

`<apex:detail>` 추가 — 속성이 없으면 컨텍스트 레코드의 완전한 detail view를 표시한다.

```html
<apex:page standardController="Account">
<apex:pageBlock title="Hello {!$User.FirstName}!">
You are viewing the {!account.name} account.
</apex:pageBlock>
<apex:detail/>
</apex:page>
```

속성으로 표시 내용·related list·title을 조정한다.

```html
<apex:page standardController="Account">
<apex:pageBlock title="Hello {!$User.FirstName}!">
You are viewing the {!account.name} account.
</apex:pageBlock>
<apex:detail subject="{!account.ownerId}" relatedList="false" title="false"/>
</apex:page>
```

컴포넌트가 업데이트·편집되면 이를 참조하는 VF 페이지도 업데이트된다. 컴포넌트 라이브러리 탐색은 Page Editor에서 **Component Reference** 클릭으로 각 컴포넌트(정의한 커스텀 컴포넌트 포함)의 속성을 drill down한다.

---

## 7. 퀵스타트 — 페이지 오버라이드와 redirect

### 기존 페이지를 VF 페이지로 오버라이드 (TabbedAccount)

레코드 detail 페이지를 커스텀 탭으로 레코드 정보를 섹션화한 VF 페이지로 교체한다.

1. **TabbedAccount** VF 페이지 생성:

```html
<apex:page standardController="Account" showHeader="true" tabStyle="account" >
<style>
.activeTab {background-color: #236FBD; color:white;
background-image:none}
.inactiveTab { background-color: lightgrey; color:black;
background-image:none}
</style>
<apex:tabPanel switchType="client" selectedTab="tabdetails"
id="AccountTabPanel" tabClass="activeTab"
inactiveTabClass="inactiveTab">
<apex:tab label="Details" name="AccDetails" id="tabdetails">
<apex:detail relatedList="false" title="true"/>
</apex:tab>
<apex:tab label="Contacts" name="Contacts"
id="tabContact">
<apex:relatedList subject="{!account}" list="contacts" />
</apex:tab>
<apex:tab label="Opportunities" name="Opportunities"
id="tabOpp">
<apex:relatedList subject="{!account}" list="opportunities" />
</apex:tab>
<apex:tab label="Open Activities" name="OpenActivities"
id="tabOpenAct">
<apex:relatedList subject="{!account}" list="OpenActivities" />
</apex:tab>
<apex:tab label="Notes and Attachments" name="NotesAndAttachments"
id="tabNoteAtt">
<apex:relatedList subject="{!account}" list="CombinedAttachments" />
</apex:tab>
</apex:tabPanel>
</apex:page>
```

   - `<style>`은 HTML 요소(VF 컴포넌트 아님)로 탭 2종 CSS 클래스 `activeTab`·`inactiveTab`을 정의한다.
   - `<apex:tabPanel>`이 탭을 생성한다. `tabClass`=활성 탭 CSS, `inactiveTabClass`=비활성 탭 CSS.
   - 각 자식 `<apex:tab>`은 account 관련 다른 정보 탭이다. 첫 탭은 `<apex:detail>`로 account 상세, 나머지는 `<apex:relatedList>`로 관련 레코드 목록을 표시한다.
2. preview: URL에 특정 account ID 지정. 예 `https://MyDomain_login_URL/apex/TabbedAccount?id=001D000000IRt53`.
3. 표준 Account detail 페이지 오버라이드: (a) accounts의 object management settings → **Buttons, Links, and Actions**. (b) 목록에서 **View**(account 레코드 detail 페이지) 찾기 → 드롭다운에서 **Edit**. (c) **Salesforce Classic Override** 섹션에서 override type을 **Visualforce page** 선택 → 드롭다운에서 **TabbedAccount** 선택. (d) Lightning Experience·모바일 앱에 적용하려면 **Use the Salesforce Classic override** 선택. (e) 저장.
4. Accounts 탭에서 아무 account 레코드 선택 → detail 페이지가 이제 TabbedAccount.

### 표준 객체 목록 페이지로 redirect

표준 탭으로 이동하는 버튼·링크에서 콘텐츠를 표준 객체 목록으로 redirect한다.

```html
<apex:page action="{!URLFOR($Action.Account.List, $ObjectType.Account)}"/>
```

contact 등 다른 표준 객체로 참조를 변경할 수 있다.

```html
<apex:page action="{!URLFOR($Action.Contact.List, $ObjectType.Contact)}"/>
```

---

## 8. 퀵스타트 — 입력 폼

### 입력 컴포넌트 사용

사용자 입력 캡처는 `<apex:form>` + 1개 이상 input 컴포넌트 + 제출용 `<apex:commandLink>` 또는 `<apex:commandButton>`을 사용한다.

```html
<apex:page standardController="Account">
<apex:form>
<apex:pageBlock title="Hello {!$User.FirstName}!">
You are viewing the {!account.name} account. <p/>
Change Account Name: <p/>
<apex:inputField value="{!account.name}"/> <p/>
<apex:commandButton action="{!save}" value="Save New Account Name"/>
</apex:pageBlock>
</apex:form>
</apex:page>
```

가장 흔히 쓰는 input 태그는 `<apex:inputField>`로, 표준/커스텀 객체 필드 타입에 따라 적절한 위젯을 렌더한다(date → calendar, picklist → drop-down). 필드 정의 메타데이터(required/unique, 사용자의 view/edit 권한)를 존중한다.

`<apex:inputField>`가 표시 못 하는 유일한 필드 = Apex custom controller 클래스의 member variable이다. 이 경우 `<apex:inputCheckbox>`, `<apex:inputHidden>`, `<apex:inputSecret>`, `<apex:inputText>`, `<apex:inputTextarea>`를 사용한다.

> **Note (원문):** "Remember, for this page to display account data, the ID of a valid account record must be specified as a query parameter in the URL for the page. For example: `https://MyDomain_login_URL/apex/myPage?id=001x000xxx3Jsxb`"

> **Note (원문):** "When you save a page, the value attribute of all input components—`<apex:inputField>`, `<apex:inputText>`, and so on—is validated to ensure it's a single expression, with no literal text or white space, and is a valid reference to a single controller method or object property. An error will prevent saving the page."

### 입력 필드 레이블 추가·커스터마이즈

`<apex:pageBlockSection>` 내부에서 input 컴포넌트와 일부 output 컴포넌트는 필드 form label을 자동 표시한다. 표준/커스텀 객체 필드 매핑 컴포넌트는 기본값이 object field label이며, `label` 속성으로 override할 수 있다(직접 매핑 안 된 컴포넌트도). `label`은 string 또는 string 평가 expression이다. 빈 string 설정 시 form label이 억제된다.

```html
<apex:page standardController="Contact">
<apex:form>
<apex:pageBlock title="Quick Edit: {!Contact.Name}">
<apex:pageBlockSection title="Contact Details" columns="1">
<apex:inputField value="{!Contact.Phone}"/>
<apex:outputField value="{!Contact.MobilePhone}"
label="Mobile #"/>
<apex:inputText value="{!Contact.Email}"
label="{!Contact.FirstName + ''s Email'}"/>
</apex:pageBlockSection>
<apex:pageBlockButtons >
<apex:commandButton action="{!save}" value="Save"/>
</apex:pageBlockButtons>
</apex:pageBlock>
</apex:form>
</apex:page>
```

`label` 속성 설정 가능 컴포넌트: `<apex:inputCheckbox>`, `<apex:inputField>`, `<apex:inputSecret>`, `<apex:inputText>`, `<apex:inputTextarea>`, `<apex:outputField>`, `<apex:outputText>`, `<apex:selectCheckboxes>`, `<apex:selectList>`, `<apex:selectRadio>`.

**Custom Labels and Error Messages:** `label` 설정 시 컴포넌트 레벨 에러 메시지(required/unique 등)에 사용된다. 단 custom error message에는 미사용되어 기본 object field label이 사용된다. `label`을 빈 string으로 설정 시 모든 에러 메시지에 기본 object field label이 사용된다.

### 폼 필드 탭 순서 설정

VF form의 "natural order"는 왼→오, 위→아래다. `tabIndex`·`tabOrderHint` 속성으로 변경한다.

```html
<apex:page standardController="Account">
<apex:form>
<apex:pageBlock title="Edit Account: {!Account.Name}">
<apex:pageBlockSection title="Account Details" columns="1">
<apex:inputField value="{!Account.Name}" tabOrderHint="4"/>
<apex:inputField value="{!Account.Website}" tabOrderHint="3"/>
<apex:inputField value="{!Account.Industry}" tabOrderHint="2"/>
<apex:inputField value="{!Account.AnnualRevenue}" tabOrderHint="1"/>
</apex:pageBlockSection>
</apex:pageBlock>
</apex:form>
</apex:page>
```

- **`tabOrderHint`:** 렌더된 HTML 요소의 `tabindex` 값 계산 시 hint. 다른 컴포넌트 대비 상대 순서. **정수 1~3276** 또는 동일 범위 평가 expression. 컴포넌트 1이 TAB 첫 선택. **`<apex:inputField>` 컴포넌트에서만 사용 가능.**
- **`tabIndex`:** 렌더된 HTML 요소의 `tabindex` 값 직접 설정. absolute index. **정수 0~32767** 또는 동일 범위 평가 expression. 컴포넌트 0이 TAB 첫 선택.
- **`tabIndex` 설정 가능 컴포넌트:** `<apex:commandButton>`, `<apex:commandLink>`, `<apex:inputCheckbox>`, `<apex:inputFile>`, `<apex:inputSecret>`, `<apex:inputText>`, `<apex:inputTextarea>`, `<apex:outputLabel>`, `<apex:outputLink>`, `<apex:selectCheckboxes>`, `<apex:selectList>`, `<apex:selectRadio>`.

`<apex:inputField>`(tabOrderHint)와 tabIndex 사용 컴포넌트를 혼합할 때는 tabOrderHint × 10이 해당 필드의 대략적 tabIndex 등가값이다.

---

## 9. 퀵스타트 — Dependent Fields (종속 필드)

Dependent fields는 VF 페이지 필드 값을 필터링한다. 두 부분으로 구성된다 — **controlling field**(필터링 결정) + **dependent field**(값이 필터됨). picklist·multi-select picklist·radio button·checkbox를 동적 필터한다. **Dependent picklist는 Salesforce API 19.0 이상에서만 표시 가능하다.**

**Subcategories 커스텀 picklist 생성:** 1) accounts object management settings → fields area → **New**. 2) **Picklist** → Next. 3) Field Label에 `Subcategories`. 4) 값 목록: **Apple Farms, Cable, Corn Fields, Internet, Radio, Television, Winery**. 5) Next 두 번 → Save.

**field dependency 정의:** 1) accounts object management settings → fields area. 2) **Field Dependencies**. 3) **New**. 4) controlling field = **Industry**, dependent field = **Subcategories**. 5) **Continue**. 6) 상단 행=Industry 값, 하단 열=Subcategory 값으로 dependency 매트릭스를 설정(표시 안 된 다른 Industry 타입 무시). 7) **Save**.

> **(PDF 스크린샷 — 텍스트만)** "The Field Dependency Matrix for Subcategories" — PDF에 dependency matrix 그림이 있어 사용자가 "set to match this image"하도록 안내하나 그림은 텍스트로 추출되지 않았다(매트릭스 재현 안 함). 텍스트로 확인된 동작만: Industry=Agriculture → Subcategories = Apple Farms, Corn Fields, Winery / Industry=Communication → 앞서 정의한 모든 Communication 타입.

dependentPicklists 페이지:

```html
<apex:page standardController="Account">
<apex:form >
<apex:pageBlock mode="edit">
<apex:pageBlockButtons >
<apex:commandButton action="{!save}" value="Save"/>
</apex:pageBlockButtons>
<apex:pageBlockSection title="Dependent Picklists" columns="2">
<apex:inputField value="{!account.industry}"/>
<apex:inputField value="{!account.subcategories__c}"/>
</apex:pageBlockSection>
</apex:pageBlock>
</apex:form>
</apex:page>
```

**Dependent Picklist Considerations:**
- controlling·dependent field를 여러 필드 타입(picklist, multi-picklist, radio button, checkbox)에 걸쳐 혼합 가능.
- **페이지당 dependent picklist pair 제한 = 10개.** 모든 객체 합산. `<apex:repeat>` 같은 iterative 태그에서 같은 pair 반복은 제한에 1회만 카운트.
- 페이지에 dependent picklist의 controlling field를 반드시 포함해야 한다. 누락 시 페이지 표시 때 runtime error.
- inline edit-enabled 필드를 같은 dependency group의 일반 input field와 혼합 금지:

```html
<apex:page standardController="Account">
<apex:form>
<!-- Don't mix a standard input field... -->
<apex:inputField value="{!account.Controlling__c}"/>
<apex:outputField value="{!account.Dependent__c}">
<!-- ...with an inline-edit enabled dependent field -->
<apex:inlineEditSupport event="ondblClick" />
</apex:outputField>
</apex:form>
</apex:page>
```

- inline edit-enabled dependent picklist를 Ajax 부분 갱신과 결합 시, 서로 dependent/controlling 관계인 모든 필드를 한 그룹으로 갱신한다. 개별 갱신은 비권장(undo/redo 불일치 가능). 권장: inline edit-enabled picklist를 모두 `<apex:outputPanel>`로 감싸고 `<apex:commandButton>` action 발화 시 outputPanel을 rerender.

```html
<apex:form>
<!-- other form elements ... -->
<apex:outputPanel id="locationPicker">
<apex:outputField value="{!Location.country}">
<apex:inlineEditSupport event="ondblClick" />
</apex:outputField>
<apex:outputField value="{!Location.state}">
<apex:inlineEditSupport event="ondblClick" />
</apex:outputField>
<apex:outputField value="{!Location.city}">
<apex:inlineEditSupport event="ondblClick" />
</apex:outputField>
</apex:outputPanel>
<!-- ... -->
<apex:commandButton value="Refresh Picklists" reRender="locationPicker" />
</apex:form>
```

> **Note (원문):** "If the API version used is 26.0 or earlier, and the user viewing the page has read-only access to the controlling field, the dependent picklist shows all possible values for the picklist, instead of being filtered on the read-only value. This is a known limitation in Visualforce."

---

## 10. 퀵스타트 — Dashboard 컴포넌트

VF 페이지를 dashboard 컴포넌트로 사용할 수 있다. dashboard는 source report 데이터를 chart·gauge·table·metric·VF 페이지로 표시한다. **dashboard당 최대 20개 컴포넌트.**

dashboard 포함 조건: VF 페이지가 custom controller 사용 / standard 또는 custom list controller 사용 / controller 없음. **standard controller만 있는 VF 페이지는 dashboard에 추가 불가하다.** 조건 충족 페이지만 Data Sources 탭 옵션에 표시된다. third-party cookie 비활성화 시 VF dashboard 컴포넌트는 미지원이다.

```html
<apex:page standardController="Case" recordSetvar="cases">
<apex:pageBlock>
<apex:form id="theForm">
<apex:panelGrid columns="2">
<apex:outputLabel value="View:"/>
<apex:selectList value="{!filterId}" size="1">
<apex:actionSupport event="onchange" rerender="list"/>
<apex:selectOptions value="{!listviewoptions}"/>
</apex:selectList>
</apex:panelGrid>
<apex:pageBlockSection>
<apex:dataList var="c" value="{!cases}" id="list">
{!c.subject}
</apex:dataList>
</apex:pageBlockSection>
</apex:form>
</apex:pageBlock>
</apex:page>
```

**추가 절차:** 1) VFDashboard VF 페이지 생성(위 코드 — standard list controller 사용). 2) Salesforce Classic dashboard 빌드. 3) (a) **Dashboards** 탭. (b) 대상 dashboard에서 **Edit**. (c) **Components** 탭에서 **Visualforce Page**를 dashboard로 drag. (d) **Data Sources** 탭에서 **Visualforce Pages** 드롭다운 → **VFDashboard**를 방금 추가한 컴포넌트로 drag. (e) (선택) header/footer 입력. (f) 저장.

> **Note (원문):** "Visualforce pages as dashboard components are only available in Salesforce Classic. In Lightning Experience, you can create a custom tab and use that as a dashboard for your custom lightning components."

> **EDITIONS (원문 사이드바):** "Available in: Salesforce Classic (not available in all orgs) / Available in: all editions"

---

## 11. 퀵스타트 — 커스텀 객체 관련 목록

커스텀 객체와 그 관련 목록을 VF로 표시하는 것은 매우 간단하다. 커스텀 객체 3개를 가정한다 — MyChildObject, MyMasterObject(master), MyLookupObject. MyChildObject ↔ MyMasterObject = master-detail, MyLookupObject ↔ MyChildObject = Lookup.

```html
<apex:page standardController="MyMasterObject__c">
<apex:relatedList list="MyChildObjects__r" />
</apex:page>
```

데이터 표시엔 URL에 유효한 custom object 레코드 ID query parameter가 필요하다(예 `?id=a00x00000003ij0`). MyLookupObject는 다른 관계 타입이나 syntax는 동일하다.

```html
<apex:page standardController="MyLookupObject__c">
<apex:relatedList list="MyChildObjects__r" />
</apex:page>
```

> **Important (원문):** "Where possible, we changed noninclusive terms to align with our company value of Equality. We maintained certain terms to avoid any effect on customer implementations."

---

## 12. 퀵스타트 — Inline Editing

**Visualforce 21.0 이상에서 inline editing을 지원한다.** 레코드 detail 페이지에서 필드 값을 빠르게 편집한다. editable cell은 hover 시 pencil 아이콘(편집 가능), non-editable cell은 lock 아이콘(편집 불가)을 표시한다.

`<apex:detail>`은 inline editing 활성화 속성(`inlineEdit="true"`)을 가진다. `<apex:inlineEditSupport>`는 여러 container 컴포넌트에 inline editing 기능을 제공한다.

```html
<apex:page standardController="Account">
<apex:detail subject="{!account.Id}" relatedList="false" />
</apex:page>
```

```html
<apex:page standardController="Account">
<apex:detail subject="{!account.Id}" relatedList="false" inlineEdit="true"/>
</apex:page>
```

`<apex:inlineEditSupport>`는 항상 다음 컴포넌트의 descendant여야 한다: `<apex:dataList>`, `<apex:dataTable>`, `<apex:form>`, `<apex:outputField>`, `<apex:pageBlock>`, `<apex:pageBlockSection>`, `<apex:pageBlockTable>`, `<apex:repeat>`.

```html
<apex:page standardController="Account" recordSetVar="records" id="thePage">
<apex:form id="theForm">
<apex:pageBlock id="thePageBlock">
<apex:pageBlockTable value="{!records}" var="record" id="thePageBlockTable">
<apex:column >
<apex:outputField value="{!record.Name}" id="AccountNameDOM" />
<apex:facet name="header">Name</apex:facet>
</apex:column>
<apex:column >
<apex:outputField value="{!record.Type}" id="AccountTypeDOM" />
<apex:facet name="header">Type</apex:facet>
</apex:column>
<apex:column >
<apex:outputField value="{!record.Industry}"
id="AccountIndustryDOM" />
<apex:facet name="header">Industry</apex:facet>
</apex:column>
<apex:inlineEditSupport event="ondblClick"
showOnEdit="saveButton,cancelButton" hideOnEdit="editButton" />
</apex:pageBlockTable>
<apex:pageBlockButtons >
<apex:commandButton value="Edit" action="{!save}" id="editButton" />
<apex:commandButton value="Save" action="{!save}" id="saveButton" />
<apex:commandButton value="Cancel" action="{!cancel}" id="cancelButton"
/>
</apex:pageBlockButtons>
</apex:pageBlock>
</apex:form>
</apex:page>
```

**inline editing 미지원 케이스:**
- 미가용 환경: Accessibility mode / Setup pages / Dashboards / Customer Portal / Descriptions for HTML solutions.
- case·lead edit 페이지의 다음 standard checkbox는 inline 편집 불가: Case Assignment (Assign using active assignment rules) / Case Email Notification (Send notification email to contact) / Lead Assignment (Assign using active assignment rule).
- 다음 standard object의 필드는 inline 편집 불가: Documents·Price Books의 모든 필드 / Tasks의 Subject·Comment 제외 모든 필드 / Events의 Subject·Description·Location 제외 모든 필드 / Person Accounts·Contacts·Leads의 Full name 필드 (단 component 필드인 First Name·Last Name은 가능).
- read-only 접근(FLS 또는 sharing model) 레코드 필드도 inline edit로 변경할 수 있으나 Salesforce가 저장을 불허해 insufficient privileges 에러를 표시한다.
- standard rich text area(RTA) 필드(예: Idea.Body)가 `<apex:outputField>`에 바인딩되고 VF 페이지가 별도 도메인에서 서빙될 때 inline editing 미지원. **Custom RTA 필드는 이 제한의 영향을 받지 않아 inline editing을 지원한다.**
- `<apex:outputField>`를 사용하는 dependent picklist는 inline editing을 지원한다.
- (Dependent §과 동일) 페이지에 controlling field 포함 필수 / inline edit-enabled 필드를 같은 dependency group 일반 input과 혼합 금지 / Ajax 부분 갱신 결합 시 한 그룹으로 갱신.

---

## 13. 퀵스타트 — PDF 렌더링

`<apex:page>`에 `renderAs="pdf"` 속성을 추가하고 rendering service로 "pdf"를 지정하면 모든 페이지를 PDF로 렌더할 수 있다. 브라우저 설정에 따라 브라우저에 표시되거나 PDF 파일로 다운로드된다.

```html
<apex:page renderAs="pdf">
```

현재 날짜·시간과 함께 새 회사명 announcement를 생성하는 예제:

```html
<apex:page standardController="Account" renderAs="pdf" applyBodyTag="false">
<head>
<style>
body { font-family: 'Arial Unicode MS'; }
.companyName { font: bold 30px; color: red; }
</style>
</head>
<body>
<center>
<h1>New Account Name!</h1>
<apex:panelGrid columns="1" width="100%">
<apex:outputText value="{!account.Name}" styleClass="companyName"/>
<apex:outputText value="{!NOW()}"></apex:outputText>
</apex:panelGrid>
</center>
</body>
</apex:page>
```

- `<style>`은 CSS 마크업(VF 아님)으로 페이지 전체 font-family와 companyName 스타일을 정의한다.
- `<apex:panelGrid>`는 HTML table로 렌더된다. body의 각 컴포넌트가 column 수에 도달할 때까지 첫 행의 셀에 배치된다(예제는 단일 셀이므로 각 output text가 별도 행에 표시).
- 배포 전 렌더 페이지 포맷을 항상 확인한다.

---

## 14. 퀵스타트 — 데이터 테이블

`<apex:pageBlockTable>`·`<apex:dataTable>` 등은 레코드 컬렉션을 iterate해 다수 레코드 정보를 한 번에 표시한다.

```html
<apex:page standardController="Account">
<apex:pageBlock title="Hello {!$User.FirstName}!">
You are viewing the {!account.name} account.
</apex:pageBlock>
<apex:pageBlock title="Contacts">
<apex:pageBlockTable value="{!account.Contacts}" var="contact">
<apex:column value="{!contact.Name}"/>
<apex:column value="{!contact.MailingCity}"/>
<apex:column value="{!contact.Phone}"/>
</apex:pageBlockTable>
</apex:pageBlock>
</apex:page>
```

required 속성 2개: `value`(sObject 레코드 list 또는 기타 Apex 타입 값; 예 `{!account.Contacts}`는 컨텍스트 account ID를 가져와 관계 순회로 연결 contact 목록 반환), `var`(iteration 변수명; body에서 각 contact 필드 접근). `<apex:pageBlockTable>`은 1개 이상 자식 `<apex:column>`을 가지며, table 행 수 = value 속성 반환 레코드 수다.

> **Note (원문):** "The `<apex:pageBlockTable>` component automatically takes on the styling of a standard Salesforce list. To display a list with your own styling, use `<apex:dataTable>` instead."

### 데이터 테이블 편집

data table column에 `<apex:inputField>`를 쓰면 편집 가능 필드 table이 된다. `<apex:commandButton>`으로 변경 데이터를 저장하고, 메시지(예 Saving)는 `<apex:pageMessages>` 태그로 자동 표시된다.

```html
<apex:page standardController="Account" recordSetVar="accounts"
tabstyle="account" sidebar="false">
<apex:form>
<apex:pageBlock >
<apex:pageMessages />
<apex:pageBlockButtons>
<apex:commandButton value="Save" action="{!save}"/>
</apex:pageBlockButtons>
<apex:pageBlockTable value="{!accounts}" var="a">
<apex:column value="{!a.name}"/>
<apex:column headerValue="Industry">
<apex:inputField value="{!a.Industry}"/>
</apex:column>
</apex:pageBlockTable>
</apex:pageBlock>
</apex:form>
</apex:page>
```

standard set controllers로 table 데이터를 생성한다. `recordSetVar` 속성으로 데이터 set 이름을 지정하고 `<apex:pageBlockTable>` value에 그 이름을 사용한다. `<apex:inputField>`가 필드 표시를 자동 생성(여기선 drop-down list)하고, `<apex:commandButton>` 사용을 위해 페이지를 `<apex:form>`으로 감싼다.

> **Note (원문):** "If you have an ID attribute in the URL, this page does not display correctly. For example, `https://MyDomainName--PackageName.vf.force.com/apex/HelloWorld?id=001D000000IR35T` produces an error. You need to remove the ID from the URL."

---

## 15. 퀵스타트 — Query String Parameters

기본 페이지 컨텍스트(데이터 소스 레코드)는 URL의 `id` query string parameter로 제어된다. VF 마크업에서 query string parameter를 get·set할 수 있다.

### Getting Query String Parameters

`$CurrentPage` global variable + `parameters` 속성으로 개별 parameter에 접근한다 → `$CurrentPage.parameters.parameter_name`. 예: account ID는 기본 `id`, contact ID는 `cid` parameter.

```html
<apex:page standardController="Account">
<apex:pageBlock title="Hello {!$User.FirstName}!">
You are displaying values from the {!account.name} account and a separate contact
that is specified by a query string parameter.
</apex:pageBlock>
<apex:pageBlock title="Contacts">
<apex:dataTable value="{!account.Contacts}" var="contact" cellPadding="4" border="1">
<apex:column>
<apex:facet name="header">Name</apex:facet>
{!contact.Name}
</apex:column>
<apex:column>
<apex:facet name="header">Phone</apex:facet>
{!contact.Phone}
</apex:column>
</apex:dataTable>
</apex:pageBlock>
<apex:detail subject="{!$CurrentPage.parameters.cid}" relatedList="false" title="false"/>
</apex:page>
```

렌더하려면 URL에 둘 다 지정한다: `https://MyDomain_login_URL/apex/MyFirstPage?id=001D000000IRt53&cid=003D000000Q0bIE`.

### Setting Query String Parameters in Links

링크에 query string parameter 설정은 URL을 수동 구성하거나 `<apex:outputLink>` 안에 `<apex:param>` 태그를 사용한다. 두 방식은 동일 링크를 생성하며 `<apex:param>` 방식이 스타일상 선호된다.

```html
<apex:outputLink value="http://google.com/search?q={!account.name}">
Search Google
</apex:outputLink>
<apex:outputLink value="http://google.com/search">
Search Google
<apex:param name="q" value="{!account.name}"/>
</apex:outputLink>
```

> **Note (원문):** "In addition to `<apex:outputLink>`, use `<apex:param>` to set request parameters for `<apex:commandLink>`, and `<apex:actionFunction>`."

### Getting and Setting on a Single Page

목록 각 contact 이름을 hyperlink로 만들어 아래 detail 컴포넌트 컨텍스트를 제어한다. 방법: (1) data table을 `<apex:form>`으로 wrap, (2) 각 contact 이름을 `<apex:commandLink>`로 변환해 `<apex:param>`으로 `cid`를 설정. standard controller 사용 시 command link는 항상 새 정보(갱신된 cid)로 현재 페이지 전체를 새로고침한다.

```html
<apex:page standardController="Account">
<apex:pageBlock title="Hello {!$User.FirstName}!">
You are displaying contacts from the {!account.name} account.
Click a contact's name to view his or her details.
</apex:pageBlock>
<apex:pageBlock title="Contacts">
<apex:form>
<apex:dataTable value="{!account.Contacts}" var="contact" cellPadding="4"
border="1">
<apex:column>
<apex:facet name="header">Name</apex:facet>
<apex:commandLink>
{!contact.Name}
<apex:param name="cid" value="{!contact.id}"/>
</apex:commandLink>
</apex:column>
<apex:column>
<apex:facet name="header">Phone</apex:facet>
{!contact.Phone}
</apex:column>
</apex:dataTable>
</apex:form>
</apex:pageBlock>
<apex:detail subject="{!$CurrentPage.parameters.cid}" relatedList="false" title="false"/>
</apex:page>
```

저장 후 URL에 `id`만 있고 `cid` 없이 새로고침(`?id=001D000000IRt53`)하면 초기엔 contact detail이 미렌더되고, contact 이름을 클릭하면 적절한 detail view가 렌더된다.

---

## 16. 퀵스타트 — Ajax

일부 VF 컴포넌트는 Ajax aware라서 JavaScript 없이 Ajax 동작을 추가할 수 있다.

### Command Link/Button 부분 페이지 갱신

partial page update = 사용자 액션 후 페이지 전체 reload 없이 특정 부분만 갱신. 가장 간단한 구현은 `<apex:commandLink>` 또는 `<apex:commandButton>`의 `reRender` 속성이다. 클릭 시 식별된 컴포넌트와 모든 자식만 refresh된다.

절차: 1) rerender할 부분을 식별 — `<apex:detail>`을 `<apex:outputPanel>`로 wrap하고 `id` 부여(페이지 내 unique). 2) `<apex:commandLink>`에 `reRender` 속성을 추가하고 output panel의 `id`와 동일 값을 부여.

```html
<apex:page standardController="Account">
<apex:pageBlock title="Hello {!$User.FirstName}!">
You are displaying contacts from the {!account.name} account.
Click a contact's name to view his or her details.
</apex:pageBlock>
<apex:pageBlock title="Contacts">
<apex:form>
<apex:dataTable value="{!account.Contacts}" var="contact" cellPadding="4"
border="1">
<apex:column>
<apex:commandLink rerender="detail">
{!contact.Name}
<apex:param name="cid" value="{!contact.id}"/>
</apex:commandLink>
</apex:column>
</apex:dataTable>
</apex:form>
</apex:pageBlock>
<apex:outputPanel id="detail">
<apex:detail subject="{!$CurrentPage.parameters.cid}" relatedList="false"
title="false"/>
</apex:outputPanel>
</apex:page>
```

> **Note (원문):** "You cannot use the reRender attribute to update content in a table."

### 비동기 작업 상태 표시

Ajax 동작(partial page update 등)은 사용자가 작업하는 동안 background에서 비동기 발생한다. `<apex:actionStatus>`로 진행 중 background 활동의 status 메시지를 표시한다. `startText`·`stopText` 속성으로 background event 시작/종료 시 메시지를 표시하며 이미지·다른 컴포넌트도 표시할 수 있다.

```html
<apex:page standardController="Account">
<apex:pageBlock title="Hello {!$User.FirstName}!">
You are displaying contacts from the {!account.name} account.
Click a contact's name to view his or her details.
</apex:pageBlock>
<apex:pageBlock title="Contacts">
<apex:form>
<apex:dataTable value="{!account.Contacts}" var="contact" cellPadding="4"
border="1">
<apex:column>
<apex:commandLink rerender="detail" status="detailStatus">
{!contact.Name}
<apex:param name="cid" value="{!contact.id}"/>
</apex:commandLink>
</apex:column>
</apex:dataTable>
</apex:form>
</apex:pageBlock>
<apex:outputPanel id="detail">
<apex:actionStatus startText="Requesting..." id="detailStatus">
<apex:facet name="stop">
<apex:detail subject="{!$CurrentPage.parameters.cid}"
relatedList="false" title="false"/>
</apex:facet>
</apex:actionStatus>
</apex:outputPanel>
</apex:page>
```

`<apex:commandLink>`가 Ajax 요청을 시작하므로 `status` 속성을 actionStatus의 `id`로 설정한다. `<apex:actionStatus>`는 `<apex:facet>`를 지원하며, `name="stop"`은 facet 내부 nested 컴포넌트(여기선 `<apex:detail>`) render까지 status 메시지를 표시한다는 의미다.

### 임의 컴포넌트 이벤트에 Ajax 적용

command link/button 없이 partial page update를 구현한다(예: 컴포넌트 hover로 트리거). data table에서 `<apex:commandLink>`를 제거하고 contact 이름을 `<apex:outputPanel>`로 wrap한 뒤, output panel 안에 `<apex:actionSupport>`를 contact 이름의 sibling으로 추가한다.

```html
<apex:page standardController="Account">
<apex:pageBlock title="Hello {!$User.FirstName}!">
You are displaying contacts from the {!account.name} account.
Mouse over a contact's name to view his or her details.
</apex:pageBlock>
<apex:pageBlock title="Contacts">
<apex:form>
<apex:dataTable value="{!account.Contacts}" var="contact" cellPadding="4"
border="1">
<apex:column>
<apex:outputPanel>
<apex:actionSupport event="onmouseover" rerender="detail"
status="detailStatus">
<apex:param name="cid" value="{!contact.id}"/>
</apex:actionSupport>
{!contact.Name}
</apex:outputPanel>
</apex:column>
</apex:dataTable>
</apex:form>
</apex:pageBlock>
<apex:outputPanel id="detail">
<apex:actionStatus startText="Requesting..." id="detailStatus">
<apex:facet name="stop">
<apex:detail subject="{!$CurrentPage.parameters.cid}"
relatedList="false"
title="false"/>
</apex:facet>
</apex:actionStatus>
</apex:outputPanel>
</apex:page>
```

- `<apex:outputPanel>`이 특수 동작 영역을 정의한다.
- `<apex:actionSupport>`가 이전에 command link가 하던 partial page update를 정의한다. `event` 속성은 트리거 DOM event(commandLink는 onclick만, actionSupport는 onclick·ondblclick·onmouseover 등 모든 유효 event), `reRender`는 refresh할 부분, `<apex:param>`은 event 발생 시 `cid` query string parameter 값을 설정한다.

> **Note (원문):** "The reRender attribute isn't required. If you don't set it, the page doesn't refresh upon the specified event, but `<apex:param>` still sets the name and value of cid."

---

## 17. 퀵스타트 — External Domain에 VF 페이지 framing

신뢰된 external domain에 VF 콘텐츠를 framing하려면 clickjack protection을 활성화하고 framing 허용 도메인을 지정한다. 인증이 필요한 VF 페이지라면 framing 페이지와 동일 도메인에 서빙하도록 custom domain을 사용한다.

**Authenticated VF 페이지 framing 옵션:** website가 authenticated VF 페이지를 iframe 로드 시 인증은 Salesforce session cookie에 의존한다. 브라우저가 third-party cookie를 차단하므로 추가 단계가 필요하다. custom domain으로 framing 페이지와 동일 registrable domain에 authenticated 콘텐츠를 서빙하는 것을 권장한다.

- **방법 1:** framing 사이트의 registrable domain의 subdomain에 authenticated 콘텐츠 서빙. 예: website가 `example.com`이면 `site.example.com`. framing 도메인이 다른 subdomain(`www.example.com`)이어도 동작.
- **방법 2:** framing과 동일 도메인에 authenticated 페이지를 서빙하도록 custom domain 설정. third-party service/CDN으로 custom domain을 서빙(필수 prerequisite 완료). framing 시 Salesforce-served URL path prefix를 포함한다. 예: custom domain `example.com`, site path `/store`인 Experience Cloud site 페이지면 `https://example.com/store`를 framing.
- custom domain을 쓸 수 없으면 token-based authentication과 함께 **Lightning Out (beta)**을 사용할 수 있다.

**Clickjack Protection 활성화 및 신뢰 도메인 지정:** Setup → Quick Find `Session Settings` → **Session Settings**. **Clickjack Protection** 아래 **Enable clickjack protection for customer Visualforce pages with headers disabled** + **Enable clickjack protection for customer Visualforce pages with standard headers**를 선택한다. **Trusted Domains for Inline Frames** 아래 framing 허용 external domain을 추가하고 iframe type을 **Visualforce Pages**로 설정한다. **최대 512개 external domain을 추가할 수 있다.** 추가 후 VF 페이지는 `X-Frame-Options`·`Content-Security-Policy` HTTP 헤더로 렌더되어 해당 도메인 framing을 허용한다.

external domain에 VF 페이지를 framing하는 HTML:

```html
<html>
<head></head>
<body>
<iframe src="https://MyDomainName--PackageName.vf.force.com/apex/iframe"></iframe>
</body>
</html>
```

> **Note (원문):** "Lightning Out is a Beta Service. Customer may opt to try such Beta Service in its sole discretion. Any use of the Beta Service is subject to the applicable Beta Services Terms provided at Agreements and Terms."

> **Tip (원문):** "Some infrastructure limits the maximum size of HTTP headers. If you allow multiple domains to frame your Visualforce pages, keep the size of the CSP header under 12 KB. Salesforce customers report issues when the header size approaches 16 KB, and third parties often add to the header during processing."

---

## 관련 노트

- [[ApexPages Namespace]] — Visualforce 컨트롤러용 Apex 클래스(`StandardController`, `StandardSetController`, `Message`, `Action` 등) 레퍼런스
- [[표준 컨트롤러·표준 리스트 컨트롤러]]
- [[커스텀 컨트롤러·컨트롤러 확장]]
- [[apex 컴포넌트 — 페이지·레이아웃 구조]] — `apex:page`·`apex:pageBlock` 등 마크업 컴포넌트 레퍼런스
- [[VF AJAX 패턴 → LWC 대응]] — 위 매핑 표에 없는 AJAX/액션 계열(actionPoller·actionFunction·actionSupport·reRender)의 LWC 대응
