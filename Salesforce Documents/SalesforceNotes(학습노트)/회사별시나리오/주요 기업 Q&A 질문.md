---
tags: [scenario, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
updated: 2026-06-14
aliases: [Top Companies Interview Questions]
---

# 주요 기업 Q&A 질문

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 답변은 표준 Salesforce 기능 기준으로 작성했으나, 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

> 형식: 굵은 줄 = **질문**, `- **A:**` = 답변.

---

## INFOSYS

**1. 인시던트 이슈 처리 시 겪은 어려움?**
- **A:** (경험형) 근본 원인 분석(디버그 로그·재현), 우선순위 판단, 임시 회피책 vs 영구 수정 분리, 이해관계자 커뮤니케이션을 축으로 답한다.

**2. Batch Apex란?**
- **A:** `Database.Batchable` 인터페이스를 구현해 대용량 레코드를 청크(기본 200건) 단위로 **비동기** 처리하는 방식. 거버너 한도가 청크마다 리셋되어 수백만 건 처리에 적합.

**3. Batch Apex의 인터페이스?**
- **A:** `Database.Batchable<sObject>` — `start(Database.BatchableContext)` (QueryLocator/Iterable 반환), `execute(context, List<sObject> scope)`, `finish(context)`. 옵션 인터페이스: `Database.Stateful`(상태 유지), `Database.AllowsCallouts`(콜아웃 허용).

**4. Test.startTest(), Test.stopTest()이란?**
- **A:** 테스트 내에서 호출하면 그 사이 코드에 **새 거버너 한도 컨텍스트**가 적용된다. `stopTest()` 시점에 큐에 쌓인 비동기 작업(future·queueable·batch)이 **동기적으로 실행 완료**되어 결과를 검증할 수 있다.

**5. 테스트 클래스가 필요한 이유?**
- **A:** 프로덕션 배포에 조직 전체 **최소 75% 코드 커버리지**가 필수이며, 회귀 방지·동작 검증 목적. 모든 트리거는 일부 커버리지가 있어야 한다.

**6. System.runAs()란?**
- **A:** 테스트 코드에서 특정 사용자의 **권한·공유·역할 컨텍스트**로 코드를 실행하는 것처럼 시뮬레이션. 테스트 메서드에서만 사용 가능하며, 실제 권한이 강제되지는 않고 데이터 가시성·CRUD를 확인하는 용도.

**7. 이전 경험·역할?**
- **A:** (경험형) 담당 모듈, 사용 기술(Apex/LWC/Flow), 팀 내 역할 중심으로 답한다.

**8. 고객에게 이메일 보내는 Lightning Flow 생성 방법?**
- **A:** Record-Triggered 또는 Screen Flow에서 **Action → Send Email**(또는 Email Alert)을 추가해 수신자·템플릿·본문을 지정. 기준 충족 시(예: 레코드 생성) 자동 발송.

**9. 동시에 실행 가능한 배치 수?**
- **A:** 동시에 **5개**의 배치 잡이 실행/큐 대기 가능. Apex Flex Queue에는 최대 100개까지 Holding 상태로 대기시킬 수 있다.

**10. Batch Apex가 한 번에 처리하는 레코드 수?**
- **A:** `execute` 메서드당 기본 **200건**. `Database.executeBatch(batch, scopeSize)`로 1~2000 사이 지정 가능.

**11. 트리거 시나리오: Account의 'Number of Location' 필드 값에 따라 레코드 생성하는 트리거**
- **A:** `after insert`에서 `Number_of_Location__c` 값만큼 자식 레코드를 만들어 **벌크 insert**.
```apex
// 구조 예시 — 실제 동작 코드 아님
trigger CreateLocations on Account (after insert) {
    List<Location__c> toCreate = new List<Location__c>();
    for (Account a : Trigger.new) {
        Integer n = (a.Number_of_Location__c == null) ? 0 : a.Number_of_Location__c.intValue();
        for (Integer i = 0; i < n; i++) {
            toCreate.add(new Location__c(Account__c = a.Id, Name = a.Name + ' Loc ' + (i+1)));
        }
    }
    if (!toCreate.isEmpty()) insert toCreate;  // 루프 밖 단일 DML
}
```

---

## DELOITTE

**1. Sharing Rules란?**
- **A:** OWD(조직 전체 기본값)가 제한적일 때 특정 역할·그룹·기준에 맞는 레코드 접근을 **확장**(Read 또는 Read/Edit)하는 선언적 규칙. 접근을 줄이지는 못한다.

**2. Sharing Rules 설명**
- **A:** 두 종류 — **Owner-based**(특정 소유자 그룹의 레코드를 다른 그룹에 공유), **Criteria-based**(필드 값 기준 레코드를 공유). 평가는 자동 재계산된다.

**3. 시나리오: 한 프로필에 사용자 3명(A=Manager, B, C). B·C는 서로 레코드 못 보게, A는 B·C 레코드 볼 수 있게**
- **A:** 프로필은 동일해도 **Role Hierarchy**로 해결. OWD를 **Private**로 두고 A를 B·C의 **상위 역할**에 배치 → A는 하위(B·C) 레코드를 자동으로 봄, B·C는 동일 레벨이라 서로 못 봄. (가시성은 프로필이 아니라 역할·공유가 결정.)

**4. Custom Label이란?**
- **A:** 런타임 텍스트(메시지·라벨)를 코드 밖으로 외부화해 **번역·재사용**하게 하는 것. Apex·LWC·Aura·VF에서 참조. 조직당 최대 5,000개.

**5. Custom Settings & Metadata란?**
- **A:** **Custom Settings**: 애플리케이션 구성 데이터를 캐시(SOQL 없이 접근), List형·Hierarchy형(프로필/사용자별 오버라이드). **Custom Metadata Types**: 메타데이터로 취급되어 **패키지·배포 가능**한 레코드(환경 간 이관에 적합).

**6. 트리거 이벤트?**
- **A:** `before insert`, `before update`, `before delete`, `after insert`, `after update`, `after delete`, `after undelete`.

**7. 보안 모듈?**
- **A:** OWD, Role Hierarchy, Sharing Rules, Manual/Apex Sharing (레코드 레벨) + Profiles·Permission Sets·Object 권한·FLS (객체/필드 레벨).

**8. seeAllData==true/false?**
- **A:** `@isTest(SeeAllData=true)`면 테스트가 조직의 **실제 데이터**에 접근. 기본값(false)이면 테스트에서 만든 데이터만 보이며 격리가 보장된다.

**9. 트리거 시나리오: 아래 코드가 오류 없이 실행되는가?**
```apex
trigger BillingCityUpdate on Account (after insert) {
    List<Account> newAccounts = new List<Account>();
    for (Account acc : trigger.new) {
        acc.BillingCity = 'Hyderabad';
        acc.BillingState = 'Telangana';
        newAccounts.add(acc);
    }
    if (newAccounts.size() > 0) insert newAccounts;
}
```
> 답: after insert에서 trigger.new 레코드를 다시 insert하려 하면 읽기 전용 오류 또는 재귀/중복 삽입 문제 발생. before insert에서 필드 설정이 올바른 패턴.

---

## SALESFORCE

**1. Assignment Rules란?**
- **A:** Lead·Case를 기준에 따라 자동으로 사용자나 큐에 **배정**하는 규칙. 순서대로 평가되어 첫 일치 규칙이 적용.

**2. Sharing Rules와 종류?**
- **A:** Owner-based, Criteria-based 두 종류 (위 DELOITTE 2번 참조).

**3. Salesforce 관계?**
- **A:** **Lookup**(느슨, 선택적), **Master-Detail**(소유권·롤업·캐스케이드 삭제), **Many-to-Many**(Junction 오브젝트 + MD 2개), **Hierarchical**(User 객체 전용 self-lookup), **External Lookup**(외부 오브젝트).

**4. Apex 클래스 디버그 방법?**
- **A:** **Debug Logs**(Setup), `System.debug()`, **Developer Console**(로그·체크포인트·실행 익명), Apex Replay Debugger(VS Code).

**5. Annual Revenue > 50000 레코드 조회 SOQL**
- **A:** `SELECT Id, Name, AnnualRevenue FROM Account WHERE AnnualRevenue > 50000`

**6. Apex 클래스 작성**
- **A:** 예시 — 계산 메서드를 가진 단순 클래스.
```apex
// 구조 예시 — 실제 동작 코드 아님
public with sharing class TaxCalculator {
    public static Decimal applyTax(Decimal amount, Decimal rate) {
        return amount + (amount * rate / 100);
    }
}
```

**7. Lightning Flow 디버그 방법?**
- **A:** Flow Builder의 **Debug** 버튼으로 입력값을 지정해 실행, 각 요소 경로·변수 값을 확인. **Fault Path**를 추가해 오류 처리. Flow 인터뷰 로그도 확인 가능.

**8. 다른 사용자가 Flow에 접근 못 하게 제한?**
- **A:** Flow의 **Override default behavior** 또는 Profile/Permission Set의 **Flow access**, "Run Flows" 권한으로 제어. Screen Flow를 특정 권한 세트에만 부여.

**9. Batch 클래스 테스트 클래스 작성?**
- **A:** 테스트 데이터 생성 → `Test.startTest()` → `Database.executeBatch(new MyBatch())` → `Test.stopTest()`(이 시점에 배치가 동기 실행) → 결과 검증.

**10. 에스컬레이션 규칙 생성?**
- **A:** Setup → **Case Escalation Rules** → 기준(예: Age > 48h, 상태) + **Business Hours** 기반 에스컬레이션 액션(소유자 변경·알림) 설정.

**11. Batch 실행 중 1건 미처리. 가능성은?**
- **A:** 해당 청크(200건)에서 예외 발생 시 그 **청크 전체가 롤백**되거나, validation rule·required 필드·거버너 한도 위반·`Database.insert(list, false)`의 부분 실패 때문. `Database.RaisesPlatformEvents`나 finish에서 에러 수집으로 진단.

**12. Admin·Developer 자기 평가?**
- **A:** (경험형) 자신 있는 영역·자격증·실무 경험으로 답한다.

**13. 우선순위 티켓 작업 중 매니저가 긴급 티켓 할당 시 무엇 먼저?**
- **A:** (상황형) 긴급 티켓 우선 처리, 단 진행 중 작업 상태를 저장·기록하고 매니저와 우선순위를 명확히 합의. SLA·영향 범위로 판단.

**14. 트리거 시나리오: User가 레코드 수정 시 User Name으로 Description 채우기**
- **A:** `before update`에서 현재 사용자 이름을 Description에 설정.
```apex
// 구조 예시 — 실제 동작 코드 아님
trigger StampUser on Account (before update) {
    for (Account a : Trigger.new) {
        a.Description = '최종 수정: ' + UserInfo.getName();
    }
}
```

**15. 시나리오: Batch 처리 중 1건 미처리. 이유·가능성?**
- **A:** 11번과 동일 — 예외에 의한 청크 롤백, validation·한도 위반, 부분 성공 처리 미흡.

**16. 클라이언트 이슈 디버그 방법? 클래스가 예상대로 안 됨?**
- **A:** 디버그 로그로 입력·분기 추적, 격리된 데이터로 재현, `System.debug` 추가, 거버너 한도·null·벌크 시나리오 점검.

---

## TECHMATRIX

**1. Multitenancy란?**
- **A:** 단일 하드웨어·코드베이스를 다수 고객(tenant)이 **공유**하면서, 메타데이터 기반으로 데이터·구성이 논리적으로 격리되는 아키텍처. 거버너 한도가 이 공유 자원을 보호한다.

**2. Profile vs Role 차이?**
- **A:** **Profile** = 객체/필드 권한(CRUD·FLS)·앱·탭 등 "무엇을 할 수 있나"(필수). **Role** = 레코드 가시성을 결정하는 **공유 계층**상의 위치, "누구의 레코드를 보나"(선택).

**3. Process Builder vs Workflow vs Flow 차이?**
- **A:** **Workflow**(단순 — 필드 업데이트·이메일·태스크, 단일 if-then), **Process Builder**(다중 액션·다중 기준, 현재 deprecated), **Flow**(가장 강력 — 화면·스케줄·레코드 트리거·반복·콜아웃, **현재 권장**되는 자동화 도구).

**4. 거버너 한도?**
- **A:** 멀티테넌트 자원 보호 한도 — SOQL 100건(동기)/200(비동기), DML 150 statements, CPU 시간 10초(동기), heap 6MB(동기)/12MB(비동기), 콜아웃 100건 등.

**5. 실행 순서?**
- **A:** 시스템 검증 → **before 트리거** → 커스텀 검증(validation rule) → **after 트리거** → assignment/auto-response 규칙 → workflow 규칙(재실행 가능) → 에스컬레이션 → roll-up summary → commit → post-commit(이메일·async).

**6. 인터페이스란? 만든 적 있나?**
- **A:** 메서드 시그니처 계약. Salesforce 시스템 인터페이스: `Database.Batchable`, `Schedulable`, `Queueable`, `Comparable`, `Database.AllowsCallouts` 등. 구현 클래스가 메서드를 정의.

**7. Batch Apex에서 Future 호출 방법?**
- **A:** 배치에서 `@future`는 **직접 호출 불가**(이미 비동기 컨텍스트). 대신 **Queueable**을 enqueue하거나 후속 처리를 finish 메서드에서 체이닝한다.

**8. Queue vs Public Group 차이?**
- **A:** **Queue** = 레코드(Case·Lead·커스텀)를 **소유**하고 작업을 분배하는 대상. **Public Group** = 공유 규칙·권한 부여에 쓰는 **사용자 집합**(레코드를 소유하지 않음).

**9. 트리거 시나리오: 메인 Contact 수정 시 관련 Contact Description 업데이트**
- **A:** 메인 Contact의 변경을 감지해 같은 Account의 다른 Contact를 벌크 업데이트.
```apex
// 구조 예시 — 실제 동작 코드 아님
trigger SyncContactDesc on Contact (after update) {
    Set<Id> acctIds = new Set<Id>();
    for (Contact c : Trigger.new) acctIds.add(c.AccountId);
    List<Contact> related = [SELECT Id, Description FROM Contact WHERE AccountId IN :acctIds];
    for (Contact c : related) c.Description = '메인 연락처 업데이트됨';
    update related;  // 재귀 방지를 위해 static 플래그 권장
}
```

---

## CAPGEMINI

**1. Cascade 삭제란?**
- **A:** **Master-Detail** 관계에서 부모 레코드를 삭제하면 자식 레코드가 **자동으로 함께 삭제**되는 동작.

**2. 동기·비동기?**
- **A:** **동기** = 한 트랜잭션에서 즉시 순차 실행, 호출자가 완료를 기다림. **비동기** = 별도 컨텍스트에서 나중에 실행(future·Queueable·Batch·Scheduled·Platform Events), 더 높은 한도·콜아웃 분리.

**3. 관계 없는 2개 오브젝트에 Master-Detail 관계 생성 방법?**
- **A:** 자식에 레코드가 없으면 직접 MD 필드 생성 가능. 이미 자식 레코드가 있으면 ① **Lookup**으로 먼저 생성 → ② 모든 자식 레코드에 부모를 채움(필수값) → ③ Lookup을 **Master-Detail로 변환**.

**4. Batch Apex에서 Future 호출 방법?**
- **A:** 직접 불가(비동기에서 비동기 금지). **Queueable**을 enqueue해 대체. (TECHMATRIX 7번 참조.)

**5. 시나리오: Batch 실행 중 실패·성공 레코드 ID 얻기?**
- **A:** `execute`에서 `Database.insert(list, false)`의 `Database.SaveResult[]`로 레코드별 성공/실패·ID·에러를 수집(`Database.Stateful`로 누적). finish에서 `AsyncApexJob`(NumberOfErrors·JobItemsProcessed) 조회로 집계.

**6. 트리거 이벤트**
- **A:** before/after insert·update·delete, after undelete (DELOITTE 6번 참조).

**7. 트리거 컨텍스트 변수?**
- **A:** `Trigger.new`, `Trigger.old`, `Trigger.newMap`, `Trigger.oldMap`, `Trigger.isInsert/isUpdate/isDelete/isUndelete`, `Trigger.isBefore/isAfter`, `Trigger.isExecuting`, `Trigger.size`.

**8. Web-to-Case 설명?**
- **A:** 웹사이트의 HTML 폼 제출을 Salesforce가 받아 **Case를 자동 생성**하는 기능. Web-to-Lead와 유사. 일일 생성 한도·스팸 방지(reCAPTCHA) 고려.

**9. 비동기 유형?**
- **A:** **Future**(`@future`), **Queueable Apex**, **Batch Apex**, **Scheduled Apex**, **Platform Events**(이벤트 기반 비동기).
