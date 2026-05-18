---
tags: [devops, scratch-org, dev-hub, org-shape, snapshot, source-tracking]
source: sfdx_dev.pdf v67.0 Summer '26 — Chapter 6
created: 2026-05-18
aliases: [Scratch Org, scratch org, org create scratch, Dev Hub, Org Shape, Snapshot]
---

# Scratch Org 패턴

> 소스 중심 일시적 org. 설정 파일(JSON)로 재현 가능하며 자동화 테스트에 최적.

---

## Scratch Org란

- Dev Hub org에서 생성하는 disposable 개발 org
- 수명: 최대 30일 (기본 7일). 만료 후 자동 삭제
- Source tracking 기본 활성화
- 공유 가능한 정의 파일(JSON)로 팀 전체 동일 환경 보장
- 개인 데이터 저장 금지

---

## Scratch Org 생성 명령

```bash
sf org create scratch \
  --definition-file config/project-scratch-def.json \
  --set-default \
  --alias MyScratch \
  --duration-days 30 \
  --target-dev-hub DevHub

# 스냅샷 기반 생성
sf org create scratch \
  --snapshot <snapshot_name> \
  --set-default \
  --alias MyScratch
```

---

## project-scratch-def.json (정의 파일)

```json
{
  "orgName": "My Dev Org",
  "edition": "Developer",
  "features": [
    "EnableSetPasswordInApi",
    "ScratchOrg"
  ],
  "settings": {
    "lightningExperienceSettings": {
      "enableS1DesktopEnabled": true
    },
    "mobileSettings": {
      "enableS1EncryptedStoragePref2": false
    }
  },
  "hasSampleData": false
}
```

### 주요 옵션

| 옵션 | 필수 | 설명 |
|---|---|---|
| `edition` | ✅ | Developer / Enterprise / Group / Professional 등 |
| `orgName` | — | 조직명 |
| `features` | — | 활성화할 기능 목록 |
| `settings` | — | Org 설정값 |
| `hasSampleData` | — | 샘플 데이터 포함 여부 (기본 false) |
| `release` | — | `preview` / `previous` (릴리스 전환 기간만) |
| `language` | — | 기본 언어 |
| `country` | — | ISO-3166 2자리 국가 코드 |

### edition 종류

| 값 | 설명 |
|---|---|
| `Developer` | 가장 일반적 |
| `Enterprise` | Enterprise 기능 포함 |
| `Professional` | Professional 에디션 |
| `Partner Developer` | Partner 전용 |

---

## 주요 Scratch Org 관리 명령

```bash
# 목록 확인
sf org list

# 상세 정보
sf org display --target-org MyScratch

# Org 열기 (브라우저)
sf org open --target-org MyScratch

# 삭제
sf org delete scratch --target-org MyScratch --no-prompt

# 소스 배포 → Scratch Org
sf project deploy start --target-org MyScratch

# Scratch Org → 로컬 소스 가져오기
sf project retrieve start --target-org MyScratch

# Permission Set 할당
sf org assign permset --name MyPermSet --target-org MyScratch
```

---

## Org Shape — 실제 Org 복제

기존 Org 구성을 기반으로 Scratch Org를 생성한다.

```bash
# Org Shape 생성
sf org create shape --target-org ProductionOrg

# Shape 기반 Scratch Org 생성
sf org create scratch \
  --definition-file config/project-scratch-def.json \
  --target-dev-hub DevHub

# project-scratch-def.json에서 shape 지정
{
  "edition": "Enterprise",
  "sourceOrg": "<production_org_id>"
}
```

### Org Shape vs Snapshot

| | Org Shape | Scratch Org Snapshot |
|---|---|---|
| 포함 내용 | Org 설정·기능만 | 설정 + 설치된 패키지 + 메타데이터 + 데이터 |
| 생성 시간 | 빠름 | 느림 (내용에 비례) |
| 업데이트 | Org 변경 시 자동 반영 | 삭제 후 재생성 필요 |
| 네임스페이스 | 지원 | `--no-namespace`로 생성 후 Scratch에서 네임스페이스 적용 |

---

## Scratch Org Snapshot

특정 시점 상태를 캡처. 반복적으로 동일한 환경 필요 시 사용.

```bash
# 스냅샷 생성
sf org create snapshot \
  --name dhsnapshot \
  --source-org dreamhouse-scratch \
  --target-dev-hub my-dev-hub \
  --description "Dreamhouse app"

# 스냅샷 목록
sf org list snapshot --target-dev-hub DevHub

# 스냅샷 상세
sf org get snapshot --snapshot dhsnapshot --target-dev-hub DevHub

# 스냅샷 삭제
sf org delete snapshot --snapshot dhsnapshot --target-dev-hub DevHub
```

> 스냅샷 이름: 최대 15자, 영숫자만 허용.

### 스냅샷으로 Scratch Org 생성

```bash
sf org create scratch \
  --snapshot dhsnapshot \
  --target-dev-hub DevHub \
  --set-default \
  --alias SnapScratch
```

### 스냅샷으로 Package Version 생성

```bash
sf package version create \
  --package "My Package" \
  --source-org dhsnapshot \
  --wait 10
```

---

## Source Tracking 제어

```bash
# Source tracking 없이 생성 (대용량 배포 시 성능 향상)
sf org create scratch \
  --definition-file config/project-scratch-def.json \
  --no-track-source

# Sandbox에서 Source Tracking 활성화 (Developer/Developer Pro Sandbox)
# Setup → Sandbox → Edit → Enable Source Tracking 체크
```

---

## Scratch Org 활용 시나리오

```
새 기능 개발:
  sf org create scratch → 코딩 → sf project deploy start
  → sf apex run test → (완료) sf org delete scratch

CI 파이프라인:
  JWT 인증 → sf org create scratch --duration-days 1
  → sf project deploy start → sf apex run test
  → sf org delete scratch
```

---

## 관련 노트

- [[Salesforce DX 개요]] — sf CLI, sfdx-project.json 설정
- [[Unlocked Package 패턴]] — Scratch Org를 이용한 패키징
- [[CI CD 패턴]] — Scratch Org + Jenkins / CircleCI
