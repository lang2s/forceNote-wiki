---
tags: [devops, salesforce-dx, unlocked-package, sfdx-project-json, package-create, namespace, dependencies, keywords]
source: sfdx_dev.pdf (Salesforce DX Developer Guide v67.0)
created: 2026-05-23
aliases: [sf package create, packageDirectories, package installation key, 패키지 의존성, 패키지 Namespace, packageAliases, 패키지 설정, NEXT LATEST RELEASED HIGHEST NONE 키워드]
---

# Unlocked Package 생성과 설정

> sf package create 명령, sfdx-project.json 전체 패키지 파라미터, Keywords(NEXT·LATEST·RELEASED·HIGHEST·NONE), Installation Key, 의존성, Namespace, Profile Settings 전수 설명.

---

## 패키지 생성 워크플로

```bash
# 1. DX 프로젝트 생성
sf project generate --output-dir expense-manager-workspace --name expenser-app

# 2. Dev Hub 인증
sf org login web --set-default-dev-hub --alias MyDevHub

# 3. 패키지 개발용 Scratch Org 생성
sf org create scratch \
  --definition-file config/project-scratch-def.json \
  --alias MyTestOrg1 \
  --duration-days 30

# 4. 패키지 컴포넌트를 프로젝트 디렉토리에 배치

# 5. 패키지 생성
sf package create \
  --name "Expense Manager" \
  --path force-app \
  --package-type Unlocked

# 6. 패키지 버전 생성
sf package version create \
  --package "Expense Manager" \
  --installation-key test1234 \
  --wait 10

# 7. 다른 Scratch Org에서 설치·테스트
sf package install \
  --package "Expense Manager@0.1.0-1" \
  --target-org MyTestOrg1 \
  --installation-key test1234 \
  --wait 10 \
  --publish-wait 10

# 8. 설치된 Scratch Org 열기
sf org open --target-org MyTestOrg1
```

패키지 생성 후 `sfdx-project.json` 자동 업데이트:
```json
{
  "packageDirectories": [
    {
      "path": "force-app",
      "default": true,
      "package": "Expense Manager",
      "versionName": "ver 0.1",
      "versionNumber": "0.1.0.NEXT"
    }
  ],
  "namespace": "",
  "sfdcLoginUrl": "https://login.salesforce.com",
  "sourceApiVersion": "59.0",
  "packageAliases": {
    "Expense Manager": "0Hoxxx"
  }
}
```

---

## sfdx-project.json 패키지 설정 파라미터 전수

| 파라미터 | 필수 | 기본값 | 설명 |
|---|---|---|---|
| `apexTestAccess` | No | None | 패키지 버전 생성 시 Apex 테스트를 실행하는 사용자에게 할당할 Permission Set 및 Permission Set License |
| `branch` | No | None | SCS 브랜치 이름. 브랜치 기반 패키지 버전 관리 시 사용 |
| `calculateTransitiveDependencies` | No | `false` | `true`면 직접 의존성만 지정하고 간접(전이적) 의존성을 자동 계산. `package version displaydependencies` 명령으로 의존성 그래프 생성 가능 |
| `default` | Yes (복수 디렉토리) | `true` | 기본 패키지 디렉토리 여부. `sf project retrieve` 시 기본 패키지 디렉토리로 복사. 하나만 `true` 가능 |
| `definitionFile` | No | None | 패키지 메타데이터에 필요한 Features·Org Settings를 지정하는 외부 .json 파일 참조 (예: scratch org definition) |
| `dependencies` | No | None | 다른 패키지에 대한 의존성 지정 |
| `includeProfileUserLicenses` | No | `false` | `true`면 패키지 버전 생성 시 프로필의 사용자 라이선스 설정 유지 |
| `namespace` | No | None | 1~15자 영숫자 패키지 식별자 |
| `package` | Yes | — | 패키지 이름 |
| `packageAliases` | Yes | CLI 자동 업데이트 | 패키지/패키지 버전 별칭 → ID 매핑 (`sfdx-project.json`에 자동 추가됨) |
| `path` | Yes | CLI 임시 경로 | 패키지 소스 디렉토리 경로 |
| `postInstallUrl` | No | None | 설치 후 안내 URL |
| `releaseNotesUrl` | No | None | 릴리스 노트 URL |
| `seedMetadata` | No | None | Standard Value Set에 의존할 때 시드 메타데이터 디렉토리 경로 |
| `unpackagedMetadata` | No | None | 패키지 버전 생성 테스트 시 사용 가능한 미패키지 메타데이터 경로 |
| `versionDescription` | No | None | 버전 설명 |
| `versionName` | No | versionNumber 사용 | 버전 이름 |
| `versionNumber` | Yes | — | MAJOR.MINOR.PATCH.BUILD 형식. 새 버전 생성 전 수동 증가 필요. NEXT 키워드 권장 |

### 완전한 sfdx-project.json 예시

```json
{
  "namespace": "exp-mgr",
  "sfdcLoginUrl": "https://login.salesforce.com",
  "sourceApiVersion": "61.0",
  "packageDirectories": [
    {
      "path": "util",
      "default": true,
      "package": "Expense Manager - Util",
      "versionName": "Summer '24",
      "versionDescription": "Welcome to Summer 2024 Release of Expense Manager Util Package",
      "versionNumber": "4.7.0.NEXT",
      "definitionFile": "config/scratch-org-def.json"
    },
    {
      "path": "exp-core",
      "default": false,
      "package": "Expense Manager",
      "versionName": "v 3.2",
      "versionDescription": "Summer 2024 Release",
      "versionNumber": "3.2.0.NEXT",
      "postInstallUrl": "https://expenser.com/post-install-instructions.html",
      "releaseNotesUrl": "https://expenser.com/summer-2024-release-notes.html",
      "definitionFile": "config/scratch-org-def.json",
      "dependencies": [
        {
          "package": "Expense Manager - Util",
          "versionNumber": "4.7.0.LATEST"
        },
        {
          "package": "External Apex Library - 1.0.0.4"
        }
      ]
    }
  ],
  "packageAliases": {
    "Expense Manager - Util": "0HoB00000004CFpKAM",
    "External Apex Library@1.0.0.4": "04tB0000000IB1EIAW",
    "Expense Manager": "0HoB00000004CFuKAM"
  }
}
```

### 자동 업데이트 비활성화

| 명령 | 환경 변수 |
|---|---|
| `sf package create` | `SFDX_PROJECT_AUTOUPDATE_DISABLE_FOR_PACKAGE_CREATE=true` |
| `sf package version create` | `SFDX_PROJECT_AUTOUPDATE_DISABLE_FOR_PACKAGE_VERSION_CREATE=true` |

---

## 패키지 Keywords

버전 번호에서 사용하는 변수로, 빌드 번호 자동 증가·의존성 버전 지정에 활용한다.

| Keyword | 용도 | 예시 |
|---|---|---|
| `NEXT` | 빌드 번호를 다음 사용 가능 번호로 자동 증가 | `"versionNumber": "1.2.0.NEXT"` |
| `LATEST` | 패키지 버전 생성 시 의존 패키지의 가장 최근 버전 | `"versionNumber": "0.1.0.LATEST"` |
| `RELEASED` | 패키지 버전 생성 시 의존 패키지의 가장 최근 Promoted·Released 버전 | `"versionNumber": "2.1.0.RELEASED"` |
| `HIGHEST` | Ancestor 버전에만 사용. 가장 높은 Promoted·Released 버전으로 자동 설정 | `"ancestorVersion": "HIGHEST"` |
| `NONE` | Ancestor 버전에만 사용. 업그레이드 경로 없음 (기존 고객 업그레이드 불가) | `"ancestorVersion": "NONE"` |

---

## Package Installation Key

설치 키는 패키지 메타데이터를 보호하는 첫 번째 방어선이다. 올바른 키를 제공하기 전까지 패키지 이름이나 컴포넌트 정보가 공개되지 않는다.

```bash
# 패키지 버전 생성 시 키 설정
sf package version create \
  --package "Expense Manager" \
  --installation-key "JSB7s8vXU93fI"

# 설치 시 키 제공
sf package install \
  --package "Expense Manager" \
  --installation-key "JSB7s8vXU93fI"

# 기존 패키지 버전의 키 변경
sf package version update \
  --package "Expense Manager@1.2.0-4" \
  --installation-key "HIF83kS8kS7C"

# 키 없이 버전 생성 (보안 조치 불필요 시)
sf package version create \
  --package "Expense Manager" \
  --directory common \
  --tag 'Release 1.0.0' \
  --installation-key-bypass
```

키 요건 확인:
```bash
sf package version list    # 또는
sf package version report
```

---

## 패키지 의존성 (Dependencies)

### 같은 Dev Hub 내 패키지 의존성

```json
// 패키지 별칭 + 버전 번호
"dependencies": [
  {
    "package": "MyPackageName",
    "versionNumber": "0.1.0.LATEST"
  }
]

// 패키지 별칭 + @ 버전
"dependencies": [
  {
    "package": "MyPackageName@0.1.0.1"
  }
]
```

### 외부 Dev Hub 패키지 의존성

```json
"dependencies": [
  {
    "package": "OtherOrgPackage@1.2.0"
  }
]
```

### ID로 의존성 지정

- 패키지 ID + 버전 번호: `0Ho` ID 사용
- 패키지 버전 ID만: `04t` ID 사용

### 다중 의존성 (설치 순서)

```json
"dependencies": [
  {
    "package": "External Apex Library 1.0.0.4"
  },
  {
    "package": "Expense Manager - Util",
    "versionNumber": "4.7.0.LATEST"
  }
]
```

설치 순서가 의존성 순서와 일치해야 한다 (먼저 의존하는 패키지부터).

### 의존성 정보 추출 (SOQL)

설치된 패키지의 의존성을 SOQL로 조회할 수 있다:

```bash
sf data query -u {USERNAME} -t \
  -q "SELECT Dependencies FROM SubscriberPackageVersion WHERE Id='04txx000000082hAAA'" \
  --json
```

출력 예시:
```json
"Dependencies": {
  "Ids": [
    {"subscriberPackageVersionId": "04txx000000080vAAA"},
    {"subscriberPackageVersionId": "04txx000000082XAAQ"},
    {"subscriberPackageVersionId": "04txx0000000AiGAAU"}
  ]
}
```

---

## Namespace

Namespace는 1~15자 영숫자 식별자로, 패키지를 다른 패키지와 구별한다. 패키지 생성 시 결정되며 이후 변경 불가.

### Namespace 없는 패키지 vs Namespace 있는 패키지

| 사용 상황 | Namespace 없음 | Namespace 있음 |
|---|---|---|
| Org 메타데이터 마이그레이션 | 적합 (API 이름 유지) | 비적합 |
| 기존 unpackaged 메타데이터 보존 | 적합 | 비적합 |
| 복수 개발 팀 (이름 충돌 방지) | 비적합 | 적합 |
| 코드 공유 용이 | 비적합 | 적합 (동일 Namespace 공유) |

> 중요: No-Namespace Unlocked Package는 Namespace가 있는 Org에 설치 불가

### Namespace 충돌 매트릭스

| 설치 대상 Org | No-namespace Unlocked | Namespaced Unlocked | 2GP | 1GP |
|---|---|---|---|---|
| Namespace 있는 Org | Fail | Pass (다른 Namespace) | Pass (Scratch Org) | Pass (다른 Namespace) |
| Namespace 없는 Org | Pass | Pass | Pass | Pass |

### Namespace 생성 절차

```
1. 새 Developer Edition Org 가입
2. Setup > Package Manager > Namespace Settings > Edit
3. Namespace 입력 → Check Availability
4. (선택) 연결할 패키지 선택 또는 None → Review → Save

Namespace 등록:
5. Dev Hub의 Namespace Registry에 Namespace Org 연결
6. sfdx-project.json의 namespace 속성에 Namespace 지정
```

### @namespaceAccessible

같은 Namespace를 사용하는 패키지 간에 Public Apex를 접근 가능하게 한다.

```java
@namespaceAccessible
public class MyClass {
    private Boolean bypassFLS;

    // Namespace 내에서 접근 가능한 생성자
    @namespaceAccessible
    public MyClass() {
        bypassFLS = false;
    }

    // 패키지 내부에서만 사용 가능한 생성자 (신뢰된 컨텍스트)
    public MyClass(Boolean bypassFLS) {
        this.bypassFLS = bypassFLS;
    }

    @namespaceAccessible
    protected Boolean getBypassFLS() {
        return bypassFLS;
    }
}
```

주의사항:
- `@AuraEnabled` Apex 메서드에는 `@namespaceAccessible` 사용 불가
- 언제든 추가·제거 가능하나 의존 패키지 영향 검토 필요
- No-namespace 패키지의 Public Apex는 외부 Lightning 컴포넌트에서 접근 가능 (unmanaged 패키지와 동일 취급)

---

## Profile Settings 처리

패키지 버전 생성 시, 빌드 시스템이 DX 프로젝트 디렉토리 전체의 프로필을 검사하고 패키지 메타데이터와 직접 관련된 프로필 설정만 보존한다.

설치 시 보존된 프로필 설정은 구독자 Org의 기존 프로필에 적용된다 (새 프로필로 설치 안 됨).

### 설치 유형별 프로필 적용 대상

| 설치 옵션 | 적용 프로필 | 사용 가능 경로 |
|---|---|---|
| Install for Admins Only | System Administrator 프로필 | 패키지 설치 페이지, CLI (기본) |
| Install for All Users | System Administrator + 복제 프로필 전체 | 패키지 설치 페이지, CLI (`--security-type AllUsers`) |
| Install for Specific Profiles | 설치자가 선택한 특정 프로필 | 패키지 설치 페이지 (CLI 불가) |

```bash
# 모든 사용자에게 설치
sf package install \
  --security-type AllUsers \
  --package "Expense Manager@1.3.0-7"
```

### 프로필 대신 Permission Set 권장

가능하면 프로필 설정보다 패키지 Permission Set을 사용한다. 구독자가 자신의 사용자에게 쉽게 할당 가능하다.

### License Settings 유지

기본적으로 프로필의 라이선스 설정은 패키지 생성 시 제거된다. 유지하려면:

```json
"packageDirectories": [
  {
    "package": "PackageA",
    "path": "common",
    "versionName": "ver 0.1",
    "versionNumber": "0.1.0.NEXT",
    "default": false,
    "includeProfileUserLicenses": true
  }
]
```

---

## 릴리스 노트·설치 후 안내 공유

```json
"packageDirectories": [
  {
    "path": "expenser-schema",
    "default": true,
    "package": "Expense Schema",
    "versionName": "ver 0.3.2",
    "versionNumber": "0.3.2.NEXT",
    "postInstallUrl": "https://expenser.com/post-install-instructions.html",
    "releaseNotesUrl": "https://expenser.com/winter-2020-release-notes.html"
  }
]
```

또는 CLI 파라미터로 지정 (sfdx-project.json의 URL 오버라이드):
```bash
sf package version create \
  --post-install-url "https://expenser.com/post-install-instructions.html" \
  --release-notes-url "https://expenser.com/release-notes.html"
```

---

## Package ID 유형

| ID 예시 | 이름 | 설명 |
|---|---|---|
| `033J0000dAb27uxVRE` | Subscriber Package ID | Salesforce 지원 문의 시 사용. `sf package list --verbose`로 확인 |
| `04t6A0000004eytQAA` | Subscriber Package Version ID | 패키지 버전 설치에 사용. `sf package version create`가 반환 |
| `0Hoxx00000000CqCAI` | Package ID | 패키지 버전 생성 시 CLI 또는 `sfdx-project.json`에 사용. `sf package create`가 생성 |
| `08cxx00000000BEAAY` | Version Creation Request ID | `sf package version create report`에 사용 |

---

## 자주 사용하는 CLI 명령

| 명령 | 설명 |
|---|---|
| `sf package create` | 패키지 생성 |
| `sf package version create` | 패키지 버전 생성 |
| `sf package install` | 패키지 버전을 Scratch Org·Sandbox·Production에 설치 |
| `sf package uninstall` | 설치된 패키지 제거 |
| `sf package version promote` | 패키지 버전을 Beta → Released 상태로 변경 |
| `sf org create scratch` | Scratch Org 생성 |
| `sf org open` | Org 브라우저에서 열기 |

---

## 관련 노트

- [[Unlocked Package 개념과 준비]] — 패키지 개념, 사전 준비
- [[Unlocked Package 개발과 버전]] — 패키지 버전 생성, 코드 커버리지
- [[Unlocked Package 릴리스와 설치]] — Promote, Install, Uninstall, Transfer
- [[sfdx-project.json 레퍼런스]] — DX 프로젝트 전체 설정
- [[DX 도구 접근 권한]] — Permission Set, 라이선스 구성
