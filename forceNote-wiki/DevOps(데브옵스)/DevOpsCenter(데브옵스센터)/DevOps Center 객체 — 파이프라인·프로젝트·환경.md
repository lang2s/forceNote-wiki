---
tags: [devops, devops-center, object-reference, pipeline, project, environment, repository, vcs, branch]
source: devops_center_dev.pdf (Salesforce DevOps Center Developer Guide v67.0, Summer '26)
created: 2026-06-27
aliases: [Project, Pipeline, Pipeline Stage, Environment, Repository, VCS, Branch, sf_devops__Project__c, sf_devops__Pipeline__c, sf_devops__Pipeline_Stage__c, sf_devops__Environment__c, sf_devops__Repository__c, sf_devops__Vcs__c, sf_devops__Branch__c, 프로젝트, 파이프라인, 파이프라인스테이지, 환경, 리포지토리, 브랜치, DevOps Center 객체]
---

# DevOps Center 객체 — 파이프라인·프로젝트·환경

> DevOps Center 릴리스 파이프라인의 백본을 이루는 7개 커스텀 객체(Project, Pipeline, Pipeline Stage, Environment, Repository, VCS, Branch)의 필드·관계·Supported Calls 전수 레퍼런스.

---

## Project (sf_devops__Project__c)

모든 DevOps Center 커스텀 객체의 부모를 나타낸다. 자세한 내용은 *Understand the DevOps Center Data Model*을 참고. 이 객체는 DevOps Center가 설치된 모든 조직에서 사용 가능하다.

**Supported Calls**

```
create(), delete(), describeLayout(), describeSObjects(), getDeleted(), getUpdated(), query(),
retrieve(), undelete(), update(), upsert()
```

**Fields**

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| Name | string | Create, Defaulted on create, Filter, Group, idLookup, Nillable, Sort, Update | 이 Project 레코드의 이름. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | 이 레코드를 소유한 사용자의 ID. 다형성(polymorphic) 관계 필드. |
| sf_devops__Description__c | string | Create, Filter, Group, Nillable, Sort, Update | 프로젝트 설명. DevOps Center는 이 필드를 UI에 설명을 표시하는 용도로만 사용한다. |
| sf_devops__Hidden__c | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | true이면 이 프로젝트가 DevOps Center 프로젝트 목록에 표시되지 않는다. 기본값은 false. |
| sf_devops__Package_Directories__c | textarea | Create, Nillable, Update | DevOps Center가 feature 브랜치의 메타데이터를 검사할 때 사용하는 파일경로 목록. 관리자가 Salesforce DX 프로젝트를 생성할 때 `sfdx-project.json` 파일에서 처음 로드하며, 마지막 파이프라인 스테이지에 연결된 브랜치에서 `sfdx-project.json`이 변경될 때마다 갱신한다. |
| sf_devops__Platform_Repository__c | reference | Create, Filter, Group, Sort, Update | 프로젝트의 소스 컨트롤 리포지토리에 대한 참조. 관계 필드. |

**Relationship 보충**

- **OwnerId** — Relationship Name: `Owner`, Relationship Type: Lookup, Refers To: Group, User
- **sf_devops__Platform_Repository__c** — Relationship Name: `sf_devops__Platform_Repository__r`, Relationship Type: Lookup, Refers To: `sf_devops__Repository__c`

---

## Pipeline (sf_devops__Pipeline__c)

프로젝트에서 DevOps Center 릴리스 파이프라인을 구성하는 Pipeline Stage 레코드의 모음을 나타낸다. 이 객체는 DevOps Center가 설치된 모든 조직에서 사용 가능하다.

**Supported Calls**

```
create(), delete(), describeLayout(), describeSObjects(), getDeleted(), getUpdated(), query(),
retrieve(), search(), undelete(), update(), upsert()
```

**Fields**

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| Name | string | Create, Defaulted on create, Filter, Group, idLookup, Nillable, Sort, Update | 이 Pipeline 레코드의 이름. |
| sf_devops__Activated__c | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | true이면 관리자가 DevOps Center에서 파이프라인의 **Activate**를 클릭했고 사용자가 work item 프로모션을 시작할 수 있다. false이면 관리자가 아직 파이프라인을 구성 중이다. 기본값은 false. |
| sf_devops__Project__c | reference | Create, Filter, Group, Sort | 이 파이프라인의 부모 프로젝트에 대한 참조. 관계 필드. |

**Relationship 보충**

- **sf_devops__Project__c** — Relationship Name: `sf_devops__Project__r`, Relationship Type: Master-detail, Refers To: `sf_devops__Project__c`

---

## Pipeline Stage (sf_devops__Pipeline_Stage__c)

파이프라인에서 환경으로의 연결을 나타낸다. 프로젝트의 모든 파이프라인 스테이지의 모음이 릴리스 파이프라인을 구성한다. 이 객체는 DevOps Center가 설치된 모든 조직에서 사용 가능하다.

DevOps Center는 파이프라인에서 가장 왼쪽의 **Approved Work Items** 열을 표현하는 데 Pipeline Stage 객체를 사용하지 않는다. 이런 이유로 그 열을 *pseudo stage*라고 부른다. 대신 DevOps Center는 이 열의 항목을 Development Approved 필드가 true이지만 아직 프로모션되지 않은 모든 Work Item 레코드로부터 계산한다.

**Supported Calls**

```
create(), delete(), describeLayout(), describeSObjects(), getDeleted(), getUpdated(), query(),
retrieve(), search(), undelete(), update(), upsert()
```

**Fields**

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| Name | string | Create, Defaulted on create, Filter, Group, idLookup, Nillable, Sort, Update | 이 Pipeline Stage 레코드의 이름. |
| sf_devops__Branch__c | reference | Create, Filter, Group, Sort, Update | 이 파이프라인 스테이지에 연결된 브랜치 정보를 담은 Branch 레코드에 대한 참조. 관계 필드. |
| sf_devops__Environment__c | reference | Create, Filter, Group, Nillable, Sort, Update | 이 파이프라인 스테이지에 연결된 Environment 레코드에 대한 참조. 현재 모든 환경은 Salesforce 조직이다. 관계 필드. |
| sf_devops__Next_Stage__c | reference | Create, Filter, Group, Nillable, Sort, Update | 파이프라인의 다음 스테이지를 가리키는 포인터. 관계 필드. |
| sf_devops__Operation_Status__c | reference | Create, Filter, Group, Nillable, Sort, Update | 이 파이프라인 스테이지가 원격 작업의 일부인 경우, 연결된 Async Operation Result 레코드를 참조한다. 작업이 종료되면 DevOps Center가 이 필드 값을 지운다. 관계 필드. |
| sf_devops__Pipeline__c | reference | Create, Filter, Group, Sort | 이 스테이지가 속한 Pipeline 레코드에 대한 참조. 관계 필드. |
| sf_devops__Prerelease__c | boolean | Defaulted on create, Filter, Group, Sort | 이 스테이지가 번들링 스테이지인지 지정한다. 자세한 내용은 *How Promotions Work* 참고. 계산된(calculated) 필드. |
| sf_devops__Promote_Review_Remote_Reference__c | string | Create, Filter, Group, Nillable, Sort, Update | 이 스테이지에서 다음 스테이지로의 change request 고유 ID. GitHub에서 change request는 pull request(PR)라 부르며 ID는 PR 번호다. DevOps Center는 이 파이프라인 스테이지에 연결된 브랜치로 변경 사항이 병합될 때마다 이 change request를 생성한다. |
| sf_devops__Swap_Status__c | reference | Create, Filter, Group, Nillable, Sort, Update | 스왑된 후 이 스테이지의 환경으로 메타데이터를 배포하는 원격 작업의 Async Operation Result 레코드에 대한 참조. 관계 필드. |
| sf_devops__Versioned__c | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | true이면 이 파이프라인 스테이지는 프로모션에 대해 change bundle만 받는다. false이면 work item만 받는다. 기본값은 false. |

**Relationship 보충**

- **sf_devops__Branch__c** — Relationship Name: `sf_devops__Branch__r`, Relationship Type: Lookup, Refers To: `sf_devops__Branch__c`
- **sf_devops__Environment__c** — Relationship Name: `sf_devops__Environment__r`, Relationship Type: Lookup, Refers To: `sf_devops__Environment__c`
- **sf_devops__Next_Stage__c** — Relationship Name: `sf_devops__Next_Stage__r`, Relationship Type: Lookup, Refers To: `sf_devops__Pipeline_Stage__c`
- **sf_devops__Operation_Status__c** — Relationship Name: `sf_devops__Operation_Status__r`, Relationship Type: Lookup, Refers To: `sf_devops__Async_Operation_Result__c`
- **sf_devops__Pipeline__c** — Relationship Name: `sf_devops__Pipeline__r`, Relationship Type: Master-detail, Refers To: `sf_devops__Pipeline__c`
- **sf_devops__Swap_Status__c** — Relationship Name: `sf_devops__Swap_Status__r`, Relationship Type: Lookup, Refers To: `sf_devops__Async_Operation_Result__c`

---

## Environment (sf_devops__Environment__c)

DevOps Center에서 환경으로의 연결을 나타내며, 현재 환경은 Salesforce 조직만 가능하다. 개발자는 개발 환경을 사용해 작업을 수행한다. 각 파이프라인 스테이지에는 연결된 환경이 있다. 이 객체는 DevOps Center가 설치된 모든 조직에서 사용 가능하다.

> [!warning] PDF 원문 Warning
> DevOps Center가 Salesforce 생태계의 추가 프로모션 유형을 지원하도록 성장함에 따라 이 객체는 변경될 수 있다. 예를 들어 현재 조직(org)에 특화된 필드가 새로운 org 중심 커스텀 객체로 이전될 수 있고, MuleSoft·Tableau 등을 나타내기 위한 추가 커스텀 객체가 생성될 수 있다.

**Supported Calls**

```
create(), delete(), describeLayout(), describeSObjects(), getDeleted(), getUpdated(), query(),
retrieve(), search(), undelete(), update(), upsert()
```

**Fields**

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| Name | string | Create, Defaulted on create, Filter, Group, idLookup, Nillable, Sort, Update | 이 Environment 레코드의 이름. |
| sf_devops__Can_Track_Changes__c | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | true이면 이 환경이 참조하는 조직에 소스 추적(source tracking)이 활성화되어 있음을 지정한다. 기본값은 false. |
| sf_devops__Expired__c | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | true이면 이 환경이 참조하는 조직이 만료되었음을 지정한다. 만료된 조직의 예로는 삭제·만료된 스크래치 조직, 또는 새로 고침된 샌드박스 등이 있다. 기본값은 false. |
| sf_devops__Last_Revision_Counter__c | double | Create, Filter, Nillable, Sort, Update | 이 환경이 참조하는 조직에서 마지막으로 가져온 revision counter. DevOps Center는 이 값으로 Source Member Reference에서 중복 레코드를 가져오지 않도록 한다. |
| sf_devops__Named_Credential__c | string | Create, Filter, Group, Nillable, Sort, Update | 이 환경이 참조하는 조직에 연결할 때 DevOps Center가 사용하는 named credential의 이름. |
| sf_devops__Operation_Result__c | reference | Create, Filter, Group, Nillable, Sort, Update | 이 환경과 관련된 현재 진행 중인 작업의 Async Operation Result 레코드에 대한 참조. DevOps Center는 작업이 시작될 때 이 값을 설정하고 종료될 때 지운다. 관계 필드. |
| sf_devops__Org_Id__c | string | Create, Filter, Group, idLookup, Sort, Update | 이 환경이 연결된 Salesforce 조직의 15자 ID. DevOps Center는 URL을 사용해 조직에 연결하며, 연결 시 자신의 org ID와 이 필드 값을 비교한다. 두 ID가 다르면 연결된 조직이 새로 고침된 샌드박스라고 판단한다. |
| sf_devops__Project__c | reference | Create, Filter, Group, Sort | 이 환경의 프로젝트에 대한 참조. 관계 필드. |
| sf_devops__Refresh_Date__c | dateTime | Create, Filter, Nillable, Sort, Update | 이 샌드박스가 부모로부터 새로 고침된 날짜와 시간. DevOps Center는 이 필드와 Refresh Source를 사용해 최근 스왑된 환경(샌드박스)에서 누락된 work item을 판단한다. |
| sf_devops__Refresh_Source__c | reference | Create, Filter, Group, Nillable, Sort, Update | 이 샌드박스가 복제된 원본 DevOps Center 환경에 대한 참조. DevOps Center는 이 필드와 Refresh Date를 사용해 최근 스왑된 환경(샌드박스)에서 누락된 work item을 판단한다. 관계 필드. |
| sf_devops__Replaces__c | reference | Create, Filter, Group, Nillable, Sort, Update | 이 환경이 대체하는 환경에 대한 참조. 관계 필드. |
| sf_devops__Test_Environment__c | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | true이면 DevOps Center가 조직에 로그인할 때 `test.salesforce.com`을 사용함을 지정한다. false이면 `login.salesforce.com`을 사용한다. 기본값은 true. |

**Relationship 보충**

- **sf_devops__Operation_Result__c** — Relationship Name: `sf_devops__Operation_Result__r`, Relationship Type: Lookup, Refers To: `sf_devops__Async_Operation_Result__c`
- **sf_devops__Project__c** — Relationship Name: `sf_devops__Project__r`, Relationship Type: Master-detail, Refers To: `sf_devops__Project__c`
- **sf_devops__Refresh_Source__c** — Relationship Name: `sf_devops__Refresh_Source__r`, Relationship Type: Lookup, Refers To: `sf_devops__Environment__c`
- **sf_devops__Replaces__c** — Relationship Name: `sf_devops__Replaces__r`, Relationship Type: Lookup, Refers To: `sf_devops__Environment__c`

---

## Repository (sf_devops__Repository__c)

프로젝트의 메타데이터가 저장되는 소스 컨트롤 시스템의 특정 위치를 나타낸다. 여러 프로젝트가 동일한 리포지토리를 참조할 수 있다. 이 객체는 DevOps Center가 설치된 모든 조직에서 사용 가능하다.

> [!warning] PDF 원문 Warning
> 이 객체의 많은 필드는 GitHub에 특화되어 있다. DevOps Center가 추가 소스 컨트롤 시스템을 지원하게 되면 이 필드들은 변경되거나 이동될 가능성이 높다.

**Supported Calls**

```
create(), delete(), describeLayout(), describeSObjects(), getDeleted(), getUpdated(), query(),
retrieve(), undelete(), update(), upsert()
```

**Fields**

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| Name | string | Create, Defaulted on create, Filter, Group, idLookup, Nillable, Sort, Update | 이 Repository 레코드의 이름. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | 이 레코드를 소유한 사용자의 ID. 다형성(polymorphic) 관계 필드. |
| sf_devops__Default_Branch__c | string | Create, Filter, Group, Sort, Update | 릴리스할 모든 변경 사항을 담고 있는 리포지토리 내 브랜치. GitHub에서 이 브랜치는 일반적으로 `main`이라 부른다. |
| sf_devops__GitHub_Owner__c | string | Create, Filter, Group, Nillable, Sort, Update | 리포지토리의 소유자. GitHub에서 이 문자열은 리포지토리 URL에 사용된다. |
| sf_devops__GitHub_Repo__c | string | Create, Filter, Group, Nillable, Sort, Update | 리포지토리의 이름. GitHub에서 이 문자열은 리포지토리 URL에 사용된다. |
| sf_devops__Last_Event__c | string | Create, Filter, Group, Nillable, Sort, Update | DevOps Center가 GitHub에서 처리한 가장 최근 VCS Event의 ID. DevOps Center는 이 ID로 이벤트의 중복 다운로드·재처리를 방지한다. |
| sf_devops__Named_Credential__c | string | Create, Filter, Group, Sort, Update | 이 리포지토리에 연결할 때 DevOps Center가 사용하는 named credential의 이름. |
| sf_devops__Polling_Interval__c | double | Create, Filter, Nillable, Sort, Update | DevOps Center가 VCS Events를 폴링하는 빈도를 지정한다. |
| sf_devops__Provider__c | picklist | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort, Update | 이 리포지토리의 provider. 현재 유효한 값은 `GitHub`뿐이다. |

**Relationship / Picklist 보충**

- **OwnerId** — Relationship Name: `Owner`, Relationship Type: Lookup, Refers To: Group, User
- **sf_devops__Provider__c** — Possible values: `GitHub` (현재 유일한 유효값)

---

## VCS (sf_devops__Vcs__c)

지원되는 소스(버전) 컨트롤 시스템을 나타낸다. 이 객체는 DevOps Center 패키지 버전 8.2 이상이 설치된 모든 조직에서 사용 가능하다. API 버전 62.0 이상에서 사용 가능하다.

**Supported Calls**

```
create(), delete(), describeLayout(), describeSObjects(), getDeleted(), getUpdated(), query(),
retrieve(), undelete(), update(), upsert()
```

**Fields**

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| LastReferencedDate | dateTime | Filter, Nillable, Sort | DevOps Center에서 사용하지 않음. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | DevOps Center에서 사용하지 않음. |
| Name | string | Create, Defaulted on create, Filter, Group, idLookup, Nillable, Sort, Update | 소스 컨트롤 시스템의 이름. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | DevOps Center에서 사용하지 않음. |
| sf_devops__Base_URL__c | url | Create, Filter, Group, Sort, Update | 소스 컨트롤 시스템의 base URL. 예: `https://github.com`. |
| sf_devops__Named_Credential__c | string | Create, Filter, Group, Sort, Update | 이 소스 컨트롤 시스템에 접근하는 데 사용되는 named credential의 developer(API) 이름. |
| sf_devops__Service_Provider__c | string | Create, Filter, Group, Sort, Update | 이 소스 컨트롤 시스템의 provider 이름. 이 필드는 Vcs Provider 인터페이스를 구현하는 Service Provider CMT의 기존 developer(API) 이름을 참조해야 한다. |

**Relationship 보충**

- **OwnerId** — Relationship Name: `Owner`, Refers To: Group, User

---

## Branch (sf_devops__Branch__c)

소스 컨트롤 리포지토리(버전 컨트롤 시스템, 즉 VCS)에서 브랜치의 상태를 저장한다. DevOps Center 객체 모델에서 이 객체는 브랜치가 존재하는 Repository의 자식이다. Work Item과 Pipeline Stage 레코드가 이 객체를 참조한다. 이 객체는 DevOps Center가 설치된 모든 조직에서 사용 가능하다.

**Supported Calls**

```
create(), delete(), describeLayout(), describeSObjects(), getDeleted(), getUpdated(), query(),
retrieve(), search(), undelete(), update(), upsert()
```

**Fields**

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| Name | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | 이 Branch 레코드의 이름. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | 이 레코드를 소유한 사용자의 ID. 다형성(polymorphic) 관계 필드. |
| sf_devops__Ignore_Rules__c | textarea | Create, Nillable, Update | 브랜치의 `.forceignore` 파일을 전처리한 내용을 직렬화한 JSON 표현. |
| sf_devops__Name__c | string | Create, Filter, Group, Sort, Update | 브랜치의 이름. |
| sf_devops__Parent_Remote_Reference__c | string | Create, Filter, Group, Sort, Update | 이 브랜치가 부모 브랜치에서 분기된 지점을 나타내는 고유 ID. GitHub에서 이 ID는 SHA라 부른다. DevOps Center는 필요 시 이 ID로 브랜치를 재생성한다. 예를 들어 사용자가 GitHub에서 브랜치를 삭제했지만 DevOps Center가 아직 그 브랜치를 사용 중이라면, 이 ID를 사용해 브랜치를 재생성할 수 있다. |
| sf_devops__Remote_Reference_Date__c | dateTime | Create, Filter, Nillable, Sort, Update | Remote Reference 필드로 식별되는 브랜치가 마지막으로 업데이트된 날짜와 시간. |
| sf_devops__Remote_Reference__c | string | Create, Filter, Group, Sort, Update | 이 브랜치의 tip에 대한 고유 ID. GitHub에서 이 ID는 HEAD SHA라 부른다. |
| sf_devops__Repository__c | reference | Create, Filter, Group, Sort, Update | 이 브랜치가 존재하는 소스 코드 리포지토리에 대한 참조. 관계 필드. |

**Relationship 보충**

- **OwnerId** — Relationship Name: `Owner`, Relationship Type: Lookup, Refers To: Group, User
- **sf_devops__Repository__c** — Relationship Name: `sf_devops__Repository__r`, Relationship Type: Lookup, Refers To: `sf_devops__Repository__c`

---

## 관련 노트
- [[DevOps Center 데이터 모델 개요]]
- [[DevOps Center 객체 — Work Item·프로모션]]
- [[DevOps Center 객체 — 비동기·결과]]
- [[DevOps Center 객체 — 변경 추적]]
- [[DevOps Center — User 필드·플랫폼 이벤트]]
