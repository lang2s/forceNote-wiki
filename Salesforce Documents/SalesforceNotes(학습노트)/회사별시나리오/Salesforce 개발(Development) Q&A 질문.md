---
tags: [scenario, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Salesforce Developer Interview Questions]
---

# Salesforce 개발(Development) Q&A 질문

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

**1. 거버너 한도란? 왜 존재하나요?**

멀티테넌트 환경에서 효율적 리소스 사용을 보장하는 런타임 한도. 예: SOQL 트랜잭션당 100개, DML 150개, Heap 6MB(동기)/12MB(비동기), CPU 10,000ms. 시스템 성능·안정성·데이터 보안 유지를 위해 존재.

**2. SOQL과 SOSL의 차이/사용 시점.**

SOQL은 하나 이상 관련 오브젝트에서 레코드 쿼리(WHERE 조건 구조화 쿼리), SOSL은 여러 오브젝트 텍스트 검색(키워드 매칭 전문 검색).

**3. Bulkification이란? 왜 중요한가.**

한 번에 여러 레코드를 처리하도록 설계. 거버너 한도 위반 방지, 성능·확장성 향상.
```apex
// 좋은 예
List<Account> accList = [SELECT Id FROM Account WHERE Id IN :Trigger.newMap.keySet()];
for(Account a : accList){ a.Name='UpdatedName'; }
update accList;
```

**4. Before vs After Trigger.**

Before는 저장 전 실행(값 수정·검증, 명시적 update 불필요), After는 커밋 후 실행(관련 레코드 접근·저장 후 작업, 명시적 DML 필요).

**5. Batch Apex 작동/사용 시점.**

대량 레코드를 청크로 비동기 처리. start(수집)·execute(처리)·finish(후처리). 대량 업데이트·데이터 정리·외부 통합에 사용.

**6. 효율적·확장 가능 Apex 모범 사례.**

코드 벌크화, 루프 안 SOQL/DML 회피, 컬렉션 사용, 비동기 처리, SOQL 최적화, 예외 처리, 테스트 클래스(75%+).

**7. 외부 서비스 콜아웃 구현.**

Http·HttpRequest 클래스로 HTTP 콜아웃.

**8. 예외 처리 방법.**

try-catch, 오류 로깅(커스텀 오브젝트·디버그 로그), ApexPages.Message로 사용자 메시지.

**9. Apex 테스트 커버리지 보장.**

@isTest 어노테이션, 긍정·부정 시나리오, System.assert(), Test.startTest()/stopTest().

**10. Visualforce vs Lightning.**

Visualforce(페이지 중심, HTML+Apex, 서버 측, 레거시), Lightning(컴포넌트 기반, JS 클라이언트 측, 모던 앱·SPA).

**11. 트리거 재귀 방지.**

정적 Boolean 변수 또는 처리된 레코드 추적 Set.

**12. 트리거가 자신을 발동시킨 레코드를 업데이트하면?**

Before는 커밋 전 메모리 업데이트라 재귀 없음, After는 재귀 발생. 해결: Trigger.oldMap으로 변경 감지.

**13. 대량 처리에서 SOQL 한도 회피.**

루프 밖 SOQL, 조회 데이터에 Map 사용.

**14. SOQL for 루프 사용 시점.**

대용량 데이터셋(50,000+) 처리 시.

**15. 폴링 없이 LWC 실시간 업데이트.**

Platform Events 또는 Streaming API(empApi).

**16. LDS의 한계.**

Apex에서 사용 불가, 표준/커스텀 오브젝트만, 복잡한 쿼리 불가, DML 직접 호출 불가.

**17. 실시간 통합에서 API 한도 처리.**

지수 백오프, 비동기 처리, 호출 전 rate limit 확인.

**18. 만료된 OAuth 토큰 자동 갱신.**

Refresh Token Flow.

**19. Queueable/Future/Batch 사용 시점.**

Future(단순 비동기), Queueable(체이닝·관련 레코드), Batch(대용량 50K+).

**20. API 재시도 멱등성.**

External ID로 중복 제거, 고유 request ID로 추적, External ID Upsert.

**21. 트리거에서 future 메서드 호출 가능?**

아니요. Queueable Apex 사용. `System.enqueueJob(new MyQueueableJob());`

**22. System Mode vs User Mode.**

System Mode(사용자 권한·필드 보안 무시, 트리거·Batch·Scheduled), User Mode(권한·보안 적용, VF 컨트롤러·LWC·Flow).

**23. 레코드 공유 솔루션 설계 모범 사례.**

OWD 현명하게, 역할 계층, 공유 규칙, 수동 공유, Apex Managed Sharing, Queue 기반 공유, 대량 트랜잭션 시 공유 재계산 지연, View All/Modify All 신중히.

**24. Batch Apex 작업 예약.**

Batch 클래스 작성 → Scheduler 클래스(Schedulable) → System.schedule(name, cron, scheduler).

**25. LWC 라이프사이클 훅.**

constructor(생성, DOM 접근 금지), connectedCallback(DOM 추가, Apex 데이터 가져오기 적합), renderedCallback(렌더링 후, DOM 조작), disconnectedCallback(제거, 정리 작업), errorCallback(오류 처리).
