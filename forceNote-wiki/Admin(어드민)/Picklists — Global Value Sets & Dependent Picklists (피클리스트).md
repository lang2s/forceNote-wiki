---
tags: [admin, customization, picklist, global-value-set, dependent-picklist]
source: help.salesforce.com (Salesforce Help — Global Picklist Value Set / Dependent Picklists; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=sf.fields_about_dependent_fields.htm&type=5
created: 2026-07-03
aliases: [Picklists, 피클리스트, Global Value Set, 전역 값 집합, Dependent Picklist, 종속 피클리스트, Controlling Field, Field Dependency]
---

# Picklists — Global Value Sets & Dependent Picklists (피클리스트)

> 정해진 값 목록 필드. **Global Value Set**으로 값을 여러 오브젝트에서 공유하고(승격 후 강등 불가), **Dependent Picklist**로 controlling field 값에 따라 표시 값을 필터링한다.

---

## Picklist 기본

Picklist는 미리 정의된 값 중에서 하나(또는 multi-select의 경우 여러 개)를 선택하는 필드다. 값은 다음과 같이 관리한다.

- 값 **추가(add)**
- 값 **편집(edit)**
- 값 **비활성화(deactivate) / 재활성화(reactivate)**
- 값 **제거(delete)**

---

## Global Value Set (전역 값 집합)

picklist 값을 **다른 오브젝트와 공유**하려면, custom picklist를 global value set으로 **승격(promote)**한다.

- 승격하면 원본 custom picklist는 그 global value set을 **참조**한다.
- 그 값 집합은 이후 **다른 custom picklist에서도 사용** 가능하다 — 여러 오브젝트가 동일한 값 목록을 공유한다.

> [!warning] **강등 불가**
> global value set으로 승격한 뒤에는 **강등(demote)할 수 없다.** 승격은 되돌릴 수 없는 작업이므로 공유가 필요한 값 집합에만 적용한다.

---

## Dependent Picklist (종속 피클리스트)

Dependent picklist는 유효 값이 **다른 필드(controlling field)의 값에 따라 달라지는** (multi-select) picklist다.

### Controlling field 요건

controlling field는 **같은 레코드**의 다음 필드 중 하나여야 한다.

| controlling field 타입 | 조건 |
|---|---|
| Picklist | 값이 **1개 이상이고 300개 미만** |
| Checkbox | (조건 없음) |

### Field dependency matrix

controlling 값별로 표시할 dependent 값을 **field dependency matrix**에서 지정한다.

- 맨 윗행 = **controlling 값**
- 열 = **dependent 값**
- **포함(include)**한 값은 그 controlling 값을 선택했을 때 dependent picklist에 **나타난다.**
- **제외(exclude)**한 값은 **나타나지 않는다.**

---

## 구조 개요

```
// 구조 예시 — Picklists(실제 원본 다이어그램 아님)
Custom Picklist ──promote(강등 불가)──▶ Global Value Set ──▶ 다른 오브젝트 공유
Dependent Picklist:
   Controlling Field(picklist <300값 또는 checkbox)
        └ Field Dependency Matrix(controlling 값별 include/exclude) → dependent 값 필터
```

---

## 관련 노트
- [[Custom Objects & Custom Fields (커스텀 오브젝트·필드)]] — picklist는 커스텀 필드 타입.
- [[Record Types (레코드 타입)]] — record type별 사용 가능한 picklist 값.
