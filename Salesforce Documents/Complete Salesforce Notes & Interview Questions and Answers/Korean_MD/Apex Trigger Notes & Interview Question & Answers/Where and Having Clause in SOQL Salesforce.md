# SOQL의 WHERE와 HAVING 절

## WHERE 절

- **목적:** 그룹화·집계 전에 레코드 필터링.
- **사용:** 개별 레코드의 필드 기반.
```sql
SELECT Id, Name FROM Account WHERE Industry = 'Technology'
```

## HAVING 절

- **목적:** 그룹화(GROUP BY) 후 레코드 필터링.
- **사용:** 집계된 데이터에 적용.
```sql
SELECT Industry, COUNT(Id) FROM Account GROUP BY Industry HAVING COUNT(Id) > 10
```
(Account가 10개 초과인 산업 조회.)

## 주요 차이

1. **실행 순서:** WHERE는 집계 전, HAVING은 집계 후 필터링.
2. **적용:** WHERE는 모든 필드에, HAVING은 집계 함수(COUNT, SUM 등)에.
3. **그룹화:** WHERE는 집계 함수 포함 불가, HAVING은 집계 결과 조건 전용.
