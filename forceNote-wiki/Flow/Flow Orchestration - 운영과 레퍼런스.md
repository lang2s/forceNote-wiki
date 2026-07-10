---
tags: [flow, orchestration, flow-orchestration, orchestration-run, work-item, troubleshooting, limits, entitlements, reference, operators]
source: extend_click_automate.pdf (Automate Your Business Processes, Spring '26)
created: 2026-07-11
aliases: [Flow Orchestration Reference, Orchestration Run, 오케스트레이션 실행, 오케스트레이션 운영, 오케스트레이션 레퍼런스, Resume Failed Orchestration, 실패 오케스트레이션 재개, Orchestration Runs list view, Flow Orchestration Limits, Flow Orchestration Entitlements, Flow Orchestration Operators, Orchestration Reports, Disable Default Email Notifications, isOrchestrationConditionMet]
---

# Flow Orchestration - 운영과 레퍼런스

> 배포된 오케스트레이션을 **실행(Run)·관리(Manage)·문제 해결(Troubleshoot)** 하고, **한도·엔타이틀먼트·요소/리소스/연산자 레퍼런스**를 전수 수록한 층. 개념·타입·Stage·Step·Work Item 설계·Build·Deploy는 [[Flow Orchestration]] 참조.

---

## 실행 인스턴스 — Orchestration Run

**orchestration run**은 오케스트레이션의 실행 중 인스턴스이며, 오케스트레이션 인스턴스마다 하나씩 생성된다. run이 사용하는 컨텍스트는 오케스트레이션 타입에 따라 다르고, **How to Run the Orchestration** 고급 옵션으로도 지정할 수 있다 (컨텍스트 상세는 [[Flow Orchestration]]).

### 실패한 오케스트레이션 재개 (Resuming a Failed Orchestration)

- run이 **step이 호출한 action의 오류** 때문에 실패하면 → 오류를 고친 뒤 **최대 14일** 안에 resume할 수 있다.
- run이 **그 외 다른 종류의 오류**로 실패하면 → **resume할 수 없다**.
- 실패했지만 **14일 안에 resume되지 않으면** → 더 이상 resume할 수 없다.

재개 시 각 항목의 상태 전이 (PDF 표는 페이지 넘김으로 다단 병합 — 이미지 대조 후 셀별 복원):

| Item | Status In Failed Run | When Run is Resumed | Status In Resumed Run |
|---|---|---|---|
| Stage | Error | The stage is resumed. | In Progress |
| Background or MuleSoft Step | Error | The step is restarted. | In Progress |
| Background or MuleSoft Step | Discontinued (no pending outputs) | The step is restarted. | In Progress |
| Background or MuleSoft Step | Discontinued (pending outputs) | The stored outputs are processed, and the step isn't restarted. | **Completed / Error** |
| Interactive Step | **Error / Discontinued** | A new work item is created for the step. | In Progress |

> ⚠️ 셀 병합 주의 — `Discontinued (pending outputs)` background/MuleSoft step은 저장된 출력을 처리한 뒤 **Completed 또는 Error** 중 하나가 되고(step은 재시작하지 않음), interactive step은 실패 상태가 **Error 이거나 Discontinued**일 때 모두 **새 work item을 생성**하고 **In Progress**로 재개된다.

### Orchestration Run Status (5종)

run은 생성되면 status를 가진다.

| Orchestration Run Status | 설명 |
|---|---|
| In Progress | The orchestration started. |
| Completed | The orchestration was completed. |
| Suspended | The orchestration was manually suspended. |
| Canceled | The orchestration was manually canceled. |
| Error | 오케스트레이션 오류 / 오케스트레이션 내 stage 오류 / 오케스트레이션 내 step 오류 / step에 연결된 screen flow·autolaunched flow 오류 |

### Orchestration Run Milestone (6종)

로깅에서 run은 여러 milestone을 남긴다. (Stage/Step/Work Item milestone은 [[Flow Orchestration]] 참조 — 아래는 **Run 레벨** 전수.)

| Orchestration Run Milestone | 설명 |
|---|---|
| Start Run | The orchestration started or was manually resumed. |
| End Run | The orchestration was completed. |
| Suspend Run | The orchestration was manually suspended. |
| Cancel Run | The orchestration was manually canceled. |
| Resume Run | The orchestration was manually resumed. |
| Fail Run | 오케스트레이션 오류 / 오케스트레이션 내 stage 오류 / 오케스트레이션 내 step 오류 |

---

## 오케스트레이션·Work Item 관리

리스트 뷰로 오케스트레이션과 work item을 관리한다. 실행 중 오케스트레이션을 취소·suspend, 실패한(14일 내·action/flow 오류) run이나 수동 suspend된 run을 resume, 배정됐지만 미완료된 work item을 재배정한다.

### Work Item 조회 (리스트 뷰)

| 리스트 뷰 | 내용 |
|---|---|
| **All Work Items** | 배정·완료된 모든 work item |
| **All Open Orchestration Work Items** | 배정됐으나 미완료인 work item. 배정된 사용자는 이 뷰에서 **자신의 pending work item만** 조회·접근 가능 |

경로: App Launcher → **Orchestration Work Items** → 드롭다운에서 `All Work Items`(배정+완료) 또는 `All Open Work Items`(배정) 선택 → 리스트의 work item 레코드를 클릭하면 연관 레코드 페이지에서 확인.

> 배정된 work item을 연관 레코드 페이지에서 볼 수 있는 사람은 **배정된 사용자 또는 배정된 group/queue의 멤버뿐**이다. 필요 권한: *모든 orchestration work item 조회 = 공유 설정(sharing) 기반 조회 접근*.

### 레코드에서 Work Item 조회·완료 (Work Guide)

특정 레코드의 배정 work item은 해당 레코드 페이지의 **Orchestration Work Guide** 컴포넌트에서 본다. 여러 개면 목록으로 표시되며, 마지막 수정일 기준 정렬·검색어 필터가 가능하고 완료 시 목록이 자동 새로고침된다. 필요 권한: **Run Flows**.

1. 배정 work item이 있는 레코드로 이동
2. Work Guide에서 정렬 아이콘으로 정렬
3. 검색 아이콘 + 검색어로 필터 (라벨에 검색어를 포함하는 work item만 표시)
4. 완료: 실행 아이콘 클릭 → Work Guide에서 screen flow 열림 → 완료 후 **Finish** → status가 **Completed**로 설정되고 목록으로 복귀. (완료 원치 않으면 뒤로 → OK)

### Orchestration Runs 조회

App Launcher → **Orchestration Runs** → `All Orchestration Runs` 리스트 뷰에서 진행 중·취소·완료된 run을 조회. run 링크 → **Related** 탭에서 상세, **Orchestration Run Log** → **View All**로 전체 히스토리. 필요 권한: *공유 설정 기반 조회 접근*.

#### Orchestration Run Log에 커스텀 코멘트 추가 (2단계)

**1) step이 호출하는 flow에 `Comments` 변수 추가**

<!-- 구조 예시 — 실제 동작 리소스 정의 아님: PDF 절차의 변수 설정값 -->
```text
Resource Type: Variable
API Name:      Comments
Description:   Stores custom text to be added to the Comments field in the Flow Orchestration Log.
Available for output: ✔ (체크)
Data Type:     Text
```
그다음 flow의 **Assignment** 요소에서 `Comments` 변수에 문자열을 설정한다.

**2) Orchestration Run Log에 Comments 컬럼 추가**

Orchestration Run 리스트 뷰 → 톱니 → **Edit Object** → **Page Layouts** → **Orchestration Instance Layout** → Related Lists 섹션에서 **Orchestration Run Log**의 렌치 아이콘 → Available Fields에서 **Comments** 선택해 이동 → (위/아래 화살표로 위치 조정) → OK → Save.

### Work Item 재배정

진행 중인 오케스트레이션의 **배정된(미완료) work item**을 다른 user/group/queue에 재배정한다. App Launcher → **Orchestration Work Items** → **All Open Work Items** → 대상 work item 드롭다운 → **Reassign Orchestration Work Item** → 대상 선택 → **Reassign Orchestration Work Item** 클릭.

| 작업 | 필요 권한 |
|---|---|
| work item 재배정 | **Reassign Orchestration Work Items** OR **Manage Orchestration Runs and Work Items** |
| 배정된 작업 완료 | **Run Flows** |

### 기본 이메일 알림 비활성화

기본적으로 오케스트레이션은 work item이 user/group/queue에 배정·재배정될 때 이메일 알림을 보낸다. 이를 끄면 내부 사용자와 credentialed Experience Cloud 사이트 방문자에게 이메일 발송이 중단된다.

Setup → Quick Find `process automation` → **Process Automation Settings** → **Stop Sending Orchestration Work Item Default Email Notifications** 선택. 필요 권한: **Customize Application**.

### Suspend · Resume · Cancel

모두 App Launcher → **Orchestration Runs** → 대상 run 드롭다운에서 실행.

| 작업 | 대상 조건 | 동작 | 필요 권한 |
|---|---|---|---|
| **Suspend** | in-progress만 | 현재 stage도 suspend. 진행 중 step은 계속 실행되지만 **새 step은 시작 안 됨**. 진행 중 step에 output이 있으면 저장했다가 resume 시 처리 | Manage Orchestration Runs **OR** Manage Orchestration Runs and Work Items |
| **Resume (suspended)** | suspend된 run | suspend된 stage도 resume. 진행 중 step 상태 평가·갱신, 저장된 output 처리 | (위와 동일) |
| **Resume (failed)** | 14일 내 · action 오류로 실패 | **먼저 호출된 flow/action의 오류를 수정**한 뒤 status가 Error인 run에서 Resume | (위와 동일) |
| **Cancel** | in-progress만 | 실행 중 오케스트레이션 취소 | Manage Orchestration Runs **OR** Manage Orchestration Runs and Work Items |

> Resume는 **수동 suspend된 run** 또는 **step이 호출한 action/flow 오류로 14일 내 실패한 run**에 대해 가능하다.

### Orchestration Reports (샘플 리포트)

오케스트레이션 사용량 추적용 샘플 리포트 5종:

- **Orchestration Runs**, **Orchestration Stage Runs**, **Orchestration Step Runs**, **Orchestration Work Items**, **Orchestration Run Logs**
- 각각 `Orchestration ... Spring '24` custom report type 기반.

찾기: Reports 리스트 뷰 → **Public Reports** → `orchestration` 검색 → 원하는 샘플 리포트 편집. 필요 권한: **Report Builder** OR **Report Builder (Lightning Experience)**.

주의:
- org에 **정의된 custom report가 최대치**면 오케스트레이션 리포트가 org에 추가되지 않는다.
- 샘플 리포트를 **삭제하면 다시 생성할 수 없다**.
- 샘플 리포트는 **public report**이고, 사용자에게 **직접** 배정된 work item만 표시한다. 사용자가 속한 group/queue의 작업까지 보려면 필터를 변경한다.

---

## 완료·취소·오류 상태 매트릭스

Orchestration Details 페이지는 실행 중 오케스트레이션의 상태를 준다. 오케스트레이션이 완료/취소/flow 오류로 종료/진행 중일 때 stage·step·work item 상태는 상황에 따라 달라진다. 상황별 전수:

### Completed Orchestration

| Item | Status |
|---|---|
| Orchestration Run | Completed |
| Completed Stages | Completed |
| Completed Steps | Completed |
| Running Steps | Discontinued |
| Not Started Steps | Not Started |
| Completed Work Items | Completed |
| Not Started Work Items | Completed |

### Canceled Orchestration

| Item | Status |
|---|---|
| Orchestration Run | Canceled |
| Completed Stages | Completed |
| Running Stage | Canceled |
| Completed Steps | Completed |
| Running Steps in the Running Stage | Canceled |
| Not Started Steps | Not Started |
| Completed Work Items | Completed |
| Not Started Work Items | Completed |

### Stopped by Orchestration Error

| Item | Status |
|---|---|
| Orchestration Run | Error |
| Running Stage | Discontinued |
| Running Steps | Discontinued |
| Not Started Steps | Not Started |
| Completed Work Items | Completed |
| Not Started Work Items | **Assigned** |

### Stopped by Stage Error

| Item | Status |
|---|---|
| Orchestration Run | Error |
| Failed Stage | Error |
| Completed Stages | Completed |
| Completed Steps | Completed |
| Running Steps | Discontinued |
| Not Started Steps | Not Started |
| Completed Work Items | Completed |
| Not Started Work Items | Completed |

### Stopped by Interactive Step Error

| Item | Status |
|---|---|
| Orchestration Run | Error |
| Completed Stages | Completed |
| Running Stage | Error |
| Failed Step | Error |
| Completed Steps | Completed |
| Running Steps | Discontinued |
| Not Started Steps | Not Started |
| Completed Work Items | Completed |
| Not Started Work Items | **Assigned** |

> 위 값은 **interactive step 자체가 실패**할 때 적용된다. interactive step에 연결된 **screen flow가 실패**하면 running stage·failed step의 상태는 **In Progress**, not started work item은 **Assigned**가 된다.

### Stopped by Background Step Error

| Item | Status |
|---|---|
| Orchestration Run | Error |
| Completed Stages | Completed |
| Running Stage | Error |
| Failed Step | Error |
| Completed Steps | Completed |
| Running Steps | Discontinued |
| Not Started Steps | Not Started |
| Completed Work Items | Completed |
| Not Started Work Items | Completed |

---

## Troubleshoot — 오류 이메일과 디버그

### 오류 이메일 (Emails about Orchestration Errors)

run이 실패하면 Salesforce가 오류 이메일을 발송한다. 수신자는 **연관 오케스트레이션을 마지막으로 수정한 admin** 또는 **Apex 예외 이메일 수신자**다. 이메일에는 다음에 대한 오류 메시지가 담긴다:

- Orchestration
- Executed orchestration elements (실행된 오케스트레이션 요소)
- Flows called from orchestration steps (step이 호출한 flow)

**활성 오케스트레이션**의 경우 오류 이메일에 **Flow Builder에서 실패한 run 상세를 보는 링크**가 포함된다. 오케스트레이션이 호출한 flow 때문에 실패하면 수신자는 **오케스트레이션 실패 오류 이메일**과 **flow 실패 오류 이메일**을 **둘 다** 받는다.

PDF의 오류 이메일 예시(원문 발췌):

```text
Error element Stage_1 (FlowOrchestratedStage).
An error occurred when executing a flow interview.
Flow Details
Flow API Name: Create_Customer_Record
Type: Orchestrator
Version: 1
Status: Inactive
Org: signup.org.test.1640285093849 (00DRM000000G0SV)
Flow Interview Details
Interview Label: Create New Customer 2/11/2022, 1:57 PM
Interview GUID: 1fb36a45416070aa772cba20517eea2a1236-7f18
Current User: Test User (005RM0000025zTa)
Start time: 2/11/2022, 1:57 PM
Duration: 3 seconds
How the Interview Started
Orchestration Run ID: 0jERM0000004CQT
Test User (005RM0000025zTa) started the flow interview.
API Version for Running the Flow: 54
ENTER STAGE: Stage 1
ID: 0jFRM0000004CQY
Status: Error
BACKGROUND STEP: Create Account for New Customer
ID: 0jLRM0000004Cfd
Status: Error
Entry Condition:
When the stage starts, the step starts = true
Flow (Create_Account_for_New_Customer)
Inputs:
None.
Outputs:
None.
Error Occurred: An error occurred when executing a flow interview.
Salesforce Error ID: 904995012-1848 (1749972898)
```

### 디버그 (Debug an Orchestration)

- Flow Builder에서는 **in-progress·failed run만** 디버그 상세를 볼 수 있다. 실패한 flow는 오류 이메일에서 디버그 상세를 본다.
- ⚠️ 오케스트레이션이 실패해도 실패 전에 이뤄진 레코드 추가·변경·삭제가 **반드시 롤백되지는 않는다** → **sandbox에서 설계·디버그 후 production 배포** 권장.
- 디버그 정보는 flow와 유사하며, 추가로 orchestration·stage·step·work item의 **milestone**을 보여준다 (milestone 목록은 [[Flow Orchestration]] 및 위 Run Milestone 표 참조).

**In-Progress 디버그** — orchestration run과 flow interview에 대해 **sharing이 활성화**돼 있어야 하고, 대상 run·연관 flow interview가 사용자와 공유돼 있어야 한다. App Launcher → **Orchestration Runs** → 대상 in-progress run 드롭다운 → **Debug Orchestration**. 필요 권한: Manage Orchestration Runs **OR** Manage Orchestration Runs and Work Items.

**Failed 디버그** — 실패 후 **14일 내** 가능. Setup → Quick Find `Orchestration Runs` → 대상 failed run 드롭다운 → **Debug**. 필요 권한: **Manage Flow**.

> ⚠️ **Spring '22 이전** 시작된 run을 디버그하면 stage·step instance ID가 **null**로 표시되고, evaluation flow output도 **null**로 표시된다.

---

## 한도와 고려사항 (Limits and Considerations)

### General Flow Orchestration Limits

오케스트레이션 한도 외에 flow 한도·Apex governor 한도도 함께 적용된다. per-org (Enterprise, Performance, Unlimited, Developer):

| Per-Org Limit | 값 |
|---|---|
| Versions per orchestration | **50** |
| Active flows plus orchestrations | **2,000** |
| Total flows plus orchestrations | **4,000** |

### Considerations for Orchestrations

**Entry and Exit Condition Requirements** — step entry / stage·step exit condition의 requirement에 선택하는 리소스는 오케스트레이션 리소스 또는 global variable을 담을 수 있다. 제약:
- Resource 또는 Value 필드에 **레코드를 쓰려면 반드시 레코드의 필드를 선택**해야 한다.
- 참조 레코드는 **자기 오브젝트의 필드**를 써야 하며, 관련(related) 레코드의 필드는 안 된다.

**Record-Change-Triggered Flow Orchestration Events** — requirement가 레코드 참조를 담으면, 그 레코드 변경이 현재 stage와 미결 step의 상태 평가를 트리거할 수 있다. 트리거 가능 여부에 대한 제약(PDF 원문 나열):
- 참조 레코드의 부모 오브젝트가 **change event를 지원**해야 한다.
- 참조 레코드 필드가 `IsDeleted`·`SystemModeStamp`, 또는 related 레코드/수식에서 파생된 필드가 **아니어야** 한다.
- 참조 레코드가 null이거나 유효하지 않은 ID.
- 참조 레코드가 **autolaunched 오케스트레이션의 global variable**.
- 참조 레코드가 **record-triggered 오케스트레이션에서 `$Record` 외의 global variable**.

**Input Values for Flows** — step이 호출하는 flow의 입력값 합계가 **32,768자**를 넘으면 오케스트레이션이 실패한다 (레코드 통째 전달 시 흔함 → 레코드 ID만 전달 후 flow 안 Get Records). 상세·회피 패턴은 [[Flow Orchestration]] 참조.

**Email Notifications** — step이 호출한 flow가 실패해 오케스트레이션이 실패하면 이메일 알림 **2개**(flow error notification + orchestration error notification)가 발송된다.

### Considerations for Evaluation Flows

evaluation flow = process type이 **Evaluation Flow**인 autolaunched flow, 미리 정의된 Boolean output 변수 `isOrchestrationConditionMet`를 가진다.

**General Guidelines**
- evaluation flow는 **특정 필드 업데이트가 일어날 때까지 오케스트레이션을 일시정지**시키는 용도로 쓴다.
- evaluation flow 안에서 **레코드를 loop하거나 external callout을 하지 말 것**.
- 오케스트레이션 → evaluation flow로 변수를 넘기려면 **evaluation flow input variable**을 쓴다.

**Output Variable** — `isOrchestrationConditionMet` 하나만 output, Boolean이며 **false로 초기화**해야 한다. 그 외 output 변수 값은 모두 폐기된다 (상세는 [[Flow Orchestration]]의 Evaluation Flow 섹션).

### Security Considerations for Orchestrations

**Shield Platform Encryption** — 보안 강화를 위해 **Flow Orchestration Work Item** 오브젝트의 **`Screen Flow Inputs`** 필드에 Shield Platform Encryption을 활성화한다. (암호화 일반은 [[Platform Encryption]] 참조.)

---

## Entitlements (사용량 기반)

Flow Orchestration은 usage-based entitlement를 가지며 필수 에디션(Enterprise, Performance, Unlimited, Developer — Lightning Experience, Government Cloud/Government Cloud Plus 지원)에서 **자동 활성화**된다.

| How To Get It | What's Included | Notes |
|---|---|---|
| **Free orchestration runs** | 모든 org는 **연 600 orchestration run**을 무료로 받는다. 이 run은 **12개월마다 600으로 리셋**되며, 전년도 사용량과 무관하다. | org가 **Workflow Orchestration Runs SKU를 하나 이상 보유**하면 이 무료 run은 제공되지 않는다. |
| **Workflow Orchestration Runs SKU** | **연 12 orchestration run을 org 단위(org-wide)**로 제공. | — |
| **Workflow Orchestration User SKU** | Flow Orchestration에 대해 **contractual restriction이 있는 사용자 라이선스 1개**를 제공. 오케스트레이션 step에 배정되는 **non-CRM 사용자**용. | Contractual restriction 적용. Salesforce account rep에 문의. |

> 숫자 원문 대조 완료(이미지 검증): Free = **600/년**, Workflow Orchestration Runs SKU = **12/년 org-wide**. (PDF 원문 그대로 — 두 값 모두 "orchestration runs" 단위.)

---

## Reference — 리소스 (Resources)

Flow Builder의 **Manager** 탭이 오케스트레이션에서 쓸 수 있는 리소스를 보여준다. 일부는 **New Resource**로 생성, global constant/variable은 시스템 제공, 나머지(Decision Outcome·Element·Step 등)는 요소를 추가할 때 생성된다.

| Resource | 설명 | Resources 탭에서 생성 |
|---|---|---|
| Constant | Store a fixed value that you can use throughout an orchestration. | ✔ (New Resource) |
| Decision Outcome | Decision 요소를 추가하면 각 outcome이 Boolean 리소스로 제공. 실행 중 오케스트레이션에서 그 outcome 경로가 이미 실행됐으면 값이 **True**. | 요소 추가 시 |
| Element | 추가한 모든 요소는 decision outcome 조건에서 **was visited** 연산자용 리소스로 제공. 실행되면 visited로 간주. | 요소 추가 시 |
| Formula | Calculate a value when the formula is used in the orchestration. | ✔ (New Resource) |
| Global Constant | EmptyString·True·False 같은 시스템 제공 고정값. | 시스템 제공 |
| Global Variable | org·실행 사용자 정보(사용자 ID, API session ID 등)를 참조하는 시스템 제공 변수. | 시스템 제공 |
| Step | Organize the work done in an orchestration stage. | 요소 추가 시 |
| Text Template | 오케스트레이션 전체에서 쓰는 변경 가능한 텍스트. HTML 태그로 서식. | ✔ (New Resource) |
| Variable | Store a value that can be changed throughout the orchestration. | ✔ (New Resource) |

> "Resources 탭에서 생성" 열: PDF는 체크마크 **이미지**를 쓴다(pdftotext 미포착). ✔ 표기는 PDF 본문 산문("You can create some resources by clicking New Resource … global constants and global variables … Other resources are created when you add an element")에 근거해 도출.

### Resource: Constant — 필드

| Field | Description |
|---|---|
| API Name | 유일성은 현재 오케스트레이션 내 요소에만 적용. underscore·영숫자 가능(공백 불가), 글자로 시작, underscore로 끝나면 안 되고, 연속 underscore 불가. |
| Description | 다른 리소스와 구별용. |
| Data Type | constant가 저장하는 값의 타입. **저장 후 변경 불가.** |
| Value | constant의 값. 오케스트레이션 전체에서 변하지 않음. |

### Resource: Formula — 필드

| Field | Description |
|---|---|
| API Name | (Constant와 동일 규칙) |
| Description | 다른 리소스와 구별용. |
| Data Type | 수식 반환값의 데이터 타입. **저장 후 변경 불가.** |
| Decimal Places | 소수점 이하 자릿수 최대 **17자리**. 비우거나 0이면 정수만 표시. Data Type이 Number/Currency일 때만. |
| Formula | 런타임에 평가되는 수식. 반환값은 Data Type과 호환돼야 함. 일부 수식 함수는 Flow Builder에서 미지원. |

### Resource: Global Constants

| Global Constant | Supported Data Types |
|---|---|
| `{!$GlobalConstant.True}` | Boolean |
| `{!$GlobalConstant.False}` | Boolean |
| `{!$GlobalConstant.EmptyString}` | Text |

> Boolean 변수 생성 시 `$GlobalConstant.True`/`False` 지원, Currency 변수 생성 시 지원 global constant 없음. **Null vs Empty String** — 런타임에 `{!$GlobalConstant.EmptyString}`과 null은 별개의 값. 텍스트 필드/리소스를 비우면 런타임 값은 null, empty string으로 취급하려면 `{!$GlobalConstant.EmptyString}` 설정. 조건에서 null 확인은 **is null** 연산자.

### Resource: Global Variables

| Global Variable | 설명 |
|---|---|
| `$Api` | API URL 또는 session ID 참조. merge field: `Enterprise_Server_URL_xxx`(Enterprise WSDL SOAP endpoint, xxx=API 버전), `Partner_Server_URL_xxx`(Partner WSDL SOAP endpoint), `Session_ID`. |
| `$Label` | custom label 참조. org에 custom label이 있을 때만 표시. 반환값은 컨텍스트 사용자의 언어 설정에 따라 우선순위대로: local 번역 텍스트 → 패키지 번역 텍스트 → primary label 텍스트. |
| `$Organization` | 회사 정보 참조. |
| `$Permission` | 현재 사용자의 custom permission 접근 정보 참조. |
| `$Profile` | 현재 사용자 프로필 정보(라이선스 타입·이름 등). $Profile merge field에서 표준 프로필은 profile 이름으로 참조. 사용자는 이 merge field를 참조하는 flow 실행에 자기 프로필 정보 접근이 필요 없음. |
| `$Record` | **record-triggered 오케스트레이션에서만.** 시작 시 트리거 레코드의 **복사본**을 만든다. step이 트리거 레코드에 필드 업데이트를 해도 `$Record`에는 반영되지 않음 → 트리거 레코드에 필드 업데이트하려면 record ID를 step flow에 넘겨 Get Records로 사용. step flow에 input 파라미터로 넘겨 오케스트레이션 전체에서 참조 가능. |
| `$Record__Prior` | **record가 update / created or updated 시 실행되는 record-triggered 오케스트레이션에서만.** 오케스트레이션 시작 직전 트리거 레코드가 가졌던 값을 담는다. 오케스트레이션이나 step flow에서 변경 불가. 새로 생성된 레코드가 트리거면 모든 `$Record__Prior` 값은 null. |
| `$Setup` | hierarchy 타입 custom setting 참조. org에 hierarchy custom setting이 있을 때만 표시. list 타입은 Apex에서만 접근. 계층: Organization(기본) → Profile(Organization 재정의) → User(Organization·Profile 재정의). |
| `$System` | `$System.OriginDateTime` = literal `1900-01-01 00:00:00`. date/time offset 계산용. |
| `$User` | 오케스트레이션 실행 사용자 정보. 대개 실행 사용자는 automated process user이며 이때 `$User`는 유용한 정보를 주지 않음. `$User.UITheme`/`$User.UIThemeDisplayed` = 실행 사용자가 보는 look and feel(전자=봐야 할, 후자=실제 보는). 값: `Theme1`(구 Salesforce), `Theme2`(Classic 2005), `Theme3`(Classic 2010), `Theme4d`(Lightning Experience), `Theme4t`(모바일 앱), `Theme4u`(Lightning Console), `PortalDefault`(Customer Portal), `Webstore`(AppExchange). |
| `$UserRole` | 현재 사용자의 role 정보(role 이름·ID 등). |

> **Global Variable 고려사항** — record-triggered 오케스트레이션에서 `$Record`는 다른 레코드에서 파생된 필드값(예: `Contact.Name`, `User.MediumPhotoUrl`)을 담지 않는다. Multi-select picklist·time·location global variable은 **수식에서만** 사용 가능. DB 필드에 값이 없으면 대응 merge field는 빈 값 반환.

### Resource: $Flow Global Variables

실행 중 오케스트레이션 정보를 제공. 일부는 시스템 값, 나머지는 출력값 저장으로 갱신.

| Global Variable | Supported Resource Types | Description | Value Set By |
|---|---|---|---|
| `$Flow.ActiveStages` | Stage | flow의 현재 경로에 관련된 stage 컬렉션. 이 시스템 변수는 flow **Stage 리소스**를 참조하며 오케스트레이션 **Stage 요소**가 아님. flow(오케스트레이션 step이 호출한 flow 포함)에서만 쓰이고 **오케스트레이션에서는 미지원**. | Assignment |
| `$Flow.CurrentDate` | Text, Date, Date/Time | flow interview가 이 global variable을 참조하는 요소를 실행하는 날짜. | System |
| `$Flow.CurrentRecord` | Text | 관련 레코드의 ID. 유효 오브젝트의 단일 ID여야 함(모든 custom·대부분 standard 오브젝트 유효). 사용자가 interview를 pause하거나 Wait 요소 실행 시 FlowRecordRelation 레코드 생성으로 이 레코드와 연결. ID가 유효하지 않으면 pause 실패. | Assignment |
| `$Flow.CurrentStage` | Stage | 현재 선택된 stage. flow **Stage 리소스** 참조(오케스트레이션 Stage 요소 아님). flow에서만 사용, 오케스트레이션 미지원. | Assignment |
| `$Flow.CurrentDateTime` | Text, Date, Date/Time | flow interview가 참조 요소를 실행하는 날짜·시각. | System |
| `$Flow.FaultMessage` | Text | 런타임 문제 해결을 돕는 시스템 fault 메시지. | System |
| `$Flow.InterviewGuid` | Text | interview 고유 식별자. | System |
| `$Flow.InterviewStartTime` | Text, Date, Date/Time | flow interview 시작 날짜·시각. Subflow 요소로 launch된 flow는 최초 부모 flow 시작 시각을 나타냄. | System |

### Resource: Step — 필드

오케스트레이션은 background step과 interactive step을 가진다. (Flow Orchestration의 **Step 리소스**는 Flow Builder에서 단종된 Step **요소**와 무관.)

**Background Steps** (autolaunched flow 호출, 사용자 상호작용 없음):

| Field | Description |
|---|---|
| Label | 캔버스에서 요소 식별. |
| API Name | Label 입력 후 TAB 시 자동 채움. 유일성은 현재 오케스트레이션 내만. (underscore·영숫자, 글자 시작, underscore 종료 불가, 연속 underscore 불가.) |
| Description | 리소스 용도 메모. |
| Condition | step 시작 준비 여부 판정 방법. |
| Step Name | 현재 step 시작 전 완료돼야 하는 step 지정. entry condition이 "When another step is marked complete the step starts"일 때. |
| Evaluation Flow | step 시작 여부를 판정하는 flow. entry condition이 "When the specified evaluation flow returns True, the step starts"일 때. |
| Flow | step이 실행할 autolaunched flow. |

**Interactive Steps** (screen flow 호출, 사용자 상호작용 필요):

| Field | Description |
|---|---|
| Label | 캔버스에서 요소 식별. |
| API Name | (Background Step과 동일 규칙) |
| Description | 리소스 용도 메모. |
| Condition | step 시작 또는 완료 판정 방법. |
| Step Name | 현재 step 시작 전 완료돼야 하는 step 지정. |
| Evaluation Flow | step 시작/완료 판정 flow. entry("...the step starts") 및 exit("...the step is marked Completed") 조건에서. |
| Flow | step이 실행할 screen flow. |
| Record ID | Work Guide가 배정 사용자에게 screen flow를 표시하는 레코드의 ID. |
| Username | screen flow 완료에 배정된 사용자. |

**Step Status** (전수 — [[Flow Orchestration]]의 개념 서술과 동일한 레퍼런스 표):

| Step Status | Description |
|---|---|
| Not Started | The step hasn't met its entry condition. |
| In Progress | The step was started. |
| Completed | interactive step이 exit condition 충족 / background step의 flow 완료 / 연관 stage가 오류를 만났을 때 step은 완료돼 있었음. |
| Discontinued | in progress 중 연관 stage 완료 / in progress 중 오케스트레이션 오류 / in progress 중 연관 stage 오류. |
| Error | step 오류 / background step의 autolaunched flow 오류 / interactive step의 screen flow 오류 / MuleSoft step의 MuleSoft action 오류. |

### Resource: Text Template — 필드

| Field | Description |
|---|---|
| API Name | (공통 규칙) |
| Description | 다른 리소스와 구별용. |
| Text Template | 템플릿 텍스트. 다른 리소스 참조는 merge field. |
| Rich Text | 폰트·크기·색·정렬 제어, HTML 링크·불릿·번호 목록 추가. **기본 on.** |
| Plain Text | Send email core action, 일부 AppExchange/Salesforce 개발 custom action은 plain text 기대. |

### Resource: Variable — 필드

| Field | Description |
|---|---|
| Apex Class | Apex-defined 데이터 타입용 필드 정의. **`@AuraEnabled` annotation 필드만** 오케스트레이션에서 사용 가능. |
| API Name | (공통 규칙) |
| Description | 다른 리소스와 구별용. |
| Data Type | 변수가 저장하는 값의 타입. **저장 후 변경 불가.** Record 타입=한 레코드의 여러 필드값, Apex-defined=한 Apex class의 여러 필드값 저장. (sObject → Flow Builder에서 **Record**로 변경됨.) |
| Allow multiple values (collection) | 선택 시 collection 변수. 데이터 타입과 호환되는 값 리스트 저장. Record 타입이면 연관 오브젝트 레코드 값만 저장. |
| Object | 변수에 필드값을 저장할 오브젝트. **저장 후 변경 불가.** Data Type이 Record일 때만. |
| Decimal Places | 소수점 이하 최대 **17자리**. 비우거나 0이면 정수만. Number/Currency일 때만. |
| Availability Outside the Flow | input 가능 시 오케스트레이션 시작 시점(예: Lightning page에서 시작)에 설정 가능. 기존 변수의 input/output 접근을 끄면 오케스트레이션을 호출·접근하는 앱·페이지 기능이 깨질 수 있음(URL 파라미터·process·다른 flow 등에서 접근). 같은 오케스트레이션 내 변수 할당·사용에는 영향 없음. |
| Default Value | 시작 시 변수 값. 비우면 null. Picklist·Multi-Select Picklist 변수엔 없음. |

---

## Reference — 요소·커넥터 (Elements & Connectors)

Flow Builder의 **Add Element** 메뉴에 추가 가능한 요소가 나온다. 오케스트레이션은 **Decision**과 **Stage** 요소를 담을 수 있다.

### Element: Decision

조건 집합을 평가해 결과에 따라 경로를 분기(if-then 등가). 각 경로마다 outcome을 만들고 조건을 지정, 어떤 outcome도 충족 안 되면 **Default Outcome** 경로.

| Field | Description |
|---|---|
| Label | 캔버스에서 이 outcome의 커넥터 식별. |
| Outcome API Name | (공통 규칙: 현재 오케스트레이션 내 유일, underscore·영숫자, 글자 시작, underscore 종료/연속 불가.) |
| Condition Requirements to Execute Outcome | 이 outcome 경로를 탈지 결정. outcome별 로직·조건 설정. |
| When to Execute Outcome | **record-triggered 오케스트레이션에서만.** 트리거 레코드가 업데이트되어 조건을 충족하는지에 따라 경로 결정 (예: opportunity가 Closed Won이 아닌 값에서 Closed Won으로 stage 변경). |

### Element: Stage

관련 step들을 묶음. **Stage는 순차 실행, 한 번에 하나**이며 step을 담는다. (Flow Orchestration의 **Stage 요소**는 Flow Builder의 Stage **리소스**와 무관.)

| Field | Description |
|---|---|
| Label | 캔버스에서 stage 이름 식별. |
| API Name | (공통 규칙) |
| Set Exit Condition | stage 완료 시점 판정. ① **When all steps have been marked Complete** — 모든 step이 complete면 stage complete, 다음 요소로 이동. ② **When the specified evaluation flow returns True** — 지정 evaluation flow의 `isOrchestrationConditionMet`가 true 반환할 때까지 complete하지 않음. |

**Stage Status** (전수 — 레퍼런스 표):

| Stage Status | Description |
|---|---|
| In Progress | The stage was started. |
| Completed | stage 완료 + (오케스트레이션 완료 / 진행 중 / 취소됨). |
| Suspended | 오케스트레이션 수동 suspend 시 stage가 in-progress였음. |
| Canceled | 오케스트레이션 취소 시 stage가 in progress였음. |
| Discontinued | 오케스트레이션 오류 시 stage가 in progress였음. |
| Error | stage 오류 / stage 내 background step 오류 / background step이 호출한 autolaunched flow 오류 / in progress 중 interactive step 오류 / in progress 중 interactive step의 screen flow 오류 / in progress 중 MuleSoft step 오류 / in progress 중 MuleSoft step의 MuleSoft action 오류. |

### Connectors

커넥터는 런타임에 오케스트레이션이 취할 경로를 결정. 캔버스에서 한 요소에서 다른 요소로 향하는 화살표.

| Label | Description |
|---|---|
| Unlabeled | 다음에 실행할 요소를 식별. |
| Decision outcome | Decision outcome 기준이 충족될 때 실행할 요소를 식별. |
| Go To | 이동해 다음 실행할 요소를 식별. 오케스트레이션에서 **루프** 생성용. |

> PDF의 Connectors 표에는 각 커넥터의 **Example**(화살표 아이콘 이미지) 컬럼이 있음 — pdftotext 미포착, 본 wiki에는 텍스트 설명만.

---

## Reference — 연산자 (Operators)

condition·filter에서 연산자로 값을 평가·범위 축소한다. Decision 요소의 condition에 쓰이며, Resource에 선택한 **데이터 타입별**로 지원 연산자가 다르다.

### Apex-Defined 타입 매핑

`@AuraEnabled` 필드의 Apex 데이터 타입 → Flow Orchestration 데이터 타입으로 매칭해 연산자를 결정:

| Apex Data Type | Flow Orchestration Data Type |
|---|---|
| Boolean | Boolean |
| Date | Date |
| DateTime | Date/Time |
| Decimal | Number |
| Double | Number |
| Integer | Number |
| List | Collection |
| Long | Number |
| String | Text |

### Boolean

| Operator | True if... | Supported Data Types |
|---|---|---|
| Does Not Equal | 선택 Resource 값이 Value와 불일치. | Boolean |
| Equals | 선택 Resource 값이 Value와 일치. (실행 중 오케스트레이션이 그 outcome을 탔으면 decision outcome은 true. stage 요소는 오류 없이 실행되면 true, fault면 false, 미실행이면 null.) | Boolean |
| Is Blank | Resource 값이 미설정이거나 값 없음(Is Null과 유사, Text 참조). | Boolean |
| Is Null | Resource 값이 미설정이거나 값 없음. | Boolean |
| Was Set | Resource가 record 변수의 필드이고, step이 호출한 flow에서 그 필드가 최소 한 번 값이 채워졌음. | Boolean |
| Was Visited | 선택 Resource가 오케스트레이션의 Decision 요소이고 실행 중 방문됨. | Boolean |

### Collection

| Operator | True if | Supported Data Types |
|---|---|---|
| Contains | Resource 컬렉션의 한 항목이 Value와 정확히 같은 값을 가짐. (record collection은 같은 오브젝트 타입 record 리소스만.) | 같은 데이터 타입의 Resource |
| Does Not Equal | Resource 컬렉션이 Value 컬렉션과 불일치. (두 record collection의 필드/값이 다르면 불일치.) | 같은 데이터 타입의 Collection (record는 같은 오브젝트 타입) |
| Equals | Resource 컬렉션이 Value 컬렉션과 일치. (같은 필드·같은 값이면 일치.) | 같은 데이터 타입의 Collection (record는 같은 오브젝트 타입) |
| Is Empty | 빈 컬렉션. | Boolean |
| Is Null | Resource 값이 미설정이거나 값 없음. | Boolean |

### Currency and Number

| Operator | True if | Supported Data Types |
|---|---|---|
| Does Not Equal | Resource 값 ≠ Value. | Currency, Number |
| Equals | Resource 값 = Value. | Currency, Number |
| Greater Than | Resource 값 > Value. | Currency, Number |
| Greater Than or Equal | Resource 값 ≥ Value. | Currency, Number |
| Less Than | Resource 값 < Value. | Currency, Number |
| Less Than or Equal | Resource 값 ≤ Value. | Currency, Number |
| Is Blank | 미설정/값 없음(Is Null 유사, Text 참조). | Boolean |
| Is Null | 미설정/값 없음. | Boolean |
| Was Set | record 변수 필드가 step flow에서 최소 한 번 채워짐. | Boolean |

### Date and Date/Time

| Operator | True if | Supported Data Types |
|---|---|---|
| Does Not Equal | Resource ≠ Value. | Date, Date/Time |
| Equals | Resource = Value. | Date, Date/Time |
| Greater Than | Resource가 Value보다 나중 날짜/시각. | Date, Date/Time |
| Greater Than or Equal | Resource가 Value보다 나중이거나 같음. | Date, Date/Time |
| Less Than | Resource가 Value보다 이른 날짜/시각. | Date, Date/Time |
| Less Than or Equal | Resource가 Value보다 이르거나 같음. | Date, Date/Time |
| Is Blank | 미설정/값 없음(Is Null 유사). | Boolean |
| Is Null | 미설정/값 없음. | Boolean |
| Was Set | record 변수 필드가 step flow에서 최소 한 번 채워짐. | Boolean |

### Picklist

> 이 연산자들은 리소스 값을 **텍스트 값**으로 취급. 각 연산자의 Supported Data Types는 공통: **Boolean, Currency, Date, Date/Time, Multi-Select Picklist, Number, Picklist, Text** (단 Is Blank·Is Null·Was Set은 **Boolean**).

| Operator | True if |
|---|---|
| Contains | Resource 값이 Value를 포함. (예: `{!varPicklist}`=yellow-green이면 `Contains green`은 TRUE.) |
| Does Not Equal | Resource ≠ Value. |
| Equals | Resource = Value. |
| Is Blank | 미설정/값 없음(Is Null 유사). — Boolean |
| Is Null | 미설정/값 없음. — Boolean |
| Was Set | record 변수 필드가 step flow에서 최소 한 번 채워짐. — Boolean |

### Multi-Select Picklist

> 값을 텍스트로 취급. 여러 항목이면 **세미콜론을 포함한 하나의 문자열**로 취급(각 선택을 별개 값으로 보지 않음). 예: `red; blue; green`은 세 값이 아니라 단일 값. Supported Data Types 공통: **Boolean, Currency, Date, Date/Time, Multi-Select Picklist, Number, Picklist, Text** (Is Blank·Is Null·Was Set은 **Boolean**).

| Operator | True if |
|---|---|
| Contains | Resource 값이 Value를 포함. 특정 값이 다른 값의 일부로도 포함될 수 있으면 `INCLUDES()` 함수 수식 사용 권장(예: "green"과 "yellow-green" 중 "green"만 허용하려면 INCLUDES). |
| Does Not Equal | Resource ≠ Value. **순서 중요** — 순서 불확실하면 `INCLUDES()` 사용 (예: "red; blue; green" vs "blue; green; red"는 Does Not Equal이 true). |
| Equals | Resource가 Value와 **정확히** 일치. **순서 중요** — (예: "red; blue; green" vs "blue; green; red"는 Equals가 false). |
| Is Blank | 미설정/값 없음(Is Null 유사). — Boolean |
| Is Null | 미설정/값 없음. — Boolean |
| Was Set | record 변수 필드가 step flow에서 최소 한 번 채워짐. — Boolean |

### Record

| Operator | True if | Supported Data Types |
|---|---|---|
| Does Not Equal | Resource ≠ Value. | 같은 오브젝트 타입의 Record |
| Equals | Resource = Value. | 같은 오브젝트 타입의 Record |
| Is Blank | 미설정/값 없음(Is Null 유사). | Boolean |
| Is Null | 미설정/값 없음. | Boolean |

### Text

> Supported Data Types 공통(Contains·Does Not Equal·Equals·Ends With·Starts With): **Boolean, Currency, Date, Date/Time, Multi-Select Picklist, Number, Picklist, Text**. Is Blank·Is Null·Was Set은 **Boolean**.

| Operator | True if |
|---|---|
| Contains | Resource 값이 Value를 포함. |
| Does Not Equal | Resource ≠ Value. |
| Equals | Resource = Value. |
| Ends With | Resource 값의 **끝**이 Value와 일치. |
| Is Blank | Resource 값이 **0 문자이거나 공백만**. (Text의 Is Blank는 0자/공백 판정으로 정의됨.) — Boolean |
| Is Null | 미설정/값 없음. — Boolean |
| Starts With | Resource 값의 **시작**이 Value와 일치. |
| Was Set | record 변수 필드가 step flow에서 최소 한 번 채워짐. — Boolean |

---

## Reference — 버전 속성 (Version Properties)

오케스트레이션 버전의 속성 = label + description. 이 값들이 detail 페이지 필드값을 채운다.

| Property | Description |
|---|---|
| Orchestration Label | 버전 라벨. detail 페이지·리스트 뷰에 표시. **비활성** 오케스트레이션·버전에서 편집 가능. |
| Flow API Name | 오케스트레이션 API 이름 (URL·LWC 등에서 구별용). underscore·영숫자, 글자 시작, underscore 종료/연속 불가. detail 페이지에 표시. **저장 후 편집 불가.** |
| Description | 다른 버전과 구별. detail 페이지·리스트 뷰에 표시. 비활성 오케스트레이션·버전에서 편집 가능. |

---

## 관련 노트

- [[Flow Orchestration]] — 개념·타입·Stage·Step·Work Item 설계·Evaluation Flow·Build·Deploy (짝 노트, 상호 링크)
- [[Flow 종류와 변수]] — processType 전반 (Orchestration·Evaluation Flow의 위치)
- [[Flow 네이밍 컨벤션]] — Orchestration(`ORCH`)·Evaluation(`EVAL`) 접두어 패턴
- [[Platform Admin Objects]] — FlowOrchestrationInstance·FlowOrchestrationWorkItem·FlowOrchestrationLog 등 오케스트레이션 런타임 sObject
- [[Platform Encryption]] — Shield Platform Encryption (Screen Flow Inputs 필드 암호화)
