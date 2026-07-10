---
tags: [flow, distribution, quick-action, flow-url, lightning-page, utility-bar, visualforce, aura, experience-cloud, paused-interview]
source: extend_click_automate.pdf (Automate Your Business Processes, Spring '26)
created: 2026-07-10
aliases: [Distribute a Flow, Flow URL, Flow Quick Action, Flow 배포, 플로우 배포 위치, 플로우 URL, Flow 유틸리티바, Flow Visualforce 임베드, flow interview 컴포넌트, retURL, Paused Flow Interview, 일시정지 인터뷰]
---

# Flow 배포 위치 가이드

> 완성한 Flow를 **어디에 심어서 누구에게 노출할 것인가** — 조직 내 사용자(액션·URL·Lightning 페이지·유틸리티바·Aura·Visualforce), 조직 외부 사용자(Experience Cloud·외부 Visualforce), 자동화 시스템(Process·Workflow·REST)까지 경로별 절차 전수.

---

## 배포 경로 한눈에

| 대상 | 경로 | 런타임 |
|---|---|---|
| 조직 내 사용자 | Lightning 페이지 (앱빌더) | Lightning |
| 조직 내 사용자 | 오브젝트별 퀵액션 (Flow action) | Lightning |
| 조직 내 사용자 | Actions & Recommendations 컴포넌트 | Lightning |
| 조직 내 사용자 | 유틸리티 바 | Lightning |
| 조직 내 사용자 | Flow URL · 커스텀 버튼/링크 · 웹탭 | 설정에 따라 Classic/Lightning |
| 조직 내 사용자 | 커스텀 Aura 컴포넌트 (`lightning:flow`) | Lightning |
| 조직 내 사용자 | Visualforce 페이지 (`<flow:interview>`) | Classic |
| 조직 외부 사용자 | Experience Builder 사이트 페이지, 외부 앱/페이지, Embedded Service 배포 | — |
| 조직 외부 사용자 | 외부용 Visualforce 페이지 (사이트/포털) | Classic |
| 자동화 시스템 | Apex `start` 메서드 · Process · Workflow 액션(파일럿 종료) · REST API | — |

런타임(Classic vs Lightning) 비교표와 실행 컨텍스트(user/system)는 [[Flow 버전 관리와 활성화 - 배포 수명주기]] 참조.

> **위임 포인터:**
> - **LWC에 임베드**(`lightning-flow` 베이스 컴포넌트)는 [[lightning-flow]] 참조
> - **LWC에서 NavigationMixin(`standard__flow`)으로 기동**은 [[Screen Flow 설계]] 참조
> - **Apex `Flow.Interview`로 기동**은 [[Flow Interview API]] 참조

---

## 조직 내 사용자 배포 (Distribute Flows to Users in Your Org)

### 1. Lightning 페이지에 추가 (Lightning App Builder)

Lightning Experience·Salesforce 앱 사용자에게 가장 쉬운 배포. 필요 권한: Customize Application. Outlook/Gmail 통합 사용 시 커스텀 email application pane도 만들 수 있다.

1. Lightning App Builder에서 Lightning 페이지를 연다
2. 왼쪽 Lightning Components 패널에서 **Flow 컴포넌트**를 캔버스로 드래그
3. 컴포넌트 구성:

| 속성 | 설명 |
|---|---|
| **Flow** | **활성 screen flow만** 선택 가능. Desktop Flow Designer로 만든 flow는 미지원 |
| **Layout** | 기본 1열 표시. **Winter '23부터 2열 flow 레이아웃은 무시됨** — 대신 화면에 Section 컴포넌트(최대 4열 가변폭)를 쓴다. 화면에 Section 컴포넌트가 있으면 그 화면은 Layout 속성을 무시 |
| **입력 변수** | 그 외 속성으로 보이는 것은 flow의 입력 변수. **입력 접근(Available for input)이 허용된 변수만** 표시 |
| **Pass record ID into this variable** | **Record 페이지의 Text 입력 변수에만** 제공. 런타임에 레코드 ID(예: Opportunity ID)를 선택한 변수로 전달. **ID는 변수 1개에만 전달 권장** |

4. 페이지 저장
5. **페이지를 활성화(Activation)해야 사용자에게 노출**된다 — 최초 저장 시 Save 다이얼로그 또는 이후 Activation 버튼
6. flow 동작 확인 후 롤아웃

### 2. 오브젝트별 퀵액션 (Flow Action)

flow action을 만들어 페이지 레이아웃에 추가한다. **글로벌 액션에서는 flow 미지원.** 필요 권한: Customize Application.

1. 대상 오브젝트의 관리 설정에서 **Buttons, Links, and Actions**로 이동
2. **New Action** 클릭
3. Action Type = **Flow** 선택
4. 사용할 flow 선택 — flow는 **활성 상태**이고 타입이 **Screen Flow 또는 Field Service Mobile Flow**여야 함
5. 액션 레이블 입력 — 사용자는 flow 이름이 아니라 이 레이블을 본다 (flow 이름을 그대로 쓰길 권장)
6. 필요 시 액션 이름(API·managed 패키지에서 사용) 변경 — 문자로 시작, 영숫자·밑줄만, 밑줄로 끝나거나 연속 밑줄 불가
7. 설명 입력 — 사용자에게 보이지 않음, 액션 상세 페이지와 목록에 표시
8. 필요 시 액션 아이콘을 조직의 static resource로 변경 — 커스텀 이미지는 **1MB 미만**
9. 저장
10. **페이지 레이아웃에 액션을 추가**해야 사용자에게 노출된다

레코드 ID를 flow에 전달하려면 flow에 다음 변수가 있어야 한다:

| 변수 설정 | 값 |
|---|---|
| API Name | `recordId` (**대소문자 구분**) |
| Data Type | Text |
| Available for input | 선택됨 |

> 액션을 삭제하면 할당된 모든 레이아웃에서 제거된다. 액션이 참조하는 flow를 **비활성화하면 런타임에 액션이 표시되지 않는다.**

### 3. Actions & Recommendations 컴포넌트

Lightning 콘솔·표준 내비게이션 앱에서 복잡한 업무 프로세스를 안내할 때. process로 **RecordAction** 오브젝트를 생성하거나 **Actions & Recommendations deployment**를 만들어 flow를 레코드에 연결한 뒤, Lightning App Builder로 컴포넌트를 페이지에 추가한다.

- 사용자가 이 컴포넌트가 있는 레코드를 열면 목록에서 flow·액션을 기동할 수 있다.
- flow는 **콘솔 앱에서는 서브탭**, 표준 내비게이션 앱에서는 **팝업 창**으로 시작된다. 콜 스크립트·채팅 응대에 적합.
- 상세는 Lightning Flow for Service Developer Guide(영문) 참조.

### 4. 유틸리티 바

앱의 어느 페이지에서든 flow에 접근하게 한다.

1. Setup Quick Find에 `App` 입력 → **App Manager** 선택
2. 기존 Lightning 앱 편집 또는 **New Lightning App** (커스텀 Classic 앱의 Lightning 업그레이드도 가능)
3. App Settings에서 **Utility Items** 클릭
4. **Add Utility Item** → **Flow** 선택
5. 유틸리티 항목 속성 + 컴포넌트 속성(**Flow**, **Layout**) 구성
   - Tip: Section 컴포넌트가 3열 이상이면 유틸리티 항목의 **Panel Width** 값을 늘려 열이 표시될 공간을 확보
6. 저장 — App Launcher에서 앱을 열어 확인

### 5. Flow URL — 커스텀 버튼·링크·웹탭

커스터마이즈된 look & feel이 필요 없는 사용자용. 필요 권한: Manage Flow (flow 상세 페이지 열람).

1. Setup Quick Find에 `Flows` → **Flows** 선택
2. 배포할 flow의 액션 메뉴에서 **View Details and Versions** (메뉴가 없으면 flow 이름 클릭)
3. flow에 **활성 버전이 있는지 확인** — inactive flow는 Manage Flow 권한자만 실행 가능. flow에 Subflow 요소가 있으면 **참조된 flow에도 활성 버전 필요**
4. flow URL을 복사해 인스턴스에 붙인다:

```
https://yourDomain.my.salesforce.com/flow/MyFlowName
```

managed 패키지에서 설치된 flow는 **네임스페이스 접두사 포함**:

```
https://yourDomain.my.salesforce.com/flow/namespace/MyFlowName
```

5. 변수 초기값 설정: URL에 `?variable1=value1&variable2=value2` 추가
6. URL 배포 — 예: 커스텀 버튼/링크를 만들어 페이지 레이아웃에 추가, 웹탭을 만들어 프로필에 추가

#### 5-a. URL 기반 flow의 런타임 설정

직접 URL·커스텀 버튼·Setup 내 링크 등 URL 기반 flow 전체를 Lightning runtime으로 올리는 스위치.

1. Setup Quick Find에 `Process Automation Settings` → 선택
2. **Enable Lightning runtime for flows** 선택
3. 저장

필요 권한: Customize Application (설정 편집) / Manage Flow (flow list view 관리). 활성화 시 direct link, 커스텀 버튼/링크, Flow Builder, flow 상세 페이지·리스트 뷰에서 실행되는 flow가 Lightning runtime을 쓴다. 이 설정은 URL·Lightning 페이지 배포 시 화면이 1열/2열로 보일지도 제어한다.

#### 5-b. retURL — Finish 후 리다이렉트

기본 동작: 화면이 있는 flow interview가 끝나면 **새 인터뷰가 시작되고 첫 화면으로 돌아간다.** Finish 클릭 시 Salesforce 내 다른 페이지로 보내려면 `retURL` 파라미터를 쓴다.

```
/flow/flowName?retURL=url
```

`url`은 상대 URL (`https://MyDomainName.my.salesforce.com/` 또는 `https://MyDomainName.lightning.force.com/` 뒤 부분).

**URL 옵션:**
- **조직 외부 URL로는 리다이렉트 불가.**
- Tip: **Salesforce Classic URL을 쓸 것** — Classic URL이면 사용자가 켠 경험(LEX/Classic)에 맞는 페이지로 리다이렉트된다 (LEX에 없는 페이지면 Classic 페이지로). **Lightning Experience URL은 항상 LEX 홈(`lightning/page/home`)으로 리다이렉트**되며, LEX 접근 권한이 없는 사용자는 에러를 본다.
- 웹탭으로 리다이렉트하면 웹탭은 Salesforce Classic으로 렌더링된다.
- LEX의 웹탭은 Visualforce 페이지로만 리다이렉트 가능.

**리다이렉트 목적지별 상대 URL:**

| 목적지 | 상대 URL | 예 |
|---|---|---|
| Chatter | `_ui/core/chatter/ui/ChatterPage` | `_ui/core/chatter/ui/ChatterPage` |
| 홈 페이지 | `home/home.jsp` | `home/home.jsp` |
| 리스트 뷰 | `objectCode?fcf=listViewId` | `006?fcf=00BD0000005lwec` |
| 오브젝트 홈 (예: Accounts) | `objectCode/o` | `001/o` |
| 특정 레코드 (연락처·리포트·대시보드·사용자·프로필·Chatter 게시물 등) | `recordId` | `0D5B000000SKZ7V` |
| Visualforce 페이지 | `apex/pageName` | `apex/myVisualforcePage` |
| 웹탭 | `servlet/servlet.Integration?lid=webTabId` | `servlet/servlet.Integration?lid=01rD0000000A88h` |

**제한:**
- `retURL` 값으로 **flow 변수를 쓸 수 없다.** 변수 기반 리다이렉트(예: 특정 레코드로)가 필요하면 Visualforce로 배포한다.
- `retURL`은 목적지 페이지에 중첩된 상단/사이드 내비게이션 바를 렌더링할 수 있다.
- `retURL`은 **대소문자 구분** — `retUrl`로 쓰면 리다이렉트되지 않는다.

**예:**

```
/flow/myFlow?retURL=001/o
/flow/myFlow?retURL=apex/myPage
/flow/User_Info?varUserFirst={!$User.FirstName}
    &varUserLast={!$User.LastName}&retURL=home/home.jsp
```

#### 5-c. URL 파라미터로 변수 설정

- **레코드 변수·레코드 컬렉션 변수는 URL 파라미터로 설정 불가.** 변수는 입력 접근(Available for input)이 허용돼야 한다.
- 형식: `?name=value`, 여러 개는 `?name1=value1&name2=value2`, 같은 컬렉션 변수의 여러 항목은 `?name=value1&name=value2`.

변수 데이터 타입별 허용 값:

| 변수 타입 | 허용 값 |
|---|---|
| Boolean | Checkbox 타입 merge field / true 값: `true` 또는 `1` / false 값: `false` 또는 `0` |
| Currency | Number 타입 merge field 또는 숫자 값 |
| Date | Date 타입 merge field 또는 `YYYY-MM-DD` |
| DateTime | Date/Time 타입 merge field 또는 `YYYY-MM-DDThh:mm:ssZ` |
| Multi-Select Picklist | 아무 타입 merge field 또는 `value1; value2` 형식 문자열 |
| Number | Number 타입 merge field 또는 숫자 값 |
| Picklist | 아무 타입 merge field 또는 문자열 |
| Text | 아무 타입 merge field 또는 문자열 |

> **통화 필드 주의:** 레코드의 통화 필드 값을 URL 파라미터로 currency 변수에 넘기지 말 것. merge field(예: `{!Account.AnnualRevenue}`)로 참조된 통화 값은 통화 기호($)를 포함하는데, flow currency 변수는 숫자만 받으므로 **런타임에 flow가 실패**한다. 대신 레코드 **ID를 text 변수로** 넘기고 flow 안에서 ID로 레코드의 통화 필드를 조회한다.

**예 (PDF 원문):**

```
/flow/MyFlow?varNumber=100&varString=Hello
/flow/Case_Management?varID={!Case.CaseNumber}
/flow/User_Info?varUserFirst={!$User.FirstName}&varUserLast={!$User.LastName}
/flow/Contact_Info?collNames={!Contact.FirstName}&collNames={!Contact.LastName}
```

#### 5-d. flowLayout=twoColumn (2열 화면 — 사실상 폐기)

```
/flow/flowName?flowLayout=twoColumn
```

- 전제: Lightning runtime 활성화 (Process Automation Settings → Enable Lightning runtime for flows).
- **Winter '23부터 이 URL 커스터마이제이션을 포함한 2열 flow 레이아웃은 무시된다.** 대신 화면에 Section 컴포넌트(최대 4열 가변폭)를 쓴다.

### 6. 커스텀 Aura 컴포넌트에 임베드

flow의 데이터 입출력을 커스터마이즈하려면 커스텀 Aura 컴포넌트에 넣고, 그 컴포넌트를 커스텀 액션·Lightning 탭·Lightning 페이지로 배포한다. `lightning:flow` 컴포넌트를 추가한다:

```html
<aura:component>
    <aura:handler name="init" value="{!this}" action="{!c.init}" />
    <lightning:flow aura:id="flowData" />
</aura:component>
```

JavaScript 컨트롤러에서 시작할 flow를 지정한다:

```javascript
({
    init : function (component) {
        // Find the component whose aura:id is "flowData"
        const flow = component.find("flowData");
        // In that component, start your flow. Reference the flow's API Name.
        flow.startFlow("myFlow");
    },
})
```

> LWC 쪽 대응 컴포넌트는 [[lightning-flow]] 참조. Flow **안에서** Aura 컴포넌트를 클라이언트 액션으로 실행하는 반대 방향은 [[Aura Flow 로컬 액션 (availableForFlowActions)]] 참조.

### 7. Visualforce 페이지에 임베드

내부 사용자용으로 flow의 look & feel을 커스터마이즈. Visualforce 탭·커스텀 버튼·커스텀 링크로 배포한다. 필요 권한: Customize Application.

1. flow의 API 이름 확인 (Setup → Flows → flow 이름 클릭 → API 이름 복사)
2. Setup Quick Find에 `Visualforce Pages` → 선택
3. 새 페이지 정의 또는 기존 페이지 열기
4. `<apex:page>` 태그 사이에 `<flow:interview>` 컴포넌트 추가
5. `name` 속성 = flow API 이름:

```html
<apex:page>
    <flow:interview name="flowAPIName"/>
</apex:page>
```

managed 패키지의 flow면 `name` 속성 형식은 `namespace.flowuniquename`.

6. 저장
7. 페이지 접근 사용자 제한 — Visualforce Pages → 페이지 옆 **Security** → Available Profiles에서 Enabled Profiles로 이동 → 저장
8. 커스텀 버튼·링크·Visualforce 탭으로 앱에 추가

#### finishLocation — Visualforce에서 Finish 동작 제어

기본값: Finish 클릭 시 새 인터뷰가 시작되고 첫 화면 표시. `finishLocation` 속성으로 Salesforce 내 다른 페이지로 라우팅한다.

> **주의:**
> - **조직 외부 URL로는 리다이렉트 불가.**
> - `Auth.SessionManagement.finishLoginFlow` 메서드와 `finishLocation` 속성을 **같은 flow에서 함께 쓰지 말 것.** `finishLoginFlow`는 Visualforce 페이지 로그인 flow의 끝을 나타내는데, 같은 flow에 `finishLocation`이 있으면 **flow 시작 시점에 `finishLocation`이 실행돼 사용자에게 세션 전체 접근이 열린다.**

**① URLFOR 함수** — 상대 URL 또는 레코드 ID로 라우팅:

```html
<apex:page>
    <flow:interview name="MyUniqueFlow" finishLocation="{!URLFOR('/home/home.jsp')}"/>
</apex:page>
```

```html
<apex:page>
    <flow:interview name="MyUniqueFlow" finishLocation="{!URLFOR('/001D000000IpE9X')}"/>
</apex:page>
```

**② $Page 변수** — 다른 Visualforce 페이지로 라우팅: `{!$Page.pageName}` 형식.

```html
<apex:page>
    <flow:interview name="MyUniqueFlow" finishLocation="{!$Page.MyUniquePage}"/>
</apex:page>
```

**③ 커스텀 컨트롤러** — PDF 원문 샘플 (3가지 방식):

```apex
public class myFlowController {
    public PageReference getPageA() {
        return new PageReference('/300');
    }
    public String getPageB() {
        return '/300';
    }
    public String getPageC() {
        return '/apex/my_finish_page';
    }
}
```

```html
<apex:page controller="myFlowController">
    <h1>Congratulations!</h1> This is your new page.
    <flow:interview name="flowname" finishLocation="{!pageA}"/>
</apex:page>
```

> standard controller로 flow와 같은 페이지에 레코드를 표시하는 경우: Finish 클릭 시 `id` 쿼리 스트링 파라미터가 URL에 보존되지 않아 사용자는 **레코드 없이 첫 화면**을 본다. 필요하면 `finishLocation`으로 레코드로 되돌린다.

### 8. Paused 인터뷰 준비 (Prepare Your Org for Paused Flow Interviews)

flow interview = 실행 중인 flow 인스턴스. 한 번에 끝낼 수 없는 인터뷰를 위해 Pause 버튼, 공유 모델, 재개 컴포넌트를 준비한다.

#### 8-a. 사용자가 인터뷰를 일시정지하도록 허용

1. Setup Quick Find에 `Automation` → **Process Automation Settings** 선택
2. **Let users pause flows** 선택
3. 저장

활성화하면 화면에 **Pause 버튼이 자동 표시**된다. 필요 권한: Customize Application.

#### 8-b. 인터뷰에 레코드 컨텍스트 연결 ($Flow.CurrentRecord)

flow에서 `$Flow.CurrentRecord` 전역 변수를 설정하면 paused 인터뷰가 레코드에 연결된다 (예: Change Address flow에서 `{!recordId}`로 설정). 사용자가 인터뷰를 일시정지하거나 인터뷰가 Wait 요소를 실행하면 **FlowRecordRelation** 오브젝트를 통해 레코드와 연결된다.

1. flow 시작부에 **Assignment** 요소 추가
2. Variable = `$Flow.CurrentRecord`
3. Operator = equals
4. Value = 적절한 ID가 든 변수 (**ID 1개만** 들어 있어야 함)

#### 8-c. 사용자가 자기 paused 인터뷰를 찾게 하기

| 표면 | 방법 |
|---|---|
| Lightning Experience | Home 페이지에 **Paused Flow Interviews** 컴포넌트 추가 (Lightning App Builder의 Home 페이지 전용). 사용자가 **read 접근** 가진 인터뷰 표시 |
| Experience Builder 사이트 | 사이트 페이지에 **Paused Flows** 컴포넌트 추가 (로그인·에러 페이지 등 제외 대부분 페이지 가능). read 접근 가진 인터뷰 표시 |
| Salesforce 모바일 앱 | Lightning 앱 내비게이션 항목에 **Paused Flows** 추가 |
| Salesforce Classic | 홈 페이지 레이아웃에 **Paused Flow Interviews** 관련 목록 추가 — **본인이 일시정지한 인터뷰만** 표시 |

#### 8-d. 레코드 페이지에서 paused 인터뷰 목록 표시 (커스텀 Aura 컴포넌트)

PDF는 레코드에 연결된 paused 인터뷰를 표에 표시하고 행별 Resume/Delete 액션을 제공하는 전체 샘플(`c:interviewsByRecord` — 컴포넌트 마크업 + Apex 컨트롤러 + JS 컨트롤러 + 헬퍼 4부 구성, 인쇄 206–214쪽)을 제공한다. 핵심 Apex 컨트롤러 (PDF 원문):

```apex
public class interviewsByRecordController {
    @AuraEnabled
    public static List<FlowRecordRelation> getInterviews(Id recordId) {
        return [ SELECT
                    ParentId, Parent.InterviewLabel, Parent.PauseLabel,
                    Parent.CurrentElement, Parent.CreatedDate, Parent.Owner.Name
                 FROM FlowRecordRelation
                 WHERE RelatedRecordId = :recordId ];
    }
    @AuraEnabled
    public static FlowInterview deleteInterview(Id interviewId) {
        FlowInterview interview = [Select Id from FlowInterview Where Id = :interviewId];
        delete interview;
        return interview;
    }
}
```

동작 구조: FlowRecordRelation을 조회해 표를 채우고 → Resume 선택 시 헬퍼가 `lightning:flow` 컴포넌트를 동적 생성해 모달에 띄운 뒤 `content.resumeFlow(id)` 호출 → `onstatuschange` 이벤트의 status가 `FINISHED`를 포함하면 모달 닫기 → Delete 선택 시 위 `deleteInterview`를 호출하고 표 갱신. 전체 마크업·JS는 PDF 원문 참조.

#### 8-e. paused 인터뷰 접근 제어 (공유 모델)

기본적으로 사용자는 **edit 접근이 있는** paused 인터뷰를 재개할 수 있다. edit 접근을 제어하려면 **Flow Interview 오브젝트의 공유 모델**(OWD + 공유 규칙)을 구성한다. 에디션: Professional 이상 (Essentials 제외).

- 인터뷰의 기본 공유 모델은 **Private** — 역할 계층상 **하위 사용자로부터 edit 접근을 상속**한다. 역할 계층을 쓰면 하위 사용자가 소유하거나 edit 접근을 가진 모든 인터뷰를 재개할 수 있다.
- **CEO 역할 사용자는 조직의 모든 flow interview에 read/write 접근**을 가진다 — 인터뷰 소유자가 계층에 없어도.
- 예: 모든 상담원이 어떤 인터뷰든 재개하게 하려면 — ① 상담원을 Agents 공용 그룹에 추가 ② Flow Interview OWD는 Private 유지 ③ flow interview 공유 규칙으로 "내부 사용자 소유 인터뷰"에 대해 Agents 그룹에 read/write 부여.

#### 8-f. 공유 인터뷰 재개 제한

기본적으로 **Run Flows 권한 또는 Flow User feature license** 보유자는 edit 접근이 있는 어떤 paused 인터뷰든 재개할 수 있다. 이를 **인터뷰 소유자 본인**, 또는 **Manage Flow 권한 + 인터뷰 view 접근을 가진 관리자**로만 제한하려면:

1. Setup Quick Find에 `Automation` → **Process Automation Settings** 선택
2. **Let users resume shared flow interviews** 선택 해제
3. 저장

> flow가 "프로필/권한 집합 접근 제한 오버라이드"로 구성돼 있으면, 재개하는 사용자는 그 flow 자체에 대한 접근도 있어야 한다.

#### 8-g. paused 인터뷰 삭제

오래 실행 중이거나 paused된 인터뷰를 삭제해야 그 **flow 버전을 업데이트/삭제**할 수 있다.

1. Setup Quick Find에 `Flows` → **Flows** 선택
2. 삭제할 각 인터뷰에서 **Del** 클릭 또는 액션 메뉴에서 **Delete**

---

## 조직 외부 사용자 배포 (Distribute Flows to Users Outside Your Org)

Experience Builder 사이트, 외부 앱/페이지, **Embedded Service 배포**에 flow를 추가해 외부 사용자가 실행하게 한다 (Embedded Service는 이 챕터에서 배포 대상으로 언급만 되고 별도 절차 토픽은 없다). 외부 컨텍스트에서 flow 동작을 더 세밀하게 제어하려면 커스텀 Aura 컴포넌트 또는 Visualforce 페이지를 쓴다 — **Aura 컴포넌트의 flow는 Lightning runtime, Visualforce의 flow는 Classic runtime**. 예: 사이트 방문자가 커스텀 견적을 생성하는 셀프서비스 도구.

### Experience Builder 사이트 페이지에 Screen Flow 추가

공개 Experience Builder 웹사이트 페이지에는 **Flow 컴포넌트**로 추가한다. **미인증(unauthenticated) 방문자**가 flow를 보려면 **guest user 프로필에 접근을 부여**해야 한다. 로그인 후 보는 flow라면 프로필 권한 부여가 필요 없다. 에디션: Enterprise, Performance, Unlimited, Developer.

> Experience Builder 사이트의 flow는 **Flow와 Suggested Actions 컴포넌트**를 통해 지원된다. flow 작성자는 에러 메시지를 자체 콘텐츠로 덮어쓸 수 있다.

1. Flow Builder에서 screen flow를 만들고 **활성화**
2. Experience Builder에서 원하는 페이지 영역에 **Flow 컴포넌트** 추가
3. 속성 편집기에서 구성:
   - Flow 드롭다운에서 표시할 **활성 screen flow** 선택
   - 입력 가능 변수가 있으면 변수 필드가 표시됨 — 값 입력 또는 공란. 레코드 상세 페이지라면 record ID 입력 변수에 **Pass record ID into this variable** 선택 가능 (변수 1개에만 전달 권장)
4. 미인증 방문자가 완료해야 하는 flow면 **guest user 프로필에 flow 접근 + 사이트 접근** 부여
5. flow에 데이터 요소가 있으면 guest user 프로필에 **오브젝트 수준·필드 수준 권한**도 부여 (Setup)
6. 저장
7. Experience Builder에서 사이트를 **게시(publish)**하고 사이트에서 테스트

### 외부 사용자용 Visualforce 페이지에 임베드

flow를 Visualforce 페이지에 넣고 그 페이지를 외부(예: 커뮤니티)로 배포한다. 회사 브랜딩·스타일로 외관 커스터마이즈 가능. 필요 권한: Customize Application.

> **사이트/포털 사용자는 flow를 직접 실행할 수 없다** — flow 자체가 아니라 **flow가 임베드된 Visualforce 페이지로** 안내할 것.

절차는 내부용 Visualforce 임베드(위 7절)와 동일: API 이름 확인 → `<flow:interview name="flowAPIName"/>` (managed 패키지면 `namespace.flowuniquename`) → 저장 → **Security에서 프로필 제한** (페이지 접근 가능한 외부 사용자는 누구나 임베드된 flow를 실행할 수 있다) → Salesforce 사이트에 페이지를 추가하거나, 커스텀 Visualforce 탭으로 만들어 포털/커뮤니티에 추가.

---

## 자동화 시스템 배포 (Distribute Flows to Automated Systems) — 개요

사용자 상호작용 없이 시작하는 flow. 시스템이 자동으로 flow를 기동하게 하려면 **Apex `start` 메서드, process, workflow 액션**을 쓴다.

- 이 방법 대부분은 **autolaunched flow에만** 사용 가능. autolaunched flow는 벌크로, 사용자 상호작용 없이 실행되며 활성/최신 버전에 step·screen·choice·dynamic choice를 포함할 수 없다.
- **flow user가 기동하면 활성 버전 실행** (활성 버전이 없으면 최신 버전). **flow admin이 기동하면 항상 최신 버전 실행** — 상세는 [[Flow 버전 관리와 활성화 - 배포 수명주기]] 참조.
- Apex에서의 기동(`Flow.Interview` / `interview.start`)은 [[Flow Interview API]] 참조.

### Process에서 기동

workflow rule처럼 process는 특정 오브젝트 레코드의 생성/수정 시 시작된다. flow 액션으로 process의 기능을 확장한다.

1. process가 기동할 autolaunched flow를 만들고 **활성화**
2. flow를 기동할 process 생성
3. process에 **"Flows" 액션** 추가 — Flow에서 만든 flow를 검색·선택, 필요 시 **Add Row**로 flow 변수 값 설정
4. process 활성화

필요 권한: Manage Flow + View All Data.

### Workflow 액션(Flow Trigger)에서 기동 — 파일럿 종료

> **flow trigger workflow 액션 파일럿 프로그램은 종료(closed)됐다.** 이미 파일럿을 활성화한 조직은 flow trigger를 계속 생성·편집할 수 있다. 활성화하지 않았다면 Flow Builder로 record-triggered flow를 만들거나 Process Builder로 process에서 flow를 기동한다.

Salesforce Classic 전용. 에디션: Enterprise, Performance, Unlimited, Developer.

**Workflow rule에 flow trigger 연결:**

1. Setup Quick Find에 `Workflow Rules` → 선택
2. workflow rule 선택 → Workflow Actions 섹션에서 **Edit**
3. **Immediate Workflow Actions** 섹션에서 **Add Workflow Action > Select Existing Action** — flow trigger는 **time-dependent 액션으로는 불가, immediate 액션으로만** 추가 가능
4. Search 드롭다운에서 **Flow Trigger** 선택 → 연결할 flow trigger를 Selected Actions로 이동 → 저장

**Flow trigger 정의:**

1. Setup Quick Find에 `Flow Triggers` → 선택 → **New Flow Trigger**
2. workflow rule과 **같은 오브젝트** 선택 → Next
3. 구성:

| 필드 | 설명 |
|---|---|
| Name | flow trigger 이름 |
| Unique Name | API에서 참조하는 고유 이름. 밑줄·영숫자만, 오브젝트 타입 내 고유, 문자로 시작, 공백 불가, 밑줄로 끝나거나 연속 밑줄 불가 |
| Protected Component | Reserved for future use |
| Flow | 이 액션이 기동할 autolaunched flow의 고유 이름 |
| Set Flow Variables | flow 변수로 값을 넘길지 여부 |

4. Set Flow Variables 선택 시 변수 이름·값 지정 (**Set Another Value**로 추가)
5. 테스트 모드: **Administrators run the latest flow version** 선택 — 관리자가 rule을 트리거하면 **최신 버전**, 다른 사용자는 항상 **활성 버전**이 기동된다. 어느 쪽이든 flow 변수에는 같은 값이 전달된다
6. 저장 — workflow rule에 연결하는 것을 잊지 말 것

### REST API에서 기동

autolaunched flow를 REST API로 호출하려면 **invocable action 엔드포인트**를 쓴다. Salesforce 외부 애플리케이션이나 코드에서 flow를 실행할 수 있고, flow가 조회한 데이터를 출력 변수로 돌려받는다. PDF 원문 예 — "Escalate_to_Case" flow의 활성 버전 호출:

```
POST /services/data/v33.0/actions/custom/flow/Escalate_to_Case
```

```json
{
  "inputs" : [ {
    "CommentCount" : 6,
    "FeedItemId" : "0D5D0000000cfMY"
  } ]
}
```

요청은 flow의 입력 변수 `CommentCount`·`FeedItemId` 값을 설정한다. 상세(요청/응답 스키마 등)는 Actions Developer Guide의 Flow Actions 참조 — 이 노트는 개요 수준만 다룬다.

---

## 관련 노트

- [[Flow 버전 관리와 활성화 - 배포 수명주기]] — 활성 버전 1개 규칙·실행 컨텍스트(user/system)·런타임 비교·다른 조직으로 배포(패키지·change set)
- [[lightning-flow]] — LWC 베이스 컴포넌트로 flow 임베드
- [[Screen Flow 설계]] — Screen Flow 구조 설계 + NavigationMixin(`standard__flow`) 기동
- [[Flow Interview API]] — Apex `Flow.Interview`로 autolaunched flow 기동
- [[Aura Flow 로컬 액션 (availableForFlowActions)]] — Flow 안에서 Aura 컴포넌트를 클라이언트 액션으로 실행 (반대 방향)
- [[Flow 종류와 변수]] — processType·변수 설계 (입력 가능 변수의 전제)
