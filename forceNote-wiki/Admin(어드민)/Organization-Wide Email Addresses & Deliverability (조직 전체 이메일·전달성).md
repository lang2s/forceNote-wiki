---
tags: [admin, email, org-wide-email, deliverability, email-verification]
source: help.salesforce.com (Salesforce Help — Organization-Wide Email Addresses / Email Deliverability; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=sales.orgwide_email.htm&type=5
created: 2026-07-03
aliases: [Organization-Wide Email Addresses, 조직 전체 이메일 주소, Email Deliverability, 이메일 전달성, Access to Send Email, Email Verification]
---

# Organization-Wide Email Addresses & Deliverability (조직 전체 이메일·전달성)

> **Org-Wide Email Address**로 사용자가 개인 주소 대신 공통 주소(예: support@회사.com)로 발신하게 하고, **Deliverability**로 조직의 이메일 발송 허용 수준을 제어한다. 발송에는 도메인·사용자 수준 인증이 필요하다.

---

## Organization-Wide Email Address (조직 전체 이메일 주소)

특정 프로파일에 속한 사용자가 자신의 **개인 이메일 주소** 대신 **공통 발신 주소**로 이메일을 보내게 한다. 예를 들어 지원팀 사용자 전원이 개별 주소가 아니라 `support@회사.com` 같은 하나의 주소로 발신하도록 통일할 수 있다.

- 설정 위치: **Setup → Email → Organization-Wide Email Addresses**
- 사용 전에 해당 주소에 대한 **인증(verification)** 이 필요하다. 인증을 마치기 전에는 발신 주소로 사용할 수 없다.
- **Scheduled-Triggered flow**의 **Send Email** 액션은 이렇게 Setup에서 구성한 org-wide email address를 발신 주소로 사용한다.

## Email Deliverability (이메일 전달성)

조직이 보낼 수 있는 이메일의 허용 수준을 관리한다.

- 설정 위치: **Setup → Deliverability → Access to Send Email**
- **Access to Send Email** 값 — 세 단계 중 선택:
  - **No access** — 이메일 발송 없음
  - **System email only** — 시스템 이메일만 발송
  - **All email** — 모든 이메일 발송
- 이메일 발송에는 **도메인 수준 인증 + 사용자 수준 이메일 인증**이 모두 필요하다.
- 사용자 이메일 주소나 발송 도메인이 **미인증 상태이면 이메일 전달이 실패**한다.
- flow 등에서 이메일을 보내기 전에 **Access to Send Email이 "All email"인지 확인**한다.

## 설정 흐름 요약

```
// 구조 예시 — Org-Wide Email & Deliverability(실제 동작 코드 아님)
Setup → Email → Organization-Wide Email Addresses: 공통 발신 주소(인증 필요)
Setup → Deliverability → Access to Send Email:
   No access | System email only | All email
발송 요건: 도메인 수준 + 사용자 수준 인증 (미인증 → 전달 실패)
```

## 관련 노트
- [[Email Alerts, Templates & Auto-Response Rules (이메일 알림·템플릿·자동 응답)]] — 발신되는 이메일 자동화. org-wide 주소·전달성 설정에 의존.
- [[Flow — 선언적 자동화 개요 (플로우)]] — Send Email 액션이 org-wide 주소·전달성에 의존.
