---
tags: [admin, monitoring, scheduled-jobs, apex-jobs, apex-flex-queue, background-jobs, bulk-data-load-jobs, setup]
source: help.salesforce.com (Monitoring Scheduled Jobs — data_monitoring_jobs.htm; Monitor the Apex Job Queue — code_apex_job.htm; Monitor Background Jobs — monitoring_background_jobs.htm; Monitor Bulk Data Load Jobs — monitoring_async_api_jobs.htm; Apex Flex Queue — Apex Developer Guide; 라이브 공식 문서, Tier 2, 접속 2026-07-12)
created: 2026-07-12
aliases: [작업 모니터링, Job Monitoring, Scheduled Jobs, All Scheduled Jobs, Apex Jobs, Apex Job Queue, Apex Flex Queue, Background Jobs, Bulk Data Load Jobs, 예약 작업, 아펙스 작업, 플렉스 큐, 백그라운드 작업, 벌크 데이터 로드 작업]
---

# 작업 모니터링 (Scheduled Jobs · Apex Jobs · Flex Queue · Bulk Data Load)

> Setup의 **Monitoring(모니터링)** 영역에서 org의 비동기·예약 작업을 운영 관점으로 들여다보는 5개 화면 — **All Scheduled Jobs**(예약 목록·삭제), **Apex Jobs**(실행 이력·상태·중단), **Apex Flex Queue**(Holding 배치 대기열·재정렬), **Background Jobs**(공유 재계산 등), **Bulk Data Load Jobs**(Bulk API 잡). 각 기능의 코드 동작(Batch/Scheduled Apex 작성법)은 개발자 노트로 위임하고, 이 노트는 **Setup 화면에서 무엇이 보이고 무엇을 할 수 있는가**만 다룬다.

> [!note] Setup 라벨 캐비엇
> Setup의 Quick Find 라벨·페이지 명칭은 릴리스·에디션·활성 기능에 따라 달라질 수 있다(예: 문서 ID가 `sf.` → `xcloud.`/`platform.` 네임스페이스로 리다이렉트). 아래는 2026-07-12 기준 공식 Salesforce Help 문서 표기다.

---

## 한눈에 보기 — 5개 모니터링 화면

| Setup Quick Find | 화면 | 보이는 것 | 가능한 액션 |
|---|---|---|---|
| Scheduled Jobs | **All Scheduled Jobs** | 예약된 Apex·대시보드 새로고침·리포팅 스냅샷 목록, 다음 실행 시각 | Manage(편집)·**Del(삭제)**·Pause/Resume·Schedule Apex |
| Apex Jobs | **Apex Job Queue** | 최근 7일 제출된 Apex 잡의 상태·배치 진행·실패 | **Abort Job**(중단) |
| Apex Flex Queue | **Apex Flex Queue** | `Holding` 상태 배치 대기열(최대 100) | 실행 순서 **재정렬(Reorder)** |
| Background Jobs | **Background Jobs** | 병렬 공유 재계산 등 백그라운드 작업 진행률 | 모니터링만(중단은 Salesforce 문의) |
| Bulk Data Load Jobs | **Bulk Data Load Jobs** | Bulk API/Data Loader 잡의 진행·결과 | 잡 상세(Job ID) 조회 |

---

## 1. All Scheduled Jobs (예약 작업)

**경로:** Setup → Quick Find에 `Scheduled Jobs` → **Scheduled Jobs**
**필요 권한:** View Setup and Configuration
**에디션:** Professional·Enterprise·Performance·Unlimited·Developer·Database.com (Reporting Snapshots·Dashboards는 Database.com 미지원)

이 페이지는 org에 예약된 **모든** 작업을 나열한다:

- **Reporting snapshots**(리포팅 스냅샷)
- **Scheduled Apex jobs**(예약 Apex — `System.schedule()`로 등록된 `Schedulable` 클래스)
- **Dashboards scheduled to refresh**(예약 새로고침 대시보드)

**표시되는 필드(잡 상세):**

- 예약 작업 이름(Name)
- 제출한 사용자(Submitted By)
- 최초 제출 일시(Submitted)
- 시작 일시(Started)
- **다음 실행 일시(Next Scheduled Run)**
- 작업 유형(Type)
- 예약 작업의 **CronTrigger ID**

**가능한 액션(권한에 따라 일부 또는 전부):**

- 페이지 상단에 **사용된 예약 작업 수의 백분율 + org 허용 한도**를 표시
- **Schedule Apex** — Apex 잡을 새로 예약(Schedule Builder 또는 Cron Expression 선택)
- **Manage** — 예약 작업 편집
- **Del** — 예약 작업의 **모든 인스턴스를 영구 삭제**
- **Pause Job / Resume Job** — 예약 작업 일시정지/재개

> 동시 예약 잡 **최대 100개** 등 Scheduled Apex의 한도·`System.schedule` 문법은 → [[Scheduled Apex]] 위임.

---

## 2. Apex Jobs (Apex 작업 큐)

**경로:** Setup → Quick Find에 `Apex Jobs` → **Apex Jobs**
**에디션:** Enterprise·Performance·Unlimited·Developer·Database.com (Salesforce Classic은 일부 org 미제공)

Apex Jobs 페이지는 **최근 7일간 실행 제출된 Apex 잡**을 나열한다(7일보다 오래된 예약 잡은 All Scheduled Jobs 페이지 또는 `AsyncApexJob`으로 프로그램 조회). 페이지 상단에 **비동기 Apex 사용률(%)과 24시간 org 한도 대비 사용된 Apex 오퍼레이션 수**를 표시해 한도 초과를 사전에 감지하게 한다.

**나열되는 잡 유형(Job Type 열):**

- **Future** — `@future` 메서드 또는 `Queueable` 구현 클래스로 아직 실행되지 않은 잡. `Total Batches`·`Batches Processed` 값 없음.
- **Scheduled Apex** — 아직 끝나지 않은 예약 Apex. 배치 값 없고 **항상 `Queued` 상태**. (이 페이지에서 중단 불가 → All Scheduled Jobs에서 관리/삭제. 두 페이지에 모두 나와도 비동기 한도엔 **1회만** 계산.)
- **Sharing Recalculation** — 공유 재계산 배치 잡(레코드가 자동으로 배치 분할). limited release.
- **Batch Apex** — 아직 끝나지 않은 배치 Apex(레코드 자동 배치 분할). `Total Batches`=전체 배치 수, `Batches Processed`=처리 완료 배치 수.

**상태(Status) 값 — 전수:**

| Status | 설명 |
|---|---|
| **Queued** | 실행 대기 중 |
| **Preparing** | 잡의 `start` 메서드가 호출됨(배치 크기에 따라 수 분 소요 가능) |
| **Processing** | 처리 중 |
| **Aborted** | 사용자가 중단함 |
| **Completed** | 실패 여부와 무관하게 완료됨 |
| **Failed** | 시스템 오류 발생 |

> 배치 Apex 잡은 Flex Queue에 있을 때 **`Holding`** 상태도 가질 수 있다(→ 아래 3장).

- 배치 처리 중 오류가 나면 **Status Details** 열에 첫 오류의 짧은 설명이 뜨고, 더 상세한 설명은 배치 클래스를 마지막으로 수정한 사용자에게 이메일로 전송된다.
- 대형 배치가 처리 중일 때 `Total Batches` 값이 부정확할 수 있음 → 페이지 상단 링크로 **batch jobs 페이지**로 이동하면 정확한 카운트를 본다. 배치 클래스의 **More Info**로 부모 잡(상태·제출/완료일·배치별 경과시간·처리/실패 배치 수)을 확인.
- **View** 드롭다운으로 미리 정의된 목록 선택 또는 **Create New View**로 커스텀 뷰(예: `future` 메서드만).
- **한 org에서 배치 Apex 잡의 `start` 메서드는 한 번에 하나만** 실행(다른 잡은 큐 대기). 이 한도로 잡이 실패하진 않으며, 여러 잡이 돌면 `execute` 메서드는 여전히 병렬 실행.
- **Abort Job** — 모든 유형의 Apex 잡에 대해 Action 열의 이 버튼으로 처리를 중단.

> Batch/Queueable/Future/Scheduled Apex의 작성·수명주기 상세는 → [[Batch Apex]] · [[Queueable]] · [[Scheduled Apex]] 위임.

---

## 3. Apex Flex Queue (Holding 배치 대기열)

**경로:** Setup → **Jobs | Apex Flex Queue**

즉시 처리되지 못한 배치 잡은 **실패하지 않고** `Holding` 상태로 **Apex Flex Queue**(표준 배치 큐와 별개의 대기열)에 들어간다.

- **최대 100개**의 배치 잡이 동시에 `Holding` 상태로 대기 가능.
- 시스템 리소스가 나면 Flex Queue에서 잡을 꺼내 배치 큐로 옮기고, 상태가 **`Holding` → `Queued`** 로 바뀐다.
- 관리자는 Flex Queue에서 **Holding 잡의 실행 순서를 재정렬(reorder)** 할 수 있다 — 예: 특정 배치를 맨 앞으로 올려 다음에 먼저 처리되게. 관리자 개입이 없으면 제출 순서대로 **FIFO(first-in first-out)** 처리.
- org당 동시에 처리(queued 또는 active)되는 잡은 **최대 5개**.

> 동시성 한도(queued/active 5 + Holding 100)의 코드 맥락과 대량 배치 정체 함정은 → [[Batch Apex]]의 "동시성 한도 — Apex Flex Queue" 절 위임.

---

## 4. Background Jobs (백그라운드 작업)

**경로:** Setup → Quick Find에 `Background Jobs` → **Background Jobs**
**필요 권한:** View Setup and Configuration
**에디션:** Professional·Enterprise·Performance·Unlimited·Developer·Database.com

대형 org에서 오브젝트별 공유 재계산 속도를 높이는 **병렬 공유 재계산(parallel sharing recalculation)** 같은 백그라운드 작업을 모니터링한다.

- **Job Type** 열 — 실행 중인 백그라운드 작업(예: `Organization-Wide Default Update`).
- **Job Sub Type** 열 — 영향받는 오브젝트(예: `Account`, `Opportunity`) 또는 재계산 단계(`Person Account Access`, `Associated Portal Account Access`, `Parent Account Access`).
- 진행률(재계산 완료 백분율 추정치) 표시.
- `Status`가 **Completed** 로 떠도 변경이 org에 반영되기까지 추가 작업이 더 걸릴 수 있다.

> [!note] 모니터링 전용
> 이 페이지에서는 **모니터링만** 가능하다. 백그라운드 작업 중단은 Salesforce에 문의해야 한다.

---

## 5. Bulk Data Load Jobs (벌크 데이터 로드 작업)

**경로:** Setup → Quick Find에 `Bulk Data Load Jobs` → **Bulk Data Load Jobs**
**필요 권한:** Manage Data Integrations, API Enabled, View Setup and Configuration
**에디션:** Enterprise·Performance·Unlimited·Developer·Database.com

Bulk API로 대량 레코드를 비동기 처리하는 **잡**의 진행·결과를 추적한다. **Data Loader를 포함해 임의의 클라이언트 앱**이 만든 잡·배치를 모니터링한다. 화면은 **In Progress Jobs**(진행 중)와 **Completed Jobs**(완료) 목록으로 나뉜다.

**In Progress Jobs 주요 열(알파벳순):**

- **Job ID** — 15자리 고유 ID(클릭하면 Job Detail 페이지)
- **Job Type** — 사용된 API 유형: `Bulk V1`, `Bulk V2`, `Bulk V2 Query` (V2/V2 Query = Bulk API 2.0, 배치 자동 생성)
- **Object** — 처리 대상 오브젝트(잡 내 데이터는 단일 오브젝트 유형)
- **Operation** — 처리 오퍼레이션: `Delete`, `Insert`, `Query`, `QueryAll`, `Upsert`, `Update`, `HardDelete`
- **Progress** — 제출된 전체 배치 대비 처리된 배치 백분율(잡이 open이면 미표시)
- **Records Processed** — 처리 완료된 레코드 수
- **Start Time** — 잡 제출 일시
- **Submitted By** — 잡을 제출한 사용자

**Status 값 — 전수:**

| Status | 설명 |
|---|---|
| **Open** | 잡 생성됨, 데이터 추가 가능 |
| **Closed** | 새 데이터 추가 불가(닫힌 잡 편집/저장 불가), 닫힌 뒤에도 처리될 수 있음 |
| **Aborted** | 잡 중단됨 |
| **Failed** | 잡 실패(이미 성공 처리된 데이터는 롤백 불가) |
| **Job Complete** | Salesforce가 처리 완료 (Bulk API 2.0 전용) |
| **Upload Complete** | 새 데이터 추가 불가 (Bulk API 2.0 전용) |

> Data Loader / Data Import Wizard 등 실제 로딩 도구는 → [[Data Loader]] · [[Data Import Wizard]] 위임.

---

## 프로그래밍 방식 모니터링 (참고)

Setup 화면 대신 SOQL로 잡 상태를 조회할 수도 있다 — 개발자 관점의 보조 수단.

```apex
// 구조 예시 — 실제 동작 코드 아님 (표준 객체 AsyncApexJob / CronTrigger 조회 형태)
// Apex Jobs 화면에 대응: AsyncApexJob
List<AsyncApexJob> jobs = [
    SELECT Id, JobType, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, ApexClass.Name
    FROM AsyncApexJob
    WHERE Status IN ('Queued', 'Processing', 'Preparing', 'Holding')
];

// All Scheduled Jobs 화면에 대응: CronTrigger
List<CronTrigger> scheduled = [
    SELECT Id, CronJobDetail.Name, State, NextFireTime, PreviousFireTime
    FROM CronTrigger
];
```

`AsyncApexJob`·`CronTrigger` 필드와 `System.abortJob(id)` 사용법은 [[Batch Apex]]·[[Scheduled Apex]]에 상세.

---

## 관련 노트

- [[Batch Apex]] — 배치 Apex 작성·수명주기·Flex Queue 동시성 한도
- [[Scheduled Apex]] — 예약 Apex(`Schedulable`)·CronTrigger·동시 100 한도
- [[Queueable]] — Queueable 인터페이스(Apex Jobs에 Future로 표시)
- [[Data Loader]] — Bulk Data Load Jobs를 생성하는 CSV 로딩 도구
- [[Data Import Wizard]] — 웹 기반 임포트 마법사
