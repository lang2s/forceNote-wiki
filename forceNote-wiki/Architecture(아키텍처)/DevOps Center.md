---
tags: [DevOps, DevOps-Center, Pipeline, Deployment, CLI, Source-Control, Change-Management]
source: external-knowledge
created: 2026-05-23
aliases: [DevOps Center, Salesforce DevOps Center, 데브옵스 센터, 파이프라인 배포, 변경관리 도구]
---

# DevOps Center

> Salesforce 공식 릴리즈 관리 도구 — Git 기반 소스 추적과 파이프라인 스테이지 단계 배포를 UI 없이 설정 가능

> [!warning] 이 노트는 외부 지식 기반으로 작성되었으며 공식 소스와 대조되지 않았습니다.
> 공식 문서: https://help.salesforce.com/s/articleView?id=sf.devops_center_overview.htm

---

## 개념 설명

DevOps Center는 **Salesforce 내장 변경 관리 및 파이프라인 도구**로, Salesforce 조직(org) 간 메타데이터 변경을 Git 저장소와 연계해 추적·승인·배포하는 워크플로를 제공한다.

### 핵심 개념

| 개념 | 설명 |
|---|---|
| **Work Item** | 변경의 단위. 하나의 기능·버그 수정을 추적하는 티켓 개념 |
| **Pipeline** | 변경이 통과해야 하는 환경(스테이지) 순서 (예: Dev → QA → Staging → Prod) |
| **Stage** | 파이프라인의 각 환경. Dev Hub와 연결된 Scratch Org 또는 Sandbox |
| **Bundle** | 여러 Work Item을 묶어 한 번에 배포하는 단위 |
| **Promotion** | 한 스테이지에서 다음 스테이지로 변경을 이동시키는 작업 |

### 아키텍처 개요

```
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

## 설정 방법

### 사전 요건

- DevOps Center 패키지가 Dev Hub org에 설치되어 있어야 한다
- GitHub / GitLab 등 외부 Git 저장소 연결 필요
- Dev Hub 활성화 필수

### 파이프라인 생성 절차

```bash
# 1. Dev Hub에서 DevOps Center 패키지 설치 후 앱에 접근
# (UI 기반: Setup > DevOps Center 앱 열기)

# 2. Git 저장소 연결 (Connected App 또는 GitHub 앱)

# 3. 파이프라인 생성 → 스테이지 환경 추가

# 4. Work Item 생성 후 변경 작업 시작
```

### Salesforce CLI로 파이프라인 배포 (Winter '24 Beta)

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

### 2. Bundle 배포 워크플로

```
여러 Work Item → Bundle 생성 → Validate-Only → Deploy
```

---

## CLI 연동 명령 (DevOps Center 플러그인 v6.0 이상)

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
- 한 번에 최대 **500개** Work Item 추적 가능
- 외부 CI/CD 도구(GitHub Actions 등)와 병행 사용 가능하나 파이프라인 동기화 주의
- Managed Package 배포는 DevOps Center 미지원 — Unlocked Package 권장
- 2GP 패키지 기반 프로젝트에 최적화

---

## 비교표 (DevOps Center vs 기존 방식)

| 항목 | DevOps Center | 기존 Change Set | Salesforce CLI + CI |
|---|---|---|---|
| Git 통합 | ✅ 네이티브 | ❌ 없음 | ✅ 직접 구성 |
| UI 관리 | ✅ GUI | ✅ GUI | ❌ CLI만 |
| 자동화 | ✅ CLI 지원 | ❌ | ✅ 완전 자동화 |
| 의존성 추적 | ✅ 자동 | ⚠️ 수동 | ⚠️ 수동 |
| 학습 곡선 | 낮음 | 매우 낮음 | 높음 |

---

## 관련 노트
- [[Salesforce DX 개요]]
- [[CI CD 패턴]]
- [[Unlocked Package 패턴]]
- [[Scratch Org 패턴]]
