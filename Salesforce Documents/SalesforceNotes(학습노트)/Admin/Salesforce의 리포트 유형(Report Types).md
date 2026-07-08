---
tags: [admin, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Report Types in Salesforce]
---

# Salesforce의 리포트 유형(Report Types)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

Salesforce는 데이터 분석을 돕는 4가지 리포트 유형을 제공합니다:
1. **Tabular Report** — 단순 레코드 목록(스프레드시트 같음)
2. **Summary Report** — 소계가 있는 그룹화 데이터
3. **Matrix Report** — 행과 열로 그룹화(크로스탭 형식)
4. **Joined Report** — 여러 리포트 유형을 하나로 결합

## 1. Tabular Report

가장 단순한 형식으로 데이터를 기본 목록(Excel 유사)으로 표시합니다. 그룹화나 소계 불가.

**사용 시점:**

레코드의 빠른 목록 필요, 외부 분석용 데이터 내보내기, 그룹화 없는 단순 리포트.
**제한:**

차트 생성 불가, 대시보드 사용 불가.
**예:**

모든 열린 Opportunity 목록, 활성 Lead 표, 사용자에게 할당된 Case 목록.

## 2. Summary Report

특정 필드로 데이터를 그룹화하여 소계와 총계를 제공합니다. 차트도 지원.

**사용 시점:**

Stage·Owner·Type 등으로 데이터 그룹화, 소계·계산 필요, 차트·대시보드 생성.
**제한:**

Matrix처럼 그룹화 데이터를 열로 표시 불가.
**예:**

Stage별로 그룹화된 Opportunity와 총 매출, Status별 Case 개수, Source별 Lead.

## 3. Matrix Report

Summary와 유사하지만 행과 열 모두로 그룹화할 수 있습니다. 크로스탭 리포트에 유용.

**사용 시점:**

두 차원에 걸친 데이터 분석, 성과 지표 비교(예: 지역별·제품별 매출), 차트·대시보드 생성.
**제한:**

Summary보다 복잡, 데이터가 많으면 읽기 어려움.
**예:**

Owner(행)·Stage(열)별 Opportunity, Priority(행)·Status(열)별 Case, Region(행)·Product(열)별 매출.

## 4. Joined Report

여러 리포트 유형을 단일 리포트로 결합하여 서로 다른 데이터셋을 비교할 수 있게 합니다.

**사용 시점:**

여러 관련 오브젝트의 데이터 필요, 한 뷰에서 다른 리포트 비교, Opportunity vs Case 또는 Lead vs Account 분석.
**제한:**

일부 대시보드에서 사용 불가, 오브젝트 간 관계가 제한적.
**예:**

Opportunity와 Case를 한 리포트에, Lead와 전환된 Opportunity 비교, 제품별 영업팀 성과.

## 모범 사례

- 대시보드에는 Summary Report 사용(그룹화·계산 가능)
- 크로스탭 데이터에는 Matrix Report 사용(추세 비교에 유용)
- Tabular Report는 단순하게(원시 데이터 내보내기에 적합)
- 필터·그룹화를 현명하게(그룹이 너무 많으면 읽기 어려움)
- 공유 전 샌드박스에서 테스트
