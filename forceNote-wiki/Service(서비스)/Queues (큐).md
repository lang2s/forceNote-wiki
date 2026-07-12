---
tags: [service-cloud, queues, work-distribution, case-routing]
source: help.salesforce.com (Salesforce Help — Service; Set Up Queues; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=service.queues_overview.htm&type=5
created: 2026-07-03
aliases: [Queues, 큐, 대기열, Case Queue, Work Distribution, Omni-Channel Queue]
---

# Queues (큐)

> **Queue**는 lead·case·contact request·커스텀 오브젝트 레코드를 팀이 공유·처리하도록 담아두는 클래식 요소. 팀이 워크로드를 나눠 우선순위화·배정하며, Omni-Channel이 실시간 라우팅으로 이를 강화한다.

---

## 개념 — Queue란

Queue는 팀이 함께 처리할 레코드를 담아두는 **클래식(classic) 요소**다. 다음 오브젝트를 관리하는 데 사용한다.

- **Lead** (리드)
- **Case** (케이스)
- **Contact request** (고객 연락 요청)
- **Custom object** 레코드 (커스텀 오브젝트)

워크로드를 공유하는 팀에 레코드를 담아두고, 팀이 이를 **우선순위화(prioritize)** 하고 **배정(assign)** 한다. 큐에 들어온 레코드는 팀원이 소유권을 가져가 처리하기 전까지 큐가 임시로 "소유"하는 형태로 대기한다.

### 핵심 특성

| 항목 | 내용 |
|---|---|
| 생성 개수 | **제한 없음** — 필요한 만큼 큐를 만들 수 있다 |
| 멤버 | 큐를 처리하는 사용자·역할·그룹 등 (예: service level이 서로 다른 support rep) |
| 이메일 알림 | 큐 멤버가 **알림을 언제 받을지 선택**할 수 있다 |
| 처리 방식 | 멤버가 수동으로 항목을 가져가거나(pull), Omni-Channel이 실시간으로 밀어 넣는다(push) |

---

## 큐의 동작 구조

```
// 구조 예시 — Queue(실제 원본 다이어그램 아님)
레코드(Case/Lead/Contact Request/Custom) → Queue(팀 공유)
   멤버(예: service level별 support rep) · 이메일 알림 시점 선택
   수동 pull  또는  Omni-Channel 실시간 push 라우팅
   개수 제한 없음
```

레코드가 큐에 배정되면 큐 멤버 전원이 그 레코드를 볼 수 있고, 처리할 준비가 된 멤버가 소유권을 가져간다.

---

## 큐 유형 (예시)

문서가 제시하는 대표 예시는 다음과 같다.

- **Case queue** — 서로 다른 service level의 support rep들이 멤버로 참여하는 케이스 큐.
- **Contact request queue** — 고객 이슈를 해결하는 support rep들이 멤버로 참여하는 고객 연락 요청 큐.

> 위는 문서가 "예시"로 든 큐 형태이며, 큐로 관리 가능한 대상은 위 "개념" 섹션의 오브젝트(lead·case·contact request·custom object) 전체다.

---

## Omni-Channel 연동

Omni-Channel은 큐를 **강화(enhance)** 한다. 큐에 들어온 **work item을 서비스 rep에게 실시간으로 라우팅**하므로, rep가 큐를 열어 항목을 **수동으로 고를 필요가 없다**. 큐가 "대기 저장소"라면 Omni-Channel은 그 저장소에서 적합한 rep에게 자동으로 항목을 밀어주는 실시간 배분 계층이다.

---

## 관련 노트
- [[Service Cloud 개요]] — Service Cloud 시리즈 허브
- [[Cases (케이스)]] — 큐에 담기는 대상
- [[Case Assignment & Escalation Rules (케이스 배정·에스컬레이션 규칙)]] — 큐로 배정하는 규칙
- [[Public Groups (공개 그룹)]] — 겹치는 "사용자 묶음"이나 큐만 레코드 소유·배정, 그룹은 공유 전용 (Public Group vs Queue 비교)
