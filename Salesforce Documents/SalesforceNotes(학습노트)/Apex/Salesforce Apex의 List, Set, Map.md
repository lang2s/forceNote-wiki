---
tags: [apex, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [In Salesforce Apex List, Set, Map]
---

# Salesforce Apex의 List, Set, Map

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

데이터 컬렉션을 저장·조작하는 세 가지 주요 컬렉션 타입입니다.

## 1. List

순서가 있는 요소 컬렉션으로 중복 값을 허용합니다. 순서 유지와 중복 허용이 필요할 때 사용. 주요 메서드: `.add()`, `.remove()`, `.get()`, `.set()`, `.size()`, `.contains()`.
```apex
List<String> cityList = new List<String>();
cityList.add('New York'); cityList.add('Los Angeles'); cityList.add('Chicago');
```
실시간 시나리오: Account 이름 목록을 가져와 순서대로 처리.
```apex
List<Account> accounts = [SELECT Id, Name FROM Account LIMIT 5];
for (Account acc : accounts) { System.debug('Account Name: ' + acc.Name); }
```

## 2. Set

순서 없는 고유 요소 컬렉션. 중복 불가. 고유성을 보장하고 순서가 중요하지 않을 때 사용. 주요 메서드: `.add()`, `.remove()`, `.contains()`, `.size()`.
```apex
Set<String> emailSet = new Set<String>();
emailSet.add('user1@example.com'); emailSet.add('user2@example.com');
emailSet.add('user1@example.com'); // 중복, 무시됨
```
실시간 시나리오: 알림 전송 전 중복 이메일 방지.

## 3. Map

키-값 쌍 컬렉션, 각 키는 고유. 한 값을 다른 값과 연결할 때(예: Id→레코드) 사용. 주요 메서드: `.put()`, `.get()`, `.keySet()`, `.values()`, `.containsKey()`.
```apex
Map<Id, String> accountMap = new Map<Id, String>();
for (Account acc : [SELECT Id, Name FROM Account]) { accountMap.put(acc.Id, acc.Name); }
```
실시간 시나리오: Account 데이터를 Id로 매핑해 빠른 조회.
```apex
Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, Name FROM Account]);
if (accountMap.containsKey(accId)) { System.debug(accountMap.get(accId).Name); }
```

## 비교

| 타입 | 중복 허용 | 순서 | 키-값 | 사용 |
|---|---|---|---|---|
| List | 예 | 예 | 아니오 | 레코드·순서 데이터 처리 |
| Set | 아니오 | 아니오 | 아니오 | 고유 값(이메일 등) |
| Map | 해당없음 | 해당없음 | 예 | Id→데이터 조회 |

## 실시간 종합 예시

Account와 관련 Contact를 가져와 고유 Contact를 보장하고 조회용으로 매핑:
```apex
List<Account> accounts = [SELECT Id, Name, (SELECT Id, Email FROM Contacts) FROM Account];
Set<String> uniqueEmails = new Set<String>();
Map<Id, List<Contact>> accountContactsMap = new Map<Id, List<Contact>>();
for (Account acc : accounts) {
    List<Contact> contactList = new List<Contact>();
    for (Contact con : acc.Contacts) {
        if (!uniqueEmails.contains(con.Email)) {
            uniqueEmails.add(con.Email);
            contactList.add(con);
        }
    }
    accountContactsMap.put(acc.Id, contactList);
}
```
→ List(순서 있는 Contact 보관), Set(이메일 고유성 보장), Map(Account와 고유 Contact 연결).
