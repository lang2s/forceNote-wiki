---
tags: [data-cloud, data-360, cdp, customer-360, overview]
source: help.salesforce.com (Salesforce Help — About Salesforce Data Cloud (Data 360); 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=sf.c360_a_data_cloud.htm&type=5
created: 2026-07-03
aliases: [Data Cloud, Data 360, 데이터 클라우드, CDP, Customer Data Platform, Customer 360, Unified Profile]
---

# Data Cloud 개요

> 모든 소스의 고객 데이터를 수집·조화·통합해 단일 고객 뷰(unified profile)를 만들고 세그먼트·액티베이션하는 CDP. **현재 명칭은 Data 360**(2025-10-14 리브랜딩, 구 Data Cloud). 이 노트는 Data Cloud 파이프라인의 허브다.

---

> [!info] 브랜딩 변경 — Data Cloud → Data 360
> "As of October 14, 2025, Data Cloud has been rebranded to **Data 360**." 공식 문서·제품 UI에서 두 명칭(Data Cloud / Data 360)을 모두 볼 수 있으며 같은 제품을 가리킨다.

## Data Cloud(Data 360)란

Data Cloud는 **구조적(structured)·비구조적(unstructured) 데이터를 막론하고 모든 데이터 소스를 연결**하는 CDP(Customer Data Platform)다. 소스를 연결한 뒤 다음을 수행한다.

- **수집(Ingest)** — 데이터를 **batch 또는 streaming** 방식으로 가져온다.
- **연결(Connect, zero copy)** — **zero copy data federation**으로 데이터를 복사하지 않고 원본 위치에 둔 채 연결한다.
- **준비(Prepare)** — transformation과 거버넌스로 데이터를 정제·통제한다.
- **조화(Harmonize)** — **표준 데이터 모델(standard data model)** 로 서로 다른 소스의 데이터를 일관된 형태로 맞춘다.
- **통합(Unify)** — **identity resolution ruleset**으로 여러 소스에 흩어진 동일 고객의 레코드를 하나의 **unified profile(단일 고객 뷰)** 로 묶는다.

여기에 **Segmentation**과 **Activation**을 더해, 의미 있는 audience segment를 만들고 개인화된 커뮤니케이션과 journey를 실행한다.

## 파이프라인 (핵심 흐름)

Data Cloud는 원시 데이터를 실행 가능한 audience로 바꾸는 일련의 단계로 동작한다.

1. **연결·수집** — Data Streams / Ingestion으로 소스를 연결하고 batch·streaming으로 데이터를 가져온다.
2. **원시 저장** — 수집된 데이터를 **Data Lake Object(DLO)** 로 저장한다.
3. **조화** — DLO를 **Data Model Object(DMO)** 에 매핑해 표준 데이터 모델로 정규화한다.
4. **통합** — **Identity Resolution**의 ruleset을 적용해 DMO 레코드를 unified profile로 묶는다.
5. **인사이트** — **Calculated Insights**로 프로필 기반 지표를 계산한다.
6. **대상 정의** — **Segments**로 조건에 맞는 audience를 만든다.
7. **발행** — **Activation**으로 세그먼트를 Marketing Cloud·외부 대상 등으로 내보낸다.

```
// 구조 예시 — Data Cloud(Data 360) 파이프라인(실제 원본 다이어그램 아님)
소스(구조/비구조, batch/streaming, zero-copy)
  → Data Stream(수집) → Data Lake Object(DLO, 원시)
  → Data Model Object(DMO, 표준 모델로 조화)
  → Identity Resolution(ruleset) → Unified Profile(통합)
  → Calculated Insights(지표) → Segment(대상) → Activation(발행: MC/외부)
```

## 핵심 용어

| 단계 | 오브젝트/기능 | 역할 |
|---|---|---|
| 수집 | Data Stream / Ingestion | 소스 연결, batch·streaming으로 데이터 가져오기 |
| 연결 | Zero Copy Data Federation | 복사 없이 원본 위치에서 데이터 연결 |
| 원시 저장 | Data Lake Object (DLO) | 수집된 원시 데이터 저장 |
| 조화 | Data Model Object (DMO) | 표준 데이터 모델로 정규화 |
| 통합 | Identity Resolution (ruleset) | 동일 고객 레코드를 unified profile로 통합 |
| 인사이트 | Calculated Insights | 프로필 기반 지표 계산 |
| 대상 | Segment | 조건에 맞는 audience 정의 |
| 발행 | Activation | 세그먼트를 외부 대상으로 내보내기 |

## Data Cloud 시리즈 노트

파이프라인 순서로 읽는다.

- **수집·저장** — [[Data Streams & Ingestion (데이터 스트림·수집)]] · [[Data Lake Objects & Data Model Objects (DLO·DMO)]]
- **통합·인사이트** — [[Identity Resolution (아이덴티티 해석)]] · [[Calculated Insights (계산된 인사이트)]]
- **활용** — [[Segments (세그먼트)]] · [[Activations (액티베이션)]]
- **거버넌스** — [[Data Spaces (데이터 스페이스)]]

## 관련 노트
- [[Datacloud Namespace]] — Data Cloud를 Apex로 다루는 네임스페이스
- [[Data Cloud Objects]] — Data Cloud 표준 오브젝트 레퍼런스
