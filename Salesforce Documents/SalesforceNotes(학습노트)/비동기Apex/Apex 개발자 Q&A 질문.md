---
tags: [apex, async, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Apex Developer Interview Questions]
---

# Apex 개발자 Q&A 질문

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

**1. Apex란?** Salesforce의 강타입 객체지향 프로그래밍 언어.

**2. 데이터 타입?** 기본(Integer, Double, String, Long, Date, Id, Boolean), sObject(일반/특정 예: Account), 컬렉션(List, Set, Map), 사용자 정의 클래스, 시스템 제공 클래스.

**3. List?** 순서 있는 컬렉션, 각 요소에 인덱스. 모든 데이터 타입 가능.
```apex
List<Integer> myList = new List<Integer>();
myList.add(20);
Integer i = myList.get(0);
List<Account> accList = [SELECT Id, Name FROM Account];
```

**4. Set?** 순서 없는 중복 없는 컬렉션.
```apex
Set<Integer> intSet = new Set<Integer>();
intSet.add(20);
Boolean b = intSet.contains(30);
```

**5. Map?** 키-값 쌍, 키는 고유.
```apex
Map<Id, Account> IdToAccountMap = new Map<Id, Account>(accList);
```

**6. SOQL?** Salesforce 레코드 읽기. SQL 유사하나 Lightning 플랫폼 맞춤.

**7. 익명 실행 창?** 로그에 결과 표시, System.debug() 디버깅. 테스트 후 디버그문 제거(모범 사례).

**8. DML?** insert/update/delete/undelete/upsert. 항상 벌크로.

**9. 거버너 한도:**
| 항목 | 동기 | 비동기 |
|---|---|---|
| SOQL 쿼리 | 100 | 200 |
| SOQL 반환 레코드 | 50,000 | 50,000 |
| SOSL 쿼리 | 20 | 20 |
| DML 문 | 150 | 150 |
| 콜아웃 | 100 | 100 |
| 힙 크기 | 6MB | 12MB |

**10. Database 클래스?** DML 메서드 제공(static): insert/upsert/update/delete/undelete/merge.

**11. DML vs Database 클래스?** DML은 예외 throw·try-catch. Database 메서드는 벌크 부분 성공 허용.

**12. 디버그 로그?** DB 변경·HTTP 콜아웃·Apex 오류·리소스·워크플로우 기록.

**13. 트리거?** 레코드 삽입·업데이트·삭제·복원 시 시작.

**14. 트리거 유형?** Before(저장 전 검증·업데이트), After(시스템 설정 필드 접근·관련 레코드 변경).

**15. 트리거 이벤트?** before/after insert·update·delete, after undelete.

**16. 컨텍스트 변수?** isExecuting, isInsert, isUpdate, isDelete, isBefore, isAfter, isUndelete, size.

**17. Trigger.new vs newMap?** new는 새 레코드 목록(insert·update·undelete, before에서만 수정), newMap은 id→레코드 맵.

**18. Trigger.old vs oldMap?** old는 이전 버전 목록, oldMap은 id→이전 레코드 맵.

**19. 트리거 모범 사례?** 오브젝트당 하나, 벌크화, 루프 안 SOQL/DML 회피, 중첩 루프 대신 Map, static boolean으로 재귀 방지.

**20. 벌크화?** 단일·벌크 레코드 모두 처리, sObject 컬렉션 작업, 효율적 SOQL/SOSL.

**21. 실행 순서?** 레코드 로드 → 시스템 검증 → before flow → before 트리거 → 커스텀 검증 → after 트리거 → 할당/자동응답/워크플로우/에스컬레이션 → record-triggered flow → 엔타이틀먼트 → 롤업 → 기준 기반 공유 → 커밋 → 커밋 후 로직 → 이메일 → 비동기 Apex.

**22. 트리거 재귀?** static boolean 변수(기본 true) 클래스 생성.

**23. Test.startTest()/stopTest()?** startTest는 새 거버너 한도로 테스트, stopTest는 비동기 작업 처리.

**24. @testSetup?** 테스트 레코드 1회 생성해 모든 테스트 메서드에서 접근, 클래스 종료 시 롤백.

**25. 테스트 모범 사례?** 벌크 데이터, startTest/stopTest, assert, 긍정·부정 테스트.

**26. 비동기 Apex?** 백그라운드 작업 실행. 외부 콜아웃·높은 한도·특정 시간 실행.

**27. 비동기 유형?** Future(자체 스레드, 콜아웃), Batch(대량, 정리·아카이빙), Queueable(체이닝·복합 타입), Scheduled(일·주간).

**28. Future 메서드?** 백그라운드 비동기, 별도 스레드, static·void, Future에서 Future 호출 불가.

**29. Batch Apex?** 대량(수백~수백만 건) 비동기 배치 처리. 정리·아카이빙에 최적.

**30. Batch 메서드?** start(수집, QueryLocator/Iterable 반환), execute(처리, 기본 200건, 순서 무관), finish(후처리, 이메일).

**31. Queueable Apex?** Future 상위 집합, Future+Batch 조합. System.enqueueJob() 호출, 단일 트랜잭션 50개.

**32. 트리거에서 Batch 호출?** 가능하나 매번 호출 금지(5개 한도 초과).

**33. Batch에서 Batch?** finish에서만, start/execute는 AsyncException.

**34. Batch 실행?** Database.executeBatch(인스턴스, scope 크기).

**35. Batch vs Data Loader?** Data Loader는 정적 데이터셋. Batch는 동적 생성·쿼리, 복잡 로직.

**36. Future 사용 이유?** 외부 서비스 콜아웃 같은 장기 작업.

**37. Scheduled Apex?** 특정 시간 코드 실행, Schedulable 구현.

**38. Batch 스케줄?** 인터페이스 또는 System.scheduleBatch.

**39. 트리거에서 콜아웃?** 직접 불가, @future로 async 변환 후 콜아웃.

**40. Batch에서 Queueable?** 가능(거버너 한도 고려).

**41. Batch에서 Future?** 불가(과도한 비동기 체이닝 방지).

**42. Batch vs Normal Apex?** Normal은 100건/사이클·50,000 SOQL, Batch는 200건/사이클·5천만 SOQL.

**43. Custom Settings?** 재사용 데이터 org 전반 접근. List(전역 정적), Hierarchical(org·프로필·사용자별).

**44. with/without sharing?** with는 현재 사용자 공유 규칙 고려, without은 시스템 모드(모든 접근).

**45. Database.QueryLocator?** Batch에서 대량(최대 5천만 건) 조회.

**46. 예외 처리?** try-catch. NullPointerException, DMLException, QueryException.

**47. Wrapper 클래스?** 서로 다른 데이터 타입 컬렉션 Apex 클래스.

**48. public/static?** public은 다른 클래스 접근, static은 인스턴스 아닌 클래스 소속.

**49. @AuraEnabled / cacheable=true?** LWC 접근 가능, cacheable=true는 캐싱(wire 사용 시).

**50. public/global/private?** global은 org 외부, public은 org 내, private는 메서드·클래스 내.

**51. 동기/비동기 트리거?** 동기는 검증·데이터 조작·업데이트, 비동기는 이메일·콜아웃 같은 지연 가능 작업.
