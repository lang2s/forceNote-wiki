---
tags: [release, summer_26, clouds, data360, analytics, field-service]
api_version: v67.0
release_date: 2026-06
created: 2026-06-15
source: salesforce_release_notes_5-17-2026.pdf (Salesforce Summer '26 Release Notes, Tier 2)
aliases: [Summer '26 Clouds, 서머26 클라우드, Data 360, Field Service]
---

# Summer '26 — Clouds (Data 360 · Analytics · Field Service · Industries 외)

> Summer '26(API v67.0) 클라우드별 변경: GA는 전수, Beta는 요약 전수, Pilot/Dev Preview는 한 줄. Agentforce 관련 클라우드 기능 상세는 [[Summer '26/Agentforce]] 참조.

이 노트는 [[Summer '26]] 릴리즈의 Clouds 스포크다.

## 개요 — 클라우드별 GA 건수

| 클라우드 | GA | Beta | 기타 |
|---|---:|---:|---|
| Data 360 | 7 | 2 | Code Extension(Python) |
| Analytics | 5 | 5 | — |
| Field Service | 5 | 1 | — |
| Education Cloud | 4 | — | — |
| Service Cloud | 2(IT) | 5 | Pilot 1 / Beta retire 1 |
| MuleSoft | 3 | — | — |
| Life Sciences | 1 | — | Pilot 1 |
| 기타 클라우드 | — | — | 아래 ### 참조 |

---

## Data 360

### GA (7)

- **Databricks 통합 (GA)** — Data 360에서 Databricks 데이터를 zero-copy로 연동.
- **Time Series Forecasting (GA)** — 시계열 예측 모델로 미래 값을 예측.
- **Sentiment Analysis (GA)** — 텍스트 데이터의 감성(긍정/부정)을 분석.
- **Topic Classification (GA)** — 텍스트를 주제(topic)별로 분류.
- **Multiclass Classification (GA)** — 다중 클래스 분류 모델 지원.
- **Enterprise Knowledge (GA)** — 엔터프라이즈 지식 데이터를 Data 360에서 활용.
- **Intelligent Context — 추가 파일 타입 (GA)** — Intelligent Context가 지원하는 파일 타입 확장.

### Beta (2)

- **Structured Clustering (Beta)** — 정형 데이터 군집화.
- **Model Drift (Beta)** — 배포된 모델의 성능 드리프트를 모니터링.

### 기타

- **Code Extension — Python** — Data 360 변환에 Python 코드 확장 지원.

---

## Analytics

### GA (5)

- **Custom LWC in Dashboards (GA)** — CRM Analytics 대시보드에 커스텀 LWC 임베드.
- **Semi-Joins / Anti-Joins (GA)** — SAQL/쿼리에서 세미조인·안티조인 지원.
- **Snapshot Optimized (GA)** — 데이터셋 스냅샷 최적화.
- **Write to Data 360 Optimized (GA)** — Analytics에서 Data 360으로의 쓰기 최적화.
- **Azure Data Lake 출력 커넥터 (GA)** — CRM Analytics 데이터를 Microsoft Azure Data Lake로 **출력(write)**하는 커넥터. recipe 출력 데이터셋을 하나 이상의 `.csv` 파일로 data lake에 기록한다(데이터 소스 입력이 아니라 출력).
  > PDF 원문: "Output Your CRM Analytics Data to Azure Data Lake … Write your data from CRM Analytics into Microsoft's Azure Data Lake with the Azure Data Lake output connector. Write recipe output datasets as one or more .csv files to your data lake"

### Beta (5)

- **CIO History (Beta)** — Compute-in-Output 변환 이력 추적.
- **Dimensional Hierarchies (Beta)** — 차원 계층 구조 지원.
- **Currency Reporting (Beta)** — 통화 단위 리포팅.
- **Custom Page Sizes (Beta)** — 대시보드 페이지 크기 커스터마이즈.
- **Experience Cloud Widget Subscribe (Beta)** — Experience Cloud 위젯 구독.

---

## Field Service

### GA (5)

- **Appointment Insights (GA)** — 서비스 약속이 스케줄되지 못하는 이유를 분석.
- **Insights API — `getAppointmentInsights` (GA)** — `ScheduleService` Apex 클래스의 신규 `getAppointmentInsights` 메서드. 특정 서비스 약속이 간트(Gantt)에서 스케줄될 수 없는 이유 데이터를 반환해 스케줄링 정책을 튜닝하도록 돕는다. Enterprise·Unlimited·Developer 에디션의 Lightning Experience에서 사용 가능.

```apex
// 구조 예시 — 실제 동작 코드 아님 (PDF는 메서드명·소속 클래스만 명시, 시그니처 미제공)
// ScheduleService Apex 클래스의 getAppointmentInsights 메서드로 약속 스케줄 불가 사유 조회
ScheduleService.getAppointmentInsights(/* serviceAppointmentId */);
```

- **Activity Reports (GA)** — Field Service 활동 리포트.
- **Keep Scheduled (GA)** — 최적화 중에도 특정 약속의 스케줄을 유지.
- **Fix Overlaps Flow (GA)** — 겹치는 약속을 정리하는 Flow.

### Beta (1)

- **Mobile Insights (Beta)** — Field Service 모바일 앱에서 인사이트 조회.

---

## Education Cloud

### GA (4)

- **Student Recruitment Agent (GA)** — 학생 모집을 지원하는 에이전트.
- **Transfer Credit (GA)** — 편입 학점(transfer credit) 관리.
- **Course Search (GA)** — 강좌 검색 기능.
- **Student Goals (GA)** — 학생 목표 관리.

---

## Service Cloud

### GA (2 — IT)

- **Hardware Asset Management (GA)** — IT 하드웨어 자산 관리.
- **IT Compliance (GA)** — IT 컴플라이언스 관리.

### Beta (5)

- **Merge Duplicate Cases (Beta)** — 중복 케이스 병합.
- **Rich Text Descriptions (Beta)** — 케이스 설명에 리치 텍스트 지원.
- **Enhanced Case Merge (Beta)** — 향상된 케이스 병합 경험.
- **Agentic Milestones (Beta)** — 에이전트 기반 마일스톤 관리.
- **Enterprise Knowledge URLs (Beta)** — 엔터프라이즈 지식 URL 연동.

### 기타

- **Voice Call Audit (Pilot)** — 음성 통화 감사(Pilot).
- **Work Summaries for Case (Beta) 은퇴** — 케이스용 Work Summaries Beta 기능 은퇴.

---

## MuleSoft

### GA (3)

- **MuleSoft MCP into API Catalog (GA)** — MuleSoft MCP Server를 API Catalog에 등록.
- **Manually Registered MCP (GA)** — MCP Server를 수동 등록.
- **Named Query APIs (GA)** — 명명된 쿼리(Named Query) API 지원.

---

## Life Sciences

### GA (1)

- **Microsoft Teams Remote Visits (GA)** — Microsoft Teams로 원격 방문(remote visit) 진행.

### 기타

- **Voice-Based Visit Logging (Pilot)** — 음성 기반 방문 기록(Pilot).

---

## 기타 클라우드 (depth balance)

> GA/Beta 건수가 적은 클라우드는 아래에 묶는다. GA는 전수, Beta/Pilot은 요약.

### Commerce

- GA 0. **Eventing Framework (Pilot)** — 커머스 이벤팅 프레임워크. B2B 커스텀 LWC/Apex 확장, Place Order Validation extension 등 확장 포인트 제공.

### Sales

- GA 0. **Agentforce Sales in Gemini (Beta)** — Gemini에서 Agentforce Sales 활용(Beta). 기타: Authorized Email Domains, Email Connect Integration(ECI) native, EAC(Einstein Activity Capture) Microsoft Graph 지원 등.

### Experience Cloud

- **Malware Scan (GA)** — 업로드 파일 멀웨어 스캔.
- **Static Resource Images (GA)** — 정적 리소스 이미지 활용.
- **File Upload 10 GB** — 파일 업로드 한도 10 GB로 확대.

### Marketing

- GA 0. RCS 메시징, AMPscript helpers, Marketing Cloud Next 관련 enhancement.

### Omnistudio

- **Omnistudio MCP (Beta)** — Omnistudio용 MCP Server(Beta). **Autolaunched Flows in Flexcards (Pilot)**, Migration Assistant 등.

### Industries 기타

- **Media — Ad Targeting DPE (Beta)** — 미디어 광고 타겟팅 Data Processing Engine(Beta). Automotive·Communications 등 산업별 개요 enhancement.

### Revenue Management

- **Predictive Invoice Risk (Pilot)** — 인보이스 리스크 예측(Pilot). **Advanced Approvals via Apex** 지원.

### Partner Cloud

- **Partner Connect (Beta)** — 파트너 커넥트(Beta).

### Hyperforce / Slack

- Hyperforce 리전 확장 등 인프라 변경은 [[Summer '26/Platform]] 참조.
- **Slack — 신규 org Salesforce channels 기본** — 신규 Enterprise/Unlimited 조직에서 Salesforce 채널 기본 활성화.

---

## Salesforce Overall

> 특정 클라우드에 속하지 않는 전사(Overall) 영역 GA. (Clouds.md가 GA 집약 노트이므로 여기에 둔다.)

### GA (2)

- **My Trust Center (GA)** — Salesforce My Trust Center에서 incident·major release·patch release·maintenance 업데이트를 모니터링. 지원 플랫폼 언어로 로케일화된 라벨·표준 메시지 제공, 브라우저 선호 형식으로 날짜 표시, 시스템 시간은 24시간 표기. (patch release 알림 구독 가능)
  > PDF 원문: "Stay Up to Date with the Salesforce My Trust Center (Generally Available) — Monitor incidents, major releases, patch releases, and maintenance updates. … View dates in your browser's preferred format, and review system times in 24-hour notation."
- **Salesforce Data Pipelines → Azure Data Lake 출력 (GA)** — Salesforce Data Pipelines recipe 출력 데이터셋을 `.csv`로 Azure Data Lake에 기록하는 출력 커넥터. (※ Analytics 섹션의 CRM Analytics Azure Data Lake 출력 GA와는 별개 항목 — 이쪽은 **Data Pipelines** 데이터다.)
  > PDF 원문: "Output Your Salesforce Data Pipelines Data to Azure Data Lake (Generally Available)"

---

## 관련 노트

- [[Summer '26]] — Summer '26 릴리즈 허브
- [[Summer '26/Agentforce]] — MCP Servers·에이전트 관련 클라우드 기능 상세
