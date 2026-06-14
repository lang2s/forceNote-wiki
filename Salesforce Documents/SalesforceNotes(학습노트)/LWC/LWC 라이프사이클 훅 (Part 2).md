---
tags: [lwc, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [LifeCycle Hooks in LWC Part -2]
---

# LWC 라이프사이클 훅 (Part 2)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

주요 라이프사이클 훅:
1. **constructor():** 컴포넌트 초기화. 기본값·일회성 설정.
2. **connectedCallback():** DOM 추가 후. DOM 조작·데이터 조회에 적합.
3. **renderedCallback():** 렌더링 후. 렌더링된 DOM이 필요한 작업.
4. **disconnectedCallback():** DOM 제거 시. 정리·리소스 해제.
5. **errorCallback():** 렌더링 중 오류 시. 우아한 오류 처리.

(원본에는 parent.js·child.js 구현 예제가 포함되어 있습니다.)
