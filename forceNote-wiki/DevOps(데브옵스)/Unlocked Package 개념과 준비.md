---
tags: [devops, salesforce-dx, unlocked-package, packaging, dev-hub, org-dependent]
source: sfdx_dev.pdf (Salesforce DX Developer Guide v67.0)
created: 2026-05-23
aliases: [Unlocked Package란, 패키지 기반 개발, Org-Dependent Unlocked Package, 2GP, 패키지 준비, package development model]
---

# Unlocked Package 개념과 준비

> Unlocked Package의 개념·패키지 기반 개발 모델·사전 준비 체크리스트·Org 역할·Org-Dependent 패키지 전수 설명.

---

## Unlocked Package란?

패키지는 메타데이터를 채워 넣는 컨테이너다. 관련 기능·커스터마이제이션·스키마를 묶은 집합이다.

Unlocked Package는 특히 내부 비즈니스 앱에 적합하다. AppExchange 배포를 계획하지 않는 경우 대부분의 사용 사례에서 올바른 패키지 유형이다. 용도:
- 기존 메타데이터 정리
- 앱 패키징
- AppExchange에서 구매한 앱 확장
- 신규 메타데이터 패키징

> AppExchange 배포를 계획하는 ISV 파트너는 Second-Generation Managed Packages를 사용한다.

### Unlocked Package vs Managed Package

Managed Package는 각 메타데이터 컴포넌트의 동작을 결정하는 관리 규칙이 있다.
Unlocked Package는 유연성이 높다 — 관리자가 Production에서 직접 메타데이터를 수정할 수 있다.
단, 이 유연성에는 책임이 따른다. 관리자가 Production에서 패키지 메타데이터를 직접 편집할 때 개발팀에 알리는 거버넌스 체계가 필요하다.

### 패키지 버전 (Package Version)

- 각 Unlocked Package는 고유한 라이프사이클을 갖는다.
- 메타데이터를 추가할 때마다 **새 패키지 버전**을 생성한다.
- 패키지는 계속 진화하지만, 각 패키지 버전은 **불변(immutable)** 아티팩트다.
- 패키지 버전에는 생성 시점의 특정 메타데이터와 기능이 담겨 있다.
- 설치 가능한 환경: Scratch Org, Sandbox, Trial, Developer Edition, Production
- 패키지 버전은 CI/CD 프로세스의 아티팩트로도 사용 가능

---

## 패키지 기반 개발 모델

### 전통 개발 모델의 문제점

전통적으로 Production Org의 메타데이터는 두 버킷으로 나뉜다:
1. AppExchange에서 설치한 관리 패키지 집합
2. 패키지화되지 않은 메타데이터 (unpackaged metadata)

커스터마이제이션은 하나의 거대한 단일체(monolith)에 쌓인다 → 이해·업그레이드·유지 관리가 어렵다.

### 패키지 기반 개발의 장점

패키지 기반 개발 모델에서 unpackaged 메타데이터를 명확하게 정의된 패키지로 정리한다:
- Salesforce DX 프로젝트로 소스를 패키지 디렉토리로 구성하고 버전 관리
- 버전 관리 가능, 유지 관리 용이, 설치·업그레이드 간편
- Multi-level 의존성 선언 지원 → 패키지를 작고 모듈화된 상태로 유지 가능
- CLI 명령 또는 스크립트로 패키지 개발 자동화 가능

---

## 사전 준비 체크리스트 (Before You Create Unlocked Packages)

```
□ Dev Hub 활성화 (Enable Dev Hub in Your Org)
□ Second-Generation Managed Packaging 활성화
□ Salesforce CLI 설치

라이선스 확인:
  - Unlocked packaging 사용 가능 라이선스: Salesforce 또는 Salesforce Limited Access - Free (파트너 전용)

Permission Set 확인:
  - System Administrator 프로필 또는
  - Create and Update Second-Generation Packages 권한
  (상세: DX 도구 접근 권한 참조)
```

일일 패키지 버전 생성 한도는 일일 Scratch Org 할당과 동일하다. 한도 증가 필요 시 Salesforce 고객 지원에 문의.

Scratch Org와 패키지 버전 생성은 별도로 계산되므로, 패키지 버전 생성이 Scratch Org 한도를 소모하지 않는다.

한도 확인:
```bash
sf limits api display
```

---

## Org 역할 파악 (Know Your Orgs)

Unlocked Package 작업 시 각 Org의 역할을 명확히 한다.

### Dev Hub Org

- 패키지 소유자 (`sf package create` 실행 시 연결된 Dev Hub가 소유)
- Namespace 링크 (Namespaced 패키지 생성 시)
- `sf package` 명령 실행 및 인증 기준
- 비활성화·만료 시 설치된 패키지 업데이트 불가·새 설치 실패 가능
- **Production Org를 Dev Hub로 지정 권장** (패키지 소유 안정성)

### Namespace Org

- Namespace 전용 조직 (패키지에 Namespace 사용 시 필요)
- Namespace Org에서 Namespace를 등록하고 Dev Hub에 연결한다
- 테스트 목적이라면 임시 Namespace 사용 권장

### 기타 Org

| Org 유형 | 역할 |
|---|---|
| Scratch Org | 패키지 개발·테스트 환경 (온디맨드 생성) |
| Installation Org (Target Org) | 패키지를 설치할 대상 조직 |

---

## Org-Dependent Unlocked Packages

Org-Dependent Unlocked Package는 Unlocked Package의 변형으로, **설치 대상 Org의 패키지화되지 않은 메타데이터에 의존하는 패키지**를 생성한다. 의존성 검증이 패키지 버전 생성 시가 아니라 **패키지 설치 시**에 수행된다.

> Org-Dependent Unlocked Package는 별도의 패키지 유형이 아니라 Unlocked Package의 변형이다. 동일한 개발 단계와 지원 메타데이터 유형을 따른다.

### 사용 목적

오래되고 방대한 Production Org는 패키지 기반 ALM을 도입할 때 모든 메타데이터 의존성을 파악하기 어렵다. Org-Dependent 패키지를 사용하면 unpackaged 메타데이터에 의존하는 메타데이터도 패키지화할 수 있다.

```bash
# Org-Dependent Unlocked Package 생성
sf package create \
  -t Unlocked \
  -r force-app \
  -n MyPackage \
  --org-dependent
```

### 일반 Unlocked Package vs Org-Dependent Unlocked Package 비교

| 시나리오 | Unlocked Package | Org-Dependent Unlocked Package |
|---|---|---|
| Build once, install anywhere | Yes | No — 의존 메타데이터가 있는 특정 Org에만 설치 가능 |
| 의존성 검증 시점 | 패키지 버전 생성 시 | 패키지 설치 시 |
| 다른 패키지에 의존 가능 | Yes | No |
| 의존성 해결 없이 패키지 생성 가능 | No (해결 필요) | Yes |
| 지원 메타데이터 타입 | Metadata Coverage Report 참조 | Metadata Coverage Report 참조 (동일) |
| 권장 개발·테스트 환경 | Scratch Org | 의존 메타데이터 포함 Sandbox (Source Tracking 활성화 권장) |
| 코드 커버리지 요건 | 75% (promote 전 필수) | 미계산 (권장: 충분한 테스트) |

패키지 목록에서 Org-Dependent 여부 확인:
```bash
sf package list --verbose
```

---

## 관련 노트

- [[DX 도구 접근 권한]] — Dev Hub 활성화, Permission Set 구성
- [[Unlocked Package 생성과 설정]] — 패키지 생성, sfdx-project.json 설정, 의존성
- [[Unlocked Package 개발과 버전]] — 패키지 버전 생성, 코드 커버리지
- [[Unlocked Package 릴리스와 설치]] — Promote, Push Upgrade, Install, Uninstall
- [[Unlocked Package 패턴]] — 요약 패턴 노트
- [[Scratch Org 생성과 정의 파일]] — 패키지 개발용 Scratch Org 구성
