---
tags: [soql, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [SOQL Governor limits]
---

# SOQL 거버너 한도

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

**1. SOQL 쿼리 수:**

트랜잭션당 100개(Apex·배치). 트리거·클래스·VF 포함.
```apex
// 한도 초과 예 (루프 안 쿼리)
for (Integer i = 0; i < 200; i++) {
    List<Account> accounts = [SELECT Id FROM Account WHERE Name = 'A'];
}
```

**2. SOQL 조회 레코드 총수:**

트랜잭션당 50,000건. 표준·커스텀 포함.

**3. 단일 쿼리 반환:**

1,000건. 초과 시 페이지네이션·배치.

**4. 리포트·대시보드 행:**

리포트 2,000행.

**5. 관계 쿼리:**

트랜잭션당 50개(parent-to-child·child-to-parent).

**6. 대형 텍스트 필드:**

Encrypted Text·Long Text Area·Rich Text Area는 SOQL 쿼리 제외.

**7. 수식 필드:**

WHERE·aggregate에서 직접 쿼리 불가(동적 계산).

**8. 루프 안 SOQL:**

회피.
```apex
// 나쁨
for (Account acc : [SELECT Id FROM Account]) {
    List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId = :acc.Id];
}
// 올바름
List<Account> accounts = [SELECT Id FROM Account];
Set<Id> accountIds = new Set<Id>();
for (Account acc : accounts) accountIds.add(acc.Id);
List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId IN :accountIds];
```

**9. Bulk API/Data Load:**

핵심 SOQL 한도 적용(50,000건/트랜잭션).

## 모범 사례
선택적 쿼리(WHERE), 페이지네이션(LIMIT·OFFSET), 효율적 설계(필요 필드만), 루프 안 SOQL 금지, 대량은 Batch Apex.

## 핵심 한도
- SOQL 쿼리/트랜잭션: 100
- 쿼리당 반환: 1,000
- 트랜잭션당 총 레코드: 50,000
- 관계 쿼리/트랜잭션: 50
