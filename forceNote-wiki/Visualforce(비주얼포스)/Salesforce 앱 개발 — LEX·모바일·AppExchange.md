---
tags: [visualforce, vf, lightning-experience, mobile, sforce-one, appexchange, legacy]
source: salesforce_pages_developers_guide.pdf (Visualforce Developer Guide, v67.0 Summer '26)
created: 2026-06-21
aliases: [Visualforce Lightning Experience, sforce.one, VF 모바일 앱, Visualforce AppExchange, VF CSP 도메인]
---

# Salesforce 앱 개발 — LEX·모바일·AppExchange

> Visualforce로 Salesforce 모바일 앱·Lightning Experience를 확장하는 법(Ch19) — `one.app`/`/lightning` iframe 컨테이너 제약, `sforce.one` 네비게이션 객체 전수, 모바일에서 피해야 할 컴포넌트·Known Issues, SLDS 적용, 커스텀 액션·성능 캐싱 — 과 AppExchange managed package에 VF를 넣을 때의 제약(Ch20).

> 레거시 안내 — Visualforce는 Salesforce Classic 기반 레거시 마크업 프레임워크다. 신규 모바일/Lightning UI 개발은 Lightning Web Components(LWC)·Lightning Aura Components 권장이며, 본 챕터는 기존 VF 페이지를 Salesforce 모바일 앱·Lightning Experience 컨테이너에서 동작·정렬시키기 위한 호환·이식 지침이다.

---

이 노트는 Visualforce Developer Guide(v67.0 Summer '26) **Chapter 19 — "Developing Salesforce Apps with Visualforce"(p.286–332)** 와 **Chapter 20 — "Adding Visualforce to a Salesforce AppExchange App"(p.333–335)** 를 다룬다.

> PDF p.286–332에는 모바일 앱 화면 스크린샷이 다수 있으나(레이아웃·키보드·아이콘 등) `pdftotext`로는 캡처되지 않는다. 본 노트는 **스크린샷의 본문 설명만** 옮겼다 — "(PDF 스크린샷 — 텍스트만)"으로 표시된 항목은 PDF에 이미지가 있으나 여기엔 텍스트 설명만 있다는 뜻이다.

> 외관·출력 제어(`$User.UITheme`, `UITheme.getUITheme()`, `lightningStylesheets`, `renderAs="pdf"`, `<apex:slds>` 의 스타일 메커니즘 등)는 Chapter 4 소관으로 본 노트 범위 밖이다 — [[페이지 출력 제어 — HTML·PDF·SLDS]] 참조. 본 노트의 SLDS 섹션은 **모바일 페이지에서 SLDS를 적용하는 절차**만 다룬다.

---

## 1. Visualforce로 Salesforce 앱 개발하기 (개요)

개발자는 Visualforce로 Salesforce 모바일 앱을 확장·기능 추가할 수 있다. Visualforce로 Salesforce용을 개발하면 Salesforce 데이터에 접근하고 Lightning Platform 위에서 동작하는 통합 경험을 만들 수 있다. 데스크톱과 모바일이 공유하는 페이지를 만들거나, 모바일 앱 전용 페이지를 만들 수 있다.

> Note: Visualforce 페이지와 커스텀 iframe은 **iPad Safari의 Lightning Experience에서 지원되지 않는다.**

Salesforce용 개발은 프로세스·도구에 유연성을 준다. 예를 들어 Salesforce Lightning Design System(SLDS)으로 Lightning Experience의 원칙·디자인 언어·베스트 프랙티스에 일관된 앱을 만들 수 있고, JavaScript 도구나 서드파티 프레임워크를 넣어 인터랙티브한 UX를 만들 수도 있다.

---

## 2. Salesforce Platform 개발 프로세스

Lightning Experience와 Salesforce 모바일 앱의 개발 프로세스는 **동일**하다. Salesforce Classic 개발에 익숙하다면 몇 가지 차이가 있으나 대부분 익숙할 것이다. 모바일 앱용 VF 페이지를 만들 때는 도구와 테스트 환경을 올바로 설정하는 것이 중요하다.

### 2.1 개발 시스템 설정

#### 에디터 선택
먼저 코드 작성 도구를 설정한다. **Developer Console**, **Salesforce Extensions for Visual Studio Code**, **Setup 에디터** 모두 Salesforce 앱·Lightning Experience·Salesforce Classic 개발에 동작한다. 유일한 예외는 **Visualforce Development Mode 푸터**로, Salesforce Classic에서만 사용 가능하다.

#### Visualforce 페이지 보기
Salesforce Classic에서는 `https://yourInstance.salesforce.com/apex/PageName` URL 패턴으로 페이지를 본다. 이 방법은 Lightning Experience에서 Salesforce 앱 페이지를 보는 데는 **동작하지 않는다** — 직접 URL 접근으로 본 페이지는 항상 Salesforce Classic으로 표시되기 때문이다.

Lightning Experience에서 페이지를 보려면 `https://yourInstance.salesforce.com/lightning` 으로 간다. 특정 VF 페이지로 가는 가장 간단한 방법은 그 페이지에 탭을 만들고 App Launcher의 All Items 섹션에서 그 탭으로 이동하는 것이다. 장기적으로는 "In Development" 앱을 만들어 작업 중 VF 탭을 추가/제거한다.

1. Setup에서 Quick Find에 `Apps` 입력 → **App Manager** 선택.
2. **New Lightning App** 클릭 → 개발 중 페이지용 커스텀 앱 생성.
   > Note: 앱을 System Administrators 또는 개발자용으로 만든 프로파일로만 제한하는 것을 고려하라.
3. Setup에서 `App Menu` 입력 → **App Menu** 선택.
4. In Development 앱이 **Visible in App Launcher** 로 설정됐는지 확인.
5. Setup에서 `Tabs` 입력 → **Tabs** 선택.
6. Visualforce Tabs 섹션에서 **New** 클릭 → 개발 중 페이지용 커스텀 탭 생성. 탭은 개발 사용자 프로파일에만 보이게, In Development 앱에만 추가.
7. 추가할 페이지마다 이전 단계 반복.

브라우저 메뉴/툴바에 아래 북마클릿을 추가해 페이지로 직접 이동할 수도 있다. 이 JavaScript는 Lightning Experience의 `navigateToURL` 이벤트를 발생시키며, classic의 `/apex/PageName` URL 입력과 동등하다.

```javascript
javascript:(function(){
var pageName = prompt('Visualforce page name:');
$A.get("e.force:navigateToURL").setParams(
{"url": "/apex/" + pageName}).fire();})();
```

### 2.2 개발 프로세스와 테스트의 중요성

프로덕션 배포 전 VF 페이지를 테스트하는 것이 중요하다. 여러 환경·디바이스·사용자에서 테스트하라. 다양한 가능성을 지원해야 한다면 테스트 계획은 다음 교차 케이스를 고려해야 한다.

- 지원하는 각 디바이스
- 지원하는 각 운영체제
- 지원하는 각 브라우저 — Salesforce 모바일 앱이 임베드한 브라우저 포함
- 지원하는 각 UI 컨텍스트 (Lightning Experience, Salesforce Classic, Salesforce 모바일 앱)

> Salesforce 모바일 앱을 **에뮬레이터에서 실행하는 것은 정상 사용으로 지원되지 않는다.** 에뮬레이터는 편리하지만 조직이 지원하는 실제 모바일 디바이스에서의 전체 테스트를 대체하지 못한다. 개발 중 배포 예정인 모든 디바이스·플랫폼에서 정기적으로 테스트하라.

### 2.3 Salesforce 모바일 앱에서 VF 페이지 테스트하기

Lightning Experience·Salesforce Classic·모바일 앱 모두에서 쓰일 페이지라면 작업 중 모든 환경에서 검토하라. 철저히 테스트하려면 여러 브라우저나 여러 디바이스를 쓰고, 추가 테스트 사용자를 최소 한 명 확보한다.

개발 환경 구성 예 (세 환경):

| 환경 | Browser | User | UI 설정 |
|---|---|---|---|
| **Main Development** — Setup에서 조직 변경(커스텀 객체·필드 추가), Developer Console로 코드 작성. Salesforce Classic에서 디자인·동작 검토 | Chrome | Your developer user | Salesforce Classic |
| **Lightning Experience Review** — LEX에서 디자인·동작 확인 | Safari 또는 Firefox | Your test user | Lightning Experience |
| **Salesforce App Review** — 모바일 앱에서 디자인·동작 확인 | Salesforce app | Your test user | Lightning Experience 또는 Salesforce Classic (Device: iOS 또는 Android phone/tablet) |

---

## 3. Salesforce 모바일 앱 컨테이너 이해하기

Salesforce Classic에서는 Visualforce가 페이지·요청·환경을 "소유"한다 — Visualforce가 애플리케이션 컨테이너다. 그러나 Salesforce 모바일 앱과 Lightning Experience에서는 **Visualforce가 더 큰 `/lightning` 컨테이너 안의 iframe 내부에서 실행된다.**

> Note: 모바일 앱 컨테이너와 Lightning Experience 컨테이너가 같은가? **Yes and no.** 둘 다 `/lightning` 컨테이너의 파생이고 한쪽용 코드는 다른 쪽에서도 동작한다. 그러나 내부 동작은 약간 다르다 — 모바일 앱은 모바일 디바이스의 모바일 브라우저에서, Lightning Experience는 데스크톱의 표준 데스크톱 브라우저에서 실행된다. 각 컨텍스트로 보내는 `/lightning` 버전을 최적화하며, 실행 브라우저 환경도 눈에 띄게 다르다. 요컨대 **대부분 유사한 능력을 가진 별개의 컨테이너로 취급**하라.

### 3.1 Outer Container와 Inner iframe

외부 Salesforce 앱 컨테이너는 `/lightning` URL로 접근하는 **single-page application** 이다. `/lightning` 페이지가 로드되고 코드가 시작되면 그 애플리케이션 코드가 환경을 장악한다.

Visualforce 페이지는 HTML iframe 안에서 실행되며, 이는 사실상 메인 `/lightning` 브라우징 콘텐츠와 **분리된 브라우저 창**을 만든다. Salesforce 앱이 부모 컨텍스트, Visualforce 페이지가 자식 컨텍스트다. 즉 VF 페이지는 `/lightning` 외부 컨테이너의 제약 아래서 동작하면서 iframe 컨텍스트에 격리된다.

### 3.2 Salesforce 앱용 VF 코드 고려사항

가능하면 UI 컨텍스트와 무관하게 올바로 동작하는 VF 페이지를 만들라. 보통 Salesforce Classic용 VF 코드는 모바일 앱에서 "just works"한다. 그러나 컨테이너 때문에 일부 상황에서는 변경이 필요하다.

#### 보안 고려사항 (Security Considerations)
영향받을 수 있는 보안 요소:
- Session maintenance and renewal (세션 유지·갱신)
- Authentication (인증)
- Cross-domain requests (교차 도메인 요청)
- Embedding restrictions (임베딩 제약)

특히 **세션 유지** — 매 요청마다 username/password를 입력하는 대신 브라우저가 쓰는 토큰 관리 — 에 주의하라. 현재 세션 접근에는 글로벌 변수 `$Api.Session_ID` 를 자주 쓰는데, `$Api.Session_ID` 는 **요청의 도메인에 따라 다른 값을 반환**한다. 모바일 앱과 VF 페이지는 서로 다른 도메인에서 서빙되므로, VF iframe 내부의 세션 ID는 외부의 세션 ID와 다르다. 모바일 앱 컨테이너에서는 이것이 세션 ID 관리 방식을 바꿀 수 있다.

#### 스코프 고려사항 (Scope Considerations)
조정이 필요할 수 있는 스코프 요소:
- DOM access and modification (DOM 접근·수정)
- JavaScript scope, visibility, and access
- `window.location` 같은 JavaScript 전역 변수

요컨대 VF 페이지의 JavaScript 코드는 **iframe의 브라우저 컨텍스트 내 요소에만** 영향을 줄 수 있고, 부모 컨텍스트에는 영향을 줄 수 없다.

#### 모바일 앱 컨테이너에서 피해야 할 기능 (Features to Avoid)
모바일 앱 컨테이너는 일부 VF 컴포넌트가 기대대로 동작하지 못하게 막는다.

- 모바일 앱 컨테이너 내의 VF 페이지에서 `<apex:iframe>` 사용을 피하라. iframe과 그것이 DOM·JavaScript에 미치는 영향을 정말 이해할 때만 써라.
- `contentWindow` 나 `window.parent` 로 부모 브라우저 컨텍스트에 접근하는 것을 피하라 — VF와 모바일 앱은 다른 도메인에서 서빙되기 때문이다.
- `window.location` 을 직접 설정하는 것을 피하라 — VF iframe은 `window.location` 에 직접 접근할 수 없다.
- `link = '/' + accountId + '/e'` 같은 정적 패턴으로 만든 하드코딩 URL 사용을 피하라. 대신 VF 마크업에서는 `{!URLFOR($Action.Contact.Edit, recordId)}`, JavaScript에서는 `navigateToSObject(recordId)` 를 써라.

---

## 4. 모바일 앱에서 VF 페이지가 나타날 수 있는 위치

VF 페이지를 만들면 UI의 여러 곳에서 접근 가능하게 만들 수 있다.

- 기본 네비게이션 메뉴 — **Mobile Only** 라고 불리며, 화면 하단 네비게이션 바의 아이콘을 탭하면 나온다. (PDF 스크린샷 — 텍스트만)
- **Action bar 및 action menu** — 액션을 지원하는 모든 페이지 상단에서 사용 가능. (PDF 스크린샷 — 텍스트만)

VF 마크업에서 "Navigation with the sforce.one Object"에 나열된 지원 네비게이션 호출을 사용해 다른 VF 페이지를 참조·링크할 수도 있다. 다단계(multi-page) 프로세스의 모든 페이지에서 **Available for Lightning Experience, Experience Builder sites, and the mobile app** 을 선택해야 한다.

참조된 페이지에 이 옵션이 선택돼 있지 않더라도, 참조하는(부모) 페이지가 나타나는 것을 막지는 않는다. 그러나 사용자가 비-모바일 페이지에 접근하려 하면 **"Unsupported Page"** 에러 메시지를 받는다.

---

## 5. 가이드라인과 베스트 프랙티스

VF 페이지는 모바일 앱에서 자동으로 모바일 친화적이지 않다. 표준 Salesforce 헤더·사이드바는 모바일 컨트롤로 대체돼 비활성화되며, VF 페이지가 모바일 네비게이션 관리와 연결되도록 JavaScript API가 제공된다. 그 외에는 페이지가 그대로 유지되므로, 앱 안에서 쓸 수는 있어도 데스크톱 중심 VF 페이지는 데스크톱처럼 느껴진다.

다행히 모바일 앱에서 보기 좋게 만드는 것은 간단하다 — 전체 Salesforce 사이트와 모바일 앱 둘 다에서 동작하도록 코드를 고치거나, 모바일 전용 페이지를 만들면 된다.

> Note: VF 페이지와 커스텀 iframe은 iPad Safari의 Lightning Experience에서 지원되지 않는다.

배울 베스트 프랙티스: 모바일·데스크톱 간 페이지 공유 / 모바일·데스크톱에서 VF 제외 / 최선의 아키텍처 선택 / 효과적 페이지 레이아웃 선택 / 사용자 입력·네비게이션 관리 / VF 페이지를 커스텀 액션으로 사용 / 성능 튜닝.

### 5.1 모바일·데스크톱 간 VF 페이지 공유

두 환경 모두에서 동작해야 하는 VF 페이지:
- 커스텀 액션으로 쓰이는 페이지 — 모바일 앱에서는 action bar, 전체 사이트에서는 publisher menu에 나타남.
- 일반 페이지 레이아웃에 추가된 페이지 — 페이지에 **Available for Lightning Experience, Experience Builder sites, and the mobile app** 이 활성화됐을 때.
- 일반 페이지 레이아웃에 추가된 커스텀 VF 버튼/링크.
- New, Edit, View, Delete, Clone 액션의 표준 버튼 오버라이드. 앱에서는 표준 list/tab 컨트롤 오버라이드가 지원되지 않는다. 위 옵션이 활성화되지 않으면 버튼 오버라이드는 앱에 나타나지 않는다.

> Note: 표준 버튼을 VF 페이지로 오버라이드했는데 그 VF 페이지에 위 옵션이 선택되지 않으면, 그 표준 버튼은 앱의 레코드 상세 페이지·레코드 목록에서 **사라진다.**

### 5.2 모바일 또는 데스크톱에서 VF 페이지 제외

탭·네비게이션 설정으로 VF 페이지를 모바일 앱 또는 전체 사이트에 추가한다. 데스크톱 전용/모바일 전용으로 설정 가능한 페이지:
- 일반 페이지 레이아웃에 추가된 페이지에서 위 옵션이 **비활성화**됐을 때 — 전체 Salesforce 사이트에만 나타남.
- Visualforce 탭에 쓰인 페이지 — 모바일 네비게이션에 탭을 추가하는 작업은 전체 사이트 네비게이션과 별도로 한다.

### 5.3 모바일·데스크톱 둘 다에서 동작하는 페이지 만들기

모바일 앱은 네비게이션 컨트롤·이벤트 처리 프레임워크를 제공하는데, 이 프레임워크는 **`sforce` 객체가 앱 안에서만 페이지에 주입**되므로 전체 사이트에서 실행될 때는 VF 페이지에서 쓸 수 없다. 따라서 공유 페이지에서는 `sforce` 객체가 있으면 그것을, 없으면 표준 VF 네비게이션을 쓰도록 코드를 작성해야 한다.

다음은 quick order를 만드는 `@RemoteAction` 메서드에서 JavaScript remoting 요청이 성공 반환된 후 실행되는 코드다. 커스텀 액션으로 쓰여 모바일 앱의 action bar와 전체 사이트의 publisher menu에 추가되므로 두 곳 모두에서 동작해야 한다. 의도는 주문이 들어간 account의 상세 페이지로 이동하는 것이다.

```javascript
// Go back to the Account detail page
if( (typeof sforce != 'undefined') && sforce && (!!sforce.one) ) {
// Salesforce app navigation
sforce.one.navigateToSObject(aId);
}
else {
// Set the window's URL using a Visualforce expression
window.location.href =
'{!URLFOR($Action.Account.View, account.Id)}';
}
```

`if` 문은 `sforce` 객체가 사용 가능·유효한지 검사한다 — 페이지가 앱 안에서 실행될 때만 true다. 사용 가능하면 모바일 네비게이션 관리 시스템으로 account 상세로 이동한다. `sforce` 객체가 없으면 그것으로 네비게이션을 시도할 경우 JavaScript 에러가 나고 이동이 일어나지 않으므로, 대신 VF 표현식으로 window URL을 설정한다. 앱에서는 이렇게 하면 안 되는데(네비게이션 이벤트가 프레임워크에 의해 손실됨), 일반 VF에서는 필요하다.

> Note: 이런 공통 테스트는 헬퍼 함수로 추출하는 것이 베스트 프랙티스다. JavaScript static resource에 아래 같은 것을 넣고 `if` 조건에서 `ForceUI.isSalesforce1()` 만 호출하면, 탐지 로직이 바뀌어도 한 곳만 고치면 된다.

```javascript
(function(myContext){
myContext.ForceUI = myContext.ForceUI || {};
myContext.ForceUI.isSalesforce1 = function() {
return((typeof sforce != 'undefined') && sforce && (!!sforce.one));
}
})(this);
```

> SEE ALSO: `$Action`

---

## 6. 모바일 앱용 VF 페이지 아키텍처 선택

페이지를 설계·구조화하는 방법은 여러 가지이며, 개발 시간·필요 숙련도·모바일 앱과의 일치도 면에서 trade-off가 다르다. 세 가지 접근:

| 접근 | 요약 | trade-off |
|---|---|---|
| **Standard Visualforce Pages** | 일반 VF 페이지를 모바일 브라우저에서 그대로 렌더링 | UX는 약간 떨어지나 개발 빠름. 전체 사이트처럼 표시되고 다른 모바일 기능과 시각적으로 안 맞음 |
| **Mixed Visualforce and HTML** | 폼 요소·출력 텍스트는 VF 태그, 페이지 구조는 static HTML | 모바일 앱 디자인에 더 가깝게 매칭. 모바일 전용엔 빠르나 모바일+데스크톱 공유엔 덜 적합 |
| **JavaScript Remoting and Static HTML** | JS remoting + static HTML로 대부분 VF 태그 회피, 요소를 JS로 렌더링 | 최고의 UX·성능·일치도. 가장 높은 숙련도 필요, 셋업 더 오래 걸림. Salesforce Mobile Packs로 빠른 시작 |

### 6.1 Standard Visualforce Pages

일반 VF 페이지는 모바일 브라우저에서 잘 렌더링되며 그대로 쓸 수 있다(모바일 최적화 웹 페이지 대비 UX는 약간 감소). 전체 사이트처럼 표시되며 다른 모바일 앱 기능과 시각적으로 매칭되지 않는다.

**제약:**
- Tap targets(버튼·링크·폼 필드 등)가 마우스 커서용으로 최적화돼 손가락으로 정확히 누르기 어려울 수 있다.
- 시각 디자인이 그대로라 모바일 최적화된 현대적 디자인과 안 맞을 수 있다.

개발 일정이 빡빡하면 이 제약이 수용 가능할 수 있다.

```xml
<apex:page standardController="Warehouse__c">
<apex:form>
<apex:pageBlock title="{! warehouse__c.Name }">
<apex:pageBlockSection title="Warehouse Details" columns="1">
<apex:inputField value="{! warehouse__c.Street_Address__c }"/>
<apex:inputField value="{! warehouse__c.City__c }"/>
<apex:inputField value="{! warehouse__c.Phone__c }"/>
</apex:pageBlockSection>
<apex:pageBlockButtons location="bottom">
<apex:commandButton action="{! quickSave }" value="Save"/>
</apex:pageBlockButtons>
</apex:pageBlock>
</apex:form>
</apex:page>
```

이 페이지는 모바일 앱·전체 사이트 둘 다에서 쓸 수 있으며, 두 컨텍스트에서 표준 데스크톱 VF 페이지로 표시된다.

### 6.2 Mixed Visualforce and HTML

폼 요소·출력 텍스트엔 VF 태그를, 페이지 구조엔 static HTML을 결합해 모바일 앱 디자인에 더 가까운 페이지를 만든다. 이렇게 설계해도 표준 요청-응답 사이클, 표준 컨트롤러, `<apex:inputField>`, POSTBACK과 view state를 쓰므로 여전히 "standard" VF다. 전체 사이트용과의 주 차이는 구조 추가용 VF 태그를 줄이거나 없애고 static HTML을 쓴다는 점 — `<apex:pageBlock>`, `<apex:pageBlockSection>` 등을 `<div>`, `<p>`, `<span>` 등으로 대체한다.

이 접근은 VF 컴포넌트가 자동 적용하던 스타일 대신 CSS 스타일시트를 직접 만들어야 한다. 시간은 걸리지만 모바일 앱 디자인에 훨씬 가까워진다(반면 전체 사이트와는 시각적으로 안 맞게 됨).

**적용 규칙:**
- 다음 VF 태그를 쓰지 말 것: `<apex:pageBlock>`, `<apex:pageBlockButtons>`, `<apex:pageBlockSection>`, `<apex:pageBlockSectionItem>`, `<apex:pageBlockTable>`
- 폼에는 `<apex:form>`, `<apex:inputField>` 또는 `<apex:input>`, `<apex:outputLabel>` 사용.
- 편집 불가 텍스트엔 `<apex:outputText>` 또는 Visualforce 사용.
- 페이지 구조엔 선호하는 HTML 사용: `<div>`, `<span>`, `<h1>`, `<p>` 등.
- 시각 디자인엔 CSS 스타일링 적용.

**장점:** 합리적으로 빠른 개발 시간(일반 VF 도구·프로세스 사용), 기존 페이지 재활용 용이, 모바일 앱 룩앤필에 더 근접.
**제약:** 일반 VF 라운드트립을 하므로 페이로드가 큼(JS remoting 대비), `<apex:pageBlock>` 등이 자동 추가하던 스타일을 대체할 CSS 추가 작업.

```xml
<apex:page standardController="Warehouse__c">
<style>
html, body, p { font-family: sans-serif; }
</style>
<apex:form >
<h1>{!Warehouse__c.Name}</h1>
<h2>Warehouse Details</h2>
<div id="theForm">
<div>
<apex:outputLabel for="address" value="Street Address"/>
<apex:inputField id="address"
value="{! warehouse__c.Street_Address__c}"/>
</div>
<div>
<apex:outputLabel for="city" value="City"/>
<apex:inputField id="city"
value="{! warehouse__c.City__c}"/>
</div>
<div>
<apex:outputLabel for="phone" value="Phone"/>
<apex:inputField id="phone"
value="{! warehouse__c.Phone__c}"/>
</div>
</div>
<div id="formControls">
<apex:commandButton action="{!quickSave}" value="Save"/>
</div>
</apex:form>
</apex:page>
```

전체 사이트에선 표준 페이지로(폼은 전체 스타일 없이), 모바일 앱에선 모바일 스타일에 대략 맞게 표시된다. 추가 스타일로 두 버전 모두에 근사시킬 수 있다.

### 6.3 JavaScript Remoting and Static HTML

JS remoting + static HTML로 최고의 UX·성능·일치도를 제공한다. 대부분 VF 태그를 버리고 페이지 요소를 JavaScript로 렌더링한다. 가장 높은 개발 숙련도가 필요하고 셋업이 다소 오래 걸린다. **Salesforce Mobile Packs** 로 빠르게 시작할 수 있다.

> Important: 가능한 곳에서는 회사 가치(Equality)에 맞춰 비포용적 용어를 변경했다. 고객 구현에 영향을 피하기 위해 일부 용어는 유지했다. [sic]

이 방식은 표준 VF의 자동·단순화 기능 다수를 버리고 요청-응답 사이클을 더 직접 제어하며 페이지 reload 대신 JavaScript로 페이지를 갱신한다. 저대역폭·고지연 무선 연결에서 성능을 크게 개선할 수 있다. 단점은 코드량이 많고 JavaScript·JS remoting·HTML5·모바일 툴킷·CSS와 Apex·VF 전문성이 필요하다는 것. 장점은 최신 모바일 개발 도구로 작업하며 앱에 완전히 통합되는 커스텀 기능을 "snap in"할 수 있다는 것. 스타일링을 커스터마이즈하면 두 환경에서 공유도 가능하나 전체 사이트 룩앤필을 정확히 맞추긴 어렵다. 가장 중요한 점은 페이지가 fully responsive하게 만들어질 수 있다는 것.

**적용 절차:**
1. 선호하는 Salesforce Mobile Pack을 static resource로 조직에 설치.
2. 페이지 `docType` 을 `html-5.0` 으로 설정. 표준 stylesheet·header 비활성화를 강력 고려.

```xml
<apex:page standardController="Warehouse__c"
extensions="WarehouseEditor"
showHeader="false" standardStylesheets="false"
docType="html-5.0">
```

3. 선택한 모바일 툴킷의 script·style을 VF resource 태그로 추가.

```xml
<apex:includeScript
value="{!URLFOR(
$Resource.Mobile_Design_Templates,
'Mobile-Design-Templates-master/common/js/
jQuery2.0.2.min.js'
)}"/>
```

4. HTML5와 툴킷 태그·속성으로 페이지 스켈레톤 생성.
5. 사용자 인터랙션에 응답하는 JavaScript 핸들러 추가. JS remoting으로 Apex `@RemoteAction` 메서드를 호출해 레코드 조회·DML 수행.
6. 사용자 액션·페이지 갱신 처리용 JavaScript 함수 추가. 페이지 갱신은 JavaScript에서 HTML 요소를 구성해 스켈레톤에 추가/append.

전체 remoting+HTML VF 페이지 예시:

```xml
<apex:page standardController="Warehouse__c" extensions="WarehouseEditor"
showHeader="false" standardStylesheets="false"
docType="html-5.0" applyHtmlTag="false" applyBodyTag="false">
<!-- Include Mobile Toolkit styles and JavaScript -->
<apex:stylesheet
value="{!URLFOR($Resource.Mobile_Design_Templates,
'Mobile-Design-Templates-master/common/css/app.min.css')}"/>
<apex:includeScript
value="{!URLFOR($Resource.Mobile_Design_Templates,
'Mobile-Design-Templates-master/common/js/jQuery2.0.2.min.js')}"/>
<apex:includeScript
value="{!URLFOR($Resource.Mobile_Design_Templates,
'Mobile-Design-Templates-master/common/js/jquery.touchwipe.min.js')}"/>
<apex:includeScript
value="{!URLFOR($Resource.Mobile_Design_Templates,
'Mobile-Design-Templates-master/common/js/main.min.js')}"/>
<head>
<style>
html, body, p { font-family: sans-serif; }
input { display: block; }
</style>
<script>
$(document).ready(function(){
// Load the record
loadWarehouse();
});
// Utility; parse out parameter by name from URL query string
$.urlParam = function(name){
var results = new RegExp('[\\?&]' + name + '=([^&#]*)')
.exec(window.location.href);
return results[1] || 0;
}
function loadWarehouse() {
// Get the record Id from the GET query string
warehouseId = $.urlParam('id');
// Call the remote action to retrieve the record data
Visualforce.remoting.Manager.invokeAction(
'{!$RemoteAction.WarehouseEditor.getWarehouse}',
warehouseId,
function(result, event){;
if(event.status){
console.log(warehouseId);
$('#warehouse_name').text(result.Name);
$('#warehouse_address').val(
result.Street_Address__c);
$('#warehouse_city').val(result.City__c);
$('#warehouse_phone').val(result.Phone__c);
} else if (event.type === 'exception'){
console.log(result);
} else {
// unexpected problem...
}
});
}
function updateWarehouse() {
// Get the record Id from the GET query string
warehouseId = $.urlParam('id');
// Call the remote action to save the record data
Visualforce.remoting.Manager.invokeAction(
'{!$RemoteAction.WarehouseEditor.setWarehouse}',
warehouseId, $('#warehouse_address').val(),
$('#warehouse_city').val(),
$('#warehouse_phone').val(),
function(result, event){;
if(event.status){
console.log(warehouseId);
$('#action_status').text('Record updated.');
} else if (event.type === 'exception'){
console.log(result);
$('#action_status').text(
'Problem saving record.');
} else {
// unexpected problem...
}
});
}
</script>
</head>
<body>
<div id="detailPage">
<div class="list-view-header" id="warehouse_name"></div>
<div id="action_status"></div>
<section>
<div class="content">
<h3>Warehouse Details</h3>
<div class="form-control-group">
<div class="form-control form-control-text">
<label for="warehouse_address">
Street Address</label>
<input type="text" id="warehouse_address" />
</div>
<div class="form-control form-control-text">
<label for="warehouse_city">City</label>
<input type="text" id="warehouse_city" />
</div>
<div class="form-control form-control-text">
<label for="warehouse_phone">Phone</label>
<input type="text" id="warehouse_phone" />
</div>
</div>
</div>
</section>
<section class="data-capture-buttons one-buttons">
<div class="content">
<section class="data-capture-buttons one-buttons">
<a href="#" id="updateWarehouse"
onClick="updateWarehouse();">save</a>
</section>
</div>
</section>
</div> <!-- end detail page -->
</body>
</apex:page>
```

static HTML이 빈 폼 필드를 포함한 페이지 셸을 제공하고, JavaScript 함수가 레코드를 로드·채우고 갱신 데이터를 Salesforce로 돌려보낸다. 전체 사이트에서도 쓸 수 있으나 Salesforce 앱 페이지로 설계됐으므로 일반 VF 페이지와 매우 다르게 보인다.

위 페이지를 지원하는 컨트롤러 확장 예시 — 다른 두 접근과 달리 remoting+HTML은 표준 컨트롤러 기능을 쓰지 않고 컨트롤러 확장/커스텀 컨트롤러에 `@RemoteAction` 메서드를 추가한다.

```apex
global with sharing class WarehouseEditor {
// Stub controller
// We're only using RemoteActions, so this never runs
public WarehouseEditor(ApexPages.StandardController ctl){ }
@RemoteAction
global static Warehouse__c getWarehouse(String warehouseId) {
// Clean up the Id parameter, in case there are spaces
warehouseId = warehouseId.trim();
// Simple SOQL query to get the warehouse data we need
Warehouse__c wh = [
SELECT Id, Name, Street_Address__c, City__c, Phone__c
FROM Warehouse__c
WHERE Id = :warehouseId];
return(wh);
}
@RemoteAction
global static Boolean setWarehouse(
String whId, String street, String city, String phone) {
// Get the warehouse record for the Id
Warehouse__c wh = WarehouseEditor.getWarehouse(whId);
// Update fields
// Note that we're not validating / sanitizing, for simplicity
wh.Street_Address__c = street.trim();
wh.City__c = city.trim();
wh.Phone__c = phone.trim();
// Save the updated record
// This should be wrapped in an exception handler
update wh;
return true;
}
}
```

---

## 7. 모바일 앱에서 VF 성능 최적화

모바일 디바이스는 컴퓨팅 자원이 더 제한적이고 사용자는 빠른 반응을 기대하므로 최적화 베스트 프랙티스가 중요하다. (추가 가이드는 *Visualforce Performance: Best Practices* 가이드 참조.)

**Visualforce**
- `<apex:form>` 또는 `<apex:inputField>` 를 쓰지 말 것 — view state 크기를 키운다. view state는 VF 페이지 상태를 유지하는 암호화 데이터로, 매 요청마다 왕복돼 요청/응답 크기를 키운다. 큰 view state는 응답 시간을 늦춘다.
- `<apex:repeat>` 으로 페이지 렌더링 시 필요한 데이터만 브라우저로 전송 — 로딩 시간 개선.
- `<apex:page cache="true" expires="600">` 로 페이지 캐싱 활성화.

**CSS and JavaScript**
- 다중 페이지 앱 대신 single-page application(SPA) 생성. JavaScript·서드파티 프레임워크 고려.
- compressor로 CSS·JavaScript minify.
- drop shadow·gradient 등 성능에 영향 주는 CSS 기법 회피.
- `<script>` 문을 페이지 끝으로 이동 — `</body>` 직전에 로드하면 다른 컴포넌트를 먼저 다운로드하고 점진적 렌더링 가능.

**Images**
- 이미지를 더 적게·더 작게.
- 모든 이미지 압축.
- GIF 대신 PNG 또는 JPG 사용.
- 이미지 대신 CSS sprite 사용.

**General Best Practices**
- Lazy loading 사용 — 핵심 기능을 먼저, 나머지 데이터는 나중에/필요 시 로드.
- Infinite scroll 사용 — 사용자가 콘텐츠 끝에 가까워질 때만 추가 콘텐츠 로드.

---

## 8. 모바일 앱에서 피해야 할 VF 컴포넌트·기능

대부분의 코어 VF 컴포넌트(`apex` 네임스페이스)는 모바일 앱에서 정상 동작하지만, 모바일 최적화됐거나 모든 기능이 동작한다는 뜻은 아니다.

- 일반적으로 `<apex:pageBlock>` 과 자식 컴포넌트 같은 구조 컴포넌트, `<apex:pageBlockTable>` 처럼 Salesforce 룩앤필을 모방하는 컴포넌트를 피하라. 꼭 써야 하면 기본 2열 대신 `<apex:pageBlockSection columns="1">` 로 1열로 설정하라.
- 넓고 wrap 안 되는 컴포넌트를 피하라 — 특히 `<apex:detail>`, `<apex:enhancedList>`, `<apex:listViews>`, `<apex:relatedList>` 는 모두 **미지원**. `<apex:dataTable>` 로 테이블을 만들 땐 디바이스 너비를 염두에 두라.
- `<apex:inlineEditSupport>` 사용을 피하라 — 인라인 편집은 마우스 기반 데스크톱엔 좋지만 터치 디바이스, 특히 작은 화면의 폰에선 쓰기 어렵다.
- `<apex:inputField>` 는 text·email·phone 같은 기본 입력 필드엔 괜찮으나, date·lookup 같은 input widget을 쓰는 필드 타입엔 피하라.
- `<apex:scontrol>` 을 쓰지 말 것 — sControl은 모바일 앱 어디서도 미지원.
- **PDF 렌더링**(`<apex:page>` 에 `renderAs="PDF"` 설정)은 모바일 앱의 페이지에선 미지원. (PDF 렌더링 메커니즘 자체는 [[페이지 출력 제어 — HTML·PDF·SLDS]] 참조)

### 8.1 미지원 VF 컴포넌트 (전수)

모바일 앱에서 지원되지 않아 모바일용 VF 페이지에 쓰면 안 되는 컴포넌트:

- `<analytics:reportChart>`
- `<apex:detail>`
- `<apex:emailPublisher>`
- `<apex:enhancedList>`
- `<apex:flash>`
- `<apex:inputField>` — 기본 폼 필드 대신 widget을 쓰는 필드 타입에 대해
- `<apex:listViews>`
- `<apex:logCallPublisher>`
- `<apex:relatedList>`
- `<apex:scontrol>`
- `<apex:sectionHeader>`
- `<apex:selectList>` — picklist 필드에 대해
- `<apex:tabPanel>` (그리고 결과적으로 `<apex:tab>`)
- `<apex:vote>`

> Warning: `<apex:enhancedList>` 컴포넌트를 포함한 임베디드 VF 페이지(페이지 레이아웃에 추가된 것)는 **iOS에서 Salesforce 모바일 앱을 크래시**시킬 수 있다.

`apex` 네임스페이스 밖의 표준 컴포넌트(예: `<liveagent:*>`, `<chatter:*>` 등)는 앱에서 지원되지 않는다. 커스텀 컴포넌트는 미지원 컴포넌트를 자체적으로 쓰지 않는 한 앱에서 쓸 수 있다.

---

## 9. Known Visualforce Mobile Issues

Salesforce는 신뢰·고객 성공을 위해 알려진 이슈를 공개한다. Customer Support·Engineering이 고객 신고 수·심각도·우회책 유무에 따라 자체 재량으로 공개하며, 모든 버그가 공개되진 않는다. 아래는 카테고리별 이슈(Issue)와 해법(Solution)이다.

### 9.1 Access or Permission Issues

| Issue | Solution |
|---|---|
| 사용자 프로파일 수준에서 **High Assurance 세션 설정(MFA)** 이 활성화되면, 사용자가 VF 콘텐츠에 접근할 수 없고 *"You can't view this page, either because you don't have permission or because the page isn't supported on mobile devices."* 에러를 본다. Salesforce for iOS·Android에 한함. | 사용자 프로파일에서 High Assurance를 비활성화하고 다시 로그인. MFA를 계속 강제하려면 프로파일 수준 대신 **connected app 수준**에서 High Assurance 활성화. |
| Experience Cloud 사이트 사용자가 앱에서 lead의 convert 액션 VF 오버라이드에 접근할 수 없고 위와 같은 에러를 본다. | lead 변환용으로 같은 VF 페이지를 쓰는 **별도 VF 액션**을 생성. |

### 9.2 Device Sensor Issues

| Issue | Solution |
|---|---|
| 입력 필드용 자식 브라우저 창에서 디바이스 카메라가 동작하지 않고 검은 화면이 보임. Apple의 `SFSafariViewController` 버그로 추정. Salesforce for iOS에 한함. | 자식 브라우저 창 우하단의 Safari 아이콘을 탭해 Safari 모바일 브라우저에서 Salesforce를 연다. |

### 9.3 Input Issues

| Issue | Solution |
|---|---|
| URL content source를 쓰는 list button으로 접근한 VF 페이지가 input selector에 부적절한 스타일링 표시(예: input date 필드가 흰 배경에 흰 날짜). Salesforce for Android에 한함. | list view URL 버튼을 **VF page content source의 list view 버튼**, VF 탭, 또는 VF 액션으로 변환. |
| iOS native input 컨트롤이 입력 필드를 탭한 뒤 헤더 back 화살표를 누를 때 컨트롤이 활성화된 채 화면에 남음. 다른 페이지로 이동 시 예기치 않게 재출현 가능. Salesforce for iOS에 한함. | 모바일 앱에서 이동 전 input 컨트롤이 닫혀 있는지 확인. |
| 필드 long press 후 VF input 필드가 멈추거나 입력을 받지 않음(복사·붙여넣기·선택·커서 위치 변경 시). Salesforce for iOS에 한함. | VF 페이지 하단에 다음 JavaScript 줄 추가: `window.onkeydown=function(){window.focus();}` |

### 9.4 Loading and Performance Issues

| Issue | Solution |
|---|---|
| VF Page나 Lightning Tab을 랜딩 페이지로 설정하면 페이지 로딩 에러·느린 성능 발생 가능. *"We got stuck in a loop while loading the page"* 또는 *"It's taking awhile to load this page. You can keep waiting or try again"* 출현. | 랜딩 페이지로 **standard tab** 선택. |
| 여러 파일을 열면 Salesforce for iOS가 멈춤. | Safari에서 Salesforce for mobile web 사용. |

### 9.5 Navigation Issues

| Issue | Solution |
|---|---|
| 사용자가 이동한 후 VF 탭이 랜딩 페이지를 로드함. | 앱 전환·다른 탭 선택 전 페이지가 완전히 로드되게 하거나, VF 페이지 탭을 다시 선택. |
| 앱 전환 후 Canvas 페이지로 돌아올 때 빈 페이지가 보일 수 있음. | Canvas 앱을 reload. |
| publisher action이 `sforce.one.navigateToSObject` 로 file 레코드에 네비게이션 호출 시, file 미리보기 창이 표시 전에 닫힐 수 있음(`publisher.close` 가 네비게이션 호출 전에 발생). Salesforce for iOS에 한함. | file 레코드 네비게이션 전 `publisher.close` 호출을 쓰지 말 것. 사용자는 file 레코드 작업 후 publisher action 창을 수동으로 닫아야 함. |
| 올바른 버전의 record type 선택 페이지에서 사용자가 앱을 force quit하면 record type 선택 페이지가 부정확하게 나타날 수 있음. Salesforce for iOS에 한함. | 객체 홈 페이지로 돌아가 New를 다시 탭. 지속되면 앱 캐시 clear 또는 로그아웃해 동작 리셋. |
| iPad에서 객체 홈 페이지로 이동하는 커스텀 VF 페이지 사용 시 *"Sorry to Interrupt"* 에러 출현. 이후 디바이스 캐시를 clear할 때까지 그 페이지에서 다른 네비게이션 호출이 동작 안 함. | 캐시 clear. |
| sforce.one 네비게이션 라이브러리로 VF 페이지에서 ID로 note 레코드에 이동 후 Cancel/Save 탭 시 looping. 레코드 상세 페이지의 VF 액션에서 호출되면 Cancel·Save·Back 버튼이 빈 레코드 상세 페이지로 돌아갈 수 있음. | 직접 우회책 없음. 앱을 force quit하고 재시작. |
| view state POST 요청이 모바일 앱 네비게이션 히스토리에 저장됨. view state 폼 제출→다른 VF 페이지 이동→back 클릭 시 POST 요청이 다시 서빙됨. iOS에서 중복 레코드 생성, 브라우저 앱에서 에러. | 알려진 우회책 없음. |

### 9.6 Network Issues

| Issue | Solution |
|---|---|
| 네트워크가 활성인데도 VF 페이지에 *"Check your network connection and try again"* 네트워크 연결 에러 출현. Salesforce for iOS에 한함. | 조직 전체 설정 **Enable caching in Salesforce** 를 끈다. |

### 9.7 Salesforce Classic vs. Lightning Experience Issues

| Issue | Solution |
|---|---|
| 모바일 디바이스에서 Classic UI를 쓸 때 UI 체크가 `Theme3` 대신 `Theme4t` 를 잘못 반환. VF 글로벌 `$User.UIThemeDisplayed` 와 Apex 클래스 `UserInfo.getUiThemeDisplayed` 명령에서 발생. | `sforce.one` JavaScript 객체 사용 가능 여부로 현재 UI 확인 — 이 객체는 Classic UI에선 사용 불가. (`$User.UITheme`/`UITheme.getUITheme()` 메커니즘은 [[페이지 출력 제어 — HTML·PDF·SLDS]] 참조) |

### 9.8 Updating Records Issues

| Issue | Solution |
|---|---|
| 레코드 업데이트 직후 저장 불가 — *"The record was modified by [current user] during your edit session. Make a note of the data you entered, then reload the record and enter your updates again"* 에러. | 표준 edit 페이지를 즉시 호출하기 전에 레코드를 원격 업데이트하는 커스텀 프로세스를 피할 것. 아니면 사용자는 캐시 기간이 지날 때까지 **30초** 기다려야 편집 가능. |
| 안 읽은 lead 편집 시 collision detection 트리거 — 위와 유사한 에러. | 레코드를 열고 레코드 상세 페이지의 edit 버튼으로 변경. |
| `sforce.one.createRecord(entityName [, recordTypeId]);` 에서 선택적 `recordTypeID` 파라미터를 생략하면 recordTypeID 에러 출현. *"Review the errors on this page. Record Type ID: this value isn't valid for the user: [user name]"* 가능. | VF 페이지의 `sforce.one.createRecord` 호출을 수정해 `recordTypeId` 파라미터를 전달. |

### 9.9 User Interface Issues

| Issue | Solution |
|---|---|
| 표준 back 네비게이션 버튼이 두 번 탭해야 반응. `window.history.back()`·`sforce.one.back()` 같은 프로그래밍 호출로 한 페이지 뒤로 간 후 표준 back 버튼으로 또 뒤로 가려 할 때 발생. Salesforce for iOS에 한함. | 여러 페이지가 있으면 표준 back 버튼만 쓰거나 프로그래밍 호출만 쓰도록 설계. |
| 레코드 상세 페이지에 임베드된 VF 페이지에서 back을 클릭하면 페이지가 스크롤 안 됨. | back 클릭 후 몇 초 기다리거나, 레코드를 떠났다 돌아오거나, 디바이스를 가로↔세로 회전. |
| 특정 CSS 요소가 Cancel·Post·Save 버튼 또는 UI 일부를 무응답으로 만듦. | 스크롤에 영향 주는 CSS 요소 제거: `overflow-x: hidden;`, `overflow-y: scroll;`, `-webkit-overflow-scrolling: touch;` |
| Salesforce for iOS에서 표준 레코드 Create·Edit 페이지 스크롤 불가. Create/Edit로 링크하는 VF 페이지 콘텐츠가 화면을 넘을 때 주로 발생. | Create/Edit 링크를 담은 VF 페이지의 콘텐츠량을 줄여 스크롤이 필요 없게. |
| 객체 페이지 레이아웃의 임베디드 VF 페이지가 사용자 정의 높이를 따르지 않음. Salesforce for iOS에 한함. | 페이지 레이아웃 에디터에서 임베디드 VF 페이지의 **Show scrollbars** 옵션 해제. |
| Safari에서 VF 페이지 스크롤 시 페이지는 움직이나 새 텍스트가 안 보임. Apple의 `UIWebView` 버그. Salesforce for iOS에 한함. | 페이지 새로고침. |
| Experience Cloud 사이트 사용자가 VF 액션 오버라이드로 가려지고 모바일 미지원으로 표시된 객체인데도 표준 new 버튼을 봄. Salesforce for iOS에 한함. | 알려진 해법 없음. iOS Safari의 브라우저 기반 Salesforce 사용. |
| Lightning Components를 쓰는 객체 view 오버라이드가, 부모 객체의 related list로 접근될 때 전체 페이지 스크롤을 비활성화. Salesforce for iOS에 한함. | 알려진 해법 없음. 객체 홈 탭이나 프로그래밍 네비게이션 등 다른 방법으로 레코드 접근. |

---

## 10. 모바일 앱에서 VF 사용의 고려사항·제약 (장단점)

VF는 Lightning Platform에 네이티브 호스팅되는 정교한 커스텀 UI를 만들 수 있게 한다. 모바일 앱에서 VF 사용엔 많은 이점과 일부 제약이 있다.

**Usability** — 구현 용이로 생산성↑. 페이지 중심 모델이 큰 앱을 작고 관리 가능한 페이지로 자연스럽게 분할.
**Integration with the Salesforce Platform and Other Tools** — Salesforce의 풍부한 메타데이터 인프라 접근. 표준 컨트롤러로 쿼리 한 줄 없이 객체·관계에 직접 접근. VF 페이지가 AngularJS·React 같은 JS/서드파티 프레임워크의 컨테이너 역할 가능.
**Customization** — VF 페이지로 오버라이드된 표준 탭·커스텀 객체 탭·list view는 모바일 앱에서 미지원. 모바일 사용자는 객체의 기본 Salesforce 페이지를 봄.
**Interactivity** — 제한적 인터랙티비티(직접 추가한 JavaScript 기능 제외). 몰입형 UX 만들기 어려움.
**Speed** — 높은 latency로 모바일 성능 저하. 저사양·구형 모바일 디바이스에 부적합. VF가 마크업 태그를 Salesforce 서버에서 처리해 응답 시간↑.

### 10.1 The one.app Container
Salesforce Classic에서 VF가 페이지·요청·환경을 "소유"하나, 모바일 앱·Lightning Experience에서는 VF가 `/lightning` 컨테이너 안의 iframe에서 실행된다. Classic 개발에 익숙하다면 `one.app` 컨테이너 사용은 주로 스코프·보안 관련 몇 가지 조정이 필요하다. ([3. 모바일 앱 컨테이너 이해하기](#3-salesforce-모바일-앱-컨테이너-이해하기) 참조)

---

## 11. VF 페이지 문제 지원 요청 준비

먼저 Developer Discussion Forum, Salesforce Stack Exchange, Known Issues 페이지를 보고 즉시 해법을 찾을 수 있는지 확인하라. 그래도 미해결이면 Salesforce 지원팀에 케이스 제출.

- **Salesforce Developer Discussion Forum** — 플랫폼·도구 질문의 장. 4백만 Salesforce 개발자 커뮤니티에서 질문·답변.
- **Salesforce Stack Exchange** — admin·구현 전문가·개발자용 Q&A 사이트.
- **Known Issues** — 알려진 버그 가시성 제공. 모든 버그가 공개 기준에 맞진 않음.

**Submit a Support Request:**
1. Help & Training 포털 계정 로그인.
2. Contact Support 타일에서 **Create a case** 클릭.
3. Help Finder에서 **Development** → **Apex/Visualforce** 선택.
4. Questions 탭에서 자주 묻는 질문에 있는지 확인. 없으면 페이지 하단의 **Log a New Case** 아이콘 클릭.

케이스 제출에 필요한 정보: Username, Preferred email address, Phone number, Time zone, Time frame, Call back date, Business impact. 설명란에 에러 재현 단계를 요약하고, 문제를 보이는 가장 단순·짧은 코드 샘플 제공. login access 부여(Your Name / Settings / My Personal Information / Grant Login Access / Select Salesforce.com Support)도 고려.

**Check on a Support Request:** Help & Training 포털 로그인 → My Success Hub 타일의 **Go** → 좌측 네비게이션의 **Support Cases**.

---

## 12. 효과적 페이지 레이아웃 선택

main 네비게이션 탭이나 action bar의 커스텀 액션으로 추가된 페이지는 디바이스 화면을 거의 다 쓰고 세로 스크롤 가능하나, 객체 페이지 레이아웃에 추가된 VF는 특정·제한된 공간에 맞춰야 한다. 일반적으로 페이지 레이아웃의 VF는 **읽기 전용·한눈에 보는 정보**에 가장 적합하다. 다중 필드 폼처럼 인터랙션이 필요한 기능은 main 네비게이션 탭이나 action bar 커스텀 액션의 전체 화면 페이지에 둔다.

### 12.1 페이지 레이아웃 위의 Visualforce
객체 페이지 레이아웃에 추가된 VF 페이지는 레코드 상세 페이지에 표시된다. 페이지 레이아웃에서 배치를 바꿔 모바일 레코드 상세 화면에서 VF 요소 위·아래에 필드·레코드 상세를 둘 수 있다.

> Note: 이 페이지의 이미지는 **이전** Salesforce 모바일 앱 것이며 새 모바일 앱이 아니다. (PDF 스크린샷 — 텍스트만)

1. **record header** 는 레코드 로드 시 표시되나 위로 스크롤해 화면 밖으로 내보낼 수 있다. 화면에 있을 때 모든 디바이스에서 높이 **158 pixels**, 화면 전체 너비. 표시를 제어할 수 없다.
2. record controls·details — 모바일 앱이 자동 생성.
3. 객체 페이지 레이아웃에 추가된 VF 페이지.
4. 너비를 **100%** 로 설정 — 양쪽 padding을 뺀 크기로 자동 조정.
5. 페이지 레이아웃 에디터에서 항목 높이를 픽셀로 설정해 VF 페이지 영역 높이 제어. VF 요소는 콘텐츠가 더 짧아도 정확히 그 높이를 쓰며(나머지는 공백), 콘텐츠가 더 크면 잘림. **inline VF 페이지를 지원 예정인 가장 작은 디바이스 화면보다 높게 설정하지 말 것** 이 베스트 프랙티스.

한 페이지 레이아웃에 여러 inline VF 페이지를 추가할 수 있으나 스크롤 부담이 커진다. **한 줄에 VF 페이지 요소를 둘 넘게 추가하지 말 것** — VF 요소 사이에 필드 같은 일반 페이지 요소를 넣어 분리. 전체 화면이 필요하면 객체의 커스텀 액션으로 옮기는 것을 고려.

페이지 레이아웃에 추가된 VF 페이지는 자동으로 표준 헤더·사이드바가 제거된다. 개발 중엔 명시적으로 끄는 것이 유용할 수 있다. Google Maps API를 쓰면 Google이 HTML5 doctype을 권장한다.

```xml
<apex:page standardController="Warehouse__c"
docType="html-5.0" showHeader="false" standardStylesheets="false">
```

### 12.2 Full Screen Layout
모바일 앱 네비게이션 메뉴나 action bar의 커스텀 액션으로 추가된 VF 페이지는 화면을 거의 다 써서 더 많은 정보·복잡한 UI를 담을 수 있다.

> Note: 이 페이지의 이미지는 이전 Salesforce 모바일 앱 것이다. (PDF 스크린샷 — 텍스트만)

1. **Salesforce header** — main 네비게이션 메뉴 접근 제공, 높이 **42 pixels**. 헤더 내용은 변경 불가.
2. 나머지 디바이스 화면은 VF 페이지 전용.

모바일 앱 표시 시 표준 헤더·사이드바는 자동 제거된다. 단 action bar의 커스텀 액션으로 쓰인 VF 페이지는 전체 사이트와 공유되며, 네비게이션에 추가된 페이지는 공유될 수도 아닐 수도 있다. 전체 사이트와 공유되는 페이지는, 사이트 전체 VF의 표준 관행이 아닌 한 표준 헤더·사이드바를 명시적으로 제거하면 안 된다.

---

## 13. 사용자 입력과 인터랙션

키보드·마우스 없이 표준 HTML 폼은 모바일, 특히 폰에서 채우기 어렵다. JS remoting을 쓰지 않는 VF 페이지에서는 모바일 사용자를 염두에 두고 폼 입력용 VF 컴포넌트를 고른다. HTML5·모바일 브라우저 기능을 활용해 폼·UI 컨트롤을 개선하는 것보다 사용성 임팩트가 큰 변경은 없다.

### 13.1 효율적 입력 요소 선택
가능하면 `<apex:input>` 을 써라 — HTML5 지원·모바일 친화·범용 입력 컴포넌트로, 폼 필드가 기대하는 데이터에 적응한다. `<apex:inputField>` 보다 유연한데, `type` 속성으로 클라이언트 브라우저가 타입에 맞는 입력 위젯(date picker 등)이나 타입별 키보드를 표시하게 한다.

`<apex:inputField>` 도 Salesforce 객체 필드에 대응하는 HTML input을 만들며, sObject 필드 데이터 타입에 맞춰 HTML을 적응시킨다. 보통 원하는 동작이나, 아니면 `type` 속성으로 자동 타입 탐지를 오버라이드한다. 단 `<apex:inputField>` 는 HTML을 많이 생성하고 추가 자원이 필요해 모바일 무선 연결에서 가장 효율적이진 않다.

### 13.2 type 속성으로 모바일 친화 입력 요소 만들기
`<apex:input>`(그리고 쓴다면 `<apex:inputField>`)에 `type` 속성을 설정해 터치스크린에서 쓰기 쉬운 데이터 타입별 키보드·입력 위젯을 표시한다. 값은 생성된 HTML `<input>` 요소로 pass-through된다. text 필드는 표준 키보드, email 필드는 `@`·`.com` 키가 있는 email 키보드, date 필드는 date picker 등으로 적응한다.

```xml
<apex:form >
<apex:outputLabel value="Phone" for="phone"/>
<apex:input id="phone" value="{!fPhone}" type="tel"/><br/>
<apex:outputLabel value="Email" for="email"/>
<apex:input id="email" value="{!fText}" type="email"/><br/>
<apex:outputLabel value="That Number" for="num"/>
<apex:input id="num" value="{!fNumber}" type="number"/><br/>
<apex:outputLabel value="The Big Day" for="date"/>
<apex:input id="date" value="{!fDate}" type="date"/><br/>
</apex:form>
```

`<apex:input>` 이 허용하는 명시적 `type` 값(전수): `date`, `datetime`, `datetime-local`, `month`, `week`, `time`, `email`, `number`, `range`, `search`, `tel`, `text`, `url`. `type` 을 `auto` 로 설정하면 연결된 컨트롤러 프로퍼티/메서드의 데이터 타입이 쓰인다.

HTML `type` 속성(HTML5 신기능 포함)은 HTML 표준의 일부다. 모든 값이 VF input 컴포넌트에서 지원되진 않는다. VF가 지원 안 하는 값을 쓰려면 VF 태그 대신 static HTML을 쓴다.

### 13.3 HTML5 Pass-Through 속성으로 클라이언트 측 검증
`<apex:input>` 등 VF 컴포넌트에 pass-through 속성을 설정해 client-side validation 같은 HTML5 기능을 켠다. 클라이언트에서 기본 검증을 하면 쉽게 고칠 수 있는 폼 오류에 대해 서버 왕복을 피할 수 있다.

`html-` 접두어 속성은 접두어를 제거하고 생성된 HTML로 pass-through된다. 클라이언트 검증을 켜려면 `<apex:input>` 에 `html-pattern` 속성을 기대 폼 값에 맞춰 설정한다 — 생성된 `<input>` 태그에 `pattern` 속성을 추가해 그 필드의 클라이언트 검증을 켠다.

> Note: 클라이언트 측 검증은 VF 페이지가 **API 버전 29.0 이상**, 페이지 `docType` 이 `html-5.0` 이어야 한다.

검증 패턴은 정규식이다. 입력이 식과 매칭되면 유효, 아니면 무효로 에러 메시지가 표시되고 폼이 서버로 제출되지 않는다.

```xml
<apex:input id="email" value="{!fText}" type="email"
html-placeholder="you@example.com"
html-pattern="^[a-zA-Z0-9._-]+@example.com$"
title="Please enter an example.com email address"/>
```

pass-through로 설정 가능한 다른 유용한 HTML5 속성:
- `placeholder` (`html-placeholder` 속성으로 설정) — 필드에 샘플 입력 ghost text 추가.
- `title` (`<apex:input>` 에서는 `title` 속성, title 속성이 없는 컴포넌트에서는 `html-title` 속성으로 설정) — 클라이언트 검증 실패 시 쓸 에러 메시지 추가.

---

## 14. 네비게이션 관리 — sforce.one 객체

모바일 앱은 **이벤트**로 네비게이션을 관리한다. 네비게이션 이벤트 프레임워크는 여러 유틸리티 함수를 제공하는 JavaScript 객체로 노출되어, 프로그래밍 네비게이션을 쉽게 만들고 모바일에 자연스러운 경험을 준다. 주문 성공 후 주문 페이지로 리다이렉트하는 등 완료 후 네비게이션도 쉽다.

모바일 앱에서 VF 페이지의 프로그래밍 네비게이션은 보통 이렇게 동작한다:
1. 사용자가 네비게이션 메뉴나 action bar 액션에서 VF 페이지 호출.
2. VF 페이지 로드·실행(커스텀 컨트롤러/확장 코드 포함).
3. 사용자가 페이지와 인터랙션(예: 폼 값 입력).
4. 사용자가 폼 제출 등 변경을 커밋하는 액션 수행.
5. 컨트롤러/확장 코드가 변경을 Salesforce에 저장하고 결과 반환.
6. VF 페이지가 JavaScript 응답 핸들러로 결과를 받아 성공 시 결과를 보여주는 새 페이지로 리다이렉트.

이 네비게이션은 특수 유틸리티 JavaScript 객체 **`sforce.one`** 이 처리한다. `sforce.one` 객체는 모바일 앱 안에서 실행될 때 **모든 VF 페이지에 자동 추가**되며, 실행 시 네비게이션 이벤트를 트리거하는 함수들을 제공한다. 페이지 JavaScript에서 직접 호출하거나 요소의 click 핸들러로 붙일 수 있다.

Google map에 마커를 추가하는 함수 예:

```javascript
function setupMarker(){
// Use JavaScript nav function to determine if we are
// in the Salesforce mobile app and set navigation link appropriately
var warehouseNavUrl =
'sforce.one.navigateToSObject(\'' + warehouse.Id + '\')';
// Wrap the warehouse details with the link to
// navigate to the warehouse details
var warehouseDetails =
'<a href="javascript:' + warehouseNavUrl + '">' +
warehouse.Name + '</a><br/>' +
warehouse.Street_Address__c + '<br/>' +
warehouse.City__c + '<br/>' +
warehouse.Phone__c;
// Create a panel that will appear when a marker is clicked
var infowindow = new google.maps.InfoWindow({
content: warehouseDetails
});
// ...
}
```

모바일 앱 안에서 실행되는 JS/HTML 마크업이 있으면 다음을 유념:
- `window.location.href` 로 브라우저 URL을 직접 조작하지 말 것 — 앱의 네비게이션 관리 시스템과 잘 안 맞음.
- 네비게이션 URL에 `target="_blank"` 를 쓰지 말 것 — 앱 안에서 새 창을 열 수 없음.

### 14.1 Canvas 프레임워크 내 네비게이션 메서드
Canvas를 쓰면 모바일 앱에서 canvas 앱·canvas personal 앱의 네비게이션을 더 간단히 제어할 수 있다. Canvas 프레임워크 내의 네비게이션 메서드는 JavaScript 라이브러리에 있는 이벤트다. canvas 코드에서 네비게이션 메서드를 호출하면 Salesforce로 이벤트를 보내고, Salesforce가 payload를 읽어 지정 목적지로 사용자를 안내한다. 네비게이션 메서드는 `name` 과 `payload` 를 가진 이벤트 변수로 참조한다.

```javascript
var event = {name:"s1.createRecord", payload: {entityName: "Account", recordTypeId:
"00h300000001234"}};
```

(자세한 내용은 *Canvas Developer Guide* 의 "Salesforce Mobile App Navigation Methods for Use with Canvas Apps" 참조)

### 14.2 sforce.one 객체 — 함수 전수

`sforce.one` 함수는 dotted notation으로 참조한다. 예: `sforce.one.navigateToSObject(recordId, view)`. 이 함수들이 발생시키는 기저 이벤트의 자세한 내용은 *Lightning Aura Components Developer Guide* 참조.

| Function | Description |
|---|---|
| `back([refresh])` | sforce.one 히스토리에 저장된 이전 상태로 이동(브라우저 Back 버튼과 동등). `refresh` 는 선택 — 기본은 새로고침 안 함, `true` 전달 시 가능하면 새로고침. |
| `navigateToSObject(recordId [, view])` | `recordId` 로 지정된 sObject 레코드로 이동. 이 record "home"엔 여러 view가 있고, 모바일 앱에서는 사용자가 swipe로 전환하는 slide로 제공됨. `view` 는 선택, 기본 `detail`. 가능 값: `detail`(레코드 상세 slide), `chatter`(Chatter slide), `related`(관련 slide). **Note: ContentNote SObject에 해당하는 Record ID는 미지원.** |
| `navigateToURL(url[, isredirect])` | 지정 URL로 이동. relative root·absolute URL 지원. relative URL은 Lightning 도메인 root 기준이며 네비게이션 히스토리 유지(예: VF 페이지의 relative root URL은 `/apex/c__Listen` 처럼 forward slash 접두). `../apex/c__Listen` 이나 `apex/c__Listen` 같은 relative URL은 **미지원**. external URL(Lightning 도메인 밖)은 별도 브라우저 창에서 열림. external URL이 연 새 창은 자체 히스토리를 가지며 닫히면 폐기됨 — 사용자는 Back으로 앱에 돌아올 수 없고 새 창을 닫아야 함. `mailto:`·`tel:`·`geo:` 등 URL scheme도 external 앱 실행에 지원되나 플랫폼·디바이스별로 다름(`mailto:`·`tel:` 은 신뢰 가능, 그 외엔 테스트 권장). `isredirect` 는 선택, 기본 `false` — `true` 시 새 URL이 히스토리에서 현재 것을 대체. **modal(예: quick action 활성 컴포넌트)에서 URL로 이동 시 modal은 기본적으로 자동으로 안 닫힘 — 자동으로 닫으려면 `isredirect` 를 `true` 로.** **Note: `<apex:commandButton>` 의 onClick 핸들러나 `<button type="submit">`·`<input type="submit">` 안에서 `navigateToURL` 사용 시 주의 — `isredirect=true` 라도 command button의 기본 click 동작은 form post다. 이 경우 form post와 navigateToURL이 둘 다 일어나 사용자가 back을 두 번 눌러야 함. 기본 click 동작을 막으려면 onClick 핸들러가 `event.preventDefault()` 를 호출하거나 `return false` 하게 설정. Note: ContentNote SObject에 해당하는 URL은 미지원.** |
| `navigateToFeed(subjectId, type)` | `subjectId` 로 스코프된 지정 타입 피드로 이동. 일부 피드 타입은 `subjectId` 가 required이나 무시됨 — 그런 경우 현재 사용자 ID를 전달. `type` 가능 값: `BOOKMARKS`(컨텍스트 사용자가 북마크한 모든 피드 항목, 사용자 ID 전달), `COMPANY`(TrackedChange 제외 모든 피드 항목; 부모에 sharing 접근 필요, 사용자 ID 전달), `FILES`(컨텍스트 사용자가 follow하는 사람/그룹이 올린 파일 포함 피드 항목, 사용자 ID 전달), `GROUPS`(컨텍스트 사용자가 소유·멤버인 모든 그룹의 피드 항목, 사용자 ID 전달), `NEWS`(follow하는 사람·멤버 그룹·follow하는 파일/레코드의 모든 업데이트 + 부모가 컨텍스트 사용자인 레코드 업데이트, 사용자 ID 전달), `PEOPLE`(컨텍스트 사용자가 follow하는 모든 사람이 올린 피드 항목, 사용자 ID 전달), `RECORD`(부모가 지정 레코드인 모든 피드 항목 — 그룹·user·객체·파일 등; 레코드가 그룹이면 그룹 mention 포함, user면 그 user의 피드 항목만, 레코드 ID 전달), `TO`(컨텍스트 사용자 mention·comment 관련 피드 항목, 사용자 ID 전달), `TOPICS`(지정 topic을 포함한 모든 피드 항목, topic ID 전달 — **Salesforce for mobile web에서만 지원**; iOS·Android에선 Topics 미사용). |
| `navigateToFeedItemDetail(feedItemId)` | 특정 피드 항목 `feedItemId` 와 관련 comment로 이동. |
| `navigateToRelatedList(relatedListId, parentRecordId)` | `parentRecordId` 의 related list로 이동(예: Warehouse 객체 related list면 `parentRecordId` 는 `Warehouse__c.Id`). `relatedListId` 는 표시할 related list의 API name 또는 ID. |
| `navigateToList(listViewId, listViewName, scope)` | `listViewId`(표시할 list view의 ID)로 지정된 list view로 이동. `listViewName` 은 list view 제목 설정 — 저장된 실제 이름과 일치할 필요 없음, 저장된 이름을 쓰려면 `null`. `scope` 는 view의 sObject 이름(예: "Account" 또는 "MyObject__c"). |
| `createRecord(entityName[, recordTypeId][, defaultFieldValues])` | 지정 `entityName`(예: "Account" 또는 "MyObject__c")의 레코드 생성 페이지를 엶. `recordTypeId` 는 선택 — 생성 객체의 record type 지정. **`recordTypeId` 없이 `createRecord` 호출 시 에러가 날 수 있음.** `defaultFieldValues` 는 선택 — 제공 시 생성 패널(패널에 표시 안 된 필드 포함)의 필드를 미리 채움. prepopulate 값이 있는 필드엔 사용자가 create 접근 필요. 필드 접근 제한으로 저장 중 발생한 에러는 에러 메시지를 표시 안 함. |
| `editRecord(recordId)` | `recordId` 로 지정된 레코드의 편집 페이지를 엶. |
| `showToast({toastParams})` | toast 표시 — view 상단 헤더 아래 메시지. `toastParams` 객체가 toast 속성 설정. `force:showToast` Aura 이벤트에 쓸 수 있는 모든 속성 사용 가능. |
| `publish(messageChannel, message)` | Lightning Message Service로 `messageChannel` 에 메시지 발행. ("Publish on a Message Channel" 참조) |
| `subscribe(messageChannel, function)` | Lightning Message Service로 `messageChannel` 구독. 구독 채널에 메시지 발행 시 제공 함수 실행. `subscribe()` 는 `unsubscribe()` 에 쓸 subscription 객체 반환. ("Subscribe and Unsubscribe from a Message Channel" 참조) |
| `unsubscribe(subscription)` | subscription 객체를 메시지 채널에서 구독 해제. |

`showToast` 예시:

```javascript
sforce.one.showToast({
"title": "Success!",
"message": "The record was updated successfully."
});
```

`sforce.one` 객체 사용 시 유념:
- `sforce.one.navigateToURL` 호출이 객체용 표준 페이지나 Chatter 페이지를 참조하면 "Unsupported Page" 에러가 날 수 있다. URL이 forward slash로 시작하게 하라(`_ui` 대신 `/_ui`).
- `sforce.one.createRecord` 메서드는 표준 액션의 VF 오버라이드를 **존중하지 않는다.**
- `pageReference` 클래스로 모바일 앱 네비게이션을 제어할 수 있다. 일부 액션·연관 pageReference URL은 아직 완전 지원 안 됨 — 예: `standard_recordPage` 의 clone·edit 액션이 기대대로 동작 안 할 수 있음. 완전 지원은 향후 릴리즈 예정.

### 14.3 sforce.one의 API 버전 처리

`sforce.one` 객체는 새 릴리즈에서 자주 개선된다. 하위 호환을 위해 버전별 동작을 제공하며 특정 버전을 쓸 수 있다.

기본적으로 `sforce.one` 은 요청된 VF 페이지의 API 버전과 같은 버전을 쓴다. 예: VF 페이지가 API 30.0이면 그 페이지의 `sforce.one` 도 기본적으로 30.0을 쓴다. 즉 VF 페이지를 새 API 버전으로 업데이트하면 `sforce.one` 도 자동으로 업데이트된 버전을 쓴다(31.0으로 올리면 31.0 사용).

새 API 버전의 `sforce.one` 동작이 호환 문제를 일으키면 세 가지 옵션:
- VF 페이지 API 버전을 이전 버전으로 되돌림(코드 변경 불필요).
- 페이지 기능 코드를 고쳐 문제 해결(최선이나 디버깅·코드 변경 필요).
- 특정 `sforce.one` 버전 사용(보통 최소한의 코드 변경).

> Note: `sforce.one` 은 Winter '14(API 29.0)에 추가됐고 Summer '14(API 31.0)까지 버전 관리되지 않았다. **31.0 미만의 모든 버전은 31.0과 동일**하다. Visualforce에 유효한 어떤 버전(15.0부터 현재 API 버전까지)이든 `sforce.one` 버전으로 지정할 수 있다.

#### 특정 버전 사용
`sforce.one.getVersion()` 함수에 API 버전과, 특정 버전을 써야 하는 callback 함수를 제공한다. 해당 버전들이 이 호출로 자동 로드된다. 시그니처:

```javascript
sforce.one.getVersion(versionString, callbackFunction);
```

`versionString` 은 앱이 요구하는 API 버전 — 항상 두 자리·점·한 자리(예: "30.0"). 유효하지 않은 버전 문자열은 **silently 실패**한다. `callbackFunction` 은 특정 버전을 쓰는 JavaScript 함수다. `getVersion()` 은 비동기로 동작하며, 요청 버전 로딩이 끝나면 callback이 호출되어 그 API 버전용 `sforce.one` 객체 하나를 단일 파라미터로 받는다. 전역 `sforce.one` 대신 전달된 객체로 호출한다.

다음 예들은 아래 input 버튼에 Create Account 기능을 추가한다.

```html
<input type="button" value="Create Account" onclick="btnCreateAccount()" id="btnCreateAcct"/>
```

**VF 페이지의 API 버전 기본 사용** — 버전 요청 불필요, 자동 적용:

```javascript
<script>
function MyApp() {
this.createAccount = function() {
sforce.one.navigateToURL("/001/e");
};
}
var app = new MyApp();
function btnCreateAccount() {
app.createAccount();
}
</script>
```

**특정 버전 사용 (Simple)** — versioned 인스턴스 참조를 얻어 저장:

```javascript
<script>
function MyApp(sfone) {
this.createAccount = function() {
sfone.navigateToURL("/001/e");
};
}
var app30 = null;
function btnCreateAccount() {
// Create our app object if not already defined
if(!app30) {
// Create app object with versioned sforce.one
sforce.one.getVersion("30.0", function(sfoneV30) {
app30 = new MyApp(sfoneV30);
app30.createAccount();
});
return;
}
app30.createAccount();
}
</script>
```

**특정 버전 사용 (Best)** — 앱 초기화 블록에서 versioned 인스턴스를 만들어 이벤트 처리와 분리:

```javascript
<script>
function MyApp(sfone) {
this.createAccount = function() {
sfone.navigateToURL("/001/e");
};
}
var app30 = null;
// Initialize app: get versioned API, wire up clicks
sforce.one.getVersion("30.0", function(sfoneV30) {
// Create app object with versioned sforce.one
app30 = new MyApp(sfoneV30);
// Wire up button event
var btn = document.getElementById("btnCreateAcct");
btn.onclick = btnCreateAccount;
});
// Events handling functions
// Can't be fired until app is defined
function btnCreateAccount() {
app30.createAccount();
}
</script>
```

**특정 버전 사용 (Synchronous)** — 특정 버전 라이브러리를 수동 include해 동기 모드 트리거. 라이브러리 URL 형식: `/sforce/one/sforceOneVersion/api.js`:

```javascript
<script src="/sforce/one/30.0/api.js"></script>
<script>
function MyApp(sfone) {
this.createAccount = function() {
sfone.navigateToURL("/001/e");
};
}
var app = null;
sforce.one.getVersion("30.0", function(sfoneV30) {
app = new MyApp(sfoneV30);
});
// Events handling function
// Can't be fired until app is defined
function btnCreateAccount() {
app.createAccount();
}
</script>
```

일부 상황은 동기 모드가 필요하나 비동기 버전이 선호된다. 올바른 버전 라이브러리 수동 include를 잊으면 진단하기 어려운 버그가 생긴다.

---

## 15. 모바일 페이지에 SLDS 적용

> SLDS의 디자인 원칙·스타일 메커니즘 자체는 [[페이지 출력 제어 — HTML·PDF·SLDS]] 소관이다. 여기서는 **모바일 앱용 VF 페이지에 SLDS를 적용하는 절차**만 다룬다.

SLDS는 CSS 한 줄 없이 Lightning Experience 룩앤필의 앱을 만들게 돕는 CSS 프레임워크다. Lightning Experience UI의 4대 핵심 디자인 원칙: **Clarity**(모호성 제거), **Efficiency**(워크플로 최적화), **Consistency**(같은 문제에 같은 해법), **Beauty**(사려 깊은 craftsmanship).

**SLDS 이점:** 통합 경험·간소화 워크플로 제공 / padding·margin 같은 기본값을 과하게 강제하지 않음 / 지속 업데이트(최신 SLDS를 쓰면 LEX와 일관) / 접근성을 CSS 프레임워크에 포함 / Bootstrap 등 다른 CSS 프레임워크와 호환.

### 15.1 VF 페이지에 SLDS 적용
SLDS를 쓸 때마다 페이지에 `<apex:slds />` 를 추가하고 코드를 scoping 클래스 `<div class="slds-scope">...</div>` 로 감싼다.

```xml
<apex:page showHeader="false" standardStylesheets="false" sidebar="false"
applyHtmlTag="false" applyBodyTag="false" docType="html-5.0">
<!-- Import the Design System style sheet -->
<apex:slds />
<!-- REQUIRED SLDS WRAPPER -->
<div class="slds-scope">
```

`<apex:pageblock>`·`<apex:inputField>` 같은 Apex 태그는 아직 SLDS 사용에 지원되지 않는다.

**SLDS 클래스 명명** — Block-Element-Modifier(BEM) 규칙 사용: block은 고수준 컴포넌트(`car`), element는 컴포넌트 자손(`car__door`), modifier는 상태/변형(`car__door--red`).

### 15.2 VF에서 SLDS 아이콘 사용
SLDS는 action·custom·doctype·standard·utility 아이콘의 PNG·SVG(개별·spritemap) 버전을 포함한다. SVG spritemap 아이콘을 쓰려면 `<html>` 태그에 `xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"` 속성을 추가한다.

```xml
<span class="slds-icon_container slds-icon-standard-account" title="description of icon
when needed">
<svg aria-hidden="true" class="slds-icon">
<use xlink:href="{!URLFOR($Asset.SLDS,
'assets/icons/standard-sprite/svg/symbols.svg#account')}"></use>
</svg>
<span class="slds-assistive-text">Icon Assistive Text</span>
</span>
```

아이콘이 standalone이고 의미를 가지므로 `slds-icon_container` 클래스의 outer span 안에 둔다. 기본 색이 없으므로 background color는 두 번째 클래스로 적용 — `slds-icon-`, sprite map 이름, `-icon` 을 연결해(예: `slds-icon-standard-account`) span에 적용. `<svg>` 안의 `<use>` 태그가 `xlink:href` 로 표시 아이콘을 지정. `xlink:href` 경로: 카테고리 sprite(예: "standard-sprite") + `/svg/symbols.svg#` + 아이콘 이름(예: "account") = `assets/icons/standard-sprite/svg/symbols.svg#account`. assistive text는 `slds-assistive-text` 클래스 span에.

### 15.3 SLDS로 모바일 앱용 VF 페이지 만들기 (튜토리얼)
최근 접근한 account를 표시하고 모바일 네비게이션 메뉴에 추가하는 SLDS 스타일 페이지를 만든다.

1. Developer Console → File > New > Visualforce Page → 이름 `SLDSPage`. 마크업을 다음으로 교체:

```xml
<apex:page showHeader="false" standardStylesheets="false" sidebar="false"
applyHtmlTag="false" applyBodyTag="false" docType="html-5.0">
<html xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
lang="en">
<head>
<meta charset="utf-8" />
<meta http-equiv="x-ua-compatible" content="ie=edge" />
<title>SLDS LatestAccounts Visualforce Page in Salesforce Mobile</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<!-- Import the Design System style sheet -->
<apex:slds />
</head>
<apex:remoteObjects >
<apex:remoteObjectModel name="Account" fields="Id,Name,LastModifiedDate"/>
</apex:remoteObjects>
<body>
<!-- REQUIRED SLDS WRAPPER -->
<div class="slds-scope">
<!-- PRIMARY CONTENT WRAPPER -->
<div class="myapp">
<!-- ACCOUNT LIST TABLE -->
<div id="account-list" class="slds-p-vertical--medium"></div>
<!-- / ACCOUNT LIST TABLE -->
</div>
<!-- / PRIMARY CONTENT WRAPPER -->
</div>
<!-- / REQUIRED SLDS WRAPPER -->
<!-- JAVASCRIPT -->
<script>
(function() {
var outputDiv = document.getElementById('account-list');
var account = new SObjectModel.Account();
var updateOutputDiv = function() {
account.retrieve(
{ orderby: [{ LastModifiedDate: 'DESC' }], limit: 10 },
function(error, records) {
if (error) {
alert(error.message);
} else {
// create data table
var dataTable = document.createElement('table');
dataTable.className = 'slds-table slds-table--bordered
slds-text-heading_small';
// add header row
var tableHeader = dataTable.createTHead();
var tableHeaderRow = tableHeader.insertRow();
var tableHeaderRowCell1 = tableHeaderRow.insertCell(0);
tableHeaderRowCell1.appendChild(document.createTextNode('Latest Accounts'));
tableHeaderRowCell1.setAttribute('scope', 'col');
tableHeaderRowCell1.setAttribute('class', 'slds-text-heading_medium');
// build table body
var tableBody = dataTable.appendChild(document.createElement('tbody'))
var dataRow, dataRowCell1, recordName, data_id;
records.forEach(function(record) {
dataRow = tableBody.insertRow();
dataRowCell1 = dataRow.insertCell(0);
recordName = document.createTextNode(record.get('Name'));
dataRowCell1.appendChild(recordName);
});
if (outputDiv.firstChild) {
// replace table if it already exists
// see later in tutorial
outputDiv.replaceChild(dataTable, outputDiv.firstChild);
} else {
outputDiv.appendChild(dataTable);
}
}
}
);
}
updateOutputDiv();
})();
</script>
<!-- / JAVASCRIPT -->
</body>
</html>
</apex:page>
```

- `<apex:slds />` 태그로 SLDS 스타일시트 접근(정적 자원 업로드 대안).
- `<div class="slds-scope">` wrapper는 SLDS 스타일 콘텐츠를 감싸야 하며, SLDS 스타일은 그 안의 요소에만 적용된다.

2~5. 페이지를 모바일 앱용으로 활성화:
- Setup → `Visualforce Pages` → SLDSPage 옆 **Edit** → **Available for Lightning Experience, Experience Builder sites, and the mobile app** 선택 → Save.
- Setup → `Tabs` → Visualforce Tabs 섹션 **New** → Visualforce Page에서 SLDSPage 선택, Tab Label `SLDS Page`, Tab Style은 Diamond 선택(이 아이콘이 모바일 네비게이션 메뉴 아이콘이 됨) → Next, Next, Save.
- Setup → `Mobile Apps` → **Salesforce Navigation** → SLDS Page 탭 선택 → **Add**(Selected 목록 하단에 추가됨) → Save.

### 15.4 SLDS로 반응형 페이지 디자인
표준 Salesforce 앱 페이지는 responsive design으로 디바이스 최적 레이아웃을 제공한다 — 폰엔 stacked single-column, 태블릿엔 side-by-side two-column. 같은 페이지가 모든 디바이스에서 화면 크기에 적응한다.

**SLDS Grid System** — SLDS는 Flexbox 기반 grid로 유연·mobile-first·device-agnostic scaffolding을 제공한다. grid wrapper(`slds-grid` 클래스)와 그 안의 column(`slds-col` 클래스) 두 부분이며, 기본적으로 column은 콘텐츠 기준으로 크기가 정해진다. sizing helper로 수동 지정 가능 — `slds-size--X-of-Y` 형식(X는 전체 공간 Y의 분수, 예: `slds-size--1-of-2` 는 50%). 수동 sizing helper로 2, 3, 4, 5, 6, 12 grid에 걸쳐 column 비율을 지정할 수 있다.

```xml
<apex:page showHeader="false" standardStylesheets="false" sidebar="false"
applyHtmlTag="false" applyBodyTag="false" docType="html-5.0">
<html xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
lang="en">
<head>
<meta charset="utf-8" />
<meta http-equiv="x-ua-compatible" content="ie=edge" />
<title>SLDS ResponsiveDesign Visualforce Page in Salesforce Mobile</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<!-- Import the Design System style sheet -->
<apex:slds />
</head>
<body>
<!-- REQUIRED SLDS WRAPPER -->
<div class="slds-scope">
<!-- PRIMARY CONTENT WRAPPER -->
<!-- RESPONSIVE GRID EXAMPLE -->
<div class="myapp">
<div class="slds-grid slds-wrap">
<div class="slds-col slds-size--1-of-1 slds-small-size--1-of-2
slds-medium-size--1-of-4">
<div class="slds-box slds-box_x-small slds-text-align_center
slds-m-around--x-small">Box 1</div>
</div>
<div class="slds-col slds-size--1-of-1 slds-small-size--1-of-2
slds-medium-size--3-of-4">
<div class="slds-box slds-box_x-small slds-text-align_center
slds-m-around--x-small">Box 2</div>
</div>
</div>
</div>
<!-- / RESPONSIVE GRID EXAMPLE -->
</div>
</body>
</html>
</apex:page>
```

이 코드는 2-column grid를 만든다: 모바일 화면에선 full width·vertical / small 화면(480px 초과)에선 1:1·side by side / 더 큰 화면(768px 초과)에선 3:1·side by side.

---

## 16. VF 페이지를 커스텀 액션으로 사용

VF 페이지가 커스텀 액션으로 쓰이면, 표준 컨트롤러가 제공하는 단일 레코드에 작용하거나, 커스텀 컨트롤러 코드가 조회한 레코드(들)를 찾아 작용하도록 설계한다.

### 16.1 객체의 커스텀 액션
객체의 커스텀 액션으로 추가된 VF 페이지는 그 객체 타입 레코드의 컨텍스트에서 호출된다 — 사용자가 액션을 클릭할 때 보던 특정 record ID가 전달된다. 그 특정 레코드 타입에 작용하도록 설계한다. 객체의 커스텀 액션으로 쓰이는 VF 페이지는 그 객체의 **표준 컨트롤러를 써야 한다.** 커스텀 코드(JS remoting용 `@RemoteAction` 메서드 포함)는 컨트롤러 확장으로 추가한다.

커스텀 코드는 원본 레코드 업데이트 이상도 할 수 있다 — 예: Create Quick Order 커스텀 액션은 매칭 merchandise를 검색해 invoice·line item을 만들고, 이 모든 게 원본 account 레코드 컨텍스트에서 일어난다(invoice가 quick order 액션이 호출된 account에 연관). org 내부 URL로 리다이렉트하면 완료 또는 프로그래밍 이동 시 액션 dialog가 닫힌다. external URL로 리다이렉트하면 새 브라우저 탭에서 열려 동작이 달라질 수 있다.

### 16.2 커스텀 글로벌 액션
글로벌 액션으로 쓰이는 VF 페이지는 여러 곳에서 호출 가능하고 특정 레코드가 연관되지 않는다 — 완전한 행동 자유가 있어 코드를 직접 써야 한다. 글로벌 액션 VF 페이지는 **어떤 표준 컨트롤러도 쓸 수 없으며** 커스텀 컨트롤러를 작성해야 한다. 하나 또는 여러 레코드를 만들거나 찾은 레코드를 수정할 수 있다. 글로벌 액션 완료 시 사용자는 액션의 일부로 생성된 부모 레코드로 리다이렉트되거나 시작 지점으로 돌아간다.

---

## 17. VF 페이지 성능 튜닝 (캐싱)

성능은 모바일 VF 페이지의 중요한 측면이다. VF는 성능 튜닝용 캐싱 메커니즘을 가진다. 페이지 캐싱 활성화:

```xml
<apex:page cache="true" expires="600">
```

| Attribute | Description |
|---|---|
| `cache` | 브라우저가 페이지를 캐시할지 지정하는 Boolean. 미지정 시 기본 `false`. |
| `expires` | 캐시 기간을 초 단위로 지정하는 Integer. |

(자세한 내용은 Developerforce의 *Force.com Sites Best Practices* 참조.) 추가 자원: *Inside the Force.com Query Optimizer*(웨비나), *Maximizing the Performance of Force.com SOQL, Reports, and List Views*(블로그), *Force.com SOQL Best Practices: Nulls and Formula Fields*(블로그).

---

## 18. AppExchange 앱에 Visualforce 추가하기 (Ch20)

AppExchange용 앱에 Visualforce 페이지·컴포넌트·커스텀 컨트롤러를 포함할 수 있다.

Apex 클래스와 달리 managed package 내 **VF 페이지의 내용은 설치 시 숨겨지지 않는다.** 그러나 커스텀 컨트롤러·컨트롤러 확장·커스텀 컴포넌트는 숨겨진다. 또 커스텀 컴포넌트는 `access` 속성으로 네임스페이스 내에서만 실행되도록 제한할 수 있다.

Salesforce는 VF/Apex 컴포넌트 배포에 **managed package만 쓰기를 권장**한다 — managed package는 고유 네임스페이스를 받아 페이지·컴포넌트·클래스·메서드·변수 등의 이름 앞에 자동으로 prepend되어, 설치 조직의 이름 중복을 방지하기 때문이다.

### 18.1 VF 페이지로 패키지 만들 때 caveat (전수)

- managed package에 포함된 컴포넌트의 `access` 속성이 `global` 이면 다음 제약이 적용된다:
  - 컴포넌트의 `access` 속성을 `public` 으로 바꿀 수 없다.
  - required 자식 `<apex:attribute>` 컴포넌트(`required` 가 `true` 인 것)는 모두 `access` 를 `global` 로 설정해야 한다.
  - required 자식 `<apex:attribute>` 에 `default` 속성이 설정됐으면 제거·변경할 수 없다.
  - 새 required 자식 `<apex:attribute>` 컴포넌트를 추가할 수 없다.
  - 자식 `<apex:attribute>` 의 `access` 가 `global` 이면 `public` 으로 바꿀 수 없다.
  - 자식 `<apex:attribute>` 의 `access` 가 `global` 이면 `type` 속성을 바꿀 수 없다.
- non-global 컴포넌트를 가진 패키지를 설치하면, Setup에서 컴포넌트를 보는 사용자는 내용 대신 **"Component is not global"** 을 본다. 또 컴포넌트는 component reference에 포함되지 않는다.
- 설치 조직에 advanced currency management가 활성화돼 있으면, `<apex:inputField>` 와 `<apex:outputField>` 를 쓰는 VF 페이지는 설치할 수 없다.
- AppExchange 앱에 포함된 Apex는 **누적 테스트 커버리지 최소 75%** 여야 한다. 패키지 업로드 시 모든 테스트가 에러 없이 실행되는지 확인하고, 설치 시에도 테스트가 실행된다.
- **version 16.0부터** managed global Apex 클래스를 VF 컨트롤러로 쓰면, subscriber가 쓰려면 다음 메서드·프로퍼티의 access 레벨도 `global` 로 설정해야 한다: 커스텀 컨트롤러 생성자 / getter·setter 메서드(input·output 컴포넌트용 포함) / 프로퍼티의 get·set 속성.

> Tip: custom label에 번역이 있으면, 원하는 언어를 명시적으로 패키징해 번역을 패키지에 포함하라.

악성 코드가 데이터에 영향을 주지 못하도록, VF 페이지를 담은 패키지가 조직에 설치되면 페이지는 `salesforce.com` 도메인이 아닌 **`vf.force.com` 도메인**에서 서빙된다.

> SEE ALSO: Test a Custom Controller / Second-Generation Managed Packaging Developer Guide: Create a Second-Generation Managed Package

### 18.2 VF 페이지·컴포넌트의 Package Version Settings 관리

VF 마크업이 설치된 managed package를 참조하면, 마크업이 참조하는 각 managed package의 version setting이 하위 호환을 위해 저장된다 — managed package 컴포넌트가 후속 버전에서 진화해도 페이지는 특정·알려진 동작의 버전에 바인딩된다.

package version은 패키지에 업로드된 컴포넌트 집합을 식별하는 번호로, `majorNumber.minorNumber.patchNumber`(예: `2.1.3`) 형식이다. major·minor는 major 릴리즈마다 선택 값으로 증가하고, patchNumber는 patch 릴리즈에만 생성·갱신된다. publisher는 package version으로 기존 고객 통합을 깨지 않고 후속 버전을 릴리즈해 managed package 요소를 우아하게 진화시킬 수 있다.

**구성 절차:**
1. VF 페이지/컴포넌트 편집 → **Version Settings** 클릭.
2. VF 마크업이 참조하는 각 managed package의 **Version** 선택. 이 버전이 나중에 더 최신 버전이 설치돼도 계속 쓰인다(수동 업데이트 전까지). 설치된 managed package를 설정 목록에 추가하려면 사용 가능 패키지 목록에서 선택(이 페이지/컴포넌트에 아직 연관 안 된 설치 managed package가 있어야 목록 표시).
3. **Save**.

유의:
- managed package 버전을 지정하지 않고 그것을 참조하는 VF 페이지/컴포넌트를 저장하면, 기본적으로 **최신 설치 버전**에 연관된다.
- 페이지/컴포넌트가 managed package를 참조하면 그 version setting을 **Remove할 수 없다.** 참조 위치는 Show Dependencies로 찾는다.
- 패키지 subscriber는 package version으로 삭제된 컴포넌트를 참조할 수 있다. 패키지 내 VF 페이지는 항상 **자신의 패키지의 최신 API 버전**을 쓰며, 삭제된 컴포넌트에는 접근할 수 없다.

> SEE ALSO: How Visualforce is Versioned / Managing Version Settings for Custom Components / What are Custom Components?

### 18.3 다른 패키지의 VF 페이지에서 컨트롤러 접근

다른 패키지에 있는 VF 페이지에서 Apex 컨트롤러에 접근하려면 커스텀 컨트롤러 클래스에 `@namespaceAccessible` Apex 어노테이션을 쓴다. 1세대 패키징에서는 한 네임스페이스로 managed package 하나만 개발할 수 있으나, 2세대 패키징에서는 같은 네임스페이스로 둘 이상의 managed(또는 unlocked) package를 개발할 수 있다.

기본적으로 패키지에 설치된 VF 페이지는 다른 패키지의 Apex 클래스의 public Apex 메서드를 호출할 수 없다 — 두 패키지가 같은 네임스페이스라도 마찬가지다.

```apex
@namespaceAccessible
public virtual class NsController {
private String message;
@namespaceAccessible
public NsController() {
this.message = 'default'; // init to non-blank value
}
@namespaceAccessible
public virtual String getMessage() {
return this.message;
}
@namespaceAccessible
public virtual void setMessage(String msg) {
this.message = msg;
}
}
```

먼저 컨트롤러 위에 어노테이션을 추가해 다른 패키지의 같은 네임스페이스에서 보이게 한다 — 추가하는 메서드들도 보이려면 컨트롤러를 어노테이트해야 한다. 그 다음 네임스페이스 전체에서 보여야 할 각 메서드 앞에 `@namespaceAccessible` 을 추가한다. 패키지 밖이지만 같은 네임스페이스 안에서 보여야 할 메서드에만 이 어노테이션을 써라.

---

## 관련 노트

- [[페이지 출력 제어 — HTML·PDF·SLDS]]
- [[Visualforce 개요 — 도구·퀵스타트]]
- [[커스텀 컨트롤러·컨트롤러 확장]]
- [[표준 컨트롤러·표준 리스트 컨트롤러]]
- [[버튼·링크 오버라이드·Static Resource·커스텀 컴포넌트]]
