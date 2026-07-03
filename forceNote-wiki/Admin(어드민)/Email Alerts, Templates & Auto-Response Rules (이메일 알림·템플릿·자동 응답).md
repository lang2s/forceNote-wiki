---
tags: [admin, automation, email-alerts, email-templates, auto-response-rules]
source: help.salesforce.com (Salesforce Help — Email Alerts / Email Templates / Auto-Response Rules; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=platform.workflow_alerts.htm&type=5
created: 2026-07-03
aliases: [Email Alerts, 이메일 알림, Email Templates, 이메일 템플릿, Auto-Response Rules, 자동 응답 규칙, Merge Fields]
---

# Email Alerts, Templates & Auto-Response Rules (이메일 알림·템플릿·자동 응답)

> 자동화가 보내는 이메일의 3요소: **Email Alert**(재사용 이메일 발송 액션), **Email Template**(재사용 이메일 내용), **Auto-Response Rule**(레코드 속성 기반 자동 회신).

---

## 세 요소의 관계

Salesforce에서 "자동화가 이메일을 보낸다"는 동작은 세 가지 서로 다른 구성 요소의 조합이다. 하나는 **무엇을 보낼지(내용)**, 하나는 **어떻게 보내는 액션**, 하나는 **레코드 속성에 반응해 회신하는 규칙**이다.

```
// 구조 예시 — Email Alerts / Templates / Auto-Response(실제 원본 다이어그램 아님)
Email Template(내용, merge field) ──┐
                                    ├─▶ Email Alert(재사용 발송 액션)
Flow · 승인 · workflow rule ────────┘   (Process Automation → Workflow Actions)
Auto-Response Rule: lead/case 속성 → 자동 회신(Web/Email-to-Case)  ≠ assignment rule
```

- **Email Template**은 재사용 가능한 이메일 **내용**을 정의한다.
- **Email Alert**는 그 template을 지정 수신자에게 보내는 재사용 가능한 **발송 액션**이다.
- **Auto-Response Rule**은 lead·case의 **속성에 따라 자동으로 회신**을 보내는 별도 규칙이다.

---

## Email Alert (이메일 알림)

**Email Alert**는 지정한 **email template**을 사용해 지정 수신자에게 이메일을 보내는 **재사용 가능한 액션**이다.

- 구성 위치: **Process Automation → Workflow Actions**.
- 이 액션은 여러 자동화 도구가 **공유**해 호출한다:
  - **Flow**
  - **승인 프로세스(Approval Process)**
  - **(레거시) workflow rule**
- 즉 Email Alert 하나를 만들어 두면 Flow·승인·workflow rule 어디서든 동일한 발송 액션으로 재사용할 수 있다.

---

## Email Template (이메일 템플릿)

**Email Template**은 재사용 가능한 이메일 **내용**이다. **merge field**로 레코드 값을 본문에 삽입한다.

### 유형

| 유형 | 설명 |
|---|---|
| **Text** | 순수 텍스트 이메일 |
| **HTML (with letterhead)** | 레터헤드를 사용하는 HTML 이메일 |
| **Custom** | 레터헤드 없이 직접 구성하는 HTML 이메일 |
| **Visualforce** | Visualforce로 렌더링하는 이메일 |
| **Lightning** | Lightning 이메일 템플릿 |

### Merge Field

**merge field**는 template 안에서 레코드의 값(예: 수신자 이름, 케이스 번호 등)을 실제 값으로 치환하도록 삽입하는 자리표시자다.

---

## Auto-Response Rule (자동 응답 규칙)

**Auto-Response Rule**은 레코드 속성에 따라 **lead·case에 자동 이메일 회신**을 보낸다.

- 적용 채널: **Web-to-Lead**, **Web-to-Case**, **Email-to-Case**.
- 조건별로 **다른 template**과 **다른 발신자(sender)** 를 지정할 수 있다.
- 예: 특정 조건을 만족하는 case가 들어오면 그에 맞는 template으로 자동 회신.

> ⚠️ **assignment rule과는 별개다.** assignment rule은 레코드를 **배정**하는 규칙이고, auto-response rule은 **자동 회신**을 보내는 규칙이다. 둘을 혼동하지 않는다.

---

## 관련 노트
- [[Workflow Rules & Migrate to Flow (워크플로 규칙·플로우 이전)]] — Email Alert를 공유하는 자동화
- [[Approval Process (승인 프로세스)]] — Email Alert 액션 사용
- [[Case Assignment & Escalation Rules (케이스 배정·에스컬레이션 규칙)]] — 자동 회신 vs 자동 배정 구분
- [[Organization-Wide Email Addresses & Deliverability (조직 전체 이메일·전달성)]] — 발신 주소·전달성
