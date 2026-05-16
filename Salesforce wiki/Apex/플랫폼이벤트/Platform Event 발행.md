---
tags: [apex, platform-event, publish, trigger, pattern]
source: apex-recipes/PlatformEventRecipes.cls
created: 2026-05-17
aliases: [Platform Event, EventBus.publish, 플랫폼 이벤트]
---

# Platform Event 발행

> `EventBus.publish()`로 이벤트를 발행하고 트리거로 수신. DML + EventBus.publish()는 같은 트랜잭션에서 사용 가능. 수신 트리거는 별도 트랜잭션.

---

## 발행 패턴

```apex
// 단건 발행
LogEvent__e event = new LogEvent__e(
    Message__c  = 'Processing complete',
    Severity__c = 'INFO'
);
EventBus.publish(event);

// 다건 발행 (List)
List<OrderEvent__e> events = new List<OrderEvent__e>();
for (Order o : orders) {
    events.add(new OrderEvent__e(
        OrderId__c = o.Id,
        Status__c  = o.Status
    ));
}
List<Database.SaveResult> results = EventBus.publish(events);
```

---

## 발행 결과 확인

```apex
List<Database.SaveResult> results = EventBus.publish(events);
for (Integer i = 0; i < results.size(); i++) {
    if (!results[i].isSuccess()) {
        System.debug('발행 실패: ' + results[i].getErrors()[0].getMessage());
    }
}
```

---

## 수신 트리거 패턴

```apex
trigger LogEventTrigger on LogEvent__e (after insert) {
    List<Log_Entry__c> entries = new List<Log_Entry__c>();

    for (LogEvent__e event : Trigger.new) {
        entries.add(new Log_Entry__c(
            Message__c   = event.Message__c,
            Severity__c  = event.Severity__c,
            EventUUID__c = event.EventUuid  // 중복 방지용 고유 ID
        ));
    }

    insert entries;
}
```

---

## 트랜잭션 동작

```apex
// DML + EventBus.publish() — 같은 트랜잭션에서 가능
insert newAccount;                    // DML
EventBus.publish(new OrderEvent__e()); // 같은 트랜잭션

// 메인 트랜잭션 롤백 시: 이벤트도 발행되지 않음 (일관성 보장)
// 수신 트리거: 별도 트랜잭션 (독립 실행)
```

> [!note] 트랜잭션 경계
> `EventBus.publish()`는 메인 트랜잭션이 **커밋된 후** 이벤트를 발행. 롤백 시 이벤트도 취소됨. 수신 트리거의 DML 실패는 이벤트 발행 자체를 영향 안 줌.

---

## Platform Event vs Streaming API vs CDC

| | Platform Event | Streaming API | Change Data Capture |
|---|---|---|---|
| 소스 | 커스텀 이벤트 | SOQL 기반 PushTopic | SObject 변경 |
| 수신 | Apex Trigger, LWC | LWC, External | LWC, External |
| DML 연동 | ✅ | ❌ | 자동 |
| 재사용 | ✅ | ❌ (deprecated) | ❌ |

---

## Platform Event 정의 (SFDX 메타데이터)

```xml
<!-- LogEvent__e.object-meta.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<CustomObject xmlns="http://soap.sforce.com/2006/04/metadata">
    <deploymentStatus>Deployed</deploymentStatus>
    <eventType>HighVolume</eventType>  <!-- HighVolume 또는 StandardVolume -->
    <label>Log Event</label>
    <pluralLabel>Log Events</pluralLabel>
    <fields>
        <fullName>Message__c</fullName>
        <type>Text</type>
        <length>255</length>
    </fields>
</CustomObject>
```

---

## 고급: ReplayId로 이벤트 재처리

```apex
// 수신 트리거에서 마지막 ReplayId 저장
String lastReplayId = Trigger.new[Trigger.new.size() - 1].ReplayId;
// LWC Subscribe에서 -1: 새 이벤트만, -2: 24시간 이내 전체
```

---

## 관련 노트

- [[Log 싱글턴 패턴]] — EventBus.publish 활용
- [[Queueable]] — 이벤트 처리 후 비동기 체이닝
- [[Custom REST Endpoint]]

