---
tags: [omnistudio, flexcard, omniuicard, low-code, ui, data-display]
source: help.salesforce.com — OmniStudio FlexCard (xcloud.os_flexcardsbasics_8118·os_omnistudio_flexcards_24388·os_create_a_flexcard_25432·os_set_up_a_flexcard_in_the_flexcard_designer_37646·os_flexcards_display_elements_reference_28421·os_flexcards_input_elements_reference_31222·os_configure_a_data_source_on_a_flexcard_35864·os_flexcards_data_source_properties_36016·os_add_an_action_to_a_flexcard_25672·os_flexcards_reserved_event_and_channel_names_28308·os_add_conditions_to_a_flexcard_state_35695·os_omniscript_or_fc·os_activateconfigureand_publish_flexcards_24744, 접속일 2026-07-13) [Tier 2]
created: 2026-07-13
aliases: [FlexCard, 플렉스카드, OmniUiCard, data source, 데이터 소스, states, 카드 상태, display elements, flexcard actions, reserved events, pubsub]
---

# FlexCard

> 고객 컨텍스트에 맞춰 정보와 액션을 하나의 LWC 블록에 담는 OmniStudio 선언형 UI 컴포넌트 — 상태(States)·데이터 소스·액션·이벤트로 동적 카드를 구성한다.

---

## FlexCard란

FlexCard는 **특정 컨텍스트 안에서 관련 정보와 프로세스로의 링크를 결합한 블록(block)** 이다. Salesforce 플랫폼 위에서 고객 중심(customer-centric)·산업별(industry-specific) UI 컴포넌트를 선언형(declarative) 디자인 도구인 **FlexCard Designer**로 만들고, Lightning 페이지나 Experience Cloud 페이지에 추가한다. Lightning Component 프레임워크로 빌드된다.

예를 들어 **account card**는 다음과 같은 고유 계정 정보를 담을 수 있다:

- Status
- Priority or service level agreement (우선순위 또는 SLA)
- Creation date

account card에서 수행할 수 있는 **액션** 예시:

- Closing a case (케이스 닫기)
- Opening a new case (새 케이스 열기)
- Creating a new task (새 태스크 생성)

FlexCard Designer에서는 Omniscript를 launch/update하거나, 웹 페이지·앱으로 navigate, flyout 표시, 이벤트 fire, 필드 값 update 등의 액션을 만든다.

### OmniUiCard 객체와 활성화 시 LWC 생성

- 생성된 FlexCard는 **Lightning Web Component**다. 비즈니스 로직에 따라 일부 사용자는 생성된 FlexCard를 직접 수정하기도 한다.
- FlexCard의 메타데이터 객체는 **Omni UI Card**(OmniUiCard)다. canvas 뷰가 열리지 않으면 Omni UI Card 객체의 기본 Lightning 레코드 페이지를 업데이트한다. (custom object data model → standard object data model 마이그레이션 후 기본 레코드 페이지가 달라졌을 때 발생.)
- **표준 런타임(Winter '25~)**: Omnistudio standard runtime에 포함된 새 Designer에서 생성·관리. 패키지 설치 불필요, 권한 활성화 후 사용. FlexCard 활성화가 즉시(instant) 이루어짐.
- **관리형 패키지(managed package) Designer**: 기존 Designer는 그대로 유지. 이 Designer에서는 생성 시점에 데이터 소스 타입과 test parameters도 구성 가능하다.

> 이름(name)·author의 조합은 고유해야 하며, 클론하지 않는 한 name·theme·author를 변경할 수 없다.

---

## States 모델 (핵심)

FlexCard **states**는 사용자가 사용할 수 있는 필드와 액션을 결정한다. FlexCard를 만들면 Omnistudio가 **default state**를 하나 할당한다. 조건에 따라 서로 다른 정보·상호작용을 제공하려면 state를 추가한다.

- **State element**을 elements 패널에서 canvas로 드래그해 state를 추가한다.
- state마다 **내부 이름(internal name)** 을 입력하고, 필요한 조건(conditions)과 elements를 추가한다.

### null / Blank Card State

레코드가 없을 때 표시할 state를 만들려면:

- **Use this state when the FlexCard returns a null value** 를 선택한다.
- 관리형 패키지 Designer를 쓰는 경우 **Blank Card State** 를 선택한다.
- 예: Policy 객체에서 데이터 소스가 레코드를 반환하지 않을 때, "add a policy" Omniscript 액션이 있는 state를 만든다.

### top-to-bottom 평가 (첫 매칭 state 승리)

여러 state를 추가하면 Omnistudio는 이들을 **top-to-bottom(위→아래)** 으로 순회하며, **조건을 만족하는 첫 번째 state의 데이터를 표시**한다.

- **권장 정렬 순서**: 가장 복잡한(most complex) state → 가장 단순한(simplest) state 순으로 배치.
- 그 다음, **조건이 없는(no conditions) state** 를 끝에 하나 추가하고, 마지막에 **blank card state** 를 추가한다.

> 조건은 개별 element·필드·이벤트 단위(granular)로도, FlexCard 전체 단위로도, 또는 양쪽 모두에 적용할 수 있다. State는 **FlexCard 레벨**에서 사용자에게 무엇을 보여줄지 제어하는 수단이다. 예: 보험 계정의 결제 상태(payment status)에 따라 서로 다른 FlexCard를 표시하려면 상태별 state를 만든다.

---

## Display Elements (전수)

정보를 표시하기 위해 FlexCard에 추가하는 display element 전체 목록이다. 대부분 element에는 앱 내 info bubble이 제공되나, custom LWC처럼 설정이 복잡한 element는 별도 고려사항이 있다.

| Display Element | 용도 |
|---|---|
| **Block** | element들의 논리적 그룹을 접을 수 있는(collapsible) 컨테이너로 묶는다. 예: 계정 기본 정보를 한 block에, 연락처 정보를 다른 block에. |
| **Chart** | 데이터를 차트로 표시. bar·pie·donut 등 사용 가능한 타입 제공. aspect ratio·dimensions 등 설정. |
| **Custom Lightning Web Component** | 커스텀 스타일·기능을 추가한 컴포넌트를 임베드. 예: 기존 carousel 컴포넌트를 임베드하고 attribute 구성. |
| **Data Table** | 데이터 소스에서 가져온 데이터를 정렬 가능한(sortable) 테이블로 표시. 예: account cases를 sortable table로. |
| **Display Field** | 데이터 소스가 반환한 데이터 필드를 표시. 예: Account의 Policy 정보 표시. |
| **Child Flexcard (Embed Flexcard)** | FlexCard를 다른 FlexCard의 자식(child)으로 임베드해 데이터 공유. 자식은 자체 데이터 소스를 갖거나, 부모가 자식의 데이터 소스를 자신의 것으로 override 가능. 부모가 record ID 등 특정 데이터를 자식의 context ID로 전달 가능. |
| **Icon / Image** | 기존 라이브러리 또는 자체 이미지에서 아이콘·이미지 추가. 액션·CSS 클래스·dimensions 구성. |
| **Menu (Group Actions)** | 액션 목록으로 메뉴를 만든다. 메뉴 버튼과 드롭다운 내 각 액션을 스타일링. |
| **Text** | plain text와 merge field를 결합해 표시. rich text editor로 최종 렌더링 포맷팅. |

> Actions와 States도 display element로 참조된다.

⚠️ **cyclic redundancy 주의**: flyout·custom LWC·Flexcard처럼 자기 자신을 호출하거나 다른 컴포넌트에 임베드된 컴포넌트를 추가하면 이벤트가 무한 실행되어 브라우저의 최대 call stack size를 초과할 수 있다. 예: FlexCard의 child Flexcard가 Omniscript를 호출하고, 그 Omniscript가 flyout에서 다시 같은 parent Flexcard를 호출하는 경우.

---

## Input Elements

Input element를 추가하면 사용자가 데이터를 입력할 수 있고, 이 입력은 **JSON 데이터를 업데이트**한다. 사용자가 element와 상호작용할 때 액션을 실행하도록 구성할 수도 있다.

모든 input element에서 구성 가능한 설정:

- **Common parameters** — field binding: 사용자가 입력한 정보를 기반으로 데이터 필드를 업데이트.
- **Lightning web component custom attributes** — 예: 조건부 체크박스 색상, 토글 hover 시 특정 레이블 등.
- **Actions / conditions / style formats** — 다른 FlexCard element 타입과 동일하게 적용.

### 입력값 기반 데이터 필드 업데이트 (field binding)

input element 값을 데이터 소스의 데이터 필드에 바인딩하면, 사용자가 입력값을 변경할 때 Omnistudio가 대응하는 JSON 코드를 업데이트한다. 업데이트된 데이터는 데이터 소스의 다른 데이터처럼 사용 가능하다. 예: 사용자 입력을 기반으로 parent → child Flexcard로 전송된 attribute 값을 업데이트.

- **Element-Specific Considerations**: 각 element가 매핑되는 LWC와 구성 가능한 attribute를 확인하고, 해당 readme 파일에서 custom attribute 설정 정보를 얻는다.

---

## Data Source (전수 10종)

FlexCard가 표시할 데이터를 어떻게 가져올지 구성한다. child와 parent Flexcard에 서로 다른 데이터 소스를 설정할 수 있다. 데이터 소스가 보이지 않으면 활성화되어 있는지 확인한다(**Enable and Disable Data Sources** — Card Framework Configuration custom setting에서 org·profile·user 레벨로 데이터 소스 타입 enable/disable).

> **권장**: 어떤 데이터 소스로든 데이터를 가져올 때는 처음엔 낮은 limit을 걸고, 카드 개발·게시 후 양을 늘린다. 최적의 유연성·구현 용이성을 위해서는 **Integration Procedure**를 데이터 소스로 사용해 단일 서버 콜에서 여러 액션을 실행하는 것이 권장된다.

### 1. SOQL Query

SOQL 쿼리로 org 데이터를 검색. SOQL 쿼리는 **암호화(encrypted)** 되어 client-side에 쿼리 정보가 노출되지 않는다.

- 필드 매핑 시, 테스트 쿼리에서 해당 레코드에 **non-null 값이 있는 필드만** field picker에 보인다. 매핑할 모든 필드에 non-null 값이 있는 테스트 레코드를 사용한다.
- **FLS 적용**: Setup → Omni Interaction Configuration → New. Name·Label = `EnableQueryWithFLS`, Value = `true`. 활성화 시 사용자가 볼 권한 있는 필드만 표시된다.
- ⚠️ **2026년 2월 2일 주간부터** Salesforce가 `EnableQueryWithFLS` 설정을 기본 활성화한다 (org 보안 강화, SOQL·SOSL 공통).

```
SELECT Id, Name, Email, Phone, Title FROM Contact WHERE Email != Null LIMIT 10
```

### 2. SOSL Search

검색 인덱스에 대한 텍스트 기반 검색. 단일 쿼리로 접근 권한 있는 여러 객체(커스텀 객체 포함)의 text·email·phone 필드를 검색. SOSL 쿼리도 **암호화**된다. FLS 적용은 `EnableQueryWithFLS=true` 동일.

- 검색어 입력 → 검색할 필드 선택 → 최소 1개 sObject와 1개 필드 선택 → 필요 시 최대 반환 행 수(limit) 입력.

### 3. Apex Remote (VlocityOpenInterface)

Apex 클래스·메서드를 호출해 데이터를 fetch. **비동기(asynchronously) 실행** 가능 — CPU time은 증가하지만 long-running 트랜잭션이 타임아웃되지 않는다. Apex remote 클래스는 **`VlocityOpenInterface`(VlocityOpenInterface2)를 구현하는** 표준 Apex 클래스다.

- 시작 전 Apex class permissions checker를 추가해 remote action에서 VlocityOpenInterface 클래스(API)에 접근 가능한 대상을 정의(**Set Up Access to Remote Action APIs**).
- Apex 클래스·메서드 선택 → 비동기 실행 여부 선택 → 필요 시 response status 확인 interval(ms) 입력.
- **input map**(Key = context ID 변수, Value = 변수 값. 예: AccountId 키 + 레코드의 account ID) 및 **options map**(추가 key-value)로 값 전달. Value 필드는 static 값과 `{recordId}`·`{name}` 같은 merge field 지원.

```apex
global class RemoteActionClass implements [Namespace].VlocityOpenInterface2 {

    public Boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> outMap, Map<String,Object> options) {
        if (methodName.equals('getAccounts')) {
            getAccounts(input, outMap, options);
        }
        return true;
    }
    // getAccounts() 메서드 본문 예시 코드는 공식 문서 참조 (안전 필터로 원문 미확보)
    // ...
    //     outMap.put('accounts', accounts);
}
```

### 4. Apex REST

Apex REST 콜로 데이터 조회. **GET**: 필드에 데이터 채우기. **POST**: 서버로 데이터 전송(JSON Payload 필드에 JSON 입력). endpoint URL 예: `/services/apexrest/{namespace}/CardTestApexRestResource/{recordId}`. context 변수로 상속값 전달 가능.

```apex
@RestResource(urlMapping='/v1/typeahead/*')
global with sharing class TypeaheadApexRest {
    // TypeaheadApexRest 클래스 본문 예시 코드는 공식 문서 참조 (안전 필터로 원문 미확보)
}
```

### 5. Omnistudio Data Mapper

**Data Mapper Extract**에서 데이터를 fetch. **field-level security 완전 지원**. 시작 전 FlexCard의 context ID(예: AccountId)에 대응하는 input parameter가 있는 Data Mapper Extract를 생성.

- Data Mapper 선택 → 필요 시 input map(Key = context ID 변수, Value = 변수 값)으로 값 전달. Value는 static·`{recordId}`·`{name}` merge field 지원.

### 6. REST (named credentials)

public API를 통해 데이터를 조회/전송. 예: policyholder의 ZIP code 기반 weather API. **named credentials**로 Apex callout을 인증(callout endpoint URL·인증 파라미터를 한 정의에 지정).

- 시작 전: REST endpoint URL을 **Remote Sites**에 등록 + **trusted URL**로 추가.
- REST type → method type(GET: URL 파라미터 기반 요청 / POST: JSON 전송).
- named credential REST type: named credential 선택 → data 조회용 상대 경로 입력(예: `My_Payroll_System/paystubs?format=json`).
- Web REST type 이하의 세부(예시 payload)는 안전 필터로 원문 미확보 — 공식 문서 참조.

### 7. Integration Procedure

Integration Procedure로 **단일 서버 콜에서 여러 액션 실행**. 예: Data Mapper Extract로 계정 ZIP code를 반환하고, REST API 콜로 그 지역 날씨를 가져오는 IP.

- IP 선택 → 필요 시 key-value pair로 값 전달. Value는 `{}, {}, ...` 형식. **array 형식은 미지원** — `[{},{}]` 형태의 객체 배열은 interpolation 로직을 깨뜨린다(`{ }` 포맷만 허용).
- Omnistudio Winter '23 이상: Apex의 **Continuation class**로 long-running 외부 웹 서비스 요청 구성 — options map에 Key=`useContinuation`, Value=`true`.
- 필요 시 IP에 sample data 추가(Response Action for Integration Procedures).

### 8. Streaming API (PushTopic / Streaming Channel / Platform Event)

push technology(publish-subscribe 모델)를 사용 — 서버가 정의된 criteria에 따라 클라이언트로 정보를 전송. persistent connection으로 새 데이터를 지속 전달(client polling 대신). API 콜 수를 줄여 성능 향상. **Streaming API 데이터 소스는 관리형 패키지 Designer에서만 지원된다.**

- **PushTopic**: 레코드 변경을 streaming API 채널로 리스너에게 알리는 SOQL 쿼리. 예: 특정 type·status의 케이스 생성 시 알림.
- **Streaming Channel**: Salesforce 데이터 변경과 무관한 일반 이벤트 알림을 전송(예: 채팅 앱의 커스텀 알림).
- **Platform Event**: 이벤트 기반 메시징 아키텍처. PushTopic과 streaming channel 타입을 결합. sObject 대신 커스텀 객체로 동작.
- Channel에 streaming API URL 입력 → operation 타입(데이터 replace/add) 선택 → **Get All Messages**: True(최근 24시간 전체) / False(최신 업데이트).

> Streaming API의 하위 메커니즘(CometD·PushTopic·Generic Streaming)은 [[Streaming API (CometD·PushTopic·Generic Streaming)]] 참조.

### 9. Custom (JSON)

외부 데이터 소스 없이 **커스텀 JSON 데이터를 FlexCard에 직접 임베드**. API 접근 대기 중이거나 빠른 개념 테스트 시 임시 static 데이터로 테스트. custom JSON 코드를 직접 입력한다(공식 문서에 Contact 배열 예시 JSON 수록).

### 10. Autolaunched Flow (Pilot)

새/기존 **autolaunched flow**를 FlexCard의 데이터 소스로 사용.

> ⚠️ **Pilot/Beta**: Beta Services Terms 적용. 사용은 고객 재량. Agentforce에 연락해 org에서 활성화.

- 시작 전: Omnistudio Settings에서 **Enhanced Runtime Performance** 활성화. flow에 Picklist·Multi-Select Picklist·Apex-Defined 데이터 타입이 없어야 함.
- **데이터 소스로**: Setup 패널 → Data Source → Data Source Types에서 Autolaunched Flow 선택 → Autolaunched Flows 필드에서 flow 검색·선택 → Import 섹션에서 Import → inputs에 포함할 key 선택·값 입력.
- **액션으로**: Action input element 추가 → Action 섹션에서 action type = **Data** → Data Source Types = Autolaunched Flow → Input Map에서 Import → key 선택·값 입력.

### Common Properties (모든 데이터 소스 공통)

| Property | 설명 |
|---|---|
| **Order By** | 지정 필드로 레코드 정렬. |
| **Reverse Order** | 반환된 레코드 순서 역전. |
| **Fetch Timeout(ms)** | 데이터 소스 응답을 기다리는 시간 설정. |
| **Refresh Interval(ms)** | 데이터 확인 빈도. 각 refresh 시 데이터 소스 레코드가 변경됐으면 FlexCard와 그 child 컴포넌트가 reload. |
| **Delay(ms)** | 이 데이터 소스 콜을 다른 서버 요청과 묶지 않고 우선순위를 지정하려면 지연 시간(ms) 입력. |
| **Key** | 전달할 변수 입력(예: AccountId context ID). |
| **Value** | 변수 값 입력(merge field `{recordId}` 또는 static 값 등). |
| **Test Parameters** | 미리보기 시 쿼리가 데이터를 가져오는 데 쓰는 test 변수 추가. |
| **Result JSON Path** | JSON 응답의 특정 노드 경로 지정(예: `['Cases']`). 전체 JSON이 array면 index 포함(예: `[0]['Cases']`). |

---

## Actions (전수)

지원 element에 액션을 추가하거나 action element를 FlexCard에 추가한 뒤 액션 설정을 구성한다. **sequential actions**(순차 액션)와 각 액션의 trigger를 설정할 수 있다.

- 액션은 properties 패널에서 설정 시 event listener 등에서 추가할 때보다 필드가 더 많다(예: "actions 완료까지 상호작용 차단" 옵션).
- **blocking interactions until actions are complete**: 액션 진행 중 사용자 상호작용 방지. 또는 값이 true인 merge field(예: `{requireResponse}`) 입력.
- **tracking**: card load·card unload·state load(FlexCard 레벨) 및 UI action(action 레벨) 이벤트 기록. 기본적으로 parent Flexcard는 추적하나 child Flexcard는 안 함 — child 추적하려면 child와 모든 parent에서 설정 on.

### 순차 실행 규칙

preview/런타임에서 Omnistudio는 액션을 **top to bottom**으로 실행하며, **각 액션 완료를 기다린 후 다음 액션을 trigger**한다. 이전 액션의 response를 이후 액션에서 사용 가능. **액션이 실패하면 이후 액션을 실행하지 않는다.** (단, 순차 custom/pubsub 이벤트가 각자의 event listener에서 순차 액션을 trigger할 때는, 실패한 액션이 다음 event listener의 다음 액션 시퀀스를 막지 않는다.)

> 💡 FlexCard를 벗어나는(navigate away) 액션은 큐의 **마지막**에 두거나, 이후 액션을 중단하도록 설정한다. data action type은 response를 response node에 저장해 후속 액션에서 사용.

예시 시퀀스: set values로 데이터 값 업데이트 → update Omniscript 액션으로 업데이트 값을 Omniscript에 전달 → navigate 액션으로 레코드 페이지 이동.

### Action Types

| Action Type | 설명 |
|---|---|
| **Card Action (Update a Flexcard / set values)** | 사용자가 trigger하며 FlexCard의 레코드나 FlexCard 자체에 영향을 주는 액션. 예: 개인 취향에 맞게 레코드 뷰 정렬. |
| **Data (Get or Send Data)** | 데이터 소스를 호출해 서버로부터/서버로 데이터 전송. 수신 데이터를 카드 record object의 JSON 또는 지정 data node에 추가. 예: 부모 데이터로 child Flexcard 채우기, API 응답에 따라 조건부 메시지 표시. |
| **Fire Event (pubsub / custom event)** | 이벤트 발생 시 element의 액션을 통해 FlexCard에 알림 전송 → 이벤트 기반 액션 실행. child↔parent, element↔FlexCard, 별개 컴포넌트 간 통신. |
| **Flyout** | 사용자가 액션 클릭 시 child Flexcard·Omniscript·custom LWC의 추가 정보를 표시. 예: FlexCard에 계정 정보, flyout에 primary contact 이름·이메일. |
| **Navigate** | 외부 URL·Lightning 페이지·Experience Builder Aura 사이트 페이지·임의의 Salesforce 페이지로 이동. |
| **Launch Omniscript** | FlexCard가 Omniscript를 호출해 FlexCard의 데이터 소스를 업데이트. 예: 사용자가 account ID 입력 → Omniscript 액션 클릭 → 입력값 전달하며 계정 정보 업데이트 폼 launch. |
| **Update Omniscript** | 사용자 액션에 응답해 Omnistudio가 업데이트할 JSON node 지정 — FlexCard를 Omniscript에 custom LWC로 임베드하는 방식. |

---

## 이벤트·채널

FlexCard는 event listener로 다른 컴포넌트에서 trigger된 이벤트를 추적하고 대응 액션을 수행한다. listener 타입:

- **Pubsub**: 같은 Lightning 페이지의 다른 FlexCard 등 **다른 컴포넌트**에서 온 이벤트.
- **Custom event**: **child Flexcard** 또는 카드 위 element에서 온 이벤트.
- **Record change**: FlexCard에 있는 레코드의 변경. 레코드 ID를 `{recordId}` 또는 실제 ID 값으로 입력하고 record type 선택. 레코드 변경 시 카드에 복사할 필드 선택 가능. 기본은 Salesforce 객체 기반 Fields 드롭다운, **Advanced Mode** on 시 임의 sObject·related object의 필드를 배열로 지정(예: `Contact.Id, Contact.Account.Id, Contact.Name`). ⚠️ Experience Cloud 페이지에서 레코드 변경 시, 같은 브라우저 탭 내 편집일 때만 반영(백엔드 프로세스 경유 X).

### 예약 이벤트/채널명 (Reserved Names)

지정된 목적으로만 사용해야 하는 예약 이름:

| Reserved Name | Event Type | Property Name Used In | 설명 |
|---|---|---|---|
| **close_modal** | Pubsub Event | Channel Name | channel name이 `close_modal`일 때 flyout 창을 자동으로 닫는다. |
| **closemodal** | Custom Event | Event Name | 액션에서 flyout 창을 닫는다. |
| **close** | Pubsub Event | Event Name | channel name이 `close_modal`일 때 조합으로 flyout 창을 자동으로 닫는다. |
| **resetselectedcards** | Custom Event | Event Name | 여러 parent card에 걸친 선택된 모든 child card를 reset. |
| **selectcards_** | Custom Event | Event Name | custom event listener에서 사용자가 선택한 카드의 데이터로 Omniscript를 업데이트. |

**금지어(이벤트 설정 시 사용 불가)** — Omnistudio가 특정 이벤트에 이미 사용:

- `executeaction`
- `fireactionevent`
- `reload`
- `remove`
- `setvalue`
- `showtoast`
- `updatedatasource`
- `updatefieldbinding`
- `updateos`
- `updateparent`
- `updatestyle`

---

## 설정·임베드

FlexCard Settings(Setup 패널)에서 동작을 구성한다.

> ⚠️ FlexCard 업데이트/구성 후 캐시를 지워도 반영에 **15–20분** 소요. 오류나 구버전 로드 시 Salesforce support에 Template API 설정 활성화 요청.

### Multi-language `{Label}`

multi-language support를 켜면 custom label을 지원 언어로 번역 가능. **`{Label}` merge field**로 다음 element에 custom label 추가:

- **Field**: Label, output, placeholder
- **Text**: rich text editor 내부
- **Action**: Label

> Omnistudio는 custom label을 캐시에 저장하지 않고 매번 업데이트. standard runtime에서는 표준 에러 메시지 등 autotranslated system label을 locale 기반으로 제공.

### Session Variables / Public Properties

- **Session variables**: 전역 접근 가능한 변수. key·value 입력 후 `{Session.var}` merge field로 element 필드에 적용(예: REST endpoint URL). 적용 가능 대상 — Action: Label / Custom event action: Input Parameter > Value / Field: Label·Placeholder·Output / Text: rich text editor 내부. **데이터 소스 값은 session variable로 쓸 수 없다.**
- **Public properties**: Lightning/Experience Builder 페이지에서 값을 설정하는 속성. attribute 이름을 **pascal case**로 입력 → 생성 API 이름은 **`cfPropName`**. custom LWC·Omniscript에서는 **kebab case**로 참조(예: **`cf-record-limit`**). Experience Builder 노출은 `lightningCommunity__Default` target 선택. `{Session.RecordLimit}` 형태로 session variable처럼 호출 가능. public property는 configuration 파일의 `targetConfig` 태그 하위 `property` subtag에 게시.

### FlexCard 안에 FlexCard / OmniScript 임베드

- **Embed Flexcard in a Flexcard**: FlexCard를 child로 임베드해 데이터 공유. 자식은 자체 데이터 소스 보유 가능, 부모가 override 가능.
- **Omniscript support**: FlexCard가 LWC Omniscript와 상호작용하면 Omniscript support를 켠다. 예: Omniscript의 Custom LWC element로 FlexCard를 Omniscript 안에 렌더링, 또는 Update OmniScript action element로 Omniscript 업데이트.
- **Repeat Records**: 데이터 소스의 레코드마다 카드 컨테이너를 생성(모든 레코드를 한 카드에 표시하는 대신). render key로 DOM에서 업데이트할 반복 카드 레코드를 식별해 성능 개선. data table·chart·자체 데이터 소스를 쓰는 컨테이너(LWC·child Flexcard)는 deselect 권장.
- **width listener**: 브라우저 너비 변경 시 element 리사이즈·카드 재렌더링을 위한 동적 클래스를 CSS에 자동 추가.
- **custom permissions**: 콤마 구분 목록으로 FlexCard 접근 제한(예: `Can_Edit_Policy,Can_View_Policy`). 비워두면 모든 사용자가 볼 수 있음. ⚠️ 이는 런타임 UI 가시성만 제어하며 **데이터 접근을 제한하지 않는다** — 데이터 접근은 field-level security로 관리. 암호화 필드의 복호화 값 표시 전 항상 **View Encrypted Data** 권한 확인.

### Flexcards Omni Interaction Access Configuration

Omni UI Card 객체(FlexCard)에 대한 데이터 소스 접근 제한·캐시 설정을 org 전역에서 관리. org·profile·user 레벨로 데이터 소스 타입 enable/disable. Platform Cache 캐싱을 모든 FlexCard에 대해 비활성화하거나, 전체 캐싱 완료를 기다리지 않고 비동기 캐싱 활성화 가능.

---

## 활성화·게시

FlexCard가 준비되면 activate한 뒤 Lightning 페이지 또는 Experience Builder 사이트 페이지에 추가한다. **active FlexCard는 편집·삭제 불가** — 변경하려면 먼저 deactivate.

### 런타임별 컴포넌트

- **Omnistudio for Vlocity / Standard Summer '22 이전**: 활성화 시 custom LWC 생성 → 생성된 LWC를 페이지에 추가.
- **Standard Summer '22 이후**: 활성화 후 **standard Flexcard 컴포넌트**를 페이지에 추가(권장). 관리형 패키지 → standard runtime 마이그레이션 시 기존 FlexCard의 새 버전을 standard runtime용으로 생성 후 Lightning App Builder/Experience Builder의 **Process Automation** 섹션에서 추가.

### Publish Options — Targets (전수)

Publish Options에서 게시할 대상 페이지 선택:

| Target | 설명 |
|---|---|
| **App Page** | Lightning App Builder의 App page에서 사용 가능. |
| **Home Page** | Lightning App Builder의 Home page에서 사용 가능. |
| **Record Page** | Lightning App Builder의 record page에서 사용 가능. |
| **Community Page** | Experience Builder 페이지에서 drag-and-drop 컴포넌트로 사용 가능. |
| **Community Default** | Experience Builder에서 컴포넌트 선택 시 편집 가능한 속성을 노출. |

> parent Flexcard의 publish option은 **최소 1개 target 선택 필수**. 모든 target을 해제하고 Save하면 Omnistudio가 App Page·Home Page·Record Page를 기본 target으로 자동 활성화.

### LWR 사이트 고려사항

Experience Cloud 사이트/Lightning 페이지에서 참조하려면 **Flexcard wrapper 컴포넌트**를 사용(Salesforce Lightning Component Library). **LWR(Lightning Web Runtime) 사이트**에서는 로드할 FlexCard 이름을 받는 wrapper 컴포넌트를 사용해야 하며 **`flexcard-name` attribute는 필수**다.

```html
<namespace-flex-card-standard-runtime-wrapper
    flexcard-name="name"
    record-id="recordId"
    object-api-name="objectApiName"
    records="records"
    exposed-attributes="exposedAttributes">
</namespace-flex-card-standard-runtime-wrapper>
```

LWR 사이트 주요 고려사항:

- child/parent FlexCard를 변경하면 이를 쓰는 사이트를 **republish** 해야 함(production-ready일 때만).
- LWR에서 Open Omniscript 옵션을 쓰려면 페이지 Properties에서 **Load Omniscript from URL** 체크박스 선택 + `lwcos` 페이지 생성 필요.
- LWR 사이트의 **Style 탭은 FlexCard element와 동작 안 함** — FlexCard designer 내 옵션으로 스타일 제어.
- Custom LWC 지원. 단 **nested custom LWC**는 workaround 필요(LWR은 cached data 기반이라 build time에 nested Flexcard/Omniscript를 로드).
- LWR 사이트를 Digital Experiences에서 열면 unauthenticated user로 간주되어 guest user 데이터가 있는 FlexCard만 표시 — 전체 데이터를 보려면 login 페이지 구현.
- ⚠️ **Streaming API를 데이터 소스로 쓰면 LWR에서 동작하지 않는다.**

### Experience Cloud 접근 — Omni UI Cards 객체

Experience Builder 사이트에서 사용자가 FlexCard를 보려면 **Omni UI Cards 객체에 View All Records 접근** 권한을 부여해야 한다. Apex class 접근 제어를 위한 permission set·group도 구성.

### 게시 후 추가 설정

- **Lightning 페이지 추가**: Setup → Lightning App Builder → 페이지 Edit → Standard 섹션에서 Flexcard 컴포넌트를 canvas로 드래그 → Flexcard Name 선택(기본은 최근 active FlexCard) → 사용자 상호작용 추적은 **Enable Omnistudio Analytics**.
- **Experience Builder 페이지 추가**: Aura 사이트는 **Process Automation**, LWR 사이트는 **Customer Interactions** 섹션에서 컴포넌트를 찾음. **Exposed Attributes**에 public property를 JSON으로 입력(예: `{"AccountRecordLimit": 5, "Greeting": "Hello"}`). object API name은 `{!objectApiName}` 형식(예: `{!Account}`).

---

## FlexCard vs OmniScript

Omniscript와 FlexCard는 둘 다 UI이며 여러 소스에서 데이터를 pull하고 상호작용할 수 있다. **목적이 데이터를 보여주기만 하는가, 아니면 복잡한 상호작용 UI가 필요한가**로 구분한다.

| 구분 | FlexCard | OmniScript |
|---|---|---|
| 주 용도 | 데이터 **표시** (account 정보·contact 상세·opportunity 상세) + 단순 액션 | 데이터 표시 + **다단계(step-by-step) 정보 수집** |
| 상호작용 | multi-step 없이 표시. Omniscript·새 창 launch, 주소 업데이트 같은 단순 액션 | guided·interactive flow, radio button·text 등 response format으로 수집 |
| 조건 로직 | 조건부 element 표시/숨김 | 복잡한 조건 로직으로 액션 세트 전환 |
| 상호 임베드 | Omniscript를 launch/표시 | 데이터 시각화용으로 FlexCard 사용 |

- **FlexCard 유스케이스**: Experience Cloud 대시보드에서 배정된 open opportunity 목록을 오래된 순으로 테이블에 표시, 사용자가 정렬·필터 같은 기본 상호작용 수행.
- **OmniScript 유스케이스**: 직원의 medical history를 여러 화면 questionnaire로 수집해 회사 승인 보험 플랜을 제안.

---

## 관련 노트

- [[OmniStudio 개요·오리엔테이션]] — 시리즈 허브·오리엔테이션
- [[OmniScript]] — FlexCard 액션이 실행하는 가이드형 UI 프로세스
- [[Data Mapper (DataRaptor)]] — 데이터 소스로 쓰는 Data Mapper
- [[Integration Procedure]] — 데이터 소스로 쓰는 서버측 오퍼레이션 번들
- [[OmniStudio Formula Functions 레퍼런스]] — FlexCard element·상태에서 쓰는 공용 수식 함수
- [[Streaming API (CometD·PushTopic·Generic Streaming)]] — Streaming API 데이터 소스(PushTopic·Streaming Channel·Platform Event)의 하위 메커니즘
- `lightning-omnistudio-flexcard` base component — Lightning Component Library의 FlexCard wrapper 컴포넌트 (LWC 노트 참조)
