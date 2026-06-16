---
tags: [release, winter_24, automation, flow, orchestration]
source: salesforce_winter24_release_notes.pdf
created: 2026-06-16
aliases: [Winter '24 Automation, 윈터 24 플로우, Flow Reactive HTTP Callout Transform]
---

# Winter '24 — Automation (Salesforce Flow & Flow Orchestration)

> 허브: [[Winter '24]]
> Winter '24(API v59.0)의 Flow 영역 전수 — Reactive Screen 컴포넌트 GA, HTTP Callout(POST/PUT/PATCH/DELETE) GA, Transform element Beta, Record-Triggered Flow의 Custom Error Message element, Data Cloud-Triggered Flow, Wait element 확대, Advanced Pause → Wait for Conditions, Flow Orchestration 요구사항 제어, Migrate to Flow, 그리고 Flow 컨텍스트 Release Update.

---

## 개요

이 노트는 Winter '24 릴리즈 노트의 **Salesforce Flow 섹션**(physical p.572~599)을 정리한 spoke다. GA/Beta/이름 변경/Release Update를 구분해 기록한다.

> 범례: **GA**=Generally Available · **Beta** · **RU**=Release Update · **변경**=Enhancement
> 허브: [[Winter '24]] · 강제 적용 항목: [[Winter '24/Release Updates]]

---

## Flow Builder

### Reactive Screen 컴포넌트로 화면 플로우 빌드 (GA)

reactive flow screen 컴포넌트로 사용자가 클릭하는 화면 수를 줄이고, single-page application처럼 느껴지는 화면을 만든다. 지원되는 standard 컴포넌트나 custom LWC를 같은 화면의 다른 컴포넌트 변경에 실시간으로 반응하도록 구성한다.

- **Where:** Essentials, Professional, Enterprise, Performance, Unlimited, Developer editions.
- **How:** API v59.0+ screen flow는 추가 단계가 필요 없다. API 57.0/58.0 flow는 Process Automation Settings → **Enable Reactive Components for Screen Flows running API Version 57.0 and 58.0**을 켠다. **이 설정은 Winter '25에 만료된다** — 그 전에 flow를 API 59.0+로 업그레이드한다.

**하위 항목(GA umbrella):**
- **Reactive Global Variables** — reactive formula에서 global variable + custom label 참조.
- **Reactive Selections** — choice 컴포넌트가 선택에 반응(Choice Lookup, Picklist, Radio Buttons).
- **More Formula Functions in Reactive Screens** — `SUBSTITUTE`, `ADDMONTHS`, `^`가 이제 reactive(API 59.0+).
- **React to Changes Using Display Text Components (Beta)** — **Beta.** Setup: Process Automation Settings → "Opt In to Reactive Display Text Beta."
- **Reactive Components Update the First Time a Screen Loads** — API 59.0+ 전용.
- **Inform Screen Reader Users of Reactive Changes** — API 59.0+. screen reader가 "Due to your recent changes, the content on the screen has changed."를 안내.

### Record-Triggered Flow에 Custom Error Message 생성 (IdeaExchange Delivered)

새 **Custom Error Message element**로 타겟 에러 메시지를 만든다. 에러 메시지는 전체 레코드 페이지의 윈도우로 표시되거나 특정 필드의 inline error로 표시된다. 연관된 레코드 변경은 rollback된다. 에러 메시지는 **before-save·after-save flow** 모두에서 만들 수 있다.

- **Where:** Essentials/Professional/Enterprise/Performance/Unlimited/Developer (Lightning Experience + Salesforce Classic).

> PDF에는 Custom Error Message UI 콜아웃((1) element 추가 → (2) 표시 위치 선택 → (3) 에러 텍스트 입력)이 있으나 pdftotext로 추출되지 않았다. 본 노트는 텍스트 설명만 담는다(다이어그램 재현하지 않음).

### 코드 없이 HTTP Callout으로 외부 서버에 Salesforce 데이터 전송 (GA)

이제 Flow Builder에서 **POST** 메서드로 외부 서버에 Salesforce 데이터를 보낼 수 있다. 이 기능은 GA되면서 Summer '23 대비 변경을 포함하며, 새 **PUT·PATCH·DELETE** 메서드로 외부 데이터 통합을 더 쉽게 한다.

- **Where:** Enterprise/Performance/Unlimited/Developer.
- 메서드: 이전엔 GET, 이제 GET/POST/PUT/PATCH/DELETE.

### Flow에서 데이터 변환 — Transform element (Beta)

새 **Transform element**로 flow resource 간 데이터 컬렉션을 변환한다. HTTP callout을 수행하는 Action element와 결합하면, 코드 없이 Salesforce 외부 데이터를 완전히 통합하는 flow를 만들 수 있다. 이전에는 Loop element + Assignment element를 사용해야 했다.

- screen flow, 트리거 없는 autolaunched flow, record-triggered flow에서 사용 가능.
- **Where:** Essentials/Professional/Enterprise/Performance/Unlimited/Developer.
- 새 merge field 구문: `[$EachItem]`은 컬렉션의 각 항목을 나타낸다. source/target data field는 최대 2개 컬렉션을 참조할 수 있다. 예: `{!Orders[$EachItem].Customers[$EachItem].Name}`.

### Data Cloud의 데이터 변경 기반 Autolaunched Flow (신규)

data model object나 calculated insight object의 변경에 따라 **Data Cloud-Triggered Flow**를 시작할 수 있다.

- **2023년 10월 23일부터 사용 가능.** DMO에 대한 Read object permission + Manage Flows 필요.
- Setup: New Flow → Data Cloud-Triggered Flow.

### Wait element를 더 많은 Flow 유형에서 사용 (변경)

**Wait for Amount of Time** element와 **Wait Until Date** element가 이제 schedule-triggered flow, autolaunched flow, orchestration에서 사용 가능하다. 이전에는 journey에서만 사용 가능했다.

### Advanced Pause → Wait for Conditions로 이름 변경 (변경)

모든 wait element가 유사한 용어를 갖도록 **Advanced Pause가 Wait for Conditions로 리네임**됐다. element의 기능은 변경되지 않았다.

### 그 외 Flow Builder 변경

- **Save the Progress of Your Flow as You Build** — 일부 element가 완전히 구성되기 전에도 저장 가능. 에러가 warning이 됨. sliding property window, undo button.
- **Screen Flow Components Retain Values After State Changes** — 재개/검증 에러/뒤로 이동 시 값 유지(Name, Address, Data Table, Email 등). API 59.0+.
- **Refresh Values Between Screens for More Components** — choice, Date, Date & Time, Number, Currency, Text, Long Text Area. Advanced 아래 "Revisited Screen Values" 옵션.
- **Get Data Cloud Records More Easily in Flow Builder** — Salesforce/Data Cloud object를 별도 섹션으로 분리.
- **Find Flow Resources More Easily in Create Records Elements.**
- **Flow Trigger Explorer** — record-triggered flow를 status 등으로 필터.

---

## Flow and Process Management — Migrate to Flow

- **Migrate Workflow Rules with Pending Time-Based Actions to Flow** — at-rest time-based action을 scheduled path로 마이그레이션.
- **Migrate Process Builder Processes with Custom Metadata in Formulas to Flows.**
- **Migrate More Workflow Rules to Flow with Increased Flow Limits** — Essentials/Professional edition이 증가된 active+total flow 한도를 받는다.
- **Some Graphs Are No Longer Available in Automation Home** — Total Completed Screen Flows by Name, Average Completion Time by Flow Name, Total Errors by Flow Name 제거.
- **Flow Extensions** — Slack action을 Flow에서 이제 action element로만 호출 가능.

---

## Flow Orchestration

- **Control Execution of Orchestration Stages and Steps with Requirements** — evaluation flow 대신 Properties panel에서 최대 **3개 requirement** 정의. Enterprise/Performance/Unlimited/Developer.
- **Extend Flow Orchestration Objects** — Flow Orchestration Run·Stage Run·Step Run·Work Item object가 Object Manager에 추가됨. custom field/relationship 추가 가능.
- **More Easily Find Orchestrations in Setup** — Quick Find "orch" → Flows.
- **Pause Background Step Flows for Minutes** — async background step의 autolaunched flow 내 Wait for Duration element가 분 단위로 일시정지 가능.

---

## Flow Integration

- **MuleSoft Composer for Salesforce(= Flow Integration)가 이제 Salesforce Flow의 일부**가 됐다.

---

## Flow / Process Release Update

> 아래는 Flow·Process 컨텍스트의 Release Update다. 시점·조치 상세는 [[Winter '24/Release Updates]]에 위임한다.

- **Disable Access to Session IDs in Flows** — flow에서 `$Api.Session_ID`. Winter '23 → Summer '23 → **Winter '24 enforced.**
- **Make Paused Flow Interviews Resume in the Same Context** — Winter '21 → Winter '22 → Spring '23 → **Winter '24 enforced.**
- **Prevent Guest User from Editing or Deleting Approval Requests** — Winter '23 → Summer '23 → **Spring '24로 연기.**
- **Enable EmailSimple Invocable Action to Respect Organization-Wide Profile Settings** — Summer '23, Spring '24 예정 → **Summer '24로 연기.**
- **Run Flows in Bot User Context** — Summer '23 first available. **Summer '24 enforced.**
- **Enforce Rollbacks for Apex Action Exceptions in REST API** — Spring '23, Spring '24 예정 → **Spring '25로 연기.**
- **Evaluate Criteria Based on Original Record Values in Process Builder** — Summer '19. **Summer '25 enforced.**
- **Restrict User Access to Run Flows** — FlowSites license deprecate. **Winter '25 enforced.**

---

## 동작 예시 (구조 참고)

```apex
// 구조 예시 — 실제 동작 코드 아님
// Transform element (Beta)의 [$EachItem] 컬렉션 매핑 의미를 Apex 유사 코드로 표현.
// 실제 Flow Builder에서는 Transform element를 캔버스에 추가해 선언적으로 구성한다.
// 위키 본문의 merge field 예: {!Orders[$EachItem].Customers[$EachItem].Name}
List<String> customerNames = new List<String>();
for (Order ord : orders) {
    for (Customer cust : ord.customers) {
        customerNames.add(cust.name);
    }
}
```

> 위 코드는 `[$EachItem]`가 컬렉션의 각 항목을 가리키는 의미만 설명하기 위한 구조 예시다. Winter '24 release notes의 Flow 섹션에는 동작 Apex 코드가 포함돼 있지 않다.

---

## 관련 노트

- [[Winter '24]] — 상위 릴리즈 허브
- [[Winter '24/Development]] — HTTP Callout·Transform과 연결되는 Apex/LWC 개발자 변경
- [[Winter '24/Einstein]] — Data Cloud-Triggered Flow와 연계되는 생성형 AI/Einstein
- [[Winter '24/Clouds]] — Data Cloud·Service의 flow 활용 맥락
- [[Winter '24/Release Updates]] — Flow·Process Release Update 시점 맵
- [[Release MOC]]
