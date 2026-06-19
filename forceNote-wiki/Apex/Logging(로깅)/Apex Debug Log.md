---
tags: [apex, debug-log, debugging, trace-flag, log-category, log-level, event-type, developer-console, 디버깅]
source: salesforce_apex_developer_guide.pdf (Summer '26, v67.0) — Debugging Apex / Debug Log (print p.678–719)
created: 2026-06-19
aliases: [Debug Log, Apex Debug Log, Apex 디버깅, Apex 디버그, 디버깅, 디버그 로그 안 보일 때, 로그 레벨 설정, 로그 안 나올 때, Trace Flag, Log Category, Log Level, Event Type, USER_DEBUG, System.debug, DebuggingHeader, Debug Log Order of Precedence, Debug Log Limits, 디버그 로그, 로그 카테고리, 로그 레벨, 로그 필터 설정]
---

# Apex Debug Log

> Debug log는 트랜잭션 실행 또는 unit test 동안 DB 작업·시스템 프로세스·에러를 기록한다. 로그 카테고리·레벨로 출력 verbosity를 조정하고, event type별로 어떤 정보가 어떤 레벨에서 로깅되는지가 정해진다.

---

## 개요

Apex는 Developer Console과 debug log를 통한 디버깅을 지원한다. Debug log는 트랜잭션 실행 또는 unit test 시 DB 작업·시스템 프로세스·에러를 기록한다.

debug log에 포함되는 정보:

- Database changes
- HTTP callouts
- Apex errors
- Resources used by Apex
- Automated workflow processes(Workflow rules, Assignment rules, Approval processes, Validation rules)

> [!note]
> debug log는 time-based workflow가 발생시킨 액션 정보를 포함하지 않으며, Visualforce 이메일 템플릿의 표준/custom 컨트롤러 정보도 포함하지 않는다.

특정 사용자·클래스·트리거의 debug log를 retain·관리할 수 있다. class·trigger trace flag 설정은 로그 생성/저장을 유발하지 않는다(다른 logging level을 override하나 logging 자체를 유발하지 않는다). 조회: Setup → Debug Logs → View / Download.

> 예외(Exception)의 throw·catch·custom exception·unhandled exception 이메일 등 Apex 예외 처리 메커니즘은 이 노트의 범위 밖이다 — [[Apex 언어 기초 — 예외 처리와 예약어]] 참조.

> ★ **DX 노트와의 경계:** trace flag를 CLI로 설정하거나 로그를 조회하는 운영 절차는 [[DX 개발 워크플로]]를 참조한다. 본 노트는 개념·레퍼런스(섹션 해부·Event Type 매트릭스·우선순위·DebuggingHeader)를 다룬다. 또한 로그 카테고리 명칭이 출처에 따라 다르게 표기된다는 점에 주의한다 — [[DX 개발 워크플로]]는 CLI식 명칭(APEX_CODE·WAVE 등)을 쓰고, 이 노트는 Developer Console UI / Database Access·NBA 가이드식 명칭을 쓴다(같은 카테고리의 다른 표기).

### Debug Log 한도 (수치 전수)

- 각 debug log는 **20 MB 이하**다. 20 MB를 초과하면 older log line(이전 System.debug 등)을 제거해 크기를 줄인다(시작 부분뿐 아니라 어느 위치에서든 제거될 수 있다).
- **System debug logs는 24시간 보존된다. Monitoring debug logs는 7일 보존된다.**
- **15분 윈도우에 1,000 MB를 초과해 생성하면 trace flags가 비활성화된다**(마지막 수정 사용자에게 15분 후 재활성화 가능하다는 이메일이 발송된다).
- org이 **1,000 MB를 초과해 누적하면 trace flags 추가/편집이 방지된다**(일부 debug log를 삭제해야 재생성 가능하다).

> [!warning]
> 자주 접근되는 Apex 클래스나 자주 요청하는 사용자에게 trace flag를 활성화하면, 시간 윈도우·debug log 크기와 무관하게 요청이 실패할 수 있다.

---

## Debug Log 섹션 해부 (Inspecting the Debug Log Sections)

filter 값에 따라 정보의 유형·양은 다르지만 포맷은 항상 동일하다.

> [!note]
> Apex debug log에서 Session ID는 "SESSION_ID_REMOVED"로 대체된다.

### Header

API 버전 + log category·level. 예:

```
67.0
APEX_CODE,DEBUG;APEX_PROFILING,INFO;CALLOUT,INFO;DB,INFO;SYSTEM,DEBUG;VALIDATION,INFO;VISUALFORCE,INFO;WORKFLOW,INFO
```

이 예제는 API 67.0이며 카테고리·레벨이 Apex Code=DEBUG, Apex Profiling=INFO, Callout=INFO, Database=INFO, System=DEBUG, Validation=INFO, Visualforce=INFO, Workflow=INFO이다.

> [!warning]
> Apex Code log level이 FINEST면 debug log에 모든 Apex 변수 할당 상세가 포함된다 — traced 코드가 민감 데이터를 처리하지 않는지 확인해야 한다(예: community user self-registration에서 password가 Apex string 변수에 할당될 수 있다).

### Execution Units

트랜잭션과 동등하다. 트랜잭션 내 모든 것을 포함하며 `EXECUTION_STARTED`·`EXECUTION_FINISHED`로 구분된다.

### Code Units

트랜잭션 내 discrete unit이다(트리거 하나 = code unit 하나, webservice 메서드·validation rule도 마찬가지). 클래스는 discrete code unit이 아니다. `CODE_UNIT_STARTED`·`CODE_UNIT_FINISHED`로 구분되며 중첩될 수 있다.

```
EXECUTION_STARTED
CODE_UNIT_STARTED|[EXTERNAL]execute_anonymous_apex
CODE_UNIT_STARTED|[EXTERNAL]MyTrigger on Account trigger event BeforeInsert for [new]|__sfdc_trigger/MyTrigger
CODE_UNIT_FINISHED <-- The trigger ends
CODE_UNIT_FINISHED <-- The executeAnonymous ends
EXECUTION_FINISHED
```

Code unit에 포함되는 것(전수): Triggers, Workflow invocations·time-based workflow, Validation rules, Approval processes, Apex lead convert, `@future` method invocations, Web service invocations, executeAnonymous calls, Visualforce property access on Apex controllers, Visualforce actions on Apex controllers, batch Apex start·finish 메서드 및 각 execute 메서드 실행, Apex System.Schedule execute 메서드 실행, Incoming email handling.

### Log Lines

code unit 내부에서 실행 코드/규칙을 표시하거나 debug log 메시지를 나타낸다. pipe(`|`)로 구분된 필드로 구성된다.

> p.685의 "Debug Log Line Example" 이미지(스크린샷)는 텍스트로 추출되지 않았다. 아래 timestamp·event identifier 설명이 그 텍스트 등가물이다(이미지 재현하지 않음).

- **timestamp:** 이벤트 발생 시간 + 괄호 값. 시간은 사용자 시간대·`HH:mm:ss.SSS` 형식이다. 괄호 값은 요청 시작 후 경과 나노초다. 경과 시간 값은 Developer Console의 Execution Log view에서 제외된다(Raw Log view에서는 표시된다; Logs 탭 → 로그 우클릭 → Open Raw Log).
- **event identifier:** debug log 항목을 유발한 이벤트(예: SAVEPOINT_RESET, VALIDATION_RULE) + 추가 정보(메서드명, line·character number). line number를 못 찾으면 `[EXTERNAL]`로 표시된다(built-in Apex 클래스·관리 패키지 코드). 일부 이벤트(CODE_UNIT_STARTED, CODE_UNIT_FINISHED, VF_APEX_CALL_START, VF_APEX_CALL_END, CONSTRUCTOR_ENTRY, CONSTRUCTOR_EXIT)는 끝에 pipe + typeRef를 추가한다. 트리거 typeRef는 `__sfdc_trigger/` prefix로 시작한다(예: `__sfdc_trigger/YourTriggerName` 또는 `__sfdc_trigger/YourNamespace/YourTriggerName`). 클래스 typeRef 포맷: `YourClass`, `YourClass$YourInnerClass`, 또는 `YourNamespace/YourClass$YourInnerClass`.

### More Log Data

- Cumulative resource usage는 많은 code unit 끝에 로깅된다(트리거·executeAnonymous·batch Apex 메시지 처리·@future·Apex test·Apex web service·Apex lead convert).
- Cumulative profiling은 트랜잭션 끝에 한 번 로깅된다(DML invocation·expensive query 등).
- Heap usage는 정확히 보고된다(Apex Heap Size error 시 예외 throw; 그 외에는 트랜잭션 중 계산된 최대 heap size; 작은 트랜잭션은 0으로 보고).

### 예시 debug log (원문 그대로)

```
37.0 APEX_CODE,FINEST;APEX_PROFILING,INFO;CALLOUT,INFO;DB,INFO;SYSTEM,DEBUG;
    VALIDATION,INFO;VISUALFORCE,INFO;WORKFLOW,INFO
Execute Anonymous: System.debug('Hello World!');
16:06:58.18 (18043585)|USER_INFO|[EXTERNAL]|005D0000001bYPN|devuser@example.org|
    Pacific Standard Time|GMT-08:00
16:06:58.18 (18348659)|EXECUTION_STARTED
16:06:58.18 (18383790)|CODE_UNIT_STARTED|[EXTERNAL]|execute_anonymous_apex
16:06:58.18 (23822880)|HEAP_ALLOCATE|[72]|Bytes:3
16:06:58.18 (24271272)|HEAP_ALLOCATE|[77]|Bytes:152
16:06:58.18 (24691098)|HEAP_ALLOCATE|[342]|Bytes:408
16:06:58.18 (25306695)|HEAP_ALLOCATE|[355]|Bytes:408
16:06:58.18 (25787912)|HEAP_ALLOCATE|[467]|Bytes:48
16:06:58.18 (26415871)|HEAP_ALLOCATE|[139]|Bytes:6
16:06:58.18 (26979574)|HEAP_ALLOCATE|[EXTERNAL]|Bytes:1
16:06:58.18 (27384663)|STATEMENT_EXECUTE|[1]
16:06:58.18 (27414067)|STATEMENT_EXECUTE|[1]
16:06:58.18 (27458836)|HEAP_ALLOCATE|[1]|Bytes:12
16:06:58.18 (27612700)|HEAP_ALLOCATE|[50]|Bytes:5
16:06:58.18 (27768171)|HEAP_ALLOCATE|[56]|Bytes:5
16:06:58.18 (27877126)|HEAP_ALLOCATE|[64]|Bytes:7
16:06:58.18 (49244886)|USER_DEBUG|[1]|DEBUG|Hello World!
16:06:58.49 (49590539)|CUMULATIVE_LIMIT_USAGE
16:06:58.49 (49590539)|LIMIT_USAGE_FOR_NS|(default)|
  Number of SOQL queries: 0 out of 100
  Number of query rows: 0 out of 50000
  Number of SOSL queries: 0 out of 20
  Number of DML statements: 0 out of 150
  Number of DML rows: 0 out of 10000
  Maximum CPU time: 0 out of 10000
  Maximum heap size: 0 out of 6000000
  Number of callouts: 0 out of 100
  Number of Email Invocations: 0 out of 10
  Number of future calls: 0 out of 50
  Number of queueable jobs added to the queue: 0 out of 50
  Number of Mobile Apex push calls: 0 out of 10

16:06:58.49 (49590539)|CUMULATIVE_LIMIT_USAGE_END

16:06:58.18 (52417923)|CODE_UNIT_FINISHED|execute_anonymous_apex
16:06:58.18 (54114689)|EXECUTION_FINISHED
```

---

## 로그 카테고리·레벨 설정

### Developer Console에서 로그 작업

Developer Console의 Logs 탭에서 debug log를 연다. Log Inspector는 context-sensitive 실행 viewer다.

- **Log category:** 로깅되는 정보의 유형(Apex·workflow rule 등)
- **Log level:** 로깅되는 정보의 양
- **Event type:** log category + log level의 조합(어떤 이벤트가 로깅되는지; 각 이벤트는 line·character number·연관 필드·duration 등 추가 정보를 로깅할 수 있다)

### Setting Debug Log Filters for Apex Classes and Triggers

Apex class·trigger trace flag(= debug log filter)로 클래스별 로그 verbosity를 조정할 수 있다. debug log type은 `CLASS_TRACING`이며, USER_DEBUG·DEVELOPER_LOG trace flag의 debug log level을 override한다.

### Debug Log Categories (전수 — 10종)

> 방향성: 각 debug level은 각 log category에 대한 debug log level을 포함한다. category별 로깅 정보량은 log level에 의존한다.

| Log Category | Description |
|---|---|
| Database | Includes information about database activity, including every data manipulation language (DML) statement or inline SOQL or SOSL query. |
| Database Access | Logs rules and policy information for objects accessed from the UI, which can be used to determine why an object isn't accessible. |
| Workflow | Includes information for workflow rules, flows, and processes, such as the rule name and the actions taken. |
| NBA | Includes information about Einstein Next Best Action activity, including strategy execution details from Strategy Builder. |
| Validation | Includes information about validation rules, such as the name of the rule and whether the rule evaluated true or false. |
| Callout | Includes the request-response XML that the server is sending and receiving from an external web service. Useful when debugging issues related to using Lightning Platform web service API calls or troubleshooting user access to external objects via Salesforce Connect. |
| Apex Code | Includes information about Apex code. Can include information such as log messages generated by DML statements, inline SOQL or SOSL queries, the start and completion of any triggers, and the start and completion of any test method. |
| Apex Profiling | Includes cumulative profiling information, such as the limits for your namespace and the number of emails sent. |
| Visualforce | Includes information about Visualforce events, including serialization and deserialization of the view state or the evaluation of a formula field in a Visualforce page. |
| System | Includes information about calls to all system methods such as the System.debug method. |

### Debug Log Levels (전수 — 8종, 누적적)

각 debug level은 각 log category에 대해 이 log level 중 하나를 포함한다. lowest → highest 순이다. 대부분의 이벤트는 INFO부터 로깅을 시작한다. 레벨은 **누적적**이다(FINE을 선택하면 DEBUG·INFO·WARN·ERROR도 포함된다).

> [!note]
> 모든 category에 모든 level을 사용할 수 있는 것은 아니다 — 하나 이상의 이벤트에 대응하는 level만 사용할 수 있다.

1. NONE
2. ERROR
3. WARN
4. INFO
5. DEBUG
6. FINE
7. FINER
8. FINEST

> [!important]
> 배포 실행 전에 Apex Code log level이 FINEST가 아닌지 확인한다(배포가 지연된다). Developer Console이 열려 있으면 log level이 모든 로그(배포 중 생성되는 로그 포함)에 영향을 준다.

---

## Debug Event Types

event = USER_DEBUG. 포맷 = timestamp | event identifier.

> p.685의 "Debug Log Line Example" 이미지는 텍스트로 추출되지 않았다. 아래 본문이 텍스트 등가물이다.

- **timestamp:** (Header Log Lines와 동일 — 사용자 시간대 `HH:mm:ss.SSS`, 괄호=경과 나노초, Execution Log view 제외 / Raw Log view 표시)
- **event identifier:** 유발 이벤트(SAVEPOINT_RESET, VALIDATION_RULE 등) + 추가 정보. line을 못 찾으면 `[EXTERNAL]`. 일부 이벤트(CODE_UNIT_STARTED, CODE_UNIT_FINISHED, VF_APEX_CALL_START, VF_APEX_CALL_END, CONSTRUCTOR_ENTRY, CONSTRUCTOR_EXIT)는 끝에 pipe + typeRef를 추가한다.

USER_DEBUG event identifier 구성: Event name(`USER_DEBUG`), line number(`[2]`), logging level(`DEBUG`), user-supplied string(`Hello world!`).

> p.685의 "Debug Log Line Code Snippet" 이미지는 텍스트로 추출되지 않았다. 아래 DML_BEGIN 로그라인이 그 텍스트 등가물이며, test가 코드 line 5에 도달할 때 기록된다.

```
15:51:01.071 (55856000)|DML_BEGIN|[5]|Op:Insert|Type:Invoice_Statement__c|Rows:1
```

DML_BEGIN 구성: Event name(`DML_BEGIN`), line number(`[5]`), DML operation type—Insert(`Op:Insert`), Object name(`Type:Invoice_Statement__c`), Number of rows(`Rows:1`).

### Event Type 매트릭스 (전수)

표 방향성(원문 그대로): row = Event Name, col = ① Event Name ② "Fields or Information Logged with Event" ③ "Category Logged" ④ "Level Logged". 매트릭스를 옮기기 전에 PDF가 명시한 unique 값을 먼저 나열한다.

- **unique "Level Logged" 값:** `FINEST` / `INFO and above` / `ERROR and above` / `FINE and above` / `FINER and above` / `DEBUG and above` / `INFO` / `DEBUG` / `WARNING and above` / `FINE` / `FINER` (※ USER_DEBUG는 "DEBUG and above by default" + 사용자 설정 시 그 레벨이라는 조건부 셀)
- **unique "Category Logged" 값:** Apex Code / Callout / Apex Profiling / DB / Data Access / Workflow / NBA / System / Validation / Visualforce

아래는 각 셀을 원문 텍스트 그대로 옮긴 전수 매트릭스다(✅/❌로 압축하지 않음).

| Event Name | Fields or Information Logged with Event | Category | Level |
|---|---|---|---|
| BULK_HEAP_ALLOCATE | Number of bytes allocated | Apex Code | FINEST |
| CALLOUT_REQUEST | Line number and request headers | Callout | INFO and above |
| CALLOUT_REQUEST (External object access via cross-org and OData adapters for Salesforce Connect) | External endpoint and method | Callout | INFO and above |
| CALLOUT_RESPONSE | Line number and response body | Callout | INFO and above |
| CALLOUT_RESPONSE (External object access...Salesforce Connect) | Status and status code | Callout | INFO and above |
| CODE_UNIT_FINISHED | Line number, code unit name (such as `MyTrigger on Account trigger event BeforeInsert for [new]`), and: • For Apex methods, the namespace (if applicable), class name, and method name; for example, `YourNamespace.YourClass.yourMethod()` or `YourClass.yourMethod()` • For Apex triggers, a typeRef; for example, `__sfdc_trigger/YourNamespace.YourTrigger` or `__sfdc_trigger/YourTrigger` | Apex Code | ERROR and above |
| CODE_UNIT_STARTED | Line number, code unit name (such as `MyTrigger on Account trigger event BeforeInsert for [new]`), and: • For Apex methods, the namespace (if applicable), class name, and method name; for example, `YourNamespace.YourClass.yourMethod()` or `YourClass.yourMethod()` • For Apex triggers, a typeRef; for example, `__sfdc_trigger/YourTrigger` | Apex Code | ERROR and above |
| CONSTRUCTOR_ENTRY | Line number, Apex class ID, the string `<init>()` with the types of parameters (if any) between the parentheses, and a typeRef; for example, `YourClass` or `YourClass.YourInnerClass` | Apex Code | FINE and above |
| CONSTRUCTOR_EXIT | Line number, the string `<init>()` with the types of parameters (if any) between the parentheses, and a typeRef; for example, `YourClass` or `YourClass.YourInnerClass` | Apex Code | FINE and above |
| CUMULATIVE_LIMIT_USAGE | None | Apex Profiling | INFO and above |
| CUMULATIVE_LIMIT_USAGE_END | None | Apex Profiling | INFO and above |
| CUMULATIVE_PROFILING | None | Apex Profiling | FINE and above |
| CUMULATIVE_PROFILING_BEGIN | None | Apex Profiling | FINE and above |
| CUMULATIVE_PROFILING_END | None | Apex Profiling | FINE and above |
| CURSOR_CREATE_BEGIN | Line number and SOQL query. This event occurs when you call `Database.getCursor()` or `Database.getPaginationCursor()`. | DB | INFO and above |
| CURSOR_CREATE_END | Line number, query ID, and number of rows in the result set. This event occurs when a cursor or pagination cursor is created. | DB | INFO and above |
| CURSOR_FETCH | Line number, query ID, cursor offset position, and number of rows fetched. This event occurs when you call `Cursor.fetch()`. | DB | INFO and above |
| CURSOR_FETCH_PAGE | Line number, query ID, cursor offset position, and number of rows on the current page. This event occurs when you call `PaginationCursor.fetchPage()`. | DB | INFO and above |
| DATA_ACCESS_EVALUATION | Request and Response for the data access request. Used regardless of the data space or policy being accessed. | Data Access | FINE |
| DML_BEGIN | Line number, operation (such as Insert or Update), record name or type, and number of rows passed into DML operation | DB | INFO and above |
| DML_END | Line number | DB | INFO and above |
| EMAIL_QUEUE | Line number | Apex Code | INFO and above |
| ENTERING_MANAGED_PKG | Package namespace | Apex Code | FINE and above |
| EVENT_SERVICE_PUB_BEGIN | Event Type | Workflow | INFO and above |
| EVENT_SERVICE_PUB_DETAIL | Subscription IDs, ID of the user who published the event, and event message data | Workflow | FINER and above |
| EVENT_SERVICE_PUB_END | Event Type | Workflow | INFO and above |
| EVENT_SERVICE_SUB_BEGIN | Event type and action (subscribe or unsubscribe) | Workflow | INFO and above |
| EVENT_SERVICE_SUB_DETAIL | ID of the subscription, ID of the subscription instance, reference data (such as process API name), ID of the user who activated or deactivated the subscription, and event message data | Workflow | FINER and above |
| EVENT_SERVICE_SUB_END | Event type and action (subscribe or unsubscribe) | Workflow | INFO and above |
| EXCEPTION_THROWN | Line number, exception type, and message | Apex Code | INFO and above |
| EXECUTION_FINISHED | None | Apex Code | ERROR and above |
| EXECUTION_STARTED | None | Apex Code | ERROR and above |
| FATAL_ERROR | Exception type, message, and stack trace | Apex Code | ERROR and above |
| FLOW_ACTIONCALL_DETAIL | Interview ID, element name, action type, action enum or ID, whether the action call succeeded, and error message | Workflow | FINER and above |
| FLOW_ASSIGNMENT_DETAIL | Interview ID, reference, operator, and value | Workflow | FINER and above |
| FLOW_BULK_ELEMENT_BEGIN | Interview ID and element type | Workflow | FINE and above |
| FLOW_BULK_ELEMENT_DETAIL | Interview ID, element type, element name, number of records | Workflow | FINER and above |
| FLOW_BULK_ELEMENT_END | Interview ID, element type, element name, number of records, and execution time | Workflow | FINE and above |
| FLOW_BULK_ELEMENT_LIMIT_USAGE | Incremented usage toward a limit for this bulk element. Each event displays the usage for one of these limits: SOQL queries / SOQL query rows / SOSL queries / DML statements / DML rows / CPU time in ms / Heap size in bytes / Callouts / Email invocations / Future calls / Jobs in queue / Push notifications | Workflow | FINER and above |
| FLOW_BULK_ELEMENT_NOT_SUPPORTED | Operation, element name, and entity name that doesn't support bulk operations | Workflow | INFO and above |
| FLOW_CREATE_INTERVIEW_BEGIN | Organization ID, definition ID, and version ID | Workflow | INFO and above |
| FLOW_CREATE_INTERVIEW_END | Interview ID and flow name | Workflow | INFO and above |
| FLOW_CREATE_INTERVIEW_ERROR | Message, organization ID, definition ID, and version ID | Workflow | ERROR and above |
| FLOW_ELEMENT_BEGIN | Interview ID, element type, and element name | Workflow | FINE and above |
| FLOW_ELEMENT_DEFERRED | Element type and element name | Workflow | FINE and above |
| FLOW_ELEMENT_END | Interview ID, element type, and element name | Workflow | FINE and above |
| FLOW_ELEMENT_ERROR | Message, element type, and element name (flow runtime exception) | Workflow | ERROR and above |
| FLOW_ELEMENT_ERROR | Message, element type, and element name (spark not found) | Workflow | ERROR and above |
| FLOW_ELEMENT_ERROR | Message, element type, and element name (designer exception) | Workflow | ERROR and above |
| FLOW_ELEMENT_ERROR | Message, element type, and element name (designer limit exceeded) | Workflow | ERROR and above |
| FLOW_ELEMENT_ERROR | Message, element type, and element name (designer runtime exception) | Workflow | ERROR and above |
| FLOW_ELEMENT_FAULT | Message, element type, and element name (fault path taken) | Workflow | WARNING and above |
| FLOW_ELEMENT_LIMIT_USAGE | Incremented usage toward a limit for this element. Each event displays the usage for one of these limits: SOQL queries / SOQL query rows / SOSL queries / DML statements / DML rows / CPU time in ms / Heap size in bytes / Callouts / Email invocations / Future calls / Jobs in queue / Push notifications | Workflow | FINER and above |
| FLOW_INTERVIEW_FINISHED_LIMIT_USAGE | Usage toward a limit when the interview finishes. Each event displays the usage for one of these limits: SOQL queries / SOQL query rows / SOSL queries / DML statements / DML rows / CPU time in ms / Heap size in bytes / Callouts / Email invocations / Future calls / Jobs in queue / Push notifications | Workflow | FINER and above |
| FLOW_INTERVIEW_PAUSED | Interview ID, flow name, and why the user paused | Workflow | INFO and above |
| FLOW_INTERVIEW_RESUMED | Interview ID and flow name | Workflow | INFO and above |
| FLOW_LOOP_DETAIL | Interview ID, index, and value. The index is the position in the collection variable for the item that the loop is operating on. | Workflow | FINER and above |
| FLOW_RULE_DETAIL | Interview ID, rule name, and result | Workflow | FINER and above |
| FLOW_START_INTERVIEW_BEGIN | Interview ID and flow name | Workflow | INFO and above |
| FLOW_START_INTERVIEW_END | Interview ID and flow name | Workflow | INFO and above |
| FLOW_START_INTERVIEWS_BEGIN | Requests | Workflow | INFO and above |
| FLOW_START_INTERVIEWS_END | Requests | Workflow | INFO and above |
| FLOW_START_INTERVIEWS_ERROR | Message, interview ID, and flow name | Workflow | ERROR and above |
| FLOW_START_INTERVIEW_LIMIT_USAGE | Usage toward a limit at the interview's start time. Each event displays the usage for one of these limits: SOQL queries / SOQL query rows / SOSL queries / DML statements / DML rows / CPU time in ms / Heap size in bytes / Callouts / Email invocations / Future calls / Jobs in queue / Push notifications | Workflow | FINER and above |
| FLOW_START_SCHEDULED_RECORDS | Message and number of records that the flow runs for | Workflow | INFO and above |
| FLOW_SUBFLOW_DETAIL | Interview ID, name, definition ID, and version ID | Workflow | FINER and above |
| FLOW_VALUE_ASSIGNMENT | Interview ID, key, and value | Workflow | FINER and above |
| FLOW_WAIT_EVENT_RESUMING_DETAIL | Interview ID, element name, event name, and event type | Workflow | FINER and above |
| FLOW_WAIT_EVENT_WAITING_DETAIL | Interview ID, element name, event name, event type, and whether conditions were met | Workflow | FINER and above |
| FLOW_WAIT_RESUMING_DETAIL | Interview ID, element name, and persisted interview ID | Workflow | FINER and above |
| FLOW_WAIT_WAITING_DETAIL | Interview ID, element name, number of events that the element is waiting for, and persisted interview ID | Workflow | FINER and above |
| HEAP_ALLOCATE | Line number and number of bytes | Apex Code | FINER and above |
| HEAP_DEALLOCATE | Line number and number of bytes deallocated | Apex Code | FINER and above |
| IDEAS_QUERY_EXECUTE | Line number | DB | FINEST |
| LIMIT_USAGE_FOR_NS | Namespace and these limits: Number of SOQL queries / Number of query rows / Number of SOSL queries / Number of DML statements / Number of DML rows / Number of code statements / Maximum heap size / Number of callouts / Number of Email Invocations / Number of fields describes / Number of record type describes / Number of child relationships describes / Number of picklist describes / Number of future calls / Number of find similar calls / Number of System.runAs() invocations | Apex Profiling | FINEST |
| METHOD_ENTRY | Line number, the Lightning Platform ID of the class, and method signature (with namespace, if applicable) | Apex Code | FINE and above |
| METHOD_EXIT | Line number, the Lightning Platform ID of the class, and method signature (with namespace, if applicable). For constructors, this information is logged: line number and class name. | Apex Code | FINE and above |
| NAMED_CREDENTIAL_REQUEST | Named Credential Id, Named Credential Name, Endpoint, Method, External Credential Type, Http Header Authorization, Request Size bytes, and Retry on 401. If using an outbound network connection, these fields are also logged: Outbound Network Connection Id, Outbound Network Connection Name, Outbound Network Connection Status, Host Type, Host Region, and Private Connect Outbound Hourly Data Usage Percent. | Callout | INFO and above |
| NAMED_CREDENTIAL_RESPONSE | Truncated section of the response body that's returned from the NamedCredential callout. | Callout | INFO and above |
| NAMED_CREDENTIAL_RESPONSE_DETAIL | Named Credential Id, Named Credential Name, Status Code, Response Size bytes, Overall Callout Time ms, and Connect Time ms. If using an outbound network connection, these fields are also logged: Outbound Network Connection Id, Outbound Network Connection Name, and Private Connect Outbound Hourly Data Usage Percent. | Callout | FINER and above |
| NBA_NODE_BEGIN | Element name, element type | NBA | FINE and above |
| NBA_NODE_DETAIL | Element name, element type, message | NBA | FINE and above |
| NBA_NODE_END | Element name, element type, message | NBA | FINE and above |
| NBA_NODE_ERROR | Element name, element type, error message | NBA | ERROR and above |
| NBA_OFFER_INVALID | Name, ID, reason | NBA | FINE and above |
| NBA_STRATEGY_BEGIN | Strategy name | NBA | FINE and above |
| NBA_STRATEGY_END | Strategy name, count of outputs | NBA | FINE and above |
| NBA_STRATEGY_ERROR | Strategy name, error message | NBA | ERROR and above |
| POLICY_RULE_DEFINITION_CONDITION_EVALUATION_RESPONSE | Condition evaluation response for a policy. Used for identifying conditions that match the policy. | Data Access | FINER |
| POLICY_RULE_EVALUATION_REQUEST | Request received for the evaluation of data access via the policy. | Data Access | FINE |
| POLICY_RULE_EVALUATION_RESPONSE | Response for the evaluation of access via the policy, including why access is granted or denied. | Data Access | FINER |
| POLICY_RULE_EVALUATION_SKIPPED | Object for which the policy evaluation is skipped. If the policy evaluation is skipped, the user is allowed access to the object. | Data Access | FINER |
| POLICY_RULE_EVALUATION_START | Rule being evaluated. | Data Access | FINER |
| POP_TRACE_FLAGS | Line number, the Lightning Platform ID of the class or trigger that has its log levels set and that is going into scope, the name of this class or trigger, and the log level settings that are in effect after leaving this scope | System | INFO and above |
| PUSH_NOTIFICATION_INVALID_APP | App namespace, app name. This event occurs when Apex code is trying to send a notification to an app that doesn't exist in the org, or isn't push-enabled. | Apex Code | ERROR |
| PUSH_NOTIFICATION_INVALID_CERTIFICATE | App namespace, app name. This event indicates that the certificate is invalid. For example, it's expired. | Apex Code | ERROR |
| PUSH_NOTIFICATION_INVALID_NOTIFICATION | App namespace, app name, service type (Apple or Android GCM), user ID, device, payload (substring), payload length. This event occurs when a notification payload is too long. | Apex Code | ERROR |
| PUSH_NOTIFICATION_NO_DEVICES | App namespace, app name. This event occurs when none of the users we're trying to send notifications to have devices registered. | Apex Code | DEBUG |
| PUSH_NOTIFICATION_NOT_ENABLED | This event occurs when push notifications aren't enabled in your org. | Apex Code | INFO |
| PUSH_NOTIFICATION_SENT | App namespace, app name, service type (Apple or Android GCM), user ID, device, payload (substring). This event records that a notification was accepted for sending. We don't guarantee delivery of the notification. | Apex Code | DEBUG |
| PUSH_TRACE_FLAGS | Line number, the Salesforce ID of the class or trigger that has its log levels set and that is going out of scope, the name of this class or trigger, and the log level settings that are in effect after entering this scope | System | INFO and above |
| QUERY_MORE_BEGIN | Line number | DB | INFO and above |
| QUERY_MORE_END | Line number | DB | INFO and above |
| QUERY_MORE_ITERATIONS | Line number and the number of queryMore iterations | DB | INFO and above |
| SAVEPOINT_ROLLBACK | Line number and Savepoint name | DB | INFO and above |
| SAVEPOINT_SET | Line number and Savepoint name | DB | INFO and above |
| SLA_END | Number of cases, load time, processing time, number of case milestones to insert, update, or delete, and new trigger | Workflow | INFO and above |
| SLA_EVAL_MILESTONE | Milestone ID | Workflow | INFO and above |
| SLA_NULL_START_DATE | None | Workflow | INFO and above |
| SLA_PROCESS_CASE | Case ID | Workflow | INFO and above |
| SOQL_EXECUTE_BEGIN | Line number, number of aggregations, and query source | DB | INFO and above |
| SOQL_EXECUTE_END | Line number, number of rows, and duration in milliseconds | DB | INFO and above |
| SOQL_EXECUTE_EXPLAIN | Query Plan details for the executed SOQL query. To get feedback on query performance, see Get Feedback on Query Performance. | DB | FINEST |
| SOSL_EXECUTE_BEGIN | Line number and query source | DB | INFO and above |
| SOSL_EXECUTE_END | Line number, number of rows, and duration in milliseconds | DB | INFO and above |
| STACK_FRAME_VARIABLE_LIST | Frame number and variable list of the form: Variable number \| Value. For example: var1:50 / var2:'Hello World' | Apex Profiling | FINE and above |
| STATEMENT_EXECUTE | Line number | Apex Code | FINER and above |
| STATIC_VARIABLE_LIST | Variable list of the form: Variable number \| Value. For example: var1:50 / var2:'Hello World' | Apex Profiling | FINE and above |
| SYSTEM_CONSTRUCTOR_ENTRY | Line number and the string `<init>()` with the types of parameters, if any, between the parentheses | System | FINE and above |
| SYSTEM_CONSTRUCTOR_EXIT | Line number and the string `<init>()` with the types of parameters, if any, between the parentheses | System | FINE and above |
| SYSTEM_METHOD_ENTRY | Line number and method signature | System | FINE and above |
| SYSTEM_METHOD_EXIT | Line number and method signature | System | FINE and above |
| SYSTEM_MODE_ENTER | Mode name | System | INFO and above |
| SYSTEM_MODE_EXIT | Mode name | System | INFO and above |
| TESTING_LIMITS | None | Apex Profiling | INFO and above |
| TOTAL_EMAIL_RECIPIENTS_QUEUED | Number of emails sent | Apex Profiling | FINE and above |
| USER_DEBUG | Line number, logging level, and user-supplied string | Apex Code | DEBUG and above by default. If the user sets the log level for the System.Debug method, the event is logged at that level instead. |
| USER_INFO | Line number, user ID, username, user timezone, and user timezone in GMT | Apex Code | ERROR and above |
| VALIDATION_ERROR | Error message | Validation | INFO and above |
| VALIDATION_FAIL | None | Validation | INFO and above |
| VALIDATION_FORMULA | Formula source and values | Validation | INFO and above |
| VALIDATION_PASS | None | Validation | INFO and above |
| VALIDATION_RULE | Rule name | Validation | INFO and above |
| VARIABLE_ASSIGNMENT | Line number, variable name (including the variable's namespace, if applicable), a string representation of the variable's value, and the variable's address | Apex Code | FINEST |
| VARIABLE_SCOPE_BEGIN | Line number, variable name (including the variable's namespace, if applicable), type, a value that indicates whether the variable can be referenced, and a value that indicates whether the variable is static | Apex Code | FINEST |
| VARIABLE_SCOPE_END | None | Apex Code | FINEST |
| VF_APEX_CALL_START | Element name, method name, return type, and the typeRef for the Visualforce controller (for example, YourApexClass) | Apex Code | INFO and above |
| VF_APEX_CALL_END | Element name, method name, return type, and the typeRef for the Visualforce controller (for example, YourApexClass) | Apex Code | INFO and above |
| VF_DESERIALIZE_VIEWSTATE_BEGIN | View state ID | Visualforce | INFO and above |
| VF_DESERIALIZE_VIEWSTATE_END | None | Visualforce | INFO and above |
| VF_EVALUATE_FORMULA_BEGIN | View state ID and formula | Visualforce | FINER and above |
| VF_EVALUATE_FORMULA_END | None | Visualforce | FINER and above |
| VF_PAGE_MESSAGE | Message text | Apex Code | INFO and above |
| VF_SERIALIZE_VIEWSTATE_BEGIN | View state ID | Visualforce | INFO and above |
| VF_SERIALIZE_VIEWSTATE_END | None | Visualforce | INFO and above |
| WF_ACTION | Action description | Workflow | INFO and above |
| WF_ACTION_TASK | Task subject, action ID, rule name, rule ID, owner, and due date | Workflow | INFO and above |
| WF_ACTIONS_END | Summary of actions performed | Workflow | INFO and above |
| WF_APPROVAL | Transition type, `EntityName: NameField Id`, and process node name | Workflow | INFO and above |
| WF_APPROVAL_REMOVE | `EntityName: NameField Id` | Workflow | INFO and above |
| WF_APPROVAL_SUBMIT | `EntityName: NameField Id` | Workflow | INFO and above |
| WF_APPROVAL_SUBMITTER | Submitter ID, submitter full name, and error message | Workflow | INFO and above |
| WF_ASSIGN | Owner and assignee template ID | Workflow | INFO and above |
| WF_CRITERIA_BEGIN | `EntityName: NameField Id`, rule name, rule ID, and (if rule respects trigger types) trigger type and recursive count | Workflow | INFO and above |
| WF_CRITERIA_END | Boolean value indicating success (true or false) | Workflow | INFO and above |
| WF_EMAIL_ALERT | Action ID, rule name, and rule ID | Workflow | INFO and above |
| WF_EMAIL_SENT | Email template ID, recipients, and CC emails | Workflow | INFO and above |
| WF_ENQUEUE_ACTIONS | Summary of actions enqueued | Workflow | INFO and above |
| WF_ESCALATION_ACTION | Case ID and escalation date | Workflow | INFO and above |
| WF_ESCALATION_RULE | None | Workflow | INFO and above |
| WF_EVAL_ENTRY_CRITERIA | Process name, email template ID, and Boolean value indicating result (true or false) | Workflow | INFO and above |
| WF_FIELD_UPDATE | `EntityName: NameField Id` and the object or field name | Workflow | INFO and above |
| WF_FLOW_ACTION_BEGIN | ID of flow trigger | Workflow | INFO and above |
| WF_FLOW_ACTION_DETAIL | ID of flow trigger, object type and ID of record whose creation or update caused the workflow rule to fire, name and ID of workflow rule, and the names and values of flow variables | Workflow | FINE and above |
| WF_FLOW_ACTION_END | ID of flow trigger | Workflow | INFO and above |
| WF_FLOW_ACTION_ERROR | ID of flow trigger, ID of flow definition, ID of flow version, and flow error message | Workflow | ERROR and above |
| WF_FLOW_ACTION_ERROR_DETAIL | Detailed flow error message | Workflow | ERROR and above |
| WF_FORMULA | Formula source and values | Workflow | INFO and above |
| WF_HARD_REJECT | None | Workflow | INFO and above |
| WF_NEXT_APPROVER | Owner, next owner type, and field | Workflow | INFO and above |
| WF_NO_PROCESS_FOUND | None | Workflow | INFO and above |
| WF_OUTBOUND_MSG | `EntityName: NameField Id`, action ID, rule name, and rule ID | Workflow | INFO and above |
| WF_PROCESS_FOUND | Process definition ID and process label | Workflow | INFO and above |
| WF_PROCESS_NODE | Process name | Workflow | INFO and above |
| WF_REASSIGN_RECORD | `EntityName: NameField Id` and owner | Workflow | INFO and above |
| WF_RESPONSE_NOTIFY | Notifier name, notifier email, notifier template ID, and reply-to email | Workflow | INFO and above |
| WF_RULE_ENTRY_ORDER | Integer indicating order | Workflow | INFO and above |
| WF_RULE_EVAL_BEGIN | Rule type | Workflow | INFO and above |
| WF_RULE_EVAL_END | None | Workflow | INFO and above |
| WF_RULE_EVAL_VALUE | Value | Workflow | INFO and above |
| WF_RULE_FILTER | Filter criteria | Workflow | INFO and above |
| WF_RULE_INVOCATION | `EntityName: NameField Id` | Workflow | INFO and above |
| WF_RULE_NOT_EVALUATED | None | Workflow | INFO and above |
| WF_SOFT_REJECT | Process name | Workflow | INFO and above |
| WF_SPOOL_ACTION_BEGIN | Node type | Workflow | INFO and above |
| WF_TIME_TRIGGER | `EntityName: NameField Id`, time action, time action container, and evaluation Datetime | Workflow | INFO and above |
| WF_TIME_TRIGGERS_BEGIN | None | Workflow | INFO and above |
| XDS_DETAIL (External object access via cross-org and OData adapters for Salesforce Connect) | For OData adapters, the POST body and the name and evaluated formula for custom HTTP headers | Callout | FINER and above |
| XDS_RESPONSE (External object access...Salesforce Connect) | External data source, external object, request details, number of returned records, and system usage | Callout | INFO and above |
| XDS_RESPONSE_DETAIL (External object access...Salesforce Connect) | Truncated response from the external system, including returned records | Callout | FINER and above |
| XDS_RESPONSE_ERROR (External object access...Salesforce Connect) | Error message | Callout | ERROR and above |

---

## API 디버깅 — DebuggingHeader

Apex를 호출하는 모든 API 호출은 debug facility를 지원한다(System.debug() 포함 실행 상세에 접근). SOAP input header `DebuggingHeader`의 `categories` 필드로 logging granularity를 설정한다.

| Element Name | Type | Description |
|---|---|---|
| category | LogCategory | Specify the type of information returned in the debug log. Valid values are: • Db • Workflow • Validation • Callout • Apex_code • Apex_profiling • Visualforce • System • All |
| level | LogCategoryLevel | Specifies the level of detail returned in the debug log. Valid log levels are (listed from lowest to highest): • NONE • ERROR • WARN • INFO • DEBUG • FINE • FINER • FINEST |

- **LogCategory enum (9 값):** Db, Workflow, Validation, Callout, Apex_code, Apex_profiling, Visualforce, System, All
- **LogCategoryLevel enum (8 값):** NONE, ERROR, WARN, INFO, DEBUG, FINE, FINER, FINEST

### backwards compatibility 지원 log level (전수)

DebuggingHeader는 backwards compatibility를 위해 다음 log level도 지원한다.

| Log Level | Description |
|---|---|
| NONE | Does not include any log messages. |
| DEBUGONLY | Includes lower-level messages, and messages generated by calls to the System.debug method. |
| DB | Includes log messages generated by calls to the System.debug method, and every data manipulation language (DML) statement or inline SOQL or SOSL query. |
| PROFILE | Includes log messages generated by calls to the System.debug method, every DML statement or inline SOQL or SOSL query, and the entrance and exit of every user-defined method. In addition, the end of the debug log contains overall profiling information for the portions of the request that used the most resources. This profiling information is presented in terms of SOQL and SOSL statements, DML operations, and Apex method invocations. These three sections list the locations in the code that consumed the most time, in descending order of total cumulative time. Also listed is the number of times the categories executed. |
| CALLOUT | Includes the request-response XML that the server is sending and receiving from an external web service. Useful when debugging issues related to using Lightning Platform web service API calls or troubleshooting user access to external objects via Salesforce Connect. |
| DETAIL | Includes all messages generated by the PROFILE level and the following: • Variable declaration statements • Start of loop executions • All loop controls, such as break and continue • Thrown exceptions * • Static and class initialization code * • Any changes in the with sharing context |

output header `DebuggingInfo`에 결과 debug log가 포함된다.

---

## Debug Log Order of Precedence (우선순위 — 전수)

1. **Trace flags가 다른 모든 logging 로직을 override한다.** Developer Console은 로드 시 trace flag를 설정한다(만료까지 유효). Developer Console·Setup, 그리고 TraceFlag와 DebugLevel Tooling API 객체로 설정할 수 있다. (Note: class·trigger trace flag 설정은 로그 생성/저장을 유발하지 않는다; 다른 logging level(user trace flag 포함)을 override하나 logging 자체를 유발하지 않는다.)
2. **active trace flag가 없으면 sync·async Apex test는 default logging level로 실행된다:** DB=INFO, APEX_CODE=DEBUG, APEX_PROFILING=INFO, WORKFLOW=INFO, VALIDATION=INFO, CALLOUT=INFO, VISUALFORCE=INFO, SYSTEM=DEBUG.
3. **관련 trace flag가 비활성이고 test가 실행 중이 아니면 API header가 logging level을 설정한다.** debugging header가 없는 API 요청은 transient log를 생성한다(저장되지 않음; 다른 logging rule이 없으면).
4. **entry point가 log level을 설정하면 그 level을 사용한다.** 예를 들어 VF 요청은 log level을 설정하는 debugging 파라미터를 포함할 수 있다.

이 중 어느 것도 적용되지 않으면 로그가 생성·보존되지 않는다.

---

## 관련 노트

- [[Apex 언어 기초 — 예외 처리와 예약어]]
- [[DX 개발 워크플로]]
- [[System Namespace]]
- [[Apex 표준 클래스 레퍼런스]]
- [[Anonymous Apex 실행]]
- [[Governor Limits]]
- [[Log 싱글턴 패턴]]
- [[Logging(로깅)/index]]
- [[Apex MOC]]
