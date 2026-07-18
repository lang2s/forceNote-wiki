---
tags: [devops, salesforce-dx, dx-overview, workflow, getting-started, cli, vs-code]
source: sfdx_dev.pdf v67.0 Summer '26 — Ch.1 (p.1–14)
created: 2026-05-23
aliases: [DX 도구, DX 개발 방식, DX 시작, How DX Works, 소스 중심 개발 개요, dreamhouse-lwc, DX 워크플로 전환]
---

# DX 도구 개요와 워크플로 전환

> Salesforce DX 도구가 기존 org-centric 개발 방식을 어떻게 바꾸는지 — 샘플 레포·신규 프로젝트·마이그레이션의 3가지 시작 경로와 완전한 CLI 워크플로 전수.

---

## Salesforce DX가 바꾸는 것

| 기존 방식 | DX 방식 |
|---|---|
| Org가 source of truth | VCS(Git)가 source of truth |
| Setup UI에서 직접 수정 | 로컬 파일 → deploy → org |
| 팀 협업 = 수동 병합 | 버전 관리 + CI/CD |
| IDE 종속(Developer Console) | 내가 원하는 IDE + CLI |
| 재현 불가한 org 상태 | Scratch Org로 재현 가능한 환경 |

핵심 특징:
- **소스 중심(source-driven)**: 소스 코드와 메타데이터가 org 외부에 존재.
- **CLI 중심**: `sf` CLI로 org 조작·CI/CD·배포 전과정 처리.
- **Scratch Org**: 재현 가능·자동화 가능한 개발 환경 (Dev Hub 필요).
- **패키지 기반**: Unlocked Package로 앱을 불변 버전으로 관리.

> Note: Salesforce DX 도구에는 **API Enabled** 시스템 권한이 필요하다.

---

## 시작 경로 1 — 샘플 레포로 빠른 시작 (dreamhouse-lwc)

DX를 가장 빠르게 체험하는 방법은 `dreamhouse-lwc` GitHub 레포를 클론하는 것이다.

### 전제 조건
- Dev Hub org (Developer Edition 또는 Trailhead Playground)
- Salesforce CLI 설치 완료

### 단계별 명령

```bash
# 1. 레포 클론 (HTTPS)
git clone https://github.com/trailheadapps/dreamhouse-lwc.git

# SSH 방식
git clone git@github.com:trailheadapps/dreamhouse-lwc.git

# 2. 디렉토리 이동
cd dreamhouse-lwc

# 3. Dev Hub 인증 (기본값 설정 + 별칭)
sf org login web --set-default-dev-hub --alias DevHub

# 4. Scratch Org 생성 (기본값 + 별칭)
sf org create scratch \
  --definition-file config/project-scratch-def.json \
  --set-default \
  --alias my-scratch-org

# 5. 인증된 org 목록 확인
sf org list

# 6. force-app 소스를 Scratch Org에 배포
sf project deploy start --source-dir force-app

# 7. dreamhouse 권한 세트 할당
sf org assign permset --name dreamhouse

# 8. 샘플 데이터 임포트 (Contact, Property, Broker)
sf data import tree --plan data/sample-data-plan.json

# 9. Apex 테스트 실행
sf apex run test --result-format human --wait 1

# 10. Scratch Org 브라우저로 열기
sf org open
```

`sf org list` 출력 예시:
```
Type    Alias          Username                           Org ID             Status    Expires
──      ─────────      ─────────────────────────────      ──────────────     ──────    ──────
(D)     DevHub         jules@sf.com                       00Daj0AUXXXXXXXX   Connected
        –              jules@sf.com.jssandtwo             00D02000EAMXXXXX   Connected
(S)     my-scratch-org test-loo73bj6givn@example.com      00D7xOjgTEASXXXX   Active    2024-05-16

Legend: (D)=DevHub, (S)=Default Org
```

---

## 시작 경로 2 — 새 DX 프로젝트 생성

Salesforce 커스터마이징을 처음부터 소스 중심으로 개발할 때의 완전한 흐름.

### 1. Dev Hub org 준비

Developer Edition 또는 Trailhead Playground org를 Dev Hub로 설정한다.

```bash
# Setup > Quick Find > "Dev Hub" > Enable Dev Hub 클릭 후
# 로컬에서 인증
sf org login web --set-default-dev-hub --alias DevHub
```

### 2. Salesforce CLI & VS Code 설치

```bash
# CLI 설치 확인
sf version
# 출력 예: @salesforce/cli/2.98.6 darwin-arm64 node-v22.17.0

# npm으로 설치할 경우
npm install -g @salesforce/cli
```

VS Code에는 **Salesforce Extensions** 확장팩을 추가한다.  
인터넷 브라우저 기반 IDE를 원하면 **Agentforce Vibes IDE** 사용 가능.

### 3. DX 프로젝트 생성

```bash
# 원하는 디렉토리로 이동
cd /Users/juliet/sfdx

# 프로젝트 생성
sf project generate --name mydxproject

# 프로젝트 디렉토리로 이동
cd mydxproject
```

생성된 주요 파일:

| 파일/폴더 | 역할 |
|---|---|
| `sfdx-project.json` | DX 프로젝트 메인 설정 |
| `config/project-scratch-def.json` | Scratch Org 정의 파일 |
| `.forceignore` | 동기화 제외 파일 지정 (.gitignore 형식) |
| `force-app/` | org 메타데이터 소스 디렉토리 |

### 4. Dev Hub 인증 + Scratch Org 생성

```bash
# Dev Hub 인증
sf org login web --set-default-dev-hub --alias DevHub

# Scratch Org 생성
sf org create scratch \
  --definition-file config/project-scratch-def.json \
  --set-default \
  --alias myscratch

# 생성 확인
sf org list
sf org display
```

### 5. Scratch Org에서 변경 후 검색 (Retrieve)

```bash
# Scratch Org를 브라우저로 열기
sf org open
# --target-org 플래그로 특정 org 지정 가능
sf org open --target-org myscratch

# 변경사항 검색 (Scratch Org → 로컬 프로젝트)
sf project retrieve start
```

### 6. Apex 클래스 생성 후 배포

VS Code 커맨드 팔레트: `SFDX: Create Apex Class` 실행 후:

```bash
# 배포 (로컬 → Scratch Org)
# VS Code: SFDX: Push Source to Default Org
# 또는 CLI:
sf project deploy start --source-dir force-app

# org에서 변경 후 다시 검색
# VS Code: SFDX: Pull Source from Default Org
```

배포 출력 예시:
```
=== Pushed Source
STATE   FULL NAME    TYPE        PROJECT PATH
─────── ─────────── ─────────── ─────────────────────────────────────────────
Created MyApexClass ApexClass   force-app/main/default/classes/MyApexClass.cls
Created MyApexClass ApexClass   force-app/main/default/classes/MyApexClass.cls-meta.xml
```

### 7. LWC 컴포넌트 생성 후 배포

VS Code 커맨드 팔레트: `SFDX: Create Lightning Web Component` 실행 후:

```bash
# 배포 확인
sf project deploy start --source-dir force-app --target-org DevHub
```

전체 배포 출력 예시 (Custom Field + ApexClass + LWC 동시 배포):
```
=== Deployed Source
State   Name                                    Type                     Path
─────── ─────────────────────────────────────── ──────────────────────── ───────────────
Created MyApexClass                             ApexClass                force-app/.../MyApexClass.cls
Created Account.Account_Status__c               CustomField              force-app/.../Account_Status__c.field-meta.xml
Changed Account-Account Layout                  Layout                   force-app/.../Account Layout.layout-meta.xml
Created helloworld                              LightningComponentBundle force-app/.../helloworld.html
Created helloworld                              LightningComponentBundle force-app/.../helloworld.js
```

### 8. VCS(Git)에 추가

```bash
# 일반적인 다음 단계 — 로컬 DX 프로젝트를 GitHub에 푸시하면
# 팀 협업, CI 테스트, Source of Truth 역할을 VCS가 담당
git init
git add .
git commit -m "initial DX project"
git remote add origin <github-repo-url>
git push -u origin main
```

---

## 시작 경로 3 — 기존 소스 마이그레이션

기존 org의 메타데이터를 DX 소스 포맷으로 변환하는 흐름.

```bash
# 1. 프로젝트 설정
sf project generate --name myproject

# 2. 기존 org에서 메타데이터 검색 (Metadata API)
sf project retrieve start --target-org <prod-org>

# 3. 메타데이터 포맷 → 소스 포맷 변환
#    (이미 Metadata API retrieve 형식의 디렉토리 구조라면 스킵 가능)
sf project convert mdapi --root-dir <mdapi-dir>

# 4. Dev Hub 인증
sf org login web --set-default-dev-hub --alias DevHub

# 5. Scratch Org 생성
sf org create scratch --definition-file config/project-scratch-def.json --set-default

# 6. 소스를 Scratch Org에 배포
sf project deploy start --source-dir force-app

# 7. 개발 & 테스트
sf apex run test --result-format human

# 8. VCS 커밋 + PR
git add . && git commit -m "migrate from org" && git push

# 9. 릴리스 (둘 중 선택)
# a) Managed Package 방식
# b) Metadata API 방식
sf project deploy start --target-org <sandbox>
```

---

## DX 기반 앱 개발 표준 워크플로 (Create Application)

```
1. 프로젝트 설정         → sf project generate
2. Dev Hub 인증          → sf org login web --set-default-dev-hub
3. 로컬 프로젝트 설정     → sfdx-project.json, .forceignore 편집
4. Scratch Org 생성      → sf org create scratch
5. 소스 배포             → sf project deploy start
6. 앱 개발               → Apex / LWC / Flow / 커스텀 객체 생성
7. 소스 동기화            → sf project retrieve start (org → 로컬)
8. 테스트 실행            → sf apex run test
9. VCS 커밋 + PR         → git add / commit / push
릴리스:
  - Managed Package      → sf package version create & install
  - Metadata API         → sf project deploy start --target-org <prod>
```

---

## DX Release Notes 확인 위치

| 구분 | URL |
|---|---|
| VS Code Extensions | salesforcedx-vscode GitHub Releases |
| Salesforce CLI | npm @salesforce/cli releases |
| Developer Environments (Sandbox·Scratch Org) | Salesforce Release Notes > Development Environments |
| Packaging | Salesforce Release Notes > Packaging |
| New/Changed for Developers (Apex·sObjects·Metadata API) | Salesforce Release Notes > For Developers |

---

## 관련 노트
- [[Salesforce DX 개요]] — DX 허브/요약 (sfdx-project.json·기본 명령 개요)
- [[DX 프로젝트 구조와 소스 포맷]] — 프로젝트 디렉토리·소스 포맷 심층 분석
- [[DX 인증 방식]] — org login web·JWT Flow·External Client App 전수
- [[Scratch Org 생성과 정의 파일]] — project-scratch-def.json 전수
- [[Source Tracking 변경 추적]] — deploy/retrieve·충돌 해결
- [[DX 개발 워크플로]] — Apex·LWC·Trigger 생성 명령 전수
- [[Metadata API 빌드·릴리스 워크플로]] — Sandbox 기반 Org Development Model
