---
tags: [admin, user-management, delegated-administration, security, least-privilege]
source: help.salesforce.com (Salesforce Help — Delegate Administrative Duties; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=sf.admin_delegate.htm&type=5
created: 2026-07-03
aliases: [Delegated Administration, 위임 관리, 위임 관리자, Delegated Admin, 부분 관리 권한]
---

# Delegated Administration (위임 관리)

> 전체 관리자 권한을 주지 않고 특정 관리 업무(지정 역할의 사용자 관리·permission set 할당·지정 커스텀 오브젝트 관리 등)만 비관리자에게 위임하는 기능. 최소 권한 원칙으로 관리 부담을 분산한다.

---

## 개념

Delegated administration은 **전체 "Manage Users" 권한이나 관리자 프로파일 없이**, 특정한 관리 업무만 비관리자(예: 부서 리드·팀 매니저)에게 위임하는 기능이다. 관리 부담을 분산하면서도 시스템 전체에 대한 광범위한 권한을 넘기지 않아 **최소 권한(least privilege)** 원칙을 지킬 수 있다.

예를 들어 영업 부서 매니저에게 "자기 부서 role 아래의 사용자만 생성·편집"할 수 있게 하면, 그는 전체 org의 모든 사용자를 볼 필요 없이 자기 팀원만 관리한다.

---

## delegated admin group이 할 수 있는 것

지정한 delegated admin group에는 다음과 같은 범위의 권한을 부여할 수 있다.

- **지정한 role(및 그 하위)의 사용자 생성·편집 관리** — group에 지정된 role과 그 하위 role에 속한 사용자에 한해 생성·편집한다.
- **지정한 profile / permission set 할당** — group에 지정된 profile·permission set만 사용자에게 할당할 수 있다.
- **지정한 커스텀 오브젝트 관리** — group에 지정된 커스텀 오브젝트를 관리한다.
- **지정 사용자로 로그인(log in as)** — 대상 사용자가 login access를 부여한 경우, 그 사용자로 로그인할 수 있다.

> 각 범위의 세부 제약(할당 가능한 profile 조건, role 하위 포함 규칙, 커스텀 오브젝트 권한 세분화 등)은 공식 문서에 위임한다 — [Delegate Administrative Duties](https://help.salesforce.com/s/articleView?id=sf.admin_delegate.htm&type=5).

---

## 설정

1. **Setup**을 연다.
2. Quick Find 상자에 **`Delegated Administration`** 을 입력한다.
3. **Delegated Administration**을 선택한다.
4. delegated admin group을 만들고, 위 4가지 권한 범위(관리할 role·할당 가능한 profile/permission set·관리할 커스텀 오브젝트)를 지정한다.

---

## 위임 범위 구조

```
// 구조 예시 — Delegated Administration(실제 원본 다이어그램 아님)
Delegated Admin Group (비관리자에게 부분 위임)
  ├─ 지정 Role(및 하위)의 User 생성·편집
  ├─ 지정 Profile / Permission Set 할당
  ├─ 지정 Custom Object 관리
  └─ (login access 부여 시) 해당 사용자로 로그인
전체 관리 권한 없이 최소 범위만 위임(least privilege)
```

---

## 관련 노트
- [[Users (사용자 관리)]] — 위임 대상 업무(사용자 생성·편집).
- [[Roles & Role Hierarchy (역할·역할 계층)]] — 위임 범위를 정하는 지정 role(및 하위)의 사용자를 관리.
- [[Permission Sets (권한 집합)]] — 위임 admin이 할당하는 권한 집합.
