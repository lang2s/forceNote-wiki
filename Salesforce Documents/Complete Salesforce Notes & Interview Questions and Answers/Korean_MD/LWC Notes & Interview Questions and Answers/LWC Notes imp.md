# LWC 핵심 노트

LWC는 ES6·Custom Elements·Shadow DOM 같은 웹 표준으로 만든 현대 JavaScript 프레임워크. 재사용·빠름·동적 UI. Aura보다 경량·빠름. 표준 JavaScript로 복잡도 감소.

**컴포넌트 파일:** HTML(.html, UI 구조), JavaScript(.js, 로직), Meta XML(.js-meta.xml, 가시성 구성).

**Template:** 컴포넌트 UI 구조·레이아웃 정의 HTML. JS 컨트롤러 데이터를 바인딩하는 동적 표현식 포함.

**데이터 바인딩:** 주로 단방향(JS→템플릿). 양방향은 직접 미지원, 이벤트 처리로 구현.
```javascript
handleInput(event) { this.name = event.target.value; }
```

**이벤트:** 이벤트 리스너로 처리. HTML에 onclick·onchange 등, JS에 메서드 구현.

**데코레이터:** @api(public 속성·메서드), @track(내부 속성 반응형), @wire(Salesforce 데이터·메타데이터 조회).

**라이프사이클:** constructor·connectedCallback·renderedCallback·disconnectedCallback.

**통신:** Parent→Child(@api), Child→Parent(custom event), Pub/Sub(관계 없는 형제 컴포넌트).

**Apex 호출:** @wire 또는 imperative.

**조건부 렌더링:** 조건·표현식에 따라 동적 표시/숨김(JS + HTML 템플릿).

**반응성:** @track·@api 속성 변경 시 자동 재렌더링.

**LMS:** Lightning Experience에서 LWC·Aura·VF 간 통신(발행·구독).

**Promise:** 비동기 작업 완료를 기다려 성공/실패·결과 제공. 3상태: Pending·Fulfilled·Rejected. Apex 호출·외부 API·시간 소요 작업에 사용. 중첩 콜백 회피·순서 보장.
