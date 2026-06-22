---
tags: [visualforce, vf, dynamic-binding, dynamic-component, fieldset, legacy]
source: salesforce_pages_developers_guide.pdf (Visualforce Developer Guide, v67.0 Summer '26)
created: 2026-06-21
aliases: [동적 Visualforce 바인딩, 동적 컴포넌트, sobject fieldName 바인딩, Component.Apex, field set Visualforce]
---

# 동적 Visualforce — 바인딩·동적 컴포넌트

> 런타임에 필드/컴포넌트를 결정하는 Visualforce 기법 두 가지 — 동적 바인딩(`{!reference[expression]}`, 필드를 모를 때)과 동적 컴포넌트(`Component.Apex.*`, 객체 타입을 모를 때).

> [!note] 레거시 안내
> 동적 Visualforce 바인딩·동적 컴포넌트는 모두 **클래식 Visualforce 기능**이다. Salesforce는 신규 UI 개발 시 Lightning Web Components(LWC)를 권장하며, 가이드 본문에도 동적 컴포넌트를 "primary way로 새 Visualforce 페이지를 만드는 데 쓰지 말라"는 Warning(아래 [동적 컴포넌트 개요](#동적-visualforce-컴포넌트--개요) 참조)이 명시돼 있다. 이 노트는 레거시 자료의 정확한 보존을 목적으로 한다.

이 노트는 Visualforce Developer Guide(v67.0 Summer '26)의 **Ch12 Dynamic Visualforce Bindings** + **Ch13 Dynamic Visualforce Components** 전수를 다룬다. 코드 블록은 모두 PDF 원문 verbatim이며, 원문 자체의 오타·아티팩트도 `[sic]` 표기로 그대로 보존한다.

---

## Part 1 — Dynamic Visualforce Bindings (동적 바인딩)

### 개요와 일반 형식

동적 Visualforce 바인딩은 **어떤 필드를 보여줄지 반드시 알지 못한 채** 레코드 정보를 표시하는 generic 페이지를 작성하는 방법이다. 페이지의 필드가 컴파일 타임이 아니라 **런타임에 결정**되므로, 권한·선호에 따라 청중별로 다르게 렌더되는 단일 페이지를 만들 수 있다. managed package에 포함된 Visualforce 페이지에 특히 유용하다(subscriber별 데이터를 적은 코드로 표현).

동적 바인딩은 standard·custom 객체 모두 지원한다. 일반 형식:

```
reference[expression]
```

- `reference` → sObject, Apex 클래스, 또는 global variable로 평가됨
- `expression` → 필드명 또는 관련 객체 이름인 string으로 평가됨. 관련 객체가 반환되면 재귀적으로 필드/추가 관련 객체를 선택할 수 있음

formula expression이 유효한 곳이면 어디서든 사용 가능하며, 페이지에서는 다음처럼 쓴다:

```
{!reference[expression]}
```

선택적으로 전체 동적 expression 끝에 `fieldname`을 추가할 수 있다. 동적 expression이 sObject로 resolve되면 `fieldname`은 해당 객체의 특정 필드를 가리킨다. reference가 Apex 클래스이면 그 필드는 `public` 또는 `global`이어야 한다. 예:

```
{!myContact['Account'][fieldname]}
```

동적 Visualforce 페이지는 객체의 standard controller를 사용하도록 설계하고, 추가 커스터마이즈는 controller extension으로 구현해야 한다. 동적 reference용 정보는 Apex `Schema.SobjectType` 메서드로 취득한다. 예를 들어 `Schema.SobjectType.Account.fields.getMap()`은 Account 필드명의 Map을 반환한다(컨트롤러·extension이 이해할 수 있는 형식).

> Important: Static references are checked for validity when you save a page, and an invalid reference will prevent you from saving it. Dynamic references, by their nature, can only be checked at run time, and if your page contains a dynamic reference that is invalid when the page is viewed, the page fails. It's possible to create references to custom fields or global variables which are valid, but if that field or global value is later deleted, the page will fail when it is next viewed.

#### 관계(relationship) 정의

`Object1__c`가 `Object2__c`와 관계(관계 이름 `Relationship__r`)를 갖고 `Object2__c`에 `myField`가 있을 때, 다음은 **모두 동일한 필드**를 참조한다:

```
• Object1__c.Object2__c['myField']
• Object1__c['Object2__c.myField']
• Object1__c['Object2__c']['myField']
• Object1__c.Relationship__r[myField]
• Object1__c[Relationship__r.myField]
• Object1__c[Relationship__r][myField]
```

---

### Standard 객체와 동적 reference

알려진 필드 집합으로 재사용 가능한 단순 페이지를 만드는 두 예제(교육용 단순화)와, 필드를 전혀 모르는 user-customizable 페이지 예제를 다룬다.

#### A Simple Dynamic Form

Controller extension `DynamicAccountFieldsLister`:

```apex
public class DynamicAccountFieldsLister {
public DynamicAccountFieldsLister(ApexPages.StandardController controller) {
controller.addFields(editableFields);
}
public List<String> editableFields {
get {
if (editableFields == null) {
editableFields = new List<String>();
editableFields.add('Industry');
editableFields.add('AnnualRevenue');
editableFields.add('BillingCity');
}
return editableFields ;
}
private set;
}
}
```

Page `DynamicAccountEditor`:

```html
<apex:page standardController="Account"
extensions="DynamicAccountFieldsLister">
<apex:pageMessages /><br/>
<apex:form>
<apex:pageBlock title="Edit Account" mode="edit">
<apex:pageBlockSection columns="1">
<apex:inputField value="{!Account.Name}"/>
<apex:repeat value="{!editableFields}" var="f">
<apex:inputField value="{!Account[f]}"/>
</apex:repeat>
</apex:pageBlockSection>
</apex:pageBlock>
</apex:form>
</apex:page>
```

- The DynamicAccountFieldsLister controller extension creates a list of strings called editableFields. Each string maps to a field name in the Account object.
- The editableFields list is hard-coded, but you can determine them from a query or calculation, read them from a custom setting, or otherwise providing a more dynamic experience. This is what makes dynamic references powerful.
- DynamicAccountEditor markup uses an `<apex:repeat>` tag to loop through the strings returned by editableFields.
- The `<apex:inputField>` tag displays each field in editableFields by referencing the f iteration element, which represents the name of a field on Account. The dynamic reference `{!Account[f]}` actually displays the value on the page.

#### standard controller가 필드를 로드하도록 보장하기 (addFields)

Visualforce는 페이지의 `StandardController`(또는 `StandardSetController`)가 수행하는 SOQL 쿼리를 자동 최적화해, 페이지에서 실제로 사용되는 필드만 로드한다. **정적** reference는 페이지 저장 시점에 필드를 알 수 있으므로 SOQL에 포함된다.

그러나 **동적** reference는 SOQL 쿼리가 실행된 **이후** 런타임에 평가된다. 어떤 필드가 동적 reference로만 사용되면 자동 로드되지 않고, 나중에 그 동적 reference가 평가될 때 데이터가 누락돼 SOQL error가 발생한다. 따라서 컨트롤러에 어떤 필드/관련 객체를 로드할지 추가 정보를 줘야 한다.

`addFields()` 메서드로 페이지 컨트롤러에 추가 필드 리스트를 넘긴다. 앞 예제에서는 controller extension 생성자에서 처리했다:

```apex
public DynamicAccountFieldsLister(ApexPages.StandardController controller) {
controller.addFields(editableFields);
}
```

리스트가 controller extension 인스턴스화 시점에 알려질 수 있으면 동작한다. 나중에 결정된다면 컨트롤러에 `reset()`을 호출한 뒤 필드를 추가해 revised query를 보낸다([User-Customizable 페이지](#user-customizable-페이지에-동적-reference-사용) 예제가 이 기법을 보여준다).

> Note: Adding fields to a controller is only required if you're using the default query for a StandardController or StandardSetController. If your controller or controller extension performs its own SOQL query, using addFields() is unnecessary and has no effect.
> For more information on these methods, see the StandardController documentation.

#### 관련(related) 객체에 대한 동적 reference

case 레코드용 페이지에서 일부 필드는 editable, 일부는 관련 객체에서 가져온다(관계 traverse 시연).

Controller extension `DynamicCaseLoader`:

```apex
public class DynamicCaseLoader {
public final Case caseDetails { get; private set; }
// SOQL query loads the case, with Case fields and related Contact fields
public DynamicCaseLoader(ApexPages.StandardController controller) {
String qid = ApexPages.currentPage().getParameters().get('id');
String theQuery = 'SELECT Id, ' + joinList(caseFieldList, ', ') +
' FROM Case WHERE Id = :qid';
this.caseDetails = Database.query(theQuery);
}
// A list of fields to show on the Visualforce page
public List<String> caseFieldList {
get {
if (caseFieldList == null) {
caseFieldList = new List<String>();
caseFieldList.add('CaseNumber');
caseFieldList.add('Origin');
caseFieldList.add('Status');
caseFieldList.add('Contact.Name'); // related field
caseFieldList.add('Contact.Email'); // related field
caseFieldList.add('Contact.Phone'); // related field
}
return caseFieldList;
}
private set;
}
// Join an Apex list of fields into a SELECT fields list string
private static String joinList(List<String> theList, String separator) {
if (theList == null) {
return null;
}
if (separator == null) {
separator = '';
}
String joined = '';
Boolean firstItem = true;

for (String item : theList) {
if(null != item) {
if(firstItem){
firstItem = false;
}
else {
joined += separator;
}
joined += item;
}
}
return joined;
}
}
```

Page `DynamicCaseEditor`:

```html
<apex:page standardController="Case" extensions="DynamicCaseLoader">
<br/>
<apex:form >
<apex:repeat value="{!caseFieldList}" var="cf">
<h2>{!cf}</h2>
<br/>
<!-- The only editable information should be contact information -->
<apex:inputText value="{!caseDetails[cf]}"
rendered="{!IF(contains(cf, "Contact"), true, false)}"/>
<apex:outputText value="{!caseDetails[cf]}"
rendered="{!IF(contains(cf, "Contact"), false, true)}"/>
<br/><br/>
</apex:repeat>
</apex:form>
</apex:page>
```

접근 URL 예: `https://MyDomain_login_URL/apex/DynamicCaseEditor?id=500D0000003ZtPy`

> 이 지점에서 PDF는 결과 폼 스크린샷("form similar to this one:", p.169)을 보여주나, 텍스트로 추출되지 않음 (PDF 스크린샷/figure — 텍스트만). 재현하지 않는다.

- In the controller extension, the constructor performs its own SOQL query for the object to display. Here it's because the page's StandardController doesn't load related fields by default, but there are many different use cases for needing a customized SOQL query. The query result is made available to the page through the property caseFieldList. There's no requirement to perform the query in the constructor—it can just as easily be in the property's get method.
- The SOQL query specifies the fields to load, so it's not necessary to use addFields() which was needed in A Simple Dynamic Form.
- The SOQL query is constructed at run time. A utility method converts the list of field names into a string suitable for use in a SOQL SELECT statement.
- In the markup, the form fields are displayed by iterating through the field names using `<apex:repeat>`, and using the field name variable cf in a dynamic reference to get the field value. Each field is potentially written by two components—`<apex:outputText>` and `<apex:inputText>`. The render attribute on these tags controls which of the two actually displays: if the field name contains the string "Contact," then the information is rendered in an `<apex:inputText>` tag, and if it doesn't, it's rendered in an `<apex:outputText>`.

#### User-Customizable 페이지에 동적 reference 사용

객체의 사용 가능한 필드를 모른 채 페이지를 구성한다. Account에서 Name 외 필드를 모른 채 사용자가 list를 커스터마이즈한다. `Schema.SobjectType.Account.fields.getMap()`으로 필드 목록을 얻고 동적 reference와 결합한다. 메인 list view는 처음엔 account name만 표시하고, **Customize List** 버튼으로 추가 필드를 선택·저장하면 동적 생성된 컬럼이 표시된다.

> Note: You can also build a page without knowing the fields using dynamic references with Field Sets on page 181.

Controller extension `DynamicCustomizableListHandler`:

```apex
public class DynamicCustomizableListHandler {
// Resources we need to hold on to across requests
private ApexPages.StandardSetController controller;
private PageReference savePage;
// This is the state for the list "app"
private Set<String> unSelectedNames = new Set<String>();
private Set<String> selectedNames = new Set<String>();
private Set<String> inaccessibleNames = new Set<String>();
public DynamicCustomizableListHandler(ApexPages.StandardSetController controller) {
this.controller = controller;
loadFieldsWithVisibility();
}
// Initial load of the fields lists
private void loadFieldsWithVisibility() {
Map<String, Schema.SobjectField> fields =
Schema.SobjectType.Account.fields.getMap();
for (String s : fields.keySet()) {
if (s != 'Name') { // name is always displayed
unSelectedNames.add(s);
}
if (!fields.get(s).getDescribe().isAccessible()) {
inaccessibleNames.add(s);
}
}
}
// The fields to show in the list
// This is what we generate the dynamic references from
public List<String> getDisplayFields() {
List<String> displayFields = new List<String>(selectedNames);
displayFields.sort();
return displayFields;
}
// Nav: go to customize screen
public PageReference customize() {
savePage = ApexPages.currentPage();
return Page.CustomizeDynamicList;
}
// Nav: return to list view
public PageReference show() {
// This forces a re-query with the new fields list
controller.reset();
controller.addFields(getDisplayFields());
return savePage;
}
// Create the select options for the two select lists on the page
public List<SelectOption> getSelectedOptions() {
return selectOptionsFromSet(selectedNames);
}
public List<SelectOption> getUnSelectedOptions() {
return selectOptionsFromSet(unSelectedNames);
}
private List<SelectOption> selectOptionsFromSet(Set<String> opts) {
List<String> optionsList = new List<String>(opts);
optionsList.sort();
List<SelectOption> options = new List<SelectOption>();
for (String s : optionsList) {
options.add(new
SelectOption(s, decorateName(s), inaccessibleNames.contains(s)));
}
return options;
}
private String decorateName(String s) {
return inaccessibleNames.contains(s) ? '*' + s : s;
}
// These properties receive the customization form postback data
// Each time the [<<] or [>>] button is clicked, these get the contents
// of the respective selection lists from the form
public transient List<String> selected
{ get; set; }
public transient List<String> unselected { get; set; }
// Handle the actual button clicks. Page gets updated via a
// rerender on the form
public void doAdd() {
moveFields(selected, selectedNames, unSelectedNames);
}
public void doRemove() {
moveFields(unselected, unSelectedNames, selectedNames);
}
private void moveFields(List<String> items,
Set<String> moveTo, Set<String> removeFrom) {
for (String s: items) {
if( ! inaccessibleNames.contains(s)) {
moveTo.add(s);
removeFrom.remove(s);
}
}
}
}
```

> Note: When you save the class, you may be prompted about a missing Visualforce page. This is because of the page reference in the customize() method. Click the "quick fix" link to create the page—Visualforce markup from a later block of code will be pasted into it.

- The standard controller methods addFields() and reset() are used in the show() method, which is the method that returns back to the list view. They are necessary because the list of fields to display may have changed, and so the query that loads data for display needs to be re-executed.
- Two action methods, customize() and show(), navigate from the list view to the customization form and back again.
- Everything after the navigation action methods deals with the customization form. These methods are broadly broken into two groups, noted in the comments. The first group provides the List<SelectOption> lists used by the customization form, and the second group handles the two buttons that move items from one list to the other.

Page `DynamicCustomizableList`:

```html
<apex:page standardController="Account" recordSetVar="accountList"
extensions="DynamicCustomizableListHandler">
<br/>
<apex:form >
<!-- View selection widget, uses StandardController methods -->
<apex:pageBlock>
<apex:outputLabel value="Select Accounts View: " for="viewsList"/>
<apex:selectList id="viewsList" size="1" value="{!filterId}">
<apex:actionSupport event="onchange" rerender="theTable"/>
<apex:selectOptions value="{!listViewOptions}"/>
</apex:selectList>
</apex:pageblock>
<!-- This list of accounts has customizable columns -->
<apex:pageBlock title="Accounts" mode="edit">
<apex:pageMessages />
<apex:panelGroup id="theTable">
<apex:pageBlockTable value="{!accountList}" var="acct">
<apex:column value="{!acct.Name}"/>
<!-- This is the dynamic reference part -->
<apex:repeat value="{!displayFields}" var="f">
<apex:column value="{!acct[f]}"/>
</apex:repeat>
</apex:pageBlockTable>
</apex:panelGroup>
</apex:pageBlock>
<br/>
<apex:commandButton value="Customize List" action="{!customize}"/>
</apex:form>
</apex:page>
```

상단 `<apex:pageBlock>`은 표준 views 드롭다운(StandardSetController 메서드 사용). 두 번째 `<apex:pageBlock>`의 `<apex:pageBlockTable>`은 `<apex:repeat>`로 컬럼을 추가하며, 모든 컬럼이 동적 reference `{!acct[f]}`를 사용한다.

Page `CustomizeDynamicList`:

```html
<apex:page standardController="Account" recordSetVar="ignored"
extensions="DynamicCustomizableListHandler">
<br/>
<apex:form >
<apex:pageBlock title="Select Fields to Display" id="selectionBlock">
<apex:pageMessages />
<apex:panelGrid columns="3">
<apex:selectList id="unselected_list" required="false"
value="{!selected}" multiselect="true" size="20" style="width:250px">
<apex:selectOptions value="{!unSelectedOptions}"/>
</apex:selectList>
<apex:panelGroup >
<apex:commandButton value=">>"
action="{!doAdd}" rerender="selectionBlock"/>
<br/>
<apex:commandButton value="<<"
action="{!doRemove}" rerender="selectionBlock"/>
</apex:panelGroup>
<apex:selectList id="selected_list" required="false"
value="{!unselected}" multiselect="true" size="20" style="width:250px">
<apex:selectOptions value="{!selectedOptions}"/>
</apex:selectList>
</apex:panelGrid>
<em>Note: Fields marked <strong>*</strong> are inaccessible to your account</em>
</apex:pageBlock>
<br/>
<apex:commandButton value="Show These Fields" action="{!show}"/>
</apex:form>
</apex:page>
```

- This page uses the same standard controller as the list view, even though no accounts are being displayed. This is required to maintain the view state, which contains the list of fields to display. If this form saved the user's preferences to something permanent, like a custom setting, this wouldn't be necessary.
- The first list is populated by a call to the getUnSelectedOptions() method, and when the form is submitted (via either of the two `<apex:commandButton>` components), the values in the list that are selected at time of form submission are saved into the selected property. Corresponding code handles the other list.
- These "delta" lists of fields to move are processed by the doAdd() or doRemove() method, depending on which button was clicked.

`/apex/DynamicCustomizableList` 접근 시퀀스: (1) account name만 있는 기본 상태에서 **Customize List** 클릭 → (2) display preferences 화면에서 필드를 오른쪽 리스트로 이동 후 **Show These Fields** 클릭 → (3) 커스터마이즈된 list view 표시.

> 위 3단계는 PDF에서 스크린샷으로 제시되나(p.174), 텍스트로 추출되지 않음 (PDF 스크린샷 — 텍스트만).

---

### Custom 객체·패키지와 동적 reference

패키지 개발자는 동적 Visualforce 바인딩으로 **user가 접근 가능한 필드만** 나열할 수 있다. managed package의 Visualforce 페이지가 객체 필드를 표시할 때, 패키지 개발자는 subscriber가 어떤 필드에 접근 가능한지 모르므로 subscriber별로 다르게 렌더되는 동적 페이지를 정의한다.

다음 예제는 Book(API name `Book__c`) custom 객체를 패키징해, 서로 다른 subscribing user가 같은 페이지를 어떻게 보는지 보여준다. 단계:

1. custom 객체 Book(API name `Book__c`)을 다음 필드/데이터 타입으로 생성: Title: Text(255) / Author: Text(255) / ISBN: Text(20) / Price: Currency(5, 2) / Publisher: Text(255)
2. Book 페이지 레이아웃을 편집해 custom 필드를 먼저 표시하고 Created By, Last Modified By, Owner, Name 같은 표준 필드를 일부 제거
3. 새 custom object tab 생성. object를 Book, tab style을 Books로 설정
4. Book tab으로 전환해 Book 객체 몇 개 생성(값은 무관, 레코드 몇 개만 존재하면 됨)
5. controller extension `BookExtension` 생성:

```apex
public with sharing class BookExtension {
private ApexPages.StandardController stdController;
public BookExtension (ApexPages.StandardController ct) {
this.stdController = ct;
if( ! Test.isRunningTest()) {
// You can't call addFields() in a test context, it's a bug
stdController.addFields(accessibleFields);
}
}
public List<String> accessibleFields {
get {
if (accessibleFields == null) {
// Get a list (map) of all fields on the object
Map<String, Schema.SobjectField> fields =
Schema.SobjectType.Book__c.fields.getMap();
// Save only the fields accessible by the current user
Set<String> availableFieldsSet = new Set<String>();
for (String s : fields.keySet()) {
if (fields.get(s).getDescribe().isAccessible()
// Comment out next line to show standard/system fields
&& fields.get(s).getDescribe().isCustom()
){
availableFieldsSet.add(s.toLowerCase());
if(Test.isRunningTest()) System.debug('Field: ' + s);
}
}
// Convert set to list, save to property
accessibleFields = new List<String>(availableFieldsSet);
}
return accessibleFields;
}
private set;
}
}
```

6. controller extension을 사용해 Book 값을 표시하는 Visualforce 페이지 `booksView` 생성:

```html
<apex:page standardController="Book__c" extensions="BookExtension" >
<apex:pageBlock title="{!Book__c.Name}">
<apex:pageBlockSection >
<apex:repeat value="{!accessibleFields}" var="f">
<apex:pageBlockSectionItem >
<apex:outputLabel value="{!$ObjectType['Book__c'].Fields[f].Label}"/>
<apex:outputText value="{!Book__c[f]}"/>
</apex:pageBlockSectionItem>
</apex:repeat>
</apex:pageBlockSection>
</apex:pageBlock>
</apex:page>
```

7. controller extension을 패키징하므로 Apex 클래스 테스트가 필요. `BookExtensionTest` 생성:

```apex
@isTest
public class BookExtensionTest {
public static testMethod void testBookExtension() {
// Create a book to test with
Book__c book = new Book__c();
book.Author__c = 'Harry Lime';
insert book;
Test.startTest();
// Add the page to the test context
PageReference testPage = Page.booksView;
testPage.getParameters().put('id', String.valueOf(book.Id));
Test.setCurrentPage(testPage);
// Create a controller for the book
ApexPages.StandardController sc = new ApexPages.StandardController(book);
// Real start of testing BookExtension
// BookExtension has only two methods; to get 100% code coverage, we need
// to call the constructor and get the accessibleFields property
// Create an extension with the controller
BookExtension bookExt = new BookExtension(sc);
// Get the list of accessible fields from the extension
Set<String> fields = new Set<String>(bookExt.accessibleFields);
// Test that accessibleFields is not empty
System.assert( ! fields.isEmpty());
// Test that accessibleFields includes Author__c
// This is a bad test; you can't know that subscriber won't disable
System.assert(fields.contains('Author__c'.toLowerCase()),
'Expected accessibleFields to include Author__c');
Test.stopTest();
}
}
```

> Note: This Apex test is only meant to be a sample. When creating tests that are included into packages, validate all behavior, including positive and negative results.

8. 패키지 `bookBundle` 생성, custom 객체·Visualforce 페이지·`bookExtensionTest` Apex 클래스 추가(페이지의 controller extension Apex 클래스 등 참조 요소는 자동 포함됨)
9. `bookBundle` 패키지를 subscriber 조직에 설치
10. 설치 후 books object management settings에서 새 필드 `Rating` 추가
11. 새 Book 객체 생성(값은 무관)
12. 패키지 namespace + book ID를 붙인 URL로 booksView 페이지 이동. 예: namespace가 GBOOK, book ID가 a00D0000008e7t4이면 URL은 `https://MyDomain_login_URL/apex/GBOOK__booksView?id=a00D0000008e7t4`

구독 org에서 페이지 조회 시 패키지된 Book 필드 전부 + 새로 만든 Rating 필드가 포함된다. 각 user/org는 원하는 필드를 계속 추가할 수 있고 동적 VF 페이지가 적응한다.

---

### Apex Map·List 참조

동적 바인딩을 사용하는 VF 페이지는 markup에서 Apex `Map`·`List` 데이터 타입을 참조할 수 있다.

Apex List 정의 예:

```apex
public List<String> people {
get {
return new List<String>{'Winston', 'Julia', 'Brien'};
}
set;
}
public List<Integer> iter {
get {
return new List<Integer>{0, 1, 2};
}
set;
}
```

List 값 접근:

```html
<apex:repeat value="{!iter}" var="pos">
<apex:outputText value="{!people[pos]}" /><br/>
</apex:repeat>
```

Apex Map 정의 예:

```apex
public Map<String,String> directors {
get {
return new Map<String, String> {
'Kieslowski' => 'Poland',
'del Toro' => 'Mexico',
'Gondry' => 'France'
};
}
set;
}
```

Map 키/값 접근:

```html
<apex:repeat value="{!directors}" var="dirKey">
<apex:outputText value="{!dirKey}" /> -<apex:outputText value="{!directors[dirKey]}" /><br/>
</apex:repeat>
```

`<apex:inputText>`에서 list/map의 동적 reference로, org custom 객체에 없는 데이터를 폼으로 작성할 수 있다. 단일 map이 일련의 instance variable이나 폼 데이터용 custom 객체보다 단순하다.

Map으로 폼 데이터 처리 — Page:

```html
<apex:page controller="ListsMapsController">
<apex:outputPanel id="box" layout="block">
<apex:pageMessages/>
<apex:form >
<apex:repeat value="{!inputFields}" var="fieldKey">
<apex:outputText value="{!fieldKey}"/>:
<apex:inputText value="{!inputFields[fieldKey]}"/><br/>
</apex:repeat>
<apex:commandButton action="{!submitFieldData}"
value="Submit" id="button" rerender="box"/>
</apex:form>
</apex:outputPanel>
</apex:page>
```

Controller `ListsMapsController`:

```apex
public class ListsMapsController {
public Map<String, String> inputFields { get; set; }
public ListsMapsController() {
inputFields = new Map<String, String> {
'firstName' => 'Jonny', 'lastName' => 'Appleseed', 'age' => '42' };
}
public PageReference submitFieldData() {
doSomethingInterestingWithInput();
return null;
}
public void doSomethingInterestingWithInput() {
inputFields.put('age', (Integer.valueOf(inputFields.get('age')) + 10).format());
}
}
```

Map은 sObject 또는 sObject 필드를 참조할 수 있다. 갱신하려면 input field에서 필드명을 참조한다.

Map에 sObject 담기 — Controller `MapAccCont` + Page:

```apex
public with sharing class MapAccCont {
Map<Integer, Account> mapToAccount = new Map<Integer, Account>();
public MapAccCont() {
Integer i = 0;
for (Account a : [SELECT Id, Name FROM Account LIMIT 10]) {
mapToAccount.put(i, a);
i++;
}
}
public Map<Integer, Account> getMapToAccount() {
return mapToAccount;
}
}
```

```html
<apex:page controller="MapAccCont">
<apex:form>
<apex:repeat value="{!mapToAccount}" var="accNum">
<apex:inputField value="{!mapToAccount[accNum].Name}" />
</apex:repeat>
</apex:form>
</apex:page>
```

#### Unresolved Dynamic References

런타임에 동적 reference가 resolve되지 않을 때의 동작.

Controller `ToolController`:

```apex
public class ToolController {
public Map<String, String> toolMap { get; set; }
public String myKey { get; set; }
public ToolController() {
Map<String, String> toolMap = new Map<String, String>();
toolMap.put('Stapler', 'Keeps things organized');
toolMap.put('Notebook', null);
}
}
```

**케이스 1 — 매핑 값이 없거나 null이면 페이지에 error 메시지를 렌더:**

```html
<apex:page controller="ToolController">
<!-- Both outputText values render an error on the page -->
<apex:outputText value="{!toolMap['Paperclip']}" />
<apex:outputText value="{!toolMap['Notebook']}" />
</apex:page>
```

**케이스 2 — key가 null이면 빈 문자열(blank space)을 렌더:**

```html
<apex:page controller="ToolController">
<!-- This renders a blank space -->
<apex:outputText value="{!toolMap[null]}" />
</apex:page>
```

---

### Field Set 다루기

동적 바인딩으로 Visualforce 페이지에 **field set**(필드의 그룹)을 표시할 수 있다. 예를 들어 user의 first name, middle name, last name, business title을 담는 field set을 만들 수 있다. 페이지가 managed package에 추가되면 관리자는 코드를 수정하지 않고 field set의 필드를 add/remove/reorder해 페이지에 표시되는 필드를 바꿀 수 있다.

**제약 수치:**

> PDF 원문: "Field sets are available for Visualforce pages on API version 21.0 or above. You can have up to 50 field sets referenced on a single page. An sObject can have up to 2,000 field sets."

- API version **21.0 이상**에서 사용 가능
- 단일 페이지당 참조 가능한 field set 최대 **50개**
- sObject당 field set 최대 **2,000개**

> Note: Each field set can have up to 25 fields through lookup relationships. Fields can only span one level away from the entity.

(즉 field set 하나당 lookup relationship을 통한 필드는 최대 **25개**, 필드는 entity로부터 **한 단계**만 span 가능.)

#### Visualforce로 Field Set 다루기

`$ObjectType` global variable + `FieldSets` 키워드 조합으로 field set을 직접 참조한다. 예: Contact에 `properNames` field set(3필드 표시):

```html
<apex:page standardController="Contact">
<apex:repeat value="{!$ObjectType.Contact.FieldSets.properNames}" var="f">
<apex:outputText value="{!Contact[f]}" /><br/>
</apex:repeat>
</apex:page>
```

field set의 각 필드는 다음 특수 프로퍼티에 접근할 수 있다 (PDF p.181, 2열 표 — Property Name / Description):

| Property Name | Description |
|---|---|
| `DBRequired` | Indicates whether the field is required for the object |
| `FieldPath` | Lists the field's spanning info |
| `Label` | The UI label for the field |
| `Required` | Indicates whether the field is required in the field set |
| `Type` | The data type for the field |

labels/data types 접근 예:

```html
<apex:page standardController="Contact">
<apex:pageBlock title="Fields in Proper Names">
<apex:pageBlockTable value="{!$ObjectType.Contact.FieldSets.properNames}" var="f">
<apex:column value="{!f}">
<apex:facet name="header">Name</apex:facet>
</apex:column>
<apex:column value="{!f.Label}">
<apex:facet name="header">Label</apex:facet>
</apex:column>
<apex:column value="{!f.Type}" >
<apex:facet name="header">Data Type</apex:facet>
</apex:column>
</apex:pageBlockTable>
</apex:pageBlock>
</apex:page>
```

managed package로 배포하면 subscriber가 `properNames` field set을 편집할 수 있다(로직은 동일, 표현만 subscriber 구현별 차이). managed package의 field set을 참조할 때는 org namespace를 prepend해야 한다. `properNames`가 Spectre org에서 왔다면:

```
{!$ObjectType.Contact.FieldSets.Spectre__properNames}
```

#### Apex로 Field Set 다루기

표준 controller 사용 시 field set 필드는 자동 로드된다. custom controller 사용 시 필요한 필드를 SOQL query에 추가해야 한다. Apex는 두 Schema 객체 `Schema.FieldSet`, `Schema.FieldSetMember`를 제공한다(자세한 내용은 Lightning Platform Apex Code Developer's Guide 참조).

Sample — Merchandise 커스텀 객체의 `Dimensions` field set 표시.

Controller `MerchandiseDetails`:

```apex
public class MerchandiseDetails {
public Merchandise__c merch { get; set; }
public MerchandiseDetails() {
this.merch = getMerchandise();
}
public List<Schema.FieldSetMember> getFields() {
return SObjectType.Merchandise__c.FieldSets.Dimensions.getFields();
}
private Merchandise__c getMerchandise() {
String query = 'SELECT ';
for(Schema.FieldSetMember f : this.getFields()) {
query += f.getFieldPath() + ', ';
}
query += 'Id, Name FROM Merchandise__c LIMIT 1';
return Database.query(query);
}
}
```

Page:

```html
<apex:page controller="MerchandiseDetails">
<apex:form >
<apex:pageBlock title="Product Details">
<apex:pageBlockSection title="Product">
<apex:inputField value="{!merch.Name}"/>
</apex:pageBlockSection>
<apex:pageBlockSection title="Dimensions">
<apex:repeat value="{!fields}" var="f">
<apex:inputField value="{!merch[f.fieldPath]}"
required="{!OR(f.required, f.dbrequired)}"/>
</apex:repeat>
</apex:pageBlockSection>
</apex:pageBlock>
</apex:form>
</apex:page>
```

required 판단 expression에 주목 — field set 정의 또는 필드 자체 정의 중 하나로 required가 될 수 있으며, expression이 두 케이스를 모두 처리한다.

#### Field Set Considerations

> [!warning] PDF 아티팩트 [sic]
> PDF 원문(p.183)은 다음과 같이 시작하나, 예고된 "two categories"의 실제 항목이 본문에 나열되지 않는다(원문 자체 결함 또는 시각요소 변환 손실로 추정). 임의로 카테고리를 채우지 않고 원문 그대로 보존한다.
> ```
> Field Set Considerations
> Fields added to a field set can be in one of two categories:
> The order in which a developer lists displayed fields determines their order of appearance on a Visualforce page.
> ```

package developer best practices (verbatim):

- Subscribers with installed field sets can add fields that your page didn't account for. There is no way to conditionally omit some fields from a field set iteration, so make sure that any field rendered through your field set works for all field types.
- We recommend that you add only non-essential fields to your field set. This ensures that even if a subscriber removes all fields in the field set, Visualforce pages that use that field set still function.

> Note: Field sets are available for Visualforce pages on API version 21.0 or above.

---

### Global Variable에 대한 동적 reference

Visualforce 페이지는 동적 바인딩으로 markup에서 global variable을 참조할 수 있다. global variable은 현재 user·조직·데이터 schema 정보에 접근하게 해준다. global variable 참조는 sObject·Apex 클래스 참조와 동일하게 `reference[expression]` 패턴을 쓰며, 이때 `reference`가 global variable이다.

#### $Resource — static resource 동적 참조

static resource를 `$Resource` global variable로 참조한다. expression에 static resource 이름을 제공: `{!$Resource[StaticResourceName] }`. 예를 들어 `getCustomLogo` 메서드가 static resource 이미지명을 반환하면 `<apex:image value="{!$Resource[customLogo]}"/>`.

Controller extension `ThemeHandler`:

```apex
public class ThemeHandler {
public ThemeHandler(ApexPages.StandardController controller) { }
public static Set<String> getAvailableThemes() {
// You must have at least one uploaded static resource
// or this code will fail. List their names here.
return(new Set<String> {'Theme_Color', 'Theme_BW'});
}
public static List<SelectOption> getThemeOptions() {
List<SelectOption> themeOptions = new List<SelectOption>();
for(String themeName : getAvailableThemes()) {
themeOptions.add(new SelectOption(themeName, themeName));
}
return themeOptions;
}
public String selectedTheme {
get {
if(null == selectedTheme) {
// Ensure we always have a theme
List<String> themeList = new List<String>();
themeList.addAll(getAvailableThemes());
selectedTheme = themeList[0];
}
return selectedTheme;
}
set {
if(getAvailableThemes().contains(value)) {
selectedTheme = value;
}
}
}
}
```

- It has an empty constructor, because there's no default constructor for controller extensions.
- Add the name of your uploaded static resource files theme to the getAvailableThemes method. Using Static Resources on page 153 provides details of how to create and upload static resources, in particular, zipped archives containing multiple files.
- The last two methods provide the list of themes and the selected theme for use in the Visualforce form components.

Page:

```html
<apex:page standardController="Account"
extensions="ThemeHandler" showHeader="false">
<apex:form >
<apex:pageBlock id="ThemePreview" >
<apex:stylesheet
value="{!URLFOR($Resource[selectedTheme], 'styles/styles.css')}"/>
<h1>Theme Viewer</h1>
<p>You can select a theme to use while browsing this site.</p>
<apex:pageBlockSection >
<apex:outputLabel value="Select Theme: " for="themesList"/>
<apex:selectList id="themesList" size="1" value="{!selectedTheme}">
<apex:actionSupport event="onchange" rerender="ThemePreview"/>
<apex:selectOptions value="{!themeOptions}"/>
</apex:selectList>
</apex:pageBlockSection>
<apex:pageBlockSection >
<div class="custom" style="padding: 1em;"><!-- Theme CSS hook -->
<h2>This is a Sub-Heading</h2>
<p>This is standard body copy. Lorem ipsum dolor sit amet, consectetur
adipiscing elit. Quisque neque arcu, pellentesque in vehicula vitae, dictum
id dolor. Cras viverra consequat neque eu gravida. Morbi hendrerit lobortis
mauris, id sollicitudin dui rhoncus nec.</p>
<p><apex:image
value="{!URLFOR($Resource[selectedTheme], 'images/logo.png')}"/></p>
</div><!-- End of theme CSS hook -->
</apex:pageBlockSection>
</apex:pageBlock>
</apex:form>
</apex:page>
```

- The page uses the Account standard controller, but has nothing to do with accounts. You have to specify a controller to use a controller extension.
- The first `<apex:pageBlockSection>` contains the theme selection widget. Using `<apex:actionSupport>`, changes to the selection menu re-render the whole `<apex:pageBlock>`. This is so that the `<apex:stylesheet>` tag gets the updated selectedTheme for its dynamic reference.
- The theme preference selected here is only preserved in the view state for the controller, but you could easily save it to a custom setting instead, and make it permanent.
- The zip files that contain the graphics and style assets for each theme need to have a consistent structure and content. That is. there needs to be an images/logo.png in each theme zip file, and so on. *[sic — "That is." 오타]*

이 페이지엔 `$Resource` 동적 reference가 2개뿐이지만 stylesheet·graphic asset 양쪽 접근 방법을 보여준다. 모든 `<apex:image>` 태그에 동적 reference를 사용해 look & feel을 전면 변경할 수 있다.

`$Label`과 `$Setup`은 `$Resource`와 유사하게, 조직 관리자나 user가 Salesforce에서 설정한 텍스트 값/저장된 설정에 접근하게 해준다:

- Custom labels allow you to create text messages that can be consistently used throughout your application. Label text can also be translated and automatically displayed in a user's default language.
- Custom settings allow you to create settings for your application, which can be updated by administrators or by users themselves. They can also be hierarchical, so that user-level settings override role- or organization-level settings.

#### $Action — action 메서드 동적 참조

`$Action` global variable로 객체 타입 또는 특정 레코드의 유효한 action을 동적 참조한다. 주 용도는 그 action을 수행하는 URL 생성이다. 예: `<apex:outputLink>`에서 `{!URLFOR($Action[objectName].New)}` + controller 메서드 `getObjectName()`.

Controller extension `DynamicActionsHandler`:

```apex
public with sharing class DynamicActionsHandler {
public List<CustomObjectDetails> customObjectDetails { get; private set; }
public DynamicActionsHandler(ApexPages.StandardController cont) {
this.loadCustomObjects();
}
public void loadCustomObjects() {
List<CustomObjectDetails> cObjects = new List<CustomObjectDetails>();
// Schema.getGlobalDescribe() returns lightweight tokens with minimal metadata
Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
for(String obj : gd.keySet()) {
if(obj.endsWith('__c')) {
// Get the full metadata details only for custom items
Schema.DescribeSObjectResult objD = gd.get(obj).getDescribe();
if( ! objD.isCustomSetting()) {
// Save details for custom objects, not custom settings
CustomObjectDetails objDetails = new CustomObjectDetails(
obj, objD.getLabel(), objD.isCreateable());
cObjects.add(objDetails);
}
}
}
cObjects.sort();
this.customObjectDetails = cObjects;
}
public class CustomObjectDetails implements Comparable {
public String nameStr
{ get; set; }
public String labelStr { get; set; }
public Boolean creatable { get; set; }
public CustomObjectDetails(String aName, String aLabel, Boolean isCreatable) {
this.nameStr = aName;
this.labelStr = aLabel;
this.creatable = isCreatable;
}
public Integer compareTo(Object objToCompare) {
CustomObjectDetails cod = (CustomObjectDetails)objToCompare;
return(this.nameStr.compareTo(cod.nameStr));
}
}
}
```

- The loadCustomObjects method uses Apex schema methods to get metadata information about available custom objects. The Schema.getGlobalDescribe method is a lightweight operation to get a small set of metadata about available objects and custom settings. The method scans the collection looking for items with names that end in "__c", which indicates they are custom objects or settings. These items are more deeply inspected using getDescribe, and selected metadata is saved for the custom objects.
- Using if(obj.endsWith('__c')) to test whether an item is a custom object or not may feel like a "hack", but the alternative is to call obj.getDescribe().isCustom(), which is expensive, and there is a governor limit on the number of calls to getDescribe. Scanning for the "__c" string as a first pass on a potentially long list of objects is more efficient.
- This metadata is saved in an inner class, CustomObjectDetails, which functions as a simple structured container for the fields to be saved.
- CustomObjectDetails implements the Comparable interface, which makes it possible to sort a list of custom objects details by an attribute of each object, in this case, the custom object's name.

Page:

```html
<apex:page standardController="Account"
extensions="DynamicActionsHandler">
<br/>
<apex:dataTable value="{!customObjectDetails}" var="coDetails">
<apex:column >
<apex:facet name="header">Custom Object</apex:facet>
<apex:outputText value="{!coDetails.labelStr}"/>
</apex:column>
<apex:column >
<apex:facet name="header">Actions</apex:facet>
<apex:outputLink value="{!URLFOR($Action[coDetails.nameStr].New)}"
rendered="{!coDetails.creatable}">[Create]</apex:outputLink><br/>
<apex:outputLink value="{!URLFOR($Action[coDetails.nameStr].List,
$ObjectType[coDetails.nameStr].keyPrefix)}">[List]</apex:outputLink>
</apex:column>
</apex:dataTable>
</apex:page>
```

특정 레코드를 지정하지 않은 페이지에선 New, List만 유용하다. 레코드를 query하는 페이지에선 `$Action`이 View, Clone, Edit, Delete 등을 제공한다. 특정 표준 객체는 데이터 타입에 맞는 추가 action을 갖는다.

#### $ObjectType — schema 정보 동적 참조

`$ObjectType` global variable은 org 객체의 다양한 schema 정보(필드명·label·data type 등)에 접근한다. "deep" global variable이라 "double dynamic" reference를 쓸 수 있다:

```
$ObjectType[sObjectName].fields[fieldName].Type
```

Controller `DynamicObjectHandler`:

```apex
public class DynamicObjectHandler {
// This class acts as a controller for the DynamicObjectViewer component
private String objType;
private List<String> accessibleFields;
public sObject obj {
get;
set {
setObjectType(value);
discoverAccessibleFields(value);
obj = reloadObjectWithAllFieldData();
}
}
// The sObject type as a string
public String getObjectType() {
return(this.objType);
}
public String setObjectType(sObject newObj) {
this.objType = newObj.getSObjectType().getDescribe().getName();
return(this.objType);
}
// List of accessible fields on the sObject
public List<String> getAccessibleFields() {
return(this.accessibleFields);
}
private void discoverAccessibleFields(sObject newObj) {
this.accessibleFields = new List<String>();
Map<String, Schema.SobjectField> fields =
newObj.getSObjectType().getDescribe().fields.getMap();
for (String s : fields.keySet()) {
if ((s != 'Name') && (fields.get(s).getDescribe().isAccessible())) {
this.accessibleFields.add(s);
}
}
}
private sObject reloadObjectWithAllFieldData() {
String qid = ApexPages.currentPage().getParameters().get('id');
String theQuery = 'SELECT ' + joinList(getAccessibleFields(), ', ') +
' FROM ' + getObjectType() +
' WHERE Id = :qid';
return(Database.query(theQuery));
}
// Join an Apex List of fields into a SELECT fields list string
private static String joinList(List<String> theList, String separator) {
if (theList == null)
{ return null; }
if (separator == null) { separator = ''; }
String joined = '';
Boolean firstItem = true;
for (String item : theList) {
if(null != item) {
if(firstItem){ firstItem = false; }
else { joined += separator; }
joined += item;
}
}
return joined;
}
}
```

- Visualforce components can't use controller extensions, so this class is written as a controller instead. There is no constructor defined, so the class uses the default constructor.
- To collect metadata for an object, the controller must know the object. Visualforce constructors can't take arguments so there is no way to know what the object of interest is at the time of instantiation. Instead, the metadata discovery is triggered by the setting of the public property obj.
- Several of the methods in this class use system schema discovery methods, in slightly different ways than prior examples.

Visualforce component `DynamicObjectViewer`:

```html
<apex:component controller="DynamicObjectHandler">
<apex:attribute name="rec" type="sObject" required="true"
description="The object to be displayed." assignTo="{!obj}"/>
<apex:form >
<apex:pageBlock title="{!objectType}">
<apex:pageBlockSection title="Fields" columns="1">
<apex:dataTable value="{!accessibleFields}" var="f">
<apex:column >
<apex:facet name="header">Label</apex:facet>
<apex:outputText value="{!$ObjectType[objectType].fields[f].Label}"/>
</apex:column>
<apex:column >
<apex:facet name="header">API Name</apex:facet>
<apex:outputText value="{!$ObjectType[objectType].fields[f].Name}"/>
</apex:column>
<apex:column >
<apex:facet name="header">Type</apex:facet>
<apex:outputText value="{!$ObjectType[objectType].fields[f].Type}"/>
</apex:column>
<apex:column >
<apex:facet name="header">Value</apex:facet>
<apex:outputText value="{!obj[f]}"/>
</apex:column>
</apex:dataTable>
</apex:pageBlockSection>
<apex:pageBlockSection columns="4">
<apex:commandButton value="View"
action="{!URLFOR($Action[objectType].View, obj.Id)}"/>
<apex:commandButton value="Edit"
action="{!URLFOR($Action[objectType].Edit, obj.Id)}"/>
<apex:commandButton value="Clone"
action="{!URLFOR($Action[objectType].Clone, obj.Id)}"/>
<apex:commandButton value="Delete"
action="{!URLFOR($Action[objectType].Delete, obj.Id)}"/>
</apex:pageBlockSection>
</apex:pageBlock>
</apex:form>
</apex:component>
```

- Any page that uses this component must look up a record. To do so, use the standard controller for that object, and specify the Id of the record in the URL. For example, `https://<MyDomain_login_URL>/apex/DynamicContactPage?id=003D000000Q5GHE`.
- The selected record is immediately passed into the component's obj attribute. This parameter is used for all of the object metadata discovery.
- The three double dynamic references, which start with `$ObjectType[objectType].fields[f]`, display the metadata for each field, while the normal dynamic reference displays the actual value of the field.
- For the data value, the value is `{!obj[f]}`, using a getter method in the controller, not the perhaps more natural `{!rec[f]}`, which is the parameter to the component. The reason is simple, the obj attribute has been updated to load data for all of the fields, while rec has remained unchanged from what was loaded by the standard controller, and so only has the Id field loaded.

component 사용 페이지 2종:

```html
<apex:page standardController="Account">
<c:DynamicObjectViewer rec="{!account}"/>
</apex:page>
<apex:page standardController="Contact">
<c:DynamicObjectViewer rec="{!contact}"/>
</apex:page>
```

---

## Part 2 — Dynamic Visualforce Components (동적 컴포넌트)

### 동적 Visualforce 컴포넌트 — 개요

Visualforce는 기본적으로 Salesforce look-and-feel에 맞는 UI를 만드는 **static, markup-driven** 언어다. 그러나 표준 markup으로는 어렵거나 불가능한 복잡한 UI 동작을 위해 페이지를 **프로그래밍 방식으로** 생성해야 할 때가 있다.

동적 Visualforce 컴포넌트는 user 권한·action, user/조직 선호, 표시 데이터 등 다양한 상태에 따라 컴포넌트 트리의 내용·배치를 달리하는 페이지를 만드는 방법이다. 표준 markup 대신 **Apex로** 설계한다.

Apex에서의 정의 형식:

```
Component.Component_namespace.Component_name
```

예: `<apex:dataTable>` → `Component.Apex.DataTable`

> Note: The Standard Visualforce Component Reference contains the dynamic representation for all valid Visualforce components.

Apex로 표현된 VF 컴포넌트는 일반 클래스처럼 동작한다. 표준 VF 컴포넌트의 모든 attribute는 Apex 표현에서 get/set 메서드를 가진 property로 제공된다. 예를 들어 `<apex:outputText>`의 value attribute 조작:

```apex
Component.Apex.OutputText outText = new Component.Apex.OutputText();
outText.value = 'Some dynamic output text.';
```

사용 시나리오:

- You can use dynamic Visualforce components inside complex control logic to assemble components in combinations that would be challenging or impossible to create using equivalent standard Visualforce. For example, with standard Visualforce components, you typically control the visibility of components using the rendered attribute with the global IF() formula function. By writing your control logic in Apex, you can choose to display components dynamically with a more natural mechanism.
- If you know that you'll be iterating over objects with certain fields, but not specifically which objects, dynamic Visualforce components can "plug in" the object representation by using a generic sObject reference. For more information, see Example Using a Related List on page 198.

> [!warning] Warning (PDF 원문)
> Dynamic Visualforce components are not intended to be the primary way to create new Visualforce pages in your organization. Existing Visualforce pages shouldn't be rewritten in a dynamic manner and, for most use cases, standard Visualforce components are acceptable and preferred. You should only use dynamic Visualforce components when the page must adapt itself to user state or actions in ways that can't be elegantly coded into static markup.

> **동적 컴포넌트 vs 동적 바인딩 핵심 구분:** 동적 **컴포넌트**는 참조할 **객체 타입**을 모를 때, 동적 **바인딩**은 접근할 **필드**를 모를 때 최적이다.

---

### 동적 컴포넌트 제약

모든 VF 기능이 dynamic context에서 의미 있는 건 아니므로, 일부 컴포넌트는 dynamic으로 제공되지 않는다.

**Apex에 대응 dynamic representation이 없는 표준 VF 컴포넌트(전수):**

- `<apex:attribute>`
- `<apex:component>`
- `<apex:componentBody>`
- `<apex:composition>`
- `<apex:define>`
- `<apex:dynamicComponent>`
- `<apex:include>`
- `<apex:insert>`
- `<apex:param>`
- `<apex:variable>`

나머지 제약:

- If a dynamic Visualforce component refers to a specific sObject field, and that field is later deleted, the Apex code for that field reference will still compile, but the page will fail when it is viewed. Also, you can create references to global variables such as $Setup or $Label, and then delete the referenced item, with similar results. Please verify such pages continue to work as expected.
- Dynamic Visualforce pages and expressions check attribute types more strictly than static pages.
- You can't set "pass-through" HTML attributes on dynamic components.

---

### 동적 컴포넌트 생성·표시

동적 컴포넌트를 페이지에 임베드하는 2단계:

- Adding an `<apex:dynamicComponent>` tag somewhere on your page. This tag acts as a placeholder for your dynamic component.
- Developing a dynamic Visualforce component in your controller or controller extension.

`<apex:dynamicComponent>` 태그는 required attribute 1개 — **`componentValue`** — 를 가지며, dynamic component를 반환하는 Apex 메서드 이름을 받는다.

Page:

```html
<apex:page standardController="Contact" extensions="DynamicComponentExample">
<apex:dynamicComponent componentValue="{!headerWithDueDateCheck}"/>
<apex:form>
<apex:inputField value="{!Contact.LastName}"/>
<apex:commandButton value="Save" action="{!save}"/>
</apex:form>
</apex:page>
```

Controller `DynamicComponentExample`:

```apex
public class DynamicComponentExample {
public DynamicComponentExample(ApexPages.StandardController con) { }
public Component.Apex.SectionHeader getHeaderWithDueDateCheck() {
date dueDate = date.newInstance(2011, 7, 4);
boolean overdue = date.today().daysBetween(dueDate) < 0;
Component.Apex.SectionHeader sectionHeader = new Component.Apex.SectionHeader();
if (overdue) {
sectionHeader.title = 'This Form Was Due On ' + dueDate.format() + '!';
return sectionHeader;
} else {
sectionHeader.title = 'Form Submission';
return sectionHeader;
}
}
}
```

단일 페이지에 여러 `<apex:dynamicComponent>`를 둘 수 있다.

> Each dynamic component has access to a common set of methods and properties. You can review this list in the Apex Developer's Guide in the chapter titled "Component Class.". *[sic — 마침표 중복 ".".]*

#### Dynamic Custom Components

custom component를 dynamic하게 쓰는 건 표준 VF 컴포넌트와 완전히 동일하며, namespace만 custom component의 것으로 바꾼다. custom component는 `c` namespace를 쓴다:

```apex
Component.c.MyCustomComponent myDy = new Component.c.MyCustomComponent();
```

자신의 컴포넌트는 namespace를 생략할 수 있다:

```apex
Component.MyCustomComponent myDy = new Component.MyCustomComponent();
```

패키지의 third party 컴포넌트는 패키지 제공자 namespace를 사용한다:

```apex
Component.TheirName.UsefulComponent usefulC = new Component.TheirName.UsefulComponent();
```

#### 생성자로 attribute 전달

property 대신 생성자로 attribute 목록을 전달할 수 있다:

```apex
Component.Apex.DataList dynDataList =
new Component.Apex.DataList(id='myDataList', rendered=true);
```

생성자에 정의되지 않은 attribute는 컴포넌트 기본값을 쓴다.

생성자에서 **반드시** attribute를 정의해야 하는(property로는 안 되는) 컴포넌트 2개:

- `Component.Apex.Detail` must have `showChatter=true` passed to its constructor if you want to display the Chatter information and controls for a record. Otherwise, this attribute is always false.
- `Component.Apex.SelectList` must have `multiSelect=true` passed to its constructor if you want the user to be able to select more than one option at a time. Otherwise, this value is always false.

이 값들은 String이 아닌 Boolean이므로 작은따옴표로 감싸지 않는다.

> [!warning] Warning (PDF 원문)
> You can't pass attributes through the class constructor if the attribute name matches an Apex keyword. For example, Component.Apex.RelatedList can't pass list through the constructor, because List is a reserved keyword. Similarly, Component.Apex.OutputLabel can't define the for attribute in the constructor, because it's also a keyword.

#### Expression·임의 HTML 정의

`expressions` property로 EL 문장을 추가한다. property 이름 앞에 `expressions`를 붙여 expression statement를 전달하며, static markup처럼 `{! }`로 wrap한다:

```apex
Component.Apex.Detail detail = new Component.Apex.Detail();
detail.expressions.subject = '{!Account.ownerId}';
detail.relatedList = false;
detail.title = false;
```

유효 expression엔 표준·custom 객체 필드 참조가 포함되며, global variable·function도 쓸 수 있다:

```apex
Component.Apex.OutputText head1 = new Component.Apex.OutputText();
head1.expressions.value =
'{!IF(CONTAINS($User.FirstName, "John"), "Hello John", "Hey, you!")}';
```

expression 값 전달은 이를 지원하는 attribute에만 유효하다. `expressions` property 밖의 `{! }`는 expression이 아니라 literal로 해석된다.

순수 HTML을 포함하려면 `Component.Apex.OutputText`의 `escape` property를 false로 설정한다:

```apex
Component.Apex.OutputText head1 = new Component.Apex.OutputText();
head1.escape = false;
head1.value = '<h1>This header contains HTML</h1>';
```

#### Facet 정의

expression 정의와 유사하게 facet도 dynamic component의 특수 property다:

```apex
Component.Apex.DataTable myTable = new Component.Apex.DataTable(var='item');
myTable.expressions.value = '{!items}';
Component.Apex.OutputText header =
new Component.Apex.OutputText(value='This is My Header');
myTable.facets.header = header;
```

facet 자세한 내용은 Best Practices for Using Component Facets on page 398 참조.

#### Child Node 정의

`childComponents` property로 child node를 추가한다. 이 property는 `List of Component.Apex objects`를 참조한다.

```apex
public Component.Apex.PageBlock getDynamicForm() {
Component.Apex.PageBlock dynPageBlock = new Component.Apex.PageBlock();
// Create an input field for Account Name
Component.Apex.InputField theNameField = new Component.Apex.InputField();
theNameField.expressions.value = '{!Account.Name}';
theNameField.id = 'theName';
Component.Apex.OutputLabel theNameLabel = new Component.Apex.OutputLabel();
theNameLabel.value = 'Rename Account?';
theNameLabel.for = 'theName';
// Create an input field for Account Number
Component.Apex.InputField theAccountNumberField = new Component.Apex.InputField();
theAccountNumberField.expressions.value = '{!Account.AccountNumber}';
theAccountNumberField.id = 'theAccountNumber';
Component.Apex.OutputLabel theAccountNumberLabel = new Component.Apex.OutputLabel();
theAccountNumberLabel.value = 'Change Account #?';
theAccountNumberLabel.for = 'theAccountNumber';
// Create a button to submit the form
Component.Apex.CommandButton saveButton = new Component.Apex.CommandButton();
saveButton.value = 'Save';
saveButton.expressions.action = '{!Save}';
// Assemble the form components
dynPageBlock.childComponents.add(theNameLabel);
dynPageBlock.childComponents.add(theNameField);
dynPageBlock.childComponents.add(theAccountNumberLabel);
dynPageBlock.childComponents.add(theAccountNumberField);
dynPageBlock.childComponents.add(saveButton);
return dynPageBlock;
}
```

markup:

```html
<apex:form>
<apex:dynamicComponent componentValue="{!dynamicForm}"/>
</apex:form>
```

동등한 static markup:

```html
<apex:form>
<apex:pageBlock>
<apex:outputLabel for="theName"/>
<apex:inputField value="{!Account.Name}" id="theName"/>
<apex:outputLabel for="theAccountNumber"/>
<apex:inputField value="{!Account.AccountNumber}" id="theAccountNumber"/>
<apex:commandButton value="Save" action="{!save}"/>
</apex:pageBlock>
</apex:form>
```

동등 static markup의 요소 순서는 `childComponents`에 add된 순서이지, getDynamicForm 메서드의 Apex 코드에서 선언된 순서가 아니다.

---

### Deferred Creation — invokeAfterAction

동적 컴포넌트를 정의하는 Apex 메서드는 기본적으로 **page load 시점**에, 페이지에 정의된 어떤 action 메서드보다 **먼저** 실행된다. dynamic component의 `invokeAfterAction` attribute를 `true`로 설정하면 page action 완료를 **기다린 후** 동적 컴포넌트 생성 메서드가 실행된다. 이를 통해 page 초기화 action이나 callout 결과에 따라 변하는 동적 컴포넌트를 설계할 수 있다.

Page:

```html
<apex:page controller="DeferredDynamicComponentController"
action="{!pageActionUpdateMessage}" showHeader="false">
<apex:dynamicComponent componentValue="{!dynamicComp}" invokeAfterAction="true"/>
</apex:page>
```

Controller `DeferredDynamicComponentController`:

```apex
public class DeferredDynamicComponentController {
private String msgText { get; set; }
public DeferredDynamicComponentController() {
this.msgText = 'The controller is constructed.';
}
public Component.Apex.OutputPanel getDynamicComp() {
// This is the component to return
Component.Apex.OutputPanel dynOutPanel= new Component.Apex.OutputPanel();
dynOutPanel.layout = 'block';
// Child component to hold the message text
Component.Apex.OutputText msgOutput = new Component.Apex.OutputText();
msgOutput.value = this.msgText;
dynOutPanel.childComponents.add(msgOutput);
return dynOutPanel;
}
public Object pageActionUpdateMessage() {
this.msgText= 'The page action method has been run.';
return null;
}
}
```

기본 동작에선 생성자에서 set한 msgText가 표시된다. `invokeAfterAction="true"` 설정 시 페이지가 `pageActionUpdateMethod` 완료를 기다린 후 dynamic component를 생성하므로, `pageActionUpdateMessage` action 메서드에서 set한 msgText 값이 표시된다.

> Note: The invokeAfterAction attribute is available for dynamic components in pages set to API version 31.0 or later.

#### Deferred Creation과 다른 action

`invokeAfterAction="true"`는 component 생성과 페이지의 action 메서드 순서를 뒤집는다. 다음 모든 컴포넌트의 action 메서드 실행 순서가 영향을 받는다(전수):

- `<apex:actionFunction>`
- `<apex:actionPoller>`
- `<apex:actionSupport>`
- `<apex:commandButton>`
- `<apex:commandLink>`
- `<apex:page>`

**`invokeAfterAction="false"` (기본) 실행 순서:**

1. Invoke the dynamic component's creation method, which constructs the component.
2. Invoke the action method.
3. Rerender the page.

**`invokeAfterAction="true"` 실행 순서:**

1. Invoke the action method.
2. Invoke the dynamic component's creation method, which constructs the component.
3. Rerender the page.

> Note: In the second case, if the action method returns a PageReference, Visualforce will redirect the request to the new page, and the dynamic component's creation method won't be run. To avoid a possible order-of-execution bug, it's a best practice that methods that create dynamic components don't have side effects.

---

### Example — Related List 사용

동적 Visualforce 컴포넌트는 참조할 객체 타입을 모를 때 가장 유용하고, 동적 Visualforce 바인딩은 접근할 필드를 모를 때 가장 유용하다. 다음 시나리오는 접근할 필드 집합은 알려진, 간단하고 재사용 가능한 페이지를 구성한다. 페이지와 custom 객체를 unmanaged package에 넣어 동일 조직 내에 배포한다.

셋업 단계:

1. custom object `Classroom`을 생성한다. 객체 두 개 — 하나는 `Science 101`, 다른 하나는 `Math 201`. (이 부분은 PDF에서 figure로 제시되나 텍스트로 추출되지 않음 — PDF figure, 텍스트만.)
2. 추가 custom object 2개 `Student`, `Teacher`를 생성한다. 각 객체 생성 후:
   1. Click New under Custom Fields & Relationships.
   2. Select Master-Detail Relationship, then click Next.
   3. Select Classroom from the drop-down list, then click Next.
   4. Continue to click Next, leaving all the default values intact.
   - A new Student named Johnny Walker, and a new Teacher named Mister Pibb, both assigned to Science 101.
   - Another new Student named Boont Amber, and a new Teacher named Doctor Pepper, both assigned to Math 201.

Apex `DynamicClassroomList`(실제로는 controller 클래스):

```apex
public class DynamicClassroomList {
private ApexPages.StandardSetController controller;
private PageReference savePage;
private Set<String> unSelectedNames;
private Set<String> selectedNames;
public List<String> selected { get; set; }
public List<String> unselected { get; set; }
public String objId { get; set; }
public List<String> displayObjs {
get; private set;
}
boolean idIsSet = false;
public DynamicClassroomList() {
init();
}
public DynamicClassroomList(ApexPages.StandardSetController con) {
this.controller = con;
init();
}
private void init() {
savePage = null;
unSelectedNames = new Set<String>();
selectedNames = new Set<String>();
if (idIsSet) {
ApexPages.CurrentPage().getParameters().put('id', objId);
idIsSet = false;
}
}
public PageReference show() {
savePage = Page.dynVFClassroom;
savePage.getParameters().put('id', objId);
return savePage;
}
public List<SelectOption> displayObjsList {
get {
List<SelectOption> options = new List<SelectOption>();
List<Classroom__c> classrooms = [SELECT id, name FROM Classroom__c];
for (Classroom__c c: classrooms) {
options.add(new SelectOption(c.id, c.name));
}
return options;
}
}
public PageReference customize() {
savePage = ApexPages.CurrentPage();
savePage.getParameters().put('id', objId);
return Page.dynamicclassroomlist;
}
// The methods below are for constructing the select list
public List<SelectOption> selectedOptions {
get {
List<String> sorted = new List<String>(selectedNames);
sorted.sort();
List<SelectOption> options = new List<SelectOption>();
for (String s: sorted) {
options.add(new SelectOption(s, s));
}
return options;
}
}
public List<SelectOption> unSelectedOptions {
get {
Schema.DescribeSObjectResult R = Classroom__c.SObjectType.getDescribe();
List<Schema.ChildRelationship> C = R.getChildRelationships();
List<SelectOption> options = new List<SelectOption>();
for (Schema.ChildRelationship cr: C) {
String relName = cr.getRelationshipName();
// We're only interested in custom relationships
if (relName != null && relName.contains('__r')) {
options.add(new SelectOption(relName, relName));
}
}
return options;
}
}

public void doSelect() {
for (String s: selected) {
selectedNames.add(s);
unselectedNames.remove(s);
}
}
public void doUnSelect() {
for (String s: unselected) {
unSelectedNames.add(s);
selectedNames.remove(s);
}
}

public Component.Apex.OutputPanel getClassroomRelatedLists() {
Component.Apex.OutputPanel dynOutPanel= new Component.Apex.OutputPanel();
for(String id: selectedNames) {
Component.Apex.RelatedList dynRelList = new Component.Apex.RelatedList();
dynRelList.list = id;
dynOutPanel.childComponents.add(dynRelList);
}
return dynOutPanel;
}
}
```

> [!note] [sic] 코드 정합성
> `doSelect()` 본문은 `unselectedNames.remove(s)`로 표기됐으나, 클래스 필드는 `unSelectedNames`(대문자 S)로 선언됐다. PDF 원문 그대로이며 명백한 원문 오타로 보인다. 코드를 수정하지 않고 verbatim 유지한다.

> After trying to save, you may be prompted about a missing Visualforce page. Click the link to create the page: the next blocks of code will populate it.

VF page `dynVFClassroom`:

```html
<apex:page standardController="Classroom__c" recordSetVar="classlist"
extensions="DynamicClassroomList">
<apex:dynamicComponent componentValue="{!ClassroomRelatedLists}"/>
<apex:form>
<apex:pageBlock title="Classrooms Available" mode="edit">
<apex:pageMessages/>
<apex:selectRadio value="{!objId}">
<apex:selectOptions value="{!displayObjsList}"/>
</apex:selectRadio>
</apex:pageBlock>
<apex:commandButton value="Select Related Items" action="{!Customize}"/>
</apex:form>
</apex:page>
```

page `DynamicClassroomList`(controller extension 구성 시 이미 만들어졌을 수 있음):

```html
<apex:page standardController="Classroom__c" recordsetvar="listPageMarker"
extensions="DynamicClassroomList">
<apex:messages/><br/>
<apex:form>
<apex:pageBlock title="Select Relationships to Display" id="selectionBlock">
<apex:panelGrid columns="3">
<apex:selectList id="unselected_list" required="false"
value="{!selected}" multiselect="true" size="20"
style="width:250px">
<apex:selectOptions value="{!unSelectedOptions}"/>
</apex:selectList>
<apex:panelGroup>
<apex:commandButton value=">>" action="{!DoSelect}"
reRender="selectionBlock"/>
<br/>
<apex:commandButton value="<<" action="{!DoUnselect}"
reRender="selectionBlock"/>
</apex:panelGroup>
<apex:selectList id="selected_list" required="false"
value="{!unselected}" multiselect="true" size="20"
style="width:250px">
<apex:selectOptions value="{!selectedOptions}"/>
</apex:selectList>
</apex:panelGrid>
</apex:pageBlock>
<br/>
<apex:commandButton value="Show Related Lists" action="{!show}"/>
</apex:form>
</apex:page>
```

이 페이지는 표시할 객체 relationship 선택 옵션을 사용자에게 제공한다. "selected"/"unselected" list는 동적 수단으로 채워진다. controller extension + 페이지를 조립한 뒤 `/apex/dynVFClassroom`에 접근하면 일련의 화면 sequence가 표시된다.

> 위 결과 sequence는 PDF에서 스크린샷으로 제시되나(p.202), 텍스트로 추출되지 않음 (PDF 스크린샷 — 텍스트만).

---

## 관련 노트

- [[Dynamic SOQL]] — 동적 바인딩 컨트롤러가 런타임에 SELECT 문자열을 조립하는 기법(이 노트의 `DynamicCaseLoader`·`DynamicObjectHandler`·`MerchandiseDetails`가 사용)
- [[Schema Namespace 상세]] — `Schema.SobjectType`·`getMap()`·`DescribeSObjectResult`·`FieldSetMember` 등 동적 reference의 메타데이터 토대
- 동적 컴포넌트가 공통으로 갖는 메서드·프로퍼티(Component Class)는 Apex Developer's Guide 소관 — (위키 노트 미작성)
- [[Visualforce 개요 — 도구·퀵스타트]] — Visualforce 입문·도구·페이지 구조 개요
- [[표준 컨트롤러·표준 리스트 컨트롤러]] — 동적 바인딩이 함께 쓰는 표준 컨트롤러 메커니즘
- [[apex 컴포넌트 — 페이지·레이아웃 구조]] — `apex:dynamicComponent` 등 동적 생성 대상 마크업 컴포넌트 레퍼런스
- [[Global Variables·함수·표현식 연산자]] — 동적 바인딩 표현식이 쓰는 전역 변수·함수·연산자
