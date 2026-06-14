---
tags: [integration, rest-api, invocable-action, actions, apex-action]
source: api_action.pdf (Actions Developer Guide v67.0, Summer '26, Tier 2)
created: 2026-06-14
aliases: [Actions API, Invocable Action, 인보커블 액션, 액션 API, actions/standard, actions/custom/apex, InvocableAction REST, 표준 액션]
---

# Actions API (Invocable Actions)

> 액션(이메일·Chatter 게시·Apex·Flow 등 "일을 수행하는" 로직)을 **공통 REST 엔드포인트**로 호출하는 API. 표준 액션 + 커스텀(Apex/Flow) 액션을 `POST /actions/.../{name}` + `inputs` JSON으로 invoke, describe 지원.

> [!note] 공식 *Actions Developer Guide v67.0* 핵심 digest. 표준 액션은 **수십 종 카탈로그**(아래 개요)이며 전체 입력/출력 명세는 공식 가이드 참조.

---

## 액션 유형

| 유형 | 설명 |
|---|---|
| **InvocableAction** | REST 공통 엔드포인트로 호출 + **describe** 지원(플랫폼의 모든 invocable action 메타 학습). 두 종류: |
| ↳ **Standard** | 즉시 사용 가능, 입출력이 미리 정의됨, 모든 org에 존재 (예: Post to Chatter, Send Email) |
| ↳ **Custom** | 정의 필요 — 예: **Apex 액션**은 `@InvocableMethod` Apex 클래스 메서드 생성 |
| **QuickAction** | (구 Publisher Action) 페이지 레이아웃 기반 레코드 생성/수정. API는 항상 sObject로 동작 |
| **StandardButton** | Edit·리드 전환 등 표준 동작 URL |
| **CustomButton** | 관리자가 지정한 URL |
| **FlowActionCall** | Flow에서 액션 호출 (Metadata API) |

> Apex 액션 정의는 [[@InvocableMethod 패턴]], Apex 측 네임스페이스는 [[Invocable Namespace]]·[[QuickAction Namespace]] 참조.

---

## 액션 호출 (Invoking)

대부분의 액션은 같은 JSON 형식으로 호출 — **최상위 키는 반드시 `inputs`** (배열, 여러 작업 batch 가능. API v35.0+).

```bash
# 표준 액션 — POST /actions/standard/{actionName}  (예: Chatter 게시 2건 batch)
POST /services/data/v67.0/actions/standard/chatterPost
{
  "inputs" : [
    { "subjectNameOrId" : "jsmith@salesforce.com", "text" : "첫 번째 게시" },
    { "subjectNameOrId" : "005...",                 "text" : "두 번째 게시" }
  ]
}
```

```bash
# 사용 가능한 Apex 액션 목록 / 특정 액션 describe — GET
GET /services/data/v67.0/actions/custom/apex
GET /services/data/v67.0/actions/custom/apex/{action_name}

# 커스텀 Apex 액션 호출 — POST /actions/custom/apex/{ApexActionName}
POST /services/data/v67.0/actions/custom/apex/ActionTestWithSObject
{
  "inputs": [
    { "objects": { "attributes": { "type": "Account" }, "Name": "Acme" } }
  ]
}
# 위 예: Account 리스트를 받아 직원 수를 1씩 늘리고 갱신된 account ID 목록 반환
```

- **포맷**: JSON·XML / **메서드**: GET, HEAD, POST / **인증**: `Authorization: Bearer <token>`
- **describe**: `GET /actions/...` 로 입력·출력 메타데이터 조회
- **`If-Modified-Since`** 헤더 사용 가능 — 액션 메타가 미변경이면 **304 Not Modified**(본문 없음). 날짜 형식 `EEE, dd MMM yyyy HH:mm:ss z`
- > [!note] **Order Management 액션**은 표준 엔드포인트가 아니라 대응 Connect REST API 리소스/Apex `ConnectApi` 메서드로 호출.

---

## 표준 액션 카탈로그 (개요)

가이드는 수십 종 표준 액션을 카테고리별로 제공한다(전체 입출력은 공식 가이드 참조):

- **협업/알림**: Post to Chatter, Email Alert, Custom Notification, Send Email
- **Knowledge**: Search Knowledge Articles, Get/Manage Data Category
- **Commerce/Revenue**: Checkout Flow, Create Subscription, Process Payment, Record Tax Transaction/Reversal, Generate Order Summary
- **Service**: Create Service Document/Report, Omni-Channel, Live Message, Conversation Intelligence/Transcript
- **Einstein/AI**: Einstein Bots, Convert Base64 Speech to Text, Apply Case Classification
- **Flow/Data**: Flow Actions, Exit Individuals from Flow, Get Data Graph Data/Metadata, Deploy Data Kit

---

## 관련 노트

- [[@InvocableMethod 패턴]] — Apex 커스텀 액션 정의(`@InvocableMethod`/`@InvocableVariable`)
- [[Invocable Namespace]] · [[QuickAction Namespace]] — Apex 측 액션 네임스페이스
- [[REST API]] — 표준 REST(sObjects·SOQL·Composite)
- [[통합 MOC]]
