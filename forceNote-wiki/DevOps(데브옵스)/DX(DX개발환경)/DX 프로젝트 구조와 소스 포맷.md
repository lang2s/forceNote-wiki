---
tags: [devops, salesforce-dx, sfdx, project-structure, source-format, sf-cli, project-generate]
source: sfdx_dev.pdf v67.0 Summer '26 — Chapter 3 (Project Setup, p.24–35)
created: 2026-05-22
aliases: [DX Project Structure, Source Format, sf project generate, DX 프로젝트 구조, 소스 포맷, Salesforce DX Project Structure]
---

# DX 프로젝트 구조와 소스 포맷

> Salesforce DX 프로젝트의 생성 방법, 디렉토리 구조, 소스 포맷(Source Format) 개념을 전수 정리한 레퍼런스.

---

## 개요

Salesforce DX 프로젝트는 org의 메타데이터(코드·설정), org 템플릿, 샘플 데이터, 팀 테스트를 담는 표준 구조를 갖는다. 이 모든 항목을 소스 컨트롤 시스템(SCS)에 저장하고, 개발 시마다 레포지토리에서 꺼내 쓴다.

**DX 프로젝트를 DX 프로젝트로 만드는 것:** `sfdx-project.json` 파일의 존재. 이 파일은 Connected App 정보, 소스 위치, 2GP 패키지 디렉토리 구조, 사용 API 버전을 정의한다.

---

## 샘플 레포지토리 (GitHub)

빠른 시작을 원하면 **dreamhouse-lwc** GitHub 레포를 클론한다. 이 레포는 Apex 클래스, Aura 컴포넌트, Custom Object, 샘플 데이터, Apex 테스트를 포함한 완성된 DX 예제 프로젝트다.

```bash
# HTTPS로 클론
git clone https://github.com/trailheadapps/dreamhouse-lwc

# SSH로 클론
git clone git@github.com:trailheadapps/dreamhouse-lwc.git
```

Git 없이 시작하려면 GitHub 사이트에서 `.zip` 파일을 다운로드해 로컬 파일시스템 어디에나 압축 해제한다.

> 더 복잡한 예제는 **Sample Gallery**에서 확인 — 플랫폼 최신 기능과 베스트 프랙티스가 지속 업데이트된다.

---

## 프로젝트 생성

### 기본 생성

```bash
# 1. 프로젝트를 생성할 디렉토리로 이동
cd /path/to/your/workspace

# 2. DX 프로젝트 생성 (기본: standard 템플릿, force-app 기본 디렉토리)
sf project generate --name MyProject

# 출력 디렉토리 지정
sf project generate --name MyProject --output-dir /some/other/dir

# 기본 패키지 디렉토리 지정
sf project generate --name MyProject --default-package-dir myapp-source

# 템플릿 지정
sf project generate --name mywork --template standard
sf project generate --name mywork --template empty
sf project generate --name mywork --template analytics
sf project generate --name mywork --default-package-dir myapp-source
```

### `--template` 옵션별 생성 파일

| 템플릿 | 포함 파일 | 설명 |
|---|---|---|
| `empty` | `.forceignore`, `config/project-scratch-def.json`, `sfdx-project.json`, `package.json` | 최소 구성 |
| `standard` (기본) | empty 파일 모두 + `.gitignore`, `.prettierrc`, `.prettierignore`, `.vscode/extensions.json`, `.vscode/launch.json`, `.vscode/settings.json` | VS Code 연동 최적화 |
| `analytics` | standard 파일 모두 + Analytics 템플릿 번들 디렉토리(`/force-app/main/default/waveTemplates`), Apex 클래스, LWC 컴포넌트 등 | Analytics 개발용 |

`--template` 플래그를 지정하지 않으면 `standard` 템플릿이 기본 사용된다.

### VS Code 파일 역할

| 파일 | 역할 |
|---|---|
| `.gitignore` | Git 버전 컨트롤 시작을 쉽게 |
| `.prettierrc` / `.prettierignore` | Aura 컴포넌트 Prettier 포매팅 |
| `.vscode/extensions.json` | VS Code 실행 시 권장 익스텐션 설치 프롬프트 |
| `.vscode/launch.json` | Replay Debugger 구성 |
| `.vscode/settings.json` | 검색/빠른 열기에서 특정 파일·폴더 제외 설정 |

### 프로젝트 생성 후 다음 단계

1. (선택) Dev Hub org에 네임스페이스 등록
2. 프로젝트 설정 (`sfdx-project.json`) — 네임스페이스를 사용하면 이 파일에 포함
3. Scratch org 정의 파일 작성 (`config/project-scratch-def.json` 샘플 포함됨)

---

## 프로젝트 디렉토리 구조

### standard 템플릿 생성 시 전체 구조

```
MyProject/
├── .forceignore                        — 동기화 제외 파일 패턴
├── .gitignore                          — Git 제외 파일
├── .prettierrc                         — Prettier 설정
├── .prettierignore                     — Prettier 제외 파일
├── package.json                        — Node.js 패키지 설정
├── sfdx-project.json                   — DX 프로젝트 메인 설정 파일
├── .vscode/
│   ├── extensions.json                 — VS Code 권장 익스텐션
│   ├── launch.json                     — Replay Debugger 설정
│   └── settings.json                   — 검색·탐색 제외 설정
└── config/
    └── project-scratch-def.json        — Scratch org 정의 파일
```

### 기본 패키지 디렉토리 구조 (`force-app/`)

```
force-app/
└── main/
    └── default/
        ├── aura/                       — Aura 컴포넌트 번들
        ├── classes/                    — Apex 클래스
        ├── digitalExperiences/         — DigitalExperienceBundle (향상된 LWR Sites)
        │   └── site/                   — 각 향상된 LWR 사이트 폴더
        ├── documents/                  — 문서 파일
        │   └── <document-folder>/      — 부모 문서 폴더 내에 위치
        ├── experiences/                — ExperienceBundle (Aura·LWR Sites)
        │   └── <site-name>/            — 각 Aura·LWR 사이트 폴더
        ├── flows/                      — Flow
        ├── layouts/                    — 페이지 레이아웃
        ├── lwc/                        — Lightning Web Components
        │   └── <componentName>/        — 컴포넌트 번들
        ├── objects/                    — Custom Objects (분해됨)
        │   └── <ObjectName>/
        │       ├── <ObjectName>.object-meta.xml
        │       ├── fields/
        │       ├── validationRules/
        │       └── ...
        ├── objectTranslations/         — Custom Object Translations (분해됨)
        ├── staticresources/            — Static Resources
        │   ├── expandedzippedresource/ — 자동 확장된 .zip 아카이브
        │   ├── expandedzippedresource.resource-meta.xml
        │   ├── myimage.gif             — MIME 타입 확장자 파일
        │   └── myimage.gif-meta.xml
        └── ... (기타 메타데이터 타입)
```

---

## 소스 포맷 (Source Format) 개념

### 소스 변환(Source Transformation)이 필요한 이유

전통적인 Metadata API 방식에서는 Custom Object 전체, Object Translation 전체가 하나의 거대한 XML 파일에 저장된다. 이러면:
- 파일이 너무 커서 원하는 내용을 찾기 어렵다
- 팀원 여러 명이 동일 파일을 동시에 수정하면 병합 충돌이 발생한다

**소스 포맷(Source Format)** 은 이 문제를 해결하기 위해 대형 소스 파일을 분해(decompose)해 더 작고 관리하기 쉬운 파일로 나눈다.

### 소스 포맷의 동작 원리

- `project retrieve start` 실행 시: Salesforce CLI가 org에서 가져온 메타데이터를 소스 포맷으로 변환해 저장
- `project deploy start` 실행 시: Salesforce CLI가 소스 포맷을 Metadata API가 요구하는 형식으로 역변환해 배포

### 파일 확장자 규칙

| 방식 | 파일명 예시 | 설명 |
|---|---|---|
| 소스 포맷 — Object | `Case.object-meta.xml` | XML 파일에 `.xml` 확장자 추가 |
| 소스 포맷 — App | `DreamHouse.app-meta.xml` | 타입별 `.{type}-meta.xml` 패턴 |
| 소스 포맷 — Static Resource (MIME) | `myimage.gif` | MIME 타입 확장자로 저장 |
| 소스 포맷 — Static Resource (레거시) | `myresource.resource` | 기존 `.resource` 확장자 유지 |

> 새 Static Resource는 MIME 타입 확장자(`.gif`, `.png` 등)로 저장하는 것을 권장. `.resource` 확장자는 레거시 전환을 위해 계속 지원된다.

---

## Static Resources 처리 규칙

Static Resource는 반드시 `/main/default/staticresources` 디렉토리에 위치해야 한다.

| 동작 | 설명 |
|---|---|
| org에서 `.zip` 아카이브 업로드 후 `project retrieve start` | 자동으로 디렉토리 구조로 확장 |
| 파일시스템에서 직접 구성 | 디렉토리 구조 + `.resource-meta.xml` 파일 생성 후 배포 |
| 단일 파일로 저장된 아카이브 | 단일 파일로만 취급 (자동 확장 없음) |
| `.zip` / `.jar` MIME 타입 | 자동 확장/압축 지원 |

---

## 메타데이터 타입별 저장 위치

| 메타데이터 타입 | 저장 디렉토리 | 특이사항 |
|---|---|---|
| Aura 컴포넌트 | `<package-dir>/aura/` | 반드시 `aura` 디렉토리 |
| Lightning Web Components | `<package-dir>/lwc/` | 반드시 `lwc` 디렉토리 |
| ExperienceBundle (Aura/LWR Sites) | `<package-dir>/experiences/` | 각 사이트별 서브폴더 |
| DigitalExperienceBundle (향상된 LWR Sites) | `<package-dir>/digitalExperiences/site/` | 각 향상된 LWR 사이트별 서브폴더 |
| Documents | `<package-dir>/documents/<document-folder>/` | 부모 문서 폴더 내에 위치 |
| Static Resources | `<package-dir>/staticresources/` | MIME 타입 확장자 권장 |
| Custom Objects | `<package-dir>/objects/` | 기본 분해(decompose) 적용 |
| Custom Object Translations | `<package-dir>/objectTranslations/` | 기본 분해 적용 |

---

## 기존 소스에서 DX 프로젝트 만들기

### 매니지드 패키지(파트너/ISV) 소스 가져오기

```bash
sf project generate --name MyProject
cd MyProject

# 파트너 패키지 조직에서 소스 가져오기
sf project retrieve start \
  --package-name "My Package Name" \
  --target-org <sourceOrg-username-or-alias>

# 다른 디렉토리에 저장하려면
sf project retrieve start \
  --package-name "My Package Name" \
  --target-org <sourceOrg-username-or-alias> \
  --output-dir mypackage
```

### 매니페스트 파일(package.xml) 기반 소스 가져오기

```bash
sf project retrieve start \
  --manifest package.xml \
  --target-org <sourceOrg-username-or-alias>
```

### 매니페스트 파일이 없는 경우 — 자동 생성

```bash
# org에서 매니페스트 생성
sf project generate manifest --from-org prod-org

# 도움말 확인
sf project generate manifest --help
```

### Metadata 형식 → 소스 포맷 변환

이미 Metadata API로 가져온 파일이 있는 경우:

```bash
# metadata 형식 파일을 소스 포맷으로 변환
sf project convert mdapi --root-dir /Users/testing/mdapi_project

# 출력 디렉토리 지정
sf project convert mdapi --root-dir /Users/testing/mdapi_project --output-dir my-package

# 변환된 파일은 sfdx-project.json의 기본 패키지 디렉토리(force-app)에 저장
# 다른 디렉토리에 저장하면 sfdx-project.json에 해당 경로 추가 필요
```

> `convert` 명령은 `.`으로 시작하는 파일(`.DS_Store` 등)을 무시한다. 추가 제외가 필요하면 `.forceignore` 파일을 사용한다.

---

## Usernames, Orgs, 기본 Org 설정

### 기본 Org 설정 방법

```bash
# 로그인 시 기본 Dev Hub org 설정
sf org login web --set-default-dev-hub --alias my-hub-org

# Scratch org 생성 시 기본 org 설정
sf org create scratch \
  --definition-file config/project-scratch-def.json \
  --set-default \
  --alias my-scratch-org
```

### config 명령으로 기본 org 변경

```bash
# 현재 프로젝트에만 적용 (로컬)
sf config set target-org test-wvkpnfm5z113@example.com

# 모든 프로젝트에 적용 (전역)
sf config set target-org test-wvkpnfm5z113@example.com --global

# 기본 Dev Hub org 설정
sf config set target-dev-hub jdoe@mydevhub.com

# config 변수 해제
sf config unset target-org --global

# 설정된 모든 config 변수 확인
sf config list
```

### alias 관리

```bash
# alias 설정
sf alias set my-scratch-org test-wvkpnfm5z113@example.com

# 여러 alias 한 번에 설정
sf alias set org1=<username> org2=<username>

# 모든 alias 확인
sf alias list
sf org list

# alias 제거
sf alias unset my-org
```

> alias는 username 하나에만 연결된다. 동일 alias를 여러 번 set하면 가장 최근 username을 가리킨다.

### Org 목록 확인

```bash
# 기본 org 목록
sf org list

# 상세 정보 (생성일, DevHub, 인스턴스 URL 포함)
sf org list --verbose

# 만료·삭제된 Scratch org 제거
sf org list --clean
```

**출력 예시:**
```
Type  Alias          Username                          Org ID                Expires
──    ─────────────  ────────────────────────────────  ────────────────────  ──────────
D     DevHub         jules@sf.com                      00DB0001234c7jiMAA    Connected
      (Sandbox)      jules@sf.com.jssandtwo            00D020012344XTiEAM    Connected
O     my-scratch-org test-qjrr9q5d13o8@example.com    00DMN0012342Gez2AE    2023-08-21

Legend: D=Default DevHub, O=Default Org
```

### 특정 org에 배포/가져오기

```bash
# 기본 org에 배포
sf project deploy start

# 특정 org 지정
sf project deploy start --target-org my-other-scratch-org

# 특정 Dev Hub 지정
sf org create scratch \
  --target-dev-hub jdoe@mydevhub.com \
  --definition-file my-org-def.json \
  --alias yet-another-scratch-org
```

---

## 네임스페이스를 Dev Hub Org에 연결하기

Scratch org에 네임스페이스를 사용하려면 네임스페이스가 등록된 Developer Edition org를 Dev Hub org에 연결해야 한다.

### 사전 준비

1. 등록된 네임스페이스가 있는 Developer Edition org 준비 (없으면 별도 생성)
2. 해당 org에서 네임스페이스 생성 및 등록

> **주의:** 네임스페이스는 신중하게 선택. org에 연결한 후에는 변경하거나 재사용할 수 없다.

### 연결 절차

```
1. Dev Hub org에 System Administrator 또는 Salesforce DX Namespace Registry 권한 보유 사용자로 로그인
2. App Launcher → Namespace Registries 선택
3. Link Namespace 클릭
4. 팝업 창에서 네임스페이스가 등록된 Developer Edition org에 System Administrator 자격으로 로그인
```

연결된 전체 네임스페이스 확인: Namespace Registries의 **All Namespace Registries** 목록 보기

> 네임스페이스 없이 연결 불가: sandbox, scratch org, patch org, branch org는 네임스페이스가 있어야 Namespace Registry에 연결 가능.

---

## 관련 노트

- [[Salesforce DX 개요]] — sfdx-project.json, Source Format, .forceignore 요약 개요
- [[메타데이터 분해와 forceignore]] — Decomposed Metadata Types 전수, .forceignore 문법 전수
- [[sfdx-project.json 레퍼런스]] — sfdx-project.json 모든 필드·기본값·예제 전수
- [[Scratch Org 패턴]] — Scratch org 생성, 설정, 스냅샷
- [[Unlocked Package 패턴]] — 패키지 생성·버전·배포
- [[CI CD 패턴]] — Jenkins, CircleCI 연동
- [[Source Tracking 변경 추적]] — Source Tracking 전수 (변경 추적·Preview·Deploy/Retrieve·Conflicts 해결)
- [[DX 개발 워크플로]] — CLI 소스 파일 생성·배포·Anonymous Apex·테스트 실행·Debug Logs 전수
