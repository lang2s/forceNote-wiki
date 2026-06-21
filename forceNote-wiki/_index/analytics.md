---
tags: [index, search, navigation, analytics]
created: 2026-06-21
---

# SEARCH INDEX — Analytics(애널리틱스) (CRM Analytics Data Prep Recipe REST API, Summer '26)
> CRM Analytics(Tableau CRM) Data Prep Recipe REST API — 레시피로 데이터를 변환·정제하는 REST API의 개요·인증·엔드포인트·노드 Input·Response·Enum 10노트
> 루트 라우터: `00 SEARCH_INDEX.md` · 다른 샤드는 라우터에서 이동.
> source: salesforce_recipes_api.pdf (Data Prep Recipe REST API Developer Guide Summer '26, Tier 2)

---

## 개요·인증·엔드포인트 — 진입 허브

| 키워드 | 파일 |
|---|---|
| Data Prep Recipe REST API, Recipe REST API, CRM Analytics REST API, Tableau CRM Recipe API, recipe endpoint, /wave/recipes, /wave/dataprepRecipes, OAuth 인증, access token, Examples workflow, 레시피 생성 API, 레시피 실행 API, 레시피 REST API 개요, 데이터 프렙 레시피 API, CRM Analytics에서 데이터 변환 API, 레시피를 REST로 만드는 법, 레시피 엔드포인트가 뭐야, Recipe API 인증 방법, Recipe API 버전, EOL, retirement | `Analytics(애널리틱스)/Data Prep Recipe REST API — 개요·인증·엔드포인트.md` |

## 노드 Input 표현형 — 데이터 변환 노드 JSON

| 키워드 | 파일 |
|---|---|
| Bucket node, Cluster node, BucketInput, bucketing, 구간화, 클러스터링, 값을 범주로 묶기, 버킷 노드 Input, 클러스터 노드 입력, 버킷팅 어떻게 정의해, Bucket 노드 JSON | `Analytics(애널리틱스)/Recipe REST API — Bucket·Cluster 노드 Input.md` |
| Aggregate node, Append node, Join node, Compute node, Pivot node, AggregateInput, JoinInput, 집계 노드, 데이터셋 결합, 조인 노드, 계산 컬럼, 피벗 노드, 두 데이터셋 합치기, 레시피에서 조인하는 법, 집계 노드 입력 정의 | `Analytics(애널리틱스)/Recipe REST API — Aggregate·Append·Join·Compute·Pivot Input.md` |
| Formula node, Format node, Typecast node, Update node, FormulaInput, 수식 노드, 서식 노드, 타입 변환, 필드 값 갱신, 계산식 컬럼 추가, 데이터 타입 바꾸기, 필드 업데이트 노드, 수식 컬럼 정의 | `Analytics(애널리틱스)/Recipe REST API — Formula·Format·Typecast·Update Input.md` |
| Filter node, Flatten node, Extract node, Schema node, FilterInput, 필터 노드, 평탄화, 문자열 추출, 스키마 조정, 행 거르기, 중첩 데이터 평탄화, 정규식 추출, 필터 노드 정의 | `Analytics(애널리틱스)/Recipe REST API — Filter·Flatten·Extract·Schema Input.md` |
| Load node, Save node, Output node, ML node, machine learning node, LoadInput, SaveInput, 소스 로드, 결과 저장, 출력 노드, 머신러닝 예측 노드, 데이터셋 불러오기, 레시피 결과 저장, 예측 노드 정의, ML 노드 입력 | `Analytics(애널리틱스)/Recipe REST API — Load·Save·Output·ML 노드 Input.md` |
| Recipe input, Definition input, Node input, RecipeInput, DefinitionInput, NodeInput, 레시피 구성, 레시피 최상위 구조, 노드 정의 컨테이너, 레시피 정의 JSON, Recipe Definition Node 차이 | `Analytics(애널리틱스)/Recipe REST API — Recipe 구성 Input.md` |

## Response 표현형 — API 응답 JSON

| 키워드 | 파일 |
|---|---|
| Recipe Response, node Response, BucketRepresentation, Output Representation, 노드 응답 표현형, API 응답 구조, Bucket부터 Output까지 응답, 레시피 API 응답 JSON, 노드 Response 구조, 응답 표현형 Bucket Output | `Analytics(애널리틱스)/Recipe REST API — Response 표현형 (Bucket~Output).md` |
| Recipe Representation, Update Representation, RecipeRepresentation, 레시피 응답 표현형, Recipe부터 Update까지 응답, 레시피 자체 응답 구조, 응답 표현형 Recipe Update, 레시피 메타데이터 응답 | `Analytics(애널리틱스)/Recipe REST API — Response 표현형 (Recipe~Update).md` |

## Enums — 허용값 목록

| 키워드 | 파일 |
|---|---|
| Recipe API enums, node type enum, action enum, data type enum, join type enum, 47개 enum, 노드 타입 열거형, 액션 열거형, 데이터 타입 허용값, 조인 타입 허용값, 레시피 API enum 목록, 필드에 들어갈 수 있는 값, Recipe enum 전체 | `Analytics(애널리틱스)/Recipe REST API — Enums.md` |
