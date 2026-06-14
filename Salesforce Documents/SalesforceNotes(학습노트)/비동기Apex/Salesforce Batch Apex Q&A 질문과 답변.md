---
tags: [apex, async, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [SALESFORCE BATCH APEX INTERVIEW QUESTIONS]
---

# Salesforce Batch Apex Q&A 질문과 답변

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

**1. Batch Apex란?** 대량 데이터를 비동기 처리. 일반 거버너 한도를 초과하는 작업을 작은 청크로 나눠 실행.

**2. 세 가지 메서드?** start(처리할 레코드 조회), execute(각 배치 처리), finish(작업 완료 후 후처리).

**3. Data Loader가 있는데 Batch를 쓰는 이유?** Data Loader는 정적·Excel 가능 작업만. Batch는 더 많은 커스터마이즈·복잡 로직·런타임 계산(start에서 필터·관련 쿼리 등).

**4. 기본·최대 배치 크기?** 기본 200, 최대 2000.

**5. 동시 실행 가능 배치 최대?** 5개(활성·큐).

**6. 단일 실행 최대 레코드?** 5천만 건.

**7. start 메서드 동시 실행 최대?** 1.

**8. Apex Flex Queue의 Holding 상태 최대?** 100개.

**9. 트리거에서 Batch 실행?** 가능하나 권장 모범 사례 아님.

**10. Batch 구현 인터페이스?** Database.Batchable.

**11. Batch 작업 일시정지·재개?** 불가(시작 후). 체이닝으로 유사 구현 가능.

**12. 배치 실행 순서 보장?** 미보장. 시스템 리소스·큐 작업 등에 영향. 특정 순서에 의존 금지.

**13. finish 메서드 목적?** 모든 배치 후 호출. 확인 이메일·관련 레코드 업데이트·로깅·추가 작업 트리거.

**14. 미래 1회 실행 스케줄?** System.scheduleBatch. 스케줄 작업 ID 반환.

**15. Database.QueryLocator 장점?** 단순 SELECT로 범위 조회 시 SOQL 반환 레코드 거버너 한도 우회(최대 5천만 건).

**16. Batch에서 Batch 호출?** 가능(finish에서).

**17. 1000건/배치 200, 5번째 배치만 오류 시?** 각 배치는 독립 트랜잭션. 5번째만 롤백, 1~4번째는 커밋 유지.

**18. 문제 레코드만 롤백하려면?** Database 메서드(allOrNone=false) 활용.

**19. Batch에서 Future 호출?** 불가(동작 방식 차이로 예기치 않은 동작).

**20. Batch에서 콜아웃?** Database.AllowsCallouts 구현.

**21. Batch 상태 추적?** 실행 시 Job ID로. ① UI(Setup → Apex Jobs), ② AsyncApexJob 쿼리.
```apex
AsyncApexJob aaj = [SELECT Id, Status, JobItemsProcessed, TotalJobItems,
    NumberOfErrors FROM AsyncApexJob WHERE Id = :batchprocessid];
```

**22. Batch 재정렬 가능?** FIFO 순서. ① UI Apex Flex Queue(Holding 작업), ② System.FlexQueue 메서드.

**23. 성공·실패 카운트 이메일?** Database.Stateful 구현으로 인스턴스 변수 상태 유지(미구현 시 배치 간 리셋).

**24. Batch 작업 중단?** System.abortJob(jobId). 단 이미 시작된 작업은 불가, Queued·Holding만 가능.

**25. execute의 미처리 예외 발생 시?** 작업 종료. 적절한 오류 처리 필요(Database.Stateful로 오류 캡처).

**26. Batch에서 플랫폼 이벤트 발행?** Database.RaisesPlatformEvents 구현.

**27. QueryLocator vs Iterable?** QueryLocator는 SOQL 반환 한도 우회(5천만 건), Iterable은 한도 적용되나 커스텀 로직 가능. 필터 로직이 QueryLocator로 불가능할 때 Iterable.

**28. 거버너 한도 회피?** 코드 최적화, 루프 안 DML 회피, 작은 배치 처리.

**29. CloseDate 기반 Opportunity Stage 업데이트 Batch** — start에서 Opportunity 쿼리, execute에서 CloseDate 기준 StageName 설정.

**30. 배치 작업 상태?** Holding(Flex Queue 대기), Queued(실행 대기), Preparing(start 실행 중), Processing(처리 중), Aborted(사용자 중단), Completed(완료), Failed(시스템 실패).

**31. Batch Apex 제한:**
- 동시 큐·실행 5개
- Flex Queue Holding 100개
- 테스트 중 최대 5개 제출
- 24시간당 실행 250,000회 또는 200 × 사용자 라이선스 수(더 큰 값)
- QueryLocator 최대 5천만 건(초과 시 즉시 실패)
- Batch에서 FOR UPDATE 절 사용 불가
