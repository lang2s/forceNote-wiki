---
tags: [architecture, record-access, sharing, security, performance, group-membership, implicit-sharing]
source: draes.pdf (Designing Record Access for Enterprise Scale, Salesforce Spring '26, Tier 2)
official_doc: https://developer.salesforce.com/docs/atlas.en-us.draes.meta/draes/
created: 2026-06-14
aliases: [Record Access, 레코드 액세스 설계, Sharing Recalculation, 공유 재계산, Group Membership, Implicit Sharing, 암시적 공유, Ownership Data Skew, Group Membership Locking]
---

# 레코드 액세스 설계 (Enterprise Scale)

> 역할 계층·그룹·공유 규칙 변경이 일으키는 **공유 재계산(sharing recalculation)** 비용과, 그것을 키우는 함정(ownership skew·parent-child skew·암시적 공유)을 다루는 공식 아키텍처 가이드. 대규모 조직 재편(realignment) 성능 최적화용.

> [!note] 공식 가이드 *Designing Record Access for Enterprise Scale* (Spring '26) 발췌. 복잡한 접근 요구사항·대규모 영업 조직 재편을 다루는 아키텍트 대상이지만, 공유 모범 사례는 모든 규모에 적용된다. 내부 동작은 *Record-Level Access: Under the Hood* 참고.

---

## 그룹 멤버십 변경 → 공유 재계산

역할 계층(role hierarchy)·공개 그룹(public group)·테리토리(territory)는 공유 규칙·보안 기능과 긴밀히 얽혀 있다. 그래서 **겉보기엔 단순한 그룹/멤버십 변경이 대규모 접근 권한 재계산**을 유발할 수 있다.

예) 관리자가 사용자를 계층의 다른 가지로 **이동**하면 Salesforce가 수행하는 작업:
- 사용자가 새 역할에서 데이터를 소유한 첫 멤버면 → 새/옛 역할 **상위 사용자들의 접근 추가/제거**
- 사용자가 고객·파트너 계정을 소유하면 → 자식 고객·파트너 계정 역할을 옛 역할에서 제거하고 새 역할 자식으로 추가 (**소유한 계정마다** 수행)
- **암시적 공유(implicit share)** 조정
- 사용자의 옛/새 역할을 source group으로 쓰는 **모든 공유 규칙 재계산**

---

## Ownership Data Skew (소유권 데이터 스큐)

> **한 사용자가 한 오브젝트의 레코드를 10,000건 초과 소유**하면 ownership data skew. 미할당 리드를 더미 사용자에게 몰아주는 패턴 등에서 흔히 발생.

문제: 그 사용자를 계층에서 이동하거나, 공유 규칙 source group인 역할/그룹에 넣고 빼면 → **공유 테이블의 막대한 항목을 조정**해야 해 장시간 재계산 발생.

**완화책:**
- 소유권을 **여러 사용자에 분산** (가장 권장)
- 소수에 집중해야 한다면 → 그 사용자에게 **역할(role)을 부여하지 않는다**
- 역할이 꼭 필요하면 → **계층 최상단의 별도 역할**에 배치 (단, 이 사용자는 하위 모든 데이터 접근을 상속)

```apex
// 구조 예시 — ownership skew 진단 SOQL (PDF 원문 아님, 점검용)
// 한 오브젝트에서 사용자별 소유 건수를 집계해 10,000 초과 소유자 탐지
SELECT OwnerId, COUNT(Id) ownedCount
FROM Lead
GROUP BY OwnerId
HAVING COUNT(Id) > 10000
```

---

## Group Membership Locking (그룹 멤버십 잠금)

그룹 멤버십 연산은 서로 충돌할 수 있어, **동시에 실행 가능한 조합이 정해져 있다.** (가이드에 연산별 동시 실행 가능표 제공) 예: "고객·파트너 계정을 소유하지 않은 사용자의 역할 변경"은 role insertion·territory insertion·user provisioning과 동시 가능.

→ 대규모 멤버십 작업 전, 어떤 연산이 직렬화되는지 이해하고 **풀 카피 샌드박스(최근 리프레시)에서 테스트**한다.

### Takeaway — 그룹 멤버십 성능 튜닝
- 복잡한 업데이트(역할 변경·계정 소유권 변경·대량 연관 데이터)는 **추가 시간** 확보
- 계층 변경 시 **leaf(말단) 노드부터 → 상위로** 처리(중복 처리 회피)
- **사용자당 오브젝트 레코드 10,000건 이하**로 제한
- 배치 크기 실험 + **Bulk API** 활용
- 계층으로 이미 접근 가능한데 또 주는 **중복 접근 경로(redundant sharing rule) 제거**
- 대규모 그룹 작업은 **off-peak 시간**에 + **serial mode**로

---

## 암시적 공유 (Implicit Sharing)

명시적으로 부여하는 공유(공유 규칙 등) 외에, Salesforce가 **시스템이 정의·유지하는 내장 공유**가 있다 — 영업팀·서비스 담당·고객 간 협업을 위해. 추가 역할·그룹·규칙 없이 흔한 접근 케이스를 처리한다.

| 유형 | 제공 |
|---|---|
| **Parent** | 자식(case/contact/opportunity)에 접근 권한이 있는 사용자에게 **부모 계정 읽기 전용** 접근 (자식 접근이 부모로 제어될 때는 미사용) |
| (그 외) | 가이드의 Implicit Sharing 표 참고 — child, portal/community 등 |

> [!note] 편리하지만, ownership skew처럼 일부 **parent-child 구성은 대량 로드·업데이트(때로 단건 작업)의 성능을 떨어뜨린다**(Parent-Child Data Skew). [[Data Skew]] 참고.

---

## Record-Level Locking (레코드 수준 잠금)

대량 업로드·실시간/배치 통합에서 데이터 무결성을 위해 Salesforce는 **레코드 수준 DB 잠금**을 건다. parent-child 편중 시 같은 부모에 대한 잠금 경합이 성능을 떨어뜨린다.

→ 완화: 자식 레코드를 **ParentId 기준 배치 그룹핑**, serial 모드. ([[Data Skew]]의 "부모 레코드 잠금" 참고)

---

## 대규모 재편 도구 — Deferred Sharing Calculations

대규모 그룹/공유 변경 시, **공유 계산을 유예(defer)**했다가 유지보수 시간에 일괄 재계산할 수 있다. 관리자가 group membership calculation·sharing rule calculation을 일시중지/재개해, 업무 시간엔 구성 변경만 빠르게 처리하고 재계산은 야간·주말에 돌린다.

---

## 빠른 체크리스트 (대규모 공유 변경 전)

- [ ] 사용자당 소유 ≤ 10,000건 (ownership skew 회피)
- [ ] 부모당 자식 ≤ 10,000건 (parent-child skew 회피)
- [ ] 계층 변경은 leaf → 상위 순서
- [ ] 중복 공유 규칙(계층으로 이미 접근 가능) 제거
- [ ] 대규모 작업은 off-peak + serial mode + Bulk API
- [ ] Defer Sharing Calculation으로 재계산 유예
- [ ] 풀 카피 샌드박스에서 사전 테스트

---

## 관련 노트

- 📖 공식: [Designing Record Access for Enterprise Scale](https://developer.salesforce.com/docs/atlas.en-us.draes.meta/draes/)
- [[조직 전체 공유 기본값(OWD)과 공유 규칙]] — OWD·공유 규칙의 선언적 설정 방법(본 노트의 설정 짝; 이 노트는 그 변경이 유발하는 재계산 성능을 다룸)
- [[Data Skew]] — account/ownership/parent-child skew·record-locking·defer sharing (본 노트와 짝)
- [[대용량 데이터 (LDV) — 대량 로드·삭제]] — 대량 로드 시 순차 적재·defer sharing으로 공유 재계산 부하 관리
- [[Permission Set 설계]] — 명시적 접근 권한 부여
- [[Scoping Rules]] — 접근 권한은 그대로 두고 사용자가 기본으로 보는 레코드만 좁힘(sharing이 접근을 확대/제한하는 것과 직교)
- [[Object Relationships]] — master-detail/lookup이 implicit sharing·skew에 미치는 영향
- [[Salesforce 플랫폼 개요]] — 보안·공유 모델 개요
- [[Governor Limits]] — 대량 처리 한도
