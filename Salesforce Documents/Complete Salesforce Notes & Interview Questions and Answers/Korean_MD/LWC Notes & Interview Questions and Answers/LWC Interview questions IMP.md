# LWC 면접 질문 (중요)

**1. LWC와 Aura 차이?** LWC는 ES6 기반 현대 웹 표준 모델. Aura보다 나은 성능·단순 모델.

**2. 라이프사이클 훅?** Constructor(초기화), connectedCallback(DOM 삽입), renderedCallback(렌더링 후), disconnectedCallback(DOM 제거).

**3. @api 데코레이터?** public 속성·메서드 노출. 부모·App Builder 접근.

**4. 이벤트 처리?** 표준 DOM 핸들러(onclick·onchange) 또는 CustomEvent API.

**5. 표준 vs 커스텀 이벤트?** 표준은 네이티브 브라우저 이벤트, 커스텀은 CustomEvent API로 생성·dispatch.

**6. Wire 어댑터?** Apex·SOQL·플랫폼 이벤트에서 선언적으로 데이터 조회.

**7. Wire vs Imperative Apex 장점?** Wire는 캐싱·동기화·오류 자동 처리. 반응형(데이터 변경 시 UI 자동 반영).

**8. 오류·예외 처리?** try-catch 또는 onError 핸들러.

**9. 재사용 컴포넌트?** 공통 UI·기능을 별도 컴포넌트로 캡슐화해 재사용.

**10. @track?** 속성을 반응형으로 표시. 변경 시 재렌더링.

**11. Imperative Apex 호출?** imperative wire 어댑터 또는 JS에서 직접 import·호출.

**12. LDS vs Wire?** LDS는 Apex 없이 데이터 접근(레코드 캐싱·동기화·공유 규칙 자동).

**13. LMS?** pub/sub 메시징. 계층 관계 무관 컴포넌트 통신.

**14. CSS 역할?** 스타일링. `:host` 의사 클래스로 스타일 누출 방지.

**15. 조건부 렌더링?** if:true·if:false·template if:true 디렉티브.

**16. LWC vs Visualforce?** LWC는 현대 표준·나은 성능·단순 모델·JS 프레임워크 통합.

**17. 서드파티 JS 라이브러리?** import 문으로 가능.

**18. @wire?** Apex·wire 어댑터 호출. 데이터 조회·캐싱·오류 자동, 데이터 변경 시 UI 업데이트.

**19. Slot?** 부모가 자식에 마크업·컴포넌트 전달하는 플레이스홀더(유연성·재사용).

**20. 페이지네이션?** wire·imperative로 부분 조회 후 내비게이션 컨트롤로 표시.

**21. 디렉티브 유형?** if:true, if:false, template if:true/false, for:each, for:item.

**22. LDS 레코드?** LDS로 조회한 Salesforce 레코드. 반응형 데이터 모델.

**23. @api vs @wire?** @api는 public 속성·메서드 노출, @wire는 Apex·wire 어댑터 호출.

**24. 내비게이션?** Lightning Navigation Service.

**25/30. Composition?** 여러 컴포넌트 결합해 복잡한 UI·기능 구성(재사용·모듈성).

**26. this.template?** 컴포넌트 DOM 접근(DOM 요소 직접 조작).

**27. Imperative vs Declarative?** Imperative는 명시적 JS 코드, Declarative는 내장 기능(wire·이벤트)으로 적은 코드.

**28. 폼 제출?** `<form>`·onsubmit 핸들러 또는 submit 이벤트.

**29. LWC vs VF 장점?** 나은 성능·단순 모델·JS 통합·현대 UX·반응형.

**31. 부모-자식 이벤트?** dispatchEvent()·addEventListener(). 부모는 속성으로 데이터 전달.

**32. 내비게이션 유형?** 표준 페이지·URL·컴포넌트 내비게이션(Lightning Navigation Service).

**33. 조건부 CSS?** JS 표현식으로 동적 CSS 클래스·인라인 스타일.

**34. 이벤트 버블링·전파?** 버블링은 자식→부모, 전파는 부모→자식.

**35. 인증·권한?** Salesforce Identity·OAuth·Security Model. 커스텀은 Apex·커스텀 권한.

**36. 데이터 바인딩?** JS 데이터를 UI 요소에 연결. 데이터 변경이 UI에 자동 반영.

**37. 바인딩 유형?** 단방향(JS→UI), 양방향(UI→JS).

**38. Apex 오류 처리?** try-catch, 커스텀 이벤트·반환 값으로 LWC에 전달.

**39. Lightning App Builder?** LWC·Aura·표준 컴포넌트로 커스텀 페이지·앱(드래그앤드롭).

**40. 접근성?** 시맨틱 HTML, 이미지 대체 텍스트, 키보드 내비게이션, WCAG, SLDS.
