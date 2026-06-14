# LWC 종합 노트

## 1. LWC 소개
**LWC란?** HTML·JavaScript·CSS 표준 웹 기술로 Lightning 컴포넌트를 만드는 현대 프레임워크. Web Components 표준 기반·경량·빠름·안전. Aura의 후속.

**장점:** 성능(빠른 렌더링), 표준 기반(Custom Elements·Shadow DOM·ES6+), 재사용성, 보안(Locker Service), 개발 경험. 데스크톱·모바일 최적화.

## 2. 통신
- **Parent → Child:** @api 데코레이터로 데이터 전달.
- **Child → Parent:** CustomEvent·dispatchEvent.

## 3. 데코레이터
- **@api:** public 속성(부모 접근).
- **@track:** 복잡 객체 변경 추적(신버전 대부분 불필요).
- **@wire:** Apex 메서드 호출·데이터 바인딩.

## 4. 바인딩
- **단방향:** `{property}` 구문으로 표시.
- **양방향:** onchange 이벤트로 값 업데이트.

## 5. 라이프사이클 훅
constructor·connectedCallback·renderedCallback·disconnectedCallback·errorCallback.

## 6. Lightning Message Service (LMS)
LWC·Aura·Visualforce 간 통신. MessageChannel로 발행·구독. ① messageChannel.meta.xml 생성, ② LWC에 publish·subscribe import.

## 7. Lightning Data Service (LDS)
Apex 없이 CRUD. `lightning/uiRecordApi`의 getRecord·createRecord·updateRecord·deleteRecord.

## 8. Pub/Sub 모델
직접 부모-자식 관계 없는 컴포넌트 통신. pubsub.js 유틸리티(이벤트 버스).

## 9. 이벤트 통신
Custom Events. 자식 dispatchEvent, 부모 handleEvent.

## 10. Promise·Promise.all
비동기 작업 처리. Promise.all은 여러 promise 병렬 실행.

## NavigationMixin
`lightning/navigation`으로 페이지 간 이동. ① import, ② 레코드 페이지(View 모드), ③ 오브젝트 List View, ④ 외부 URL, ⑤ 커스텀 탭/Lightning App Page.

## Wire 어댑터
`lightning/ui*Api`에서 import해 Apex 없이 데이터 조회.
- **getRecord:** 레코드 데이터 조회.
- **getListUi:** 레코드 목록 조회.
- **getObjectInfo:** 오브젝트 메타데이터.
