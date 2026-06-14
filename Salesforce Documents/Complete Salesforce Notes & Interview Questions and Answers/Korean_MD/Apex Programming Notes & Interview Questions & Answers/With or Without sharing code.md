# With & Without Sharing (코드)

클래스를 `with sharing` 키워드로 선언하면 현재 사용자의 레코드 수준 공유 규칙을 강제합니다.
```apex
public with sharing class sharingClass {
    public List<Account> getAccounts() {
        return [SELECT Id, Name FROM Account];
    }
}
```

클래스를 `without sharing` 키워드로 선언하면 현재 사용자의 공유 규칙을 강제하지 않습니다.
```apex
public without sharing class noSharing {
    public List<Account> getAllAccounts() {
        return [SELECT Id, Name FROM Account];
    }
}
```
