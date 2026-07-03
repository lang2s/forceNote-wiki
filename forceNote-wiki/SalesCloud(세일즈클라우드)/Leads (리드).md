---
tags: [sales-cloud, leads, lead-conversion, web-to-lead, assignment-rules]
source: help.salesforce.com (Salesforce Help — Sales Basics; Leads / 리드 전환 FAQ / Web-to-Lead / Lead Assignment Rules; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=sales.faq_leads_what_happens_when.htm&type=5
created: 2026-07-03
aliases: [Leads, 리드, Lead Conversion, 리드 전환, Web-to-Lead, Lead Assignment Rules, 리드 할당 규칙]
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

## Web-to-Lead (웹-투-리드)

웹사이트에서 lead를 생성하는 기능. 웹 폼 제출을 받아 Salesforce에 lead 레코드로 만든다(폼 제출 → lead 레코드).

---

## Lead Assignment Rules (리드 할당 규칙)

Lead를 사용자 또는 큐(queue)에 **자동으로 배정(auto-route)**하는 규칙. 유입된 lead가 정해진 조건에 따라 적절한 소유자/큐로 자동 라우팅된다.

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
