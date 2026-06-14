# Salesforce 통합 치트시트

## 1. 소개
Salesforce를 외부 시스템과 연결해 데이터 공유. 유형: Real-time(REST·SOAP), Batch(ETL), Middleware(MuleSoft·Informatica).

## 2. 핵심 용어
- **API:** 시스템 간 통신.
- **Endpoint:** API 접근 URL.
- **인증:** OAuth 2.0(권장), Username-Password.
- **웹 서비스:** REST(경량·JSON), SOAP(XML·복잡 트랜잭션).
- **Data Loader:** 벌크 import/export.
- **External Services:** OpenAPI 스펙으로 선언적 통합.

## 3. 도구·API
**REST API:** 경량, JSON/XML. `GET /services/data/v57.0/sobjects/Account/001xx... Authorization: Bearer <Token>`
**SOAP API:** XML, WSDL 필요. `<create><sObjects><type>Lead</type>...</sObjects></create>`
**Bulk API:** 대량 데이터. 1.0(CSV), 2.0(JSON).
**Streaming API:** 실시간 알림. PushTopic·Platform Events.
**도구:** Postman, Workbench, Data Loader.

## 4. 통합 디자인 패턴
- **Remote Process Invocation:** Request and Reply(응답 대기), Fire and Forget(대기 없음).
- **UI Update:** Platform Events·Change Data Capture.
- **Data Sync:** 미들웨어 양방향.
- **Data Virtualization:** Salesforce Connect·External Objects.

## 5. 보안
- **OAuth 2.0:** Grant Types(Authorization Code·Client Credentials·Refresh Token), Scopes.
- **Named Credentials:** 엔드포인트·자격 증명 관리 단순화.
- **Shield Platform Encryption:** 민감 데이터 암호화.

## 6. 오류 처리·디버깅
- **HTTP 상태 코드:** 200(성공), 401(인증), 500(서버).
- **도구:** Debug Logs, Postman, Workbench.

## 7. 모범 사례
- **거버너 한도:** API 일 100,000회(Enterprise), 벌크화.
- **데이터:** External ID upsert, soft delete.
- **버전:** API 버전 항상 지정.
- **모니터링:** API 사용 알림, Event Monitoring.

## 8. 예시
**REST로 Account 조회:** `GET /services/data/v57.0/sobjects/Account/001xx...` → `{"Id":"...", "Name":"Acme Corporation", "Phone":"123-456-7890"}`
**워크플로우 Outbound Message:** 레코드 업데이트 시 외부 호출, 엔드포인트 URL 필요.

## 9. FAQ
- **REST vs SOAP?** REST는 경량·JSON, SOAP은 견고·XML.
- **통합 디버깅?** 디버그 로그·오류 코드·인증 검증.
