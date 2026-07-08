---
tags: [apex, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [With or Without sharing code]
---

# With & Without Sharing (코드)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

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
