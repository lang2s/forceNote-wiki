---
tags: [scenario, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Salesforce Interview Hyderabad part-1]
---

# Salesforce Q&A 질문/답변 (주제별, Hyderabad Part 1)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## 트리거 시나리오

### Account 상태 Active→Inactive 시 관련 Opportunity 삭제
```apex
trigger DeleteRelatedOpportunity on Account (after update) {
    List<Id> ids = new List<Id>();
    for(Account acc : trigger.new) {
        if(Trigger.oldMap.get(acc.id).Account_Status__c == 'Active' && acc.Account_Status__c == 'Inactive') {
            List<Opportunity> opp = [SELECT id FROM Opportunity WHERE AccountId = :acc.id];
            delete opp;
        }
    }
}
```

### Account checkbox 체크 시 모든 관련 Contact의 checkbox 체크
```apex
trigger CheckboxAccount on Account (after update) {
    List<Contact> contactToUpdate = new List<Contact>();
    for(Account acc : trigger.new) {
        if(acc.chekbox__c == true) {
            for(Contact con : [SELECT id, checkboxContact__c FROM Contact WHERE Accountid = :acc.id AND checkboxContact__c = false]) {
                con.checkboxContact__c = true;
                contactToUpdate.add(con);
            }
        }
    }
    if(!contactToUpdate.isEmpty()) update contactToUpdate;
}
```

### 관련 Opportunity 있으면 Account 삭제 방지
```apex
trigger preventdeleteopp on Account (before delete) {
    Set<Id> ids = new Set<Id>();
    for(Opportunity opp : [SELECT id, Accountid FROM Opportunity WHERE Accountid IN :trigger.old]) ids.add(opp.accountid);
    for(Account acc : trigger.old) {
        if(ids.contains(acc.id)) acc.addError('cannot delete account with associate opportunities');
    }
}
```

### Account 삽입 시 동일 이름·금액·산업 자식 Opportunity 2개 생성
```apex
trigger CreateChildOpportunties on Account (after insert) {
    List<Opportunity> opp = new List<Opportunity>();
    for(Account acc : trigger.new) {
        Opportunity o1 = new Opportunity(name=acc.name, CloseDate=System.today(), StageName='Prospecting', AccountId=acc.Id);
        Opportunity o2 = o1.clone(false, true);
        o2.Name = acc.name;
        opp.add(o1); opp.add(o2);
    }
    insert opp;
}
```

## 트리거 컨텍스트 변수·이벤트
isBefore, isAfter, isInsert, isUpdate, isDelete, isUndelete, size, isExecuting, new, old, newMap, oldMap, operationType.

| 이벤트 | Before | After |
|---|---|---|
| INSERT | new | new, newMap |
| UPDATE | new, newMap, old, oldMap | new, newMap, old, oldMap |
| DELETE | old, oldMap | old, oldMap |
| UNDELETE | — | new, newMap |

- Trigger.new: after DML에서 변경 불가(record is read-only), before에서만.
- Trigger.old: update·delete만(읽기 전용).
- Trigger.newMap: ID 채워진 후만(Before Insert 불가).
- Trigger.operationType: System.TriggerOperation enum.
- 주의: new/old는 DML 직접 불가, before에서만 자기 필드 변경, old는 읽기 전용, new 삭제 불가.

## SOQL
- Opportunity·Contact 모두 있는 Account: `SELECT Id, Name, (SELECT Id, Name FROM Opportunities), (SELECT Id, Name FROM Contacts) FROM Account WHERE Id IN (SELECT AccountId FROM Opportunity) AND Id IN (SELECT AccountId FROM Contact)`
- 단계별 Opportunity 수: `SELECT StageName, COUNT(Id) FROM Opportunity GROUP BY StageName`

## LWC

**@wire / @track / @api 목적?**

@api(public 속성), @track(private 반응형), @wire(반응형 데이터 조회·재렌더링).

**실행 순서(워크플로우+Process Builder+트리거 한 트랜잭션):**

트리거 → 워크플로우 → 워크플로우 업데이트 후 before 트리거 1회. 총 3회.

### 통신: Parent → Child
속성 바인딩으로 부모가 자식에 데이터 전달.
```html
<!-- 부모 -->
<c-child-component message={parentMessage} oncustomevent={handleEvent}></c-child-component>
```

### Child → Parent
CustomEvent로 자식이 부모에 값 전달.
```javascript
// 자식
handleClick() {
    this.dispatchEvent(new CustomEvent('customevent', { detail: 'Event data' }));
}
```
부모는 oncustomevent 핸들러에서 event.detail로 수신.

### LMS (Lightning Message Service)
Visualforce·Aura·LWC 간 통신(Lightning Experience만). message channel·payload. 관계 없는 컴포넌트 간 통신.
**제약:**

모바일 앱·AppExchange·Lightning Out·Communities 미통합, Classic·iframe 미작동, UI에서 채널 직접 생성 불가.

### connectedCallback()
컴포넌트가 DOM에 삽입될 때 호출. 초기화·데이터 조회·이벤트 등록.

### 라이프사이클 훅
connectedCallback(DOM 삽입), renderedCallback(템플릿 렌더링 후), disconnectedCallback(DOM 제거), errorCallback(오류).

## Aura

**Aura vs LWC?**

Aura는 ES6 이전 출시, Aura 전용 코드 작성→네이티브 JS 생성. LWC는 네이티브 JS 작성→성능 향상, ES6 업데이트 즉시 사용.

**컴포넌트 번들:**

Component(UI), Controller JS(클라이언트), Helper JS, Style(CSS), Documentation, Renderer, Design, SVG. 각 컨트롤러 액션은 component·event·helper 3개 매개변수. `{!c.myAction}`으로 호출, helper는 `helper.myActionHelper()`로 호출(컨트롤러에서 컨트롤러 함수·재귀 호출 불가).

**Design 파일 목적?**

관리자가 UI로 매개변수 값 설정.

### Component Event
같은 컴포넌트 또는 상위 컴포넌트가 처리. 자식에서 등록·부모에서 처리.
```xml
<aura:event type="COMPONENT" description="Component Event">
    <aura:attribute name="message" type="String" default="Hello World!!" />
</aura:event>
```
자식: `<aura:registerEvent name="sampleCmpEvent" type="c:ComponentEvent" />`, JS에서 `component.getEvent("sampleCmpEvent").setParams(...).fire()`.
부모: `<aura:handler name="sampleCmpEvent" event="c:ComponentEvent" action="{!c.parentComponentEvent}"/>`.

### Application Event
계층 무관 독립 컴포넌트 간 통신(publish-subscribe).
```xml
<aura:event type="Application" description="Sample Application Event">
    <aura:attribute name="message" type="String" />
</aura:event>
```
Notifier: `$A.get("e.c:ApplicationEvent").setParams(...).fire()`. Handler: `<aura:handler event="c:ApplicationEvent" action="{!c.handleApplicationEvent}"/>`.

### Parent→Child 데이터(Attributes)
aura:attribute는 변수 역할. 기본 타입(String/Boolean/Decimal/Integer/Double/Date/DateTime/Long), 컬렉션(Array/List/Map/Set), Object(JSON). 필수: name·type. access: public(기본)/global/private.

## Apex

### Static vs Non-static 메서드
Static은 클래스 소속(인스턴스 없이 호출, non-static 참조 불가). Non-static은 인스턴스 소속(인스턴스로만 호출, static·non-static 참조 가능).
```apex
public class MyClass {
    public static Integer addNumbers(Integer a, Integer b) { return a + b; }  // static
    private Integer number;
    public MyClass(Integer number) { this.number = number; }
    public Integer multiplyNumber(Integer multiplier) { return number * multiplier; }  // non-static
}
Integer r1 = MyClass.addNumbers(1, 2);
Integer r2 = new MyClass(3).multiplyNumber(4);
```

### Batch 클래스
대량 레코드 처리(50,000 SOQL 한도 초과 시). 비동기·높은 한도. Database.Batchable 구현, start(QueryLocator/Iterable)·execute(배치당, 기본 200)·finish(이메일·후처리).
```apex
global class batch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc) { }
    global void execute(Database.BatchableContext bc, List<SObject> scope) { }
    global void finish(Database.BatchableContext bc) { }
}
```

### Future 메서드
백그라운드 비동기. 외부 콜아웃·Mixed DML 회피. 리소스 가용 시 실행, 높은 거버너 한도.
```apex
global class FutureClass {
    @future
    public static void myFutureMethod() { }
}
```

### Database.Stateful
트랜잭션 간 상태 유지(인스턴스 변수만, static 미유지). 카운팅·요약에 유용.

### Future vs Queueable
| Future | Queueable |
|---|---|
| @future 어노테이션 | Queueable 인터페이스 |
| 모니터링 불가 | Job ID 모니터링 |
| Future·Batch에서 호출 불가, 50개 | 체이닝(Dev 5, Enterprise 50) |
| 기본 타입만 | 기본·비기본 타입 |

## Platform Events
Salesforce 내·외부 앱에 알림 전달. 이벤트 기반 아키텍처. point-to-point 통합 과제·거버너 한도 극복. __e 접미사. Pub/Sub, 폴링 불필요, ReplayId로 재생. 필드: Checkbox·Date·Date/Time·Number·Text·Text Area만.

**용어:**

Event(상태 변화), Event message/Notification, Event producer(발행자), Channel(event bus), Event consumer(구독자).

| SObject__c | Platform Events__e |
|---|---|
| DML(Insert/Update/Delete) | Publish(Insert만) |
| SOQL | Streaming API |
| Triggers | Subscribers |
| 병렬 컨텍스트 | 보장된 실행 순서 |

**고려사항:**

__e 접미사, SOQL/SOSL 쿼리 불가, 리포트·리스트 뷰·검색 불가(탭 없음), 롤백 불가, 필드 읽기 전용, after insert 트리거만, API·선언적 접근, 프로필·권한 제어.

## 예외 유형
DmlException(필수 필드 누락·Mixed DML·Invalid Data), System.FinalException(Record read-only), ListException(index out of bounds), NullPointerException, QueryException(행 없음·비선택 쿼리), SObjectException(미쿼리 필드), LimitException(SOQL 101·DML 151·CPU 시간·Query rows 50001), StringException, JSONException, UnexpectedException, FlowException.
