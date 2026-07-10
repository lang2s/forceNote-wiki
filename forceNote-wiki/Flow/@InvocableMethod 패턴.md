---
tags: [flow, apex, invocable, action, pattern]
source: automation-components, dreamhouse-lwc-main/force-app/main/default/classes/GeocodingService.cls, agent-script-recipes-main/force-app/main/04_architecturalPatterns/externalAPIIntegration/classes/WeatherService.cls, developer.salesforce.com Apex Reference — InvocableMethod Annotation (Tier 2), salesforce_apex_developer_guide.pdf — InvocableMethod Annotation, Supported Modifiers (Tier 2), help.salesforce.com Article 000385708 — uncommitted work pending (Tier 2)
created: 2026-05-17
aliases: [InvocableMethod, Flow Action, Invocable Apex, callout=true, Agentforce Apex Action, apex 액션]
---

# @InvocableMethod 패턴

> Flow에서 호출 가능한 Apex 액션 작성 표준. automation-components 프로젝트의 30개 액션 전체가 동일한 구조를 사용.

---

## 표준 구조

```apex
global with sharing class FilterRecordsWithFieldValue {

    @InvocableMethod(
        label='Filters a list of records with a field matching a value'
        category='Collections'  // Flow Builder에서 카테고리로 그룹화
    )
    global static List<OutputParameters> bulkInvoke(
        List<InputParameters> inputs  // Flow는 항상 List로 전달
    ) {
        List<OutputParameters> outputs = new List<OutputParameters>();
        for (InputParameters input : inputs) {
            outputs.add(invoke(input));  // 단건 처리 위임
        }
        return outputs;
    }

    // 실제 비즈니스 로직 분리 — 테스트 용이
    private static OutputParameters invoke(InputParameters input) {
        OutputParameters output = new OutputParameters();
        output.collection = filter(input.collection, input.fieldName, input.fieldValue);
        output.filteredRecordCount = output.collection.size();
        output.totalRecordCount = input.collection.size();
        return output;
    }

    global class InputParameters {
        @InvocableVariable(required=true)
        global List<SObject> collection;

        @InvocableVariable(required=true)
        global String fieldName;

        @InvocableVariable(required=true)
        global String fieldValue;
    }

    global class OutputParameters {
        @InvocableVariable
        global List<SObject> collection;

        @InvocableVariable
        global Integer totalRecordCount;

        @InvocableVariable
        global Integer filteredRecordCount;
    }
}
```

---

## 핵심 규칙

| 항목 | 규칙 |
|---|---|
| 클래스 접근자 | `global` (관리 패키지 배포 시 필요) |
| 메서드 시그니처 | `global static List<Output> bulkInvoke(List<Input> inputs)` |
| Bulk 처리 | Flow가 여러 레코드를 한번에 보냄 → List 순환 필수 |
| 실제 로직 | `private static invoke()` 로 분리 → 단위 테스트 직접 호출 가능 |
| 파라미터 클래스 | `global inner class` + `@InvocableVariable` |
| 공유 키워드 | `with sharing` (Flow는 사용자 컨텍스트에서 실행) |

### ⚠️ 하드 제약 (컴파일 실패 방지)

`@InvocableMethod`에는 아래 세 하드 제약이 있다. automation-components가 **액션마다 별도 클래스**를 두는 이유가 여기 있다 — 한 클래스에 여러 액션을 몰아넣거나 `@future`와 결합하려다 컴파일에서 막힌다.

| 제약 | 규칙 |
|---|---|
| 클래스당 메서드 1개 | **한 클래스에서 `@InvocableMethod`를 붙일 수 있는 메서드는 단 1개.** 여러 액션이 필요하면 클래스를 분리한다. |
| 결합 가능 어노테이션 | `@InvocableMethod`와 함께 쓸 수 있는 어노테이션은 **`@Deprecated` 뿐.** `@future`·`@AuraEnabled`·`@RemoteAction` 등과 결합 불가. |
| 입력 파라미터 최대 1개 | 인보커블 메서드의 입력 파라미터는 **최대 1개**(관례상 `List<Input>`). 여러 값은 이너 클래스 필드로 묶는다. |

> 근거: [Salesforce Apex 개발자 가이드 — InvocableMethod Annotation](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_annotation_InvocableMethod.htm) — "Only one method in a class can have the InvocableMethod annotation." / "The only annotation that can be used with the InvocableMethod annotation is Deprecated." / "There can be at most one input parameter"

---

## @InvocableMethod 수식자 전수 (Supported Modifiers)

`@InvocableMethod`가 지원하는 수식자는 아래 7종이며 **모두 선택(optional)**이다. `label`·`category`·`callout`·`description` 외에 `capabilityType`·`configurationEditor`·`iconName`까지 소스 전수.

| 수식자 | 설명 |
|---|---|
| `label` | Flow Builder에서 **액션 이름**으로 표시되는 레이블. 기본값은 메서드 이름이지만, 레이블을 직접 지정할 것을 권장 |
| `description` | Flow Builder에서 **액션 설명**으로 표시. 기본값은 Null |
| `callout` | 메서드가 외부 시스템으로 콜아웃하는지 여부. 콜아웃하면 `callout=true`. 기본값 `false` |
| `capabilityType` | 메서드와 통합되는 capability. 유효 형식은 `Name://Name` — 예: `PromptTemplateType://SalesEmail` |
| `category` | Flow Builder에서 **액션 카테고리**로 표시. 지정하지 않으면(기본) 액션이 **Uncategorized**에 표시 |
| `configurationEditor` | 메서드에 등록된 **커스텀 프로퍼티 에디터** — admin이 액션을 구성할 때 Flow Builder에 표시. 미지정 시 Flow Builder가 표준 프로퍼티 에디터 사용 |
| `iconName` | Flow Builder 캔버스에서 액션의 **커스텀 아이콘** 이름. 정적 리소스로 업로드한 SVG 파일 또는 SLDS 표준 아이콘 지정 가능 |

```apex
// 정적 리소스 SVG 커스텀 아이콘 (소스 발췌)
@InvocableMethod(label='myIcon' iconName='resource:myPackageNamespace__google:top')

// SLDS 표준 아이콘 (소스 발췌)
@InvocableMethod(iconName='slds:standard:choice')
```

> 근거: [Salesforce Apex 개발자 가이드 — InvocableMethod Annotation](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_annotation_InvocableMethod.htm), "Supported Modifiers" — All modifiers are optional (label·description·callout·capabilityType·category·configurationEditor·iconName)

---

## @InvocableVariable 옵션

```apex
@InvocableVariable(required=true label='Field Name' description='API name of the field')
global String fieldName;
```

| 옵션 | 설명 |
|---|---|
| `required=true` | Flow Builder에서 필수 입력 표시 |
| `label` | Flow Builder UI 레이블 |
| `description` | Flow Builder 툴팁 |
| `defaultValue` | 기본값 지정 *(Summer '24 추가)* |
| `placeholderText` | 입력 필드 플레이스홀더 텍스트 *(Summer '24 추가)* |

**Summer '24 (v61.0) — `defaultValue` · `placeholderText` 수식자 추가:**

```apex
@InvocableVariable(label='Account ID' defaultValue='001000000000000' placeholderText='Enter Account ID')
public String accountId;
```

---

## 지원 타입

| Apex 타입 | Flow 타입 |
|---|---|
| `String` | Text |
| `Boolean` | Boolean |
| `Integer` / `Double` | Number |
| `Date` / `DateTime` | Date / DateTime |
| `Id` | Record ID |
| `List<SObject>` | Record Collection |
| `SObject` | Record (단건) |

> Flow는 복잡한 객체를 직접 전달 불가 → **JSON 직렬화 우회**

```apex
// Flow에서 JSON 문자열로 복잡한 파라미터 전달
@InvocableVariable(required=true)
global String sortKeys;  // '[{"field":"Name","direction":"desc"}]'

// Apex 역직렬화
List<SortKey> keys = (List<SortKey>) JSON.deserialize(sortKeys, List<SortKey>.class);
```

---

## 외부 REST 콜아웃 인보커블 — `callout=true` + raw Http (dreamhouse)

인보커블 액션 안에서 **외부 REST API를 직접 GET 콜아웃**하는 실전 패턴. dreamhouse-lwc의 `GeocodingService`가 주소를 OpenStreetMap Nominatim으로 지오코딩한다. 위의 컬렉션/데이터 인보커블과 달리 세 가지가 추가된다: **(1)** `@InvocableMethod(callout=true)` 수식자, **(2)** `Http`/`HttpRequest`/`HttpResponse`로 raw 동기 콜아웃, **(3)** 응답 JSON을 `@InvocableVariable` 이너 클래스로 역직렬화.

```apex
public with sharing class GeocodingService {
    private static final String BASE_URL = 'https://nominatim.openstreetmap.org/search?format=json';

    @InvocableMethod(callout=true label='Geocode address')
    public static List<Coordinates> geocodeAddresses(
        List<GeocodingAddress> addresses
    ) {
        List<Coordinates> computedCoordinates = new List<Coordinates>();
        for (GeocodingAddress address : addresses) {
            String geocodingUrl = BASE_URL;
            geocodingUrl += (String.isNotBlank(address.street))
                ? '&street=' + address.street : '';
            geocodingUrl += (String.isNotBlank(address.city))
                ? '&city=' + address.city : '';
            // ... state / country / postalcode 동일하게 URL 파라미터로 누적

            Coordinates coords = new Coordinates();
            if (geocodingUrl != BASE_URL) {
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                request.setEndpoint(geocodingUrl);
                request.setMethod('GET');
                request.setHeader(
                    'http-referer',
                    URL.getOrgDomainUrl().toExternalForm()
                );
                HttpResponse response = http.send(request);
                if (response.getStatusCode() == 200) {
                    List<Coordinates> deserializedCoords = (List<Coordinates>) JSON.deserialize(
                        response.getBody(),
                        List<Coordinates>.class
                    );
                    coords = deserializedCoords[0];
                }
            }
            computedCoordinates.add(coords);
        }
        return computedCoordinates;
    }

    public class GeocodingAddress {
        @InvocableVariable public String street;
        @InvocableVariable public String city;
        @InvocableVariable public String state;
        @InvocableVariable public String country;
        @InvocableVariable public String postalcode;
    }

    public class Coordinates {
        @InvocableVariable public Decimal lat;
        @InvocableVariable public Decimal lon;
    }
}
```

**핵심 규칙:**

| 항목 | 규칙 |
|---|---|
| `callout=true` | 액션이 HTTP 콜아웃을 하면 **필수**. 없으면 Flow가 트랜잭션 규칙 위반으로 런타임 에러 |
| 콜아웃 방식 | `new Http().send(request)` — **동기** 콜아웃. Remote Site Setting(엔드포인트 도메인 등록) 기반 익명 콜아웃 |
| 응답 매핑 | `JSON.deserialize(response.getBody(), List<Coordinates>.class)` — 응답 이너 클래스 필드명이 JSON 키(`lat`/`lon`)와 일치해야 자동 매핑 |
| 출력 타입 | `List<Coordinates>` — 응답 이너 클래스 자체를 반환. Flow는 `geocode_address.lat` 처럼 하위 필드 접근 |

> 이 패턴은 **Remote Site 기반 익명 콜아웃**이다. Named Credential 기반의 관리형 콜아웃은 [[RestClient 패턴]] 참조(인증·엔드포인트를 Named Credential에 위임).

#### ⚠️ 최다 블로커 — "uncommitted work pending" (같은 트랜잭션 DML → 콜아웃)

`callout=true`와 Remote Site Setting을 갖춰도, **같은 트랜잭션에서 DML(Create/Update Records) 이후 콜아웃**을 하면 런타임에 다음 예외로 막힌다:

```text
CalloutException: You have uncommitted work pending.
Please commit or rollback before calling out.
```

Record-Triggered Flow에서 이 콜아웃 액션을 저장(DML) **이후 동기 경로**에 배치하면 이 예외가 발생한다. Apex는 미커밋 DML이 열려 있는 상태에서 콜아웃을 허용하지 않기 때문이다. 해결책 두 가지:

| 해결책 | 방법 |
|---|---|
| 콜아웃을 DML 앞으로 | Flow에서 콜아웃 액션을 Create/Update Records 요소 **이전**에 배치 |
| 비동기 경로로 분리 | Record-Triggered Flow에서 콜아웃을 **Run Asynchronously**(비동기 경로)로 실행 → 별도 트랜잭션에서 콜아웃 |

> 근거: [Salesforce Help — 'You have uncommitted work pending. Please commit or rollback before calling out'](https://help.salesforce.com/s/articleView?id=000385708&type=1) (DML before callout in same transaction)

### Screen Flow에서 호출 — `actionCall` + `faultConnector`

`Create_property` 스크린 Flow가 위 액션을 `actionType=apex`로 호출하고, 콜아웃 실패 시 `faultConnector`로 에러 화면으로 분기한다.

```xml
<!-- Create_property.flow-meta.xml (발췌) -->
<actionCalls>
    <name>geocode_address</name>
    <label>Geocode Address</label>
    <actionName>GeocodingService</actionName>
    <actionType>apex</actionType>
    <connector>
        <targetReference>property_details</targetReference>
    </connector>
    <faultConnector>
        <targetReference>Error5</targetReference>   <!-- 콜아웃 실패 시 에러 화면으로 -->
    </faultConnector>
    <flowTransactionModel>CurrentTransaction</flowTransactionModel>
    <inputParameters>
        <name>city</name>
        <value><elementReference>property_address.city</elementReference></value>
    </inputParameters>
    <!-- country / postalcode / state / street 동일하게 매핑 -->
    <storeOutputAutomatically>true</storeOutputAutomatically>
</actionCalls>
```

- `inputParameters`의 `<name>`은 인보커블 이너 클래스(`GeocodingAddress`)의 `@InvocableVariable` 필드명과 **정확히 일치**해야 한다(`city`·`street`·`state`·`country`·`postalcode`).
- `storeOutputAutomatically=true` → Flow가 반환 `Coordinates`를 `geocode_address.lat`/`geocode_address.lon`으로 자동 저장.
- `faultConnector` 없이 콜아웃 액션을 두면 실패 시 Flow 전체가 unhandled fault로 중단된다 → 콜아웃 액션엔 fault 경로를 항상 배선.

---

## Queueable 연동 — 비동기 처리

```apex
// Flow에서 비동기 저장 호출
private static OutputParameters invoke(InputParameters input) {
    UpsertRecordsQueueable job = new UpsertRecordsQueueable(input.records);
    Id jobId = System.enqueueJob(job);

    OutputParameters output = new OutputParameters();
    output.jobId = jobId;  // Job ID를 Flow 변수로 반환
    return output;
}

public class UpsertRecordsQueueable implements Queueable {
    private List<SObject> records;

    @TestVisible
    UpsertRecordsQueueable(List<SObject> records) {
        this.records = records;
    }

    public void execute(QueueableContext ctx) {
        upsert records;
    }
}
```

---

## Flow.Interview — Apex에서 Flow 실행

```apex
// 다른 Autolaunched Flow를 Apex에서 기동
Map<String, Object> flowParams = new Map<String, Object>{
    'recordId' => input.recordId
};

if (!Test.isRunningTest()) {  // Flow 실행은 테스트에서 불가
    Flow.Interview interview = Flow.Interview.createInterview(
        input.namespace,   // 관리 패키지 namespace ('': 기본)
        input.flowApiName,
        flowParams
    );
    interview.start();
}
```

---

## 레코드 잠금 (Approval Process)

```apex
// 승인 잠금 확인
output.isLocked = Approval.isLocked(input.recordId);

// 잠금 / 해제
Approval.lock(input.recordId);
Approval.unlock(input.recordId);
```

---

## category 분류 (Flow Builder 정렬)

| category | 포함 액션 |
|---|---|
| `Collections` | 컬렉션 필터·정렬·집계·변환 |
| `Data` | SOQL 실행, 레코드 비동기 저장 |
| `Flows` | Flow 실행, Flow 메타데이터 조회 |
| `Security` | 레코드 잠금 확인/설정 |
| `Strings` | CSV 파싱·포맷팅 |
| `Utilities` | 업무 시간 계산, 랜덤 값 |
| `Messaging` | Chatter Rich 메시지 발송 |

---

## 테스트

```apex
@IsTest
static void testFilter() {
    // bulkInvoke 대신 invoke 직접 테스트 불가 (private)
    // → bulkInvoke를 통해 테스트
    FilterRecordsWithFieldValue.InputParameters input =
        new FilterRecordsWithFieldValue.InputParameters();
    input.collection = [SELECT Id, Name, Status__c FROM Order__c LIMIT 10];
    input.fieldName = 'Status__c';
    input.fieldValue = 'Active';

    List<FilterRecordsWithFieldValue.OutputParameters> outputs =
        FilterRecordsWithFieldValue.bulkInvoke(
            new List<FilterRecordsWithFieldValue.InputParameters>{ input }
        );

    Assert.areEqual(/* 기대값 */, outputs[0].filteredRecordCount);
}
```

---

## InvocableActionExtension — Flow Builder 커스텀 프로퍼티 에디터 *(Winter '26 추가)*

`InvocableActionExtension` 메타데이터를 사용하면 Flow Builder 내 Apex 액션의 입력 파라미터에 피클리스트 및 커스텀 프로퍼티 에디터를 정의할 수 있다. 별도 LWC 없이 Flow Builder UI에서 동적 선택 옵션을 제공한다.

---

## 파라미터 클래스 no-arg 생성자 필수 *(Summer '26 추가)*

**v67.0+부터 Invocable Action 파라미터 클래스(Request/Response)에 무인자 생성자 선언이 필수.**

| 패키지 유형 | 필요 접근자 |
|---|---|
| 비패키지(언매니지드) | `public` |
| 관리 패키지 | `global` |

```apex
// ✅ v67.0+ 필수 — no-arg 생성자 명시
public class FlowRequest {
    public FlowRequest() {} // no-arg 생성자 필수
    @InvocableVariable
    public String accountId;
}

// ❌ 이전 방식 — v67.0부터 허용 안 됨
public class FlowRequest {
    @InvocableVariable
    public String accountId;
    // 생성자 없음
}
```

---

## Platform Events 발행 접근 레벨 지정 *(Summer '26 추가)*

`EventBus.publishWithAccessLevel()` — Platform Events 발행 시 접근 레벨을 명시적으로 지정하는 신규 메서드.

```apex
// 구조 예시 — 실제 동작 코드 아님
EventBus.publishWithAccessLevel(eventList, EventBus.AccessLevel.USER);
```

---

## Agentforce 에이전트 액션으로 노출 — `apex://` 타깃 (agent-script-recipes)

동일한 `@InvocableMethod`를 **Agentforce 에이전트 액션**으로도 배선할 수 있다. Flow 관점(bulkInvoke·category·Flow 타입 매핑)과 별개로, 에이전트 관점에선 세 가지 계약이 추가된다. agent-script-recipes의 `WeatherService`가 예시다.

```apex
public with sharing class WeatherService {
    public class WeatherRequest {
        @InvocableVariable(label='City Name' required=true)
        public String cityName;
    }
    public class WeatherResponse {
        @InvocableVariable(label='Success')      public Boolean success;
        @InvocableVariable(label='Error Message') public String error_message;
        @InvocableVariable(label='Temperature')  public Integer temperature;
        @InvocableVariable(label='Humidity')     public Integer humidity;
        @InvocableVariable(label='Conditions')   public String conditions;
    }

    @InvocableMethod(label='Get Weather'
        description='Retrieves current weather information for a specified location')
    public static List<WeatherResponse> getWeather(List<WeatherRequest> requests) {
        // ... 요청별 WeatherResponse 생성 후 반환
    }
}
```

### 1) 필드명 = 액션 inputs/outputs 이름 (네이밍 계약)

`.agent` 액션의 `inputs`/`outputs` 이름은 Apex Request/Response 이너 클래스의 `@InvocableVariable` 필드명과 **글자 그대로 일치**해야 배선된다. `WeatherResponse.error_message`(스네이크 케이스 그대로) → 액션 output `error_message`.

```yaml
# ExternalAPIIntegration.agent (발췌) — 실제 Agent Script
actions:
   get_weather:
      description: "Fetch weather data from external API via Flow"
      inputs:
         cityName: string          # = WeatherRequest.cityName
            is_required: True
      outputs:
         temperature: object       # = WeatherResponse.temperature
            complex_data_type_name: "lightning__integerType"
         conditions: string        # = WeatherResponse.conditions
         humidity: object          # = WeatherResponse.humidity
            complex_data_type_name: "lightning__integerType"
         success: boolean          # = WeatherResponse.success
         error_message: string     # = WeatherResponse.error_message
      target: "apex://WeatherService"
```

### 2) Apex primitive 출력 → `object` + `complex_data_type_name`

Apex의 `Integer`/`Boolean`/`Date` 같은 primitive 출력을 에이전트 액션에서 쓰려면, 액션 output을 단순 타입이 아니라 **`object` + `complex_data_type_name`으로 감싸 선언**해야 한다. 위에서 `temperature`(Apex `Integer`)가 `object` / `complex_data_type_name: "lightning__integerType"`로 선언된 이유다.

| Apex 출력 타입 | 액션 output 선언 |
|---|---|
| `String` | `string` (그대로) |
| `Boolean` | `boolean` (그대로) |
| `Integer` | `object` + `complex_data_type_name: "lightning__integerType"` |

> `success`(Boolean)·`conditions`(String)은 primitive 그대로 두고, `temperature`·`humidity`(Integer)만 `object` 래핑된 점에 주의 — 래핑 규칙은 타입별로 다르다.

### 3) `genAiFunction`(invocationTargetType=apex)이 클래스를 액션으로 배선

`.agent` 번들의 `target: "apex://..."`와 별개로, 메타데이터 배포 경로에서는 `GenAiFunction`이 `invocationTargetType=apex`로 Apex 클래스를 에이전트 액션에 연결한다(같은 레포의 `Submit_Case` 예시).

```xml
<!-- Submit_Case.genAiFunction-meta.xml (발췌) -->
<GenAiFunction xmlns="http://soap.sforce.com/2006/04/metadata">
    <developerName>Submit_Case</developerName>
    <invocationTarget>CaseSubmissionService</invocationTarget>
    <invocationTargetType>apex</invocationTargetType>
    <masterLabel>Submit Case</masterLabel>
</GenAiFunction>
```

- `invocationTarget` = Apex 클래스명, `invocationTargetType=apex` → 해당 `@InvocableMethod`가 에이전트 함수로 노출.
- Agent Script(`.agent`) 방식과 `genAiFunction` 메타데이터 방식은 같은 인보커블을 배선하는 두 경로다. Agent Script 문법·액션 참조는 [[Agent Script 레퍼런스 — 액션 (apex·flow·prompt)]] 참조.

> 하나의 `@InvocableMethod`가 **Flow 액션 · Agentforce 액션 둘 다**로 재사용된다 — Request/Response 이너 클래스 설계가 두 소비자 모두의 계약이 된다.

---

## 관련 노트

- [[Flow Interview API]] — Apex에서 Flow를 실행하는 반대 방향 패턴
- [[Flow Screen LWC 패턴]]
- [[멀티 패키지 구조]]
- [[Queueable 체이닝]]
- [[Summer '24]] — @InvocableVariable defaultValue/placeholderText 추가
- [[Winter '26]] — InvocableActionExtension 메타데이터
- [[Summer '26]] — no-arg 생성자 필수, EventBus.publishWithAccessLevel
- [[Summer '26/Development]] — no-arg 생성자 필수, InvocableActionExtension 메타데이터 상세
- [[Aura Flow 로컬 액션 (availableForFlowActions)]] — 서버 인보커블(이 노트)의 클라이언트 짝. 브라우저 전용 동작(네비게이션·유틸리티바)은 로컬 액션으로 (선택 기준 비교)
- [[RestClient 패턴]] — Named Credential 기반 관리형 콜아웃 (이 노트의 `callout=true` 익명 콜아웃과 대비)
- [[Agent Script 레퍼런스 — 액션 (apex·flow·prompt)]] — 인보커블을 `apex://` 에이전트 액션으로 배선하는 Agent Script 문법
