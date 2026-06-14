---
tags: [admin, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Salesforce Interview Q &A]
---

# Salesforce 면접 Q & A (종합)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

> 관리자·개발자 영역을 아우르는 종합 Q&A 모음입니다. (원문의 반복 항목은 통합 정리했습니다.)

## 기초 노트

**검증 규칙(Validation Rule)**
- 비즈니스 규칙에 따라 데이터 생성·업데이트를 막는 조건 기반 오류 메시지.
- 기준이 참이면 오류 메시지 표시, 거짓이면 레코드 저장.
- 레코드 저장(insert/update) 시 발동.
- 주요 사례: 논리 오류(StartDate < EndDate, 입사일 < 생년월일), 조건부 필수 필드(type=Employee면 Phone 필수), 형식 검증(PAN, Aadhaar 등 REGEX), 데이터 일관성(VLOOKUP).

**수식(Formula) 필드**
- 런타임에 자동 계산되어 표시되며 DB에 저장되지 않음(현재 레코드 값 또는 부모 레코드 값 기반).
- 수식 표현식과 반환 타입 두 부분으로 구성, 편집 불가.
- 예: Case 경과 기간 = NOW() − CreatedDate, 급여 밴드 = IF(Salary__c > 10000, "Band A", "Band B"), 보너스 자격 = IF(AND(ISPICKVAL(Type__c,"Employee"), Salary__c > 10000), true, false).

**비즈니스 프로세스 자동화 도구:** Workflow Rules, Process Builder, Assignment Rules, Approval Process, Escalation Rules, Auto Response Rules, Queues, Public Groups, Hierarchical Relationship(User), Flows.

**User란?** Salesforce에 로그인하는 모든 사람(영업 담당자, 관리자, IT 전문가 등). 각 사용자 계정은 최소한 Username, Email, 이름, License, Profile, Role(선택)을 포함합니다.

**Profile이란?** 사용자가 Salesforce에서 무엇을 할 수 있는지 결정하며, 특정 오브젝트·필드·탭·레코드 접근 권한을 부여합니다. 사용자당 하나의 프로필.

**Role이란?** 역할 계층상 위치에 따라 사용자가 무엇을 볼 수 있는지 결정합니다. 계층 상위 사용자는 하위 사용자가 소유한 데이터를 볼 수 있습니다. 선택 사항이며 사용자당 하나. Professional/Enterprise/Unlimited/Performance/Developer 에디션에서만 사용 가능.

## 핵심 Q&A

**Salesforce는 무엇을 하나요?** 기업이 고객과 더 잘 연결되도록 돕는 CRM 소프트웨어와 클라우드 솔루션을 제공하며, 고객 데이터 관리와 활동 추적을 지원합니다.

**두 사용자가 같은 프로필을 가질 수 있나요? 한 사용자에게 두 프로필을 할당할 수 있나요?** 하나의 프로필은 여러 사용자에게 할당 가능. 그러나 각 사용자는 하나의 프로필만 가질 수 있습니다. 추가 권한이 필요하면 권한 집합으로 부여.

**거버너 한도(Governor Limits)란?** 멀티테넌트 환경에서 단일 클라이언트의 공유 리소스 독점을 막기 위해 Apex 런타임 엔진이 엄격히 적용하는 한도. 초과 시 처리 불가능한 런타임 예외 발생. 유형: Per-Transaction Apex Limits, Platform Apex Limits, Static Apex Limits, Size-Specific, Miscellaneous, Email Limits, Push Notification Limits.

**샌드박스 조직이란? 유형은?** 테스트·개발용 운영 환경 사본. 유형: Developer, Developer Pro, Partial Copy, Full.

**운영 환경에서 Apex 트리거/클래스를 편집할 수 있나요? Visualforce 페이지는?** Apex 클래스·트리거는 운영에서 직접 편집 불가(Developer/테스트/샌드박스에서 작업 후 Author Apex 권한 사용자가 배포 도구로 배포). Visualforce 페이지는 샌드박스와 운영 모두에서 생성·편집 가능.

**표준 필드 Record Name의 데이터 타입은?** Auto Number 또는 80자 제한 Text.

**Visualforce 페이지가 다른 도메인에서 제공되는 이유는?** 보안 표준 향상과 크로스 사이트 스크립팅 차단을 위해.

**활동(Activity)의 Who Id와 What Id란?** Who ID = 사람(Contact/Lead), What ID = 오브젝트(Account/Opportunity).

**공유 규칙(Sharing Rule)의 용도는? 데이터 접근을 제한할 수 있나요?** Public Group이나 역할의 사용자에게 더 큰 접근(Read/Write 또는 Read Only)을 부여. 접근을 제한할 수는 없고 확장만 가능.

**이메일 템플릿의 유형은?** Text(모든 사용자), HTML with Letterhead("Edit HTML Templates" 권한), Custom HTML(권한 필요, letterhead 없음), Visualforce(관리자·개발자, 여러 레코드 병합).

**리포트의 Bucket Field란?** 복잡한 수식·커스텀 필드 없이 범위·세그먼트로 레코드를 그룹화. 여러 버킷(카테고리) 정의.

**Dynamic Dashboard란? 예약 가능한가?** 특정 사용자에 맞춘 정보 표시(개인 할당량·매출 등). Static Dashboard는 단일 사용자 관점. Dynamic Dashboard는 예약 불가(실시간 데이터 표시).

**리포트 유형은? 대량 삭제 가능?** Tabular, Summary, Matrix, Joined. Summary·Matrix만 대시보드 소스로 사용 가능. 대량 삭제는 Setup의 Data Management에서 가능.

**오브젝트 관계 유형은?** Master-Detail(1:n, 부모가 자식 제어, cascade delete, 자식이 소유·공유·보안 상속), Lookup(1:n, 종속성 없음, cascade delete 없음), Junction(다대다, 두 Master-Detail로 3개 오브젝트 연결).

**Master 레코드 삭제 시 detail 레코드는? Lookup에서 부모 삭제 시 자식은?** Master-Detail은 detail 자동 삭제(cascade), Lookup은 자식 삭제 안 됨.

**Master-Detail에서 롤업 요약 필드를 가질 수 있나요?** 네(Lookup은 불가). 자식의 필드 값을 기반으로 master에 값 표시. Count, Sum, Min, Max 4가지 계산.

**Data Skew란?** 10,000개 이상 레코드를 단일 사용자가 소유할 때(ownership data skew) 업데이트 시 성능 문제 발생. 단일 사용자/단일 역할이 특정 오브젝트의 대부분 레코드를 소유할 때.

**Skinny Table이란?** 자주 사용하는 필드에 접근하고 조인을 피해 성능을 크게 향상. 고려사항: 최대 100열, 다른 오브젝트 필드 불가, Full 샌드박스에 복사됨(Summer '15 이후).

**자동으로 인덱싱되는 필드는?** Primary Key(Id, Name, Owner), Foreign Key(lookup/master-detail), 감사 날짜(SystemModStamp), External ID/unique 표시 커스텀 필드.

**Data Loader 업로드 시 필드 내 쉼표를 처리하려면?** CSV에서 내용을 큰따옴표(" ")로 감쌉니다.

**시간 종속 워크플로우 액션을 만들 수 없는 기준은?** "생성되고 편집될 때마다(created, and every time it's edited)".

**Custom Settings의 유형과 장점은?** List Custom Settings(프로필/사용자 무관 정적 데이터), Hierarchy Custom Settings(프로필/사용자별 개인화). 장점: 사용자·프로필별 커스텀 접근 규칙 생성.

**Lead/Case에 활성 할당 규칙은 몇 개?** 한 번에 하나만 활성.

**Custom Label이란? 문자 제한은?** Apex 클래스·Visualforce에서 접근하는 커스텀 텍스트 값으로 번역 가능(다국어 앱). 조직당 최대 5,000개, 각 1,000자.

**Role과 Profile의 차이는?** Profile은 필수(레코드 접근 제어), Role은 선택(계층 상위가 하위 레코드 접근).

**비결정적(non-deterministic) 수식 필드 예시는?** Lookup 필드, 다른 엔티티를 참조하는 수식, TODAY()/NOW() 같은 동적 날짜 함수. (결정적 필드는 값이 정적, 비결정적은 동적으로 변경.)

**테스트 클래스를 작성하는 이유와 식별 방법은?** 견고하고 오류 없는 코드를 위해. @isTest 어노테이션으로 식별, testMethod 키워드를 가진 메서드가 테스트 메서드.

**트리거 배포에 필요한 최소 테스트 커버리지는?** 75% 이상, 모든 테스트 성공.

**배포 방법은?** Change Sets, Eclipse with Force.com IDE, Force.com Migration Tool(ANT/Java), Salesforce Package.

**External ID란? 어떤 데이터 타입이 가능한가?** 레코드의 고유 식별자로 사용되는 커스텀 필드(임포트 시 사용). Text, Number, Email, Auto-Number 가능. 커스텀 필드만.

**단일 Apex 트랜잭션에서 외부 콜아웃은 몇 개?** 거버너 한도로 최대 100개.

**Apex 클래스를 REST 웹 서비스로 노출하려면?** @RestResource 어노테이션으로 정의. 호출은 항상 system 컨텍스트 사용(현재 사용자 권한 미반영), 민감 데이터 노출 주의.

**Standard Controller와 Custom Controller의 차이는?** Standard Controller는 표준 오브젝트 속성·버튼 기능을 상속. Custom Controller는 표준 컨트롤러 없이 모든 로직을 구현하는 Apex 클래스(controller 속성으로 연결).

**Visualforce에서 Pagination을 어떻게 구현하나요?** 기본 List Controller는 20개 반환. controller extension으로 pageSize 설정. `<apex:commandLink action="{!previous}">` / `{!next}` 사용.

**JavaScript에서 컨트롤러 메서드를 호출하려면?** actionFunction 사용.

**현재 로그인한 모든 사용자의 UserID를 Apex로 가져오려면?** `UserInfo.getUserId()`.

**SOQL/SOSL이 반환할 수 있는 최대 레코드 수는?** SOQL 50,000개, SOSL 2,000개.

**Attribute 태그란?** 커스텀 컴포넌트의 속성 정의(component 태그의 자식). id, rendered는 자동 생성되므로 정의 불가. `<apex:attribute name="..." type="String" required="true"/>`.

**Visualforce의 세 가지 바인딩은?** Data Bindings(컨트롤러 데이터), Action Bindings(컨트롤러 액션 메서드), Component Bindings(다른 VF 컴포넌트).

**Apex의 컬렉션 유형과 Map은?** List, Map, Set. Map은 키-값 쌍 저장(`Map<String, String> country_city = new Map<String, String>();`).

**Visualforce 페이지에 Flow를 임베드하려면?** Flow의 unique name을 복사해 `<flow:interview name="flowuniquename"/>`를 `<apex:page>` 태그 안에 추가.

**@future 어노테이션의 용도는?** 메서드를 비동기 실행. 외부 서비스 콜아웃 등에 사용. static 메서드여야 하고 void만 반환.

**Batch Apex 클래스의 메서드는?** start(레코드 수집, QueryLocator/Iterable 반환), execute(각 배치 처리), finish(후처리).

**Visualforce 컴포넌트란?** 사전 정의(표준) 또는 커스텀 컴포넌트로 UI 동작 결정. 예: `<apex:detail>`.

**Trigger.new란?** 새로 추가된(아직 DB 미저장) sObject 레코드 목록. insert·update 트리거에서만, before에서만 수정 가능. (Trigger.old는 이전 버전, update·delete에서만.)

**Set이 저장할 수 있는 데이터 타입은?** Primitive, Collections, sObjects, 사용자 정의 타입, 내장 Apex 타입.

**sObject 타입이란?** Force.com 데이터베이스에 저장 가능한 모든 오브젝트. 제네릭 sObject 추상 타입으로 모든 오브젝트 표현. Account, Opportunity, CustomObject__c는 구체 타입.

**SOQL과 SOSL의 차이는?** SOQL은 한 번에 한 오브젝트, 모든 필드 쿼리, 클래스·트리거 사용, 쿼리 결과에 DML 가능, 레코드 반환. SOSL은 여러 오브젝트, email/text/phone 필드만, 클래스에서만(트리거 불가), DML 불가, 필드 반환.

**Apex Transaction이란?** 단일 단위로 실행되는 작업 집합. 모든 DML이 성공하거나, 단일 레코드 오류 시 전체 롤백.

**public과 global 클래스의 차이는?** global은 네임스페이스 무관 전체 접근, public은 해당 네임스페이스 내에서만.

**getter/setter 메서드란?** getter는 컨트롤러에서 VF 페이지로 값 전달, setter는 페이지에서 컨트롤러 변수로 값 설정.

**Asynchronous Apex의 유형은?** Future Methods, Batch Apex, Queueable Apex, Scheduled Apex.

**Visualforce에서 Header와 Sidebar를 숨기려면?** `<apex:page>`에서 showHeader="false", sidebar="false".

**Visualforce에서 AJAX 요청을 수행하려면?** `apex:actionRegion`으로 영역을 표시하여 해당 컴포넌트만 서버가 처리.

**Lightning Component란?** 데스크톱·모바일용 단일 페이지 애플리케이션 UI 프레임워크. Aura Component Model과 Lightning Web Component Model 두 가지. 클라이언트는 JavaScript, 서버는 Apex.

**Developer Console이란?** 애플리케이션 생성·디버그·테스트를 위한 통합 개발 도구 모음.

**Package와 유형, Managed Package란?** 컴포넌트/관련 앱의 모음. Managed(클라이언트에 판매·배포, 업그레이드 가능), Unmanaged. Managed는 AppExchange로 사용자 라이선스·앱 판매.

**Apex의 Access Modifier는?** private, protected, public, global.

**Undelete가 없는 작업은?** before 작업.

**Blob 변수의 용도는?** 바이너리 데이터 수집. toString()으로 문자열 변환.

**apex:outputLink의 목적은?** URL 링크. body에 표시할 이미지·텍스트 포함.

**Static Resource란?** Visualforce에서 참조할 콘텐츠 업로드(zip, jar, 스타일시트, 이미지, JavaScript 등). 조직당 최대 250MB. Lightning 플랫폼이 CDN 역할.

**OAuth란?** 무관한 서비스·서버가 자격 증명 공유 없이 인증된 접근을 안전하게 허용하는 방법을 기술하는 개방형 인증 프로토콜.

**Connected App이란?** API로 외부 애플리케이션을 Salesforce와 통합. OAuth·SAML 프로토콜로 인증, SSO·토큰 제공.

**Salesforce의 API는?** SOAP API(엔터프라이즈), REST API(클라이언트-서버 메시지, XML/JSON), Bulk API(비동기 대용량), Streaming API(쿼리 기반 변경 알림 푸시), Apex REST/SOAP API(Apex 노출).

**Apex로 개발하는 플랫폼은?** Force.com 플랫폼. 모바일 앱은 Mobile SDK.

**Primitive 데이터 타입은?** Integer, Double, Long, Date, Date-Time, String, ID, Boolean 등(값으로 전달).

**Standard Controller와 Controller 속성을 동시에 참조할 수 있나요?** 아니요. extensions 속성으로 표준 컨트롤러를 커스텀 컨트롤러로 확장.

**Development Mode란?** Visualforce 페이지를 코드와 출력을 동시에 보며 빌드하는 모드(상세 스택 트레이스, view state 푸터, Page Markup Editor 제공).

**Multitenant 아키텍처란?** IT 리소스를 안전하고 비용 효율적으로 공유하는 클라우드의 핵심 기술(여러 클라이언트가 하나의 인스턴스 사용).

**External Lookup이란?** 자식 오브젝트(커스텀·표준·외부)를 부모 외부 오브젝트에 연결. 값은 External Id 값과 매칭.

**Self-Relationship이란?** 같은 오브젝트에 대한 Lookup. 오브젝트 트리 다이어그램 생성. (Master-Detail은 불가.)

**Time Trigger란?** 규칙과 일정에 따라 작업을 실행하는 시간 값.

**Matrix/Tabular/Summary 리포트에 표시 가능한 레코드 수는?** 최대 2,000개.

**오브젝트당 Master-Detail 필드는?** 최대 2개. Lookup은 최대 40개.

**User License 정보를 보려면?** Setup → Administer → Company Profile → Company Information.

**프로필 생성 시 라이선스를 변경할 수 있나요?** 아니요.

**Object Relationship Overview란?** 관련 목록에서 커스텀 오브젝트와 표준 오브젝트 레코드를 연결(제품 결함 추적에 유용).

**레코드를 저장하는 다양한 방법은?** Attachments, Google Drive, Chatter Files, Libraries.

**DataTable vs PageBlockTable 태그의 차이는?** PageBlock: page block 내 정의, 스타일시트로 디자인, value 속성 필수, 열 헤더 자동 표시. DataTable: page block 내 불필요, value 불필요, 커스텀 스타일시트, 열 헤더 명시 필요.

**데이터 손실을 유발하는 것은?** 다른 타입에서 Number/Percent/Currency로 마이그레이션, Date/Time 변경, 다른 타입(picklist 제외)에서 Multi-Select로, Checkbox/Auto Number/Multi-Select에서 다른 타입으로, Text Area에서 Phone/URL/Email/Text로.

**거버너 한도가 부분 DML을 허용하나요?** (루프에서 200개 삽입 중 151번째에서 한도 도달 시) 아니요, 전부 아니면 전무(all or none).

**Apex Interface란?** 미구현 메서드 모음. 메서드 시그니처(입력·출력 타입) 지정. 보통 global로 선언.

**Apex를 어디에 사용하나요?** 이메일 서비스, 웹 서비스, 여러 오브젝트에 걸친 복잡한 검증, 워크플로우가 지원하지 않는 복잡한 비즈니스 프로세스, 커스텀 트랜잭션 로직.

**Apex는 어떻게 작동하나요?** Force.com 플랫폼에서 온디맨드 실행. 앱 서버가 코드를 추상 명령으로 컴파일하여 메타데이터에 저장. 버튼/VF 페이지 트리거 시 메타데이터에서 컴파일된 명령을 가져와 런타임 인터프리터로 실행.

**Apex Email Service란?** Apex 클래스로 인바운드 이메일의 내용·헤더·첨부를 처리하는 자동화 프로세스. 각 서비스는 Salesforce 생성 이메일 주소와 연결.

**Apex Scheduler란?** Schedulable 인터페이스를 구현해 특정 시간에 Apex 클래스를 실행. execute(SchedulableContext sc) 메서드.

**Apex Managed Sharing이란?** 개발자가 앱 공유 요구사항을 지원. "Modify All Data" 권한 사용자만 추가·변경 가능. Sharing Reason(Apex Sharing Reason) 사용.

**Bulkification 모범 사례는?** Trigger.New[0] 같은 인덱스 값 피하기, for-each 루프 사용, 루프 안에 SOQL/SOSL/DML 금지, 컬렉션에 데이터 저장.

**database.insert(list, true)와 (list, false)의 차이는?** true는 일반 insert(전부 아니면 전무), false는 부분 DML 허용.

**SOQL 문의 유형은?** Static SOQL([] 대괄호), Dynamic SOQL(런타임에 Database.query()로 문자열 생성).

**SOQL 구문은?** `SELECT field1, field2,... FROM Object_Type [WHERE condition]`.

**GROUP BY란?** API 18.0+에서 sum()/max() 같은 집계 함수와 함께 데이터 요약. `GROUP BY field`.

**SOSL 구문은?** `FIND 'map*' IN ALL FIELDS RETURNING Account(Id, Name), Contact, Opportunity, Lead`. Apex에서는 작은따옴표, API에서는 중괄호.

**JavaScript Remoting이란?** Visualforce에서 JavaScript로 Apex 컨트롤러 메서드 호출. 3부분: JS 원격 메서드 호출, Apex 컨트롤러 메서드 정의(@RemoteAction), 응답 처리 콜백.

**Declarative vs Non-declarative 접근은?** Declarative(코드 없이 작업), Non-declarative/Customization(코드로 작업).

**쿼리에서 변수를 비교하는 연산자는?** `=`. 컬렉션을 전달하는 키워드는 `IN`.

**inputText vs inputField의 차이는?** inputField는 오브젝트의 필드를 복사해 VF에 표시(복사-붙여넣기), inputText는 처음부터 필드 생성.

**AppExchange 디렉터리란?** Salesforce 고객이 앱을 검토·데모·설치하는 웹 디렉터리.

**라디오 버튼과 선택 목록에 선택 값을 만드는 태그는?** `<apex:selectOption>`.

**커스텀 인덱스에 추가할 수 없는 필드는?** 수식(Formula) 필드.

**transient 키워드의 효과는?** 데이터가 view state에 저장되지 않게 함(임시 변수용).

**VF 페이지에서 최대 필드 종속성은?** 10개.

**보안 토큰을 얻는 방법은?** Name 탭 → Personal → Reset My Security Token.

**Metadata 기반 개발 모델이란?** 코드 없이 선언적 "청사진"으로 앱을 정의(데이터 모델, 오브젝트, 폼, 워크플로우 등을 메타데이터로 정의).

**Force.com Sites란?** 사용자 로그인 없이 Salesforce 조직과 직접 통합되는 공개 웹사이트·애플리케이션.

**Batch Apex 작업을 프로그래밍 방식으로 실행하려면?** `Database.executeBatch(클래스 객체)` 또는 `Database.executeBatch(클래스 객체, scope)`.

**부분 페이지 새로 고침(partial refresh)을 만들려면?** 새로 고칠 영역과 트리거 이벤트를 정의. reRender 속성으로 AJAX 사용.

**컴포넌트 마크업으로 JS 컨트롤러 액션을 호출하려면?** action provider 사용.

**Component Event와 Application Event는?** Application Event는 어떤 컴포넌트든 발생·처리(컴포넌트 간 관계 불필요). Component Event는 자식이 발생하고 부모가 처리(자식→부모 값 전달).

**Lightning Message Service(LMS)란?** 같은 Lightning 페이지에서 Aura, LWC, Visualforce 간 통신을 허용(Lightning Experience에서만).

**Custom Object vs Custom Settings의 차이는?** Custom Object는 DB에 데이터 저장, 모든 데이터 타입, Apex 트리거·검증 규칙 가능, 탭 생성 가능. Custom Settings는 애플리케이션 캐시에 저장, SQL 쿼리 불필요, 제한된 데이터 타입, List Custom Settings는 트리거·검증 불가, 탭 불가.

**Salesforce Chatter란?** 정보 공유와 협업을 가능하게 하는 소셜 네트워킹 애플리케이션.

**Guest User란?** 계정이 없는 미인증 사용자(로그인 불필요). 페이지를 공개 가능하게, 레코드 생성·편집 가능. 게스트 라이선스 무료.

**Salesforce가 영업을 추적하는 방법은?** 일일 응대 고객 수, 정기 매출, 영업 관리자 리포트, 적시 리포트 생성, 재구매 고객 활동.

## 추가 Admin/Apex 질문 모음

(앞 항목과 일부 중복되는 내용은 통합) Roll-Up Summary는 master 오브젝트에 생성하며 Master-Detail 관계 필요. Queue는 Lead·Case·커스텀 오브젝트 등에서 작업 부하를 분배·우선순위 지정·할당. Time-Dependent Workflow는 레코드 마감 전 특정 시점에 액션 수행. Approval Process는 레코드 승인 단계 시퀀스. Change Set은 연결된 조직 간 컴포넌트 마이그레이션.

S-Control은 JavaScript 기반 위젯으로 Visualforce로 대체됨. Wrapper 클래스는 여러 오브젝트 컬렉션을 담는 데이터 구조로 VF의 단일 테이블에 다양한 오브젝트 표시. AppExchange는 Salesforce 애플리케이션 마켓플레이스.
