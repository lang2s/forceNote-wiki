---
tags: [integration, rest-api, invocable-action, actions, apex-action]
source: api_action.pdf (Actions Developer Guide v67.0, Summer '26, Tier 2 — Flow Actions 소절) · extend_click_automate.pdf (Automate Your Business Processes with Salesforce Flow, Spring '26, Tier 2 — Distribute Flows to Automated Systems 개념 참조)
official_doc: https://developer.salesforce.com/docs/atlas.en-us.api_action.meta/api_action/
created: 2026-06-14
updated: 2026-07-11
aliases: [Actions API, Invocable Action, 인보커블 액션, 액션 API, actions/standard, actions/custom/apex, actions/custom/flow, Flow Actions, Flow__InterviewStatus, flow REST 실행, InvocableAction REST, 표준 액션 카탈로그, QuickAction REST]
---

# Actions API (Invocable Actions)

> 액션(이메일·Chatter·Apex·Flow 등 "일을 수행하는" 로직)을 **공통 REST 엔드포인트**로 호출하는 API. 표준 + 커스텀(Apex/Flow) 액션을 `POST /actions/.../{name}` + `inputs` JSON으로 invoke, describe 지원. **표준 액션 50+종**(아래 전수 목록).

> [!note] *Actions Developer Guide v67.0* 전수. 📖 공식: [Actions Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.api_action.meta/api_action/) (개별 액션의 전체 입력/출력 필드는 공식 가이드 각 페이지)

---

## 액션 유형

| 유형 | 설명 |
|---|---|
| **InvocableAction** | REST 공통 엔드포인트로 호출 + **describe** 지원(모든 invocable action 메타 학습). standard/custom 2종 |
| ↳ **Standard** | 즉시 사용, 입출력 미리 정의, 모든 org에 존재 |
| ↳ **Custom** | 정의 필요 — **Apex 액션**(`@InvocableMethod`) 또는 Flow |
| **QuickAction** | (구 Publisher Action) 페이지 레이아웃 기반 레코드 생성/수정. API는 항상 sObject |
| **StandardButton** | Edit·리드 전환 등 표준 동작 URL |
| **CustomButton** | 관리자 지정 URL |
| **FlowActionCall** | Flow에서 액션 호출 (Metadata API) |

> Apex 액션 정의는 [[@InvocableMethod 패턴]], Apex 측 네임스페이스는 [[Invocable Namespace]]·[[QuickAction Namespace]].

---

## 액션 호출 (Invoking)

대부분 같은 JSON — **최상위 키는 반드시 `inputs`**(배열, batch 가능. API v35.0+).

```bash
# 표준 액션 — POST /actions/standard/{actionName}
POST /services/data/v67.0/actions/standard/chatterPost
{ "inputs" : [ { "subjectNameOrId":"jsmith@salesforce.com", "text":"게시 내용" } ] }

# 사용 가능 Apex 액션 목록 / describe — GET
GET /services/data/v67.0/actions/custom/apex
GET /services/data/v67.0/actions/custom/apex/{action_name}

# 커스텀 Apex 액션 호출 — POST /actions/custom/apex/{ApexActionName}
POST /services/data/v67.0/actions/custom/apex/ActionTestWithSObject
{ "inputs": [ { "objects": { "attributes":{"type":"Account"}, "Name":"Acme" } } ] }

# 사용 가능 Flow 액션 목록 — GET /actions/custom/flow
GET /services/data/v67.0/actions/custom/flow

# 커스텀 Flow(autolaunched) 액션 호출 — POST /actions/custom/flow/{FlowApiName}
# 엔드포인트·flow명(LargeOrder)은 Actions Dev Guide 원문. inputs 본문은 구조 예시(flow의 input 변수에 따라 다름)
POST /services/data/v67.0/actions/custom/flow/LargeOrder
{ "inputs": [ { "orderId":"801xx000003GYT2AAO" } ] }   # <!-- 구조 예시 — 실제 동작 body 아님 -->
```

- **포맷** JSON·XML / **메서드** GET·HEAD·POST / **인증** `Authorization: Bearer <token>`
- **describe**: `GET /actions/...`로 입력·출력 메타 조회
- **`If-Modified-Since`**: 액션 메타 미변경 시 **304 Not Modified**(본문 없음). 형식 `EEE, dd MMM yyyy HH:mm:ss z`
- 엔드포인트 그룹: `/actions/standard/`, `/actions/custom/apex/`, `/actions/custom/flow/`, `/actions/custom/quickAction/`
- > [!note] **Order Management 액션**은 표준 엔드포인트가 아니라 대응 Connect REST API/Apex `ConnectApi` 메서드로 호출.

---

## Flow 액션 (autolaunched flow REST 실행)

> 출처: *Actions Developer Guide* — "Flow Actions". 현재 org에 존재하는 **활성 autolaunched flow**를 REST로 실행한다. **API v32.0+** (autolaunched flow), 자동화 시스템에서 사람 개입 없이 flow를 실행하는 배포 방식(ECA "Distribute Flows to Automated Systems" — 자동 시스템은 start Apex 메서드·process·workflow action·**REST API** 로 flow를 실행).

| 항목 | 값 |
|---|---|
| **목록 조회** | `GET /services/data/vXX.X/actions/custom/flow` |
| **호출(예: LargeOrder flow)** | `/services/data/vXX.X/actions/custom/flow/LargeOrder` |
| **Formats** | JSON, XML |
| **HTTP Methods** | GET, HEAD, POST |
| **Authentication** | `Authorization: Bearer <token>` |
| **Inputs** | flow에 정의된 **input 변수**에 따라 값이 달라진다(autolaunched flow의 input 변수 기준) |

### Outputs

응답에는 **`Flow__InterviewStatus`** 와 flow에 정의된 output 변수가 포함된다.

| Output | 타입 | 설명 |
|---|---|---|
| **Flow__InterviewStatus** | picklist | flow 인터뷰 상태. 유효 값: **Created · Started · Finished · Error · Waiting** |

### Legacy — Process Builder invocable process

Process Builder에서 type이 **'Invocable'** 로 만든 프로세스도 위 flow 엔드포인트로 REST 호출할 수 있다(**invocable process는 API v38.0+**). 단:

- **필수 입력**(둘 중 하나) — `sObject`(프로세스가 실행될 sObject 자체, 프로세스가 정의된 객체 타입과 동일) 또는 `sObjectId`(그 레코드의 Id, 동일 객체 타입).
- Invocable process는 **outputs가 없다**.

> Apex 커스텀 액션과 달리 Flow/Process 입력은 sObject·input 변수 중심이다. Apex 액션 정의는 [[@InvocableMethod 패턴]] 참조.

---

## 표준 액션 카탈로그 (전수 — `/actions/standard/{name}`)

> 개별 액션의 입력/출력 필드 전체는 공식 가이드의 각 액션 페이지 참조.

### 협업·알림
- Post to Chatter · Custom Notification · Send Notification · Email Alert · Simple Email · Live Message Notification

### 승인 (Approval)
- Submit for Approval · Cancel Approval Submission · Recall Approval Submission · Reassign Approval Work Item · Review Approval Work Item

### Commerce / Revenue
- Commerce Checkout Flow · Create Subscription Records · Process First Payment Billing for Subscriptions · Record Tax Transaction · Record Tax Reversal · Generate Order Summary · Preview Cart to Exchange Order · Submit Exchange Order · Apply Payment · Payment Sale · Salesforce Omnichannel Inventory · Salesforce Order Management

### Service / Field Service
- Create Service Document · Create Service Report · Generate Work Orders · Omni-Channel · Work Plan and Work Step · Apply Case Classification Recommendations · Send Conversation Messages · Explore Conversation · Get Conversation Intelligence · Get Conversation Transcript

### Knowledge / Einstein Bots
- Knowledge Actions · Search Knowledge Articles · Get Data Category Details · Get Data Category Groups · Einstein Bots Actions

### AI / Prompt / 음성
- Prompt Template Actions · Convert Base64 Speech to Text · Speech to Text · Text to Speech (Beta) · Perform Survey Sentiment Analysis

### Survey / Engagement
- Survey Invitation (Dynamic Send / Send) · Sales Engagement · Assign Enablement Program · Get Assessment Response Summary

### Flow / Data / 기타
- Flow Actions · Exit Individuals from a Flow · Deploy Data Kit Components · Get Data Graph Data By Lookup · Get Data Graph Metadata · Refresh Metric · Lead Action · Session-Based Permission Set · PlatformAction · Quick Actions

---

## 관련 노트

- 📖 공식: [Actions Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.api_action.meta/api_action/)
- [[@InvocableMethod 패턴]] — Apex 커스텀 액션 정의(`@InvocableMethod`/`@InvocableVariable`)
- [[Invocable Namespace]] · [[QuickAction Namespace]] — Apex 측 액션 네임스페이스
- [[REST API]] — 표준 REST(sObjects·SOQL·Composite)
- [[통합 MOC]]
