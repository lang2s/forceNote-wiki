---
tags: [lwc, experience-cloud, lwr, sites, community, js-meta, targetConfigs, salesforce-modules, screen-responsive, custom-layout, navigation-menu, dxp]
source: exp_cloud_lwr.pdf (LWR Sites for Experience Cloud v66.0, Spring '26, Tier 2) — Chapter 3 "Start Building Your LWR Site" (print p.15–30)
official_doc: https://developer.salesforce.com/docs/atlas.en-us.exp_cloud_lwr.meta/exp_cloud_lwr/
created: 2026-06-20
aliases: [LWR component development, LWR 컴포넌트 개발, js-meta.xml targets, lightningCommunity__Page_Layout, lightningCommunity__Theme_Layout, lightningCommunity__Default, targetConfigs, component properties, screenResponsive, --dxp-c-screensize-property, @salesforce modules LWR, screen-size responsive, custom layout component, custom navigation menu, F6 navigation, theme layout component, page layout component, NavigationLinkSet, 화면 크기 반응형, 커스텀 레이아웃 컴포넌트, 커스텀 내비게이션 메뉴]
---

# LWR 컴포넌트 개발 심화

> LWR 사이트용 커스텀 LWC를 만드는 전 과정 — 사이트·커스텀 페이지·테마 레이아웃 생성부터 `js-meta.xml` 타깃·`targetConfigs` 프로퍼티 전수, `@salesforce` 모듈, 화면 크기 반응형(`--dxp-c-*`), 커스텀 레이아웃·내비게이션 메뉴 컴포넌트까지. (`exp_cloud_lwr.pdf` Ch3 전수)

> 📍 허브: [[LWR Sites (Experience Cloud)]] · 이 노트는 그 "컴포넌트 개발" 섹션의 deep dive(Ch3 전수).

---

## 개요

이 노트는 *LWR Sites for Experience Cloud* (v66.0 Spring '26) **Chapter 3 "Start Building Your LWR Site"** (print p.15–30)를 전수 정리한 deep dive다. LWR(= Build Your Own / Microsite 템플릿) 사이트에서 커스텀 Lightning web component를 만들어 동작하는 사이트를 띄우기까지의 초기 단계 — 사이트 생성, 커스텀 페이지, 테마 레이아웃, `js-meta.xml` 구성, 컴포넌트 프로퍼티, `@salesforce` 모듈, navigation, 화면 크기 반응형, 커스텀 레이아웃·내비게이션 메뉴 컴포넌트, publish — 를 다룬다.

> custom record 컴포넌트 등 더 advanced한 커스터마이징은 *Add More Customizations*(Ch6) 영역이며 허브가 담당한다. 브랜딩 `--dxp` 스타일링 훅(색·텍스트 매핑)은 Ch4 영역으로 이 노트 범위 밖이다 — [[LWR --dxp 스타일링 훅 레퍼런스]] 참조. (단 화면 반응형의 `--dxp-c-screensize-property`는 Ch3 소관이라 여기 포함한다.)

---

## LWR 사이트 생성

LWR 사이트는 **Build Your Own (LWR)** 또는 **Microsite (LWR)** 템플릿으로 만든다.

**Winter '23부터의 두 가지 변경점:**
1. Winter '23 이전엔 사이트 생성 시 authenticated/unauthenticated를 선택할 수 있었고 이것이 사이트 URL에 영향을 줬다. **Winter '23 이후 LWR 사이트는 기본적으로 authenticated**이며 URL 끝에 더 이상 `/s`를 포함하지 않는다. → *Custom URL Paths in LWR Sites* 참조.
2. Winter '23부터 새로 만드는 LWR 사이트와 CMS workspace는 **enhanced sites and content platform**에 함께 호스팅된다(partial deployment, site content search, easy content management 제공). 따라서 Microsite (LWR)·Build Your Own (LWR)로 만든 새 LWR 사이트는 모두 **enhanced LWR sites**다.

**생성 절차 (4단계):**
1. Setup → Quick Find에 `Digital Experiences` 입력 → **All Sites** 선택 → **New** 클릭.
2. 생성 위저드에서 **Build Your Own (LWR)** 또는 **Microsite (LWR)** 선택 → **Get Started**.
3. name과 base URL value 입력. base URL은 Digital Experiences 활성화 시 만든 도메인에 append된다. 예: 도메인이 `UniversalTelco.my.site.com`이고 partner 사이트를 만든다면 `partners`를 입력해 `UniversalTelco.my.site.com/partners`라는 고유 URL을 만든다.
4. **Create** 클릭. 생성 후 Experience Workspaces 영역이 나타난다.

> 프로그래밍 방식 생성: **Connect API** 또는 **Salesforce CLI commands**로도 사이트를 만들 수 있다.

---

## 커스텀 페이지 생성

LWR 템플릿은 key default page를 몇 개만 제공하므로, use case에 맞춰 추가 custom page를 만든다.

**생성 방법:** Experience Builder 상단 툴바의 **Pages** 메뉴를 열고, Pages 메뉴 하단의 **New Page**를 클릭한다. (*Create Custom Pages with Experience Builder* in Salesforce Help)

| 페이지 유형 | 내용 |
|---|---|
| **Standard Pages** | custom page 생성 시 **Search** standard page를 템플릿에서 사용할 수 있고, 특정 route·URL parameter를 지원한다. **Note:** Account Management 같은 일부 preconfigured standard page는 **unsupported**다. |
| **Object Pages** | record page 컴포넌트의 권장 솔루션은 User Interface API로 데이터를 조회하므로, *User Interface API Developer Guide*의 **Supported Objects**에 대해서만 object page를 만든다. **Note:** Aura 템플릿과 달리 **generic record page가 없다**. record page가 필요하면 특정 object에 대해 직접 만들어야 한다. |
| **Login Pages** | LWR 템플릿이 제공하는 Login / Forgot Password / Registration page를 쓰려면 사이트가 published여야 한다. Administration workspace의 **Login & Registration** 탭에서 각 page에 **Experience Builder Page**를 선택하고, Login page엔 `main`(1), Forgot Password page엔 `Forgot Password`(2), Registration page엔 `Register`(3)를 입력한다. |
| **Page Access & Authentication** | Aura 사이트와 마찬가지로, guest user session을 포함해 사이트의 **모든 route**에 대해 page metadata를 client로 보낸다. |

> [!important] **보안 — URL parameter validation 차이.** LWR 사이트는 navigation 중 URL parameter validation이 Aura 사이트와 다르다. 예를 들어 object/record 접근 권한이 없는 user가 record route에 접근하는 것을 막지 않으며, URL parameter가 org의 유효한 기존 데이터에 대응하는지도 validate하지 않는다. 데이터 조회 시 올바른 user sharing rule을 강제하는 것은 page의 컴포넌트와 사용 API의 책임이다. **따라서 user access rule을 구현한 API에서 오는 데이터가 아니면 민감 정보를 page에 두지 말 것.** (→ [[Lightning Web Security (LWS)]])

---

## 테마 레이아웃 생성

theme layout과 theme layout component는 LWR site page의 **shared region**(header·footer)을 정의한다. theme layout component는 site page의 header·footer를 결정하고 보통 navigation·search·user profile menu를 포함한다. theme layout component를 theme layout에서 사용하고, 그 theme layout을 page에 assign하면, 같은 theme layout을 assign한 모든 page가 동일한 header·footer를 보여준다. LWR 사이트는 일부 theme layout·theme layout component를 기본 제공하며 직접 만들 수도 있다.

**예시 시나리오:** primary theme layout이 **Scoped Header and Footer** theme layout component를 쓴다(header에 logo·navigation menu·user profile menu, footer에 contact links 포함). knowledge base page에만 header에 **Create Case** 버튼을 추가하고 싶다면, `Knowledge Base`라는 theme layout을 만들어 knowledge base page에 적용하고 그 page의 header에 버튼을 추가한다.

**절차 (5단계):**
1. **Settings > Theme**에서 **New Theme Layout** 클릭.
2. 새 theme layout 이름을 입력하고, 선택한 theme layout component를 새 layout에 assign한 뒤 저장한다. (예: Scoped Header and Footer를 새 Knowledge Base theme layout에 추가 — 이 component가 logo·navigation menu·user profile menu를 header에 포함하므로 새 theme layout도 그 요소들을 갖는다.)
3. Experience Builder의 **Pages** 메뉴에서 새 theme layout을 적용할 page(예: knowledge base page)를 선택한다.
4. page settings에서 **Override the default theme layout for this page**를 선택한 뒤 새 theme layout을 선택한다.
5. page 자체에서 원하는 컴포넌트(들)를 header/footer에 추가한다(예: Button 컴포넌트를 header에).

결과적으로 버튼이 있는 header는 knowledge base page에만 표시되고, 나머지 page는 버튼 없는 header를 보여준다.

> **Tip:** 자신만의 theme layout component를 만들려면 아래 [커스텀 레이아웃 컴포넌트](#커스텀-레이아웃-컴포넌트)의 Theme Layout을 참조한다.

**Scoped Header and Footer 추가 layout 옵션** — Build Your Own (LWR) 템플릿으로 만든 사이트에서, theme layout이 Scoped Header and Footer component를 쓰는 page에는 **Theme > Theme Layout Settings**에서 추가 옵션을 선택할 수 있다.

| 옵션 | 설명 |
|---|---|
| **Fix theme header** | 전체 header region을 page 상단에 항상 표시되도록 유지하고 싶을 때. |
| **Hide theme footer** | footer를 화면에서 숨기고 싶을 때. |
| **Position theme footer at page bottom** | footer region을 page 하단에 위치시키고 싶을 때. page 길이에 따라 site visitor가 footer를 보려면 스크롤해야 할 수 있다. |

- 이 옵션들은 **Settings > Theme**에서 Scoped Header and Footer 타입의 어떤 theme layout component의 property settings에서도 사용할 수 있다.
- **Note:** theme layout을 변경하면(예: theme header 고정) 그 변경은 이 theme layout이 assign된 **모든 page**에 나타난다.

---

## 컴포넌트 생성 — js-meta.xml 타깃

각 LWC 폴더는 **`<component>.js-meta.xml`** 구성 파일을 반드시 포함한다. 이 파일이 컴포넌트의 metadata value(Experience Builder용 design configuration value 포함)를 정의한다.

기존 Experience Builder 사이트용 LWC를 만들어봤다면 `lightningCommunity__Page`, `lightningCommunity__Default` target에 익숙할 것이다. **LWR 템플릿에선 2개의 신규 target 타입이 추가됐다:** `lightningCommunity__Page_Layout`, `lightningCommunity__Theme_Layout`.

### 타깃 4종과 design configuration 규칙

| Target Value | Description |
|---|---|
| `lightningCommunity__Page` | drag-and-drop 컴포넌트를 Experience Builder의 LWR 또는 Aura site page에서 사용 가능하게 한다. **Components panel**에 나타난다. |
| `lightningCommunity__Page_Layout` | 컴포넌트를 Experience Builder의 LWR site에서 **page layout**으로 사용 가능하게 한다. **Page Layout window**에 나타난다. |
| `lightningCommunity__Theme_Layout` | 컴포넌트를 Experience Builder의 LWR site에서 **theme layout**으로 사용 가능하게 한다. **Settings**의 **Theme** area에 나타난다. |
| `lightningCommunity__Default` | `lightningCommunity__Page` 또는 `lightningCommunity__Theme_Layout`과 함께 사용한다. 컴포넌트가 Experience Builder에서 선택되었을 때 editable한 property를 expose하게 한다. Experience Builder 사이트에선 `lightningCommunity__Default`만이 configurable component property를 지원한다. 지원하는 property attribute data type: **Integer / String / Boolean / Picklist / Color**. |

**design configuration value 정의 규칙** — 컴포넌트를 Experience Builder에서 쓰려면 `<component>.js-meta.xml`를 편집한다:
- **Experience Builder에서 usable하게:** `isExposed`를 `true`로 설정하고, `targets`에 `lightningCommunity__Page`, `lightningCommunity__Page_Layout`, 또는 `lightningCommunity__Theme_Layout`을 정의한다.
- **선택 시 editable한 property 포함:** `targets`에 `lightningCommunity__Default`를 정의하고 `targetConfigs`에 property를 정의한다.

> **Note:** *Configuration File Tags*(LWC Developer Guide)에 나열된 모든 configuration file tag가 지원된다. 자세한 내용은 *Configure a Component for Experience Builder*(LWC Developer Guide) 참조.

### Component Properties — targetConfigs 전수

다음은 **4개의 editable property**를 가진 LWC의 샘플 코드다. `lightningCommunity__Page`는 이 컴포넌트가 drag-and-drop 컴포넌트임을 Experience Builder에 알리고, `lightningCommunity__Default` target은 `targetConfig`에서 design-time component property를 Experience Builder용으로 구성한다.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<LightningComponentBundle xmlns="http://soap.sforce.com/2006/04/metadata" fqn="myComponent">
<apiVersion>51.0</apiVersion>
<isExposed>true</isExposed>
<masterLabel>Component Name</masterLabel>
<description>Description of your component.</description>
<targets>
<target>lightningCommunity__Page</target>
<target>lightningCommunity__Default</target>
</targets>
<targetConfigs>
<targetConfig targets="lightningCommunity__Default">
<property type="String" name="stringProp" default="hello world"/>
<property type="Integer" name="integerProp" default="314"/>
<property type="Boolean" name="booleanProp" default="true"/>
<property type="Color" name="colorProp" default="#333333"/>
<property type="Picklist" name="picklistProp" datasource="item1,item2"/>
</targetConfig>
</targetConfigs>
</LightningComponentBundle>
```

> ⚠️ **원문 불일치(보존):** 본문은 "four editable properties"라고 하지만 코드 블록에는 property가 5개(`stringProp`/`integerProp`/`booleanProp`/`colorProp`/`picklistProp`) 있다. PDF 원문 그대로 둔다.
> ⚠️ **`<apiVersion>51.0`**: PDF 원문 그대로 보존(허브 helloSite 예제의 67.0과 다름). 실제 신규 컴포넌트는 최신 API 버전 사용을 권장한다.

**코드상 property 5종:**

| property name | type | default / datasource |
|---|---|---|
| `stringProp` | String | `default="hello world"` |
| `integerProp` | Integer | `default="314"` |
| `booleanProp` | Boolean | `default="true"` |
| `colorProp` | Color | `default="#333333"` |
| `picklistProp` | Picklist | `datasource="item1,item2"` |

**프로퍼티 규칙 (전수):**
- **camelCase (Note):** component property 이름은 `.js` 파일과 `js-meta.xml` 파일 **양쪽 모두** camel case로 짓는다. **첫 글자를 대문자로 하지 말 것** — 컴포넌트가 깨질 수 있다.
- **default 동작:** `js-meta.xml`의 property `default` 값이 컴포넌트 property의 out-of-the-box 값을 결정한다. `default`가 제공되지 않으면 `.js` 파일의 대응 `@api` 변수 값을 사용한다(→ [[@api 패턴]]). 이 값은 Experience Builder의 컴포넌트 property panel에서 추가 편집할 수 있다.
- **타입 coercion:** 컴포넌트가 load될 때, property의 현재 값을 `js-meta.xml`에 지정된 JavaScript type으로 coerce하려 시도한다. `js-meta.xml`에 대응 property가 전혀 없고 attribute가 `.js` 파일에만 존재하면 값은 coerce되지 않는다.
- **expression language:** expression 구문(예: `{!Route.recordId}`)을 값으로 가진 `@api` property는 `js-meta.xml`에 대응하는 design property config가 있을 때만 interpolate된다. *Make a Component Aware of Its Context*(LWC Developer Guide) 참조.
- **translatable:** multilingual 사이트에서 String property를 translatable하게 만들려면 `js-meta.xml`에 `translatable="true"`로 정의한다. property에 `datasource` attribute를 추가하면(예: picklist 생성) 그 property를 `translatable="true"`로 정의할 수 없다. (→ [[LWR 다국어 사이트]])

> ⚠️ PDF 원문은 위 `translatable` 값을 곡선 따옴표(`translatable=“true”`)로 인쇄했으나 실제 XML은 직선 따옴표(`"true"`)이므로 정규화했다.

### Base Lightning Component 제약

LWR 사이트에서 Lightning Component Library의 대부분 컴포넌트를 쓸 수 있으나 일부 제약이 있다.

- **`lightning-input-field`** 컴포넌트(다른 컴포넌트 내에서 사용될 때 포함):
  - desktop computer에서 보는 LWR 사이트에서 **lookup search 미지원**.
  - mobile device에서 보는 LWR 사이트에서 **unsupported**.
- **unsupported 컴포넌트·이벤트:**
  - `lightning-emp-api`
  - `lightningsnapin` components
  - `platform-show-toast-event` — 단 `toast-container`는 사용 가능.
- **unsupported features:**
  - 파일 열기(*Open Files*, LWC Developer Guide 설명대로)
  - panel 또는 modal 사용

> **Tip:** `lightning-messageService` 예시는 code sample files의 `codeSamples/messageService` 참조.

### User Interface API

User Interface API로 Salesforce record data를 LWC에 가져온다. LWR 사이트는 UI API로 LWC를 개발할 때 특별히 필요한 것이 없다. 참고 토픽(LWC Developer Guide): *Use the Wire Service to Get Data*, *lightning/ui\*Api Wire Adapters and Functions*.

> **Tip — public 사이트/public page일 때** Administration workspace의 **Preferences**에서 다음을 활성화한다:
> - **Allow guest users to access public APIs** — guest user가 User Interface API를 쓰는 LWC에 접근할 수 있게 한다(기존 API 접근에 더해). 이 설정을 켜면 guest user가 Salesforce CMS·record detail page(예: Knowledge detail page)에 접근할 수 있다.
> - **Let guest users view asset files, library files, and CMS content available to the site** — guest user가 `@salesforce/contentAssetUrl`을 쓰는 LWC에 접근할 수 있게 한다.

---

## @salesforce 모듈 (전수)

LWR 사이트는 `@salesforce` 모듈을 지원해 runtime에 LWC에 기능을 추가한다.

**referential integrity:** 지원 모듈 대부분이 referential integrity를 지원한다. LWC가 object/resource 참조를 포함하면 그 dependency가 존중된다. 예:
- LWR 사이트의 LWC가 지원 모듈 참조를 포함하면, LWC를 먼저 제거하지 않고는 참조된 object를 삭제할 수 없다.
- org에서 참조된 object 이름이나 관련 data를 수정하면 시스템이 LWC의 참조를 자동으로 업데이트한다.

> **Note:** published LWR 사이트는 시스템이 참조를 **즉시** 업데이트한다. 단 unpublished 사이트는 custom component definition의 source code에 의존하며 업데이트에 **최대 2시간**이 걸릴 수 있다. 이 짧은 window 동안 컴포넌트의 참조가 일시적으로 invalid해져 LWR 사이트 publish가 불가능할 때가 있다.

다음은 PDF에 명시된 `@salesforce` 모듈 전수다. 모듈명은 PDF 원문 정확 표기를 따른다(예: `resourceUrl`·`contentAssetUrl`).

| Module | Description and Limitations |
|---|---|
| `@salesforce/apex` | Apex method를 import한다. Apex 호출은 LWR과 Aura 사이트에서 동일하게 동작한다. Apex method signature가 변경되면 사이트를 republish해야 한다. 그렇지 않으면 변경이 기존 컴포넌트를 깨뜨릴 수 있다. |
| `@salesforce/apexContinuation` | 외부 web service에 long-running request를 할 수 있는 Apex method를 import한다. Apex 호출은 LWR과 Aura 사이트에서 동일하게 동작한다. Apex method signature가 변경되면 republish해야 한다. 그렇지 않으면 변경이 기존 컴포넌트를 깨뜨릴 수 있다. |
| `@salesforce/client` | 브라우저가 실행 중인 하드웨어의 form factor(desktop, tablet, mobile)를 획득한다. |
| `@salesforce/community` | network ID나 base path 같은 사이트 정보를 획득한다. base path가 변경돼도 republish가 필요하지 않다. |
| `@salesforce/contentAssetUrl` | content asset file을 import한다. Content asset은 LWR과 Aura 사이트에서 동일하게 동작한다. live 사이트는 항상 content asset의 최신 버전을 fetch한다. content asset 이름이 변경돼도 live 사이트는 republish가 필요하지 않다. **Note:** content asset의 URL은 Aura 사이트나 Lightning Experience와 정확히 동일하지 않다. |
| `@salesforce/customPermission` | custom permission을 import하고 현재 user에 assign되었는지 확인한다. 참조된 permission의 assignment가 변경돼도 republish가 필요하지 않다. |
| `@salesforce/i18n` | internationalization property를 import한다. LWR 사이트의 경우 language·locale은 사이트에 구성된 language에 mapping되고, timezone은 user의 personal setting이 아닌 브라우저 timezone으로 결정된다. 추가로 `currency`, `number.currencySymbol`, `number.currencyFormat`은 unsupported다. 사이트 또는 org language 구성이 업데이트되면 republish해야 한다. |
| `@salesforce/label` | org의 label을 참조한다. label이 업데이트되면 republish해야 한다. **Note:** published 사이트에선 label에 referential integrity가 강제되지 않는다(publish 시점에 frozen). 단 publish 전 Experience Builder에서 LWR 사이트를 preview할 때는 항상 최신 label을 fetch한다. |
| `@salesforce/messageChannel` | Lightning Message Service API를 expose한다. Lightning Message Service는 page의 서로 다른 LWC 간에 DOM을 가로질러 message를 publish·subscribe하게 한다. 업데이트가 이루어지면 republish해야 한다. |
| `@salesforce/resourceUrl` | org의 static resource를 import한다. Resource URL은 LWR과 Aura 사이트에서 동일하게 동작한다. live 사이트는 항상 resource의 최신 버전을 fetch한다. resource 이름을 변경해도 live 사이트는 republish가 필요하지 않다. static resource의 URL은 `/webruntime/org-asset/<hash>/resource/<id>` 형식을 사용한다. |
| `@salesforce/schema` | org의 object·field·relationship 이름을 참조한다. 이 이름들 중 어느 것이 변경돼도 republish가 필요하지 않다. |
| `@salesforce/site` | site ID나 active language 같은 사이트 정보를 획득한다. 사이트 language 구성이 변경되면 republish해야 한다. |
| `@salesforce/user` | user 모듈의 `Id` property로 현재 user의 ID를 획득하거나, user 모듈의 `isGuest` property로 현재 user가 guest인지 판단한다. user가 guest user면 ID는 null 값이다. |
| `@salesforce/userPermission` | Salesforce permission을 import하고 현재 user에 assign되었는지 확인한다. 참조된 permission의 assignment가 변경돼도 republish가 필요하지 않다. |

> 자세한 내용은 *@salesforce Modules*(LWC Developer Guide) 참조. (위 14개 모듈은 PDF 표에 정확히 명시된 것이며, PDF에 없는 모듈명은 임의로 추가하지 않았다.)

---

## Lightning Navigation

`lightning/navigation` API로 사이트 내 다른 page로 navigate하고, 다른 route URL을 생성하고, 현재 `pageReference` object를 획득한다. *PageReference Types*(LWC Developer Guide) 참조. NavigationMixin 사용 패턴은 [[NavigationMixin 패턴]] 참조.

- **`comm__namedPage` 속성:** Aura 템플릿은 `name` attribute(Spring '20 추가)와 `pageName` attribute(Spring '20 deprecated)를 쓰는 `comm__namedPage` schema를 지원한다. **LWR 템플릿에선 `name` attribute만 지원한다.** page의 name은 API name이며 page 생성 중 configurable하고 page properties에 표시된다.
- **record detail page URL 동작 (LWR ≠ Aura):**
  - `standard__recordPage` 타입 page의 경우, `lightning/navigation` API로 생성된 URL은 URL path의 `recordName`으로 `detail`을 포함한다. user가 canonical URL redirect를 통해 실제 page를 방문할 때 proper record name이 사용된다.
  - 현재 user가 record detail page를 방문하지만 현재 record에 접근 권한이 없으면 canonical URL redirect가 없고 record name을 resolve할 수 없다.
  - `standard__namedPage` pageReference 타입은 지원되지 않는다. 대신 `comm__namedPage`를 사용한다.
  - LWR Commerce store에서 URL slug가 enable되면, `standard__recordPage` 타입 page에서 Category object page엔 `urlPath`, Product object page엔 `urlName`이 지원된다. `standard__recordPage` pageReference attribute에 `recordId`와 함께 Product엔 `urlName`, Category엔 `urlPath` attribute를 포함한다.

> **Tip:** link를 포함한 custom LWC를 개발할 때는 SEO best practice로 `lightning/navigation` API로 `href` 값의 URL을 생성한다. *Basic Navigation*(LWC Developer Guide) 참조.

**Limitations:**
- `comm__loginPage` pageReference 타입은 지원되지 않는다. 대신 일반 `comm__namedPage`로 login page에 navigate한다.
- `standard__recordPage` 또는 `standard__recordRelationshipPage` 타입 page로 navigate할 때 `objectApiName` attribute가 **required**다.
- `standard__recordPage` 또는 `standard__recordRelationshipPage` 타입 page로 navigate할 때 `actionName` attribute는 required로 강제되지 않는다. 단 `actionName` 포함은 권장 best practice로 유지된다.

---

## 화면 크기 반응형 컴포넌트

enhanced LWR 사이트에서는 custom LWC의 특정 property에 desktop·mobile·tablet 버전별로 별도 값을 할당할 수 있다. screen-responsive property를 쓰면 컴포넌트가 end user의 screen size에 따라 올바른 property 값을 사용한다. 다음 4단계로 진행한다.

### Step 1 — screenResponsive 선언

컴포넌트 구성 파일 `componentName.js-meta.xml`에서 **integer, string, 또는 둘 다** property를 **`screenResponsive` attribute = `true`**, **`exposedTo` attribute = `css`**로 screen-size responsive로 선언한다.

**예시 1 — custom button 컴포넌트의 maximum height:**

```xml
<!-- PDF 원문 표기 — targets 값의 언더스코어가 1개(lightningCommunity_Default). 정식은 lightningCommunity__Default -->
<targetConfig targets="lightningCommunity_Default">
<property name="test" type="String" default="Button"/>
<property name="url" type="String"/>
<property name="maxHeight" type="Integer" min="0" max="20" default="0"
screenResponsive="true" exposedTo="css"/></targetConfig>
```

**예시 2 — custom banner 컴포넌트의 child 컴포넌트 alignment:**

```xml
<!-- PDF 원문 표기 — targets 값의 언더스코어가 1개(lightningCommunity_Default). 정식은 lightningCommunity__Default -->
<targetConfig targets="lightningCommunity_Default">
<property type="Color" name="borderColor" default="" />
<property name="url" type="String"/>
<property type="String" name="bannerAlignment" default="center" screenResponsive="true"
exposedTo="css"/>
</targetConfig>
```

### Step 2 — CSS 변수·미디어 쿼리

컴포넌트의 `.css` 파일에서 CSS 변수 **`--dxp-c-screensize-property`**로 media query를 정의한다. 여기서:
- **`screensize`** = `l`(desktop), `m`(tablet), `s`(mobile).
- **`property`** = property name을 **kebab case**로.

| screensize 키 | 의미 | breakpoint (media query) | CSS 변수 패턴 |
|---|---|---|---|
| `l` | desktop | (기본 / no media query) | `--dxp-c-l-<property-kebab>` |
| `m` | tablet | `@media only screen and (max-width: 64em)` | `--dxp-c-m-<property-kebab>` |
| `s` | mobile | `@media only screen and (max-width: 47.9375em)` | `--dxp-c-s-<property-kebab>` |

**예시 1 — maximum height (property `maxHeight`) of custom button component:**

```css
/* Desktop */
div {
max-height: calc(var(--dxp-c-l-max-height)*1px);
}
/* Tablet */
@media only screen and (max-width: 64em) {
div {
max-height: calc(var(--dxp-c-m-max-height)*1px);
}
}
/* Mobile */
@media only screen and (max-width: 47.9375em) {
div {
max-height: calc(var(--dxp-c-s-max-height)*1px);
}
}
```

> [!important] screen-responsive property는 **style property에만** 적용되고 expression에는 적용되지 않는다. CSS 값으로 설정된 expression(JavaScript나 data-binding expression 등)은 runtime에 resolve되지 않는다.

**예시 2 — alignment (property `bannerAlignment`) of custom banner component:**

```css
/* Desktop */
div {
justify-content: var(--dxp-c-l-banner-alignment, center);
}
/* Tablet */
@media only screen and (max-width: 64em){
div {
justify-content: var(--dxp-c-m-banner-alignment);
}
}
/* Mobile */
@media only screen and (max-width: 47.9375em) {
div {
justify-content: var(--dxp-c-s-banner-alignment);
}
}
```

> **Note:** enhanced LWR 사이트는 각 view mode를 구분하기 위해 이 예시와 동일한 breakpoint를 사용한다. 최상의 경험을 위해 media query 정의 시 이 breakpoint를 사용한다.

### Step 3 — Experience Builder에서 값 지정

컴포넌트 property를 screen responsive로 선언한 뒤 Experience Builder에서 각 screen size별 값을 지정한다. 컴포넌트 property panel에서 icon이 screen-responsive property를 표시한다. 기본적으로 작은 screen size는 더 큰 screen size에 지정한 property 값을 inherit한다. 특정 screen size의 값을 설정하려면 navigation bar의 dropdown menu로 view mode를 전환한다.

### Step 4 — Publish

property의 screen size별 값을 지정한 뒤 사이트를 publish한다. publish 시 CSS custom variable이 생성된 컴포넌트의 **host class**에 추가된다.

**예시 — custom button 컴포넌트의 maximum height (generated host class):**

```html
<dxp_base-button data-component-id="button-0b67" slot="column"
style="--dxp-c-l-max-height:100; --dxp-c-m-max-height:80;
--dxp-c-s-max-height:60;">
...
```

이 예시에서 maximum height property는 desktop 100px, tablet 80px, mobile 60px 값을 할당받았다.

> **SEE ALSO:** Experience Cloud Help: *Assign Different Values for Desktop, Tablet, and Mobile Properties in Custom LWR Components*.

---

## 커스텀 레이아웃 컴포넌트

Build Your Own (LWR) 템플릿에서는 Aura 컴포넌트 대신 LWC로 layout을 지원한다. Aura 사이트와 같은 방식으로 custom layout을 만들 수 있으나 syntax에 minor한 변경이 있다.

> **Tip:** custom theme layout 컴포넌트가 Experience Builder용 design property를 expose하면, `js-meta.xml`의 `lightningCommunity__Default` target의 `targetConfig`에 그 property를 선언한다.

**Regions** — Slot은 web component template의 일부를 declarative하게 구성하는 새로운 방식이다. 컴포넌트에 slot이 존재하면 Experience Builder에 그것이 region임을 알린다. Named slot(`<slot name="header">`)은 Aura layout의 component attribute에 해당한다. slot에 name이 없으면 default slot으로 간주되며 Aura의 `{!v.body}`에 해당한다. LWC의 slot 사용법은 *Pass Markup into Slots*(LWC Dev Guide) 참조.

### Page Layout

Page layout 컴포넌트는 `js-meta.xml`에서 `lightningCommunity__Page_Layout` target을 사용한다.

region name이 뒤따르는 `@slot` JSDoc annotation은 page layout 컴포넌트에 어떤 slot(Experience Builder의 region)이 expose되는지 platform이 알기 위해 **required**다. 이 annotation을 컴포넌트 class 선언 바로 앞에 추가한다.

```js
// PDF 원문 표기 — extends 뒤에 공백이 들어가 있음. 실제 LWC는 LightningElement(공백 없음)
/**
* @slot contentHeaderRegion
* @slot contentRegion
* @slot contentFooterRegion
*/
export default class YourComponentName extends Lightning Element {
```

page가 올바르게 render되도록 annotation과 class 선언 사이에 inline comment나 다른 statement를 추가하지 않는다.

> **Tip:** exposed hero banner region을 가진 two-row page layout 예시는 code sample files의 `customLayoutsAndBranding/force-app/main/default/lwc/customPageLayout` 참조.

### Theme Layout

Theme layout 컴포넌트는 `js-meta.xml`에서 `lightningCommunity__Theme_Layout` target을 사용한다.

Aura theme layout 컴포넌트에선 content가 render되는 위치를 표시하기 위해 `{!v.body}`를 포함한다. 유사하게 LWC theme layout 컴포넌트에선 main content의 region을 표시하기 위해 **default slot**(name 없는 slot: `<slot></slot>`)을 반드시 포함해야 한다.

region name이 뒤따르는 `@slot` JSDoc annotation은 theme layout 컴포넌트에 어떤 slot(region)이 expose되는지 platform이 알기 위해 required다. class 선언 바로 앞에 추가한다.

```js
// PDF 원문 표기 — extends 뒤에 공백이 들어가 있음. 실제 LWC는 LightningElement(공백 없음)
/**
* @slot themeHeaderRegion
* @slot themeFooterRegion
*/
export default class YourComponentName extends Lightning Element {
```

annotation과 class 선언 사이에 inline comment나 다른 statement를 추가하지 않는다.

> **Tip:** three-column theme layout 예시는 code sample files의 `customLayoutsAndBranding/force-app/main/default/lwc/customThemeLayout` 참조. proper navigation 컴포넌트 구축의 functional 예시는 *Set Up a Navigation Menu Using Apex* 참조.

### F6 Navigation

F6 navigation은 **theme layout 컴포넌트에만** 사용할 수 있다. framework는 `data-f6-region` attribute를 가진 모든 DOM element를 F6-navigable region으로 취급한다. theme layout의 region에 F6 navigation을 enable하려면 major region에 `data-f6-region` attribute를 추가한다.

```html
<template>
<header data-f6-region style={headerStyle}>
<slot name="header"></slot>
</header>
<section data-f6-region style={sectionStyle}>
<slot></slot>
</section>
<footer data-f6-region style={footerStyle}>
<slot name="footer"></slot>
</footer>
</template>
```

> **SEE ALSO:** Video: *How to Implement Custom Layouts for LWR Sites*.

---

## 커스텀 내비게이션 메뉴 컴포넌트

Build Your Own (LWR) 템플릿은 사이트의 desktop·mobile 버전용으로 customize할 수 있는 **Navigation Menu** 컴포넌트를 포함한다. 직접 컴포넌트를 만들려면 navigation item을 가져오는 **Apex controller를 가진 custom LWC**를 만드는 것을 권장한다.

**Step 1 — Configure a Navigation Menu**
- Experience Builder에서 **Settings > Navigation** → **Add Navigation Menu** 클릭. Menu Editor에서 특정 site page를 target하는 navigation item을 추가할 수 있다.
- navigation item 추가는 **`NavigationLinkSet`** object와 그에 대응하는 **`NavigationMenuItems`**를 생성한다.
- **Note:** LWR 템플릿(Build Your Own, Microsite)은 generic record page를 포함하지 않는다. 따라서 Salesforce object에 link하는 object 또는 global action 타입 menu item을 생성하면 대응 object page도 반드시 생성해야 한다. 연관 object page를 만들지 않으면 end user가 menu item을 클릭해도 아무것도 보지 못한다.

**Step 2 — Implement the Apex Controller**
- 컴포넌트용 navigation menu를 fetch하려면, Menu Editor에서 생성한 `NavigationLinkSet`의 `NavigationMenuItems`를 가져오는 **Connect API**를 쓰는 Apex controller를 구현한다.
- 예시에서 전달하는 인자:
  - **`navigationLinkSetMasterLabel`** (또는 menu name) — 현재 사이트 nav menu의 `NavigationLinkSet.DeveloperName`을 조회하기 위함.
  - **`publishStatus`** — published 사이트 또는 draft mode 사이트의 올바른 `NavigationMenuItems`를 가져오기 위함.
  - **`addHomeMenuItem`** — Home menu item을 data에 포함할지 결정.
  - **`includeImageUrl`** — data에 image URL을 포함할지 결정.
- **Tip:** 이 Apex controller 예시는 code sample files의 `lightningNavigation/force-app/main/default/classes` 참조.

**Step 3 — Implement the Navigation Menu Component**
- Navigation Menu 컴포넌트 구현 시 제공된 code sample을 사용한다. sample 컴포넌트 설정 pointer:
  - **JavaScript:** LWC에 data를 가져오려면 `wire` annotation으로 Apex controller를 import한다.
  - **JavaScript:** Apex controller용 `publishedState`를 가져오려면 `lightning/navigation`에서 `CurrentPageReference`를 import하고 menu가 published인지 확인한다.
  - **XML:** `js-meta.xml` 파일의 `targetConfig`의 property를 통해 Navigation Menu Name을 expose할 수 있다.
  - **JavaScript:** page 간 navigate 시 `lightning/navigation`과 지원되는 다양한 page type을 reference한다.
- **Tip:** Navigation Menu 컴포넌트 예시는 code sample files의 `lightningNavigation/force-app/main/default/lwc/navigationMenu` 참조.

> **SEE ALSO:** Lightning Web Component Reference: *Navigation* / Video: *Use lightning-navigation in LWR Sites* / Video: *Build Custom Navigation and Footers for LWR Sites*.

---

## 사이트 Publish

Aura 사이트와 달리 LWR 사이트는 사이트가 unchanged여도 언제든 publish할 수 있다. org의 schema를 변경하거나 LWR 사이트에서 사용하는 컴포넌트를 업데이트할 때는 변경을 live로 만들기 위해 반드시 publish해야 한다. 그렇지 않으면 사이트가 runtime에 깨질 수 있다.

> **Note:** live 사이트에 변경을 publish할 때는 한 번에 **하나의 사이트만** publish할 수 있다. LWR 사이트 publish가 필요한 변경의 상세는 *New Publishing Model* 참조. (publish 후 캐싱·런타임 동작은 [[LWR 동작·캐싱·제약]] 참조.)

---

## 관련 노트
- [[LWR Sites (Experience Cloud)]]
- [[LWR 동작·캐싱·제약]]
- [[LWR 다국어 사이트]]
- [[LWR Expressions 레퍼런스]]
- [[LWR --dxp 스타일링 훅 레퍼런스]] — 형제 spoke(브랜딩 Ch4): `--dxp-c-*` 반응형 훅(이 노트 Ch3)과 분담 — `--dxp-g`/`--dxp-s` 전역·settings 훅 전수
- [[NavigationMixin 패턴]]
- [[@api 패턴]]
- [[Lightning Web Security (LWS)]]
