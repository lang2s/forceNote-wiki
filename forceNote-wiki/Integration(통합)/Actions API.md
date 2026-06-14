---
tags: [integration, rest-api, invocable-action, actions, apex-action]
source: api_action.pdf (Actions Developer Guide v67.0, Summer '26, Tier 2)
official_doc: https://developer.salesforce.com/docs/atlas.en-us.api_action.meta/api_action/
created: 2026-06-14
updated: 2026-06-14
aliases: [Actions API, Invocable Action, 인보커블 액션, 액션 API, actions/standard, actions/custom/apex, InvocableAction REST, 표준 액션 카탈로그, QuickAction REST]
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
```

- **포맷** JSON·XML / **메서드** GET·HEAD·POST / **인증** `Authorization: Bearer <token>`
- **describe**: `GET /actions/...`로 입력·출력 메타 조회
- **`If-Modified-Since`**: 액션 메타 미변경 시 **304 Not Modified**(본문 없음). 형식 `EEE, dd MMM yyyy HH:mm:ss z`
- 엔드포인트 그룹: `/actions/standard/`, `/actions/custom/apex/`, `/actions/custom/flow/`, `/actions/custom/quickAction/`
- > [!note] **Order Management 액션**은 표준 엔드포인트가 아니라 대응 Connect REST API/Apex `ConnectApi` 메서드로 호출.

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
