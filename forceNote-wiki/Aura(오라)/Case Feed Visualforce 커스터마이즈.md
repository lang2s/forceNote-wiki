---
tags: [aura, visualforce, case-feed, service-cloud, salesforce-classic, console, apex-controller, emailPublisher, caseArticles]
source: case_feed_dev_guide.pdf (Publisher and Quick Action Developer Guide, Summer '26, p.23-45)
created: 2026-06-18
aliases: [Case Feed Visualforce, Case Feed VF 컴포넌트, Case Feed 페이지 커스터마이즈, Case Feed 컴포넌트 속성, apex:emailPublisher, apex:logCallPublisher, support:portalPublisher, support:caseArticles, support:CaseFeed, chatter:feed, Customize Case Feed Actions, Replicate Case Feed Page, Custom Case Feed Action, 케이스피드 커스터마이즈, 케이스피드 VF 컴포넌트, 케이스 피드 화면 만들기, 이메일 액션 커스터마이즈, Log a Call 액션, 아티클 툴, Article Tool, 표준 케이스피드 복제, VF 커스텀 액션, 케이스피드 컴포넌트 속성 어디 있나]
---

# Case Feed Visualforce 커스터마이즈

> Salesforce가 제공하는 Case Feed Visualforce 컴포넌트(`apex:emailPublisher`·`support:portalPublisher`·`apex:logCallPublisher`·`support:caseArticles`·`support:CaseFeed`)로 Salesforce Classic 콘솔 앱의 Case Feed 페이지를 커스터마이즈한다.

---

## 개요

Salesforce가 제공하는 Case Feed Visualforce 컴포넌트로 Salesforce Classic 앱 내에 커스터마이즈된 페이지를 만들 수 있다. Case Feed 액션과 상호작용하는 커스텀 Salesforce 콘솔 컴포넌트를 만들려면 Salesforce Classic Publisher JavaScript API의 `Sfdc.canvas.publisher` 객체의 `publish` 메서드를 사용해 Case Feed 관련 이벤트를 발행한다.

> [!important] Salesforce Classic 권장
> 이 가이드 섹션은 Salesforce Classic 콘솔 앱에서의 Case Feed 커스터마이즈에 초점을 둔다. 단 case 객체를 사용하는 표준 내비게이션 Salesforce Classic 앱에서도 이 Visualforce 컴포넌트를 사용할 수 있다. Lightning Experience에서도 Case Feed Visualforce 컴포넌트를 사용할 수 있으나 특정 Visualforce 컴포넌트의 refresh에 일부 문제가 있다. **이 컴포넌트들은 Salesforce Classic에서만 사용하는 것을 권장한다.**

### Requirements

Salesforce 콘솔에서 Case Feed를 커스터마이즈하기 전에 다음을 확인한다:
- org에서 Case Feed, Chatter, case의 feed tracking이 활성화되어 있어야 한다.
- org에 최소 하나의 Salesforce 콘솔 앱이 있어야 한다. (자세한 내용은 Salesforce Help의 "Set Up a Salesforce Console App in Salesforce Classic" 참조)
- Visualforce 개발에 익숙해야 한다. (전반적 개요는 Visualforce Developer Guide 참조)

> **Note:** Lookup field filters는 어떤 Case Feed Visualforce 컴포넌트에서도 지원되지 않는다.

### Assigning Custom Pages to Users

일반적으로 Visualforce로 커스텀 Case Feed 페이지를 만들면, 특정 사용자에게만 그 페이지를 할당하면서 다른 사용자에게는 표준 Case Feed 페이지를 보여주는 것은 불가능하다. 그러나 `support:CaseFeed` 컴포넌트를 사용하면 표준 Case Feed 페이지를 복제한 페이지를 만들어 특정 사용자에게 할당하고, 다른 사용자 그룹에는 커스텀 페이지를 할당할 수 있다. (자세한 내용은 아래 "표준 Case Feed 페이지 복제" 참조)

### Customization Overview

| Component Name | Description |
|---|---|
| apex:emailPublisher | Case Feed Email action의 외관과 기능을 표시·제어. |
| apex:logCallPublisher | Case Feed Log a Call action의 외관과 기능을 표시·제어. |
| support:caseArticles | case의 Articles tool의 외관과 기능을 표시·제어. |
| support:CaseFeed | 모든 표준 액션·링크·버튼을 포함한 표준 Case Feed 페이지를 복제. |
| support:portalPublisher | Case Feed Portal action의 외관과 기능을 표시·제어. |

추가로 `chatter:feed` 컴포넌트에 Case Feed 관련 속성 두 개가 있다:
- `feedItemType`: feed item이 어떻게 필터링되는지 지정.
- `showPublisher`: 페이지에 Chatter publisher를 표시.

### Publisher JavaScript API 메서드 (요약)

Case Feed 관련 이벤트는 `Sfdc.canvas.publisher`의 `publish` 메서드로 발행한다. 메서드 요약:

| Method Name | Description |
|---|---|
| customActionMessage | custom action에 커스텀 이벤트 전달 (Visualforce 기반 custom action 전용). |
| invokeAction | 지정 액션의 submit 함수 트리거 (이메일 전송·포털 댓글 게시 등). |
| selectAction | 지정 액션을 선택하고 포커스. |
| refresh | 현재 레코드 페이지 새로고침. |
| setActionInputValues | 액션 필드를 특정 값으로 채움. |

> 각 메서드의 Payload·버전·코드 샘플 상세는 [[Aura(오라)/Quick Action·Publisher JS API 레퍼런스|Quick Action·Publisher JS API 레퍼런스]] 참조. (이 노트에서는 반복하지 않는다.)

---

## Layout·Appearance 커스터마이즈

Visualforce로 커스터마이즈된 Case Feed 페이지를 만들면 어떤 액션·툴이 어디에 표시되는지를 포함한 전체 레이아웃과 외관을 제어할 수 있다. 다른 표준·커스텀 콘솔 컴포넌트를 포함해 페이지 기능을 강화할 수도 있다. 이 가이드에서 다루는 4개의 case 전용 Visualforce 컴포넌트 외에도 `chatter:feed` 컴포넌트로 Case Feed를 커스터마이즈할 수 있다.

### chatter:feed 속성

| Attribute Name | Attribute Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| entityId | id | Entity ID of the record for which to display the feed; for example, Contact.Id | Yes | 25.0 | |
| feedItemType | String | The feed item type on which the Entity or UserProfileFeed is filtered. See the Type field on the FeedItem object listing in the API Object Reference Guide for accepted values. | | 25.0 | |
| id | String | An identifier that allows the component to be referenced by other components on the page. | | 20.0 | global |
| onComplete | String | The Javascript function to call after a post or comment is added to the feed | | 25.0 | |
| rendered | Boolean | A Boolean value that specifies whether the additional fields defined in the action layout are displayed. | | 20.0 | global |
| reRender | Object | The ID of one or more components that are redrawn when the result of the action method returns to the client. This value can be a single ID, a comma-separated list of IDs, or a merge field expression for a list or collection of IDs. | | 25.0 | |
| showPublisher | Boolean | Displays the Chatter publisher. | | 25.0 | |

### Use Case

Acme Entertainment은 여러 플랫폼에서 백만 명 이상이 사용하는 온라인 게임을 만든다. Acme의 1,500명 지원 상담원은 데스크톱·노트북·태블릿을 사용하며, 회사는 여러 기기에서 일관된 룩앤필을 위해 Case Feed 페이지를 커스터마이즈하길 원했다. 또한 필터로 case 활동을 추적하기 쉽게 하고 싶었다. Acme는 다음 단계로 커스터마이즈된 Case Feed 페이지를 만들었다:

1. `chatter:feed` 컴포넌트로 feed를 사이드바에 배치해 publisher와 다른 Case Feed 툴이 항상 페이지 중앙에 오게 함.
2. feed 필터를 재배치하고 case origin에 따라 기본 필터를 자동 선택:
   - case origin이 email이면 기본 필터는 Emails.
   - case origin이 phone이면 기본 필터는 Call Logs.
   - case origin이 Web이면 기본 필터는 Portal Answers.
3. `apex:emailPublisher`, `apex:logCallPublisher`, `support:portalPublisher`에서 width를 백분율 기반으로 만들어 페이지 크기에 따라 publisher가 늘어나고 줄어들게 함 — 다양한 화면 크기에서 외관 일관성 향상.
4. publisher action 탭의 방향을 표준 좌측 세로 배열에서 페이지 상단의 가로 배열로 변경.

> 시각 자료: PDF p.25에 스크린샷이 있으나 캡션 없는 순수 이미지다. 본문 미추출 — 재현하지 않는다. 위 use case 텍스트로 설명은 충분하다.

### Code Sample — VF 페이지 (커스텀 탭)

커스텀 Email, Portal, Log a Call, Case Details 탭이 있는 Visualforce 페이지.

```html
<apex:page standardController="Case">

     <!-- Repositions publisher tabs to a horizontal arrangement on top of the page -->
     <ul class="demoNav" style="list-style: none; overflow: hidden">
         <li style="float:left">
             <a id="custom_email_tab" class="selected" href="javascript:void(0);"
                 onclick="getDemoSidebarMenu().selectMenuItem('custom_email_tab');">
                 <span class="menuItem">Email Customer</span>
             </a>
         </li>
         <li style="float:left">
             <a id="custom_log_call_tab" href="javascript:void(0);"
                 onclick="getDemoSidebarMenu().selectMenuItem('custom_log_call_tab');">
                 <span class="menuItem">Log Call</span>
             </a>
         </li>
         <li style="float:left">
             <a id="custom_portal_tab" href="javascript:void(0);"
                 onclick="getDemoSidebarMenu().selectMenuItem('custom_portal_tab');">
                 <span class="menuItem">Portal Answer</span>
             </a>
          </li>
         <li style="float:left">
             <a id="custom_detail_tab" href="javascript:void(0);"
                 onclick="getDemoSidebarMenu().selectMenuItem('custom_detail_tab');">
                 <span class="menuItem">Case Details</span>
             </a>
         </li>
     </ul>

     <!-- Email action -->
     <div id="custom_email_pub_vf">
         <apex:emailPublisher entityId="{!case.id}"
              width="80%"
              emailBodyHeight="10em"
              showAdditionalFields="false"
              enableQuickText="true"
              toAddresses="{!case.contact.email}"
              toVisibility="readOnly"
              fromAddresses="support@cirrus.com"
              onSubmitSuccess="refreshFeed();" />
     </div>

     <!-- Log call action -->
     <div id="custom_log_call_vf" style="display:none">
         <apex:logCallPublisher entityId="{!case.id}"
             width="80%"
             logCallBodyHeight="10em"
             reRender="demoFeed"
             onSubmitSuccess="refreshFeed();" />
     </div>

     <!-- Portal action -->
     <div id="custom_portal_vf" style="display:none">
         <support:portalPublisher entityId="{!case.id}"
             width="80%"
             answerBodyHeight="10em"
             reRender="demoFeed"
             answerBody="Dear {!Case.Contact.FirstName},
                 \n\nHere is the solution to your case.\n\nBest regards,\n\nSupport"
             onSubmitSuccess="refreshFeed();" />
     </div>

     <!-- Case detail page -->
     <div id="custom_detail_vf" style="display:none">
         <apex:detail inlineEdit="true" relatedList="true" rerender="demoFeed" />
     </div>

     <!-- Include library for using service desk console API -->
     <apex:includeScript value="/support/console/25.0/integration.js"/>

     <!-- Javascript for switching publishers -->
     <script type="text/javascript">
         function DemoSidebarMenu() {
             var menus = {"custom_email_tab" : "custom_email_pub_vf",
                          "custom_log_call_tab" : "custom_log_call_vf",
                          "custom_portal_tab" : "custom_portal_vf",
                          "custom_detail_tab" : "custom_detail_vf"};

               this.selectMenuItem = function(tabId) {
                   for (var index in menus) {
                       var tabEl = document.getElementById(index);
                       var vfEl = document.getElementById(menus[index]);

                          if (index == tabId) {
                              tabEl.className = "selected";
                              vfEl.style.display = "block";
                          } else {
                              tabEl.className = "";
                              vfEl.style.display = "none";
                          }
                      }
                 };
         }
         var demoSidebarMenu;
         var getDemoSidebarMenu = function() {
             if (!demoSidebarMenu) {
                 demoSidebarMenu = new DemoSidebarMenu();
             }
             return demoSidebarMenu;
         };
     </script>

     <!-- Javascript for firing event to refresh feed in the sidebar -->
     <script type="text/javascript">
         function refreshFeed() {
             sforce.console.fireEvent
                 ('Cirrus.samplePublisherVFPage.RefreshFeedEvent', null, null);
         }
     </script>
</apex:page>
```

### MyCaseExtension (Apex 컨트롤러 확장)

위 Visualforce 페이지와 함께 사용하는 컨트롤러 확장.

```apex
public class MyCaseExtension {
    private final Case mycase;
    private String curFilter;

     public MyCaseExtension(ApexPages.StandardController stdController) {
         this.mycase = (Case)stdController.getRecord();

           // initialize feed filter based on case origin
           if (this.mycase.origin.equals('Email')) {
               curFilter = 'EmailMessageEvent';
           } else if (this.mycase.origin.equals('Phone')) {
               curFilter = 'CallLogPost';
           } else if (this.mycase.origin.equals('Web')) {
               curFilter = 'CaseCommentPost';
           }
     }

     public String getCurFilter() {
         return curFilter;
     }

     public void setCurFilter(String c) {
         if (c.equals('All')) {
             curFilter = null;
         } else {
             curFilter = c;
         }
     }

     public PageReference refreshFeed() {
         return null;
     }
}
```

### VF 페이지 — 사이드바 필터 + Chatter feed

커스텀 feed 필터와 case용 Chatter feed가 있는 Visualforce 페이지. Salesforce 콘솔 사이드바에 사용할 수 있다.

```html
<apex:page standardController="Case" extensions="MyCaseExtension">

     <!-- Feed filter -->
     <div>
         <span>Feed Filters:</span>
         <select onchange="changeFilter(this.options[selectedIndex].value);"
             id="custom_filterSelect">
             <option value="All" id="custom_all_option">All</option>
             <option value="EmailMessageEvent"
                 id="custom_email_option">Emails</option>
             <option value="CaseCommentPost"
                 id="custom_web_option">Portal Answers</option>
             <option value="CallLogPost"
                 id="custom_phone_option">Call Logs</option>
         </select>
     </div>

     <apex:form >
         <!-- actionFunction for refreshing feed when the feed filter is updated -->
         <apex:actionFunction action="{!refreshFeed}" name="changeFilter"
             reRender="custom_demoFeed" immediate="true" >
             <apex:param name="firstParam" assignTo="{!curFilter}" value="" />
         </apex:actionFunction>

         <!-- actionFunction for refreshing feed when there is an event fired for
             updating the feed -->
         <apex:actionFunction action="{!refreshFeed}" name="updateFeed"
             reRender="custom_demoFeed" immediate="true" />
     </apex:form>

     <!-- Chatter feed -->
     <chatter:feed entityId="{!case.id}" showPublisher="false"
         feedItemType="{!curFilter}" id="custom_demoFeed" />

     <!-- Include library for using service desk console API -->
     <apex:includeScript value="/support/console/25.0/integration.js"/>

     <!-- Javascript for adding event listener for refreshing feed -->
     <script type="text/javascript">

          var listener = function (result) {
              updateFeed();
          };

         // add a listener for the 'Cirrus.samplePublisherVFPage.RefreshFeedEvent'
             event type
         sforce.console.addEventListener('Cirrus.samplePublisherVFPage.RefreshFeedEvent',
             listener);
     </script>

     <!-- Javascript for initializing select option based on case origin -->
     <script type="text/javascript">
         window.onload = function() {
             var caseOrigin = "{!case.origin}";
             if (!caseOrigin) {
                 caseOrigin = "all";
             } else {
                 caseOrigin = caseOrigin.toLowerCase();
             }
             var selectElem = document.getElementById('custom_' + caseOrigin + '_option');

               if (selectElem) {
                   selectElem.selected = true;
               }
         }
     </script>

</apex:page>
```

---

## Email 액션 (apex:emailPublisher)

Case Feed의 Email action은 상담원이 이메일로 고객과 소통하게 해준다. `apex:emailPublisher` 컴포넌트로 다음을 할 수 있다:
- Email action의 크기 커스터마이즈.
- 필드의 기본값과 가시성 정의.
- send 버튼의 가시성과 레이블 정의.
- onSubmit 기능 정의.
- 액션 내 이메일 템플릿과 첨부 지원.

> **Note:** `apex:emailPublisher` 컴포넌트는 Email-to-Case 인바운드 이메일이 생성한 Open Activities의 task를 닫는다.

### apex:emailPublisher 속성

| Attribute Name | Attribute Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| autoCollapseBody | Boolean | A Boolean value that specifies whether the email body collapses to a small height when it is empty. | | 25.0 | |
| bccVisibility | String | The visibility of the BCC field can be 'editable', 'editableWithLookup', 'readOnly', or 'hidden'. | | 25.0 | |
| ccVisibility | String | The visibility of the CC field can be 'editable', 'editableWithLookup', 'readOnly', or 'hidden'. | | 25.0 | |
| emailBody | String | The default text value of the email body. | | 25.0 | |
| emailBodyFormat | String | The format of the email body can be 'text', 'HTML', or 'textAndHTML'. | | 25.0 | |
| emailBodyHeight | String | The height of the email body in em. | | 25.0 | |
| enableQuickText | Boolean | A Boolean value that specifies whether the Quick Text autocomplete functionality is available in the action. | | 25.0 | |
| entityId | id | Entity ID of the record for which to display the Email action. In the current version, only Case record ids are supported. | Yes | 25.0 | |
| expandableHeader | Boolean | A Boolean value that specifies whether the header is expandable or fixed. | | 25.0 | |
| fromAddresses | String | A restricted set of from addresses. | | 25.0 | |
| fromVisibility | String | The visibility of the From field can be 'selectable' or 'hidden'. | | 25.0 | |
| id | String | An identifier that allows the component to be referenced by other components on the page. | | 25.0 | Global |
| onSubmitFailure | String | The JavaScript invoked if the email is not successfully sent. | | 25.0 | |
| onSubmitSuccess | String | The JavaScript invoked if the email is successfully sent. | | 25.0 | |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 25.0 | Global |
| reRender | Object | The ID of one or more components that are redrawn when the email is successfully sent. This value can be a single ID, a comma-separated list of IDs, or a merge field expression for a list or collection of IDs. | | 25.0 | |
| sendButtonName | String | The name of the send button in the Email action. | | 25.0 | |
| showAdditionalFields | Boolean | A Boolean value that specifies whether the additional fields defined in the action layout are displayed. | | 25.0 | |
| showAttachments | Boolean | A Boolean value that specifies whether the attachment selector is displayed. | | 25.0 | |
| showSendButton | Boolean | A Boolean value that specifies whether the send button is displayed. | | 25.0 | |
| showTemplates | Boolean | A Boolean value that specifies whether the template selector is displayed. | | 25.0 | |
| subject | String | The default value of the Subject. | | 25.0 | |
| subjectVisibility | String | The visibility of the Subject field can be 'editable', 'readOnly', or 'hidden'. | | 25.0 | |
| submitFunctionName | String | The name of a function that can be called from JavaScript to send the email. | | 25.0 | |
| title | String | The title displayed in the Email action header. | | 25.0 | |
| toAddresses | String | The default value of the To field. | | 25.0 | |
| toVisibility | String | The visibility of the To field can be 'editable', 'editableWithLookup', 'readOnly', or 'hidden'. | | 25.0 | |
| width | String | The width of the action in pixels (px) or percentage (%). | | 25.0 | |

### Use Case

Cirrus Computers는 전 세계 10개 지원 센터에 기술 지원 상담원을 둔 다국적 하드웨어 회사로, 발신 메시지의 표준화를 높이고 상담원이 편집할 수 있는 필드를 제한하기 위해 Email action을 커스터마이즈하길 원했다. Cirrus는 `apex:emailPublisher` 컴포넌트로 다음과 같은 Email action을 만들었다:
- To와 Subject 필드를 read-only로.
- 그 필드들을 사전 채움 — 이메일 작성 시 일관성을 보장하고 상담원 효율성 향상.

### Code Sample

```html
<apex:page standardController="Case" >
  <apex:emailPublisher entityId="{!case.id}"
      fromVisibility="selectable"
      subjectVisibility="readOnly"
      subject="Your Cirrus support request"
      toVisibility="readOnly"
      toAddresses="{!case.contact.email}"
      emailBody=""/>
</apex:page>
```

---

## Portal 액션 (support:portalPublisher)

Portal action은 상담원이 포털에서 고객에게 메시지를 작성·게시하기 쉽게 해준다. `support:portalPublisher` 컴포넌트로 다음을 할 수 있다:
- Portal action의 크기 커스터마이즈.
- 포털 메시지 텍스트의 기본값 정의.
- submit 버튼의 가시성과 레이블 정의.
- onSubmit 기능 정의.

### support:portalPublisher 속성

| Attribute Name | Attribute Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| answerBody | String | The default text value of the answer body. | | 25.0 | |
| answerBodyHeight | String | The height of the answer body in ems (em). | | 25.0 | |
| autoCollapseBody | Boolean | A Boolean value that specifies whether the answer body is collapsed when it is empty. | | 25.0 | |
| entityId | id | Entity ID of the record for which to display the Portal action. In the current version, only Case record ids are supported. | Yes | 25.0 | |
| id | String | An identifier that allows the component to be referenced by other components on the page. | | 25.0 | Global |
| onSubmitFailure | String | The JavaScript invoked if the answer failed to be published to the portal. | | 25.0 | |
| onSubmitSuccess | String | The JavaScript invoked if the answer was successfully published to the portal. | | 25.0 | |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 25.0 | Global |
| reRender | Object | The ID of one or more components that are redrawn when the answer is successfully published. This value can be a single ID, a comma-separated list of IDs, or a merge field expression for a list or collection of IDs. | | 25.0 | |
| showSendEmailOption | Boolean | A Boolean value that specifies whether the option to send email notification should be displayed. | | 25.0 | |
| showSubmitButton | Boolean | A Boolean value that specifies whether the submit button should be displayed. | | 25.0 | |
| submitButtonName | String | The name of the submit button in the portal action. | | 25.0 | |
| submitFunctionName | String | The name of a function that can be called from JavaScript to publish the answer. | | 25.0 | |
| title | String | The title displayed in the portal action header. | | 25.0 | |
| width | String | The width of the action in pixels (px) or percentage (%). | | 25.0 | |

### Use Case

The Wellness Group은 3계층 지원 구조에 300명의 지원 상담원을 둔 헬스케어 회사다. Wellness는 고객 응답 시 상담원이 입력해야 하는 인사말·맺음말 같은 표준 텍스트량을 줄이도록 Portal action을 커스터마이즈하길 원했다 — 상담원 효율성을 높이고 포털 커뮤니케이션 표준화를 개선하기 위해. Wellness는 `support:portalPublisher` 컴포넌트로 다음과 같은 Portal action을 만들었다:
- 메시지 본문을 표준 시작("Hello {name}, and thanks for your question.")과 표준 맺음("Please let me know if there's anything else I can do to help.")으로 사전 채움.
- 필요 시 상담원이 사전 채운 텍스트를 편집할 수 있게 함.

### Code Sample

```html
<apex:page standardController="Case">
    <support:portalPublisher entityId="{!case.id}" width="800px"
        answerBody="Hello {!Case.Contact.FirstName}, and thanks for your question.
            \n\nPlease let me know if there's anything else I can do to help.">
    </support:portalPublisher>
</apex:page>
```

---

## Log a Call 액션 (apex:logCallPublisher)

Log a Call action은 상담원이 고객 통화에 대한 메모와 정보를 기록하게 해준다. `apex:logCallPublisher`로 다음을 할 수 있다:
- Log a Call action의 외관과 크기 커스터마이즈.
- 액션에 표시할 필드 지정.
- submit 버튼의 가시성과 레이블 정의.
- onSubmit 기능 정의.

### apex:logCallPublisher 속성

| Attribute Name | Attribute Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| autoCollapseBody | Boolean | A Boolean value that specifies whether the Log a Call body is collapsed when it is empty. | | 25.0 | |
| entityId | id | Entity ID of the record for which to display the Log a Call action. In the current version, only Case record ids are supported. | Yes | 25.0 | |
| id | String | An identifier that allows the component to be referenced by other components on the page. | | 25.0 | Global |
| logCallBody | String | The initial text value of the Log a Call body when the action is rendered. | | 25.0 | |
| logCallBodyHeight | String | The height of the Log a Call body in em. | | 25.0 | |
| onSubmitFailure | String | The JavaScript invoked if the call is not successfully logged. | | 25.0 | |
| onSubmitSuccess | String | The JavaScript invoked if the call is successfully logged. | | 25.0 | |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 25.0 | Global |
| reRender | Object | The ID of one or more components that are redrawn when the call is successfully logged. This value can be a single ID, a comma-separated list of IDs, or a merge field expression for a list or collection of IDs. | | 25.0 | |
| showAdditionalFields | Boolean | A Boolean value that specifies whether the additional fields defined in the action layout should be displayed. | | 25.0 | |
| showSubmitButton | Boolean | A Boolean value that specifies whether the submit button should be displayed. | | 25.0 | |
| submitButtonName | String | The name of the submit button in the Log a Call action. | | 25.0 | |
| submitFunctionName | String | The name of a function that can be called from JavaScript to publish the call log. | | 25.0 | |
| title | String | The title displayed in the Log a Call action header. | | 25.0 | |
| width | String | The width of the action in pixels (px) or percentage (%). | | 25.0 | |

### Use Case

Stellar Wireless는 여러 대규모 콜센터를 운영하는 모바일 폰 제공업체로, 상담원이 고객 이슈를 빠르게 해결하고 고객 상호작용에 대한 상세·정확한 기록을 유지하는 것 모두에 보상한다. Stellar는 상담원이 다른 액션으로 작업 중일 때도 항상 열려 있고 사용 가능하도록 Log a Call action을 커스터마이즈하길 원했다 — 인바운드 통화에 대해 빠르고 쉽게 메모할 수 있도록. Stellar는 `apex:logCallPublisher` 컴포넌트로 다음과 같은 Log a Call action을 만들었다:
- 표준 interaction log를 대체하여 페이지 footer에 표시.
- 상담원이 case를 열 때마다 기본적으로 열려 있고 사용 가능.

### Code Sample

```html
<apex:page standardController="Case">
  <apex:logCallPublisher entityId="{!case.id}"
      width="100%"
      title="Log a Call"
      autoCollapseBody="false"
      showAdditionalFields="false"
      submitButtonName="Save Log" />
</apex:page>
```

### interaction log 교체 단계

이 코드로 Visualforce 페이지를 만든 후, 생성한 Log a Call action을 표준 interaction log의 대체로 사용하려면 다음 단계를 따른다:

1. case의 object management settings에서 Page Layouts로 이동.
2. Page Layouts for Case Feed Users 목록에서 사용 중인 레이아웃을 선택한 뒤 Edit detail view 선택.
3. 페이지 상단의 Custom Console Components 링크 클릭.
4. Subtab Components 섹션에서 lookup으로 생성한 페이지를 bottom sidebar에 사용할 컴포넌트로 선택.
5. 액션의 높이 지정.
6. Save 클릭.
7. 페이지 레이아웃 편집기에서 Layout Properties 클릭.
8. Interaction Log 체크 해제.
9. OK 클릭.
10. Save 클릭.

> **SEE ALSO:** Salesforce Help: Find Object Management Settings

---

## Articles 툴 (support:caseArticles)

Articles tool은 상담원이 Salesforce Knowledge 아티클을 탐색하고, 아티클이 case에 첨부됐는지 확인하고, 관련 아티클을 고객과 공유하게 해준다. `support:caseArticles` 컴포넌트로 다음을 할 수 있다:
- Articles tool의 외관과 크기 커스터마이즈.
- 툴의 검색 기능이 어떻게 작동하는지 정의 (기본 사용 아티클 타입·키워드, advanced search 가용 여부 포함).
- 상담원이 이메일에 아티클을 첨부할 수 있는지 지정.

### support:caseArticles 속성

| Attribute Name | Attribute Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| articleTypes | String | Article types to be used to filter the search. Multiple article types can be defined, separated by commas. | | 25.0 | |
| attachToEmailEnabled | Boolean | A Boolean value that specifies whether articles can be attached to emails. | | 25.0 | |
| bodyHeight | String | The height of the body in pixels (px) or 'auto' to automatically adjust to the height of the currently displayed list of articles. | | 25.0 | |
| caseId | id | Case ID of the record for which to display the case articles. | Yes | 25.0 | |
| categories | String | Data categories to be used to filter the search. The format of this value should be: 'CatgeoryGroup1:Category1' where CategoryGroup1 and Category1 are the names of a Category Group and a Category respectively. Multiple category filters can be specified separated by commas but only one per category group. | | 25.0 | |
| defaultKeywords | String | The keywords to be used when the defaultSearchType attribute is 'keyword'. If no keywords are specified, the Case subject is used as a default. | | 25.0 | |
| defaultSearchType | String | Specifies the default query of the article search form when it is first displayed. The value can be 'keyword', 'mostViewed', or 'lastPublished'. | | 25.0 | |
| id | String | An identifier that allows the component to be referenced by other components on the page. | | 25.0 | Global |
| language | String | The language used for filtering the search if multilingual Salesforce Knowledge is enabled. | | 25.0 | |
| logSearch | Boolean | A Boolean value that specifies whether keyword searches should be logged. | | 25.0 | |
| mode | String | Specifies whether the component displays articles currently attached to the case, an article search form, or both. The value can be 'attached', 'search', 'attachedAndSearch', or 'searchAndAttached'. | | 25.0 | |
| onSearchComplete | String | The JavaScript invoked after an article search has completed. | | 25.0 | |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 25.0 | Global |
| reRender | Object | The ID of one or more components that are redrawn when the result of the action method returns to the client. This value can be a single ID, a comma-separated list of IDs, or a merge field expression for a list or collection of IDs. | | 25.0 | |
| searchButtonName | String | The display name of the search button. | | 25.0 | |
| searchFieldWidth | String | The width of the keyword search field in pixels (px). | | 25.0 | |
| searchFunctionName | String | The name of a function that can be called from JavaScript to search for articles if the widget is currently in search mode. | | 25.0 | |
| showAdvancedSearch | Boolean | A Boolean value that specifies whether the advanced search link should be displayed. | | 25.0 | |
| title | String | The title displayed in the component's header. | | 25.0 | |
| titlebarStyle | String | The style of the title bar can be 'expanded', 'collapsed', 'fixed', or 'none'. | | 25.0 | |
| width | String | The width of the component in pixels (px) or percentage (%). | | 25.0 | |

### Use Case

Cirrus Computers는 상담원이 고객 이슈 해결에 도움이 되는 아티클을 더 쉽게 찾도록 Case Feed articles tool을 커스터마이즈하길 원했다. Cirrus는 `support:caseArticles` 컴포넌트로 다음과 같은 articles tool을 만들었다:
1. 페이지 우측 사이드바에 표시되고 모든 case 페이지에서 기본적으로 열려 있음.
2. search-as-you-type 기능으로 제안 아티클을 빠르게 표시.
3. 상담원이 email action으로 작성한 메시지에 아티클을 첨부하게 함.
4. case에 첨부된 아티클이 없을 때 가장 최근 게시된 아티클을 표시.

### Code Sample

```html
<apex:page standardController="Case">
    <div style="margin-left:-10px;margin-right:-10px;">
        <div style="background-color: #99A3AC;color:#FFFFFF;font-size:1.1em;font-weight:
            bold;padding:3px 6px 3px 6px;">Articles</div>
        <support:caseArticles caseId="{!case.id}"
            bodyHeight="auto"
            titlebarStyle="none"
            searchButtonName="Search"
            searchFieldWidth="200px"
            defaultSearchType="lastPublished"
        />
    </div>
</apex:page>
```

---

## 표준 Case Feed 페이지 복제 (support:CaseFeed)

`support:CaseFeed` 컴포넌트는 표준 Case Feed 페이지의 모든 요소를 포함한다:
- Email, Portal, Log a Call, Case Note 액션
- Case activity feed
- Feed filters
- Highlights panel
- Case following icon
- Case followers list
- Layout, print, help 링크

### support:CaseFeed 속성

| Attribute Name | Attribute Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| caseId | id | ID of the case record to display in Case Feed. | Yes | 26.0 | |
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 26.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 26.0 | global |

### Use Case

National Foods는 미국 전역의 레스토랑과 기업 카페테리아에 공급하는 식품 서비스 회사다. National의 지원 운영은 주로 데스크톱에서 일하는 콜센터 상담원과 주로 모바일 기기에서 일하는 현장 상담원 모두를 포함한다. 회사는 현장 상담원이 사용하기 쉬운 단순화된 Case Feed 페이지를 원했고, 콜센터 상담원에게는 전체 Case Feed 기능에 대한 접근을 주고 싶었다. National은 `support:CaseFeed` 컴포넌트로 데스크톱에서 일하는 콜센터 상담원용 표준 Case Feed 페이지를 재현하고, 모바일 기기에서 일하는 현장 상담원용 커스텀 페이지를 만들었다.

> 시각 자료: PDF p.40에 다이어그램/스크린샷이 있으며 캡션은 "Standard Case Feed page created with support:CaseFeed" 한 줄이다. 다이어그램 본체는 본문 미추출 — 캡션만 사용하고 재현하지 않는다.

### Code Sample — VF 페이지

```html
<apex:page standardController="Case"
    extensions="CasePageSelectorExtension" showHeader="true" sidebar="false">
    <apex:dynamicComponent componentValue="{!casePage}"/>
</apex:page>
```

### CasePageSelectorExtension (Apex 컨트롤러 확장)

위 Visualforce 페이지와 함께 사용하는 컨트롤러 확장. 역할에 따라 동적으로 `support:CaseFeed` 또는 표준 detail을 렌더한다.

```apex
public class CasePageSelectorExtension {
    boolean isFieldAgent;
    String caseId;

    public CasePageSelectorExtension(ApexPages.StandardController controller) {
        List<UserRole> roles = [SELECT Id FROM UserRole WHERE Name = 'FieldAgent'];
        isFieldAgent = !roles.isEmpty() && UserInfo.getUserRoleId() == roles[0].Id;
        caseId = controller.getRecord().id;
    }

    public Component.Apex.OutputPanel getCasePage() {
        Component.Apex.OutputPanel panel = new Component.Apex.OutputPanel();
        if (isFieldAgent) {
            Component.Apex.Detail detail = new Component.Apex.Detail();
            detail.subject = caseId;
            panel.childComponents.add(detail);
        } else {
            Component.Support.CaseFeed caseFeed = new Component.Support.CaseFeed();
            caseFeed.caseId = caseId;
            panel.childComponents.add(caseFeed);
        }
        return panel;
    }
}
```

---

## 커스텀 액션 만들기

Visualforce 페이지를 Case Feed의 커스텀 액션으로 사용할 수 있다. 예를 들어 상담원이 고객 위치를 조회하고 인근 서비스 센터를 찾는 Map and Local Search 액션을 만들 수 있다. 표준 case 컨트롤러를 사용하는 어떤 Visualforce 페이지든 커스텀 액션으로 쓸 수 있다.

### Use Case

Viaggio Italiano는 이탈리아 투어를 전문으로 하는 부티크 여행사다. 회사는 각 고객별로 항공편, 지상 교통 세부사항, 식단 선호, 일정 등 여러 정보를 추적한다. Viaggio Italiano의 상담원은 긴 case 댓글을 작성할 수 있어야 했지만 표준 case note는 1,000자로 제한되어 있었다. 회사는 이 제한을 우회하는 방법을 원했다. Viaggio Italiano는 Visualforce로 최대 4,000자까지 case comment를 게시할 수 있는 페이지를 만들고, Case Feed 페이지 레이아웃을 편집해 그 페이지를 커스텀 액션으로 추가했다.

### Code Sample 1 — interaction.js 사용

publisher에 액션이 활성화되지 않았거나, 활성화되었더라도 페이지 레이아웃 편집기가 아닌 Case Feed Settings 페이지로 publisher 액션을 선택·구성하는 org를 위한 커스텀 Post Case Comment 액션.

```html
<apex:page standardcontroller="Case"
    extensions="CaseCommentExtension" showHeader="false">
    <apex:includeScript value="/support/api/26.0/interaction.js"/>
    <div>
        <apex:form >
            <!-- Creates a case comment and on complete notifies the Case Feed page
               that a elated list and the feed have been updated -->
            <apex:actionFunction action="{!addComment}" name="addComment" rerender="out"
               oncomplete="sforce.interaction.entityFeed.refreshObject('{!case.id}',
               false, true, true);"/>
               <apex:outputPanel id="out" >
                   <apex:inputField value="{!comment.commentbody}" style="width:98%;
                   height:160px;" />
               </apex:outputPanel>
           </apex:form><br />
           <button type="button" onclick="addComment();" style="position:fixed; bottom:0px;
        right:2px; padding: 5px 10px; font-size:13px;" id="cpbutton" >Post Case Comment
        </button>
    </div>
</apex:page>
```

### Code Sample 2 — publisher.js 사용

org에 publisher 액션이 활성화되어 있고 페이지 레이아웃 편집기로 액션을 선택·구성하기로 선택한 경우의 커스텀 Post Case Comment 액션.

```html
<apex:page standardcontroller="Case"
    extensions="CaseCommentExtension" showHeader="false">
    <!-- Uses publisher.js rather than interaction.js -->
    <apex:includeScript value="/canvas/sdk/js/28.0/publisher.js"/>
    <div>
        <apex:form >
            <!-- Creates a case comment and on complete notifies the Case Feed page
                that a related list and the feed have been updated -->
            <apex:actionFunction action="{!addComment}" name="addComment" rerender="out"
               <!-- Different oncomplete function using publisher.js -->
               oncomplete="Sfdc.canvas.publisher.publish(
               {name : 'publisher.refresh', payload :
               {feed: true, objectRelatedLists: {}}});"/>
               <apex:outputPanel id="out" >
                   <apex:inputField value="{!comment.commentbody}" style="width:98%;
                   height:160px;" />
               </apex:outputPanel>
           </apex:form><br />
           <button type="button" onclick="addComment();" style="position:fixed; bottom:0px;
           right:2px; padding: 5px 10px; font-size:13px;" id="cpbutton" >Post Case Comment
           </button>
    </div>
</apex:page>
```

### CaseCommentExtension (Apex 컨트롤러 확장)

위 두 버전의 Visualforce 페이지 중 어느 것과도 함께 사용하는 컨트롤러 확장.

```apex
public with sharing class CaseCommentExtension {
    private final Case caseRec;
    public CaseComment comment {get; set;}

      public CaseCommentExtension(ApexPages.StandardController controller) {
          caseRec = (Case)controller.getRecord();
          comment = new CaseComment();
          comment.parentid = caseRec.id;
      }

      public PageReference addComment() {
          insert comment;
          comment = new CaseComment();
          comment.parentid = caseRec.id;
          return null;
      }
}
```

### Additional Steps

Visualforce 페이지를 만든 후 사용자가 사용할 수 있게 한다.

**먼저 프로파일에 페이지 접근 권한을 부여:**
1. Setup에서 Quick Find 박스에 Visualforce Pages 입력 후 Visualforce Pages 선택.
2. 생성한 페이지 이름 옆의 Security 클릭.
3. 페이지에 접근할 수 있게 할 프로파일 선택.
4. Save 클릭.

**그 다음 페이지를 커스텀 액션으로 포함. Case Feed Settings 페이지로 액션을 선택·구성하는 경우:**
1. case의 object management settings에서 Page Layouts로 이동.
2. Case Feed Settings 페이지 접근 방법은 작업 중인 페이지 레이아웃 종류에 따라 다름.
   - Case Page Layouts 섹션의 레이아웃은 Edit 클릭 후 페이지 레이아웃 편집기에서 Feed View 클릭.
   - Page Layouts for Case Feed Users 섹션의 레이아웃은 아래쪽 화살표를 클릭하고 Edit feed view 선택. (이 섹션은 Spring '14 이전에 생성된 org에만 나타남.)
3. Custom Actions에서 + Add a Visualforce page 클릭.
4. 추가할 페이지 선택.
5. 액션의 높이 지정. 최상의 외관을 위해 200픽셀 높이 권장.
6. Select Actions에서 커스텀 액션을 Available에서 Selected로 이동.
7. Save 클릭.

**페이지 레이아웃 편집기로 액션을 선택·구성하기로 한 경우, 먼저 커스텀 액션을 생성:**
1. case의 object management settings에서 Buttons, Links, and Actions로 이동.
2. New Action 클릭.
3. Custom Visualforce 선택.
4. 생성한 Visualforce 페이지를 선택한 뒤 액션 창의 높이 지정. (너비는 고정.)
5. 액션의 레이블 입력. publisher에서 사용자가 보는 텍스트.
6. 필요 시 액션 이름 변경.
7. 액션 설명 입력. 액션의 상세 페이지와 Buttons, Links, and Actions 페이지 목록에 표시됨. 사용자에게는 보이지 않음.
8. 선택적으로 Change Icon을 클릭해 액션에 다른 아이콘 선택. 이 아이콘은 API를 통해 액션을 사용할 때만 나타남.

**그 다음 액션을 페이지 레이아웃에 추가:**
1. case의 object management settings에서 Page Layouts로 이동.
2. 페이지 레이아웃 편집기 접근 방법은 작업 중인 페이지 레이아웃 종류에 따라 다름.
   - Case Page Layouts 섹션의 레이아웃은 Edit 클릭 후 페이지 레이아웃 편집기에서 Feed View 클릭.
   - Page Layouts for Case Feed Users 섹션의 레이아웃은 아래쪽 화살표를 클릭하고 Edit detail view 선택. (이 섹션은 Spring '14 이전에 생성된 org에만 나타남.)
3. 팔레트에서 Quick Actions 클릭.
4. 팔레트에서 Quick Actions in the Salesforce Classic Publisher 섹션으로 액션을 드래그.
5. Save 클릭.

> **SEE ALSO:** Salesforce Help: Find Object Management Settings

---

## 기타 리소스

이 가이드 외에도 Salesforce Classic Publisher JavaScript API와 Lightning Quick Action JavaScript API 학습을 위한 다른 리소스가 있다. Aura 컴포넌트, Visualforce, Case Feed에 대해 더 배우려면 다음을 사용한다:
- Lightning Aura Components Developer Guide
- Visualforce Developer Guide

---

## 관련 노트
- [[Aura(오라)/Quick Action·Publisher JS API 레퍼런스|Quick Action·Publisher JS API 레퍼런스]] — 이 VF 컴포넌트가 사용하는 Publisher JS API 메서드의 Payload·버전·코드 샘플 상세.
- [[Service(서비스)/Knowledge(지식)/Lightning Knowledge 사용 — 액션·검색·스마트링크·채널|Lightning Knowledge 사용 — 액션·검색·스마트링크·채널]] — `support:caseArticles`가 다루는 Knowledge 아티클의 액션·검색 맥락.
- [[Architecture(아키텍처)/ApexPages Namespace|ApexPages Namespace]] — VF 컨트롤러 확장이 사용하는 `ApexPages.StandardController`.
- [[Apex/Integration(통합)/Support Namespace|Support Namespace]] — `Support.EmailTemplateSelector`(Classic Case Feed 이메일 템플릿 자동선택)·마일스톤. 이 노트의 `apex:emailPublisher` Email 액션 커스터마이즈와 인접한 Apex 측 Case Feed API.
