---
tags: [devops, devops-center, platform-events, user-field, object-reference, sf_devops]
source: devops_center_dev.pdf (Salesforce DevOps Center Developer Guide v67.0, Summer '26)
created: 2026-06-27
aliases: [Deployment event, Work Item Commit, Work Item Merged Change Request, Work Item Open Change Request, Work Item State Change, 플랫폼 이벤트, User 커스텀 필드, sf_devops__e, GitHub Primary Email Address, DevOps Center 플랫폼 이벤트]
---

# DevOps Center — User 커스텀 필드 · 플랫폼 이벤트

> DevOps Center가 User 표준 객체에 추가하는 커스텀 필드 1개와, 작업 항목(work item)의 개발·프로모션 라이프사이클에서 발생하는 플랫폼 이벤트 5종의 전체 필드 레퍼런스.

---

## DevOps Center Custom Field on the User Standard Object

DevOps Center 데이터 모델은 User 표준 객체를 사용하며 이 커스텀 필드를 추가한다.

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| `sf_devops__GitHub_Primary_Email_Address__c` | email | Create, Filter, Group, Nillable, Sort, Update | Primary email address of the user's GitHub account. |

> SEE ALSO: Object Reference for the Salesforce Platform: User

---

## DevOps Center Custom Platform Events

DevOps Center generates platform events for work items as they move through the development and promotion lifecycle.

- **개발 단계(development phases):** DevOps Center generates a platform event every time a work item changes state (New, In Progress, and so on). DevOps Center also generates a platform event for every commit on the work item's feature branch and when the change request is opened.
- **프로모션 라이프사이클(promotion lifecycle):** DevOps Center generates a platform event whenever the work item's metadata is merged into a pipeline stage. DevOps Center also generates a platform event whenever a work item's metadata is deployed to a pipeline stage's org.

You can subscribe to these events using all the methods supported by Salesforce (Apex Triggers, Flows, LWCs, APIs, and so on).

이벤트 5종은 모두 **API version 62.0 and later**에서 사용 가능하며, 구독에는 **DevOps Center package version 8.2 or later가 설치**되어 있어야 한다(Special Access Rules). 5종 모두 `create()`, `describeSObjects()` 호출을 지원하고, Event Delivery Allocation Enforced = Yes 이며, 아래 5개 구독자 유형을 모두 지원한다.

| Subscriber | Supported? |
|---|---|
| Apex Triggers | ✅ |
| Flows | ✅ |
| Processes | ✅ |
| Pub/Sub API | ✅ |
| Streaming API (CometD) | ✅ |

> 위 구독자 지원표는 5개 이벤트(`Deployment__e`, `Work_Item_Commit__e`, `Work_Item_Merged_Change_Request__e`, `Work_Item_Open_Change_Request__e`, `Work_Item_State_Change__e`)에 **동일하게 적용**된다 (각 이벤트 페이지의 Supported Subscribers 표를 PDF 페이지 이미지로 직접 확인 — 모두 ✅).

> 공통 필드(`EventUuid`, `ReplayId`) 정의는 모든 이벤트에서 동일하다. 아래 각 이벤트 표에 PDF 원문 그대로 반복 수록한다.

---

## Deployment (sf_devops__Deployment__e)

Notifies subscribers when a work item's metadata is deployed to a pipeline stage. This object is available in API version 62.0 and later.

- **Supported Calls:** `create()`, `describeSObjects()`
- **Streaming API Subscription Channel:** `/event/sf_devops__Deployment__e`
- **Event Delivery Allocation Enforced:** Yes
- **Special Access Rules:** DevOps Center package version 8.2 or later must be installed in the org.

### Fields

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| `EventUuid` | string | Nillable | The unique ID of the event, which is shared with the corresponding storage object. For example, `0a4779b0-0da1-4619-a373-0a36991dff90`. Use this field to correlate the event with its storage object. |
| `ReplayId` | string | Nillable | Represents an ID value that is populated by the system and refers to the position of the event in the event stream. Replay ID values aren't guaranteed to be contiguous for consecutive events. A subscriber can store a replay ID value and use it on resubscription to retrieve missed events that are within the retention window. |
| `sf_devops__Change_Bundle_Id__c` | string | Create, Nillable | The ID of the work item change bundle that was deployed. This field is empty if an individual work item was deployed. |
| `sf_devops__Deployment_Id__c` | string | Create, Nillable | The ID for the deployment in the target org. |
| `sf_devops__Target_Stage_Id__c` | string | Create, Nillable | The ID of the target stage to which the changes were deployed. |
| `sf_devops__Work_Item_Id__c` | string | Create, Nillable | The ID of the work item that was deployed. This field is empty if a work item change bundle was deployed. |

---

## Work Item Commit (sf_devops__Work_Item_Commit__e)

Notifies subscribers whenever a commit occurs on a work item's feature branch. This object is available in API version 62.0 and later. The event isn't generated if a commit occurs on a feature branch after a work item has been promoted.

- **Supported Calls:** `create()`, `describeSObjects()`
- **Streaming API Subscription Channel:** `/event/sf_devops__Work_Item_Commit__e`
- **Event Delivery Allocation Enforced:** Yes
- **Special Access Rules:** DevOps Center package version 8.2 or later must be installed in the org.

### Fields

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| `EventUuid` | string | Nillable | The unique ID of the event, which is shared with the corresponding storage object. For example, `0a4779b0-0da1-4619-a373-0a36991dff90`. Use this field to correlate the event with its storage object. |
| `ReplayId` | string | Nillable | Represents an ID value that is populated by the system and refers to the position of the event in the event stream. Replay ID values aren't guaranteed to be contiguous for consecutive events. A subscriber can store a replay ID value and use it on resubscription to retrieve missed events that are within the retention window. |
| `sf_devops__Remote_Reference__c` | string | Create | The unique ID of the commit in the source control system. |
| `sf_devops__Work_Item_Id__c` | string | Create | The ID of the work item associated with the commit on the work item's feature branch. |

---

## Work Item Merged Change Request (sf_devops__Work_Item_Merged_Change_Request__e)

Notifies subscribers when a work item's metadata is merged into a pipeline stage's branch. This object is available in API version 62.0 and later.

- **Supported Calls:** `create()`, `describeSObjects()`
- **Streaming API Subscription Channel:** `/event/sf_devops__Work_Item_Merged_Change_Request__e`
- **Event Delivery Allocation Enforced:** Yes
- **Special Access Rules:** DevOps Center package version 8.2 or later must be installed in the org.

### Fields

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| `EventUuid` | string | Nillable | The unique ID of the event, which is shared with the corresponding storage object. For example, `0a4779b0-0da1-4619-a373-0a36991dff90`. Use this field to correlate the event with its storage object. |
| `ReplayId` | string | Nillable | Represents an ID value that is populated by the system and refers to the position of the event in the event stream. Replay ID values aren't guaranteed to be contiguous for consecutive events. A subscriber can store a replay ID value and use it on resubscription to retrieve missed events that are within the retention window. |
| `sf_devops__Remote_Reference__c` | string | Create, Nillable | The unique ID of the change request in the source control system. |
| `sf_devops__Source_Stage_Id__c` | string | Create, Nillable | The ID of the source pipeline stage if the changes were merged from a pipeline stage to the next pipeline stage. Not applicable if the changes were merged from a work item's feature branch. |
| `sf_devops__Target_Stage_Id__c` | string | Create, Nillable | The ID for the target pipeline stage. |
| `sf_devops__Work_Item_Id__c` | string | Create, Nillable | The ID of the work item that contained the changes that were merged. |

---

## Work Item Open Change Request (sf_devops__Work_Item_Open_Change_Request__e)

Notifies subscribers whenever a change request (pull request) is opened for a work item. This object is available in API version 62.0 and later.

This event occurs whether the change request was initiated in DevOps Center or directly in the source control system. For changes made in feature branches, the change request is associated with the first pipeline stage. After a promotion to a pipeline stage, the event is generated for the next pipeline stage. This event is generated after a promotion as well as when a change request is opened for the next pipeline stage.

- **Supported Calls:** `create()`, `describeSObjects()`
- **Streaming API Subscription Channel:** `/event/sf_devops__Work_Item_Open_Change_Request__e`
- **Event Delivery Allocation Enforced:** Yes
- **Special Access Rules:** DevOps Center package version 8.2 or later must be installed in the org.

### Fields

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| `EventUuid` | string | Nillable | The unique ID of the event, which is shared with the corresponding storage object. For example, `0a4779b0-0da1-4619-a373-0a36991dff90`. Use this field to correlate the event with its storage object. |
| `ReplayId` | string | Nillable | Represents an ID value that is populated by the system and refers to the position of the event in the event stream. Replay ID values aren't guaranteed to be contiguous for consecutive events. A subscriber can store a replay ID value and use it on resubscription to retrieve missed events that are within the retention window. |
| `sf_devops__Remote_Reference__c` | string | Create, Nillable | The unique ID of the change request in the source control system. |
| `sf_devops__Target_Stage_Id__c` | string | Create, Nillable | The ID of the pipeline stage where the change request will be merged. |
| `sf_devops__Work_Item_Id__c` | string | Create, Nillable | The ID of the work item associated with the newly created change request. |

---

## Work Item State Change (sf_devops__Work_Item_State_Change__e)

Notifies subscribers when the `State__c` field of a work item changes. This object is available in API version 62.0 and later.

This event is empty if the current state is New. In some cases, a work item can revert to a previous state, for example, if it's not approved for promotion.

- **Supported Calls:** `create()`, `describeSObjects()`
- **Streaming API Subscription Channel:** `/event/sf_devops__Work_Item_State_Change__e`
- **Event Delivery Allocation Enforced:** Yes
- **Special Access Rules:** DevOps Center package version 8.2 or later must be installed in the org.

### Fields

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| `EventUuid` | string | Nillable | The unique ID of the event, which is shared with the corresponding storage object. For example, `0a4779b0-0da1-4619-a373-0a36991dff90`. Use this field to correlate the event with its storage object. |
| `ReplayId` | string | Nillable | Represents an ID value that is populated by the system and refers to the position of the event in the event stream. Replay ID values aren't guaranteed to be contiguous for consecutive events. A subscriber can store a replay ID value and use it on resubscription to retrieve missed events that are within the retention window. |
| `sf_devops__New_State__c` | string | Create | The current state of the work item. |
| `sf_devops__Previous_State__c` | string | Create, Nillable | The previous state of the work item. |
| `sf_devops__Work_Item_Id__c` | string | Create | The ID of the work item that changed state. |

---

## 구독 예시 (Apex Trigger)

```apex
// 구조 예시 — 실제 동작 코드 아님
trigger WorkItemStateChangeTrigger on sf_devops__Work_Item_State_Change__e (after insert) {
    for (sf_devops__Work_Item_State_Change__e evt : Trigger.New) {
        System.debug('Work Item ' + evt.sf_devops__Work_Item_Id__c
            + ' : ' + evt.sf_devops__Previous_State__c
            + ' -> ' + evt.sf_devops__New_State__c);
    }
}
```

---

## 관련 노트
- [[DevOps Center 데이터 모델 개요]]
- [[DevOps Center 객체 — 파이프라인·프로젝트·환경]]
- [[DevOps Center 객체 — Work Item·프로모션]]
- [[DevOps Center 객체 — 비동기·결과]]
- [[DevOps Center 객체 — 변경 추적]]
