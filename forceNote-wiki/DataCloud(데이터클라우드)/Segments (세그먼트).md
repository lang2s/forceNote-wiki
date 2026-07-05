---
tags: [data-cloud, data-360, segments, segmentation, audience]
source: help.salesforce.com (Salesforce Help — Create and Activate Segments; 라이브 공식 문서, Tier 2, 접속 2026-07-03); help.salesforce.com — Increase Segment Refresh with Rapid Segment Publish (sf.c360_a_rapid_segment_publish.htm, Tier 2); help.salesforce.com — Rapidly Publish Segments to Hyperscaler Targets (Summer '24 release-notes rn_cdp_2024_summer_rapid_activation_hyperscaler_targets, Tier 2)
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

### 발행 스케줄 · 한도

세그먼트 발행(publish) 주기에는 두 가지 모드가 있고 각각 하드 한도가 있다:

| 모드 | 발행 주기 | 전송 대상 | org당 한도 |
|---|---|---|---|
| **Standard Publish** | 최소 12시간 ~ 최대 24시간 | 제한 없음 | — |
| **Rapid Segment Publish** | 최소 1시간 ~ 최대 4시간 | Marketing Cloud + 파일 스토리지/하이퍼스케일러(Amazon S3·Microsoft Azure·SFTP·Google Cloud Storage)·Data 360 | **Rapid 세그먼트 20개** |

> ℹ️ **전송 대상 확대(Summer '24):** Rapid Segment Publish는 이전에 Marketing Cloud로만 전송 가능했으나, Summer '24 릴리스('Rapidly Publish Segments to Hyperscaler Targets')부터 Marketing Cloud Engagement 외에 파일 스토리지/하이퍼스케일러 타깃(Amazon S3·Microsoft Azure·SFTP·Google Cloud Storage) 및 Data 360로도 rapid publish할 수 있다. (근거: [Summer '24 릴리스 노트](https://help.salesforce.com/s/articleView?id=release-notes.rn_cdp_2024_summer_rapid_activation_hyperscaler_targets.htm&release=250&type=5) · [Rapid Segment Publish 공식 문서](https://help.salesforce.com/s/articleView?id=data.c360_a_rapid_segment_publish.htm&type=5))

> ⚠️ 세그먼트를 **생성한 뒤에는 Standard → Rapid 스케줄로 변경할 수 없다.** Rapid Publish가 필요하면 세그먼트 생성 시점에 지정해야 한다.

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
