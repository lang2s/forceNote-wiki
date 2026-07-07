---
tags: [apex, trigger, context-variables, trigger-events, TriggerOperation, before-after, bulk-trigger]
source: salesforce_apex_developer_guide.pdf (Apex Developer Guide v67.0 Summer '26 — Triggers; TriggerOperation ordinal은 Apex Reference Guide 출처)
created: 2026-06-19
aliases: [Trigger Context Variables, 트리거 컨텍스트 변수, Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap, operationType, operationType switch, System.TriggerOperation, isInsert, isBefore, trigger syntax, 트리거 문법, before trigger, after trigger, 트리거 이벤트, 트리거에서 Trigger.new 언제 쓰나, before update에서 update DML, after insert에서 update 되나, 트리거에서 런타임 에러, before delete에서 delete, 트리거 이벤트별 허용 금지, 트리거에서 뭘 쓸 수 있나, trigger merge, trigger undelete, after undelete 트리거, MasterRecordId 트리거]
---

# Trigger 컨텍스트 변수와 이벤트

> 트리거의 문법, 13종 컨텍스트 변수(Trigger.new/old/newMap/oldMap 등), TriggerOperation enum, 그리고 각 트리거 이벤트에서 무엇이 허용/금지되는지(런타임 에러 포함)를 다룬다.

---

## 개요

Apex 트리거는 Salesforce 레코드의 삽입·수정·삭제 등 변경 **전(before)** 또는 **후(after)** 에 커스텀 동작을 수행하는 Apex 코드다. 트리거는 다음 시점에 실행된다.

- insert 작업의 before / after
- update 작업의 before / after
- delete 작업의 before / after
- merge 작업의 before / after
- upsert 작업의 before / after
- undelete 작업의 after

트리거를 정의할 수 있는 대상은 트리거를 지원하는 **top-level 표준 객체**(Contact, Account 등), 일부 표준 자식 객체(CaseComment 등), 그리고 **커스텀 객체**다.

**두 종류의 트리거:**

- **Before 트리거** — 레코드가 DB에 저장되기 **전**에 레코드 값을 업데이트하거나 검증하는 데 쓴다.
- **After 트리거** — 시스템이 설정한 필드 값(레코드의 `Id`나 `LastModifiedDate` 등)에 접근하거나, 다른 레코드에 영향을 주는 데(감사 테이블 로깅, 큐로 비동기 이벤트 발행 등) 쓴다. **after 트리거를 발생시킨 레코드는 read-only**다.

트리거는 자신을 발생시킨 레코드와 같은 타입의 **다른 레코드**도 수정할 수 있다(예: contact A의 update 후 트리거가 contact B, C, D도 수정). 이렇게 트리거가 다른 레코드를 바꾸고 그 변경이 또 다른 트리거를 발생시킬 수 있으므로, Apex 런타임 엔진은 이런 모든 작업을 **단일 작업 단위(single unit of work)** 로 간주하고 무한 재귀 방지를 위해 작업 수에 한도를 둔다.

> ⚠️ **런타임 에러 규칙:** before 트리거에서 레코드를 **update 또는 delete** 하거나, after 트리거에서 레코드를 **delete** 하면 런타임 에러가 발생한다. 이는 **직접·간접 작업 모두** 포함한다. 예를 들어 account A를 업데이트하고, account A의 before update 트리거가 contact B를 insert하고, contact B의 after insert 트리거가 account A를 조회해 DML update로 수정하면, before 트리거 안에서 account A를 **간접적으로** 업데이트한 것이 되어 런타임 에러가 난다.

> 실행 순서(save lifecycle 전체)는 [[Trigger Order of Execution]] 참조.

> PDF 원본에서는 "Defining Triggers" 절이 컨텍스트 변수보다 앞쪽에 온다 — 이 노트는 독자의 학습 흐름에 맞춰 재배치했다.

### Implementation Considerations

트리거 생성 전 고려할 점:

- **upsert** 트리거는 상황에 맞게 before/after insert 또는 before/after update 트리거를 모두 발생시킨다.
- **merge** 트리거는 losing 레코드에 대해 before/after delete를, winning 레코드에 대해 before/after update 트리거를 모두 발생시킨다. (아래 Merge 섹션 참조)
- undelete 후 실행되는 트리거는 특정 객체에서만 동작한다. (아래 Recovered Records 섹션 참조)
- **Field history는 트리거가 끝날 때까지 기록되지 않는다.** 트리거 안에서 field history를 조회하면 현재 트랜잭션의 history는 보이지 않는다.
- Field history tracking은 현재 사용자의 권한을 따른다. 현재 사용자가 객체/필드를 직접 편집할 권한이 없지만, 트리거를 통해 history tracking이 켜진 객체/필드를 변경하면 그 변경의 history는 기록되지 않는다.
- **Callout은 반드시 트리거에서 비동기로 호출**해야 한다. 그래야 외부 서비스 응답을 기다리는 동안 트리거 프로세스가 막히지 않는다. 비동기 callout은 future 메서드 같은 비동기 Apex를 사용한다.
- **API 버전 20.0 이하**에서 Bulk API 요청이 트리거를 발생시키면, 트리거가 처리할 200 레코드 chunk가 다시 **100 레코드 chunk로 분할**된다. **API 버전 21.0 이상**에서는 추가 분할이 일어나지 않는다. Bulk API 요청이 200 레코드 chunk마다 트리거를 여러 번 발생시키면, 동일 HTTP 요청 내에서도 이 트리거 호출 사이에 governor limit이 리셋된다.

---

## 트리거 문법

트리거 정의 구문:

```apex
// Apex Developer Guide 원문 발췌 (구문 템플릿)
trigger TriggerName on ObjectName (trigger_events) {
    code_block
}
```

`trigger_events`는 쉼표로 구분된 하나 이상의 이벤트다. 예를 들어 다음 코드는 Account 객체의 before insert·before update 이벤트에 대한 트리거를 정의한다.

```apex
// Apex Developer Guide 원문 발췌
trigger myAccountTrigger on Account (before insert, before update) {
    // Your code here
}
```

- 트리거 코드 블록에는 **`static` 키워드를 쓸 수 없다.** 트리거는 inner class에 적용 가능한 키워드만 포함할 수 있다.
- DB 변경을 **수동으로 커밋할 필요가 없다.** Apex 트리거가 성공적으로 완료되면 모든 DB 변경이 자동 커밋되고, 실패하면 변경이 롤백된다.

### 코드 예제 — SimpleTrigger

`Trigger.new`는 sObject 리스트이며 for 루프로 순회할 수 있고, SOQL 쿼리의 `IN` 절에서 바인드 변수로도 쓸 수 있다.

```apex
// Apex Developer Guide 원문 발췌
trigger SimpleTrigger on Account(after insert) {
  for (Account a : Trigger.new) {
    // Iterate over each sObject
  }

    // This single query finds every contact that is associated with any of the
    // triggering accounts. Note that although Trigger.new is a collection of
    // records, when used as a bind variable in a SOQL query, Apex automatically
    // transforms the list of records into a list of corresponding Ids.
    Contact[] cons = [
      SELECT LastName
      FROM Contact
      WHERE AccountId IN :Trigger.new
      WITH USER_MODE
    ];
}
```

### 코드 예제 — MyAccountTrigger

`Trigger.isBefore`, `Trigger.isDelete` 같은 Boolean 컨텍스트 변수로 특정 조건에서만 실행되는 코드를 분기한다.

```apex
// Apex Developer Guide 원문 발췌
trigger MyAccountTrigger on Account(
  before delete,
  before insert,
  before update,
  after delete,
  after insert,
  after update
) {
  if (Trigger.isBefore) {
    if (Trigger.isDelete) {
      // In a before delete trigger, the trigger accesses the records that will be
      // deleted with the Trigger.old list.
      for (Account a : Trigger.old) {
        if (a.name != 'okToDelete') {
          a.addError('You can\'t delete this record!');
        }
      }
    } else {
      // In before insert or before update triggers, the trigger accesses the new records
      // with the Trigger.new list.
      for (Account a : Trigger.new) {
        if (a.name == 'bad') {
          a.name.addError('Bad name');
        }
      }
      if (Trigger.isInsert) {
        for (Account a : Trigger.new) {
          Assert.areEqual('xxx', a.accountNumber);
          Assert.areEqual('industry', a.industry);
          Assert.areEqual(100, a.numberofemployees);
          Assert.areEqual(100.0, a.annualrevenue);
          a.accountNumber = 'yyy';
        }

        // If the trigger is not a before trigger, it must be an after trigger.
      } else {
        if (Trigger.isInsert) {
          List<Contact> contacts = new List<Contact>();
          for (Account a : Trigger.new) {
            if (a.Name == 'makeContact') {
              contacts.add(new Contact(LastName = a.Name, AccountId = a.Id));
            }
          }
          insert as user contacts;
        }
      }
    }
  }
}
```

---

## 컨텍스트 변수

모든 트리거는 런타임 컨텍스트에 접근하기 위한 암묵적 변수를 정의한다. 이 변수들은 `System.Trigger` 클래스에 들어 있다.

| 변수 | 타입 / 반환 | 가용 trigger 종류 · 수정 가능 여부 |
|---|---|---|
| `isExecuting` | Boolean | 현재 Apex 코드 컨텍스트가 트리거이면(Visualforce 페이지·웹서비스·`executeAnonymous()` API 호출이 아니면) `true` 반환 |
| `isInsert` | Boolean | Salesforce UI·Apex·API에서의 **insert** 작업으로 트리거가 발생했으면 `true` |
| `isUpdate` | Boolean | UI·Apex·API에서의 **update** 작업으로 발생했으면 `true` |
| `isDelete` | Boolean | UI·Apex·API에서의 **delete** 작업으로 발생했으면 `true` |
| `isBefore` | Boolean | 레코드가 저장되기 **전**에 발생했으면 `true` |
| `isAfter` | Boolean | 모든 레코드가 저장된 **후**에 발생했으면 `true` |
| `isUndelete` | Boolean | 레코드가 휴지통에서 복구된 후 발생했으면 `true`(UI·Apex·API의 undelete 작업으로 복구 발생 가능) |
| `new` | `List<sObject>` | 새 버전 sObject 레코드 리스트. **insert·update·undelete 트리거에서만 사용 가능**하며, **before 트리거에서만 수정 가능** |
| `newMap` | `Map<Id, sObject>` | ID → 새 버전 sObject 맵. **before update·after insert·after update·after undelete 트리거에서만 사용 가능** |
| `old` | `List<sObject>` | 이전 버전 sObject 레코드 리스트. **update·delete 트리거에서만 사용 가능** (항상 read-only) |
| `oldMap` | `Map<Id, sObject>` | ID → 이전 버전 sObject 맵. **update·delete 트리거에서만 사용 가능** (항상 read-only) |
| `operationType` | `System.TriggerOperation` enum | 현재 작업에 해당하는 enum 반환 (아래 enum 섹션 참조). 트리거 타입별로 로직이 달라지면 switch 문 사용 권장 |
| `size` | Integer | 트리거 호출에서 처리된 레코드 수. 200건 초과 DML은 배치로 처리되고 트리거가 배치마다 호출됨. `Trigger.size`는 **현재 배치의 레코드 수만** 포함하며, DML 작업 전체 레코드 수가 아님 |

> **Note (PDF 원문 보존):** 트리거를 발생시킨 레코드는 0으로 나누는 수식처럼 **유효하지 않은 필드 값**을 가질 수 있다. 이 경우 해당 필드 값은 다음 변수들에서 `null`로 설정된다 — `new`, `newMap`, `old`, `oldMap`.

---

## TriggerOperation enum

`Trigger.operationType`이 반환하는 `System.TriggerOperation` enum의 가능한 값은 7개다. 트리거 타입별로 프로그래밍 로직이 달라진다면, 고유한 트리거 실행 enum 상태 조합으로 **switch 문**을 쓰는 것이 권장된다.

| ordinal | enum 값 | 의미 |
|---|---|---|
| 0 | `BEFORE_INSERT` | before insert |
| 1 | `AFTER_INSERT` | after insert |
| 2 | `BEFORE_UPDATE` | before update |
| 3 | `AFTER_UPDATE` | after update |
| 4 | `BEFORE_DELETE` | before delete |
| 5 | `AFTER_DELETE` | after delete |
| 6 | `AFTER_UNDELETE` | after undelete |

> 표의 **ordinal 값은 Apex Reference Guide(TriggerOperation Enum) 출처**다. Apex Developer Guide 본문은 enum 값 7종만 나열하며 ordinal 순서를 명시하지 않는다 — ordinal은 Reference Guide의 enum 선언 순서를 따른다.

---

## 컨텍스트 변수 사용 매트릭스

PDF 원문(아래)을 셀별로 대조해 작성했다. ⚠️ 상태값은 **4종**으로 구분된다 — 단순 ✅/❌가 아니다.

- **Allowed** — 허용
- **Not allowed. A runtime error is thrown** — 금지, 런타임 에러 발생
- **Not applicable** — 해당 없음(상황 자체가 성립 안 함)
- **Allowed, but unnecessary** — 허용되지만 불필요

**먼저 알아둘 4개 고려사항:**

- `trigger.new`와 `trigger.old`는 Apex **DML 작업에 직접 사용할 수 없다.**
- `trigger.new`로 **객체 자신의 필드 값을 바꿀 수 있지만 before 트리거에서만** 가능하다. 모든 after 트리거에서는 `trigger.new`가 저장되지 않으므로 런타임 예외가 발생한다.
- `trigger.old`는 **항상 read-only**다.
- `trigger.new`는 **삭제할 수 없다.**

| Trigger Event | ① `trigger.new`로 필드 변경 | ② update DML로 원본 update | ③ delete DML로 원본 delete |
|---|---|---|---|
| **before insert** | Allowed | **Not applicable** — 원본 객체가 아직 생성되지 않았다. 아무것도 그것을 참조할 수 없으므로 update할 수 없다 | **Not applicable** — 원본 객체가 아직 생성되지 않았다. 아무것도 그것을 참조할 수 없으므로 delete할 수 없다 |
| **after insert** | **Not allowed. A runtime error is thrown** — `trigger.new`가 이미 저장됨 | Allowed | **Allowed, but unnecessary** — 객체가 insert된 직후 삭제된다 |
| **before update** | Allowed | **Not allowed. A runtime error is thrown** | **Not allowed. A runtime error is thrown** |
| **after update** | **Not allowed. A runtime error is thrown** — `trigger.new`가 이미 저장됨 | Allowed — 잘못된 코드가 무한 재귀를 일으킬 수 있으나, 잘못 작성하면 그 에러는 **governor limits**에 의해 발견된다 | Allowed — 객체가 삭제되기 전에 update가 저장되므로, 객체가 undelete되면 그 update가 보이게 된다 |
| **before delete** | **Not allowed. A runtime error is thrown** — `trigger.new`는 before delete 트리거에서 사용 불가 | Allowed — 객체가 삭제되기 전에 update가 저장되므로, 객체가 undelete되면 그 update가 보이게 된다 | **Not allowed. A runtime error is thrown** — 삭제가 이미 진행 중이다 |
| **after delete** | **Not allowed. A runtime error is thrown** — `trigger.new`는 after delete 트리거에서 사용 불가 | **Not applicable** — 객체가 이미 삭제됨 | **Not applicable** — 객체가 이미 삭제됨 |
| **after undelete** | **Not allowed. A runtime error is thrown** | Allowed | **Allowed, but unnecessary** — 객체가 insert된 직후 삭제된다 |

> PDF 원문(after undelete ③): *"Allowed, but unnecessary. The object is deleted immediately after being inserted."* — undelete된 객체를 다시 삭제하는 것은 허용되나 불필요함을 의미한다.

---

## 트리거 정의 (Defining)

트리거 코드는 연관된 객체 아래 **메타데이터로 저장**된다. Salesforce UI에서 트리거를 정의하는 절차:

1. 트리거에 접근하려는 객체의 object management settings에서 **Triggers**로 이동.
   > **Tip:** **Attachment, ContentDocument, Note** 표준 객체는 Salesforce UI에서 트리거를 생성할 수 없다. 이 객체들은 **Developer Console, VS Code용 Salesforce extensions, 또는 Metadata API**로 트리거를 생성한다.
2. Triggers 목록에서 **New** 클릭.
3. 이 트리거에 사용할 Apex·API 버전을 지정하려면 **Version Settings** 클릭. 조직에 AppExchange managed package가 설치돼 있으면 각 패키지 버전도 지정 가능. 기본값을 쓰면 최신 버전과 연결된다.
4. **Apex Trigger**를 클릭하고, 컴파일·활성화하려면 **Is Active** 체크박스 선택(기본 선택됨). 메타데이터에 코드만 저장하려면 체크 해제.
5. **Body** 텍스트 박스에 트리거 Apex 입력. **단일 트리거는 최대 100만(1 million)자**까지 가능. `trigger_events`는 다음 7종을 쉼표로 나열 — `before insert`, `before update`, `before delete`, `after insert`, `after update`, `after delete`, `after undelete`.
   > **Note:**
   > - recurring event 또는 recurring task의 insert·delete·update로 호출된 트리거를, Lightning Platform API에서 bulk로 호출하면 **런타임 에러**가 발생한다.
   > - after-insert/after-update 트리거로 lead·contact·opportunity의 소유권을 바꾸는 경우: API로 레코드 소유권을 바꾸거나 Lightning Experience 사용자가 소유자를 바꾸면 이메일 알림이 발송되지 않는다. 새 소유자에게 이메일 알림을 보내려면 `DMLOptions`의 `triggerUserEmail` 프로퍼티를 `true`로 설정.
6. **Save** 클릭.
   > **Note (isValid flag):** 트리거는 `isValid` flag와 함께 저장되며, 마지막 컴파일 이후 dependent metadata가 바뀌지 않은 한 `true`다. 트리거에 쓰인 객체명·필드에 변경(객체/필드 description 편집 같은 사소한 변경 포함)이 생기면 Apex 컴파일러가 재처리할 때까지 `isValid`가 `false`가 된다. 재컴파일은 트리거가 다음 실행될 때 또는 사용자가 트리거를 메타데이터에 재저장할 때 발생한다.
   > **Note (lookup field 동작):** lookup 필드가 **삭제된 레코드**를 참조하면, Salesforce는 기본적으로 그 lookup 필드의 값을 **클리어(clear)** 한다. 또는, lookup relationship에 있는 레코드는 **삭제되지 않도록 방지**하는 옵션을 선택할 수도 있다.

### Apex Trigger Editor 기능

- **Syntax highlighting** — 키워드·함수·연산자에 구문 강조 자동 적용
- **Search** — 현재 페이지/클래스/트리거 내 텍스트 검색. Replace/Replace All, Match Case(대소문자 구분), Regular Expressions(JavaScript 정규식 규칙, 여러 줄 매칭 + `$1`,`$2` 그룹 변수 바인딩) 지원
- **Go to line** — 지정한 라인 번호로 이동/스크롤
- **Undo / Redo** — 편집 작업 되돌리기/다시 실행
- **Font size** — 드롭다운으로 글자 크기 제어
- **Line and column position** — 커서의 라인·컬럼 위치를 하단 상태 표시줄에 표시(go to line과 함께 사용)
- **Line and character count** — 전체 라인 수·문자 수를 하단 상태 표시줄에 표시

---

## Merge / Recovered Records

### Triggers and Merge Statements

Merge 이벤트는 **자체 트리거 이벤트를 발생시키지 않는다.** 대신 delete·update 이벤트를 발생시킨다.

- **losing 레코드의 삭제** — 단일 merge 작업은 merge로 삭제되는 모든 레코드에 대해 단일 delete 이벤트를 발생시킨다. merge로 삭제된 레코드를 식별하려면 `Trigger.old`의 `MasterRecordId` 필드를 쓴다. losing한 레코드의 `MasterRecordId`는 winning 레코드 ID로 설정된다. **`MasterRecordId`는 after delete 트리거 이벤트에서만 설정**되므로, merge 결과 삭제된 레코드에 특별 처리가 필요하면 after delete 트리거를 써야 한다.
- **winning 레코드의 업데이트** — 단일 merge 작업은 winning 레코드에 대해서만 단일 update 이벤트를 발생시킨다. merge로 reparent된 자식 레코드는 트리거를 발생시키지 않는다.

예: 두 contact가 merge되면 delete·update contact 트리거만 발생한다. account나 opportunity 같은 관련 레코드의 트리거는 발생하지 않는다.

**merge 발생 시 이벤트 순서:**

1. before delete 트리거 발생.
2. 시스템이 merge로 필요한 레코드를 삭제하고, 자식 레코드에 새 부모 레코드를 배정하며, 삭제된 레코드에 `MasterRecordId` 필드를 설정.
3. after delete 트리거 발생.
4. 시스템이 master 레코드에 필요한 update 수행. 일반 update 트리거가 적용됨.

### Triggers and Recovered Records

`after undelete` 트리거 이벤트는 **복구된 레코드**(`undelete` DML 문으로 휴지통에서 복구된 레코드, undeleted records)에서만 동작한다.

`after undelete` 트리거는 **top-level 객체에서만** 실행된다. 예를 들어 Account를 삭제하면 Opportunity도 함께 삭제될 수 있는데, 휴지통에서 Account를 복구하면 Opportunity도 복구된다. 이때 Account와 Opportunity 양쪽에 after undelete 트리거가 있어도 **Account의 after undelete 트리거만 실행**된다.

`after undelete` 트리거는 **커스텀 객체**와 다음 표준 객체에서만 발생한다.

- Account
- Asset
- Campaign
- Case
- Contact
- ContentDocument
- Contract
- Event
- Lead
- Opportunity
- Product
- Solution
- Task

---

## 관련 노트

- [[Trigger Order of Execution]] — insert/update/upsert 저장 시 20단계 실행 순서 (이 노트의 "실행 순서" 위임 대상)
- [[TriggerHandler 패턴]] — abstract class로 트리거 로직 구조화, bypass, 단일 트리거 원칙
- [[Trigger 재귀 방지]] — static 변수 가드·Set&lt;Id&gt; 추적으로 무한 재귀 방지
- [[CMDT 메타데이터 트리거]] — 배포 없이 핸들러 등록/비활성화
- [[System Namespace]] — `System.TriggerOperation` enum이 속한 System 네임스페이스 전체 레퍼런스
- [[ChangeEvent Objects]] — Change Data Capture 이벤트 객체와 트리거 연동
- [[Trigger 벌크 관용구·미발생 작업·예외]] — 벌크 처리 관용구·트리거 미발생 작업·`addError()` 예외 마킹 (정의·문법의 실행 측면 형제)
- [[특정 표준 객체 트리거 고려사항 — Chatter · Knowledge]] — 일반 이벤트 가용성이 특정 표준 객체(FeedItem/FeedComment·KAV)에서 어떻게 제약되는지 다루는 객체별 형제
- [[Record-Triggered Flow vs Apex Trigger 선택]] — 같은 before/after·insert/update/delete 이벤트를 Flow로 처리할지 트리거로 처리할지(언제 Flow 대신 트리거) 선택 기준
