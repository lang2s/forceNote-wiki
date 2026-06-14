---
tags: [scenario, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
updated: 2026-06-14
aliases: [Infosys Integration SBQ]
---

# Infosys Salesforce 개발자 — 통합 시나리오 질문

> [!warning] 제3자 학습노트(통합 시나리오 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 답변·코드는 표준 Salesforce 통합 패턴 기준으로 작성했으나, 구현 전 공식 문서로 검증하세요.

> 형식: **예상 로직**·**솔루션** = 접근법, **흔한 실수** = 함정, **A** = 표준 해법.

---

## Q: Queueable Apex로 외부 시스템 비동기 통합
**예상 로직:**

Queueable로 장기 콜아웃을 동기 실행에서 분리, execute에서 재시도·오류 처리.

**흔한 실수:**

Queueable 예외 처리 미흡, 실패 콜아웃 재시도 미처리, 다중 비동기 콜아웃 시 거버너 한도 미고려.

- **A:** `Queueable` + `Database.AllowsCallouts` 구현. 실패 시 재시도 카운터를 들고 다시 enqueue(백오프). 비동기 컨텍스트에서는 한 트랜잭션당 **체인 enqueue 1개**만 가능.
```apex
// 구조 예시 — 실제 동작 코드 아님
public class SyncJob implements Queueable, Database.AllowsCallouts {
    private Integer attempt;
    public SyncJob(Integer attempt) { this.attempt = attempt; }
    public void execute(QueueableContext ctx) {
        try {
            HttpResponse res = new Http().send(buildRequest());
            if (res.getStatusCode() != 200 && attempt < 3) {
                System.enqueueJob(new SyncJob(attempt + 1));  // 재시도
            }
        } catch (CalloutException e) {
            if (attempt < 3) System.enqueueJob(new SyncJob(attempt + 1));
        }
    }
    private HttpRequest buildRequest() { /* ... */ return new HttpRequest(); }
}
```

---

## Q: OAuth 2.0로 외부 시스템 인증 통합
**예상 로직:**

Named Credentials 또는 수동 OAuth 플로우로 인증. authorization code grant 또는 client credentials 플로우.

**솔루션:**

① OAuth 자격 증명으로 Named Credential 생성, ② Named Credential로 외부 API 콜아웃.

**흔한 실수:**

OAuth 토큰·만료 미처리, 외부 시스템에 맞는 플로우 미설정, 토큰 갱신 미처리.

- **A:** **Named Credential + External Credential**(OAuth 2.0 Authorization Code 또는 Client Credentials)을 구성하면 플랫폼이 **토큰 발급·갱신·만료를 자동 처리**. 콜아웃은 `req.setEndpoint('callout:My_Named_Cred/path')`만 하면 인증 헤더가 자동 주입 → 토큰을 코드에서 다루지 않는다.

---

## Q: SOAP API + WSDL 통합
**예상 로직:**

WSDL로 Apex 클래스 생성(Salesforce Apex Web Services 도구), 데이터 처리·오류 처리.

**솔루션:**

① WSDL로 Apex 클래스 생성, ② 생성된 클래스로 SOAP API 호출.

**흔한 실수:**

WSDL 처리 오류, SOAP 오류(타임아웃·잘못된 응답) 예외 미처리, 통합 테스트 부족.

- **A:** Setup의 **Generate from WSDL**(WSDL2Apex)로 stub 클래스를 생성 → 생성된 프록시 클래스의 메서드를 호출. 엔드포인트·인증은 Named Credential로, 호출은 `try/catch (CalloutException)`로 감싸고, 테스트는 `WebServiceMock`(`Test.setMock(WebServiceMock.class, ...)`)으로 응답 시뮬레이션.

---

## Q: Mulesoft로 SAP 통합
**예상 로직:**

Mulesoft를 미들웨어로 데이터 변환, Salesforce REST API로 송수신, 양쪽 데이터 일관성.

**솔루션:**

트리거(Salesforce API 요청) → 변환(JSON→XML) → SAP Connector로 전송 → 응답 반환.

**흔한 실수:**

미들웨어 오류 처리 무시(SAP 다운·잘못된 매핑), 업데이트 전 데이터 검증 미흡, 실시간 동기화 체크 누락.

- **A:** Salesforce는 **MuleSoft 엔드포인트**(Named Credential)로만 콜아웃하고, JSON↔XML 변환·SAP 커넥션·재시도는 MuleSoft가 담당(관심사 분리). **멱등성**(외부 ID upsert), 에러 큐, SAP 다운 시 회로 차단(circuit breaker)으로 일관성 확보. 대량·실시간은 Platform Events로 디커플.

---

## Q: WebSockets로 실시간 주문 추적
**예상 로직:**

CometD(Bayeux 프로토콜)로 실시간 업데이트, 외부 앱에서 Platform Events 구독.

**흔한 실수:**

CometD 핸드셰이크 실패 미처리, 잘못된 API 버전, 대량 구독자 확장성 무시.

- **A:** Salesforce는 임의 WebSocket 서버를 제공하지 않으므로, 주문 변경을 **Platform Event**(또는 CDC)로 발행하고 외부 앱이 **Pub/Sub API**(gRPC, 권장) 또는 **CometD/Streaming API**(Bayeux)로 구독한다. `replayId`로 재연결 시 누락 방지, 핸드셰이크 실패·재연결 백오프, 구독자 한도 고려.

---

## Q: Google Drive 통합으로 업로드 파일 저장
**예상 로직:**

Google Drive API + OAuth 2.0, 파일 링크를 Salesforce에 저장.

**흔한 실수:**

OAuth 2.0 오용, 액세스 토큰 하드코딩(동적 갱신 안 함), 파일 크기·rate limit 무시.

- **A:** **Named Credential + External Credential**(Google OAuth)로 Drive API에 콜아웃(토큰 하드코딩 금지·자동 갱신). 업로드 후 응답의 `webViewLink`/`fileId`를 Salesforce 필드(또는 `ContentDocumentLink`)에 저장. 대용량은 resumable upload, Google **rate limit**·heap 한도(콜아웃 응답 6MB) 유의.
