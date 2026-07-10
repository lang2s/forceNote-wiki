---
tags: [flow, element, xml, reference]
source: dreamhouse-lwc/Create_property, agent-script-recipes, api_meta.pdf (Metadata API — Flow), extend_click_automate.pdf (Spring '26)
created: 2026-05-17
aliases: [Flow Elements, Flow XML, recordLookups, decisions, assignments, screens, loops, subflows, waits, collectionProcessors, customErrors, recordRollbacks, dynamicChoiceSets]
---

# Flow 요소 참조

> .flow-meta.xml 에서 사용하는 요소들. 각 요소의 XML 구조와 연결(connector) 패턴.

---

## 요소 종류 한눈에 보기

| XML 요소 | Flow Builder 이름 | 역할 |
|---|---|---|
| `recordLookups` | Get Records | SOQL 조회 |
| `recordCreates` | Create Records | 레코드 생성 |
| `recordUpdates` | Update Records | 레코드 수정 |
| `recordDeletes` | Delete Records | 레코드 삭제 |
| `decisions` | Decision | 조건 분기 |
| `assignments` | Assignment | 변수에 값 대입 |
| `loops` | Loop | 컬렉션 반복 |
| `screens` | Screen | 사용자 입력 화면 |
| `actionCalls` | Action | Apex/외부 액션 호출 |
| `subflows` | Subflow | 다른 Flow 호출 |
| `formulas` | Formula | 계산 수식 |
| `waits` | Wait | 일시 정지 (예약) |
| `start` | Start | 플로우 시작·트리거 지정 (모든 플로우에 1개) |
| `transforms` | Transform | 소스 데이터 → 타겟 데이터 변환 |
| `collectionProcessors` | Collection Filter / Collection Sort / Recommendation Assignment | 컬렉션 필터·정렬·매핑 |
| `customErrors` | Custom Error | 트랜잭션 롤백 + 사용자 정의 오류 메시지 |
| `recordRollbacks` | Roll Back Records | 현재 트랜잭션 롤백 (Screen Flow 전용) |
| `dynamicChoiceSets` | (Choice 리소스) | 런타임에 레코드·picklist 기반 선택지 동적 생성 |

> API 버전: `start` v47.0+, `transforms` v59.0+, `collectionProcessors` v50.0+, `customErrors`·`recordRollbacks` v52.0+, `dynamicChoiceSets`(picklist) v35.0+. (api_meta.pdf, 물리 1252–1308)

---

## recordLookups — Get Records

```xml
<recordLookups>
    <name>Get_Contact</name>
    <label>Get Contact</label>
    <locationX>176</locationX>
    <locationY>134</locationY>

    <!-- 결과 없으면 null 할당 여부 -->
    <assignNullValuesIfNoRecordsFound>false</assignNullValuesIfNoRecordsFound>

    <!-- 첫 번째 레코드만 (true) vs 전체 컬렉션 (false) -->
    <getFirstRecordOnly>true</getFirstRecordOnly>

    <filterLogic>and</filterLogic>
    <filters>
        <field>Customer_ID__c</field>
        <operator>EqualTo</operator>
        <value>
            <elementReference>customer_id</elementReference>  <!-- Flow 변수 참조 -->
        </value>
    </filters>

    <object>Contact</object>

    <!-- 자동 저장 (storeOutputAutomatically=true) → 요소명으로 직접 접근 -->
    <storeOutputAutomatically>true</storeOutputAutomatically>

    <!-- 또는 outputAssignments로 특정 필드만 변수에 매핑 -->
    <outputAssignments>
        <assignToReference>name</assignToReference>
        <field>LastName</field>
    </outputAssignments>

    <connector>
        <targetReference>Next_Element</targetReference>
    </connector>
    <faultConnector>
        <targetReference>Error_Screen</targetReference>
    </faultConnector>
</recordLookups>
```

**storeOutputAutomatically vs outputAssignments:**

| 방식 | 접근 방법 | 사용 시점 |
|---|---|---|
| `storeOutputAutomatically` | `{!get_contact.LastName}` | 전체 레코드 필드에 접근 |
| `outputAssignments` | `{!name}` (별도 변수) | 특정 필드만 별도 변수로 |

---

## recordCreates — Create Records

```xml
<recordCreates>
    <name>create_property</name>
    <label>Create Property</label>
    <object>Property__c</object>

    <inputAssignments>
        <field>Name</field>
        <value>
            <elementReference>property_name</elementReference>
        </value>
    </inputAssignments>
    <inputAssignments>
        <field>Status__c</field>
        <value>
            <stringValue>Available</stringValue>  <!-- 리터럴 값 -->
        </value>
    </inputAssignments>
    <inputAssignments>
        <field>Date_Listed__c</field>
        <value>
            <elementReference>$Flow.CurrentDate</elementReference>  <!-- 전역 변수 -->
        </value>
    </inputAssignments>

    <!-- true면 생성된 레코드 ID를 요소명으로 자동 저장 -->
    <storeOutputAutomatically>true</storeOutputAutomatically>

    <connector><targetReference>Next_Step</targetReference></connector>
    <faultConnector><targetReference>Error_Screen</targetReference></faultConnector>
</recordCreates>
```

> `storeOutputAutomatically`가 true이면 `{!create_property}` = 생성된 Record ID.

---

## recordUpdates — Update Records

```xml
<recordUpdates>
    <name>Update_Case_Record</name>
    <label>Update Case Record</label>
    <object>Case</object>

    <filterLogic>and</filterLogic>
    <filters>
        <field>Id</field>
        <operator>EqualTo</operator>
        <value>
            <elementReference>case_id</elementReference>
        </value>
    </filters>

    <inputAssignments>
        <field>Status</field>
        <value>
            <elementReference>status</elementReference>
        </value>
    </inputAssignments>

    <connector><targetReference>Assign_Result</targetReference></connector>
</recordUpdates>
```

---

## decisions — 조건 분기

```xml
<decisions>
    <name>If_content_document_found</name>
    <label>If Content Document found</label>

    <!-- 조건 미충족 시 기본 경로 -->
    <defaultConnector>
        <targetReference>navigate_to_record_detail</targetReference>
    </defaultConnector>
    <defaultConnectorLabel>Default Outcome</defaultConnectorLabel>

    <rules>
        <name>Content_Document_Link_found</name>
        <conditionLogic>and</conditionLogic>
        <conditions>
            <leftValueReference>get_main_content_document</leftValueReference>
            <operator>IsNull</operator>
            <rightValue>
                <booleanValue>false</booleanValue>
            </rightValue>
        </conditions>
        <connector>
            <targetReference>get_main_content_version</targetReference>
        </connector>
        <label>Content Document Found</label>
    </rules>
</decisions>
```

**operator 종류:**

| operator | 의미 |
|---|---|
| `EqualTo` | = |
| `NotEqualTo` | ≠ |
| `IsNull` | null 여부 |
| `GreaterThan` | > |
| `LessThan` | < |
| `Contains` | 포함 |
| `StartsWith` | 시작 |

---

## assignments — 변수 대입

```xml
<assignments>
    <name>Assign_Result</name>
    <label>Assign Result</label>
    <assignmentItems>
        <assignToReference>updated</assignToReference>
        <operator>Assign</operator>
        <value>
            <booleanValue>true</booleanValue>
        </value>
    </assignmentItems>
</assignments>
```

**operator 종류:**

| operator | 의미 |
|---|---|
| `Assign` | 덮어쓰기 |
| `Add` | 숫자 더하기 / 문자열 연결 |
| `AddItem` | 컬렉션에 항목 추가 |
| `RemoveFirst` | 컬렉션에서 첫 일치 제거 |
| `RemoveAll` | 컬렉션에서 모든 일치 제거 |

---

## actionCalls — Apex Action 호출

```xml
<actionCalls>
    <name>geocode_address</name>
    <label>Geocode Address</label>
    <actionName>GeocodingService</actionName>  <!-- @InvocableMethod 클래스명 -->
    <actionType>apex</actionType>

    <!-- storeOutputAutomatically로 출력 자동 저장 -->
    <storeOutputAutomatically>true</storeOutputAutomatically>

    <inputParameters>
        <name>city</name>
        <value>
            <elementReference>property_address.city</elementReference>
        </value>
    </inputParameters>

    <!-- 현재 트랜잭션에서 실행 여부 -->
    <flowTransactionModel>CurrentTransaction</flowTransactionModel>

    <connector><targetReference>property_details</targetReference></connector>
    <faultConnector><targetReference>Error5</targetReference></faultConnector>
</actionCalls>
```

**actionType 종류:**

| actionType | 설명 |
|---|---|
| `apex` | `@InvocableMethod` Apex 클래스 |
| `flow` | Subflow 호출 |
| `emailAlert` | 이메일 알림 |
| `quickAction` | Quick Action |
| `externalService` | External Service (OpenAPI) |

---

## faultConnector — 오류 처리

모든 레코드 DML 요소와 actionCalls에 `faultConnector` 추가 권장:

```xml
<faultConnector>
    <targetReference>Error_Screen</targetReference>
</faultConnector>
```

오류 화면에서 `{!$Flow.FaultMessage}` 로 오류 내용 표시 가능.

---

## screens — Screen (사용자 입력·표시 화면)

> Screens capture information from users and display information to users. (api_meta.pdf, FlowScreen)
> Flow Builder: "Collect information from or display information to a user who runs the flow." Screen Flow에서만 사용.

아래는 api_meta.pdf 샘플 플로우 발췌 — DisplayText 필드를 표시하는 확인 화면:

```xml
<screens>
    <name>Confirm</name>
    <label>Confirm</label>
    <locationX>50</locationX>
    <locationY>998</locationY>
    <allowBack>false</allowBack>
    <allowFinish>true</allowFinish>
    <allowPause>true</allowPause>
    <fields>
        <name>confirmation_message</name>
        <fieldText>Thanks! &lt;a href=&quot;/{!contact.Id}&quot;&gt;The contact&lt;/a&gt; was {!created_or_updated}.</fieldText>
        <fieldType>DisplayText</fieldType>
    </fields>
    <showFooter>true</showFooter>
    <showHeader>true</showHeader>
</screens>
```

DropdownBox 입력 필드는 `choiceReferences`로 `dynamicChoiceSets`(또는 `choices`)를 참조한다 (api_meta.pdf 샘플 발췌):

```xml
<fields>
    <name>Account</name>
    <choiceReferences>accounts</choiceReferences>
    <dataType>String</dataType>
    <fieldText>Account</fieldText>
    <fieldType>DropdownBox</fieldType>
    <isRequired>true</isRequired>
</fields>
```

**FlowScreen 주요 필드** (api_meta.pdf, 물리 1280–1282):

| 필드 | 타입 | 설명 |
|---|---|---|
| `allowBack` | boolean | Previous 버튼 표시 여부. 기본 true. `allowBack`·`allowFinish` 중 하나만 false 가능 (둘 다 false 불가) |
| `allowFinish` | boolean | Finish 버튼 표시 여부. 기본 true |
| `allowPause` | boolean | Pause 버튼 표시 여부. 기본 true. org 설정·`showAllowPause`·`showFooter` 모두 true여야 실제 노출 (v33.0+) |
| `backButtonLabel` | string | Back 버튼 라벨 |
| `connector` | FlowConnector | 화면 이후 실행할 노드 |
| `fields` | FlowScreenField[] | 화면에 표시할 필드(컴포넌트) 배열 |
| `helpText` | string | 도움말 링크 클릭 시 표시 텍스트 (v26.0+ 병합 필드 지원) |
| `nextOrFinishButtonLabel` | string | Next/Finish 버튼 라벨 |
| `pauseButtonLabel` | string | Pause 버튼 라벨 |
| `pausedText` | string | Pause 클릭 시 확인 메시지 (v33.0+) |
| `showFooter` | boolean | 푸터(네비게이션) 표시 여부. Lightning 런타임만. 기본 true (v42.0+) |
| `showHeader` | boolean | 헤더(도움말 접근) 표시 여부. Lightning 런타임만. 기본 true (v42.0+) |
| `actions` | FlowScreenAction[] | 화면 액션 배열 (v59.0+) |
| `triggers` | FlowScreenTrigger[] | 화면 필드/속성에 구성된 트리거 (v59.0+) |
| `styleSettings` | FlowScreenStyleSetting[] | 화면 시각 커스터마이즈 설정 (v66.0+) |
| `stageReference` | FlowElementReferenceOrValue | 화면과 연결된 stage 리소스 API 명 |

> 개별 Screen 컴포넌트(`fields` 하위 `FlowScreenField`)의 상세는 [[Screen Component 레퍼런스 - 입력]] 참조.

---

## dynamicChoiceSets — 동적 선택지 (Record / Picklist Choice)

> Retrieves data or metadata from an object and dynamically generates a set of choices at run time. (api_meta.pdf, FlowDynamicChoiceSet)

설정된 필드에 따라 **레코드 choice** 또는 **picklist choice** 두 종류로 동작한다.
- **Record choice** — 필터 조건에 맞는 레코드로 선택지 생성. `picklistField`·`picklistObject`가 없으면 record choice이며 데이터 타입이 Picklist/Multipicklist일 수 없다.
- **Picklist choice** — picklist/multi-select picklist 필드의 사용 가능한 값으로 선택지 생성. `picklistField`·`picklistObject`가 설정되면 picklist choice이며 데이터 타입이 반드시 Picklist 또는 Multipicklist여야 한다.

api_meta.pdf 샘플 플로우 발췌 (record choice):

```xml
<dynamicChoiceSets>
    <name>accounts</name>
    <dataType>String</dataType>
    <displayField>Name</displayField>
    <object>Account</object>
    <outputAssignments>
        <assignToReference>contact.AccountId</assignToReference>
        <field>Id</field>
    </outputAssignments>
    <valueField>Id</valueField>
</dynamicChoiceSets>
```

**FlowDynamicChoiceSet 주요 필드** (api_meta.pdf, 물리 1258–1261):

| 필드 | 타입 | 설명 |
|---|---|---|
| `collectionReference` | string | 선택지 생성에 사용할 컬렉션 (v54.0+) |
| `dataType` | FlowDataType | 필수. Boolean·Currency·Date·Multipicklist·Number·Picklist·Record·String·Time. Picklist/Multipicklist는 v35.0+, Record는 v54.0+ |
| `displayField` | string | record choice 필수. 사용자에게 라벨로 표시할 객체 필드 (picklist choice 미지원) |
| `filters` | FlowRecordFilter[] | DB 조회 레코드에 적용할 필터 배열 (picklist choice 미지원) |
| `limit` | int | 생성 선택지 최대 개수. **최대·기본 200** (v25.0+, v45.0+ nillable) |
| `object` | string | record choice 필수. 선택지를 생성할 객체 (picklist choice 미지원) |
| `outputAssignments` | FlowOutputFieldAssignment[] | 사용자가 고른 레코드의 필드를 변수에 할당 (picklist choice 미지원) |
| `picklistField` | string | picklist choice 필수. 값을 가져올 picklist 필드 (record choice 미지원, v35.0+) |
| `picklistObject` | string | picklist choice 필수. picklist 필드가 속한 객체 (record choice 미지원, v35.0+) |
| `sortField` | string | 정렬 기준 필드. Sort API 속성이 있는 필드만 가능 (picklist choice 미지원, v25.0+) |
| `sortOrder` | SortOrder | Asc(오름차순)·Desc(내림차순) (picklist choice 미지원, v25.0+) |
| `valueField` | string | 선택 시 저장되는 값. `displayField`와 다를 수 있음 (예: display=Name, value=Id). picklist choice 미지원 |

> `limit` 최댓값·기본값 모두 **200**. `sortField`/`sortOrder`가 함께 지정되면 정렬 후 limit이 적용된다 (api_meta.pdf 원문).

---

## loops — Loop (컬렉션 반복)

> A construct for iterating through a collection. (api_meta.pdf, FlowLoop, v30.0+)

api_meta.pdf 샘플 (autolaunched flow의 loop 발췌):

```xml
<loops>
    <name>Loop_Accounts</name>
    <label>Loop Accounts</label>
    <locationX>0</locationX>
    <locationY>0</locationY>
    <collectionReference>Get_Accounts</collectionReference>
    <iterationOrder>Asc</iterationOrder>
    <nextValueConnector>
        <targetReference>Assign_Counter</targetReference>
    </nextValueConnector>
</loops>
```

**FlowLoop 주요 필드** (api_meta.pdf, 물리 1267):

| 필드 | 타입 | 설명 |
|---|---|---|
| `assignNextValueToReference` | string | `nextValueConnector`의 타겟으로 이동하기 전, 컬렉션의 현재 값을 할당할 변수. (자동 저장 미사용 시) |
| `collectionReference` | string | 반복 대상 컬렉션 |
| `iterationOrder` | enum | `Asc` — 첫→마지막 순서로 반복 / `Desc` — 마지막→첫 역순으로 반복 |
| `nextValueConnector` | FlowConnector | 컬렉션의 다음 요소로 진행할 때 실행할 요소 (루프 본문) |
| `noMoreValuesConnector` | FlowConnector | 모든 항목을 반복 완료했을 때 이동할 요소 (루프 종료 후 경로) |

> 위 샘플은 자동 저장 모드라 `assignNextValueToReference`가 없다. 루프 항목은 `{!Loop_Accounts}`(요소명)로 참조하고, 루프 안 `assignments`에서 `Loop_Accounts.NumberOfEmployees` 처럼 현재 항목 필드에 접근한다 (api_meta.pdf 샘플).

---

## collectionProcessors — Collection Filter / Sort / Recommendation

> Defines a node that processes the contents of a collection, depending on the collectionProcessorType. (api_meta.pdf, FlowCollectionProcessor, v50.0+)

`collectionProcessorType` 값으로 세 가지 Flow Builder 요소를 표현한다:
- `SortCollectionProcessor` — Collection Sort (v50.0+)
- `RecommendationMapCollectionProcessor` — Recommendation Assignment (v53.0+)
- `FilterCollectionProcessor` — Collection Filter (v53.0+)

```xml
<!-- 구조 예시 — 실제 동작 XML 아님 (api_meta.pdf에 이 요소 전용 샘플 XML 없음. FlowCollectionProcessor 필드 스키마 기반 조립) -->
<collectionProcessors>
    <name>Filter_High_Value</name>
    <label>Filter High Value</label>
    <collectionProcessorType>FilterCollectionProcessor</collectionProcessorType>
    <collectionReference>Get_Accounts</collectionReference>
    <assignNextValueToReference>currentAccount</assignNextValueToReference>
    <conditionLogic>and</conditionLogic>
    <conditions>
        <leftValueReference>currentAccount.AnnualRevenue</leftValueReference>
        <operator>GreaterThan</operator>
        <rightValue>
            <numberValue>1000000.0</numberValue>
        </rightValue>
    </conditions>
    <connector>
        <targetReference>Next_Element</targetReference>
    </connector>
</collectionProcessors>
```

**FlowCollectionProcessor 주요 필드** (api_meta.pdf, 물리 1252–1253):

| 필드 | 타입 | 설명 |
|---|---|---|
| `assignNextValueToReference` | string | 컬렉션의 다음 값이 할당되는 변수 이름 |
| `collectionProcessorType` | enum | `SortCollectionProcessor`(v50.0+) · `RecommendationMapCollectionProcessor`(v53.0+) · `FilterCollectionProcessor`(v53.0+) |
| `collectionReference` | string | 정렬·필터·추천 매핑 대상 컬렉션 |
| `conditionLogic` | string | 필터 조건 평가 방식: `And` · `Or` · 커스텀 로직(`(1 AND (2 OR 3))`) · `Formula` |
| `conditions` | FlowCondition[] | 입력 컬렉션에 대한 조건 배열 |
| `connector` | FlowConnector | 컬렉션 처리 후 실행할 노드 |
| `formula` | string | 입력 컬렉션을 필터링하는 수식. true로 평가되면 출력 컬렉션에 추가 |
| `limit` | int | 생성 컬렉션에 포함할 최대 레코드 수. **기본값 없음.** 컬렉션 크기보다 크면 전체 유지. `sortField`/`sortOrder` 지정 시 정렬 후 limit 적용 (v51.0+, nillable) |
| `mapItems` | FlowCollectionMapItem[] | 컬렉션 변수 각 필드 매핑 규칙 |
| `outputSObjectType` | string | 출력 컬렉션의 sObject 타입 |
| `sortOptions` | FlowCollectionSortOption[] | 컬렉션 정렬 옵션 배열 (v51.0+) |

**FlowCollectionSortOption** (v51.0+): `doesPutEmptyStringAndNullFirst`(빈/null 값을 앞에 배치, 기본 false) · `sortField`(정렬 필드, 레코드/Apex-defined 컬렉션은 필수, primitive 리스트는 미지원) · `sortOrder`(`Asc`/`Desc`).

---

## subflows — Subflow (다른 플로우 호출 + 입출력 매핑)

> A subflow element references another flow, which it calls at run time. The flow that contains the subflow element is referred to as the parent flow. (api_meta.pdf, FlowSubflow, v25.0+)
> Flow Builder: "Launch another active flow that's available in your org. A flow launched by another flow is called the referenced flow."

api_meta.pdf 샘플 (subflow 호출 + 입력 할당 발췌):

```xml
<subflows>
    <name>Call_My_Subflow</name>
    <label>Call My Subflow</label>
    <locationX>0</locationX>
    <locationY>0</locationY>
    <connector>
        <targetReference>Assign_Value</targetReference>
    </connector>
    <flowName>Sample_Definition_Autolaunched</flowName>
    <inputAssignments>
        <name>Counter</name>
    </inputAssignments>
    <inputAssignments>
        <name>Counter_Value2</name>
    </inputAssignments>
</subflows>
```

**FlowSubflow 주요 필드** (api_meta.pdf, 물리 1301–1302):

| 필드 | 타입 | 설명 |
|---|---|---|
| `connector` | FlowConnector | subflow 이후 실행할 노드 |
| `flowName` | string | 런타임에 호출할 플로우의 **API 명**. 뒤에 하이픈+버전 번호를 붙일 수 없음 (활성 버전이 실행됨) |
| `inputAssignments` | FlowSubflowInputAssignment[] | 참조 플로우 시작 시 설정되는 입력 변수 할당 배열 |
| `outputAssignments` | FlowSubflowOutputAssignment[] | 참조 플로우 종료 시 설정되는 출력 변수 할당 배열 |
| `storeOutputAutomatically` | boolean | true면 변수를 만들지 않고 subflow의 출력 파라미터를 `{!subflow_API명.출력변수}`로 자동 참조. false면 수동으로 변수 생성. 기본 false (v49.0+) |

### 입출력 변수 매핑 (ECA — 실행 컨텍스트 경계)

Subflow는 부모 플로우와 **참조(자식) 플로우 사이에서 값을 전달**한다. 매핑 방향과 발생 시점(ECA 근거)이 정반대다:

| 매핑 요소 | 방향 | 발생 시점 | 핵심 필드 |
|---|---|---|---|
| `inputAssignments` (FlowSubflowInputAssignment) | 부모 → 자식 | subflow가 참조 플로우를 **호출할 때** | `name`(자식 플로우 변수, 필수) · `value`(부모의 값/요소 참조) |
| `outputAssignments` (FlowSubflowOutputAssignment) | 자식 → 부모 | 참조 플로우가 **실행을 마쳤을 때** | `name`(자식 플로우 변수, 필수) · `assignToReference`(부모 플로우 변수) |

- **입력 매핑** — "Input assignments occur when the subflow calls the referenced flow." 부모의 `value`(elementReference 또는 리터럴)가 자식 플로우의 `name` 변수(반드시 자식에서 `isInput=true`)로 들어간다.
- **출력 매핑** — "Output assignments occur when the referenced flow is finished running." 자식 플로우의 `name` 변수(자식에서 `isOutput=true`) 값이 부모의 `assignToReference` 변수로 나온다.
- `storeOutputAutomatically=true`면 `outputAssignments`를 쓰지 않고 자식 플로우 API 명으로 출력 파라미터를 직접 참조한다.
- 이때 자식 플로우의 변수는 `isInput`/`isOutput` 플래그로 입출력 가능 여부가 결정된다 → [[Flow 종류와 변수]] 참조.

```xml
<!-- 구조 예시 — 실제 동작 XML 아님 (FlowSubflowOutputAssignment 스키마 기반. api_meta.pdf 샘플은 입력만 포함) -->
<subflows>
    <name>Call_Rollup</name>
    <label>Call Rollup</label>
    <flowName>Account_Rollup_Subflow</flowName>
    <inputAssignments>
        <name>inputAccountId</name>
        <value>
            <elementReference>account.Id</elementReference>
        </value>
    </inputAssignments>
    <outputAssignments>
        <assignToReference>parentTotal</assignToReference>
        <name>outputTotalRevenue</name>
    </outputAssignments>
    <storeOutputAutomatically>false</storeOutputAutomatically>
    <connector>
        <targetReference>Next_Element</targetReference>
    </connector>
</subflows>
```

---

## waits — Wait (이벤트/시간 대기)

> Waits for one or more defined events to occur. (api_meta.pdf, FlowWait, v32.0+)
> Flow Builder: "Resume a flow interview after specific conditions are met, a specified amount of time passes, or until a specific date."

```xml
<!-- 구조 예시 — 실제 동작 XML 아님 (api_meta.pdf에 waits 전용 샘플 XML 없음. FlowWait / FlowWaitEvent 필드 스키마 기반 조립) -->
<waits>
    <name>Wait_For_Followup</name>
    <label>Wait For Followup</label>
    <defaultConnector>
        <targetReference>Timed_Out_Path</targetReference>
    </defaultConnector>
    <defaultConnectorLabel>No events</defaultConnectorLabel>
    <faultConnector>
        <targetReference>Error_Screen</targetReference>
    </faultConnector>
    <waitEvents>
        <name>Wait_3_Days</name>
        <conditionLogic>and</conditionLogic>
        <eventType>AlarmEvent</eventType>
        <connector>
            <targetReference>Send_Reminder</targetReference>
        </connector>
    </waitEvents>
</waits>
```

**FlowWait 주요 필드** (api_meta.pdf, 물리 1308):

| 필드 | 타입 | 설명 |
|---|---|---|
| `defaultConnector` | FlowConnector | Wait의 모든 이벤트 조건이 false일 때 실행할 노드 |
| `defaultConnectorLabel` | string | 기본 커넥터 라벨 |
| `faultConnector` | FlowConnector | 대기 시도가 오류를 낼 때 실행할 노드. wait 이벤트 중 하나라도 실패하면 fault 커넥터를 탐 |
| `timeZoneId` | string | (Reserved for future use) |
| `waitEvents` | FlowWaitEvent[] | Wait가 기다리는 이벤트 배열. 모든 이벤트 조건이 false면 `defaultConnector` 사용 |

**FlowWaitEvent 주요 필드** (api_meta.pdf, 물리 1308–1309, v32.0+):

| 필드 | 타입 | 설명 |
|---|---|---|
| `conditionLogic` | string | `and`(모든 조건 true) · `or`(하나라도 true) · 고급 로직(`1 AND (2 OR 3)`, 1,000자 이하) |
| `conditions` | FlowCondition[] | 이 이벤트를 기다리기 위해 true여야 하는 조건 배열 |
| `filterlogic` | string | 필터 조건에 적용할 로직 — 모든 조건은 `AND`, 하나라도는 `OR`, 커스텀은 `1 AND (2 OR 3)` 형태. `filters`의 짝 (v60.0+) |
| `inputParameters` | FlowWaitEventInputParameter[] | 이벤트의 입력 파라미터 배열. 파라미터 값은 플로우의 값으로 설정 (알람 시각 등 이벤트 정의값) |
| `interactionType` | FlowWaitInteractionType | 플로우를 재개할 수 있는 이벤트 타입 — `SmsResponse`(SMS 응답 이벤트) · `WhatsappResponse`(WhatsApp 응답 이벤트) (v62.0+) |
| `associatedElement` | string | 플로우를 재개하는 이벤트의 API 명 (v60.0+) |
| `connector` | FlowConnector | 이 이벤트가 가장 먼저 발생했을 때 실행할 노드 |
| `eventType` | string | 필수. 이벤트 타입 — `AlarmEvent`(절대 날짜/시간 기준 알람) · `DateRefAlarmEvent`(레코드의 날짜/시간 필드 기준 알람) |
| `automationEventName` | string | Wait가 기다리는 automation 이벤트 이름 |
| `automationEventType` | InvocableActionType | automation 이벤트 타입 (`trgrOnSmsSubscription` 등, v61.0+/v64.0+ 값 포함) |
| `filters` | FlowRecordFilter[] | DB 조회 시 적용할 필터 배열 (v60.0+) |
| `extendUntil` | Time | (Reserved for future use) |

---

## customErrors — Custom Error (롤백 + 사용자 오류 메시지)

> Defines a custom error element to roll back a change that triggered a flow and inform the user exactly what caused the error. (api_meta.pdf, FlowCustomError, extends FlowNode)

```xml
<!-- 구조 예시 — 실제 동작 XML 아님 (api_meta.pdf에 customErrors 전용 샘플 XML 없음. FlowCustomError / FlowCustomErrorMessage 필드 스키마 기반 조립) -->
<customErrors>
    <name>Reject_Invalid_Amount</name>
    <label>Reject Invalid Amount</label>
    <description>Amount must be positive</description>
    <connector>
        <targetReference>End</targetReference>
    </connector>
    <customErrorMessages>
        <errorMessage>Amount must be greater than zero.</errorMessage>
        <fieldSelection>Amount__c</fieldSelection>
        <isFieldError>true</isFieldError>
    </customErrorMessages>
</customErrors>
```

**FlowCustomError 주요 필드** (api_meta.pdf, 물리 1254):

| 필드 | 타입 | 설명 |
|---|---|---|
| `description` | string | 오류 메시지 설명 |
| `connector` | FlowConnector | **필수.** 현재 노드 완료 후 실행할 노드 |
| `customErrorMessages` | FlowCustomErrorMessage[] | 커스텀 오류 메시지 배열 |

**FlowCustomErrorMessage 주요 필드** (api_meta.pdf, 물리 1254):

| 필드 | 타입 | 설명 |
|---|---|---|
| `errorMessage` | string | **필수.** 표시할 커스텀 오류 메시지 |
| `fieldSelection` | string | 오류 메시지와 연결된 문제 필드 참조 |
| `isFieldError` | boolean | **필수.** true면 필드에 인라인으로 표시, false면 레코드 페이지 창에 표시. 기본 false |

---

## recordRollbacks — Roll Back Records (트랜잭션 롤백)

> Rolls back the current transaction and cancels its pending record changes. Corresponds to the Roll Back Records element in Flow Builder. **Available only in screen flows.** (api_meta.pdf, FlowRecordRollback, v52.0+)

```xml
<!-- 구조 예시 — 실제 동작 XML 아님 (api_meta.pdf에 recordRollbacks 전용 샘플 XML 없음. FlowRecordRollback 필드 스키마 기반 조립) -->
<recordRollbacks>
    <name>Undo_Changes</name>
    <label>Undo Changes</label>
    <connector>
        <targetReference>Error_Screen</targetReference>
    </connector>
</recordRollbacks>
```

**FlowRecordRollback 주요 필드** (api_meta.pdf, 물리 1272):

| 필드 | 타입 | 설명 |
|---|---|---|
| `connector` | FlowConnector | 현재 트랜잭션을 롤백한 후 실행할 노드 |

> Screen Flow 전용. `customErrors`가 (트리거 변경 롤백 + 메시지)를 함께 처리한다면, `recordRollbacks`는 순수하게 현재 트랜잭션의 보류 중 레코드 변경을 취소한다.

---

## start — Start (시작·트리거)

> Represents the flow's Start element, which specifies how the flow starts. (api_meta.pdf, FlowStart, v47.0+)
> FlowStart는 FlowNode를 확장하되 `name`·`label`은 상속하지 않는다. 모든 플로우에 정확히 1개.

가장 단순한 형태 — 트리거 없이 첫 요소로 연결만 하는 start (api_meta.pdf 샘플 발췌):

```xml
<start>
    <locationX>254</locationX>
    <locationY>0</locationY>
    <connector>
        <targetReference>Contact_Info</targetReference>
    </connector>
</start>
```

**핵심 트리거 필드** (api_meta.pdf, 물리 1295–1300):

| 필드 | 타입 | 설명 |
|---|---|---|
| `connector` | FlowConnector | 가장 먼저 실행할 요소 |
| `triggerType` | FlowTriggerType | 무엇이 플로우를 실행하는지. 생략 시 트리거 없음(사용자/앱이 실행). 주요 값: `RecordBeforeSave`(v48.0+, 저장 전) · `RecordAfterSave`(v49.0+, 저장 후) · `RecordBeforeDelete`(v50.0+, 삭제 전) · `PlatformEvent`(v49.0+) · `Scheduled`(v47.0+) · `DataCloudDataChange`(v59.0+) 등 |
| `recordTriggerType` | RecordTriggerType | `Create` · `Update` · `CreateAndUpdate` · `Delete`(v50.0+) · `None`(v55.0+). `triggerType`이 `RecordBeforeSave`/`DataCloudDataChange`일 때만 |
| `object` | string | 레코드를 조회할 객체. 조건에 맞는 각 레코드마다 인터뷰 시작 |
| `filterLogic` / `filters` | string / FlowRecordFilter[] | 실행 대상 레코드 필터 (AND/OR/커스텀, v50.0+) |
| `filterFormula` | string | 저장 중 실행 레코드를 거르는 수식. record-triggered flow 전용 (v55.0+) |
| `schedule` / `scheduledPaths` | FlowSchedule / FlowScheduledPath[] | `triggerType=Scheduled`일 때 실행 시점·빈도, 예약 경로 (scheduledPaths v51.0+) |

> **record-triggered flow의 트리거 타입·before/after·스케줄 경로·엔트리 조건 상세는 [[Record-Triggered Flow]]에 위임한다.** 여기서는 `start` 요소의 XML 뼈대만 다룬다.

---

## transforms — Transform (데이터 변환)

> Defines a node that can dynamically transform the value of source data to target data in the flow. (api_meta.pdf, FlowTransform, extends FlowNode, v59.0+)
> Flow Builder: "Select the flow resources for mapping and transforming source data to target data."

**핵심 필드** (api_meta.pdf, 물리 1303):

| 필드 | 타입 | 설명 |
|---|---|---|
| `dataType` | FlowDataType | **필수.** 변환 결과(타겟) 데이터 타입: `Apex` · `sObject` · `Time` (그 외 Boolean·Currency·Date·DateTime·Number·String은 v62.0+) |
| `apexClass` | string | 타겟 데이터 타입이 Apex일 때 대상 Apex 클래스 |
| `objectType` | string | 타겟 데이터 타입이 sObject일 때 객체 타입 |
| `isCollection` | boolean | 컬렉션 여부. 기본 false |
| `scale` | int | 소수점 이하 자릿수(최대 17). Flow Builder의 Decimal Places 필드 |
| `connector` | FlowConnector[] | 변환 후 실행할 노드 |
| `transformValues` | FlowTransformValue[] | 변환 값 배열 (하위 `transformValueActions` → `transformType`: `Count`·`InnerJoin`(v63.0+)·`Map` 등) |

> **Transform 요소의 매핑 유형(Map/Count/InnerJoin)·소스↔타겟 스키마·화면 사용 예시 상세는 [[Transform 요소]]에 위임한다.** 여기서는 `transforms` 요소의 필드 스키마만 다룬다.

---

## 관련 노트

- [[Flow 종류와 변수]]
- [[Screen Flow 설계]]
- [[Autolaunched Flow 패턴]]
- [[Record-Triggered Flow]] — start 요소 트리거 타입·before/after·스케줄 경로 상세
- [[Transform 요소]] — transforms 매핑 유형(Map/Count/InnerJoin) 상세
- [[Screen Component 레퍼런스 - 입력]] — screens 하위 개별 컴포넌트
- [[@InvocableMethod 패턴]]
- [[automation-flow-generate]] (sf-skill — 실행형) — Flow 메타데이터 생성(MCP) 실행형 스킬
