---
tags: [devops, apex, deploy, change-sets, metadata-api, tooling-api, vs-code, devops-center, compile-on-deploy, v67]
source: salesforce_apex_developer_guide.pdf v67.0 Summer '26 — Deploying Apex (print p.764-765)
created: 2026-06-19
aliases: [Apex 배포, Deploying Apex, Apex 배포 방법, deploy apex, 배포 방법 비교, Change Sets, 체인지셋, VS Code 배포, Code Builder 배포, Metadata API 배포, Tooling API 배포, DevOps Center 배포, Compile On Deploy, Perform Synchronous Compile on Deploy, 동기 컴파일, production org Apex 개발 불가, sandbox에서 production으로 배포, Apex를 어떻게 배포하나]
---

# Apex 배포 방법

> Production org에는 Apex를 직접 개발할 수 없다 — 개발은 sandbox/scratch org/Developer Edition org에서 하고, 그 결과를 운영 org로 옮기는 5가지 배포 경로(Change Sets · VS Code/Code Builder · Metadata API · Tooling API · DevOps Center)와 배포 시 자동 재컴파일(Compile On Deploy)을 정리한다.

---

## 개요

> "You can't develop Apex in your Salesforce production org. Your development work is done in a sandbox, in a scratch org, or in a Developer Edition org."

production org에서는 Apex를 직접 개발할 수 없다. 모든 개발 작업은 **sandbox**, **scratch org**, 또는 **Developer Edition org** 에서 수행한다. 따라서 "배포(deploy)"란 그 개발 org에서 만든 Apex 클래스·트리거와 관련 메타데이터를 **운영(production) org로 옮기는 작업**을 뜻한다.

배포 경로는 역할(개발자·SI·ISV 파트너)과 도구 환경에 따라 5가지가 있다. 아래 [배포 방법 비교](#배포-방법-비교-5가지--언제-무엇을)에서 한눈에 비교하고, 각 방법은 이어지는 섹션에서 다룬다.

---

## Compile On Deploy

각 org의 Apex 코드는 **metadata deploy, package install, package upgrade 를 완료하기 전에 자동으로 재컴파일**된다. 이를 통해 배포 직후 코드가 컴파일된 상태로 준비되어, 이후 요청 처리 시점에 재컴파일이 발생하지 않는다.

### org 타입별 자동 활성/비활성

| org 타입 | Compile On Deploy 기본값 | 비고 |
|---|---|---|
| production org | **자동 활성화** | 비활성화 불가 — "You can't disable the compile on deploy option in production orgs." |
| full sandbox | **자동 활성화** | 옵션 해제로 비활성화 가능 |
| developer sandbox | 비활성화 (disabled by default) | 필요 시 수동 활성화 |
| developer pro sandbox | 비활성화 (disabled by default) | 필요 시 수동 활성화 |
| partial copy sandbox | 비활성화 (disabled by default) | 필요 시 수동 활성화 |
| developer (Developer Edition) org | 비활성화 (disabled by default) | 필요 시 수동 활성화 |
| trial org | 비활성화 (disabled by default) | 필요 시 수동 활성화 |
| scratch org | 비활성화 (disabled by default) | 필요 시 수동 활성화 |

> [!note] Setup 옵션명
> 활성화/비활성화는 **Setup → Apex Settings → "Perform Synchronous Compile on Deploy"** 옵션으로 제어한다. 기본 비활성화 org에서 활성화하려면 이 옵션을 선택하고, full sandbox에서 비활성화하려면 이 옵션을 해제한다.

### 동작

배포 시 Apex compiler를 invoke하여 결과 **bytecode를 배포의 일부로 저장**한다. 예를 들어 custom field를 배포하면, **그 필드를 사용하는 모든 클래스가 재컴파일**된다.

### Tradeoff

- 배포 시간이 약간 증가한다.
- 그러나 이후 요청 처리 시 재컴파일이 불필요해지므로, **활성 사용자/프로세스의 성능 문제가 완화**된다.

### 권장

여러 사용자가 공유하는 sandbox/scratch org(기능 테스트용 또는 CI용)에서는 Compile On Deploy 활성화를 고려한다.

---

## 배포 방법 비교 (5가지 — 언제 무엇을)

소스 챕터가 명시한 사실만 채운다. 챕터가 언급하지 않는 셀은 `—`로 둔다(추측 금지).

| 방법 | 인터페이스 (UI/CLI/API) | 동기/비동기 | 단위 (granularity) | 주 용도 | 에디션/환경 |
|---|---|---|---|---|---|
| 1. Change Sets | UI (Salesforce Classic) | — | — | connected org 간 Apex 클래스·트리거 배포 (sandbox → production) | Enterprise, Performance, Unlimited, Database.com Editions |
| 2. VS Code & Code Builder | CLI + API (Salesforce CLI + Salesforce APIs) | — | — | Org Development / Package Development 모델 배포 | — (Code Builder는 웹 기반 IDE) |
| 3. Metadata API | API | 비동기 (`Operations.enqueueDeployment`) | — | 커스텀 오브젝트 정의 등 customization 배포 | — |
| 4. Tooling API | API | 비동기 (`ContainerAsyncRequest`) | 복합 타입의 단일 요소만 변경 | Apex 클래스/트리거 일부만 배포 | — |
| 5. DevOps Center | UI | — | — | 파이프라인 기반 work item promote (개발 → 운영) | — |

### 인라인 API 이름 / 타입 (소스에 등장하는 식별자)

```apex
// 구조 예시 — 실제 동작 코드 아님
// 아래는 소스 챕터에 등장하는 API 이름/타입 식별자 목록 (호출 스크립트 아님)

// Method 3 — Metadata API (비동기 배포)
Metadata.Operations.enqueueDeployment();

// Method 4 — Tooling API (복합 타입의 단일 요소 변경)
ContainerAsyncRequest    // compile + deploy 요청
ApexTriggerMember        // 트리거 변경
ApexComponentMember      // Visualforce 컴포넌트 변경
ApexPageMember           // Visualforce 페이지 변경
```

---

## 1. Change Sets

> "Use change sets to deploy Apex classes and triggers between connected organizations, for example, from a sandbox org to your production org."

> "You can create an outbound change set in the Salesforce user interface and add the Apex components that you want to upload and deploy to the target organization."

연결된(connected) org 사이에서 Apex 클래스·트리거를 배포할 때 사용한다(예: sandbox org → production org). Salesforce 사용자 인터페이스에서 **outbound change set**을 만들고, 대상 org로 업로드·배포할 Apex 컴포넌트를 추가한다.

> [!note] EDITIONS
> Available in: **Salesforce Classic**.
> Available in **Enterprise, Performance, Unlimited, and Database.com Editions**.

**SEE ALSO**
- Sandboxes: Staging Environments for Customizing and Testing: Change Sets (official doc)
- [[Change Sets 배포]] — outbound/inbound 단계별 절차·사전 요건 deep dive

---

## 2. Salesforce Extensions for VS Code & Code Builder

> "Salesforce Extensions for VS Code and Code Builder are powered by Salesforce CLI and the Salesforce APIs."

> "Salesforce Extensions for Visual Studio Code support different deployment options based on your role and needs as a customer, system integrator, or independent software vendor (ISV) partner. Salesforce DX supports Org Development and Package Development models to authorize, create, and deploy code in your project. For information on how to deploy to a Salesforce org with Visual Studio Code, see Salesforce Development Models."

> "Salesforce Code Builder is a web-based integrated development environment that has all the power and flexibility of Visual Studio Code in your web browser. ... see Code Builder: Quick Start."

Salesforce Extensions for VS Code와 Code Builder는 **Salesforce CLI와 Salesforce API**로 동작한다. 고객·시스템 통합사(SI)·ISV 파트너 등 역할과 필요에 따라 서로 다른 배포 옵션을 지원하며, **Salesforce DX**가 **Org Development**·**Package Development** 모델을 통해 프로젝트의 코드 인증·생성·배포를 지원한다.

**Code Builder**는 동일한 기능과 유연성을 웹 브라우저에서 제공하는 **웹 기반 통합 개발 환경**이다.

DX/CLI(`sf` CLI, `sfdx-project.json`) 기반의 자세한 배포 흐름은 [[Salesforce DX 개요]] 참조.

**SEE ALSO**
- Salesforce Extensions for Visual Studio Code: Deploy and Retrieve Code
- Salesforce DX Developer Guide: Develop Against Any Org
- Salesforce CLI Command Reference: `project deploy start`

---

## 3. Metadata API

> "Use Metadata API to deploy customization information, such as custom object definitions for your org."

> "To deploy custom metadata, use the Metadata.Operations.enqueueDeployment() method to asynchronously deploy metadata to the current org. For more information, see Operations Class."

커스텀 오브젝트 정의 등 **customization 정보**를 배포할 때 사용한다. Apex에서 커스텀 메타데이터를 배포하려면 `Metadata.Operations.enqueueDeployment()` 메서드로 **현재 org에 비동기 배포**한다.

> [!warning] 대량 배포 시 코드 커버리지 객체 삭제
> "If a single deployment has over 2,000 Apex classes, ApexCodeCoverage objects for the deployed classes are deleted even if the deployment fails or is rolled back. ApexCodeCoverageAggregate objects aren't affected."
>
> 즉, 단일 배포에 **2,000개를 초과하는 Apex 클래스**가 포함되면, 배포가 실패하거나 rollback되더라도 배포 대상 클래스의 `ApexCodeCoverage` 객체가 삭제된다. `ApexCodeCoverageAggregate` 객체는 영향을 받지 않는다.

**SEE ALSO**
- Metadata API Developer Guide: `deploy()`
- Using Salesforce Features with Apex: Metadata

Metadata API 전반과 호출 방식은 [[DevOps(데브옵스)/MetadataAPI(메타데이터API)/Metadata API 개요]], `deploy()`/`retrieve()` 상세는 [[DevOps(데브옵스)/MetadataAPI(메타데이터API)/Metadata API File-Based 호출]], Apex `Metadata` 네임스페이스의 `Operations` 클래스는 [[Metadata Namespace]] 참조.

---

## 4. Tooling API

> "Use Tooling API to deploy Apex classes or Apex triggers. Because Tooling API allows you to change just one element within a complex type, it is easy to deploy using Tooling API."

> "Use ContainerAsyncRequest to compile and deploy the changes with ApexTriggerMember, ApexComponentMember, and ApexPageMember."

Apex 클래스 또는 Apex 트리거를 배포할 때 사용한다. Tooling API는 **복합 타입(complex type) 안의 단일 요소만 변경**할 수 있어, 일부만 배포하기 쉽다. 변경을 컴파일·배포하려면 `ContainerAsyncRequest`를 `ApexTriggerMember`, `ApexComponentMember`, `ApexPageMember`와 함께 사용한다.

**SEE ALSO**
- Tooling API: When to Use Tooling API

---

## 5. DevOps Center

DevOps Center는 변경·릴리스 관리 경험을 개선하며, 파이프라인을 구성해 **work item을 개발 → 운영으로 promote**한다.

> 자세한 배포 흐름(파이프라인 구성, work item promote)은 [[DevOps Center]] 참조.

---

## 관련 노트
- [[DevOps Center]] — 5번 방법 정본 (파이프라인 기반 배포)
- [[Salesforce DX 개요]] — 2번 방법(VS Code/CLI)의 `sf` CLI·`sfdx-project.json` 기반
- [[DevOps(데브옵스)/MetadataAPI(메타데이터API)/Metadata API 개요]] — 3번 방법 Metadata API 전체
- [[DevOps(데브옵스)/MetadataAPI(메타데이터API)/Metadata API File-Based 호출]] — `deploy()`/`retrieve()` 상세
- [[Tooling API 배포]] — 4번 방법 Tooling API 컨테이너 비동기 배포 워크플로(MetadataContainer · ContainerAsyncRequest · *Member)
- [[Metadata Namespace]] — 3번 방법의 Apex `Metadata.Operations.enqueueDeployment()` API
- [[Metadata API 빌드·릴리스 워크플로]] — Org Development Model 배포 파이프라인
- [[platform-metadata-deploy]] (sf-skill — 실행형) — sf CLI 메타데이터 배포 실행형 스킬
