---
tags: [index, search, navigation]
created: 2026-07-03
---

# SEARCH INDEX — Admin(어드민)
> 어드민 종합 지식 이니셔티브의 홈 샤드 — 조직 설정·사용자 관리·보안·데이터·UI·자동화 어드민 태스크 키워드 → 파일
> 루트 라우터: `00 SEARCH_INDEX.md` · 다른 샤드는 라우터에서 이동.
> 참고: 커스터마이제이션 세부(Formula·Roll-Up·Page Layout·Record Type·Data Loader·DIW·Approval 등)는 `_index/platform.md`, OWD/공유는 `_index/security.md`, Reports/Dashboards는 `_index/analytics.md`도 참조.

## 조직 설정 (Organization Setup)

| 키워드 | 파일 |
|---|---|
| Company Information, 회사 정보, Fiscal Year, 회계연도, org default, 조직 기본값, 회계연도 시작 월, locale, 언어, 통화, 라이선스, 스토리지, 표준 회계연도, 커스텀 회계연도 | `Admin(어드민)/Company Information & Fiscal Year (회사 정보·회계연도).md` |
| Business Hours, Holidays, 영업 시간, 휴일, 지원 시간, escalation 기준, 에스컬레이션 경과시간, 지원 시간 설정, 휴일 관리 | `Admin(어드민)/Business Hours & Holidays (영업 시간·휴일).md` |
| Multiple Currencies, 멀티 통화, multi-currency, corporate currency, 환율, dated exchange rate, 통화 관리, 멀티통화 비활성화 불가, 회사 통화 | `Admin(어드민)/Multiple Currencies (멀티 통화).md` |
| Setup Audit Trail, 설정 감사 추적, audit trail, 변경 이력, 감사, 누가 바꿨나, 설정 변경 이력, 누가 무엇을 언제 | `Admin(어드민)/Setup Audit Trail (설정 감사 추적).md` |

## 사용자 관리 (User Management)

| 키워드 | 파일 |
|---|---|
| Users, 사용자, 사용자 관리, deactivate, 비활성화, freeze, 동결, user license, 사용자 라이선스, 로그인 차단, 사용자 생성, 라이선스 반환 | `Admin(어드민)/Users (사용자 관리).md` |
| Roles, Role Hierarchy, 역할, 역할 계층, 레코드 접근, record access, role vs profile, 역할과 프로파일 차이, 수직 상속, 레코드 접근 확대 | `Admin(어드민)/Roles & Role Hierarchy (역할·역할 계층).md` |
| Public Groups, 공개 그룹, 공용 그룹, 그룹, sharing 대상, 공유 그룹, 사용자 역할 묶음, 공유 대상 그룹 | `Admin(어드민)/Public Groups (공개 그룹).md` |
| Delegated Administration, 위임 관리, delegated admin, 부분 관리 권한, 위임 관리자, 관리 권한 위임 | `Admin(어드민)/Delegated Administration (위임 관리).md` |

## 보안 설정 (Security Settings)

| 키워드 | 파일 |
|---|---|
| Session Settings, 세션 설정, session timeout, 세션 타임아웃, High Assurance, 세션 보안, 자동 로그아웃, 세션 보안 수준, IP 잠금, 로그인 보안 | `Admin(어드민)/Session Settings (세션 설정).md` |
| Password Policies, 비밀번호 정책, 암호 정책, lockout, 계정 잠금, 비밀번호 만료, 로그인 실패, 복잡도, 비밀번호 이력, 프로파일 override | `Admin(어드민)/Password Policies (비밀번호 정책).md` |
| Login IP Ranges, 로그인 IP 범위, Login Hours, 로그인 시간, Trusted IP, 신뢰 IP, Network Access, IP 제한, 프로파일 IP 하드 거부, org 챌린지, 로그인 시간 제한 | `Admin(어드민)/Login IP Ranges & Login Hours (로그인 IP·시간 제한).md` |
| Health Check, 보안 상태 점검, Security Health Check, baseline, 보안 점수, security score, 보안 baseline 부합도, 위험 수정 | `Admin(어드민)/Security Health Check (보안 상태 점검).md` |
| Field History Tracking, 필드 이력 추적, 필드 변경 추적, history related list, Field Audit Trail, 이전 이후 값, 최대 20필드, History 관련목록 | `Admin(어드민)/Field History Tracking (필드 이력 추적).md` |

## 데이터 관리 (Data Management)

| 키워드 | 파일 |
|---|---|
| Mass Transfer, 대량 이전, Mass Delete, 대량 삭제, 소유권 이전, 레코드 재배정, 대량 작업, 소유권 대량 이전, 레코드 대량 삭제 | `Admin(어드민)/Mass Transfer & Mass Delete (대량 이전·삭제).md` |
| Data Export, 데이터 내보내기, export service, 백업, storage, 스토리지, 용량, 주간 내보내기, 데이터 백업, 스토리지 사용량 | `Admin(어드민)/Data Export & Storage (데이터 내보내기·스토리지).md` |

## 오브젝트·필드 커스터마이제이션 (Objects & Fields Customization)

| 키워드 | 파일 |
|---|---|
| Custom Objects, 커스텀 오브젝트, Custom Fields, 커스텀 필드, Object Manager, __c, 오브젝트 만들기, 필드 추가, 커스텀 오브젝트 생성 | `Admin(어드민)/Custom Objects & Custom Fields (커스텀 오브젝트·필드).md` |
| Picklists, 피클리스트, Global Value Set, 전역 값 집합, Dependent Picklist, 종속 피클리스트, controlling field, field dependency, 필드 종속성 | `Admin(어드민)/Picklists — Global Value Sets & Dependent Picklists (피클리스트).md` |
| Custom Settings, 커스텀 설정, List Custom Setting, Hierarchy Custom Setting, 캐시 설정, 구성 데이터, 리스트 커스텀 설정, 계층 커스텀 설정 | `Admin(어드민)/Custom Settings (커스텀 설정).md` |
| Custom Labels, 커스텀 레이블, 사용자 정의 레이블, 번역, localization, 지역화, 번역 가능한 텍스트 | `Admin(어드민)/Custom Labels (커스텀 레이블).md` |
