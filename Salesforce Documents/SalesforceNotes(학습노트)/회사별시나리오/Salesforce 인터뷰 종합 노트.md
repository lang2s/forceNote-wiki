---
tags: [scenario, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Interview Notes]
---

# Salesforce 인터뷰 종합 노트

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

> Salesforce 전 영역을 망라하는 종합 학습 노트입니다.

## 기본 개념
**Force.com IDE:** Apex·Visualforce·메타데이터 개발 통합 환경(마법사·코드 에디터·테스트·배포·디버거).
**Sales Cloud:** 영업·마케팅·Lead 생성·고객 지원 CRM(B2B/B2C). 완전 커스터마이즈, SaaS(브라우저·모바일).
**Org Id:** 샌드박스 새로고침 시마다 변경.

## 관계

**Lookup:** 두 오브젝트 연결, 오브젝트당 25개, 부모 비필수, 보안·삭제 영향 없음, 다층 가능.
**Master-Detail:** 부모-자식, 마스터 필수, 부모 삭제 시 자식 삭제. 롤업 요약(SUM·MAX·MIN·COUNT, AVG 불가) 마스터에만, 오브젝트당 2개. 부모 접근이 자식 접근 결정.
- SUM: Number·Currency·Percent. MIN/MAX: + Date·Date/Time.
**Many-to-Many:** Junction 오브젝트(Master-Detail 2개)로 구현.
**Controlled by Parent:** 자식 OWD가 부모 접근 복사.

| Lookup | Master-Detail |
|---|---|
| 25개 | 2개 |
| Self-Lookup 가능 | Self-Lookup 불가 |
| 보안·삭제 영향 없음 | 자식 삭제 |
| 부모 비필수 | 부모 필수 |
| 다층 | 무층 |

**관계 시나리오:**
- 마스터 업데이트 시 워크플로우로 자식 필드 업데이트? **불가**.
- 자식 업데이트 시 워크플로우로 부모 필드 업데이트? **가능**(Master-Detail).
- 부모 삭제 시 자식 삭제(Master-Detail), Lookup은 영향 없음.
- 기존 레코드 있는 오브젝트에 Master-Detail 직접 생성 불가(Lookup→값 채움→변환).
- Junction 200개 초과 시 부모 삭제 불가(수동 삭제 후).
- 마스터-디테일에 롤업 요약 없으면 Lookup으로 변환 가능.
- 오브젝트가 Lookup·Master-Detail 둘 다 가질 수 있음.

**External Object:** 외부 데이터 매핑. Lookup·External Lookup·Indirect Lookup만(Cascade-delete·Lookup 필터 없음).

## Insert vs Database.Insert
| Insert | Database.Insert |
|---|---|
| 부분 삽입 불가 | 부분 삽입 가능 |
| 롤백 불가 | 롤백 가능 |
| 오류 시 전체 중단 | allOrNone(기본 true) 옵션 |

## 수식 필드
**Custom Formula vs Cross-Object Formula:** Cross-Object는 관련 오브젝트 참조(최대 15 관계 거리, 보안·공유 우회, 롤업 요약에 참조 불가).

## De-Activation vs Freezing
De-Activation은 라이선스 조직 반환(커스텀 계층 필드면 freeze 후), 비활성 사용자가 running user면 리포트 미실행. Freezing은 라이선스 유지, 리포트 실행.

## Workflow vs Process Builder
Workflow 액션 4개(Task·필드 업데이트·이메일·아웃바운드). Process Builder 9개(+레코드 생성·관련 레코드 업데이트·Quick Action·Flow·Chatter·승인·Apex·다른 프로세스 호출, 아웃바운드 제외). Process Builder는 순서 제어·다중 if-then·비주얼 디자이너. **모범 사례: 한 오브젝트에 Workflow와 Process Builder 동시 사용 금지.**

## Workflow vs Approval Process
Workflow는 단일 단계·액션·자동 발동. Approval은 다단계·승인자 액션 필요(최대 15단계, 단계당 25명).

## Workflow vs Trigger
Workflow는 평가·규칙 기준 자동 액션, DML·SOQL 불가, 오브젝트 간 접근. Trigger는 코드(insert/update 전후), 트랜잭션당 DML 150·SOQL 100.

## Role vs Profile
Profile은 수행 작업(오브젝트·필드 보안·시스템 권한, 필수). Role은 가시성(레코드 수준, 계층, 비필수). 사용자당 프로필 1개·역할 1개.

## Profile vs Permission Set
Profile은 사용자당 1개·필수·제한적. Permission Set은 다중·비필수·추가(additive)만·페이지 레이아웃 제어 안 함.

## SOQL vs SOSL
| SOQL | SOSL |
|---|---|
| 한 오브젝트·관련 | 다중 오브젝트 |
| 모든 데이터 타입 | Text·Phone·Email만 |
| 클래스·트리거 | 클래스만(트리거 불가) |
| DML 가능 | DML 불가 |

`List<List<SObject>> r = [FIND 'SFDC' IN ALL FIELDS RETURNING Account(Name), Contact(FirstName,LastName)];`

## 관계 쿼리
- 부모→자식: `SELECT name, (SELECT name FROM courses__r) FROM Branch__c` (자식은 복수형 __r)
- 자식→부모: `SELECT Lastname, Account.name FROM Contact` (최대 5 관계)
- `SELECT id, name, (SELECT id, name FROM user WHERE Profile.Name='SysManager') FROM Account`

## Database 쿼리 비교
| Database.Query() | Database.QueryLocator() | getQueryLocator() |
|---|---|---|
| 5만 건 | 5천만 건 | 5천만 건 |
| 동적 쿼리 | 단순 SOQL 반복 | Batch start 반환 타입 |

## Custom Setting vs Custom Metadata
Custom Setting: 앱 캐시·SOQL 불필요·List/Hierarchy·관계 없음·CUD 가능·테스트에 SeeAllData 필요·마이그레이션 시 데이터 별도. Custom Metadata: 무제한 SOQL·배포 시 데이터 포함·관계·검증 규칙·페이지 레이아웃·CUD 불가·SeeAllData 불필요.

## Wrapper 클래스
사용자 정의 데이터 타입. 메서드 없이 데이터 멤버 모음.

## Junction Object
Master-Detail 2개로 다대다. Primary Master(색상·아이콘·소유권 상속). Junction은 다른 오브젝트의 부모 불가.

## Import Wizard vs Data Loader
Import Wizard: 웹 기반·5만 건·중복 불가·Master-Detail 자식 안 보임. Data Loader: Insert/Update/Upsert/Delete/Hard Delete/Export/Export All, 배치 최소 1·최대 2000·기본 200(Bulk API 활성 시 2000).

**필수 필드 누락 import:** 페이지 레이아웃 필수만이면 전체 성공, 필드 수준 필수면 해당 레코드 제외.

## External ID
외부 시스템 고유 식별 필드(Text·Number·Auto-Number·Email). upsert 시 일치하면 업데이트, 없으면 삽입. 오브젝트당 Unique+External ID ≤ 7개.

## FOR UPDATE
레코드 잠금. `[SELECT id FROM Campaign LIMIT 1 FOR UPDATE]`.

## MVC
Model-View-Controller. Visualforce가 MVC 인터페이스 제공.

## Approval Process
승인 단계·승인자·액션 자동화. 액션 4개(Task·Field Update·Email·Outbound). 최대 15단계, 단계당 25명. Assigned/Delegated Approver. Email Approval Response(YES 응답). Process Instance/Node.
**Parallel Approval Routing:** 단일 단계 다중 승인자. **Dynamic Approval:** lookup 필드에 승인자 동적 할당(승인 매트릭스 + Apex).

## Account Team
Account 관련 사용자 정보 저장. 기본은 소유자 정보. Account-Contact는 Lookup이나 CascadeDelete=true(부모 삭제 시 Contact 삭제).

## Validation Rule
저장 전 데이터 검증(True 반환 시 오류). 한 번에 전체 실행. import 시 비활성화. 
**건너뛰는 경우:** Lead 전환 활동, 캠페인 계층, Mass Transfer, 워크플로우·프로세스 필드 업데이트.
**모범 사례:** 프로덕션 직접 생성 금지, 좁게 적용, 사용자 알림, ID 하드코딩 금지, 테스트.

수식 예: 캐나다 우편번호 REGEX, VLOOKUP으로 ZipCode 검증, 평일 검증 `CASE(MOD(My_Date__c - DATE(1900,1,7),7), 0,0, 6,0, 1)=0`, `Begin_Date__c > End_Date__c` 등.

## Cross-Object Formula
Master-Detail/Lookup, 최대 15 관계 거리, 보안·공유 우회, 롤업 요약에 참조 불가.

## 실행 순서
데이터 조회 → 시스템 검증(편집 페이지 미실행) → before 트리거 → 검증 규칙(커스텀+표준) → 중복 규칙 → 저장(미커밋) → after 트리거 → 할당 규칙 → 자동 응답 → 워크플로우(필드 업데이트 시 before/after update·시스템 검증 재실행) → 프로세스·Flow → 에스컬레이션 → 엔타이틀먼트 → 교차 오브젝트 수식 → 롤업 요약 → 기준 기반 공유 → 커밋 → 커밋 후 로직(이메일).

## 동기 vs 비동기
동기(트리거·컨트롤러)는 단일 스레드 순차. 비동기(Batch·@future·Queueable·Schedule·콜아웃·Bulk DML·Mixed DML)는 별도 스레드 백그라운드.

## Future 메서드
독립적 장기 작업. 규칙: @future·static·void·기본 타입만·Queue 추가 후 실행·콜아웃은 @future(callout=true)·AsyncApexJob 등록. 호출: `FutureClass.method()`(객체 없이).
**단점:** sObject 전달 금지(실행 시점 변경 위험), Job Id 미반환, Future에서 Future 호출 불가.

## Mixed DML 예외
한 트랜잭션에서 Setup·Non-Setup 오브젝트 DML 혼합 시. Setup 오브젝트(Group·GroupMember·User·PermissionSet·Territory 등)는 다른 사용자 권한에 영향. 해결: 하나를 @future로 분리.
```apex
public class Mix_DML {
    public void callMe(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Manager'];
        UserRole r = [SELECT Id FROM UserRole WHERE Name='COO'];
        User u = new User(alias='head', email='ani@gmail.com', emailencodingkey='UTF-8',
            lastname='mixed', languagelocalekey='en_US', localesidkey='en_US',
            profileid=p.Id, userroleid=r.Id, timezonesidkey='America/Los_Angeles', username='mixed@312.com');
        insert u;
        create();
    }
    @future
    public static void create(){
        insert new Account(Name='DML Testing', Phone='01001');
    }
}
```

## Queueable
QueueableContext.getJobId()로 작업 추적. 장기 작업·외부 콜아웃·벌크 DML 비동기. Queueable 인터페이스·execute 메서드. System.enqueueJob()이 Job Id 반환. 체이닝(Queueable→Queueable, Queueable→Future 가능). Future 대비: 비기본 타입 가능·Job Id 반환·체이닝.
```apex
public class Queue_Example implements Queueable {
    public void execute(QueueableContext qc){
        List<Account> accounts = [SELECT Id, rating FROM Account WHERE CreatedDate=LAST_WEEK];
        for(Account a : accounts) a.Rating='Hot';
        update accounts;
        System.enqueueJob(new Queue_Example_2());  // 체이닝
    }
}
```

## 거버너 한도
| 항목 | 동기 | 비동기 |
|---|---|---|
| SOQL | 100 | 200 |
| SOQL 반환 | 50,000 | 50,000 |
| getQueryLocator | 10,000 | 10,000 |
| SOSL | 20 | 20 |
| 단일 SOSL 반환 | 2,000 | 2,000 |
| DML | 150 | 150 |
| DML 레코드 | 10,000 | 10,000 |
| 재귀 스택 | 16 | 16 |
| 콜아웃 | 100 | 100 |
| 콜아웃 타임아웃 | 120초 | 120초 |
| Future | 50 | batch·future 0, queueable 1 |
| enqueueJob | 50 | 1 |
| sendEmail | 10 | 10 |
| 힙 | 6MB | 12MB |
| CPU 시간 | 10,000ms | 60,000ms |
| Apex 트랜잭션 최대 실행 | 10분 | |

비동기 Apex 실행: 24시간당 250,000 또는 사용자 라이선스 ×200.

## Batch Apex
데이터 조회→배치 분할→병렬 실행→종료. Database.Batchable 구현, start·execute·finish.
- **start:** 데이터 수집(QueryLocator는 5천만 우회, Iterable은 한도 적용·복잡 범위).
- **execute:** 배치별 비즈니스 로직(기본 200, scope).
- **finish:** 확인 이메일·후처리.
**한도:** 동시 5개, Flex Queue 100개, 한 배치 실패 시 해당만 실패, finish 실패 시 execute 변경 커밋, Future 호출 불가, finish에서 Batch 호출 가능, 콜아웃은 Database.AllowsCallouts.
**Database.Stateful:** execute 간 비static 데이터 상태 유지(카운팅).
```apex
global class Batch_Example_4 implements Database.Batchable<sobject>, Database.Stateful {
    global Integer count=0;
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('SELECT id,name FROM Account');
    }
    global void execute(Database.BatchableContext bc, List<Account> scope){
        for(Account a : scope) count++;
    }
    global void finish(Database.BatchableContext bc){
        insert new Account(Name='State Example', Description='Count :'+count);
    }
}
// Database.executeBatch(new Batch_Example_4(), 100);
```

## Schedule Apex
지정 시간 실행. Schedulable 인터페이스·execute(SchedulableContext). System.schedule(name, cron, instance).

## 리포트·대시보드
**폴더:** Standard, My Personal Custom, Custom(공유), Public.
**Bucketing 필드:** 수식 없이 레코드 분류.
**리포트 유형:** Tabular(테이블), Summary(행 그룹화 최대 3), Matrix(행·열), Joined(2개+). Joined는 직접 export 불가(printable view→xls).
**Report Type:** Standard, Custom.
**대시보드:** Summary·Matrix 리포트 소스, Running User가 접근 결정, 스케줄·이메일 가능, 최대 20개 리포트. 컴포넌트: Chart·Table·Metric·Gauge.

## Record Type
오브젝트의 선택 목록·페이지 레이아웃 제한. 레코드 타입으로만 다중 페이지 레이아웃 할당. 프로필별 다른 레이아웃 가능.

## Page Layout
레코드 페이지 레이아웃(버튼·필드·관련 목록·VF). 필드 가시성·읽기 전용·필수 결정.

## 보안 (4계층)
**1. 조직:** 인증 사용자·비밀번호 정책·로그인 실패 한도·시간·위치(Org은 OTP, Profile은 차단)·이메일 도메인. Health Check.
**2. 오브젝트:** Profile(직무), Permission Set(추가).
**3. 필드:** 프로필 FLS·Permission Set·Field Accessibility. (Universally required는 FLS 무관, 롤업·수식은 읽기 전용·항상 계산.) 페이지 레이아웃은 상세·편집만, FLS는 List View·검색·관련 목록·VF·리포트 등 모든 곳.
**4. 레코드:** OWD → Role Hierarchy → Sharing Rule → Manual Sharing.

### OWD
Private(소유자·상위), Public Read Only, Public Read/Write(소유자만 삭제), Public Read/Write/Transfer(Case·Lead), Public Full Access(Campaign), Controlled by Parent.

### Sharing Rules
공개 그룹·역할·영역 접근 확장(OWD보다 엄격 불가). 오브젝트당 300개(criteria 50개). Owner-Based, Criteria-Based.

### Manual Sharing
수동 공유. 소유자·상위 역할·Full 접근·관리자. OWD Private/Read Only일 때만.

### Apex Sharing
특정 사용자에게 프로그래밍 공유.

## Groups & Queues
**Public Groups:** 관리자 생성. **Collaborative Groups:** 개인. **Queues:** Lead·Case·Order·커스텀 관리, 멤버가 소유권 가져갈 때까지 보관.

## Platform Events
앱 내·외부 알림(이벤트 기반). 발행(프로세스·Flow·Apex·외부 앱), 구독(프로세스·Flow·트리거·CometD). __e 접미사. Apex 코드 트리거·외부 시스템 통신.

## Apex 모범 사례
오브젝트당 트리거 하나, 로직 없는 트리거(핸들러), 컬렉션 활용, FOR 루프 안 SOQL/DML 회피, Batch로 한도 회피, ID 하드코딩 금지.

## 트리거
insert/update/delete/undelete 전후 코드.
- Trigger.new: 새 버전 목록(insert·update·undelete). before insert에서만 수정.
- INSERT Before: trigger.new에 삽입 시도 레코드. INSERT After: 저장된 레코드(읽기 전용).
- **트리거 안 Batch 불가.**

**필드 필수화(트리거):**
```apex
trigger AccountTrigger on Account (before insert, before update) {
    for(Account a : Trigger.new) if(a.Phone == null) a.addError('Phone required');
}
```

**Account의 Contact 수 카운트 트리거** — 자식 수 집계 후 부모 업데이트.

**재귀 방지:**
```apex
public class ContactTriggerHandler { public static Boolean isFirstTime = true; }
trigger ContactTriggers on Contact (after update) {
    if(ContactTriggerHandler.isFirstTime) {
        ContactTriggerHandler.isFirstTime = false;
        // 로직
    }
}
```

## Visualforce render/rerender/renderAs
render(표시·숨김), rerender(부분 갱신), renderAs(PDF·Excel·doc). `apexpages.Message(Severity.ERROR, ...)` — Confirm/Warning/Success.

## CPU 시간 한도
동기 10초, 비동기 60초. 계산: 모든 Apex 코드·라이브러리 함수. 미계산: SOQL·SOSL·콜아웃 대기.

## 일반 오류
- SOQL 101: 루프 안 쿼리 → 루프 밖으로.
- DML 151: 루프 안 DML → 컬렉션.
- Query rows 50001 → LIMIT·Batch.
- AsyncApexExecutions Limit → 비동기 24시간 250,000.

## JSON
JavaScript Object Notation. 텍스트 형식, 객체는 `{}`. 클래스: JSON, JSONParser, JSONGenerator, JSONToken.
```apex
String s = JSON.serialize(acc);
Account a = (Account) JSON.deserialize(jsonStr, Account.class);
```

## REST/SOAP 통합
**REST API:** 경량·JSON/XML·HTTP. 커스텀: @RestResource(urlMapping), @HttpGet/Post/Patch/Put/Delete. 소비자가 JSON 전송→역직렬화. JSONGenerator/JSONParser로 본문 생성·파싱.
**SOAP:** XML 인코딩 데이터 전달 프로토콜.
**통합 인증:** Authorization Code, Client Credentials(FaceBook), Connected App, Named Credential. 서드파티(Box·FaceBook) 동적 통합.

## Aura
**Aura?** Salesforce 오픈소스 UI 프레임워크(동적 웹 앱). Lightning 컴포넌트는 Aura의 부분집합. aura: 네임스페이스.
**@AuraEnabled:** Apex 컨트롤러 메서드를 Aura/LWC에 노출(static·인스턴스 메서드·속성).
**번들:** Component·Controller·Helper·Style·Documentation·Renderer·Design·SVG.
**배포:** Change Set·메타데이터 API. AuraDefinitionBundle.

## Sandbox
| 유형 | 스토리지 | 새로고침 |
|---|---|---|
| Developer | 10MB(200MB) | 일일 |
| Developer Pro | 1GB | 일일 |
| Partial Copy | 5GB | 5일 |
| Full Copy | 프로덕션 크기 | 29일 |

## 테스트 클래스 모범 사례
@isTest, 긍정·부정 assert, @testSetup, startTest/stopTest, System.runAs, seeAllData=true 회피, ID 하드코딩 금지, 200건, 75%+, @TestVisible, 콜아웃은 Mock, static·void, 이메일 불가, 24시간 500회 한도.

## 배포·기타
- 배포: Change Sets·Packages·ANT·VSCode.
- 검증만(저장 없이) 배포 가능.
- 테스트 클래스는 커버리지에 미포함.
- 관리 패키지 컴포넌트는 샌드박스→프로덕션 시 재설치 필요할 수 있음.
- 검증 규칙 배포 시 무시: Custom Setting 플래그를 FALSE로 배포 후 재활성화.
