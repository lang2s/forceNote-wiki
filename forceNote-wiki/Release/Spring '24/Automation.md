---
tags: [release, spring_24, automation, flow, orchestration]
source: salesforce_spring24_release_notes.pdf
created: 2026-06-16
aliases: [Spring '24 Automation, 스프링 24 플로우, Flow Builder Orchestration Reactive Repeater Transform]
---

# Spring '24 — Automation (Flow & Flow Orchestration)

> Spring '24 Automation spoke: Flow Builder의 reactive 화면(Repeater·Transform 베타, 컴포넌트 반응성 GA), Data Cloud / Prompt Builder / HTTP Callout 연동, segment-triggered flow의 Wait Until Event, 그리고 Flow Orchestration의 실행 컨텍스트·리포트·알림 제어 변경을 다룬다.

> 허브: [[Spring '24]]

---

## Flow Integration

- **MuleSoft Composer for Salesforce** (인트로): 코드 없이 Salesforce와 외부 시스템을 통합하는 MuleSoft Composer가 소개됐다. Enterprise, Performance, Unlimited Edition에서 **추가 비용(extra cost)** 으로 제공된다.

---

## Flow Builder Updates

### Template-Triggered Prompt Flows (GA · 신규)
Prompt Builder와 연동되는 신규 flow 유형. flow에 **Add Prompt Instructions** element를 추가해 prompt template을 호출하고 결과를 활용한다.

- 에디션: **Enterprise / Unlimited / Unlimited+** + **Einstein add-on**.
- 주의: **Winter '24에서 만든 prompt template과는 비호환**이다(Spring '24 prompt template 필요).
- Einstein / Prompt Builder 영역과 상호 관계 → [[Spring '24/Einstein]]

### Send Data to Data Cloud using Flows (신규)
flow에서 **Ingestion API**를 통해 코드 없이 Data Cloud로 데이터를 전송한다.

- 절차: 먼저 Data Cloud에서 **Ingestion API connector**를 생성·구성한 뒤, flow에 **`Send to Data Cloud`** action을 추가한다.
- 각 connector schema마다 **고유한 invocable action**이 생성된다.
- 에디션: **all editions**.

### Verify Your API Connection via HTTP Callout (신규)
HTTP Callout의 API response를 구성할 때 새로운 **Connect for Schema** 옵션을 선택할 수 있다.

- Connect for Schema는 API endpoint에 실시간으로 연결해 **정확한 real-time sample response body**를 가져오고, 이를 기반으로 HTTP Callout을 자동 구성한다.
- 에디션: **Enterprise / Performance / Unlimited / Developer**.

### Repeater Component (Beta)
화면에 컴포넌트 묶음을 배치하고, 사용자가 런타임에 그 묶음을 **복제 추가**할 수 있게 한다. 예: 보험 정책의 beneficiary 정보(이름·생년월일·관계)를 여러 명 수집.

- **Lightning runtime 전용**.
- Repeater가 만든 인스턴스 리스트는 **Loop element**로 순회·저장한다.
- 지원 child 컴포넌트 (verbatim): Checkbox, Checkbox Group, Currency, Date, Date & Time, Long Text Area, Multi-Select Picklist, Number, Password, Picklist, Radio Buttons, Text, Display Text.

### Transform Element (Beta)
flow resource 간 컬렉션 데이터를 변환하는 신규 element.

- 집계: 소스 컬렉션의 항목 **sum(합계)** 또는 **count(개수)** 계산. 예: 회사 location별 직원 수 컬렉션에서 location 개수를 count하거나 전체 직원 수를 sum.
- target에 **fixed value** 할당도 지원.
- 런타임: **Lightning / Classic** 모두.

### Use More Components to React to Changes on the Same Screen (GA)
**Display Text** 및 **Long Text** 컴포넌트가 같은 화면의 다른 컴포넌트 변경에 반응한다. 예: Currency 컴포넌트에 도매가를 입력하면 Display Text가 즉시 갱신.

- 이번 GA에서 **visual enhancement** 추가: decimal, comma, currency, date 포맷팅.
- **Lightning runtime 전용**.

### Text Templates React to Changes on Same Screen (변경)
**Text Template** resource가 실시간으로 변경에 반응한다. Display Text 컴포넌트에 Text Template을 포함하면, 사용자가 입력을 바꿀 때마다 표시 텍스트가 갱신된다.

### Validate User Input for More Screen Components (변경)
입력 검증을 지원하는 화면 컴포넌트가 확대됐다: **Name / Address / Data Table**.

- 단, choice를 렌더링하는 컴포넌트(예: **Radio Buttons**)는 미지원.

### Wait for Engagement Events in Segment-Triggered Flows with the Wait Until Event Element (신규)
**segment-triggered flow**에서 email / SMS **engagement**(이메일 열람, 링크 클릭 등) 기반으로 flow를 재개하는 신규 **Wait Until Event** element.

- 절차: segment-triggered flow를 열고 canvas에 Wait Until Event element를 추가, 속성에서 engagement 조건을 구성.
- 에디션: **Enterprise / Unlimited** + **Marketing Cloud Growth**.

### Run Event-Triggered Flows as Workflow User (변경)
event-triggered flow를 **트리거를 발생시킨 사용자**로 실행할지, **default workflow user**로 실행할지 선택할 수 있다.

- 위치: Start element의 **Advanced Settings**.

### Save the Progress of Your Flow as You Build (변경)
**Screen 및 Action element를 제외한** element는 미완성 상태로도 flow를 저장할 수 있다. 미완성 구성은 더 이상 error가 아니라 **warning**으로 처리된다.

### Find and Select Flow Resources More Easily (변경)
향상된 resource selection이 Create Records뿐 아니라 **Delete / Get / Update Records** element에도 적용된다.

### Use Predictions from Your AI Models in Flows (변경)
**autolaunched flow**에서 model endpoint action을 통해 AI model 예측 결과를 사용할 수 있다.

---

## Flow Testing & Debugging

### Debug Data Cloud-Triggered Flows (신규)
기존 Data Cloud record를 사용해 **실제 record에 영향을 주지 않고** Data Cloud-triggered flow를 테스트·디버그한다.

---

## Flow Runtime

### Maintain Your Previous Selections When You Search a Data Table (변경)
Data Table에서 검색을 수행한 뒤에도 **이전 선택이 유지**된다. **Lightning runtime 전용**.

---

## Flow and Process Management

### View Performance Details for Segment-Triggered Flows (변경)
**Performance** tab에서 segment-triggered flow의 **error 통계**를 확인할 수 있다.

- 에디션: **Enterprise / Unlimited** + **Marketing Cloud Growth**.

### Migrate Even More Processes with Migrate to Flow (변경)
**invocable action을 제외한** 프로세스의 **부분 마이그레이션(partial migration)** 이 가능하다. 마이그레이션되지 않은 부분은 **Needs Review**로 표시된다.

### Delete Workflow Rules from Managed Packages (변경)
**1GP / 2GP managed package**에 포함된 workflow rule을 삭제할 수 있다.

### Identify Flows Containing Email Alerts (변경)
Email Alerts Setup에 **Flows Using This Email Alert** section이 추가되어, 특정 Email Alert를 사용하는 flow를 식별할 수 있다.

### Have Unlimited Paused and Waiting Flows (변경 · 거버너)
paused / waiting flow interview의 **org당 usage 한도가 제거**됐다.

- 단, **storage 한도는 그대로 남는다**.

---

## Flow Extensions

### Salesforce Relaunches Four Previously Enforced Release Updates (변경)
이전에 enforce됐던 4개 release update가 **Winter '25에 재enforce**된다 → 상세: [[Spring '24/Release Updates]]

- Run Flows in User Context via REST API
- Make Flows Respect Access Modifiers
- Disable Access to Session IDs
- Enable Partial Save for Invocable Actions

### Manage Your MuleSoft Anypoint Platform Connection (Beta)
**MuleSoft Services Setup**에서 MuleSoft Anypoint Platform 연결을 관리한다. **Automation Starter / Advanced SKU**.

### Use Custom Input Validations with Screen Extension Components (변경)
모든 screen extension component에 **custom validation** + formula를 적용할 수 있다.

지원 컴포넌트 (verbatim): Appointment Scheduling, Address, Data Table, Dependent Picklists, Email, Display Image, Lookup, Name, Phone, Slider, Toggle, URL, Slack Channel Selector, Slack Workspace Selector, File Upload, Call Script, Enhanced Message.

### Use Media Type Mapping Options for Importing APIs with MuleSoft Services (변경)
MuleSoft Services로 API를 import할 때 **media type mapping** 옵션을 사용할 수 있다.

---

## Flow Orchestration

### Control the User Context of a Background or MuleSoft Step (신규 · API v60.0)
**API version 60.0**부터 background step과 MuleSoft step의 **default running user가 Automated Process User로 변경**된다.

- Automated Process User가 feature/record/external credential에 필요한 access가 없는 경우, **Select Who to Run the Action As** section에서 실행 사용자를 지정한다.
- 배경: MuleSoft step이 호출하는 action은 external credential과 연결되는데, Automated Process User가 해당 external credential에 access가 없으면 step이 실패한다.
- 에디션: **Enterprise / Performance / Unlimited / Developer**.

### Use Reports for Flow Orchestration Objects (신규)
Flow Orchestration 객체용 신규 **custom report type** (verbatim):

- Orchestration Runs Spring '24
- Orchestration Stage Runs Spring '24
- Orchestration Step Runs Spring '24
- Orchestration Work Items Spring '24
- Orchestration Run Logs Spring '24

각 custom report type에는 연관된 sample report가 제공된다(예: Sample Report: Orchestration Runs).

### Disable Default Email Notifications for Orchestration Work Items (신규)
신규 **Stop Sending Orchestration Work Item Default Email Notifications** setting으로, 사용자·그룹·큐에 발송되는 work item 알림 이메일을 끌 수 있다.

### Fine-Tune Access to Flow Orchestration Functions (변경)
기존 *Manage Orchestration Runs and Work Items* 대신 세분화된 신규 user permission 도입:

- **Reassign Orchestration Work Items** — orchestration work item 재할당 가능.
- **Manage Orchestration Runs** — orchestration 취소 또는 debug 가능.

### Other Changes
- **Variable Values Visible in Debugger Details** — debugger details에서 변수 값 확인 가능.
- **Paused Flow Interview Limit Removed** — paused / waiting orchestration run 한도 제거.
- **New Save-Time Warning Message** — 저장 시점 신규 경고 메시지.

---

## Flow Release Updates

아래 release update는 모두 상세를 [[Spring '24/Release Updates]]에 위임한다(여기서는 1줄 요약 + enforce 시점만).

- **Send Email Actions Use the Org-Wide Profile (EmailSimple)** — Summer '24 enforce.
- **Enforce Sharing Rules When Apex Launches a Flow** — Winter '25 enforce.
- **Prevent Guest User from Editing Approval Requests** — Winter '25 enforce.
- **Restrict User Access to Run Flows** — Winter '25 enforce (FlowSites deprecate).
- **Enable Secure Redirection for Flows** — Spring '25 enforce.
- **Enforce Rollbacks for Apex Action Exceptions in REST API** — Spring '25 enforce.
- **Run Flows in User Context via REST API** — Winter '25 enforce.
- **Evaluate Criteria Based on Original Record Values in Process Builder** — Summer '25 enforce.
- **Make Flows Respect Access Modifiers for Legacy Apex Actions** — Winter '25 enforce.
- **Disable Access to Session IDs in Flows** — Winter '25 enforce.
- **Enable Partial Save for Invocable Actions** — Winter '25 enforce.

---

## 동작 예시 (구조 참고)

```apex
// 구조 예시 — 실제 동작 코드 아님
// Transform element (Beta)의 sum / count 개념을 Apex 유사 코드로 표현.
// 실제 Flow Builder에서는 캔버스에 Transform element를 추가해 선언적으로 구성한다.
Integer locationCount = companyLocations.size();          // count
Decimal totalEmployees = 0;                               // sum
for (Location__c loc : companyLocations) {
    totalEmployees += loc.Employee_Count__c;
}
```

> 위 코드는 Transform element의 집계 의미만 설명하기 위한 구조 예시다. Spring '24 release notes에는 동작 코드가 포함돼 있지 않다.

---

## 관련 노트
- [[Spring '24]]
- [[Spring '24/Development]] — Template-Triggered Prompt Flow와 연결되는 Apex `@InvocableMethod` `capabilityType` 등 개발자 통합
- [[Spring '24/Einstein]]
- [[Spring '24/Clouds]]
- [[Spring '24/Release Updates]]
