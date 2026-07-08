---
tags: [index, lwc, security]
created: 2026-05-17
---

# Security(보안) — 로컬 인덱스

> LWC 보안 패턴 — 권한 기반 UI, CSP, DOM XSS 방어

**상위:** [[LWC MOC]] → [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[LWC 보안 패턴]] | customPermission, userId, CSP Locker Service, DOM XSS 방어 | #pattern |
| [[Lightning Web Security vs Lightning Locker]] | LWS vs Locker 아키텍처 비교, distortion, secure wrapper, strict mode, CSP | #reference |
| [[LWS 활성화·Locker 마이그레이션 절차]] | Session Settings 토글로 org 전체 LWS 활성화·Locker→LWS 호환성 테스트·distortion 진단·롤백 실무 절차 | #procedure |
| [[CSP·Trusted Sites 레퍼런스]] | CSP 지시자별(connect-src·frame-src·img-src·style-src·font-src·media-src) 신뢰 사이트 등록으로 외부 도메인 리소스/API 허용 | #reference |

---

## 관련 폴더

Apex 보안 → [[Apex/Security(보안)/index|Apex Security(보안)]] | CSP 설정 → [[Integration(통합)/CSP와 RemoteSite]]
