---
tags: [flow, processType, variable, concept]
source: dreamhouse-lwc, lwc-recipes, agent-script-recipes, Salesforce Help — Schedule-Triggered Flow Considerations (sf.flow_considerations_trigger_schedule, Tier 2), Trigger Schedule (sf.flow_concepts_trigger_schedule, Tier 2), Apex-Defined Variable (sf.flow_ref_resources_variable_apexdefined, Tier 2), extend_click_automate.pdf — Automate Your Business Processes with Salesforce Flow, Spring '26 (Tier 2)
created: 2026-05-17
aliases: [Flow 종류, Screen Flow, AutolaunchedFlow, Flow 변수, Apex-Defined 변수, Apex-Defined Variable]
---

# Flow 종류와 변수

> Flow의 processType 결정과 변수 설계. .flow-meta.xml의 가장 기본적인 구조.

---

## Flow 종류 (processType)

| processType | 실행 방식 | 화면 | 주요 사용 |
|---|---|---|---|
| `Flow` | 사용자가 직접 실행 | ✅ | 마법사형 UI, 데이터 입력 |
| `AutoLaunchedFlow` | 코드/Flow/Agent에서 호출 | ❌ | 레코드 처리, API 로직 |
| `Schedule` | 예약 실행 | ❌ | 배치 처리, 일괄 업데이트 |
| `RecordTriggeredFlow` | 레코드 저장 시 자동 실행 | ❌ | Trigger 대체, 자동화 |
| `Orchestration` | 복잡한 다단계 프로세스 | ❌ | 승인/SLA 관리 |

```xml
<!-- Screen Flow -->
<processType>Flow</processType>

<!-- Autolaunched Flow (Apex/Agent에서 호출) -->
<processType>AutoLaunchedFlow</processType>
```

### Schedule-Triggered Flow 설정 절차

Autolaunched Flow의 **Start 요소**에서 스케줄 트리거를 구성한다(트리거 없이 만들면 커스텀 버튼·프로세스·Apex·Einstein Bots 등 다른 실행 수단을 별도로 마련해야 한다). 배치 레코드 대상 스케줄 트리거의 구성 항목:

| 구성 항목 | 내용 |
|---|---|
| **시작 시각·빈도** | 지정한 시각에 시작하도록 예약하고, 실행 빈도를 **one time / daily / weekly** 중 선택 |
| **대상 객체** | 배치로 실행하려면 대상 **object**를 지정 |
| **필터 조건** | 배치에 포함될 각 레코드가 충족해야 하는 **filter conditions** 지정 |
| **실행 컨텍스트** | 스케줄 트리거 Flow는 **System context without sharing**으로 실행된다(실행 사용자 지정이 아니라 시스템 컨텍스트) |

- 배치의 **레코드 1건마다 인터뷰가 실행**되며, 각 레코드의 모든 필드 값이 `$Record` 전역 변수에 저장된다. 스케줄 Flow를 만들 때 `$Record`를 참조해 필드 값에 접근한다.
- Update Records 요소가 `$Record`의 **ID와 모든 필드 값**을 그대로 사용하도록 구성하면, 조직의 Process Automation Settings에서 **Filter inaccessible fields from flow requests**를 활성화해야 한다. 그렇지 않으면 시스템/읽기 전용 필드까지 설정하려다 Flow가 실패한다.
- 실행된 스케줄 Flow는 **Setup의 Scheduled Jobs 페이지**에서 모니터링한다.

> 근거: extend_click_automate.pdf (Spring '26) — "Schedule Triggers for Flows That Run for Batches of Records" (물리 p.35), "How Is the Flow Launched?" 컨텍스트 표 — Schedule-triggered = System context without sharing (물리 p.193–194)

### ⚠️ Schedule-Triggered Flow 한도

`Schedule` 유형으로 대량 레코드를 예약 배치 처리할 때는 다음 하드 한도를 반드시 고려한다:

- **배치 크기: 대상 레코드는 기본 200건 단위 배치로 인터뷰가 실행**된다 (레코드 1건 = 인터뷰 1건, 200건씩 묶여 처리). Summer '26부터는 Start 요소 → **Advanced Options**에서 배치 크기를 **1–200 범위로 커스텀** 설정할 수 있다 → [[Summer '26]] 릴리즈 노트 참조.
- **24시간당 실행되는 스케줄 트리거 Flow 인터뷰 수는 250,000건, 또는 조직의 사용자 라이선스 수 × 200 중 큰 값**으로 상한이 있다.
- 이 상한을 초과하는 대상 레코드를 예약하면 인터뷰가 조용히 잘리거나 밀릴 수 있으므로, 배치 설계 시 대상 레코드 수가 이 한도 안에 들어오는지 확인해야 한다.

> 근거: Salesforce Help — Schedule-Triggered Flow Considerations (`sf.flow_considerations_trigger_schedule`), Scheduled Paths/Trigger Schedule (`sf.flow_concepts_trigger_schedule`)

---

## 변수 (variables)

### 기본 구조

```xml
<variables>
    <name>customer_id</name>
    <dataType>String</dataType>
    <isCollection>false</isCollection>
    <isInput>true</isInput>    <!-- 외부에서 값 주입 가능 -->
    <isOutput>true</isOutput>  <!-- 외부로 값 반환 가능 -->
</variables>
```

### isInput / isOutput 조합

| isInput | isOutput | 용도 |
|---|---|---|
| `true` | `false` | 입력 전용 (파라미터) |
| `false` | `true` | 출력 전용 (결과 반환) |
| `true` | `true` | 입출력 양방향 |
| `false` | `false` | 내부 전용 변수 |

### dataType 종류

| dataType | 설명 | isCollection |
|---|---|---|
| `String` | 텍스트 | `false` |
| `Number` | 숫자 (정수/소수) | `false` |
| `Boolean` | 참/거짓 | `false` |
| `Date` | 날짜 | `false` |
| `DateTime` | 날짜+시간 | `false` |
| `Currency` | 통화 | `false` |
| `Id` | Salesforce Record ID | `false` |
| `SObject` | 단일 레코드 | `false` |
| `SObject` | 레코드 컬렉션 | `true` |
| `Apex` | Apex-Defined (Apex 클래스 인스턴스) — `<apexClass>` 필수 | `false`/`true` 모두 가능 |

### 레코드 변수

```xml
<!-- 단일 레코드 변수 -->
<variables>
    <name>currentCase</name>
    <dataType>SObject</dataType>
    <isCollection>false</isCollection>
    <isInput>false</isInput>
    <isOutput>true</isOutput>
    <objectType>Case</objectType>  <!-- SObject 타입 지정 -->
</variables>

<!-- 레코드 컬렉션 변수 -->
<variables>
    <name>contactList</name>
    <dataType>SObject</dataType>
    <isCollection>true</isCollection>
    <isInput>false</isInput>
    <isOutput>false</isOutput>
    <objectType>Contact</objectType>
</variables>
```

### Apex-Defined 변수 (dataType = Apex)

sObject로 표현할 수 없는 **복잡한 데이터 구조(중첩 JSON 등)를 Apex 클래스 타입으로 담는 변수**. `dataType`을 `Apex`로 지정하고 `<apexClass>`로 대상 Apex 클래스를 명시한다.

```xml
<!-- 구조 예시 — 실제 동작 설정 아님 -->
<variables>
    <name>calloutResponse</name>
    <dataType>Apex</dataType>
    <apexClass>InvoiceResponse</apexClass>  <!-- 대상 Apex 클래스 지정 -->
    <isCollection>false</isCollection>
    <isInput>false</isInput>
    <isOutput>true</isOutput>
</variables>
```

**대상 Apex 클래스 요건** — Flow에서 접근할 필드는 **`@AuraEnabled` 어노테이션이 필수**다:

```apex
// 구조 예시 — 실제 동작 코드 아님
public class InvoiceResponse {
    @AuraEnabled public String invoiceNumber;
    @AuraEnabled public Decimal amount;
    @AuraEnabled public List<String> lineItemIds;
}
```

**주 용도:**

- **HTTP Callout** — Flow의 HTTP Callout 액션이 반환하는 JSON 응답 본문을 Apex-Defined 변수로 받아 필드 단위로 매핑
- **External Services** — 등록된 외부 서비스(OpenAPI 스키마)의 요청/응답 객체를 Flow 변수로 다룰 때 자동으로 Apex-Defined 타입이 사용됨
- Invocable Apex와 Flow 사이에 sObject가 아닌 커스텀 구조체를 주고받을 때

> 근거: Salesforce Help — Flow Resource: Variable, Apex-Defined Data Type (`sf.flow_ref_resources_variable_apexdefined`)

---

## 전역 변수 ($Flow)

```
$Flow.CurrentDate       → 오늘 날짜
$Flow.CurrentDateTime   → 현재 날짜+시간
$Flow.CurrentUser.Id    → 실행 사용자 ID
$Flow.CurrentUser.Name  → 실행 사용자 이름
$Flow.FaultMessage      → 오류 메시지 (faultConnector에서)
$Flow.CurrentStage      → 현재 선택된 stage (Stage 리소스, 진행 표시기의 선택 항목)
$Flow.ActiveStages      → 현재 경로에 관련된 stage 컬렉션 (Stage 리소스)
```

> 전역 변수 전수(16종)·`$Flow` 하위 8종·Stage 진행 표시 패턴은 [[Flow 리소스 레퍼런스]] 참조.

---

## 수식 (formulas)

```xml
<formulas>
    <name>displayName</name>
    <dataType>String</dataType>
    <!-- IF, ISBLANK, AND, OR 등 Salesforce 수식 함수 사용 가능 -->
    <expression>IF(ISBLANK({!User_Name_Input}), "", ", " &amp; {!User_Name_Input})</expression>
</formulas>
```

> 수식은 변수처럼 다른 요소에서 `{!formulaName}` 으로 참조.

---

## Apex로 Flow 호출 시 변수 전달

```apex
// isInput=true 변수에 값 전달
Map<String, Object> params = new Map<String, Object>{
    'customer_id' => '12345',
    'status'      => 'Active'
};
Flow.Interview interview = Flow.Interview.createInterview(
    '',           // namespace
    'FetchCustomer',
    params
);
interview.start();

// isOutput=true 변수 값 읽기
String name = (String) interview.getVariableValue('name');
```

---

## 관련 노트

- [[Flow 요소 참조]]
- [[Screen Flow 설계]]
- [[Autolaunched Flow 패턴]]
- [[@InvocableMethod 패턴]]

- [[Flow 유틸리티 액션 모음]] — Send Email·Get Record·Duplicate Record 등 유틸리티 액션 전체
