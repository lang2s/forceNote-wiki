---
tags: [DevOps, Packaging, 패키징, PackageType, Unlocked, 2GP, 1GP, Unmanaged, ManagedPackage, AppExchange, DecisionGuide, 패키지선택]
source: 조합 노트 — Unlocked Package 개념과 준비.md · 2GP Managed Package 개념과 1GP 비교.md · 2GP Managed Package 개발 환경과 사전 준비.md (원 소스 sfdx_dev.pdf v67.0 · pkg2_dev.pdf v67.0 Summer '26, Tier 2 승계)
created: 2026-07-12
aliases: [패키징 유형 결정, 패키지 타입 선택, Unlocked vs Managed vs Unmanaged, 어떤 패키지를 써야 하나, 2GP vs 1GP 선택, package type decision, which package type, 매니지드 vs 언매니지드, 내부앱 패키지, ISV 패키지 선택]
---

# 패키징 유형 결정 가이드 (Unlocked·2GP·1GP·Unmanaged)

> "우리 프로젝트는 어떤 패키지 유형인가?"를 한 곳에서 결정하는 라우팅 노트. 4개 모델(Unlocked · 2GP Managed · 1GP Managed · Unmanaged)을 배포 대상·잠금·IP 보호·의존성 등 결정 축으로만 비교한다. **각 유형의 수명주기·설치·버전 상세는 재서술하지 않고 해당 노트로 위임**한다.

---

## 이 노트의 범위

이 노트는 **선택(decision)만** 다룬다. 각 모델의 생성 절차·CLI·버전·설치 메커니즘은 이 노트에 없다 — 결정 후 아래 위임 링크로 이동한다.

- Unlocked 상세 → [[Unlocked Package 개념과 준비]]
- 2GP Managed 개념·1GP 비교 → [[2GP Managed Package 개념과 1GP 비교]]
- 2GP Managed 개발 환경·의존성 매트릭스 → [[2GP Managed Package 개발 환경과 사전 준비]]

---

## 1. 결정 흐름 (Decision Flow)

가장 먼저 묻는 질문은 **"AppExchange에 상용 배포하는가?"** 와 **"구독자가 코드를 수정/열람하게 둘 것인가?"** 두 가지다.

```
// 구조 예시 — 실제 원본 다이어그램 아님 (결정 흐름 텍스트 재현)

Q1. 배포 대상이 어디인가?
 ├─ 내 조직 / 우리가 관리하는 조직들 (내부 앱·메타데이터 정리)
 │     │
 │     └─ Q2. 일회성 이관인가, 재배포·버전 관리가 필요한가?
 │           ├─ 단발 이관 (오픈소스 템플릿·1회 복사) ......... → Unmanaged
 │           └─ 버전 관리·재배포·모듈화 필요 .............. → Unlocked Package
 │                 └─ 설치 대상 org의 unpackaged 메타데이터에
 │                    의존해야 하는가?
 │                      ├─ 예 → Org-Dependent Unlocked (Unlocked의 변형)
 │                      └─ 아니오 → 일반 Unlocked
 │
 └─ AppExchange에 여러 고객사로 상용 배포 (ISV/OEM)
       │
       └─ Q3. 신규 패키지인가, 기존 1GP 자산인가?
             ├─ 신규 → 2GP Managed (처음부터 2GP로 시작)
             └─ 기존 1GP 유지보수 → 당분간 1GP Managed
                (신규를 1GP로 새로 시작하는 것은 지양 — §5 참조)
```

- 핵심 갈림길: **내부/우리 조직용이면 Unlocked**, **AppExchange 상용이면 Managed(가급적 2GP)**, **한 번 복사로 끝이면 Unmanaged**.
- Unlocked와 2GP Managed는 **둘 다 2GP 패키징 모델**(source-driven, Dev Hub 소유, CLI 자동화)을 공유한다. 차이는 기술이 아니라 **용도**(구독자 잠금 여부)다.

---

## 2. 4모델 결정 축 비교표

> 셀은 압축 기호(✅/❌) 대신 소스 원문 표현을 그대로 옮겼다. 근거 노트: 배포 대상·잠금·용도 = [[2GP Managed Package 개념과 1GP 비교]] §8, 1GP↔2GP 축 = 같은 노트 §3, Org-Dependent·Namespace 축 = [[Unlocked Package 개념과 준비]], 의존성 축 = [[2GP Managed Package 개발 환경과 사전 준비]] §8.

| 결정 축 | Unlocked Package | 2GP Managed | 1GP Managed | Unmanaged |
|---|---|---|---|---|
| **주 배포 대상** | 고객·시스템 통합자 (내부 비즈니스 앱) | AppExchange ISV/OEM 파트너 | AppExchange ISV (레거시 방식) | 단발 이관·템플릿 공유 |
| **AppExchange 상용 등재** | 일반적이지 않음 | 가능 (보안 리뷰·등록) | 가능 (보안 리뷰·등록) | 소스 미기재 (상용 배포 모델 아님) |
| **구독자 수정 가능 여부** | 풀려 있음 — 관리자가 Production에서 직접 수정 가능 | 잠겨 있음 — 수정 불가 (manageability rules) | 잠겨 있음 — 수정 불가 | 완전 개방 — 설치 후 org 메타데이터가 되어 자유 수정 |
| **코드 IP 보호(숨김)** | 없음 (열려 있음) | 있음 (managed = 관리 규칙으로 보호) | 있음 (managed) | 없음 (그대로 노출) |
| **Org-Dependent 지원** | 지원 (Org-Dependent Unlocked 변형 — 설치 org의 unpackaged 메타데이터 의존) | 해당 없음 | 해당 없음 | 해당 없음 |
| **Namespace** | 선택 (namespaced 또는 no-namespace) | namespace org에서 생성 후 Dev Hub link, **N:1**(여러 패키지가 공유 가능) | packaging org에서 생성, **1:1**(한 패키지 전용) | 없음 |
| **의존성 그래프 위치** | 1GP·2GP·Unlocked에 의존 가능 (Unmanaged 의존은 권장 안 함) | 1GP·2GP에 의존 가능 (Unlocked·Unmanaged 의존은 권장 안 함) | 1GP에만 의존 가능 (2GP 의존은 차단·override 요청 가능) | **leaf only** — 어떤 패키지에도 의존 불가 |
| **업그레이드 방식** | 패키지 버전(불변) promote 후 install/upgrade | ancestry 기반 upgrade path + push upgrade | 선형 버전·patch org 필요·한번 넣은 메타데이터 제거 불가 | 업그레이드 연결 없음 (설치 후 패키지와 분리) |
| **진실의 원천** | VCS (source-driven) | VCS (source-driven) | packaging org | VCS/소스 (배포 아티팩트일 뿐) |
| **상세 노트(위임)** | [[Unlocked Package 개념과 준비]] | [[2GP Managed Package 개념과 1GP 비교]] · [[2GP Managed Package 개발 환경과 사전 준비]] | [[2GP Managed Package 개념과 1GP 비교]] §2·§3 (1GP 특성) | (전용 상세 노트 없음 — 의존성 매트릭스에서만 등장) |

> ⚠️ Unmanaged의 "AppExchange 등재"·"IP 보호" 등 일부 셀은 조합한 3개 소스 노트에 명시적 서술이 없다. 위 셀 중 "소스 미기재"로 표기한 것은 추측이 아니라 **소스에 없다는 사실**이다. Unmanaged에 대해 소스가 직접 말하는 것은 의존성 매트릭스의 **leaf only** 특성뿐이다.

---

## 3. "우리 프로젝트는 무엇?" — 빠른 판정

| 우리 상황 | 선택 | 왜 |
|---|---|---|
| 자기 조직(또는 우리가 운영하는 조직들)의 메타데이터를 정리·모듈화·재배포 | **Unlocked Package** | AppExchange 배포 계획이 없으면 대부분의 사용 사례에서 올바른 유형 |
| 오래되고 방대한 Production의 unpackaged 메타데이터에 의존하는 부분까지 패키지화 | **Org-Dependent Unlocked** | 의존성 검증을 생성 시점이 아니라 **설치 시점**에 수행 (Unlocked 변형) |
| 여러 고객 org에 같은 앱을 상용 배포·보호·업그레이드 (신규) | **2GP Managed** | 구독자 org에서 잠김 + AppExchange 등재 + source-driven·CLI 자동화 |
| 이미 1GP로 출시된 앱을 유지보수 중 | **1GP Managed 유지** | 현재 1GP→2GP 공식 GA 마이그레이션 도구 없음 (§5) |
| 코드/설정을 한 번 복사해 넘기고 이후 관리·업그레이드 불필요 | **Unmanaged** | 설치 후 org 메타데이터로 흡수되어 패키지와 분리 |

---

## 4. Unlocked vs 2GP Managed — 같은 모델, 다른 잠금

두 유형은 기술 스택이 같으므로(둘 다 2GP), 실제 결정은 **"구독자가 손대게 둘 것인가"** 하나로 좁혀진다.

- 목표가 "여러 고객 org에 배포·관리·보호"면 → **2GP Managed** (잠김)
- 목표가 "자기 조직 메타데이터를 정리·재배포"면 → **Unlocked** (풀림)

Unlocked의 유연성(구독자 직접 수정)에는 거버넌스 책임이 따른다 — 관리자가 Production에서 패키지 메타데이터를 직접 편집할 때 개발팀에 알리는 체계가 필요하다. 자세한 거버넌스·수명주기는 [[Unlocked Package 개념과 준비]] 참조.

---

## 5. 1GP는 왜 신규에서 지양하는가

신규 상용 패키지는 **처음부터 2GP Managed로 시작**하는 것이 권장된다. 근거:

- **마이그레이션 부담 회피** — Salesforce가 1GP → 2GP 마이그레이션 도구를 개발 중이지만, **현재 공식 GA 도구는 없다.** 출시되더라도 파트너 측 작업이 필요하다. 신규를 2GP로 시작하면 이 미래 부담을 원천 차단한다.
- 1GP의 구조적 제약: packaging org 진실의 원천, patch org 필요, 선형 버전(한번 들어간 메타데이터 제거 불가), namespace 1:1, 일부 작업 자동화 불가.

> 1GP → 2GP 마이그레이션이 "현재 불가"라는 판단의 근거는 [[2GP Managed Package 개념과 1GP 비교]] §1·§2-8이다. 1GP의 아키텍처 차이 전수는 같은 노트 §2·§3에 있으므로 여기서는 재서술하지 않는다.

---

## 6. 의존성 관점의 결정 (leaf 여부)

패키지를 작은 모듈로 쪼갤 때 "이 패키지가 무엇에 의존할 수 있는가"가 유형 선택에 영향을 준다. 요지만:

- **Unmanaged는 leaf only** — 어떤 패키지에도 의존할 수 없다. 다른 패키지가 Unmanaged에 의존하는 것도 권장되지 않는다. 즉 의존성 그래프의 **말단**으로만 쓴다.
- **Unlocked**는 가장 넓게(1GP·2GP·Unlocked) 의존 가능.
- **2GP Managed**는 1GP·2GP에 의존 가능, Unlocked 의존은 권장 안 함(구독자가 수정 가능해 깨질 위험).
- **1GP Managed → 2GP**는 차단(Partner Support에 override 요청 가능).

> 전체 4×4 의존성 매트릭스(각 셀의 ✅/❌/권장 안 함/footnote ¹ override)는 [[2GP Managed Package 개발 환경과 사전 준비]] §8이 정본이다. 여기서 매트릭스를 재현하지 않는다 — 셀 단위 판단이 필요하면 그 노트를 본다.

---

## 관련 노트

- [[Unlocked Package 개념과 준비]] — Unlocked 개념·패키지 기반 개발 모델·Org 역할·Org-Dependent 변형 (Unlocked 선택 시 진입점)
- [[2GP Managed Package 개념과 1GP 비교]] — 2GP Managed 정의·1GP와의 8가지 차이·1GP 비교표·기능 갭 (Managed 선택 시 진입점)
- [[2GP Managed Package 개발 환경과 사전 준비]] — org 역할·namespace 생성/link·manageability·ancestry·**의존성 매트릭스 정본(§8)**
- [[Metadata Coverage 보고서]] — 각 패키지 유형이 지원하는 메타데이터 타입 확인
- [[sfdx-project.json 레퍼런스]] — 유형 결정 후 namespace·dependencies·packageDirectories 선언
- [[Salesforce DX 개요]] — DX 도구 전반(CLI·source format)
