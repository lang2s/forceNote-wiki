---
tags: [Apex, Namespace, renew_assets_summary, Revenue-Cloud, Asset-Renewal, Renewal-Opportunity]
source: salesforce_apex_reference_guide.pdf (v67.0)
created: 2026-05-23
aliases: [renew_assets_summary, RenewalOpptyDetail, RenewalPriceDetail, 자산 갱신 요약, Revenue Cloud 자산 갱신]
---

# renew_assets_summary Namespace

> 갱신 가능한 자산 세부 정보를 조회해 갱신 Opportunity를 생성하는 Revenue Cloud 전용 네임스페이스

> [!note] PDF(Apex Reference v67.0)에서 이 네임스페이스는 클래스 목록만 제공하며, 메서드 시그니처 상세가 포함되지 않습니다. Revenue Cloud 개발자 가이드를 병행 참조하세요.
> 공식 문서: https://developer.salesforce.com/docs/atlas.en-us.revenue_lifecycle_management.meta/revenue_lifecycle_management/

---

## 개념 설명

`renew_assets_summary` 네임스페이스는 **Revenue Cloud**에서 갱신 가능한 자산(Asset) 데이터를 조회하고, 갱신 Opportunity 생성을 지원하는 클래스를 제공한다.

### 사용 목적

- 만료 예정 자산(Asset)의 갱신 세부 정보 조회
- 갱신 가격 정보(RenewalPriceDetail) 계산 및 조회
- 갱신 Opportunity 생성 프로세스 지원

---

## 클래스 목록

| 클래스 | 설명 |
|---|---|
| `RenewalOpptyDetail` | 갱신 Opportunity 세부 정보 — 갱신 대상 자산 정보 포함 |
| `RenewalPriceDetail` | 갱신 가격 세부 정보 — 자산별 갱신 가격 계산 결과 |

---

## 코드 예제

```apex
// renew_assets_summary 네임스페이스는 Revenue Cloud 환경에서 사용
// 갱신 자산 처리 패턴 (구조 예시 — 실제 동작 코드 아님)

// RenewalOpptyDetail 조회 패턴
// Revenue Cloud의 Asset Renewal 프로세스에서 사용됨
// 갱신 자산 목록 기반 Opportunity 생성 워크플로
List<Asset> renewableAssets = [
    SELECT Id, Name, Status, UsageEndDate, Product2Id
    FROM Asset
    WHERE Status = 'Installed'
    AND UsageEndDate <= :Date.today().addDays(90)
];

// renew_assets_summary 클래스는 Revenue Cloud Managed Package에서 노출됨
// 직접 인스턴스화는 Revenue Cloud 라이선스 및 패키지 설치 필요
```

---

## 비교표 (Revenue Cloud 갱신 관련 네임스페이스)

| 네임스페이스 | 주요 역할 |
|---|---|
| `renew_assets_summary` | 갱신 가능 자산 조회 + 갱신 Opportunity 생성 지원 |
| `RevSalesTrxn` | 판매 트랜잭션 생성 (Quote/Order) |
| `RevSignaling` | Revenue Lifecycle 시그널링 |
| `RulesAppIn` | 결제·크레딧 규칙 기반 적용 |

---

## 관련 노트
- [[RevSalesTrxn Namespace]]
- [[RevSignaling Namespace]]
- [[RulesAppIn Namespace]]
- [[IssueCreditMemo Namespace]]
- [[InvoiceWriteOff Namespace]]
