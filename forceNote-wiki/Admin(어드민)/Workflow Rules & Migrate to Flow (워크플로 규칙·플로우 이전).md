---
tags: [admin, automation, workflow-rules, migrate-to-flow, legacy]
source: help.salesforce.com (Salesforce Help — Workflow Rules / Migrate to Flow Tool Considerations; 라이브 공식 문서, Tier 2, 접속 2026-07-03) · extend_click_automate.pdf (Automate Your Business Processes with Salesforce Flow, Spring '26, Tier 2 — Legacy Salesforce Flow Features / Migrate to Flow Tool Considerations)
official_doc: https://help.salesforce.com/s/articleView?id=platform.migrate_to_flow_tool_considerations.htm&type=5
created: 2026-07-03
aliases: [Workflow Rules, 워크플로 규칙, Migrate to Flow, 플로우 이전, Legacy Automation, Time-Dependent Action, Process Builder, 프로세스 빌더, Migrate to Flow Tool]
---

# Workflow Rules & Migrate to Flow (워크플로 규칙·플로우 이전)

> 레코드 생성·편집 시 액션(이메일 알림·필드 업데이트·태스크·아웃바운드 메시지)을 자동 실행하는 **레거시** 선언적 자동화. ⚠️ 은퇴 중 — **Migrate to Flow** 도구로 Flow로 이전하며, 트리거 flow가 더 빠르다.

---

## ⚠️ 레거시 · 은퇴 안내 (먼저 읽기)

**Workflow Rules는 신규 자동화 대상이 아니다.** 대부분의 workflow rule은 이메일 알림과 **같은 레코드의 필드 업데이트**에 쓰였는데, **트리거 flow가 더 빠르다.** Salesforce는 기존 workflow rule을 **Flow Builder로 마이그레이션**하기를 권장하며, Process Builder 역시 은퇴 중이다.

- **신규 자동화**는 workflow rule이 아니라 [[Flow — 선언적 자동화 개요 (플로우)]]로 만든다.
- **기존 workflow rule**은 아래 **Migrate to Flow** 도구로 flow로 변환한다.

---

## 개념 — Workflow Rule이란

Workflow Rule은 레코드 **생성·편집** 시 규칙을 평가해 **액션**을 자동 실행하는 선언적 자동화다. 규칙 조건을 만족하면 아래 액션이 실행된다.

| 액션 | 설명 |
|---|---|
| **Email Alert** | 지정 수신자에게 이메일 알림 발송 |
| **Field Update** | **같은 레코드**의 필드 값을 업데이트 |
| **Task** | 태스크 레코드 자동 생성 |
| **Outbound Message** | 외부 엔드포인트로 아웃바운드 메시지 전송 |
| **Time-Dependent Action** | 규칙 충족 후 **시간이 경과한 뒤** 실행되는 액션 |

> Field Update는 **같은 레코드(same record)** 한정이라는 점에 유의한다.

---

## Migrate to Flow 도구

기존 workflow rule을 flow로 변환하는 도구다.

- **Email Alert 재사용:** workflow에서 쓰던 Email Alert를 flow에서 **그대로 재사용**한다. Email Alert는 workflow와 동일하게 **Process Automation의 Workflow Actions** 아래에 구성되어 있으므로, 마이그레이션 후에도 같은 위치의 액션을 참조한다.
- 변환 후에는 트리거 flow가 workflow rule 대비 더 빠르게 동작한다.

---

## Process Builder — 은퇴 상태와 Migrate to Flow 절차

> 출처: *Automate Your Business Processes with Salesforce Flow* (ECA, Spring '26, Tier 2) — "Legacy Salesforce Flow Features" / "Migrate to Flow Tool Considerations". Process Builder와 Workflow Rules는 모두 legacy 자동화이며 Migrate to Flow 도구로 함께 이전한다.

### 은퇴 상태 (retirement)

ECA 원문:

> "Starting in **Winter '23**, you can't create new processes or workflow rules. You can still **activate, deactivate, and edit** any existing processes and workflow rules."

- **Winter '23부터 신규 생성 불가** — Process Builder 프로세스·Workflow Rule 모두. 기존 것은 **활성화·비활성화·편집**만 가능하다.
- Salesforce는 이를 *pending retirement*(은퇴 예정)로 표현하며, **Flow Builder**를 미래 표준으로 권장한다.
- ⚠️ **구체 하드 종료(삭제) 일자는 Spring '26 ECA 문서에 명시되지 않음** — 문서가 제시하는 확정 사실은 "Winter '23 신규 생성 차단"뿐이다. (그 이후의 완전 종료일은 이 소스에서 확인 불가.)
- 신규 자동화는 Flow Builder로 만들고, 기존 프로세스/규칙은 **Migrate to Flow 도구**로 sandbox에서 먼저 테스트한 뒤 프로덕션으로 이전한다.

### Migrate to Flow 도구 — Process 마이그레이션

Migrate to Flow 도구는 **Process Builder 프로세스와 workflow rule을 모두** Flow Builder로 변환하며 scheduled actions를 포함해 **부분 마이그레이션**도 지원한다.

**지원 대상 프로세스:** **record-triggered process만** 지원한다. **Custom event · custom invocable type** 프로세스, **custom metadata types**, 관련 객체 필드를 참조하는 criteria(**field traversals**)는 지원하지 않는다.

**추가 설정 없이 마이그레이션되는 액션 타입:**
- Record update · Record create · Invoke flow · Invoke Apex · Email alert

**마이그레이션 후 원래 위치는 유지되나 추가 설정이 필요한 액션 타입:**
- Post to Chatter · Quick Action · Submit for Approval · Send Custom Notification · Live Message Notification · Send Surveys · Quip-related action types

**주요 고려사항 (ECA 전수):**

| 항목 | 동작 |
|---|---|
| **Recursion** | 완전 지원 안 됨 — recursion 프로세스를 마이그레이션하면 레코드가 **1회만 평가**된다. 마이그레이션 후 의도대로 동작하는지 테스트 필요 |
| **마이그레이션 형태** | 프로세스는 **Actions and Related Record-optimized(after-save)** flow로 변환된다. 이후 필요 시 **Fast Field Updates(before-save)** 로 최적화 편집 가능 |
| **Invoke flow 액션** | **subflow 요소**로 마이그레이션(부모 flow와 같은 트랜잭션). 외부 콜아웃·external action·pause를 포함하면 **비동기 경로(async path)로 재설계** 필요 |
| **Scheduled actions** | 연결된 **단일 criteria를 선택할 때만** 마이그레이션(복수 criteria 선택 시 scheduled action은 마이그레이션 안 됨). 변환 후 Flow의 **scheduled path**(`ScheduledPath__#` 명명)가 됨 |
| **Cross-object formula 참조** | 마이그레이션 **불가** |
| **Custom metadata formula 참조** | 마이그레이션 가능하나 마이그레이션 후 resource picker로 구성 불가 |
| **Time-based process** | 각 outcome을 **자체 scheduled action flow로 개별 마이그레이션** 후 새 flow를 활성화하고 프로세스를 비활성화 |

> Workflow Rule 자체의 마이그레이션 지원/미지원 항목은 위 "## Migrate to Flow 도구" 및 아래 표 참조. Flow의 트리거·before/after-save 개념은 [[Record-Triggered Flow]] 참조.

---

## 구조 개요

```
// 구조 예시 — Workflow Rules & Migrate(실제 동작 코드 아님)
Workflow Rule(레거시): 레코드 생성/편집 → 규칙 평가 → 액션
   액션: Email Alert · Field Update(같은 레코드) · Task · Outbound Message · Time-Dependent
⚠️ 은퇴 중 → Migrate to Flow 도구로 변환 (트리거 flow가 더 빠름)
   Email Alert 재사용: Process Automation → Workflow Actions
```

---

## 관련 노트
- [[Flow — 선언적 자동화 개요 (플로우)]] — 이전 대상·신규 자동화 표준
- [[Record-Triggered Flow]] — 마이그레이션 결과물(트리거 flow)·before/after-save 개념
- [[Email Alerts, Templates & Auto-Response Rules (이메일 알림·템플릿·자동 응답)]] — 공유되는 Email Alert 액션
- [[Approval Process (승인 프로세스)]] — 같은 액션 타입(Email Alert·Field Update·Outbound) 공유
