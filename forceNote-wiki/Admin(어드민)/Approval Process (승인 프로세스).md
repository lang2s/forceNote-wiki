---
tags: [admin, approval-process, automation, classic-approval, approvals]
source: help.salesforce.com (Salesforce Help — Automate Your Business Processes; Classic Approval Processes; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=platform.approvals_getting_started.htm&type=5
created: 2026-07-03
aliases: [Approval Process, 승인 프로세스, Classic Approval Process, Jump Start Wizard, Standard Wizard, Approval Steps, Assigned Approver, Delegated Approver, Record Locking, Flow Approval Processes]
---

# Approval Process (승인 프로세스)

> 레코드가 승인되는 단계·승인자·각 시점의 자동 액션을 정의하는 선언적 승인 워크플로(Classic Approval Process). Setup에서 마법사로 구성하며, 프로그래밍 방식 짝은 Apex [[Approval Namespace]].

---

## 개요

**Classic Approval Process**는 레코드가 Salesforce에서 승인되는 방식을 자동화한다. 각 승인 단계, 각 단계에서 누가 승인하는지, 각 시점에 무엇을 할지를 지정한다. 즉, 승인 프로세스 = 레코드가 승인되기까지의 단계 조합 + 각 단계를 승인하는 사람이다.

- **Available in:** Salesforce Classic + Lightning Experience
- **Editions:** Enterprise, Performance, Unlimited, Developer
- **승인 프로세스 생성 권한:** Customize Application

> [!note]
> Classic Approval Processes로는 **User 오브젝트**에 승인 프로세스를 만들 수 없다.

> [!important] 현대 대안 — Flow Approval Processes
> **Flow Approval Processes**는 Classic의 현대 대안이다. 더 유연하며 레코드 변경으로 트리거되고, Apex 확장성, 규정 준수/감사용 상세 로깅을 제공한다. (공식: `automate_automated_approvals.htm`)
> 이 노트는 **Classic Approval Process**를 다루며, Flow 대안의 존재만 짚어 둔다.

---

## 용어 (Terminology)

| 용어 | 정의 |
|---|---|
| **Approval Process(승인 프로세스)** | 레코드 승인 방식을 자동화하고 각 단계를 지정한다. |
| **Approval Steps(승인 단계)** | 특정 승인 프로세스의 **승인 체인(chain of approval)**을 정의한다. 각 단계는 (1) 어떤 레코드가 그 단계로 진행할 수 있는가, (2) 승인 요청을 누구에게 할당하는가, (3) 각 승인자의 delegate가 요청에 응답하도록 허용할지를 지정한다. **첫 단계**는 레코드가 그 단계로 진행하지 못할 때 무엇을 할지 지정하고, **이후 단계**는 그 단계에서의 처리를 지정한다. |
| **Approval Request(승인 요청)** | 지정된 승인자에게 승인/거부를 요청하는 email · Salesforce app notification 등. |
| **Approval Actions(승인 액션)** | 필요한 모든 승인자가 요청을 승인하면 발생. |
| **Assigned Approver(할당된 승인자)** | 승인 요청에 응답할 책임이 있는 사용자. |
| **Delegated Approver(위임 승인자)** | assigned approver가 요청에 응답하도록 지정한 사람. 내부 Salesforce 사용자는 Delegated Approver 조회 필드로 나열/추가한다 — 관련 필드 `CommunityUserId` / `UserId` / `DelegatedApproverId`. |
| **Email Approval Response(이메일 승인 응답)** | 이메일 알림에 회신(reply)해 승인 요청에 응답할 수 있게 한다. |
| **Initial Submission Actions(초기 제출 액션)** | 사용자가 레코드를 승인에 처음 제출할 때 발생. |
| **Final Approval Actions(최종 승인 액션)** | 필요한 모든 승인이 획득됐을 때 발생. |
| **Final Rejection Actions(최종 거부 액션)** | 승인자가 요청을 거부할 때 발생. |
| **Recall Actions(회수 액션)** | 제출된 승인 요청이 회수(recall)될 때 발생. |
| **Outbound Message(아웃바운드 메시지)** | 지정된 엔드포인트(외부 서비스)로 정보를 전송한다. |
| **Process Instance(프로세스 인스턴스)** | 승인 프로세스의 한 인스턴스. 레코드가 승인 제출될 때마다 새 process instance가 생성된다. |
| **Process Instance Node(프로세스 인스턴스 노드)** | 승인 단계의 한 인스턴스. |
| **Record Locking(레코드 잠금)** | field-level security나 sharing 설정과 무관하게 사용자가 레코드를 편집하지 못하게 막는다. |

---

## 설정 흐름 (Setup, 5단계)

1. **준비 (Prepare)** — 각 승인 프로세스를 신중히 계획한다(체크리스트). (Prepare to Create a Classic Approval Process)
2. **마법사 선택** — Jump Start vs Standard (아래 참조).
3. **승인 단계 추가** — 승인 체인 정의.
4. **자동화 액션 추가** — 아래 "자동화 액션" 참조.
5. **활성화 (Activate)** — 최소 한 단계를 생성한 후 프로세스를 활성화한다.

```
// 구조 예시 — Setup 경로 표기(실제 동작 코드 아님)
Setup → Quick Find: "Approval Processes" → Approval Processes
  └ Manage Approval Processes For: (오브젝트 선택)
  └ Create New Approval Process → [Use Jump Start Wizard | Use Standard Setup Wizard]
     └ 진입 기준 → 승인 단계(할당 승인자·delegate) → 액션(초기 제출/승인/거부/회수) → Activate
```

---

## 두 마법사 (Wizards)

| 마법사 | 언제 | 특징 |
|---|---|---|
| **Jump Start Wizard** | **단일 단계(single step)** 승인 프로세스 | 일부 기본 옵션을 자동 선택해 빠르게 생성(Default Selections 제공) |
| **Standard Wizard** | 더 **복잡**하고 **특정 단계들을 직접 정의**하고 싶을 때 | 전체 제어(단계·기준·승인자·액션 세부 지정) |

---

## 자동화 액션 (Automated Actions)

액션을 연결할 수 있는 **그룹(시점)**은 다음과 같다:

- **approval steps(승인 단계)**
- **initial submission(초기 제출)**
- **final approval(최종 승인)**
- **final rejection(최종 거부)**
- **recall(회수)**

**액션 타입 4종:**

| 액션 타입 | 설명 |
|---|---|
| **Task** | 지정한 사용자에게 작업(task)을 할당한다. subject·status·priority·due date 등을 지정. |
| **Email Alert** | 지정 수신자에게 지정 email template으로 이메일을 전송한다. |
| **Field Update** | 선택한 필드 값을 변경한다. 값을 지정하거나 새 값 계산용 formula를 작성할 수 있다. |
| **Outbound Message** | 지정 엔드포인트로 메시지를 전송한다. username·포함 데이터를 지정 가능. ⚠️ **junction object의 classic approval process에서는 미지원**. |

예시: 경비가 승인되면 지급용 수표를 출력하려고 outbound message를 추가할 수 있다.

---

## 관련 노트
- [[Approval Process — 운영·엔드유저·레퍼런스]] — companion 심화 노트: org 준비(제출·발신자 재정의·이메일/Chatter/Slack 응답)·승인 한도·샘플 4종·이력 리포트·대량 관리·엔드유저 승인 경험
- [[Approval Namespace]] — 프로그래밍 방식 승인(Apex `Approval.process()`로 제출·승인·거부). 선언적 승인 프로세스의 코드 짝(declarative ↔ programmatic)
- [[Email Alerts, Templates & Auto-Response Rules (이메일 알림·템플릿·자동 응답)]] — 승인 단계에서 호출하는 Email Alert 발송 액션
