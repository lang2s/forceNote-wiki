---
tags: [aura, quick-action, publisher-api, javascript-api, case-feed, lightning-experience, salesforce-classic, visualforce]
source: case_feed_dev_guide.pdf (Publisher and Quick Action Developer Guide, Summer '26, p.5-22)
created: 2026-06-18
aliases: [Quick Action JavaScript API, Publisher JavaScript API, lightning:quickActionAPI, Sfdc.canvas.publisher, getAvailableActions, getAvailableActionFields, getCustomAction, getSelectedActions, invokeAction, selectAction, setActionFieldValues, publisher.selectAction, publisher.setActionInputValues, publisher.invokeAction, publisher.customActionMessage, publisher.refresh, Case Feed Publisher API, Case Feed JS API, Case Feed 액션 커스터마이즈, Case Feed 액션 제어, 퀵액션 JS API, 퍼블리셔 JS API, 케이스피드 액션 제어, 케이스피드 자바스크립트 API, quickActionAPI vs Apex QuickAction 차이, JS Quick Action API와 Apex QuickAction 네임스페이스 차이, Quick Action JS API와 Console JS API 차이, 퀵액션 동명이의 구분]
---

# Quick Action·Publisher JS API 레퍼런스

> 레코드 페이지의 액션(quick action / publisher action)을 커스텀 컴포넌트로 프로그래밍 제어하는 두 JavaScript API — Lightning Experience의 `lightning:quickActionAPI`와 Salesforce Classic의 `Sfdc.canvas.publisher`.

---

## 개요 — 두 JS API와 시작하기

Salesforce Classic과 Lightning Experience 앱의 페이지 **액션과 상호작용**하는 커스텀 컴포넌트를 만들 수 있다. Aura 컴포넌트, Visualforce, Apex를 사용해 케이스 피드를 포함한 앱 경험을 커스터마이즈한다. 예를 들어 커스텀 컴포넌트로 사용자가 Knowledge 아티클을 이메일로 보내게 할 수 있다.

이 가이드가 다루는 두 API:

- **Salesforce Classic Publisher JavaScript APIs** (= Case Feed Publisher APIs) — Visualforce 컴포넌트·페이지와 함께 작동하여 **publisher action**과 상호작용한다.
- **Lightning Quick Action JavaScript APIs** — `lightning:quickActionAPI` 컴포넌트가 호출하여 **quick action**과 상호작용한다.

> **Note:** Publisher API의 API 버전 **43.0부터** Visualforce 컴포넌트에서 사용하는 메서드가 Lightning Experience에서도 동작한다. Visualforce 페이지에서 Publisher API 스크립트의 최신 버전을 가리키기만 하면 된다.

이 가이드를 사용하려면 JavaScript, Visualforce, Apex, Aura 컴포넌트, Salesforce 사용자 인터페이스에 대한 기본적인 친숙함이 있으면 좋다.

**EDITIONS:**
- Available in: Salesforce Classic 및 Lightning Experience
- Available in: Group, Professional, Enterprise, Performance, Unlimited, Developer Editions

> [!important] 이 API의 invokeAction/selectAction ≠ Apex `QuickAction.performQuickAction`
> 이 노트의 `invokeAction`·`selectAction`은 **클라이언트 측 JavaScript**에서 화면에 보이는 액션을 선택·제출하는 UI 제어 API다. Apex `QuickAction.performQuickAction`(서버 측에서 quick action을 실행하는 별개의 API, 이름만 유사)과는 다르다. Apex 쪽은 [[Apex/Integration(통합)/QuickAction Namespace|QuickAction Namespace]] 참조.

> [!important] 이 API ≠ workspaceAPI/utilityBarAPI 콘솔 탭 제어
> 이 노트의 두 API는 **레코드 페이지의 액션(quick action / publisher action)** 을 제어한다. 콘솔의 탭·서브탭·유틸리티 바를 열고 닫는 신형 `lightning:workspaceAPI`·`lightning:utilityBarAPI`는 별개의 콘솔 탭 제어 API다. 콘솔 탭 제어는 [[LWC/Navigation(네비게이션)/Lightning Console JS API|Lightning Console JS API]] 참조.

---

## 두 API는 어떻게 다른가

org의 사용자 인터페이스가 어떤 개발 도구를 쓸지 결정한다. Salesforce Classic에서는 Publisher JavaScript API를 Visualforce 컴포넌트와 함께 쓰고, Lightning Experience에서는 `lightning:quickActionAPI` 컴포넌트로 Quick Action JavaScript API를 호출한다.

| 구분 | Salesforce Classic Publisher JS APIs | Lightning Quick Action JS APIs |
|---|---|---|
| **구현 방식** | Visualforce 페이지/컴포넌트에 publisher 스크립트(`/canvas/sdk/js/43.0/publisher.js`)를 로드 후 `Sfdc.canvas.publisher` 객체로 참조 | 커스텀 Aura 컴포넌트에 `lightning:quickActionAPI` 컴포넌트를 사용한 뒤 컨트롤러 코드에서 참조 |
| **지원 액션·앱·페이지** | feed-enabled 객체의 Salesforce Classic 앱 레코드 페이지의 **모든 quick action**. 표준 내비게이션·콘솔 내비게이션 앱 지원 | **모든** Lightning Experience 앱의 레코드 페이지의 **모든 quick action**. 표준 내비게이션·콘솔 내비게이션 앱 지원 |
| **제공 메서드** | `publisher.customActionMessage`, `publisher.invokeAction`, `refresh`, `publisher.selectAction`, `publisher.setActionInputValues` | `getAvailableActions`, `getAvailableActionFields`, `getCustomAction`, `getSelectedActions`, `invokeAction`, `refresh`, `selectAction`, `setActionFieldValues` |
| **LEX/Classic 지원** | Salesforce Classic **및** Lightning Experience에서 동작. **API 버전 43.0부터** Visualforce 컴포넌트·페이지의 메서드가 Lightning Experience에서 동작 (최신 버전 스크립트를 가리킬 것). 단 `portalPostFields` 입력값은 Lightning Experience에서 미지원 | **Lightning Experience에서만** 동작. 구현 전 Quick Action API Considerations 검토 필요 |

**Classic Publisher API — 43.0 스크립트 (Lightning Experience 지원):**

```html
<script
  src="/canvas/sdk/js/43.0/publisher.js"
  type="text/javascript">
</script>
```

---

## 메서드 패리티 표

Lightning Quick Action JavaScript API는 Aura 컴포넌트 내 액션과 상호작용하게 해주며, 이는 Salesforce Classic Publisher JavaScript API가 Visualforce 페이지 내 publisher action과 상호작용하게 해주는 방식과 유사하다. 아래 표는 어떤 Quick Action API 메서드가 어떤 Publisher API 메서드에 매핑되는지를 보여준다.

> 표 방향: 왼쪽 열 = Quick Action API Method (in Aura Component), 오른쪽 열 = Publisher API Method (in Visualforce). 각 행이 한 쌍의 매핑이며, 오른쪽이 `N/A`인 행은 Publisher API에 대응 메서드가 없음을 의미한다.

| Quick Action API Method (in Aura Component) | Publisher API Method (in Visualforce) |
|---|---|
| getAvailableActions | N/A |
| getAvailableActionFields | N/A |
| getCustomAction | customActionMessage |
| getSelectedActions | N/A |
| invokeAction | invokeAction |
| refresh | refresh |
| selectAction | selectAction |
| setActionFieldValues | setActionInputValues |

---

## Quick Action API (Lightning Experience)

`lightning:quickActionAPI` 컴포넌트는 레코드 페이지의 quick action을 프로그래밍 방식으로 제어하는 메서드에 접근하게 해준다. 이 컴포넌트는 Lightning Experience에서 지원되며 utility pop-out을 지원한다. **API 버전 43.0 이상**이 필요하다.

예를 들어 Knowledge 아티클을 표시하는 커스텀 Aura 컴포넌트가 있다면, `lightning:quickActionAPI` 컴포넌트로 케이스 레코드 페이지의 Email quick action을 통해 커스텀 컴포넌트에서 Knowledge 아티클을 첨부·전송할 수 있다.

이 메서드들에 접근하려면 Aura 컴포넌트나 페이지 안에 `lightning:quickActionAPI` 컴포넌트 인스턴스를 만들고 `aura:id` 속성을 부여한다.

```html
<lightning:quickActionAPI aura:id="quickActionAPI"/>
```

이 컴포넌트는 Salesforce Classic의 Publisher API와 유사한 기능을 제공한다.

**EDITIONS:**
- Available in: Lightning Experience
- Available in: Group, Professional, Enterprise, Performance, Unlimited, Developer Editions

### 통합 Sample Code

이 예제는 케이스 레코드 페이지의 Update Case quick action과 상호작용하는 버튼 두 개를 만든다. 컨트롤러 코드는 `selectAction`, `setActionFieldValues`, `invokeAction` 메서드를 사용한다.

**Component:**

```html
<aura:component implements="flexipage:availableForRecordHome" description="My Lightning Component">
    <lightning:quickActionAPI aura:id="quickActionAPI" />
    <div>
        <lightning:button label="Select Update Case Action" onclick="{!c.selectUpdateCaseAction}"/>
        <lightning:button label="Update Case Status Field" onclick="{!c.updateCaseStatusAction}"/>
    </div>
</aura:component>
```

**Controller:**

```javascript
({
    selectUpdateCaseAction : function( cmp, event, helper) {
        var actionAPI = cmp.find("quickActionAPI");
        var args = { actionName :"Case.UpdateCase" };
        actionAPI.selectAction(args).then(function(result) {
            // Action selected; show data and set field values
        }).catch(function(e) {
            if (e.errors) {
                // If the specified action isn't found on the page,
                // show an error message in the my component
            }
        });
    },

    updateCaseStatusAction : function( cmp, event, helper ) {
        var actionAPI = cmp.find("quickActionAPI");
        var fields = { Status : { value : "Closed"},
                       Subject : { value : "Sets by lightning:quickActionAPI component" },
                       accountName : { Id : "accountId" } };
        var args = { actionName : "Case.UpdateCase",
                     entityName : "Case",
                     targetFields : fields };
        actionAPI.setActionFieldValues(args).then(function() {
            actionAPI.invokeAction(args);
        }).catch(function(e) {
            console.error(e.errors);
        });
    }
})
```

### Considerations

Lightning Quick Action JavaScript API 메서드로 작업하기 전, 구현에 영향을 줄 수 있는 고려사항을 검토한다.

> [!tip] Targetable 규칙
> Lightning Quick Action JavaScript API는 페이지에서 **targetable한** quick action하고만 상호작용할 수 있다.
> - **Targetable:** highlights panel에 표시되는 액션 (dropdown action overflow 포함)
> - **Targetable:** publisher에 표시되는 액션 (More overflow 포함)
> - **Targetable:** 기본적으로 펼쳐진 accordion 컴포넌트 섹션이나 탭에 중첩된 액션
> - **Not targetable:** 기본적으로 펼쳐지지 않은 accordion 컴포넌트 섹션이나 탭에 중첩된 액션\*
>   - \*사용자가 해당 액션을 포함한 accordion 섹션이나 탭을 열면 그 액션은 targetable해진다.
>
> Lightning 앱의 커스텀 코드에서 이 API를 사용할 경우, 대상 quick action은 페이지에 보여야 한다. 페이지에 보이지 않는 액션을 대상으로 하면 실패한다.

Quick Action API는 대부분의 액션 타입과 작동한다.

> 지원 액션 타입 표 — 행 = 액션 타입. Supported? 열의 고유값은 `Yes` / `No` 두 가지.

| Action Type | Supported? | Notes |
|---|---|---|
| Create a Record | Yes | Supported in all Lightning apps, on any object. |
| Custom Visualforce | Yes | Supported in all Lightning apps, on any object.<br>**Note:** 이 액션 타입과 작업하려면 `getCustomAction` 메서드를 사용. 다른 메서드는 이 액션 타입에 미지원. |
| Flow | No | Results in error. |
| Log a Call | Yes | Supported in all Lightning apps, on any object. |
| Aura Component | Yes | Supported in all Lightning apps, on any object.<br>**Note:** 이 액션 타입과 작업하려면 `getCustomAction` 메서드를 사용. 다른 메서드는 이 액션 타입에 미지원. |
| Send Email | Yes | Supported in all Lightning apps, on any object. |
| Update a Record | Yes | Supported in all Lightning apps, on any object. |

`lightning:quickActionAPI` 컴포넌트는 utility popout을 지원한다. 단 `getCustomAction` 메서드는 아직 utility popout과 동작하지 않는다. Salesforce Classic Publisher API도 utility bar에 사용된 Visualforce 페이지에 두면 utility popout을 지원하지만, `customActionMessage`는 utility popout을 지원하지 않는다.

**미지원 항목:**
- Opportunity products
- Knowledge articles
- Service Crew 객체의 Crew Size 필드
- Social Customer Service와 함께 제공되는 케이스 피드 publisher의 Social quick action
- Experience Cloud 사이트 — `lightning:quickActionAPI` 컴포넌트는 Experience Cloud 사이트에서 동작하지 않음

### getAvailableActions

레코드 페이지에서 사용 가능한 액션 목록을 가져오는 메서드.

**Arguments:** None.

**Sample Code:**

```javascript
getAvailableActions : function( cmp, event, helper) {
        var actionAPI = cmp.find("quickActionAPI");
        actionAPI.getAvailableActions().then(function(result){
            //All available actions shown;
        }).catch(function(e){
            if(e.errors){
                //If the specified action isn't found on the page, show an error message in the my component
            }
        });
    }
```

**Response:** Promise를 반환한다. 성공 시 response 객체로 resolve되고, 오류 응답 시 reject된다.

```javascript
success: true,
actions:
    {actionName: "Case._LightningUpdateCase", recordId: "recordId", type: "QuickAction"}
    {actionName: "FeedItem.TextPost", recordId: "recordId", type: "QuickAction"}
    {actionName: "Case.LogACall", recordId: "recordId", type: "QuickAction"}
    {actionName: "Case.SendEmail", recordId: "recordId", type: "QuickAction"}
errors: []
```

### getAvailableActionFields

레코드 페이지의 특정 액션에 사용 가능한 필드 목록을 가져오는 메서드.

**Arguments:**

| Name | Type | Description |
|---|---|---|
| actionName | string | The name of the quick action that you want to access. |

`actionName` 파라미터는 Salesforce 객체로 시작해 quick action 이름이 뒤따른다. 예:

```javascript
actionName: "Case.LogACall"
```

**Sample Code:**

```javascript
getAvailableActionFields : function( cmp, event, helper) {
        var actionAPI = cmp.find("quickActionAPI");
        var args = {actionName :"Case.LogACall", entityName:"Case" };
        actionAPI.getAvailableActionFields(args).then(function(result){
            //All available action fields shown for Log a Call
        }).catch(function(e){
            if(e.errors){
                //If the specified action isn't found on the page, show an error message in the my component
            }
        });
    }
```

**Response:** Promise를 반환한다. 성공 시 response 객체로 resolve되고, 오류 응답 시 reject된다.

```javascript
success: true,
fields:
    {fieldName: "Subject", type: "textEnumLookup"}
    {fieldName: "Description", type: "TextArea"}
    {fieldName: "WhoId", type: "Lookup"},
errors: []
```

### getCustomAction

커스텀 quick action에 접근하여 데이터나 메시지를 전달하는 메서드.

**Arguments:**

| Name | Type | Description |
|---|---|---|
| actionName | string | The name of the quick action that you want to access. |

`actionName` 파라미터는 Salesforce 객체로 시작해 quick action 이름이 뒤따른다. 예:

```javascript
actionName: "Case.MyCustomAction"
```

**Sample Code:**

```javascript
actionApi.getCustomAction(args).then(function(customAction) {
  if (customAction) {
    customAction.subscribe(function(data) {
      // Handle quick action message
    });
    customAction.publish({
      message : "Hello Custom Action",
      Param1 : "This is a parameter"
    });
  }
}).catch(function(error) {
  // We can't find that custom action.
});
```

**Response:** Promise를 반환한다. 성공 시 response 객체로 resolve되고, 오류 응답 시 reject된다.

```javascript
success: boolean,
customAction: {
  subscribe: function,
  publish: function,
  unsubscribe: function
},
unavailableAction: boolean,
errors: []
```

### getSelectedActions

레코드 페이지에서 선택된 quick action에 접근하는 메서드.

**Arguments:** None.

**Response:** Promise를 반환한다. 성공 시 response 객체로 resolve되고, 오류 응답 시 reject된다.

```javascript
success: boolean,
actions: [ {
    actionName: "UpdateCase",
    recordId: "recordId",
    type: "QuickAction"
} ],
errors: []
```

### invokeAction

레코드 페이지의 quick action을 저장 또는 제출하는 메서드.

**Arguments:**

| Name | Type | Description |
|---|---|---|
| actionName | string | The name of the quick action that you want to access. |

`actionName` 파라미터는 Salesforce 객체로 시작해 quick action 이름이 뒤따른다. 예:

```javascript
actionName: "Case.UpdateCase"
```

**Response:** Promise를 반환한다. 성공 시 response 객체로 resolve되고, 오류 응답 시 reject된다.

> PDF에 invokeAction의 응답 객체 예시 없음 — 위 한 줄 설명 외 별도 응답 객체 코드 예시는 원문에 없으므로 재현하지 않는다.

### refresh

현재 레코드 페이지를 새로 고친다.

**Arguments:** None.

> PDF에 Quick Action API 쪽 refresh의 Sample/Response 예시 없음 — 재현하지 않는다. (Classic 쪽 `publisher.refresh`는 Use Case 예제가 있으며 아래 별도 섹션 참조.)

### selectAction

레코드 페이지의 quick action을 선택하고 포커스를 맞추는 메서드.

**Arguments:**

| Name | Type | Description |
|---|---|---|
| actionName | string | The name of the quick action that you want to access. |

`actionName` 파라미터는 Salesforce 객체로 시작해 quick action 이름이 뒤따른다. 예:

```javascript
actionName: "Case.UpdateCase"
```

**Response:** Promise를 반환한다. 성공 시 response 객체로 resolve되고, 오류 응답 시 reject된다.

```javascript
success: boolean,
unavailableAction: boolean,
targetableFields: [{
    fieldName: "Status",
    type: "PickList"
}],
actionName: string,
errors: []
```

### setActionFieldValues

레코드 페이지의 quick action을 선택한 뒤 그 액션의 필드 값을 지정하는 메서드. 이 메서드가 quick action도 선택하므로 `selectAction` 메서드를 따로 쓸 필요가 없다. quick action 업데이트를 제출하려면 `submitOnSuccess`를 true로 전달한다.

**Arguments:**

| Name | Type | Description |
|---|---|---|
| actionName | string | The name of the quick action that you want to access. |
| parentFields | Object | Optional. The fields that you want to update on the current record. For example, if you want to set field values on the Email quick action on the case record page, the case object is the parent record. |
| targetFields | Object | The fields that you want to update on the quick action. |
| submitOnSuccess | boolean | Optional. Set to true if you want to save and submit the quick action after setting the field values. Default is false. |

`actionName` 파라미터는 Salesforce 객체로 시작해 quick action 이름이 뒤따른다. 예:

```javascript
actionName: "Case.UpdateCase"
```

`parentFields`와 `targetFields` 객체는 각 필드의 이름과 값 목록을 담는다. 각 필드는 `insertType` 키로 삽입 동작을 선택적으로 지정할 수 있으며, 값은 `replace`(기본값), `cursor`, `begin` 중 하나다. 예:

```javascript
var parentFields = { Status: {value: "Closed"},
                     Subject: {value: "Case subject", insertType: "cursor"} }
var targetFields = { ToAddress: {value: "to@to.com"},
                     TextBody: {value: "the text body", insertType: "cursor"} }
```

다음 항목에는 이 API 사용을 권장하지 않는다:
- Read-only fields
- Encrypted fields
- Fields within social actions

**Response:** Promise를 반환한다. 성공 시 response 객체로 resolve되고, 오류 응답 시 reject된다.

```javascript
success: boolean,
actionName: "LogACall",
unavailableAction: boolean,
targetFieldErrors: [{
  Status: {message: "error"},
  Subject: {message: "error",
}],
errors: []
```

---

## Publisher API (Salesforce Classic)

Salesforce Classic Publisher JavaScript API는 Visualforce 페이지·컴포넌트가 feed-enabled 객체의 Salesforce Classic 앱 레코드 페이지에 추가한 액션과 상호작용하게 해준다. 이 API는 표준 내비게이션과 콘솔 내비게이션을 가진 Salesforce Classic 앱에서 동작한다. 예를 들어 커스터마이즈된 사전 작성 텍스트를 생성해 Case Feed portal action의 새 게시물에 추가하고 그 게시물을 한 번의 클릭으로 포털에 제출하는 컴포넌트를 개발할 수 있다.

콘솔 컴포넌트가 quick action과 상호작용하게 하려면 `Sfdc.canvas.publisher` 객체의 `publish` 메서드를 사용한다.

**EDITIONS:**
- Available in: Salesforce Classic (not available in all orgs)
- Available in: Enterprise, Performance, Unlimited, Developer Editions

> [!tip] 43.0 버전부터 Lightning Experience 지원
> Salesforce Classic JavaScript Publisher API의 **API 버전 43.0부터** Visualforce 컴포넌트의 메서드가 Lightning Experience에서 동작한다. 커스텀 quick action을 통하거나 Lightning App Builder로 페이지에 추가하여 Visualforce 페이지를 Lightning Experience에서 사용할 수 있다. Visualforce 페이지에서 43.0 버전의 Publisher API 스크립트를 가리키기만 하면 된다.
>
> ```html
> <script src="/canvas/sdk/js/43.0/publisher.js" type="text/javascript"></script>
> ```
>
> Lightning 앱의 커스텀 코드에서 JavaScript Publisher API 메서드를 사용할 경우, 대상 quick action은 페이지에 보여야 한다. 페이지에 보이지 않는 액션을 대상으로 하면 실패한다.

### publisher.selectAction

| Description | Payload Values | Available Versions |
|---|---|---|
| Selects the specified action and puts it in focus. | `actionName`—선택할 액션. 지원값:<br>• `action_name`–create, log a call, 또는 custom Visualforce quick action. 예: create contact 액션의 action_name은 `create_contact`<br>• `Case.CaseComment`—Case Feed portal action<br>• `Case.ChangeStatus`—Case Feed change status action<br>• `Case.Email`—Case Feed email action<br>• `Case.LogACall`—Case Feed log a call action<br>• `FeedItem.TextPost`—Standard Chatter post action (API 32.0 이상)<br>• `SocialPostAPIName.SocialPost`—Social post action (API 32.0 이상) | Available in API versions 29.0 and later. |

**Code Sample** — email action을 선택하고 포커스를 맞춘다.

```javascript
Sfdc.canvas.publisher.publish({name:"publisher.selectAction",payload:{actionName:"Case.Email"}});
```

### publisher.setActionInputValues

| Description | Payload Values | Available Versions |
|---|---|---|
| Specifies which fields on the action should be populated with specific values, and what those values are. | `actionName`—채울 필드가 있는 액션. 사용 가능한 필드값은 지정한 액션에 따라 다름.<br><br>• `emailFields`–`Case.Email`에서 사용. Case Feed email action의 표준 필드:<br>– `to`<br>– `cc`<br>– `bcc`<br>– `subject`<br>– `body`<br>– `template`<br><br>• `portalPostFields`–`Case.CaseComment`에서 사용. Case Feed portal action의 표준 필드:<br>– `body`<br>– `sendEmail` (boolean)<br><br>• `targetFields`–`Case.ChangeStatus`, `Case.LogACall`, `FeedItem.TextPost`, Social action에서 사용. 해당 액션의 표준 필드.<br>– `Case.ChangeStatus`: `commentBody`<br>– `Case.LogACall`: `description`<br>– `FeedItem.TextPost`: `body` — body의 속성은 `value`와 `insertType`(선택). insertType의 유효값은 `begin`, `end`, `cursor`, `replace`. 기본값은 `replace`. (API 32.0 이상)<br>– `SocialPostAPIName.SocialPost`: `content`와 `insertType`(선택). insertType 유효값은 `begin`, `end`, `cursor`, `replace`. 기본값은 `replace`. (API 32.0 이상)<br><br>• `parentFields`—`Case.ChangeStatus`, `Case.Email`, `Case.LogACall`에서 사용. case의 표준·커스텀 필드. Lookup 필드는 미지원. | Available in API versions 29.0 and later. |

**Code Sample (예제 1)** — 이메일 메시지 필드를 사전 정의값으로 채우고 관련 case의 상태를 Closed로 설정.

```javascript
Sfdc.canvas.publisher.publish({name:"publisher.setActionInputValues",
    payload:{actionName:"Case.Email",parentFields: {Status:{value:"Closed"}},
    emailFields: {to:{value:"customer@company.com"},cc:{value:"customer2@company.com"},
    bcc:{value:"supervisor@company.com"},
    subject:{value:"Your Issue Has Been Resolved"},
    body:{value:"Thank you for working with our support department.
        We've resolved your issue and have closed this ticket, but
        please feel free to contact us at any time if you encounter this
        problem again or need other assistance."}}}});
```

**Code Sample (예제 2)** — Post action의 body에서 현재 커서 위치에 "Hello World"를 삽입.

```javascript
Sfdc.canvas.publisher.publish({name:"publisher.setActionInputValues",
payload:{actionName:"FeedItem.TextPost", targetFields:{body:{value:"Hello World",
insertType:"cursor"}}}});
```

### publisher.invokeAction

| Description | Payload Values | Available Versions |
|---|---|---|
| Triggers the submit function (such as sending an email or posting a portal comment) on the specified action. | `actionName`—submit 함수를 트리거할 액션. 지원 액션:<br>• `Case.Email`<br>• `Case.CaseComment`<br>• `Case.ChangeStatus`<br>• `Case.LogACall`<br>• `FeedItem.TextPost` (API 32.0 이상)<br>• `SocialPostAPIName.SocialPost` (API 32.0 이상) | Available in API versions 29.0 and later. |

**Code Sample** — email action의 submit 함수를 트리거하여 이메일을 보내고 관련 feed item을 생성.

```javascript
Sfdc.canvas.publisher.publish({name:"publisher.invokeAction",
payload:{actionName:"Case.Email"}});
```

### publisher.customActionMessage

| Description | Payload Values | Available Versions |
|---|---|---|
| Passes a custom event to a custom action. Supported for Visualforce-based custom actions only. | `actionName`—이벤트를 전달할 Visualforce custom action.<br>`message`–custom action에 전달할 이벤트. | Available in API versions 29.0 and later. |

**Code Sample (publish)** — Hello world 이벤트를 my_custom_action에 전달.

```javascript
Sfdc.canvas.publisher.publish({name:"publisher.customActionMessage",
payload:{actionName:"my_custom_action", message:"Hello world"}});
```

**Code Sample (subscribe)** — my_custom_action이 Hello world 이벤트를 수신.

```javascript
Sfdc.canvas.publisher.subscribe([{name : "publisher.customActionMessage", onData :
function(e) {alert(e.message);}}]);
```

### publisher.refresh

현재 레코드 페이지를 새로 고친다. 이 메서드는 인수가 없다.

**Use Case** — Universal Cable은 미국 전역의 수백만 전화·케이블 고객을 서비스하며, 다양한 규모의 콜센터에 4,000명의 지원 상담원이 있다. Universal은 상담원이 Salesforce Knowledge의 방대한 아티클 모음에 쉽게 접근하고 이를 이메일로 고객과 공유해 지원 비용을 억제하길 원했다. Universal은 publish 시의 events를 사용해 다음을 하는 커스텀 콘솔 컴포넌트를 만들었다:

- 가장 최근 게시된 것부터 오래된 순으로 Knowledge 아티클 목록을 표시.
- 상담원이 제목을 클릭해 아티클을 볼 수 있게 함.
- 콘솔 컴포넌트의 Email 버튼을 클릭하면 아티클의 전체 서식 텍스트를 Case Feed email action의 메시지에 추가.

> 시각 자료: PDF p.21에 이 use case의 콘솔 컴포넌트 스크린샷이 있으나 캡션 텍스트가 없는 순수 이미지다. 본문 미추출 — 스크린샷 재현하지 않는다. 위 불릿 설명으로 동작은 충분히 설명된다.
>
> (참고: scout가 언급한 "events on publish를 사용한 커스텀 콘솔 컴포넌트" 예제는 별도의 Events 표·목록 섹션이 아니라 곧 이 `publisher.refresh`의 use case 예제다.)

**KBController (Apex custom controller)** — 아래 Visualforce 페이지가 사용하는 커스텀 컨트롤러.

```apex
public with sharing class KBController {
   public List<FAQ__kav> articles {get; set;}

       public KBController() {
         articles = [select knowledgearticleid, id, title, content__c from FAQ__kav where
          publishstatus = 'Online' and language='en_US' order by lastpublisheddate];
     }
}
```

**Visualforce 페이지 (커스텀 콘솔 컴포넌트)** — 위 use case의 콘솔 컴포넌트로 사용되는 VF 페이지.

```html
<apex:page sidebar="false" controller="KBController">
   <script type='text/javascript' src='/canvas/sdk/js/publisher.js'/>
   <style>
      .sampleTitle { background-color: #99A3AC;color:#FFFFFF;font-size:1.1em;
      font-weight: bold;padding:3px 6px 3px 6px; }
      .sampleHeader { }
      .sampleArticleList { min-width: 250px; padding: 8px 0 5px 0;}
      .sampleUl { padding: 0; margin: 0; list-style: none;}
      .sampleLi { display: block; position: relative; margin: 0;}
      .sampleRow { min-height: 16px; padding: 4px 10px;}
      .emailBtn { margin: 1px 1px 1px 3px; padding: 3px 8px; color: #333;
        border: 1px solid #b5b5b5; border-bottom-color: #7f7f7f; background: #e8e8e9;
        font-weight: bold; font-size: .9em; -moz-border-radius: 3px;
        -webkit-border-radius: 3px; order-radius: 3px; }
     .emailBtn:active { background-position: right -60px; border-color: #585858;
        border-bottom-color: #939393; }
     .sampleArticle { padding-left: 4px; padding-bottom: 2px; font-weight: bold;
        font-size: 1em; color: #222; }
     .sampleLink { color: #015ba7; text-decoration: none; font-weight: bold;
        font-size: .9em; }
  </style>
  <script>
     function emailArticle(content) {
        Sfdc.canvas.publisher.publish({name: 'publisher.selectAction',
        payload: { actionName: 'Case.Email'}});
        Sfdc.canvas.publisher.publish({name: 'publisher.setActionInputValues',
        payload: {
           actionName: 'Case.Email',
           emailFields: { body: { value:content, format:'richtext', insert: true}}
        }});
    }
  </script>
  <div style="margin-left:-10px;margin-right:-10px;">
     <div class="sampleTitle">Latest Articles</div>
     <div class="sampleHeader" style=""></div>
     <div class="sampleArticleList">
        <apex:repeat value="{!articles}" var="article">
           <ul class="sampleUl">
              <li class="sampleLi">
                 <div class="sampleRow">
                 <div style="display:none;" id="content_{!article.id}">
                    <apex:outputText value="{!article.content__c}" escape="false"/>
                 </div>
                   <input type="button" title="Email" value="Email" class="emailBtn"
                      onclick="emailArticle(document.getElementById
                         ('content_{!article.id}').innerHTML);"/>
                         <span class="sampleArticle">
                             <a href="/{!article.knowledgearticleid}"
                                 title="{!article.title}" class="sampleLink">
                                {!article.title}</a>
                         </span>
                </div>
             </li>
          </ul>
       </apex:repeat>
    </div>
 </div>
</apex:page>
```

---

## 관련 노트
- [[Apex/Integration(통합)/QuickAction Namespace|QuickAction Namespace]] — Apex `QuickAction.performQuickAction`은 별개 API(이름만 유사). 서버 측 quick action 실행 담당.
- [[LWC/Navigation(네비게이션)/Lightning Console JS API|Lightning Console JS API]] — `workspaceAPI`/`utilityBarAPI`는 별개의 신형 콘솔 탭 제어 API.
- [[Aura(오라)/Case Feed Visualforce 커스터마이즈|Case Feed Visualforce 커스터마이즈]] — 이 Publisher API를 사용하는 Case Feed VF 컴포넌트 커스터마이즈.
- [[Service(서비스)/Knowledge(지식)/Lightning Knowledge 사용 — 액션·검색·스마트링크·채널|Lightning Knowledge 사용 — 액션·검색·스마트링크·채널]] — Knowledge 아티클을 이메일로 첨부하는 use case 맥락.
- [[Tooling API 객체 — UI·레이아웃 (페이지·액션·탭)]] — 퀵액션의 서버측 정의(QuickActionDefinition·QuickActionList·QuickActionListItem Tooling sObject). 이 Publisher/퀵액션 JS API의 런타임 짝.
