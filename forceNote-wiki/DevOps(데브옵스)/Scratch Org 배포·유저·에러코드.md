---
tags: [devops, scratch-org, deploy, retrieve, users, error-codes, source-tracking, project-deploy, project-retrieve]
source: sfdx_dev.pdf v67.0 Summer '26 — Chapter 6
created: 2026-05-22
aliases: [Scratch Org Deploy, project deploy start, project retrieve start, org create user, Scratch Org Users, Scratch Org Error Codes, error codes]
---

# Scratch Org 배포·유저·에러코드

> Scratch org로 소스 배포(Deploy)·검색(Retrieve) 전수, 유저 관리 명령 전수, Error Codes 전수표.

---

## Deploy Source — Scratch Org로 소스 배포

### 개요

로컬 소스 변경사항을 scratch org에 동기화. Source tracking이 활성화된 경우 변경된 항목만 자동 감지.

```bash
# Source tracking 없이 scratch org 생성 (배포 속도 향상 목적)
sf org create scratch --definition-file config/project-scratch-def.json --no-track-source
```

### 배포 미리보기 (Preview)

```bash
# 기본 미리보기 (기본 scratch org)
sf project deploy preview --target-org MyGroovyScratchOrg

# manifest 파일 기반 미리보기
sf project deploy preview --manifest package.xml --target-org test-am6xqkossaq8@example.com
```

- 배포될 컴포넌트 목록
- 잠재적 충돌 항목
- .forceignore로 제외될 파일 목록 표시

### 배포 실행

```bash
# 변경된 소스 전체 배포 (기본 scratch org)
sf project deploy start

# 특정 메타데이터 타입 배포
sf project deploy start --metadata ApexClass

# manifest 파일 기반 배포
sf project deploy start --manifest package.xml

# 특정 소스 디렉토리 배포
sf project deploy start --source-dir force-app/main/default/classes

# 대상 org 명시
sf project deploy start --target-org MyScratchOrg
```

**배포 결과 출력 예시:**
```
Deploying v58.0 metadata to test-am6xqkossaq8@example.com using the v59.0 SOAP API.
Deploy ID: 0Af7e00001WsuoSCAR
Status: Succeeded | ████████████████████████████████████████ | 1/1 Components (Errors:0) | 0/0 Tests (Errors:0)
Deployed Source
=====================================================================================================
State   Name                Type       Path
─────── ─────────────────── ───────── ──────────────────────────────────────────────────────────────
Changed PropertyController  ApexClass force-app/main/default/classes/PropertyController.cls
Changed PropertyController  ApexClass force-app/main/default/classes/PropertyController.cls-meta.xml
```

### 경고/충돌 처리

```bash
# 경고 무시하고 배포 (예: 오래된 API 버전 경고)
sf project deploy start --ignore-warnings

# 충돌 무시하고 로컬 변경사항으로 덮어쓰기
sf project deploy start --ignore-conflicts
```

**충돌 감지 출력 예시:**
```
STATE    FULL NAME          TYPE      FILE PATH
──────── ────────────────── ───────── ──────────────────────────────────────────
Conflict PropertyController ApexClass <dir>/force-app/main/default/classes/PropertyController.cls-meta.xml
Conflict PropertyController ApexClass <dir>/force-app/main/default/classes/PropertyController.cls
Error (1): There are changes in the org that conflict with the local changes you're trying to deploy.
```

**충돌 해결 선택:**
- 로컬 변경사항 유지: `sf project deploy start --ignore-conflicts`
- org 변경사항 유지: `sf project retrieve start --ignore-conflicts`

### .forceignore 사용

배포 및 검색에서 제외할 파일을 `.forceignore`에 추가.

---

## Retrieve Source — Scratch Org에서 소스 가져오기

### 검색 미리보기 (Preview)

```bash
# 기본 미리보기
sf project retrieve preview --target-org MyGroovyScratchOrg
```

### 검색 실행

```bash
# 변경된 소스 전체 검색 (기본 scratch org)
sf project retrieve start

# 특정 메타데이터 타입
sf project retrieve start --metadata ApexClass

# manifest 파일 기반
sf project retrieve start --manifest package.xml

# 특정 소스 디렉토리
sf project retrieve start --source-dir force-app/main/default/classes

# 대상 org 명시
sf project retrieve start --target-org MyScratchOrg
```

**검색 결과 출력 예시:**
```
Preparing retrieve request...
Preparing retrieve request... Succeeded
Retrieved Source
====================================================================================================================
State   Name             Type           Path
─────── ──────────────── ────────────── ─────────────────────────────────────────────────────────────────────────
Created DiscountSpecial  ApexClass      force-app/main/default/classes/DiscountSpecial.cls
Created DiscountSpecial  ApexClass      force-app/main/default/classes/DiscountSpecial.cls-meta.xml
Created DiscountPermSet  PermissionSet  force-app/main/default/permissionsets/DiscountPermSet.permissionset-meta.xml
```

### 충돌 처리

```bash
# 충돌 감지 출력:
# STATE    FULL NAME          TYPE      FILE PATH
# ──────── ────────────────── ───────── ──────────────
# Conflict PropertyController ApexClass <dir>force-app/...
# Error (1): There are changes in your local files that conflict with the org changes you're trying to retrieve.

# org 변경사항 유지 (검색 강행)
sf project retrieve start --ignore-conflicts

# 로컬 변경사항 유지 (배포 강행)
sf project deploy start --ignore-conflicts
```

---

## Scratch Org Users — 유저 관리

### 개요

Scratch org는 기본적으로 어드민 사용자 1명으로 시작. 다양한 프로필/권한 세트 테스트를 위해 추가 사용자 생성 가능.

### Scratch Org User 한도 및 제한사항

- `sf org create user`는 scratch org 전용 (비scratch org에서 실행 시 실패)
- 사용자 라이선스 수는 scratch org 에디션에 따라 결정 (예: Developer Edition = Salesforce 사용자 라이선스 최대 2개 → 어드민 1명 + 표준 사용자 1명)
- username은 Salesforce 전체 생태계에서 고유해야 함 (이메일 형식)
- 사용자 삭제 불가 (CLI/Setup 모두). Scratch org 삭제 시 자동 비활성화
- 비활성화된 username은 재사용 불가
- 자동 생성 기본값: username = `<타임스탬프>_<admin-username>`, profile = Standard User
- 새 사용자 생성 후 Salesforce CLI가 자동으로 scratch org에 인증
- Hyperforce 한도: Dev Hub 인증에 JWT flow 사용 + scratch org가 Hyperforce에 있는 경우 사용자 생성 실패. `org login web` 또는 `org login sfdx-url`로 Dev Hub 인증 필요

### 사용자 로그인 방법

| 조건 | 로그인 URL |
|---|---|
| 기본 어드민 사용자 (모든 인프라) | test.salesforce.com 또는 My Domain URL (`https://MyDomainName.scratch.my.salesforce.com`) |
| 일반 사용자 (Salesforce 1st-party 인스턴스) | test.salesforce.com 또는 My Domain URL |
| 일반 사용자 (Hyperforce 인스턴스) | My Domain URL만 허용 |

인프라 확인: Company Information Setup 페이지의 Instance → status.salesforce.com 검색

---

### Create a Scratch Org User

```bash
# 기본 사용자 생성 (자동 생성 값 사용)
sf org create user --set-alias qa-user --target-org my-scratch

# 사용자 정의 파일 사용
sf org create user --set-alias qa-user --definition-file config/user-def.json

# 정의 파일 + 대상 org 명시
sf org create user \
  --set-alias qa-user \
  --definition-file config/user-def.json \
  --target-org my-scratch

# CLI에서 정의 파일 옵션 오버라이드
sf org create user --set-alias qa-user \
  --definition-file config/user-def.json \
  permsets="Dreamy,Cloudy" \
  Username=tester345@sfdx.org \
  generatePassword=false \
  --target-org my-scratch

# CLI에서 정의 파일에 없는 옵션 추가
sf org create user --set-alias qa-user \
  --definition-file config/user-def.json \
  City=Oakland \
  --target-org my-scratch
```

**생성 결과 출력:**
```
Successfully created user "1690397809_test-st9thgoyyyq3@example.com" with ID 0058I002inzvQAA
for org 00D80000PhAkUAK.
See more details about this user by running "sf org user display -o 1690397809774_test-st9thgoyyyq3@example.com".
```

**사용자 목록 조회:**
```bash
sf org list users --target-org my-scratch
# === Users in org 00D80000PhAkUAK
# Default Alias     Username                                    Profile Name        User Id
# ─────── ────────  ──────────────────────────────────────────  ──────────────────  ───────────────
# (A)     my-scratch test-st9thgoyyyq3@example.com              System Administrator 0058I002inzvQAA
#         qa-user    1690397809_test-st9thgoyyyq3@example.com   Standard User        0058I002inzvQAA
```

**사용자 상세 정보 조회:**
```bash
sf org display user --target-org qa-user
# === User Description
# key          label
# ──────────── ──────────────────────────────────────────────────────────────────
# Username     1690397809_test-st9thgoyyyq3@example.com
# Profile Name Standard User
# Id           0058I002inzvQAA
# Org Id       00D80000PhAkUAK
# Access Token 00D8I<truncated>
# Instance Url https://connect-enterprise-1121-dev-ed.scratch.my.salesforce.com
# Login Url    https://connect-enterprise-1121-dev-ed.scratch.my.salesforce.com
# Alias        qa-user
```

---

### User Definition File

사용자 정의 파일은 JSON 형식. Salesforce User 오브젝트 필드 + DX-specific 옵션 사용 가능.

**DX-specific 옵션 전수:**

| 옵션 | 타입 | 기본값 | 설명 |
|---|---|---|---|
| `permsets` | Array | 없음 | 할당할 권한 세트 배열. 쉼표 구분, 대괄호로 감쌈. 먼저 `project deploy start`로 scratch org에 배포 필요 |
| `generatePassword` | Boolean | `false` | 랜덤 비밀번호 생성 여부. `true`로 설정 시 생성 완료 후 비밀번호 표시. `org display user`로도 확인 가능 |
| `profileName` | String | `Standard User` | 프로필 이름 (User 오브젝트의 `ProfileId` 대신 이름 사용). `project deploy start`로 먼저 배포 필요 |
| `roleDeveloperName` | String | 없음 | 역할 API 이름 (`UserRole.DeveloperName`). `project deploy start`로 먼저 배포 필요 |

**작성 규칙:**
- DX-specific 옵션: lower camelCase 권장
- User 오브젝트 필드: upper camelCase 권장

**샘플 사용자 정의 파일:**
```json
{
  "Username": "tester1@sfdx.org",
  "LastName": "Hobbs",
  "Email": "tester1@sfdx.org",
  "Alias": "tester1",
  "TimeZoneSidKey": "America/Denver",
  "LocaleSidKey": "en_US",
  "EmailEncodingKey": "UTF-8",
  "LanguageLocaleKey": "en_US",
  "profileName": "Standard Platform User",
  "permsets": ["Dreamhouse", "Cloudhouse"],
  "generatePassword": true,
  "roleDeveloperName": "Customer_Support"
}
```

> `Username`은 Salesforce 전체에서 고유해야 함. `--set-unique-username` 플래그로 자동 고유화 권장.  
> 정의 파일의 `Alias`는 Salesforce UI용. CLI의 `--set-alias`는 로컬 CLI용 (별개).

---

### Generate or Change a Password

```bash
# 어드민 사용자 비밀번호 생성
sf org generate password --target-org <username-or-alias>

# 여러 사용자 동시에 비밀번호 생성 (--on-behalf-of 복수 지정)
sf org generate password \
  --target-org my-scratch \
  --on-behalf-of ci-user \
  --on-behalf-of qa-user

# 길이 지정 (기본 13자)
sf org generate password --target-org my-scratch --length 20

# 강도 지정 (0~5, 기본 5. 높을수록 복잡한 문자 조합)
sf org generate password --target-org my-scratch --complexity 5
```

**비밀번호 및 접속 정보 확인:**
```bash
sf org display user --target-org qa-user
# key          label
# ──────────── ────────────────────────────────────────────────────────────────────────
# Username     1690397809_test-st9thgoyyyq3@example.com
# Password     ogihymg%lXa
# Instance Url https://connect-enterprise-1121-dev-ed.scratch.my.salesforce.com
# ...
```

**로그인:**
- Instance URL을 브라우저에서 열기 → `Log In to Sandbox` 클릭
- UI에서 비밀번호 변경 시 `org display user` 출력에 반영되지 않음

**제한사항:**
- `org generate password`는 scratch org 사용자 전용
- CLI로 생성한 사용자(`org create user`)만 대상 (`--on-behalf-of` 사용 시)
- Setup에서 직접 생성한 사용자는 대상 불가

---

### Manage Scratch Orgs from Dev Hub

Dev Hub org에서 scratch org 목록 확인·삭제.

- `ActiveScratchOrg` 표준 오브젝트: 현재 활성 scratch org
- `ScratchOrgInfo` 표준 오브젝트: scratch org 생성 요청 이력

**Dev Hub UI에서 관리 절차:**
1. Dev Hub org에 System Administrator 또는 Salesforce DX 권한 사용자로 로그인
2. App Launcher → `Active Scratch Orgs` (활성 org 목록)
3. Number 컬럼 링크 클릭 → 상세 정보
4. 삭제: 드롭다운 → Delete
   - 활성 scratch org 삭제 시 생성 요청(ScratchOrgInfo)은 유지, 할당량은 해제
5. App Launcher → `Scratch Org Infos` (생성 요청 이력)
6. 요청 삭제: 드롭다운 → Delete (활성 scratch org도 함께 삭제됨)

---

## Scratch Org Error Codes

Scratch org 생성 실패 시 생성되는 오류 코드 전수. `SignupRequest` API의 일부는 모든 org signup에 공통 적용.

| 오류 코드 | 설명 | 해결 방법 |
|---|---|---|
| `C-1007` | 중복된 username | 다른 username 사용 |
| `C-1015` | My Domain (subdomain) 설정 중 오류 | Salesforce Support에 문의 |
| `C-1016` | OAuth connected app 구성 오류 (Proxy Signup) | connected app의 consumer key, callback URL, 인증서(만료 여부) 확인 |
| `C-1018` | 잘못된 subdomain 값 | 유효한 subdomain 값 사용 |
| `C-1019` | Subdomain 이미 사용 중 | 새 subdomain 값 선택 |
| `C-1020` | 템플릿 없음 (삭제되었거나 존재하지 않음) | 올바른 템플릿 확인 |
| `C-1033` | 잘못된 템플릿 버전 | 올바른 버전의 템플릿 사용 |
| `C-1034` | org 생성 불가 (일반 오류) | Salesforce Customer Support에 문의 |
| `C-9998` | 유효하지 않은 scratch org | Salesforce Customer Support에 문의 |
| `C-9999` | 일반 치명적 오류 | Salesforce Customer Support에 문의 |
| `S-1017` | Namespace 미등록. namespace를 scratch org와 함께 사용하려면 Developer Edition org에 등록된 namespace를 Dev Hub org에 연결해야 함 | 네임스페이스 연결: Setup → Dev Hub → Link Namespace |
| `S-2006` | 잘못된 국가 코드 | 올바른 ISO-3166 2자리 국가 코드 사용 |
| `SH-0001` | Org Shape 기반 scratch org 생성 불가. source org 어드민이 Dev Hub org ID 추가 안 함 | source org Setup → Org Shape → Dev Hub ID 추가 |
| `SH-0002` | 지정한 sourceOrg에 org shape 없음 | `sf org create shape --target-org <source>` 실행 후 재시도 |
| `SH-0003` | Org shape가 이전 Salesforce 릴리즈로 만들어져 outdated | Org shape 재생성 후 재시도 |
| `SN-0001` | Snapshot 만료됨 | 새 snapshot 생성 후 재시도 |
| `SN-0002` | Snapshot이 지정한 Dev Hub org에 속하지 않음 | 올바른 `--target-dev-hub` 사용 |
| `SH-9999` | Org shape 검증 중 치명적 오류 | Salesforce Customer Support에 문의 |
| `VR-0001` | Scratch org 생성 불가 (일시적) | 나중에 재시도 |
| `VR-0002` | Scratch org 생성 불가 (release 값 문제) | release 값 확인. 지정하지 않았으면 Salesforce Customer Support에 문의 |
| `VR-0003` | Scratch org 생성 불가 (release 값 문제) | release 값 확인. 지정하지 않았으면 Salesforce Customer Support에 문의 |

**오류 코드 접두사 의미:**
- `C-` : 일반 signup 오류
- `S-` : Namespace/SignupRequest 관련 오류
- `SH-` : Org Shape 관련 오류
- `SN-` : Snapshot 관련 오류
- `VR-` : 릴리즈 버전 관련 오류

---

## 관련 노트

- [[Scratch Org 생성과 정의 파일]] — Definition File 옵션 전수, Features 전수, 생성 명령
- [[Scratch Org Settings 레퍼런스]] — settings 블록 전수 옵션
- [[Org Shape와 Snapshot]] — Org Shape 생성·사용, Snapshot 전수
- [[Scratch Org 패턴]] — Scratch Org 개요·활용 시나리오 (요약)
- [[DX 인증 방식]] — JWT Flow·Hyperforce 인증 주의사항
- [[CI CD 패턴]] — CI 환경에서의 scratch org 활용
- [[Source Tracking 변경 추적]] — Source Tracking 전수 심층 레퍼런스 (org enable/disable tracking, Conflicts 해결, Profile 추적, Performance)
