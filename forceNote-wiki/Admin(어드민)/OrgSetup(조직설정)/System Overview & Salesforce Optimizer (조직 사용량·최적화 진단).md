---
tags: [admin, system-overview, salesforce-optimizer, org-health, usage, limits, monitoring]
source: https://help.salesforce.com/s/articleView?id=xcloud.dev_force_com_system_overview_page.htm (2026-07-12)
created: 2026-07-12
aliases: [System Overview, Salesforce Optimizer, 시스템 개요, 옵티마이저, 조직 사용량, 조직 건강, org health, org usage, 최적화 진단, org limits monitoring]
---

# System Overview & Salesforce Optimizer (조직 사용량·최적화 진단)

> 조직의 리소스 사용량과 한도를 진단하는 두 도구 — **System Overview**(Setup의 실시간 사용량 대시보드 카드)와 **Salesforce Optimizer**(org을 스캔해 정리·최적화 리포트를 만드는 Lightning 앱).

---

## 두 도구의 관계 — 한눈에

| | System Overview | Salesforce Optimizer |
|---|---|---|
| 성격 | **실시간 사용량 카드**(대시보드) | **심층 정기 리포트**(스캔) |
| 위치 | Setup → System Overview | Setup → Optimizer(별도 Lightning 앱) |
| 보는 것 | 현재 사용량 vs 한도(%) — Schema·API·Business Logic·UI·License·Portal Roles | 미사용 필드·미사용 리포트·한도 근접·과다 규칙·중복 등 40+ 메타데이터 기능 분석 + **권장 조치** |
| 실행 | 열면 즉시(항상 최신) | **Run Optimizer** 실행(10분~1시간) 또는 월 1회 자동 |
| 용도 | "지금 한도에 얼마나 가까운가?" 빠른 확인 | "무엇을 정리해야 하나?" 정리 로드맵 |

> System Overview가 **"한도에 근접했다"**고 경고하면, Optimizer가 **"어떤 항목을 정리하면 되는지"**를 짚어준다. 실시간 게이지 ↔ 정기 정밀검진의 관계.

---

## 1. System Overview (Setup)

시스템 개요 페이지는 조직의 사용량 데이터와 한도를 보여주고, **한도의 95%에 도달하면**(포털 역할은 75%) 메시지를 표시한다.

- **접근:** Setup → Quick Find에 `System Overview` 입력 → **System Overview** 선택
- **필요 권한:** Customize Application(애플리케이션 사용자 지정)
- **에디션:** Personal Edition을 제외한 모든 에디션. Salesforce Classic·Lightning Experience 양쪽
- **동작 규칙**
  - 각 지표의 숫자를 클릭하면 사용 내역 상세로 이동한다.
  - 가능한 경우 **Checkout**으로 한도를 늘릴 수 있다(예: 커스텀 오브젝트 한도 도달 시 정리 링크 또는 Checkout 안내).
  - 조직에 **활성화된 항목만** 표시된다(예: workflow가 켜져 있어야 workflow rules가 보임).
  - 오브젝트 한도 백분율은 **반올림이 아니라 절삭(truncate)** — 95.55% 사용 시 화면엔 `95%`로 표기.

### 카드(box)별 표시 항목 (공식)

| 카드 | 표시하는 사용량 |
|---|---|
| **Schema** | 커스텀 오브젝트 · 커스텀 설정(custom settings) · 커스텀 메타데이터 타입 · 데이터 스토리지 |
| **API Usage** | 최근 24시간 API 요청 수 |
| **Business Logic** | rules · Apex 트리거 · Apex 클래스 · 사용된 코드(code used) |
| **User Interface** | 커스텀 앱 · 게시된 Site.com 사이트 · 활성 Salesforce 사이트 · 활성 flow · 커스텀 탭 · Visualforce 페이지 |
| **Most Used Licenses** | **활성 라이선스만** 집계, 기본으로 상위 3개 표시. **95% 사용에 도달한 라이선스**도 함께 표시 |
| **Portal Roles** | 포털 역할 사용량(75% 도달 시 경고) |

```text
// 구조 예시 — 실제 Setup 화면 아님 (카드 레이아웃 개념도)
┌ System Overview ────────────────────────────────────────────┐
│ Schema            API Usage        Business Logic            │
│  Custom Objects    API Requests     Rules                    │
│  Custom Settings   (last 24 hrs)    Apex Triggers            │
│  Custom Metadata                    Apex Classes             │
│  Data Storage                       Code Used                │
│                                                              │
│ User Interface    Most Used         Portal Roles             │
│  Custom Apps       Licenses          (warn at 75%)           │
│  Site.com Sites    (top 3 active,                            │
│  Salesforce Sites   + any at 95%)                            │
│  Active Flows                                                │
│  Custom Tabs        ⚠ 95% 도달 지표엔 경고 메시지 표시        │
│  Visualforce Pages                                           │
└──────────────────────────────────────────────────────────────┘
```

---

## 2. Salesforce Optimizer (Setup, Lightning 앱)

Salesforce Optimizer는 조직을 스캔해 **기능 사용 방식을 평가하고, 사용을 최적화·단순화하고 사용자 채택을 높이기 위한 구체적 권장 사항**을 생성하는 Lightning Experience 앱이다. **메타데이터만** 분석하며 고객 데이터에는 접근하지 않는다.

### 실행 절차 (Run Optimizer)

```text
// 구조 예시 — 실제 클릭 흐름 요약 (Setup 기준)
1. Setup → Quick Find에 "Optimizer" 입력 → Optimizer 선택
2. Allow Access  클릭 (Optimizer가 org을 분석하도록 권한 부여)
3. (attestation 체크박스 동의) → 저장
4. Open Optimizer  — org에서 Optimizer Lightning 앱을 연다
5. Run Optimizer   — 스캔 실행 (완료까지 약 10분 ~ 1시간, org 규모에 따라 변동)
   · 결과는 앱 안의 레코드/리스트 뷰로 열람
   · PDF로 즉시 생성하거나, 월 1회 자동 실행·갱신하도록 설정 가능
```

- **필요 권한:** Customize Application · Modify All Data · Manage Users
- **에디션:** Professional · Enterprise · Performance · Unlimited · Developer Edition (Lightning Experience 앱)
- **권장 주기:** 분기별(quarterly) 실행이 일반적. 앱을 월 1회 자동 실행하도록 예약 가능

### 리포트 구조·평가 항목

리포트는 크게 **① 발견(현재 org 상태) → ② 권장 조치(어떻게 개선할지, 해당 Setup 페이지 링크) → ③ 학습 자료**로 구성된다. **40+ 메타데이터 기능**을 평가하며, 대표적으로:

| 영역 | 점검 예시 |
|---|---|
| 필드 | 사용자가 채우지 않는 **미사용 필드**(Field Usage) — 제거 후보 |
| 리포트 | **미사용 리포트** |
| 한도 | 오브젝트당 필드 수·스토리지 등 **한도 근접** 여부 |
| 자동화 | Apex 트리거 · Workflow Rules · Validation Rules · **과다/중복 규칙** |
| 공유·권한 | Sharing Rules · Profiles · Permission Sets(미할당 등) · Administrator Permissions |
| 레이아웃 | Page Layouts · Report Types |
| 데이터 품질 | Duplicate Management(중복 관리) |

> 결과의 각 권장 항목에는 해당 Setup 페이지로 가는 링크가 있어, 발견 → 정리 작업을 바로 이어서 할 수 있다.

---

## 활용 시나리오

- **정기 org 건강검진:** Optimizer를 분기별로 돌려 미사용 필드·리포트·중복을 정리하고, 한도 근접 항목을 미리 파악한다.
- **한도 모니터링:** 배포·대량 커스터마이징 전후로 System Overview를 열어 Schema·API·Business Logic 카드가 95%에 근접하는지 확인한다.
- **라이선스 관리:** Most Used Licenses 카드로 95% 근접 라이선스를 조기에 포착해 구매·재배치를 계획한다.

---

## 관련 노트
- [[Object & Field Limits (오브젝트·필드 한도)]] — 한도 짝: Schema 카드가 감시하는 오브젝트·필드 한도의 상세
- [[Data Export & Storage (데이터 내보내기·스토리지)]] — Schema 카드의 데이터 스토리지
- [[User Licenses · Permission Set Licenses · Feature Licenses (라이선스 유형)]] — Most Used Licenses 카드가 집계하는 라이선스 유형
- [[Security Health Check (보안 상태 점검)]] — 형제 org 진단 도구(보안 설정 점수화)
- [[Salesforce 한도·할당량 레퍼런스 (API·Bulk·Metadata·SOQL·VF)]] — API·Bulk·Metadata 등 플랫폼 한도 수치 레퍼런스
- [[Setup Audit Trail (설정 감사 추적)]] — 조직 변경 이력 모니터링
