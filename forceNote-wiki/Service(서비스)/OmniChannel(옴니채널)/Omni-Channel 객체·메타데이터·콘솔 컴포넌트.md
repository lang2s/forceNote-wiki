---
tags: [service, service-cloud, omni-channel, console, lightning-console-js-api, console-integration-toolkit, metadata-api, capacity, EOL]
source: service_presence_developer_guide.pdf (Omni-Channel Developer Guide, v67.0 Summer '26, Tier 2) + service_presence_administrators.pdf (Omni-Channel for Administrators, Spring '26, Tier 2 — Capacity 모델 섹션)
official_doc: https://developer.salesforce.com/docs/atlas.en-us.service_presence_developer_guide.meta/service_presence_developer_guide/
created: 2026-06-20
aliases: [Omni-Channel, Omni-Channel Objects, AgentWork, ServiceChannel, UserServicePresence, PendingServiceRouting, PresenceUserConfig, Omni-Channel Metadata API, Lightning Console JS API Omni, Console Integration Toolkit Omni, Capacity Weight, Capacity Percentage, Interruptible Capacity, Capacity Model, 옴니채널, 옴니채널 객체, 콘솔 메서드, 콘솔 이벤트, 에이전트 용량, 동시 작업 수]
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

이에 더해 아래 **Capacity 모델** 섹션은 별도 소스인 *Omni-Channel for Administrators*(`service_presence_administrators.pdf`, Spring '26)에서 발췌해, capacity 계산·설정 방법을 다룬다.

---

## Capacity 모델 — 에이전트 용량 계산과 설정

> 출처: `service_presence_administrators.pdf` (Omni-Channel for Administrators, Spring '26, Tier 2)

### 계산 구조 한눈에

capacity 계산은 두 값의 조합이다. **에이전트의 총 capacity**(Presence Configuration에서 설정) − **work item별 크기**(Routing Configuration의 Capacity Weight 또는 Capacity Percentage) = 남은 capacity. 에이전트에게 큐의 work item이 할당될 때마다 그 크기만큼 총 capacity에서 차감되고, 남은 capacity가 work item 크기 이상인 에이전트에게만 새 작업이 라우팅된다.

> PDF 원문: *"The Capacity setting in the presence configuration that the agent is assigned to determines the agent's overall capacity. As agents are assigned work items from the queue, the capacity weight or percentage is deducted from the agent's overall capacity as long as they have enough capacity to cover the assigned work items."*

에이전트의 **현재** capacity는 `UserServicePresence` 객체가 추적한다.

### 1) 에이전트 총 capacity — Presence Configuration (객체: `PresenceUserConfig`)

**Setup → Quick Find에 "Presence" 입력 → Presence Configurations**에서 설정한다. Omni-Channel을 활성화하면 **Default Presence Configuration**이 자동 생성되어 모든 에이전트가 자동 할당되며, 커스텀 configuration을 만들어 일부 에이전트를 재할당하면 Default에서 제외된다.

| 설정 | 역할 (PDF Presence Configuration Settings 표) |
|---|---|
| **Capacity** | 에이전트의 최대 work capacity. Routing Configuration에서 지정한 work item 크기가 이 capacity를 소비한다. |
| **Interruptible Capacity** | 에이전트가 동시에 처리할 수 있는 interruptible work의 최대량. **비워두면 Primary Capacity(= Capacity) 값과 동일하게 기본 설정**된다. |

### 2) work item 크기 — Routing Configuration의 Capacity Weight vs Capacity Percentage (객체: `QueueRoutingConfig`)

**Setup → Omni-Channel Routing Configurations**에서 work item 크기를 지정한다. **work unit 수(Capacity Weight) 또는 에이전트 capacity의 percentage(Capacity Percentage) 중 하나만** 쓴다(둘 다 지정 불가).

| 설정 | 의미 |
|---|---|
| Units of Capacity for In-Progress Work Items | in-progress work item 1건이 소비하는 에이전트 총 capacity의 **unit 수** |
| Percentage of Capacity for In-Progress Work Items | in-progress work item 1건이 소비하는 에이전트 총 capacity의 **percentage** |
| Units / Percentage of Capacity for **Paused** Work Items | paused work item의 크기. **기본 소비 0**(pause하면 새 작업을 받을 수 있음). Paused status는 Enhanced Omni-Channel 활성화 시에만 제공 |

- **계산 예시 (PDF 원문 예)**: 에이전트 capacity가 **6 work units**이고 모든 case의 capacity weight가 **2**이면 → 에이전트는 **최대 3개 case**를 동시에 처리할 수 있다. percentage 방식 예: voice call은 에이전트 capacity의 **100%**를 소비.
- 라우팅 결정 시 Omni-Channel은 available primary/interruptible capacity를 **percentage로 검사**한다 — work unit으로 지정했으면 내부적으로 percentage로 변환해 판단한다.
- ⚠️ **Important (PDF)**: work item 크기는 primary·interruptible capacity 값보다 **작게** 설정해야 한다. 그렇지 않으면 그 work item은 **영원히 라우팅되지 않는다**.
- **Apex로도 설정 가능**: `CapacityWeight` 또는 `CapacityPercentage` 필드를 **PendingServiceRouting · AgentWork · ServiceChannel · QueueRoutingConfig** 레코드에 명시적으로 설정한다. (External Routing 흐름에서의 실사용 코드는 [[Omni-Channel External Routing]] 참조)

```apex
// 구조 예시 — 실제 동작 코드 아님 (PDF는 필드명만 제시: CapacityWeight·CapacityPercentage·IsInterruptible)
PendingServiceRouting psr = new PendingServiceRouting();
psr.CapacityWeight = 2;        // work unit 방식 — CapacityPercentage와 동시 사용 불가
psr.IsInterruptible = true;    // 이 work item을 interruptible로 지정
```

### 3) Primary vs Interruptible capacity

- **Primary(= uninterruptible) work**: 중단하면 안 되는 작업 — voice call·chat이 대표 예. `LiveChatTranscript` 레코드는 **항상 uninterruptible이며 primary capacity를 사용**한다.
- **Interruptible work**: 더 급한 작업을 위해 잠시 미뤄둘 수 있는 작업 — 해결에 오래 걸리는 case가 예.
- work item의 interruptible 여부는 **PendingServiceRouting 또는 AgentWork 레코드의 `IsInterruptible` 필드**가 결정하며, 3곳에서 설정할 수 있다:
  1. **Service Channel** 설정의 Is Interruptible 체크박스
  2. **Routing Configuration**의 **Capacity Type** — `interruptible` / `primary` / 서비스 채널에서 상속(inherited) 중 선택
  3. **Apex** — PendingServiceRouting/AgentWork 레코드에 `IsInterruptible` 명시 설정

**라우팅 규칙 (PDF 표 그대로):**

| work이 … 이면 | Omni-Channel 규칙 |
|---|---|
| **Primary (Uninterruptible)** | 에이전트에게 **available primary capacity가 있을 때만** 할당. 이때 에이전트에게 할당된 interruptible work은 **고려하지 않는다**. |
| **Interruptible** | **primary와 interruptible capacity가 둘 다 충분한** 에이전트만 고려. (전화 등 primary work으로 바쁜 에이전트에게 손대지 못할 interruptible work을 쌓지 않기 위해) |

**PDF 예시**: 에이전트가 voice call 1건 + case 4건을 동시 처리할 수 있다면(각 work item = 1 unit 가정) → primary capacity = 1, interruptible capacity = 4로 설정하고, 서비스 채널에서 voice = uninterruptible, case = interruptible로 지정한다. case 4건이 할당돼 interruptible이 가득 차도, primary capacity가 남아 있으므로 voice call은 즉시 할당된다.

**PDF 예시 2** (primary 5·interruptible 5, lead = uninterruptible·case = interruptible): case 5건 작업 중인 에이전트(interruptible 소진)에게도 lead는 할당된다(primary 여유). 반대로 lead 5건 작업 중인 에이전트(primary 소진)에게는 case가 할당되지 않는다 — interruptible work은 **양쪽** capacity가 모두 필요하기 때문.

에이전트별 primary·interruptible capacity 현황은 Omni Supervisor의 **Agents 탭**에서 확인한다.

### 4) capacity 판정 방식 2종 — Tab-Based vs Status-Based

| 모델 | capacity 판정 기준 | 해제 시점 |
|---|---|---|
| **Tab-Based** | 에이전트 Omni-Channel 세션에 열려 있는 **콘솔 tab 수** | tab을 닫으면 close로 간주. 로그아웃하면 할당된 모든 work이 closed 처리되어 capacity 리셋. standard navigation 앱 미지원 |
| **Status-Based** | 할당된 work item의 **status** | tab을 닫거나 로그아웃해도 work이 completed status가 될 때까지 capacity 유지. pause 가능(Enhanced Omni-Channel). **Voice 미지원** |

- Status-Based 활성화: **Setup → Omni-Channel Settings → Enable Status-Based Capacity Model** 체크 → 각 **Service Channel**에서 Status-Based 모델 선택 + status 추적용 picklist 필드와 completed/paused/in-progress 값 매핑.
- 상한: 에이전트는 동시에 **최대 100개 work item**을 가질 수 있다(tab-based는 tab 100개, status-based는 paused+in-progress 포함). Omni-Channel 컴포넌트에는 처음 20개만 표시된다.

### 5) capacity 기반 라우팅 모델 (Least Active vs Most Available)

Routing Configuration의 라우팅 모델 옵션 중 **Least Active**는 사용 중(used) capacity가 가장 적은 에이전트에게, **Most Available**은 남은(available) capacity가 가장 큰 에이전트에게 라우팅한다(동률이면 가장 오래 작업을 못 받은 에이전트). PDF 예: A(총 5, 사용 3)·B(총 10, 사용 5)일 때 — Least Active는 사용량이 적은 **A**(3<5), Most Available은 여유가 큰 **B**(10−5=5 > 5−3=2)를 선택한다.

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
- [[Omni-Channel 라우팅 유형 — Queue 기반 vs Skills 기반]] — QueueRoutingConfig·SkillRequirement 등 객체의 라우팅 개념·설정·선택 기준
- [[Lightning Console JS API]]
- [[Service Cloud Objects]]
- [[Tooling API 객체 — Service·OmniChannel (라우팅·대화채널·서비스카탈로그·스케줄링)]] — Omni-Channel 설정 sObject의 Tooling API facet (ServiceChannel·QueueRoutingConfig·ServicePresenceStatus 등)
- [[Case Assignment & Escalation Rules (케이스 배정·에스컬레이션 규칙)]] — Assignment Rule → Omni 큐 실행 순서·조합 패턴
