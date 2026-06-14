---
tags: [apex, async, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Batch Apex Notes]
---

# Batch Apex 노트

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## 개요
Batch 클래스는 `Database.Batchable<SObject>` 표준 인터페이스를 구현해 대량 데이터를 처리. 세 메서드를 정의·구현해야 함: `start()`, `execute()`, `finish()`.

**BatchableContext**는 세 메서드 모두에서 사용되며 현재 작업 ID를 제공해 배치 작업 실행을 추적·관리.

## 1. Start 메서드
배치 프로세스의 진입점. 처리할 레코드 범위를 정의. 두 가지 반환 타입:
- **Database.QueryLocator**: 기존 레코드 쿼리 시.
- **Iterable<SObject>**: 레코드 목록 작업(주로 삽입) 시.

```apex
global Database.QueryLocator start(Database.BatchableContext bc) {
    return Database.getQueryLocator('SELECT Id FROM Account');
}
```

Iterable로 새 레코드 삽입:
```apex
global Iterable<Account> start(Database.BatchableContext bc) {
    List<Account> accountList = new List<Account>();
    for (Integer i = 0; i < 12000; i++) {
        accountList.add(new Account(Name = 'TestAccount' + i));
    }
    return accountList;
}
```

> `Database.getQueryLocator()`는 레코드를 즉시 가져오지 않고 QueryLocator 객체를 생성. QueryLocator는 테스트·디버깅용 `getQuery()`, `size()` 메서드 제공.

## 2. Execute 메서드
배치 크기(기본 200)에 따라 레코드를 청크로 처리. 각 청크는 `List<SObject>` scope로 전달.
```apex
global void execute(Database.BatchableContext bc, List<Account> scope) {
    for (Account acc : scope) {
        acc.Name = 'UpdatedAccount';
    }
    update scope;
}
```
핵심 단계: 페이지네이션(자동 청크 분할) → 처리(업데이트·삭제) → DML(변경 저장).

## 3. Finish 메서드
모든 배치 처리 후 호출. 로깅·알림·정리에 사용.
```apex
global void finish(Database.BatchableContext bc) {
    System.debug('Batch processing completed successfully!');
}
```

완료 이메일 전송:
```apex
global void finish(Database.BatchableContext bc) {
    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
    email.setSubject('Batch Job Status');
    email.setToAddresses(new String[] {'admin@example.com'});
    email.setPlainTextBody('The batch job has completed successfully.');
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
}
```

## 실행 (익명 창)
```apex
BatchClass batchJob = new BatchClass();
Database.executeBatch(batchJob, 2000);  // 배치 크기 2000
```
