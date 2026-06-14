# Data Import Wizard와 Data Loader의 차이

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
