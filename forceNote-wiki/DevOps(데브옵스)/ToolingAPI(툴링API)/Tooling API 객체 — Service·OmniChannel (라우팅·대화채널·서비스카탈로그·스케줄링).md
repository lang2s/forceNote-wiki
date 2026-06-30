---
tags: [tooling-api, devops, omni-channel, routing, presence, service-channel, conversation, messaging, service-catalog, scheduling, workforce-engagement, virtual-visit]
source: api_tooling.pdf v67.0 (Summer '26)
created: 2026-06-29
aliases: [ServiceChannel, ServicePresenceStatus, PresenceDeclineReason, PresenceUserConfig, QueueRoutingConfig, OmniSupervisorConfig, Skill, WorkSkillRouting, WorkSkillRoutingAttribute, ConversationChannelDefinition, ConversationVendorInfo, ContactCenterChannel, CustomMsgChannel, ExtConvParticipantIntegDef, EngagementInsightType, SvcCatalogItemDef, SvcCatalogCategory, SvcCatalogCategoryItem, SvcCatalogFulfillmentFlow, SvcCatalogFulfillFlowItem, SchedulingObjective, SchedulingRule, ShiftSegmentType, TimeSheetTemplateAssignment, VirtualVisitConfig, 옴니채널, 프레즌스, 라우팅, 서비스 채널, 큐 라우팅, 스킬 라우팅, 대화 채널, 메시징 채널, 벤더 정보, 서비스 카탈로그, 스케줄링, 스케줄링 규칙, 워크포스 인게이지먼트, 시프트 세그먼트, 가상 방문, Omni-Channel을 Tooling API로 설정, 서비스 채널 라우팅 모델 enum, 큐 라우팅 구성, 대화 채널 정의 객체, 서비스 카탈로그 항목 Tooling, 스케줄링 규칙 타입, 가상 방문 AWS 리전, Tooling API로 프레즌스 상태 만들기]
---

# Tooling API 객체 — Service·OmniChannel (라우팅·대화채널·서비스카탈로그·스케줄링)

> Omni-Channel 라우팅·프레즌스·스킬, 대화/메시징 채널, 서비스 카탈로그, 스케줄링·워크포스, 가상 방문을 다루는 Tooling sObject 25종 전수 — ServiceChannel·QueueRoutingConfig로 라우팅을, ServicePresenceStatus·PresenceUserConfig로 상담원 프레즌스를, Skill·WorkSkillRouting으로 스킬 기반 라우팅을, ConversationChannelDefinition·ConversationVendorInfo로 메시징 채널을, SvcCatalog* 5종으로 셀프서비스 카탈로그를, Scheduling* + VirtualVisitConfig로 워크포스·가상진료를 SOQL 조회 / create·update로 운영한다.

---

## 개요

이 노트는 Tooling API Reference v67.0(Summer '26)의 **Service Cloud / Omni-Channel 도메인 setup sObject 25종**을 전수 정리한다. 하위 도메인 5개로 묶었다.

| # | 하위 도메인 | 객체 수 | 핵심 객체 |
|---|---|---|---|
| 1 | Omni-Channel 라우팅·프레즌스·스킬 | 9 | ServiceChannel, QueueRoutingConfig, PresenceUserConfig |
| 2 | 대화·메시징 채널 | 6 | ConversationChannelDefinition, ConversationVendorInfo |
| 3 | 서비스 카탈로그 | 5 | SvcCatalogItemDef, SvcCatalogCategory |
| 4 | 스케줄링·워크포스 | 4 | SchedulingObjective, SchedulingRule, ShiftSegmentType |
| 5 | 가상 방문 | 1 | VirtualVisitConfig |

> **배열 방식:** 원본 PDF는 이 25객체를 전 챕터에 **알파벳순으로 산재**(물리 224~959p) 배치한다. 본 노트는 독자의 탐색 경로에 맞춰 **하위 도메인 5그룹**으로 재구성하고, 각 그룹 내부는 **필드 수 내림차순**으로 정렬했다.
>
> **경계:** 임베디드 챗·채널 메뉴·약속 위젯(스냅인 배포) sObject는 형제 노트 [[Tooling API 객체 — Embedded Service (임베디드 챗·채널 메뉴·약속관리)]] 소관이다. 본 노트는 라우팅·채널·카탈로그·스케줄링 **운영** 도메인만 다룬다. Omni-Channel·Scheduler의 **메타데이터/표준객체 facet**은 [[Omni-Channel 객체·메타데이터·콘솔 컴포넌트]] / [[Salesforce Scheduler 표준객체 — 리소스·영역·스킬·시프트]]를 참조한다(아래 BOUNDARY 참고).

각 객체는 setup sObject이므로 SOQL 조회는 Tooling API 엔드포인트를 통해야 한다.

```sql
-- 구조 예시 — 실제 동작 코드 아님 (Tooling API SOQL: Developer Console에서 "Use Tooling API" 체크 또는 /tooling/query)
SELECT Id, DeveloperName, MasterLabel, RelatedEntity, CapacityModel
FROM ServiceChannel
WHERE RelatedEntity = 'Case'

-- create/update 예: Tooling REST
-- POST /services/data/v67.0/tooling/sobjects/QueueRoutingConfig
-- { "DeveloperName": "...", "MasterLabel": "...", "RoutingModel": "MostAvailable" }
```

> **표기 규약:** 여러 객체에 동일 boilerplate로 반복되는 `NamespacePrefix`·`ManageableState`·`FullName`/`Metadata`의 전체 정의·enum 값은 문서 하단 [공통 블록](#공통-블록)에 1회 전수 정의하고, 각 객체 표에서는 행만 두고 "(공통 블록)"으로 참조한다. **단 `Language` 피클리스트는 객체별로 값/표기가 달라 합치지 않고 각 객체에 개별 기재한다.**

---

## 1. Omni-Channel 라우팅·프레즌스·스킬 (9객체)

### ServiceChannel (14필드)

고객으로부터 수신되는 work item의 채널을 나타낸다. API 65.0+. (Omni-Channel 활성 필요)

- **Supported SOAP API Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| AcwExtensionDuration | int | Create, Filter, Group, Nillable, Sort, Update | 상담원이 타이머를 연장할 때마다 After Conversation Work(ACW)에 쓸 수 있는 최대 시간(초). `HasAcwExtensionEnabled=true`이면 설정 필요. **10~3600** 지정. service channel type이 Messaging/Voice일 때만 사용 가능. |
| AfterConvoWorkMaxTime | int | Create, Filter, Group, Nillable, Sort, Update | 상담원이 ACW를 완료할 최대 시간(초). `HasAfterConvoWorkTimer=true`이면 설정 필요. **10~3600** 지정. Messaging/Voice 채널만. |
| CapacityModel | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | 상담원 capacity가 해제되는 시점 결정. Status-Based는 work 완료/재배정까지 유지, tab-based는 콘솔 work tab을 닫으면 해제. 값: `StatusBased`, `TabBased` |
| DeveloperName | string | Create, Filter, Group, Sort, Update | API 내 고유 이름. |
| DoesCheckCapOnOwnerChange | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | capacity check override on(true)/off(false). Status-Based 모델에서 work가 상담원에게 재배정될 때 capacity check를 override하고 특정 상담원에게 유지할지. API 65.0+. 기본 false. |
| DoesCheckCapOnStatusChange | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | capacity check override on(true)/off(false). Status-Based 모델에서 work가 재오픈될 때 override해 특정 상담원에게 유지할지. API 65.0+. 기본 false. |
| DoesMinimizeWidgetOnAccept | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | 상담원이 work를 수락하면 Omni-Channel 위젯을 자동 최소화(true)할지. 기본 false. |
| HasAcwExtensionEnabled | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | 상담원이 ACW를 연장할 수 있는지(true). `HasAfterConvoWorkTimer=true`일 때만. true면 `AcwExtensionDuration`·`MaxExtensions`도 설정 필요. Messaging/Voice 채널만. 기본 false. |
| HasAfterConvoWorkTimer | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | 채널에 ACW 시간 구성 가능 여부(true). true면 `AfterConvoWorkMaxTime`도 설정 필요. Messaging/Voice 채널만. 기본 false. |
| HasAutoAcceptEnabled | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | service channel의 work item이 상담원 workspace에 자동 오픈되어 수동 수락이 불필요한지(true). 기본 false. |
| Language | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | service channel의 언어. |
| MasterLabel | string | Create, Filter, Group, Sort, Update | service channel의 라벨. |
| MaxExtensions | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | 상담원이 ACW 시간을 연장할 수 있는 최대 횟수. **1~10** 지정. `hasAcwExtensionEnabled=true`이면 설정 필요. Messaging/Voice 채널만. |
| RelatedEntity | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | 이 service channel과 연관된 객체 유형. org 내 unique. 값(14): `Account`, `Activity`, `Case`, `ChangeRequest`, `Contact`, `ContactRequest`, `FlowOrchestrationWorkItem`, `Incident`, `Lead`, `Opportunity`, `Order`, `Problem`, `SocialPost`, `WorkOrder` |

> 참고: PDF에서 ServiceChannel 다음에 나오는 `ServiceFieldDataType`는 v34.0 deprecated, v58.0+ removed된 별개 객체로 **본 노트 대상이 아니다**.

### QueueRoutingConfig (12필드)

work item이 상담원에게 라우팅되는 방식을 결정하는 구성. API 65.0+. (Omni-Channel 활성 필요)

- **Supported SOAP API Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| CapacityPercentage | percent | Create, Filter, Nillable, Sort, Update | service channel의 특정 work item 유형이 소비하는 상담원 capacity 비율. 예: 전화 call의 capacity percentage=100. 설정 한도에 도달하면 call이 라우팅되지 않음. |
| CapacityWeight | double | Create, Filter, Nillable, Sort, Update | service channel의 work item이 소비하는 상담원 capacity 양. 예: capacity 6, case의 weight 2 → 상담원이 case 3개까지 받으면 capacity 도달. |
| DeveloperName | string | Create, Filter, Group, Sort, Update | API 내 고유 이름. |
| DropAdditionalSkillsTimeout | int | Create, Filter, Group, Nillable, Sort, Update | Omni-Channel 라우팅에서 additional skill을 drop하기 전 대기 초. skills-based 라우팅에서 일부 skill을 Additional Skill로 지정 가능. timeout 후 best-matched 상담원에게 라우팅(모든 skill 미보유라도). `CustomRequestedDateTime`(PendingServiceRouting)이 설정되면 그것을 시작 시간으로 사용. |
| IsAttributeBased | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | 라우팅 구성이 skills-based 라우팅 규칙과 함께 사용되는지(true). 기본 false. |
| Language | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | queue routing configuration의 언어. |
| MasterLabel | string | Create, Filter, Group, Sort, Update | queue routing configuration의 라벨. |
| PausedCapacityPercentage | percent | Create, Filter, Nillable, Sort, Update | work item이 일시정지될 때 소비되는 상담원 capacity 비율. status-based capacity + Enhanced Omni-Channel일 때만. |
| PausedCapacityWeight | double | Create, Filter, Nillable, Sort, Update | work item이 일시정지될 때 소비되는 상담원 capacity 양. status-based capacity + Enhanced Omni-Channel일 때만. |
| PushTimeout | int | Create, Filter, Group, Nillable, Sort, Update | item이 다른 상담원에게 push되기 전 상담원이 응답할 시간 제한(초). |
| RoutingModel | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | work item을 상담원에게 라우팅하는 방식. 값: `ExternalRouting`(서드파티 라우팅을 Omni-Channel과 통합), `LeastActive`(work가 가장 작은 capacity를 소비하는 상담원에게), `MostAvailable`(가용 capacity가 가장 큰 상담원에게) |
| RoutingPriority | int | Create, Filter, Group, Sort, Update | service channel의 work item이 상담원에게 라우팅되는 우선순위. 낮은 값(예: 0)이 먼저 라우팅됨. |

### PresenceUserConfig (10필드)

프레즌스 사용자의 설정을 결정하는 구성. API 65.0+. (Omni-Channel 활성 필요)

- **Supported SOAP API Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| AcwExtensionDuration | int | Create, Filter, Group, Nillable, Sort, Update | 상담원이 타이머를 연장할 때마다 ACW에 쓸 수 있는 최대 시간(초). `HasAcwExtensionEnabled=true`이면 설정 필요. **10~3600** 지정. |
| AfterConvoWorkMaxTime | int | Create, Filter, Group, Nillable, Sort, Update | 상담원이 ACW를 완료할 최대 시간(초). `HasAfterConvoWorkTimer=true`이면 설정 필요. **10~3600** 지정. |
| Capacity | int | Create, Filter, Group, Sort, Update | 상담원이 동시에 배정될 수 있는 최대 work unit 수. |
| DeveloperName | string | Create, Filter, Group, Sort, Update | API 내 고유 이름. |
| HasAcwExtensionEnabled | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | 상담원이 ACW 시간을 연장할 수 있는지(true). `HasAfterConvoWorkTimer=true`일 때만. true면 `AcwExtensionDuration`·`MaxExtensions`도 설정 필요. 기본 false. |
| HasAfterConvoWorkTimer | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | 상담원에게 ACW 시간 구성 가능 여부(true). true면 `AfterConvoWorkMaxTime`도 설정 필요. 기본 false. |
| InterruptibleCapacity | int | Create, Filter, Group, Nillable, Sort, Update | interruptible capacity를 사용해 상담원에게 한 번에 배정될 수 있는 최대 work unit 수. 비어있으면 `Capacity` 값을 기본 사용. Interruptible Capacity 기능 활성 시에만. |
| Language | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | presence configuration의 언어. |
| MasterLabel | string | Create, Filter, Group, Sort, Update | presence configuration의 라벨. |
| MaxExtensions | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | 상담원이 ACW 시간을 연장할 수 있는 최대 횟수. **1~10** 지정. `HasAcwExtensionEnabled=true`이면 설정 필요. |

> **인접 객체 코드 주의:** PDF의 PresenceUserConfig/PresenceDeclineReason 페이지에 등장하는 `PlatformEventSubscriberConfig`의 POST/SOQL 코드 예제는 **인접 객체(별 노트 소관) 것**이므로 여기에 포함하지 않는다.

### OmniSupervisorConfig (7필드)

배정된 supervisor 그룹을 위한 Omni-Channel supervisor 구성. API 57.0+. (Omni-Channel 활성, admin 권한 또는 Customize Application 권한 필요)

- **Supported SOAP API Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| DeveloperName | string | Filter, Group, Sort | API 내 고유 이름. underscore·영숫자만, org 내 unique. 문자로 시작, 공백 불가, underscore로 끝나거나 연속 underscore 불가. 관리형 패키지에서 설치 시 이름 충돌 방지. Label은 Record Type Name. 자동 생성되나 API로 생성 시 직접 지정 가능. (대량 생성 시 항상 고유 DeveloperName 지정 권장) |
| FullName | string | Create, Group, Nillable | Metadata API 연관 타입의 full name(공통 블록). |
| IsTimelineHidden | boolean | Defaulted on create, Filter, Group, Sort | true면 이 supervisor 구성에 배정된 supervisor에게 상담원 timeline을 숨김. 기본 false. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | Omni-Channel이 지원하는 언어들. |
| MasterLabel | string | Filter, Group, Sort | Omni-Channel supervisor 구성의 라벨. |
| Metadata | mns:OmniSupervisorConfig | Create, Nillable, Update | Omni-Channel supervisor 구성의 metadata(공통 블록). |
| SkillVisibility | picklist | Filter, Group, Nillable, Restricted picklist, Sort | 이 구성에 배정된 supervisor에게 어떤 skill 기반 work item이 보이는지. 값: `AllSkills`(이 구성에서 선택된 모든 skill 요건의 work item 표시), `AnySkill`(최소 1개 skill 요건의 work item 표시) |

### WorkSkillRouting (7필드)

skill을 가진 상담원에게 work item을 라우팅하는 데 사용되는 WorkSkillRoutingAttribute 집합을 저장하는 setup 객체. API 46.0+.

- **Supported SOAP Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST HTTP Methods:** DELETE, GET, PATCH, POST
- **Limitations:** SOQL Limitations, SOSL Limitations

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| DeveloperName | string | Filter, Group, Sort | WorkSkillRouting의 developer name. (View DeveloperName 또는 View Setup and Configuration 권한 보유자만 view/group/sort/filter 가능) |
| FullName | string | Create, Group, Nillable | Metadata API 연관 타입의 full name. |
| IsActive | boolean | Defaulted on create, Filter, Group, Sort | assignment 규칙이 활성이고 평가 가능한지. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | 사용자 개인 설정의 언어. |
| MasterLabel | string | Filter, Group, Sort | 이 객체의 master label. 번역되지 않는 내부 라벨. |
| Metadata | mns:WorkSkillRouting | Create, Nillable, Update | Metadata API 연관 타입. |
| RelatedEntity | picklist | Filter, Group, Restricted picklist, Sort, Unique | attribute가 연관된 Salesforce 객체 유형. |

### WorkSkillRoutingAttribute (7필드)

객체 field 값과 skill 간 라우팅 배정 metadata를 저장하는 setup 객체. field 값으로 skill 보유 상담원에게 라우팅. API 46.0+.

- **Supported SOAP Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST HTTP Methods:** DELETE, GET, PATCH, POST
- **Limitations:** SOQL Limitations, SOSL Limitations

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| Field | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | skill이 매핑되는 field 값에 해당하는 field. Skills-Based Routing Rules는 picklist·lookup·checkbox 타입 field 지원(예: Case Reason, Case Type, Escalated). 유효 값 전체는 Tooling API WSDL 참조. |
| IsAdditionalSkill | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | skills-based 라우팅에서 일부 skill을 additional로 지정. 지정된 timeout 후 additional로 표시된 skill은 Omni-Channel 라우팅에서 drop되어 best-matched 상담원에게(모든 skill 미보유라도) 라우팅. |
| RelatedEntity | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | 라우팅되는 객체 유형. 값(6): `Case`, `ContactRequest`, `Lead`, `Order`, `SocialPost`, `Custom` |
| SkillLevel | double | Create, Defaulted on create, Filter, Nillable, Sort, Update | 요구되는 skill 레벨. **0~10** 범위. |
| SkillPriority | int | Create, Filter, Group, Nillable, Sort, Update | additional skill의 경우, Drop Additional Skills Timeout 후 해당 skill 보유 상담원이 없을 때 skill이 drop되는 순서. 낮은 우선순위 rank(9 또는 10)가 먼저 drop, 높은 rank(0 또는 1)가 나중에 drop. 동일 priority는 그룹으로 drop. skills-based 라우팅 규칙 또는 Apex로 설정. API 49.0+. |
| Value | string | Create, Filter, Group, Nillable, Sort, Update | 선택된 skill에 매핑되는 field 값. |
| WorkSkillRoutingId | reference | Create, Filter, Group, Sort | 이 field 값이 연관된 WorkSkillRouting 객체의 ID. |

### Skill (4필드)

field service용 또는 Chat에서 chat을 상담원에게 라우팅하는 데 쓰는 skill 설정(skill 이름·배정 상담원 등). API 65.0+.

- **Supported SOAP API Calls:** `create()`, `describeSObjects()`, `query()`, `retrieve()`, `search()`, `update()`, `upsert()`
- **Supported REST API Methods:** GET, HEAD, PATCH, POST, Query
- **Special Access Rules:** *PDF에 Special Access Rules 섹션 없음.* (fabricate 금지)

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| Description | textarea | Create, Nillable, Update | skill의 설명. |
| DeveloperName | string | Create, Filter, Group, Sort, Update | API 내 고유 이름. underscore·영숫자만, org 내 unique. 문자로 시작, 공백 불가, underscore로 끝나거나 연속 underscore 불가. 자동 생성되나 API 생성 시 직접 지정 가능. |
| Language | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Skill의 언어. |
| MasterLabel | string | Create, Filter, Group, idLookup, Sort, Update | Skill의 라벨. |

> **BOUNDARY — Skill의 다른 API facet:** 동일한 Skill 객체는 Scheduler/Field Service 쪽에서 **Metadata facet**으로도 노출된다. 본 노트는 **Tooling sObject facet**(위 4필드)이다. 표준객체로서의 Skill·스킬 데이터 모델은 [[Salesforce Scheduler 표준객체 — 리소스·영역·스킬·시프트]]를 참조.

### ServicePresenceStatus (3필드)

service channel에 배정할 수 있는 프레즌스 상태. API 65.0+. (Omni-Channel 활성 필요)

- **Supported SOAP API Calls:** `create()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST API Methods:** GET, HEAD, PATCH, POST, Query

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| DeveloperName | string | Create, Filter, Group, Sort, Update | API 내 고유 이름. |
| Language | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | presence status의 언어. |
| MasterLabel | string | Create, Filter, Group, Sort, Update | presence status의 라벨. |

### PresenceDeclineReason (3필드)

상담원이 Omni-Channel work 요청을 거절할 때 선택할 수 있는 사유. API 65.0+. (Omni-Channel 활성 필요)

- **Supported SOAP API Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| DeveloperName | string | Create, Filter, Group, Sort, Update | API 내 고유 이름. |
| Language | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | presence decline reason의 언어. |
| MasterLabel | string | Create, Filter, Group, Sort, Update | presence decline reason의 라벨. |

---

## 2. 대화·메시징 채널 (6객체)

### ConversationChannelDefinition (33필드)

Interaction Service(Bring Your Own Channel for Messaging / for CCaaS messaging channel)용으로 구현되는 대화 채널의 구성 가능 정의. API 60.0+. (Interaction Service 구성, admin 권한 또는 Customize Application 권한 필요)

- **Supported SOAP API Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| CapabilitiesSupportsCustomChannelParameters | boolean | Filter | admin이 messaging channel에 custom parameter·parameter mapping을 구성할 수 있는지. 런타임에 Omni-Channel flow로 추가 정보 전달. 기본 false. API 61.0. |
| CapabilitiesSupportsDoubleOptInConsent | boolean | Filter | 채널이 Double Opt-In consent 레벨을 지원하는지(true). 기본 false. true면 `capabilitiesSupportsExplicitConsent`도 true여야 함. 선택. BYOC for Messaging 미지원, BYOC for CCaaS만 지원. |
| CapabilitiesSupportsExplicitConsent | boolean | Filter | 채널이 Explicit Opt-In consent 레벨을 지원하는지(true). 선택. |
| CapabilitiesSupportsImplicitConsent | boolean | Filter | 채널이 Implicit Opt-In consent 레벨을 지원하는지(true). 필수이며 항상 true여야 함. 기본 false. |
| CapabilitiesSupportsIsoCountryCode | boolean | Filter | 채널이 ISO country code를 지원하는지(true). 기본 false. |
| CapabilitiesSupportsKeywords | boolean | Filter | 채널이 keyword를 지원하는지(true). 기본 false. |
| ConnectedAppOauthLink | string | Filter, Group, Sort | **이 값을 설정/변경하지 말 것.** 자동 생성. ConnectedAppType이 Partner일 때 ECA(external client app) 또는 connected app의 OAuth link. partner Org ID + consumer ID(key prefix 제외)를 포함한 string 식별자. |
| ConnectedAppType | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | Salesforce Interaction Service와 Messaging/CCaaS partner 시스템 간 인증 관리에 쓰는 ECA/connected app의 소유자. 값: `Partner`, `Customer`. 기본 Partner. Partner면 partner가 ECA/connected app을 생성해 managed package에 포함, Customer면 admin이 생성. API 62.0. |
| ConsentOwner | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | 고객이 consent 레벨을 관리하는 시스템. 값: `Partner`, `Salesforce`. 기본 Salesforce. Salesforce면 Salesforce가, Partner면 partner의 telephony/CCaaS 시스템이 관리. BYOC for Messaging은 반드시 Salesforce. |
| ConversationVendorInfo | string | Create, Filter, Group, Nillable, Sort, Update | ConversationVendorInfo record에 연결하는 데 쓰는 `ConversationVendorInfo.developerName`. 예: PartnerName. |
| customEventChnlAddrIdField ⚠️ | picklist | Filter, Group, Restricted picklist, Sort | ChannelAddressIdentifier field를 가리키는 custom field를 가리키는 mapping field. **API 60.0에서 deprecated, API 61.0에서 제거 예정.** 대신 `customEventTypeField` + `customEventPayloadField` 조합 사용. |
| CustomEventPayloadField | picklist | Filter, Group, Restricted picklist, Sort | Payload field를 가리키는 custom field를 가리키는 mapping field. 형식 `<orgNamespace>__<CustomFieldName>__c`. custom platform event의 custom Payload field API 이름. 예: `devorg__Payload__c`. |
| customEventRecipientField ⚠️ | picklist | Filter, Group, Restricted picklist, Sort | Recipient field를 가리키는 custom field를 가리키는 mapping field. **API 60.0에서 deprecated, API 61.0에서 제거 예정.** 대신 `customEventTypeField` + `customEventPayloadField` 조합 사용. |
| CustomEventTypeField | picklist | Filter, Group, Nillable, Restricted picklist, Sort | Platform event type(EventType) field를 가리키는 custom field를 가리키는 mapping field. 형식 `<orgNamespace>__<CustomFieldName>__c`. 예: `devorg__EventType__c`. |
| CustomIconId | reference | Filter, Group, Nillable, Sort | BYOC for Messaging/CCaaS에서 채널 통합 식별용 status resource 이미지(채널 로고 등) 이름. 50px×50px, SVG 권장. 선택. API 61.0+. **관계 field** — RelName=`CustomIcon`, RefersTo=`StaticResource`. |
| CustomerConnectedAppOauthLink | string | Filter, Group, Nillable, Sort | **이 값을 설정/변경하지 말 것.** 자동 생성. ConnectedAppType이 Customer일 때 admin이 생성한 ECA/connected app의 OAuth link. API 62.0. |
| CustomPlatformEvent | picklist | Filter, Group, Restricted picklist, Sort | Interaction Service API용 custom platform event의 API 이름. 형식 `<orgNamespace>__<CustomPlatformEventName>__e`. 예: `devorg__TestEvent__e`. |
| DeveloperName | string | Filter, Group, Sort | API 내 custom metadata type 객체의 고유 이름. 형식 `<Prefix>_<ConversationChannelDefinition>`. 예: `Partner1_ChannelDefinition1`. |
| EventCapabilitiesIsInboundAcknwOptionExposed | boolean | Filter | partner가 inbound message의 read/delivery receipt를 지원(true)하거나, 미지원이라 Messaging 설정에서 admin에게 기능이 숨겨지는지(false). 기본 false. API 65.0+. `IsInboundReceiptsEnabled` 대신 사용. |
| EventCapabilitiesIsProgressIndicatorOptExposed | boolean | Filter | partner가 AI agent의 progress indicator를 지원(true)하거나, 미지원이라 admin에게 숨겨지는지(false). 기본 false. API 65.0+. |
| EventCapabilitiesIsRoutingWorkResultSupported | boolean | Filter | Routing Work Result event가 Custom Platform event로 전송되는지(true). 기본 false. API 65.0+. `IsRoutingWorkResultEnabled` 대신 사용. |
| EventCapabilitiesIsTypingIndicatorOptionHidden | boolean | Filter | partner가 outbound message의 typing indicator를 미지원이라 admin에게 숨겨지는지(true), 또는 지원하는지(false). 기본 false(기본적으로 outbound typing indicator 지원). 비활성화하려면 true. API 65.0+. `IsTypingIndicatorDisabled` 대신 사용. |
| FullName | string | Create, Group, Nillable | Metadata API 연관 ConversationChannelDefinition의 full name. 형식 `???_???`, namespace prefix 포함 가능(공통 블록). |
| IsConferenceSupported | boolean | Defaulted on create, Filter, Group, Sort | partner가 BYOC conferencing을 지원하는지(true). conferencing 시 messaging session에 2명 초과 참가자 허용. 기본 false. API 64.0+. |
| IsInboundReceiptsEnabled ⛔ | boolean | Defaulted on create, Filter, Group, Sort | partner가 inbound message의 read/delivery receipt를 지원(true)하는지. 기본 false. **API 63.0~65.0 사용 가능. API 66.0+에서 제거됨.** 대신 `EventCapabilitiesIsInboundAcknwOptionExposed` 사용. |
| IsRoutingWorkResultEnabled ⛔ | boolean | Defaulted on create, Filter, Group, Sort | Routing Work Result event가 Custom Platform event로 전송되는지. 기본 false. **API 64.0~65.0 사용 가능. API 66.0+에서 제거됨.** 대신 `EventCapabilitiesIsRoutingWorkResultSupported` 사용. |
| IsTypingIndicatorDisabled ⛔ | boolean | Defaulted on create, Filter, Group, Sort | partner가 outbound message의 typing indicator를 미지원이라 숨겨지는지(true), 또는 지원하는지(false). 기본 false. **API 63.0~65.0 사용 가능. API 66.0+에서 제거됨.** 대신 `EventCapabilitiesIsTypingIndicatorOptionHidden` 사용. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | 패키지에 포함된 컴포넌트의 manageable state(서술형 — 공통 블록). |
| MasterLabel | string | Filter, Group, Sort | API 내 custom metadata type 객체의 UI 라벨. UI 여러 곳에 표시되므로 partner channel 이름 포함 권장. 예: Channel Definition 1. |
| MaxParticipantsForCnfrOverride | int | Filter, Group, Nillable, Sort | messaging conference에 들어갈 수 있는 참가자 수 한도. 설정 시 플랫폼 한도를 override. 미설정 시 messaging 플랫폼 한도를 기본 사용. API 64.0+. |
| Metadata | complexvalue | Create, Nillable, Update | standard/custom 객체의 metadata. Tooling API WSDL의 metadata namespace `CustomObject` 항목 참조(공통 블록). |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | 이 객체와 연관된 namespace prefix(공통 블록). publisher가 Salesforce면 null. |
| RoutingOwner | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | 고객이 BYOC for Messaging/CCaaS의 라우팅을 관리하는 시스템. 값: `Partner`, `Salesforce`. 기본 Salesforce. Salesforce면 Salesforce가, Partner면 partner telephony/CCaaS 시스템이 관리. BYOC for Messaging은 반드시 Salesforce. |

> ⚠️ = deprecated(제거 예정), ⛔ = API 66.0+에서 제거됨. v67.0 PDF가 historical record로 보존하고 있어 본 노트도 행을 유지한다.

### ConversationVendorInfo (28필드)

partner vendor 시스템을 Service Cloud 기능에 연결하는 setup 객체. Service Cloud Voice는 partner telephony/CCaaS 정보를, BYOC for Messaging은 partner messaging 시스템 정보를, BYOC for CCaaS는 CCaaS partner 시스템 정보를 보유. API 52.0+. (Service Cloud Voice for Partner Telephony 또는 Digital Engagement add-on 라이선스 필요)

- **Supported SOAP API Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query

> 필드는 별도 명시가 없으면 모든 Service Cloud 기능에 적용된다. 특정 SCV telephony 모델 setup에만 적용되거나 partner 시스템별로 다르면 설명에 명시된다. 아래 "적용 구현"은 PDF의 "Applies to the following implementations"를 요약한 것이다(SCV-PT = Service Cloud Voice with Partner Telephony, SCV-PT/AC = SCV with Partner Telephony from Amazon Connect, BYOC-CCaaS = Bring Your Own Channel for CCaaS).

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| BridgeComponent | string | Filter, Group, Nillable, Sort | telephony/messaging 시스템과 다른 Lightning 컴포넌트 간 통신에 쓰는 Lightning 컴포넌트. 적용: SCV-PT, SCV-PT/AC, BYOC-CCaaS. |
| CapabilitiesSupportsAgentSSO | boolean | Filter | true면 상담원이 Salesforce를 IdP로 contact center에 SSO 가능(Salesforce가 Single Sign-On ECA의 SAML IdP). false면 다른 IdP 또는 IdP 미사용. 기본 false. false인데 Salesforce를 IdP로 쓰려면 이 값과 `namedCredentialSupported`를 true로 하고 `service_cloud_voice.PartnerSSO` 인터페이스를 Apex 통합 클래스에 구성. API 53.0+. 적용: SCV-PT, SCV-PT/AC, BYOC-CCaaS. |
| CapabilitiesSupportsEinsteinConversationInsights | boolean | Filter | true면 Einstein Conversation Insights on. 기본 false. API 53.0+. 적용: SCV-PT, SCV-PT/AC. |
| CapabilitiesSupportsIntelligence | boolean | Filter | true면 partner telephony가 보내는 실시간 신호를 Salesforce가 ingest. 기본 false. API 59.0+. 적용: SCV-PT. |
| CapabilitiesSupportsKeyProvisioning | boolean | Filter | true면 key provisioning·갱신 자동화. 기본 false. API 54.0+. 적용: SCV-PT, SCV-PT/AC. |
| CapabilitiesSupportsNamedCredential | boolean | Filter | partner 시스템 Apex callout에 쓸 수 있는 sample named credential. API 53.0+. 적용: SCV-PT, SCV-PT/AC, BYOC-CCaaS. |
| CapabilitiesSupportsPartnerContactCenterList | boolean | Filter | true면 고객이 여러 contact center 목록 중 하나를 골라 Salesforce와 연결. 기본 false. API 53.0+. 적용: SCV-PT, SCV-PT/AC, BYOC-CCaaS. |
| CapabilitiesSupportsPartnerPhoneNumbers | boolean | Filter | true면 contact center 채널 생성에 쓰는 전화번호 목록 표시. 기본 false. API 54.0+. 적용: SCV-PT, SCV-PT/AC. |
| CapabilitiesSupportsPartnerTransferDestinations | boolean | Filter | true면 Salesforce가 contact center queue를 fetch해 Salesforce↔contact center queue 매핑 가능. 기본 false. API 53.0+. 적용: SCV-PT, SCV-PT/AC, BYOC-CCaaS. |
| CapabilitiesSupportsQueueManagement | boolean | Filter | true면 queue management 지원. 기본 false. API 56.0+. 적용: SCV-PT, SCV-PT/AC, BYOC-CCaaS. |
| CapabilitiesSupportsUnifiedRouting (Beta) | boolean | Create, Filter, Update | voice channel의 voice call에 unified routing 지원 여부(true). 기본 false. true로 설정하면 false로 되돌릴 수 없음. API 63.0+. 적용: SCV-PT. **(Beta)** |
| CapabilitiesSupportsUniversalCallRecordingAccess | boolean | Filter | true면 Universal Call Recording Access on. 기본 false. false인데 켜려면 true로 하고 `service_cloud_voice.RecordingMediaProvider` 인터페이스를 Apex 통합 클래스에 구성. API 54.0+. 적용: SCV-PT, SCV-PT/AC. |
| CapabilitiesSupportsUserSyncing | boolean | Filter | true면 contact center에 사용자 추가/제거 시 자동 user syncing 지원. 기본 false. API 53.0+. 적용: SCV-PT, SCV-PT/AC, BYOC-CCaaS. |
| ConnectorUrl | url | Filter, Group, Nillable, Sort | SCV 또는 BYOC-CCaaS connector를 호스팅하는 URL. Visualforce 페이지 또는 public URL 가능. 적용: SCV-PT, SCV-PT/AC, BYOC-CCaaS. |
| CustomConfigId | reference | Filter, Group, Nillable, Sort | partner별 custom 설정을 담은 CustomEntityDefinition에 대한 foreign key. API 53.0+. 적용: SCV-PT, SCV-PT/AC, BYOC-CCaaS. **관계 field** — RelName=`CustomConfig`, RefersTo=`CustomObject`. |
| CustomIconId | reference | Filter, Group, Nillable, Sort | contact center 통합 식별용 static resource ID(CCaaS provider 로고 등). SVG 형식 필수. 선택. API 62.0+. 적용: SCV-PT, BYOC-CCaaS. **관계 field** — RelName=`CustomIcon`, RefersTo=`StaticResource`. |
| CustomLoginUrl | url | Filter, Group, Nillable, Sort | telephony/CCaaS 시스템 로그인 페이지를 호스팅하는 URL. 적용: SCV-PT, SCV-PT/AC, BYOC-CCaaS. |
| DeveloperName | string | Filter, Group, Sort | API 내 고유 이름. 자동 생성되나 API 생성 시 직접 지정 가능. |
| FullName | string | Create, Group, Nillable | Metadata API 연관 ConversationVendorInfo 타입의 full name. namespace prefix 포함 가능(공통 블록). |
| IntegrationClassId | reference | Filter, Group, Nillable, Sort | 지원 인터페이스를 구현하는 partner Apex 클래스에 대한 foreign key. API 53.0+. 적용: SCV-PT, SCV-PT/AC, BYOC-CCaaS. **관계 field** — RelName=`IntegrationClass`, RefersTo=`ApexClass`. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | master label(MasterLabel)의 UI 표시 언어. 적용: SCV-PT, SCV-PT/AC, BYOC-CCaaS. (값 미명시 피클리스트) |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | 패키지 컴포넌트의 manageable state(단축형 — 공통 블록). |
| MasterLabel | string | Filter, Group, Sort | partner vendor의 UI 표시 이름. UI 여러 곳에 표시되므로 partner vendor 이름 포함 권장. SCV는 contact center record의 telephony provider 이름. SCV with Amazon Connect는 항상 `Service Cloud Voice`. |
| Metadata | ConversationVendorInfo | Create, Nillable, Update | ConversationVendorInfo의 metadata(공통 블록 쿼리 제한 적용). |
| NamedCredentialId | reference | Filter, Group, Nillable, Sort | partner 시스템 Apex callout에 쓸 수 있는 sample named credential. API 53.0+. 적용: SCV-PT, SCV-PT/AC, BYOC-CCaaS. **관계 field** — RelName=`NamedCredential`, RefersTo=`NamedCredential`. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | 이 객체와 연관된 namespace prefix(공통 블록). |
| TelephonySettingsComponent | string | Filter, Group, Nillable, Sort | Omni-Channel 위젯에 추가 상담원 설정을 표시하는 데 쓰는 LWC 이름. 형식 `mynamespace:componentName`(mynamespace = 생성된 SCV 패키지 namespace, componentName = Lightning 컴포넌트 FQDN). API 54.0+. 적용: SCV-PT. |
| VendorType | picklist | Filter, Group, Nillable, Restricted picklist, Sort | partner vendor가 지원하는 Service Cloud 기능. 값: `Amazon_Connect`(SCV with Amazon Connect용), `BringYourOwnChannelPartner`(BYOC for Messaging용, API 60.0+), `BringYourOwnContactCenter`(BYOC for CCaaS용, API 60.0+), `ServiceCloudVoicePartner`(SCV with Partner Telephony / from Amazon Connect용, API 53.0+) |

### EngagementInsightType (15필드)

voice·video call insight를 위한 engagement insight type 구성. API 65.0+.

- **Supported Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST API Methods:** *PDF에 REST API 메서드 섹션 없음.* (SOAP "Supported Calls"만 존재 — fabricate 금지)

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| ActivatedDateTime | dateTime | Create, Filter, Nillable, Sort, Update | Required. insight type이 활성화된 timestamp. |
| AdditionalConfig | textarea | Create, Nillable, Update | Required. insight type별 추가 구성 정보. 예: time-based insight의 timing 구성, generative insight의 prompt-based 구성. |
| Category | picklist | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort, Update | Required. insight type의 카테고리. 값: `CUSTOM`(admin이 생성), `SYSTEM`(Salesforce 기본 제공). 기본 CUSTOM. |
| ChannelType | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Required. insight 생성에 쓰는 engagement 채널. 값: `Emails`, `VideoCalls`, `VoiceCalls`. 기본 VoiceCalls. |
| Description | textarea | Create, Nillable, Update | insight type의 설명. |
| DeveloperName | string | Create, Filter, Group, Sort, Update | EngagementInsightType 객체의 고유 이름. |
| ExternalIdentifier | string | Create, Filter, Group, Nillable, Sort, Update | 각 insight type에 생성된 ID. |
| InsightModel | picklist | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort, Update | Required. insight 생성에 선택하는 computational model. 값: `GENERATIVE`, `KEYWORD`, `SITUATIONAL`, `TIME_BASED`. 기본 KEYWORD. |
| InsightName | string | Create, Filter, Group, Sort, Update | Required. insight의 이름. |
| Language | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Required. insight type에 쓰는 언어. |
| MasterLabel | string | Create, Filter, Group, Sort, Update | insight type의 라벨. |
| SpeakerType | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | 참가자가 internal(내부 rep)·external(고객)·either(불확실) 중 무엇인지. UI의 'Said by' field. 값: `EITHER`, `EXTERNAL`, `INTERNAL`. 기본 INTERNAL. |
| Status | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Required. insight type의 상태. 값: `ENABLED`, `USER_DISABLED`. 기본 ENABLED. |
| SupportedLanguageList | string | Create, Filter, Group, Nillable, Sort, Update | insight type에 지원되는 언어 목록. |
| UsageType | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | insight type이 적용 가능한 industry. 값: `SALES`, `SALES_SERVICE`, `SERVICE`. 기본 SALES. |

### ExtConvParticipantIntegDef (11필드)

external 대화 참가자를 위한 통합 구성. Salesforce와 external messaging 플랫폼 간 통신용. API 66.0+.

- **Supported Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST API Methods:** *PDF에 REST API 메서드 섹션 없음.* (SOAP "Supported Calls"만 존재 — fabricate 금지)

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| AccountKey | textarea | Create, Nillable, Update | external bot API call용 인증 자격증명을 안전 저장하는 암호화된 JSON 형식 key. |
| BotProvider | picklist | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort, Update | 인증 및 request/response 로직을 처리하는 bot 통합 provider. 값: `Custom` |
| ChannelMode | picklist | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort, Update | 채널 유형. 값: `Messaging`, `Voice`. 기본 Messaging. |
| ClientIdentifier | string | Create, Filter, Group, Nillable, Sort, Update | bot provider의 API client ID. |
| DeveloperName | string | Create, Filter, Group, Sort, Update | API 내 고유 이름. |
| Language | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | MasterLabel의 언어. |
| ManageableState | picklist | Filter, Group, Nillable, Restricted picklist, Sort | 패키지 컴포넌트의 manageable state(단축형 — 공통 블록). |
| MasterLabel | string | Create, Filter, Group, Sort, Update | 이 객체의 라벨. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | 관리형 패키지의 일부면, external 대화 참가자 통합 정의를 담은 패키지의 namespace. |
| ProjectIdentifier | string | Create, Filter, Group, Nillable, Sort, Update | API call과 resource 접근 범위를 정하는 provider framework 내 프로젝트 ID. |
| Status | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | 통합의 상태. 값: `Active`, `Deleted`, `Inactive`. 기본 Active. |

### CustomMsgChannel (6필드)

custom 대화 채널을 나타내고 event-driven Messaging 설정을 저장. BYOC for Messaging / for CCaaS Messaging channel용으로 구현. API 63.0+.

- **Supported SOAP API Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query
- **Special Access Rules:** *PDF에 Special Access Rules 헤딩은 있으나 내용 비어있음.* (fabricate 금지)

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| ChannelDefinitionId | reference | Create, Filter, Group, Sort, Update | custom channel의 ConversationChannelDefinition 지정. **관계 field** — RelName=`ChannelDefinition`, RefersTo=`ConversationChannelDefinition`. |
| EventCapabilitiesIsInboundAcknowledgementEnabled | boolean | Create, Filter, Update | admin이 Messaging 설정에서 inbound message의 read/delivery receipt를 활성화했는지(true). 기본 false(partner가 지원해도 기본 비활성). API 65.0+. `HasInboundReceipts` 대신 사용. |
| EventCapabilitiesIsProgressIndicatorEnabled | boolean | Create, Filter, Update | admin이 Messaging 설정에서 AI agent progress indicator를 활성화했는지(true). 기본 false(partner가 지원해도 기본 비활성). API 65.0+. |
| EventCapabilitiesIsTypingIndicatorDisabled | boolean | Create, Filter, Update | admin이 Messaging 설정에서 outbound message의 typing indicator를 활성화했는지(false), 또는 미활성(true). 기본 false(기본적으로 outbound typing indicator 활성). API 65.0+. `HasTypingIndicator` 대신 사용. |
| HasInboundReceipts ⛔ | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | **API 63.0~65.0 사용 가능. API 66.0+에서 제거됨.** 대신 `EventCapabilitiesIsInboundAcknowledgementEnabled` 사용. 기본 false. |
| HasTypingIndicator ⛔ | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | **API 63.0~65.0 사용 가능. API 66.0+에서 제거됨.** 대신 `EventCapabilitiesIsTypingIndicatorDisabled` 사용. |

> ⛔ = API 66.0+에서 제거됨. v67.0 PDF가 historical record로 보존.

### ContactCenterChannel (5필드)

BYOC for CCaaS(Contact Center as a Service) messaging channel과 CallCenter 객체를 연결하는 junction 객체. voicemail 구성의 라우팅 세부도 나타냄. API 56.0+. (SCV with Amazon Connect / Partner Telephony / Partner Telephony from Amazon Connect, 또는 BYOC for CCaaS 활성 필요. Tooling 객체 접근에는 SysAdmin 또는 ViewSetup 권한 필요)

- **Supported SOAP API Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| ChannelId | reference | Create, Filter, Group, Sort, Update | BYOC for CCaaS에서 contact center(CallCenterId)와 연관된 BYOC messaging channel(MessagingChannel)의 고유 ID. API 60.0+. **관계 field** — RelName=`Channel`, RefersTo=`MessagingChannel`. |
| ContactCenterId | reference | Create, Filter, Group, Sort | BYOC for CCaaS에서 BYOC messaging channel(MessagingChannel)과 연관된 contact center(CallCenterId)의 고유 ID. API 60.0+. **관계 field** — RelName=`ContactCenter`, RelType=Master-detail, RefersTo=`CallCenter`(master 객체). |
| UserId | reference | Create, Filter, Group, Nillable, Sort, Update | **API 63.0에서만 사용 가능. 내부용(For internal use).** |
| VoicemailFallbackQueueId | reference | Create, Filter, Group, Nillable, Sort, Update | voicemail 라우팅이 구성된 경우, voicemail 라우팅 실패 시 쓸 fallback queue의 고유 ID. **이 값을 변경하지 말 것** — 대신 Lightning Experience에서 voicemail 라우팅 구성. **관계 field** — RelName=`VoicemailFallbackQueue`, RefersTo=`Group`. |
| VoicemailHandler | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | voicemail 라우팅이 구성된 경우, voicemail 라우팅에 쓰는 flow의 고유 ID. **이 값을 변경하지 말 것** — 대신 Lightning Experience에서 구성. |

> ContactCenterChannel은 PDF에 코드 예제가 없다.

---

## 3. 서비스 카탈로그 (5객체)

> 5종 모두 **Special Access Rules:** Employee Productivity Plus 또는 IT Service Center add-on 보유 고객에게 제공.

### SvcCatalogItemDef (13필드)

Service Catalog 내 개별 카탈로그 항목. API 53.0+.

- **Supported SOAP API Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| Description | textarea | Nillable | 카탈로그 항목의 자유 텍스트 설명. |
| DeveloperName | string | Filter, Group, Sort | 이 카탈로그 항목의 developer name. |
| FlowId | reference | Filter, Group, Nillable, Sort | 카탈로그 항목과 연관된 screen flow. **관계 field** — RelName=`Flow`, RelType=Lookup, RefersTo=`FlowDefinition`. |
| FulfillmentFlowId | reference | Filter, Group, Nillable, Sort | **관계 field** — RelName=`FulfillmentFlow`, RelType=Lookup, RefersTo=`SvcCatalogFulfillmentFlow`. |
| FullName | string | Create, Group, Nillable | 카탈로그 항목의 full name. org 내 unique, 영숫자·underscore만, 문자로 시작, 공백 불가, underscore로 끝나거나 연속 underscore 불가(공통 쿼리 제한 적용). |
| InternalNotes | textarea | Nillable | 카탈로그 항목의 동작·구현 설명. 다른 catalog builder용. |
| IsFeatured | boolean | Defaulted on create, Filter, Group, Sort | 카탈로그 항목이 featured 항목의 일부인지. 기본 false. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted Picklist, Sort | 값(18): `da`(Danish), `de`(German), `en_US`(English), `es`(Spanish), `es_MX`(Spanish-Mexico), `fi`(Finnish), `fr`(French), `it`(Italian), `ja`(Japanese), `ko`(Korean), `nl_NL`(Dutch), `no`(Norwegian), `pt_BR`(Portuguese-Brazil), `ru`(Russian), `sv`(Swedish), `th`(Thai), `zh_CN`(Chinese-Simplified), `zh_TW`(Chinese-Traditional) |
| ManageableState | picklist | Filter, Group, Nillable, Restricted picklist, Sort | 패키지 카탈로그 항목의 manageable state(서술형 — 공통 블록). |
| MasterLabel | string | Filter, Group, Sort | 카탈로그 항목 record의 primary label. |
| Metadata | complexvalue | Create, Nillable, Update | 카탈로그 항목의 metadata(공통 쿼리 제한 적용). |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | 이 카탈로그 항목과 연관된 namespace(공통 블록). |
| Status | picklist | Defaulted on create, Filter, Group, Restricted picklist, Sort | 카탈로그 항목의 publishing 상태. 값: `Deprecated`, `Draft`, `PendingChanges`, `Published`. 기본 Draft. |

### SvcCatalogCategory (9필드)

Service Catalog에서 개별 카탈로그 항목의 그룹핑. API 53.0+.

- **Supported SOAP API Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| DeveloperName | string | Filter, Group, Sort | 이 카테고리의 developer name. |
| FullName | string | Create, Group, Nillable | 카테고리의 full name. org 내 unique, 영숫자·underscore만, 문자로 시작, 공백 불가, underscore로 끝나거나 연속 underscore 불가(공통 쿼리 제한 적용). |
| IsActive | boolean | Defaulted on create, Filter, Group, Sort | 카탈로그 카테고리가 활성인지. 기본 false. |
| ManageableState | picklist | Filter, Group, Nillable, Restricted picklist, Sort | 패키지 카테고리의 manageable state(서술형 — 공통 블록). |
| MasterLabel | string | Filter, Group, Sort | 카탈로그 카테고리 record의 primary label. |
| Metadata | complexvalue | Create, Nillable, Update | 카테고리의 metadata(공통 쿼리 제한 적용). |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | 이 카테고리와 연관된 namespace(공통 블록). |
| ParentCategoryId | reference | Filter, Group, Nillable, Sort | 제공 시, 이 카테고리가 표시될 다른 SvcCatalogCategory의 이름. parent 카테고리는 자체 parent를 가질 수 없음(중첩 1단계만). **관계 field** — RelName=`ParentCategory`, RelType=Lookup, RefersTo=`SvcCatalogCategory`. |
| SortOrder | int | Filter, Group, Nillable, Sort | 카탈로그 카테고리 엔티티의 표시 순서. |

### SvcCatalogFulfillmentFlow (9필드)

Service Catalog 내 특정 카탈로그 항목과 연관된 flow. API 53.0+.

- **Supported SOAP API Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| Description | textarea | Nillable | fulfillment flow의 자유 텍스트 설명. |
| DeveloperName | string | Filter, Group, Sort | 이 fulfillment flow의 developer name. |
| FlowId | reference | Filter, Group, Nillable, Sort | 이 SvcCatalogFulfillmentFlow가 나타내는 flow. **관계 field** — RelName=`Flow`, RelType=Lookup, RefersTo=`FlowDefinition`. |
| FullName | string | Create, Group, Nillable | fulfillment flow의 full name. org 내 unique, 영숫자·underscore만, 문자로 시작, 공백 불가, underscore로 끝나거나 연속 underscore 불가(공통 쿼리 제한 적용). |
| Icon | string | Filter, Group, Nillable, Sort | 향후 사용 예약(Reserved for future use). |
| ManageableState | picklist | Filter, Group, Nillable, Restricted picklist, Sort | 패키지 fulfillment flow의 manageable state(서술형 — 공통 블록). |
| MasterLabel | string | Filter, Group, Sort | fulfillment flow record의 primary label. |
| Metadata | complexvalue | Create, Nillable, Update | fulfillment flow의 metadata(공통 쿼리 제한 적용). |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | 이 fulfillment flow와 연관된 namespace(공통 블록). |

### SvcCatalogCategoryItem (4필드)

Service Catalog 내 카테고리에 대한 이 서비스의 배정. API 53.0+.

- **Supported SOAP API Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| IsPrimaryCategory | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | 카탈로그 카테고리(SvcCatalogCategory)가 이 카탈로그 항목의 primary 카테고리인지. 각 SvcCatalogItemDef 컴포넌트는 이 속성이 true인 카테고리를 하나만 가질 수 있음. 기본 false. |
| SortOrder | int | Create, Filter, Group, Nillable, Sort, Update | 카탈로그 카테고리 내 다른 카탈로그 항목 대비 이 항목의 위치. |
| SvcCatalogCategoryId | reference | Create, Filter, Group, Nillable, Sort, Update | 카탈로그 항목이 배정된 카탈로그 카테고리. **관계 field** — RelName=`SvcCatalogCategory`, RelType=Lookup, RefersTo=`SvcCatalogCategory`. |
| SvcCatalogItemDefId | reference | Create, Filter, Group, Sort | SvcCatalogItemDef에 대한 참조. **관계 field** — RelName=`SvcCatalogItemDef`, RelType=Lookup, RefersTo=`SvcCatalogItemDef`. |

### SvcCatalogFulfillFlowItem ⚠️ deprecated (v53.0~56.0)

> [!warning] 이 객체는 **API 버전 53.0 through 56.0** 범위에서만 사용 가능하며 그 이후로 deprecated 되었다. v67.0 PDF가 historical record로 보존하고 있어 본 노트도 전수 기재한다.

Service Catalog의 fulfillment flow에서 input을 받을 수 있는 변수를 나타낸다.

- **Supported SOAP API Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| CatalogFulfillmentId | reference | Create, Filter, Group, Sort | 이 항목이 속한 SvcCatalogFulfillmentFlow의 ID. **관계 field** — RelName=`CatalogFulfillment`, RelType=Lookup, RefersTo=`SvcCatalogFulfillmentFlow`. |
| CatalogInputVariable | string | Create, Filter, Group, Nillable, Sort, Update | fulfillment flow property가 나타내는 FlowVariable. |
| DisplayType | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | 사용 가능한 표시 옵션. 값: `Checkbox`, `Lookup`, `Number`, `Picklist`, `Text`. 기본 Lookup. |
| FieldDefinition | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | ObjectLookupDomainId 객체 내 이 변수 값을 지정하는 field 이름. DisplayType이 Picklist면 picklist field 이름, Lookup이고 FieldLookupDomainId가 FieldDefinition이면 relationship field 이름. standard/custom 객체의 field 가능. |
| FieldLookupDomainId | string | Create, Filter, Group, Nillable, Sort, Update | 해당 lookup/picklist의 도메인을 지정하는 standard/custom 객체 이름. displayType이 Lookup 또는 Picklist일 때만 유효. **관계 field** — RelName=`FieldLookupDomain`, RelType=Lookup, RefersTo=`EntityDefinition`. |
| IsAdditionalQuestionsInputVariable | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | 이 변수가 사용자에게 물은 모든 additional question의 input을 받는지. 이 항목의 DisplayType이 Text일 때만 true 가능. SvcCatalogFulfillmentFlow 컴포넌트당 한 항목만 이 속성을 true로 설정 가능. 기본 false. |
| IsRequired | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | 연관 fulfillment flow 실행에 이 field가 필수인지. 기본 false. |
| LookupDomainFieldType | string | Create, Filter, Group, Nillable, Sort, Update | ObjectLookupDomainId가 지정한 객체의 field 중 Catalog Builder에 type별로 표시될 field 지정. DisplayType이 Lookup이고 fieldLookupDomain이 FieldDefinition일 때만 유효. |
| MasterLabel | string | Create, Filter, Group, Sort, Update | (primary label) |
| ObjectLookupDomainId | string | Create, Filter, Group, Nillable, Sort, Update | standard/custom 객체 이름. DisplayType이 Lookup 또는 Picklist면 이 값이 사용 가능 옵션을 특정 객체로 필터. **관계 field** — RelName=`ObjectLookupDomain`, RelType=Lookup, RefersTo=`EntityDefinition`. |

---

## 4. 스케줄링·워크포스 (4객체)

### ShiftSegmentType (10필드)

Shift Scheduling 및 Workforce Engagement용 shift segment type 설정. API 55.0+. (Shift Scheduling 또는 Workforce Engagement 활성 필요. Shift Scheduling Planner 또는 Workforce Engagement Planner permission set 필요)

- **Supported SOAP API Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| AdherenceThreshold | int | Filter, Group, Sort | threshold(분). 상담원이 이 threshold 내에 예정 활동을 시작하면 shift segment 활동이 adherence(준수) 상태. |
| Category | picklist | Filter, Group, Restricted picklist, Sort | shift segment 유형의 카테고리. 값: `Break`(커피·점심 등 휴식), `NonWork`(교육·회의 등 비근무), `Work`(call 응대·chat·case 처리 등 근무) |
| Color | string | Filter, Group, Nillable, Sort | 이 유형의 shift 활동이 UI에 표시될 때 배경색. 3자리 또는 6자리 16진수 형식. 예: #FF00FF. |
| DeveloperName | string | Filter, Group, Sort | API 내 고유 이름. underscore·영숫자만, org 내 unique. 문자로 시작, 공백 불가, underscore로 끝나거나 연속 underscore 불가. Label은 Record Type Name. 자동 생성되나 API 생성 시 직접 지정 가능. |
| FullName | string | Create, Group, Nillable | Metadata API 연관 타입의 full name. namespace prefix 포함 가능(공통 블록). |
| IsActive | boolean | Defaulted on create, Filter, Group, Sort | shift segment type이 활성인지. 기본 true. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | shift segment type의 언어. Workforce Engagement가 지원하는 언어들. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | 패키지 컴포넌트의 manageable state(단축형 — 공통 블록). |
| MasterLabel | string | Filter, Group, idLookup, Sort | shift segment type의 라벨. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | 이 객체와 연관된 namespace prefix(공통 블록). |

### SchedulingObjective (7필드)

Workforce Engagement용 scheduling objective 설정. API 55.0+. (Workforce Engagement 활성 필요. Workforce Engagement Planner permission set 필요)

- **Supported SOAP API Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| DeveloperName | string | Filter, Group, Sort | API 내 고유 이름. underscore·영숫자만, org 내 unique. 문자로 시작, 공백 불가, underscore로 끝나거나 연속 underscore 불가. Label은 Record Type Name. 자동 생성되나 API 생성 시 직접 지정 가능. |
| FullName | string | Create, Group, Nillable | Metadata API 연관 타입의 full name. namespace prefix 포함 가능(공통 블록). |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | scheduling objective의 언어. Workforce Engagement가 지원하는 언어들. |
| MasterLabel | string | Filter, Group, idLookup, Sort | scheduling objective의 라벨. UI에서 이 field는 Scheduling Objective. |
| Metadata | mns:SchedulingObjective | Create, Nillable, Update | scheduling objective의 metadata(공통 쿼리 제한 적용). |
| SchedulingCategory | picklist | Filter, Group, Restricted picklist, Sort | scheduling 로직이 objective를 적용하는 대상. 값: `A`—Service Appointment, `B`—Shift |
| SchedulingObjectiveType | picklist | Filter, Group, Restricted picklist, Sort | scheduling objective의 유형. 값: `AgentPreference`(UI 표시: Maximized Preferences), `BalanceNonStandardShifts`, `BalanceShifts` |

### SchedulingRule (7필드)

Workforce Engagement용 scheduling rule 설정. API 53.0+. (Workforce Engagement 활성 필요. Workforce Engagement Planner permission set 필요)

- **Supported SOAP API Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| DeveloperName | string | Filter, Group, Sort | API 내 고유 이름. underscore·영숫자만, org 내 unique. 문자로 시작, 공백 불가, underscore로 끝나거나 연속 underscore 불가. Label은 Record Type Name. 자동 생성되나 API 생성 시 직접 지정 가능. |
| FullName | string | Create, Group, Nillable | Metadata API 연관 타입의 full name. namespace prefix 포함 가능(공통 블록). |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | scheduling rule의 언어. Workforce Engagement가 지원하는 언어들. |
| MasterLabel | string | Filter, Group, idLookup, Sort | scheduling rule의 라벨. UI에서 이 field는 Scheduling Rule. |
| Metadata | mns:SchedulingRule | Create, Nillable, Update | scheduling rule의 metadata(공통 쿼리 제한 적용). |
| SchedulingCategory | picklist | Filter, Group, Restricted picklist, Sort | **Required.** scheduling 로직이 rule을 적용하는 대상. 값: `A`—Service Appointment, `B`—Shift |
| SchedulingRuleType | picklist | Filter, Group, Restricted picklist, Sort | rule의 유형. 값(8): `A`—Active Resources, `B`—Match Skills, `C`—Availability, `LimitNonstandardShifts`(상담원당 비표준 shift 배정 수 제한, API 54.0+), `M`—Match Territory, `Q`—Match Queues, `RestTimeMinutes`(연속 shift 사이 최소 휴식 시간(분)을 충족한 resource를 찾음, API 56.0+), `W`—Work Limit |

### TimeSheetTemplateAssignment (2필드)

time sheet template을 profile에 배정한 것을 나타낸다. API 48.0+. (Field Service 활성 필요. Customize Application 및 Time Sheet Template 권한 필요)

- **Supported SOAP Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST HTTP Methods:** GET
- **Limitations:** SOQL Limitations, SOSL Limitations

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| AssignedToId | reference | Create, Filter, Group, Nillable, Sort, Unique, Update | time sheet template에 배정된 user profile의 ID. |
| TimeSheetTemplateId | reference | Create, Filter, Group, Sort, Update | 연관된 time sheet template의 ID. |

> **BOUNDARY — TimeSheetTemplate 본체:** time sheet template 본체(TimeSheetTemplate 객체)는 Field Service 소관으로 이미 별 노트에 있어 본 노트에서 제외하고, **Assignment(2필드)만 Tooling facet으로 기재**한다. Field Service/Scheduler 워크포스 데이터 모델은 [[Salesforce Scheduler 표준객체 — 리소스·영역·스킬·시프트]] 참조.

---

## 5. 가상 방문 (1객체)

### VirtualVisitConfig (17필드)

external video provider의 구성. Salesforce에서 provider로 event를 relay한다. API 56.0+. (Virtual Visit 기능 사용에는 Video Call 라이선스 add-on 필요)

- **Supported SOAP API Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| ComprehendServiceType | picklist | Filter, Group, Nillable, Restricted picklist, Sort | speech를 text로 변환하거나 변환된 speech text를 분석하는 데 쓰는 service 유형. 값: `ComprehendMedicalService`(Transcribe Medical), `ComprehendService`(Transcribe) |
| DeveloperName | string | Filter, Group, Sort | Required. VirtualVisitConfig 객체의 API 내 고유 이름. underscore·영숫자만, org 내 unique. 문자로 시작, 공백 불가, underscore로 끝나거나 연속 underscore 불가. Label은 Record Type Name. |
| ExperienceCloudSiteUrl | string | Filter, Group, Nillable, Sort | Video Call 컴포넌트가 portal/guest 사용자에게 제공되는 Digital Experience site의 URL. |
| ExternalRoleIdentifier | string | Filter, Nillable, Sort | 사용자가 video call에 참여하도록 허용하고 call 참여에 필요한 특정 기능에 임시 접근을 부여하는 role의 ID. |
| FullName | string | Create, Group, Nillable | Metadata API 연관 VirtualVisitConfig의 full name. namespaceprefix 포함 가능(공통 블록). |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | VirtualVisitConfig의 언어. |
| ManageableState | picklist | Filter, Group, Nillable, Restricted picklist, Sort | 패키지 컴포넌트의 manageable state(서술형 — 공통 블록). |
| MasterLabel | string | Filter, Group, Sort | VirtualVisitConfig의 라벨. UI에서 이 field는 Virtual Visit Config. |
| MessagingRegion | string | Filter, Group, Nillable, Sort | waiting room·messaging channel 데이터가 처리·저장되는 region. API 57.0+. |
| Metadata | EventRelayConfig | Create, Nillable, Update | VirtualVisitConfig의 metadata. |
| NamedCredentialId | reference | Filter, Group, Nillable, Sort | video call vendor 계정을 인증·인가하는 데 쓰는 named credential record. **관계 field** — RelName=`NamedCredential`, RelType=Lookup, RefersTo=`NamedCredential`. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | 이 객체와 연관된 namespace prefix(공통 블록). |
| StorageBucketName | string | Filter, Group, Nillable, Sort | meeting transcript를 저장하는 storage bucket 이름. |
| UsageType | picklist | Filter, Group, Nillable, Restricted picklist, Sort | video call 구성 record가 생성된 Salesforce 기능 이름. 값: `CHIME`(Chime), `INTELLIGENT_FORM_READER`(Intelligent Form Reader), `SENTIMENT_ANALYSIS`(Sentiment Analysis) |
| VideoCallApptTypeValue | string | Filter, Group, Nillable, Sort | video appointment type을 나타내는 Service Appointment 객체의 Default Appointment Type picklist 값들. 여러 값은 세미콜론으로 구분. |
| VideoControlRegion | string | Filter, Group, Nillable, Sort | Video Call 관련 API call이 이루어지는 region. API 57.0+. |
| VisitRegion | picklist | Filter, Group, Nillable, Restricted picklist, Sort | Video Call의 video·audio 데이터가 처리되는 region. 값(21, AWS region): `af-south-1`(Africa-Cape Town), `ap-east-1`(Asia Pacific-Hong Kong), `ap-northeast-1`(Asia Pacific-Tokyo), `ap-northeast-2`(Asia Pacific-Seoul), `ap-northeast-3`(Asia Pacific-Osaka), `ap-south-1`(Asia Pacific-Mumbai), `ap-southeast-1`(Asia Pacific-Singapore), `ap-southeast-2`(Asia Pacific-Sydney), `ca-central-1`(Canada-Central), `eu-central-1`(Europe-Frankfurt), `eu-north-1`(Europe-Stockholm), `eu-south-1`(Europe-Milan), `eu-west-1`(Europe-Ireland), `eu-west-2`(Europe-London), `eu-west-3`(Europe-Paris), `me-south-1`(Middle East-Bahrain), `sa-east-1`(South America-São Paulo), `us-east-1`(US East-N. Virginia), `us-east-2`(US East-Ohio), `us-west-1`(US West-N. California), `us-west-2`(US West-Oregon) |

---

## 공통 블록

> 여러 객체에 verbatim으로 반복되는 boilerplate field/enum의 전체 정의. 누락 방지를 위해 값은 여기에 전수 보존하며, 각 객체 표는 "(공통 블록)"으로 참조한다.

### NamespacePrefix (string)

이 객체와 연관된 namespace prefix. managed package를 만드는 각 Developer Edition org는 unique한 namespace prefix를 가진다. **Limit: 15자.** `namespacePrefix__componentName` 표기로 managed package의 컴포넌트를 참조한다. 값:
- Developer Edition org: 이 prefix가 지원되는 모든 객체에 org의 namespace prefix가 설정된다. 단 객체가 설치된 managed package에 속하면 그 설치 패키지의 namespace prefix를 가진다.
- 비 Developer Edition org: 설치된 managed package의 일부인 객체에만 설정되고, 그 외 객체는 namespace prefix가 없다.
- publisher가 Salesforce면 NamespacePrefix는 null.

> 서비스 카탈로그 객체(SvcCatalog*)는 위 일반형 대신 "이 (카테고리/카탈로그 항목/fulfillment flow)와 연관된 namespace"라는 축약형 설명을 쓴다.

### ManageableState

패키지에 포함된 컴포넌트의 manageable state. **두 가지 텍스트 변형이 PDF에 공존하며 모두 보존한다.**

**서술형** (ConversationChannelDefinition, SvcCatalog* 4종, VirtualVisitConfig):
- `beta`—Managed-Beta
- `deleted`—Managed-Proposed-Deleted
- `deprecated`—Managed-Proposed-Deprecated
- `deprecatedEditable`—SecondGen-Installed-Deprecated
- `installed`—Managed-Installed
- `installedEditable`—SecondGen-Installed-Editable
- `released`—Managed-Released
- `unmanaged`—Unmanaged

**단축형** (ConversationVendorInfo, ExtConvParticipantIntegDef, ShiftSegmentType, WorkSkillRouting):
- `beta`, `deleted`, `deprecated`, `deprecatedEditable`, `installed`, `installedEditable`, `released`, `unmanaged`

> Type 표기도 객체별로 `ManageableState enumerated list`(ConversationChannelDefinition·ConversationVendorInfo·ShiftSegmentType·WorkSkillRouting) 또는 `picklist`(ExtConvParticipantIntegDef·SvcCatalog*·VirtualVisitConfig)로 갈린다. Properties는 공통적으로 Filter, Group, Nillable, Restricted picklist, Sort.

### FullName / Metadata 쿼리 제한 문구

`FullName`·`Metadata` field를 보유한 객체에 공통 적용:

> Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance.

즉 **결과가 1 record 이하일 때만 쿼리**하라(성능 보호). 초과 시 에러 → 여러 쿼리로 나눠 조회.

---

## 관련 노트
- [[Tooling API — 개요·REST·SOAP 호출 기초]] — Tooling API 호출 기초·허브
- [[Tooling API — Objects and Namespaces (객체 분류)]] — 전체 객체 분류 카탈로그
- [[Tooling API 객체 — Embedded Service (임베디드 챗·채널 메뉴·약속관리)]] — 같은 Service 도메인 임베디드 위젯 sObject
- [[Tooling API 객체 — 통합·데이터·결제·마케팅 (외부서비스·Data Kit·페이먼트·Account Engagement)]] — 같은 C4-9 그룹 형제 노트(통합·데이터·결제·마케팅 sObject)
- [[Omni-Channel 객체·메타데이터·콘솔 컴포넌트]] — Omni-Channel 런타임 객체·콘솔 (Service 도메인)
- [[Omni-Channel External Routing]] — 외부 라우팅 (Service 도메인)
- [[Salesforce Scheduler 표준객체 — 리소스·영역·스킬·시프트]] — Scheduler 표준객체(Skill 등)
- [[Salesforce Scheduler — 개요·셋업·데이터모델·인증·SOQL]] — Scheduler 개요
