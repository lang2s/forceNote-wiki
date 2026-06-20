---
tags: [Apex, Trigger, BulkTrigger, addError, 트리거예외, 벌크관용구]
source: salesforce_apex_developer_guide.pdf (Apex Developer Guide v67.0 Summer '26, p.273-285)
created: 2026-06-19
aliases: [Bulk Trigger Idioms, addError, Operations That Don't Invoke Triggers, Fields Not Updateable in Before Triggers, 트리거 벌크, 트리거 예외]
---

# Trigger 벌크 관용구·미발생 작업·예외

> 벌크 트리거를 안전하게 작성하는 Map/Set 관용구, 트리거가 발생하지 않는 시스템 작업 전수, before/after 트리거에서 갱신 불가한 필드, 그리고 `addError()` 기반 예외 마킹과 부분 저장(partial save) 동작.

---

이 노트는 Apex Developer Guide "Invoking Apex" 챕터에서 **벌크 처리 관용구 · 트리거 미발생 작업 · 엔티티/필드 제약 · 트리거 예외**만 다룬다. 트리거의 정의 문법, 컨텍스트 변수, merge/recovered 이벤트, 저장 순서(order of execution)는 별도 노트 소관이므로 deep-link만 둔다(아래 `## 관련 노트`).

---

## 1. Common Bulk Trigger Idioms (벌크 트리거 관용구)

벌크 트리거는 한 번의 호출에서 여러 레코드를 배치(batch)로 처리하므로 실행 거버너 한도를 넘기지 않으면서 더 많은 레코드를 처리할 수 있지만, 그만큼 코드 이해·작성이 어렵다. 벌크로 작성할 때 자주 써야 하는 관용구는 다음과 같다.

### 1-1. Using Maps and Sets in Bulk Triggers

Set·Map 자료구조는 벌크 트리거 코딩의 핵심이다. **Set은 distinct(중복 없는) 레코드를 분리**하는 데, **Map은 레코드 ID 기준으로 정렬된 쿼리 결과를 보관**하는 데 쓴다.

다음 샘플 quoting 애플리케이션의 벌크 트리거는 `Trigger.new`의 각 `OpportunityLineItem`에 연관된 pricebook entry를 먼저 Set에 추가해 distinct 요소만 담는다. 이어 PricebookEntry를 쿼리해 연관 product color를 Map에 넣고, Map이 만들어지면 `Trigger.new`의 OpportunityLineItem들을 순회하며 적절한 색을 할당한다.

```apex
// When a new line item is added to an opportunity, this trigger copies the value of the
// associated product's color to the new record.
trigger oppLineTrigger on OpportunityLineItem (before insert) {
    // For every OpportunityLineItem record, add its associated pricebook entry
    // to a set so there are no duplicates.
    Set<Id> pbeIds = new Set<Id>();
    for (OpportunityLineItem oli : Trigger.new)
        pbeIds.add(oli.pricebookentryid);
    // Query the PricebookEntries for their associated product color and place the results
    // in a map.
    Map<Id, PricebookEntry> entries = new Map<Id, PricebookEntry>(
        [select product2.color__c from pricebookentry
         where id in :pbeIds]);
    // Now use the map to set the appropriate color on every OpportunityLineItem processed
    // by the trigger.
    for (OpportunityLineItem oli : Trigger.new)
        oli.color__c = entries.get(oli.pricebookEntryId).product2.color__c;
}
```

### 1-2. Correlating Records with Query Results in Bulk Triggers

레코드와 쿼리 결과를 상관(correlate)시키려면 `Trigger.newMap`·`Trigger.oldMap`(ID→sObject 맵)을 쓴다. 다음 샘플 quoting 앱 트리거는 `Trigger.oldMap`으로 unique ID 집합(`Trigger.oldMap.keySet()`)을 만든다.

이 집합을 쿼리의 일부로 사용해 처리 중인 opportunity들에 연관된 quote 목록을 만든다. 쿼리가 반환한 모든 quote에 대해, `Trigger.oldMap`에서 관련 opportunity를 꺼내 삭제되지 못하도록 막는다.

```apex
trigger oppTrigger on Opportunity (before delete) {
    for (Quote__c q : [SELECT opportunity__c FROM quote__c
                       WHERE opportunity__c IN :Trigger.oldMap.keySet()]) {
        Trigger.oldMap.get(q.opportunity__c).addError('Cannot delete opportunity with a quote');
    }
}
```

### 1-3. Using Triggers to Insert or Update Records with Unique Fields

insert 또는 upsert 이벤트가 **같은 배치 내 다른 신규 레코드의 unique 필드 값을 중복**시키면, 중복 레코드에 대한 에러 메시지에는 **첫 번째 레코드의 ID**가 포함된다. 그러나 요청이 끝날 무렵에는 그 에러 메시지가 더 이상 정확하지 않을 수 있다.

> caveat (rollback/retry로 인한 ID 무효화):
> 트리거가 존재할 때, 벌크 작업의 retry 로직이 **rollback/retry 주기**를 일으킨다. 그 retry 주기는 신규 레코드에 **새 key를 재할당**한다. 예를 들어 unique 필드에 같은 값을 가진 두 레코드를 insert하고 insert 이벤트 트리거도 정의되어 있으면, 두 번째 중복 레코드가 실패하면서 첫 번째 레코드의 ID를 보고한다. 하지만 시스템이 변경을 롤백하고 첫 번째 레코드를 단독으로 재삽입하면 그 레코드는 **새 ID**를 받는다. 즉, 두 번째 레코드가 보고한 에러 메시지의 ID는 더 이상 유효하지 않다.

---

## 2. Trigger and Bulk Request Best Practices

흔한 개발 함정은 **트리거 호출에 레코드가 1건뿐이라고 가정**하는 것이다. Apex 트리거는 벌크 동작에 최적화되어 있으므로, 정의상 개발자는 벌크 작업을 지원하는 로직을 작성해야 한다.

### 2-1. 결함 패턴 ① — 단일 레코드(Trigger.new[0]) 가정

다음은 결함이 있는 프로그래밍 패턴이다. 트리거 호출 중 레코드가 **하나만** 들어온다고 가정한다. 대부분의 UI 이벤트는 지원하지만, SOAP API·Visualforce를 통해 호출되는 벌크 작업은 지원하지 못한다.

```apex
trigger MileageTrigger on Mileage__c (before insert, before update) {
    User c = [SELECT Id FROM User WHERE mileageid__c = :Trigger.new[0].id];
}
```

### 2-2. 결함 패턴 ② — 루프 내 SOQL(100 초과)

또 다른 결함 패턴이다. 스코프에 레코드가 **100건 미만**이라고 가정한다. 쿼리가 100개를 초과해 발행되면 트리거는 **SOQL 쿼리 한도**를 초과한다.

```apex
trigger MileageTrigger on Mileage__c (before insert, before update) {
    for(mileage__c m : Trigger.new){
        User c = [SELECT Id FROM user WHERE mileageid__c = :m.Id];
    }
}
```

> 거버너 한도 상세는 [[Governor Limits]] 참조.

### 2-3. 올바른 패턴 — keySet() → IN 단일 쿼리

다음은 거버너 한도를 존중하면서 트리거의 벌크 특성을 지원하는 올바른 패턴이다.

```apex
Trigger MileageTrigger on Mileage__c (before update) {
    Set<ID> ids = Trigger.newMap.keySet();
    List<User> c = [SELECT Id FROM user WHERE mileageid__c in :ids];
}
```

이 패턴은 `Trigger.new` 컬렉션을 Set에 담은 뒤 그 Set을 **단일 SOQL 쿼리**에 사용해 벌크 특성을 존중한다. 요청 안의 모든 incoming 레코드를 포착하면서 SOQL 쿼리 수를 제한한다.

### 2-4. Best Practices for Designing Bulk Programs

- **DML 최소화:** 레코드를 컬렉션에 추가하고 그 컬렉션에 대해 DML을 수행해 DML 작업 수를 최소화한다.
- **SOQL 최소화:** 레코드를 전처리해 Set을 생성하고, 이를 `IN` 절을 사용하는 단일 SOQL 문에 넣어 SOQL 문 수를 최소화한다.

---

## 3. Operations That Don't Invoke Triggers (트리거 미발생 작업 — 전수)

트리거는 Java 애플리케이션 서버가 시작·처리하는 DML 작업에 대해 호출된다. 따라서 일부 시스템 벌크 작업은 트리거를 호출하지 않는다.

> Note: person account에 대한 insert·update·delete는 **Account 트리거**를 발생시키며, Contact 트리거는 발생시키지 않는다.

트리거를 호출하지 않는 작업 (PDF 전수):

- **Cascading delete operations** — delete를 *시작한* 레코드만 트리거 평가를 유발한다.
- **Cascading updates of child records** — merge 작업 결과로 reparent된 자식 레코드의 cascade update.
- **Mass campaign status changes** (대량 캠페인 상태 변경)
- **Mass division transfers** (대량 division 이전)
- **Mass address updates** (대량 주소 업데이트)
- **Mass approval request transfers** (대량 승인 요청 이전)
- **Mass email actions** (대량 이메일 액션)
- **Modifying custom field data types** (커스텀 필드 데이터 타입 변경)
- **Renaming or replacing picklists** (피크리스트 이름 변경·교체)
- **Managing price books** (price book 관리)
- **Changing a user's default division** with the transfer division option checked (transfer division 옵션 체크 상태로 사용자 기본 division 변경)
- **다음 객체의 변경:**
  - `BrandTemplate`
  - `MassEmailTemplate`
  - `Folder`

### 3-1. Business ↔ Person Account 레코드 타입 변경

Update account 트리거는 **business account 레코드 타입이 person account로** 바뀌기 전·후에 발생하지 않는다. 또한 **person account 레코드 타입이 business account로** 바뀌기 전·후에도 발생하지 않는다.

### 3-2. FeedItem LikeCount

`LikeCount` 카운터가 증가할 때 FeedItem의 update 트리거는 발생하지 않는다.

### 3-3. Lead Conversion (조건부)

다음 작업에 연관된 **before 트리거는, 조직에서 lead conversion에 대한 validation·trigger가 활성화된 경우에만** lead conversion 중에 발생한다.

- account·contact·opportunity의 insert
- account·contact의 update

### 3-4. Opportunity 트리거 미발생 케이스

Opportunity 트리거는 다음일 때 발생하지 않는다.

- 연관된 opportunity의 owner가 바뀐 결과로 **account owner가 바뀔** 때.
- 연관된 account의 owner가 바뀐 결과로 **opportunity owner가 바뀔** 때.

before·after 트리거와 validation rule은 다음일 때 opportunity에 대해 발생하지 않는다.

- opportunity의 opportunity product를 수정할 때.
- opportunity product schedule이 opportunity product를 변경할 때 (그 opportunity product가 opportunity를 변경하더라도).

> 단, roll-up summary 필드는 업데이트되며, opportunity에 연관된 workflow rule은 실행된다.

### 3-5. getContent / getContentAsPDF

`getContent`·`getContentAsPDF` PageReference 메서드는 **트리거 내에서 허용되지 않는다.**

### 3-6. ContentVersion 객체

- Content pack 작업(slide·slide autorevision 포함)은 트리거를 호출하지 않는다.
  > Note: Content pack은 그 안의 slide가 수정될 때 revise된다.
- `TagCsv`·`VersionData` 필드 값은 ContentVersion 레코드의 생성·업데이트 요청이 **API에서 비롯된 경우에만** 트리거에서 사용 가능하다.
- ContentVersion 객체에는 **before·after delete 트리거를 사용할 수 없다.**

### 3-7. Attachment 객체

Attachment 객체의 트리거는 다음일 때 발생하지 않는다.

- Attachment가 **Case Feed publisher**를 통해 생성될 때.
- 사용자가 **Email 관련 목록**을 통해 이메일을 보내고 첨부 파일을 추가할 때.

> Attachment 객체가 **Email-to-Case** 또는 **UI**를 통해 생성될 때는 트리거가 발생한다.

---

## 4. Entity and Field Considerations in Triggers

트리거를 만들 때 특정 엔티티·필드·작업의 동작을 고려한다.

### 4-1. QuestionDataCategorySelection — After Insert 미제공

하나 이상의 Question 레코드 삽입 후 발생하는 after insert 트리거는 삽입된 Question에 연관된 **`QuestionDataCategorySelection` 레코드에 접근할 수 없다.** 예를 들어 다음 쿼리는 after insert 트리거에서 어떤 결과도 반환하지 않는다.

```apex
QuestionDataCategorySelection[] dcList =
    [select Id,DataCategoryName from QuestionDataCategorySelection where ParentId IN :questions];
```

### 4-2. Fields Not Updateable in Before Triggers (14목록 전수)

일부 필드 값은 before 트리거가 발생한 *후*에 일어나는 시스템 save 작업 중에 설정된다. 그 결과 이 필드들은 **before insert·before update 트리거에서 수정하거나 정확히 감지할 수 없다.**

1. `Task.isClosed`
2. `Opportunity.amount` *
3. `Opportunity.ForecastCategory`
4. `Opportunity.isWon`
5. `Opportunity.isClosed`
6. `Contract.activatedDate`
7. `Contract.activatedById`
8. `Case.isClosed`
9. `Solution.isReviewed`
10. `Id` (for all records) **
11. `createdDate` (for all records) **
12. `lastUpdated` (for all records)
13. `Event.WhoId` (when Shared Activities is enabled)
14. `Task.WhoId` (when Shared Activities is enabled)

> \* When Opportunity has no lineitems, `Amount` can be modified by a before trigger. (Opportunity에 line item이 없으면 `Amount`는 before 트리거로 수정 가능.)
>
> \*\* `Id`와 `createdDate`는 **before update 트리거에서 감지(detect)는 가능**하지만 **수정(modify)은 불가**하다.

### 4-3. Fields Not Updateable in After Triggers

다음 필드는 **after insert·after update 트리거로 업데이트할 수 없다.**

- `Event.WhoId`
- `Task.WhoId`

### 4-4. Considerations for Event DateTime Fields (권장)

event를 생성·업데이트할 때 다음 date·time 필드 사용을 권장한다.

- **timed Event**를 생성·업데이트할 때는 `ActivityDateTime`을 사용해 일관성 없는 날짜·시간 값 문제를 피한다.
- **all-day Event**를 생성·업데이트할 때는 `ActivityDate`를 사용한다.
- `DurationInMinutes`는 Event의 모든 update·create에서 동작하므로 사용을 권장한다.

### 4-5. Operations Not Supported in Insert and Update Triggers

insert·update 트리거에서 다음 작업은 지원되지 않는다.

- Shared Activities가 활성화된 경우, `TaskRelation` 또는 `EventRelation` 객체를 통한 activity relation 조작.
- (Shared Activities 활성화 여부와 무관하게) group event에서 `Invitee` 객체를 통한 invitee relation 조작.

### 4-6. Entities Not Supported in After Undelete Triggers (4종)

특정 객체는 복원될 수 없으므로 after undelete 트리거를 가져서는 안 된다.

- `CollaborationGroup`
- `CollaborationGroupMember`
- `FeedItem`
- `FeedComment`

### 4-7. Considerations for Update Triggers — Field History Tracking

Field history tracking은 **현재 사용자의 권한**을 따른다. 현재 사용자가 객체·필드를 직접 편집할 권한이 없더라도, 그 사용자가 history tracking이 활성화된 객체·필드를 변경하는 트리거를 기동시키면 **변경 이력이 기록되지 않는다.**

### 4-8. Salesforce Side Panel for Salesforce for Outlook

Salesforce Side Panel(Salesforce for Outlook)을 통해 이메일이 레코드에 연관되면, 이메일 연관은 task 레코드의 `WhoId`·`WhatId` 필드로 표현된다. 연관은 task가 생성된 *후*에 완료되므로, `Task.WhoId`·`Task.WhatId` 필드는 insert·update 이벤트의 before·after Task 트리거에서 **즉시 사용할 수 없고 초기값은 null**이다. 단, `WhoId`·`WhatId`는 이후 작업에서 저장된 task 레코드에 설정되므로 나중에 조회할 수 있다.

---

## 5. Trigger Exceptions

트리거는 레코드나 필드에 대해 `addError()` 메서드를 호출함으로써 DML 작업이 일어나지 않도록 막을 수 있다.

- **insert·update 트리거에서는 `Trigger.new` 레코드에**, **delete 트리거에서는 `Trigger.old` 레코드에** 사용하면, 커스텀 에러 메시지가 **애플리케이션 인터페이스에 표시되고 로깅**된다.

> Note: 에러를 **before 트리거**에 추가하면 사용자가 응답 시간 지연을 덜 겪는다.

### 5-1. 부분 마킹(partial marking) 동작 분기 — 전수

처리 중인 레코드의 **일부 subset**을 `addError()`로 마킹할 수 있다. 어떻게 동작하는지는 트리거를 무엇이 기동했느냐에 따라 갈린다.

| 트리거 기동 주체 | 동작 |
|---|---|
| **Apex의 DML 문**이 트리거를 spawn | 단 하나의 에러라도 있으면 **전체 작업이 롤백**된다. 단, 런타임 엔진은 포괄적 에러 목록을 컴파일하기 위해 작업의 **모든 레코드를 계속 처리**한다. |
| **Lightning Platform API의 bulk DML 호출**이 트리거를 spawn | 런타임 엔진이 나쁜 레코드를 따로 떼어 두고, 에러를 생성하지 않은 레코드의 **partial save**를 시도한다. (Bulk DML Exception Handling 참조) |
| 트리거가 **unhandled exception**을 throw | **모든 레코드가 에러로 마킹**되고 더 이상의 처리가 일어나지 않는다. |

### 5-2. 경계 — HTML escaping 오버로드는 이 챕터 미수록

이 챕터의 `addError()` 설명에는 **HTML escaping 제어 오버로드(`SObject.addError(errorMsg, escapeHtml)`)에 대한 상세가 없다.** PDF는 SEE ALSO로 *Apex Reference Guide: `SObject.addError()`* 만 가리킨다.

> HTML escaping을 제어하는 `addError(errorMsg, escapeHtml)` 오버로드의 동작은 **Apex Reference Guide(SObject.addError) 또는 [[Apex 표준 클래스 레퍼런스]]** 를 참조한다. (이 Developer Guide 챕터에는 해당 상세가 없으며, 추후 Exception 클래스 전용 노트가 작성되면 그쪽으로 deep-link한다.)

---

## 관련 노트

- [[Trigger 컨텍스트 변수와 이벤트]] — 트리거 정의 문법·컨텍스트 변수(`Trigger.new`/`newMap`/`oldMap`)·이벤트·merge/recovered 매트릭스 (정의·문법 소관)
- [[TriggerHandler 패턴]] — 트리거 로직을 핸들러 클래스로 분리하는 패턴
- [[Trigger 재귀 방지]] — static 변수 기반 재귀 호출 방지
- [[Trigger Order of Execution]] — insert/update/upsert 저장 시 서버 이벤트 실행 순서
- [[Governor Limits]] — SOQL·DML 등 실행 거버너 한도
- [[Apex 표준 클래스 레퍼런스]] — `SObject.addError()` 등 표준 메서드
- [[특정 표준 객체 트리거 고려사항 — Chatter · Knowledge]] — FeedItem `LikeCount` 미발생·FeedItem/FeedComment after undelete 미지원 등 객체별 미발생 작업·Entity 제약의 구체화
