---
tags: [flow, best-practice, design, pattern, performance]
source: Salesforce-Flow-Best-Practices-White-Paper-June-2025
created: 2026-05-17
aliases: [Flow 베스트 프랙티스, Flow 설계 원칙, Flow 성능, Flow 바이패스, Fast Field Update, Flow 거버너]
---

# Flow 설계 베스트 프랙티스

> CLD Partners White Paper(2025-06) 기반 Flow 설계·운영 원칙. 네이밍·에러 처리를 제외한 설계 전략, 성능, 유지보수 관련 항목을 정리.

---

## 1. Fast Field Update — 언제나 우선 사용

Fast Field Update = Apex의 **before-save context** 동등물. 같은 트랜잭션에서 DML 없이 레코드 필드를 업데이트한다.

**조건 (모두 충족 시 사용 가능):**
- 트리거된 레코드만 업데이트
- Create Records / Delete Records / Action / Subflow 요소 없음

```
Fast Field Update Flow:
  [트리거] → [Assignment: SET_DefaultFields] → (저장, DML 없음)

After-Save Flow:
  [트리거] → [Create Records: Child_Object__c] → (별도 DML 발생)
```

> [!warning] Fast Field Update에서는 Update가 아닌 Assignment 사용
> Fast Field Update Flow에서 `Update Records` 요소를 쓰면 추가 DML이 발생한다. 반드시 `Assignment` 요소로 필드 값을 수정한다.

---

## 2. 하드코딩된 ID 절대 금지

Flow 안에 ID를 직접 입력하면 Sandbox → Production 배포 시 반드시 깨진다.

```
❌ 금지: Decision → {!RecordTypeId} = '012xx0000000001AAA'

✅ 올바른 방법:
  [Get Records: Fetch_RecordType]
    Object: RecordType
    Filter: SObjectType = 'Opportunity', DeveloperName = 'Enterprise'
  → {!Fetch_RecordType.Id} 를 이후 요소에서 참조
```

Record Type ID도 마찬가지 — RecordType 오브젝트에서 Get Records로 조회한다.

---

## 3. 진입 조건(Entry Criteria) 최적화

Flow 수가 늘수록 진입 조건 설계가 성능을 좌우한다.

```
Record-Triggered Flow 진입 조건 예:
  - Status가 변경됨 (ISCHANGED)
  - Stage = 'Closed Won'
  - 불필요한 레코드는 아예 Flow 진입 차단
```

> [!tip] Flow Trigger Explorer로 실행 순서 제어
> Setup → Flow Trigger Explorer → 오브젝트·컨텍스트별 실행 순서를 드래그로 조정한다. 순서가 중요한 경우 반드시 설정.

---

## 4. 바이패스(Circuit Breaker) — 긴급 비활성화

모든 Record-Triggered Flow에 바이패스 메커니즘을 추가한다. 데이터 마이그레이션, Sandbox 초기화 시 Flow 전체를 끄는 안전장치.

**Custom Setting 방식 (권장):**

```
Custom Setting: Trigger_Control_Settings__c
Field: Deactivate_Flows__c (Checkbox)

Flow 진입 조건에 추가:
  {!$Setup.Trigger_Control_Settings__c.Deactivate_Flows__c} = false
```

또는 Flow 첫 번째 요소로 Decision 추가:
```
[Decision: IsFlowActive]
  Outcome Yes: Deactivate_Flows__c = false → 계속 진행
  Default (Deactivated): → Flow 즉시 종료
```

> [!tip] Custom Permission 방식
> Custom Setting 대신 Custom Permission을 쓰면 특정 사용자에게만 바이패스 권한을 부여할 수 있어 더 세밀한 제어가 가능하다.

---

## 5. Mixed DML — Asynchronous Path 사용

같은 트랜잭션에서 Setup 오브젝트(User, Group 등)와 일반 오브젝트를 동시에 DML하면 Mixed DML 에러 발생.

```
해결 방법: Asynchronous Path 추가

[트리거]
  ↓ Immediately (동기)
  [Update Records: Setup Object (User)]

  ↓ Asynchronously (비동기 Path)
  [Update Records: Non-Setup Object (Account)]
```

---

## 6. 거버너 한도 — Loop 안에서 DML 금지

```
❌ 금지 패턴:
  [LOOP_Contacts]
    → [Update Records: Contact]   ← Loop 안에서 DML

✅ 올바른 패턴:
  [LOOP_Contacts]
    → [Assignment: ADD_ContactsToUpdate]   (컬렉션에 추가)
  [Update Records: ContactsToUpdate]       (Loop 밖에서 한번에 DML)
```

---

## 7. Subflow — 재사용 & 권한 분리

Subflow는 Apex의 helper class와 같다.

**사용 시점:**

| 상황 | Subflow 사용 |
|---|---|
| 여러 Flow에서 동일한 로직 반복 | ✅ 재사용 |
| Flow가 너무 복잡하고 길어짐 | ✅ 로직 분리 |
| Screen Flow에서 시스템 컨텍스트로 오브젝트 업데이트 | ✅ 권한 우회 |
| 단순하고 독립적인 프로세스 | ❌ 불필요한 복잡도 추가 |

```
Subflow 권한 우회 패턴:
  [Screen Flow — User Context]
    → [SUB_UpdateRestrictedObject]   ← System Context with Sharing으로 실행
      (사용자가 Edit 권한 없는 오브젝트도 업데이트 가능)
```

> [!warning] Subflow는 Before-Save Flow에서 사용 불가
> Record-Triggered Before-Save Flow에서는 Subflow 요소를 사용할 수 없다.

---

## 8. Flow 설명 필수 작성

```
Flow 설명 예시:
  "Contact 레코드 생성 시(Before Insert) 기본 필드 값을 설정한다.
   관련 오브젝트: Contact, Account.
   호출 방식: 레코드 저장 자동 실행."

Flow 요소 설명 예시:
  Get_AccountDefaults → "연결된 Account의 기본값(Region, Segment) 조회"
  IsPersonAccount     → "Account가 Person Account인지 확인"
```

> [!tip] Flow 요소 설명은 Agentforce 액션 지원
> 요소에 Description이 있으면 Agentforce Flow Action에서 자동으로 컨텍스트 정보로 활용된다.

---

## 9. 외부 API 호출 — HTTP Callout in Flow *(Winter '24 GA)*

External Services + Flow 조합으로 Apex 없이 외부 REST API를 호출할 수 있다. **Apex 없이 통합 가능한 경우 Flow 우선 고려.**

```
[Get Records: Account]
  → [External Services Action: POST /orders]  ← Apex 불필요
      Input: {!Account.Id}, {!Account.Name}
  → [Decision: IsSuccess]
      응답 상태 코드 기반 분기
```

> [!tip] External Services 사용 조건
> Named Credential 설정 + OpenAPI 3.0 스펙 등록 필요. 복잡한 인증 흐름이나 동적 엔드포인트는 여전히 Apex Invocable 사용.

---

## 10. Winter '26 신기능 — 인라인 Transform · 중첩 루프 · LWC 로컬 액션

### 인라인 Transform 처리 *(Winter '26 추가)*

별도 Transform 요소 없이 액션 설정 안에서 데이터 변환이 가능하다. Flow 캔버스가 단순해지고 중간 변수를 줄일 수 있다.

```
[이전] [Action] → [Transform 요소] → [다음 Action]
[이후] [Action (변환 인라인 설정)] → [다음 Action]
```

### 중첩 루프 Beta *(Winter '26 추가)*

여러 수준의 관련 레코드를 처리할 때 Loop 안에 Loop를 중첩할 수 있다 (Beta).

```
[LOOP_Accounts]
  → [LOOP_Contacts (중첩)]     ← Winter '26 Beta
      → [Assignment: ADD_Contacts]
```

> [!warning] 중첩 루프 Beta 주의
> DML을 중첩 루프 안에서 실행하면 거버너 한도 초과 위험. 내부 루프에서는 Collection에 추가하고 외부 루프 이후 한번에 DML.

### LWC 로컬 액션 *(Winter '26 추가)*

LWC로 Screen Flow 내 로컬 액션을 제작할 수 있다. JavaScript로 클라이언트 사이드 처리(파일 다운로드, 클립보드 복사 등)를 Flow에서 직접 실행 가능.

```
Screen Flow:
  [Screen] → [LWC Local Action: c/copyToClipboard] → [다음 화면]
```

### Flow 트랜잭션 자동 결정 *(Winter '26 추가)*

Flow가 실행 컨텍스트를 동적으로 판단하여 트랜잭션 필요 여부를 스스로 결정한다.

---

## 11. 테스트 — 실행 사용자로 디버그

Flow는 배포에 테스트 커버리지가 필요 없지만, 반드시 **실행 사용자 권한으로 테스트**해야 한다.

```
Setup → Process Automation Settings
  → "Let admins debug flows as other users" 체크

Flow Debug 화면 → "Run flow as another user" 선택
  → 해당 사용자 권한으로 실행되는 결과 확인
```

Record-Triggered Flow: **Test Records** 생성 및 어서션으로 케이스 커버리지 확보.

---

## 빠른 체크리스트 (배포 전)

```
□ Flow 설명 작성 완료
□ Fast Field Update 가능 여부 검토
□ 모든 ID를 Get Records로 동적 조회
□ 진입 조건(Entry Criteria) 최적화
□ Record-Triggered Flow에 바이패스 추가
□ Loop 안에 DML 없음
□ Mixed DML 있다면 Asynchronous Path 분리
□ 모든 DML·Action에 Fault 연결
□ 실행 사용자로 테스트 완료
□ Flow Trigger Explorer에서 실행 순서 확인
```

---

## 관련 노트

- [[Flow 네이밍 컨벤션]] — Flow 이름·요소 이름 규칙
- [[Flow 에러 처리]] — Fault 경로 설계
- [[Flow 종류와 변수]] — processType 및 컨텍스트
- [[Autolaunched Flow 패턴]] — 헤드리스 Flow 설계
