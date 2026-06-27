---
tags: [agent-skill, sf-skills, dx, tooling, app-analytics, isv]
source: forcedotcom/sf-skills (skills/dx-app-analytics-query/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [dx-app-analytics-query, App Analytics 쿼리 스킬, AppAnalyticsQueryRequest, AppAnalyticsSettings, ISV 앱 애널리틱스, 패키지 사용량 데이터]
---

# dx-app-analytics-query — ISV App Analytics 쿼리 스킬

> ISV 파트너가 관리형 패키지(managed package)의 사용량 분석 데이터를 `AppAnalyticsQueryRequest` sObject로 비동기 조회하고 `AppAnalyticsSettings` 메타데이터로 시뮬레이션/옵트아웃을 설정하도록 돕는 에이전트 스킬.

---

## 목적과 활성화 조건

이 스킬은 다음 작업을 소관한다.

- REST/sObject API로 `AppAnalyticsQueryRequest` 레코드 생성
- Metadata API(`sf project deploy`)로 `AppAnalyticsSettings` 구성 (시뮬레이션 모드, 옵트아웃)
- 쿼리 라이프사이클 이해: New → Pending → Complete → Expired → Failed
- `dataType` 값 선택: `PackageUsageSummary`, `PackageUsageLog`, `SubscriberSnapshot`
- 분석 데이터 다운로드의 파일 포맷·압축 옵션
- `startTime`, `endTime`, `availableSince`를 이용한 시간 범위 필터링
- 실패하거나 만료된 분석 쿼리 트러블슈팅

**TRIGGER:** 사용자가 App Analytics, AppAnalyticsQueryRequest, AppAnalyticsSettings, 패키지 사용량 데이터, 구독자(subscriber) 분석, ISV 분석, app analytics 시뮬레이션 모드를 언급할 때.

**DO NOT TRIGGER (다른 스킬에 위임):**
- 표준 CRM SOQL 쿼리 → `platform-soql-query`
- Data Cloud SQL 또는 DMO → `data360-query`
- 표준 객체 기반 리포트/대시보드 → reporting 스킬
- 일반 메타데이터 XML 배포/조회 → `platform-metadata-deploy` / retrieving-metadata

---

## 사용 가능한 타입

### AppAnalyticsQueryRequest (REST/sObject API)

ISV 파트너가 자신의 관리형 패키지에 대한 사용량 분석 데이터를 ISV Intelligence Data Lake에서 가져오기 위해 사용하는 비동기 쿼리 요청. 레코드는 `POST /services/data/vXX.0/sobjects/AppAnalyticsQueryRequest`로 생성하고 `GET /services/data/vXX.0/sobjects/AppAnalyticsQueryRequest/<id>`로 폴링한다. 시스템이 쿼리를 처리하고 완료 시 presigned 다운로드 URL을 제공한다.

**필드 (14개 속성):**

| 필드 | 타입 | 설명 |
|------|------|------|
| DataType | string (filterable) | 분석 데이터 유형. 값: `PackageUsageSummary`, `PackageUsageLog`, `SubscriberSnapshot` |
| RequestState | string (filterable) | 처리 상태. 값: `New`, `Pending`, `Complete`, `Expired`, `Failed`, `NoData`, `Delivered` |
| StartTime | string | 요청 데이터 시간 범위의 시작 |
| EndTime | string | 시간 범위의 끝. 시(hour) 경계에 맞춰야 함 |
| AvailableSince | string | 이 시간 이후 인덱싱된 데이터로 쿼리를 한정(inclusive). 증분 조회에 사용 |
| PackageIds | string | 관리형 패키지 ID(033-prefix)의 콤마 구분 목록 |
| OrganizationIds | string | 결과를 필터링할 구독자 org ID의 콤마 구분 목록 |
| DownloadUrl | string | 결과 다운로드용 presigned URL. RequestState가 Complete일 때 채워짐 |
| DownloadSize | long | 결과 데이터 파일의 바이트 크기 |
| DownloadExpirationTime | string | 다운로드 URL이 만료되는 시간 |
| FileType | string (filterable) | 출력 포맷. 값: `csv`, `parquet` |
| FileCompression | string (filterable) | 압축. 값: `none`, `gzip`, `snappy` |
| QuerySubmittedTime | string | 쿼리가 Data Lake에 제출된 시간 |
| ErrorMessage | string | 실패한 쿼리의 진단 메시지 |

> PDF 원문(SKILL.md): DataType 값 = `PackageUsageSummary`, `PackageUsageLog`, `SubscriberSnapshot` / RequestState 값 = `New`, `Pending`, `Complete`, `Expired`, `Failed`, `NoData`, `Delivered` / FileType = `csv`, `parquet` / FileCompression = `none`, `gzip`, `snappy`.

### AppAnalyticsSettings (Metadata API)

시뮬레이션 모드와 옵트아웃 동작을 제어하는 ISV App Analytics 구성 설정. Metadata API(`sf project deploy`) 또는 Tooling API로 배포한다.

**필드 (2개 속성):**

| 필드 | 타입 | 설명 |
|------|------|------|
| enableSimulationMode | boolean (filterable) | true이면 실제 구독자 데이터 없이 통합 테스트용 샘플 사용량 로그를 쿼리 가능 |
| enableAppAnalyticsOptOut | boolean (filterable) | true이면 이 구독자 org를 AppExchange App Analytics 데이터 수집에서 옵트아웃 |

---

## 워크플로 / 단계

### 요청 라이프사이클

```text
New → Pending → Complete → (만료 윈도우 내 다운로드)
                         → Expired (다운로드 URL 무효)
                         → Delivered (다운로드 수신 확인됨)
         → Failed (errorMessage 확인)
         → NoData (조건에 맞는 레코드 없음)
```

### 패턴 1 — 패키지 사용량 요약 쿼리 (최근 7일)

REST API로 레코드를 생성한다.

```bash
POST /services/data/v60.0/sobjects/AppAnalyticsQueryRequest
Content-Type: application/json

{
  "DataType": "PackageUsageSummary",
  "StartTime": "<7-days-ago>T00:00:00Z",
  "EndTime": "<today-on-hour-boundary>T00:00:00Z",
  "PackageIds": "033XXXXXXXXXXXX",
  "FileType": "csv",
  "FileCompression": "gzip"
}
```

`RequestState`가 `Complete`에 도달할 때까지 GET으로 폴링한 뒤 `DownloadUrl`에서 다운로드한다.

### 패턴 2 — 증분 데이터 조회

`AvailableSince`를 마지막 성공 쿼리 완료 시각의 타임스탬프로 설정하여 이미 받은 데이터를 다시 받지 않도록 한다.

### 패턴 3 — 테스트용 시뮬레이션 모드 활성화

`AppAnalyticsSettings`를 `enableSimulationMode: true`로 Metadata API 배포하면 실제 구독자 없이 샘플 데이터를 쿼리할 수 있다.

---

## 핵심 규칙·가드레일 (High-Signal Gotchas)

- AppAnalyticsQueryRequest는 **sObject**다 — REST Data API(`/sobjects/AppAnalyticsQueryRequest`)로 레코드를 생성/폴링하며, Metadata API XML 배포로 하지 **않는다**.
- AppAnalyticsQueryRequest는 Apex 트리거가 **없고**, 커스텀 객체나 Flow를 거치지 않는다.
- 다운로드 URL은 만료된다 — 다운로드 시도 전 항상 `DownloadExpirationTime`을 확인한다.
- `EndTime`은 일관된 결과를 위해 시(hour) 경계에 맞춰 설정한다.
- `AvailableSince`는 inclusive — 정확히 그 타임스탬프에 인덱싱된 데이터도 포함된다.
- `PackageIds`는 033-prefix ID를 쓴다. 04t(패키지 버전) ID가 아니다.
- 데이터는 ISV Intelligence Data Lake 인프라가 비동기로 처리한다. 동기(synchronous) 쿼리 옵션은 없다.
- `FileType: parquet` + `FileCompression: snappy` 조합이 대용량 데이터셋에 최적 성능을 준다.

### 출력 포맷

```text
Analytics task: <query / configure / troubleshoot>
Data type: <PackageUsageSummary / PackageUsageLog / SubscriberSnapshot>
Package IDs: <033-prefixed IDs>
Time range: <startTime> to <endTime>
File format: <csv|parquet> / <none|gzip|snappy>
Request state: <current state>
Next step: <poll for completion / download / investigate failure>
```

---

## 번들 파일

- `SKILL.md` — 단일 번들 파일 (별도 references/examples/scripts 없음)
- frontmatter metadata: `version: 1.0`, `minApiVersion: 56.0`

---

## 관련 노트
- [[dx-org-switch]]
- [[dx-code-analyzer-run]]
- [[platform-soql-query]]
- [[data360-query]]
