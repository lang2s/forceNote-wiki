---
tags: [scenario, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [TCS Apex SBQ]
---

# TCS Salesforce 개발자 — Apex 시나리오 질문

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## Q: 매일 새벽 2시에 배치 작업을 실행하는 Schedulable Apex 작성
**의도:**

Schedulable 클래스, cron 표현식, 배치 작업 이해. 프로세스 자동화 능력.
**자주 막히는 부분:**

cron 표현식 미이해(2시 매일 = `0 0 2 * * ?`), 스케줄러 오류·재시도 미처리, 스케줄러 테스트 부족.

## Q: 외부 REST API로 HTTP 콜아웃 후 응답 처리하는 Apex 메서드
**의도:**

콜아웃, Future 메서드, 비동기 처리 이해. 외부 통합·JSON 파싱 능력.
**자주 막히는 부분:**

트리거·동기 컨텍스트에서 `@future(callout=true)` 미사용, 타임아웃·오류 응답 미처리, JSON 파싱 오류.

## Q: 커스텀 오브젝트 필드 변경을 추적해 관련 오브젝트(Field_History__c)에 로깅
**의도:**

트리거 로직, 필드 히스토리 추적, 커스텀 로깅 이해.
**자주 막히는 부분:**

null·누락 필드 미처리, 벌크화 안 함, 모든 변경 시나리오 미테스트.

## Q: 수신자 목록에 동적 콘텐츠(머지 필드) 이메일 발송 메서드
**의도:**

이메일 서비스, 템플릿, 동적 콘텐츠 이해.
**자주 막히는 부분:**

이메일 템플릿·머지 필드 오용, 이메일 한도(일 5,000) 미처리, 전달 테스트 부족.
