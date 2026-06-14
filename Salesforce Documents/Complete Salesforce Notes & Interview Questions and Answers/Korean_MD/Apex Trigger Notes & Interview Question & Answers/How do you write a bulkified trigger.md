# 벌크화된(Bulkified) 트리거 작성 방법

- DML로 루프를 도는 대신 컬렉션(List, Map, Set) 사용.
- SOQL 쿼리는 루프 밖에서 사용.
- 유지보수성을 위해 Trigger Handler Framework 사용.
