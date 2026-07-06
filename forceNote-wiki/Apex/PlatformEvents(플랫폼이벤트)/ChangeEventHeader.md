---
tags: [apex, platform-events, cdc, change-data-capture, change-event-header, eventbus]
source: salesforce_apex_reference_guide (Version 67.0, Summer '26) · Change Data Capture Developer Guide (developer.salesforce.com/docs/atlas.en-us.change_data_capture.meta — cdc_trigger_intro·cdc_subscribe_channels, Tier 2)
created: 2026-05-17
aliases: [ChangeEventHeader, CDC, Change Data Capture, 변경 데이터 캡처, changetype, recordids]
---

# EventBus.ChangeEventHeader

> Change Data Capture(CDC) 이벤트의 헤더 필드를 담는 클래스. CDC 트리거에서 변경된 레코드·필드 정보 파악에 사용.

---

## ⚠️ 전제조건 — CDC 엔티티 선택 (트리거 작성 전 필수)

`{Object}ChangeEvent` 트리거는 코드를 배포한다고 발화하지 않는다. **먼저 Setup에서 대상 엔티티를 선택·저장해 change event가 채널에 발행되도록 켜야** 한다. 엔티티를 선택하지 않으면 채널에 이벤트가 아예 발행되지 않아 트리거는 절대 실행되지 않는다.

**활성화 경로:** `Setup → Change Data Capture`(또는 `Integrations → Change Data Capture`) → **Edit** → 대상 엔티티를 Selected Entities로 이동 → **Save**

```
// 구조 예시 — 실제 동작 코드 아님 (Setup UI 절차)
Setup → Change Data Capture → Edit
   Available Entities → [Account] → Selected Entities
   Save
→ AccountChangeEvent 채널로 change event 발행 시작
→ 이후 AccountChangeEvent 트리거가 발화
```

**하드 한도:** 이 화면에서 선택할 수 있는 엔티티는 **표준 + 커스텀 합쳐 최대 5개**다. 더 많은 엔티티에 CDC가 필요하면 추가 Change Data Capture 라이선스가 필요하다.

### 구독 채널명 형식 (CometD / Pub/Sub API)

외부 클라이언트가 CDC 이벤트를 구독할 때 쓰는 채널명 형식 (CDC Developer Guide — Subscription Channels, Tier 2):

| 대상 | 채널명 형식 | 예시 |
|---|---|---|
| 표준 오브젝트 | `/data/{Object}ChangeEvent` | `/data/AccountChangeEvent` |
| 커스텀 오브젝트 (`__c` → `__ChangeEvent`) | `/data/{Object}__ChangeEvent` | `Employee__c` → `/data/Employee__ChangeEvent` |
| 전체 (선택된 모든 엔티티) | `/data/ChangeEvents` | 표준 채널 하나로 선택된 엔티티 전부 수신 |

**지원 객체 확인 방법:** 모든 객체가 CDC를 지원하는 것은 아니다 — Setup의 Change Data Capture 화면에 뜨는 **Available Entities 목록에 있는 객체가 곧 그 org에서 CDC를 지원하는 객체**다(목록에 없으면 선택 불가 = 미지원). 지원 오브젝트 전수 목록은 [[ChangeEvent Objects]] 참조.

> 커스텀 채널로 엔티티를 구성하는 메타데이터 방식(PlatformEventChannel·PlatformEventChannelMember)은 [[Tooling API 객체 — User·플랫폼이벤트 (이벤트·CDC 채널)]] 참조.

---

## CDC 트리거 기본 구조

```apex
trigger AccountCDCTrigger on AccountChangeEvent (after insert) {
    List<AccountChangeEvent> events = Trigger.new;

    for (AccountChangeEvent event : events) {
        EventBus.ChangeEventHeader header = event.ChangeEventHeader;

        String changeType  = header.changetype;       // CREATE/UPDATE/DELETE/UNDELETE
        List<String> recordIds = header.recordids;    // 변경된 레코드 ID 목록
        String entityName  = header.entityname;       // 오브젝트 API 이름
        String commitUser  = header.commituser;       // 변경 실행 User ID
        Long   commitTs    = header.committimestamp;  // 에포크 밀리초

        // UPDATE일 때만 의미 있음
        List<String> changedFields = header.changedfields;
        List<String> nulledFields  = header.nulledfields;

        System.debug('변경 타입: ' + changeType);
        System.debug('레코드 ID: ' + recordIds);
        System.debug('변경 필드: ' + changedFields);
    }
}
```

---

## changeType 값 처리

```apex
String ct = event.ChangeEventHeader.changetype;

if (ct == 'CREATE') {
    // 새 레코드 생성됨
} else if (ct == 'UPDATE') {
    // 기존 레코드 수정됨
    List<String> changed = event.ChangeEventHeader.changedfields;
    if (changed.contains('Status__c')) {
        // 특정 필드 변경 시 처리
    }
} else if (ct == 'DELETE') {
    // 레코드 삭제됨
} else if (ct == 'UNDELETE') {
    // 휴지통에서 복원됨
}
// GAP_CREATE / GAP_UPDATE / GAP_DELETE / GAP_UNDELETE — 갭 이벤트
// GAP_OVERFLOW — 오버플로우 이벤트
```

---

## 다중 레코드 이벤트 처리

```apex
// 동일 트랜잭션 내 동일 변경이 여러 레코드에 발생하면 하나의 이벤트로 병합됨
List<String> allRecordIds = event.ChangeEventHeader.recordids;
// 예: 피클리스트 값 일괄 업데이트 시 recordIds에 와일드카드 '001*' 포함 가능

for (String rId : allRecordIds) {
    if (rId.endsWith('*')) {
        // 와일드카드 — 정확한 ID 조회 불가
    } else {
        // 정상 레코드 ID 처리
    }
}
```

---

## TriggerContext — 재시도 정보

```apex
// EventBus.TriggerContext: 현재 트리거 실행 컨텍스트 정보
trigger MyPlatformEventTrigger on My_Event__e (after insert) {
    EventBus.TriggerContext ctx = EventBus.TriggerContext.currentContext();
    Integer retryCount = ctx.retries;   // 현재 재시도 횟수

    if (retryCount >= 3) {
        // 최대 재시도 초과 — 에러 로깅 후 포기
        return;
    }

    try {
        // 이벤트 처리 로직
    } catch (Exception e) {
        // 재시도 트리거 (다음 재시도 스케줄)
        throw new EventBus.RetryableException('재처리 필요: ' + e.getMessage());
    }
}
```

---

## 테스트 — TestBroker

```apex
@IsTest
static void testCDCTrigger() {
    // CDC 이벤트 시뮬레이션
    AccountChangeEvent changeEvent = new AccountChangeEvent();
    EventBus.ChangeEventHeader header = new EventBus.ChangeEventHeader();
    header.changetype = 'UPDATE';
    header.recordids  = new List<String>{ '001xx000000001AAAQ' };
    header.changedfields = new List<String>{ 'Name', 'Phone' };
    changeEvent.ChangeEventHeader = header;

    // TestBroker로 이벤트 전달 시뮬레이션
    Test.startTest();
    EventBus.TestBroker.deliver(new List<AccountChangeEvent>{ changeEvent });
    Test.stopTest();
}
```

---

## ChangeEventHeader 프로퍼티 목록

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `changetype` | `String` | `CREATE`/`UPDATE`/`DELETE`/`UNDELETE` (또는 `GAP_*`) |
| `recordids` | `List<String>` | 변경된 레코드 ID 목록 |
| `entityname` | `String` | 오브젝트 API 이름 (예: `Account`) |
| `changedfields` | `List<String>` | UPDATE 시 변경된 필드명 목록 |
| `nulledfields` | `List<String>` | null로 변경된 필드명 목록 |
| `difffields` | `List<String>` | 대용량 텍스트 diff로 전송된 필드 |
| `commituser` | `String` | 변경 실행 User ID |
| `committimestamp` | `Long` | 에포크 밀리초 |
| `commitnumber` | `Long` | 시스템 변경 번호 (SCN) |
| `transactionkey` | `String` | 트랜잭션 고유 키 |
| `sequencenumber` | `Integer` | 트랜잭션 내 변경 순서 (1부터) |
| `changeorigin` | `String` | 변경을 일으킨 API/클라이언트 정보 |

---

## Platform Event vs CDC 비교

| 항목 | Platform Event | Change Data Capture |
|---|---|---|
| 이벤트 소스 | 직접 발행 (`EventBus.publish`) | Salesforce 자동 생성 |
| 이벤트 타입 | 커스텀 (`My_Event__e`) | `{Object}ChangeEvent` |
| 트리거 대상 | 직접 발행 시 | 레코드 CUD 시 |
| 헤더 | 없음 | `ChangeEventHeader` 포함 |
| 재시도 | 수동 처리 | `RetryableException` 지원 |

---

## 관련 노트

- [[Platform Event 발행]] — Platform Event 발행·수신 기본 패턴
- [[Platform Event 한도와 고려사항]] — PE vs CDC 선택 기준 상세표 + 에디션별 발행·전달 할당량(둘이 전달 할당량 공유)
- [[Batch Apex]] — CDC 이벤트를 Batch에서 처리하는 패턴
- [[Queueable]] — CDC 트리거에서 비동기 처리 위임
- [[EventBus Namespace]] — EventBus.publish 메서드 서명, TriggerContext, RetryableException 상세
- [[3 Associated Objects]] — ChangeEvent Object 패턴 상세 (changeType·changedFields·transactionKey)
- [[ChangeEvent Objects]] — CDC 지원 오브젝트 목록 전수·JSON 이벤트 메시지 예제·ChangeEventHeader 필드 상세
- [[Tooling API 객체 — User·플랫폼이벤트 (이벤트·CDC 채널)]] — CDC 커스텀 채널을 정의하는 Tooling sObject 정본(PlatformEventChannel·PlatformEventChannelMember로 채널·선택 엔티티 구성).
- [[integration-eventing-cdc-configure]] (sf-skill — 실행형) — Change Data Capture 활성화 메타데이터 구성 실행형 스킬
