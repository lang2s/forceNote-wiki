---
tags: [admin, org-setup, multi-currency, currency-management, dated-exchange-rates]
source: help.salesforce.com (Salesforce Help — Enable Multiple Currencies / Manage Multiple Currencies; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=sales.admin_enable_multicurrency.htm&type=5
created: 2026-07-03
aliases: [Multiple Currencies, 멀티 통화, Multi-Currency, Multi-Currency Everywhere, Corporate Currency, Dated Exchange Rates, Advanced Currency Management]
---

# Multiple Currencies (멀티 통화)

> 한 조직에서 여러 통화로 거래·리포트하게 하는 기능(Multi-Currency Everywhere). System Admin이 Setup에서 활성화하며 ⚠️ **한 번 켜면 영구(비활성화 불가)**다.

---

## 개념

**Multiple Currencies**는 하나의 Salesforce 조직에서 **여러 통화**로 opportunity·리포트 등을 다룰 수 있게 하는 기능이다. 국제 거래를 하거나 여러 통화로 매출을 기록하는 조직에서 사용한다.

**Multi-Currency Everywhere**는 셀프서비스(self-service) 기능으로, **System Administrator가 Setup 메뉴에서 직접 활성화**한다. 별도의 Salesforce 지원 요청 없이 관리자가 켤 수 있다.

> [!warning] 되돌릴 수 없음 — 비활성화 불가
> 한 번 활성화하면 Multi-Currency Everywhere는 **영구(permanent)이며 비활성화할 수 없다.** 활성화 전에 반드시 고려사항(considerations)을 검토한다.

---

## 활성화 (System Admin)

- 활성화 주체: **System Administrator**
- 위치: **Setup 메뉴** (Multi-Currency Everywhere 셀프서비스 활성화)
- 활성화 전 **고려사항(considerations)** 이 존재하므로 사전 검토가 권장된다. (세부 고려사항 목록은 공식 문서 위임 — 아래 Official Doc 참조)

아래는 활성화 흐름과 통화 관리 구성요소를 나타낸 구조 개념도다.

```
// 구조 예시 — Multiple Currencies(실제 원본 다이어그램 아님)
System Admin → Setup → Multi-Currency Everywhere 활성화 (⚠️영구·비활성화 불가)
   Corporate Currency(기준) + Active 통화들 + Conversion Rate(환율)
   Advanced Currency Management: Dated Exchange Rate(기간별 환율)
   활성화 흔적 → Setup Audit Trail
```

---

## 활성화 확인 — Setup Audit Trail

최근 **180일 이내**에 Multi-Currency를 켰다면 [[Setup Audit Trail (설정 감사 추적)]]에 활성화 항목이 남는다.

```
Activate Multiple Currencies off to on. Activation currency ISO code: xxx
```

(`xxx`는 활성화 시점의 통화 ISO 코드) 이미 켜져 있는지, 언제 누가 켰는지 확인할 때 Setup Audit Trail을 조회한다.

---

## 통화 관리

활성화 후 관리하는 주요 요소:

- **Corporate Currency(기업 기준 통화):** 조직의 기준 통화. 환율 계산의 기준점이 된다.
- **Active / Inactive 통화:** 조직에서 사용할 통화를 활성/비활성 상태로 관리한다.
- **Conversion Rate(환율):** 기준 통화 대비 각 통화의 환율.
- **Advanced Currency Management / Dated Exchange Rate(기간별 환율):** 특정 기간별로 서로 다른 환율을 적용해 과거 거래를 그 시점 환율로 계산한다. (세부 설정은 공식 문서 위임)

> 참고: Advanced Currency Management는 currency roll-up summary 필드를 무효화(invalidate)하므로, [[Roll-Up Summary 필드]]와 함께 쓸 때 영향을 검토한다.

---

## 관련 노트
- [[Setup Audit Trail (설정 감사 추적)]] — 멀티통화 활성화(off→on)가 기록되는 곳.
- [[Roll-Up Summary 필드]] — 멀티통화 org에서는 master 레코드의 통화가 roll-up 통화를 결정하고, advanced currency management는 currency roll-up을 무효화한다.
