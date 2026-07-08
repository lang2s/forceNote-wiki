---
tags: [admin, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [salesforce development interview Questions]
---

# Salesforce 개발(Development) Q&A 질문

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

**1. 거버너 한도(Governor Limits)란 무엇이며, Salesforce에 왜 존재하나요?**

거버너 한도는 멀티테넌트 환경에서 효율적인 리소스 사용을 보장하기 위해 Salesforce가 적용하는 런타임 제한입니다. 단일 사용자나 조직이 리소스를 독점하는 것을 방지하여 모든 테넌트의 공정한 사용을 보장합니다. 예시:

- **SOQL 쿼리:** 트랜잭션당 최대 100개
- **DML 문:** 트랜잭션당 최대 150개
- **Heap Size:** 동기 실행 6MB, 비동기 실행 12MB
- **CPU 시간:** 트랜잭션당 최대 10,000밀리초

이 한도는 Salesforce 플랫폼 전반의 시스템 성능, 안정성, 데이터 보안을 유지하기 위해 존재합니다.

**2. SOQL과 SOSL의 차이와 각각 언제 사용하는지 설명하세요.**

| 항목 | SOQL | SOSL |
|---|---|---|
| 목적 | 하나 이상의 관련 오브젝트에서 레코드 쿼리 | 여러 오브젝트에 걸친 텍스트 검색 수행 |
| 검색 범위 | 필드 값 기반 레코드 검색 | 여러 오브젝트와 필드에 걸쳐 검색 |
| 사용 사례 | WHERE 조건을 가진 구조화된 쿼리가 필요할 때 | 키워드 매칭이 있는 전문(full-text) 검색이 필요할 때 |
| 예시 | `SELECT Id, Name FROM Account WHERE Name='Acme'` | `FIND 'Acme' IN ALL FIELDS RETURNING Account(Id, Name)` |

- **SOQL 사용 시점:** 조건, 관계, 집계를 기반으로 특정 레코드를 가져올 때.
- **SOSL 사용 시점:** 텍스트 검색을 사용해 여러 오브젝트에 걸쳐 광범위하게 검색할 때.

**3. Apex의 Bulkification(벌크화)이란 무엇이며 왜 중요한가요?**

Bulkification은 한 번에 하나의 레코드를 처리하는 대신 여러 레코드를 한 번에 처리하도록 Apex 코드를 설계하는 관행입니다. 중요한 이유:

- 거버너 한도 위반 방지 (예: SOQL 쿼리 한도 초과 회피)
- 데이터베이스 및 CPU 시간을 줄여 성능 향상
- 대용량 데이터 처리 시 확장성 보장

**벌크화되지 않은 코드(나쁜 예):**
```apex
for(Account acc : Trigger.new){
    Account a = [SELECT Id FROM Account WHERE Id = :acc.Id]; // 루프 안 쿼리 (BAD)
    a.Name = 'UpdatedName';
    update a; // 루프 안 DML (BAD)
}
```

**벌크화된 코드(모범 사례):**
```apex
List<Account> accList = [SELECT Id FROM Account WHERE Id IN :Trigger.newMap.keySet()];
for(Account a : accList){
    a.Name = 'UpdatedName';
}
update accList; // 단일 DML 작업 (GOOD)
```

**4. Before Trigger와 After Trigger의 차이는?**

| 항목 | Before Trigger | After Trigger |
|---|---|---|
| 실행 시점 | 레코드가 DB에 저장되기 전 실행 | 레코드가 DB에 커밋된 후 실행 |
| 사용 사례 | 저장 전 레코드 값 수정 | 관련 레코드 접근 또는 저장 후 작업 수행 |
| 예시 | 필드 검증 또는 자동 채우기 | 이메일 전송, 관련 레코드 생성 |
| DML 작업 | 명시적 update 불필요 | 명시적 DML 작업 필요 |

```apex
// Before Trigger 예시: 필드 자동 채우기
trigger BeforeUpdateAccount on Account (before insert, before update){
    for(Account acc : Trigger.new){
        acc.Industry = 'Technology'; // 기본값 설정
    }
}

// After Trigger 예시: insert 후 관련 레코드 생성
trigger AfterInsertAccount on Account (after insert){
    List<Contact> contacts = new List<Contact>();
    for(Account acc : Trigger.new){
        Contact c = new Contact(LastName='Default', AccountId=acc.Id);
        contacts.add(c);
    }
    insert contacts;
}
```

**5. Batch Apex는 어떻게 작동하며 언제 사용해야 하나요?**

Batch Apex는 거버너 한도를 피하기 위해 대량의 레코드를 청크 단위로 비동기 처리하는 데 사용됩니다.

핵심 구성 요소:
- `start()`: 처리할 레코드 수집
- `execute()`: 레코드 배치 처리
- `finish()`: 후처리 작업 실행

사용 사례: 대량 레코드 업데이트, 데이터 정리 작업, 외부 시스템과의 통합.

```apex
global class AccountBatchUpdate implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT Id, Name FROM Account');
    }
    global void execute(Database.BatchableContext BC, List<Account> scope){
        for(Account acc : scope){
            acc.Name = acc.Name + '-Updated';
        }
        update scope;
    }
    global void finish(Database.BatchableContext BC){
        System.debug('Batch Processing Completed');
    }
}
// Batch Apex 실행
AccountBatchUpdate batch = new AccountBatchUpdate();
Database.executeBatch(batch, 200);
```

**6. 효율적이고 확장 가능한 Apex 코드 작성을 위한 모범 사례는?**

- 코드를 벌크화하기
- 루프 안에서 SOQL/DML 피하기
- 컬렉션(List, Map, Set) 사용으로 성능 향상
- 비동기 처리(Batch Apex, Future 메서드, Queueable Apex) 사용
- SOQL 쿼리 최적화 (필요한 필드만 쿼리)
- 예외 처리 구현 (try-catch 블록)
- 테스트 클래스 작성 (최소 75% 코드 커버리지 보장)

**7. 통합 기법: Apex에서 외부 서비스로의 콜아웃을 어떻게 구현하나요?**

Salesforce는 Http 및 HttpRequest 클래스를 사용한 HTTP 콜아웃을 허용합니다.

```apex
public class ExternalAPICallout{
    public static void makeCallout(){
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.example.com/data');
        req.setMethod('GET');
        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug(res.getBody());
    }
}
```

**8. 오류 처리: Apex에서 예외 처리에 어떤 방법을 사용하나요?**

- try-catch 블록 사용으로 예외를 잡아 우아하게 처리
- 커스텀 오브젝트나 디버그 로그에 오류 로깅
- ApexPages.Message를 사용해 사용자 친화적 메시지 표시

```apex
try{
    Account acc = [SELECT Id FROM Account WHERE Name='XYZ'];
    System.debug(acc.Id);
}catch(Exception e){
    System.debug('Error: ' + e.getMessage());
}
```

**9. 테스트 프레임워크: Apex 테스트가 적절한 커버리지를 제공하도록 어떻게 보장하나요?**

- 테스트 클래스 정의에 @isTest 어노테이션 사용
- 긍정 및 부정 시나리오 모두 테스트
- 예상 동작 검증을 위해 System.assert() 사용
- 거버너 한도 테스트를 위해 Test.startTest()와 Test.stopTest() 사용

```apex
@isTest
public class AccountTest{
    static testMethod void testAccountInsert(){
        Test.startTest();
        Account acc = new Account(Name='TestAccount');
        insert acc;
        System.assertNotEquals(null, acc.Id);
        Test.stopTest();
    }
}
```

**10. Visualforce vs Lightning: 주요 차이는?**

| 항목 | Visualforce | Lightning Components |
|---|---|---|
| UI 기술 | 페이지 중심, HTML + Apex 사용 | 컴포넌트 기반, 모던 UI |
| 성능 | 서버 측 실행 | JavaScript를 통한 클라이언트 측 실행 |
| 이벤트 처리 | 컨트롤러와 확장(extension) 사용 | Lightning 프레임워크 이벤트 사용 |
| 사용 사례 | 레거시 애플리케이션, 서버 처리 커스텀 UI | 모던 앱, 동적 UI, SPA |

**11. 트리거에서 재귀(recursion)를 효율적으로 어떻게 방지하나요?**

정적 Boolean 변수 사용:
```apex
public class TriggerHelper{
    public static Boolean isTriggerExecuted = false;
}

trigger AccountTrigger on Account (before update){
    if(TriggerHelper.isTriggerExecuted) return;
    TriggerHelper.isTriggerExecuted = true;
}
```

처리된 레코드를 추적하는 Set 사용:
```apex
public class TriggerHelper{
    public static Set<Id> processedRecords = new Set<Id>();
}

trigger AccountTrigger on Account (before update){
    for(Account acc : Trigger.new){
        if(!TriggerHelper.processedRecords.contains(acc.Id)){
            TriggerHelper.processedRecords.add(acc.Id);
        }
    }
}
```

**12. 트리거가 자신을 발동시킨 동일한 레코드를 업데이트하면 어떻게 되나요?**

- **Before Trigger:** 커밋 전 메모리에서 업데이트가 일어나므로 재귀가 발생하지 않습니다.
- **After Trigger:** 레코드 업데이트가 트리거를 다시 발동시켜 재귀를 유발합니다.
- **해결책:** Trigger.oldMap을 사용해 변경을 감지하고 불필요한 업데이트를 방지합니다:

```apex
trigger AccountTrigger on Account (before update){
    for(Account acc : Trigger.new){
        if(acc.Name == Trigger.oldMap.get(acc.Id).Name){
            acc.Name = acc.Name + '-Updated';
        }
    }
}
```

**13. 대량 처리에서 SOQL 거버너 한도를 어떻게 피하나요?**

루프 밖에서 SOQL 쿼리 사용, 조회 데이터에 Map 사용.

나쁜 예 ❌:
```apex
for(Contact c : Trigger.new){
    Account acc = [SELECT Id FROM Account WHERE Id = :c.AccountId]; // 루프 안 SOQL (BAD)
}
```

좋은 예 ✅:
```apex
Map<Id, Account> accountMap = new Map<Id, Account>(
    [SELECT Id, Name FROM Account WHERE Id IN :Trigger.newMap.keySet()]
);
```

**14. 일반 쿼리 대신 SOQL for 루프를 언제 사용해야 하나요?**

대용량 데이터셋(50,000개 이상)을 처리할 때 SOQL for 루프를 사용합니다:
```apex
for(List<Account> accs : [SELECT Id, Name FROM Account]){
    // 더 작은 청크로 레코드 처리
}
```
한도에 도달하지 않고 대용량 데이터를 다룰 때 사용합니다.

**15. 폴링 없이 LWC에서 실시간 업데이트를 어떻게 처리하나요?**

Salesforce Platform Events 또는 Streaming API 사용:
```javascript
import { subscribe, unsubscribe } from 'lightning/empApi';

connectedCallback(){
    this.subscription = subscribe('/event/Order_Updated__e', -1, (event) => {
        console.log('Received event:', event);
    });
}
disconnectedCallback(){
    unsubscribe(this.subscription);
}
```

**16. Lightning Data Service(LDS)의 한계는?**

- Apex에서 사용할 수 없음
- 표준/커스텀 오브젝트로 제한됨 (외부 오브젝트 불가)
- 복잡한 쿼리(집계, 조인 등) 불가
- DML 작업을 직접 호출할 수 없음

빠른 UI 레코드 가져오기에 LDS 사용:
```html
<lightning-record-form record-id={recordId} object-api-name="Account" layout-type="Full"></lightning-record-form>
```

**17. 실시간 통합에서 API 한도(rate limit)를 어떻게 처리하나요?**

- 지수 백오프(Exponential Backoff) 전략 사용
- 비동기 처리(Future, Queueable, Batch Apex) 사용
- 호출 전 API Rate Limit 확인

```apex
public class APIService{
    public static void callAPI(Integer retryCount){
        try{
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://api.example.com');
            request.setMethod('GET');
            HttpResponse response = new Http().send(request);
        }catch(LimitException e){
            if(retryCount < 3){
                System.debug('Retrying in ' + (retryCount*2) + ' seconds');
                callAPI(retryCount+1);
            }
        }
    }
}
```

**18. 만료된 OAuth 토큰을 자동으로 새로 고치는 최선의 방법은?**

Refresh Token Flow 사용:
```http
POST https://login.salesforce.com/services/oauth2/token
Content-Type: application/x-www-form-urlencoded

grant_type=refresh_token
&client_id=YOUR_CLIENT_ID
&client_secret=YOUR_CLIENT_SECRET
&refresh_token=YOUR_REFRESH_TOKEN
```

**19. Queueable, Future, Batch Apex를 언제 사용해야 하나요?**

| 항목 | Future | Queueable | Batch Apex |
|---|---|---|---|
| 사용 사례 | 단순 비동기 처리 | 체이닝이 있는 비동기 처리 | 대용량 데이터 처리(50K+) |
| 체이닝(Chaining) | ❌ | ✅ | ✅ |
| Stateful | ❌ | ✅ | ✅ (제한적) |
| 예시 | API 콜아웃 | 관련 레코드 처리 | 대량 업데이트 |

- 단순 비동기 작업에는 Future 사용
- 체이닝 및 관련 레코드에는 Queueable 사용
- 대용량 데이터 처리에는 Batch Apex 사용

**20. API 재시도에서 중복 레코드를 피하기 위해 멱등성(idempotency)을 어떻게 보장하나요?**

- 중복 제거를 위해 External ID 사용
- API 호출 추적을 위해 고유 request ID 사용

External ID를 사용한 Upsert 예시:
```apex
Account acc = new Account();
acc.External_Id__c = 'API12345'; // 고유 External ID
acc.Name = 'TestAccount';
upsert acc External_Id__c; // 중복 삽입 방지
```

고유 API Request ID 사용:
```apex
public class APIRequestHelper{
    private static Set<String> processedRequests = new Set<String>();
    public static void processRequest(String requestId, Account acc){
        if(!processedRequests.contains(requestId)){
            processedRequests.add(requestId);
            insert acc;
        }
    }
}
```

**21. 트리거에서 future 메서드를 호출할 수 있나요?**

아니요, future 메서드는 트리거에서 직접 호출할 수 없습니다. Future 메서드는 비동기로 실행되며 다른 비동기 컨텍스트(future 메서드나 batch 메서드 등)에서 큐에 넣을 수 없습니다("Future method cannot be called from a future or batch method" 오류). 트리거에서 future 메서드를 호출하면 오류가 발생합니다.

**해결책:**

future 메서드 대신 Queueable Apex 사용:
```apex
public class MyQueueableJob implements Queueable{
    public void execute(QueueableContext context){
        System.debug('Executing queueable job');
    }
}

// 트리거에서 Queueable 호출
trigger AccountTrigger on Account (after insert){
    System.enqueueJob(new MyQueueableJob());
}
```

핵심 정리: Future Methods = 단순 비동기 호출, Queueable Apex = 체인된 비동기 호출.

**22. System Mode와 User Mode의 차이는?**

| 모드 | 설명 | 예시 |
|---|---|---|
| System Mode | 사용자 권한과 필드 수준 보안을 무시 | Apex Trigger, Batch Apex, Scheduled Apex |
| User Mode | 사용자 권한과 필드 수준 보안을 적용 | Visualforce 컨트롤러, Lightning 컴포넌트, Flow |

- **System Mode 사용 시점:** 사용자 보안의 영향을 받지 않아야 하는 백엔드 로직 실행 시(예: 트리거), 전체 접근이 필요한 DML 작업 수행 시.
- **User Mode 사용 시점:** 사용자가 접근 권한이 있는 것만 봐야 할 때(예: UI 컴포넌트, Flow).

**23. 레코드 공유 솔루션 설계를 위한 모범 사례**

1. **OWD를 현명하게 사용:** 민감한 데이터는 Private로 설정하고 공유 규칙으로 접근 개방, 널리 사용 가능한 데이터는 Public Read-Only로 설정.
2. **역할 계층으로 접근 부여:** 상위 역할이 자식 레코드에 자동으로 접근하게 함.
3. **공유 규칙으로 예외 자동화.**
4. **수동 공유로 특정 레코드만 필요 시 공유.**
5. **고급 시나리오에는 Apex Managed Sharing 사용:**
```apex
public class AccountSharing{
    public static void shareAccount(Id accountId, Id userId){
        AccountShare accShare = new AccountShare();
        accShare.AccountId = accountId;
        accShare.UserOrGroupId = userId;
        accShare.AccessLevel = 'Edit';
        insert accShare;
    }
}
```
6. **작업 부하 분산을 위해 Queue 기반 공유 사용:** 레코드를 Queue에 할당하고 사용자가 소유권을 가져가게 함.
7. **대량 트랜잭션에서 공유 재계산 피하기:** 대용량 데이터 처리 시 공유 계산을 지연(defer).
8. **'View All'과 'Modify All' 권한을 무분별하게 사용하지 않기:** 이 권한은 공유 규칙을 우회하므로 필요한 경우에만 사용.

**24. Batch Apex 작업을 어떻게 예약하나요?**

1단계: Batch Apex 클래스 작성
```apex
global class MyBatchJob implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT Id, Name FROM Account');
    }
    global void execute(Database.BatchableContext BC, List<Account> scope){
        for(Account acc : scope){
            acc.Name = acc.Name + '-Processed';
        }
        update scope;
    }
    global void finish(Database.BatchableContext BC){
        System.debug('Batch Processing Completed');
    }
}
```

2단계: Scheduler 클래스 작성
```apex
global class MyBatchScheduler implements Schedulable{
    global void execute(SchedulableContext SC){
        MyBatchJob batch = new MyBatchJob();
        Database.executeBatch(batch, 200);
    }
}
```

3단계: Anonymous Apex로 작업 예약
```apex
String cron = '0 0 12 * * ?'; // 매일 오후 12시 실행
System.schedule('Daily Batch Job', cron, new MyBatchScheduler());
```

핵심 정리: Batch Apex는 대량 처리(50K+)에 사용, Scheduled Apex는 배치 실행을 자동화, System.schedule()로 프로그래밍 방식 예약.

**25. LWC의 라이프사이클 훅(lifecycle hooks)이란?**

라이프사이클 훅은 LWC의 라이프사이클의 여러 단계에서 트리거되는 특수 메서드입니다.

1. **constructor():** 컴포넌트가 생성될 때 발동. 여기서 DOM과 상호작용하지 마세요.
```javascript
constructor(){
    super();
    console.log('Component initialized');
}
```

2. **connectedCallback():** 컴포넌트가 DOM에 추가될 때 발동. Apex에서 데이터를 가져오기 가장 좋은 곳.
```javascript
connectedCallback(){
    console.log('Component connected to the DOM');
}
```

3. **renderedCallback():** 컴포넌트의 UI가 렌더링된 후 발동. DOM 조작에 사용 가능.
```javascript
renderedCallback(){
    console.log('Component has been rendered');
}
```

4. **disconnectedCallback():** 컴포넌트가 DOM에서 제거될 때 발동. 정리 작업(이벤트 리스너 제거 등)에 유용.
```javascript
disconnectedCallback(){
    console.log('Component removed from the DOM');
}
```

5. **errorCallback(error, stack):** 컴포넌트나 자식 컴포넌트에서 오류가 발생할 때 발동. 오류 처리에 사용.
```javascript
errorCallback(error, stack){
    console.log('An error occurred:', error);
}
```

핵심 정리: 데이터 가져오기는 connectedCallback(), DOM 조작은 renderedCallback(), 정리 작업은 disconnectedCallback(), 오류 처리는 errorCallback() 사용.
