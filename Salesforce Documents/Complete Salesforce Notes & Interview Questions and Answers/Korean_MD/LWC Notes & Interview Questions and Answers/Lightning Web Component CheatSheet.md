# Lightning Web Component (LWC) 치트시트

> 원본은 이미지 PDF로 OCR 추출했습니다.

## 1. 컴포넌트 구조
1. **HTML 파일:** 구조·레이아웃.
2. **JavaScript 파일:** 로직(이벤트·데이터 조작·비즈니스 로직).
3. **CSS 파일:** 스타일.
4. **메타데이터 파일:** 구성(이름·설명·App Builder 노출 여부).

## HTML 템플릿 디렉티브
- `{data}`: 데이터 표시.
- `oneventName`: 이벤트 처리.
- `if:true|false`: 조건부 렌더링.
- `for:each={array}`: 배열 반복.

## 속성·프로퍼티
1. **Public Properties** (@api).
2. **데이터 전달** (부모→자식).

## 이벤트
이벤트 처리(CustomEvent·dispatchEvent·핸들러).

## Apex 통합
1. **Wire 서비스.**
2. **Imperative Apex.**

## 고급 개념
1. **LDS:** 레코드 데이터 자동 캐싱·관리. lightning-record-form·lightning-record-view-form.
2. **Navigation Service.**
3. **라이프사이클 훅:**
   - **constructor():** 첫 호출. 상태 초기화·이벤트 리스너 설정.
   - **connectedCallback():** DOM 삽입 시. DOM 접근 작업(타이머·API 호출).
   - **renderedCallback():** 템플릿 렌더링 시. DOM 접근(CSS 조작·상태 업데이트).
   - **disconnectedCallback():** DOM 제거 시. connectedCallback 리소스 정리.
   - **errorCallback():** 렌더링 오류 시. 오류 처리·메시지 표시.
4. **Custom Labels:** Salesforce Setup에 라벨 정의 후 LWC에서 사용.
