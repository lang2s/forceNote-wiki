---
tags: [scenario, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [TCS SF Interview Q &A]
---

# TCS Salesforce 개발자 Q&A 질문

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

**1. Trigger.new/old/newMap/oldMap 차이?**

Trigger.new는 새 레코드, Trigger.old는 업데이트 전 데이터. newMap은 ID 포함 새 레코드, oldMap은 ID 포함 이전 데이터.

**2. 삭제 레코드 복원 시 ID 변경?**

아니오, 동일 ID 유지.

**3. trigger.isExecuting 용도?**

Apex 클래스의 메서드가 트리거에서 호출될 때만 실행되도록 하려면 isExecuting으로 확인.

**4. Future에 객체 인수 불가 이유? Batch/다른 Future에서 Future 호출?**

호출~실행 사이 객체 변경 가능성으로 레코드 ID 전달. Batch·Future에서 Future 호출 불가.

**5. Future 실행 중 다운타임 발생 시?**

롤백 후 다운타임 종료 시 재시작.

**6. 유지보수 전 큐에 있던 Future?**

큐에 남아 유지보수 종료·리소스 가용 시 실행.

**6b. Database.Stateful?**

Batch는 stateless(각 실행 별도 트랜잭션). Database.Stateful 구현 시 트랜잭션 간 상태 유지(인스턴스 변수만, static 미유지). 배치 진행 중 레코드 카운트에 중요.

**7. SOQL 문 유형?**
- **Static SOQL**: `[]`(배열 괄호)로 작성, 동적 변경 없을 때.
- **Dynamic SOQL**: 런타임에 SOQL 문자열 생성, 유연한 앱(필드명 변동·사용자 입력 검색).

**8. HAVING 절?**

aggregate 함수 결과를 필터링. GROUP BY와 함께 사용. WHERE와 유사하나 aggregate 함수 포함 가능.
```sql
SELECT LeadSource, count(Name) FROM Lead GROUP BY LeadSource HAVING count(Name) > 6
```

**9. with vs without sharing?**

with sharing은 현재 사용자 공유 규칙만 적용(오브젝트·필드 권한 X). without sharing은 공유 규칙 미적용.

**10. 대시보드 컴포넌트?**

Gauge(단일 값/범위), Visualforce page(커스텀), Metric(키-값 쌍), Table(목록), Charts(line/bar/donut/funnel/pie 등 6종).
