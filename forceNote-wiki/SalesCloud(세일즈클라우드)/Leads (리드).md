---
tags: [sales-cloud, leads, lead-conversion, web-to-lead, assignment-rules]
source: help.salesforce.com (Salesforce Help — Sales Basics; Leads / 리드 전환 FAQ / Web-to-Lead / Lead Assignment Rules; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=sales.faq_leads_what_happens_when.htm&type=5
source_web_to_lead: help.salesforce.com — How many leads can we capture (500/day) (sales.faq_leads_how_many_leads) · Setting Up Web-to-Lead (sf.setting_up_web-to-lead), Tier 2
source_assignment_rules: help.salesforce.com — Assignment Rules / Guidelines (only one rule active at a time) (sf.customize_leadrules), Tier 2
source_field_mapping: help.salesforce.com — Map Custom Lead Fields (customize_mapleads) · Convert Qualified Leads (leads_convert), Tier 2 (web.archive.org 공식 스냅샷 원문 대조, 2026-07-06)
created: 2026-07-03
aliases: [Leads, 리드, Lead Conversion, 리드 전환, Web-to-Lead, Lead Assignment Rules, 리드 할당 규칙, Map Lead Fields, 리드 필드 매핑, Convert Leads 권한, 전환 버튼 안 보임]
---

# Leads (리드)

> 지속적 관계가 확실해지기 전의 잠재고객(prospect) 데이터를 수집하는 레코드. 전환(convert) 시 Account·Contact·Opportunity로 바뀌며, 전환된 lead는 더 이상 조회 불가하되 리포트에는 데이터로 기여한다.

---

## 개념 — Lead란?

Lead는 어떤 사람이 조직과 **지속적인 관계를 맺을지 확실해지기 전 단계**에서 그 prospect(잠재고객)에 대한 데이터를 수집하는 레코드다. 아직 검증되지 않은 초기 관심 단계의 정보를 담아두고, 검증이 끝나면 정식 영업 개체(Account·Contact·Opportunity)로 전환한다.

Lead에 내장된 핵심 기능:

- **Field mapping** — lead 필드를 전환 대상(account·contact·opportunity) 필드로 매핑
- **Ownership 자동 할당 (auto-assignment)** — 소유자를 자동으로 배정
- **전환 (Conversion)** — Contact·Account·Opportunity로 변환

---

## Lead Conversion (리드 전환)

Lead를 전환하면 lead 하나가 Account·Contact·Opportunity 레코드로 바뀐다. 전환 시 동작은 다음과 같다.

- 전환 시 **새 account를 만들거나 기존 account에 연결**한다.
  - **새 account를 선택하면 새 Contact가 함께 생성**된다.
  - **기존 account를 선택하면**, 그 account에 이미 연결돼 있는 **기존 Opportunity를 선택**할 수 있다. (기존 opportunity로의 전환은 account가 이미 존재할 때만 가능하다.)
- 전환 시 lead의 **모든 open activity와 activity history가 새 account·contact·opportunity로 전환·첨부**된다.
- **전환된 lead 레코드는 더 이상 조회할 수 없다.** 다만 리포트에는 데이터로 계속 기여한다.

> 요약: 전환은 lead → (Account + Contact) [+ Opportunity 선택]. 새 account면 Contact 신규 생성, 기존 account면 그 account의 기존 opportunity에 연결 가능.

---

## Lead Field Mapping 설정 (Map Lead Fields)

**표준 lead 필드는 자동으로 매핑된다** — 전환 시 표준 lead 필드의 값은 표준 account·contact·opportunity 필드로 자동으로 들어간다(Lead Conversion Mapping). **설정이 필요한 것은 커스텀 필드**다.

### 설정 위치·절차

```
// 설정 경로 (Lightning Experience)
Setup → Object Manager → Lead → Fields & Relationships → [Map Lead Fields] 버튼
  (Classic: Setup → Customize → Leads → Fields → Map Lead Fields)

1. Account / Contact / Opportunity 탭별로,
   각 커스텀 lead 필드 → 전환 시 값을 넣을 커스텀 대상 필드 선택
2. Save
```

- 필요 권한: **Customize Application** (관리자 설정 권한)
- 매핑 화면은 **Account · Contact · Opportunity 탭**으로 나뉘며, 커스텀 lead 필드 하나당 대상 오브젝트의 커스텀 필드 하나를 지정한다.

### 타입 호환 제약 (공식 문서 규칙)

원칙: **같은 데이터 타입의 커스텀 필드끼리** 매핑한다 (숫자 ↔ 숫자, long text area ↔ long text area 등). 예외·세부 규칙:

| 규칙 | 내용 |
|---|---|
| Text ↔ Picklist | 매핑 가능. 단 대상 text 필드 길이가 부족하면 **값이 잘릴(truncate) 수 있음** |
| Text / Text Area → Long Text Area | 매핑 가능 |
| Auto-Number → Text · Text Area · Picklist | 매핑 가능 |
| Formula 필드 | **매핑 금지** — 커스텀 formula 필드는 다른 formula 필드든 다른 어떤 타입이든 매핑하지 않는다 |
| Number · Currency · Percent | **길이와 소수 자릿수까지 정확히 동일**해야 함 (예: 길이 3·소수 2 통화 필드 → 길이 3·소수 2 통화 필드) |
| 비어 있는 표준 picklist | 대상 account·contact·opportunity의 **기본(default) picklist 값**으로 매핑됨 |

> ⚠️ 매핑에 사용 중인 커스텀 필드의 **데이터 타입을 변경하면 해당 lead field mapping이 삭제**된다.

---

## 트러블슈팅 — 전환이 안 될 때

전환(Convert) 버튼이 안 보이거나 전환이 실패하면 아래를 순서대로 확인한다.

### ① 사용자 권한 (공식 요구 권한)

전환에는 프로필/권한 집합에 다음이 **모두** 필요하다:

- **"Convert Leads"** 권한
- Lead·Account·Contact·Opportunity에 대한 **"Create" + "Edit"** 권한
- 관련 캠페인이 있으면 해당 Campaign에 대한 **"Read"** 권한

하나라도 빠지면 Convert 버튼이 노출되지 않거나 전환이 거부된다.

### ② 페이지 레이아웃

Lead 페이지 레이아웃/Highlights Panel 액션에 **Convert 버튼이 배치돼 있는지** 확인한다. 권한이 있어도 레이아웃에서 버튼이 제거돼 있으면 보이지 않는다.

### ③ 검증 규칙 · 중복 관리 · Apex 트리거

- 전환은 Account·Contact·Opportunity 레코드를 **생성**하므로, 대상 오브젝트의 **검증 규칙(validation rule)이나 Apex 트리거가 생성을 차단**하면 전환이 실패한다. ("Require Validation for Converted Leads" 설정이 켜져 있으면 전환 산출물에도 검증·트리거가 적용된다.)
- 전환 시 중복 레코드가 감지되면 **Duplicate Management / Apex Lead Convert 설정**에 따라 중복 해결을 요구받을 수 있다.

### ④ 이미 전환된 리드

**전환 완료된 lead는 원래 조회 불가**다(버그 아님 — 위 "Lead Conversion" 섹션 참조). 또한 **전환은 되돌릴 수 없다(can't reverse)**.

---

## Web-to-Lead (웹-투-리드)

웹사이트에서 lead를 생성하는 기능. 웹 폼 제출을 받아 Salesforce에 lead 레코드로 만든다(폼 제출 → lead 레코드).

### ⚠️ 전제조건 — 먼저 활성화 + HTML 폼 생성

폼만 붙인다고 동작하지 않는다. 다음을 먼저 해야 한다.

1. **Setup → Web-to-Lead에서 기능을 활성화**한다.
2. Salesforce가 생성해 주는 **HTML 폼을 만들어** 웹사이트에 게시한다. 이 폼이 제출되면 lead 레코드가 생성된다.

### 한도·주의

- **하루 최대 500건**까지만 lead를 캡처한다.
- **500건을 초과한 제출분**은 lead로 생성되지 않고, **default lead creator에게 이메일로 보내지거나 보류**된다(무한정 캡처 아님).

---

## Lead Assignment Rules (리드 할당 규칙)

Lead를 사용자 또는 큐(queue)에 **자동으로 배정(auto-route)**하는 규칙. 유입된 lead가 정해진 조건에 따라 적절한 소유자/큐로 자동 라우팅된다.

### ⚠️ 실무 함정

- **활성 규칙은 한 번에 단 1개뿐** — 여러 할당 규칙을 만들 수 있지만, active로 지정 가능한 규칙은 동시에 하나만이다.
- **'Assign using active assignment rules' 체크박스가 켜져 있어야 실제로 돈다** — lead 저장 시 이 체크박스가 활성 규칙을 적용한다. 수동으로 lead를 생성할 때는 기본적으로 적용되지 않을 수 있으므로, 규칙을 태우려면 이 체크박스를 켜야 한다.

---

## 전환 흐름 (구조)

```
// 구조 예시 — Lead 전환(실제 원본 다이어그램 아님)
Web-to-Lead / 수동 → Lead (prospect)
   Lead Assignment Rules → 소유자/큐 자동 배정
   Convert:
     → Account(신규 or 기존)  [신규면 Contact도 생성]
     → Contact
     → Opportunity(신규 or 기존 account의 기존 opp)
   open activity·history 이관 · 전환된 lead는 조회 불가(리포트엔 기여)
```

---

## 관련 노트
- [[Sales Cloud 개요]] — Sales Cloud 시리즈 허브
- [[Opportunities (기회)]] — 전환 산출물
- [[Accounts & Contacts (거래처·연락처)]] — 전환 산출물
- [[Campaigns (캠페인)]] — lead를 campaign member로
