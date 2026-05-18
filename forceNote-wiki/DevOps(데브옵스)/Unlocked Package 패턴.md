---
tags: [devops, unlocked-package, 2gp, packaging, package-version, sf-cli]
source: sfdx_dev.pdf v67.0 Summer '26 — Chapter 13
created: 2026-05-18
aliases: [Unlocked Package, 2GP, second-generation package, sf package, 언락드 패키지]
---

# Unlocked Package 패턴

> 내부 비즈니스 앱 배포에 최적화된 소스 중심 패키지. AppExchange 배포가 아니면 이것을 선택.

---

## Unlocked Package vs Managed Package

| | Unlocked Package | Managed Package (2GP) |
|---|---|---|
| 대상 | 내부 앱 | AppExchange 배포 |
| 메타데이터 수정 | 설치 후 Production에서 수정 가능 | 잠김 규칙 있음 |
| 네임스페이스 | 선택 사항 | 필수 |
| 의존성 선언 | ✅ | ✅ |

---

## 사전 조건

```
✅ Dev Hub 활성화
✅ Second-Generation Managed Packaging 활성화
✅ Salesforce CLI 설치
✅ Create and Update Second-Generation Packages 권한
```

---

## 패키지 개발 흐름

```
sf package create          — 패키지 생성 (1회)
    ↓
sf package version create  — 버전 생성 (반복)
    ↓
테스트 (Scratch Org에 install)
    ↓
sf package install         — 대상 Org에 설치
```

---

## 핵심 명령

### 1. 패키지 생성

```bash
sf package create \
  --name "Expense Manager" \
  --path force-app \
  --package-type Unlocked \
  --target-dev-hub DevHub

# Org-Dependent Unlocked Package (의존성 검증을 설치 시로 연기)
sf package create \
  --type Unlocked \
  --path force-app \
  --name MyPackage \
  --org-dependent
```

### 2. 패키지 버전 생성

```bash
sf package version create \
  --package "Expense Manager" \
  --installation-key test1234 \
  --wait 10 \
  --target-dev-hub DevHub

# 특정 디렉토리 지정
sf package version create \
  --package "Expense Manager" \
  --directory common \
  --installation-key "JSB7s8vXU93fI" \
  --wait 10

# 설치 키 없이 (bypass)
sf package version create \
  --package "Expense Manager" \
  --installation-key-bypass \
  --wait 10
```

### 3. 패키지 설치

```bash
# 버전 별칭으로 설치
sf package install \
  --package "Expense Manager@0.1.0-1" \
  --target-org MyTestOrg1

# 설치 키로 설치
sf package install \
  --package "Expense Manager" \
  --installation-key "JSB7s8vXU93fI" \
  --target-org MyScratch

# 버전 ID(04t...)로 설치
sf package install \
  --package 04t6A0000004eytQAA \
  --target-org MyOrg
```

### 4. 버전 업데이트

```bash
sf package version update \
  --package "Expense Manager@1.2.0-4" \
  --installation-key "NewKey123"
```

### 5. 조회

```bash
# 패키지 목록
sf package list --target-dev-hub DevHub

# 버전 생성 상태 확인
sf package version create report \
  --package-create-request-id 08cxx00000000BEAAY

# 버전 목록
sf package version list \
  --packages "Expense Manager" \
  --target-dev-hub DevHub
```

---

## sfdx-project.json 패키지 설정

```json
{
  "packageDirectories": [
    {
      "path": "force-app",
      "default": true,
      "package": "Expense Manager",
      "versionName": "Spring 2026",
      "versionNumber": "1.2.0.NEXT",
      "definitionFile": "config/project-scratch-def.json",
      "dependencies": [
        {
          "package": "Foundation Package",
          "versionNumber": "2.0.0.LATEST"
        }
      ]
    },
    {
      "path": "my-unpackaged-directory"
    }
  ],
  "namespace": "",
  "sfdcLoginUrl": "https://login.salesforce.com",
  "sourceApiVersion": "63.0",
  "packageAliases": {
    "Expense Manager": "0Hoxx00000000CqCAI",
    "Expense Manager@1.2.0-4": "04t6A0000004eytQAA"
  }
}
```

---

## Package ID 종류

| ID 예시 | 종류 | 용도 |
|---|---|---|
| `033J0000...` | Subscriber Package ID | Salesforce 지원 문의 시 |
| `04t6A0000...` | Subscriber Package Version ID | 설치 시 사용 |
| `0Ho...` | Package ID | 버전 생성 시 사용 (`sf package version create`) |
| `08c...` | Version Creation Request ID | 생성 요청 상태 추적 |

---

## Org-Dependent Unlocked Package

기존 Production org 메타데이터에 의존하는 패키지. 모든 의존성을 정리하지 않고도 패키징 가능.

| | 일반 Unlocked | Org-Dependent |
|---|---|---|
| 어디든 설치 | ✅ | ❌ (의존 org에만) |
| 의존성 검증 시점 | 버전 생성 시 | 설치 시 |
| 레거시 org 마이그레이션 | 어려움 | 용이 |

```bash
sf package create -t Unlocked -r force-app -n MyPackage --org-dependent
```

---

## 베스트 프랙티스

```
✅ Dev Hub는 하나만 사용 (Production org 권장)
✅ 네임스페이스: 테스트는 임시 ns, 실제 배포는 실제 ns
✅ --tag 옵션으로 VCS 태그와 패키지 버전 동기화
✅ sfdx-project.json에 packageAliases로 ID 관리
✅ Dev Hub org가 만료되면 패키지 업데이트 불가 → 주의
✅ 비-namespace 패키지는 namespace org에 설치 불가
```

---

## apexTestAccess — 테스트 접근 권한

```json
"apexTestAccess": {
  "permissionSets": [
    "Permission_Set_1",
    "Permission_Set_2"
  ],
  "permissionSetLicenses": [
    "SalesConsoleUser"
  ]
}
```

---

## 관련 노트

- [[Salesforce DX 개요]] — sfdx-project.json, sf CLI 기본
- [[Scratch Org 패턴]] — 버전 생성 시 Scratch Org 사용
- [[CI CD 패턴]] — 패키지 버전 생성 자동화
