---
tags: [index, analytics, crm-analytics, data-prep, recipe-rest-api]
created: 2026-06-21
---

# Analytics(애널리틱스) — 로컬 인덱스

> Salesforce Analytics 도메인 — CRM Analytics(Tableau CRM) Data Prep Recipe REST API 개발자 가이드(Summer '26) 기반 — 레시피로 데이터를 변환·정제하는 REST API의 개요·인증·엔드포인트, 노드 Input 표현형(Bucket·Aggregate·Join·Formula·Filter·Load/Save·ML 등), Response 표현형, Enum까지 10노트
>
> ℹ️ Data Prep Recipe는 CRM Analytics에서 dataflow의 후속으로 데이터를 변환·정제하는 파이프라인이다. 이 폴더는 **Recipe REST API**(레시피 정의·노드를 JSON으로 다루는 API)를 다룬다. 후속 ING-08(Dashboards REST API)도 이 Analytics 폴더에 수용한다.

**상위:** [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Data Prep Recipe REST API — 개요·인증·엔드포인트]] | 진입 허브 — Recipe REST API 6개 엔드포인트·OAuth 인증·Examples 워크플로(레시피 생성→실행)·API 버전·EOL | #overview |
| [[Recipe REST API — Bucket·Cluster 노드 Input]] | Bucket 계열 노드 Input 표현형 26개(버킷팅·구간화·클러스터링 — 값을 범주로 묶는 변환) | #reference |
| [[Recipe REST API — Aggregate·Append·Join·Compute·Pivot Input]] | Aggregate·Append·Join·Compute·Pivot 노드 Input 표현형 20개(집계·결합·조인·계산·피벗) | #reference |
| [[Recipe REST API — Formula·Format·Typecast·Update Input]] | Formula·Format·Typecast·Update 노드 Input 표현형 23개(수식·서식·타입 변환·필드 갱신) | #reference |
| [[Recipe REST API — Filter·Flatten·Extract·Schema Input]] | Filter·Flatten·Extract·Schema 노드 Input 표현형 23개(필터·평탄화·추출·스키마) | #reference |
| [[Recipe REST API — Load·Save·Output·ML 노드 Input]] | Load·Save·Output·ML(머신러닝) 노드 Input 표현형 38개(소스 로드·저장·출력·예측) | #reference |
| [[Recipe REST API — Recipe 구성 Input]] | Recipe·Definition·Node 등 레시피 최상위 구성 Input 표현형 11개 | #reference |
| [[Recipe REST API — Response 표현형 (Bucket~Output)]] | Bucket부터 Output까지 노드 Response 표현형 86개(API 응답 JSON 구조) | #reference |
| [[Recipe REST API — Response 표현형 (Recipe~Update)]] | Recipe부터 Update까지 Response 표현형 50개 | #reference |
| [[Recipe REST API — Enums]] | API 전반에서 쓰이는 enum 47개(노드 타입·액션·데이터 타입·조인 타입 등 허용값 목록) | #reference |

---

## 빠른 선택

- 처음 시작 / Recipe REST API 엔드포인트·인증·레시피 생성·실행 워크플로 큰 그림 → [[Data Prep Recipe REST API — 개요·인증·엔드포인트]]
- 값을 버킷/구간/클러스터로 묶는 노드를 JSON으로 정의 → [[Recipe REST API — Bucket·Cluster 노드 Input]]
- 집계·여러 데이터셋 결합·조인·계산 컬럼·피벗 노드 정의 → [[Recipe REST API — Aggregate·Append·Join·Compute·Pivot Input]]
- 수식 컬럼·서식·데이터 타입 변환·필드 값 갱신 노드 정의 → [[Recipe REST API — Formula·Format·Typecast·Update Input]]
- 행 필터·중첩 평탄화·문자열 추출·스키마 조정 노드 정의 → [[Recipe REST API — Filter·Flatten·Extract·Schema Input]]
- 데이터 소스 로드·결과 저장·출력·ML 예측 노드 정의 → [[Recipe REST API — Load·Save·Output·ML 노드 Input]]
- 레시피 자체(Recipe/Definition/Node) 최상위 구조 정의 → [[Recipe REST API — Recipe 구성 Input]]
- API가 돌려주는 응답 JSON 구조(노드별 Response, Bucket~Output) → [[Recipe REST API — Response 표현형 (Bucket~Output)]]
- 응답 JSON 구조(Recipe~Update) → [[Recipe REST API — Response 표현형 (Recipe~Update)]]
- 필드에 들어갈 수 있는 허용값(노드 타입·액션·데이터/조인 타입 enum) → [[Recipe REST API — Enums]]

---

## 관련 폴더

- 후속: CRM Analytics Dashboards REST API(ING-08) — 동일 Analytics 폴더 수용 예정
- 표준/커스텀 sObject·데이터 소스 객체 레퍼런스 → [[sObject/index|sObject Reference]]
- Apex에서의 외부 데이터 연동 → [[Apex/Integration(통합)/index|Apex Integration(통합)]]
