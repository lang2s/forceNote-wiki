---
tags: [DevOps, 배포, Change Sets, Apex, Deployment, Sandbox]
source: salesforce_apex_developer_guide.pdf
created: 2026-06-19
aliases: [Change Sets, 체인지셋, Outbound Change Set, Inbound Change Set, 변경 세트 배포]
---

# Change Sets 배포

> Salesforce UI에서 outbound change set을 만들어 연결된(connected) org 사이로 Apex 클래스·트리거를 배포한다(예: sandbox org → production org). 보내는 쪽에서 컴포넌트를 담아 Upload하고, 받는 쪽(production)에서 awaiting deployment 목록의 change set을 Deploy한다.

---

## 1. 개념

> "Use change sets to deploy Apex classes and triggers between connected organizations, for example, from a sandbox org to your production org."

> "You can create an outbound change set in the Salesforce user interface and add the Apex components that you want to upload and deploy to the target organization."

연결된(connected) org 사이에서 **Apex 클래스·트리거**를 배포할 때 사용한다(예: sandbox org → production org). Salesforce 사용자 인터페이스에서 **outbound change set**을 만들고, 대상(target) org로 업로드·배포할 Apex 컴포넌트를 담는다.

배포는 두 단계로 나뉜다.

- **Outbound change set** — 보내는 쪽(예: sandbox)에서 컴포넌트를 모아 만들고, target org로 **Upload**한다.
- **Inbound change set** — 받는 쪽(예: production)에서 도착한 change set을 **Deploy**한다.

Apex Quick Start에서는 앞 단계에서 만든 Apex 코드(`MyHelloWorld` 클래스, `HelloWorldTestClass` 테스트 클래스)와 custom object를 change set으로 production org에 배포하는 절차를 예시로 보여준다.

---

## 2. EDITIONS

> [!note] EDITIONS
> Available in: **Salesforce Classic**.
> Available in **Enterprise, Performance, Unlimited, and Database.com Editions**.

> "This procedure doesn't apply to Developer organizations since change sets are available only in Performance, Unlimited, Enterprise, or Database.com Edition organizations. If you have a Developer Edition account, you can use other deployment methods."

**Developer Edition org에서는 change set을 사용할 수 없다** — change set은 Performance, Unlimited, Enterprise, Database.com Edition org에서만 제공되기 때문이다. Developer Edition 계정이라면 다른 배포 방법(예: Metadata API, Salesforce Extensions/CLI 등 [[Apex 배포 방법]] 참조)을 써야 한다.

---

## 3. 사전 요건 (Prerequisites)

배포에 앞서 다음이 모두 갖춰져 있어야 한다.

| 요건 | 내용 |
|---|---|
| Sandbox 계정 | Performance, Unlimited, 또는 Enterprise Edition org의 **sandbox 내 Salesforce 계정** |
| 테스트 클래스 | 배포할 코드의 테스트 클래스 (Quick Start 예시: `HelloWorldTestClass` Apex 테스트 클래스) |
| Deployment connection | sandbox ↔ production org 사이의 **deployment connection** — production org이 **inbound change set을 수신하도록 허용**해야 함 |
| 사용자 권한 | **"Create and Upload Change Sets"** 사용자 권한 — outbound change set의 생성·편집·업로드에 필요 |

> "A deployment connection between the sandbox and production organizations that allows inbound change sets to be received by the production organization. See "Change Sets" in Salesforce Help."

> "Create and Upload Change Sets" user permission to create, edit, or upload outbound change sets."

---

## 4. Outbound change set 만들기·업로드 (보내는 org)

Quick Start의 전체 단계 (예시 이름: `HelloWorldChangeSet`, 컴포넌트: `MyHelloWorld` · `HelloWorldTestClass`):

1. Setup에서 Quick Find 박스에 **Outbound Changesets**를 입력한 뒤 **Outbound Changesets**를 선택한다.
2. splash 페이지가 나타나면 **Continue**를 클릭한다.
3. Change Sets 목록에서 **New**를 클릭한다.
4. change set 이름(예: `HelloWorldChangeSet`)을 입력하고, 필요하면 설명(description)을 입력한 뒤 **Save**를 클릭한다.
5. **Change Set Components** 섹션에서 **Add**를 클릭한다.
6. 컴포넌트 타입 드롭다운에서 **Apex Class**를 선택하고, 목록에서 `MyHelloWorld`와 `HelloWorldTestClass` 클래스를 선택한 뒤 **Add to Change Set**을 클릭한다.
7. 의존 컴포넌트를 추가하려면 **View/Add Dependencies**를 클릭한다.
8. 모든 컴포넌트를 선택하려면 맨 위 체크박스를 선택한다. **Add To Change Set**을 클릭한다.
9. change set 페이지의 **Change Set Detail** 섹션에서 **Upload**를 클릭한다.
10. target organization(이 경우 production)을 선택하고 **Upload**를 클릭한다.
11. change set 업로드가 완료되면, production org에서 배포한다 (→ 다음 섹션).

> View/Add Dependencies는 선택한 컴포넌트가 의존하는 다른 컴포넌트(예: custom object, custom field)를 같이 담기 위한 단계다. 맨 위 체크박스로 전체 선택 후 Add To Change Set 한다.

UI 흐름 요약 (Setup 네비게이션 경로):

```text
// 구조 예시 — 실제 동작 코드 아님 (PDF 단계의 UI 경로 요약)
Setup ▸ Quick Find: "Outbound Changesets" ▸ Outbound Changesets
  └ New ▸ 이름(HelloWorldChangeSet)·설명 ▸ Save
     └ Change Set Components ▸ Add
        └ 타입: Apex Class ▸ MyHelloWorld, HelloWorldTestClass 선택 ▸ Add to Change Set
           └ View/Add Dependencies ▸ 맨 위 체크박스(전체) ▸ Add To Change Set
              └ Change Set Detail ▸ Upload ▸ target org(production) ▸ Upload
```

---

## 5. Inbound change set 배포 (받는 org · production)

업로드된 change set은 target org(production)의 inbound change set으로 도착한다. production org에서 다음을 수행한다 (위 4번 절차의 11단계 세부).

1. production organization에 로그인한다.
2. Setup에서 Quick Find 박스에 **Inbound Change Sets**를 입력한 뒤 **Inbound Change Sets**를 선택한다.
3. splash 페이지가 나타나면 **Continue**를 클릭한다.
4. **change sets awaiting deployment**(배포 대기) 목록에서 해당 change set의 이름을 클릭한다.
5. **Deploy**를 클릭한다.

---

## 6. Edition 제약 Note

> [!note]
> 이 절차는 **Developer organization에는 적용되지 않는다.** Change set은 Performance, Unlimited, Enterprise, Database.com Edition org에서만 사용할 수 있다. Developer Edition 계정이라면 다른 배포 방법을 사용한다(자세한 내용은 [[Apex 배포 방법]]).

---

## 7. Scope 경계 (이 PDF의 커버리지)

이 노트는 **Apex Developer Guide(v67.0 Summer '26)** 가 다루는 Change Sets 범위 — 위의 outbound/inbound 단계별 절차와 사전 요건 — 까지만 담는다. 다음 항목은 **이 PDF에 수록되지 않았으며(Salesforce Help 영역)**, 추측해서 적지 않는다.

- **Deployment connection 설정 절차** — sandbox ↔ production 연결을 어떻게 구성하는지의 상세 단계.
- **Change set 타입/모드** — validation-only deploy(검증만), 실제 deploy 등 배포 모드 옵션.
- **전체 outbound/inbound 관리 기능** — clone, profile 설정, 재배포, 컴포넌트 목록 검토 등.

> 위 항목은 아래 SEE ALSO의 Salesforce Help 공식 문서가 소관한다.

**SEE ALSO**
- Sandboxes: Staging Environments for Customizing and Testing: Change Sets (Salesforce Help 공식 doc — PDF 미수록 범위 위임)

---

## 관련 노트
- [[Apex 배포 방법]] — 5가지 배포 경로 개요·비교표 (이 노트는 그중 Change Sets의 단계별 deep dive)
- [[Sandbox 관리]] — change set의 출발지가 되는 sandbox 환경
- [[Metadata API 빌드·릴리스 워크플로]] — Change Sets 대신 사용할 수 있는 프로그래밍 방식 배포
- [[DevOps Center]] — change/release 관리 개선 경험 (change set 대안 파이프라인)
