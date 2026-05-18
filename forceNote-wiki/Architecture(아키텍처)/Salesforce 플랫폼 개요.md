---
tags: [architecture, salesforce-basics, platform, org, object, record, cloud]
source: basics.pdf
created: 2026-05-19
aliases: [Salesforce란, Salesforce 개요, Salesforce 플랫폼, Org, Object, Record, Salesforce 기초]
---

# Salesforce 플랫폼 개요

> Salesforce는 고객 성공 플랫폼으로, 클라우드 기반으로 판매·서비스·마케팅·분석·협업을 지원한다.

---

## 핵심 개념 정의

| 개념 | 정의 |
|---|---|
| **Org** (조직) | Salesforce의 단일 인스턴스. 회사 전용 데이터·설정·사용자를 포함하는 독립된 환경 |
| **Object** (오브젝트) | 데이터베이스 테이블에 해당. 표준(Account, Contact 등)과 커스텀(Expense__c 등)으로 구분 |
| **Record** (레코드) | Object의 단일 인스턴스 (테이블의 행). 예: 특정 Account 하나 |
| **Field** (필드) | Record의 속성 (테이블의 열). 예: Account.Name, Account.Phone |
| **App** (앱) | 특정 업무를 위한 탭·기능 묶음. App Launcher에서 전환 가능 |
| **Tab** | Object 또는 웹 페이지에 대한 링크. 네비게이션바에 표시 |
| **Cloud** | 특정 업무 유형을 지원하는 기능 묶음의 이름 (예: Sales Cloud, Service Cloud) |

---

## 주요 Cloud 종류

```
// 구조 예시 — 실제 동작 코드 아님
Salesforce 플랫폼
├── Sales Cloud       — 리드, 기회, 견적, 영업 프로세스
├── Service Cloud     — 케이스, 옴니채널, Knowledge, 고객 지원
├── Experience Cloud  — 파트너/고객 포털, 커뮤니티
├── Marketing Cloud   — 이메일·SMS 마케팅 자동화
├── Data Cloud        — 실시간 데이터 통합·분석 플랫폼
├── Agentforce        — AI 에이전트 플랫폼 (Apex/Flow로 호출 가능)
└── Platform          — Apex, LWC, Flow, API — 커스텀 개발 레이어
```

---

## 표준 Object 주요 목록

| Object | API 이름 | 용도 |
|---|---|---|
| Account | `Account` | 거래처 (회사/개인) |
| Contact | `Contact` | 연락처 (사람) |
| Lead | `Lead` | 잠재 고객 |
| Opportunity | `Opportunity` | 영업 기회 |
| Case | `Case` | 고객 지원 케이스 |
| User | `User` | Salesforce 사용자 |
| Task | `Task` | 할 일 (활동) |
| Event | `Event` | 일정 (활동) |

---

## Org 구조 계층

```
// 구조 예시 — 실제 동작 코드 아님
Org
├── Profiles / Permission Sets — 사용자 권한 제어
├── Apps
│   └── Tabs
│       └── Object (표준/커스텀)
│           ├── Fields (표준/커스텀)
│           ├── Record Types
│           ├── Validation Rules
│           └── Page Layouts
└── Automation
    ├── Flow
    ├── Process Builder (레거시)
    └── Apex Triggers
```

---

## 개발자가 알아야 할 환경 종류

| 환경 | 용도 |
|---|---|
| **Production** | 실 운영 환경 |
| **Sandbox** (Developer/Developer Pro/Partial/Full) | 개발·테스트 환경 |
| **Developer Edition (DE)** | 무료 개발 전용 org. Agentforce + Data Cloud 포함(Spring '25+) |
| **Scratch Org** | 단기 개발·CI용 임시 org (SFDX) |
| **Trailhead Playground** | Trailhead 학습용 무료 org |

---

## 관련 노트

- [[Admin(어드민)/Salesforce 네비게이션]] — Lightning Experience 화면 구조
- [[Admin(어드민)/Salesforce ID 인증]] — MFA 인증 설정
- [[Architecture(아키텍처)/서비스 레이어 패턴]] — 개발 아키텍처 패턴
- [[Apex/Security(보안)/index]] — 권한 설계
