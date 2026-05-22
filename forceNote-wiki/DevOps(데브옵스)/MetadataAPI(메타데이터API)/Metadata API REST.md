---
tags: [devops, metadata-api, rest, deployRequest, REST-deploy, sf-cli-rest, v67]
source: api_meta.pdf v67.0 Summer '26 — Chapter 6 (REST Resources)
created: 2026-05-22
aliases: [Metadata API REST, deployRequest, REST deploy, 메타데이터 REST 배포]
---

# Metadata API REST

> SOAP 대신 REST 방식으로 Metadata API 배포를 수행하는 `deployRequest` 리소스 레퍼런스. Summer '26 (v67.0).

---

## REST 배포 개요

Metadata API는 전통적으로 SOAP 방식을 사용하지만, REST 방식도 지원한다. 엔드포인트:

```
/services/data/vXX.0/metadata/deployRequest
```

**sf CLI로 REST 배포 모드 활성화:**
```bash
sf config set org-metadata-rest-deploy true
sf project deploy start --source-dir force-app --target-org myOrg
```

---

## POST — 배포 시작

```http
POST https://{instance}/services/data/v67.0/metadata/deployRequest
Content-Type: multipart/form-data; boundary="boundary_string"
Authorization: Bearer {session_id}

--boundary_string
Content-Disposition: form-data; name="json"
Content-Type: application/json

{
  "rollbackOnError": true,
  "testLevel": "RunLocalTests",
  "checkOnly": false
}
--boundary_string
Content-Disposition: form-data; name="file"; filename="deploy.zip"
Content-Type: application/zip

[ZIP 바이너리]
--boundary_string--
```

### 요청 본문 (JSON) 주요 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `allowMissingFiles` | boolean | 매니페스트에 있지만 zip에 없는 파일 허용 |
| `autoUpdatePackage` | boolean | 누락 컴포넌트 자동 추가 |
| `checkOnly` | boolean | 검증만 수행 (실제 저장 안 함) |
| `ignoreWarnings` | boolean | 경고 무시하고 계속 |
| `performRetrieve` | boolean | 배포 후 자동 retrieve |
| `purgeOnDelete` | boolean | 삭제 시 영구 삭제 |
| `rollbackOnError` | boolean | 오류 시 전체 롤백 |
| `runTests` | string[] | 지정 테스트 클래스 목록 |
| `singlePackage` | boolean | 단일 패키지 여부 |
| `testLevel` | string | 테스트 실행 수준 |

### 응답

```json
{
  "id": "0Af5f000001FgXXCAA",
  "done": false,
  "status": "Pending"
}
```

---

## GET — 배포 상태 조회

```http
GET https://{instance}/services/data/v67.0/metadata/deployRequest/{id}?includeDetails=true
Authorization: Bearer {session_id}
```

### 응답 예시

```json
{
  "id": "0Af5f000001FgXXCAA",
  "done": true,
  "status": "Succeeded",
  "success": true,
  "numberComponentsTotal": 15,
  "numberComponentsDeployed": 15,
  "numberComponentErrors": 0,
  "numberTestsTotal": 5,
  "numberTestsCompleted": 5,
  "numberTestErrors": 0,
  "details": {
    "componentSuccesses": [...],
    "runTestResult": {...}
  }
}
```

### 주요 응답 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `id` | string | 배포 작업 ID |
| `done` | boolean | 완료 여부 |
| `status` | string | 배포 상태 (Pending/InProgress/Succeeded/Failed 등) |
| `success` | boolean | 성공 여부 |
| `numberComponentsTotal` | int | 전체 컴포넌트 수 |
| `numberComponentsDeployed` | int | 배포 완료 컴포넌트 수 |
| `numberComponentErrors` | int | 오류 컴포넌트 수 |
| `numberTestsTotal` | int | 전체 테스트 수 |
| `numberTestsCompleted` | int | 완료된 테스트 수 |
| `numberTestErrors` | int | 실패한 테스트 수 |
| `errorMessage` | string | 오류 메시지 (실패 시) |
| `errorStatusCode` | string | 오류 상태 코드 |

---

## POST — 빠른 배포 (Quick Deploy)

`checkOnly=true`로 성공한 검증 ID를 사용해 테스트 없이 실제 배포:

```http
POST https://{instance}/services/data/v67.0/metadata/deployRequest/{validationId}
Authorization: Bearer {session_id}
Content-Type: application/json

{}
```

- `validationId` — `checkOnly=true` 배포의 ID (4일 이내)

---

## PATCH — 배포 취소

```http
PATCH https://{instance}/services/data/v67.0/metadata/deployRequest/{id}
Authorization: Bearer {session_id}
Content-Type: application/json

{
  "action": "cancel"
}
```

---

## curl 예제

```bash
# 1. 배포 시작
curl -s -X POST \
  "https://myinstance.salesforce.com/services/data/v67.0/metadata/deployRequest" \
  -H "Authorization: Bearer $SESSION_ID" \
  -F "json={\"rollbackOnError\":true,\"testLevel\":\"RunLocalTests\"};type=application/json" \
  -F "file=@deploy.zip;type=application/zip"

# 2. 상태 조회
curl -s -X GET \
  "https://myinstance.salesforce.com/services/data/v67.0/metadata/deployRequest/$DEPLOY_ID?includeDetails=true" \
  -H "Authorization: Bearer $SESSION_ID" | jq '.'

# 3. 취소
curl -s -X PATCH \
  "https://myinstance.salesforce.com/services/data/v67.0/metadata/deployRequest/$DEPLOY_ID" \
  -H "Authorization: Bearer $SESSION_ID" \
  -H "Content-Type: application/json" \
  -d '{"action":"cancel"}'
```

---

## DeployStatus 값 (REST/SOAP 공통)

| 상태 | 설명 |
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

## 관련 노트

- [[Metadata API 개요]]
- [[Metadata API File-Based 호출]]
- [[Metadata API Result Objects]]
- [[CI CD 패턴]]
