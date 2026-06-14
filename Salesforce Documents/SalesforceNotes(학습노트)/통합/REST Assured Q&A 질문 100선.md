---
tags: [integration, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [100 REST API Interview Q&A]
---

# REST Assured Q&A 질문 100선

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## 일반 API 테스트
**API 테스트란?**

API를 직접·통합 테스트로 기능·신뢰성·성능·보안 검증.
**중요성?**

API가 기대대로 동작·안전·부하 처리 보장, 시스템 간 통신 신뢰성.
**API vs 단위 테스트?**

단위는 개별 컴포넌트, API는 전체 API(엔드포인트).
**API 테스트 유형?**

기능·부하·런타임 오류·보안·UI·침투·퍼즈 테스트.
**도구?**

Postman, SoapUI, JMeter, RestAssured, Swagger, Katalon Studio.

## REST Assured
**REST Assured란?**

RESTful API 테스트·검증 Java 라이브러리. DSL 제공.
**설정?**

Maven/Gradle에 의존성 추가.
**GET 요청·상태 코드 검증?**

`given().when().get(url).then().statusCode(200);`
**POST(JSON 본문)?**

`given().contentType("application/json").body(json).when().post(url);`

## HTTP 메서드·상태 코드
**메서드:**

GET, POST, PUT, DELETE, PATCH, OPTIONS, HEAD.
**상태 코드:**

200(성공), 201(생성), 400(잘못된 요청), 401(인증 필요), 404(없음), 500(서버 오류).

## 인증·권한
**Basic 인증?**

`given().auth().basic(user, pass)`.
**OAuth2?**

`given().auth().oauth2(token)`.
**인증 vs 권한?**

인증은 신원 확인, 권한은 허용 작업 결정.

## 요청·응답 명세
**Request Specification?**

base URI·헤더·인증 등 재사용 요청 구성.
**Response Specification?**

상태 코드·헤더·본문 등 재사용 응답 검증.

## 헤더·파라미터
헤더 추가: `given().header(...)`. 쿼리 파라미터: `given().queryParam(...)`. 쿠키: `given().cookie(...)`. 응답 헤더 검증: `then().header(...)`.

## 데이터 처리
JSON 배열 검증, 값 추출(`extract().path()`), 동적 데이터(플레이스홀더), 키 존재(`hasKey`), 중첩 JSON, 응답 시간(`time()`), XML 파싱, 리스트 특정 값(`hasItems`).

## 고급 기능
- Relaxed HTTPS: `RestAssured.useRelaxedHTTPSValidation();`
- 명세 재사용: @BeforeClass/@BeforeAll.
- 파일 업로드: `multiPart()`.
- 멀티파트 폼 데이터, 커스텀 역직렬화(ObjectMapper).
- 쿠키 추출, 리디렉션: `RestAssured.followRedirects = true;`
- 로그 파일: `RestAssured.config().logConfig()`.

## 오류 처리
예외: try-catch. 재시도: 루프·resilience4j. Rate limiting: 응답 헤더 확인 후 일시정지.

## 성능 테스트
REST Assured는 부하 테스트용 아님 → JMeter·Gatling. 응답 시간 측정 가능.

## API 보안 테스트
**보안 테스트?**

인증·권한·데이터 보호 검증.
**SQL Injection/XSS?**

페이로드 전송 후 적절히 sanitize되는지 검증.
**Broken Authentication?**

자격 증명 유무로 무단 접근 차단 확인.
**JWT 검증.**

## 모범 사례
요청/응답 명세로 중복 감소, 긍정·부정 시나리오, 데이터 기반 테스트, 독립·격리 테스트, 명확한 assertion. 버전 정보 URL/헤더 포함, 페이지 객체 패턴·재사용 메서드, CI/CD 통합(Maven/Gradle·Jenkins).

## 데이터 기반 테스트
테스트 데이터를 로직과 분리해 다른 입력으로 동일 테스트. TestNG @DataProvider, JUnit @ParameterizedTest.

## Mocking·Stubbing
**목적?**

실제 API 없이 동작 시뮬레이션. REST Assured는 직접 미지원 → WireMock(목 서버). 시작/구성/요청/`wireMockServer.stop()`. 장점: 외부 의존성 격리·재현 어려운 시나리오·속도·응답 제어.

## 데이터 검증
XML·JSON 스키마 검증, 선택 필드(`hasKey`).

## 버전·환경 관리
버전을 URL/헤더에 파라미터화. 환경별 설정 파일·시스템 속성: `System.getProperty("baseUri", "https://api.dev.example.com")`.

## 오류·복원력
오류 응답 테스트(잘못된 데이터·없는 엔드포인트), 간헐적 실패(재시도·resilience4j), 네트워크 실패 시뮬레이션(Chaos Monkey).

## 기타
멀티파트 업로드, 콘텐츠 타입(Content-Type·Accept), 페이지네이션(루프), 깊은 중첩 JSON, PUT/DELETE, path parameter(`pathParam`), 다중 assertion:
```java
given().when().get("https://api.example.com/resource")
  .then().statusCode(200)
  .body("key1", equalTo("value1"))
  .body("key2", equalTo("value2"));
```

## API 계약 테스트
**계약 테스트?**

API가 정의된 계약(OpenAPI/Swagger)을 요청·응답 형식·파라미터·데이터 타입 측면에서 준수하는지 검증.
**중요성?**

변경이 기존 기능 깨지 않음 보장, 제공자-소비자 합의, 조기 통합 이슈 발견.
**도구?**

Swagger/OpenAPI, Postman, Pact, Dredd.
**Pact?**

소비자 테스트가 계약 파일(pact) 생성, 제공자 검증으로 호환성 보장.
**계약 핵심 요소?**

엔드포인트 URL, HTTP 메서드, 요청 파라미터, 응답 형식, 데이터 타입, 제약.
**과제?**

버전 관리, 도구 호환성, 동적 데이터, 유지보수, 소비자 주도 계약.
**하위 호환성?**

API 버전 관리, 점진적 deprecate, 회귀 테스트, 소비자 피드백.
**스키마 검증 vs 계약 테스트?**

스키마 검증은 데이터 구조 형식·타입만, 계약 테스트는 전체 상호작용(요청/응답 구조·상태 코드·헤더·무결성) 검증.
