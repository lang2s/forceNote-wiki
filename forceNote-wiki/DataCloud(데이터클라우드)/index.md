---
tags: [index, data-cloud, data-360, cdp, customer-360]
created: 2026-07-03
---

# DataCloud(데이터클라우드) — 로컬 인덱스

> Salesforce Data Cloud(현 명칭 **Data 360**) — 모든 소스의 고객 데이터를 수집·조화·통합해 단일 고객 뷰(unified profile)를 만들고 세그먼트·액티베이션하는 CDP. 파이프라인(연결→수집→조화→통합→세그먼트→발행) 8노트.
>
> ⚠️ 이 폴더는 **어드민/개념(Data 360 파이프라인)** 측면이다. **개발자 측 Apex 코드**(`Datacloud` 네임스페이스)는 `Apex/` 네임스페이스 노트(apex-namespaces 샤드) 참조.

**상위:** [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Data Cloud 개요]] | (허브) Data 360 파이프라인 전체 — 연결→수집→조화→통합→세그먼트→발행. 각 단계 노트로 분기 | #overview |
| [[Data Streams & Ingestion (데이터 스트림·수집)]] | 소스 데이터를 Data Cloud로 들여오는 수집 파이프라인 — Data Stream·data bundle·zero copy | #reference |
| [[Data Lake Objects & Data Model Objects (DLO·DMO)]] | 원시 수집 데이터(DLO) → 표준 조화 데이터(DMO). Customer 360 Data Model·데이터 조화 | #reference |
| [[Identity Resolution (아이덴티티 해석)]] | match rule·ruleset으로 여러 소스 레코드를 단일 unified profile로 통합 | #reference |
| [[Calculated Insights (계산된 인사이트)]] | 통합 데이터 위에서 지표·KPI(LTV 등)를 계산하는 메트릭 정의 | #reference |
| [[Segments (세그먼트)]] | 통합 프로파일을 기준으로 오디언스 세그먼트(고객 그룹) 정의 | #reference |
| [[Activations (액티베이션)]] | 세그먼트를 Marketing Cloud 등 외부 대상으로 발행 — full/incremental refresh | #reference |
| [[Data Spaces (데이터 스페이스)]] | 데이터를 논리적으로 분리(브랜드·지역·부서)하는 파티션·거버넌스 경계 | #reference |

---

## 빠른 선택

- Data Cloud가 뭔지·전체 그림부터 → [[Data Cloud 개요]]
- 데이터를 Data Cloud로 가져오려면 → [[Data Streams & Ingestion (데이터 스트림·수집)]]
- 원시(DLO)/표준(DMO) 데이터 모델·조화 이해 → [[Data Lake Objects & Data Model Objects (DLO·DMO)]]
- 여러 소스의 고객을 단일 프로파일로 합치려면 → [[Identity Resolution (아이덴티티 해석)]]
- 지표·KPI를 계산하려면 → [[Calculated Insights (계산된 인사이트)]]
- 고객을 오디언스로 나누려면 → [[Segments (세그먼트)]]
- 세그먼트를 외부로 내보내려면 → [[Activations (액티베이션)]]
- 데이터를 브랜드·지역별로 격리하려면 → [[Data Spaces (데이터 스페이스)]]

---

## 관련 폴더

- 개발자 측 Apex `Datacloud` 네임스페이스(코드) → `Apex/` 네임스페이스 노트 (apex-namespaces 샤드)
- 리포트·대시보드·CRM Analytics → [[Analytics(애널리틱스)/index|Analytics(애널리틱스)]]
- 세그먼트 발행 대상 Marketing Cloud 등 마케팅 도메인
