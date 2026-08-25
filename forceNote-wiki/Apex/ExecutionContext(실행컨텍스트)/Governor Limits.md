---
tags: [apex, governor-limits, execution-context, limits, performance, soql, dml, email-limits, push-notification, elastic-limits, winter-27]
source: developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_gov_limits.htm (Apex Developer Guide v67.0, Summer '26); Salesforce Documents/salesforce_app_limits_cheatsheet.pdf (Developer Limits and Allocations Quick Reference, Last updated May 8 2026 판 p.1-8 Apex Governor Limits 4개 표 — heap 6/12 MB·DailyAsyncApexElasticExecutions 1천만 캡 등 종전 값); Salesforce Documents/Winter27-v68-Docs/salesforce_app_limits_cheatsheet.pdf (같은 치트시트 Last updated August 14 2026 판, Winter '27 문서 경로 release=264 배포본 — 버전 표기 없음·Apex 한도 표 미수록); help.salesforce.com Winter '27 릴리즈 노트 (rn_apex_heap_limit · rn_apex_elastic_limits_batch · rn_apex_elastic_limits_test_nonprod)
created: 2026-05-19
aliases: [Governor Limits, 거버너 한도, 실행 한도, SOQL 한도, DML 한도, Heap 한도, CPU 한도, Limits 클래스, 거버너 리밋, 이메일 한도, Elastic Limits, elastic limits beta, heap 10MB, heap 25MB, DailyAsyncApexElasticExecutions, 비동기 잡 한도 override]
---

# Governor Limits — Apex 실행 한도

> Salesforce 멀티테넌트 플랫폼에서 자원 독점을 막기 위해 Apex 런타임이 강제하는 실행 한도. 한도 초과 시 처리 불가능한 런타임 예외가 발생한다.

---

## 개요

Apex는 Salesforce 멀티테넌트 서버에서 실행된다. 런타임 엔진이 *governors*(거버너)를 통해 한도를 강제 적용하여, Runaway Apex 코드나 프로세스가 공유 자원을 독점하지 못하게 한다.

어떤 Apex 코드가 한도를 초과하면, 해당 거버너는 **처리할 수 없는(can't be handled) 런타임 예외**를 발생시킨다.

한도 대부분은 **트랜잭션 단위**로 적용되며, 일부(예: 24시간 비동기 실행 한도)는 트랜잭션에 묶이지 않는다. Batch Apex의 경우 `execute` 메서드의 각 배치 실행마다 Per-Transaction 한도가 초기화된다.

**Apex 트랜잭션 경계:** trigger, 클래스 메서드, 익명 코드 블록, Visualforce 페이지, 커스텀 Web Service 메서드

---

## Winter '27 한도 변경 — before / after

Winter '27 릴리즈 노트가 예고한 Apex 한도 변경. 아래 값은 이 노트의 각 표에 이미 반영돼 있고, 변경 배경·설정 절차 원문은 [[Winter '27/Development]]에 있다.

| 한도 | 이전 (Summer '26) | Winter '27 | 상태 | 소스 |
|---|---|---|---|---|
| Heap size — **동기** 트랜잭션 | 6 MB | **10 MB** | 전 org 자동 적용 (Winter '27 릴리즈 일정) | `rn_apex_heap_limit` |
| Heap size — **비동기** 트랜잭션 | 12 MB | **25 MB** | 전 org 자동 적용 (Winter '27 릴리즈 일정) | `rn_apex_heap_limit` |
| Elastic Limits 적용 대상 | future 메서드 · Queueable | future 메서드 · Queueable · **Batch 잡** | **Beta** | `rn_apex_elastic_limits_batch` |
| 프로덕션 elastic 한도의 **추가 용량 캡** | 10,000,000 잡 | **min(라이선스된 비동기 Apex 잡 한도, 2,000,000 잡)** | **Beta** — 캡이 **내려갔다**(↓) | `rn_apex_elastic_limits_batch` |
| 비프로덕션 org 비동기 Apex 잡 한도 override | 없음 (elastic limits는 프로덕션·데모 org 전용이었음) | **override 설정 가능** — 예: 표준 250,000 / override 250 → elastic 한도 500 | 일반 기능 (Beta인 Elastic Limits를 시험하기 위한 도구) | `rn_apex_elastic_limits_test_nonprod` |

> [!warning] 소스 상태 — 한도 치트시트에는 아직 반영되지 않았다
> 위 변경의 출처는 **Winter '27 릴리즈 노트**뿐이다. Winter '27 문서 경로(`release=264`)에서 받은 `salesforce_app_limits_cheatsheet.pdf`(**Last updated: August 14, 2026**, 15p)에는 **Apex Governor Limits 표 자체가 없다** — 첫 장(p.1)에 "Execution Governors and Limits" 문서로 넘기는 안내 링크 1줄과 설명 문단 2개만 남아 있고, 직전 판(**Last updated: May 8, 2026**, 23p)에 있던 Per-Transaction(p.1~4) · Platform(p.5~7) · Static(p.7~8) · Size-Specific(p.8~) Apex 한도 표가 통째로 빠졌다. 따라서 heap 10/25 MB도, elastic 추가 용량 200만 캡도 **치트시트로는 교차 검증할 수 없다**(치트시트 미수록 ≠ 반박). 이 노트의 Apex 한도 표 수치는 Apex Developer Guide + May 8 2026 판 치트시트가 근거이고, 변경분만 릴리즈 노트가 근거다.
> **판본 표기 주의:** 8월 14일 판 치트시트에는 `Version 68.0, Winter '27` 같은 **버전 문자열이 인쇄돼 있지 않다.** 표지에 릴리즈 프리뷰 고지(*"This release is in preview…"* — 5월 8일 판에는 없던 문구)와 갱신일만 있으므로, 이 문서를 "v68판"이라고 단정하지 않는다.
> **Beta 주의:** Elastic Limits는 **Beta**다(Beta Services Terms 적용, 제공 보장 없음). 운영 용량 계획을 elastic 한도에 기대어 세우지 않는다.

---

## Per-Transaction Apex Limits

> **참고:** Scheduled Apex는 비동기 기능이지만, 동기 한도가 적용된다.
>
> **참고:** Bulk API / Bulk API 2.0 트랜잭션의 경우, 동기/비동기 한도 중 높은 쪽이 적용된다.

| 항목 | 동기 한도 | 비동기 한도 |
|---|---|---|
| SOQL 쿼리 수 | **100** | **200** |
| SOQL 조회 레코드 수 | 50,000 | 50,000 |
| `Database.getQueryLocator` 레코드 수 | 10,000 | 10,000 |
| SOSL 쿼리 수 | 20 | 20 |
| 단일 SOSL 쿼리 결과 레코드 수 | 2,000 | 2,000 |
| DML 문 수 | **150** | **150** |
| DML 처리 레코드 수 (`Approval.process`, `database.emptyRecycleBin` 포함) | 10,000 | 10,000 |
| 트리거 재귀 스택 깊이 (insert/update/delete) | 16 | 16 |
| Callout 수 (HTTP 요청 / 웹 서비스 호출) | 100 | 100 |
| Callout 누적 타임아웃 | 120초 | 120초 |
| `@future` 메서드 수 | 50 | 0 (batch/future), 50 (queueable) |
| `System.enqueueJob` 대기열 추가 수 | **50** | **1** |
| `sendEmail` 메서드 수 | 10 | 10 |
| Heap size (Winter '27 인상 — 표 아래 주 참조) | **10 MB** | **25 MB** |
| CPU time (Salesforce 서버) | **10,000 ms** | **60,000 ms** |
| 트랜잭션 최대 실행 시간 | 10분 | 10분 |
| Push notification 메서드 호출 수 | 10 | 10 |
| Push notification 건당 최대 발송 수 | 2,000 | 2,000 |
| `EventBus.publish` (즉시 발행 이벤트) | 150 | 150 |
| Apex cursors 총 rows (트랜잭션 당) | 50 million | 50 million |
| Apex cursors 일일 한도 | 10,000 | 10,000 |
| `Cursor.fetch` 호출 수 | 100 | 100 |
| Cursor rows 누적 (신규+페이지네이션, 24시간) | 100 million | 100 million |
| Apex Pagination Cursor 총 rows (트랜잭션 당) | 100,000 | 100,000 |
| Apex Pagination Cursor 인스턴스 수 (트랜잭션 당) | 50 | 50 |
| Apex Pagination Cursor 인스턴스 수 (24시간) | 200,000 | 200,000 |
| Pagination Cursor 페이지당 rows | 2,000 | 2,000 |

> **Heap size — Winter '27 인상 (`rn_apex_heap_limit`):** 동기 6 MB → **10 MB**, 비동기 12 MB → **25 MB**. Winter '27 릴리즈 일정에 따라 커스텀·관리형 Apex를 실행하는 **모든 에디션의 org에 자동 적용**된다. 단 Winter '27 **비프로덕션 org**(샌드박스 · Developer Edition · 스크래치 org)에 한해 Setup → Quick Find `Apex Settings` → **"Enforce the Summer '26 Apex heap limit"** 를 켜면 구 한도(6 / 12 MB)로 되돌려, Summer '26 프로덕션에 배포할 코드가 낮은 한도에서도 통과하는지 검증할 수 있다. 이 설정은 **Winter '27 비프로덕션 org에서만** 제공되며 **Spring '27부터는 설정 상태와 무관하게 높은 한도가 전역 강제**된다. 실제 적용값은 `Limits.getLimitHeapSize()`로 확인한다.

**DML 문으로 카운트되는 메서드:**
`Approval.process`, `Database.convertLead`, `Database.emptyRecycleBin`, `Database.rollback`, `Database.setSavePoint`, `delete/Database.delete`, `insert/Database.insert`, `merge/Database.merge`, `undelete/Database.undelete`, `update/Database.update`, `upsert/Database.upsert`, `EventBus.publish` (커밋 후 발행 이벤트), `System.runAs`

**SOQL 쿼리로 카운트되는 메서드:**
`Database.countQuery`, `Database.countQueryWithBinds`, `Database.getQueryLocator`, `Database.getQueryLocatorWithBinds`, `Database.query`, `Database.queryWithBinds`

---

## Per-Transaction Certified Managed Package Limits

AppExchange 보안 리뷰를 통과한 Certified Managed Package는 자체 Per-Transaction 한도를 별도로 가진다.

**예시:** Certified Managed Package 설치 시, 해당 패키지 코드는 자체 150 DML 문 + org 네이티브 코드의 150 DML 문을 각각 사용 가능하다. 동일 트랜잭션에서 150개 이상의 DML이 가능해진다.

**Cross-Namespace 누적 한도 (여러 패키지 동시 사용):**

| 항목 | 누적 한도 |
|---|---|
| SOQL 쿼리 수 | 1,100 |
| `Database.getQueryLocator` 레코드 수 | 110,000 |
| SOSL 쿼리 수 | 220 |
| DML 문 수 | 1,650 |
| Callout 수 | 1,100 |
| `sendEmail` 수 | 110 |

> **참고:** Heap size, CPU time, 최대 트랜잭션 실행 시간, 최대 unique namespace 수는 전체 트랜잭션에 걸쳐 단일하게 적용된다 (certified managed package별 분리 없음).

---

## Salesforce Platform Apex Limits

트랜잭션에 귀속되지 않는 플랫폼 수준 한도.

| 항목 | 한도 |
|---|---|
| 일일 비동기 Apex 실행 수 (Batch, Future, Queueable, Scheduled) — `DailyAsyncApexExecutions` org 한도 | 250,000 또는 사용자 라이선스 수 × 200 중 큰 값 |
| 일일 enqueue 가능 Queueable + Future 실행 수 (throttled rate로 처리되는 elastic executions 포함, **Beta**) — `DailyAsyncApexElasticExecutions` org 한도 | 일일 비동기 Apex 실행 한도 + min(라이선스 기반 일일 비동기 한도, **2,000,000**) — 즉 elastic **추가분**은 최대 **200만** executions로 캡. **Winter '27에서 1천만 → 200만으로 축소(↓)** |
| 비프로덕션 org 비동기 Apex 잡 한도 override (Winter '27~, Elastic Limits 테스트용) — Setup `Apex Settings` / Metadata API `ApexSettings` | override 값이 표준 24시간 롤링 비동기 Apex 잡 한도를 대체(비우면 표준 한도). elastic 설정 ON이면 elastic 한도 = **min(override × 2, org의 라이선스된 표준 한도)** |
| 동시 장기실행 트랜잭션 (5초 초과, 동기) | licenses/100 비율 (최소 10, 최대 50) |
| 동시 스케줄 클래스 수 | 100 (Developer Edition: 5) |
| Batch flex queue Holding 상태 | 100 |
| 동시 활성 Batch jobs | 5 |
| Batch `start` 메서드 동시 실행 | 1 |
| 실행 중인 테스트에서 제출 가능한 Batch jobs | 5 |
| 테스트 클래스 큐 한도 (24시간, production) | max(500, 테스트 클래스 수 × 10) |
| 테스트 클래스 큐 한도 (24시간, sandbox/Developer Edition) | max(500, 테스트 클래스 수 × 20) |

> **Elastic Limits (Beta) — 용량 계획의 근거로 쓰지 않는다.**
> - **적용 범위:** Winter '27부터 future 메서드 · Queueable 잡에 더해 **Batch 잡**까지 확대(`rn_apex_elastic_limits_batch`). Setup → Apex Settings의 *"Use elastic limits for asynchronous Apex jobs (beta)"* 가 켜진 org에서만 동작하며, Lightning Experience · Salesforce Classic의 **Enterprise · Performance · Unlimited · Developer** 에디션이 대상이다.
> - **프로덕션 산식:** elastic 한도 = 24시간 롤링 비동기 Apex 한도 + **추가 용량**, 추가 용량 = min(라이선스된 비동기 Apex 잡 한도, **2,000,000 잡**). 이전 캡은 10,000,000 잡이었으므로 이 값은 **완화가 아니라 축소**다.
> - **초과 시 동작:** 표준 한도를 넘기면 진행 중인 Batch 잡의 처리 속도가 스로틀링되고, **신규 Batch 잡은 동시 1개**로 제한된다(정상 시 동시 활성 Batch 잡 5개).
> - **비프로덕션 테스트(`rn_apex_elastic_limits_test_nonprod`):** 샌드박스 · Developer Edition · 스크래치 org에서 override를 표준보다 낮게 잡으면 탄력 처리가 더 일찍 촉발된다. 예) 표준 한도 250,000 잡 / override 250 잡 → elastic 한도 **500 잡**. override는 elastic 설정 on/off와 **무관하게** 적용되므로, 탄력 동작을 관찰하려면 **설정 ON + override < 라이선스 표준 한도**가 둘 다 필요하다. override를 비우면 한도가 250,000으로 유지돼 탄력 동작이 아니라 표준 한도 예외가 발생한다.
> - **사용량 확인:** Winter '27 릴리즈 노트는 *"use methods from the `OrgLimits` class"* 라고만 안내한다. 개별 OrgLimit 인스턴스(`DailyAsyncApexExecutions` · `DailyAsyncApexElasticExecutions` · `DailyAsyncApexProcessed`, **API v67.0 이상**)와 Apex Jobs 페이지 배너는 Summer '26 릴리즈 노트가 출처다 — [[Summer '26/Development]] 참조. 치트시트(May 8 2026 판 p.7)는 `OrgLimits.getAll()` / `OrgLimits.getMap()` 또는 REST API `limits` 리소스를 안내한다.
> - **종전 캡 1천만의 근거:** 치트시트 May 8 2026 판 p.5~6 *Salesforce Platform Apex Limits* 표 — *"…or 10 million executions, whichever is less."*
> - 설정 절차·릴리즈 노트 원문은 [[Winter '27/Development]] 참조.

---

## Static Apex Limits

특정 트랜잭션이 아닌 정적으로 적용되는 한도.

| 항목 | 한도 |
|---|---|
| Callout 기본 타임아웃 | 10초 |
| Callout 요청/응답 최대 크기 | 동기 6 MB, 비동기 12 MB (표 아래 주 참조) |
| SOQL query run time | 120초 (초과 시 트랜잭션 취소) |
| 배포 당 Apex 클래스/트리거 최대 수 | 7,500 |
| Apex 트리거 배치 크기 | **200** (PE/CDC 이벤트: 2,000) |
| for 루프 배치 크기 | 200 |
| `Database.QueryLocator` 최대 레코드 수 | 50 million |

> **Callout 크기와 heap의 관계 — 함께 오르지 않았다.** callout 요청/응답 크기는 heap에 합산된다(치트시트 May 8 2026 판 — 한도 행은 p.7 Static Apex Limits 표, 각주 1은 p.8: *"The HTTP request and response sizes count towards the total heap size."*). 그러나 **Winter '27 릴리즈 노트(`rn_apex_heap_limit`)는 heap 한도 인상만 밝혔을 뿐 callout 요청/응답 크기 한도(동기 6 MB / 비동기 12 MB)의 변경은 언급하지 않았고**, August 14 2026 판 치트시트에는 Apex 한도 표가 없어 대조할 수도 없다. 따라서 이 행은 확인된 종전 값을 그대로 둔다 — heap이 올랐다고 callout 크기 한도도 올랐다고 가정하지 않는다.

---

## Size-Specific Apex Limits

| 항목 | 한도 |
|---|---|
| 클래스 최대 문자 수 | 1 million |
| 트리거 최대 문자 수 | 1 million |
| Org 전체 Apex 코드 크기 | 6 MB (support case로 증설 가능) |
| Method size | 65,535 bytecode instructions (compiled) |

---

## Limits 클래스 사용법

```apex
// 현재 트랜잭션에서 사용된 SOQL 쿼리 수와 남은 한도 확인
Integer queriesUsed  = Limits.getQueries();          // 현재까지 사용된 SOQL 수
Integer queriesLimit = Limits.getLimitQueries();     // 허용된 총 SOQL 수
Integer queriesLeft  = queriesLimit - queriesUsed;

System.debug('SOQL: ' + queriesUsed + '/' + queriesLimit + ' (남은: ' + queriesLeft + ')');
```

```apex
// 주요 Limits 메서드 목록
Limits.getQueries()                  // 현재 SOQL 쿼리 수
Limits.getLimitQueries()             // 최대 허용 SOQL 수 (sync: 100, async: 200)

Limits.getDmlStatements()            // 현재 DML 문 수
Limits.getLimitDmlStatements()       // 최대 허용 DML 수 (150)

Limits.getDmlRows()                  // 현재 DML 처리 레코드 수
Limits.getLimitDmlRows()             // 최대 허용 DML 레코드 수 (10,000)

Limits.getQueryRows()                // 현재 SOQL 조회 레코드 수
Limits.getLimitQueryRows()           // 최대 허용 SOQL 레코드 수 (50,000)

Limits.getCallouts()                 // 현재 Callout 수
Limits.getLimitCallouts()            // 최대 허용 Callout 수 (100)

Limits.getHeapSize()                 // 현재 힙 크기 (bytes)
Limits.getLimitHeapSize()            // 최대 허용 힙 크기 (Winter '27~ sync: 10MB, async: 25MB / 이전 6MB·12MB)

Limits.getCpuTime()                  // 현재 CPU 사용량 (ms)
Limits.getLimitCpuTime()             // 최대 허용 CPU (sync: 10,000ms, async: 60,000ms)
```

```apex
// 구조 예시 — 실제 동작 코드 아님
// 한도 안전 체크 후 DML 실행 패턴
public void safeBulkInsert(List<SObject> records) {
    Integer remaining = Limits.getLimitDmlStatements() - Limits.getDmlStatements();
    if (remaining > 0) {
        insert records;
    } else {
        // 로그 또는 예외 처리
        throw new LimitException('DML 한도 초과 위험');
    }
}
```

---

## 한도 초과 방어 패턴

### 1. Bulkify DML — 루프 내 DML 금지

```apex
// 비추천 — 루프 내 DML (150개 초과 시 런타임 예외)
for(Line_Item__c li : liList) {
    if (li.Units_Sold__c > 10) {
        li.Description__c = 'New description';
    }
    update li;  // 매 반복마다 DML 1회 소비
}

// 권장 — 리스트로 모아서 단 1번 DML
List<Line_Item__c> updatedList = new List<Line_Item__c>();
for(Line_Item__c li : liList) {
    if (li.Units_Sold__c > 10) {
        li.Description__c = 'New description';
        updatedList.add(li);
    }
}
update updatedList;  // DML 1회
```

### 2. Efficient SOQL — 루프 내 SOQL 금지

```apex
// 비추천 — Trigger.new 100개 이상이면 SOQL 한도(100) 초과
trigger LimitExample on Invoice_Statement__c (before insert, before update) {
    for(Invoice_Statement__c inv : Trigger.new) {
        List<Line_Item__c> liList = [SELECT Id, Units_Sold__c, Merchandise__c
                                     FROM Line_Item__c
                                     WHERE Invoice_Statement__c = :inv.Id];
        for(Line_Item__c li : liList) { /* 처리 */ }
    }
}

// 권장 — 중첩 쿼리로 단 1번의 SOQL
trigger EnhancedLimitExample on Invoice_Statement__c (before insert, before update) {
    List<Invoice_Statement__c> invoicesWithLineItems =
        [SELECT Id, Description__c,
                (SELECT Id, Units_Sold__c, Merchandise__c FROM Line_Items__r)
         FROM Invoice_Statement__c
         WHERE Id IN :Trigger.newMap.KeySet()];

    for(Invoice_Statement__c inv : invoicesWithLineItems) {
        for(Line_Item__c li : inv.Line_Items__r) { /* 처리 */ }
    }
}
```

### 3. SOQL for Loop — Heap 한도 방어

```apex
// 구조 예시 — 실제 동작 코드 아님
// 대용량 레코드 처리 시 for 루프로 heap 한도(동기 10MB — Winter '27 이전 6MB) 방어
// 200개씩 청크로 처리하므로 전체를 한 번에 List에 올리지 않음
for(Account a : [SELECT Id, Name FROM Account]) {
    // 처리 로직 — 200개씩 청크로 자동 분할
}
```

---

## 한도 초과 시 발생하는 예외

| 상황 | 발생하는 예외 / 메시지 |
|---|---|
| SOQL 한도 초과 | `System.LimitException: Too many SOQL queries: 101` |
| DML 한도 초과 | `System.LimitException: Too many DML statements: 151` |
| DML 레코드 한도 초과 | `System.LimitException: Too many DML rows: 10001` |
| Heap 한도 초과 | `System.LimitException: Apex heap size too large: ...` |
| CPU 한도 초과 | `System.LimitException: Maximum CPU time exceeded` |
| Callout 한도 초과 | `System.LimitException: Too many callouts: 101` |
| 일일 비동기 한도 초과 | `System.AsyncException: AsyncApexExecutions Limit exceeded` |

> `System.LimitException`은 `catch` 블록에서 잡을 수 없다. try-catch로 처리되지 않으며, 트랜잭션이 강제 롤백된다.

---

## 동기 vs 비동기 핵심 차이

| 컨텍스트 | SOQL | Heap | CPU | enqueueJob |
|---|---|---|---|---|
| **동기 (Sync)** | 100 | 10 MB | 10,000 ms | 50 |
| **비동기 (Async)** | 200 | 25 MB | 60,000 ms | 1 |
| **Scheduled** | 100 (동기 적용) | 10 MB (동기 적용) | 10,000 ms | 50 |

> Heap 값은 **Winter '27 인상 후** 기준이다(이전: 동기 6 MB · 비동기 12 MB). 비프로덕션 org에서 구 한도를 강제한 경우는 위 [Per-Transaction Apex Limits](#per-transaction-apex-limits)의 주 참조.

비동기 컨텍스트는 SOQL 2배, Heap **2.5배**(Winter '27 인상 전에는 2배), CPU 6배로 여유가 크다. 대용량 처리는 [[비동기 컨텍스트 선택]] 참조.

---

## Miscellaneous Apex Limits

### Connect in Apex (ConnectApi)

- ConnectApi 모든 **쓰기 작업**은 DML 문 1회로 카운트된다.
- ConnectApi 메서드 호출은 Salesforce Platform API 요청 할당(24시간 기준, org 단위)에도 포함된다.
- **Chatter 필요 메서드**는 사용자/네임스페이스/시간당 별도 Rate Limit 적용. 초과 시 `ConnectApi.RateLimitException` 발생 → 반드시 catch 처리.

### 테스트에서의 DML 한도 (MAX_DML_ROWS)

- 단일 동기 Apex 테스트 실행 컨텍스트에서 insert/update/delete 가능한 최대 rows: **450,000**
- 초과 시: `Your runallTests is consuming too many DB resources`

### 이메일 한도 (Email Limits)

#### 인바운드 이메일

| 항목 | 한도 |
|---|---|
| Email Services 일일 처리 최대 수 (On-Demand Email-to-Case 포함) | 사용자 라이선스 수 × 1,000 (최대 1,000,000) |
| Email Services 메시지 최대 크기 (본문 + 첨부) | 25 MB |
| On-Demand Email-to-Case 첨부 최대 크기 | 25 MB |

#### 아웃바운드 이메일 (Apex/API)

| 항목 | 한도 |
|---|---|
| 일일 외부 이메일 주소 발송 수 (single email) | 5,000 (Developer Edition: 50명/일, 수신자 당 최대 15명) |
| `SingleEmailMessage` To/CC/BCC 합산 최대 수신자 | 150명 (각 필드 4,000 bytes 제한) |
| 일일 mass/list email 외부 주소 발송 수 | 5,000 (Developer Edition: 10명/일) |
| 내부 사용자 발송 | 무제한 (일일 한도 미적용) |

> **팁:** `setTargetObjectId`로 내부 사용자 ID를 지정하면 일일 한도 미포함. `setToAddresses`로 이메일 주소를 지정하면 한도 포함.

### Push Notification 한도 (Org 수준)

| 항목 | 한도 |
|---|---|
| iOS push notification | 시간당 **20,000건** |
| Android push notification | 시간당 **10,000건** |
| 테스트 push notification | 수신자 1명 제한, org 시간당 한도에 포함 |

> 시간당 한도 초과 시에도 인앱 표시 및 REST API 조회용 알림은 계속 생성됨.

---

## 관련 노트

- [[Winter '27/Development]] — heap 한도 인상(6→10 / 12→25 MB) · Batch 잡 Elastic Limits(Beta) · 비프로덕션 잡 한도 override 릴리즈 노트 원문
- [[QuiddityGuard]] — 현재 실행 컨텍스트 판별 (동기/비동기/Batch 구분)
- [[OrgShape]] — Org 환경 정보 (isSandbox 등)
- [[비동기 컨텍스트 선택]] — @future vs Queueable vs Batch 결정 기준
- [[Batch Apex]] — 대용량 처리, execute 당 한도 초기화
- [[Queueable]] — enqueueJob 한도 (비동기: 1개)
- [[SOQL 패턴]] — WITH USER_MODE, SOQL for loop, 한도 방어
- [[DML 패턴]] — Bulkify DML, allOrNothing
- [[Apex 표준 클래스 레퍼런스]] — Limits 클래스 전체 메서드 목록
- [[TriggerHandler 패턴]] — 트리거에서 한도 방어 아키텍처
- [[Trigger Order of Execution]] — 재귀 save와 트리거 재귀 스택 깊이(16) 한도가 발생하는 저장 lifecycle
- [[Apex Debug Log]] — 디버그 로그의 LIMIT_USAGE 라인으로 한도 소비 추적
- [[Salesforce 한도·할당량 레퍼런스 (API·Bulk·Metadata·SOQL·VF)]] — 이 노트가 다루는 트랜잭션 거버너 한도와 별개인 org/플랫폼 레벨 정적 할당량(24시간 API 콜·Bulk·Metadata·SOQL/VF 한도)
- [[platform-apex-logs-debug]] (sf-skill — 실행형) — 디버그 로그의 LIMIT_USAGE로 거버너 한도 소비를 추적하는 실행형 스킬
