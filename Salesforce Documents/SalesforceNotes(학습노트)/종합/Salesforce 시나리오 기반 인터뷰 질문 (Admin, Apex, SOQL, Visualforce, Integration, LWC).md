---
tags: [general, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Admin-Apex-SOQL-LWC-VF-Integration]
---

# Salesforce 시나리오 기반 인터뷰 질문 (Admin, Apex, SOQL, Visualforce, Integration, LWC)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

> 각 항목은 "질문 / 답변 / 팁" 구조이며, 코드는 원문 그대로 보존했습니다.

## 1. Admin
**질문:**

Stage가 "Closed Lost"로 바뀔 때 Flow로 레코드를 잠그고 CEO만 편집하게 하려면?
**답변:**

Stage 필드의 이전 값을 확인하는 Record-Triggered Flow를 사용했다. "Closed Lost"로 바뀌면 커스텀 체크박스 Locked__c = TRUE로 갱신한다. 그다음 Validation Rule을 만들었다:
```
AND(
Locked__c = TRUE,
$User.Role.Name <> 'CEO'
)
```
이렇게 하면 CEO 역할 외 모두의 편집이 제한된다.
**팁:**

UI 수준 잠금엔 Flow + Validation Rule 조합 / 더 유연하게는 RecordType이나 Custom Permission.

## 2. Apex
**질문:**

확장·유지보수 가능하게 Opportunity 업데이트 로직을 Apex로 어떻게 처리하나?
**답변:**

Trigger Handler Framework를 구현했다. 트리거가 핸들러 클래스에 로직을 위임한다:
```apex
trigger OpportunityTrigger on Opportunity (before update) {
if(Trigger.isBefore && Trigger.isUpdate) {
OpportunityHandler.handleBeforeUpdate(Trigger.new, Trigger.oldMap);
}
}
```
```apex
public class OpportunityHandler {
public static void handleBeforeUpdate(List<Opportunity> newList,
Map<Id, Opportunity> oldMap) {
for(Opportunity opp : newList) {
if(oldMap.get(opp.Id).StageName != opp.StageName) {
opp.Description = 'Stage Changed';
}
}
}
}
```
**팁:**

항상 트리거 로직을 벌크화 / 재사용·테스트 용이성을 위해 핸들러 클래스.

## 3. SOQL
**질문:**

이메일 도메인이 'gmail.com'인 관련 Contact 수와 함께 Account Name을 가져오는 SOQL을 작성하라.
**답변:**

Aggregate SOQL을 사용했다:
```sql
SELECT Account.Name, COUNT(Id)
FROM Contact
WHERE Email LIKE '%@gmail.com'
GROUP BY Account.Name
```
**팁:**

이메일 도메인 필터엔 LIKE '%@gmail.com' / aggregate 쿼리는 항상 limit·필터로 테스트.

## 4. Visualforce
**질문:**

Account 목록을 표시하는 VF 페이지에서 페이지네이션을 어떻게 구현하나?
**답변:**

StandardSetController를 사용했다:
```apex
public class AccountPaginationController {
public ApexPages.StandardSetController setCon {
get {
if(setCon == null) {
setCon = new ApexPages.StandardSetController(
[SELECT Name FROM Account LIMIT 1000]
);
setCon.setPageSize(10);
}
return setCon;
}
set;
}
public List<Account> getAccounts() {
return (List<Account>)setCon.getRecords();
}
}
```
**팁:**

기본 페이지네이션엔 StandardSetController / 쿼리가 거버너 한도에 걸리지 않도록.

## 5. Integration
**질문:**

Apex에서 외부 시스템으로 REST 콜아웃을 어떻게 하나?
**답변:**

HttpRequest를 쓰고 JSON 응답을 처리했다:
```apex
HttpRequest req = new HttpRequest();
req.setEndpoint('https://api.external.com/data');
req.setMethod('GET');
req.setHeader('Authorization', 'Bearer token');
Http http = new Http();
HttpResponse res = http.send(req);
if(res.getStatusCode() == 200) {
Map<String, Object> result = (Map<String, Object>)
JSON.deserializeUntyped(res.getBody());
}
```
**팁:**

Remote Site Settings에 엔드포인트 추가 / 유연한 파싱엔 deserializeUntyped.

## 6. LWC
**질문:**

LWC에서 picklist 값을 로드하고 Platform Cache로 캐싱하려면?
**답변:**

Platform Cache가 있는 Apex를 사용했다:
```apex
public with sharing class PicklistController {
@AuraEnabled(cacheable=true)
public static List<String> getPicklistValues() {
String cachedData = (String) PlatformCache.get('PicklistCache', 'values');
if(String.isNotEmpty(cachedData)) {
return (List<String>) JSON.deserialize(cachedData, List<String>.class);
}
List<String> options = new List<String>{'Option A', 'Option B'};
PlatformCache.put('PicklistCache', 'values', JSON.serialize(options), 300);
return options;
}
}
```
**팁:**

UI 캐시엔 @AuraEnabled(cacheable=true) / 서버 측 성능엔 PlatformCache.put().

## 7. Admin
**질문:**

커스텀 오브젝트(Lead_Request__c) 레코드를 지역별로 다른 사용자에게 어떻게 할당하나?
**답변:**

Auto-Assignment Rule은 Lead·Case에만 있으므로, 생성 시 Record-Triggered Flow로 Region__c를 확인했다. 이를 기반으로 User 오브젝트에 Get Records를 사용하고 Assignment element로 OwnerId를 동적 할당했다.
**팁:**

커스텀 오브젝트 할당 로직엔 Flow / 유지보수성을 위해 사용자-지역 매핑을 Custom Metadata에 저장.

## 8. Apex
**질문:**

특정 오류 케이스 처리를 위해 Apex에서 custom exception을 어떻게 쓰나?
**답변:**

custom exception 클래스를 만들었다:
```apex
public class RecordLimitExceededException extends Exception {}
public void processRecords(List<Account> accList) {
if(accList.size() > 100) {
throw new RecordLimitExceededException('More than 100 records not allowed');
}
// proceed with logic
}
```
**팁:**

재사용·설명적 오류 처리에 custom exception / 호출부에서 try-catch로 감싸고 커스텀 로깅 프레임워크로 기록.

## 9. SOQL
**질문:**

각 Account에 대해 (CreatedDate 기준) 상위 2개 Contact만 조회하려면?
**답변:**

SOQL은 서브쿼리 내 LIMIT을 허용하지 않으므로 Apex로 처리했다:
```apex
List<Account> accList = [SELECT Id, Name, (SELECT Name, CreatedDate FROM
Contacts ORDER BY CreatedDate DESC) FROM Account];
for(Account acc : accList) {
List<Contact> topContacts = acc.Contacts.size() > 2 ?
acc.Contacts.subList(0, 2) : acc.Contacts;
}
```
**팁:**

Apex가 자식 레코드 한도 처리 / 성능 위해 메인 쿼리에 선택적 필터.

## 10. Visualforce
**질문:**

Account 데이터를 수집·저장하는 VF 페이지를 어떻게 만드나?
**답변:**

`<apex:form>`으로 폼을 만들고 save 메서드가 있는 컨트롤러를 썼다:
```apex
<apex:page controller="AccountFormController">
<apex:form >
<apex:inputField value="{!acc.Name}" />
<apex:commandButton value="Save" action="{!saveAccount}" />
</apex:form>
</apex:page>
```
```apex
public class AccountFormController {
public Account acc { get; set; }
public AccountFormController() {
acc = new Account();
}
public PageReference saveAccount() {
insert acc;
return null;
}
}
```
**팁:**

자동 생성 필드엔 `<apex:inputField>` / 컨트롤러에서 항상 예외 처리.

## 11. Integration
**질문:**

OAuth 2.0 인증으로 외부 API와 어떻게 통합하나?
**답변:**

OAuth 2.0이 있는 Named Credentials를 사용했다. Auth Provider 설정 후 Named Credential을 만들고 API를 호출했다:
```apex
HttpRequest req = new HttpRequest();
req.setEndpoint('callout:MyAPI/some-endpoint');
req.setMethod('GET');
Http http = new Http();
HttpResponse res = http.send(req);
```
**팁:**

안전·확장 가능한 통합엔 Named Credential / 동적 토큰·위임 인증엔 OAuth 2.0이 최선.

## 12. LWC
**질문:**

자식 LWC에서 부모로 값을 어떻게 전달하나?
**답변:**

Custom Event를 사용했다:
```js
// childComponent.js
this.dispatchEvent(new CustomEvent('submitdata', {
detail: { value: this.inputValue }
}));
```
```html
<!-- parentComponent.html -->
<c-child-component onsubmitdata={handleSubmit}></c-child-component>
```
```js
// parentComponent.js
handleSubmit(event) {
this.receivedData = event.detail.value;
}
```
**팁:**

자식→부모 통신엔 custom event / 이벤트 이름을 의미 있게, 데이터는 항상 detail로.

## 13. Admin
**질문:**

어떤 필드가 Permission Set 없이 한 Profile에만 보이게 하려면?
**답변:**

Field-Level Security를 사용했다. Object Manager의 필드 설정에서 Set Field-Level Security를 클릭해 필요한 Profile(예: Sales Manager)에만 보이게 하고 나머지는 체크 해제했다.
**팁:**

FLS가 가시성 제어의 가장 안전한 방법 / 페이지 레이아웃만 의존 말 것(UI만 제어, 접근은 아님).

## 14. Apex
**질문:**

Batch Apex 클래스를 매주 월요일 오전 8시에 실행하도록 스케줄하려면?
**답변:**

Batch Apex 클래스를 만든 뒤 Schedulable 클래스로 스케줄했다:
```apex
public class WeeklyBatchScheduler implements Schedulable {
public void execute(SchedulableContext sc) {
MyBatchClass batch = new MyBatchClass();
Database.executeBatch(batch, 200);
}
}
```
그다음 CRON 표현식으로 스케줄:
```apex
String cronExp = '0 0 8 ? * MON';
System.schedule('Weekly Batch', cronExp, new WeeklyBatchScheduler());
```
**팁:**

스케줄 전 배치 로직을 따로 테스트 / Workbench > Utilities > Cron Expression Generator 활용.

## 15. SOQL
**질문:**

각 Lead에 대해 가장 최근 생성된 Task를 어떻게 가져오나?
**답변:**

SOQL이 서브쿼리 내 LIMIT을 지원하지 않으므로 모든 task를 쿼리해 정렬했다:
```apex
Map<Id, Task> latestTaskMap = new Map<Id, Task>();
List<Task> tasks = [SELECT Id, Subject, CreatedDate, WhatId
FROM Task
WHERE What.Type = 'Lead'
ORDER BY CreatedDate DESC];
for(Task t : tasks) {
if(!latestTaskMap.containsKey(t.WhatId)) {
latestTaskMap.put(t.WhatId, t);
}
}
```
**팁:**

"레코드당 최신"엔 Apex에서 map 사용 / 불필요한 조인을 피하려 What.Type = 'Lead'.

## 16. Visualforce
**질문:**

StandardSetController 없이 커스텀 페이지네이션을 어떻게 구현하나?
**답변:**

offset 로직으로 수동 처리했다:
```apex
public class CustomPaginationController {
public Integer pageSize = 10;
public Integer pageNumber = 0;
public List<Account> accounts { get; set; }
public void next() { pageNumber++; loadData(); }
public void previous() { if(pageNumber > 0) pageNumber--; loadData(); }
public void loadData() {
accounts = [SELECT Name FROM Account LIMIT :pageSize OFFSET :pageNumber * pageSize];
}
public CustomPaginationController() {
loadData();
}
}
```
**팁:**

정밀 페이지네이션엔 OFFSET / LIMIT/OFFSET 조합은 거버너 한도가 있으니 대용량엔 주의.

## 17. Integration
**질문:**

레코드가 삽입될 때 실시간으로 외부 시스템에 콜아웃하려면?
**답변:**

같은 컨텍스트에서 DML과 콜아웃이 함께 불가하므로 @future(callout=true)를 썼다:
```apex
trigger ContactTrigger on Contact (after insert) {
for(Contact c : Trigger.new) {
CalloutService.sendToExternal(c.Id);
}
}
```
```apex
public class CalloutService {
@future(callout=true)
public static void sendToExternal(Id contactId) {
Contact c = [SELECT Name, Email FROM Contact WHERE Id = :contactId LIMIT 1];
HttpRequest req = new HttpRequest();
req.setEndpoint('callout:ExternalSystemAPI');
req.setMethod('POST');
req.setBody(JSON.serialize(c));
Http http = new Http();
http.send(req);
}
}
```
**팁:**

DML 후 콜아웃엔 @future(callout=true) / 더 많은 제어엔 Queueable Apex나 Platform Events.

## 18. LWC
**질문:**

레코드의 Record Type에 따라 LWC에서 다른 UI 섹션을 표시하려면?
**답변:**

Apex에서 RecordTypeId를 쿼리해 RecordType.Name을 LWC에 전달하고 template if:true를 썼다:
```html
<template if:true={isRetail}>
<!-- Retail layout -->
</template>
<template if:true={isCommercial}>
<!-- Commercial layout -->
</template>
```
```js
@api recordTypeName;
get isRetail() {
return this.recordTypeName === 'Retail';
}
get isCommercial() {
return this.recordTypeName === 'Commercial';
}
```
**팁:**

record type 정보는 @api나 Apex wire로 / Id 하드코딩 회피, Name·DeveloperName 사용.

## 19. Admin
**질문:**

Opportunity Amount에 따라 다른 승인자로 라우팅되는 승인 프로세스를 어떻게 만드나?
**답변:**

Opportunity에 Entry Criteria가 있는 여러 승인 프로세스를 만들었다: Amount < 50,000 → 자동 승인 또는 Manager 1, Amount ≥ 50,000 → Senior Manager로 라우팅. 또는 Process Builder/Flow + Apex Invocable 메서드로 NextApproverIds를 설정하는 동적 승인 라우팅을 썼다.
**팁:**

복잡한 로직엔 동적 라우팅 고려 / 임계값·승인자 매핑은 Custom Metadata에 저장.

## 20. Apex
**질문:**

DML 예외를 처리하고 전체 트랜잭션을 롤백하려면?
**답변:**

Database.setSavepoint()와 rollback()을 썼다:
```apex
Savepoint sp = Database.setSavepoint();
try {
insert new Account(Name='Test');
insert new Contact(LastName=null); // will fail
} catch(Exception e) {
Database.rollback(sp);
System.debug('Rollback done due to: ' + e.getMessage());
}
```
**팁:**

부분 롤백 제어엔 savepoint/rollback / 더 나은 오류 처리엔 Database.insert(list, allOrNone=false).

## 21. SOQL
**질문:**

최근 90일간 로그인하지 않은 활성 사용자 목록을 어떻게 가져오나?
**답변:**
```sql
SELECT Id, Name, LastLoginDate
FROM User
WHERE IsActive = TRUE AND (LastLoginDate = NULL OR LastLoginDate < LAST_N_DAYS:90)
```
**팁:**

동적 날짜 필터엔 LAST_N_DAYS / 한 번도 로그인 안 한 사용자는 LastLoginDate가 null.

## 22. Visualforce
**질문:**

체크박스 선택 시 VF 페이지 섹션을 보이고 숨기려면?
**답변:**

actionSupport로 rerender를 사용했다:
```html
<apex:inputCheckbox value="{!showDetails}">
<apex:actionSupport event="onclick" reRender="detailsSection"/>
</apex:inputCheckbox>
<apex:outputPanel id="detailsSection">
<apex:outputPanel rendered="{!showDetails}">
<apex:inputField value="{!acc.Phone}" />
</apex:outputPanel>
</apex:outputPanel>
```
**팁:**

동적 갱신엔 rerender + rendered 조합 / 조건부 콘텐츠는 outputPanel로 감싸기.

## 23. Integration
**질문:**

외부 시스템의 콜백(webhook)을 Salesforce에서 어떻게 처리하나?
**답변:**

공개 REST Resource 클래스를 만들었다:
```apex
@RestResource(urlMapping='/callback-handler')
global with sharing class CallbackHandler {
@HttpPost
global static void doPost() {
RestRequest req = RestContext.request;
String body = req.requestBody.toString();
// parse JSON and take action
Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(body);
// Save or process data
}
}
```
**팁:**

Site + Guest User Access로 사이트 노출 / API key나 서명 페이로드로 webhook 보호.

## 24. LWC
**질문:**

주어진 오브젝트·필드의 동적 picklist 값을 LWC에 표시하려면?
**답변:**

lightning/uiObjectInfoApi의 @wire(getPicklistValues, …)를 썼다:
```js
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import INDUSTRY_FIELD from '@salesforce/schema/Account.Industry';
@wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
objectInfo;
@wire(getPicklistValues, {
recordTypeId: '$objectInfo.data.defaultRecordTypeId',
fieldApiName: INDUSTRY_FIELD
})
industryOptions;
```
**팁:**

반응형·선언적 picklist엔 UI API / RecordTypeId 하드코딩 회피, 항상 동적 조회.

## 25. Admin
**질문:**

승인된 레코드를 사용자가 편집하지 못하게 하려면?
**답변:**

오브젝트에 Validation Rule을 만들었다:
```
AND(
ISPICKVAL(Status__c, "Approved"),
NOT($Profile.Name = "System Administrator")
)
```
"Approved" 상태가 되면 System Admin 외 편집을 막는다.
**팁:**

편집 접근이 달라야 하면 Record Type과 결합 / UI 메시지엔 Flow, 백엔드 제어엔 Validation Rule.

## 26. Apex
**질문:**

트리거에서 future 메서드를 호출하고 오류를 우아하게 처리하려면?
**답변:**

DML 후 @future 메서드를 호출하고 try-catch로 처리했다:
```apex
@future
public static void notifyUser(String email) {
try {
// logic to send email
} catch(Exception e) {
System.debug('Error in future method: ' + e.getMessage());
}
}
```
**팁:**

future 메서드 안에서 DML 금지 / future 로직을 항상 try-catch로 감싸기.

## 27. SOQL
**질문:**

관련 Task가 없는 Opportunity를 가져오는 SOQL을 작성하라.
**답변:**

semi-join 쿼리를 썼다:
```sql
SELECT Id, Name FROM Opportunity
WHERE Id NOT IN (SELECT WhatId FROM Task WHERE What.Type = 'Opportunity')
```
**팁:**

"존재하지 않음" 로직엔 semi-join / WhatId가 올바른 오브젝트를 가리키는지 확인.

## 28. Visualforce
**질문:**

VF 페이지 테이블을 Excel 파일로 어떻게 익스포트하나?
**답변:**

다음 페이지 설정을 썼다:
```html
<apex:page controller="AccountExportController"
contentType="application/vnd.ms-excel#Accounts.xls" cache="true">
<apex:pageBlock title="Accounts">
<apex:pageBlockTable value="{!accList}" var="acc">
<apex:column value="{!acc.Name}" />
</apex:pageBlockTable>
</apex:pageBlock>
</apex:page>
```
**팁:**

Excel용 MIME 타입 정확히 설정 / 단순하게, Excel 익스포트는 스타일링이 제한적.

## 29. Integration
**질문:**

LWC에서 Apex로, 그다음 외부 시스템으로 데이터를 어떻게 보내나?
**답변:**

LWC 폼에서 데이터 수집 → @AuraEnabled Apex 메서드 호출 → Apex에서 HTTP 콜아웃:
```apex
@AuraEnabled
public static void sendToAPI(String name, String email) {
HttpRequest req = new HttpRequest();
req.setEndpoint('callout:ExternalSystem');
req.setMethod('POST');
req.setHeader('Content-Type', 'application/json');
req.setBody(JSON.serialize(new Map<String, String>{ 'name' => name, 'email' => email }));
new Http().send(req);
}
```
**팁:**

LWC·Apex 양쪽에서 입력 검증 / 안전한 콜아웃엔 Named Credentials.

## 30. LWC
**질문:**

Account 레코드 목록의 datatable에서 인라인 편집을 어떻게 구현하나?
**답변:**

editable=true인 `<lightning-datatable>`을 썼다:
```html
<lightning-datatable
key-field="Id"
data={accounts}
columns={columns}
draft-values={draftValues}
onsave={handleSave}
hide-checkbox-column>
</lightning-datatable>
```
```js
handleSave(event) {
const updatedFields = event.detail.draftValues;
updateAccount({ data: updatedFields }) // Apex method
.then(() => {
this.dispatchEvent(new ShowToastEvent({ title: 'Success', message: 'Updated' }));
return refreshApex(this.accounts);
});
}
```
**팁:**

임시 편집엔 draftValues / 갱신 후 변경 반영을 위해 refreshApex() 잊지 말 것.

## 31. Admin
**질문:**

관련 Contact가 갱신될 때 Account의 필드를 자동 갱신하려면?
**답변:**

Contact(After Update)에 Record-Triggered Flow를 만들었다. Get Records로 관련 Account를 가져오고 Update Records로 필드(예: Last_Updated_Contact__c)를 변경했다.
**팁:**

크로스 오브젝트 갱신엔 After Update flow / 무한 루프 방지로 Decision element에 IsChanged 사용.

## 32. Apex
**질문:**

트리거가 재귀적으로 실행되는 것을 어떻게 방지하나?
**답변:**

헬퍼 클래스 안에 static Boolean 플래그를 썼다:
```apex
public class TriggerControl {
public static Boolean isFirstRun = true;
}
```
트리거에서:
```apex
if(TriggerControl.isFirstRun) {
TriggerControl.isFirstRun = false;
// trigger logic
}
```
**팁:**

static 변수는 단일 트랜잭션의 트리거 컨텍스트에 걸쳐 유지 / 재귀 제어에 Limits.getDMLStatements() 사용 금지(신뢰 불가).

## 33. SOQL
**질문:**

Title = 'Manager'인 Contact가 있는 모든 Account를 가져오는 SOQL을 작성하라.
**답변:**
```sql
SELECT Name, (SELECT FirstName, LastName FROM Contacts WHERE Title = 'Manager')
FROM Account
WHERE Id IN (SELECT AccountId FROM Contact WHERE Title = 'Manager')
```
**팁:**

관련 데이터엔 내부 쿼리 / 관련 부모만 반환하려면 외부 WHERE 절.

## 34. Visualforce
**질문:**

선택된 picklist 값에 따라 VF 페이지에서 다른 섹션을 표시하려면?
**답변:**

rerender가 있는 apex:selectList와 조건부 apex:outputPanel을 썼다:
```html
<apex:selectList value="{!selectedType}" size="1">
<apex:selectOptions value="{!typeOptions}"/>
<apex:actionSupport event="onchange" reRender="formSection"/>
</apex:selectList>
<apex:outputPanel id="formSection">
<apex:outputPanel rendered="{!selectedType = 'Retail'}">
<!-- Retail fields -->
</apex:outputPanel>
<apex:outputPanel rendered="{!selectedType = 'Enterprise'}">
<!-- Enterprise fields -->
</apex:outputPanel>
</apex:outputPanel>
```
**팁:**

값 하드코딩 회피, 동적 picklist 사용 / rerender·rendered를 효과적으로.

## 35. Integration
**질문:**

실패한 콜아웃을 자동 재시도하려면?
**답변:**

Queueable Apex로 재귀 재시도 로직을 구현했다:
```apex
public class RetryableCallout implements Queueable {
Integer retryCount;
public RetryableCallout(Integer retryCount) {
this.retryCount = retryCount;
}
public void execute(QueueableContext context) {
try {
// make HTTP callout
} catch(Exception e) {
if(retryCount < 3) {
System.enqueueJob(new RetryableCallout(retryCount + 1));
}
}
}
}
```
**팁:**

재시도 패턴엔 Queueable / 감사를 위해 커스텀 오브젝트에 오류 로깅.

## 36. LWC
**질문:**

액션 후 사용자에게 성공/오류 메시지를 표시하려면?
**답변:**

lightning/platformShowToastEvent의 ShowToastEvent를 썼다:
```js
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
this.dispatchEvent(
new ShowToastEvent({
title: 'Success',
message: 'Record saved successfully',
variant: 'success'
})
);
```
오류는:
```js
this.dispatchEvent(
new ShowToastEvent({
title: 'Error',
message: 'Something went wrong!',
variant: 'error'
})
);
```
**팁:**

더 나은 UX를 위해 항상 피드백 표시 / variant: success, error, info, warning.

## 37. Admin – 7일간 갱신 없으면 Case 자동 종료
**질문:**

7일간 갱신되지 않은 Case를 자동으로 종료하려면?
**답변:**

필터가 있는 Scheduled Flow(매일 실행)를 썼다: Case Status ≠ Closed, LastModifiedDate ≤ TODAY() - 7. 그다음 Update Records로 상태를 "Closed"로 변경.
**팁:**

시간 기반 자동화엔 Apex 없이 Scheduled Flow가 최선 / 이미 종료된 Case 갱신을 피하도록 기준 설정.

## 38. Apex
**질문:**

Opportunity Stage를 갱신하는 Apex 메서드를 어떻게 벌크화하나?
**답변:**

Opportunity Id 목록을 받아 Database.update()로 벌크 갱신했다:
```apex
public static void bulkUpdateStage(List<Id> oppIds, String newStage) {
List<Opportunity> oppsToUpdate = [SELECT Id, StageName FROM Opportunity WHERE Id IN :oppIds];
for(Opportunity opp : oppsToUpdate) {
opp.StageName = newStage;
}
update oppsToUpdate;
}
```
**팁:**

루프 안 DML 회피 / 쿼리 전 null/empty 체크.

## 39. SOQL
**질문:**

Stage별로 그룹화된 Opportunity 수를 어떻게 가져오나?
**답변:**

aggregate SOQL을 썼다:
```sql
SELECT StageName, COUNT(Id) total
FROM Opportunity
GROUP BY StageName
```
**팁:**

가독성을 위해 항상 COUNT에 별칭 / 대시보드·차트에 aggregate 함수.

## 40. Visualforce
**질문:**

VF 페이지에서 레코드의 PDF를 어떻게 생성하나?
**답변:**

`<apex:page>` 태그에 renderAs="pdf"를 추가했다:
```html
<apex:page renderAs="pdf" controller="InvoiceController">
<h1>Invoice</h1>
<p>Amount: {!invoice.Amount__c}</p>
</apex:page>
```
**팁:**

PDF 페이지에 `<apex:form>` 사용 금지 / 브랜딩엔 외부 파일 대신 인라인 CSS.

## 41. Integration
**질문:**

외부 데이터를 Salesforce에 저장하지 않고 UI에 표시하려면?
**답변:**

LWC + Apex Callout으로 외부 데이터를 가져와 커스텀 페이지에 표시했다(DML 없음). 또는 대용량엔 External Object를 쓰는 Salesforce Connect를 권했다.
**팁:**

저장이 불필요하면 Salesforce Connect / 실시간 뷰엔 필요시 캐싱이 있는 LWC + Apex.

## 42. LWC
**질문:**

부모 LWC에서 여러 자식 컴포넌트로 통신하려면?
**답변:**

template query selector로 각 자식의 공개 메서드를 호출했다:
```html
<c-child-component lwc:ref="child1"></c-child-component>
<c-child-component lwc:ref="child2"></c-child-component>
<lightning-button label="Notify" onclick={notifyAllChildren}></lightning-button>
```
```js
notifyAllChildren() {
this.template.querySelectorAll('c-child-component').forEach(child => {
child.refreshData();
});
}
```
**팁:**

다중 자식 상호작용엔 lwc:ref나 querySelectorAll() / 자식 컴포넌트에 @api로 공개 메서드 정의.

## 43. Admin
**질문:**

사용자 부서에 따라 Case를 다른 큐에 자동 할당하려면?
**답변:**

Case(Before Insert)에 Record-Triggered Flow를 만들었다. Get Records로 User.Department를 가져오고, Decision 로직으로 부서별로 Case.OwnerId를 해당 Queue Id로 할당했다.
**팁:**

부서별 큐 매핑은 Custom Metadata로 관리 / flow에 Queue Id 하드코딩 회피.

## 44. Apex
**질문:**

Account 삭제 시 관련 Contact를 모두 삭제하려면?
**답변:**

Account에 Before Delete 트리거를 작성했다:
```apex
trigger AccountTrigger on Account (before delete) {
List<Contact> contactsToDelete = [SELECT Id FROM Contact WHERE AccountId IN :Trigger.oldMap.keySet()];
delete contactsToDelete;
}
```
**팁:**

레코드 잠금 이슈를 피하려 after 대신 before delete / 항상 벌크화하고 IN :Trigger.oldMap.keySet()로 쿼리.

## 45. SOQL
**질문:**

현재 회계 분기에 마감된 Opportunity를 어떻게 가져오나?
**답변:**
```sql
SELECT Name, CloseDate
FROM Opportunity
WHERE IsClosed = TRUE AND CloseDate = THIS_FISCAL_QUARTER
```
**팁:**

THIS_FISCAL_QUARTER, LAST_N_DAYS 같은 날짜 리터럴 / 정확성을 위해 Company Information에서 회계연도 설정 조정.

## 46. Visualforce
**질문:**

VF 페이지 안에 Lightning 컴포넌트를 표시하려면?
**답변:**

lightning:out으로 컴포넌트를 노출하고 `<apex:includeLightning>`으로 임베드했다:
```html
<apex:page>
<apex:includeLightning />
<div id="lightningContainer"/>
<script>
$Lightning.use("c:myApp", function() {
$Lightning.createComponent("c:myLWC", {}, "lightningContainer");
});
</script>
</apex:page>
```
**팁:**

VF가 LWC와 상호작용해야 하면 Lightning Out / use() 메서드에 네임스페이스(myApp) 추가.

## 47. Integration
**질문:**

외부 시스템의 큰 JSON 응답(1만+ 레코드)을 Apex에서 어떻게 처리하나?
**답변:**

JSONStreamReader 패턴을 쓰거나 외부 시스템에서 응답을 청크로 분할했다. 내부적으로 유연성을 위해 JSON.deserializeUntyped()로 필요한 필드만 파싱했다:
```apex
Map<String, Object> response = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
List<Object> records = (List<Object>) response.get('records');
```
**팁:**

부분 역직렬화엔 deserializeUntyped() / 극단적인 경우 Heroku/AWS Lambda로 처리 오프로드.

## 48. LWC
**질문:**

특정 Permission Set이 있는 사용자에게만 LWC를 조건부로 표시하려면?
**답변:**

Apex로 Custom Permission을 쿼리해 boolean을 컴포넌트에 노출했다:
```apex
@AuraEnabled(cacheable=true)
public static Boolean hasAccess() {
return FeatureManagement.checkPermission('Can_See_LWC');
}
```
```js
@wire(hasAccess) access;
get showComponent() {
return this.access.data === true;
}
```
**팁:**

안전·선언적 제어엔 Custom Permission + FeatureManagement / LWC에 프로필·역할 로직 하드코딩 회피.

## 49. Admin
**질문:**

Case의 Record Type에 따라 다른 이메일 템플릿을 보내려면?
**답변:**

Case에 Record-Triggered Flow를 만들었다. Decision element로 RecordType.DeveloperName을 확인하고, 결과에 따라 각 템플릿에 연결된 다른 Email Alert로 Send Email 액션을 사용했다.
**팁:**

하드코딩 Id 대신 RecordType.DeveloperName / 오류를 피하려 일관된 merge field로 템플릿 유지.

## 50. Apex
**질문:**

각 Account에 여러 관련 Contact를 벌크 Apex로 어떻게 삽입하나?
**답변:**
```apex
List<Contact> contactsToInsert = new List<Contact>();
for(Account acc : [SELECT Id, Name FROM Account WHERE Name LIKE 'Test%']) {
for(Integer i = 0; i < 3; i++) {
contactsToInsert.add(new Contact(
FirstName = 'Test' + i,
LastName = acc.Name + 'Contact',
AccountId = acc.Id
));
}
}
insert contactsToInsert;
```
**팁:**

한도를 피하려 중첩 루프 신중히 / 삽입을 단일 DML로 벌크화.

## 51. SOQL
**질문:**

Contact나 Opportunity가 없는 Account를 어떻게 찾나?
**답변:**

두 개의 semi-join을 썼다:
```sql
SELECT Id, Name FROM Account
WHERE Id NOT IN (SELECT AccountId FROM Contact)
AND Id NOT IN (SELECT AccountId FROM Opportunity)
```
**팁:**

복합 관계엔 여러 NOT IN 서브쿼리 / 관련 레코드에 AccountId가 채워져 있는지 확인.

## 52. Visualforce
**질문:**

VF 페이지에서 특정 프로필에게만 버튼을 표시하려면?
**답변:**

컨트롤러에서 사용자 프로필을 확인했다:
```apex
public Boolean isAdmin { get; set; }
public MyVFController() {
isAdmin = [SELECT Name FROM Profile WHERE Id = :UserInfo.getProfileId()].Name == 'System Administrator';
}
```
그다음:
```html
<apex:commandButton value="Admin Action" rendered="{!isAdmin}" action="{!someAction}" />
```
**팁:**

현재 사용자 프로필엔 UserInfo.getProfileId() / 운영에선 프로필 이름 하드코딩 회피, Custom Permission 선호.

## 53. Integration
**질문:**

외부 시스템이 REST API로 Contact를 Salesforce에 삽입하려면?
**답변:**

Salesforce 표준 REST API를 노출했다. 외부 시스템은 OAuth 2.0으로 인증하고 `/services/data/vXX.0/sobjects/Contact/`에 POST한다. 예제 JSON:
```json
{
"FirstName": "John",
"LastName": "Doe",
"Email": "john@example.com"
}
```
**팁:**

Salesforce로 호출 시 Named Credentials + Auth Provider / 페이로드에 필수 필드 포함 확인.

## 54. LWC
**질문:**

Apex로 레코드 갱신 후 LWC 데이터를 어떻게 새로고침하나?
**답변:**

Apex wire를 쓰는 경우:
```js
@wire(getAccounts) accountData;
handleUpdate() {
updateRecord({ recordId: this.recordId }).then(() => {
return refreshApex(this.accountData);
});
}
```
**팁:**

wired 속성엔 refreshApex()로 데이터 재로드 / 명령형 호출은 then()에서 수동 재로드.

## 55. Admin
**질문:**

Permission Set 없이 특정 프로필의 레코드 삭제를 제한하려면?
**답변:**

Validation Rule로 프로필 기반 삭제를 막으려 했으나(`ISCHANGED(IsDeleted) && $Profile.Name = "Sales User"`), IsDeleted는 validation rule에서 직접 쓸 수 없으므로 대신 Before Delete Flow를 만들어 Decision element로 사용자 프로필 기반 flow 실행을 중단하고 메시지를 표시했다.
**팁:**

삭제 방지엔 Before Delete Flow / 더 복잡한 역할 기반 삭제엔 Apex Trigger.

## 56. Apex
**질문:**

Apex에서 external ID로 upsert를 어떻게 하나?
**답변:**

External_Id__c가 Contact의 External ID라고 가정:
```apex
List<Contact> contacts = new List<Contact>{
new Contact(External_Id__c = '123', FirstName = 'Test', LastName = 'User')
};
upsert contacts External_Id__c;
```
**팁:**

필드를 External ID와 Unique로 표시 / 중복 삽입·수동 조회를 피하려 upsert.

## 57. SOQL
**질문:**

Contact가 5개 초과인 Account를 어떻게 찾나?
**답변:**

HAVING 절을 썼다:
```sql
SELECT AccountId, COUNT(Id)
FROM Contact
GROUP BY AccountId
HAVING COUNT(Id) > 5
```
**팁:**

HAVING에서 부모 필드 필터 불가, 집계된 자식 데이터로 필터 / 필요시 Apex map으로 Account와 조인.

## 58. Visualforce
**질문:**

필수 필드가 누락되면 VF 폼 제출을 막으려면?
**답변:**

`<apex:inputField required="true" />`로 UI 검증을 강제하고, 실시간 피드백용 클라이언트 JS와 DML 전 서버 측 Apex 검증을 추가했다:
```apex
if(String.isBlank(contact.FirstName)) {
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'First Name is required'));
return null;
}
```
**팁:**

프런트엔드 required + 백엔드 Apex 검증 결합 / 더 나은 피드백엔 ApexPages.addMessage().

## 59. Integration
**질문:**

API key나 토큰 같은 커스텀 헤더로 Apex 콜아웃을 하려면?
**답변:**

Remote Site Settings를 구성하고 헤더를 추가했다:
```apex
HttpRequest req = new HttpRequest();
req.setEndpoint('https://api.example.com/data');
req.setMethod('GET');
req.setHeader('Authorization', 'Bearer abc123');
req.setHeader('x-api-key', 'myapikey');
Http http = new Http();
HttpResponse res = http.send(req);
```
**팁:**

인증엔 항상 setHeader() / 토큰은 Custom Metadata나 Named Credentials에 보관.

## 60. LWC
**질문:**

요청 처리 중 LWC에서 다중 제출을 방지하려면?
**답변:**

boolean isProcessing 플래그로 버튼을 비활성화했다:
```html
<lightning-button label="Submit" onclick={handleSubmit} disabled={isProcessing}></lightning-button>
```
```js
isProcessing = false;
handleSubmit() {
this.isProcessing = true;
submitData({ data: this.formData })
.then(() => {
// success
})
.catch(error => {
// error
})
.finally(() => {
this.isProcessing = false;
});
}
```
**팁:**

비동기 작업 중 항상 UI 요소 비활성화 / 오류 시에도 플래그 리셋을 위해 finally().

## 61. Admin
**질문:**

레코드 생성 시 사용자 프로필에 따라 필드(Priority)의 동적 기본값을 설정하려면?
**답변:**

Record Page에 임베드된 Screen Flow(Quick Action)를 썼다. Get Records로 현재 사용자 프로필을 가져오고, Decision element로 "Support User"엔 Priority = High, 나머지엔 Low를 설정해 기본값으로 폼을 사전 채움했다.
**팁:**

UI 동적 기본값엔 flow / Flow Variable + Input Component로 효율적 처리.

## 62. Apex
**질문:**

트리거 로직을 특정 record type에만 실행하도록 제한하려면?
**답변:**

루프 밖에서 RecordType을 한 번 쿼리하고 DeveloperName으로 비교했다:
```apex
Set<Id> recordTypeIds = new Set<Id>();
for(RecordType rt : [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType = 'Opportunity']) {
if(rt.DeveloperName == 'Corporate') recordTypeIds.add(rt.Id);
}
for(Opportunity opp : Trigger.new) {
if(recordTypeIds.contains(opp.RecordTypeId)) {
// Your logic
}
}
```
**팁:**

RecordTypeId 하드코딩 회피, DeveloperName 사용 / 재사용 시 static 변수에 record type 캐싱.

## 63. SOQL
**질문:**

WhoId 필드로 Lead에만 관련된 Task를 어떻게 쿼리하나?
**답변:**
```sql
SELECT Id, Subject, WhoId
FROM Task
WHERE Who.Type = 'Lead'
```
**팁:**

WhoId는 Lead/Contact, WhatId는 Account·Opportunity 등 / 다형 필드엔 WHERE에 .Type 사용.

## 64. Visualforce
**질문:**

Account, Contact, Opportunity 섹션을 탭 형식으로 VF에 표시하려면?
**답변:**

jQuery나 Bootstrap 탭 UI 구조와 각 탭 안 apex:outputPanel을 썼다:
```html
<ul class="tabs">
<li onclick="showTab('acc')">Account</li>
<li onclick="showTab('cont')">Contact</li>
</ul>
<div id="acc" class="tab-content">
<apex:pageBlockTable value="{!accounts}" var="a">...</apex:pageBlockTable>
</div>
<div id="cont" class="tab-content" style="display:none">
<apex:pageBlockTable value="{!contacts}" var="c">...</apex:pageBlockTable>
</div>
```
**팁:**

탭 전환엔 최소한의 JavaScript / Lightning이면 classic VF 대신 Lightning Tabs 선호.

## 65. Integration
**질문:**

페이지네이션된 REST API 응답을 Apex에서 어떻게 처리하나?
**답변:**

응답의 nextPageToken으로 다음 페이지를 가져오는 루프를 만들었다:
```apex
String nextUrl = 'https://api.example.com/page1';
do {
HttpRequest req = new HttpRequest();
req.setEndpoint(nextUrl);
req.setMethod('GET');
Http http = new Http();
HttpResponse res = http.send(req);
Map<String, Object> response = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
nextUrl = (String) response.get('nextPageUrl');
} while (nextUrl != null);
```
**팁:**

요청 간 API rate limit 존중 / 페이지 끝에 항상 오류 처리·폴백.

## 66. LWC
**질문:**

record type에 따라 LWC에서 다른 레이아웃을 렌더링하려면?
**답변:**

Apex로 레코드의 RecordType.DeveloperName을 쿼리해 LWC에 반환했다:
```apex
@AuraEnabled(cacheable=true)
public static String getRecordTypeName(Id recordId) {
return [SELECT RecordType.DeveloperName FROM Account WHERE Id = :recordId].RecordType.DeveloperName;
}
```
```js
@wire(getRecordTypeName, { recordId: '$recordId' }) recordType;
get isRetail() {
return this.recordType.data === 'Retail';
}
```
```html
<template if:true={isRetail}>
<!-- Retail layout -->
</template>
```
**팁:**

가독성·마이그레이션 안전성을 위해 Id 대신 DeveloperName / 성능을 위해 @wire에 cacheable=true.

## 67. Admin
**질문:**

Flow에서 필수 필드가 비었을 때 커스텀 오류를 표시하려면?
**답변:**

Screen Flow에서 화면 후 Decision element를 추가했다. 필드가 비면 화면 컴포넌트에 커스텀 검증 메시지를 썼다(`{!Your_Field} Is Null → "This field is required."`). 또는 복잡한 검증엔 커스텀 Lightning 컴포넌트를 썼다.
**팁:**

깔끔한 UX엔 Screen Component → Configure Validation / 신뢰성 있는 검증엔 Is Null과 TRIM().

## 68. Apex
**질문:**

관련 데이터 삽입 시 루프 안 SOQL/DML을 어떻게 피하나?
**답변:**

먼저 모든 관련 레코드를 벌크 조회하고 map으로 빠르게 조회했다:
```apex
Map<Id, Account> accMap = new Map<Id, Account>([SELECT Id, Name FROM Account]);
List<Contact> conList = new List<Contact>();
for(Opportunity opp : oppList) {
if(accMap.containsKey(opp.AccountId)) {
conList.add(new Contact(LastName='Auto', AccountId=opp.AccountId));
}
}
insert conList;
```
**팁:**

항상 쿼리를 루프 밖으로 / 효율적 조회엔 Map<Id, sObject>.

## 69. SOQL
**질문:**

관련 Account Industry가 'Banking'인 모든 Contact를 어떻게 가져오나?
**답변:**
```sql
SELECT Id, FirstName, LastName, Account.Industry
FROM Contact
WHERE Account.Industry = 'Banking'
```
**팁:**

필요에 따라 부모-자식·자식-부모 순회 / WHERE 절에선 한 단계 관계 순회만 허용.

## 70. Visualforce
**질문:**

버튼 클릭 시 VF에 팝업/모달 창을 표시하려면?
**답변:**

모달엔 `<apex:outputPanel>`을, 표시/숨김엔 JavaScript를 썼다:
```html
<apex:commandButton value="Open Popup" onclick="showPopup();" rerender="popupPanel"/>
<apex:outputPanel id="popupPanel" styleClass="modal" style="display:none;">
<p>This is a popup!</p>
</apex:outputPanel>
<script>
function showPopup() {
document.getElementById('popupPanel').style.display = 'block';
}
</script>
```
**팁:**

더 나은 스타일링엔 Bootstrap이나 SLDS / 좋은 UX를 위해 항상 "X" 닫기 버튼.

## 71. Integration
**질문:**

LWC에서 파일을 업로드해 Apex로 외부 시스템에 보내려면?
**답변:**

lightning-file-upload로 파일을 캡처하고 ContentVersion으로 Apex에서 가져와 콜아웃했다:
```apex
ContentVersion cv = [SELECT VersionData FROM ContentVersion WHERE Id = :fileId];
Blob fileBody = cv.VersionData;
HttpRequest req = new HttpRequest();
req.setBodyAsBlob(fileBody);
req.setHeader('Content-Type', 'application/pdf');
```
**팁:**

파일 바이트는 ContentVersion.VersionData / Remote Site Settings에 엔드포인트 화이트리스트 잊지 말 것.

## 72. LWC
**질문:**

데이터 조회·저장 중 LWC에 로딩 스피너를 표시하려면?
**답변:**

boolean isLoading 플래그를 Apex 호출 전후로 토글했다:
```html
<template if:true={isLoading}>
<lightning-spinner alternative-text="Loading..." size="medium"></lightning-spinner>
</template>
```
```js
this.isLoading = true;
myApexMethod({ param: this.recordId })
.then(result => {
// process result
})
.finally(() => {
this.isLoading = false;
});
```
**팁:**

내장 로딩엔 `<lightning-spinner>` / 성공·오류 모두 처리하려 finally()에서 토글.

## 73. Admin
**질문:**

사용자가 생성될 때 Permission Set을 자동 할당하려면?
**답변:**

User(After Insert)에 Record-Triggered Flow를 썼다. Create Records로 PermissionSetAssignment 오브젝트에 삽입: `AssigneeId = {!User.Id}`, `PermissionSetId = [Name = 'Your_Permission_Set'인 Permission Set 조회]`.
**팁:**

라벨 대신 Permission Set의 DeveloperName / 권한 이슈를 피하려 flow를 system context로 실행.

## 74. Apex
**질문:**

Apex 콜아웃의 간헐적 실패를 어떻게 처리하나?
**답변:**

Apex 메서드 안에 루프와 재시도 카운터를 썼다:
```apex
Integer retries = 0;
while (retries < 3) {
try {
HttpResponse res = http.send(req);
if(res.getStatusCode() == 200) break;
} catch (Exception e) {
retries++;
}
}
```
**팁:**

무한 루프 금지, 항상 재시도 상한 / 중요 통합엔 Exponential Backoff.

## 75. SOQL
**질문:**

최근 30분 내 갱신된 레코드를 어떻게 가져오나?
**답변:**
```sql
SELECT Id, Name, LastModifiedDate
FROM Account
WHERE LastModifiedDate = LAST_N_MINUTES:30
```
**팁:**

준실시간 동기화엔 LAST_N_MINUTES / 성능을 위해 인덱스 필드(LastModifiedDate) 사용.

## 76. Visualforce
**질문:**

Custom Setting 값에 따라 VF 섹션을 숨기려면?
**답변:**

컨트롤러에서:
```apex
public Boolean showSection { get; set; }
public MyVFController() {
MySetting__c setting = MySetting__c.getInstance();
showSection = setting.Enable_Feature__c;
}
```
페이지에서:
```html
<apex:outputPanel rendered="{!showSection}">
<!-- Section visible if setting is true -->
</apex:outputPanel>
```
**팁:**

Hierarchy Custom Settings엔 getInstance() / 여러 메서드에서 쓰면 static 변수에 캐싱.

## 77. Integration
**질문:**

OAuth 토큰을 받아 Apex에서 외부 API를 호출하려면?
**답변:**

먼저 토큰을 받는 POST 요청:
```apex
HttpRequest req = new HttpRequest();
req.setEndpoint('https://api.example.com/oauth/token');
req.setMethod('POST');
req.setBody('client_id=xxx&client_secret=yyy&grant_type=client_credentials');
Http http = new Http();
HttpResponse res = http.send(req);
String token = (String)((Map<String, Object>)JSON.deserializeUntyped(res.getBody())).get('access_token');
```
그다음 토큰을 다음 호출에:
```apex
req.setHeader('Authorization', 'Bearer ' + token);
```
**팁:**

재사용 시 토큰 안전 보관 / 반복 접근엔 OAuth가 있는 Named Credentials.

## 78. LWC
**질문:**

사용자가 하단으로 스크롤할 때 LWC에서 데이터를 더 로드하려면?
**답변:**

scroll 이벤트 리스너로 하단 도달 시 Apex로 더 로드했다:
```js
handleScroll(event) {
const bottom = event.target.scrollTop + event.target.clientHeight >= event.target.scrollHeight;
if(bottom && !this.isLoading) {
this.loadMoreRecords();
}
}
```
**팁:**

페이지네이션엔 Apex의 LIMIT·OFFSET / 더 로드하는 동안 스피너 표시.

## 79. Admin
**질문:**

로그인한 사용자 역할에 따라 picklist 값을 제한하려면?
**답변:**

Salesforce는 조건부 picklist 값을 네이티브 지원하지 않으므로 Dynamic Choice가 있는 Screen Flow를 만들고 Apex로 사용자 역할 기반 필터 값을 반환했다:
```apex
@AuraEnabled(cacheable=true)
public static List<String> getRoleBasedOptions() {
String roleName = [SELECT UserRole.Name FROM User WHERE Id = :UserInfo.getUserId()].UserRole.Name;
if(roleName == 'Sales Manager') return new List<String>{'High', 'Medium'};
return new List<String>{'Low'};
}
```
**팁:**

동적 picklist 렌더링엔 flow / 재사용 제어엔 역할-값 매핑을 Custom Metadata에 저장.

## 80. Apex
**질문:**

Apex의 어떤 로직이 트랜잭션당 한 번만 실행되도록 보장하려면?
**답변:**

유틸리티 클래스에 static 변수를 썼다:
```apex
public class ExecutionTracker {
public static Boolean hasRun = false;
}
```
로직에서:
```apex
if(!ExecutionTracker.hasRun) {
// run logic
ExecutionTracker.hasRun = true;
}
```
**팁:**

static 변수는 트랜잭션 간 리셋되지만 같은 실행 컨텍스트엔 유지 / 트리거·Batch Apex·재귀 방지에 유용.

## 81. SOQL
**질문:**

단일 SOQL로 Opportunity, Account, Owner를 조인할 수 있나?
**답변:**

예, 부모-부모 조인으로:
```sql
SELECT Name, Account.Name, Owner.Name, StageName
FROM Opportunity
WHERE StageName = 'Closed Won'
```
**팁:**

한 쿼리에 여러 부모 오브젝트 조인 가능 / 쿼리 레벨당 자식 관계는 하나만 허용.

## 82. Visualforce
**질문:**

VF 페이지에 종속 picklist를 어떻게 구현하나?
**답변:**

`<apex:actionSupport>`를 쓰고 Apex에서 값을 수동 필터했다:
```apex
<apex:selectList value="{!selectedControlling}" size="1">
<apex:selectOptions value="{!controllingOptions}"/>
<apex:actionSupport event="onchange" reRender="dependentPicklist"/>
</apex:selectList>
<apex:selectList id="dependentPicklist" value="{!selectedDependent}" size="1">
<apex:selectOptions value="{!getDependentOptions}"/>
</apex:selectList>
```
**팁:**

종속 매핑엔 Schema.DescribeFieldResult.getPicklistValues() / 복잡한 제어엔 Lightning 컴포넌트나 LWC.

## 83. Integration
**질문:**

Apex에서 중첩 JSON 응답을 어떻게 파싱하나?
**답변:**

JSON.deserializeUntyped()를 쓰고 각 레벨을 수동 캐스팅했다:
```apex
Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(jsonBody);
Map<String, Object> user = (Map<String, Object>)response.get('user');
String email = (String)user.get('email');
```
**팁:**

유연한 중첩 JSON 파싱엔 deserializeUntyped / 구조화 파싱엔 Wrapper Class 생성.

## 84. LWC
**질문:**

LWC 로드 시 Apex를 어떻게 호출하나?
**답변:**

함수형 @wire를 썼다:
```js
@wire(getData)
wiredData({ error, data }) {
if(data) {
this.records = data;
} else if(error) {
this.error = error;
}
}
```
또는 명령형 Apex로 connectedCallback():
```js
connectedCallback() {
getData().then(result => {
this.records = result;
});
}
```
**팁:**

반응형 데이터엔 @wire / 조건부·일회성 로직엔 명령형 호출.

## 85. Admin
**질문:**

Flow에서 관련 Account 기반으로 Case 필드를 자동 채우려면?
**답변:**

Case의 Record-Triggered Flow에서 Get Records로 Case.AccountId를 통해 Account를 가져오고, 그 Account 필드를 Assignment Element로 Case 필드에 채웠다.
**팁:**

항상 AccountId가 null이 아닌지 확인 / 깔끔한 할당엔 formula.

## 86. Apex
**질문:**

update 트리거에서 어떤 필드가 수정됐는지 어떻게 추적하나?
**답변:**

필드를 수동 비교하거나 확장성 있는 솔루션엔 ObjectDescribeField + Dynamic Apex를 썼다:
```apex
if(trigger.oldMap.get(rec.Id).Status != rec.Status) {
// Field changed
}
```
**팁:**

동적 필드 추적엔 Schema.SObjectField / 히스토리 로깅엔 Audit Trail이 최선.

## 87. SOQL
**질문:**

다중 선택 picklist에 특정 값을 포함하는 레코드를 어떻게 쿼리하나?
**답변:**
```sql
SELECT Name FROM Contact
WHERE Interests__c INCLUDES ('Travel', 'Music')
```
**팁:**

"하나라도 있음"엔 INCLUDES() / "하나도 없음"엔 EXCLUDES().

## 88. Visualforce
**질문:**

VF에서 저장 후 사용자를 레코드 상세 페이지로 리다이렉트하려면?
**답변:**
```apex
public PageReference saveRecord() {
insert myAccount;
return new PageReference('/' + myAccount.Id);
}
```
**팁:**

DML 후 항상 PageReference 반환 / 커스텀 오브젝트 리다이렉션엔 URLFOR().

## 89. Integration
**질문:**

외부 시스템이 platform event 처리에 실패하면?
**답변:**

Platform Events는 at-least-once 전달을 보장한다. 외부 측에 ReplayId 추적을 구현하고 수신 ID를 저장해 중복을 방지했다.
**팁:**

CometD + Durable Streaming / 리스너에 Retry + Dead Letter Queue 전략.

## 90. LWC
**질문:**

LWC에서 숫자를 통화로 어떻게 포맷하나?
**답변:**
```js
const formatter = new Intl.NumberFormat('en-US', {
style: 'currency',
currency: 'USD'
});
const formattedValue = formatter.format(amount);
```
**팁:**

모든 로케일/통화엔 Intl.NumberFormat / 내장 포맷엔 Lightning Formatting Service.

## 91. Admin
**질문:**

사용자가 레코드를 수동 공유하지 못하게 하려면?
**답변:**

Page Layout에서 Manual Sharing 버튼을 제거하고 Sharing Settings → Private Model + No View All Sharing으로 공유 접근을 비활성화했다.
**팁:**

Classic에선 수동 공유를 완전히 막을 수 없음 / 프로그래밍 제어엔 Apex Sharing.

## 92. Apex
**질문:**

시간 요소를 무시하고 두 date 필드를 어떻게 비교하나?
**답변:**
```apex
if(date1.date() == date2.date()) {
// Dates match
}
```
**팁:**

DateTime 값에 .date() 사용 / 시간이 무관하면 DateTime을 직접 비교하지 말 것.

## 93. SOQL
**질문:**

formula 필드로 SOQL 쿼리를 필터할 수 있나?
**답변:**

예, formula 필드가 저장형(동적이 아님)이면:
```sql
SELECT Id FROM Contact WHERE Age__c > 18
```
**팁:**

비인덱스 formula 필드 필터 회피 / 성능 이슈를 피하려 선택적 필터.

## 94. Visualforce
**질문:**

URL 매개변수로 VF 폼 필드를 사전 채우려면?
**답변:**
```apex
public String defaultValue { get; set; }
public MyController() {
defaultValue = ApexPages.currentPage().getParameters().get('name');
}
```
입력 필드에 바인딩:
```html
<apex:inputText value="{!defaultValue}" />
```
**팁:**

항상 URL 매개변수를 sanitize / 빠른 액션엔 사전 채운 URL의 커스텀 버튼.

## 95. Integration
**질문:**

Base64 인코딩 문자열을 파싱해 파일로 저장하려면?
**답변:**
```apex
Blob fileBlob = EncodingUtil.base64Decode(encodedString);
ContentVersion cv = new ContentVersion(
Title = 'Uploaded',
PathOnClient = 'file.pdf',
VersionData = fileBlob
);
insert cv;
```
**팁:**

항상 파일 타입·크기 검증 / 레코드와 파일 연결엔 ContentDocumentLink.

## 96. LWC
**질문:**

부모를 공유하지 않는 LWC 컴포넌트 간 데이터를 어떻게 전달하나?
**답변:**

Lightning Message Service(LMS)를 썼다:
```js
// Sender
import { publish, MessageContext } from 'lightning/messageService';
publish(this.messageContext, MY_CHANNEL, { value: 'Hello' });
// Receiver
import { subscribe } from 'lightning/messageService';
subscribe(this.messageContext, MY_CHANNEL, (message) => {
this.data = message.value;
});
```
**팁:**

크로스 컴포넌트 통신엔 LMS / LMS 남용 금지, 가능하면 부모-자식.

## 97. Admin
**질문:**

Experience Cloud 사용자에게만 flow를 실행하려면?
**답변:**

Decision element를 썼다: `IF Profile.Name CONTAINS 'Community' OR $User.UserType = 'CSPLitePortal'`.
**팁:**

커뮤니티 사용자 구별엔 $User.UserType / 가능하면 프로필 이름 하드코딩 회피.

## 98. Apex
**질문:**

String이 null이거나 비었는지 안전하게 확인하려면?
**답변:**
```apex
if(String.isNotBlank(myString)) {
// Safe
}
```
**팁:**

isBlank()는 null과 '' 모두 포함 / == ''나 == null 직접 사용 금지.

## 99. SOQL
**질문:**

관련 오브젝트의 필드로 레코드를 정렬하려면?
**답변:**
```sql
SELECT Name, Account.Name FROM Contact
ORDER BY Account.Name ASC
```
**팁:**

ORDER BY RelatedObject.Field 구문 / 대용량에선 비인덱스 필드 정렬 회피.

## 100. LWC
**질문:**

저장 기능이 있는 레코드 편집 가능 LWC 폼을 만들려면?
**답변:**
```html
<lightning-record-edit-form object-api-name="Account" record-id={recordId} onsuccess={handleSuccess}>
<lightning-input-field field-name="Name"></lightning-input-field>
<lightning-button type="submit" label="Save"></lightning-button>
</lightning-record-edit-form>
```
**팁:**

표준 동작엔 lightning-record-edit-form.
