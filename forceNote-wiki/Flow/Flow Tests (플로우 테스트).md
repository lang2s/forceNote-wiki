---
tags: [flow, testing, flow-test, assertion, flow-builder, record-triggered]
source: extend_click_automate.pdf (Automate Your Business Processes, Spring '26)
created: 2026-07-10
aliases: [Flow Tests, Flow Test 생성, 플로우 테스트, Flow 테스트 한도, Flow assertion, 플로우 어서션, Testing Your Flow, Flow 테스트 절차]
---

# Flow Tests (플로우 테스트)

> Record-Triggered·Data Cloud-Triggered Flow를 활성화하기 전에 Flow Builder에서 테스트(트리거 조건 → 어서션)를 만들어 반복 실행하는 절차 — flow당 최대 200개, 삭제 트리거·비동기 경로는 미지원.

---

## 왜 디버그가 아니라 테스트인가

Flow를 디버그할 때는 시작할 때마다 디버그 파라미터와 입력을 매번 수동으로 설정해야 한다. **Flow 테스트는 테스트 파라미터와 입력을 한 번만 구성**하면, 실행할 때마다 같은 구성으로 flow를 평가한다. 테스트는 수정할 수 있고 시나리오별로 여러 개를 만들 수 있다. Salesforce는 **flow가 탈 수 있는 모든 경로(path)마다 테스트를 하나씩 만들 것을 권장**한다. (인쇄 p.182)

사용자나 입력이 flow에 필요한 데이터를 다 제공하지 않으면 flow는 실패한다 — 데이터를 보정할 수 있는 경로를 fault connector로 제공해 flow가 정상 종료되게 하라는 것이 소스의 권고다(fault 경로 설계 자체는 [[Flow 에러 처리]] 참조).

## 한도·권한·에디션

| 항목 | 값 (인쇄 p.182) |
|---|---|
| **flow당 최대 테스트 수** | **200** |
| 에디션 | Essentials, Professional, Enterprise, Performance, Unlimited, Developer |
| Salesforce Classic | 사용 가능 (일부 org 제외) — Lightning Experience 양쪽 지원 |

**필요 권한:**

| 작업 | 권한 |
|---|---|
| Flow Builder 또는 flow 상세 페이지에서 flow 실행 | Manage Flow |
| Flow Builder에서 flow 테스트 열기·수정·생성 | Manage Flow |
| Flow Builder에서 테스트 실행 상세(Test Run Details) 보기 | View All Data |

## 제약 (Limitations 전수)

인쇄 p.182의 Limitations 5개 전부:

1. **Flow 테스트는 record-triggered flow와 data cloud-triggered flow에서만 사용 가능**하다.
2. **레코드가 삭제될 때(deleted) 실행되는 flow는 지원하지 않는다.**
3. **비동기로 실행되는 flow 경로(asynchronous path)는 지원하지 않는다.**
4. **Flow 테스트는 flow test-coverage 요구사항에 집계되지 않는다** (커버리지는 아래 "테스트 커버리지와 배포" 참조).
5. **테스트 데이터 설정에 수식(formula)을 쓸 수 없다 — 고정값만.** 예: 날짜 필드를 상대 날짜 "Today"로 검증하는 테스트라면, 테스트를 2022-08-03에 만들고 실행하면 그 날짜는 2022-08-03으로 고정된다. 다음 날 같은 테스트를 실행해도 값은 여전히 2022-08-03이므로 실행 전에 필드를 수동으로 갱신해야 한다.

## 테스트 생성·실행 절차 (Test a Flow)

인쇄 p.182–183의 절차 전수:

1. **Flow Builder를 연다.**
   - Setup → Quick Find에 `Flows` 입력 → **Flows** 선택
   - 또는 Automation Lightning app의 **Flows** 탭
   - 또는 아무 Lightning app의 Flows 탭
2. **테스트할 flow 버전을 연다.**
   - Setup의 flow 목록에서 해당 flow의 메뉴 → **View Details and Versions** → **Open**
   - 또는 Automation/Lightning app의 flow 목록에서 flow의 **Related** 탭 → 대상 버전의 메뉴 → **Open Flow**
3. **View Tests** 클릭 → **Create** 클릭.
4. **Set the Test Details, Trigger, and Path** 창에서 테스트를 구성한다.
   a. 테스트의 label, API name, description 입력.
   b. **Run the Test When a Record Is**에서 **Created** 또는 **Updated** 선택.
5. **Set Initial Triggering Record** 클릭 → 테스트를 최초로 트리거하는 레코드 값 입력.
6. 레코드 **업데이트** 시 실행되는 테스트라면 **Set Updated Trigger Record** 클릭 → 업데이트된 레코드 값 입력.
7. **Set Assertions** 클릭 → 어서션마다 조건(condition)과 커스텀 실패 메시지 설정.
8. 저장 후 **View Tests** 클릭. **테스트를 마지막으로 수정한 사람이 flow의 소유자(owner)가 된다.**
9. 구성한 테스트를 선택하고 **Run** 클릭 → Flow Builder가 테스트를 실행하고 **Result** 열에 결과를 표시한다.

> [!note] 테스트 데이터는 DB에 저장되지 않는다
> 테스트는 트리거 레코드의 초기값·업데이트값을 설정하는 필드를 포함하며, **테스트 전용으로 레코드 사본(copy)을 만들어 사용한다. 그 레코드는 데이터베이스에 저장되지 않는다.** (인쇄 p.184)

## 테스트 결과 해석 (Interpret Flow Test Results)

인쇄 p.183–185:

1. 테스트 실행 상세를 보려면 메뉴에서 **Run Test and View Details** 선택.
   - **Test Run Details의 All Details 탭**: 테스트 실행 전체의 결과. flow가 실패하면 여기서 오류를 추적한다(→ [[Flow 디버깅과 모니터링 - 오류 이메일·인터뷰]]).
2. **Assertions 탭**에서 어서션별 상태를 펼쳐 확인한다.
   - Flow Builder가 **테스트 실행이 지나간 경로를 캔버스에 하이라이트**한다.
   - 각 어서션은 ① 어떤 조건을 찾았는지, ② 그 조건이 대조된 값(괄호 안), ③ 정의해 둔 커스텀 오류 메시지를 보여준다.
3. 실패한 어서션은 조건과 평가 결과를 확인 → 해당 요소를 클릭해 **Edit Element**로 수정 → flow 저장 → 실패했던 테스트 재실행.

**평가 의미론 (전수):**
- 테스트가 평가할 수 있는 것은 **"flow 요소가 실행되었는가"와 "flow 리소스 값이 기대대로 설정되었는가" 두 가지뿐**이다.
- 테스트는 **org의 기존 Salesforce 데이터와 커스터마이제이션(룰·제약 등)을 기반으로** flow를 평가한다.
- **어서션은 테스트 실행이 끝난 뒤(at the end of the test run) 평가**된다.
- 조건 하나라도 false로 평가되면 그 어서션과 테스트는 실패. **모든 어서션이 통과하면 테스트 통과.**
- flow에 테스트가 있으면 **Tests 목록 뷰**에 그 flow의 모든 테스트와 결과가 표시된다.

> [!tip] 디버그 실행을 테스트로 전환
> record-triggered flow에 한해, 디버그 실행 후 **Convert to Test**로 그 디버그 실행을 테스트로 변환할 수 있다(Screen Flow·Prompt Flow는 불가). 절차는 [[Flow 디버깅과 모니터링 - 오류 이메일·인터뷰]] 참조.

## 테스트 커버리지와 배포

Flow 테스트는 **flow test-coverage 요구사항에 집계되지 않는다**(위 제약 4). 커버리지 요구사항은 **Apex 테스트**로 채운다 (인쇄 p.223–224, "Deploy Processes and Flows as Active"):

- Setup → Process Automation Settings의 **Deploy processes and flows as active**를 켜면 flow test coverage 백분율을 입력한다. 프로세스·autolaunched flow를 active로 배포하려면 **최소 1개의 Apex 테스트**가 그 백분율만큼 활성 프로세스·autolaunched flow를 커버해야 한다.
- **화면(screen)이 있는 flow에는 flow test coverage 요구사항이 적용되지 않는다.**

테스트 커버리지가 없는 활성 autolaunched flow·프로세스의 이름을 모두 조회하는 쿼리 (인쇄 p.225 원문 그대로, Tooling API):

```sql
SELECT Definition.DeveloperName
FROM Flow
WHERE Status = 'Active'
AND (ProcessType = 'AutolaunchedFlow'
    OR ProcessType = 'Workflow'
    OR ProcessType = 'CustomEvent'
    OR ProcessType = 'InvocableProcess')
AND Id NOT IN (SELECT FlowVersionId FROM FlowTestCoverage)
```

> Flow·FlowTest·FlowTestCoverage·FlowElementTestCoverage **Tooling sObject의 필드 상세는 [[Tooling API 객체 — 자동화 (Flow·Workflow·룰)]] 참조** (이 노트는 절차만 담당).

## CLI·Apex에서 Flow 테스트 실행 — 위임

> Flow Builder에서 만든 테스트를 `sf flow run test` CLI나 `flowtesting` 동적 Apex 네임스페이스로 실행하는 방법은 [[Flowtesting Namespace]] 참조.

## 관련 노트

- [[Flow 디버깅과 모니터링 - 오류 이메일·인터뷰]] — 디버그 옵션(Rollback·Run as another user)·오류 이메일·인터뷰 운영 (이 노트의 짝: 테스트=활성화 전, 디버깅·모니터링=운영 중)
- [[Flowtesting Namespace]] — `sf flow run test`·flowtesting 동적 Apex 클래스로 flow test 실행
- [[Tooling API 객체 — 자동화 (Flow·Workflow·룰)]] — FlowTest·FlowTestCoverage·FlowElementTestCoverage Tooling sObject 필드 전수
- [[Flow 에러 처리]] — fault connector 경로 설계 (테스트가 검증할 경로를 만드는 쪽)
- [[Record-Triggered Flow vs Apex Trigger 선택]] — 테스트 대상이 되는 record-triggered flow 설계 판단
