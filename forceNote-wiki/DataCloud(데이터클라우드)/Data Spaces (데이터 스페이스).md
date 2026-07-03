---
tags: [data-cloud, data-360, data-spaces, data-partition, governance]
source: help.salesforce.com (Salesforce Help — Data Spaces in Data Cloud; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=sf.c360_a_data_spaces.htm&type=5
created: 2026-07-03
aliases: [Data Spaces, 데이터 스페이스, Data Partition, 데이터 분리, Data Governance]
---

# Data Spaces (데이터 스페이스)

> 하나의 Data 360 org 안에서 데이터를 **브랜드·지역·부서 등으로 논리적으로 분리(partition)**하는 단위. 팀이 자신의 데이터 스페이스 범위 내에서만 작업하도록 거버넌스·분리를 제공한다.

---

## 개념

**Data space**는 하나의 **Data 360 org** 내에서 데이터를 **논리적으로 분리(partition)**하는 단위다. 예를 들어 **브랜드·지역(region)·business unit(부서)** 별로 데이터를 나눌 수 있다.

이 논리적 분리를 통해 팀과 프로세스가 **특정 data space 범위의 데이터만** 다루게 함으로써 **거버넌스**와 **데이터 격리(isolation)**를 지원한다. 즉, 한 org를 여러 조직 단위가 공유하더라도 각 단위는 자신의 data space 안에서만 데이터를 보고 작업한다.

## 용도

서로 다른 브랜드/지역의 데이터를 **하나의 org에서 분리 관리**하면서, 각 data space에 대해 다음을 개별적으로 운영한다:

- **Data Stream(데이터 스트림)** — data space별 데이터 수집
- **Segment(세그먼트)** — data space 범위 내 오디언스 정의
- **Activation(액티베이션)** — data space 범위 내 발행

이렇게 하면 여러 조직 단위가 한 Data 360 org를 공유하면서도 서로의 데이터에 간섭하지 않고 각자의 파이프라인을 운영할 수 있다.

## 분리 구조

```
// 구조 예시 — Data Spaces(실제 원본 다이어그램 아님)
Data 360 Org
 ├─ Data Space A (예: 브랜드/지역 1) — 자체 data stream·segment·activation
 ├─ Data Space B (예: 브랜드/지역 2)
 └─ …  (논리적 분리 · 거버넌스 · 데이터 격리)
```

> data space 생성·권한·필터 세부와 개수 한도 등은 위 개요 범위 밖이므로 [공식 문서](https://help.salesforce.com/s/articleView?id=sf.c360_a_data_spaces.htm&type=5)에 위임한다.

## 관련 노트
- [[Data Cloud 개요]] — Data Cloud 시리즈 허브
- [[Data Streams & Ingestion (데이터 스트림·수집)]] — data space별 수집
