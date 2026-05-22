---
tags: [devops, salesforce-dx, sandbox, sandbox-definition-file, org-create-sandbox, sandbox-clone, sandbox-refresh]
source: sfdx_dev.pdf (Salesforce DX Developer Guide v67.0)
created: 2026-05-23
aliases: [Sandbox CLI 관리, sandbox-def.json, org create sandbox, org refresh sandbox, org clone sandbox, Sandbox 생성 CLI, Sandbox 갱신]
---

# Sandbox 관리

> Salesforce CLI로 Sandbox를 프로그래밍 방식으로 생성·복제·갱신·삭제하는 전수 절차 — sandbox-def.json 설정 전수 포함.

---

## 개요

Sandbox는 Production 데이터와 앱을 건드리지 않고 개발·테스트·교육에 사용하는 Salesforce Org 복사본이다. CLI를 통해 Sandbox를 자동화하면 CI/CD 파이프라인에 통합하거나 팀 환경을 반복적으로 재현할 수 있다.

JWT 및 Web 기반 인증 플로우는 Dev Hub 대신 **Sandbox 라이선스가 있는 Production Org**를 사용한다.

Sandbox 대안: Scratch Org(개발), Developer Edition Org(개인 개발)

---

## Production Org 인증

Sandbox CLI 작업 전에 Production Org를 먼저 인증한다.

```bash
# JWT Flow 사용 시 sfdcLoginUrl에 login.salesforce.com 사용
# instance-url 플래그로 직접 지정도 가능 (sfdx-project.json 값보다 우선)
sf org login jwt \
  --instance-url https://login.salesforce.com \
  --client-id <consumer_key> \
  --jwt-key-file server.key \
  --username <production_username>
```

Production Org 인증 팁:
- `sfdx-project.json`의 `sfdcLoginUrl`은 `https://login.salesforce.com` 지정
- Dev Hub 지정 불필요 (`--set-default-dev-hub` 사용 안 함)
- Connected App은 **Production Org에** 생성해야 함

---

## Sandbox Definition File (sandbox-def.json)

Sandbox Definition File은 생성할 Sandbox의 구성을 정의하는 청사진이다. Salesforce DX 프로젝트의 `config/` 디렉토리에 저장하며, `*-sandbox-def.json` 형식으로 파일명을 지정하는 것을 권장한다.

### 전체 설정 옵션

| 옵션 | 필수 여부 | 설명 |
|---|---|---|
| `sandboxName` | Yes | 고유한 영숫자 문자열 (최대 10자). 삭제 중인 이름은 재사용 불가 |
| `licenseType` | Yes (생성 시) | `Developer`, `Developer_Pro`, `Partial`, `Full` 중 하나. `licenseType`, `sourceSandboxName`, `sourceId` 중 하나만 지정 |
| `sourceId` | Yes (복제 시) | 복제할 Sandbox의 ID. `licenseType`, `sourceSandboxName`, `sourceId` 중 하나만 지정 |
| `sourceSandboxName` | Yes (복제 시) | 복제할 Sandbox 이름. `licenseType`, `sourceSandboxName`, `sourceId` 중 하나만 지정 |
| `templateId` | Yes (Partial용), 선택 (Full) | 샌드박스 템플릿의 15자 ID (URL의 1ps로 시작). Developer/Developer Pro에는 사용 불가 |
| `activationUserGroupId` | No | 접근 가능한 공개 그룹의 ID. `activationUserGroupName`과 동시 지정 불가 |
| `activationUserGroupName` | No | 접근 가능한 공개 그룹 이름. `activationUserGroupId`와 동시 지정 불가 |
| `apexClassId` | No | Sandbox 복사 후 실행할 Apex 클래스 ID. `apexClassName`과 동시 지정 불가 |
| `apexClassName` | No | Sandbox 복사 후 실행할 Apex 클래스 이름. `apexClassId`와 동시 지정 불가 |
| `autoActivate` | No | `true`면 Sandbox Refresh를 즉시 활성화 가능 |
| `copyArchivedActivities` | No | Full Sandbox 전용. 아카이브된 활동 복사 여부 (추가 옵션 필요) |
| `copyChatter` | No | `true`면 아카이브된 Chatter 데이터를 Sandbox에 복사 |
| `description` | No | Sandbox 설명 (최대 1000자) |
| `features` | No | 추가 기능 목록. 복제 시에는 불필요. 현재 유효한 값: `['SandboxStorage']` — Developer 200MB→400MB, Developer Pro 1GB→2GB 증가. Partial/Full에는 사용 불가 |
| `historyDays` | No | Full Sandbox 전용. 복사할 오브젝트 히스토리 일수. 유효값: `-1`(전체), `0`(기본), `10`, `20`, `30`, `60`, `90`, `120`, `150`, `180` |

### 샘플 Definition File

```json
// 기본 Developer Sandbox 생성
{
  "sandboxName": "dev1",
  "licenseType": "Developer"
}
```

```json
// Sandbox 복제
{
  "sandboxName": "dev1clone",
  "sourceSandboxName": "dev1"
}
```

```json
// features 옵션으로 스토리지 확장
{
  "sandboxName": "dev1",
  "licenseType": "Developer",
  "features": "['SandboxStorage']"
}
```

```json
// Full Sandbox — 히스토리 30일, 아카이브 데이터 포함
{
  "sandboxName": "fullsbx",
  "licenseType": "Full",
  "historyDays": 30,
  "copyArchivedActivities": true,
  "description": "Production 복제본 — 회귀 테스트용"
}
```

---

## Sandbox 생성 (Create)

### 사전 조건

```
1. manifest 파일을 포함한 Salesforce DX 프로젝트 생성
2. 사용 가능한 Sandbox 라이선스가 있는 Production Org에 인증
3. Sandbox Definition File 생성
```

### CLI 명령

```bash
# Definition File 사용
sf org create sandbox \
  --target-org prodOrg \
  --definition-file config/dev-sandbox-def.json \
  --alias MyDevSandbox \
  --set-default \
  --wait 30

# 직접 옵션 지정 (Definition File 오버라이드 또는 대체)
sf org create sandbox \
  --name FullSbx \
  --license-type Full \
  --target-org prodOrg \
  --alias MyFullSandbox \
  --wait 30
```

주요 플래그:
- `--target-org`: Production Org의 사용자명 또는 별칭
- `--alias`: Sandbox에 지정할 별칭 (나중에 지정도 가능: `sf alias set MyDevSandbox username@company.com.dev1`)
- `--set-default`: 이 Sandbox를 기본 Org로 설정
- `--wait`: 완료 대기 시간 (분). 기본 6분. 대기열 처리로 더 오래 걸릴 수 있으므로 30분 이상 권장

### 생성 상태 확인

명령이 타임아웃되면 상태 확인:

```bash
sf org resume sandbox \
  --job-id 0GR1888880000HORuWAO \
  --target-org prodOrg
```

생성 완료 시 CLI가 자동으로 Sandbox에 인증. `org list`에 Sandbox 표시.

팀원 인증:
```bash
sf org web login --instance-url https://test.salesforce.com
```

### 왜 별칭(Alias)을 권장하는가

Sandbox 생성 시 자동 생성되는 사용자명은 `username@company.com.dev1` 형태다. 고유성 충돌 시 `00x7Vqusername@company.com.dev1`처럼 복잡해진다. 별칭으로 관리하면 기억하기 쉽고 명령 실행이 빨라진다.

---

## Sandbox 복제 (Clone)

기존 Sandbox를 복제해 데이터와 메타데이터를 새 Sandbox에 복사한다. 같은 Production Org에 연결된 Sandbox 간에만 복제 가능하다.

```bash
sf org create sandbox \
  --source-sandbox-name FullSbx \
  --name NewSbx \
  --target-org prodOrg \
  --alias MyDevSandbox \
  --set-default \
  --wait 30
```

또는 ID로 지정:
```bash
# --source-id로 소스 Sandbox ID 지정
sf org create sandbox \
  --source-id 0GQ1Q000000xxx \
  --name NewSbx \
  --target-org prodOrg \
  --wait 30
```

복제 상태 확인:
```bash
sf org resume sandbox \
  --job-id 0GR1888880000HORuWAO \
  --target-org prodOrg
```

---

## Sandbox Refresh (갱신)

기존 Sandbox를 소스 Org에서 최신 메타데이터로 갱신한다. 복제 Sandbox나 템플릿 기반 Sandbox는 데이터도 갱신된다.

```bash
sf org refresh sandbox \
  --name FullSbx \
  --target-org prodOrg
```

주의사항:
- `--name`은 Sandbox의 **이름**을 지정 (별칭 아님)
- `--target-org`는 소스 Org의 사용자명 또는 별칭
- 설정 변경 시 `--definition-file` 추가 (sandboxName은 변경 불가)
- Sandbox 이름을 변경하려면: `org delete sandbox` → `org create sandbox`로 새 이름 생성

```bash
# 설정 변경하며 갱신
sf org refresh sandbox \
  --name FullSbx \
  --target-org prodOrg \
  --definition-file config/full-sandbox-def.json
```

---

## Sandbox 삭제 (Delete)

`org create sandbox` 또는 `org login`으로 생성·인증한 Sandbox를 삭제할 수 있다. Production Org에도 미리 인증되어 있어야 한다.

```bash
sf org delete sandbox --target-org MyDevSandbox
```

---

## Sandbox Open

Sandbox가 준비된 후 별칭이나 사용자명으로 열기:

```bash
sf org open --target-org MyDevSandbox
```

CLI가 인증 정보를 관리하므로 비밀번호 입력 불필요.

---

## 다음 단계 (Sandbox 생성 후)

```bash
# 메타데이터 검색
sf project retrieve start --target-org MyDevSandbox

# 변경 사항 배포
sf project deploy start --target-org MyDevSandbox
```

---

## 관련 노트

- [[DX 도구 접근 권한]] — Sandbox 생성에 필요한 권한 (Manage Dev Sandboxes 등)
- [[DX 인증 방식]] — JWT Flow 및 Web 기반 인증 방법
- [[Source Tracking 변경 추적]] — Sandbox에서 Source Tracking 활성화 후 사용
- [[Scratch Org 생성과 정의 파일]] — Sandbox 대안으로 Scratch Org 활용
- [[Metadata API 빌드·릴리스 워크플로]] — Sandbox를 활용한 배포 파이프라인
- [[DX 데이터 작업]] — Sandbox 간 데이터 이동·로드 (data tree·bulk)
