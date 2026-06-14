# Mixed DML Error(혼합 DML 오류)

Non-setup 오브젝트, setup 오브젝트, Mixed DML 예외와 회피 방법을 다룹니다.

Non-setup 오브젝트는 데이터를 저장하는 표준·커스텀 오브젝트를, setup 오브젝트는 플랫폼 구성·커스터마이징에 사용되는 메타데이터 오브젝트를 의미합니다.

- **Non-Setup 오브젝트:** Account, Contact, Opportunity, Case, Lead, 커스텀 오브젝트.
- **Setup 오브젝트(메타데이터):** Profile, PermissionSet, ApexClass, CustomMetadata, WorkflowRule, ValidationRule, RecordType, User.

## Mixed DML 오류는 언제 발생하나요?

단일 트랜잭션에서 setup 오브젝트와 non-setup 오브젝트에 DML을 수행할 때 발생합니다.

```apex
public class MixedDmlExample {
    public static void createMixedDmlError() {
        Account acc = new Account(Name='Test Account');
        insert acc; // non-setup 오브젝트
        Profile prof = [SELECT Id FROM Profile LIMIT 1];
        User user = new User(Alias='test', Email='test@example.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId=prof.Id, TimeZoneSidKey='America/New_York',
            UserName='test@example.com');
        insert user; // setup 오브젝트 → Mixed DML 예외 발생
    }
}
```

## 해결 방법

future 메서드를 사용해 setup·non-setup 오브젝트의 DML을 별도 트랜잭션에서 실행하면 Mixed DML 예외를 방지할 수 있습니다.

```apex
public class MixedDmlHandler {
    @future
    public static void processNonSetupObject(String accName) {
        insert new Account(Name = accName);
    }
    @future
    public static void processSetupObject(String userName, String profId) {
        Profile prof = [SELECT Id FROM Profile WHERE Id = :profId LIMIT 1];
        User user = new User(Alias='test', Email='test@example.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId=prof.Id, TimeZoneSidKey='America/New_York',
            UserName=userName);
        insert user;
    }
}
```

future 메서드를 각각 호출하면 setup·non-setup DML이 별도 트랜잭션에서 실행되어 Mixed DML 예외가 방지됩니다.
