---
tags: [lwc, experience-cloud, lwr, multilingual, translation, i18n]
source: exp_cloud_lwr.pdf (LWR Sites for Experience Cloud v66.0, Spring '26, Tier 2)
created: 2026-06-20
aliases: [LWR 다국어, multilingual LWR site, add a language, fallback language, automatic language detection, PreferredLanguage cookie, default language, export import translation, .xlf, ExperienceBundle translation, RTL, Language Selector, 언어 추가, 번역 내보내기, 번역 가져오기]
---

# LWR 다국어 사이트

> LWR 사이트에 최대 40개 언어를 추가해 멀티링궐 사이트를 만드는 워크플로 — 언어 추가·fallback·기본 언어·자동 언어 감지·`.xlf` 번역 export/import.

---

## 개요

LWR 사이트에 언어를 추가하면 **multilingual LWR site**가 된다. 방문자는 Language Selector로 번역본을 전환하고, 번역되지 않은 텍스트는 fallback 언어로 표시된다. 번역 콘텐츠는 표준 `.xlf` 포맷으로 export/import한다.

> 이 노트는 [[LWR Sites (Experience Cloud)]]의 spoke다. 컴포넌트 개발·브랜딩·Experience Delivery 등은 hub 노트 참조.

---

## 번역 가능 텍스트

Salesforce가 지원하는 언어로 LWR 사이트를 번역해 **최대 40개 언어**로 사이트를 제공할 수 있다.

- LWR 템플릿에 포함된 **standard 컴포넌트**에서는 text, URL, alt text field 같은 컴포넌트 property의 text 값을 번역할 수 있다. **Rich Content Editor·HTML Editor·Text Block** 같은 컴포넌트에 담긴 text도 번역 가능. title·description·head 태그를 포함한 **SEO page property**도 번역 가능.
- 사이트에 포함한 **custom Lightning web component**는, 컴포넌트의 **js-meta.xml** 파일에서 String property를 `translatable="true"`로 정의하면 번역 가능하게 만들 수 있다.

```xml
<!-- exp_cloud_lwr.pdf 발췌 — PDF 원문 코드 (js-meta.xml, translatable property 예시) -->
<?xml version="1.0" encoding="UTF-8" ?>
<LightningComponentBundle
    xmlns="http://soap.sforce.com/2006/04/metadata">
    <isExposed>true</isExposed>
    <targets>
        <target>lightningCommunity__Page</target>
        <target>lightningCommunity__Default</target>
    </targets>
    <targetConfigs>
        <targetConfig targets="lightningCommunity__Default">
            <property type="String" name="recordId"
                default="{!Route.recordId}"/>
            <property type="String" name="pageTitle"
                translatable="true"/>
            <property type="String" name="description"
                translatable="true"/>
            <property type="String" name="customHeadTags"
                translatable="true"/>
        </targetConfig>
    </targetConfigs>
</LightningComponentBundle>
```

- 이 text field의 콘텐츠는 Experience Builder의 component property editor에서 직접 번역하거나, 사이트 콘텐츠를 export해 번역할 수 있다 — translatable로 표시한 property는 export 파일에 포함된다([[#번역 콘텐츠 내보내기·가져오기]] 참조).
- > Note: property에 **datasource attribute**를 추가하면(예: picklist 생성), 그 property는 `translatable="true"`로 정의할 수 **없다.**
- 방문자가 사이트를 볼 언어를 선택하도록 standard **Language Selector** 컴포넌트를 사이트에 추가한다.

### URL 언어 표시

방문자가 언어를 선택하면 사이트 URL이 **어느 언어를 보고 있는지 표시하도록 업데이트**된다. 예: 사이트 URL이 `https://www.UniversalTelco.my.site.com`이고 French 번역을 추가하면, 번역본 URL은 `https://www.UniversalTelco.my.site.com/fr`가 된다.

> Note: 사이트 URL에서 언어를 식별하는 데 다른 로직을 쓰거나 다른 language-selector 디자인을 원하면, **직접 Lightning web component를 작성**한다.

---

## 다국어 사이트 제약

LWR 멀티링궐 사이트에는 다음 제약이 있다.

- 일부 **Lightning base component**는 **localization을 지원하지 않아** 멀티링궐 사이트와 호환되지 않는다.
- LWR 사이트에서는 **Google Cloud Translation API를 사용할 수 없다.**
- LWR 사이트는 standard 컴포넌트에서 **right-to-left 언어를 제한적으로만 지원**한다. 이런 언어에서 최상의 고객 경험을 위해서는 **custom Lightning web component**를 사용한다.
- **enhanced LWR 사이트**에서는, 사용 가능한 언어가 **Salesforce org에서 enabled된 언어로 제한**된다. Site Languages 목록에 있던 언어가 이후 Salesforce에서 disabled되면, 그 언어의 사이트 번역은 여전히 사용자에게 보인다. 해당 번역을 업데이트할 수는 있지만, **disabled된 언어를 기본 사이트 언어로 선택할 수는 없다.**
- 드물게 사이트 번역의 URL이 **다른 사이트 URL과 의도치 않게 충돌**한다. 예: 한 번역의 URL이 원본 사이트의 특정 페이지 URL과 동일해지거나, 다른 사이트의 home page URL과 동일해질 수 있다. 전자의 경우 번역 사이트로 가는 URL이 원본 페이지 URL보다 우선하고, 후자의 경우 다른 사이트로 가는 URL이 번역·특정 페이지 URL보다 우선한다.
  > **URL 충돌 예시 1:** 사이트가 `https://UniversalTelco.my.site.com`이고, franchisees 페이지가 `https://UniversalTelco.my.site.com/fr`에 있다고 하자. 이 사이트를 French로 번역해 publish하면 French 번역본 URL도 `https://www.UniversalTelco.my.site.com/fr`가 된다. 사용자가 이 URL을 입력하면 franchisees 페이지가 아니라 **French 번역의 home page**에 도달한다.
  > **URL 충돌 예시 2:** Framingham 시의 sale을 위해 새 사이트를 `https://UniversalTelco.my.site.com/fr`에 만들면, 사용자가 그 URL을 입력했을 때 French 번역이나 franchisees 페이지가 아니라 **sale 사이트 페이지**에 도달한다.
  > **해결:** 이런 URL 충돌을 피하려면 franchisees 페이지 URL을 `/franchisees`처럼, sale 페이지 URL을 `/framingham`처럼 다른 값으로 끝나도록 변경한다.

---

## 언어 추가

방문자에게 여러 언어로 사이트를 제공하려면 먼저 Experience Builder의 **Settings 패널**에서 각 언어를 추가한다. **기본 사이트 언어를 포함해 최대 40개 언어** 제공 가능. 추가한 각 언어는 Experience Builder의 language selector에 나타나 번역본 간 이동이 쉽다. 방문자에게 번역본을 제공하려면 **Language Selector 컴포넌트**를 사이트에 추가한다.

1. Settings 패널에서 **Languages** 선택.
2. Languages 패널에서 **Edit Languages** 클릭.
3. **Edit site languages** 창에서 Available Languages 목록의 언어를 Site Languages 목록으로 옮기고 저장. 한 번에 여러 언어 추가 가능. **enhanced LWR 사이트에서는 추가 가능한 언어가 org에서 enabled된 언어로 제한**된다.
   > Note: LWR 사이트의 **standard 컴포넌트는 right-to-left(RTL) 언어 지원이 제한적**이다. 해당 언어의 최상 경험을 위해 **custom Lightning web components**를 사용하라.
4. 방문자에게 언어를 노출하려면 Languages 패널에서 **Activate and show in the language selector** 선택.
   > Tip: 해당 언어로 콘텐츠를 publish할 준비가 될 때까지 이 옵션을 해제해 둔다.
5. (선택) 추가한 각 언어의 **fallback 언어** 지정. publish된 멀티링궐 사이트에서 방문자가 선택한 언어로 번역되지 않은 텍스트는 fallback 언어로 표시된다. 예: French·French (Canadian) 추가 시 French (Canadian)의 fallback을 French로 지정 가능. fallback을 지정하지 않으면 **기본 사이트 언어**가 fallback이 된다.

**fallback 규칙:**
- 멀티링궐 사이트는 **1단계(one level) fallback만 지원**. 예: French (Canadian)이 French로 fallback하면, French의 fallback은 사이트 기본 언어만 허용된다.
- Experience Builder가 **fallback loop를 방지**한다. 예: French가 French (Canadian)의 fallback이면, French (Canadian)은 French의 fallback으로 선택 불가. 마찬가지로 French (Morocco)의 fallback이 French (Canadian)이면 French (Morocco)도 French의 fallback 불가.
- **enhanced LWR 사이트에서는, fallback 언어가 지정된 언어는 그 자체가 다른 언어의 fallback이 될 수 없다.** 예: French를 French (Canadian)의 fallback으로 지정하면, French (Canadian)은 어떤 언어의 fallback도 될 수 없다.

6. (선택) language selector에서 언어가 어떻게 나열될지 결정하려면 **사이트 언어 label을 커스텀**. Site Languages 목록 순서는 grabber 아이콘으로 재배열하며, 이 순서가 Experience Builder·사이트의 language selector 순서에 반영된다. Experience Builder에서 다른 언어로 사이트를 보려면 language selector 사용.

---

## 기본 언어 / 언어 삭제

### 기본 언어 설정

LWR 사이트 생성 시 **기본 사이트 언어는 English (US)**다. 다른 기본 언어로 바꾸려면 **콘텐츠 손실을 피하기 위해 사이트 생성 직후 가능한 한 빨리** 변경한다.

- 기본 사이트 언어를 변경하면 **원래 기본 언어의 모든 콘텐츠가 제거**된다. 새 기본 언어로 번역된 콘텐츠가 있으면 그것도 제거된다. 따라서 기본 언어 업데이트 전까지 양쪽 언어로 추가하는 콘텐츠를 최소화하는 것이 좋다.
- 절차: Settings > Languages → 의도한 새 기본 언어를 아직 추가하지 않았으면 추가 → 해당 언어의 actions 메뉴에서 **Set as default site language** → 확인 창에서 Change. **enhanced LWR 사이트에서는 org에서 disabled된 언어는 기본 언어로 선택 불가.**
- > Note: 사이트에 **Salesforce CMS 콘텐츠**를 추가할 계획이면, 콘텐츠가 올바르게 표시되도록 **사이트와 CMS workspace의 기본 언어가 동일**해야 한다. 다르면 CMS workspace 콘텐츠를 사이트 기본 언어로 번역한 뒤 추가한다.
- > Note: 콘텐츠를 보존하려면 기본 언어 변경 전에 번역을 export한다. 결과 **`.xlf`** 파일은 양쪽 언어 콘텐츠를 담는다 — 원래 기본 언어 텍스트는 **`<source>`** 태그, 의도한 새 기본 언어 텍스트는 **`<target>`** 태그 안에 들어간다. 이 파일은 사이트로 다시 import할 수 없지만, 텍스트를 Experience Builder의 각 component property editor 패널에 붙여넣을 수 있다.

### 언어 삭제

추가한 언어를 삭제할 수 있다. Settings > Languages → Site Languages 목록에서 해당 언어의 actions 메뉴 > **Delete site language**(또는 Edit site languages 창에서 삭제) → Available Languages 목록으로 옮기고 저장.

- 사이트 언어를 삭제하면 **그 언어의 번역 콘텐츠와 language selector 목록도 함께 삭제**된다. 번역 콘텐츠를 보존하려면 삭제 전에 export한다.
- 다른 번역의 **fallback으로 지정된** 사이트 언어를 삭제하면, 그 번역의 fallback이 **사이트 기본 언어로 전환**된다. 이후 다른 사이트 언어로 fallback을 변경할 수 있다.

---

## 자동 언어 감지

고객이 LWR 사이트에 접근하면 브라우저 설정의 localized 언어로 사이트를 본다. **자동 언어 감지는 LWR 사이트를 republish하고 사이트에 localized 버전이 있을 때 동작**한다.

- 예: 기본 언어 English + French 버전이 있는 사이트. **guest 사용자는 브라우저 기본 언어**, **인증 사용자는 user profile에 설정된 언어**로 본다.
- **기본적으로 org에서 켜져 있음.** 끄려면 Salesforce Customer Support에 문의.
- **`PreferredLanguage` cookie**가 설정되면, 사용자가 language selector로 바꾸거나 cookie가 삭제될 때만 언어가 변경된다. 그 외에는 현재 사용자의 기본 언어 설정과 일치하지 않더라도 cookie에 지정된 언어를 계속 사용한다.
- 사이트가 user profile 언어나 브라우저 기본 언어를 지원하지 않으면 **기본 사이트 언어**로 표시.
- org가 **IdP initiated SSO**(한 사이트→다른 사이트)를 쓰면 자동 언어 감지가 **동작하지 않는다**.
- guest·인증 사용자가 Language Selector로 언어 선호를 바꾸면, 다음 접근 시 새 선호가 적용된다.
- 자동 언어 감지는 사용자가 **locale path prefix 없이** 사이트에 접근할 때만 일어난다. 예: `www.salesforce.com/siteprefix/`는 자동 리다이렉트되지만, `www.salesforce.com/siteprefix/fr/`는 French 사이트로 간다.
- 사용자가 사이트에 로그인하면 cookie locale이 즉시 설정된다. user locale을 바꿔도(언제도 Language Selector를 쓰지 않았다면) 언어 선호는 바뀌지 않는다.
- 자동 언어 감지는 **functional cookie에 의존**한다. functional cookie가 disabled면 사이트가 사용자 언어 선호를 감지/저장할 수 없다.

**언어 선호 우선순위 (1이 최우선):**

| 우선순위 | 소스 |
|---|---|
| 1 | Locale path prefix |
| 2 | Cookie locale |
| 3 | User Profile's set locale |
| 4 | Browser locale |

---

## 번역 콘텐츠 내보내기·가져오기

### 내보내기 (Export)

언어를 추가한 후, localization 팀/벤더에 보내기 위해 사이트 콘텐츠를 export할 수 있다. LWR 사이트 콘텐츠는 third-party 번역 소프트웨어와 호환되는 표준 **`.xlf`** 포맷으로 export된다. 원래 기본 언어 콘텐츠는 **`<source>`** 태그, 번역 콘텐츠는 **`<target>`** 태그 안에 들어간다.

```xml
<!-- exp_cloud_lwr.pdf 발췌 — PDF 원문 코드 (.xlf 발췌, English US 기본 + French 번역) -->
<segment id="title">
    <source>Subscribe to our newsletter!</source>
    <target>Inscrivez-vous à notre newsletter!</target>
</segment>
<segment id="headline">
    <source>We'll send you our latest news.</source>
    <target>On vous apporte nos dernières nouvelles.</target>
</segment>
<segment id="description">
    <source>No need to search. Get all our news every week in your mailbox.</source>
    <target>Plus besoin de chercher. Recevez toute notre actu chaque semaine dans votre boîte mail.</target>
</segment>
```

- > Note: **Summer '22 이전에 export**했다면 다시 export해야 한다 — 최신 `.xlf` 포맷으로 작업해야 하며, 구버전 `.xlf`는 사이트로 업로드할 수 없다.
- 절차: Settings > Languages > **Export Content** → Export site content 창에서 언어 선택(이름 입력 선택) → Export. 한 번에 여러 언어 export 가능. 모든 언어가 하나의 `.zip`으로 export되며, `.zip` 안에서 각 언어가 자체 `.xlf` 파일로 들어간다.
- **export 파일은 CMS 콘텐츠와 사이트 navigation menu 항목을 포함하지 않는다.** CMS 콘텐츠는 Digital Experiences 앱의 CMS Workspace에서 번역하고, navigation menu 항목은 **Translation Workbench**로 번역한다.
- > Note: export 후에는 기본 언어 텍스트를 업데이트하지 말 것 — 번역은 업데이트 이전(pre-updated) 버전 기준이다.
- `.xlf`는 컴포넌트 js-meta.xml에서 **`translatable="true"`**로 정의된 속성 값을 포함한다. 단 **empty String 값은, translatable로 표시돼 있어도 제외**된다(번역할 텍스트가 없으므로).
- HTML Editor 컴포넌트를 쓰거나 SEO head 태그를 추가하면, `.xlf`는 그 HTML 텍스트도 포함한다. **HTML 태그를 포함**하는 이유는 태그가 placeholder text 같은 번역 필요 속성을 담기도 하기 때문이다. 번역가는 HTML 태그에 익숙해 무엇을 번역하고 무엇을 둘지 알아야 한다(예: `Enter your email address`만 번역).

### 가져오기 (Import)

번역을 Experience Builder의 component property editor 패널에 직접 입력하거나, 사이트 콘텐츠를 export 후 번역한 `.xlf`를 import할 수 있다.

- Experience Builder에서는 **`.xlf` 파일로만** import 가능. **각 파일은 하나의 번역만** 담을 수 있고, 한 번에 하나의 `.xlf`만 import. **1MB 초과** 파일 업로드는 몇 분 걸릴 수 있으며, 그 경우 완료 시 **이메일로 알림**.
- > Note: **Summer '22 이전 export**라면 다시 export(위와 동일).
- 사이트 번역 import는 **해당 언어의 기존 콘텐츠를 overwrite**하지만, **기본 언어 콘텐츠나 다른 언어 콘텐츠는 overwrite하지 않는다.**
- 번역 중에는(컴포넌트 추가·제거 포함) 사이트를 업데이트하지 말 것 — 번역은 업데이트 이전 버전 기준이다.
- 절차: Settings > Languages > **Upload File**로 번역 파일 탐색(또는 Drop File에 드래그) → language selector에서 해당 언어 선택해 번역 콘텐츠 확인.
- export 파일은 CMS 콘텐츠·navigation menu 항목을 포함하지 않았으므로, CMS 콘텐츠는 CMS Workspace에서, navigation menu는 **Translation Workbench**로 번역한다.
- > Note: **ExperienceBundle**을 사용해 프로그래매틱하게 번역을 import할 수도 있다(*Metadata API Developer Guide*의 ExperienceBundle 참조).

---

## 관련 노트

- 📖 공식: [LWR Sites for Experience Cloud](https://developer.salesforce.com/docs/atlas.en-us.exp_cloud_lwr.meta/exp_cloud_lwr/)
- [[LWR Sites (Experience Cloud)]] — hub: LWR 사이트 컴포넌트 개발·브랜딩·Experience Delivery
- [[Lightning Knowledge 다국어 & 번역]] — peer: 번역 워크플로(Translation Workbench·언어 추가)
- [[Metadata API 빌드·릴리스 워크플로]] — ExperienceBundle 프로그래매틱 import
- [[LWR 동작·캐싱·제약]] — 형제 spoke: 퍼블리싱 모델·캐싱·LWR Template Limitations(RTL 언어 제약 등)
