---
tags: [crm-analytics, tableau-crm, einstein-analytics, analytics-cloud, overview]
source: help.salesforce.com (Salesforce Help — CRM Analytics; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=sf.wave_overview.htm&type=5
created: 2026-07-03
aliases: [CRM Analytics, 씨알엠 애널리틱스, Tableau CRM, Einstein Analytics, Wave, Analytics Cloud, 분석 클라우드]
---

# CRM Analytics 개요

> Salesforce·외부 데이터를 인터랙티브 대시보드·앱으로 탐색하고 Einstein으로 예측하는 고급 분석 플랫폼. 표준 Reports & Dashboards와는 별개의 제품이다. (구 Tableau CRM / Einstein Analytics / Wave.)

---

## CRM Analytics란

**CRM Analytics**는 Salesforce(및 외부) 데이터를 **인터랙티브 대시보드·lens·앱**으로 탐색·분석하는 고급 분석 플랫폼이다. AI(**Einstein**)를 통해 예측과 인사이트를 함께 제공한다.

- 데이터를 시각적으로 탐색하고, 필터링·드릴다운하며, 도메인에 맞춘 분석 앱을 배포할 수 있다.
- 예측 모델과 추천은 **Einstein Discovery**가 담당한다.

### 명칭 변천

이 제품은 시대에 따라 여러 이름으로 불렸다.

- **Wave** → **Einstein Analytics** → **Tableau CRM** → **CRM Analytics**

동일 제품의 브랜드 변경이며, 위키·공식 문서에서 이 이름들이 혼용될 수 있다.

## Prebuilt 분석 앱

도메인별로 미리 구성된 prebuilt analytics 앱을 제공한다(예시).

- **Sales Analytics** — 영업 도메인 분석 앱
- **Service Analytics** — 서비스 도메인 분석 앱
- **Einstein Discovery** — 예측 모델·추천 제공

## 무엇과 다른가 (구분)

| 대상 | 구분 |
|---|---|
| 표준 **Reports & Dashboards** | 선언적(declarative) 리포트/대시보드 기능. CRM Analytics와 **별개 제품**이다. → [[Reports (리포트)]] · [[Dashboards (대시보드)]] |
| **Tableau** | 별도의 독립 제품. CRM Analytics와 다르다. |

## 구성 개요

아래는 CRM Analytics의 구성을 텍스트로 정리한 예시 도식이다.

```
// 구조 예시 — CRM Analytics(실제 원본 다이어그램 아님)
데이터셋(Salesforce/외부) → Lens/Dashboard/App(인터랙티브)
   prebuilt: Sales Analytics · Service Analytics …
   Einstein Discovery: 예측·추천
표준 Reports & Dashboards(ADMIN)와 별개 · Tableau와도 별개
기술 상세 → Analytics(애널리틱스)/ 폴더
```

> 데이터셋·SAQL·대시보드 빌더 등 기술 세부는 이 개요의 범위 밖이며, 공식 문서 및 위키 `Analytics(애널리틱스)/` 폴더에 위임한다.

## 관련 노트

- [[Salesforce 제품 클라우드 개요]] — 전체 클라우드 지도 허브
- [[Reports (리포트)]] — 표준 선언적 리포트(구분 대상)
- [[Dashboards (대시보드)]] — 표준 대시보드(구분 대상)
