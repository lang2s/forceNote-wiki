---
tags: [devops, devops-center, object-reference, async, deployment-result, merge-result, back-sync, vcs-synch-state]
source: devops_center_dev.pdf (Salesforce DevOps Center Developer Guide v67.0, Summer '26)
created: 2026-06-27
aliases: [Async Operation Result, Deployment Result, Merge Result, Back Sync, VCS Synch State, sf_devops__Async_Operation_Result__c, sf_devops__Deployment_Result__c, sf_devops__Merge_Result__c, sf_devops__Back_Sync__c, sf_devops__Vcs_Synch_State__c, 비동기 작업 결과, 배포 결과, 머지 결과, 백 싱크, VCS 동기화 상태]
---

# DevOps Center 객체 — 비동기·결과

> DevOps Center가 Heroku 앱에 위임하는 비동기 작업(머지·배포·동기화)의 통신 다리와 그 결과를 저장하는 5개 커스텀 객체 — Async Operation Result · Deployment Result · Merge Result · Back Sync · VCS Synch State.

---

## 개요

DevOps Center는 소스 컨트롤 저장소(version control system, VCS)에서 브랜치를 머지하고 메타데이터를 환경에 배포하는 등 일부 작업을 **Heroku 앱에 비동기로 위임**한다. 이때 작업의 시작·진행·종료 상태와 결과 데이터를 저장하기 위해 아래 객체들이 사용된다.

- **Async Operation Result** — DevOps Center ↔ Heroku 앱 사이의 통신 다리(communication bridge). 모든 원격 작업의 상태/메시지/에러를 담는다.
- **Deployment Result** — 메타데이터 배포 실행 지시(테스트 레벨 등)와 배포 완료 정보(배포 ID, 완료 일시).
- **Merge Result** — 프로모션의 일부로 머지할 소스 컨트롤 브랜치 정보와 머지 완료 정보(머지 ID, 일시).
- **Back Sync** — DevOps Center 사용자의 개발 환경과 파이프라인 첫 스테이지 브랜치 간 동기화 추적.
- **VCS Synch State** — DevOps Center와 소스 컨트롤 시스템 간 동기화 상태 추적.

> 아래 각 객체의 Description / Supported Calls / Fields는 PDF 레퍼런스를 전수 옮긴 것이다. picklist 필드는 모든 가능한 값을, reference 필드는 Relationship Name·Type·Refers To를 포함한다.

```sql
-- 구조 예시 — 실제 동작 코드 아님
-- 진행 중인 배포의 결과 상태를 Async Operation Result와 함께 조회
SELECT Name,
       sf_devops__Deployment_Id__c,
       sf_devops__Test_Level__c,
       sf_devops__Status__r.sf_devops__Status__c,        -- picklist: Completed / Error / Ignored / In Progress
       sf_devops__Status__r.sf_devops__In_Terminal_State__c
FROM   sf_devops__Deployment_Result__c
WHERE  sf_devops__Status__r.sf_devops__Status__c = 'In Progress'
```

---

## Async Operation Result (sf_devops__Async_Operation_Result__c)

### Description
Represents the communication bridge between the Heroku app and DevOps Center. DevOps Center creates an instance of Async Operation Result when it delegates certain asynchronous operations to the Heroku app. These operations include merging branches in the source control repository (also called version control system, or VCS) and deploying metadata to environments. This object is available in orgs that have DevOps Center installed.

### Supported Calls
`create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `undelete()`, `update()`, `upsert()`

### Fields

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| Name | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | Name of the Async Operation Result record. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | ID of the user who owns this record. (polymorphic relationship field) |
| sf_devops__Dependent_Records__c | textarea | Create, Nillable, Update | JSON representation of all the related object records that must be updated as a result of this asynchronous operation. |
| sf_devops__Error_Details__c | textarea | Create, Nillable, Update | If the remote operation encounters an error, this field contains the stack trace from the Heroku app. |
| sf_devops__In_Terminal_State__c | boolean | Defaulted on create, Filter, Group, Sort | If `true`, indicates that this async operation is in a terminal state. If `false`, the operation is in progress. (calculated field) |
| sf_devops__Log_Id__c | string | Create, Filter, Group, Sort, Update | Unique ID for this remote operation. Used internally by Salesforce to tie together various logging systems when investigating customer cases. |
| sf_devops__Message__c | string | Create, Filter, Group, Nillable, Sort, Update | Status message that's displayed in DevOps Center as the remote operation progresses. |
| sf_devops__Operation__c | string | Create, Filter, Group, Sort, Update | Type of remote operation that this record is being used in. |
| sf_devops__Remote_Commands__c | textarea | Create, Nillable, Update | List of remote commands that were executed as part of this remote operation. Includes `git` and `sf` (Salesforce CLI) commands. |
| sf_devops__Status__c | picklist | Create, Defaulted on create, Filter, Group, Sort, Update | Status of the remote operation. (가능한 값 아래) |

**reference 필드 상세**

- **OwnerId** — Relationship Name: `Owner` · Relationship Type: Lookup · Refers To: Group, User

**picklist 필드 상세 — sf_devops__Status__c**

Possible values are:
- Completed
- Error
- Ignored
- In Progress

기본값(default value): **In Progress**.

> SEE ALSO: *How DevOps Center Uses Asynchronous Operations* — Heroku가 작업을 완료하면 Async Operation Result의 Status 필드를 Completed 또는 Error로 변경한다.

---

## Deployment Result (sf_devops__Deployment_Result__c)

### Description
Contains information from DevOps Center to the Heroku application about how to execute a metadata deployment to an environment, such as the Apex tests and test level. After the deployment completes, this object then stores information about the deployment, such as the deployment ID and completion date. See *How Promotions Work* for more information. This object is available in all orgs that have DevOps Center installed.

### Supported Calls
`create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `undelete()`, `update()`, `upsert()`

### Fields

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| Name | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | Name of this Deployment Result record. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | ID of the user who owns this record. (polymorphic relationship field) |
| sf_devops__Check_Deploy_Date__c | dateTime | Create, Filter, Nillable, Sort, Update | Specifies the date and time that a validate-only deployment completed. DevOps Center uses this value to prompt the user when a validate-only deployment is about to expire. |
| sf_devops__Check_Deploy_Status__c | reference | Create, Filter, Group, Nillable, Sort, Update | Reference to the Async Operation Result record that was used to perform the validate-only deployment. (relationship field) |
| sf_devops__Check_Deploy__c | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | DevOps Center sets this field to `true` to alert the Heroku application to perform a validate-only deployment. The default value is `false`. |
| sf_devops__Completion_Date__c | dateTime | Create, Filter, Nillable, Sort, Update | Date and time when the promotion of this Deployment Result completed. |
| sf_devops__Deployment_Id__c | string | Create, Filter, Group, Nillable, Sort, Update | ID of the deployment. The Heroku application sets this field after a successful deployment to the environment. |
| sf_devops__Full_Deploy__c | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | DevOps Center sets this field to `true` to alert the Heroku application to deploy all of the metadata from the branch, rather than just the metadata components in the Deploy Component records. The default value is `false`. |
| sf_devops__Number_Tests_Completed__c | double | Create, Defaulted on create, Filter, Nillable, Sort, Update | Number of tests that completed as part of the deployment to the environment. The Heroku application sets this field after the deployment. DevOps Center uses this field to determine if a validate-only deployment is available for a subsequent quick deploy. |
| sf_devops__Run_Tests__c | textarea | Create, Nillable, Update | If the Test Level field is set to `RunSpecifiedTests`, this field contains the comma-separated list of Apex tests to run during the deployment. |
| sf_devops__Status__c | reference | Create, Filter, Group, Nillable, Sort, Update | Reference to the Async Operation Result record that was used for the associated promotion or quick deploy. (relationship field) |
| sf_devops__Test_Level__c | string | Create, Filter, Group, Nillable, Sort, Update | Specifies the level of Apex tests to run during the deployment. The Heroku application uses this field when it executes the deployment. (Valid values 아래) |

**reference 필드 상세**

- **OwnerId** — Relationship Name: `Owner` · Relationship Type: Lookup · Refers To: Group, User
- **sf_devops__Check_Deploy_Status__c** — Relationship Name: `sf_devops__Check_Deploy_Status__r` · Relationship Type: Lookup · Refers To: `sf_devops__Async_Operation_Result__c`
- **sf_devops__Status__c** — Relationship Name: `sf_devops__Status__r` · Relationship Type: Lookup · Refers To: `sf_devops__Async_Operation_Result__c`

**sf_devops__Test_Level__c — Valid values**
- NoTestRun
- RunAllTestsInOrg
- RunLocalTests
- RunSpecifiedTests

> SEE ALSO: *Metadata API Developer Guide: deploy()* · Async Operation Result (`sf_devops__Async_Operation_Result__c`) · *How Promotions Work*

---

## Merge Result (sf_devops__Merge_Result__c)

### Description
Contains information from DevOps Center to the Heroku application about the source control branch to merge as part of a promotion. When the merge completes, this object then stores information about the merge, such as the ID of the merge and when it happened. This object is available in all orgs that have DevOps Center installed.

### Supported Calls
`create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `undelete()`, `update()`, `upsert()`

### Fields

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| Name | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | Name of this Merge Result record. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | ID of the user who owns this record. (polymorphic relationship field) |
| sf_devops__Merge_Date__c | dateTime | Create, Filter, Nillable, Sort, Update | Date and time that the merge happened. |
| sf_devops__Previous_Remote_Reference__c | string | Create, Filter, Group, Nillable, Sort, Update | Unique ID of the branch before the merge. In GitHub, this ID is called the HEAD SHA. |
| sf_devops__Remote_Reference__c | string | Create, Filter, Group, Nillable, Sort, Update | Unique ID of this merge. In GitHub, this ID is called the SHA. |
| sf_devops__Source_Branch_Name__c | string | Create, Filter, Group, Sort, Update | Name of the branch that's being merged. |
| sf_devops__Target_Branch_Name__c | string | Create, Filter, Group, Sort, Update | Name of the branch into which the source branch is being merged. |

**reference 필드 상세**

- **OwnerId** — Relationship Name: `Owner` · Relationship Type: Lookup · Refers To: Group, User

---

## Back Sync (sf_devops__Back_Sync__c)

### Description
Represents the synchronization between a DevOps Center user's development environment and the first pipeline stage's branch. In particular, this object tracks when the synchronization happened and the records of the Source Member Reference object that the synchronization can ignore. This object is available in all orgs that have DevOps Center installed.

**동작 예시 (PDF 본문 시나리오)** — 다음을 가정한다:
- 사용자가 이미 메타데이터 변경 2개를 자신의 개발 환경으로 pull했고, 이는 Remote Change 레코드 2개로 표현된다. Source Member Reference 객체에서 이 두 메타데이터 파일의 **Revision Counter** 필드 값은 5와 6이다.
- Source Member Reference 객체에 아직 pull되지 않은 메타데이터 변경 2개가 있으며, revision counter는 7과 8이다.
- 사용자가 Pipeline Environment에서 **Sync**를 클릭한다. DevOps Center는 이 Back Sync 레코드의 **Start Revision Counter** 필드를 **8**로 설정한다.
- 동기화가 Source Member Reference 테이블에 Revision Counter 값 9, 10, 11을 가진 새 행 3개를 생성한다.
- 동기화가 완료되고, DevOps Center는 이 Back Sync 레코드의 **End Revision Counter** 필드를 **11**로 설정한다.
- 사용자가 개발 환경에서 메타데이터 변경 2개를 더 만든다. Source Member Reference 객체의 대응 Revision Counter 값은 12와 13이다.

다음에 사용자가 work item 내에서 **Pull Changes**를 클릭하면, DevOps Center는 revision counter 7부터 13까지에 대응하는 Source Member Reference의 메타데이터 변경을 pull한다. 이때 DevOps Center는 관련 Source Member Reference를 Remote Change 레코드로 변환해야 하며, 먼저 이 개발 환경에 연결된 다른 Back Sync 레코드를 검사한다. 이 예시에서 DevOps Center는 revision counter 9, 10, 11을 **무시(ignore)** 하고, revision counter 7, 8, 12, 13에 대해서만 Remote Change 레코드를 생성한다.

### Supported Calls
`create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

### Fields

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| Name | string | Create, Defaulted on create, Filter, Group, idLookup, Nillable, Sort, Update | Name of the Back Sync record. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | ID of the user who owns this record. (polymorphic relationship field) |
| sf_devops__Deployment_Result__c | reference | Create, Filter, Group, Sort, Update | A reference to the Deployment Result record that was sent to the Heroku application to perform the metadata deployment to the development environment. (relationship field) |
| sf_devops__Destination_Environment__c | reference | Create, Filter, Group, Sort, Update | A reference to the development environment that was synchronized. (relationship field) |
| sf_devops__End_Revision_Counter__c | double | Create, Filter, Nillable, Sort, Update | The Source Member Reference revision counter in the development environment after the synchronization completes. |
| sf_devops__Operation_Result__c | reference | Create, Filter, Group, Nillable, Sort, Update | A reference to the Async Operation Result that was used in this remote operation. (relationship field) |
| sf_devops__Source_Pipeline_Stage__c | reference | Create, Filter, Group, Sort, Update | A reference to the Pipeline Stage whose branch was used to deploy metadata from. This stage is always the first one in the pipeline. (relationship field) |
| sf_devops__Start_Revision_Counter__c | double | Create, Filter, Sort, Update | The Source Member Reference revision counter in the development environment before the synchronization was initiated. |

**reference 필드 상세**

- **OwnerId** — Relationship Name: `Owner` · Relationship Type: Lookup · Refers To: Group, User
- **sf_devops__Deployment_Result__c** — Relationship Name: `sf_devops__Deployment_Result__r` · Relationship Type: Lookup · Refers To: `sf_devops__Deployment_Result__c`
- **sf_devops__Destination_Environment__c** — Relationship Name: `sf_devops__Destination_Environment__r` · Relationship Type: Lookup · Refers To: `sf_devops__Environment__c`
- **sf_devops__Operation_Result__c** — Relationship Name: `sf_devops__Operation_Result__r` · Relationship Type: Lookup · Refers To: `sf_devops__Async_Operation_Result__c`
- **sf_devops__Source_Pipeline_Stage__c** — Relationship Name: `sf_devops__Source_Pipeline_Stage__r` · Relationship Type: Lookup · Refers To: `sf_devops__Pipeline_Stage__c`

> SEE ALSO: *Salesforce Help: Synchronize Your Development Environment* · Async Operation Result (`sf_devops__Async_Operation_Result__c`) · Source Member Reference (`sf_devops__Source_Member_Reference__c`) · Environment (`sf_devops__Environment__c`) · Pipeline Stage (`sf_devops__Pipeline_Stage__c`) · Deployment Result (`sf_devops__Deployment_Result__c`)

---

## VCS Synch State (sf_devops__Vcs_Synch_State__c)

### Description
Represents the synchronization state between DevOps Center and the source (version) control system. DevOps Center uses this object to track all synchronization events to ensure that DevOps Center is working with the latest version of the code in the source control repository. This object is available in all orgs that have DevOps Center package version **8.2 and later**. Available in **API version 62.0 and later**.

### Supported Calls
`create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `undelete()`, `update()`, `upsert()`

### Fields

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| Name | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | Name of the synchronization state. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | Not used by DevOps Center. |
| sf_devops__Project__c | reference | Create, Filter, Group, Sort, Update | Reference to a DevOps Center project that this state belongs to. (relationship field) |
| sf_devops__Synch_Name__c | string | Create, Filter, Group, Sort, Update | Name of the synchronization state used for logging. |

**reference 필드 상세**

- **OwnerId** — Relationship Name: `Owner` · Refers To: Group, User
- **sf_devops__Project__c** — Relationship Name: `sf_devops__Project__r` · Refers To: `sf_devops__Project__c`

---

## 관련 노트
- [[DevOps Center 데이터 모델 개요]]
- [[DevOps Center 객체 — 파이프라인·프로젝트·환경]]
- [[DevOps Center 객체 — Work Item·프로모션]]
- [[DevOps Center 객체 — 변경 추적]]
- [[DevOps Center — User 필드·플랫폼 이벤트]]
