# Wrapper Class 이해 및 "Inner Types Are Not Allowed to Have Inner Types" 오류 해결

## Wrapper Class란?

여러 오브젝트나 데이터 구조를 하나의 단위로 묶는 커스텀 클래스입니다. 서버 측 Apex와 클라이언트 측 컴포넌트(Aura, LWC) 간에 복잡한 데이터를 전달할 때 유용합니다.

**사용 이유:** 여러 데이터 타입을 한 오브젝트로 처리, 복잡한 로직 단순화, UI 컴포넌트에 커스텀 데이터 바인딩.

기본 예시:
```apex
public class WrapperClassExample {
    public String name;
    public Boolean isSelected;
    public WrapperClassExample(String name, Boolean isSelected) {
        this.name = name;
        this.isSelected = isSelected;
    }
}
```
사용:
```apex
List<WrapperClassExample> wrapperList = new List<WrapperClassExample>();
wrapperList.add(new WrapperClassExample('John Doe', true));
```

## "Inner Types Are Not Allowed to Have Inner Types" 오류

다른 클래스 안에 정의된 내부 클래스(inner type)가 또 자체 내부 클래스를 포함할 때 발생합니다. Apex는 이 구조를 허용하지 않습니다.

오류를 유발하는 예:
```apex
public class OuterClass {
    public class InnerClass {        // 유효
        public class NestedInnerClass { } // 오류 발생
    }
}
```

## 해결 방법

중첩 내부 클래스를 top-level로 옮깁니다. 각 내부 클래스를 별도로 정의하고, 부모 내부 클래스에서 인스턴스를 생성합니다.
```apex
public class OuterClass {
    public class InnerClass {
        List<NestedInnerClass> nInnerC;
        public InnerClass(){ nInnerC = new List<NestedInnerClass>(); }
    }
    public class NestedInnerClass { }
}
```

**장점:** 모듈식 설계(재사용 가능), 오류 없음, 단순한 구조.

## 중첩 내부 타입 없는 실용 예시

```apex
public class OuterClass {
    public class AccountWrapper {
        @AuraEnabled public Account accountRecord;
        @AuraEnabled public List<ContactWrapper> relatedContacts;
        public AccountWrapper(Account account) {
            this.accountRecord = account;
            this.relatedContacts = new List<ContactWrapper>();
        }
    }
    public class ContactWrapper {
        @AuraEnabled public Contact contactRecord;
        @AuraEnabled public Boolean isPrimaryContact;
        public ContactWrapper(Contact contact, Boolean isPrimaryContact) {
            this.contactRecord = contact;
            this.isPrimaryContact = isPrimaryContact;
        }
    }
}
```

복잡한 데이터 저장에 적용:
```apex
public class AccountDataService {
    @AuraEnabled
    public static String fetchAccountsWithContacts() {
        List<AccountWrapper> accountWrappers = new List<AccountWrapper>();
        List<Account> accounts = [SELECT Id, Name, Industry,
            (SELECT Id, Name, Email, Title FROM Contacts) FROM Account LIMIT 5];
        for (Account acc : accounts) {
            AccountWrapper accountWrapper = new AccountWrapper(acc);
            for (Contact con : acc.Contacts) {
                Boolean isPrimary = con.Title == 'Manager';
                accountWrapper.relatedContacts.add(new ContactWrapper(con, isPrimary));
            }
            accountWrappers.add(accountWrapper);
        }
        return JSON.serialize(accountWrappers);
    }
}
```
