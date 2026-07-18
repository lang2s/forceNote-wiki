---
tags: [Einstein, PredictiveAI, ClassicAI, SalesCloudEinstein, AI개요, 예측형AI]
source: help.salesforce.com ai.einstein_sales / einstein_sales_lead_insights / einstein_sales_opportunity_scoring / einstein_sales_forecasting(_considerations).htm (2026-07-18 접속, Tier 2)
created: 2026-07-18
aliases: [Einstein 예측형 AI, Predictive AI, 클래식 AI, Einstein Platform, Einstein 개요, Sales Cloud Einstein]
---

# Einstein 예측형 AI 개요 — 예측 vs 생성형·도구 지도

> 생성형(Agentforce·Prompt Builder)과 구분되는 Einstein의 **예측형(비생성형) AI** 계열 — Prediction Builder·Next Best Action·Discovery + Sales Cloud Einstein의 Lead/Opportunity Scoring·Forecasting — 을 한눈에 잇는 도구 지도.

---

## 예측형(비생성형) AI란

Einstein의 예측형 AI는 과거 CRM 데이터에서 통계 모델링·supervised machine learning으로 패턴을 학습해 **미래 결과를 예측(prediction)**하고, 점수·추천·개선안을 제시한다. 데이터 사이언스에 기반한다("It's built with science. Data science.").

예: 어떤 리드가 전환될지(Lead Scoring), 어떤 기회가 성사될지(Opportunity Scoring), 다음 분기 매출이 얼마일지(Forecasting), 커스텀 필드 값이 어떻게 될지(Prediction Builder).

## 예측형 ↔ 생성형 경계

> ⚠️ 아래 경계 서술의 일부(제품 계열 대비)는 소스 dump 밖의 **추정·비단정** 정리다. 확정 사실은 각 스포크 노트의 소스 인용을 따른다.

- **예측형(이 노트 계열):** 데이터 패턴 → 점수·확률·추천·개선안. Prediction Builder / Next Best Action / Discovery / Lead·Opportunity Scoring / Forecasting. **생성형 요소 없음.**
- **생성형(별개 계열):** LLM으로 자연어·콘텐츠·대화를 생성. **Agentforce·Prompt Builder·Copilot** 등 — 이 노트 범위 밖. 제품·에이전트 유형은 [[Agentforce 개요 — 제품·에이전트 유형·구성요소]] 참조. (추정: 두 계열은 별도 라이선스·설정 트랙으로 운영됨.)

---

## 도구 지도 — 언제 무엇을

| 도구 | 무엇을 하나 | 대표 유스케이스 | 상세 노트 |
|---|---|---|---|
| **Einstein Prediction Builder** | 코드 없이 커스텀 likelihood/numeric 예측 모델 | 표준/커스텀 필드 값 예측 (갱신 여부·예측 매출 등) | [[Einstein Prediction Builder]] |
| **Next Best Action** | 전략 + 예측으로 적시 추천 표면화 | 수리·할인·부가 서비스 등 맞춤 offer | [[Next Best Action — Strategy Builder·Recommendations]] |
| **Einstein Discovery** | 정교한 예측·처방 모델링(CRM Analytics) | why 분석 + 예측 + improvement 제안 | [[Einstein Discovery — Model Builder·예측 모델]] |
| **Einstein Lead Scoring** | 전환 패턴으로 리드 점수화 | 리드 우선순위 지정 | (본 노트 아래 섹션) |
| **Einstein Opportunity Scoring** | 성사 likelihood로 기회 점수화(1~99) | 딜 우선순위 지정 | (본 노트 아래 섹션) |
| **Einstein Forecasting** | AI로 예측 정확도·가시성 향상 | 파이프라인 예측 | (본 노트 아래 섹션) |

**언제 무엇을 (가이드):**

```
// 구조 예시 — 실제 동작 설정 아님 (선택 가이드)
- 표준 Lead/Opportunity에 즉시 점수가 필요       → Lead/Opportunity Scoring (out-of-the-box)
- 임의 객체/필드에 코드 없이 커스텀 예측이 필요    → Einstein Prediction Builder
- why(진단)·처방(개선안)까지 정교한 모델링이 필요  → Einstein Discovery
- 예측을 "추천" 형태로 사용자에게 제시            → Next Best Action (Enhance로 위 예측 결합)
- 팀 파이프라인 매출 예측                        → Einstein Forecasting
```

Prediction Builder·Discovery의 예측은 Next Best Action의 **Enhance 요소**를 통해 추천에 결합될 수 있다(예측 → 추천 소비 흐름).

---

## Sales Cloud Einstein — 허브

**Sales Cloud Einstein**은 팀의 세일즈 활동·CRM 데이터로 학습하는 자체 데이터 사이언스 부서다. 최적 리드 식별, 기회 효율적 전환, 고객 유지를 돕는다. Sales Analytics 앱과 Inbox도 포함한다.

- **Available in:** Lightning Experience, Salesforce Classic
- **Available with:** Sales Cloud Einstein — **Performance·Unlimited Edition**에서 사용 가능, **Enterprise Edition은 추가 비용**.
- 가격은 Salesforce account executive에 문의.

> ⚠️ Sales Cloud Einstein은 **Government Cloud에서 미지원**. Government Cloud·Government Cloud Plus org에서 이 기능을 켜지 말 것.

구성 요소: Einstein Activity Capture(이메일·일정 자동 캡처), Einstein Insights, Einstein Scoring, Einstein Forecasting. 셋업은 Sales Cloud Einstein Setup Assistant로 진행.

---

## Einstein Lead Scoring

AI로 리드를 회사의 성공적 전환 패턴에 얼마나 부합하는지로 점수화한다. 세일즈 팀이 lead score로 리드 우선순위를 정하고, 어떤 필드가 각 점수에 가장 큰 영향을 주는지 본다.

- data science·ML로 리드 전환 패턴을 발견 → 어떤 현재 리드를 우선할지 예측. 룰 기반 방식보다 단순·빠르고 정확.
- 과거 리드를 분석해 이전에 전환된 리드와 가장 공통점이 많은 현재 리드를 판단. 기본적으로 대부분의 lead field로 점수화(어드민이 특정 필드를 제외 가능).
- 특정 lead text 필드(예: job title)에 대해 내부 카테고리를 생성. 예: title이 CEO면 **C-level job rank**를 할당. 더 작은 job rank·department 목록으로 연관해 패턴을 쉽게 발견.
- **10일마다** 리드 데이터를 재분석하고 점수를 refresh → 새 트렌드를 놓치지 않는다.
- 세그먼트 없이 모든 리드를 함께 점수화하고 자체 모델을 만들 전환 데이터가 부족하면 **global model**(여러 Salesforce 고객의 익명 데이터) 사용. 충분한 데이터가 쌓이면 자체 데이터로 모델을 만들고 결과가 더 나은 쪽을 사용.
- 리드에 **Lead Score 필드** 추가. lead detail 페이지의 **Einstein Score 컴포넌트**에 점수와 영향을 가장 크게 준 필드(positive/negative)를 표시. list view에 추가하면 hover 시 top factor 표시, lock 아이콘은 점수가 read-only임을 표시.
- 대시보드 리포트: Average Lead Score by Lead Source / Conversion Rate by Lead Score / Lead Score Distribution: Converted and Lost Opportunities.

**에디션:** Lightning Experience·Salesforce Classic. Sales Cloud Einstein(Performance·Unlimited, Enterprise는 추가 비용). 리드 자체 개념은 [[Leads (리드)]] 참조.

---

## Einstein Opportunity Scoring

AI가 올바른 기회에 집중하도록 도와 더 많은 딜을 성사시킨다. 각 기회에 **1~99 점수**를 부여하며, opportunity 레코드·list view에서 확인. forecasts를 쓰면 forecasts 페이지에서도 사용 가능. 리포트·Process Builder·workflow에서도 활용.

- **Sales Cloud Einstein 라이선스 유무와 무관하게** 사용 가능.
- opportunity score는 기회가 성사될 likelihood를 알려주고, 점수에 가장 크게 기여한 요인(positive·negative)을 함께 표시.
- **Lightning Experience:** 점수가 opportunity 레코드의 compact layout 또는 Details 탭에 표시. hover 시 기여 요인 목록. 예: 다른 기회 대비 stage를 빠르게 통과 중이라 점수가 상대적으로 높을 수 있음.
- **Salesforce Classic:** 점수가 opportunity 레코드 상세에 표시, 기여 요인도 표시. (단 Classic list view에서는 기여 요인 미제공 → 레코드 상세로 이동.)
- Opportunity Score 필드를 list view에 추가 가능. public list view에 안 보이면 어드민에 추가 요청. forecasts를 쓰면 어드민이 forecasts 페이지의 opportunity 목록에 점수 추가 가능.

**에디션:** Lightning Experience·Salesforce Classic. Sales Cloud Einstein(Performance·Unlimited, Enterprise 추가 비용). **적격 고객은 Enterprise·Performance·Unlimited에서 추가 비용 없이** 사용 가능. 기회 자체 개념은 [[Opportunities (기회)]] 참조.

---

## Einstein Forecasting

AI로 예측의 확실성·가시성을 높인다. 예측 정확도를 개선하고 forecast prediction을 얻으며 세일즈 팀 성과를 추적한다.

- Einstein Forecasting을 켜면 forecasts 페이지 summary에 **Einstein prediction 컬럼** 표시. 값은 각 매니저 팀의 **median 예측 금액**. 예측은 **Best Case·Commit** forecast 카테고리 내 기회에 기반.
- 충분한 이력 데이터가 없거나 예측 범위가 너무 커 유용하지 않으면 예측이 표시되지 않을 수 있다.
- 예측은 기본 US dollar (multi-currency면 사용자 선택 통화로 어드민의 static conversion rate로 변환).
- **details 패널:** Range(예측값 전체 범위, median 계산에 사용) / Breakdown(Wins from Existing Deals, Wins from New Deals, Pulled In) / Top Factors.
- **Weekly Changes Chart:** grid view → chart view로 전환해 현재 forecast 기간 내 예측 마감을 시각화. "Einstein Prediction This Week" 지표는 이번 주말까지 Closed Won으로 예측되는 값. 점선 projection line은 이번 주부터 기간 말까지 Closed Won 예측값.

### Considerations — 셋업 요건

```
// 구조 예시 — 실제 동작 설정 아님 (요건 체크리스트)
□ Salesforce Forecasting이 활성화돼 있어야 함
□ Salesforce에서 opportunity를 최소 12개월 다뤄야 함
  (opportunity history가 지난 12개월 각 달에 최소 1개 update를 보여야 함)
□ standard fiscal year 사용 (Gregorian 캘린더, 연중 어느 달 1일이든 시작 가능)
□ opportunity revenue로 측정. 가장 오래된 activated opportunity revenue
  forecast type에 대해서만 예측 생성
□ forecast hierarchy에 forecast manager에게 보고하는 forecasting-enabled
  사용자 최소 1명 포함
□ 표준 Opportunity 객체와 표준 Close Date·Amount 필드 사용 (커스텀 date 필드 미지원)
□ Amount 필드가 open opportunity의 최소 80%에서 채워져 있어야 함
□ Opportunity splits 미지원 (총 매출 기반, 공유 매출 아님)
□ Territories 미지원 (user role hierarchy 기반)
□ home 페이지 prediction graph를 보려면 Forecasting Item에 historical trending 활성화
□ production org에서만 사용 가능, sandbox 불가
□ Sales Insights Integration User Profile의 opportunity 필드에 FLS 설정 지양
  (forecasting 정확도에 영향)
```

**picklist 값 삭제/비활성화 시 field filter 동작:**
- 표준 필드의 picklist 값 **삭제** → 그 값으로 field filter 설정 불가.
- 표준 필드의 picklist 값 **비활성화** → 새 field filter 설정엔 사용 불가하나, 그 값 기반 기존 filter는 비활성 값을 담은 레코드에 계속 작동.
- 표준 필드 값으로 filter 생성 후 그 값을 삭제 → filter는 계속 작동하나 Setup에 blank 값으로 표시.
- **커스텀** 필드의 picklist 값 삭제 → Setup에 여전히 표시되나 그 값으로 만든 filter는 미작동.
- 커스텀 필드의 picklist 값 비활성화 → 여전히 field filter 설정에 사용 가능.

**에디션:** Lightning Experience·Salesforce Classic. Sales Cloud Einstein(Performance·Unlimited, Enterprise 추가 비용). Collaborative Forecasts 자체는 [[Collaborative Forecasts (예측)]] 참조.

---

## 에디션·라이선스 개괄

| 도구 | 에디션·라이선스 |
|---|---|
| Sales Cloud Einstein (Lead/Opportunity Scoring·Forecasting 포함) | Performance·Unlimited, Enterprise 추가 비용. Government Cloud 미지원 |
| Einstein Opportunity Scoring | 위 + 적격 고객은 Enterprise·Performance·Unlimited 추가 비용 없이. 라이선스 유무 무관 사용 |
| Einstein Prediction Builder | Enterprise·Performance·Unlimited·Developer |
| Einstein Discovery | Enterprise·Performance·Unlimited·Developer + CRM Analytics Plus 또는 Einstein Predictions 라이선스(추가 비용) |
| Next Best Action | View supported editions for Next Best Action (지원 에디션 별도 확인) |

---

## 관련 노트

- [[Einstein Prediction Builder]] — 코드 없는 커스텀 예측
- [[Next Best Action — Strategy Builder·Recommendations]] — 예측 결합 추천 엔진
- [[Einstein Discovery — Model Builder·예측 모델]] — 정교한 예측·처방 모델링
- [[CRM Analytics 개요]] — Discovery의 플랫폼 컨텍스트
- [[Agentforce 개요 — 제품·에이전트 유형·구성요소]] — 생성형 AI 계열(경계 대비)
- [[Leads (리드)]] · [[Opportunities (기회)]] · [[Collaborative Forecasts (예측)]] — 점수화·예측이 얹히는 표준 객체
