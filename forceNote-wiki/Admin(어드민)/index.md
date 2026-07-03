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
| [[Users (사용자 관리)]] | 사용자 생성·deactivate(라이선스 반환)·freeze(로그인 차단) | #user-mgmt |
| [[Roles & Role Hierarchy (역할·역할 계층)]] | 레코드 접근 수직 상속(role≠profile) | #user-mgmt |
| [[Public Groups (공개 그룹)]] | 사용자·역할 묶음(공유 대상) | #user-mgmt |
| [[Delegated Administration (위임 관리)]] | 부분 관리 권한 위임 | #user-mgmt |
| [[Session Settings (세션 설정)]] | 세션 타임아웃·로그인 보안 수준(High Assurance)·IP 잠금 | #security |
| [[Password Policies (비밀번호 정책)]] | 복잡도·만료·이력·로그인 실패 잠금(프로파일 override) | #security |
| [[Login IP Ranges & Login Hours (로그인 IP·시간 제한)]] | 프로파일 IP 하드 거부 vs org Trusted IP 챌린지·로그인 시간 | #security |
| [[Security Health Check (보안 상태 점검)]] | 보안 설정 baseline 부합도 점수·위험 수정 | #security |
| [[Field History Tracking (필드 이력 추적)]] | 필드 변경 이력(최대 20필드·History 관련목록) | #security |

---

## 빠른 선택

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
- 사용자 생성·비활성화·동결(freeze)? → [[Users (사용자 관리)]]
- 역할 계층으로 레코드 접근 상속 설계? → [[Roles & Role Hierarchy (역할·역할 계층)]]
- 사용자·역할을 묶어 공유 대상 만들기? → [[Public Groups (공개 그룹)]]
- 부분 관리 권한을 다른 사용자에게 위임? → [[Delegated Administration (위임 관리)]]
- 세션 타임아웃·High Assurance 보안 수준 설정? → [[Session Settings (세션 설정)]]
- 비밀번호 복잡도·만료·계정 잠금 정책 설정? → [[Password Policies (비밀번호 정책)]]
- 로그인 IP·시간을 제한(프로파일 vs Trusted IP)? → [[Login IP Ranges & Login Hours (로그인 IP·시간 제한)]]
- 보안 설정을 baseline과 비교해 점수 확인? → [[Security Health Check (보안 상태 점검)]]
- 필드 변경 이력(이전·이후 값) 추적? → [[Field History Tracking (필드 이력 추적)]]
- Salesforce란 무엇인가? → [[Architecture(아키텍처)/Salesforce 플랫폼 개요]]

---

## 관련 폴더

- 플랫폼 개요 → [[Architecture(아키텍처)/index|Architecture(아키텍처)]]
- 보안 설계 → [[Apex/Security(보안)/index|Security(보안)]]
