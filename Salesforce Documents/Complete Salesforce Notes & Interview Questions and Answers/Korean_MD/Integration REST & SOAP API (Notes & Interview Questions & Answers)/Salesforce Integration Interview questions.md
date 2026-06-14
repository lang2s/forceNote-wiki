# Salesforce 통합 면접 질문

**1. 통합이란?** 둘 이상의 애플리케이션 연결. 데이터·비즈니스 로직·표현·보안 계층 통합.

**2. 웹 서비스란?** 클라이언트-서버 통신 표준 매개체. 다양한 언어 앱 간 통신. 개방 표준(XML·SOAP·HTTP). 유형: SOAP, RESTful.

**3. JSON vs XML?** JSON은 경량·텍스트(JavaScript 객체 표기), XML은 구조화·태그 기반. JSON이 더 가볍고 파싱 빠름.

**4. REST API?** REST 아키텍처 제약 준수 API. 경량 요청/응답. XML·JSON 지원. URI로 리소스 참조, HTTP 메서드 접근.

**5. SOAP API?** W3C 메시징 표준. XML 데이터 형식. WSDL로 파라미터 정의. XML만. 서버 간 통합에 적합.

**6. SOAP vs REST?** SOAP은 프로토콜·XML·WSDL·WS-Security·엔터프라이즈. REST는 아키텍처·JSON/XML·경량·웹/모바일.

**7. 통합 옵션?** REST/SOAP API, Bulk, Streaming, Outbound Message, Apex Callout, Platform Events, Salesforce Connect, 미들웨어.

**8. WSDL?** 웹 서비스를 기술하는 XML 문서. Enterprise WSDL, Partner WSDL.

**9. SoapUI?** SOAP API 테스트 도구. Salesforce org 연결·표준 SOAP API 호출·응답 확인.

**10. Enterprise vs Partner WSDL?** Enterprise는 특정 org에 강타입(오브젝트·필드 반영), Partner는 약타입·범용(다중 org).

**11~12. 통합 패턴?** Request and Reply, Fire and Forget, Batch Data Sync, Publish-Subscribe, Data Virtualization, Smart Data Replication.

**13. Remote Site Settings?** 엔드포인트 인증·허용(콜아웃 화이트리스트).

**14. Connected App?** SAML·OAuth·OpenID Connect로 외부 앱이 Salesforce와 통합·인증·SSO하는 프레임워크.

**15. OAuth?** Open Authorization. 사용자명·비밀번호 제공 없이 보호 리소스 접근 액세스 토큰 획득 프레임워크.

**16. OAuth 2.0 플로우?** SAML Bearer Assertion, JWT Bearer Token, Refresh Token, Web Server Authentication, Username-Password, User-Agent, Device Authentication, Asset Token, SAML Assertion.

**17. JWT 플로우?** 실시간 사용자 개입 없는 서버 간 통합. JWT/SAML로 사용자 지정·서명. API 전용 앱(ETL·미들웨어)에 이상적.
**JWT 구조:** Header(알고리즘 `{"alg":"RS256"}`), Payload(claims: iss·aud·sub·exp), Signature(`<header>.<claims>.<signature>`).

**18. Web Service 플로우?** secret/private key를 보호할 수 있는 클라이언트-서버 앱이 리소스 접근. 웹 서버 호스팅 앱.

**19. Named Credentials?** 콜아웃 엔드포인트 URL과 인증 파라미터를 한 정의에. 인증 콜아웃 설정 단순화.

**20. OpenID Connect?** OAuth 2.0 위 신원 계층. 클라이언트가 인증 서버 기반으로 사용자 신원 검증·프로필 정보 획득.

**21. OpenID vs OAuth?** OpenID는 인증(신원 확인), OAuth는 권한 부여(리소스 접근).

**22. Streaming API?** push 기술로 이벤트 스트리밍·구독(근실시간). PushTopic·Generic·Platform Events·CDC.

**23. Change Data Capture?** 레코드 변경(생성·업데이트·삭제·복원)을 실시간 이벤트로 발행, 외부 데이터 동기화.

**24. Tooling API?** 커스텀 개발 도구·앱 구축. 메타데이터 SOQL(작은 단위 조회, 성능). SOAP·REST 인터페이스.

**25. Salesforce Connect?** 외부 소스 데이터를 복사 없이 External Object로 실시간 접근(웹 서비스 콜아웃).

**26. REST API Composite Resources?** 여러 요청을 단일 호출로(API 호출 한도 절감, 작업 간 의존성).
