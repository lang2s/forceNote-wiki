---
tags: [devops, salesforce-dx, limitations, known-issues, cli, scratch-org, packaging]
source: sfdx_dev.pdf v67.0 Summer '26 — Ch.16 (p.354–364)
created: 2026-05-23
aliases: [DX 제약사항, DX 한계, DX limitations, DX known issues, Salesforce DX 알려진 문제]
---

# DX 제약사항

> Salesforce DX 사용 중 알려진 제약 및 한계 전수 — CLI·Dev Hub·Scratch Org·Source Management·배포·패키지 영역별 분류.

---

## 개요

아래는 DX 사용 중 발생할 수 있는 알려진 문제들이다. 최신 Known Issues는 다음에서 확인한다:
- Trailblazer Community > Known Issues 페이지
- Salesforce CLI GitHub 레포 > Issues 탭

---

## Salesforce CLI

### Can't Import Record Types Using Salesforce CLI

- **설명**: `data tree import` 명령으로 RecordType을 임포트하는 것은 지원되지 않는다.
- **우회 방법**: 없음 (Workaround: None).

### Limited Support for Shell Environments on Windows

- **설명**: Salesforce CLI는 **Command Prompt(cmd.exe)**와 **PowerShell**에서만 공식 테스트된다. Cygwin, Min-GW, WSL(Windows Subsystem for Linux)에는 알려진 문제가 있으며 현재 지원되지 않는다.
- **우회 방법**: 지원되는 셸(cmd.exe 또는 PowerShell)을 사용한다.

---

## Dev Hub와 Scratch Org

### Salesforce CLI Sometimes Doesn't Recognize Scratch Orgs with Communities

- **설명**: Communities 기능을 포함한 Scratch Org 생성이 CLI에서 인식되지 않는 경우가 있다. Dev Hub에는 Scratch Org가 표시되지만 CLI로 열 수 없는 상태.
- **우회 방법**: Dev Hub에서 Scratch Org를 삭제하고 CLI로 새 Scratch Org를 생성. 단, 삭제 및 재생성은 일일 Scratch Org 한도에 카운트된다.

### Error Occurs If You Pull a Community and Deploy It

- **설명**: Scratch Org에 필요한 guest 라이선스가 없어 오류가 발생한다.
- **우회 방법**: Scratch Org 정의 파일에서 `Communities` feature를 지정할 때 `Sites` feature도 함께 지정한다.

```json
{
  "orgName": "My Company",
  "edition": "Developer",
  "features": ["Communities", "Sites"]
}
```

---

## Source Management

### ERROR: Entity of type 'RecordType' named 'Account.PersonAccount' cannot be found

- **설명**: Scratch Org 정의 파일에 Person Accounts feature를 추가해 활성화해도, `project deploy start` 또는 `project retrieve start` 실행 시 오류가 발생한다.
- **우회 방법**: 없음.

### project convert source Doesn't Add Post-Install Scripts to package.xml

- **설명**: `project convert source` 실행 시 `package.xml`에 post install script가 포함되지 않는다.
- **우회 방법** (둘 중 선택):
  - `project convert source`가 생성한 메타데이터 디렉토리의 `package.xml`에 `<postInstallClass>` 요소를 수동으로 추가한다.
  - 배포 대상 org의 패키지에 해당 요소를 수동으로 추가한다.

### Must Manually Enable Feed Tracking in an Object's Metadata File

- **설명**: 표준 또는 커스텀 객체에 feed tracking을 활성화한 후 `project retrieve start`를 실행해도 feed tracking이 활성화된 상태로 검색되지 않는다.
- **우회 방법**: DX 프로젝트의 해당 객체 메타데이터 파일(`-meta.xml`)에 다음을 수동으로 추가한다.

```xml
<enableFeeds>true</enableFeeds>
```

### Unable to Push Lookup Filters to a Scratch Org

- **설명**: lookup filter가 있는 관계 필드의 소스를 `project deploy start` 명령으로 배포할 때 다음과 같은 오류가 발생하는 경우가 있다.

```
duplicate value found: <unknown> duplicates value on record with
id: <unknown> at line num, col num.
```

- **우회 방법**: 없음.

---

## Deployment

### Compile on Deploy Can Increase Deployment Times in Scratch Orgs

- **설명**: Apex 코드 배포 시간이 느리다면 Scratch Org에 `enableCompileOnDeploy` 설정이 `true`로 되어 있을 수 있다.
- **우회 방법**: Scratch Org 정의 파일에서 해당 설정을 `false`(기본값)로 변경하거나 삭제한다.

```json
{
  "orgName": "My Company",
  "edition": "Developer",
  "features": [],
  "settings": {
    "lightningExperienceSettings": {
      "enableS1DesktopEnabled": true
    },
    "apexSettings": {
      "enableCompileOnDeploy": false
    }
  }
}
```

---

## Managed First-Generation Packages (1GP)

### When You Install a Package in a Scratch Org, No Tests Are Performed

- **설명**: CI 프로세스의 일부로 테스트를 포함하는 경우, Scratch Org에 패키지를 설치할 때 해당 테스트가 실행되지 않는다.
- **우회 방법**: 패키지 설치 후 테스트를 수동으로 실행한다.

### New Terminology in CLI for Managed Package Password

- **설명**: CLI에서 패키지 버전에 installation key를 추가하거나 key-protected 패키지를 설치할 때 사용하는 플래그명은 `--installationkey`이다. Salesforce UI에서는 같은 속성이 "Password"로 표시된다. API에서는 필드명이 "password"로 변경되지 않았다.
- **우회 방법**: 없음.

---

## Managed Second-Generation Packages (2GP)

### Protected Custom Metadata and Custom Settings are Visible to Developers (Shared Namespace)

- **설명**: 동일한 namespace를 사용하는 여러 2세대 관리 패키지를 생성할 수 있다. 그러나 이 패키지들을 공유 namespace가 있는 Scratch Org에 설치하면 보호된 Custom Metadata 또는 Custom Settings에 저장된 시크릿이 해당 Scratch Org에서 작업하는 개발자에게 노출된다. 향후 `package-protected` 키워드 추가를 검토 중이다.
- **우회 방법**: 없음. 시크릿 저장 시 주의가 필요하다.

---

## Unlocked Packages

### Protected Custom Metadata and Custom Settings are Visible to Developers (Shared Namespace)

- **설명**: 동일한 namespace의 여러 Unlocked Package를 생성한 경우, 공유 namespace Scratch Org에 설치하면 보호된 Custom Metadata 또는 Custom Settings의 시크릿이 개발자에게 노출된다. 향후 `package-protected` 키워드 추가를 검토 중이다.
- **우회 방법**: 없음. 패키지에 시크릿 저장 시 주의가 필요하다.

---

## 제약사항 요약표

| 영역 | 제약 | 우회 방법 |
|---|---|---|
| Salesforce CLI | RecordType data tree import 불가 | 없음 |
| Salesforce CLI | Windows: Cygwin/MinGW/WSL 미지원 | cmd.exe 또는 PowerShell 사용 |
| Dev Hub / Scratch Org | Communities Scratch Org CLI 미인식 (간헐적) | 삭제 후 재생성 |
| Dev Hub / Scratch Org | Communities 배포 시 guest license 오류 | Sites feature 함께 지정 |
| Source Management | PersonAccount RecordType 배포/검색 오류 | 없음 |
| Source Management | post-install script가 package.xml에 미포함 | 수동으로 추가 |
| Source Management | feed tracking 검색 후 미활성화 | `<enableFeeds>true</enableFeeds>` 수동 추가 |
| Source Management | Lookup Filter 배포 시 중복 오류 (간헐적) | 없음 |
| Deployment | Scratch Org에서 Compile on Deploy로 느린 배포 | `enableCompileOnDeploy: false` 설정 |
| 1GP | Scratch Org 패키지 설치 시 테스트 미실행 | 설치 후 수동 테스트 |
| 1GP | CLI `--installationkey` vs UI "Password" 명칭 불일치 | 없음 |
| 2GP | 공유 namespace Scratch Org에서 시크릿 노출 | 없음 (시크릿 저장 주의) |
| Unlocked Package | 공유 namespace Scratch Org에서 시크릿 노출 | 없음 (시크릿 저장 주의) |

---

## 관련 노트
- [[DX 트러블슈팅]] — 인증 오류·JWT 오류·CLI 버전 문제 해결
- [[Scratch Org 생성과 정의 파일]] — project-scratch-def.json 옵션 전수
- [[Unlocked Package 개발과 버전]] — 패키지 버전 생성·코드 커버리지
- [[Source Tracking 변경 추적]] — deploy/retrieve·충돌 해결
- [[DX 데이터 작업]] — data tree import/export 전수
