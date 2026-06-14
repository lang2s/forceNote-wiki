---
tags: [scenario, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Infosys Integration SBQ]
---

# Infosys Salesforce 개발자 — 통합 시나리오 질문

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## Q: Queueable Apex로 외부 시스템 비동기 통합
**예상 로직:** Queueable로 장기 콜아웃을 동기 실행에서 분리, execute에서 재시도·오류 처리.
**흔한 실수:** Queueable 예외 처리 미흡, 실패 콜아웃 재시도 미처리, 다중 비동기 콜아웃 시 거버너 한도 미고려.

## Q: OAuth 2.0로 외부 시스템 인증 통합
**예상 로직:** Named Credentials 또는 수동 OAuth 플로우로 인증. authorization code grant 또는 client credentials 플로우.
**솔루션:** ① OAuth 자격 증명으로 Named Credential 생성, ② Named Credential로 외부 API 콜아웃.
**흔한 실수:** OAuth 토큰·만료 미처리, 외부 시스템에 맞는 플로우 미설정, 토큰 갱신 미처리.

## Q: SOAP API + WSDL 통합
**예상 로직:** WSDL로 Apex 클래스 생성(Salesforce Apex Web Services 도구), 데이터 처리·오류 처리.
**솔루션:** ① WSDL로 Apex 클래스 생성, ② 생성된 클래스로 SOAP API 호출.
**흔한 실수:** WSDL 처리 오류, SOAP 오류(타임아웃·잘못된 응답) 예외 미처리, 통합 테스트 부족.

## Q: Mulesoft로 SAP 통합
**예상 로직:** Mulesoft를 미들웨어로 데이터 변환, Salesforce REST API로 송수신, 양쪽 데이터 일관성.
**솔루션:** 트리거(Salesforce API 요청) → 변환(JSON→XML) → SAP Connector로 전송 → 응답 반환.
**흔한 실수:** 미들웨어 오류 처리 무시(SAP 다운·잘못된 매핑), 업데이트 전 데이터 검증 미흡, 실시간 동기화 체크 누락.

## Q: WebSockets로 실시간 주문 추적
**예상 로직:** CometD(Bayeux 프로토콜)로 실시간 업데이트, 외부 앱에서 Platform Events 구독.
**흔한 실수:** CometD 핸드셰이크 실패 미처리, 잘못된 API 버전, 대량 구독자 확장성 무시.

## Q: Google Drive 통합으로 업로드 파일 저장
**예상 로직:** Google Drive API + OAuth 2.0, 파일 링크를 Salesforce에 저장.
**흔한 실수:** OAuth 2.0 오용, 액세스 토큰 하드코딩(동적 갱신 안 함), 파일 크기·rate limit 무시.
