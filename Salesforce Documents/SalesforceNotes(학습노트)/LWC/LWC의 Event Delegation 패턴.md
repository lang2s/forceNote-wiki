---
tags: [lwc, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Event Delegation Pattern In LWC]
---

# LWC의 Event Delegation 패턴

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## Event Delegation이란?
단일 이벤트 리스너를 부모 요소에 추가해 여러 자식 요소의 이벤트를 관리하는 패턴. 각 자식에 개별 리스너를 추가하는 대신 부모가 이벤트를 듣고 event target에 따라 적절한 자식에 위임.

## LWC에서 사용 이유
- **성능 최적화:** 리스너 수 감소(자식이 많을 때 유리).
- **코드 관리 단순화:** 이벤트 처리 로직 중앙화.
- **동적 콘텐츠 처리:** 동적으로 추가·제거되는 자식의 이벤트를 리스너 추가/제거 없이 처리.

## 구현
- 부모 컴포넌트에 단일 이벤트 리스너 추가.
- event 객체로 어느 자식이 트리거했는지 식별.
- event target에 따라 적절한 로직 실행.

## 예 (Contact 목록 클릭)
- handleContactClick을 부모 div(class="contact-list")에 부착.
- event.target으로 트리거한 자식 식별.
- 자식의 data-id 속성에서 contact ID를 가져와 작업 수행.
