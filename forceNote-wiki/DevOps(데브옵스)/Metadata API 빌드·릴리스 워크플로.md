---
tags: [devops, salesforce-dx, metadata-api, deploy, sandbox, org-development-model, release]
source: sfdx_dev.pdf (Salesforce DX Developer Guide v67.0)
created: 2026-05-23
aliases: [Org Development Model, 빌드 릴리스, sf project deploy validate, sf project deploy quick, 배포 취소, Cancel Deployment, 릴리스 아티팩트, 스테이징 배포]
---

# Metadata API 빌드·릴리스 워크플로

> Org Development Model에 따른 Sandbox 기반 개발·테스트·릴리스 전수 — Local Dev → Build → Staging → Production → Cancel Deployment.

---

## 개요

코드를 작성한 후 배포하는 방법은 역할과 목적에 따라 다르다.

### 배포 도구 선택

**고객 및 비-ISV 파트너:**

| 도구 | 설명 |
|---|---|
| Agentforce Vibes IDE | VS Code + Salesforce Extensions 기반 웹 IDE |
| Salesforce Extensions for VS Code | 풍부한 개발 도구 제공 VS Code 확장 |
| Salesforce CLI | 개발·빌드 자동화 단일 인터페이스 |
| Metadata API | 배포·검색·생성·수정·삭제 API |
| DevOps Center | 선언적·코드 개발자를 위한 변경 관리 |
| Unlocked Packages | 메타데이터 패키지로 조직 간 배포 |

**ISV 파트너:**

| 도구 | 설명 |
|---|---|
| Second-Generation Managed Packages | AppExchange 배포용 |
| First-Generation Managed Packages | 레거시 AppExchange 배포 |

---

## Org Development Model 워크플로

Sandbox 기반 개발 모델. 릴리스 아티팩트는 Production Org에 업데이트할 변경된 메타데이터 집합이다.

### 개발·릴리스 환경 구성

| 단계 | 환경 | 용도 |
|---|---|---|
| 1. 개발·테스트 | Developer Sandbox (팀원별 개별) | 각 팀원의 커스터마이제이션 개발. Production 데이터 없음 |
| 2. 릴리스 빌드 | Developer Pro Sandbox (공유) | 각 팀원의 변경 통합. 테스트 데이터 시드 가능 |
| 3. 릴리스 테스트 | Partial Sandbox | UAT(사용자 수락 테스트). Production의 완전한 복제본 |
| 4. 릴리스 | Full Sandbox | Production 데이터 복사본으로 사용자 교육 |

### 필요 도구

| 도구 | 용도 |
|---|---|
| Salesforce DX Project | 메타데이터·소스 파일 컨테이너. `sfdx-project.json` 포함 |
| Deployment Artifact (.zip) | 배포할 변경 파일 묶음. Inbound 변경 세트와 유사 |
| Source Control System | 전체 변경 사항 병합·저장 |
| Salesforce CLI | 개발 라이프사이클 전 단계 자동화 |
| Salesforce Extensions for VS Code | CLI 기반 통합 개발 환경 |
| Change Management Tool | 변경 목록, 배포 실행 목록 등 외부 추적 도구 |

---

## Apex 코드 배포 고려사항

Production에 Apex 배포 시 단위 테스트가 커버리지 요건을 충족해야 한다.

테스트 실행 기본 동작 (TestLevel 미지정 시):
- 배포 패키지에 Apex 클래스 또는 트리거 포함 → 관리 패키지 테스트를 제외한 모든 테스트 실행
- 배포 패키지에 Apex 코드 미포함 → 기본적으로 테스트 미실행

권장: Production 배포 전 개발 환경(Sandbox)에서 로컬 테스트를 모두 실행해 Production 배포에서 필요한 테스트 수를 줄인다.

---

## Step 1 — 로컬 개발 및 변경 (Develop and Test Changes Locally)

Developer Sandbox에서 Source Format으로 개발하고, 변경 사항을 검색해 Source Control에 커밋한다.

```bash
# 1. DX 프로젝트 생성
#    (기존 프로젝트가 있으면 필수 DX 설정 파일 확인)

# 2. Developer Sandbox 인증
sf org login web --target-org dev-sandbox --alias dev-sandbox

# 3. Developer Sandbox에서 개발 작업 수행

# 4. 변경 사항 검색
# Source Tracking 활성화 Sandbox: 변경된 메타데이터만 자동 감지
sf project retrieve start

# Source Tracking 비활성화 또는 대량 변경 시: manifest 사용
sf project retrieve start --manifest path/to/package.xml

# 5. Source Control에 커밋
git add .
git commit -m "feat: [기능 설명]"
```

---

## Step 2 — 릴리스 아티팩트 빌드·테스트 (Build and Test the Release Artifact)

팀의 변경 사항을 Developer Pro Sandbox에서 통합하고 릴리스 아티팩트(배포용 .zip)를 빌드한다.

```bash
# 1. 레포에서 최신 변경 사항 pull
git pull origin main

# 2. Developer Pro Sandbox 인증
sf org login web --target-org dev-pro-sandbox --alias dev-pro-sandbox

# 3. 통합 배포 (실제 Production 배포를 미리 실행)
sf project source deploy \
  --manifest manifest/package.xml \
  --target-org dev-pro-sandbox \
  --test-level RunSpecifiedTests \
  --tests TestMyCode

# 4. Sandbox 열어서 테스트 수행
sf org open --target-org dev-pro-sandbox

# 5. 테스트 통과 시 → Staging(Full Sandbox)으로 진행
```

---

## Step 3 — 스테이징 환경 테스트 (Test the Release Artifact in a Staging Environment)

Full Sandbox에서 Production 배포와 동일한 Quick Deploy를 리허설한다.

```bash
# 1. Full Sandbox 인증
sf org login web --target-org full-sandbox --alias full-sandbox

# 2. 검증 실행 (컴포넌트 저장 없이 테스트만 실행)
sf project deploy validate \
  --manifest manifest/package.xml \
  --target-org full-sandbox \
  --test-level RunLocalTests

# 3. 실제 Production 배포와 동일한 Quick Deploy 준비
sf project deploy validate \
  --manifest manifest/package.xml \
  --target-org full-sandbox \
  --test-level RunSpecifiedTests
# → Job ID 반환 (다음 Quick Deploy에 사용)

# 4. Quick Deploy 테스트
sf project deploy quick \
  --target-org full-sandbox \
  --job-id <jobID>
```

> 검증 후 **10일 이내**에 Quick Deploy를 Production에 실행해야 한다.

---

## Step 4 — Production 릴리스 (Release Your App to Production)

```bash
# 1. 사전 배포 작업 목록 완료

# 2. Production Org 인증
sf org login web --target-org prod-org --alias prod-org

# 3. 검증 실행 (Job ID 획득)
sf project deploy validate \
  --source-dir force-app \
  --target-org prod-org \
  --test-level RunLocalTests
# → Job ID 반환

# 4. 모든 Apex 테스트 통과 + 코드 커버리지 75% 이상 확인

# 5. Quick Deploy 실행
sf project deploy quick \
  --target-org prod-org \
  --job-id <jobID>

# 6. Production Org 열기 + 사후 배포 작업 목록 완료
sf org open --target-org prod-org
```

---

## 배포 취소 (Cancel a Metadata Deployment)

진행 중인 배포를 Salesforce CLI에서 취소한다.

```bash
# 가장 최근 배포 취소
sf project deploy cancel --use-most-recent

# 특정 Job ID로 취소
sf project deploy cancel --job-id <jobid>

# 대기 시간 지정 (기본 33분)
sf project deploy cancel --wait 20 --use-most-recent
```

취소 상태 확인:
```bash
sf project deploy report --use-most-recent
```

---

## 관련 노트

- [[DX 인증 방식]] — 각 환경 인증
- [[Sandbox 관리]] — Sandbox 생성·갱신 절차
- [[Metadata API File-Based 호출]] — deploy·retrieve·package.xml 상세
- [[Source Tracking 변경 추적]] — Source Tracking 활성화 Sandbox에서 변경 감지
- [[CI 통합 전수 (CircleCI·Jenkins·Travis)]] — 배포 자동화 CI 파이프라인
- [[Unlocked Package 릴리스와 설치]] — 패키지 기반 배포 모델과 비교
