---
tags: [sales-cloud, cpq, revenue-cloud, rlm, quoting, decision-guide, quote-to-cash]
source: 위키 내부 노트 synthesis (SalesCloud Quotes·CPQ API Models/Quote API·Revenue Cloud 개요 조합 — 각 노트의 Tier 2 소스 계승)
created: 2026-07-12
aliases: [견적 제품 선택, 견적 제품 비교, Quoting 제품 선택, 표준 Quote vs CPQ, CPQ vs Revenue Cloud, CPQ vs RLM, 어떤 견적 제품, quote product decision, "언제 CPQ를 쓰나", "표준 견적과 CPQ 차이", "신규 프로젝트에 CPQ 써도 되나", "CPQ end of sale"]
---

# 견적 제품 선택 — 표준 Quote vs CPQ vs Revenue Cloud (RLM)

> Salesforce에서 견적(quote)을 만드는 세 가지 제품 — **표준 Quotes**(Sales Cloud 기본), **Salesforce CPQ**(`SBQQ` managed package, **end-of-sale**), **Revenue Cloud / RLM**(platform-native 차세대) — 을 언제 어느 것으로 고를지 결정하는 노드. 각 제품의 상세 기능은 해당 노트로 위임하고, 여기서는 **비교와 선택**만 다룬다.

---

## 왜 이 노트가 필요한가

Salesforce에는 "견적을 만드는" 제품이 셋 존재하는데 이름·범위·라이프사이클 상태가 제각각이라 신규 프로젝트에서 무엇을 골라야 할지 혼동하기 쉽다. 특히 **Salesforce CPQ는 신규 판매가 종료(end-of-sale)** 되었으므로, 과거 자료를 보고 신규 구축에 CPQ를 채택하면 유지보수 모드 제품 위에 시스템을 짓는 실수가 된다. 이 노트는 세 제품을 한 표에서 대조하고, end-of-sale이 신규 도입 결정에 주는 영향을 명확히 한다.

---

## 3제품 한눈 비교표 ⭐

각 셀은 근거 노트(아래 `## 관련 노트`)에 검증된 사실만 반영한다.

| 축 | 표준 Quotes | Salesforce CPQ | Revenue Cloud / RLM |
|---|---|---|---|
| **제품 유형** | Sales Cloud **표준 기능** | **Managed package** (`SBQQ` 네임스페이스, Steelbrick 유래) | **Platform-native** 제품 (`PlaceQuote`·`RevSalesTrxn` 네임스페이스) |
| **비용/도입** | Sales Cloud에 **기본 포함**(추가 제품 구매 불필요) · **기본 비활성** → Setup에서 활성화 필요 | 별도 라이선스(managed package 설치) | 별도 라이선스(Revenue Cloud 제품군) |
| **제품 구성(configuration)** | 없음 — Opportunity의 제품을 그대로 담는 단순 라인(Quote Line Items) | **고급 번들 구성** — 옵션·피처·중첩 번들(OptionModel·ConfigurationModel 재귀), MDQ 세그먼트 | Platform-native 구성 엔진 |
| **가격규칙 복잡도** | 없음 — 라인별 제안 가격·수동 조정 수준 | **가격규칙 엔진** — 할인 규칙·파트너/추가 할인·계산 API(QuoteCalculator)·견적 약관(Quote Term) | Platform-native 가격/규칙 |
| **라이프사이클 상태** | **현행**(표준 기능, 계속 제공) | **End-of-sale** — 신규 판매 중단, 신규 기능 개발 없음(유지보수 모드) | **차세대**(신규 구축 권장 후속 아키텍처) |
| **신규 vs 기존 고객** | 모두 사용 가능 | **기존 고객만** 계속 제공(신규 도입 비권장) | **신규 구축 권장** 경로 |
| **대표 객체/API** | `Quote` · `QuoteLineItem`(Opportunity와 quote sync) | `SBQQ__Quote__c`·`SBQQ__QuoteLine__c` + `SBQQ/ServiceRouter` REST(Save/Calculate/Read Quote/Validate/Add Products/Read Product/Proposal/Term Reader) | `PlaceQuote`·`RevSalesTrxn` Apex 네임스페이스 |
| **상세 노트** | [[Quotes (견적)]] | [[CPQ Quote API]] · [[CPQ API Models]] | [[Revenue Cloud 개요]] |

> [!warning] CPQ는 신규 판매 종료(end-of-sale) — 근거 노트 실제 문구
> CPQ Developer Guide 인트로(Tier 2) 원문 인용:
> *"The Salesforce CPQ managed package continues to be available for existing customers, however, there is no longer any new feature development. For a more comprehensive and robust CPQ solution, we recommend exploring Revenue Cloud."*
>
> 레거시 Salesforce CPQ(Steelbrick managed package) 및 Salesforce Billing은 **2025-03-27자로 End of Sale**(신규 판매 중단)되었다. Salesforce 공식 입장은 신규/업데이트 고객에게 **Revenue Cloud Advanced(RCA, 구 Revenue Lifecycle Management / RLM)** 를 권장하는 것이며, **RCA는 CPQ의 업그레이드가 아니라 대체 아키텍처**다. (출처: [[CPQ API Models]], [[Revenue Cloud 개요]])

---

## 선택 기준 (결정 트리)

```text
// 구조 예시 — 결정 트리(실제 원본 다이어그램 아님). 각 분기 근거는 관련 노트 참조.

견적이 필요한가?
│
├─ 단순 제안 가격만 필요 · 번들/가격규칙 불필요 · 추가 제품 구매 없이 시작
│     → 표준 Quotes  ([[Quotes (견적)]] · Setup에서 Enable Quotes 후 사용)
│
├─ 복잡한 제품 구성(번들·옵션·중첩)·가격규칙·구독 견적이 필요
│   │
│   ├─ 신규 구축 / 장기 아키텍처 / platform-native 선호
│   │     → Revenue Cloud (RLM)  ([[Revenue Cloud 개요]]) ← 신규 권장 경로
│   │
│   └─ 기존 CPQ 자산(SBQQ 패키지·룰·템플릿)이 이미 있고 그 위에서 유지/확장
│         → Salesforce CPQ  ([[CPQ Quote API]] · 단 end-of-sale 유의)
│
└─ (혼동 방지) CPQ(SBQQ managed package)와 RLM(PlaceQuote·RevSalesTrxn)은 별개 제품
```

축별로 풀어 쓰면:

- **단순 견적·기본 제공으로 시작 → 표준 Quotes.** Opportunity에서 바로 제안 가격 레코드를 만들고 quote sync로 양방향 동기화하는 수준이면 충분하다. 별도 제품 구매가 필요 없고 Setup에서 활성화만 하면 된다.
- **복잡한 구성·번들·가격규칙 + 이미 보유한 CPQ 자산 → Salesforce CPQ (단 end-of-sale).** 기존에 `SBQQ` 패키지·가격 규칙·견적 템플릿·`ServiceRouter` 통합이 구축돼 있고 그것을 유지·확장하는 상황에서만 CPQ를 계속 쓴다. **신규 도입은 비권장** — 신규 기능 개발이 없는 유지보수 모드 제품이기 때문이다.
- **신규 구축·platform-native·장기 → Revenue Cloud (RLM).** 새 프로젝트에서 구성 가능한 제품·가격 규칙·구독·청구까지 필요하면 CPQ가 아니라 후속 platform-native 제품인 Revenue Cloud(RLM)를 채택한다. Salesforce가 신규/업데이트 고객에게 권장하는 경로다.

### end-of-sale이 신규 결정에 주는 영향

CPQ의 기술 문서·모델·API는 **기존 고객에게 여전히 유효**하지만, **신규 구현의 기본 선택지에서는 CPQ를 제외**한다. "복잡한 견적이 필요하다"는 요구가 과거에는 자동으로 CPQ를 의미했지만, 2025-03-27 end-of-sale 이후로는 **복잡한 견적 = Revenue Cloud(RLM)** 로 매핑해야 한다. CPQ는 오직 "이미 CPQ 위에 구축된 org를 유지/확장"하는 경우로 한정된다.

---

## Quote-to-Cash 흐름에서의 위치

세 견적 제품은 모두 영업 흐름 **Lead → Opportunity → Quote → Order/Contract** 의 **Quote(견적)** 단계를 담당한다. 표준 Quotes는 이 단계의 기본 구현이고, CPQ·Revenue Cloud는 같은 단계를 구성·가격·구독·청구까지 확장한다. Revenue Cloud/RLM은 견적을 넘어 계약·주문·billing·구독/자산까지 **quote-to-cash 전체**를 아우른다.

- 영업 프로세스 전체 흐름(리드→기회→견적→주문) → [[Sales Cloud 개요]]
- 견적이 생성·동기화되는 소스 레코드 → [[Opportunities (기회)]]
- 견적 다음 단계(주문·계약) → [[Contracts & Orders (계약·주문)]]
- 견적 이후 quote-to-cash 전체(계약·주문·billing·구독) → [[Revenue Cloud 개요]]

---

> [!note] 소스 — 이 노트는 synthesis다
> 새 사실을 추출한 노트가 아니라, 위키에 이미 검증된 세 견적 제품 노트([[Quotes (견적)]] · [[CPQ API Models]] · [[CPQ Quote API]] · [[Revenue Cloud 개요]])를 **비교·선택 관점에서 한 곳에 모은 결정 가이드**다. 각 셀의 사실은 위 노트의 Tier 2 소스(Salesforce Help·CPQ Developer Guide)를 계승하며, 각 제품의 상세는 해당 노트로 위임한다. Tier 3(외부 지식) 아님.

## 관련 노트
- [[Quotes (견적)]] — 표준 Salesforce Quotes: Opportunity 기반 단순 견적·quote sync·활성화
- [[CPQ Quote API]] — CPQ(SBQQ) 견적 엔진: ServiceRouter 8개 하위 API(Save/Calculate/Read Quote/Validate/Add Products/Read Product/Proposal/Term Reader)
- [[CPQ API Models]] — CPQ 데이터 모델 11종 + **end-of-sale 경고 원문**·"신규는 Revenue Cloud 권장" 문구
- [[Revenue Cloud 개요]] — Revenue Cloud / RLM: platform-native 차세대 quote-to-cash 제품군(신규 구축 권장)
- [[Sales Cloud 개요]] — Lead→Opportunity→Quote→Order 영업 프로세스 허브
- [[Opportunities (기회)]] — 견적이 생성·sync되는 소스 레코드
- [[Contracts & Orders (계약·주문)]] — 견적 다음 단계(주문·계약)
