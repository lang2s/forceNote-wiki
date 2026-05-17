---
tags: [integration, moc, index]
created: 2026-05-17
aliases: [통합 MOC, Integration Index]
---

# 통합 MOC

> Salesforce 통합 패턴 인덱스. 방향(Outbound/Inbound)과 동기/비동기 축으로 읽기.

---

## 아키텍처 결정 매트릭스

| 방향 | 동기/비동기 | 패턴 |
|---|---|---|
| Outbound (SF → 외부) | 동기 | [[RestClient 패턴]] |
| Outbound (SF → 외부) | 비동기 | [[Queueable + Callout 패턴]] |
| Inbound (외부 → SF) | 동기 | [[Custom REST Endpoint]] |
| Inbound/내부 | 이벤트 기반 | [[Platform Event 통합 패턴]] |

---

## 보안 & 설정

- [[Named Credential]] — URL·인증 정보를 코드 밖에서 관리 (Outbound 필수)
- [[CSP와 RemoteSite]] — LWC 브라우저 callout 및 Apex callout 허용 설정

## Outbound (Salesforce → 외부)

- [[RestClient 패턴]] — Named Credential 기반 HTTP 추상화, 서비스 클래스 상속 구조
- [[Queueable + Callout 패턴]] — DML과 Callout을 한 트랜잭션에서 조합, 체이닝 가능

## Inbound (외부 → Salesforce)

- [[Custom REST Endpoint]] — `@RestResource`, `@HttpGet/@HttpPost` 글로벌 클래스

## 이벤트 기반

- [[Platform Event 통합 패턴]] — `EventBus.publish()`, 트리거 수신, LWC 구독

## 테스트

- [[HttpCalloutMock]] — HTTP 모킹 (SuccessCalloutMock / ErrorCalloutMock)

---

## 핵심 API 요약

| API | 설명 |
|---|---|
| `callout:{NC_Name}/{path}` | Named Credential 엔드포인트 형식 |
| `Http.send(req)` | 동기 HTTP 발신 |
| `Database.AllowsCallouts` | Queueable에서 Callout 허용 |
| `@RestResource(urlmapping=...)` | Inbound REST 엔드포인트 등록 |
| `RestContext.request / .response` | Inbound 요청·응답 접근 |
| `EventBus.publish(events)` | 이벤트 발행 |
| `Test.setMock(HttpCalloutMock.class, mock)` | Callout 테스트 Mock 등록 |
