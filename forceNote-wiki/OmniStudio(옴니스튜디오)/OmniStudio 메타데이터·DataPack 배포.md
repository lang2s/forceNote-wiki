---
tags: [omnistudio, metadata, deployment, datapack, salesforce-cli, migration, vlocity-build]
source: help.salesforce.com — OmniStudio Deployment & Metadata (xcloud.os_omnistudio_for_vlocity·os_deploy_recommended_tool·os_deploy_omnistudio_between_orgs·os_deploy_lightning_web_components_58289·os_viewing_the_namespace_and_version_of_the_omnistudio_vlocity_package_8315·os_omnistudio_naming_conventions, 접속일 2026-07-13) [Tier 2]
created: 2026-07-13
aliases: [OmniStudio 배포, OmniStudio metadata, DataPack, Vlocity Build, Build Tool, Salesforce CLI 배포, OmniProcess metadata, OmniUiCard metadata, 네임스페이스, Metadata API support, org 간 배포, 명명 규칙]
---

# OmniStudio 메타데이터·DataPack 배포

> OmniStudio 컴포넌트를 org 간에 옮길 때 어떤 도구를 쓰는가 — standard runtime은 Salesforce CLI, managed package는 Build Tool(DataPacks) — 와 컴포넌트별 메타데이터 명명 규칙·네임스페이스 확인·Metadata API 지원을 정리한다.

---

## Standard vs Managed Package (배포 관점)

OmniStudio는 두 가지 런타임/데이터 모델로 존재하며, **어느 쪽인가에 따라 배포 도구가 갈린다.**

| 구분 | 런타임 | 데이터 모델(objects) | 배포 도구 |
|---|---|---|---|
| **Omnistudio** (standard) | standard runtime | standard objects | **Salesforce CLI** (권장) |
| **Omnistudio for Managed Packages** | managed package runtime | custom objects | **Build Tool** (DataPacks / Vlocity Build) |

> Omnistudio for Managed Packages는 이전 이름이 **Omnistudio for Vlocity**다. Managed Packages는 managed package runtime과 **custom objects**를 사용한다. standard runtime과 objects를 쓰면 그냥 Omnistudio다.

Omnistudio for Managed Packages에 포함되는 컴포넌트(dump verbatim):

- **Omniscripts** — the interaction logic를 담는다.
- **Flexcards** — user interaction과 data tools를 묶는다.
- **Omnistudio Data Mappers** — Omnistudio와 Salesforce 사이에서 데이터를 전송한다.
- **Integration Procedures** — 효율·재사용을 위해 server-side operations를 번들링한다.

추가 도구: **OmniOut**(LWC Omniscripts/Flexcards를 서드파티 웹사이트에서 off-platform 실행), **Calculation procedures and matrices**, **Tracking service and OmniAnalytics**.

---

## 배포 도구 (핵심)

### Standard runtime → Salesforce CLI 권장

> Salesforce recommends that you use **Salesforce CLI** for deploying Omnistudio components between orgs **when you're on Omnistudio standard runtime with standard objects.**

Salesforce CLI는 **Salesforce standard deployment tool**이며 다음을 아우른다(caters across):

- **Omnistudio components** — Omniscripts, Flexcards, Integration Procedures, Data Mappers.
- **Other Salesforce components** — Business Rules Engine 등.
- **Metadata** — FlexiPage, PermissionSet, Omnistudio Lightning Web Components, and components, and entities.

**동작 조건(제약):** Salesforce CLI works only with **standard objects in the source org**, and with **standard objects and standard runtime in the target org**. 즉 source·target 둘 다 standard여야 한다.

Salesforce CLI 배포의 이점:

- **Consistency** — 모든 배포 요구를 하나의 standard 도구로. 환경 간 일관된 배포, 불일치 최소화.
- **No learning curve** — CLI에 익숙한 사용자에게 직관적. 복잡한 UI/도구를 새로 배울 필요 없음.

### ⚠️ 제약 — setup objects와 non-setup objects를 함께 배포 불가

> **Note:** You can't deploy setup objects and non-setup objects together.

| 분류 | 포함 objects |
|---|---|
| **Setup objects** | FlexiPage, Profile, PermissionSet, CustomField |
| **Non-setup objects** | Omnistudio entities such as **OmniProcess**, **OmniUICard** |

→ 두 부류를 **분리 배포**해야 한다.

### Managed Package → Build Tool (DataPacks / Vlocity Build)

Omnistudio for Managed Packages를 쓴다면 **다른 배포 도구를 반드시 사용**해야 한다(you must use different deployment tools). 이 경우 standard의 Salesforce CLI가 아니라 **Build Tool**로 DataPacks를 옮긴다. (Salesforce CLI vs Build Tool 차이는 "Deployment of Omnistudio for Managed Packages Components Between Orgs" 참조.)

> ⚠️ 흔한 오해 정정: **standard OmniStudio의 기본 배포 도구는 Salesforce CLI다** — DataPacks/Build Tool이 아니다. DataPacks(Build Tool)는 **managed package** 전용이다.

---

## Org 간 배포 (Deployment Between Orgs)

standard runtime + standard objects인 프로젝트는 **Salesforce CLI**로 컴포넌트와 메타데이터를 한 org에서 다른 org로 이동한다.

DevOps 방법으로 흐름을 구성한다:

1. **dev org**에서 Omnistudio로 솔루션을 만든다(DevOps methods 사용).
2. 그 컴포넌트를 **test/integration org**에 배포해 테스트한다.
3. 최종적으로 **production org**에 배포한다.

> **Note:** org 간 컴포넌트 **배포(deployment)** 와 Omnistudio for Managed Packages → Omnistudio로의 **마이그레이션(migration)** 은 서로 다른 프로세스다. ("Deploying Omnistudio Components Between Orgs" vs "Migrating to Omnistudio Standard".)

Omnistudio for Managed Packages를 쓴다면 여기서도 different deployment tools(= Build Tool)를 써야 한다.

> 배포 대상 org를 **Scratch Org**로 준비할 때의 feature/setting enablement는 [[Scratch Org Settings 레퍼런스]]를, Salesforce CLI 명령 일반은 [[sf CLI 명령 카탈로그 · sfdx→sf 매핑]]을 참조.

---

## LWC 배포 (Deploy Lightning Web Components)

새 Lightning web components를 배포하거나 기존 컴포넌트를 변경할 때, 로컬 개발 환경에서 **Visual Studio + Salesforce DX** 또는 **IDX Workbench**로 배포한다.

1. Visual Studio에서 프로젝트를 연다.
2. **Salesforce DX** 또는 **IDX Workbench**가 설치되어 있는지 확인한다. (설치는 "Salesforce DX Setup Guide" 참조.)
3. 터미널에서 다음 명령을 실행해 변경사항을 org에 배포한다:

```
sf project deploy start
```

(개발 환경 셋업은 "Set Up Lightning Web Components", Visual Studio로의 배포 상세는 "Analyze Your Code and Deploy It to Your Org" 참조.)

---

## 네임스페이스·버전 확인

Omnistudio는 **managed package**로 설치될 수 있다(Cloud 제품 — Insurance·Communications 등 — 이거나 Omnistudio Foundation). **업그레이드 계획이나 트러블슈팅**에 필요한 namespace·version을 확인하는 절차:

1. **Setup**으로 이동한다.
2. Quick Find 박스에 **Installed Packages**를 입력하고 클릭한다.
3. Installed Packages 페이지에 패키지의 최신 버전이 나열되었는지 확인한다.
4. Installed Packages 페이지에서 현재 사용 중인 **Omnistudio Vlocity 패키지**를 클릭한다.

결과 페이지에 Omnistudio Vlocity 패키지 상세 — **namespace, version number, license information** — 가 표시된다.

---

## 명명 규칙 (Naming Conventions)

Omnistudio 컴포넌트(Data Mapper·Flexcard·Integration Procedure·Omniscript) 생성 시 아래 규칙을 따른다. 각 컴포넌트는 실제 저장 sObject와 Unique Name 규칙이 다르다.

| Product | sObject | Unique Name 규칙 |
|---|---|---|
| **Integration Procedures** | `Omni Process` | **Type_SubType**: Type과 SubType을 **underscore**로 결합해 IP 호출에 쓰는 unique identifier를 만든다. Name Type·SubType은 letters, numbers, special characters를 담을 수 있으나 **spaces 불가**. 예: Type=Auto, SubType=CreateUpdateQuote → `Auto_CreateUpdateQuote`. |
| **Data Mappers** | `Omni Data Transformation` | **Interface Name**: Interface Name은 unique해야 한다. letters, numbers, **dashes**를 담을 수 있으나 **spaces 불가**. |
| **Omniscripts** | `Omni Process` | **TypeSubtypeLanguage**: Type·SubType·Language를 결합해 compiled Omniscript의 LWC 이름이 되는 unique identifier를 만든다. Type·SubType은 letters·numbers만, **spaces나 underscores 불가**, **104자 초과 불가**. 예: Type=account, SubType=Create, Language=English → LWC명 `accountCreateEnglish`. |
| **Flexcards** | `Omni Ui Card` | **Name + Author**: card Name과 Author의 조합이 Org 내에서 unique해야 한다. Name·Author는 **letters, numbers, underscores만**, letter로 시작, spaces 불가, underscore로 끝나지 않음, 연속 underscore 2개 불가. |

### 예약어 (Reserved Words)

다음 예약어는 Flexcard 이름이나 element 이름에 쓰면 안 된다(dump verbatim):

- Action
- Data-element-label
- Data-action-key
- Data-element-label
- Data-action-element-class
- Flyout
- FlyoutType
- Tracking-obj
- Parent-Mergefields

### Omnistudio Metadata API Support

Setup의 **Omnistudio Settings**에서 Omnistudio Metadata API support를 활성화하면:

- Omnistudio 컴포넌트 이름은 **letters와 numbers만** 포함할 수 있고, **spaces나 underscores 같은 special characters를 담을 수 없다.**
- **Omniscripts** 예외: 이름에 special characters가 들어갈 수 있으나, **Type·Subtype·Language의 unique 조합**에는 special characters가 들어갈 수 없다.
- **활성화 이후엔** unique name에 special characters가 들어간 컴포넌트를 **생성할 수 없다.**

(활성화 절차는 "Enable Omnistudio Metadata API Support" 참조.)

---

## 관련 노트
- [[OmniStudio 개요·오리엔테이션]]
- [[OmniStudio 셋업·권한·활성화]]
- [[Integration Procedure]]
- [[Data Mapper (DataRaptor)]]
- [[OmniScript]]
- [[FlexCard]]
- [[Scratch Org Settings 레퍼런스]]
- [[sf CLI 명령 카탈로그 · sfdx→sf 매핑]]
