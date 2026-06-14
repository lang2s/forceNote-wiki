---
tags: [integration, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [REST API]
---

# REST API

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## REST API란?
API는 애플리케이션 간 연결·통신 정의. REST(Representational State Transfer)는 HTTP 요청 메서드로 데이터를 접근·조작하는 아키텍처 스타일. 메서드: GET, POST, PUT, DELETE, PATCH, HEAD, TRACE, CONNECT, OPTIONS.

## 핵심 개념
- **Resources:** 모든 것이 리소스(고유 URL).
- **HTTP 메서드:** GET(조회), POST(생성), PUT(업데이트), DELETE(삭제).
- **Stateless:** 각 요청이 모든 정보 포함, 서버가 세션 상태 미저장.
- **JSON/XML:** 데이터 교환 형식.

## 예 (도서관 API)
- GET /books: 전체 조회
- GET /books/{id}: 특정 조회
- POST /books: 추가
- PUT /books/{id}: 업데이트
- DELETE /books/{id}: 삭제

## 장점
확장성, 유연성(다양한 데이터 형식), 상호운용성, 성능(캐싱).

## REST vs SOAP
**REST:** 아키텍처 스타일, 다중 형식(JSON·XML·HTML), Stateless, 빠름·적은 대역폭·캐싱, 구현 간단.
**SOAP:** 프로토콜·엄격 표준, XML만, Stateful 가능, WS-Security, 복잡·고대역폭.
**사용:** REST(경량·확장·유연, 웹·모바일), SOAP(보안·트랜잭션 신뢰성, 엔터프라이즈).

## RESTful 인증

**1. Basic:** 사용자명·비밀번호 Base64 인코딩(`Authorization: Basic ...`). 간단하나 HTTPS 없으면 비안전.
**2. Bearer Token:** 토큰 헤더(`Authorization: Bearer <token>`). Basic보다 안전(단기 토큰).
**3. API Key:** 헤더·쿼리 파라미터(`?api_key=...`). 간단하나 공유·유출 위험.
**4. OAuth2:** 인증 서버로 액세스 토큰 획득(`Authorization: Bearer <access_token>`). 세밀한 제어·서드파티 인증.

**모범 사례:** HTTPS, 토큰 만료·갱신, rate limiting, 로깅·모니터링, 최소 권한.

**OAuth2 워크플로우:** 클라이언트 인증 요청 → 사용자 승인 → Authorization Code 수신 → 토큰 교환 → 리소스 접근.

## API Key vs Token
**API Key:** 프로젝트·앱 식별, 정적·장수명, 고정 권한, 덜 안전(`?api_key=...`).
**Token:** 사용자 세션·권한 표현, 동적·단기·갱신, 세밀한 제어, 안전(`Authorization: Bearer ...`).
- **목적:** Key는 앱 식별, Token은 사용자 인증·권한.
- **보안:** Token이 단기·특정 스코프로 더 안전.
- **사용:** Key(단순·앱 식별), Token(보안·사용자별 인증).

## Token-based vs Session-based 인증
**Session-based:** 로그인 → 서버가 세션 생성·저장 → 세션 ID(쿠키) → 요청마다 세션 ID 전송 → 서버 검증. 장점: 간단·관리 용이. 단점: 확장성 이슈(서버 세션 저장), sticky session 필요.
**Token-based:** 로그인 → 토큰 생성(JWT) → 클라이언트 저장 → 요청마다 헤더 전송 → 서버 검증. 장점: Stateless·확장성·도메인 간·안전(만료·무효화). 단점: 클라이언트 안전 저장 필요·복잡.
- **상태:** Session은 stateful, Token은 stateless.
- **확장성:** Token이 우수.
- **사용:** Session(소규모·서버 관리), Token(현대·확장·크로스 도메인·모바일).
