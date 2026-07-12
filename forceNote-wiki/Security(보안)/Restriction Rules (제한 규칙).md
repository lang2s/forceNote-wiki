---
tags: [security, record-access, restriction-rule, sharing, owd, visibility, tooling-api, metadata-api]
source: restriction_rules.pdf (Restriction Rules Developer Guide, Version 67.0 Summer '26, Last updated July 10 2026, resources.docs.salesforce.com/latest/latest/en-us/sfdc/pdf/restriction_rules.pdf, 접속 2026-07-11, Tier 2)
created: 2026-07-11
aliases: [Restriction Rules, 제한 규칙, RestrictionRule, enforcementType Restrict, recordFilter, record-level restriction, 레코드 접근 제한]
---

# Restriction Rules (제한 규칙)

> 사용자가 이미 접근 권한을 가진 레코드 집합을 **기준(recordFilter)에 맞는 것만 남기도록 영구적으로 좁히는** record-level 보안 통제. OWD·공유 규칙으로 열린 접근을 **되돌릴 수 없게 필터**한다. `RestrictionRule` 메타 타입을 `enforcementType=Restrict`로 만든다. (`restriction_rules.pdf` v67.0 전수)

> [!note] 이 노트는 **Restriction Rule의 개념·차이·설정·시나리오**에 집중한다. `RestrictionRule` Tooling/Metadata API 타입의 **전체 필드 레퍼런스(12/8 필드·SOAP/REST 호출·필드명 매핑)** 는 Scoping Rule과 공용이므로 [[Scoping Rules]] 노트의 "RestrictionRule API 레퍼런스" 섹션에 정리돼 있다. 여기서는 Restrict 전용 사항만 다룬다.

---

## 개요 — Restriction Rule이란

Restriction rule은 특정 사용자가 **지정된 레코드에만 접근**하도록 허용해 보안을 강화한다. 민감하거나 업무에 불필요한 데이터가 담긴 레코드에 대한 접근을 막을 수 있다.

> PDF 원문: *"Restriction rules let you enhance your security by allowing certain users to access only specified records. They can prevent users from accessing records that can contain sensitive data or information that isn't essential to their work."*

핵심 동작 — restriction rule이 어떤 사용자에게 적용되면, **OWD·공유 규칙·기타 공유 메커니즘으로 그 사용자가 read 접근을 얻은 데이터가 `recordFilter` 기준에 맞는 레코드로 다시 좁혀진다.** 이는 list view나 report를 필터링하는 것과 비슷하지만 **영구적(permanent)** 이다.

> PDF 원문: *"When a restriction rule is applied to a user, the data that they had read access to via your sharing settings is further scoped to only records matching the recordFilter. This behavior is similar to how you can filter results in a list view or report, except that it's permanent."*

- 사용자가 restriction rule 적용 후 더 이상 접근할 수 없는 레코드 링크를 클릭하면 **error message**를 본다.
- Today's Tasks 탭이나 activity list view 등에서는 rule 기준을 만족하는 레코드만 보인다.
- 보이는 레코드 수는 `recordFilter` 값에 따라 크게 달라진다.

**언제 쓰나 (When Do I Use Restriction Rules?):** 특정 사용자가 **특정 레코드 집합만** 보게 하고 싶을 때. 특히 **contract·task·event**는 OWD만으로 진정한 private 설정이 어려워 restriction rule이 최선의 방법이다. 예: 같은 account 위의 activity라도 경쟁하는 두 sales team이 서로의 것을 못 보게 하거나, 기밀 서비스 대상 개인의 관련 task를 담당 팀원만 보게 한다.

**EDITIONS:** Lightning Experience in **Enterprise, Performance, Unlimited, and Developer** editions.

> [!warning] **Salesforce Classic를 끄고 쓴다.** restriction rule 생성 전 org의 Salesforce Classic를 Turn Off하도록 권장 — Classic 사용자에게는 rule이 의도대로 동작함을 보장하지 못한다.

---

## Restriction vs Scoping — 같은 타입, 반대 목적

둘 다 **동일한 `RestrictionRule` 메타 타입**으로 만들고 `enforcementType` 값으로만 갈린다. 그러나 효과의 성격이 정반대다.

|  | **Restriction Rule** (`Restrict`) | **Scoping Rule** (`Scoping`) |
|---|---|---|
| 목적 | 레코드 접근을 **제한**(보안 경계) | 기본 표시 범위를 **좁힘**(포커스) |
| 접근 권한 | **실제로 제거** — 필터 밖 레코드는 못 봄 | **불변** — 사용자는 여전히 모든 접근 가능 레코드 열람·report 가능 |
| 되돌릴 수 있나 | **아니오, 영구 적용**(항상 강제) | 예 — **쿼리별(query-by-query) on/off** (Filter by scope) |
| 성격 | 강제 보안 통제 | 편의성 표시 필터 |
| 지원 객체 | custom · external + Contract·Event·Quote·Task·TimeSheet·TimeSheetEntry | custom + Account·Case·Contact·Event·Lead·Opportunity·Task |
| SOQL operator | **미지원** | 지원 (`SOQL(...)`, `USING SCOPE EVERYTHING`) |

> 요지: **Restriction = "볼 수 없게 막는다"(security), Scoping = "기본으로 이것만 보여준다"(default view, 원하면 벗어날 수 있음)**. Restriction은 사용자가 스스로 필터를 끌 수 없으므로 보안 경계가 되고, Scoping은 Filter by scope를 끄면 원래 공유 범위를 다시 볼 수 있다. 두 규칙의 공용 API 타입·필드는 [[Scoping Rules]] 참조.

---

## 다른 공유 설정과의 관계 (OWD·공유 규칙)

사용자는 먼저 **OWD·공유 규칙·enterprise territory management** 등으로 레코드 접근을 얻는다. 그 위에 restriction rule이 적용되면 그 접근이 `recordFilter`에 맞는 레코드로 **한 번 더 좁혀진다.** 즉 restriction rule은 접근을 **넓히지 않고 오직 좁히기만** 한다 — 공유가 준 것 위에 얹는 **한 방향 필터**다.

**우회·예외 (권한이 restriction rule을 이긴다):**
- **View All Records / View All Data** 권한자는 restriction rule과 무관하게 모든 레코드를 **조회**할 수 있다.
- **Modify All Records / Modify All Data** 권한자는 restriction rule과 무관하게 모든 레코드를 **조회·수정·삭제**할 수 있다.
- **System Mode로 실행되는 코드에는 restriction rule이 적용되지 않는다** (Apex 등).
- **child 객체는 자동 제한되지 않는다** — 예: Contract에 rule을 만들어도 그 contract에 연결된 notes 접근은 변하지 않는다. child를 보호하려면 별도 공유 메커니즘을 쓴다.
- `UserRecordAccess` 객체는 restriction rule로 인한 접근 차단을 **고려하지 않는다** — 쿼리가 접근 가능하다고 해도 실제로는 rule에 막힐 수 있다.

> 오브젝트 권한(View All/Modify All)이 restriction rule을 우회하는 정확한 의미는 [[Object Permissions (오브젝트 권한 — CRUD·View All·Modify All)]] 참조.

---

## 지원 객체 · 적용 기능 · 한도

### 지원 객체 (Available Objects)

restriction rule은 다음에서 가능하다 — **custom objects, external objects, contracts, events, quotes, tasks, time sheets, time sheet entries.**

> PDF 원문: *"Restriction rules are available for custom objects, external objects, contracts, events, quotes, tasks, time sheets, and time sheet entries."*

### 적용되는 기능 (Applicable Features)

restriction rule은 아래 Salesforce 기능들에 적용된다:

- **Links · List Views · Lookups · Records · Related Lists · Reports · Search · SOQL · SOSL**

### 한도 (오브젝트당 active rule 수)

| Edition | 오브젝트당 active restriction rule 한도 |
|---|---|
| **Enterprise · Developer** | 최대 **2개** |
| **Performance · Unlimited** | 최대 **5개** |

- **오브젝트당·사용자당 rule은 하나만** — 주어진 객체에서 한 사용자에게 `userCriteria`가 true로 평가되는 restriction/scoping rule은 **하나만** 있어야 한다. Salesforce는 이를 검증하지 않으며, 두 active rule이 한 사용자에게 걸리면 **하나만 관찰(observed)** 된다.

---

## 설정 — recordFilter · userCriteria · enforcementType

restriction rule은 **Object Manager**(지원 객체로 이동)나 **Tooling API / Metadata API**로 만든다. 생성·관리 절차·payload 구조(POST/GET/PATCH/DELETE, package.xml, `.rule` 파일, `restrictionRules` 폴더)는 Scoping과 동일하므로 [[Scoping Rules]]의 "생성 — Tooling API / Metadata API" 참조. 여기서는 **Restrict에 고유한 필터 규칙**만 정리한다.

**필수 필드 4종(개념):** `enforcementType=Restrict` · `targetEntity`(대상 객체) · `recordFilter`(남길 레코드 조건) · `userCriteria`(rule이 적용될 사용자). 그 외 `active`·`masterLabel`·`description`·`version`.

### recordFilter — 남길 레코드 조건

`recordFilter`는 rule로 **접근 가능하게 남길** 레코드를 결정하는 criteria다.

- **`EQUALS` 연산자만 지원.** `AND`·`OR` 등 다른 연산자 **미지원.**
- **formula 미지원.**
- **SOQL operator 미지원** (이건 scoping rule 전용 — restriction rule은 못 씀).
- 지원 데이터 타입: `boolean`, `date`, `dateTime`, `double`, `int`, `reference`, `string`, `time`, `single picklist`.
- **콤마 구분 다중 ID/string** 값 지원. 큰따옴표로 묶은 값 안의 콤마는 구분자로 보지 않는다.
- **null·blank 값 미지원** — 예기치 않은 동작을 유발할 수 있다.
- **dot notation은 1-level만** (targetEntity로부터 한 단계 lookup). 예: `Owner.UserRoleId`.
- **Owner 참조 시 객체 타입 명시** — 예: `Owner:User` (queue는 미지원이므로 user만 허용할 때).
- **ID는 15자리** 사용 권장(18자리 대신).
- lookup 필드를 쓰는데 관련 레코드가 없으면 **접근이 부여되지 않는다.**
- **custom picklist value** 지원 — 사용 중인 값을 삭제하면 rule이 의도대로 동작하지 않는다.

```
// 구조 예시 — recordFilter 값 발췌 모음 (PDF 원문, 실행 코드 아님)
recordTypeId = '011xxxxxxxxxxxx'          // 특정 record type만
OwnerId = $User.Id                         // 자기가 소유한 레코드만
Owner:User.UserRoleId = $User.UserRoleId   // 같은 role 사용자 소유 레코드만
Owner:User.ProfileId = $User.ProfileId     // 같은 profile 사용자 소유 레코드만
Department__c = $User.Department           // custom 필드로 department 매칭
```

### userCriteria — 적용 대상 사용자

rule이 적용되는 사용자 집합을 지정한다. 예: `$User.IsActive = true`(모든 active 사용자), `$User.ProfileId = '00e...'`(특정 profile), `$User.UserRoleId = '00E...'`(특정 role), `$User.UserType = 'CSPLitePortal'`(high-volume portal 사용자). custom permission·custom picklist value도 지원.

### 배포 시 org ID 주의

`recordFilter`·`userCriteria`에 org 고유 ID(role·record type·profile ID 등)를 넣으면, **다른 org(sandbox↔production)로 배포할 때 그 ID를 대상 org에 맞게 수정**해야 한다. rule은 change set·unlocked package로 이동 가능하다.

---

## 예제 시나리오 (PDF Example Scenarios — recordFilter 발췌)

각 시나리오의 전체 Tooling(JSON)·Metadata(XML) 정의는 PDF 원문 기준. 아래는 핵심 필드만 압축.

| 시나리오 | targetEntity | recordFilter | userCriteria |
|---|---|---|---|
| **특정 record type만** (Internal Contract) | Contract | `RecordTypeId = '012xxx'` | `$User.UserRoleId = '00Exxx'` |
| **자기 소유 레코드만** | Task | `OwnerId = $User.Id` | `$User.ProfileId = '00exxx'` |
| **같은 role 소유 레코드만** | Event | `Owner:User.UserRoleId = $User.UserRoleId` | `$User.IsActive = true` |
| **같은 profile 소유 레코드만** | Event | `Owner:User.ProfileId = $User.ProfileId` | `$User.IsActive = true` |
| **custom 필드로 department 매칭** | Contract | `Department__c = $User.Department` | `$User.UserType = 'CSPLitePortal'` |
| **external object의 open 레코드만** | PurchaseOrder__x | `IsClosed__c = 'false'` | `$User.Department = 'Accounting'` |
| **여러 이름 값 매칭 (콤마+큰따옴표)** | Agent__c | `Name__c='Tom, Anita, "Torres, Jia"'` | `$User.IsActive=true` |
| **두 매니저 소유 레코드 (콤마 구분 ID)** | Agent__c | `Agent__c.Owner:User.ManagerId=001xx...HNy7, 001xx...HNut` | `$User.IsActive=true` |

**Tooling API 전체 예 — 자기 소유 task만** (PDF 원문 JSON):

```json
{
  "FullName": "restriction_rule_tasks_you_own",
  "Metadata": {
    "active": true,
    "description": "Allows users of a specific profile to see only tasks that they own.",
    "enforcementType": "Restrict",
    "masterLabel": "Tasks You Own",
    "recordFilter": "OwnerId = $User.Id",
    "targetEntity": "Task",
    "userCriteria": "$User.ProfileId = '00exxxxxxxxxxxx'",
    "version": 1
  }
}
```

**Metadata API 전체 예 — 같은 role 소유 event만** (PDF 원문 XML):

```xml
<?xml version="1.0" encoding="UTF-8"?>
<RestrictionRule xmlns="http://soap.sforce.com/2006/04/metadata">
  <active>true</active>
  <description>Allows active users to see only events owned by users of the same role.</description>
  <enforcementType>Restrict</enforcementType>
  <masterLabel>Events Owned by Same Role</masterLabel>
  <recordFilter>Owner:User.UserRoleId = $User.UserRoleId</recordFilter>
  <targetEntity>Event</targetEntity>
  <userCriteria>$User.IsActive = true</userCriteria>
  <version>1</version>
</RestrictionRule>
```

---

## Considerations (주의사항 — PDF 전 항목)

**동작·표시:**
- **calendar에서 Show Details 접근 레벨**이 선택돼 있으면 사용자는 restriction rule과 무관하게 **모든 event의 subject를 볼 수 있다.**
- 사용자는 자신의 **subordinate의 event**를 calendar에서 볼 수 있다(active restriction rule이 있어도).
- **global search box shortcuts**에는 rule 적용 후에도 이전에 접근했던 레코드가 보일 수 있으나, 이름을 클릭하면 접근 불가 error가 난다.
- **Chatter publisher**로 만든 event·task의 레코드 이름은 관련 Chatter post에 보인다 — restriction rule이 이 이름 표시를 막지 않는다.
- restriction rule로 볼 수 없는 레코드에 대한 **lookup을 가진 레코드는 clone할 수 없다**(error).
- **search crowding** — 성능상 검색 결과 수에 제한이 걸려, 찾는 레코드가 그 범위 밖으로 밀릴 수 있다.

**Activity related list:**
- **Open Activities·Activity History related list 대신 Activity Timeline을 쓴다.** related list를 쓴다면 그 list에만 있는 필드로 task/event rule을 만든다.
- Open Activities·Activity History related list는 최대 50개만 표시하고 restriction rule은 그 뒤에 적용되므로, 실제 접근 가능한 activity가 더 많아도 **50개 미만**이 표시될 수 있다(알려진 이슈).

**생성:**
- `Event.IsGroupEvent`(event에 invitee 유무 표시)에 rule을 만들지 말 것.
- 생성 후 `targetEntity` 편집 비권장 — 삭제 후 재생성.

**External object 전용:**
- **Salesforce Connect: OData 2.0 · OData 4.0 · Cross-Org adapter**로 만든 external object만 restriction rule 지원. **custom adapter는 미지원.**
- **external object의 restriction rule에는 OWD·공유 메커니즘이 포함되지 않는다.**
- Cross-Org adapter external object는 rule 적용 시 search·SOSL 미지원(최근 조회 레코드만 반환) — search 끄기 권장.
- external object는 Object Manager에 안 나온다 — Setup의 **External Data Sources**로 이동.
- external object rule의 편집·삭제는 추가 DB 호출을 유발(외부 소스가 호출당 과금하면 추가 비용). external ID를 record criteria에 쓰는 것 비권장.

**Performance:**
- rule 성능 영향 테스트 — record criteria 쿼리를 API client에서 실행. 특정 사용자에게 빠르면 rule도 효율적. 대용량 객체는 record filter 성능에 **3~5% overhead**를 더해 본다.
- 느리면 문제 필드를 분리하고 Salesforce customer support와 색인 가능 여부 확인. **indexed 필드만** 쓰기 권장(특히 record criteria).

**USER PERMISSIONS:**
- 생성·관리: **Manage Sharing**
- 조회: **View Setup & Configuration** AND **View Restriction and Scoping Rules**

---

## 관련 노트
- [[Scoping Rules]]
- [[조직 전체 공유 기본값(OWD)과 공유 규칙]]
- [[Object Permissions (오브젝트 권한 — CRUD·View All·Modify All)]]
- [[Salesforce 권한 모델 개요]]
