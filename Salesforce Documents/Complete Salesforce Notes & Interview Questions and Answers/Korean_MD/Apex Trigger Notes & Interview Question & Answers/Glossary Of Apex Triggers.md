# Salesforce Apex 트리거 용어집

| 용어 | 정의 |
|---|---|
| Trigger.IsDelete | 레코드 삭제로 트리거가 실행 중인지 나타내는 Boolean |
| Trigger.IsUndelete | 레코드 복원으로 실행 중인지 나타내는 Boolean |
| SOQL | Salesforce Object Query Language — Apex에서 레코드 쿼리 |
| DML | Data Manipulation Language — 레코드 삽입·업데이트·삭제·복원 |
| Governor Limits | 단일 트랜잭션에서 Apex가 소비할 수 있는 리소스 한도(플랫폼 안정성) |
| Bulkification | 단일 레코드가 아닌 대량 레코드를 처리하는 코드 작성 관행 |
| Future Methods | 메인 트랜잭션을 막지 않고 별도 스레드에서 비동기 실행되는 메서드 |
| Dependency Injection | 클래스 내부에서 생성하지 않고 오브젝트를 전달하는 패턴(테스트·유연성) |
| After Insert Trigger | DB 삽입 후 발동하는 트리거 |
| Before Update Trigger | DB 업데이트 전 발동하는 트리거 |
| Static Variables | 인스턴스가 아닌 클래스에 속하는 변수 |
| Trigger.isExecuting | 코드가 트리거의 일부로 실행 중이면 true |
| Trigger.newMap | ID→새 버전 sObject 맵 |
| Trigger.oldMap | ID→이전 버전 sObject 맵 |
| Trigger.size | 트리거를 발동시킨 총 레코드 수 |
| TriggerContext | 트리거 컨텍스트 정보에 접근하는 내장 Apex 클래스 |
| TriggerHandler | 트리거 로직을 조직·관리하는 커스텀 Apex 클래스 |
| TriggerFactory | 다양한 컨텍스트용 TriggerHandler 인스턴스를 생성하는 커스텀 클래스 |
| Database.SaveResult | DML 작업이 처리한 레코드의 저장 결과 모음 |
| Database.rollback | 현재 트랜잭션의 DB 변경을 되돌리는 메서드 |
| System.assert | 조건이 true임을 단언하는 메서드 |
| Batch Apex | 대용량 데이터를 배치로 처리하는 기능 |
| Context Variable | 현재 실행 컨텍스트 정보를 저장하는 변수 |
| Database.QueryLocator | 많은 레코드를 반환하는 쿼리에 사용하는 클래스 |
| Data Skew | 적은 수의 레코드를 많은 사용자가 접근해 경합·성능 문제 발생 |
