---
tags: [apex, trigger, recursion, static-variable, best-practice]
source: salesforce_apex_developer_guide.pdf (Apex Developer Guide — Using Static Methods and Variables / Trigger Stack Depth, Tier 2)
created: 2026-06-14
aliases: [Trigger 재귀 방지, 트리거 재귀, Trigger Recursion, recursion guard, firstRun 플래그, static 재귀 제어]
---

# Trigger 재귀 방지 (Trigger Recursion)

> 트리거 안의 DML이 같은 트리거를 다시 발동시켜 무한·중복 실행되는 문제. 공식 해법은 **클래스의 `static` 변수**로 1회 실행 여부를 추적해 재진입을 차단하는 것. 재귀 트리거의 스택 깊이는 **최대 16**으로 제한된다.

---

## 왜 재귀가 발생하나

트리거가 레코드를 update/insert 하면, 그 DML이 **같은 객체의 트리거를 다시 발동**시킨다. 핸들러가 또 DML을 하면 다시 발동… 이렇게 의도치 않은 반복(중복 계산, 거버너 한도 초과, `maximum trigger depth exceeded` 오류)이 생긴다.

> 플랫폼은 무한 재귀를 막기 위해 **재귀적으로 트리거를 발동하는 Apex 호출의 총 스택 깊이를 16으로 제한**한다(insert/update/delete로 트리거가 재귀 발동하는 경우).

---

## 핵심 메커니즘 — `static` 변수의 트랜잭션 스코프

`static` 변수는 **Apex 트랜잭션 범위 안에서만** static하다. 서버·조직 전체가 아니라 **단일 트랜잭션 동안 값이 유지**되고 트랜잭션 경계에서 리셋된다. 따라서 **하나의 DML이 트리거를 여러 번 발동시켜도 static 변수 값은 그 발동들 사이에 유지**된다 → 재귀 종료 판단에 쓸 수 있다.

> [!important] **트리거가 아니라 클래스에 정의해야 한다.** 트리거에 정의한 static 변수는 **같은 트랜잭션 내라도 트리거 컨텍스트가 다르면**(예: `before insert` ↔ `after insert`) 값이 유지되지 않는다. 클래스 멤버 변수로 두고 트리거가 그 static 값을 참조·갱신해야 한다.

---

## 공식 패턴 — `firstRun` 플래그 (Tier 2 원문)

아래는 Apex Developer Guide의 **원문 예제**다. 클래스에 static boolean을 두고, 트리거가 첫 실행만 선택적으로 처리한다.

```apex
// Apex Developer Guide 원문 예제 (Tier 2) — 클래스에 static 플래그 정의
public class P {
    public static boolean firstRun = true;
}

// 첫 실행에서만 동작하고 이후 재진입은 건너뜀
trigger T1 on Account (before delete, after delete, after undelete) {
    if(Trigger.isBefore){
        if(Trigger.isDelete){
            if(p.firstRun){
                Trigger.old[0].addError('Before Account Delete Error');
                p.firstRun=false;
            }
        }
    }
}
```

### 실무 권장형 — 핸들러에서 1회 가드

```apex
// 구조 예시 — 위 공식 static 플래그 원리를 핸들러에 적용 (일반 패턴)
public class AccountTriggerHandler {
    @TestVisible
    private static Boolean hasRun = false;

    public static void run(List<Account> newList) {
        if (hasRun) { return; }   // 재진입 차단
        hasRun = true;
        // ... DML을 동반하는 비즈니스 로직 (이 DML이 트리거를 재발동해도 위에서 차단됨)
    }
}
```

### 레코드 단위 가드 — 처리된 Id 추적

전체 실행을 한 번으로 막으면 안 되고 **레코드별로 1회만** 처리해야 할 때는 `Set<Id>`로 이미 처리한 레코드를 추적한다.

```apex
// 구조 예시 — '처리된 Id' Set 가드 (일반 패턴)
public class AccountTriggerHandler {
    private static Set<Id> processedIds = new Set<Id>();

    public static void run(List<Account> records) {
        List<Account> toProcess = new List<Account>();
        for (Account a : records) {
            if (!processedIds.contains(a.Id)) {
                processedIds.add(a.Id);
                toProcess.add(a);
            }
        }
        // toProcess 만 처리 → 같은 레코드가 재귀로 다시 들어와도 스킵
    }
}
```

---

## 주의 — 롤백 시 static 변수는 복원되지 않는다

> [!warning] **static 변수는 롤백(rollback)으로 되돌려지지 않는다.** savepoint로 롤백한 뒤 트리거가 다시 실행되면, static 변수는 **첫 실행 때의 값을 그대로 유지**한다. 따라서 예외 후 재시도 경로에서 `firstRun=false`가 남아 정상 로직이 통째로 스킵될 수 있다 — 예외/재시도 시나리오가 있으면 가드 변수 리셋을 신중히 설계한다.

---

## 프레임워크 방식 — 루프 카운트 제한

TriggerHandler 프레임워크를 쓰면 static 플래그를 직접 관리하는 대신 **루프 카운트 상한**으로 재귀를 제어할 수 있다. `setMaxLoopCount(1)`로 한 트랜잭션에서 한 번만 실행되도록 제한한다.

- 상세: [[TriggerHandler 패턴]] — `loopCountMap`, `setMaxLoopCount(Integer)` 구현

---

## 비교 — 어떤 방식을 쓰나

| 방식 | 적합 상황 |
|---|---|
| `static Boolean` 1회 가드 | 트리거 전체를 트랜잭션당 1회만 실행 |
| `static Set<Id>` 가드 | 레코드별 1회 처리(일부 재진입은 허용) |
| `setMaxLoopCount(n)` (프레임워크) | TriggerHandler 패턴 사용 중이고 N회로 제한하고 싶을 때 |

---

## 관련 노트

- [[TriggerHandler 패턴]] — 트리거 프레임워크, `setMaxLoopCount` 루프 제한
- [[Apex Best Practices]] — Order of Execution, 트리거 모범 사례
- [[Governor Limits]] — 트리거 스택 깊이 등 한도
- [[DML 패턴]] — 트리거 내 DML과 재발동
