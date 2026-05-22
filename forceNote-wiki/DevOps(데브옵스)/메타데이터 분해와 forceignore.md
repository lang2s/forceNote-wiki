---
tags: [devops, salesforce-dx, sfdx, decomposed-metadata, forceignore, source-format, metadata-types]
source: sfdx_dev.pdf v67.0 Summer '26 — Chapter 3 (Project Setup, p.30–45)
created: 2026-05-22
aliases: [Decomposed Metadata Types, forceignore, .forceignore, 메타데이터 분해, decompose, source-behavior, decomposePermissionSetBeta2]
---

# 메타데이터 분해와 forceignore

> Salesforce DX의 분해(Decompose) 메타데이터 타입 전수 레퍼런스 및 `.forceignore` 문법·예제 전수.

---

## 분해(Decomposition) 개념

**분해(Decomposition)** 란 하나의 크고 단일한 메타데이터 XML 파일을 서브타입 기반으로 더 작은 XML 파일들로 쪼개는 것을 말한다. 그 결과가 소스 포맷(Source Format)이다.

- **기본 분해(Default Decomposition):** Custom Objects, Custom Object Translations — DX 프로젝트에서 항상 자동 분해
- **선택적 분해(Optional Decomposition, Beta):** Custom Labels, External Service Registrations, Permission Sets, Sharing Rules, Workflows — `sfdx-project.json` 설정 또는 `project convert source-behavior` 명령으로 활성화

---

## 선택적 분해 활성화 방법 (Beta)

> **주의:** Permission Sets, Custom Labels, Sharing Rules, Workflows 분해는 Beta/Pilot 서비스이며 Beta Services Terms 또는 Unified Pilot Agreement가 적용된다.

### 사전 준비

```bash
# 모든 DX 프로젝트 소스 파일을 VCS에 커밋 (변경 추적 및 롤백을 위해 필수)
git add .
git commit -m "pre-decompose backup"
```

### dry-run으로 미리보기

```bash
# Permission Sets dry-run 예시
sf project convert source-behavior --behavior decomposePermissionSetBeta2 --dry-run
```

### 실제 적용

```bash
# Permission Sets 분해 활성화
sf project convert source-behavior --behavior decomposePermissionSetBeta2

# Custom Labels 분해 활성화
sf project convert source-behavior --behavior decomposeCustomLabelsBeta2

# External Service Registrations 분해 활성화
sf project convert source-behavior --behavior decomposeExternalServiceRegistrationBeta

# Sharing Rules 분해 활성화
sf project convert source-behavior --behavior decomposeSharingRulesBeta

# Workflows 분해 활성화
sf project convert source-behavior --behavior decomposeWorkflowBeta
```

> 명령 실행 후 `sfdx-project.json`의 `sourceBehaviorOptions`가 자동 업데이트되고, 로컬 패키지 디렉토리의 기존 소스 파일이 새 분해 형식으로 변환된다.

> 기본 org가 소스 추적 활성화 상태이면 에러가 반환된다. 이는 의도된 동작으로, 에러 메시지의 안내를 따른다.

### 롤백 방법

변경 마음이 바뀌면 `project convert source-behavior`가 만든 변경을 되돌리고 소스 추적 org를 재생성한다.

---

## 분해 메타데이터 타입 전수 목록

| 메타데이터 타입 | `--behavior` 플래그 값 | 분해 방식 |
|---|---|---|
| **CustomObject** | 불필요 (기본 분해) | 기본 자동 분해 |
| **CustomObjectTranslation** | 불필요 (기본 분해) | 기본 자동 분해 |
| **CustomLabels** | `decomposeCustomLabelsBeta2` | Beta — 명시 설정 필요 |
| **ExternalServiceRegistration** | `decomposeExternalServiceRegistrationBeta` | Beta — 명시 설정 필요 |
| **PermissionSet** | `decomposePermissionSetBeta2` | Beta — 명시 설정 필요 |
| **SharingRules** | `decomposeSharingRulesBeta` | Beta — 명시 설정 필요 |
| **Workflow** | `decomposeWorkflowBeta` | Beta — 명시 설정 필요 |

---

## 분해 타입별 소스 포맷 구조 상세

### Custom Objects (기본 분해)

저장 위치: `<package-directory>/main/default/objects/`

각 오브젝트는 자체 서브디렉토리를 갖는다. 다음 서브타입이 각각의 서브디렉토리로 분리된다:

```
objects/
└── MyObject__c/
    ├── MyObject__c.object-meta.xml      — 분리되지 않은 나머지 정보
    ├── businessProcesses/
    ├── compactLayouts/
    ├── fields/
    │   └── MyField__c.field-meta.xml
    ├── fieldSets/
    ├── indexes/
    ├── listViews/
    ├── recordTypes/
    ├── sharingReasons/
    ├── validationRules/
    └── webLinks/
```

분리되지 않은 나머지 Custom Object 정보는 `<object-name>.object-meta.xml`에 배치된다.

### Custom Object Translations (기본 분해)

저장 위치: `<package-directory>/main/default/objectTranslations/`

각 Object Translation은 자체 서브디렉토리(Custom Object Translation 이름)를 갖는다:

```
objectTranslations/
└── MyObject__c-ja/
    ├── MyObject__c-ja.objectTranslation-meta.xml   — 분리되지 않은 나머지 정보
    └── MyField__c.fieldTranslation-meta.xml        — 각 필드 번역
```

- 필드 번역: `<field_name>.fieldTranslation-meta.xml`
- 오브젝트 번역: `<object_name>.objectTranslation-meta.xml`

### Custom Labels (Beta 분해)

기본값: `<package-directory>/labels/CustomLabels.labels-meta.xml` — org 전체 Custom Label이 단일 파일에 저장

분해 후: 각 CustomLabel 컴포넌트가 `*.label-meta.xml` 파일로 분리된다. 파일명은 CustomLabel 컴포넌트의 `fullName`에서 파생된다.

```
force-app/
└── main/
    └── default/
        └── labels/
            ├── MyLabel1.label-meta.xml
            ├── MyLabel2.label-meta.xml
            ├── MyLabel3.label-meta.xml
            └── MyLabel4.label-meta.xml
```

**Custom Labels 구성 규칙:**
- 모든 `*.label-meta.xml` 소스 파일은 `labels` 소스 디렉토리에 포함되어야 한다
- DX 프로젝트의 각 패키지 디렉토리마다 `labels` 소스 디렉토리를 만들 수 있다
- `labels` 소스 디렉토리의 서브디렉토리를 만들어 Custom Label을 더 세분화해 구성할 수 있다

### External Service Registrations (Beta 분해)

기본값: `<package-directory>/main/default/externalServiceRegistrations/<name>.externalServiceRegistration-meta.xml`

분해 후: 동일한 최상위 `externalServiceRegistrations` 디렉토리에 저장되지만, 각 등록이 두 소스 파일로 분해된다:

```
externalServiceRegistrations/
├── BankService.yaml                                    — OpenAPI 스키마 (YAML 형식)
└── BankService.externalServiceRegistration-meta.xml   — 스키마 필드 제외한 나머지 필드
```

- `BankService.yaml`: OpenAPI 2.0.x 또는 3.0.x 스키마. org에서 JSON 형식이라도 DX 프로젝트로 가져올 때 항상 YAML로 변환
- `BankService.externalServiceRegistration-meta.xml`: `schema` 필드를 제외한 모든 필드를 담는 표준 Metadata API XML 파일

배포 시 두 파일이 하나의 Metadata API XML 파일로 재변환된다.

### Permission Sets (Beta 분해)

기본값: `<package-directory>/main/default/permissionsets/<name>.permissionset-meta.xml`

분해 후: 동일한 최상위 `permissionsets` 디렉토리에 저장되지만, 각 Permission Set이 서브디렉토리로 분해된다:

```
permissionsets/
└── MyPermSet/
    ├── MyPermSet.permissionset-meta.xml            — 레이블, 설명, 라이선스 등 기본 정보
    ├── objectSettings/
    │   └── <ObjectName>.objectSettings-meta.xml    — 오브젝트별 권한·설정
    ├── MyPermSet.applicationVisibilities-meta.xml  — 애플리케이션 가시성
    ├── MyPermSet.flowAccesses-meta.xml             — Flow 액세스
    └── MyPermSet.<category>-meta.xml               — 카테고리별 나머지 권한·설정
```

**Permission Set 분해 하이라이트:**
- 특정 Permission Set의 분해 파일은 해당 Permission Set 이름과 동일한 서브디렉토리에 담긴다
- 서브디렉토리 내에는 `<Name>.permissionset-meta.xml` 단일 파일 (레이블, 설명, 라이선스 등 포함)
- `objectSettings` 디렉토리가 오브젝트 관련 권한·설정을 각 오브젝트별 단일 파일(`<ObjectName>.objectSettings-meta.xml`)로 통합
- 나머지 권한·설정은 카테고리별 확장자 파일(예: `applicationVisibilities-meta.xml`, `flowAccesses-meta.xml`)로 분리

### Sharing Rules (Beta 분해)

기본값: `<package-directory>/main/default/sharingRules/<object-name>.sharingRules-meta.xml`

분해 후: 동일한 최상위 `sharingRules` 디렉토리에 저장되지만, Sharing Rule이 연결된 오브젝트와 동일한 이름의 서브디렉토리로 그룹화된다:

```
sharingRules/
└── Account/
    ├── Account.sharingRules-meta.xml      — 분리되지 않은 나머지 정보
    ├── sharingCriteriaRules/
    ├── sharingGuestRules/
    ├── sharingOwnerRules/
    └── sharingTerritoryRules/
```

분리되지 않은 나머지 정보는 `<object-name>.sharingRules-meta.xml`에 배치된다.

### Workflows (Beta 분해)

기본값: `<package-directory>/main/default/workflows/<object-name>.workflow-meta.xml`

분해 후: 동일한 최상위 `workflows` 디렉토리에 저장되지만, Workflow가 연결된 오브젝트와 동일한 이름의 서브디렉토리로 그룹화된다:

```
workflows/
└── Account/
    ├── Account.workflow-meta.xml          — 분리되지 않은 나머지 정보
    ├── workflowAlerts/
    ├── workflowFieldUpdates/
    ├── workflowKnowledgePublishes/
    ├── workflowOutboundMessages/
    ├── workflowRules/
    ├── workflowSends/
    └── workflowTasks/
```

분리되지 않은 나머지 정보는 `<object-name>.workflow-meta.xml`에 배치된다.

---

## .forceignore

### 목적

로컬 파일시스템과 대상 org 간 메타데이터를 동기화할 때 제외할 소스 파일을 지정한다. 소스를 DX 소스 포맷으로 변환할 때도 제외 대상을 지정할 수 있다.

**적용 명령:**
- `project deploy start`
- `project retrieve start`
- `project convert source`
- `project delete source`
- `project convert mdapi`
- (그 외 대부분의 `project` 명령)

---

### .forceignore 파일 구조 및 문법

`.gitignore` 파일 구조를 그대로 따른다. 각 줄은 하나 이상의 파일에 해당하는 패턴을 지정한다.

**핵심 규칙:**

| 규칙 | 설명 |
|---|---|
| 디렉토리 구분자 | 항상 forward slash(`/`) 사용 — Windows에서도 동일 |
| `*` | forward slash(`/`)를 제외한 모든 문자 매칭 |
| `**` | 경로 내 위치에 따라 특수 의미 (아래 예시 참조) |
| 빈 줄 | 가독성을 위한 구분자로 사용 |
| `#` | 주석 |

전체 규칙은 [git 문서](https://git-scm.com/docs/gitignore) 참조.

---

### 메타데이터 컴포넌트 정확한 파일명 확인 방법

**방법 1:** 패키지 디렉토리 직접 확인
```
force-app/main/default/profiles/
└── NotUsedProfile.profile-meta.xml   ← 이 파일명을 .forceignore에 사용
```

**방법 2:** `project deploy preview` / `project retrieve preview` 출력에서 Path 컬럼 확인

```bash
sf project deploy preview
# 출력:
# Will Deploy [2] files.
# Type          Fullname    Path
# ─────────────────────────────────────────────────────────────────────
# PermissionSet dreamhouse  force-app/main/default/permissionsets/dreamhouse.permissionset-meta.xml
# CustomTab     Settings    force-app/main/default/tabs/Settings.tab-meta.xml
```

---

### 자동으로 제외되는 파일 (`.forceignore` 불필요)

소스 명령은 `.forceignore`에 없어도 다음 파일을 자동 무시한다:

| 패턴 | 예시 |
|---|---|
| `.`으로 시작하는 파일·디렉토리 | `.DS_Store`, `.sf` |
| `.dup`으로 끝나는 파일 | — |
| `package2-descriptor.json` | — |
| `package2-manifest.json` | — |

---

### .forceignore 예제 모음

#### 특정 메타데이터 파일 제외

```
# Profile 제외 (경로 지정)
**/NotUsedProfile.profile-meta.xml
```

#### 원격 변경 사항 Pull 방지

org에서 변경했지만 로컬로 가져오고 싶지 않을 때:

```
# Dreamhouse Permission Set을 원격에서 pull하지 않음
**/Dreamhouse.permissionset-meta.xml
```

#### MetadataWithContent 타입 제외

`ApexClass`, `EmailTemplate` 등 콘텐츠를 포함하는 메타데이터는 두 소스 파일을 갖는다:
- 콘텐츠 파일 (예: `HelloWorld.cls`)
- 메타데이터 XML 파일 (예: `HelloWorld.cls-meta.xml`)

```
# 방법 1: 두 파일 명시적 나열
helloWorld/main/default/classes/HelloWorld.cls
helloWorld/main/default/classes/HelloWorld.cls-meta.xml

# 방법 2: 와일드카드로 한 번에 제외
helloWorld/main/default/classes/HelloWorld.cls*
```

#### 번들 및 파일 그룹 제외

```
# LWC 컴포넌트 번들 전체 제외
**/lwc/myLwcComponent

# 모든 Apex 클래스 제외
**/classes
```

#### 특수 문자가 있는 파일명

메타데이터명에 특수 문자(forward slash, backslash, 따옴표 등)가 있으면 로컬 파일시스템에서 인코딩된 이름으로 저장된다. `.forceignore`에도 인코딩된 이름을 사용한다.

```
# 원본 이름: Custom: Marketing Profile
# 인코딩된 파일명:
Custom%3A Marketing Profile.profile-meta.xml
```

#### 전체 문법 예시 모음 (Sample Syntax)

```
# 프로젝트 루트 기준 상대 경로로 디렉토리 지정
helloWorld/main/default/classes

# 와일드카드 디렉토리 — 이름이 "classes"인 모든 디렉토리 제외
**classes

# 파일 확장자로 지정
**.cls*
**.pdf

# 특정 파일 지정
helloWorld/main/default/HelloWorld.cls*
```

---

### .forceignore 파일 위치 규칙

| 실행 명령 | `.forceignore` 위치 |
|---|---|
| `project deploy start`, `project retrieve start` (소스 추적 명령) | **프로젝트 루트** |
| `project convert mdapi` | **메타데이터 retrieve 디렉토리** (package.xml이 있는 곳) |

> `.forceignore`에서 지정하는 경로는 **`.forceignore` 파일이 있는 디렉토리 기준 상대경로**여야 한다.

---

### 여러 .forceignore 파일 (Multiple .forceignore)

프로젝트에 `.forceignore` 파일을 여러 개 둘 수 있다. 소스 명령이 특정 소스 파일을 제외할지 결정할 때 다음 알고리즘을 따른다:

1. 소스 파일 위치에서 시작해 **디렉토리 트리를 위쪽으로 순회**한다
2. `.forceignore` 파일을 발견하면 해당 파일을 참조해 제외 여부를 결정한다
3. 찾으면 즉시 **중단** — 상위의 다른 `.forceignore` 파일은 더 이상 참조하지 않는다

**예시:**

```
프로젝트 루트/
├── .forceignore            ← Apex 클래스 미제외
├── force-app/              ← 기본 패키지 디렉토리
│   └── main/default/
│       └── classes/
│           └── PagedNewResult.cls   ← 루트 .forceignore 참조 → 배포됨
└── second-package/         ← 추가 패키지 디렉토리
    ├── .forceignore        ← Paged* Apex 클래스 제외
    └── main/default/
        └── classes/
            └── PagedResult.cls      ← second-package .forceignore 참조 → 배포 안 됨
```

```bash
# 모든 패키지의 Apex 클래스 배포
sf project deploy start --metadata ApexClass
# PagedResult는 second-package/.forceignore에 의해 제외됨
# PagedNewResult는 루트 .forceignore에 의해 제외 안 됨 → 배포됨
```

---

### 무시 중인 파일 목록 확인

```bash
# 모든 패키지 디렉토리에서 무시되는 파일 전체 목록
sf project list ignored

# 특정 파일 무시 여부 확인
sf project list ignored --source-dir package.xml

# 특정 디렉토리 내 무시되는 파일 목록 (하위 디렉토리 재귀 포함)
sf project list ignored --source-dir force-app/main/default
```

**출력 예시 (무시 파일 있을 때):**
```
Found the following ignored files:
force-app/main/default/aura/.eslintrc.json
force-app/main/default/lwc/.eslintrc.json
force-app/main/default/lwc/jsconfig.json
```

**출력 예시 (무시 파일 없을 때):**
```
No ignored files found in paths:
README.md
```

---

## 관련 노트

- [[Salesforce DX 개요]] — sfdx-project.json, Source Format, .forceignore 요약 개요
- [[DX 프로젝트 구조와 소스 포맷]] — DX 프로젝트 생성·디렉토리 구조·소스 포맷 전수
- [[sfdx-project.json 레퍼런스]] — sourceBehaviorOptions 등 모든 sfdx-project.json 필드 전수
- [[Scratch Org 패턴]] — Scratch org 생성, 설정, 스냅샷
- [[Source Tracking 변경 추적]] — Source Tracking 전수 (.forceignore로 Profile 제외 설정 포함)
