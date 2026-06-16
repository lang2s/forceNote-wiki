---
tags: [architecture, large-data-volumes, ldv, bulk-load, bulk-api, data-deletion, data-extraction, performance]
source: salesforce_large_data_volumes_bp.pdf (Best Practices for Deployments with Large Data Volumes, Spring '26, Tier 2)
created: 2026-06-17
aliases: [Large Data Volumes, LDV, 대용량 데이터, Bulk Load, 대량 로드, Bulk API 2.0, getUpdated, getDeleted, Soft Delete, Hard Delete, soft delete, 데이터 삭제, 수백만 건 삭제, 수백만 건 로드, mass delete, truncate, sandbox truncate, 휴지통 15일, 변경된 레코드만 추출, 순차 적재, defer sharing]
---

# 대용량 데이터 (LDV) — 대량 로드·삭제

> 대용량 데이터(LDV) 환경에서 **쓰기 경로**(API 대량 로드·데이터 추출·삭제)의 성능 모범 사례 — Bulk API 2.0, sharing 계산 연기(defer sharing), 순차 적재, soft/hard delete. 읽기 경로(쿼리 옵티마이저·인덱싱)는 [[대용량 데이터 (LDV) — 쿼리 옵티마이저·인덱싱]] 참조.

---

## 개요

데이터가 커질수록 **로드·업데이트·추출·삭제** 작업 시간이 늘어나며, 아키텍처·구성 방식에 따라 그 시간이 수 자릿수(orders of magnitude) 차이로 변한다. 성능 최적화 전략은 세 가지다.

- 스키마 변경·작업에 대한 산업 표준 관행을 따른다.
- **business rule·sharing 처리를 연기하거나 우회**한다.
- 작업에 가장 효율적인 연산을 선택한다.

이 노트의 범위(쓰기/볼륨 경로):
- API 대량 로드(Bulk API 2.0, 순차 적재, sharing 계산 회피)
- defer sharing calculation (로드 맥락 — 메커니즘은 [[Data Skew]])
- 데이터 추출(getUpdated/getDeleted, Bulk Query)
- 데이터 삭제(soft/hard delete, truncate)
- 쓰기 관련 케이스 스터디

읽기 경로(쿼리 옵티마이저·selectivity·인덱스·skinny table·Divisions·SOQL/SOSL 작성)는 → [[대용량 데이터 (LDV) — 쿼리 옵티마이저·인덱싱]]

> **Data Skew 위임:** "any user가 10,000 레코드 초과 소유 회피"·"parent당 10,000 child 초과 회피"의 *메커니즘*과 sharing 재계산 폭증 원리는 [[Data Skew]] 참조. 본 노트는 best practice 행 자체만 표로 노출한다.

---

## 대량 로드 (Loading Data from the API)

### Bulk API 2.0 — 2,000건 기준

> **2,000건 초과** 레코드를 포함하는 데이터 작업은 Bulk API 2.0의 좋은 후보다. Bulk 프레임워크를 활용하는 비동기 워크플로를 준비·실행·관리한다.
> **2,000건 미만** 작업은 REST(예: Composite) 또는 SOAP의 **"bulkified" 동기 호출**을 사용해야 한다.

### 가장 효율적인 연산 선택

- **가장 빠른 연산 사용:** `insert()` 가 가장 빠르고, `update()` 가 다음, `upsert()` 가 그다음. 가능하면 `upsert()` 를 **`create()` 와 `update()` 두 연산으로 분해**한다.
- Bulk API 2.0 사용 시 **로드 전 데이터를 깨끗이** 한다. 배치 내 오류는 그 배치의 **단일 행 처리(single-row processing)** 를 유발해 성능에 큰 영향을 준다.

### 전송·처리 데이터 축소

- **업데이트 시 변경된 필드만 전송**(delta-only 로드).

### 전송 시간·중단 축소 (custom 통합)

- **로드당 1회만 인증**(레코드마다 인증하지 않음).
- **GZIP 압축 + HTTP keep-alive** 사용 — 긴 저장 작업 중 연결 끊김 방지.

### 계산 회피 — Public Read/Write

- **초기 로드 동안 Public Read/Write 보안**을 사용해 sharing 계산 오버헤드를 피한다.

### 계산 축소 — 순차 적재 (4단계)

초기 로드 시 가능하면 **sharing rule보다 role을 먼저** 채운다.

1. **사용자를 role에 로드**한다.
2. **owner를 포함한 레코드 데이터를 로드**해 role 계층의 계산을 트리거한다.
3. **public group·queue를 구성**하고 계산이 전파되게 둔다.
4. **sharing rule을 한 번에 하나씩 추가**하고, 다음 규칙을 추가하기 전에 각 규칙의 계산이 끝나게 한다.

> (대안 순서) 그룹·queue를 만들기 전에 사람·데이터를 먼저 추가한다: ① 새 사용자·레코드 데이터 로드 → ② (선택) 새 public group·queue 로드 → ③ sharing rule을 한 번에 하나씩 추가.

### 계산 연기 + throughput 향상

- **로드 중 Apex 트리거·workflow rule·validation 비활성화**, 로드 완료 후 레코드 처리에 **batch Apex** 사용을 검토한다.

### 배치 크기·timeout 균형

- SOAP API 사용 시, 레코드가 크거나 저장 작업에 연기 불가한 처리가 많으면 **네트워크 timeout을 피하면서 가능한 한 많은 배치(최대 200개)** 를 사용한다.

### WSC 사용

- Axis 같은 다른 Java API 클라이언트 대신 **Lightning Platform Web Service Connector(WSC)** 를 사용한다.

### parent 그룹핑 — 잠금 충돌 최소화

- 자식 레코드를 변경할 때 **parent별로 그룹핑** — 같은 배치 내에서 `ParentId` 필드로 레코드를 그룹핑해 잠금 충돌을 최소화한다.

### sharing 계산 연기 (defer sharing)

- **defer sharing calculation 권한**을 사용하면 대량 로드·구성 변경 동안 sharing 재계산을 미뤄 처리량을 높일 수 있다. 새 사용자·규칙·콘텐츠 로드가 끝날 때까지 sharing rule 처리를 연기한 뒤 한 번에 재계산한다.
- → 연기 메커니즘(suspend/resume·group membership calculation과 sharing rule calculation 두 프로세스·재계산 타이밍)의 상세는 [[Data Skew]] 참조.

의사코드 — 순차 적재 + 잠금 최소화 원리:

```apex
// 구조 예시 — LDV 백서 원리 표현, PDF 원문 코드 아님
deferSharing.suspend();              // group membership + sharing rule 계산 중단
loadUsersIntoRoles();                // 1. role
loadRecordsWithOwners();             // 2. owner 포함 → role 계층 계산
configureGroupsAndQueues();          // 3. public group/queue
addSharingRulesOneAtATime();         // 4. 규칙 하나씩
// 자식 로드 시 ParentId로 그룹핑해 잠금 충돌 최소화
deferSharing.resume();               // 유지보수 시간대에 재계산
```

---

## 데이터 추출 (Extracting Data from the API)

### getUpdated() / getDeleted() — 5분 초과 간격

- **`getUpdated()` 와 `getDeleted()` SOAP API**를 사용해 **5분보다 긴 간격**으로 외부 시스템과 Salesforce를 동기화한다. 더 잦은 동기화에는 **outbound messaging** 기능을 사용한다.

### Bulk API 2.0 Query — 100만 결과 초과

- **100만 결과를 초과해 반환할 수 있는 쿼리**는 더 적합할 수 있는 **Bulk API 2.0의 query 기능** 사용을 고려한다.

> PK chunking(대량 쿼리를 Primary Key 범위로 분할해 record-locking·timeout을 줄이는 추출 전략)은 본 LDV 백서의 범위 밖이다. Bulk 쿼리 분할 전략은 [[Bulk API 2.0]] 참조.

### mashup으로 로드 회피

- Salesforce로 데이터를 로드하지 않으려면 **mashup**(애플리케이션의 loosely coupled 통합)을 사용한다. mashup은 실시간 제약 때문에 짧은 상호작용·적은 데이터에 한정된다. 장점: 데이터가 항상 최신. 단점: 데이터 접근 시간 증가, 외부 데이터에 리포트·workflow 미동작.

---

## 데이터 삭제 (Deleting Data)

Salesforce 데이터 삭제 메커니즘은 LDV 성능에 큰 영향을 줄 수 있다. Salesforce는 사용자가 삭제한 데이터에 **Recycle Bin(휴지통) 비유**를 사용한다.

### Soft Delete — 휴지통 15일

데이터를 제거하지 않고 **삭제됨으로 플래그**하고 Recycle Bin으로 보이게 하는 것이 **soft deletion**이다.

- soft delete 상태에서도 데이터가 여전히 상주하므로 **DB 성능에 영향**을 준다(삭제 레코드를 쿼리에서 제외해야 함).
- 단, 휴지통 항목은 **조직의 storage 사용량에 포함되지 않는다**.
- 휴지통이 담을 수 있는 삭제 항목 수에 **제한이 없다**.
- 삭제 항목은 **15일** 동안 휴지통에 남고 그 기간 복원 가능. UI·API·Apex로 수동으로 비울 수도 있다.
- **15일 후** 항목은 휴지통에서 hard deletion 예약된다. Salesforce는 영구 삭제 정확한 시점을 보장하지 않는다.

### Hard Delete — Bulk API / Bulk API 2.0

- **Bulk API와 Bulk API 2.0**은 휴지통을 우회해 즉시 삭제 가능하게 하는 **hard delete 옵션**을 지원한다.
- 대용량 데이터 삭제에는 **Bulk API 2.0의 hard delete 함수 사용을 권장**한다.
- **100만 이상 레코드 삭제**(대용량 삭제 프로세스)에는 **Bulk API 또는 Bulk API 2.0의 hard delete 옵션**을 사용한다. 삭제 프로세스의 복잡성 때문에 대용량 삭제는 상당한 시간이 걸릴 수 있다.

### 자식 먼저 삭제

- **자식이 많은 레코드를 삭제할 때는 자식을 먼저 삭제**한다.

### sandbox truncate

- sandbox 조직의 custom 객체에서 레코드를 즉시 삭제하려면 해당 **custom 객체를 truncate**할 수 있다. Customer Support에 지원 요청.

---

## General Best Practice (요약 표)

| Goal | Best Practice |
|---|---|
| sharing 계산 회피 | **any user가 10,000 레코드 초과 소유 회피** (메커니즘 → [[Data Skew]]) |
| 성능 개선 | 여러 객체에 데이터를 분산하는 data-tiering 전략, 다른 객체·외부 스토어에서 on-demand 로드 |
| production sandbox 전체 복사 시간 단축 | 불필요하면 field history 제외, sandbox 복사 완료 전 데이터 대량 변경 금지 |
| 배포 효율화 | **parent당 child 10,000 초과 회피** — child 분산 (예: account 미사용 시 dummy account 만들어 contact 분산) (메커니즘 → [[Data Skew]]) |

---

## 케이스 스터디 (쓰기 경로)

### API Performance

**상황:** Salesforce 데이터를 외부 고객 애플리케이션과 동기화하는 custom 통합. 과정: ① 주어진 객체의 모든 데이터 쿼리 → ② 외부 시스템에 로드 → ③ Salesforce에서 어떤 데이터가 삭제됐는지 판단하려고 모든 ID를 다시 쿼리. 객체는 수백만 레코드. 통합은 **sharing 계층의 일부인 특정 API 사용자**로 검색 레코드를 제한. 쿼리가 수 분 소요.

**해법:** sharing은 UI 상호작용에는 잘 작동하지만 **SOQL 쿼리의 고볼륨 데이터 필터로 쓰면 성능이 저하**된다(데이터 접근이 복잡). 해법은 쿼리에 **모든 데이터 접근 권한**을 주고 selective filter로 적절한 레코드를 얻는 것. 예: **administrator를 API 사용자로 사용**하면 모든 데이터 접근이 가능해 쿼리에서 sharing이 고려되지 않는다. 추가로 **delta extraction**을 만들어 처리 데이터량을 낮출 수도 있었다.

---

## 관련 노트

- [[대용량 데이터 (LDV) — 쿼리 옵티마이저·인덱싱]] — LDV 읽기 경로(옵티마이저·인덱스·SOQL)
- [[Data Skew]] — 1만 건 소유/자식 임계값 메커니즘, group membership/sharing 재계산
- [[Bulk API 2.0]] — Bulk 로드·query·hard delete 상세
- [[Batch Apex]] — 로드 후 비동기 레코드 처리
- [[Governor Limits]] — DML·쿼리 제한 일반
- [[레코드 액세스 설계 (Enterprise Scale)]] — sharing·role 계층 대규모 설계
- [[Salesforce 플랫폼 개요]] — 멀티테넌트 아키텍처
