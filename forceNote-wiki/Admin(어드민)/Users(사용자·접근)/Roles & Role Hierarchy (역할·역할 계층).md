---
tags: [admin, user-management, roles, role-hierarchy, record-access]
source: help.salesforce.com (Salesforce Help — Controlling Access Using the Role Hierarchy; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=platform.security_controlling_access_using_hierarchies.htm&type=5
created: 2026-07-03
aliases: [Roles, Role Hierarchy, 역할, 역할 계층, Record Access, 레코드 접근 상속]
---

# Roles & Role Hierarchy (역할·역할 계층)

> **Role Hierarchy**는 레코드 접근을 **수직으로** 연다 — 상위 역할 사용자는 하위(부하) 역할이 소유·공유받은 레코드에 자동 접근한다. Role은 "누가 누구의 레코드를 보나"(레코드 접근)를 정하고, Profile/Permission Set은 "무엇을 할 수 있나"(오브젝트/필드 권한)를 정한다.

---

## 정의 — 접근을 수직으로 개방

Role hierarchy는 레코드 접근을 **수직(vertically)으로 개방**한다. 계층에서 상위 역할에 배정된 사용자는 **하위(부하) 역할 사용자가 소유하거나 공유(sharing rule·수동 공유 등)받은 레코드에 자동 접근**한다.

예를 들어 **Sales Manager** 역할을 **Sales Rep** 역할 **위에** 두면, Sales Manager는 Sales Rep이 소유하거나 접근하는 모든 레코드에 자동으로 접근한다. 즉 계층은 위에서 아래를 내려다보는 방향으로만 접근을 넓히며, 접근은 상속되어 최상위(예: CEO)까지 누적된다.

## Role vs Profile — 두 개의 별개 축

역할과 프로파일/권한 세트는 **서로 다른 축**이며 혼동하면 안 된다.

| 축 | 담당 | 질문 |
|---|---|---|
| **Role** (역할) | 레코드 접근 — 계층 기반 수직 상속 | "누가 누구의 레코드를 보나" |
| **Profile / Permission Set** | 오브젝트·필드 권한, 시스템 권한 | "무엇을 할 수 있나" |

- **Role = 레코드 접근**: 계층을 통해 하위 소유·공유 레코드로 접근이 열린다.
- **Profile/Permission Set = 오브젝트/필드 권한 및 시스템 권한**: 어떤 오브젝트·필드를 읽고 편집할 수 있는지, 어떤 기능을 쓸 수 있는지를 정한다.

두 축은 독립적이므로, 같은 프로파일을 가진 두 사용자라도 역할이 다르면 접근 가능한 레코드 범위가 달라진다.

## Grant Access Using Hierarchies

조직 전체 공유 기본값(OWD)의 **Grant Access Using Hierarchies** 옵션이 계층을 통한 자동 접근을 켜고 끈다. 커스텀 오브젝트에서는 이 옵션을 **끌 수 있어** 계층 상속을 막을 수 있다(표준 오브젝트에서는 항상 켜져 있음).

> OWD·공유 모델과의 상호작용은 [[조직 전체 공유 기본값(OWD)과 공유 규칙]] 참조.

## 설정

- 사용자에게 **role을 배정**하고, **Setup → Roles / Role Hierarchy** 에서 role을 계층에 추가·편집한다.
- Role은 레코드 접근 외에도 **forecast(예측)** 와 **일부 리포트 계층**에도 사용된다.

## 구조

```
// 구조 예시 — Role Hierarchy(실제 원본 다이어그램 아님)
CEO
 └ Sales Manager  ← Sales Rep 소유/공유 레코드 자동 접근(수직 개방)
     └ Sales Rep
Role = 레코드 접근(수직 상속)  ≠  Profile/Permission Set = 오브젝트/필드 권한
제어: OWD의 "Grant Access Using Hierarchies"
```

## 관련 노트
- [[조직 전체 공유 기본값(OWD)과 공유 규칙]] — Grant Access Using Hierarchies·공유 모델
- [[Profiles (프로파일)]] — 권한 축(레코드 접근과 구분)
- [[Users (사용자 관리)]] — role을 배정받는 사용자
- [[Public Groups (공개 그룹)]] — 공유 규칙 대상(role과 함께)
