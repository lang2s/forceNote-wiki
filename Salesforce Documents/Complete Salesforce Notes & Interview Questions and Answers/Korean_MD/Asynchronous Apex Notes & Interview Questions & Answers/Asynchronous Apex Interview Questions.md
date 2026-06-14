# 비동기 Apex 면접 질문

**Database.BatchableContext의 용도?** 현재 실행 중인 배치 작업 정보(특히 ID)에 접근하는 인터페이스. 진행 추적·대량 데이터를 작은 배치로 처리해 거버너 한도 회피.

## Database.QueryLocator vs Iterable<SObject>
| 기능 | QueryLocator | Iterable<SObject> |
|---|---|---|
| 적합 | 대량(최대 5천만 건) | 소량(최대 5만 건) |
| 동작 | SOQL로 청크 조회 | 커스텀 레코드 목록, 더 많은 제어 |
| 성능 | 벌크 처리 효율 | 유연하나 크기 제한 |
| 사용 사례 | 수백만 건 효율 처리 | 처리 전 커스텀 필터·복잡 쿼리 |

**Batch에서 콜아웃 가능?** 가능. `Database.AllowsCallouts` 구현 필요. start·execute·finish 각 실행당 최대 100회. scope 크기 주의(200이면 처음 100건만 콜아웃 성공).

**Database.RaisesPlatformEvents (BatchApexErrorEvent)?** Batch 작업의 미처리 예외 발생 시 자동 발동되는 표준 플랫폼 이벤트. 예외 메시지·스택 추적·컨텍스트 캡처. `Database.RaisesPlatformEvents` 구현 필요.

**"uncommitted work pending" 오류?** 같은 트랜잭션에서 DML 후 콜아웃 시도 시 발생. Salesforce는 콜아웃을 DML 전에 실행하도록 강제. **해결:** 모든 콜아웃을 DML 전에 실행.

**System.FinalException?** 불변·읽기 전용 데이터를 수정하려 할 때 발생. 예: after 트리거의 Trigger.new는 읽기 전용("Record is read-only"). **해결:** before 트리거에서 수정.

**배치 작업 변경 가능?** 가능(재스케줄·취소·삭제·공유).

**배치 작업 한도:** 동시 5개, 배치당 최대 2,000건, 24시간당 5천만 건 처리, 24시간당 배치 시작 250,000회.

**배치 작업 실패 시?** 배치 내 레코드 실패 시 전체 배치 롤백. 5천만 건 초과 반환 시 Failed로 표시·즉시 종료.

**Apex Flex Queue?** 실행 제출됐으나 즉시 처리되지 않는 작업 큐. Holding 상태 최대 100개.

**단일 트랜잭션 콜아웃 최대?** 100회. 관리: Batch(청크 처리), 비동기(future·Queueable).

**Future가 객체를 매개변수로 못 받는 이유?** 호출~실행 사이에 sObject가 변경될 수 있어서.

**Future에서 Future 호출?** 불가(비동기에서 비동기 호출 불가).

**Future를 큐에 넣을 수 있나?** 비동기 큐에 등록되어 백그라운드 실행되나, Future끼리 직접 체이닝 불가 → Queueable 사용.

**Queueable/Batch에서 Future 호출?** 미지원. 대안: Queueable(복합 타입·체이닝).

**Future에서 Queueable 호출?** 가능(Future 실행 중 Queueable 등록).

**Queueable 체이닝 횟수?** 단일 트랜잭션 최대 50개, Dev/Trial 스택 깊이 5(즉 4회 체이닝).

## Future vs Queueable
- **매개변수**: Future는 기본 타입만, Queueable은 복합 타입(sObject·커스텀).
- **모니터링**: Future는 추적 불가, Queueable은 Job ID로 추적.
- **체이닝**: Future 불가, Queueable 가능.
- **사용 사례**: Future는 단순 fire-and-forget, Queueable은 복잡 처리·모니터링·체이닝.

**Batch에서 Queueable 사용?** 가능(execute·finish에서).

**600건/배치 크기 200, 두 번째 트랜잭션 실패 시?** 각 배치는 별도 트랜잭션. 1·3번째는 커밋, 2번째만 롤백. 각 배치 독립 동작.
