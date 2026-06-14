---
tags: [apex, async, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Asynchronous - Apex Imp Notes]
---

# 비동기 Apex 핵심 노트

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

- 별도 스레드에서 나중에 프로세스를 실행.
- 사용자가 완료를 기다리지 않고 백그라운드에서 작업 실행.
- 외부 시스템 콜아웃, 더 높은 한도가 필요한 작업, 특정 시간 실행 코드에 사용.

**장점:** 확장성(병렬 처리), 사용자 효율(백그라운드 처리), 더 높은 한도(새 스레드, 높은 거버너·실행 한도).

## Future 메서드
@future 어노테이션으로 비동기 실행 메서드 식별.
```apex
public class testFuture {
    @future
    public static void executeInFuture(List<Id> recordIds) {
        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Id IN :recordIds];
        // 레코드 처리
    }
}
```
항상 static, void 반환.

**장점·용도:**
- **외부 웹서비스 콜아웃**: 트리거에서 콜아웃을 @future로 캡슐화. `@future(callout=true)` 전달.
- **Mixed DML 오류 회피**: 같은 트랜잭션에서 Setup·non-Setup 오브젝트 변경 시 오류 → 한 메서드를 @future로.
- **더 높은 거버너 한도**: SOQL·힙 크기 한도 상향.

**단점:** sObject·비기본 타입 인수 불가(Id, List<Id> 등 기본 타입만), Job Id 미반환(모니터링·디버깅 어려움), 대량 데이터 부적합.

**중요:** Future에서 Future 호출 불가, Future에서 Queueable 1개만 호출 가능, Future에서 작업 스케줄 가능, Future에서 Batch 호출 불가, Apex 호출당 50개 이하, static·void.

## Queueable Apex
Batch의 강점과 Future의 단순함 결합. `Queueable` 인터페이스 구현(public/global), `execute(QueueableContext)` 본문 제공. `System.enqueueJob`으로 실행.

**장점:** AsyncApexJob Id 반환, 모니터링·중단 가능, 비기본 타입 전달 가능, 작업 체이닝 가능.
**중요:** Queueable에서 다수 Future 호출 가능, Queueable에서 Batch 호출 가능, 콜아웃 시 `Database.AllowsCallouts` 구현.

## Schedulable Apex
`Schedulable` 인터페이스 구현 global 클래스, execute 메서드 포함.

**Cron 표현식:** 6개 문장(초 분 시 일 월 요일). 예: `0 0 12 * * ?` = 매일 12:00 PM. `*`는 every.
**중요:** Scheduled 작업에서 JobId 획득, CronTrigger 쿼리로 모니터링, `System.abortJob(jobId)`로 중단, UI에서 삭제(Setup → Scheduled Jobs), `System.scheduleBatch()`로 Batch 스케줄, Schedulable에서 콜아웃 불가.

## Batch Apex
`Database.Batchable` 인터페이스 구현 global 클래스. 단일 작업을 관리 가능한 청크로 분할 처리.

**필요성:** 더 높은 거버너 한도가 필요한 대량 데이터셋(정리·아카이빙). 각 트랜잭션이 새 거버너 한도로 시작.

- **start()**: 처리할 레코드/객체 수집(1회 호출).
- **execute()**: 범위 레코드 하위 집합 처리(여러 번 호출).
- **finish()**: 모든 배치 후 후처리(확인 이메일 등, 1회 호출).

**실행:** `Database.executeBatch(obj, size)` 또는 스케줄러.
**중요:** QueryLocator 최대 5천만 건, size 미지정 시 200건씩, execute마다 거버너 한도 리셋, 24시간당 배치 실행 최대 250,000회, Database.Stateful로 배치 청크 간 상태 유지.
