# Batch Apex와 AsyncApexJob로 대량 데이터 처리

> 원본은 이미지 PDF로 OCR 추출했습니다.

## Batchable Apex란?
대량 데이터를 관리 가능한 배치로 나눠 병렬·비동기 처리할 수 있게 하는 인터페이스. `Database.Batchable`을 구현.

## Database.BatchableContext 인터페이스
배치 작업 메서드(start, execute, finish)에서 사용하는 매개변수 타입. 배치 작업 ID 같은 정보 보유. Salesforce가 내부 관리하므로 직접 구현 불필요.

## AsyncApexJob 객체
Batch·Queueable·Future·Scheduled 같은 비동기 Apex 작업의 상세 정보 제공. 작업 진행·실패 추적, 성능 최적화에 사용.
- 작업 상태 모니터링(Queued, Processing, Completed, Failed 등)
- 필요 시 실행 중 작업 중단(abort)
- 알림용 작업 상세 조회

### 주요 필드
| 필드 | 설명 |
|---|---|
| Id | 비동기 작업 고유 식별자 |
| ApexClassId | 연관 Apex 클래스 ID |
| CompletedDate | 작업 완료 일시 |
| CronTriggerId | 연관 CronTrigger ID(스케줄 작업) |
| ExtendedStatus | Status보다 상세한 상태 정보 |
| JobItemsProcessed | 처리된 배치 수 |
| JobType | 유형(Batch, Future, Queueable 등) |
| MethodName | 실행 메서드명 |
| NumberOfErrors | 처리 중 오류 수 |
| ParentJobId | 부모 작업 ID |
| Status | 현재 상태 |
| TotalJobItems | 총 배치 수 |

## 예제: 모든 Account의 BillingCity 변경
```apex
global class UpdateBillingCityBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, BillingCity FROM Account');
    }
    global void execute(Database.BatchableContext bc, List<Account> obj) {
        List<Account> acclist = new List<Account>();
        for (Account acc : obj) {
            acc.BillingCity = 'New City';
            acclist.add(acc);
        }
        upsert acclist;
    }
    global void finish(Database.BatchableContext bc) {
        AsyncApexJob job = [SELECT Id, ApexClassId, CompletedDate, CronTriggerId,
            ExtendedStatus, JobItemsProcessed, JobType, MethodName, NumberOfErrors,
            ParentJobId, Status, TotalJobItems
            FROM AsyncApexJob WHERE Id = :bc.getJobId()];
        // job 정보로 모니터링·알림
    }
}
```

## AsyncApexJob의 중요성
- **사전 모니터링**: 실행 작업 추적, 병목 방지.
- **디버깅**: 오류 상세로 실패 빠르게 식별.
- **최적화**: 리소스 사용 추적, 작업 성능 개선.

## 요약
Batch Apex는 대량 데이터를 원활히 처리하고, AsyncApexJob은 비동기 작업을 추적한다. 함께 사용하면 Salesforce 프로세스를 관리·모니터링·최적화하는 강력한 방법이 된다.
