---
tags: [index, apex, logging]
created: 2026-05-17
---

# Logging(로깅) — 로컬 인덱스

> Apex 로깅 패턴 — 싱글턴 버퍼, Platform Event 기반 발행

**상위:** [[Apex MOC]] → [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Log 싱글턴 패턴]] | add() 버퍼 → publish() 일괄 발행, Platform Event 기반 | #pattern |
| [[Apex Debug Log]] | Debug Log 카테고리 10종·레벨 8종(NONE~FINEST), Event Type 매트릭스, DebuggingHeader(LogCategory/LogCategoryLevel enum), 로그 한도·우선순위, Developer Console | #reference |
| [[Tooling API 디버그·로그·리플레이 sObject]] | TraceFlag·DebugLevel·ApexLog·HeapDump·Overlay·ExecuteAnonymousResult, API식 로그/리플레이 제어 sObject 전수 | #reference |

---

## 빠른 선택

- 로깅 버퍼 패턴으로 디버그 로그 발행? → [[Log 싱글턴 패턴]]
- Debug Log 카테고리·레벨·한도, System.debug 로그 설정? → [[Apex Debug Log]]
- API/Tooling으로 디버그 로그 켜기·trace flag 생성·힙 덤프·리플레이 디버거? → [[Tooling API 디버그·로그·리플레이 sObject]]

---

## 관련 폴더

Platform Event 구현 → [[Apex/PlatformEvents(플랫폼이벤트)/index|PlatformEvents(플랫폼이벤트)]]
