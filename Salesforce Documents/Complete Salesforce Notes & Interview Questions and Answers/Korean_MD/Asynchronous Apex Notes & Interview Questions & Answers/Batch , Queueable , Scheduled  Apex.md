# Batch, Queueable, Scheduled, Future 면접 질문

## Batch Apex
1. **Batch Apex란?** 대량 데이터를 작은 배치로 비동기 처리해 거버너 한도 회피.
2. **언제 사용?** 대량(50,000건 초과) 처리, 동기 실행 시간 한도 우회 시.
3. **실행 흐름?** execute는 각 배치마다 호출, finish는 모든 배치 후 호출.
4. **배치 크기 지정?** Salesforce가 자동 결정하나 executeBatch의 scope 매개변수로 지정 가능.
5. **오류 처리?** execute에서 try-catch.

## Queueable Apex
6. **Queueable Apex란?** 복잡·장기 작업을 Apex 작업 큐에 추가해 비동기 처리.
7. **Batch 대비 장점?** 유연한 실행 흐름, 레코드 수 제한 없음, 체이닝 가능.
8. **Batch에서 Queueable 호출?** 가능(배치 완료 후 추가 처리).

## Scheduled Apex
9. **Scheduled Apex란?** Apex 클래스를 지정 시간·간격에 실행.
10. **스케줄 방법?** System.schedule 또는 UI.
11. **동일 클래스 다중 인스턴스?** 가능(다른 시간·간격).
12. **예외 처리?** execute에서 try-catch.

## Future 메서드
13. **Future 메서드란?** 장기 작업을 별도 스레드에서 비동기 실행.
14. **제한?** 트리거에서 호출 불가(직접), 콜아웃 한도, non-setup 오브젝트 DML 제약.
15. **Visualforce에서 호출?** 가능, 콜아웃 시 @future(callout=true) 필요.

## 시나리오 질문
16. **복잡 로직으로 대량 레코드 업데이트?** Batch Apex(대량 처리, 동기 한도 우회).
17. **외부 콜아웃 장기 작업?** Queueable Apex(장기 작업·비동기 콜아웃 지원).
18. **매일 특정 시간 반복 작업?** Scheduled Apex.
19. **순서가 중요한 다중 비동기 작업?** Queueable 체이닝.
20. **트리거에서 외부 콜아웃?** Future 메서드(비동기 콜아웃, 콜아웃 한도 분리).

## 추가 비동기 시나리오
1. **외부 API 비동기 콜아웃?** Future 또는 Queueable.
2. **Future vs Queueable?** Future는 콜아웃 포함 비동기지만 제약 있음, Queueable은 유연·복잡 처리·큐잉.
3. **다중 Queueable 체이닝?** Queueable 구현 + System.enqueueJob.
4. **비동기 오류 처리?** try-catch, addError로 커스텀 메시지.
5. **Future에서 DML?** non-setup 오브젝트는 가능, setup 오브젝트는 불가.
6. **Lightning/VF에서 콜아웃?** Future·Queueable·HttpCalloutMock(테스트).
7. **콜아웃 한도 회피?** 비동기 Apex는 동기와 별도 한도.
8. **다중 비동기 실행 순서?** Queueable 체이닝 또는 종속 Future.
9. **간격 실행 예약?** Scheduled Apex.
10. **비동기 거버너 한도?** 비동기 Apex는 자체 한도 존재, 설계 시 고려.
