---
tags: [apex, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Salesforce Apex Magic Real-world Business Scenarios! 🚀]
---

# Salesforce Apex 실전 비즈니스 시나리오 모음 🚀

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

> Apex의 다양한 기능을 보여주는 실전 코드 예제 모음입니다. (코드는 원문 유지, 설명은 한글)

## 1. SOQL을 사용하는 기본 Apex 클래스
산업별 Account를 조회. SOQL을 메서드에 캡슐화해 재사용성·가독성 향상.
```apex
public class AccountProcessor {
    public static List<Account> getAccountsByIndustry(String industry) {
        return [SELECT Id, Name, Industry FROM Account WHERE Industry = :industry];
    }
}
```

## 2. 트리거 컨텍스트 변수를 사용하는 트리거
삽입·업데이트 전 관련 Account 조회. Trigger.new, Trigger.isBefore 활용.
```apex
trigger OpportunityTrigger on Opportunity (before insert, before update) {
    public static void updateRelatedAccounts(List<Opportunity> newOpportunities) {
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opp : newOpportunities) { accountIds.add(opp.AccountId); }
        List<Account> relatedAccounts = [SELECT Id, Name FROM Account WHERE Id IN :accountIds];
    }
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        updateRelatedAccounts(Trigger.new);
    }
}
```

## 3. 생성자·메서드·컬렉션을 사용하는 클래스 (장바구니)
Map으로 항목명-가격 저장.
```apex
public class ShoppingCart {
    private Map<String, Decimal> itemPrices;
    public ShoppingCart() { itemPrices = new Map<String, Decimal>(); }
    public void addItem(String itemName, Decimal price) { itemPrices.put(itemName, price); }
    public Decimal getTotalPrice() {
        Decimal totalPrice = 0;
        for (Decimal price : itemPrices.values()) { totalPrice += price; }
        return totalPrice;
    }
    public List<String> getItemNames() { return new List<String>(itemPrices.keySet()); }
}
```

## 4. Future 메서드와 콜아웃
외부 시스템에서 데이터를 비동기 조회. @future(callout=true).
```apex
public class ExternalDataService {
    @future(callout=true)
    public static void fetchDataFromExternalSystem() {
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.weather.com/data');
        request.setMethod('GET');
        HttpResponse response = new Http().send(request);
    }
}
```

## 5. Batch Apex 클래스
Technology 산업 Account를 청크로 업데이트. start·execute·finish.
```apex
public class AccountUpdateBatch implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator('SELECT Id, Name, Industry FROM Account WHERE Industry = \'Technology\'');
    }
    public void execute(Database.BatchableContext context, List<Account> scope) {
        for (Account acc : scope) { acc.Description = 'Updated by batch process'; }
        update scope;
    }
    public void finish(Database.BatchableContext context) { }
}
```

## 6. 테스트 클래스
@isTest로 메서드 검증, System.assertEquals로 결과 확인.
```apex
@isTest
public class AccountProcessorTest {
    @isTest
    static void testGetAccountsByIndustry() {
        List<Account> testAccounts = new List<Account>();
        testAccounts.add(new Account(Name='Test Account 1', Industry='Technology'));
        insert testAccounts;
        List<Account> result = AccountProcessor.getAccountsByIndustry('Technology');
        System.assertEquals(1, result.size());
    }
}
```

## 7. 핸들러 클래스로 분리한 트리거
Trigger 로직을 핸들러 클래스로 분리해 조직화.
```apex
trigger CaseTrigger on Case (before insert, after update) {
    if (Trigger.isBefore && Trigger.isInsert) { CaseHandler.handleBeforeInsert(Trigger.new); }
    else if (Trigger.isAfter && Trigger.isUpdate) { CaseHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap); }
}
public class CaseHandler {
    public static void handleBeforeInsert(List<Case> newCases) { }
    public static void handleAfterUpdate(List<Case> newCases, Map<Id, Case> oldCaseMap) { }
}
```

## 8. Custom Metadata Type 쿼리
```apex
public class CustomMetadataHandler {
    public static void processMetadata() {
        List<MyCustomMetadata__mdt> metadataList = [SELECT Id, Label__c, Value__c FROM MyCustomMetadata__mdt];
        for (MyCustomMetadata__mdt metadata : metadataList) { }
    }
}
```

## 9. Invocable Method (Process Builder/Flow용)
@InvocableMethod로 선언적 도구에서 Apex 호출.
```apex
public class AccountProcessor {
    @InvocableMethod(label='Update Account Status')
    public static void updateAccountStatus(List<Id> accountIds, String newStatus) {
        List<Account> accountsToUpdate = [SELECT Id, Status__c FROM Account WHERE Id IN :accountIds];
        for (Account acc : accountsToUpdate) { acc.Status__c = newStatus; }
        update accountsToUpdate;
    }
}
```

## 10. Schema Describe 메서드
런타임에 오브젝트·필드 메타데이터 조회.
```apex
Schema.SObjectType objectType = Schema.getGlobalDescribe().get(objectName);
Schema.DescribeSObjectResult objectDescribe = objectType.getDescribe();
Map<String, Schema.SObjectField> fieldMap = objectDescribe.fields.getMap();
Schema.DescribeFieldResult fieldDescribe = fieldMap.get(fieldName).getDescribe();
System.debug('Field Label: ' + fieldDescribe.getLabel());
```

## 11. REST Web Service
@RestResource로 외부 시스템 연동 엔드포인트.
```apex
@RestResource(urlMapping='/MyService/*')
global with sharing class MyRESTService {
    @HttpGet  global static String doGet() { return 'GET processed'; }
    @HttpPost global static String doPost(String requestBody) { return 'POST processed'; }
}
```

## 12. Scheduled Apex
Schedulable 인터페이스로 예약 실행.
```apex
global class MyScheduledJob implements Schedulable {
    global void execute(SchedulableContext context) { System.debug('Executed at: ' + Datetime.now()); }
}
```

## 13. LWC 컨트롤러
@AuraEnabled(cacheable=true)로 클라이언트 측 접근.
```apex
public with sharing class AccountController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() { return [SELECT Id, Name, Industry FROM Account LIMIT 10]; }
}
```

## 14. 이메일 전송
```apex
public class EmailHandler {
    public static void sendEmail(String toAddress, String subject, String body) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[]{toAddress});
        email.setSubject(subject);
        email.setPlainTextBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
    }
}
```

## 15. Database Rollback (Savepoint)
오류 시 Savepoint로 롤백해 데이터 일관성 유지.
```apex
Savepoint sp = Database.setSavepoint();
try {
    update oppsToUpdate;
} catch (Exception e) {
    Database.rollback(sp);
}
```

## 16. 커스텀 예외 처리
```apex
public class CustomExceptionExample {
    public class MyCustomException extends Exception {}
    public static void process() {
        try { Integer result = 10 / 0; }
        catch (Exception e) { throw new MyCustomException('An error occurred: ' + e.getMessage()); }
    }
}
```

## 17. System Assertion
```apex
public static Integer divide(Integer dividend, Integer divisor) {
    System.assert(divisor != 0, 'Divisor cannot be zero.');
    return dividend / divisor;
}
```

## 18. Static 초기화 블록
클래스가 처음 로드될 때 한 번 실행.
```apex
public class StaticInitializer {
    static { System.debug('Static initialization block executed.'); }
}
```

## 19. 인터페이스 구현
```apex
public interface Shape { Decimal calculateArea(); }
public class Circle implements Shape {
    public Decimal radius { get; set; }
    public Decimal calculateArea() { return Math.PI * radius * radius; }
}
```

## 20. Queueable 인터페이스
```apex
public class MyQueueable implements System.Queueable {
    public void execute(System.QueueableContext context) { }
}
```

## 21. JSON 직렬화·역직렬화
```apex
public class JSONHandler {
    public class AccountInfo { public String name; public String industry; }
    public static String serializeAccount(Account acc) {
        AccountInfo info = new AccountInfo();
        info.name = acc.Name; info.industry = acc.Industry;
        return JSON.serialize(info);
    }
    public static Account deserializeAccount(String jsonStr) {
        AccountInfo info = (AccountInfo) JSON.deserialize(jsonStr, AccountInfo.class);
        Account acc = new Account();
        acc.Name = info.name; acc.Industry = info.industry;
        return acc;
    }
}
```

## 22. Dynamic SOQL
런타임에 쿼리 문자열 구성.
```apex
public static List<Account> executeDynamicQuery(String fieldName, String value) {
    String query = 'SELECT Id, Name, Industry FROM Account WHERE ' + fieldName + ' = :value';
    return Database.query(query);
}
```

## 23. Database 메서드 DML (부분 성공)
```apex
Database.SaveResult result = Database.insert(acc, false);
if (!result.isSuccess()) {
    for (Database.Error error : result.getErrors()) { System.debug(error.getMessage()); }
}
```

## 24. Sharing 설정 (with sharing)
```apex
public with sharing class AccountSharingController {
    public List<Account> getMyAccounts() {
        return [SELECT Id, Name FROM Account WHERE OwnerId = :UserInfo.getUserId()];
    }
}
```

## 25. Static 변수·메서드 (카운터)
```apex
public class Counter {
    public static Integer count = 0;
    public static void increment() { count++; }
    public static Integer getCount() { return count; }
}
```

## 26. Final 한정자 (상수)
```apex
public class Constants {
    public static final Integer MAX_ATTEMPTS = 3;
    public static final String API_ENDPOINT;
    static { API_ENDPOINT = 'https://example.com/api'; }
}
```

## 27. Virtual·Abstract 메서드
```apex
public abstract class Shape {
    public virtual String getType() { return 'Shape'; }
    public abstract Decimal calculateArea();
}
public class Triangle extends Shape {
    public Decimal base; public Decimal height;
    public override String getType() { return 'Triangle'; }
    public override Decimal calculateArea() { return 0.5 * base * height; }
}
```

## 28. 어노테이션 (@Deprecated, @SuppressWarnings)
```apex
@Deprecated
public static void oldMethod() { }
@SuppressWarnings('PMD.AvoidUsingHardCodedIP')
public static void process() { }
```

## 29. Enum
```apex
public enum Color { RED, YELLOW, GREEN }
Color light = Color.RED;
switch on light {
    when RED { System.debug('Stop!'); }
    when GREEN { System.debug('Go!'); }
}
```

## 30. @TestVisible 메서드
private 메서드를 테스트에서 접근 가능하게.
```apex
public class DataManipulator {
    @TestVisible private static void internalMethod() { }
    public static void publicMethod() { internalMethod(); }
}
```

## 31. Batchable + Stateful
배치 실행 간 상태 유지.
```apex
public class MyBatchable implements Database.Batchable<SObject>, Database.Stateful {
    private Integer totalCount = 0;
    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator([SELECT Id FROM Account]);
    }
    public void execute(Database.BatchableContext context, List<SObject> scope) { totalCount += scope.size(); }
    public void finish(Database.BatchableContext context) { System.debug('Total: ' + totalCount); }
}
```

## 32. 커스텀 Iterable 클래스
```apex
public class MyIterable implements Iterable<Integer> {
    private List<Integer> elements;
    public MyIterable(List<Integer> elements) { this.elements = elements; }
    public Iterator<Integer> iterator() { return new MyIterator(elements); }
    private class MyIterator implements Iterator<Integer> {
        private Integer index = 0; private List<Integer> elements;
        public MyIterator(List<Integer> elements) { this.elements = elements; }
        public Boolean hasNext() { return index < elements.size(); }
        public Integer next() { return elements[index++]; }
    }
}
```

## 33. 시스템 로그 메시지
```apex
public class LogHandler {
    public static void logInfo(String message) { System.debug('INFO: ' + message); }
    public static void logError(String message) { System.debug('ERROR: ' + message); }
}
```

## 34. 집계 함수 (sum, average)
```apex
public static Integer sum(List<Integer> numbers) {
    Integer total = 0;
    for (Integer num : numbers) { total += num; }
    return total;
}
public static Decimal average(List<Integer> numbers) {
    if (numbers.isEmpty()) return 0;
    Decimal sum = 0;
    for (Integer num : numbers) { sum += num; }
    return sum / numbers.size();
}
```

## 35. 예외 처리 후 재던지기(Re-Throw)
```apex
try { Integer result = 10 / 0; }
catch (Exception e) {
    System.debug('An error occurred: ' + e.getMessage());
    throw e; // 상위 레벨 처리를 위해 재던지기
}
```

## 그 외 예제

이 자료에는 추가로 다음 패턴의 예제가 포함되어 있으며, 위 예제들과 동일한 핵심 개념을 변형 적용합니다:
- **Named Credentials를 사용한 콜아웃:** 인증 정보를 안전하게 관리하며 외부 호출.
- **Queueable Chainable Jobs:** finish/execute에서 `System.enqueueJob`으로 작업 체이닝.
- **Remote Action (@RemoteAction):** Visualforce JavaScript Remoting용 메서드 노출.
- **REST API Endpoint:** @RestResource + @HttpPost/@HttpGet로 커스텀 API.
- **JSON Parsing:** `JSON.deserializeUntyped`로 응답 파싱.
- **Custom Annotations & Reflection:** 메서드의 어노테이션을 런타임에 조회.
- **Scheduling (Schedulable):** System.schedule + cron 표현식.

각 예제의 공통 교훈: 적절한 추상화(클래스·인터페이스), 거버너 한도 고려(벌크화·비동기), 예외·트랜잭션 처리(try-catch·Savepoint), 테스트(75% 커버리지), 보안(with/without sharing)을 적용해 견고하고 유지보수 가능한 Apex 코드를 작성하는 것입니다.
