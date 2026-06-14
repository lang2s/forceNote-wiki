# 트리거에서 재귀(Recursion) 방지 방법

재귀는 트리거 내 DML 작업으로 트리거가 자신을 반복 호출해 무한 루프나 거버너 한도 도달을 일으킬 때 발생합니다.

**방지 방법:**

1. **헬퍼 클래스의 Static Boolean 플래그:** static Boolean 변수로 트리거가 이미 실행되었는지 추적.

2. **Trigger Framework:** Trigger Handler 패턴으로 트랜잭션당 한 번만 실행되도록 보장.
