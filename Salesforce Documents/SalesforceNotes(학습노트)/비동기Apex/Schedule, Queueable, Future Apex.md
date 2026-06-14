---
tags: [apex, async, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Schedule and Queueable and Future Apex]
---

# Schedule, Queueable, Future Apex

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## Queueable Apex
Future 메서드보다 세밀한 제어로 Apex 작업을 비동기 실행.

- **정의**: 별도 트랜잭션에서 비동기 실행. @future보다 추적·체이닝 우수.
- **구현**: `Queueable` 인터페이스 구현, `public void execute(QueueableContext context)` 필수.

```apex
public class MyQueueableJob implements Queueable {
    public void execute(QueueableContext context) {
        System.debug('Queueable Apex executed');
    }
}
```

**작업 등록:**
```apex
MyQueueableJob job = new MyQueueableJob();
System.enqueueJob(job);
```

**체이닝:** Queueable 작업이 다른 Queueable 작업을 등록.
```apex
public void execute(QueueableContext context) {
    System.debug('Executing Job 1');
    System.enqueueJob(new AnotherQueueableJob());
}
```

**모니터링**: Setup → Apex Jobs.

**장점**: 복잡한 비동기 처리, 멤버 변수로 상태 보존, 작업 체이닝.
**제한**: 단일 트랜잭션당 큐에 최대 50개, Apex 실행 한도 적용.

## Scheduled vs Queueable Apex

| 기능 | Scheduled | Queueable |
|---|---|---|
| 사용 사례 | 예약 작업 | 비동기 처리 |
| 인터페이스 | Schedulable | Queueable |
| 호출 | 스케줄(cron 표현식) | 작업 등록(System.enqueueJob) |
| 체이닝 | 미지원 | 지원 |
| 실행 시점 | 예약 시간(cron) | 등록 후 ASAP |

## Future 메서드
장기 작업·콜아웃을 메인 스레드 차단 없이 비동기 실행.

- **정의**: @future 어노테이션, 백그라운드 실행.
- **구문**: static 선언, void만 반환, 매개변수는 기본 타입·배열·기본 타입 컬렉션만.

```apex
public class FutureExample {
    @future
    public static void updateAccounts(Set<Id> accountIds) {
        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Id IN :accountIds];
        for (Account acc : accounts) acc.Name = acc.Name + ' - Updated';
        update accounts;
    }
}
// 호출
FutureExample.updateAccounts(new Set<Id>{'001XX00000345ABCDE'});
```

**특징**: 현재 트랜잭션 후 별도 스레드 실행. 콜아웃·대량 처리·장기 DB 업데이트에 이상적.
**제한**: Future에서 Future 호출 불가, Batch나 트리거에서 직접 사용 불가, 트랜잭션당 최대 50개, 직접 상태 추적 불가.

## Future vs Queueable

| 기능 | Future | Queueable |
|---|---|---|
| 복잡도 | 단순·경량 | 체이닝·상태 보존 |
| 추적성 | 직접 추적 불가 | Apex Jobs에서 추적 |
| 매개변수 | 기본 타입만 | 복합 타입·SObject 지원 |
| 체이닝 | 미지원 | 지원 |
| 콜아웃 | 지원(callout=true) | 지원 |

**Future 사용 시점:** 추적이 필요 없는 경량 작업, 단순 비동기(레코드 업데이트·콜아웃).
