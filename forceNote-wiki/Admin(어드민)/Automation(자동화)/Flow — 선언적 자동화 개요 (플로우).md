---
tags: [admin, automation, flow, flow-builder, declarative]
source: help.salesforce.com (Salesforce Help — Flow / Flow Builder; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=platform.flow.htm&type=5
created: 2026-07-03
aliases: [Flow, 플로우, Flow Builder, 플로우 빌더, Record-Triggered Flow, Screen Flow, Scheduled Flow, 선언적 자동화]
---

# Flow — 선언적 자동화 개요 (플로우)

> Flow Builder는 Salesforce의 **주력 선언적 자동화 도구**로, 은퇴 중인 Workflow Rules·Process Builder를 대체한다. 화면·트리거·스케줄 등 유형이 있고, 심층 내용은 기존 Flow 섹션에 있다.

---

## 어드민 관점 개요

Flow Builder는 코드 없이 point-and-click으로 자동화를 구성하는 도구다. Salesforce는 **Workflow Rules와 Process Builder를 은퇴시키고 Flow로 통합**하는 중이므로, 새로 만드는 선언적 자동화는 원칙적으로 Flow로 구축한다.

어드민이 알아야 할 핵심은 "어떤 유형의 Flow를 언제 쓰는가"이며, 각 요소·설계 심층은 이 노트에서 다시 설명하지 않고 Flow 섹션으로 위임한다(중복 방지).

## 주요 Flow 유형 (개요)

| 유형 | 실행 계기 |
|---|---|
| **Screen Flow** | 사용자를 안내하는 화면 UI 흐름 |
| **Record-Triggered Flow** | 레코드 생성/수정/삭제 시 실행(before/after save) |
| **Schedule-Triggered Flow** | 예약 실행(배치) |
| **Autolaunched Flow** | 트리거 없이 Apex·다른 flow·프로세스가 호출 |
| **Platform Event-Triggered Flow** | 플랫폼 이벤트로 실행 |

## 구성 요소 (개요)

레코드 생성·수정·삭제, 결정(Decision), 루프(Loop), 할당(Assignment), subflow, 액션(이메일 발송·Apex 호출 등)으로 흐름을 조립한다.

```
// 구조 예시 — Flow 유형(실제 동작 코드 아님)
Flow Builder(선언적, Workflow·Process Builder 대체)
  Screen Flow(화면) · Record-Triggered(레코드 이벤트) · Schedule-Triggered(예약)
  · Autolaunched(호출됨) · Platform Event-Triggered
  요소: 생성/수정/삭제 · Decision · Loop · Assignment · Subflow · Action
심층 → [[Flow MOC]]
```

> ⚠️ Flow 요소·유형·설계의 심층 내용은 이 노트에서 재서술하지 않는다. 자세한 내용은 **[[Flow MOC]]** 및 `Flow/` 섹션을 참조한다.

## 관련 노트

- [[Flow MOC]] — Flow 섹션 전체 목차(심층)
- [[Workflow Rules & Migrate to Flow (워크플로 규칙·플로우 이전)]] — Flow로 대체되는 레거시
- [[Approval Process (승인 프로세스)]] — Flow Approval Processes 현대 대안
- [[Organization-Wide Email Addresses & Deliverability (조직 전체 이메일·전달성)]] — Send Email 액션의 발신 주소·전달성 의존
