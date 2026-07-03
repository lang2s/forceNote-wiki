---
tags: [data-cloud, data-360, data-lake-object, data-model-object, data-model]
source: help.salesforce.com (Salesforce Help — Data Objects in Data Cloud / Data Model Concepts; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=sf.c360_a_data_lake_objects.htm&type=5
created: 2026-07-03
aliases: [Data Lake Object, DLO, Data Model Object, DMO, Customer 360 Data Model, 데이터 레이크 오브젝트, 데이터 모델 오브젝트]
---

# Data Lake Objects & Data Model Objects (DLO·DMO)

> **DLO**는 수집된 원시 데이터를 담는 오브젝트, **DMO**는 Customer 360 표준 데이터 모델로 조화(harmonize)된 오브젝트. 수집 데이터가 DLO로 들어와 DMO에 매핑되어 표준화된다.

---

## Customer 360 Data Model

Customer 360 Data Model은 클라우드 앱 간 데이터 통합의 복잡성을 줄이는 **표준화된 데이터 가이드라인**이다. 여러 소스에서 들어오는 데이터를 공통 스키마로 정렬해, 앱마다 제각각인 데이터 형태를 조율(harmonize)한다.

이 표준 모델은 확장해서 다음 용도에 사용한다.

- data lake 구축
- 분석(analytics)
- ML 모델 학습(training)
- 단일 고객 뷰(single view of the customer) 구축

DLO와 DMO는 이 모델을 실제로 구현하는 두 종류의 데이터 오브젝트다. 수집된 원시 데이터는 먼저 DLO에 담기고, DMO에 매핑되어 표준 모델로 조화된다.

## Data Lake Object (DLO)

**Data Lake Object**는 Data Cloud의 데이터 오브젝트로, **수집된(원시) 데이터**를 담는다. 소스에서 들어온 데이터가 표준 모델로 조화되기 전, 원래 스키마에 가까운 형태로 저장되는 계층이다.

- **Data Lake Objects 탭**에서 모든 DLO를 본다.
- 각 DLO가 **어떤 DMO에 매핑됐는지** 함께 확인한다.
- 이 탭에서 DLO를 새로 만들거나 필드를 추가한다.

## Data Model Object (DMO)

**Data Model Object**는 Customer 360 **표준 데이터 모델**의 오브젝트다. 여러 DLO의 데이터가 이 표준 오브젝트로 매핑되면서 소스별 차이가 사라지고 데이터가 표준화된다.

- **Data Model 탭**에서 DMO를 본다.
- data stream(을 통해 채워진 DLO)을 **DMO에 매핑(map)**해 데이터를 표준 모델로 조화한다.

## 데이터 흐름 — 수집에서 표준 모델까지

소스에서 들어온 데이터는 data stream을 통해 원시 형태로 DLO에 담기고, 필드 매핑을 거쳐 DMO로 조화되어 단일 고객 뷰·분석·ML의 기반이 된다.

```
// 구조 예시 — DLO · DMO(실제 원본 다이어그램 아님)
Data Stream(수집) → Data Lake Object(DLO, 원시 스키마)
        │  map fields
        ▼
Data Model Object(DMO, Customer 360 표준 모델)
   → 단일 고객 뷰·분석·ML의 기반
```

정리하면 흐름은 다음과 같다: **소스 → data stream → DLO(원시) → DMO(표준 모델로 매핑·조화)**.

## DLO vs DMO — 언제 무엇을 보나

| 구분 | Data Lake Object (DLO) | Data Model Object (DMO) |
|---|---|---|
| 담는 데이터 | 수집된 원시 데이터 | 표준 모델로 조화된 데이터 |
| 데이터 모델 | 소스 원래 스키마에 가까움 | Customer 360 표준 데이터 모델 |
| 확인 탭 | Data Lake Objects 탭 | Data Model 탭 |
| 주요 작업 | DLO 생성·필드 추가, 매핑된 DMO 확인 | data stream(DLO)을 DMO에 매핑 |
| 위치 | 수집 계층 | 표준화(조화) 계층 |

## 관련 노트

- [[Data Cloud 개요]] — Data Cloud 시리즈 허브
- [[Data Streams & Ingestion (데이터 스트림·수집)]] — DLO를 채우는 수집
- [[Identity Resolution (아이덴티티 해석)]] — DMO를 입력으로 unified profile 통합
- [[Data Cloud Objects]] — Data Cloud 표준 오브젝트 레퍼런스
