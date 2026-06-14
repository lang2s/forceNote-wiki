# Salesforce 질문과 답변 (100선)

**1. Apex 구문?** INSERT·UPDATE·DELETE 등 DML과 DML 예외 처리 내장. 인라인 SOQL/SOSL 지원(sObject 레코드 집합 반환). Java와 유사한 구문(변수 선언·루프·조건문).

**2. Apex가 단위 테스트(Test Class)를 지원하나?** 지원. 단, 테스트 클래스로는 메시지 전송·웹서비스 콜아웃 테스트 불가, 데이터 생성 커밋 불가.

**3. Apex 한도?** SOQL 쿼리: 동기 100/비동기 200. SOQL 반환 레코드: 50,000. SOSL 쿼리: 20. DML 문: 150.

**4. Apex 개발 도구?** Developer Console, Force.com IDE, Salesforce UI의 코드 에디터.

**5. aura:registerEvent?** 컴포넌트가 특정 이벤트를 발생시킬 수 있음을 선언. name 속성 포함, type은 component.

**6. $A.enqueueAction(action)?** 서버 요청을 비동기 서버 호출 큐에 추가. Lightning의 최적화 기능.

**7. List/Set/Map 구문과 차이?**
```apex
List<String> lists = new List<String>();
Set<String> sets = new Set<String>();
Map<Id, Value> maps = new Map<Id, Value>();
```
| List | Set | Map |
|---|---|---|
| 중복 허용 | 중복 불가 | 키 중복 불가 |
| 삽입 순서 유지 | 순서 미유지 | 순서 미유지 |
| null 다수 허용 | null 하나만 | null 키 하나, null 값 다수 |
| ArrayList, LinkedList | HashSet, TreeSet | HashMap, TreeMap |

**8. Salesforce 쿼리 언어?** SOQL, SOSL.

**9. SOQL로 두 오브젝트 데이터 조회?** 가능, 관계가 있으면.

**10/72. 트리거 모범 사례?** 오브젝트당 트리거 하나, 벌크화, SOQL for 루프, 필요한 이벤트만, 컨텍스트별 핸들러 메서드, 명명 규칙, 하드코딩 금지.

**11/73. 테스트 클래스 모범 사례?** @isTest 필수, 75% 커버리지, 메서드당 assert 하나, @isTest/testMethod, TestFactory 클래스, 하드코딩 회피.

**12. seeAllData=true?** 조직 레코드에 데이터 접근 개방.

**13. 부모당 자식 하나 제한?** 트리거로 작성하거나, 수식 필드로 값을 ≤true로 설정.

**14. 리포트 유형?** Matrix, Tabular, Summary, Joined.

**15. 대시보드 유형?** Static, Dynamic.

**16. 동적 대시보드 스케줄?** 불가(수동 새로고침만 — 50, 85 참조).

**17/86. 보안 모델?** Object-level(프로필·권한 집합), Field-level(프로필), Record-level(OWD, 역할 계층, 공유 규칙, 수동 공유, Apex 관리 공유).

**18. Role vs Profile?** Role은 계층 내 위치(보고 관계), 하위에게 데이터 가시성, 필수 아님. Profile은 필수, 사용자당 1개, 데이터 가시성 결정.

**19. 워크플로우 평가 기준?** Created, Created and edited, Created/edited 후 후속 기준 충족.

**20. Cascade delete?** Master-Detail에서 부모 삭제 시 자식 자동 삭제(내장 기능).

**21. Process Builder 액션(8종)?** 레코드 생성·업데이트, Flow 실행, Quick Action, Apex, 이메일, Chatter, 승인 제출.

**22/87. Cascade delete 장단점?** 자식 오브젝트 권한 없어도 부모 삭제 시 자동 삭제 → 공유 설정 override(단점).

**23. Record Type 중요성?** 오브젝트별 다른 페이지 레이아웃, 다른 선택 목록 값, 레이아웃별 필드 접근 제한, 프로필·레코드 타입으로 생성 제한.

**24. Page Layout 중요성?** 상세·편집 페이지 디자인·구성 커스터마이즈. 필드·관련 목록·커스텀 링크 표시 제어.

**25. 프로필당 오브젝트당 페이지 레이아웃?** 레코드 타입당 프로필당 하나만.

**26. 필드 필수화 방법?** 필드 생성 시, 페이지 레이아웃, 검증 규칙, 트리거.

**27. Aura 컴포넌트에서 Apex 클래스 사용?** Apex에 @AuraEnabled 정의, Aura에 컨트롤러로 클래스명 지정.

**28. Trigger vs Process Builder?** Process Builder는 before DML·delete·undelete 불가, 트리거는 가능. Process Builder는 all-or-none(전체 실패), 트리거는 부분 실행 가능. 트리거가 예외 처리 더 구체적.

**29. 모든 클래스에 테스트 클래스 필수?** 예(모범 사례).

**30. 비동기 프로세스?** 별도 스레드/백그라운드에서 실행, 작업 대기 불필요, 더 높은 한도 제공.

**31. 비동기 Apex 유형?** Future Method(자체 스레드, 리소스 가용 시 실행, 웹서비스 콜아웃), Batch Apex(대용량 작업, 데이터 정리·아카이빙), Queueable(Future 유사 + 작업 체이닝), Scheduled(특정 시간, 일·주간 작업).

**32. aura:if?** 서버에서 isTrue 표현식 평가, body 또는 else 중 하나만 생성·렌더링. 조건 전환 시 현재 브랜치 파괴·다른 브랜치 생성.

**33/88. Aura Bundle?** Controller, Helper, SVG, CSS, Renderer, Design, Documentation, Component.

**34. Lightning이 MVC 기반인가?** 예. Model-View-Controller. 신뢰성·높은 재사용·낮은 개발 비용·유지보수 용이.

**35. helper.js 용도?** 컴포넌트 내 재사용 함수. 데이터 처리·서버 액션 큐잉 등 특화. 코드 재사용, 무거운 JS 로직을 클라이언트 컨트롤러에서 분리.

**36. Lightning 서버/클라이언트 상태?** Stateful 클라이언트 + Stateless 서버. 필요 시에만 서버 호출, 필요 데이터만 전송.

**37. Database.BatchableContext?** Batch Apex 정보 보유(실행 추적).

**38. Aura 이벤트(3종)?** Component(자식→부모), Application(계층 무관 컴포넌트 간), Standard(예: showToast).

**39. Database.Stateful?** Batch에서 처리 레코드 총 카운트 유지 시 사용(상태 유지).

**40. Service Cloud?** 고객 서비스·지원용 CRM. 리포트 커스터마이즈, 라이브 에이전트 웹챗, Service Entitlement, 지식 관리, Case 관리.

**41. Custom vs Standard 오브젝트?** Standard는 Salesforce 기본 제공(Account, Contact, Lead, Opportunity). Custom은 회사·산업 특화 정보 저장용 생성.

**42. Lookup vs Master-Detail?**
- **Master-Detail**: 강결합 부모-자식, 마스터 없이 디테일 생성 불가, 공유 규칙 상속, 마스터 변경 불가, 오브젝트당 2개, 롤업 요약 가능, cascade delete.
- **Lookup**: 느슨한 결합, 직접 의존 없음, 최대 40개, 공유 규칙·프로필 권한·cascade 없음, 부모 삭제 시 자식의 참조 필드만 삭제.

**43. OWD?** Organization-Wide Defaults. 가장 제한된 사용자가 가져야 할 기준 접근 수준. 접근 제한용. 공유 규칙·역할 계층·팀·수동 공유·Apex 공유로 확장.

**44. 권한 집합 사용 이유?** 프로필 변경 없이 추가 접근 부여.

**45. 권한 집합으로 접근 제한 가능?** 불가(확장만).

**46. 프로필?** 사용자가 할 수 있는 것을 정의하는 설정·권한 집합. 오브젝트·필드·사용자 권한, 탭·앱 설정, Apex 클래스 접근 제어.

**47. Invocable Method?** @InvocableMethod로 Flow에서 Apex 호출. 루프 밖에서 레코드 한 번 조회 후 처리.

**48. Flow Designer에서 변수 데이터 타입 변경?** 생성 후 변경 불가.

**49. Bucket 필드?** 복잡한 수식·커스텀 필드 없이 범위·세그먼트로 레코드 그룹화. 그룹·필터·정렬.

**50. 동적 대시보드?** 특정 사용자 맞춤 정보. 스케줄 불가(실시간 표시).

**51. 종속 선택 목록(Dependent Picklist)?** 유효 값이 다른 필드(controlling field)에 종속.

**52. Schema Builder?** 오브젝트·필드·관계를 그래픽 인터페이스로 보고 관리하는 도구.

**53. One-to-One 관계?** Salesforce는 직접 방법 미제공.

**54. Unique 필드?** 같은 값을 여러 레코드에 사용 불가. External ID에 자주 사용.

**55. Promises?** 비동기 호출 성공/실패 처리, 작업 체이닝 단순화. 주로 콜아웃·CRUD에 사용.

**56. Sales Cloud?** 영업·마케팅·고객 지원 CRM(B2B/B2C). Account/Contact 관리, Opportunity·Lead 관리.

**57. 새 데이터 타입?** Time.

**58. Cross-object 수식?** 관련 두 오브젝트에 걸친 수식(머지 필드 참조). Master-Detail의 디테일에서 부모 참조 가능, Lookup도 가능.

**59. 레코드 삭제 가능 자동화 도구?** Flow.

**60. Governor Limit?** 멀티테넌트 환경에서 효율적 처리를 위한 사용 상한.

**61. Salesforce 아키텍처?** 다층 구조. Application(기능), Platform(데이터 서비스·AI·API), Salesforce(신뢰·멀티테넌트 클라우드). 사용자가 최상위 계층.

**62. Lead Assignment Rule?** 수동·Web-to-Lead·Data Import Wizard로 생성된 Lead 자동 할당.

**63. Web-to-Case / Web-to-Lead?** 외부 웹사이트에서 Lead·Case를 자동 캡처해 Salesforce 레코드 생성. HTML 폼 생성.

**64. Workflow vs Process Builder?** Process Builder가 더 발전(액션 다양: 레코드 생성·업데이트, Quick Action, Flow, 이메일, Chatter, 승인, Apex). 아웃바운드 메시지 미지원. Workflow 액션: Task 생성, 필드 업데이트, 이메일 알림, 아웃바운드 메시지. Process Builder는 비주얼 디자이너 제공, 관련 레코드 모든 필드 업데이트 가능(Workflow는 Master-Detail 부모 일부만).

**65. Flow?** 데이터 수집·액션 수행. Screen Flow, Autolaunched Flow.

**66. 관계?** 두 오브젝트 간 양방향 연결. 커스텀 관계 필드로 생성.

**67. Account-Contact 관계?** Lookup(Account 없이 Contact 생성 가능). 단, Account 삭제 시 Contact도 삭제되는 특이 동작.

**68. Campaign?** 특정 마케팅 커뮤니케이션 대상 Lead·Contact 그룹. 성과 지표 저장.

**69. List/Set/Map 정의?** List는 인덱스로 구분되는 순서 있는 컬렉션. Map은 키-값 쌍. Set은 중복 없는 순서 없는 컬렉션. 모두 모든 데이터 타입 가능.

**74. Scratch Org (LWC)?** 개발·테스트용 일회용 org. 최대 30일(기본 7일) 후 비활성화.

**75. Parent→Grandparent 통신?** Component event 사용.

**76. Aura attribute?** 앱·인터페이스·컴포넌트·이벤트의 속성 기술. access: public(기본)/global/private.

**77. Batch에서 Finish 메서드 미사용 시?** 컴파일 오류(필수).

**78. Execute 메서드 동작?** 한 번에 200건 처리. 각 배치마다 호출.

**79. Batch에서 Future 호출?** 불가("Future method cant be called from future or Batch" 오류).

**80. Batch에서 Batch 호출?** Queueable 사용 또는 Batch의 finish 메서드 사용.

**81. Future에서 Batch?** 제약: Apex 호출당 future 메서드 50개 이하.

**82. 트리거 명명 규칙?** camelCase(예: apexHours). 가독성·유지보수.

**83. aura:method?** 컴포넌트 API의 메서드 정의. 이벤트 발생 없이 클라이언트 컨트롤러 메서드 직접 호출. 부모가 자식 메서드 호출 단순화.

**84. runAs (테스트)?** 테스트에서 사용자 컨텍스트 변경, 레코드 공유 강제. 단, 사용자/필드 권한은 강제 안 함.

**85. 동적 대시보드 스케줄?** 불가(수동 새로고침).

**89. Data Loader vs Import Wizard?** Import Wizard는 Setup 내 도구. Data Loader는 외부 도구.

**90. Decorators (LWC)?** @api(public 속성, 반응형), @track(private 반응형, 변경 시 재렌더링), @wire(반응형 wire 서비스로 Salesforce 데이터 읽기).

**91. Imperative 메서드 (LWC)?** 호출 시점 제어(버튼 클릭 등). 단일 응답. cacheable=true 아닌 메서드(insert/update/delete), 호출 시점 제어, User Interface API 미지원 오브젝트(Task·Event)에 사용. stale 데이터 새로고침은 getRecordNotifyChange().

**92. CRM 유형?** Strategic, Operational, Analytical, Collaborative.

**93. Salesforce를 많이 쓰는 이유?** 데이터 기반 의사결정, 연결된 브랜드 여정, 개인화 경험.

**94. Trigger.new vs Trigger.newMap?**
- Trigger.New: 트리거 오브젝트의 레코드 컬렉션(List 유사). 모든 이벤트에서 사용(before insert/update, after insert/update/undelete).
```apex
trigger CaseTrigger on Case (before insert){
    for(Case c: Trigger.New){
        c.Subject = 'This case is being updated by trigger logic.';
    }
}
```
- Trigger.NewMap: ID→레코드 Map. After Insert, Before Update, After Update, After Undelete만.
```apex
trigger AccountTrigger on Account (After insert){
    List<Case> cLst = [SELECT Subject FROM Case WHERE AccountId IN :Trigger.NewMap.keySet()];
    for(Case c: cLst){ /* 로직 */ }
}
```
- **선택:** new는 목록 순회(특히 ID 미생성 전), newMap은 알려진 ID로 특정 레코드 접근 시.

**95. After undelete?** 휴지통에서 undelete DML로 복구된 레코드에만 동작.

**96. Application event?** 관계 무관하게 같은 앱 내 어떤 컴포넌트든 처리.

**97. Aura vs LWC 이벤트?** Component 이벤트는 자식-부모 통신(버블링·캡처). Application 이벤트는 등록된 모든 컴포넌트에 알림.

**98. Custom Settings?** 커스텀 오브젝트 유사하나, 조직 전반 커스텀 데이터셋 활용. 사용자·프로필별 구분 가능.

**99. SOQL?** Salesforce 데이터 검색. SQL SELECT 유사하나 Salesforce 전용.

**100. assertEquals?** 두 값이 같은지 검증(테스트 메서드). 다르면 런타임 예외.
