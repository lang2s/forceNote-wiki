---
tags: [devops, salesforce-dx, source-tracking, sf-cli, conflict-resolution, deploy, retrieve, profiles, performance]
source: sfdx_dev.pdf v67.0 Summer '26 — Chapter 8
created: 2026-05-22
aliases: [Source Tracking, 소스 추적, 변경 추적, source track, project deploy preview, project retrieve preview, --ignore-conflicts, --no-track-source, org enable tracking, org disable tracking]
---

# Source Tracking 변경 추적

> 로컬 프로젝트와 Scratch Org·Sandbox 간 변경 내역을 자동으로 추적하고, Preview → Resolve Conflicts → Deploy/Retrieve 의 이터레이티브 워크플로를 지원하는 Salesforce CLI 핵심 기능.

---

## Source Tracking 개요

Source tracking은 org 자체에 직접 영향을 주지 않는다. Salesforce CLI가 **로컬 설정 파일**을 확인해 특정 org에 대해 소스 추적이 활성화되어 있는지 판단하고, 활성화되어 있으면 `project deploy start` 등의 명령 실행 시 추적 동작을 수행한다.

### Source Tracking이 가능한 기능

- 메타데이터 컴포넌트 변경 자동 추적 (수동 추적 불필요)
- 다른 개발자가 sandbox에 배포한 변경 내역 확인
- 변경된 소스만 선택적 배포·검색
- 로컬 프로젝트와 Scratch Org·Sandbox 간 충돌 식별 및 해결

Source tracking을 지원하는 메타데이터 컴포넌트 목록은 **Metadata Coverage Report**의 "Source Tracking" 컬럼에서 확인할 수 있다.

---

## Source Tracking 활성화 Org 에디션

| Org 유형 | Source Tracking 지원 여부 |
|---|---|
| Developer Edition org | ❌ 미지원 |
| Production org | ❌ 미지원 |
| Partial Copy sandbox | ❌ 미지원 |
| Full sandbox | ❌ 미지원 |
| Developer sandbox | ✅ 지원 (관련 production org가 활성화된 경우) |
| Developer Pro sandbox | ✅ 지원 (관련 production org가 활성화된 경우) |
| Scratch org | ✅ 항상 지원 |

Source tracking이 없는 org에서도 배포·검색은 가능하다. 단, 충돌 검사가 없고 `--source-dir` 또는 `--metadata` 플래그로 대상을 명시해야 한다.

---

## Manage Source Tracking

### 신규 Org에서 Source Tracking 관리

- **Scratch Org:** 기본으로 활성화
- **Developer·Developer Pro sandbox:** 관련 production org가 source tracking을 활성화했으면 기본으로 활성화

생성 시 `--no-track-source` 플래그를 지정해 source tracking을 비활성화할 수 있다. 이 플래그는 **로컬 설정에만** 영향을 미치며 org 자체는 변경되지 않는다. Salesforce CLI가 인증 정보의 일부로 `trackSource: false`를 로컬에 저장한다. 로그아웃 후 재로그인하면 source tracking이 다시 기본 활성화된다.

```bash
# Scratch Org 생성 시 source tracking 비활성화
sf org create scratch \
  --target-dev-hub=MyHub \
  --definition-file config/project-scratch-def.json \
  --no-track-source

# Sandbox 생성 시 source tracking 비활성화
sf org create sandbox \
  --definition-file config/dev-sandbox-def.json \
  --target-org prodOrg \
  --no-track-source
```

### 기존 Org에서 Source Tracking 관리

기존 Scratch Org 또는 sandbox에서 source tracking 활성화·비활성화 여부를 변경할 수 있다.

| 명령 | 동작 |
|---|---|
| `org enable tracking` | Salesforce CLI가 로컬 소스 파일 변경을 추적하도록 허용 |
| `org disable tracking` | Salesforce CLI의 변경 추적을 차단 |

```bash
# mySandbox org에서 source tracking 활성화
# source tracking을 지원하지 않는 org(Full sandbox 등)면 오류 반환
sf org enable tracking --target-org mySandbox

# mySandbox org에서 source tracking 비활성화
# 예: 통합 테스트용 sandbox에서 추적 대기 없이 빠른 배포가 필요한 경우
sf org disable tracking --target-org mySandbox
```

---

## Preview Changes Identified by Source Tracking

변경 내역을 확인하려면 프로젝트 디렉토리에서 preview 명령을 실행한다. 로컬에서 org로 배포할 수 있는 변경, 또는 org에서 로컬로 검색할 수 있는 변경 내역을 표시한다.

```bash
# 로컬 → org로 배포할 수 있는 변경 확인
sf project deploy preview --target-org DevSandbox

# org → 로컬로 검색할 수 있는 변경 확인
sf project retrieve preview --target-org DevSandbox

# 특정 메타데이터 타입만 미리보기
sf project deploy preview --metadata ApexClass --target-org DevSandbox
```

`project deploy preview` 명령은 `--metadata`, `--source-dir`, `--manifest` 플래그를 지원해 더 세밀한 배포 미리보기가 가능하다.

### Preview 출력 형식

출력 테이블은 3개 컬럼으로 구성된다:

| 컬럼 | 설명 |
|---|---|
| **Type** | 변경된 컴포넌트의 메타데이터 타입 (예: ApexClass, CustomObject) |
| **Fullname** | 컴포넌트의 API 이름 |
| **Path** | 로컬 프로젝트 내 파일 경로. 비어 있으면 해당 컴포넌트가 org에만 존재하고 로컬에는 없음 |

### Deploy Preview 출력 예시

```
sf project deploy preview --target-org DevSandbox
No conflicts found.
No files will be deleted.
Will Deploy [2] files.
Type         Fullname        Path
──────────── ───────────────────────────────────────────────────────────────────
ApexClass    WidgetClass     force-app/main/default/classes/WidgetClass.cls-meta.xml
CustomObject WidgetObject__c force-app/main/default/objects/WidgetObject__c/WidgetObject__c.object-meta.xml
No files were ignored. Update your .forceignore file if you want to ignore certain files.
```

### Retrieve Preview 출력 예시 (충돌 없음 + .forceignore 파일 포함)

```
sf project retrieve preview --target-org DevSandbox
No conflicts found.
No files will be deleted.
Will Retrieve [3] files.
Type         Fullname                           Path
──────────── ──────────────────────────────── ────
Layout       GizmoObject__c-GizmoObject Layout
CustomObject GizmoObject__c
ApexClass    GizmoClass

Ignored [2] files. These files won't retrieve because they're ignored by your .forceignore file.
Type    Fullname                          Path
─────── ───────────────────────────────── ────
Profile Admin
Profile B2B Reordering Portal Buyer Profile
```

### 변경 없을 때 출력

```
sf project retrieve preview
=== Source Status
No results found
```

---

## Deploy and Retrieve Changes Identified by Source Tracking

Source tracking은 저-코드(Setup에서 Custom Object 생성)와 고-코드(IDE에서 Apex 작성) 방식을 함께 사용할 때 변경 내역을 자동으로 추적하여 org와 로컬 소스를 동기화한다.

### 권장 이터레이션 워크플로

```
1. project retrieve preview → remote 변경 확인
2. 충돌 있으면 → 충돌 해결
3. project retrieve start → org 변경 내역을 로컬로 검색
4. Git에 push → 소스 컨트롤에 전체 변경 보관
5. project deploy start → 로컬 변경(Apex 등)을 org에 배포
6. 유효성 검사·테스트 후 반복
```

### Retrieve 실행 예시

```bash
# org의 변경 내역을 로컬로 검색
sf project retrieve start --target-org DevSandbox
```

```
Preparing retrieve request...
Sending request to org
Preparing retrieve request... Succeeded
Retrieved Source
=================================================================================
| State   Name                               Type         Path
| ─────── ──────────────────────────────── ─────────────────────────────────────
| Created GizmoClass                        ApexClass    force-app/main/default/classes/GizmoClass.cls
| Created GizmoClass                        ApexClass    force-app/main/default/classes/GizmoClass.cls-meta.xml
| Created GizmoObject__c                    CustomObject force-app/main/default/objects/GizmoObject__c/GizmoObject__c.object-meta.xml
| Created GizmoObject__c-GizmoObject Layout Layout       force-app/main/default/layouts/GizmoObject__c-GizmoObject Layout.layout-meta.xml
```

검색 후 `project retrieve preview`를 다시 실행하면 검색할 내용이 없다고 표시된다.

### Deploy 실행 예시

```bash
# 로컬 변경 내역을 org에 배포
sf project deploy start --target-org DevSandbox
```

```
Deploying v59.0 metadata to test-ikspctiorkzs@example.com using the v59.0 SOAP API.
Deploy ID: 0Af8D00000pNmKySAK
Status: Succeeded | ████████████████████████████████████████ | 2/2 Components (Errors:0)
                  | 0/0 Tests (Errors:0)
Deployed Source
=================================================================================
| State   Name           Type         Path
| ─────── ───────────── ─────────────────────────────────────────────────────────
| Created WidgetClass    ApexClass    force-app/main/default/classes/WidgetClass.cls
| Created WidgetClass    ApexClass    force-app/main/default/classes/WidgetClass.cls-meta.xml
| Created WidgetObject__c CustomObject force-app/main/default/objects/WidgetObject__c/WidgetObject__c.object-meta.xml
```

배포 후 `project deploy preview`를 재실행하면 배포할 파일이 없다고 표시된다. 이는 로컬 프로젝트와 org가 동기화되었음을 의미한다.

### 특정 메타데이터만 배포·검색

```bash
# Apex 클래스만 검색
sf project retrieve start --metadata ApexClass:MyFabClass

# 특정 소스 디렉토리만 배포
sf project deploy start --source-dir es-base-custom

# 무시된 파일 목록 확인
sf project list ignored --source-dir force-app/main/default
```

---

## Retrieve Changes to Profiles with Source Tracking

Profile 검색은 source tracking 활성화 여부에 따라 동작이 다르다.

> **중요:** 일반적으로 permission sets 사용을 권장한다. Profile은 org 유형·추적 상태·기타 메타데이터에 따라 검색·배포 결과가 달라지고 org 간 일관성이 없다. Profile을 계속 사용한다면 `.forceignore`에 추가해 배포·검색 시 제외하는 것을 권장한다.

### Source Tracking 비활성화 상태에서 Profile 검색

`package.xml`에 명시된 다른 항목과 관련된 profile 정보만 반환한다.

```xml
<!-- 이 package.xml로 retrieve 시 -->
<!-- Account.MyCustomField__c 커스텀 필드에 대한 profile 권한만 반환 -->
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
  <types>
    <members>Account.MyCustomField__c</members>
    <name>CustomField</name>
  </types>
  <types>
    <members>*</members>
    <name>Profile</name>
  </types>
  <version>50.0</version>
</Package>
```

### Source Tracking 활성화 상태에서 Profile 검색

`package.xml`에 명시된 항목 + **source tracking이 추적 중인 모든 변경 관련 컴포넌트**에 대한 profile 정보를 반환한다.

예시: 로컬에서 Opportunity 객체에 `OppCustomField__c` 커스텀 필드를 생성했다고 가정한다. source tracking이 이 변경을 감지한 상태에서 위와 동일한 `package.xml`로 profile을 검색하면, `package.xml`에 `OppCustomField__c`가 없더라도 source tracking이 추적 중이므로 `MyCustomField__c`(Account)와 `OppCustomField__c`(Opportunity) 두 커스텀 필드 모두에 대한 profile 권한이 반환된다.

> **노트:** source retrieve는 package.xml 파일 자체를 포함하지 않지만, retrieve 요청은 source tracking이 보고하는 모든 내용에 대한 profile 정보를 반환한다.

---

## Resolve Conflicts Between Your Local Project and Org

충돌이 있는 컴포넌트는 배포·검색 전에 반드시 해결한다. 충돌을 수동으로 해결하거나 한쪽 버전으로 덮어쓸 수 있다. **덮어쓰기는 해당 버전이 올바른 버전임을 확신할 때만 수행한다.**

### 충돌 감지

```bash
sf project deploy preview --target-org DevSandbox
```

```
Conflicts [1]. Run the command with the --ignore-conflicts flag to override.
Type      Fullname    Path
───────── ─────────── ────────────────────────────────────────────────────────────
ApexClass WidgetClass force-app/main/default/classes/WidgetClass.cls-meta.xml

No files will be deleted.
Will Deploy [1] files.
Type      Fullname   Path
───────── ────────── ────────────────────────────────────────────────────────────
ApexClass GizmoClass force-app/main/default/classes/GizmoClass.cls-meta.xml
```

충돌이 있는 상태에서 실제로 배포를 시도하면 Salesforce CLI가 다시 충돌을 보고하고 작업을 중단한다. `project retrieve preview`에서도 유사한 충돌 메시지가 나타난다.

### Overwrite Conflicting Changes — 시나리오별 해결 패턴

#### 시나리오 1: 로컬 버전이 정확 → org에 덮어쓰기

`--ignore-conflicts` 플래그와 함께 deploy를 실행해 로컬 버전으로 org를 덮어쓴다.

```bash
# 충돌 컴포넌트만 먼저 배포 (--ignore-conflicts 사용)
sf project deploy start \
  --metadata ApexClass:WidgetClass \
  --ignore-conflicts \
  --target-org DevSandbox
```

DevSandbox org가 로컬 프로젝트의 WidgetClass 버전을 갖게 된다. 이후 `project deploy preview`에서 충돌 메시지가 사라진다.

#### 시나리오 2: Org 버전이 정확 → 로컬에 덮어쓰기

`--ignore-conflicts` 플래그와 함께 retrieve를 실행해 org 버전으로 로컬을 덮어쓴다.

```bash
# org 버전으로 로컬을 덮어쓰기
sf project retrieve start \
  --metadata ApexClass:WidgetClass \
  --ignore-conflicts \
  --target-org DevSandbox
```

로컬 프로젝트가 org의 WidgetClass 버전을 갖게 된다.

#### 시나리오 3: 충돌 해결 후 나머지 배포

충돌 해결 후 특수 플래그 없이 일반 배포를 실행해 나머지 변경사항을 배포한다.

```bash
# 충돌 해결 완료 후 나머지 변경사항 배포
sf project deploy start --target-org DevSandbox
```

```
Deploying v59.0 metadata to test-ikspctiorkzs@example.com using the v59.0 SOAP API.
Deploy ID: 0Af8D00000pNtEUSA0
Status: Succeeded | ████████████████████████████████████████ | 1/1 Components (Errors:0)
                  | 0/0 Tests (Errors:0)
Deployed Source
=====================================================================================
| State   Name       Type      Path
| ─────── ────────── ─────────────────────────────────────────────────────────────────
| Created GizmoClass ApexClass force-app/main/default/classes/GizmoClass.cls
| Created GizmoClass ApexClass force-app/main/default/classes/GizmoClass.cls-meta.xml
```

---

## Best Practices

### 배포 전에 변경 내역을 검색하고 충돌을 해결하라

Sandbox에 배포하기 전에 `project retrieve preview` → `project retrieve start`를 통해 다른 개발자의 변경을 먼저 로컬로 반영하고 충돌을 해결한다. 이 방식이 협업과 변경 통합을 원활하게 한다.

### Git 같은 버전 관리 시스템으로 메타데이터 변경 이력을 관리하라

VCS를 사용하면 변경 이력을 추적하고, 다른 환경(sandbox 등)으로 프로모션하기 전에 메타데이터 변경을 검토할 수 있다.

### Source Tracking 파일 동기화 복구

Source tracking이 부정확한 보고를 시작하면 `project deploy|retrieve start` 명령으로 동기화를 복구할 수 있다.

- **로컬 소스를 신뢰할 때:** `project deploy start --ignore-conflicts`
- **Org 소스를 신뢰할 때:** `project retrieve start --ignore-conflicts`

```bash
# 로컬 소스가 정확 → org로 강제 동기화
sf project deploy start --ignore-conflicts --target-org mySandbox

# Org 소스가 정확 → 로컬로 강제 동기화
sf project retrieve start --ignore-conflicts --target-org mySandbox
```

---

## Performance Considerations of Source Tracking

Source tracking은 추가 함수를 실행해 소스 추적 컴포넌트의 변경 내역을 판단한다. 구체적으로는 더 많은 쿼리를 실행하고 배포 후 **SourceMember Tooling API 오브젝트**가 업데이트될 때까지 대기한다. 따라서 중~대형 프로젝트에서 일부 명령이 더 오래 걸릴 수 있다. 소형 프로젝트에서는 속도 저하가 눈에 띄지 않는다.

### 프로젝트 규모 기준

| 규모 | 컴포넌트 수 | 테스트 수 | 예시 |
|---|---|---|---|
| **소형** | 30개 미만 | 50개 미만 | 느린 속도 없음 |
| **중형** | 30개 이상 | 50개 이상 | 25 컴포넌트 + 51 테스트 = 중형 |
| **대형** | 600개 이상 | 150개 이상 | 610 컴포넌트 + 140 테스트 = 대형 |

조건은 **OR**이다. 컴포넌트 수가 30개 미만이더라도 테스트가 51개면 중형으로 분류된다.

### 성능 최적화 대책

```bash
# 1. 프로젝트를 작은 컴포넌트 집합으로 분리
# 2. 작은 집합을 개별 배포

# 3. Scratch Org·Sandbox 생성 시 source tracking 비활성화 (개발 환경 용도가 아닌 경우)
sf org create scratch \
  --target-dev-hub=MyHub \
  --definition-file config/project-scratch-def.json \
  --no-track-source

# 주의: DevOps Center용 개발 환경에서는 source tracking을 비활성화하지 않는다
```

> **주의:** DevOps Center를 사용하는 개발 환경용 Scratch Org·Sandbox는 source tracking을 비활성화하면 안 된다.

---

## 관련 노트

- [[Salesforce DX 개요]] — Source Tracking 개념 한 줄 수준 요약. 이 파일이 전수 심층 레퍼런스
- [[Scratch Org 배포·유저·에러코드]] — project deploy/retrieve start 전수 (--ignore-warnings, --ignore-conflicts, --no-track-source 플래그 포함)
- [[메타데이터 분해와 forceignore]] — .forceignore 문법·예제 전수 (Profile 등 특정 파일 제외 설정)
- [[DX 프로젝트 구조와 소스 포맷]] — Source Format 구조·패키지 디렉토리 설정
- [[Scratch Org 생성과 정의 파일]] — --no-track-source 플래그, Scratch Org Features 전수
- [[DX 도구 개요와 워크플로 전환]] — DX 전체 워크플로에서 source tracking 위치
- [[Metadata Coverage 보고서]] — 각 메타데이터 타입의 Source Tracking 지원 여부 공식 참조
- [[DX 제약사항]] — Source Tracking 관련 알려진 제약 (PersonAccount RecordType 등)
