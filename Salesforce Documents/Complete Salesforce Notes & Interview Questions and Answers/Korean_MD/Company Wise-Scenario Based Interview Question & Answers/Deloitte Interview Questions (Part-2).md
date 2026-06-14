# Deloitte 면접 질문 (Part 2)

**with sharing vs without sharing?** with sharing은 현재 사용자 공유 규칙만 적용(오브젝트·필드 권한 X). without sharing은 공유 규칙 미적용.

**Future 메서드로 오류 메시지 표시?** 불가. 필드에 오류 응답 저장 또는 이메일 발송.

**Account 15개 필드 중 Service팀 10개·Sales팀 5개 표시?** Field-Level Security + Page Layouts. 팀별 Field Set 생성, FLS로 프로필별 가시성 설정, 팀별 페이지 레이아웃 생성·할당.

**Sharing Rules?** 공개 그룹·역할·영역에 접근 확장(OWD보다 엄격할 수 없음). 오브젝트당 최대 300개(criteria 50개). Owner-Based, Criteria-Based.

**보안 방식 요약:** OWD(전체 기본), Role Hierarchy(매니저·하위), Sharing Rules(조건 기반 그룹·역할), Manual Sharing(수동).

**Re-evaluate 체크박스(워크플로우)?** true면 필드 업데이트가 값을 바꿀 때 관련 오브젝트의 모든 워크플로우 규칙 재평가.

**Trigger Framework?** 트리거를 조직·구조화·관리하는 아키텍처 패턴. 핵심: 모듈성, 단일 책임 원칙(SRP), 관심사 분리, 벌크화, 거버너 한도 관리, 테스트 지원, 오류 처리, 버전 관리·문서화.

**Process Builder + Apex?** 코드 없는 시각적 자동화 도구. @InvocableMethod 클래스를 Process Builder에서 호출(객체 연결→기준 추가→Apex 클래스 액션 선택→매개변수 설정).

**Process Builder vs Workflow?** Process Builder가 더 발전. 액션: 레코드 생성·업데이트, Quick Action, Flow, 이메일, Chatter, 승인, Apex(아웃바운드 메시지 제외). Workflow: Task 생성, 필드 업데이트, 이메일, 아웃바운드 메시지. Process Builder는 비주얼 디자이너·관련 레코드 모든 필드 업데이트·기준 순서 제어·다중 if-then·버전 관리. 시작: 레코드 변경·다른 프로세스 호출·플랫폼 이벤트.

**Upsert?** External ID 또는 Salesforce ID로 일치 시 업데이트, 불일치 시 생성. 벌크 upsert 지원.

**Batch에서 Future 호출?** 불가("Future method cant be called from future or Batch"). Future 제약: Apex 호출당 50개, 24시간 250,000회(전체 비동기 공유), static·void, Future에서 Future 호출 불가, VF 컨트롤러 getter/setter·생성자 불가, getContent/getContentAsPDF 불가.

## Salesforce 보안 (4계층)

**1. 조직 수준:** 인증 사용자 목록, 비밀번호 정책, 로그인 실패 한도, 로그인 시간·위치 제한(Org Level은 OTP, Profile Level은 차단), 이메일 도메인 제한. Health Check(High/Medium Risk).

**2. 오브젝트 수준:** Profile(직무 정의: 오브젝트·필드·사용자 권한, 탭·앱·로그인 시간·범위), Permission Set(프로필 변경 없이 추가 접근).

**3. 필드 수준:** 프로필 FLS, Permission Set, Field Accessibility. (Universally required 필드는 FLS 무관 표시. 롤업·수식 필드는 읽기 전용·편집 페이지 미표시.) 페이지 레이아웃은 상세·편집만 숨김, FLS는 List View·검색·관련 목록·VF·리포트 등 모든 곳 보안.

**4. 레코드 수준:** OWD → Role Hierarchy → Sharing Rule → Manual Sharing.

### OWD
- Private: 소유자·상위만 보기·편집.
- Public Read Only: 모두 보기, 소유자·상위만 편집.
- Public Read/Write: 모두 보기·편집, 소유자만 삭제.
- Public Read/Write/Transfer: Case·Lead만.
- Public Full Access: Campaign만.
- Controlled by Parent: Master-Detail 자식이 부모 접근 복사.

### Manual Sharing
수동 공유. 소유자·상위 역할·Full 접근·관리자만. OWD가 Private/Read Only일 때만 활성(Lightning 미지원).

**Lookup 관계에서 부모 삭제 시 자식 삭제(Master-Detail 한도 초과):**
```apex
trigger DeleteChildRecordsOnParentDelete on Parent_Object__c (before delete) {
    Set<Id> parentIds = new Set<Id>();
    for (Parent_Object__c parent : Trigger.old) parentIds.add(parent.Id);
    List<Child_Object__c> childRecordsToDelete = [SELECT Id FROM Child_Object__c WHERE Parent_Object__c IN :parentIds];
    delete childRecordsToDelete;
}
```

**Lookup 롤업 요약(트리거):**
```apex
trigger UpdateParentInvoiceTotal on Invoice_Line_Item__c (after insert, after update, after delete, after undelete) {
    Set<Id> parentIds = new Set<Id>();
    for (Invoice_Line_Item__c lineItem : Trigger.new) parentIds.add(lineItem.Invoice__c);
    List<Invoice__c> invoicesToUpdate = [SELECT Id, (SELECT Amount__c FROM Invoice_Line_Items__r) FROM Invoice__c WHERE Id IN :parentIds];
    for (Invoice__c invoice : invoicesToUpdate) {
        invoice.Total_Amount__c = 0;
        for (Invoice_Line_Item__c lineItem : invoice.Invoice_Line_Items__r) invoice.Total_Amount__c += lineItem.Amount__c;
    }
    update invoicesToUpdate;
}
```

**Mixed DML 오류?** 한 트랜잭션에서 setup·non-setup 오브젝트 DML 혼합 시(예: Account와 User Role). 해결: 다른 트랜잭션(Future), 테스트는 System.runAs 또는 @future.

**테스트 클래스 모범 사례:** @isTest, 긍정·부정 assert, @testSetup, Test.startTest/stopTest, System.runAs, seeAllData=true 회피, ID 하드코딩 금지, 200건, 75%+(가능하면 95%), @TestVisible, 콜아웃은 CalloutMock, 메서드당 startTest/stopTest 1개, static·void, 이메일 불가.

**AJAX 함수?** ActionFunction(JS로 컨트롤러 호출), ActionSupport(이벤트 트리거 서버 액션), ActionPoller(주기 업데이트), Remote Objects(JS CRUD), @RemoteAction(Apex를 원격 액션 노출), ActionRegion(독립 새로고침 섹션).

**render vs rerender vs renderAs?** render(초기 HTML 생성), rerender(부분 동적 갱신), renderAs(PDF·Excel·CSV 형식).

**Task·Event 기본 OWD?** Controlled by Parent 또는 Private 2가지만.

**Save Report vs Run Report?** Save는 리포트 정의 보존, Run은 실시간 결과 생성.

**Bucket vs Formula 필드(리포트)?** Bucket은 데이터 그룹화·범위, Formula는 리포트 내 계산·커스텀 지표.

**부모에서 자식 쿼리:** `SELECT Id, Name, (SELECT Id, FirstName, LastName FROM Contacts__r) FROM Account__c`

**Account 생성 시 생성자 User Id를 lookup에 채우기:** Process Builder(레코드 생성 시 → Update Records → User Lookup = 현재 사용자 Id).

**After insert에서 같은 오브젝트 업데이트?** 직접 불가(재귀·무한 루프 방지, 런타임 예외). 관련 레코드·다른 오브젝트는 가능.

**Forecasting?** 예상 매출 표현. 영업 파이프라인~마감 예측. 기간·예측 유형·조정·통화로 결정. Opportunity 집합의 총 롤업 기반.

**Territory Management?** 영역 기반 계정 접근 공유·데이터 구조화로 영업 운영 관리.

**트리거 유형·이벤트?** Before(저장 전 검증·업데이트), After(시스템 설정 필드 접근). 이벤트: before/after insert·update·delete, after undelete.

**Workflow와 시간 종속 워크플로우(15분 후 메일):** 워크플로우는 자동 프로세스(이메일·필드 업데이트·태스크·아웃바운드). 시간 종속은 지정 시간 후 액션. 이메일 템플릿 생성 → 워크플로우 규칙(기준 정의) → Time Trigger 추가(15분 후) → 이메일 알림 → 활성화.
