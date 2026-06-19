---
tags: [DevOps, DevOps-Center, Pipeline, Deployment, CLI, Source-Control, Change-Management, DevHubSettings, Scratch-Org, MCP]
source: salesforce_apex_developer_guide.pdf, api_meta.pdf, sfdx_dev.pdf (+ 일부 블록 external-knowledge — 본문 한정 경고 배너 참조)
created: 2026-05-23
updated: 2026-06-19
aliases: [DevOps Center, Salesforce DevOps Center, 데브옵스 센터, 파이프라인 배포, 변경관리 도구]
---

# DevOps Center

> Salesforce 공식 변경·릴리즈 관리 도구 — 파이프라인을 구성해 work item을 개발에서 프로덕션까지 릴리즈 생명주기를 따라 승격(promote)한다.

> 이 노트는 공식 PDF(Apex Developer Guide / Metadata API / SFDX Dev Guide)로 검증되었으며, 일부 운영 디테일 블록은 외부지식으로 별도 표시한다.

---

## 개념 설명

DevOps Center는 **Salesforce 내장 변경 관리 및 파이프라인 도구**로, Salesforce 조직(org) 간 메타데이터 변경을 Git 저장소와 연계해 추적·승인·배포하는 워크플로를 제공한다.

### 핵심 개념

| 개념 | 설명 |
|---|---|
| **Work Item** | 변경의 단위. 하나의 기능·버그 수정을 추적하는 티켓 개념 |
| **Pipeline** | 변경이 통과해야 하는 환경(스테이지) 순서 (예: Dev → QA → Staging → Prod) |
| **Stage** | 파이프라인의 각 환경. Dev Hub와 연결된 Scratch Org 또는 Sandbox |
| **Bundle** | 여러 Work Item을 묶어 한 번에 배포하는 단위 (미검증) |
| **Promotion** | 한 스테이지에서 다음 스테이지로 변경을 이동시키는 작업 |

### 아키텍처 개요

> [!warning] 아래 블록은 공식 PDF(Apex Dev Guide / Metadata API / SFDX)에서 확인되지 않은 외부지식이며 공식 소스와 대조되지 않았습니다.

```
// 구조 예시 — 실제 원본 다이어그램 아님
Git Repository (GitHub / GitLab / Bitbucket)
        │
        ▼
DevOps Center (Salesforce org 내 설치)
        │
   ┌────┴────┐
   │ Pipeline │
   └────┬────┘
        │
   Stage 1 (Dev)  →  Stage 2 (QA)  →  Stage 3 (Staging)  →  Stage 4 (Production)
   [Scratch Org]     [Sandbox]         [Sandbox]              [Prod Org]
```

---

## Apex 배포 방법 중 DevOps Center의 위치

[salesforce_apex_developer_guide.pdf] Apex Developer Guide는 Apex를 배포하는 5가지 방법을 제시하며, DevOps Center는 그중 다섯 번째다.

1. **Deploy Apex Using Change Sets** — 연결된 조직(예: sandbox → production) 간 Apex 클래스·트리거를 배포.
2. **Deploy Apex Using Salesforce Extensions for Visual Studio Code and Code Builder** — Salesforce CLI와 Salesforce API로 구동되는 VS Code 및 Code Builder 확장.
3. **Deploy Apex Using Metadata API** — custom object 정의 등 커스터마이징 정보를 배포.
4. **Deploy Apex Using Tooling API** — 복합 타입의 단일 요소만 변경 가능해 Apex 클래스·트리거 배포에 용이.
5. **Deploy Apex Using DevOps Center** — 변경·릴리즈 관리 경험을 개선.

> Salesforce DevOps Center provides an improved experience around change and release management. Build a pipeline when you configure DevOps Center and use the pipeline to promote work items through the release lifecycle from development to production.

자세한 내용은 *Manage and Release Changes Easily and Collaboratively with DevOps Center: Promote Work Items Through Your Pipeline* 참조.

---

## 설정 방법

### 사전 요건

- DevOps Center 패키지가 Dev Hub org에 설치되어 있어야 한다
- GitHub / GitLab 등 외부 Git 저장소 연결 필요
- Dev Hub 활성화 필수

### 개발 환경 요건

[salesforce_apex_developer_guide.pdf] DevOps Center 개발 환경으로 쓰려면 **source tracking이 활성화된** sandbox 또는 scratch org가 필요하다. Developer Edition org은 source tracking이 없어 DevOps Center 개발 환경으로 사용할 수 없다.

| 환경 | source tracking | DevOps Center 개발환경 사용 |
|---|---|---|
| Sandbox (Developer / Developer Pro) | 활성화 시 지원 | 사용 가능 |
| Developer Edition org | 미지원 | 사용 불가 |

---

## DevHubSettings 메타데이터 (DevOps Center 활성화)

[api_meta.pdf] `<DevHubSettings>`는 Settings 메타데이터 타입으로, Dev Hub의 설정값을 담는다. 값은 `settings` 폴더의 `DevHub.settings` 파일에 저장되며 API 버전 47.0 이상에서 사용 가능하다. DevOps Center 활성화 관련 필드는 다음 두 가지다.

| 필드 | 타입 | 설명 | API 버전 | 비고 |
|---|---|---|---|---|
| `enableALMDevopsCorePref` | boolean | next-generation DevOps Center (Beta), AI-powered 활성화 | v65.0+ | Beta 약관 적용 |
| `enableDevOpsCenterGA` | boolean | DevOps Center managed package (GA, older version) 활성화 | v56.0+ | — |

```xml
<?xml version="1.0" encoding="UTF-8"?>
<DevHubSettings xmlns="http://soap.sforce.com/2006/04/metadata">
    <enablePackaging2>true</enablePackaging2>
    <enableScratchOrgManagementPref>true</enableScratchOrgManagementPref>
</DevHubSettings>
```

> `enableALMDevopsCorePref`는 Beta 서비스로, Beta Services Terms 또는 별도 Unified Pilot Agreement가 적용된다. `enableDevOpsCenterGA`는 일반 공급(GA)되는 구버전 DevOps Center 패키지를 활성화한다.

---

## Scratch Org에서 DevOps Center 활성화

[sfdx_dev.pdf] scratch org feature `DevOpsCenter`는 파트너가 DevOps Center 애플리케이션(base) 패키지의 기능을 확장·강화하는 2세대 관리형 패키지(2GP)를 제작하도록 scratch org에서 DevOps Center를 활성화한다.

먼저 Dev Hub org에서 org preference를 활성화해야 한다: Setup의 Quick Find에 *DevOps Center*를 입력하고 **DevOps Center**를 선택. org preference가 활성화된 후에 scratch org를 생성할 수 있다.

scratch org 정의 파일 예시:

```json
{
  "orgName": "Acme",
  "edition": "Enterprise",
  "features": ["DevOpsCenter"],
  "settings": { "devHubSettings": { "enableDevOpsCenterGA": true } }
}
```

org shape 기반으로 scratch org를 만드는 경우에도, DevOpsCenter feature와 setting을 정의 파일에 **명시적으로** 추가해야 한다. org shape는 보안·법적 이유로 DevOps Center 활성화 상태를 캡처하지 않기 때문이다.

> We require that customers explicitly enable it for legal reasons as part of the DevOps Center terms and conditions.

또한 DevOps Center 개발 환경용으로 scratch org나 sandbox를 만들 때 source tracking을 비활성화해서는 안 된다.

> If creating a scratch org or sandbox for use as a development environment in DevOps Center, don't disable source tracking.

---

## DX MCP Server (Beta) — devops 툴셋

[sfdx_dev.pdf] Salesforce DX MCP Server(Beta)는 LLM 컨텍스트를 좁히기 위해 도구를 기능별 툴셋으로 묶는다. 그중 `devops` 툴셋(소문자)은 DevOps Center 내에서 다음 작업을 수행한다.

1. Manage work items — work item 관리
2. Resolve merge conflicts — 병합 충돌 해결
3. Troubleshoot deployment problems within DevOps Center — DevOps Center 내 배포 문제 진단

자세한 내용은 *DevOps MCP Tools documentation* 참조. 더 깊은 MCP 내용은 [[DX MCP Server (Beta)]] 참조.

---

### 파이프라인 생성 절차

> [!warning] 아래 블록은 공식 PDF(Apex Dev Guide / Metadata API / SFDX)에서 확인되지 않은 외부지식이며 공식 소스와 대조되지 않았습니다.


```bash
# 1. Dev Hub에서 DevOps Center 패키지 설치 후 앱에 접근
# (UI 기반: Setup > DevOps Center 앱 열기)

# 2. Git 저장소 연결 (Connected App 또는 GitHub 앱)

# 3. 파이프라인 생성 → 스테이지 환경 추가

# 4. Work Item 생성 후 변경 작업 시작
```

### Salesforce CLI로 파이프라인 배포 (Winter '24 Beta)

> [!warning] 아래 블록은 공식 PDF(Apex Dev Guide / Metadata API / SFDX)에서 확인되지 않은 외부지식이며 공식 소스와 대조되지 않았습니다.
> 특히 `sf project deploy pipeline` 명령은 검증한 49개 공식 PDF 어디에서도 확인되지 않았다(0건).

```bash
# 파이프라인 스테이지에 배포
sf project deploy pipeline --devops-center-project-name "MyProject" \
  --branch-name "feature/my-feature" \
  --devops-center-username admin@devhub.com

# Validate-Only 배포 (번들링 단계에서 사전 검증)
sf project deploy pipeline --devops-center-project-name "MyProject" \
  --branch-name "main" \
  --devops-center-username admin@devhub.com \
  --validate-only

# 배포 결과 확인
sf project deploy pipeline report --job-id <jobId>
```

---

## 주요 워크플로

> [!warning] 아래 블록은 공식 PDF(Apex Dev Guide / Metadata API / SFDX)에서 확인되지 않은 외부지식이며 공식 소스와 대조되지 않았습니다.

### 1. 개발 워크플로

```
Work Item 생성
    → Dev 스테이지에서 변경 작업 (org에서 직접 수정 또는 CLI)
    → 변경 사항 Work Item에 추가 (Pull Changes)
    → 리뷰 요청
    → QA 스테이지로 Promote
    → ... (각 스테이지 반복)
    → Production 배포
```

---

## CLI 연동 명령 (DevOps Center 플러그인 v6.0 이상)

> [!warning] 아래 블록은 공식 PDF(Apex Dev Guide / Metadata API / SFDX)에서 확인되지 않은 외부지식이며 공식 소스와 대조되지 않았습니다.

```bash
# DevOps Center CLI 플러그인 설치
sf plugins install @salesforce/plugin-devops-center

# 프로젝트 목록
sf project deploy pipeline list --devops-center-username admin@devhub.com

# 특정 Work Item 배포
sf project deploy pipeline --devops-center-project-name "MyProject" \
  --work-item-name "W-001" \
  --devops-center-username admin@devhub.com

# 번들링 스테이지 Validate-Only 배포
sf project deploy pipeline --devops-center-project-name "MyProject" \
  --bundle-version-name "v1.0" \
  --devops-center-username admin@devhub.com \
  --validate-only
```

---

## Scratch Org vs Sandbox 스테이지

> [!warning] 아래 블록은 공식 PDF(Apex Dev Guide / Metadata API / SFDX)에서 확인되지 않은 외부지식이며 공식 소스와 대조되지 않았습니다.

| 항목 | Scratch Org 스테이지 | Sandbox 스테이지 |
|---|---|---|
| **용도** | 격리된 개발 환경 | 통합 테스트·스테이징 |
| **데이터** | 없음 (시드 필요) | Sandbox 데이터 |
| **수명** | 1~30일 | 지속적 |
| **생성 속도** | 빠름 | 느림 (복사 시간) |
| **권장 스테이지** | Dev | QA / Staging |

---

## 제한 사항

- DevOps Center 자체가 Salesforce org(Dev Hub)에 설치되는 앱 — 추가 라이선스 없이 사용 가능하나 Dev Hub 필수
- 한 번에 최대 **500개** Work Item 추적 가능 (미검증 — 공식 PDF 무근거)
- 외부 CI/CD 도구(GitHub Actions 등)와 병행 사용 가능하나 파이프라인 동기화 주의
- Managed Package 배포는 DevOps Center 미지원 — Unlocked Package 권장 (미검증)
- 2GP 패키지 기반 프로젝트에 최적화 (미검증)

---

## 비교표 (DevOps Center vs 기존 방식)

> [!warning] 아래 블록은 공식 PDF(Apex Dev Guide / Metadata API / SFDX)에서 확인되지 않은 외부지식이며 공식 소스와 대조되지 않았습니다.

| 항목 | DevOps Center | 기존 Change Set | Salesforce CLI + CI |
|---|---|---|---|
| Git 통합 | ✅ 네이티브 | ❌ 없음 | ✅ 직접 구성 |
| UI 관리 | ✅ GUI | ✅ GUI | ❌ CLI만 |
| 자동화 | ✅ CLI 지원 | ❌ | ✅ 완전 자동화 |
| 의존성 추적 | ✅ 자동 | ⚠️ 수동 | ⚠️ 수동 |
| 학습 곡선 | 낮음 | 매우 낮음 | 높음 |

---

## 관련 노트
- [[Apex 배포 방법]] — Apex 배포 5가지 방법 카탈로그 (DevOps Center는 5번 방법)
- [[Salesforce DX 개요]]
- [[CI CD 패턴]]
- [[Unlocked Package 패턴]]
- [[Scratch Org 패턴]]
- [[DX MCP Server (Beta)]]
- [[Scratch Org Settings 레퍼런스]]
- [[Scratch Org 생성과 정의 파일]]

### 외부 참조
- DevOps Center 개요 (Salesforce Help): https://help.salesforce.com/s/articleView?id=sf.devops_center_overview.htm
