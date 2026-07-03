---
tags: [security, permissions, custom-permissions, access-control, feature-management]
source: help.salesforce.com (Salesforce Help — Manage Users and Data Access; Custom Permissions; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=platform.custom_perms_overview.htm&type=5
created: 2026-07-03
aliases: [Custom Permissions, 커스텀 권한, Access Check, FeatureManagement.checkPermission, $Permission, Required Custom Permission]
---

# Custom Permissions (커스텀 권한)

> 커스텀 프로세스·앱에 대한 **자체 접근 체크(access check)**를 정의해 permission set·프로파일로 사용자에게 부여하는 권한. 수식·검증 규칙·Flow·Apex에서 "이 사용자가 이 권한을 가졌는가"를 확인해 기능을 게이트한다.

---

## 개념 — 무엇을 위한 권한인가

**Custom permission**은 커스텀 프로세스나 앱에 대한 접근을 사용자에게 부여하기 위한 권한이다.

> 원문: *"Use custom permissions to give users access to custom processes or apps."*

Salesforce의 많은 기능은 **어떤 사용자가 특정 기능에 접근할 수 있는지**를 판단하는 **access check(접근 체크)**를 요구한다. 표준 사용자 권한처럼 플랫폼이 미리 제공하는 체크만으로는 커스텀 로직을 게이트할 수 없다.

custom permission은 이런 **access check를 개발자가 직접 정의**하게 해준다. 정의한 뒤에는 표준 user 권한이나 다른 접근 설정과 마찬가지로 **permission set·프로파일을 통해 사용자에게 할당**한다. 즉 "이 프로세스/앱에 접근 가능한 사용자"라는 개념을 하나의 부여 가능한 단위로 만들어, 이후 수식·규칙·코드에서 그 단위를 참조해 분기한다.

- 정의 위치: **Setup → Custom Permissions**
- 부여 위치: **Permission Set / Profile** (표준 권한과 동일한 할당 경로)
- 소비 위치: **수식 · 검증 규칙 · Flow · Apex · Connected App** 등에서 참조

---

## Available in (에디션·환경)

| 항목 | 값 |
|---|---|
| UI | Salesforce Classic **및** Lightning Experience |
| Edition | Group, Professional, Enterprise, Performance, Unlimited, Developer |

> [!warning] **Group·Professional Edition 제약**
> Group Edition과 Professional Edition에서는 custom permission을 **생성하거나 편집할 수 없다.** 단, managed package를 통해 **설치**된 custom permission은 이 두 에디션에서도 사용할 수 있다.

---

## 조회·체크(query) 방법

정의한 custom permission을 "이 사용자가 가졌는가"로 소비하는 표면들이다.

- **Apex** — 특정 custom permission에 어떤 사용자가 접근 권한을 갖는지 판별한다. (예: `FeatureManagement.checkPermission`)
- **Connected app** — 사용자가 connected app에서 인증할 때 보유한 custom permission을 **Identity URL**을 통해 참조한다.
- **수식(formula) · 검증 규칙 · Flow** — 문서상 custom permission의 목적이 access check이므로, 일반적으로 **`$Permission` 전역 변수**를 통해 수식·검증 규칙·Flow에서 참조해 기능을 게이트한다.

---

## Required custom permission (권한 간 의존성)

**Required custom permission**은 parent custom permission이 활성화될 때 **반드시 함께 활성화돼야 하는** custom permission이다. 즉 custom permission 사이에 **의존성**을 선언해, 상위 권한을 부여하면 필요한 하위 권한도 함께 유효해지도록 보장한다.

---

## 체크 표면 예시

```
// 구조 예시 — custom permission 체크 표면(실제 동작 코드 아님)
정의: Setup → Custom Permissions → New (예: "Approve_Large_Discount")
할당: Permission Set / Profile 에 포함 → 사용자에 할당
체크:
  수식/검증 규칙:  $Permission.Approve_Large_Discount
  Apex:            FeatureManagement.checkPermission('Approve_Large_Discount')
  Flow:            Decision 요소에서 $Permission 참조
  Connected App:   Identity URL로 custom permission 조회
```

> 위 `FeatureManagement.checkPermission`·`$Permission`은 공식 문서화된 표준 체크 표면이다. 정확한 시그니처·반환 타입·네임스페이스 세부는 Apex 레퍼런스로 확인하고, 위 블록은 참조 지점의 구조만 보여주는 예시로 다룬다.

---

## 관련 노트
- [[Salesforce 권한 모델 개요]] — 권한 시리즈 허브
- [[Permission Sets (권한 집합)]] — custom permission을 담아 사용자에게 할당하는 그릇
