---
tags: [apex, trigger, pattern, architecture]
source: apex-recipes/TriggerHandler.cls, AccountTriggerHandler.cls
created: 2026-05-17
aliases: [트리거 핸들러, TriggerHandler]
---

# TriggerHandler 패턴

> 트리거 로직을 핸들러 클래스로 분리하는 표준 패턴. apex-recipes의 `TriggerHandler.cls`가 공식 구현.

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

    // 루프 방지 설정
    public void setMaxLoopCount(Integer max) { ... }

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
> 재귀 트리거 위험이 있다면 `setMaxLoopCount(1)`로 한 번만 실행되도록 제한한다.

---

## 관련 노트

- [[CMDT 메타데이터 트리거]]
- [[서비스 레이어 패턴]]
- [[Apex Best Practices]] — 객체당 단일 트리거 + 트리거에 비즈니스 로직 금지 원칙
