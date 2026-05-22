---
tags: [devops, salesforce-dx, sfdx, sf-cli, project-setup, scratch-org, source-tracking]
source: sfdx_dev.pdf v67.0 Summer '26 — Chapter 1–5, 8
created: 2026-05-18
aliases: [Salesforce DX, SFDX, sf CLI, sfdx-project.json, source format, DevOps]
---

# Salesforce DX 개요

> 소스 중심 개발 환경. scratch org + sf CLI + VCS = 재현 가능한 Salesforce 배포.

---

## 핵심 개념

| 개념 | 설명 |
|---|---|
| **Dev Hub** | scratch org를 생성하는 부모 org. 보통 production org |
| **Scratch Org** | 일시적 disposable 개발 org. 소스로 완전 재구성 가능 |
| **Source Tracking** | 로컬 파일 ↔ org 간 변경 추적. Scratch org 기본 활성화 |
| **Source Format** | Metadata API XML을 파일별로 분해한 DX 전용 형식 |
| **sfdx-project.json** | DX 프로젝트 메인 설정 파일 |

---

## 프로젝트 생성 & 기본 워크플로

```bash
# 1. 프로젝트 생성
sf project generate --name MyProject --template standard

# 2. Dev Hub 인증
sf org login web --set-default-dev-hub --alias DevHub

# 3. Scratch Org 생성
sf org create scratch \
  --definition-file config/project-scratch-def.json \
  --set-default \
  --alias MyScratch \
  --duration-days 30

# 4. Org 목록 확인
sf org list

# 5. 소스 배포 (로컬 → org)
sf project deploy start --source-dir force-app

# 6. 소스 가져오기 (org → 로컬)
sf project retrieve start

# 7. Org 열기
sf org open
sf org open --target-org MyScratch

# 8. Apex 테스트 실행
sf apex run test --result-format human --wait 1

# 9. 데이터 Import
sf data import tree --plan data/sample-data-plan.json
```

---

## sfdx-project.json 구조

```json
{
  "packageDirectories": [
    { "path": "force-app", "default": true },
    { "path": "unpackaged" },
    { "path": "utils" }
  ],
  "namespace": "",
  "sfdcLoginUrl": "https://login.salesforce.com",
  "sourceApiVersion": "63.0"
}
```

### 주요 필드

| 필드 | 필수 | 설명 |
|---|---|---|
| `packageDirectories` | ✅ | 배포 대상 디렉토리 목록. `default: true` 하나 필수 |
| `namespace` | ✅ | 패키지 네임스페이스. 비어 있으면 namespaced 없음 |
| `sourceApiVersion` | ✅ | API 버전 |
| `sfdcLoginUrl` | — | 로그인 URL. My Domain 사용 권장 |
| `plugins` | — | 커스텀 플러그인 설정값 |
| `packageAliases` | — | 패키지 ID 별칭 (2GP 전용) |

---

## Source Format — 분해(Decompose) 구조

DX는 대형 XML 파일을 파일별로 분해해 VCS에서 병합 충돌을 줄인다.

### 기본 분해 (자동)

| 메타데이터 | 분해 단위 |
|---|---|
| Custom Object | 필드, 유효성검사, 레이아웃 등 개별 파일 |
| Custom Object Translation | 마찬가지 |

### 선택적 분해 (Beta, 명시 설정 필요)

| 메타데이터 | 분해 방식 |
|---|---|
| Custom Labels | 레이블별 `*.label-meta.xml` |
| Permission Sets | `objectSettings/`, `flowAccesses-meta.xml` 등 |
| Sharing Rules | `sharingCriteriaRules/`, `sharingOwnerRules/` 등 |
| Workflows | `workflowAlerts/`, `workflowRules/` 등 |
| External Service Registrations | `.yaml` + `-meta.xml` 2개 |

```bash
# 선택적 분해 활성화
sf project convert source-behavior \
  --behavior decomposePermissionSetBeta2 \
  --dry-run    # 실제 변경 없이 미리보기
sf project convert source-behavior \
  --behavior decomposePermissionSetBeta2  # 실제 적용
```

---

## .forceignore

`.gitignore` 문법과 동일. `project deploy/retrieve` 시 제외할 파일 지정.

```
# 예시
**/NotUsedProfile.profile-meta.xml
**/*.lwc.css
**/lwc/**/*.json
```

---

## Authorization (인증) 방식

### 브라우저 인증 (대화형)

```bash
sf org login web --set-default-dev-hub --alias DevHub
```

### JWT 인증 (CI/CD 환경)

```bash
sf org login jwt \
  --client-id <consumer_key> \
  --jwt-key-file server.key \
  --username <username> \
  --set-default-dev-hub
```

필요 준비: Connected App, 개인 키 + 자체 서명 인증서

### SFDX Authorization URL

```bash
sf org display --verbose  # Auth URL 확인
sf org login sfdx-url --sfdx-url-file auth_url.txt
```

---

## Source Tracking (소스 추적)

| 명령 | 설명 |
|---|---|
| `sf project deploy start` | 변경된 소스만 org에 배포 |
| `sf project retrieve start` | org 변경 내용을 로컬로 가져오기 |
| `sf project deploy preview` | 배포 대상 미리보기 (실제 배포 없음) |
| `sf project deploy start --ignore-conflicts` | 충돌 무시하고 배포 |

```bash
# 특정 메타데이터만 배포
sf project deploy start --metadata ApexClass
sf project deploy start --source-dir es-base-custom

# 무시된 파일 목록 확인
sf project list ignored --source-dir force-app/main/default
```

---

## 프로젝트 구조

```
MyProject/
├── config/
│   └── project-scratch-def.json   — Scratch org 정의 파일
├── force-app/
│   └── main/default/
│       ├── classes/              — Apex
│       ├── lwc/                  — LWC
│       ├── flows/                — Flow
│       ├── objects/              — Custom Objects (분해됨)
│       └── layouts/              — Layouts
├── .forceignore                  — 제외 파일 패턴
├── .gitignore
└── sfdx-project.json             — 프로젝트 설정
```

---

## 관련 노트

- [[Scratch Org 패턴]] — scratch org 생성, 설정, 스냅샷
- [[Unlocked Package 패턴]] — 패키지 생성·버전·배포
- [[CI CD 패턴]] — Jenkins, CircleCI 연동
- [[MetadataAPI/Metadata API 개요]] — Metadata API 직접 사용법 (deploy/retrieve SOAP+REST)
