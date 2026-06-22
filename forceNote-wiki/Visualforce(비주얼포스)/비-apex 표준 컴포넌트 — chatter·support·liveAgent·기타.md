---
tags: [visualforce, vf, component-reference, chatter, liveagent, support, messaging, legacy]
source: salesforce_pages_developers_guide.pdf (Visualforce Developer Guide, v67.0 Summer '26)
created: 2026-06-22
aliases: [chatter:feed, liveAgent 컴포넌트, knowledge:articleList, messaging:emailTemplate, wave:dashboard, Visualforce 비-apex 컴포넌트, chatteranswers]
---

# 비-apex 표준 컴포넌트 — chatter·support·liveAgent·기타

> [!note] Visualforce는 레거시 기술이다. 신규 개발은 Lightning Web Components(LWC) 권장.

> Visualforce 표준 컴포넌트 라이브러리 중 `apex:` 네임스페이스를 제외한 기능 컴포넌트 57개 전수 레퍼런스 — Chatter 피드, Chatter Answers, Flow, Ideas, Knowledge, Chat(Live Agent), 이메일 템플릿, Sites, Social, Case Support, Topics, Analytics(Wave) 네임스페이스의 컴포넌트명·설명·예제·6열 속성표.

---

> **속성표 6열 구조 (전 컴포넌트 공통):** `Attribute Name | Type | Description | Required? | API Ver | Access`. `Required?` 셀이 공란이면 선택 속성, `Access` 셀이 공란이면 명시 없음(non-global). 빈 셀은 PDF 원문에서도 빈 값이다.
>
> 중복 3개 컴포넌트(`support:caseArticles` · `support:caseFeed` · `support:portalPublisher`)의 속성표 정본은 [[Case Feed Visualforce 커스터마이즈]]에 있다. 이 노트에서는 deep-link 1줄만 둔다. `messaging:*` 컴포넌트는 [[이메일·차트·맵·Flow·템플릿]](사용법)과 겹치나 **속성표 정본은 이 노트**다.

---

## chatter (6)

### chatter:feed

Displays the Chatter feed for a record or a user.

**사용 제한:**
- Chatter components are unavailable for Visualforce pages on Experience Cloud sites.
- Ext JS version 3.0 and earlier can't be included on pages that use this component.
- The `chatter:feed` component doesn't support `feedItemType` when the `entityId` is a user.
- The `chatter:feed` component doesn't support the creation of hyperlinks in Chatter posts through the rich text editor. In Salesforce Classic, users can still attach a link to a Chatter post.

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| entityId | id | ID of the record for which to display the feed; for example, `{!Contact.Id}`. To display the Chatter feed of the current user, use `{!$User.Id}`. | Yes | 20.0 | |
| feedItemType | String | The feed item type on which the record or user feed is filtered. For accepted values, see the type field for the FeedItem object. | | 20.0 | |
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| onComplete | String | The JavaScript function to call after a post or comment is added to the feed | | 20.0 | |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |
| reRender | Object | The ID of one or more components that are redrawn when the result of the action method returns to the client. This value can be a single ID, a comma-separated list of IDs, or a merge field expression for a list or collection of IDs. | | 20.0 | |
| showPublisher | Boolean | Displays the Chatter publisher. In archived groups, the publisher is hidden regardless of the value specified. | | 20.0 | |

---

### chatter:feedWithFollowers

An integrated UI component that displays the Chatter feed for a record, as well as its list of followers.

> Chatter components are unavailable for Visualforce pages on Force.com sites. Ext JS versions less than 3 should not be included on pages that use this component. Do not include this component inside an `<apex:form>` tag.

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| entityId | id | Entity ID of the record for which to display the feed; for example, Contact.Id | Yes | 20.0 | |
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| onComplete | String | The JavaScript invoked when the result of an AJAX update request completes on the client | | 20.0 | |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |
| reRender | Object | The ID of one or more components that are redrawn when the result of the action method returns to the client. This value can be a single ID, a comma-separated list of IDs, or a merge field expression for a list or collection of IDs. | | 20.0 | |
| showHeader | Boolean | Shows a metabar header that includes UI tags, a Show/Hide button, and a Follow/Unfollow button | | 20.0 | |

See also: `chatter:feed`

---

### chatter:follow

Renders a button for a user to follow or unfollow a Chatter record.

> Chatter components are unavailable for Visualforce pages on Force.com sites. Ext JS versions less than 3 should not be included on pages that use this component.

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| entityId | id | Entity ID of the record for which to display the follow or unfollow button; for example, Contact.Id | Yes | 20.0 | |
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| onComplete | String | The JavaScript function to call after the follow/unfollow event completes | | 20.0 | |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |
| reRender | Object | The ID of one or more components that are redrawn when the result of the action method returns to the client. This value can be a single ID, a comma-separated list of IDs, or a merge field expression for a list or collection of IDs. | | 20.0 | |

See also: `chatter:followers`

---

### chatter:followers

Displays the list of Chatter followers for a record.

> Chatter components are unavailable for Visualforce pages on Force.com sites. Ext JS versions less than 3 should not be included on pages that use this component.

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| entityId | id | Entity ID of the record for which to display the list of followers; for example, Contact.Id | Yes | 20.0 | |
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |

See also: `chatter:follow`

---

### chatter:newsfeed

Displays the Chatter NewsFeed for the current user.

> Chatter components are unavailable for Visualforce pages on Force.com sites. Ext JS versions less than 3 should not be included on pages that use this component.

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| onComplete | String | The JavaScript function to call after a post or comment is added to the feed | | 24.0 | |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |
| reRender | Object | The ID of one or more components that are redrawn when the result of the action method returns to the client. This value can be a single ID, a comma-separated list of IDs, or a merge field expression for a list or collection of IDs. | | 24.0 | |

---

### chatter:userPhotoUpload

Uploads a user's photo to their Chatter profile page.

> To use this component, you must enable Chatter in the org. Users must belong to either Standard User, Portal User, High Volume Portal User, or Chatter External User profiles.

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |
| showOriginalPhoto | Boolean | Displays the photo in its original format instead of the default cropped format. | | 28.0 | |

---

## chatteranswers (14)

### chatteranswers:aboutme

Chatter Answers profile box which contains the user photo, username, the Edit my settings link, and the Sign out link.

> The profile box is accessible only to authenticated users. Use with other Chatter Answers components to create a customized experience for your Chatter Answers users.

```xml
<apex:page showHeader="true">
    <chatteranswers:aboutme communityId="09axx00000000HK"/>
</apex:page>
```

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| communityId | String | Zone in which to display the feed. | Yes | 29.0 | |
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| noSignIn | Boolean | A flag that disables the sign-on option for the feed. | | 29.0 | |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |

---

### chatteranswers:allfeeds

Displays the Chatter Answers application, including the feed, filters, profiles, and the Sign Up and Sign In buttons.

> Ext JS versions less than 3 should not be included on pages that use this component.

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| articleLanguage | String | The language in which the articles must be retrieved. | | 24.0 | |
| communityId | id | Zone in which to display the feed. | Yes | 24.0 | |
| filterOptions | String | You can select any of the following options as filters in the Q&A feed: 'AllQuestions', 'UnansweredQuestions', 'UnsolvedQuestions', 'SolvedQuestions', 'MyQuestions', 'MostPopular', 'DatePosted', 'RecentActivity'. | | 24.0 | |
| forceSecureCustomWebAddress | Boolean | This attribute was deprecated in Salesforce API version 29.0 and has no effect on the page. | | 24.0 | |
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| jsApiVersion | Double | JavaScript API version | | 24.0 | |
| noSignIn | Boolean | A flag that disables the sign-on option for the feed. | | 24.0 | |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |
| useUrlRewriter | Boolean | A flag that rewrites URLs based on the Sites URL Rewriter. | | 24.0 | |

---

### chatteranswers:changepassword

Displays the Chatter Answers change password page.

> Ext JS versions less than 3 should not be included on pages that use this component.

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |

See also: `chatteranswers:forgotpassword`

---

### chatteranswers:datacategoryfilter

Chatter Answers data category filter, which let users filter feeds by data category.

> Use with other Chatter Answers components to create a customized experience for your Chatter Answers users.

```xml
<apex:page showHeader="true">
    <chatteranswers:datacategoryfilter communityId="09axx00000000HK"/>
</apex:page>
```

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| communityId | string | Zone in which to display the feed. | Yes | 29.0 | |
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |

> [sic] `communityId` Type가 소문자 `string`(다른 컴포넌트는 `String`) — 원문 그대로 보존.

---

### chatteranswers:feedfilter

The feed filter lets users sort and filter the feeds that appear in Chatter Answers.

```xml
<apex:page showHeader="true">
    <chatteranswers:feedfilter/>
</apex:page>
```

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| filterOptions | String | The options show in Chatter Answers Filter, can be 'AllQuestions', 'UnansweredQuestions', 'UnsolvedQuestions', 'SolvedQuestions', 'MyQuestions', 'MostPopular', 'DatePosted', 'RecentActivity'. | | 29.0 | |
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |

---

### chatteranswers:feeds

Chatter Answers feed, which let users browse questions and articles and post replies to questions within a zone.

> Use with other Chatter Answers components to create a customized experience for your Chatter Answers users.

```xml
<apex:page showHeader="true">
    <chatteranswers:feeds communityId="09axx00000000HK"/>
</apex:page>
```

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| articleLanguage | String | The language in which the articles must be retrieved. | | 29.0 | |
| communityId | String | Zone in which to display the feed. | Yes | 29.0 | |
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| jsApiVersion | Double | JavaScript API version | | 29.0 | |
| noSignIn | Boolean | A flag that disables the sign-on option for the feed. | | 29.0 | |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |
| useUrlRewriter | Boolean | A flag that rewrites urls based on the Sites URL Rewriter. | | 29.0 | |

---

### chatteranswers:forgotpassword

Displays the Chatter Answers forgot password page.

> Ext JS versions less than 3 should not be included on pages that use this component.

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |
| useUrlRewriter | Boolean | A flag that rewrites urls based on the Sites URL Rewriter. | | 24.0 | |

See also: `chatteranswers:changepassword`

---

### chatteranswers:forgotpasswordconfirm

Displays the Chatter Answers password confirmation page.

> Ext JS versions less than 3 should not be included on pages that use this component.

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |
| useUrlRewriter | Boolean | A flag that rewrites urls based on the Sites URL Rewriter. | | 24.0 | |

See also: `chatteranswers:changepassword`

---

### chatteranswers:guestsignin

Chatter Answers Sign In and Sign Up buttons.

> These buttons are accessible only to guest users. Use with other Chatter Answers components to create a customized experience for your Chatter Answers users.

```xml
<apex:page showHeader="true">
    <chatteranswers:guestsignin/>
</apex:page>
```

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |
| useUrlRewriter | Boolean | A flag that rewrites URLs based on the Sites URL Rewriter. | | 29.0 | |

---

### chatteranswers:help

Displays the Chatter Answers help page (FAQ) to your customers.

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |

---

### chatteranswers:login

Displays the Chatter Answers sign in page.

> Ext JS versions less than 3 should not be included on pages that use this component.

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |
| useUrlRewriter | Boolean | A flag that rewrites urls based on the Sites URL Rewriter. | | 24.0 | |

---

### chatteranswers:registration

Displays the Chatter Answers registration page.

```xml
<apex:page showHeader="true">
    <chatteranswers:registration hideTerms="false" useUrlRewriter="false"
profileId="00exx0000000000" registrationClassName="ChatterAnswersRegistration"/>
</apex:page>
```

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| hideTerms | Boolean | Flag to hide Terms and Conditions section. | | 24.0 | |
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| profileId | id | If this component is accessed through a Salesforce Community, it represents the profile ID of the self-registered user. This profile is used only for Salesforce Community site registration and not for standalone Force.com site registration. | | 24.0 | |
| registrationClassName | String | The name of the Apex class that implements the ChatterAnswers.AccountCreator Apex interface. If unused, Chatter Answers registration uses the generated ChatterAnswers or ChatterAnswersRegistration Apex class. | | 24.0 | |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |
| useUrlRewriter | Boolean | A flag that rewrites urls based on the Sites URL Rewriter. | | 24.0 | |

---

### chatteranswers:searchask

Search bar and button that lets users search for questions and articles and ask questions within a zone.

> Use with other Chatter Answers components to create a customized experience for your Chatter Answers users.

```xml
<apex:page showHeader="true">
    <chatteranswers:searchask communityId="09axx00000000HK"/>
</apex:page>
```

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| communityId | string | Zone in which to display the feed. | Yes | 29.0 | |
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| noSignIn | Boolean | A flag that disables the sign-on option for the feed. | | 29.0 | |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |
| searchLanguage | String | The language in which the articles must be retrieved. | | 29.0 | |
| useUrlRewriter | Boolean | A flag that rewrites URLs based on the Sites URL Rewriter. | | 29.0 | |

> [sic] `communityId` Type가 소문자 `string` — 원문 그대로 보존.

---

### chatteranswers:singleitemfeed

Displays the Chatter Answers feed for a single case and question.

> Ext JS versions less than 3 should not be included on pages that use this component.

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| entityId | id | Entity ID of the case for which to display the feed. | Yes | 24.0 | |
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |

---

## flow (1)

### flow:interview

This component embeds a Flow interview in the page.

```xml
<!-- Page: -->
<apex:page controller="exampleCon">
<!-- embed a simple flow -->
 <flow:interview name="my_flow" interview="{!my_interview}"></flow:interview>
 <!-- get a variable from the embedded flow using my_interview.my_variable -->
 <apex:outputText value="here is my_variable : {!my_interview.my_variable}"/>
</apex:page>

/*** Controller ***/
public class exampleCon {
    Flow.Interview.my_flow my_interview {get; set;}
}
```

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| allowShowPause | Boolean | A Boolean value that allows the flow to display the Pause button. The Pause button appears on a flow screen only if this attribute is set to true for the `<flow:interview>` component, the 'Let Users Pause Flows' setting is enabled for your organization, and the currently displayed screen has been configured to show the Pause button. | | 33.0 | |
| buttonLocation | String | The area of the page block where the navigation buttons should be rendered. Possible values include 'top', 'bottom', or 'both'. If not specified, this value defaults to 'both'. | | 21.0 | |
| buttonStyle | String | Optional style applied to the command buttons. Can only be used for in-line styling, not for CSS classes. | | 21.0 | |
| finishLocation | ApexPages.PageReference | A PageReference that can be used to determine where the flow navigates when it finishes. | | 21.0 | |
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| interview | Flow.Interview | An object that can be used to represent the FlowInterview. | | 21.0 | |
| name | String | The unique name of the flow. | Yes | 21.0 | |
| pausedInterviewId | String | Id of a paused interview to resume. | | 33.0 | |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |
| rerender | Object | The ID of one or more components that are redrawn when the result of the action method returns to the client. This value can be a single ID, a comma-separated list of IDs, or a merge field expression for a list or collection of IDs. | | 21.0 | |
| showHelp | Boolean | Should the help link be displayed. | | 21.0 | |

See also: An Advanced Example of Using `<flow:interview>`

---

## ideas (3)

> 세 컴포넌트 공통 — Note: To use this component, please contact your Salesforce representative and request that the Ideas extended standard controllers be enabled for your organization.

### ideas:detailOutputLink

A link to the page displaying an idea.

```xml
<!-- For this example to render properly, you must associate the Visualforce page
with a valid idea record in the URL.
For example, if 001D000000IRt53 is the idea ID, the resulting URL should be:
https://MyDomain_login_URL/apex/myPage?id=001D000000IRt53
See the Visualforce Developer's Guide Quick Start Tutorial for more information. -->

<!-- Page: detailPage -->
<apex:page standardController="Idea">
    <apex:pageBlock title="Idea Section">
        <ideas:detailOutputLink page="detailPage"
ideaId="{!idea.id}">{!idea.title}</ideas:detailOutputLink>
        <br/><br/>
        <apex:outputText >{!idea.body}</apex:outputText>
    </apex:pageBlock>
    <apex:pageBlock title="Comments Section">
        <apex:dataList var="a" value="{!commentList}" id="list">
        {!a.commentBody}
        </apex:dataList>
    </apex:pageBlock>
</apex:page>
```

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| ideaId | String | The ID for the idea to be displayed. | Yes | 43.0 | |
| page | ApexPages.PageReference | The Visualforce page whose URL is used for the output link. This page must use the standard controller. | Yes | 43.0 | |
| pageNumber | Integer | The desired page number for the comments on the idea detail page (50 per page). E.g. if there are 100 comments, pageNumber="2" would show comments 51-100. | | 43.0 | |
| pageOffset | Integer | The desired page offset from the current page. If pageNumber is set, then the pageOffset value is not used. If neither pageNumber nor pageOffset are set, the resulting link does not have a page specified and the controller defaults to the first page. | | 43.0 | |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |
| style | String | The style used to display the detailOutputLink component, used primarily for adding inline CSS styles. | | 43.0 | |
| styleClass | String | The style class used to display the detailOutputLink component, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | | 43.0 | |

---

### ideas:listOutputLink

A link to the page displaying a list of ideas.

```xml
<!-- Page: listPage -->
<apex:page standardController="Idea" recordSetVar="ideaSetVar">
    <apex:pageBlock >
        <ideas:listOutputLink sort="recent" page="listPage" >Recent
Ideas</ideas:listOutputLink>
        |
        <ideas:listOutputLink sort="top" page="listPage">Top Ideas</ideas:listOutputLink>
        |
        <ideas:listOutputLink sort="popular" page="listPage">Popular
Ideas</ideas:listOutputLink>
        |
        <ideas:listOutputLink sort="comments" page="listPage">Recent
Comments</ideas:listOutputLink>
    </apex:pageBlock>
    <apex:pageBlock >
        <apex:dataList value="{!ideaList}" var="ideadata">
        <apex:outputText value="{!ideadata.title}"/>
        </apex:dataList>
    </apex:pageBlock>
</apex:page>
```

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| category | String | The desired category for the list of ideas. | | 43.0 | |
| communityId | String | The ID for the zone in which the ideas are displayed. If communityID is not set, the zone is defaulted to an active zone accessible to the user. If the user has access to more than one zone, the zone whose name comes first in the alphabet is used. | | 43.0 | |
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| page | ApexPages.PageReference | The Visualforce page whose URL is used for the output link. This page must use the set oriented standard controller. | Yes | 43.0 | |
| pageNumber | Integer | The desired page number for the list of ideas (20 per page). E.g. if there are 100 ideas, pageNumber="2" would show ideas 21-40. | | 43.0 | |
| pageOffset | Integer | The desired page offset from the current page. If pageNumber is set, then the pageOffset value is not used. If neither pageNumber nor pageOffset are set, the resulting link does not have a page specified and the controller defaults to the first page. | | 43.0 | |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |
| sort | String | The desired sort for the list of ideas. Possible values include "popular", "recent", "top", and "comments." | | 43.0 | |
| status | String | The desired status for the list of ideas. | | 43.0 | |
| stickyAttributes | Boolean | A Boolean value that specifies whether this component should reuse values for communityId, sort, category, and status that are used on the page containing this link. | | 43.0 | |
| style | String | The style used to display the listOutputLink component, used primarily for adding inline CSS styles. | | 43.0 | |
| styleClass | String | The style class used to display the listOutputLink component, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | | 43.0 | |

---

### ideas:profileListOutputLink

A link to the page displaying a user's profile.

```xml
<!-- Page: profilePage -->
<apex:page standardController="Idea" recordSetVar="ideaSetVar">
    <apex:pageBlock>
        <ideas:profileListOutputLink sort="recentReplies" page="profilePage">Recent
Replies</ideas:profileListOutputLink>
        |
        <ideas:profileListOutputLink sort="ideas" page="profilePage">Ideas
Submitted</ideas:profileListOutputLink>
        |
        <ideas:profileListOutputLink sort="votes" page="profilePage">Ideas
Voted</ideas:profileListOutputLink>
    </apex:pageBlock>
    <apex:pageBlock >
        <apex:dataList value="{!ideaList}" var="ideadata">
            <apex:outputText value="{!ideadata.title}"/>
        </apex:dataList>
    </apex:pageBlock>
</apex:page>
```

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| communityId | String | The ID for the zone in which the ideas are displayed. If communityID is not set, the zone is defaulted to an active zone accessible to the user. If the user has access to more than one zone, the zone whose name comes first in the alphabet is used. | | 43.0 | |
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| page | ApexPages.PageReference | The Visualforce page whose URL is used for the output link. This page must use the set oriented standard controller. | Yes | 43.0 | |
| pageNumber | Integer | The desired page number for the list of ideas (20 per page). E.g. if there are 100 ideas, pageNumber="2" would show ideas 21-40. | | 43.0 | |
| pageOffset | Integer | The desired page offset from the current page. If pageNumber is set, then the pageOffset value is not used. If neither pageNumber nor pageOffset are set, the resulting link does not have a page specified and the controller defaults to the first page. | | 43.0 | |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |
| sort | String | The desired sort for the list of ideas. Possible values include "ideas", "votes", and "recentReplies." | | 43.0 | |
| stickyAttributes | Boolean | A Boolean value that specifies whether this component should reuse values for userId, communityId, and sort that are used on the page containing this link. | | 43.0 | |
| style | String | The style used to display the profileListOutputLink component, used primarily for adding inline CSS styles. | | 43.0 | |
| styleClass | String | The style class used to display the profileListOutputLink component, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | | 43.0 | |
| userId | String | The ID of the user whose profile is displayed. | | 43.0 | |

---

## knowledge (5)

### knowledge:articleCaseToolbar

UI component used when an article is opened from the case detail page.

> This component shows current case information and lets the user attach the article to the case.

```xml
<apex:page standardController="FAQ__kav" sidebar="false" >
    <knowledge:articleCaseToolbar
        rendered="{!$CurrentPage.parameters.caseId != null}"
        caseId="{!$CurrentPage.parameters.caseId}"
        articleId="{!$CurrentPage.parameters.id}" />
    <h1>{!FAQ__kav.Title}</h1><br />
 </apex:page>
```

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| articleId | String | Id of the current article. | Yes | 43.0 | |
| caseId | String | Id of the current case. | Yes | 43.0 | |
| id | String | An identifier that allows the component to be referenced by other components on the page. | | 14.0 | global |
| includeCSS | Boolean | Specifies whether this component must include the CSS. Default is true. | | 43.0 | |
| rendered | Boolean | Specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |

---

### knowledge:articleList

A loop on a filtered list of articles.

> A loop on a filtered list of articles. You can use this component up to four times on the same page. Note that you can only specify one criterion for each data category and that only standard fields are accessible, such as:
> - `ID` (string): the ID of the article
> - `Title` (string): the title of the article
> - `Summary` (string): the summary of the article
> - `urlName` (string): the URL name of the article
> - `articleTypeName` (string): the developer name of the article type
> - `articleTypeLabel` (string): the label of the article type
> - `lastModifiedDate` (date): the date of the last modification
> - `firstPublishedDate` (date): the date of the first publication
> - `lastPublishedDate` (date): the date of the last publication

```xml
<apex:outputPanel layout="block">
    <ul>
        <knowledge:articleList articleVar="article"
            categories="products:phone"
            sortBy="mostViewed"
            pageSize="10"
        >
            <li><a href="{!URLFOR($Action.KnowledgeArticle.View,
article.id)}">{!article.title}</a></li>
        </knowledge:articleList>
    </ul>
</apex:outputPanel>
```

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| articleTypes | String | The article list can be filtered by article types. | | 43.0 | |
| articleVar | String | The name of the variable that can be used to represent the article object in the body of the articleList component. | Yes | 43.0 | |
| categories | String | The article list can be filtered by data categories. | | 43.0 | |
| hasMoreVar | String | The boolean variable name indicating whether the list contains more articles. | | 43.0 | |
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| isQueryGenerated | Boolean | Flag indicating whether this article list was produced from a generated query that did not originate from the user. | | 43.0 | |
| keyword | String | The search keyword if the search is not null. When the keyword attribute is specified, the results are sorted by keyword relevance and the sortBy attribute is ignored. | | 43.0 | |
| language | String | The language in which the articles must be retrieved. | | 43.0 | |
| pageNumber | Integer | The current page number. | | 43.0 | |
| pageSize | Integer | The number of articles displayed at once. The total number of articles displayed in a page cannot exceed 200. | | 43.0 | |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |
| sortBy | String | The sort value applied to the article list: 'mostViewed,' 'lastUpdated,' and 'title'. When the keyword attribute is specified, the sortBy attribute is ignored. | | 43.0 | |

---

### knowledge:articleRendererToolbar

Displays a header toolbar for an article.

> This toolbar includes voting stars, a Chatter feed, a language picklist and a properties panel. Ext JS versions less than 3 should not be included on pages that use this component.

```xml
<apex:page standardController='FAQ__kav' showHeader='false' sidebar='false'>
    <knowledge:articleRendererToolBar
        articleId="{! $CurrentPage.parameters.id}"
    />
</apex:page>
```

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| articleId | String | The id of the article. | | 43.0 | |
| canVote | Boolean | If true, the vote component is editable. If false, it is readonly. | | 43.0 | |
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| includeCSS | Boolean | Specifies whether this component must include the CSS | | 43.0 | |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |
| showChatter | Boolean | Set this to true if Chatter is enabled, and the article renderer requires a feed | | 43.0 | |

---

### knowledge:articleTypeList

A loop on all available article types.

```xml
<knowledge:articleTypeList articleTypeVar="articleType">
     {!articleType.label}<br />
</knowledge:articleTypeList>
```

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| articleTypeVar | String | The name of the variable that can be used to represent the article type object in the body of the articleTypeList component. | Yes | 43.0 | |
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |

---

### knowledge:categoryList

A loop on a subset of the category hierarchy.

> A loop on a subset of the category hierarchy. The total number of categories displayed in a page can't exceed 500. You must have access to the category you set as rootCategory to get a list of any categories. To list categories available to a user, see the Knowledge Support REST APIs.

```xml
<select name="category">
    <knowledge:categoryList categoryVar="category" categoryGroup="product"
rootCategory="phone" level="-1">
        <option value="{!category.name}">{!category.label}</option>
    </knowledge:categoryList>
</select>
```

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| ancestorsOf | String | If specified, the component will enumerate the category hierarchy up to the root (top-level) category. rootCategory can be used to specify the top-level category. | | 43.0 | |
| categoryGroup | String | The category group to which the individual categories belong. | Yes | 43.0 | |
| categoryVar | String | The name of the variable that can be used to represent the article type object in the body of the categoryList component. | Yes | 43.0 | |
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| level | Integer | If specified with rootCategory, the component will stop at this specified depth in the category hierarchy. -1 means unlimited. | | 43.0 | |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |
| rootCategory | String | If specified without ancestorsOf, the component will loop on the descendents of this category. | | 43.0 | |

---

## liveAgent (13)

> 네임스페이스 공통 — 거의 모든 `liveAgent:*` 컴포넌트는 `<liveAgent:clientChat>` 안에서만 사용한다. 각 컴포넌트 설명 원문에 보존.

### liveAgent:clientChat

The main parent element for any chat window.

> The main parent element for any chat window. You must create this element in order to do any additional customization of Chat. Chat must be enabled for your organization. Note that this component can only be used once in a Chat deployment.

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |

---

### liveAgent:clientChatAlertMessage

The area in a Live Agent chat window that displays system alert messages (such as "You have been disconnected").

> Must be used within `<liveAgent:clientChat>`. Each chat window can have only one alert message area.

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| agentsUnavailableLabel | String | A string specifying the label that appears when all agents become unavailable; the default English label is "Your chat request has been canceled because no agents are available." | | 27.0 | |
| chatBlockedLabel | String | Specifies the message that appears to a customer who has been blocked from chatting with an agent. The default message is "You have been blocked from the chat." | | 27.0 | |
| connectionErrorLabel | String | A string specifying the label that appears when there is a connection error; the default English label is "Connection Lost: Please check your local connection." | | 27.0 | |
| dismissLabel | String | A string specifying the label that appears to dismiss the alert; the default English label is "Close." | | 27.0 | |
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| internalFailureLabel | String | A string specifying the label that appears when there is an internal error; the default English label is "Chat isn't available. Please try again later." | | 27.0 | |
| noCookiesLabel | String | A string specifying the label that appears when cookies are disabled; the default English label is "Your browser is not currently accepting cookies. Cookies are required to request a chat. Please enable cookies and try again." | | 27.0 | |
| noFlashLabel | String | A string specifying the label that appears when Flash is not installed; the default English label is "The Flash Player or an HTML5 compatible web browser is necessary to chat. Please install Flash player or use a different web browser." | | 27.0 | |
| noHashLabel | String | A string specifying the label that appears when the chat window is improperly launched; the default English label is "The chat window may only be launched from a button -- you cannot access it directly." | | 27.0 | |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |

See also: `liveAgent:clientChat`

---

### liveAgent:clientChatCancelButton

The button within a chat window a visitor clicks to cancel a chat session.

> Must be used within `<liveAgent:clientChat>`.

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| label | String | The label that appears on the button. The default English label is "Cancel Chat". | | 34.0 | |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |

See also: `liveAgent:clientChat`

---

### liveAgent:clientChatEndButton

The button within a chat window a visitor clicks to end a chat session.

> Must be used within `<liveAgent:clientChat>`.

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| label | String | A string specifying the label that appears on the button; the default English label is "End Chat". | | 24.0 | |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |

See also: `liveAgent:clientChat`

---

### liveAgent:clientChatFileTransfer

The file upload area in a chat window where a visitor can send a file to an agent.

> Must be used within `<liveAgent:clientChat>`. Each chat window can have only one file upload.

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| fileTransferCanceledLabel | String | A string specifying the message that appears in the chat log when the file transfer request is canceled; the default English label is "The agent has canceled the file transfer request.". | | 30.0 | |
| fileTransferCancelFileLabel | String | A string specifying the label for the button to be clicked to cancel the file transfer; the default English label is "Cancel". | | 30.0 | |
| fileTransferDropFileLabel | String | A string specifying the label that indicates where the file can be dropped; the default English label is "Drop here.". | | 30.0 | |
| fileTransferFailedLabel | String | A string specifying the message that appears in the chat log when the file transfer fails; the default English label is "Your file upload failed. Please wait for instructions from the agent.". | | 30.0 | |
| fileTransferSendFileLabel | String | A string specifying the label for the button to be clicked to upload the file; the default English label is "Send File". | | 30.0 | |
| fileTransferSuccessfulLabel | String | A string specifying the message that appears in the chat log when the file transfer is successful; the default English label is "Your file has been successfully uploaded to the agent.". | | 30.0 | |
| fileTransferUploadLabel | String | A string specifying the label that appears as a link which can be clicked to select a file to be uploaded; the default English label is "Upload or drag your file here.". | | 30.0 | |
| fileTransferUploadMobileLabel | String | A string specifying the label for mobile that appears as a link which can be clicked to select a file to be uploaded; the default English label is "Upload your file here.". | | 30.0 | |
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |

See also: `liveAgent:clientChat`

---

### liveAgent:clientChatInput

The text box in a chat window where a visitor types messages to an agent.

> Must be used within `<liveAgent:clientChat>`. Each chat window can have only one input box.

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| autoResizeElementId | String | Specifies the HTML element that should be dynamically resized when the transcript exceeds a certain length. | | 24.0 | |
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |
| useMultiline | Boolean | Specifies whether a customer chat window supports a multiple-line text input field (true) or not (false). | | 24.0 | |

See also: `liveAgent:clientChat`

---

### liveAgent:clientChatLog

The area in a chat window that displays the chat transcript to a visitor.

> Must be used within `<liveAgent:clientChat>`. Each chat window can have only one chat log.

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| agentTypingLabel | String | A string specifying the label that appears when the agent is typing a message; the default English label is "The agent is typing." | | 24.0 | |
| chatEndedByAgentLabel | String | A string specifying the label that appears when the agent has ended the chat; the default English label is "The chat has been ended by the agent." | | 24.0 | |
| chatEndedByVisitorIdleTimeoutLabel | String | A string specifying the label that appears when the chat is ended by visitor idle (customer) time-out; the default English label is "Chat session ended by visitor idle time-out." | | 24.0 | |
| chatEndedByVisitorLabel | String | A string specifying the label that appears when the visitor has ended the chat; the default English label is "You've ended the chat." | | 24.0 | |
| chatTransferredLabel | String | A string specifying the label that appears when the chat has been transferred to a new agent; the default English label is "{OperatorName} is your new agent for the chat session." ({OperatorName} defaults to '[First Name] [Last Initial]' of the Salesforce user or the Custom Agent Name as set in the Chat Configuration.) | | 24.0 | |
| combineMessagesText | Boolean | Specifies whether the chat log displayed in the customer chat window should support combined messages based on the user ID (true) or not (false). Note: If you turn this on for existing custom chat windows, it will change your markup and you may need to modify your CSS. | | 24.0 | |
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |
| showTimeStamp | Boolean | Specifies whether the chat log displayed in the customer chat window should display the timestamp text input field (true) or not (false). | | 24.0 | |
| visitorNameLabel | String | A string specifying the label that appears next to the messages that the visitor sends; the default English label is "Me". | | 24.0 | |

See also: `liveAgent:clientChat`

---

### liveAgent:clientChatLogAlertMessage

The area in a chat window that displays the idle time-out alert (customer warning) to a visitor.

> Must be used within `<liveAgent:clientChat>`. Each chat window can have only one idle time-out alert.

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| autoResizeElementId | String | Specifies the ID of the sibling HTML element that should be dynamically resized when the chat log alert height changes. | | 35.0 | |
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |
| respondToChatLabel | String | A string specifying the label that appears on the chat window title during the customer time-out warning; the default English label is "Respond to Chat" | | 35.0 | |
| respondWithinTimeLabel | String | A string specifying the label that appears as a warning during customer time-out; the default English label is "Are you still there? Please respond within `<span id="liveAgentChatLogAlertTimer">{Time}</span>` or this chat will time out." {Time} presents a countdown timer to the visitor. | | 35.0 | |

See also: `liveAgent:clientChat`

---

### liveAgent:clientChatMessages

The area in a chat window that displays system status messages (such as "Chat session has been disconnected").

> Must be used within `<liveAgent:clientChat>`. Each chat window can have only one message area.

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |

See also: `liveAgent:clientChat`

---

### liveAgent:clientChatQueuePosition

A text label indicating a visitor's position within a queue for a chat session initiated via a button that uses push routing.

> (On buttons that use pull routing, this component has no effect.) Must be used within `<liveAgent:clientChat>`.

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| label | String | A string specifying the label that appears to display the queue position; the default English label is "". | | 24.0 | |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |

See also: `liveAgent:clientChat`

---

### liveAgent:clientChatSaveButton

The button in a chat window a visitor clicks to save the chat transcript as a local file.

> Must be used within `<liveAgent:clientChat>`. Each chat window can have multiple save buttons.

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| label | String | A string specifying the label that appears on the button; the default English label is "Save Chat". | | 24.0 | |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |

See also: `liveAgent:clientChat`

---

### liveAgent:clientChatSendButton

The button in a chat window a visitor clicks to send a chat message to an agent.

> Must be used within `<liveAgent:clientChat>`. Each chat window can have multiple send buttons.

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| label | String | A string specifying the label that appears on the button; the default English label is "Send". | | 24.0 | |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |

See also: `liveAgent:clientChat`

---

### liveAgent:clientChatStatusMessage

The area in a chat window that displays system status messages (such as "You are being reconnected").

> Must be used within `<liveAgent:clientChat>`. Each chat window can have only one status message area.

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| reconnectingLabel | String | A string specifying the label that appears when there is network latency or disruption; the default English label is "You've been disconnected from the agent. Please wait while we attempt to re-establish the connection..." | | 27.0 | |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |

See also: `liveAgent:clientChat`

---

## messaging (5)

> 이 네임스페이스의 사용법·이메일 템플릿 전반은 [[이메일·차트·맵·Flow·템플릿]]에 정리돼 있다. **속성표 정본은 이 노트**다.

### messaging:attachment

Compose an attachment and append it to the email.

```xml
<messaging:emailTemplate recipientType="Contact"
 relatedToType="Account"
 subject="Case report for Account: {!relatedTo.name}"
 replyTo="support@example.com">

  <messaging:htmlEmailBody>
  <html>
   <body>
   <p>Dear {!recipient.name},</p>
   <p>Attached is a list of cases related to {!relatedTo.name}.</p>
   <center>
   <apex:outputLink value="https://salesforce.com">
    For more detailed information log in to Salesforce.com
   </apex:outputLink>
   </center>
   </body>
  </html>
  </messaging:htmlEmailBody>

  <messaging:attachment renderAs="PDF" filename="yourCases.pdf">
  <html>
   <body>
   <p>You can display your {!relatedTo.name} cases as a PDF</p>

  <table border="0" >
  <tr>
   <th>Case Number</th><th>Origin</th>
   <th>Creator Email</th><th>Status</th>
  </tr>
  <apex:repeat var="cx" value="{!relatedTo.Cases}">
  <tr>
   <td><a href =
        "https://na1.salesforce.com/{!cx.id}">{!cx.CaseNumber}
    </a></td>
   <td>{!cx.Origin}</td>
   <td>{!cx.Contact.email}</td>
   <td>{!cx.Status}</td>
  </tr>
  </apex:repeat>
  </table>
  </body>
 </html>
 </messaging:attachment>
</messaging:emailTemplate>
```

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| filename | String | Sets a file name on the attachment. If a filename isn't provided, one is generated for you. | | 14.0 | |
| id | String | An identifier that other components in the page use to reference the attachment component. | | 14.0 | global |
| inline | Boolean | Sets the HTTP Content-Disposition header of the attachment in the email to inline. | | 17.0 | |
| renderAs | String | Indicates how the attachment is rendered. The default value is "text". Although any MIME type/subtype is a valid renderAs value, Visualforce supports content conversion on page 71 of only PDFs. Visualforce doesn't generate other file formats. It only sets the Content-Type field of the HTTP response header to the specified MIME type. Some file formats, such as .xlsx, can fail to render. | | 14.0 | |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |

> [sic] `renderAs` 설명의 "content conversion on page 71 of only PDFs" — PDF 본문 cross-reference 텍스트가 그대로 추출됨(의미: "supports content conversion of only PDFs"). 원문 보존.

See also: Visualforce Email Templates / Add Attachments to a Visualforce Email Template

---

### messaging:emailHeader

Adds a custom header to the email.

> Adds a custom header to the email. The body of a header is limited to 1000 characters.

```xml
<messaging:emailTemplate recipientType="Contact"
 relatedToType="Account"
 subject="Testing a custom header"
 replyTo="support@acme.com">

  <messaging:emailHeader name="customHeader">
   BEGIN CUSTOM HEADER
   Account Id: {!relatedTo.Id}
   END CUSTOM HEADER
  </messaging:emailHeader>

  <messaging:htmlEmailBody >
  <html>
  <body>

 <p>Dear {!recipient.name},</p>
    <p>Check out the header of this email!</p>
 </body>
 </html>
 </messaging:htmlEmailBody>
</messaging:emailTemplate>
```

위 예제가 렌더링하는 HTML 헤더:

```
Date: Thu, 5 Feb 2009 19:35:59 +0000
From: Admin User <support@salesforce.com>
Sender: <no-reply@salesforce.com>
Reply-To: support@acme.com
To: "admin@salesforce.com" <admin@salesforce.com>
Message-ID: <19677436.41233862559806.JavaMail.admin@admin-WS>
Subject: Testing a custom header
MIME-Version: 1.0
Content-Type: multipart/alternative;
boundary="----=_Part_8_14667134.1233862559806"
X-SFDC-X-customHeader: BEGIN CUSTOM HEADER Account Id: 001x000xxx3BIdoAAG END CUSTOM HEADER
X-SFDC-LK: 00Dx000000099jh
X-SFDC-User: 005x0000000upVu
X-Sender: postmaster@salesforce.com
X-mail_abuse_inquiries: https://salesforce.com/company/abuse.jsp
X-SFDC-Binding: 1WrIRBV94myi25uB
X-OriginalArrivalTime: 05 Feb 2009 19:35:59.0747 (UTC) FILETIME=[F8FF7530:01C987C8]
X-MS-Exchange-Organization-SCL: 0
```

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| id | String | An identifier that allows the emailHeader component to be referenced by other components in the page. | | 14.0 | global |
| name | String | The name of the header. Note: X-SFDC-X- is prepended to the name. | Yes | 14.0 | |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |

See also: Visualforce Email Templates

---

### messaging:emailTemplate

Defines a Visualforce email template.

> Defines a Visualforce email template. All email template tags must be wrapped inside a single emailTemplate component tag. emailTemplate must contain either an htmlEmailBody tag or a plainTextEmailBody tag. The detail and form components are not permitted as child nodes. This component can only be used within a Visualforce email template. Email templates can be created and managed through Setup | Communication Templates | Email Templates.

```xml
<messaging:emailTemplate recipientType="Contact"
    relatedToType="Account"
    subject="Your account's cases"
    replyTo="cases@acme.nomail.com" >

      <messaging:htmlEmailBody >
      <html>
          <body>
          <p>Hello {!recipient.name}--</p>
         <p>Here is a list of the cases we currently have for account {!relatedTo.name}:</p>

         <apex:datatable cellpadding="5" var="cx" value="{!relatedTo.Cases}">
             <apex:column value="{!cx.CaseNumber}" headerValue="Case Number"/>
             <apex:column value="{!cx.Subject}" headerValue="Subject"/>
             <apex:column value="{!cx.Contact.email}" headerValue="Creator's Email" />
             <apex:column value="{!cx.Status}" headerValue="Status" />
         </apex:datatable>
         </body>
     </html>
     </messaging:htmlEmailBody>

     <messaging:attachment renderas="pdf" filename="cases.pdf">
         <html>
         <body>
         <h3>Cases currently associated with {!relatedTo.name}</h3>
         <apex:datatable border="2" cellspacing="5" var="cx" value="{!relatedTo.Cases}">
             <apex:column value="{!cx.CaseNumber}" headerValue="Case Number"/>
             <apex:column value="{!cx.Subject}" headerValue="Subject"/>
             <apex:column value="{!cx.Contact.email}" headerValue="Creator's Email" />
             <apex:column value="{!cx.Status}" headerValue="Status" />
         </apex:datatable>
         </body>
         </html>
     </messaging:attachment>

    <messaging:attachment filename="cases.csv" >
        <apex:repeat var="cx" value="{!relatedTo.Cases}">
            {!cx.CaseNumber}, {!cx.Subject}, {!cx.Contact.email}, {!cx.Status}
        </apex:repeat>
    </messaging:attachment>
</messaging:emailTemplate>
```

**번역 템플릿 예제 (Translated Template Example):**

```xml
<!-- This example requires that Label Workbench is enabled and that you have created the
referenced labels. The example assumes that the Contact object has a custom language field
 that contains a valid language key. -->

<messaging:emailTemplate recipientType="Contact"
 relatedToType="Account"
 language="{!recipient.language__c}"
 subject="{!$Label.email_subject}"
 replyTo="cases@acme.nomail.com" >

  <messaging:htmlEmailBody >
  <html>
   <body>
   <p>{!$Label.email_greeting} {!recipient.name}--</p>
   <p>{!$Label.email_body}</p>
   </body>
  </html>
  </messaging:htmlEmailBody>

    </messaging:emailTemplate>
```

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| id | String | An identifier that allows the emailTemplate component to be referenced by other components in the page. | | 14.0 | global |
| language | String | The language used to display the email template. Valid values: Salesforce-supported language keys, for example, "en" or "en-US". Accepts merge fields from recipientType and relatedToType. | | 18.0 | |
| recipientType | String | The Salesforce object receiving the email. | | 14.0 | |
| relatedToType | String | The Salesforce object from which the template retrieves merge field data. Valid objects: objects that have a standard controller, including custom objects Visualforce supports. | | 14.0 | |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |
| replyTo | String | Sets the reply-to email header. | | 14.0 | |
| subject | String | Sets the email subject line. Limit: 100 characters. | Yes | 14.0 | |

See also: Visualforce Email Templates

---

### messaging:htmlEmailBody

The HTML version of the email body.

```xml
<messaging:emailTemplate recipientType="Contact"
 relatedToType="Account"
 subject="Case report for Account: {!relatedTo.name}"
 replyTo="support@acme.com">
  <messaging:htmlEmailBody>
  <html>
  <style type="text/css">
   body {font-family: Courier; size: 12pt;}

                 table {
                 border-width: 5px;
                 border-spacing: 5px;
                 border-style: dashed;
                 border-color: #FF0000;
               background-color: #FFFFFF;
               }

               td {
               border-width: 1px;
               padding: 4px;
               border-style: solid;
               border-color: #000000;
               background-color: #FFEECC;
               }

               th {
               color: #000000;
               border-width: 1px ;
               padding: 4px ;
               border-style: solid ;
               border-color: #000000;
               background-color: #FFFFF0;
               }
   </style>
   <body>
               <p>Dear {!recipient.name},</p>
               <p>Below is a list of cases related to {!relatedTo.name}.</p>
               <table border="0" >
                <tr>
                <th>Case Number</th><th>Origin</th>
                <th>Creator Email</th><th>Status</th>
               </tr>
               <apex:repeat var="cx" value="{!relatedTo.Cases}">
                <tr>
                 <td><a href =
                  "https://na1.salesforce.com/{!cx.id}">{!cx.CaseNumber}
                 </a></td>
                 <td>{!cx.Origin}</td>
                 <td>{!cx.Contact.email}</td>
                 <td>{!cx.Status}</td>
                </tr>
               </apex:repeat>
               </table>
               <p/>
               <center>
                <apex:outputLink value="https://salesforce.com">
                For more detailed information login to Salesforce.com
               </apex:outputLink>
               </center>

  </body>
  </html>
 </messaging:htmlEmailBody>
</messaging:emailTemplate>
```

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| id | String | An identifier that allows the htmlEmailBody component to be referenced by other components in the page. | | 14.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |

See also: Visualforce Email Templates

---

### messaging:plainTextEmailBody

The plain text (non-HTML) version of the email body.

```xml
<messaging:emailTemplate recipientType="Contact"
 relatedToType="Account"
 subject="Case report for Account: {!relatedTo.name}"
 replyTo="support@acme.com">

  <messaging:plainTextEmailBody>
   Dear {!recipient.name},

   Below is a list of cases related to {!relatedTo.name}.

   <apex:repeat var="cx" value="{!relatedTo.Cases}">
    Case Number: {!cx.CaseNumber}
    Origin: {!cx.Origin}
    Contact-email: {!cx.Contact.email}
    Status: {!cx.Status}
   </apex:repeat>

   For more detailed information login to Salesforce.com

  </messaging:plainTextEmailBody>

</messaging:emailTemplate>
```

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| id | String | An identifier that allows the plainTextEmailBody component to be referenced by other components in the page. | | 14.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |

---

## site (2)

### site:googleAnalyticsTracking

The standard component used to integrate Google Analytics with Force.com sites to track and analyze site usage.

> Add this component just once, either on the site template for the pages you want to track, or the individual pages themselves. Don't set the component for both the template and the page. Attention: This component only works on pages used in a Force.com site. Sites must be enabled for your organization and the Analytics Tracking Code field must be populated. To get a tracking code, go to the Google Analytics website.

```xml
<!-- Google Analytics recommends adding the component at the bottom of the page to avoid
  increasing page load time. -->
<site:googleAnalyticsTracking/>
```

위 예제가 렌더링하는 HTML:

```html
<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js'
type='text/javascript'%3E%3C/script%3E"));
</script>

<script>
 try {
    var pageTracker = _gat._getTracker("{!$Site.AnalyticsTrackingCode}");
     if ({!isCustomWebAddressNull}) {
       pageTracker._setCookiePath("{!$Site.Prefix}/");
    }
    else if ({!isCustomWebAddress}) {
       pageTracker._setAllowLinker(true);
       pageTracker._setAllowHash(false);
       }
     else {
       pageTracker._setDomainName("none");
       pageTracker._setAllowLinker(true);
       pageTracker._setAllowHash(false);
     }
  pageTracker._trackPageview();
  }
  catch(err) {
  }
</script>
```

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |

---

### site:previewAsAdmin

This component shows detailed error messages on a site in administrator preview mode.

> We recommend that you add it right before the closing apex:page tag. Note: The site:previewAsAdmin component contains the apex:messages tag, so if you have that tag elsewhere on your error pages, you will see the error message twice.

```xml
<!-- We recommend adding this component right before your closing apex:page tag. -->
<site:previewAsAdmin/>
```

위 예제가 렌더링하는 HTML:

```html
<span id="j_id0:j_id50">
<span id="j_id0:j_id50:j_id51:j_id52">
<div style="border-color:#FF9900; border-style:solid; border-width:1px;
padding:5px 0px 5px 6px; background-color:#FFFFCC; font-size:10pt;
margin-right:210px; margin-left:210px; margin-top:25px;">
 <table cellpadding="0" cellspacing="0">
 <tbody><tr>
  <td><img src="/img/sites/warning.png" height="40"
  style="padding:5px;margin:0px;" width="40" /></td>
  <td> <strong><ul id="j_id0:j_id50:j_id51:msgs3"
   style="margin:5px;"><li>Page not found:test </li></ul>
  </strong>
  <a href="/sites/servlet.SiteDebugMode?logout=1"
  style="padding:40px;margin:15px;">Logout of Administrator Preview Mode</a>
  </td>
 </tr> </tbody>
 </table>
</div>
</span>
</span>
```

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |

---

## social (1)

### social:profileViewer

UI component that adds the Social Accounts and Contacts viewer to Account (including person account), Contact, or Lead detail pages.

> The viewer displays the record name, a profile picture, and the social network icons that allow users to sign in to their accounts and view social data directly in Salesforce. Social Accounts and Contacts must be enabled for your organization. Note that this component is only supported for Account, Contact, and Lead objects and can only be used once on a page. This component isn't available for Visualforce pages on Force.com sites.

> **Note (원문 보존):** The Social Accounts, Contacts, and Leads feature is now unavailable. See Twitter/X Public API Access.

```xml
<apex:page standardController="Contact">
  <social:profileViewer entityId="{!contact.id}"/>
</apex:page>
```

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| entityId | id | Entity ID of the record for which to display the Social Accounts and Contacts viewer; for example, Contact.Id. | Yes | 24.0 | |
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |

---

## support (5 — 3개 중복 위임 / 2개 신규)

> Case Feed 전용 3개 컴포넌트(`support:caseArticles` · `support:caseFeed` · `support:portalPublisher`)의 속성표 정본은 [[Case Feed Visualforce 커스터마이즈]]에 있다. 아래 deep-link 1줄씩만 둔다.

- **support:caseArticles** — Displays the case articles tool (currently-attached articles and/or an article keyword search). Case Feed + Knowledge 활성 조직 전용. → 속성표는 [[Case Feed Visualforce 커스터마이즈]] 참조.
- **support:caseFeed** — The Case Feed component includes all of the elements of the standard Case Feed page (publishers, case activity feed, feed filters, highlights panel). Case Feed 활성 조직 전용. → 속성표는 [[Case Feed Visualforce 커스터마이즈]] 참조.
- **support:portalPublisher** — The Portal publisher lets support agents who use Case Feed compose and post portal messages. Case Feed 활성 조직 전용. → 속성표는 [[Case Feed Visualforce 커스터마이즈]] 참조.

### support:caseUnifiedFiles

Displays the Files component.

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| entityId | String | Entity ID of the record for which to display the milestones. | Yes | 31.0 | |
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |

> [sic] `entityId` 설명이 "...to display the milestones."(Files 컴포넌트인데 설명은 milestones 언급) — PDF 원문 오류 그대로 보존.

---

### support:clickToDial

A component that renders a valid phone number as click-to-dial enabled for Open CTI for Salesforce Classic or Salesforce CRM Call Center.

> This field respects any existing click-to-dial commands for computer-telephony integrations (CTI) with Salesforce.

> **Note (원문 전체 보존):**
> - If you create a Visualforce page with a custom console component, you must set the showHeader attribute to true. If this attribute is set to false, click-to-dial is disabled.
> - This component works with Open CTI for Lightning Experience.
> - This component doesn't support Open CTI Phone iFrames.
> - This component works with the enableClickToDial, disableClickToDial, and onClickToDial Open CTI methods.
> - This component doesn't work with embedded Visualforce pages within standard page layouts in Salesforce Classic.

```xml
<apex:page standardController="Account" showHeader="true">
    <support:clickToDial
        number="415-555-1234"
        entityId="001XB000000HFUM"
        params="myparam1,myparam2"
    />
</apex:page>
```

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| entityId | String | The entity ID of the record from which to invoke click-to-dial. | | 28.0 | |
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| number | String | The phone number that invokes click-to-dial functionality. | Yes | 28.0 | |
| params | String | Optional parameters related to when click-to-dial is invoked, such as any case or account parameters. | | 28.0 | |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |

See also: Open CTI Developer Guide: Methods for Lightning Experience

---

## topics (1)

### topics:widget

UI component that displays topics assigned to a record and allows users to add and remove topics.

> The UI component is available only if topics are enabled for these supported objects: accounts, assets, campaigns, cases, contacts, contracts, leads, opportunities, and custom objects.

```xml
<apex:page>
 <topics:widget entity="0D5x00000009Fhc"
customUrl="http://mywebsite/TopicViewTestPage?topicId="/>
</apex:page>
```

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| customUrl | string | The custom URL to a topic page. Salesforce adds the topicId to the end of the URL provided. | | 29.0 | |
| entity | string | Entity ID of the record for which to display the feed; for example, Contact.Id | Yes | 29.0 | |
| hideSuccessMessage | Boolean | Hide the success message that appears when done assigning topics. Defaults to false. | | 29.0 | |
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |
| renderStyle | string | The style in which the topics widget is rendered. Acceptable values are "simple" and "enhanced". | | 29.0 | |

---

## wave (1)

### wave:dashboard

Use this component to add a Salesforce Analytics dashboard to a Visualforce page.

| Attribute Name | Type | Description | Required? | API Ver | Access |
|---|---|---|---|---|---|
| dashboardId | string | The unique ID of the dashboard. You can get a dashboard's ID, an 18-character code beginning with 0FK, from the dashboard's URL, or you can request it through the API. This attribute can be used instead of the developer name, but it can't be included if the name has been set. One of the two is required. | | 34.0 | |
| developerName | string | The unique developer name of the dashboard. You can request the developer name through the API. This attribute can be used instead of the dashboard ID, but it can't be included if the ID has been set. One of the two is required. | | 34.0 | |
| filter | string | (아래 filter 셀 전문 참조) | | 34.0 | |
| height | string | Specifies the height of the dashboard, in pixels. | | 34.0 | |
| hideOnError | Boolean | Controls whether or not users see a dashboard that has an error. When this attribute is set to true, if the dashboard has an error, it won't appear on the page. When set to false, the dashboard appears but doesn't show any data. An error can occur when a user doesn't have access to the dashboard or it has been deleted. | | 34.0 | |
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| openLinksInNewWindow | Boolean | If false, links to other dashboards will be opened in the same window. | | 34.0 | |
| rendered | Boolean | Specifies whether or not the component is rendered on the page. | | 34.0 | |
| showHeader | Boolean | If true, the dashboard is displayed with a header bar that includes dashboard information and controls. If false, the dashboard appears without a header bar. Note that the header bar automatically appears when either showSharing or showTitle is true. | | 41.0 | |
| showSharing | Boolean | If true, and the dashboard is sharable, then the dashboard shows the Share icon. If false, the dashboard doesn't show the Share icon. To show the Share icon in the dashboard, the smallest supported frame size is 800 x 612 pixels. | | 37.0 | |
| showTitle | Boolean | If true, the dashboard's title is included above the dashboard. If false, the dashboard appears without a title. | | 34.0 | |
| width | string | Specifies the width of the dashboard, in pixels or percent. Pixel values are simply the number of pixels, for example, 500. Percentage values specify the width of the containing HTML element and must include the percent sign, for example, 20%. If the specified width is too large for the device, the maximum device width is used. | | 34.0 | |

**`filter` 속성 Description 전문 (verbatim — JSON 문법 보존):**

> Adds selections or filters to the dashboard at runtime. You can filter dataset fields by variables or specified values. The filters are configured with JSON strings. For filtering by dimension, use this syntax:
> ```
> {'datasets' : {'dataset1': [ {'fields':['field1'], 'selection': ['!value1', '!value2']}, {'fields':['field2'], 'filter': { 'operator':'operator1', 'values': ['!value3', '!value4']}}]}}
> ```
> For filtering on measures, use this syntax:
> ```
> {'datasets' : {'dataset1': [ {'fields':['field1'], 'selection': ['!value1', '!value2']}, {'fields':['field2'], 'filter': { 'operator':'operator1', 'values':[ [!value3] ]}}]}}
> ```
> (위 measures 예제의 `values` 값은 PDF 원문에서 공백 없이 중첩 대괄호로 표기됨 — 여는 대괄호 2개, `!value3`, 닫는 대괄호 2개. 위키링크 오인을 막기 위해 안쪽 대괄호 사이에만 공백을 넣어 표시했고, 실제 JSON 값에는 공백이 없다.)
> datasets takes the dataset API name which is found on the dataset's edit page. (If your org has namespaces, include the namespace prefix and two underscores before the dataset system name.) fields takes dataset dimensions or measures. To find the names, select Show Details on the widget, and click the View Query Details icon. values can be specific values or fields in a Salesforce object. To find the name of a field, go to Setup, locate the object you want, and select Fields. Use the Field Name (also known as the API name). For custom fields, use the name with "__c" at the end. Note that values must have the format object.field. With the selection option, the dashboard is shown with all its data, and the specified dimension values are highlighted. The selection option can be used alone or with the filter option. Selection takes dimension values only. To use this option, the dashboard must include a list, date, or toggle widget that groups by the specified dimension. With the filter option, the dashboard is shown with only filtered data. The filter option can be used alone or with the selection option. Filter takes dimension or measure values. Use operator with the filter option. Supported operators for dimensions: in; not in; matches. Supported operators for measures: == ; != ; >= ; > ; <= ; >.
> Note: If a selection specifies a value that doesn't exist, or the dashboard doesn't include a list, date, or toggle widget that groups by the specified dimension, then the selection input is ignored and the dashboard appears with all its data and no selection.
> Note: To filter on a field that contains special characters, use Visualforce's JSENCODE function in the filter to replace special characters with encoded values.
> Note: The above syntax is for Spring '17 and later. The previous syntax continues to be supported, and it works the same as the new selection option. For reference, here's the previous syntax:
> ```
> { 'datasetSystemName1': {'field1': ['!value1']}, 'datasetSystemName2': {'field1': ['!value1', '!value2'], 'field2': ['!value3']} }
> ```

> [sic] "Supported operators for measures: == ; != ; >= ; > ; <= ; >." — 마지막 연산자가 `<` 대신 `>`로 표기됨(PDF 원문 오류, 추정상 `<` 이어야 함). 원문 그대로 보존.

---

## 관련 노트

- [[Case Feed Visualforce 커스터마이즈]] — support:caseArticles · support:caseFeed · support:portalPublisher 속성표 정본
- [[이메일·차트·맵·Flow·템플릿]] — messaging:* 사용법·Visualforce 이메일 템플릿·차트·Flow(이 노트는 messaging 속성표 정본)
- [[apex 컴포넌트 — 입력·폼]] (apex:inputField · apex:form 등 — Chatter publisher와 함께 쓰는 입력 컴포넌트)
- [[apex 컴포넌트 — 출력·데이터·반복·차트]] (apex:outputPanel · apex:repeat — knowledge:articleList 본문에서 사용)
- [[apex 컴포넌트 — 페이지·레이아웃 구조]] (apex:page · apex:pageBlock 등 — 모든 예제의 컨테이너)
- [[apex 컴포넌트 — AJAX·액션·Remote Objects·기타]] (apex:emailPublisher · apex:logCallPublisher 등 Case Feed 측 apex 컴포넌트)
- [[Visualforce 개요 — 도구·퀵스타트]] (Visualforce 전반 개요)
