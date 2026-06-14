# Salesforce 종합 End-to-End 가이드

> 관리자·아키텍트 수준의 광범위한 치트시트입니다.

## CRM 치트시트 (영업 흐름)

- **리드 유입:** 웹사이트·소셜, Web-to-Lead 양식, 인바운드 콜, 리스트 임포트.
- **리드 생성:** 먼저 검색 후 신규 생성, 자동 응답 이메일 설정, 리드 할당 규칙 설정(지역·회사 규모·관심 제품), 중복 관리로 중복 방지.
- **마케팅 캠페인:** 이메일·DM·콜드콜·파트너·TV·라디오·이벤트·전시회·PR 계획·실행.
- **리드 작업:** 리드 유형별 작업 시리즈 설정(예: 1일차 개인화 메일, 2~3일차 통화/음성메일, 4일차 메일).
- **자격 판단:** 현 상황·관심 제품·기간·핵심 의사결정자 등 자격 질문. 자격 있으면 Contact로 전환(연결된 Opportunity·Account 생성).
- **Opportunity → 프레젠테이션·제안·협상 → 성사(Won):** 죽은 리드/Opportunity는 보관(archive)하고 이메일 마케팅으로 재마케팅.

## Service Cloud 치트시트

- 웹사이트·소셜·온라인 커뮤니티, Web-to-Case, 콜, 이메일·채팅·영상.
- Case 생성/업데이트, 자동 응답 이메일, 케이스 상태로 지원 프로세스 정의, Queue·할당 규칙, Entitlements(SLA 검증).
- 기능: Escalation Rules, Reports/Dashboards, Knowledge, CTI, Communities, Console, Live Agent.

## 예측(Forecasting)

조직 내 미래 매출 예측. 각 사용자의 Opportunity 레코드와 단계의 예측 카테고리에서 집계. 장점: 영업 담당자가 상태를 쉽게 유지, 마감일 기반 자동 합산. 단점: 부정확한 업데이트가 데이터 무결성을 해침.

- **Customizable Forecasting:** 커스텀 회계 연도, 영역 관리, 스냅샷·이력 등 커스터마이징.
- **Collaborative Forecasting:** 더 유연하고 직관적인 UI. 카테고리 이름 변경, 확장형 예측 테이블, opportunity splits 예측 등.

## 영역 관리(Territory Management)

계정 특성에 따라 접근을 부여하는 계정 공유 시스템. 영업 영역과 동일하게 데이터·사용자를 구조화. 계정·사용자는 여러 영역에 속할 수 있으나 Opportunity는 하나의 영역에만 속함. 계정 소유권과 레코드 공유는 유지됨. Original Territory Management는 Customizable Forecasts에서만 사용 가능. Enterprise Territory Management는 Collaborative Forecasts와 동시 활성화 가능(단, 통합 작동은 아님). Territory 공유와 역할 계층 공유가 동시 활성화되면 더 관대한 접근이 적용됨.

## 암호화 방식

**Classic Encrypted Fields:** Text(Encrypted) 타입만 지원. "View Encrypted Data" 권한 사용자만 조회. unique·external ID·기본값 불가. 175자 제한. 많은 기능에서 미지원. 기존 필드를 암호화 필드로 변환 불가.

**Shield Platform Encryption:** 플랫폼 기능을 보존하며 보안 계층 추가. HSM 기반 키 파생 시스템으로 암호화. 플로우·프로세스에서 참조 가능. Account, Contact, Case, Case Comment의 특정 필드 암호화. email·phone·url·datetime·텍스트 타입 커스텀 필드 암호화 가능. 일부 SF 앱(Heroku, CPQ, Data.com, Marketing Cloud)에서 미지원.

## 오브젝트 관계 유형

- **Master-Detail:** 마스터가 detail/subdetail 동작 제어. 보안·권한 상속. Owner 필드 없음(마스터 소유자로 자동 설정). 관계 필드 필수. 마스터 삭제 시 detail도 삭제.
- **Lookup:** 두 오브젝트 연결(공유·롤업 요약 미지원). 필수·삭제 방지·cascade delete 설정 가능.
- **External Lookup:** 자식(표준/커스텀/외부)을 부모 외부 오브젝트에 연결. External ID 값으로 매칭.
- **Indirect Lookup:** 자식 외부 오브젝트를 부모 표준/커스텀 오브젝트에 연결. 부모의 unique external ID 필드로 매칭.
- **Hierarchical:** User 오브젝트 전용 특수 lookup. 자기 자신을 직간접 참조하지 않게 사용자 연결(예: 직속 관리자).
- **Many-to-Many:** 2개의 Master-Detail/Lookup 관계를 가진 정션 오브젝트로 생성.

## 조직 전략(Org Strategy)

**Single-Org:** (장점) 부서 간 협업, 공유 Chatter, 정렬된 프로세스·리포트, 데이터 공유, 통합 리포팅, 단일 로그인. (단점) 복잡성 증가, 조직 한도 도달 가능, 조직 전체 설정 관리 어려움, 회귀 테스트 증가.

**Multi-Org:** (장점) 논리적 데이터 분리, 한도 초과 위험 감소, 설정 관리 용이, 성능 개선, 빠른 출시. (단점) 전역 프로세스 정의 어려움, 코드 재사용 감소, 협업 저하, 관리 중복, SSO 복잡성, 조직 병합·분할 어려움.

Multi-Org 접근: 1) 완전 자율(각 조직 비연결), 2) Master-Child(마스터가 자식에 데이터 푸시), 3) 중앙 조직 없음(Salesforce2Salesforce 통합으로 직접 연결).

## 비동기 Apex와 단위 테스트

- 최소 75% 테스트 커버리지 필요, 모든 트리거에 일부 커버리지 필요, 모든 클래스·트리거 컴파일 성공.
- @isTest 클래스는 top-level이어야 하며 interface·enum 불가.
- 테스트 메서드는 실행 중인 테스트에서만 호출 가능.
- 웹 서비스 콜아웃 테스트는 mock 콜아웃 사용(Test.setMock + HttpCalloutMock, WebServiceMock).
- @TestVisible로 private 메서드 접근, IsTest(SeeAllData=true)로 조직 데이터 접근.
- @testSetup으로 테스트 레코드 한 번 생성. runAs로 사용자 컨텍스트 변경·Mixed DML. Test.startTest/stopTest로 거버너 한도 관리.

## 배포 방법

- **Change Sets:** 샌드박스→운영 마이그레이션, 로컬 파일 시스템 없이, 여러 조직 배포.
- **Ant Migration Tool:** 대량 설정 변경, 다단계 릴리스, 반복 배포, 배치 배포 예약.
- **Force.com IDE:** 프로젝트 기반 개발, 모든 조직 배포, 변경 동기화.
- **Force.com Workbench:** 임시 쿼리, package.xml 배포, 경량 데이터 로드(비공식 지원).
- **Force.com CLI:** 스크립트 명령·자동화.
- **Unmanaged Packages:** 개발 환경 일회성 설정, 커스터마이징 시작점.
- **Managed Packages:** 상용 앱, 여러 조직에 기능 추가(코드 숨김, 고유 네임스페이스).

## 다중 언어 지원

관리자가 Setup에서 언어별로 활성화. 표준 오브젝트·필드는 자동 번역. Translation Workbench로 번역 값 유지. 거의 모든 것(오브젝트명, 필드 라벨, 선택 목록 값, 검증 메시지) 번역 가능. 번역 값이 없으면 조직 기본 언어 사용. 파일로 내보내기·가져오기 가능.

## 다중 통화(Multi-Currency)

기본은 단일 통화. 활성화 후 지원 통화 지정. 각 레코드에 Currency 필드. 금액은 레코드 통화로 표시되고 레코드 소유자의 개인 통화로도 변환. 리포트는 원 통화로 표시(활성 통화로 표시 가능). 관리자가 환율 수정 가능. Advanced currency management로 dated exchange rate 관리. Cross-object 수식은 항상 정적 환율 사용.

## 커스텀 공유 코드 보호

수동 공유는 소유자 변경 시 삭제됨. 코드 공유 보호: Apex Sharing Reasons(커스텀 오브젝트만), Outbound Messaging으로 외부 시스템 복원, 트리거+할당 엔진, Shadow Sharing Table+트리거.

## 테스트 유형

Unit testing(개발 중), Code review(병합/커밋 시), Functional testing(QA), Integration testing(CIT), System Integration testing(SIT), User Acceptance testing(UAT), Performance testing(Stress/Load, LoadRunner 등), Smoke testing(배포 후), Regression testing(변경 후), Data migration testing(UAT/Staging).

## Salesforce 공유 방법

Profiles, Permission Sets, Organization Wide Defaults, Role Hierarchy, Sharing Rules, Sharing Sets(고볼륨 사용자), Sharing Groups(커뮤니티), Partner Super Users, Public Groups, Queues, Teams(Account/Opportunity/Case), Territory Management, Implicit Sharing(시스템 정의: Parent/Child/Portal/High Volume), Manual Sharing, Apex Managed Sharing.

## 조직 접근 제한

- **My Domain:** 로그인 정책 선택, 브랜딩·SSO 지원.
- **Login IP Ranges:** 프로필에 허용 IP 범위 지정(다른 IP 거부).
- **Login Hours:** 프로필 기반 로그인 시간 지정.
- **Two-Factor Authentication:** 프로필별 인증 코드(TOTP) 요구.
- **Trusted IP Ranges:** 로그인 챌린지 없이 로그인 가능한 IP 목록.

## ETL & ESB 통합

**ETL:** 여러 소스의 대량 데이터 추출·변환·로드(배치·예약·임시). 예: Talend, Informatica, Jitterbit. **ESB:** 애플리케이션 컴포넌트 간 작업 분배 미들웨어. 예: MuleSoft. 통합 지점이 2개 이상, 여러 프로토콜(FTP·HTTP·Web Service·JMS) 사용, 메시지 내용 기반 라우팅 시 사용. 5대 원칙: Orchestration, Transformation, Transportation, Mediation, Non-functional consistency.

## 계정 모델

**B2C:** Person Accounts(개인 정보, 되돌릴 수 없음), Private Contact(권장 안 함), Household model(NPSP 기본·권장), 1-to-1 Account Model, Bucket model(모든 Contact를 하나의 Account에).

**Account Hierarchy:** Global Enterprise Account(하나의 전역 계정), Location-Specific Accounts(위치별 계정).

**Contacts to Multiple Accounts:** Account Contact Roles(커스텀 미지원), Contacts to Multiple Accounts(커스텀 지원), Custom Junction Object(전체 기능, 커스텀 개발 필요).

## 데이터 마이그레이션 & 백업

**데이터 로딩 모범 사례:** 수천 건 이상은 Bulk API, 가장 빠른 작업 우선(Insert > Update > Upsert), Public Read/Write로 공유 계산 회피, 트리거·워크플로우·검증 비활성화, 자식은 부모 ID로 그룹화, defer-sharing 사용, 로드 후 공유 규칙 활성화(하나씩), 감사 필드는 insert 시에만 채움.

**백업 유형:** Full, Incremental, Partial. **아카이빙:** BigObject, Salesforce 외부, 주간 export, Data Loader, Reporting snapshot.

## 데이터 거버넌스 & 스튜어드십

**데이터 거버넌스:** 데이터 자산의 사용성·품질·정책 준수를 보장하는 프로세스. **데이터 스튜어드십:** 거버넌스 규칙 준수를 위한 교차 기능 역할. **마스터 데이터 관리(MDM):** 단일 마스터 참조 소스 생성(3대 축: 데이터, 데이터 관계, 이벤트 마스터링).

## 사용자 프로비저닝 방법

Manual provisioning, API provisioning(SOAP/REST), Programmatic(Apex), JIT provisioning with SAML, Mass user provisioning(Bulk API/Data Loader/ETL), Identity Connect with AD, Self-registration(커뮤니티), Social sign-on(커뮤니티).

## SSO 방법

SSO with multiple Orgs(내부 사용자만), SSO with AD(Identity Connect/ADFS), Social Sign On(커뮤니티), Federated Authentication(SAML assertion), Delegated Authentication(외부 WS). *관리자 사용자에게는 SSO 활성화하지 말 것.

## 데이터 품질 & 중복 관리

**품질 속성:** Age, Completeness, Accuracy, Consistency, Duplication, Usage.

**안전한 삭제:** 의심 격리 → 제거 표시·색상 코드 → 보안으로 숨김 → 대기(약 3개월) → 백업 → 삭제.

**중복 제거 순서:** Accounts vs Accounts → Account 내 Contacts → Account 간 Contacts → Accounts vs Accounts → Leads → Leads to Contacts.

**도구:** Data.com, Duplicate Rules, Merging records. **아카이브 전략:** In-place, External, Hybrid(데이터 티어링).

## 2단계 인증(2FA)

모든 사용자 로그인에 두 번째 인증 요구 가능. 신뢰 IP 범위 밖에서 인식하지 않는 브라우저/앱으로 로그인 시 신원 확인. 우선순위: 1) Salesforce Authenticator 푸시·위치 기반, 2) U2F 보안 키, 3) 모바일 인증 앱 코드, 4) SMS 코드, 5) 이메일 코드, 6) Login Flows.

## 제안할 관리형 패키지

문서 생성(Conga Composer, WebMerge, Drawloop), eSignature(DocuSign, EchoSign), ESB(MuleSoft), CPQ(Salesforce CPQ, CloudSense), 마케팅(Marketing Cloud, Marketo), 회계(FinancialForce, Intacct), 분석(Wave Analytics), 클라우드 저장(Heroku, AWS), 문서 저장(Box, Google Drive, SharePoint, DropBox, CRM Content).

## 모바일 전략 결정

Native(빠름, App Store, 카메라·알림 지원, ObjectiveC/Java), HTML5(느림, 웹, 크로스플랫폼), Hybrid(느림, App Store, 카메라·알림), Salesforce App(표준+Visualforce, 빠른 개발). 성능·룩앤필·배포·오프라인·개발 기술 등을 고려해 선택.

## Salesforce Communities

**템플릿:** Visualforce+Tabs, Customer Service(Napili), Kokua & Koa, Lightning Communities, Partner Central, Customer Account Portal.
**롤아웃 단계:** Establish → Manage → Engage → Measure.
**브랜딩:** 색 구성, 이메일 커스터마이징, 로고, 로그인 페이지, 커스텀 도메인.

## 프로젝트 방법론

**Agile vs Waterfall.** 산출물: 중앙 협업·문서 저장소, 요구사항 추적, 거버넌스 수준(Steering Committee, COE, Architectural Review Board), 품질 관리(설계 표준, 피어 리뷰, 코드 리뷰, 배포 체크리스트), 테스트 전략, 의존성 관리. 핵심 도구: 프로젝트 관리 SW(MS Project, Agile Accelerator), 요구사항 저장소(Rally, Jira, Excel), Traceability Matrix, Test Suite 관리.

**Center of Excellence(COE):** 비즈니스 프로세스·CRM·도메인 전문가 팀. 유형: Best Practice Centers(공유자), DevOps Centers(실행자), Competency Centers(안내자), Innovation Centers(창조자).

## Chatter 기능

Connect to Business Processes, Actions, Mobile, Engagement(기여 점수·배지), Groups, Polls, Rich Feeds, Topics, Recommendations, Salesforce Files, Answers.

## 발표(Presentation) 개요

Title → Agenda → About me → About company → Requirements → Assumptions → Actors & licenses → System landscape → Integrations → Data model → Role hierarchy → Mobile → Communities → Authentication → LDV mitigation → Reporting → 기타 SF 기능 → Data migration → 프로젝트 관리·거버넌스 → 방법론 산출물 → 개발 전략 → Sandbox 구조 → 테스트 전략 → 리스크·완화 → Q&A.

## 기타 보안 기능

- **Certificates and Keys:** 요청이 조직에서 왔음을 검증하는 서명에 사용(SSL, Identity Provider). 자체 서명 또는 인증 기관 서명.
- **Named Credentials:** 콜아웃 엔드포인트 URL과 인증 매개변수를 하나로 정의. 인증을 직접 처리할 필요 없음.
- **WSDL 유형:** Enterprise WSDL(강타입, 특정 조직 구성에 묶임, 고객용), Partner WSDL(약타입, 정적, 어떤 조직 구성에도 사용, 파트너용).

## 리포트와 대시보드

**리포트 형식:** Tabular(단순·총합), Summary(그룹·소계·차트), Matrix(행·열 그룹화), Joined(여러 블록). *리포트는 최대 3단계 그룹화.

**대시보드 컴포넌트:** Chart, Gauge, Metric, Table(정렬·조건부 강조), Visualforce Page(StandardSetController 또는 CustomController 필요).

## 통합(Integration)

**유형:** UI 통합, 데이터 통합, 보안 통합, 비즈니스 프로세스 통합. **설계 패턴:** API Wrapper class, Delegator class, 선택 컴포넌트(로깅·매핑·세션·예외 처리).

**메커니즘:** External Objects(Salesforce Connect Adapters: Cross-org, OData 2.0/4.0, Custom), Canvas(서드파티 앱 통합), Push Notifications, REST API, SOAP API, Chatter REST API, Bulk API, Metadata API, Streaming API(PushTopics), Web Service API, Tooling API, Apex Callouts, Outbound Messages(SOAP, Session ID, 24시간 재시도), Email(InboundEmailHandler), Middleware(ESB/ETL).

## OAuth & SSO 플로우

- **Web Server Flow:** 보안 서버 호스팅 앱. client secret 보호. authorization code grant. 장기 access token(refresh token으로 갱신). 가장 안전(access token이 클라이언트 측에 노출 안 됨).
- **User-Agent Flow:** 브라우저 스크립팅 언어. implicit grant. refresh token 없음. access token이 URI fragment로 노출되어 가장 덜 안전.
- **JWT Bearer Token Flow:** 서버-서버 API 통합. 인증서로 JWT 서명, 사용자 상호작용 불필요.
- **Device Authentication Flow:** 입력·표시 제한 기기(TV·IoT). 커뮤니티 미지원.
- **Asset Token Flow:** 연결된 기기용 asset token 요청.
- **SAML Bearer Assertion Flow / SAML Assertion Flow:** SAML assertion으로 OAuth access token 요청(단일 조직 내).
- **Username and Password Flow:** 자격 증명을 주고받음(테스트용으로만 사용 권장).
- **OAuth 2.0 Refresh Token Flow:** access token 갱신.
- **Canvas App User Flow:** Signed Request(기본), OAuth(Web Server/User-Agent), SAML SSO.

## LDV(대용량 데이터) 완화 전략

- **Indexes:** 커스텀 인덱스(Salesforce 지원 요청).
- **Skinny Tables:** 자주 사용하는 필드를 담아 조인 회피(최대 100열, 다른 오브젝트 필드 불가).
- **Data Archiving:** 활성 오브젝트에서 오래된 데이터 제거.
- **Managing Data Skew:** 자식 레코드가 많은 레코드 회피(Account/Ownership/Lookup Skew). 워크플로우 대신 트리거, lookup 대신 picklist, 저부하 시간대 자동 업데이트 예약.
