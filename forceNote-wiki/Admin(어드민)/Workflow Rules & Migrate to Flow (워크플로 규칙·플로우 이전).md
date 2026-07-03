---
tags: [admin, automation, workflow-rules, migrate-to-flow, legacy]
source: help.salesforce.com (Salesforce Help — Workflow Rules / Migrate to Flow Tool Considerations; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=platform.migrate_to_flow_tool_considerations.htm&type=5
created: 2026-07-03
aliases: [Workflow Rules, 워크플로 규칙, Migrate to Flow, 플로우 이전, Legacy Automation, Time-Dependent Action]
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
- [[Email Alerts, Templates & Auto-Response Rules (이메일 알림·템플릿·자동 응답)]] — 공유되는 Email Alert 액션
- [[Approval Process (승인 프로세스)]] — 같은 액션 타입(Email Alert·Field Update·Outbound) 공유
