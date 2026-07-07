---
tags: [apex, trigger, pattern, architecture]
source: apex-recipes/TriggerHandler.cls, AccountTriggerHandler.cls
created: 2026-05-17
aliases: [트리거 핸들러, TriggerHandler]
---

# TriggerHandler 패턴

> 트리거 로직을 핸들러 클래스로 분리하는 표준 패턴. apex-recipes의 `TriggerHandler.cls`가 공식 구현.

---

## one-trigger-per-object 원칙

이 패턴의 대전제는 **객체당 트리거를 단 1개만** 두는 것이다. 한 객체에 같은 이벤트를 처리하는 트리거가 여러 개 있으면 Salesforce는 그 실행 순서를 보장하지 않는다(**실행 순서 비결정성**). 순서에 의존하는 로직이 비정상 동작하거나 재현하기 어려운 버그를 낳으므로, 객체마다 트리거 1개를 두고 모든 이벤트 분기를 그 트리거가 위임하는 단일 핸들러 클래스로 몰아 실행 순서를 코드로 통제한다.

---

## 구조 개요

```
AccountTrigger.trigger (1줄)
    ↓ new AccountTriggerHandler().run()
AccountTriggerHandler extends TriggerHandler
    ↓ beforeInsert() / afterInsert() / ...
AccountServiceLayer (실제 비즈니스 로직)
```

---

## TriggerHandler 추상 기반 클래스

```apex
public virtual class TriggerHandler {
    // 비활성화 레지스트리
    private static Set<String> bypassedHandlers = new Set<String>();

    // 루프 방지
    private static Map<String, LoopCount> loopCountMap = new Map<String, LoopCount>();

    public virtual void run() {
        if (!validateRun()) return;
        addToLoopCount();

        switch on Trigger.operationType {
            when BEFORE_INSERT  { this.beforeInsert();  }
            when BEFORE_UPDATE  { this.beforeUpdate();  }
            when BEFORE_DELETE  { this.beforeDelete();  }
            when AFTER_INSERT   { this.afterInsert();   }
            when AFTER_UPDATE   { this.afterUpdate();   }
            when AFTER_DELETE   { this.afterDelete();   }
            when AFTER_UNDELETE { this.afterUndelete(); }
        }
    }

    // 핸들러 비활성화 API
    public static void bypass(String handlerName) {
        bypassedHandlers.add(handlerName);
    }
    public static void clearBypass(String handlerName) {
        bypassedHandlers.remove(handlerName);
    }
    public static Boolean isBypassed(String handlerName) {
        return bypassedHandlers.contains(handlerName);
    }
    public static void clearAllBypasses() { bypassedHandlers.clear(); }

    // 루프 방지 설정 — 핸들러별 최대 실행 횟수 등록/갱신
    public void setMaxLoopCount(Integer max) {
        String handlerName = getHandlerName();
        if (!TriggerHandler.loopCountMap.containsKey(handlerName)) {
            TriggerHandler.loopCountMap.put(handlerName, new LoopCount(max));
        } else {
            TriggerHandler.loopCountMap.get(handlerName).setMax(max);
        }
    }

    // 루프 한도 해제 (max = -1 → LoopCount.exceeded()가 항상 false)
    public void clearMaxLoopCount() { this.setMaxLoopCount(-1); }

    // run()이 매 호출마다 카운트를 올리고, 한도 초과 시 예외
    protected void addToLoopCount() {
        String handlerName = getHandlerName();
        if (TriggerHandler.loopCountMap.containsKey(handlerName)) {
            Boolean exceeded = TriggerHandler.loopCountMap.get(handlerName).increment();
            if (exceeded) {
                Integer max = TriggerHandler.loopCountMap.get(handlerName).max;
                throw new TriggerHandlerException(
                    'Maximum loop count of ' + String.valueOf(max) +
                    ' reached in ' + handlerName
                );
            }
        }
    }

    // 핸들러별 실행 횟수 추적용 inner class
    private class LoopCount {
        private Integer max;
        private Integer count;
        public LoopCount()            { this.max = 5;   this.count = 0; }  // 기본 한도 5
        public LoopCount(Integer max) { this.max = max; this.count = 0; }
        public Boolean increment() { this.count++; return this.exceeded(); }
        public Boolean exceeded()  {
            if (this.max < 0) return false;        // 음수 = 한도 없음
            return this.count > this.max;
        }
        public void setMax(Integer max) { this.max = max; }
    }

    public class TriggerHandlerException extends Exception {}

    // 컨텍스트 메서드 — 구현 클래스에서 override
    protected virtual void beforeInsert()  {}
    protected virtual void beforeUpdate()  {}
    protected virtual void beforeDelete()  {}
    protected virtual void afterInsert()   {}
    protected virtual void afterUpdate()   {}
    protected virtual void afterDelete()   {}
    protected virtual void afterUndelete() {}
}
```

---

## 구현 클래스 (핸들러)

```apex
public with sharing class AccountTriggerHandler extends TriggerHandler {

    // 생성자에서 트리거 컨텍스트 변수 캐싱
    private List<Account> triggerNew;
    private Map<Id, Account> triggerMapNew;

    public AccountTriggerHandler() {
        this.triggerNew    = (List<Account>) Trigger.new;
        this.triggerMapNew = (Map<Id, Account>) Trigger.newMap;
    }

    // 로직은 ServiceLayer에 위임 (얇은 브로커)
    public override void beforeInsert() {
        AccountServiceLayer.incrementCounterInDescription(this.triggerNew, false);
    }

    public override void afterInsert() {
        AccountServiceLayer.changeShippingStreet(this.triggerNew, AccessLevel.SYSTEM_MODE);
    }

    // 간단한 유효성 검사는 핸들러 직접
    public override void beforeUpdate() {
        for (Account acct : this.triggerNew) {
            if (acct.ShippingState?.length() > 2) {
                acct.addError('Shipping State 최대 2자리');
            }
        }
    }
}
```

---

## 트리거 파일 (단 1줄)

```apex
// AccountTrigger.trigger
trigger AccountTrigger on Account (
    before insert, before update, before delete,
    after insert, after update, after delete, after undelete
) {
    new AccountTriggerHandler().run();
}
```

---

## bypass 패턴 (테스트/통합에서 특정 핸들러 비활성화)

```apex
// 테스트에서 다른 핸들러 비활성화
TriggerHandler.bypass('AccountTriggerHandler');
// ... DML 수행 ...
TriggerHandler.clearBypass('AccountTriggerHandler');

// 통합 사용자가 실행할 때 특정 핸들러 비활성화 → CMDT 방식 권장
// → [[CMDT 메타데이터 트리거]] 참조
```

---

## 핵심 규칙

> [!note] 브로커 원칙
> 핸들러는 **얇은 브로커**로 유지한다. 비즈니스 로직은 ServiceLayer 클래스에 위임한다.

> [!note] 루프 방지
> 재귀 트리거 위험이 있다면 `setMaxLoopCount(1)`로 한 번만 실행되도록 제한한다. 프레임워크 없이 static 변수로 막는 방법은 [[Trigger 재귀 방지]] 참조.

---

## 관련 노트

- [[CMDT 메타데이터 트리거]]
- [[서비스 레이어 패턴]]
- [[Trigger 컨텍스트 변수와 이벤트]] — `switch on Trigger.operationType`이 쓰는 TriggerOperation enum·컨텍스트 변수 레퍼런스
- [[Trigger Order of Execution]] — 핸들러가 어느 save 단계에서 실행되는지(before/after 트리거 위치)
- [[Trigger 재귀 방지]] — `setMaxLoopCount` 외 static 변수 가드 방식
- [[Apex Best Practices]] — 객체당 단일 트리거 + 트리거에 비즈니스 로직 금지 원칙
- [[Trigger 벌크 관용구·미발생 작업·예외]] — 핸들러가 구현해야 할 벌크 관용구·`addError()` 예외 처리 패턴
