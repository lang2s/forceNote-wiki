---
tags: [admin, customization, custom-objects, custom-fields, object-manager]
source: help.salesforce.com (Salesforce Help — Create Custom Objects / Object Manager; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=platform.creating_objects.htm&type=5
created: 2026-07-03
aliases: [Custom Objects, 커스텀 오브젝트, Custom Fields, 커스텀 필드, Object Manager, __c, 오브젝트 생성]
---

# Custom Objects & Custom Fields (커스텀 오브젝트·필드)

> 회사 고유 데이터를 담을 **커스텀 오브젝트**(`__c`)와 표준/커스텀 오브젝트에 **커스텀 필드**를 Object Manager에서 클릭으로 만든다. 필드 타입이 저장 데이터를 결정한다.

---

## Custom Object — 회사 고유 데이터 저장소

**커스텀 오브젝트**는 표준 오브젝트(Account·Contact 등)가 담지 못하는, 회사·산업 특유의 정보를 저장하는 오브젝트다. API 이름에 접미사 **`__c`** 가 붙는다.

생성 위치: **Setup → Object Manager → Create → Custom Object**

생성 시 지정하는 값:

| 항목 | 설명 |
|---|---|
| Label | 단수 표시 이름 |
| Plural Label | 복수 표시 이름 |
| Record Name | 레코드 식별 필드 이름 + 데이터 타입 **Text** 또는 **Auto Number** |
| 옵션 | reports 허용, activities, field history 추적, search 허용 등 |

지정한 옵션에 따라 이 오브젝트로 리포트를 만들거나, 활동(Task/Event)을 연결하거나, 필드 값 변경 이력을 추적하거나, 검색 대상에 포함시킬 수 있다.

---

## Custom Field — 오브젝트에 데이터 항목 추가

**커스텀 필드**는 표준·커스텀 오브젝트 어디에나 추가할 수 있는 데이터 항목이다.

생성 흐름: **Object Manager → (오브젝트) → Fields & Relationships → New**

1. **필드 타입 선택** — 저장할 데이터 종류 결정
2. 세부 입력 — Label·이름·길이·기본값 등
3. **field-level security (FLS)** 설정 — 프로파일별 가시성/편집 권한
4. **page layout** 추가 — 어느 레이아웃에 노출할지

---

## Field Type — 저장 데이터를 결정

필드 타입이 그 필드에 담기는 데이터를 결정한다. 대표 타입:

Text · Number · Currency · Percent · Date · Date/Time · Checkbox · Picklist · Email · Phone · URL · Formula · Roll-Up Summary · Lookup · Master-Detail 등.

> 필드 타입 전수 목록·타입별 세부 동작, 데이터 모델(관계·정규화) 세부는 이 노트에서 다루지 않고 아래 관련 노트로 위임한다. → [[Field Types]]

---

## 생성 흐름 (구조 요약)

```
// 구조 예시 — Custom Object & Field(실제 동작 코드 아님)
Setup → Object Manager
  Create → Custom Object:
    Label · Plural Label · Record Name(Text / Auto Number) · 옵션(reports · activities · history · search)
    → API명 __c

  (오브젝트) → Fields & Relationships → New:
    필드 타입 선택 → FLS(field-level security) → page layout
```

---

## 관련 노트
- [[Field Types]] — 커스텀 필드 타입 상세 목록·타입별 동작
- [[Object Relationships]] — Lookup·Master-Detail 관계
- [[Formula 필드]] — 자동 계산 필드 타입
- [[Schema Builder (스키마 빌더)]] — 오브젝트·관계 시각 생성
- [[Picklists — Global Value Sets & Dependent Picklists (피클리스트)]] — picklist·dependent picklist 커스텀 필드 타입
