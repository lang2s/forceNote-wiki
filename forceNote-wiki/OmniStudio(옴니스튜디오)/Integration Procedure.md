---
tags: [omnistudio, integration-procedure, omniprocess, server-side, orchestration, integration]
source: help.salesforce.com — OmniStudio Integration Procedures (xcloud.os_integration_procedure_features_not_in_omniscripts_8210·os_omnistudio_integration_procedures_48334·os_standard_integration_procedure_workflow·os_build_integration_procedure·os_group_integration_procedure_steps_using_blocks_48498·os_integration_procedure_actions_50165·os_remote_action_for_integration_procedures_54037·os_http_action_for_integration_procedures_53002·os_integration_procedure_invocation_55721·os_integration_procedure_invocation_from_apex_55724·os_integration_procedure_invocation_from_rest_apis_55792·os_integration_procedure_invocation_from_salesforce_flow_55876·os_long_running_integration_procedures_56206·os_error_handling_in_integration_procedures_55179·os_cache_for_top_level_integration_procedure_data_54841, 접속일 2026-07-13) [Tier 2]
created: 2026-07-13
aliases: [Integration Procedure, IP, 인테그레이션 프로시저, OmniProcess, server-side orchestration, IP actions, IP blocks, Remote Action, chainable, queueableChainable, IP invocation, Try-Catch, Loop, Cache block]
---

# Integration Procedure

> UI 없이 서버에서 동작하는 OmniStudio의 다단계 데이터 오케스트레이션 프로세스 — 여러 액션을 단일 서버 호출로 실행하고 동기/비동기·캐싱·체이닝을 지원한다.

---

## Integration Procedure란

Integration Procedure(IP)는 Salesforce와 외부 서드파티 애플리케이션 사이의 데이터 상호작용을 **선언적으로 자동화**하는 OmniStudio 도구다. 복잡한 데이터 변환·API 호출·이벤트 기반 자동화를 처리하며, **여러 액션을 단일 서버 호출(single server call)로 실행**한다.

- **엔드유저 UI가 없다.** OmniScript와 달리 화면이 없고 **서버에서 실행**되며 **동기(synchronous) 또는 비동기(asynchronous)** 로 동작한다.
- 메타데이터 상으로 **OmniProcess 객체**에 저장된다 — OmniScript와 객체를 공유한다(명명 규칙·sObject 매핑은 [[OmniStudio 개요·오리엔테이션]] 참조).
- 하나의 IP가 **여러 소스에서 데이터를 조회 → 변환 → 단일 페이로드로 반환**할 수 있다. 자주 접근하는 데이터(전체 IP 응답 또는 개별 스텝 응답)를 캐시해 성능을 높인다.
- Salesforce·외부 시스템에서 데이터를 읽고 쓰며, REST API 호출과 Apex 코드 호출이 가능하다.

**사용 시점** — 실행 중 사용자 상호작용이 필요 없고 다음을 원할 때:

- Salesforce ↔ 외부 시스템 간 데이터 조회·변환·전송
- 처리를 서버로 offload 해 성능·확장성 개선
- 여러 작업을 단일 서버 트랜잭션으로 묶기(bundle)
- 자주 접근하는 정보의 데이터 캐싱 활성화

**호출 가능한 주체:** OmniScript · FlexCard · 다른 Integration Procedure · REST API · Salesforce Flow · Apex 메서드 · Scheduled Job(batch).

### building block

IP의 가장 중요한 구성 요소는 **actions(액션)** 와 **blocks(블록)** 이다.

- **Actions** — 데이터 읽기, HTTP 요청, 이메일 발송 등 **작업을 수행**한다.
- **Blocks** — 액션을 그룹화해 **동작을 함께 구성**한다(조건 실행·캐싱·리스트 반복·에러 처리).

이 외에 **variables(변수)** 로 IP 내부에서 데이터를 저장·조작하고, **Data Mapper**로 시스템·포맷 간 데이터를 변환한다.

> OmniScript ↔ 그것이 호출하는 IP의 관계는 공식 문서에 다이어그램으로 제공된다 — 본 wiki에는 텍스트 설명만 담는다.

### 빌드·활성화 워크플로우

App Launcher에서 **Integration Procedures 앱**을 열고 New로 생성한다.

1. IP를 고유 식별하려면 **Name, Type, Subtype**을 입력하고 저장해야 이후 작업이 가능하다.
2. Preview 창에서 입력 파라미터를 추가하고 **Execute**로 실행 → 응답 출력·디버그 로그·실행 시퀀스·에러 등을 확인해 디버깅·리파인.
3. 기대대로 동작하면 **activate**해 배포한다. 개발을 이어가며 새 버전을 저장해 이전 버전을 보존할 수 있다. **한 번에 한 버전만 active** 가능하며, 한 버전을 activate 하면 나머지 모든 버전이 비활성화된다.
4. **Export/Import** — 데이터 팩으로 다른 org(예: 샌드박스 → 프로덕션)로 옮긴다. Apex heap/CPU 한도 에러가 나면 export 시 의존성 선택을 해제해 데이터 팩 크기를 줄이거나, 여러 개의 작은 팩으로 분할한다. **모범 사례: 데이터 팩당 요소 10개 이하** 권장.

Procedure Configuration(Properties 탭)에서 IP 전체를 제어한다 — 응답 JSON에 반환할 데이터 정의, 실행에 필요한 권한(Required Permission) 설정, 성능 커스텀 데이터 추적, 트랜잭션 분할(governor limit 회피), 캐싱, Test Procedure 구성 등.

---

## IP vs OmniScript

두 도구는 OmniProcess 객체를 공유하고 공통 기능을 갖지만, IP만의 기능이 있다.

**공통점** — 둘 다 OmniStudio Data Mapper · Integration Procedure · REST 엔드포인트 · Apex 메서드를 호출할 수 있고, 이메일·DocuSign 봉투를 보내며, 함수·변수로 데이터를 조작한다.

**IP가 추가하는 것 (OmniScript에는 없음):**

| IP 전용 기능 | 설명 |
|---|---|
| 엔드유저 UI 없음 · 서버 실행 · sync/async | OmniScript와 근본적으로 다른 실행 모델 |
| Caching | 성능을 위해 IP의 일부 또는 전체를 캐시 |
| Unit testing | IP가 호출하는 엔티티를 단위 테스트(Test Procedure) |
| Chainable / queueable chainable | governor limit 회피용 설정 |
| Complex list processing and merging | 복잡한 리스트 처리·병합 |
| Invocation from Apex · REST · Flow · Scheduled Jobs | Apex/REST/Flow/스케줄 잡에서 호출 |

---

## Blocks (4종 전수)

블록은 관련된 스텝 그룹을 **단위(unit)로 실행** — 조건 실행·캐싱·리스트 반복·실패 시 에러 반환. 모든 블록은 공통 프로퍼티 **Execution Conditional Formula**를 가진다: 이 수식이 true거나 정의되지 않으면 블록이 실행되고, false면 건너뛴다.

**Nesting** — 블록은 다른 블록 안에 중첩할 수 있다. 예: Loop Block을 Try-Catch Block 또는 Cache Block 안에 중첩.

| 블록 | 역할 |
|---|---|
| **Cache Block** | 내부 액션을 성능을 위해 캐시한다. 일부 액션이 데이터를 업데이트해 캐시하면 안 되거나, 캐시 데이터의 만료 시점이 서로 달라야 할 때 사용한다. |
| **Conditional Block (If-Else)** | 루프·리스트 병합 없이 formula 뒤에 액션·블록을 그룹화한다. 유일한 역할은 IP 흐름 제어 — 표현식이 true면 전체를 실행하거나, 내부 스텝에 정의된 **상호 배타적(mutually exclusive) 조건** 중 하나를 실행하거나, 둘 다 한다. |
| **Loop Block** | 데이터 배열의 각 항목을 반복 — 내부 액션을 **리스트의 각 항목마다 1회** 실행한다. Loop List 파라미터에 리스트 이름을 넣으면 각 반복이 배열의 한 항목만 받는다. |
| **Try-Catch Block** | 내부 스텝을 "try"로 실행하고, 스텝이 실패하면 그 에러를 "catch"한다. 내부 액션 중 하나가 에러를 유발해도 에러가 처리되고 **IP는 계속 실행된다.** |

> ⚠️ **Include All Actions in Response** 설정을 켜면 IP의 어떤 Loop Block도 레코드 배열을 처리할 수 없다. `stepResultFinal` 배열 크기가 1을 초과해 `Cannot Write Array to Root` 에러가 발생하기 때문이다.

---

## Actions (카탈로그 전수)

액션은 순차적으로 실행되며, Action elements 패널에서 캔버스로 드래그하거나 커넥터(+)로 추가한다. 데이터 값 설정·함수 수행·Data Mapper 호출·Apex 호출·이메일 발송·REST 호출·다른 IP 실행 등을 한다.

### 모든 액션 공통 프로퍼티

| 프로퍼티 | 설명 |
|---|---|
| **Element Name** | 요소(노드) 이름 |
| **Send JSON Path** | 액션 실행 전, 들어오는 JSON을 지정 경로로 트림 |
| **Send JSON Node** | 들어오는 JSON을 지정 노드 아래로 reparent |
| **Response JSON Path** | 액션 실행 후, 출력 JSON을 지정 경로로 트림 |
| **Response JSON Node** | 출력 JSON을 지정 노드 아래로 reparent. 경로 구분자는 콜론 — 예: `level1:level2:level3` |
| **Send Only Additional Input** | 체크 시 Additional Input 프로퍼티의 데이터만 받음 |
| **Additional Input** | 입력 JSON에 포함할 추가 key-value. 값에 formula·merge field 사용 가능 |
| **Return only additional output** | Additional Output의 데이터만 반환 |
| **Additional Output** | 출력 JSON에 반환할 추가 key-value. 값에 formula·merge field 사용 가능 |
| **Send Only Failure Response** | 액션 실패 시 실패 응답만 반환 |
| **Failure Response** | 액션 실패 시 출력 JSON에 반환할 key-value. formula·merge field 사용 가능 |
| **Execution Conditional Formula** | 스텝 실행 전 실행되는 formula. TRUE면 스텝 실행, FALSE면 미실행, 미지정이면 실행 |
| **Failure Conditional Formula** | 스텝 실행 후 실행되는 커스텀 실패 조건. 예: Data Mapper Extract Action이 레코드를 못 찾은 것은 보통 에러가 아니지만, 이 formula로 실패 조건을 지정할 수 있다. TRUE 반환 시 스텝 실패로 간주되고 Failure Response의 key-value가 JSON에 추가됨 |
| **Terminate when step fails** / **Fail on Step Error** (managed package designer) | 이 스텝이 실패하면 IP 종료 |
| **Chain On Step** | 액션을 자체 Salesforce 트랜잭션에서 실행. 성능은 느려지지만 governor limit 초과 가능성 감소 |
| **Additional Chainable Response** | 응답에 보낼 key-value 지정. value는 merge field 구문 허용 |

**Failure Conditional Formula 예시** — 다음 JSON이 반환될 때:

```json
{
  "Result": {
    "ErrorCode": "ERR-123",
    "Success": "FALSE"
  }
}
```

에러를 식별해 에러 코드를 JSON에 추가하는 설정:

- Failure Conditional Formula: `Result:Success == 'FALSE'`
- Failure Response: Key `ErrorCode`, Value `%StepName:Result:ErrorCode%`

### 액션 카탈로그

| 액션 | 용도 |
|---|---|
| **Assert Action** | Test Procedure의 기대 결과를 선언 — 표현식(true/false)으로 기대값과 실제값 비교. Assert Conditional Formula에 환경 변수를 써 성능 테스트 가능 |
| **Batch Action** | Scheduled Job을 실행 |
| **Chatter Action** | Chatter 포스트를 생성해 Chatter 피드에 전송 |
| **Decision Matrix Action** | 지정 입력으로 Decision Matrix를 호출하고 결과를 IP에 반환 |
| **Delete Action** | 하나 이상의 sObject 레코드를 삭제. Object의 Record Id로 삭제 대상 결정 — Path to Id 필드에 data JSON의 Id(또는 Id 리스트)를 참조하는 merge field 사용 권장 |
| **DocuSign Envelope Action** | 서명받을 문서 세트를 이메일로 발송 |
| **Email Action** | 지정 이메일을 발송. 모든 이메일 필드 값을 지정하거나 Salesforce 이메일 템플릿 사용 |
| **Expression Set Action** | 지정 Expression Set을 호출하고 결과를 IP에 반환 |
| **HTTP Action** | REST 호출을 실행하고 결과를 IP에 반환 (아래 상세 참조) |
| **Integration Procedure Action** | 하위(subordinate) IP를 실행 |
| **Intelligence Action** | OmniStudio의 Intelligence Machine에 입력을 제공하고 실행 |
| **List Action** | 지정 리스트 항목 JSON 노드의 값을 매칭해 여러 리스트를 병합. 기본 병합은 노드 이름을 정확히 매칭, 고급 병합은 이름이 다르거나 레벨이 다른 노드를 매칭 |
| **Data Mapper Extract Action** | Data Mapper Extract를 호출해 Salesforce에서 데이터를 읽어 IP에 반환 |
| **Data Mapper Post Action** | Data Mapper Load(post)를 호출해 Salesforce에 데이터 기록 |
| **Data Mapper Transform Action** | Data Mapper Transform을 호출해 Data JSON에 변환을 실행하고 변환 데이터 반환 |
| **Data Mapper Turbo Action** | Data Mapper Turbo Extract를 호출해 Salesforce에서 데이터를 읽어 IP에 반환 |
| **Remote Action** | 지정 Apex 클래스·메서드 또는 invocable action을 호출 (아래 상세 참조) |
| **Response Action** | IP를 종료하고 호출 엔티티에 데이터 반환. data JSON에 데이터 추가나 조건부 종료도 가능. IP 디버깅에 유용 |
| **Set Values Action** | 리터럴 값·merge field·formula로 IP의 data JSON에 값 설정 |

> Data Mapper(Extract/Post/Transform/Turbo) 액션의 Data Mapper 자체 동작·구성은 형제 노트 Data Mapper (DataRaptor)에 위임한다 — 여기서는 IP 액션으로서의 호출 용도만 다룬다.

**IP 전용 액션(OmniScript에 없음):** Assert · Batch · Chatter · List · Response.

**Response Action 활용** — IP 끝에서 Response Action으로 데이터를 트림해 필요한 것만 반환한다. 서로 다른 Execution Conditional Formula를 가진 **여러 Response Action**을 두면 조건에 따라 IP를 조기 종료(exit early)할 수 있다. 각 액션 결과를 Data JSON 루트에 기록하려면 **Include All Actions in Response**를 선택한다.

---

## Remote Action 상세

Remote Action은 지정 Apex 클래스·메서드 또는 invocable action을 호출한다.

| 프로퍼티 | 설명 |
|---|---|
| **Remote Class** | Callable 클래스, 또는 Invocable Action이면 `DefaultInvocableAction`. **OmniStudio Standard에서는 "Apex class can't be loaded" 에러 방지를 위해 namespace를 포함**한다: `omnistudio.ClassName` |
| **Remote Method** | 메서드명 또는 Invocable Action 이름 |
| **Remote Options** | 추가 클래스 invocation 옵션. 아래는 사전 정의된 옵션이며 클래스별 옵션도 전달 가능 |
| **Additional Input** | 메서드 또는 Invocable Action에 전달되는 데이터 |

**Remote Options (사전 정의):**

- **InvocableInputKey** — JSON map을 Invocable Action 입력으로 지정
- **reserialize** — true면 클래스 출력을 reserialize. remote action이 `Map<String, Object>` 형식이 아닌 데이터를 반환하면 IP나 DataRaptor가 reserialize 없이는 처리하지 못하는 경우가 있다. 반환 데이터가 sObject가 아니면 reserialize 없이는 Product2 객체 업데이트에 사용할 수 없다.
- **useStandardRuntime** — true면 Setup의 Omnistudio Settings에서 Managed Package Runtime이 활성화돼 있어도 Apex 클래스를 **OmniStudio standard runtime**에서 강제 실행한다.

```apex
// 구조 예시 — 실제 동작 코드 아님. Remote Action 프로퍼티 값 형태 참고용
// Remote Class:  omnistudio.MyApexClass      (Standard에서 namespace 필수)
// Remote Method: getAccountData
// Remote Options: { "useStandardRuntime": true, "reserialize": true }
```

---

## HTTP Action 상세

HTTP Action은 REST 호출을 실행하고 결과를 IP에 반환한다. **응답 반환에는 `getBody()`만 지원**한다 — 바이너리 응답을 처리하려면 Remote Action을 통해 Apex를 직접 사용한다.

| 프로퍼티 | 설명 |
|---|---|
| **Request URL** (managed package: HTTP Path) | 호출할 URL. Apex REST 액션은 merge field로 설정 가능. URL에 퍼센트 기호를 전달하려면 Path의 `%`를 변수 `$Vlocity.Percent`로 대체 |
| **HTTP Method** | GET, POST, PUT, PATCH, DELETE |
| **Named Credential** | 엔드포인트에 필요한 Salesforce named credential. 인증 데이터를 안전하게 관리하려면 Named Credentials 사용 권장. Summer '24부터 OmniStudio가 **Salesforce Private Connect** 지원 — AWS에서 실행되는 외부 서비스로의 아웃바운드 HTTP 호출에 named credential 사용 가능 |
| **REST Options: Header** | key-value로 지정하는 HTML 헤더 설정. 보안상 민감 데이터를 하드코딩하지 말 것. character set 변경·기본 content-type 관련 세부 예시는 공식 문서 참조 |
| **REST Options: Params** | key-value로 지정하는 URL 파라미터 |
| **Request Body** (managed package: Send Body) | POST 액션이 Body 내용을 보내도록 활성화 |
| **Timeout** | 응답 대기 시간(밀리초) |
| **Client Certificate Name** | 2-factor 인증용 클라이언트 인증서 이름 |
| **Debug Logging: Pre-Action Log / Post-Action Log** | Preview 탭 Debug Output 창에 액션 시도 전/후 추가할 정보. PropertySetMap 값과 merge field 로깅 가능 — Pre-Action: `%endpoint%`, `%body%` / Post-Action: `%stepName + 'Info'%`, `%stepName + 'Info:Content-Type'%` |
| **Retry Count** | 액션 실패 시 재시도 횟수 |
| **Escape XML Response** | XML 응답에서 XML escape 제거 |

Debug 로깅 merge field 예:

```
%stepName + 'Status'%
```

> content-type 키/기본값(character set 변경) 예시는 안전 필터로 캡처되지 않았다 — 정확한 key/value는 공식 문서 참조.

---

## 호출 방법 (전수)

IP는 OmniScript·Cards 같은 다른 OmniStudio 도구, 그리고 Apex 클래스·batch job·REST API·Salesforce Flow에서 호출할 수 있다.

### Apex에서 호출

**Summer '25**부터 `IntegrationProcedureService` Apex 클래스의 IP 호출에 **Connect API**를 사용한다:

```
ConnectAPI.OmniDesignerConnect.integrationProcedureExecute(ipName, apexInput)
```

이 Connect API는 managed package 의존성을 제거하고, 기존 방식 대비 Apex 클래스에서의 IP 호출을 **최대 21% 빠르게** 만든다.

> ⚠️ 성능 수치는 내부 검증·테스트 기준의 참고 정보이며 컴포넌트 설계·프로덕션 환경 등에 따라 달라질 수 있다(성능 보장 아님).

**전제 조건(Prerequisites)** — Connect API를 IP 호출에 사용하기 전에 **Omnistudio Settings 페이지에서 Enhanced Runtime Performance를 활성화**해야 한다. 비활성화 시 요청이 Connect API로 라우팅되지 않는다.

Connect API는 여러 호출 변형을 제공한다 — 데이터 반환, Sharing Rules·Custom Permissions를 무시하고 데이터 반환(IP를 private 보장), 데이터 반환 없이 호출, 옵션과 함께 호출 등.

> 이 페이지의 Apex 코드 샘플(Connect API vs 기존 메서드 비교표, 예: `omnistudio.IntegrationProcedureService.runIntegrationService(...)`)은 안전 필터로 차단되어 dump에 캡처되지 않았다 — **예시 코드는 공식 문서 참조**. 날조하지 않는다.

**Apex 단위 테스트** — Apex 테스트 클래스로 IP를 호출·테스트할 수 있다. 단 **core runtime에서는 HTTP mocking이 불가**하며 테스트 실행 중 실제 HTTP 호출이 발생한다.

### REST API에서 호출

REST API로는 **GET 또는 POST**로 IP를 호출해 결과를 받는다. 차이점: **GET은 JSON request body로 데이터를 전달할 수 없다.**

URL 포맷:

```
/services/apexrest/{namespace}/v1/integrationprocedure/{Type}_{SubType}/
```

namespace는 보통 `omnistudio`이며, IP의 Type과 SubType을 지정한다.

**데이터 전달 3가지 방법:**

- URL 경로의 inline 값 (GET or POST)
- URL에 append 하는 query `parameter=value` 쌍 (GET or POST)
- JSON request body 지정 (POST only)

> **주의:** JSON 표기의 중괄호 `{}`는 리터럴(JSON 객체 구분). REST URL 표기의 중괄호는 치환해야 할 변수값을 감싸므로 실제 요청에 포함하지 않는다. REST URL의 모든 부분은 case-sensitive로 취급한다.

`chainable`·`queueableChainable` 같은 IP 옵션도 query 파라미터로 설정할 수 있다:

```
/services/apexrest/vlocity_ins/v1/integrationprocedure/Create_Cases/?queueableChainable=true
```

**GET 예시** — Contact 이름을 query 파라미터로 append (`%20`은 URL 인코딩된 공백):

```
GET URL:
/services/apexrest/vlocity_ins/v1/integrationprocedure/Create_Cases/?Contact=Dennis%20Reynolds
```

```json
Result:
{
  "Case": {
    "Id": "0036100001HDn3QAAT"
  }
}
```

inline 경로값 + query 파라미터 조합:

```
/services/apexrest/{namespace}/v1/integrationprocedure/{Type}_{SubType}/{inlinevalue1}/{inlinevalue2}/?{Param1}={Value1}
```

```
/services/apexrest/vlocity_cmt/v1/integrationprocedure/IP_Rest/Apple/Phones/?product=iPhoneX
```

URL 경로로 전달된 값은 JSON의 `options` 노드 아래 `PathN` 키로 추가된다:

```json
{
  "options": {
    "Path1": "Apple",
    "Path2": "Phones",
    "product": "iPhoneX",
    "isDebug": "true"
  }
}
```

**POST 예시** — Contact 이름을 JSON request body로 지정:

```
POST URL:
/services/apexrest/vlocity_ins/v1/integrationprocedure/Create_Cases/
```

```json
POST JSON data:
{
  "Contact": "Dennis Reynolds"
}
```

```json
Result:
{
  "Case": {
    "Id": "0036100001HDn3QAAT"
  }
}
```

POST도 inline 경로값 + query 파라미터를 지정할 수 있으며, 마찬가지로 경로값은 `options` 노드의 `PathN` 키로 추가된다(위 GET과 동일한 두 번째 예시 구조).

### Salesforce Flow에서 호출

Salesforce Flow에서 IP를 호출하려면 Developer Console에서 **`@InvocableMethod` 애노테이션을 가진 클래스**를 정의해 Flow 컴포넌트를 만든다. `IntegrationProcedureService.runIntegrationService` 호출 시 namespace를 **`omnistudio`, `vlocity_cmt`, `vlocity_ins`, `vlocity_ps` 중 하나**로 교체한다.

```apex
global with sharing class IntegrationProcedureInvocable {
    // 예시 클래스 본문(@InvocableMethod로 IntegrationProcedureService.runIntegrationService 호출)은
    // 안전 필터로 차단되어 dump에 캡처되지 않았다 — 예시 코드는 공식 문서 참조.
}
```

**Flow 컴포넌트 구성:**

- **Unique Name** — 컴포넌트 인스턴스에 서술적 이름 지정
- **Input Settings**
  - **Procedure Name** — 실행할 IP를 `Type_SubType` 형식으로 지정(언더스코어 주의)
  - **Input** — IP가 요구하는 각 입력 변수마다 Variable을 선택하고 `{!variableName}` 형식으로 지정
- **Output Settings** — IP가 반환하는 각 변수마다 Variable을 선택하고 `{!variableName}` 형식으로 지정

### Batch (Scheduled Job)에서 호출

**Vlocity batch framework**로 IP 또는 VlocityOpenInterface를 스케줄로 실행한다. 전형적 사용 사례: 반복 청구 주기, 향후 60일 내 갱신 대상 보험 정책 스캔 등. 잡이 실행되면 입력을 IP(또는 Apex 메서드)에 보내 레코드를 처리한다. IP 내에서는 **Batch Action**으로 Scheduled Job을 실행한다.

---

## Long-Running IP

장시간 실행 IP는 Salesforce governor limit에 걸리는 것을 피하기 위해 다음을 사용한다:

- **chainable / queueable chainable 설정** — governor limit 회피용. Procedure Configuration에서 설정
- **Apex Continuations** — long-running 호출 지원. OmniScript가 long-running IP나 Apex 클래스를 호출하거나, FlexCard가 HTTP Action·Remote Action을 가진 long-running IP를 호출할 때 continuation을 활성화할 수 있다
- **Chain On Step** — 하나 이상의 특정 long-running 스텝에서 체이닝. 액션을 자체 Salesforce 트랜잭션에서 실행

기본적으로 IP의 모든 액션은 **단일 트랜잭션**에서 실행된다. 트랜잭션이 governor limit을 초과하면 Salesforce가 트랜잭션을 종료하고 IP는 실패한다. Salesforce가 부과하는 최대치를 초과하는 한도는 설정할 수 없다.

---

## 에러 처리

각 스텝에서 성공/실패 조건을 구성한다.

- **Failure Conditional Formula** — 스텝이 성공적으로 실행되지 못했으면 TRUE로 평가되는 formula를 지정. ⚠️ 리스트를 반환하는 액션은 Failure Conditional Formula에서 반환 데이터를 사용할 수 없다.
- **Fail On Step Error** — conditional formula가 스텝 실패로 판정하면 IP를 종료하는 옵션
- **Try-Catch Block** — 액션 그룹의 성공/실패 조건과 동작을 구성
- **Response Action** — Data JSON에 디버깅 정보 추가

**에러 로깅** — 실패한 IP 스텝의 상세 정보를 캡처하려면 에러 로깅을 구성한다. OmniStudio는 모든 IP 에러를 **`OmniComponentErrorLog` sObject** 레코드에 기록한다.

**HTTP 액션의 결과** — 호출 결과 상세를 Data JSON의 `ElementNameInfo` 노드에 추가한다: 응답 헤더(예: Content-Type), 응답 상태(Status), 상태 코드(예: 200).

---

## 캐싱

자주 접근하고 드물게 갱신되는 IP 데이터를 캐시하면 DB 왕복을 줄여 성능이 향상된다. **전체 IP 데이터**를 캐시하거나 **Cache Block**으로 일부만 캐시할 수 있다.

두 가지 주요 사용자 구성 캐싱 타입은 **Org Cache**와 **Session Cache**로, IP designer에서 사용 가능하다. 이들은 Salesforce Platform Cache의 일부이며 standard runtime에서 Scale Cache로 구현된다.

**Top-Level 캐싱 구성** — Procedure Configuration에서 **Salesforce Platform Cache Type**과 **Time To Live In Minutes** 프로퍼티를 설정한다.

> ⚠️ top-level 캐싱이 켜진 IP가 실패하면 데이터가 캐시되지 않는다.

**Preview의 캐싱 옵션** (Options JSON 섹션 — top-level 데이터만 제어, metadata 캐시엔 영향 없음):

- **ignoreCache** — 캐시에 데이터를 저장하거나 지우지 않음. **기본값 `true`**. 캐싱 효과의 간섭 없이 IP 스텝을 테스트할 때 사용
- **resetCache** — 데이터를 강제로 캐시에 저장. **기본값 `false`**. 캐싱 자체를 테스트할 때 사용

> 캐싱을 테스트하려면 반드시 `ignoreCache`를 `false`로 설정한다. REST API로 캐싱 IP를 호출할 때 `ignoreCache`·`resetCache`를 파라미터로 전달할 수 있다 — 예: URL에 `?resetCache=true`를 포함해 캐싱 강제.

**Top-Level 캐싱 JSON 노드 및 REST 헤더** — top-level 캐싱이 구성되고 IP가 active면 root 노드 아래에 다음 노드가 포함될 수 있다. REST API로 호출하면 이 노드들이 **헤더로 반환**된다:

| 노드 | 의미 |
|---|---|
| **vlcCacheKey** | 캐시에 저장된 데이터의 키 |
| **vlcCacheResult** | 캐시에서 데이터를 조회했으면 포함되고 `true`로 설정 |
| **vlcCacheEnabled** | `ignoreCache` 설정이 캐싱을 비활성화하면 포함되고 `false`로 설정 |
| **vlcCacheException** | 캐싱 에러 |

**Top-Level 데이터 캐시 지우기** — Developer Console에서 Connect API를 실행한다. **Summer '25부터** `clearSessionCache`, `clearOrgCache`, `clearAllCache` 메서드를 Connect API로 대체한다:

- Session cache 지우기 — `IntegrationProcedureService.clearSessionCache()`를 Connect API로 대체
- vlcCacheKey로 session cache 지우기 — `IntegrationProcedureService.clearSessionCache('vlcCacheKey')`를 `ConnectApi.OmniDesignerConnect.ClearIntegrationProcedureCache(apexInput)`로 대체
- IP의 모든 캐시 데이터(session·org·metadata) 지우기 — `IntegrationProcedureService.clearAllCache('Type_SubType')`를 Connect API로 대체

```apex
// 구조 예시 — 실제 동작 코드 아님. Summer '25 캐시 삭제 Connect API 호출 형태 참고용
ConnectApi.IntegrationProcedureCacheInputRepresentation apexInput =
    new ConnectApi.IntegrationProcedureCacheInputRepresentation();
// ... 입력 필드 설정 (전체 코드는 안전 필터로 차단됨) ...
ConnectApi.OmniDesignerConnect.ClearIntegrationProcedureCache(apexInput);
```

> 위 캐시 삭제 Connect API의 전체 Apex 코드 샘플(`ClearIntegrationProcedureCache` 입력 구성)은 안전 필터로 차단되어 dump에 부분만 캡처됐다 — **정확한 코드는 공식 문서 참조**.

---

## 관련 노트

- [[OmniStudio 개요·오리엔테이션]] — 시리즈 허브·오리엔테이션
- [[OmniScript]] — IP를 호출하는 UI 프로세스
- [[FlexCard]] — IP를 호출하는 카드 컴포넌트
- [[Data Mapper (DataRaptor)]] — IP가 오케스트레이션하는 Data Mapper Extract/Post/Transform/Turbo 액션의 소관
- [[OmniStudio Formula Functions 레퍼런스]] — IP formula/Set Values에서 쓰는 공용 함수
- [[ConnectApi Namespace 개요]] — Summer '25 IP 호출 Connect API(`OmniDesignerConnect.integrationProcedureExecute`)가 속하는 ConnectApi 네임스페이스
