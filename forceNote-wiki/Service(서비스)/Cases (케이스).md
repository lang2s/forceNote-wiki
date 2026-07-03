---
tags: [service-cloud, cases, case-management, support]
source: help.salesforce.com (Salesforce Help — Service; What's a Case? / Set Up and Manage Cases in Service Cloud; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=service.cases_def.htm&type=5
created: 2026-07-03
aliases: [Cases, 케이스, Case, Case Management, 케이스 관리, 지원 요청]
---

# Cases (케이스)

> **Case**는 고객의 질문·피드백·이슈를 담는 Service Cloud 핵심 오브젝트. 서비스 담당자(rep)가 case로 고객과 상호작용하며, 여러 채널로 생성되고 규칙·큐·Omni-Channel로 라우팅된다.

---

## Case란 무엇인가

**Case**는 고객의 **질문(question)·피드백(feedback)·이슈(issue)** 를 담는 레코드다. 서비스 담당자(support rep)는 case를 사용해 고객과 상호작용하며 — 문의를 접수하고, 진행 상황을 추적하고, 해결까지 이끈다. Case는 Service Cloud에서 고객 지원 업무의 중심 단위다.

## 생성 채널

Case는 여러 채널을 통해 생성된다.

- **Email-to-Case** — 고객이 보낸 이메일이 자동으로 case로 전환
- **Web-to-Case** — 웹 폼 제출이 case로 접수
- **Chat** — 실시간 채팅 세션에서 case 생성
- **Messaging** — 메시징 채널(SMS 등)에서 case 생성
- **수동 생성** — rep가 콘솔에서 직접 case 생성

## 관리와 라우팅

Case는 생성 후 적절한 담당자에게 라우팅되고, 콘솔에서 처리되며, SLA로 추적된다.

- **라우팅:** Queue(큐), Assignment Rules / Escalation Rules, **Omni-Channel** 로 case를 담당자에게 배정
- **처리:** **Service Console** 에서 case를 작업
- **SLA 추적:** **Entitlements & Milestones** 로 서비스 수준 계약(SLA)을 추적

## Case Lifecycle

```
// 구조 예시 — Case Lifecycle(실제 원본 다이어그램 아님)
채널(Email/Web/Chat/Messaging/수동) → Case 생성
  Assignment Rules/Queue/Omni-Channel → 담당자 배정
  처리(Service Console + Knowledge + Macros)
  Escalation Rules(시간/기준) · Entitlements & Milestones(SLA)
  → 해결(Closed)
```

> 개요 노트입니다. Case 필드·상태 값·Case Feed·Case Team 등 세부 구성은 공식 문서(위 `official_doc`)를 참조하세요.

## 관련 노트
- [[Service Cloud 개요]] — Service Cloud 시리즈 허브
- [[Service Cloud Objects]] — Case 표준 오브젝트 레퍼런스
- [[Email-to-Case & Web-to-Case (이메일·웹 투 케이스)]] — case를 생성하는 채널
- [[Case Assignment & Escalation Rules (케이스 배정·에스컬레이션 규칙)]] — case 배정·에스컬레이션
