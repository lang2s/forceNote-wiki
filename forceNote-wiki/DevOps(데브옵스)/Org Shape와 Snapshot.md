---
tags: [devops, scratch-org, org-shape, snapshot, dev-hub, org-create-snapshot]
source: sfdx_dev.pdf v67.0 Summer '26 — Chapter 6
created: 2026-05-22
aliases: [Org Shape, Scratch Org Snapshot, org create shape, org create snapshot, sourceOrg, ShapeRepresentation]
---

# Org Shape와 Snapshot

> Org Shape 기반 scratch org 생성, Snapshot 생성·관리 전수. Org Shape는 실제 org 설정을 캡처하고, Snapshot은 scratch org의 특정 시점 상태를 저장.

---

## Org Shape vs Snapshot

| 항목 | Org Shape | Scratch Org Snapshot |
|---|---|---|
| 포함 내용 | Metadata API 설정(boolean)·에디션·라이선스·한도 | 설치된 패키지·기능·한도·라이선스·메타데이터·데이터 |
| 생성 소스 | 실제 production/sandbox org | 기존 scratch org (namespace 없어야 함) |
| 생성 시간 | 빠름 | scratch org 크기에 비례 (느릴 수 있음) |
| 업데이트 방법 | source org 변경 후 재캡처 (1회에 1개 활성) | 삭제 후 새로 생성 (정적 snapshot) |
| 네임스페이스 | 지원 | 반드시 namespace 없는 scratch org로 생성 후, 생성된 scratch org에서 적용 |
| 포함 안 되는 것 | integer/string 필드 settings, metadata types, data | connected apps, external credentials, named credentials |
| 만료 | 없음 (source org가 만료되면 error) | 90일 |
| 데이터 보존 | N/A | 만료 후 10일, 삭제 후 100일 |
| 사용 | `sourceOrg` 옵션으로 scratch org 생성 | `snapshot` 옵션으로 scratch org 생성 |

---

## Org Shape for Scratch Orgs

### 개요

실제 org(보통 production org)의 기능·설정·에디션·라이선스·한도를 기반으로 scratch org를 생성하는 기능. scratch org definition file을 수동으로 작성하지 않아도 됨.

**포함:**
- Metadata API settings (boolean 필드)
- 라이선스 (설치된 패키지와 연관, 단 패키지 자체는 미포함)
- 에디션, 한도

**미포함 (수동 추가 필요):**
- Metadata API settings의 integer·string 필드
- Metadata types
- Data
- 보안/법적 이유로 의도적으로 제외된 features:
  - `Chatbot`
  - `DevOpsCenter`
  - `MultiCurrency`
  - `PersonAccounts`

**Org Shape 특성:**
- Scratch org shape는 특정 Salesforce 릴리즈와 연관됨. source org가 새 릴리즈로 업그레이드된 후 반드시 재캡처
- Org shape 파일은 내부 시스템 파일이며 조회 불가
- 한 org에서 하나의 활성 shape만 유지 가능

**사용 가능 에디션:** Developer, Group, Professional, Unlimited, Enterprise (source org)
**사용 불가:** Scratch orgs, Sandboxes (source org로)

---

### Enable Org Shape (활성화 절차)

**Dev Hub org에서 활성화:**
1. Dev Hub org 어드민 계정으로 로그인
2. Setup → Quick Find: `Scratch Orgs` → Scratch Orgs 선택
3. `Enable Org Shape for Scratch Orgs` 토글 활성화
4. 텍스트 박스에 Dev Hub의 15자리 org ID 입력 → Save

**Source org (Dev Hub와 다른 경우)에서 활성화:**
1. Source org에 로그인
2. 동일하게 Setup → Scratch Orgs → Enable Org Shape 활성화
3. Dev Hub org의 15자리 ID 입력 (최대 50개 Dev Hub org ID 지정 가능)

> 중요: Org ID는 18자리가 표준이지만 Org Shape 기능에서는 **앞 15자리만** 사용

---

### Org Shape Permissions

Dev Hub org 어드민이 사용자에게 권한 할당 필요.

| 작업 | 필요 권한 |
|---|---|
| Org Shape 생성 | Object Settings > Shape Representation > Create, Edit |
| Org Shape 삭제 | Object Settings > Shape Representation > Delete |
| Org Shape 기반 scratch org 생성 | 기본 scratch org 생성 권한으로 충분 (추가 권한 불필요) |

- 다른 사용자가 생성한 shape는 `Modify All Records` 없이도 삭제 가능 (활성 shape는 org당 1개이므로)
- 지원 라이선스: Salesforce 라이선스만 (다른 사용자 라이선스 미지원)

---

### Create and Manage Org Shapes

```bash
# Dev Hub org와 source org 각각 인증
sf auth web login --alias <source-org-alias>
sf auth web login --alias <dev-hub-alias>

# Org Shape 생성 (비동기 프로세스 시작)
sf org create shape --target-org <source org username/alias>
# 출력 예:
# Successfully created org shape for 3SRB0000000TXbnOCG.

# Shape 생성 상태 확인
sf org list shape
# 예시 출력:
# === Org Shapes
# ALIAS  USERNAME   ORG ID             SHAPE STATUS  CREATED BY   CREATED DATE
# ────── ──────── ─────────────────── ────────────  ────────────  ────────────
# SrcOrg me@my.org 00DB1230000Ifx5MAC InProgress   me@my.org    2020-08-06
#
# (Active 상태가 되면 사용 가능)
# SrcOrg me@my.org 00DB1230000Ifx5MAC Active       me@my.org    2020-08-06

# Org Shape 삭제
sf org delete shape --target-org <username/alias>
```

---

### Scratch Org Definition for Org Shape

#### 단순 정의 파일 (Dev Hub, source org, shape 모두 동일 버전)

```json
{
  "orgName": "Acme",
  "sourceOrg": "00DB1230400Ifx5"
}
```

> `sourceOrg`에는 15자리 org ID 사용. `edition` 대신 지정.

#### 릴리즈 전환 기간 정의 파일

Dev Hub org와 source org가 서로 다른 버전일 때:

```json
{
  "orgName": "Acme",
  "sourceOrg": "00DB1230400Ifx5",
  "release": "previous"
}
```

| Source Org 버전 | Dev Hub 버전 | 지원 Scratch Org 버전 | 사용할 release 옵션 |
|---|---|---|---|
| Current | Preview | Current만 | `"release": "previous"` |
| Preview | Current | Preview만 | `"release": "preview"` |

#### DevOps Center 추가 (법적 이유로 수동 명시 필요)

```json
{
  "orgName": "Acme",
  "sourceOrg": "00DB1230400Ifx5",
  "features": ["DevOpsCenter"],
  "settings": {
    "devHubSettings": {
      "enableDevOpsCenterGA": true
    }
  }
}
```

#### 추가 features/settings 포함

```json
{
  "orgName": "Acme",
  "sourceOrg": "00DB1230000Ifx5",
  "features": ["Communities", "ServiceCloud", "Chatbot"],
  "settings": {
    "communitiesSettings": {
      "enableNetworksEnabled": true
    },
    "mobileSettings": {
      "enableS1EncryptedStoragePref2": true
    },
    "omniChannelSettings": {
      "enableOmniChannel": true
    },
    "caseSettings": {
      "systemUserEmail": "support@acme.com"
    }
  }
}
```

---

### Troubleshoot Org Shape

**일부 features가 org shape에서 캡처되지 않는 경우:**
- `Chatbot`, `DevOpsCenter`, `MultiCurrency`, `PersonAccounts`는 보안·법적 이유로 의도적으로 제외
- 해결: scratch org definition file에 수동 추가

```json
{
  "orgName": "Acme",
  "sourceOrg": "00DB1230400Ifx5",
  "features": ["Chatbot", "MultiCurrency", "DevOpsCenter"],
  "settings": {
    "botSettings": { "enableBots": true },
    "currencySettings": { "enableMultiCurrency": true },
    "devHubSettings": { "enableDevOpsCenterGA": true }
  }
}
```

**Field Service Enhanced Scheduling/Optimization이 미적용되는 경우:**

시나리오 1: org shape에 두 기능 모두 포함된 경우 → `o2EngineEnabled` 추가:
```json
"settings": {
  "fieldServiceSettings": {
    "fieldServiceOrgPref": true,
    "o2EngineEnabled": true
  }
}
```

시나리오 2: Field Service Integration만 포함된 경우 → `optimizationServiceAccess` 추가:
```json
"settings": {
  "fieldServiceSettings": {
    "fieldServiceOrgPref": true,
    "optimizationServiceAccess": true
  }
}
```

**Shift Status 피클리스트 미입력 (Field Service):**
```json
{
  "orgName": "Acme",
  "sourceOrg": "00DB1230000Ifx5",
  "settings": {
    "fieldServiceSettings": {
      "fieldServiceOrgPref": true
    }
  }
}
```

**기타 오류:**

| 오류 | 설명 | 해결책 |
|---|---|---|
| `Can't create scratch org from org shape` | source org 어드민이 Dev Hub org ID 추가 안 함 | source org Setup → Org Shape에서 Dev Hub ID 추가 |
| `No org shape exists for the specified sourceOrg` | 지정한 sourceOrg에 org shape 없음 | `sf org create shape` 실행 후 재시도 |
| `org shape was created on a previous Salesforce release version` | org shape가 이전 릴리즈로 만들어짐 | 재캡처 후 재시도 |
| `A fatal signup error occurred` | shape 기반 생성 중 치명적 오류 | `sf org create shape` 재실행 후 재시도 |
| `Can't create a Digital Experience Cloud Site Using Org Shape` | Experience Cloud Site 포함 org shape로 생성 시 오류 | 해결책 없음 (Known limitation) |
| `ERROR running org list shape: inactive user / expired access/refresh token` | org shape 소스로 사용한 trial org 만료 | `sf org logout` 후 `sf org list shape` 재실행 |
| Org Shape에 15자리 org ID만 허용 | 18자리 전체 사용 시 오류 | 앞 15자리만 사용 |

---

## Scratch Org Snapshots

### 개요

Scratch org의 특정 시점 상태를 캡처하여 동일한 환경을 빠르게 복제. Snapshot에는 설치된 패키지·기능·한도·라이선스·메타데이터·데이터가 포함됨.

**핵심 특성:**
- 정적(static): 소스 scratch org를 계속 수정해도 snapshot에 반영되지 않음. 스냅샷 생성 전 scratch org 설정 완료 필수
- Dev Hub와 연결됨: 동일한 Dev Hub org만 사용 가능
- 200 MB 데이터 스토리지 한도 (scratch org와 동일)
- Snapshot은 소스 중심 개발이나 버전 컨트롤 시스템을 대체하지 않음

**미포함 (보안·인증 비밀 노출 위험):**
- Connected apps
- External credentials
- Named credentials

**개발 라이프사이클 활용:**
- 프로젝트 의존성이 안정적인 경우 snapshot으로 scratch org 복제 시간 단축
- CI/CD에서 패키지 버전 생성 속도 향상
- 단, snapshot은 의존성·패키지·테스트 데이터만 포함 (production org의 전체 데이터 아님)

---

### Snapshot Allocations

Dev Hub 에디션별 snapshot 할당량 (active + daily 동일):

| Dev Hub Edition | Snapshot 할당 |
|---|---|
| Developer Edition | 3 |
| Enterprise Edition | 40 |
| Unlimited Edition | 100 |
| Performance Edition | 100 |

- Snapshot 만료 후 90일, 또는 삭제 시 라이선스 즉시 회수
- Snapshot 데이터 보존: 만료 시 10일 후 삭제, 삭제 시 생성일로부터 100일 후 삭제

할당량 확인:
```bash
sf org list limits -o <Dev Hub username or alias>
# 출력:
# Name                 Remaining  Max
# ───────────────────  ─────────  ─────
# ActiveOrgSnapshots   38         40
# DailyOrgSnapshots    35         40
```

---

### Get Started with Scratch Org Snapshots (활성화 절차)

1. Salesforce CLI 설치
2. Dev Hub 활성화 (production org에서)
3. Dev Hub org 인증
4. **Dev Hub org에서 Scratch Org Snapshots 활성화:**
   - Dev Hub org 어드민으로 로그인
   - Setup → Quick Find: `Scratch Orgs` → Scratch Orgs
   - `Enable Scratch Org Snapshots` 토글 클릭
5. 비어드민 사용자에게 라이선스·권한 할당

**비어드민 사용자 권한 할당 절차:**
1. Dev Hub org 어드민으로 로그인
2. 각 snapshot 사용자에게 Salesforce / Salesforce Platform / Salesforce Limited Access 라이선스 할당
3. Setup → Permission Set 생성 또는 선택
4. Object Settings → Org Snapshots → Edit
   - Read, Create, Delete 선택
   - (선택) View All Records: 다른 사용자의 snapshot 조회
   - (선택) Modify All Records (Salesforce 라이선스 전용): 다른 사용자의 snapshot 삭제
5. Scratch Org Info, Active Scratch Orgs 오브젝트 접근권한도 추가 (없는 경우)
6. Save → Manage Assignments → Add Assignment → 사용자 선택 → Assign

---

### Salesforce CLI Snapshot Commands

```bash
# Snapshot 생성
sf org create snapshot --name <name> \
  --source-org <ID or alias of scratch org> \
  --target-dev-hub <username or alias of Dev Hub org> \
  --description <text>

# Snapshot 삭제 (이름으로)
sf org delete snapshot --snapshot <name or ID> --target-dev-hub <username or alias>

# Snapshot 상세 정보 조회
sf org get snapshot --snapshot <name or ID> --target-dev-hub <username or alias>

# Dev Hub의 모든 Snapshot 목록
sf org list snapshot --target-dev-hub <username or alias>

# 도움말
sf org create snapshot --help
```

---

### Create a Scratch Org Snapshot (상세)

**전제 조건:**
- 소스 scratch org가 snapshot으로 생성되지 않아야 함
- 소스 scratch org에 namespace가 없어야 함

```bash
# 예시: Dreamhouse 앱 snapshot 생성
sf org create snapshot \
  --name dhsnapshot \
  --source-org dreamhouse-scratch \
  --target-dev-hub my-dev-hub \
  --description "Dreamhouse app"
```

**Snapshot 이름 규칙:**
- 최대 15자
- 영숫자만 허용 (특수문자·공백 불가, 따옴표 안에 넣어도 불가)

**생성 요청 직후 출력 (InProgress 상태):**
```
Name               Value
────────────────── ────────────────────
Id                 0Oo1Q0000004C93SXX
Snapshot Name      dhsnapshot
Description        Dreamhouse app
Status             InProgress
Source Org         00D050000004ipAEXX
Created Date       09/22/2023, 02:07 PM
Last Modified Date 09/22/2023, 02:07 PM
Expiration Date    2023-12-21
```

**Active 상태 확인 (사용 가능):**
```bash
sf org get snapshot --snapshot dhsnapshot --target-dev-hub my-dev-hub
# Name               Value
# ────────────────── ────────────────────
# Status             Active
# ...
# Expiration Date    2024-09-21
# Last Cloned Date
# Last Cloned By Id
```

---

### Namespaced Scratch Org Snapshot 생성

Namespaced scratch org는 snapshot 소스로 사용 불가. 단, snapshot에서 namespaced scratch org 생성은 가능.

```bash
# 1. Dev Hub org에 namespace 등록 + sfdx-project.json에 추가
# 2. --no-namespace 플래그로 scratch org 생성 (namespace 없이)
sf org create scratch --definition-file config/project-scratch-def.json --no-namespace

# 3. Snapshot 생성
sf org create snapshot --name dhsnapshot --source-org no-ns-scratch ...

# 4. Snapshot 기반 scratch org 생성 (이 org는 namespace를 가짐)
sf org create scratch --definition-file config/dhsnapshot-scratch-def.json
# 결과: sfdx-project.json의 namespace가 적용된 scratch org 생성
# snapshot의 unpackaged metadata가 이 scratch org에서 namespaced됨
```

---

### Create a Scratch Org Based on a Snapshot

**Scratch org definition file 작성:**

```json
{
  "orgName": "Salesforce",
  "snapshot": "dhsnapshot"
}
```

**포함하지 말아야 할 옵션:**
- `edition`
- `features`
- `hasSampleData`
- `release`
- `sourceOrg`

**기본 설정을 오버라이드하려면 settings 추가:**

```json
{
  "orgName": "Salesforce",
  "snapshot": "dhsnapshot",
  "settings": {
    "activitiesSettings": {
      "enableCalendarHomeLWC": false
    },
    "omniChannelSettings": {
      "enableOmniSkillRouting": true,
      "enableOmniChannel": true
    },
    "experienceBundleSettings": {
      "enableExperienceBundleMetadata": true
    },
    "oauthOidcSettings": {
      "blockOAuthUnPwFlow": true
    },
    "mobileSettings": {
      "enableS1EncryptedStoragePref2": false
    },
    "securitySettings": {
      "lockerServiceNext": false
    }
  }
}
```

**Snapshot 기반 scratch org 생성 명령:**

```bash
# 정의 파일 사용 (--wait 값 증가 권장, snapshot 기반은 더 오래 걸림)
sf org create scratch \
  --definition-file config/dhsnapshot-scratch-def.json \
  --alias dh-scratch-ci \
  --wait 10 \
  --target-dev-hub my-dev-hub

# --snapshot 플래그 직접 사용 (정의 파일 없이)
sf org create scratch \
  --snapshot dhsnapshot \
  --alias dh-scratch-ci \
  --wait 10 \
  --target-dev-hub my-dev-hub

# Namespace 제어
# sfdx-project.json에 namespace 정의 시 → 생성된 org에 namespace 적용
# --no-namespace 플래그 → namespace 없이 생성 (sfdx-project.json 설정 무시)
sf org create scratch \
  --snapshot dhsnapshot \
  --no-namespace \
  --target-dev-hub my-dev-hub
```

> 참고: Pooled Org Admin이 생성자로 표시될 수 있음 (성능 최적화를 위한 사전 구성 org 풀 사용)

---

### Snapshot 릴리즈 버전 결정

Snapshot 기반 scratch org의 릴리즈 버전은 Dev Hub와 snapshot 버전 조합에 따라 결정됨:

| Dev Hub 버전 | Snapshot 버전 | 생성되는 Scratch Org 버전 |
|---|---|---|
| Current | Current | Current |
| Current | Preview | Preview |
| Preview | Current | Current |
| Preview | Preview | Preview |

---

### Create a Package Version Based on a Snapshot

2GP 파트너/ISV가 기본 패키지 의존성이 있는 경우 snapshot을 사용하면 패키지 버전 생성 시간 대폭 단축.

**작동 원리:**
- 패키지 버전 생성 시 Salesforce CLI는 내부적으로 build org(scratch org)를 생성
- 일반 방법: 매번 의존성 패키지를 build org에 설치 (시간 소요)
- Snapshot 방법: 이미 패키지가 설치된 snapshot 기반으로 build org 생성 → 설치 단계 건너뜀

**중요 제한:**
- Snapshot 기반 관리 패키지 버전은 **promoted(릴리즈 상태)로 승격 불가**
  - snapshot에 패키지와 무관한 unpackaged metadata가 포함될 수 있어 고객 push upgrade 시 문제 가능
  - 릴리즈를 위해서는 snapshot 없이 패키지 버전 빌드 필요
- 단, **Unlocked Package는 snapshot 기반으로 promoted 가능**

---

### Manage and Maintain Your Snapshots

```bash
# 상태 확인 (InProgress → Active 될 때까지 확인)
sf org get snapshot --snapshot <name or ID> --target-dev-hub <username or alias>

# 전체 목록 조회
# 어드민: Dev Hub의 모든 snapshot 조회
# 일반 사용자: 자신의 snapshot만 (View All Records 권한 없으면)
sf org list snapshot --target-dev-hub <username or alias>

# 삭제 (이름으로)
sf org delete snapshot --snapshot dhsnapshot --target-dev-hub my-dev-hub

# 삭제 (ID로)
sf org delete snapshot --snapshot 0OoWt00000000A1BCD --target-dev-hub my-dev-hub
```

**삭제 권한:**
- Dev Hub 어드민: 모든 snapshot 삭제 가능
- 일반 사용자: 자신이 생성한 snapshot만 (Modify All Records 없으면)

**삭제 후:** 라이선스 즉시 회수, 연관 데이터는 생성일로부터 100일 후 삭제

---

## 관련 노트

- [[Scratch Org 생성과 정의 파일]] — Definition File 옵션 전수, Features 전수, 생성 명령
- [[Scratch Org Settings 레퍼런스]] — settings 블록 전수 옵션
- [[Scratch Org 배포·유저·에러코드]] — Deploy/Retrieve, Users 관리, Error Codes
- [[Scratch Org 패턴]] — Scratch Org 개요·활용 시나리오 (요약)
- [[Unlocked Package 패턴]] — Snapshot 기반 패키지 버전 생성
