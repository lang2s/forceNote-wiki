---
tags: [integration, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [REST API and SF Authentication]
---

# REST API와 Salesforce 인증 방법

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## REST API 인증 방법

| 방법 | 설명 | 프로세스 |
|---|---|---|
| Token Authentication | JWT 등 생성 토큰을 클라이언트-서버 간 교환 | 로그인 → 인증 요청 → JWT 발급 → JWT로 보호 리소스 접근 |
| OAuth Authentication | 자격 증명 노출 없이 사용자 리소스 제한 접근 | 인증 요청 → 사용자 승인 → Authorization Grant → Access Token → 토큰으로 리소스 요청 |
| API Key Authentication | 사용자/앱에 고유 키 부여(헤더·매개변수) | 키 포함 요청 → 검증 → 유효 시 DB 접근, 무효 시 401 |
| Basic Authentication | 요청마다 사용자명·비밀번호 전송 | 리소스 요청 → 자격 증명 요청 → 전송 → 유효 시 리소스 반환 |

## Salesforce 인증 방법

| 방법 | 설명 | 사용 사례 | 고려사항 |
|---|---|---|---|
| Basic | 요청마다 사용자명·비밀번호(암호화 없어 덜 안전) | SOAP API, 일부 REST, 구 통합 | 신규 비권장, HTTPS만, 더 안전한 방법 권장 |
| Token | 생성 토큰(세션 ID·액세스 토큰) | REST API, Mobile SDK, 클라이언트 앱 | 만료 있음, 갱신 처리 필요, Basic보다 안전 |
| OAuth | 자격 증명 노출 없이 제한 접근 | 현대 통합 주력, Connected Apps, 웹·모바일 | 다중 플로우(Web Server·User-Agent·JWT Bearer), Connected App 필요, 가장 유연·안전 |
| API Key | 고유 키(헤더·매개변수) | 일부 제품, 파트너 통합, 개발 도구, 샌드박스 | 핵심 API에 미사용, 세밀한 접근 제어 제한, 구현 단순하나 OAuth보다 덜 안전 |
