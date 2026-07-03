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

- [[REST API]] — 표준 REST(sObjects CRUD·SOQL·Composite·sObject Tree/Collections), OAuth 2.0
- [[Actions API]] — Invocable Action REST 호출(`/actions/standard`·`/actions/custom/apex`), inputs JSON, describe
- [[Custom REST Endpoint]] — `@RestResource`, `@HttpGet/@HttpPost` 글로벌 클래스

## 대량 데이터 (Bulk)

- [[Bulk API 2.0]] — 비동기 잡 기반 대량 ingest/query, 자동 배치·병렬, CSV, PK chunking
- [[Data Loader]] — Bulk API를 UI·CLI로 사용하는 클라이언트 (최대 1.5억 건)

## 이벤트 기반

- [[Platform Event 통합 패턴]] — `EventBus.publish()`, 트리거 수신, LWC 구독

## 선언적 외부 연동

- [[External Services]] — OpenAPI 스펙 등록으로 Apex 클래스·Flow Action 자동 생성

## Connect REST API (Chatter/협업 REST)

> 모바일·인트라넷·서드파티 앱을 Salesforce 협업(피드·그룹·사용자·댓글·토픽)과 통합하는 REST API. Apex `ConnectApi`(Connect in Apex)의 HTTP 짝. 폴더: [[ConnectREST(커넥트REST)/index|ConnectREST]]

- [[Connect REST API 개요]] — 용도·아키텍처·인증(OAuth)·Limits·Quick Start·Connect in Apex 관계
- [[Connect REST API 요청·응답 규약]] — resource URL·HTTP 메서드·필터(filterGroup·exclude/include)·상태 코드·multipart 업로드
- [[Feed Elements Resources]] — 피드 요소 POST·검색·capability(45)·Message Segment·Feed Item Input
- [[Feeds Resources]] — 23개 feed type(news·record·groups·topics 등)·feed-elements 파라미터
- [[Comments · Likes · Mentions Resources]] — 댓글(조회·편집·verified·status·투표)·좋아요·멘션(자동완성·검증) REST
- [[Groups Resources]] — Chatter 그룹 CRUD·멤버·멤버십 요청·사진·배너·공지·레코드·초대 REST(17 리소스)
- [[Users Resources - 프로필·대화·메시지·팔로우]] — 사용자 정보·프로필·비공개 대화/메시지·팔로우·그룹·설정 REST(17 리소스)
- [[Users Resources - Recommendations·Reputation]] — Chatter 추천 6종·평판(action·objectCategory·idPrefix)
- [[User Profiles · Subscriptions · Followers on Records Resources]] — 사용자 프로필·사진/배너·구독(언팔)·레코드 팔로워 REST(5 리소스)
- [[Topics · Announcements · Q&A Resources]] — 토픽 endorsement·knowledgeable·opt-out·공지·Q&A 제안 REST(10 리소스)
- [[Files & Folders Resources]] — 네이티브 Salesforce Files 파일·폴더·공유·미리보기·렌디션 REST(21 엔드포인트)
- [[Files Connect Repository Resources]] — 외부 저장소(SharePoint·Google Drive·OneDrive) 파일·권한 REST(14+3)
- [[Notifications Resources]] — in-app/push 알림·알림 설정 REST(10 엔드포인트)

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
