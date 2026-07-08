# NCNS 콜아웃 인터페이스 — 서브클래스 작성 & 로그 사용 가이드

> **문서 유형: 하우투/레퍼런스** — NCNS 신규 프레임워크로 아웃바운드 콜아웃 인터페이스를 만들고, 로그(`NCNS_InterfaceLog__c`)를 사용하는 방법.
> 작성일: 2026-07-08 · [문서 인덱스](index.md) · 관련: [재플랫폼 설계서](cmp-interface-replatform-plan.md) · 샘플 클래스: `NCNS_IF_SAMPLE_OS_Callout`

---

## 1. 핵심 개념

- **콜아웃 인터페이스 = `NCNS_InterfaceRealTime`(동기) 또는 `NCNS_InterfaceQueueable`(비동기) 상속 서브클래스**.
- 콜아웃/로그 적재는 **프레임워크가 자동** 처리. 개발자는 `before()`(요청 구성) / `after(rc)`(응답 처리)만 구현.
- **로그 저장 방식·재시도·타임아웃은 코드가 아니라 `NCNS_Interface__c` 레코드 설정**으로 켠다.
- 사람이 읽는 추적 로그는 `appendLog('...')` 로 남긴다 → `NCNS_InterfaceLog__c.LogText__c` 에 누적.

## 2. 서브클래스 코드 (동기 RealTime, 최소형)

```apex
public with sharing class NCNS_IF_ACME_OS_Something extends NCNS_InterfaceRealTime {

    private static final String IF_ID = 'NCNS_IF_ACME_OS_Something'; // = NCNS_Interface__c.Name
    private final Request req;

    public NCNS_IF_ACME_OS_Something(Request req) {
        super(IF_ID, Response.class);   // 단일 인터페이스 → 즉시 로깅
        this.req = req;
    }

    // 송신 전 — 요청 구성
    public override Object before() {
        appendLog('[OK] before: ' + JSON.serialize(req));   // ← LogText__c 누적
        INF.keyList.add(req.id);                            // 로그 조회 키(선택)
        // GET이면: this.queryParameterMap.put('keyword', req.keyword);  → return null;
        return req;                                         // POST면 이 객체가 request body
    }

    // 수신 후 — 응답 처리
    public override void after(NCNS_InterfaceService.ReturnCls rc) {
        Response res = (Response) rc.responseObject;
        appendLog('[OK] after: statusCode=' + rc.log.StatusCode__c);
        // 비즈니스 실패를 사용자 에러로: if('FAIL'.equals(res.resultCode)) { INF.error(rc, res.message); return; }
        // ... 업무 로직(upsert 등) ...
    }

    // 요청/응답 DTO — 반드시 "타입 지정" (Map<String,Object> 금지)
    public class Request  { public String id; public String keyword; }
    public class Response { public String resultCode; public String message; }
}
```

> 그대로 복제해 쓸 수 있는 샘플: **`NCNS_IF_SAMPLE_OS_Callout`**(편의 진입점 `run(req)` 포함).

## 3. 호출 방법

```apex
NCNS_IF_ACME_OS_Something.Request req = new NCNS_IF_ACME_OS_Something.Request();
req.id = 'A-001';  req.keyword = 'hello';

NCNS_InterfaceService.ReturnCls rc = new NCNS_IF_ACME_OS_Something(req).execute();

if (rc != null && !rc.isError) {
    NCNS_IF_ACME_OS_Something.Response res = (NCNS_IF_ACME_OS_Something.Response) rc.responseObject;
    // ...
}
```

## 4. 선행조건 — `NCNS_Interface__c` 레코드 (필수)

| 필드 | 값(예) | 용도 |
|------|--------|------|
| `Name` | `NCNS_IF_ACME_OS_Something` | 서브클래스 `super(IF_ID, ...)`의 IF_ID와 동일 |
| `IsActive__c` | ✅ | 활성(비활성이면 정의 조회 안 됨) |
| `InterfaceId__c` | (Named Credential 이름) | 엔드포인트 = `callout:InterfaceId__c` |
| `Method__c` | `POST` / `GET` | HTTP 메서드 (POST만 body 전송) |
| `SuccessfulStatusCode__c` | `200` (멀티셀렉트) | 성공으로 볼 상태코드 |
| `Timeout__c` | (선택) ms | 인터페이스별 타임아웃 |
| `IsRetry__c` / `RetryCount__c` | (선택) | 자동 재시도(GET 등 멱등만) |
| `LogMode__c` | `DML`(기본) / `PlatformEvent` | **로그 저장 방식**(§5) |

## 5. 로그 저장 방식 — `LogMode__c` (2택)

로그를 **어떻게 적재할지**를 레코드 설정으로 선택합니다. 코드는 그대로.

| 값 | 동작 | 언제 |
|----|------|------|
| **`DML`** (기본) | 콜아웃 직후 `insert` (같은 트랜잭션) | 일반적인 단건 콜아웃 |
| **`PlatformEvent`** | `NCNS_InterfaceLogEvent__e` 발행 → 트리거가 별도 트랜잭션에서 insert | **다중 콜아웃/루프**에서 "uncommitted work pending before callout" 회피, 로그 트랜잭션 분리 |

**변경 방법**: 해당 `NCNS_Interface__c` 레코드의 `LogMode__c` 값만 바꾸면 즉시 적용(배포 불필요).

> 참고: 한 트랜잭션에 인터페이스 여러 건을 모아 마지막에 일괄 저장하는 **버퍼(수동 로깅)**는 config가 아니라 **코드**로만 씁니다 — 생성자 `super(IF_ID, Response.class, true)` + 서브클래스 `finish()`에서 `INF.saveLog()`. (레거시 유지)

## 6. 로그에 자동 기록되는 것 (`NCNS_InterfaceLog__c`)

콜아웃 시 프레임워크가 **설정과 무관하게 자동**으로 채웁니다:

| 필드 | 내용 |
|------|------|
| `Status__c` / `StatusCode__c` | `SUCCESS`/`RESPONSE ERROR` 등 / 실제 HTTP 코드(200/503…) |
| `RequestTime__c` / `ResponseTime__c` (+`fm_CalloutTime__c`) | 요청·응답 시각, 지연 |
| `RequestBody__c` / `ResponseBody1~5__c` | 요청/응답 본문(응답은 ~65만자 분할) |
| `ResponseHeader__c` / `Headers__c` | 응답 헤더 / 요청 헤더 |
| `LogText__c` | **`appendLog('...')` 로 남긴 추적 로그** |
| `ErrorMessage__c` | 실패 시 메시지 |
| `Key__c` / `Success__c` / `Fail__c` | `INF.keyList`/`successList`/`failList` |

로그 조회 UI: `ncns_InterfaceLog` LWC(관련 목록/레코드 페이지).

## 7. 비동기(Queueable) 변형

대량/비동기는 `NCNS_InterfaceQueueable` 상속:

```apex
public with sharing class NCNS_IF_ACME_OS_SomethingQ extends NCNS_InterfaceQueueable {
    private final Request req;
    public NCNS_IF_ACME_OS_SomethingQ(Request req) { super('NCNS_IF_ACME_OS_SomethingQ', Response.class); this.req = req; }
    public override Object before() { appendLog('[OK] before'); return req; }
    public override void after(NCNS_InterfaceService.ReturnCls rc) { /* ... */ }
    public class Request {} public class Response {}
}
// 호출
System.enqueueJob(new NCNS_IF_ACME_OS_SomethingQ(req));
```
- 로그는 `System.Finalizer`에서 적재되므로, 트랜잭션이 롤백돼도 로그가 남습니다.
- `LogMode__c`는 동일하게 적용.

## 8. 요약 체크리스트

- [ ] `NCNS_IF_<시스템>_OS_<이름>` 서브클래스 작성(`before`/`after`), 필요 시 `appendLog`
- [ ] `NCNS_Interface__c` 레코드 생성(§4) + Named Credential
- [ ] `LogMode__c` 선택(기본 `DML`, 루프/분리 필요 시 `PlatformEvent`)
- [ ] (버퍼 수동로깅 쓸 때만) `super(...,true)` + `finish()`에서 `INF.saveLog()`
- [ ] 호출부에서 `new ...(req).execute()` / async는 `System.enqueueJob(...)`
