---
tags: [agent-skill, sf-skills, devops, flow, automation, mcp]
source: forcedotcom/sf-skills (skills/automation-flow-generate/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [automation-flow-generate, Flow 생성 스킬, Salesforce Flow 메타데이터 생성, 3-step MCP pipeline, execute_metadata_action, inflightMetadata]
---

# automation-flow-generate — Salesforce Flow 메타데이터 생성

> MCP 도구 `execute_metadata_action`으로 Salesforce Flow를 생성한다. 필수 3-step 파이프라인(fetchGroundedObjectMetadata → flowElementSelection → flowElementGeneration)을 실행해 flow XML을 반환하는, **Flow 생성 유일 스킬**.

---

## 목적과 활성화 조건

`metadata.version: 1.0`

**Goal:** 필수 3-step MCP 파이프라인을 실행해 Salesforce Flow 메타데이터를 생성하고 flow XML 반환.

**Use when:** 모든 종류의 Flow(Screen, Autolaunched, Record-Triggered before/after-save, Scheduled) 생성 · Flow 메타데이터 XML 생성 · 코드 없는 비즈니스 프로세스 자동화 · 사용자 가이드 워크플로 또는 백그라운드 자동화 구축 · Flow 관련 배포 오류 트러블슈팅.

**Trigger 표현:** "when a record is created", "trigger daily at", "send an email when", "update the field when", "automate", "workflow", "flow XML/metadata" 같은 flow-like 요청.

### Flow 타입
| Type | 설명 |
|---|---|
| Screen Flow | 사용자 가이드(다단계 데이터 수집·결정) |
| Autolaunched Flow | 백그라운드 처리·통합 |
| Record-Triggered Flow | DB 이벤트(레코드 변경 실시간 반응) |
| Scheduled Flow | 시간 기반 반복 작업·배치 |

---

## 워크플로 / 단계

### Flow Generation Pipeline — MANDATORY 3-step

> **MANDATORY:** 이 3-step 파이프라인을 정확히 따라야 한다. 예외·shortcut·step skip 없음. flow 메타데이터 XML을 수동 생성하거나 이 파이프라인 밖에서 생성 시도 금지. 다른 도구·API·방법 사용 금지. 이 파이프라인이 flow 생성의 **유일한** 지원 방법이며, 일탈은 invalid/broken 메타데이터를 만든다.

**MCP Connection:** 3 step 모두 MCP 도구 **`execute_metadata_action`**으로 호출. `action` 파라미터가 step을 선택: `"fetchGroundedObjectMetadata"`, `"flowElementSelection"`, `"flowElementGeneration"`.

#### Step 1 (REQUIRED) — Fetch Grounded Object Metadata (`fetchGroundedObjectMetadata`)
요청에 관련된 org 스키마 메타데이터를 가져온다. 항상 먼저 호출(mandatory).
- **Inputs (all required):** `userPrompt`(STRING) 유저의 자연어 요청 · `inflightMetadata`(ARRAY) 로컬 sfdx project의 custom object/field, 불요 시 빈 배열 `[]`.
- **Outputs:** `groundingMetadata`(STRING) — org 스키마 grounded 메타데이터, JSON string. **Step 2에 직접 전달 — 이미 string이므로 재직렬화(serialize) 금지.**

#### Step 2 (REQUIRED) — Flow Element Selection (`flowElementSelection`)
user prompt와 grounded 메타데이터 기반으로 flow element(assignment, decision, record op 등)와 연결을 선택. Step 1 후 호출(mandatory).
- **Inputs (all required):** `userPrompt`(STRING, **Step 1과 동일 값**) · `groundingMetadata`(STRING, **Step 1 출력 그대로** — 재직렬화 금지) · `operationId`(STRING, 첫 호출은 빈 문자열 `""`).
- **Outputs:** `operationId`(STRING, **Step 3에 전달**) · `userOutput`(STRING, 다음 단계 reasoning — 유저에게 표시 가능).

#### Step 3 (REQUIRED) — Flow Element Generation (`flowElementGeneration`)
flow 메타데이터를 element 단위로 생성. Step 2 후 호출. **`isComplete`가 `true`가 될 때까지 루프로 반복 호출.**
- **Inputs (all required):** `operationId`(STRING, **Step 2 출력**) · `requestSource`(STRING) — XML 포맷은 **`"A4V"`**.
- **Outputs:** `isComplete`(BOOLEAN, 반드시 확인) · `result`(STRING) — `isComplete`가 `true`일 때**만** 최종 flow 메타데이터 포함.

> **MANDATORY: Loop until complete. 절대 일시정지하거나 계속 진행 여부를 유저에게 묻지 않는다.**
> - flow는 element가 **몇 개든(10, 15, 그 이상)** 가능. 호출당 element 1개 생성 — **많은** iteration 정상.
> - `isComplete`가 `false`이고 **오류 없으면** 반드시 **같은 `operationId`**(Step 2의)로 다시 호출. 묻지 말고, 일시정지·중간 요약 없이 계속 호출.
> - `isComplete`가 `true`거나 invocable action이 오류 반환할 때까지 **멈추지 않음**. iteration **최대치 없음**.
> - `isComplete`가 `true`이면 `result`에서 메타데이터 추출. 오류 반환 시 루프 중단하고 유저에게 오류 표면화.

**STRICT CONSTRAINTS (생성 파이프라인이 반환한 XML에 적용):**
- 어떤 block 내부 content·value·child node도 수정 금지.
- 새 node·tag·attribute·text 추가 금지(누락된 label, X/Y 좌표 등도 추가 금지).
- 기존 node 제거 금지.

### inflightMetadata Format
**DATA TYPE: ARRAY (string 아님)**

**STRICT NAMING — 정확히 따를 것:**
| Property | Correct Name | Do NOT Use |
|---|---|---|
| Object API name | `apiName` | `objectApiName`, `name`, `objectName` |
| Field API name | `apiName` | `fieldApiName`, `name`, `fieldName` |
| Field type | `type` | `fieldType`, `dataType` |
| Lookup target | `referenceTo` | `relatedTo`, `lookupTo`, `reference` |

custom object 필요 시(여러 field data type 샘플):
```json
[
  {
    "type": "CustomObject",
    "apiName": "CustomerRequest__c",
    "label": "Customer Request",
    "fields": [
      { "apiName": "Status__c", "type": "Picklist", "label": "Status", "values": ["New", "In Progress", "Completed"] },
      { "apiName": "Priority__c", "type": "Number", "label": "Priority" },
      { "apiName": "AssignedTo__c", "type": "Lookup", "label": "Assigned To", "referenceTo": "User" },
      { "apiName": "Description__c", "type": "Textarea", "label": "Description" },
      { "apiName": "Email__c", "type": "Email", "label": "Contact Email" },
      { "apiName": "DueDate__c", "type": "Date", "label": "Due Date" },
      { "apiName": "IsUrgent__c", "type": "Boolean", "label": "Is Urgent" },
      { "apiName": "Amount__c", "type": "Currency", "label": "Amount" }
    ],
    "relationships": []
  }
]
```
**Supported field types:** Text, Textarea, Number, Picklist, Lookup, Email, Phone, URL, Date, Datetime, Boolean, Checkbox, Currency, Percent

custom object 불요 시: `[]`

**MANDATORY Decision Logic for inflightMetadata (ARRAY):**
1. **REQUIRED - First:** 로컬 sfdx project에서 flow 요청에 관련된 custom object/field 스캔.
2. **관련 custom object 발견 시:** 구조화된 object 배열로 추출·전달(위 포맷).
3. **관련 없으면:** 빈 배열 `[]`(문자열 `"[]"` 아님).
4. **NEVER:** 텍스트 설명·지시·string 표현 전달 금지.
5. **MANDATORY:** 데이터 타입은 ARRAY(STRING 아님).

custom object 매핑 시: `apiName`(custom은 `__c` suffix) · `label` · `type`=`"CustomObject"` · `fields`(각 field: `apiName`, `type`, `label`, picklist만 `values`, lookup만 `referenceTo`). flow에 관련된 object·field만 포함.

### Mandatory Enhancement Rules
- **userPrompt** REQUIRED. **단일 flow**: 유저 prompt 그대로. **다중 flow**: 요청을 **분할**해 flow별로 ONE flow만 기술하는 별도 `userPrompt` 작성. 전체 multi-flow 요청을 한 `userPrompt`로 전달 금지.
- **inflightMetadata** REQUIRED. 항상 ARRAY. 불요 시 `[]`, 관련 시 구조화 object 배열. string `"[]"` 금지, 텍스트 설명 금지.

### MANDATORY: Multiple Flows = Multiple Separate Pipelines
**FIRST:** 파이프라인 step 호출 전 유저 요청에 다중 flow가 있는지 확인. 있으면 단일-flow prompt로 분할. 각 flow가 자체 3-step 파이프라인을 갖고, `userPrompt`는 그 한 flow만 기술.

**NEVER** multi-flow 요청을 한 `userPrompt`로 전달, **NEVER** 여러 flow 설명을 한 `userPrompt`로 묶음.

다중 flow 요청 시: 1) 개별 flow 설명으로 **분할** · 2) flow별 별도 3-step 파이프라인(그 한 flow만 기술하는 `userPrompt`) · 3) 모든 파이프라인 **SEQUENTIALLY 실행 — NEVER parallel**. 첫 flow 후 멈추지 않음, 유저 요청 대기 없음, 요약·중단 없음 — 모든 요청 flow를 완전 생성할 때까지 진행.

**Mandatory Rules:**
- N개 flow면 N개의 분리된 3-step 파이프라인이 있어야 하고 ALL N개 실행. 첫 flow 후 멈춤 금지.
- 다음 flow 파이프라인 시작 **전에** 현재 flow 파이프라인을 완전 완료(Step 3 루프 `isComplete=true` 또는 오류까지). 파이프라인 interleave/parallel 금지 — **모두 SEQUENTIAL**.
- 한 flow 완료 후 **즉시** 다음 flow 시작. flow 간 일시정지·요약·유저 확인 대기 없음.
- flow별로 로컬 sfdx project 스캔해 그 flow prompt에 **특정한** custom object/field로 `inflightMetadata` 채움.

### Example Tool Calls

**Example 1 — Standard objects only (no custom objects)**

Step 1 — fetchGroundedObjectMetadata:
```json
{
  "userPrompt": "Create a scheduled-triggered Flow named Daily_Good_Morning that runs daily at 6:00 AM and sends an email to the running user saying good morning.",
  "inflightMetadata": []
}
```
Step 2 — flowElementSelection:
```json
{
  "userPrompt": "Create a scheduled-triggered Flow named Daily_Good_Morning that runs daily at 6:00 AM and sends an email to the running user saying good morning.",
  "groundingMetadata": "<groundingMetadata string from Step 1 — pass directly, do not serialize again>",
  "operationId": ""
}
```
Step 3 — flowElementGeneration (loop):
```json
{
  "operationId": "<operationId from Step 2>",
  "requestSource": "A4V"
}
```
같은 `operationId`로 `isComplete`가 `true`거나 오류 반환까지 반복 호출. element 수만큼 여러 iteration 예상. `isComplete=true`일 때 `result`에서 메타데이터 추출. XML은 `"requestSource": "A4V"`.

**Example 2 — With custom objects from local sfdx project**

Step 1 — fetchGroundedObjectMetadata:
```json
{
  "userPrompt": "Create a flow that updates the status of a Customer Request when it's assigned",
  "inflightMetadata": [
    {
      "type": "CustomObject",
      "apiName": "CustomerRequest__c",
      "label": "Customer Request",
      "fields": [
        { "apiName": "Status__c", "type": "Picklist", "label": "Status", "values": ["New", "In Progress", "Completed"] },
        { "apiName": "AssignedTo__c", "type": "Lookup", "label": "Assigned To", "referenceTo": "User" }
      ],
      "relationships": []
    }
  ]
}
```
이후 Step 2(Step 1의 `groundingMetadata`)·Step 3(Step 2의 `operationId`) 동일 패턴.

---

## 핵심 규칙·가드레일

### Mandatory Best Practices
- **ALWAYS** 3-step 파이프라인 따름(fetchGroundedObjectMetadata → flowElementSelection → flowElementGeneration). 유일한 방법, 대안 없음.
- 파이프라인 밖에서 flow 메타데이터 XML/JSON 등 수동 생성 금지.
- **유저가 이미 생성된 flow XML의 validation/deployment 오류 fix를 명시적으로 요청할 때**는 그 오류 해결을 위한 targeted 수동 XML 편집 허용 — "no manual metadata" 규칙의 유일 예외.
- step skip/combine으로 "optimize" 금지. 각 step은 atomic·required.
- **NEVER** step skip, **NEVER** 3 step 미호출 생성, **NEVER** 파이프라인 일탈(구조를 안다고 생각해도).
- 단일 flow: 유저 prompt를 `userPrompt`로. 다중 flow: flow별 별도 3-step **SEQUENTIALLY** 실행, ALL 실행(첫 후 멈춤 금지).
- flow 요구사항은 `userPrompt`에, `inflightMetadata`에 넣지 않음. `inflightMetadata`는 로컬 project의 custom object/field 메타데이터 전용.
- Step 3는 Step 2의 같은 `operationId`로 `isComplete=true` 또는 오류까지 루프. 조기 중단·계속 질문 금지(iteration 수 무관).
- `result`에서 메타데이터는 `isComplete=true`일 때만 추출.

### CRITICAL Verification Checklist (모든 flow 생성 전·후 검증)
> 이 체크리스트를 정확히 따르지 않으면 broken/missing flow 메타데이터가 된다.

- [ ] **Pipeline:** 3 step 모두 strict order 호출, skip 없음
- [ ] **No manual metadata:** 파이프라인 밖에서 수동 생성/수정 안 함
- [ ] **No deviation:** 대체 도구·API·방법 미사용
- [ ] **userPrompt** 단일 flow prompt 포함. 다중 flow면 분할되어 각 파이프라인이 한 flow만 기술하는 `userPrompt` 수신
- [ ] **userPrompt** Step 1·Step 2에 일관 전달(동일 값)
- [ ] **inflightMetadata** ARRAY(string 아님), 불요 시 `[]`, 로컬 project 스캔으로 구조화 object 포함
- [ ] **inflightMetadata** `"[]"`(string) 아님, 텍스트 설명·지시 미포함
- [ ] **groundingMetadata** Step 1 출력을 Step 2 입력에 직접 전달(이미 string — 재직렬화 금지)
- [ ] **operationId** Step 2 출력을 Step 3 입력에 전달
- [ ] **requestSource** 항상 `"A4V"`
- [ ] **Step 3** 같은 `operationId`로 `isComplete=true` 또는 오류까지 루프 — 일시정지·계속 질문 없음(iteration 수 무관)
- [ ] **Multi-flow** 각 flow 전체 파이프라인을 다음 flow 시작 전 완료(interleave 없음)
- [ ] **result** `isComplete=true`일 때만 XML 추출
- [ ] **No additions to XML** 원본 파이프라인 출력에 없던 element·attribute·property 추가 없음(`<label>`, `<description>` 등 삽입 없음). 최종 XML은 파이프라인 반환과 동일해야 함
- [ ] **Error fix exception** 유저가 validation/deployment 오류 fix를 명시 요청했으면 targeted 수동 XML 편집 허용, "No additions to XML"/"No manual metadata" 제약은 그 편집에 미적용

---

## 번들 파일

`SKILL.md` 단일 파일(추가 references/assets 없음). 본 스킬은 명세·파이프라인 정의가 SKILL.md 본문에 내장되어 있다.

---

## 관련 노트
- [[checking-devops-prerequisites]]
- [[platform-metadata-deploy]]
- [[platform-flexipage-generate]]
