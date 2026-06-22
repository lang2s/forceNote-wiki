---
tags: [visualforce, vf, best-practices, view-state, performance, security, legacy]
source: salesforce_pages_developers_guide.pdf (Visualforce Developer Guide, v67.0 Summer '26)
created: 2026-06-21
aliases: [Visualforce 베스트 프랙티스, View State 관리, VF 성능, Visualforce 보안, VF 컨트롤러 모범사례]
---

# Visualforce 베스트 프랙티스

> Visualforce는 레거시 UI 프레임워크다 — 신규 개발은 LWC를 권장하나, 기존 VF 페이지를 유지·최적화할 때의 성능·view state·컴포넌트·컨트롤러·보안 권고 모음. (Ch23 Best Practices + Appendix B Security Tips, Visualforce Developer Guide v67.0)

원문 표현(`improve the your`·`tp respect` 등 오타 포함)은 [sic] 표기로 verbatim 보존한다.

---

## 성능 — Visualforce 성능 개선 전략

> Learn strategies to improve the[sic] your Visualforce pages. — 원문 챕터 도입부 그대로.

### 성능 문제 조사 (Investigate Performance Issues)

Visualforce는 표준 Salesforce 페이지의 기능·동작·성능에 맞추도록 설계됐다. 사용자가 지연·예상치 못한 동작·기타 이슈를 Visualforce에서 겪으면 먼저 가능한 원인을 조사한다. 일반 웹 디자인 베스트 프랙티스 준수 여부부터 확인한다.

- JavaScript and CSS minification.
- Image optimization for the web.
- Avoidance of iframes whenever possible.

**테스트로 성능 회귀(regression)를 조사·예방:**

- Lightning Platform **Developer Console**로 Visualforce 마크업·기타 플랫폼 기능의 성능을 조사한다. 무엇이 시스템 리소스를 소비하는지, 코드의 이슈를 볼 수 있다. Developer Console의 debug log는 서버가 요청을 처리하면서 메서드·쿼리·workflow·callout·DML·validation·trigger·page를 유형·시간별로 실행 단계마다 기록한다.
- **Selenium** 같은 도구로 결과가 들쭉날쭉한 지루하거나 복잡한 workflow 테스트를 자동화한다. 자동 테스트는 링크 클릭, 데이터 입력·조회, 실행 시간 기록으로 수동 테스트가 놓치는 병목·결함을 드러낸다.
- 가능한 한 많은 브라우저·버전에서 테스트한다.
- **대용량 데이터로 테스트**한다. data skew 시나리오(특정 사용자가 너무 많은 레코드에 접근)를 드러낸다. unbounded data를 피하고 pagination을 구현하고 관련 데이터만 표시한다.
- HTML·CSS·JavaScript 프로파일링·디버깅 도구로 network latency·load time·코드 효율에 대한 통찰을 얻는다.
- **실제 모바일 기기에서 테스트**한다. 모바일 클라이언트는 느린 프로세서·제한된 메모리·느린 네트워크 때문에 성능 프로파일이 다르다.

> Tip: 초기 모바일 브라우저 테스트엔 WebPageTest 같은 도구를 쓰되, 심층 테스트엔 실제 기기를 쓴다.

Salesforce 페이지가 느리면 https://status.salesforce.com 에서 서버 상태를 확인하고, 모든 웹 페이지가 느리면 네트워크 설정을 확인한다.

### Visualforce 디자인 가이드라인 따르기

task-centric 페이지를 설계하고, 표준 객체·선언적 기능을 쓰고, 컴포넌트 계층을 평탄화한다.

- **Design Task-Centric Pages** — 특정 task 중심으로, 논리적 workflow와 명확한 navigation으로 설계한다. 기능·데이터를 한 페이지에 과적재하지 않는다. unbounded data 또는 다수 컴포넌트·row·field를 가진 VF 페이지는 usability·성능이 나쁘다. view state·heap size governor limit, record retrieval limit·page size limit를 칠 위험이 있다.
- **Use Standard Features Wherever Possible** — approval process·flow·workflow rule 같은 표준 객체·선언적 기능은 이미 고도로 최적화돼 있고 대부분의 governor limit에 카운트되지 않는다.
- **Flatten Component Hierarchies** — 평탄한 구조가 깊은 계층 구조보다 빠르게 처리된다. custom component 중첩은 logic이 재사용·패키지 포함 의도일 때만 쓴다. Visualforce는 요청 전체에서 context를 유지하므로 계층 순회마다 시간·리소스를 소비하고, 거대한 계층은 heap size limit 위험을 키운다.

### 데이터 크기 제어 (Control Data Size)

Visualforce 페이지는 **15-MB standard response limit**이 있고, 작은 페이지가 큰 페이지보다 빨리 로드된다. load time을 최소화하려면 각 페이지가 표시하는 데이터 양을 제한한다.

**Filter Query Results:**
- filter로 SOQL이 가져오고 Apex controller가 반환하는 데이터를 제한한다. 예: WHERE 절에 AND 사용. null 쿼리 결과도 제거할 수 있다.
- Apex controller 작성 시 `with sharing` 키워드로 사용자가 접근 가능한 레코드만 조회한다.
- **Filter in SOQL first, then in Apex, and finally in Visualforce.**

**Use Pagination:**
- unbounded data 페이지는 load time 증가·governor limit·dataset 증가에 따른 사용불가를 부른다. list view의 unbounded data를 막으려면 list controller로 pagination을 구현한다. list controller는 기본 **page당 20 레코드**를 반환하고, list view를 **최대 100 레코드**까지 표시하도록 구성할 수 있다. page당 레코드 수 제어는 controller extension으로 `pageSize`를 설정한다.
- SOQL `OFFSET` 절로 SOQL 내 특정 결과 subset으로 pagination하는 logic을 작성한다.

### 자주 접근하는 데이터 캐싱 (Cache Frequently Accessed Data)

icon graphic 같은 자주 접근하는 데이터를 캐싱하고, global data는 custom setting에 캐싱한다. 전역으로 계산 결과를 쓰는 페이지는 사용자·요청 간 같은 데이터를 쓴다. custom setting은 애플리케이션 캐시의 일부라 조회에 DB 쿼리가 필요 없다. 매 요청마다가 아니라 주기적으로 결과를 refresh한다. (custom cached data 업데이트 시간과 균형을 맞춘다.)

### 페이지 컴포넌트 지연 로딩 (Lazy Load Page Components)

비싼 계산을 줄이거나 지연하려면 lazy loading을 쓴다. 페이지가 필수 컴포넌트를 먼저 로드하고 나머지는 사용자 동작 전까지 지연한다. 전체 로드 총 시간은 같아도 큰 페이지가 더 응답성 있게 보인다.

- Visualforce 컴포넌트의 `rerender` 속성으로 전체 페이지가 아닌 컴포넌트만 업데이트한다.
- JavaScript remoting으로 controller 함수를 호출해 부가·정적 데이터를 가져온다.
- custom component를 만들어 사용자 동작에 따라 데이터를 show/hide한다.

> lazy load 시 예상 사용자 수·데이터 양을 고려한다. concurrent API call limit 같은 limit에 주의한다. 예를 들어 navigation tree가 필요할 때만 element를 로드하면 쿼리 수가 데이터에 비해 과해질 수 있다.

### 다중 동시 요청 처리 (Handle Multiple Concurrent Requests)

Concurrent request는 다른 pending task를 막는 long-running task다. 지연을 줄이려면 가능한 한 코드를 asynchronous code block으로 옮기고, `<apex:actionPoller>`를 쓰는 action method를 가볍게 유지한다.

- **Write Asynchronous Code** — Ajax(Asynchronous JavaScript and XML)로 비필수 logic을 async block으로 옮긴다. 동기 코드만 쓴 페이지는 사용자가 버튼 클릭 후 long-running task 완료까지 기다린다. async 처리로 queue하면 제어가 즉시 사용자에게 돌아오고, 완료 시 알리도록 구성할 수 있다.
- **Keep `<apex:actionPoller>` Lightweight** — `<apex:actionPoller>`는 Ajax 요청을 보내는 타이머다. 이를 쓰는 페이지는 서버에 지속적으로 요청한다. 사용자가 페이지를 오래 열어두거나 같은 페이지를 여러 창에 열면 성능이 저하된다. action method에서 DML·외부 서비스 호출 등 리소스 집약 작업을 피한다. governor limit를 피하려면 Ajax 요청 간격을 늘린다 — `<apex:actionPoller>`의 `interval` 속성은 Ajax update 요청 간격(초)이며, **반드시 5초 이상**이고 지정하지 않으면 **기본 60초**다. 비싼 계산이 필요한 페이지엔 `<apex:actionPoller>` 대신 `<apex:actionFunction>` + JavaScript remoting을 고려한다 (코드는 더 들지만 유연·효율적).

### 효율적인 Apex·SOQL 작성 (Write Efficient Apex and SOQL)

VF 페이지 내에서 Apex·SOQL을 작성할 때:

- Perform calculations in SOQL instead of in Apex whenever possible.
- Never perform Data Manipulation Language (DML) operations inside a loop.
- Filter in SOQL first, then in Apex, and finally in Visualforce.

### 효율적인 Getter 메서드 작성 (Write Efficient Getter Methods)

form submission 같은 요청은 class의 getter method를 여러 번 호출할 수 있다. 같은 레코드의 불필요한 lookup을 막으려면 property 계산 값을 캐싱해 추가 호출이 재계산 없이 property에 접근하게 한다. getter method는 객체가 null일 때만 쿼리하도록 구성할 수 있다.

```apex
Account MyAccount;
public Account getMyAccount() {
if (MyAccount == null) {
MyAccount = [SELECT name, annualRevenue FROM Account
WHERE
id = :ApexPages.currentPage().getParameters().
get('id')];
}
return MyAccount;
}
```

첫 호출 시 `MyAccount`가 null이라 쿼리하고, 이후 호출은 저장된 값을 반환해 동일한 SELECT 쿼리를 막는다.

### 리스트·테이블 최적화 (Optimize Lists and Tables)

페이지당 표시 데이터를 제한하고 테이블당 editable field 수를 줄인다. pagination을 구현하거나 `<apex:pageBlockTable>`을 static HTML table로 대체할 수도 있다.

**Avoid Data Grids if Possible** — Data grid는 editable field가 있는 레코드를 표시하는 테이블이다. 수천 개의 input component로 확장돼 maximum view state size를 초과하기 쉽다. data grid가 있다면:
- pagination·filter를 쓴다.
- view state size를 줄이려면 가능한 한 데이터를 read-only로 만든다.
- 레코드당 필수 데이터만 표시한다. Ajax 기반 details box 또는 별도 details 페이지로 링크한다.

**Consider Static HTML Tables** — `<apex:pageBlockTable>` 같은 iteration 컴포넌트는 **최대 1,000개 item**, 페이지가 **read-only mode로 실행되면 10,000개 item**을 담을 수 있다. 단, `<apex:column>`에 `rendered` 속성을 명시적으로 지정하면 이 limit 전에도 성능이 저하될 수 있다. 큰 테이블엔 pagination을 권장하거나, `<apex:pageBlockTable>` 대신 static HTML table을 쓰고 그 안에서 `<apex:repeat>`로 HTML row element를 iterate한다.

> Note: `<apex:pageBlockTable>` 테이블과 달리 static HTML table은 표준 Salesforce 스타일링이 없다.

### View State 최적화 (Optimize the View State)

VF 페이지의 view state를 유지하기 위해 Lightning Platform은 컴포넌트·field 값·controller의 상태를 **암호화된 문자열**로 hidden form element에 저장한다. **view state는 170 KB limit**이 있다. 큰 view state는 요청마다 직렬화·역직렬화, 암호화·복호화 시간을 더 요구한다. view state size를 줄이면 페이지가 더 빨리 로드되고 덜 멈춘다.

view state를 검사하려면 **Development Mode**와 **Show View State in Development Mode** 사용자 권한을 설정한다. development mode footer의 **View State** 탭이 view state 분포를 표시한다. 각 페이지의 view state size를 파악하고 대용량 데이터로 테스트한다.

**view state 줄이기:**
- filter·pagination으로 상태가 필요한 데이터를 줄인다.
- 변수가 현재 요청에만 유용하면 `transient` 키워드로 instance 변수를 선언한다 — transient 변수는 view state에 포함되지 않는다.
- SOQL이 VF 페이지에 관련된 데이터만 반환하도록 정제한다.
- 페이지가 의존하는 컴포넌트 수를 줄인다.
- 데이터를 read-only로 만든다. `<apex:inputField>` 대신 `<apex:outputText>`를 쓴다.
- JavaScript remoting을 쓴다. `<apex:actionFunction>`과 달리 `<apex:form>`이 필요 없다. JavaScript remoting은 페이지의 전체 view state를 줄이진 않지만, view state 전송·직렬화·역직렬화 없이 일반적으로 더 잘 수행한다. 트레이드오프는 `reRender` 속성 상실과 callback 처리용 추가 JavaScript 코드 필요다.

### HTML 최적화 (Optimize HTML)

서버 측에선 Visualforce가 HTML을 검증하므로 최적화된 HTML이 처리 효율을 높인다. 클라이언트 측에선 사용자 브라우저에서 더 응답성 있게 만든다.

- Visualforce 컴포넌트가 생성하는 HTML을 검토한다. VF 페이지는 컴파일 중 invalid HTML을 교정하는데, 이는 의도치 않게 렌더링될 수 있다. 예: `<apex:page>` 태그 안에 `<head>`나 `<body>` 태그가 있으면 런타임에 제거한다.
- Ajax 코드를 검토한다. Ajax 요청 중 서버는 응답이 DOM에 제대로 맞도록 inbound HTML을 검증·교정한다. 마크업이 valid하면 교정이 불필요해 처리 시간이 준다.
- HTML bloat를 줄인다. 브라우저가 HTML·컴파일된 VF 태그를 캐싱해도 캐시에서 꺼내는 게 성능에 영향을 준다. 불필요한 HTML은 component tree 크기·Ajax 처리 시간도 늘린다.

### CSS 최적화 (Optimize CSS)

- **Externalize style sheets** — inline CSS를 별도 CSS 파일로 옮긴다. 초기 HTTP 요청 수는 늘지만 개별 페이지 크기가 줄고, 브라우저가 캐싱하면 전체 요청 크기가 준다.
- 모든 CSS 파일을 단일 파일로 합쳐 HTTP 요청 수를 줄인다.
- comment·여분 whitespace 제거. 결과 파일을 압축한다.
- static resource로 CSS를 서빙한다 — Salesforce에 내장된 caching·CDN의 혜택을 받는다.
- Salesforce CSS를 안 쓰는 페이지는 `<apex:page>`의 `showHeaders`·`standardStylesheets` 속성을 false로 설정해 표준 Salesforce CSS를 생성된 page header에서 제외한다.

### JavaScript 최적화 (Optimize JavaScript)

- **Externalize JavaScript files** — 초기 HTTP 요청은 늘지만 개별 페이지 크기를 줄이고 브라우저 캐싱을 활용한다.
- 필요한 함수만 담은 custom 버전 라이브러리를 만든다 (jQuery 등 다수 오픈소스가 이 옵션 제공).
- 모든 JS를 단일 파일로 합치고 중복 함수를 제거해 HTTP 요청을 줄인다.
- comment·whitespace 제거 후 압축한다.
- static resource로 JS를 서빙한다 (caching·CDN 혜택).
- script를 페이지 하단에 둔다. 닫는 `</body>` 태그 직전에 로드되면 다른 컴포넌트를 먼저 다운로드하고 점진적으로 렌더링한다.

> Note: JS가 부작용이 없다고 확신할 때만 하단으로 옮긴다. 예: `document.write`가 필요하거나 `<head>`의 event handler인 JS는 옮기지 않는다.

- `<apex:includeScript>` 태그 대신 닫는 `</apex:page>` 태그 직전에 표준 HTML `<script>` 태그를 쓰는 것을 고려한다. `<apex:includeScript>`는 JS를 닫는 `</head>` 직전에 배치하므로 브라우저가 다른 콘텐츠 렌더링 전에 JS 로드를 시도하게 만든다.

### 이미지 최적화 (Optimize Images)

이미지는 흔히 웹 페이지의 가장 큰 컴포넌트라 VF 페이지 성능에 큰 영향을 준다.

- 더 적은 이미지·더 작은 background texture를 쓴다.
- 가능한 한 이미지 대신 CSS를 쓴다.
- 개별 이미지 대신 **CSS sprite**를 쓴다 — 버튼·icon 같은 비슷한 크기 graphic을 단일 파일로 합치고 CSS `background-image`·`background-position`으로 일부를 표시한다. 이미지 수·HTTP 요청이 줄고, sprite 파일 캐싱이 다수 이미지 캐싱보다 효율적이다.
- static resource로 이미지를 서빙한다 (caching·CDN 혜택).
- 이미지를 압축한다. 이미지 압축 도구는 visual quality 저하 없이 파일 크기를 **최대 30%**까지 줄일 수 있다.

> Tip: 개발 workflow 개선을 위해 이미지 asset을 압축하는 script를 추가한다.

### 필드가 페이지에서 누락되는 것 방지 (Prevent Fields from Dropping Off the Page)

많은 field를 가진 VF 페이지(특히 큰 text area field 또는 다른 entity와 master-detail 관계가 있는 경우)는 요청된 모든 field를 표시하지 못할 수 있다. batch limit·반환 데이터 크기 limit 때문에 데이터가 dropped될 수 있다. 표시 field 수를 줄이거나, child 레코드를 쿼리해 related list에 결과를 표시하는 controller extension을 만든다.

### immediate 속성을 신중히 사용 (Use the immediate Attribute Carefully)

`immediate` 속성을 `true`로 설정한 VF 컴포넌트는 해당 field의 validation rule을 처리하지 않고 action을 실행한다. **이 속성은 완료 후 페이지를 벗어나는(navigates away) action을 실행하는 컴포넌트에만 써야 한다.** 기본 navigation 이상의 동작을 포함하면 기능 문제가 발생한다. `immediate="true"`는 페이지의 data model을 업데이트하지 않으므로 action 중 변경이 data model에 반영되지 않아 undefined behavior·데이터 손상 가능성이 있다. **취소(cancellation) action에만 권장된다.**

```apex
<apex:CommandLink action="{!cancelApplication}" value="Cancel" styleClass="btn"
id="btnCancel" immediate="true">
```

### 성능 케이스 스터디 (Visualforce Performance Case Study)

큰 data grid와 복잡한 객체 계층이 있는 페이지로 최적화가 함께 작동하는 방식을 본다. forecast data model은 multilevel 객체 계층이고, 페이지엔 pivoted data 계산이 있다. 평균 사용자에게 grid는 약 1,500 cell을 가져 느리게 로드되고 heap·view state limit를 친다. 최적화:

- 페이지를 targeted·task-focused로 만든다. 입력과 집계 리포트를 같은 페이지에 쓰면 불필요한 복잡성이 생긴다.
- 리포팅용 집계 데이터를 담는 custom object를 만든다. 집계 표시용 formula 제거로 heap size가 준다.
- 모든 account를 한 페이지에 표시하지 않는다. pagination으로 load 속도·view state size를 개선한다.
- data grid cell을 read-only로 만든다. 사용자가 편집할 cell을 선택하게 하고 Ajax로 저장해 view state size를 줄인다.

---

## 컴포넌트 ID 접근 베스트 프랙티스

JavaScript 등 Web 언어에서 VF 컴포넌트를 참조하려면 해당 컴포넌트의 `id` 속성에 값을 지정해야 한다. **DOM ID**는 컴포넌트의 `id` 속성과 그것을 포함하는 모든 컴포넌트의 `id` 속성 조합으로 구성된다.

`$Component` global 변수로 생성된 DOM ID 참조를 단순화하고 전체 페이지 구조 의존성을 줄인다. dot notation으로 계층 각 레벨을 구분해 component path specifier를 `$Component`에 추가한다. 예: 같은 레벨은 `$Component.itemId`, 더 완전한 경로는 `$Component.grandparentId.parentId.itemId`.

**`$Component` path specifier 매칭:**
- `$Component`가 쓰인 현재 component 계층 레벨에서; 그다음
- match를 찾거나 최상위 레벨에 도달할 때까지 각 상위 레벨에서.

> backtracking이 없으므로, 매칭하려는 ID가 위로 올라갔다 다시 내려오는 traversal을 요구하면 match되지 않는다.

```apex
<apex:page >
<style>
.clicker { border: 1px solid #999; cursor: pointer;
margin: .5em; padding: 1em; width: 10em; text-align: center; }
</style>
<apex:form id="theForm">
<apex:pageBlock id="thePageBlock" title="Targeting IDs with $Component">
<apex:pageBlockSection id="theSection">
<apex:pageBlockSectionItem id="theSectionItem">
All the alerts refer to this component.
<p>The full DOM ID resembles something like this:<br/>
j_id0:theForm:thePageBlock:theSection:theSectionItem</p>
</apex:pageBlockSectionItem>
<!-- Works because this outputPanel has a parent in common
with "theSectionItem" component -->
<apex:outputPanel layout="block" styleClass="clicker"
onclick="alert('{!$Component.theSectionItem}');">
First click here
</apex:outputPanel>
</apex:pageBlockSection>
<apex:pageBlockButtons id="theButtons" location="bottom">
<!-- Works because this outputPanel has a grandparent ("theSection")
in common with "theSectionItem" -->
<apex:outputPanel layout="block" styleClass="clicker"
onclick="alert('{!$Component.theSection.theSectionItem}');">
Second click here
</apex:outputPanel>
<!-- Works because this outputPanel has a distant ancestor ("theForm")
in common with "theSectionItem" -->
<apex:outputPanel layout="block" styleClass="clicker"
onclick="alert('
{!$Component.theForm.thePageBlock.theSection.theSectionItem}');">
Third click here
</apex:outputPanel>
</apex:pageBlockButtons>
</apex:pageBlock>
<!-- Works because this outputPanel is a sibling to "thePageBlock",
and specifies the complete ID path from that sibling -->
<apex:outputPanel layout="block" styleClass="clicker"
onclick="alert('{!$Component.thePageBlock.theSection.theSectionItem}');">
Fourth click here
</apex:outputPanel>
<hr/>
<!-- Won't work because this outputPanel doesn't provide a path
that includes a sibling or common ancestor -->
<apex:outputPanel layout="block" styleClass="clicker"
onclick="alert('{!$Component.theSection.theSectionItem}');">
This won't work
</apex:outputPanel>
<!-- Won't work because this outputPanel doesn't provide a path
that includes a sibling or common ancestor -->
<apex:outputPanel layout="block" styleClass="clicker"
onclick="alert('{!$Component.theSectionItem}');">
Won't work either
</apex:outputPanel>
</apex:form>
</apex:page>
```

**Using Unique IDs** — 각 계층 segment 내에서 컴포넌트 `id`는 unique해야 한다. 단, Salesforce는 참조가 필요한 모든 컴포넌트와 참조에 필요한 상위 컴포넌트에 **페이지 전체에서 unique한 id**를 쓰기를 권장한다. 별도 page block에 담긴 두 data table은 같은 `id`를 가질 수 있으나, 그러면 특정 table 참조를 위해 모든 컴포넌트에 id를 부여하고 전체 계층으로 참조해야 한다. page 계층이 바뀌면 프로그램이 동작하지 않는다.

**Iterating with Component IDs** — table·list 같은 iteration 컴포넌트는 초기 ID를 기반으로 각 iteration에 unique "compound ID"를 부여한다. `id="theTable"`인 data table은 렌더링 시 `thePage:theTable:0:firstColumn`, `thePage:theTable:0:secondColumn`, `thePage:theTable:1:firstColumn` 식의 cell ID를 생성한다. cell 내 element도 같은 방식(`thePage:theTable:0:accountName`)으로 생성되며, 이 ID엔 자신이 속한 column의 ID 값이 포함되지 않는다.

---

## Static Resource 베스트 프랙티스

**`<apex:page>`의 `action` 속성으로 static resource 콘텐츠 표시** — VF 페이지에서 static resource로 redirect할 수 있다. 예: PDF로 redirect —

```apex
<apex:page sidebar="false" showHeader="false" standardStylesheets="false"
action="{!URLFOR($Resource.customhelp)}">
</apex:page>
```

static resource 참조는 `URLFOR` 함수로 감싼다 — 없으면 redirect가 제대로 안 된다. PDF에 국한되지 않고 어떤 static resource 콘텐츠로도 redirect할 수 있다. 단일 entry point가 있으면 HTML·JS·이미지·멀티미디어가 섞인 전체 help 시스템 zip도 가능하다.

```apex
<apex:page sidebar="false" showHeader="false" standardStylesheets="false"
action="{!URLFOR($Resource.customhelpsystem, 'index.htm')}">
</apex:page>
```

> Static Resource의 등록·참조 메커니즘 전반은 [[버튼·링크 오버라이드·Static Resource·커스텀 컴포넌트]] 참조.

---

## 컨트롤러·컨트롤러 확장 베스트 프랙티스

**Enforcing Sharing Rules in Controllers** — 다른 Apex class처럼 custom controller·controller extension은 **system mode로 실행**된다. 보통 사용자의 org-wide default·role hierarchy·sharing rule을 respect하길 원하면 class 정의에 `with sharing` 키워드를 쓴다.

> Note: controller extension이 standard controller를 extend하면, standard controller의 logic은 system mode가 아니라 **user mode로 실행**된다 — 현재 사용자의 permission·field-level security·sharing rule이 적용된다.

**Controller Constructors Evaluate Before Setter Methods** — setter method가 constructor보다 먼저 평가된다고 의존하지 않는다. 아래 component에서 controller는 `selectedValue`의 setter가 constructor 전에 호출되길 의존한다.

```apex
<apex:component controller="CustCmpCtrl">
<apex:attribute name="value" description=""
type="String" required="true"
assignTo="{!selectedValue}">
</apex:attribute>
//...
//...
</apex:component>
public class CustCmpCtrl {
// Constructor method
public CustCmpCtrl() {
if (selectedValue != null) {
EditMode = true;
}
}
private Boolean EditMode = false;
// Setter method
public String selectedValue { get;set; }
}
```

constructor가 setter보다 먼저 호출되므로 constructor 호출 시 `selectedValue`는 항상 null이고, `EditMode`는 결코 true로 설정되지 않는다.

**Methods may evaluate more than once — do not use side-effects** — controller의 method·action 속성·expression은 한 번 이상 호출될 수 있다. custom method 작성 시 evaluation order나 side-effect에 의존하지 않는다.

> controller·extension의 메커니즘 전반은 [[커스텀 컨트롤러·컨트롤러 확장]] 참조.

---

## Component Facet 베스트 프랙티스

facet은 VF 컴포넌트의 한 영역에 표시되는 데이터에 대한 contextual 정보를 제공하는 콘텐츠다. 예: `<apex:dataTable>`은 header·footer·caption facet을 지원하고, `<apex:column>`은 header·footer만 지원한다. `<apex:facet>` 컴포넌트로 기본 facet을 자신의 콘텐츠로 override한다. **facet은 start·close 태그 사이에 단일 child만 허용한다.**

> Note: 모든 컴포넌트가 facet을 지원하지 않는다. 지원하는 컴포넌트는 Standard Visualforce Component Reference에 나열돼 있다.

`<apex:facet>`은 항상 다른 VF 컴포넌트의 child로 쓰인다. `name` 속성이 parent 컴포넌트의 어느 영역을 override할지 결정한다.

```apex
<apex:page standardController="Account">
<apex:pageBlock>
<apex:dataTable value="{!account}" var="a">
<apex:facet name="caption"><h1>This is
{!account.name}</h1></apex:facet>
<apex:facet name="footer"><p>Information
Accurate as of {!NOW()}</p></apex:facet>
<apex:column>
<apex:facet name="header">Name</apex:facet>
<apex:outputText value="{!a.name}"/>
</apex:column>
<apex:column>
<apex:facet
name="header">Owner</apex:facet>
<apex:outputText value="{!a.owner.name}"/>
</apex:column>
</apex:dataTable>
</apex:pageBlock>
</apex:page>
```

> Note: 이 페이지가 account 데이터를 표시하려면 valid account 레코드 ID를 URL query parameter로 지정해야 한다. 예: `https://MyDomain_login_URL/apex/facet?id=001D000000IRosz`

> PDF에는 이 페이지의 렌더링 결과 화면("Extending `<apex:dataTable>` with a Facet", p.398)이 스크린샷으로 포함돼 있다 — (PDF 스크린샷 — 텍스트만). 본 wiki에는 텍스트 설명만 둔다.

**`<apex:actionStatus>`와 facet** — `<apex:actionStatus>`는 페이지 refresh 시 indicator를 표시하도록 확장할 수 있다. 예: progress wheel —

```apex
<apex:page controller="exampleCon">
<apex:form >
<apex:outputText value="Watch this counter: {!count}" id="counter"/>
<apex:actionStatus id="counterStatus">
<apex:facet name="start">
<img src="{!$Resource.spin}"/> <!-- A previously defined image -->
</apex:facet>
</apex:actionStatus>
<apex:actionPoller action="{!incrementCounter}" rerender="counter"
status="counterStatus" interval="7"/>
</apex:form>
</apex:page>
```

```apex
public class exampleCon {
Integer count = 0;
public PageReference incrementCounter() {
count++;
return null;
}
public Integer getCount() {
return count;
}
}
```

> PDF에는 "Extending `<apex:actionStatus>` with a Facet" 렌더링 화면이 스크린샷으로 포함돼 있다 — (PDF 스크린샷 — 텍스트만).

---

## Page Block 컴포넌트 베스트 프랙티스

**`<apex:pageBlockSectionItem>`에 child 2개 초과 추가** — `<apex:pageBlockSectionItem>`은 최대 2개 child만 가질 수 있다. 추가 child를 넣으려면 `<apex:outputPanel>`로 감싼다. 예: `<apex:outputLabel>` 앞에 asterisk를 붙이면서 input text field도 표시하려면 —

```apex
<!-- Page: -->
<apex:page standardController="Account">
<apex:form >
<apex:pageBlock title="My Content" mode="edit">
<apex:pageBlockSection title="My Content Section" columns="2">
<apex:pageBlockSectionItem >
<apex:outputPanel>
<apex:outputText>*</apex:outputText>
<apex:outputLabel value="Account Name" for="account__name"/>
</apex:outputPanel>
<apex:inputText value="{!account.name}" id="account__name"/>
</apex:pageBlockSectionItem>
</apex:pageBlockSection>
</apex:pageBlock>
</apex:form>
</apex:page>
```

---

## PDF 렌더링 베스트 프랙티스

VF 페이지를 PDF로 렌더링하는 것은 org 정보 공유에 좋은 방법이다. **더 나은 성능**을 위해 static image·style sheet resource를 `$Resource` global 변수로 참조한다.

> Warning: remote 서버의 static resource를 참조하면 VF 페이지를 PDF로 렌더링하는 시간이 늘어난다. remote 서버를 permitted Remote Sites list에 추가한다 — Setup에서 Quick Find에 `Remote Sites Settings`를 입력해 Remote Sites Settings 선택. **Apex trigger에서 VF로 PDF 렌더링 시 remote resource를 참조할 수 없다 — 하면 exception이 발생한다.**

> VF 페이지의 PDF 렌더링 메커니즘·고려사항·제한은 [[페이지 출력 제어 — HTML·PDF·SLDS]] 참조.

---

## `<apex:panelbar>` 베스트 프랙티스

**`<apex:panelBar>`에 child `<apex:panelBarItem>` 컬렉션 추가** — `<apex:panelBar>`는 `<apex:panelBarItem>` child만 가질 수 있다. child 컬렉션을 넣으려면 `<apex:panelBarItem>`을 `<apex:repeat>`로 감싼다. 예: account의 각 contact마다 item 추가 —

```apex
<apex:page standardController="account">
<apex:panelBar >
<apex:repeat value="{!account.contacts}" var="c">
<apex:panelBarItem label="{!c.firstname}">one</apex:panelBarItem>
</apex:repeat>
</apex:panelBar>
</apex:page>
```

> Note: 이 페이지가 account 데이터를 표시하려면 valid account 레코드 ID를 URL query parameter로 지정해야 한다. 예: `https://MyDomain_login_URL/apex/myPage?id=001D000000IRosz`

---

## 보안 — Apex·Visualforce 개발 보안 팁 (Appendix B 요약)

> Apex와 VF의 강력한 조합은 custom 기능을 제공하지만, 부주의한 developer는 내장 방어를 우회해 애플리케이션·고객을 보안 위험에 노출할 수 있다. AppExchange 인증을 위해서도 아래 보안 결함을 이해하는 것이 중요하다.

이 노트는 **VF 맥락의 보안 권고 요약**만 담는다. 각 위협의 공격 메커니즘·방어 전수는 전용 Security 노트의 deep-link로 위임한다.

### Open Redirects Through Static Resources

URL redirect는 사용자를 다른 페이지로 자동 전송한다. **Open redirect**(arbitrary redirect)는 사용자가 제어하는 값이 redirect 대상을 결정하는 흔한 취약점이다.

> Warning: static resource를 통한 open redirect는 의도치 않은(악의적일 수 있는) redirect 위험에 사용자를 노출한다. "Customize Application" 권한을 가진 admin만 static resource를 업로드할 수 있으니, 이 권한을 가진 admin은 static resource에 악성 콘텐츠가 없도록 주의해야 한다.

> redirect 검증·방어 메커니즘은 [[Arbitrary Redirect 방어]] 참조.

### Cross Site Scripting (XSS)

악성 HTML·client-side scripting을 웹 애플리케이션에 제공해 다른 사용자가 보는 응답에 포함시키는 공격이다. **VF 맥락의 핵심:**

- 모든 표준 VF 컴포넌트(`<apex>`로 시작)는 anti-XSS filter가 있어 harmful 문자를 걸러낸다. 예: `<apex:outputText>`는 XSS-safe이며 `<`를 `&lt;`로 변환한다.
- **escape 비활성화 주의** — 거의 모든 VF 태그는 XSS-취약 문자를 escape한다. `escape="false"`로 이를 끄면 취약해진다.

  ```apex
  <apex:outputText escape="false" value="{!$CurrentPage.parameters.userInput}" />
  ```

- **XSS 보호가 없는 항목** — custom JavaScript와 `<apex:includeScript>` 컴포넌트 내 코드는 내장 XSS 보호가 없다. 직접 작성한 JavaScript는 플랫폼이 보호할 수 없다.
- **Unescaped Output and Formulas** — `escape="false"`인 컴포넌트나 VF 컴포넌트 바깥의 formula는 출력이 unfiltered라 검증해야 한다(formula expression에서 특히 중요). expression은 server에서 렌더링되므로 client JavaScript로 escape할 수 없다. escape 함수: `HTMLENCODE`, `JSENCODE`, `JSINHTMLENCODE`(= `JSENCODE(HTMLENCODE(someValue))`), `URLENCODE`. 데이터 배치·사용에 따라 escape할 문자가 다르다 — 예: JavaScript 변수로 복사 시 double quote는 `%22`로, 그렇지 않으면 HTML escape `"` 사용.

> XSS 공격 메커니즘과 브라우저 파싱 컨텍스트별 인코딩 함수 전수는 [[XSS 방어]] 참조.

### Cross-Site Request Forgery (CSRF)

CSRF는 프로그래밍 실수라기보다 방어 부재다. Lightning Platform은 모든 페이지에 hidden form field로 random anti-CSRF 토큰을 넣어, 다음 page load 때 값이 일치하지 않으면 명령을 실행하지 않는다 — 모든 표준 controller·method 사용 시 보호된다.

**VF 맥락의 위험:** developer가 직접 action method를 작성하면 내장 방어를 우회할 수 있다. 아래 custom controller는 `id` parameter를 읽어 SOQL·DML에 쓰지만 anti-CSRF 토큰을 읽거나 검증하지 않는다.

```apex
<apex:page controller="myClass" action="{!init}"</apex:page>
public class myClass {
public void init() {
Id id = ApexPages.currentPage().getParameters().get('id');
Account obj = [select id, Name FROM Account WHERE id = :id];
delete obj;
return ;
}
}
```

work-around: 사용자가 페이지 호출을 의도했는지 확인하는 중간 confirmation 페이지 삽입, idle session timeout 단축, 사용자 교육 등.

> Salesforce 내장 CSRF 방어 때문에 여러 Salesforce 로그인 페이지가 열려 있으면 "The page you submitted was invalid for your session." 오류가 날 수 있다 — 로그인 페이지 새로고침이나 재시도로 해결.

> page load 중 자동 실행되는 state-changing logic의 CSRF 위험·방어는 [[CSRF 방어]] 참조.

### SOQL Injection

user-supplied input을 dynamic SOQL 쿼리에 검증 없이 쓰면, input이 SOQL 명령을 포함해 statement를 수정하고 의도치 않은 명령을 수행하게 할 수 있다.

**VF 맥락의 방어:**
- dynamic SOQL을 피하고 **static query + binding variable**을 쓴다.
- dynamic SOQL을 써야 하면 `escapeSingleQuotes` method로 user input을 sanitize한다 — string 내 모든 single quotation mark에 escape 문자(backslash)를 추가해 string을 감싸는 것으로 처리되게 한다.

```apex
public class SOQLController {
public String name {
get { return name;}
set { name = value;}
}
public PageReference query() {
String queryName = '%' + name + '%';
List<Contact> queryResult = [SELECT Id FROM Contact WHERE
(IsDeleted = false and Name like :queryName)];
System.debug('query result is ' + queryResult);
return null;
}
}
```

> SOQL Injection 공격 시나리오와 `escapeSingleQuotes`·bind variable 방어 전수는 [[SOQL Injection 위협]] 참조.

### Data Access Control

Salesforce Platform은 data sharing rule을 광범위하게 쓴다. 각 객체엔 permission과 sharing setting이 있고, 이는 모든 표준 controller 사용 시 강제된다.

> When using an Apex class, the default behavior is tp[sic] respect built-in user permissions and field-level security restrictions during execution, that is, as if the class were declared as `with sharing`.

```apex
public class customController {
public void read() {
Contact contact = [SELECT id FROM Contact WHERE Name = :value];
}
}
```

이 경우 현재 사용자의 contact 레코드만 검색된다. 플랫폼은 모든 레코드에 full access를 주는 대신 현재 로그인 사용자의 security sharing permission을 쓴다.

---

## 문서 표기 규약 (Documentation Typographical Conventions)

Apex·Visualforce 문서가 쓰는 표기 규약 — verbatim:

| Convention | Description |
|---|---|
| Courier font | syntax 설명에서 monospace는 brackets를 제외하고 보이는 대로 타이핑할 항목. 예: `Public class HelloWorld` |
| Italics | syntax 설명에서 italic은 변수 — 실제 값을 공급. 예: `datatype variable_name [ = value];`. bold+italic이면 class 이름·변수 값처럼 값을 공급해야 하는 code element. 예: `public static class YourClassHere { ... }` |
| Bold Courier font | code sample·syntax 설명에서 bold courier는 code·syntax의 일부를 강조 |
| `<>` | syntax 설명에서 less-than·greater-than(`< >`)은 보이는 대로 타이핑 |
| `{}` | syntax 설명에서 braces(`{ }`)는 보이는 대로 타이핑 |
| `[]` | syntax 설명에서 brackets에 포함된 것은 optional |
| `\|` | syntax 설명에서 pipe는 "or" — 나열된 것 중 하나만 가능 |

---

## 관련 노트

- [[커스텀 컨트롤러·컨트롤러 확장]] — controller/extension 메커니즘·sharing·생성자 (본 노트 컨트롤러 권고의 본체)
- [[페이지 출력 제어 — HTML·PDF·SLDS]] — PDF 렌더링·HTML 출력 제어 (본 노트 PDF 권고의 본체)
- [[버튼·링크 오버라이드·Static Resource·커스텀 컴포넌트]] — Static Resource 등록·참조·custom component
- [[JavaScript·Remoting·LMS across DOM]] — JavaScript remoting·$Component·DOM
- [[동적 Visualforce — 바인딩·동적 컴포넌트]] — dynamic binding·동적 컴포넌트
- [[XSS 방어]] — XSS 공격·브라우저 파싱 컨텍스트별 인코딩 함수 (보안 deep-link)
- [[CSRF 방어]] — CSRF·page load DML·anti-CSRF 토큰 (보안 deep-link)
- [[SOQL Injection 위협]] — SOQL 인젝션·escapeSingleQuotes·bind variable (보안 deep-link)
- [[Arbitrary Redirect 방어]] — open/arbitrary redirect 검증·방어 (보안 deep-link)
