---
tags: [agent-skill, sf-skills, reference, platform, debug, common-issues]
source: forcedotcom/sf-skills (skills/platform-apex-logs-debug/references/common-issues.md, 공식 Salesforce)
created: 2026-06-27
aliases: [Common Debug Log Issues, 흔한 디버그 로그 이슈, SOQL in loop, DML in loop, CPU 압박, 힙 압박, NPE]
---
# Common Debug Log Issues — 흔한 디버그 로그 이슈

> 디버그 로그에서 자주 나타나는 6가지 문제(루프 내 SOQL/DML, 비선택적 쿼리, CPU·힙 압박, 미처리 예외)의 신호(Signals)와 수정 패턴.

## SOQL in loop

**Signals**
- repeating `SOQL_EXECUTE_BEGIN`
- query appears inside repeated method path

**Fix pattern**
- query once outside the loop
- use `Map<Id, SObject>` or grouped collections

```apex
// 구조 예시 — 실제 동작 코드 아님 (SOQL-in-loop 수정 패턴 도해)
Map<Id, Account> accMap = new Map<Id, Account>(
    [SELECT Id, Name FROM Account WHERE Id IN :accountIds]  // query once
);
for (Contact c : Trigger.new) {
    Account a = accMap.get(c.AccountId);  // O(1) Map lookup, no query in loop
}
```

## DML in loop

**Signals**
- repeated `DML_BEGIN`
- high DML statement count for small transactions

**Fix pattern**
- collect changes
- do one bulk DML operation

## Non-selective query

**Signals**
- high rows scanned
- slow query timing
- table-scan indicators

**Fix pattern**
- add indexed filters
- reduce scope
- use query-plan guidance

## CPU pressure

**Signals**
- CPU usage trending toward sync limit
- repeated expensive helper methods
- nested loops / repeated string work

**Fix pattern**
- reduce algorithmic complexity
- cache repeated work
- move heavy processing async where appropriate

## Heap pressure

**Signals**
- large collection allocations
- heap usage approaching sync limit

**Fix pattern**
- use SOQL for-loops
- reduce in-memory object size
- clear collections when done

## Null pointer / unhandled exceptions

**Signals**
- `EXCEPTION_THROWN`
- `FATAL_ERROR`
- clear stack trace with line numbers

**Fix pattern**
- guard null values
- make assumptions explicit
- improve result handling for empty query results

## 관련 노트
- [[platform-apex-logs-debug]]
- [[debug-log-reference]]
- [[analysis-playbook]]
