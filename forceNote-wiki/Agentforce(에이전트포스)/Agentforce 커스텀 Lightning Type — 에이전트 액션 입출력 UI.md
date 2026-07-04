---
tags: [agentforce, custom-lightning-type, lwc, agent-script, lightning-type-bundle, agentforce-input, agentforce-output]
source: agent-script-recipes-main/force-app/main/02_actionConfiguration/customLightningTypes (실전 예시, Tier 1) + developer.salesforce.com/docs/platform/lwc/guide/targets-lightning-agentforce-input.html · targets-lightning-agentforce-output.html · docs/platform/lightning-types/guide/lightning-types-core.html · docs/ai/agentforce/guide/lightning-types-example-full-editor-renderer.html (레퍼런스, Tier 2)
created: 2026-07-04
aliases: [Custom Lightning Types, CLT, lightning__AgentforceInput, lightning__AgentforceOutput, Lightning Type Bundle, CLT Editor, CLT Renderer, 커스텀 라이트닝 타입, 에이전트 액션 UI, 에이전트 입력 폼, 에이전트 출력 카드]
---

# Agentforce 커스텀 Lightning Type — 에이전트 액션 입출력 UI

> Custom Lightning Type(CLT)으로 Agentforce 액션의 기본 입력/출력 UI를 커스텀 LWC로 대체한다 — 입력은 `lightning__AgentforceInput` 에디터 폼, 출력은 `lightning__AgentforceOutput` 렌더러 카드로. 연결 고리는 **AgentScript 액션 → Lightning Type Bundle(schema/editor/renderer.json) → LWC** 3층.

---

## 개념 — 왜 CLT인가

기본 Agentforce 대화 UI는 액션 입력을 자연어(슬롯 필링)로 받고, 출력을 텍스트로 요약한다. **CLT는 이 두 지점을 커스텀 LWC로 오버라이드**한다:

- **에디터(Editor)** — 액션 입력을 대화창 안에서 **구조화된 폼**(입력 필드·콤보박스·텍스트영역)으로 수집.
- **렌더러(Renderer)** — 액션 출력을 **리치 확인 카드**(배지·그리드·아이콘)로 표시.

이를 가능하게 하는 것이 **Lightning Type Bundle** — Apex 데이터 형태(shape)를 LWC 컴포넌트에 배선하는 JSON 설정 묶음이다. `LightningTypeBundle` 메타데이터 타입은 **API v64.0+** 에서 지원되고 1GP·2GP 패키징이 가능하다.

---

## 3층 배선 체인 (핵심 구조)

CLT는 세 계층의 연결로 동작한다. 이름(`complex_data_type_name` / `targetType` / `sourceType`)이 모두 **정확히 일치**해야 한다.

```text
// 구조 예시 — 실제 원본 다이어그램 아님 (recipe README 기반 재구성)
AgentScript 액션                Lightning Type Bundle              LWC 컴포넌트
─────────────────              ──────────────────────             ─────────────
입력:                          lightningTypes/caseInput/           lwc/caseInputEditor/
 complex_data_type_name         schema.json                         js-meta.xml:
   = "c__caseInput"    ───►       → @apexClassType/                    target: lightning__AgentforceInput
 is_user_input: True               c__CaseSubmissionService$CaseInput   targetConfig: targetType name="c__caseInput"
                                 lightningDesktopGenAi/editor.json
                                   → c/caseInputEditor

출력:                          lightningTypes/caseResult/          lwc/caseResultRenderer/
 complex_data_type_name         schema.json                         js-meta.xml:
   = "c__caseResult"   ───►       → @apexClassType/                    target: lightning__AgentforceOutput
 is_displayable: True               c__CaseSubmissionService$CaseResult targetConfig: sourceType name="c__caseResult"
 filter_from_agent: False        lightningDesktopGenAi/renderer.json
                                   → c/caseResultRenderer
```

정리:
1. **AgentScript 액션**이 입력/출력에 `complex_data_type_name`을 선언한다.
2. **Lightning Type Bundle**이 그 타입 이름을 Apex 클래스(`schema.json`)와 LWC(`editor.json`/`renderer.json`)에 매핑한다.
3. **LWC**가 커스텀 UI를 렌더한다 — 입력은 `targetType`, 출력은 `sourceType`으로 타입을 선언.

---

## 레퍼런스 1 — Lightning Type Bundle 구조

`lightningTypes/{typeName}/` 폴더 = 하나의 커스텀 타입. 구성 아티팩트 3종:

| 파일 | 필수 | 역할 |
|---|---|---|
| `schema.json` | ✅ 필수 | 데이터 구조·검증(JSON Schema). `lightning:type`으로 Apex 클래스를 참조 |
| `editor.json` | 선택 | 입력 UI 오버라이드 (에디터 LWC 지정) |
| `renderer.json` | 선택 | 출력 UI 오버라이드 (렌더러 LWC 지정) |

### 채널별 하위 폴더

`editor.json`/`renderer.json`은 **채널 하위 폴더** 안에 둔다. 채널마다 UI를 다르게 오버라이드할 수 있다:

| 채널 폴더 | 대상 |
|---|---|
| `lightningDesktopGenAi` | Lightning Experience의 Agentforce Employee 에이전트 (recipe가 쓰는 채널) |
| `enhancedWebChat` | Enhanced Chat v2 기반 Agentforce Service 에이전트 |
| `lightningMobileGenAi` | 모바일의 Agentforce Employee 에이전트 |
| `experienceBuilder` | Experience Builder (⚠️ `renderer.json` 미지원 — editor만) |

### schema.json — `@apexClassType` 문법

`lightning:type` 값으로 Apex 클래스를 가리킨다. 내부 클래스(inner class)는 `$` 구분자로 참조한다.

```json
{
    "title": "Case Input",
    "description": "Support case submission data",
    "lightning:type": "@apexClassType/c__CaseSubmissionService$CaseInput"
}
```

- `c__` = 로컬 org 네임스페이스(관리형 패키지는 패키지 네임스페이스 `isv__` 등).
- `CaseSubmissionService$CaseInput` = `CaseSubmissionService` 클래스의 inner class `CaseInput`. 데이터 형태를 서비스와 co-locate하는 패턴.
- 라벨은 `{!$Label.c.MyLabel}` 표현식으로 커스터마이즈 가능(title·description).

> ⚠️ Setup에서 `@apexClassType`을 참조하면 **"Unsupported Data Type"** 메시지가 뜰 수 있으나 **저장 결과에 영향 없음**(공식 문서 명시된 무해한 경고).

### editor.json / renderer.json — `componentOverrides`

`"$"` 키 = **타입 전체(top-level)** 오버라이드. 개별 프로퍼티 이름을 키로 쓰면 프로퍼티 단위 오버라이드도 가능하다. `definition`이 LWC 컴포넌트를 가리킨다.

```json
// editor.json — 입력 폼 오버라이드
{ "editor":   { "componentOverrides": { "$": { "definition": "c/caseInputEditor" } } } }

// renderer.json — 출력 카드 오버라이드
{ "renderer": { "componentOverrides": { "$": { "definition": "c/caseResultRenderer" } } } }
```

- **컬렉션 렌더러**: 리스트/배열 렌더링은 `"$"` 대신 `collection` 키를 쓴다(Collection Renderer Override).

---

## 레퍼런스 2 — LWC 타깃 & 메타 XML

### `lightning__AgentforceInput` (에디터)

| targetConfig 태그 | 개수 | 의미 |
|---|---|---|
| `targetType` | 최대 1 | 컴포넌트가 액션에 **되돌려 주는** 데이터 타입 (입력 수집 결과) |
| `sourceType` | 최대 1 | 컴포넌트가 **받는** 데이터 타입 (기존 값). targetType과 **함께** 둘 수 있음 |

- 두 태그 모두 속성: `name`(필수, Lightning 타입명) + `itemTypeName`(선택, `name`이 list류일 때만).
- 입력 컴포넌트가 받는 타입과 되돌리는 타입이 다르면 `sourceType` + `targetType`을 **둘 다** 선언한다.

```xml
<!-- caseInputEditor.js-meta.xml -->
<?xml version="1.0" encoding="UTF-8" ?>
<LightningComponentBundle xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>66.0</apiVersion>
    <isExposed>true</isExposed>
    <masterLabel>Case Input Editor</masterLabel>
    <targets>
        <target>lightning__AgentforceInput</target>
    </targets>
    <targetConfigs>
        <targetConfig targets="lightning__AgentforceInput">
            <targetType name="c__caseInput" />
        </targetConfig>
    </targetConfigs>
</LightningComponentBundle>
```

### `lightning__AgentforceOutput` (렌더러)

| targetConfig 태그 | 개수 | 의미 |
|---|---|---|
| `sourceType` | 최대 1 | 액션 출력이 **제공하는** Lightning 타입 (표준/커스텀). `name`(필수) + `itemTypeName`(선택) |

- `targetType`은 **출력 타깃에서 미지원** — 출력은 표시만 하므로 `sourceType`만.
- ⚠️ 커스텀 타입을 `sourceType`으로 쓰면 그 컴포넌트는 **해당 타입 전용**이 되어 다른 타입에 재사용 불가. 여러 타입 지원 시 `targetConfig`를 분리한다.

```xml
<!-- caseResultRenderer.js-meta.xml -->
<targets>
    <target>lightning__AgentforceOutput</target>
</targets>
<targetConfigs>
    <targetConfig targets="lightning__AgentforceOutput">
        <sourceType name="c__caseResult" />
    </targetConfig>
</targetConfigs>
```

### 프로퍼티 노출 (`<property>`)

`@api` 데코레이터 프로퍼티는 `<property name=".." type=".."/>`로 노출. `name`은 `@api` 프로퍼티명과, `type`은 그 타입과 일치해야 한다.

### 에디터/렌더러 LWC 계약

| 컴포넌트 | 받는 것 | 되돌리는 것 |
|---|---|---|
| **에디터** | `@api value` (기존 데이터 객체), `@api readOnly` (읽기 전용 플래그) | `valuechange` CustomEvent — `detail.value`에 폼 데이터. 필드명이 Apex 클래스 필드와 일치해야 함 |
| **렌더러** | `@api value` (액션 출력 객체 전체) | 없음 (표시 전용) |

---

## 레퍼런스 3 — AgentScript 액션 & genAiFunction 스키마

### AgentScript 액션 정의

```agentscript
actions:
   submit_case:
      description: "Submits a support case with structured input and returns case details"
      inputs:
         case_data: object
            is_required: True
            is_user_input: True                       # ← CLT 에디터 렌더링 트리거
            complex_data_type_name: "c__caseInput"     # ← Lightning Type 연결
      outputs:
         case_result: object
            complex_data_type_name: "c__caseResult"    # ← Lightning Type 연결
            filter_from_agent: False
            is_displayable: True                       # ← CLT 렌더러 렌더링 트리거
         case_number: string
      target: "apex://CaseSubmissionService"
```

- **인스트럭션 문구가 중요**: `Call {!@actions.submit_case} action's **user_input tool**` — `user_input tool` 표현이 플랫폼에 CLT 에디터를 띄우라고 지시한다.

### genAiFunction 스키마 (컴파일된 형태)

AgentScript가 배포되면 `is_user_input`/`is_displayable`는 genAiFunction의 JSON Schema로 컴파일된다:

```json
// input/schema.json
{ "properties": { "case_data": {
    "lightning:type": "c__caseInput",
    "copilotAction:isUserInput": true          // ← is_user_input 대응
} }, "lightning:type": "lightning__objectType" }

// output/schema.json
{ "properties": { "case_result": {
    "lightning:type": "c__caseResult",
    "copilotAction:isDisplayable": true,        // ← is_displayable 대응
    "copilotAction:isUsedByPlanner": true
} } }
```

---

## 실전 코드 (Tier 1 — customLightningTypes recipe 발췌)

### 에디터 LWC — `valuechange` 디스패치

```javascript
// caseInputEditor.js
import { api, LightningElement } from 'lwc';

export default class CaseInputEditor extends LightningElement {
    @api readOnly = false;
    _value = {};

    @api
    get value() { return this._value; }
    set value(val) {
        this._value = val;
        if (val) {
            this.subject = val.subject ?? '';
            this.priority = val.priority ?? '';
            this.description = val.description ?? '';
        }
    }

    subject = '';  priority = '';  description = '';
    priorityOptions = [
        { label: 'Low', value: 'Low' },
        { label: 'Medium', value: 'Medium' },
        { label: 'High', value: 'High' }
    ];

    handleInputChange(event) {
        event.stopPropagation();
        const { name, value } = event.target;
        this[name] = value;
        this.dispatchEvent(new CustomEvent('valuechange', {
            detail: { value: {
                subject: this.subject,
                priority: this.priority,
                description: this.description
            } }
        }));
    }
}
```

에디터 마크업은 `lightning-input`(Subject)·`lightning-combobox`(Priority)·`lightning-textarea`(Description)를 `lightning-card` 안에 배치하고, 모두 `onchange={handleInputChange}` + `read-only={readOnly}`를 건다.

### 렌더러 LWC — 출력 값 게터

```javascript
// caseResultRenderer.js
import { LightningElement, api } from 'lwc';

export default class CaseResultRenderer extends LightningElement {
    @api value;

    get caseNumber() { return this.value?.caseNumber ?? ''; }
    get subject()    { return this.value?.subject ?? ''; }
    get priority()   { return this.value?.priority ?? ''; }
    get status()     { return this.value?.status ?? ''; }
    // ... description, createdDate, estimatedResponse 동일 패턴

    get priorityClass() {
        switch (this.priority) {
            case 'High':   return 'slds-theme_warning';
            case 'Medium': return 'slds-theme_info';
            case 'Low':    return 'slds-theme_success';
            default:       return '';
        }
    }
}
```

렌더러 마크업은 `lightning-card`(아이콘 `standard:case`) 안에 성공 박스 + SLDS 그리드(Subject·Status·Priority 배지·Description·Created Date·Estimated Response)를 배치한다.

### Apex 데이터 형태 (inner class)

```apex
public with sharing class CaseSubmissionService {
    public class CaseInput {   // caseInput/schema.json이 참조
        @InvocableVariable(label='Subject' description='Case subject' required=true)
        public String subject;
        @InvocableVariable(label='Priority' description='Case priority')
        public String priority;
        @InvocableVariable(label='Description' description='Case description')
        public String description;
    }
    public class CaseResult {   // caseResult/schema.json이 참조
        @InvocableVariable(label='Case Number') public String caseNumber;
        @InvocableVariable(label='Subject')     public String subject;
        // ... priority, description, status, createdDate, estimatedResponse
    }
    public class SubmitCaseRequest {   // 필드명 = 액션 입력명(case_data)
        @InvocableVariable(required=true) public CaseInput case_data;
    }
    @InvocableMethod(label='Submit Case' description='Submits a support case')
    public static List<SubmitCaseResponse> submitCase(List<SubmitCaseRequest> requests) { /* ... */ }
}
```

- **필드명 일치 규칙**: `SubmitCaseRequest.case_data` / `SubmitCaseResponse.case_result`·`case_number`의 필드명이 AgentScript 액션 입력/출력명과 **정확히 일치**해야 배선된다.

---

## 배포 & 테스트 제약 (실무 함정)

| 항목 | 내용 |
|---|---|
| **Draft 미리보기 버그** | CLT 출력 렌더러 카드는 에이전트가 **Draft 상태면 Builder 미리보기 패널에 렌더되지 않음**(플랫폼 버그). commit → activate 후에 테스트해야 함 |
| **권한 세트** | 배포된 경험(Salesforce 앱 등)에서 테스트하려면 사용자 Permission Set에 **해당 에이전트 접근 권한** 필요 |
| **페이지 리로드** | 액션의 Input/Output Rendering 파라미터를 커스텀 타입으로 설정한 뒤 **에이전트 페이지를 리로드**해야 반영 |
| **텍스트 폴백 방지** | LLM 서브에이전트 인스트럭션을 UI 입력에 맞게 정렬해야 함 — 안 그러면 폼 대신 텍스트 입력으로 폴백 |
| **메타 API 버전** | `LightningTypeBundle` = v64.0+, recipe LWC = apiVersion 66.0 |

---

## 비교표

### targetType vs sourceType

| | `targetType` | `sourceType` |
|---|---|---|
| 방향 | 컴포넌트 → 액션 (되돌림) | 액션 → 컴포넌트 (받음) |
| Input 타깃 | ✅ 최대 1 (에디터의 주 용도) | ✅ 최대 1 (기존 값 주입) |
| Output 타깃 | ❌ 미지원 | ✅ 최대 1 (렌더러의 주 용도) |
| 속성 | `name`(필수)·`itemTypeName`(선택) | `name`(필수)·`itemTypeName`(선택) |

### 에디터 vs 렌더러

| | 에디터 (Editor) | 렌더러 (Renderer) |
|---|---|---|
| 타깃 | `lightning__AgentforceInput` | `lightning__AgentforceOutput` |
| 설정 파일 | `editor.json` | `renderer.json` |
| 트리거 | `is_user_input: True` | `is_displayable: True` (+ `filter_from_agent: False`) |
| 타입 선언 | `targetType` | `sourceType` |
| LWC 계약 | `@api value`·`@api readOnly` 입력 / `valuechange` 출력 | `@api value` 입력 / 출력 없음 |

---

## 관련 노트

- [[Agent Script 레퍼런스 — 액션 (apex·flow·prompt)]] — `complex_data_type_name`·`is_user_input`·`is_displayable`·`filter_from_agent` 등 액션 입출력 프로퍼티의 상위 레퍼런스
- [[Agent Script 메타데이터 배포 (DX·패키징)]] — AiAuthoringBundle·GenAiFunction 등 에이전트 메타데이터 배포 (CLT 번들 배포 맥락)
- [[Agent Script 패턴 — 액션 체이닝·조건·데이터 페치·필터링]] — 액션 실행 패턴 (submit_case 같은 액션 호출 흐름)
- [[Agentforce(에이전트포스)/index|Agentforce(에이전트포스) 인덱스]]
