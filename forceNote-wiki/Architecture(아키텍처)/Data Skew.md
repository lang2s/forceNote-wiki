---
tags: [architecture, data-skew, large-data-volumes, performance, record-locking, sharing]
source: salesforce_large_data_volumes_bp.pdf (Best Practices for Deployments with Large Data Volumes, Spring '26, Tier 2)
created: 2026-06-14
aliases: [Data Skew, 데이터 스큐, Account Data Skew, Ownership Skew, Lookup Skew, 소유권 스큐, 레코드 잠금, parent record-locking]
---

# Data Skew (데이터 스큐)

> 소수의 부모 레코드·소유자·조회 대상에 자식 레코드가 과도하게 몰려, **레코드 잠금 충돌**과 **공유 재계산 비용**을 유발하는 LDV(대용량 데이터) 안티패턴. 공식 권고는 **"한 부모당 자식 1만 건 / 한 사용자당 소유 1만 건 초과 금지"**.

---

## 데이터 스큐란

대용량 데이터(LDV)에서 데이터가 **고르게 분산되지 않고 소수 레코드에 집중**되면, 그 레코드를 건드리는 작업이 잠금·공유 계산 측면에서 병목이 된다. Salesforce LDV 가이드는 두 가지 임계값을 명시한다.

| 유형 | 임계값 (공식 권고) | 영향 |
|---|---|---|
| **Account Data Skew** (부모-자식 편중) | 한 부모 레코드당 자식 **10,000건 초과 금지** | 부모 레코드 잠금(record-locking) 충돌, 관련 목록 렌더링 지연 |
| **Ownership Skew** (소유권 편중) | 한 사용자가 **10,000건 초과 소유 금지** | 공유 재계산(sharing recalculation) 시간 폭증 |

> [!note] **Lookup Skew**(조회 편중)는 흔히 언급되는 세 번째 스큐 유형으로, 하나의 lookup 대상 값에 너무 많은 레코드가 연결될 때 동일한 레코드 잠금 메커니즘으로 경합이 발생한다. **단, 이 LDV 가이드는 lookup skew를 별도 항목·임계값으로 명시하지 않는다** — 아래 "부모 레코드 잠금" 원리가 lookup 관계에도 동일하게 적용된다는 점으로 이해한다.

---

## 왜 문제가 되나 — 두 메커니즘

### 1) 부모 레코드 잠금 (Parent Record-Locking)

자식 레코드를 생성·수정할 때 Salesforce는 부모 레코드에 잠금을 건다. 한 부모에 자식이 몰려 있으면(account data skew), 여러 트랜잭션이 같은 부모를 잠그려 경합해 **잠금 충돌·롤백**이 발생한다.

**완화:** 자식 레코드를 **부모(ParentId) 기준으로 묶어 같은 배치에 넣는다.** 그러면 동일 부모에 대한 동시 잠금 시도가 줄어든다.

```apex
// 구조 예시 — LDV 가이드 "group records by ParentId in the same batch" 원리를 코드로 표현 (PDF 원문 코드 아님)
// 자식 레코드를 부모 기준으로 정렬·그룹핑해 같은 배치에 모음 → 부모 레코드 잠금 충돌 최소화
List<Invoice__c> toInsert = getInvoicesToLoad();
toInsert.sort(new ByParentComparator());   // ParentId(Account__c)로 정렬

// 데이터 로더/Bulk API 사용 시: 같은 부모의 자식이 서로 다른 동시 배치로 흩어지지 않게
// ParentId 기준으로 정렬된 상태로 적재하고, 배치를 순차(serial) 모드로 실행
Database.insert(toInsert, false);
```

### 2) 공유 재계산 (Sharing Recalculation)

한 사용자가 레코드를 과도하게 소유하면(ownership skew), 역할 계층·공유 규칙 변경 시 그 사용자 관련 공유를 재계산하는 비용이 급증해 **매우 긴 평가 시간이나 타임아웃**을 유발한다.

**완화 — Defer Sharing Calculation:** 관리자는 *defer sharing calculation* 권한으로 공유 계산을 **일시중지/재개**할 수 있고, 두 프로세스를 관리한다.

- **그룹 멤버십 계산 (group membership calculation)**
- **공유 규칙 계산 (sharing rule calculation)**

대량 구성 변경을 업무 시간에 빠르게 처리하고, **재계산은 야간·주말 유지보수 시간에** 돌리도록 미룬다.

---

## 케이스 스터디 — 관련 목록 렌더링 지연 (Tier 2)

**상황:** 수십만 개 Account + **1,500만 개 Invoice**(custom object, Account와 master-detail). 대부분 계정은 자식이 적었지만 **일부 계정에 수천 개**가 몰려 있어, 계정 상세 페이지의 Invoices 관련 목록 렌더링이 매우 느렸다.

**원인:** data skew — 소수 부모에 자식 과집중.

**해결:**
1. 해당 부모들의 자식 레코드 수를 줄여 **데이터 스큐를 최소화**.
2. **Enable Separate Loading of Related Lists** 설정으로, 관련 목록 쿼리가 끝나길 기다리는 동안 계정 상세부터 먼저 렌더링.

---

## 모범 사례 요약

| 목표 | 권고 (LDV 가이드) |
|---|---|
| 공유 계산 회피 | 한 사용자가 **10,000건 초과 소유하지 않게** 한다 |
| 배포 효율 | 자식 레코드를 분산해 **한 부모당 10,000건 초과하지 않게** 한다. (예: Account를 안 쓰는데 Contact가 많으면, 더미 Account 여러 개를 만들어 분산) |
| 부모 잠금 충돌 최소화 | 자식 레코드를 **ParentId로 묶어 같은 배치**에 적재 |
| 대량 공유 변경 | **defer sharing calculation**으로 미뤘다가 유지보수 시간에 재계산 |
| 다수 자식 삭제 | **자식을 먼저 삭제**한 뒤 부모 삭제 |

---

## 관련 노트

- [[레코드 액세스 설계 (Enterprise Scale)]] — 공유 재계산·그룹 멤버십·implicit sharing 심화 (본 노트와 짝)
- [[대용량 데이터 (LDV) — 쿼리 옵티마이저·인덱싱]] — 동일 LDV 백서 읽기 경로 짝 노트(옵티마이저·인덱스·SOQL); skew 메커니즘을 본 노트에 위임
- [[대용량 데이터 (LDV) — 대량 로드·삭제]] — 동일 LDV 백서 쓰기 경로 짝 노트(Bulk 로드·삭제·defer sharing); skew·재계산 메커니즘을 본 노트에 위임
- [[Object Relationships]] — master-detail / lookup 관계 (스큐의 구조적 원인)
- [[Permission Set 설계]] — 공유·접근 모델 (ownership skew의 공유 재계산 맥락)
- [[Governor Limits]] — 대량 처리 한도
- [[Batch Apex]] — 대량 적재 시 배치 그룹핑 전략
- [[Salesforce 플랫폼 개요]] — 멀티테넌트·메타데이터 아키텍처
