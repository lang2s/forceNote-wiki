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

- [[통합 아키텍처 결정 - 미들웨어·재시도·멱등성]] — point-to-point vs ESB/MuleSoft 위상 + 재시도·멱등성
- [[ERP·서드파티 제품 연동 지도]] — SAP·Oracle·NetSuite·Informatica·MuleSoft 제품별 연동 라우팅, System/Process/Experience API 3계층, 실시간 vs 배치·데이터 가상화 vs 복제

---

## 보안 & 설정

- [[Named Credential]] — URL·인증 정보를 코드 밖에서 관리 (Outbound 필수) · External Auth Identity Provider(외부 OAuth 토큰 발급자)로 authProvider 대체
- [[Named Credential·External Credential 생성 필드 전수 레퍼런스]] — 생성 화면 모든 필드·프로토콜 분기 카탈로그
- [[CSP와 RemoteSite]] — LWC 브라우저 callout 및 Apex callout 허용 설정 (+ CORS 인바운드)
- [[Connected App (연결된 앱) — OAuth 클라이언트]] — OAuth 클라이언트 정의 (Consumer Key/Secret·scope·flow)
- [[External Client App (외부 클라이언트 앱)]] — Connected App 차세대 후속(Spring '26 신규생성 대체)
- [[서버간 통합 구축 가이드 - External Client App·JWT Bearer·Client Credentials]] — 서버간 인증 구축 절차(인증서→ECA→토큰→NC)
- [[OAuth Web Server + PKCE 플로우 구축 가이드]] — 사용자가 브라우저로 직접 로그인·승인하는 웹앱 OAuth 구축 절차(인가 코드+PKCE 5단계)
- [[OAuth 클라이언트(Connected App·External Client App) 생성 필드 전수 레퍼런스]] — Connected App/ECA OAuth 생성 화면 모든 필드·scope·정책 카탈로그
- [[Auth Provider 소셜 로그인·SSO 구축 가이드]] — 외부 IdP(Google 등) 소셜 로그인·JIT 프로비저닝 처음부터 끝까지 절차
- [[Integration User & API-Only User (통합 사용자)]] — 통합 실행 주체(무료 5 라이선스·API-Only·최소권한)
- [[Auth Provider (인증 공급자)]] — 외부 IdP 인증 게이트웨이 (소셜 로그인·외부 OAuth 토큰 공급)
- [[Pub-Sub API (gRPC) — Platform Event·CDC 구독]] — 외부 시스템이 Platform Event·CDC를 gRPC로 구독/발행 (CometD 대체·flow control·replay)
- [[아웃바운드 연결 - IP allowlist·Private Connect]] — 외부 방화벽이 Salesforce 콜아웃을 허용하도록 (ip-ranges.json 아웃바운드 IP 범위)·Hyperforce 사설 연결(Private Connect·AWS PrivateLink·OutboundNetworkConnection)

## Outbound (Salesforce → 외부)

- [[RestClient 패턴]] — Named Credential 기반 HTTP 추상화, 서비스 클래스 상속 구조
- [[Queueable + Callout 패턴]] — DML과 Callout을 한 트랜잭션에서 조합, 체이닝 가능
- [[Outbound Messaging (아웃바운드 메시지) — SOAP 콜백·WSDL·리스너]] — 워크플로/승인 규칙이 외부 엔드포인트로 `notifications()` SOAP를 push, `<Ack>true</Ack>` 리스너 계약·WSDL·24h 큐+2h 재시도(at-least-once)·Send Session ID (레거시 선언적 outbound)

## Inbound (외부 → Salesforce)

- [[REST API]] — 표준 REST(sObjects CRUD·SOQL·Composite·sObject Tree/Collections), OAuth 2.0
- [[SOAP API (표준 오퍼레이션·enterprise·partner WSDL)]] — 강타입 XML/SOAP API(Enterprise/Partner WSDL·login·upsert·convertLead·getUpdated/getDeleted·SessionHeader)
- [[Actions API]] — Invocable Action REST 호출(`/actions/standard`·`/actions/custom/apex`), inputs JSON, describe
- [[Custom REST Endpoint]] — `@RestResource`, `@HttpGet/@HttpPost` 글로벌 클래스

## 대량 데이터 (Bulk)

- [[Bulk API 2.0]] — 비동기 잡 기반 대량 ingest/query, 자동 배치·병렬, CSV, PK chunking
- [[Data Loader]] — Bulk API를 UI·CLI로 사용하는 클라이언트 (최대 1.5억 건)

## 이벤트 기반

- [[Platform Event 통합 패턴]] — `EventBus.publish()`, 트리거 수신, LWC 구독
- [[이벤트 기반 통합 구축 가이드 (Platform Event end-to-end)]] — 정의→발행→구독→멱등 소비→재시도까지 한 흐름으로 엮는 절차 허브
- [[Pub-Sub API 클라이언트 구축 가이드 (gRPC 구독·발행)]] — 외부(Python·Java 등)에서 gRPC로 Platform Event·CDC를 구독/발행하는 클라이언트 구축 how-to(proto stub·credit·Avro)
- [[Streaming API (CometD·PushTopic·Generic Streaming)]] — CometD/Bayeux long-polling 레거시 push 구독(PushTopic·Generic Streaming·Durable·replayId)

### Change Data Capture (CDC)

> 레코드 변경(생성·수정·삭제·복구)을 change event로 자동 발행해 외부 시스템과 데이터를 동기화. transaction-based replication. `/data/ChangeEvents` 및 객체별 채널로 구독.

- [[Change Data Capture — 개요·채널 구독]] — CDC란·엔티티 선택·구독 채널명 형식·이벤트 버스 저장/전달·transaction-based replication
- [[Change Data Capture — 커스텀 채널]] — 여러 객체를 한 채널로 묶는 커스텀 채널(`__chn`)·PlatformEventChannel/Member·채널 멤버·ERD
- [[Change Data Capture — 이벤트 메시지·Gap·Overflow]] — change event 메시지 구조·ChangeEventHeader·changeType enum·merged·gap·overflow·compound fields
- [[Change Data Capture — Enrichment·필터링]] — enriched(항상 포함) 필드·채널 필터 표현식·연산자·필드 타입·한도
- [[Change Data Capture — 고려사항·할당량·표준객체]] — allocations·보안(FLS·암호화)·모니터링·표준 객체 특수 동작(Person Account·Lead 전환·Task)

## 선언적 외부 연동

- [[External Services]] — OpenAPI 스펙 등록으로 Apex 클래스·Flow Action 자동 생성
- [[Salesforce Connect — 어댑터·Cross-Org·writable·External CDC]] — 외부 데이터를 external object로 실시간 가상화(복제 없음). 어댑터 카탈로그(Cross-Org·OData 2.0/4.0/4.01·Custom·DynamoDB·SQL·GraphQL)·Cross-Org 9 트리거 이벤트·쓰기 가능 외부 객체·External CDC(OData 4.0, 5–30분 폴링)·하드 한도. sObject 기본편은 [[External Objects]]

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
- [[Topics Resources - 일반·레코드]] — 조직 토픽 CRUD·병합·suggestion·trending·레코드 할당 REST(10 엔드포인트)
- [[Managed Topics Resources - Experience Cloud]] — EC 사이트 managed topic 계층(navigational·featured·content)·재정렬 REST(2 엔드포인트)
- [[Action Links Resources]] — 피드 element 버튼(웹·다운로드·API 호출)·action link group·정의·템플릿 REST(5 엔드포인트)

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
