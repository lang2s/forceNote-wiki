---
tags: [apex, async, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Interview Questions on Batch Apex]
---

# Batch Apex Q&A 질문

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

Batch Apex는 비동기 프로세스(리소스가 가용될 때까지 대기 후 실행).

**Batch Apex 메서드?**
1. **start** — 처리할 레코드 준비, 1회 실행.
2. **execute** — start의 레코드를 배치로 나눠 여러 번 실행. (1000건이고 배치 크기 미지정 시 200건씩 5회. 기본 200, 최대 2000.)
3. **finish** — 커밋 후 로직(성공·오류 이메일 등), 1회 실행.

**Database.Stateful?** 모든 트랜잭션에 걸쳐 상태 유지(인스턴스 멤버 변수만). 카운팅·요약에 유용.

**Batch Apex 사용 이유?** 대량 작업 비동기 처리, 벌크 DML, 최대 5천만 건.

**Database.Batchable?** Batch Apex로 실행되는 인터페이스(3개 프로세스).

**Database.iterable<sObject>?** DB에서 데이터 조회, 거버넌스 한도 50,000.

**큐에 추가 가능 배치 작업?** 5개.

**Apex Scheduler?** 지정 시간에 Apex 클래스 실행.

**Mixed DML 오류?** 한 트랜잭션에서 setup·non-setup 오브젝트 작업 시.

**Job이란?** 대량 데이터를 비동기 처리하는 배치 실행. start(수집)·execute(처리)·finish(최종).

**Database.AllowsCallouts?** 배치에서 콜아웃 사용 시 클래스 정의에 지정.

**비동기 메서드 유형?** Batch, Queueable, Future.

**execute 매개변수?** 빈 리스트(scope)와 Database.BatchableContext bc.

**Batch Apex 상태?** Stateless(기본).

**200건 배치 중 1건 실패 시?** 1번째 배치 200건 전체 롤백, 다음 배치 실행.

**Batch에서 Batch 호출?** 가능(start 또는 finish에서). 단 execute/start에서 호출 시 AsyncException. 실질적으로 finish에서만 권장. 24시간당 배치 실행 250,000회.

## Queueable vs Future
| Queueable | Future |
|---|---|
| sObject 사용 | 기본 타입만 |
| 스케줄 가능 | 스케줄 불가 |
| Job 모니터링 가능 | 모니터링 불가 |
| Future·Batch에서 호출 가능 | 호출 불가 |
| 체이닝 가능 | 체이닝 불가 |

**insert vs Database.insert:** 10건 중 5건 오류 시 insert는 전체 실패, Database.insert(list, false)는 부분 성공(롤백 안 함).

**Future 특징:** 별도 스레드 실행, 사용자 비차단, 높은 거버넌스 한도, 장기 작업, Mixed DML 회피. static·void만. 50개 한도(호출~실행 사이 시간 변경 가능). 호출 순서 미보장, 동시 실행 가능.

**Apex Flex Queue:** 즉시 처리되지 않는 작업은 Holding 상태.

**Batch에서 콜아웃?** 가능, 최대 100, `Database.AllowsCallouts`.

**BatchableContext?** 배치 작업 메서드 매개변수 타입, 배치 작업 ID 포함.

**현재 실행 배치 추적?** JobId로 AsyncApexJob.Status 확인.

**AsyncApexJob?** 개별 Apex 작업을 나타내는 객체.

**Batch 스케줄?** UI 또는 System.scheduleBatch. System.schedule()은 Job ID 반환.

**Batch vs Data Loader:** Batch는 유연성·제어·비동기 처리 우수. 복잡한 작업·대량·스케줄(정리·마이그레이션)에 이상적.

```apex
global class batch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<SObject> scope) {
        // 처리
    }
    global void finish(Database.BatchableContext bc) {
        // 이메일 또는 다른 배치 호출
    }
}
```

**작업 상태 모니터링:** Setup → Apex Jobs.

**System.scheduleBatch:** 미래 시점 1회 스케줄, CronTrigger ID 반환.
```apex
String cronID = System.scheduleBatch(reassign, 'job example', 1);
CronTrigger ct = [SELECT Id, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :cronID];
```

**Scheduled Apex 콜아웃:** 동기 콜아웃 미지원. 비동기 콜아웃은 Queueable(Database.AllowsCallouts). Batch의 execute당 System.enqueueJob 1회 제한.
