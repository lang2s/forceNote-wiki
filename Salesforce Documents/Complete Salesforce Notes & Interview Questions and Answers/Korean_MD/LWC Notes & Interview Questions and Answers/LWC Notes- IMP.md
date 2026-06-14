# LWC 핵심 노트 (IMP)

## 주제
1. LWC란? 2. Aura vs LWC 3. 라이프사이클 훅 4. 속성·HTML 템플릿 5. 데코레이터 6. 데이터 바인딩 7. LWC에서 Apex 호출(Wire 속성·Wire 함수·Imperative) 8. @AuraEnabled(cacheable=true) 9. Parent→Child 10. Child→Parent 11. 관계 없는 컴포넌트 통신(Pub-sub·LMS) 12. Lightning Data Service

## 면접 질문

**1. LWC란?** Salesforce가 만든 웹 컴포넌트 프로그래밍 모델. 모듈화·캡슐화 설계, 표준 HTML·JavaScript 구문, 성능·재사용성·현대적 접근.

**2. LWC가 Aura보다 빠른 이유?**
- **경량 렌더링:** 표준 웹 컴포넌트 사양 기반, 네이티브 브라우저 활용.
- **프레임워크 오버헤드 없음:** 커스텀 프레임워크 미의존.
- **효율적 DOM 조작:** 변경된 부분만 업데이트.
- **서버 측 렌더링:** 초기 로드 향상.
- **표준 웹 컴포넌트.**

**3. 웹 표준이란?** W3C·IETF가 정한 일관성·상호운용성 가이드라인. 예: HTML(구조), CSS(표현), JavaScript/ECMAScript(상호작용), HTTP/HTTPS(통신), WebAssembly(고성능 코드).

**4. Aura가 있는데 LWC를 출시한 이유?** 성능(경량 렌더링), 웹 표준(표준 웹 컴포넌트), 개발 경험(표준 JS), 모듈성·재사용성, 호환성(진화하는 표준).

**5. Aura에 없고 LWC에 있는 웹 표준?**
- **표준 웹 컴포넌트:** Shadow DOM·HTML 템플릿·Custom Elements(Aura는 자체 모델).
- **ES6+:** 클래스·모듈·화살표 함수.
- **Shadow DOM:** 캡슐화(스타일·기능 누출 방지).
- **HTML 템플릿.**
- **서버 측 렌더링.**
