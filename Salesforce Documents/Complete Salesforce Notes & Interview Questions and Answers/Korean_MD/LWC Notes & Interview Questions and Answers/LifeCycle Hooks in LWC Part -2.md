# LWC 라이프사이클 훅 (Part 2)

주요 라이프사이클 훅:
1. **constructor():** 컴포넌트 초기화. 기본값·일회성 설정.
2. **connectedCallback():** DOM 추가 후. DOM 조작·데이터 조회에 적합.
3. **renderedCallback():** 렌더링 후. 렌더링된 DOM이 필요한 작업.
4. **disconnectedCallback():** DOM 제거 시. 정리·리소스 해제.
5. **errorCallback():** 렌더링 중 오류 시. 우아한 오류 처리.

(원본에는 parent.js·child.js 구현 예제가 포함되어 있습니다.)
