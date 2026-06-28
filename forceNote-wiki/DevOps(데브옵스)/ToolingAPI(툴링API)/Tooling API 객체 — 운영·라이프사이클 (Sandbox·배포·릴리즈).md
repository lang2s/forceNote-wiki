---
tags: [tooling-api, devops, sandbox, deploy, release-update, source-tracking, my-domain]
source: api_tooling.pdf v67.0 (Summer '26)
created: 2026-06-28
aliases: [SandboxInfo, SandboxProcess, SandboxProcessStage, SourceMember, SourceMemberDeployRequest, DeployRequest, DeployDetails, PlatformEventMigration, ReleaseUpdate, ReleaseUpdateStep, HistoryRetentionJob, OperationLog, DomainProvision, OrgDomainLog, CustomHttpHeader, BusinessProcessFeedback, BusinessProcessGroup, BusProcessFeedbackConfig, 샌드박스, 배포, 릴리즈 업데이트, 소스 추적, My Domain, 운영]
---

# Tooling API 객체 — 운영·라이프사이클 (Sandbox·배포·릴리즈)

> org 운영·라이프사이클 Tooling sObject 18종 전수 — Sandbox 복사/새로고침(SandboxInfo·SandboxProcess·SandboxProcessStage)·메타데이터 배포(DeployRequest·DeployDetails)·릴리즈 업데이트(ReleaseUpdate·ReleaseUpdateStep)·소스 추적(SourceMember*)·My Domain(DomainProvision·OrgDomainLog)·플랫폼이벤트 마이그레이션·필드 히스토리 아카이브·비동기 OperationLog·고객 라이프사이클 맵 등을 SOQL로 조회하거나 일부는 생성/갱신한다.

이 노트는 Tooling API Reference & Developer Guide v67.0(Summer '26)의 "Tooling API Objects" 챕터 중 **org 운영·라이프사이클 도메인 sObject 군**을 다룬다. 이 군은 샌드박스 관리(SandboxInfo·SandboxProcess·SandboxProcessStage), 메타데이터 배포 요청(DeployRequest·DeployDetails complex type), 릴리즈 업데이트·플랫폼이벤트 마이그레이션(ReleaseUpdate·ReleaseUpdateStep·PlatformEventMigration), org 운영(HistoryRetentionJob·OperationLog·CustomHttpHeader), My Domain 프로비저닝·로그(DomainProvision·OrgDomainLog), 소스 추적(SourceMember·SourceMemberDeployRequest — 내부 예약), 고객 라이프사이클 맵 비즈니스 프로세스(BusinessProcessFeedback·BusinessProcessGroup·BusProcessFeedbackConfig)로 구성된다. 대부분 `query()`로 SOQL 조회가 가능하며, 일부(SandboxInfo·CustomHttpHeader·ReleaseUpdateStep·PlatformEventMigration 등)는 `create()`/`update()`/`delete()`로 라이프사이클을 제어한다.

> [!warning] Tooling Ch4에 없는 운영 객체 (Dev Hub / Metadata API 전용)
> 아래 객체들은 org 운영 객체로 흔히 기대되지만 **Tooling API Ch4(Tooling API Objects)에는 존재하지 않는다.** 스크래치 org/Dev Hub 객체는 Dev Hub org 안에 살며 Dev Hub 또는 Metadata API로만 다룬다. "Tooling API로 조회/생성할 수 있다"고 쓰면 안 된다(검색 시 혼동 방지 — 실제 coverage gap 신호이지 누락이 아니다).
> - **ScratchOrgInfo**
> - **ActiveScratchOrg**
> - **NamespaceRegistry**
> - **ScratchOrgInfoFeature**
> - **EnvironmentHub**
> - **SandboxSettings**

> [!note] 이미 다른 노트에 작성됨 (link-only)
> 아래 객체는 같은 Ch4의 다른 도메인 그룹에서 이미 작성되었으므로 본 노트에서는 재작성하지 않고 링크만 둔다.
> - **Certificate** → [[Tooling API 객체 — 보안·권한]] (DeployDetails/BusProcessFeedbackConfig 직후 페이지에 등장하지만 본 그룹 소관 아님)
> - **ProcessFlowMigration** → [[Tooling API 객체 — 자동화 (Flow·Workflow·룰)]]
> - **IconDefinition** → [[Tooling API 객체 — UI·레이아웃 (페이지·액션·탭)]]
> - 컨테이너 기반 배포 패밀리(**MetadataContainer·ContainerAsyncRequest·Apex\*Member**)는 [[Tooling API 배포]] 참조.
> - 디버그·로그·리플레이 패밀리(**TraceFlag·ApexLog** 등)는 [[Tooling API 디버그·로그·리플레이 sObject]] 참조.

> [!note] thin / reserved 객체 — 날조 금지
> - **SourceMember** 와 **SourceMemberDeployRequest** 는 v67.0에서 "**Reserved for internal use. Do not use this object.**" 상태로 **필드 0개**다. 필드 표를 fabricate하지 않고 원문 그대로 stub로만 기록한다. 소스 추적의 실제 개발자 워크플로는 [[Source Tracking 변경 추적]] 참조.
> - **PlatformEventMigration** 은 Fields 표에 **3개 필드(DeveloperName·EventObject·MasterLabel)만** 문서화되어 있다. 그러나 Usage의 SOQL 예제는 추가 read-only 필드명 **MigrationStatus·StartDate·EndDate·HighVolumePosition** 을 참조한다 — 이들은 Fields 표에 **미문서화**되어 있으므로 필드 행으로 발명하지 않고 "Usage SOQL에서만 언급됨"으로 기록한다(소스가 보여주는 불일치 그대로).

> 표기 규약: 필드표는 PDF `-layout` 추출본의 충실 transcription이며, 원문 오타/quirk는 `[sic]` 인라인으로 보존한다. AP-09 페이지 경계로 절단되었던 enum·필드(SandboxProcess.Status 17값, HistoryRetentionJob.Status 11값, OrgDomainLog.ProdSuffixType, ReleaseUpdate.SupportsRevoke/Title 등)는 인접 페이지에서 stitch해 전부 포함했다.

---

## 객체 빠른 색인

| 객체 | 분류 | 필드 수 | API 최소 버전 |
|---|---|---|---|
| [BusinessProcessFeedback](#businessprocessfeedback) | Business Process | 4 | 51.0 |
| [BusinessProcessGroup](#businessprocessgroup) | Business Process | 7 | 51.0 |
| [BusProcessFeedbackConfig](#busprocessfeedbackconfig) | Business Process | 15 | 51.0 |
| [CustomHttpHeader](#customhttpheader) | Org Ops | 5 | 51.0 |
| [DeployDetails](#deploydetails-complex-type) | Deploy & Source | 1 (complex type) | 31.0 |
| [DeployRequest](#deployrequest) | Deploy & Source | 25 | 49.0 |
| [DomainProvision](#domainprovision) | My Domain | 7 | 50.0 |
| [HistoryRetentionJob](#historyretentionjob) | Org Ops | 6 | 29.0 |
| [OperationLog](#operationlog) | Org Ops | 5 (+10 복합 sub-field) | 37.0 |
| [OrgDomainLog](#orgdomainlog) | My Domain | 3 | 51.0 |
| [PlatformEventMigration](#platformeventmigration) | Release & Migration | 3 | 67.0 |
| [ReleaseUpdate](#releaseupdate) | Release & Migration | 18 | 50.0 |
| [ReleaseUpdateStep](#releaseupdatestep) | Release & Migration | 4 | 49.0 |
| [SandboxInfo](#sandboxinfo) | Sandbox | 13 | 35.0 |
| [SandboxProcess](#sandboxprocess) | Sandbox | 21 | 35.0 |
| [SandboxProcessStage](#sandboxprocessstage) | Sandbox | 11 | 66.0 |
| [SourceMember](#sourcemember) | Deploy & Source | 0 (reserved) | — |
| [SourceMemberDeployRequest](#sourcememberdeployrequest) | Deploy & Source | 0 (reserved) | — |

> 메인 객체 필드 행 합계 = **148** + OperationLog 복합 타입 sub-field 10 = **158**. SourceMember·SourceMemberDeployRequest는 reserved(0행)이라 합계에 기여하지 않는다.

---

## Sandbox (샌드박스)

> 샌드박스 생성·새로고침·삭제를 관리하는 3종. **SandboxInfo** 가 생성/새로고침을 큐에 넣고, 그때마다 **SandboxProcess** 가 자동 생성되어 복사 진행을 모니터링하며, **SandboxProcessStage** 가 단계별 실시간 진행 상황을 제공한다. 샌드박스 종류·복사 정책·릴리즈 프리뷰 등 운영 맥락은 [[Sandbox 관리]] 참조.

### SandboxInfo

Represents a sandbox.

SandboxInfo enqueues a sandbox for creation or refresh. A create operation on SandboxInfo represents creation of a new sandbox, and an update represents refresh of an existing sandbox. For every creation or update, a SandboxProcess is automatically created and is used for monitoring the sandbox copy process. This object is available in API version 35.0 and later.

> 샌드박스 종류(Developer/Developer Pro/Partial Copy/Full)·프리뷰 타이밍·템플릿 운영 맥락은 [[Sandbox 관리]] 참조.

- **Version:** API 35.0 and later
- **Supported SOAP Calls:** create(), delete(), query(), retrieve(), update()
- **Supported REST HTTP Methods:** GET, PATCH, POST, DELETE
- **Special Access Rules:** none stated.

| Field | Type | Properties | Description |
|---|---|---|---|
| ActivationUserGroupId | reference | Create, Filter, Group, Nillable, Sort, Update | A reference to the ID of the public group consisting of users who can access the sandbox. The user who created the sandbox is added to the group by default. This field is a relationship field. **Restrictions:** • You can specify this value only during sandbox creation and refresh. • Available in API version 60.0 and later. • Behavior change announcement: Starting in Spring '25, this field will be required when creating or refreshing a Developer or Developer Pro sandbox. To avoid losing the ability to create or refresh Developer and Developer Pro sandboxes, use API version 60.0 or later. Relationship Name: ActivationUserGroup; Relationship Type: Lookup; Refers To: Group. |
| ApexClassId | reference | Create, Filter, Group, Nillable, Sort, Update | A reference to the ID of an Apex class that runs after each copy of the sandbox. Allows you to perform business logic on the sandbox to prepare it for use. **Restrictions:** • You can specify this value only during sandbox creation. • The class must extend the System.SandboxPostCopy interface. • Available in API version 36.0 and later. Relationship Name: ApexClass; Relationship Type: Lookup; Refers To: ApexClass. |
| AutoActivate | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | If true, you can activate a sandbox refresh immediately. **Restrictions:** This field only affects behavior for update operations (Sandbox refresh). |
| CopyArchivedActivities | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | If true, archived activity data is copied to the sandbox. **Restrictions:** This field is visible only if your organization has purchased an option to copy archived activities for sandbox. To obtain this option, contact Salesforce Customer Support. You can set the value to true only for a Full sandbox. |
| CopyChatter | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | If true, archived Chatter data is copied to the sandbox. **Restrictions:** You can set the value to true only for a Full sandbox. |
| Description | string | Create, Filter, Nillable, Sort, Update | A description of the sandbox, which helps you distinguish it from other sandboxes. **Restrictions:** The description length can't exceed 1,000 characters. |
| Features | textarea | Create, Nillable, Update | The add-on features to apply when creating or refreshing the sandbox. Currently there's one valid value: • `['SandboxStorage']`: Increases the data storage available for Developer sandboxes from 200 MB to 400 MB and Developer Pro sandboxes from 1 GB to 2 GB. You can't use this feature with Partial Copy or Full sandboxes. |
| HistoryDays | int | Create, Defaulted on create, Filter, Group, Sort, Update | Represents the number of days of object history to be copied in the sandbox. Valid values: • -1, which means all available days • 0 (default) • 10 • 20 • 30 • 60 • 90 • 120 • 150 • 180. **Restrictions:** This field affects behavior only for Full sandboxes. |
| IsNonPreview | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | If true, creates a non-preview sandbox. During the transition from one Salesforce major release to another, sandboxes get upgraded on different timelines based on their release type. Preview sandboxes provide early access to new features and are upgraded approximately six weeks before production orgs, while non-preview sandboxes are upgraded as the major release upgrade completes. Between the completion of a major release upgrade and the start of the next release upgrade, we attempt to create preview sandboxes by default when you create or refresh a sandbox. Use a non-preview sandbox to test changes in an environment that's identical to your production org without potential issues from the next release upgrade. **Note:** If you create a non-preview sandbox 24 hours or less from the start of the next release upgrade, we can't guarantee that the non-preview sandbox creation will be successful. See Salesforce Sandbox Preview Instructions in Salesforce Help for more information on release transitions and timelines. **Restrictions:** • Non-preview sandbox creation is a restricted feature. Contact Salesforce Customer Support to enable the feature and related API in your production org. • The IsNonPreview field is valid only between the completion of a major release upgrade and the start of the next release upgrade. If you create a sandbox outside of this window of time, remove the IsNonPreview field. |
| LicenseType | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | Represents the sandbox license type. Valid values: • DEVELOPER • DEVELOPER_PRO • PARTIAL • FULL |
| SandboxName | string | Create, Filter, Group, idLookup, Sort, Update | Name of the sandbox. **Restrictions:** • Must be a unique sandbox name. • Must be alphanumeric characters. • Must be 10 or fewer characters. • Can't be the same as the name of a sandbox that's pending deletion. |
| SourceId | reference | Create, Filter, Group, Nillable, Sort, Update | A reference to the ID of a SandboxInfo that serves as the source org for a cloned sandbox. Relationship Name: Source; Relationship Type: Lookup; Refers To: SandboxInfo. |
| TemplateId | reference | Create, Filter, Group, Nillable, Sort, Update | A reference to the PartitionLevelScheme that represents the sandbox template associated with this sandbox. A sandbox template lets you select which objects to copy in a sandbox. To use the TemplateId field, you must have the ManageSandboxes user permission. **Restrictions:** • Setting a TemplateId value for a Partial Copy sandbox is required. • Setting a TemplateId value for a Full sandbox is optional. • Setting a TemplateId value for other sandbox types is prohibited, because other sandbox types don't support sandbox templates. Relationship Name: Template; Relationship Type: Lookup; Refers To: PartitionLevelScheme. |

> ⚠️ **LicenseType 비교 주의:** SandboxInfo.LicenseType 는 **4값**(DEVELOPER, DEVELOPER_PRO, PARTIAL, FULL)이고, SandboxProcess.LicenseType 는 **7값**(ADVANCED_DEV, ADVANCED_FULL, FULL_PLUS 추가)이다. 두 값 집합은 다르므로 혼용하지 않는다.

**Usage:** SandboxInfo and SandboxProcess work together to manage the creation or refresh of a sandbox.

- **Creating a Sandbox** — To enqueue a new sandbox:
  - Create a SandboxInfo record.
  - To find the status of a sandbox after it is enqueued, query SandboxProcess for a given SandboxInfoId field to find the latest SandboxProcess record. The value of Completed in Status indicates that the creation process is finished.
- **Refreshing a Sandbox** — To refresh a sandbox:
  - To start a sandbox refresh, edit the SandboxInfo record.
  - To find the status of a sandbox after it is enqueued, find the latest SandboxProcess record by querying SandboxProcess for a given SandboxInfoId value. The value of Status indicates the current state of the process.
  - When the Status field value is Pending Activation, change the value of the RefreshAction field to either ACTIVATE or DISCARD.
- **Deleting a Sandbox** — To delete a sandbox, delete the SandboxInfo record that represents the sandbox. Deleting the SandboxInfo record deletes the sandbox and frees up a license.
- **Checking Sandbox Progress** — Each SandboxProcess record progresses through several stages represented by the StageType and StageNumber on the SandboxProcessStage record. The system updates progress details as the copy proceeds. For every stage, you can view specifics using the Status, StartTime, EndTime, and InfoLastUpdated fields. If your sandbox status is suspended or stopped for more than 1 hour, contact Salesforce customer support. While the system can't provide a time-based estimate, you can track your place in the queue or how much work exists and has been completed.
  - During the In Queue stage, you can check your current place in the queue with the EstimatedTotalWork field.
  - During the Data Copy and Activation stages, you can check how much work exists and has been completed to estimate copy completion with the EstimatedTotalWork, ActualTotalWork, and CompletedWork fields.
  > **Note:** • If IsActualWorkFinal = true, then ActualTotalWork is a better representation of the total work required. • If IsActualWorkFinal = false, then EstimatedTotalWork is a better representation of the total work required.

### SandboxProcess

Represents the sandbox copy process for a SandboxInfo record.

When you create a SandboxInfo record, a corresponding SandboxProcess record is created. The latest SandboxProcess record for a SandboxInfo record represents the current state of the sandbox. This object is available in API version 35.0 and later.

- **Version:** API 35.0 and later
- **Supported SOAP Calls:** query(), retrieve(), update()
- **Supported REST HTTP Methods:** GET, PATCH
- **Fields 주석:** Except for RefreshAction, all fields are read only. The read-only fields represent the attributes chosen on SandboxInfo when a copy process was enqueued, or represent the state of the process for monitoring purposes.

| Field | Type | Properties | Description |
|---|---|---|---|
| ActivatedById | reference | Filter, Group, Nillable, Sort | A reference to the ID of the user who requested sandbox activation. Relationship Name: ActivatedBy; Relationship Type: Lookup; Refers To: User. |
| ActivatedDate | dateTime | Filter, Nillable, Sort | Represents when the sandbox was activated during a refresh. |
| ActivationUserGroupId | reference | Filter, Group, Nillable, Sort, Update | A reference to the ID of the group consisting of users who can access the sandbox. The user who created the sandbox is added to the group by default. Available in API version 60.0 and later. This field is a relationship field. Relationship Name: ActivationUserGroup; Relationship Type: Lookup; Refers To: Group. |
| ApexClassId | reference | Filter, Group, Nillable, Sort | A reference to the ID of an Apex class to run after each copy of the sandbox. Running this class allows you to perform DML operations on the sandbox to prepare it for use. The class must extend the System.SandboxPostCopy interface. Available in API version 36.0 and later. Relationship Name: ApexClass; Relationship Type: Lookup; Refers To: ApexClass. |
| AutoActivate | boolean | Defaulted on create, Filter, Group, Sort | Represents whether the sandbox refresh is configured to activate immediately upon completion. |
| CopyArchivedActivities | boolean | Defaulted on create, Filter, Group, Sort | If true, archived activity data is copied to the sandbox. **Restrictions:** This field is visible only if your organization has purchased an option to copy archived activities for sandbox. To obtain this option, contact Salesforce Customer Support. You can set the value to true only for a Full sandbox. |
| CopyChatter | boolean | Defaulted on create, Filter, Group, Sort | Represents whether archived Chatter data is copied to the sandbox. |
| CopyProgress | int | Filter, Group, Nillable, Sort | Represents how much of a copy has been completed. Available for Developer, Developer Pro, and Full sandboxes. Not available for Full or Partial sandboxes created from sandbox templates. |
| Description | string | Filter, Nillable, Sort | A description of the sandbox, which helps you distinguish it from other sandboxes. |
| EndDate | dateTime | Filter, Nillable, Sort | Represents when the sandbox copy process finished. |
| Features | textarea | Nillable, Update | The list of add-on features to apply after the sandbox is created or refreshed. Currently there's one valid value: • `['SandboxStorage']`: Increases the data storage available for Developer sandboxes from 200 MB to 400 MB and Developer Pro sandboxes from 1 GB to 2 GB. You can't use this feature with Partial Copy or Full sandboxes. |
| HistoryDays | int | Defaulted on create, Filter, Group, Sort | Represents the number of days of object history to be copied in the sandbox. Valid values: • -1, which means all available days • 0 • 10 • 20 • 30 • 60 • 90 • 120 • 150 • 180 |
| LicenseType | picklist | Filter, Group, Restricted picklist, Sort | The sandbox license type. Valid values: • ADVANCED_DEV • ADVANCED_FULL • DEVELOPER • DEVELOPER_PRO • PARTIAL • FULL • FULL_PLUS |
| RefreshAction | picklist | Filter, Group, Nillable, Restricted picklist, Sort, Update | Editing this field activates or discards a sandbox refresh. Valid values: • ACTIVATE • DISCARD. **Restrictions:** If all the following are true, you can activate or discard a sandbox refresh by editing the value in this field. • This record is the latest SandboxProcess record. • The associated sandbox has been refreshed. • This record's Status is Pending Activation. (※ RefreshAction이 유일하게 read-only가 아닌 필드) |
| SandboxInfoId | reference | Filter, Group, Nillable, Sort | A reference to the ID of the SandboxInfo being processed (create or refresh). Relationship Name: SandboxInfo; Relationship Type: Lookup; Refers To: SandboxInfo. |
| SandboxName | string | Filter, Group, idLookup, Sort | The name of the sandbox. |
| SandboxOrganization | string | Filter, Group, Nillable, Sort | The ID of the org created by the copy process. This field is available in API version 37.0 and later. |
| SourceId | reference | Filter, Group, Nillable, Sort, Update | A reference to the ID of the SandboxInfo that this sandbox is a clone of. This field is used only when cloning a sandbox. When this field is used, LicenseType must be null. Your source sandbox must be an existing, completed sandbox, that belongs to the same production org as the sandbox you're creating or refreshing. Your SourceId value can't be the same SandboxInfo that you're updating. Available in API version 37.0 and later. Relationship Name: Source; Relationship Type: Lookup; Refers To: SandboxInfo. |
| StartDate | dateTime | Filter, Nillable, Sort | Represents when the sandbox copy process started. |
| Status | string | Filter, Group, Nillable, Sort | Current state of the sandbox copy process. If running a SOQL query, use the values in parentheses. Possible values include: • **Activating** — Activation Confirmed (5) / Deactivation Confirmed (6) / Deactivation Finished (7) / Activation Processing (8) • Completed (1) • Deleted (D) • Deleting (E) • Discarding (F) • Locked (B) • Locking (L) • Pending (0) • Pending Activation (4) • Processing (2) • Sampling (X) • Stopped (G) • Suspended (S) |
| TemplateId | reference | Filter, Group, Nillable, Sort | A reference to the ID of the PartitionLevelScheme that represents the sandbox template associated with the sandbox for this process. A sandbox template selects which objects to copy in a sandbox. To use the TemplateId field, you must have the ManageSandboxes user permission. Relationship Name: Template; Relationship Type: Lookup; Refers To: PartitionLevelScheme. |

> SandboxProcess.Status 는 **17개 표시값**으로, Activating 아래에 4개 하위 상태(Activation Confirmed 5 · Deactivation Confirmed 6 · Deactivation Finished 7 · Activation Processing 8)가 중첩된다. SOQL 쿼리 시에는 괄호 안 코드(예: `1`, `D`, `S`)를 사용한다. enum은 843→844 페이지 경계를 넘어 stitch 검증 완료(Suspended (S)에서 종료, 숨은 값 없음).

**Usage:** SandboxInfo represents a sandbox, and SandboxProcess represents the sandbox copy process, which occurs when you create a sandbox or refresh it. You can also delete a sandbox. (이하 Creating / Refreshing / Deleting / Checking Sandbox Progress 절차는 위 [SandboxInfo](#sandboxinfo) Usage와 동일한 boilerplate이다.)

### SandboxProcessStage

Represents the status and progress during a spectific [sic] stage for a SandboxProcess record.

Provides real time visibility into the status and progress of the sandbox copy so users can effectively plan and manage their development and testing activities. This object is available in API version 66.0 and later.

- **Version:** API 66.0 and later
- **Supported SOAP Calls:** query(), retrieve()
- **Supported REST HTTP Methods:** GET
- **Fields 주석:** All fields are read only and represent the status and progress of the sandbox for monitoring purposes.

| Field | Type | Properties | Description |
|---|---|---|---|
| SandboxProcess | reference | Filter, Group, Nillable, Sort | Indicates the sandbox process that this progress belongs to. Relationship Name: SandboxProcess; Relationship Type: Lookup; Refers To: SandboxProcess. |
| StageType | picklist | Filter, Group, Nillable, Sort | Indicates the type of stage. Valid values: • In Queue • Data Copy • Pending Activation • Activation. Refers To: SandboxProcess. |
| StageNumber | int | Filter, Group, Nillable, Sort | Indicates the order of the stages. • 0 In Queue • 1 Data Copy • 2 Pending Activation • 3 Activation |
| Status | picklist | Filter, Group, Nillable, Sort | Indicates whether the stage has completed or not. Valid values: • Pending • In Progress • Completed |
| StartTime | dateTime | Filter, Group, Nillable, Sort | When the stage's status goes into In Progress. |
| EndTime | dateTime | Filter, Group, Nillable, Sort | When the stage's status goes into Completed. |
| InfoLastUpdated | dateTime | Filter, Group, Nillable, Sort | When we last checked the internal system for progress information on this stage. |
| CompletedWork | int | Filter, Group, Nillable, Sort | Indicates the current amount of work completed. **Restrictions:** Only used for Data Copy and Activation. |
| ActualTotalWork | int | Filter, Group, Nillable, Sort | Indicates the verified amount of work to be completed. This number calculates continuously and may represent a partial amount while IsActualWorkFinal=false. **Restrictions:** Only used for Data Copy and Activation. |
| IsActualWorkFinal | boolean | Filter, Group, Nillable, Sort | Default false, set to true after calculation of the actual work completes. |
| EstimatedTotalWork | int | Filter, Group, Nillable, Sort | During the In Queue stage, this represents the number of sandboxes ahead of yours. During the Data Copy and Activation stages, this represents an estimation of work while IsActualWorkFinal=false. The estimation total derives this value from a prior sandbox copy and doesn't change throughout processing. This estimation isn't available if there's no prior copy. |

**Usage:** SandboxInfo (p821) represents a sandbox, and SandboxProcess (p828) represents the sandbox copy process, which occurs when you create a sandbox or refresh it. SandboxProcessStage represents the status and progress of a copy during a specific stage within the sandbox copy process. (이하 Creating / Refreshing / Deleting / Checking Sandbox Progress 절차는 [SandboxInfo](#sandboxinfo) Usage와 동일 boilerplate.)

---

## Deploy & Source (메타데이터 배포 · 소스 추적)

> 메타데이터 배포 요청(DeployRequest)과 컴파일 오류 complex type(DeployDetails), 그리고 내부 예약 소스 추적 객체(SourceMember·SourceMemberDeployRequest). 컨테이너 기반(MetadataContainer·Apex\*Member) 배포 흐름의 정본은 [[Tooling API 배포]] 참조.

### DeployRequest

Uses file representations of metadata components to create, update, or delete those components in a Salesforce org. This object is available in API version 49.0 and later.

> 컨테이너 배포 패밀리(MetadataContainer·ContainerAsyncRequest·Apex\*Member) 및 배포 전 과정의 정본은 [[Tooling API 배포]] 참조.

- **Version:** API 49.0 and later
- **Supported SOAP Calls:** describeSObjects(), query(), retrieve().
- **Supported REST HTTP Methods:** GET, HEAD, Query
- **Special Access Rules:** Your client application must be logged in with the Modify Metadata Through Metadata API Functions OR Modify All Data permission.
  > **Note:** If a user requires access to metadata but not to data, enable the Modify Metadata Through Metadata API Functions permission. Otherwise, enable the Modify All Data permission.

| Field | Type | Properties | Description |
|---|---|---|---|
| AllowMissingFiles | boolean | Defaulted on create, Filter, Group, Sort | If files that are specified in package.xml are not in the .zip file, specifies whether a deployment can still succeed (true) or not (false). Do not set this argument to true for deployment to production orgs. The default value is false. |
| AutoUpdatePackage | boolean | Defaulted on create, Filter, Group, Sort | If a file is in the .zip file but not specified in package.xml, specifies whether the file is automatically added to the package (true) or not (false). A retrieve() is issued with the updated package.xml that includes the .zip file. Do not set this argument to true for deployment to production orgs. The default value is false. |
| CanceledById | reference | Filter, Group, Nillable, Sort | The ID of the user who canceled the deployment. This is a relationship field. Relationship Name: CanceledBy; Relationship Type: Lookup. |
| ChangeSetName | string | Filter, Group, Nillable, Sort | Specifies the name of the change set for the deployment. |
| CheckOnly | boolean | Defaulted on create, Filter, Group, Sort | Indicates whether this deployment is being used to check the validity of the deployed files without making any changes in the organization (true) or not (false). A check-only deployment does not deploy any components or change the organization in any way. The default value is false. |
| CompletedDate | dateTime | Filter, Nillable, Sort | Timestamp for when the deployment process ended. |
| DeployTestResults | QueryResult | Filter, Nillable, Sort | Specifies the deployment test result. |
| ErrorMessage | string | Filter, Nillable, Sort | Message corresponding to the values in the ErrorStatusCode field, if any. |
| ErrorStatusCode | QueryResult | Filter, Group, Nillable, Sort | If an error occurred during the deploy() call, a status code is returned, and the message corresponding to the status code is returned in the ErrorMessage field. For a description of each StatusCode value, see "StatusCode" in the SOAP API Developer Guide. |
| IgnoreWarnings | boolean | Defaulted on create, Filter, Group, Sort | Specifies whether a deployment should continue even if the deployment generates warnings (true) or not (false). Do not set this argument to true for deployments to production organizations. The default value is false. |
| NumberComponentErrors | int | Filter, Group, Nillable, Sort | The number of components that generated errors during this deployment. |
| NumberComponentsDeployed | int | Filter, Group, Nillable, Sort | The number of components deployed in the deployment process. Use this value with the NumberComponentsTotal value to get an estimate of the deployment's progress. |
| NumberComponentsTotal | int | Filter, Group, Nillable, Sort | The total number of components in the deployment. Use this value with the NumberComponentsDeployed value to get an estimate of the deployment's progress. |
| NumberTestErrors | int | Filter, Group, Nillable, Sort | The number of Apex tests that have generated errors during this deployment. |
| NumberTestsCompleted | int | Filter, Group, Nillable, Sort | The number of completed Apex tests for this deployment. Use this value with the NumberTestsTotal value to get an estimate of the deployment's test progress. |
| NumberTestsTotal | int | Filter, Group, Nillable, Sort | The total number of Apex tests for this deployment. Use this value with the NumberTestsCompleted value to get an estimate of the deployment's test progress. The value in this field is not accurate until the deployment has started running tests for the components being deployed. |
| PurgeOnDelete | boolean | Defaulted on create, Filter, Group, Sort | Indicates whether to purge on delete (true) or not (false). The default value is false. |
| RollbackOnError | boolean | Defaulted on create, Filter, Group, Sort | Indicates whether any failure causes a complete rollback (true) or not (false). If false, whatever set of actions can be performed without errors are performed, and errors are returned for the remaining actions. This parameter must be set to true if you are deploying to a production organization. The default value is false. |
| RunTestsEnabled | boolean | Defaulted on create, Filter, Group, Sort | Indicates whether Apex tests were run as part of this deployment (true) or not (false). Tests are either automatically run as part of a deployment or can be set to run in DeployOptions for the deploy() call. For information on when tests are automatically run, see Running Tests in a Deployment. The default value is false. |
| SinglePackage | boolean | Defaulted on create, Filter, Group, Sort | Indicates whether to deploy as a single package (true) or not (false). The default value is false. |
| StartDate | dateTime | Filter, Nillable, Sort | Timestamp for when the deployment process began. |
| StateDetail | string | Filter, Nillable, Sort | Indicates which component is being deployed or which Apex test class is running. |
| Status | picklist | Filter, Group, Nillable, Restricted picklist, Sort | The current state of the deployment. Possible values are: • Canceled • Canceling • Failed • InProgress • Pending • Succeeded • SucceededPartial |
| TestLevel | picklist | Filter, Group, Nillable, Restricted picklist, Sort | Indicates which tests to run. Possible values are: • NoTestRun • RunAllTestsInOrg • RunLocalTests • RunSpecifiedTests |
| Type | picklist | Defaulted on create, Filter, Group, Restricted picklist, Sort | The type of deployment to perform. Possible values are: • Api (default) • Changeset |

#### DeployDetails (complex type)

A complex type that contains detailed XML for any compile errors reported in the asynchronous request defined by a ContainerAsyncRequest object. Replaces the JSON field CompilerErrors in Tooling API version 31.0 and later.

> DeployDetails는 독립 sObject가 아니라 DeployRequest 섹션 페이지(phys 311) 상단에 등장하는 complex type이다. Supported Calls / REST methods 없음.

| Field | Type | Description |
|---|---|---|
| componentFailures | string | The line number, component name and a short description for any compile errors. For example: |

```xml
<DeployDetails>
    <componentFailures>
        <lineNumber>5</lineNumber>
        <fullName>myApex</fileName>
        <problem>invalid name 'abc'</problem>
    </componentFailures>
    <componentFailures>
        <lineNumber>10</lineNumber>
        <fullName>myApex2</fileName>
        <problem>invalid type 'hello'</problem>
    </componentFailures>
</DeployDetails>
```

> 위 XML은 PDF 원문 verbatim이며, 여는 태그 `<fullName>` 와 닫는 태그 `</fileName>` 가 일치하지 않는 원문 오류를 그대로 보존한다 [sic].

### SourceMember

**Reserved for internal use. Do not use this object. Accuracy of results isn't guaranteed.**

> Supported Calls / REST Methods / Fields 없음 — reserved-for-internal-use stub. 소스 추적의 실제 개발자 워크플로(`sf project retrieve start` 등)는 [[Source Tracking 변경 추적]] 참조.

### SourceMemberDeployRequest

**Reserved for internal use.**

> Supported Calls / REST Methods / Fields 없음 — reserved-for-internal-use stub. SourceMember 바로 다음에 등장하며, 그다음 StandardAction(본 그룹 아님)이 시작된다.

---

## Release & Migration (릴리즈 업데이트 · 플랫폼이벤트 마이그레이션)

> 개별 릴리즈 업데이트(ReleaseUpdate)와 그 하위 단계(ReleaseUpdateStep), 그리고 표준 볼륨 플랫폼 이벤트를 고볼륨으로 1회성 전환하는 PlatformEventMigration. 릴리즈 업데이트의 분기별 enforce 정책 맥락은 각 릴리즈 노트의 Release Updates 섹션 참조.

### ReleaseUpdate

Represents an individual release update. Available in API version 50.0 and later.

- **Version:** API 50.0 and later
- **Supported SOAP Calls:** describeSObjects(), query()
- **Supported REST HTTP Methods:** Query

| Field | Type | Properties | Description |
|---|---|---|---|
| ApiVersion | double | Filter, Nillable, Sort | The API version to which the update is applied. |
| Category | string | Filter, Group, Nillable, Sort | Indicates the type of the release update. For example, "Security" or "Usability." |
| Description | string | Filter, Nillable, Sort | The description of the update that appears on the front of the card. |
| DeveloperName | string | Filter, Group, Nillable, Sort | The unique name of the release update. |
| DueDate | date | Filter, Group, Nillable, Sort | The date by which test runs must be completed. |
| DurableId | string | Filter, Group, Nillable, Sort | The unique name of the release update. |
| HasNewSteps | boolean | Defaulted on create, Filter, Group, Sort | Indicates if steps have been added to the release update since its original release (true) or not (false). |
| IsReleased | boolean | Defaulted on create, Filter, Group, Sort | Indicates if the update is released (true) or not (false). |
| NumCompSteps | integer | Filter, Group, Nillable, Sort | Indicates how many steps have been completed in the update. |
| NumReqSteps | integer | Filter, Group, Nillable, Sort | Indicates the total number of required steps before proceeding with test run. |
| NumSteps | integer | Filter, Group, Nillable, Sort | Indicates the total number of all steps in the update. |
| Release | string | Filter, Group, Nillable, Sort | The release, including patch number, in which the update is available. For example, 50.00.00. **Note:** Also see ReleaseDate and ReleaseLabel. |
| ReleaseDate | date | Filter, Group, Nillable, Sort | The date in which the update is enforced. **Note:** Only specified if the update is part of a scheduled release, so either Release or ReleaseDate will be non-null. Also see Release and ReleaseLabel. |
| ReleaseLabel | string | Filter, Group, Nillable, Sort | The release label in which the update is enforced. For example, "Winter '21." The label could also be a formatted date if Release is null and ReleaseDate is non-null. |
| Status | picklist | Filter, Group, Nillable, Restricted picklist, Sort | Values include: • **Complete**: The update has been applied. • **Info**: An information-only update; no actions to take. • **Invocable**: The update is not yet applied; ready for invocation. • **Invoked**: The update has been invoked but can't be revoked yet. • **Nascent**: The update has incomplete steps so test run can't be run yet. • **Pending**: The Complete Steps By date is in the past and update is awaiting enforcement. • **Revocable**: The update is in test run mode. |
| StepStage | string | Filter, Group, Nillable, Sort | Indicates the stage in which the update is at. Options include Needs Action, Due Soon, Overdue, and Archived. |
| SupportsRevoke | boolean | Defaulted on create, Filter, Group, Sort | Indicates if the update has a test run (true) or not (false). Default is false. |
| Title | string | Filter, Nillable, Sort | The release update title that appears at the top of the release update in the UI. |

### ReleaseUpdateStep

Represents an individual release update step. Available in API version 49.0 and later.

- **Version:** API 49.0 and later
- **Supported SOAP Calls:** create(), describeSObjects(), getDeleted(), getUpdated(), query(), retrieve(), update(), upsert()
- **Supported REST HTTP Methods:** GET, HEAD, PATCH, POST, Query
- **Special Access Rules:** To enable or disable release updates, users must have the Manage Release Updates or Customize Application permission.

| Field | Type | Properties | Description |
|---|---|---|---|
| Name | string | Create, Filter, Group, idLookup, Sort, Update | The name of the release update step. |
| Number | int | Create, Filter, Group, Sort, Update | The corresponding number for this release update step. |
| ReleaseUpdateId | string | Create, Filter, Group, Sort, Update | The ID of the related release update. This field is a relationship field. Relationship Name: ReleaseUpdate; Refers To: ReleaseUpdate. |
| Status | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | The status of the release update step. Possible values are: • Complete • Incomplete • New • Started • Viewed |

### PlatformEventMigration

Represents configuration settings for performing a one-time migration of standard volume platform events to high volume platform events. This object is available in API version 67.0 and later.

- **Version:** API 67.0 and later
- **Supported SOAP Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST HTTP Methods:** DELETE, GET, PATCH, POST

| Field | Type | Properties | Description |
|---|---|---|---|
| DeveloperName | string | Create, Filter, Group, Sort, Update | The unique name for the PlatformEventMigration object. This name can contain only underscores and alphanumeric characters, and must be unique in your org. It must begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. This field is automatically generated, but you can supply your own value if you create the record using the API. **Note:** When creating large sets of data, always specify a unique DeveloperName for each record. If no DeveloperName is specified, performance can slow down while Salesforce generates one for each record. **Note:** Only users with View DeveloperName OR View Setup and Configuration permission can view, group, sort, and filter this field. |
| EventObject | reference | Create, Filter, Group, Nillable, Sort, Update | The ID of a standard volume platform event that needs to be migrated to a high volume platform event. You can find the ID by executing this Tooling API SOQL query in the developer console: `SELECT Id FROM CustomObject WHERE DeveloperName='YourStandardVolumePlatformEvent'` The name to use as the DeveloperName of your SVPE is labeled Object Name in the UI. |
| MasterLabel | string | Create, Filter, Group, Sort, Update | Label for PlatformEventMigration. |

> ⚠️ Fields 표에는 위 3개만 문서화되어 있다. Usage의 SOQL 예제는 추가 read-only 필드명 **MigrationStatus · StartDate · EndDate · HighVolumePosition** 을 참조하지만, 이들은 Fields 표에 미문서화되어 있다 — 필드 행으로 발명하지 않고 "Usage SOQL에서만 언급됨"으로만 기록한다.

**Usage:** All standard volume platform events must be migrated to high volume platform events before Winter '27. This API provides a means for migration. Standard volume platform events that aren't migrated won't work starting in Winter '27.

Before starting a migration, ensure that all publish activity has stopped and all subscribers, including triggers and flows, are done processing, then perform a POST request to this endpoint.

```
/services/data/v67.0/tooling/sobjects/PlatformEventMigration
```

Provide the values in the request body. This example request starts migrating the standard volume platform event 01Ixx0000005aUJ to a high volume platform event.

```json
{
    "DeveloperName":"svpeConfig",
    "MasterLabel":"svpeConfig",
    "EventObject": "01Ixx0000005aUJ"
}
```

A successful POST request returns a response that includes an ID.

```json
{
    "id":"1hXxx00000000mPEAQ",
    "Success":true,
    "Errors":[],
    "Warnings":[],
    "infos":[]
}
```

To check the status of your migration, use the ID in a GET request to this endpoint.

```
/services/data/v67.0/tooling/sobjects/PlatformEventMigration<ID>
```

All these requests use the endpoint with the PlatformEventMigration record ID appended.
- Get the status of a specific migration with a GET request.
- Delete a specific migration with a DELETE request. Deleting a migration may not work because the migration could finish processing before the DELETE request is received. Because migration is a one-way door, it can't be undone after it's already happened.
- Update a specific migration with a PATCH request. For this request, include the PlatformEventMigration definition in the request body.

Once a migration has started, publishes won't work and you'll be unable to create new triggers or flows until the migration finishes. A migration usually takes 10–15 minutes, but can last as long as 24 hours in some cases. You will receive an email when the migration is complete.

Also, you can query and retrieve the configurations in your org with SOQL. If querying from the Developer Console Query Editor, ensure that you select Use Tooling API. This example query retrieves all configurations set up in your Salesforce org.

```
SELECT Id, DeveloperName, MasterLabel, EventObject, MigrationStatus, StartDate, EndDate, HighVolumePosition FROM PlatformEventMigration
```

---

## Org Ops (필드 히스토리 아카이브 · 비동기 작업 로그 · HTTP 헤더)

> 필드 히스토리 보존 작업(HistoryRetentionJob), Tooling API를 통해 트리거된 장기/비동기 작업 로그(OperationLog), OData 외부 데이터 소스용 커스텀 HTTP 헤더(CustomHttpHeader).

### HistoryRetentionJob

Represents the body of retained data from the archive, and the status of the archived data. Available in API version 29.0 or later.

- **Version:** API 29.0 or later
- **Supported SOAP Calls:** describeSObjects(), query()
- **Supported REST HTTP Methods:** GET

| Field | Type | Properties | Description |
|---|---|---|---|
| DurationSeconds | int | Filter, Group, Nillable, Sort | How many seconds the field history retention job took to complete (whether successful or not). |
| HistoryType | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort | The object type that contains the field history that you retained. Valid values for standard objects are: • Account • Case • Contact • Leads • Opportunity. For custom objects, use the object name. |
| NumberOfRowsRetained | int | Filter, Group, Nillable, Sort | The number of field history rows that a field history retention job has retained. |
| RetainOlderThanDate | dateTime | Filter, Sort | The date and time before which all field history data was retained. |
| StartDate | dateTime | Filter, Nillable, Sort | The start date of the field history retention job. |
| Status | picklist | Filter, Group, Nillable, Restricted picklist, Sort | Provides the status of the field history retention job. By default, field history tracking copies data to the archive, leaving a duplicate of the archived data in Salesforce. You can delete data from Salesforce manually after it's archived. Status can include: • CopyScheduled • CopyRunning • CopySucceeded • CopyFailed • CopyKilled • NothingToArchive • DeleteScheduled • DeleteRunning • DeleteSucceeded • DeleteFailed • DeleteKilled |

### OperationLog

Represents long-running or asynchronous operations triggered and tracked through Tooling API. This object is available in API version 37.0 and later.

- **Version:** API 37.0 and later
- **Supported SOAP Calls:** create(), describeSObjects()
- **Supported REST HTTP Methods:** Query, GET, POST
- **Special Access Rules:** As of the Spring '20 release, to access OperationLog you must have the View Setup user permission.

| Field | Type | Properties | Description |
|---|---|---|---|
| DetailedStatus | string | Filter, Group, Nillable, Sort | Complements the Status field with an operation processor-specific status code. |
| Message | string | Filter, Group, Nillable, Sort | Complements the Status field with information helpful to the user. For example, if Status=FAILED, state the reason in this field. |
| Parameters | OperationParameters | Create, Nillable | A complex type that represents a set of parameters passed to the operation processor. Specify the parameters by using the OperationPayload value that corresponds to your operation type. |
| Status | picklist | Filter, Group, Restricted picklist, Sort | Indicates the status of an operation triggered through Tooling API. Valid values are: • NEW • RUNNING • COMPLETED • FAILED • ABORTED. Only records with Status=NEW can be created through the API. |
| Type | picklist | Create, Filter, Group, Restricted picklist, Sort | The type of operation submitted through Tooling API. For each operation type, use the corresponding payload of input parameters. Valid operation types are: • **RunTerritoryRules** — Runs account assignment rules for any territory that has rules defined and belongs to a territory model in Planning or Active state. When you run rules from Setup, accounts are assigned to territories according to your rules if your territory model is in Active or Planning state. Accounts are assigned to territories according to your rules automatically on account creation or update only if your territory model is in Active state. When you choose this operation type, use the payload Territory2RunTerritoryRulesPayload in the Parameters field. • **RunOppTerrAssignmentApex** — Uses filter-based opportunity territory assignment to assign territories to opportunities using a simple job. We provide code for an Apex class that you can use as-is or modify as needed based on our guidelines. After you create and deploy the class, run the job to complete the assignment process. Job options include making assignments within date ranges and assigning territories to open opportunities only. When you choose this operation type, use the payload Territory2RunOppTerrAssignmentApexPayload in the Parameters field. |

> [!note] PDF 레이아웃 artifact — OperationLog 필드 아님
> phys 663에서 OperationLog running-header 아래에 **changeOwnPassword** complex type가 섞여 등장하지만, 이는 실제로는 `System.changeOwnPassword()` 호출용 타입(API 40.0+, 필드: oldPassword·newPassword)으로 **OperationLog의 sub-type이 아니다.** 본 노트의 OperationLog 필드 목록에 포함하지 않는다.

**OperationLog 연관 복합 타입 (같은 페이지 범위)**

**OperationParameters** — Represents parameters to be passed to an operation triggered by Tooling API. This type is available in API version 37.0 and later.

| Field | Type | Description |
|---|---|---|
| payload | OperationPayload | Use the payload that corresponds to the type of operation you want to trigger through Tooling API. Valid values are: • Territory2RunTerritoryRulesPayload • Territory2RunOppTerrAssignmentApexPayload |

**OperationPayload** — Represents a named set of input parameters, or payload, that corresponds to the operation type specified in the Type field of OperationLog. For example, if you choose the operation type RunTerritoryRules, use the payload Territory2RunTerritoryRulesPayload. Payloads that are supported by OperationLog are extensions of the OperationPayload type. This type is available in API version 37.0 and later. (필드 없음 — base type)

**Territory2RunTerritoryRulesPayload** — Represents a set of parameters to be specified when triggering a RunTerritoryRules operation through Tooling API. Extends the complex type OperationPayload. This type is available in API version 37.0 and later.

| Field | Type | Description |
|---|---|---|
| keyPrefix | string | The key prefix of the entity on which the territory assignment rules should be run. The Account key prefix (001) is currently supported. |
| territoryId | string | The TerritoryID of the Planning or Active territory model you want to run rules for. |
| territoryModelId | string | The ID for the territory model the territory belongs to. You can run assignment rules on territory models in a Planning or Active state. |

**Territory2RunOppTerrAssignmentApexPayload** — Represents a set of parameters to be specified when triggering a RunOppTerrAssignmentApex operation through Tooling API. Extends the complex type OperationPayload. This type is available in API version 37.0 and later.

| Field | Type | Description |
|---|---|---|
| excludeClosedOpportunities | string | If true, excludes from the operation all opportunities that are already closed. |
| opportunityCloseDateFrom | string | Use to filter opportunities based on a range of close dates. The operation applies to opportunities with close dates within the specified range. Use this field to specify a starting date for the range using the format ddmmyyyy. |
| opportunityCloseDateTo | string | Use to filter opportunities based a range of close dates. The operation applies to opportunities with close dates within the specified range. Use this field to specify an ending date for the range using the format ddmmyyyy. |
| opportunityLastModifiedDateFrom | string | Use to filter opportunities based a range of last-modified dates. The operation applies to opportunities with last-modified dates within the specified range. Use this field to specify a starting date for the range using the format ddmmyyyy. |
| opportunityLastModifiedDateTo | string | Use to filter opportunities based a range of last-modified dates. The operation applies to opportunities with last-modified dates within the specified range. Use this field to specify an ending date for the range using the format ddmmyyyy. |
| territoryModelId | string | The ID for the active territory model. Opportunities can be assigned to an active territory model only. |

### CustomHttpHeader

Represents a custom HTTP header used with OData 2.0 or OData 4.0 external data sources. Custom HTTP headers provide context information from Salesforce such as region, org details, or the role of the person viewing the external object. This object is available in API version 51.0 and later.

- **Version:** API 51.0 and later
- **Supported SOAP Calls:** create(), delete(), describeLayout(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST HTTP Methods:** DELETE, GET, HEAD, PATCH, POST, Query

| Field | Type | Properties | Description |
|---|---|---|---|
| Description | textarea | Create, Filter, Nillable, Sort, Update | A text description of the header field's purpose. |
| HeaderFieldName | string | Create, Filter, Group, Sort, Update | Name of the header field. The name must contain at least one alphanumeric character or underscore. It can also include: ! # $ % & ' * + - . ^ _ ` \| ~ |
| HeaderFieldValue | string | Create, Filter, Sort, Update | A formula that resolves to the value for the header. The values in the formula must evaluate to a string. If the formula resolves to null and an empty string, the header isn't sent. |
| IsActive | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether the custom HTTP header is available to use (true) or unavailable (false). |
| ParentId | reference | Create, Filter, Group, Sort | ID of the entity to which this custom HTTP header is related. |

---

## My Domain (도메인 프로비저닝 · 로그)

> 커스텀 도메인의 프로비저닝 변경 이력(DomainProvision)과 org의 이전 My Domain 기록(OrgDomainLog). My Domain·Enhanced Domains 운영 맥락은 [[Enhanced Domains]] 참조.

### DomainProvision

Represents provisioned changes to custom domains. This object is available in API version 50.0 and later.

Custom domains are domains that you own, such at https://www.example.com, that serve your site content. When you save a change to a custom domain, Salesforce provisions the updated domain and a corresponding DomainProvision record is created. The latest DomainProvision record for a Domain represents the current state of the domain.

> My Domain·Enhanced Domains 전환·CDN 구성 운영 맥락은 [[Enhanced Domains]] 참조.

- **Version:** API 50.0 and later
- **Supported SOAP Calls:** describeSObjects(), query(), retrieve()
- **Supported REST HTTP Methods:** GET, HEAD, Query
- **Special Access Rules:** Only users with the Salesforce Integration user permission can access this object.

| Field | Type | Properties | Description |
|---|---|---|---|
| CnameTarget | string | Filter, Group, Nillable, Sort | Represents the canonical name (CNAME) of the external host or server for this domain. If you use a non-Salesforce provider, such as your own external server or CDN provider, to serve your domain, this field points to the CNAME of the external provider. |
| IsActive | boolean | Defaulted on create, Filter, Group, Sort | Represents whether the provisioning for this domain is processing or complete (true) or not (false). When you activate a provisioned domain, this field is set to false. The default value is false. |
| ProvisionEndDate | dateTime | Filter, Nillable, Sort | Represents when the provisioning process was finished. |
| ProvisionFinalizeDate | dateTime | Filter, Nillable, Sort | Represents when the provisioning process was canceled or when the provisioned domain was activated. |
| ProvisionStartDate | dateTime | Filter, Nillable, Sort | Represents when the provisioning process started. |
| TargetCdnCertificate | string | Filter, Group, Nillable, Sort | If the domain is served on the Salesforce Content Delivery Network (CDN), represents the certificate that serves this domain. If your domain uses another domain configuration option, this field is null. |
| TargetDomainName | string | Filter, Group, Nillable, Sort | Represents the domain name, such as www.example.com. |

### OrgDomainLog

Represents a Salesforce org's previous My Domain. This object is available in API version 51.0 and later.

- **Version:** API 51.0 and later
- **Supported SOAP Calls:** describeSObjects(), query(), retrieve()
- **Supported REST HTTP Methods:** GET, HEAD, Query

| Field | Type | Properties | Description |
|---|---|---|---|
| DomainPartition | picklist | Filter, Group, Nillable, Restricted picklist, Sort | The partition for this org. When none, partitioned domains aren't enabled. Otherwise, My Domain hostnames include the partition value. For example, the format of a My Domain login hostname for a Developer Edition org with partitioned domains is MyDomainName.develop.my.salesforce.com. Possible values are: • **demo** — Used in demo orgs. Available in API version 60.0 and later. • **develop** — Used in Developer Edition orgs. Also used in patch orgs where partitioned domains were deployed before Winter '24. • **free** — Reserved for internal use. • **none** — Indicates that this org doesn't use partitioned domains. • **patch** — Used in patch orgs. Available in API version 59.0 and later. • **sandbox** — Used in sandboxes with enhanced domains. These orgs are always partitioned. • **scratch** — Used in scratch orgs. • **sfdctest** — Reserved for internal use. • **trailblaze** — Used in Trailblazer Playgrounds. (DomainPartition 필드 자체는 Available in API version 55.0 and later.) |
| MyDomainName | string | Filter, Group, Nillable, Sort | A previous My Domain name for the Salesforce org. |
| ProdSuffixType | picklist | Filter, Group, Restricted picklist, Sort | A previous Salesforce domain suffix, which is appended to the My Domain name. Possible values are: • **CloudforceLimited** — cloudforce.com • **DatabaseLimited** — database.com • **MySalesforce** — my.salesforce.com with enhanced domains • **MySalesforceLimited** — my.salesforce.com without enhanced domains • **OrgLevelCertificateLimited** — legacy version of my-salesforce.com that's noncompliant with browser settings that block third-party cookies • **OrgLevelCertificate** — my-salesforce.com • **Restricted1** — Reserved for future use. • **Restricted2** — Reserved for future use. |

**Usage:** To check for previous My Domain values for your org, first perform a GET request.

```
GET /services/data/v51.0/tooling/query?q=SELECT Id FROM OrgDomainLog
```

If that query returns a size of 1 or greater, previous My Domain values exist for the org. Each record represents a previous My Domain. To use a GET request for the My Domain name and suffix, use this syntax with a OrgDomainLog record ID.

```
GET /services/data/v51.0/tooling/sobjects/MyDomainLog/recordID
```

The following is an example response for a GET request querying a OrgDomainLog record ID.

```json
{
    "attributes" : {
      "type" : "OrgDomainLog",
      "url" : "/services/data/v56.0/tooling/sobjects/OrgDomainLog/9UXXXXXXXXXXXXXOAA"
    },
    "Id" : "9UXXXXXXXXXXXXXOAA",
    "IsDeleted" : false,
    "CreatedDate" : "2022-10-02T21:04:38.000+0000",
    "CreatedById" : "005XXXXXXXXXXXXIAG",
    "LastModifiedDate" : "2022-10-02T21:04:38.000+0000",
    "LastModifiedById" : "005XXXXXXXXXXXXIAG",
    "SystemModstamp" : "2022-10-02T21:04:38.000+0000",
    "DomainPartition" : "none",
    "MyDomainName" : "mycompany",
    "ProdSuffixType" : "MySalesforceLimited"
}
```

---

## Business Process (고객 라이프사이클 맵 · 피드백)

> Salesforce Surveys 기반 고객 라이프사이클 맵을 구성하는 3종 — 맵 단위(BusinessProcessGroup), 각 단계의 설문/질문(BusinessProcessFeedback), 피드백 수집 트리거 구성(BusProcessFeedbackConfig).

### BusinessProcessFeedback

Represents information about the survey and the question associated with each stage in a customer lifecycle map. This object is available in API version 51.0 and later.

- **Version:** API 51.0 and later
- **Supported SOAP Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST HTTP Methods:** DELETE, GET, HEAD, PATCH, POST, Query
- **Special Access Rules:** none stated.

| Field | Type | Properties | Description |
|---|---|---|---|
| ActionName | string | Create, Filter, Group, Sort, Update | Name of the survey used to gather feedback. |
| ActionParam | string | Create, Filter, Group, Sort, Update | Name of the question used to gather feedback. |
| ActionType | picklist | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort, Update | Method of collecting feedback. Possible values are: • PHONE_CALL • SURVEY |
| BusinessProcessDefinitionId | reference | Create, Filter, Group, Sort | Unique identifier of the stage associated with the survey and question. |

### BusinessProcessGroup

Represents information about the customer lifecycle maps. Customer lifecycle maps are used to track the scores provided by customers across their lifecycle using Salesforce Surveys. For example, the lifecycle stages for an Insurance business process group can include acquisition, onboarding, claims, routine services, and renewal. This object is available in API version 51.0 and later.

- **Version:** API 51.0 and later
- **Supported SOAP Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST HTTP Methods:** DELETE, GET, HEAD, PATCH, POST, Query

| Field | Type | Properties | Description |
|---|---|---|---|
| CustomerSatisfactionMetric | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | Represents the question type that measures the customer's Net Promote Score [sic] or satisfaction score across their lifecycle. Possible values are: • CSAT • NPS |
| Description | textarea | Create, Nillable, Update | Description of the customer lifecycle map. |
| DeveloperName | string | Create, Filter, Group, Sort, Update | Developer name of the customer lifecycle map. **Note:** Only users with View DeveloperName OR View Setup and Configuration permission can view, group, sort, and filter this field. |
| Language | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Language of the MasterLabel. Possible values are the FULL standard Salesforce language picklist (see [공통 — 표준 Salesforce Language 피클리스트](#공통--표준-salesforce-language-피클리스트) 아래 전체 목록). |
| ManageableState | picklist | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package. Possible values are: • beta—Managed-Beta • deleted—Managed-Proposed-Deleted • deprecated—Managed-Proposed-Deprecated • deprecatedEditable—SecondGen-Installed-Deprecated • installed—Managed-Installed • installedEditable—SecondGen-Installed-Editable • released—Managed-Released • unmanaged—Unmanaged |
| MasterLabel | string | Create, Filter, Group, Sort, Update | Label of the customer lifecycle map. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | Namespace prefix associated with this object. Each Developer Edition org that creates a managed package has a unique namespace prefix. |

#### 공통 — 표준 Salesforce Language 피클리스트

> `BusinessProcessGroup.Language` 와 `BusProcessFeedbackConfig.Language` 는 byte-identical한 동일 standard Salesforce language picklist 전체를 값으로 가진다. 전수 목록(약 141값)을 아래에 한 번만 verbatim으로 싣고, 두 필드 모두 이를 참조한다.

af—Afrikaans • am—Amharic • ar—Arabic • ar_AE—Arabic (United Arab Emirates) • ar_BH—Arabic (Bahrain) • ar_DZ—Arabic (Algeria) • ar_EG—Arabic (Egypt) • ar_IQ—Arabic (Iraq) • ar_JO—Arabic (Jordan) • ar_KW—Arabic (Kuwait) • ar_LB—Arabic (Lebanon) • ar_LY—Arabic (Libya) • ar_MA—Arabic (Morocco) • ar_OM—Arabic (Oman) • ar_QA—Arabic (Qatar) • ar_SA—Arabic (Saudi Arabia) • ar_SD—Arabic (Sudan) • ar_SY—Arabic (Syria) • ar_TN—Arabic (Tunisia) • ar_YE—Arabic (Yemen) • bg—Bulgarian • bn—Bengali • bs—Bosnian • ca—Catalan • cs—Czech • cy—Welsh • da—Danish • de—German • de_AT—German (Austria) • de_BE—German (Belgium) • de_CH—German (Switzerland) • de_LU—German (Luxembourg) • el—Greek • en_AU—English (Australian) • en_CA—English (Canadian) • en_GB—English (UK) • en_HK—English (Hong Kong) • en_IE—English (Ireland) • en_IN—English (Indian) • en_MY—English (Malaysian) • en_NZ—English (New Zealand) • en_PH—English (Philippines) • en_SG—English (Singapore) • en_US—English • en_ZA—English (South Africa) • es—Spanish • es_AR—Spanish (Argentina) • es_BO—Spanish (Bolivia) • es_CL—Spanish (Chile) • es_CO—Spanish (Colombia) • es_CR—Spanish (Costa Rica) • es_DO—Spanish (Dominican Republic) • es_EC—Spanish (Ecuador) • es_GT—Spanish (Guatemala) • es_HN—Spanish (Honduras) • es_MX—Spanish (Mexico) • es_NI—Spanish (Nicaragua) • es_PA—Spanish (Panama) • es_PE—Spanish (Peru) • es_PR—Spanish (Puerto Rico) • es_PY—Spanish (Paraguay) • es_SV—Spanish (El Salvador) • es_US—Spanish (United States) • es_UY—Spanish (Uruguay) • es_VE—Spanish (Venezuela) • et—Estonian • eu—Basque • fa—Farsi • fi—Finnish • fr—French • fr_BE—French (Belgium) • fr_CA—French (Canadian) • fr_CH—French (Switzerland) • fr_LU—French (Luxembourg) • ga—Irish • gu—Gujarati • hi—Hindi • hr—Croatian • hu—Hungarian • hy—Armenian • in—Indonesian • is—Icelandic • it—Italian • it_CH—Italian (Switzerland) • iw—Hebrew • ja—Japanese • ka—Georgian • km—Khmer • kn—Kannada • ko—Korean • lb—Luxembourgish • lt—Lithuanian • lv—Latvian • mi—Te reo • mk—Macedonian • ml—Malayalam • mr—Marathi • ms—Malay • mt—Maltese • my—Burmese • nl_BE—Dutch (Belgium) • nl_NL—Dutch • no—Norwegian • pl—Polish • pt_BR—Portuguese (Brazil) • pt_PT—Portuguese (European) • rm—Romansh • ro—Romanian • ro_MD—Romanian (Moldova) • ru—Russian • sh—Serbian (Latin) • sh_ME—Montenegrin • sk—Slovak • sl—Slovene • sq—Albanian • sr—Serbian (Cyrillic) • sv—Swedish • sw—Swahili • ta—Tamil • te—Telugu • th—Thai • tl—Tagalog • tr—Turkish • uk—Ukrainian • ur—Urdu • vi—Vietnamese • xh—Xhosa • zh_CN—Chinese (Simplified) • zh_HK—Chinese (Hong Kong) • zh_SG—Chinese (Singapore) • zh_TW—Chinese (Traditional) • zu—Zulu

### BusProcessFeedbackConfig

Represents information about the configuration for feedback collection. The feedback collection method triggers against pre-determined conditions on object to gather feedback. This object is available in API version 51.0 and later.

- **Version:** API 51.0 and later
- **Supported SOAP Calls:** describeSObjects(), query(), retrieve()
- **Supported REST HTTP Methods:** GET, HEAD, Query

| Field | Type | Properties | Description |
|---|---|---|---|
| ActionName | string | Filter, Group, Sort | Name of the method used to gather feedback. |
| ActionType | picklist | Defaulted on create, Filter, Group, Restricted picklist, Sort | Method of collecting feedback. Possible values are: • PHONE_CALL • SURVEY |
| ConfigurationDescription | textarea | Nillable | Describes the experience step configuration. |
| DeveloperName | string | Filter, Group, Sort | Unique name of the object. **Note:** Only users with View DeveloperName OR View Setup and Configuration permission can view, group, sort, and filter this field. |
| Field | string | Filter, Group, Sort | Represents the picklist field whose value triggers the feedback collection. |
| FieldValue | string | Filter, Group, Sort | Represents the field value that triggers the feedback collection. |
| IsActive | boolean | Defaulted on create, Filter, Group, Sort | Indicates if the feedback configuration is active (true) or not (false). |
| Language | picklist | Filter, Group, Restricted picklist, Sort | Language of the MasterLabel. Possible values are the FULL standard Salesforce language picklist — byte-identical to [BusinessProcessGroup.Language](#공통--표준-salesforce-language-피클리스트) (전체 값 목록은 위 공통 블록 참조, verbatim 동일). |
| ManageableState | picklist | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package. Possible values are: • beta—Managed-Beta • deleted—Managed-Proposed-Deleted • deprecated—Managed-Proposed-Deprecated • deprecatedEditable—SecondGen-Installed-Deprecated • installed—Managed-Installed • installedEditable—SecondGen-Installed-Editable • released—Managed-Released • unmanaged—Unmanaged |
| MasterLabel | string | Filter, Group, Sort | Name of the resource, limited up to 100 characters. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | Namespace prefix associated with this object. Each Developer Edition org that creates a managed package has a unique namespace prefix. |
| Object | string | Filter, Group, Sort | Represents the entity on which the feedback collection triggering condition depends. |
| Recipient | string | Filter, Group, Sort | Represents the recipient who is contacted for the feedback collection. |
| RecordType | string | Filter, Group, Nillable, Sort | Represents the record type of the entity on which the feedback collection triggering condition depends. |
| TriggerAction | picklist | Filter, Group, Restricted picklist, Sort | Action available with the business process feedback object. Possible values are: • Create • CreateAndUpdate • Update |

---

## 관련 노트

- [[Tooling API — 개요·REST·SOAP 호출 기초]] — 폴더 허브. REST/SOQL 쿼리 리소스·헤더·composite·EOL 등 호출 기초.
- [[Tooling API — Objects and Namespaces (객체 분류)]] — 객체↔네임스페이스 분류, SOQL/SOSL 한도, System Fields, ApiFault.
- [[Tooling API — SOAP·REST 헤더]] — 호출 시 사용하는 SOAP/REST 헤더.
- [[Tooling API 객체 — Apex 코드·테스트·커버리지]] — 형제 Ch4 도메인 노트(Apex 코드·테스트 sObject 군).
- [[Tooling API 객체 — Entity·Field·스키마]] — 형제 Ch4 도메인 노트(Entity·Field·스키마 sObject 군).
- [[Tooling API 객체 — 보안·권한]] — 형제 Ch4 도메인 노트. Certificate의 정본.
- [[Tooling API 객체 — 자동화 (Flow·Workflow·룰)]] — 형제 Ch4 도메인 노트. ProcessFlowMigration의 정본.
- [[Tooling API 객체 — UI·레이아웃 (페이지·액션·탭)]] — 형제 Ch4 도메인 노트. IconDefinition의 정본.
- [[Tooling API 객체 — Lightning (Aura·LWC 번들)]] — 형제 Ch4 도메인 노트(Aura·LWC 번들 sObject 군).
- [[Tooling API 객체 — 패키징·브랜딩 (1GP·2GP·정적콘텐츠)]] — 같은 운영 도메인의 패키징·브랜딩 sObject 20종 형제 노트.
- [[Tooling API 객체 — User·플랫폼이벤트 (이벤트·CDC 채널)]] — User·플랫폼이벤트·CDC 채널·이벤트 릴레이 sObject 7종 형제 Ch4 도메인 노트. 본 노트의 PlatformEventMigration과 인접한 플랫폼이벤트 채널·구독·릴레이 객체의 정본.
- [[Tooling API 디버그·로그·리플레이 sObject]] — (위임) TraceFlag·ApexLog 등 디버그·로그·리플레이 패밀리의 정본. OperationLog와 도메인은 다르나 모두 비동기/추적성 운영 객체.
- [[Tooling API 배포]] — 컨테이너 기반 배포 패밀리(MetadataContainer·ContainerAsyncRequest·Apex\*Member)의 정본. DeployRequest·DeployDetails의 배포 맥락.
- [[Sandbox 관리]] — 샌드박스 종류·복사 정책·프리뷰 타이밍 운영 맥락. SandboxInfo·SandboxProcess·SandboxProcessStage의 응용.
- [[Source Tracking 변경 추적]] — 소스 추적 개발자 워크플로. SourceMember*(내부 예약)가 가리키는 실제 기능.
- [[Enhanced Domains]] — My Domain·Enhanced Domains 전환·CDN 구성. DomainProvision·OrgDomainLog의 운영 맥락.
