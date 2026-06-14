# SOAP API vs REST API

| 기능 | SOAP API | REST API |
|---|---|---|
| 표준 | 프로토콜(공식 표준) | 아키텍처 스타일(공식 표준 없음) |
| 표준 | HTTP·XML만 | URL·HTTP 등 다중 |
| 기능 | 표준 메시징 패턴 인터페이스 | 리소스 이름의 일관된 인터페이스 |
| 비즈니스 로직 | @WebService | @path("/CricketService") URL |
| 대역폭 | XML 페이로드(대용량) | 적은 대역폭·리소스 |
| 언어 | WSDL | WADL |
| 규칙 | 매우 중요(표준화) | 유연하나 표준화 필요 |
| 성능·확장성 | 읽기 캐시 불가 | 캐시 가능·우수 |
| 보안 | WS-Security 엔터프라이즈급 | 덜 안전 |
| 신뢰 메시징 | 비동기·보장 | 표준 없음(클라이언트 처리) |
| 원자적 트랜잭션 | ACID 지원 | 미지원 |
| 데이터 형식 | XML | JSON |

## SOAP API
- 다른 플랫폼·언어 간 상호운용성. 엔터프라이즈에서 인기.
- RESTful API 등장으로 사용 감소.
- 플랫폼·언어 독립. XML+HTTP 표준 형식.
- 메시지 구조화·데이터 교환 규칙 정의. HTTP·SMTP·TCP 전송.

## REST API
- Representational State Transfer. 느슨하게 연결된 앱, HTTP 프로토콜.
- 저수준 구현 미규정(개발자 커스터마이즈).
- RESTful 웹 서비스. GET·POST·PUT·DELETE 표준 HTTP 동사.
- XML·JSON·텍스트 요청/응답. JSON(경량)으로 SOAP보다 빠름.
