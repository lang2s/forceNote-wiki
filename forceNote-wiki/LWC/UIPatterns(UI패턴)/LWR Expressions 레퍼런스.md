---
tags: [lwc, experience-cloud, lwr, expressions, data-binding, reference]
source: exp_cloud_lwr.pdf (LWR Sites for Experience Cloud v66.0, Spring '26, Tier 2)
created: 2026-06-20
aliases: [LWR expressions, 표현식, data binding, {!expression}, {!Route.term}, {!CurrentUser}, {!cmsMedia.contentKey}, Route expression, dynamic data binding, expression-based visibility, HTML escape, Site.basePath, User.userId]
---

# LWR Expressions 레퍼런스

> LWR 사이트에서 `{!expression}` 문법으로 Salesforce·CMS 데이터를 컴포넌트 속성에 바인딩하는 표현식 전수 — Data Binding 표현식·Other Expressions·제약.

---

## 개요

표현식(expression)으로 계산을 수행하고 Salesforce의 property 값·기타 데이터나 Salesforce CMS의 콘텐츠에 접근해 컴포넌트 속성으로 넘긴다. 동적 출력이나, 속성에 값을 할당해 컴포넌트로 값을 전달할 때 사용한다.

- 표현식 = literal 값·variable·subexpression·operator의 집합으로 **단일 값으로 resolve**될 수 있는 것.
- **method call은 표현식에서 허용되지 않는다.**
- 문법: **`{!expression}`** (`expression`은 placeholder).

> 이 노트는 [[LWR Sites (Experience Cloud)]]의 spoke다. 컴포넌트 개발·검색·다국어 등은 hub 노트 참조.

```text
// exp_cloud_lwr.pdf 발췌 — PDF 원문 예시 (HTML Editor 컴포넌트에서 표현식 사용)
{!Item.field}            <!-- 현재 바인딩된 데이터의 field 값 -->
{!Route.term}            <!-- /global-search/:term URL 파라미터 -->
{!Site.basePath}         <!-- 사이트 basePath -->
```

> 페이지가 라이브 사이트에서 로드되면 관련 값이 표현식을 대체한다.

---

## Data Binding 표현식

Salesforce 또는 Salesforce CMS 콘텐츠를 LWR 사이트에 바인딩해 콘텐츠를 동적으로 채울 때 사용한다. 다음 위치에서 동작:

- data-bound 컴포넌트(Banner·Card·Grid·Tile 등)의 모든 field
- data-bound 컴포넌트 안에 nest되거나 CMS content page·record detail page에 배치된 **HTML Editor** 컴포넌트
- data-bound 컴포넌트 안에 nest되거나 CMS content page·record detail page에 배치된 **Rich Content Editor** 컴포넌트 (단 `{!cmsMedia.contentKey}` 표현식은 제외)

| Expression | Description | Supported Pages and Components |
|---|---|---|
| `{!Item.field}` | 현재 바인딩된 데이터의 field 데이터를 가져온다. | Salesforce 또는 Salesforce CMS 콘텐츠에 바인딩될 수 있는 컴포넌트 property |
| `{!Item.field._rawValue}` | 데이터 field의 raw value를 가져온다. | Salesforce 데이터에 바인딩될 수 있는 컴포넌트 property |
| `{!Item.field._displayValue}` | 데이터 field의 formatted·localized 값을 가져온다. | Salesforce 데이터에 바인딩될 수 있는 컴포넌트 property |
| `{!Item._detailURL}` | Salesforce CMS data item의 URL을 가져온다. | Salesforce CMS 콘텐츠(CMS content page 포함)에 바인딩될 수 있는 컴포넌트 property |
| `{!Label.namespace.name}` | Experience Builder에서 label 지정 시 label의 localized 값을 정의한다. | 먼저 Salesforce Setup에서 translated custom label을 만든다(*Translate Custom Labels* 참조). 그 후 text field가 있는 Experience Builder 컴포넌트에서 label 표현식을 사용하면 localized label을 본다. |
| `{!cmsMedia.contentKey}` | Salesforce CMS image의 URL을 가져온다. | **enhanced LWR 사이트의 모든 페이지의 HTML Editor 컴포넌트.** non-enhanced LWR 사이트에서는 미지원. |

---

## 기타 표현식 (Other Expressions)

query parameter를 가져오거나, 사이트의 올바른 basePath를 resolve하거나, 표현식에서 user field를 활용할 때 사용한다.

| Expression | Description | Supported Pages and Components |
|---|---|---|
| `{!Route.param}` | URL에서 query parameter를 가져온다. | 모든 페이지 · string property를 가진 out-of-the-box·custom 컴포넌트 · HTML Editor · Rich Content Editor |
| `{!param}` | `:`가 선행하는 URL에서 parameter 값을 가져온다. 예: `/global-search/:term` URL에서 `{!term}`을 가져옴. | URL에 dynamic parameter가 있는 모든 페이지 · string property를 가진 out-of-the-box·custom 컴포넌트 · HTML Editor · Rich Content Editor |
| `{!Site.basePath}` | LWR 사이트의 basePath로 resolve된다. | 모든 페이지 · string property를 가진 out-of-the-box·custom 컴포넌트 · HTML Editor · Rich Content Editor |
| `{!User.userId}` | 사용자의 Salesforce ID로 resolve된다. | 모든 페이지 · string property를 가진 out-of-the-box·custom 컴포넌트 · HTML Editor · Rich Content Editor |
| `{!User.isGuest}` | 사용자가 guest user인지에 따라 **TRUE 또는 FALSE**를 반환한다. | 모든 페이지 · string property를 가진 out-of-the-box·custom 컴포넌트 · HTML Editor · Rich Content Editor |
| `{!User.Record.<User sObject Field>}` | Salesforce User 객체 field의 값으로 resolve된다. | 모든 페이지 · string property를 가진 out-of-the-box·custom 컴포넌트 · HTML Editor · Rich Content Editor |

---

## 제약

- `{!param}` 또는 `{!Route.param}` 표현식을 **HTML Editor·Rich Content Editor** 컴포넌트에서 사용하면, 보안상 일부 HTML 특수문자가 escape(다른 값으로 치환)된다. 해당 문자: **`<`, `>`, `&`**.
- LWR 사이트는 **`{!CurrentUser.`로 시작하는** 인증된 사용자 정보를 표시하는 표현식을 **지원하지 않는다.**
- user data가 포함된 표현식은 **Rich Content Editor에서 Preview·Published 사이트에서만 resolve**된다.
- User 데이터 바인딩 시 `{!User.Record.<User sObject Field>}` 표현식으로 모든 User sObject field에 접근 가능. 또한 **Commerce 템플릿**으로 만든 사이트에서는 `{!User.Commerce.<Commerce Field>}` 표현식으로 Commerce 관련 user data에 접근 가능(*Expressions in Commerce Components* 참조).

> SEE ALSO: *Experience Cloud Developer Guide : Use Expressions in Aura Sites* (외부 가이드)

---

## 관련 노트

- 📖 공식: [LWR Sites for Experience Cloud](https://developer.salesforce.com/docs/atlas.en-us.exp_cloud_lwr.meta/exp_cloud_lwr/)
- [[LWR Sites (Experience Cloud)]] — hub: LWR 사이트 컴포넌트 개발·Apex+SOQL 검색(`{!Route.term}`)
- [[NavigationMixin 패턴]] — Route 기반 네비게이션·`comm__namedPage`
- [[LWR 동작·캐싱·제약]] — 형제 spoke: 퍼블리싱 모델·캐싱·dynamic import 제약 등 LWR 동작/제약
