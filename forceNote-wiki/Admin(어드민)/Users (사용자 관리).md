---
tags: [admin, user-management, users, deactivate, freeze, user-license]
source: help.salesforce.com (Salesforce Help — Manage Users / Deactivate Users / Freeze User Accounts; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=sf.how_to_deactivate_users.htm&type=5
created: 2026-07-03
aliases: [Users, 사용자, 사용자 관리, Deactivate, 비활성화, Freeze, 계정 동결, User License, 사용자 라이선스]
---

# Users (사용자 관리)

> 로그인하는 각 사람이 user 레코드다. 생성 시 profile·role·user license를 배정한다. 사용자는 삭제하지 않고 **deactivate**(라이선스 반환)하거나 **freeze**(즉시 로그인 차단, 라이선스는 반환 안 함)한다.

---

## User 레코드

**User**는 조직에 로그인하는 각 사람의 레코드다. 위치는 **Setup → Users**. 사용자를 생성할 때 아래 세 가지를 배정한다.

| 배정 항목 | 결정하는 것 |
|---|---|
| **Profile** | 사용자가 가지는 **권한**(무엇을 할 수 있는가) |
| **Role** | 사용자의 **레코드 접근**(어떤 레코드를 볼 수 있는가) |
| **User License** | 사용 가능한 **기능**(예: Salesforce, Salesforce Platform 등) |

이 세 배정이 함께 사용자가 조직에서 무엇을 할 수 있고 어떤 데이터에 접근하는지를 규정한다.

---

## Deactivate (비활성화)

사용자는 **삭제할 수 없다.** 조직을 떠나거나 더 이상 접근이 필요 없는 사용자는 대신 **deactivate**한다.

- deactivate하면 그 사용자가 점유하던 **user license가 반환**되어 조직에서 **재사용**할 수 있다.
- 사용자를 완전히 제거하는 것이 아니라 로그인·접근을 막고 라이선스만 회수하는 방식이다(레코드는 남아 감사·이력 참조 가능).

> ⚠️ **일부 경우 즉시 deactivate가 불가능하다.** 예를 들어 해당 사용자가 **커스텀 hierarchy 필드에 선택**돼 있으면 그 참조를 정리하기 전까지 즉시 비활성화할 수 없다.

---

## Freeze / Unfreeze (동결·동결 해제)

deactivate를 준비하는 동안(예: 소유권 이전, 참조 정리) 사용자의 **로그인만 즉시 막고** 싶을 때 **freeze**한다.

- 경로: **Setup → Users → 사용자명 클릭 → Freeze**(차단) / **Unfreeze**(다시 허용).
- freeze는 로그인을 즉시 차단하지만 deactivate 전 준비 작업을 진행할 시간을 준다.

> ⚠️ **Freeze는 user license를 반환하지 않는다.** 로그인만 차단할 뿐이다. 라이선스를 비워 재사용하려면 반드시 **deactivate**해야 한다.

### Deactivate vs Freeze

| 구분 | 로그인 차단 | User License 반환 | 용도 |
|---|---|---|---|
| **Freeze** | ✅ 즉시 | ❌ 반환 안 함(라이선스 유지) | deactivate 준비 동안 임시로 접근 차단 |
| **Deactivate** | ✅ | ✅ 반환(재사용 가능) | 사용자가 조직을 떠날 때 |

---

## User License (사용자 라이선스)

**User license**는 사용자가 사용 가능한 기능을 결정한다. Salesforce / Salesforce Platform 등 라이선스 유형에 따라 접근 가능한 기능 범위가 달라진다. deactivate로 반환된 라이선스는 조직에서 다른 사용자에게 재배정할 수 있다.

---

## 상태 흐름 구조

```
// 구조 예시 — User 관리(실제 동작 코드 아님)
User 생성: Profile(권한) + Role(레코드 접근) + User License(기능)

상태:
  Active
    → Freeze   (로그인 차단, 라이선스 유지)
    → 준비 작업 (소유권 이전 · 참조 정리)
    → Deactivate (라이선스 반환 → 재사용 가능)

  ⚠️ 삭제 불가
  ⚠️ 커스텀 hierarchy 필드에 선택된 사용자는 즉시 deactivate 불가
```

---

## 관련 노트
- [[Profiles (프로파일)]] — 사용자에 배정하는 권한 그릇
- [[Roles & Role Hierarchy (역할·역할 계층)]] — 사용자에 배정하는 레코드 접근 역할
- [[Delegated Administration (위임 관리)]] — 지정 role 하위 사용자의 생성·편집을 비관리자에 위임
