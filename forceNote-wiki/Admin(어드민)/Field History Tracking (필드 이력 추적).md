---
tags: [admin, field-history-tracking, audit, field-audit-trail, data]
source: help.salesforce.com (Salesforce Help — Field History Tracking; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=sf.tracking_field_history.htm&type=5
created: 2026-07-03
aliases: [Field History Tracking, 필드 이력 추적, 필드 변경 추적, History Related List, Field Audit Trail]
---

# Field History Tracking (필드 이력 추적)

> 오브젝트 필드의 변경 이력(이전/이후 값·시각·변경자)을 추적하는 기능. 오브젝트당 **최대 20개 필드**, 활성화 시점부터 History 관련 목록에 기록된다.

---

## 개념

**Field History Tracking**은 특정 오브젝트에서 선택한 필드가 변경될 때, 그 변경 내역을 **History 관련 목록(History related list)**에 자동으로 기록하는 기능이다. 각 이력 항목은 다음을 포함한다.

- **날짜·시각** — 변경이 일어난 시점
- **변경 내용(nature of the change)** — 무엇이 어떻게 바뀌었는지
- **변경한 사람(who)** — 변경을 수행한 사용자

추적은 **활성화한 날짜·시각부터** 적용되며 **소급되지 않는다** — 활성화 이전에 발생한 변경은 기록되지 않는다.

---

## 설정 절차

1. **Setup → Quick Find** 에 `field history tracking` 입력 → **Field History Tracking** 선택
2. 추적할 오브젝트의 **View** 클릭
3. **Enable {OBJECT_NAME} History** 선택
4. 추적할 **필드 선택** (오브젝트당 **표준·커스텀 필드 조합 최대 20개**)
5. 오브젝트의 **page layout에 History 관련 목록을 추가**해 사용자에게 표시

```
// 구조 예시 — Field History Tracking(실제 동작 코드 아님)
Setup → Field History Tracking → (오브젝트) View → Enable {Object} History
  필드 선택(최대 20/오브젝트):
     Track old and new values  |  Track changes only(멀티피클리스트·롱텍스트)
  활성화 시점부터 → History 관련 목록: 날짜·시각·변경내용·변경자
  page layout에 History 관련 목록 추가
Shield: Field Audit Trail(연장 보존)
```

---

## 필드 선택 규칙

| 항목 | 내용 |
|---|---|
| **필드 개수** | 오브젝트당 표준·커스텀 필드 조합 **최대 20개** |
| **추적 시점** | 활성화한 **날짜·시각부터** (소급 아님) |
| **이전/이후 값 추적** | **Track old and new values** 에서 필드 선택 |
| **변경만 추적** | **multi-select picklist·large text 필드**는 값 변경 여부만 추적 (**Track changes only**) |

> **multi-select picklist와 large text 필드**는 이전/이후 값 자체를 저장하지 않고 **값이 변경되었다는 사실만** 추적한다(Track changes only).

---

## 표시

오브젝트에 추적을 활성화한 뒤, **page layout에 History 관련 목록**을 추가하면 레코드 상세 페이지에서 사용자가 변경 이력을 확인할 수 있다.

---

## Field Audit Trail (Shield)

기본 필드 이력 보존을 넘어 **연장된 필드 이력 보존**이 필요하면 Salesforce Shield의 **Field Audit Trail**을 사용한다. (세부 정책·보존 기간은 공식 문서 소관)

---

## 관련 노트
- [[Setup Audit Trail (설정 감사 추적)]] — 조직의 **설정(Setup) 변경** 추적. Field History Tracking이 **레코드 필드 데이터 변경**을 추적하는 것과 대비된다.
