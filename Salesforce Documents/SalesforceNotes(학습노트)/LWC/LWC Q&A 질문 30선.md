---
tags: [lwc, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [LWC Notes]
---

# LWC Q&A 질문 30선

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

**1. LWC?** Salesforce의 현대 프레임워크. JavaScript·HTML 표준 웹 기술로 UI 구축. 재사용·효율 컴포넌트, 성능 향상.

**2. Aura vs LWC?** Aura는 독자 프레임워크, LWC는 표준 웹 기술(JS·HTML·CSS). LWC가 네이티브 표준·효율 렌더링으로 더 빠름·학습 쉬움.

**3. Salesforce Lightning?** 컴포넌트 기반 앱 개발 프레임워크. 개발 단순화.

**4. Lightning Component Framework?** 데스크톱·모바일용 동적 앱 개발 UI 프레임워크.

**5. Lightning 컴포넌트?** Lightning Button, Input, Combo Box, Exchange, Design System.

**6. renderedCallback()?** 컴포넌트 렌더링 완료 후 로직 실행(DOM 조작·서드파티 라이브러리 초기화).

**7. @wire?** 속성·메서드를 Salesforce 데이터 소스에 연결. 데이터 수집·오류·상태 자동 관리. Apex·내장 wire 어댑터 호환.

**8. Lightning 도구?** Component Framework, App Builder, Process Builder, Design System, Component Library, Connect.

**9. Lightning Process Builder?** 코드 없이 비즈니스 프로세스 자동화 시각 도구.

**10. SFDX?** Salesforce Developer Experience. 개발 경험 향상 도구.

**11. cacheable=true?** 데이터 조회만(DML 불가). 클라이언트 캐시 데이터 표시로 성능 향상. stale 데이터는 refreshApex로 갱신(LDS는 Apex wire 데이터 미관리).

**12. Wire 메서드 호출 시점?** 반응형 매개변수 변경 시·컴포넌트 초기화 시.

**13. 라이프사이클 훅?** Constructor(생성), connectedCallback(DOM 추가), renderedCallback(렌더링 후, 자식→부모, LightningElement), disconnectedCallback(제거), errorCallback(자손 오류).

**14. Quick Action에서 LWC?** 가능(레코드 페이지에서만).

**15. Promise·단계?** 비동기 트랜잭션 완료/오류 알림 객체. then(성공)·catch(실패). 단계: Pending·Fulfilled·Rejected.

**16. Web Components?** 재사용·격리 커스텀 HTML 태그 API(Shadow DOM·Custom Elements·HTML Templates). LWC는 Web Components 기반.

**17. connectedCallback vs renderedCallback?** connectedCallback은 DOM 삽입 시, renderedCallback은 렌더링 후. 초기화·업데이트 효율 처리에 중요.

**18. 콜백 함수 동기/비동기?** 컨텍스트에 따라. setTimeout·fetch는 비동기, forEach는 동기.

**19. Callback Hell?** 다중 중첩 콜백으로 복잡·유지보수 곤란.

**20. 데코레이터?** @track, @api, @wire.

**21. var vs let?** var는 함수 스코프·재선언 가능·호이스팅, let은 블록 스코프·재선언 불가·나은 스코핑.

**22. LMS?** Lightning Message Service. LWC·Aura·VF 간 통신. 메시지 브로드캐스트·수신.

**23. LWC에 Application Event?** 없음. 표준 DOM 이벤트 모델·Custom Event 사용.

**24. String Interpolation?** 문자열에 표현식·변수 삽입. 템플릿 리터럴(백틱).

**25. "Cannot Assign to Read Only Property" 오류?** 읽기 전용 속성에 값 할당 시. 부모에서 전달된 public 속성을 직접 변경하거나 불변 객체 수정 시.

**26. 데이터 전달?** Properties(부모→자식, @api), Events(자식→부모, custom event).

**27. Child→Parent 통신?** custom event(CustomEvent dispatch, 부모 수신·처리).

**28. 조건부 렌더링?** if:true·if:false 디렉티브(Boolean 속성).

**29. === vs ==?** ==는 타입 강제 변환, ===는 타입 다르면 false. `2 == "2"`는 true, `2 === "2"`는 false.

**30. 비동기 처리?** 사용자 입력·백그라운드 계산·서버 조회 관리. UI 반응성 보장.
