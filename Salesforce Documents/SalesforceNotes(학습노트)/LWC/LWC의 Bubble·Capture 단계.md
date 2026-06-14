---
tags: [lwc, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Bubble and Capture Phase in LWC]
---

# LWC의 Bubble·Capture 단계

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

이벤트 발생 시 DOM을 따라 전파된다. 전파는 두 단계: 이벤트 버블링·이벤트 캡처링.

## Bubble Phase
컴포넌트를 따라 위로(아래→위) 전파되는 이벤트가 Bubble Phase. (파란 화살표: 아래에서 위)

## Capture Phase
컴포넌트를 따라 아래로(위→아래) 전파되는 이벤트가 Capture Phase. (빨간 화살표: 위에서 아래)

> Bubble·Capture 단계를 통해 LWC의 이벤트 처리를 이해할 수 있다. (원본에는 childComp·parentComponent의 html·js 코드 예제가 포함되어 있습니다.)
