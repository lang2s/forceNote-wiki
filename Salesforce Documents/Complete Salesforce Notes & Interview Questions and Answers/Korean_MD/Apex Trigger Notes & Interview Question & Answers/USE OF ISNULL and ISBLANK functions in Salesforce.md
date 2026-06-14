# Salesforce의 ISNULL과 ISBLANK 함수 사용

검증 규칙이나 수식에서 다양한 필드 타입에 ISNULL과 ISBLANK를 사용할 수 있습니다.

1. **Text 필드:** ISBLANK로 비어 있거나 공백만 있는지 확인. 예: Description이 비어 있지 않도록.
2. **Picklist 필드:** ISBLANK로 값이 선택되지 않았는지 확인. 예: Status 선택 목록이 비어 있지 않도록.
3. **Date 필드:** ISNULL로 날짜 필드가 비어 있는지 확인. 예: Due Date에 값이 있도록.
4. **Lookup 필드:** ISNULL로 비어 있는지(관련 레코드 미선택) 확인.
5. **Formula 필드:** ISNULL/ISBLANK로 다른 필드 값 기반 조건 평가.
6. **Checkbox 필드:** ISNULL/ISBLANK로 선택되지 않았는지 확인.
7. **Number 필드:** ISBLANK는 보통 사용하지 않으나(기본값 존재), ISNULL로 null 확인 가능.

**선택 기준:** 필드가 null일 수 있으면 ISNULL, 값이 있어야 하지만 비어 있을 수 있으면 ISBLANK. 복잡한 검증 규칙에서 결합 사용 가능.
