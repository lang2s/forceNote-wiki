---
tags: [integration, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [𝙍𝙀𝙎𝙏 𝘼𝙋𝙄 𝙉𝙊𝙏𝙀𝙎]
---

# REST API 노트

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

> 원본은 이미지 PDF로 OCR 추출했습니다.

REST = Representational State Transfer. 클라이언트가 HTTP 메서드로 요청하면 서버가 응답·HTTP 상태 코드 반환.

**HTTP 메서드:** GET, POST, PUT, DELETE, PATCH, HEAD, TRACE, OPTIONS, CONNECT.
**상태 코드:** 200, 201, 403, 404, 500 등.
**HTTP 요청:** Request Method, Headers, Body.
**HTTP 응답:** Status, Headers, Body.

## REST API 제약
- **Uniform Interface:** 공통 프로토콜 준수, 제3자 해석 불필요.
- **Client-Server Architecture:** 클라이언트·서버 분리.
- **Layering:** 클라이언트-서버 사이 다중 중개자.
- **Cacheability:** 응답 캐시 가능.
- **Statelessness:** 상태 없음, 완전 분리.

## HTTP 헤더
클라이언트·서버가 요청·응답에 추가 정보 전달. 4종:
- **Request Headers(클→서):** Accept(이해 가능 데이터 타입), Accept-Encoding, Authorization(자격 증명), Accept-Language.
- **Response Headers(서→클).**
- **Representation/Payload.**

**널리 쓰는 헤더:** Content-Type(미디어 타입), Host(도메인명), Access-Control-Allow-Origin(허용 origin), Access-Control-Allow-Methods(허용 메서드).

## HTTP 상태 코드
**성공(2xx):** 200 OK(정상), 201 Created(새 리소스 생성).
**리디렉션(3xx):** 301 Moved Permanently(영구 이동).
**클라이언트 오류(4xx):** 400 Bad Request(잘못된 구문), 401 Unauthorized(자격 증명 오류), 403 Forbidden(권한 없음), 404 Not Found(잘못된 URL), 429 Too Many Requests(과도 요청).
**서버 오류(5xx):** 500 Internal Server Error(예상치 못한 상황 처리 불가).

## HTTP 요청 메서드
- **GET:** 리소스 조회(가장 일반적).
- **POST:** 정보 제출(서버 상태 변경).
- **PUT:** 리소스 변경(이미 컬렉션의 일부).
- **PATCH:** 데이터의 필요한 부분만 수정(전체 응답 미수정).
- **DELETE:** 지정 리소스 삭제(Request-URL 식별 리소스).

## Access Control HTTP Headers (CORS)
교차 출처 요청 시:
- **Origin 헤더:** 요청 출처 알림.
- **Access-Control-Request-Method:** 메인 요청에 쓸 메서드를 서버에 사전 확인(Preflight 요청).
- **Access-Control-Allow-Origin:** 리소스 접근 허용 출처.
- **Access-Control-Allow-Methods:** 교차 출처 리소스 접근 허용 메서드.
- Preflight 응답으로 메인 요청 가능 여부 표시.

## Caching
`Cache-Control: max-age=<seconds>` — 캐시가 stale 되기까지 초.
