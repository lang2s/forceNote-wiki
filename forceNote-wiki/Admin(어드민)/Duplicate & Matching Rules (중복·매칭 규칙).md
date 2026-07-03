---
tags: [admin, duplicate-rules, matching-rules, data-quality, deduplication]
source: help.salesforce.com (Salesforce Help — Data Quality; Things to Know About Duplicate Rules + Things to Know About Matching Rules; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=sales.duplicate_rules_overview.htm&type=5
created: 2026-07-03
aliases: [Duplicate Rules, Matching Rules, 중복 규칙, 매칭 규칙, Duplicate Management, Match Key, Matching Method]
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
