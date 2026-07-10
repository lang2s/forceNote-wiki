---
tags: [flow, orchestration, flow-orchestration, stage, step, work-item, evaluation-flow, mulesoft, automation]
source: extend_click_automate.pdf (Automate Your Business Processes, Spring '26)
created: 2026-07-10
aliases: [Flow Orchestration, 플로우 오케스트레이션, 오케스트레이션, Orchestration Stage, Interactive Step, Background Step, MuleSoft Step, Evaluation Flow, 평가 플로우, isOrchestrationConditionMet, Work Guide, 오케스트레이션 만들기, 오케스트레이션 배포]
---

# Flow Orchestration

> 여러 사용자·여러 시스템이 관여하는 다단계 비즈니스 프로세스를 Stage(순차)와 Step(interactive·background·MuleSoft)으로 조립하는 자동화. 개념 → 구축(Build) → 배포(Deploy)까지. 운영(Run·Manage·Troubleshoot)·한도·레퍼런스는 [[Flow Orchestration - 운영과 레퍼런스]] 참조.

---

## 개요 — 오케스트레이션이란

오케스트레이션(orchestration)은 **stage의 시퀀스**이며, 각 stage는 1개 이상의 **step**으로 구성된다. Stage에는 background·interactive·MuleSoft step을 담을 수 있다.

| Step 타입 | 실행 대상 | 사용자 상호작용 | 실행 방식 |
|---|---|---|---|
| **Interactive step** | 지정된 screen flow | 필요 (user/group/queue에 배정) | 배정된 사용자가 Work Guide에서 완료 |
| **Background step** | autolaunched flow (Salesforce가 실행) | 없음 | 동기 또는 비동기 |
| **MuleSoft step** | MuleSoft action (Salesforce가 실행) | 없음 | 항상 비동기 |

Interactive step이 실행되면 지정된 사용자에게 배정 작업 링크가 담긴 이메일이 발송되고, 사용자는 링크로 레코드 페이지에 이동해 **Flow Orchestration Work Guide** (Lightning App Builder 컴포넌트)에서 작업을 완료한다.

**언제 쓰나** — 고급 승인 프로세스(advanced approval processes), 그룹 작업 목록(task list), 여러 상호 연관된 단계가 필요한 프로세스. 예: 신규 입사자 온보딩(다단계·다사용자·다시스템 승인으로 장비와 디지털 리소스 접근 권한 부여).

### Flow vs Orchestration 차이

| | Flow | Orchestration |
|---|---|---|
| 정의 | 데이터를 수집하고 org/외부 시스템에서 작업을 수행하는 앱 | **여러 flow를 결합·조율**해 정교한 비즈니스 프로세스를 만드는 앱 |
| 중심 | **record-centric** (특정 오브젝트에 묶이지 않으나 레코드 중심 — 여러 오브젝트 CRUD) | **user-centric** (여러 사용자·여러 부서가 관여하는 프로세스를 하나로 관리) |
| 부가 가치 | 화면으로 사용자 안내 가능 | 운영 모니터링·효율 개선 |

### 요구사항 (Editions · 권한)

- **Edition:** Enterprise, Performance, Unlimited, Developer — Lightning Experience. Government Cloud / Government Cloud Plus 지원.
- Flow Orchestration은 위 에디션에서 **자동 활성화**된다 (usage-based entitlement — 수치는 [[Flow Orchestration - 운영과 레퍼런스]]의 엔타이틀먼트 섹션).

| 작업 | 필요 권한 |
|---|---|
| Flow Builder에서 오케스트레이션 열기·편집·생성 | Manage Flow |
| 배정된 작업 완료·일시정지된 오케스트레이션 resume | Run Flows |
| 오케스트레이션 활성화/비활성화 | Manage Flow |
| **record-triggered** 오케스트레이션 활성화 | Manage Flow + **View All Data** |

---

## Flow Builder UI

Flow Orchestration은 Flow Builder에서 **Auto-Layout 캔버스만** 사용한다. Flow Orchestration 타일은 flow에서 쓸 수 없는 Stage 요소·Step 리소스를 제공하고, 사용 가능한 요소·리소스를 오케스트레이션용으로 제한한다.

1. **Button Bar** — 저장된 최신 버전 실행(Run 버튼 — **autolaunched 오케스트레이션에서만 표시**), 활성/비활성 상태·마지막 저장 시각 표시, 경고/오류 아이콘.
2. **Toolbox** — 변수·상수·수식·텍스트 템플릿 생성, 추가된 리소스·요소 목록 조회.
3. **Canvas** — 요소를 추가·연결하며 다이어그램 확인. 요소 삽입은 원하는 위치의 `+` 클릭.
4. **Details** — 캔버스에서 선택한 요소의 속성 설정 (요소 미선택 시 닫힘).

### 키보드 단축키

| 동작 | macOS | Windows |
|---|---|---|
| Zoom in | Cmd+Option+= | Ctrl+Alt+= |
| Zoom out | Cmd+Option+- | Ctrl+Alt+- |
| Zoom to fit | Cmd+Option+1 | Ctrl+Alt+1 |
| Zoom to view | Cmd+Option+0 | Ctrl+Alt+0 |
| 단축키 목록 보기 | Cmd+/ | Ctrl+/ |

### 오케스트레이션 해부 (Anatomy)

> PDF에 캔버스 스크린샷 다이어그램 있음 — 본 wiki에는 텍스트 설명만.

- **요소(element)** — 오케스트레이션이 실행할 수 있는 액션. 오케스트레이션은 **Stage와 Decision** 요소를 사용한다.
- **커넥터(connector)** — 런타임에 오케스트레이션이 취할 수 있는 경로.
- **step** — 각 stage는 1개 이상의 step으로 구성.
- **리소스(resource)** — stage·step·decision에서 참조할 수 있는 값.

```text
// 구조 예시 — 실제 원본 다이어그램 아님
Start (record-triggered: 레코드 생성/업데이트)
 └─ Stage 1 (순차 실행 — 동시에 1개 stage만 In Progress)
     ├─ Background Step: 계정 생성 (autolaunched flow, 동기)
     ├─ Interactive Step: 관리자 승인 (screen flow → user/group/queue 배정 → Work Item 생성)
     └─ MuleSoft Step: 외부 시스템 프로비저닝 (비동기)
 └─ Decision (조건 분기)
     ├─ Outcome A → Stage 2 → End
     └─ Default Outcome → End
```

---

## 오케스트레이션 타입 3종

New Flow 창의 **All + Templates 탭**에서 선택. 타입이 배포(distribution) 방법을 결정한다.

| 타입 | 배포 방법 | 비고 |
|---|---|---|
| **Autolaunched Orchestration (No Trigger)** | Custom Apex 클래스 · 커스텀 버튼/커스텀 링크 | 트리거를 쓰지 않음 — Apex나 커스텀 URL 등 별도 메커니즘으로 시작 |
| **Record-Triggered Orchestration** | 레코드 생성 또는 업데이트 시에만 실행 | 트리거는 **레코드가 저장된 후** 발생. Start 요소에서 특정 오브젝트의 신규·변경 레코드 지정 |
| **Managed Content Authoring Workflow (Beta)** | Digital Experiences 앱의 Salesforce CMS | CMS용 오케스트레이션. `mContentVariantId`·`mContentSpaceId` 입력 변수 포함 |

> record-triggered **flow**의 순서 제어는 Flow Trigger Explorer 소관 — 오케스트레이션은 복잡한 프로세스 자동화에 사용.

---

## 오케스트레이션의 변수

Autolaunched 오케스트레이션은 호출한 프로세스로부터 입력을 받는 **input 변수**를 쓸 수 있다. Step이 호출한 flow의 출력값 참조는 step의 **automatic output**을 쓴다.

| 변수 | 설명 | 비고 |
|---|---|---|
| Internal-only | 오케스트레이션에는 내부 변수에 값을 할당할 방법이 없다 | — |
| Input | Available for input으로 표시된 사용자 정의 변수. autolaunched 오케스트레이션이 호출될 때 부모 프로세스로부터의 입력 | 오케스트레이션은 변수 값을 **변경할 수 없고**, input 변수를 evaluation flow나 step이 호출하는 flow의 input 파라미터로 전달만 가능 |
| Output | 오케스트레이션은 output 변수를 사용하지 않는다 | — |

**Record Refresh** — API 버전 **58.0 이상**으로 실행되도록 구성된 오케스트레이션에서 record 변수/record 컬렉션을 참조하면, 오케스트레이션 run이 resume될 때마다 최신 값으로 refresh된다. autolaunched는 참조된 모든 레코드, record-triggered는 `$Record_Prior`를 제외한 모든 레코드.

**Run 레코드 소유권** — Winter '23 이후 생성된 flow orchestration run / stage run / step run 레코드의 Owner ID는 **automated process user**의 ID.

---

## Stage

Stage는 관련 step들을 논리적 단계로 묶는다. **Stage는 순차 실행되며, 동시에 1개의 stage만 In Progress**일 수 있다. 오케스트레이션에는 stage가 **최소 1개** 필요하다. Stage 시작 시점은 제어할 수 없고(순차 실행이므로), 완료 시점만 exit condition으로 제어한다.

> Flow Orchestration의 Stage **요소**는 Flow Builder의 Stage **리소스**와 무관하다.

### Exit Condition (3종)

| Stage 조건 | 필요한 것 |
|---|---|
| 모든 step이 Complete로 표시되면 stage를 Complete로 표시 | — |
| 지정된 requirements가 충족되면 stage를 Completed로 표시 | stage 완료 가능 여부를 판정하는 requirement 최대 3개 |
| 지정된 evaluation flow가 True를 반환하면 stage를 Complete로 표시 | stage 완료 가능 여부를 판정하는 evaluation flow 이름 |

### Stage Status (6종)

Stage는 순차 실행이고 entry condition이 없으므로 **In Progress가 된 후에만 status를 가진다**. 해당 orchestration stage run 레코드도 stage가 In Progress가 된 후 생성된다.

| Status | 설명 |
|---|---|
| In Progress | stage가 시작됨 |
| Completed | stage 완료 + (오케스트레이션 완료 / 진행 중 / 취소됨) |
| Suspended | 오케스트레이션이 수동 suspend될 때 stage가 in-progress였음 |
| Canceled | 오케스트레이션이 취소될 때 stage가 in progress였음 |
| Discontinued | 오케스트레이션이 오류를 만났을 때 stage가 in progress였음 |
| Error | stage 자체 오류 / 내부 background step 오류 / background step이 호출한 autolaunched flow 오류 / in progress 중 내부 interactive step 오류 / in progress 중 interactive step의 screen flow 오류 / in progress 중 내부 MuleSoft step 오류 / in progress 중 MuleSoft step의 MuleSoft action 오류 |

### Stage Milestone (히스토리, 5종)

| Milestone | 설명 |
|---|---|
| Start Stage | stage가 시작됐거나, 부모 오케스트레이션 resume 시 stage가 resume됨 |
| End Stage | stage가 완료됨 |
| Suspend Stage | stage가 수동 suspend됨 |
| Discontinue Stage | stage 완료 후 또는 in progress 중에 오케스트레이션이 오류를 만남 |
| Fail Stage | stage 오류 / 내부 background step 오류 / background step이 호출한 autolaunched flow 오류 |

---

## Step 공통

Step은 stage 안에 묶이며 **순차 또는 동시(concurrently)** 실행될 수 있다.

> Flow Orchestration의 Step **리소스**는 Flow Builder에서 단종된(discontinued) Step **요소**와 무관하다.

### Automatic Output의 런타임 가용 시점

설계 시점에는 automatic output 리소스가 오케스트레이션 전체에서 (run이 접근 가능해지기 전에도) 보인다. 따라서 **run이 실제로 접근 가능한 시점에만 참조**하도록 설계해야 한다.

| Automatic Output | 런타임 가용 시점 |
|---|---|
| Stage Status | 해당 stage가 In Progress가 된 후 |
| Step Status | 부모 stage가 In Progress가 된 후 |
| Flow Output Variable | 부모 step이 완료된 후 |

- Step이 호출하는 flow의 사용자 정의 output 변수를 오케스트레이션에서 쓰려면 flow에서 **Available for output**으로 표시해야 한다.
- Evaluation flow에서는 `isOrchestrationConditionMet` output 변수만 사용되고 **다른 사용자 정의 output 변수 값은 모두 폐기**된다.

### Step Status (5종)

| Status | 설명 |
|---|---|
| Not Started | entry condition을 아직 충족하지 못함 |
| In Progress | step이 시작됨 |
| Completed | interactive step이 exit condition 충족 / background step의 flow 완료 / 소속 stage가 오류를 만났을 때 step은 이미 완료돼 있었음 |
| Discontinued | in progress 중 소속 stage 완료 / in progress 중 오케스트레이션 오류 / in progress 중 소속 stage 오류 |
| Error | step 자체 오류 / background step의 autolaunched flow 오류 / interactive step의 screen flow 오류 / MuleSoft step의 MuleSoft action 오류 |

### Step Milestone (히스토리, 4종)

| Milestone | 설명 |
|---|---|
| Start Step | step이 시작됨 |
| End Step | step이 완료됨 |
| Discontinue Step | in progress 중 소속 stage 완료 / step 완료 후 오케스트레이션 오류 / in progress 중 오케스트레이션 오류 / in progress 중 소속 stage 오류 |
| Fail Step | step이 오류를 만남 |

---

## Background Step

활성 autolaunched flow를 실행하며 사용자 상호작용이 없다.

> PDF에 "Background Step Work Cycle" 다이어그램 있음 — 본 wiki에는 텍스트 설명만.

### 동기 vs 비동기

- 기본은 **동기** 처리.
- **Contains external callouts or wait elements**를 선택하면 **비동기** 처리. 호출하는 autolaunched flow에 **Pause/Wait 요소나 external callout**이 있을 때 사용.
- 비동기 step의 flow가 완료되면 **Flow Orchestration Event 플랫폼 이벤트**를 발행하고, 이 이벤트가 현재 stage와 그 안의 Not Started/In Progress step들의 상태 평가를 유발한다.

### 시작 조건 (When to Start, 4종 — interactive·MuleSoft step과 동일)

| Step 조건 | 필요한 것 |
|---|---|
| stage가 시작되면 step 시작 | — |
| 다른 step이 Complete로 표시되면 step 시작 | 선행 완료돼야 하는 step의 이름 |
| 지정된 requirements가 충족되면 step 시작 | 시작 가능 여부를 판정하는 requirement 최대 3개 |
| 지정된 evaluation flow가 True를 반환하면 step 시작 | 시작 가능 여부를 판정하는 활성 evaluation flow 이름 |

### 실행 컨텍스트

- **API 60.0 이상:** 기본적으로 background step이 호출하는 활성 autolaunched flow는 **Automated Process User** 컨텍스트에서 실행. 다른 사용자로 실행하려면 step Properties 패널의 **Select Who to Run the Action As** 사용. 시스템 컨텍스트의 레코드 접근 제어는 autolaunched flow의 **How to Run the Flow** 고급 옵션.
- **API 59.0 이하 (동기):** flow는 오케스트레이션과 같은 컨텍스트에서 실행 — 오케스트레이션이 system context면 system context, user context면 user context (접근 제어는 How to Run the Flow 옵션).
- **API 59.0 이하 (비동기):** 오케스트레이션이 system context면 **Automated Process User의 system context**, user context면 step 이전에 오케스트레이션이 실행되던 것과 같은 컨텍스트.

---

## Interactive Step

활성 screen flow를 실행하며 사용자 상호작용이 필요하다. 시작 조건과 **완료 조건** 모두 제어 가능.

> PDF에 "Interactive Step Work Cycle" 다이어그램 있음 — 본 wiki에는 텍스트 설명만.

시작 조건 4종은 background step과 동일. **완료 조건(When to Complete)**:

| Step 조건 | 필요한 것 |
|---|---|
| 배정된 사용자가 screen flow를 완료하면 step을 Complete로 표시 | — |
| 지정된 requirements가 충족되면 step을 Completed로 표시 | 완료 가능 여부를 판정하는 requirement 최대 3개 |
| 지정된 evaluation flow가 True를 반환하면 step을 Complete로 표시 | 완료 가능 여부를 판정하는 evaluation flow 이름 |

### 누가 완료하나 (Assignee)

| 타입 | 설명 |
|---|---|
| User | 내부 사용자의 username · credentialed Experience Cloud 사이트 방문자의 username |
| Group | 내부 사용자만 포함하는 그룹 / credentialed Aura 사이트 방문자만 포함하는 그룹 / credentialed LWR 사이트 방문자만 포함하는 그룹의 API name |
| Queue | 내부 사용자만 포함하는 큐 / credentialed Aura 사이트 방문자만 포함하는 큐 / credentialed LWR 사이트 방문자만 포함하는 큐의 API name |

런타임에 배정된 user/group/queue는 기본적으로 배정 작업 링크가 담긴 **알림 이메일**을 받는다. 기본 이메일 발송을 끌 수는 있지만 **기본 이메일을 커스터마이즈할 수는 없다** (비활성화는 [[Flow Orchestration - 운영과 레퍼런스]]의 "기본 이메일 알림 비활성화" 참조).

| Assignee 타입 | 알림 |
|---|---|
| 내부 사용자 | 내부 관련 레코드 페이지 링크가 담긴 개인화 이메일 (커스터마이즈 불가) |
| Credentialed Experience Cloud 사이트 방문자 | 소속된 가장 오래된 라이브 사이트의 관련 레코드 페이지 링크가 담긴 개인화 이메일 (커스터마이즈 불가) |
| 내부 사용자 group/queue | 내부 관련 레코드 페이지 링크가 담긴 일반 이메일 |
| 전원이 같은 사이트 멤버인 Aura/LWR 방문자 group/queue | 전원이 멤버인 라이브 사이트의 관련 레코드 페이지 링크 |
| 전원이 1개 이상 공통 사이트 멤버인 Aura/LWR 방문자 group/queue | 전원이 멤버인 **가장 오래된** 라이브 사이트의 레코드 페이지 링크 |
| 공통 사이트가 없는 Aura/LWR 방문자 group/queue | 내부 관련 레코드 페이지 링크 — 사이트 방문자에게는 **링크가 무효** (내부 페이지 접근 불가). Orchestration Work Item Object List 페이지에서 배정 작업 확인·접근 |
| 내부 사용자 + Aura/LWR 방문자 혼합 group/queue | 내부 관련 레코드 페이지 링크 — 사이트 방문자에게는 링크 무효 (위와 동일하게 Object List 페이지 사용) |

### 완료 위치·실행 컨텍스트

- 완료는 이메일 링크에 포함된 **관련 레코드 페이지**의 Work Guide에서.
- interactive step이 호출하는 활성 screen flow는 **완료하는 사람의 컨텍스트**에서 실행.
- **v57.0 이하:** interactive step이 완료로 표시된 후 오케스트레이션 run은 해당 work item을 완료한 사용자 컨텍스트에서 resume된다. 완료자가 Run Flows 권한 없이 특정 flow에 대한 세분화된(granular) 접근만 가진 경우 **run이 resume되지 못한다** — Run Flows 권한 보유자가 다른 work item을 실행하거나, admin이 일시정지된 run ID로 Flow Orchestration Event를 트리거해야 resume 가능.

---

## MuleSoft Step

MuleSoft API에서 import한 operation을 **비동기로** 실행하며 사용자 상호작용이 없다. 시작 조건 4종은 다른 step과 동일 (완료 조건 없음).

> PDF에 "MuleSoft Step Work Cycle" 다이어그램 있음 — 본 wiki에는 텍스트 설명만.

**실행 컨텍스트** — API 60.0 이상: 기본 **Automated Process User** (Select Who to Run the Action As로 변경 가능). API 59.0 이하: MuleSoft step 시작 전 오케스트레이션이 실행되던 사용자 컨텍스트.

---

## 오케스트레이션 안의 Flow

각 background/interactive step은 연관 flow를 실행한다. Background step → autolaunched flow, interactive step → screen flow.

**⚠️ 입력값 32,768자 한도** — step이 호출하는 flow의 **입력값 합계가 32,768자를 넘으면 오케스트레이션이 실패**한다. 레코드(들)를 통째로 전달할 때 흔히 발생. 회피: **레코드 ID만 전달**하고 flow 안에서 Get Records 요소로 조회 — 항상 최신 레코드를 얻는 부수효과도 있다.

| 변수 | 설명 | 비고 |
|---|---|---|
| Internal-only | flow 내부용, 오케스트레이션의 입출력으로 노출 안 됨 | 오케스트레이션은 이 변수를 쓸 수 없음 |
| Input | Available for input 표시. step이 flow를 호출할 때 step의 입력 | 오케스트레이션이 input 값을 줄 수 있는 flow: **autolaunched · screen · evaluation flow** |
| Output | Available for output 표시. 해당 step의 automatic output으로 접근, 오케스트레이션 전체에서 사용 가능 | 오케스트레이션이 output에 접근 가능한 flow: **autolaunched · screen flow**. API 58.0+에서 record/record 컬렉션 automatic output은 run resume 시마다 refresh |

> **Orchestration Run Log에 커스텀 코멘트 추가:** step이 호출하는 flow에 `Comments`라는 이름의 Text output 변수를 만들고 값을 할당하면 된다 (절차는 [[Flow Orchestration - 운영과 레퍼런스]]).

---

## Evaluation Flow

Stage/step 실행 제어 로직에 **3개를 초과하는 requirement**가 필요하면 evaluation flow를 쓴다. New Flow 창에서 **Evaluation Flow 타일** 선택으로 생성.

- Process type이 **Evaluation Flow**인 autolaunched flow이며, 미리 정의된 Boolean output 변수 **`isOrchestrationConditionMet`** 를 갖는다.
- **`false`로 초기화**해야 하고, 커스텀 조건 충족을 나타내려면 `true`로 설정한다.
- Evaluation flow는 `isOrchestrationConditionMet` 값만 반환 — **다른 output 변수 값은 전부 폐기**된다.

```xml
<!-- 구조 예시 — 실제 동작 XML 아님: evaluation flow의 필수 output 변수 -->
<variables>
    <name>isOrchestrationConditionMet</name>
    <dataType>Boolean</dataType>
    <isInput>false</isInput>
    <isOutput>true</isOutput>
    <value><booleanValue>false</booleanValue></value> <!-- 반드시 false로 초기화 -->
</variables>
```

**평가 실행 시점** — 현재 stage 안의 비동기 background step·interactive step·MuleSoft step이 완료될 때마다 오케스트레이션이 해당 stage와 step들의 조건을 평가한다. `$Orchestration.Instance`로 orchestration event를 발행해 평가를 강제로 트리거할 수도 있다. 평가 규칙:

- Stage가 in progress면 → 완료 가능 여부 판정
- 현재 stage 안의 각 Not Started step → 시작 가능 여부 판정
- 현재 stage 안의 각 In Progress **interactive** step → 완료 표시 가능 여부 판정

**실행 컨텍스트 (API 버전별)** — 60.0 이상: **system context without sharing으로만** 실행, 모든 데이터 접근. 58.0·59.0: 항상 system context. 57.0 이하: flow의 How to Run the Flow 고급 옵션 설정대로.

---

## Work Item — 배정과 수명주기

Interactive step이 실행되면 **work item**을 생성해 user/group/queue에 배정하고, 배정된 사용자 전원에게 지정된 레코드 페이지 링크가 담긴 이메일을 보낸다. 작업 완료는 해당 레코드 페이지의 Work Guide 컴포넌트에서. (알림 이메일 타입별 매트릭스는 위 Interactive Step 섹션의 표와 동일.)

- **Omni-Channel 위젯 알림:** interactive step이 **Orchestration Work Item 오브젝트와 연결된 queue**에 배정되면, 큐 멤버는 정의된 라우팅 로직에 따라 Omni-Channel 위젯으로도 알림을 받는다 (기본 이메일 알림에 **추가로**).
- **내부 사용자 접근:** 이메일 링크 · Flow Orchestration Work Items 리스트 뷰 · To Do List. 사전에 관련 레코드 페이지 레이아웃에 Work Guide 컴포넌트를 배치해 둬야 한다.
- **Experience Cloud 방문자 접근:** 이메일 링크(소속된 가장 오래된 라이브 사이트) · Orchestration Work Item 오브젝트 리스트 뷰. 사전에 Experience Builder에서 Aura/LWR 사이트의 관련 레코드 페이지에 Work Guide 컴포넌트 배치 + Orchestration Work Item List 오브젝트 페이지 추가.
- **Group/queue 배정 완료 경쟁:** work item은 **screen flow를 처음 완료한 사용자**가 완료한다. 두 사용자가 동시에 실행하면 **나중에 완료한 쪽이 오류**를 받는다. 완료 후 다른 멤버에게는 Work Guide에 관련 작업이 보이지 않는다 (Experience Cloud 방문자 group/queue도 동일).
- **재배정:** 진행 중인 오케스트레이션의 열린 work item을 다른 user/group/queue에 재배정 가능. 재배정 후에는 처음 생성됐을 때처럼 처리된다.

### Work Item Status (2종 — 케이스 전수)

| Status | 발생 케이스 |
|---|---|
| Assigned | 생성됐으나 미완료 + 오케스트레이션 진행 중 / 다른 사용자에게 재배정됨 + 진행 중 / 미완료 + 오케스트레이션 취소됨 / **완료됐는데** 오케스트레이션 취소됨 / 미완료 + 오케스트레이션 오류 / 미완료 + 해당 interactive step의 screen flow 오류 |
| Completed | 완료 + 오케스트레이션 완료 / 미완료였지만 소속 step의 stage가 완료됨 / 완료 + 오케스트레이션 취소됨 / 완료 + 오케스트레이션 오류 / 완료 + 소속 stage 오류 / 미완료 + 소속 stage 오류 |

### Work Item Milestone (3종)

| Milestone | 설명 |
|---|---|
| Start Work Item | work item이 생성·배정됨 |
| End Work Item | 배정된 사용자가 완료. 이때 **Completed By** 필드 = 완료한 사용자/방문자의 username, **Duration** 필드 = step 소요 시간(초) |
| Reassign Work Item | work item이 재배정됨 |

### Work Item 레코드 소유권

Winter '23 이후 생성분: 소유자는 배정된 사용자 또는 automated process user. **Summer '24 이전** 생성 + queue 배정분: automated process user.

| 시나리오 | Owner ID |
|---|---|
| 단일 내부 사용자에게 배정 | 배정된 사용자 ID |
| 단일 credentialed Experience Cloud 방문자에게 배정 | 해당 방문자 ID |
| 단일 내부 사용자에게 재배정 | 재배정받은 사용자 ID |
| 단일 credentialed 방문자에게 재배정 | 재배정받은 방문자 ID |
| group에 배정/재배정 | automated process user ID |
| Orchestration Work Item 오브젝트와 연결된 queue에 배정/재배정 | 배정된 queue ID |
| Orchestration Work Item 오브젝트와 연결되지 않은 queue에 배정/재배정 | automated process user ID |

> FlowOrchestration·FlowOrchestrationInstance·FlowOrchestrationWorkItem 등 sObject 상세는 [[Platform Admin Objects]] 참조.

---

## 고급 개념 — 실행 컨텍스트와 버저닝

### 오케스트레이션의 실행 컨텍스트

기본 실행 컨텍스트는 **Automated Process User의 system context**. 기본 실행 사용자는 타입과 API 버전에 따라 다르다.

**Autolaunched:**
- API 60.0+: 항상 Automated Process User의 system context에서 launch·resume.
- API 59.0 이하: 보통 launch한 사용자 컨텍스트. **Apex에서 launch하면 system context.** How to Run the Orchestration 고급 옵션으로 제어.

| 시나리오 (API 59.0·58.0 autolaunched) | Resume 컨텍스트 |
|---|---|
| System context로 시작 | System context |
| 수동 발행 플랫폼 이벤트로 resume | 이벤트를 발행한 사용자의 system context |
| 비동기 background step 완료로 resume | 해당 step 이전에 실행되던 것과 같은 컨텍스트 |
| MuleSoft step 완료로 resume | Automated Process User의 system context |
| Interactive step 완료로 resume | 완료한 사용자의 system context |
| 레코드 변경으로 entry/exit condition 충족되어 resume | Automated Process User의 system context |

**Record-triggered:**
- API 60.0+: 항상 Automated Process User의 system context에서 launch·resume.
- API 59.0 이하: 항상 **트리거한 사용자**의 system context에서 launch. Resume 사용자는 원인에 따라:

| Resume 원인 (API 59.0 이하 record-triggered) | 사용자 |
|---|---|
| 수동 발행 플랫폼 이벤트 | 이벤트를 발행한 사용자 |
| 비동기 background step 완료 | 해당 step 이전에 실행되던 것과 같은 사용자 |
| MuleSoft step 완료 | Automated Process User |
| Interactive step 완료 | 완료한 사용자 |
| 레코드 변경으로 entry/exit condition 충족 | Automated Process User |

### 버저닝 (2레벨)

**오케스트레이션 정의 버전** — 정의당 활성 버전은 **1개**. run은 **시작 시점의 활성 버전**을 사용하고, run 시작 후 새 버전을 활성화해도 기존 run은 시작한 버전으로 계속 실행된다 (새 활성 버전은 이후 시작되는 run에만 적용).

**Flow 정의 버전** — step은 **step이 시작될 때 활성인 flow 버전**을 사용한다.
- run 시작 후 + 해당 step run 생성 **후**에 flow 새 버전 활성화 → **기존 버전** 실행
- run 시작 후 + step run 생성 **전**에 새 버전 활성화 → **새 버전** 실행

---

## Build — 오케스트레이션 구축

Draft는 모든 정보 없이 저장 가능하지만, **활성화·실행 전에는 모든 연관 flow와 상세를 지정**해야 한다. 가능하면 필요한 flow 생성·MuleSoft action import를 먼저 끝내고 빌드한다.

1. Setup → Quick Find `Flows` → **Flows** → **New Flow**
2. **Start from Scratch** → Next
3. 오케스트레이션 타입 선택 → Create
4. (record-triggered) Start 요소 구성: **Edit**
5. Start·End 사이 `+` 클릭으로 요소 추가
6. Stage에 step 추가: **Add Step**
7. 루프 또는 다른 요소 연결: stage 뒤 `+` → **Connect to element** → 대상 요소 클릭
8. 저장 → 활성화 → 테스트

### Decision 요소

조건은 지정한 순서대로 평가된다. Outcome별 조건 로직:

| 옵션 | 동작 |
|---|---|
| All Conditions Are Met | 조건 하나라도 false면 다음 outcome의 조건 평가로 이동 |
| Any Condition Is Met | 조건 하나라도 true면 즉시 이 outcome 경로 진행 |
| Custom Condition Logic Is Met | **최대 1,000자** 로직 입력 — 조건 번호 + AND/OR/NOT + 괄호. `AND`만 쓰면 All과 동일, `OR`만 쓰면 Any와 동일. 예: `1 AND NOT(2 OR 3)` |

| 컬럼 | 옵션 |
|---|---|
| Resource | input 변수·stage/step automatic output / Decision 요소 / global variable |
| Operator | Resource의 데이터 타입에 따라 다름 ([[Flow Orchestration - 운영과 레퍼런스]] 연산자 표) |
| Value | Resource와 호환 타입 — 오케스트레이션 리소스 / global variable / 리터럴. **날짜에 숫자를 더하고 빼면 시간이 아니라 일(day) 단위로 조정** |

### Requirements 정의 (stage/step)

레코드가 변경될 때 오케스트레이션을 resume시키는 용도. step 시작 / interactive step 완료 / stage 완료 판정에 **최대 3개** requirement. 로직 옵션(All / Any / Custom **최대 1,000자**)은 Decision과 동일.

| 컬럼 | 옵션 |
|---|---|
| Resource | 오케스트레이션 리소스(변수·record 변수 필드·step automatic output) / Stage 요소 status / Step 리소스 status / (record-triggered) `$Record` / global variable |
| Operator | Decision 요소와 동일 |
| Value | 오케스트레이션 리소스 / global constant / global variable / 리터럴. 날짜±숫자 = 일 단위 |

Requirement에서 참조한 레코드가 변경되면 현재 stage·미결 step의 상태 평가가 트리거될 수 있다. 단, 일부 리소스는 조건 평가를 트리거하지 않는다 (제약 전수는 [[Flow Orchestration - 운영과 레퍼런스]]의 고려사항).

### Interactive Step 배정

Properties 패널 → **Select Someone to Complete the Action**:

| 배정 타입 | 지정 방법 |
|---|---|
| User | 내부 사용자·credentialed 방문자 이름 검색 |
| Group | 일반 public group 라벨 검색 |
| Queue | 큐 라벨 검색 |
| User Resource | 런타임에 username을 담는 변수의 API name |
| Group Resource | 런타임에 group API name을 담는 변수의 API name |
| Queue Resource | 런타임에 queue API name을 담는 변수의 API name |

> **⚠️ User Resource에 `$User`를 선택하지 말 것** — system context로 실행 중이면 `$User`는 시스템 사용자로 평가되는데, interactive step은 시스템 사용자에게 배정할 수 없다.

배정 대상은 관련 레코드에 접근할 수 있어야 한다: 내부 사용자는 내부 Lightning 레코드 페이지, credentialed 방문자는 Aura/LWR 사이트의 관련 레코드 페이지 접근 필요.

### Omni-Channel 라우팅

1. Omni-Channel 설정 → 2. **Orchestration Work Item 오브젝트에 queue 연결** → 3. 그 queue에 interactive step 배정. 이 경우 work item 소유자는 queue이며, 멤버는 라우팅 로직대로 Omni-Channel 위젯 알림을 받는다 (이메일 알림을 끄지 않으면 이메일도 병행).

### 경로 제어

- **Go To 커넥터:** Auto-Layout의 통상 경로를 벗어나는 연결·루프 생성. 요소 2개 이상 필요. 요소 뒤 `+` → Connect to element → 대상 클릭 (점선으로 표시).
- **End 요소:** 경로 종료. Decision 요소 1개 + 경로 2개 이상 필요.

### 조건 평가 트리거 · 외부 시스템 통합

현재 stage 안의 step이 완료될 때마다 조건이 평가되지만, **flow에서 orchestration event를 발행**해 평가를 강제할 수도 있다. MuleSoft step 외에 `$Orchestration.Instance` 시스템 변수로 외부 시스템과 통합한다.

외부 시스템이 일시정지된 오케스트레이션의 조건 평가를 유발하게 하는 패턴 (사전 준비: 오브젝트에 orchestration run ID 커스텀 필드 추가 → run ID를 받아 외부 시스템 호출 액션에 전달하는 autolaunched flow 작성 → 외부 시스템이 작업 종료 후 해당 레코드의 커스텀 run ID 필드를 갱신하도록 로직 추가 → 이 flow를 **비동기 background step**에서 호출하며 `$Orchestration.Instance` 전달):

1. 커스텀 run ID 필드가 업데이트될 때 실행되는 record-triggered flow 생성 (오브젝트가 여러 개면 각각)
2. Create Records 요소 추가
3. 라벨·API name·설명 입력
4. **Use separate resources, and literal values** 선택
5. Object: **Orchestration Event**
6. Field: **OrchestrationInstanceId**
7. Value: `$Record` → 트리거 레코드의 커스텀 run ID 필드 선택
8. Done
9. 저장·활성화

### 오케스트레이션 템플릿

- 신규/기존 오케스트레이션을 템플릿으로 저장해 다른 오케스트레이션의 시작점으로 사용. **managed package로 배포**해 구독자가 템플릿 기반으로 생성하게 할 수도 있다.
- 만들기: Save As → A New Orchestration → 라벨·API name·설명 → **Show Advanced** → **Template** 체크. (기존 것은 버전 속성 편집에서 설명 확인 후 동일하게 Template 체크)
- 사용: New Flow 대화상자 → **All + Templates** 탭 → Flow Orchestration 카테고리에서 선택.

### Work Guide 배치 (활성화 전 필수 준비)

| 위치 | 방법 |
|---|---|
| 내부 레코드 페이지 | Lightning App Builder에서 interactive step이 참조하는 레코드 타입의 페이지 레이아웃에 **Flow Orchestration Work Guide** 컴포넌트 드래그 (레코드 페이지 라벨 최대 80자, 페이지 활성화 필요). 필요 권한: Customize Application |
| Experience Cloud 사이트 (Aura/LWR) | Experience Builder에서 관련 레코드 페이지에 Work Guide 컴포넌트 드래그. **org에 Flow Orchestration이 활성화돼 있어야 함** |
| Experience Cloud Work Item 목록 | Experience Builder → Pages → New Page → Object Pages → `work item` 검색 → **Orchestration Work Item** 선택 → Create → 사이트 미리보기·게시 |

---

## Deploy — 배포

### Org-Wide Email Address 설정

Flow Orchestration의 알림 이메일 From 주소로 쓸 org-wide email address가 필요하다. **From 주소가 없으면 알림 이메일이 발송되지 않는다.** 기존 주소가 있으면 새로 만들 필요는 없지만 Process Automation Settings의 **Email Approval Sender**로 지정돼 있어야 한다.

1. Setup → `Email` → **Organization-Wide Address** → Add
2. Display Name·Email Address 입력, **Allow All Profiles to Use this From Address** 선택 → 저장
3. 상태가 Verification Request Sent → 해당 메일함에서 승인·검증 → 상태 **Verified** 확인
4. Setup → `automation settings` → **Process Automation Settings** → **Email Approval Sender**에 org-wide 주소 지정 → 저장

> **⚠️** Sender Type이 OrgWideEmailAddress면, flow를 실행하는 사용자가 해당 org-wide 주소에 필요한 프로필 구성을 갖춰야 한다 — 없으면 오류.

### 활성화/비활성화

- 오케스트레이션당 **활성 버전은 1개**. 새 버전을 활성화하면 기존 활성 버전은 자동 비활성화된다.
- **실행 중인 run은 시작한 버전으로 계속 실행**된다.
- Flow Builder에서 버전 열기 → 버튼바 **Activate/Deactivate**. (record-triggered 활성화에는 View All Data 추가 필요)

### Change Set 배포

Sandbox에서 생성·테스트·디버그 후 change set으로 production에 배포.

| 작업 | 필요 권한 |
|---|---|
| 프로세스 생성·편집·조회 | Manage Flow AND View All Data |
| 배포 연결 편집 | Deploy Change Sets AND Modify Metadata Through Metadata API Functions |
| Outbound change set 사용 | Create and Upload Change Sets |
| Inbound change set 사용 | Deploy Change Sets AND Modify Metadata Through Metadata API Functions |

1. 소스 org에서 interactive step 배정에 쓴 **group·queue 이름이 대상 org에도 동일하게 존재**하는지 확인
2. **interactive step을 특정 사용자에게 직접 배정하지 않았는지** 확인 — 직접 배정된 사용자마다 상수(constant)를 만들고, 각 step을 해당 상수에 배정
3. 오케스트레이션과 참조된 모든 flow 활성화
4. Outbound change set 생성
5. 컴포넌트 추가 — 오케스트레이션 + 연관 flow + 연관 flow가 의존하는 신규 custom action·custom flow screen component
6. Outbound change set 업로드
7. 대상 org에서 inbound change set 배포
8. 대상 org에서 assigned-user 상수 갱신 후 새 버전 저장
9. 새 버전 활성화
10. 참조되는 각 컨텍스트 레코드의 페이지 레이아웃에 Work Guide 컴포넌트가 있는지 확인

---

## 관련 노트

- [[Flow Orchestration - 운영과 레퍼런스]] — Run·Manage·Troubleshoot·한도·엔타이틀먼트·요소/리소스/연산자 레퍼런스 (짝 노트)
- [[Flow 네이밍 컨벤션]] — Orchestration(`ORCH`)·Evaluation(`EVAL`) 접두어 패턴
- [[Flow 종류와 변수]] — processType 전반 (Orchestration·Evaluation Flow의 위치)
- [[Screen Flow 설계]] — interactive step이 호출하는 screen flow 설계
- [[Autolaunched Flow 패턴]] — background step이 호출하는 autolaunched flow 패턴
- [[Platform Admin Objects]] — FlowOrchestration·FlowOrchestrationInstance·FlowOrchestrationStageInstance·FlowOrchestrationStepInstance·FlowOrchestrationWorkItem·FlowOrchestrationLog 등 sObject 카탈로그
