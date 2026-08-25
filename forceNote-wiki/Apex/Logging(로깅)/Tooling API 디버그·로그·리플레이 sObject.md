---
tags: [apex, logging, debugging, tooling-api, trace-flag, debug-level, apex-log, heap-dump, replay-debugger, execute-anonymous, sobject-reference, v67]
source: api_tooling.pdf — Tooling API Reference and Developer Guide v67.0 Summer '26 (디버그/로그/리플레이 sObject) + 이름 충돌 경계 주석은 Winter27-v68-Docs/api_meta.pdf v68.0 Winter '27 (PREVIEW, 2026-08-21) p.229 · Winter27-v68-Docs/api_tooling.pdf v68.0 Winter '27
created: 2026-06-20
aliases: [Tooling API 디버그 sObject, TraceFlag, DebugLevel, ApexLog, HeapDump, ApexExecutionOverlayAction, ApexExecutionOverlayResult, ExecuteAnonymousResult, executeAnonymous REST, 체크포인트, overlay action, 리플레이 디버거, Replay Debugger, 프로그래밍 방식 로그 활성화, trace flag 만들기, TraceFlag 생성, 디버그 로그 API로 켜기, 힙 덤프, heap dump, DebugLevel 카테고리, LogType, executeAnonymous REST 리소스, Tooling API로 로그 레벨 설정, API로 디버그 로그 활성화하려면]
---

# Tooling API 디버그·로그·리플레이 sObject

> TraceFlag·DebugLevel·ApexLog로 프로그래밍 방식 로그 활성화, Overlay(Action/Result)·HeapDump로 체크포인트 리플레이 디버깅, executeAnonymous REST로 익명 Apex 실행 — Tooling API SOAP/REST 제어.

---

## 개요 — 무엇을 다루나

Tooling API는 개발 도구(Developer Console, VS Code, CLI 등)가 쓰는 SOAP/REST API다. 이 노트는 그중 **디버깅·로깅 제어용 sObject**를 다룬다. 세 영역으로 나뉜다.

| 영역 | 객체 | 용도 |
|---|---|---|
| 로그 활성화 제어 | `TraceFlag` · `DebugLevel` · `ApexLog` | 프로그래밍 방식으로 디버그 로그를 켜고(trace flag), 로그 카테고리 레벨을 정의(debug level)하고, 생성된 로그를 조회(`ApexLog`) |
| 리플레이 디버거 (체크포인트) | `ApexExecutionOverlayAction` · `ApexExecutionOverlayResult` · `HeapDump` | 프로덕션 코드를 건드리지 않고 특정 라인에 진단 출력(overlay)을 덮어 실행하고, 그 결과·힙 덤프를 조회 |
| 익명 Apex 실행 | `/executeAnonymous` (REST) · `executeAnonymous()` (SOAP) / `ExecuteAnonymousResult` | 익명 Apex 코드를 실행 |

- **UI/선언적 디버그 로그**(Developer Console에서 로그 보기, Setup에서 trace flag 켜기, 로그 카테고리·레벨의 의미)는 [[Apex Debug Log]] 참조. 이 노트는 같은 제어를 **API/프로그래밍 방식**으로 다룬다. ⚠️ UI식 카테고리 명칭 ↔ API식 필드 명칭이 다를 수 있으니 주의.
- **익명 Apex의 언어 의미와 SOAP `executeAnonymous()`/`ExecuteAnonymousResult`의 상세 동작**은 [[Anonymous Apex 실행]] 참조. 이 노트는 그 REST 리소스 진입점을 다룬다.
- **Tooling API의 배포 도메인**(`MetadataContainer`·`*Member`·`ContainerAsyncRequest`)은 [[Tooling API 배포]] 참조 — 디버그 vs 배포 경계.

### 객체 관계도

```text
// 구조 예시 — 실제 원본 다이어그램 아님
TraceFlag ──DebugLevelId──▶ DebugLevel ──(8 카테고리 × 8 레벨)──▶ ApexLog
                                                                  (생성된 로그)

ApexExecutionOverlayAction ──▶ ApexExecutionOverlayResult ──┬─ ApexResult
                                                            ├─ SOQLResult
                                                            └─ HeapDump

executeAnonymous (REST 리소스) ◀──▶ executeAnonymous() / ExecuteAnonymousResult (SOAP)
```

---

## 로그 활성화 제어 — TraceFlag · DebugLevel · ApexLog

흐름: `DebugLevel`(카테고리별 레벨 묶음)을 만들고 → `TraceFlag`(누구/무엇을, 언제까지 추적)가 그 debug level을 `DebugLevelId`로 참조 → 추적 대상이 실행되면 `ApexLog` 레코드가 생성된다.

### TraceFlag

> Represents a trace flag that triggers an Apex debug log at the specified logging level.

- **Supported SOAP API Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST API HTTP Methods:** Query, GET, POST, PATCH, DELETE
- **Special Access Rules 섹션 없음** (PDF에서 TraceFlag 직전의 Special Access Rules는 인접 객체 TimeSheetTemplateAssignment의 것).

#### 필드

8개의 로그 카테고리 필드(`ApexCode`·`ApexProfiling`·`Callout`·`Database`·`System`·`Validation`·`Visualforce`·`Workflow`)는 모두 동일한 형태다 — **Type `picklist`, Properties `Create, Filter, Group, Restricted picklist, Sort, Update`, 8개 picklist 값 `NONE · ERROR · WARN · INFO · DEBUG · FINE · FINER · FINEST` 공통**. (각 카테고리의 의미는 [DebugLevel 카테고리 매트릭스](#debuglevel-카테고리--picklist-매트릭스)와 동일.) 아래는 카테고리 외 필드.

| 필드명 | Type | Properties | Description |
|---|---|---|---|
| `ApexCode` | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | Apex code 로그 카테고리 레벨. DML·inline SOQL/SOSL·트리거 시작/완료·테스트 메서드 시작/완료 등의 로그 메시지 포함. 값: NONE·ERROR·WARN·INFO·DEBUG·FINE·FINER·FINEST. **필수.** |
| `ApexProfiling` | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | Profiling 정보 로그 카테고리 레벨(네임스페이스 한도, 발송 이메일 수 등 누적 profiling). 값 8종. **필수.** |
| `Callout` | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | Callout 로그 카테고리 레벨. 외부 웹 서비스와 주고받는 request-response XML 포함(SOAP API 콜 디버깅에 유용). 값 8종. **필수.** |
| `Database` | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | Database 활동 로그 카테고리(모든 DML·inline SOQL/SOSL 쿼리 포함). 값 8종. **필수.** |
| `DebugLevelId` | reference | Create, Filter, Group, Nillable, Sort, Update | 이 trace flag에 할당된 debug level의 ID. log category level 묶음인 debug level은 여러 trace flag에 할당 가능. |
| `ExpirationDate` | dateTime | Create, Filter, Sort, Update | trace flag가 만료되는 일시. **`ExpirationDate`는 `StartDate`로부터 24시간 미만이어야 한다.** 추적 대상(traced entity) 하나당 동시에 활성 trace flag는 1개뿐. `StartDate`가 null이면 현재 시각을 쓰고, `ExpirationDate`는 현재 시각으로부터 24시간 미만이어야 한다. **필수.** |
| `LogType` | picklist | Create, Filter, Group, Restricted picklist, Sort | 생성할 로그 유형. 값: `CLASS_TRACING`·`DEVELOPER_LOG`·`PROFILING`(reserved for future use)·`USER_DEBUG`. Developer Console을 열면 활동 로깅을 위해 `DEVELOPER_LOG` trace flag를 설정한다. `USER_DEBUG`는 개별 사용자 활동을 로깅. `CLASS_TRACING`은 Apex 클래스/트리거의 로깅 레벨을 override하지만 로그를 생성하지는 않는다. **필수.** |
| `ScopeId` | reference | Create, Filter, Group, Nillable, Sort, Update | **Deprecated. API version 34.0 이하에서만 사용 가능.** user 참조이며 `TracedEntityID` 필드와 함께 사용. 값이 *user*일 때 해당 user/entity 활동을 system log에 기록(본인만 열람, class-level 필터링용). user와 entity-level 플래그가 둘 다 있으면 entity trace flag가 있는 클래스의 메서드 진입 전까지 user 플래그 우선, 메서드 반환 시 user trace flag 복원. 값이 *emptyid*일 때 user 활동을 org debug log에 기록(모든 관리자 열람) — `TracedEntityID`가 user를 참조할 때만 가능. `emptyid`는 `0000000000000000` 또는 null. 여기 정의된 scope는 `ApexLog`의 `Location` 필드에 반영된다. |
| `StartDate` | dateTime | Create, Filter, Group, Nillable, Sort, Update | trace flag가 효력을 시작하는 일시. `ExpirationDate`는 `StartDate`로부터 24시간 미만이어야 한다. traced entity 하나당 동시 활성 1개. `StartDate`가 null이면 `ExpirationDate`는 현재로부터 24시간 미만. |
| `System` | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | 모든 system 메서드(예: `System.debug`) 호출 로그 카테고리 레벨. 값 8종. **필수.** |
| `TracedEntityId` | reference | Create, Filter, Group, Sort, Update | Apex class·Apex trigger·User 참조. `LogType` 필드와 함께 사용. **필수.** |
| `Validation` | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | Validation rule 로그 카테고리 레벨(규칙 이름, true/false 평가 여부 등). 값 8종. **필수.** |
| `Visualforce` | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | Visualforce 로그 카테고리 레벨(view state 직렬화/역직렬화, 수식 필드 평가 등). 값 8종. **필수.** |
| `Workflow` | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | Workflow rule 로그 카테고리 레벨(규칙 이름, 수행된 action 등). **필수.** 값 8종. |

#### Usage

기능적 이슈나 성능 문제를 진단하려면 `TraceFlag`로 자신 또는 다른 사용자에 대한 로깅을 설정한다.
- 특정 사용자 로깅: `LogType`을 `USER_DEBUG`, `TracedEntityId`를 user ID로. (Apex class/trigger가 아니라 user에만 설정 가능.)
- Apex class/trigger의 로깅 레벨 override: `LogType`을 `CLASS_TRACING`, `TracedEntityId`를 class/trigger ID로. `CLASS_TRACING` trace flag는 다른 로깅 레벨을 override하지만 로그를 생성·persist하지 않는다.

> CLI로 TraceFlag 레코드를 만드는 운영 예제는 [[DX 데이터 작업]] 참조.

### DebugLevel

> Represents a set of log category levels to assign to a TraceFlag object. Multiple trace flags can use a debug level.

- **Supported SOAP API Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST API HTTP Methods:** Query, GET, POST, PATCH, DELETE

> [!warning] 같은 이름, 다른 API — `DebugLevel`은 두 곳에 있다
> **Winter '27(API 68.0)부터 `DebugLevel`이라는 이름의 Metadata API 타입이 별도로 생겼다.** 이 절이 다루는 것은 **Tooling API sObject**(질의·DML 대상 레코드)이고, 새 것은 **배포 가능한 선언적 메타데이터 타입**이다. 이름만 같고 서로 다른 API의 서로 다른 아티팩트이므로 혼동하지 말 것.
>
> | 구분 | Tooling API `DebugLevel` (이 노트) | Metadata API `DebugLevel` (v68.0 신규) |
> |---|---|---|
> | 성격 | SOQL 질의·DML 대상 **sObject** | 배포 가능한 **메타데이터 타입** |
> | 형태 | org 내 레코드 (`Id`로 참조) | `debugLevels/*.debugLevel` XML 파일 |
> | 사용처 | `TraceFlag.DebugLevelId`로 런타임 로그 활성화 | `package.xml` retrieve/deploy, 소스 추적 |
> | 로그 카테고리 필드 | 아래 매트릭스 8개 (**v67.0 기준**) | 11개 — `apexCode`·`apexProfiling`·`callout`·`database`·`dataAccess`·`nba`·`system`·`validation`·`visualforce`·`wave`·`workflow` |
>
> Metadata API 쪽 필드 표는 [[Metadata Types — Apex & Code]]가 정본이다. **두 API의 필드 집합이 같다고 가정하지 말 것** — 이름은 같아도 배포 단위와 참조 방식이 다르다.
>
> 📌 **이 노트의 카테고리 매트릭스는 `api_tooling.pdf` v67.0 기준이다.** v68.0(Winter '27) Tooling 가이드에서는 이 sObject에도 `dataAccess`·`nba`·`Wave` 필드가 추가돼 총 11개가 됐다 — 아래 8개 매트릭스는 **v68에 대해 불완전**하다. v68 Tooling 반영은 별도 작업 대상.

#### DebugLevel 카테고리 — picklist 매트릭스

8개 카테고리 필드(`ApexCode`·`ApexProfiling`·`Callout`·`Database`·`System`·`Validation`·`Visualforce`·`Workflow`)는 모두 **Type `picklist`, Properties `Create, Filter, Group, Restricted picklist, Sort, Update`, picklist 값 8종 공통**, 그리고 모두 **필수**다. picklist 8값(낮음→높음):

```text
NONE · ERROR · WARN · INFO · DEBUG · FINE · FINER · FINEST
```

각 카테고리의 의미:

| 카테고리 필드 | 의미 (Description) |
|---|---|
| `ApexCode` | Apex code 로그 카테고리. DML·inline SOQL/SOSL·트리거 시작/완료·테스트 메서드 시작/완료 등의 로그 메시지 포함. |
| `ApexProfiling` | Profiling 정보 로그 카테고리. 네임스페이스 한도, 발송 이메일 수 등 누적 profiling 정보 포함. |
| `Callout` | Callout 로그 카테고리. 외부 웹 서비스와 주고받는 request-response XML 포함(SOAP API 콜 디버깅에 유용). |
| `Database` | Database 활동 로그 카테고리. 모든 DML·inline SOQL/SOSL 쿼리 등 DB 활동 정보 포함. |
| `System` | 모든 system 메서드(예: `System.debug`) 호출 로그 카테고리. |
| `Validation` | Validation rule 로그 카테고리. 규칙 이름, true/false 평가 여부 등 포함. |
| `Visualforce` | Visualforce 로그 카테고리. view state 직렬화/역직렬화, Visualforce 페이지의 수식 필드 평가 등 포함. |
| `Workflow` | Workflow rule 로그 카테고리. 규칙 이름, 수행된 action 등 포함. |

#### DebugLevel 그 외 필드

| 필드명 | Type | Properties | Description |
|---|---|---|---|
| `DeveloperName` | string | Filter, Group, Sort | debug level의 개발자 내부 이름. Developer Console 및 Setup에도 표시. **View DeveloperName 또는 View Setup and Configuration 권한이 있는 사용자만** 이 필드를 보기·group·sort·filter할 수 있다. |
| `Language` | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | `MasterLabel`의 언어. (값 18종 — 아래.) |
| `MasterLabel` | string | Filter, Group, Sort | Reserved for future use. 그러나 이 필드는 필수이며 값이 있어야 한다. `DeveloperName`과 동일한 값을 쓰기를 권장. |

`Language` picklist 유효 값 18종 (전수):

| 언어 | 코드 | 비고 |
|---|---|---|
| Chinese (Simplified) | `zh_CN` | |
| Chinese (Traditional) | `zh_TW` | |
| Danish | `da` | |
| Dutch | `nl_NL` | |
| English | `en_US` | |
| Finnish | `fi` | |
| French | `fr` | |
| German | `de` | |
| Italian | `it` | |
| Japanese | `ja` | |
| Korean | `ko` | |
| Norwegian | `no` | |
| Portuguese (Brazil) | `pt_BR` | |
| Russian | `ru` | |
| Spanish | `es` | |
| Spanish (Mexico) | `es_MX` | Spanish (Mexico)는 customer-defined translation의 경우 Spanish로 기본 적용됨 |
| Swedish | `sv` | |
| Thai | `th` | Salesforce UI는 Thai로 완전 번역되나 Help은 영어 |

#### Usage

> debug level을 삭제하면, 그것을 사용하는 모든 trace flag가 함께 삭제된다.

### ApexLog

> Represents a debug log. raw 로그를 ID로 조회하려면 REST 리소스 `/sobjects/ApexLog/id/Body/`를 쓴다. (API version 28.0 이상.)

- **Supported SOAP Calls:** `delete()`, `describeSObjects()`, `query()`, `retrieve()`
- **Supported REST HTTP Methods:** Query, GET, DELETE
- **Special Access Rules 섹션 없음** (PDF에서 ApexLog 직후 객체 ApexOrgWideCoverage의 "API 49.0+ View Setup and Configuration 권한" 규칙을 ApexLog에 붙이지 않는다).

#### 필드

| 필드명 | Type | Properties | Description |
|---|---|---|---|
| `Application` | textarea | Filter, Group, Sort | 로그/힙 덤프를 트리거한 client type에 따라 달라짐. API client는 client ID, browser client는 `Browser`. **필수.** |
| `DurationMilliseconds` | int | Filter, Group, Sort | 트랜잭션 지속 시간(밀리초). **필수.** |
| `Location` | picklist | Filter, Group, Sort, Nillable, Restricted picklist | 로그/힙 덤프 origin 위치. 값: `Monitoring`—debug log monitoring으로 생성, 모든 관리자에게 표시, 7일 또는 사용자 삭제 시까지 유지 / `SystemLog`—system log monitoring으로 생성, 본인만 표시, 24시간 또는 사용자 clear 시까지 유지. |
| `LogLength` | int | Filter, Group, Sort | 로그/힙 덤프 길이(bytes). **필수.** |
| `LogUserId` | reference | Filter, Group, Sort, Nillable | debug log/힙 덤프를 트리거한 actions의 user ID. |
| `Operation` | string | Filter, Group, Sort | debug log/힙 덤프를 트리거한 operation 이름(예: APEXSOAP, Apex Sharing Recalculation 등). **필수.** |
| `Request` | string | Filter, Group, Sort | request 유형. 값: `API`—API에서 온 요청 / `Application`—Salesforce UI에서 온 요청. **필수.** |
| `RequestIdentifier` | string | Filter, Group, Sort | debug log를 트리거한 request의 고유 식별자. 동일 request가 트리거한 여러 debug log를 상관(correlate)하는 데 사용. |
| `StartTime` | dateTime | Filter, Sort | 트랜잭션 시작 시각. **필수.** |
| `Status` | string | Filter, Group, Sort | 트랜잭션 상태. `Success` 또는 unhandled Apex 예외의 텍스트. **필수.** |

---

## 리플레이 디버거 — ApexExecutionOverlayAction · OverlayResult · HeapDump

흐름: `ApexExecutionOverlayAction`(특정 라인에 Apex/SOQL을 덮어 실행하고 선택적으로 힙 덤프 생성)을 만들고 → 실행 결과를 `ApexExecutionOverlayResult`로 조회 → 그 안에 `ApexResult`·`SOQLResult`·`HeapDump` 복합 타입이 담긴다.

### ApexExecutionOverlayAction

> Specifies an Apex code snippet or SOQL query to execute at a specific line of code in an Apex class or trigger. Optionally, generates a heap dump.

- **Supported SOAP Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST HTTP Methods:** Query, GET, POST, PATCH, DELETE

#### 필드

| 필드명 | Type | Properties | Description |
|---|---|---|---|
| `ActionScript` | string | Create, Nillable, Update | Apex class/trigger의 지정 iteration에서 해당 라인에 도달했을 때 실행할 Apex 코드 또는 SOQL 쿼리. 결과는 heap dump 파일에 포함된다. |
| `ActionScriptType` | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | `ActionScript`가 Apex인지 SOQL인지 표시. 값: `None`·`Apex`·`SOQL`. 값이 없거나 빈 문자열이면 기본값 `None` 사용. |
| `ExecutableEntityId` | reference | Create, Filter, Group, Sort | 실행 대상 Apex class/trigger의 ID. `ExecutableEntityName`이 없으면 필수. 둘 다 제공되면 `ExecutableEntityId`가 우선. |
| `ExecutableEntityName` | reference | Create, Filter, Group, Nillable, Sort | 실행 대상 class/trigger의 Apex typeRef. type lookup을 수행해 typeRef가 유효하면 `ExecutableEntityId`가 그 ID로 설정됨. 트리거는 typeRef가 SFDC trigger prefix `__sfdc_trigger/`로 시작해야 함(예: `__sfdc_trigger/YourTriggerName` 또는 `__sfdc_trigger/YourNamespace/YourTriggerName`). 클래스는 `YourClass`·`YourClass$YourInnerClass`·`YourNamespace/YourClass$YourInnerClass` 형식. `ExecutableEntityId`가 없으면 필수. 둘 다 제공되면 `ExecutableEntityId`가 우선. |
| `ExpirationDate` | dateTime | Create, Filter, Sort, Update | overlay action의 만료일. 값이 없으면 기본값은 현재로부터 30분 후. |
| `IsDumpingHeap` | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | heap dump를 생성(true)할지 아닐지(false). 힙 덤프 없이 `ActionScript`만 실행하려면 false. 값이 없으면 기본값 true. |
| `Iteration` | int | Create, Filter, Group, Sort, Update | heap dump 생성 전 "the number of times to execute the specified line execute before the heap dump is generated" [sic — 원문 문법 오류 그대로]. **필수.** |
| `Line` | int | Create, Filter, Group, Sort, Update | heap dump marker의 라인 번호. **필수.** |
| `ScopeId` | reference | Create, Filter, Group, Sort | action을 실행한 user. 값이 없으면 `ScopeId`는 본인의 `UserId` 값으로 설정됨. |

#### Usage

> 런타임 이슈를 트러블슈팅할 때, `ApexExecutionOverlayAction`으로 프로덕션 코드를 손상시키지 않고 Apex class/trigger에 진단 출력을 overlay한다. 결과로 나온 `ApexExecutionOverlayResult`로 변수·DB 상태를 알아보거나 특정 조건으로 코드를 테스트한다.

### ApexExecutionOverlayResult

> Represents the result from the Apex code snippet or SOQL query defined in the associated ApexExecutionOverlayAction, and the resulting heap dump if one was returned. Available from API version 28.0 or later.

- **Supported SOAP Calls:** `query()`, `retrieve()`, `delete()`
- **Supported REST HTTP Methods:** Query, GET, DELETE

#### 필드

| 필드명 | Type | Properties | Description |
|---|---|---|---|
| `ActionScript` | string | Nillable | 실행된 Apex 코드 또는 SOQL 쿼리. |
| `ActionScriptType` | picklist | Filter, Group, Sort, Nillable | `ActionScript`가 Apex인지 SOQL인지. 값: `None`·`Apex`·`SOQL`. |
| `ApexResult` | ApexResult | Nillable | `ApexExecutionOverlayAction`의 일부로 실행된 Apex 코드 결과를 나타내는 복합 타입. (아래 복합 타입 참조.) |
| `ExpirationDate` | dateTime | Filter, Sort | overlay action의 만료일. |
| `HeapDump` | HeapDump | Nillable | `ApexExecutionOverlayResult` 객체의 heap dump를 나타내는 복합 타입. SOQL에서 `HeapDump` 사용 시 single row만 가능 — `LIMIT=1` 절을 쓰거나 여러 row를 나열해 사용자가 검사할 row를 선택하게 한다. |
| `IsDumpingHeap` | boolean | Defaulted on create, Filter, Group, Sort | heap dump가 생성됐는지(true) 아닌지(false). |
| `Iteration` | int | Create, Filter, Group, Sort, Update | heap dump 생성 전 지정 라인이 실행돼야 하는 횟수. **필수.** |
| `Line` | int | Filter, Group, Sort, Nillable | checkpoint의 라인 번호. |
| `SOQLResult` | SOQLResult | Nillable | `ApexExecutionOverlayResult` 객체의 SOQL 쿼리 결과를 나타내는 복합 타입. (아래 복합 타입 참조.) |
| `UserId` | reference | Filter, Group, Sort, | action을 실행한 user. (Properties 끝에 콤마 — 원문 그대로 [sic]) |

#### 복합 타입 — ApexResult · SOQLResult

**ApexResult** — `ApexExecutionOverlayAction`의 일부로 실행된 Apex 코드 결과. API version 28.0 이상.

| 필드 | Type | Description |
|---|---|---|
| `apexError` | string | 실행 실패 시 반환되는 error 텍스트. |
| `apexExecutionResult` | `ExecuteAnonymousResult` | 성공한 실행에서 반환되는 구조화된 결과. `ExecuteAnonymousResult`는 다음 필드를 포함: `column`·`compileProblem`·`compiled`·`exceptionMessage`·`exceptionStackTrace`·`line`·`success`. ([executeAnonymous 섹션](#executeanonymous--soap--executeanonymousresult) 참조.) |

**SOQLResult** — `ApexExecutionOverlayResult` 객체의 SOQL 쿼리 결과. API version 28.0 이상.

| 필드 | Type | Description |
|---|---|---|
| `queryError` | string | 실행 실패 시 반환되는 error 텍스트. |
| `queryMetadata` | `QueryResultMetadata` | 성공한 실행에서 반환되는 구조화된 결과. `QueryResultMetadata`는 다음 필드를 포함: `columnMetadata`·`entityName`·`groupBy`·`idSelected`·`keyPrefix`. |
| `queryResult` | array of `MapValue` | `MapValue`는 `MapEntry` 배열을 포함하고, `MapEntry`는 다음 필드를 포함: `keyDisplayValue`·`value`(reference to `StateValue`). |

### HeapDump

> A complex type that represents a heap dump in an ApexExecutionOverlayResult object. Available from API version 28.0 or later.

> ⚠️ PDF 상에서 HeapDump 헤딩 직전의 "Usage"(payment record `ProcessorId`/payment gateway `ExternalReferenceId` 등)는 인접 객체의 잔여 텍스트이며 HeapDump와 무관하다 — HeapDump 본문은 두 번째 `HeapDump` 헤딩부터다.

`HeapDump`는 sObject가 아니라 복합 타입이라 Supported Calls/REST Methods 섹션이 없고 Fields만 있다.

#### 최상위 필드

| 필드 | Type | Description |
|---|---|---|
| `className` | string | Apex class 또는 trigger의 이름. |
| `extents` | array of `TypeExtent` | `TypeExtent`는 다음 필드를 포함: `collectionType`·`count`·`definition`(array of `AttributeDefinition`)·`extent`(array of `HeapAddress`)·`totalSize`·`typeName`. |
| `heapDumpDate` | dateTime | heap dump가 캡처된 일시. |
| `namespace` | string | Apex class/trigger의 namespace. namespace가 없으면 null. |

**Usage:** heap dump를 사용해 구조화된 디버깅 정보를 캡처한다.

> ⚠️ **중첩 타입은 PDF에 독립 정의 없음(타입명만 노출).** `extents` 필드의 `TypeExtent`, 그리고 그 하위 `definition`의 `AttributeDefinition`·`extent`의 `HeapAddress`는 위 `extents` Description의 불릿으로만 나열돼 있고, `TypeExtent`·`AttributeDefinition`·`HeapAddress`의 독립 필드 정의표는 이 PDF에 존재하지 않는다. 따라서 이들 하위 타입의 필드는 본 위키에 채워 넣지 않는다(추측 금지).

---

## executeAnonymous — REST 리소스 & SOAP

### executeAnonymous REST 리소스

REST 리소스 `/executeAnonymous/?anonymousBody=<url encoded body>` — Apex 코드를 익명으로 실행.

- **Supported methods:** GET
- API version 29.0 이상.
- ⚠️ **Salesforce는 managed package의 컴포넌트에서 오는 모든 `/executeanonymous` 요청을 차단한다.** (Release Update: "Block Execute Anonymous from Managed Packages" 참조.)
- base URI: `https://domain/services/data/vXX.X/tooling/` (`domain`은 org의 My Domain login URL, `vXX.X`는 API 버전).

PDF 발췌 — Execute Anonymous Apex 요청 예제(Apex callout에서 GET):

```apex
// PDF "REST Resource Examples > Execute Anonymous Apex" 발췌
req.setEndpoint('https://MyDomainName.my.salesforce.com/services/data/v67.0/tooling/executeAnonymous/?anonymousBody=System.debug('Test')%3B');
req.setMethod('GET');
```

### executeAnonymous — SOAP & ExecuteAnonymousResult

SOAP `executeAnonymous()` 콜은 `ExecuteAnonymousResult`를 반환한다. `ExecuteAnonymousResult`의 7개 필드:

| 필드 | 의미 |
|---|---|
| `column` | (컴파일 문제의) 컬럼 위치 |
| `compileProblem` | 컴파일 문제 텍스트 |
| `compiled` | 컴파일 성공 여부 |
| `exceptionMessage` | 런타임 예외 메시지 |
| `exceptionStackTrace` | 런타임 예외 스택 트레이스 |
| `line` | (컴파일 문제의) 라인 위치 |
| `success` | 실행 성공 여부 |

PDF 발췌 — SOAP Java 클라이언트에서 `executeAnonymous` Apex 메서드로 코드를 전달하는 샘플:

```java
// PDF SOAP API 샘플 발췌
import com.sforce.soap.apex.ExecuteAnonymousResult;
ExecuteAnonymousResult result = connection.executeAnonymous(apexCode);
```

> 📌 **Note (PDF):** `ExecuteAnonymousResult`는 *현재 execution context 밖(outside the current execution context)*에 있으며 heap의 변수에 접근할 수 없다.

> 익명 Apex의 언어 의미와 `executeAnonymous()`/`ExecuteAnonymousResult`의 상세 동작은 [[Anonymous Apex 실행]] 참조 — 이 노트는 그 REST 리소스 진입점을 다룬다.

---

## 관련 노트
- [[Apex Debug Log]] — UI/선언적 디버그 로그(로그 카테고리·레벨·Developer Console). 이 노트는 같은 제어의 **API/프로그래밍 방식**. ⚠️ UI식 카테고리 명칭 ↔ API식 명칭 차이 주의
- [[Anonymous Apex 실행]] — executeAnonymous의 언어 의미·SOAP executeAnonymous()/ExecuteAnonymousResult (이 노트는 REST 리소스)
- [[Tooling API 배포]] — 같은 Tooling API의 배포 도메인(MetadataContainer·*Member). 디버그 vs 배포 경계
- [[Tooling API — 개요·REST·SOAP 호출 기초]] — Tooling API 패밀리 개요/허브(REST 12·SOAP 16·executeAnonymous·Composite·EOL). 이 노트 sObject들의 REST/SOAP 호출 표면 진입점
- [[Tooling API 객체 — Apex 코드·테스트·커버리지]] — 같은 Tooling API의 Apex 코드·테스트·커버리지 도메인. `ApexResult`/`ExecuteAnonymousResult` 복합 타입은 이 노트가 정의하며 디버그 오버레이가 소비, `ApexTestResult.ApexLogId` → `ApexLog` 연계
- [[DX 데이터 작업]] — Salesforce CLI로 TraceFlag 레코드 생성 운영 예제
- [[Log 싱글턴 패턴]] — Apex 로깅 프레임워크(같은 Logging 폴더 형제)
- [[platform-apex-logs-debug]] (sf-skill — 실행형) — TraceFlag·DebugLevel·ApexLog 기반 로그 디버깅 실행형 스킬
- [[Metadata Types — Apex & Code]] — **동명** `DebugLevel`의 **Metadata API 타입**(v68.0 신규, `debugLevels/*.debugLevel`). 이 노트의 Tooling sObject와 이름만 같고 별개 — 위 경계 표 참조
- [[Winter '27/Development]] — Metadata API `DebugLevel` 신규 타입을 포함한 v68.0 변경 릴리즈 노트 원문
