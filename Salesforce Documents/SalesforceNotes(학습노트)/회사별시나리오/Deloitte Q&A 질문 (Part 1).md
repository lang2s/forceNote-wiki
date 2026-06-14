---
tags: [scenario, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Deloitte Interview Questions (Part -1)]
---

# Deloitte Q&A 질문 (Part 1)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

**OFFSET이란? 예시·용도?** SOQL 절. offset 사용 시 첫 배치만 반환, 다음 배치는 더 높은 OFFSET으로 재실행. 예: `[SELECT Id, Name FROM Account LIMIT 10 OFFSET 10]` → 11~20번째 반환.

**Lookup을 Master-Detail로 변환?** 가능. 단 lookup 필드에 빈 값이 없어야 함(빈 값이면 채운 후 변환).

**Batch에서 삽입/업데이트된 레코드 확인?** SaveResult 클래스. `Database.SaveResult[] srLst = Database.update(lstData, false);` — isSuccess()로 성공, getError()로 오류, getId()로 실패 레코드 ID.

## REST API
RESTful 원칙 기반 웹 서비스. CRUD·검색·메타데이터·한도 조회. XML·JSON 지원. 모바일·외부 클라이언트에 이상적. Apex REST로 Force.com 웹 서비스 생성 가능.

| HTTP 메서드 | 설명 |
|---|---|
| GET | URL로 데이터 조회 |
| POST | 리소스 생성·데이터 전송 |
| DELETE | URL 리소스 삭제 |
| PUT | 요청 본문 리소스 생성·교체 |

### 커스텀 REST API
| 어노테이션 | 용도 |
|---|---|
| @RestResource(urlMapping="url") | 커스텀 Apex 엔드포인트 정의 |
| @HttpGet | 레코드 조회(Read) |
| @HttpPost | 레코드 생성(Create) |
| @HttpPatch | 부분 업데이트(Upsert) |
| @HttpPut | 전체 업데이트(Update) |
| @HttpDelete | 삭제(Delete) |

```apex
@RestResource(urlMapping='/api/Account/*')
global with sharing class MyFirstRestAPIClass {
    @HttpGet
    global static Account doGet() {
        RestRequest req = RestContext.request;
        String AccNumber = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        return [SELECT Id, Name, Phone, Website FROM Account WHERE AccountNumber = :AccNumber];
    }
    @HttpDelete
    global static void doDelete() {
        RestRequest req = RestContext.request;
        String AccNumber = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        delete [SELECT Id FROM Account WHERE AccountNumber = :AccNumber];
    }
    @HttpPost
    global static String doPost(String name, String phone, String AccountNumber) {
        Account acc = new Account(name=name, phone=phone, AccountNumber=AccountNumber);
        insert acc;
        return acc.id;
    }
}
```
기본 엔드포인트: `https://instance.salesforce.com/services/apexrest/` + urlMapping.

## Custom Metadata
계층·프로필/사용자 관련이면 Custom Settings, 아니면 Custom Metadata. 둘 다 캐시 메모리 저장. Custom Metadata는 다른 환경에 배포 가능.
- Custom Object 조회: `[SELECT Id FROM Sample_Object__c]`
- Custom Metadata 조회: `[SELECT Name FROM Sample_Mdt]` — **거버너 한도에 미포함**(무제한 쿼리).
- 장점: 검증 규칙, 페이지 레이아웃, 다른 메타데이터로 lookup.
- 단점: 커스텀 탭 불가, 쿼리 필요.

| Custom Settings | Custom Metadata |
|---|---|
| 쿼리 불필요 | 쿼리 필요 |
| 접근 쉬움 | 배포 쉬움 |
| 사용자별 다른 데이터, 계층형 | 검증 규칙·페이지 레이아웃 |

## Profile vs Permission Set
Profile은 제한, Permission Set은 추가 권한 부여. 15명에게 한 프로필 할당 후 1명에게만 추가 권한 → Permission Set 사용(다른 사용자 영향 없음).
- 프로필 read + 권한 집합 read/write → read·write 둘 다.
- 프로필 read/write + 권한 집합 read → read·write 둘 다. **권한 집합은 권한을 늘릴 뿐 줄일 수 없음.**

## 트리거: Primary Address 단일 보장
```apex
trigger AddressTrigger on Address__c (after insert) {
    Set<Id> accountIdsToUpdate = new Set<Id>();
    for(Address__c addr : Trigger.new) {
        if(addr.Primary__c) accountIdsToUpdate.add(addr.Account__c);
    }
    if(!accountIdsToUpdate.isEmpty()) {
        List<Address__c> existing = [SELECT Id, Primary__c FROM Address__c WHERE Account__c IN :accountIdsToUpdate];
        for(Address__c e : existing) {
            if(e.Primary__c) e.Primary__c = false;
        }
        update existing;
    }
}
```
> 참고: 새로 삽입한 Primary 레코드는 제외하도록 ID 필터 추가가 더 안전합니다.

## Future 메서드
비동기 실행. 외부 콜아웃·장기 작업을 자체 스레드에서. @future, static·void.
```apex
global class MyClass {
    @future
    public static void myFutureMethod(){ }
}
```
**시나리오(대량 데이터 처리):** 트리거에서 대량 레코드를 동기 처리 시 CPU 한도 초과 위험 → future 메서드에 레코드 전달, 백그라운드 비동기 처리.
```apex
trigger MyObjectTrigger on MyObject__c (after insert, after update) {
    List<MyObject__c> recordsToProcess = new List<MyObject__c>();
    for (MyObject__c obj : Trigger.new) recordsToProcess.add(obj);
    if (!recordsToProcess.isEmpty()) MyAsyncProcessor.processRecordsAsync(recordsToProcess);
}
public class MyAsyncProcessor {
    @future
    public static void processRecordsAsync(List<MyObject__c> records) {
        try {
            for (MyObject__c record : records) record.Some_Field__c = record.Amount__c * 1.1;
            update records;
        } catch (Exception e) { System.debug('Error: ' + e.getMessage()); }
    }
}
```

## JSON 읽기
Apex 클래스로 구조 표현 후 JSON.deserialize().
```apex
public class Person {
    public String name;
    public Integer age;
    public String email;
}
String jsonString = '{"name":"John Doe","age":30,"email":"john.doe@example.com"}';
Person personData = (Person) JSON.deserialize(jsonString, Person.class);
```

## SOAP vs REST API
| SOAP | REST |
|---|---|
| SOAP 프로토콜 | REST(HTTP) |
| XML 전송 | JSON 또는 XML |
| 고도 구조화·타입 | 덜 구조화·경량 |
| 대량 데이터 | JavaScript와 호환 |
| 대형 엔터프라이즈 | 모바일 디바이스 |

## 기타
**Role vs Profile?** Role은 가시성, Profile은 수행 가능 작업.
**프로필 없이 User 생성?** 불가.

**insert vs Database.insert()?** insert는 오류 시 전체 롤백(try-catch). Database.insert(list, false)는 부분 성공. Database.insert(list, true)는 insert DML처럼 동작(오류 시 전체 롤백).

**4건 중 3 성공·4번째 실패 시 Database.insert()?** 성공 레코드는 삽입, 오류 레코드는 미삽입(false일 때).

**VF 페이지네이션(20개를 5개씩):**
```apex
public class PaginationController {
    public List<Integer> itemList { get; set; }
    public List<Integer> displayedItems { get; set; }
    public Integer itemsPerPage { get; set; }
    public Integer currentPage { get; set; }
    public Boolean hasPrevious { get; set; }
    public Boolean hasNext { get; set; }
    public PaginationController() {
        itemList = new List<Integer>();
        for(Integer i = 1; i <= 20; i++) itemList.add(i);
        itemsPerPage = 5; currentPage = 1; displayItems();
    }
    public void displayItems() {
        Integer startIndex = (currentPage - 1) * itemsPerPage;
        Integer endIndex = Math.min(startIndex + itemsPerPage, itemList.size());
        displayedItems = new List<Integer>();
        for(Integer i = startIndex; i < endIndex; i++) displayedItems.add(itemList[i]);
        hasPrevious = currentPage > 1;
        hasNext = endIndex < itemList.size();
    }
    public void previousPage() { if(hasPrevious) { currentPage--; displayItems(); } }
    public void nextPage() { if(hasNext) { currentPage++; displayItems(); } }
}
```

**선택 목록을 텍스트로 변경?** 가능.

**이메일 템플릿에서 자식 데이터?** 교차 오브젝트 이메일 템플릿 불가. Visualforce 이메일 템플릿으로만 부모의 자식 레코드 표시.

**두 User lookup 중 하나에 할당된 사용자만 편집:** 검증 규칙 + 트리거.
```apex
trigger RestrictEditOnObject on Your_Object__c (before update) {
    for (Your_Object__c obj : Trigger.new) {
        if (obj.User_Lookup_1__c != UserInfo.getUserId() && obj.User_Lookup_2__c != UserInfo.getUserId()) {
            obj.addError('You do not have permission to edit this record.');
        }
    }
}
```

**HAVING 절?** aggregate 함수 결과 필터(GROUP BY와 함께). `[SELECT LeadSource, count(Name) FROM Lead GROUP BY LeadSource HAVING count(Name) > 6]`

**SOSL 반환 타입?** List<List<SObject>>.
**Aggregate 쿼리 반환?** AggregateResult[].

**Soft vs Hard Delete?** Hard Delete는 휴지통 미보관(영구 삭제). Soft Delete는 휴지통에서 15일 내 복원 가능.
