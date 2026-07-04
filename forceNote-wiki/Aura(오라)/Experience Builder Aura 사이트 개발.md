---
tags: [Aura, ExperienceCloud, ExperienceBuilder, Community, forceCommunity, ThemeLayout, 사이트개발]
source: communities_dev.pdf (Experience Cloud Developer Guide, v66.0 Spring '26) · Salesforce Help: Enable Digital Experiences (help.salesforce.com articleView id=experience.networks_enable.htm) [Tier 2]
created: 2026-06-21
aliases: [Experience Builder Aura 개발, Experience Builder Aura 컴포넌트 만들기, forceCommunity 인터페이스, availableForAllPageTypes, 커스텀 테마 레이아웃, themeLayout, Aura 사이트 expression, CurrentUser expression, swappable search profile menu, Aura 드래그앤드롭 컴포넌트, design resource Experience Builder, Personalization Target Developer Name, Aura 사이트 브랜딩, Experience Cloud Aura 사이트, 익스피리언스 빌더 Aura, 개인정보 표시 설정, PII 숨기기 Experience, UserPreferencesShowEmail, UserPreferencesShowEmailToExternalUsers, UserPreferencesShowEmailToGuestUsers]
---

# Experience Builder Aura 사이트 개발

> Aura Components 모델 기반 Experience Builder 사이트에서 커스텀 Aura 컴포넌트를 드래그앤드롭 가능하게 만들고(`forceCommunity:*` 인터페이스), 테마 레이아웃·검색/프로필 메뉴를 스왑하고, expression으로 동적 데이터를 표시하는 방법.

---

## ⚠️ 전제조건 — Digital Experiences 활성화 (사이트 생성 전 선행)

이 노트의 모든 개발(Experience Builder 사이트·드래그앤드롭 커스텀 Aura 컴포넌트·테마 레이아웃)은 org에 **Digital Experiences가 이미 활성화되어 있음을 전제**한다. 활성화·도메인 없이는 Experience Builder 자체가 존재하지 않으므로, 사이트 생성 전에 아래를 먼저 완료해야 한다.

1. **Setup → Digital Experiences → Settings**로 이동해 **Enable Digital Experiences**를 켠다. 이것이 Experience Cloud 사이트 생성의 **첫 단계**다.
2. **도메인 이름을 등록**한다(예: `myorg.my.site.com`). Digital Experiences 도메인(또는 커스텀 도메인)을 구성해야 사이트 URL이 발급된다.
3. 활성화 후에야 Experience Builder·템플릿·`forceCommunity:*` 인터페이스 기반 컴포넌트 개발이 가능해진다.

> **비가역성 (원문):** *"Enabling digital experiences is the first step to creating an Experience Cloud site... After you enable digital experiences, you can't disable it."* — **한 번 활성화하면 비활성화할 수 없다.** 프로덕션에 켜기 전 영향 범위를 확인한다.

> 근거: Salesforce Help — *Enable Digital Experiences* (`articleView id=experience.networks_enable.htm`) + *Configure a Custom/Digital Experiences Domain* [Tier 2]. 아래 "커스텀 컴포넌트 보안" 섹션의 "Digital Experiences가 org에 활성화되고"는 이 활성화를 가리킨다.

---

## 어떤 템플릿이 Aura 모델인가 (LWC vs Aura 모델 분기)

사용하는 Experience Builder 템플릿에 따라 **두 가지 프로그래밍 모델** 중 하나로 사이트를 만든다.

- **Lightning Web Components 모델** — 새 Lightning Web Runtime(LWR) 플랫폼 기반.
- **원본 Aura Components 모델** — 기존 모델. LWC와 Aura 컴포넌트를 **둘 다** 쓸 수 있다.

> 원문: *"The **Build Your Own (LWR)** template is based on the new Lightning Web Runtime (LWR) and can only be used with Lightning web components, not Aura components. Other templates are based on the Aura Components model and can use **both** Lightning web components and Aura components."*

즉, **Build Your Own (LWR) 템플릿만 LWR(LWC 전용, Aura 불가)** 이고, 나머지 템플릿은 모두 Aura 모델이라 Aura 컴포넌트를 쓸 수 있다. **이 노트는 Aura 모델 템플릿에서의 개발만 다룬다.**

| 템플릿 | 모델 | 설명 |
|---|---|---|
| **Build Your Own** | Aura (LWC+Aura 둘 다) | 모든 사이트에 필요한 기본 페이지 제공: Home, Create Record, Error, Record Detail, Record List, Related Record List, Search, Check Password, Forgot Password, Login, Login Error, Register. 필요에 따라 페이지/컴포넌트 추가, 브랜딩·테마 커스터마이즈. |
| **Build Your Own (LWR)** | LWR (LWC 전용, Aura ❌) | 새 LWR 플랫폼 기반. 픽셀 단위 페이지·LWC·테마 개발. 커스텀 LWC, Salesforce DX, User Interface API, Apex에 익숙한 개발자·컨설팅 파트너·ISV에 적합. |
| **Customer Account Portal** | Aura | 고객이 계정 정보를 보고 갱신하는 비공개·보안 포털. 인보이스 조회/결제, 계정 정보 갱신, 지식 베이스 검색. |
| **Customer Service** | Aura | 강력한 반응형 셀프서비스 템플릿(프리빌트 테마 다수). 질문 게시·기사 검색/조회·협업·케이스 생성. Knowledge, Chatter Questions, 케이스 지원. |
| **Partner Central** | Aura | 채널 영업 워크플로우용 반응형 템플릿. 파트너 네트워크 모집/구축/성장. 리드 분배·딜 등록·마케팅 캠페인 구성, 교육/영업 자료 공유, 파이프라인 추적. |
| **Help Center** | Aura | 공개 접근 셀프서비스 커뮤니티. 지식 베이스 기사를 노출해 지원 부하 감소. |

> **LWR 사이트의 상세(BYO LWR 템플릿 개발·LWC 전용 모델)는 [[LWR Sites (Experience Cloud)]] 허브 참조.** 위 표는 모델 분기 판단용 카탈로그다.

> **Note (원문):** Lightning Experience를 켜지 않아도 Experience Builder 템플릿을 쓰거나 Lightning 컴포넌트를 개발할 수 있다. Experience Builder 사이트는 Lightning Experience와 같은 기반 기술을 쓰지만 서로 독립적이다.

---

## Developer Console 사용

Developer Console은 Aura 컴포넌트·애플리케이션 개발 도구를 제공한다. Lightning Experience·Salesforce Classic이 지원하는 동일 브라우저에서 쓴다.

Developer Console이 제공하는 기능:

- **메뉴 바**에서 다음 Lightning 리소스를 생성/열기:
  - Application
  - Component
  - Interface
  - Event
  - Tokens
- **워크스페이스**에서 Lightning 리소스 작업.
- **사이드바**에서 특정 컴포넌트 번들에 속한 클라이언트측 리소스 생성/열기:
  - Controller
  - Helper
  - Style
  - Documentation
  - Renderer
  - Design
  - SVG

> (PDF 스크린샷 — 텍스트만: 원문은 메뉴 바(1)/워크스페이스(2)/사이드바(3)를 가리키는 Developer Console UI 스크린샷 콜아웃을 포함한다.)

Developer Console은 Aura 컴포넌트 작업의 간편한 방법이지만 코드 자동완성·린팅 같은 개발자 도구는 부족하다. 소스 기반 개발·에디터 기능이 필요하면 대안:

- **Code Builder** — VS Code, Salesforce Extensions for VS Code, Salesforce CLI를 웹 브라우저에서 쓰는 웹 기반 IDE. 지원되는 Salesforce org edition에 managed package로 설치.
- **Salesforce DX Tools** — Salesforce CLI + VS Code + Salesforce Extension Pack으로 org에 코드 배포.

> Aura 컴포넌트 기초(`.cmp`/controller/event 번들 구조)는 [[Aura 컴포넌트 구조]] · [[Aura 이벤트]] 참조. 이 노트는 Experience Builder에 노출시키는 부분에 집중한다.

---

## 드래그앤드롭 Aura 컴포넌트 구성 (`forceCommunity:availableForAllPageTypes`)

커스텀 Aura 컴포넌트를 Experience Builder에서 쓰기 전 몇 가지 구성 단계가 필요하다.

### 1. 컴포넌트에 인터페이스 추가

Experience Builder에서 드래그앤드롭 컴포넌트로 나타나려면 컴포넌트가 **`forceCommunity:availableForAllPageTypes`** 인터페이스를 구현해야 한다. 구현하면 org의 모든 Aura 사이트 Components 패널에 나타난다.

> **Note (원문):** 컴포넌트 같은 리소스를 자기 org 밖에서도 쓰게 하려면 `access="global"`로 표시한다. 예: 설치형 패키지에서 쓰거나 다른 org의 Experience Builder 사용자가 쓰게 하려면 `access="global"`.

```xml
<!-- componentName.cmp -->
<aura:component implements="forceCommunity:availableForAllPageTypes" access="global">
    <aura:attribute name="greeting" type="String" default="Hello" access="global" />
    <aura:attribute name="subject" type="String" default="World" access="global" />
    <div>{!v.greeting}, {!v.subject}!</div>
</aura:component>
```

> **Warning (원문):** 사이트에 커스텀 컴포넌트를 추가하면 게스트 사용자 프로필에 설정한 객체·필드 수준 보안(FLS)을 우회할 수 있다. Lightning 컴포넌트는 객체 참조나 Apex 컨트롤러에서 객체를 가져올 때 CRUD·FLS를 자동으로 강제하지 않는다. 즉, 프레임워크는 사용자에게 CRUD 권한·FLS 가시성이 없는 레코드·필드도 계속 표시한다. **Apex 컨트롤러에서 CRUD·FLS를 직접 강제해야 한다.**

### 2. 컴포넌트 번들에 design 리소스 추가

design 리소스는 어떤 컴포넌트 attribute가 Experience Builder에 노출되는지 제어한다. `.cmp`와 같은 폴더에 위치하며, 컴포넌트의 디자인 타임 동작(시각 도구가 페이지/앱에 컴포넌트를 표시하는 데 필요한 정보)을 기술한다. attribute 기본값 설정이나 관리자가 Experience Builder에서 편집할 수 있게 하려면 design 리소스가 필요하다.

```xml
<!-- componentName.design -->
<design:component label="Hello World">
    <design:attribute name="greeting" label="Greeting" />
    <design:attribute name="subject" label="Subject" description="Name of the person you want to greet" />
</design:component>
```

### 3. (선택) 컴포넌트 번들에 SVG 리소스 추가

컴포넌트에 커스텀 아이콘을 정의하려면 SVG 리소스를 번들에 추가한다. 이 아이콘은 Experience Builder Components 패널에서 컴포넌트 옆에 나타난다. SVG 리소스가 없으면 시스템이 기본 아이콘을 쓴다. (PDF 이미지 — 기본 아이콘 이미지는 텍스트로 추출되지 않음.)

```xml
<!-- componentName.svg -->
<?xml version="1.0"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN"
"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<svg xmlns="http://www.w3.org/2000/svg"
     width="400" height="400">
    <circle cx="100" cy="100" r="50" stroke="black"
            stroke-width="5" fill="red" />
</svg>
```

### 4. (선택) 컴포넌트 번들에 CSS 리소스 추가

커스텀 컴포넌트를 스타일링하려면 CSS 리소스를 번들에 추가한다.

```css
/* componentName.css */
.THIS .greeting {
    color: #ffe4e1;
    font-size: 20px;
}
```

클래스를 만든 뒤 컴포넌트에 적용한다:

```xml
<!-- componentName.cmp -->
<aura:component implements="forceCommunity:availableForAllPageTypes" access="global">
    <aura:attribute name="greeting" type="String" default="Hello" access="global" />
    <aura:attribute name="subject" type="String" default="World" access="global" />
    <div class="greeting">{!v.greeting}, {!v.subject}!</div>
</aura:component>
```

---

## Component Attribute를 Experience Builder에 노출하기

design 리소스로 어떤 attribute가 노출되는지 제어한다. design 리소스는 컴포넌트와 같은 폴더에 위치하며 디자인 타임 동작을 기술한다.

- Aura 컴포넌트 attribute를 관리자가 Experience Builder에서 편집하게 하려면 design 리소스에 그 attribute의 `design:attribute` 노드를 추가한다.
- attribute를 **required**로 표시하면 (기본값이 없는 한) 자동으로 Experience Builder에 나타난다.
- 사용자에게 나타나게 하려면 **기본값이 있는 required attribute**와 **컴포넌트 정의에서 required로 표시되지 않은 attribute**를 design 리소스에 명시해야 한다.
- design 리소스는 **`int`, `string`, `boolean` 타입의 attribute만** 지원한다.
- **드래그앤드롭 컴포넌트**의 경우, 노출된 attribute는 컴포넌트의 properties 패널에 나타난다.
- **테마 레이아웃 컴포넌트**의 경우, 노출된 attribute는 테마 레이아웃이 **Settings > Theme** 영역에서 선택될 때 나타난다.

---

## Tips and Considerations (Aura 컴포넌트 구성)

Aura 사이트용 Aura 컴포넌트·번들을 만들 때 유의 사항.

### 컴포넌트

- design 파일 요소의 `label` attribute로 친근한 이름을 준다(예: `<design:component label="foo">`).
- 컴포넌트가 표시되는 영역(region)의 너비를 **마진 포함 100%** 채우도록 설계한다.
- 상호작용이 필요한 컴포넌트는 선언적 도구에서 적절한 placeholder 동작을 제공한다.
- **컴포넌트가 빈 박스를 표시하게 두지 않는다.** 다른 사이트 동작을 생각하라 — 예: Facebook은 서버에서 피드 항목이 오기 전 피드 아웃라인을 표시해 UI 반응성에 대한 사용자 인식을 개선한다.
- 컴포넌트가 fire되는 이벤트에 의존하면, 이벤트가 fire되기 전 표시할 기본 상태를 준다.
- 표준 design token으로 스타일링해 Salesforce Lightning Design System(SLDS)과 일관성을 유지한다.
- **Lightning Locker**는 org과 사이트에서 Lightning Locker가 활성화되어 있을 때 Summer '17(API 버전 40.0) 이후 생성된 모든 Aura 컴포넌트에 강제된다. org 수준에서는 Lightning Web Security가 활성화되지 않았으면 Lightning Locker가 쓰인다. → [[Experience Cloud 사이트 — CSP·Locker·LWS]] 참조.
- 커스텀 컴포넌트에서 새 property를 Experience Builder 편집용으로 노출할 때 사이트 번역 고려: 컴포넌트가 페이지에서 사용 중이면, 그 컴포넌트를 페이지에서 삭제하고 업데이트된 버전으로 교체한다. 그러지 않으면 번역용 사이트 콘텐츠를 export할 때 추가한 property가 해당 인스턴스에서 누락된다. 컴포넌트에 이미 번역된 콘텐츠가 있으면 먼저 사이트 콘텐츠를 export해 기존 번역을 보존한 뒤 컴포넌트를 교체한다.

### Attribute

- design 파일로 Experience Builder에 노출되는 attribute를 제어한다.
- attribute를 관리자가 쓰기 쉽고 이해하기 쉽게 만든다. **SOQL 쿼리·JSON 객체·Apex 클래스 이름을 노출하지 않는다.**
- required attribute에 기본값을 줘 나쁜 UX를 피한다. 기본값 없는 required attribute가 있는 컴포넌트를 추가하면 invalid로 표시된다.
- 노출 attribute에는 기본 지원 타입(string, integer, boolean)을 쓴다.
- integer attribute는 `<design:attribute>` 요소에 min/max를 지정해 허용 값 범위를 제어한다.
- string attribute는 미리 정의된 값 세트의 데이터 소스를 제공할 수 있어 picklist로 노출 가능하다.
- attribute에 친근한 표시명 label을 준다.
- description으로 기대 데이터·가이드라인(데이터 형식, 기대 값 범위 등)을 설명한다. description 텍스트는 property 패널의 툴팁으로 나타난다.
- **`forceCommunity:availableForAllPageTypes`를 구현한 컴포넌트의 design attribute를 삭제하려면**, design attribute를 삭제하기 전에 컴포넌트에서 인터페이스를 먼저 제거한 뒤 재구현한다. 컴포넌트가 사이트 페이지에서 참조되면, 변경 전 페이지에서 컴포넌트를 제거해야 한다.

---

## 지원되는 Aura 컴포넌트·인터페이스·이벤트

모든 Aura 컴포넌트·인터페이스·이벤트가 Aura 기반 Experience Builder 사이트에서 지원되는 것은 아니다. 일부는 Salesforce 모바일 앱이나 Lightning Experience에서만 쓸 수 있다.

> **지원 목록은 외부 Component Library(Component / Interface / Event Reference)를 참조한다.** 각 컴포넌트·인터페이스·이벤트가 어떤 experience를 지원하는지 거기 표시되어 있다. (이 노트는 지원 매트릭스를 복제하지 않는다.)

이 노트 본문에서 다루는 **`forceCommunity` 인터페이스 4종** (각 용도는 해당 섹션 참조):

| 인터페이스 | 용도 |
|---|---|
| `forceCommunity:availableForAllPageTypes` | 드래그앤드롭 컴포넌트 |
| `forceCommunity:themeLayout` | 커스텀 테마 레이아웃 컴포넌트 |
| `forceCommunity:profileMenuInterface` | 스왑 가능 프로필 메뉴 컴포넌트 |
| `forceCommunity:searchInterface` | 스왑 가능 검색 컴포넌트 |

---

## Personalization Target Developer/Group Names

Connect REST API 또는 Metadata API로 Experience Builder 사이트를 personalize할 때, experience variation 타겟의 **developer name**과 **group name**을 결정해야 한다.

- Connect REST API의 **Target Input** 요청 본문 또는 Audience 메타데이터 타입의 **PersonalizationTargetInfo** 서브타입에서 다음을 지정해야 한다:
  - 타겟 group name → `groupName` property
  - 타겟 developer name → `targetValue` property
- 이 이름들을 결정하려면 사이트의 **ExperienceBundle** 폴더 안 여러 JSON 파일에서 property 값을 복사한다. → [[ExperienceBundle — Experience Builder 사이트 메타데이터]] (형제 노트)
- 결정 방식은 **page variations, branding sets, component visibility, component attributes** 중 무엇을 타겟하느냐에 따라 다르다.

> (PDF 스크린샷 — 텍스트만: 원문은 JSON 파일 내 property 위치를 가리키는 스크린샷 다수를 포함한다. 아래 Format/Example은 텍스트로 추출된 전수.)

### Page Variations

관련 route 파일과 대응 view 파일을 연다(예: routes 폴더의 `Home.json`과 views 폴더의 `Home.json`).

| 항목 | Format | Example |
|---|---|---|
| Group Name | `route.id` — route JSON 파일의 id property | `63d9b8fe-99fc-4f54-b784-5034e09a6670` |
| Developer Name | `route.label_view.label_Page` — route JSON의 label property + view JSON의 label property | `Home_Gold_Home_Page` |

### Branding Sets

관련 branding set 파일과 대응 theme 파일을 연다(예: Customer Service 사이트에서 themes 폴더의 `customerService.json`과 brandingSets 폴더의 `customerService.json`).

| 항목 | Format | Example |
|---|---|---|
| Group Name | `theme.id$#$Branding` — theme JSON 파일의 id property | `70ebee67-0fca-421e-ac32-12879ee55936$#$Branding` |
| Developer Name | `theme.developerName_brandingSet.label_Branding` — theme JSON의 developerName + branding set JSON의 label property | `service_Customer_Service_Branding` |

### Component Visibility

컴포넌트를 포함한 view 파일을 연다(예: views 폴더의 `Home.json`).

| 항목 | Format | Example |
|---|---|---|
| Group Name | `view.id$#$component.id` — view JSON의 id property + view JSON 내 컴포넌트의 id property | `f8c9b721-0a1d-45bb-954f-3277a0501892$#$823cb1c0-697f-4b33-8fa4-a925aef98cf7` |
| Developer Name | `view.label_componentName_Component` — view JSON의 label property + Experience Builder의 컴포넌트 이름(JSON 파일 아님) | `Home_Headline_Component` |

> **Note (원문):** 필요하면 developer name에 숫자 값을 추가해 고유하게 만든다. 예: `Home_Page_Rich_Content_Editor_Component1`.

### Component Attributes

컴포넌트가 **view body**에 있는지, theme layout의 **header 또는 footer**에 있는지에 따라 group/developer name이 다르다.

**View Body의 컴포넌트** — 컴포넌트를 포함한 view 파일을 연다(예: views 폴더의 `Home.json`).

| 항목 | Format | Example |
|---|---|---|
| Group Name | `view.id$#$component.id` — view JSON의 id property + view JSON 내 컴포넌트의 id property | `f8c9b721-0a1d-45bb-954f-3277a0501892$#$823cb1c0-697f-4b33-8fa4-a925aef98cf7` |
| Developer Name | `view.label_componentName_Component_Properties` — view JSON의 label property + Experience Builder의 컴포넌트 이름(JSON 파일 아님) | `Home_Headline_Component_Properties` |

> **Note (원문):** 필요하면 developer name에 숫자 값을 추가해 고유하게 만든다. 예: `Home_Page_Rich_Content_Editor_Component1`.

**Header 또는 Footer의 컴포넌트** — 컴포넌트를 포함한 theme 파일을 연다(예: Customer Service 사이트에서 themes 폴더의 `customerService.json`).

| 항목 | Format | Example |
|---|---|---|
| Group Name | `themeLayout.id$#$component.id` — 컴포넌트를 포함한 layout의 id property + layout 내 컴포넌트의 id property | `06ce2db9-2c79-4ccc-9ca8-94c7b50efb6b$#$c55d1908-fe6b-47e8-b41e-70ad05aeb490` |
| Developer Name | `themeLayout.label_componentName_Component_Properties` — 컴포넌트를 포함한 layout의 label property + Experience Builder의 컴포넌트 이름(JSON 파일 아님) | `Default_Navigation_Menu_Component_Properties` |

---

## 사용자의 개인정보 가시성 설정 준수 (Comply with a User's Personal Information Visibility Settings)

Orgs with portals and sites는 사용자의 개인식별정보(PII)·연락처 정보를 다른 사용자에게 숨기는 설정을 제공한다. **이 설정들은 Apex에서 강제되지 않는다 — `WITH USER_MODE` 절이나 `stripInaccessible` 메서드 같은 Apex 보안 기능으로도 적용되지 않는다.** guest 또는 external authenticated 사용자에게 특정 필드를 숨기려면 아래 샘플 코드처럼 직접 코드로 처리해야 한다.

> **SEE ALSO (인트로):** Metadata API Developer Guide: Audience · Connect REST API Developer Guide: Target Input

### User 객체의 개인정보 숨기기

`Auth.CommunitiesUtil.isInternalUser()`로 내부 사용자가 아니고, 다른 사용자의 레코드를 조회하는 경우 PII 필드를 비운다.

```apex
public User[] fetchUserDetail(Set userIds) {
    // Query all the fields of user which we are expected in user record to show that on UI or to
    // perform some business logic.
    User[] userRecords = [SELECT id, username, communitynickname, firstname, lastname, title
                          FROM User WHERE id IN :userIds];
    for (User userRecord : userRecords) {
        // User is not fetching his own record and is not standard user.
        if(userRecord.id != UserInfo.getUserId() && !Auth.CommunitiesUtil.isInternalUser()) {
            // clear-out all PII fields form user record which we have queried above.
            userRecord.username = '';
            userRecord.title = '';
        }
    }
    return userRecords;
}
```

> ⚠️ `Set userIds`(타입 파라미터 없음)·주석 오타("form")는 PDF 원문 그대로 보존([sic]).

### 연락처 정보 가시성 설정(FLV preferences) 준수

community·portal 내 연락처 정보 visibility 설정을 준수하려면, 특정 필드에 연관된 preferences를 확인해 데이터를 표시/숨김한다. Experience Cloud 사이트 내 연락처 가시성은 두 개의 User preference 필드로 분기한다:

- `UserPreferencesShowEmailToExternalUsers` — external 사용자에게 email 표시 여부
- `UserPreferencesShowEmailToGuestUsers` — guest 사용자에게 email 표시 여부

진입 메서드(`fetchUserRecordRespectingFLVPreferences`)는 internal → 제한 없이 반환, guest → guest 처리, 그 외(external) → external 처리로 분기한다.

```apex
public User[] fetchUserRecordRespectingFLVPreferences(Set<Id> userIds) {
    //Fetch users records along with fields specific user preferences.
    User[] userRecords = [SELECT email, UserPreferencesShowEmailToExternalUsers,
                          UserPreferencesShowEmailToGuestUsers FROM User WHERE id IN :userIds];
    // If context user is internal user then return result without any restriction.
    if (Auth.CommunitiesUtil.isInternalUser()) {
        return userRecords;
    }
    // If user is guest user then return result as per the user's UserPreference for the fields related to the Guest user visibility.
    if (Auth.CommunitiesUtil.isGuestUser()){
        return fetchUserRecordForGuestUser(userRecords);
    }
    // Return result as per the user's UserPreference for the fields related to the External user visibility
    return fetchUserRecordForExternalUser(userRecords);
}
// Apply Field level visibilty logic by checking user's UserPreferences for the fields related to the External user visibility.
public User[] fetchUserRecordForExternalUser(User[] userRecords) {
    for(User userRecord : userRecords) {
        //Clear field of user record when context user fetching other user's record and
        //Field Level Visibility for that field is set to Restricted.
        if(userRecord.id != UserInfo.getUserId() && !userRecord.UserPreferencesShowEmailToExternalUsers) {
            userRecord.email = '';
        }
    }
    return userRecords;
}
// Apply Field level visibilty logic by checking user's UserPreferences for the fields related to the Guest user visibility.
public User[] fetchUserRecordForGuestUser(User[] userRecords) {
    for(User userRecord : userRecords) {
        //Clear field of user record when context user fetching other user's record and
        //user preference for that field is NOT set to public.
        if(!userRecord.UserPreferencesShowEmailToGuestUsers) {
            userRecord.email = '';
        }
    }
    return userRecords;
}
```

> ⚠️ "visibilty" 오타는 PDF 원문 그대로 보존([sic]).
>
> **External vs Guest 분기 차이:** external 처리는 `userRecord.id != UserInfo.getUserId()` 조건(자기 자신 레코드 제외)을 추가로 검사하지만, guest 처리는 preference만 검사한다.

> **SEE ALSO (끝):** Salesforce Help: Manage Personal User Information Visibility for External Users · Salesforce Help: Share Personal Contact Information Within Experience Cloud Sites

> 게스트·외부 인증 사용자에 대한 보안 모델(권한·접근 제어) 상세는 형제 노트 [[Experience Cloud 사이트 보안 — 인증·게스트 사용자]] 참조.

---

## Aura 사이트 브랜딩 — Theme Panel·CSS Editor·Custom Fonts

Theme 패널을 쓰거나 직접 커스텀 컴포넌트를 개발해 Aura 사이트의 룩앤필을 커스터마이즈한다. Experience Builder 내 옵션은 컴포넌트 개발 없이 가장 간단하게 쓸 수 있고, 템플릿 고유이므로 사이트 간 공유되지 않는다.

- **Theme 패널** — 간단한 point-and-click property로 템플릿을 갱신. 관리자에게 이상적. header·search 같은 개별 컴포넌트 property 패널에서 더 구체적인 룩앤필 조정 가능.
- **CSS Editor** — 사이트 전반의 요소를 스타일링하는 커스텀 CSS 생성. CSS에 익숙하고 일부 템플릿 컴포넌트에 사소한 수정만 하려는 경우 적합. **Aura 사이트의 theme swapping에서 커스텀 CSS는 활성 테마에 직접 연결된다.**

완전한 커스터마이즈에는 직접 커스텀 컴포넌트를 개발해야 한다. Aura 사이트는 LWC와 Aura 컴포넌트를 둘 다 지원하며, **가능하면 성능이 좋고 개발이 쉬운 LWC 개발을 권장**한다.

- **커스텀 LWC·Aura 컴포넌트** — CSS 리소스를 번들의 일부로 캡슐화해 사이트 간 재사용 가능.
- **Content layout 컴포넌트** — 페이지의 콘텐츠 영역을 정의하고 컴포넌트를 담는다.
- **Theme layout 컴포넌트** — 템플릿의 구조적 레이아웃(header·footer 등)을 커스터마이즈하고 기본 스타일을 override.

### Theme Panel로 템플릿 갱신

Experience Builder에서 가장 간단한 방법. 관리자가 색상·폰트·로고·일반 페이지 구조/기본값을 빠르게 적용.

- Theme 패널에서 설정한 property는 템플릿의 페이지와 대부분의 off-the-shelf 컴포넌트에 적용된다. 색상·이미지·폰트 번들을 빠르게 적용하려면 **Branding Sets**를 쓴다.
- 표준 design token으로 외형을 제어하는 커스텀 Aura 컴포넌트에도 Theme 패널 property가 적용된다.

> (PDF 스크린샷 — 텍스트만: Theme Panel UI 스크린샷.)

### CSS Editor로 커스텀 CSS

Experience Builder의 CSS Editor로 Aura 사이트 전반의 요소를 스타일링하는 커스텀 CSS를 만든다.

> **Warning (원문):** 커스텀 CSS는 아껴 쓰고, **소유하지 않은 컴포넌트의 DOM 요소를 타겟팅하지 않는다.** 컴포넌트 내부 DOM 구조가 바뀌면 하드코딩한 CSS 셀렉터가 깨지기 쉽다. Salesforce는 언제든 내부 구현을 바꿀 수 있다. 또한 Salesforce Customer Support는 커스텀 CSS 관련 이슈 해결을 도울 수 없다.

- 컴포넌트에 사소한 CSS 수정을 하려면 Chrome DevTools로 페이지를 inspect해 항목의 fully qualified name과 CSS 클래스를 찾는다.
- > **Tip (원문):** 대규모 템플릿 커스터마이즈에는 커스텀 CSS 대신 커스텀 LWC·Aura 컴포넌트와 커스텀 테마 레이아웃 컴포넌트의 CSS 리소스를 쓴다. global override를 쓰면 각 릴리즈 업데이트 때 항상 sandbox에서 테스트한다.
- **Settings > Advanced**의 head 마크업에서 정적 또는 외부 리소스로 CSS 스타일시트를 링크할 수 있다. 단, global value provider가 head 마크업·CSS override에서 지원되지 않으므로 `$resource`로 static resource를 참조할 수 없다. 대신 `/sfsites/c/resource/resource_name` 구문의 상대 URL을 쓴다.

```css
/* static resource를 참조하는 CSS 예 (resource 이름 'headline') */
.forceCommunityHeadline
{
    background-image: url('/sfsites/c/resource/headline')
}
```

- head 마크업은 favicon 아이콘·SEO meta 태그 등 추가에도 유용하다. 단 기본 strict CSP 보안 수준은 코드에 영향을 줄 수 있다. → [[Experience Cloud 사이트 — CSP·Locker·LWS]]

### Migrate CSS Overrides (셀렉터 마이그레이션)

Spring '17 ~ Winter '19 사이에 여러 Experience Builder 컴포넌트의 CSS 셀렉터가 변경되었다. 그 이후 템플릿을 업데이트하지 않았고 사이트가 기본 템플릿·Theme 패널 스타일을 override하는 커스텀 CSS를 쓴다면, 새 셀렉터로 마이그레이션해야 한다.

> **Note (원문):** 커스텀 CSS는 아껴 쓴다(템플릿 업데이트가 항상 커스터마이즈를 지원하지는 않음). 커스텀 CSS는 이제 모든 사이트 페이지에 공유된다. Login 페이지에 커스텀 CSS를 썼다면 복사해 CSS 에디터를 닫고, 비-Login 페이지로 이동해 에디터를 다시 열어 추가한다.

**컴포넌트별 Previous → New 셀렉터 매핑 표는 원문(Experience Cloud Developer Guide)을 참조한다.** 이 노트는 raw 셀렉터 매핑을 싣지 않는다. 매핑이 제공되는 **11개 컴포넌트**(이름만):

1. Navigation Menu
2. Panels Container
3. Record Banner (Component)
4. Record Detail (Component)
5. Record Layout (Component)
6. Record List (Component)
7. Record Related List (Component)
8. Related Articles (Component)
9. Reputation Leaderboard (Component)
10. Embedded Service Sidebar Header (Component)
11. Trending Articles by Topic (Component)

### Custom Fonts 사용

커스텀 폰트를 static resource로 업로드해 사이트의 primary·header 폰트로 쓴다. 폰트 파일이 여러 개면 .zip을 쓴다.

1. Setup에서 **Static Resources**를 찾아 선택.
2. **New** → 파일 업로드 → static resource 이름 지정(이름 기록). 사이트에 public 페이지가 있으면 Cache Control 설정에서 **Public** 선택. public으로 만들지 않으면 페이지가 브라우저 기본 폰트를 쓴다.
3. Experience Builder에서 **Theme > [⚙ 아이콘] > Edit CSS**로 CSS 에디터를 연다. (⚙ 아이콘은 PDF 이미지.)
4. `@font-face` CSS 규칙으로 업로드한 폰트를 참조:

```css
@font-face {
    font-family: 'myFirstFont';
    src: url('/myPartnerSite/s/sfsites/c/resource/MyFonts/bold/myFirstFont.woff') format('woff');
}
```

> **Note (원문):** `format()`은 URL이 참조하는 폰트 형식을 기술하는 선택적 힌트다.
> - **단일 폰트 파일** 참조: `/path_prefix/s/sfsites/c/resource/resource_name` 구문. `path_prefix`는 사이트 생성 시 추가한 URL 값(예: `myPartnerSite`). 예: `myFirstFont.woff`를 업로드하고 resource를 `MyFonts`로 이름 지으면 URL은 `/myPartnerSite/s/sfsites/c/resource/MyFonts`.
> - **.zip 내 파일** 참조: 폴더 구조는 포함하되 .zip 파일명은 생략. `/path_prefix/s/sfsites/c/resource/resource_name/font_folder/font_file` 구문. 예: `fonts.zip`(안에 `bold/myFirstFont.woff`)을 업로드하고 `MyFonts`로 이름 지으면 URL은 `/myPartnerSite/s/sfsites/c/resource/MyFonts/bold/myFirstFont.woff`.

5. Theme 패널에서 **Fonts** → **Primary Font** 또는 **Header Fonts** 드롭다운 → **Use Custom Font** 클릭.
6. CSS 에디터에 입력한 font family 이름(예: `myFirstFont`)을 추가하고 저장.

---

## Custom Theme Layout (`forceCommunity:themeLayout`)

템플릿 테마에 자신의 스탬프를 찍고 외형을 변형하려면 커스텀 theme layout 컴포넌트를 만든다. 템플릿의 구조적 레이아웃(header·footer 등)을 커스터마이즈하고 기본 스타일을 override할 수 있다.

theme layout 컴포넌트는 사이트 템플릿 페이지의 최상위 레이아웃이다. **theme layouts**(테마 레이아웃)을 통해 페이지에 조직·적용된다. theme layout 컴포넌트는 공통 header·footer를 포함하며, 종종 navigation·search·user profile menu를 포함한다. 반면 **content layout**은 페이지의 콘텐츠 영역을 정의한다.

> (PDF 다이어그램 — 텍스트만: 원문은 two-column content layout 다이어그램 이미지를 포함한다.)

### Custom Theme Layout의 동작 원리

- Experience Builder에서 theme layout과 theme layout 컴포넌트가 결합해 각 페이지의 외형·구조를 세밀하게 제어한다. 레이아웃의 header·footer를 브랜딩에 맞게 커스터마이즈하고, theme property를 구성하거나, 커스텀 search bar·user profile menu를 쓸 수 있다. theme layout으로 theme layout 컴포넌트를 개별 페이지에 적용하고, 한 중앙 위치에서 레이아웃을 빠르게 바꾼다.
- theme layout은 같은 theme layout 컴포넌트를 공유하는 사이트 페이지를 분류한다. 기존 theme layout에 theme layout 컴포넌트를 할당한 뒤, 페이지 properties에서 theme layout(과 그에 따른 theme layout 컴포넌트)을 적용한다.
- 예: Customer Service 템플릿은 다음 theme layout·컴포넌트를 포함하되, 커스텀 컴포넌트를 만들거나 레이아웃을 전환할 수 있다.
  - **Default** — login 페이지를 제외한 모든 페이지에 Customer Service theme layout 적용.
  - **Login** — login 페이지에 Login Body Layout theme layout 컴포넌트 적용.

> **Example (원문 요약):** Spring 캠페인용 페이지 3개를 만든다. `forceCommunity:themeLayout` 인터페이스로 Developer Console에서 Large Header theme layout을 만든다. **Settings > Theme**에서 Spring이라는 커스텀 theme layout을 추가해 캠페인 페이지를 분류하고 Large Header layout 컴포넌트를 할당한다. 각 페이지 properties에서 Spring theme layout을 적용하면 Large Header layout이 즉시 적용된다. "Override the default theme layout for this page. (1)"를 선택해 Theme Layout을 표시하고, 사용 가능한 선택지에서 새 레이아웃 (2)를 고른다. header가 너무 크면 각 페이지 properties를 갱신할 필요 없이 Theme 영역에서 클릭 한 번으로 Spring을 Small Header layout으로 바꾸면 세 페이지가 즉시 갱신된다.

> **Example (원문):** Small Header layout이 Blue Background·Small Logo 두 커스텀 property를 포함한다고 하자. 모든 캠페인 페이지에 적용했지만 한 페이지에는 Small Logo만 적용하려면, Spring B라는 theme layout을 만들어 Small Header layout 컴포넌트를 할당하고 Small Logo만 활성화한 뒤 그 페이지에 Spring B를 적용한다.

어떤 페이지가 어느 theme layout에 연결됐는지 보려면 **Settings > Theme**에서 theme layout 행의 **Pages Assigned** 합계 (1)를 클릭하면 연결된 페이지 목록 (2)이 열린다.

### Custom Theme Layout 컴포넌트 구성

Developer Console에서 Customer Service 템플릿 페이지의 외형·전체 구조를 변형하는 커스텀 theme layout 컴포넌트를 만드는 방법.

**1. theme layout 컴포넌트에 인터페이스 추가**

- theme layout 컴포넌트는 **Settings > Theme** 영역에 나타나려면 **`forceCommunity:themeLayout`** 인터페이스를 구현해야 한다.
- 코드에 **`{!v.body}`를 명시적으로 선언**해 theme layout이 content layout을 포함하게 한다. 페이지 콘텐츠가 나타날 곳마다 `{!v.body}`를 추가한다.
- **`Aura.Component[]`로 선언한 attribute**를 추가해 페이지 컴포넌트를 담는 region을 포함한다. region에 컴포넌트를 미리 넣거나, 사용자가 드래그앤드롭하도록 열어둘 수 있다. 마크업에 포함된 `Aura.Component[]` attribute는 사용자가 컴포넌트를 추가할 수 있는 open region으로 렌더링된다.

```xml
<aura:component implements="forceCommunity:themeLayout">
    <aura:attribute name="myRegion" type="Aura.Component[]"/>
    {!v.body}
</aura:component>
```

Customer Service에서 Template Header는 다음 locked region으로 구성된다:

- **search** — Search Publisher 컴포넌트 포함
- **profileMenu** — Profile Header 컴포넌트 포함
- **navBar** — Navigation Menu 컴포넌트 포함

Template Header region의 기존 컴포넌트를 재사용하는 커스텀 theme layout을 만들려면, 적절히 `search`·`profileMenu`·`navBar`를 attribute name 값으로 선언한다:

```xml
<aura:attribute name="navBar" type="Aura.Component[]" required="false" />
```

> **Tip (원문):** 스왑 가능한 커스텀 profile menu나 search 컴포넌트를 만들면, `search`·`profileMenu` attribute name 값을 선언함으로써 사용자가 theme layout을 Experience Builder에서 쓸 때 커스텀 컴포넌트를 선택할 수도 있다.

region을 마크업에 추가해 theme layout body에서 표시 위치를 정의한다. 간단한 theme layout의 샘플 코드:

```xml
<aura:component implements="forceCommunity:themeLayout" access="global" description="Sample Custom Theme Layout">
    <aura:attribute name="search" type="Aura.Component[]" required="false"/>
    <aura:attribute name="profileMenu" type="Aura.Component[]" required="false"/>
    <aura:attribute name="navBar" type="Aura.Component[]" required="false"/>
    <aura:attribute name="newHeader" type="Aura.Component[]" required="false"/>
    <div>
        <div class="searchRegion">
            {!v.search}
        </div>
        <div class="profileMenuRegion">
            {!v.profileMenu}
        </div>
        <div class="navigation">
            {!v.navBar}
        </div>
        <div class="newHeader">
            {!v.newHeader}
        </div>
        <div class="mainContentArea">
            {!v.body}
        </div>
    </div>
</aura:component>
```

**2. theme property를 포함하는 design 리소스 추가**

design 리소스를 번들에 추가해 theme layout property를 Experience Builder에 노출한다. 먼저 컴포넌트에 property를 구현한다:

```xml
<aura:component implements="forceCommunity:themeLayout" access="global" description="Small Header">
    <aura:attribute name="blueBackground" type="Boolean" default="false"/>
    <aura:attribute name="smallLogo" type="Boolean" default="false" />
    ...
```

design 리소스에 theme property를 정의해 UI에 노출한다. 다음 예는 Small Header theme layout의 label과 체크박스 2개를 추가한다:

```xml
<design:component label="Small Header">
    <design:attribute name="blueBackground" label="Blue Background"/>
    <design:attribute name="smallLogo" label="Small Logo"/>
</design:component>
```

**3. overlap 이슈를 피하는 CSS 리소스 추가**

CSS 리소스를 번들에 추가해 theme layout을 스타일링한다(이상적으로 표준 design token 사용). dialog box·hover 같은 positioned 요소의 overlap 이슈를 피하려면:

- CSS 스타일 적용:

```css
.THIS {
    position: relative;
    z-index: 1;
}
```

- 커스텀 theme layout의 요소를 div 태그로 감싼다:

```xml
<div class="mainContentArea">
    {!v.body}
</div>
```

> **Note (원문):** theme layout은 그 안의 모든 것의 스타일링을 제어하므로 region·컴포넌트에 drop-shadow 같은 스타일을 추가할 수 있다. 커스텀 theme layout에는 SLDS가 기본 로드된다.

---

## Expression으로 동적 데이터 추가 (Aura 사이트)

expression으로 property 값과 기타 정보에 접근해 컴포넌트 attribute로 전달한다. expression은 단일 값으로 resolve되는 리터럴·변수·서브표현식·연산자의 집합이다. **expression에서 메서드 호출은 허용되지 않는다.**

- 구문: `{!expression}`.
- expression은 **content region**에 추가한다. **header, hero, footer** 같은 shared region에서는 지원되지 않는다.
- 인증된 사용자 정보, 데이터 카테고리 연관 이미지, 페이지의 레코드 정보를 표시하는 데 쓴다.

> Aura 사이트의 expression은 `{!CurrentUser.*}` 등 Aura 고유 형식이다. **LWR 사이트의 expression은 형식이 다르므로 [[LWR Expressions 레퍼런스]]를 참조한다.** 아래 표는 Aura 사이트 전용이다.

| Expression | Displays |
|---|---|
| `{!CurrentUser.name}` | 사용자 detail 페이지에 표시되는 이름·성 결합. |
| `{!CurrentUser.firstName}` | 사용자 edit 페이지에 표시되는 first name. |
| `{!CurrentUser.lastName}` | 사용자 edit 페이지에 표시되는 last name. |
| `{!CurrentUser.userName}` | 사용자 로그인을 정의하는 관리 필드. |
| `{!CurrentUser.id}` | 사용자의 Salesforce ID. |
| `{!CurrentUser.email}` | 사용자의 이메일 주소. |
| `{!CurrentUser.communityNickname}` | 사이트에서 사용자를 식별하는 데 쓰는 이름. |
| `{!CurrentUser.accountId}` | 사용자와 연관된 Account ID. 파트너·고객 사용자에는 유효한 account ID, 그 외에는 `'000000000000000'` 표시. |
| `{!CurrentUser.effectiveAccountId}` | effective account와 연관된 Account ID. 파트너·고객 사용자에는 유효한 account ID, 그 외에는 `'000000000000000'` 표시. |
| `{!Global.PathPrefix}/{!DataCategory.Name}.jpg` | search 컴포넌트에서 데이터 카테고리와 연관된 이미지. |
| `{!Global.PathPrefix}/<Name of the Subfolder>/{!DataCategory.Name}.jpg` | search 컴포넌트의 서브폴더에 있는 데이터 카테고리 연관 이미지. |
| `{!recordId}` | 객체 페이지의 15자리 record ID. |
| `{!term}` | Aura 기반 표준 search 페이지의 HTML-encoded 검색어를 반환하는 expression. |

---

## 스왑 가능한 Search·Profile Menu 컴포넌트

커스텀 컴포넌트를 만들어 Experience Builder에서 템플릿의 표준 **Profile Header**·**Search & Post Publisher** 컴포넌트를 대체한다.

Customer Service에서 Template Header는 locked region으로 구성된다(`search`/`profileMenu`/`navBar`). 이 지정 region 이름 덕분에 다음이 쉬워진다:

- 기본 또는 커스텀 theme layout 컴포넌트에서 search·profile 컴포넌트 스왑.
- 선택된 search 컴포넌트 같은 기존 커스터마이즈를 유지하면서 theme layout 컴포넌트 스왑.

컴포넌트가 올바른 인터페이스(`forceCommunity:searchInterface` 또는 `forceCommunity:profileMenuInterface`)를 구현하면 해당 region의 후보로 식별된다. 따라서 `search`·`profileMenu`를 attribute name 값으로 선언하는 theme layout 컴포넌트(예: 기본 Customer Service theme layout 컴포넌트)에서 스왑 가능 컴포넌트로 나타난다.

```xml
<aura:attribute name="search" type="Aura.Component[]" required="false" />
```

### `forceCommunity:profileMenuInterface`

Aura 컴포넌트에 이 인터페이스를 추가하면 템플릿의 커스텀 profile menu 컴포넌트로 쓸 수 있다. 생성 후 관리자가 Experience Builder의 **Settings > Theme**에서 선택해 표준 Profile Header 컴포넌트를 대체한다.

```xml
<aura:component implements="forceCommunity:profileMenuInterface" access="global">
    <aura:attribute name="options" type="String[]" default="Option 1, Option 2"/>
    <ui:menu >
        <ui:menuTriggerLink aura:id="trigger" label="Profile Menu"/>
        <ui:menuList class="actionMenu" aura:id="actionMenu">
            <aura:iteration items="{!v.options}" var="itemLabel">
                <ui:actionMenuItem label="{!itemLabel}" click="{!c.handleClick}"/>
            </aura:iteration>
        </ui:menuList>
    </ui:menu>
</aura:component>
```

### `forceCommunity:searchInterface`

Aura 컴포넌트에 이 인터페이스를 추가하면 템플릿의 커스텀 search 컴포넌트로 쓸 수 있다. 생성 후 관리자가 **Settings > Theme**에서 선택해 표준 Search & Post Publisher 컴포넌트를 대체한다.

```xml
<aura:component implements="forceCommunity:searchInterface" access="global">
    <div class="search">
        <div class="search-wrapper">
            <form class="search-form">
                <div class="search-input-wrapper">
                    <input class="search-input" type="text" placeholder="My Search"/>
                </div>
                <input type="hidden" name="language" value="en" />
            </form>
        </div>
    </div>
</aura:component>
```

---

## 커스텀 컴포넌트 보안 (Ch5로 가는 다리)

개발자는 커스텀 컴포넌트로 Experience Cloud 사이트 기능·비즈니스 로직을 커스터마이즈한다. 다만 내장 방어를 우회하면 사이트·org가 보안 위험에 노출된다. 예: 개발자가 민감 데이터를 커스텀 컴포넌트 정의에 텍스트로 저장하면 노출될 수 있다. 이런 노출은 Digital Experiences가 org에 활성화되고, org에 커스텀 컴포넌트가 있으며, 컴포넌트의 developer name이 알려졌을 때 발생할 수 있다 — 사이트가 public이든 private이든.

**노출될 수 있는 데이터:**

- 컴포넌트 정의에 텍스트로 저장된 민감 정보
- HTML·JavaScript·CSS 파일을 포함한 컴포넌트의 전체 정의
- 컴포넌트 정의에 포함된 다른 컴포넌트 이름
- 컴포넌트 정의에 쓰인 Apex 컨트롤러·메서드 이름

이런 데이터는 org의 어떤 커스텀 컴포넌트(Salesforce org·Experience Cloud 사이트에서 쓰이든 미사용이든)에 대해서도 노출될 수 있다.

**데이터 노출 위험을 줄이는 단계:**

- org의 모든 커스텀 컴포넌트 정의를 검토
- 컴포넌트 정의에 민감 데이터(PII·회사 기밀·민감 정보)를 저장하지 않기
- 모든 커스텀 컨트롤러를 검토해 필요한 사용자 프로필만 접근하도록
- `@AuraEnabled`로 필요한 메서드만 노출
- 커스텀 컴포넌트에 org에 고유하고 복잡한 명명 규칙 사용

> 보안 모델(CSP·Locker·LWS, 게스트 사용자 권한, 인증) 상세는 형제 노트 참조: [[Experience Cloud 사이트 — CSP·Locker·LWS]] · [[Experience Cloud 사이트 보안 — 인증·게스트 사용자]]

---

## 관련 노트

- [[Experience Cloud 사이트 — CSP·Locker·LWS]] — 커스텀 컴포넌트 보안(CSP·Lightning Locker·LWS)
- [[Experience Cloud 사이트 보안 — 인증·게스트 사용자]] — 인증·게스트 사용자 보안 모델 (PII 가시성 설정과 연관)
- [[Experience Builder 사이트 — Pardot·CMS·Deflection]] — 마케팅·CMS·케이스 deflection (형제 노트)
- [[ExperienceBundle — Experience Builder 사이트 메타데이터]] — ExperienceBundle 폴더 구조·Metadata API/DX 배포·enhanced LWR 마이그레이션
- [[LWR Sites (Experience Cloud)]] — LWR 모델(BYO LWR 템플릿) 허브
- [[LWR Expressions 레퍼런스]] — LWR 사이트의 expression 형식(Aura와 다름)
- [[Aura 컴포넌트 구조]] — Aura 컴포넌트 번들 기초(cmp/controller/helper)
- [[Aura 이벤트]] — Aura 이벤트 모델
- [[Aura vs LWC]] — Aura와 LWC 비교
