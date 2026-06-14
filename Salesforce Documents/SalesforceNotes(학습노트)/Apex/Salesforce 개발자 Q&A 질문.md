---
tags: [apex, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Interview+Questions Salesforce Developer]
---

# Salesforce 개발자 Q&A 질문

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

> 175개 이상의 Q&A 모음입니다. (중복 항목은 통합 정리)

## Apex / Visualforce

**Apex란?** Java와 유사한 객체 지향 개념의 salesforce.com 기술로 커스텀 로직 작성.

**S-Control?** JavaScript 기반. 2007년 deprecated, Visualforce로 대체.

**Visualforce 페이지?** Salesforce의 마크업 언어. HTML 사용 가능, 모든 태그가 "apex" 네임스페이스로 시작. 디자인은 마크업, 비즈니스 로직은 컨트롤러.

**Visualforce가 S-Control처럼 병합 필드를 지원하나?** 네. `{!$User.FirstName}`, `{!Account.Name}`.

**Visualforce 코드 작성 위치?** Setup > Develop > Pages, Development Mode 체크 후 페이지 하단 에디터, Eclipse IDE.

**거버너 한도?** 공유 멀티테넌트 환경에서 코드가 리소스를 독점하지 못하게 Apex 런타임 엔진이 적용하는 런타임 한도(메모리·DB·스크립트 문·레코드 수). 초과 시 런타임 예외. (SOQL 100, 레코드 50,000, SOSL 20, 단일 SOSL 200, DML 150 — 비동기는 SOQL 200.)

## 샌드박스 / 배포

**샌드박스 유형?** Configuration Only(보고서·대시보드·커스터마이징 복사, 레코드 제외, 최대 500MB, 하루 1회 새로 고침), Developer(코딩·테스트, 최대 10MB, 하루 1회), Full(전체 데이터 복사).

**데이터 백업 예약?** Setup > Data Management > Data Export > Schedule Export. 주간/월간 자동 생성. 알림 후 48시간 내 다운로드.

**배포 방법?** Change Sets, Force.com IDE(Eclipse), Force.com Migration Toolkit.

## 함수/관계/검증

**ISNULL vs ISBLANK?** 둘 다 값이 없으면 TRUE. ISBLANK는 숫자·텍스트, ISNULL은 숫자만.

**Workflow vs Approval Process?** Workflow(저장 시 트리거, 단일 기준·액션, 수정·삭제 가능), Approval Process(Submit 클릭 시 트리거, 여러 단계, 일부 속성 수정 불가·삭제 전 비활성화 필요).

**시간 종속 액션을 추가할 수 없는 경우?** "생성되고 편집될 때마다" 평가 기준 선택 시.

**이메일 템플릿 유형?** Text, HTML with Letterhead, Custom HTML, Visualforce.

**Roll-up Summary?** 관련 목록의 합계·최소·최대·레코드 수를 표시하는 읽기 전용 필드. Master 오브젝트에만 생성.

**Record Type?** 프로필에 따라 다른 선택 목록 값·페이지 레이아웃 표시. 기본 설정은 프로필의 Record Type Settings에서.

**Account 삭제 시?** 관련 Contact, Opportunity도 삭제.

**관계 유형?** Master-Detail, Many-to-Many, Lookup, Hierarchical(User 오브젝트만).

**Hierarchical 관계?** User 오브젝트 전용 특수 lookup. Manager 필드로 다른 사용자 연결(self relationship처럼).

**Many-to-Many 생성?** auto number를 가진 커스텀 오브젝트(Junction Object)에 두 Master-Detail 관계 생성.

**Junction object?** 두 Master-Detail 관계를 가진 커스텀 오브젝트. 다대다 모델링.

**Junction A에 Master B, C가 있고 C 레코드 삭제 시?** 자식도 삭제(Master-Detail 속성).

## 트리거

**트리거·자동화 실행 순서?** 원본 로드 → 새 값 덮어쓰기 → 시스템 검증 → before 트리거 → 커스텀 검증 → DB 저장(미커밋) → after 트리거 → 할당 규칙 → 자동 응답 → 워크플로우 → 에스컬레이션 → 부모 롤업 요약 → 커밋.

**한 오브젝트에 before insert 트리거 2개의 실행 순서 제어?** 사전 정의 불가. 오브젝트당 트리거 하나 권장.

**Trigger.new vs Trigger.old?** new(삽입할 레코드, insert·update에서, before에서만 수정), old(DB의 기존 레코드, update·delete에서).

**트리거를 한 번만 발동시키려면?** static boolean 변수.

**WhoId vs WhatId?** WhoID(Lead/Contact), WhatID(Account/Opportunity).

**재귀 트리거?** 같은 오브젝트에 같은 DML이 발동 조건과 같을 때. static 변수로 방지.

**트리거 컨텍스트 변수?** new, old, NewMap, OldMap, isInsert, isUpdate, isDelete, isBefore, isAfter, isUndelete, isExecuting, size.

**트리거 이벤트?** before/after insert·update·delete, after undelete.

**트리거에서 콜아웃?** @future 비동기 메서드로 가능.

**트리거에서 Batch 호출?** `Database.executeBatch(new BatchClass());`

## Visualforce / 컨트롤러

**VF 오류 메시지 표시?** `ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '...'))` + `<apex:pageMessages>`.

**Property?** `public String name {get; set;}` — Java getter/setter를 C# 스타일로 간결화, 코드 라인 절약.

**Controller Extension?** Custom/Standard Controller를 단일 인자로 받는 public 생성자를 가진 Apex 클래스. 기존 컨트롤러 기능 확장.

**URL 파라미터 읽기?** `Apexpages.currentPage().getParameters().get('Test');`

**컨트롤러 유형?** Standard Controller, Custom Controller, Controller Extensions.

**VF 페이지당 컨트롤러 수?** 하나의 컨트롤러 + 여러 확장(둘 다 getFoo()면 첫 확장 실행).

**System.runAs()?** 테스트 메서드에서 사용자 컨텍스트 변경, 해당 사용자 공유 적용.

**Test.setPage()?** 현재 페이지로 컨텍스트 설정(VF 컨트롤러 테스트).

**Custom Controller가 필요한 이유?** 공유 설정을 적용하지 않으려면(without sharing), 표준 오브젝트가 필요 없거나 여러 개 필요할 때.

**render vs rerender vs renderAs?** render(표시/숨김), rerender(부분 새로 고침), renderAs(PDF/doc/excel 변환).

**actionFunction?** JavaScript에서 AJAX로 컨트롤러 액션 호출(form 자식). actionSupport(이벤트 시 AJAX), actionPoller(타이머 AJAX), actionStatus(진행/완료 표시).

**VF의 renderAs PDF 최대 크기?** 15MB 미만.

**PageBlockTable vs DataTable?** PageBlockTable(pageBlock 내, 표준 Salesforce 룩앤필), DataTable(독립, 다른 룩앤필).

## 컬렉션 / DML

**insert vs Database.insert?** insert는 오류 시 전체 중단, Database.insert는 부분 성공 허용(rollback·할당 규칙 등 유연).

**자식이 두 master를 갖고 하나 삭제 시?** 자식 삭제.

**double을 소수점 2자리로?** `d.setScale(2)`.

**컬렉션?** List, Set, Map. Set(순서 없음·중복 불가), Map(키-값, 키는 primitive, 값은 모든 타입). Map에 List 가능: `Map<Id, List<Opportunity>>`.

**Custom Settings 접근(SOQL/SOSL 외)?** `getInstance('INDIA')`, `getAll()`.

## 보안 / 프로필

**Modify All Data vs Modify All?** Modify All Data(공유와 무관하게 모든 조직 데이터 생성·편집·삭제), Modify All(선택 오브젝트의 모든 권한).

**레코드 수준 접근?** Manual Sharing. **오브젝트 수준 접근?** Profile.

**Grant Access Using Hierarchies를 표준 오브젝트에서 변경?** 불가(커스텀 오브젝트만 가능).

**User 생성 시 필수?** Profile.

**with sharing 미작성 시 system 모드인데 왜 without sharing이 있나?** classA(with sharing)가 classB 호출 시 classB가 기본 with sharing 적용됨. 이를 피하려면 명시적 without sharing.

**읽기만 가능한 사용자가 레코드 소유자 변경?** 네, 프로필의 "Transfer Record" 설정.

**External ID vs Unique ID?** External ID(외부 시스템 ID 참조, sidebar 검색 가능, upsert 사용, Text/Number/Email/Auto-Number), Unique ID(같은 값 중복 방지). External ID는 중복 불가. Upsert: 매칭 없으면 생성, 한 번 매칭이면 업데이트, 여러 매칭이면 오류.

**Profile vs Role?** Profile(레코드 접근 권한·기능, 필수, 사용자당 1개), Role(데이터 가시성).

**프로필 없이 사용자 생성?** 불가. **역할 없이?** 가능.

**Profile이 제어하는 것?** Tabs, Custom Apps, Page Layouts, Record Types, 필드 수준 보안, 로그인 시간·IP, 관리·일반·오브젝트 권한.

**표준 프로필?** System Administrator, Standard User, Solution Manager, Marketing User, Contract Manager, Read Only.

## 리포트 / 대시보드

**리포트 유형?** Tabular(소계 없음), Summary(그룹·소계), Matrix(행·열 합계), Joined(여러 리포트 타입). 대시보드 컴포넌트는 Summary·Matrix만.

**Analytic Snapshot?** 사전 정의된 간격으로 데이터를 캡처해 커스텀 오브젝트에 저장. Tabular·Summary만 지원(Matrix 불가).

**COUNT() vs COUNT(fieldName)?** COUNT()는 SELECT의 유일 요소, ORDER BY·GROUP BY 불가. COUNT(fieldName)은 ORDER BY·GROUP BY 가능.

**GROUP BY와 WHERE?** WHERE 대신 HAVING. `... GROUP BY Name HAVING COUNT(Id) > 1 AND Name LIKE '%ABC%'`.

**대시보드 컴포넌트 유형?** 막대·선·파이·도넛·퍼널·게이지 차트, Metric, Table(Metric·Gauge는 Grand Total 사용). 대시보드당 최대 20개.

**Dynamic Dashboard?** 현재 로그인 사용자 권한으로 실행. 최대 3개. 예약 불가.

**리포트 표시 최대 레코드?** 2,000개(초과 시 Excel/CSV 내보내기).

**리포트 공유?** 리포트 폴더를 통해.

## 기타 개발

**Apex 클래스 호출 방법?** Visualforce, 트리거, 웹서비스, 이메일 서비스.

**Apex 어노테이션?** @Deprecated, @Future, @IsTest, @ReadOnly, @RemoteAction.

**Scheduler 클래스?** Schedulable 인터페이스 구현, execute() 메서드. UI 또는 System.schedule로 호출. Monitoring > Scheduled Jobs에서 확인.

**Apex 호출 방법(invoke)?** Visualforce, 트리거, 웹서비스, 이메일 서비스.

**MVC 디자인 패턴?** Model(sObject·Apex 클래스), View(Visualforce 페이지·컴포넌트), Controller(Standard·Custom).

**모범 사례?** 코드 벌크화, 루프 안 SOQL 회피, 오브젝트당 트리거 하나(로직은 클래스에), Limits 메서드 사용, ID 하드코딩 회피.

**Cross Object Formula?** Master(부모) 오브젝트의 병합 필드 참조(최대 10개 관계).

**Picklist 값을 Apex에서 가져오기?** Dynamic Apex: getDescribe() → getPicklistValues().

**Formula 필드 문자 제한?** 3,900자(초과 시 컴파일 오류). 수식 안에 다른 수식 포함 가능.

**Tab 설정(프로필)?** Tab Hidden(숨김), Default OFF(미표시, + 버튼으로 접근), Default ON(표시).

**Tab 유형?** Custom Object Tabs, Web Tabs(외부 웹), Visualforce Tabs.

**Data Loader vs Import Wizard?** Data Loader(모든 오브젝트, 최대 100만/500만, 중복 허용, 배치 크기 있음), Import Wizard(Account/Contact/Lead/Solution/커스텀, 최대 50,000, 중복 방지, 배치 크기 없음).

**Escalation Rules?** 특정 기간 후 미해결 Case에 자동 액션(알림·재할당). Case 오브젝트만.

**Email-to-Case?** 회사 이메일로 발송 시 자동 Case 생성, 필드 자동 채움.

**Assignment Rules?** Lead·Case 자동 할당 자동화.

**Custom Object 기본 필드?** Created By, Last Modified By, Owner, Record Name(시스템·감사 필드).

**Task vs Event?** Task(전화·to-do 같은 비즈니스 활동), Event(캘린더 약속).

**Developer Console / Anonymous block?** 메타데이터에 저장되지 않고 Developer Console로 컴파일·실행되는 Apex 코드.

**Pagination?** 이전·다음 링크로 페이지 이동. StandardSetController 또는 SOQL OFFSET/LIMIT.

**Batch Apex?** 복잡·장시간 프로세스 구축. 거버너 한도 직면 시 사용.

## 일반 (클라우드)

**클라우드 컴퓨팅?** 인프라·플랫폼·소프트웨어를 인터넷으로 종량제 접근.

**서비스 유형?** IAAS(인프라), PAAS(플랫폼), SAAS(소프트웨어).

**Force.com?** Salesforce 애플리케이션 개발 플랫폼.

**Agile?** 2주마다 개발을 운영으로 이동하는 프로세스. Scrum 콜(10분 이내).

**에디션?** Contact Manager, Group, Professional, Enterprise, Unlimited.

**표준 오브젝트?** Account, Contact, Opportunity, Lead, Case, Solution, Campaign, Product, Forecast, Contract, User, Report, Dashboard.

**표준 애플리케이션?** Marketing, Sales, Call Center, Community.
