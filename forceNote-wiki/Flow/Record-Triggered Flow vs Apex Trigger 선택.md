---
tags: [flow, apex, trigger, record-triggered, architecture, decision-guide, automation, density, hybrid-pattern, async]
source: architect.salesforce.com — Record-Triggered Automation Decision Guide (https://architect.salesforce.com/docs/architect/decision-guides/guide/record-triggered, Tier 2, 2026-07-05 확인)
created: 2026-07-05
aliases: [Flow vs Apex Trigger, Record-Triggered Flow vs Apex, Apex vs Flow, 트리거 자동화 선택, 자동화 밀도, automation density, record-triggered automation decision, 트리거 선택 기준, Flow로 할까 Apex로 할까, 하이브리드 패턴, Flow Apex 혼용]
---

# Record-Triggered Flow vs Apex Trigger 선택

> 레코드 변경 자동화를 Record-Triggered Flow로 만들지 Apex Trigger로 만들지 결정하는 공식 기준 — Salesforce Architects Decision Guide의 **자동화 밀도(automation density)** 휴리스틱, 역량 비교 매트릭스, 하이브리드 패턴(Flow + Invocable Apex), 비동기 오프로딩 전략.

---

## 핵심 원칙 (가이드 Takeaways)

Salesforce의 레코드 트리거 자동화는 Workflow Rules·Process Builder 세대를 지나 **Record-Triggered Flow와 Apex Trigger 두 축**으로 통합됐다. 공식 가이드의 설계 원칙은 다음과 같다.

1. **객체별 자동화 밀도(automation density)에 따라 도구를 고른다.**
   - 저밀도(low density) → **Record-Triggered Flow**
   - 중밀도(medium density) → **Record-Triggered Flow + Invocable Apex** (하이브리드)
   - 고밀도(high density) → **Apex Trigger** (메타데이터 프레임워크)
2. **비동기 프로세스 발화는 신중하게.** Flow의 비동기 경로든 Apex의 Queueable enqueue든, 에러 처리 복잡화와 governor limit 위험을 키운다.
3. **객체당 진입점(entry point)은 하나.** 같은 객체에 Flow와 Apex Trigger를 진입점으로 섞지 않는다 — 분할하면 유지보수성과 거버넌스가 파편화된다.

Flow와 Apex는 쿼리·조건 분기·변수 할당·DML이라는 **기본 역량을 공유**한다. 선택 기준은 "할 수 있는가"가 아니라 **"어떻게 달성되고 성능·확장성·유지보수성에 어떤 장기 영향이 있는가"** 다.

---

## 자동화 밀도(Automation Density) — 3가지 측정 차원

자동화 밀도 = 특정 Salesforce 객체에 걸리는 자동화 부하. 밀도가 커질수록 트랜잭션 한도 초과 가능성이 커진다. 세 차원으로 측정한다.

| 차원 | 정의 |
|---|---|
| **자동화 수량 (Automation quantity)** | 한 번의 DML 이벤트에서 실행되는 고유 자동화 메타데이터(Flow, trigger action 등)의 개수 |
| **레코드 볼륨 (Record volume)** | API 로드·대량 배치 처리 시 트랜잭션당 처리 레코드 수 |
| **의존성 확산 (Dependency sprawl)** | 최초 CRUD가 촉발하는 하류(downstream) DML의 깊이 — 예: case → account → contact → 커스텀 롤업 |

> 가이드 원문에는 밀도 3차원 다이어그램 이미지("Automation density dimensions")가 있음 — 본 노트는 텍스트 정의만 옮김.

### 밀도 선택 매트릭스 (Density Selection Matrix)

| 밀도 | 자동화 수량 | 데이터 볼륨 (배치 크기) | 의존성 확산 | 아키텍처 표준 |
|---|---|---|---|---|
| **Low** | < 15개 | Standard — 사용자 UI 상호작용 또는 소규모 API 로드 (1–200 레코드) | Discrete — 자기완결 로직, 하류 DML 0–1개 (같은/관련 객체) | **Record-Triggered Flow** |
| **Medium** | 15–30개 | Moderate — 표준 배치 처리 (신중한 벌크화 필요 로직) | Coupled — 부모/자식 업데이트, 하류 DML 2–4개, 재귀 위험 | **하이브리드 패턴 (Flow + Invocable Apex)** |
| **High** | > 30개 | High — 벌크 API 로드 등 대용량 (2,000–10,000+ 레코드) | Complex & Recursive — 깊은 의존성 그래프 (하류 DML 5개+), 삼각 재귀 루프 위험 | **Apex Trigger 메타데이터 프레임워크** |

밀도 차원들은 **종합적으로** 평가하고, 도구 선택 시 **미래 확장 범위**까지 고려한다. 또한 **일일 총 DML 수**도 감안한다 — 비동기 한도(CPU 60,000ms·힙 12MB)는 동기보다 높지만, org 전체 24시간 비동기 실행 한도(250,000회 또는 사용자 라이선스 × 200으로 산정)가 있어 일일 DML 총량이 아키텍처 설계에 영향을 준다.

---

## 역량 비교 매트릭스 (Product Comparison)

가이드 원문 값 그대로: **Recommended(권장) · Available(가능) · Not recommended(비권장) · Not Available(불가) · Requires expertise(전문성 필요) · Manual implementation required(수동 구현 필요)**.

| 역량 | Record-Triggered Flow | Apex Trigger |
|---|---|---|
| 구현·유지보수 속도 | **Recommended** — Flow Builder 비주얼 UI로 어드민·선언적 빌더도 빠르게 구축, 개발자 의존 감소 | Requires expertise — 숙련 개발자가 구현·테스트·유지 |
| 모듈성 | Available — 기본이 모듈형. 요구사항별 개별 flow를 만들고 Flow Trigger Explorer로 choreography | Available — 클래스 = 기능 모듈 단위 설계 |
| 가시성·거버넌스 | **Recommended** — 비주얼 로직 + Flow Trigger Explorer로 객체의 전체 flow 통합 뷰 | Requires expertise — 메타데이터 프레임워크가 도움되지만 팀 규율 필요 |
| 고성능 대량 데이터 처리 | **Not recommended** — 복잡 로직·대용량에서 governor limit 초과 위험 상승 | **Recommended** — 플랫폼 코어에 가깝게 실행, 쿼리 최적화·데이터 핸들링·알고리즘 효율 제어 |
| 견고한 로직·자료구조 | Available — Transform 요소가 일부 커버하나 **네이티브 Map·Set 부재**로 복잡 처리 비효율 | **Recommended** — Map·Set·루프 전체 + 디자인 패턴 + 고급 표준 라이브러리(BusinessHours, Crypto 등) |
| 트랜잭션 제어 | **Not Available** — `Database.setSavepoint`·`Database.rollback`·부분 성공 DML 접근 불가 | Available — 트랜잭션 무결성·복잡 에러 복구의 세밀한 제어 |
| 이메일 발송 | **Recommended** — 사전 구성 email alert 발송이 쉽고 확장성 있음 (일일 발송 한도 적용) | Available — 커스텀 이메일 생성·발송 가능 (동일 한도 적용) |
| 플랫폼 안전장치 적용 | **Recommended** — 자동 벌크화·자동 재시도 내장 | Manual implementation required — 벌크화를 명시적으로 코딩(루프 내 SOQL 회피 등), 자동 재시도는 커스텀 로직 필요 |
| 비동기 처리 | Available — 별도 트랜잭션 비동기 경로 제공 (일일 한도 적용) | Available — CDC·queueable 이벤트 + 분리된 구독자 트리거로 완전 제어 |
| 예약(scheduled) 처리 | **Recommended** — scheduled path ("마감 3일 전 발화" 등) + 데이터 변경 시 자동 취소·재예약 | **Not Available** — 트리거는 레코드별 시점 이벤트를 네이티브 예약 불가 (Scheduled Apex는 별개 메커니즘) |
| 실행 순서·choreography | Available — Flow Trigger Explorer로 같은 객체 flow들의 상대 순서 지정 | Available — 트리거 프레임워크로 정밀한 순서 제어 |
| 같은 레코드 필드 업데이트 | Available (**before save**) — 커밋 전 업데이트하는 가장 성능 좋은 선언적 옵션 | Available (**before save**) — 오버헤드 최소, 최고 성능 |
| 크로스 객체 CRUD | Available (**after-save**) — 단순·저복잡도 크로스 객체 DML에 적합 | Available (**after-save**) — 중복 제거·에러 처리·성능에서 우위 |
| 고비용 연산 중복 제거 | Available — 자동 벌크화로 중복 쿼리·DML 제거. 단 **트랜잭션 내 flow 간 상태 캐시·공유 불가** | **Recommended** — static 변수 트랜잭션 캐싱 + Platform Cache로 재사용 |
| 커스텀 에러 처리 | Available — CustomError 요소로 저장 차단 + 메시지 표시 | **Recommended** — `addError()`로 필드 수준·조건부 에러 메시징 |

---

## 유스케이스별 Best-Fit 권고

| 유스케이스 | 설명 | Best-Fit | 근거 |
|---|---|---|---|
| 고성능 배치 처리 | 수천 건을 효율적으로 처리해야 하는 자동화 | **Apex** | 플랫폼 인터페이스용 풍부한 API + 순수 속도 |
| 복잡한 데이터 처리 | 고급 데이터 조작이 필요한 시나리오 | **Apex** | Flow에 없는 Map·Set — 성능 좋은 벌크 세이프 코드의 핵심 |
| 트랜잭션 제어 | savepoint·rollback·부분 커밋 | **Apex** | `Database.setSavepoint`·`Database.rollback`·부분 성공 DML |
| 정교한 커스텀 검증 | 레코드 내 다중 필드 검증 | **Apex** | Flow CustomError는 모든 flow 타입에서 가용하지 않음(서브플로우 포함). `addError()`는 트리거 처리 중 언제든 필드별 다중 메시지 |
| 단순 프로세스 속 중간 복잡도 로직 | 고급 함수 라이브러리로 단순화되는 중간 복잡도 로직 | **Flow + Apex** | Flow가 오케스트레이션 레이어, 고복잡도 연산은 Invocable Apex에 캡슐화 |
| 단순–중간 복잡도 로직 | 트리거 레코드 + 관련 객체의 저·중간 복잡도 조작 | **Flow** | 선언적 모델 — 어드민·개발자 모두 접근 가능 |
| 알림·아웃바운드 메시지 | 이메일·아웃바운드 메시지 발송 | **Flow** | email alert·outbound message가 쉽고 확장성 높음 |
| 예약 처리 | 동적 미래 시점 자동화 (예: 마감 3일 전) | **Flow** | scheduled path — 플랫폼이 예약·취소·재예약 자동 처리 |

**같은 레코드 필드 업데이트는 도구와 무관하게 항상 before-save로**: Flow는 fast field update(before-save flow), Apex는 before insert/update 컨텍스트. 두 번째 DML과 재귀 save 사이클(전체 저장 순서 재실행)을 없애 가장 성능이 좋다.

---

## 비동기 오프로딩 — 트리거 자동화가 무거워질 때

복잡·장시간·대용량 로직이 동기 트리거에서 limit 예외로 실패하면 **사용자의 저장 전체가 롤백**된다. 무거운 작업은 비동기로 분리한다. (Apex 비동기 도구 자체 선택은 [[비동기 컨텍스트 선택]] 참조 — 여기서는 "트리거에서 발화"하는 관점만.)

| 메커니즘 | 적합 상황 | 제약 |
|---|---|---|
| **Flow Run Asynchronously path** | fire-and-forget: 알림 이메일, 후속 Task 생성, 단순 콜아웃 | 비동기 flow interview 일일 한도 공유, 초대용량 부적합 |
| **Change Data Capture (CDC)** | 대용량·고신뢰 — 트리거는 저장만 하고, 변경 이벤트를 별도 Apex 트리거가 구독·처리 | 이벤트에 **이전 값(oldMap 동등물) 없음** → 상태 전이 로직 곤란. 기본 최대 **5개 객체** (add-on 라이선스로 해제). 이벤트 재생은 72시간 |
| **트리거에서 Queueable enqueue** | Apex 수준 제어(복잡 로직·커스텀 재시도)가 필요하고 CDC 불가일 때만 — **위험 패턴** | enqueue 전 잡 수 체크 + `System.isBatch()` 컨텍스트 감지 필수 |

**한도 감각 (가이드 원문 수치):**
- 일일 비동기 Apex 실행 한도(Batch·Queueable·@future)는 **org 공유** — 통상 250,000회 또는 사용자 라이선스 기반 계산.
- 20,000건 벌크 로드 = 200건 청크 × **100회 트리거 호출**. 호출마다 잡을 enqueue하면 단일 로드가 일일 한도를 크게 소모 → 다른 비즈니스 프로세스의 async 자원 고갈.
- 동기 트랜잭션(UI 발화 트리거)은 queueable **50개**까지 enqueue 가능하지만, Batch Apex `execute` 안에서 발화된 트리거는 **1개만** — 이 차이를 놓치면 대량 작업에서 `LimitException`.
- **안티패턴**: 트리거 컨텍스트에서 `System.schedule()` 또는 `Database.executeBatch()` 직접 호출 — 비동기 할당량 급속 소진.

> 가이드 원문에 비동기 메커니즘 선택 **decision tree 이미지**("Asynchronous pattern decision tree")가 있음 — 본 노트는 텍스트 요지만 옮김.

**Scheduled Job 대안** — 대용량 DML인데 CDC를 못 쓸 때는 트리거 발화 프로세스 자체를 피한다: ① 동기 트리거는 저비용 마킹만 (예: `Status__c = 'pending processing'`) → ② 주기 실행 Scheduled Flow/Apex가 → ③ pending 레코드를 조회해 통제된 대용량 컨텍스트에서 처리 후 완료 마킹. 트리거발 배치의 1-job 제한을 받지 않는 확장 가능한 패턴. 이 지연도 수용 불가라면 아키텍처 미스매치 — CDC add-on 구매 또는 "진짜 준실시간이 필수인가" 요구사항 재검토.

---

## 하이브리드 패턴 — Flow 오케스트레이션 + Invocable Apex

"객체당 도구 하나" 원칙은 순수 선언적 vs 순수 코드의 양자택일이 아니다. 중밀도에서는 **Record-Triggered Flow를 오케스트레이션 레이어**(진입 조건·실행 컨텍스트 = what/when 소유)로 두고, **고복잡도 연산만 Invocable Apex에 캡슐화**한다.

가이드의 대표 예: Case SLA 계산. `BusinessHours` 객체·로직이 Flow에서 네이티브 접근 불가이므로 Apex 클래스로 캡슐화한다.

```apex
// 구조 예시 — 실제 동작 코드 아님 (가이드가 서술한 ServiceLevelAgreementCalculator 패턴의 골격)
public with sharing class ServiceLevelAgreementCalculator {
    @InvocableMethod(label='Calculate SLA Status')
    public static List<Output> calculate(List<Input> inputs) {
        // BusinessHours 기반 경과 업무시간 계산 →
        // "Within Target" / "Breached" 판정을 구조화된 출력으로 반환
        return null;
    }
}
```

**얻는 것** — 모듈성(작고 벌크 세이프하며 독립 테스트 가능한 단위), 재사용성(하나의 `@InvocableMethod`를 record-triggered flow·screen flow·외부 통합에서 공용), 유지보수성(프로세스 흐름이 Flow에 가시적으로 남아 실행 순서가 결정적·투명).

**한계 (커밋 전 필수 확인):**
- **before-save 미지원 (가장 치명적)** — Invocable Action은 after-save flow에서만 가용. 같은 레코드 필드 업데이트 위임 불가 → before-save flow 네이티브 요소 또는 Apex before 컨텍스트로.
- **after-undelete 미지원** — Record-Triggered Flow는 after-undelete 컨텍스트 자체를 지원하지 않음. 휴지통 복원 자동화가 요구되면 **Apex Trigger가 유일한 해법**.
- **런타임 전환 오버헤드** — Flow 런타임 → Apex 런타임 진입은 zero-cost가 아님. 중밀도에선 무시 가능한 트레이드오프지만, 극단적 고성능·대용량에서는 순수 Apex 프레임워크가 원시 연산 속도에서 우위.

패턴 구현은 [[@InvocableMethod 패턴]], 고밀도용 메타데이터 프레임워크는 [[CMDT 메타데이터 트리거]]·[[TriggerHandler 패턴]] 참조.

---

## 혼용(Flow + Apex Trigger 공존) — 레거시 전략과 실행 순서 주의

성숙한 org에는 같은 객체에 flow와 Apex 트리거가 (하이브리드 설계가 아니라 레거시로) 공존하는 경우가 흔하다. **용인되는 운영 상태지만 종착지가 아니다** — 파편화된 오케스트레이션은 개발·테스트·장애 대응을 분절시켜 TTR(Time to Resolution)을 늘린다.

- **신규 객체**: 자동화 밀도 원칙을 1차 기준으로.
- **기존 이중 진입점 객체**: 밀도 평가 후 리팩터링 —
  - 저밀도 → Apex 트리거를 record-triggered flow로 리팩터링 + 실행 순서 지정 → 단일 진입점화
  - 중밀도 → 메가플로우를 순서 지정된 여러 flow로 분해, Apex 트리거는 꼭 필요할 때만(예: after-undelete)
  - 고밀도 → Apex 트리거 중심으로
- **Apex는 객체당 트리거 1개** — 플랫폼이 같은 객체·같은 이벤트의 다중 트리거 실행 순서를 보장하지 않아 비결정적 동작·레이스 컨디션의 원인이 된다.
- 혼용 상태에서 before-save flow·Apex 트리거·after-save flow가 한 저장 안에서 언제 각각 실행되는지는 [[Trigger Order of Execution]] 참조 (20단계 저장 순서 — 본 노트에서 재서술하지 않음).

---

## 공통 베스트 프랙티스 (도구 불문)

**재귀 방지** — after-update 재발화 무한 루프의 정석 해법은 boolean 플래그보다 **신·구 값 비교 게이트**. Flow는 진입 조건에서 "updated to meet condition requirements" 설정 또는 formula로:

```text
$Record.Amount != $Record__Prior.Amount
```

(가이드 원문 발췌 — Opportunity Amount가 실제로 변경됐을 때만 실행.) Apex는 `Trigger.new` vs `Trigger.oldMap` 비교. 상세 패턴은 [[Trigger 재귀 방지]] 참조.

**바이패스 프레임워크** — 대량 데이터 로드·통합 사용자 동기화·관리자 정정 작업을 위해 **Custom Permission 기반** 바이패스를 모든 레코드 트리거 자동화에 일관 적용한다. Flow는 진입 조건 formula에:

```text
( ) && NOT($Permission.Bypass_This_Flow)
```

(가이드 원문 발췌 — `( )` 자리에 기존 진입 조건. flow interview 생성 전에 차단되어 가장 성능 좋음.) Apex 메타데이터 프레임워크는 `TriggerAction__mdt`에 `BypassPermission__c` 필드를 두고 핸들러가 `FeatureManagement.checkPermission()`으로 스킵 판정 — 전역 바이패스와 액션별 바이패스 모두 가능. Flow 쪽 상세는 [[Flow 설계 베스트 프랙티스]]의 바이패스 절 참조.

**메가플로우 안티패턴** — 객체의 모든 자동화를 하나의 거대 flow로 합치지 않는다. 통합 vs 분할은 성능에 큰 영향이 없고, 진짜 성능 이득은 ① 같은 레코드 업데이트의 before-save flow 사용, ② 정밀한 진입 조건 작성에서 온다. 여러 flow의 순서는 Flow Trigger Explorer의 order 값으로 보장.

**고비용 연산 중복 제거 (Apex 우위 영역)** — static 변수로 트랜잭션 내 공유 상태 캐싱 + `Cache.CacheBuilder`로 Platform Cache 활용(프로필·롤·business hours처럼 읽기 빈번·트랜잭션 내 불변 데이터).

**문서화·DevOps** — Flow는 flow·요소별 Description 필수(특히 invocable action·subflow), Apex는 why 중심 주석 + 메타데이터 레코드의 Description. Flow·Apex 모두 메타데이터이므로 Git 소스 관리 + Code Analyzer 정적 분석(루프 내 Get Records / 루프 내 SOQL 탐지) + 회귀 테스트를 파이프라인에 태운다.

---

## 관련 노트

- [[Trigger Order of Execution]] — 혼용 시 before-save flow·Apex 트리거·after-save flow의 실행 시점 (20단계 저장 순서)
- [[Flow 설계 베스트 프랙티스]] — Fast Field Update·진입 조건 최적화·바이패스·거버너 한도 등 Flow 측 설계 원칙
- [[Flow 종류와 변수]] — RecordTriggeredFlow processType과 .flow-meta.xml 구조
- [[@InvocableMethod 패턴]] — 하이브리드 패턴의 Apex 측 구현
- [[TriggerHandler 패턴]] — 단일 트리거 + 핸들러 클래스 (Classic Trigger Handler)
- [[CMDT 메타데이터 트리거]] — 고밀도 표준인 메타데이터 주도 트리거 프레임워크
- [[Trigger 재귀 방지]] — 신·구 값 비교 게이트 등 재귀 제어 상세
- [[비동기 컨텍스트 선택]] — @future·Queueable·Batch·Scheduled 자체 선택 매트릭스
- [[Platform Event 정의와 구독]] — CDC가 올라타는 이벤트 버스·구독 트리거 기반
- [[Governor Limits]] — 동기·비동기 한도 수치 정본
