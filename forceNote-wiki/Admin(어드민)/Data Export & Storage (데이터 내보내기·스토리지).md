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

> 정확한 export **주기**와 edition 별 가용 여부는 시점·edition 에 따라 가변이므로 공식 문서에 위임한다 → [공식: Data Export Service](https://help.salesforce.com/s/articleView?id=sf.admin_exportdata.htm&type=5)

---

## Storage (스토리지)

조직은 **두 종류**의 저장 한도를 가진다.

| 스토리지 유형 | 대상 |
|---|---|
| **Data Storage** (데이터 스토리지) | 레코드성 데이터 |
| **File Storage** (파일 스토리지) | 첨부·파일 등 |

- **사용량 확인 위치:** **Company Information → Storage Usage**

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
