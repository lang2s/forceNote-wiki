---
tags: [index, admin, salesforce-basics]
created: 2026-05-19
---

# Admin(어드민) — 로컬 인덱스

> Salesforce 플랫폼 기초 — 어드민·개발자가 알아야 할 핵심 개념, 네비게이션, 보안 인증

**상위:** [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| 🗺️ [[Salesforce 어드민 종합 개요]] | **어드민 전체 지도** — 8개 도메인(조직 설정·사용자/접근·보안·데이터·오브젝트/필드·UI·자동화·분석) 43노트를 묶는 진입점. 무엇부터 볼지 여기서 시작 | #overview #hub |
| [[Salesforce 네비게이션]] | App Launcher, 탐색바, 전역 검색, 리스트뷰, 레코드 페이지 구조 | #navigation |
| [[Salesforce ID 인증]] | MFA, Authenticator App, 인증 방식 종류와 설정 | #security |
| [[Data Loader]] | CSV 대량 insert/update/upsert/delete/export, Bulk API, CLI 배치(Windows), 최대 1.5억 건 | #data |
| [[Data Import Wizard]] | Setup 웹 마법사 — 표준/커스텀 오브젝트 CSV 임포트(추가·업데이트·중복 매칭), 최대 5만 건, Data Loader의 웹 보완재 | #data |
| [[State and Country Picklist]] | AddressSettings 메타데이터 타입 — 국가/주 피클리스트 구성, isoCode/integrationValue, Metadata API 편집 | #metadata-api |
| [[조직 전체 공유 기본값(OWD)과 공유 규칙]] | OWD로 레코드 기본 접근 수준을 정하고 공유 규칙(소유 기반/기준 기반)으로 접근 확대, Sharing Settings 설정법 | #security |
| [[Approval Process (승인 프로세스)]] | 레코드 승인 단계·승인자·시점별 자동 액션을 정의하는 선언적 승인 워크플로 — Jump Start/Standard 마법사, 용어 15종, 액션 4타입, Flow 대안 | #automation |
| [[Formula 필드]] | 다른 필드로부터 값을 자동 계산하는 read-only 커스텀 필드 — cross-object formula(최대 10관계), Check Syntax, 계산 필드 | #customization |
| [[Roll-Up Summary 필드]] | master-detail의 master측에서 detail 레코드를 COUNT/SUM/MIN/MAX로 집계하는 필드 | #customization |
| [[Page Layouts (페이지 레이아웃)]] | 레코드 페이지의 버튼·필드·관련목록 배치 제어 — enhanced editor, mini layout, 프로파일×레코드타입 할당 | #customization |
| [[Record Types (레코드 타입)]] | 사용자별 다른 비즈니스 프로세스·피클리스트 값·페이지 레이아웃 제공 — sales/support process, 레코드 타입 할당 | #customization |
| [[Duplicate & Matching Rules (중복·매칭 규칙)]] | Matching Rule(무엇이 중복)+Duplicate Rule(발견 시 Allow/Block/Report) — 데이터 품질·중복 방지 | #data-quality |
| [[Schema Builder (스키마 빌더)]] | 오브젝트·관계를 시각적으로 보고 드래그앤드롭으로 커스텀 오브젝트·필드·관계 추가 — 데이터 모델 ERD | #customization |
| [[Reports (리포트)]] | Report Builder로 데이터를 조회·분석 — Report Type·Format(tabular/summary/matrix/joined) | #analytics |
| [[Dashboards (대시보드)]] | report 데이터를 chart·gauge·metric·table·Visualforce 컴포넌트로 시각화 — dynamic dashboard | #analytics |
| [[Company Information & Fiscal Year (회사 정보·회계연도)]] | 조직 기본값(locale·언어·통화)·라이선스·스토리지·회계연도(표준/커스텀) | #org-setup |
| [[Business Hours & Holidays (영업 시간·휴일)]] | 지원 시간·휴일(에스컬레이션 경과시간 기준) | #org-setup |
| [[Multiple Currencies (멀티 통화)]] | 멀티통화(영구·비활성화 불가)·환율·corporate currency | #org-setup |
| [[Setup Audit Trail (설정 감사 추적)]] | 설정 변경 이력(누가·무엇·언제) | #org-setup |
| [[Release Updates 처리 (테스트 실행·기한 활성화)]] | Salesforce가 강제 적용하는 org 변경(Critical Updates 후신)을 Setup에서 처리 — Test Run 검증·Complete Steps By 기한·Get Started 라이프사이클 | #org-ops |
| [[System Overview & Salesforce Optimizer (조직 사용량·최적화 진단)]] | 조직 사용량·한도 진단 두 도구 — System Overview(실시간 사용량 카드)+Salesforce Optimizer(정리·최적화 스캔 리포트) | #org-ops #monitoring |
| [[Installed Packages 관리 (구독자 어드민 관점)]] | 구독자 org 어드민의 설치 패키지 조회·Manage Licenses(seat 할당)·업그레이드·Uninstall·데이터 export (퍼블리셔 배포 관점은 2GP로 위임) | #org-ops #packages |
| [[Users (사용자 관리)]] | 사용자 생성·deactivate(라이선스 반환)·freeze(로그인 차단) | #user-mgmt |
| [[Roles & Role Hierarchy (역할·역할 계층)]] | 레코드 접근 수직 상속(role≠profile) | #user-mgmt |
| [[Public Groups (공개 그룹)]] | 사용자·역할 묶음(공유 대상) | #user-mgmt |
| [[Delegated Administration (위임 관리)]] | 부분 관리 권한 위임 | #user-mgmt |
| [[User Access Policies (사용자 액세스 정책)]] | 사용자에게 권한집합·그룹·라이선스를 규칙 기반 자동 프로비저닝(grant/revoke)·대량 온보딩 | #user-mgmt |
| [[User Management Settings · Login Access Policies (사용자 관리 설정·로그인 대행)]] | 사용자 관리 상위 토글(Enhanced Profile UI 등)·관리자/지원사 로그인 대행 정책(log in as) | #user-mgmt |
| [[User Licenses · Permission Set Licenses · Feature Licenses (라이선스 유형)]] | User(1개 배타)·PSL·Feature(가산) 3층 라이선스 — 유형·여는 기능·소진 확인 | #user-mgmt #license |
| [[Session Settings (세션 설정)]] | 세션 타임아웃·로그인 보안 수준(High Assurance)·IP 잠금 | #security |
| [[Password Policies (비밀번호 정책)]] | 복잡도·만료·이력·로그인 실패 잠금(프로파일 override) | #security |
| [[Login IP Ranges & Login Hours (로그인 IP·시간 제한)]] | 프로파일 IP 하드 거부 vs org Trusted IP 챌린지·로그인 시간 | #security |
| [[Security Health Check (보안 상태 점검)]] | 보안 설정 baseline 부합도 점수·위험 수정 | #security |
| [[Field History Tracking (필드 이력 추적)]] | 필드 변경 이력(최대 20필드·History 관련목록) | #security |
| [[Login History & Email Log Files (로그인·이메일 감사 로그)]] | 로그인 이력(20000·6개월)·이메일 로그 — 누가 로그인했나/이 메일이 전달됐나 | #monitoring |
| [[작업 모니터링 (Scheduled Jobs · Apex Jobs · Flex Queue · Bulk Data Load)]] | Setup 작업 모니터링 5화면(예약·Apex·Flex Queue·Background·Bulk Data Load)·잡 중단(Abort) | #monitoring |
| [[Mass Transfer & Mass Delete (대량 이전·삭제)]] | 소유권 대량 이전·레코드 대량 삭제 | #data |
| [[Data Export & Storage (데이터 내보내기·스토리지)]] | 데이터 export 서비스(백업)·스토리지 사용량 | #data |
| [[Data Protection & Privacy (개인정보 보호·동의 관리)]] | Individual·Consent 오브젝트군으로 프라이버시 선호·채널별 동의 추적(GDPR/CCPA·RtbF) | #data #privacy |
| [[Custom Objects & Custom Fields (커스텀 오브젝트·필드)]] | Object Manager로 커스텀 오브젝트·필드 생성 | #customization |
| [[Picklists — Global Value Sets & Dependent Picklists (피클리스트)]] | 피클리스트·전역 값 집합·종속 피클리스트 | #customization |
| [[Custom Settings (커스텀 설정)]] | List vs Hierarchy 커스텀 설정(캐시 접근) | #customization |
| [[Custom Labels (커스텀 레이블)]] | 번역 가능한 커스텀 텍스트 | #customization |
| [[Field Sets (필드 집합)]] | 필드를 논리적으로 묶어 UI(VF·LWC·Apex)가 참조 — 관리자가 필드셋에 추가/제거만으로 코드 수정 없이 화면 노출 필드 변경 | #customization |
| [[Lookup Filters (룩업 필터)]] | 관계 필드(lookup·master-detail)에서 후보 레코드를 조건으로 제한 — Required/Optional·$Source·종속 룩업·참조 무결성 | #customization |
| [[Object & Field Limits (오브젝트·필드 한도)]] | 에디션별 정적 설정 한도(오브젝트당 커스텀 필드 900·관계 40·Roll-Up 25 등) — 한도 수치 레퍼런스 | #customization #reference |
| [[필드 타입 선택 가이드 (어드민 빌드 관점)]] | 커스텀 필드를 만들 때 어떤 타입을 고르나 — 용도·크기·변경 제약(전환 데이터 손실·인덱싱·Encrypted) 결정 가이드 | #customization #decision-guide |
| [[Lightning App Builder & Pages (라이트닝 앱 빌더·페이지)]] | 커스텀 페이지(App/Home/Record) 조립·활성화(FlexiPage) | #ui-customization |
| [[Lightning Apps & Tabs (라이트닝 앱·탭)]] | App Manager로 앱 구성·탭 4유형·유틸리티 바 | #ui-customization |
| [[List Views (리스트 뷰)]] | 필터 목록·버튼 레이아웃·Kanban·mass quick action | #ui-customization |
| [[Quick Actions & Global Actions (퀵 액션·글로벌 액션)]] | object-specific vs global 액션·글로벌 퍼블리셔 레이아웃 | #ui-customization |
| [[Compact Layouts (컴팩트 레이아웃)]] | 하이라이트 패널 핵심 필드(모바일 카드) | #ui-customization |
| [[Custom Buttons & Links (커스텀 버튼·링크)]] | URL·Visualforce 버튼·링크(JS 레거시) | #ui-customization |
| [[New Button or Link & Action 생성 가이드 (타입·설정·예시)]] | 커스텀 버튼·링크 생성(Display Type·Behavior·Content Source·Window Open Properties·merge field)+Action Type 생성 심층 how-to | #ui-customization |
| [[In-App Guidance — 프롬프트·워크스루 (사용자 온보딩)]] | 인앱 프롬프트·워크스루로 사용자 온보딩·기능 도입 — Prompt 메타데이터(displayType/Targeted·Docked·Floating)·targetPage·uiFormulaRule·프로필별 표시·delayDays/timesToDisplay | #ui-customization |
| [[User Interface Settings (사용자 인터페이스 설정)]] | Setup의 User Interface 페이지 — org 전역 UI 동작(인라인 편집·호버 상세·향상된 리스트·섹션 접기 등) 22종 토글. "왜 이 UI 기능이 안 되나"의 첫 진입점 | #ui-customization |
| [[Search Settings & Search Layouts (검색 설정·검색 레이아웃)]] | Search Settings(org 전역 검색 동작·향상된 조회)+Search Layouts(오브젝트별 검색 결과·조회 대화상자 열·필터·버튼) | #ui-customization |
| [[Path (경로 가이드)]] | 레코드 페이지 상단 단계(step) 가이드 — picklist 값을 단계로 펼치고 Key Fields·Guidance for Success·Celebration 제공 | #ui-customization |
| [[Themes and Branding & Rename Tabs and Labels (테마·브랜딩·라벨 변경)]] | LEX org에 브랜드 테마(색·로고·배경) 적용 + 표준 오브젝트·탭·필드 화면 라벨을 조직 용어로 변경(Account→거래처) | #ui-customization |
| [[Utility Bar · App Menu · Console Navigation (유틸리티 바·앱 메뉴·콘솔 네비)]] | Lightning App의 Utility Bar(하단 유틸리티 footer)·App Navigation(Standard vs Console)·Console Navigation & Split View(workspace 탭·subtab) 심화 | #ui-customization |
| [[Translation Workbench & Language Settings (번역 워크벤치·언어 설정)]] | 다국어 org 현지화 두 축 — Language Settings(허용 언어·지원 등급)+Translation Workbench(커스텀 메타데이터 라벨 번역·재정의). Custom Label 번역의 선행 전제 | #ui-customization #localization |
| [[Flow — 선언적 자동화 개요 (플로우)]] | 주력 선언적 자동화 유형 개요(Flow MOC 위임) | #automation |
| [[Workflow Rules & Migrate to Flow (워크플로 규칙·플로우 이전)]] | 레거시 워크플로·Migrate to Flow 이전 | #automation |
| [[Email Alerts, Templates & Auto-Response Rules (이메일 알림·템플릿·자동 응답)]] | 이메일 발송 액션·템플릿·자동 회신 규칙 | #automation |
| [[Organization-Wide Email Addresses & Deliverability (조직 전체 이메일·전달성)]] | 공통 발신 주소·발송 전달성·이메일 인증 | #email |
| [[이메일 전달성 인프라 (Deliverability · DKIM · Email Relay · Bounce)]] | 발신 인증·전달성 인프라 심화 — DKIM 서명(스푸핑 방지)·Email Relay(회사 SMTP 경유)·Bounce 관리·Test Deliverability(IP 차단 진단)·Compliance BCC·Footer | #email |
| [[Letterheads · Mail Merge · Email to Salesforce (Classic 이메일 도구)]] | Classic 이메일 3대 도구 — Letterhead(HTML 템플릿 브랜딩)·Mail Merge(Word 데이터 병합)·Email to Salesforce(외부 메일 활동 자동 로깅). 각 Lightning 대안 병기 | #email #legacy |
| [[Custom Notification Types (알림 유형·Notification Builder)]] | Notification Builder로 커스텀 알림 유형을 선언적 정의(채널·API 이름)+Notification Delivery Settings로 유형별 전달 채널 제어. 발송 코드는 Flow/Apex 위임 | #automation #notification |
| [[Process Automation Settings (프로세스 자동화 설정)]] | org 전체 Flow·Process·Workflow 동작을 한 페이지에서 제어 — 기본 워크플로 사용자·Flow/Process 오류 이메일 수신자·인터뷰 일시정지/공유 재개·enhanced Flows 페이지 | #automation |

---

## 빠른 선택

- 🗺️ **어드민 전체를 어디서부터 볼지 모르겠다? → [[Salesforce 어드민 종합 개요]]** (8도메인 진입 지도)
- Lightning Experience 화면 구조 이해? → [[Salesforce 네비게이션]]
- MFA 설정 방법? → [[Salesforce ID 인증]]
- 대량 데이터 적재·내보내기? → [[Data Loader]]
- 웹 마법사로 CSV 데이터 임포트(최대 5만 건)? → [[Data Import Wizard]]
- OWD·공유 규칙으로 레코드 접근 설계? → [[조직 전체 공유 기본값(OWD)과 공유 규칙]]
- 레코드 승인 워크플로(단계·승인자·자동 액션) 만들기? → [[Approval Process (승인 프로세스)]]
- 국가/주 피클리스트를 메타데이터로 설정? → [[State and Country Picklist]]
- 다른 필드로 값을 자동 계산하는 필드? → [[Formula 필드]]
- 자식 레코드를 COUNT/SUM/MIN/MAX로 집계? → [[Roll-Up Summary 필드]]
- 레코드 페이지에 버튼·필드·관련목록 배치? → [[Page Layouts (페이지 레이아웃)]]
- 사용자별 다른 비즈니스 프로세스·레이아웃? → [[Record Types (레코드 타입)]]
- 중복 레코드 방지·매칭 규칙 설정? → [[Duplicate & Matching Rules (중복·매칭 규칙)]]
- 오브젝트·관계를 시각적으로 설계? → [[Schema Builder (스키마 빌더)]]
- 데이터를 조회·분석하는 리포트 만들기? → [[Reports (리포트)]]
- 리포트 데이터를 차트·게이지로 시각화? → [[Dashboards (대시보드)]]
- 조직 기본값·라이선스·회계연도 설정? → [[Company Information & Fiscal Year (회사 정보·회계연도)]]
- 지원 시간·휴일(에스컬레이션 기준) 설정? → [[Business Hours & Holidays (영업 시간·휴일)]]
- 멀티통화·환율·회사 통화 관리? → [[Multiple Currencies (멀티 통화)]]
- 설정을 누가·언제 바꿨는지 추적? → [[Setup Audit Trail (설정 감사 추적)]]
- Salesforce 릴리스 업데이트를 Test Run으로 검증하고 기한(Complete Steps By) 전에 처리? → [[Release Updates 처리 (테스트 실행·기한 활성화)]]
- 조직 사용량·한도를 진단하거나 정리·최적화 리포트를 받기? → [[System Overview & Salesforce Optimizer (조직 사용량·최적화 진단)]]
- 설치된 패키지를 조회·라이선스 할당(Manage Licenses)·업그레이드·제거(Uninstall)? → [[Installed Packages 관리 (구독자 어드민 관점)]]
- 사용자 생성·비활성화·동결(freeze)? → [[Users (사용자 관리)]]
- 역할 계층으로 레코드 접근 상속 설계? → [[Roles & Role Hierarchy (역할·역할 계층)]]
- 사용자·역할을 묶어 공유 대상 만들기? → [[Public Groups (공개 그룹)]]
- 부분 관리 권한을 다른 사용자에게 위임? → [[Delegated Administration (위임 관리)]]
- 세션 타임아웃·High Assurance 보안 수준 설정? → [[Session Settings (세션 설정)]]
- 비밀번호 복잡도·만료·계정 잠금 정책 설정? → [[Password Policies (비밀번호 정책)]]
- 로그인 IP·시간을 제한(프로파일 vs Trusted IP)? → [[Login IP Ranges & Login Hours (로그인 IP·시간 제한)]]
- 보안 설정을 baseline과 비교해 점수 확인? → [[Security Health Check (보안 상태 점검)]]
- 필드 변경 이력(이전·이후 값) 추적? → [[Field History Tracking (필드 이력 추적)]]
- 누가 로그인했는지 이력을 조회·다운로드하거나 보낸 메일 전달을 확인? → [[Login History & Email Log Files (로그인·이메일 감사 로그)]]
- 예약 작업·Apex 잡·Flex Queue·Bulk 로드 잡을 Setup에서 모니터링·중단(Abort)? → [[작업 모니터링 (Scheduled Jobs · Apex Jobs · Flex Queue · Bulk Data Load)]]
- 소유권을 대량 이전하거나 레코드를 대량 삭제? → [[Mass Transfer & Mass Delete (대량 이전·삭제)]]
- 데이터를 백업(export)하거나 스토리지 사용량 확인? → [[Data Export & Storage (데이터 내보내기·스토리지)]]
- GDPR/CCPA 대응으로 개인정보 선호·동의(Consent)·잊혀질 권리(RtbF)를 관리? → [[Data Protection & Privacy (개인정보 보호·동의 관리)]]
- Object Manager로 커스텀 오브젝트·필드 만들기? → [[Custom Objects & Custom Fields (커스텀 오브젝트·필드)]]
- 피클리스트·전역 값 집합·종속 피클리스트 설정? → [[Picklists — Global Value Sets & Dependent Picklists (피클리스트)]]
- List/Hierarchy 커스텀 설정으로 구성 데이터를 캐시 접근? → [[Custom Settings (커스텀 설정)]]
- 번역 가능한 텍스트를 커스텀 레이블로 관리? → [[Custom Labels (커스텀 레이블)]]
- 코드 수정 없이 화면 노출 필드를 필드 묶음으로 관리? → [[Field Sets (필드 집합)]]
- 관계 필드에서 선택 가능한 후보 레코드를 조건으로 제한? → [[Lookup Filters (룩업 필터)]]
- 오브젝트당 커스텀 필드·관계·Roll-Up 한도 수치 확인? → [[Object & Field Limits (오브젝트·필드 한도)]]
- 커스텀 필드를 만들 때 어떤 타입을 골라야 하나? → [[필드 타입 선택 가이드 (어드민 빌드 관점)]]
- 커스텀 페이지(App/Home/Record)를 조립·활성화? → [[Lightning App Builder & Pages (라이트닝 앱 빌더·페이지)]]
- App Manager로 앱·탭·유틸리티 바 구성? → [[Lightning Apps & Tabs (라이트닝 앱·탭)]]
- 리스트 뷰 필터·버튼 레이아웃·mass quick action 설정? → [[List Views (리스트 뷰)]]
- object-specific/global 퀵 액션 만들기? → [[Quick Actions & Global Actions (퀵 액션·글로벌 액션)]]
- 하이라이트 패널에 핵심 필드 노출? → [[Compact Layouts (컴팩트 레이아웃)]]
- URL·Visualforce 커스텀 버튼·링크 추가? → [[Custom Buttons & Links (커스텀 버튼·링크)]]
- 인앱 프롬프트·워크스루로 사용자 온보딩·기능 안내? → [[In-App Guidance — 프롬프트·워크스루 (사용자 온보딩)]]
- 인라인 편집·호버 상세 등 org 전역 UI 토글을 켜고 끄기(왜 이 UI 기능이 안 되나)? → [[User Interface Settings (사용자 인터페이스 설정)]]
- 검색 결과·조회 대화상자에 어떤 열이 나오게 하거나 검색 동작 설정? → [[Search Settings & Search Layouts (검색 설정·검색 레이아웃)]]
- 레코드 페이지 상단에 단계(step) 가이드·핵심 필드·성공 안내 제공? → [[Path (경로 가이드)]]
- org에 브랜드 테마(색·로고)를 입히거나 오브젝트·탭·필드 라벨을 조직 용어로 변경? → [[Themes and Branding & Rename Tabs and Labels (테마·브랜딩·라벨 변경)]]
- Lightning 앱에 유틸리티 바를 넣거나 콘솔 네비게이션·분할 보기를 구성? → [[Utility Bar · App Menu · Console Navigation (유틸리티 바·앱 메뉴·콘솔 네비)]]
- 다국어 org에서 허용 언어를 정하고 커스텀 라벨을 번역(번역 워크벤치)? → [[Translation Workbench & Language Settings (번역 워크벤치·언어 설정)]]
- 커스텀 알림 유형을 정의해 데스크톱·모바일로 발송? → [[Custom Notification Types (알림 유형·Notification Builder)]]
- 선언적 자동화(Flow) 유형 개요를 알고 싶다면? → [[Flow — 선언적 자동화 개요 (플로우)]]
- 레거시 워크플로를 Flow로 이전? → [[Workflow Rules & Migrate to Flow (워크플로 규칙·플로우 이전)]]
- 이메일 알림·템플릿·자동 응답 규칙 설정? → [[Email Alerts, Templates & Auto-Response Rules (이메일 알림·템플릿·자동 응답)]]
- 조직 전체 발신 주소·이메일 전달성 관리? → [[Organization-Wide Email Addresses & Deliverability (조직 전체 이메일·전달성)]]
- 이메일이 스팸으로 분류되지 않게 DKIM·Email Relay·반송(Bounce)을 설정? → [[이메일 전달성 인프라 (Deliverability · DKIM · Email Relay · Bounce)]]
- Classic 레터헤드·메일 머지·Email to Salesforce(외부 메일 자동 로깅)? → [[Letterheads · Mail Merge · Email to Salesforce (Classic 이메일 도구)]]
- 기본 워크플로 사용자·Flow 오류 이메일 수신자 등 org 자동화 설정? → [[Process Automation Settings (프로세스 자동화 설정)]]
- Salesforce란 무엇인가? → [[Architecture(아키텍처)/Salesforce 플랫폼 개요]]

---

## 관련 폴더

- 플랫폼 개요 → [[Architecture(아키텍처)/index|Architecture(아키텍처)]]
- 보안 설계 → [[Apex/Security(보안)/index|Security(보안)]]
