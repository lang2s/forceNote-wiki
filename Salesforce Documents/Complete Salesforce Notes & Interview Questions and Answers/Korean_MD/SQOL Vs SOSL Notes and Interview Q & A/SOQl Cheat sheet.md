# SOQL 예외 치트시트

**1. QueryException**
- **No rows for assignment:** 쿼리 결과가 없는데 List 대신 sObject에 할당 시. → List로 처리.
- **Non-selective query:** 필터링 부족으로 너무 많은 레코드(20만 초과). → 인덱스 필드·구체적 필터.

**2. LimitException**
- **Too Many SOQL Queries (101):** 트랜잭션당 100개 한도 초과. → 벌크화(루프 밖 쿼리·Map·컬렉션).

**3. SObjectException**
- **Field not queried:** SELECT하지 않은 필드 접근. → 필요한 필드 SELECT.

**4. ListException**
- **List has no rows:** 빈 List 요소 접근. → list.size()·isEmpty() 확인.

**5. Too Many Query Rows**
- **50,000+ 반환:** 최대 행 한도 초과. → 페이지네이션(LIMIT·OFFSET)·배치 처리.

**6. InvalidFieldException**
- **잘못된 필드명:** 존재하지 않거나 오타. → 필드명 확인.
