---
tags: [devops, metadata-api, result-objects, DeployResult, RetrieveResult, RunTestsResult, SaveResult, DeleteResult, UpsertResult, AsyncResult, v67]
source: api_meta.pdf v67.0 Summer '26 — Chapter 12 (Result Objects)
created: 2026-05-22
aliases: [DeployResult, RetrieveResult, RunTestsResult, SaveResult, DeleteResult, UpsertResult, AsyncResult, Metadata API 결과 객체]
---

# Metadata API Result Objects

> Metadata API 호출이 반환하는 결과 객체 전체 레퍼런스. v67.0 Summer '26.

---

## AsyncResult

비동기 호출(`deploy()`, `retrieve()` 등) 시 즉시 반환되는 객체.

| 필드 | 타입 | 설명 |
|---|---|---|
| `done` | boolean | 완료 여부 |
| `id` | string | 비동기 작업 ID |
| `message` | string | 오류 메시지 |
| `state` | AsyncRequestState | 상태 (Queued/InProgress/Completed/Error) — v31.0+ 에서는 id 필드만 사용됨 |
| `statusCode` | string | 오류 상태 코드 |

---

## CancelDeployResult

`cancelDeploy()`가 반환하는 배포 취소 결과 객체. v30.0+.

| 필드 | 타입 | 설명 |
|---|---|---|
| `done` | boolean | 취소 완료 여부. 대기 중 배포는 즉시 true, 처리 중이면 false |
| `id` | ID | 취소 중인 배포 ID |

---

## DeployResult

`checkDeployStatus()`가 반환하는 배포 결과 객체.

### 주요 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `id` | ID | 배포 작업 ID |
| `done` | boolean | 완료 여부 |
| `status` | DeployStatus | 배포 상태 열거형 |
| `success` | boolean | 성공 여부 |
| `checkOnly` | boolean | 검증 전용 배포 여부 |
| `createdDate` | dateTime | 배포 시작 시각 |
| `lastModifiedDate` | dateTime | 마지막 업데이트 시각 |
| `completedDate` | dateTime | 완료 시각 |
| `startDate` | dateTime | 처리 시작 시각 |
| `errorMessage` | string | 오류 메시지 |
| `errorStatusCode` | string | 오류 상태 코드 |
| `numberComponentErrors` | int | 오류 컴포넌트 수 |
| `numberComponentsDeployed` | int | 배포 완료 컴포넌트 수 |
| `numberComponentsTotal` | int | 전체 컴포넌트 수 |
| `numberTestErrors` | int | 실패 테스트 수 |
| `numberTestsCompleted` | int | 완료 테스트 수 |
| `numberTestsTotal` | int | 전체 테스트 수 |
| `rollbackOnError` | boolean | 오류 시 롤백 여부 |
| `runTestsEnabled` | boolean | 테스트 실행 활성화 여부 |
| `details` | DeployDetails | 상세 결과 (includeDetails=true 시) |

### DeployDetails 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `allComponentMessages` | DeployMessage[] | 전체 컴포넌트 메시지 |
| `componentFailures` | DeployMessage[] | 실패한 컴포넌트 목록 |
| `componentSuccesses` | DeployMessage[] | 성공한 컴포넌트 목록 |
| `retrieveResult` | RetrieveResult | 배포 후 검색 결과 (performRetrieve=true 시) |
| `runTestResult` | RunTestsResult | 테스트 실행 결과 |

### DeployMessage 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `changed` | boolean | 변경 여부 |
| `columnNumber` | int | 오류 발생 열 번호 |
| `componentType` | string | 메타데이터 타입 |
| `created` | boolean | 새로 생성 여부 |
| `createdDate` | dateTime | 생성 시각 |
| `deleted` | boolean | 삭제 여부 |
| `fileName` | string | 파일 이름 |
| `fullName` | string | 전체 이름 |
| `id` | string | 컴포넌트 ID |
| `lineNumber` | int | 오류 발생 줄 번호 |
| `problem` | string | 오류/경고 메시지 |
| `problemType` | string | 문제 유형 (Error/Warning) |
| `success` | boolean | 성공 여부 |

### DeployStatus 열거형

| 값 | 설명 |
|---|---|
| `Pending` | 대기 중 |
| `InProgress` | 처리 중 |
| `FinalizingDeploy` | 마무리 중 |
| `FinalizingDeployFailed` | 마무리 실패 |
| `Succeeded` | 성공 |
| `SucceededPartial` | 부분 성공 |
| `Failed` | 실패 |
| `Canceling` | 취소 진행 중 |
| `Canceled` | 취소 완료 |

---

## RunTestsResult

배포 시 실행된 Apex 테스트 전체 결과.

### 주요 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `apexLogId` | ID | Apex 로그 ID |
| `codeCoverage` | CodeCoverageResult[] | 코드 커버리지 결과 목록 |
| `codeCoverageWarnings` | CodeCoverageWarning[] | 커버리지 경고 목록 |
| `failures` | RunTestFailure[] | 실패 테스트 목록 |
| `flowCoverage` | FlowCoverageResult[] | 플로우 커버리지 결과 |
| `flowCoverageWarnings` | FlowCoverageWarning[] | 플로우 커버리지 경고 |
| `numFailures` | int | 실패 테스트 수 |
| `numTestsRun` | int | 실행된 테스트 수 |
| `successes` | RunTestSuccess[] | 성공 테스트 목록 |
| `totalTime` | double | 총 테스트 실행 시간 (밀리초) |

### CodeCoverageResult 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `id` | ID | 클래스 또는 트리거 ID |
| `locationsNotCovered` | CodeLocation[] | 미커버 라인 위치 목록 |
| `name` | string | 클래스/트리거 이름 |
| `namespace` | string | 네임스페이스 |
| `numLocations` | int | 전체 실행 가능 라인 수 |
| `numLocationsNotCovered` | int | 미커버 라인 수 |
| `type` | string | 컴포넌트 타입 (Class/Trigger) |

### CodeCoverageWarning 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `id` | ID | 컴포넌트 ID |
| `message` | string | 경고 메시지 |
| `name` | string | 컴포넌트 이름 |
| `namespace` | string | 네임스페이스 |

### RunTestFailure 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `id` | ID | 클래스 ID |
| `message` | string | 오류 메시지 |
| `methodName` | string | 실패한 테스트 메서드 이름 |
| `name` | string | 클래스 이름 |
| `namespace` | string | 네임스페이스 |
| `packageName` | string | 패키지 이름 |
| `seeAllData` | boolean | 조직 데이터 접근 여부 (v33.0+) |
| `stackTrace` | string | 스택 트레이스 |
| `time` | double | 테스트 실행 시간 |
| `type` | string | 컴포넌트 타입 |

### RunTestSuccess 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `id` | ID | 클래스 ID |
| `methodName` | string | 성공한 테스트 메서드 이름 |
| `name` | string | 클래스 이름 |
| `namespace` | string | 네임스페이스 |
| `seeAllData` | boolean | 조직 데이터 접근 여부 (v33.0+) |
| `time` | double | 테스트 실행 시간 |

### CodeLocation 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `column` | int | 열 위치 |
| `line` | int | 줄 번호 |
| `numExecutions` | int | 실행 횟수 |
| `time` | double | 해당 위치 누적 실행 시간 |

---

## RetrieveResult

`checkRetrieveStatus()`가 반환하는 검색 결과 객체. v31.0+.

| 필드 | 타입 | 설명 |
|---|---|---|
| `done` | boolean | 완료 여부 |
| `errorMessage` | string | 오류 메시지 |
| `errorStatusCode` | StatusCode | 오류 상태 코드 |
| `fileProperties` | FileProperties[] | 각 컴포넌트의 파일 속성 목록 |
| `id` | ID | 검색 작업 ID |
| `messages` | RetrieveMessage[] | 성공/실패 정보 |
| `status` | RetrieveStatus | 상태 (Pending/InProgress/Succeeded/Failed) |
| `success` | boolean | 성공 여부 |
| `zipFile` | base64Binary | Base64 인코딩된 .zip 파일 |

### FileProperties 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `createdById` | string | 생성자 ID |
| `createdByName` | string | 생성자 이름 |
| `createdDate` | dateTime | 생성 날짜 |
| `fileName` | string | 파일 이름 |
| `fullName` | string | 개발자 이름 (고유 식별자) |
| `id` | string | 파일 ID |
| `lastModifiedById` | string | 최종 수정자 ID |
| `lastModifiedByName` | string | 최종 수정자 이름 |
| `lastModifiedDate` | dateTime | 최종 수정 날짜 |
| `manageableState` | ManageableState | 패키지 관리 상태 |
| `namespacePrefix` | string | 네임스페이스 접두사 |
| `type` | string | 메타데이터 타입 |

### ManageableState 열거형

| 값 | 설명 |
|---|---|
| `beta` | 베타 패키지 |
| `deleted` | 삭제됨 |
| `deprecated` | 더 이상 사용 안 됨 |
| `deprecatedEditable` | 편집 가능한 deprecated |
| `installed` | 설치된 관리 패키지 |
| `installedEditable` | 편집 가능한 설치 패키지 |
| `released` | 릴리즈된 관리 패키지 |
| `unmanaged` | 관리 패키지 아님 |

### RetrieveMessage 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `fileName` | string | 문제가 발생한 파일 이름 |
| `problem` | string | 문제 설명 |

---

## SaveResult

`createMetadata()`, `updateMetadata()`, `renameMetadata()` 반환값. v30.0+.

| 필드 | 타입 | 설명 |
|---|---|---|
| `errors` | Error[] | 실패 시 오류 배열 |
| `fullName` | string | 처리된 컴포넌트의 전체 이름 |
| `success` | boolean | 성공 여부 |

---

## DeleteResult

`deleteMetadata()` 반환값. v30.0+.

| 필드 | 타입 | 설명 |
|---|---|---|
| `errors` | Error[] | 실패 시 오류 배열 |
| `fullName` | string | 삭제된 컴포넌트의 전체 이름 |
| `success` | boolean | 성공 여부 |

---

## UpsertResult

`upsertMetadata()` 반환값. v31.0+.

| 필드 | 타입 | 설명 |
|---|---|---|
| `created` | boolean | 새로 생성됐으면 true, 업데이트면 false |
| `errors` | Error[] | 실패 시 오류 배열 |
| `fullName` | string | 처리된 컴포넌트의 전체 이름 |
| `success` | boolean | 성공 여부 |

---

## Error 객체

CRUD 호출 실패 시 SaveResult/DeleteResult/UpsertResult에 포함.

| 필드 | 타입 | 설명 |
|---|---|---|
| `extendedErrorDetails` | ExtendedErrorDetails | 추가 오류 상세 (향후 사용 예약) |
| `fields` | string[] | 오류 관련 필드 이름 배열 |
| `message` | string | 오류 메시지 텍스트 |
| `statusCode` | StatusCode | 오류 상태 코드 (SOAP API Guide 참조) |

---

## ReadResult

`readMetadata()` 반환값. v30.0+.

| 필드 | 타입 | 설명 |
|---|---|---|
| `records` | Metadata[] | 조회된 메타데이터 컴포넌트 배열 |

---

## 관련 노트

- [[Metadata API 개요]]
- [[Metadata API File-Based 호출]]
- [[Metadata API CRUD 호출]]
- [[Metadata API Utility Calls]]
- [[Metadata API Headers]]

- [[Metadata API 에러 처리]]
