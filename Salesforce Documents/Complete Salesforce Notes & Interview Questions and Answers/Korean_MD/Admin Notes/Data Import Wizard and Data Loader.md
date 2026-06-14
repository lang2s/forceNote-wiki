---
tags: [admin, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Data Import Wizard and Data Loader]
---

# Data Import Wizard와 Data Loader의 차이

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## Data Import Wizard

- Salesforce 내장 도구
- Insert, Update, Upsert 작업 수행 가능
- 최대 50,000개 레코드 처리
- 작업 후 로그 파일 제공
- 5개 표준 오브젝트와 모든 커스텀 오브젝트 지원
- 매핑 저장 불가

## Data Loader

- Salesforce 서드파티 도구
- Insert, Update, Upsert, Delete, Export, Export All 작업 수행 가능
- 최대 500만 개 레코드 처리
- 작업 후 오류 파일과 성공 파일 제공
- 모든 표준 오브젝트와 모든 커스텀 오브젝트 지원
- 매핑 저장 가능
