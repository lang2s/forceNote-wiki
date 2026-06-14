---
tags: [apex, trigger, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [SF Scenerio based Questions]
---

# Salesforce 면접 질문 (시나리오 + 주제별)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## 시나리오 기반 질문

**1. Case가 origin='Phone'으로 생성되면 status='New', Priority='High'.**
```apex
trigger CaseOrigin on Case (before insert) {
    for(Case c : trigger.new){
        if(c.origin == 'Phone'){
            c.status = 'New';
            c.priority = 'High';
        }
    }
}
```

**2. Lead가 LeadSource='Local'이면 rating='Cold', 아니면 'Hot'.**
```apex
trigger LeadScenario on Lead (before insert) {
    for(Lead ld : trigger.new){
        if(ld.leadsource == 'Local') ld.Rating = 'Cold';
        else ld.Rating = 'Hot';
    }
}
```

**3. 테스트 클래스에 Test.startTest()와 Test.stopTest()가 필요한가?**
주로 테스트 실행 컨텍스트 내에서 거버너 한도를 재설정하고 비동기 메서드를 테스트하기 위해 존재. testMethod 내에서 두 번 이상 호출 불가. 필수는 아니지만 일부 상황에서는 중요.

**4. 자식 오브젝트 권한이 없고 부모 오브젝트 권한만 있는 사용자가, 부모 생성 후 자식 레코드를 삽입하는 트리거가 있을 때, 수동으로 부모를 삽입하면 자식 레코드가 생성되는가?**
예, 자식 레코드가 생성됩니다. (트리거는 시스템 컨텍스트로 실행)

**5. 자식 컴포넌트에서 부모 컴포넌트로 값을 전달하려면 어떤 이벤트를 쓰는가?**
Component 이벤트. 자식이 발생시키고 부모가 처리.

**6. 새 버튼으로 기본값이 채워진 Account 생성 화면을 열려면?**
`force:createRecord` 이벤트 사용.
```js
createRecord : function (component, event, helper) {
    var createRecordEvent = $A.get("e.force:createRecord");
    createRecordEvent.setParams({ "entityApiName": "ObjectApiName" });
    createRecordEvent.fire();
}
```

**7. 프로필 'ReadAccessProfile'에 User1·User2가 할당. 오브젝트 X에 User1=읽기/쓰기, User2=읽기전용을 주려면?**
- 1단계: 공통인 읽기 접근은 프로필에서 'Read' 부여(User2 충족).
- 2단계: 권한 집합 'GrantWriteAccess'를 만들어 X에 쓰기 권한 부여 후 User1에 할당(User1 충족).

**8. 관련 없는 Object1·Object2에 Master-Detail 관계를 만들려면?**
- 시나리오 1(레코드 없음): Setup에서 필드 생성으로 바로 MDR 생성.
- 시나리오 2(레코드 존재): 먼저 Lookup 관계 생성→모든 값 채움→Lookup을 Master-Detail로 변환.

**9. 레코드를 휴지통에도 안 남기고 삭제하려면?**
Hard Delete. Apex에서 `emptyRecycleBin()` 호출.

**10. before insert에서 올바른 컨텍스트 변수는 Trigger.new인가 Trigger.newMap인가?**
Trigger.new만 지원. 삽입 전엔 레코드 Id가 없어 Trigger.newMap 미지원.

## 주제별 면접 질문

### A. Salesforce 기초

**1. 프로필 vs 역할? 한 사용자에 프로필 두 개 할당 가능?**
프로필은 필드 수준 보안, 페이지 레이아웃, 커스텀 앱, 레코드 타입, 로그인 시간, 탭을 제어. 표준 프로필·커스텀 프로필 두 종류. 한 사용자는 프로필 하나만 가짐.

**2. 거버너 한도?** 멀티테넌트 공유 플랫폼에서 리소스 독점 방지를 위해 강제하는 한도(트랜잭션당 Apex 한도, 관리 패키지 한도, 정적 Apex 한도, 인바운드 이메일, SOQL/SOSL, 푸시 알림, API 요청 등). 라이선스/버전별로 다름.

**3. 프로덕션에서 Apex 트리거/클래스, Visualforce를 편집할 수 있나?** 트리거·클래스는 편집 불가(개발 환경에서 변경 후 배포). 

**4. 샌드박스와 종류?** 프로덕션 복사본으로 영향 없이 테스트. 4종: Developer(200MB, 일일 갱신, 개발), Developer Pro(1GB, 일일, 통합 테스트), Partial Copy(5GB, 5일, 종단 테스트), Full(프로덕션 크기, 28일, UAT).

**5. 표준 프로필?** System Administrator, Standard User, Marketing User, Solution Manager, Read Only, Contract Manager.

**6. 관계 유형?**
- **Master-Detail**: 마스터-디테일 강결합. 마스터 삭제 시 디테일 삭제. 오브젝트당 2개, 롤업 요약 가능.
- **Lookup**: 느슨한 결합. 부모 삭제해도 자식 유지. 각자 공유·보안. 오브젝트당 40개.
- **Many-to-Many**: Junction 오브젝트에 Master-Detail 2개로 구현.
- **Self**: 같은 오브젝트와의 관계(예: 상위 Account).
- **External**: Salesforce Connect의 외부 오브젝트 간 관계(18자 Id 사용).

**7. SOQL vs SOSL?** SOQL은 한 번에 한 오브젝트 조회, DML 가능한 레코드 반환. SOSL은 여러 오브젝트 텍스트 검색, 트리거에서 불가, 필드 결과 반환, DML 불가.

**8. 권한 집합 vs 공유 규칙?** 권한 집합은 프로필 변경 없이 기능 접근 확장. 공유 규칙은 공개 그룹·역할·영역 사용자에게 조직 공유 설정 예외로 접근 확장.

**9. 프로덕션 배포 방법?** Change Sets, Force.com Migration Tool(ANT), Salesforce Package, VSCode 확장팩, Code Builder.

**10. 프로덕션 배포 최소 테스트 커버리지?** 75%.

### B. Lightning

**1. Lightning 컴포넌트 번들 구성?** Component, Controller, Helper, Style, Documentation, Renderer, SVG, Design.

**2. 컴포넌트 모델?** Aura, Lightning Web Component.

**3. Lightning App Builder?** 포인트앤클릭으로 Lightning 페이지 생성(App/Home/Record 페이지). Lightning 컴포넌트 드래그앤드롭.

**4. 서버·클라이언트 언어?** 클라이언트=JavaScript, 서버=Apex.

**5. Lightning 도구?** App Builder, Connect, Schema Builder, Process Builder.

**6. 장점?** 성능, 기본 제공 컴포넌트, 빠른 개발, 멀티 디바이스·크로스 브라우저, 이벤트 기반 아키텍처, 풍부한 컴포넌트 생태계.

**7. 앱당 컴포넌트 수 제한?** 없음.

**8. 어디서 사용?** App Builder·Community Builder 드래그앤드롭, Quick Action, Lightning 페이지·Record 페이지, 독립 앱, 표준 액션 오버라이드.

**9. Lightning 페이지 할당?** 조직 기본값, 앱 기본값, 앱·레코드 타입·프로필.

**10. 프레임워크 종류?** 컴포넌트 기반.

### C. 리포트와 대시보드

**1. 리포트 유형?** Tabular(기본), Summary(행 그룹화·정렬), Matrix(행·열 그룹화), Joined(여러 리포트 타입).

**2. 버킷 필드?** 리포트에서 레코드를 분류하는 필드. 정렬·필터·그룹화에 사용.

**3. 표준 vs 커스텀 리포트?** 표준은 오브젝트·관계 생성 시 자동 생성. 커스텀은 관리자가 필드 지정, 최대 4개 오브젝트 연결.

**4. 대시보드?** 리포트의 그래픽 표현. 최대 20개 컴포넌트. 마지막 실행 리포트 데이터 표시.

**5. 동적 대시보드?** 사용자 보안 설정에 따라 표시. 자동 갱신 없음(페이지 새로고침 시).

**6. 리포트 페이지당 표시 레코드?** 2,000건. 초과 시 Excel 내보내기.

**7. 리포트에 수식 필드?** Tabular 제외 모든 유형 가능. 통화·퍼센트·숫자 타입.

**8. 대시보드 생성 가능 리포트?** Summary, Matrix.

**9. Data Loader로 리포트 삭제 가능?** 불가.

**10. Joined 리포트 미지원?** 버킷 필드, 교차 필터, 표시 행 필터.

### D. 트리거·워크플로우·Process Builder

**1. 트리거와 유형?** 레코드 이벤트 전후 커스텀 액션. Before(insert/update/delete), After(insert/update/delete/undelete).

**2. Process Builder?** 비즈니스 프로세스 자동화 워크플로우 도구. 레코드 생성·업데이트, Flow 실행, 이메일, Chatter, 승인 제출 가능. 아웃바운드 메시지 제외 워크플로우 기능 포함.

**3. 워크플로우?** 자동화 도구: 태스크 할당, 이메일 알림, 아웃바운드 메시지, 필드 업데이트.

**4. 승인 프로세스?** 단계별 승인 가이드. 구성: 프로세스 정의, 초기 제출 액션, 단계 정의, 최종 거부 액션, 최종 승인 액션.

**5. 재귀 트리거와 방지?** 트리거가 자신을 반복 호출하는 상황. static 변수로 상태 확인 후 실행.

**6. Process Builder vs Flow Builder?** Process Builder는 단순·선형. Flow Builder는 강력(삭제 기능, 다중 레코드 업데이트). Process Builder는 시작 부모의 자식 레코드만 업데이트 제한.

**7. 액션 스케줄링 조건?** ① 레코드 생성 시에만, ② 생성·편집 시 정의된 기준 충족.

**8. 큐(Queue)?** 미리 정의된 오브젝트·사용자 집합. 큐의 누구나 작업을 가져가 완료. 사용자·공개 그룹·파트너 사용자·역할 등 포함.

**9. 컨텍스트 변수?** isExecuting, isInsert, isUpdate, isDelete, isBefore, isAfter, isUndelete, new, newMap, old, oldMap, size.

**10. 트리거·Process Builder·워크플로우 실행 순서?** Trigger → Workflow → Process Builder.

### E. 통합과 테스트

**1. 통합?** 두 애플리케이션 연결. 서로 다른 비즈니스 로직·데이터·보안 계층을 통합해 효율·일관성·품질 확보.

**2. 통합 방법 3가지?** UI 통합(합성 앱), 비즈니스 로직 통합(인바운드=Apex Web Services, 아웃바운드=Apex Callouts), 데이터 통합(SOAP/REST API).

**3. API 종류(11개)?** REST, SOAP, Bulk, Streaming, Metadata, Chatter REST, User Interface, Analytics REST, Apex REST, Apex SOAP, Tooling.

**4. 웹 서비스?** 개방 표준(XML, SOAP, HTTP) 기반으로 다른 앱과 데이터 교환.

**5. JSON?** JavaScript Object Notation. XML보다 가볍고 텍스트 기반. 서버 간 메시지 전송.

**6. 테스트 클래스가 필요한 이유?** Apex 클래스·트리거 단위 테스트. 배포 시 75% 이상 커버리지 필요.

**7. 간단한 테스트 메서드 구문?**
```apex
@isTest
private class MyTestClass {
    static testMethod void myTest1() { }
    static testMethod void myTest2() { }
}
```

**8. Assert 문?** 실제 값과 기댓값 비교. system.assertEquals, system.assertNotEquals.

**9. seeAllData?** 테스트 클래스는 기본적으로 DB 데이터를 못 봄. `@isTest(seeAllData=true)`로 인식.

**10. Apex에서 테스트할 것?** 단일 레코드, 벌크 레코드, 긍정 시나리오, 부정 시나리오, 제한된 사용자.

### F. Apex·Aura·Visualforce·LWC

**1. LWC와 번들 구성?** JavaScript 중심 신 프로그래밍 모델, Apex 불필요. 번들: HTML, JavaScript, XML. CLI 필요.

**2. Imperative vs Wired Apex 메서드?** Wired는 페이지 새로고침/반응형 속성 변경 시마다 호출, 불변 데이터, Read만, @wire 사용, refreshApex()로 갱신. Imperative는 명시적 호출, 가변 데이터, DML 가능(cacheable=true면 불가), Promise로 호출.

**3. @api와 @track?** @api는 속성/함수를 public으로. @track은 Summer 19 이후 기본 반응형이라 배열·객체 요소 변경 시 재렌더링용.

**4. LWC 안에 Aura, 반대?** Aura를 LWC 안에 사용 불가. LWC를 Aura/Flow/페이지 컴포넌트 안에 사용 가능.

**5. Aura 데이터 타입?** String, Integer, Boolean, Decimal, Double, Long, DateTime, Date, Array, List, Set, Map, sObject.

**6. Aura 이벤트(3종)?** Component(자식→부모), Application(계층 무관 컴포넌트 간), Standard Out-of-Box(예: showToast).

**7. Visualforce?** HTML 같은 태그 마크업의 컴포넌트 기반 프레임워크. MVC 패러다임.

**8. Visualforce 컨트롤러?** 버튼·링크 동작 처리. Standard(save/edit/cancel/delete), Custom, Controller extensions.

**9. Wrapper 클래스?** 다른 객체들의 컬렉션을 인스턴스로 갖는 커스텀 클래스. 복잡한 비즈니스 시나리오에 유용.

**10. Static Resources?** 문서·파일·이미지·라이브러리(.zip/.jar) 업로드. $Resource 변수로 참조.
