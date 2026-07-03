---
tags: [data-cloud, data-360, segments, segmentation, audience]
source: help.salesforce.com (Salesforce Help — Create and Activate Segments; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=sf.c360_a_segments.htm&type=5
created: 2026-07-03
aliases: [Segments, 세그먼트, Segmentation, 세그멘테이션, Audience, 오디언스]
---

# Segments (세그먼트)

> 통합된 데이터(unified profile·DMO·calculated insight)에서 조건으로 **의미 있는 오디언스 세그먼트**를 만드는 Data Cloud 기능. 세그먼트는 액티베이션으로 발행돼 개인화된 커뮤니케이션·journey에 쓰인다.

---

## 개념

Data Cloud의 **Segmentation**은 통합된 데이터에서 **의미 있는 audience segment(오디언스 세그먼트)** 를 만드는 기능이다. 흩어진 데이터를 통합해 만든 프로필과 계산된 지표를 조건으로 묶어, 마케팅·서비스에서 실제로 겨냥할 수 있는 대상 집단을 정의한다.

세그먼트는 다음 데이터를 조건(attribute)으로 사용해 정의한다:

- **Unified Profile(통합 프로필)** 의 속성(attribute)
- **DMO(Data Model Object)** 의 속성 및 **관련 속성(related attribute)**
- **Calculated Insight(계산된 인사이트)** — 집계·계산으로 도출한 지표

이 조건들을 조합해 "어떤 고객 집단을 대상으로 할지"를 규정한다.

## 용도

세그먼트는 **개인화된 고객 커뮤니케이션과 journey**를 만드는 데 쓰인다. 정의한 오디언스에 맞춰 메시지·경험을 개인화한다.

## 다음 단계 — Activation(액티베이션)

세그먼트를 만든 뒤에는 **Activation**으로 활성화 플랫폼(예: Marketing Cloud, 외부 플랫폼)으로 발행한다. 이 발행 과정을 통해 세그먼트가 실제 커뮤니케이션 채널에서 사용 가능해진다.

> 세그먼트 발행의 상세 메커니즘은 [[Activations (액티베이션)]] 참조.

## 세그먼트 흐름

```
// 구조 예시 — Segments(실제 원본 다이어그램 아님)
Unified Profile / DMO / Calculated Insight ──조건──▶ Segment(오디언스)
   → Activation(발행: Marketing Cloud / 외부 플랫폼)
   → 개인화 커뮤니케이션·journey
```

> 세그먼트 빌더 UI·필터 세부(세그먼트 생성 화면, 조건 연산자, 발행 스케줄 등)는 [공식 문서](https://help.salesforce.com/s/articleView?id=sf.c360_a_segments.htm&type=5)에 위임한다.

## 관련 노트
- [[Data Cloud 개요]] — Data Cloud 시리즈 허브
- [[Activations (액티베이션)]] — 세그먼트 발행
- [[Calculated Insights (계산된 인사이트)]] — 세그먼트 조건
