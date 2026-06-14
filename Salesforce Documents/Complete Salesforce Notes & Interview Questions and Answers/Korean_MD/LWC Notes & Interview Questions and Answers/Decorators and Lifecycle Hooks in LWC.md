# LWC의 데코레이터와 라이프사이클 훅

## 데코레이터란?
JavaScript 객체에 동작을 추가하는 디자인 패턴(ECMAScript). 기능을 동적으로 변경. LWC 3종: @api, @track, @wire.

### @api
public 속성·메서드 표시(부모·다른 컴포넌트 접근).
- **Public 속성:** 부모가 값 바인딩·변경.
- **Public 메서드:** 자식 메서드를 부모가 호출.

### @track
속성을 반응형으로 만들어 값 변경 시 재렌더링. 객체 속성·배열 요소의 내부 값 변경을 모니터링.

### @wire
LWC를 Apex 메서드·함수·wire 어댑터에 연결해 데이터 조회·관리.
```javascript
import methodName from '@salesforce/apex/ApexClassName.apexMethod';
@wire(methodName, {methodParams})
```
- @wire로 속성·함수 연결.
- wire 서비스가 data·error 속성 객체 제공.
- 값 가용 시 함수 호출.

## 라이프사이클 훅
컴포넌트 생애 단계별 개입 메서드.
1. **constructor():** 컴포넌트 생성 시 첫 호출. 변수 초기화·초기 상태.
2. **connectedCallback():** DOM 삽입 시. 렌더링 후 작업.
3. **renderedCallback():** 템플릿 렌더링 후. DOM 상호작용·렌더링 후 작업.
4. **disconnectedCallback():** DOM 제거 시. 정리(리스너 구독 해제).
5. **errorCallback():** 렌더링 중 오류 시. 오류 우아하게 처리.
