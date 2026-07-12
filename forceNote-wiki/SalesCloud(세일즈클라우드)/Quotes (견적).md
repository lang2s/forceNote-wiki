---
tags: [sales-cloud, quotes, quote-line-items, quote-sync, opportunity]
source: help.salesforce.com (Salesforce Help — Sales Basics; Quotes + How Quote Syncing Works; Enable Quotes; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=sales.quotes_overview.htm&type=5
official_doc_enable: https://help.salesforce.com/s/articleView?id=sales.quotes_enable.htm&type=5
created: 2026-07-03
aliases: [Quotes, 견적, Quote Line Items, Quote Sync, 견적 동기화, Quote PDF]
---

# Quotes (견적)

> opportunity에서 만든 제품·서비스의 **제안 가격(견적)** 레코드. quote sync로 opportunity와 제품 목록을 양방향 동기화하며, 한 opportunity는 여러 quote를 갖되 한 번에 하나만 sync한다.

---

## ⚠️ 전제조건 — Quotes 활성화

Quotes는 **기본적으로 비활성**이다. 활성화 전에는 quote·quote line item·quote sync 기능이 나타나지 않는다. 아래를 먼저 설정해야 한다.

1. **Setup → Quick Find에 `Quote Settings` 입력**(Salesforce Classic에서는 `Quotes Settings`) → **Enable Quotes**를 켠다.
2. quote가 opportunity에서 보이도록, **opportunity 페이지 레이아웃에 Quotes 관련 목록(related list)을 추가**한다.

활성화 후에야 opportunity에서 quote를 생성하고 이 노트의 sync 동작을 사용할 수 있다.

> 활성화 절차 상세는 official_doc_enable 참조 (Enable Quotes).

---

## 개념 — Quote란

**Quote(견적)**는 opportunity로부터 생성되며, 고객에게 제안하는 제품·서비스의 **제안 가격(proposed price)**을 나타내는 레코드다. quote에 담기는 제품은 **Quote Line Items(견적 라인 항목)**로 관리된다.

한 opportunity에 대해 여러 quote를 만들어 서로 다른 가격 시나리오(예: 할인 조건별, 수량별)를 제시할 수 있다.

| 요소 | 설명 |
|---|---|
| Quote | opportunity에서 생성된 제안 가격 레코드 |
| Quote Line Items | quote에 포함된 개별 제품·서비스 항목 |
| 관계 | 한 opportunity → 여러 quote 가능 (단, 한 번에 하나만 sync) |

---

## Quote Syncing (견적 동기화)

**Quote Syncing**은 quote를 그것이 생성된 **opportunity에 연결**하고, 두 레코드의 모든 업데이트를 동기화한다.

- 한 opportunity는 **여러 quote**를 가질 수 있으나, **한 번에 하나의 quote와만 sync**한다.
- sync를 중지하거나 두 레코드 중 하나를 삭제할 때까지 **양방향으로 계속 sync**된다.

### 양방향 동작

sync 중에는 한 레코드의 제품 목록에 대한 추가·변경이 다른 레코드에 반영된다.

| 변경 발생 위치 | 반영되는 곳 |
|---|---|
| quote에서 line item 추가/제거 | synced opportunity의 **Products 관련 목록** 갱신 |
| opportunity에서 제품 추가/제거 | synced quote의 **Quote Line Items 관련 목록** 갱신 |
| 제품 **정렬(sorting)** 변경 | 양쪽에 반영 (정렬도 sync됨) |

### 제품이 없는 경우

제품이 없는 quote·opportunity도 sync할 수 있다. 이 경우 **한쪽에 제품을 추가하면 synced 레코드에 자동으로 추가**된다.

> Quote PDF 생성 등 quote 산출물 관련 기능은 공식 문서에 위임한다 — 위 `official_doc` 참조.

---

## 구조 — Sync 관계도

```
// 구조 예시 — Quote ↔ Opportunity Sync(실제 원본 다이어그램 아님)
Opportunity ──(다수 quote 가능, 1개만 sync)──▶ Quote
   Products 관련목록  ◀── 양방향 sync ──▶  Quote Line Items
   추가/제거/정렬 변경이 양쪽에 반영 · 제품 없어도 sync 가능
   sync 중지 또는 레코드 삭제 시까지 지속
```

---

## 관련 노트
- [[Sales Cloud 개요]] — Sales Cloud 시리즈 허브
- [[Opportunities (기회)]] — quote가 생성·sync되는 소스 레코드
- [[Products & Price Books (제품·가격표)]] — quote line item의 제품·가격 원천
- [[Contracts & Orders (계약·주문)]] — 견적 → 주문/계약으로 이어지는 영업 흐름
- [[CPQ Quote API]] — 고급 견적(구성·가격 규칙)으로의 확장
- [[Revenue Cloud 개요]] — 구성·가격·청구가 필요할 때의 고급 제품(기본 vs 고급 대비)
- [[견적 제품 선택 — 표준 Quote vs CPQ vs Revenue Cloud (RLM)]] — 어느 견적 제품을 쓸지 결정 가이드(표준 Quote vs CPQ vs RLM)
