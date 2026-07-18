---
tags: [Einstein, PredictionBuilder, PredictiveAI, CustomAI, 예측형AI]
source: help.salesforce.com sales.custom_ai_prediction_builder*.htm (2026-07-18 접속, Tier 2)
created: 2026-07-18
aliases: [Einstein Prediction Builder, 예측 빌더, likelihood 예측, Custom AI 예측, Point Click Predict]
---

# Einstein Prediction Builder

> 코드 없이(point-click) 표준/커스텀 객체 필드에 대한 likelihood(예/아니오) 또는 numeric(Beta) 예측 모델을 만드는 어드민용 커스텀 AI. Einstein이 매시간 레코드를 채점해 0~100 점수와 top predictor를 레코드에 표시한다.

---

## 개념 — 커스텀 AI for admins

Einstein Prediction Builder는 out-of-the-box Einstein 앱이 유스케이스에 맞지 않고, 코드도 작성하지 않는 어드민을 위한 **커스텀 AI**다. "Point. Click. Predict!" — 비즈니스의 미래를 예측한다.

두 종류의 예측을 만든다.

- **Yes/No 예측 (likelihood):** "이 제품이 팔릴 가능성은?", "이 고객이 구독을 갱신할 가능성은?" — 결과는 **0~100의 점수**로, yes일 likelihood를 나타낸다.
- **Number 예측 (numeric, Beta):** "올해 매출이 얼마일까?" — 결과는 **실제 예측값**. 매출을 달러로 예측하면 점수 `1,715,000`은 예측 매출.

> NOTE (Beta): Numeric 예측은 Beta Service다. 고객은 재량으로 시도할 수 있으며, 사용은 Agreements and Terms의 Beta Services Terms를 따른다.

예측형(비생성형) AI다. 생성형(Agentforce·Prompt Builder) 요소는 없다. 예측형 AI 도구 지도는 [[Einstein 예측형 AI 개요 — 예측 vs 생성형·도구 지도]] 참조.

---

## Considerations · 한도

### 지원 데이터 타입 (예측 대상 필드)

Einstein Prediction Builder는 다음 타입의 필드를 예측할 수 있다.

- Checkbox
- Specially-constructed formula fields (특별히 구성된 수식 필드)
- Numeric (Beta)

### 지원 객체

모든 **커스텀 객체**를 지원하며, 다음 **표준 객체**(27개)를 지원한다.

```
Account, AiVisitSummary, Asset, AssignedResource, Campaign, Case, Contact,
Contract, ContractLineItem, Entitlement, Lead, LinkedArticle, LiveChatTranscript,
Opportunity, Order, OrderItem, OpportunityLineItem, Product2, ProductConsumed,
Quote, QuoteLineItem, ServiceAppointment, ServiceContract, WorkOrder,
WorkOrderLineItem, WorkType, User
```

### Predictor 한도 (scorecard Details 탭)

- Scorecard의 Details 탭은 모델의 여러 predictor(각 predictor의 impact·correlation·importance/weight)를 표시한다.
- 모델에 predictor가 **100개를 초과**하면 전부 보이지 않을 수 있다. Scorecard는 impact 기준과 correlation 기준으로 각각 **top 100 predictor**를 표시한다.
- 모델에 predictor가 최소 100개 있으면, scorecard에 표시되는 개수는 대개 **100~200개** 사이다.

### 최소 데이터 요건

성공적인 예측을 만들려면 데이터셋에 충분한 레코드가 있어야 한다. 예측 객체에 세그먼트가 있으면 Einstein은 각 세그먼트가 충분한 레코드를 갖는지 확인한다.

| 데이터셋 유형 | 최소 레코드 수 |
|---|---|
| 전체 데이터셋 (세그먼트된 경우 각 세그먼트) | **400** |
| Example 레코드 (example set) | **400** |
| True/False 값 (binary 필드만) | **값당 100** |

> NOTE: 기본적으로 Einstein Prediction Builder는 **최근 2년** 내에 생성 또는 수정된 레코드만 고려한다.

> PDF 원문: "By default, Einstein Prediction Builder only considers records that were created or modified in the last 2 years."

### Sandbox에서의 예측

- Production에서 생성한 예측은 sandbox org으로 복사되지 않는다.
- Sandbox에서 예측을 쓰려면 production에서 라이선스를 복사하고 **새 예측을 새로 빌드**한다.
- 최상의 결과를 위해 최근 refresh된 full sandbox를 사용한다.

---

## Editions & Permissions

**Available in:** Enterprise, Performance, Unlimited, and Developer Editions

### 필요한 User Permissions

| 목적 | 권한 |
|---|---|
| 예측 빌드·조회 | Customize Application AND View Setup |
| 레코드에 Einstein Predictions 컴포넌트 조회·표시 | View AI Insight Objects AND Create AI Insight Objects AND View Setup and Configuration |
| 예측 점수 저장용 커스텀 필드 생성 (prediction results) | Manage Profiles or Permsets |

### 필요한 Object Permissions

| 목적 | 권한 |
|---|---|
| 레코드에 Einstein Predictions 컴포넌트 조회·표시 | AI Record Insights AND AI Insight Reasons 객체에 대한 Read, Create, View All Records |

---

## Set Up (활성화)

org 설정에서 Einstein Prediction Builder를 켠다.

```
// 구조 예시 — 실제 동작 코드 아님 (Setup UI 단계)
1. Setup의 Quick Find 박스에 "Einstein Prediction Builder" 입력 후 선택
2. 첫 사용이면 setup 페이지에서 Get Started 클릭. 진행 전 terms 검토·동의
3. 상태를 on 또는 off로 전환
   → off로 끄면 기존 예측이 disabled 된다. 다시 on 하면 재활성화 가능
```

---

## Build Your Prediction — 가이드 셋업 16단계

Guided Setup flow가 learning card·info bubble·notification·Salesforce Help로 예측 빌드를 안내한다. 코드 작성 없이 만든다.

```
// 구조 예시 — 실제 동작 코드 아님 (Guided Setup 단계 순서)
1.  Setup Quick Find에 "Einstein Prediction Builder" 입력 후 선택.
    또는 Setup Home의 Einstein Prediction Builder 타일에서 Get Started 클릭
2.  첫 사용이면 splash 페이지에서 Get Started 클릭 (아니면 다음 단계로)
3.  New Prediction 클릭
4.  Name & Type 페이지: 예측 이름 지정 (예: "Annual Revenue Prediction")
5.  다음 필드로 Tab/클릭 → API name 자동 채움
6.  다음 필드로 Tab/클릭 → 예측 설명 입력
7.  예측 타입 선택. 예: 특정 이벤트 등록 여부 예측 = Yes/No 예측,
    올해 매출 예측 = Number 예측. 그다음 Next
8.  Object 페이지: 예측할 필드를 포함하는 객체 선택
    (검색 필드에 이름 입력해 빠르게 찾기). 그다음 Next
9.  (선택) 데이터셋의 특정 세그먼트에 예측 집중. Segment 페이지에서
    "Segment of {Object}" (예: Segment of Account) 클릭. 그다음 Save & Next
10. Example Records 페이지: yes/no example 정의. 그다음 Save & Next
    NOTE: 기본적으로 Einstein은 example set에 없는 레코드만 채점한다.
          어떤 레코드를 채점할지 filter로 정의
11. Included Fields 페이지: 모델에서 고려하지 않을 필드 deselect
    NOTE: 기본은 모든 필드 선택됨. 특정 필드 deselect 시
          남은 선택 필드로만 예측이 빌드됨
12. Records to Predict 페이지: Einstein이 예측할 레코드 선택. 그다음 Next
13. Score Field 페이지: 예측 점수를 저장할 필드 이름 지정
    (예: "Predicted Annual Revenue")
14. 다음 필드로 Tab/클릭 → score field API name 자동 채움. 그다음 Save & Next
15. Review & Build 페이지: 예측 설정 신중히 검토.
    변경하려면 해당 페이지로 돌아갔다가 Next로 다시 Review & Build로
16. 준비되면 Build Prediction 클릭
```

빌드 후에는 scorecard를 검토한 뒤 예측을 enable할지 결정한다. Enable 후 Einstein은 **매시간 레코드를 확인**해 변경된 레코드에 새 점수를 제공한다.

> NOTE: enabled 또는 pending 상태의 예측은 편집할 수 없다. enabled 예측을 편집하려면 먼저 disable해서 설정을 변경한다.

### 빌드 보조 기능

- **Segment Your Data** — 데이터셋의 특정 세그먼트(예: 특정 지역·산업)에 예측을 집중. 관련 없는 레코드를 제외해 더 유용한 예측을 얻는다.
- **Check Your Data** — Data Checker가 빌드 중 데이터를 자동 검증하고 실시간으로 알려, 이슈를 조기에 잡는다.
- **Define Your Prediction Set** — Einstein이 예측 결과(점수)를 제공하는 레코드 집합(prediction set / scoring set). 기본은 example set에 없는 모든 레코드를 채점. example set 레코드를 채점하거나 filter로 특정 집합을 채점하도록 선택 가능.
- **Define Scoring Settings** — 채점 결과는 score field라는 커스텀 필드에 저장. 예측을 생성하거나 clone할 때마다 새 이름·API name을 부여해야 한다.

---

## 레코드의 예측 결과

레코드에는 세 가지 유형의 결과가 나타난다: **prediction scores, top predictors, confidence range**.

### Prediction Scores

예측이 반환하는 숫자. 예측 빌드 시 생성된 커스텀 필드에 저장된다.

- **Yes/No 예측:** "이 제품이 팔릴 가능성은?" 같은 경우, 점수는 **0~100의 숫자**로 yes일 likelihood를 나타낸다.
- **Numeric 예측 (Beta):** 점수는 실제 예측값. 매출을 달러로 예측하면 점수 `1,715,000`이 예측 매출.

> NOTE (Beta): Numeric 예측은 Beta Service다 (Beta Services Terms 적용).

### Top Predictors

예측과 레코드 페이지 레이아웃이 Einstein Predictions 컴포넌트를 표시하면 레코드에 top predictor가 보인다. Top predictor는 점수에 가장 큰 영향을 주는 필드(그리고 경우에 따라 그 값)다.

- 예: 구독 갱신 likelihood의 top predictor가 "Industry is Technology"일 수 있다.
- top predictor 값이 blank면, 그 필드가 **비어 있는 것 자체가 좋은 predictor**라는 뜻이다. 예: "Competitor is blank"는 Competitor 필드가 채워지지 않았을 때 결과의 top predictor임을 나타낸다.

### Confidence Range

Einstein Predictions 컴포넌트를 표시하는 numeric 예측(Beta)은 confidence range도 표시한다. 실제 점수의 low·high 값을 보여준다.

- 예: 점수 `420,000`은 `398,000–446,000`의 confidence range를 가질 수 있다.

---

## Scorecard (요약)

빌드가 끝나면 Einstein Prediction Builder scorecard에서 결과를 검토한다. prediction quality·top predictor 같은 big-picture 지표를 확인하고, 각 predictor의 impact·correlation·weight 같은 세부를 drill-in 한다. 라이선스가 부여하는 총 예측 수·enable 예측 수 안에서 예측을 enable/disable해 공간을 관리한다.

> 참고: Scorecard 세부(impact/correlation/weight)·Troubleshoot·Label Leakage·Package a Prediction(managed package로 여러 org 이식) 페이지는 이번 소스에서 verbatim 미추출 — 필요 시 후속 보강.

---

## 관련 노트

- [[Einstein 예측형 AI 개요 — 예측 vs 생성형·도구 지도]] — 예측형 AI 도구 지도·언제 무엇을
- [[Einstein Discovery — Model Builder·예측 모델]] — 더 정교한 예측 모델링(CRM Analytics 기반)
- [[Next Best Action — Strategy Builder·Recommendations]] — Enhance 요소로 예측 점수를 추천에 결합
