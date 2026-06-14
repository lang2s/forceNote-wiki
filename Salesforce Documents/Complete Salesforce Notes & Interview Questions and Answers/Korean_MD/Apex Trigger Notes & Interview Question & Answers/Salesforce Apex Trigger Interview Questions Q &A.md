---
tags: [apex, trigger, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Salesforce Apex Trigger Interview Questions Q &A]
---

# Salesforce Apex 트리거 면접 질문

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

**Workflow/Process Builder와 Trigger의 차이?** Workflow·Process Builder는 액션 후에만 작동, Trigger는 액션 전후 모두 작동.

**Trigger란?** DB에서 레코드가 업데이트·삽입·삭제되기 전후에 실행되는 코드.

**트리거 작성 방법?** Standard Navigation, Developer Console, Eclipse IDE.

**트리거 이벤트?** Before Insert(삽입 전 로직, 예: 검증), After Insert(삽입 후, 예: 이메일 경고), Before Update, After Update(예: 이메일 알림), Before Delete(예: 자식 레코드 제거), After Delete(예: 롤업 요약), After Undelete(복원 후).

**컨텍스트 변수?** isExecuting, isUpdate, isInsert, isBefore, isAfter, new, old, newMap, oldMap, size.

**트리거 모범 사례?** 오브젝트당 트리거 하나, Helper·Handler 메서드 사용, 로직 없는 트리거, for 루프 안 쿼리 금지, 필터링된 쿼리, 하드코딩 ID 회피, future 메서드 적절히 사용, 벌크화.

**실행 흐름?** DB 로드 → 시스템 검증 → before 트리거 → 커스텀 검증 → after 트리거 → 워크플로우·Process Builder → 롤업 요약 → 공유·보안 → 커밋 후 작업(이메일).

**왜 오브젝트당 트리거 하나?** 여러 트리거면 실행 순서를 인식할 수 없음. 코드 명확성·재사용성·모듈성·유지보수성 향상.

**Helper와 Handler?** 트리거 클래스를 Helper, Apex 클래스를 Handler라 함.

**로직 없는 트리거의 이유?** 관심사 분리, 모듈성·재사용성·유지보수성 향상, 복잡한 로직으로 인한 거버너 한도 회피.

**왜 루프 안 쿼리 금지?** 반복마다 DB에서 레코드를 가져와 DB 작업 수·CPU 시간 증가, 쿼리·DML 한도 영향, 성능·거버너 한도 문제.

**왜 쿼리는 필터링되어야?** 성능 향상, 리소스 사용·처리 오버헤드 감소, 효율 향상.

**하드코딩 ID 회피 이유?** 개발 조직에서는 작동하나 다른 조직에서는 안 됨. 코드 유연성 저하, 환경 변경 시 유지보수 어려움.

**벌크화된 트리거?** 기본적으로 모든 트리거는 벌크 트리거로 한 번에 여러 레코드를 배치로 처리(배치당 200개). 성능 향상·DB 작업 감소.

**재귀 트리거?** 한 메서드가 다른 메서드를 호출하고 그 메서드가 다시 첫 메서드를 호출하거나, 오브젝트 트리거가 같은 트리거의 다른 인스턴스를 시작하는 상황.

**재귀 방지?** 기본값 true인 static boolean 변수를 가진 클래스 생성.

**트리거 구문?** `trigger trigger_name on object(events){}`

**Trigger.new?** sObject에 최근 추가된 레코드 목록 반환.

**컨텍스트 변수를 사용하는 이유?** 개발자가 런타임 컨텍스트에 접근하기 위해.

**Null Pointer Exception 발생 시점?** 초기화되지 않은 오브젝트 필드를 사용하려 할 때.

**오류·예외 처리?** try-catch 블록으로 예외를 잡아 우아하게 처리. 오류 세부 로깅, 알림 전송 등 적절한 오류 처리 로직 구현.
