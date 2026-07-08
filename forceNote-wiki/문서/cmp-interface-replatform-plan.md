# CMP_Interface 재플랫폼 설계서 — MCM 회복탄력성 패턴 도입

> **문서 유형: 설계/계획(Design & Plan)** — cmp_interface 프레임워크에 MCM_Dev의 회복탄력성 패턴 3종을 도입하는 재플랫폼 계획.
> 상태: **계획 확정 · 구현 미착수**(배포·코드 변경은 별도 승인 필요). 작성일: 2026-07-08 · [문서 인덱스](index.md)

---

## 1. 배경 (Context)

현재 LGCNS_Dev의 신규 인터페이스 프레임워크 `cmp_interface`(`CMP_Interface__c` + `CMP_InterfaceService` + 추상 베이스 3종 + `cmp_InterfaceLog` LWC 뷰어)는 OOP 구조는 깔끔하나 **회복탄력성(resilience)이 약하다**:

- 자동 재시도가 없다.
- 로그를 콜아웃과 같은 트랜잭션에서 직접 insert한다 → 다중 콜아웃 시 "uncommitted work pending before callout" 위험.
- 타깃 시스템 단위 긴급 차단 수단이 없다.

실제로 `CMP_InterfaceService.cls:349-357`에 원작자가 "플랫폼 이벤트로 로그를 분리할지" 고민한 주석과 `:296-297`에 uncommitted-work TODO가 남아 있다.

참고 프로젝트 **MCM_Dev의 `IF_COMM_*` 프레임워크**는 이 세 가지를 이미 검증된 형태로 갖고 있다. 본 계획은 **MCM의 아키텍처 패턴을 참고해 cmp_interface를 재플랫폼**하되, **CMP 고유의 설정/로그 객체(`CMP_Interface__c`/`CMP_InterfaceLog__c`)는 그대로 유지**한다(MCM의 `IFProgram__c`/`IFProgramLog__c`는 도입하지 않음).

- **도입 대상(확정)**: ① 자동 재시도(**즉시 재시도, 백오프 없음**) · ② 플랫폼이벤트 로깅 분리 · ③ 타깃시스템 토글. + MCM 두 객체에서 참고한 **관측성/설정 필드**(§4-A, §4-E). **팩토리(`CMP_InterfaceFactory`)는 도입하지 않음** — CMP는 인터페이스=서브클래스 모델을 유지(§4-D 결정).
- **범위 제외(현 단계)**: 지속(long) 재시도 큐(`IF_Retry_Queue__c` + 스케줄러) = **장기 재시도(C)**. MCM 설정/로그 객체 자체는 도입하지 않음.
- **전제 제약(CLAUDE.md)**: 운영 org 스냅샷 — 운영 인터페이스(G2B 입찰, DART 재무, SingleX)를 절대 깨지 않는다. 모든 변경은 **가법적·기본 OFF(하위호환)**로 설계해 기존 `CMP_IF_*` 서브클래스가 무수정으로 계속 동작하게 한다. 배포·로컬 수정은 **매번 사용자 승인 필수**.

### 설계 결정 이력 (검토 중 확정)

- **재시도 방식 = 즉시(immediate) 재시도로 확정, 지수 백오프 미도입.** Apex에는 CPU를 태우지 않고 트랜잭션 내에서 대기하는 수단이 없다 — 진짜 지수 백오프는 (a) busy-wait(CPU 소모, 실시간 10s 한도 위험) 또는 (b) 크로스-트랜잭션 재큐잉(= 아래 **C 장기 재시도**, 지연 최소 분 단위) 뿐이다. 따라서 "장기 재시도 없음" 범위에서는 즉시 재시도만 성립한다. → 지연 설정 필드(`RetryBaseDelay__c`/`RetryInterval__c`)와 `calculateBackoffDelay`·busy-wait는 **전부 삭제**. 결과적으로 CPU 소모 ≈ 0, 실시간·async 모두 안전.
- **429/503 주의**: 즉시 재시도는 네트워크 순단·502·504·408엔 잘 듣지만, 429(rate limit)·503(과부하)는 원격 회복 시간이 필요해 즉시 재던지면 같은 코드로 재실패하기 쉽다. → 기본 재시도 대상 코드에서 **429는 제외 권장**(`408,502,503,504`), 503은 유지하되 효과가 제한적임을 인지.
- **C(장기 재시도)는 지금 만들지 않고 seam으로 예약.** A와 C는 실행 모델이 달라(같은 트랜잭션 vs 다음 트랜잭션) 공유 코드가 거의 없고, C는 재시도 상태 객체+재큐잉+스케줄+중복제거+모니터링이 붙는 별도 서브시스템이라 요건 미정 상태에서 선제 구현은 YAGNI·운영 리스크다. 대신 A 구현 시 **확장 seam 3개**(§4-B)를 남겨, 나중에 A 코드를 갈아엎지 않고 C를 옆에 붙일 수 있게 한다.
- **팩토리(`CMP_InterfaceFactory`)는 도입하지 않음(현재·Phase 4 모두).** 인터페이스=서브클래스 + `new ...().execute()` 모델 유지. 시스템별 인증/엔드포인트는 Named Credential이 이미 인터페이스 단위로 처리해 `send()`가 전 시스템에 범용 → MCM식 `targetSystem` 2단계 디스패치가 CMP엔 중복. 타깃 전체 차단은 §4-D 토글로 충분. 상세 근거 §4-D.

## 2. 두 프레임워크 비교 (요약)

| 항목 | cmp_interface (LGCNS, 대상) | IF_COMM_* (MCM, 참고) |
|------|----------------------------|------------------------|
| 설정 객체 | `CMP_Interface__c` | `IFProgram__c` |
| 로그 객체 | `CMP_InterfaceLog__c` (+ LWC 뷰어) | `IFProgramLog__c` (UI 없음) |
| 코어 | `CMP_InterfaceService.send(...)` | `IF_COMM_AbstractCallout` + 팩토리 |
| 베이스 | RealTime/Queueable/Batch 추상 + WebService | AbstractCallout/Queueable/Batch/Inbound |
| **자동 재시도** | 없음 → **즉시 재시도 도입**(백오프는 C로 유보) | `executeWithRetry` 백오프+지터 (408/429/5xx) |
| **로깅 분리** | 직접 DML | `InterfaceLogEvent__e` 플랫폼 이벤트 |
| **타깃 토글** | 없음 | `Callout_Target_System_Active__mdt` |
| 응답 청킹 | `ResponseBody1..5__c` (~650k) | 131072 절단 |
| 성공코드 | 인터페이스별 멀티셀렉트 | 2xx 하드코딩 |

→ **결론**: CMP는 구조·UI·청킹이 우수하고, MCM은 회복탄력성이 우수. CMP를 유지하며 MCM의 3종을 가법적으로 이식한다. 전체 교체는 운영 인터페이스 회귀 위험이 커 채택하지 않는다.

## 3. 코드 기준점 (검증 완료)

| 위치 | 사실 | 변경 관계 |
|------|------|-----------|
| `CMP_InterfaceService.cls:244` | `HttpResponse res = new Http().send(req);` — 유일한 콜아웃 지점 | 여기를 `executeWithRetry(req)`로 교체 |
| `:89-94` | `interfaceDef` 게터의 고정 필드 SELECT (`WHERE Name=:interfaceId AND IsActive__c=TRUE`) | 신규 설정 필드를 SELECT에 추가해야 `send()`에서 읽힘 |
| `:106-117` | `SUCCESS_CODES` — `SuccessfulStatusCode__c`를 `;`로 split | 재시도 성공 판정에 그대로 재사용 |
| `:122` | `NEED_BODY` = `Method__c=='POST'` | 멱등성 게이트로 재사용(GET=멱등, 안전) |
| `:254-260` | 성공/실패 판정(SUCCESS_CODES) 이후 로직 | `executeWithRetry`가 `HttpResponse`를 그대로 반환하므로 **하류 전부 무수정** |
| `:367-371` | `LogCls.execute()` — `manualLogging`이면 버퍼, 아니면 `insert log` | 여기에 PE 발행 분기 추가(기본 OFF) |
| `:349-357`, `:296-297` | PE 로깅/uncommitted-work를 두고 남긴 원작자 TODO | 이 계획이 그 TODO를 해소 |

`send(String, Map, Map, Type)` **공개 시그니처는 불변** → 모든 서브클래스·베이스(`CMP_InterfaceRealTime/Queueable/Batch`, `CMP_InterfaceWebService`) 무영향. (예외: `appendLog` 헬퍼(§4-E-4)를 도입하면 베이스 3종에 위임 1줄 + 플러시 1줄이 **가법적으로** 추가됨 — appendLog 미호출 시 동작 동일)

### 3-1. 검증 결과 (2026-07-08, 로컬 코드 + LGCNS_Dev org 대조)

**확인 완료 (계획과 일치)**
- 라인 앵커 전부 실코드와 일치: `:89-94`(SELECT), `:106-117`(SUCCESS_CODES `;` split), `:122`(NEED_BODY=POST), `:234`(setTimeout 120000 하드코딩), `:244`(유일 콜아웃), `:254`(getStatusCode 판정), `:309`(saveLog), `:349-357`·`:296-297`(원작자 TODO), `:367-371`(LogCls 분기)
- `CMP_InterfaceQueueable` 주장 일치: 생성자 `(interfaceId, responseType)`, `System.Finalizer`(`CMP_QueueableFinalizer`)에서 로그, `IS_SKIP`/`IS_ERROR` 가드, send는 try 안(예외 시 `INF.error`)
- `CMP_InterfaceRealTime.cls:124`의 IS_TEST 시 send 미호출(테스트 함정) 재확인
- 참조 클래스 8종 전부 로컬 존재: 테스트 5종 + `CMP_TestDataFactory` + 파일럿 2종(DART/G2B BidResult)
- **필드 충돌 없음**: 신규 제안 필드(설정 5종, 로그 관측성 필드 전부)가 두 객체의 기존 필드와 미충돌 (로그의 `JobType__c`·`Headers__c`·`EndPoint__c`와 역할 구분됨)
- org의 `CMP_InterfaceService` 본문 = 로컬과 사실상 동일 (차이: 로컬에만 `:221` debug 한 줄 · BOM/개행)

**⚠ 중대 발견 1 — `:187`은 "순서 이슈"가 아니라 확정 결함(NPE)**
`rc.log.Method__c = rc.interfaceDef.Method__c;`(`:187`)는 `rc.interfaceDef`가 **null인 시점**(대입은 `:192`)에 역참조하며 **try 블록 밖**이다 → 테스트가 아닌 모든 실제 `send()` 호출은 즉시 NullPointerException. 이 라인은 **org 버전(2026-07-07 수정됨)에도 동일하게 존재**한다. 단위테스트가 못 잡는 이유는 IS_TEST 가드가 send 자체를 우회하기 때문. → **Phase 1에서 반드시 수정**: 이 라인을 `rc.interfaceDef = interfaceDef;` 이후(+null 가드)로 이동. 타깃 토글 삽입 지점 설계는 이 수정과 함께 정리.

**⚠ 중대 발견 2 — LGCNS_Dev org에서 CMP 프레임워크는 사실상 미가동**
org 데이터 확인 결과 `CMP_Interface__c` 레코드는 **"Inbound Test" 1건뿐**(DART/G2B 레코드 없음), `CMP_InterfaceLog__c`는 **0건**. 즉 이 dev org에서는 G2B/DART 인터페이스가 돌고 있지 않다(운영 org 얘기). 시사점: ① dev org에서의 서비스 변경은 이 org 기준 회귀 위험이 사실상 없음(§1의 무중단 제약은 **운영 배포 시점**에 적용), ② §7 수동 파일럿은 **DART용 `CMP_Interface__c` 레코드를 dev org에 먼저 생성**(데이터 변경 → 승인 필요)해야 실행 가능, ③ 위 NPE 결함이 아직 아무도 못 밟은 이유이기도 함.

**발견 3 (해결됨) — 검증 시점 기본 target-org가 MCM_Dev였음**
검증 시점(2026-07-08 오전)엔 `.sf/config.json`이 `"target-org": "MCM_Dev"`여서 `--target-org` 없이 배포하면 MCM 고객 org로 나갈 위험이 있었다. → 이후 **`LGCNS_Dev`로 원복 확인 완료**(2026-07-08). 배포는 `--target-org LGCNS_Dev` 명시로 안전하게 수행됨.

## 4. 설계

### A. 신규 설정 필드 — `objects/CMP_Interface__c/fields/` (전부 가법적, 안전 기본값)

| 필드 API | 타입 | 기본값 | 용도 |
|----------|------|--------|------|
| `IsRetry__c` | Checkbox | false | 재시도 마스터 스위치. OFF=현행 동작 |
| `RetryCount__c` | Number(2,0) | 공백→코드 fallback 3 | 최대 재시도 횟수 |
| `RetryableStatusCodes__c` | Text(50) | 공백→코드 fallback `408,502,503,504` | 인터페이스별 재시도 대상 코드(CSV) 오버라이드 |
| `LogMode__c` | Picklist(`DML`/`PlatformEvent`) | `DML` | 로그 저장 방식 2택. `DML`=직접 insert(기본) · `PlatformEvent`=`CMP_InterfaceLogEvent__e` 발행(트랜잭션 분리). *`UsePlatformEventLog__c` 대체.* (`manualLogging` 레거시 코드 버퍼는 config 아님) |
| `Timeout__c` | Number(18,0) | 공백→코드 fallback 120000(ms) | **인터페이스별 HTTP 타임아웃**. 현재 `CMP_InterfaceService.cls:234`에서 `req.setTimeout(120000)` 하드코딩 → 이 필드로 대체. (MCM `IFProgram__c.Timeout__c` 참고) |

> 지연 필드(`RetryBaseDelay__c`)는 즉시 재시도 확정으로 **제거됨**. C(장기 재시도) 도입 시 예약 필드: `isLongRetry__c`(Checkbox), `RetryInterval__c`(Number, 분) 등 — 지금은 생성하지 않고 이름만 예약.

**재사용(신규 생성 금지)**: 타깃 시스템 키 = 기존 `Target__c`(Text 255) · 인터페이스별 활성 = 기존 `IsActive__c` · 성공코드 = 기존 `SuccessfulStatusCode__c`.

**MCM `IFProgram__c`에서 가져오지 않는 것**: 클래스 라우팅(`CalloutClass__c`/`QueueableClassName__c`/`BatchClassName__c`/`FutureClassName__c`/`ApexType__c`/`ProcessingType__c` — CMP는 `super(IF_ID,...)` 서브클래스 다형성으로 이미 해결), 스케줄링 클러스터, 체이닝(`IsActiveChain__c`), 롱리트라이 인프라, `MiddleWare__c`(Mule 전용). `ContentType__c`·`ExampleBody__c`/`ExampleHeader__c`는 각각 `Header__c`·`Specification__c`로 대체 가능 → 선택.

### B. 자동 재시도 엔진 (즉시 재시도) — `CMP_InterfaceService`에 private 메서드 추가

- `:244`를 `executeWithRetry(req)` 호출로 교체(반환형 동일 → 하류 무수정).
- `executeWithRetry(HttpRequest)`: `IsRetry__c==true && 멱등` 아니면 **기존과 동일하게 `new Http().send(req)` 1회** 반환. 재시도 시 `SUCCESS_CODES.contains(sc)`면 즉시 성공 반환, `isRetryableStatusCode(sc) && attempt<max`이면 **대기 없이 즉시** 재시도, 아니면 반환. **지연/백오프 없음** → CPU 소모 ≈ 0.
  ```apex
  private HttpResponse executeWithRetry(HttpRequest req) {
      // 재시도 OFF이거나 비멱등(POST)이면 기존과 동일하게 1회 전송
      if (!getRetryPolicy().enabled || !isIdempotent()) return new Http().send(req);   // seam ①
      Integer max = getRetryPolicy().count, attempt = 0;
      HttpResponse res;
      do {
          res = new Http().send(req);
          Integer sc = res.getStatusCode();
          if (SUCCESS_CODES.contains(sc)) return res;               // 성공
          if (!(isRetryableStatusCode(sc) && attempt < max)) break; // 재시도 불가/소진 → seam ③로
          attempt++;
      } while (true);
      return res;   // 소진/비재시도 응답 — 하류 로직이 상태 판정
  }
  ```
- `isRetryableStatusCode(Integer)`: 기본 `{408,502,503,504}`(429 제외), `RetryableStatusCodes__c` 있으면 그것으로 대체.
- `isIdempotent()` = `!NEED_BODY`(GET) — POST는 기본적으로 재시도 제외(중복 제출 방지), 검증된 멱등 엔드포인트만 opt-in.
- 상수 `DEFAULT_RETRY_COUNT=3`. (백오프 상수 없음)
- SELECT(`:89-94`)에 신규 필드 + `Target__c` 추가.
- 타임아웃: `:234`의 `req.setTimeout(120000)` → `req.setTimeout(Integer.valueOf(interfaceDef.Timeout__c != null ? interfaceDef.Timeout__c : 120000))`.

#### C(장기 재시도) 대비 — 확장 seam 3개

A를 나중에 갈아엎지 않고 C를 옆에 붙일 수 있도록, 구현 시 아래 경계만 잡아둔다(새 클래스·객체·추상화는 만들지 않음. 메서드 경계 + 주석 수준).

1. **재시도 정책 읽기 일원화** — `getRetryPolicy()` private 접근자 하나에서만 `IsRetry__c`/`RetryCount__c`/재시도 코드를 읽는다. C가 `isLongRetry__c`/`RetryInterval__c`를 추가해도 이 지점만 확장.
2. **재시도 종료 상태 명시** — `executeWithRetry`가 성공 / **재시도 소진(재시도 대상인데 다 실패)** / 재시도 불가를 구분(위 코드의 break 경로가 "소진").
3. **소진 훅을 이름 있는 메서드로** — 소진 분기를 인라인하지 말고 `onRetryExhausted(rc)` 호출. **지금은 no-op(그대로 기존 에러 로깅으로 통과)**, 주석 `// [확장] 장기 재시도(C) 연결 지점`. C 도입 시 이 본문만 채워 durable queue에 enqueue.

### C. 플랫폼이벤트 로깅 분리

- **신규 PE `CMP_InterfaceLogEvent__e`** — `objects/CMP_InterfaceLogEvent__e/`. 필드: `LogData__c`(Long Text 131072, 직렬화 로그 JSON), `LogDataOverflow__c`(Long Text, 5필드 청킹 후에도 초과 시 이어붙임용), `InterfaceId__c`(Text), `Status__c`(Text, 모니터링용).
- **트리거+디스패처+핸들러**(MCM 네이밍의 CMP 접두사판):
  - `triggers/CMP_InterfaceLogEventTrigger.trigger` (after insert) → `CMP_InterfaceLogEventTriggerDispatcher.dispatch(Trigger.operationType)` → `CMP_InterfaceLogEventTriggerHandler.afterInsert(events)`.
  - 핸들러: `LogData__c(+Overflow)`를 `JSON.deserialize(json, CMP_InterfaceLog__c.class)`로 복원해 **벌크 insert**. 개별 역직렬화는 try/catch, 최종 insert는 `Database.insert(logs,false)`(포이즌 레코드 격리).
- **`LogCls.execute()` 분기 = 2택**: `manualLogging`(레거시 코드 `super(...,true)`)→버퍼(logList) / `LogMode__c=='PlatformEvent'`→`publishLogEvent(log)`(`EventBus.publish`) / 그 외(`'DML'`/공백)→`insert log`(기본). `LogMode__c` 미설정 시 **바이트 단위로 현행과 동일**.
  - config 로그 방식은 **PlatformEvent / DML 2가지**. (`Buffered`는 config에서 제거 — 버퍼링은 `manualLogging` 레거시 코드 경로로만 존재)
- 기존 `chunkBody`/`splitBody`(5필드 청킹)를 그대로 재사용해 직렬화 전에 로그를 청킹 → PE 필드 한도 회피. **효과**: 다중 콜아웃 트랜잭션의 "uncommitted work pending before callout" 제거(`EventBus.publish`는 콜아웃 전 미커밋 DML로 계산되지 않음).

### D. 타깃시스템 토글 (opt-in)

- **신규 MDT `CMP_CalloutTargetActive__mdt`** — `objects/CMP_CalloutTargetActive__mdt/`. 필드 `isActive__c`(Checkbox, 기본 true), `Description__c`. DeveloperName = `Target__c` 값(`G2B`, `DART`, `SingleX`…).
- **차단 지점**: `send()`의 `rc.interfaceDef=interfaceDef;`(`:192`) 직후, HttpRequest 생성 전:
  ```apex
  if (String.isNotBlank(rc.interfaceDef.Target__c) && !isTargetActive(rc.interfaceDef.Target__c)) {
      // status=DEFINITION_ERROR(또는 신규 TARGET_DISABLED), 로그 세팅 후 콜아웃 없이 rc 반환
  }
  ```
  `isTargetActive(target)`: `CMP_CalloutTargetActive__mdt.getInstance(target)` — 레코드 없거나 `isActive__c=true`면 활성. `Target__c` 공백/미매칭 인터페이스는 **절대 차단 안 됨**(순수 short-circuit, 서브클래스 무수정).
  > `:187`은 검증 결과 **확정 NPE 결함**으로 판명(§3-1 중대 발견 1) — Phase 1에서 해당 라인을 `rc.interfaceDef` 대입 이후로 이동(+null 가드)하면서, 타깃 차단도 그 직후·HttpRequest 생성 전에 배치한다.
- **팩토리(`CMP_InterfaceFactory`)는 도입하지 않기로 확정** (2026-07-08): CMP는 인터페이스마다 서브클래스(`CMP_IF_*` extends 베이스) + `new ...().execute()`로 호출하는 모델을 그대로 유지한다.
  - 근거: ① 시스템별 인증/엔드포인트는 **Named Credential**이 이미 인터페이스 단위로 캡슐화 → `send()`가 이미 모든 시스템에 범용이라 MCM식 `targetSystem` 2단계 디스패치가 불필요(중복 machinery). ② `Type.forName(ClassName__c)` 문자열 디스패치는 컴파일 체크·참조추적·rename 안전성을 잃음. ③ 동적 디스패치가 실제 필요한 곳(G2B 실패 재전송)은 이미 자체 switch로 동작 중이고, 미래의 장기 재시도(C)가 생기면 그때 자체적으로 처리.
  - **타깃 전체 차단 가치는 위 토글(MDT+`isTargetActive`)만으로 이미 확보**되므로 팩토리 없이 충분.

### E. 로그 관측성 필드 — `objects/CMP_InterfaceLog__c/fields/` (MCM `IFProgramLog__c` 참고, 사용자 요청 세트)

사용자가 MCM 로그에서 가져오길 원한 항목: **Status · StatusCode · Error Text · Request Time · Request Header · Response Body · Response Header · Response Time · Log Text**. CMP 기존 필드와 대조한 결과 아래와 같이 **4개는 이미 존재(재사용)·5개는 신규 생성**한다(전부 가법적).

#### E-1. 신규 생성 (5개)

| 필드 API | 타입 | MCM 원본 | 용도 / 서비스 연동 지점 |
|----------|------|----------|--------------------------|
| `StatusCode__c` | Number(3,0) | `StatusCode__c` | 실제 HTTP 코드(503/429 등). `CMP_InterfaceService.cls:254`에서 `res?.getStatusCode()`를 이미 쥐고 있어 담기만 하면 됨. 숫자형이라 `StatusCode__c >= 500` 필터/정렬 가능. 재시도 판정·모니터링의 핵심 |
| `RequestTime__c` | DateTime | `RequestTime__c` | 요청 전송 시각 — 콜아웃(`:244`) **직전** `rc.log.RequestTime__c = Datetime.now();` |
| `ResponseTime__c` | DateTime | `ResponseTime__c` | 응답 수신 시각 — 콜아웃(`:244`) **직후** `rc.log.ResponseTime__c = Datetime.now();` |
| `ResponseHeader__c` | Long Text(131072) | `ResponseHeader__c` | 응답 헤더(rate-limit·재시도 안내 헤더 등). `:244` 이후 `res.getHeaderKeys()`를 맵으로 직렬화해 저장 |
| `LogText__c` | Long Text(131072) | `LogText__c` | 사람이 읽는 트랜잭션 트레이스. **`appendLog(...)` 헬퍼로 누적**(E-4). 서브클래스가 `before()`/`after()`/예외 처리에서 `[OK]`/`[FAIL]` 라인을 쌓음 |

추가 파생(권장): `fm_CalloutTime__c` Formula(Number) = `ResponseTime__c − RequestTime__c`(초/ms). 위 두 시각이 있으면 파생되며 성능 모니터링에 유용(MCM `FM_CalloutTimeCheck__c` 참고 — 단 자정 넘김 오류 나는 `TIMEVALUE` 대신 DateTime 차를 쓸 것).

#### E-2. 이미 존재 — 재사용, 신규 생성 금지 (4개)

| 사용자 요청 | CMP 기존 필드 | 비고 |
|-------------|---------------|------|
| **Status** | `Status__c` | 이미 있음. CMP는 `SUCCESS`/`RESPONSE ERROR`/`SYSTEM ERROR`/`DEFINITION ERROR`로 MCM(Success/Fail)보다 세분. 그대로 사용 |
| **Error Text** | `ErrorMessage__c` | MCM `ErrorText__c`와 동일 역할. 이미 채워짐(`:258`, `:263`) |
| **Request Header** | `Headers__c` | 이미 요청 헤더 저장(`:229` `JSON.serialize(headerMap)`). 신규 `ResponseHeader__c`와 짝(요청=Headers, 응답=ResponseHeader). 명칭 대칭이 꼭 필요하면 `RequestHeader__c` 별도 생성도 가능하나 **중복이므로 비권장** |
| **Response Body** | `ResponseBody__c` + `ResponseBody1__c`~`ResponseBody5__c` | 이미 있음. **MCM(131072 절단)보다 우수**(5필드 청킹 ~650k). 그대로 사용 |

#### E-3. 요청 외 (참고, 이번 미포함)

- `RequestSize__c`/`ResponseSize__c`(크기), `Type__c`(Outbound/Inbound 방향축 — CMP `JobType__c`는 실행축), 배치 메트릭 클러스터: 필요 시 추후 확대.
- 가져오지 않음: `GUID__c`(= `JobId__c`), 대부분 `FM_*`.

**서비스 연동 요약(§4-B 콜아웃부와 함께 Phase 1에서)**: `:244` 앞뒤로 `RequestTime__c`/`ResponseTime__c`, `:244` 직후 `StatusCode__c = res?.getStatusCode()` + `ResponseHeader__c`(헤더 직렬화). 전부 **로그 필드 채우기만** → 하류 상태 판정·기존 동작 무영향. PE 로깅 경로(§4-C)는 로그 레코드 전체를 직렬화하므로 신규 필드가 자동 포함됨.

#### E-4. `appendLog(...)` 헬퍼 — `LogText__c` 누적 (MCM `IF_AmazonPayV2_Base.appendLog` 참고)

MCM는 `appendLog(msg)`로 `logWrap.logText += msg + '\n'` 누적 후 저장 시 `LogText__c`에 플러시한다. CMP도 동일 UX를 제공한다.

- **누적 버퍼 + 헬퍼를 `CMP_InterfaceService`에 추가**:
  ```apex
  @TestVisible private String logTextBuffer = '';
  public void appendLog(String message) { logTextBuffer += (message == null ? '' : message) + '\n'; }
  public String getLogText() { return logTextBuffer; }
  ```
- **추상 베이스에서 위임 노출**(서브클래스가 `appendLog('...')`를 바로 호출):
  ```apex
  protected void appendLog(String m) { INF.appendLog(m); }   // RealTime/Queueable/Batch 각 베이스
  ```
- **플러시(1줄)**: 각 베이스가 로그 저장 직전(`new CMP_InterfaceService.LogCls(rc).execute();` 호출 앞)에 `rc.log.LogText__c = INF.getLogText();`. 서비스 자신의 `error(...)` 경로(`:489~` 등)는 `rc.log.LogText__c = this.getLogText();`.
  - `before()`→`send()`→`after()` 순서라, 버퍼는 `INF`에 두고 **모든 appendLog 호출이 끝난 저장 직전에** 플러시해야 `after()`/예외 처리의 로그도 포함됨.
  - Queueable은 `CMP_QueueableFinalizer.execute`에서 `queueableInstance.INF.getLogText()`로 플러시.

> **주의 — 이 헬퍼는 추상 베이스 3종에 손을 댄다.** §3의 "베이스 무영향"에서 유일한 예외지만, 변경은 **가법적**이다: 위임 메서드 1개 + 플러시 1줄. appendLog를 아무도 호출 안 하면 버퍼=''→`LogText__c`=''→**기존과 완전 동일**. 필드만 원하고 베이스를 안 건드리려면, 헬퍼 없이 서브클래스가 `INF`를 통해 `rc.log.LogText__c`를 직접 세팅하는 방식도 가능하나 ergonomics가 떨어짐(비권장).

## 5. 단계별 비파괴 마이그레이션

- **Phase 0 — 메타데이터만(런타임 영향 0)**: 설정 필드(§4-A) + 로그 관측성 필드(§4-E), `CMP_InterfaceLogEvent__e`, `CMP_CalloutTargetActive__mdt`, 로그이벤트 트리거/디스패처/핸들러 배포. Apex 서비스 미변경 → 아무것도 이 필드를 읽지 않으므로 운영 인터페이스 무영향. 트리거는 발행 이벤트가 없어 사실상 inert.
- **Phase 1 — 서비스 변경(전부 플래그 뒤)**: `CMP_InterfaceService` 수정 배포 — **`:187` NPE 결함 수정(§3-1 발견 1, 유일한 "동작 변경"이며 실은 버그 픽스)**, `executeWithRetry`(IsRetry 기본 false, 즉시 재시도), `onRetryExhausted` no-op 훅, `isTargetActive`(Target 공백/무 MDT면 no-op), `LogCls` PE 분기(UsePlatformEventLog 기본 false, `interfaceDef` null 가드 포함), `Timeout__c`·`StatusCode__c`·`RequestTime__c`/`ResponseTime__c`·`ResponseHeader__c` 채우기, `appendLog` 헬퍼(§4-E-4: 서비스 버퍼 + 베이스 위임/플러시), SELECT 확장. 그 외 신규 경로 기본 OFF → 현행과 동일(로그 신규 필드는 값만 채워질 뿐 동작 무영향).
- **Phase 2 — 인터페이스별 opt-in 파일럿**: **`CMP_IF_DART_OS_FinancialStatement`** 우선(실시간·GET·멱등·단일 콜아웃). 해당 `CMP_Interface__c` 레코드에 `IsRetry__c=true, RetryCount__c=2`(선택적으로 `LogMode__c='PlatformEvent'`, `Timeout__c` 조정). 검증 후 `CMP_IF_G2B_OS_BidResult_qu`(async)로 확대.
- **Phase 3 — 점진 롤아웃 + 타깃 토글**: `Target__c` 채우고 타깃별 MDT 행 생성(기본 활성), 인터페이스별 재시도를 웨이브로 활성. MDT `isActive__c=false`를 시스템 단위 긴급 킬스위치로 사용.
- **Phase 4 — (미래·범위 밖) 장기 재시도(C)**: 필요가 확정되면 §4-B의 `onRetryExhausted` seam에 연결. 신규: 재시도 상태 객체(`CMP_InterfaceRetryQueue__c` 등) + Queueable 재큐잉/스케줄 + `isLongRetry__c`/`RetryInterval__c` 예약 필드 실체화 + 중복제거·소진·모니터링. C가 다음 트랜잭션에서 실패 인터페이스를 재실행할 때의 클래스 디스패치는 그 시점에 자체 처리(저장된 `ClassName__c` 활용) — **범용 팩토리는 만들지 않는다**. **A 코드는 갈아엎지 않고 seam에 얹는다.** (구형 `IF_/InterfaceUtil` 통합은 본 계획 범위 밖.)

## 6. 리스크 & 테스트 영향

- **CPU/거버너**: 즉시 재시도는 대기가 없어 CPU 소모 ≈ 0 → 실시간(10s)·async 모두 안전. (백오프·busy-wait 미도입으로 이 리스크 자체가 소멸. C 도입 시 재검토)
- **재시도 유효성 한계**: 429/503은 즉시 재시도로 회복 안 될 수 있음 → 기본 대상 코드에서 429 제외, 근본 해결은 C(백오프)에서.
- **멱등성**: 비멱등 POST 재시도는 중복 제출 위험 → `isIdempotent()` 게이트, POST는 기본 OFF.
- **PE 한도**: `EventBus.publish`는 일일 플랫폼이벤트 발행 한도 소모. 핸들러 벌크 insert는 `Database.insert(logs,false)`로 포이즌 격리.
- **테스트 클래스**:
  - `CMP_InterfaceService_test` — `executeWithRetry`(성공/재시도후성공/소진→`onRetryExhausted` 통과), `isRetryableStatusCode`, 타깃차단 short-circuit, `LogCls` PE 분기, `Timeout__c`/`StatusCode__c` 반영 커버 추가. 기존 `testBehavior*`는 플래그 미설정으로 **그대로 green**(하위호환 증명).
    - **⚠ 테스트 구동 메커니즘(검증으로 확인)**: `CMP_InterfaceRealTime.cls:124`는 `IS_TEST=true`면 `INF.send()`를 **호출조차 하지 않고** 빈 `ReturnCls`로 대체한다. 또 `CMP_InterfaceRealTime`·`CMP_InterfaceService`는 **각자 별도의 `IS_TEST` 정적 변수**(둘 다 `@TestVisible`)를 가지며, 서비스의 `insert log`(`:370`)·`error()` 로깅도 `IS_TEST` 가드 뒤에 있다. → 재시도 엔진(`:244`)·PE 분기를 실제로 커버하려면 테스트에서 **`CMP_InterfaceRealTime.IS_TEST=false` + `CMP_InterfaceService.IS_TEST=false`로 세팅한 뒤 `Test.setMock(HttpCalloutMock.class, ...)`으로 응답을 주입**해야 한다. 상태코드별 목(200/503→200/503×N)으로 재시도 분기를 검증한다.
  - `CMP_InterfaceRealTime/Queueable/Batch/WebService_test` — 기본 OFF로 통과, 각 플래그-ON 경로 1건씩 추가.
  - **신규** `CMP_InterfaceLogEventTriggerHandler_test`(발행→`Test.getEventBus().deliver()`→`CMP_InterfaceLog__c` 생성 검증).
  - `CMP_TestDataFactory`의 `CMP_Interface__c` 빌더에 신규 필드 세팅 추가.

## 7. 검증

> 기본 org는 `LGCNS_Dev`(`.sf/config.json`). 안전을 위해 `--target-org LGCNS_Dev`를 명시해도 좋다.

**자동(단계별, 영향 클래스만 — 전체 스위트 지양)**:
```bash
sf apex run test --target-org LGCNS_Dev \
  --tests CMP_InterfaceService_test --tests CMP_InterfaceRealTime_test \
  --tests CMP_InterfaceQueueable_test --tests CMP_InterfaceBatch_test \
  --tests CMP_InterfaceWebService_test --tests CMP_InterfaceLogEventTriggerHandler_test \
  --result-format human --code-coverage --wait 20
```
기존 메서드 전부 green(기본 OFF 하위호환) + 신규 재시도/PE/타깃 테스트 green + `:187` 수정 후 **비-테스트 send() 경로가 NPE 없이 동작**하는 테스트(두 IS_TEST=false + mock) 추가 + 커버리지 org 기준 충족.

**수동 파일럿(DART 실시간)** — ⚠ LGCNS_Dev org에는 현재 `CMP_Interface__c` 레코드가 "Inbound Test" 1건뿐(§3-1 발견 2)이므로 **0단계로 DART용 정의 레코드를 먼저 생성**(데이터 변경 → 승인 필요: Name=`CMP_IF_DART_OS_FinancialStatement`, InterfaceId=DART용 Named Credential, Method=GET, SuccessfulStatusCode=200 등):
1. 그 레코드에 `IsRetry__c=true, RetryCount__c=2`.
2. 익명 Apex로 실행 → `CMP_InterfaceLog__c(Status__c=SUCCESS, StatusCode__c=200)` + 요청/응답 시각·지연 채워짐 + 재무 레코드 생성 확인.
3. 503 유발(NC를 임시로 503 반환 엔드포인트로/목) → `executeWithRetry`가 `RetryCount+1`회 **연속(지연 없이)** 시도 후 `RESPONSE ERROR`, `onRetryExhausted` 통과, **CPU 거의 증가 없음** 확인(`Limits.getCpuTime()`).
4. `LogMode__c='PlatformEvent'` → 로그가 PE 경로로 적재되고 "uncommitted work" 오류 없음 확인.
5. `CMP_CalloutTargetActive__mdt`의 `DART` 행 `isActive__c=false` → `send()`가 콜아웃 0회로 short-circuit 확인 후 원복.
6. `Timeout__c`를 짧게(예: 1000) 설정 → 느린 응답에서 타임아웃 동작 확인. 이후 `CMP_IF_G2B_OS_BidResult_qu`(async)로 Finalizer 로깅 검증.

## 8. 핵심 파일

- `force-app/main/default/classes/CMP_InterfaceService.cls` — 즉시 재시도(`:244`)·`getRetryPolicy`·`onRetryExhausted` seam, 타임아웃(`:234`), `StatusCode__c`/요청·응답 시각 채우기(`:244~`), `LogCls` PE 분기(`:367-371`), 타깃 short-circuit(`:192`), SELECT 확장(`:89-94`)
- `force-app/main/default/objects/CMP_Interface__c/fields/` — 신규 5필드(`IsRetry__c`/`RetryCount__c`/`RetryableStatusCodes__c`/`LogMode__c`/`Timeout__c`) (+`Target__c`/`IsActive__c`/`SuccessfulStatusCode__c` 재사용). *`UsePlatformEventLog__c`(초기 도입분)는 `LogMode__c`로 대체 → 사용 중단(추후 삭제 가능)*
- `force-app/main/default/objects/CMP_InterfaceLog__c/fields/` — 신규 관측성 필드 5종(`StatusCode__c`/`RequestTime__c`/`ResponseTime__c`/`ResponseHeader__c`/`LogText__c`) + 파생 `fm_CalloutTime__c`. (Status/Error Text/Request Header/Response Body는 기존 `Status__c`/`ErrorMessage__c`/`Headers__c`/`ResponseBody(1..5)__c` 재사용 — 신규 생성 안 함)
- `force-app/main/default/objects/CMP_InterfaceLogEvent__e/`, `.../CMP_CalloutTargetActive__mdt/` — 신규 PE·MDT
- `triggers/CMP_InterfaceLogEventTrigger.trigger` + `classes/CMP_InterfaceLogEventTriggerDispatcher.cls` + `...Handler.cls` — 신규
- `classes/CMP_InterfaceService_test.cls`(+신규 핸들러 테스트, `CMP_TestDataFactory`)
- 참고(무수정): MCM_Dev `IF_COMM_AbstractCallout.cls`(재시도 로직 — 단 busy-wait 백오프는 미채택), `IFProgram__c`/`IFProgramLog__c`(필드 참고), `InterfaceLogEventTrigger*`·`objects/InterfaceLogEvent__e/`(PE 로깅 원본)

## 9. Apex 작업 목록 (구현 착수 전 확인용)

> 필드/오브젝트(§1~4)·FLS·레이아웃은 **사용자가 org에 직접 추가**. 아래 Apex는 **승인 후** 로컬 생성/수정 → 배포. 클래스명은 프로젝트 네이밍(테스트 `_test` 접미사, 트리거 프레임워크와 별개의 PE 전용 디스패처/핸들러)을 따름.

### 9-1. 신규 생성 (4)

| 파일 | 유형 | 역할 |
|------|------|------|
| `CMP_InterfaceLogEventTrigger.trigger` | 트리거 | `CMP_InterfaceLogEvent__e` (after insert) → 디스패처 호출 |
| `CMP_InterfaceLogEventTriggerDispatcher.cls` | 클래스 | `Trigger.operationType` 분기(AFTER_INSERT → 핸들러) |
| `CMP_InterfaceLogEventTriggerHandler.cls` | 클래스 | `LogData__c(+Overflow)` 역직렬화 → `CMP_InterfaceLog__c` 벌크 insert(`Database.insert(...,false)`, 포이즌 격리) |
| `CMP_InterfaceLogEventTriggerHandler_test.cls` | 테스트 | 발행 → `Test.getEventBus().deliver()` → `CMP_InterfaceLog__c` 생성 검증 |

### 9-2. 기존 수정 (5)

| 클래스 | 수정 내용 |
|--------|-----------|
| `CMP_InterfaceService.cls` | **(핵심)** `:187` NPE 픽스 · `executeWithRetry`+`getRetryPolicy`(inner)+`isIdempotent`+`onRetryExhausted`(seam, no-op) · 타임아웃(`Timeout__c`) · `StatusCode__c`/`RequestTime__c`/`ResponseTime__c`/`ResponseHeader__c` 채우기 · `LogCls` PE 분기+`publishLogEvent` · 타깃 short-circuit+`isTargetActive`(+`targetActiveOverride` 테스트 주입) · SELECT 확장 · `appendLog`/`getLogText` 버퍼 |
| `CMP_InterfaceRealTime.cls` | `appendLog` 위임(`protected`) + `persistLog`(저장 직전 `LogText__c` 플러시), 3개 로그 지점 교체 |
| `CMP_InterfaceQueueable.cls` | `appendLog` 위임 + `persistLog`, `CMP_QueueableFinalizer`에서 `queueableInstance.persistLog(rc)` |
| `CMP_InterfaceBatch.cls` | `appendLog` 위임 + `persistLog`, execute 로그 지점 교체 |
| `CMP_InterfaceService_test.cls` | 재시도(성공/재시도후성공/소진)·PE 분기(`LogMode__c='PlatformEvent'`)·타깃차단·`isTargetActive` 커버 + `SeqMock`(순차 상태코드) + `testBehavior2` SOQL에 `LogMode__c` 포함(미조회 필드 접근 방지) |

**수정 안 함(확인)**: `CMP_TestDataFactory`(범용 오토-팩토리 — 테스트가 필드 맵으로 신규 필드 주입, 빌더 수정 불필요), `CMP_InterfaceWebService`(인바운드 — 아웃바운드 재시도/타임아웃 무관, PE 로깅은 `LogCls` 변경으로 자동 반영), 모든 `CMP_IF_*` 서브클래스(무수정 유지), `cmp_InterfaceLog` LWC·`CMP_InterfaceLogController`(신규 로그 필드 표시는 사용자가 레이아웃/컴포넌트에서 선택).

> **작성 상태(2026-07-08)**: 위 신규 4 + 수정 5 **로컬 작성 완료**. 신규 클래스/트리거는 각각 `-meta.xml`(apiVersion 62.0) 동반. 배포는 사용자 필드 생성 완료 후 아래 명령으로.

### 9-3. 배포 / 테스트 명령

기본 org는 `LGCNS_Dev`. 사전검증만 하려면 `--dry-run` 추가.

```bash
sf project deploy start --target-org LGCNS_Dev \
  --source-dir force-app/main/default/classes/CMP_InterfaceService.cls \
  --source-dir force-app/main/default/classes/CMP_InterfaceRealTime.cls \
  --source-dir force-app/main/default/classes/CMP_InterfaceQueueable.cls \
  --source-dir force-app/main/default/classes/CMP_InterfaceBatch.cls \
  --source-dir force-app/main/default/classes/CMP_InterfaceLogEventTriggerDispatcher.cls \
  --source-dir force-app/main/default/classes/CMP_InterfaceLogEventTriggerHandler.cls \
  --source-dir force-app/main/default/classes/CMP_InterfaceLogEventTriggerHandler_test.cls \
  --source-dir force-app/main/default/classes/CMP_InterfaceService_test.cls \
  --source-dir force-app/main/default/triggers/CMP_InterfaceLogEventTrigger.trigger
```
```bash
sf apex run test --target-org LGCNS_Dev \
  --tests CMP_InterfaceService_test --tests CMP_InterfaceLogEventTriggerHandler_test \
  --result-format human --code-coverage --wait 20
```

## 10. 콜아웃 호출 방법 (CMP 표준 — 서브클래스 모델)

CMP는 **인터페이스 1개 = 서브클래스 1개**이며, 신규 회복탄력성 기능은 **코드가 아니라 `CMP_Interface__c` 레코드 설정으로** 켠다. 호출부·서브클래스 코드는 바뀌지 않는다(팩토리 없음).

### 10-1. 인터페이스 작성

```apex
public with sharing class CMP_IF_XXX_OS_Something extends CMP_InterfaceRealTime {
    private Map<String, String> req;
    public CMP_IF_XXX_OS_Something(Map<String, String> req) {
        super('CMP_IF_XXX_OS_Something', ResponseWrapper.class); // = CMP_Interface__c.Name, 응답 타입
        this.req = req;
    }
    public override Object before() {           // 요청 구성 (GET이면 queryParameterMap)
        this.queryParameterMap.putAll(req);
        appendLog('[OK] before: ' + JSON.serialize(req));   // ← LogText__c 누적(§4-E-4)
        return null;                            // POST면 여기서 request body 객체 반환
    }
    public override void after(CMP_InterfaceService.ReturnCls rc) {  // 응답 처리
        ResponseWrapper res = (ResponseWrapper) rc.responseObject;
        appendLog('[OK] after: status=' + rc.log.StatusCode__c);
        // ... upsert 등 업무 로직 ...
    }
}
```

### 10-2. 호출

```apex
// Real Time (동기)
CMP_InterfaceService.ReturnCls rc = new CMP_IF_XXX_OS_Something(req).execute();

// Queueable (비동기) — CMP_InterfaceQueueable 상속 클래스
System.enqueueJob(new CMP_IF_XXX_OS_SomethingQ(req));
```

### 10-3. 신규 기능은 설정으로 켠다 (코드 무변경)

해당 `CMP_Interface__c` 레코드에서:

| 켜는 것 | 필드 |
|--------|------|
| 자동 재시도 | `IsRetry__c=true`, `RetryCount__c`, (선택) `RetryableStatusCodes__c` |
| 타임아웃 | `Timeout__c` (ms) |
| 로그 저장 방식 | `LogMode__c` = `DML` / `Buffered` / `PlatformEvent` |
| 타깃 긴급 차단 | `Target__c` 채우고 `CMP_CalloutTargetActive__mdt`의 해당 행 `isActive__c=false` |
| 로그 트레이스 | 서브클래스에서 `appendLog('...')` 호출 → `LogText__c` |

`StatusCode__c`·`RequestTime__c`/`ResponseTime__c`·`ResponseHeader__c`는 설정과 무관하게 매 콜아웃 자동 기록. 즉 **기존 인터페이스는 레코드 플래그만 켜면** 재시도·타임아웃·PE 로깅이 적용되고, 코드 배포가 필요 없다.

> **범위 변경 이력**: 초기엔 지수 백오프를 포함했으나, Apex 내 무CPU 대기 불가 → 즉시 재시도로 확정하고 백오프(장기 재시도, C)는 seam으로 예약(§1 결정 이력, §4-B). MCM 두 객체에서 `Timeout__c`(설정)·`StatusCode__c`/요청·응답 시각(로그)을 추가 반영(§4-A·§4-E).

---

## 11. 진행 이력 & 다음 단계 (Changelog)

> 이 문서가 CMP 재플랫폼의 **단일 정본**이다(설계 + 결정 + 진행). 프로젝트 전체 로그(`doc/WORKLOG.md`)에는 이 문서를 가리키는 포인터만 둔다. 계획 스냅샷 `~/.claude/plans/floating-yawning-reef.md`도 이 문서를 정본으로 표시.

### 진행 이력 (2026-07-08)

1. **조사·방향 확정** — MCM `IF_COMM_*` vs CMP `cmp_interface` 비교. 전체 교체 대신 **CMP 객체 유지 + MCM 패턴 가법 이식**(기본 OFF, 운영 무영향)으로 결정. MCM `IFProgram__c`/`IFProgramLog__c` 객체는 미도입(필드만 참고).
2. **재시도 방식** — 지수 백오프 검토 → Apex 무CPU 대기 불가로 **즉시 재시도 확정**, 백오프(장기 재시도 C)는 seam 예약. 기본 재시도 코드에서 429 제외.
3. **필드 갭 분석** — MCM 두 객체 대조 → 설정 `Timeout__c`, 로그 관측성 5필드(`StatusCode__c`/`RequestTime__c`/`ResponseTime__c`/`ResponseHeader__c`/`LogText__c`)+지연 수식 채택. 사용자 요청 10항목 중 4개는 기존 필드 재사용.
4. **appendLog** — MCM `appendLog` 패턴(`IF_AmazonPayV2_Base.cls:38`) 채택 → 서비스 버퍼 + 베이스 위임/flush.
5. **팩토리 미도입 확정** — Named Credential이 시스템 인증을 이미 캡슐화 → MCM식 targetSystem 디스패치 불필요. 서브클래스 모델 유지.
6. **계획 검증**(로컬+org Tooling API) — 코드 앵커·필드 무충돌·참조 클래스 8종 확인. 발견 3건(§3-1): `:187` NPE 결함, dev org CMP 미가동, 검증 시점 `.sf/config.json`이 MCM_Dev(이후 LGCNS_Dev로 원복 확인).
7. **문서 최종 검증** — 재시도 스니펫 멱등성 가드 누락 1건 수정.
8. **로컬 코드 작성 완료**(신규 4·수정 5, §9) — 아래 "구현 상태".
9. **로그 저장 방식 config화**(2026-07-08, 배포 완료) — `UsePlatformEventLog__c` 체크박스를 `LogMode__c` 픽리스트로 통합 후, 최종 **2택(`DML`/`PlatformEvent`)으로 축소**(사용자 요청, `Buffered` 제거). `LogCls` 2분기 + `manualLogging`(레거시 코드 버퍼). 배포·테스트 17/17 그린. → **필드에서 `Buffered` 값 제거 권장**(코드는 남아 있어도 DML로 처리).
10. **NCNS 프레임워크 fork**(2026-07-08, 배포 완료) — 신형/구형 혼재 혼란 해소 위해, 이 CMP 프레임워크를 **`NCNS_` 접두사로 통째 복제**하여 정식 신규 프레임워크로 확정. 신규 객체 4(`NCNS_Interface__c`/`NCNS_InterfaceLog__c`/`NCNS_InterfaceLogEvent__e`/`NCNS_CalloutTargetActive__mdt`) + 클래스 11(`NCNS_InterfaceService`/베이스 3/WebService/트리거세트/테스트) + 트리거 + 로그뷰어 LWC(`ncns_InterfaceLog`)+컨트롤러 + 샘플 2. 공유 유틸(`CMP_HttpUtil`/`CMP_TestDataFactory`/`Core`/`CMP_NamedCredentialController`)은 재사용. 배포 성공(104 컴포넌트)·테스트 17/17 그린. **앞으로 신규 인터페이스는 NCNS_ 프레임워크로 작성** — 사용법: [NCNS 핸드오버](NCNS_Interface_Framework_Handover.md), [NCNS 콜아웃 가이드](ncns-callout-logging-guide.md). CMP 프레임워크는 이 fork의 원본으로 남음.

### 구현 상태

- ✅ **로컬 코드 작성 완료** (2026-07-08). 신규 트리거 세트 4개, `CMP_InterfaceService`(v2.1) + 베이스 3종 + 서비스 테스트 수정. 상세 §9.
- ✅ **배포 완료** (2026-07-08, LGCNS_Dev = `cnspartner...ndev`) — 9개 컴포넌트(신규 3·변경 6). `--target-org LGCNS_Dev` 명시.
- ✅ **테스트 그린** — `CMP_InterfaceService_test` + `CMP_InterfaceLogEventTriggerHandler_test` **17/17 pass(100%)**. 신규 트리거/디스패처/핸들러 커버리지 100%, `CMP_InterfaceService` 86%.

### 배포 중 실패·수정 이력 (재발 방지)

1. **`json`/`JSON` 식별자 충돌** — 핸들러/서비스/테스트에서 지역변수명을 `json`으로 씀. Apex는 **대소문자 미구분**이라 `json`이 시스템 클래스 `JSON`을 가림 → `JSON.deserialize(...)`가 `String.deserialize(...)`로 해석되어 컴파일 실패. → 변수명 `payload`로 변경. **교훈: 지역변수를 Apex 시스템 클래스명(json/date/time/system/math 등)으로 짓지 말 것.**
2. **`CMP_InterfaceLog__c.Interface__c`는 필수 필드** — PE 핸들러가 역직렬화한 로그를 insert할 때 `Interface__c` 없으면 `REQUIRED_FIELD_MISSING`(단, `Database.insert(...,false)`라 조용히 실패 → 로그 0건). **운영 `send()`는 이미 세팅하므로 정상**, 테스트만 누락. → 테스트에서 `Interface__c` 세팅. **교훈: 테스트로 sObject 직접 생성 시 필수 필드(특히 Master-Detail/required lookup) 확인.**
3. **테스트 데이터 필드 길이 초과** — overflow 테스트에서 `ResponseBody1__c`(131072 제한)에 150000자 → insert `STRING_TOO_LONG`. → 여러 필드로 분산(120000+30000). **교훈: 테스트 데이터도 필드 길이 제약 준수.**

### 다음 단계 (체크리스트)

- [x] **사용자: 필드/오브젝트 org 생성** — 완료 (2026-07-08).
- [x] **배포** — 완료, 테스트 17/17 그린 (2026-07-08).
- [x] **`.sf/config.json` 기본 org** — `LGCNS_Dev`로 원복 확인 완료 (2026-07-08).
- [ ] **콜아웃 파일럿 (Named Credential 셋팅 후)** — 이 dev org엔 DART용 Named Credential이 없어(org NC = `APPR...`·`InterfaceLog` 2개뿐) 라이브 DART 콜아웃 불가. **NC 셋팅 후** DART용 `CMP_Interface__c` 레코드 생성 → `IsRetry__c=true` 등으로 §7 수동 검증. (재시도·PE·타임아웃 로직은 자동 테스트 17건으로 이미 검증됨)
  - 외부 콜아웃이 필요 없는 **타깃 토글**은 NC 없이도 라이브 검증 가능(`CMP_CalloutTargetActive__mdt` 레코드 + `Target__c` 설정 → send()가 콜아웃 0회 short-circuit). 원하면 별도 진행(데이터/CMDT 생성 = 승인 필요).
- [x] 베이스 3종(RealTime/Queueable/Batch)·`CMP_InterfaceService_test` 헤더 Modification Log 행 추가 (2026-07-08). *소스만 반영, 주석 변경이라 재배포는 선택.*
- [x] **로그 저장 방식 config화 (`LogMode__c`)** (2026-07-08) — `CMP_Interface__c.LogMode__c` Picklist(`DML`/`Buffered`/`PlatformEvent`) 추가·배포 완료, 테스트 17/17 그린. `LogCls`가 `manualLogging` 우선 → 아니면 `LogMode__c` 스위치. `UsePlatformEventLog__c` 사용 중단. 사용법(현행 NCNS 기준): [ncns-callout-logging-guide](ncns-callout-logging-guide.md).
- **현재 상태**: 전 인터페이스 기본 OFF(플래그 미설정)라 **운영 동작 변화 없음**. 배포된 코드는 대기 상태.
