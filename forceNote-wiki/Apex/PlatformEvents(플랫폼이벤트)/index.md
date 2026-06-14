---
tags: [index, apex, platform-events]
created: 2026-05-17
---

# PlatformEvents(플랫폼이벤트) — 로컬 인덱스

> Platform Event 발행·수신 — 느슨한 결합, 비동기 이벤트 기반 통합

**상위:** [[Apex MOC]] → [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Platform Event 발행]] | EventBus.publish, 수신 트리거, ReplayId | #pattern |
| [[Platform Event 정의와 구독]] | `__e` 정의·Publish Behavior·고볼륨, after insert 트리거·Pub/Sub·CometD 구독, 재시도 | #concept |
| [[Platform Event Apex 테스트]] | Test.getEventBus deliver/fail, onSuccess/onFailure 검증 | #pattern |
| [[Platform Event 한도와 고려사항]] | allocations·72h 보관, read-only/no-SOQL, 디커플드 발행-구독, PE vs CDC | #reference |
| [[ChangeEventHeader]] | CDC 변경 이벤트 헤더 — changetype, recordids, changedfields, TriggerContext, TestBroker | #reference |
| [[EventBus Publish Callbacks]] | 비동기 발행 최종 결과 콜백 — EventPublishFailureCallback, onFailure, setResumeCheckpoint | #reference |
| [[EventBus Namespace]] | EventBus.publish 메서드 전체 서명 + TriggerContext + RetryableException + API v67 변경 | #reference |

---

## 빠른 선택

- Platform Event 발행·수신 기본? → [[Platform Event 발행]]
- 이벤트 정의·구독 트리거·Publish Behavior? → [[Platform Event 정의와 구독]]
- Apex 테스트(deliver/fail)? → [[Platform Event Apex 테스트]]
- 한도·SOQL 불가·디커플드 함정? → [[Platform Event 한도와 고려사항]]
- CDC 변경 필드 확인? → [[ChangeEventHeader]]
- 발행 성공/실패 최종 결과 수신? → [[EventBus Publish Callbacks]]
- 트리거 부분 처리 재개? → [[EventBus Publish Callbacks]] → setResumeCheckpoint
- EventBus 메서드 서명 전체? → [[EventBus Namespace]]
- TriggerContext.retries 활용? → [[EventBus Namespace]] → RetryableException 비교표

## 관련 폴더

시스템 간 통합 활용 → [[Integration(통합)/Platform Event 통합 패턴]] | 로깅 연동 → [[Apex/Logging(로깅)/index|Logging(로깅)]]
