---
tags: [admin, data-management, data-export, storage, backup]
source: help.salesforce.com (Salesforce Help — Data Export Service / Monitor Storage Usage; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=sf.admin_exportdata.htm&type=5
created: 2026-07-03
aliases: [Data Export, 데이터 내보내기, Export Service, 백업, Storage, 스토리지, Data Storage, File Storage]
---

# Data Export & Storage (데이터 내보내기·스토리지)

> **Data Export Service**로 조직 데이터를 CSV zip으로 내보내(백업)고, **Storage** 사용량(데이터/파일)을 모니터링한다. 예약 export 또는 즉시 export.

---

## Data Export Service

조직 데이터를 **CSV 파일 집합(zip)** 으로 내보내는 백업용 서비스다. Setup UI에서 실행하며, 코드나 외부 도구 없이 전체 조직 데이터의 스냅샷을 확보할 수 있다.

- **접근 경로:** Setup → Quick Find 에 **"Data Export"** 입력 → **Data Export**
- **출력 형식:** CSV 파일들을 묶은 **zip** 아카이브(백업 용도)

### 내보내기 방식 — 2가지

| 방식 | 설명 |
|---|---|
| **Schedule Export** (예약) | edition 에 따라 **주간 또는 월간** 주기로 자동 export 를 예약 |
| **Export Now** (즉시) | 요청 시점에 곧바로 export 를 생성 |

### Export 주기 — edition 별

| 주기 | 지원 edition |
|---|---|
| **Weekly**(주간) | Enterprise · Performance · Unlimited |
| **Monthly**(월간) | 그 외 edition (Professional · Developer · Group 등) |

- Weekly 예약 export 는 **Enterprise / Performance / Unlimited** 에서만 가능하고, 그보다 낮은 edition 은 **monthly** 만 예약할 수 있다.
- 생성된 export 파일은 완료 후 **48시간** 동안 다운로드 가능하다.

> 출처: Salesforce Help — help.salesforce.com (`sf.admin_exportdata.htm` Data Export Service / Data Export FAQ). edition 별 주기·48시간 보관은 공식 문서 기준(접속 2026-07-12). 정확한 최신 값은 시점에 따라 달라질 수 있으므로 공식 문서 재확인 권장 → [공식: Data Export Service](https://help.salesforce.com/s/articleView?id=sf.admin_exportdata.htm&type=5)

---

## Storage (스토리지)

조직은 **두 종류**의 저장 한도를 가진다.

| 스토리지 유형 | 대상 |
|---|---|
| **Data Storage** (데이터 스토리지) | 레코드성 데이터 |
| **File Storage** (파일 스토리지) | 첨부·파일 등 |

- **사용량 확인 위치:** **Company Information → Storage Usage**

### Storage 계산 심화

**Data Storage 는 바이트가 아니라 "레코드 건수 × 고정 per-record 크기"로 계산된다.** 대부분의 레코드는 필드 수·값 길이와 무관하게 고정 크기를 차지한다.

| 레코드 유형 | per-record 크기 |
|---|---|
| 대부분의 레코드 | 약 **2 KB** |
| Person Account | **4 KB** |
| Campaign | **8 KB** |
| Campaign Member | **1 KB** |
| Article | **4 KB** (리치텍스트 이미지는 File Storage에 별도 저장) |
| Email Message | **실제 이메일 크기에 비례** (예: 100 KB 메일 = 100 KB) |

- **실무 함의:** 데이터 스토리지를 줄이려면 **필드를 다듬는 게 아니라 레코드를 삭제·아카이브**해야 한다(레코드당 고정 크기이므로).
- **Data Storage vs File Storage 구분:** Data Storage = 위 per-record 계산이 적용되는 **레코드성 데이터**. File Storage = 첨부·Salesforce Files·문서 등 **바이너리 콘텐츠**로, 실제 파일 크기 그대로 계산된다(고정 per-record 아님).

> per-record 크기 값 출처: Salesforce Help — help.salesforce.com (`000383664` Salesforce record size overview, 접속 2026-07-12).

**에디션별 기본 용량(참고 — 시점 가변, 공식 재확인 필요):** 다수 edition(Contact Manager · Group · Professional · Enterprise · Performance · Unlimited)은 **Data Storage 기본 10 GB + 사용자 라이선스당 소량 증분**, **File Storage 기본 10 GB**(Essentials/Starter 계열은 1 GB) 수준으로 알려져 있으나, 정확한 값은 edition·시점에 따라 달라지므로 조직의 **Storage Usage** 페이지 또는 공식 문서로 확인한다.

> 정확한 edition 별 **용량 한도 값**은 시점·edition 에 따라 가변이므로 공식 문서에 위임한다 → [공식: Monitor Your Storage Usage](https://help.salesforce.com/s/articleView?id=sf.admin_monitorresources.htm&type=5)

---

## 구조 개요

```
// 구조 예시 — Data Export & Storage(실제 동작 코드 아님)
Setup → Data Export: Schedule Export(주간/월간) 또는 Export Now → CSV zip(백업)
Storage: Data Storage + File Storage 한도
   사용량 확인: Company Information → Storage Usage
```

Data Loader 의 export 기능이 **온디맨드·필터 기반**의 개별 추출인 반면, Data Export Service 는 **예약 백업**에 초점을 둔 별개 서비스다.

---

## 관련 노트
- [[Data Loader]] — 즉시·필터 export 대안(예약 백업 vs 온디맨드)
- [[Company Information & Fiscal Year (회사 정보·회계연도)]] — 스토리지 사용량 확인 위치(Storage Usage)
