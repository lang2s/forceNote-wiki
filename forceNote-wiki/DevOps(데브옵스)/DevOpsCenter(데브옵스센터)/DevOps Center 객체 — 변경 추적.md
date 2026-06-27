---
tags: [devops, devops-center, object-reference, change-tracking, source-member, remote-change, object-activity]
source: devops_center_dev.pdf (Salesforce DevOps Center Developer Guide v67.0, Summer '26)
created: 2026-06-27
aliases: [Remote Change, Hidden Remote Change, Source Member Reference, Object Activity, sf_devops__Remote_Change__c, sf_devops__Hidden_Remote_Change__c, sf_devops__Source_Member_Reference__c, sf_devops__Object_Activity__c, 변경 추적, 원격 변경, 소스 멤버 참조, 객체 활동]
---

# DevOps Center 객체 — 변경 추적

> DevOps Center가 환경의 메타데이터 변경을 추적·표시하는 4개 커스텀 객체(Remote Change, Hidden Remote Change, Source Member Reference, Object Activity)의 필드 레퍼런스.

DevOps Center는 개발 환경에서 발생한 메타데이터 변경을 추적해 work item으로 pull할 수 있게 표시한다. 이 변경 추적 메커니즘의 핵심 동작은 *How DevOps Center Keeps Track of User Changes* 문서에서 설명된다 — 본 노트는 그 흐름에 관여하는 4개 객체의 객체 레퍼런스(필드 전수)를 다룬다.

> 모든 객체는 DevOps Center가 설치된 모든 org에서 사용 가능하다(This object is available in all orgs that have DevOps Center installed).

---

## Remote Change (sf_devops__Remote_Change__c)

DevOps Center에 연결된 환경에 대한 변경을 나타낸다. 특히 Remote Change 레코드는 특정 메타데이터 조각에 대한 작업의 누적(accumulation of operations on a particular piece of metadata)을 나타낸다. DevOps Center는 이 변경을 사용자에게 표시해, 사용자가 자신의 work item으로 pull하고 연관된 feature branch에 commit할 수 있게 한다. 자세한 내용은 *How DevOps Center Keeps Track of User Changes* 참조.

### Supported Calls

```
create(), delete(), describeLayout(), describeSObjects(), getDeleted(), getUpdated(), query(),
retrieve(), undelete(), update(), upsert()
```

### Fields

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| `Name` | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | Name of this Remote Change record. |
| `sf_devops__Change_Submission__c` | reference | Create, Filter, Group, Nillable, Sort, Update | 이 remote change가 이미 feature branch에 commit되었다면, 연관된 Change Submission 레코드에 대한 참조를 담는다. |
| `sf_devops__Environment__c` | reference | Create, Filter, Group, Sort | 이 remote change가 연관된 환경에 대한 참조. |
| `sf_devops__Member_Name__c` | string | Create, Filter, Group, Sort, Update | 이 remote change가 나타내는 메타데이터 컴포넌트의 이름. |
| `sf_devops__Member_Type__c` | string | Create, Filter, Group, Sort, Update | 이 remote change가 나타내는 메타데이터 type. |
| `sf_devops__Remote_Change_By__c` | string | Create, Filter, Group, Sort, Update | 환경에서 메타데이터 변경을 만든 사용자의 username. |
| `sf_devops__Remote_Change_On__c` | dateTime | Create, Filter, Sort, Update | 메타데이터 변경이 발생한 날짜·시간. |
| `sf_devops__Remote_Change_Type__c` | picklist | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort, Update | 메타데이터가 어떻게 변경되었는지. |
| `sf_devops__Source_Component__c` | string | Filter, Nillable, Sort | Member Type와 Member Name 필드의 조합. *(calculated field)* |

**Relationship 필드 상세**

- `sf_devops__Change_Submission__c` — Relationship Name: `sf_devops__Change_Submission__r` / Type: Lookup / Refers To: `sf_devops__Change_Submission__c`
- `sf_devops__Environment__c` — Relationship Name: `sf_devops__Environment__r` / Type: **Master-detail** / Refers To: `sf_devops__Environment__c`

**`sf_devops__Remote_Change_Type__c` Possible values** (Restricted picklist):

- ADD
- CHANGE
- MANUAL
- REMOVE
- RENAME

The default value is `ADD`.

---

## Hidden Remote Change (sf_devops__Hidden_Remote_Change__c)

Remote Change 레코드를 work item에서 숨기는 데 사용된다. 대표적 사용 사례는 work item에 연관된 feature branch가 `.forceignore` 파일을 가지고 있어 그 Remote Change 레코드가 나타내는 메타데이터를 제외하는 경우다. 자세한 내용은 *How DevOps Center Keeps Track of User Changes* 참조.

### Supported Calls

```
create(), delete(), describeLayout(), describeSObjects(), getDeleted(), getUpdated(), query(),
retrieve(), undelete(), update(), upsert()
```

### Fields

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| `Name` | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | Name of this Hidden Remote Change record. |
| `sf_devops__Hidden_by_Force_Ignore__c` | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | true이면, `.forceignore` 규칙에 매칭되었기 때문에 이 Remote Change가 work item에서 숨겨졌음을 지정한다. |
| `sf_devops__Remote_Change__c` | reference | Create, Filter, Group, Sort | 숨겨진 Remote Change 레코드에 대한 참조. |
| `sf_devops__Work_Item__c` | reference | Create, Filter, Group, Sort | 숨겨졌기 때문에 Remote Change 레코드를 볼 수 없는 work item에 대한 참조. |

**`sf_devops__Hidden_by_Force_Ignore__c`** — The default value is `false`.

**Relationship 필드 상세**

- `sf_devops__Remote_Change__c` — Relationship Name: `sf_devops__Remote_Change__r` / Type: **Master-detail** / Refers To: `sf_devops__Remote_Change__c`
- `sf_devops__Work_Item__c` — Relationship Name: `sf_devops__Work_Item__r` / Type: **Master-detail** / Refers To: `sf_devops__Work_Item__c`

---

## Source Member Reference (sf_devops__Source_Member_Reference__c)

개발 환경의 SourceMember Tooling API 레코드에서 관련 정보를 복사한 사본을 나타낸다. DevOps Center는 사용자가 아직 자신의 work item으로 pull하지 않은 메타데이터 변경을 추적하기 위해 이 데이터를 복사한다. 데이터를 복사하면 Remote Change 레코드 계산도 더 효율적이 된다. 자세한 내용은 *How DevOps Center Keeps Track of User Changes* 참조.

### Supported Calls

```
create(), delete(), describeLayout(), describeSObjects(), getDeleted(), getUpdated(), query(),
retrieve(), undelete(), update(), upsert()
```

### Fields

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| `Name` | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | Name of this Source Member Reference record. |
| `sf_devops__Remote_Change__c` | reference | Create, Filter, Group, Sort | 이 Source Member Reference 레코드가 연결된 Remote Change 레코드에 대한 참조. |
| `sf_devops__Revision_Counter__c` | double | Create, Filter, Sort, Update | 연관된 SourceMember Tooling API 레코드의 RevisionCounter 필드 값. |
| `sf_devops__Source_Member_Id__c` | string | Create, Filter, Group, Sort, Update | 연관된 SourceMember Tooling API 레코드의 ID. |

**Relationship 필드 상세**

- `sf_devops__Remote_Change__c` — Relationship Name: `sf_devops__Remote_Change__r` / Type: **Master-detail** / Refers To: `sf_devops__Remote_Change__c`

> 참고: 이 객체는 Tooling API의 SourceMember 레코드를 미러링한다(`Tooling API Developer Guide: SourceMember`).

---

## Object Activity (sf_devops__Object_Activity__c)

DevOps Center 커스텀 객체 중 하나에 의한 활동(activity)을 나타낸다. Object Activity 레코드는 work item과 pipeline의 Activity History에 나열되는 항목을 결정한다. DevOps Center가 작업을 수행하면 activity 레코드를 만들어 적절한 사용자 인터페이스 view에 삽입하며, 각 activity는 연관된 커스텀 객체를 참조한다. 예를 들어, 사용자가 work item을 promote하면 DevOps Center는 promotion initiation activity를 work item Activity History에 삽입하고, 그 activity는 Work Item과 Pipeline Stage 객체를 참조한다. promotion이 종료되면 DevOps Center는 동일한 두 객체와 Async Operation Result를 참조하는 두 번째 activity를 삽입한다.

### Supported Calls

```
create(), delete(), describeLayout(), describeSObjects(), getDeleted(), getUpdated(), query(),
retrieve(), search(), undelete(), update(), upsert()
```

> 다른 세 객체와 달리 Object Activity의 Supported Calls에는 `search()`가 포함된다.

### Fields

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| `Name` | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | Name of this Object Activity record. |
| `sf_devops__Activity_Date__c` | dateTime | Create, Filter, Sort, Update | activity가 발생한 날짜·시간. |
| `sf_devops__Activity_Type__c` | string | Create, Filter, Group, Sort, Update | 수행된 activity의 type. |
| `sf_devops__Change_Submission__c` | reference | Create, Filter, Group, Nillable, Sort, Update | 이 activity와 연관된 Change Submission 레코드에 대한 참조. |
| `sf_devops__Environment__c` | reference | Create, Filter, Group, Nillable, Sort, Update | 이 activity와 연관된 Environment 레코드에 대한 참조. |
| `sf_devops__Hidden__c` | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | true이면, 이 activity는 내부 bookkeeping 전용이며 DevOps Center가 Activity History view에 포함하지 않는다. |
| `sf_devops__Operation_Result__c` | reference | Create, Filter, Group, Nillable, Sort, Update | 이 activity와 연관된 Async Operation Result 레코드에 대한 참조. |
| `sf_devops__Parent_Activity__c` | reference | Create, Filter, Group, Nillable, Sort, Update | parent activity가 이 activity를 트리거한 경우, 그 parent activity에 대한 참조. 예를 들어, change bundle의 promotion은 그 change bundle에서 promote된 모든 work item을 나타내는 child activity들을 트리거한다. |
| `sf_devops__Pipeline__c` | reference | Create, Filter, Group, Nillable, Sort, Update | 이 activity와 연관된 Pipeline 레코드에 대한 참조. |
| `sf_devops__Project__c` | reference | Create, Filter, Group, Sort | 이 activity가 속한 parent project에 대한 참조. |
| `sf_devops__Summary__c` | string | Create, Filter, Group, Sort, Update | 이 activity에 대해 Activities History view에 표시되는 summary. |
| `sf_devops__Target_Pipeline_Stage__c` | reference | Create, Filter, Group, Nillable, Sort, Update | 이 activity와 연관된 Pipeline Stage 레코드에 대한 참조. |
| `sf_devops__Work_Item__c` | reference | Create, Filter, Group, Nillable, Sort, Update | 이 activity와 연관된 Work Item 레코드에 대한 참조. |

**`sf_devops__Hidden__c`** — The default value is `false`.

**Relationship 필드 상세**

| 필드 | Relationship Name | Type | Refers To |
|---|---|---|---|
| `sf_devops__Change_Submission__c` | `sf_devops__Change_Submission__r` | Lookup | `sf_devops__Change_Submission__c` |
| `sf_devops__Environment__c` | `sf_devops__Environment__r` | Lookup | `sf_devops__Environment__c` |
| `sf_devops__Operation_Result__c` | `sf_devops__Operation_Result__r` | Lookup | `sf_devops__Async_Operation_Result__c` |
| `sf_devops__Parent_Activity__c` | `sf_devops__Parent_Activity__r` | Lookup | `sf_devops__Object_Activity__c` |
| `sf_devops__Pipeline__c` | `sf_devops__Pipeline__r` | Lookup | `sf_devops__Pipeline__c` |
| `sf_devops__Project__c` | `sf_devops__Project__r` | **Master-detail** | `sf_devops__Project__c` |
| `sf_devops__Target_Pipeline_Stage__c` | `sf_devops__Target_Pipeline_Stage__r` | Lookup | `sf_devops__Pipeline_Stage__c` |
| `sf_devops__Work_Item__c` | `sf_devops__Work_Item__r` | Lookup | `sf_devops__Work_Item__c` |

---

## 관련 노트
- [[DevOps Center 데이터 모델 개요]]
- [[DevOps Center 객체 — 파이프라인·프로젝트·환경]]
- [[DevOps Center 객체 — Work Item·프로모션]]
- [[DevOps Center 객체 — 비동기·결과]]
- [[DevOps Center — User 필드·플랫폼 이벤트]]
