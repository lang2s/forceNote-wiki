---
tags: [lwc, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Salesforce Scenerios Interviews (LWC)]
---

# Salesforce LWC Q&A 질문과 답변

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

**1. LWC 구조?**

HTML·JS·CSS·XML.

**2. 폴더 구조 각 부분?**

HTML(마크업), JS(로직·동작), CSS(스타일), XML(메타데이터·타깃).

**3. 명명 규칙?**

camelCase로 시작·소문자, 영숫자·언더스코어만(대시 불가), HTML 참조는 kebab-case.

**4. SLDS?**

Salesforce Lightning Design System. 일관된 UI 프레임워크.

**5. LWC 장점?**

네이티브 웹 표준, 성능·빠른 렌더링, 단순 개발·디버깅.

**6. 두 LWC 통신?**

Parent→Child(@api), Child→Parent(custom event).

**7. 이벤트?**

컴포넌트 통신. 표준(click·change), 커스텀(정의·dispatch).

**8. 이벤트 버블링?**

자식에서 DOM 트리 위로 전파.

**9. 데코레이터 유형?**

@api, @track, @wire.

**10. 각 데코레이터?**

@api(public·통신), @track(private 반응형, 배열·객체 깊은 변경 추적), @wire(Salesforce 데이터 상호작용).

**11. CompA→CompB 데이터?**

@api로 Parent→Child. childComp에 @api messageFromParent.

**12. CompB→CompA?**

custom event dispatch, 부모가 on 접두로 수신·handler.

**13. Promise?**

비동기 코드, 완료 시 성공/실패. Pending·Fulfilled·Rejected.

**14. Apex 호출?**

wire(@AuraEnabled(cacheable=true), 캐시·DML 불가) 또는 imperative(cacheable 없음, DML 가능·promise 반환).

**15. 라이프사이클 훅?**

constructor·connectedCallback·renderedCallback·disconnectedCallback·errorCallback. (자식은 connectedCallback 후·renderedCallback 전 실행)

**16. 조건부 렌더링?**

template if:true 또는 lwc:if·lwc:elseif·lwc:else.

**17. for:each vs map?**

for:each는 반복 중 요소 업데이트 가능하나 새 배열 미반환, map은 수정된 새 배열 반환.

**18. Aura에서 LWC?**

Aura 안에 LWC 가능, 역은 불가.

**19. 버블링 vs 캡처링?**

자식→조부모 통신 시 bubbles·composed=true로 Shadow 경계 통과. 버블링은 아래→위, 캡처링은 위→아래.

**20. 독립 컴포넌트 통신?**

LMS(message channel·publisher·subscriber).

**21. 컴포넌트 안 보임 디버그?**

① isExposed=true, ② 올바른 target(lightning__AppPage 등), ③ Apex 클래스 sharing, ④ SOQL user/system 모드, ⑤ 프로필·권한 집합 Apex 접근.

**22. Apex 없이 Contact 생성 폼?**

lightning-record-form(Save 시 onsuccess).

**23. 동적 message 값(페이지별)?**

meta xml에 targetConfig·property(type·default·label) 정의.

**25. LMS?**

관계 없는 컴포넌트·Aura·VF 간 통신.

**26. LDS?**

Apex 없이 LWC가 Salesforce 데이터 상호작용. 클라이언트 측 데이터 조회·관리.

**27. async vs await?**

async는 promise 반환 함수 정의, await는 promise(resolve/reject)까지 실행 일시정지.

**28. uiRecordApi?**

레코드 생성·업데이트·삭제 메서드. createRecord·deleteRecord·getFieldValue 등.

**29. @wire에서 DML?**

불가(캐시 조회).

**30. super()?**

constructor에서 부모 클래스 속성 호출(필수).

**31. Component vs Application 이벤트?**

Component는 부모-자식 통신, Application은 다중 컴포넌트 글로벌(pub-sub).

**32. promise.all vs promise.race?**

all은 모든 promise 충족 시 반환(하나 reject 시 즉시 reject), race는 가장 먼저 settle되는 단일 promise 반환.

**33. Deep vs Shallow copy?**

Shallow는 중첩 속성 참조(스프레드 연산자), Deep은 참조 없이 복사(JSON.stringify(JSON.parse())).

**34. reduce?**

배열 요소를 단일 값으로 누적. (index=누산기, currentItem=현재 값, 0=시작점)

**35. Jest?**

JS 단위 테스트 도구(LWC 전용, Aura 미지원).

**37. 데이터 바인딩?**

JS 컨트롤러와 HTML 템플릿 연결·동기화. 단방향·양방향.

**38. 기본 바인딩?**

단방향.

**39. 단방향?**

JS→HTML. 데이터 제어·의도치 않은 수정 방지(읽기 전용·자식 전달).

**40. 양방향?**

UI↔JS. @track·이벤트 핸들러. 인터랙티브 컴포넌트.

**41. this 키워드?**

현재 코드 실행 컨텍스트(컴포넌트 속성·메서드 접근).

**42. Lightning Data Table?**

표 형식 데이터 표시. 정렬·인라인 편집·페이지네이션·커스텀 셀.

**43. lightning-record-form?**

LDS 기반 레코드 추가·보기·업데이트 폼(Apex 불필요, FLS·공유 처리).

**44. 조건부 렌더링?**

if:true·if:false로 동적 표시.

**45. connectedCallback()?**

DOM 삽입 시. 부모→자식.

**46. renderedCallback()?**

템플릿·자식 렌더링 후. 자식→부모.

**47. disconnectedCallback()?**

DOM 제거 시.

**48. 이벤트 전파?**

버블링·캡처링.

**49. 직렬화?**

객체를 문자열(JSON)로 변환(저장·전송·통신).

**50. getRelatedListCount?**

LDS로 관련 목록 레코드 수 조회(전체 조회 없이).

**51. connectedCallback에 wire?**

불가.

**52. JSON.stringify?**

JS 객체를 JSON 문자열로(전송·표시·디버깅).

**53. 현재 사용자 ID(Apex 없이)?**

`import Id from '@salesforce/user/Id'`.

**54. Toast 알림?**

ShowToastEvent(lightning/platformShowToastEvent).

**55. NavigationMixin?**

페이지·레코드·앱 간 프로그래밍 내비게이션(lightning/navigation).

**56. VF에서 LWC?**

lightning:container 태그로 가능.

**57. 선택 목록 조회(Apex 없이)?**

getPicklistValues wire 어댑터(lightning/uiObjectInfoApi).

**58. refreshApex()?**

수동 데이터 새로고침(LDS 확장).

**59. reportValidity()?**

제출 전 필수 필드·검증 확인.

**60. 특정 레코드 조회?**

getRecords wire 어댑터(다중 레코드 단일 호출).

**61. wire 다중 호출?**

라이프사이클 중 여러 번 호출 가능.

**62. Static Resource import?**

@salesforce/resourceUrl.
