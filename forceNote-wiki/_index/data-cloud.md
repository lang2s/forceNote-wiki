---
tags: [index, search, navigation, data-cloud]
created: 2026-07-03
---

# SEARCH INDEX — Data Cloud (데이터 클라우드 / Data 360)
> Salesforce Data Cloud(현 명칭 **Data 360**) — CDP 파이프라인: 연결→수집→조화→통합→세그먼트→발행. `DataCloud(데이터클라우드)/` 폴더 8노트.
> 루트 라우터: `00 SEARCH_INDEX.md` · 다른 샤드는 라우터에서 이동.
>
> ⚠️ 이 샤드는 **어드민/개념(Data 360 파이프라인)** 측면이다. **개발자 측 Apex 코드**(`Datacloud` 네임스페이스 — `Datacloud.PartyIdentification` 등)는 `_index/apex-namespaces.md` 샤드 참조.

---

## 개요 · 파이프라인 (허브)

| 키워드 | 파일 |
|---|---|
| Data Cloud, Data 360, 데이터 클라우드, CDP, Customer Data Platform, Customer 360, unified profile, 통합 프로파일, 데이터 클라우드란, Data 360 파이프라인, 연결 수집 조화 통합 세그먼트 발행 | `DataCloud(데이터클라우드)/Data Cloud 개요.md` |

## 수집 (Ingestion)

| 키워드 | 파일 |
|---|---|
| Data Streams, 데이터 스트림, ingestion, 데이터 수집, zero copy, 제로 카피, data bundle, 데이터 번들, 데이터 가져오기, 소스 데이터 수집 파이프라인, Data Cloud로 데이터 넣는 법 | `DataCloud(데이터클라우드)/Data Streams & Ingestion (데이터 스트림·수집).md` |

## 데이터 모델 · 조화 (DLO · DMO)

| 키워드 | 파일 |
|---|---|
| Data Lake Object, DLO, Data Model Object, DMO, Customer 360 Data Model, 데이터 모델, 데이터 조화, harmonization, 원시 데이터 오브젝트, 표준 데이터 오브젝트, DLO DMO 차이, 데이터 클라우드 데이터 모델이 뭐야 | `DataCloud(데이터클라우드)/Data Lake Objects & Data Model Objects (DLO·DMO).md` |

## 통합 (Identity Resolution)

| 키워드 | 파일 |
|---|---|
| Identity Resolution, 아이덴티티 해석, unified profile, 통합 프로파일, match rule, 매치 규칙, ruleset, reconciliation, 신원 통합, 프로파일 통합, 중복 고객 통합, 어떻게 단일 고객 뷰를 만드나 | `DataCloud(데이터클라우드)/Identity Resolution (아이덴티티 해석).md` |

## 인사이트 (Calculated Insights)

| 키워드 | 파일 |
|---|---|
| Calculated Insights, 계산된 인사이트, metrics, KPI, 지표, 측정값, LTV, 계산 지표 만들기, Data Cloud에서 지표 계산 | `DataCloud(데이터클라우드)/Calculated Insights (계산된 인사이트).md` |

## 세그먼트 (Segments)

| 키워드 | 파일 |
|---|---|
| Segments, 세그먼트, segmentation, 세그멘테이션, audience, 오디언스, 세그먼트 만들기, 오디언스 정의, 고객 그룹 나누기 | `DataCloud(데이터클라우드)/Segments (세그먼트).md` |

## 발행 (Activations)

| 키워드 | 파일 |
|---|---|
| Activations, 액티베이션, activation target, 액티베이션 타깃, full refresh, incremental refresh, 전체 새로고침, 증분 새로고침, 세그먼트 발행, Marketing Cloud, 세그먼트를 외부로 내보내기 | `DataCloud(데이터클라우드)/Activations (액티베이션).md` |

## 거버넌스 (Data Spaces)

| 키워드 | 파일 |
|---|---|
| Data Spaces, 데이터 스페이스, data partition, 데이터 파티션, 데이터 격리, 데이터 분리, 데이터 거버넌스, data governance, 브랜드별 데이터 분리, 데이터 논리 분리 | `DataCloud(데이터클라우드)/Data Spaces (데이터 스페이스).md` |
