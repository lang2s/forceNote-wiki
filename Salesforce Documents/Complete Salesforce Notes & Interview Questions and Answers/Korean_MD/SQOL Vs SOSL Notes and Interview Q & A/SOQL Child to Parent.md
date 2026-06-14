# SOQL Child to Parent

자식 오브젝트 쿼리 시 부모 필드에 접근하는 child-to-parent 관계 쿼리.

1. 단일 SOQL로 자식·부모 레코드 조회.
2. 점(.) 표기로 부모 레코드 접근.
3. 최대 55개 child-to-parent 관계 지정 가능.
4. 자식 오브젝트의 관계 필드명으로 표준 오브젝트 접근.
5. 최대 5단계 탐색(child→parent). 예: Contact → Account → User.

> 자식이 커스텀·부모가 표준이면 부모 오브젝트 뒤에 `__r` 추가(예: `Account__r`).

## Child(표준) → Parent(표준)
```sql
SELECT LastName, Account.Name FROM Contact
SELECT LastName, Account.OwnerId FROM Contact
-- Level 2
SELECT LastName, Account.Owner.Name FROM Contact
SELECT LastName, Account.Owner.Email FROM Contact
```

## Custom(자식) → Standard(부모)
```sql
SELECT Name, City__c, Account__r.Name FROM Department__c
SELECT Name, City__c, Account__r.Name, Account__r.Owner.Name FROM Department__c
```
> 커스텀 자식→표준 부모는 관계 필드 API 이름에 `__r` 추가. 관계 필드 사용 시 이름이 아닌 해당 Id의 레코드 저장.

## Custom(자식) → Custom(부모)
```sql
SELECT Name, Department__r.Name FROM Employee__c
SELECT Id, Name, Customer__r.Name, Customer__r.Email__c FROM Order__c WHERE Customer__r.City__c = 'San Francisco'
```
