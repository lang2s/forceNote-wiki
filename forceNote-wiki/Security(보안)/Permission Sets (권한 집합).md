---
tags: [security, permissions, permission-sets, access-control, admin]
source: help.salesforce.com (Salesforce Help — Manage Users and Data Access; Permission Sets; 라이브 공식 문서, Tier 2, 접속 2026-07-03) | Salesforce Help — Increase Number of Permission Sets per Organization (id=000390856, Tier 2) | Salesforce Help — Permission Set Considerations (id=platform.perm_sets_considerations.htm, Tier 2)
official_doc: https://help.salesforce.com/s/articleView?id=platform.perm_sets_overview.htm&type=5
created: 2026-07-03
aliases: [Permission Sets, 권한 집합, permset, Standard Permission Set, Integration Permission Set, Session-based Permission Set, Permission Set Assignment]
---

# Permission Sets (권한 집합)

> 특정 직무·작업에 필요한 권한과 설정을 모아 사용자에게 **추가로 부여**하는 그릇. 사용자는 profile 1개 + permission set 다수를 가질 수 있고, 부여는 additive(프로파일 OR permission set).

---

## 정의

> 공식 원문: *"A permission set is a collection of settings and permissions that give users access to various tools and functions."*

Permission set은 **설정(settings)과 권한(permissions)의 묶음**으로, 사용자에게 다양한 도구·기능에 대한 접근을 부여한다. 기본 프로파일과 무관하게, **특정 job이나 task**에 필요한 접근만 별도로 부여하려고 생성한다.

- 사용자는 **profile은 오직 1개**만 가질 수 있지만, Salesforce edition에 따라 **permission set은 여러 개** 가질 수 있다.
  > 원문: *"Users can have only one profile but, depending on the Salesforce edition, they can have multiple permission sets."*
- 담기는 것: **object 권한, field 권한, user(system) 권한**, 그리고 기타 접근·기능 설정을 permission set 안에 구성한다.

---

## additive(grant-only) 동작 — 핵심 규칙

> ⚠️ 공식 원문: *"If a permission isn't enabled in a profile but is enabled in a permission set, users with that permission set have the permission."*

권한 부여는 **누적(additive)** 이다. 어떤 권한이 프로파일에는 꺼져 있어도 permission set에 켜져 있으면, 그 permission set을 가진 사용자는 해당 권한을 **가진다**.

- 판정은 논리적으로 **프로파일 OR permission set** — 둘 중 하나라도 켜져 있으면 부여.
- Permission set은 **부여(grant)만** 한다. 프로파일이 준 권한을 permission set으로 **회수(제거)할 수는 없다**.

---

## 지원 환경 (Available in)

- **UI:** Salesforce Classic + Lightning Experience 모두.
- **Editions:** Essentials, Contact Manager, Professional, Group, Enterprise, Performance, Unlimited, Developer, Database.com.

---

## 한도·주의 — org당 생성 가능 개수

> ⚠️ Permission set 기반 설계(아래 '권장' 지침·[[Permission Set 설계]])를 따르기 전에 반드시 확인해야 하는 **에디션별 하드 한도**다.

한 org에서 생성할 수 있는 permission set 개수는 edition에 따라 다르다.

| Edition | org당 permission set 기본 한도 |
|---|---|
| **Professional Edition** | 기본 **최대 10개** (11번째 생성 시 오류) |
| **Enterprise · Performance · Unlimited · Developer** 등 | 기본 **최대 1,500개** |

- **Group / Professional 에디션**에서 permission set 중심으로 접근을 설계하면 이 한도에 **빠르게 도달**한다. 저에디션에서는 permission set 남발 전에 한도를 감안해 설계한다.
- 근거: Salesforce Help — *Increase Number of Permission Sets per Organization* / *Permission Set Considerations*.

---

## Permission Set 유형

Salesforce는 여러 종류의 permission set을 제공한다.

| 유형 | 설명 |
|---|---|
| **Standard permission set** | 특정 feature에 대한 공통 권한 묶음(Salesforce가 제공). |
| **Integration permission set** | Salesforce integration 관련 기능의 **데이터 접근 범위(scope)** 를 정의. |
| **Session-based permission set** | 특정 **user session**에 적용돼, 세션이 활성인 동안만 기능을 부여. |

---

## 할당 (Assignment)

- **단일 사용자**에게 할당: 해당 user detail page에서 부여.
- **여러 사용자**를 한 번에 할당: 다중 사용자를 묶어 일괄 부여.

---

## Overview 페이지 (권한 요약)

Permission set의 **Overview 페이지**는 그 set에 담긴 모든 권한으로 진입하는 시작점을 제공한다. 특정 set의 전체 권한을 한눈에 확인하려면 **View Summary**(권한 요약)를 연다.

경로: Quick Find → **Permission Sets** → 해당 set 선택 → **View Summary**.

---

## 관리 편의 기능

- **Enhanced 검색 / 고급 필터**로 permission set을 빠르게 찾기.
- **List view 생성** 및 list view에서 직접 권한 편집.
- Permission set **내부 검색**(원하는 권한 페이지로 이동).
- 특정 permission set이 **몇 개의 permission set group에 포함**됐는지 확인.
- 배정된 **custom permission set·permission set group 리포트**.
- **Considerations / special behaviors**(고려사항·특수 동작)가 문서에 별도 정리돼 있음.

---

## Setup 경로

```
// 구조 예시 — Setup 경로 표기(실제 동작 코드 아님)
Setup → Quick Find: "Permission Sets" → Permission Sets
  └ New (또는 Standard/Integration/Session-based) → 권한 구성
     └ Object · Field · System(User) 권한 · Apex/VF Access · Custom Permission
  └ Manage Assignments → (단일/다중 사용자 할당)  ·  View Summary(권한 요약)
```

---

## 관련 노트
- [[Salesforce 권한 모델 개요]] — 권한 시리즈 허브(그릇·대상 격자). 전체 권한 모델 안에서 permission set의 위치를 잡을 때.
- [[Permission Set 설계]] — permission set 기반 접근 **설계 패턴**(본 노트는 구조 레퍼런스, 그 노트는 설계 전략).
- [[Profiles (프로파일)]] — 기본값(profile) vs 추가 부여(permission set), 짝.
- [[Permission Set Groups (권한 집합 그룹)]] — 여러 permission set을 묶는 상위 그릇.
