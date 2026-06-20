---
tags: [lwc, experience-cloud, lwr, sites, caching, publishing, limitations, accessibility, dxp]
source: exp_cloud_lwr.pdf (LWR Sites for Experience Cloud v66.0, Spring '26, Tier 2)
official_doc: https://developer.salesforce.com/docs/atlas.en-us.exp_cloud_lwr.meta/exp_cloud_lwr/
created: 2026-06-20
aliases: [LWR caching, LWR caching policy, Caching TTL, CDN cache, LWR publishing model, new publishing model, frozen components, republish, Which Features Are Affected, custom URL paths, /s 제거, vforcesite, unauthenticated site, head markup, basePath, versionKey, Light DOM, shadow to light DOM, third-party analytics, LWR limitations, LWR Template Limitations, Unsupported Features, 500 routes, 250 routes, dynamic import, statically analyzable, asset files in sandbox, F6 navigation, screen reader, ARIA-Live, LWR 캐싱, 퍼블리싱 모델, 컴포넌트 동결, 커스텀 URL, head 마크업, 라이트 DOM, LWR 제약, 다이내믹 임포트, 샌드박스 에셋, 접근성]
---

# LWR 동작·캐싱·제약

> LWR 사이트의 페이지·컴포넌트 구성, Aura 대비 **동작 차이**(새 퍼블리싱 모델·커스텀 URL 경로·캐싱 정책·head markup·접근성), 그리고 **LWR Template Limitations** 전수 — Build Your Own (LWR)·Microsite (LWR) 템플릿으로 사이트를 만들기 전 검토해야 할 제약을 한곳에 모았다.

---

## 개요

이 노트는 [[LWR Sites (Experience Cloud)]] 허브의 **런타임 동작·제약** 영역을 전수로 다룬다. LWR 템플릿(Build Your Own (LWR)·Microsite (LWR))은 essential한 out-of-the-box 페이지·컴포넌트만 제공하며, Aura 사이트와는 퍼블리싱·URL·캐싱·head markup·접근성 측면에서 동작이 다르다. 시작 전 LWR Template Limitations 섹션을 검토해 템플릿이 요구사항을 지원하는지 확인한다.

---

## Pages and Components

Build Your Own (LWR)·Microsite (LWR) 템플릿은 **가장 essential한 out-of-the-box 페이지·컴포넌트만** 제공한다.

### Site Pages

LWR 템플릿은 보통 다음 template 페이지를 포함하므로, 동작하는 사이트를 만들려면 흔히 추가 custom 페이지를 만들어야 한다.

- Home
- Error
- Check Password
- Forgot Password
- Login
- Register
- News Detail (enhanced LWR 사이트에서만 제공)

### Page Components · startURL/autofill · 민감정보 주의

LWR 템플릿과 함께 여러 컴포넌트가 제공되지만, 목표를 달성하려면 흔히 custom Lightning web component를 만들어야 한다. LWR 템플릿에서 바로 쓸 수 있는 컴포넌트는 Salesforce Help의 *Standard Components for LWR Templates* 참조.

> Tip: LWR 템플릿에서는 **`startURL` query parameter가 모든 login·page redirect에 전파**된다. 또한 login input 필드와 password manager에 대해 **autofill이 활성화**되어 있다.

> Warning: Experience Builder로 login 페이지나 민감/기밀 정보를 포함하는 필드가 있는 페이지를 커스터마이즈할 때는, **Salesforce가 만든 standard 컴포넌트** 또는 본인이 만들거나·커스터마이즈하거나·검증한(vetted) 컴포넌트만 사용할 것을 권장한다. 민감/기밀 정보 필드가 있는 페이지에서 third-party 컴포넌트·코드 라이브러리를 사용하면 보안 취약점 위험이 커질 수 있다.

### Light DOM

Spring '22 이전에는 LWR 템플릿의 standard Lightning web component가 기본적으로 **shadow DOM**(Document Object Model)으로 렌더링되어, third-party analytics 서비스 통합이 어려웠다. 이제 이 템플릿들과 일부 컴포넌트가 **light DOM**으로 활성화된다. light DOM으로 활성화된 LWC에서는 document root에서 DOM 요소를 query할 수 있어 DOM traversal이 쉬워진다. 이 컴포넌트들 내부에서 이벤트를 listen하고, Google Analytics 같은 여러 third-party analytics 서비스로 이벤트를 보낼 수 있다.

기존 LWR 사이트에서 light DOM을 활용하려면 사이트를 **republish**한다.

> shadow DOM ↔ light DOM 모드 메커니즘 상세는 [[LWC Shadow DOM 모드]] 참조.

---

## Differences in Behavior — 개요

LWR 템플릿에서는 일부 동작이 Aura 템플릿과 조금 다르다. 아래 6개 하위 항목으로 정리된다(각 상세는 해당 섹션).

| 차이 | 한 줄 요약 |
|---|---|
| **New Publishing Model** | 컴포넌트가 publish 시 frozen되어 runtime에 정적으로 served된다. → 아래 *New Publishing Model* |
| **Custom URL Paths** | Aura와 달리 `/s` 없는 custom URL 경로 지원. → 아래 *Custom URL Paths* |
| **Lightning Web Security (LWS)** | Lightning Locker 대신 LWS(LWC용 신규 보안 아키텍처) 사용. cross-namespace 통신 지원. → [[Lightning Web Security (LWS)]] 위임 |
| **Caching Policy** | 초기 document 요청·data API 호출을 제외한 모든 요청이 HTTP cacheable. → 아래 *Caching Policy* |
| **Head Markup** | 페이지 head markup을 완전히 제어. Head Markup 창에서 기본 markup 접근. → 아래 *Head Markup* |
| **Accessibility** | screen reader 지원·F6 navigation 등 접근성 기능. → 아래 *Accessibility* |

---

## New Publishing Model

LWR 사이트는 **새 퍼블리싱 패러다임**을 활용한다 — 사이트가 published될 때 컴포넌트가 **frozen**되고 runtime에 **정적으로 served**된다. 이 방식은 컴포넌트·데이터를 최대한 효율적으로 전달하지만, 사이트를 관리하고 컴포넌트를 작성할 때 몇 가지 caveat·limitation을 동반한다.

### Aura(dynamic) vs LWR(publish 필요)

Aura 사이트에서는 Lightning 컴포넌트(Lightning web components·Aura components 둘 다)가 **dynamic하게** 전달된다. 그래서 Aura 사이트에서 현재 사용 중인 custom 컴포넌트를 업데이트하면, 사이트를 publish하지 않아도 변경 사항이 즉시 라이브로 반영된다. 그러나 **LWR 사이트에서는 버그 수정·신규 기능 등 어떤 변경이라도 standard·custom·managed 컴포넌트에 전파되려면 사이트를 반드시 publish해야 한다.**

> Note: Experience Builder에서 사이트를 **preview**할 때는 Lightning web component가 **dynamic하게** served되므로, preview는 항상 컴포넌트·데이터의 최신 버전을 보여준다.

### Which Features Are Affected?

새 퍼블리싱 모델이 어떤 기능에 영향을 주는지 정리한다.

| Feature | republish 필요 시점 (You must republish your LWR site...) |
|---|---|
| **Lightning web components** | 다음의 경우: ① LWR 사이트에서 사용 중인 Lightning web component를 업데이트할 때 ② Salesforce가 out-of-the-box 컴포넌트를 업데이트할 때. republish하기 전까지 사이트는 이전에 published된 컴포넌트의 source code 버전을 사용하므로, runtime에 이슈가 생길 수 있다. |
| **Managed package components** | 사이트에 이미 있는 managed package의 컴포넌트를 업그레이드할 때. republish하기 전까지 사이트는 이전에 published된 컴포넌트의 source code 버전을 사용하므로, runtime에 이슈가 생길 수 있다. |
| **Labels** | custom label을 업데이트하거나, Salesforce로부터 갱신된 label을 받고 싶을 때. |

---

## Custom URL Paths

Aura 사이트와 달리, LWR 사이트는 **custom URL 경로**를 지원한다 — 사이트 URL에 `/s`가 끼어들지 않는다. 예: `https://mycustomdomain.com/mypage`.

- **Winter '23 이전:** authenticated 또는 unauthenticated LWR 사이트를 만들 수 있었다. Unauthenticated 사이트는 custom URL 경로를 지원했으나, authenticated 사이트는 base URL 끝에 `/s`가 포함되었다. 예: `https://mycustomdomain.com/s/mypage`.
- **Winter '23 이후:** 생성된 LWR 사이트는 URL에 더 이상 `/s`를 포함하지 않으며, **기본적으로 authenticated 사이트**다. Authenticated 사이트는 사용자가 로그인해 user-specific 데이터에 접근하게 하지만, 공개 페이지를 포함하거나 사이트 전체를 공개로 만들 수도 있다.
- **Visualforce 접근:** `/s`를 쓰지 않는 사이트도 base URL에 **`vforcesite`**를 append해 Visualforce 페이지에 접근할 수 있다. 예: `https://mycustomdomain.com/vforcesite/mypage`. `vforcesite` URL은 Setup > Custom URLs에서도 확인 가능.

> Note: Winter '23 이전에 만들어진 **unauthenticated LWR 사이트**는 웹의 누구에게나 열려 있고 login·authentication을 지원하지 않는다. 따라서 Administration workspace의 **Members, Contributors, Login & Registration, Emails** 영역은 unauthenticated 사이트에 적용되지 않으므로 사용할 수 없다.

---

## Caching Policy

LWR 사이트는 라이브 사이트의 성능·확장성을 높이기 위해 caching을 적극 활용한다. **초기 document 요청과 data API 호출을 제외하면, 페이지를 로드하는 데 필요한 모든 요청이 HTTP cacheable**이다.

사이트가 published되면 JavaScript 리소스가 생성·persist되고, runtime에 **static·immutable·cacheable** 리소스로 served된다. 어떤 리소스든 사이트의 public 페이지를 통해 접근 가능하면 publicly cacheable이다. Salesforce **content delivery network(CDN)**가 활성화되면, publicly cacheable한 리소스가 CDN에 캐시되어 성능이 더 향상된다.

### Caching TTL

caching time to live(TTL) 값에 대한 상세 정보다.

| Resource | HTTP Caching Policy | Description |
|---|---|---|
| **Generated framework scripts, views, and components** | 150 days | 사이트의 framework scripts·views·components는 사이트가 published될 때 생성·persist된다. 그 내용이 변경되면 resource URL이 변경되며, 이는 사이트가 republished될 때 캐시를 wipe한다. |
| **HTML document** | 1 minute | HTML document caching은 Salesforce CDN으로 구성된 org에서만 활성화된다(*Enable CDN to Load Applications Faster* 참조). Salesforce first-party CDN은 HTML document 응답을 **60초** 동안 캐시한다. downstream 영향을 막기 위해, CDN에서 오는 응답은 cache 헤더가 **private, must-revalidate, max-age 0**으로 설정된다. 단, 사이트가 published되는 동안에는 HTML document caching이 비활성화된다. 사이트가 published된 후 max-age TTL이 만료되기 전 구간에 stale HTML document가 served되는 것을 피하려면 **off-peak hours에 publish**할 것을 권장한다. |
| **Permissions** | 5 minutes | Permissions scoped 모듈(`@salesforce/userPermission/`·`@salesforce/customPermission/`)은 HTML에 포함되지 않는다. 대신 별도 리소스로 fetch된다. 이 리소스들은 **per-user 기준으로 5분** 동안 cacheable하다. |
| **Org assets** | 1 day | Salesforce static resources(`@salesforce/staticResource/`)와 content assets(`@salesforce/contentAsset/`)에 대한 요청은 max-age cache 헤더가 **1일**로 설정된다. |

---

## Head Markup

LWR 사이트에서는 페이지에 포함되는 head markup을 **완전히 제어**한다. Head Markup 창을 열면 다음 기본 markup에 접근할 수 있다.

```html
<!-- exp_cloud_lwr.pdf 발췌 -->
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Welcome to LWC Communities!</title>
<link rel="stylesheet" href="{ basePath }/assets/styles/styles.css?{ versionKey }" />
<!-- webruntime-branding-shared stylesheets -->
<link rel="stylesheet" href="{ basePath }/assets/styles/salesforce-lightning-design-system.min.css?{ versionKey }" />
<link rel="stylesheet" href="{ basePath }/assets/styles/dxp-site-spacing-styling-hooks.min.css?{ versionKey }" />
<link rel="stylesheet" href="{ basePath }/assets/styles/dxp-styling-hooks.min.css?{ versionKey }" />
<link rel="stylesheet" href="{ basePath }/assets/styles/dxp-slds-extensions.min.css?{ versionKey }" />
<!-- webruntime-branding-shared stylesheets -->
```

Aura 사이트에서는 이 markup이 Head Markup 창에 노출되지 않지만, LWR 사이트에서는 다음을 편집할 수 있다.

- **`meta charset` 태그** — 사용할 character set을 지정. 이 지정은 best practice다.
- **`title` 태그** — 브라우저 탭에 표시되는 사이트의 기본 title을 제어.
- **default style sheet로의 링크** — 사이트 외관을 제어. 한 링크는 Salesforce Lightning Design System(SLDS)용이고, 나머지는 base template이 쓰는 internal style sheet다. style sheet를 직접 편집할 수는 없지만 제거할 수는 있다.

> Tip: 이 섹션에서 **`<x-oasis-script>`** privileged script 태그를 사용해 third-party 라이브러리의 global JavaScript를 포함할 수도 있다. (Privileged Script Tag 상세는 [[Lightning Web Security (LWS)]] 참조. `<x-oasis-script>`로 Google Tag Manager를 연결하는 실제 head markup 예제는 [[LWR Tag Manager 데이터 관리]] 참조.)

**`{ basePath }`·`{ versionKey }`** 변수 reference는 head markup에서 원하는 대로 사용할 수 있다. 예를 들어 사이트 URL이 `https://site.acme.com/service`라면 `{ basePath }`는 `service`를 반환하므로 relative URL을 참조할 수 있다. `{ versionKey }`는 현재 published 상태를 가리키는 고유 id로, caching·성능 목적에 사용할 수 있다. 사이트가 republish될 때마다 versionKey가 변경된다.

---

## Accessibility

LWR 사이트는 screen reader 지원·F6 navigation 등 중요한 접근성 기능·best practice를 포함한다.

### F6 Navigation

F6 navigation은 키보드나 screen reader로 웹페이지를 탐색하기 쉽게 한다. 특정 요소에 도달하는 데 여러 keystroke가 필요할 수 있는 Tab 키와 달리, **F6을 누르면 사용자가 먼저 서로 다른 region 간을 이동**할 수 있다. 그 다음 Tab 키로 해당 region 안의 컴포넌트로 좁혀 들어간다.

out-of-the-box Header·Footer theme layout 컴포넌트의 주요 섹션이 F6 navigation에 활성화되어 있다. custom theme layout의 region에서 F6 navigation을 활성화하려면 *Create Custom Layout Components* 참조.

### Screen Reader Support

LWR 사이트는 **single page application(SPA)** — 하나의 HTML 페이지를 로드하는 웹 앱 — 에서 실행된다. 페이지 업데이트는 DOM(Document Object Model)을 수정해 navigation을 시뮬레이션하는 JavaScript가 처리하는데, 이는 screen reader에 문제를 일으킬 수 있다.

그래서 SPA navigation을 제대로 인식하도록 screen reader에 정보를 제공한다. navigation이 일어나면 페이지의 title이 **ARIA-Live region**을 통해 announce된다. theme layout이 동일하게 유지되면 사용자의 focus가 content 영역으로 복귀하고, theme layout이 변경되면 사용자의 focus가 페이지 상단으로 복귀한다.

---

## LWR Template Limitations

LWR 템플릿은 Aura 템플릿과 동일한 기능을 포함하지 않는다. 사이트 생성을 시작하기 전에 현재 차이점·제약을 확인한다.

### Unsupported Features

다음 항목은 사용할 수 없다(전수 16항).

1. Aura 템플릿에서 제공되는 여러 default 컴포넌트·페이지 — 예: Chatter feeds
2. 일부 preconfigured standard 페이지 — *Account Management* 같은 페이지는 custom 페이지를 만들 때 사용된다 *(원문: "Some preconfigured standard pages, such as Account Management, are used when creating custom pages")*
3. Default themes·theme management
4. standard 컴포넌트에서의 Right-to-left 언어
5. Progressive rendering
6. 사이트 root domain에서의 favicon 변경
7. Template·page·theme export 및 Lightning Bolt Solutions
8. Template-level 접근성 기능 — 예: skip link
9. Aura 템플릿에서 제공되는 App-level events (단, `CustomEvent`는 사용 가능)
10. Lightning Component Library의 일부 base components·기능
11. `@salesforce/i18n` 모듈의 일부 property
12. Mobile 및 `$Browser` 같은 value provider
13. `ExperienceBundle` metadata type의 `pageAccess` property
14. Session timeout alerts
15. Salesforce Community Page Optimizer
16. Surveys

### Experience Workspaces 제약

**Administration, Builder, Dashboards, Guided Setup** 워크스페이스만 사용할 수 있다.

### Experience Builder 제약

- toolbar에서 Undo·Redo 버튼과 일부 Help 옵션을 사용할 수 없다.
- Theme 패널에서 branding sets·theme settings·CSS editor를 사용할 수 없다. section palette 생성·head markup에 style sheet 추가 같은 대안은 *Brand Your LWR Site* 참조.
- enhanced LWR 사이트에서는 Components 팔레트에 모든 컴포넌트를 표시하려면, Experience Builder를 열거나 reload할 때마다 Advanced 패널에서 **Show all components**를 활성화해야 한다.
- 컴포넌트 작업 시 property editor의 일부 hover 액션·action menu 옵션을 사용할 수 없다.
- Experience Builder에서 사이트를 preview하는 동안 레코드를 수정하면, 이전 페이지로 navigate할 때 가끔 stale record data가 보인다. 이 문제를 해결하려면 브라우저를 refresh한다.
- Experience admin은 자신이 접근 권한이 없는 object의 record 페이지를 Experience Builder에서 접근할 수 없다.

### Route 수 제한

LWR 사이트는 **최대 500 routes**(고유 URL)를 지원한다. best performance를 위해 **route 수를 250 미만**으로 유지한다. dynamic content가 route 수를 낮게 유지하는 데 도움이 된다. 예를 들어 content item마다 고유 route를 가진 개별 페이지를 만들지 말고, record detail로 content를 표현한 뒤 record detail을 보여주며 하나의 route만 필요로 하는 단일 페이지를 만든다.

### Enhanced LWR — Referential Integrity

enhanced LWR 사이트에서는 object route의 **object API name에 대한 referential integrity가 미지원**이다. 페이지 컴포넌트가 참조하는 object의 이름을 변경(rename)하면, 그 object로의 연결이 깨진다.

### Dynamic Import 제약

LWR 사이트에서 Lightning web component를 dynamic하게 import·instantiate할 수 있다. 단, LWR 사이트는 **statically analyzable한 dynamic import만** 지원한다.

```javascript
// 구조 예시 — 실제 동작 코드 아님 (exp_cloud_lwr.pdf 본문 인용)
// [sic] PDF 원문 curly quote(" ")는 straight quote로 정규화함
import("c/analyzable")              // 작동함
import("c/" + "analyzable")         // 미작동 — statically analyzable하지 않음
import("c/" + componentName)        // 미작동
import("c/" + componentNameVariable)// 미작동
```

`import("c/analyzable")`는 작동하지만, `import("c/" + "analyzable")`는 statically analyzable하지 않아 작동하지 않는다. 마찬가지로 `import("c/" + componentName)` 또는 `import("c/" + componentNameVariable)`도 작동하지 않는다.

### LWS Properties 제약

LWR 사이트는 Lightning Locker 대신 LWS(Lightning Web Security)를 사용한다. LWR 사이트의 LWS에서 현재 지원되지 않는 property는 다음과 같다.

- `document.domain`
- `document.location`
- `window.location`
- `window.top`

> LWS 보안 아키텍처 전반은 [[Lightning Web Security (LWS)]] 참조.

### Asset Files in Sandbox

**Full·Partial Copy sandbox**는 다른 content entity와 함께 asset file을 지원할 수 있다. asset file은 **Developer·Developer Pro sandbox에서는 미지원**이다. Full·Partial Copy sandbox용 sandbox template을 정의할 때 template에서 **Content Body**도 선택해야 한다.

미지원 sandbox의 경우, 사이트에 `@salesforce/contentAsset` reference를 가진 Lightning web component가 포함되어 있으면, 그 reference가 sandbox org의 사이트에서 깨진다. LWR 사이트에서는 해당 컴포넌트가 render되지 못하며, 페이지에서 그 컴포넌트를 삭제하거나 컴포넌트에서 asset reference를 제거하기 전까지 사이트를 publish할 수 없다. Aura 사이트에서는 import된 reference가 invalid URL로 resolve된다.

---

## 관련 노트

- [[LWR Sites (Experience Cloud)]] — LWR 사이트 hub
- [[LWR 컴포넌트 개발 심화]] — 형제 spoke(컴포넌트 개발): `js-meta.xml` 타깃·`targetConfigs`·`@salesforce` 모듈·화면 반응형·커스텀 레이아웃 (publish 후 동작은 이 노트가 다룸)
- [[Lightning Web Security (LWS)]] — LWS 보안 아키텍처(Differences·x-oasis-script 위임)
- [[LWR 다국어 사이트]] — 형제 spoke(다국어)
- [[LWR Expressions 레퍼런스]] — 형제 spoke(표현식·dynamic 데이터)
- [[LWR Tag Manager 데이터 관리]] — 형제 spoke(데이터): head markup의 `<x-oasis-script>`로 Google Tag Manager를 연결하는 실제 예제·네이티브 Experience Tag Manager
- [[LWC Shadow DOM 모드]] — Light DOM·shadow→light 전환
- [[SLDS LWC 디자인 시스템]] — head markup SLDS 스타일시트
- [[Static Resource 로딩]] — 정적 리소스·contentAsset
- [[Metadata API 빌드·릴리스 워크플로]] — ExperienceBundle·pageAccess
