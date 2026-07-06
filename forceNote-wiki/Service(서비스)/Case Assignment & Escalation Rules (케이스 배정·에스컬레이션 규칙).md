---
tags: [service-cloud, assignment-rules, escalation-rules, case-routing, automation]
source: help.salesforce.com (Salesforce Help — Service; Case Assignment / Set Up Escalation Rules; 라이브 공식 문서, Tier 2, 접속 2026-07-03) + service_presence_administrators.pdf (Omni-Channel for Administrators — Route Work with Omni-Channel·Set Up Queues, Tier 2)
official_doc: https://help.salesforce.com/s/articleView?id=service.rules_escalation_create.htm&type=5
created: 2026-07-03
aliases: [Case Assignment Rules, Escalation Rules, 케이스 배정 규칙, 에스컬레이션 규칙, 케이스 라우팅]
---

# Case Assignment & Escalation Rules (케이스 배정·에스컬레이션 규칙)

> **Assignment Rule**은 들어온 case를 조건에 따라 사용자·큐에 자동 배정하고, **Escalation Rule**은 시간·기준 미충족 시 case를 상위로 에스컬레이션(재배정·알림)한다.

---

## Case Assignment Rules (케이스 배정 규칙)

새로 생성된 case를 조건(criteria)에 따라 **사용자 또는 큐(queue)에 자동 배정**한다.

- 규칙은 순서대로 평가되는 **rule entry**(조건 → 배정 대상)로 구성된다. 각 entry는 "이 조건에 맞으면 이 사용자/큐로 보낸다"를 정의한다.
- rule entry는 **정의된 순서대로 평가**되며, 조건이 매칭되는 첫 entry가 배정 대상을 결정한다.
- 배정 대상은 **개별 사용자** 또는 **큐** 중 하나다.

## Case Escalation Rules (케이스 에스컬레이션 규칙)

정해진 시간/기준 안에 처리되지 않은 case를 **에스컬레이션**한다.

- escalation action으로 case를 **재배정하거나 이메일 알림**을 보낸다.
- **business hours(영업 시간)** 기준으로 경과 시간을 계산할 수 있다 — 실제 근무 시간만을 기준으로 에스컬레이션 타이밍을 산정한다.

## 공통 규칙 구조

두 규칙 모두 오브젝트당 **활성 규칙은 하나**이며, 하나의 활성 규칙이 여러 rule entry를 가진다.

> assignment·auto-response·escalation에는 각각 한도(rule/entry 수 등)가 적용된다. 세부 한도 수치는 공식 문서를 참조한다 → [official_doc](https://help.salesforce.com/s/articleView?id=service.rules_escalation_create.htm&type=5).

## 규칙 흐름

```
// 구조 예시 — Case Assignment & Escalation(실제 원본 다이어그램 아님)
Case 생성 → Assignment Rule(rule entry 순서 평가)
              조건 매칭 → 사용자 or Queue 배정
시간 경과(business hours) 미해결 → Escalation Rule
              action: 재배정 · 이메일 알림
오브젝트당 활성 규칙 1개(여러 entry)
```

## Omni-Channel 라우팅과의 관계 — 실행 순서·조합·이중 라우팅 주의

> 라우팅 구성(Routing Configuration) 필드·라우팅 모델·Omni-Channel Flow 자체의 상세는 [[Omni-Channel 라우팅 유형 — Queue 기반 vs Skills 기반]] 소관 — 여기서는 **Assignment Rule과의 실행 순서·조합 규칙**만 다룬다. (`service_presence_administrators.pdf`, Tier 2)

### 실행 순서 — Assignment Rule이 먼저, Omni-Channel은 큐에서 이어받는다

두 기능은 경쟁하는 것이 아니라 **체인으로 연결**된다. Assignment Rule은 "어느 큐로 넣을지"를, Omni-Channel은 "그 큐에서 어느 에이전트에게 push할지"를 담당한다.

```
// 구조 예시 — 실제 원본 다이어그램 아님
Case 생성 (Email-to-Case / Web-to-Case / 수동+배정 체크박스)
  → ① Case Assignment Rule: rule entry 순서 평가 → 조건 매칭된 Queue에 배정
  → ② 그 Queue에 Routing Configuration이 연결돼 있으면
       work item이 Omni-Channel 라우팅 대기 목록에 추가됨
  → ③ Omni-Channel이 가용·capacity 있는 큐 멤버 에이전트에게 push
       (Routing Configuration 없는 큐 = Omni가 라우팅 안 함 → 클래식 수동 pull 큐)
```

> PDF 원문 (Set Up Queues): *"an assignment rule can add cases or leads to a queue based on specific record criteria. Records remain in a queue until they're assigned an owner."* — Create Queues 절차 마지막 단계(10)도 *"If you want, set up assignment rules for your lead or case queues so that records that meet certain criteria are automatically added to a queue."* 로, **Assignment Rule → Omni 큐**가 공식 조합 패턴이다.

**에이전트 수락 시점에 자동화 규칙은 다시 발화하지 않는다** — Omni-Channel이 work item을 라우팅해 에이전트가 수락하는 시점에는 assignment·auto-response·escalation·workflow rule이 **트리거되지 않는다**. 수락 후 에이전트가 레코드를 **편집·저장할 때** 트리거된다 (재배정 무한 루프 방지).

> PDF 원문: *"Automation rules, such as assignment, auto-response, escalation, and workflow rules, aren't triggered when Omni-Channel routes a work item to an agent and the agent accepts the work. When an agent accepts the work and then edits and saves the work item record, automation rules are triggered."*

### Omni-Channel Flow 사용 시 — Assignment Rule은 끈다 (자동 우회 아님)

Omni-Channel Flow를 지정해도 **Assignment Rule이 자동으로 우회되지 않는다** — 둘 다 켜 두면 각자 라우팅을 시도한다. 그래서 공식 문서는 Email-to-Case에 Omni-Channel flow를 쓸 때 **다른 case assignment rule 사용을 피하라**고 명시한다.

> PDF 원문 (Assign an Omni-Channel Flow to Route Cases from Email-to-Case): *"If you use Email-to-Case, use an Omni-Channel flow rather than a record-triggered flow to direct cases to the right queue or agent. **Avoid using other case assignment rules** so that Email-to-Case routes cases using the logic in your Omni-Channel flow."*

- Email-to-Case 라우팅 주소(verified 필수)의 Flow Settings에 flow를 지정하고 **fallback queue**를 지정한다 — fallback queue는 Case service channel 객체를 쓰고 **Omni-Channel routing configuration이 연결**돼 있어야 한다. flow 실행 중 예외가 나면 case는 fallback queue로 라우팅된다.
- Email-to-Case 외의 non-real-time 객체(case·lead·custom object)는 Omni-Channel flow를 **record-triggered flow의 subflow로 invoke**해 라우팅한다.

### 조합 패턴 정리 (이중 라우팅 금지)

| 패턴 | 구성 | 언제 |
|---|---|---|
| **A. Assignment Rule → Omni 큐** | 규칙이 Routing Configuration 연결된 큐에 배정 → Omni가 push | 선언적 조건(rule entry)으로 큐 분류가 충분할 때 — 기본 조합 |
| **B. Omni-Channel Flow 단독** | E2C 라우팅 주소에 flow 지정(또는 record-triggered subflow), **assignment rule 미사용** | 동적 로직·skills·direct-to-agent가 필요할 때 (E2C에서는 공식 권장) |
| ⚠️ **둘 다 라우팅 (금지)** | Assignment Rule과 Omni flow가 같은 case를 각자 라우팅 | 규칙이 큐 A로, flow가 큐 B/에이전트로 보내며 충돌 — 공식 가이드가 "avoid" |

## 관련 노트
- [[Service Cloud 개요]] — Service Cloud 시리즈 허브
- [[Cases (케이스)]] — 배정·에스컬레이션 대상
- [[Queues (큐)]] — 배정 대상 큐 (Omni-Channel push의 대기 저장소)
- [[Omni-Channel 라우팅 유형 — Queue 기반 vs Skills 기반]] — Routing Configuration·라우팅 모델·Omni-Channel Flow 상세 (Assignment Rule이 넣은 큐에서 push하는 계층)
- [[Omni-Channel 객체·메타데이터·콘솔 컴포넌트]] — Omni-Channel 객체·콘솔 레퍼런스
- [[Business Hours & Holidays (영업 시간·휴일)]] — escalation 경과 시간 계산 기준(영업 시간)·holiday 중단
- [[Email Alerts, Templates & Auto-Response Rules (이메일 알림·템플릿·자동 응답)]] — 자동 배정 vs 자동 회신(케이스·리드 생성 시 함께 구성)
