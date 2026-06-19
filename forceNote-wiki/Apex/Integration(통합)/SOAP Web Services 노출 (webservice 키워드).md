---
tags: [apex, soap, web-service, webservice-keyword, integration, wsdl, ajax-toolkit, 외부연동]
source: salesforce_apex_developer_guide.pdf (Summer '26, v67.0) — Invoking Apex / Exposing Apex Methods as SOAP Web Services + Apex in AJAX
created: 2026-06-19
aliases: [webservice 키워드, SOAP Web Service, Apex SOAP, "Apex를 SOAP로 노출", Apex 웹서비스 노출, "@WebService", WebService 키워드, Generate WSDL, Web Service Method, webservice static, AJAX toolkit Apex, sforce.apex.execute, Overloading Web Service]
---

# SOAP Web Services 노출 (webservice 키워드)

> `webservice` 키워드로 Apex 메서드를 custom SOAP 웹서비스로 노출하면 외부 앱이 그 코드·앱에 접근할 수 있다. WSDL을 생성해 외부 클라이언트가 호출하며, AJAX Toolkit에서도 같은 메서드를 호출할 수 있다.

---

## 개요

Apex 메서드를 SOAP 웹서비스로 노출하면 외부 앱이 코드·앱에 접근할 수 있다. 이때 Webservice Methods를 사용한다. SOAP는 Apex를 호출하는 여러 표면 중 하나이며, 세 가지 외부 연동 방식과 구분해야 한다.

> [!tip]
> - **Apex SOAP web services** — 외부 앱이 SOAP로 Apex 메서드를 호출한다(이 노트의 주제).
> - **Apex callouts** — Apex가 외부 web/HTTP 서비스를 호출한다([[RestClient 패턴]] 참조).
> - **Apex REST API** — Apex 클래스·메서드를 REST로 노출한다([[Custom REST Endpoint]] 참조).

이 노트는 공식 가이드의 다음 4개 서브섹션과 AJAX Toolkit 호출을 다룬다.

1. Webservice Methods
2. Exposing Data with Webservice Methods
3. Considerations for Using the webservice Keyword
4. Overloading Web Service Methods
5. Apex in AJAX (AJAX Toolkit으로 호출)

---

## 1. Webservice 메서드 정의

Apex 클래스 메서드를 custom SOAP Web service 호출로 노출하면 외부 앱이 Salesforce에서 액션을 수행할 수 있다. `webservice` 키워드로 정의한다.

```apex
global class MyWebService {
    webservice static Id makeContact(String contactLastName, Account a) {
        Contact c = new Contact(lastName = contactLastName, AccountId = a.Id);
        insert c;
        return c.id;
    }
}
```

### WSDL 생성 (3단계)

1. Setup → Apex Classes
2. webservice 메서드를 포함하는 클래스 이름 클릭
3. **Generate WSDL**

외부 클라이언트는 생성된 WSDL을 사용해 이 메서드를 호출한다.

---

## 2. 데이터 노출 시 system context 주의

custom webservice 메서드 호출은 **항상 system context를 사용한다.** 즉 현재 사용자의 credential을 사용하지 않으며, 접근 가능한 누구나 권한·field-level security·sharing rule과 무관하게 full power로 동작한다. 민감 데이터 노출에 주의해야 한다.

> [!warning]
> `webservice` 키워드로 API에 노출된 Apex 메서드는 기본적으로 object 권한·field-level security를 강제하지 않는다. `DescribeSObjectResult`·`DescribeFieldResult`로 접근 레벨을 체크할 것을 권장한다. sharing rule(record-level access)은 클래스를 `with sharing` 키워드로 선언했을 때에만 강제된다 — webservice 메서드에 sharing을 강제하려면 그 클래스를 `with sharing`으로 선언한다.

접근 레벨·권한 강제 패턴은 [[StripInaccessible]]·[[CanTheUser]]·[[WITH USER_MODE]] 참조.

---

## 3. webservice 키워드 고려사항 (전수)

- `webservice` 키워드로 top-level 메서드·outer class 메서드를 정의한다. 클래스나 inner class의 메서드 정의에는 사용할 수 없다.
- 인터페이스·인터페이스 메서드·변수 정의에 사용할 수 없다.
- System-defined enum은 Web service 메서드에 사용할 수 없다.
- 트리거에서 사용할 수 없다.
- `webservice` 메서드를 포함하는 모든 클래스는 `global`로 선언해야 한다(메서드·inner class가 global이면 outer top-level 클래스도 global이어야 한다).
- `webservice` 메서드는 본질적으로 global이다. 클래스에 접근 가능한 모든 Apex 코드가 사용할 수 있다. `webservice` 키워드는 global보다 더 많은 접근을 허용하는 access modifier의 일종으로 간주할 수 있다.
- `webservice`를 사용하는 메서드는 `static`으로 정의한다.
- 관리 패키지 코드에서는 webservice 메서드·변수를 deprecate할 수 없다.
- Web service의 일부로 노출할 member 변수에 `webservice` 키워드를 사용한다(이 member 변수를 static으로 marking하면 안 된다).

### SOAP 아날로그가 없는 Apex 요소 (5종)

다음 요소는 SOAP에 대응하는 표현이 없어 **파라미터로 받을 수 없다**(메서드 내부에서는 사용할 수 있으나 return value로 marking할 수도 없다).

1. **Maps**
2. **Sets**
3. **Pattern objects**
4. **Matcher objects**
5. **Exception objects**

### 호출 시 고려사항

- Restricted 접근의 AppExchange 패키지에서 온 Web service·executeAnonymous 요청은 거부된다.
- API v15.0 이상에서 컴파일된 클래스·트리거는 필드에 너무 긴 String을 할당하면 런타임 에러가 난다.
- expired/temporary password를 가진 사용자가 login을 호출한 직후 custom Apex SOAP Web service 메서드를 호출하면 `INVALID_OPERATION_WITH_EXPIRED_PASSWORD` 에러가 발생한다(비밀번호를 reset해야 한다).

### SpecialAccounts 예제

```apex
global class SpecialAccounts {

    global class AccountInfo {
       webservice String AcctName;
       webservice Integer AcctNumber;
    }

    webservice static Account createAccount(AccountInfo info) {
      Account acct = new Account();
      acct.Name = info.AcctName;
      acct.AccountNumber = String.valueOf(info.AcctNumber);
      insert acct;
      return acct;
    }

    webservice static Id [] createAccounts(Account parent,
         Account child, Account grandChild) {

            insert parent;
            child.parentId = parent.Id;
            insert child;
            grandChild.parentId = child.Id;
            insert grandChild;

            Id [] results = new Id[3];
            results[0] = parent.Id;
            results[1] = child.Id;
            results[2] = grandChild.Id;
            return results;
      }
}

// Test class for the previous class.
@isTest
private class SpecialAccountsTest {
  testMethod static void testAccountCreate() {
    SpecialAccounts.AccountInfo info = new SpecialAccounts.AccountInfo();
    info.AcctName = 'Manoj Cheenath';
    info.AcctNumber = 12345;
    Account acct = SpecialAccounts.createAccount(info);
    System.assert(acct != null);
  }
}
```

---

## 4. 오버로딩 불가 (Overloading Web Service Methods)

SOAP·WSDL은 overloading 지원이 좋지 않다. 따라서 Apex는 `webservice` 키워드로 marking된 두 메서드가 같은 이름을 가지는 것을 허용하지 않는다. 같은 클래스 내에 동명의 Web service 메서드가 있으면 컴파일 타임 에러가 발생한다.

---

## 5. AJAX Toolkit으로 호출 (Apex in AJAX)

AJAX Toolkit은 anonymous block 또는 public webservice 메서드를 통해 Apex 호출을 지원한다.

```html
<script src="/soap/ajax/67.0/connection.js" type="text/javascript"></script>
<script src="/soap/ajax/67.0/apex.js" type="text/javascript"></script>
```

> [!note]
> AJAX 버튼은 이 include의 alternate form을 사용한다.

두 가지 방법이 있다.

### (1) 익명 실행 — sforce.apex.executeAnonymous

`sforce.apex.executeAnonymous(script)`를 사용한다. API result 타입과 유사하나 JavaScript 구조로 반환된다.

> anonymous block 자체의 제약·권한·반환 결과 상세는 [[Anonymous Apex 실행]] 참조.

### (2) class WSDL 사용 — sforce.apex.execute

```apex
global class myClass {
  webservice static Id makeContact(String lastName, Account a) {
        Contact c = new Contact(LastName = lastName, AccountId = a.Id);
        return c.id;
    }
}
```

```javascript
var account = sforce.sObject("Account");
var id = sforce.apex.execute("myClass","makeContact",
                             {lastName:"Smith",
                              a:account});
```

`execute` 메서드는 primitive 데이터 타입·sObject·primitive/sObject의 list를 받는다. 파라미터가 없는 webservice 메서드를 호출할 때는 세 번째 파라미터로 `{}`를 사용한다.

```apex
global class myClass{
   webservice static String getContextUserName() {
        return UserInfo.getFirstName();
   }
}
```

```javascript
var contextUser = sforce.apex.execute("myClass", "getContextUserName", {});
```

---

## 관련 노트

- [[Custom REST Endpoint]]
- [[RestClient 패턴]]
- [[Anonymous Apex 실행]]
- [[StripInaccessible]]
- [[CanTheUser]]
- [[WITH USER_MODE]]
- [[Integration(통합)/index]]
- [[Apex MOC]]
