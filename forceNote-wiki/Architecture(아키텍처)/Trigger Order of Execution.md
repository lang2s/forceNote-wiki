---
tags: [apex, trigger, order-of-execution, save-order, lifecycle, workflow, flow, roll-up-summary, validation, architecture]
source: salesforce_apex_developer_guide.pdf (Apex Developer Guide v67.0 Summer '26 — Triggers and Order of Execution)
created: 2026-06-19
aliases: [Order of Execution, 실행 순서, save order, 저장 순서, 트리거 실행 순서, 20 steps, before trigger, after trigger, system validation, workflow rule order, recursive save, 트리거 저장 절차, 저장 순서 트리거 몇 번째, 트리거 validation 순서, validation rule 트리거 순서, workflow 후 트리거 재실행, roll-up summary 순서, flow 트리거 순서, 재귀 save 건너뛰기, 트리거 언제 실행되나, before after 트리거 어느 게 먼저, duplicate rule 순서]
---

# Trigger Order of Execution

> insert·update·upsert로 레코드를 저장할 때 Salesforce 서버가 수행하는 20단계 저장(save) 순서 — before/after 트리거, validation, duplicate rules, workflow, flow, roll-up summary, commit, post-commit까지 전체 lifecycle.

---

## 개요

레코드를 **insert·update·upsert** 문으로 저장하면 Salesforce는 정해진 순서로 일련의 이벤트를 수행한다. 이 순서는 트리거 전용이 아니라 **전체 저장(save) 절차**이며, 트리거는 그중 일부 단계일 뿐이다. (출처는 Apex Developer Guide의 "Triggers and Order of Execution" 절이지만, 다루는 범위는 저장 lifecycle 전체다.)

서버에서 이 이벤트들이 실행되기 **전에**, 레코드에 dependent picklist 필드가 있으면 **브라우저가 JavaScript validation**을 실행한다. 이 validation은 각 dependent picklist 필드를 가용 값으로 제한한다. 클라이언트 측에서는 다른 validation이 일어나지 않는다.

이 페이지에서 다루는 트리거 구문은 다음과 같다.

```apex
// Apex Developer Guide 원문 발췌 (구문 템플릿)
trigger TriggerName on ObjectName (trigger_events) {
    code_block
}
```

> **Note (다이어그램):** 실행 순서의 **다이어그램 표현(Order of Execution Flowchart)** 은 외부의 **Salesforce Data Model Gallery**에 있다. 그 다이어그램은 표시된 API 버전에 한정되며 이 정보와 어긋날(out-of-sync) 수 있다. **이 Apex Developer Guide 페이지가 해당 API 버전에 대한 가장 최신 정본**이다. 다른 API 버전을 보려면 Apex Developer Guide의 버전 선택기를 사용한다. (이 노트에는 임의로 그린 순서도를 두지 않고 번호 리스트로만 표현한다.)

---

## 20단계 실행 순서

서버에서 Salesforce는 다음 순서로 이벤트를 수행한다. (PDF 원문 라인 대조, 생략 없이 전수)

1. **원본 레코드 로드** — DB에서 원본 레코드를 로드하거나, upsert 문의 경우 레코드를 초기화한다.
2. **새 필드 값 로드 + validation** — 요청에서 새 레코드 필드 값을 로드해 이전 값을 덮어쓴다. 요청 타입에 따라 다른 validation 검사를 수행한다.
   - **표준 UI edit page 요청:** 다음 system validation 검사를 실행 — layout-specific 규칙 준수, layout 레벨·field-definition 레벨의 required 값, 유효한 필드 포맷, 최대 필드 길이. 추가로, 요청이 표준 UI edit page의 **User 객체**에서 온 것이면 custom validation rules도 실행한다.
   - **multiline item 생성(quote line item, opportunity line item 등):** custom validation rules 실행.
   - **기타 소스(Apex 애플리케이션, SOAP API 호출 등):** foreign key, 필드 포맷, 최대 필드 길이, restricted picklist를 검증. 트리거 실행 전, custom foreign key가 객체 자신을 참조하지 않는지 확인한다.
3. **before-save record-triggered flow 실행** — 레코드 저장 전에 실행되도록 구성된 record-triggered flow 실행.
4. **모든 before 트리거 실행.**
5. **system validation 재실행 + custom validation rules** — 대부분의 system validation을 다시 실행(모든 required 필드가 non-null인지 등)하고 custom validation rules를 실행한다. (표준 UI edit page 요청일 때) 두 번째로 실행하지 **않는** 유일한 system validation은 **layout-specific 규칙 강제**다.
6. **duplicate rules 실행** — duplicate rule이 레코드를 중복으로 식별하고 **block** 액션을 쓰면, 레코드는 저장되지 않고 after 트리거·workflow rule 등 이후 단계가 진행되지 않는다.
7. **DB에 레코드 저장 (커밋은 아직 안 함).**
8. **모든 after 트리거 실행.**
9. **assignment rules 실행.**
10. **auto-response rules 실행.**
11. **workflow rules 실행** — workflow field update가 있으면:
    > 이 시퀀스는 workflow rules에만 적용된다.
    - a. 레코드를 다시 업데이트한다.
    - b. system validation을 다시 실행한다. custom validation rules, flow, duplicate rules, Process Builder로 만든 process, escalation rules는 다시 실행되지 **않는다.**
    - c. 레코드 작업(insert/update)과 무관하게 **before update 트리거와 after update 트리거를 한 번 더(그리고 딱 한 번만)** 실행한다.
12. **escalation rules 실행.**
13. **Salesforce Flow 자동화 실행 (보장된 순서 없음)** — Process Builder로 만든 process, workflow rules로 시작된 flow(flow trigger workflow actions pilot).
    > Salesforce Flow 자동화의 실행 순서를 제어하려면 record-triggered flow를 사용한다. process나 flow가 DML 작업을 실행하면, 영향받은 레코드가 save 절차를 거친다.
14. **after-save record-triggered flow 실행** — 레코드 저장 후 실행되도록 구성된 record-triggered flow 실행.
15. **entitlement rules 실행.**
16. **roll-up summary (parent)** — 레코드에 roll-up summary 필드가 있거나 cross-object workflow의 일부면, 계산을 수행하고 **parent 레코드**의 roll-up summary 필드를 업데이트한다. parent 레코드는 save 절차를 거친다.
17. **roll-up summary (grandparent)** — parent 레코드가 업데이트되고, grandparent 레코드에 roll-up summary 필드가 있거나 cross-object workflow의 일부면, 계산을 수행하고 **grandparent 레코드**의 roll-up summary 필드를 업데이트한다. grandparent 레코드는 save 절차를 거친다.
18. **Criteria Based Sharing 평가 실행.**
19. **모든 DML 작업을 DB에 커밋.**
20. **post-commit 로직 실행** — 변경이 DB에 커밋된 후 실행. post-commit 로직 예시(특정 순서 없음):
    - 이메일 발송
    - 큐에 들어간 비동기 Apex 작업(queueable jobs, future methods 포함)
    - record-triggered flow의 asynchronous path

---

## 재귀 save 시 건너뛰는 단계

> **재귀 save 동안 Salesforce는 9단계(assignment rules)부터 17단계(grandparent 레코드의 roll-up summary 필드)까지를 건너뛴다(skip).**

즉 재귀 save에서는 9~17단계가 실행되지 않는다.

---

## Additional Considerations

트리거 작업 시 다음을 유의한다. (PDF 원문 6항 전수)

- **workflow field update와 `Trigger.old`** — workflow rule field update가 레코드 update로 트리거되면, `Trigger.old`는 workflow가 update한 새 필드 값을 갖지 **않는다.** 대신 `Trigger.old`는 **초기 레코드 update가 이뤄지기 전의 객체**를 가진다.
  - 예시: 기존 레코드의 number 필드 초기 값이 `1`. 사용자가 이 필드를 `10`으로 업데이트하고, workflow rule field update가 발생해 `11`로 증가시킨다. workflow field update 후 발생하는 update 트리거에서, `Trigger.old`로 얻은 객체의 필드 값은 `10`이 아니라 **원래 값 `1`** 이다.
- **partial success와 static 변수** — partial success를 허용한 DML 호출에서는 첫 시도에 트리거가 발생하고 이후 시도에서도 다시 발생한다. 이 트리거 호출들은 동일 트랜잭션의 일부이므로, 트리거가 접근하는 **static 클래스 변수는 reset되지 않는다.**
- **동일 이벤트 다중 트리거** — 한 객체에 같은 이벤트의 트리거가 둘 이상 정의되면 **트리거 실행 순서가 보장되지 않는다.** 예: Case에 before insert 트리거가 둘이고 새 Case가 insert되면, 두 트리거의 발생 순서는 보장되지 않는다.
- **AccountContactRelation** — org에서 contact를 여러 account에 연관시키는 non-private contact를 insert할 때의 실행 순서는 AccountContactRelation 문서 참조.
- **Opportunity** — before 트리거로 Stage·Forecast Category를 설정할 때의 실행 순서는 Opportunity 문서 참조.
- **API 53.0 이하 after-save flow** — API 버전 53.0 이하에서는 after-save record-triggered flow가 **entitlements가 실행된 후**에 실행된다.

---

## 관련 노트

- [[Trigger 컨텍스트 변수와 이벤트]] — 트리거 문법, 컨텍스트 변수, TriggerOperation enum, 이벤트별 허용/금지 매트릭스
- [[Trigger 재귀 방지]] — 재귀 save·무한 재귀를 막는 static 변수 가드 패턴
- [[TriggerHandler 패턴]] — 트리거 로직 구조화, 단일 트리거 원칙
- [[Governor Limits]] — after update 트리거의 잘못된 재귀를 잡아내는 거버너 한도
- [[Validation Rules 예제]] — 2·5·11b 단계에서 실행되는 custom validation rules 작성 예제
- [[Trigger 벌크 관용구·미발생 작업·예외]] — 트리거 미발생 시스템 작업·벌크 관용구·`addError()` 예외 마킹
- [[Apex 버전별 동작 변경 레퍼런스]] — API v53.0 이하 after-save flow·entitlement 실행 순서 등 버전 게이트 동작 카탈로그
- [[Record-Triggered Flow vs Apex Trigger 선택]] — 이 저장 순서에 올라탈 자동화를 Flow로 만들지 Apex로 만들지 결정 기준 (자동화 밀도)
- (외부) Salesforce Help: Triggers for Autolaunched Flows
