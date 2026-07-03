---
tags: [admin, schema-builder, data-model, custom-object, relationships, customization]
source: help.salesforce.com (Salesforce Help — Extend Salesforce with Clicks, Not Code; Design Your Own Data Model With Schema Builder; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=platform.schema_builder.htm&type=5
created: 2026-07-03
aliases: [Schema Builder, 스키마 빌더, Data Model, 데이터 모델, ERD, Object Relationships 시각화]
---

# Schema Builder (스키마 빌더)

> 조직의 모든 오브젝트와 관계를 **시각적으로 보고 수정**하는 동적 환경. 드래그앤드롭으로 커스텀 오브젝트·필드·관계(lookup·master-detail)를 추가하고 기존 스키마를 ERD처럼 조망한다.

---

## 개요

Schema Builder는 앱의 **모든 오브젝트와 관계를 보고 수정**할 수 있는 동적(dynamic) 환경을 제공한다. 기존 스키마를 조망하는 동시에, 새 **custom object·custom field·관계**를 **인터랙티브(드래그앤드롭)** 방식으로 추가할 수 있다.

캔버스는 각 오브젝트를 박스로 표시하며, field 값·required 필드·오브젝트 간 관계 같은 세부 정보를 함께 보여준다. 즉, 데이터 모델을 ERD(Entity Relationship Diagram)처럼 한눈에 파악하고 그 자리에서 변경할 수 있다.

**Available in:** **All Editions** (Salesforce Classic + Lightning Experience).

## 접근 방법

1. Setup으로 이동한다.
2. Quick Find 상자에 `Schema Builder`를 입력한다.
3. **Schema Builder**를 선택한다.

## Schema Builder로 추가할 수 있는 것

Schema Builder에서는 다음 요소를 인터랙티브(드래그앤드롭)로 추가할 수 있다.

- Custom objects
- Lookup relationships
- Master-detail relationships
- **Geolocation을 제외한 모든 custom field**

> Geolocation custom field만 Schema Builder에서 추가할 수 없다. 그 외 모든 custom field 타입은 지원된다.

## 캔버스 개념도

```
// 구조 예시 — Schema Builder 캔버스(실제 원본 다이어그램 아님)
Setup → Quick Find: "Schema Builder" → Schema Builder
[캔버스] 오브젝트 박스(필드·required 표시) ── 관계선(lookup / master-detail)
드래그앤드롭 팔레트: Custom Object · Lookup · Master-Detail · 모든 Custom Field(단 Geolocation 제외)
```

## 관련 노트
- [[Object Relationships]] — Schema Builder가 시각화·생성하는 lookup/master-detail 관계
