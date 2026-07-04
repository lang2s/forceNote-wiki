---
tags: [lwc, reference, navigation, pagereference, navigationmixin, lightning-navigation]
source: developer.salesforce.com (Lightning Web Components Developer Guide — Reference > PageReference Types; 라이브 공식 문서, Tier 2, 접속 2026-07-04)
official_doc: https://developer.salesforce.com/docs/platform/lwc/guide/reference-page-reference-type.html
created: 2026-07-04
aliases: [PageReference, PageReference Types, NavigationMixin, standard__recordPage, standard__objectPage, standard__navItemPage, standard__component, standard__webPage, standard__flow, standard__quickAction, standard__app, standard__namedPage, comm__namedPage, comm__loginPage, knowledgeArticlePage, recordRelationshipPage, 네비게이션 타입]
---

# PageReference Types 레퍼런스

> LWC에서 네비게이션할 때 대상 페이지를 정의하는 `PageReference` 객체의 지원 타입 16종 — type 식별자·지원 컨테이너·프로퍼티 전수 레퍼런스.

---

## 개요

Lightning Experience(LEX)·Experience Builder 사이트·Salesforce 모바일 앱에서 네비게이션하려면, 대상 페이지를 기술하는 **`PageReference` 객체**를 정의한 뒤 `lightning/navigation` 모듈의 **`NavigationMixin`** 과 함께 사용한다.

- `PageReference`는 대상 페이지의 **type 식별자**(`standard__*`·`comm__*`)와 그에 따르는 **프로퍼티 집합**으로 구성된다.
- `PageReference`는 legacy Aura 이벤트 기반 네비게이션(`force:navigateToURL` 등)을 **대체(supersede)** 한다.
- **Experience Builder 사이트는 타입별로 제한적으로만 지원**한다(각 타입의 지원 컨테이너·제약을 확인).

네비게이션 how-to(패턴·`NavigationMixin.Navigate`/`GenerateUrl` 사용법)는 [[NavigationMixin 패턴]]에서 다룬다. 이 노트는 **타입·프로퍼티 레퍼런스**에 집중한다.

### 사용 예시 (NavigationMixin + PageReference)

```javascript
// 구조 예시 — 실제 동작 코드 아님 (문법은 공식 문서 기준, 예시값 명시)
import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class NavExample extends NavigationMixin(LightningElement) {
    // 1) Record Page — 특정 레코드 view
    navigateToRecord() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: '001XXXXXXXXXXXXXXX', // 18자 레코드 ID (예시값)
                objectApiName: 'Account',
                actionName: 'view'
            }
        });
    }

    // 2) Lightning Component — state로 파라미터 전달
    navigateToComponent() {
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'c__MyComponent'   // namespace__componentName
            },
            state: {
                c__counter: '5'   // key는 네임스페이스 포함 필수, value는 문자열
            }
        });
        // 결과 URL: /lightning/cmp/c__MyComponent?c__counter=5
    }

    // 3) Web Page — 외부 URL
    navigateToWebPage() {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: 'https://www.example.com'   // 예시값
            }
        });
    }
}
```

---

## 지원 타입 16종

각 타입의 `type` 식별자는 문자열 그대로 사용한다. 프로퍼티의 Required/Retired 표기는 공식 문서 기준.

### 1. App — `standard__app`

- **지원 컨테이너:** Lightning Experience
- App Launcher의 표준/커스텀 앱으로 네비게이션. 커스텀 네비게이션 아이템 생성용. 다른 앱으로 이동 시 기본적으로 같은 창에서 열린다.

| 프로퍼티 | 타입 | 설명 | Retired? |
|---|---|---|---|
| `appTarget` | String | 네비게이션 대상 앱. `appId` 또는 `appDeveloperName`를 전달. 표준 앱 네임스페이스 `standard__`, 커스텀 `c__`. `appId`=AppDefinition의 DurableId 필드, `appDeveloperName`=네임스페이스+developer name | **Yes(은퇴)** |
| `pageRef` | PageReference | 앱 내 특정 위치. `pageRef`와 해당 속성을 전달 | |

`appId`/`appDeveloperName`로 앱 홈 또는 오브젝트 레코드 페이지로 네비게이션할 수 있다.

### 2. External Record Page — `standard__externalRecordPage`

- **지원 컨테이너:** Experience Builder Aura Sites
- 외부 레코드와 상호작용. 현재 CMS Connect 페이지를 지원.

| 프로퍼티 | 타입 | 설명 | Required |
|---|---|---|---|
| `recordId` | String | 외부 레코드 ID | Yes |
| `objectType` | String | 외부 레코드 타입. CMS Connect는 `cms`만 | Yes |
| `objectInfo` | Object | `objectType` 레코드 식별을 위한 추가 정보 | Yes |

### 3. External Record Relationship Page — `standard__externalRecordRelationshipPage`

- **지원 컨테이너:** Experience Builder Aura Sites
- 특정 레코드의 외부 관계와 상호작용. 현재 Quip 문서만 지원.

| 프로퍼티 | 타입 | 설명 | Required |
|---|---|---|---|
| `recordId` | String | 18자 레코드 ID | Yes |
| `objectType` | String | 외부 레코드 타입. Quip 문서는 `quip`만 | Yes |

### 4. Lightning Component — `standard__component`

- **지원 컨테이너:** Lightning Experience, Salesforce Mobile App
- Lightning web component 또는 Aura component로 네비게이션. addressable하게 만들려면 LWC는 `lightning__UrlAddressable` 타깃(Aura는 `lightning:isUrlAddressable` 인터페이스)을 사용한다([[XML Config File Elements (js-meta.xml) 레퍼런스]] 참조).

| 프로퍼티 | 타입 | 설명 | Required |
|---|---|---|---|
| `componentName` | String | 컴포넌트 이름. 형식 `namespace__componentName` | Yes |

- `state` 객체에 임의의 key/value를 전달할 수 있다. **key는 네임스페이스를 포함해야 하고, value는 문자열**이어야 한다.
- 예: `state: { c__counter: '5' }` → URL `/lightning/cmp/c__MyComponent?c__counter=5`.

### 5. Knowledge Article — `standard__knowledgeArticlePage`

- **지원 컨테이너:** Lightning Experience, Experience Builder sites, Salesforce Mobile App

| 프로퍼티 | 타입 | 설명 | Required |
|---|---|---|---|
| `articleType` | String | Knowledge Article 레코드의 API 이름. Experience Builder 사이트에선 무시됨 | Yes |
| `urlName` | String | 대상 KnowledgeArticleVersion 레코드의 urlName(기사 URL) | Yes |

### 6. Login Page — `comm__loginPage`

- **지원 컨테이너:** Experience Builder sites

| 프로퍼티 | 타입 | 설명 | Required |
|---|---|---|---|
| `actionName` | String | `login` 또는 `logout` | Yes |

### 7. Managed Content Page (Salesforce CMS) — `standard__managedContentPage`

- **지원 컨테이너:** Experience Builder sites

| 프로퍼티 | 타입 | 설명 | Required |
|---|---|---|---|
| `contentTypeName` | String | Salesforce CMS 콘텐츠 타입 이름 | Yes |
| `contentKey` | String | CMS 콘텐츠를 식별하는 고유 content key | Yes |

### 8. Named Page (Experience Builder sites) — `comm__namedPage`

- **지원 컨테이너:** Experience Builder sites

| 프로퍼티 | 타입 | 설명 | Required |
|---|---|---|---|
| `name` | String | Experience Builder 페이지의 고유 이름(API Name). 지원 페이지: Home·Account Management·Contact Support·Error·Login·My Account·Top Articles·Topic Catalog·Custom page | Yes |

### 9. Named Page (Standard) — `standard__namedPage`

- **지원 컨테이너:** Lightning Experience, Salesforce Mobile App

| 프로퍼티 | 타입 | 설명 | Required |
|---|---|---|---|
| `pageName` | String | 고유 페이지명. 값: `home`·`chatter`·`today`·`dataAssessment`·`filePreview` | Yes |

### 10. Navigation Item Page — `standard__navItemPage`

- **지원 컨테이너:** Lightning Experience, Salesforce Mobile App
- 커스텀 탭에 매핑된 콘텐츠를 표시(Visualforce 탭·web 탭·Lightning Pages 등).

| 프로퍼티 | 타입 | 설명 | Required |
|---|---|---|---|
| `apiName` | String | 커스텀 탭의 고유 이름 | Yes |

### 11. Object Page — `standard__objectPage`

- **지원 컨테이너:** Lightning Experience, Experience Builder sites, Salesforce Mobile App

| 프로퍼티 | 타입 | 설명 | Required |
|---|---|---|---|
| `actionName` | String | `home`·`list`·`new`. Experience Builder 사이트는 `list`·`home` | Yes |
| `objectApiName` | String | 표준/커스텀 오브젝트 API 이름. managed package 커스텀 오브젝트는 `ns__` | Yes |
| `filterName` | String | 오브젝트 페이지의 ID 또는 developer name. 기본값 `Recent`. 지원 액션 `list` | |
| `defaultFieldValues` | String | `new`용 기본 필드값 key-value 목록(`lightning/pageReferenceUtils`로 생성) | |
| `nooverride` | String | 표준 액션엔 아무 값(예 `home`·`list`·`new`), override 액션엔 미지정 | |

### 12. Quick Action Page Type — `standard__quickAction`

- **지원 컨테이너:** Lightning Experience
- 표준/커스텀 quick action을 호출하는 Lightning 레코드 페이지.

| 프로퍼티 | 타입 | 설명 | Required |
|---|---|---|---|
| `apiName` | String | quick action API 이름. object-specific는 오브젝트명 접두(예 `Account.CreateContact`), global은 `Global.` 접두(예 `Global.SendEmail`). PlatformAction에서 조회 | Yes |
| `recordID` | String | 레코드 페이지 내에서 실행 시 state가 자동으로 그 recordId로 설정됨 | |
| `defaultFieldValues` | Object | quick action 필드를 pre-populate | |

### 13. Record Page — `standard__recordPage`

- **지원 컨테이너:** Lightning Experience, Experience Builder sites, Salesforce Mobile App

| 프로퍼티 | 타입 | 설명 | Required |
|---|---|---|---|
| `actionName` | String | `clone`·`edit`·`view`. **Experience Builder 사이트는 clone/edit 미지원** | Yes |
| `objectApiName` | String | 레코드 오브젝트 API 이름. lookup은 선택. Experience Builder LWR 사이트에서만 필수, 그 외 컨테이너에서는 선택 | |
| `recordId` | String | 18자 레코드 ID | Yes |
| `nooverride` | String | 표준 액션엔 아무 값, override 액션엔 미지정 | |

### 14. Record Relationship Page — `standard__recordRelationshipPage`

- **지원 컨테이너:** Lightning Experience, Experience Builder sites, Salesforce Mobile App

| 프로퍼티 | 타입 | 설명 | Required |
|---|---|---|---|
| `actionName` | String | `view`만 지원 | Yes |
| `objectApiName` | String | 관계를 정의하는 오브젝트 API 이름. lookup은 선택. LWR 사이트에서만 필수 | |
| `recordId` | String | 관계를 정의하는 레코드의 18자 ID | Yes |
| `relationshipApiName` | String | 오브젝트 관계 필드 API 이름 | Yes |

### 15. Standard Flow — `standard__flow`

- **지원 컨테이너:** Lightning Experience
- active screen/autolaunched flow를 실행하는 페이지.

| 프로퍼티 | 타입 | 설명 | Required |
|---|---|---|---|
| `devName` | String | flow 이름(`flowName` 또는 `namespace__flowName`) | Yes |
| `retURL` | String | flow 종료 시 리다이렉트할 상대 URL | |

- flow 입력 변수는 `state` 객체로 전달하며, key는 `flow__` 접두를 붙인다.

### 16. Web Page — `standard__webPage`

- **지원 컨테이너:** Lightning Experience, Experience Builder sites, Salesforce Mobile App

| 프로퍼티 | 타입 | 설명 | Required |
|---|---|---|---|
| `url` | String | 네비게이션 대상 URL | Yes |

- ⚠️ Aura 기반 Experience Builder 사이트에서 `/apex/`·`/sfdcpage/` 등 특정 URL은 제한된다(legacy Aura `force:navigateToURL`·`window.open` 관련).

---

## See Also (공식 문서 위임)

공식 문서의 관련 how-to: Navigate to Different Page Types · Navigate to Pages, Records, and Lists · Open Files · Component Reference `lightning-navigation`. 위키 내 how-to는 아래 관련 노트 참조.

## 관련 노트
- [[NavigationMixin 패턴]] — 네비게이션 how-to(이 노트는 타입·프로퍼티 레퍼런스)
- [[XML Config File Elements (js-meta.xml) 레퍼런스]] — `lightning__UrlAddressable` 타깃(`standard__component`와 짝)
- [[HTML 템플릿 Directives 레퍼런스]] — 형제 레퍼런스
- [[@salesforce Modules 레퍼런스]] — 형제 레퍼런스
- [[Lightning Console JS API]] — 콘솔 네비게이션 API
- [[LWC MOC]] — LWC 섹션 목차
