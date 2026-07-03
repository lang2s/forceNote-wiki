---
tags: [admin, record-types, business-process, picklist, page-layout, customization]
source: help.salesforce.com (Salesforce Help — Extend Salesforce with Clicks, Not Code; Tailor Business Processes to Different Record Types; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=platform.customize_recordtype.htm&type=5
created: 2026-07-03
aliases: [Record Types, 레코드 타입, Business Process, 비즈니스 프로세스, Master Record Type, Sales Process, Support Process]
---

# Record Types (레코드 타입)

> 같은 오브젝트에서 사용자 그룹마다 **다른 비즈니스 프로세스·피클리스트 값·페이지 레이아웃**을 제공하는 구성물. 프로파일(또는 permission set) × 레코드 타입 조합이 표시 레이아웃을 결정한다.

---

## 개념

**Record type**은 하나의 오브젝트를 쓰는 서로 다른 사용자 그룹에게 **different business processes, picklist values, and page layouts**를 제공한다. 즉, 동일한 오브젝트라도 사용자에 따라 다른 프로세스와 화면을 노출할 수 있다.

- 예: 하나의 Opportunity 오브젝트에서 **일반 세일즈 딜(standard sales deal)** 과 **전문 서비스 계약(professional services agreement)** 을 서로 다른 record type으로 구분해, 각각에 맞는 피클리스트 값과 레이아웃을 제공한다.

**Available in:** Professional, Enterprise, Performance, Unlimited, Developer Edition. (Salesforce Classic + Lightning Experience)

## --Master-- record type

- 시스템이 자동 생성하는 record type.
- 레코드에 연결된 **커스텀 record type이 없을 때** 사용되는 기본값이다.
- 조직이 커스텀 record type을 만들지 않았거나, 사용자에게 커스텀 record type이 할당되지 않은 경우 이 --Master-- 가 적용된다.

## Business processes (비즈니스 프로세스)

**Multiple business processes**를 만들어 record type별로 서로 다른 피클리스트 값을 표시한다. 비즈니스 프로세스는 특정 오브젝트의 상태/단계 피클리스트 값 집합을 정의하며, 각 record type에 연결된다.

만들 수 있는 business process 종류:

| Business Process | 대상 |
|---|---|
| **Sales process** | Opportunity 의 Stage 값 |
| **Support process** | Case 의 Status 값 |
| **Lead process** | Lead 의 Status 값 |
| **Solution process** | Solution 의 Status 값 |

각 process를 만든 뒤 해당 record type에 연결(associate)하면, 그 record type을 쓰는 사용자에게 지정된 피클리스트 값만 표시된다.

## 할당·표시 로직

- Record type은 **프로파일(profile)** 또는 **permission set** 을 통해 사용자에게 할당된다 (profile/permission set 의 record type assignments).
- 조직이 record type을 사용하는 경우, **사용자의 프로파일 + record type 조합**이 실제로 표시되는 **page layout** 을 결정한다.

```
// 구조 예시 — Record Type 개념(실제 원본 다이어그램 아님)
Object(Opportunity)
 ├─ Record Type: "Standard Sales"  → Sales Process A(피클리스트 값 집합) + Page Layout X
 ├─ Record Type: "Pro Services"    → Sales Process B                    + Page Layout Y
 └─ --Master-- (커스텀 타입 없을 때 기본)
할당: Profile(또는 Permission Set)의 record type assignments
표시: Profile × Record Type → Page Layout 결정
```

## 생성 전 준비 (considerations)

- Record type을 만들기 **전에**, 가능한 **모든 record type 값을 master picklist에 포함**시켜 둔다. Master picklist에 없는 값은 record type에서 노출할 수 없다.
- 피클리스트·business process 관련 **considerations 및 limitations** 가 존재하므로, 실제 구성 전 공식 문서의 해당 항목을 확인한다.
  - 공식: [Tailor Business Processes to Different Record Types](https://help.salesforce.com/s/articleView?id=platform.customize_recordtype.htm&type=5)

## 관련 노트
- [[Page Layouts (페이지 레이아웃)]] — record type × 프로파일 조합이 실제 표시 레이아웃을 결정한다.
- [[Profiles (프로파일)]] — record type을 사용자에게 할당하는 기본 그릇(record type assignments).
- [[Permission Sets (권한 집합)]] — record type assignments를 추가로 부여하는 수단.
