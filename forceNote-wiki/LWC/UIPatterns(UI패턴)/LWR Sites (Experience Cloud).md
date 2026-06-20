---
tags: [lwc, experience-cloud, lwr, sites, community, dxp, multilingual, experience-delivery]
source: exp_cloud_lwr.pdf (LWR Sites for Experience Cloud v66.0, Spring '26, Tier 2)
official_doc: https://developer.salesforce.com/docs/atlas.en-us.exp_cloud_lwr.meta/exp_cloud_lwr/
created: 2026-06-14
aliases: [LWR Sites, Experience Cloud LWR, Build Your Own LWR, Microsite, lightningCommunity__Page, dxp styling hooks, --dxp, Experience Builder LWC, Enhanced LWR, enhanced sites and content platform, partial deployment, expression-based visibility, site content search, Experience Delivery, SSR, CSR, server-side rendering, custom record component, GlobalSearchController, logout link, secur/logout.jsp, Build Your Own vs Microsite, Editions]
---

# LWR Sites (Experience Cloud)

> **Lightning Web Runtime(LWR)** + LWC 프로그래밍 모델로 만드는 고성능 Experience Cloud 사이트. **Build Your Own (LWR)**·**Microsite (LWR)** 템플릿. Aura 사이트보다 빠르고, 커스텀 LWC·테마/페이지 레이아웃·`--dxp` 브랜딩 훅을 지원.

> [!note] *LWR Sites for Experience Cloud v66.0* 전수. 📖 공식: [LWR Sites for Experience Cloud](https://developer.salesforce.com/docs/atlas.en-us.exp_cloud_lwr.meta/exp_cloud_lwr/)

---

## LWR이란

- **Build Your Own (LWR)** · **Microsite (LWR)** 템플릿 = 웹사이트·포털·마이크로사이트를 LWC로 구축. 코어 Web Components 표준 기반이라 경량·고성능.
- Aura 기반 사이트와 다른 런타임 — **새 퍼블리싱 모델·커스텀 URL 경로·Lightning Web Security·캐싱 정책·head markup**.
- 커스텀 URL 경로(`/s` 없이 `https://mycustomdomain.com/mypage`), Salesforce DX·선호 에디터로 개발, Apex·UI API·SOSL 지원으로 data-rich 경험 구축. publish-time freezing·HTTP caching 성능 기능.

### Enhanced LWR Sites

**enhanced sites and content platform** = Salesforce CMS와 LWR 사이트를 통합한 유연한 신규 시스템. **Winter '23부터 자동 활성화**되어, 새로 만드는 모든 LWR 사이트가 이 플랫폼에서 호스팅된다(새 enhanced CMS workspace도 동일). enhanced 플랫폼의 사이트/워크스페이스를 **enhanced LWR sites**·**enhanced CMS workspaces**라 부른다.

enhanced LWR 사이트·워크스페이스 전용 기능:

| 기능 | 설명 |
|---|---|
| **partial deployment** | 어떤 site element를 라이브로 보낼지 선택 가능 |
| **expression-based visibility** | 컴포넌트가 **언제·누구에게** 노출될지 제어 |
| **site content search** | 사용자가 **Rich Content Editor·HTML Editor** 컴포넌트에 담긴 콘텐츠를 검색 |
| **enhanced CMS workspace 통합 검색** | 모든 것이 통합 플랫폼에서 함께 동작하므로, 사이트 검색 결과에 enhanced CMS workspace에서 공유한 콘텐츠 포함 |

### Editions & 사전요건

- **Editions:** Enterprise · Performance · Unlimited · Developer 에서 LWR 사이트 생성 가능.
- **사전요건:** org에 **Digital Experiences(구 Communities) enabled**. 그리고 다음 경험 필요:
  - Experience Builder로 사이트 빌드
  - Lightning web components 개발
  - Salesforce DX · User Interface API · Apex 사용
- > Important: LWR 템플릿으로 개발 시작 전에 **LWR Template Limitations** 섹션을 검토해 템플릿이 요구사항을 지원하는지 확인 권장.

### Build Your Own vs Microsite

| 항목 | Build Your Own (LWR) | Microsite (LWR) |
|---|---|---|
| 성격 | minimal — 가장 필수적인 페이지·컴포넌트만 제공 | responsive layout + preconfigured pages + content components 포함 |
| 빌드 | 동작하는 사이트를 만들려면 자체 custom 페이지·컴포넌트를 추가해야 함 | use case에 따라 추가 커스터마이징이 거의 불필요 |
| 적합 대상 | LWC·Salesforce DX·UI API·Apex에 능숙한 개발자 | landing page·event site 등을 빠르게 구축할 때 |
| SLDS | **SLDS를 제거**하고 자체 컴포넌트·디자인 시스템으로 pixel-perfect 사이트 구성 가능 | (PDF 언급 없음) |

---

## 컴포넌트 개발 — meta 타깃 (전수)

각 LWC 폴더에 `<component>.js-meta.xml` 필요. Experience Builder용 design 설정값 정의. LWR 템플릿용으로 2개 타깃이 추가됨.

> → 심화: [[LWR 컴포넌트 개발 심화]] — `js-meta.xml` 타깃·`targetConfigs` 프로퍼티 전수, `@salesforce` 모듈, 화면 크기 반응형(`--dxp-c-*`), 커스텀 레이아웃·내비게이션 메뉴 컴포넌트(Ch3 전수).

| 타깃 | 용도 |
|---|---|
| `lightningCommunity__Page` | 드래그앤드롭 컴포넌트(LWR·Aura 사이트 페이지). Components 패널에 표시 |
| `lightningCommunity__Page_Layout` | **(LWR 신규)** 페이지 레이아웃으로 사용. Page Layout 창에 표시 |
| `lightningCommunity__Theme_Layout` | **(LWR 신규)** 테마 레이아웃으로 사용. Settings > Theme에 표시 |
| `lightningCommunity__Default` | `Page` 또는 `Theme_Layout`과 함께 사용 — 모든 위치에서 사용 가능하게 |

```xml
<!-- helloSite.js-meta.xml — LWR 사이트 페이지 컴포넌트 -->
<?xml version="1.0" encoding="UTF-8"?>
<LightningComponentBundle xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>67.0</apiVersion>
    <isExposed>true</isExposed>
    <masterLabel>Hello Site</masterLabel>
    <targets>
        <target>lightningCommunity__Page</target>
        <target>lightningCommunity__Default</target>
    </targets>
    <targetConfigs>
        <targetConfig targets="lightningCommunity__Default">
            <property name="greeting" type="String" label="Greeting" />
        </targetConfig>
    </targetConfigs>
</LightningComponentBundle>
```

### LWR 컴포넌트에서 쓸 수 있는 것
- **User Interface API** (레코드 데이터)
- **`@salesforce` 모듈**: `userPermission/`·`customPermission/`·`staticResource/`·`contentAsset/`·일부 `i18n` 속성
- **Lightning Navigation** (사이트 내 페이지 이동)
- **반응형**: 커스텀 LWC를 화면 크기 반응형으로 (`--dxp-c-screensize-property` 등)
- **커스텀 레이아웃·내비게이션 메뉴 컴포넌트** 작성 가능
- ⚠️ **Base Lightning Component Limitations** — 일부 `lightning-*` 베이스 컴포넌트는 LWR 사이트에서 제한/미지원

---

## 브랜딩 — `--dxp` 스타일링 훅

> → 전수 레퍼런스: [[LWR --dxp 스타일링 훅 레퍼런스]] — Color/Text/Site Spacing 훅 전수·Theme 패널 속성 매핑표·Site Logo·Custom Fonts·Remove SLDS (Ch4). 이 절은 그 요약이다.

LWR 사이트는 SLDS의 `--slds-*`가 아니라 **`--dxp-*`** (Digital Experience Platform) 훅으로 브랜딩한다. Theme 패널 속성과 매핑됨.

| 분류 | 예시 훅 |
|---|---|
| **전역(Global) `--dxp-g-*`** | `--dxp-g-brand`, `--dxp-g-brand-contrast`, `--dxp-g-brand-1~3` (브랜드 색 팔레트) |
| **컴포넌트(Component) `--dxp-c-*`** | `--dxp-c-section-content-spacing-block-start/end`, `--dxp-c-section-columns-max-width`, `--dxp-c-l/m/s-banner-alignment`(화면 크기별) |

- **색상·텍스트·사이트 간격** 훅으로 테마 제어, 커스텀 컴포넌트에서도 `var(--dxp-...)` 사용
- 커스텀 CSS로 컴포넌트 브랜딩 오버라이드, 색 팔레트(섹션/컬럼), 사이트 로고 컴포넌트, **커스텀 폰트** 추가
- **Remove SLDS** — SLDS 스타일을 제거하고 완전 커스텀 CSS 적용 가능

---

## 비-LWS 커스텀 컴포넌트

Build Your Own (LWR) 템플릿은 record 컴포넌트를 포함하지 않으므로, **User Interface API**로 자체 record 컴포넌트를 구성한다. 많은 Aura 템플릿 컴포넌트는 LWC로 제공되지 않지만, 기존 LWC를 extend할 수 있다(*Lightning Web Components Reference* 참조). 단 **related record lists는 UI API가 아직 미지원**이라 해당 유형 컴포넌트는 완전히 구성할 수 없다.

> custom record home·record detail 컴포넌트 예시는 코드 샘플의 `customRecord/force-app/main/default/lwc`에 있음.

### Custom Record Components

record list 컴포넌트의 data table에 **custom column**(예: Account Name)을 추가하려면 `LightningDatatable`을 extend해 **custom data type**을 정의한다. 아래 예에서 레코드 이름이 자신의 record page로의 하이퍼링크와 함께 표시된다.

```javascript
// exp_cloud_lwr.pdf 발췌 — PDF 원문 코드
// [sic] PDF 원문 import 구문 닫는 따옴표 누락(`'lightning/datatable;`) — 정규화함
import { LightningDatatable } from 'lightning/datatable';
export default class RecordTable extends LightningDatatable {
    // define a new custom type… the custom cell will have a markup
    // represented by the template attribute
    static customTypes = {
        'name': {
            template: './name.html'
        };
    }
}
```

custom type의 markup은 template 안에 정의한다. record page로의 하이퍼링크를 표시하기 위해 별도 record link 컴포넌트를 만들고 record table 컴포넌트가 제공한 값을 넘긴다.

```html
<!-- exp_cloud_lwr.pdf 발췌 — PDF 원문 코드 (inside name.html) -->
<template>
    <c-record-link
        object-api-name={value.objectApiName}
        record-id={value.id}
        label={value.name}>
    </c-record-link>
</template>
```

record 컴포넌트는 `lightning/navigation`의 **`NavigationMixin`**을 extend해 record·object page용 URL을 생성할 수 있다. `NavigationMixin.Navigate`에 page type과 route parameter를 넘기면 새 URL을 생성해 이동한다 — 다른 페이지에서 액션을 수행할 때 유용. **`view` 외의 record `actionName`은 custom page가 필요**하다.

```javascript
// exp_cloud_lwr.pdf 발췌 — PDF 원문 코드 (record 편집 custom page로 이동)
handleEdit() {
    // assumes you have created a custom page with API Name "record"
    this[NavigationMixin.Navigate]({
        type: 'comm__namedPage',
        attributes: {
            name: 'record__c'
        },
        state: {
            objectApiName: this.objectApiName,
            recordId,
            actionName: 'edit'
        }
    });
}
```

> Note: actions에 대한 UI API는 아직 미제공. 기본 record 생성·편집은 별도 페이지 + `lightning-record-form` 또는 custom Apex controller 사용 고려.
>
> Important: **preconfigured route parameter를 쓰는 object page custom solution은 limited support** — at your own risk. 가능하면 Salesforce 제공 page template 사용.

### Apex + SOQL 검색

theme layout search 컴포넌트가 사용자를 search results 페이지로 보내도록 구성한다.

1. 사이트에 **Search용 standard 페이지** 생성(검색 결과 landing page 역할).
2. theme header region에 **Simple Theme Header** 컴포넌트 드래그. 여기엔 **Search Bar** 컴포넌트 등 유틸리티가 포함. 사용자가 검색어 입력 후 Enter 시 Search Bar가 `lightning-navigation` API로 Search 페이지로 이동.
3. Search 페이지의 content region에 **Search Results** 컴포넌트 드래그. 이 컴포넌트는 **`{!Route.term}`** 표현식으로 검색 URL 파라미터를 가져온 뒤, 검색어와 object API name을 파라미터로 Apex 메서드에 요청해 결과 데이터로 UI를 채운다.
4. **`GlobalSearchController.cls`** — 검색어를 받아 Name에 검색 문자열을 포함하는 레코드를 SOQL로 검색하는 Apex controller.

> Tip: 검색 결과를 쓸 사용자를 위해 **Apex class에 permission을 설정**해야 함(*How Does Apex Class Security Work*). custom search 예시는 `codeSamples/customSearch/force-app/main/default/`.

### 동적 데이터 — Expressions

`{!expression}` 표현식으로 Salesforce·CMS 데이터를 컴포넌트 속성에 바인딩한다.

> Data Binding·Other Expressions 표 전수와 제약은 [[LWR Expressions 레퍼런스]] 참조.

### Logout Link Component

사용자를 로그아웃시키려면 **`[/sitePrefix]/secur/logout.jsp`** 경로로 리다이렉트한다. `[/sitePrefix]`는 사이트의 base path(`/s` 제외)이며, 사이트가 prefix를 쓰지 않으면 **빈 문자열**을 사용한다. 아래는 인증된 사용자일 때만 logout link를 표시하는 컴포넌트 예시다.

```html
<!-- exp_cloud_lwr.pdf 발췌 — PDF 원문 코드 -->
<template>
    <template if:false={isGuest}>
        <a href={logoutLink}>Logout</a>
    </template>
</template>
```

```javascript
// exp_cloud_lwr.pdf 발췌 — PDF 원문 코드
// [sic] PDF 원문 마지막 return이 single-quote('/${sitePrefix}/...')라 template literal 미동작 — backtick으로 정규화함
import { LightningElement, api } from "lwc";
import isGuest from "@salesforce/user/isGuest";
import basePath from "@salesforce/community/basePath";

export default class Logout extends LightningElement {
    get isGuest() {
        return isGuest;
    }
    get logoutLink() {
        const sitePrefix = basePath.replace("/", "");
        return `/${sitePrefix}/secur/logout.jsp`;
    }
}
```

대안으로, 제공된 system Apex 클래스를 호출해 login·logout 링크를 얻을 수 있다.

```javascript
// exp_cloud_lwr.pdf 발췌 — PDF 원문 코드
import getLogoutUrl from
    '@salesforce/apex/applauncher.IdentityHeaderController.getLogoutUrl';
import getLoginUrl from '@salesforce/apex/system.Network.getLoginUrl';
```

> 기본적으로 로그아웃 후 login 페이지로 리다이렉트된다. logout 페이지 URL은 **Experience Workspaces > Administration > Login & Registration > Logout Page URL**에서 설정. logout link·profile menu 예시는 `codeSamples/salesforceScopedModules/force-app/main/default/`.

---

## 다국어

LWR 사이트에 언어를 추가하면 멀티링궐(multilingual) 사이트가 된다. Experience Builder의 **Settings > Languages**에서 **최대 40개 언어**(기본 언어 포함)를 추가하고, **Language Selector** 컴포넌트로 방문자가 번역본을 전환하게 한다. 콘텐츠는 **`.xlf`** 파일로 export/import하며, **자동 언어 감지**가 브라우저/프로필 언어로 사이트를 표시한다.

> 언어 추가·fallback·자동 감지·번역 export/import 전수는 [[LWR 다국어 사이트]] 참조.

---

## Experience Delivery (Beta)

**Experience Delivery** = LWR 사이트 호스팅을 위한 강력한 신규 인프라로, **Build Your Own (LWR) 템플릿**으로 만든 사이트의 확장성·성능을 높인다. subsecond page load와 함께 향상된 보안·SEO를 제공한다.

> [!note] **Beta 면책 (PDF 원문 인용)**
> *"For sites created with the Build Your Own (LWR) template, Experience Delivery is a pilot or beta service that is subject to the Beta Services Terms at Agreements - Salesforce.com or a written Unified Pilot Agreement if executed by Customer, and applicable terms in the Product Terms Directory. Use of this pilot or beta service is at the Customer's sole discretion."*

| 항목 | Existing LWR (CSR) | Experience Delivery (SSR) |
|---|---|---|
| 렌더링 | client-side rendering (CSR) | server-side rendering (SSR) + dedicated CDN |
| 동작 | 페이지를 구성하는 HTML·JavaScript·CSS·assets를 client로 다운로드한 뒤 브라우저에서 렌더 | 서버에서 페이지를 렌더한 뒤 CDN에 캐시 |
| 성능 | 기준 | **page load 최대 60% faster**, subsecond — 전환율↑·bounce rate↓ |

- 신규·기존 LWR 및 enhanced LWR 사이트 중 **Build Your Own (LWR) 템플릿** 사용 사이트에서 지원.
- **site-level**로 enable — 사이트의 **Administration workspace > Settings tab**에서 켠다.

> Tip: Experience Delivery 및 beta limitation 상세는 *Experience Delivery (Beta) guide* 참조.

---

## 차이·제약 (Aura 사이트 대비)

- Experience Cloud에는 기존 Aura 기반 Build Your Own 템플릿(Aura·LWC 모두 지원)이 있으나, **Build Your Own (LWR)·Microsite (LWR)는 LWC 프로그래밍 모델·Lightning web components만 기반**으로 한다. LWR로 구동되어 scale·로드가 빠르고 완전 커스텀 솔루션을 지원.
- 새 **퍼블리싱 모델**, **커스텀 URL 경로**, **[[Lightning Web Security (LWS)|Lightning Web Security]]** 적용, **캐싱 정책**, **head markup** 커스터마이즈 — 퍼블리싱 모델·커스텀 URL·캐싱·head markup 상세는 [[LWR 동작·캐싱·제약]] 참조
- **LWR Template Limitations** — 일부 표준 기능/컴포넌트 미지원. 전수는 [[LWR 동작·캐싱·제약]] 참조

---

## 관련 노트

- 📖 공식: [LWR Sites for Experience Cloud](https://developer.salesforce.com/docs/atlas.en-us.exp_cloud_lwr.meta/exp_cloud_lwr/)
- [[LWR 동작·캐싱·제약]] — 페이지/퍼블리싱 모델·커스텀 URL·캐싱 TTL·head markup·Light DOM·LWR Template Limitations 전수
- [[LWR 다국어 사이트]] — 언어 추가·fallback·자동 감지·`.xlf` export/import 전수
- [[LWR Expressions 레퍼런스]] — `{!expression}` Data Binding·Other Expressions 표·제약 전수
- [[LWR --dxp 스타일링 훅 레퍼런스]] — 형제 spoke(브랜딩): `--dxp` 훅 전수·Theme 패널 매핑표·Site Logo·Custom Fonts·Remove SLDS (Ch4)
- [[LWR Tag Manager 데이터 관리]] — 형제 spoke(데이터): 네이티브 Experience Tag Manager(`experience_interaction`→Website Engagement DMO·이벤트 9종)·Google Tag Manager(`<x-oasis-script>`→dataLayer) (Ch7+Ch6)
- [[Lightning Web Security (LWS)]] — LWR 사이트 LWS·Privileged Script Tag(`<x-oasis-script>`) 상세
- [[UI API 개요]] — custom record 컴포넌트 데이터 소스
- [[lightning-datatable]] — `LightningDatatable` extend·custom cell type
- [[getRecord 패턴]] — UI API 레코드 데이터 바인딩
- [[NavigationMixin 패턴]] — Lightning Navigation·`comm__namedPage`
- [[Metadata API 빌드·릴리스 워크플로]] — ExperienceBundle
- [[LWC API 버전 관리]] — `.js-meta.xml` targets/targetConfigs 구조
- [[SLDS LWC 디자인 시스템]] — `--slds-*` 훅 (LWR은 `--dxp-*` 사용)
- [[CRM Analytics 대시보드용 LWC]] — 다른 LWC 타깃 surface
- [[LWC MOC]]
