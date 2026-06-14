# Salesforce Apex & 트리거 면접 질문

Apex, 트리거, 거버너 한도 중심의 면접 질문 모음.

## Apex 기초

**1. Apex란?** Salesforce가 개발한 강타입·객체지향 언어. API 호출과 함께 Salesforce 서버에서 흐름·트랜잭션 제어 실행. Java와 유사한 구문.

**2. 거버너 한도란?** 공유 리소스 독점 방지를 위해 Salesforce가 강제하는 런타임 한도(SOQL, DML, 힙 크기, CPU 시간 등).

**3. Apex 컬렉션?** List(순서 있음), Set(고유 값, 순서 없음), Map(키-값 쌍).

**4. SOQL vs SOSL?** SOQL은 단일/관련 오브젝트에서 레코드 조회. SOSL은 여러 오브젝트 텍스트 검색.

**5. DML 문?** 데이터 조작: insert, update, delete, upsert, merge.

**6. @future 어노테이션?** 메서드 비동기 실행. DML 후 외부 콜아웃, 대량 데이터 처리에 사용.

**7. 커스텀 예외?** 사용자 정의 예외 클래스로 표준 예외 외 자체 오류 처리.

**8. Database 클래스?** 더 세밀한 제어의 DML 제공(Database.insert/update). allOrNone 플래그로 부분 처리 가능.

**9. Wrapper 클래스?** 객체·속성을 담는 커스텀 클래스. 서로 다른 타입을 단일 컬렉션으로 처리, 복잡한 데이터 구조 생성.

**10. with sharing 키워드?** 공유 규칙 강제. 사용자 권한·접근 존중.

## 트리거

**11. 트리거란?** 레코드의 특정 DB 이벤트(before/after insert·update 등) 전후 실행되는 Apex 코드.

**12. 트리거 컨텍스트 변수?** Trigger.new, Trigger.old, Trigger.isInsert, Trigger.isUpdate 등 작업 컨텍스트 제공 변수.

**13. 트리거 유형?** Before(저장 전 검증·수정), After(시스템 설정 필드 접근, 관련 레코드 작업).

**14. Trigger.new vs Trigger.old?** new는 insert·update의 새 버전 목록, old는 update·delete의 이전 버전 목록.

**15. 재귀 트리거란?** 다른 트리거 실행으로 인한 데이터 변경이 자신을 반복 호출. 무한 루프 위험.

**16. 재귀 방지?** 헬퍼 클래스의 static Boolean 변수로 실행 여부 확인.

**17. Trigger Handler 클래스?** 트리거 로직을 별도 처리. 단일 책임 원칙, 재사용성·가독성·디버깅 용이.

**18. Trigger.new vs newMap?** new는 새 레코드 목록, newMap은 ID→레코드 맵. newMap은 before update·after update에서만 사용 가능.

**19. 트리거 예외 처리?** try-catch 블록. 커스텀 예외 throw 가능.

**20. 트리거 실행 제한?** 거버너 한도(DML, SOQL, CPU 시간, 힙 크기) 적용.

## 거버너 한도

| 항목 | 한도 |
|---|---|
| SOQL 쿼리 | 동기 100 / 비동기 200 (트랜잭션당) |
| DML 문 | 150 (트랜잭션당) |
| CPU 시간 | 동기 10초 / 비동기 60초 |
| 힙 크기 | 동기 6MB / 비동기 12MB |
| 배치 크기 | 실행당 200 레코드 |
| 콜아웃 타임아웃 | 120초 |
| 이메일 | 단일 일 5,000건 / 대량 메일 수신자 1,000명 |
| SOQL 반환 레코드 | 트랜잭션당 50,000건 |
| 콜아웃 수 | 트랜잭션당 100회 |

**27. Limit 클래스?** Limits.getQueries(), Limits.getDMLStatements() 등으로 현재 리소스 소비 확인.

## 고급 Apex

**31. Batch Apex?** 대량 레코드를 200건 배치로 비동기 처리, 거버너 한도 관리.

**32. Queueable Apex?** 작업 체이닝 가능한 비동기 Apex, 순차 실행·리소스 제어.

**33. Scheduled Apex?** 특정 시간에 Apex 클래스 실행 예약, 반복 작업 자동화.

**34. Apex에서 웹 서비스 호출?** HttpRequest, HttpResponse, Http 클래스로 외부 콜아웃.

**35. Platform Events?** 실시간 통합. Flow·프로세스·트리거 발동, 비동기 이벤트 기반 통신.

## 모범 사례

**36. 벌크화 중요성?** 대량 데이터 처리, 거버너 한도 회피. 효율적·확장 가능한 코드의 핵심.

**37. Transient 키워드?** Visualforce 컨트롤러에서 뷰 상태 직렬화에 불필요한 변수 선언, 뷰 상태 크기 감소.

**38. @AuraEnabled vs @InvocableMethod?** AuraEnabled는 Lightning 컴포넌트에서 접근, InvocableMethod는 Process Builder·Flow에서 사용.

**39. SOQL 대량 처리?** LIMIT, OFFSET 페이지네이션, FOR 루프 활용.

**40. @TestVisible?** private 변수·메서드를 테스트 클래스에 노출, 커버리지 보장.

## 시나리오 질문

**41. 무한 루프 방지?** 헬퍼 클래스의 static Boolean 플래그.

**42. Database.SaveResult?** allOrNone=false인 DML의 성공·실패 정보 포함.

**43. @isTest?** Apex 클래스/메서드를 테스트로 표시. 테스트 환경에서만 실행, 배포 커버리지 보장.

**44. SOQL for 루프?** 200건 배치로 레코드 조회, 대량 처리 시 성능·메모리 개선.

**45. 거버너 한도 초과 최적화?** 효율적 SOQL·DML, 트리거 벌크화, 비동기 처리, Limit 클래스 모니터링.

**46. Custom Metadata Types?** 커스텀 데이터 타입 정의·메타데이터 레코드로 앱 구성 저장, 유지보수·이식성 향상.

**47. Batch Apex vs 트리거 대량 처리?** Batch는 200건 청크로 비동기 처리, 동기 트리거보다 거버너 한도에 유리.

**48. 비동기 Apex?** Batch, Queueable, Scheduled. 백그라운드 실행, 대량 처리·콜아웃 효율화.

**49. Custom Labels?** Apex·Visualforce에서 참조 가능한 커스텀 텍스트. 다국어 지원.

**50. Apex 디버깅?** 디버그 로그, System.debug, Developer Console.

## 실시간 시나리오 기반 질문

1. **Opportunity Amount > $1,000,000 시 영업 관리자 알림** → before insert/update 트리거에서 금액 확인 후 Messaging 클래스로 이메일 또는 Task 생성.
2. **중복 Account 방지** → before insert 트리거에서 고유 필드로 기존 레코드 쿼리, 일치 시 CustomException. 또는 Duplicate/Matching Rules.
3. **Contact의 Total_Purchase__c를 관련 Opportunity 합계로 실시간 반영** → Opportunity의 after insert/update/delete 트리거에서 Map<Id, Decimal>로 집계 후 업데이트.
4. **1년 이상 된 Case 아카이브 후 삭제** → Batch Apex로 쿼리·Archive 레코드 생성·원본 삭제.
5. **Account Industry 변경 시 관련 Contact의 Industry__c 일치** → after update 트리거, 변경된 Account 식별, 단일 벌크 DML.
6. **회계연도 Closed Won Opportunity 총액을 Account에 저장** → Master-Detail이면 롤업 요약, Lookup이면 Opportunity 트리거로 합산 후 커스텀 필드 업데이트.
7. **표준 전환 없이 Lead → Account/Contact 생성, 커스텀 필드 연결** → Lead 트리거/메서드로 레코드 생성, @future/Queueable 비동기 가능.
8. **활성 Contract 연관 레코드 삭제 방지** → before delete 트리거에서 확인 후 addError().
9. **Account/Contact 필드 변경 빈도 추적** → before update 트리거로 old/new 비교, 카운터 증가 또는 감사 오브젝트 기록. 또는 Field History Tracking.
10. **OpportunityLineItem 수량·제품 타입별 동적 할인** → before insert/update 트리거에서 Discount__c 계산, 복잡 시 헬퍼 클래스.

### 모범 사례·한도 시나리오

11. **동일 오브젝트 다중 트리거 실행 순서 문제** → 단일 트리거 + 핸들러 프레임워크로 통합.
12. **데이터 로드 중 SOQL 한도 초과** → 루프 밖 쿼리, 단일 SOQL로 통합, Map으로 메모리 필터링.
13. **Batch 힙 크기 초과** → execute()에서 작은 청크 처리, transient 변수, 미사용 데이터 제거.
14. **대량 레코드 재계산 성능 영향 없이** → Batch/Queueable 비동기, 오프피크 스케줄링.
15. **단일 트랜잭션 500+ 이메일 한도 초과** → Batch Apex로 10건 이하씩 전송, 주기적 스케줄.

### 복합 시나리오

16. **Closed 상태 Opportunity 수정 방지** → before update 트리거 + addError().
17. **일치 Account 소유 영업 담당에게 Lead 자동 할당** → before insert/update 트리거, Account 매칭 후 OwnerId 업데이트.
18. **전일 생성 Lead/Opportunity 일일 요약 이메일** → Scheduled Apex로 24시간 내 레코드 쿼리·Messaging 전송.
19. **할인 20% 초과 시 승인 프로세스** → before insert/update 트리거에서 Discount__c 확인, Approval.ProcessSubmitRequest 호출.
20. **Contact Email 변경 시 old/new 감사 기록** → after update 트리거, Email 변경 확인, 감사 오브젝트에 타임스탬프·Contact ID와 함께 기록.
