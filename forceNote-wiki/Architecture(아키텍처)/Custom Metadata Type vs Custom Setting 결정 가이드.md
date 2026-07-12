---
tags: [architecture, custom-metadata, custom-settings, cmdt, configuration, decision-guide, deployment]
source: 조합 노트 — [[Custom Metadata Type (__mdt)]](object_reference.pdf v67.0, Tier 2) + [[Custom Settings (커스텀 설정)]](help.salesforce.com, Tier 2)
created: 2026-07-12
aliases: [CMDT vs Custom Setting, Custom Metadata vs Custom Setting, 커스텀 메타데이터 vs 커스텀 설정, 구성 데이터 저장 선택, 설정 저장 선택 가이드]
---

# Custom Metadata Type vs Custom Setting 결정 가이드

> 구성값을 어디에 저장할지 — **배포가 필요하면 CMDT(메타데이터), 런타임 수정·사용자별 계층이 필요하면 Custom Setting(데이터)**. 상세는 각 노트로 위임하고 여기서는 선택 축만 다룬다.

**상위:** [[Architecture MOC]] → [[00 Home]]

---

## 한눈에 — 무엇을 언제

| 상황 | 선택 | 이유 |
|---|---|---|
| 앱 구성값(환경 무관, org 간 배포 필요) | **CMDT** | 레코드가 메타데이터라 change set·패키지로 배포 |
| 사용자·프로필별로 값이 달라야 함 | **Hierarchy Custom Setting** | org < profile < user 계층 override |
| 자주 바뀌는 런타임 값(Apex/UI에서 수정) | **List / Hierarchy Custom Setting** | 데이터라 DML로 런타임 수정 가능 |
| 관리 패키지에 담아 구독자 org에 릴리즈 | **CMDT** | 패키징 가능 + `isProtected`로 접근 제어 |
| 수천 건 이상 대량 매핑·요율 | **둘 다 부적합** → Custom Object 검토 | CMDT 10M자 한도·CS 수백 건 한도. [[Custom Metadata Types]] §7 참조 |

---

## 결정 축 비교

| 결정 축 | CMDT (`__mdt`) | Custom Setting (`__c`) |
|---|---|---|
| **본질** | 메타데이터 | 데이터 |
| **배포 가능성** | ✅ change set·패키지로 배포 | ❌ 데이터라 배포 대상 아님(패키징 제한적) |
| **런타임 수정** | ❌ 배포(Metadata API Deploy)로만 | ✅ Apex DML로 런타임 수정 |
| **레코드 접근** | 앱 캐시 `getAll()`/`getInstance()` → SOQL 불필요(SOQL 한도 면제) | 앱 캐시 → SOQL 불필요 |
| **계층 override** | ❌ 계층 없음 | ✅ **Hierarchy**만: org < profile < user (낮은 수준 우선) |
| **관계 필드** | ✅ 지원(qualified API name으로 참조) | ❌ 계층 관계 외 관계 필드 없음 |
| **관리 패키지 접근 제어** | ✅ `isProtected`(같은 패키지 코드만 읽기) | 해당 없음 |
| **대용량** | org 전체 CMDT 합산 10M자·타입당 필드 100·레코드 10KB 한도 | 수백 건 수준 |

> **캐시 주의(CMDT):** `getAll()`/`getInstance()`는 255자 초과 필드를 자른다. 전체 값이 필요하면 SOQL로 조회한다. 상세 메서드·한도는 [[Custom Metadata Types]] 참조.

---

## 축별 판단 포인트

### 1. 배포 가능성 (가장 결정적 축)
- **CMDT = 레코드 자체가 메타데이터.** dev/test/prod, 관리 패키지로 레코드까지 함께 배포된다. 환경 간 동일해야 하는 앱 구성값(요율표·기능 플래그·매핑)에 적합.
- **Custom Setting = 데이터.** org 안에서 관리하며 그 자체는 배포 대상이 아니다. 정의(스키마)는 배포돼도 레코드 값은 각 org에서 별도 입력.

### 2. 런타임 수정
- **Custom Setting은 데이터라 Apex DML로 런타임 수정 가능** — 관리자·코드가 실행 중 값을 바꿔야 하는 토글·카운터에 적합.
- **CMDT는 메타데이터라 런타임 DML 불가** — `create()/update()/delete()/upsert()` 없음. 변경하려면 배포가 필요하므로 "자주 바뀌는" 값에는 부적합.

### 3. 계층 override (Hierarchy Custom Setting 고유)
- 사용자·프로필별로 다른 값이 필요하면 **Hierarchy Custom Setting**만 가능. **org < profile < user** 순으로 더 구체적인 수준이 상위를 이긴다(org=기본값, user=최우선).
- **CMDT는 계층이 없다** — 모든 컨텍스트에서 같은 레코드 집합.

### 4. SOQL governor
- **둘 다 앱 캐시로 SOQL 없이 접근.** CMDT의 `getAll()`은 SOQL 한도에 집계되지 않는다.
- 차이는 접근 API: CMDT는 타입에 내장된 정적 메서드(`getAll()`/`getInstance()`), List Custom Setting도 캐시 접근, **계층 override는 Hierarchy Custom Setting에서만**.

---

## 코드 관점 대조

```apex
// 구조 예시 — 각 저장소 접근 방식 대조(실제 동작 코드 아님)

// CMDT: 정적 메서드 · 캐시 · 배포로만 갱신
Map<String, RateCard__mdt> rates = RateCard__mdt.getAll();   // SOQL 한도 면제
RateCard__mdt std = RateCard__mdt.getInstance('Standard');
// std 값 변경 → DML 불가. Metadata API Deploy로만.

// Hierarchy Custom Setting: 계층 override · 런타임 DML 가능
// (현재 사용자 컨텍스트에 맞는 값이 org<profile<user 순으로 해석됨)
// getInstance()로 현재 사용자 값을 얻고, upsert로 런타임 수정 가능
```

> 실제 메서드 시그니처·필드·한도는 재서술하지 않는다 — [[Custom Metadata Type (__mdt)]]·[[Custom Metadata Types]]·[[Custom Settings (커스텀 설정)]]에서 확인.

---

## 관련 노트
- [[Custom Metadata Type (__mdt)]] — CMDT Object 필드 참조·`isProtected`·SOQL/`getInstance` 상세(위임 대상)
- [[Custom Settings (커스텀 설정)]] — List vs Hierarchy·계층 override·생성 방법 상세(위임 대상)
- [[Custom Metadata Types]] — CMDT Apex 읽기/쓰기(Metadata.Operations)·한도(10M자)·사용 사례 심화
- [[Object Groups]] — 구성·설정값 저장 선택은 이 노트, 데이터 레코드 저장 오브젝트(Custom/Big/External/Data Cloud) 선택은 Object Groups로
