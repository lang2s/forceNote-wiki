---
tags: [devops, devops-center, data-model, object-model, async, change-tracking, promotion, heroku]
source: devops_center_dev.pdf (Salesforce DevOps Center Developer Guide v67.0, Summer '26)
created: 2026-06-27
aliases: [DevOps Center, 데브옵스 센터, 객체 모델, 데이터 모델, DevOps Center Data Model, 비동기 동작, 변경 추적, 프로모션, Async Operation Result, Source Member Reference, Remote Change, 번들 프로모션, 언번들 프로모션]
---

# DevOps Center 데이터 모델 개요

> DevOps Center 매니지드 패키지가 설치하는 커스텀 객체 모델의 개념 구조 — Project를 최상위 부모로 하는 객체 관계, Heroku 기반 비동기 동작, 사용자 변경 추적, 프로모션 메커니즘을 정리한다.

---

## DevOps Center 데이터 모델 이해하기 (Data Model)

DevOps Center 객체 모델은 매니지드 패키지를 org에 설치할 때 생성되는 **커스텀 객체들**로 구성된다. 최상위 객체는 **Project**이며, 거의 모든 다른 객체의 직접 또는 간접적 부모다. **유일한 예외는 Repository**로, 하나 이상의 프로젝트가 이를 참조(reference)한다.

> 명명 규칙: 이 가이드는 가독성을 위해 객체·필드를 API명이 아니라 **레이블**로 부른다. 예를 들어 `sf_devops__Async_Operation_Result__c` 대신 Async Operation Result, `sf_devops__Error_Details__c` 대신 Error Details라고 쓴다. 객체를 가리킬 때는 대문자(Project), 그 객체가 표현하는 DevOps Center 기능을 가리킬 때는 소문자(project)를 쓴다.

> [!note] 다이어그램 안내
> PDF 원본에는 객체 모델의 기초 객체들을 보여주는 관계 다이어그램이 있으나 pdftotext로 추출되지 않는다(모든 객체가 표시된 것은 아님). 아래 관계 정리는 PDF **본문 텍스트의 서술을 근거**로 작성했다.

### Project에 직접 관계를 갖는 3개 객체

다음 3개 객체는 Project 객체와 **직접 관계**를 갖는다.

- **Work Item** — 메타데이터 변경의 묶음(collection)을 표현한다. 사용자가 (소스 컨트롤 저장소에서 외부적으로 개발·커밋하는 대신) DevOps Center 안에서 work item을 개발 환경에 연결하면, Work Item 객체가 Environment 객체를 참조한다. work item이 promote될 때, 참조된 환경은 그 항목의 개발 작업이 이전에 수행된 곳이다. **하나의 프로젝트는 여러 work item을 가질 수 있다.**
- **Pipeline** — 릴리즈 파이프라인을 표현한다. Pipeline 객체는 하나 이상의 **Pipeline Stage** 자식 객체를 가지며, 이들은 integration·UAT·release 같은 파이프라인의 단계들을 표현한다. 파이프라인 스테이지는 특정 순서를 가지며, **production 스테이지는 항상 마지막**에 온다. 현재 **하나의 프로젝트는 단 하나의 파이프라인만** 가질 수 있다.
- **Environment** — 개발 작업 또는 promote된 작업의 테스트가 수행되는 환경을 표현한다. Project, work item, pipeline stage는 모두 환경과 직접 관계를 갖는다. **프로젝트는 여러 자식 환경을 갖지만, work item과 pipeline stage는 각각 하나의 환경만 참조**한다. 현재 환경 유형은 **Salesforce org**가 유일하다.

### 단일 프로젝트 격리 (Validation Rule)

DevOps Center 객체 모델은 **검증 규칙(validation rule)** 을 사용해 work item·environment·pipeline stage 등에 대한 모든 참조가 **하나의 프로젝트 안에 포함**되도록 강제한다. 예를 들어 work item이 새 pipeline stage로 promote될 때, work item과 pipeline stage는 **둘 다 같은 프로젝트의 일부**여야 한다. 한 프로젝트의 work item을 다른 프로젝트에 연결된 환경에 연결할 수 없다.

### 객체 관계 요약표

```text
// 구조 예시 — 실제 원본 다이어그램 아님 (PDF 다이어그램을 본문 서술 근거로 표로 재구성)
```

| 객체 | 부모/참조 | 관계(cardinality) | 비고 |
|---|---|---|---|
| Project | (최상위) | — | 거의 모든 객체의 직·간접 부모 |
| Repository | (Project가 참조) | 1 Repository ← N Project | **유일하게 Project 밑이 아닌 객체** |
| Work Item | Project | 1 Project → N Work Item | 내부 개발 시 Environment 1개 참조 |
| Pipeline | Project | 1 Project → 1 Pipeline | 현재 프로젝트당 1개 제한 |
| Pipeline Stage | Pipeline | 1 Pipeline → N Stage | 순서 있음, production은 항상 마지막, Environment 1개 참조 |
| Environment | Project | 1 Project → N Environment | 현재 Salesforce org만 가능 |

---

## DevOps Center의 비동기 동작 활용 (Asynchronous Operations)

DevOps Center 객체 모델을 구성하는 커스텀 객체들은 매니지드 패키지를 설치한 org 안에 존재한다. 그러나 DevOps Center가 수행하는 많은 동작은 **이 org 외부에서** 일어난다. 이런 동작에는 다음이 포함된다.

- 소스 컨트롤 저장소에서 **브랜치 병합(merge)**
- 개발·스테이징 환경으로 **메타데이터 배포(deploy)**
- 개발 환경에서 **메타데이터 가져오기(pull)**

DevOps Center는 이런 동작을 **Heroku 애플리케이션**에 위임한다. 이 Heroku 앱은 초기 DevOps Center 설치 과정에서 생성·구성된다.

### 30초 제한과 비동기 처리

예를 들어 DevOps Center가 스테이징 환경에 메타데이터를 배포할 때, 관련 데이터를 패키징해 Heroku 앱에 **HTTP POST**를 보낸다. Heroku 앱은 이 요청 페이로드를 파싱하고 필요한 작업을 수행한다. 그러나 **Heroku 애플리케이션은 HTTP 연결을 최대 30초까지만 열어둘 수 있고**, 메타데이터 배포는 때때로 그보다 오래 걸린다. 이 때문에 DevOps Center는 이런 동작을 **비동기적으로** 실행한다.

### Async Operation Result로 비동기 동작 관리

DevOps Center는 Heroku 앱과 상호작용할 때마다 **Async Operation Result**(`sf_devops__Async_Operation_Result__c`) 커스텀 객체에 레코드를 생성해 비동기 동작을 관리한다.

1. DevOps Center가 Heroku에 보내는 요청 페이로드에는 이 새 레코드의 **ID**가 포함된다.
2. Heroku는 그 ID를 사용해 Async Operation Result 레코드의 **Messages 필드**를 진행 상황으로 업데이트한다.
3. DevOps Center는 이 진행 메시지를 UI에 게시한다(예: promotion 중 "메타데이터 배포 중" 메시지).
4. Heroku가 동작을 마치면 Async Operation Result의 **Status 필드**를 **Completed** 또는 **Error**로 변경한다.

Heroku가 동작을 수행하는 동안 DevOps Center는 Async Operation Result 레코드의 status 변화를 **감시(watch)** 한다. status가 바뀌면 **Apex trigger**가 모델의 다른 객체들을 업데이트해 최종 상태를 반영한다. 예를 들어 promotion과 연관된 비동기 동작이 성공적으로 완료되면, DevOps Center는 **Deployment Result의 Completion Date 필드**를 업데이트한다. 이 업데이트가 다시 나머지 객체들에게 promotion이 성공했음을 알린다.

> PDF에는 이 흐름을 보여주는 다이어그램이 있으나 pdftotext로 추출되지 않는다. 위 4단계 + Apex trigger 흐름이 그 흐름의 텍스트 서술이다.

### 단일 Async Operation Result에 모든 객체를 연결하는 설계 목적

DevOps Center가 원격 동작을 수행할 때, **그 동작에 관여하는 모든 객체가 Async Operation Result와 연관(associate)** 된다. 이 설계는 두 가지 목적을 달성한다.

- **단일 트랜잭션 업데이트** — 원격 동작이 완료되면 Apex trigger가 **단일 SOQL 쿼리**를 실행해 연관된 모든 객체를 최종 상태로 업데이트할 수 있다. 이로써 업데이트가 **하나의 트랜잭션** 안에서 일어남이 보장된다.
- **진행 중 동작 감지(동시성 제어)** — 다른 잠재적 원격 동작들이 **이미 진행 중인 동작이 있는지 판단**하고, 필요하면 그것이 완료될 때까지 대기할 수 있다.

### 동시 Promotion 충돌 처리 예시

> PDF 원문 예시: UAT → Staging promotion 진행 중일 때 Integration → UAT promotion이 들어오는 경우

1. 한 사용자가 **UAT 파이프라인 스테이지 → Staging** promotion을 시작한다. 새 Async Operation Result 레코드가 연관된 **두 Pipeline Stage 레코드에 플래그**를 설정해, 진행 중인 원격 동작(promotion)과 연관되어 있음을 표시한다.
2. 그 후 **다른 사용자**가 **Integration → UAT** promotion을 시작한다.
3. DevOps Center는 먼저 이 두 스테이지 중 어느 하나라도 이미 원격 동작에 관여 중인지 확인한다.
4. **UAT 스테이지가 첫 번째 동작에 관여 중**이므로, DevOps Center는 첫 동작이 완료될 때까지 **대기한 후** 새 동작을 시작한다.

---

## DevOps Center의 사용자 변경 추적 (Change Tracking)

DevOps Center 사용자가 개발 환경에 연결되면, DevOps Center는 사용자가 환경에 가하는 변경을 추적한다. 이 추적 덕분에 나중에 그 변경을 검토(review)를 위해 소스 컨트롤 저장소에 **커밋**할 수 있다.

> PDF의 그래픽: 하나의 개발 환경에 두 개의 work item이 있고, 그 환경에 연결된 org에 DevOps Center가 추적 중인 메타데이터 변경 3개가 있는 상황을 예시로 든다.

### Org Source Tracking과 Remote Change

DevOps Center 환경의 유일한 유형은 sandbox나 scratch org 같은 **Salesforce org**다. 사용자가 개발 환경에서 변경을 가하면, 실제로는 자기 org의 메타데이터를 변경하는 것이다(예: Apex 클래스 생성, 표준 객체에 새 커스텀 필드 추가).

- 이 변경을 추적하기 위해 DevOps Center는 Salesforce의 **"source tracking"** 기능을 사용하며, 이는 다시 Tooling API 객체 **Source Member**에 의존한다.
- 많은 메타데이터 유형이 source tracking을 지원하지만 **전부는 아니다** — 자세한 것은 Metadata Coverage Report를 확인한다.
- source tracking을 지원하는 메타데이터 유형에 대해, Source Member 레코드는 org에서 변경된 각 메타데이터 조각에 대한 정보를 담는다. 각 레코드에는 **어떻게 변경됐는지(add·change·remove), 누가 변경했는지, 언제 변경했는지**가 포함된다.

DevOps Center는 Source Member Tooling API 객체를 **직접 사용하지 않는다.** 대신 그 정보를 커스텀 객체 **Source Member Reference**(`sf_devops__Source_Member_Reference__c`)로 미러링한다.

사용자가 개발 환경에서 메타데이터 변경을 가하면, DevOps Center는 Source Member Reference 레코드를 생성하고, 이를 새 **Remote Change**(`sf_devops__Remote_Change__c`) 레코드와 짝지운다. Remote Change 객체는 특정 메타데이터 조각에 대한 **동작의 누적(accumulation)** 을 표현하며, 언젠가 원격 소스 컨트롤 저장소에 커밋될 것이다.

**누적 동작 예시:**
- source member reference가 새 메타데이터(add)를 포함하고 그 뒤 같은 메타데이터에 여러 번 변경이 있어도, 연관된 remote change는 **여전히 add 동작**이다(이후 변경 횟수와 무관) — 사용자가 커밋할 때 소스 컨트롤 저장소가 add 동작을 수행하기 때문이다.
- source member reference가 먼저 어떤 메타데이터에 대한 change를 포함하고 그 뒤 그것을 remove하면, remote change는 단순히 **remove 동작**이다.

> remote change는 **work item이 아니라 environment에 연결**된다. 같은 환경에 여러 work item이 연관될 수 있기 때문이다. 그 결과 같은 환경에 연관된 모든 work item은 항상 소스 컨트롤 저장소에 커밋할 수 있는 **동일한 파일 집합**을 보여준다.

### Work Item에서 사용 가능한 변경 목록 결정

사용자는 개발 환경에서 변경을 만들고 테스트한 뒤 work item으로 **pull**한다. 이 동작으로 커밋 전에 변경을 미리 볼 수 있다. DevOps Center는 모든 Remote Change의 파일 목록에서 시작해, 다음 상황에 따라 목록을 수정한다.

- **`.forceignore` 파일 변경** — work item에 연관된 feature branch의 `.forceignore`가 바뀌면, 일부 remote change가 연관 work item에서 더 이상 보이지 않을 수 있다. 단, 한 feature branch의 `.forceignore` 변경은 **다른** feature branch에 연관된 work item의 사용 가능 변경 목록에는 영향을 주지 않는다. DevOps Center는 이 시나리오를 **Hidden Remote Change**(`sf_devops__Hidden_Remote_Change__c`) 객체로 관리한다. (예: Work Item 1은 Remote Change 2를 볼 수 있지만, Work Item 2의 feature branch는 그 메타데이터를 제외하는 `.forceignore`를 가져 못 본다.)
- **사용자가 feature branch에 파일 커밋** — 사용자가 커밋하면 DevOps Center는 org에서 메타데이터를 가져와 소스 컨트롤 저장소에 커밋한다. 그 후 커밋을 모델링하기 위해 **Change Submission**(`sf_devops__Change_Submission__c`) 레코드를 생성하고, 커밋에 포함된 모든 remote change를 이 레코드에 연관시킨다. 메타데이터 변경이 이제 저장소에 있으므로, 같은 환경에 연관된 다른 어떤 work item도 이 변경을 커밋할 수 없다. 따라서 DevOps Center는 change submission에 연관된 모든 remote change를 사용 가능 목록에서 **제외**한다. (예: Remote Change 3은 이미 커밋되어 Work Item 1·2 어디에도 나열되지 않는다.)

### 제출할 컴포넌트 결정 (Submit Component)

DevOps Center는 **Submit Component**(`sf_devops__Submit_Component__c`) 커스텀 객체로 work item에 연관된 feature branch에 커밋된 모든 변경을 추적한다. 이 변경은 두 곳에서 올 수 있다.

- 사용자가 **DevOps Center UI로 커밋**할 때, DevOps Center는 원격 커밋의 모든 관련 메타데이터를 Submit Component 객체 레코드로 추상화한다.
- 사용자가 **VS Code 등 UI 외부에서 feature branch에 커밋**할 때마다 DevOps Center가 통지받고, 그 커밋을 추적하기 위해 Submit Component 레코드를 생성한다.

즉 메타데이터 변경이 어떻게 feature branch에 커밋되든, Submit Component 객체가 그것을 표현한다. DevOps Center는 work item이 결국 promote될 때 이 객체들을 사용한다.

### Work Item 상태가 Never로 바뀔 때

사용자가 work item 상태를 **Never**로 바꾸면, DevOps Center는 그것에 연관된 **Change Submission과 Submit Component 레코드를 삭제**한다. 이 삭제는 UI 표시에 파급 효과를 가질 수 있다.

> 예: Work Item 2의 상태를 Never로 설정하면 그것에 연관된 Change Submission 레코드가 삭제된다. DevOps Center는 Remote Change 3에 나열된 변경을 사용 가능 변경 목록으로 **되돌리고**, 그 변경에 대한 source tracking을 **리셋**한다. 이제 Work Item 1이 이 변경을 표시하고 사용자는 이 work item에서 다시 커밋할 수 있다.

### Back Sync와 Revision Counter

> 객체 필드 전체 레퍼런스는 [[DevOps Center 객체 — 변경 추적]] 참조. 여기서는 개념 메커니즘만 다룬다.

**Back Sync**(`sf_devops__Back_Sync__c`) 객체는 DevOps Center 사용자의 개발 환경과 **첫 번째 파이프라인 스테이지의 브랜치 간 동기화**를 표현한다. 특히 동기화가 언제 일어났는지와, 동기화가 **무시할 수 있는** Source Member Reference 레코드들을 추적한다.

> PDF 원문 예시 — Revision Counter 동작:
> - 사용자가 이미 메타데이터 변경 2개를 개발 환경으로 pull했고(Remote Change 2개), 이 두 메타데이터 파일의 Source Member Reference **Revision Counter는 5와 6**이다.
> - Source Member Reference에 아직 pull하지 않은 변경 2개가 있으며 revision counter는 **7과 8**이다.
> - 사용자가 Pipeline Environment에서 **Sync**를 클릭한다. DevOps Center는 이 Back Sync 레코드의 **Start Revision Counter** 필드를 **8**로 설정한다.
> - 동기화가 Source Member Reference 테이블에 revision counter **9, 10, 11**의 새 행 3개를 생성한다.
> - 동기화가 완료되고, DevOps Center는 이 Back Sync 레코드의 **End Revision Counter** 필드를 **11**로 설정한다.
> - 사용자가 개발 환경에서 메타데이터 변경 2개를 추가로 만든다 → Source Member Reference의 revision counter는 **12, 13**.
> - 사용자가 다음에 work item에서 **Pull Changes**를 클릭하면, DevOps Center는 revision counter **7~13**에 해당하는 변경을 pull한다.
> - DevOps Center는 이 개발 환경에 연관된 다른 Back Sync 레코드를 먼저 확인하고, **revision counter 9, 10, 11은 무시**하며 **7, 8, 12, 13에 대해서만** Remote Change 레코드를 생성한다.

즉 Back Sync의 Start/End Revision Counter는 동기화로 자동 생성된 행(9·10·11)을 사용자 변경(7·8·12·13)과 구분해 **중복 Remote Change 생성을 막는** 역할을 한다.

---

## 프로모션 동작 방식 (How Promotions Work)

DevOps Center는 두 가지 promotion 유형을 지원한다.

- **Unbundled promotion(언번들 프로모션)** — 사용자가 하나 이상의 work item을 선택해 다음 파이프라인 스테이지로 promote(이동)한다.
- **Versioned promotion(버전드/번들 프로모션)** — work item들이 **Change Bundle**(`sf_devops__Change_Bundle__c`) 객체로 표현되는 단일 번들로 결합된다. 이 번들이 단일 단위로 다음 스테이지로 promote된다. Change bundle은 **1.0** 같은 버전 식별자를 갖는다.

### Pipeline Stage의 Versioned 필드와 스테이지 유형

Pipeline Stage 객체에는 **Versioned**라는 Boolean 필드가 있어, promotion이 스테이지로 들어오는 방식을 제어한다. 필드 값이 스테이지 유형을 결정한다.

| 스테이지 유형 | 의미 |
|---|---|
| **Unbundled Stage** | 사용자가 work item을 개별 선택해 promote해 들어오는 스테이지 |
| **Bundling Stage** | 파이프라인의 **마지막 unbundled 스테이지**. work item이 개별적으로 promote되어 들어오지만, 새 change bundle이 여기서 promote되어 **나간다** |
| **Versioned Stage** | change bundle이 promote되어 **들어오는** 스테이지 |

admin이 파이프라인을 만들면 DevOps Center는 bundling 스테이지를 포함한 전형적인 릴리즈 파이프라인 템플릿을 제공한다. 단, 완전한 구성 유연성이 있어 사용자는 Approved Work Items 목록에서 첫 파이프라인 스테이지로 promote할 work item을 개별 선택할 수 있다. admin은 후속 스테이지를 unbundled 또는 versioned로 구성할 수 있다. **그러나 admin이 한 스테이지를 versioned로 만들면, 파이프라인에서 그 오른쪽의 모든 스테이지도 versioned여야 하며, 다시 unbundled로 되돌릴 수 없다.**

### 공통 프로모션 커스텀 객체 (Common Promotion Custom Objects)

unbundled와 bundled promotion 모두가 공유하는 공통 객체다.

**Deployment Result**(`sf_devops__Deployment_Result__c`)
- 파이프라인 스테이지에 연관된 환경(현재 항상 Salesforce org)으로의 메타데이터 배포 **요청과 결과**를 추적한다.
- 사용자가 promotion을 시작하면 DevOps Center는 모든 요청 속성(배포가 full인지 partial인지, 배포할 메타데이터 컴포넌트 집합 등)을 담은 Deployment Result 레코드를 생성한다. 각 메타데이터 컴포넌트는 Deployment Result의 자식인 **Deploy Component**(`sf_devops__Deploy_Component__c`) 레코드로 저장된다.
- 배포할 메타데이터 컴포넌트 집합 계산 방식:
  - **unbundled promotion** — 사용자가 promote하려고 선택한 모든 work item에 연관된 모든 Submit Component 레코드에서 가져온다.
  - **versioned promotion** — 이전 versioned promotion의 Deploy Component에서 가져온다.
- promotion이 완료되면 Heroku 앱이 같은 Deployment Result 레코드에 결과 속성(배포 ID, 완료 일자, 완료된 테스트 수 등)을 기록한다.

**Merge Result**(`sf_devops__Merge_Result__c`)
- 소스 컨트롤 저장소에서 브랜치 병합의 요청과 결과를 추적한다.
- promotion이 항상 병합을 요구하는 것은 아니다(예: 사용자가 소스 컨트롤 저장소에서 개발 환경을 동기화할 때). 때로는 두 번 이상의 병합이 필요하다(예: 여러 work item의 unbundled promotion).
- 사용자가 promotion을 시작하면 DevOps Center는 필요한 **각 병합마다** Merge Result 레코드를 생성한다. promotion이 완료되면 Heroku 앱이 같은 Merge Result 레코드에 병합 ID(GitHub에서는 SHA)를 기록한다.

### Unbundled Promotion 심화 (단계별 객체 상태)

사용자가 unbundled promotion을 시작하면 DevOps Center는 promotion에 포함된 **각 work item마다 Work Item Promote**(`sf_devops__Work_Item_Promote__c`) 레코드를 생성한다. 각 work item은 여전히 사용자 소스 컨트롤 저장소의 feature branch에 연관되어 있어, 각 브랜치가 대상 스테이지 환경의 브랜치로 병합돼야 한다. 따라서 **모든 Work Item Promote 레코드는 연관된 Merge Result 레코드를 갖는다.** 그러나 전체 promotion에 대한 메타데이터 배포는 하나뿐이므로(대상 스테이지 환경으로), **각 Work Item Promote 레코드는 공유된 하나의 Deployment Result 레코드를 가리킨다.**

> 예시: work item **WI-000003**을 Integration 스테이지 → UAT로 promote(DevOps Center UI에서 시작).

**① Promotion 이전 상태 (State Before)**

| 커스텀 객체 | 필드 | 값 | 비고 |
|---|---|---|---|
| Work Item | Status | NULL | 비동기 동작 참조 |
| Work Item | Promoted | TRUE | — |
| Work Item | Review Remote Reference | (값 있음) | 이 work item의 feature branch와 대상 스테이지 간 변경 요청의 고유 ID |
| Pipeline Stage | Status | NULL | 비동기 동작 참조 |
| Work Item Promote | Work Item | WI-000003 | work item이 이전에 Approved Work Item → Integration으로 promote될 때 생성된 레코드 |
| Work Item Promote | Pipeline Stage | Integration | — |
| Work Item Promote | Status | (값 있음) | Completed 상태의 Async Operation Result 레코드 참조 |

**② Promotion 진행 중 상태 (State During)** — 사용자가 항목 선택 후 **Promote Selected** 클릭 직후. `New or Existing?`는 이 단계에서 레코드가 새로 생성되는지 기존 것인지 표시.

| 커스텀 객체 | New/Existing | 필드 | 값 |
|---|---|---|---|
| Async Operation Result | New | Status | In Progress |
| Async Operation Result | New | Operation | AD_HOC_PROMOTE |
| Async Operation Result | New | Message | 비동기 프로세스가 현재 상태로 주기적으로 갱신 |
| Work Item | Existing | Status | 새 Async Operation Result 레코드의 ID |
| Pipeline Stage | Existing | Status | 새 Async Operation Result 레코드의 ID |
| Work Item Promote | New | Work Item | WI-000003 (이 레코드는 Integration → UAT의 현재 promotion을 표현) |
| Work Item Promote | New | Pipeline Stage | UAT |
| Work Item Promote | New | Status | 새 Async Operation Result 레코드의 ID |
| Deployment Result | New | n/a | — |
| Merge Result | New | Source Branch | work item에 연관된 feature branch |
| Merge Result | New | Target Branch | UAT 스테이지에 연관된 브랜치 |

그 후 DevOps Center는 Heroku에 비동기 처리(적절한 환경으로 메타데이터 배포, 브랜치 병합) 요청을 보낸다. **Heroku가 인계받은 후** 변경되는 값:

| 커스텀 객체 | 필드 | 값 (Heroku가 변경) | 비고 |
|---|---|---|---|
| Async Operation Result | Message | promotion 상태에 기반한 상태 메시지 | — |
| Deployment Result | Deployment Id | 이 promotion의 메타데이터 배포 ID | DevOps Center가 promotion 시작 즉시 이 값을 설정 |
| Merge Result | Remote Reference | feature branch → 대상 스테이지 브랜치 병합 커밋의 병합 ID(GitHub의 SHA) | — |
| Merge Result | Previous Remote Reference | 이 work item이 병합되기 전 대상 스테이지 브랜치의 SHA | — |

**③ Promotion 성공 상태 (State When Succeeds)**

| 커스텀 객체 | 필드 | 값 | 비고 |
|---|---|---|---|
| Async Operation Result | Status | Completed | — |
| Async Operation Result | Message | Promotion Completed | — |
| Deployment Result | Completion Date | 배포 완료 일시 | — |
| Merge Result | Merge Date | 병합 완료 일시 | — |
| Work Item | Status | NULL | — |
| Work Item | Branch | rebase 후 브랜치의 start/end SHA로 갱신 | — |
| Work Item | Rebase Branch | 초기 promotion 후 feature branch의 start/end SHA로 갱신 | **초기 promotion 후에만 생성됨** |
| Pipeline Stage | Status | NULL | — |

> 성공 후 DevOps Center는 work item에 연관된 feature branch의 **rebase**도 수행한다(예: feature branch rebase·삭제 등). PDF는 rebase의 상세는 다루지 않으며 추후 제공 예정이라고 명시한다.

**④ Promotion 실패 상태 (State When Fails)**

| 커스텀 객체 | 필드 | 값 |
|---|---|---|
| Async Operation Result | Status | ERROR |
| Async Operation Result | Message | 비동기 처리의 에러 메시지 |
| Async Operation Result | Error Details | (가능하면) 스택 트레이스 또는 상세 에러 정보 |
| Deployment Result | Deployment Id | NULL |
| Deployment Result | Completion Date | NULL |
| Merge Result | Merge Date | NULL |
| Merge Result | Remote Reference | NULL |
| Merge Result | Previous Remote Reference | NULL |
| Work Item | Status | NULL |
| Pipeline Stage | Status | NULL |

### 변형 1: 다중 Work Item

앞 흐름은 단일 work item이었다. 여러 work item을 동시에 unbundled promote할 수도 있다. 흐름은 유사하나 다음 차이가 있다.

- **각 Work Item 레코드마다** DevOps Center가 **고유한 Work Item Promote 레코드와 고유한 Merge Result 레코드**를 생성한다.
- 그러나 함께 promote되는 **모든 Work Item Promote 레코드는 단일 Deployment Result와 단일 Async Operation Result를 공유**한다.

### 변형 2: 외부에서 병합된 변경 요청 (Externally Merged Change Request)

앞 흐름에서는 DevOps Center가 소스 컨트롤 저장소에서 변경 요청을 병합했다. 그러나 개발자가 GitHub UI 등에서 **외부적으로** 변경 요청을 병합할 수도 있다.

- promotion 이전의 초기 상태는 ①과 동일하다. 그 후 사용자가 소스 컨트롤 저장소에서 외부로 변경(pull) 요청을 병합한다(예: WI-000005의 GitHub feature branch → `doce-uat` 브랜치를 권장 옵션인 **Squash and Merge**로 병합). 이 pull request는 WI-000005가 Integration 스테이지로 promote될 때 DevOps Center가 GitHub에 생성한 것이다.
- 이 시점에 변경은 병합됐지만 아직 배포되지 않은 **부분 promote 상태(partially promoted)** 다. DevOps Center는 work item과 파이프라인 양쪽에서 사용자에게 알린다.

사용자가 DevOps Center에서 **Complete Promotion**을 클릭하기 **전**, 외부 병합 후의 객체 모델 상태(두 레코드 모두 새로 생성):

| 커스텀 객체 | 필드 | 값 |
|---|---|---|
| Work Item Promote | Work Item | WI-000005 (Integration → UAT의 현재 미배포 promotion 표현) |
| Work Item Promote | Pipeline Stage | UAT |
| Merge Result | Source Branch | work item에 연관된 feature branch |
| Merge Result | Target Branch | UAT 스테이지에 연관된 브랜치 |
| Merge Result | Remote Reference | feature branch → 대상 스테이지 브랜치 병합 커밋의 병합 ID(GitHub SHA) |
| Merge Result | Previous Remote Reference | 병합 전 대상 스테이지 브랜치의 커밋 ID |
| Merge Result | Remote Reference Date | 외부 병합이 발생한 날짜 |

사용자가 **Complete Promotion**을 클릭하면 DevOps Center는 ②(State During)에서 설명한 대로 계속 처리한다. 단 일부 레코드(Work Item Promote·Merge Result)는 이미 존재한다는 점만 다르며, 나머지 promotion은 동일하다.

---

## 관련 노트
- [[DevOps Center 객체 — 파이프라인·프로젝트·환경]]
- [[DevOps Center 객체 — Work Item·프로모션]]
- [[DevOps Center 객체 — 비동기·결과]]
- [[DevOps Center 객체 — 변경 추적]]
- [[DevOps Center — User 필드·플랫폼 이벤트]]
- [[checking-devops-prerequisites]] · [[recommending-devops-tests]] (sf-skill — 실행형) — DevOps Center 사전확인·테스트 스위트 추천 실행형 스킬
