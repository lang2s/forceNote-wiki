---
tags: [devops, salesforce-dx, scratch-org, sandbox, developer-edition, dev-environment, decision-guide]
source: 조합 노트 (Sandbox 관리.md · Scratch Org 패턴.md · Scratch Org 생성과 정의 파일.md · Salesforce DX 개요.md · Org Shape와 Snapshot.md · Source Tracking 변경 추적.md — 모두 sfdx_dev.pdf v67.0 / help.salesforce.com 기반 Tier 2 승계)
created: 2026-07-12
aliases: [개발 환경 선택, Scratch Org vs Sandbox, Sandbox vs Developer Edition, 환경 전략, dev environment decision, 어떤 org를 써야 하나]
---

# 개발 환경 선택 (Scratch Org vs Sandbox vs Developer Edition)

> "기능 개발·CI 재현엔 Scratch Org, prod 유사 UAT·통합 테스트엔 Sandbox, 개인 학습·영구 데모엔 Developer Edition" — 세 개발 환경을 결정 축별로 비교해 상황에 맞는 org를 고르는 가이드.

---

## 언제 무엇을 — 3줄 결론

- **기능 개발 / CI 재현성 / 패키지 검증** → **Scratch Org** (정의 파일로 매번 동일 환경을 즉석 생성·폐기)
- **Production 유사 UAT / 통합 테스트 / 스테이징 / 릴리스 리허설** → **Sandbox** (prod 메타데이터·데이터 복제, 지속 환경)
- **개인 학습 / 영구 데모 / 네임스페이스 등록용 org** → **Developer Edition** (무료·영구, 셋업 불필요, 샘플 데이터 포함)

세 환경은 배타적이지 않다. 실무에서는 Dev Hub(보통 Production 또는 DE) 아래 Scratch Org로 개발하고, Sandbox로 UAT·스테이징을 거쳐 Production에 배포하는 **파이프라인**으로 함께 쓴다.

---

## 결정 매트릭스

| 결정 축 | Scratch Org | Sandbox (Dev / Dev Pro / Partial / Full) | Developer Edition |
|---|---|---|---|
| **수명** | 임시 — 최대 30일 (기본 7일), 만료 시 자동 삭제·복구 불가 | 지속 (명시적 삭제 전까지 유지) | 지속 — 무료·영구 (단, 비활성 상태로 만료 가능) |
| **재현성** | 정의 파일(JSON)로 완전 재생성 — source-driven | Clone / Refresh / Snapshot (sandbox-def.json). 정의 파일로 처음부터 재구성은 안 됨 | 낮음 — 정의 파일 없음, 수동 셋업 |
| **초기 데이터** | 비어있음 (커스텀 오브젝트·샘플데이터·프로파일 등 미포함). `hasSampleData`로 샘플만 추가 | Dev/Dev Pro = 메타데이터만(데이터 없음) · Partial = 템플릿 선택 오브젝트(오브젝트당 ≤10,000건, 총 5GB) · Full = Production 전체 복제 | 샘플 데이터 포함 (Account·Contact·Lead 등 기본 제공) |
| **Source Tracking** | ✅ 항상 지원 (기본 활성) | Developer ✅ · Developer Pro ✅ (관련 Production org 활성 시) · Partial Copy ❌ · Full ❌ | ❌ 미지원 |
| **라이선스 / 비용** | Dev Hub 할당량 소비 (아래 표) | Production org의 **Sandbox 라이선스** 필요 (에디션·구매에 따라 종류·개수 결정) | 무료 |
| **연결(부모) org** | **Dev Hub 필수** | Production org (Sandbox 라이선스 보유) | 없음 — 독립. 단 DE org 자체를 Dev Hub로 쓸 수 있음 |
| **팀 협업** | 정의 파일을 VCS 공유 → 팀 전체 동일 환경. 1인 1 org로 격리 개발 | prod 유사 공유 환경 — 여러 개발자·QA·트레이너가 함께 사용 | 부적합 (개인용, 최대 Salesforce 사용자 라이선스 2개) |
| **Org Shape / Snapshot** | `sourceOrg`(Shape)·`snapshot` 옵션으로 활용 | Clone/Refresh로 복제 (Org Shape/Snapshot 대상 아님) | Org Shape의 **source org**로 사용 가능 (Shape 캡처 소스) |
| **주 용도** | 기능 개발, CI 파이프라인, 패키지 개발·검증, 데모/UAT용 일회성 | UAT, 통합 테스트, 스테이징, 릴리스 리허설, 교육 | 개인 학습, 영구 데모, 네임스페이스 등록 org, Dev Hub/Trailhead Playground 대용 |

> Sandbox 4종(Developer / Developer Pro / Partial Copy / Full)의 데이터 한도·새로고침 간격·스토리지 차이는 [[Sandbox 관리]] 참조. Scratch Org 정의 파일·Features·생성 명령 전수는 [[Scratch Org 패턴]]·[[Scratch Org 생성과 정의 파일]] 참조. (이 노트는 결정 기준만 다루고 메커니즘은 재서술하지 않음)

---

## Dev Hub Edition별 Scratch Org 할당량

Scratch Org를 쓰려면 Dev Hub가 필요하며, 동시에 유지·하루 생성 가능한 수는 Dev Hub의 에디션이 결정한다. 이 한도가 팀 규모·CI 병렬성의 상한이 된다.

| Dev Hub Edition | 동시 활성 (Active) | 일 생성 (Daily) |
|---|---|---|
| Developer Edition / trial | 3 | 6 |
| Enterprise Edition | 40 | 80 |
| Unlimited Edition | 100 | 200 |
| Performance Edition | 100 | 200 |

> DE를 Dev Hub로 쓰면 동시 3개·하루 6개까지만 Scratch Org를 만들 수 있다 — 개인·소규모 실험에는 충분하나 병렬 CI에는 부족. 상세·확인 명령은 [[Scratch Org 생성과 정의 파일]] 참조.

---

## 상황별 흐름 (결정 트리)

```text
// 구조 예시 — 실제 원본 다이어그램 아님 (조합 노트 결정 로직을 텍스트로 표현)

새 환경이 필요하다
│
├─ Production의 실제 데이터/메타데이터로 검증해야 하나? (UAT·통합·회귀)
│   ├─ 예 → Sandbox
│   │        ├─ 코드/메타데이터만 필요, 데이터 불필요 → Developer / Developer Pro
│   │        ├─ 대표 데이터 샘플만 필요 (오브젝트당 ≤10,000건) → Partial Copy
│   │        └─ Production 전체 데이터 복제 필요 (성능·회귀) → Full
│   └─ 아니오 ↓
│
├─ 매번 동일 환경을 코드로 재생성하고 폐기하나? (기능 개발·CI·패키지 검증)
│   └─ 예 → Scratch Org   (Dev Hub 필요 · 정의 파일 VCS 공유 · Source Tracking 기본)
│
└─ 영구적이고 개인적인 org가 필요하나? (학습·데모·네임스페이스 등록)
    └─ 예 → Developer Edition   (무료·영구 · 셋업 없이 샘플데이터 포함 · Source Tracking 없음)
```

---

## 결정에 자주 걸리는 함정

- **Source Tracking이 필요하면 Full/Partial Sandbox·DE는 탈락.** 로컬↔org 자동 변경 추적·충돌 감지가 개발 흐름에 중요하면 Scratch Org 또는 Developer/Developer Pro Sandbox만 후보다. 세부 지원표·활성화는 [[Source Tracking 변경 추적]] 참조.
- **"Scratch Org는 DE처럼 채워져 있다"는 오해.** Scratch Org는 기본 **비어있다**(커스텀 오브젝트·샘플데이터·프로파일 미포함). Production 유사 환경을 원하면 Org Shape/Snapshot으로 채우거나([[Org Shape와 Snapshot]]) Sandbox를 택한다.
- **CI에서 Sandbox refresh 반복은 간격 한도에 막힌다.** Full 29일·Partial 5일·Developer/Dev Pro 1일. 잦은 재생성이 필요한 CI는 Sandbox refresh가 아니라 Scratch Org 생성·폐기가 맞다.
- **DE는 Dev Hub가 아니라 대상 org로 오해하기 쉽다.** DE org는 Scratch Org를 만드는 Dev Hub로도, 네임스페이스 등록 org로도 쓰이지만, DE 자체는 Source Tracking·Change Set을 지원하지 않는다.
- **Partial Copy로 대규모 회귀 테스트 시도 금지.** 오브젝트당 10,000건·총 5GB 한도. 전체 Production 데이터가 필요하면 Full Sandbox뿐이다([[Sandbox 관리]]).

---

## 파이프라인에서의 조합 (실무 기본형)

```bash
# 구조 예시 — 실제 동작 설정 아님 (환경 조합 흐름을 CLI로 개념 표현)

# 1) 기능 개발 — Dev Hub 아래 일회성 Scratch Org
sf org create scratch --definition-file config/project-scratch-def.json \
  --alias feature-x --duration-days 7 --target-dev-hub DevHub
#    → 코딩 · deploy · 테스트 · 완료 후 sf org delete scratch

# 2) UAT / 통합 — Production 라이선스로 Sandbox
sf org create sandbox --definition-file config/partial-sandbox-def.json \
  --target-org prodOrg --alias uat
#    → prod 유사 데이터로 검증 · 이해관계자 확인

# 3) 학습 / 데모 — 무료 영구 Developer Edition
#    developer.salesforce.com/signup 으로 개별 가입 (CLI 대상 아님)
```

세 환경 모두 최종적으로 [[Salesforce DX 개요]] 기반의 source·deploy 워크플로로 Production까지 연결된다.

---

## 관련 노트

- [[Sandbox 관리]] — Sandbox 4종 차이·데이터 한도·새로고침 간격·sandbox-def.json·CLI 생성/복제/갱신 전수
- [[Scratch Org 패턴]] — Scratch Org 개요·생성·활용 시나리오
- [[Scratch Org 생성과 정의 파일]] — 정의 파일 옵션·Editions/Allocations·Features 전수
- [[Salesforce DX 개요]] — Dev Hub·Source Tracking·sfdx-project.json 등 DX 전체 그림
- [[Org Shape와 Snapshot]] — 실제 org를 복제해 Scratch Org를 채우는 방법
- [[Source Tracking 변경 추적]] — org 유형별 Source Tracking 지원표·활성화·충돌 해결
