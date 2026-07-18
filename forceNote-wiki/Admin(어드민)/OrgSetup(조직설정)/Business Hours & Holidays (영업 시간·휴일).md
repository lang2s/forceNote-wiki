---
tags: [admin, org-setup, business-hours, holidays, escalation]
source: help.salesforce.com (Salesforce Help — Set Business Hours / Set Up Support Holidays; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=service.customize_supporthours.htm&type=5
created: 2026-07-03
aliases: [Business Hours, 영업 시간, Holidays, 휴일, Support Hours, Escalation]
---

# Business Hours & Holidays (영업 시간·휴일)

> **Business Hours**는 지원팀이 고객을 도울 수 있는 시간을 정의하고, **Holidays**는 팀이 쉬는 날짜·시간을 지정한다. 두 설정은 case escalation rule의 경과 시간 계산에 쓰인다.

---

## Business Hours (영업 시간)

지원팀이 고객을 도울 수 있는 시간을 정의한다. 지원 프로세스를 더 정확하게 만들며, **escalation rule**이 이 영업 시간을 기준으로 경과 시간을 계산한다 — 즉 실제 근무 시간만을 기준으로 에스컬레이션 타이밍이 산정된다.

- **설정 경로:** Setup → Quick Find에 `Business Hours` 입력 → **Business Hours**.

## Holidays (휴일)

지원팀이 **불가한(도움을 줄 수 없는) 날짜·시간**을 지정한다. holiday를 만든 뒤 **business hours에 연결(associate)** 하면, 그 holiday 날짜·시간 동안 **business hours와 연결된 escalation rule이 중단(suspend)** 된다.

- **설정 경로:** Setup → Quick Find에 `Holidays` 입력 → **Holidays** → **New**.
  - 지난 holiday를 기준으로 새로 만들 때는 해당 holiday 옆 **Clone**을 사용한다.

## 두 설정의 관계

Holiday는 단독으로 동작하지 않는다. **business hours에 연결되어야** escalation 흐름에 반영된다. 연결된 holiday의 날짜·시간 동안에는 business hours가 적용되지 않으므로, 그 business hours를 사용하는 escalation rule의 경과 시간 계산이 중단된다.

```
// 구조 예시 — Business Hours & Holidays(실제 원본 다이어그램 아님)
Business Hours(지원 가능 시간) ── escalation rule 경과시간 계산 기준
   └ Holiday 연결 → 그 날짜·시간 동안 business hours + escalation rule 중단(suspend)
```

## 관련 노트
- [[Case Assignment & Escalation Rules (케이스 배정·에스컬레이션 규칙)]] — business hours 기준으로 case 에스컬레이션
