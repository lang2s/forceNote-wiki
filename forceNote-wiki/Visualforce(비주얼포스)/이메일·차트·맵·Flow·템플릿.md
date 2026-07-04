---
tags: [visualforce, vf, email-template, charting, maps, flow, templating, legacy]
source: salesforce_pages_developers_guide.pdf (Visualforce Developer Guide, v67.0 Summer '26); help.salesforce.com — Email Deliverability & Sandbox 기본값 (id=000384750 / platform.data_sandbox_email_deliverability.htm, Tier 2); help.salesforce.com — Single Email Daily Limits & Email Limit Types (id=000384947 / id=000386730, Tier 2)
created: 2026-06-21
aliases: [Visualforce 이메일 템플릿, apex:chart, apex:map, flow:interview, apex:composition 템플릿, messaging emailTemplate]
---

# Visualforce — 이메일 · 차트 · 맵 · Flow · 템플릿

> Visualforce로 이메일을 보내고 이메일 템플릿·차트·맵을 만들고, Flow를 페이지에 임베드하고, `<apex:composition>`/`<apex:include>`로 페이지를 재사용하는 다섯 가지 영역(Developer Guide Ch14–18).

> **레거시 안내:** Visualforce는 레거시 UI 기술이며 신규 UI 개발은 LWC가 권장된다. 단 이메일 템플릿·PDF 렌더·Flow 임베드·기존 페이지 유지보수 맥락에서는 여전히 사용된다. (이 한 줄은 도메인 컨텍스트 안내이며 PDF 본문에 "legacy"라는 단어가 있는 것은 아니다.)

> **컴포넌트 attribute 상세는 위임:** 이 노트는 사용법·예제 중심이다. 각 컴포넌트(`<apex:chart>`·`<apex:map>`·`<flow:interview>` 등)의 전체 attribute 표는 Visualforce Developer Guide Part B — Standard Component Reference 소관이며, 해당 위키 노트가 아직 없어 본문 정리표(사용법 수준)로만 둔다.

> **시각 자료 안내:** 차트 렌더 결과(p.222–249)·맵 렌더 결과(p.250–261)·이메일 폼/렌더 화면·차트 컴포넌트 연결 다이어그램·Flow 데이터테이블 화면은 모두 PDF 스크린샷/다이어그램이며 pdftotext가 캡처하지 못한다. 본 노트는 PDF 캡션만 인용하고 `(PDF 스크린샷 — 텍스트만)`로 명시한다. 화면·다이어그램은 재현하지 않는다.

---

## 1. Visualforce로 이메일 보내기 (Ch14)

Visualforce로 contacts·leads·recipients에게 이메일을 보낼 수 있고, Salesforce 레코드를 순회하는 재사용 가능한 이메일 템플릿도 만들 수 있다. 아웃바운드 이메일은 Apex `Messaging.SingleEmailMessage` 클래스가 처리한다.

> `Messaging.SingleEmailMessage`·`Messaging.sendEmail`·`Messaging.EmailFileAttachment`의 클래스 레퍼런스 자체는 [[SingleEmailMessage]] / [[Messaging Namespace]] 참조. 이 절은 Visualforce 페이지·컨트롤러에서의 사용 패턴만 다룬다.

> [!warning] ⚠️ 전제조건 — Email Deliverability 접근 레벨
> 아래 컨트롤러 코드를 실행하기 전, org의 **Email Deliverability 접근 레벨**을 확인해야 한다. 새로 refresh된 샌드박스는 Deliverability가 기본 **'System email only'** 로 설정되어 있어, Apex/Visualforce에서 보내는 단일 이메일이 다음 예외로 차단된다:
> ```
> System.EmailException: NO_MASS_MAIL_PERMISSION,
> Single email is not enabled for your organization or profile
> ```
> **해결:** Setup → Email → **Deliverability** → **Access to Send Email** 을 **'All email'** 로 변경해야 코드가 정상 동작한다. (샌드박스는 실수로 실제 고객에게 메일이 나가는 것을 막기 위해 기본이 'System email only'다.)
>
> 근거: help.salesforce.com — NO_MASS_MAIL_PERMISSION on Email Sent via Apex Trigger (id=000384750) / Sandbox Email Deliverability 기본값 (platform.data_sandbox_email_deliverability.htm)

### 1.1 Messaging 클래스를 쓰는 커스텀 컨트롤러

최소 요건은 subject, body, recipient다. 폼 역할을 하는 페이지가 필요하다.

`sendEmailPage` 페이지:

```xml
<apex:page controller="sendEmail">
<apex:messages />
<apex:pageBlock title="Send an Email to Your
{!account.name} Representatives">
<p>Fill out the fields below to test how you might send an email to a user.</p>
<br />
<apex:dataTable value="{!account.Contacts}" var="contact" border="1">
<apex:column >
<apex:facet name="header">Name</apex:facet>
{!contact.Name}
</apex:column>
<apex:column >
<apex:facet name="header">Email</apex:facet>
{!contact.Email}
</apex:column>
</apex:dataTable>
<apex:form >
<br /><br />
<apex:outputLabel value="Subject" for="Subject"/>:<br />
<apex:inputText value="{!subject}" id="Subject" maxlength="80"/>
<br /><br />
<apex:outputLabel value="Body" for="Body"/>:<br />
<apex:inputTextarea value="{!body}" id="Body" rows="10" cols="80"/>
<br /><br /><br />
<apex:commandButton value="Send Email" action="{!send}" />
</apex:form>
</apex:pageBlock>
</apex:page>
```

account ID는 URL에서 가져온다. 유효한 account record와 페이지를 연결해야 한다. 예를 들어 account ID가 `001D000000IRt53`이면 URL은 `https://MyDomain_login_URL/apex/sendEmailPage?id=001D000000IRt53`이다.

`sendEmail` 컨트롤러:

```apex
public class sendEmail {
public String subject { get; set; }
public String body { get; set; }
private final Account account;
// Create a constructor that populates the Account object
public sendEmail() {
account = [select Name, (SELECT Contact.Name, Contact.Email FROM Account.Contacts)
from Account where id = :ApexPages.currentPage().getParameters().get('id')];
}
public Account getAccount() {
return account;
}
public PageReference send() {
// Define the email
Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
String addresses;
if (account.Contacts[0].Email != null)
{
addresses = account.Contacts[0].Email;
// Loop through the whole list of contacts and their emails
for (Integer i = 1; i < account.Contacts.size(); i++)
{
if (account.Contacts[i].Email != null)
{
addresses += ':' + account.Contacts[i].Email;
}
}
}
String[] toAddresses = addresses.split(':', 0);
// Sets the paramaters of the email
email.setSubject( subject );
email.setToAddresses( toAddresses );
email.setPlainTextBody( body );
// Sends the email
Messaging.SendEmailResult [] r =
Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
return null;
}
}
```

> 주석 `// Sets the paramaters of the email`는 PDF 원문의 `paramaters` 오타를 그대로 보존한 것이다. [sic]

- subject/body는 별도 Visualforce 페이지에서 설정해 컨트롤러로 전달한다.
- `send()` 메서드명은 Visualforce 버튼의 action명과 일치해야 한다.
- recipients(`toAddresses[]`)는 연관 account의 contacts 주소다. contacts/leads/records로 recipient 목록을 만들 때는 각 레코드에 email이 정의돼 있는지 loop로 확인하는 것이 good practice다.

> Note (한도 — Apex/API 단일 이메일 발송): 위 예제처럼 account의 모든 contact를 순회해 `toAddresses`에 넣는 패턴은 아래 하드 한도에 직접 부딪힌다.
> - **일일 외부 수신자 한도:** org당 하루 최대 **5,000개 외부 이메일 주소**로만 `SingleEmailMessage`를 발송할 수 있다. 초과 시 `SINGLE_EMAIL_LIMIT_EXCEEDED` 예외가 발생한다.
> - **단일 메시지당 수신자 한도:** To 최대 **100** / CC 최대 **25** / BCC 최대 **25** 수신자.
> - **내부 User는 한도 미포함:** `setTargetObjectId`로 내부 User(또는 Contact·Lead)에게 보내면 일일 외부 수신자 한도에 포함되지 않는다.
>
> 근거: help.salesforce.com — Single email daily limits (5,000 external addresses/day, id=000384947) / Overview of Salesforce Email Limit Types (id=000386730)

시각자료: "Example of the Form on sendEmailPage" — (PDF 스크린샷 — 텍스트만)

> SEE ALSO — Apex Developer Guide: Outbound Email

### 1.2 이메일 첨부 만들기

첨부는 Blob 파일 타입이며 `Messaging.EmailFileAttachment` 클래스를 쓴다. 파일 이름과 콘텐츠를 둘 다 정의해야 한다.

**PDF 첨부 추가** — PDF로 렌더되는 Visualforce 페이지의 PageReference를 첨부로 변환한다.

`attachmentPDF` 페이지:

```xml
<apex:page standardController="Account" renderAs="PDF">
<h1>Account Details</h1>
<apex:panelGrid columns="2">
<apex:outputLabel for="Name" value="Name"/>
<apex:outputText id="Name" value="{!account.Name}"/>
<apex:outputLabel for="Owner" value="Account Owner"/>
<apex:outputText id="Owner" value="{!account.Owner.Name}"/>
<apex:outputLabel for="AnnualRevenue" value="Annual Revenue"/>
<apex:outputText id="AnnualRevenue" value="{0,number,currency}">
<apex:param value="{!account.AnnualRevenue}"/>
</apex:outputText>
<apex:outputLabel for="NumberOfEmployees" value="Employees"/>
<apex:outputText id="NumberOfEmployees" value="{!account.NumberOfEmployees}"/>
</apex:panelGrid>
</apex:page>
```

> Note: PDF 첨부에 권장되는 컴포넌트는 "Best Practices for Rendering PDF Files"(PDF p.400) 참조. → 위키에서는 [[페이지 출력 제어 — HTML·PDF·SLDS]] 참조.

`send()` 메서드 안에서 `Messaging.sendEmail` 호출 전에 EmailFileAttachment를 생성한다:

```apex
// Reference the attachment page, pass in the account ID
PageReference pdf = Page.attachmentPDF;
pdf.getParameters().put('id',(String)account.id);
pdf.setRedirect(true);
// Take the PDF content
Blob b = pdf.getContent();
// Create the email attachment
Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
efa.setFileName('attachment.pdf');
efa.setBody(b);
```

SingleEmailMessage가 `email`이면 첨부를 연결한다:

```apex
email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
```

**커스텀 컴포넌트를 첨부로 정의** — 같은 커스텀 컴포넌트를 Visualforce 이메일 폼의 미리보기와 PDF 렌더에 함께 쓰면 사용자가 보낼 콘텐츠를 미리 볼 수 있다.

`attachment` 컴포넌트:

```xml
<apex:component access="global">
<h1>Account Details</h1>
<apex:panelGrid columns="2">
<apex:outputLabel for="Name" value="Name"/>
<apex:outputText id="Name" value="{!account.Name}"/>
<apex:outputLabel for="Owner" value="Account Owner"/>
<apex:outputText id="Owner" value="{!account.Owner.Name}"/>
<apex:outputLabel for="AnnualRevenue" value="Annual Revenue"/>
<apex:outputText id="AnnualRevenue" value="{0,number,currency}">
<apex:param value="{!account.AnnualRevenue}"/>
</apex:outputText>
<apex:outputLabel for="NumberOfEmployees" value="Employees"/>
<apex:outputText id="NumberOfEmployees" value="{!account.NumberOfEmployees}"/>
</apex:panelGrid>
</apex:component>
```

attachmentPDF 페이지는 다음으로 교체한다:

```xml
<apex:page standardController="account" renderAs="PDF">
<c:attachment/>
</apex:page>
```

sendEmailPage 하단에는 미리보기를 추가한다:

```xml
<apex:pageBlock title="Preview the Attachment for {!account.name}">
<c:attachment/>
</apex:pageBlock>
```

첨부와 미리보기를 둘 다 변경할 때 커스텀 컴포넌트 한 곳만 수정하면 된다.

**예제 — 첨부와 함께 이메일 보내기.** 커스텀 컴포넌트로 Visualforce 페이지를 첨부하는 전체 컨트롤러:

```apex
public class sendEmail {
public String subject { get; set; }
public String body { get; set; }
private final Account account;
// Create a constructor that populates the Account object
public sendEmail() {
account = [SELECT Name,
(SELECT Contact.Name, Contact.Email FROM Account.Contacts)
FROM Account
WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
}
public Account getAccount() {
return account;
}
public PageReference send() {
// Define the email
Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
// Reference the attachment page and pass in the account ID
PageReference pdf = Page.attachmentPDF;
pdf.getParameters().put('id',(String)account.id);
pdf.setRedirect(true);
// Take the PDF content
Blob b = pdf.getContent();
// Create the email attachment
Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
efa.setFileName('attachment.pdf');
efa.setBody(b);
String addresses;
if (account.Contacts[0].Email != null) {
addresses = account.Contacts[0].Email;
// Loop through the whole list of contacts and their emails
for (Integer i = 1; i < account.Contacts.size(); i++) {
if (account.Contacts[i].Email != null) {
addresses += ':' + account.Contacts[i].Email;
}
}
}
String[] toAddresses = addresses.split(':', 0);
// Sets the paramaters of the email
email.setSubject( subject );
email.setToAddresses( toAddresses );
email.setPlainTextBody( body );
email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
// Sends the email
Messaging.SendEmailResult [] r =
Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
return null;
}
}
```

Visualforce 페이지:

```xml
<apex:page controller="sendEmail">
<apex:messages/>
<apex:pageBlock title="Send an Email to Your {!account.name} Representatives">
<p>Fill out the fields below to test how you might send an email to a user.</p>
<apex:dataTable value="{!account.Contacts}" var="contact" border="1">
<apex:column>
<apex:facet name="header">Name</apex:facet>
{!contact.Name}
</apex:column>
<apex:column>
<apex:facet name="header">Email</apex:facet>
{!contact.Email}
</apex:column>
</apex:dataTable>
<apex:form><br/><br/>
<apex:outputLabel value="Subject" for="Subject"/>: <br/>
<apex:inputText value="{!subject}" id="Subject" maxlength="80"/>
<br/><br/>
<apex:outputLabel value="Body" for="Body"/>: <br/>
<apex:inputTextarea value="{!body}" id="Body" rows="10" cols="80"/>
<br/><br/>
<apex:commandButton value="Send Email" action="{!send}"/>
</apex:form>
</apex:pageBlock>
<apex:pageBlock title="Preview the Attachment for {!account.name}">
<c:attachment/>
</apex:pageBlock>
</apex:page>
```

> SEE ALSO — Apex Developer Guide: EmailFileAttachment Class

### 1.3 Visualforce 이메일 템플릿

HTML 이메일 템플릿 대비 장점은 recipient에게 보내는 data에 advanced operations를 할 수 있다는 점이다. 표준 Visualforce 컴포넌트와 달리 **`messaging` 네임스페이스 접두 컴포넌트**를 쓴다.

- 모든 Visualforce 이메일 템플릿은 단일 `<messaging:emailTemplate>` 태그 안에 있어야 한다(일반 VF 페이지가 하나의 `<apex:page>`에 들어가는 것과 동일).
- `<messaging:emailTemplate>`은 단일 `<messaging:htmlEmailBody>` 또는 단일 `<messaging:plainTextEmailBody>` 중 하나를 반드시 포함해야 한다.
- 이메일 템플릿 안에서 **사용 불가**한 표준 VF 컴포넌트: `<apex:detail>`, `<apex:pageBlock>` 및 모든 관련 pageBlock 컴포넌트, `<apex:form>` 같은 모든 input 컴포넌트. 이런 컴포넌트로 저장하면 에러 메시지가 표시된다.

**템플릿 만들기** — contact에 연관된 모든 cases를 표시하는 예제(`<apex:repeat>`로 cases 순회):

```xml
<messaging:emailTemplate recipientType="Contact"
relatedToType="Account"
subject="Case report for Account: {!relatedTo.name}"
language="{!recipient.language__c}"
replyTo="support@acme.com">
<messaging:htmlEmailBody>
<html>
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
"https://yourInstance.salesforce.com/{!cx.id}">{!cx.CaseNumber}
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

- `recipientType`·`relatedToType`이 이메일 템플릿의 controller 역할을 한다. 다른 standard controller가 쓰는 merge fields에 동일하게 접근한다. `recipientType`=이메일 받는 사람, `relatedToType`=이메일에 연관시킬 record.
- `<messaging:htmlEmailBody>`는 VF markup + HTML 혼합이 가능하다. `<messaging:plainTextEmailBody>`는 VF markup + plain text만 가능하다.
- recipients/related objects의 언어로 번역하려면 `<messaging:emailTemplate>`의 `language` 속성을 쓴다(유효값: Salesforce supported language keys, 예: "en-US"). `language`는 템플릿의 `recipientType`·`relatedToType` 속성에서 merge fields를 받는다. merge fields용 custom language fields를 생성한다.
- Note: 이메일 템플릿 번역에는 Translation Workbench가 필요하다.

**생성 단계(Salesforce Classic):**

1. public templates 편집 권한이 있으면 Setup → Email Templates 검색 → Classic Email Templates. 없으면 personal settings → Templates 검색 → Email Templates 또는 My Templates.
2. New Template 클릭.
3. Visualforce 선택 → Next.
4. 템플릿을 저장할 폴더 선택.
5. Available For Use 체크박스 선택(사용 가능하게).
6. 이메일 템플릿 이름 입력.
7. 필요시 Template Unique Name 변경. Lightning Platform API에서 컴포넌트 참조 시 사용하며 managed packages에서 naming conflict를 방지한다. underscores·alphanumeric만, org 내 unique, 문자로 시작, 공백 없음, underscore로 끝나지 않음, 연속 두 underscore 없음.
8. 원하면 Encoding dropdown에서 다른 character set 선택.
9. description 입력(template name·description은 내부용).
10. Email Subject에 subject line 입력.
11. Recipient Type dropdown에서 recipient 유형 선택.
12. 원하면 Related To Type dropdown에서 merge field data를 가져올 object 선택.
13. Save 클릭.
14. View and Edit Email Templates in Salesforce Classic 페이지에서 Edit Template 클릭.
15. Visualforce 이메일 템플릿 markup 입력. 이미지를 포함할 때는 Documents tab에 업로드해 서버 복사본을 참조하는 것이 권장된다. 예:
    ```xml
    <apex:image id="Logo"
    value="https://yourInstance.salesforce.com/servlet/servlet.ImageServer?
    id=015D0000000Dpwc&oid=00DD0000000FHaG&lastMod=127057656800" />
    ```
16. Version Settings 클릭해 VF·API 버전 지정. AppExchange managed packages 설치 시 각 버전도 지정 가능. 일반적으로 모든 버전 default를 쓴다.
17. Save(세부 보기) 또는 Quick Save(계속 편집). markup이 valid해야 저장된다.

> Note (한도):
> - Visualforce 이메일 템플릿 최대 크기 = **1 MB**.
> - Visualforce 이메일 템플릿으로 **mass email 불가**.
> - `{!Receiving_User.field_name}`·`{!Sending_User.field_name}` merge fields는 **mass email·list email에만** 동작하며 Visualforce 이메일 템플릿에서는 사용할 수 없다.

> SEE ALSO — Use a Custom Stylesheet in a Visualforce Email Template

### 1.4 이메일 템플릿에 커스텀 스타일시트 사용

기본은 standard look & feel이며 자신의 stylesheet로 확장/덮어쓸 수 있다. 다른 VF 페이지와 달리 **referenced page styles나 static resources를 사용할 수 없다.** preview pane에서는 CSS가 렌더되어 보여도 recipients에게는 다르게 보일 수 있으므로 `<style>` 태그 안에 CSS를 정의해야 한다.

> Note: Email clients는 CSS styling을 제한할 수 있다. web·mobile 양쪽에서 회사 email client로 테스트한다.

예제(Courier font, table border, row 색상):

```xml
<messaging:emailTemplate recipientType="Contact"
relatedToType="Account"
subject="Case report for Account: {!relatedTo.name}"
replyTo="support@acme.com">
<messaging:htmlEmailBody>
<html>
<head>
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
</head>
<body>
<p>Dear {!recipient.name},</p>
<table border="0" >
<tr>
<th>Case Number</th><th>Origin</th>
<th>Creator Email</th><th>Status</th>
</tr>
<apex:repeat var="cx" value="{!relatedTo.Cases}">
<tr>
<td>
<a href="https://MyDomain_login_URL/{!cx.id}">
{!cx.CaseNumber}
</a>
</td>
<td>{!cx.Origin}</td>
<td>{!cx.Contact.email}</td>
<td>{!cx.Status}</td>
</tr>
</apex:repeat>
</table>
</body>
</html>
</messaging:htmlEmailBody>
</messaging:emailTemplate>
```

시각자료: "Example of the Rendered Visualforce Email Template" — (PDF 스크린샷 — 텍스트만)

**커스텀 컴포넌트로 스타일시트 정의** — external stylesheet 참조는 불가하나 style 정의를 커스텀 컴포넌트에 넣어 재참조할 수 있다.

`EmailStyle` 컴포넌트:

```xml
<apex:component access="global">
<head>
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
</head>
</apex:component>
```

템플릿에서 컴포넌트 참조:

```xml
<messaging:htmlEmailBody>
<html>
<c:EmailStyle />
<body>
<p>Dear {!recipient.name},</p>
...
</body>
</html>
</messaging:htmlEmailBody>
```

> Note: Visualforce 이메일 템플릿 안에서 쓰는 `<apex:component>` 태그는 access level이 global이어야 한다.

### 1.5 이메일 템플릿에 첨부 추가

각 첨부는 단일 `<messaging:attachment>` 컴포넌트에 캡슐화한다. 안에 HTML과 VF 태그를 조합할 수 있다.

**1) 데이터로 첨부 생성**(unformatted text file):

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
For more detailed information, log in to Salesforce.com
</apex:outputLink>
</center>
</body>
</html>
</messaging:htmlEmailBody>
<messaging:attachment>
<apex:repeat var="cx" value="{!relatedTo.Cases}">
Case Number: {!cx.CaseNumber}
Origin: {!cx.Origin}
Creator Email: {!cx.Contact.email}
Case Number: {!cx.Status}
</apex:repeat>
</messaging:attachment>
</messaging:emailTemplate>
```

> 마지막 줄 `Case Number: {!cx.Status}`는 라벨이 "Case Number"인데 값이 Status인 PDF 원문 오류를 그대로 보존한 것이다. [sic]

**2) filename 속성으로 첨부 파일명 정의** — 권장이나 필수는 아니다. 미정의 시 Salesforce가 생성한다. 확장자가 없으면 text file로 기본 처리된다. CSV로 렌더하려면 `.csv` 확장자를 추가한다:

```xml
<messaging:attachment filename="cases.csv">
<apex:repeat var="cx" value="{!relatedTo.Cases}">
{!cx.CaseNumber}
{!cx.Origin}
{!cx.Contact.email}
{!cx.Status}
</apex:repeat>
</messaging:attachment>
```

HTML로 렌더하려면 `.html` 확장자를 쓴다:

```xml
<messaging:attachment filename="cases.html">
<html>
<body>
<table border="0" >
<tr>
<th>Case Number</th><th>Origin</th>
<th>Creator Email</th><th>Status</th>
</tr>
<apex:repeat var="cx" value="{!relatedTo.Cases}">
<tr>
<td><a href =
"https://MyDomain_login_URL/{!cx.id}">{!cx.CaseNumber}
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
```

`<messaging:attachment>` 하나당 file name은 하나만 정의 가능하지만, 한 이메일에 여러 파일을 첨부할 수 있다.

**3) PDF로 렌더** — `renderAs="PDF"`를 쓴다. 사용 전 "Visualforce PDF Rendering Considerations and Limitations"(PDF p.81 → 위키 [[페이지 출력 제어 — HTML·PDF·SLDS]])를 검토한다:

```xml
<messaging:attachment renderAs="PDF" filename="cases.pdf">
<html>
<body>
<p>You can display your {!relatedTo.name} cases as a PDF:</p>
<table border="0" >
<tr>
<th>Case Number</th><th>Origin</th>
<th>Creator Email</th><th>Status</th>
</tr>
<apex:repeat var="cx" value="{!relatedTo.Cases}">
<tr>
<td><a href =
"https://MyDomain_login_URL/{!cx.id}">{!cx.CaseNumber}
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
```

> Note: `renderAs` 속성은 어떤 MIME type도 valid value로 받지만 Visualforce는 PDF 렌더만 지원한다. 다른 file format을 생성하지 않으며 HTTP response header의 Content-Type field만 지정 MIME type으로 설정한다. `.xlsx` 같은 일부 포맷은 렌더에 실패할 수 있다.

**4) images·style sheets로 스타일링** — 첨부는 이메일 템플릿과 동일 방식(inline 또는 커스텀 컴포넌트)으로 스타일을 연결한다. PDF로 렌더된 첨부는 `$Resource` global variable로 static resources를 참조할 수 있다.

로고 포함 예:

```xml
<messaging:attachment renderAs="PDF" filename="cases.pdf">
<html>
<body>
<img src = "{!$Resource.logo}" />
...
</body>
</html>
</messaging:attachment>
```

static resource로 저장된 stylesheet 참조 예:

```xml
<messaging:attachment renderAs="PDF">
<html>
<link rel='stylesheet' type='text/css' href='{!$Resource.EMAILCSS}' />
<body>
...
</body>
</html>
</messaging:attachment>
```

> Note: remote server의 static resources 참조는 PDF 첨부 렌더 시간을 늘릴 수 있다. Apex trigger에서 PDF 첨부를 생성할 때는 remote resources를 참조할 수 없으며 참조 시 exception이 발생한다.

### 1.6 이메일 템플릿에서 커스텀 컨트롤러 사용

커스텀 컨트롤러로 highly customized content를 렌더할 수 있다. 커스텀 컨트롤러를 쓰는 커스텀 컴포넌트를 이메일 템플릿에 포함한다.

예제 — "Smith"로 시작하는 모든 accounts 표시:

```apex
public class findSmithAccounts {
private final List<Account> accounts;
public findSmithAccounts() {
accounts = [select Name from Account where Name LIKE 'Smith_%'];
}
public List<Account> getSmithAccounts() {
return accounts;
}
}
```

> PDF 본문은 이 컨트롤러를 "SOSL call"이라 부르지만 실제 코드는 SOQL `LIKE` 쿼리다(PDF 원문 그대로). [sic]

`smithAccounts` 커스텀 컴포넌트:

```xml
<apex:component controller="findSmithAccounts" access="global">
<apex:dataTable value="{!SmithAccounts}" var="s_account">
<apex:column>
<apex:facet name="header">Account Name</apex:facet>
{!s_account.Name}
</apex:column>
</apex:dataTable>
</apex:component>
```

> Tip: VF 이메일 템플릿에 쓰는 모든 커스텀 컴포넌트는 access level이 global이어야 한다.

이메일 템플릿:

```xml
<messaging:emailTemplate subject="Embedding Apex Code" recipientType="Contact"
relatedToType="Opportunity">
<messaging:htmlEmailBody>
<p>As you requested, here's a list of all our Smith accounts:</p>
<c:smithAccounts/>
<p>Hope this helps with the {!relatedToType}.</p>
</messaging:htmlEmailBody>
</messaging:emailTemplate>
```

`relatedToType` 속성은 emailTemplate 컴포넌트가 required로 요구하지만 이 예제에서는 효과가 없다. object value를 받을 수 있음을 보이려 "Opportunity" 값을 둔 것이다.

> Note (Sharing·Debug):
> - 이메일 템플릿이 standard controller를 쓰면 Sharing settings가 강제된다. user object의 org-wide default가 Private이고 이메일 템플릿에서 name·email address 같은 user 정보 접근이 필요하면 `without sharing` 키워드의 커스텀 컴포넌트/컨트롤러를 쓴다.
> - Debug logs에는 이메일 템플릿이 쓰는 컴포넌트 컨트롤러의 `System.debug()` 메시지가 들어가지 않는다. Salesforce Platform 실행 순서 때문이다 — debug logs는 DML 커밋 시 작성되지만 emails는 DML 커밋 후에 전송된다. 즉 debug log 작성=on-commit, email 전송=post-commit. 따라서 이메일 템플릿에서 호출되면 커스텀 컴포넌트·컨트롤러는 debug log 생성 후에 실행되어 log에 나타나지 않는다. 우회: try-catch block으로 커스텀 컴포넌트 렌더 과정의 에러를 catch한다.

---

## 2. Visualforce 차트 (Ch15)

SOQL 쿼리나 Apex 코드로 만든 data set 기반의 customized business charts를 만드는 컴포넌트 모음이다. 개별 data series를 조합·설정해 차트를 구성한다. **client-side JavaScript로 렌더**되어 animated이며 data를 비동기로 load/reload할 수 있다.

### 2.1 언제 / 대안 / 제한

- **언제:** standard Salesforce charts/dashboards가 불충분하거나, 차트 + data tables를 조합한 custom 페이지가 더 유용할 때.
- **대안:** Salesforce dashboards/reports는 다양한 business charts를 지원하며 프로그래밍이 불필요해 더 간단하다. Visualforce charting은 bar/line/area/pie + radar/gauge/scatter를 제공한다. 다른 chart types나 advanced 상호작용이 필요하면 JavaScript charting library를 고려한다(작업은 많지만 customization이 크다).

**제한·고려사항:**
- Visualforce charts는 **SVG 지원 브라우저에서만** 렌더된다.
- JavaScript로 그리므로 **PDF로 렌더된 페이지에서는 표시되지 않는다.**
- Email clients는 보통 JavaScript 실행을 미지원하므로 **email messages/templates에 Visualforce charting을 쓰지 말 것.**
- errors·messages를 JavaScript console로 보낸다 — 개발 중에는 JavaScript debugging tool(Chrome DevTools, Safari Web Inspector)을 활성화해 둔다.
- **Dynamic(Apex-generated) charting 컴포넌트는 현재 미지원이다.**

### 2.2 차트 동작 원리

charting 컴포넌트 시리즈로 차트를 정의하고 data source에 연결한다.
1. 차트 data를 query/calculate/wrap해 브라우저로 보내는 Apex method를 작성한다.
2. Visualforce charting 컴포넌트로 차트를 정의한다.

페이지 로드 시 chart data가 chart 컴포넌트에 bind되고, 차트를 그리는 JavaScript가 생성된다. JavaScript가 실행되면 브라우저에 차트가 렌더된다.

### 2.3 단순 차트 예제

chart container 컴포넌트(최소 하나의 data series 컴포넌트 포함)가 필요하다. 선택적으로 series 컴포넌트, axes, legend/labels/tooltips를 추가한다.

간단한 pie chart:

```xml
<apex:page controller="PieChartController" title="Pie Chart">
<apex:chart height="350" width="450" data="{!pieData}">
<apex:pieSeries dataField="data" labelField="name"/>
<apex:legend position="right"/>
</apex:chart>
</apex:page>
```

`<apex:chart>`은 container로 data source(`getPieData()` 컨트롤러 메서드)에 bind된다. `<apex:pieSeries>`은 각 data point의 label/size용 label·data fields를 기술한다.

컨트롤러:

```apex
public class PieChartController {
public List<PieWedgeData> getPieData() {
List<PieWedgeData> data = new List<PieWedgeData>();
data.add(new PieWedgeData('Jan', 30));
data.add(new PieWedgeData('Feb', 15));
data.add(new PieWedgeData('Mar', 10));
data.add(new PieWedgeData('Apr', 20));
data.add(new PieWedgeData('May', 20));
data.add(new PieWedgeData('Jun', 5));
return data;
}
// Wrapper class
public class PieWedgeData {
public String name { get; set; }
public Integer data { get; set; }
public PieWedgeData(String name, Integer data) {
this.name = name;
this.data = data;
}
}
}
```

`getPieData()`는 inner class `PieWedgeData` wrapper의 List를 반환한다. 각 element가 data point이며 `PieWedgeData`는 properties 집합(name=value store)이다. `<apex:pieSeries>`가 어느 properties를 쓸지 정의한다. multiple series/axes 차트에서는 전체 data set을 한 List object로 efficient하게 반환할 수 있다.

### 2.4 차트 데이터 제공 — 세 가지 방법

`<apex:chart>`의 `data` 속성으로 data source에 bind한다. 세 가지 방법이 있다.

| 방법 | `data` 값 | 설명 |
|---|---|---|
| 컨트롤러 메서드 | expression `{!method}` | server-side에서 List of objects(Apex wrapper, sObjects, AggregateResult) 반환, JSON 직렬화 후 client에서 직접 사용 |
| JavaScript function | function 이름 string | JavaScript remoting·external data source 접근 시. callback function을 받아 data result object로 invoke |
| JavaScript array | array 이름 string | non-Salesforce data sources용, 페이지 자체 JS로 array 빌드 |

**컨트롤러 메서드로 제공**(가장 직관적) — sObjects 예, Opportunities bar chart:

```apex
public class OppsController {
// Get a set of Opportunities
public ApexPages.StandardSetController setCon {
get {
if(setCon == null) {
setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
[SELECT name, type, amount, closedate FROM Opportunity]));
setCon.setPageSize(5);
}
return setCon;
}
set;
}
public List<Opportunity> getOpportunities() {
return (List<Opportunity>) setCon.getRecords();
}
}
```

```xml
<apex:page controller="OppsController">
<apex:chart data="{!Opportunities}" width="600" height="400">
<apex:axis type="Category" position="left" fields="Name" title="Opportunities"/>
<apex:axis type="Numeric" position="bottom" fields="Amount" title="Amount"/>
<apex:barSeries orientation="horizontal" axis="bottom"
xField="Name" yField="Amount"/>
</apex:chart>
<apex:dataTable value="{!Opportunities}" var="opp">
<apex:column headerValue="Opportunity" value="{!opp.name}"/>
<apex:column headerValue="Amount" value="{!opp.amount}"/>
</apex:dataTable>
</apex:page>
```

> Note: **object field names는 JavaScript에서 case-sensitive**다(Apex/VF는 case-insensitive). `fields`, `xField`, `yField` 속성에 정확한 field name을 써야 한다 — 아니면 차트가 silently fail한다.

**JavaScript function으로 제공** — function 이름을 `<apex:chart>`에 제공한다. function은 callback function을 parameter로 받아 data result object로 invoke한다:

```xml
<apex:page>
<script>
function getRemoteData(callback) {
PieChartController.getRemotePieData(function(result, event) {
if(event.status && result && result.constructor === Array) {
callback(result);
}
});
}
</script>
<apex:chart data="getRemoteData" ...></apex:chart>
</apex:page>
```

지원 컨트롤러 메서드(PieChartController에 추가):

```apex
@RemoteAction
public static List<PieWedgeData> getRemotePieData() {
List<PieWedgeData> data = new List<PieWedgeData>();
data.add(new PieWedgeData('Jan', 30));
data.add(new PieWedgeData('Feb', 15));
data.add(new PieWedgeData('Mar', 10));
data.add(new PieWedgeData('Apr', 20));
data.add(new PieWedgeData('May', 20));
data.add(new PieWedgeData('Jun', 5));
return data;
}
```

**JavaScript array로 제공**(non-Salesforce sources) — 페이지의 자체 JavaScript로 array를 빌드해 array 이름을 `<apex:chart>`에 제공한다:

```xml
<apex:page>
<script>
// Build the chart data array in JavaScript
var dataArray = new Array();
dataArray.push({'data1':33,'data2':66,'data3':80,'name':'Jan'});
dataArray.push({'data1':33,'data2':66,'data3':80,'name':'Feb'});
// ...
</script>
<apex:chart data="dataArray" ...></apex:chart>
</apex:page>
```

**Chart Data Format:** data collection의 모든 element는 그 data source에 bind된 `<apex:chart>` hierarchy가 참조하는 모든 fields를 포함해야 한다. 아니면 client-side JavaScript error가 난다(JavaScript console에서 확인). Apex method가 제공하는 data는 List of uniform objects(simple wrappers, sObjects, AggregateResult)이며 data fields는 public member variables 또는 properties로 접근한다. JavaScript method가 제공하는 data는 array of arrays이며 각 inner array가 record/data point, data fields는 name:value pairs다.

### 2.5 복합 차트 만들기 (series 컴포넌트 조합)

확장 컨트롤러(`ChartController`) — multiple data series:

```apex
public class ChartController {
// Return a list of data points for a chart
public List<Data> getData() {
return ChartController.getChartData();
}
// Make the chart data available via JavaScript remoting
@RemoteAction
public static List<Data> getRemoteData() {
return ChartController.getChartData();
}
// The actual chart data; needs to be static to be
// called by a @RemoteAction method
public static List<Data> getChartData() {
List<Data> data = new List<Data>();
data.add(new Data('Jan', 30, 90, 55));
data.add(new Data('Feb', 44, 15, 65));
data.add(new Data('Mar', 25, 32, 75));
data.add(new Data('Apr', 74, 28, 85));
data.add(new Data('May', 65, 51, 95));
data.add(new Data('Jun', 33, 45, 99));
data.add(new Data('Jul', 92, 82, 30));
data.add(new Data('Aug', 87, 73, 45));
data.add(new Data('Sep', 34, 65, 55));
data.add(new Data('Oct', 78, 66, 56));
data.add(new Data('Nov', 80, 67, 53));
data.add(new Data('Dec', 17, 70, 70));
return data;
}
// Wrapper class
public class Data {
public String name { get; set; }
public Integer data1 { get; set; }
public Integer data2 { get; set; }
public Integer data3 { get; set; }
public Data(String name, Integer data1, Integer data2, Integer data3) {
this.name = name;
this.data1 = data1;
this.data2 = data2;
this.data3 = data3;
}
}
}
```

> Note: `@RemoteAction` 메서드는 이 절의 차트 예제에는 쓰이지 않지만, data generation method를 server-side·JavaScript remoting 양쪽에 재사용하는 법을 보여준다.

**단순 line chart**("Opportunities Closed-Won"):

```xml
<apex:page controller="ChartController">
<apex:chart height="400" width="700" data="{!data}">
<apex:axis type="Numeric" position="left" fields="data1"
title="Opportunities Closed" grid="true"/>
<apex:axis type="Category" position="bottom" fields="name"
title="Month of the Year">
</apex:axis>
<apex:lineSeries axis="left" fill="true" xField="name" yField="data1"
markerType="cross" markerSize="4" markerFill="#FF0000"/>
</apex:chart>
</apex:page>
```

Line/bar charts는 X·Y axes 정의가 필요하다. vertical axis=left(달러 금액), horizontal axis=bottom(월). `<apex:lineSeries>`는 특정 axis에 bind되며 line 구분용 marker 속성이 다수 있다.

**두 번째 data series 추가**("Closed-Lost"):

```xml
<apex:page controller="ChartController">
<apex:chart height="400" width="700" data="{!data}">
<apex:axis type="Numeric" position="left" fields="data1,data2"
title="Opportunities Closed" grid="true"/>
<apex:axis type="Category" position="bottom" fields="name"
title="Month of the Year">
</apex:axis>
<apex:lineSeries axis="left" fill="true" xField="name" yField="data1"
markerType="cross" markerSize="4" markerFill="#FF0000"/>
<apex:lineSeries axis="left" xField="name" yField="data2"
markerType="circle" markerSize="4" markerFill="#8E35EF"/>
</apex:chart>
</apex:page>
```

data1·data2를 둘 다 vertical `<apex:axis>`의 `fields`에 bind하면 charting engine이 scale·tick marks를 결정한다.

**두 번째 axis와 bar series 추가**("Revenue by Month", 다른 단위 → 두 번째 vertical axis):

```xml
<apex:page controller="ChartController">
<apex:chart height="400" width="700" data="{!data}">
<apex:axis type="Numeric" position="left" fields="data1,data2"
title="Opportunities Closed" grid="true"/>
<apex:axis type="Numeric" position="right" fields="data3"
title="Revenue (millions)"/>
<apex:axis type="Category" position="bottom" fields="name"
title="Month of the Year"/>
<apex:lineSeries axis="left" fill="true" xField="name" yField="data1"
markerType="cross" markerSize="4" markerFill="#FF0000"/>
<apex:lineSeries axis="left" xField="name" yField="data2"
markerType="circle" markerSize="4" markerFill="#8E35EF"/>
<apex:barSeries orientation="vertical" axis="right"
xField="name" yField="data3"/>
</apex:chart>
</apex:page>
```

> 새 unit data series 추가 시 right side에 두 번째 vertical axis를 둔다. **최대 4개 axes**(차트 각 edge당 하나). bar chart는 vertical orientation·right axis에 bind한다. horizontal bar chart는 top/bottom axis에 bind한다.

**legend·labels·chart tips 추가:**

```xml
<apex:page controller="ChartController">
<apex:chart height="400" width="700" data="{!data}">
<apex:legend position="right"/>
<apex:axis type="Numeric" position="left" fields="data1"
title="Opportunities Closed" grid="true"/>
<apex:axis type="Numeric" position="right" fields="data3"
title="Revenue (millions)"/>
<apex:axis type="Category" position="bottom" fields="name"
title="Month of the Year">
<apex:chartLabel rotate="315"/>
</apex:axis>
<apex:barSeries title="Monthly Sales" orientation="vertical" axis="right"
xField="name" yField="data3">
<apex:chartTips height="20" width="120"/>
</apex:barSeries>
<apex:lineSeries title="Closed-Won" axis="left" xField="name" yField="data1"
fill="true" markerType="cross" markerSize="4" markerFill="#FF0000"/>
<apex:lineSeries title="Closed-Lost" axis="left" xField="name" yField="data2"
markerType="circle" markerSize="4" markerFill="#8E35EF"/>
</apex:chart>
</apex:page>
```

- data series 컴포넌트 순서가 layering을 결정한다(앞에 둔 것이 background).
- `<apex:legend>`는 left/right/top/bottom 4위치가 가능하며 차트 boundary 안에 배치된다(차트 가로 폭이 압축됨).
- legend titles는 data series 컴포넌트의 `title` 속성으로 준다.
- bottom axis labels 회전은 `<apex:chartLabel>`을 해당 `<apex:axis>` 안에 둔다.
- `<apex:chartTips>`는 enclose하는 series의 각 data point에 rollover tool tips를 제공한다.

### 2.6 새 데이터로 차트 갱신

`<apex:actionSupport>`(VF만으로 update) 또는 JavaScript remoting + 자체 JavaScript code(코드 필요하나 더 flexible·smoother transitions)로 redraw한다.

**`<apex:actionSupport>` 방식** — 연도 선택 메뉴로 update되는 pie chart:

```xml
<apex:page controller="PieChartRemoteController">
<apex:pageBlock title="Charts">
<apex:pageBlockSection title="Standard Visualforce Charting">
<apex:outputPanel id="theChart">
<apex:chart height="350" width="450" data="{!pieData}">
<apex:pieSeries dataField="data" labelField="name"/>
<apex:legend position="right"/>
</apex:chart>
</apex:outputPanel>
<apex:form>
<apex:selectList value="{!chartYear}" size="1">
<apex:selectOptions value="{!chartYearOptions}"/>
<apex:actionSupport event="onchange" reRender="theChart"
status="actionStatusDisplay"/>
</apex:selectList>
<apex:actionStatus id="actionStatusDisplay"
startText="loading..." stopText=""/>
</apex:form>
</apex:pageBlockSection>
</apex:pageBlock>
</apex:page>
```

`data="{!pieData}"`가 `getPieData()`를 호출한다. 차트는 id=`theChart`인 `<apex:outputPanel>`로 wrap된다. `<apex:selectList>`의 child `<apex:actionSupport>`가 메뉴 변경 시 form을 submit하고, `theChart`를 reRender해 차트만 update한다(전체 페이지 reload가 아님). `<apex:actionStatus>`가 refresh 중 status message를 제공한다.

컨트롤러(`PieChartRemoteController`) — actionSupport·remoting 양쪽이 공유:

```apex
public class PieChartRemoteController {
// The year to be charted
public String chartYear {
get {
if (chartYear == Null) chartYear = '2013';
return chartYear;
}
set;
}
// Years available to be charted, for <apex:selectList>
public static List<SelectOption> getChartYearOptions() {
List<SelectOption> years = new List<SelectOption>();
years.add(new SelectOption('2013','2013'));
years.add(new SelectOption('2012','2012'));
years.add(new SelectOption('2011','2011'));
years.add(new SelectOption('2010','2010'));
return years;
}
public List<PieWedgeData> getPieData() {
// Visualforce expressions can't pass parameters, so get from property
return PieChartRemoteController.generatePieData(this.chartYear);
}
@RemoteAction
public static List<PieWedgeData> getRemotePieData(String year) {
// Remoting calls can send parameters with the call
return PieChartRemoteController.generatePieData(year);
}
// Private data "generator"
private static List<PieWedgeData> generatePieData(String year) {
List<PieWedgeData> data = new List<PieWedgeData>();
if(year.equals('2013')) {
// These numbers are absolute quantities, not percentages
// The chart component will calculate the percentages
data.add(new PieWedgeData('Jan', 30));
data.add(new PieWedgeData('Feb', 15));
data.add(new PieWedgeData('Mar', 10));
data.add(new PieWedgeData('Apr', 20));
data.add(new PieWedgeData('May', 20));
data.add(new PieWedgeData('Jun', 5));
}
else {
data.add(new PieWedgeData('Jan', 20));
data.add(new PieWedgeData('Feb', 35));
data.add(new PieWedgeData('Mar', 30));
data.add(new PieWedgeData('Apr', 40));
data.add(new PieWedgeData('May', 5));
data.add(new PieWedgeData('Jun', 10));
}
return data;
}
// Wrapper class
public class PieWedgeData {
public String name { get; set; }
public Integer data { get; set; }
public PieWedgeData(String name, Integer data) {
this.name = name;
this.data = data;
}
}
}
```

data 제공 두 경로: VF expression `{!pieData}`(instance method `getPieData()` 호출) / JavaScript remoting(`@RemoteAction` static `getRemotePieData()` 호출).

**JavaScript remoting 방식** — 연도 메뉴로 update되는 pie chart:

```xml
<apex:page controller="PieChartRemoteController">
<script>
function retrieveChartData(callback) {
var year = document.getElementById('theYear').value;
Visualforce.remoting.Manager.invokeAction(
'{!$RemoteAction.PieChartRemoteController.getRemotePieData}',
year,
function(result, event) {
if(event.status && result && (result.constructor === Array)) {
callback(result);
RemotingPieChart.show();
}
else if (event.type === 'exception') {
document.getElementById("remoteResponseErrors").innerHTML = event.message
+
'<br/>' + event.where;
}
else {
document.getElementById("remoteResponseErrors").innerHTML = event.message;
}
},
{ escape: true }
);
}
function refreshRemoteChart() {
var statusElement = document.getElementById('statusDisplay');
statusElement.innerHTML = "loading...";
retrieveChartData(function(statusElement){
return function(data){
RemotingPieChart.reload(data);
statusElement.innerHTML = '';
};
}(statusElement)
);
}
</script>
<apex:pageBlock title="Charts">
<apex:pageBlockSection title="Visualforce Charting + JavaScript Remoting">
<apex:chart height="350" width="450" data="retrieveChartData"
name="RemotingPieChart" hidden="true">
<apex:pieSeries dataField="data" labelField="name"/>
<apex:legend position="right"/>
</apex:chart>
<div>
<select id="theYear" onChange="refreshRemoteChart();">
<option value="2013">2013</option>
<option value="2012">2012</option>
<option value="2011">2011</option>
<option value="2010">2010</option>
</select>
<span id="statusDisplay"></span>
<span id="remoteResponseErrors"></span>
</div>
</apex:pageBlockSection>
</apex:pageBlock>
</apex:page>
```

- `data="retrieveChartData"`(string). static HTML `<select>` 메뉴는 form과 무관해 value가 컨트롤러로 직접 submit되지 않는다. `onChange`가 `refreshRemoteChart()`를 호출한다.
- 초기 로드: `data` 속성=함수명이므로 차트 생성·초기 로드 시 한 번만 `retrieveChartData()`를 직접 invoke한다. data가 있으면 `RemotingPieChart.show()` 호출.
- update: theYear 메뉴 onChange → `refreshRemoteChart()` → `retrieveChartData()` → `@RemoteAction` 반환 시 callback으로 `RemotingPieChart.reload(data)` 호출(새 data로 redraw).
- `hidden="true"`로 data 로드 전 차트 표시를 방지하고, `retrieveChartData()`가 `RemotingPieChart.show()`로 표시한다. `<apex:actionSupport>`보다 smoother animations를 준다.

시각자료: "This diagram illustrates these links between the different components of the page:" — (PDF 다이어그램 — 텍스트만. 페이지 컴포넌트 간 호출 링크를 보여주는 다이어그램이 PDF에 있으나 재현하지 않음.)

> 이 절의 컨트롤러는 위 actionSupport 절의 `PieChartRemoteController`와 동일하다(generatePieData 포함).

### 2.7 차트 외관 제어

customizable 항목: data series elements의 Line·fill colors / fill·lines opacity / data points marker shape·color / connecting lines line width / data elements highlighting / axes tick·grid line styles / Legends·labels·tool tip rollover annotations. (다수 컴포넌트·attribute는 Standard Visualforce Component Reference에 설명 — Part B 위임.)

**Chart Colors** — 기본 색은 built-in reporting/analytics charts와 일치한다(visually-consistent dashboards). `colorSet` 속성으로 data series elements 색을 지정한다. `<apex:chart colorSet="...">`=모든 series, data series 컴포넌트에 `colorSet`=해당 series만. comma-delimited HTML hex color 리스트를 순서대로 사용하고 끝나면 처음부터 반복한다.

```xml
<apex:pageBlockSection title="Simple colorSet Demo">
<apex:chart data="{!pieData}" height="300" width="400" background="#F5F5F5">
<apex:legend position="left"/>
<apex:pieSeries labelField="name" dataField="data1"
colorSet="#37241E,#94B3C8,#4D4E24,#BD8025,#816A4A,#F0E68C"/>
</apex:chart>
</apex:pageBlockSection>
```

> `background` 속성=전체 차트 배경색. `colorSet`은 `<apex:radarSeries>`를 제외한 모든 data series 컴포넌트에 사용 가능하다.

**Chart Layout and Annotation:** 기본적으로 모든 차트에 legend가 있다. 끄려면 `<apex:chart legend="false">`. 배치·간격은 `<apex:legend>`를 추가해 `position`으로 4 edges에 배치, `font`(CSS shorthand font property string, 예: `font="bold 24px Helvetica"`)로 조정한다. `<apex:axis type="Numeric">`은 `fields`의 data 기반 자동 scale이며 `minimum`·`maximum`으로 override, tick mark interval은 `steps`(integer), lines/shading은 `dashSize`·`grid`·`gridFill`로 제어한다. `<apex:chartLabel>`은 `<apex:axis>` child면 axis 바깥에, data series 컴포넌트 child면 data elements에 그린다(`field`=label text, `display`=위치, `orientation`·`rotate`로 조정).

> Note: `orientation` 속성은 `<apex:chartLabel>`이 `<apex:pieSeries>`와 쓰일 때 효과가 없다.

```xml
<apex:chart data="{!data}" height="400" width="500">
<apex:legend position="left" font="bold 14px Helvetica"/>
<apex:axis type="Numeric" position="left" title="Closed Won" grid="true"
fields="data1,data2,data3" minimum="0" maximum="225" steps="8" dashSize="2">
<apex:chartLabel />
</apex:axis>
<apex:axis type="Category" position="bottom" fields="name" title="2012">
<apex:chartLabel rotate="315"/>
</apex:axis>
<apex:barSeries orientation="vertical" axis="left"
xField="name" yField="data1,data2,data3" stacked="true"/>
</apex:chart>
```

### 2.8 차트 유형별 세부

**Bar Charts** — `<apex:barSeries>`는 origin axis와 X,Y coordinates 사이에 bars를 그린다. `orientation`이 origin axis를 결정한다 — `horizontal`=left(Y)에서 시작, `vertical`=bottom(X)에서 올라오는 column chart. bar interval당 multiple data points는 single `<apex:barSeries>` 안에 group/stack한다(multiple `<apex:barSeries>`는 서로 위에 그려져 마지막만 보임). vertical column chart는 group/stack할 모든 fields를 `yField`에 추가한다:

```xml
<apex:barSeries orientation="vertical" axis="left"
xField="name" yField="data1,data2,data3"/>
```

기본은 grouped이며 stack하려면 `stacked="true"`. `gutter`=grouped bars 간격, `groupGutter`=groups 간격, `xPadding`·`yPadding`=axes와 bars 간격. 기본 legend titles는 `yField` 이름이며 meaningful titles는 `title`(comma 구분)로 준다:

```xml
<apex:chart data="{!data}" height="400" width="500">
<apex:legend position="left"/>
<apex:axis type="Numeric" position="left" title="Closed Won" grid="true"
fields="data1,data2,data3" dashSize="2">
<apex:chartLabel/>
</apex:axis>
<apex:axis type="Category" position="bottom" fields="name" title="Stacked Bars">
<apex:chartLabel rotate="315"/>
</apex:axis>
<apex:barSeries orientation="vertical" axis="left" stacked="true"
xField="name" yField="data1,data2,data3" title="MacDonald,Promas,Worle"/>
</apex:chart>
```

**Other Linear Series Charts** (`<apex:areaSeries>`·`<apex:lineSeries>`·`<apex:scatterSeries>`) — data series charts는 markup 정의 순서대로 위에 그린다. `<apex:barSeries>`는 background가 필요(transparent 불가)하니 먼저 정의한다.

`<apex:areaSeries>`는 stacked bar charts와 유사하나 line으로 연결된 shaded areas다. 조합 시 `opacity`(0.0~1.0)로 투명하게 한다. area + bar series 예:

```xml
<apex:chart height="400" width="700" animate="true" data="{!data}">
<apex:legend position="left"/>
<apex:axis type="Numeric" position="left" title="Closed Won" grid="true"
fields="data1,data2,data3">
<apex:chartLabel />
</apex:axis>
<apex:axis type="Numeric" position="right" fields="data1"
title="Closed Lost" />
<apex:axis type="Category" position="bottom" fields="name"
title="Month of the Year">
<apex:chartLabel rotate="315"/>
</apex:axis>
<apex:areaSeries axis="left" tips="true" opacity="0.4"
xField="name" yField="data1,data2,data3"/>
<apex:barSeries orientation="vertical" axis="right"
xField="name" yField="data1">
<apex:chartLabel display="insideEnd" field="data1" color="#333"/>
</apex:barSeries>
</apex:chart>
```

area chart legend titles 변경(`<apex:areaSeries>` `title`):

```xml
<apex:chart height="400" width="700" animate="true" data="{!data}">
<apex:legend position="left"/>
<apex:axis type="Numeric" position="left" fields="data1,data2,data3"
title="Closed Won" grid="true">
<apex:chartLabel />
</apex:axis>
<apex:axis type="Category" position="bottom" fields="name" title="2011">
<apex:chartLabel rotate="315"/>
</apex:axis>
<apex:areaSeries axis="left" xField="name" tips="true"
yField="data1,data2,data3" title="MacDonald,Picard,Worlex" />
</apex:chart>
```

`<apex:lineSeries>`는 lines로 points를 연결하며 area fill이 가능하다. areaSeries와 달리 stack하지 않으며 fill을 안 하면 여러 series를 같은 차트에 둘 수 있다. 세 line series 예(하나는 filled):

```xml
<apex:chart height="400" width="700" animate="true" legend="true" data="{!data}">
<apex:legend position="left"/>
<apex:axis type="Numeric" position="left" title="Volatility" grid="true"
fields="data1,data2,data3">
<apex:chartLabel />
</apex:axis>
<apex:axis type="Category" position="bottom" title="Month" grid="true"
fields="name">
<apex:chartLabel />
</apex:axis>
<apex:lineSeries axis="left" xField="name" yField="data1"
strokeColor="#0000FF" strokeWidth="4"/>
<apex:lineSeries axis="left" fill="true" xField="name" yField="data2"
markerType="cross" markerSize="4" markerFill="#FF0000"/>
<apex:lineSeries axis="left" xField="name" yField="data3"
markerType="circle" markerSize="4" markerFill="#8E35EF">
<apex:chartTips height="20" width="120"/>
</apex:lineSeries>
</apex:chart>
```

> Note: `<apex:lineSeries>`는 Numeric axis가 위·오른쪽으로 증가하는 순서가 아니면 기대대로 fill되지 않을 수 있다. 해결: axis를 `type="Category"`로 설정하고 차트에 data를 전달하기 전에 값을 수동 정렬한다.

`<apex:scatterSeries>`는 lineSeries에서 connecting lines를 제거한 것으로, marker size/type/color를 조절해 여러 scatter series를 쉽게 plot한다.

**Pie Charts** — `<apex:pieSeries>`의 흔한 customization은 colors·labels(`colorSet`·`<apex:chartLabel>`)다. ring(donut) chart는 `donut` 속성(0~100 integer, hole 반지름 %):

```xml
<apex:chart data="{!pieData}" height="400" width="500" background="#F5F5F5">
<apex:legend position="left"/>
<apex:pieSeries labelField="name" dataField="data1" donut="50">
<apex:chartLabel display="middle" orientation="vertical"
font="bold 18px Helvetica"/>
</apex:pieSeries>
</apex:chart>
```

**Gauge Charts** — 단일 measurement를 axis/scale에 대해 표시한다. `<apex:axis>`의 `minimum`·`maximum`으로 값 범위, `<apex:gaugeSeries>`의 `colorSet`으로 good/bad를 표시한다:

```xml
<apex:chart height="250" width="450" animate="true" data="{!data}">
<apex:axis type="Gauge" position="gauge" title="Transaction Load"
minimum="0" maximum="100" steps="10"/>
<apex:gaugeSeries dataField="data1" donut="50" colorSet="#78c953,#ddd"/>
</apex:chart>
```

> Note: Gauge charts는 legends나 labels를 지원하지 않는다.

**Radar Charts** — line charts와 유사하나 circular axis다. `markerType`·`markerSize`·`markerFill`로 markers, `strokeColor`·`strokeWidth`로 connecting lines, `fill="true"`로 영역 채우기, `opacity`(0.0~1.0)로 투명하게 한다:

```xml
<apex:chart height="530" width="700" legend="true" data="{!data}">
<apex:legend position="left"/>
<apex:axis type="Radial" position="radial">
<apex:chartLabel />
</apex:axis>
<apex:radarSeries xField="name" yField="data1" tips="true" opacity="0.4"/>
<apex:radarSeries xField="name" yField="data2" tips="true" opacity="0.4"/>
<apex:radarSeries xField="name" yField="data3" tips="true"
markerType="cross" strokeWidth="2" strokeColor="#f33" opacity="0.4"/>
</apex:chart>
```

### 2.9 차트 컴포넌트 정리 (사용법 — 상세 attribute는 Part B 위임)

| 컴포넌트 | 역할 |
|---|---|
| `<apex:chart>` | 차트 container, `data`로 data source bind. height/width/colorSet/background/legend/hidden/name/animate |
| `<apex:axis>` | 축. type=Numeric/Category/Gauge/Radial, position=left/right/top/bottom/gauge/radial, fields, title, grid, minimum/maximum/steps/dashSize/gridFill |
| `<apex:legend>` | 범례. position=left/right/top/bottom, font |
| `<apex:chartLabel>` | 라벨. field/display/orientation/rotate/color/font |
| `<apex:chartTips>` | rollover tooltip. height/width |
| `<apex:barSeries>` | 막대. orientation=horizontal/vertical, axis, xField/yField, stacked, gutter/groupGutter/xPadding/yPadding, title |
| `<apex:lineSeries>` | 선. axis, xField/yField, fill, markerType/markerSize/markerFill, strokeColor/strokeWidth, title |
| `<apex:areaSeries>` | 영역. axis, xField/yField, opacity, tips, title |
| `<apex:scatterSeries>` | 산점도. markerType/markerSize/markerFill (연결선 없음) |
| `<apex:pieSeries>` | 파이. dataField/labelField, colorSet, donut |
| `<apex:gaugeSeries>` | 게이지. dataField, donut, colorSet (legend/label 미지원) |
| `<apex:radarSeries>` | 레이더. xField/yField, markerType/markerSize/markerFill, strokeColor/strokeWidth, fill, opacity, tips (colorSet 미지원) |

---

## 3. Visualforce 맵 (Ch16)

third-party mapping service를 쓰는 interactive JavaScript 맵(zoom/pan/markers)을 만든다. standalone map pages, page layouts에 삽입하는 맵, Salesforce 모바일 앱 맵을 만들 수 있다.

- `<apex:map>` = map canvas (size, type, center point, initial zoom level)
- `<apex:mapMarker>` (child) = address나 geolocation(lat/long)으로 markers 배치
- `<apex:mapInfoWindow>` = marker click/tap 시 나타나는 customizable 정보 패널

> Note: Visualforce mapping 컴포넌트는 **Developer Edition organizations에서는 사용할 수 없다.**

> Important: VF mapping 컴포넌트는 페이지에 JavaScript를 추가해 third-party JavaScript로 맵을 그린다.
> - VF가 추가하는 JavaScript는 industry-standard best practices로 충돌을 회피한다. 자체 JavaScript가 best practices를 안 쓰면 충돌할 수 있다.
> - geocoding이 필요한 주소(lat/long 값이 없는 locations)는 third-party service로 보낸다. org와 무관하며 VF markup에 제공한 것 외의 data는 보내지 않는다. 그러나 Salesforce 외부로의 data 공유를 strict하게 통제해야 하면 geocoding feature를 쓰지 말 것.

### 3.1 기본 맵

basic map(markers 없음)은 `<apex:map>`만 필요하다. `center` 속성=중심점이며 형식은 세 가지다.
- 주소 string. 예: "1 Market Street, San Francisco, CA". geocode되어 lat/long 결정.
- lat/long 속성 JSON object string. 예: `"{latitude: 37.794, longitude: -122.395}"`.
- `Map<String, Double>` Apex map object(latitude·longitude keys).

`<apex:map>`에 child `<apex:mapMarker>`가 없으면 `center`가 required다.

```xml
<apex:page >
<h1>Salesforce in San Francisco</h1>
<!-- Display the address on a map -->
<apex:map width="600px" height="400px" mapType="roadmap" zoomLevel="16"
center="One Market Street, San Francisco, CA">
</apex:map>
</apex:page>
```

시각자료: "This code produces the following map." — (PDF 스크린샷 — 텍스트만)

- mapped address에는 marker가 없다 — `<apex:map>` 자체는 center point도 marker로 표시하지 않는다.
- `mapType`="roadmap"(standard street map). 다른 옵션: "satellite", "hybrid".
- **map당 최대 10개 geocoded addresses**(center 속성 + `<apex:mapMarker>` markers 합산). marker는 최대 100개.

### 3.2 위치 마커 추가

`<apex:mapMarker>`를 연관 `<apex:map>`의 child로 추가한다. `position`으로 위치, `title`로 hover 시 텍스트를 지정한다. marker는 최대 100개이며 multiple markers는 `<apex:repeat>`로 iterate한다.

> Note (메모리): VF maps는 resource-intensive해서 mobile browsers·Salesforce app에서 memory issues가 생길 수 있다. markers가 많거나 큰 이미지 custom markers는 memory를 늘린다. mobile context 페이지는 철저히 테스트한다.

> Note (geocoding 한도): **map당 최대 10 geocoded address lookups.** `<apex:map>`의 `center`와 `<apex:mapMarker>`의 `position`이 모두 이 한도에 합산된다. 더 많은 markers는 geocoding이 불필요한 position 값(lat/long)을 제공한다. 한도를 초과하는 locations는 skip된다.

`position` 형식은 center와 동일하다(주소 string / lat·long JSON object string / `Map<String, Double>`).

예 — account 주소를 중심으로 contacts 표시:

```xml
<apex:page standardController="Account">
<!-- This page must be accessed with an Account Id in the URL. For example:
https://MyDomainName--c.vf.force.com/apex/NearbyContacts?id=001D000000JRBet -->
<apex:pageBlock >
<apex:pageBlockSection title="Contacts For {! Account.Name }">
<apex:dataList value="{! Account.Contacts }" var="contact">
<apex:outputText value="{! contact.Name }" />
</apex:dataList>
<apex:map width="600px" height="400px" mapType="roadmap"
center="{!Account.BillingStreet},{!Account.BillingCity},{!Account.BillingState}">
<apex:repeat value="{! Account.Contacts }" var="contact">
<apex:mapMarker title="{! contact.Name }"
position="{!contact.MailingStreet},{!contact.MailingCity},{!contact.MailingState}"
/>
</apex:repeat>
</apex:map>
</apex:pageBlockSection>
</apex:pageBlock>
</apex:page>
```

시각자료: "This code produces the following map." — (PDF 스크린샷 — 텍스트만)

> center·position이 주소 elements를 concatenate한 VF expression이고 geocoding을 쓰므로 첫 9 contacts만 표시된다(center가 10개 중 1 lookup을 사용). 예시 account에는 contacts가 3개뿐이다.

### 3.3 커스텀 마커 아이콘

`icon` 속성에 absolute/fully qualified URL을 준다. Web 이미지(CDN)나 static resource를 쓸 수 있고 static resource는 `URLFOR()` 함수로 URL을 얻는다:

```xml
<apex:mapMarker title="{! Account.Name }"
position="{!Account.BillingStreet},{!Account.BillingCity},{!Account.BillingState}"
icon="{! URLFOR($Resource.MapMarkers, 'moderntower.png') }" />
```

> PNG/GIF/JPEG 같은 common format을 쓴다. preferred marker size = **32 × 32 pixels**. 다른 size는 scale되며 이상적이지 않을 수 있다.

custom marker(account) + standard markers(contacts) 전체 페이지:

```xml
<apex:page standardController="Account">
<!-- This page must be accessed with an Account Id in the URL. For example:
https://MyDomainName--c.vf.force.com/apex/AccountContacts?id=001D000000JRBet -->
<apex:pageBlock >
<apex:pageBlockSection title="Contacts For {! Account.Name }">
<apex:dataList value="{! Account.Contacts }" var="contact">
<apex:outputText value="{! contact.Name }" />
</apex:dataList>
<apex:map width="600px" height="400px" mapType="roadmap"
center="{!Account.BillingStreet},{!Account.BillingCity},{!Account.BillingState}">
<!-- Add a CUSTOM map marker for the account itself -->
<apex:mapMarker title="{! Account.Name }"
position="{!Account.BillingStreet},{!Account.BillingCity},{!Account.BillingState}"
icon="{! URLFOR($Resource.MapMarkers, 'moderntower.png') }"/>
<!-- Add STANDARD markers for the account's contacts -->
<apex:repeat value="{! Account.Contacts }" var="ct">
<apex:mapMarker title="{! ct.Name }"
position="{! ct.MailingStreet },{! ct.MailingCity },{! ct.MailingState }">
</apex:mapMarker>
</apex:repeat>
</apex:map>
</apex:pageBlockSection>
</apex:pageBlock>
</apex:page>
```

시각자료: "This code produces the following map." — (PDF 스크린샷 — 텍스트만)

iteration(`<apex:repeat>`) 안 markers에 다른 icons를 쓰려면 iteration variable 관련 expression으로 URL을 정의한다(lookup field 이름이나 custom formula field 사용). `ContactType__c` custom field 가정 예:

```xml
<!-- Add CUSTOM markers for the account's contacts -->
<apex:repeat value="{! Account.Contacts }" var="ct">
<apex:mapMarker title="{! ct.Name }"
position="{! ct.MailingStreet },{! ct.MailingCity },{! ct.MailingState }"
icon="{! URLFOR($Resource.MapMarkers, ct.ContactType__c + '.png') }">
</apex:mapMarker>
</apex:repeat>
```

> field로 icon URL의 critical part를 제공할 때는 항상 usable value를 보장한다(required field나 formula field default).

### 3.4 마커에 정보 창 추가

info windows는 marker click/tap 시 extra details를 보여준다. `title`은 hover 시 소량 정보이고, 더 많은 정보·formatting 제어는 info window를 쓴다. `<apex:mapInfoWindow>`를 연관 `<apex:mapMarker>`의 child로 추가하며 body는 VF markup, HTML+CSS, plain text가 가능하다.

```xml
<apex:page standardController="Account">
<!-- This page must be accessed with an Account Id in the URL. For example:
https://MyDomainName--c.vf.force.com/apex/AccountContactsCustomMarker?id=001D000000JRBet
-->
<apex:pageBlock >
<apex:pageBlockSection title="Contacts For {! Account.Name }">
<apex:dataList value="{! Account.Contacts }" var="contact">
<apex:outputText value="{! contact.Name }" />
</apex:dataList>
<apex:map width="600px" height="400px" mapType="roadmap"
center="{!Account.BillingStreet},{!Account.BillingCity},{!Account.BillingState}">
<!-- Add markers for account contacts -->
<apex:repeat value="{! Account.Contacts }" var="ct">
<apex:mapMarker title="{! ct.Name }"
position="{! ct.MailingStreet },{! ct.MailingCity },{! ct.MailingState }">
<!-- Add info window with contact details -->
<apex:mapInfoWindow >
<apex:outputPanel layout="block" style="font-weight: bold;">
<apex:outputText>{! ct.Name }</apex:outputText>
</apex:outputPanel>
<apex:outputPanel layout="block">
<apex:outputText>{! ct.MailingStreet }</apex:outputText>
</apex:outputPanel>
<apex:outputPanel layout="block">
<apex:outputText>{! ct.MailingCity }, {! ct.MailingState }</apex:outputText>
</apex:outputPanel>
<apex:outputPanel layout="block">
<apex:outputLink value="{! 'tel://' + ct.Phone }">
<apex:outputText>{! ct.Phone }</apex:outputText>
</apex:outputLink>
</apex:outputPanel>
</apex:mapInfoWindow>
</apex:mapMarker>
</apex:repeat>
</apex:map>
</apex:pageBlockSection>
</apex:pageBlock>
</apex:page>
```

시각자료: "This code produces the following map." — (PDF 스크린샷 — 텍스트만)

> 기본은 한 번에 하나의 info window만 표시된다(다른 marker click 시 첫 window가 닫힘). 동시에 여러 개 표시는 containing `<apex:map>`에 `showOnlyActiveInfoWindow="false"`. Note: 여러 info windows 동시 표시는 cluttered map을 만들 수 있으니 신중히 쓴다.

### 3.5 Apex로 맵 데이터 구성

custom query, nearby locations 검색, filter/transform, standard controller 결과를 못 쓸 때 Apex로 location data를 구성한다(Salesforce 외부 결과도 가능). 사용자 위치 기준 최대 10 warehouses 표시 페이지:

```xml
<apex:page controller="FindNearbyController" docType="html-5.0" >
<!-- JavaScript to get the user's current location, and pre-fill
the currentPosition form field. -->
<script type="text/javascript">
// Get location, fill in search field
function setUserLocation() {
if (navigator.geolocation) {
navigator.geolocation.getCurrentPosition(function(loc){
var latlon = loc.coords.latitude + "," + loc.coords.longitude;
var el = document.querySelector("input.currentPosition");
el.value = latlon;
});
}
}
// Only set the user location once the page is ready
var readyStateCheckInterval = setInterval(function() {
if (document.readyState === "interactive") {
clearInterval(readyStateCheckInterval);
setUserLocation();
}
}, 10);
</script>
<apex:pageBlock >
<!-- Form field to send currentPosition in request. You can make it
an <apex:inputHidden> field to hide it. -->
<apex:pageBlockSection >
<apex:form >
<apex:outputLabel for="currentPosition">Find Nearby</apex:outputLabel>
<apex:input size="30"
html-placeholder="Attempting to obtain your position..."
id="currentPosition" styleClass="currentPosition"
value="{!currentPosition}" />
<apex:commandButton action="{!findNearby}" value="Go!"/>
</apex:form>
</apex:pageBlockSection>
<!-- Map of the results -->
<apex:pageBlockSection rendered="{!resultsAvailable}" title="Locations">
<apex:map width="600px" height="400px">
<apex:repeat value="{!locations}" var="pos">
<apex:mapMarker position="{!pos}"/>
</apex:repeat>
</apex:map>
</apex:pageBlockSection>
</apex:pageBlock>
</apex:page>
```

시각자료: "This code produces the following map." — (PDF 스크린샷 — 텍스트만)

세 section: (1) JavaScript block은 브라우저 built-in 위치를 요청해 visible form field를 업데이트(hidden field도 가능), (2) 첫 `<apex:pageBlockSection>`은 POSTBACK request에 위치를 submit하는 폼, (3) 둘째 section의 맵 자체는 5줄이며 복잡성은 `{!locations}` expression(Apex 컨트롤러 property)에 있다. `rendered="{!resultsAvailable}"`로 locations가 없으면 맵 section을 숨긴다.

Apex 컨트롤러:

```apex
public with sharing class FindNearbyController {
public List<Map<String,Double>> locations { get; private set; }
public String currentPosition {
get {
if (String.isBlank(currentPosition)) {
currentPosition = '37.77493,-122.419416'; // San Francisco
}
return currentPosition;
}
set;
}
public Boolean resultsAvailable {
get {
if(locations == Null) {
return false;
}
return true;
}
}
public PageReference findNearby() {
String lat, lon;
// FRAGILE: You'll want a better lat/long parsing routine
// Format: "<latitude>,<longitude>" (must have comma, but only one comma)
List<String> latlon = currentPosition.split(',');
lat = latlon[0].trim();
lon = latlon[1].trim();
// SOQL query to get the nearest warehouses
String queryString =
'SELECT Id, Name, Location__longitude__s, Location__latitude__s ' +
'FROM Warehouse__c ' +
'WHERE DISTANCE(Location__c, GEOLOCATION('+lat+','+lon+'), \'mi\') < 20 ' +
'ORDER BY DISTANCE(Location__c, GEOLOCATION('+lat+','+lon+'), \'mi\') ' +
'LIMIT 10';
// Run the query
List <Warehouse__c> warehouses = database.Query(queryString);
if(0 < warehouses.size()) {
// Convert to locations that can be mapped
locations = new List<Map<String,Double>>();
for (Warehouse__c wh : warehouses) {
locations.add(
new Map<String,Double>{
'latitude' => wh.Location__latitude__s,
'longitude' => wh.Location__longitude__s
}
);
}
}
else {
System.debug('No results. Query: ' + queryString);
}
return null;
}
}
```

- `locations`=`Map<String,Double>` elements 리스트(`<apex:mapMarker>`가 바로 쓰는 형식).
- `currentPosition`=폼 submit 위치, 빈 submission이면 valid default 제공.
- `findNearby` action=Go! `<apex:commandButton>` 시 호출, custom SOQL 실행·결과를 locations 형식으로 변환.
- `<apex:mapMarker>`의 `title`로 추가 정보(warehouse 이름)를 주려면: method가 sObjects를 반환하면 fields를 참조하고, 직접 objects를 생성하면 location map object + title string을 결합한 inner class를 만들어 collection을 반환한다.

---

## 4. Flow를 Visualforce로 렌더 (Ch17)

flow 실행 standard UI는 Flow Builder로 customize할 수 없다. 그러나 flow를 Visualforce 페이지에 embed하면 Apex·VF markup으로 run time를 설정할 수 있다(VF↔flow 값 전달, look & feel customize).

> Flow를 Apex 코드에서 직접 시작하는 `Flow.Interview` API 레퍼런스는 [[Flow Interview API]] 참조. 이 절은 Visualforce `<flow:interview>` 컴포넌트로 flow를 페이지에 임베드하는 패턴을 다룬다.

### 4.1 Flow 임베드

> Note: 사용자는 active version이 있는 flow만 실행할 수 있다. active version이 없으면 error message가 표시된다. embed한 flow에 Subflow element가 있으면 referenced/called flow도 active version이 필요하다.

1. flow의 API name 찾기: Setup → Flows 검색 → Flows → flow 이름 클릭.
2. VF 페이지 정의/편집.
3. `<apex:page>` 태그 사이에 `<flow:interview>` 추가.
4. `name` 속성=flow의 unique name:
   ```xml
   <apex:page>
   <flow:interview name="flowAPIName"/>
   </apex:page>
   ```
   > Note: managed package flow면 `name`은 `namespace.flowuniquename` 형식이다.
5. VF 페이지 page security 설정으로 실행 가능 사용자를 제한한다. external users(Experience Cloud site)는 VF 페이지 접근이 필요하다. internal users는 VF 페이지 접근 + 다음 중 하나가 필요하다: "Run Flows" permission / user detail page에 Flow User field enabled / 개별 flow에 "Override default behavior and restrict access to enabled profiles or permission sets" 선택 시 profile/permission set으로 access 부여.

**Flow 시작 시 변수 값 설정** — `<apex:param>`으로 시작 시 variable 값을 설정한다(modem issue troubleshooting flow 예):

```xml
<apex:page>
<flow:interview name="ModemTroubleShooting">
<apex:param name="vaCaseNumber" value="01212212"/>
</flow:interview>
</apex:page>
```

standard controllers로도 가능하다:

```xml
<apex:page standardController="Case" tabStyle="Case" >
<flow:interview name="ModemTroubleShooting">
<apex:param name="vaCaseNumber" value="{!Case.CaseNumber}"/>
</flow:interview>
</apex:page>
```

**finishLocation 속성** — Finish 클릭 시 Salesforce home page로 redirect:

```xml
<apex:page standardController="Case" tabStyle="Case" >
<flow:interview name="ModemTroubleShooting" finishLocation="{!URLFOR('/home/home.jsp')}">
<apex:param name="vaCaseNumber" value="{!case.CaseNumber}"/>
</flow:interview>
</apex:page>
```

### 4.2 `<flow:interview>` 고급 예제

커스텀 컨트롤러로 additional features에 접근한다. org 내 모든 flow는 자체 Apex type으로 참조 가능하며 flow variables를 member variables로 접근한다.

> Note: input access가 허용된 variables만 set 가능하고, output access가 허용된 variables만 get 가능하다. input/output 둘 다 미허용 variable은 get 시도가 무시되며 VF 페이지·`<apex:page>` 컴포넌트·Apex class 컴파일이 실패할 수 있다.

"ModemTroubleShooting" flow는 `Flow.Interview.ModemTroubleShooting`으로 참조한다:

```xml
<apex:page Controller="ModemTroubleShootingCustomSimple" tabStyle="Case">
<flow:interview name="ModemTroubleShooting" interview="{!myflow}"/>
<apex:outputText value="Default Case Prioriy: {!casePriority}"/>
</apex:page>
```

> `Default Case Prioriy`는 PDF 원문의 Priority 오타를 그대로 보존. [sic]

```apex
public class ModemTroubleShootingCustomSimple {
// You don't need to explicitly instantiate the Flow object;
// the class constructor is invoked automatically
public Flow.Interview.ModemTroubleShooting myflow { get; set; }
public String casePriority;
public String getCasePriority() {
// Access flow variables as simple member variables with get/set methods
if(myflow == null) return 'High';
else return myflow.vaCasePriority;
}
}
```

커스텀 컨트롤러면 constructor에서 초기값을 설정할 수 있다(optional, `<apex:param>`을 쓰면 불필요):

```apex
public class ModemTroubleShootingCustomSetVariables {
public Flow.Interview.ModemTroubleShooting myflow { get; set; }
public ModemTroubleShootingCustomSetVariables() {
Map<String, Object> myMap = new Map<String, Object>();
myMap.put('vaCaseNumber','123456');
myflow = new Flow.Interview.ModemTroubleShooting(myMap);
}
public String caseNumber { set; }
public String getCaseNumber() {
return myflow.vaCaseNumber;
}
}
```

`Flow.Interview` 클래스의 `getVariableValue` 메서드로 flow variable 값에 접근할 수 있다(embed된 flow나 Subflow가 호출한 별도 flow의 variable일 수 있음). interview가 현재 실행 중인 flow에서 값을 가져오며 못 찾으면 null을 반환한다. 존재는 run time에만 확인된다(compile time이 아님):

```apex
public class SampleController {
//Instance of the flow
public Flow.Interview.Flow_Template_Gallery myFlow {get; set;}
public String getBreadCrumb() {
String aBreadCrumb;
if (myFlow==null) { return 'Home';}
else aBreadCrumb = (String) myFlow.getVariableValue('vaBreadCrumb');
return(aBreadCrumb==null ? 'Home': aBreadCrumb);
}
}
```

**Flow ↔ Apex data type 매핑:**

| Flow | Apex |
|---|---|
| Text | String |
| Number | Decimal |
| Currency | Decimal |
| Date | Date, DateTime |
| Boolean | Boolean |
| Record, with a specified object | The API name of the specified object, such as Account or Case |

test class 예:

```apex
@isTest
private class ModemTroubleShootingCustomSetVariablesTest {
static testmethod void ModemTroubleShootingCustomSetVariablestests() {
PageReference pageRef = Page.ModemTroubleShootingSetVariables;
Test.setCurrentPage(pageRef);
ModemTroubleShootingCustomSetVariables mytestController =
new ModemTroubleShootingCustomSetVariables();
System.assertEquals(mytestController.getcaseNumber(), '01212212');
}
}
```

**reRender 속성** — 전체 페이지 refresh 없이 flow를 re-render:

```xml
<apex:page Controller="ModemTroubleShootingCustomSimple" tabStyle="Case">
<flow:interview name="ModemTroubleShooting" interview="{!myflow}"
reRender="casePrioritySection"/>
<apex:outputText id="casePrioritySection"
value="Default Case Prioriy: {!casePriority}"/>
</apex:page>
```

> `Default Case Prioriy`는 PDF 원문 오타. [sic]

> Warning: `reRender` 미설정 시 flow의 다른 screen으로 navigate하는 버튼을 클릭하면 component만이 아니라 전체 VF 페이지가 refresh된다.

### 4.3 Visualforce 페이지에서 Flow 변수 값 설정

embed 후 variables, record variables, collection variables, record collection variables의 초기값을 `<apex:param>`으로 설정한다.

> Note: variables는 interview 시작 시에만 설정된다. `<apex:param>` 태그는 flow launch 시 한 번만 평가된다. input access가 허용된 variables만 설정 가능하며, 미허용 variable 참조 시 설정 시도가 무시되고 컴파일이 실패할 수 있다.

**설정 방법 × 변수 유형 매트릭스 (구조만):**

PDF 원문(라인 12265–12293)은 "방법(행) × 변수 유형(열)" 격자 매트릭스이나, 셀별 가능/불가 마크(✓/✗)가 pdftotext 추출에서 누락되었다. 따라서 아래는 매트릭스의 **구조(축)만** 제시하며 셀별 가능 여부는 fabricate하지 않는다. 실제 사용 가능 조합은 바로 아래 각 예제(코드가 존재하는 조합)로만 확정한다.

- 열(변수 유형): **Variables / Record Variables / Collection Variables / Record Collection Variables**
- 행(방법): **Without a controller / With a standard controller / With a standard List controller / With a custom Apex controller / With an Interview Map**
- 본문 명시(아래 예제 근거): **Record collection variable은 array이므로 standard list controller 또는 custom Apex controller가 필요하다.**

**컨트롤러 없이 설정** — `myVariable`을 `01010101`로:

```xml
<apex:page>
<flow:interview name="flowname">
<apex:param name="myVariable" value="01010101"/>
</flow:interview>
</apex:page>
```

**standard controller로 설정** — record data 전달. `myVariable`을 `{!account}`로:

```xml
<apex:page standardController="Account" tabStyle="Account">
<flow:interview name="flowname">
<apex:param name="myVariable" value="{!account}"/>
</flow:interview>
</apex:page>
```

**standard list controller로 record collection variable 설정** — record collection variables는 array이므로 standard list controller나 custom Apex controller가 필요하다. `myCollection`을 `{!accounts}`로:

```xml
<apex:page standardController="Account" tabStyle="Account" recordSetVar="accounts">
<flow:interview name="flowname">
<apex:param name="myCollection" value="{!accounts}"/>
</flow:interview>
</apex:page>
```

**custom Apex controller로 설정** — `myVariable`을 특정 account의 Id로:

```apex
public class MyCustomController {
public Account apexVar {get; set;}
public MyCustomController() {
apexVar = [
SELECT Id, Name FROM Account
WHERE Name = 'Acme' LIMIT 1];
}
}
```

```xml
<apex:page controller="MyCustomController">
<flow:interview name="flowname">
<apex:param name="myVariable" value="{!apexVar}"/>
</flow:interview>
</apex:page>
```

record collection variable `myAccount`을 Acme 레코드들의 Id·Name으로:

```apex
public class MyCustomController {
public Account[] myAccount {
get {
return [
SELECT Id, Name FROM account
WHERE Name = 'Acme'
ORDER BY Id
] ;
}
set {
myAccount = value;
}
}
public MyCustomController () {
}
}
```

```xml
<apex:page id="p" controller="MyCustomController">
<flow:interview id="i" name="flowname">
<apex:param name="accountColl" value="{!myAccount}"/>
</flow:interview>
</apex:page>
```

**Interview Map으로 설정** — `accVar`을 특정 account Id로:

```apex
public class MyCustomController {
public Flow.Interview.TestFlow myflow { get; set; }
public MyCustomController() {
Map<String, Object> myMap = new Map<String, Object>();
myMap.put('accVar', [SELECT Id FROM Account
WHERE Name = 'Acme' LIMIT 1]);
myflow = new Flow.Interview.ModemTroubleShooting(myMap);
}
}
```

```xml
<apex:page controller="MyCustomController">
<flow:interview name="flowname" interview="{!myflow}"/>
</apex:page>
```

`accVar`을 새 account로:

```apex
public class MyCustomController {
public Flow.Interview.TestFlow myflow { get; set; }
public MyCustomController() {
Map<String, List<Object>> myMap = new Map<String, List<Object>>();
myMap.put('accVar', new Account(name = 'Acme'));
myflow = new Flow.Interview.ModemTroubleShooting(myMap);
}
}
```

```xml
<apex:page controller="MyCustomController">
<flow:interview name="flowname" interview="{!myflow}"/>
</apex:page>
```

string collection variable·number collection variable에 두 값씩 추가:

```apex
public class MyCustomController {
public Flow.Interview.flowname MyInterview { get; set; }
public MyCustomController() {
String[] value1 = new String[]{'First', 'Second'};
Double[] value2 = new Double[]{999.123456789, 666.123456789};
Map<String, Object> myMap = new Map<String, Object>();
myMap.put('stringCollVar', value1);
myMap.put('numberCollVar', value2);
MyInterview = new Flow.Interview.flowname(myMap);
}
}
```

```xml
<apex:page controller="MyCustomController">
<flow:interview name="flowname" interview="{!MyInterview}" />
</apex:page>
```

### 4.4 Flow 변수 값을 Visualforce 페이지로 가져오기

> Note: output access가 허용된 variables만 get 가능하다. 미허용 variable 참조 시 get 시도가 무시되고 컴파일이 실패할 수 있다.

record variable 값 get·표시:

```apex
public class FlowController {
public Flow.Interview.flowname myflow { get; set; }
public Case apexCaseVar;
public Case getApexCaseVar() {
return myflow.caseVar;
}
}
```

```xml
<apex:page controller="FlowController" tabStyle="Case">
<flow:interview name="flowname" interview="{!myflow}"/>
<apex:outputText value="Default Case Priority: {!apexCaseVar.Priority}"/>
</apex:page>
```

string collection variable(`emailsCollVar`) get·iterate:

```apex
public class FlowController {
public Flow.Interview.flowname myflow { get; set; }
public List<String> getVarValue() {
if (myflow == null) {
return null;
}
else {
return (List<String>)myflow.emailsCollVar;
}
}
}
```

```xml
<apex:page controller="FlowController">
<flow:interview name="flowname" interview="{!myflow}" />
<apex:repeat value="{!varValue}" var="item">
<apex:outputText value="{!item}"/><br/>
</apex:repeat>
</apex:page>
```

record collection variable을 data table로 iterate:

```apex
public class MyCustomController {
public Flow.Interview.flowname myflow { get; set; }
}
```

```xml
<apex:page controller="MyCustomController" tabStyle="Account">
<flow:interview name="flowname" interview="{!myflow}" reRender="nameSection" />
<!-- The data table iterates over the variable set in the "value" attribute and
sets that variable to the value for the "var" attribute, so that instead of
referencing {!myflow.collectionVariable} in each column, you can simply refer
to "account".-->
<apex:dataTable value="{!myflow.collectionVariable}" var="account"
rowClasses="odd,even" border="1" cellpadding="4" id="nameSection">
<!-- Add a column for each value that you want to display.-->
<apex:column >
<apex:facet name="header">Name</apex:facet>
<apex:outputlink value="/{!account['Id']}">
{!account['Name']}
</apex:outputlink>
</apex:column>
<apex:column >
<apex:facet name="header">Rating</apex:facet>
<apex:outputText value="{!account['Rating']}"/>
</apex:column>
<apex:column >
<apex:facet name="header">Billing City</apex:facet>
<apex:outputText value="{!account['BillingCity']}"/>
</apex:column>
<apex:column >
<apex:facet name="header">Employees</apex:facet>
<apex:outputText value="{!account['NumberOfEmployees']}"/>
</apex:column>
</apex:dataTable>
</apex:page>
```

시각자료: "Depending on the contents of the record collection variable in your flow, here's what that data table looks like." — (PDF 스크린샷 — 텍스트만)

### 4.5 일시정지(Pause) 제어

`allowShowPause="false"`로 pause를 방지한다. Pause 버튼 표시는 세 settings의 결합으로 정해진다:
- org Process Automation settings에 "Let users pause flows" enabled.
- 이 `<flow:interview>`의 `allowShowPause`가 false가 아님(기본값 true).
- 각 screen이 Pause 버튼 표시로 설정됨.

**Pause 버튼 표시 매트릭스** (Example 가정: 3 screens flow를 embed, Screen 1=Pause 버튼 표시 설정, Screens 2·3=미표시):

| Let Users Pause Flows (Process Automation) | allowShowPause (Visualforce 컴포넌트) | Result Pause button |
|---|---|---|
| Enabled | true or not set | Pause button appears only on the first screen |
| Enabled | false | Pause button doesn't appear for any screens in this Visualforce page |
| Not enabled | true or not set | Pause button doesn't appear for any screens |

```xml
<apex:page>
<flow:interview name="MyUniqueFlow" allowShowPause="false" />
</apex:page>
```

### 4.6 일시정지된 Interview 재개 커스터마이즈

기본은 home page의 Paused Interviews 컴포넌트에서 resume한다. customize는 `<flow:interview>`의 `pausedInterviewId` 속성으로 한다(예: contact record의 Survey Customer 버튼 — paused interview가 있으면 첫 것을 resume, 없으면 새로 시작):

```xml
<apex:page
standardController="Contact" extensions="MyControllerExtension_SurveyCustomers">
<flow:interview name="Survey_Customers" pausedInterviewId="{!pausedId}"/>
</apex:page>
```

```apex
public class MyControllerExtension_SurveyCustomers {
// Empty constructor, to allow use as a controller extension
public MyControllerExtension_SurveyCustomers(
ApexPages.StandardController stdController) { }
// Flow support methods
public String getInterviews() { return null; }
public String showList { get; set; }
public String getPausedId() {
String currentUser = UserInfo.getUserId();
List<FlowInterview> interviews =
[SELECT Id FROM FlowInterview WHERE CreatedById = :currentUser AND InterviewLabel
LIKE '%Survey Customers%'];
if (interviews == null || interviews.isEmpty()) {
return null; // early out
}
// Return the ID for the first interview in the list
return interviews.get(0).Id;
}
}
```

> Tip: VF 페이지를 page layout에 직접 embed하면 사용자가 contact에 접근할 때마다 paused interview가 자동 resume되어 의도치 않을 수 있다. custom button 사용이 권장된다.

custom button 필드 값:

| Field | Value |
|---|---|
| Label | Survey Customer |
| Display Type | Detail Page Button |
| Content Source | Visualforce Page |
| Content | YourVisualforcePage |

### 4.7 finishLocation 구성

finishLocation 미지정 시 Finish 클릭 사용자는 새 interview를 시작하고 첫 screen으로 간다. URLFOR function, $Page variable, controller로 shape한다.

> Note: Salesforce org 외부 URL로는 redirect할 수 없다. `Auth.SessionManagement.finishLoginFlow` 메서드와 finishLocation 속성을 같은 flow에서 호출하지 말 것. finishLoginFlow는 VF login flow 종료를 표시하는데, 같은 flow에 finishLocation이 있으면 flow 시작 시 실행되어 사용자에게 full session access를 부여한다.

URLFOR function — home page / detail page로:

```xml
<apex:page>
<flow:interview name="MyUniqueFlow" finishLocation="{!URLFOR('/home/home.jsp')}"/>
</apex:page>
```

```xml
<apex:page>
<flow:interview name="MyUniqueFlow" finishLocation="{!URLFOR('/001D000000IpE9X')}"/>
</apex:page>
```

$Page variable — URLFOR 없이 destination page로:

```xml
<apex:page>
<flow:interview name="MyUniqueFlow" finishLocation="{!$Page.MyUniquePage}"/>
</apex:page>
```

Controller — 세 방법:

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

```xml
<apex:page controller="myFlowController">
<h1>Congratulations!</h1> This is your new page.
<flow:interview name="flowname" finishLocation="{!pageA}"/>
</apex:page>
```

> standard controller로 같은 페이지에 record를 표시할 때 Finish 클릭 사용자는 새 flow interview를 시작하고 record 없이 첫 screen으로 간다(id query string parameter가 page URL에 보존되지 않음). 필요하면 finishLocation으로 record로 route한다.

### 4.8 Flow UI 커스터마이즈

embed 후 flow attributes + CSS classes로 button location, button style, background, screen labels look & feel을 개별 customize한다.

**Flow Button Attributes:**

| Attribute | Description |
|---|---|
| `buttonLocation` | flow UI의 navigation buttons 위치. 값: top / bottom / both. 예: `<flow:interview name="MyFlow" buttonLocation="bottom"/>`. 미지정 시 기본 both. |
| `buttonStyle` | flow navigation buttons에 style을 set으로 할당. inline styling만(CSS classes 불가). 예: `<flow:interview name="MyFlow" buttonStyle="color:#050; background-color:#fed; border:1px solid;"/>`. |

**Flow-Specific CSS Classes** — predefined flow style classes를 자체 CSS로 override한다:

| Flow Style Class | Applies to... |
|---|---|
| `FlowContainer` | The `<div>` element containing the flow. |
| `FlowPageBlockBtns` | The `<apex:pageBlockButtons>` element containing the flow navigation buttons. navigation button CSS가 다른 곳 button styling에 덮이는 것을 막기 위해 이 class를 매번 지정 권장(예: `.FlowPreviousBtn {}` 대신 `.FlowPageBlockBtns .FlowPreviousBtn {}`). |
| `FlowCancelBtn` | The Don't Pause button. |
| `FlowPauseBtn` | The Pause button. |
| `FlowPreviousBtn` | The Previous button. |
| `FlowNextBtn` | The Next button. |
| `FlowFinishBtn` | The Finish button. |
| `FlowText` | A text field label. |
| `FlowTextArea` | A text area field label. |
| `FlowNumber` | A number field label. |
| `FlowDate` | A date field label. |
| `FlowCurrency` | A currency field label. |
| `FlowPassword` | A password field label. |
| `FlowRadio` | A radio button field label. |
| `FlowDropdown` | A picklist label. |

### 4.9 Lightning Runtime으로 Flow 렌더

기본은 Classic runtime(Salesforce Classic desktop 느낌)이다. Lightning runtime은 `lightning:flow` Aura component를 VF 페이지에 추가한다.

> Important: Lightning Components for Visualforce는 Lightning Out (Beta) 기반이다(Aura·LWC를 거의 모든 web page에 embed). VF와 함께 쓰면 authentication·Connected App 설정이 불필요하다. 그 외엔 Lightning Out과 동일하다.

1. `lightning:flow` 의존성을 선언하는 Lightning Out app 생성(globally accessible, `ltng:outApp` extends, VF 페이지와 같은 org에 존재).
2. `<apex:includeLightning/>`로 JavaScript library 추가.
3. `$Lightning.use("theNamespace:theAppName", function() {});`로 dependency app 참조.
4. `$Lightning.createComponent(String type, Object attributes, String domLocator, function callback)`로 component 생성.

`lightningOutApp`:

```xml
<aura:application access="global" extends="ltng:outApp" >
<aura:dependency resource="lightning:flow"/>
</aura:application>
```

`myFlowName` flow를 Lightning runtime으로 렌더하는 VF 페이지(초기값 전달·`onstatuschange` event handler):

```xml
<apex:page >
<html>
<head>
<apex:includeLightning />
</head>
<body class="slds-scope" >
<div id="flowContainer" />
<script>
var statusChange = function (event) {
if(event.getParam("status") === "FINISHED") {
// Control what happens when the interview finishes
var outputVariables = event.getParam("outputVariables");
var key;
for(key in outputVariables) {
if(outputVariables[key].name === "myOutput") {
// Do something with an output variable
}
}
}
};
$Lightning.use("c:lightningOutApp", function() {
// Create the flow component and set the onstatuschange attribute
$Lightning.createComponent("lightning:flow",
{"onstatuschange":statusChange},
"flowContainer",
function (component) {
// Set the input variables
var inputVariables = [
{
name : "myInput",
type : "String",
value : "Hello, world"
}
];
// Start an interview in the flowContainer div and
// initialize the input variables
component.startFlow("myFlowName", inputVariables);
}
);
});
</script>
</body>
</html>
</apex:page>
```

---

## 5. 템플릿화 (Ch18)

여러 VF 페이지에서 유사한 content를 재사용하는 세 가지 전략(flexibility 높은→낮은):

- **커스텀 컴포넌트 정의:** code를 method에 캡슐화하듯 design pattern을 커스텀 컴포넌트에 캡슐화한다. 가장 flexible하며 유효한 모든 VF tags를 제한 없이 import한다. 단 reusable VF *pages* 정의에는 쓰지 말 것.
- **`<apex:composition>` 템플릿:** 각 implementation마다 portions가 바뀌는 base template. 전체 구조는 유지하되 개별 페이지 content가 다를 때(예: 같은 layout의 뉴스 기사). controller가 반환한 PageReference로 template를 정의할 수도 있다.
- **`<apex:include>`:** 전체 content를 다른 페이지에 삽입한다. 같은 content를 여러 곳에 복제할 때(예: 모든 페이지의 feedback form).

> `<apex:insert>`·`<apex:composition>` 템플릿은 이미 존재하는 VF 페이지를 참조할 때만 쓴다. 컴포넌트 집합만 복제하면 커스텀 컴포넌트가 적합하다.

> 커스텀 컴포넌트(`<apex:component>`·`<apex:attribute>`) 자체의 정의·접근 제어는 [[버튼·링크 오버라이드·Static Resource·커스텀 컴포넌트]] 참조.

### 5.1 `<apex:composition>` 템플릿

모든 `<apex:composition>` template은 하나 이상의 child `<apex:insert>`가 필요하다. `<apex:insert>`는 import하는 페이지에 section 정의가 필요함을 표시한다. `<apex:composition>`으로 import하는 VF 페이지는 `<apex:define>`으로 각 `<apex:insert>` section content를 지정한다.

빈 `myFormComposition` 페이지(`compositionExample` 컨트롤러):

```xml
<apex:page controller="compositionExample">
</apex:page>
```

컨트롤러:

```apex
public class compositionExample{
String name;
Integer age;
String meal;
String color;
Boolean showGreeting = false;
public PageReference save() {
showGreeting = true;
return null;
}
public void setNameField(String nameField) {
name = nameField;
}
public String getNameField() {
return name;
}
public void setAgeField(Integer ageField) {
age= ageField;
}
public Integer getAgeField() {
return age;
}
public void setMealField(String mealField) {
meal= mealField;
}
public String getMealField() {
return meal;
}
public void setColorField(String colorField) {
color = colorField;
}
public String getColorField() {
return color;
}
public Boolean getShowGreeting() {
return showGreeting;
}
}
```

myFormComposition skeleton template:

```xml
<apex:page controller="compositionExample">
<apex:form >
<apex:outputLabel value="Enter your name: " for="nameField"/>
<apex:inputText id="nameField" value="{!nameField}"/>
<br />
<apex:insert name="age" />
<br />
<apex:insert name="meal" />
<br />
<p>That's everything, right?</p>
<apex:commandButton action="{!save}" value="Save" id="saveButton"/>
</apex:form>
</apex:page>
```

두 `<apex:insert>`(age, meal)의 markup은 이 composition template을 호출하는 페이지에서 정의한다.

`myFullForm` 페이지 — insert 정의:

```xml
<apex:page controller="compositionExample">
<apex:messages/>
<apex:composition template="myFormComposition">
<apex:define name="meal">
<apex:outputLabel value="Enter your favorite meal: " for="mealField"/>
<apex:inputText id="mealField" value="{!mealField}"/>
</apex:define>
<apex:define name="age">
<apex:outputLabel value="Enter your age: " for="ageField"/>
<apex:inputText id="ageField" value="{!ageField}"/>
</apex:define>
<apex:outputLabel value="Enter your favorite color: " for="colorField"/>
<apex:inputText id="colorField" value="{!colorField}"/>
</apex:composition>
<apex:outputText id="greeting" rendered="{!showGreeting}" value="Hello {!nameField}.
You look {!ageField} years old. Would you like some {!colorField} {!mealField}?"/>
</apex:page>
```

- composition page가 age·meal을 요구하니 text input으로 정의한다(순서는 무관 — myFormComposition이 age를 meal 전에 표시하도록 지정).
- name field는 matching `<apex:define>` 없이도 import된다.
- color field는 controller code가 있어도 무시된다(composition template이 color named field를 요구하지 않으므로).
- age·meal은 text inputs일 필요가 없다 — `<apex:define>` 안 컴포넌트는 유효한 모든 VF tag가 가능하다.

`myAgelessForm` 페이지(age를 text 대신 문구로 정의):

```xml
<apex:page controller="compositionExample">
<apex:messages/>
<apex:composition template="myFormComposition">
<apex:define name="meal">
<apex:outputLabel value="Enter your favorite meal: " for="mealField"/>
<apex:inputText id="mealField" value="{!mealField}"/>
</apex:define>
<apex:define name="age">
<p>You look great for your age!</p>
</apex:define>
</apex:composition>
<apex:outputText id="greeting" rendered="{!showGreeting}" value="Hello {!nameField}.
Would you like some delicious {!mealField}?"/>
</apex:page>
```

> composition template은 `<apex:define>` tag의 존재만 요구한다.

**Dynamic Templates** — PageReference로 template를 할당한다(template 이름을 PageReference 반환 controller method에 할당).

`myAppliedTemplate` skeleton:

```xml
<apex:page>
<apex:insert name="name" />
</apex:page>
```

`dynamicComposition` 컨트롤러:

```apex
public class dynamicComposition {
public PageReference getmyTemplate() {
return Page.myAppliedTemplate;
}
}
```

`myDynamicComposition` 페이지:

```xml
<apex:page controller="dynamicComposition">
<apex:composition template="{!myTemplate}">
<apex:define name="name">
Hello {!$User.FirstName}, you look quite well.
</apex:define>
</apex:composition>
</apex:page>
```

### 5.2 `<apex:include>`로 기존 페이지 참조

다른 페이지의 전체 content를 변경 없이 복제한다. 같은 markup을 여러 곳에 쓸 때 적합하다.

> Note: 컴포넌트만 복제하면 `<apex:include>`를 쓰지 말 것 — 커스텀 컴포넌트가 reusable segments에 적합하다.

`formTemplate` 페이지(`templateExample` 컨트롤러):

```xml
<apex:page controller="templateExample">
</apex:page>
```

```apex
public class templateExample{
String name;
Boolean showGreeting = false;
public PageReference save() {
showGreeting = true;
return null;
}
public void setNameField(String nameField) {
name = nameField;
}
public String getNameField() {
return name;
}
public Boolean getShowGreeting() {
return showGreeting;
}
}
```

formTemplate markup:

```xml
<apex:page controller="templateExample">
<apex:form>
<apex:outputLabel value="Enter your name: " for="nameField"/>
<apex:inputText id="nameField" value="{!nameField}"/>
<apex:commandButton action="{!save}" value="Save" id="saveButton"/>
</apex:form>
</apex:page>
```

> Save 클릭 시 아무 일도 일어나지 않아야 정상(expected behavior).

`displayName` 페이지 — formTemplate include:

```xml
<apex:page controller="templateExample">
<apex:include pageName="formTemplate"/>
<apex:actionSupport event="onClick"
action="{!save}"
rerender="greeting"/>
<apex:outputText id="greeting" rendered="{!showGreeting}" value="Hello {!nameField}"/>
</apex:page>
```

> 저장 시 전체 formTemplate가 import된다. 이름 입력·Save 시 form이 showGreeting에 true를 전달 → `<apex:outputText>`가 렌더되어 이름을 표시한다.

`displayBoldName` 페이지(표시 텍스트는 변해도 templateExample logic은 동일):

```xml
<apex:page controller="templateExample">
<style type="text/css">
.boldify { font-weight: bolder; }
</style>
<apex:include pageName="formTemplate"/>
<apex:actionSupport event="onClick"
action="{!save}"
rerender="greeting"/>
<apex:outputText id="greeting" rendered="{!showGreeting}"
styleClass="boldify"
value="I hope you are well, {!nameField}."/>
</apex:page>
```

### 5.3 템플릿 컴포넌트 정리

| 컴포넌트 | 역할 |
|---|---|
| `<apex:composition template="...">` | base template import. child로 `<apex:define>` |
| `<apex:insert name="...">` | template 내 정의 필요 section 표시 |
| `<apex:define name="...">` | composition import 페이지가 insert section content 지정 |
| `<apex:include pageName="...">` | 다른 페이지 전체 content 삽입(변경 없이) |

(dynamic template: controller가 `PageReference` 반환 → `template="{!method}"`)

---

## 관련 노트

- [[SingleEmailMessage]] — `Messaging.SingleEmailMessage`·`Messaging.sendEmail`·setToAddresses/setPlainTextBody/setFileAttachments 등 이 노트 §1의 이메일 발송 Apex 클래스 레퍼런스
- [[Messaging Namespace]] — `Messaging.EmailFileAttachment`·`Messaging.SendEmailResult` 등 이메일 관련 Apex 네임스페이스 전체
- [[Flow Interview API]] — `Flow.Interview`·`getVariableValue`·`createInterview` 등 §4 `<flow:interview>`가 참조하는 Apex flow 실행 API
- [[페이지 출력 제어 — HTML·PDF·SLDS]] — `renderAs="PDF"` 렌더링 고려사항·한도(§1.2 PDF 첨부, §1.5 PDF 첨부 렌더가 참조)
- [[버튼·링크 오버라이드·Static Resource·커스텀 컴포넌트]] — `<apex:component>`·`access="global"`·`$Resource`·`URLFOR` (§1·§3·§5가 커스텀 컴포넌트·static resource 사용)
- [[JavaScript·Remoting·LMS across DOM]] — `@RemoteAction`·`Visualforce.remoting.Manager.invokeAction` (§2.6 차트 JavaScript remoting 갱신이 사용)
- [[커스텀 컨트롤러·컨트롤러 확장]] — 이 노트의 모든 커스텀 컨트롤러·controller extension(예: `MyControllerExtension_SurveyCustomers`)의 메커니즘
- [[표준 컨트롤러·표준 리스트 컨트롤러]] — `standardController`·`recordSetVar`·`StandardSetController` (§2.4 차트·§4.3 Flow 변수 설정이 사용)
- [[Visualforce 개요 — 도구·퀵스타트]] — `<apex:page>`·컨트롤러 기초·VF vs LWC
- [[apex 컴포넌트 — 출력·데이터·반복·차트]] — `apex:chart`·`apex:barSeries` 등 §2 차트 컴포넌트의 전체 속성표 레퍼런스
- [[비-apex 표준 컴포넌트 — chatter·support·liveAgent·기타]] — `messaging:emailTemplate`·`messaging:*` §1 이메일 템플릿 컴포넌트의 속성표 정본
