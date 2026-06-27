---
tags: [devops, devops-center, object-reference, work-item, promotion, change-submission, change-bundle, deploy-component, submit-component, sobject]
source: devops_center_dev.pdf (Salesforce DevOps Center Developer Guide v67.0, Summer '26)
created: 2026-06-27
aliases: [Work Item, Work Item Promote, Change Submission, Change Bundle, Change Bundle Install, Deploy Component, Submit Component, sf_devops__Work_Item__c, sf_devops__Work_Item_Promote__c, sf_devops__Change_Submission__c, sf_devops__Change_Bundle__c, sf_devops__Change_Bundle_Install__c, sf_devops__Deploy_Component__c, sf_devops__Submit_Component__c, 워크아이템, 프로모션, 변경제출, 변경번들, 배포컴포넌트, 제출컴포넌트]
---

# DevOps Center 객체 — Work Item·프로모션

> DevOps Center 데이터 모델에서 작업 단위(Work Item)와 그 프로모션·번들 단계를 표현하는 7개 커스텀 객체 — Work Item, Work Item Promote, Change Submission, Change Bundle, Change Bundle Install, Deploy Component, Submit Component.

---

이 노트는 Salesforce DevOps Center Developer Guide(v67.0, Summer '26)의 커스텀 객체 레퍼런스 중 **Work Item과 프로모션 라이프사이클** 관련 7개 객체를 PDF 구조 그대로 전수 정리한다. 각 객체의 Description, Supported Calls, 모든 Field(Type / Properties / Description, relationship·picklist 포함)를 빠짐없이 옮겼다.

> Supported Calls 한 줄 SOQL 예시 (구조 예시 — 실제 동작 코드 아님):
> ```apex
> // 구조 예시 — 실제 동작 코드 아님
> List<sf_devops__Work_Item__c> items = [
>     SELECT Id, Name, sf_devops__State__c, sf_devops__Subject__c
>     FROM sf_devops__Work_Item__c
>     WHERE sf_devops__State__c = 'IN_PROGRESS'
> ];
> ```

---

## Work Item (sf_devops__Work_Item__c)

프로젝트 내 메타데이터 변경의 집합을 나타낸다. Work item은 작업이 수행되는 환경과 연결될 수 있다. 환경에 연결되지 않으면 VCS Event 객체가 변경을 처리한다. Work item은 모든 개발 작업이 완료되고 work item이 릴리즈 파이프라인의 일부가 될 때까지 여러 개발 라이프사이클 단계를 거친다. 이 객체는 DevOps Center가 설치된 모든 조직에서 사용할 수 있다.

**Supported Calls**
`create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

**Fields**

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| Name | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | Name of this Work Item record. |
| sf_devops__Assigned_To__c | reference | Create, Filter, Group, Nillable, Sort, Update | Reference to the DevOps Center user that this work item is assigned to. DevOps Center uses this field only to display the user's name in the UI. (relationship field) |
| sf_devops__Branch__c | reference | Create, Filter, Group, Nillable, Sort, Update | Reference to the Branch record that contains all the information about the feature branch associated with this work item. DevOps Center initially sets this value when the work item transitions to IN_PROGRESS. The value stays set until the work item becomes a member of the change bundle. (relationship field) |
| sf_devops__Change_Bundle__c | reference | Create, Filter, Group, Nillable, Sort, Update | If this work item is part of a bundle, this field references the Change Bundle record that this work item belongs to. (relationship field) |
| sf_devops__Combine_Status__c | reference | Create, Filter, Group, Nillable, Sort, Update | Reference to the Async Operation Result record associated with the most recent attempt to combine other work items with this work item. (relationship field) |
| sf_devops__Combined_With__c | reference | Create, Filter, Group, Nillable, Sort, Update | Reference to the other work item that this work item has been combined with. (relationship field) |
| sf_devops__Concluded__c | string | Create, Filter, Group, Nillable, Sort, Update | If this field is set to a value, the work item has finished being used for active development or promotion. A work item is done when it's either reached the last stage of the pipeline or a user has set its status to NEVERED. |
| sf_devops__Cross_Environment_Combination__c | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | If true, this work item is the result of a combination operation where metadata came from multiple development environments. The default value is false. |
| sf_devops__Description__c | textarea | Create, Nillable, Update | Description of the work item. DevOps Center uses this field only to display the description in the UI. |
| sf_devops__Development_Approved_By__c | reference | Create, Filter, Group, Nillable, Sort, Update | Reference to the user who clicked the Ready to Promote button for this work item in DevOps Center. (relationship field) |
| sf_devops__Development_Approved__c | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | If true, a user has clicked the Ready to Promote button for this work item in DevOps Center and the work item shows up in the Approved Work Items column in the pipeline. The default value is false. |
| sf_devops__Development_Environment__c | string | Filter, Nillable, Sort | Environment in which the work for this work item was developed. This field is a calculated field. |
| sf_devops__Environment__c | reference | Create, Filter, Group, Nillable, Sort, Update | Environment in which active development work for this work item is happening. DevOps Center clears this field value when the work item's status is PROMOTED. (relationship field) |
| sf_devops__Operation_Status__c | reference | Create, Filter, Group, Nillable, Sort, Update | If this work item is part of a remote operation, this field references the Async Operation Result record for that operation. DevOps Center clears this field value when the operation terminates. (relationship field) |
| sf_devops__Project__c | reference | Create, Filter, Group, Sort | Reference to the parent project of this work item. (relationship field) |
| sf_devops__Promoted_From_Environment__c | reference | Create, Filter, Group, Nillable, Sort, Update | Reference to the development environment that this work item was originally promoted from. When a user promotes a work item, DevOps Center clears the Environment field value of its associated Work Item record. However, DevOps Center must still know which environment the work item was originally promoted from so it can do further processing. So when the first promotion of a work item completes, DevOps Center sets this field to the value of the Environment field before it's cleared. (relationship field) |
| sf_devops__Promoted__c | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | If true, then this work item has been promoted at least one time. The default value is false. |
| sf_devops__Rebase_Branch__c | reference | Create, Filter, Group, Nillable, Sort, Update | Reference to the Branch record that this work item is using as its rebase branch. (relationship field) |
| sf_devops__Review_Remote_Reference__c | string | Create, Filter, Group, Nillable, Sort, Update | Unique ID of the change request for this work item. In GitHub, a change request is called a pull request (PR) and the ID is the PR number. DevOps Center clears this field when the work item's status changes to IN_REVIEW. As the work item moves through the pipeline stages, DevOps Center creates change requests and updates this field with the new ID. When the work item becomes a member of a change bundle, DevOps Center clears this field and no longer sets it. |
| sf_devops__State__c | string | Filter, Nillable, Sort | Current state of this work item. Valid values 아래 picklist 참조. |
| sf_devops__Subject__c | string | Create, Filter, Group, Sort, Update | Subject of the work item. DevOps Center uses this field only to display the subject in the UI. |

**Relationship 보충 (reference 필드)**

| 필드 | Relationship Name | Relationship Type | Refers To |
|---|---|---|---|
| sf_devops__Assigned_To__c | sf_devops__Assigned_To__r | Lookup | User |
| sf_devops__Branch__c | sf_devops__Branch__r | Lookup | sf_devops__Branch__c |
| sf_devops__Change_Bundle__c | sf_devops__Change_Bundle__r | Lookup | sf_devops__Change_Bundle__c |
| sf_devops__Combine_Status__c | sf_devops__Combine_Status__r | Lookup | sf_devops__Async_Operation_Result__c |
| sf_devops__Combined_With__c | sf_devops__Combined_With__r | Lookup | sf_devops__Work_Item__c |
| sf_devops__Development_Approved_By__c | sf_devops__Development_Approved_By__r | Lookup | User |
| sf_devops__Environment__c | sf_devops__Environment__r | Lookup | sf_devops__Environment__c |
| sf_devops__Operation_Status__c | sf_devops__Operation_Status__r | Lookup | sf_devops__Async_Operation_Result__c |
| sf_devops__Project__c | sf_devops__Project__r | Master-detail | sf_devops__Project__c |
| sf_devops__Promoted_From_Environment__c | sf_devops__Promoted_From_Environment__r | Lookup | sf_devops__Environment__c |
| sf_devops__Rebase_Branch__c | sf_devops__Rebase_Branch__r | Lookup | sf_devops__Branch__c |

> Owner 관계: `Name`/표준 OwnerId는 별도 표기 없음 — 이 객체 본문에는 위 reference 필드만 명시됨.

**Picklist — sf_devops__State__c (Valid values)**
- NEW
- IN_PROGRESS
- IN_REVIEW
- APPROVED
- PROMOTED
- CLOSED
- NEVERED

**SEE ALSO:** Branch (sf_devops__Branch__c), Environment (sf_devops__Environment__c), Change Bundle (sf_devops__Change_Bundle__c), Async Operation Result (sf_devops__Async_Operation_Result__c), Project (sf_devops__Project__c)

---

## Work Item Promote (sf_devops__Work_Item_Promote__c)

파이프라인의 다음 단계로 work item을 **언번들(unbundled) 프로모션**하는 것을 나타낸다. 자세한 내용은 Unbundled Promotions: A Deeper Look을 참조한다. 이 객체는 DevOps Center가 설치된 모든 조직에서 사용할 수 있다.

**Supported Calls**
`create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `undelete()`, `update()`, `upsert()`

**Fields**

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| Name | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | Name of this Work Item Promote record. |
| sf_devops__Deployment_Result__c | reference | Create, Filter, Group, Nillable, Sort, Update | Reference to the Deploy Result record that DevOps Center used to control the deployment of the work item. (relationship field) |
| sf_devops__Merge_Result__c | reference | Create, Filter, Group, Sort, Update | Reference to the Merge Result record that DevOps Center used to control how the feature branch associated with the work item was merged as part of the promotion. (relationship field) |
| sf_devops__Pipeline_Stage__c | reference | Create, Filter, Group, Sort | Reference to the pipeline stage that the work item was promoted to. (relationship field) |
| sf_devops__Rebase_Status__c | reference | Create, Filter, Group, Nillable, Sort, Update | Reference to the Async Operation Result record associated with a potential remote rebase operation. After DevOps Center performs an unbundled promotion of a work item, it checks whether another unbundled promotion is pending. If there is, DevOps Center must rebase the feature branch of the original work item to the branch in the next stage of the pipeline. This field references the Async Operation Result that's doing this work. (relationship field) |
| sf_devops__Status__c | reference | Create, Filter, Group, Nillable, Sort, Update | Reference to the Async Operation Result record associated with the remote operation of promoting this work item. (relationship field) |
| sf_devops__Work_Item__c | reference | Create, Filter, Group, Sort | Reference to the work item that was promoted. (relationship field) |

**Relationship 보충 (reference 필드)**

| 필드 | Relationship Name | Relationship Type | Refers To |
|---|---|---|---|
| sf_devops__Deployment_Result__c | sf_devops__Deployment_Result__r | Lookup | sf_devops__Deployment_Result__c |
| sf_devops__Merge_Result__c | sf_devops__Merge_Result__r | Lookup | sf_devops__Merge_Result__c |
| sf_devops__Pipeline_Stage__c | sf_devops__Pipeline_Stage__r | Master-detail | sf_devops__Pipeline_Stage__c |
| sf_devops__Rebase_Status__c | sf_devops__Rebase_Status__r | Lookup | sf_devops__Async_Operation_Result__c |
| sf_devops__Status__c | sf_devops__Status__r | Lookup | sf_devops__Async_Operation_Result__c |
| sf_devops__Work_Item__c | sf_devops__Work_Item__r | Master-detail | sf_devops__Work_Item__c |

**SEE ALSO:** Deployment Result (sf_devops__Deployment_Result__c), Async Operation Result (sf_devops__Async_Operation_Result__c), Merge Result (sf_devops__Merge_Result__c), Pipeline Stage (sf_devops__Pipeline_Stage__c), Work Item (sf_devops__Work_Item__c)

---

## Change Submission (sf_devops__Change_Submission__c)

Work item 피처 브랜치에 제출(커밋)된 변경을 나타낸다. 변경에는 관련 메타데이터 파일이 포함된다. 이 객체는 DevOps Center가 설치된 모든 조직에서 사용할 수 있다. 커밋은 다음 방식 중 하나로 발생할 수 있다:

- 사용자가 DevOps Center 내 work item에서 **Commit Changes**를 클릭한 경우.
- 사용자가 GitHub UI 등 DevOps Center 외부에서 변경을 커밋하고, DevOps Center가 그 이벤트를 감지한 경우.

**Supported Calls**
`create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `undelete()`, `update()`, `upsert()`

**Fields**

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| Name | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | Name of this Change Submission record. |
| sf_devops__Comment__c | textarea | Create, Nillable, Update | The commit message that the user entered. |
| sf_devops__Creation_Result__c | reference | Create, Filter, Group, Nillable, Sort, Update | When the commit comes from a user using DevOps Center, this field references the Async Operation Result record that was used for the commit. (relationship field) |
| sf_devops__Inspection_Result__c | reference | Create, Filter, Group, Nillable, Sort, Update | When the commit comes from outside DevOps Center, this field references the Async Operation Result record that was used when DevOps Center detected the commit. DevOps Center must inspect the commit to determine the relevant metadata components. (relationship field) |
| sf_devops__Remote_Reference__c | string | Create, Filter, Group, Nillable, Sort, Update | Unique ID of the feature branch before the commit. In GitHub, this ID is called a SHA. DevOps Center uses this ID when the Inspection Result field contains an error and DevOps Center must inspect the commit again. |
| sf_devops__Repository__c | reference | Create, Filter, Group, Sort | Reference to the repository in which the commit is made. (relationship field) |
| sf_devops__Submitted_By_Name__c | string | Create, Filter, Group, Nillable, Sort, Update | Name of the user that performed the commit when it was initiated outside of DevOps Center. |
| sf_devops__Submitted_By__c | reference | Create, Filter, Group, Nillable, Sort, Update | Reference to the user that performed the commit when it was initiated in DevOps Center. (relationship field) |
| sf_devops__Submitted_On__c | dateTime | Create, Filter, Sort, Update | Date and time of the commit. |
| sf_devops__Work_Item__c | reference | Create, Filter, Group, Sort, Update | Reference to the work item that the commit is associated with. This work item owns the feature branch. (relationship field) |

**Relationship 보충 (reference 필드)**

| 필드 | Relationship Name | Relationship Type | Refers To |
|---|---|---|---|
| sf_devops__Creation_Result__c | sf_devops__Creation_Result__r | Lookup | sf_devops__Async_Operation_Result__c |
| sf_devops__Inspection_Result__c | sf_devops__Inspection_Result__r | Lookup | sf_devops__Async_Operation_Result__c |
| sf_devops__Repository__c | sf_devops__Repository__r | Master-detail | sf_devops__Repository__c |
| sf_devops__Submitted_By__c | sf_devops__Submitted_By__r | Lookup | User |
| sf_devops__Work_Item__c | sf_devops__Work_Item__r | Lookup | sf_devops__Work_Item__c |

**SEE ALSO:** (PDF SEE ALSO 미표기 — 본문 SEE ALSO 블록 없음)

---

## Change Bundle (sf_devops__Change_Bundle__c)

다음 파이프라인 단계로 단일 단위로 프로모션되는 Work Item 레코드의 집합. 이 집합은 메타데이터가 릴리즈 파이프라인을 통과할 때 일관된 머지와 배포를 보장하는 데 도움을 준다. 이 객체는 DevOps Center가 설치된 모든 조직에서 사용할 수 있다.

**Supported Calls**
`create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

**Fields**

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| Name | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | Name of the Change Bundle record. |
| sf_devops__Project__c | reference | Create, Filter, Group, Sort | A reference to the project in which this change bundle lives. (relationship field) |
| sf_devops__Version_Name__c | string | Create, Filter, Group, Sort, Update | Unique name of this bundle within the project. |

**Relationship 보충 (reference 필드)**

| 필드 | Relationship Name | Relationship Type | Refers To |
|---|---|---|---|
| sf_devops__Project__c | sf_devops__Project__r | Master-detail | sf_devops__Project__c |

**SEE ALSO:** Project (sf_devops__Project__c)

---

## Change Bundle Install (sf_devops__Change_Bundle_Install__c)

Change bundle와 연관된 메타데이터 컴포넌트를 환경에 배포하는 것을 나타낸다. 이 객체는 DevOps Center가 설치된 모든 조직에서 사용할 수 있다.

**Supported Calls**
`create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

**Fields**

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| Name | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | Name of this Change Bundle Install record. |
| sf_devops__Change_Bundle__c | reference | Create, Filter, Group, Sort | Reference to the Change Bundle record that's being deployed. (relationship field) |
| sf_devops__Deployment_Result__c | reference | Create, Filter, Group, Nillable, Sort, Update | Reference to the Deployment Result record that controls the metadata deployment associated with this record. (relationship field) |
| sf_devops__Environment__c | reference | Create, Filter, Group, Sort, Update | Reference to the environment in which the change bundle is being deployed. (relationship field) |
| sf_devops__Merge_Result__c | reference | Create, Filter, Group, Sort, Update | Reference to the Merge Result record that lists the source control branches that were merged as part of this deployment. (relationship field) |
| sf_devops__Status__c | reference | Create, Filter, Group, Nillable, Sort, Update | Reference to the Async Operation Result record that's associated with this record. (relationship field) |

**Relationship 보충 (reference 필드)**

| 필드 | Relationship Name | Relationship Type | Refers To |
|---|---|---|---|
| sf_devops__Change_Bundle__c | sf_devops__Change_Bundle__r | Master-detail | sf_devops__Change_Bundle__c |
| sf_devops__Deployment_Result__c | sf_devops__Deployment_Result__r | Lookup | sf_devops__Deployment_Result__c |
| sf_devops__Environment__c | sf_devops__Environment__r | Lookup | sf_devops__Environment__c |
| sf_devops__Merge_Result__c | sf_devops__Merge_Result__r | Lookup | sf_devops__Merge_Result__c |
| sf_devops__Status__c | sf_devops__Status__r | Lookup | sf_devops__Async_Operation_Result__c |

**SEE ALSO:** Change Bundle (sf_devops__Change_Bundle__c), Deployment Result (sf_devops__Deployment_Result__c), Environment (sf_devops__Environment__c), Merge Result (sf_devops__Merge_Result__c), Async Operation Result (sf_devops__Async_Operation_Result__c)

---

## Deploy Component (sf_devops__Deploy_Component__c)

프로모션의 일부로 배포해야 하는 메타데이터 컴포넌트의 집계된 집합을 저장한다. 프로모션과 연관된 모든 work item의 메타데이터 컴포넌트를 포함한다. Deploy Component 객체는 Deployment Result의 자식이다. 이 객체는 DevOps Center가 설치된 모든 조직에서 사용할 수 있다.

**Supported Calls**
`create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `undelete()`, `update()`, `upsert()`

**Fields**

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| Name | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | Name of this Deploy Component record. |
| sf_devops__Deployment_Result__c | reference | Create, Filter, Group, Sort | Reference to the parent Deployment Result of this component. (relationship field) |
| sf_devops__File_Path__c | string | Create, Filter, Group, Nillable, Sort, Update | Full pathname of the -meta.xml source file for this component. The Heroku application uses this field to determine if the .forceignore file on the branch references the component. If it does, this component is ignored during the deployment to the environment. |
| sf_devops__Force_Ignored__c | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Set to true by the Heroku application when the component wasn't deployed to the environment because it matched a .forceignore rule. The default value is false. |
| sf_devops__Operation__c | string | Create, Filter, Group, Sort, Update | Specifies the operation, either UPSERT or DELETE. |
| sf_devops__Source_Component__c | string | Create, Filter, Group, Sort, Update | Type and name of this metadata component. |

**Relationship 보충 (reference 필드)**

| 필드 | Relationship Name | Relationship Type | Refers To |
|---|---|---|---|
| sf_devops__Deployment_Result__c | sf_devops__Deployment_Result__r | Master-detail | sf_devops__Deployment_Result__c |

**Picklist — sf_devops__Operation__c (Possible values)**
- UPSERT
- DELETE

**SEE ALSO:** Deployment Result (sf_devops__Deployment_Result__c)

---

## Submit Component (sf_devops__Submit_Component__c)

소스(버전) 컨트롤 리포지토리의 피처 브랜치에 커밋된 메타데이터 컴포넌트를 나타낸다. 커밋은 DevOps Center 내부 또는 소스 컨트롤 리포지토리에서 직접, 두 가지 방식 중 하나로 시작될 수 있다. 커밋의 일부인 각 메타데이터 컴포넌트는 환경에도 배포되어야 하며, DevOps Center는 Submit Component 객체를 사용해 메타데이터를 모델링한다. Submit Component 객체는 Change Submission의 자식이다. 이 객체는 DevOps Center가 설치된 모든 조직에서 사용할 수 있다.

**Supported Calls**
`create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `undelete()`, `update()`, `upsert()`

**Fields**

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| Name | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | Name of this Submit Component record. |
| sf_devops__Change_Submission__c | reference | Create, Filter, Group, Sort | Reference to the parent Change Submission record that this Submit Component record is a child of. (relationship field) |
| sf_devops__Empty__c | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | If true, indicates that the metadata component didn't change anything on the associated feature branch. This scenario occurs when a user pulls removed metadata from a development environment, but the metadata source doesn't yet exist on the feature branch. DevOps Center still removes the metadata from the environment but doesn't change the feature branch. The default value is false. |
| sf_devops__File_Path__c | string | Create, Filter, Group, Nillable, Sort, Update | Full pathname of the -meta.xml source file for this component on the feature branch. |
| sf_devops__Operation__c | string | Create, Filter, Group, Sort, Update | Specifies the operation that was executed on this component. Either ADD, CHANGE, or DELETE. |
| sf_devops__Source_Component__c | string | Create, Filter, Group, Sort, Update | Combination of the metadata name and type. |
| sf_devops__Source_Remote_Change__c | reference | Create, Filter, Group, Nillable, Sort, Update | If a user in DevOps Center initiated the commit, this field is a reference to the associated Remote Change record that displayed the component in the user interface. (relationship field) |

**Relationship 보충 (reference 필드)**

| 필드 | Relationship Name | Relationship Type | Refers To |
|---|---|---|---|
| sf_devops__Change_Submission__c | sf_devops__Change_Submission__r | Master-detail | sf_devops__Change_Submission__c |
| sf_devops__Source_Remote_Change__c | sf_devops__Source_Remote_Change__r | Lookup | sf_devops__Remote_Change__c |

**Picklist — sf_devops__Operation__c (Possible values)**
- ADD
- CHANGE
- DELETE

**SEE ALSO:** Change Submission (sf_devops__Change_Submission__c), Remote Change (sf_devops__Remote_Change__c)

---

## 객체 간 관계 요약

// 구조 예시 — 실제 원본 다이어그램 아님 (PDF의 산문 기반 재구성)

```
Project
  └─ Work Item ──(Master-detail)──> Project
        ├─ Change Submission ──> Work Item (Lookup), Repository (M-D)
        │     └─ Submit Component ──(M-D)──> Change Submission
        ├─ Work Item Promote ──(M-D)──> Work Item, Pipeline Stage
        └─ Change Bundle (멤버: Work Item.Change_Bundle__c)
              ├─ Change Bundle Install ──(M-D)──> Change Bundle
              └─ Deploy Component ──(M-D)──> Deployment Result
```

- **Work Item**은 Project의 자식(Master-detail)이며, 개발→리뷰→승인→프로모션 라이프사이클을 `sf_devops__State__c`로 추적한다.
- **Change Submission / Submit Component**는 커밋(제출) 단계를 모델링한다(Submit Component는 Change Submission의 자식).
- **Work Item Promote / Change Bundle / Change Bundle Install / Deploy Component**는 프로모션·번들·배포 단계를 모델링한다.

---

## 관련 노트
- [[DevOps Center 데이터 모델 개요]]
- [[DevOps Center 객체 — 파이프라인·프로젝트·환경]]
- [[DevOps Center 객체 — 변경 추적]]
- [[DevOps Center 객체 — 비동기·결과]]
- [[DevOps Center — User 필드·플랫폼 이벤트]]
- [[creating-fix-work-item]] (sf-skill — 실행형) — Work Item 생성 실행형 스킬
