# Salesforce 시나리오 기반 질문 (Admin & 개발)

## 트리거 시나리오 (코드)

### 1. Account 삽입 시 Contact 자동 생성
```apex
trigger SCENARIO1 on Account (after insert) {
    list<contact> c = new list<contact>();
    for(Account a : trigger.new){
        Contact b = new Contact();
        b.LastName = a.Name;
        b.AccountId = a.Id;
        c.add(b);
    }
    insert c;
}
```

### 2. Contact 삽입 시 Account 자동 생성 (+ 재귀 방지)
```apex
trigger scenario2 on Contact (after insert) {
    if(Recursive.flag){
        Recursive.flag = false;
        list<account> a = new list<account>();
        for(Contact c : trigger.new){
            Account a1 = new Account();
            a1.Phone = c.Phone;
            a1.Name = c.LastName;
            a.add(a1);
        }
        insert a;
    }
}
// 재귀 방지 클래스
public class Recursive {
    public static boolean flag = true;
}
```

### 3. Opportunity 생성 시 Account에 총 Opportunity 수·총 금액
```apex
trigger scenario24 on Opportunity (after insert) {
    set<id> ids = new set<id>();
    for(Opportunity op : trigger.new) ids.add(op.accountid);
    list<account> ac = [SELECT Total_opportunities__c, Total_Amount__c,
        (SELECT id, Amount FROM Opportunities) FROM account WHERE id = :ids];
    for(Account a : ac){
        a.Total_opportunities__c = a.opportunities.size();
        decimal sum = 0;
        for(Opportunity p : a.opportunities) sum += p.amount;
        a.Total_Amount__c = sum;
    }
    update ac;
}
```

### 4. Contact Department='CSE'면 before insert로 Email 채우기
```apex
trigger scenario4 on Contact (before insert) {
    for(Contact c : trigger.new){
        if(c.Department == 'CSE') c.Email = 'naveengorentla1@gmail.com';
    }
}
```

### 5. Inputout__c의 Doctor Name 수정 시 관계 없는 Dropoff1__c 텍스트 필드 업데이트
```apex
trigger SCENARIO32 on Inputout__c (after update) {
    list<Dropoff1__c> d = [SELECT id, name, Text__c FROM Dropoff1__c WHERE Text__c = 'naveen'];
    string name;
    for(Inputout__c c : trigger.new) name = c.Doctor_Name__c;
    for(Dropoff1__c dp : d) dp.Text__c = name;
    update d;
}
```

### 6. 하루 레코드 한도 도달
```apex
trigger SCENARIO6 on Account (before insert, before update) {
    integer count = 0;
    list<account> a = [SELECT id, name FROM account WHERE createddate = today OR lastmodifieddate = today];
    for(Account ac : trigger.new){
        count = a.size();
        ac.NumberofLocations__c = count;
        if(count > 2) ac.addError('reached limit today');
    }
}
```

### 7. 특정 사용자의 Account 삽입/수정/삭제 방지
```apex
trigger scenario30 on Account (before insert, before update, before delete) {
    user u = [SELECT id, name FROM user WHERE username = 'naveensfdc98@gmail.com'];
    if(u.id == userinfo.getUserId()){
        if(trigger.isdelete) for(Account a : trigger.old) a.addError('cant delete record');
        if(trigger.isupdate) for(Account b : trigger.new) b.addError('can not update');
        if(trigger.isinsert) for(Account c : trigger.new) c.addError('can not insert');
    }
}
```

### 8. 기존 레코드 중복 시 오류 메시지
```apex
trigger scenario8 on Contact (before insert) {
    for(Contact c : trigger.new){
        list<contact> a = [SELECT id, name, Email, lastname FROM contact WHERE Email = :c.Email];
        if(a.size() > 0) c.Email.addError('already existing');
    }
}
```
루프 안 쿼리 없는 버전(권장):
```apex
trigger duplicatetrigger on Inputout__c (before insert) {
    set<string> s = new set<string>();
    for(Inputout__c op : trigger.new) s.add(op.Doctor_Name__c);
    list<Inputout__c> d = [SELECT id, Doctor_Name__c FROM Inputout__c WHERE Doctor_Name__c = :s];
    set<string> dupids = new set<string>();
    for(Inputout__c don : d) dupids.add(don.Doctor_Name__c);
    for(Inputout__c c : trigger.new){
        if(c.Doctor_Name__c != null && dupids.contains(c.Doctor_Name__c))
            c.Doctor_Name__c.addError('already existing record');
    }
}
```

### 9. 관련 Contact 수 롤업
```apex
public class rollupsummery {
    public static void increment(list<contact> con){
        set<id> ids = new set<id>();
        for(Contact c : con) ids.add(c.accountid);
        list<account> a = [SELECT id, name, NumberOfEmployees, (SELECT id, lastname FROM contacts)
                           FROM account WHERE id = :ids];
        for(Account ac : a) ac.NumberOfEmployees = ac.contacts.size();
        update a;
    }
}
trigger scenario11 on Contact (after insert) { rollupsummery.increment(trigger.new); }
```

### 10. Opportunity StageName='Closed won'이면 Account Rating='hot'
```apex
trigger scenario12 on Opportunity (after insert, after update) {
    set<id> ids = new set<id>();
    for(Opportunity op : trigger.new) ids.add(op.AccountId);
    list<account> ac = [SELECT id, name, rating FROM account WHERE id = :ids];
    for(Opportunity op : trigger.new){
        if(op.StageName == 'Closed won'){
            for(Account a : ac) a.Rating = 'hot';
            update ac;
        }
    }
}
```

### 11. Account name이 'naveen'이면 모든 Contact lastname 업데이트
```apex
trigger scenario13 on Account (after update) {
    string names;
    for(Account a : trigger.new) names = a.name;
    list<contact> c = [SELECT id, lastname, firstname FROM contact WHERE lastname = :names];
    for(Contact con : c) con.lastname = names;
    update c;
}
```

### 12. Opportunity 생성/수정/삭제 시 Account 총 금액 계산
```apex
trigger scenario21 on Opportunity (after insert, after update, after delete) {
    set<id> ids = new set<id>();
    map<id,opportunity> opp = new map<id,opportunity>();
    Decimal oldVal, newVal;
    if(trigger.isinsert){
        for(Opportunity op : trigger.new){ ids.add(op.AccountId); opp.put(op.AccountId, op); }
        list<account> acc = [SELECT id, Total_Amount__c FROM account WHERE id = :ids];
        for(Account a : acc){
            a.Total_Amount__c = (a.Total_Amount__c == null)
                ? opp.get(a.Id).amount : a.Total_Amount__c + opp.get(a.Id).amount;
        }
        update acc;
    }
    if(trigger.isUpdate){
        for(Opportunity op : trigger.new){ ids.add(op.AccountId); opp.put(op.AccountId, op); newVal = op.Amount; }
        for(Opportunity ops : trigger.old) oldVal = ops.Amount;
        list<account> acc = [SELECT id, Total_Amount__c FROM account WHERE id = :ids];
        for(Account a : acc){
            a.Total_Amount__c = (a.Total_Amount__c == null)
                ? opp.get(a.Id).amount : a.Total_Amount__c + opp.get(a.Id).amount - oldVal;
        }
        update acc;
    }
}
```

### 13. Lead 생성 시 Account·Contact·Opportunity 자동 전환
```apex
trigger scenario19 on Lead (after insert) {
    list<account> acc = new list<account>();
    list<contact> con = new list<contact>();
    list<opportunity> op = new list<opportunity>();
    for(Lead l : trigger.new){
        acc.add(new Account(Name=l.lastname, Phone=l.Phone));
        con.add(new Contact(LastName=l.Name));
        op.add(new Opportunity(Amount=l.AnnualRevenue, CloseDate=system.today(), StageName='closed won'));
    }
    insert acc; insert con; insert op;
}
```

### 14. Contact 생성 시 Opportunity 필드 업데이트
```apex
trigger scenario17 on Contact (after insert) {
    list<opportunity> op = [SELECT id, name, stagename, Description, amount FROM opportunity LIMIT 50];
    for(Contact c : trigger.new){
        for(Opportunity o : op){
            if(o.amount < 5000 || o.Amount == null){
                o.amount = 5000; o.Name = o.Name+'Mr'; o.StageName = 'prospecting';
            } else {
                o.Amount = o.Amount+1000; o.Name = o.Name+'Dr';
            }
            update o;
        }
    }
}
```

### 15~20. Visualforce/이메일 예제
- **15. ActionPoller** — `<apex:actionPoller>`로 일정 간격마다 시간 갱신.
- **16. ActionStatus** — AJAX 요청 진행/완료 상태 표시.
- **17. Aggregate 함수** — `SUM/MIN/MAX(AnnualRevenue)`, `COUNT()`를 AggregateResult로 조회.
- **18. 이메일 발송** — `Messaging.SingleEmailMessage`로 To/CC/Subject/Body 설정 후 `Messaging.sendEmail`.
- **18b. PDF 첨부 이메일** — `page.getContentAsPDF()`를 `EmailFileAttachment`로 첨부.
- **19. 이메일 템플릿 발송** — `setTemplateId`, `setTargetObjectId`, `setWhatId`.
- **20. 이메일 트리거** — 체크박스 true 시 이메일 발송.
```apex
trigger sendingmailtrigger on Inputout__c (before insert) {
    for(Inputout__c i : trigger.new){
        if(i.Check_box__c == true){
            Messaging.SingleEmailMessage m1 = new Messaging.SingleEmailMessage();
            m1.setToAddresses(new string[]{'naveengorentla1@gmail.com'});
            m1.setSubject('accenture');
            m1.setPlainTextBody('this is interview call letter');
            Messaging.sendEmail(new Messaging.Email[]{m1});
        }
    }
}
```

### 21. Apex 공유(AccountShare/OpportunityShare) 필수 항목
사용자 상세, opportunity id, RowCause, AccessLevel, UserOrGroupId.

## 트리거 모범 사례
오브젝트당 트리거 하나, 로직 없는 트리거(핸들러 위임), 컨텍스트별 핸들러 메서드, 벌크화(200건), FOR 루프 안 SOQL/DML 회피(SOQL 100 한도), 컬렉션 활용, 대용량(50,000건)은 SOQL for 루프, @future 적절히, ID 하드코딩 금지, 일관된 명명 규칙(AccountTrigger).

## 동적 승인 프로세스
승인 요청을 레코드의 lookup 필드에 나열된 사용자에게 동적 라우팅.
```apex
Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
req1.setObjectId(a.id);          // 승인 제출 레코드 id
req1.setSubmitterId(user1.id);   // 제출 사용자 id
Approval.ProcessResult result = Approval.process(req1);
```

## 트리거 실행 순서
데이터 로드 → 시스템 검증 → before 트리거 → 커스텀 검증 → sObject 저장 → after 트리거 → 할당 규칙 → 자동 응답 규칙 → 워크플로우 규칙(필드 업데이트 시 before/after 트리거 재실행) → 에스컬레이션 → 롤업 요약 → 기준 기반 공유 → 레코드 커밋 → 이메일 액션.

**특정 사용자/프로필별 트리거 제어:** Custom Settings(계층형) 사용.

**트리거에서 자주 겪는 오류:** System.LimitException(SOQL 101), NullPointerException, 재귀 트리거, 필수 필드 누락.

## 테스트 클래스 모범 사례
- @isTest 어노테이션 필수(클래스 버전 25 이상), @testVisible·@testSetup 지원
- 단위 테스트는 인수 없음, 데이터 커밋·이메일 발송 안 함
- 배포에 75% 커버리지 필요(System.debug는 한도 미포함)
- 커버리지보다 모든 케이스(긍정/부정/벌크/단일) 검증에 집중
- Single Action(단일 레코드 검증), Bulk Action(1~200건), Positive(정상 동작), Negative(미래 날짜·음수 금지), Restricted User
- 테스트 메서드는 static·void, 클래스/메서드 기본 private
- 웹서비스 콜아웃은 Mock 사용, 이메일 발송 불가
- User/Profile/RecordType/ApexClass 등은 seeAllData 없이 접근 가능
- TestFactory 클래스(@isTest)로 조직 코드 크기 제외, @testSetup으로 공통 레코드 1회 생성
- Apex는 시스템 모드 실행이라 공유는 System.runAs로 강제(사용자/필드 권한은 미강제)

## 비교 정리

### Process Builder vs Workflow
| Process Builder | Workflow |
|---|---|
| 8개 액션 | 4개 액션 |
| 부모↔자식(Lookup·Master) 업데이트 | Master-Detail 자식→부모만 |
| Apex 메서드 호출 | 불가 |
| 레코드 생성 | Task만 생성 |
| 필드 업데이트·이메일·Chatter·Flow·승인 | 필드 업데이트·이메일·아웃바운드 메시지 |
| 아웃바운드 메시지 불가 | 가능 |

### Profile vs Role
Profile은 설정·권한 모음(오브젝트/필드/레코드 타입/페이지 레이아웃/로그인 제어), 필수. Role은 레코드 수준 보안·계층 구조, 비필수.

### Lookup vs Master-Detail
Lookup: 1:다, 오브젝트당 40개, 필수 아님, 부모 삭제 시 자식 유지, 롤업 불가, 기존 데이터에도 생성 가능. Master-Detail: 오브젝트당 2개, 필수, cascade delete, 부모에 롤업 가능. 상호 변환 가능.

### SOQL vs SOSL
| SOQL | SOSL |
|---|---|
| 트랜잭션당 100 쿼리 | 20 |
| 50,000건 반환 | 2,000건 |
| List<sObject> | List<List<sObject>> |
| SELECT | FIND |
| 단일/관련 오브젝트 | 다중 오브젝트 |

### Custom Setting vs Custom Object
Custom Setting은 앱 캐시 저장(SOQL 불필요), 데이터 타입 제한, 검증·트리거 불가. Custom Object는 DB 저장(SOQL 필요), 모든 타입, 검증·트리거 가능.

### Queueable vs Future
Queueable은 비기본 타입 지원·Job ID 있음. Future는 기본 타입만·Job ID 없음.

## 어노테이션
@isTest, @future, @deprecated(관리 패키지에서 더 이상 참조 불가 요소 표시), @ReadOnly(무제한 쿼리), @RemoteAction(JS remoting), @AuraEnabled(Lightning 접근), @testSetup(공통 테스트 레코드). Apex REST: @RestResource, @HttpDelete/Get/Patch/Post/Put.

## 비동기 Apex

### Batch Apex
대량 데이터를 배치로 나눠 처리, 거버너 한도 극복, 5천만 건 지원. 메서드 3개: start, execute, finish. 기본 배치 크기 200(최소 1, 최대 2000).
```apex
global class classname implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('Query');
    }
    global void execute(Database.BatchableContext bc, List<sObject> scope){ /* 로직 */ }
    global void finish(Database.BatchableContext bc){ /* 후처리 */ }
}
```
- Batch에서 Batch 호출: finish 메서드에서 가능.
- 콜아웃: `Database.AllowsCallouts` 구현 시 최대 10개.
- Iterable: start 반환 타입으로 커스텀 로직, 50,000건.
- Database.Stateful: execute 간 상태 유지 시.

### Schedule Apex
```apex
public class scheduleapex implements Schedulable {
    public void execute(Database.SchedulableContext sc){ /* 로직 */ }
}
```
Cron Trigger: 스케줄된 작업이 먼저 등록되는 곳. 상태 추적은 CronTrigger SOQL. 중지: `System.abortJob(jobId)`. Cron 표현식: 초 분 시 일 월 요일 연도.

### Queueable Apex
```apex
public class quableclass implements Queueable {
    public void execute(QueueableContext context){ /* 로직 */ }
}
ID jobID = System.enqueueJob(new AsyncExecutionExample());
```

## 기타 개념

**Wrapper 클래스:** 다른 객체들의 컬렉션을 인스턴스로 갖는 클래스.

**Custom Label:** 커스텀 텍스트 값, 다국어 지원. Apex `System.Label.labelName`, VF `{!$Label.labelName}`.

**리포트(4종):** Tabular(소계 없는 목록), Summary(행 그룹화·요약), Matrix(행·열 그룹화), Joined(여러 리포트 타입, 최대 5블록). 표준/커스텀 리포트는 한 폴더에 함께 저장 불가. Running user(실행자) vs Viewing user(조회자). 내보내기: .csv/xls, 최대 50,000건.

**Sales Cloud vs Service Cloud:** Sales는 영업·마케팅(Lead, Account, Contact, Opportunity, Quote). Service는 고객 지원(Case, Solution, Knowledge, Web-to-Case). Service Cloud는 Sales Cloud의 상위 집합.

**환경:** Developer, Testing, Production. **샌드박스(4종):** Developer(200MB, 메타데이터, 일일), Developer Pro(1GB, 일일), Partial Copy(5GB, 5일, 테이블당 1만 건), Full(프로덕션 크기, 29일, 전체 데이터).

**Document vs Static Resource:** Document는 이미지·파일 업로드(로고 20KB 이하). Static Resource는 VF에서 참조할 콘텐츠(zip/jar/이미지/CSS/JS). `<apex:image url="{!$Resource.TestImage}"/>`.

**Setup Audit Trail:** 최근 설정 변경 추적. **System Log/Developer Console:** 실시간 요청·익명 Apex 실행. **Debug Log:** DB 작업·시스템 프로세스·오류 기록.

**DML:** insert/update/delete/upsert/undelete/merge. Atomic(하나 실패 시 전체 실패) vs Non-atomic(부분 실패 허용, `Database.insert(list, false)`). 휴지통 비우기: `Database.emptyRecycleBin`. 151 예외 회피: 벌크화. Lead 전환: `Database.convertLead()`.

**Data Loader vs Import Wizard:** Data Loader는 ETL(가져오기·내보내기), 모든 오브젝트, 500만 건, 중복 허용, 삭제 가능. Import Wizard는 가져오기만, Account/Contact/Lead/Solution, 5만 건, 중복 불가.

**External ID:** 가져오기 시 중복 방지용 외부 시스템 고유 식별 필드(Number/Text/Email). Upsert 시 일치하면 업데이트, 없으면 생성, 여러 개 일치하면 오류.

**Package:** 컴포넌트 묶음. Unmanaged(오픈소스, 설치 후 편집 가능, 업그레이드 불가), Managed(판매·라이선스, 완전 업그레이드 가능, 파괴적 변경 제한).

**배포(ANT):** build.properties(자격 증명), build.xml(명령/타겟), package.xml(컴포넌트 매니페스트). Eclipse: Force.com 우클릭 배포. Jira: 프로젝트/티켓 추적.

**예외 유형(try-catch 외):** AsyncException, CalloutException, DmlException, NullPointerException, XmlException, SecurityException, TypeException, StringException, SObjectException, SearchException.

**Salesforce:** 클라우드 컴퓨팅 SaaS 제공자. 장점: 비용 절감, 스토리지 증가, 유연성, 어디서나 접근, 낮은 유지보수, 멀티테넌트. SaaS/PaaS/IaaS 구분.

**Freeze vs Deactivate:** Freeze는 로그인 불가하나 라이선스 유지. Deactivate는 라이선스 조직 반환.

**OWD:** Private, Public Read Only, Public Read/Write, Public Read/Write/Transfer, Public Full Access, Controlled by Parent. Grant Access using hierarchy로 상위 계층 접근.

**Queue vs Public Group:** Queue는 레코드 소유자로 사용자 그룹 할당.

**Approval Process:** 자동화 프로세스. Parallel(단일 단계 다중 사용자): First Response(첫 응답이 최종), Unanimous(전원 승인 필요).

**ISBLANK vs ISNULL:** ISBLANK는 빈 값(텍스트/숫자) true, ISNULL은 null(숫자) true.

**Field Dependency:** 한 필드 값이 다른 필드 값 제어. 종속 필드는 선택 목록/다중 선택 목록.

**접근 제어자:** private(클래스 내), public(앱 내), global(클래스 접근 가능 어디서나), protected(확장 내부 클래스).

**컨트롤러(3종):** Standard(표준·커스텀), Custom(전체 로직 구현), Extension(기존 컨트롤러 기능 추가).

**render/renderAs/reRender:** render(컴포넌트 표시·숨김), renderAs(PDF 변환), reRender(부분 새로고침). contentType으로 Word/Excel 변환.

**이메일 서비스:** Outbound(SF→외부), Inbound(외부→SF). Single Email Message(단일, 최대 100), Mass Email Message(다중, 최대 250). Inbound: Messaging.InboundEmailHandler 인터페이스 구현.

**Analytic Snapshot:** 과거 데이터 리포트. Source Report(Tabular/Summary) + Custom Object + Snapshot 정의.

## 빠른 Q&A
- 다중 extension에서 동명 메서드: 왼쪽(컨트롤러)에 정의된 것 호출.
- JS에서 컨트롤러 메서드 호출: actionFunction.
- SOQL 정렬: ORDER BY.
- 현재 로그인 사용자 id: `UserInfo.getUserId()`.
- CSV blob → string: `.toString()`.
- VF 컴포넌트에서 DML: `allowDML=true` 선언 필요.
- Map의 모든 키: `keySet()`.
