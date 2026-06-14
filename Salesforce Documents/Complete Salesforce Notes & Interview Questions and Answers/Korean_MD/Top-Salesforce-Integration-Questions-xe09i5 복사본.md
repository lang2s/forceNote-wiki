# Salesforce 통합 주요 질문 & 답변

> 각 항목은 "질문 / 답변 / 팁" 구조이며, 코드와 표는 원문 그대로 보존했습니다.

---

# Part A. 시나리오 기반 질문 (1~20)

## 1. 양방향 통합에서 순환 의존성 처리
**질문:** Salesforce와 외부 시스템 간 양방향 통합에서 순환 의존성을 어떻게 처리하나?
**답변:** 업데이트 출처를 추적하고 재처리를 막기 위해 상관관계 ID(correlation ID)를 쓴다. 이미 처리된 레코드를 식별하는 플래그/상태 필드를 둔다. 미들웨어로 흐름 오케스트레이션과 순환 의존성 차단을 활용한다. LastModifiedDate/SystemModstamp 비교로 변경을 검증한다.
**팁:** 멱등(idempotent) API 설계가 핵심 / 리플레이·중복 제거 제어를 위해 CDC나 Platform Events를 쓰라.

## 2. 높은 API 호출량이 거버너 한도에 미치는 영향
**질문:** 높은 API 호출량이 Salesforce 거버너 한도에 어떤 영향을 주며 어떻게 최적화하나?
**답변:** 높은 API 볼륨은 일일 org 한도나 사용자별 한도(24시간 롤링 API 호출 한도)를 초과할 수 있다. 해결: 대용량 적재에 Bulk API(v2), 여러 요청 결합에 Composite API, 불필요한 호출을 줄이는 캐싱·데이터 가상화(Salesforce Connect), Salesforce API를 소비하는 외부 시스템에 rate limiting 구현.
**팁:** Setup → System Overview → API Usage로 사용량 모니터링 / 외부 API 인증에 Named Credentials 사용 / 폴링보다 CDC 선호.

## 3. Platform Events vs CDC vs Outbound Messages
**질문:** Platform Events, CDC, Outbound Messages의 차이와 각각 언제 쓰는지 설명하라.

| 특징 | Platform Events | CDC | Outbound Messages |
|---|---|---|---|
| 목적 | 커스텀 이벤트 메시징 | 데이터 변경 추적 | 선언적 메시징 |
| 리플레이 | 24시간 | 3일(기본, 최대 7일) | 없음 |
| 사용 사례 | 실시간 알림 | 외부 DB 동기화 | 레거시 워크플로우 |
| 트랜잭션 바운드 | 예 | 예 | 예 |

**언제 쓰나:** 커스텀 이벤트 기반 통합(실시간 마이크로서비스)에는 Platform Events, Salesforce 레코드 변경 동기화에는 CDC, 선언적·로우코드 알림이 필요하면 Outbound Messages.
**팁:** CDC + Platform Events는 함께 잘 동작 / 복잡한 통합에는 Outbound Messages 대신 Platform Events + 미들웨어.

## 4. OAuth 2.0 JWT Bearer Flow 구현
**질문:** 외부 시스템과의 안전한 통합을 위해 OAuth 2.0 JWT Bearer Flow를 어떻게 구현하나?
**답변:** (1) 자체 서명 인증서 생성 → Salesforce에 업로드. (2) JWT Bearer가 활성화된 Connected App 등록. (3) 필수 claim(iss, aud, sub, exp)으로 JWT assertion 생성. (4) 외부 시스템이 JWT 서명 → Salesforce 토큰 엔드포인트로 전송 → 액세스 토큰 수신. (5) API 호출에 토큰 사용.
**팁:** JWT는 사용자 상호작용이 없는 서버 간 통합에 이상적 / 개인 키는 가급적 AWS KMS나 Azure Key Vault에 안전하게 저장.

## 5. 속도 제한과 재시도 관리 베스트 프랙티스
**질문:** Salesforce 통합에서 rate limit과 재시도를 관리하는 베스트 프랙티스는?
**답변:** 재시도에 백오프 전략(Exponential Backoff + Jitter). HTTP 429(Too Many Requests) → 재시도 메커니즘 트리거. 미들웨어로 스로틀링·큐 관리. 가능한 곳에서 API 호출 벌크화.
**팁:** 안정적 인증을 위해 OAuth refresh token이 있는 Named Credentials / Event Monitoring → API Usage로 모니터링 / 외부 폴링보다 CDC 푸시 선호.

## 6. 대용량 데이터 전송(수백만 건) 처리
**질문:** 수백만 건의 Salesforce와 외부 시스템 간 대용량 데이터 전송을 어떻게 처리하나?
**답변:** Bulk API v2(대용량 최적화). 비동기 패턴 처리. 레코드 잠금에 주의하며 병렬 배치. 익스포트는 Data Export Service(전체/부분 샌드박스 백업)나 Heroku Connect.
**팁:** 큰 트랜잭션을 작은 배치로 분할(예: 배치당 1만 건) / 성능 튜닝을 위해 partial 샌드박스에서 먼저 테스트 / 효율적 upsert를 위해 외부 시스템 인덱싱.

## 7. Named Credentials vs Custom Metadata 인증
**질문:** 통합에서 Named Credentials와 Custom Metadata 기반 인증의 역할은?
**답변:** Named Credentials: 엔드포인트·OAuth 토큰을 안전하게 관리하는 내장 기능, Apex에 URL·시크릿 하드코딩 불필요. Custom Metadata Types: 외부 시스템 매핑·구성 같은 동적 값 저장, 시크릿 직접 저장 불가(필요시 Protected Custom Metadata와 함께).
**팁:** 외부 엔드포인트의 안전·선언적 관리에는 Named Credentials 선호 / Custom Metadata는 구성용, 민감 시크릿을 평문 필드에 저장 금지.

## 8. Salesforce External Objects(OData 4.0) 이점과 도전
**질문:** OData 4.0을 사용하는 External Objects의 이점과 도전을 설명하라.
**답변:** 이점: 외부 데이터에 실시간 접근(Salesforce에 저장 불필요), 표준 SOQL로 외부 데이터 쿼리. 도전: External Object에 트리거·Apex 불가, 외부 시스템 응답성에 따른 성능 병목, OData 4.0 또는 커스텀 어댑터로 제한.
**팁:** 참조 데이터(가격, 재고)에 적합 / 자주 접근하는 데이터셋에는 캐싱·미러링.

## 9. Salesforce 통합에서 Heroku Connect
**질문:** Heroku Connect는 통합에 어떻게 도움이 되며 한계는?
**답변:** Salesforce 오브젝트를 Heroku의 Postgres DB와 양방향 동기화. 관계형 DB가 필요한 고객 대면 앱·마이크로서비스에 이상적. 한계: Postgres 쓰기에 커스텀 Apex 트리거 미지원, Heroku 라이선스 + 추가 비용 필요, 동기화는 준실시간이나 즉시는 아님.
**팁:** Heroku Connect → CDC → AWS Lambda → 실시간 동기화 패턴이 고급 사례에 잘 동작 / 데이터 스큐와 Postgres 인덱싱 이슈 주의.

## 10. Salesforce에서 Pub/Sub 패턴 구현
**질문:** 외부 시스템과 실시간 데이터 동기화를 위해 Salesforce에서 Pub/Sub 패턴을 어떻게 구현하나?
**답변:** Platform Events나 Change Data Capture를 발행자(publisher)로 사용. 미들웨어나 외부 구독자(AWS Lambda, Kafka)가 이벤트 처리. 실시간 구독에 CometD 프로토콜이나 Pub/Sub API 사용.
**팁:** 확장 가능한 이벤트 소비에 Pub/Sub API(2024 GA) 선호 / 다중 소비자 모델에는 Kafka Connect → Salesforce CDC → 다운스트림.

## 11. REST API에서 민감 데이터 보호
**질문:** REST API로 전송 시 민감 데이터를 보호하는 최선의 방법은?
**답변:** TLS(HTTPS) 필수. 민감 데이터에 페이로드 수준 암호화(AES-256). 인증에 OAuth 2.0 또는 mutual TLS(mTLS). 저장 데이터에 필드 수준 암호화(Shield Platform Encryption).
**팁:** URL 쿼리 문자열에 토큰·민감 데이터 노출 금지 / 입출력 검증과 로깅 마스킹(redaction) 구현.

## 12. 동시 API 요청과 경쟁 조건 처리
**질문:** Salesforce는 동시 API 요청을 어떻게 처리하며 경쟁 조건(race condition)을 어떻게 방지하나?
**답변:** Salesforce는 API 요청을 독립적으로 처리하지만 레코드 수준 업데이트는 레코드 잠금을 유발할 수 있다. 방지: Optimistic Locking(If-Unmodified-Since 헤더), 멱등 업데이트를 위한 External ID, 중요한 작업 직렬화에 Platform Events.
**팁:** 중요 오브젝트에는 버전 필드나 eTag로 제어 / 부모-자식 master-detail 오브젝트의 병렬 빈번한 업데이트를 피하라.

## 13. 동기 vs 비동기 Apex 콜아웃
**질문:** 동기 vs 비동기 Apex 콜아웃의 차이와 각각 언제 쓰는지 설명하라.
**답변:** 동기: 실시간 사용자 컨텍스트에서 발생, 응답 기대, UI 주도 작업(스크린 Flow)에 사용. 비동기(Future, Queueable, Batch): 논블로킹, 대용량이나 서드파티 지연에 적합, @future는 반환값 불가.
**팁:** 체인·배치 콜아웃에 Queueable Apex / 트리거 안 동기 콜아웃을 피하라.

## 14. AWS EventBridge와 Salesforce 통합
**질문:** AWS EventBridge로 Salesforce 이벤트 기반 통합을 어떻게 가능하게 하나?
**답변:** Change Data Capture → CometD → AWS Lambda → EventBridge. 또는 MuleSoft나 Heroku → Webhook → Lambda → EventBridge 흐름.
**팁:** 회복탄력성을 위해 Event Replay ID 사용 / 실시간이 중요하지 않으면 선언적 통합에 AWS AppFlow 고려.

## 15. Salesforce Connect의 한계
**질문:** Salesforce Connect의 한계와 커스텀 API 통합 대비 언제 쓰나?
**답변:** 한계: 트리거/Apex 로직 불가, 외부 소스 응답성에 묶인 성능, 제한된 오프라인 기능. 참조 데이터나 경량 통합에 Salesforce Connect 사용.
**팁:** 고성능이나 복잡한 워크플로우에는 커스텀 API를 구축하라.

## 16. 외부 API 통합의 오류 처리 설계
**질문:** 외부 API 통합의 오류 처리 프레임워크를 어떻게 설계하나?
**답변:** 중앙화된 로깅 프레임워크(커스텀 오브젝트나 외부 도구) 구현. 재시도 큐(커스텀 또는 Platform Events DLQ 패턴) 사용. 오류를 복구 가능 vs 복구 불가로 분류.
**팁:** Kafka/SQS 같은 메시징 시스템 사용 시 DLQ(Dead Letter Queue) 고려.

## 17. Salesforce에서 GraphQL vs REST API
**질문:** Salesforce 통합 맥락에서 GraphQL vs REST를 설명하라.
**답변:** REST: 고정된 응답, CRUD 작업에 좋음. GraphQL: 클라이언트가 필요한 필드 지정 가능, 페이로드 최적화·왕복 감소.
**팁:** 모바일이나 프런트엔드 중심 앱에 Salesforce GraphQL API(2024 기준 파일럿) 사용.

## 18. 멀티-org Salesforce-to-Salesforce 통합
**질문:** 멀티-org Salesforce-to-Salesforce 통합을 어떻게 구현하나?
**답변:** 옵션: Salesforce-to-Salesforce(신규 설정엔 폐기), Platform Events + CDC + 미들웨어, org 간 MuleSoft나 커스텀 REST API.
**팁:** 실시간 동기화에는 이벤트 기반 아키텍처 선호.

## 19. 실시간 vs 배치 통합 최적화
**질문:** 성능과 신뢰성을 위해 실시간 vs 배치 통합을 어떻게 최적화하나?
**답변:** 실시간: CDC/Platform Events + 미들웨어. 배치: 대용량 트랜잭션에 Bulk API, 야간 스케줄.
**팁:** 중요+비중요 데이터에는 하이브리드 접근이 가장 좋다.

## 20. Salesforce 통합에서 Webhook 실패 처리
**질문:** Salesforce 통합에서 webhook 실패를 처리하는 최선의 접근은?
**답변:** 지수 백오프 재시도 구현. 실패한 페이로드 저장 → 수동/자동 재시도. 미들웨어 큐(Kafka, SQS) 사용.
**팁:** DLQ로 데이터 무손실 보장 / 지원되면 Replay ID(CDC) 사용.

---

# Part B. 개념 기반 Q&A (1~100)

## [통합 기초]

### 1. Salesforce에서 통합이란?
데이터 교환, 자동화, 프로세스 오케스트레이션을 가능하게 하기 위해 Salesforce를 외부 시스템과 연결하는 것. **팁:** 데이터 교환 + 프로세스 오케스트레이션을 언급하라.

### 2. Salesforce가 지원하는 통합 유형은?
API 기반(REST, SOAP, Bulk, Streaming), 이벤트 기반(Platform Events, CDC), 데이터 기반(Salesforce Connect/OData), UI 기반(Canvas, 외부 서비스 사용 LWC), 미들웨어 기반(MuleSoft, Informatica). **팁:** 항상 카테고리 + 예시를 쓰라.

### 3. 인바운드 vs 아웃바운드 통합 차이?
인바운드: 외부 시스템이 Salesforce API 호출. 아웃바운드: Salesforce가 콜아웃을 시작하거나 Outbound Message로 외부와 통신. **팁:** 예: "인바운드 → 외부 앱이 Salesforce 데이터 쿼리".

### 4. 동기 vs 비동기 통합 차이?
동기: 즉각 응답 기대, REST/SOAP API에 사용. 비동기: 나중에 실행, Platform Events·@future(callout=true)·Queueable Apex에 사용. **팁:** 대규모 프로젝트의 API 성능/확장성과 연결하라.

### 5. Salesforce의 흔한 통합 사용 사례는?
ERP 통합(주문 동기화), 마케팅 자동화(Salesforce → Marketo), 결제 게이트웨이 통합, 서드파티 리포팅(BI 도구), IoT·실시간 이벤트 추적. **팁:** 예시를 회사 도메인/산업에 맞춰라.

## [REST & SOAP API]

### 6. Salesforce에서 REST vs SOAP 차이?

| REST | SOAP |
|---|---|
| 경량 | 무거움(XML 기반) |
| JSON/XML | 엄격히 XML |
| 모바일에 쉬움 | 레거시 시스템 |

**팁:** REST → 신규 시스템 / SOAP → 레거시 ERP/CRM.

### 7. Apex에서 REST API 콜아웃을 어떻게 하나?
HttpRequest 사용, 엔드포인트·메서드 설정, 헤더 추가, Http.send()로 전송.
```apex
HttpRequest req = new HttpRequest();
req.setEndpoint('https://api.example.com/data');
req.setMethod('GET');
Http http = new Http();
HttpResponse res = http.send(req);
```
**팁:** 엔드포인트 인가에 Remote Site Settings/Named Credentials를 언급하라.

### 8. Apex의 HttpRequest와 HttpResponse란?
HttpRequest: HTTP 콜아웃을 구성. HttpResponse: 콜아웃의 응답(상태 코드, 본문, 헤더) 보유. **팁:** 상태 코드 → 성공/실패 처리를 설명하라.

### 9. WSDL이란? Apex에서 SOAP 웹 서비스를 어떻게 소비하나?
WSDL은 SOAP 웹 서비스의 XML 설명. Salesforce에서 "Generate Apex from WSDL"로 WSDL 업로드 → SOAP 호출용 Apex 스텁/클래스 생성. **팁:** "wsdl2apex" 도구를 언급하라.

### 10. REST 응답의 흔한 상태 코드는?
200 OK(성공), 201 Created(리소스 생성), 400 Bad Request(검증 오류), 401 Unauthorized(인증 실패), 500 Internal Server Error(외부 서버 실패). **팁:** 401 → OAuth 토큰 만료 시나리오를 설명하라.

### 11. @future(callout=true) vs Queueable 콜아웃 차이?
@future(callout=true): 경량, 메서드당 콜아웃 하나, 체인 불가. Queueable: 복잡한 로직, 체이닝, 더 큰 페이로드 지원. **팁:** 복잡·의존 콜아웃엔 Queueable 선호.

### 12. API 페이로드에서 JSON vs XML 차이?

| JSON | XML |
|---|---|
| 경량 | 장황 |
| 파싱 빠름 | 강한 타이핑 |
| REST 친화적 | SOAP 표준 |

**팁:** 현대 API에는 JSON 선호.

### 13. Workbench의 REST Explorer란?
브라우저에서 직접 REST API 요청(GET, POST, PATCH, DELETE)을 테스트하는 Workbench 도구. **팁:** 빠른 API 디버깅에 유용.

### 14. REST 콜아웃에서 인증을 어떻게 처리하나?
OAuth 2.0 Bearer Token(표준), Basic Authentication(base64 username:password), API Key(해당 시). **팁:** 보안을 위해 OAuth + Named Credentials 선호.

### 15. Remote Site Setting이란? 언제 쓰나?
Apex 콜아웃을 위해 외부 엔드포인트를 화이트리스트하는 설정. 없으면 Salesforce가 외부 HTTP 요청을 차단. **팁:** 안전·관리형 엔드포인트엔 Named Credentials가 더 나은 대안.

## [인증 & 보안]

### 16. Salesforce의 OAuth 2.0란?
인증 후 액세스 토큰을 제공해 안전한 API 접근을 가능하게 하는 인가 프레임워크. **팁:** 실제 사용자 자격 증명 공유 없이 접근함을 강조하라.

### 17. Salesforce에서 사용 가능한 OAuth 흐름은?
Authorization Code Flow, JWT Bearer Token Flow, Client Credentials Flow, Username-Password Flow, Device Authentication Flow. **팁:** JWT Bearer → 서버 간 통합에 최적임을 강조하라.

### 18. JWT vs Web Server OAuth 흐름 차이?
JWT Flow: 서버 간, 헤드리스, 사용자 상호작용 없음. Web Server Flow: 인가 코드 grant와 리다이렉트 URI 필요, 사용자 기반 통합에 적합. **팁:** JWT → 머신 간 사용 사례.

### 19. 외부 API 호출용 자격 증명을 어떻게 안전하게 저장하나?
Named Credentials(권장), Protected Custom Metadata Types(커스텀 로직 시), Encrypted Custom Settings(레거시). **팁:** Named Credentials + Auth Provider → 베스트 프랙티스.

### 20. Named Credential이란? 왜 선호되나?
외부 시스템을 위한 Salesforce 관리형 인증 메커니즘. 엔드포인트 + 인증을 추상화해 단순·안전. **팁:** OAuth 2.0으로 토큰 갱신이 자동 처리됨을 언급하라.

### 21. Named Credentials를 Auth Provider와 어떻게 쓰나?
Auth Provider가 OAuth 엔드포인트를 구성하고, Named Credential이 그 Auth Provider에 연결. 함께 쓰면 Salesforce가 토큰 갱신을 처리하는 안전한 API 접근 가능. **팁:** Salesforce가 토큰 생애주기를 관리함을 언급하라.

### 22. 만료된 액세스 토큰을 어떻게 갱신하나?
Named Credential + Auth Provider 사용 시 Salesforce가 자동 처리. 수동이면 refresh token으로 OAuth 토큰 엔드포인트에 POST 호출. **팁:** 자동화 → Named Credential 접근을 권하라.

### 23. Access Token vs Refresh Token 차이?

| 토큰 | 목적 |
|---|---|
| Access Token | 임시 API 접근 부여(단기) |
| Refresh Token | 새 Access Token 획득에 사용 |

**팁:** Access Token 만료 → Refresh Token으로 재인증.

### 24. Auth Provider vs Named Credential 차이?
Auth Provider: OAuth/OpenID Connect 세부(인가 엔드포인트, scope 등) 정의. Named Credential: Salesforce가 호출할 위치(엔드포인트 URL)와 방법(인증 방식) 정의. **팁:** 함께 → 완전한 안전 통합 설정.

### 25. CSP Trusted Site란?
URL 화이트리스트로 Lightning 컴포넌트가 외부 리소스(API, 스크립트)에 접근하게 하는 Content Security Policy 신뢰 사이트. **팁:** LWC가 서드파티 API/스크립트를 가져올 때 중요.

## [Outbound Messaging]

### 26. Salesforce의 Outbound Messaging이란?
레코드 변경 시 외부 시스템에 SOAP 메시지를 보내는 포인트앤클릭 자동화 기능. Workflow Rule이나 Process Builder(현재 Flow로 대체)와 동작, XML로 지정 엔드포인트에 전달. **팁:** SOAP만 동작 / 외부에 리스너 필요 / 복잡한 통합엔 비권장, Platform Events나 API 콜아웃이 더 낫다.

### 27. Outbound Messaging을 어떻게 구성하나?
Setup → Outbound Messages → 신규 생성 → 오브젝트 선택 → 필드 선택 → 엔드포인트 URL 제공 → 필드 매핑 → 저장. 마지막에 Workflow Rule이나 Process Builder와 연결. **팁:** 외부 시스템에서 Salesforce IP 화이트리스트 / 외부 엔드포인트는 성공/실패 SOAP 응답을 반환해야 함.

### 28. Outbound Messaging의 장단점은?
장점: 선언적 설정, 자동 재시도, 코드 불필요. 단점: SOAP만, 재시도 전략 제어 불가, 제한된 유연성, 복잡한 비즈니스 로직 처리 불가. **팁:** 단순·경량·fire-and-forget 사례에만 쓰라.

### 29. Outbound Messaging에서 엔드포인트가 다운되면?
Salesforce가 최대 24시간 재시도. 이후에도 다운이거나 확인이 실패하면 메시지 폐기. **팁:** Setup → Outbound Messages → View Delivery Status로 모니터링 / 더 나은 재시도엔 Platform Events 고려.

### 30. 실패한 Outbound Message를 재시도할 수 있나?
Salesforce가 최대 24시간 자동 재시도. 수동 재시도는 Setup → Outbound Messages → Delivery Status → Retry. **팁:** 외부에 멱등 엔드포인트 구현 / 신뢰성이 중요하면 Platform Events나 미들웨어 사용.

## [Apex 콜아웃 (실시간)]

### 31. 트리거에서 콜아웃을 어떻게 하나(베스트 프랙티스)?
트리거에서 직접 콜아웃 불가. @future(callout=true)나 Queueable Apex 메서드로 비동기 처리. **팁:** 더 나은 제어·체이닝·복잡 로직 때문에 @future보다 Queueable 선호 / 필요 없으면 벌크 콜아웃을 피하라.

### 32. Apex 콜아웃을 어떻게 테스트하나?
Test.setMock()으로 모의 응답 제공, 실제 외부 요청 회피. **팁:** HttpCalloutMock 인터페이스 사용 / Test.startTest()·stopTest()에서 mock 설정.

### 33. Test.startTest()와 Test.setMock()의 용도는?
Test.startTest()는 거버너 한도를 리셋하고 테스트 부분을 격리. Test.setMock()은 테스트 중 Apex 콜아웃용 모의 HTTP 응답 객체 설정. **팁:** 함께 써서 명확·격리·한도 준수 테스트 실행.

### 34. 콜아웃의 HTTP 헤더를 어떻게 설정하나?
HttpRequest 객체에 req.setHeader('Header-Name', 'Header-Value')로 Authorization·Content-Type 등 커스텀 헤더 설정. **팁:** Authorization 헤더엔 Bearer 토큰 / JSON 페이로드엔 Content-Type: application/json.

### 35. 한 트랜잭션에서 여러 콜아웃을 할 수 있나?
예, 트랜잭션당 최대 100개 콜아웃 허용. **팁:** 한도 내 유지하도록 콜아웃을 신중히 벌크화 / LWC·VF의 장시간 콜아웃엔 Continuation 고려.

### 36. 트랜잭션당 콜아웃 한도는?
Apex 트랜잭션당 100개, 동기 누적 응답 최대 6MB·비동기 12MB. **팁:** 대용량엔 배칭 / 무거운 콜아웃 처리는 Queueable Apex나 Platform Events로 오프로드.

### 37. 벌크 작업에서 콜아웃 한도를 어떻게 피하나?
Queueable Apex로 레코드당 콜아웃 하나를 enqueue하거나 Batch Apex로 데이터를 청크 분할. 전송 전 데이터 통합 로직 구현. **팁:** 다중 콜아웃 오케스트레이션에 미들웨어(MuleSoft, Boomi) / 트리거에서 직접 콜아웃 금지.

### 38. Continuation이란? LWC 콜아웃에서 언제 쓰나?
Apex 스레드 실행 시간을 소비하지 않고 장시간 HTTP 콜아웃을 비동기 처리하기 위해 Visualforce나 Aura에서 사용. LWC는 Aura를 브리지로 한 Apex Continuation 사용. **팁:** 5초 초과 콜아웃에 사용 / LWC에 아직 네이티브 미지원, Aura 래퍼 필요.

### 39. Platform Events로 콜아웃을 할 수 있나?
예, Platform Event Trigger로 Queueable Apex나 @future(callout=true) 호출. **팁:** Platform Events → Apex Trigger → Queueable Apex → HTTP Callout / 통합 분리에 유용.

### 40. Apex에서 API 요청·응답을 어떻게 로깅하나?
커스텀 오브젝트에 요청·응답·상태·타임스탬프 저장. 실시간 로깅에 Platform Events나 외부 모니터링 도구 활용. **팁:** 비밀번호·토큰 같은 민감 데이터 로깅 금지 / 대용량엔 Event Monitoring이나 Splunk 같은 외부 로깅.

## [미들웨어와 도구]

### 41. Salesforce 통합에 흔히 쓰이는 미들웨어 도구는?
MuleSoft(Anypoint Platform), Dell Boomi, Informatica Cloud, Jitterbit, Zapier(단순 사례). **팁:** 복잡도에 따라 선택: 엔터프라이즈는 MuleSoft, ETL/ESB는 Boomi/Informatica, 경량 자동화는 Zapier.

### 42. Salesforce에서 MuleSoft의 역할은?
API-led connectivity 접근, 다중 시스템 오케스트레이션, API 게이트웨이, 재사용 커넥터로 확장 가능한 통합 제공. **팁:** 엔터프라이즈·멀티클라우드·멀티org 통합에 탁월 / Salesforce-레거시 통합의 선호 선택.

### 43. Dell Boomi나 Informatica를 Salesforce와 어떻게 쓰나?
Salesforce가 REST/SOAP·Bulk API를 노출하면 사전 빌드 커넥터로 이 ETL/ESB 도구가 소비. 개발자가 미들웨어 팀과 협력해 오브젝트·필드 매핑. **팁:** 대용량엔 Bulk API / 데이터 거버넌스·오류 처리 전략과 정렬.

### 44. Heroku Connect란? 언제 쓰나?
Salesforce와 Heroku Postgres DB 간 데이터를 동기화해 Heroku 호스팅 앱이 준실시간으로 Salesforce 데이터를 다루게 함. **팁:** Salesforce 데이터 접근이 필요한 커스텀 앱에 유용 / 대용량 읽기나 밀결합 웹/모바일 앱에 최적.

### 45. ETL vs ESB?
ETL(Extract, Transform, Load): 대용량 배치 처리(예: Informatica). ESB(Enterprise Service Bus): MuleSoft 같은 실시간·이벤트 기반 오케스트레이션 워크플로우. **팁:** ETL → 데이터 마이그레이션·정제·배치 / ESB → 실시간 API·복잡 오케스트레이션·마이크로서비스.

## [Platform Events & Streaming]

### 46. Salesforce의 Platform Event란?
Salesforce와 외부 시스템 간 실시간 통신을 가능하게 하는 이벤트 기반 아키텍처 컴포넌트. CometD 프로토콜의 발행-구독 모델. **팁:** 분리된 통합 패턴에 사용 / 표준·고볼륨·커스텀 이벤트 지원.

### 47. Platform Events를 어떻게 발행·구독하나?
발행: Apex EventBus.publish(), Flow, REST API. 구독: Apex Trigger, 외부 앱의 CometD, EMP Connector를 통한 CDC. **팁:** org 내 처리엔 Apex 트리거 / 외부 구독엔 CometD(EMP Connector).

### 48. Platform Events vs CDC 차이?
Platform Events: 커스텀, 개발자 정의, 이벤트 기반. CDC: Salesforce 레코드 변경(생성·갱신·삭제·복원) 추적. **팁:** 커스텀 알림엔 Platform Events / 데이터 복제·동기화엔 CDC.

### 49. CometD와 Streaming API의 용도는?
CometD는 Bayeux 프로토콜 구현으로 외부 시스템에서 PushTopic·Platform Events·CDC 이벤트 같은 Streaming API 채널을 구독. **팁:** Java 구현엔 EMP Connector / Streaming API → 준실시간, 리소스 효율적.

### 50. 최대 이벤트 리플레이 윈도우는?
replay ID로 발행 후 최대 72시간 리플레이 가능. **팁:** 중요 이벤트엔 durable subscriber 구현 / 72시간 후엔 외부 아카이브 없이는 복구 불가.

### 51. durable vs non-durable subscriber 차이?
Durable subscriber는 replay ID를 저장해 다운타임 중 놓친 이벤트를 가져옴. Non-durable subscriber는 연결 중 라이브 이벤트만 수신. **팁:** 신뢰성 있는 전달엔 항상 durable subscriber / 외부 시스템이 마지막 replay ID 관리.

### 52. Platform Events로 Salesforce를 Kafka와 어떻게 통합하나?
CometD 프로토콜(Streaming API)이나 EMP Connector로 Platform Events 구독, 커넥터·커스텀 서비스로 Kafka 토픽에 스트리밍. **팁:** 엔터프라이즈엔 Confluent Kafka Connect나 MuleSoft Kafka 커넥터 / 필요시 Kafka 파티션으로 메시지 순서 보장.

### 53. EMP Connector의 용도는?
EMP(Event Monitoring Platform) Connector는 CometD 기반 Java 라이브러리로 PushTopic·Platform Events·CDC 같은 Streaming API 채널을 구독. **팁:** Salesforce 이벤트와 커스텀 Java 통합 구축 시 사용 / replay ID로 durable 구독 지원.

### 54. 전달되는 이벤트 수 한도는?
Enterprise Events → 24시간당 5만 이벤트(애드온으로 증가). High-Volume Events → 하루 수백만(높은 처리량, 제한된 기능). **팁:** 대규모엔 High-Volume Platform Events / Setup에서 Event Usage Metrics 확인.

### 55. 구독자에서 이벤트 순서를 어떻게 처리하나?
Salesforce는 이벤트 순서를 보장하지 않음. 페이로드의 버전 필드/타임스탬프로 커스텀 시퀀싱하고 소비자 앱(Kafka Consumer)에서 순서 로직 처리. **팁:** 순서 일관성을 위해 마지막 처리 replay ID 저장 / 순서 처리에 Kafka 파티셔닝.

## [통합 패턴]

### 56. 흔한 Salesforce 통합 패턴은?
5가지 주요 패턴: (1) Remote Process Invocation – Request and Reply(실시간 동기), (2) Remote Process Invocation – Fire and Forget(비동기, 응답 불필요), (3) Batch Data Synchronization(스케줄·대용량 이동), (4) Remote Call-In(외부가 Salesforce API 호출), (5) UI Update Based on Data Changes(이벤트 기반, Streaming API·Platform Events). **팁:** Salesforce "Enterprise Integration Patterns" 가이드 참조 / 선택은 실시간 필요·볼륨·결합도에 의존.

### 57. Request and Reply는 언제 쓰나?
Salesforce가 외부 시스템을 실시간 호출하고 트랜잭션 진행을 위해 즉각 응답을 기다려야 할 때. 예: 주문 생성 중 실시간 카드 검증이나 재고 확인. **팁:** 트리거에서 직접 콜아웃 회피, 필요시 Platform Events/Queueable / 외부 의존성에 타임아웃 처리.

### 58. Remote Call-In이란?
외부 시스템이 Salesforce API(REST/SOAP/Bulk)를 호출해 데이터를 읽거나 쓰는 패턴. 외부 시스템이 통신을 시작할 때(고객 대면 모바일 앱, 데이터를 푸시하는 외부 ERP) 이상적. **팁:** OAuth 2.0로 API 보호 / API rate limit과 캐싱 최적화 언급.

### 59. Fire and Forget vs Request & Reply 차이?
Request & Reply: Salesforce가 외부 응답을 기다린 후 진행, 즉각 의사결정에 사용. Fire and Forget: 응답을 기다리지 않고 비동기 요청, 예: 감사용 로그 전송. **팁:** Fire and Forget은 확인이 선택적인 비중요 액션에 좋음 / @future(callout=true)나 Queueable로 구현.

### 60. Batch Data Synchronization 패턴이란?
스케줄·주기적으로 대용량 데이터를 동기화. 예: 매일 밤 Salesforce 연락처를 ERP 고객 레코드와 동기화. **팁:** 대용량엔 Bulk API나 Data Loader / 부분 실패는 재시도 로직 / 데이터 스큐·rate limit 고려.

### 61. 고볼륨·느슨한 결합 시스템엔 어떤 패턴?
Batch Data Synchronization이나 Pub/Sub(Platform Events/CDC)가 이상적. Batch는 주기적 대용량 적재, Pub/Sub는 낮은 의존성의 준실시간 갱신. **팁:** 분리에 MuleSoft·Kafka 같은 미들웨어 / 세밀한 변경 추적엔 CDC.

### 62. 모바일 통합엔 어떤 패턴이 최선?
REST API를 쓰는 Remote Call-In이 이상적(REST는 경량·모바일 친화). Salesforce→모바일 실시간 갱신엔 Streaming API나 Platform Events 권장. **팁:** 성능에 캐싱 / 인증엔 OAuth 2.0, 모바일엔 User-Agent flow 선호.

### 63. UI Update Based on Data Changes란?
백엔드 데이터 변경에 따라 UI가 자동 갱신되는 이벤트 기반 패턴. 예: Platform Events나 Streaming API(PushTopic/Generic Events)로 클라이언트에 알림. **팁:** LWC는 empApi로 Platform Events 구독 지원 / 실시간 갱신이 필요한 Console·서드파티 앱에 유용.

### 64. Data Virtualization이란?
Salesforce에 물리적으로 저장하지 않고 외부 데이터를 실시간으로 보고 상호작용. Salesforce Connect와 External Object로(주로 OData) 달성. **팁:** Salesforce 데이터 저장 비용 절감에 좋음 / 외부 데이터는 구성·OData 버전에 따라 읽기 전용/읽기-쓰기.

### 65. Pub/Sub vs Point-to-Point 차이?
Pub/Sub: 여러 구독자가 발행자로부터 메시지 수신(Platform Events, Kafka). Point-to-Point: 시스템 간 일대일 통신(Salesforce→특정 외부 시스템 REST 호출). **팁:** Pub/Sub은 이벤트 기반·확장성에 좋음 / Point-to-Point는 단순하나 밀결합.

## [데이터 통합 (ETL, CDC)]

### 66. 두 Salesforce org 간 데이터를 어떻게 동기화하나?
(1) Salesforce-to-Salesforce(폐기), (2) Platform Events(실시간), (3) CDC(레코드 수준 변경), (4) 커스텀 API(REST/SOAP), (5) 미들웨어(MuleSoft, Boomi). 실시간엔 CDC+미들웨어나 Platform Events, 주기적 대용량엔 Batch Data Synchronization 선호. **팁:** org 간 레코드 ID 매핑 처리 / 매칭에 External ID / 데이터 일관성·충돌 해결 로직 고려.

### 67. Salesforce Connect란?
Salesforce에 저장 없이 외부 데이터에 실시간 접근. External Object를 외부 데이터 소스(DB, SAP, SharePoint)에 매핑, 주로 OData 2.0/4.0. **팁:** 저장이 불필요할 때 이상적 / 빈번한 갱신이 필요한 대용량엔 부적합, 읽기 중심 시나리오가 최적 / Indirect lookup으로 표준 오브젝트와 관계.

### 68. Salesforce Connect vs Platform Events 차이?
Salesforce Connect: 풀(pull) 기반, 외부에서 온디맨드 쿼리, 데이터 가상화용. Platform Events: 푸시(push) 기반, 실시간 이벤트 알림, 이벤트 기반 아키텍처(Pub/Sub)에 좋음. **팁:** Connect = 온디맨드 읽기 / Platform Events = 실시간 알림.

### 69. External Object란?
표준/커스텀 오브젝트와 유사하나 Salesforce 외부 데이터를 표현. Salesforce 스키마에 정의되지만 데이터는 OData로 외부에서 라이브 조회. **팁:** Salesforce Connect와 함께 사용 / Indirect/External Lookup으로 관계 지원 / ERP·외부 DB 데이터를 Salesforce UI에 표시하는 데 좋음.

### 70. OData란? Salesforce에서 어떻게 쓰나?
OData(Open Data Protocol)는 RESTful API 생성·소비 표준 프로토콜. Salesforce는 Salesforce Connect와 함께 OData 2.0·4.0으로 외부 소스에 연결. **팁:** 고급 기능 지원하는 OData 4.0 선호 / 제공자 역량에 따라 읽기 전용/읽기-쓰기 / OData 서비스가 인증(Basic, OAuth) 지원 확인.

### 71. Salesforce Connect의 indirect lookup이란?
부모의 매칭 External ID 필드로 External Object를 표준/커스텀 오브젝트에 연결하는 관계. 외부 데이터가 Salesforce 레코드 ID가 아닌 참조를 가질 때 유용. 예: External_Account_ID__c로 Salesforce Account를 참조하는 외부 Invoice__x. **팁:** External Object에 Salesforce External ID와 매칭되는 필드 필요 / 성능 위해 External ID 인덱싱.

### 72. Google Sheets나 Excel과 어떻게 통합하나?
Google Sheets: App Script + REST API(커스텀), Salesforce Connector for Sheets(공식 애드온). Excel: Office Excel 플러그인, Power Query + Salesforce API, Zapier·MuleSoft 같은 미들웨어. **팁:** 안전 접근에 Named Credentials·OAuth / 대용량 REST엔 rate limit 처리 / 공개 시트에 민감 데이터 동기화 회피.

### 73. Change Data Capture(CDC)란?
Salesforce 레코드 변경(생성·갱신·삭제·복원)을 준실시간으로 캡처해 외부에 푸시. Event Bus 기반, 리플레이 지원. 사용 사례: 외부 동기화, 감사 추적, 외부 워크플로우 트리거. **팁:** 표준·커스텀 오브젝트 가능 / 구독자는 EMP Connector·CometD·미들웨어 / 이벤트 보존 최대 72시간(replayId 기반).

### 74. CDC vs Platform Events 차이?

| CDC | Platform Events |
|---|---|
| DML 시 자동 발행 | 커스텀 발행 |
| 표준·커스텀 오브젝트 | 완전 커스텀 스키마 |
| CRUD 변경 캡처 | 비즈니스 이벤트 발생 |
| 변경 헤더 메타데이터 보유 | before/after 미포함 |

**팁:** 레코드 변경을 외부에 미러링하려면 CDC / 도메인·비즈니스 이벤트 모델(OrderPlaced, PaymentFailed)엔 Platform Events.

### 75. Shield Event Monitoring이란?
Salesforce Shield의 일부로 사용자 활동(로그인, 데이터 익스포트, API 호출, 리포트 실행)을 감사 수준으로 추적. EventLogFile 오브젝트로 전달, API나 스트리밍 접근. **팁:** 보안 감사·이상 탐지·컴플라이언스에 유용 / Splunk·SIEM·Event Monitoring Analytics App과 결합 / Salesforce Shield 라이선스 필요.

## [오류 처리 & 디버깅]

### 76. 실패한 API 콜아웃을 어떻게 처리하나?
(1) Apex try-catch, (2) 커스텀 오브젝트에 오류 상세(상태 코드, 응답 본문) 로깅, (3) Queueable·Platform Events로 재시도, (4) HTTP 상태 코드 기반 처리(타임아웃, 500 등). **팁:** 재시도에 Exponential Backoff / 외부 추적에 Request ID/Correlation ID 로깅 / 반복 실패에 알림.

### 77. 실패한 API 호출을 어떻게 추적하나?
Integration Log 오브젝트로 커스텀 로깅 프레임워크: 엔드포인트 URL, 상태 코드, 요청 본문, 응답 본문, 타임스탬프, 재시도 횟수 캡처. Platform Events로 Splunk·ELK에 외부 스트리밍. **팁:** 로그에 민감 데이터 저장 회피 / 필요시 Shield Platform Encryption / 콜아웃 엔드포인트에 Named Credentials.

### 78. Apex 콜아웃 최대 타임아웃 한도는?
HTTP 콜아웃 최대 타임아웃 120초(2분).
```apex
req.setTimeout(120000);
```
**팁:** 장시간 통합엔 Continuation(비동기) 고려 / 불필요한 실행 시간 소비를 피하려 짧은 타임아웃 선호.

### 79. 통합 재시도 메커니즘을 어떻게 구축하나?
(1) Queueable Apex + 페이로드 저장 커스텀 오브젝트, (2) 재시도 횟수·간격 필드, (3) Exponential Backoff, (4) 영구 실패용 DLQ 개념, (5) 비동기 알림용 Platform Events. **팁:** 무한 루프 방지로 재시도 횟수 제한 / 최종 실패 후 관리자 팀에 알림 / 복잡한 재시도엔 미들웨어.

### 80. 콜아웃을 어떻게 로깅·감사하나?
Salesforce에 커스텀 로깅 테이블(Integration Logs) 구현, Platform Events·Heroku Logging·Splunk·Datadog 같은 SIEM으로 외부 스트리밍. Salesforce Shield 사용 시 Field Audit Trail로 최대 10년 보존. **팁:** 여러 시스템 로그 중앙화 / User Context·Session ID·Correlation ID 포함 / 페이로드 민감 부분 암호화.

## [통합 사용 사례 (실무)]

### 81. 결제 게이트웨이와 어떻게 통합하나?
Stripe와 REST API로 통합했다. 결제 로그용 External Object, 인증에 Named Credentials. LWC가 Apex로 결제 API를 트리거(토큰화, charge 생성, 레코드 갱신). 성공/실패 콜백 같은 비동기 알림엔 Platform Events. **팁:** 아웃바운드엔 Apex / 비동기 콜백엔 Platform Events나 Webhook / 민감 데이터 보안(PCI 준수, 카드번호 저장 회피).

### 82. 서드파티 REST API 통합 시나리오를 설명하라
물류 제공자의 REST API와 통합해 배송 상태를 추적했다. Apex가 인증된 GET으로 추적 정보를 주기적으로 가져옴. 배치 작업을 스케줄해 갱신을 폴링하고 커스텀 Shipment__c 갱신. 인증엔 OAuth 2.0 Named Credential. **팁:** 인증(API key, OAuth) / 오류 처리·재시도 / 빈번한 폴링 시 거버너 한도.

### 83. REST API에서 페이지네이션을 어떻게 처리하나?
API 설계에 따라 offset 또는 cursor 기반 페이지네이션. Apex에서 응답을 루프하며 nextPageToken/offset이 없을 때까지. 콜아웃 한도 회피를 위해 요청을 일시정지/배치. **팁:** 페이지네이션 모델(offset vs cursor) 이해 / 대용량엔 배치 클래스 / rate limiting 처리.

### 84. Google Maps API와 어떻게 통합하나?
JavaScript와 Google Maps SDK로 Lightning 컴포넌트에 Google Maps 통합. Salesforce 주소 필드를 전달해 지오로케이션을 가져오고 마커로 지도 표시. Apex 콜아웃으로 Google Geocoding API 역조회. **팁:** 프런트엔드 지도엔 LWC / 지오코딩·REST엔 Apex / API key 노출 금지, Named Credential이나 protected custom metadata 사용.

### 85. Salesforce와 Marketo 간 리드를 어떻게 동기화하나?
Marketo-Salesforce 커넥터로 리드·연락처·활동 동기화. 커스텀 동기화엔 Marketo REST API와 Apex 콜아웃. 리드 갱신 시 Platform Event를 발행해 미들웨어로 Marketo에 알림. **팁:** 리드 생애주기 정렬 / 커스텀 동기화엔 MuleSoft / 데이터 볼륨·동기화 빈도 고려.

### 86. Salesforce와 SAP 통합 시 겪은 도전은?
가장 큰 도전은 SAP의 SOAP API와 데이터 변환. MuleSoft로 SOAP→REST 변환 후 Salesforce와 통합. ID 매핑·벌크 동기화 이슈는 중간 스테이징 테이블로 해결. **팁:** 데이터 모델 차이 강조 / 프로토콜 변환에 미들웨어 / 대용량·성능 병목 주의.

### 87. Salesforce와 WhatsApp/SMS 서비스를 어떻게 통합하나?
Twilio API 사용. Apex에서 Named Credential로 Twilio REST 엔드포인트 호출. WhatsApp은 승인된 번호로 템플릿 메시지 전송. 수동 SMS·자동 메시지용 LWC 인터페이스를 Flow·Invocable Apex로 구축. **팁:** Twilio·Kaleyra·Vonage 같은 메시징 플랫폼 / DND·옵트인/아웃 규정 준수 / 대용량엔 비동기 콜아웃.

### 88. Salesforce와 ERP 간 양방향 동기화를 어떻게 설정하나?
MuleSoft로 양방향 동기화 오케스트레이션. Salesforce 측은 CDC로 ERP에 갱신 푸시. ERP가 REST API를 노출하고 MuleSoft가 호출해 데이터 푸시/풀. 레코드 추적·충돌 해결에 UUID. **팁:** 아웃바운드엔 CDC, 인바운드엔 Platform Events / 동기화 로직 중앙화에 미들웨어 / 멱등성·충돌 해결 보장.

### 89. 배치와 실시간을 함께 쓴 복잡한 통합을 설명하라
금융 시스템과 통합했다. 실시간 API 콜아웃이 트랜잭션 처리, 배치 Apex가 야간 리포트 풀. 실시간 실패를 추적하는 커스텀 로깅 오브젝트로 배치 작업에서 재실행. **팁:** 중요 작업엔 실시간, 볼륨 처리엔 배치 / 실패 로깅·모니터링 / 동기화 재시도는 스마트·멱등.

### 90. 레거시 시스템 통합 시 고려할 점은?
레거시는 현대 API가 없는 경우가 많아 SFTP·배치 작업의 파일 기반 통합 사용. 고정 데이터 형식·인증 표준 부재·긴 처리 시간 대응. 프로토콜 변환·오류 버퍼링에 미들웨어 도입. **팁:** 비동기·파일 기반 전송 계획 / 프로토콜 격차 연결에 미들웨어 / 회복탄력성·데이터 무결성 테스트.

## [메타데이터, 배포 & 한도]

### 91. 통합에 관련된 메타데이터는(예: Named Credential)?
Named Credentials(안전한 인증 엔드포인트 관리), External Data Sources(External Object용), Remote Site Settings(레거시), Auth Providers(OAuth 흐름), Custom Metadata(API key 안전 저장), External Service 등록 Flow. **팁:** 보안 위해 Remote Site Settings보다 Named Credential / 엔드포인트 변형엔 Custom Metadata·Custom Settings / 소스 컨트롤·Metadata API로 배포.

### 92. 통합을 change set으로 배포할 수 있나?
예, Named Credentials·Remote Site Settings·External Data Sources·Auth Providers 같은 많은 통합 메타데이터를 change set으로 배포 가능. 단 시크릿·OAuth 토큰은 배포 후 수동 재구성하거나 Salesforce DX 환경 변수로 처리. **팁:** 메타데이터엔 change set, 민감 정보는 수동 구성 / 큰 프로젝트엔 Salesforce DX CI/CD / 배포 후 단계 문서화.

### 93. 요청·응답 페이로드 최대 크기는?
Apex 콜아웃: HTTP 응답 최대 6MB(동기)·12MB(비동기). REST API 인바운드 요청: 호출당 최대 25MB. 더 큰 데이터셋엔 Bulk API. **팁:** 압축(GZIP)으로 페이로드 최적화 / 대용량엔 Bulk API나 External Object / 페이지네이션·청킹 구현.

### 94. 통합에서 고려할 흔한 거버너 한도는?
트랜잭션당 100 콜아웃, 6MB 동기 응답 한도, 10MB heap, 트랜잭션당 5만 SOQL 행. 배칭·재시도·비동기(Queueable, Batch Apex)로 설계. **팁:** 사전 처리에 Apex Limits 메서드 / 큰 작업을 작은 트랜잭션으로 분할 / 분리 처리에 Platform Events나 CDC.

### 95. External Service 정의 배포의 최선은?
External Service 정의는 메타데이터로 저장, Salesforce DX나 change set으로 배포. 실제 서비스 엔드포인트 URL·인증은 환경별로 다르므로 환경별 Custom Metadata나 Named Credentials에 저장. **팁:** 환경별 URL/구성은 Custom Metadata에 / 가능하면 SFDX 자동화 / 배포 후 바인딩 검증.

## [최신 트렌드 & 실시간 개념]

### 96. Salesforce External Services란? 어떻게 동작하나?
OpenAPI(Swagger) 명세를 가져와 외부 REST API를 선언적으로 소비. 등록 후 작업이 Flow·Apex의 invocable 액션이 됨. 스크린 Flow에서 배송 라벨 생성을 위해 배송 제공자 API와 통합에 사용. **팁:** Apex 없는 선언적 통합에 좋음 / OpenAPI 정의 정확성·버전 관리 / Flow와 결합해 관리자가 자동화 구축.

### 97. OpenAPI/Swagger를 Salesforce와 어떻게 쓰나?
OpenAPI(구 Swagger)는 REST API 기술 표준. External Services가 이 파일을 가져와 Flow의 named operation 생성. Apex 통합엔 엔드포인트·요청/응답 구조·인증 이해에 도움. **팁:** OpenAPI spec을 Git 버전 관리 / SwaggerHub·Postman으로 생성·테스트 / 개발 중 JSON 스키마 검증.

### 98. MuleSoft Anypoint Platform이란?
Salesforce 소유의 통합 플랫폼. 시스템 연결, 데이터 변환, API 안전 노출. Salesforce·SAP·결제 제공자 간 통합 오케스트레이션, 변환·재시도·모니터링 중앙화에 사용. **팁:** 복잡한 다중 시스템 통합에 이상적 / 프로토콜 브리징(SOAP→REST, SFTP→HTTPS) / 단순 사례엔 MuleSoft Composer.

### 99. GraphQL이란? REST와 어떻게 다른가?
GraphQL은 클라이언트가 정확히 필요한 데이터를 요청하는 쿼리 언어. 고정 페이로드를 반환하는 REST와 달리 over-fetching·under-fetching 감소. Salesforce가 2024년 LWC용 GraphQL Wire Adapter를 출시해 네이티브 소비가 쉬워짐. 여러 소스의 결합 데이터를 효율적으로 가져오는 데 미들웨어와 함께 사용. **팁:** REST = 리소스 기반, GraphQL = 쿼리 기반 / 유연한 쿼리에 유용 / GraphQL introspection은 보안 위해 신중한 접근 제어 필요.

### 100. 2025년 Salesforce 통합 기능의 새로운 점은?
2025년 주요 강화: 네이티브 캐싱이 있는 LWC용 GraphQL 지원 개선, 레거시용 MuleSoft RPA 통합, 다중 OpenAPI 버전을 지원하는 External Services UI 강화, External API 분기가 있는 Flow Orchestration, 비-Salesforce 시스템으로의 아웃바운드 이벤트로 이벤트 기반 아키텍처 지원 강화. **팁:** Salesforce Release Notes 업데이트 / Trailhead 모듈로 신기능 실습.
