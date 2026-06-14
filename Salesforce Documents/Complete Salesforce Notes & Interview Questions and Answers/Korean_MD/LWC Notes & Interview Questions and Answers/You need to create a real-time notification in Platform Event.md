---
tags: [lwc, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [You need to create a real-time notification in Platform Event]
---

# Platform Event 발행 시 실시간 알림 컴포넌트 만들기

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

Salesforce Platform Events에 대한 실시간 알림 컴포넌트 생성 단계.

## 1단계: Platform Event 정의
1. Setup → Quick Find에 "Platform Events".
2. New Platform Event → Name·API Name(예: Notification__e) 정의, 커스텀 필드 추가(Message__c, Type__c).
3. 저장.

## 2단계: Apex에서 이벤트 발행
1. Platform Event를 발행하는 Apex 클래스 생성.
2. 다른 Apex·트리거·LWC에서 호출해 알림 발행.

## 3단계: LWC 생성
1. **JS:** `lightning/empApi` 모듈로 Platform Event 구독.
2. **HTML:** 컴포넌트에 알림 표시.

## 4단계: 배포·테스트
1. Apex 클래스·LWC 배포.
2. Lightning App Builder에서 LWC를 페이지에 추가.
3. Developer Console 등에서 publishNotification 메서드 트리거해 실시간 알림 확인.
