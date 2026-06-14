---
tags: [apex, platform-events, testing, test-event-bus, callback]
source: platform_events.pdf (Platform Events Developer Guide v67.0, Summer '26, Tier 2)
created: 2026-06-14
aliases: [Platform Event 테스트, Test.getEventBus, deliver, fail, test event bus, onSuccess onFailure 테스트, 플랫폼 이벤트 테스트]
---

# Platform Event Apex 테스트

> Apex 테스트에서 플랫폼 이벤트는 **테스트 이벤트 버스에 동기 발행**된다. `Test.getEventBus().deliver()` / `.fail()`로 전달·실패를 시뮬레이션해 트리거·콜백(`onSuccess`/`onFailure`)을 검증한다.

> [!note] 공식 *Platform Events Developer Guide v67.0* 발췌. 구독 트리거·발행은 [[Platform Event 정의와 구독]]·[[EventBus Publish Callbacks]] 참조.

---

## 테스트 이벤트 버스

- 테스트 안에서 이벤트 메시지는 **동기적으로** 테스트 이벤트 버스에 발행된다.
- 콜백 메서드 실행을 시뮬레이션하려면 발행을 **deliver(성공)** 하거나 **fail(실패)** 한다.

| 호출 | 효과 |
|---|---|
| `Test.getEventBus().deliver()` | 이벤트를 **즉시 전달** → 콜백의 `onSuccess()` 실행, 구독 트리거 발화 |
| `Test.getEventBus().fail()` | 발행을 **즉시 실패** 처리, 메시지를 버스에서 제거 → 콜백의 `onFailure()` 실행. **트리거는 실패 이벤트를 받지 않음** |
| `Test.stopTest()` 이후 | 그 시점에 이벤트가 **자동 전달**됨(deliver와 동일 효과) |

> 즉, 성공 경로는 `deliver()` 또는 `stopTest()` 이후, 실패 경로는 `fail()`로 검증한다.

---

## 예제 — 콜백 실패/성공 테스트 (Tier 2 원문)

> 사전 준비: Setup에서 label `Order Event`, `Text(18)` 필드 `Order Id`를 가진 플랫폼 이벤트 정의.

```apex
@isTest
public class MyCallbackTest {
    @isTest static void testFailedEventsWithFail() {
        // 콜백과 함께 발행
        FailureAndSuccessCallback cb = new FailureAndSuccessCallback();

        // EventUuid 값을 가진 테스트 이벤트 생성
        Order_Event__e event = (Order_Event__e)Order_Event__e.sObjectType.newSObject(
            null, true);
        event.Order_Id__c = '100';
        System.debug('EventUuid of created event: ' + event.EventUuid);

        // 콜백과 함께 이벤트 발행
        EventBus.publish(event, cb);

        // 실패 처리: onFailure 호출 + 구독자에게 전달 안 함
        Test.getEventBus().fail();

        // onFailure()가 Task를 생성했는지 검증
        List<Task> tasksFailed =
            [SELECT Id, Subject, Description FROM Task
             WHERE Subject = 'Follow up on event publishing failures.'];
        System.Assert.areEqual(1, tasksFailed.size(),
            'Unexpected number of tasks received for failed publishing');
        System.Assert.isTrue(tasksFailed[0].Description.contains(event.EventUuid),
            'Task description should contain the EventUuid');
    }
}
```

- 성공 경로 테스트는 동일 패턴에서 `Test.getEventBus().fail()` 대신 **`Test.getEventBus().deliver()`**(또는 `Test.stopTest()`)를 호출하고 `onSuccess()`가 만든 결과를 검증한다.
- `newSObject(null, true)` 의 두 번째 인자 `true`가 **EventUuid를 채운다**(테스트에서 사용 가능).

---

## 재시도 이벤트 테스트

재시도(`EventBus.RetryableException`) 트리거도 테스트 가능 — `deliver()` 반복 호출로 재전달을 시뮬레이션해 재시도 경로(예: N회 후 처리/오류 상태)를 검증한다.

---

## 관련 노트

- [[Platform Event 정의와 구독]] — after insert 트리거·재시도
- [[EventBus Publish Callbacks]] — onSuccess/onFailure 콜백 구현
- [[Platform Event 발행]] — EventBus.publish
- [[Jest 테스트 패턴]] — (참고) LWE 측 비동기 테스트와 대비
