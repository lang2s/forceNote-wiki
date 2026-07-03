---
tags: [service-cloud, assignment-rules, escalation-rules, case-routing, automation]
source: help.salesforce.com (Salesforce Help — Service; Case Assignment / Set Up Escalation Rules; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
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

## 관련 노트
- [[Service Cloud 개요]] — Service Cloud 시리즈 허브
- [[Cases (케이스)]] — 배정·에스컬레이션 대상
- [[Queues (큐)]] — 배정 대상 큐
- [[Business Hours & Holidays (영업 시간·휴일)]] — escalation 경과 시간 계산 기준(영업 시간)·holiday 중단
