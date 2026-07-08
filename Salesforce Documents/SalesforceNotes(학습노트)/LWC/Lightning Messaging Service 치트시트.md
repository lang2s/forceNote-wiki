---
tags: [lwc, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Lightning Message Channel Cheat Sheet]
---

# Lightning Messaging Service 치트시트

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

> 원본은 이미지 PDF로 OCR 추출했습니다.

## 소개
**목적:**

Salesforce 앱의 서로 다른 부분(Aura·LWC)이 직접 연결 없이 메시지를 주고받게 함.

**핵심 개념:**
1. **Message Channel:** org에 정의하는 통신 매체.
2. **Publisher:** 메시지 전송 컴포넌트.
3. **Subscriber:** 메시지 수신 컴포넌트.

## Message Channel 생성
1. messageChannels 폴더에 새 XML 파일 생성.
2. 채널 상세·설명 추가.
3. message 필드로 메시지 구조 정의.
4. 가시성 설정 후 저장.
```xml
<LightningMessageChannel xmlns="...">
    <masterLabel>...</masterLabel>
    <isExposed>true</isExposed>
    <messagingFields>
        <field name="recordId"/>
        <field name="..."/>
    </messagingFields>
</LightningMessageChannel>
```

## 메시지 발행
1. `lightning/messageService`에서 publish·MessageContext import.
2. @wire로 MessageContext 획득.
3. 메시지 구성·publish 호출 함수 정의.
4. 이벤트(버튼 클릭 등)에 응답해 호출.

## 메시지 구독
1. `lightning/messageService`에서 subscribe·MessageContext import.
2. @wire로 MessageContext 획득.
3. 컴포넌트 연결 시 subscribe로 메시지 수신.
4. 수신 메시지 처리 함수 생성.
5. disconnectedCallback에서 unsubscribe(메모리 누수 방지).
