---
tags: [service, service-cloud, omni-channel, external-routing, change-data-capture, cdc, pub-sub-api, platform-event-channel, apex-trigger, change-event, streaming-api, EOL]
source: service_presence_developer_guide.pdf (Omni-Channel Developer Guide — External Routing, v67.0 Summer '26, Tier 2)
official_doc: https://developer.salesforce.com/docs/atlas.en-us.service_presence_developer_guide.meta/service_presence_developer_guide/
created: 2026-06-20
aliases: [External Routing, Omni-Channel External Routing, PendingServiceRouting, AgentWork, UserServicePresence, ExternalRoutingChannel, PreferredUserId, AgentWorkChangeEvent, PendingServiceRoutingChangeEvent, UserServicePresenceChangeEvent, 외부 라우팅, 파트너 라우팅, CDC 외부라우팅]
---

# Omni-Channel External Routing

> Omni-Channel을 서드파티 라우팅 엔진과 통합하는 External Routing — 기술 아키텍처·CDC 구독(Pub/Sub API & Apex Trigger)·AgentWork 생성·예상 동작 시나리오·트러블슈팅. (`service_presence_developer_guide.pdf` Ch4)

> [!warning] **Standard Omni-Channel은 Summer '26(v67.0)으로 EOL에 도달했습니다.** Enhanced Omni-Channel 마이그레이션 권고. 이 노트 내용은 Standard Omni-Channel 기준입니다.

> 📂 형제 노트: [[Omni-Channel 객체·메타데이터·콘솔 컴포넌트]]

---

## 개요 — External Routing이란

> *"Multiple routing options, one console. Integrate third-party routing with Omni-Channel to give your support team more routing options for their work."*

External Routing은 Omni-Channel을 서드파티(파트너) 라우팅 엔진과 통합해, 지원 팀에게 작업 라우팅 옵션을 추가로 제공하는 기능이다.

- 외부 라우팅을 설정하기 전 **동작하는 Omni-Channel 구현**이 이미 있어야 한다.
- Salesforce와 외부 라우팅 구현을 연결하려면 **Salesforce 표준 API 및 streaming API의 v41.0 이상**을 라우팅 구성에서 사용한다.
- 이후 큐를 만들 때, 각 큐는 **Omni-Channel routing** 또는 **외부 라우팅 구현** 중 하나를 사용하도록 만들 수 있다.

> [!note] **Skills-Based / direct-to-rep 라우팅 미지원**
> PDF 원문: *"With external routing, Skills-Based routing or direct-to-rep routing is not supported."*
> (단, 특정 담당자 전달은 후술하는 [Preferred User](#특정-담당자에게-전달-preferreduserid) 메커니즘으로 처리한다.)

---

## 기술 아키텍처와 프로세스

Salesforce와 파트너 애플리케이션 간 정보는 Salesforce API와 파트너 애플리케이션 API를 통해 다음 프로세스로 공유된다.

> [!info] **PDF에 다이어그램 있음 — 본 wiki에는 텍스트 설명만**
> p.8에 정보 흐름을 시각화한 이미지(다이어그램)가 있으나 pdftotext로 추출되지 않았다. 아래 5단계는 다이어그램 직후 PDF 본문에 텍스트로 기술된 프로세스를 그대로 옮긴 것이다. 다이어그램 자체는 재현하지 않는다.

PDF 원문: *"Information is shared using Salesforce APIs and the APIs for your partner application using the following process."*

1. Salesforce uses Change Data Capture to send event notifications to reps.
2. Salesforce sends event notifications for new work items to the partner routing application.
3. Partner routing application matches new work items with logged-in reps.
4. Salesforce sends event notifications to the partner routing application after work is accepted, declined, or completed.
5. Salesforce sends event notifications to the partner routing application after reps log out.

### Salesforce API Resources for External Routing

파트너 애플리케이션을 Omni-Channel과 통합할 때 사용하는 리소스 (PDF 원문: *"Use the following resources as you integrate your partner application with Omni-Channel."*):

| 리소스 | 역할 |
|---|---|
| **AgentWork** | rep에게 라우팅된 work assignment 레코드. 외부 라우팅 시스템이 직접 생성한다. |
| **PendingServiceRouting** (PSR) | 라우팅/할당 대기 중인 work item의 라우팅 상세. |
| **UserServicePresence** (USP) | presence user의 실시간 presence status. |
| Streaming API Developer Guide | streaming API 참조 문서. |
| Streaming API Message Durability | 메시지 내구성(durability) 참조 — 어댑터 재시작 복구 시 사용. |
| Streaming API Limits | streaming API 한도 참조. |

---

## External Routing 통합하기

> PDF 원문: *"Use the following steps to integrate your external routing implementation with Omni-Channel."*

1. Create a Routing Configuration and Queue for External Routing.
2. Add Objects to Change Data Capture for External Routing.
3. Subscribe to Change Data Capture Event Notifications.
4. Create AgentWork.

### 1. 라우팅 구성 & 큐 생성

> 외부 라우팅에는 별도의 routing configuration과 queue가 필요하다. 이 별도 객체들이 라우팅 동작을 정의하고 작업을 rep에게 할당한다.

1. In Setup, enter **Routing Configurations** in the Quick Find box, then select **Routing Configurations**.
2. Create a routing configuration and select **External Routing** for the routing model.
3. Enter **Queues** in the Quick Find box, then select **Queues**.
4. Create a queue and connect it to the routing configuration you created.

> SEE ALSO: Create Routing Configurations for Your Queues / Create a Queue

### 2. CDC에 객체 추가 (최대 5엔티티)

> 외부 라우팅을 활성화하려면 핵심 Service Cloud 객체에 대해 event notification을 publish하도록 Change Data Capture (CDC)를 구성한다.

**객체 추가 절차:**

- From Setup, in the Quick Find box, enter **Change Data Capture**, and then select **Change Data Capture**.
- In the **Available Entities** list, select these objects to set up external routing with Omni-Channel.
  - **PendingServiceRouting**: Routing details for a work item awaiting routing or assignment.
  - **AgentWork**: Work assignment routed to a rep.
  - **UserServicePresence**: A presence user's real-time presence status.
- Move the selected objects to the **Selected Entities** list.

> [!important] **엔티티 한도 — 최대 5개**
> PDF 원문: *"You can select up to five entities, including standard and custom objects. To enable more entities, contact your Salesforce Account Representative to purchase an add-on license."*
> 표준+커스텀 객체 포함 최대 5개. 더 필요하면 Salesforce Account Representative에 연락해 add-on 라이선스 구매.

#### 이벤트 모니터링 규칙 — PendingServiceRouting (PSR)

- **Create**: PSR 생성은 파트너 라우팅 애플리케이션이 rep을 검색하도록 트리거한다.
- **Update**: 레코드 status 변경을 알린다. 파트너 애플리케이션은 **`IsPushed` 값 변화**를 확인해야 한다.
  - `IsPushed` → **true**: PSR에 대한 **AgentWork 레코드가 생성**되었음.
  - `IsPushed` → **false**: 작업이 **declined** 되었으며 다른 rep에게 재할당되어야 함.
- **Delete**: 작업이 rep에게 **accepted** 되었거나, 작업 생성 사유가 제거되었음(예: 고객이 전화를 끊거나 대화를 종료). Delete 이벤트 수신 시 PSR 추적을 중단하고 시스템에서 제거한다.

#### 이벤트 모니터링 규칙 — UserServicePresence (USP)

- **Create 추적**: 각 rep의 status를 추적할 수 있게 한다.
- **Update** (`IsCurrentState` → **false**): rep이 status를 변경했거나 오프라인이 되었음을 의미.
  - rep이 **status를 변경**한 경우 → Update 이벤트 **직후 즉시 Create 레코드 이벤트** notification이 생성됨.
  - rep이 **로그아웃**한 경우 → Update 이벤트 뒤에 Create 레코드 이벤트 notification이 **생성되지 않음**.

#### 이벤트 모니터링 규칙 — AgentWork

- **Create**: 외부 라우팅 시스템이 work item을 rep에게 라우팅할 때 AgentWork 레코드를 생성한다. 이 notification은 **success message**로 취급할 수 있다.
- **Update**: 외부 라우팅 시스템은 Update 이벤트의 **`Status` 필드 변화**를 추적해 rep의 accept/decline 여부를 모니터링해야 한다.
  - work item은 **`Assigned`** status로 생성된다.
  - 작업이 accept되면 status가 **`Opened`** 로 변경된다.
  - **`Unavailable`**: rep이 Assigned work item을 가진 채 오프라인이 되었음 → 새 rep을 할당해야 함.
  - **`Declined`** 또는 **`DeclinedOnPushTimeout`**: rep이 작업을 거부함 → 새 rep을 할당해야 함.
  - 그 외 모든 status는 작업이 완료되었거나 더 이상 필요 없음을 의미 → rep의 capacity를 해제하고 새 작업을 할당할 수 있음.

> 모니터링 대상 핵심 필드: PSR `IsPushed` (true/false), USP `IsCurrentState` (true/false), AgentWork `Status` (`Assigned` / `Opened` / `Unavailable` / `Declined` / `DeclinedOnPushTimeout`).

### 3. CDC 이벤트 구독

> CDC 이벤트 notification을 추적하고 실시간 라우팅 데이터 리스너를 설정하는 구독 방법을 선택한다. 두 가지 옵션이 있다.

- **Pub/Sub API로 구독** — 특정 이벤트(create/update/delete)에 대해 **필터링 가능**.
- **Apex Trigger로 구독** — 모든 change 이벤트에 반응하나 **특정 이벤트 필터링 불가**.

#### Pub/Sub API로 구독

> Pub/Sub API로 외부 클라이언트에서 event notification을 구독해 시스템을 통합할 수 있다. 외부 라우팅에 필요한 create/update/delete 이벤트를 받기 위한 custom channel을 만들 수 있다.

**(i) 외부 라우팅 관련 모든 업데이트를 받으려면 — 기본 채널 생성**

- custom channel을 만든다. 채널명은 다음 구조를 따라야 한다: `ExternalRoutingChannel__chn.platformEventChannel`
- channel member를 정의한다. 이 채널은 외부 라우팅에 핵심적인 객체(예: PendingServiceRouting)에 대한 CDC 이벤트 notification을 받는다.
- channel member를 구성한다. 예시 채널 구조 정의:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<PlatformEventChannel xmlns="http://soap.sforce.com/2006/04/metadata">
    <channelType>data</channelType>
    <label>External Routing Channel</label>
</PlatformEventChannel>
```

- event notification을 listen한다.

**(ii) 레코드가 외부 라우팅 준비된 경우에만 업데이트를 받으려면 — PSR 필터 채널 멤버**

- channel member 레코드를 정의해 `PendingServiceRoutingChangeEvent`를 구독한다. channel member 메타데이터 파일명 구조: `ExtPSRChangeEvent.platformEventChannelMember`
- channel member는 destination channel로 `ExternalRoutingChannel__chn`, monitored object로 `PendingServiceRoutingChangeEvent`를 가져야 한다.
- 예시 필터 로직:

```xml
<?xml version="1.0" encoding="UTF-8"?> <PlatformEventChannelMember
xmlns="http://soap.sforce.com/2006/04/metadata">
<eventChannel>ExternalRoutingChannel__chn</eventChannel>
<selectedEntity>PendingServiceRoutingChangeEvent</selectedEntity>
<filterExpression>RoutingModel = 'ExternalRouting' AND IsReadyForRouting =
true</filterExpression> </PlatformEventChannelMember>
```

> PDF 원문: *"This filter expression ensures that events are only delivered when the routing model is set to ExternalRouting and the IsReadyForRouting field is true."*

- event notification을 listen한다.

**(iii) rep의 로그인/로그아웃/status 변경 notification을 받으려면 — USP 필터 채널 멤버**

- channel member 레코드를 정의해 `UserServicePresenceChangeEvent`를 구독한다. 파일명 구조: `ExtUSPUpdateEvent.platformEventChannelMember`
- destination channel은 `ExternalRoutingChannel__chn`, monitored object는 `UserServicePresenceChangeEvent`.
- rep 가용성 모니터링에 핵심적인 구성:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<PlatformEventChannelMember xmlns="http://soap.sforce.com/2006/04/metadata">
    <eventChannel>ExternalRoutingChannel__chn</eventChannel>
    <selectedEntity>UserServicePresenceChangeEvent</selectedEntity>
    <filterExpression>ChangeEventHeader.changeType = 'CREATE' OR (IsCurrentState =
false)</filterExpression>
</PlatformEventChannelMember>
```

- event notification을 listen한다.

**(iv) 외부 라우팅된 AgentWork 레코드 업데이트만 필터링하려면 — AgentWork 필터 채널 멤버**

- channel member 레코드를 정의해 `AgentWorkChangeEvent`를 구독한다. 파일명: `ExtAgentWorkChangeEvent.platformEventChannelMember`
- destination channel은 `ExternalRoutingChannel__chn`, monitored object는 `AgentWorkChangeEvent`.
- 파트너 라우팅 애플리케이션이 관리하는 work item의 실시간 status·lifecycle 모니터링에 필요한 구성:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<PlatformEventChannelMember xmlns="http://soap.sforce.com/2006/04/metadata">
    <eventChannel>ExternalRoutingChannel__chn</eventChannel>
    <selectedEntity>AgentWorkChangeEvent</selectedEntity>
    <filterExpression>ChangeEventHeader.changeType = 'UPDATE' AND RoutingModel =
'ExternalRouting'</filterExpression>
</PlatformEventChannelMember>
```

> Pub/Sub API event notification을 받으려면 파트너 라우팅 애플리케이션은 setting `/data/ExternalRoutingChannel_chn`을 사용해야 한다.

> [!warning] **불일치 각주 ① — 채널명 밑줄 개수**
> 메타데이터 채널명은 `ExternalRoutingChannel__chn`(밑줄 **2개**)인 반면, Pub/Sub API subscribe setting은 `/data/ExternalRoutingChannel_chn`(밑줄 **1개**)로 PDF 원문에 다르게 표기되어 있다. **PDF 원문 그대로 보존**한 것이며 writer가 임의로 통일하지 않았다. 실제 구현 시 어느 표기가 정확한지 공식 문서로 재확인 권장.

#### Apex Trigger로 구독

> PDF 원문: *"You can use Apex Triggers to capture event notifications. With Apex Triggers, it isn't possible to filter for specific events."*

Apex Trigger로는 **특정 이벤트만 필터링할 수 없으며** 모든 change 이벤트가 트리거를 실행한다. 이벤트 헤더 메커니즘([[ChangeEventHeader]])과 `getRecordIds()` / `header.changedFields` 사용은 CDC change event 표준이다.

**PSR Trigger** — *"This trigger identifies and prepares new work for processing by the partner routing application."*

```apex
trigger PSR_CDC_Trigger on PendingServiceRoutingChangeEvent (after insert) {

   // Iterate through each event message.
   for (PendingServiceRoutingChangeEvent event : Trigger.New) {
    // Get some event header fields
        EventBus.ChangeEventHeader header = event.ChangeEventHeader;
        // All the PSR records that were updated in this transaction. Could be multiple
        // at once - e.g. when updating due to User going offline with multiple work items assigned.
        List<String> recordIds = event.ChangeEventHeader.getRecordIds();
        System.debug('Received change event for ' + header.entityName + ' for ' +
header.recordIds + ' of type ' + header.changeType + ' operation.');
        if (header.changetype == 'CREATE')
        {
           // New PSR record - check model is of type external & isReadyForRouting = true before proceeding
            System.debug('event.IsReadyForRouting: ' + event.IsReadyForRouting);
            System.debug('event.RoutingModel: ' + event.RoutingModel);
            if (event.IsReadyForRouting && event.RoutingModel == 'ExternalRouting')
            {
                // Process new work - remember to iterate all record Ids
                // Likely want to send this to your routing engine to determine who to route it to.
            }
        }
        // For update operations, we can get a list of changed fields
        else if (header.changetype == 'UPDATE') {
   // Updated record details. Updates we care about are:
   //   if 'IsReadyForRouting' updated to true - means it is now ready for routing, and needs an owner. Edge case - this is only where custom routing is used
            //   'LastDeclinedAgentSession' is set/updated - indicates work was declined
           //   if 'IsPushed' becomes true - means it was assigned. External system should know about this already as they create the AgentWork so can likely ignore.
   //   if 'IsPushed' becomes false - means it was released by assigned Agent. Either due to a decline (manual or push timeout), or they went offline (unavailable).
            System.debug('List of all changed fields:');
            // Process the update based on what changed - remember to iterate all record Ids
            for (String field : header.changedFields) {
                if (null == event.get(field)) {
                    System.debug('Deleted field value (set to null): ' + field);
                } else {
                    System.debug('Changed field value: ' + field + '. New Value: '
                        + event.get(field));
                }
            }
        }
        else if (header.changetype == 'DELETE') {
   // Indicates that either the work was accepted, or is no longer needed (i.e. canceled). Either way, no longer need to track this work
   // Remember to iterate all record Ids
        }
}
}
```

**USP Trigger** — *"This trigger monitors the presence status of reps and conveys them to the partner routing application."*

```apex
trigger USP_CDC_Trigger on UserServicePresenceChangeEvent (after insert) {

   // Iterate through each event message.
   for (UserServicePresenceChangeEvent event : Trigger.New) {
    // Get some event header fields
        EventBus.ChangeEventHeader header = event.ChangeEventHeader;
        // All the USP records that were updated in this transaction. Would only ever expect 1 per event
        List<String> recordIds = event.ChangeEventHeader.getRecordIds();
        System.debug('Received change event for ' + header.entityName + ' for ' +
header.recordIds + ' of type ' + header.changeType + ' operation.');
        if (header.changetype == 'CREATE')
        {
           // New USP record - indicates either a first login to Omni-Channel or a Presence Status change to a new presence status
            // Will want to call out to the 3rd party service to let them know about the state of this user (e.g. Busy/Away v Online etc.)
        }
        // For update operations, we can get a list of changed fields
        else if (header.changetype == 'UPDATE') {
            // Updated record. Updates we care about are:
            //   IsCurrentState - Will get updated to false when the user changes status or logs out.
            // Will also get events about 'AverageCapacity' changes as work is accepted & completed, but isn't relevant for External Routing so can be ignored
            System.debug('List of all changed fields:');
            for (String field : header.changedFields) {
                if (null == event.get(field)) {
                    System.debug('Deleted field value (set to null): ' + field);
                } else {
                    System.debug('Changed field value: ' + field + '. New Value: '
                        + event.get(field));
                }
            }
        }
        else if (header.changetype == 'DELETE') {
            // Should never get here for UserServicePresence
           }
    }
}
```

**AgentWork Trigger** — *"This trigger identifies when a new AgentWork record has been created."*

```apex
trigger AgentWork_CDC_Trigger on AgentWorkChangeEvent (after insert) {
 // Iterate through each event message.
   for (AgentWorkChangeEvent event : Trigger.New) {
     // Get some event header fields
        EventBus.ChangeEventHeader header = event.ChangeEventHeader;
        // All the AgentWork records that were updated in this transaction. Could be multiple when updating due to User going offline with multiple work items assigned.
        List<String> recordIds = event.ChangeEventHeader.getRecordIds();
        System.debug('Received change event for ' +
          header.entityName +
          ' for ' + header.recordIds + ' of type ' + header.changeType + ' operation.');
        if (header.changetype == 'CREATE')
        {
            // New AgentWork record - only care about this if mixing External and Omni-Channel routed work, as for external work
            // the external 3rd party application will have created the AgentWork record so already knows about it.
        }
        // For update operations, we can get a list of changed fields
        else if (header.changetype == 'UPDATE') {
            // Updated record. Updates we care about are:
           //  Status - main updates you care about are: 'Opened' - means it was accepted. Any other state update is an end state and will indicate capacity has been released for the user.
            // If mixing External and Internal work, you will get here for both. Need to ensure it is an AgentWork Id that you care about
            // to determine that an externally routed work item is completed. If it is internally routed, you will need to query the DB
           // to get the capacity that the work item consumed and therefore released (both 'CapacityWeight' and 'CapacityPercentage').
            System.debug('List of all changed fields:');
            // Process work - remember to iterate all record Ids
            for (String field : header.changedFields) {
                if (null == event.get(field)) {
                    System.debug('Deleted field value (set to null): ' + field);
                } else {
                    System.debug('Changed field value: ' + field + '. New Value: '
                        + event.get(field));
                }
            }
        }
        else if (header.changetype == 'DELETE') {
            // Shouldn't ever get here for AgentWork
        }
   }
}
```

> [!warning] **불일치 각주 ② — AgentWork change event 엔티티명**
> PDF 본문 산문은 이 trigger를 설명할 때 **`AgentWorkPresenceChangeEvent`** 라고 표기하지만, 실제 trigger 코드는 **`AgentWorkChangeEvent`** 를 사용한다. **코드의 `AgentWorkChangeEvent`가 정확**하며(Pub/Sub 섹션 (iv)와도 일치), 본문 산문 표기가 오기로 판단된다. PDF 원문 불일치를 그대로 명시한다.

### 4. AgentWork 레코드 생성

> 외부 라우팅 애플리케이션은 Omni-Channel에서 work item을 rep에게 라우팅하기 위해 AgentWork 레코드를 생성한다.

> [!warning] **외부 라우팅과 Omni-Channel 라우팅 동시 사용 비권장**
> PDF 원문: *"We strongly recommend not to use external routing and Omni-Channel routing simultaneously because they may assign the same work item to the same rep. This conflicting assignment could lead to complications while tracking consumed work capacity."*
> 동일 work item이 동일 rep에게 중복 할당될 수 있어 소비된 capacity 추적에 문제가 생긴다.

파트너 라우팅 애플리케이션이 routing type이 External인 PSR 생성 이벤트를 받으면, 이벤트 notification 값을 사용해 어떤 작업을 rep에게 라우팅할지 결정하고 AgentWork 레코드를 만들어 라우팅 결정을 내린다.

AgentWork 레코드 생성·전송 단계:

- PSR 이벤트 notification에서 수집한 ID(예: **PendingServiceRouting ID**와 **WorkItem ID**)를 사용해 AgentWork 레코드를 만든다. AgentWork 생성에 필수이므로 PSR ID와 WorkItem ID를 추적해 둔다.
- rep에게 라우팅 준비가 될 때까지 외부 라우팅 애플리케이션에 AgentWork 레코드를 저장한다.
- 준비된 AgentWork 레코드를 Salesforce로 보내는 Apex 코드를 실행한다.

> *"This Apex code sample creates an AgentWork record and assigns the work item to a specific rep."*

```apex
AgentWork work = new AgentWork();
work.ServiceChannelId = '<ServiceChannelId>';
work.WorkItemId = '<WorkItemId>';
work.UserId = '<UserId>';
work.PendingServiceRoutingId = '<PendingServiceRoutingId>';
work.CapacityWeight = <Capacity Weight from PSR>;
insert work;
```

생성 코드에 등장하는 AgentWork 실사용 필드 (위 5개만 — 그 외 필드는 PDF에 정의되지 않음):

| 필드 | 값 |
|---|---|
| `ServiceChannelId` | 서비스 채널 ID |
| `WorkItemId` | work item ID |
| `UserId` | 할당 대상 rep의 user ID |
| `PendingServiceRoutingId` | 출처 PSR의 ID |
| `CapacityWeight` | PSR의 Capacity Weight 값 |

> AgentWork trigger 주석에는 `CapacityPercentage` 필드도 언급된다(내부 라우팅 작업의 소비/해제 capacity 조회 시). 생성 코드에는 포함되지 않는다.

### 특정 담당자에게 전달 (PreferredUserId)

> 라우팅 요건상 작업을 큐가 아니라 **특정 rep**에게 직접 보내야 할 때 Preferred User 기능을 사용한다. 고객 서비스 연속성 유지나 high-priority 에스컬레이션 처리에 특히 유용하다.

**동작 방식:**

특정 지원 rep에게 작업을 전달하려면 Omni-Channel 설정에서 **Skills-Based and Direct-to-Agent Routing**을 켠다. 활성화 후 PSR 레코드가 생성될 때 시스템이 라우팅 엔진에 신호를 보내는 특정 필드를 채운다.

- **Field**: `PreferredUserId`
- **Logic**: 외부 라우팅 엔진은 이 필드의 ID를 우선해야 한다.
- **Outcome**: 표준 load-balancing이나 큐 기반 로직 대신, 엔진은 AgentWork 레코드를 지정된 `UserId`에게 직접 할당하려 시도한다.

> [!note] PDF 원문: *"Ensure your external routing engine is configured to check for the presence of a PreferredUserId on the PSR record before executing its standard distribution algorithms. If this field is populated, it should override the default queue routing to ensure the work reaches the intended rep."*

---

## 예상 동작 (5 시나리오)

> 외부 라우팅 구현을 테스트·사용하며 관찰되는 동작이 다음 예상 시나리오와 일치하는지 검증한다.
>
> 아래 시나리오의 `pushTopic` 이벤트, `EventType`(Create/Update/Delete), Status 값은 PDF 원문 그대로다.

**시나리오 1 — Agent accepts the work:**

1. Chat visitor initiates a chat request from the external routing button.
2. PendingServiceRouting is created.
3. Partner is notified by a pushTopic event (**EventType=Create, isPushed=false**).
4. Partner creates AgentWork using the PSR.
5. Agent is routed the chat request (**AgentWork Status = Assigned**).
6. Agent accepts the chat request (**AgentWork Status = Accept**).
7. Omni-Channel deletes the PendingServiceRouting after Agent accepts the work.
8. Partner is notified by a pushTopic event (**EventType=Delete**).

**시나리오 2 — Agent declines the work through Omni-Channel:**

1. Agent declines the assigned AgentWork.
2. Salesforce updates the PendingServiceRouting.
3. Partner is notified by a pushTopic event (**EventType=Update, LastDeclinedAgentSession**=agent's session id in Chat (not the Salesforce session), **isPushed=false**).
4. Partner creates a new AgentWork using the updated PendingServiceRouting for rerouting.

**시나리오 3 — Agent doesn't accept the work due to push time-out:**

1. Existing PendingServiceRouting is updated.
2. Partner is notified by a pushTopic event (**EventType=Update**, PSR Fields updated: **isPushed=false, LastDeclinedAgentSession**=agent's liveagent session id).
3. Partner creates a new AgentWork for rerouting.

**시나리오 4 — Agent transfers the work to an external routing queue:**

1. New PendingServiceRouting for the transfer is created.
2. Partner is notified by a pushTopic event (**EventType=Create, isTransfer=true, isPushed=false**).
3. The routing process is repeated.

**시나리오 5 — Agent transfers the work to another agent:**

1. The PendingServiceRouting from the original chat request is deleted.
2. A new PendingServiceRouting isn't created when the work is transferred. Subscribe to AgentWork and LiveChatTranscript to determine whether the work was transferred to an agent.
3. Two AgentWorks are created for the LiveChatTranscript:
   a. First AgentWork with the **Status = Opened**
   b. Second AgentWork with the **Status = Assigned**
4. The LiveChatTranscript is updated with the **Status = In Progress** and the Owner = second Agent.
5. To determine if the Transfer to Agent has occurred, check that the second AgentWork isn't inserted into the same LiveChatTranscript as the first AgentWork.

> [!important] **외부 라우팅 + Omni-Channel 큐 기반 라우팅 동시 구현 비권장**
> PDF 원문: *"We don't recommend using both external routing and Omni-Channel queue-based routing in the same implementation. If the same agent is in both queues, the agent's capacity could be exceeded. We don't have control over an agent's capacity in external routing. If you attempt this combination, there can be unknown issues."*

---

## 트러블슈팅

> External Routing for Omni-Channel 구현에서 문제가 발생하면 다음 트러블슈팅 단계를 시도한다.

### 외부 라우팅 어댑터 재시작 복구 (Recover from an External Routing Adaptor Restart)

> 서드파티 어댑터가 재시작에서 복구될 때, **Streaming API의 durability 기능(v37.0 이상)**을 활용해 PSR 토픽의 마지막 성공 position에서 replay해야 한다.

PDF 원문: *"Reference the following code sample in Java."*

```javascript
// Register streaming extension
var replayExtension = new cometdReplayExtension();
replayExtension.setChannel(***<Streaming Channel to Subscribe to>***);
replayExtension.setReplay(<Event Replay Option>);
cometd.registerExtension('myReplayExtensionName', replayExtension);
```

> 더 자세한 내용은 Streaming API Developer Guide의 *Message Durability* 참조.

### Salesforce 데이터 복구 인스턴스에서 복구 (Recover from a Salesforce Data Recovery Instance)

> Salesforce data center switch로 org 인스턴스가 복구될 수 있다. 복구 과정에는 downtime이 포함되므로 모든 online 에이전트가 로그아웃되어야 한다. 서드파티 어댑터가 유지하던 모든 state(예: agent presence)는 더 이상 유효하지 않으므로 reset되어야 한다. 서드파티 어댑터는 토픽에 처음 구독했을 때처럼 재초기화해야 한다.

### 클라이언트 솔루션 테스트 (Test the Client Solution)

> Streaming API를 사용해 **UserServicePresence**와 **PendingServiceRouting**의 CRUD 이벤트를 listen할 수 있다. 예시는 Streaming API Developer Guide의 *Code Examples* 참조.

---

## 관련 노트
- [[Omni-Channel 객체·메타데이터·콘솔 컴포넌트]]
- [[Omni-Channel 라우팅 유형 — Queue 기반 vs Skills 기반]] — 라우팅 4유형 비교·선택 기준 (External Routing의 위치 짚기)
- [[ChangeEventHeader]]
- [[ChangeEvent Objects]]
- [[Platform Event 통합 패턴]]
- [[Service Cloud Objects]]
- [[Tooling API 객체 — Service·OmniChannel (라우팅·대화채널·서비스카탈로그·스케줄링)]] — 외부 라우팅 관련 설정 sObject의 Tooling API facet (QueueRoutingConfig·ServiceChannel 등)
