---
tags: [admin, duplicate-rules, matching-rules, duplicate-jobs, duplicate-record-set, data-quality, deduplication]
source: help.salesforce.com (Salesforce Help — Data Quality; Things to Know About Duplicate Rules + Things to Know About Matching Rules, 접속 2026-07-03; Find Duplicates Across Your Org Using Duplicate Jobs + Run Duplicate Jobs + Things to Know About Duplicate Jobs + Manage Duplicates Using Duplicate Record Sets, 접속 2026-07-12; developer.salesforce.com Object Reference — DuplicateRecordSet·DuplicateRecordItem; 라이브 공식 문서, Tier 2)
official_doc: https://help.salesforce.com/s/articleView?id=sales.duplicate_rules_overview.htm&type=5
created: 2026-07-03
aliases: [Duplicate Rules, Matching Rules, 중복 규칙, 매칭 규칙, Duplicate Management, Match Key, Matching Method, Duplicate Jobs, 중복 작업, Duplicate Record Set, 중복 레코드 세트, DuplicateRecordSet, DuplicateRecordItem]
---

# Duplicate & Matching Rules (중복·매칭 규칙)

> **Matching Rule**이 "무엇이 중복인가"(필드 비교 방법·match key)를 정의하고, **Duplicate Rule**이 "중복 발견 시 무엇을 하나"(Allow/Block/Report)를 정의하는 데이터 품질 도구. Duplicate Rule은 Matching Rule을 참조한다.

---

## 개요 — 두 규칙의 역할 분리

Salesforce 중복 관리(Duplicate Management)는 서로 다른 책임을 가진 **두 개의 규칙**이 협력한다.

| 규칙 | 답하는 질문 | 정의하는 것 |
|---|---|---|
| **Matching Rule** | *무엇이 중복인가?* | 필드 비교 방법(matching method·algorithm), match key |
| **Duplicate Rule** | *중복을 발견하면 무엇을 하나?* | 저장 시 동작(Allow / Block / Report), 어떤 matching rule을 쓸지 |

Duplicate Rule은 하나 이상의 Matching Rule을 **참조**한다. 따라서 Matching Rule이 먼저 "중복 후보"를 판정하고, 그 결과를 받아 Duplicate Rule이 사용자 저장 시점의 동작을 결정한다.

**Available in:** Lightning Experience + Salesforce Classic.
**Editions:** Essentials, Professional, Enterprise, Performance, Unlimited, Developer.

---

## Matching Rules — 무엇이 중복인가

Matching rule은 **criteria를 적용해 새 레코드 또는 편집된 레코드의 필드가 기존 레코드의 같은 필드와 얼마나 가깝게 일치하는지** 판정한다.

### matching method와 matching equation
- **matching method**는 특정 필드가 다른 레코드의 같은 필드와 **어떻게 비교되는지**를 결정한다.
- matching method + 그에 대응하는 **matching algorithms** = matching rule의 **matching equation**.

### 실행 순서 — match key 먼저, 그다음 matching equation
matching rule이 실행되면 다음 순서로 동작한다.

1. 하나 이상의 **match key formula**를 먼저 적용한다.
2. 이후 comprehensive(포괄) **matching equation**을 적용한다.

**match key의 목적(성능):** match key는 예비 비교(preliminary comparison)로, 비교 대상 후보를 **가장 유력한 100건**으로 좁혀 성능을 높인다. 전체 레코드에 무거운 matching equation을 곧바로 돌리지 않고, 값싼 match key로 후보를 먼저 줄이는 방식이다.

**정규화(normalize):** match key 값을 만드는 과정에서 matching rule 필드 값은 **정규화(normalize)**된다.

---

## Duplicate Rules — 중복 발견 시 동작

Duplicate rule은 사용자가 **중복으로 식별된 레코드를 저장하려 할 때의 동작**을 정의하며, **어떤 matching rule로 중복을 식별할지 선택**한다.

- 레코드 **생성 또는 편집** 시 동작하도록 구성할 수 있다.
- **활성화 조건:** duplicate rule 활성화가 성공하려면, 연결된 **모든 matching rule이 active**여야 한다.

### 한도 (Limits)

> help.salesforce 원문 기준. 오브젝트 단위로 적용된다.

| 한도 항목 | 값 |
|---|---|
| 오브젝트당 활성 duplicate rule | 최대 **5개** |
| 각 duplicate rule에 추가할 수 있는 matching rule | 최대 **3개** |
| duplicate rule 1개 기준 오브젝트당 활성 matching rule | **1개** |
| 여러 duplicate rule 사용 시 오브젝트당 활성 matching rule | 최대 **5개** |

### Report 옵션과 Duplicate Record Set
duplicate rule의 **Report** 옵션을 선택하면 다음이 일어난다.

- 저장된 레코드 + 최대 개수의 중복이 **새 또는 기존 duplicate record set**에 재할당되고, **duplicate record item**으로 나열된다.
- **레코드당 최대 100개**의 중복까지 나열된다.
- **cross-object 규칙**의 중복도 처리한다.
- 단, 중복 lead가 record set이 생성되기 전에 변환되면 그 lead는 **record set에 포함되지 않는다**.

### 사용자 접근 권한의 영향
레코드를 업데이트하는 사용자가 **matching rule이 참조하는 필드에 접근 권한이 없으면**, 규칙 동작에 영향을 준다.

### 미지원 항목
- duplicate rule에서 **global picklist value set 미지원**.
- cross-object duplicate rule에 쓰이는 matching rule에서 **custom picklist 필드 미지원**.

### Rollup summary 값 변경 시
**rollup summary 필드 값**이 변경되면 duplicate rule이 실행되고, **Allow 옵션이 적용**된다.

> Roll-Up Summary 필드 자체의 동작은 [[Roll-Up Summary 필드]] 참조.

---

## Duplicate Rule이 실행되지 않는 조건

아래 상황에서는 duplicate rule이 **동작하지 않는다**.

- **Quick Create** 또는 **Community Self-Registration**으로 레코드가 생성될 때
- **Lead 변환**(단, *Use Apex Lead Convert*를 사용하지 않는 경우)
- **Undelete**로 레코드를 복원할 때
- **Lightning Sync** 또는 **Einstein Activity Capture**로 레코드가 추가될 때
- 레코드를 **수동으로 merge**할 때
- **Self-Service 사용자**가 *Use...* 조건 규칙으로 레코드를 생성할 때
- 규칙 조건이 **lookup relationship 필드**인데 그 필드에 값이 없을 때

---

## 설정이 오버라이드되는 조건 (알림 없이 저장)

아래 상황에서는 duplicate rule 설정이 오버라이드되어, **중복 알림 없이 레코드가 저장**된다.

- **data import 도구**를 사용할 때 → [[Data Import Wizard]], [[Data Loader]]
- **person account를 business account로 변환**할 때
- **Salesforce API**를 사용할 때

---

## 그 밖의 동작 주의점

- **동시 저장 타이밍:** 여러 레코드를 **동시에 저장**하면서 **block 규칙**이 적용될 때는 타이밍에 주의가 필요하다.
- **Translation Workbench:** duplicate rule의 커스터마이즈 가능한 **alert 텍스트**는 Translation Workbench에서 지원되지 않는다.

---

## 두 개의 청소 축 — 신규 저장 방지 vs 기존 레코드 청소

Duplicate Rule은 **신규/편집 저장 시점**에 중복을 막는 *예방* 축이다. 그러나 규칙 도입 이전부터 org에 쌓인 **기존 중복 레코드**는 저장 시점 규칙으로는 잡히지 않는다. 이를 사후에 배치로 훑어 청소하는 별도 축이 **Duplicate Jobs**이며, 두 축 모두 결과를 **Duplicate Record Set**으로 모은다.

| 축 | 도구 | 시점 | 결과물 |
|---|---|---|---|
| 신규 저장 방지(예방) | **Duplicate Rule** (+ Matching Rule) | 레코드 생성·편집 저장 시 | Alert/Block, Report 시 Duplicate Record Set |
| 기존 레코드 청소(사후) | **Duplicate Job** (+ Matching Rule) | 관리자가 Setup에서 배치 실행 | Duplicate Record Set + Duplicate Record Item |

---

## Duplicate Jobs — 기존 레코드 배치 스캔

**Duplicate Job**은 표준 또는 커스텀 **matching rule**로 org의 기존 **business/person account·contact·lead**를 스캔해 이미 존재하는 중복을 찾아낸다. Duplicate Rule이 저장 시점 예방이라면, Duplicate Job은 **이미 저장된 데이터를 사후에 훑는** 도구다.

**Available in:** Lightning Experience + Salesforce Classic (not available in all orgs).
**Editions:** **Performance, Unlimited** 에디션만. (Duplicate Rule/Record Set과 달리 Essentials/Professional/Enterprise/Developer에서는 미제공 — 에디션이 라이선스 전제)
**필요 권한:** *Customize Application* **AND** *View All Data*.

### Setup 실행 절차
1. **Setup → Quick Find → Duplicate Jobs**.
2. **New Job** 클릭.
3. 오브젝트 선택 → 기존 **matching rule** 선택 또는 새로 생성(선택한 오브젝트의 matching rule만 표시됨).
4. (선택) 기본 job 이름 편집 → **Run**.
   - job 생성 후에는 **이름·설명을 삭제·편집할 수 없다**. 데이터 보호/프라이버시 규정 준수 시 이름·설명에 개인정보를 넣지 않도록 고려.
5. job 요약 페이지가 상태를 표시하며, **완료 시 이메일 알림**을 받는다.
6. **재실행:** New Job에서 같은 오브젝트 + matching rule 선택.
7. **중복 확인·병합:** job 요약 페이지 → record set 열기 → **Related** 탭 → **Compare and Merge** 액션. (사용자가 병합하려면 duplicate record set 접근 권한 필요)
8. **결과 공유:** job이 생성한 duplicate record set에 대해 리포트 실행.

### Duplicate Job 한도·주의 (Things to Know)
- **커스텀 오브젝트:** job은 커스텀 오브젝트에도 돌릴 수 있으나 **Compare and Merge 미지원**(찾기만 가능, 병합 불가).
- **덮어쓰기:** 완료된 job과 **같은 설정(오브젝트 + matching rule)**으로 새 job을 만들면 이전 job을 덮어쓴다(실행 전 확인 알림).
- **matching rule 수정 후 재실행:** 사용한 matching rule을 편집한 뒤 그 rule로 다시 실행하면 **알림 없이 첫 job 결과가 삭제**된다.
- **1,000,000건 상한:** 모든 완료 job의 중복 총합이 **1,000,000건**에 도달하면 새 job을 실행할 수 없다. duplicate record item이 1,000,000 미만으로 떨어질 때까지 일부 job 결과를 삭제해야 한다.
- 레코드가 많은 org에서는 duplicate job이 **실패**할 수 있다.
- **결과 삭제 후에도 job 정보는 보존**된다: 스캔한 레코드 수, 발견한 중복 세트 수, 발견한 개별 중복 수.
- **list view 연동:** 각 job마다 duplicate record set의 **list view**가 생성된다. list view만 삭제하면 set·item·Setup의 job 정보는 유지되지만, **Setup에서 job 결과를 삭제하면** 해당 list view·duplicate record set·duplicate record item이 **모두 삭제**된다.
- **필수 커스텀 필드:** job이 생성한 duplicate record set/item 레이아웃에 **required custom field**가 있으면 job이 실패한다.

---

## Duplicate Record Sets — 중복 그룹 오브젝트 (DuplicateRecordSet / DuplicateRecordItem)

**Duplicate Record Set**은 중복으로 식별된 항목들의 목록으로, **duplicate rule(Report 액션) 또는 duplicate job이 실행될 때 생성**된다. 실제 중복 그룹과 그 구성 레코드는 두 표준 오브젝트로 표현된다.

**Available in:** Lightning Experience + Salesforce Classic (not available in all orgs).
**Editions:** Essentials, Professional, Enterprise, Performance, Unlimited, Developer.
**필요 권한:** set·item 보기 = account/contact/lead에 *View*; item 병합 = account/contact/lead에 *Edit* 및 *Delete*. 접근 권한은 **Sales Cloud / Service Cloud / Sales & Service Cloud 라이선스** 사용자에게 부여할 수 있다.

### 두 오브젝트
| 오브젝트 | 표현하는 것 | 핵심 필드 | 생성/접근 전제 |
|---|---|---|---|
| **DuplicateRecordSet** | 중복으로 식별된 레코드 **그룹**. 하나 이상의 duplicate record item 포함. custom report type·duplicate job 결과 조회에 사용 | **DuplicateRuleId** (이 목록을 식별한 duplicate rule 참조) | duplicate rule 활성화 필요 |
| **DuplicateRecordItem** | 중복으로 식별된 **개별 레코드**. DuplicateRecordSet에 포함되며 duplicate job에서 처리됨 | **DuplicateRecordSetId** (소속 set으로의 lookup 관계, Refers To = DuplicateRecordSet) | Duplicate Management 활성화, Sales Cloud/CRM 라이선스 |

지원 호출(두 오브젝트 공통): `create()`, `delete()`, `query()`, `retrieve()`, `update()`, `upsert()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `undelete()`.

### 조회·수동 생성·병합
- **조회:** LEX는 App Launcher → **Duplicate Record Sets**; Classic은 **Duplicate Record Sets** 탭. list view는 **Table view로만** 표시된다.
- **job 링크:** job이 생성한 record set은 기본적으로 job으로의 링크를 포함하지 않는다 → Lightning App Builder로 레이아웃에 **Parent** 필드를 추가하면 링크가 표시된다.
- **수동 생성**(규칙이 잡지 못한 중복 관리): DRS list view에서 **New** → **Duplicate Rule** 필드에 duplicate rule 지정 또는 **Parent** 필드에 duplicate job 지정 → Related 탭에서 **New**(item 추가; Classic은 *New Duplicate Record Item*).
- **병합:** **Lightning Experience에서만** set 안의 중복을 **Compare and Merge** 액션으로 병합한다.

---

## 중복 관리 흐름 (구조)

```
// 구조 예시 — 중복 관리 흐름(실제 원본 다이어그램 아님)
Matching Rule (무엇이 중복인가)
   match key formula(후보 100건으로 축소) → matching equation(method+algorithm)
        ▼ 참조
Duplicate Rule (발견 시 동작)  ── 오브젝트당 활성 5개, 각 rule에 matching rule 3개
   Action: Allow(알림/Report) | Block
   활성화 조건: 연결된 모든 matching rule active
안 도는 경우: 데이터 import·API·merge·undelete·lead convert(Apex 미사용) 등
```

---

## 관련 노트
- [[Data Import Wizard]] — 데이터 import 도구는 duplicate rule을 오버라이드(알림 없이 저장)한다.
- [[Data Loader]] — 대량 적재 시 duplicate rule을 오버라이드(알림 없이 저장)한다.
- [[Roll-Up Summary 필드]] — rollup summary 값 변경 시 duplicate rule이 실행되며 Allow 옵션이 적용된다.
