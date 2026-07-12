---
tags: [admin, user-management, user-access-policies, permission-sets, provisioning, onboarding]
source: help.salesforce.com (Salesforce Help — User Access Policies / User Access Policy Considerations / Enable User Access Policies; 라이브 공식 문서, Tier 2, 접속 2026-07-11)
official_doc: https://help.salesforce.com/s/articleView?id=platform.perm_user_access_policies.htm&type=5
created: 2026-07-11
aliases: [User Access Policies, 사용자 액세스 정책, UAP, 사용자 프로비저닝 자동화, User Access Policy, 액세스 자동 할당]
---

# User Access Policies (사용자 액세스 정책)

> 신규·변경 사용자에게 permission set·permission set group·라이선스·public group·queue 멤버십을 **규칙 기반으로 자동 프로비저닝/디프로비저닝**하는 기능. 대량 온보딩·액세스 마이그레이션을 단일 작업으로 처리한다. (GA: Summer '24)

---

## 개념

User Access Policies(UAP)는 **여러 사용자에게 부여할 액세스를 단일 작업으로 정의**하는 기능이다. 공식 정의: *"With user access policies, you define aggregated access for your users in a single operation."*

전통적으로 각 사용자에게 permission set을 개별 할당하거나, 부서 이동·입사 때마다 수동으로 액세스를 조정해야 했다. UAP는 **사용자 조건(criteria)에 매칭되는 사용자에게 액세스 항목을 자동으로 부여(grant)하거나 회수(revoke)**해, 대량 온보딩과 액세스 마이그레이션을 규칙으로 자동화한다.

- **Edition:** Enterprise · Unlimited 에디션.
- **GA 이력:** Spring '24 베타(release 244) → **Summer '24 정식 GA**. Winter '25(release 248)에서 picklist·group·queue를 조건에 참조하는 기능 등 조건 확장.

> [!note] 재활성화 주의
> Salesforce가 **Summer '23 이전**에 UAP를 활성화해 준 조직은 User Management Settings 페이지에서 **이 기능을 다시 활성화**해야 한다.

---

## 부여/회수할 수 있는 액세스 항목

정책의 access grant(부여) 및 revoke(회수) 액션으로 관리할 수 있는 대상:

| 항목 | 설명 |
|---|---|
| **Permission Sets** | 개별 권한 집합 |
| **Permission Set Groups** | 권한 집합 그룹 |
| **Permission Set Licenses** | 권한 집합 라이선스 |
| **Package Licenses** (managed package licenses) | 관리 패키지 라이선스 |
| **Public Groups** | 공개 그룹 멤버십 |
| **Queues** | 큐 멤버십 |

부여(grant)와 회수(revoke) 액션을 **둘 다** 제공하므로, 신규 사용자 프로비저닝뿐 아니라 **기존 액세스의 대량 마이그레이션**(예: 구 permission set 회수 + 신 permission set 부여)도 한 정책으로 가능하다.

---

## 구성 요소 — User Criteria + Access Grants

### User Criteria (사용자 조건)
정책이 대상 사용자를 식별하는 필터. 사용자 속성 기반(user attribute-based, 예: role·department·profile) 또는 사용자 엔타이틀먼트 기반(user entitlement-based) 조건을 지정한다. Winter '25부터 picklist 값·public group·queue를 조건에 참조할 수 있다.

### Access Grants (액세스 부여/회수)
조건에 매칭된 사용자에게 적용할 액션. 위 6종 항목의 assign(부여)·remove(회수)를 설정한다.

---

## 정책 실행 모드 — Manual vs Active

| 모드 | 트리거 | 동작 |
|---|---|---|
| **Manual (기본)** | 관리자가 수동 실행 | 일회성 프로세스. 대상 사용자가 많으면 **비동기(asynchronous)**로 실행된다. 대량 마이그레이션에 사용. |
| **Active (자동)** | 사용자 레코드 **생성/수정** 이벤트 | *"An active user access policy automatically runs off a triggered event, such as a created or updated user record."* 조건에 새로 매칭되면 자동 부여/회수. |

```text
// 구조 예시 — 실제 정책 설정 화면 아님
[User Access Policy]
  User Criteria:  Department = "Sales"  AND  Profile = "Standard User"
  Access Grants (Grant):   PermissionSetGroup = "Sales_Rep_PSG"
                           Queue             = "Inbound_Leads"
  Access Grants (Revoke):  PermissionSet     = "Legacy_Sales_PS"
  Status: Active   Order: 10
  → 사용자 레코드 생성/수정 시 Department가 "Sales"로 바뀌면 자동 적용
```

### Active 정책의 적용 규칙 (Considerations)

- **기존 사용자 적용 시점:** Active 정책은 기존 사용자에게 **레코드가 수정되어 조건에 새로 매칭될 때만** 적용된다. 이미 조건을 충족 중인 사용자에게 소급 적용되지 않는다. (예: department 필터가 있으면, department가 조건 값으로 *바뀌는* 순간에만 적용. 처음부터 그 값이던 사용자는 미적용)
- **다중 정책 충돌:** 한 생성/수정 이벤트가 여러 정책을 트리거하면 **Order 값이 가장 낮은 정책이 적용**된다.
- **비재귀:** *"An action performed by a user access policy can't trigger another user access policy."* — 정책 액션이 다른 정책을 연쇄 트리거하지 않는다.
- **Public group / queue 조건 한계:** 조건이 public group·queue를 대상으로 하면, 그 그룹/큐에 **직접(directly) 추가된 개별 사용자에게만** 적용된다. role·territory·nested public group 경유로 추가된 사용자는 제외된다.

---

## 한도 · 주의사항 (Considerations)

| 항목 | 값/내용 |
|---|---|
| **활성 정책 최대 수** | 조직당 **최대 200개** active user access policy |
| **성능** | 비즈니스에 필요한 정책만 생성 권장. 복잡한 필터 + 다중 정책 트리거 시 처리 시간 급증 |
| **그룹 멤버십 대량 변경** | 대량 public group 멤버십 동시 변경은 **sharing 재계산 지연·타임아웃·group membership lock** 위험 |
| **라이선스 부족** | 정책이 라이선스를 할당하는데 라이선스가 부족하면 실패가 **Recent User Access Changes**에 기록됨 |
| **라이선스 카운트 반영** | 정책으로 라이선스 회수 시 Company Information·Installed Packages 페이지에 항상 즉시 반영되지는 않음 |
| **Recent User Access Changes** | 정책이 적용한 변경 중 **현재 유효한(still in effect)** 것만 표시. 이후 덮어쓰인 변경은 사라짐 |
| **Enhanced Interface** | 기본 Enhanced Interface 사용 권장. Enhanced 사용 후 구 인터페이스로 되돌리면 정책 데이터가 덮어써질 수 있음 |

---

## 활성화 절차

1. Setup → Quick Find에 **User Management Settings** 입력 → **User Management Settings** 선택.
2. **User Access Policies** 토글을 활성화한다.
3. **Enhanced Interface for User Access Policies** 설정이 자동으로 함께 활성화된다(유지 권장).

> 자세한 User Management Settings 페이지의 다른 토글은 [[User Management Settings · Login Access Policies (사용자 관리 설정·로그인 대행)]] 참조.

---

## 관련 노트
- [[User Management Settings · Login Access Policies (사용자 관리 설정·로그인 대행)]] — 이 기능을 켜는 상위 설정 페이지
- [[Users (사용자 관리)]] — 사용자 레코드·라이선스 관리
- [[Permission Set Groups (권한 집합 그룹)]] — 정책이 부여하는 주요 대상
- [[Public Groups (공개 그룹)]] — 정책이 멤버십을 관리하는 대상
- [[Delegated Administration (위임 관리)]] — 관리 업무 위임(수동 방식과 대비)
