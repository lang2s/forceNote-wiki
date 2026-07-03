---
tags: [admin, overview, hub, moc, salesforce-admin]
source: help.salesforce.com (Salesforce Help — Set Up and Maintain Your Salesforce Organization; 라이브 공식 문서, Tier 2, 접속 2026-07-03) + 위키 어드민 도메인 큐레이션
official_doc: https://help.salesforce.com/s/articleView?id=sf.setup.htm&type=5
created: 2026-07-03
aliases: [Salesforce Admin, 어드민 개요, 관리자 개요, Admin Overview, 어드민 종합, Setup, Salesforce 관리]
---

# Salesforce 어드민 종합 개요

> Salesforce 관리자가 알아야 할 8개 도메인(조직 설정·사용자/접근·보안·데이터·오브젝트/필드·UI·자동화·분석)의 진입 지도. 각 항목은 세부 노트로 연결된다.

---

## 개요

Salesforce 어드민은 조직 설정·사용자와 접근·보안·데이터·오브젝트/필드 커스터마이제이션·UI·자동화·분석을 코드 없이 클릭(선언적) 기반으로 관리한다. 이 노트는 그 전 영역을 한 장으로 묶은 지도이며, 세부 내용은 각 도메인 스포크 노트에 있다. 여기서는 링크 지도와 짧은 도메인 설명만 제공한다.

## 도메인 지도

```
// 구조 예시 — 어드민 도메인 지도(실제 원본 다이어그램 아님)
Salesforce Admin
├─ 조직 설정      회사정보·회계연도 · 영업시간/휴일 · 멀티통화 · 감사추적 · 네비 · 국가피클리스트
├─ 사용자·접근    Users · Roles/계층 · Public Groups · 위임관리 · OWD/공유  → 권한모델(Security)
├─ 보안          Session · Password · Login IP/시간 · Health Check · Field History · MFA
├─ 데이터        Data Loader · Import Wizard · Export/Storage · Mass Transfer/Delete · 중복/매칭
├─ 오브젝트·필드  Custom Object/Field · Formula · Roll-Up · Picklist · Custom Settings/Labels · Schema Builder · Record Type
├─ UI            App Builder/Pages · Apps/Tabs · Page/Compact Layout · List View · Quick/Global Action · Buttons/Links
├─ 자동화        Flow · Workflow(레거시)→Migrate · Approval · Email Alert/Template/Auto-Response
└─ 분석·이메일    Reports · Dashboards · Org-Wide Email/Deliverability
```

---

## 도메인별 노트

### 조직 설정
조직 전역 속성과 지역·시간·통화·감사 기반을 설정한다.

- [[Company Information & Fiscal Year (회사 정보·회계연도)]]
- [[Business Hours & Holidays (영업 시간·휴일)]]
- [[Multiple Currencies (멀티 통화)]]
- [[Setup Audit Trail (설정 감사 추적)]]
- [[Salesforce 네비게이션]]
- [[State and Country Picklist]]

### 사용자 관리 & 접근
사용자 계정과 역할 계층·그룹·위임을 통해 누가 무엇에 접근하는지를 관리한다.

- [[Users (사용자 관리)]]
- [[Roles & Role Hierarchy (역할·역할 계층)]]
- [[Public Groups (공개 그룹)]]
- [[Delegated Administration (위임 관리)]]
- [[조직 전체 공유 기본값(OWD)과 공유 규칙]]
- 권한(프로파일·권한 집합·오브젝트/FLS 등)은 → [[Salesforce 권한 모델 개요]] (Security 시리즈)

### 보안
로그인·세션·비밀번호·인증과 조직 보안 상태를 통제한다.

- [[Session Settings (세션 설정)]]
- [[Password Policies (비밀번호 정책)]]
- [[Login IP Ranges & Login Hours (로그인 IP·시간 제한)]]
- [[Security Health Check (보안 상태 점검)]]
- [[Field History Tracking (필드 이력 추적)]]
- [[Salesforce ID 인증]]

### 데이터 관리
데이터 적재·내보내기·대량 작업·품질(중복/매칭)을 다룬다.

- [[Data Loader]]
- [[Data Import Wizard]]
- [[Data Export & Storage (데이터 내보내기·스토리지)]]
- [[Mass Transfer & Mass Delete (대량 이전·삭제)]]
- [[Duplicate & Matching Rules (중복·매칭 규칙)]]

### 오브젝트·필드 커스터마이제이션
데이터 모델을 코드 없이 확장한다 — 오브젝트·필드·수식·피클리스트·레코드 타입.

- [[Custom Objects & Custom Fields (커스텀 오브젝트·필드)]]
- [[Formula 필드]]
- [[Roll-Up Summary 필드]]
- [[Picklists — Global Value Sets & Dependent Picklists (피클리스트)]]
- [[Custom Settings (커스텀 설정)]]
- [[Custom Labels (커스텀 레이블)]]
- [[Schema Builder (스키마 빌더)]]
- [[Record Types (레코드 타입)]]

### UI 커스터마이제이션
페이지·앱·레이아웃·리스트 뷰·액션·버튼으로 사용자 화면을 구성한다.

- [[Lightning App Builder & Pages (라이트닝 앱 빌더·페이지)]]
- [[Lightning Apps & Tabs (라이트닝 앱·탭)]]
- [[Page Layouts (페이지 레이아웃)]]
- [[Compact Layouts (컴팩트 레이아웃)]]
- [[List Views (리스트 뷰)]]
- [[Quick Actions & Global Actions (퀵 액션·글로벌 액션)]]
- [[Custom Buttons & Links (커스텀 버튼·링크)]]

### 자동화
선언적 자동화(Flow)와 레거시(Workflow/Approval)·이메일 자동화를 다룬다.

- [[Flow — 선언적 자동화 개요 (플로우)]] (심층 → [[Flow MOC]])
- [[Workflow Rules & Migrate to Flow (워크플로 규칙·플로우 이전)]]
- [[Approval Process (승인 프로세스)]]
- [[Email Alerts, Templates & Auto-Response Rules (이메일 알림·템플릿·자동 응답)]]

### 이메일 & 분석
조직 이메일 전달성과 리포트·대시보드 기반 분석을 다룬다.

- [[Organization-Wide Email Addresses & Deliverability (조직 전체 이메일·전달성)]]
- [[Reports (리포트)]]
- [[Dashboards (대시보드)]]

---

## 관련 노트
- [[Salesforce 권한 모델 개요]] — 권한·접근 제어 시리즈(프로파일·권한 집합·FLS 등)
- [[Salesforce 제품 클라우드 개요]] — Sales·Service·Data 등 클라우드 기능 지도
- [[Flow MOC]] — Flow 자동화 섹션 전체 목차
