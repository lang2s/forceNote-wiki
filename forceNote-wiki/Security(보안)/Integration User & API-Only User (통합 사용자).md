---
tags: [security, integration, license, api-only, integration-user, permission-set, least-privilege]
source: help.salesforce.com — Give Integration Users API Only Access (platform.integration_user, Tier 2) + Assign the New Salesforce Integration User License (release-notes.rn_api_integration_license, Tier 2) + Salesforce Admins Blog "Best Practices for Configuring Your Integration User" (admin.salesforce.com, Tier 2)
official_doc: https://help.salesforce.com/s/articleView?id=platform.integration_user.htm&type=5
created: 2026-07-07
aliases: [Integration User, 통합 사용자, API-Only User, API Only User, Salesforce Integration License, 통합 라이선스, Minimum Access - API Only Integrations, Salesforce API Integration permission set license, 5 free integration licenses]
---

# Integration User & API-Only User (통합 사용자)

> 시스템 간 통합(ERP·미들웨어·외부 앱)은 **사람 사용자 라이선스가 아니라 전용 Integration User**로 실행해야 한다. Salesforce는 org마다 **무료 5개**의 Integration 라이선스를 주며, 이 사용자는 **API 전용(UI 로그인 차단)**이고 권한은 **최소권한 프로파일 + Permission Set**로 정밀하게 붙인다.

> [!note] 근거: help.salesforce.com **Give Integration Users API Only Access** + Release Notes(Integration User License) + Salesforce Admins 공식 블로그. 📖 [Give Integration Users API Only Access](https://help.salesforce.com/s/articleView?id=platform.integration_user.htm&type=5)

---

## 왜 전용 통합 사용자인가

외부 시스템이 사람 관리자 계정으로 API를 치면 세 가지 문제가 생긴다: (1) 유료 사용자 **라이선스 낭비**, (2) 그 사람이 퇴사·비활성화되면 통합이 **끊김**, (3) 감사 로그에서 "사람이 한 일"과 "통합이 한 일"이 **구분 안 됨**. 통합마다 전용 사용자를 두면 라이선스를 아끼고, 인적 변동과 무관하며, 감사·권한을 통합 단위로 격리할 수 있다.

---

## Salesforce Integration License

| 항목 | 내용 |
|---|---|
| 무료 제공 | **org당 5개** (Performance·Enterprise·Unlimited 에디션). Developer Edition에는 **1개** 포함 |
| 추가 비용 | 무료 5개 소진 후 추가분은 **약 $10/user/월** (공식 가격표 아님·근사치이며 가격은 변동 가능 — 정확한 가격은 Salesforce 영업 문의) |
| 성격 | **API 전용** — 이 라이선스 사용자는 UI로 org의 기능·데이터에 접근 불가, 오직 REST·SOAP·Bulk API 등 API로만 |
| 도입 시점 | TrailblazerDX 2023(2023-03 발표) 이후 제공 |

Integration 라이선스를 사용자에 배정하면 두 가지가 배정 가능해진다:

- **`Minimum Access - API Only Integrations` 프로파일** — 통합 사용자를 API로만 동작하도록 **활성화·제한**하는 최소 접근 프로파일.
- **`Salesforce API Integration` permission set license (PSL)** — 이 PSL이 있어야 표준 오브젝트 권한을 담은 Permission Set를 통합 사용자에게 붙일 수 있다.

> [!warning] 표준 오브젝트 권한이 든 Permission Set는 **License = `Salesforce API Integration`** 으로 만든 것이어야 통합 사용자에 할당된다. 라이선스가 맞지 않는 permission set는 할당이 거부된다.

---

## API-Only User (API 전용 사용자)

**API Only User**는 사용자가 **REST·SOAP·Bulk API로만** org에 접근하고 **표준 UI 로그인은 차단**되는 상태다. `API Only User` 시스템 권한으로 켠다.

- UI 로그인 시도 시 "access is restricted for API Only users" 안내가 뜨고, 이후 로그인은 API로만 가능.
- Integration 라이선스의 `Minimum Access - API Only Integrations` 프로파일이 이 제한을 내장한다(전용 라이선스가 없어도 일반 프로파일에 `API Only User` 권한을 켜서 만들 수도 있다).
- **해제:** `Manage Users` 권한 보유자가 해당 사용자의 프로파일·permission set에서 `API Only User` 권한을 찾아 제거/비활성화.

> [!note] `API Only User`는 "권한 축소"이자 "보안 강화"다. 통합 자격증명이 유출돼도 공격자가 **UI로 로그인해 대화식으로 돌아다닐 수 없다**. 통합 사용자는 원칙적으로 항상 API-Only로 둔다.

---

## 최소권한 설계 패턴 — 프로파일은 그릇, 권한은 Permission Set

Salesforce Admins 공식 권장: **프로파일에 업무 권한을 넣지 말고**, 프로파일은 기본값(default)·페이지 레이아웃·로그인 시간/IP·그리고 **핵심인 `API Only` 권한**만 담는다. 실제 접근 권한(오브젝트·필드·시스템·Connected App 등)은 **Permission Set / Permission Set Group**으로 부여한다.

```text
// 구조 예시 — 통합 사용자 권한 조립(최소권한)
Integration User "SVC_ERP_Sync"
├─ License:  Salesforce Integration            (무료 5개 중 1개)
├─ Profile:  Minimum Access - API Only Integrations   ← API 전용 강제 + 최소 기본값
└─ Permission Set(License = Salesforce API Integration):
     ├─ Object: Account(Read/Create/Edit), Order(Read/Edit)   ← 딱 필요한 것만
     ├─ Field:  Account.Legacy_Id__c (Edit)                    ← 멱등 upsert 키 필드
     ├─ System: API Enabled
     └─ Apex Class / Connected App access (필요 시)
```

원칙:

1. **통합마다 사용자 1개** — ERP 동기화, 결제 연동, BI 추출을 한 계정에 몰지 않는다. 격리해야 유출·권한 폭발을 각각 봉쇄.
2. **딱 필요한 오브젝트/필드만** — "View All / Modify All Data" 같은 광범위 권한을 통합에 주지 않는다.
3. **프로파일=제약, Permission Set=부여** — 권한 증분은 전부 permission set로. 감사·재사용·회수가 쉬워진다.

각 권한 그릇의 의미는 [[Profiles (프로파일)]]·[[Permission Sets (권한 집합)]]·[[Permission Set Groups (권한 집합 그룹)]] 참조. 오브젝트/시스템 권한 종류는 [[Object Permissions (오브젝트 권한 — CRUD·View All·Modify All)]]·[[User and System Permissions (사용자·시스템 권한)]].

---

## Named Principal과의 관계

아웃바운드(SF → 외부) 방향에서 인증 **주체(principal)** 를 어떻게 잡느냐는 별개 축이다.

- **Named Principal** — org 전체가 **하나의 공유 자격증명**으로 외부에 인증(모든 SF 사용자가 같은 외부 계정으로 나감). Named Credential에서 설정.
- **Per-User Principal** — SF 사용자마다 각자의 외부 자격증명으로 인증.

여기서 다룬 **Integration User는 "SF 쪽(인바운드) 실행 주체"**, Named Principal은 **"외부 쪽(아웃바운드) 인증 주체"** 로 층이 다르다. 외부 미들웨어가 SF로 들어올 때는 Integration User의 자격증명으로 인증하고, SF가 외부로 나갈 때 그 콜아웃을 Named Credential의 named principal로 인증하는 식으로 **양방향에서 각각** 설계한다. 아웃바운드 자격증명 관리는 [[Named Credential]]·인증 클라이언트는 [[Connected App (연결된 앱) — OAuth 클라이언트]] 참조.

---

## 관련 노트
- [[Profiles (프로파일)]] — 프로파일=제약·기본값 그릇(API Only 권한 위치)
- [[Permission Sets (권한 집합)]] — 통합 권한을 부여하는 additive 그릇(License 매칭 주의)
- [[Permission Set Groups (권한 집합 그룹)]] — 통합 역할별 permission set 묶음
- [[User and System Permissions (사용자·시스템 권한)]] — API Enabled·광범위 권한 회피
- [[Object Permissions (오브젝트 권한 — CRUD·View All·Modify All)]] — 딱 필요한 CRUD만
- [[Named Credential]] — 아웃바운드 named principal·자격증명 관리
- [[Connected App (연결된 앱) — OAuth 클라이언트]] — 통합 인증(OAuth) 클라이언트 정의
- [[통합 아키텍처 결정 - 미들웨어·재시도·멱등성]] — 통합 위상·신뢰성 결정 프레임
