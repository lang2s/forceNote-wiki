---
tags: [Einstein, NextBestAction, StrategyBuilder, Recommendations, PredictiveAI]
source: help.salesforce.com platform.einstein_next_best_action / nba_strategy_elements / nba_recommendation_fields / nba_strategy_builder_creating.htm (2026-07-18 접속, Tier 2)
created: 2026-07-18
aliases: [Next Best Action, NBA, Strategy Builder, Recommendation Strategy, 추천 전략, Einstein Next Best Action]
---

# Next Best Action — Strategy Builder·Recommendations

> 비즈니스 로직(전략)과 예측 모델(Discovery·Prediction Builder)을 결합해 적시에 맞춤 추천(수리·할인·부가 서비스 등)을 표면화하는 예측형 추천 엔진. Recommendation 레코드를 전략으로 걸러 Lightning 페이지·Experience 사이트에 표시한다.

---

## NBA 아키텍처

Einstein Next Best Action은 고유 기준에 맞춘 offer·action을 만들어 표시한다. 흐름은 다음과 같다.

1. **Create Recommendations** — 추천할 offer/action을 만든다. Recommendation은 account·contact와 유사한 표준 Salesforce **레코드**로, 전략이 처리하고 flow와 연결된다.
2. **Building a Strategy** — 전략은 비즈니스 룰·예측 모델·기타 데이터 소스로 어떤 recommendation 레코드를 표면화할지 결정한다. 결과는 컨텍스트별 추천이다.
3. **Display Recommendations** — 전략을 실행할 페이지를 선택해 추천을 표시한다. Lightning record page, 앱 home page, Experience Cloud site page, Visualforce page, 외부 사이트 중 원하는 곳.
4. **Report On and Track** — 커스텀 report type을 만들어 추천 데이터·전략 지표를 추적한다. 월별 총 추천 수, accept/reject 분석, 누가 응답했는지 등.

예측형(비생성형) 엔진이다. Enhance 요소를 통해 [[Einstein Discovery — Model Builder·예측 모델]]·[[Einstein Prediction Builder]]의 예측 점수를 추천에 결합한다. (Einstein Recommendation Builder는 AI 자동 생성 추천으로, 여전히 예측형 ML 범주.)

---

## 현행 저작 경로 — Flow가 권장, Strategy Builder는 대체

> PDF 원문(NOTE): "Where possible, we recommend building strategies in Flow Builder using the Recommendation Strategy flow type, but you can also create them in Strategy Builder."

- **권장(현행):** Flow Builder의 **"Recommendation Strategy" flow type**로 전략을 만든다.
- **대체:** Strategy Builder로도 만들 수 있다.

전략은 Salesforce Lightning record page에 언제·어떻게 추천을 표시할지 결정한다. 예: 일부 고객에게 할인을 제공하려면, 적절한 고객 레코드를 수집하고 표시할 할인 옵션을 식별하는 전략을 만든다.

> 참고: 이 노트는 **저작(authoring)** 측을 다룬다. 만들어진 추천의 **표시·소비**(Actions & Recommendations 컴포넌트 등)는 [[Lightning Flow for Service (Actions & Recommendations)]] 참조 — 그 메커니즘은 해당 노트가 정본이다.

---

## Recommendation 객체 필드

Recommendation은 사용자가 Einstein Next Best Action 전략을 통해 보고 상호작용하는 제안 액션이다. 생성 방법은 세 가지.

- Flow Builder 또는 Strategy Builder에서 필요에 따라 recommendation 조립
- **Recommendation 객체**에 표준 Salesforce 레코드로 생성 (App Launcher의 Recommendations 탭에서 recommendation 레코드 생성 가능)
- **Einstein Recommendation Builder**로 AI를 통해 자동 생성

### 표시(look and feel) 필드

| 필드 | 설명 | 표시 조건 (Lightning 컴포넌트) |
|---|---|---|
| **Image** | 추천에 표시되는 이미지 | 컴포넌트 구성 시 Show Image 선택 |
| **Name** | 추천 상단의 헤더 텍스트 | Show Title 선택 |
| **Description** | 추천에 표시되는 추가 설명 텍스트 | Show Description 선택 |
| **Acceptance Label** | 추천을 수락하는 버튼의 텍스트 | 항상 표시됨 |
| **Rejection Label** | 추천을 거부하는 버튼의 텍스트 | Show Reject Option 선택 |

### 실행(how it runs) 필드

| 필드 | 설명 |
|---|---|
| **Action** | 사용자가 Accept 옵션을 선택할 때 실행되는 flow. 수락/거부 모두에서 실행하려면 컴포넌트 구성 시 **Launch Flow on Rejection** 선택. 참조된 flow가 inactive·invalid이거나 미지원 Flow Type이면 추천이 표시되지 않는다. **지원 flow type: screen flow, autolaunched flow.** |

---

## Strategy Builder 요소 전체 카탈로그

Strategy Builder를 열고 Toolbox에서 Elements를 선택한 뒤 요소를 canvas로 드래그해 전략을 만든다. 요소는 두 범주로 나뉜다 — **Recommendation Logic**(추천에 직접 작용: filter·sort·limit)과 **Branch Logic**(gate 역할: 컨텍스트 정보로 어떤 추천 집합을 통과시킬지 결정).

| 요소 | 범주 | 기능 |
|---|---|---|
| **Enhance** | Recommendation | Einstein Discovery·Einstein Prediction Builder 등 서비스에서 AI 예측(예: propensity score)을 가져와 추천을 보강. 전략 실행마다 추천 집합을 즉석에서 수정. 추천은 static(Salesforce 레코드)이거나 dynamic(외부 데이터·다른 객체)일 수 있다. |
| **Generate** | Recommendation | 가능성이 많아 수동 생성이 불편할 때 개인화 추천을 동적 생성. 외부 데이터 소스나 다른 Salesforce 객체에서 in-memory 즉석 추천 생성. |
| **Load** | Recommendation | 전략 branch의 **첫 요소**. Recommendation 객체의 레코드를 load·filter. 또는 임의 객체의 레코드를 load·filter한 뒤 전략 끝에서 Map 요소로 recommendation으로 변환. 어떤 추천이 평가될지 결정. |
| **Filter** | Recommendation | 컨텍스트에 따라 원치 않는 추천을 차단·필터하는 expression 생성. branch를 통과하는 모든 추천마다 평가됨. |
| **Limit Reoffers** | Recommendation | 같은 추천을 사용자가 보는 빈도 결정. 사용자가 추천에 몇 번 반응해야 하는지, 다시 표시하기까지 며칠 기다릴지 결정. |
| **Map** | Recommendation | Apex 코드 대신 formula로 Recommendation 필드를 생성·수정. 한 이름의 Recommendation 필드 데이터를 다른 이름의 flow input으로 전달, 또는 Description·Name 등을 컨텍스트별 데이터로 개인화. |
| **Sort** | Recommendation | branch 내에서 추천이 정렬되는 방식 선택, Recommendation 필드로 재정렬. |
| **Branch Merge** | Branch | 여러 branch의 추천을 단일 branch로 결합. |
| **Branch Selector** | Branch | 여러 branch를 branch selector로 필터하고 각 branch마다 고유 expression 생성. expression이 true면 그 branch의 추천이 통과되어 단일 branch로 결합. |
| **First Non-Empty Branch** | Branch | canvas에 나타나는 순서대로 branch를 필터. 추천을 포함한 **첫 branch만 통과**, 나머지 branch는 모두 차단. |

> ℹ️ **범주 열 주석:** 소스는 요소가 "두 범주(Recommendation Logic·Branch Logic)로 나뉜다"고만 명시하고 요소별 배정 열을 두지 않는다. 위 표의 범주 열은 각 요소의 성격(추천에 직접 작용 vs branch gate)에 따른 분류이며, Filter·Sort·Limit Reoffers·Branch 계열은 소스 정의로 직접 확인되고 나머지는 성격상 추론이다.

---

## Strategy Builder로 전략 생성 단계

전략을 만들기 전, 전략에 쓸 flow와 recommendation 레코드를 먼저 만들어 둔다.

### 필요한 User Permissions

| 목적 | 권한 |
|---|---|
| action strategy 생성·관리 | Modify All Data OR Manage Next Best Action Strategies |
| action strategy 실행 | Run Flows OR 사용자 상세 페이지에서 Flow User 필드 활성화 |

### 단계

```
// 구조 예시 — 실제 동작 코드 아님 (Strategy Builder UI 단계)
1. Strategy Builder 열기. Setup의 Quick Find에 Strategies 또는
   Next Best Action 입력 → Next Best Action 선택 → New Strategy 클릭
2. 전략 이름·설명 지정
3. "Object Where Recommendations Display"에서 context object 선택
   NOTE: 여기서 고른 객체가 전략 전체의 컨텍스트를 제공한다. 예: Case 페이지에
         쓸 전략이면 Case 선택. 전략 실행 시 NBA 엔진이 recordId를 case
         객체로 해석. 객체를 특정 객체에 연결하면 Test 기능 등에서
         intelligent assistance도 활성화됨
4. 적절한 요소를 canvas로 드래그
   NOTE: 추천 로딩이 모든 전략의 첫 단계이므로 Load 요소부터 추가하는 것이 좋다
5. 요소를 정렬해 추천이 올바른 branch를 흐르게 함
6. 전략 변경 저장
7. 기대대로 동작하는지 전략 test
   NOTE: 제대로 실행되지 않거나 예상치 못한 에러가 보이면 Inspector 탭 사용
8. Experience Builder의 Suggested Actions 컴포넌트 또는
   Lightning App Builder의 Einstein Next Best Action 컴포넌트로 전략 표시
```

### 전략 확장 — expression·Apex·패키징

- **Write a Strategy Builder Expression** — Salesforce expression builder 로직으로 고유 expression을 만들어 추천을 필터, branch를 선택/해제, 어떤 추천을 고려 대상으로 삼을지 결정.
- **Action Strategy Connection** — **Apex actions**로 외부 데이터 소스와 org 정보를 전략에 통합.
- **Custom Notification Flow** — Process Builder에 trigger를 만들어 전략 에러 알림을 직접 수신. flow를 실행해 에러 정보를 원하는 대상으로 전송.
- **Package·Distribute a Strategy Builder Template** — Enterprise 개발자는 Developer Edition org에서 전략 템플릿을 만들어 패키징, 여러 org에서 사용. ISV는 AppExchange에 템플릿을 게시해 구독자에게 배포. managed package에서 template로 표시되지 않은 전략은 **IP(지적재산) 보호**를 받아 편집·clone 불가 — 독점 정보를 보호한다.

> 참고: **RecommendationStrategy 메타데이터 타입**은 Metadata API Developer Guide 소관으로 이번 소스(help.salesforce.com) 범위 밖. 필요 시 Metadata API 문서에서 별도 추출.

---

## 배포 후 표시

전략 생성 후 실행할 페이지를 선택한다.

- **Lightning App Builder** — Einstein Next Best Action 컴포넌트
- **Experience Builder** — Suggested Actions 컴포넌트
- 그 외 Lightning record page, 앱 home page, Experience Cloud site page, Visualforce page, 외부 사이트

표시·소비 측 컴포넌트 구성(Show Image/Title/Description/Reject Option, Launch Flow on Rejection 등)은 위 [Recommendation 객체 필드](#recommendation-객체-필드) 표와 [[Lightning Flow for Service (Actions & Recommendations)]] 참조.

---

## 관련 노트

- [[Einstein 예측형 AI 개요 — 예측 vs 생성형·도구 지도]] — 예측형 AI 도구 지도
- [[Einstein Prediction Builder]] — Enhance 요소가 결합하는 예측 소스
- [[Einstein Discovery — Model Builder·예측 모델]] — Enhance 요소가 결합하는 예측 소스
- [[Lightning Flow for Service (Actions & Recommendations)]] — 추천의 표시·소비(consumer) 측
