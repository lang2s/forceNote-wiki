---
tags: [apex, platform-events, eventbus, namespace, publish, trigger-context, retry]
source: salesforce_apex_reference_guide.pdf (Version 67.0, Summer '26) p.2865, 3872
created: 2026-05-18
aliases: [EventBus Namespace, EventBus.publish, TriggerContext, RetryableException, 이벤트버스 네임스페이스, 플랫폼이벤트 Apex]
---

# EventBus Namespace

> Apex에서 플랫폼 이벤트와 CDC 이벤트를 발행·수신·제어하는 네임스페이스. `System.EventBus` 클래스(발행)와 `EventBus` 네임스페이스 클래스(콜백·트리거 제어)로 구성된다.

---

## 네임스페이스 구성 클래스

| 클래스/인터페이스 | 위치 | 역할 |
|---|---|---|
| `EventBus` | System namespace | `publish()` 정적 메서드 컨테이너 |
| `EventBus.ChangeEventHeader` | EventBus namespace | CDC 이벤트 헤더 필드 |
| `EventBus.EventPublishFailureCallback` | EventBus namespace | 비동기 발행 실패 콜백 인터페이스 |
| `EventBus.EventPublishSuccessCallback` | EventBus namespace | 비동기 발행 성공 콜백 인터페이스 |
| `EventBus.FailureResult` | EventBus namespace | 실패 콜백 결과 인터페이스 |
| `EventBus.SuccessResult` | EventBus namespace | 성공 콜백 결과 인터페이스 |
| `EventBus.TestBroker` | EventBus namespace | 테스트 내 이벤트 전달·실패 시뮬레이션 |
| `EventBus.TriggerContext` | EventBus namespace | 트리거 실행 컨텍스트 정보 및 재개 제어 |
| `EventBus.RetryableException` | EventBus namespace | 트리거 재시도 요청 예외 |

---

## EventBus 클래스 메서드 (System namespace)

```apex
// 단건 발행
Database.SaveResult result = EventBus.publish(new MyEvent__e(Payload__c = 'hello'));

// 다건 발행
List<Database.SaveResult> results = EventBus.publish(new List<MyEvent__e>{
    new MyEvent__e(Payload__c = 'msg1'),
    new MyEvent__e(Payload__c = 'msg2')
});

// 콜백 포함 발행 (비동기 최종 결과 추적)
EventBus.publish(events, new MyFailureCallback());

// AccessLevel 지정 발행 (API v67.0+: 기본값이 USER_MODE로 변경)
EventBus.publishWithAccessLevel(event, AccessLevel.SYSTEM_MODE);
EventBus.publishWithAccessLevel(events, callback, AccessLevel.USER_MODE);

// 발행된 이벤트의 UUID 조회
String uuid = EventBus.getOperationId(result);
```

### publish 메서드 서명 전체 목록

```apex
// 단건
public static Database.SaveResult publish(SObject event)
public static Database.SaveResult publish(SObject event, Object callback)
public static Database.SaveResult publishWithAccessLevel(SObject event, AccessLevel accesslevel)
public static Database.SaveResult publishWithAccessLevel(SObject event, Object callback, AccessLevel accesslevel)

// 다건
public static List<Database.SaveResult> publish(List<SObject> events)
public static List<Database.SaveResult> publish(List<SObject> sobjects, Object callback)
public static List<Database.SaveResult> publishWithAccessLevel(List<SObject> events, AccessLevel accesslevel)
public static List<Database.SaveResult> publishWithAccessLevel(List<SObject> sobjects, Object callback, AccessLevel accesslevel)

// UUID 조회
public static String getOperationId(Object result)
```

### 발행 결과 처리

```apex
List<Database.SaveResult> results = EventBus.publish(events);
for (Database.SaveResult sr : results) {
    if (!sr.isSuccess()) {
        // 큐잉 단계에서의 동기 오류
        System.debug('발행 실패: ' + sr.getErrors()[0].getMessage());
    }
}
// isSuccess() = true → 큐잉 성공 (발행은 비동기로 처리)
// 최종 발행 성공/실패는 Apex Publish Callback으로 수신
```

---

## EventBus.TriggerContext — 트리거 실행 정보 및 재개

```apex
// TriggerContext 프로퍼티
// retries     : 재시도 횟수 (RetryableException으로 인한 재실행 횟수)
// lastError   : 마지막 RetryableException의 메시지

trigger MyEventTrigger on MyEvent__e (after insert) {
    EventBus.TriggerContext ctx = EventBus.TriggerContext.currentContext();
    System.debug('재시도 횟수: ' + ctx.retries);
    System.debug('마지막 오류: ' + ctx.lastError);

    for (MyEvent__e event : Trigger.new) {
        try {
            // 이벤트 처리 로직
            processEvent(event);
            // 성공 처리한 이벤트 체크포인트 설정
            ctx.setResumeCheckpoint(event.ReplayId);
        } catch (Exception e) {
            // 일시적 오류 → RetryableException으로 전체 재시도 요청
            if (ctx.retries < 9) {
                throw new EventBus.RetryableException('재시도 필요: ' + e.getMessage());
            }
            // 9회 초과 → 오류 로깅 후 계속
            System.debug('재시도 한도 초과: ' + e.getMessage());
        }
    }
}
```

### setResumeCheckpoint vs RetryableException

| | `setResumeCheckpoint()` | `RetryableException` |
|---|---|---|
| 서명 | `void setResumeCheckpoint(String resumeReplayId)` | `throw new EventBus.RetryableException(String msg)` |
| 동작 | 체크포인트 이후부터 새 트리거 호출로 재개 | 현재 배치 전체를 처음부터 재처리 |
| 사용 목적 | 한도 제어, 배치 분할, 부분 처리 재개 | 일시적 오류(외부 시스템 타임아웃 등) 재시도 |
| 재시도 횟수 | 제한 없음 | 기본 9회 (TriggerContext.retries로 확인) |

---

## EventBus.TriggerContext 메서드 서명

```apex
// 현재 실행 중인 트리거 컨텍스트 인스턴스 반환
public static EventBus.TriggerContext currentContext()

// 마지막으로 성공 처리한 이벤트의 replayId 조회
public String getResumeCheckpoint()

// 체크포인트 설정 — 이 replayId 다음부터 새 트리거 실행 시작
public void setResumeCheckpoint(String resumeReplayId)
```

---

## 발행 행동(Publish Behavior) 비교

| 설정 | 발행 시점 | 거버너 카운트 |
|---|---|---|
| Publish After Commit | 트랜잭션 커밋 후 | DML 문 한도 (150) |
| Publish Immediately | 즉시 | 별도 한도 150 (`Limits.getPublishImmediateDML()`) |

> [!note] API v67.0 ACCESS MODE 변경
> `EventBus.publish()` 는 API v67.0(Summer '26)부터 기본 `AccessLevel.USER_MODE`로 변경. 트리거의 실행 사용자는 `Automated Process` 사용자 (또는 `PlatformEventSubscriberConfig`로 지정한 사용자). 이전 버전은 `SYSTEM_MODE`.

---

## 테스트 패턴 (TestBroker)

```apex
@IsTest
static void testEventDelivery() {
    Test.startTest();
    EventBus.publish(new List<MyEvent__e>{ new MyEvent__e(Payload__c = 'test') });
    // deliver() : 이벤트를 즉시 트리거에 전달
    Test.getEventBus().deliver();
    Test.stopTest();
    // 트리거가 생성한 레코드 검증
}

@IsTest
static void testPublishFailureCallback() {
    List<MyEvent__e> events = new List<MyEvent__e>{
        (MyEvent__e) MyEvent__e.sObjectType.newSObject(null, true)
    };
    MyFailureCallback cb = new MyFailureCallback();
    Test.startTest();
    EventBus.publish(events, cb);
    Test.getEventBus().fail();   // 발행 실패 시뮬레이션 → onFailure 호출
    Test.stopTest();
}
```

---

## 관련 노트

- [[Platform Event 발행]] — EventBus.publish 기본 패턴, 발행 결과 처리
- [[EventBus Publish Callbacks]] — EventPublishFailureCallback, onFailure, setResumeCheckpoint 상세
- [[ChangeEventHeader]] — CDC 이벤트 헤더 프로퍼티 전체 목록
