---
tags: [lwc, lwr, experience-cloud, tag-manager, experience-tag-manager, google-tag-manager, data-cloud, experience-data-layer, experience-interaction, consent, web-events]
source: exp_cloud_lwr.pdf (LWR Sites for Experience Cloud, v66.0 Spring '26, Tier 2) — Ch7 Manage Data in LWR Sites (print p.80-101) + Ch6 Examples: Use Google Tag Manager (print p.77-79)
official_doc: https://developer.salesforce.com/docs/atlas.en-us.exp_cloud_lwr.meta/exp_cloud_lwr/
created: 2026-06-20
aliases: [Experience Tag Manager, Google Tag Manager, GTM, experience_interaction, Experience Data Layer, set-consent, Website Engagement DMO, x-oasis-script, 익스피리언스 태그 매니저, 구글 태그 매니저, LWR 데이터 관리, 인터랙션 이벤트, 동의 옵트인]
---

# LWR Tag Manager 데이터 관리

> LWR 사이트의 방문자 인터랙션을 캡처해 Data Cloud로 보내는 두 경로 — Salesforce **네이티브 Experience Tag Manager**(`experience_interaction` 이벤트 → Website Engagement DMO)와 **3rd-party Google Tag Manager**(`<x-oasis-script>` → dataLayer). 이름은 비슷하지만 완전히 다른 기능. (`exp_cloud_lwr.pdf` Ch7 + Ch6)

> 📍 허브: [[LWR Sites (Experience Cloud)]] · LWR 일반 동작은 [[LWR 동작·캐싱·제약]] 참조. (PDF 순서는 GTM=Ch6, 네이티브=Ch7이나 이 노트는 네이티브를 먼저 배치)

---

## 개요 — LWR 데이터를 외부로 보내는 두 경로

LWR 사이트의 방문자 인게이지먼트를 외부 앱(특히 Data Cloud)으로 보낼 수 있다. PDF Ch7 인트로:

> "Use this guide to understand how visitor engagement from your LWR sites can be sent to Data Cloud and how you can best tailor our tools to your specific needs. Data is a powerful tool in the world of site management and analytics. Understanding how your users interact with your sites helps you build detailed user profiles, create enhanced analytics, and personalize your site for the best user experience."

여기서 핵심이 되는 도구가 "Tag Manager"인데, 이름이 같지만 **완전히 다른 두 가지**가 존재한다. 이 노트는 둘을 분명히 구분해 다룬다.

- **A. 네이티브 Experience Tag Manager** — Salesforce가 제공. LWR 사이트를 Data Cloud에 연결하면 자동 설치되는 JavaScript 라이브러리. `experience_interaction` CustomEvent를 캡처해 site data와 결합, web event를 만들어 Data Cloud / Google Analytics 등으로 전송.
- **B. Google Tag Manager (GTM)** — Google의 3rd-party 제품. Salesforce 네이티브 Tag Manager와 전혀 별개. `<x-oasis-script>` privileged script tag로 shadow DOM에 접근해 `dataLayer`에 push하고, GTM custom HTML tag로 트리거를 설정.

> ⚠️ Ch8 "Improve Performance with Experience Delivery"는 이 노트 범위 밖이다(허브 [[LWR Sites (Experience Cloud)]]가 커버). Data Cloud DMO 스키마(Website Engagement DMO·Product Browse Engagement DMO)의 오브젝트 정의는 [[Data Cloud Objects]], `<x-oasis-script>` privileged script tag의 보안 메커니즘 상세는 [[Lightning Web Security (LWS)]]로 위임한다.

---

## 두 "Tag Manager" 구분

이름에 둘 다 "Tag Manager"가 들어가지만 **완전히 다른 기능**이다. 절대 혼동하지 않도록 아래 표로 정리한다.

| 구분 | A. 네이티브 Experience Tag Manager | B. Google Tag Manager (GTM) |
|---|---|---|
| 제공 주체 | Salesforce (Experience Cloud + Data Cloud 통합) | Google (3rd-party 라이브러리) |
| 설치 | Data Cloud 연결 시 **자동 설치** | **수동** — Head Markup에 GTM 스크립트 + custom HTML tag 직접 추가 |
| 트리거 메커니즘 | `experience_interaction` CustomEvent (`dispatchEvent`) | `<x-oasis-script>` privileged script tag + `dataLayer.push(...)` |
| 목적지 | Data Cloud **Website Engagement DMO** (type=product 시 Product Browse Engagement DMO) | GTM 컨테이너 (이후 GTM 트리거로 라우팅) |
| shadow DOM 접근 | Lightning web component / 페이지 이벤트를 직접 캡처 | `<x-oasis-script>`로 shadow DOM 내부 요소 접근 |
| 사전 설정 | Consent Opt-In 기본값 설정 (Relaxed CSP) | Relaxed CSP 전환 + Trusted Sites for Scripts에 스크립트 URL 추가 |
| 챕터 | Ch7 (print p.80–101) | Ch6 (print p.77–79) |

---

## A. 네이티브 Experience Tag Manager (→ Data Cloud)

### Experience Data Layer 란

data layer는 사용자가 웹사이트와 상호작용할 때 캡처되는 모든 정보를 담는 곳이며, 웹사이트 HTML에 JSON으로 임베드된다. PDF 원문:

> "A data layer contains all the information captured when a user interacts with your website. The data layer is embedded as JSON in the HTML of your website. It provides a central location for user data so it can be sent to other applications and processed. The Experience Data Layer contains information about the page, the user, and behavioral data from your Experience Cloud sites. All of that data provides valuable information about how your customers interact with your site and can be sent along to other apps like Data Cloud and Google Analytics, or power products like Marketing Cloud."

> Note: "Use the Experience Data Layer Object Lightning web component to populate the data layer." (data layer를 채우려면 Experience Data Layer Object LWC를 사용한다.)

아래는 PDF에 실린 Experience Data Layer 임베드 JSON 예시다. `data-provider-type`(site / page / user / catalog)별로 `<experience-data-layer-object>`가 JSON을 담는다.

```html
// exp_cloud_lwr.pdf 원문 발췌 — 동작 코드 아님
<html>
<head>
</head>
<body>
<web-runtime-app>
<experience-data-layer-object>
<script type="application/json"
data-provider-type="site">
{
"siteId": "site-12345"
}
</script>
</experience-data-layer-object>
<experience-data-layer-object>
<script type="application/json"
data-provider-type="page">
{
"url":
"https://www.datacloud.salesforce.com",
"urlReferrer":
"https://www.root.salesforce.com"
}
</script>
</experience-data-layer-object>
<experience-data-layer-object>
<script type="application/json"
data-provider-type="user">
{
"guestUuid": "guest-uuid-12345",
"crmId": "user-id-12345"
}
</script>
</experience-data-layer-object>
<commerce-product-list-component>
<commerce-product-list-data-provider>
<experience-data-layer-object>
<script type="application/json"
data-provider-type="catalog">
[
{
"id": "product-id-12345",
"type": "Product",
"attributes": {
"color": "blue"
}
},
{
"id": "product-id-54321",
"type": "Product",
"attributes": {
"color": "orange"
}
}
]
</script>
</experience-data-layer-object>
</commerce-product-list-data-provider>
<div>
<p>Product-1</p>
</div>
<commerce-individual-product-component>
</commerce-individual-product-component>
<div>
<p>Product-2</p>
</div>
<commerce-individual-product-component>
</commerce-individual-product-component>
</commerce-product-list-component>
</web-runtime-app>
</body>
</html>
```

> Data Cloud가 처음이면 PDF는 Data Cloud Help 탐색을 권한다. Experience Cloud–Data Cloud 통합은 필요한 설정 대부분을 자동 수행하나, 시작 전 Salesforce Help의 "Connect Data Cloud to Your LWR Sites" 작업을 먼저 수행해야 한다.

### Data Cloud 연결 & 데이터 스트림 확인

Experience Cloud 사이트를 Data Cloud에 연결하면, 셋업 중 선택한 data space에 connection과 data stream이 자동 설치된다. Experience Cloud connector의 스트림이 active인지 확인한다.

> "If you connect your Experience Cloud site to Data Cloud, the connection and data streams are automatically installed in the data space that you selected during setup. Confirm that streams from your Experience Cloud connector are active. Before completing these steps, connect your Experience Cloud site to Data Cloud."

확인 절차:

1. Data Cloud Setup에서 **External Integrations** 하위 **Websites & Mobile Apps** 선택.
2. **EC_Engagement_Connector**가 목록에 있는지 확인하고 Data Cloud Setup을 나간다.
3. Data Cloud에서 **Data Streams** 탭으로 가 list view를 **All Data Streams**로 변경. EC_Engagement_Connector의 스트림이 active인지 확인한다. 이 스트림 이름은 접두사 **EC_Engagement_Connector-** 로 시작한다.

> Note: "By default, EC_Engagement_Connector data lake objects (DLO) have a filter applied on siteId. If you have multiple LWR sites with Data Cloud integrations, this filter makes the DLOs associated with each site visible only in the data space that you selected during setup."

이후 "To start capturing events to send to Data Cloud, configure your user consent options."(이벤트 캡처를 시작하려면 user consent 옵션을 구성한다 → 아래 Consent Opt-In 절.)

**EDITIONS:** Available in Salesforce Classic (not available in all orgs) and Lightning Experience / Enterprise, Performance, Unlimited, and Developer Editions / Applies to: LWR sites.

**USER PERMISSIONS (데이터 스트림 생성·편집):** 다음 permission set 중 하나 — Data Cloud Admin / Data Cloud Marketing Admin / Data Cloud Data Aware Specialist.

**SEE ALSO (Salesforce Help, 외부 링크):** Connect Experience Cloud to Data Cloud / Add Filters to a Data Lake Object / Manage Data Spaces.

> DMO·DLO 등 Data Cloud 오브젝트 정의는 [[Data Cloud Objects]] 참조.

### 인게이지먼트 데이터 캡처 개요

Experience Tag Manager는 Experience Cloud data layer에서 사용자 인터랙션 이벤트를 캡처해 site data와 결합, web event를 만드는 JavaScript 라이브러리다.

> "Experience Tag Manager is a JavaScript library that captures user-interaction events from the Experience Cloud data layer and combines them with site data to generate web events. These events are sent to other applications, such as Data Cloud or Google Analytics. Tag Manager is installed automatically when you connect your enhanced LWR sites to Data Cloud with the built-in Data Cloud integration. You can then use information you gather with Tag Manager to build behavior profiles for web visitors, audience segmentation, site personalization, or Salesforce integrations.
> Experience interaction events are triggered when a user performs an action on a site page. Examples include scrolling, clicking, and viewing. Events can take place on Lightning web components or the page itself. When they occur, they're sent to the event queue, which notifies the Experience Tag Manager to process the events."

> Important: "In the Summer '24 release, when Data Cloud and Google Analytics integrations are enabled in an LWR site, the transfer of site metadata to a different org via the DigitalExperienceBundle Metadata API encounters component failures. For more information, see DigitalExperienceBundle has component failures with Data Cloud and Google Analtyics integrations."
>
> 주: 위 Important 인용문의 `Analtyics`는 PDF 원문 그대로(오타 보존). 임의 수정 아님.

### Consent Opt-In 기본값 설정

이벤트 캡처를 시작하려면 user consent 옵션을 구성해야 한다. 기본적으로 Tag Manager는 **사용자가 명시적으로 opt-in 하기 전까지 목적지로 데이터를 보내지 않는다.**

> "To start capturing events to send to Data Cloud, configure your user consent options. By default, Tag Manager doesn't send data to its destination until the user explicitly opts in. Choose how to present consent options to the site visitor and whether to update the default behavior.
> Not all website visitors and customers consent to cookie tracking. With Experience Tag Manager, you can configure whether customers opt in or opt out of tracking. After a user provides consent, and the consent info is passed to your site, Experience Cloud respects the consent preference by sending or not sending data. Any engagement event triggered before a user provides consent is ignored. We recommend using a consent management provider (CMP) application to help manage your consent options.
> Tag Manager listens for a specific interaction event called **set-consent** to capture user consent. Consent is stored as long as the session is active and the page isn't reloaded. Every time the page is refreshed the consent value must be sent through the set-consent event."

설정 절차:

1. Setup → Quick Find에 `Digital Experiences` 입력 → **Digital Experiences** 클릭 → **Settings** 클릭.
2. **Security & Privacy** 선택.
3. Security Level 하위에서 **Relaxed CSP: Permit Access to Inline Scripts and Allowed Hosts** 선택.
4. 프롬프트가 뜨면 변경을 허용.
5. Settings로 돌아가 **Advanced** 선택.
6. **Edit Head Markup** 클릭 후 기존 코드에 아래 스크립트를 추가.

```html
// exp_cloud_lwr.pdf 원문 발췌 — 동작 코드 아님
<script>
document.dispatchEvent(
new CustomEvent('experience_interaction', {
bubbles: true,
composed: true,
detail: {
name: 'set-consent',
value: true,
},
})
);
</script>
```

7. 변경을 저장하고 사이트를 publish.

CMP를 사용하면 위 절차를 따르되 아래 스크립트를 쓰고 `value` 속성에 CMP의 API를 넣는다.

```html
// exp_cloud_lwr.pdf 원문 발췌 — 동작 코드 아님
<script>
document.dispatchEvent(
new CustomEvent('experience_interaction', {
bubbles: true,
composed: true,
detail: {
name: 'set-consent'
value: CMP.getConsent()
},
})
);
</script>
```

> 주: 위 CMP 예제의 `name: 'set-consent'` 뒤에 콤마가 없는 것은 PDF 원문 그대로(오타 보존). 임의 수정 아님.

user consent를 제거하려면 value 없이 interaction event를 트리거한다.

```html
// exp_cloud_lwr.pdf 원문 발췌 — 동작 코드 아님
<script>
document.dispatchEvent(
new CustomEvent('experience_interaction', {
bubbles: true,
composed: true,
detail: {
name: 'set-consent'
},
})
);
</script>
```

**USER PERMISSIONS:** Experience Cloud 사이트 생성에는 Create and Set Up Experiences AND View Setup and Configuration. 커스터마이즈·publish에는 사이트 멤버십과 함께 Create and Set Up Experiences 또는 해당 사이트의 experience admin/publisher(/builder) 권한 중 하나. (**SEE ALSO:** Consent Interactions → B 영역의 [Consent Interactions](#consent-interactions))

### 인터랙션 이벤트 커스터마이즈

Data Cloud 통합에는 기본으로 켜져 있고 Website Engagement DMO에 매핑된 인터랙션 이벤트 세트가 함께 온다. 인터랙션은 **전부 매핑되거나 전혀 매핑되지 않는다**(중간 없음). 다만 이벤트의 named identifier는 변경할 수 있다.

> "Your Data Cloud integration comes with a set of interaction events that are turned on and mapped to the Website Engagement DMO by default. Interactions are either all mapped, or not mapped at all, but you can update event names to customize your integration. An interaction event has a named identifier, required values, and tracked values that you define.
> The events that you capture can't be changed, but you can update the named identifier to personalize your integration. For example, if you want to capture when your user clicks on a menu, you can change the interaction name to **menu-click**, instead of the more general **button-click** event.
> If you want to change an existing name, create an event based on our Tag Manager Event Reference."

절차:

1. Setup → Quick Find에 `Digital Experiences` 입력 → **Digital Experiences** → **Settings**.
2. **Advanced** 선택.
3. **Edit Head Markup** 클릭 후 편집하려는 이벤트의 스크립트를 추가.
4. 변경을 저장하고 사이트를 publish.

> Note: "All anchor and button element clicks are captured as events, unless they're located inside a Shadow DOM element. For example, if an element is on certain custom lightning components, clicks aren't tracked. Events within Shadow DOM elements require custom tracking by the custom element. Anchor and button element clicks aren't supported in . For more information, see Activity Tracking for Marketing Cloud Growth Landing Pages."
>
> 주: 위 Note의 `aren't supported in .`(in 뒤 대상이 비어 있고 공백이 그대로 남음)은 PDF 원문 그대로(누락·artifact 보존). 임의 수정 아님.

### Event Reference 공통 패턴 (experience_interaction dispatchEvent — 1회만 설명)

아래 B영역 모든 인터랙션(consent 제외)은 동일한 발송 패턴을 따른다. **이 절에서 1회만 설명하고, B영역 각 이벤트에서는 코드 예제만 싣고 패턴을 반복 설명하지 않는다.**

- 모든 이벤트는 `experience_interaction`라는 `CustomEvent`의 `detail`에 페이로드를 담아 발송한다.
- 발송 호출은 `event.target.dispatchEvent(...)`다. (단 **consent 계열은 `document.dispatchEvent(...)`** — A의 Consent Opt-In 절 참조.)
- `CustomEvent` 옵션은 항상 `bubbles: true`, `composed: true`(shadow DOM 경계를 넘어 전파).
- `detail.name`이 인터랙션의 named identifier(예: `cart-add`, `button-click`)다.

PDF의 Event Reference 인트로:

> "This guide includes the event specifications for Experience Tag Manager. Use the examples and reference to understand the structure of Experience Cloud interaction events that are mapped to the Website Engagement DMO in Data Cloud."

---

## B. Tag Manager Event Reference (9개 인터랙션)

아래 9개 인터랙션은 모두 [Event Reference 공통 패턴](#event-reference-공통-패턴-experience_interaction-dispatchevent--1회만-설명)을 따른다(코드만 싣고 발송 패턴 반복 설명 생략).

### Cart Interactions

A cart interaction occurs when a customer interacts with their cart or checkout.

#### Interaction Name

| Interaction Name | Description |
|---|---|
| cart-add | Captures an event for the addition of an item to a cart. |
| cart-remove | Captures an event for the removal of an item from a cart. |
| cart-replace | Captures an event for the replacement of all items in a cart at the same time. |
| cart-update | Captures events for updates to a cart. |
| cart-view | Captures an event for when a user views their cart. Available in package version 1.3 and later |
| checkout-apply-coupon | Captures an event that occurs when a user applies a coupon during checkout. Available in package version 1.3 and later. |
| checkout-begin | Captures an event for when a checkout begins. Available in package version 1.3 and later. |
| checkout-billing-address | Captures an event that occurs when a user enters their billing address during checkout. Available in package version 1.3 and later. |
| checkout-contact-info | Captures an event that occurs when a user enters their contact info during checkout. Available in package version 1.3 and later. |
| checkout-payment | Captures an event that occurs when a user makes a payment during checkout. Available in package version 1.3 and later. |
| checkout-review | Captures an event that occurs when a user selects review checkout before submitting their order. Available in package version 1.3 and later. |
| checkout-shipping-address | Captures an event that occurs when a user enters their shipping address during checkout. Available in package version 1.3 and later. |
| checkout-shipping-options | Captures an event that occurs when a user chooses a shipping option during checkout. Available in package version 1.3 and later. |
| checkout-submit | Captures an event that occurs when a user submits their order at the end of the checkout process. Available in package version 1.3 and later. |
| checkout-user-register | Captures an event that occurs when a user registers during checkout. Available in package version 1.3 and later. |
| order-accepted | Captures an event that occurs when an order is accepted and ready for fulfillment. Available in package version 1.3 and later. |

> 주: `cart-view`의 "later" 뒤에 마침표가 없는 것은 PDF 원문 그대로(다른 행은 마침표 있음). 임의 수정 아님.

#### Fields

| Field | Type | Description |
|---|---|---|
| attributes | object | A dictionary of values that you supply. |
| id | string | Required. A unique ID representing the Cart object. |
| lineItems | Line Item Data on page 97 | Required. A single Line Item Data value. |
| name | string | Required. The event name. |

예제 (Add / Remove / Update):

```javascript
// exp_cloud_lwr.pdf 원문 발췌 — 동작 코드 아님
event.target.dispatchEvent(
new CustomEvent('experience_interaction', {
bubbles: true,
composed: true,
detail: {
name: 'cart-add',
cart: {
id: 'cart-12345',
lineItems: {
id: 'line-item-12345',
catalogObject: {
id: 'catalog-id-12345678',
type: 'Product'
},
attributes: {
quantity: 12,
price: 2.5,
imageUrl: 'https://commerce.salesforce.com/blueshirt.jpg',
name: 'blue-shirt'
},
},
attributes: {
currency: '$',
name: 'my-personal-cart',
},
},
},
})
);
```

```javascript
// exp_cloud_lwr.pdf 원문 발췌 — 동작 코드 아님
event.target.dispatchEvent(
new CustomEvent('experience_interaction', {
bubbles: true,
composed: true,
detail: {
name: 'cart-remove',
cart: {
id: 'cart-12345',
lineItems: {
id: 'line-item-23112',
},
attributes: {
name: 'my-personal-cart'
},
},
},
})
);
```

```javascript
// exp_cloud_lwr.pdf 원문 발췌 — 동작 코드 아님
event.target.dispatchEvent(
new CustomEvent('experience_interaction', {
bubbles: true,
composed: true,
detail: {
name: 'cart-update',
cart: {
id: 'cart-61221',
lineItems: {
id: 'line-item-11111',
attributes: {
quantity: 2,
},
},
attributes: {
name: 'my-updated-cart'
},
},
},
})
);
```

### Catalog Interactions

A catalog interaction occurs when a customer interacts with various tracking items. For example, catalog items could include a product or a blog post.

#### Interaction Name

| Interaction Name | Description |
|---|---|
| catalog-object-click | Captures the event of a user clicking a catalog object. |
| catalog-object-impression | Captures the event of a user viewing search results or category products. Available in package version 1.3 and later. |
| catalog-object-view-start | Captures the start point of a user viewing a catalog object. |
| catalog-object-view-stop | Captures the stop point of a user viewing a catalog object. |
| form-submit | Captures the event of a user submitting a form. |

#### Fields

| Field | Type | Description |
|---|---|---|
| attributes | object | A dictionary of values that you supply. |
| id | string | Required. A unique ID representing the Catalog object. |
| lineItems | Line Item Data on page 97 | Required. A single-Line Item Data value. |
| name | string | Required. The event name. |
| type | string | Required. A type name representing the catalog object. If type is set to product, the interaction is sent to the Product Browse Engagement DMO. If type is set to anything else, the interaction is sent to the Website Engagement DMO. |

> 주: `lineItems`의 Description "A single-Line Item Data value."에서 `single-Line`(하이픈)은 PDF 원문 그대로다. Cart/Wish-List는 "A single Line Item Data value."(공백)로 표기가 다르다. 임의 수정 아님.

예제 (View Start / View Stop / Click):

```javascript
// exp_cloud_lwr.pdf 원문 발췌 — 동작 코드 아님
event.target.dispatchEvent(
new CustomEvent('experience_interaction', {
bubbles: true,
composed: true,
detail: {
name: 'catalog-object-view-start',
catalogObject: {
id: 'product-12345678',
lineItems: {
id: 'line-item-12345',
catalogObject: {
.
id: 'catalog-id-12345678',
type: 'Product'
},
attributes: {
quantity: 12,
price: 2.5,
name: 'blue-shirt'
},
},
},
},
})
);
```

> 주: `catalogObject` 블록 안의 외톨이 `.`(점 한 줄)은 PDF 원문 artifact 그대로다. fabricate 아님.

```javascript
// exp_cloud_lwr.pdf 원문 발췌 — 동작 코드 아님
event.target.dispatchEvent(
new CustomEvent('experience_interaction', {
bubbles: true,
composed: true,
detail: {
name: 'catalog-object-view-stop,
catalogObject: {
id: 'product-12345678',
lineItems: {
id: 'line-item-12345',
catalogObject: {
.
id: 'catalog-id-12345678',
type: 'Product'
},
attributes: {
quantity: 12,
price: 2.5,
name: 'blue-shirt'
},
},
},
},
})
);
```

> 주: `name: 'catalog-object-view-stop,`의 닫는 따옴표 누락, 그리고 `catalogObject` 안 외톨이 `.`은 둘 다 PDF 원문 오타·artifact 그대로다. 임의 수정 아님.

```javascript
// exp_cloud_lwr.pdf 원문 발췌 — 동작 코드 아님
event.target.dispatchEvent(
new CustomEvent('experience_interaction', {
bubbles: true,
composed: true,
detail: {
name: 'catalog-object-click',
catalogObject: {
id: 'product-12345678',
lineItems: {
id: 'line-item-12345',
catalogObject: {
.
id: 'catalog-id-12345678',
type: 'Product'
},
attributes: {
quantity: 12,
price: 2.5,
name: 'blue-shirt'
},
},
},
},
})
);
```

> 주: Click 예제의 외톨이 `.`도 PDF 원문 artifact 그대로다. 임의 수정 아님.

### Consent Interactions

Consent interactions capture whether a user opts into or out of tracking cookies.

> 발송 패턴 차이: consent 계열은 `event.target.dispatchEvent`가 아니라 **`document.dispatchEvent`**로 보낸다(A의 [Consent Opt-In 기본값 설정](#consent-opt-in-기본값-설정) 참조). 아래 Reference 예제는 PDF Event Reference의 표기(`event.target.dispatchEvent`)를 그대로 옮긴다.

#### Interaction Name

| Interaction Name | Description |
|---|---|
| set-consent | Captures the user-consent value. |

#### Fields

| Field | Type | Description |
|---|---|---|
| name | string | Required. The event name. |
| value | string | Indicates whether the user opts in to cookie tracking (true) or opts out (false). |

예제 (Opt-in / Opt-out):

```javascript
// exp_cloud_lwr.pdf 원문 발췌 — 동작 코드 아님
event.target.dispatchEvent(
new CustomEvent('experience_interaction', {
bubbles: true,
composed: true,
detail: {
name: 'set-consent',
value: true,
},
})
);
```

```javascript
// exp_cloud_lwr.pdf 원문 발췌 — 동작 코드 아님
event.target.dispatchEvent(
new CustomEvent('experience_interaction', {
bubbles: true,
composed: true,
detail: {
name: 'set-consent',
value: false,
},
})
);
```

### Email Interactions

An email interaction occurs when a user updates or adds an email in your site.

#### Interaction Name

| Interaction Name | Description |
|---|---|
| email-update | Captures the email of the site visitor. |

#### Fields

| Field | Type | Description |
|---|---|---|
| email | string | The email of the site visitor. |
| name | string | Required. The event name. |

예제:

```javascript
// exp_cloud_lwr.pdf 원문 발췌 — 동작 코드 아님
event.target.dispatchEvent(
new CustomEvent('experience_interaction', {
bubbles: true,
composed: true,
detail: {
name: 'email-update',
email: 'genie@example.com'
},
})
);
```

### Engagement Interactions

An engagement interaction occurs when a customer engages with your site through buttons, links, or other page elements.

#### Interaction Name

| Interaction Name | Description |
|---|---|
| anchor-click | Captures any anchor click. |
| button-click | Captures any button click. |
| page-scroll-to-bottom | Captures when a user scrolls to the bottom of the page. |
| page-view | Captures the event when a user views a page. |

#### Fields

| Field | Type | Description |
|---|---|---|
| attributes | object | A dictionary of values that you supply. |
| linkhref | string | The web address of the link to capture. |
| name | string | Required. The event name. |

> 주: Fields 표는 필드명을 소문자 `linkhref`로 표기하나, 아래 예제 코드는 `linkHref`(대문자 H)로 표기한다. 둘 다 PDF 원문 그대로(불일치 보존). 임의 수정 아님.

예제 (Anchor Click / Button Click):

```javascript
// exp_cloud_lwr.pdf 원문 발췌 — 동작 코드 아님
event.target.dispatchEvent(
new CustomEvent('experience_interaction', {
bubbles: true,
composed: true,
detail: {
name: 'anchor-click',
linkHref: 'https://expectedUrl'
attributes: {
buttonLabel: 'Click here'
},
},
})
);
```

> 주: `linkHref: 'https://expectedUrl'` 뒤 콤마 누락은 PDF 원문 오타 그대로다. 임의 수정 아님.

```javascript
// exp_cloud_lwr.pdf 원문 발췌 — 동작 코드 아님
event.target.dispatchEvent(
new CustomEvent('experience_interaction', {
bubbles: true,
composed: true,
detail: {
name: 'button-click',
attributes: {
buttonLabel: 'Click here'
}
},
})
);
```

### Error Report Interactions

Error interactions capture when an error occurs on your site.

#### Interaction Name

| Interaction Name | Description |
|---|---|
| error | Captures errors that occur on your site. |

#### Fields

| Field | Type | Description |
|---|---|---|
| attributes | object | A dictionary of values that you supply. |
| id | string | Required. A unique ID representing the error type. |
| name | string | Required. The event name. |

예제:

```javascript
// exp_cloud_lwr.pdf 원문 발췌 — 동작 코드 아님
event.target.dispatchEvent(
new CustomEvent('experience_interaction', {
bubbles: true,
composed: true,
detail: {
name: 'error',
id: 'error-id-1',
attributes: {
type: "api-error",
message: "503: service not available"
},
},
})
);
```

### Line Item Data

Line items are intended to describe purchasable items. They're used in cart, catalog, and wish-list interactions.

> 주: Line Item Data는 Interaction Name 표가 없고 Fields만 있다. 또한 표 헤더가 다른 인터랙션의 `Field`가 아니라 **`Field Name`**으로 표기된다. 둘 다 PDF 원문 그대로. 임의 수정 아님.

#### Fields

| Field Name | Type | Description |
|---|---|---|
| attributes | object | A dictionary of values that you supply. |
| catalogObjectId | string | Required. A unique identifier representing the catalog object referenced in the line item. |
| catalogObjectType | string | Required. A name representing the catalog object referenced in the line item. |
| currency | string | The currency of the price field. |
| price | number | The price of the catalog object referenced in the line item. |
| quantity | number | Required. The number of catalog objects in this line item. |

예제 (인터랙션 내부에서 쓰이는 line item의 기본 구조):

```javascript
// exp_cloud_lwr.pdf 원문 발췌 — 동작 코드 아님
{
lineItems: {
id: 'line-item-12345',
catalogObject: {
id: 'catalog-id-12345678',
type: 'Product'
},
attributes: {
quantity: 12,
price: 2.5,
imageUrl: 'https://commerce.salesforce.com/blueshirt.jpg',
name: 'blue-shirt'
},
}
```

### Search Interactions

A search interaction occurs when a user performs a search on your site.

#### Interaction Name

| Interaction Name | Description |
|---|---|
| category-search | Captures an event that occurs when a user selects a category during a search. Available in package version 1.3 and later. |
| search | Captures a search event on your site. |

#### Fields

| Field | Type | Description |
|---|---|---|
| attributes | object | A dictionary of values that you supply. |
| categoryId | string | The ID of a category from a commerce site that the site visitor selects. Must be classified as a category-based search. |
| name | string | Required. The event name. |
| searchQuery | string | A value that the site visitor supplies representing a search query. |

예제:

```javascript
// exp_cloud_lwr.pdf 원문 발췌 — 동작 코드 아님
event.target.dispatchEvent(
new CustomEvent('experience_interaction', {
bubbles: true,
composed: true,
detail: {
name: 'search',
searchQuery: input7.value,
attributes: {
searchFacetList: ['color', 'size'],
searchType: ['product'],
numberOfResultsRequested: 12,
resultPageOffset: 10,
sortType: 'asc',
correlationId: 'X-239-22-0',
},
},
})
);
```

### Wish-List Interactions

A wish-list interaction occurs when a customer adds or removes items from their wish list.

#### Interaction Name

| Interaction Name | Description |
|---|---|
| wish-list-add | Captures an event for the addition of an item to a wish list. |
| wish-list-remove | Captures an event for the removal of an item from a wish list. |
| wish-list-replace | Captures an event for the replacement of all items in a wish list at the same time. |
| wish-list-update | Captures events for updates to a wish list. |

#### Fields

| Field | Type | Description |
|---|---|---|
| attributes | object | A dictionary of values that you supply. |
| id | string | Required. A unique ID representing the Wishlist object. |
| lineItems | Line Item Data on page 97 | Required. A single Line Item Data value. |
| name | string | Required. The event name. |

예제 (Add to Wish List):

```javascript
// exp_cloud_lwr.pdf 원문 발췌 — 동작 코드 아님
event.target.dispatchEvent(
new CustomEvent('experience_interaction', {
bubbles: true,
composed: true,
detail: {
name: 'wish-list-add',
wishList: {
id: 'wish-list-12345',
lineItems: {
catalogObject: {
id: 'catalog-id-12345678',
type: 'Product'
},
attributes: {
quantity: 12,
price: 2.5,
name: 'gray-jeans'
},
},
attributes: {
currency: '$',
name: 'my-personal-wish-list,
},
},
},
})
);
```

> 주: `name: 'my-personal-wish-list,`의 닫는 따옴표 누락은 PDF 원문 오타 그대로다. 임의 수정 아님.

---

## C. Google Tag Manager (3rd-party) 예제

> ⚠️ 이 영역(PDF Ch6)은 위 A영역의 네이티브 Experience Tag Manager와 **완전히 별개**다. Google의 3rd-party GTM 제품을 LWR 사이트에 수동으로 연결하는 예제다.

PDF 도입:

> "Use Google Tag Manager to track customer interactions with your LWR site, which is a single-page application. In these examples, the `<x-oasis-script>` privileged script tag lets Google Tag Manager interact with elements within the shadow DOM."

> "In these examples, the code listens for events and sends the captured details to the **data layer**. The data layer is an object that contains all the information that you want to pass to Google Tag Manager, such as events or variables. You can set up triggers in Google Tag Manager based on the variables in the data layer. Keep in mind that triggers and events loaded into Google Tag Manager using the `<x-oasis-script>` aren't visible in Google Tag Manager Preview mode. To view your expected changes, switch to live mode."

### GTM 설정 사전 작업 (Relaxed CSP·Trusted Sites·x-oasis-script)

GTM은 3rd-party 라이브러리이므로 추가 전에:

- Experience Builder의 **Settings > Security & Privacy**에서 **Relaxed CSP**로 전환한다.
- 같은 페이지의 **Trusted Sites for Scripts** 목록에 Google Tag Manager 스크립트의 URL을 추가한다.
- shadow DOM 내부 요소 접근은 `<x-oasis-script>` privileged script tag를 통해 이뤄진다.

> `<x-oasis-script>` privileged script tag의 보안 메커니즘(shadow DOM 접근 권한·LWS와의 관계) 상세는 [[Lightning Web Security (LWS)]]로 위임한다.
>
> 참고(공통): PDF에는 GTM 외에 인접 절 "Examples: Use Google Analytics in LWR Sites"(별개 절)도 있으나, 모든 Google 3rd-party 예제에 "Relaxed CSP 전환 + Trusted Sites for Scripts에 스크립트 URL 추가 + `<x-oasis-script>`로 shadow DOM 접근"이 공통으로 적용된다.

### Example 1 — 폼 입력·제출 추적

PDF: "In this example, a page in the LWR site contains a form called Subscribe. Google Tag Manager tracks when the form is submitted and what a customer entered in the form."

1. Experience Builder에서 **Settings > Advanced > Edit Head Markup** 클릭 후, 아래 GTM 스크립트를 oasis script tag로 임베드. `XXXX`를 본인의 GTM ID로 교체.

```html
// exp_cloud_lwr.pdf 원문 발췌 — 동작 코드 아님
<x-oasis-script hidden="true">(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
})(window,document,'script','dataLayer','GTM-XXXX');</x-oasis-script>
```

2. GTM에서 custom HTML tag를 만들고 아래 스크립트를 추가. 이 코드는 `.subscribe` 클래스로 페이지의 폼을 listen하고 `lwr_form_function`을 호출해 캡처된 입력을 data layer로 보낸다.

```html
// exp_cloud_lwr.pdf 원문 발췌 — 동작 코드 아님
<script>
var lwr_forms = window.frames[0].window.document.querySelectorAll('.subscribe');
lwr_forms.forEach(lwr_form_function);
function lwr_form_function(item) {
item.addEventListener('submit', function (event) {
window.dataLayer.push({
'event': 'formSubmit',
'FormTarget': event.target["target"],
'FormId': event.target.id,
'FormClass': event.target.className,
'FormUrl': event.target.src,
'FormElement': event.target,
'FormText': event.target.innerText
});
});
}
</script>
```

3. GTM에서 **Window Loaded** page view 트리거를 만들고, 특정 페이지에만 활성화하는 필터를 생략해 모든 페이지에 적용.
4. step 2에서 만든 custom HTML tag의 구성 페이지에서 Window Loaded page view 트리거를 그 태그에 할당.
5. 트리거를 publish.

### Example 2 — 버튼·링크 클릭 추적

PDF: "In this scenario, Google Tag Manager tracks each click of a link or button on a page."

1. Experience Builder에서 **Settings > Advanced > Edit Head Markup** 클릭 후, 아래 GTM 스크립트를 oasis script tag로 임베드. `XXXX`를 본인의 GTM ID로 교체.

```html
// exp_cloud_lwr.pdf 원문 발췌 — 동작 코드 아님
<x-oasis-script hidden="true">(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
})(window,document,'script','dataLayer','GTM-XXXX');</x-oasis-script>
```

2. GTM에서 custom HTML tag를 만들고 아래 스크립트를 추가. 이 코드는 `click` 클래스의 이벤트를 listen하고 캡처된 상세를 data layer로 보낸다.

```html
// exp_cloud_lwr.pdf 원문 발췌 — 동작 코드 아님
<script>
window.frames[0].window.document.addEventListener('click',function(e){
var targetElement=e.target;
window.dataLayer.push({
event: 'custom_click_Text_Trigger',
custom_event: {
element: targetElement,
elementId: targetElement.id || '',
elementClasses: targetElement.className || '',
elementUrl: targetElement.href || targetElement.action || '',
elementTarget: targetElement.target || '',
elementText: targetElement.innerText
}
});
});
</script>
```

3. GTM에서 **Window Loaded** 트리거를 만들고, 특정 페이지에만 활성화하는 필터를 생략해 모든 페이지에 적용.
4. step 2에서 만든 custom HTML tag의 구성 페이지에서 Window Loaded page view 트리거를 그 태그에 할당.
5. 트리거를 publish.

**SEE ALSO (외부 링크):** Google Help: Tag Manager Help.

---

## 관련 노트
- [[LWR Sites (Experience Cloud)]]
- [[LWR 동작·캐싱·제약]]
- [[LWR 컴포넌트 개발 심화]]
- [[LWR 다국어 사이트]]
- [[LWR Expressions 레퍼런스]]
- [[LWR --dxp 스타일링 훅 레퍼런스]]
- [[Lightning Web Security (LWS)]]
- [[Data Cloud Objects]]
