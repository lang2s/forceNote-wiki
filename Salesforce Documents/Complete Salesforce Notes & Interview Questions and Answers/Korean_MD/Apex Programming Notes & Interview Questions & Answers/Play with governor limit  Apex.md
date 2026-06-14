# 거버너 한도 다루기 (Apex)

커스텀 오브젝트 testobject__c에 50,000개 레코드를 만들어 보며 한도를 실험합니다. 단일 트랜잭션 한도: DML 문 150개, DML 작업(행) 10,000개.

## DML 행 한도

```apex
public static void dmloperation(){
    List<TestObject__c> createRecords = new List<TestObject__c>();
    for(Integer i = 0; i<=10000; i++) {
        createRecords.add(new TestObject__c(Age__c = i));
    }
    insert createRecords; // 10001개 → System.LimitException: Too many DML rows: 10001
}
```

DML 문 1/150만 사용하는 방법: 9999개 인스턴스를 리스트에 모은 뒤 한 번의 insert로 삽입(벌크화). 이는 "bulkification" 모범 사례로, DML 작업 수를 최소화해 대량 데이터를 적절히 처리합니다.
```apex
for(Integer i = 1; i<10000; i++) {
    createRecords.add(new TestObject__c(Age__c = i));
}
insert createRecords;
```

10,000개 생성 후 나머지 40,000개를 만들려 했으나, 학습 에디션 조직의 데이터 저장 한도(5.0MB)를 초과(21.1MB 사용)하여 50,000개를 만들 수 없었습니다.

레코드 삭제:
```apex
List<TestObject__c> RetriveRecords = [SELECT id FROM TestObject__c];
delete RetriveRecords;
```
참고: 단일 트랜잭션에서 50,000행을 조회할 수 있습니다.

## CPU 시간 한도

CPU 시간은 Salesforce 서버에서 Apex 코드 실행·트리거 등이 소비하는 처리 시간(밀리초)으로, 멀티테넌트 플랫폼에서 공정한 자원 할당을 위해 엄격히 모니터링됩니다.
- 동기: 10초
- 비동기: 60초

```apex
for(integer i=0 ; i< 10000000; i++){ system.debug(i); }
// 반복이 많아 10초 초과 → CPU time limit exceeded 오류
```

## 모범 사례

효율적인 코드 작성, SOQL 쿼리 최적화, 적절한 데이터 구조 사용, 가능한 한 루프 사용 제한, 대량 데이터를 효율적으로 처리하기 위한 코드 벌크화.
