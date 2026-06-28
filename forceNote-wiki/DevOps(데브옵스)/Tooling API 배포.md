---
tags: [devops, tooling-api, apex, deploy, compile, metadata-container, async, container-async-request, member-sobject, v67]
source: api_tooling.pdf — Tooling API Developer Guide (Save Apex Code / MetadataContainer · ContainerAsyncRequest · *Member objects)
created: 2026-06-20
aliases: [Tooling API 배포, Tooling API Apex deploy, MetadataContainer, ContainerAsyncRequest, ApexClassMember, ApexTriggerMember, ApexComponentMember, ApexPageMember, IsCheckOnly, compile and deploy apex, Apex 컴파일 배포, Tooling API로 Apex 저장, 단일 요소 배포, working copy 컴파일, Tooling API 컨테이너 배포는 어떻게]
---

# Tooling API 배포 (Apex 컨테이너 비동기 배포 워크플로)

> Tooling API로 Apex 클래스·트리거·Visualforce 페이지·컴포넌트를 **개별 요소 단위로 컴파일·배포**하는 워크플로 — `MetadataContainer`에 `*Member`(작업 사본)를 담고 `ContainerAsyncRequest`로 비동기 컴파일·저장한 뒤 `State`를 폴링한다. 단일 요소만 바꾸는 개발 도구·IDE·CI에 적합하다.

---

> [!note] 이 노트의 범위 (scope)
> 이 노트는 **Tooling API의 Apex 컨테이너 배포 워크플로에만 한정**한다 — `MetadataContainer` · `ContainerAsyncRequest` · `ApexClassMember` / `ApexTriggerMember` / `ApexComponentMember` / `ApexPageMember`.
> Tooling API의 다른 영역(`SymbolTable` 상세 구조, `EntityDefinition`/`FieldDefinition`, 전체 sObject 레퍼런스 등)은 **범위 밖**이다(`SymbolTable` 내부 구조는 별도 대형 작업 ING-26 소관). 디버그·로그·리플레이 sObject(`TraceFlag`·`DebugLevel`·`ApexLog`·`ApexExecutionOverlayAction`·`HeapDump` 등)는 [[Tooling API 디버그·로그·리플레이 sObject]] 참조 — 디버그 vs 배포 경계.
> `SymbolTable`은 `*Member`의 필드로만 언급하고 그 내부 구조는 다루지 않는다.

---

## Tooling API란 — 언제 쓰나

Tooling API는 **개발 도구(developer tooling)에서 쓰는 메타데이터**를 REST 또는 SOAP로 노출한다. org 메타데이터에 **fine-grained(세밀한)** 으로 접근해야 할 때 사용한다. 많은 메타데이터 타입에 대한 SOQL 기능으로 **작은 단위의 메타데이터만 retrieve** 할 수 있어 성능이 좋고, 대화형(interactive) 애플리케이션 개발에 적합하다.

> PDF 원문: *"Use Tooling API when you need fine-grained access to an org's metadata. ... Smaller retrieves improve performance, which makes Tooling API a better fit for developing interactive applications."*

### Metadata API와의 차이

> PDF 원문: *"Because Tooling API allows you to change just one element within a complex type, it can be easier to use than Metadata API."*

Tooling API는 **complex type 안의 한 요소만 변경**할 수 있어 Metadata API보다 쓰기 쉬운 경우가 있다. 따라서 IDE처럼 "한 번에 클래스 하나·트리거 하나"만 다루는 도구에 잘 맞는다. PDF가 든 그 밖의 use case:

- Source control integration (소스 관리 연동)
- Continuous integration (CI)
- Apex classes or trigger deployment (Apex 클래스·트리거 배포)

> 배포 경로 전체 비교(Change Sets · VS Code/Code Builder · Metadata API · Tooling API · DevOps Center)는 [[Apex 배포 방법]] 참조. File-based `deploy()`/`retrieve()` 메커니즘은 [[Metadata API File-Based 호출]] 소관이다.

---

## 핵심 객체 (역할)

| 객체 | 역할 |
|---|---|
| `MetadataContainer` | `*Member` 객체들의 작업 사본(working copy)을 관리하는 패키지. 함께 배포할 객체 모음(collection)을 담는다. |
| `ApexClassMember` | Apex 클래스의 working copy — 편집·저장·컴파일용 |
| `ApexTriggerMember` | Apex 트리거의 working copy |
| `ApexComponentMember` | Visualforce 컴포넌트의 working copy |
| `ApexPageMember` | Visualforce 페이지의 working copy |
| `ContainerAsyncRequest` | `MetadataContainer`를 컴파일하고 org에 **비동기 배포**하는 요청 |

> PDF 원문: *"MetadataContainer — Manages working copies of ApexClassMember, ApexTriggerMember, ApexPageMember, and ApexComponentMember objects, including collections of objects to be deployed together."*

`*Member`는 모두 동일한 패턴을 따른다 — 하나의 `*Member`는 **단 하나의 `MetadataContainer`만** 참조할 수 있으나, 여러 `*Member`가 **같은 `MetadataContainer`를 공유**할 수 있다. 서로 의존하는 소스 파일(예: 클래스 A가 클래스 B를 호출)은 같은 `MetadataContainer`에 담아 함께 저장·컴파일해야 컴파일러 오류를 피한다.

---

## 배포 워크플로 (전수 단계)

```
// 구조 예시 — 실제 원본 다이어그램 아님 (PDF 산문 절차를 단계로 재구성)
1. MetadataContainer 생성              (Name 지정, create / POST)
2. *Member 레코드 생성·추가             (ApexClassMember 등 — ContentEntityId·Body·MetadataContainerId)
3. ContainerAsyncRequest 생성          (IsCheckOnly 지정 → 비동기 컴파일·배포 시작)
4. State 폴링                          (SELECT State, ErrorMsg FROM ContainerAsyncRequest WHERE Id = ...)
5. 결과 처리                            (State / DeployDetails / ErrorMsg / SymbolTable)
```

### 1단계 — MetadataContainer 생성

도구 작업공간(workspace)의 패키지로 `MetadataContainer`를 만든다. `Name`은 필수이며 **같은 이름의 컨테이너가 이미 있으면 `create()`/POST에서 오류**가 보고된다. 컨테이너는 **재사용 가능**하지만 컨테이너 멤버는 재사용 불가다.

### 2단계 — *Member 레코드 추가

편집할 클래스/트리거/페이지/컴포넌트마다 해당 `*Member` 객체를 생성해 컨테이너에 넣는다. 주요 설정 필드:

- `ContentEntityId` — 대상 ApexClass/ApexTrigger/VF 페이지·컴포넌트 참조 (`FullName`을 지정하지 않으면 필수)
- `Body` — 새 소스 코드 (`update()`/PATCH 가능한 **유일한** 필드)
- `MetadataContainerId` — 1단계에서 만든 컨테이너 ID (필수)

### 3단계 — ContainerAsyncRequest 생성 (비동기 배포 시작)

`ContainerAsyncRequest`를 생성하면 비동기 컴파일·배포가 시작된다. `IsCheckOnly`로 저장 여부를 결정한다(아래 표 참조).

> PDF 원문: *"The IsCheckOnly parameter on ContainerAsyncRequest indicates whether an asynchronous request compiles code but doesn't execute or save it (true), or compiles and save the code (false)."*

| `IsCheckOnly` | 동작 |
|---|---|
| `true` | 코드를 **컴파일만** 하고 org에는 변경을 가하지 않음(저장 안 함). `*Member`에는 컴파일 결과가 담기지만 서버의 클래스는 그대로 유지. **단, `MetadataContainerMember`를 지정한 경우에만 지원** — 단일 `MetadataContainerMemberId`는 저장 없이 컴파일할 수 없음. |
| `false` | 컴파일 **후 org에 저장**. |

> PDF 원문: *"You can compile without saving but you can't save without compiling."*

### 4단계 — State 폴링

`ContainerAsyncRequest`를 `State`/`ErrorMsg`로 쿼리하며 완료를 기다린다. PDF 샘플은 `State`가 `"Queued"`인 동안 2초 간격으로 재쿼리한다.

```sql
-- 원문 발췌 (PDF SOAP 샘플의 폴링 SOQL)
SELECT Id, State, ErrorMsg
FROM ContainerAsyncRequest
WHERE id = '<requestId>'
```

### 5단계 — 결과 처리

`State` 값으로 결과를 분기한다(전체 enum은 아래 [ContainerAsyncRequest 필드](#containerasyncrequest-필드) 참조). 컴파일 성공 시 지정한 `MetadataContainer` 안 각 객체의 `SymbolTable` 필드가 갱신된다. 컴파일 오류 상세는 `DeployDetails`(XML, `componentFailures` 포함)에, 예기치 못한 오류 메시지는 `ErrorMsg`에 담긴다.

#### 배포 성공 후 — MetadataContainerId 재설정 (중요)

> PDF 원문: *"When a ContainerAsyncRequest completes successfully, the MetadataContainerId field on all container members is changed from the ID of the MetadataContainer to the ID of the ContainerAsyncRequest."*

배포가 성공하면 모든 컨테이너 멤버의 `MetadataContainerId`가 **`MetadataContainer`의 ID → `ContainerAsyncRequest`의 ID로 재설정**된다. 이 시점 이후 컨테이너 멤버는 더 이상 수정·배포할 수 없고, `MetadataContainer`로는 조회되지 않는다 — 무엇이 배포됐는지 보려면 `ContainerAsyncRequest`를 쿼리해야 한다.

배포가 **실패**하면 멤버는 `MetadataContainer`에 남아 다른 `ContainerAsyncRequest`로 성공 배포될 때까지 계속 수정 가능하다. 실패한(완료된) `ContainerAsyncRequest`의 `MetadataContainerId`는 `MetadataContainer`의 ID로 설정되므로, 한 `MetadataContainer`에 여러 개의 완료된 `ContainerAsyncRequest`가 있을 수 있다.

---

## sObject 필드 레퍼런스 (전수)

### MetadataContainer 필드

> Supported SOAP: `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
> Supported REST: Query, GET, POST, PATCH, DELETE

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| `Name` | string | Create, Filter, Group, Sort, Update | 컨테이너 이름. 같은 이름이 이미 있으면 create/POST 시 오류. **필수**. |

> Special Access: Spring '20부터 `MetadataContainer` 접근에는 **View All Data** + (**Author Apex** 또는 **Customize Application**) 권한이 필요하다.
> Note: `MetadataContainer`를 삭제하면 이를 참조하는 모든 객체가 함께 삭제된다.

### ContainerAsyncRequest 필드

> Supported SOAP: `create()`, `describeSObjects()`, `query()`, `retrieve()` (참고: update/delete 미지원)
> Supported REST: Query, GET, POST

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| `DeployDetails` | DeployDetails | Nillable | 비동기 요청 중 보고된 컴파일 오류에 대한 상세 XML. `componentFailures` 포함. Tooling API v31.0 이상에서 JSON 필드 `CompilerErrors`를 대체. |
| `ErrorMsg` | textarea | Nillable | 비동기 요청 중 보고된 오류. |
| `IsCheckOnly` | boolean | Create, Defaulted on create, Filter, Group, Sort | 변경 없이 컴파일만(`true`) 할지, 컴파일 후 저장(`false`)할지. **필수**. 저장 없이 컴파일은 가능하나 컴파일 없이 저장은 불가. |
| `IsRunTests` | boolean | None | Reserved for future use (향후 사용 예약). |
| `MetadataContainerId` | reference | Create, Filter, Group, Sort | `MetadataContainer` 객체의 ID. `MetadataContainerId` 또는 `MetadataContainerMemberId` 중 **하나만** 지정(둘 다 X). |
| `MetadataContainerMemberId` | reference | Create, Filter, Group, Nillable, Sort | `ApexClassMember`/`ApexTriggerMember`/`ApexPageMember`/`ApexComponentMember` 객체의 ID. `MetadataContainerId`와 둘 중 하나만 지정. |
| `State` | picklist | Filter, Group, Restricted picklist, Sort | 요청 상태(enum 전수는 아래). **필수**. |

#### State enum 값 (전수)

| 값 | 의미 |
|---|---|
| `Queued` | 작업이 큐에 있음. |
| `Invalidated` | 결과가 유효하지 않을 수 있어 Salesforce가 작업을 취소함. `IsCheckOnly=true` 중 누군가 컨테이너 멤버를 변경했거나, 더 새 컴파일 요청이 큐에 추가된 경우 발생. |
| `Completed` | 컴파일/배포 완료. 지정 객체들의 `SymbolTable`이 갱신됨. `IsCheckOnly`가 false면 각 객체의 `Body`가 저장되고 `MetadataContainerId`가 배포된 `MetadataContainer` ID → 해당 `ContainerAsyncRequest` ID로 재설정됨. |
| `Failed` | `CompilerError` 필드에 명시된 사유로 컴파일/배포 실패. |
| `Error` | 예기치 못한 오류 발생. `ErrorMsg` 필드 메시지를 Salesforce support에 전달 가능. |
| `Aborted` | 큐에 있는 배포를 삭제할 때 이 값을 사용. |

> Special Access: Spring '20부터 `ContainerAsyncRequest` 접근에는 **View All Data** + **Customize Application** 권한 필요.
> Usage(전수): `IsCheckOnly=true`(저장 없이 컴파일)는 `MetadataContainerMember`를 지정한 경우에만 지원 — 단일 `MetadataContainerMemberId`는 저장 없이 컴파일 불가. 컴파일 성공 시 지정 `MetadataContainer`의 각 객체 `SymbolTable`이 갱신, 저장/컴파일 실패로 `SymbolTable`을 갱신 못 하면 해당 필드는 비워짐. 미처리 저장 요청이 있으면 모든 update/insert/deploy가 실패. 큐 배포 종료는 `State`를 `Aborted`로 설정.

### *Member 공통 필드

`ApexClassMember` · `ApexTriggerMember` · `ApexComponentMember` · `ApexPageMember`는 거의 동일한 필드 집합을 가진다. 아래 공통 필드 표 + 객체별 차이(SymbolTable 유무·접근 권한)를 따로 정리한다.

> Supported SOAP (4종 공통): `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
> Supported REST (4종 공통): Query, GET, POST, PATCH, DELETE

| 필드 | Type | Properties | 설명 |
|---|---|---|---|
| `Body` | string | Create, Update | 대상의 소스 데이터. **`update()`/PATCH 할 수 있는 유일한 필드**. |
| `Content` | string | None | 대응 엔티티의 `Apex*Metadata`(version·status·packaged versions)를 나타내는 문자열 표현. |
| `ContentEntityId` | reference | Create, Filter, Group, Sort | 대상 엔티티(ApexClass/ApexTrigger/VF 컴포넌트/VF 페이지) 참조. `*Member`당 `ContentEntityId`는 **하나만** 가능(아니면 오류). `FullName`을 지정하지 않으면 필수. |
| `FullName` | string | Group, Nillable | Metadata API에서의 연결 객체 full name. ID를 얻기 전 create 시 race condition 회피용. 쿼리 결과 레코드가 1개 이하일 때만 조회(아니면 오류). `ContentEntityId`를 지정하지 않으면 필수. |
| `LastSyncDate` | dateTime | Filter, Sort | 이 `*Member`의 `Body`가 기반 엔티티에서 복제된 일시. `MetadataContainer` 배포 시 기반 엔티티의 `LastModifiedDate`와 비교 — `LastSyncDate`가 `LastModifiedDate`보다 오래되면 배포가 오류로 실패. |
| `Metadata` | `Apex*Metadata` | None | 대응 엔티티의 version·status·packaged versions를 기술하는 객체. 쿼리 결과가 1개 이하일 때만 조회(아니면 오류). |
| `MetadataContainerId` | reference | Create, Filter, Group, Sort | `MetadataContainer` 또는 `ContainerAsyncRequest` 참조. 성공 배포 시 배포된 `MetadataContainer` ID → 해당 `ContainerAsyncRequest` ID로 재설정. **필수**. |

#### 객체별 차이

| 객체 | `SymbolTable` 필드 | Special Access (Spring '20+) | 비고 |
|---|---|---|---|
| `ApexClassMember` | **있음** (Nillable) | View All Data + **Author Apex** | `Apex 클래스의 working copy`. 클래스/트리거 의존성이 있으면 관련 `*Member`를 한 컨테이너에 함께 담아 저장. |
| `ApexTriggerMember` | **있음** (Nillable) | View All Data + **Author Apex** | `Apex 트리거의 working copy`. 트리거 생성은 REST API 또는 Metadata API로. |
| `ApexComponentMember` | 없음 | View All Data + **Customize Application** | `Visualforce 컴포넌트의 working copy`. VF 컴포넌트 생성은 REST API 또는 Metadata API로. |
| `ApexPageMember` | 없음 | View All Data + **Customize Application** | `Visualforce 페이지의 working copy`. VF 페이지 생성은 REST API 또는 Metadata API로. |

> `SymbolTable` 필드(있는 객체): `ApexClass`/`ApexClassMember`/`ApexTriggerMember`의 `Body` 안 모든 user-defined token과 line/column 위치를 나타내는 complex type. `ContentEntityId`가 가리키는 콘텐츠가 symbol table을 쓰지 않거나, 마지막 배포의 컴파일 오류가 있으면 null. **`SymbolTable` 내부 구조는 이 노트 범위 밖(ING-26 소관).**

> 배포 후 재사용 불가 (4종 공통): `*Member`가 `MetadataContainer`에서 성공 배포되면 `MetadataContainerId`가 `ContainerAsyncRequest` ID로 바뀌고, 그 `*Member`는 더 이상 수정·재사용할 수 없다.

---

## SOAP 호출 예시 (원문 발췌)

PDF SOAP 샘플은 클래스 본문을 수정해 컴파일·배포한다. `IsCheckOnly=false`면 변경이 서버에 저장되고, `true`면 컴파일 결과만 `*Member`에 담긴다.

```csharp
// 원문 발췌 (PDF "SOAP Calls" — MetadataContainer + ApexClassMember + ContainerAsyncRequest)
//create the metadata container object
MetadataContainer Container = new MetadataContainer();
Container.Name = "SampleContainer";
MetadataContainer[] Containers = { Container };
SaveResult[] containerResults = sforce.create(Containers);
if (containerResults[0].success)
{
    String containerId = containerResults[0].id;
    //create the ApexClassMember object
    ApexClassMember classMember = new ApexClassMember();
    //pass in the class ID from the first example
    classMember.ContentEntityId = classId;
    classMember.Body = updatedClassBody;
    //pass the ID of the container created in the first step
    classMember.MetadataContainerId = containerId;
    ApexClassMember[] classMembers = { classMember };
    SaveResult[] MembersResults = sforce.create(classMembers);
    if (MembersResults[0].success)
    {
        //create the ContainerAsyncRequest object
        ContainerAsyncRequest request = new ContainerAsyncRequest();
        //change to IsCheckOnly = true to compile without saving
        request.IsCheckOnly = false;
        request.MetadataContainerId = containerId;
        ContainerAsyncRequest[] requests = { request };
        SaveResult[] RequestResults = sforce.create(requests);
        // ... then poll ContainerAsyncRequest.State (Queued → Completed/Failed/...)
    }
}
```

> PDF 원문: *"You can use the same method with ApexTriggerMember, ApexComponentMember, and ApexPageMember."* (동일 패턴을 다른 `*Member`에도 적용)

---

## REST 호출 예시 (원문 발췌)

REST에서는 `/composite` 리소스로 5개 subrequest를 한 번의 API 호출로 묶어 컨테이너 생성→멤버 추가→비동기 요청 시작→상태 조회까지 한다(`@{...}` 참조로 앞 응답의 ID를 다음 요청에 주입).

> PDF: *"The five subrequests count as a single call toward the API limit."*

```json
// 원문 발췌 (PDF Composite Request Body — 5개 subrequest)
{
  "allOrNone": false,
  "compositeRequest": [
    {
      "method": "POST",
      "body": { "Name": "MetadataContainer Unique Name" },
      "url": "/services/data/v40.0/tooling/sobjects/metadatacontainer/",
      "referenceId": "metadatacontainer_reference_id"
    },
    {
      "method": "POST",
      "body": {
        "contententityid": "<ID of an ApexClass you want to update>",
        "fullname": "ApexClassMemberUniqueFullName",
        "body": "public class Classtest2test {}",
        "MetadataContainerId": "@{metadatacontainer_reference_id.id}"
      },
      "url": "/services/data/v40.0/tooling/sobjects/apexclassmember/",
      "referenceId": "apexclassmember_reference_id"
    },
    {
      "method": "POST",
      "body": {
        "IsCheckOnly": "false",
        "MetadataContainerId": "@{metadatacontainer_reference_id.id}"
      },
      "url": "/services/data/v40.0/tooling/sobjects/containerasyncrequest/",
      "referenceId": "containerasyncrequest_reference_id"
    },
    {
      "method": "GET",
      "url": "/services/data/v40.0/tooling/sobjects/containerasyncrequest/@{containerasyncrequest_reference_id.id}",
      "referenceId": "containerasyncrequest_GET_reference_id"
    },
    {
      "method": "GET",
      "url": "/services/data/v40.0/tooling/sobjects/metadatacontainer/@{metadatacontainer_reference_id.id}",
      "referenceId": "metadatacontainer_GET_reference_id"
    }
  ]
}
```

---

## 주의사항 (PDF 명시)

- Apex 클래스·트리거는 Create/Update 필드 속성이 있어도 **API로 직접 create/update/delete 시 런타임 예외**가 발생한다. 대신 Salesforce Extensions for VS Code, Ant Migration Tool, 또는 위의 `*Member` + `ContainerAsyncRequest` 워크플로를 쓴다. **production org에서는 Apex 클래스·트리거를 만들거나 편집·삭제할 수 없다.**
- 서로 의존하는 소스 파일은 같은 `MetadataContainer`에 담아 함께 저장·컴파일해야 컴파일러 오류를 피한다(예: VF 페이지+컴포넌트, 또는 상호 호출 클래스).
- 컨테이너는 재사용 가능하지만 컨테이너 멤버는 1회 성공 배포 후 재사용 불가.

---

## 관련 노트
- [[Apex 배포 방법]] — 배포 경로 5종 비교 허브(Tooling API는 그중 4번 방법)
- [[Metadata API File-Based 호출]] — Metadata API의 `deploy()`/`retrieve()` 파일 기반 배포(대규모·전체 메타데이터 배포)
- [[Anonymous Apex 실행]] — Tooling API/REST로 anonymous Apex 실행(executeAnonymous)
- [[Tooling API 디버그·로그·리플레이 sObject]] — 같은 Tooling API의 디버그/로그 도메인(TraceFlag·DebugLevel·ApexLog·Overlay·HeapDump). 디버그 vs 배포 경계
- [[Tooling API — 개요·REST·SOAP 호출 기초]] — Tooling API 패밀리 개요/허브(REST 12·SOAP 16·executeAnonymous·Composite·EOL). 컨테이너 배포 객체의 REST/SOAP 호출 표면 진입점
- [[Tooling API 객체 — Apex 코드·테스트·커버리지]] — `*Member` 컨테이너가 저장하는 저장본 sObject(`ApexClass`·`ApexTrigger`·`ApexComponent`·`ApexPage`)+SymbolTable 필드 상세. 편집 단위(여기) vs 저장본 단위(저기) 경계
- [[Tooling API 객체 — 운영·라이프사이클 (Sandbox·배포·릴리즈)]] — 메타데이터 배포 요청 sObject `DeployRequest`·`DeployDetails` complex type 필드 상세. 컨테이너 배포(여기) vs 파일 기반 배포 요청 조회(저기) 경계
