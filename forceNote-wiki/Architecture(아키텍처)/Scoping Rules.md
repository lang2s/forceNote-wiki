---
tags: [architecture, record-access, scoping-rules, restriction-rule, security, visibility, tooling-api, metadata-api, soql]
source: scoping_rules_dev_guide.pdf (Scoping Rules Developer Guide, Version 66.0 Spring '26, Tier 2)
created: 2026-06-20
aliases: [Scoping Rules, 스코핑 룰, 범위 규칙, RestrictionRule, Restriction Rule, enforcementType, Filter by scope, USING SCOPE EVERYTHING, recordFilter, targetEntity]
---

# Scoping Rules

> 사용자가 **기본으로 보는 레코드 집합을 좁히는**(접근 권한은 변경하지 않는) 규칙. 별도 API 타입이 없고 Restriction Rule과 **동일한 `RestrictionRule` Tooling/Metadata 타입**을 공유하며 `enforcementType=Scoping`으로만 구분된다. (`scoping_rules_dev_guide.pdf` v66.0 전수)

> [!warning] **`ScopingRule`/`ScopingRuleService` 같은 별도 API 타입은 존재하지 않는다.** Scoping Rule은 `RestrictionRule` 타입(Tooling object + Metadata type)으로 만들고 `enforcementType` 값으로 Restriction Rule과 구분한다.

---

## 개요 — Scoping Rules란

선택한 기준(criteria)에 따라 사용자가 보는 레코드를 제어한다. 조직 내 사용자별로 scoping rule을 설정하면 자신에게 의미 있는 레코드에 집중할 수 있다. Tooling API, Metadata API, 또는 Salesforce Setup에서 생성·편집·삭제한다.

> PDF 원문: *"Based on criteria that you select, you can set rules to help your users see only records that are relevant to them. Scoping rules don't restrict the record access that your users already have. Your users can still open and report on all records that they have access to per your org's sharing settings."*

**언제 쓰나 (When Do I Use Scoping Rules?):** 여러 agency를 지원하는 사용자가 각자 배정된 agency의 레코드만 list view·report에서 보도록 필터링하되, 필요하면 다른 agency 레코드에도 여전히 접근할 수 있게 한다. **Flow Builder**와 함께 써서 사용자의 선택에 따라 scope를 설정할 수도 있다 — 예: 사용자가 **Lightning Utility Bar**로 접근하는 flow를 만들어 division별로 account 레코드 set을 전환.

**EDITIONS:** Available in: Lightning Experience in **Performance, Unlimited, and Developer** editions. (단, 하위 섹션 다수는 "Performance and Unlimited Editions"만 표기 — 섹션별 차이가 있어 PDF 원문 그대로 반영.)

### 지원 객체 (Scoping)

`enforcementType=Scoping`일 때 지원되는 객체 — **custom objects + account, case, contact, event, lead, opportunity, task** standard objects.

> PDF 원문: *"Scoping rules are available for custom objects and the account, case, contact, event, lead, opportunity, and task standard objects."*

### 접근 권한은 바뀌지 않는다

Scoping rule은 사용자가 이미 가진 레코드 접근(access)을 **제한하지 않는다.** 사용자는 조직의 sharing 설정에 따라 접근 가능한 모든 레코드를 여전히 열고 report할 수 있다. Scope는 **쿼리별(query-by-query)로 enable/disable** 가능하다.

> PDF 원문: *"Scoping rules are flexible. You can enable and disable them on a query-by-query basis. Plus, they don't restrict the access that your users have to records."*

### 어디에 적용되나 (List View·Report·SOQL)

| Feature | 동작 (PDF 원문) |
|---|---|
| List Views | Applied in Lightning Experience if **Filter by scope** is selected |
| Reports | Applied in Lightning Experience if **Filter by scope** is selected |
| SOQL | Applied, **unless a scope other than `scopingrule` is specified** |

**설정 방법:** 지원 객체로 이동해 Object Manager에서 관리하거나, **RestrictionRule Tooling API object** 또는 **RestrictionRule Metadata API type**을 사용한다. 생성 후에는 change set이나 unlocked package로 다른 org에 이동할 수 있다.

> 중요(PDF 원문): *"When creating more than one scoping or restriction rule, configure the rules so that only one active rule applies to a given user. Salesforce doesn't validate that only one active rule applies for a given user. If you create two active rules, and both rules apply to a given user, only one of the active rules is observed."*

**USER PERMISSIONS:**
- 생성·관리: **Manage Sharing**
- 조회: **View Setup & Configuration AND View Restriction and Scoping Rules**

---

## Scoping vs Restriction vs Sharing — 혼동 구분

|  | Scoping Rule | Restriction Rule | Sharing Rule |
|---|---|---|---|
| 목적 | 기본 표시 범위를 **좁힘** | 레코드 접근을 **제한** | 레코드 접근을 **확대** |
| 접근 권한 | 불변 (focus만) | 실제 제거 | 추가 |
| API 타입 | `RestrictionRule` (enforcementType=Scoping) | `RestrictionRule` (enforcementType=Restrict) | (별도 — 본 노트 범위 밖) |
| 지원 객체 | Account·Case·Contact·Event·Lead·Opportunity·Task + custom | Contract·Event·Quote·Task·TimeSheet·TimeSheetEntry + custom/external | — |
| on/off | 쿼리별 (Filter by scope) | 항상 적용 | 항상 적용 |

> Scoping Rule과 Restriction Rule은 **동일 API 타입 `RestrictionRule`을 공유**하고 `enforcementType` 값(Scoping vs Restrict)으로만 구분된다. Restriction Rule의 메커니즘 자체는 본 노트 범위 밖 — [[Metadata Types — Security & Access]] 및 Restriction Rule Developer Guide 참조. RestrictionRule API 타입의 공용 레퍼런스는 본 노트 하단 [RestrictionRule API 레퍼런스](#restrictionrule-api-레퍼런스-scoping·restriction-공용)에 정리.

---

## recordFilter 문법

### EQUALS 전용(비-SOQL)

SOQL operator를 쓰지 않으면 scoping rule은 **`EQUALS` 연산자만** 지원한다. **AND·OR는 지원하지 않는다.**

```
// 구조 예시 — recordFilter 값(원문 발췌 모음, 실행 코드 아님)
Branch__c = $User.Branch__c
Department=$User.Department
Division=$User.Division
recordTypeId = '012xxxxxxxxxxxx'
OwnerId = $User.Id
```

지원 데이터 타입(recordFilter·userCriteria 공통): `boolean`, `date (yyyy-MM-dd)`, `dateTime (yyyy-MM-dd HH:mm:ss)`, `double`, `int`, `reference`, `string`, `time`, `single picklist`. Record Criteria 필드에서는 **콤마로 구분된 ID/string 다중값**도 지원한다. null·blank 값은 지원하지 않으며 예기치 않은 동작을 유발할 수 있다.

### SOQL Operator (USING SCOPE EVERYTHING)

rule의 record criteria가 junction object 같은 **target 객체 외의 객체 필드를 참조**해야 할 때 SOQL operator를 쓴다. SOQL operator가 있는 scoping rule은 **API(Tooling 또는 Metadata)로만** 생성·편집할 수 있다.

문법: `SOQL(<leftOperand>, <SELECT statement>)`

다음은 PDF의 SOQL operator callout 그림을 3요소 표로 재현한 것이다. PDF에는 JSON에 ①②③ 원형 callout이 붙은 다이어그램이 있으나, 본 wiki에는 텍스트 표로만 옮긴다.

```
// 구조 예시 — 실제 PDF 다이어그램 아님 (callout이 가리키는 3요소를 표로 재현)
```

| # | 명칭 | 설명 (PDF 원문) |
|---|---|---|
| 1 | SOQL Operator | The operator that tells Salesforce to run a SELECT statement on the junction object. |
| 2 | Record Filter | The record criteria in this expression is used to filter records when the users specified by the user criteria use a list view, report, or SOQL query. |
| 3 | Target Entity | The standard or custom object whose records are scoped by the scoping rule. Scoping rules support custom objects and the account, case, contact, event, lead, opportunity, and task standard objects only. |

**Detail of Record Filter** — PDF 원문 코드 그대로:

```
<recordFilter>SOQL(Id, SELECT AccountId FROM BranchUnitCustomer USING SCOPE EVERYTHING WHERE BranchUnitId IN(SELECT CurrentBranchId From Banker WHERE UserOrContactId = $User.Id))</recordFilter>
```

작성 절차(PDF 원문):
1. recordFilter에서 큰따옴표 사이로 쿼리를 시작한다: `"SOQL()"`.
2. **target entity 객체의 단일 ID(primary key) 또는 reference(foreign key) 필드**인 left operand를 지정한다.
3. 해당 필드와 그 필드를 저장하는 객체를 지정하는 SELECT문을 작성한다.

> 중요(PDF 원문): *"The SELECT statement, including nested SELECT statements, must include **USING SCOPE EVERYTHING**. USING SCOPE EVERYTHING is the only valid scope clause syntax for scoping rules."*

**핵심 제약:**
- SOQL operator의 SELECT문에서 query의 **junction object와 scoping rule의 `targetEntity`는 같은 객체일 수 없다.**
- SOQL operator는 `$User` 구문 중 **`$User.Id`만** 지원한다. 그 외 dynamic query(다른 user object 필드 포함)는 미지원.
- record filter의 SELECT문에 subquery에서 지원되지 않는 객체를 쓰지 말 것. WHERE 절 field expression에 쓸 수 있는 valid operator 목록은 Comparison Operators 참조.
- **SOQL operator는 scoping rule에서만 지원된다** (restriction rule 미지원).

**SOQL operator 미지원 객체:** `ActivityHistory`, `Attachments`, `Event`, `EventAttendee`, `Note`, `OpenActivity`, `Tags`(AccountTag·ContactTag 등 모든 tag 객체), `Task`.

**Performance:** SOQL operator를 포함한 rule을 활성화하기 전, SELECT문을 API client에서 따로 실행해 성능 영향을 테스트한다. 특정 사용자에 대해 빠르면 rule도 효율적으로 동작할 가능성이 높다. 느리면 성능을 떨어뜨리는 필드를 분리하고, Salesforce customer support와 함께 해당 필드를 색인할 수 있는지 확인한다.

### dot notation·Owner·다중값

- **dot notation:** recordFilter에서 다른 객체의 필드를 참조할 수 있으나 **"dot" 하나만**(targetEntity로부터 1-level lookup) 허용된다. 예: `Owner.UserRoleId`.
- **Owner 참조:** Owner 필드를 참조할 때는 **객체 타입을 명시**해야 한다. 예를 들어 event 객체의 Owner 필드는 user 또는 queue를 담을 수 있지만 queue는 scoping rule에서 지원되지 않으므로, user만 허용할 때 `Owner:User`를 명시한다.
- **다중값:** 콤마로 구분된 ID/string 다중값 지원. **곡선 큰따옴표 `“ ”`**로 묶으면 그 안의 콤마는 구분자로 보지 않는다.

> 지원 SOQL 예 (PDF 원문):
> `SOQL(Id, SELECT Account.id FROM AccountAdvisors USING SCOPE EVERYTHING WHERE userid = $User.Id)`
> 미지원 SOQL 예 (PDF 원문 — `$User.Id` 외 user 필드 사용):
> `SOQL(Id, SELECT Account.id FROM AccountAdvisors USING SCOPE EVERYTHING WHERE userid = $User.Current_Advisor__c)`
> left operand 예 (PDF 원문): `"recordFilter":"SOQL(OwnerId, Select Id from User USING SCOPE Everything LIMIT 2)"` — 여기서 left operand는 `OwnerId`.

---

## 생성 — Tooling API

`RestrictionRule` Tooling API object로 restriction rule과 scoping rule을 모두 만든다. FullName 값과 모든 required 필드를 포함한다. payload 최상위는 `FullName` + `Metadata`(camelCase 하위 필드) 구조다.

> Note(PDF 원문): *"The `userCriteria` in this example applies this rule to any active user in your org."* 이 rule이 다른 사용자 부분집합에 적용돼야 하면 userCriteria를 조정한다.

**예제 ① — BranchRuleOnAccount** (PDF 원문 JSON; Branch Management 데이터 모델, SOQL operator 사용):

```json
{
    "FullName": "BranchRuleOnAccount",
    "Metadata": {
        "active": true,
        "description": "Scoping rule where users can scope account records by the user’s current branch",
        "enforcementType": "Scoping",
        "masterLabel": "BranchRuleOnAccount",
        "recordFilter": "SOQL(Id, SELECT AccountId FROM BranchUnitCustomer USING SCOPE EVERYTHING WHERE BranchUnitId IN(SELECT CurrentBranchId From Banker WHERE UserOrContactId = $User.Id))",
        "targetEntity": "Account",
        "userCriteria": "$User.IsActive = true",
        "version": 1
    }
}
```

**예제 ② — BranchRuleOnLead** (PDF 원문 JSON):

```json
{
    "FullName": "BranchRuleOnLead",
    "Metadata": {
        "active": true,
        "description": "Scoping rule where users can scope lead records by the user’s current branch",
        "enforcementType": "Scoping",
        "masterLabel": "BranchRuleOnLead",
        "recordFilter": "SOQL(Id, SELECT RelatedRecordId FROM BranchUnitRelatedRecord USING SCOPE EVERYTHING WHERE BranchUnitId IN(SELECT CurrentBranchId From Banker WHERE UserOrContactId = $User.Id))",
        "targetEntity": "Lead",
        "userCriteria": "$User.IsActive = true",
        "version": 1
    }
}
```

> 다른 객체(case, contact 등)용 scoping rule을 만들려면 `targetEntity` 값을 조정한다.

**POST로 생성:**

```
POST /services/data/v66.0/tooling/sobjects/RestrictionRule
```

요청 body에 정의를 복사하고 실행한다. 반환된 ID는 이후 참조를 위해 보관한다.

**Branch Rule On Account의 SOQL operator 해설(PDF 원문):**
- SOQL문은 scoping rule이 필터링하는 target entity인 account 객체에서 `Id`를 취하고, `BranchUnitCustomer` 객체에서 `AccountId`를 select한다.
- WHERE 절은 nested query로 `BranchUnitId`(각 branch의 고유 식별자)를 가져온다. nested query는 `Banker` 객체에서 `UserOrContactId`를 현재 로그인 사용자와 매칭해 각 banker의 current branch를 찾는다.
- SOQL query 객체와 scoping rule target entity는 같은 객체일 수 없다(여기서 query 객체=BranchUnitCustomer, targetEntity=account).
- SOQL 타입 RecordCriteria의 left operand는 단일 ID/reference 필드여야 한다(여기서는 target entity의 `Id`).

### Retrieve·Update·Delete (Tooling API)

GET·PATCH·DELETE 메서드를 쓴다.

**Retrieve (GET):**

```
GET /services/data/v66.0/tooling/query/?q=SELECT+id,+targetEntity,+enforcementType,+recordFilter,+userCriteria+FROM+RestrictionRule+WHERE+enforcementtype='Scoping'
```

**Update (PATCH):** `targetEntity` 값은 생성 후 업데이트하지 않기를 권장한다 — 대신 삭제하고 올바른 값으로 새로 만든다.

```
PATCH /services/data/v66.0/tooling/sobjects/RestrictionRule/0eYxxxxxxxxxxxx2AY
```

> `0eYxxxxxxxxxxxx2AY`는 생성 시 반환된 ID로 교체한다. 업데이트하지 않는 필드도 포함해 모든 Metadata 필드를 넣고, FullName은 변경할 때만 지정한다. 아래 예제는 `active`를 false로 설정해 rule을 비활성화한다.

```json
{
    "Metadata": {
        "active": false,
        "description": "sales support associate sees only account records of specified advisor",
        "enforcementType": "Scoping",
        "masterLabel": "Advisor1 Record Set",
        "recordFilter": "SOQL(id, SELECT Account__c FROM Client_Entitlement__c USING SCOPE EVERYTHING WHERE Team_Entitlement__c IN ( SELECT Team_Entitlement__c FROM User_Entitlement__c USING SCOPE EVERYTHING WHERE User__c = $User.id) )",
        "targetEntity": "Account",
        "userCriteria": "$User.ProfileId = '00exxxxxxxxxxxx'",
        "version": 1
    }
}
```

**Delete (DELETE):**

```
DELETE /services/data/v66.0/tooling/sobjects/RestrictionRule/0eYxxxxxxxxxxxx2AY
```

> Note(PDF 원문): userCriteria나 recordCriteria 필드에 Salesforce org ID가 포함돼 있고 다른 org로 배포한다면, 먼저 Salesforce ID를 수정한다.

---

## 생성 — Metadata API

`RestrictionRule` Metadata API type을 쓴다. 컴포넌트 suffix는 **`.rule`**, 저장 폴더는 **`restrictionRules`**.

**Step 1 — package.xml + 디렉터리 구성:**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
  <types>
    <members>*</members>
    <name>RestrictionRule</name>
  </types>
  <version>66.0</version>
</Package>
```

```
myPackage/package.xml
myPackage/restrictionRules
myPackage/restrictionRules/Rule1.rule
myPackage/restrictionRules/Rule2.rule
```

**예제 ① — BranchRuleOnAccount** (PDF 원문 XML):

```xml
<?xml version="1.0" encoding="UTF-8"?>
<RestrictionRule xmlns="http://soap.sforce.com/2006/04/metadata">
  <active>true</active>
  <description>Scoping rule where users can scope account records by the user’s current branch</description>
  <enforcementType>Scoping</enforcementType>
  <masterLabel>BranchRuleOnAccount</masterLabel>
  <recordFilter>SOQL(Id, SELECT AccountId FROM BranchUnitCustomer USING SCOPE EVERYTHING WHERE BranchUnitId IN(SELECT CurrentBranchId From Banker WHERE UserOrContactId = $User.Id))</recordFilter>
  <targetEntity>Account</targetEntity>
  <userCriteria>$User.IsActive = true</userCriteria>
  <version>1</version>
</RestrictionRule>
```

**예제 ② — BranchRuleOnLead** (PDF 원문 XML):

```xml
<?xml version="1.0" encoding="UTF-8"?>
<RestrictionRule xmlns="http://soap.sforce.com/2006/04/metadata">
  <active>true</active>
  <description>Scoping rule where users can scope lead records by their current branch</description>
  <enforcementType>Scoping</enforcementType>
  <masterLabel>BranchRuleOnLead</masterLabel>
  <recordFilter>SOQL(Id, SELECT RelatedRecordId FROM BranchUnitRelatedRecord USING SCOPE EVERYTHING WHERE BranchUnitId IN(SELECT CurrentBranchId From Banker WHERE UserOrContactId = $User.Id))</recordFilter>
  <targetEntity>Lead</targetEntity>
  <userCriteria>$User.IsActive = true</userCriteria>
  <version>1</version>
</RestrictionRule>
```

**Step 3 — 디렉터리를 zip해 배포.** `deploy()`·`retrieve()` 호출로 metadata XML을 Salesforce와 로컬 파일시스템 간 이동한다.

**삭제:** 컴포넌트 배포와 동일한 절차를 쓰되, 삭제할 컴포넌트를 나열한 **`destructiveChanges.xml`** delete manifest 파일을 포함한다.

> Note(PDF 원문): `targetEntity` 값은 생성 후 업데이트하지 않기를 권장 — 삭제 후 재생성. userCriteria/recordCriteria에 org-specific ID가 있고 다른 org로 배포하면 먼저 Salesforce ID를 수정한다.

---

## 예제 — Branch & Wealth Management

Wealth Management 시나리오: 여러 financial advisor를 지원하는 sales support associate에게, 함께 일하는 advisor에 해당하는 record set만 보여준다.

**Wealth Mgmt — Tooling API** (PDF 원문 JSON):

```json
{
    "FullName": "SalesSupportAssociateScopingRule",
    "Metadata": {
        "active": true,
        "description": "Sales support associate sees only account records of of Advisor1",
        "enforcementType": "Scoping",
        "masterLabel": "Advisor1 Record Set",
        "recordFilter": "SOQL(id, SELECT Account__c FROM Client_Entitlement__c USING SCOPE EVERYTHING WHERE Team_Entitlement__c IN ( SELECT Team_Entitlement__c FROM User_Entitlement__c USING SCOPE EVERYTHING WHERE User__c = $User.id) )",
        "targetEntity": "Account",
        "userCriteria": "$User.ProfileId = '00exxxxxxxxxxxx'",
        "version": 1
    }
}
```

> PDF 원문 그대로 (오타/불일치 포함, fabricate 아님): description의 `"...account records of of Advisor1"`는 **"of of" 중복 오타**가 PDF 원문에 그대로 있다.

POST URI도 PDF 원문 그대로:

```
POST /services/data/66.0/tooling/sobjects/RestrictionRule
```

> PDF 원문 그대로 (오타/불일치 포함, fabricate 아님): 이 URI는 다른 Tooling URI(`v66.0`)와 달리 **`66.0`**(접두 `v` 없음)으로 표기됨.

**Wealth Mgmt — Metadata API** (PDF 원문 XML; 이 예제는 SOQL operator가 아니라 `recordTypeId =` 방식):

```xml
<?xml version="1.0" encoding="UTF-8"?>
<RestrictionRule xmlns="http://soap.sforce.com/2006/04/metadata">
  <active>true</active>
  <description>Sales support associate sees only account records of specified advisor</description>
  <enforcementType>Scoping</enforcementType>
  <masterLabel>Advisor1 Record Type</masterLabel>
  <recordFilter>recordTypeId = '012xxxxxxxxxxxx'</recordFilter>
  <targetEntity>Account</targetEntity>
  <userCriteria>$User.ProfileId = '00exxxxxxxxxxxx'</userCriteria>
  <version>1</version>
</RestrictionRule>
```

> PDF 원문 그대로 (오타/불일치 포함, fabricate 아님): masterLabel이 **`Advisor1 Record Type`**로, Tooling 버전의 **`Advisor1 Record Set`**과 다르다. 또 recordFilter가 Tooling의 SOQL operator와 달리 `recordTypeId = '012...'` 단순 EQUALS다.

---

## Example Scenarios

각 시나리오는 Tooling(JSON)·Metadata(XML) 양쪽 정의를 전수한다.

**EDITIONS:** Available in: Lightning Experience in **Performance, Unlimited, and Developer** editions.

### 1. Display a Branch Location's Records by Default

custom field `Branch__c`에 bank branch location을 저장하고, 특정 branch와 연관된 task 레코드를 기본 표시.

```json
{
    "FullName":"Task scoping rule on Bank Branch 1",
    "Metadata": {
        "active":true,
        "description":"View tasks for Bank Branch 1.",
        "enforcementType":"Scoping",
        "masterLabel":"SR for Bank Branch 1",
        "recordFilter":"Branch__c = $User.Branch__c",
        "targetEntity":"Task",
        "userCriteria":"$User.UserRoleId = '00Exxxxxxxxxxxx'",
        "version":1
    }
}
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<RestrictionRule xmlns="http://soap.sforce.com/2006/04/metadata">
    <active>true</active>
    <description>View tasks for Bank Branch 1.</description>
    <enforcementType>Scoping</enforcementType>
    <masterLabel>SR for Bank Branch 1</masterLabel>
    <recordFilter>Branch__c = $User.Branch__c</recordFilter>
    <targetEntity>Task</targetEntity>
    <userCriteria>$User.UserRoleId = '00Exxxxxxxxxxxx'</userCriteria>
    <version>1</version>
</RestrictionRule>
```

### 2. Display a Department's Records by Default

contact owner의 department를 현재 사용자의 department와 동적으로 매칭.

```json
{
    "FullName":"Department A contact scoping rule",
    "Metadata": {
        "active":true,
        "description":"View contacts from Department A.",
        "enforcementType":"Scoping",
        "masterLabel":"SR for Department A",
        "recordFilter":"Department=$User.Department",
        "targetEntity":"Contact",
        "userCriteria":"$User.UserRoleId = '00Exxxxxxxxxxxx'",
        "version":1
    }
}
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<RestrictionRule xmlns="http://soap.sforce.com/2006/04/metadata">
    <active>true</active>
    <description>View tasks contacts from Department A.</description>
    <enforcementType>Scoping</enforcementType>
    <masterLabel>SR for Department A contacts</masterLabel>
    <recordFilter>Department=$User.Department</recordFilter>
    <targetEntity>Contact</targetEntity>
    <userCriteria>$User.UserRoleId = '00Exxxxxxxxxxxx'</userCriteria>
    <version>1</version>
</RestrictionRule>
```

> PDF 원문 그대로 (오타/불일치 포함, fabricate 아님): Metadata 예제의 description **`View tasks contacts from Department A.`**(`tasks contacts` — PDF 오타)와 masterLabel **`SR for Department A contacts`**가 Tooling 예제(`View contacts from Department A.` / `SR for Department A`)와 불일치한다.

### 3. Display a Division's Tasks by Default

```json
{
    "FullName":"Task scoping rule on current user’s Division",
    "Metadata": {
        "active":true,
        "description":"View tasks in the current user’s Division.",
        "enforcementType":"Scoping",
        "masterLabel":"SR for Divisions",
        "recordFilter":"Division=$User.Division",
        "targetEntity":"Task",
        "userCriteria":"$User.ProfileId = '00exxxxxxxxxxxx'",
        "version":1
    }
}
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<RestrictionRule xmlns="http://soap.sforce.com/2006/04/metadata">
    <active>true</active>
    <description>View tasks in the current user’s Division.</description>
    <enforcementType>Scoping</enforcementType>
    <masterLabel>SR for Divisions</masterLabel>
    <recordFilter>Division=$User.Division</recordFilter>
    <targetEntity>Task</targetEntity>
    <userCriteria>$User.ProfileId = '00exxxxxxxxxxxx'</userCriteria>
    <version>1</version>
</RestrictionRule>
```

### 4. Scope Records Using Multiple String or ID Values in Record Criteria

custom object `Agent__c`의 text 필드 `Name__c`를 콤마로 구분된 값과 매칭. 곡선 큰따옴표로 묶은 값 내부의 콤마는 구분자로 보지 않는다.

**4-A. 문자열 다중값 (Name__c):**

```json
{
    "FullName":"Agent records matching name field",
    "Metadata": {
        "active":true,
        "description":"Show Records Matching Name__c field",
        "enforcementType":"Scoping",
        "masterLabel":"Records Matching Name__c field",
        "recordFilter":"Name__c='Tom, Anita, “Torres, Jia”'",
        "targetEntity":"Agent__c",
        "userCriteria":"$User.IsActive=true",
        "version":1
    }
}
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<RestrictionRule xmlns="http://soap.sforce.com/2006/04/metadata">
    <active>true</active>
    <description>Show Records Matching Name__c field</description>
    <enforcementType>Scoping</enforcementType>
    <masterLabel>Records Matching Name__c field</masterLabel>
    <recordFilter>Name__c='Tom, Anita, “Torres, Jia”</recordFilter>
    <targetEntity>Agent__c</targetEntity>
    <userCriteria>$User.IsActive=true</userCriteria>
    <version>1</version>
</RestrictionRule>
```

> PDF 원문 그대로 (오타/불일치 포함, fabricate 아님): recordFilter 값의 큰따옴표는 PDF에서 **곡선따옴표 `“ ”`**(`"Torres, Jia"`를 묶어 콤마를 구분자에서 제외)로 표기됨. Tooling JSON은 닫는 작은따옴표 `'`가 있으나, **Metadata XML 버전은 닫는 작은따옴표가 누락**된 채(`Name__c='Tom, Anita, “Torres, Jia”` — 끝 `'` 없음) 출력된다.

**4-B. ID 다중값 (두 매니저 소유 레코드):** `Owner` 필드에 객체 타입(`:User`)을 명시한 dot notation 1-level lookup 예.

```json
{
    "FullName":"Records Owned By Managers",
    "Metadata": {
        "active":true,
        "description":"Displays records owned by two department managers",
        "enforcementType":"Scoping",
        "masterLabel":"RR for manager records",
        "recordFilter":"Agent__c.Owner:User.ManagerId=001xx000003HNy7, 001xx000003HNut",
        "targetEntity":"Agent__c",
        "userCriteria":"$User.IsActive=true",
        "version":1
    }
}
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<RestrictionRule xmlns="http://soap.sforce.com/2006/04/metadata">
    <active>true</active>
    <description>Displays records owned by two department managers</description>
    <enforcementType>Scoping</enforcementType>
    <masterLabel>RR for manager records</masterLabel>
    <recordFilter>Agent__c.Owner:User.ManagerId=001xx000003HNy7, 001xx000003HNut</recordFilter>
    <targetEntity>Agent__c</targetEntity>
    <userCriteria>$User.IsActive=true</userCriteria>
    <version>1</version>
</RestrictionRule>
```

> PDF 원문 그대로 (오타/불일치 포함, fabricate 아님): masterLabel이 **`RR for manager records`**(`RR` = restriction rule 접두처럼 보임)인데 `enforcementType`은 **`Scoping`**이다.

---

## Considerations

PDF "Considerations for Scoping Rules" 전 항목.

**EDITIONS:** Available in: Lightning Experience in Performance and Unlimited Editions.

**Creating Scoping Rules — edition별 활성 rule 한도:**
- **Developer** edition: 객체당 active scoping rule **최대 2개**.
- **Performance and Unlimited** edition: 객체당 active scoping rule **최대 5개**.
- 객체당·사용자당 scoping/restriction rule은 **하나만** — 주어진 객체에서 주어진 사용자에게 `userCriteria`가 true로 평가되는 scoping/restriction rule은 하나뿐이어야 한다.
- 여러 객체 데이터를 담은 report에서는 Filter by scope 선택 시 **관련된 모든 scoping rule이 적용**된다(예: account 필드를 추가한 opportunity report는 opportunity·account scoping rule 둘 다 고려).
- 객체에 scoping rule을 만들면 **그 객체에만** 영향을 주고 child 객체에는 영향이 없다.
- `Owner` 필드 참조 시 객체 타입을 명시(예: `Owner:User`) — queue는 미지원.
- dot notation은 targetEntity로부터 **1-level lookup만**(예: `Owner.UserRoleId`).
- 지원 데이터 타입: boolean, date(yyyy-MM-dd), dateTime(yyyy-MM-dd HH:mm:ss), double, int, reference, string, time, single picklist. Record Criteria에서 콤마 구분 ID/string 다중값 지원.
- null·blank 값은 record criteria에서 미지원 — 예기치 않은 동작 가능.
- `Event.IsGroupEvent`(event에 invitee가 있는지 표시)에 rule을 만들지 말 것.
- Open Activities / Activity History 대신 **Activity Timeline**을 쓸 것. Open Activities·Activity History related list를 쓴다면 `OpenActivity`·`ActivityHistory` 객체에만 있는 필드로 task/event rule을 만든다.
- list view·report에는 Metadata API로 scope 적용 가능(ListView 타입의 `filterScope` 필드, Report 타입의 `scope` 필드).
- recordFilter/userCriteria에 org-specific ID(role·record type·profile ID 등)를 넣으면, target org가 다를 경우 ID를 수정해야 한다(sandbox 간·production 배포 시 유의).

**Using SOQL:**
- record criteria에 SOQL operator는 **API로 scoping rule을 만들 때만** 사용 가능.
- SOQL을 쓰지 않으면 **`EQUALS` 연산자만** 지원, AND·OR 미지원.
- nested 포함 모든 SELECT문에 **`USING SCOPE EVERYTHING`** 필수 — 유일하게 유효한 scope clause.
- SOQL operator는 `$User.Id`만 지원, 그 외 dynamic query 미지원.
- SOQL Query 객체와 Scoping Rule 객체를 동일하게 쓰는 것은 미지원.
- SOQL 타입 RecordCriteria의 left operand는 단일 ID(primary key)/reference(foreign key) 필드여야 한다.
- SOQL operator 미지원 객체: ActivityHistory, Attachments, Event, EventAttendee, Note, OpenActivity, Tags(AccountTag·ContactTag 등 모든 tag 객체), Task.

**Modifying Scoping Rules:**
- 생성 후 `targetEntity` 편집 비권장 — 삭제 후 재생성.
- scoping rule을 disable하려면 먼저 Filter by scope가 선택된 list view·report를 삭제한다. disable 후에는 그 list view·report가 동작하지 않고 수정도 불가.
- userCriteria 필드는 **custom permission**을 지원. custom permission을 삭제하면 그것을 쓰는 scoping rule이 동작하지 않는다.
- record filter·user criteria의 **custom picklist value** 지원. 사용 중인 custom picklist value를 삭제하면 rule이 의도대로 동작하지 않는다.

**Accounts, Contacts, and Person Accounts:**
- account 객체의 `IsPersonAccount` 필드는 미지원 — `PersonDepartment`·`PersonLeadSource` 같은 IsPersonAccount 필드를 record filter criteria에 쓰지 말 것.
- account 객체에 scoping rule이 있을 때 Contacts list view에서 person account 상세 페이지로 이동하면 오류 가능 — `All Accounts` 같은 Accounts list view를 쓴다.
- related list에서는 scope와 무관하게 사용자가 접근 가능한 모든 연관 레코드가 보인다. **단 contact role related list는 예외** — contact 객체에 scoping rule이 적용되면 account·opportunity·case·contract 레코드의 contact role related list에도 scope가 적용된다.
- duplicate rule을 쓰는 org에서 scoping rule은 표시되는 잠재적 중복을 제한한다 — **Bypass sharing rules가 켜져 있어도** 중복 레코드는 scoping rule의 scope로 제한된다.

**Performance Considerations:**
- Salesforce는 비효율적이거나 데이터 모델 규모로 slowness를 유발하는 rule을 **비활성화할 권리**를 보유. throttling·deactivation을 막으려면 production 적용 전 sandbox에서 테스트한다.
- SOQL operator rule은 SELECT문을 API client에서 따로 실행해 성능을 테스트한다.
- 느린 rule은 성능을 떨어뜨리는 필드를 분리하고 Salesforce customer support와 색인 가능 여부를 확인한다.

---

## RestrictionRule API 레퍼런스 (Scoping·Restriction 공용)

`RestrictionRule`은 **restriction rule 또는 scoping rule**을 표현한다. EnforcementType이 `Restrict`면 지정 사용자의 레코드 접근을 제어하는 restriction rule, `Scoping`이면 접근을 제한하지 않고 기본 표시 레코드를 제어하는 scoping rule이다. **이 타입은 Tooling API object와 Metadata API type 양쪽으로 제공되며 API version 52.0 이상**에서 사용 가능하다.

### Tooling API object — Fields 12종

PascalCase 필드명. Tooling API object 표현.

| Field | Type | Properties | Description |
|---|---|---|---|
| Description | textarea | Filter, Group, Nillable, Sort | **Required.** The description of the rule. |
| DeveloperName | string | Filter, Group, Sort | The unique name for the RestrictionRule object. 밑줄·영숫자만 허용, org 내 고유, 문자로 시작, 공백 불가, 밑줄로 끝나거나 연속 밑줄 불가. 자동 생성되나 API로 레코드 생성 시 직접 값 지정 가능. View DeveloperName OR View Setup and Configuration 권한자만 조회·group·sort·filter 가능. |
| EnforcementType | picklist | Defaulted on create, Filter, Group, Restricted picklist, Sort | **Required.** The type of rule. 값: • FieldRestrict—Don't use. • Restrict—Restriction rule. • Scoping—Scoping rule. |
| FullName | string | Create, Group, Nillable | **Required.** Metadata API의 연관 RestrictionRule full name(namespaceprefix 포함 가능). query 결과가 1건 이하일 때만 이 필드를 query. 여러 건이면 error — 여러 query로 나눠 조회(성능 보호). |
| IsActive | boolean | Defaulted on create, Filter, Group, Sort | rule 활성(true)/비활성(false). 기본값 false. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | rule의 언어. org의 language 값. |
| MasterLabel | string | Filter, Group, Sort | Label for the rule. |
| Metadata | mns:RestrictionRule | Create, Nillable, Update | The restriction rule's metadata. query 결과가 1건 이하일 때만 query(여러 건이면 error, 성능 보호). |
| RecordFilter | textarea | Create, Filter, Group, Sort, Update | **Required.** rule로 접근 가능한 레코드를 결정하는 criteria. |
| TargetEntity | picklist | Filter, Group, Restricted picklist, Sort | **Required.** rule을 만드는 대상 객체. 생성 후 편집 비권장. (지원 객체는 아래 enforcementType 분기표) |
| UserCriteria | textarea | Create, Filter, Group, Sort, Update | **Required.** rule이 적용되는 사용자(전체 active 사용자, 특정 role/profile 등). |
| Version | int | Filter, Group, Sort | **Required.** The rule's version number. |

**TargetEntity 지원 객체 (enforcementType 분기):**

| enforcementType | 지원 객체 |
|---|---|
| **Restrict** | custom objects, external objects + Contract · Event · Quote · Task · TimeSheet · TimeSheetEntry |
| **Scoping** | custom objects + Account · Case · Contact · Event · Lead · Opportunity · Task |

> `FieldRestrict`는 **Don't use**(사용 금지). 위 지원 객체 분기는 `Restrict`·`Scoping` 두 값에만 정의됨.

**Usage 예제 (Tooling):** restriction rule 표현 — `OwnerId = $User.Id` / `enforcementType: Restrict` / `targetEntity: Task` (FullName `restriction_rule_tasks_you_own`). scoping rule 표현 — `Department=$User.Department` / `enforcementType: Scoping` / `targetEntity: Contact`(위 Example Scenario 2의 Tooling 예제와 동일 payload).

### Metadata API type — Fields 8종

camelCase 필드명. Metadata API type 표현. **이 타입은 Metadata metadata type을 extend하고 그 `fullName` 필드를 상속**한다. 컴포넌트 suffix `.rule`, 저장 폴더 `restrictionRules`, API version 52.0 이상.

| Field Name | Field Type | Description |
|---|---|---|
| active | boolean | rule 활성(true)/비활성(false). 기본값 false. |
| description | string | **Required.** The description of the rule. |
| enforcementType | EnforcementType (enumeration of type string) | **Required.** 값: • FieldRestrict—Don't use. • Restrict—Restriction rule. • Scoping—Scoping rule. |
| masterLabel | string | **Required.** The name of the rule. |
| recordFilter | string | **Required.** rule로 접근 가능한 레코드를 결정하는 criteria. |
| targetEntity | string | **Required.** rule을 만드는 대상 객체. 생성 후 편집 비권장. (지원 객체 분기는 위 표와 동일) |
| userCriteria | string | **Required.** rule이 적용되는 사용자. |
| version | int | **Required.** The rule's version number. |

> Metadata API type의 `targetEntity` 지원 객체 분기는 Tooling object와 동일하다(Restrict: Contract/Event/Quote/Task/TimeSheet/TimeSheetEntry + custom/external; Scoping: Account/Case/Contact/Event/Lead/Opportunity/Task + custom).

**Sample Definition (Metadata):** restriction rule(`OwnerId = $User.Id`, `Restrict`, Task), scoping rule(`Department=$User.Department`, `Scoping`, Contact), 그리고 이를 참조하는 package.xml. 마지막 package.xml의 version은 아래와 같이 다른 예제(66.0)와 다르다.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
    <types>
        <members>*</members>
        <name>RestrictionRule</name>
    </types>
    <version>55.0</version>
</Package>
```

> PDF 원문 그대로 (오타/불일치 포함, fabricate 아님): 이 package.xml의 `<version>`은 **`55.0`**으로, Quick Start의 다른 package.xml 예제(`66.0`)와 다르다.

### Tooling vs Metadata 필드명 매핑

| 개념 | Tooling API object (PascalCase) | Metadata API type (camelCase) |
|---|---|---|
| 활성화 | IsActive (boolean) | active (boolean) |
| 설명 | Description (textarea) | description (string) |
| 시행 타입 | EnforcementType (picklist) | enforcementType (EnforcementType enum) |
| 풀네임 | FullName (string) | fullName — Metadata 타입에서 상속(표에 별도 미기재) |
| 레이블 | MasterLabel (string) | masterLabel (string) |
| 레코드 필터 | RecordFilter (textarea) | recordFilter (string) |
| 대상 객체 | TargetEntity (picklist) | targetEntity (string) |
| 사용자 기준 | UserCriteria (textarea) | userCriteria (string) |
| 버전 | Version (int) | version (int) |
| Tooling 전용 | DeveloperName · Language · Metadata | — |

> Tooling REST payload 구조: `{ FullName, Metadata: { active, description, enforcementType, masterLabel, recordFilter, targetEntity, userCriteria, version } }` — 최상위는 `FullName`(PascalCase) + `Metadata`, `Metadata` 블록 내부는 camelCase.

### enforcementType enum

| 값 | 의미 |
|---|---|
| `FieldRestrict` | **Don't use.** (사용 금지) |
| `Restrict` | Restriction rule. |
| `Scoping` | Scoping rule. |

### SOAP/REST 호출·Special Access

- **Supported SOAP API Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST API Methods:** `DELETE`, `GET`, `HEAD`, `PATCH`, `POST`, `Query`
- **Special Access Rules:** **View Restriction and Scoping Rules** 권한자만 API로 restriction/scoping rule을 조회할 수 있다. **Manage Sharing** 권한자만 조회·생성·수정·삭제할 수 있다.

---

## 관련 노트
- [[레코드 액세스 설계 (Enterprise Scale)]]
- [[Permission Set 설계]]
- [[Metadata Types — Security & Access]]
- [[SOQL 문법 레퍼런스]]
- [[Share Objects]]
