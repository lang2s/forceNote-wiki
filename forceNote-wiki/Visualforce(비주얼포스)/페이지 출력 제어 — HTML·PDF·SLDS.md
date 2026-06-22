---
tags: [visualforce, vf, pdf, slds, rendering, legacy]
source: salesforce_pages_developers_guide.pdf (Visualforce Developer Guide, v67.0 Summer '26)
created: 2026-06-21
aliases: [Visualforce PDF 렌더링, renderAs pdf, lightningStylesheets, VF docType contentType, Visualforce 스타일링]
---

# 페이지 출력 제어 — HTML·PDF·SLDS

> Visualforce 페이지의 외관(스타일·SLDS·테마)과 출력 형식(custom doctype·MIME type·PDF 렌더링)을 제어하는 Chapter 4 전수 — `renderAs="pdf"`·`PageReference.getContentAsPDF()`·`lightningStylesheets`·`<apex:slds>` 포함.

> 레거시 안내 — Visualforce는 Salesforce Classic 기반의 레거시 마크업 프레임워크다. 신규 UI 개발은 Lightning Web Components(LWC) 권장이며, 본 챕터의 `lightningStylesheets`·`<apex:slds>`는 기존 VF 페이지를 Lightning Experience와 시각적으로 정렬하기 위한 호환 기능이다.

---

이 노트는 Visualforce Developer Guide(v67.0 Summer '26) **Chapter 4 — "Customizing the Appearance and Output of Visualforce Pages"(p.49–85) 전 하위섹션**을 다룬다. 7개 메이저 섹션(Styling / HTML Comments / HTML Tags Added by VF / Custom Doctype / contentType / Custom HTML Attributes / Render as PDF) 전부.

---

## 1. Styling Visualforce Pages

많은 VF 컴포넌트는 `style` 또는 `styleClass` 속성을 가진다. 둘 중 하나를 정의하면 컴포넌트에 CSS 코드를 연결할 수 있다. 커스텀 CSS로 컴포넌트의 기본 시각 스타일(width, height, color, font 포함)을 변경할 수 있다.

### 1.1 Using Salesforce Styles

많은 VF 컴포넌트는 이미 Salesforce 동일 컴포넌트의 룩앤필을 가진다(detail page의 related list, section header 등). 스타일링(색 구성 포함) 일부는 컴포넌트가 표시되는 탭에 기반한다. 탭 스타일은 다음으로 지정한다.

- **standard controller 연결:** 새 페이지가 연관 객체의 standard 탭 스타일을 따른다. 연관 객체의 메서드·레코드 접근도 허용된다.
- **`tabStyle` 속성:** custom controller 사용 시 `<apex:page>`의 `tabStyle` 속성으로 연관 Salesforce 페이지의 룩앤필을 모방한다. 페이지 일부만 유사하게 하려면 `<apex:pageBlock>`의 `tabStyle`을 쓴다. (예제는 가이드 "Defining Getter Methods" p.129 참조)

### 1.2 Extending Salesforce Styles with Stylesheets

`<apex:stylesheet>` 태그로 페이지에 추가 스타일시트를 더한다. 대부분 컴포넌트에 있는 `style`/`styleClass` 속성으로 스타일시트 정의에 연결한다 — Salesforce 스타일을 자체 스타일로 확장하는 방식이다.

```html
<apex:page>
<apex:stylesheet value="{!$Resource.TestStyles}"/>
<apex:outputText value="Styled Text in a sample style class" styleClass="sample"/>
</apex:page>
```

이 예제의 스타일시트(`TestStyles` 정적 리소스):

```css
.sample {
font-weight: bold;
}
```

### 1.3 Using the Lightning Design System

`<apex:slds>` 요소로 SLDS를 VF 페이지에 통합해 Lightning Experience 스타일과 정렬한다. SLDS를 정적 리소스로 업로드하는 것의 간소화된 대안으로, 페이지 구문을 단순하게 유지하고 250-MB 정적 리소스 한도 이내로 유지한다.

**SLDS 스타일시트 사용 절차:**

1. 페이지 마크업 아무 곳에나 `<apex:slds />` 추가.
2. `<apex:page>`의 `applyBodyTag` 또는 `applyHtmlTag` 속성을 `false`로 설정.
3. SLDS 스타일/에셋 부모 요소에 `slds-scope` 클래스 포함.

> **Warning:** Don't wrap any Visualforce tags in the slds-scope element. (slds-scope 요소 안에 VF 태그를 감싸지 말 것)

```html
<apex:page standardController="Account" applyBodyTag="false">
<apex:slds />
<!-- any Visualforce component should be outside SLDS scoping element -->
<apex:outputField value="{!Account.OwnerId}" />
<div class="slds-scope">
<!-- SLDS markup here -->
</div>
</apex:page>
```

일반적으로 SLDS는 이미 scoped 되어 있다. 단 `applyBodyTag`/`applyHtmlTag`를 false로 설정하면 scoping 클래스 `slds-scope`를 직접 포함해야 한다. scoping 클래스 안에서 마크업이 SLDS 스타일·에셋을 참조할 수 있다.

SLDS 에셋(SVG 아이콘·이미지) 참조는 `URLFOR()` 수식 함수 + `$Asset` 글로벌 변수를 쓴다. SVG account 아이콘 참조 마크업:

```html
<svg aria-hidden="true" class="slds-icon">
<use xlink:href="{!URLFOR($Asset.SLDS,
'assets/icons/standard-sprite/svg/symbols.svg#account')}"></use>
</svg>
```

SVG 아이콘 사용 시 html 태그에 XML 네임스페이스를 추가한다: `xmlns="http://www.w3.org/2000/svg"` 및 `xmlns:xlink="http://www.w3.org/1999/xlink"`.

> **Note:** If you're using the Salesforce sidebar, header, or built-in style sheets, you can't add attributes to the html. VG icons are supported only if showHeader, standardStylesheets, and sidebar are set to false. [sic — "VG icons"는 원문 그대로, "SVG icons" 오타로 추정]

**SLDS card 사용 account detail 예제:** 다음 마크업은 SLDS card 요소 + account standard controller + account PNG 아이콘을 쓴 단순 account detail 페이지다. 이 페이지는 record ID로 로드하지 않는 한 데이터가 없다. SLDS는 `<apex:pageBlock>`·`<apex:detail>`처럼 VF 페이지로 데이터를 가져오는 컴포넌트를 지원하지 않는다. SLDS 사용 페이지에서 Salesforce 데이터 접근은 Remote Objects, JavaScript remoting, 또는 REST API를 쓴다.

```html
<apex:page showHeader="false" standardStylesheets="false" sidebar="false"
docType="html-5.0" standardController="Account" applyBodyTag="False"
applyHtmlTag="False">
<head>
<title>{! Account.Name }</title>
<apex:slds />
</head>
<body class="slds-scope">
<!-- MASTHEAD -->
<p class="slds-text-heading--label slds-m-bottom--small">
Using the Lightning Design System in Visualforce
</p>
<!-- / MASTHEAD -->
<!-- PAGE HEADER -->
<p class="slds-text-title_caps slds-line-height--reset">Accounts</p>
<h1 class="slds-page-header__title slds-truncate" title="My Accounts">{!
Account.Name }</h1>
<span class="slds-icon_container slds-icon-standard-account" title="Account
Standard Icon">
<svg class="slds-icon slds-page-header__icon" aria-hidden="true">
<use xmlns:xlink="http://www.w3.org/1999/xlink"
xlink:href="{!URLFOR($Asset.SLDS,
'assets/icons/standard-sprite/svg/symbols.svg#account')}" />
</svg>
</span>
<!-- / HEADING AREA -->
<div class="slds-col slds-no-flex slds-grid slds-align-top">
<button class="slds-button slds-button--neutral">New Account</button>
</div>
<!-- / PAGE HEADER -->
<!-- ACCOUNT DETAIL CARD -->
<div class="slds-panel slds-grid slds-grid--vertical slds-nowrap">
<div class="slds-form--stacked slds-grow slds-scrollable--y">
<div class="slds-panel__section">
<h3 class="slds-text-heading--small slds-m-bottom--medium">Account Detail</h3>
<div class="slds-form-element slds-hint-parent slds-has-divider--bottom">
<span class="slds-form-element__label">Name</span>
<div class="slds-form-element__control">
<span class="slds-form-element__static">{! Account.Name }</span>
</div>
</div>
<div class="slds-form-element slds-hint-parent slds-has-divider--bottom">
<span class="slds-form-element__label">Phone</span>
<div class="slds-form-element__control">
<span class="slds-form-element__static">{! Account.Phone }</span>
</div>
</div>
</div>
<div class="slds-panel__section slds-has-divider--bottom">
<div class="slds-media">
<div class="slds-media__body">
<div class="slds-button-group slds-m-top--small" role="group">
<button class="slds-button slds-button--neutral slds-grow">Edit</button>
<button class="slds-button slds-button--neutral slds-grow">Save</button>
<button class="slds-button slds-button--neutral slds-grow">New
Account</button>
</div>
</div>
</div>
</div>
</div>
</div>
<!-- / ACCOUNT DETAIL CARD -->
</body>
</apex:page>
```

더 많은 SLDS 스타일링 예제는 Salesforce Lightning Design System reference site와 Trailhead 참조.

### 1.4 Style Existing Visualforce Pages with Lightning Experience Stylesheets

`lightningStylesheets` 속성은 LEX/Salesforce 모바일 앱에서 볼 때 페이지가 Lightning Experience 룩으로 스타일링될지를 제어한다.

> **Note:** The lightningStylesheets attribute isn't supported in Experience Cloud sites.

LEX/모바일 앱에서 볼 때 LEX UI에 맞추려면 `<apex:page>` 태그에 `lightningStylesheets="true"`를 설정한다. Salesforce Classic에서 보면 LEX 스타일링이 적용되지 않는다.

```html
<apex:page lightningStylesheets="true">
```

`lightningStylesheets="true"`이면 CSS scoping 클래스 `slds-vf-scope`가 VF 페이지의 `<body>` 요소에 자동 적용된다. 콘텐츠가 LEX UI와 매치되도록 scoping 클래스가 적용되는 것이다. `applyBodyTag`/`applyHtmlTag`를 false로 설정하면 scoping 클래스 `slds-vf-scope`를 수동으로 추가해야 한다.

> ⚠️ 시각 자료 (PDF 스크린샷 — 텍스트만): p.54에 두 스크린샷이 본문 사이에 있다 — "Here is a standard Visualforce page without the lightningStylesheets attribute. The page is styled with the Classic UI." / "Here is the same Visualforce page with the lightningStylesheets attribute set to true." 이미지는 pdftotext로 추출되지 않아 위 두 캡션만 확보됨.

대부분의 흔히 쓰이는 VF 컴포넌트를 `lightningStylesheets`로 스타일링할 수 있다. 단 일부 컴포넌트는 LEX와 스타일이 약간 다르다. 예: `<apex:inputFile>`, 일부 `<apex:inputField>` 요소는 브라우저 기본 스타일링을 쓴다. 스타일링이 불필요한 흔한 컴포넌트(`<apex:form>`, `<apex:outputText>`, `<apex:param>`)도 여전히 지원된다.

VF 컴포넌트 라이브러리에 없는 커스텀 SLDS 컴포넌트를 포함하려면 `<apex:slds/>` 태그 + 코드 + `lightningStylesheets` 속성을 함께 쓴다.

> **Note:**
> • The lightningStylesheets attribute doesn't affect custom styling. Custom code must be updated to match the page's SLDS styling.
> • If set to false, the standardStylesheets attribute for `<apex:page>` overrides and suppresses lightningStylesheets in Lightning Experience, Salesforce Classic, and the mobile app.
> • The `<apex:slds>` component has known issues when creating PDF files from Visualforce pages. For this reason, lightningStyleSheets does not support `<apex:page renderAs="pdf">` or calls to PageReference.getContentAsPDF(). [sic — "lightningStyleSheets" 대소문자 원문]

`lightningStylesheets="true"` 사용 시 대부분의 VF 버튼이 neutral variant로 표시된다. 어떤 버튼을 branded 해야 할지 신뢰성 있게 판단할 selector hook이 없어서 neutral로 스타일링된다. org 브랜딩 기반 버튼을 만들려면 `<apex:commandButton>`에 `.slds-vf-button_brand` 스타일 속성을 추가한다:

```html
<apex:commandButton styleClass="slds-vf-button_brand" value="Refresh the Page">
```

> **Note:** When building new features, use `<apex:slds>` and implement the button using the Lightning Design System Button blueprint.

**lightningStylesheets 속성을 지원하거나 스타일링이 불필요한 VF 컴포넌트 전수 목록 (PDF 원문에 나열된 컴포넌트 전수):**

```
analytics:reportChart, apex:actionFunction, apex:actionPoller, apex:actionRegion,
apex:actionStatus, apex:actionSupport, apex:areaSeries, apex:attribute, apex:axis,
apex:barSeries, apex:canvasApp, apex:chart, apex:chartLabel, apex:chartTips,
apex:column, apex:commandButton, apex:commandLink, apex:component, apex:componentBody,
apex:composition, apex:dataList, apex:dataTable, apex:define, apex:detail,
apex:dynamicComponent, apex:enhancedList, apex:facet, apex:flash, apex:form,
apex:gaugeSeries, apex:iframe, apex:image, apex:include, apex:includeLightning,
apex:includeScript, apex:inlineEditSupport, apex:input, apex:inputCheckbox,
apex:inputField, apex:inputFile, apex:inputHidden, apex:inputSecret, apex:inputText,
apex:inputTextArea, apex:insert, apex:legend, apex:lineSeries, apex:listViews,
apex:map, apex:mapMarker, apex:message, apex:messages, apex:outputField,
apex:outputLabel, apex:outputLink, apex:outputPanel, apex:outputText, apex:page,
apex:pageBlock, apex:pageBlockButtons, apex:pageBlockSection, apex:pageBlockSectionItem,
apex:pageBlockTable, apex:pageMessage, apex:pageMessages, apex:panelBar,
apex:panelBarItem, apex:panelGrid, apex:panelGroup, apex:param, apex:pieSeries,
apex:radarSeries, apex:relatedList, apex:remoteObjectField, apex:remoteObjectModel,
apex:remoteObjects, apex:repeat, apex:scatterSeries, apex:scontrol, apex:sectionHeader,
apex:selectCheckboxes, apex:selectList, apex:selectOption, apex:selectOptions,
apex:selectRadio, apex:stylesheet, apex:tab, apex:tabPanel, apex:toolbar,
apex:toolbarGroup, apex:variable, chatter:feed, chatter:feedWithFollowers,
chatter:follow, chatter:newsFeed, flow:interview, site:googleAnalyticsTracking,
site:previewAsAdmin, topics:widget
```

### 1.5 Using Custom Styles

`<apex:stylesheet>` 태그 또는 정적 HTML로 자체 스타일시트/스타일을 포함한다. HTML 태그에 대해 일반 HTML 페이지처럼 inline CSS 코드를 정의할 수 있다:

```html
<apex:page>
<style type="text/css">
p { font-weight: bold; }
</style>
<p>This is some strong text!</p>
</apex:page>
```

정적 리소스로 정의된 스타일시트를 참조하려면, 먼저 스타일시트를 만들어 `customCSS`로 업로드한다:

```css
h1 { color: #f00; }
p { background-color: #eec; }
.newLink { color: #f60; font-weight: bold; }
```

다음, 이 정적 리소스를 참조하는 페이지를 생성한다:

```html
<apex:page showHeader="false">
<apex:stylesheet value="{!$Resource.customCSS}" />
<h1>Testing Custom Stylesheets</h1>
<p>This text could go on forever...<br/><br/>
But it won't!</p>
<apex:outputLink value="https://salesforce.com" styleClass="newLink">
Click here to switch to www.salesforce.com
</apex:outputLink>
</apex:page>
```

> **Tip:** Salesforce 스타일을 사용하지 않으면 표준 Salesforce 스타일시트 로딩을 막아 페이지 크기를 줄일 수 있다. `<apex:page>`의 `standardStylesheets` 속성을 false로 설정한다. 단, Salesforce 스타일시트를 로드하지 않으면 그것을 필요로 하는 컴포넌트는 올바르게 표시되지 않는다.

```html
<apex:page standardStylesheets="false">
<!-- page content here -->
</apex:page>
```

HTML을 생성하는 VF 컴포넌트는 pass-through `style`·`styleClass` 속성을 가진다. `style`은 컴포넌트에 직접 스타일을 설정하고, `styleClass`는 다른 곳에 정의된 스타일용 클래스에 연결한다.

```html
<apex:page>
<style type="text/css">
.asideText { font-style: italic; }
</style>
<apex:outputText style="font-weight: bold;"
value="This text is styled directly."/>
<apex:outputText styleClass="asideText"
value="This text is styled via a stylesheet class."/>
</apex:page>
```

스타일시트에 이미지를 쓰려면 이미지를 CSS 파일과 함께 zip으로 묶어 단일 정적 리소스로 업로드한다. 예: CSS 파일에 다음 줄이 있으면 전체 images 디렉토리와 부모 CSS 파일을 단일 zip(이 예에서 리소스 이름 `myStyles`)으로 결합한다.

```css
body { background-image: url("images/dots.gif") }
```

```html
<apex:stylesheet value="{!URLFOR($Resource.myStyles, 'styles.css')}"/>
```

> **Warning:** If a style sheet has an empty string in a url value, you can't render that page as a PDF. For example, the style rule `body { background-image: url(""); }` prevents any page that includes the rule from being rendered as a PDF.

### 1.6 Suppressing the Salesforce User Interface and Styles

기본적으로 VF 페이지는 Salesforce 나머지와 같은 시각 스타일·UI "chrome"을 채택한다. Salesforce 룩앤필을 원치 않으면 `<apex:page>`의 다음 속성으로 억제한다.

- **sidebar** — false로 설정하면 표준 사이드바가 억제된다. 사이드바를 제거하면 페이지 캔버스가 넓어진다(예: 테이블에 더 많은 컬럼 표시). 이 속성은 나머지 Salesforce 룩앤필에는 영향이 없다 — `<apex:pageBlock>`, `<apex:detail>`, `<apex:inputField>` 같은 컴포넌트는 계속 Salesforce UI 스타일링으로 렌더된다.
- **showHeader** — false로 설정하면 표준 Salesforce 페이지 디자인이 억제된다. 헤더·탭·사이드바가 연관 스타일시트·JS 리소스(세션 타임아웃 시 리디렉트 보조 스크립트 등)와 함께 제거되어 자체 UI를 채울 빈 페이지가 된다. 단, 표준 페이지 디자인 억제가 Salesforce 시각 디자인을 제공하는 모든 스타일시트·스크립트나 페이지에 포함된 다른 스크립트를 억제하지는 않는다. 페이지에 추가하는 VF 컴포넌트는 계속 Salesforce 시각 디자인을 채택한다.
- **standardStylesheets** — `showHeader`도 false로 설정한 상태에서 false로 설정하면 Salesforce 시각 디자인을 지원하는 스타일시트 포함이 억제된다. 표준 스타일시트를 억제하면 자체 스타일시트를 제외하고 페이지는 unstyled가 된다. `showHeader`도 false로 설정하지 않으면 이 속성을 false로 설정해도 효과가 없다.

> **Note:** If you don't load the Salesforce style sheets, components that require them don't display correctly.

### 1.7 Defining Styles for a Component's DOM ID

DOM ID로 스타일을 적용할 때는 CSS attribute selector를 쓴다. attribute selector는 HTML 태그가 아니라 속성의 정의에 기반해 CSS 스타일을 적용한다.

어떤 VF 컴포넌트에도 `id` 값을 설정해 DOM ID를 설정할 수 있다. 단 렌더된 HTML의 id는 보통 부모 컴포넌트의 id가 앞에 붙는다(VF의 자동 ID 생성 과정의 일부). 예를 들어 다음 코드의 실제 HTML id는 `j_id0:myId`다:

```html
<apex:page>
<apex:outputText id="myId" value="This is less fancy."/>
</apex:page>
```

CSS는 attribute selector로 이를 고려해야 한다:

```html
<apex:page>
<style type="text/css">
[id*=myId] { font-weight: bold; }
</style>
<apex:outputText id="myId" value="This is way fancy !"/>
</apex:page>
```

이 selector는 ID 내 어디든 "myId"를 포함하는 모든 DOM ID와 매치되므로, 스타일링 목적으로 사용하려면 VF 컴포넌트에 설정한 id가 페이지에서 unique해야 한다.

### 1.8 Using Styles from Salesforce Stylesheets

Salesforce는 모든 탭이 룩앤필에 부합하도록 앱 전반에 다양한 스타일시트(.css)를 사용한다. 이 스타일시트는 `<apex:page>`의 `showHeader` 속성을 false로 지정하지 않는 한 VF 페이지에 자동 포함된다.

> **Warning:** Salesforce stylesheets aren't versioned, and the appearance and class names of components change without notice. Salesforce strongly recommends that you use Visualforce components that mimic the look-and-feel of Salesforce styles instead of directly referencing—and depending upon—Salesforce stylesheets.

다음 스타일시트는 참조 가능한 스타일 클래스를 포함하며, Salesforce 인스턴스의 `/dCSS/` 디렉토리에 위치한다:

- **dStandard.css** — 표준 객체·탭의 스타일 정의 대부분 포함.
- **allCustom.css** — 커스텀 탭의 스타일 정의 포함.

> **Important:** Salesforce doesn't provide notice of changes to or documentation of the built-in styles. Use at your own risk.

### 1.9 Identifying the Salesforce Style Your Users See

VF 페이지 작성 시 사용자가 기대하는 Salesforce 룩앤필을 아는 것이 유용하다(사용자 스타일과 매치하는 페이지를 렌더하기 위해). 일부 사용자는 룩앤필을 커스터마이즈할 선택지가 있다.

스타일 식별용 글로벌 변수는 `$User.UITheme`와 `$User.UIThemeDisplayed` 두 가지다. 차이: `$User.UITheme`는 사용자가 **봐야 할** 룩앤필을 반환하고, `$User.UIThemeDisplayed`는 사용자가 **실제로 보는** 룩앤필을 반환한다. 예: 사용자가 LEX 룩앤필을 볼 권한·환경설정이 있어도 그것을 지원하지 않는 브라우저(예: 구버전 IE)를 쓰면 `$User.UIThemeDisplayed`는 다른 값을 반환한다.

**두 변수가 반환하는 값 (전수):**

| 값 | 설명 |
|---|---|
| Theme1 | Obsolete Salesforce theme |
| Theme2 | Salesforce Classic 2005 user interface theme |
| Theme3 | Salesforce Classic 2010 user interface theme |
| Theme4d | Modern "Lightning Experience" Salesforce theme |
| Theme4t | Salesforce mobile app theme |
| Theme4u | Lightning Console theme |
| PortalDefault | Salesforce Customer Portal theme |
| Webstore | AppExchange theme |

개발자가 Salesforce를 닮도록 CSS 스타일을 하드코딩한 경우, 사용자 환경설정에 맞춰 여러 스타일시트 중 선택해야 한다:

```html
<apex:page standardController="Account">
<apex:variable var="newUI" value="newSkinOn"
rendered="{!$User.UIThemeDisplayed = 'Theme3'}">
<apex:stylesheet value="{!URLFOR($Resource.myStyles, 'newStyles.css')}" />
</apex:variable>
<apex:variable var="oldUI" value="oldSkinOn"
rendered="{!$User.UIThemeDisplayed != 'Theme3'}">
<apex:stylesheet value="{!URLFOR($Resource.myStyles, 'oldStyles.css')}" />
</apex:variable>
<!-- Continue page design -->
</apex:page>
```

이 예제의 주의점:

- `rendered` 속성으로 어떤 섹션이 표시될지 "toggle"할 수 있다.
- `<apex:stylesheet>` 태그는 `rendered` 속성이 없으므로, `rendered` 속성이 있는 컴포넌트로 감싸야 한다.

새 룩앤필이 활성화되어도 사용자가 올바른 브라우저·접근성 설정이 아니면 못 볼 수 있다. `$User.UITheme` 변수로 사용자에게 대체 정보를 제공하는 예제:

```html
<apex:page showHeader="true" tabstyle="Case">
<apex:pageMessage severity="error" rendered="{!$User.UITheme = 'Theme3' &&
$User.UIThemeDisplayed != 'Theme3'}">
We've noticed that the new look and feel is enabled for your organization.
However, you can't take advantage of its brilliance. Please check with
your administrator for possible reasons for this impediment.
</apex:pageMessage>
<apex:ListViews type="Case" rendered="{!$User.UITheme = 'Theme3' &&
$User.UIThemeDisplayed = 'Theme3'}"/>
</apex:page>
```

`$User.UITheme`은 Theme3이지만 `$User.UIThemeDisplayed`은 아니므로 페이지가 완전히 렌더되지 않는다.

### 1.10 Determining the Salesforce Style That Users See in JavaScript

페이지·앱에 JS를 많이 쓰면 JS 코드에서 사용자가 보는 Salesforce 테마를 식별하는 것이 중요하다. `UITheme.getUITheme()` JavaScript 함수는 현재 UI 테마를 식별하는 문자열을 반환하며, 반환 값은 위 1.9 표와 동일하다(Theme1 / Theme2 / Theme3 / Theme4d / Theme4t / Theme4u / PortalDefault / Webstore). 반환 문자열 값은 VF `$User.UITheme`·`$User.UIThemeDisplayed` 글로벌 변수가 반환하는 값과 동일하다.

현재 사용자 경험 컨텍스트가 LEX 테마인지 확인하는 마크업:

```javascript
function isLightningDesktop() {
return UITheme.getUITheme === "Theme4d";
}
```

[sic — 본문 코드는 `UITheme.getUITheme`로 괄호 `()`가 없다. 설명문에서는 `UITheme.getUITheme()`로 표기되어 원문 자체가 불일치 — 그대로 보존]

---

## 2. HTML Comments and IE Conditional Comments

VF는 대부분의 HTML/XML 주석을 렌더 전 내용 처리 없이 제거한다. 단 IE 조건부 주석은 제거하지 않는다(IE 전용 리소스·메타 태그를 포함할 수 있으므로).

VF는 표준 HTML 주석(`<!-- -->`)으로 감싼 것은 single line/multiline 무관 아무것도 평가하지 않는다. 비-IE 주석의 경우 VF 컴파일러가 HTML 주석 내용을 별표(asterisks)로 치환한다. 이 때문에 HTML 주석은 구버전 브라우저에서 JS 코드를 주석 처리하기에 부적합하다.

IE 조건부 주석은 주로 브라우저 호환성 문제(일반적으로 구버전 IE) 해결에 쓴다. 페이지 어디서나 동작하지만, 자주 페이지의 `<head>` 태그 안에 배치되어 버전별 스타일시트나 JS 호환 "shims" 포함에 사용된다.

조건부 주석을 페이지 `<head>` 태그 안에 두려면 표준 Salesforce 헤더·사이드바·스타일시트를 비활성화하고 자체 `<head>`·`<body>` 태그를 추가한다:

```html
<apex:page docType="html-5.0" showHeader="false" standardStylesheets="false">
<head>
<!-- Base styles -->
<apex:stylesheet value="{!URLFOR($Resource.BrowserCompatibility, 'css/style.css')}"/>

<!--[if lt IE 7]>
<script type="text/javascript"
src="{!URLFOR($Resource.BrowserCompatibility, 'js/obsolete-ie-shim.js')}>
</script>
<link rel="stylesheet" type="text/css"
href="{!URLFOR($Resource.BrowserCompatibility, 'css/ie-old-styles.css')}"
/>
<![endif]-->
<!--[if IE 7]>
<link rel="stylesheet" type="text/css"
href="{!URLFOR($Resource.BrowserCompatibility, 'css/ie7-styles.css')}" />
<![endif]-->
</head>
<body>
<h1>Browser Compatibility</h1>
<p>It's not just a job. It's an adventure.</p>
</body>
</apex:page>
```

VF는 표준 HTML 주석 안의 VF 태그(예: `<apex:includeScript/>`)를 지원·평가하지 않는다. 단 IE 조건부 주석 안에서는 다음 표현식을 평가한다:

- 글로벌 변수, 예: `$Resource`, `$User`
- `URLFOR()` 함수

---

## 3. HTML Tags Added or Modified by Visualforce

기본적으로 VF는 유효한 HTML(및 XML) 문서 보장을 위해 필수 HTML 태그를 페이지에 자동 추가한다. 이 동작은 완화·오버라이드할 수 있다.

자동 동작 사용 페이지에서 VF는 두 컨텍스트로 HTML 태그를 추가한다: **(1) GET 요청 컨텍스트**(페이지 최초 로드·렌더 시), **(2) POSTBACK 컨텍스트**(`<apex:form>` 제출, `<apex:actionXXX>` 태그로 Ajax 요청 등).

- **GET 컨텍스트** — VF가 렌더하는 HTML은 다소 relaxed하다. 페이지를 감싸는 `<html>` 태그, 페이지 title 및 `<apex:stylesheet>`/`<apex:includeScript>`로 추가된 스타일시트·스크립트를 감싸는 `<head>` 태그, 페이지 콘텐츠를 감싸는 `<body>` 태그를 추가한다. 다른 VF 태그가 생성한 HTML은 완전하고 유효한 HTML이며, 유효하지 않은 정적 XML로는 VF 페이지를 저장할 수 없다. 단 controller 메서드·sObject 필드·기타 비-VF 소스에 접근하는 표현식이 추가한 HTML은 반환 전 VF에 의해 검증되지 않는다 — 따라서 GET 요청으로 유효하지 않은 XML 문서를 반환할 수 있다.
- **POSTBACK 컨텍스트** — VF는 더 엄격하다. 요청 내용이 기존 DOM에 삽입되어야 할 수 있으므로 응답 HTML이 유효성 확보를 위해 후처리된다. 이 "tidying"은 누락·미닫힌 태그 수정, 유효하지 않은 태그·속성 제거 등으로 반환되는 페이지의 DOM에 깔끔히 삽입되게 한다. `<apex:actionHandler>` 같이 기존 DOM을 업데이트하는 태그가 안정적으로 동작하도록 의도된 동작이다.

### 3.1 Relaxed Tidying for the HTML5 Doctype

HTML5 앱에서 문제 발생 시 기본 HTML tidying을 완화하려면 `docType`을 "html-5.0"으로, API 버전을 28.0 이상으로 설정한다.

API 버전 28.0부터 `docType="html–5.0"` VF 페이지의 tidying 동작이 POSTBACK 컨텍스트에서 변경된다 — HTML5 태그·속성이 제거되지 않는다. VF는 저장 시 항상 모든 페이지의 XML 정확성을 검증하고 well-formed XML을 요구하지만, 후처리 tidying이 POSTBACK 요청에 대해 더는 알 수 없는 태그·속성을 제거하지 않는다. 이로써 HTML5·JS 프레임워크(HTML 속성 광범위 사용) 작업이 훨씬 쉬워진다.

현대 브라우저는 자체 tidying을 잘하지만 그 동작은 유효한 마크업 렌더링보다 덜 일관적이다. html–5.0 모드의 감소된 HTML tidying은 더 작은 안전망인 대신 훨씬 큰 유연성을 제공한다. 필요한 HTML5 페이지에만, HTML 검증·디버깅 도구와 함께 이 relaxed tidying 모드를 쓸 것을 권장한다.

> **Note:** In API version 28.0 or greater, the scope of how the docType is determined for a page is different. When child pages are added to a root page using `<apex:include>`, if any page in the hierarchy is set to docType="html–5.0" and the root page is set to API version 28.0 or later, the entire page hierarchy is rendered in html–5.0 mode.

### 3.2 Manually Override Automatic `<html>` and `<body>` Tag Generation

`<apex:page>` 태그의 `applyHtmlTag`·`applyBodyTag` 속성으로 `<html>`·`<body>` 태그 자동 생성을 억제하고 직접 추가한 정적 마크업을 사용한다:

```html
<apex:page showHeader="false" sidebar="false" standardStylesheets="false"
applyHtmlTag="false" applyBodyTag="false" docType="html-5.0">
<html>
<body>
<header>
<h1>Congratulations!</h1>
</header>
<article>
<p>This page looks almost like HTML5!</p>
</article>
</body>
</html>
</apex:page>
```

두 속성은 서로 독립적으로 작동하며, true·false·unset 어떤 조합으로도 쓸 수 있다. 둘 다 true(기본값)면 `<html>`·`<body>` 태그 자동 생성이 유지된다. 어느 하나가 false면 해당 태그를 마크업에 직접 추가할 책임이 있다. 이 모드에서 VF는 현대 브라우저도 곤란하게 할 nonsense 태그 조합·속성 생성을 막지 않는다.

> **Note:** A `<head>` section is always generated if required, regardless of the values for applyHtmlTag and applyBodyTag. For example, a `<head>` tag is generated if you use `<apex:includeScript>` or `<apex:stylesheet>` tags, set the page title, and so on.

이 규칙에 예외가 하나 있다: `applyHtmlTag`가 false이고 `<apex:includeScript>` 외 페이지에 다른 요소가 없으면 `<head>`가 생성되지 않는다. 예: 다음 코드는 `<body>` 태그는 자동 추가하지만 `<head>` 섹션은 추가하지 않는다(실제 페이지에서 문제를 일으키지 않을 것):

```html
<apex:page showHeader="false" applyHtmlTag="false">
<html>
<apex:includeScript
value="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"/>
</html>
</apex:page>
```

`applyHtmlTag` 속성은 API 버전 27.0 이상, `applyBodyTag` 속성은 API 버전 28.0 이상에서 사용 가능하다. 둘 다 추가 제약이 있다:

- 페이지의 `showHeader` 속성이 false여야 한다.
- `contentType` 속성이 "text/html"(기본값)이어야 한다.
- top level(최외곽) `<apex:page>` 태그의 값이 사용된다 — `<apex:include>`로 추가된 페이지의 `applyHtmlTag`·`applyBodyTag` 속성은 무시된다.

### 3.3 Creating an Empty HTML5 "Container" Page

대부분의 VF를 우회하고 자체 마크업을 추가하려면 빈 container 페이지를 쓴다. HTML5·모바일 개발 및 표준 VF 출력이 필요 없는 웹 앱에 특히 유용하다. Remote Objects, JavaScript remoting, 기타 Lightning Platform API로 서비스 요청을 하고 JS로 결과를 렌더한다.

```html
<apex:page docType="html-5.0" applyHtmlTag="false" applyBodyTag="false"
showHeader="false" sidebar="false" standardStylesheets="false"
title="Unused Title">
<html>
<head>
<title>HTML5 Container Page</title>
</head>
<body>
<h1>An Almost Empty Page</h1>
<p>This is a very simple page.</p>
</body>
</html>
</apex:page>
```

`<apex:page>` 컴포넌트와 그 속성이 container 페이지 정의의 핵심이다:

- `docType="html-5.0"` — 현대 HTML5 docType 사용 설정.
- `applyHtmlTag="false"`·`applyBodyTag="false"` — 마크업이 `<html>`·`<body>` 태그를 제공하므로 VF가 자체 생성하지 않도록 지시.
- `showHeader="false"`·`sidebar="false"`·`standardStylesheets="false"` — Salesforce UI·시각 디자인을 추가하는 표준 헤더·사이드바·스타일시트를 억제. 세션 타임아웃 시 리디렉트 보조 스크립트 같은 JS 리소스도 억제된다.

> **Note:** When you set applyHtmlTag or applyBodyTag to false, the title attribute of the `<apex:page>` component is ignored.

`<head>` 태그는 container 페이지에 필수는 아니지만 포함하는 것이 좋다. `<head>` 요소에 값을 추가해야 하면 `<head>` 태그를 직접 추가해야 하며, 그 경우 VF가 필요한 값을 당신의 `<head>`에 추가한다. 안 그러면 VF가 필요한 값 추가를 위해 자체 `<head>`를 렌더한다.

`<apex:includeScript>`, `<apex:stylesheet>`, `<apex:image>` 같은 VF 컴포넌트로 페이지에서 정적 리소스를 참조할 수 있다. `<apex:includeScript>`·`<apex:stylesheet>`의 출력은 `<head>` 요소에 추가된다(없으면 VF가 자체 추가). `<apex:image>` 출력은 페이지에 배치한 곳에 렌더된다.

> **Note:** An "empty" Visualforce page renders the minimum amount of HTML markup, but it isn't entirely empty, or free of resources you don't control. JavaScript code that's essential for Visualforce, such as instrumentation, is still added. Visualforce also automatically adds resources required for markup you add. For example, references to Remote Objects or JavaScript remoting resources, if you use them in your code.

---

## 4. Using a Custom Doctype

`docType` 속성(`<apex:page>` 태그)으로 다른 doctype(document type, DTD)을 지정한다. 페이지 시작의 doctype 선언을 변경하며, HTML5 작업·브라우저 호환성 문제 해결에 유용하다.

기본적으로 VF 페이지는 HTML 4.01 Transitional doctype으로 제공된다. 구체적으로 페이지는 다음 doctype 선언으로 시작한다:

```html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
```

`docType` 속성은 document type를 나타내는 문자열을 받는다. 문자열 포맷:

```
<doctype>-<version>[-<variant>]
```

where

- **doctype** — `html` 또는 `xhtml`
- **version** — doctype에 유효한 십진 버전 번호
- **variant** (포함되는 경우):
  - 모든 html document type 및 xhmtl-1.0 [sic — "xhmtl" 오타 원문] document type에 대해 `strict`, `transitional`, 또는 `frameset`, 또는
  - xhmtl-1.1 [sic] document type에 대해 `<blank>` 또는 `basic`

유효하지 않은 document type 지정 시 기본 doctype이 사용된다. 유효한 HTML doctype 정보는 W3C 웹사이트 목록 참조.

> **Note:** In API 28.0 and greater, the scope of how the docType is determined for a page depends on the entire page hierarchy, not just the main page. When pages are added to the main page using the `<apex:include>` tag, if any page in the hierarchy is set to docType="html-5.0", the entire page hierarchy is rendered in that mode.

**Custom Doctype Example** — XHTML 1.0 Strict document type VF 페이지 생성: `<apex:page>` 태그에 `docType` 속성을 쓰고 값 `xhtml-1.0-strict`를 지정한다:

```html
<apex:page docType="xhtml-1.0-strict" title="Strictly XHTML"
showHeader="false" sidebar="false">
<h1>This is Strict XHTML!</h1>
<p>
Remember to close your tags correctly:<br/>
<apex:image url="/img/icon-person.gif" alt="Person icon"/>
</p>
</apex:page>
```

> **Note:** Visualforce doesn't alter markup generated by components to match the doctype, nor the markup for standard Salesforce elements such as the header and sidebar. Salesforce elements are valid for most doctypes and function properly with any doctype, but if you choose a strict doctype and wish to pass an HTML validation test, you might need to suppress or replace the standard Salesforce elements.

---

## 5. Change the MIME type of Your Visualforce Page

`contentType` 속성(`<apex:page>` 태그)으로 다른 포맷을 지정한다. 응답의 HTTP Content-Type 헤더를 페이지 `contentType` 속성 값으로 설정한다.

`contentType` 속성은 MIME(Multipurpose Internet Mail Extension) type를 값으로 받는다, 예: `application/vnd.ms-excel`, `text/csv`, `image/gif`.

> **Note:** Browsers can behave unpredictably if you set an invalid contentType. For information about valid MIME types, see http://www.iana.org/assignments/media-types/.

`contentType` 속성은 어떤 MIME type도 유효한 값으로 받는다. 단 **VF는 PDF로의 콘텐츠 변환만 지원**하며, 이는 `renderAs` 속성 지정으로 가능하다(아래 섹션 7). VF는 다른 파일 포맷을 생성하지 않으며, 단지 HTTP 응답 헤더의 Content-Type 필드를 지정된 MIME type로 설정할 뿐이다. `.xlsx` 같은 일부 파일 포맷은 렌더에 실패할 수 있다.

예: VF 페이지 데이터를 Microsoft Excel 스프레드시트에 표시하려면 `<apex:page>` 태그에 `contentType` 속성을 쓰고 값 `application/vnd.ms-excel`을 지정한다. 다음 페이지는 정적 HTML과 `<apex:repeat>` 컴포넌트로 cases 목록을 작성한다:

```html
<!-- This page must be accessed with an Account Id in the URL. For example:
https://MyDomainName--c.vf.force.com/apex/myPage?id=001D000000JRBet -->
<apex:page standardController="Account" contentType="application/vnd.ms-excel">
<table border="0" >
<caption>Cases</caption>
<tr>
<th>Case Number</th>
<th>Origin</th>
<th>Creator Email</th>
<th>Status</th>
</tr>
<apex:repeat var="cases" value="{!Account.Cases}">
<tr>
<td>{!cases.CaseNumber}</td>
<td>{!cases.Origin}</td>
<td>{!cases.Contact.email}</td>
<td>{!cases.Status}</td>
</tr>
</apex:repeat>
</table>
</apex:page>
```

> **Tip:** If the page doesn't display properly in Excel, try a different MIME type, such as text/csv.

---

## 6. Setting Custom HTML Attributes on Visualforce Components

다수 VF 컴포넌트에 렌더된 HTML로 "pass-through"되는 임의 속성을 추가할 수 있다. jQuery Mobile·AngularJS·Knockout 등 data-* 또는 기타 속성을 프레임워크 함수 활성화 hook으로 쓰는 JS 프레임워크와 VF를 함께 쓸 때 유용하다.

pass-through 속성은 HTML5 기능(placeholder "ghost" text, pattern 클라이언트 측 검증, title 도움말 텍스트 속성)의 사용성 개선에도 쓸 수 있다.

> **Important:** The behavior of HTML5 features is determined by the user's browser, not Visualforce, and varies considerably from browser to browser. If you want to use these features, test early and often on every browser and device you plan to support.

예: `<apex:outputPanel>` 컴포넌트에 pass-through 속성을 추가할 때 속성에 "html-" 접두사를 붙이고 값을 정상적으로 설정한다:

```html
<apex:page showHeader="false" standardStylesheets="false" doctype="html-5.0">
<apex:outputPanel layout="block" html-data-role="panel" html-data-id="menu">
<apex:insert name="menu"/>
</apex:outputPanel>
<apex:outputPanel layout="block" html-data-role="panel" html-data-id="main">
<apex:insert name="main"/>
</apex:outputPanel>
</apex:page>
```

다음 HTML 출력을 생성한다:

```html
<!DOCTYPE HTML>
<html>
<head> ... </head>
<div id="..." data-id="menu" data-role="panel">
<!-- contents of menu -->
</div>
<div id="..." data-id="main" data-role="panel">
<!-- contents of main -->
</div>
</html>
```

"html-"으로 시작하는 모든 속성은 "html-"이 제거된 채 결과 HTML로 pass-through된다.

> **Note:** Pass-through attributes that conflict with built-in attributes for the component generate a compilation error.

**Pass-through 속성을 지원하는 VF 컴포넌트 전수 목록 (PDF 원문에 나열된 컴포넌트 전수):**

```
apex:column, apex:commandButton, apex:commandLink, apex:component, apex:dataTable,
apex:form, apex:iframe, apex:image, apex:includeScript, apex:input, apex:inputCheckbox,
apex:inputField, apex:inputHidden, apex:inputSecret, apex:inputText, apex:inputTextarea,
apex:messages, apex:outputField, apex:outputLabel, apex:outputLink, apex:outputPanel,
apex:outputText, apex:page, apex:pageBlock, apex:pageBlockButtons, apex:pageBlockSection,
apex:pageBlockSectionItem, apex:pageBlockTable, apex:panelBar, apex:panelBarItem,
apex:panelGrid, apex:sectionHeader, apex:selectCheckboxes, apex:selectList,
apex:selectOption, apex:selectOptions, apex:selectRadio, apex:stylesheet, apex:tab,
apex:tabPanel
```

개별 컴포넌트 상세(pass-through 속성이 렌더된 HTML 어디에 추가되는지 등)는 가이드 "Standard Visualforce Component Reference"(p.403) 참조.

pass-through 속성 지원 컴포넌트로 생성할 수 없는 HTML 마크업은 VF 태그를 정적 HTML과 결합한다. 예: jQuery Mobile listview 생성 시 `<apex:repeat>` 태그를 필요한 HTML 태그와 결합한다:

```html
<ul data-role="listview" data-inset="true" data-filter="true">
<apex:repeat value="{! someListOfItems}" var="item">
<li><a href="#">{! item.Name}</a></li>
</apex:repeat>
</ul>
```

> Pass-through 속성은 dynamic Visualforce에서 지원되지 않는다.

---

## 7. Render a Visualforce Page as a PDF File

PDF 렌더링 서비스로 다운로드/인쇄 가능한 PDF 파일을 생성한다. `<apex:page>` 태그 변경으로 페이지를 PDF로 변환한다:

```html
<apex:page renderAs="pdf">
```

PDF로 렌더된 VF 페이지는 브라우저 설정에 따라 브라우저에 표시되거나 다운로드된다. 구체적 동작은 브라우저·버전·사용자 설정에 따르며 VF의 제어 밖이다.

다음 페이지는 account 상세를 포함하고 PDF로 렌더한다:

```html
<apex:page standardController="Account" renderAs="pdf">
<-- Placeholder CSS file, supply your own, with your branding, etc. -->
<apex:stylesheet value="{!URLFOR($Resource.Styles,'pdf.css')}"/>
<h1>Welcome to Universal Samples!</h1>
<p>Thank you, <b><apex:outputText value=" {!Account.Name}"/></b>, for
becoming a new account with Universal Samples.</p>
<p>Your account details are:</p>
<table>
<tr><th>Account Name</th>
<td><apex:outputText value="{!Account.Name}"/></td>
</tr>
<tr><th>Account Rep</th>
<td><apex:outputText value="{!Account.Owner.Name}"/></td>
</tr>
<tr><th>Customer Since</th>
<td><apex:outputText value="{0,date,long}">
<apex:param value="{!Account.CreatedDate}"/>
</apex:outputText></td>
</tr>
</table>
</apex:page>
```

[sic — 위 예제 주석 `<-- ... -->`은 원문 그대로(올바른 HTML 주석 `<!-- -->`이 아님)]

> ⚠️ 시각 자료 (PDF 스크린샷 — 텍스트만): p.73 캡션 "A Visualforce Page Rendered as a PDF File" — PDF로 렌더된 결과 스크린샷 이미지. pdftotext로 추출되지 않아 캡션만 확보됨.

### 7.1 Render a Visualforce Page as PDF from Apex

Apex의 `PageReference.getContentAsPDF()` 메서드로 VF 페이지를 PDF 데이터로 렌더한다. 그 PDF 데이터를 Apex 코드로 이메일 첨부, document, Chatter post 등으로 변환할 수 있다.

다음 예제는 account와 report format을 선택하고 결과 report를 지정된 이메일 주소로 보내는 3-element form이다.

**페이지 마크업 (`controller="PdfEmailerController"`):**

```html
<apex:page title="Account Summary" tabStyle="Account"
controller="PdfEmailerController">
<apex:pageMessages />
<apex:form >
<apex:pageBlock title="Account Summary">
<p>Select a recently modified account to summarize.</p>
<p/>
<apex:pageBlockSection title="Report Format">
<!-- Select account menu -->
<apex:pageBlockSectionItem>
<apex:outputLabel for="selectedAccount" value="Account"/>
<apex:selectList id="selectedAccount" value="{! selectedAccount }"
size="1">
<apex:selectOption /> <!-- blank by default -->
<apex:selectOptions value="{! recentAccounts }" />
</apex:selectList>
</apex:pageBlockSectionItem>
<!-- Select report format menu -->
<apex:pageBlockSectionItem >
<apex:outputLabel for="selectedReport" value="Summary Format"/>
<apex:selectList id="selectedReport" value="{! selectedReport }"
size="1">
<apex:selectOptions value="{! reportFormats }" />
</apex:selectList>
</apex:pageBlockSectionItem>
<!-- Email recipient input field -->
<apex:pageBlockSectionItem >
<apex:outputLabel for="recipientEmail" value="Send To"/>
<apex:inputText value="{! recipientEmail }" size="40"/>
</apex:pageBlockSectionItem>
</apex:pageBlockSection>
<apex:pageBlockButtons location="bottom">
<apex:commandButton action="{! sendReport }" value="Send Account Summary" />
</apex:pageBlockButtons>
</apex:pageBlock>
</apex:form>
</apex:page>
```

이 페이지는 단순 UI이고, Apex에서 PDF 생성 시 모든 동작은 controller로 지정된 `PdfEmailerController` 클래스에 있다.

**PdfEmailerController 클래스 전문:**

```apex
public with sharing class PdfEmailerController {
// Form fields
public Id selectedAccount
{ get; set; }
public String selectedReport { get; set; }
public String recipientEmail { get; set; }

// Account selected on Visualforce page
// Report selected
// Send to this email

// Action method for the [Send Account Summary] button
public PageReference sendReport() {
// NOTE: Abbreviated error checking to keep the code sample short
//
You, of course, would never do this little error checking
if(String.isBlank(this.selectedAccount) || String.isBlank(this.recipientEmail)) {
ApexPages.addMessage(new
ApexPages.Message(ApexPages.Severity.ERROR,
'Errors on the form. Please correct and resubmit.'));
return null; // early out
}
// Get account name for email message strings
Account account = [SELECT Name
FROM Account
WHERE Id = :this.selectedAccount
LIMIT 1];
if(null == account) {
// Got a bogus ID from the form submission
ApexPages.addMessage(new
ApexPages.Message(ApexPages.Severity.ERROR,
'Invalid account. Please correct and resubmit.'));
return null; // early out
}
// Create email
Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
message.setToAddresses(new String[]{ this.recipientEmail });
message.setSubject('Account summary for ' + account.Name);
message.setHtmlBody('Here\'s a summary for the ' + account.Name + ' account.');
// Create PDF
PageReference reportPage =
(PageReference)this.reportPagesIndex.get(this.selectedReport);
reportPage.getParameters().put('id', this.selectedAccount);
Blob reportPdf;
try {
reportPdf = reportPage.getContentAsPDF();
}
catch (Exception e) {
reportPdf = Blob.valueOf(e.getMessage());
}
// Attach PDF to email and send
Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
attachment.setContentType('application/pdf');
attachment.setFileName('AccountSummary-' + account.Name + '.pdf');
attachment.setInline(false);
attachment.setBody(reportPdf);
message.setFileAttachments(new Messaging.EmailFileAttachment[]{ attachment });
Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ message });
ApexPages.addMessage(new
ApexPages.Message(ApexPages.Severity.INFO,
'Email sent with PDF attachment to ' + this.recipientEmail));
return null; // Stay on same page, even on success
}

/***** Form Helpers *****/
// Ten recently-touched accounts, for the Account selection menu
public List<SelectOption> recentAccounts {
get {
if(null == recentAccounts){
recentAccounts = new List<SelectOption>();
for(Account acct : [SELECT Id,Name,LastModifiedDate
FROM Account
ORDER BY LastModifiedDate DESC
LIMIT 10]) {
recentAccounts.add(new SelectOption(acct.Id, acct.Name));
}
}
return recentAccounts;
}
set;
}
// List of available reports, for the Summary Format selection menu
public List<SelectOption> reportFormats {
get {
if(null == reportFormats) {
reportFormats = new List<SelectOption>();
for(Map <String,Object> report : reports) {
reportFormats.add(new SelectOption(
(String)report.get('name'), (String)report.get('label')));
}
}
return reportFormats;
}
set;
}

/***** Private Helpers *****/
// List of report templates to make available
// These are just Visualforce pages you might print to PDF
private Map<String,PageReference> reportPagesIndex;
private List<Map<String,Object>> reports {
get {
if(null == reports) {
reports = new List<Map<String,Object>>();
// Add one report to the list of reports
Map<String,Object> simpleReport = new Map<String,Object>();
simpleReport.put('name', 'simple');
simpleReport.put('label', 'Simple');
simpleReport.put('page',
Page.ReportAccountSimple);
reports.add(simpleReport);
// Add your own, more complete list of PDF templates here
// Index the page names for the reports
this.reportPagesIndex = new Map<String,PageReference>();
for(Map<String,Object> report : reports) {
this.reportPagesIndex.put(
(String)report.get('name'), (PageReference)report.get('page'));
}
}
return reports;
}
set;
}
}
```

**이 controller는 개념적으로 4부분:**

- **시작의 3 public 프로퍼티** — form의 3 input 요소가 제출한 값을 캡처.
- **`sendReport()` action 메서드** — Send Account Summary 버튼 클릭 시 발화.
- **2 public helper 프로퍼티** — 2개 select list input 요소에 쓸 값을 공급.
- **끝의 private helpers** — 가능한 PDF report format 목록을 캡슐화. VF 페이지를 만들고 이 섹션에 항목을 추가해 자체 report를 추가할 수 있다.

**`sendReport()` action 메서드 발화 시 코드 동작:**

- form 필드가 유용한 값을 갖는지 보장하는 기초적 error checking 수행.
  > **Note:** This error checking is inadequate for a form that must survive contact with real people. Perform more complete form validation in your production code.
- 다음, 선택된 account 값으로 그 account 이름을 조회. account 이름은 이메일 메시지에 추가되는 텍스트에 쓰인다. 이 조회는 form 값을 추가 검증하고 실제 account가 선택됐는지 확인하는 기회이기도 하다.
- `Messaging.SingleEmailMessage` 클래스로 이메일 메시지를 조립하고 To·Subject·Body 값을 설정.
- 선택된 report format에 대한 PageReference를 생성한 후 page request parameter를 설정한다. parameter 이름은 "id", 값은 선택된 account의 ID. 이 PageReference는 지정된 account 컨텍스트에서 이 페이지에 접근하는 특정 요청을 나타낸다. `getContentAsPdf()` 호출 시 참조된 VF 페이지가 지정된 account에 접근하고, 페이지는 그 account 상세로 렌더된다.
- 마지막으로 PDF 데이터가 attachment에 추가되고, attachment가 앞서 만든 이메일 메시지에 추가되어 메시지가 전송된다.

`PageReference.getContentAsPdf()` 사용 시 반환 타입은 Blob("binary large object")이다. Apex에서 Blob 데이터 타입은 untyped binary data를 나타낸다. reportPdf 변수가 content type "application/pdf"로 `Messaging.EmailFileAttachment`에 추가될 때 비로소 binary 데이터가 PDF 파일이 된다.

또한 `getContentAsPdf()` 호출은 try/catch 블록으로 감싸진다. 호출 실패 시 catch가 기대했던 PDF 데이터를 예외 메시지 텍스트의 Blob 버전으로 치환한다.

> **Note:** PDF generation can throw a variety of different exceptions. Not all of them can be caught. Your code should be prepared to manage uncatchable exceptions like System.LimitException. For details, see "Exceptions that Can't be Caught" in Exception Statements in the Apex Developer Guide.

VF 페이지를 PDF 데이터로 렌더하는 것은 여러 이유로 **외부 서비스로의 callout으로 의미상 취급**된다. 한 이유는 렌더링 서비스가 외부 서비스가 실패할 수 있는 모든 방식으로 실패할 수 있기 때문이다(예: 페이지가 사용 불가한 외부 리소스 참조). 다른 예는 페이지에 데이터가 너무 많거나(보통 이미지 형태) 렌더 시간이 한도를 초과하는 경우다. 이 때문에 Apex에서 VF 페이지를 PDF 데이터로 렌더할 때 항상 `getContentAsPdf()` 호출을 try/catch 블록으로 감쌀 것.

**완결성을 위한 report template 페이지 (Apex 코드가 PDF 데이터로 렌더):**

```html
<apex:page showHeader="false" standardStylesheets="false"
standardController="Account">
<!-This page must be called with an Account ID in the request, e.g.:
https://MyDomainName--PackageName.vf.force.com/apex/ReportAccountSimple?id=001D000000JRBet
-->
<h1>Account Summary for {! Account.Name }</h1>
<table>
<tr><th>Phone</th> <td><apex:outputText value="{! Account.Phone }"/></td></tr>
<tr><th>Fax</th>
<td><apex:outputText value="{! Account.Fax }"/></td></tr>
<tr><th>Website</th><td><apex:outputText value="{! Account.Website }"/></td></tr>
</table>
<p><apex:outputText value="{! Account.Description }"/></p>
</apex:page>
```

[sic — 위 주석 `<!- ... -->`은 원문 그대로(여는 부분이 `<!-`로 dash 하나)]

> **Note:** Don't use the PageReference.getContent() or PageReference.getContentAsPDF() methods to retrieve the output of a different Visualforce page with the same controller and controller extensions. Doing so can cause unexpected problems that are difficult to debug. Instead, pass the base URL of the destination page.

```apex
new PageReference(Site.getBaseUrl() +
'/apex/VisualforcePageName').getContentAsPdf();
```

### 7.2 Fonts Available When Using Visualforce PDF Rendering

VF PDF 렌더링은 제한된 폰트 세트만 지원한다. PDF 출력이 기대대로 렌더되도록 지원되는 폰트 이름을 쓴다. 기본 폰트는 serif이며, 각 typeface에 대해 첫 번째 font-family 이름이 권장된다.

**Typeface별 font-family 값 (전수, 첫 번째가 권장):**

| Typeface | font-family Values |
|---|---|
| Arial Unicode MS | Arial Unicode MS |
| Helvetica | sans-serif / SansSerif / Dialog |
| Times | serif / Times |
| Courier | monospace / Courier / Monospaced / DialogInput |

> **Note:**
> • These rules apply to server-side PDF rendering. Viewing pages in a web browser can have different results.
> • Text styled with a value not listed here uses Times. For example, if you use the word "Helvetica," it renders as Times, because that's not a supported value for the Helvetica font. We recommend using "sans-serif".
> • Arial Unicode MS is the only multibyte font available. It's the only font that provides support for the extended range of characters of languages that don't use the Latin character set.
> • Arial Unicode MS doesn't support bold or italic font-weight.
> • Web fonts aren't supported when the page is rendered as a PDF file. You can use web fonts in your Visualforce pages when they're rendered normally.

**Testing Font Rendering** — 다음 페이지로 VF PDF 렌더링 엔진의 폰트 렌더링을 테스트할 수 있다 (`controller="SaveToPDF"`, `renderAs="{! renderAs }"`):

```html
<apex:page showHeader="false" standardStylesheets="false"
controller="SaveToPDF" renderAs="{! renderAs }">
<apex:form rendered="{! renderAs != 'PDF' }" style="text-align: right; margin: 10px;">
<div><apex:commandLink action="{! print }" value="Save to PDF"/></div>
<hr/>
</apex:form>
<h1>PDF Fonts Test Page</h1>
<p>This text, which has no styles applied, is styled in the default font for the
Visualforce PDF rendering engine.</p>
<p>The fonts available when rendering a page as a PDF are as follows. The first
listed <code>font-family</code> value for each typeface is the recommended choice.</p>
<table border="1" cellpadding="6">
<tr><th>Font Name</th><th>Style <code>font-family</code> Value to Use (Synonyms)</th></tr>
<tr><td><span style="font-family: Arial Unicode MS; font-size: 14pt; ">Arial
Unicode MS</span></td><td><ul>
<li><span style="font-family: Arial Unicode MS; font-size: 14pt;">Arial Unicode
MS</span></li>
</ul></td></tr>
<tr><td><span style="font-family: Helvetica; font-size: 14pt;">Helvetica</span></td>
<td><ul>
<li><span style="font-family: sans-serif; font-size: 14pt;">sans-serif</span></li>
<li><span style="font-family: SansSerif; font-size: 14pt;">SansSerif</span></li>
<li><span style="font-family: Dialog; font-size: 14pt;">Dialog</span></li>
</ul></td></tr>
<tr><td><span style="font-family: Times; font-size: 14pt;">Times</span></td><td><ul>
<li><span style="font-family: serif; font-size: 14pt;">serif</span></li>
<li><span style="font-family: Times; font-size: 14pt;">Times</span></li>
</ul></td></tr>
<tr><td><span style="font-family: Courier; font-size: 14pt;">Courier</span></td>
<td><ul>
<li><span style="font-family: monospace; font-size: 14pt;">monospace</span></li>
<li><span style="font-family: Courier; font-size: 14pt;">Courier</span></li>
<li><span style="font-family: Monospaced; font-size: 14pt;">Monospaced</span></li>
<li><span style="font-family: DialogInput; font-size: 14pt;">DialogInput</span></li>
</ul></td></tr>
</table>
<p><strong>Notes:</strong>
<ul>
<li>These rules apply to server-side PDF rendering. You might see different results
when viewing this page in a web browser.</li>
<li>Text styled with any value besides those listed above receives the default font
style, Times. This means that, ironically, while Helvetica's synonyms render as
Helvetica, using "Helvetica" for the font-family style renders as Times.
We recommend using "sans-serif".</li>
<li>Arial Unicode MS is the only multibyte font available, providing support for the
extended character sets of languages that don't use the Latin character set.</li>
</ul>
</p>
</apex:page>
```

**SaveToPDF 클래스 전문** — 앞 페이지가 사용하는 controller로, 단순 Save to PDF 기능을 제공한다:

```apex
public with sharing class SaveToPDF {
// Determines whether page is rendered as a PDF or just displayed as HTML
public String renderAs { get; set; }

// Action method to "print" to PDF
public PageReference print() {
renderAs = 'PDF';
return null;
}
}
```

### 7.3 Visualforce PDF Rendering Considerations and Limitations

PDF로 렌더할 의도의 VF 페이지 설계 시 다음 고려사항·제약을 검토한다. 항상 프로덕션 투입 전 페이지의 PDF 버전 포맷·외관을 확인한다.

**VF PDF 렌더링 서비스의 제약 (전수):**

- PDF is the only supported rendering service. (PDF가 유일하게 지원되는 렌더링 서비스)
- The PDF rendering service renders **PDF version 1.4** and **CSS versions up to 2.1**.
- PDF로 VF 페이지 렌더링은 인쇄용으로 설계·최적화된 페이지를 위한 것이다. PDF 렌더링 전용 페이지를 만들 수 있다.
- 유효하지 않은 HTML 마크업은 PDF 렌더링 실패를 야기할 수 있다. 모든 validation 오류가 fatal은 아니며, 여기엔 VF 자체가 생성한 minor HTML 이슈도 포함된다. 페이지 렌더 시 또는 `PageReference.getContentAsPDF()`·`Blob.toPDF()` 호출 시 오류가 발생하면 HTML validator로 페이지를 확인하고, 페이지 HTML에 추가한 마크업의 오류를 수정한다.
- PDF로 렌더된 VF 페이지는 브라우저 설정에 따라 브라우저에 표시되거나 다운로드된다. 구체적 동작은 브라우저·버전·사용자 설정에 따르며 VF 제어 밖이다.
- `PageReference.getContent()`·`PageReference.getContentAsPDF()` 메서드로 동일 controller·controller extension을 쓰는 다른 VF 페이지 출력을 가져오지 말 것. 디버그가 어려운 예기치 못한 문제를 야기할 수 있다. 대신 대상 페이지의 base URL을 전달한다:
  ```apex
  new PageReference(Site.getBaseUrl() +
  '/apex/VisualforcePageName').getContentAsPdf();
  ```
- PDF 렌더링 서비스는 페이지의 마크업·데이터를 렌더하지만, 페이지에 추가된 rich text area 필드 내용에 포함된 포맷은 렌더하지 못할 수 있다.
- break point(공백·dash 등)가 없는 긴 텍스트 줄은 PDF 렌더링 서비스가 wrap할 수 없다. 긴 URL·registry entry 등에서 가장 흔히 발생한다. 이 줄이 페이지보다 넓으면 페이지 콘텐츠 폭을 PDF 페이지 가장자리 너머로 늘려 콘텐츠가 페이지 옆으로 "flow"되어 잘린다.
- 인쇄용으로 쉽게 포맷되지 않는 표준 컴포넌트, input·button 같은 form 요소, JS로 포맷되어야 하는 컴포넌트를 쓰지 말 것.
- PDF rendering doesn't support JavaScript-rendered content. (JS로 렌더된 콘텐츠 미지원)
- PDF rendering isn't supported for pages in the Salesforce mobile app. (Salesforce 모바일 앱 페이지에서 PDF 렌더링 미지원)
- 페이지에 쓰는 폰트는 VF PDF 렌더링 서비스에서 사용 가능해야 한다. Web fonts aren't supported. (위 7.2 참조)
- PDF 파일이 페이지의 모든 텍스트(특히 일본어나 악센트 있는 국제 문자 같은 multibyte 문자)를 표시하지 못하면, CSS를 조정해 그것을 지원하는 폰트를 쓴다. 예:
  ```html
  <apex:page showHeader="false" applyBodyTag="false" renderAs="pdf">
  <head>
  <style>
  body { font-family: 'Arial Unicode MS'; }
  </style>
  </head>
  <body>

  これはサンプルページです。<br/>
  This is a sample page: API version 28.0
  </body>
  </apex:page>
  ```
  "Arial Unicode MS" is the only font supported for extended character sets that include multibyte characters.
- inline CSS 스타일 사용 시 API 버전을 28.0 이상으로 설정한다. 또한 `<apex:page applyBodyTag="false">`로 설정하고, 위 예제처럼 정적·유효한 `<head>`·`<body>` 태그를 페이지에 추가한다.
- **The maximum response size when creating a PDF file must be less than 15 MB before being rendered as a PDF file.** This limit is the standard limit for all Visualforce requests. (PDF 생성 시 렌더 전 최대 응답 크기는 15 MB 미만 — 모든 VF 요청의 표준 한도)
- **The maximum file size for a generated PDF file is 60 MB.** (생성된 PDF 파일 최대 크기 60 MB)
- **The maximum total size of all images included in a generated PDF is 30 MB.** (생성된 PDF에 포함된 모든 이미지의 최대 총 크기 30 MB)
- PDF rendering doesn't support images encoded in the data: URI scheme format. (data: URI scheme 포맷 인코딩 이미지 미지원)
- PDF rendering doesn't support WebP images or SVG markup. (WebP 이미지·SVG 마크업 미지원)
- PDF rendering doesn't support multipage TIFF files. (multipage TIFF 파일 미지원)
- 다음 컴포넌트는 PDF로 렌더 시 double-byte 폰트를 지원하지 않는다. These components aren't recommended for use in pages rendered as PDF:
  - `<apex:pageBlock>`
  - `<apex:sectionHeader>`
- `<apex:dataTable>`이나 `<apex:pageBlockTable>`에 렌더되는 `<apex:column>` 컴포넌트가 하나도 없으면 PDF 렌더링이 실패한다. 해결책: 자식 `<apex:column>` 컴포넌트가 하나도 렌더되지 않으면 테이블 컴포넌트의 `rendered` 속성을 false로 설정한다.

> **숫자 한도 요약 (Pattern B 검증 — 세 metric 각각 다른 값):**
> | metric | 값 | 시점/대상 |
> |---|---|---|
> | 최대 응답 크기 | **15 MB 미만** | PDF로 렌더되기 **전**(모든 VF 요청 표준 한도) |
> | 생성된 PDF 파일 최대 크기 | **60 MB** | 생성된 PDF 파일 |
> | PDF 내 모든 이미지 총합 최대 크기 | **30 MB** | 생성된 PDF에 포함된 이미지 합계 |

### 7.4 Component Behavior When Rendered as PDF

VF 컴포넌트가 PDF로 변환될 때 어떻게 동작하는지 이해하는 것이 잘 렌더되는 페이지 작성에 필수다.

VF PDF 렌더링 서비스는 페이지가 명시적으로 제공한 정적 HTML과 기본 CSS를 렌더한다. 원칙적으로 다음 컴포넌트를 쓰지 말 것:

- 동작 수행에 JS에 의존하는 것
- Salesforce 스타일시트에 의존하는 것
- 페이지 자체나 정적 리소스에서 사용 불가한 에셋(스타일시트·그래픽)을 쓰는 것

VF 페이지가 이 카테고리 중 하나에 해당하는지 확인하려면, 페이지 아무 곳이나 우클릭하여 HTML 소스를 본다. JavaScript(.js)를 참조하는 `<script>` 태그나 스타일시트(.css)를 참조하는 `<link>` 태그가 보이면 생성된 PDF 파일이 기대대로 표시되는지 확인한다.

**Components That Are Safe When Rendering as PDF (PDF-안전 컴포넌트 전수):**

- `<apex:composition>` (페이지가 PDF-safe 컴포넌트를 포함하는 한)
- `<apex:dataList>`
- `<apex:define>`
- `<apex:facet>`
- `<apex:include>` (페이지가 PDF-safe 컴포넌트를 포함하는 한)
- `<apex:insert>`
- `<apex:image>`
- `<apex:outputLabel>`
- `<apex:outputLink>`
- `<apex:outputPanel>`
- `<apex:outputText>`
- `<apex:page>`
- `<apex:panelGrid>`
- `<apex:panelGroup>`
- `<apex:param>`
- `<apex:repeat>`
- `<apex:stylesheet>` (URL이 Salesforce 스타일시트를 직접 참조하지 않는 한)
- `<apex:variable>`

**Components to Use with Caution When Rendering as PDF (주의 컴포넌트 전수):**

- `<apex:attribute>`
- `<apex:column>`
- `<apex:component>`
- `<apex:componentBody>`
- `<apex:dataTable>`

**Components That Are Unsafe to Use When Rendering as PDF (비-안전 컴포넌트 전수):**

```
apex:actionFunction, apex:actionPoller, apex:actionRegion, apex:actionStatus,
apex:actionSupport, apex:commandButton, apex:commandLink, apex:detail,
apex:enhancedList, apex:flash, apex:form, apex:iframe, apex:includeScript,
apex:inputCheckbox, apex:inputField, apex:inputFile, apex:inputHidden, apex:inputSecret,
apex:inputText, apex:inputTextarea, apex:listViews, apex:message, apex:messages,
apex:outputField, apex:pageBlock, apex:pageBlockButtons, apex:pageBlockSection,
apex:pageBlockSectionItem, apex:pageBlockTable, apex:pageMessage, apex:pageMessages,
apex:panelBar, apex:panelBarItem, apex:relatedList, apex:scontrol, apex:sectionHeader,
apex:selectCheckboxes, apex:selectList, apex:selectOption, apex:selectOptions,
apex:selectRadio, apex:tab, apex:tabPanel, apex:toolbar, apex:toolbarGroup
```

---

## 관련 노트

- [[Case Feed Visualforce 커스터마이즈]] — Publisher·Case Feed VF 컴포넌트 속성·Apex 액션 커스터마이즈
- [[Governor Limits]] — Apex callout·heap·response size 등 한도(PDF 렌더링이 callout으로 취급되는 맥락)
- [[Visualforce 개요 — 도구·퀵스타트]] — Visualforce 페이지 기초·태그 언어(같은 가이드 Ch1–3)
- [[표준 컨트롤러·표준 리스트 컨트롤러]] — Visualforce 표준/리스트 컨트롤러(같은 가이드 Ch5+)
- [[커스텀 컨트롤러·컨트롤러 확장]] — Visualforce 커스텀 컨트롤러·확장(같은 가이드 Ch5+)
