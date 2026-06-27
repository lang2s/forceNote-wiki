---
tags: [agent-skill, sf-skills, platform, apex, code-generation, naming-conventions]
source: forcedotcom/sf-skills (skills/platform-apex-generate/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [platform-apex-generate, Apex 생성 스킬, Apex authoring, Apex 클래스 생성, Apex 리팩터링, Apex code review]
---

# platform-apex-generate — Apex 생성·리팩터링·리뷰 에이전트 스킬

> 프로덕션급 Apex(클래스·셀렉터·서비스·비동기 작업·invocable·트리거)를 생성/리팩터링하고, 기존 `.cls`·`.trigger`를 근거 기반으로 리뷰하는 일차 Apex authoring 스킬.

---

## 목적과 활성화 조건

`metadata.version: 1.0` · `minApiVersion: 66.0`

**ALWAYS ACTIVATE** — 사용자가 Apex, `.cls`, 트리거를 언급하거나, 다음 유형의 클래스 생성/리팩터링을 요청할 때:
service, selector, domain, batch, queueable, schedulable, invocable, DTO, utility, interface, abstract, exception, REST resource.

또한 다음 작업에도 사용: SObject CRUD, 컬렉션 매핑, 관련 레코드 조회, 스케줄 작업, 배치 작업, 트리거 설계, `@AuraEnabled` 컨트롤러, `@RestResource` 엔드포인트, 커스텀 REST API, 기존 Apex 코드 리뷰.

### 필수 입력 (Required Inputs)

작성 전에 수집하거나 추론:
- 클래스 타입 (service / selector / domain / batch / queueable / schedulable / invocable / trigger / trigger action / DTO / utility / interface / abstract / exception / REST resource)
- 대상 객체(들)와 비즈니스 목표
- 클래스명 (아래 네이밍 표로 도출)
- 신규(net-new) vs 리팩터링/수정; org/API 제약
- 배포 대상 (기본값 `runSpecifiedTests`, 생성된 테스트 사용)

명시되지 않으면 기본값:
- Sharing: `with sharing` (타입별 sharing 규칙 참조)
- Access: `public` (`global`은 managed package 또는 `@RestResource`가 요구할 때만)
- API 버전: `66.0` (최소 버전)
- ApexDoc 주석: yes

요청이 명확·완전하면 불필요한 왕복 없이 즉시 생성한다.

---

## 워크플로 (3 Phase / 8 Step)

모든 단계는 순차적. 건너뛰기·병합·재정렬 금지. 막히면 멈추고 누락된 컨텍스트를 묻는다. 해당 없으면 `N/A` + 한 줄 정당화를 리포트에 기록한다.

### Phase 1 — Author

1. **프로젝트 컨벤션 발견** — Service-Selector-Domain 계층화, 로깅 유틸리티, 기존 클래스/트리거와 현재 트리거 프레임워크/핸들러 패턴, Trigger Actions Framework(TAF) 사용 여부
2. **가장 작은 올바른 패턴 선택** (아래 Type-Specific Guidance 참조)
3. **템플릿·에셋 검토** — `assets/`에서 매칭되는 템플릿을 작성 전에 읽는다. 타입별 `references/` 예제가 있으면 스타일 가이드로 읽는다. 모든 테스트 클래스 작업은 항상 `platform-apex-test-generate` 스킬을 읽고 사용한다.
4. **가드레일 적용 작성** — Rules 섹션의 모든 규칙 적용. `{ClassName}.cls`(ApexDoc 포함)와 `{ClassName}.cls-meta.xml` 생성.
5. **테스트 클래스 생성** — `platform-apex-test-generate` 스킬을 로드해 `{ClassName}Test.cls` + `{ClassName}Test.cls-meta.xml` 생성. 배포에는 Apex 테스트가 항상 필수이며, **이 스킬을 로드하지 않고는 어떤 테스트 파일 생성·편집도 불가**.

### Phase 2 — Validate (리포트 전 필수)

파일 작성은 중간 지점이지 종착점이 아니다. Step 6·7은 각각 도구 호출이 필요하고 그 출력이 Step 8 리포트에 나타나야 한다. 두 단계 실행·출력 캡처 전에는 리포트를 요약·제시하지 않는다.

6. **코드 분석기 실행** — 생성/갱신된 모든 `.cls`에 MCP `run_code_analyzer` 호출. `sev0`·`sev1`·`sev2` 위반을 모두 교정하고 clean해질 때까지 재실행. 최종 도구 출력을 verbatim으로 캡처. Fallback: `sf code-analyzer run --target <target>`. 둘 다 불가 시 리포트에 `run_code_analyzer=unavailable: <error>` 기록.
7. **Apex 테스트 실행** — `{ClassName}Test` 포함 org 테스트를 `sf apex run test` 또는 MCP로 실행. 모든 테스트 생성/수정/커버리지 작업은 `platform-apex-test-generate`에 위임하고 통과할 때까지 반복. pass/fail 수와 커버리지 %를 캡처. 불가 시 `test_execution=unavailable: <error>` 기록.

### Phase 3 — Report

8. **리포트** — 파일 하단 출력 형식 사용. `Analyzer` 줄은 실제 Step 6 출력(또는 호출 시도 후 `run_code_analyzer=unavailable: <reason>`)을, `Testing` 줄은 실제 Step 7 결과(또는 `test_execution=unavailable: <reason>`)를 담아야 한다. 둘 중 하나라도 없는 리포트는 불완전. 항상 unavailable 기록 전 도구 호출을 시도한다.

### Meta XML 템플릿 (verbatim)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<ApexClass xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>{API_VERSION}</apiVersion>
    <status>Active</status>
</ApexClass>
```

### 리포트 형식 (verbatim)

```text
Apex work: <summary>
Files: <paths>
Design: <pattern / framework choices>
Workflow: all steps completed (1-8); any N/A justified
Risks: <security, bulkification, async, dependency notes>
Analyzer: <REQUIRED -- paste actual run_code_analyzer output or state "run_code_analyzer=unavailable: <reason>">
Testing: <REQUIRED -- paste actual test execution results (pass/fail, coverage) or state "test_execution=unavailable: <reason>">
Deploy: <dry-run or next step>
```

---

## 핵심 규칙·가드레일

### Hard-Stop 제약 (반드시 강제 — 위반 시 멈추고 설명)

| 제약 | 근거 |
|---|---|
| 모든 SOQL을 루프 밖에 배치 | 쿼리 거버너 한도 회피 (100 쿼리) |
| 모든 DML을 루프 밖에 배치 | DML 거버너 한도 회피 (150 statements) |
| 모든 클래스에 sharing 키워드 선언 | 의도치 않은 `without sharing` 기본값·데이터 노출 방지 |
| 하드코딩 ID 대신 Custom Metadata/Labels/describe 호출 | org 간 이식성 보장 |
| 항상 예외 처리 (로그·rethrow·복구) | silent 실패 방지 |
| 사용자 입력 동적 SOQL에 bind 변수 사용 | SOQL injection 방지 |
| Java 타입이 아닌 Apex 네이티브 컬렉션(`List`/`Map`/`Set`) 사용 | 컴파일 오류 방지 |
| 사용 전 Apex에 메서드 존재 검증 | 존재하지 않는 API 의존 방지 |
| 메인 코드 경로에서 `System.debug()` 회피 | debug 문은 로깅 비활성 시에도 평가되어 CPU 소비. 필요 시 로깅 프레임워크 사용 |
| `@future` 메서드 절대 사용 안 함 | `System.Finalizer` 있는 Queueable 사용. `@future`는 chain 불가·Batch에서 호출 불가·non-primitive 타입 불가 |

### Bulkification & 거버너 한도

- 모든 public API는 컬렉션을 받고 처리; 단일 레코드 오버로드는 bulk 메서드에 위임
- batch/bulk 흐름은 partial-success DML(`Database.update(records, false)`) 선호, `SaveResult`로 오류 처리
- 쿼리 결과의 ID 기반 조회는 `Map<Id, SObject>` 생성자 사용
- 자식 레코드를 부모별로 그룹화할 때 `Map<Id, List<SObject>>`; 처리 전 단일 루프로 맵 구축
- 중복 제거·멤버십 검사는 `Set<Id>`; `List.contains()`보다 `Set.contains()` 선호
- 부모+자식을 모두 필요 시 관계 서브쿼리로 단일 SOQL로 조회
- rollup 계산은 Apex에서 쿼리·카운트하지 말고 `AggregateResult` + `GROUP BY`
- 실제 변경된 레코드만 DML — `Trigger.oldMap`/이전 상태와 비교 후 update 리스트에 추가
- 복잡 트랜잭션에서 `Limits.getQueries()`·`Limits.getDmlStatements()`·`Limits.getCpuTime()`로 소비 모니터링

### SOQL 최적화

- 적절한 `WHERE`로 선택적 쿼리; 가능하면 인덱스 필드(`Id`/`Name`/`OwnerId`/lookup·master-detail/`ExternalId`/커스텀 인덱스) 필터 사용
- `SELECT *`는 SOQL에 없음 — 항상 정확한 필드 명시
- 결과 집합 제한에 `LIMIT`; 결정적 결과에 `ORDER BY`
- Custom Metadata Type(`__mdt`) 조회는 SOQL 금지 — 빌트인 메서드(`{CustomMdt__mdt}.getAll().values()`, `getInstance()` 등) 사용

### Caching

- 자주 접근·드물게 변경되는 데이터는 Platform Cache(`Cache.Org`/`Cache.Session`); TTL 설정 + 항상 cache miss 처리 (캐시는 언제든 evict 가능)
- 같은 실행 컨텍스트 내 중복 쿼리 방지에 `private static Map`을 트랜잭션 스코프 캐시로; 최초 접근 시 lazy-init

### Security

- 기본 `with sharing`; `without sharing`/`inherited sharing`은 정당화 문서화
- CRUD/FLS 강제에 SOQL `WITH USER_MODE`, `Database` DML에 `AccessLevel.USER_MODE`
- 동적 필드/연산자명은 allowlist 또는 `Schema.describe`로 검증
- 모든 외부 자격증명/API 키는 Named Credentials
- `@AuraEnabled` 사용자 대상 오류는 `AuraHandledException` (내부 상세 노출 금지)
- `without sharing`은 Custom Permission 검사 필요
- `without sharing` 로직은 전용 헬퍼 클래스에 격리; `with sharing` 진입점에서 호출해 elevated-access 범위 제한
- PII/민감 데이터는 Platform Encryption으로 at-rest 암호화; debug/오류 메시지/API 응답에 PII 절대 노출 금지

**Security Verification (마무리 전 확인):** CRUD/FLS 강제(SOQL+DML) · 모든 클래스에 명시적 sharing 키워드 · 하드코딩 secret/Record ID 없음 · 로그·오류 메시지에서 PII 제외 · 엔드유저용 오류 메시지 정제.

### Error Handling

- 일반 `Exception` 전에 구체적 예외 catch; 메시지에 컨텍스트 포함
- `try/catch`는 던질 수 있는 코드(DML·callout·JSON 파싱·cast)에만; 단순 할당/컬렉션/산술의 방어적 wrapping 회피
- 예외 cause chain 보존: `new CustomException('message', cause)` (stack trace를 concat 메시지로 대체 금지)
- 의미 있으면 service 도메인별 커스텀 예외 클래스 제공
- `@AuraEnabled` 메서드는 catch 후 `AuraHandledException`으로 rethrow
- Fallback: 의미 있는 도메인 예외가 없으면 generic `Exception` catch 후 rethrow하거나 원본 cause를 보존하는 최소 커스텀 예외로 wrap

### Null Safety

- 모든 public 메서드 상단에 null/empty 입력 guard clause; 컨텍스트별 스타일: private/trigger-handler는 early `return`, public API는 예외 `throw`, 검증 service는 `record.addError()`
- `null` 대신 빈 컬렉션 반환
- chained property 접근은 safe navigation(`?.`)
- 존재 보장 안 되면 `map.get(key)` inline 역참조 금지; `containsKey`·할당+null 검사·safe navigation 먼저
- 기본값에 null coalescing(`??`)
- 수동 검사 대신 `String.isBlank(value)` 선호

### Constants & Literals

- 가능하면 string 상수보다 enum; enum 값은 `UPPER_SNAKE_CASE`
- 반복 literal string/number는 `private static final` 상수 또는 상수 클래스로 추출
- 사용자 대상 문자열은 `Label.` custom label
- 설정 가능한 값(임계값·매핑·feature flag)은 Custom Metadata
- 코드에 HTML-escaped 엔티티(`&#39;`) 출력 금지; Apex string literal은 리터럴 single quote `'` 사용

### Naming Conventions (네이밍 표)

| Type | Pattern | Example |
|---|---|---|
| Service | `{SObject}Service` | `AccountService` |
| Selector | `{SObject}Selector` | `AccountSelector` |
| Domain | `{SObject}Domain` | `OpportunityDomain` |
| Batch | `{Descriptive}Batch` | `AccountDeduplicationBatch` |
| Queueable | `{Descriptive}Queueable` | `ExternalSyncQueueable` |
| Schedulable | `{Descriptive}Schedulable` | `DailyCleanupSchedulable` |
| DTO | `{Descriptive}DTO` | `AccountMergeRequestDTO` |
| Wrapper | `{Descriptive}Wrapper` | `OpportunityLineWrapper` |
| Utility | `{Descriptive}Util` | `StringUtil` |
| Interface | `I{Descriptive}` | `INotificationService` |
| Abstract | `Abstract{Descriptive}` | `AbstractIntegrationService` |
| Exception | `{Descriptive}Exception` | `AccountServiceException` |
| REST Resource | `{SObject}RestResource` | `AccountRestResource` |
| Trigger | `{SObject}Trigger` | `AccountTrigger` |
| Trigger Action | `TA_{SObject}_{Action}` | `TA_Account_SetDefaults` |

추가 네이밍 규칙:
- Classes: `PascalCase`
- Methods: `camelCase`, 동사로 시작(`get`/`create`/`process`/`validate`/`is`/`has`/`can`)
- Variables: `camelCase`, 서술적 명사; List는 복수형(`accounts`, `relatedContacts`); Map은 `{value}By{key}`(`accountsById`); Set은 `{noun}Ids`
- Constants: `UPPER_SNAKE_CASE`
- 약어(`acc`/`tks`/`rec`) 대신 전체 서술명

### ApexDoc

- 클래스 헤더와 모든 `public`/`global` 메서드에 필수
- 포함: 간단 설명, `@param`, `@return`, `@throws`, 유용하면 `@example`

```apex
/**
 * Provides services for geolocation and address conversion.
 */
public with sharing class GeolocationService { }
```

```apex
/**
 * @param paramName Description of the parameter
 * @return Description of the return value
 * @example
 * List<Account> results = AccountService.deduplicateAccounts(accountIds);
 */
```

### Code Structure & Architecture

- 클래스당 단일 책임; 최대 500줄 — 초과 시 분할
- Return Early: 메서드 상단에서 전제조건 검증, 즉시 return/throw
- ~40줄 초과 메서드는 private 헬퍼 추출
- 테스트 용이성 위해 Dependency Injection(생성자/메서드 파라미터)
- 깊은 상속보다 composition·narrow interface; 수정이 아닌 새 구현으로 확장
- 계층 경계에서 메서드당 단일 추상화 수준 강제:

| Layer | Owns | Must NOT contain |
|---|---|---|
| Trigger | 이벤트 라우팅만 | 비즈니스 로직, 오케스트레이션 |
| Handler/Service | 흐름 제어, 조정 | inline SOQL/DML/HTTP/파싱 |
| Domain | 비즈니스 규칙, 검증 | 쿼리, callout, 영속화 상세 |
| Data/Integration | SOQL, DML, HTTP | 비즈니스 결정 |

- 금지: 오케스트레이션과 inline SOQL/DML/HTTP 혼합 메서드; 비즈니스 규칙과 파싱 내부 혼합; 검증+영속화+cross-system plumbing을 한 메서드에

### Async Decision Matrix

| 시나리오 | 기본값 | 핵심 특성 |
|---|---|---|
| 표준 async 작업 | **Queueable** | Job ID, chaining, non-primitive 타입, 설정 가능 지연(`AsyncOptions`로 최대 10분), dedup signature |
| 매우 큰 데이터셋 | **Batch Apex** | chunked 처리, 최대 5 동시; 큰 scope에 `QueryLocator` |
| 모던 배치 대안 | **CursorStep** (`Database.Cursor`) | 2000-record chunk, 높은 throughput, 5-job 한도 없음 |
| 반복 스케줄 | **Scheduled Flow**(선호) 또는 **Schedulable** | Schedulable은 100-job 한도; Batch chaining/복잡 Apex 로직 필요 시에만 |
| 작업 후 정리 | **Finalizer** (`System.Finalizer`) | Queueable 성공/실패 무관 실행 |
| 장시간 callout | **Continuation** | 트랜잭션당 최대 3, 3 parallel |
| 10분 초과 지연 | `System.scheduleBatch()` | 특정 미래 시각에 Batch 작업 스케줄 |
| 레거시 fire-and-forget | `@future` | **새 코드에 사용 금지** — Hard-Stop 참조; Queueable + Finalizer로 대체 |

---

## Type-Specific Guidance (타입별 지침)

### Service
- Template `assets/service.cls` · Reference `references/AccountService.cls`
- `with sharing`; stateless — public 필드/가변 인스턴스 상태 없음; 합당하면 public API를 `static`으로
- 모든 SOQL은 Selector, SObject 동작은 Domain에 위임
- 비즈니스 오류는 커스텀 예외(예 `AccountServiceException`)로 wrap

### Selector
- Template `assets/selector.cls` · Reference `references/AccountSelector.cls`
- `inherited sharing`; SObject 또는 쿼리 도메인당 하나
- `List<SObject>` 또는 `Map<Id, SObject>` 반환; 공유 base 필드 리스트 상수 사용(inline 중복 금지)
- filter 파라미터 수용; 항상 `WITH USER_MODE` 포함

### Domain
- Template `assets/domain.cls`
- `with sharing`; 필드 기본값·파생·검증 캡슐화
- in-memory 리스트만 조작; SOQL/DML 없음(Service/Selector 소관)

### Batch
- Template `assets/batch.cls` · Reference `references/AccountDeduplicationBatch.cls`
- `with sharing`; `Database.Batchable<SObject>` 구현(chunk 간 추적 시 `Database.Stateful` 추가)
- `start()`=쿼리 정의 · `execute()`=비즈니스 로직 · `finish()`=로깅/알림
- 큰 데이터셋에 `QueryLocator`; partial 실패는 `Database.SaveResult`로 처리
- 재사용성 위해 생성자로 filter 파라미터 수용

### Queueable
- Template `assets/queueable.cls`
- `with sharing`; `Queueable` 구현, HTTP callout 필요 시 `Database.AllowsCallouts` 선택 구현
- 생성자로 데이터 수용
- 무한 chain 방지 위해 chain-depth guard 추가
- 복구/정리에 `Finalizer` 선택 구현
- 설정 가능 지연(최대 10분)·dedup signature에 `AsyncOptions`

### Schedulable
- Template `assets/schedulable.cls`
- `with sharing`; `execute()`는 Queueable 또는 Batch에 위임
- CRON 상수와 편의 `scheduleDaily()` 헬퍼 제공

### DTO / Wrapper
- Template `assets/dto.cls`
- sharing 키워드 불필요(순수 데이터 컨테이너)
- 단순 public property; no-arg + 파라미터 생성자; 순서 필요 시 `Comparable`
- 직렬화/역직렬화되는 private/protected inner DTO에 `@JsonAccess`

### Utility
- Template `assets/utility.cls`
- sharing 키워드 불필요; 모든 메서드 `public static`; `private` 생성자
- pure, side-effect 없음; SOQL/DML 없음

### Interface
- Template `assets/interface.cls`
- 각 메서드 시그니처에 ApexDoc로 명확한 계약 정의

### Abstract
- Template `assets/abstract.cls`
- `with sharing`; `virtual` 메서드로 기본 동작 제공
- 확장 지점은 `protected virtual` 또는 `protected abstract`
- ApexDoc에 확장 방법 보이는 구체 예제 포함

### Custom Exception
- Template `assets/exception.cls`
- sharing 키워드 없음; 서술적 이름으로 `Exception` 확장
- 지원 생성자: `()`, `('msg')`, `(cause)`, `('msg', cause)`

### Trigger
- Template `assets/trigger.cls`
- 객체당 트리거 하나; 모든 로직은 handler/TAF action 클래스에 위임
- 모든 관련 DML 컨텍스트 포함; TAF면 `new MetadataTriggerHandler().run();`

### Trigger Action (TAF)
- 컨텍스트별 concern당 클래스 하나; `TriggerAction.{Context}` 구현
- `Trigger_Action__mdt`로 등록(등록 없으면 action 비활성)
- 이름 `TA_{SObject}_{ActionName}`; recursion에는 static boolean보다 field-value 비교 선호

### Invocable Method (`@InvocableMethod`)
- Template `assets/invocable.cls`
- `with sharing`; inner `Request`/`Response`에 `@InvocableVariable`
- 메서드는 `public static` 필수; non-static/single-object 시그니처는 컴파일 안 됨
- `List<Request>` 수용, `List<Response>` 반환; bulkify(SOQL/DML 루프 밖)
- Decorator 파라미터: `label`(필수 — Flow Builder 표시명), `description`, `category`(Builder에서 action 그룹화), `callout=true`(HTTP callout 시 필수)
- `@InvocableVariable` 파라미터: `label`(필수), `description`, `required=true/false`
- `@InvocableVariable` 지원: primitive, `Id`, `SObject`, `List<T>`만(`Map`/`Set`/`Blob` 불가); Flow 컬렉션 I/O에 `List<Id>`·`List<SObject>` 필드 사용
- Response에 항상 `isSuccess`, `errorMessage`, `errorType`(`e.getTypeName()`) 포함
- Response에 오류 반환(권장); 예외 throw는 Flow Fault path 트리거 — 복구 불가 실패에만 사용

### REST Resource (`@RestResource`)
- Template `assets/rest-resource.cls`
- `global with sharing`; 클래스와 메서드 모두 `global`
- 버전 URL: `@RestResource(urlMapping='/{resource}/v1/*')`
- 분기별 적절한 HTTP 상태 코드(`200`/`201`/`400`/`404`/`422`/`500`); 모든 오류를 `500`으로 default 금지
- 입력 검증(Id 형식: `Pattern.matches('[a-zA-Z0-9]{15,18}', value)`); 모든 사용자 입력 SOQL bind
- 쿼리에 `LIMIT`/`ORDER BY`; pagination(`pageSize`/`offset`) 구현
- 표준화된 `ApiResponse` wrapper(`success`/`message`/`data`·`records`); inner request/response DTO
- thin controller: 비즈니스 로직은 Service 클래스에 위임

### `@AuraEnabled` Controller
- `with sharing`; 모든 SOQL에 `WITH USER_MODE`
- 읽기 전용 쿼리에만 `@AuraEnabled(cacheable=true)`; DML 작업은 `cacheable` 미설정
- 예외 catch 후 사용자 친화 메시지로 `AuraHandledException` rethrow

---

## Output Expectations

클래스당 산출물:
- `{ClassName}.cls`
- `{ClassName}.cls-meta.xml` (기본 API 버전 `66.0` 이상)
- `{ClassName}Test.cls` (`platform-apex-test-generate` 스킬로 생성)
- `{ClassName}Test.cls-meta.xml` (동상)

트리거당 산출물:
- `{TriggerName}.trigger`
- `{TriggerName}.trigger-meta.xml` (기본 API 버전 `66.0` 이상)

### Cross-Skill Integration

| 필요 | 위임 대상 |
|---|---|
| Apex 테스트 / 실패 수정 | `platform-apex-test-generate` 스킬 |
| 객체/필드 describe | metadata 스킬(있으면) |
| org 배포 | deploy 스킬(있으면) |
| Flow가 Apex 호출 | Flow 스킬(있으면) |
| LWC가 Apex 호출 | LWC 스킬(있으면) |

### Troubleshooting Boundary

이 스킬은 프로덕션 `.cls`/`.trigger`/`.apex` 이슈만 처리: compile/parse 실패, 배포 의존성 오류, 런타임 거버너 한도 실패. 테스트 실행·assertion·커버리지·`sf apex run test` 실패는 `platform-apex-test-generate`에 위임.

---

## 번들 파일

`assets/` (타입별 템플릿 `.cls`):
abstract · batch · domain · dto · exception · interface · invocable · queueable · rest-resource · schedulable · selector · service · trigger · utility

`references/` (구체 스타일 가이드 예제):
`AccountDeduplicationBatch.cls` · `AccountSelector.cls` · `AccountService.cls`

`CREDITS.md` · `SKILL.md`

---

## 관련 노트
- [[platform-apex-test-generate]]
- [[platform-apex-test-run]]
- [[platform-apex-logs-debug]]
- [[Apex Best Practices]] — Apex 작성 베스트 프랙티스 (위키 패턴 노트)
- [[Apex 언어 기초 — 제어 흐름과 클래스]] — 제어 흐름·클래스 문법 레퍼런스
- [[Apex MOC]] — Apex 위키 섹션 전체 목차
