---
tags: [lwc, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Lightning Message Service in LWC - Modi Mitron Fun Project]
---

# LWC의 Lightning Message Service (Modi Mitron 프로젝트)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## LMS 개요
Winter'20 도입. 컴포넌트 계층에서 직접 관계 없는 컴포넌트 간 통신. Visualforce·Aura·LWC(유틸리티 바 팝업 포함) 간 대화 가능. 발행 컴포넌트가 데이터 브로드캐스트, 구독 컴포넌트가 수신.

## 재미있는 비유 (Modi-Rahul)
서로 다른 당(BJP·Congress) 소속처럼 직접 통신할 수 없는 컴포넌트. 의회에서 직접 통신 불가하나 LMS로 발행·구독.
1. **Publish:** Modi가 'Mitron' 메시지를 수신자 지정 없이 발행(확성기로 외침).
2. **Message Channel:** 메시지 전송 매체(라디오 주파수).
3. **Subscribe:** Rahul이 채널 구독해 직접 접촉 없이 메시지 수신(라디오 켜기).

## 1단계: Message Channel 생성
1. VS Code → force/app/main/default.
2. `messageChannels` 폴더 생성.
3. `mitronMessageChannel.messageChannel-meta.xml` 생성.
4. masterLabel·description·isExposed=true 추가.
5. package.xml에 lightningMessageChannel 추가.
6. Dev Org 배포.

## 2단계: Publisher 컴포넌트
- 메시지 채널 import(`@salesforce/messageChannel/...__c`).
- publish·MessageContext import.
- `@wire(MessageContext)`로 영구 연결.
- **publish() 매개변수 3개:** Message Context(객체), Message Channel(객체), Message Payload(JSON).
  - messageContext: LMS를 사용하는 LWC 정보(MessageContext wire 어댑터 또는 createMessageContext()).
  - messageChannel: `@salesforce/messageChannel` 스코프 모듈로 import.
  - message: 직렬화 가능 JSON(함수·심볼 불가).

## 3단계: Subscriber 컴포넌트
- Message Channel·subscribe·MessageContext import.
- `@wire(MessageContext)`.
- connectedCallback에서 subscribeToMessageChannel() 호출.
- **subscribe() 매개변수 4개:** Message Context, Message Channel, Listener(함수), Subscriber Options(객체).
  - listener: 메시지 발행 시 처리 함수.
  - subscriberOptions: `{scope: APPLICATION_SCOPE}`면 앱 어디서나 수신(lightning/messageService에서 import).

**요약:**

Modi의 'Mitron' 메시지 → messageContext → messageChannel → Rahul의 listener. subscriberOptions로 위치 무관 수신 보장.
