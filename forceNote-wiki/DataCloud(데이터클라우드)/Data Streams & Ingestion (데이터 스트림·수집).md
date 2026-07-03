---
tags: [data-cloud, data-360, data-streams, ingestion, connectors]
source: help.salesforce.com (Salesforce Help — Data Streams; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=sf.c360_a_data_streams.htm&type=5
created: 2026-07-03
aliases: [Data Streams, 데이터 스트림, Ingestion, 데이터 수집, Data Bundle, Zero Copy]
---

# Data Streams & Ingestion (데이터 스트림·수집)

> **Data Stream**은 소스 데이터를 Data 360으로 가져오는(ingest) 파이프라인. 커넥터로 데이터 소스를 연결해 batch/streaming으로 수집하며, 수집된 데이터는 Data Lake Object(DLO)로 저장된다.

---

## Data Stream이란

**Data Stream**은 소스 데이터를 Data 360으로 가져오는 **파이프라인**이다. 데이터 소스(오브젝트)마다 하나의 data stream을 만든다. 즉 소스 시스템의 각 오브젝트가 개별 data stream이 되어 Data 360으로 흐른다.

## 수집(Ingestion) 설정

데이터 소스를 설정해 Data 360이 **어디서 데이터를 pull(ingest)할지**를 지정한다. 이렇게 수집된 데이터는 이후 data mapping과 segment 작업에 쓰인다.

- 수집 방식은 **batch** 또는 **streaming** 중 하나로 동작한다.
- data stream을 통해 Data 360이 소스에서 데이터를 끌어온다.

## 연결(Connection) 구조

- 하나의 Data 360 org에는 **여러 EID를 연결**할 수 있고, 각 EID는 자체 연결을 가진다.
- 각 연결마다 **data bundle** 또는 **data extension**으로 여러 data stream을 설정한다.

## Zero Copy 연결

**zero copy data federation**을 사용하면 데이터를 **복사하지 않고** 소스에 연결할 수도 있다. 즉 원본 데이터를 Data 360으로 물리적으로 이동/복제하지 않고 참조 형태로 연결하는 방식이다.

## 스케줄

**data stream schedule**로 수집 주기(얼마나 자주 데이터를 가져올지)를 정한다.

## 수집 결과 — DLO

수집된 데이터는 **Data Lake Object(DLO)**로 들어간다. DLO는 수집 데이터가 원시 형태로 저장되는 대상이다.

> DLO의 구조·매핑 등 세부는 [[Data Lake Objects & Data Model Objects (DLO·DMO)]] 참조.

## 수집 흐름 (구조)

```
// 구조 예시 — Data Streams & Ingestion(실제 원본 다이어그램 아님)
소스(Salesforce/외부 시스템/파일) ──커넥터──▶ Data Stream
   batch 또는 streaming · zero-copy federation · schedule
   → Data Lake Object(DLO, 원시 저장)
```

---

## 관련 노트
- [[Data Cloud 개요]] — Data Cloud 시리즈 허브
- [[Data Lake Objects & Data Model Objects (DLO·DMO)]] — 수집 데이터가 저장되는 DLO
