---
tags: [service, service-cloud, omni-channel, console, lightning-console-js-api, console-integration-toolkit, metadata-api, EOL]
source: service_presence_developer_guide.pdf (Omni-Channel Developer Guide, v67.0 Summer '26, Tier 2)
official_doc: https://developer.salesforce.com/docs/atlas.en-us.service_presence_developer_guide.meta/service_presence_developer_guide/
created: 2026-06-20
aliases: [Omni-Channel, Omni-Channel Objects, AgentWork, ServiceChannel, UserServicePresence, PendingServiceRouting, PresenceUserConfig, Omni-Channel Metadata API, Lightning Console JS API Omni, Console Integration Toolkit Omni, 옴니채널, 옴니채널 객체, 콘솔 메서드, 콘솔 이벤트]
---

# Omni-Channel 객체·메타데이터·콘솔 컴포넌트

> Standard Omni-Channel의 API 객체(24)·Metadata API 타입(11)·Salesforce 콘솔 통합 컴포넌트(Lightning Console JS API + Classic Console Integration Toolkit) 레퍼런스. (`service_presence_developer_guide.pdf` = Omni-Channel Developer Guide v67.0)

> [!warning] **Standard Omni-Channel은 Summer '26(v67.0)으로 EOL(End of Life)에 도달했습니다.** 지속 지원·최신 기능을 위해 **Enhanced Omni-Channel** 마이그레이션이 권고됩니다. 이 노트의 객체·메타데이터·콘솔 API는 모두 Standard Omni-Channel 기준입니다. (출처: Omni-Channel Developer Guide Ch.1 "Important" 고지)

> 📂 형제 노트: [[Omni-Channel External Routing]] (서드파티 라우팅 통합)

---

## 개요

Omni-Channel은 정의된 라우팅 로직에 따라 work item을 큐·에이전트·스킬, 그리고 (지원 채널에서는) Einstein Bots로 라우팅한다. work item의 우선순위와 에이전트의 capacity(동시에 처리 가능한 작업 수)를 관리하고, 어떤 에이전트가 어떤 유형의 작업을 처리할지 정의할 수 있다.

> 라우팅 로직은 work가 owner에게 할당될 때 적용된다. work item이 라우팅된 **후** 필드 값이 변경되어도 라우팅 로직은 재적용되지 않는다.

이 노트는 Omni-Channel Developer Guide(단일 챕터 가이드)의 다음 영역을 다룬다.

- **Omni-Channel API 객체** — 레코드를 생성/조회/수정/삭제하는 데이터 모델 객체 (24)
- **Omni-Channel Metadata API 타입** — 기능 설정·메타데이터 접근용 (11)
- **콘솔 통합 컴포넌트** — Lightning Experience(Lightning Console JS API)와 Salesforce Classic(Console Integration Toolkit)에서 Omni-Channel을 제어하는 메서드·이벤트

> 외부 라우팅(서드파티 라우팅 통합, External Routing)은 [[Omni-Channel External Routing]] 노트에서 다룬다.

---

## Omni-Channel API 객체 (24)

> API를 사용해 account·lead·custom object 등 레코드를 생성/조회/수정/삭제한다. Salesforce 데이터 모델에는 Omni-Channel 사용자·라우팅 구성·상태 등 Omni-Channel 레코드를 제어·커스터마이즈하는 객체가 여러 개 포함된다. (PDF: "see *Which API Do I Use?* in Salesforce Help")

PDF가 나열한 순서 그대로의 객체 목록(24개)이다.

1. `AgentWork`
2. `AgentWorkSkill`
3. `OmniSupervisorConfig`
4. `OmniSupervisorConfigAction`
5. `OmniSupervisorConfigGroup`
6. `OmniSupervisorConfigProfile`
7. `OmniSupervisorConfigQueue`
8. `OmniSupervisorConfigSkill`
9. `OmniSupervisorConfigTab`
10. `OmniSupervisorConfigUser`
11. `PendingServiceRouting`
12. `PresenceConfigDeclineReason`
13. `PresenceDeclineReason`
14. `PresenceUserConfig`
15. `PresenceUserConfigUser`
16. `QueueRoutingConfig`
17. `QueueSobject`
18. `ServiceChannel`
19. `ServiceChannelFieldPriority`
20. `ServiceChannelStatus`
21. `ServicePresenceStatus`
22. `ServiceResource`
23. `SkillRequirement`
24. `UserServicePresence`

> ⚠️ **필드 스키마는 이 PDF에 정의되어 있지 않다.** PDF는 객체를 bullet 목록으로만 제시하고 각 객체의 필드·상세 스키마는 외부(*Which API Do I Use?* / Object Reference)로 위임한다. 필드 상세가 필요하면 [[Service Cloud Objects]]를 참조한다. (일부 객체 — `AgentWork`·`PendingServiceRouting`·`UserServicePresence` — 의 실사용 필드는 외부 라우팅 흐름에서 등장하며 [[Omni-Channel External Routing]]에서 다룬다.)

---

## Omni-Channel Metadata API 타입 (11)

> Metadata API는 Omni-Channel 기능 설정과 메타데이터 정보에 접근하게 해준다. 아래 타입들이 Metadata API로 제공된다. (PDF: "see the *Metadata API Developer Guide*")

PDF 순서 그대로의 타입 목록(11개)이다.

1. `Flow`
2. `OmniChannelSettings`
3. `OmniSupervisorConfig`
4. `PresenceDeclineReason`
5. `PresenceUserConfig`
6. `Queue`
7. `QueueRoutingConfig`
8. `ServiceChannel`
9. `ServicePresenceStatus`
10. `WorkSkillRouting`
11. `WorkSkillRoutingAttribute`

> ⚠️ PDF는 타입 이름만 나열한다. 각 메타데이터 타입의 필드·속성은 이 PDF에 정의되어 있지 않으며 *Metadata API Developer Guide*로 외부 위임한다.

---

## 콘솔 컴포넌트 — Lightning Experience (Lightning Console JS API)

> Lightning Experience용 Lightning Console JavaScript API는 조직의 Lightning Service Console 안에서 Omni-Channel 동작을 제어하는 메서드·이벤트를 포함한다. (PDF: "see *Lightning Console JavaScript API*")

이 절의 메서드·이벤트는 **Omni-Channel 전용**이다. tab 열기·닫기 등 일반 콘솔 메서드는 [[Lightning Console JS API]] 노트를 참조한다.

### 메서드 (12)

Lightning Experience용 Lightning Console JS API의 Omni-Channel 메서드. 모두 `for Lightning Experience` 접미가 붙는다(PDF 표기 보존).

1. `acceptAgentWork` for Lightning Experience
2. `closeAgentWork` for Lightning Experience
3. `declineAgentWork` for Lightning Experience
4. `getAgentWorkload` for Lightning Experience
5. `getAgentWorks` for Lightning Experience
6. `getServicePresenceStatusChannels` for Lightning Experience
7. `getServicePresenceStatusId` for Lightning Experience
8. `login` for Lightning Experience
9. `logout` for Lightning Experience
10. `lowerAgentWorkFlag` for Lightning Experience
11. `raiseAgentWorkFlag` for Lightning Experience
12. `setServicePresenceStatus` for Lightning Experience

> ⚠️ PDF는 메서드명만 나열한다(시그니처·파라미터·반환 타입 미제공). 상세 시그니처는 이 PDF에 없으며 *Lightning Console JavaScript API*로 외부 위임한다. `lowerAgentWorkFlag`·`raiseAgentWorkFlag` 2개는 **Lightning Experience 전용**으로, 아래 Classic 메서드 목록에는 존재하지 않는다.

### 이벤트 (10)

Lightning Console JS API의 Omni-Channel 이벤트. JavaScript는 콘솔에서 특정 이벤트(예: 사용자가 tab을 닫을 때)가 발생할 때 실행될 수 있다. 아래 이벤트는 **Lightning Experience에만 적용된다.**

1. `lightning:omniChannelConnectionError`
2. `lightning:omniChannelLoginSuccess`
3. `lightning:omniChannelStatusChanged`
4. `lightning:omniChannelLogout`
5. `lightning:omniChannelWorkAssigned`
6. `lightning:omniChannelWorkAccepted`
7. `lightning:omniChannelWorkDeclined`
8. `lightning:omniChannelWorkClosed`
9. `lightning:omniChannelWorkFlagUpdated`
10. `lightning:omniChannelWorkloadChanged`

---

## 콘솔 컴포넌트 — Salesforce Classic (Console Integration Toolkit)

> Salesforce Console Integration Toolkit은 조직의 Salesforce 콘솔 안에서 Omni-Channel 동작을 제어하는 객체들을 포함한다. 조직이 Salesforce Classic을 사용한다면 Console Integration Toolkit 메서드를 쓴다. (PDF: "see *Salesforce Console Integration Toolkit for Salesforce Classic*")

### 메서드 (10)

Salesforce Classic의 Omni-Channel용 Console Integration Toolkit API 메서드(10개)이다. Lightning 버전과 메서드명은 거의 동일하나 `for Lightning Experience` 접미가 없다.

1. `acceptAgentWork`
2. `closeAgentWork`
3. `declineAgentWork`
4. `getAgentWorks`
5. `getAgentWorkload`
6. `getServicePresenceStatusChannels`
7. `getServicePresenceStatusId`
8. `login`
9. `logout`
10. `setServicePresenceStatus`

> ⚠️ Classic 목록에는 `lowerAgentWorkFlag`·`raiseAgentWorkFlag`가 **없다** (이 2개는 Lightning Experience 전용). PDF는 시그니처·파라미터·반환 타입을 제공하지 않는다. (+ 하위 절 "Methods for Omni-Channel Console Events" 링크 존재 — 아래 콘솔 이벤트 표 참조.)

콘솔 이벤트는 일반(Standard) 콘솔 이벤트와 Omni-Channel 전용 이벤트로 나뉜다. 일반 콘솔 메서드는 [[Lightning Console JS API]]가 아닌 *Salesforce Console Integration Toolkit*(Classic) 소관이며, 아래 표의 이벤트는 **Salesforce Classic에만 적용된다.**

### Standard Console Events 표 (3행)

| Event | Description | Payload |
|---|---|---|
| `sforce.console.ConsoleEvent.OPEN_TAB` | Fired when a primary tab or subtab is opened. Available in API version 30.0 or later. | • `id`—the ID of the opened tab<br>• `objectId`—the object ID of the opened tab, if available |
| `sforce.console.ConsoleEvent.CLOSE_TAB` | Fired when a primary tab or subtab with a specified ID in the additionalParams argument is closed. Or, fired when a primary tab or subtab with no specified ID is closed. Available in API version 30.0 or later. | • `id`—the ID of the closed tab<br>• `objectID`—the object ID of the closed tab, if available |
| `sforce.console.ConsoleEvent.CONSOLE_LOGOUT` | Delays the execution of logging out of a console when a user clicks Logout. When Logout is clicked: 1. An overlay appears, which tells a user that logout is in progress. 2. Callbacks are executed that have been registered by using `sforce.console.ConsoleEvent.CONSOLE_LOGOUT`. 3. Console logout logic is executed. If the callback contains synchronous blocking code, the console logout code isn't executed until the blocking code is executed. As a best practice, avoid synchronous blocking code or long code execution during logout. Available in API version 31.0 or later. | None |

### Omni-Channel Console Events 표 (7행)

| Event | Description | Payload |
|---|---|---|
| `sforce.console.ConsoleEvent.PRESENCE.LOGIN_SUCCESS` | Fired when an Omni-Channel user logs into Omni-Channel successfully. Available in API version 32.0 or later. | • `statusId`—the ID of the agent's current presence status. |
| `sforce.console.ConsoleEvent.PRESENCE.STATUS_CHANGED` | Fired when a user changes his or her presence status. Available in API version 32.0 or later. | • `statusId`—the ID of the agent's current presence status.<br>• `channels`—channelJSON string of channel objects.<br>• `statusName`—the name of the agent's current presence status.<br>• `statusApiName`—the API name of the agent's current presence status. |
| `sforce.console.ConsoleEvent.PRESENCE.LOGOUT` | Fired when a user logs out of Salesforce. Available in API version 32.0 or later. | None |
| `sforce.console.ConsoleEvent.PRESENCE.WORK_ASSIGNED` | Fired when a user is assigned a new work item. Available in API version 32.0 or later. | • `workItemId`—the ID of the object that's routed through Omni-Channel. This object becomes a work assignment with a workId when it's assigned to an agent.<br>• `workId`—the ID of a work assignment that's routed to an agent. |
| `sforce.console.ConsoleEvent.PRESENCE.WORK_ACCEPTED` | Fired when a user accepts a work assignment, or when a work assignment is automatically accepted. Available in API version 32.0 or later. | • `workItemId`—the ID of the object that's routed through Omni-Channel. This object becomes a work assignment with a workId when it's assigned to an agent.<br>• `workId`—the ID of a work assignment that's routed to an agent. |
| `sforce.console.ConsoleEvent.PRESENCE.WORK_DECLINED` | Fired when a user declines a work assignment. Available in API version 32.0 or later. | • `workItemId`—the ID of the object that's routed through Omni-Channel. This object becomes a work assignment with a workId when it's assigned to an agent.<br>• `workId`—the ID of a work assignment that's routed to an agent. |
| `sforce.console.ConsoleEvent.PRESENCE.WORK_CLOSED` | Fired when the status of an AgentWork object is changed to Closed. Available in API version 32.0 or later. | • `workItemId`—the ID of the object that's routed through Omni-Channel. This object becomes a work assignment with a workId when it's assigned to an agent.<br>• `workId`—the ID of a work assignment that's routed to an agent. |
| `sforce.console.ConsoleEvent.PRESENCE.WORKLOAD_CHANGED` | Fired when an agent's workload changes. This includes receiving new work items, declining work items, and closing items in the console. It's also fired when there's a change to an agent's capacity or Presence Configuration or when the agent goes offline in the Omni-Channel widget. | • `ConfiguredCapacity`—the configured capacity for the agent.<br>• `PreviousWorkload`—the agent's workload before the change.<br>• `NewWorkload`—the agent's new workload after the change. |

### channel object 프로퍼티 표 (2행)

`STATUS_CHANGED` 이벤트의 `channels` payload는 channel object의 JSON 문자열이다. channel object는 다음 프로퍼티를 포함한다.

| Name | Type | Description |
|---|---|---|
| `channelId` | String | Retrieves the ID of a service channel that's associated with a presence status. |
| `developerName` | String | Retrieves the developer name of the the service channel that's associated with the channelId.<sup>※</sup> |

> <sup>※</sup> PDF 원문 표기를 그대로 보존한 것으로, "the the service channel"은 **PDF 원본의 오타**다(중복된 "the").

### Methods for Console Events 표 (3행)

위 콘솔 이벤트들은 `addEventListener()`로 리스너를 등록해 구독한다(`fireEvent()`로 발생, `removeEventListener()`로 해제).

| Method | Description |
|---|---|
| `addEventListener()` | Adds a listener for a custom event type or a standard event type when the event is fired. This method adds a listener for custom event types in API version 25.0 or later; it adds a listener for standard event types in API version 30.0 or later. |
| `fireEvent()` | Fires a custom event. This method is only available in API version 25.0 or later. |
| `removeEventListener()` | Removes a listener for a custom event type or a standard event type. This method removes a listener for custom event types in API version 25.0 or later; it removes a listener for standard event types in API version 30.0 or later. |

```javascript
// 구조 예시 — 실제 동작 코드 아님 (PDF는 메서드명·이벤트명만 제공, 시그니처·인자 미정의)
// Salesforce Classic Console Integration Toolkit에서 Omni-Channel 콘솔 이벤트를 구독하는 형태
sforce.console.addEventListener(
  sforce.console.ConsoleEvent.PRESENCE.WORK_ASSIGNED,
  function (result) {
    // result.payload 에 workItemId, workId 등 (위 'Omni-Channel Console Events 표' 참조)
  }
);
```

---

## 관련 노트
- [[Omni-Channel External Routing]]
- [[Lightning Console JS API]]
- [[Service Cloud Objects]]
