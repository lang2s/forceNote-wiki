---
tags: [data-cloud, data-360, activation, segment-activation, marketing-cloud]
source: help.salesforce.com (Salesforce Help — Activation for a Segment; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=sf.c360_a_activation_for_a_segment.htm&type=5
created: 2026-07-03
aliases: [Activation, 액티베이션, Activation Target, Full Refresh, Incremental Refresh, 세그먼트 발행]
---

# Activations (액티베이션)

> 세그먼트를 활성화 플랫폼(Marketing Cloud·외부)으로 **발행(publish)**하는 Data Cloud 프로세스. full/incremental refresh로 발행 범위를 정한다.

---

## 정의

**Activation(액티베이션)**은 세그먼트를 Data 360의 **활성화 플랫폼(activation platform)으로 발행(publish)**하는 프로세스다. 세그먼트로 정의한 대상 집단을 실제로 활용할 수 있도록, 이를 외부 실행 채널(마케팅 캠페인 등)로 내보내는 단계에 해당한다.

## Activation Target (발행 대상)

Activation Target은 세그먼트가 발행되는 **대상 플랫폼**이다. 대표적인 대상은 다음과 같다.

- **Marketing Cloud Engagement** — Salesforce 마케팅 실행 플랫폼
- **외부 플랫폼(external platform)** — Data 360 외부의 활성화 대상

> activation target 설정·필드 매핑 세부는 공식 문서로 위임한다 (본 노트 범위 밖).

## Refresh 유형

Activation을 실행할 때 발행 범위(어떤 레코드를 내보낼지)를 결정하는 두 가지 refresh 유형이 있다.

| Refresh 유형 | 발행 범위 |
|---|---|
| **Full refresh** | activation 시 세그먼트의 **모든 레코드를 갱신**한다. |
| **Incremental refresh** | 마지막 성공 refresh 이후 **추가·수정·삭제된 레코드만** 발행한다. |

- **Full refresh** — 전체 세그먼트 멤버십을 매번 다시 발행. 대상 플랫폼이 항상 세그먼트 전량을 반영하도록 한다.
- **Incremental refresh** — 직전 성공 refresh 이후 변경분(추가·수정·삭제)만 발행하여 처리량을 줄인다.

## 발행 흐름

```
// 구조 예시 — Activation(실제 원본 다이어그램 아님)
Segment ──▶ Activation(발행) ──▶ Activation Target
                                  (Marketing Cloud Engagement / 외부 플랫폼)
Refresh: Full(전 레코드) | Incremental(마지막 이후 추가·수정·삭제분만)
```

## 관련 노트
- [[Data Cloud 개요]] — Data Cloud 시리즈 허브
- [[Segments (세그먼트)]] — 발행 대상 세그먼트
