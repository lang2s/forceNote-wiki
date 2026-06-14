# Salesforce 시나리오 통합 질문 (실전 Apex·LWC·Async)

## 1. 재시도 로직 결제 게이트웨이 통합 (Apex + LWC)
Razorpay·Stripe 결제, 실패 시 재시도. Named Credentials·Queueable·LWC UI.
```apex
public class PaymentQueueable implements Queueable, Database.AllowsCallouts {
    String paymentId;
    public PaymentQueueable(String paymentId) { this.paymentId = paymentId; }
    public void execute(QueueableContext context) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Razorpay/payment/' + paymentId);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        HttpResponse res = new Http().send(req);
        if(res.getStatusCode() != 200) System.enqueueJob(new PaymentQueueable(paymentId)); // 재시도
    }
}
```

## 2. 통합 콜아웃 트리거 (Async-safe)
Opportunity 단계 변경 시 외부 webhook 알림. Trigger → Queueable 패턴.
```apex
trigger OpportunityTrigger on Opportunity (after update) {
    List<Id> oppIdsToNotify = new List<Id>();
    for(Opportunity opp : Trigger.new) {
        if(opp.StageName != Trigger.oldMap.get(opp.Id).StageName) oppIdsToNotify.add(opp.Id);
    }
    if(!oppIdsToNotify.isEmpty()) System.enqueueJob(new NotifyQueueable(oppIdsToNotify));
}
```

## 3. Salesforce→SAP Batch 동기화
10만 건을 200건 배치로 커스텀 REST 동기화.
```apex
global class SAPBatchSync implements Database.Batchable<SObject>, Database.AllowsCallouts {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, Name FROM Account WHERE Sync_Status__c != \'Synced\'');
    }
    global void execute(Database.BatchableContext bc, List<Account> scope) { /* SAP REST */ }
    global void finish(Database.BatchableContext bc) { }
}
```

## 4. Continuation으로 장기 콜아웃 (LWC)
응답 지연(>5초) 외부 주식 API.
```apex
@AuraEnabled(continuation=true)
public static Object getStockData(String symbol) {
    Continuation con = new Continuation(40, Continuation.CONTEXT_APEX);
    HttpRequest req = new HttpRequest();
    req.setEndpoint('callout:StockAPI/quote/' + symbol);
    req.setMethod('GET');
    con.addHttpRequest(req);
    return con;
}
```

## 5. CDC + Kafka (외부 스트리밍)
Account 업데이트 시 CDC 이벤트 → Kafka. Setup → Change Data Capture 활성화, EMP Connector로 소비, Replay ID로 누락 이벤트 추적.

## 6. 커스텀 오브젝트 오류 로깅 프레임워크
```apex
public class LogUtility {
    public static void logError(String endpoint, Integer statusCode, String response, String payload) {
        insert new Integration_Log__c(Endpoint__c=endpoint, Status_Code__c=statusCode,
            Response_Body__c=response, Request_Payload__c=payload, Timestamp__c=System.now());
    }
}
```

## 7. 부모-자식 레코드 삽입 (Account & Contact)
```apex
public static void createAccountWithContacts(String accName, List<String> contactNames) {
    Account acc = new Account(Name = accName);
    insert acc;
    List<Contact> contacts = new List<Contact>();
    for(String name : contactNames) contacts.add(new Contact(FirstName=name, LastName='Default', AccountId=acc.Id));
    insert contacts;
}
```

## 8. REST API 페이지네이션 (nextPageToken)
```apex
String nextPage = 'initial';
while(nextPage != null && Limits.getCallouts() < 100) {
    HttpRequest req = new HttpRequest();
    req.setEndpoint('callout:MyAPI/records?page=' + nextPage);
    req.setMethod('GET');
    HttpResponse res = new Http().send(req);
    Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
    nextPage = (String)responseMap.get('nextPageToken');
}
```

## 9. 인라인 편집 LWC DataTable
```apex
@AuraEnabled(cacheable=true)
public static List<Contact> getContacts() { return [SELECT Id, FirstName, LastName, Email FROM Contact LIMIT 50]; }
@AuraEnabled
public static void updateContacts(List<Contact> updatedList) { update updatedList; }
```
LWC: `handleSave(event)`에서 `event.detail.draftValues`를 updateContacts로 저장.

## 10. API Rate Limit (HTTP 429) 처리
지수 백오프. HTTP 429 시 재시도(Apex는 sleep 불가 → Platform Event 재시도·미들웨어).
```apex
if(res.getStatusCode() == 429 && attempt < 3) {
    Integer delay = (Integer)Math.pow(2, attempt) * 1000 + Math.mod(Crypto.getRandomInteger(), 500);
}
```

## 11. 동적 SOQL 검색 (injection 방지)
```apex
String query = 'SELECT Id, Name, Industry, Rating FROM Account WHERE Name != null';
if(String.isNotBlank(industry)) query += ' AND Industry = \'' + String.escapeSingleQuotes(industry) + '\'';
if(String.isNotBlank(name)) query += ' AND Name LIKE \'%' + String.escapeSingleQuotes(name) + '%\'';
return Database.query(query);
```

## 12. Flow Invocable 이메일 + 첨부
```apex
@InvocableMethod(label='Send Email With Attachment')
public static void send(List<EmailInput> inputs) {
    for(EmailInput input : inputs) {
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName(input.fileName);
        attachment.setBody(EncodingUtil.base64Decode(input.base64Content));
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[]{input.email});
        email.setSubject(input.subject);
        email.setPlainTextBody(input.body);
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{attachment});
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
    }
}
```

## 13. CRUD LWC (Contact)
@AuraEnabled getContacts(accountId)·createContact·deleteContact. @wire 로딩·draftValues 편집.

## 14. CDC 구독 로깅 (Opportunity)
```apex
trigger OpportunityCDCTrigger on OpportunityChangeEvent (after insert) {
    List<Opportunity_Change_Log__c> logs = new List<Opportunity_Change_Log__c>();
    for(OpportunityChangeEvent evt : Trigger.New) {
        logs.add(new Opportunity_Change_Log__c(Opportunity_Id__c=evt.ReplayId,
            Operation__c=evt.ChangeEventHeader.changeType,
            Changed_Fields__c=String.join(evt.ChangeEventHeader.changedFields, ',')));
    }
    insert logs;
}
```

## 15. 외부 시스템 Lead 생성 REST 웹서비스
```apex
@RestResource(urlMapping='/createLead')
global with sharing class LeadWebService {
    @HttpPost
    global static String createLead() {
        Map<String, Object> data = (Map<String, Object>)JSON.deserializeUntyped(RestContext.request.requestBody.toString());
        Lead l = new Lead(FirstName=(String)data.get('firstName'), LastName=(String)data.get('lastName'),
            Email=(String)data.get('email'), Company=(String)data.get('company'));
        insert l;
        return 'Lead Created: ' + l.Id;
    }
}
```

## 16. 재사용 선택 목록 유틸리티
```apex
@AuraEnabled(cacheable=true)
public static List<String> getPicklistValues(String objectName, String fieldName) {
    List<String> values = new List<String>();
    Schema.DescribeFieldResult fieldDesc = Schema.getGlobalDescribe().get(objectName).getDescribe()
        .fields.getMap().get(fieldName).getDescribe();
    for(Schema.PicklistEntry entry : fieldDesc.getPicklistValues()) values.add(entry.getLabel());
    return values;
}
```

## 17. Trigger Framework (Handler 클래스)
```apex
trigger ContactTrigger on Contact (before insert, after update) {
    ContactHandler handler = new ContactHandler();
    if(Trigger.isBefore && Trigger.isInsert) handler.beforeInsert(Trigger.new);
    if(Trigger.isAfter && Trigger.isUpdate) handler.afterUpdate(Trigger.new, Trigger.oldMap);
}
```

## 18. Dead Letter Queue (DLQ) 오류 처리
try-catch로 오류를 DLQ__c에 저장(Attempt·Error_Message·Retry_Ready 포함).

## 19. Flow에서 Lead 전환 + Opportunity 소유자 할당
```apex
@InvocableMethod
public static void convertLeadWithOwner(List<LeadConvertInput> inputs) {
    for(LeadConvertInput input : inputs) {
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(input.leadId);
        lc.setDoNotCreateOpportunity(false);
        lc.setOpportunityOwnerId(input.ownerId);
        Database.convertLead(lc);
    }
}
```

## 20. Scheduled Apex 정리/통합
```apex
global class NightlyCleanupJob implements Schedulable {
    global void execute(SchedulableContext sc) {
        delete [SELECT Id FROM Task WHERE CreatedDate < LAST_N_DAYS:60];
    }
}
System.schedule('Nightly Cleanup', '0 0 2 * * ?', new NightlyCleanupJob());
```

## 21. LWC 파일 업로드 → ContentVersion
```apex
@AuraEnabled
public static void uploadBase64File(String fileName, String base64Data, Id parentId) {
    insert new ContentVersion(Title=fileName, PathOnClient=fileName,
        VersionData=EncodingUtil.base64Decode(base64Data), FirstPublishLocationId=parentId);
}
```

## 22. 콜아웃 테스트 (HttpCalloutMock)
```apex
public class SampleCalloutMock implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"status":"OK"}');
        res.setStatusCode(200);
        return res;
    }
}
// 테스트: Test.setMock(HttpCalloutMock.class, new SampleCalloutMock());
```

## 23. Platform Events로 Cross-Org 통합
Org A가 발행, Org B가 CometD(EMP Connector)로 소비. `EventBus.publish(new Account_Sync__e(...))`. Replay ID를 영구 캐시(Redis/DB)에 저장.

## 24. Twilio WhatsApp 통합
```apex
public static void sendMessage(String toNumber, String bodyMsg) {
    HttpRequest req = new HttpRequest();
    req.setEndpoint('callout:TwilioWhatsApp/messages');
    req.setMethod('POST');
    req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
    req.setBody('To=whatsapp:' + toNumber + '&From=whatsapp:+14155238886&Body=' + EncodingUtil.urlEncode(bodyMsg, 'UTF-8'));
    new Http().send(req);
}
```

## 25. 스케줄 Platform Event 발행
```apex
global class DailySyncPublisher implements Schedulable {
    global void execute(SchedulableContext sc) {
        EventBus.publish(new Sync_Trigger__e(Message__c='Start Daily Sync', Timestamp__c=System.now()));
    }
}
System.schedule('Daily Sync Event', '0 0 3 * * ?', new DailySyncPublisher());
```

## 26. 다중 오브젝트 검증 트리거
Opportunity Closed Won 시 관련 열린 Case가 있으면 차단(AggregateResult).
```apex
for (AggregateResult ar : [SELECT OpportunityId, COUNT(Id) cnt FROM Case
    WHERE OpportunityId IN :oppIds AND Status != 'Closed' GROUP BY OpportunityId]) {
    openCaseCount.put((Id)ar.get('OpportunityId'), (Integer)ar.get('cnt'));
}
for (Opportunity opp : Trigger.new) {
    if (openCaseCount.containsKey(opp.Id)) opp.addError('관련 Case가 열려 있어 마감할 수 없습니다.');
}
```

## 27. Pub/Sub API (실시간 통합)
gRPC 기반 Pub/Sub API(2024 GA). Node.js·Java·Python. OAuth 2.0 인증·`/event/Order_Event__e` 구독·Replay ID 추적. Streaming API보다 다중 소비자 확장성 우수.

## 28. 수식 필드 의존 Apex 테스트
수식 필드는 직접 설정 불가 → Test.loadData() 또는 로직 시뮬레이션. 수식 값 직접 의존을 피해 테스트 친화적으로.

## 29. Custom Setting 플래그 기반 배치 스케줄러
```apex
global class ConditionalScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        if (Integration_Settings__c.getInstance().Run_Batch__c) Database.executeBatch(new MyBatchClass(), 100);
    }
}
```

## 30. GraphQL 통합 (2025 GA)
한 요청으로 Account + 관련 Contact 조회. 쿼리 기반·다중 REST보다 효율.
```graphql
query {
  uiapi { query { Account(first: 10) { edges { node {
    Name { value }
    Contacts(first: 3) { edges { node { Name { value } Email { value } } } }
  } } } } }
}
```
LWC에서 GraphQL Wire 어댑터로 소비.
