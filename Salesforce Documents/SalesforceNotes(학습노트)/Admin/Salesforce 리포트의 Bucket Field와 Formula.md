---
tags: [admin, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Bucket Fields & Formulas in Salesforce Reports]
---

# Salesforce 리포트의 Bucket Field와 Formula

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## 1. Bucket Field란?

Bucket Field는 오브젝트에 커스텀 필드를 만들지 않고 리포트 내에서 값을 그룹화할 수 있게 합니다. 데이터베이스를 수정하지 않고 데이터를 분류하는 데 도움이 됩니다.

**작동 방식:**
- 리포트 열의 값에 대해 "버킷"(카테고리)을 정의
- Salesforce가 자동으로 레코드를 해당 버킷에 할당
- 복잡한 수식이나 커스텀 필드 불필요

**사용 예:**

"Amount" 값이 있는 Opportunity 리포트에서 원시 숫자 대신 Bucket Field로 분류 — Small Deals($0~$10,000), Medium Deals($10,001~$50,000), Large Deals($50,001+).

**생성 단계:**
1. 리포트 열기
2. Add Bucket Field 클릭
3. 버킷할 열 선택(Amount, Stage, Industry 등)
4. 버킷 생성(Small, Medium, Large)
5. 각 버킷의 값 범위 정의
6. Apply & Save

**장점:**

커스텀 필드 불필요, 빠른 데이터 그룹화, Summary·Matrix 리포트에서 사용 가능, 리포트 내에서 동적·편집 가능.

## 2. 리포트의 Formula Field란?

오브젝트에 수식 필드를 추가하지 않고 리포트 내에서 계산을 수행할 수 있게 합니다.

**유형:**
- **Row-Level Formula:** 리포트의 각 행에 대해 값 계산
- **Summary Formula:** 그룹화된 데이터에 대해 계산 수행

**사용 예:**

Row-Level Formula로 Profit = Amount − Cost 계산. Summary Formula로 Win Rate(%) = (Closed Won / Total Opportunities) × 100 계산.

**Row-Level Formula 생성:**
1. 리포트 열기
2. Add Formula 클릭
3. 수식 이름 입력(예: "Profit Calculation")
4. 출력 타입 선택(Number, Currency, Percentage 등)
5. 수식 입력(예: Amount − Cost)
6. Validate로 오류 확인
7. Apply & Save

장점: 즉석 계산, 커스텀 수식 필드 불필요, Tabular·Summary·Matrix·Joined 리포트에서 사용 가능.

**Summary Formula 생성:**
1. 그룹화된(Summary/Matrix) 리포트 열기
2. Add Summary Formula 클릭
3. 수식 이름 입력
4. 출력 타입 선택
5. 수식 작성(예: `COUNT(Id) / PARENTGROUPVAL(COUNT(Id), GRAND_SUMMARY) * 100`)
6. Apply & Save

장점: 그룹화된 데이터 전반의 지표 계산, KPI 리포팅에 적합, 비율·백분율·추세에 사용.

## 모범 사례

- 빠른 그룹화에는 Bucket Field 사용(오브젝트에 새 필드 생성 대신)
- 계산에는 리포트 Formula 사용(불필요한 수식 필드로 오브젝트를 어지럽히지 않기)
- 대시보드에서 사용 전 테스트
- 수식은 단순하게 유지(복잡하면 리포트가 느려짐)
- 비율·KPI에는 Summary Formula 사용
