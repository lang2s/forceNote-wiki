---
tags: [security, permissions, permission-set-groups, muting-permission-set, access-control, admin]
source: help.salesforce.com (Salesforce Help — Manage Users and Data Access; Permission Set Groups; 라이브 공식 문서, Tier 2, 접속 2026-07-03) + help.salesforce.com (Permission Set Group Status and Recalculation, id=platform.perm_set_groups_status_recalc.htm; 재계산 Failed 원인 id=002723601; Tier 2, 접속 2026-07-04)
official_doc: https://help.salesforce.com/s/articleView?id=platform.perm_set_groups.htm&type=5
created: 2026-07-03
aliases: [Permission Set Groups, 권한 집합 그룹, PSG, Muting Permission Set, 뮤팅 권한 집합, Combined Permissions, Session-based Permission Set Group]
---

# Permission Set Groups (권한 집합 그룹)

> 여러 permission set을 **직무(job function) 단위로 묶어** 한 번에 할당하는 그릇. 사용자는 그룹에 포함된 모든 permission set의 **결합 권한(combined permissions)**을 받으며, muting permission set으로 특정 권한만 예외적으로 비활성화할 수 있다.

---

## 개념

Permission set group(PSG)은 **permission 할당과 관리를 간소화(streamlines permissions assignment and management)**하기 위한 그릇이다. 여러 permission set을 **직무(job function) 기준으로 묶어** 하나의 단위로 취급한다.

핵심은 **결합 권한(combined permissions)**이다.

> **원문:** *"Users assigned the permission set group receive the combined permissions of all the permission sets [in the group]."*

- PSG는 자신에 포함된 permission set들로부터 결합 권한을 **계산(calculate)**한다.
- PSG 상세 화면의 **Combined Permissions** 섹션이 그룹에 포함된 모든 권한을 한눈에 보여준다.
- 결합은 기본적으로 **합집합(grant-only)**이다 — 포함된 permission set 중 하나라도 어떤 권한을 부여하면 그 권한이 결합 결과에 들어간다. 유일한 예외적 차감(subtractive) 메커니즘이 아래의 **muting permission set**이다.

### Available in

| 항목 | 값 |
|---|---|
| Experience | **Lightning Experience** (Salesforce Classic은 **모든 org에서 제공되지 않음**) |
| Editions | Contact Manager, Group, Essentials, Professional, Enterprise, Performance, Unlimited, Developer, Database.com |

---

## 왜 쓰는가 — 공식 예시

세일즈 부서 사용자가 다음을 모두 할 수 있어야 하는 상황이라고 하자.

1. Sales Cloud Analytics 템플릿·앱 사용
2. survey 생성·편집·삭제
3. account·opportunity의 read/create/edit/delete
4. list view·report 생성·커스터마이즈

이 요구를 충족하는 permission set 3개를 이미 보유하고 있다.

| Permission Set | 담당 기능 |
|---|---|
| **Sales Cloud Einstein** | Sales Cloud Analytics 템플릿·앱 |
| **Survey Creator** | survey 생성·편집·삭제 |
| **Standard User Profile 기반 permission set** | account/opportunity CRUD, list view·report |

- **PSG가 없다면:** 각 permission set을 사용자마다 **개별 할당**해야 한다.
- **PSG를 쓰면:** 직무 기준으로 **단일 그룹**을 만들어 세 permission set을 넣고, 그 그룹 하나만 사용자에게 할당한다.

사용자가 늘거나 직무 요건이 바뀌어도 관리 지점이 그룹 하나로 수렴한다.

---

## Muting Permission Set (뮤팅 권한 집합)

**Muting permission set**은 permission set group **내에서 선택한 권한을 mute(비활성화)**하는 데 사용한다.

- 그룹의 결합(합집합) 결과에서 **특정 권한만 빼는 유일한 차감(subtractive) 메커니즘**이다 — 나머지 권한 모델은 grant-only이다.
- 그룹에 포함된 permission set들은 그대로 두면서, 원치 않는 권한만 그룹 수준에서 예외적으로 꺼서 결합 결과에서 제외한다.

```
// 구조 예시 — 권한 집합 그룹 개념도(실제 원본 다이어그램 아님)
Permission Set Group "Sales Rep"
  ├─ Permission Set: Sales Cloud Einstein
  ├─ Permission Set: Survey Creator
  ├─ Permission Set: (Standard User Profile 기반)
  └─ Muting Permission Set: (위 결합 권한 중 특정 권한 비활성화)
        ▼
  Combined Permissions = (3개 permission set 합집합) − (muting)
```

---

## 생성 흐름

```
// 구조 예시 — PSG 도입 절차(실제 동작 코드 아님)
1. 준비   기존 permission set과 사용자를 평가한다
          (어떤 직무에 어떤 permission set 묶음이 필요한지)
2. 생성   permission set group을 만든다
3. 구성   그룹에 permission set을 추가한다
          (필요 시 muting permission set으로 특정 권한 차감)
4. 할당   그룹을 사용자에게 할당한다
          → 사용자는 combined permissions를 부여받는다
          ⚠️ 단, 그룹 status가 'Updated'일 때만 할당 가능 (아래 참조)
```

생성 전에 **기존 permission set과 사용자를 평가**하는 준비 단계가 권장된다.

---

## Status 라이프사이클과 재계산 (실무 블로커)

PSG는 포함된 permission set들로부터 **결합 권한을 계산**하며, 이 계산 결과에 따라 그룹에 **status**가 부여된다. 위 "할당" 단계는 이 라이프사이클을 전제로 하므로, 변경 직후 status를 확인하지 않으면 할당·권한 반영이 실무에서 막힌다.

### status 값

| Status | 의미 |
|---|---|
| **Updated** | 결합 권한 계산이 완료된 상태. **이 상태에서만 사용자 할당이 가능**하다. |
| **Updating** | 결합 권한을 재계산 중. 계산이 끝나 Updated가 될 때까지 권한 반영이 지연될 수 있다. |
| **Outdated** | 그룹 또는 포함된 permission set에 변경이 있어 재계산이 필요한 상태. 아직 결합 권한이 최신이 아니다. |
| **Failed** | 재계산이 실패한 상태. 수동 recalculation이 필요하다. |

> **원문:** *"You can assign users only to permission set groups that have a status of Updated."*

### 블로커 1 — 할당은 Updated 상태에서만

사용자는 status가 **Updated**인 PSG에만 할당할 수 있다. 그룹을 방금 만들었거나 구성을 바꾼 직후에는 status가 **Outdated / Updating**일 수 있고, 이 상태에서는 할당·권한 반영이 지연된다. 할당 단계 전에 그룹 상세 화면에서 status가 Updated인지 확인한다.

### 블로커 2 — 재계산 트리거와 Failed 원인

다음이 발생하면 결합 권한 **재계산이 트리거**된다.

- 그룹에 포함된 permission set을 **편집**할 때
- 관련 **배포(deploy)·패키지 업데이트**가 있을 때

재계산 과정에서 permission set에 **잘못된 데이터**가 있으면 status가 **Failed**로 떨어지고 **수동 recalculation**이 필요하다. 대표적 원인은 permission set에 다음과 같은 **오브젝트 권한**이 포함된 경우다.

- **View Setup**
- **Edit Setup**
- **Create Setup**

이런 setup 오브젝트 권한이 결합 계산을 실패시키므로, Failed 상태를 만나면 해당 permission set의 잘못된 권한을 정리한 뒤 그룹을 다시 recalculate한다.

---

## 변형 및 활용

### Session-based permission set group
특정 **user session**에 적용되는 permission set group. 세션이 유효한 동안에만 해당 기능을 부여한다. 상시 부여가 아니라 세션 컨텍스트에 한정된 권한이 필요할 때 사용한다.

### Managed package 포함
파트너(ISV)는 관련 권한을 permission set group으로 조직해 **managed package에 포함**할 수 있다. 패키지 설치 org에서 직무 단위 권한 묶음을 그대로 배포·재사용할 수 있게 한다.

---

## 정리

| 개념 | 요약 |
|---|---|
| Permission Set Group | permission set들을 **직무 단위로 묶는 그릇** |
| Combined Permissions | 포함된 모든 permission set의 **합집합**을 계산·표시 |
| Muting Permission Set | 결합 결과에서 **특정 권한만 차감**하는 유일한 subtractive 수단 |
| Session-based PSG | **user session** 동안만 유효한 그룹 |
| Managed package | 파트너가 권한 묶음을 패키지로 배포 |

> 이 문서의 상위 개념(권한 부여 계층·프로파일과의 관계)은 [[Salesforce 권한 모델 개요]]를 참조한다. behaviors/considerations, FAQ 등 세부 고려사항은 공식 문서(상단 official_doc 링크)를 참조한다.

---

## 관련 노트
- [[Salesforce 권한 모델 개요]] — 권한 시리즈 허브
- [[Permission Sets (권한 집합)]] — PSG를 구성하는 단위
- [[Permission Set 설계]] — permission set/PSG 기반 접근 설계 패턴
