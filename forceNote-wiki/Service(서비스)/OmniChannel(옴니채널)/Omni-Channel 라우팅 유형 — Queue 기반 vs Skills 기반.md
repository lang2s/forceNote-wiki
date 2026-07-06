---
tags: [service, service-cloud, omni-channel, routing, queue-based-routing, skills-based-routing, direct-to-agent, external-routing, routing-configuration, skill-requirement, omni-channel-flow]
source: service_presence_administrators.pdf (Omni-Channel for Administrators, Spring '26, Tier 2) + object_reference.pdf (PendingServiceRouting·QueueRoutingConfig·SkillRequirement) + api_meta.pdf (WorkSkillRouting)
official_doc: https://help.salesforce.com/s/articleView?id=service.service_presence_intro.htm
created: 2026-07-05
aliases: [Omni-Channel Routing Types, Queue-based Routing, Skills-based Routing, Direct-to-Agent Routing, Routing Configuration, Skills-Based Routing Rules, WorkSkillRouting, 큐 기반 라우팅, 스킬 기반 라우팅, 라우팅 유형, 라우팅 구성, 어떤 라우팅 써야 해]
---

# Omni-Channel 라우팅 유형 — Queue 기반 vs Skills 기반

> Omni-Channel의 4가지 라우팅 목적지(Queue·Skill·Agent·Bot)와 라우팅 유형별 개념·동작 방식·설정 절차·선택 기준. Queue 기반(QueueRoutingConfig: 우선순위·모델·capacity)과 Skills 기반(Skills-Based Routing Rules·Omni-Channel Flow·Apex + SkillRequirement) 중심. (`service_presence_administrators.pdf` — Omni-Channel for Administrators, Spring '26)

> [!note] Salesforce는 **Enhanced Omni-Channel** 사용을 권장한다. Standard Omni-Channel은 개발자 가이드 기준 Summer '26(v67.0)으로 EOL이며, 향후 기능은 Enhanced 위에서 개발된다. 이 노트의 라우팅 개념(목적지·유형·설정 필드)은 양쪽에 공통 적용되는 기반 개념이다.

> 📂 형제 노트: [[Omni-Channel 객체·메타데이터·콘솔 컴포넌트]] (객체·콘솔 API 레퍼런스) · [[Omni-Channel External Routing]] (서드파티 라우팅 통합)

---

## 전체 그림 — 목적지 4가지 × 설정 방법 5가지

Omni-Channel은 정의된 라우팅 로직에 따라 work item을 라우팅한다. 관리자 가이드는 **"어디로 보내는가"(Routing Destination)** 와 **"어떻게 규칙을 구성하는가"(Routing Rules)** 를 분리해 설명한다.

**라우팅 목적지 (Choose Your Routing Destination):**

| 목적지 | 설명 |
|---|---|
| **Route to a Queue** | 팀(에이전트 그룹)에 워크로드를 분배. 큐 멤버 중 가용·capacity 있는 에이전트에게 push |
| **Route to a Skill** | work item이 요구하는 **모든 스킬**을 가진 에이전트에게 라우팅 (skills-based routing) |
| **Route to an Agent** | 선호(preferred) 에이전트에게 직접 라우팅 (Direct-to-Agent). 예: 기존 고객의 영업 전화를 담당 AE에게 |
| **Route to a Bot** | enhanced Messaging 채널에서 대화를 enhanced bot으로 라우팅 (Omni-Channel Flow 사용) |

**라우팅 규칙 구성 방법 (Configure Your Routing Rules):**

| 방법 | 설명 |
|---|---|
| **Basic Routing** | 채널(chat button·phone channel·messaging channel)에서 Routing Type = Queue를 지정해 큐로 직행 |
| **Omni-Channel Flow** (Advanced) | Flow Builder에서 라우팅 규칙 정의. voice·chat·messaging·case·lead·custom object 전 채널 라우팅 설정을 통합. queue·skills·agent·bot 모두 목적지 가능 |
| **Skills-Based Routing Rules** | work-item 필드 값 → 스킬 매핑(skill mapping set)을 선언적으로 정의 |
| **Routing Salesforce and Partner Channels** | Service Cloud Voice로 텔레포니 통합 시 Omni-Channel이 라우팅 지시를 텔레포니 라우팅 엔진에 전달 |
| **External Routing** | 서드파티 라우팅 엔진이 라우팅 결정을 수행 (표준 API + streaming API 통합, 커스텀 코드 필요) |

---

## 1. Queue 기반 라우팅 (Queue-Based Routing)

### 동작 방식

Omni-Channel은 두 개의 분리된 프로세스로 큐의 작업을 라우팅한다.

1. **새 work item이 Omni-Channel 큐에 할당될 때** — 큐의 **priority** 순으로 먼저 push하고, 같은 priority면 **큐에서 오래 기다린 것**부터 push한다.
2. **에이전트의 수용 능력이 변할 때** (away 복귀, 다른 작업 완료 등) — 그 에이전트에게 라우팅할 수 있는 대기 작업을 찾는다.

핵심 흐름: work item이 큐에 할당되고 그 큐에 **Routing Configuration이 연결돼 있으면** 라우팅 대기 목록에 추가된다 → Omni-Channel이 `UserServicePresence`로 에이전트 가용성·capacity를 판단 → 올바른 Service Channel에 연결된 Presence Status로 온라인인 에이전트 중 capacity가 있는 에이전트에게 routing model(Least Active / Most Available)에 따라 push. 동점이면 **가장 오래 전에 작업을 받은** 에이전트에게 라우팅.

- 에이전트가 거절하거나 push time-out으로 미수락하면 work item은 원래 큐로 소유자가 되돌아가고 **원래 age를 유지한 채** 다른 에이전트를 찾아 재라우팅된다. 같은 item을 같은 에이전트에게 다시 라우팅하지 않는다 (단, B가 거절하면 A에게 다시 갈 수 있음).
- ⚠️ **큐에 routing configuration이 없으면 Omni-Channel은 그 큐의 작업을 라우팅하지 않는다.**
- assignment·auto-response·escalation·workflow rule은 Omni-Channel이 라우팅해 에이전트가 수락하는 시점엔 **트리거되지 않는다** — 수락 후 레코드를 편집·저장할 때 트리거된다.

### 설정 절차 (Setup 경로)

```
// 순서 요약 (Setup 절차 — 관리자 가이드 원문 순서)
1. Setup → Queues → New                          : 큐 생성 (라벨·객체·멤버)
2. Setup → Routing Configurations → New          : 라우팅 구성 생성 (service channel별 1개 권장)
3. 큐 편집 → Routing Configuration 필드에 연결    : 큐 ↔ 라우팅 구성 연결
4. Queue Members에 에이전트 추가                  : 작업을 받을 에이전트 지정
(선택) 채널별 Basic Routing: Chat Buttons & Invitations / Voice 컨택센터 / Messaging Settings에서
       Routing Type = Queue 선택 후 대상 큐 지정
```

- 큐 개수 제한은 없지만 **한 batch에서 수정(insert/update/delete)할 수 있는 큐는 16개**까지.
- 큐 이름에 **콤마(,) 사용 불가**.
- 작업은 **큐 멤버에게만** 라우팅된다 (멤버의 매니저 제외, guest user는 멤버 불가).

### Routing Configuration 설정 필드 (핵심)

| 설정 | 역할 |
|---|---|
| **Routing Priority** | 이 구성에 연결된 큐의 work item이 라우팅되는 순서. **숫자가 낮을수록 먼저** 라우팅 (예: 고품질 리드=1, 저품질 리드=2) |
| **Routing Model** | `Least Active` 또는 `Most Available` (아래 표) |
| **Push Time-Out (seconds)** | 에이전트가 응답해야 하는 제한 시간. 초과 시 다른 에이전트에게 push되고 상태 변경. Voice는 텔레포니 제약 적용 — Amazon Connect는 20초로 제한 |
| **Drop Additional Skills Time-out (seconds)** | additional 스킬을 드롭하기 전 대기 시간 (skills 기반에서 사용) |
| **Capacity Type** | work item이 primary(중단 불가)인지 interruptible인지, Service Channel 설정 상속인지 |
| **Units / Percentage of Capacity for In-Progress Work Items** | 이 구성의 큐에서 할당된 진행 중 work item이 에이전트 전체 capacity에서 소비하는 양 — **단위 또는 퍼센트 중 하나만** 사용 |
| **Units / Percentage of Capacity for Paused Work Items** | 일시정지 작업의 capacity 소비량 (Paused 상태는 **Enhanced Omni-Channel 전용**, status-based capacity에서만 유효, 기본 소비 0) |
| **Overflow Assignee** | org가 Omni-Channel 한도에 도달했을 때 라우팅할 사용자 또는 (routing configuration 없는) 큐 |
| **Use with Skills-Based Routing Rules** | 이 구성을 Skills-Based Routing Rules와 함께 사용 (Omni-Channel Flow 사용 시엔 flow에서 규칙 호출) |

에이전트의 **전체 capacity**는 에이전트가 배정된 **Presence Configuration의 Capacity 설정**이 결정한다.

**Routing Model 옵션 (Least Active vs Most Available):**

| 모델 | 로직 | 공식 예시 (A: 총 5유닛·활성 3 / B: 총 10유닛·활성 5, weight 각 1) |
|---|---|---|
| **Least Active** | **사용 중 capacity가 가장 적은** 에이전트에게 라우팅. 동점이면 가장 오래 전에 작업 받은 에이전트 | A 사용=3 < B 사용=5 → **A에게** 라우팅 |
| **Most Available** | **가용 capacity가 가장 큰** 에이전트에게 라우팅. 동점이면 가장 오래 전에 작업 받은 에이전트 | A 가용=5−3=2 < B 가용=10−5=5 → **B에게** 라우팅 |

> 데이터 모델: 라우팅 구성은 `QueueRoutingConfig` sObject다. `RoutingModel`(Least Active/Most Available), `RoutingPriority`(낮을수록 먼저), `PushTimeout`(미설정 시 0 반환), `CapacityWeight`/`CapacityPercentage`, `PausedCapacityWeight`/`PausedCapacityPercentage`(Enhanced 전용), `OverflowAssigneeId` 필드가 위 Setup 설정과 대응한다. (object_reference.pdf)

---

## 2. Skills 기반 라우팅 (Skills-Based Routing)

### 개념·동작 방식

특정 스킬이 필요한 work item을, **요구 스킬을 전부 보유하고** 가용 capacity가 있는 에이전트에게 라우팅한다. 라우팅 시점에 요구 스킬은 세 소스의 조합으로 결정된다.

1. **Routing configuration에 정의된 스킬(static)** — 그 구성으로 라우팅되는 모든 work item에 추가
2. **Skills-based routing rule의 스킬(dynamic)** — work item이 조건을 충족하면 추가
3. **Omni-Channel flow의 스킬(dynamic)** — flow 로직이 조건 충족 시 추가

여러 에이전트가 해당 스킬을 가지면 routing model(Most Available/Least Active)에 따라 첫 가용 에이전트에게 라우팅된다. 스킬은 레코드가 **Omni-Channel 큐에 추가될 때** 평가된다 — 큐에 있는 레코드를 편집해도 스킬 변경은 반영되지 않으며, 큐에 재할당해야 한다. 요구 스킬을 가진 에이전트가 아무도 없으면 라우팅되지 않는다 (Omni Supervisor의 **Skills Backlog** 탭에서 확인).

**Additional Skills (드롭 가능한 부가 스킬):** primary 스킬에 더해 additional 스킬을 정의할 수 있다 (예: primary=태양광 패널 설치, additional=스페인어). 처음엔 모든 스킬 보유 에이전트를 찾고, 없으면 **timeout(Drop Additional Skills Time-out) 후 additional 스킬을 드롭**한다. **priority 값이 높은 스킬부터 드롭** (5가 4보다 먼저), priority 0 또는 미지정 스킬은 마지막에 드롭. 같은 priority 스킬은 그룹으로 함께 드롭. 에이전트가 거절하거나 오프라인이 되면 요구 스킬과 타이머가 **원래대로 리셋**되어 드롭 과정을 처음부터 다시 시작한다.

### 사전 준비 (공통 prerequisite)

```
// 순서 요약 (Setup 절차 — 관리자 가이드 원문 순서)
1. Setup → Omni-Channel Settings → "Enable Skills-Based and Direct-to-Agent Routing" 체크 → Save
2. Setup → Omni-Channel → Skills → New            : 스킬 정의 (예: Spanish, CCNP)
   ⚠️ Assign Users / Assign Profiles 섹션은 건너뛰고, 스킬은 Service Resource에 부여
3. Service Resources 탭 → 에이전트별 Service Resource 생성 (Active 체크, Resource Type=Agent)
4. Service Resource → Skills related list → New Service Resource Skill
   : 스킬 + 스킬 레벨(0–10) + 시작일/종료일(예: 6개월 재인증)
```

> Service Resource가 없는 에이전트는 오프라인일 때 Omni Supervisor에 표시되지 않는다.

### 구현 방식 — 3가지

**방식 A — Omni-Channel Flow (권장, 최대 유연성)**

Flow가 skills-based routing rules에 없는 기능을 제공하며 work item별로 스킬 요건을 동적으로 정의할 수 있고, flow 안에서 skills-based routing rules도 실행할 수 있다.

1. **Add Skill Requirements** 액션 — 스킬(또는 Skill ID 변수)·skill level·additional 여부·priority 지정. 액션당 **최대 10개 스킬**, 한 work item 라우팅 flow 전체에서 **최대 20개 스킬** 정의 가능. `skillList` 변수로 스킬을 누적 집계 가능.
2. **Route Work** 액션 — Route To = **Skills** 선택. Skill Requirements는 ①Define Skill Requirements(Add Skill Requirements 액션 출력 `{!AddSkill.skillRequirements}` 지정) ②Run Skills-Based Routing Rules ③Both 중 선택. Routing Configuration은 **Use with Skills-Based Routing Rules가 비활성인 구성**을 지정하거나 변수 사용. Single(1건) 또는 Multiple(최대 100건, 1건이라도 못 찾으면 전체 롤백) 라우팅.

> Route Work 액션은 flow의 마지막 요소다. Route Work 액션 호출 시 debug log는 생성되지 않는다. flow를 service channel에 할당해야 flow로 라우팅된다.

**방식 B — Skills-Based Routing Rules (선언적 — skill mapping set)**

work-item **필드 값 → 스킬 매핑**을 정의한다. 예: Case Type 필드 값 `Product Return` → `Returns Processing` 스킬.

```
// 순서 요약 (Setup 절차 — 관리자 가이드 원문 순서)
1. 큐가 사용하는 Routing Configuration에서 "Use with Skills-Based Routing Rules" 체크
   + Drop Additional Skills Time-Out 지정 (+ 선택: static 스킬 추가)
2. Setup → Skills-Based Routing Rules → New Skill Mapping Set
3. 이름·developer name·라우팅할 객체 선택 (객체당 mapping set 1개)
4. 라우팅 기준 필드 선택 — picklist·boolean·lookup 타입 표준/커스텀 필드, 최대 10개 필드·100개 필드 값
5. 필드 값별 스킬·skill level·additional 여부·드롭 priority 매핑 → Done
6. mapping set Activate / Deactivate로 객체 라우팅 시작·중지
```

- 지원 객체: **case, chat transcript, contact request, lead, messaging session, order, social post, custom object**.
- ⚠️ routing configuration에 skills-based routing rules를 활성화해 큐에 할당하면 **그 큐의 멤버십은 라우팅에 더 이상 적용되지 않는다** — 올바른 스킬을 가진 가용 에이전트에게 라우팅되고, 스킬 매핑 조건 미충족으로 스킬이 없으면 org의 **아무 가용 에이전트**에게나 라우팅된다.
- 매핑은 **라우팅 시점에만** 적용된다 (레코드 값 업데이트 시점 아님).
- 이 매핑의 Metadata API 타입이 **`WorkSkillRouting`**(+ `WorkSkillRoutingAttribute`, API v46.0+, suffix `.workSkillRouting`)이다. 샘플의 masterLabel이 "**Attribute setup** for skills-based routing for Case object"인 데서 보듯, 과거 문서의 "Attribute Setup" 방식이 곧 지금의 Skills-Based Routing Rules다.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<WorkSkillRouting xmlns="http://soap.sforce.com/2006/04/metadata">
    <isActive>true</isActive>
    <masterLabel>Attribute setup for skills-based routing for Case object</masterLabel>
    <relatedEntity>Case</relatedEntity>
    <workSkillRoutingAttributes>
        <field>Case.Origin</field>
        <isAdditionalSkill>false</isAdditionalSkill>
        <skill>Technical_Skill</skill>
        <skillLevel>3</skillLevel>
        <skillPriority>2</skillPriority>
        <value>Web</value>
    </workSkillRoutingAttributes>
</WorkSkillRouting>
```
(api_meta.pdf의 WorkSkillRouting 선언적 메타데이터 샘플 원문 발췌)

**방식 C — Apex로 PSR + SkillRequirement 수동 생성 (비권장)**

flow가 지원하지 않는 복잡한 케이스(세밀한 우선순위, 재오픈·전송·재할당 등)에는 Apex로 `PendingServiceRouting` 레코드를 직접 생성·업데이트할 수 있다. 단, 관리자 가이드 원문: *"doing so isn't recommended unless absolutely necessary"* — **꼭 필요한 경우가 아니면 비권장**이며, 공식 권장은 Omni-Channel flow 또는 skills-based routing rules다. skill priority도 skills-based routing rules 또는 Apex 코드로 설정 가능하다(object_reference.pdf).

```apex
// 구조 예시 — 실제 동작 코드 아님 (객체·필드는 object_reference.pdf 정의와 일치, 완성 코드는 소스에 없음)
// 1) 스킬 기반 PSR 생성 — RoutingType 픽리스트: QueueBased | SkillsBased
PendingServiceRouting psr = new PendingServiceRouting(
    ServiceChannelId = '<ServiceChannelId>',
    WorkItemId       = '<WorkItemId>',
    RoutingType      = 'SkillsBased',
    RoutingPriority  = 1,            // skills-based에서만 고려됨 (queue-based는 routing config가 결정)
    RoutingModel     = 'MostAvailable',
    CapacityWeight   = 1,
    IsReadyForRouting = false        // SkillRequirement 부착 전까지 false 유지
);
insert psr;

// 2) 요구 스킬 부착 — PSR 1건에 SkillRequirement 여러 건 연결 가능 (API v42.0+)
insert new SkillRequirement(
    RelatedRecordId   = psr.Id,      // polymorphic — PSR·WorkOrder·WorkType 등
    SkillId           = '<SkillId>',
    SkillLevel        = 5,           // 0 ~ 99.99
    IsAdditionalSkill = false,       // true면 timeout 후 드롭 대상
    SkillPriority     = 0            // 높은 값부터 드롭, 0은 마지막
);

// 3) 라우팅 준비 완료 표시 — true가 되면 PSR 편집 불가
psr.IsReadyForRouting = true;
update psr;
```

### Skills 기반 라우팅 제한사항 (공식 Limitations 전수)

- **External routing에서는 지원되지 않는다.**
- **Voice Calls를 지원하지 않는다.**
- **Estimated wait time을 지원하지 않는다.**
- Chat에서 다음 전송(transfer)은 미지원: 큐→스킬 / 스킬→큐(Service Chat·Embedded Chat 표준 채널의 chat 전송은 예외) / 스킬→사용자·버튼 직접 전송.
- Secondary Routing Priority는 skills-based로 라우팅된 chat·messaging 채널에서 자동 업데이트되지 않는다.

에디션: Skills 기반은 **Lightning Experience** 전용 — Professional, Enterprise, Unlimited, Developer(Service Cloud). Queue 기반은 Salesforce Classic(일부 org 제외)·Lightning Experience — Essentials, Pro Suite, Professional, Enterprise, Performance, Unlimited, Developer.

---

## 3. Direct-to-Agent 라우팅 (특정 에이전트 직행)

선호 에이전트에게 work item을 직접 라우팅한다. Omni-Channel flow의 **Route Work** 액션에서 Route To = **Agent**를 선택하고, 에이전트를 직접 지정하거나 변수(예: Contact의 preferred agent lookup 필드에서 Agent ID 전달)로 지정한다.

- **voice call을 제외한** work item 라우팅에는 Omni-Channel Settings의 **Enable Skills-Based and Direct-to-Agent Routing** 활성화가 필수다. voice call을 특정 에이전트에게 라우팅할 때는 이 옵션이 필요 없다(선택하지 말 것).
- **Required Agent** 체크: 그 에이전트가 가용해질 때까지 기다렸다가 그 에이전트에게만 할당 (+ Routing Configuration 지정). voice call은 Required Agent 미지원. **Required Agent 사용 시 Push Time-Out과 Allow Agents to Decline Work Requests 설정은 무시된다.**
- Required Agent 해제 시: 선호 에이전트가 불가하면 지정한 **backup queue**로 라우팅.

> External Routing 환경에서 특정 담당자 전달은 PSR의 `PreferredUserId` 메커니즘을 쓴다 — [[Omni-Channel External Routing]]의 "특정 담당자에게 전달 (PreferredUserId)" 참조.

---

## 4. External Routing (서드파티 라우팅)

서드파티(파트너) 라우팅 엔진이 라우팅 결정을 수행하고 Salesforce 표준 API·streaming API(CDC 구독 + AgentWork 생성)로 결과를 반환하는 방식. 파트너 통합 지원과 커스텀 코드가 필요하다.

> 아키텍처·CDC 구독(Pub/Sub API·Apex Trigger)·AgentWork 생성·시나리오·트러블슈팅 상세는 [[Omni-Channel External Routing]] 참조. **External routing에서는 skills-based·direct-to-rep 라우팅이 지원되지 않는다**는 점만 이 노트 소관으로 재확인한다.

관리자 가이드의 voice 라우팅 접근법 비교 (SCV+Omni-Channel Flow vs External Routing 원문 표):

| 특성 | SCV + Omni-Channel Flows | External Routing |
|---|---|---|
| Omni-Channel 컴포넌트의 통합 에이전트 경험·screen pop 자동화 | Yes | No |
| 멀티채널 통합 슈퍼바이저 경험·인사이트 | Yes | No |
| 전 채널 통합 리포트·대시보드 | Yes | No |
| 구현 복잡도 | Low | High (파트너 지원 + 커스텀 코드 필요) |

---

## 비교표 — 4가지 라우팅 유형 한눈에

| | **Queue 기반** | **Skills 기반** | **Direct-to-Agent** | **External Routing** |
|---|---|---|---|---|
| 매칭 기준 | 큐 멤버십 + priority + 대기 시간 | work item 요구 스킬 전부 보유 여부 | 지정한 특정 에이전트 | 서드파티 엔진의 자체 로직 |
| 핵심 설정물 | Queue + Routing Configuration (`QueueRoutingConfig`) | 스킬 + Service Resource Skill + (flow / routing rules / Apex) + `SkillRequirement` | Omni-Channel Flow Route Work(Agent) ± Required Agent | External Routing용 별도 Routing Configuration·Queue + CDC + AgentWork 생성 코드 |
| 사전 토글 | 없음 (Omni-Channel 활성화만) | Enable Skills-Based and Direct-to-Agent Routing | Enable Skills-Based and Direct-to-Agent Routing (voice 제외) | Routing Model = External Routing |
| PSR `RoutingType` 값 | `QueueBased` | `SkillsBased` | (flow 기반 — 큐 fallback 여부에 따름) | `RoutingModel = ExternalRouting` |
| Voice 지원 | 지원 | **미지원** | 지원 (단 Required Agent·토글 예외) | 지원 (SCV 대비 경험 통합도 낮음) |
| UI | Classic + LEX | **LEX 전용** | LEX (flow) | Classic + LEX |
| 구현 난이도 | 낮음 | 중간 (스킬 모델 설계 필요) | 낮음~중간 (flow) | **높음** (파트너 지원 + 커스텀 코드) |

---

## 선택 기준 — 언제 뭘 쓰나

공식 문서의 차이 정의: **"큐는 일반적으로 하나의 스킬을 대표하도록 설계된다"** (예: 스페인어 큐, L3 기술지원 큐). Queue 기반은 큐 멤버에게 라우팅하고, Skills 기반은 **요구 스킬을 전부 가진** 에이전트에게 라우팅한다 — 즉 skills-based가 더 정교하고(sophisticated) 동적인(dynamic) 기준을 제공한다.

| 상황 | 선택 |
|---|---|
| 팀 단위로 워크로드만 분배하면 됨 (단일 축 분류: 부서·티어) | **Queue 기반** — 설정 최소, 모든 에디션·Classic 지원, voice 지원 |
| 한 work item에 **여러 속성 동시 매칭** 필요 (언어 × 제품 × 인증 등) | **Skills 기반** — 큐 조합 폭발(스페인어×하드웨어×L3 큐를 다 만드는 문제) 대신 스킬 조합으로 해결 |
| 매칭이 안 될 때 점진적으로 조건을 풀고 싶음 | **Skills 기반 + Additional Skills** — timeout 후 priority 순 드롭 |
| 필드 값으로 정적 매핑이면 충분 | **Skills-Based Routing Rules** (선언적) |
| 조건 분기·레코드 조회·wait time 체크 등 동적 로직 필요 | **Omni-Channel Flow** (+ 필요 시 flow에서 routing rules 실행) |
| 기존 고객을 담당자에게 (연속성·에스컬레이션) | **Direct-to-Agent** (내부) / `PreferredUserId` (external) |
| 이미 보유한 파트너 라우팅 엔진을 유지해야 함 | **External Routing** — 단, skills-based·direct-to-rep 미지원, 통합 경험·리포트 포기, 높은 복잡도. 가능하면 SCV+Omni-Channel Flow 권장 |

**혼용 규칙:**

- 같은 org에서 **queue 기반과 skills 기반을 함께 사용할 수 있다** — 특정 work item은 큐로, 다른 work item은 스킬로 라우팅하도록 나눠 설정한다.
- ⚠️ **External routing과 Omni-Channel(내부) 라우팅의 동시 사용은 강력 비권장** — 같은 work item이 같은 에이전트에게 중복 할당돼 capacity 추적이 깨질 수 있다. 같은 에이전트가 양쪽 큐에 있으면 capacity 초과 위험 ([[Omni-Channel External Routing]]).
- ⚠️ skills-based routing rules를 켠 routing configuration을 큐에 할당하면 **큐 멤버십이 무시**되므로, "큐 멤버 제한 + 스킬"을 동시에 기대하지 말 것.

---

## 관련 노트
- [[Omni-Channel 객체·메타데이터·콘솔 컴포넌트]] — 객체 24종·Metadata API 타입 11종·콘솔 API 레퍼런스
- [[Omni-Channel External Routing]] — 서드파티 라우팅 통합 상세 (CDC·AgentWork·시나리오)
- [[Queues (큐)]] — 큐 일반 개념 (멤버·assignment rule)
- [[Case Assignment & Escalation Rules (케이스 배정·에스컬레이션 규칙)]] — Assignment Rule → Omni 큐 실행 순서·Omni-Channel Flow 사용 시 assignment rule 회피·이중 라우팅 주의
- [[Service Cloud Objects]] — PendingServiceRouting·AgentWork 등 필드 상세
- [[Tooling API 객체 — Service·OmniChannel (라우팅·대화채널·서비스카탈로그·스케줄링)]] — QueueRoutingConfig·ServiceChannel의 Tooling API facet
