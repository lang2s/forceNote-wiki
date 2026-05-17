---
tags: [flow, naming, convention, best-practice]
source: Salesforce-Flow-Best-Practices-White-Paper-June-2025
created: 2026-05-17
aliases: [Flow 이름 규칙, Flow 네이밍, Flow API 이름, Flow 요소 이름 규칙]
---

# Flow 네이밍 컨벤션

> Flow 타입별 이름 패턴과 Flow 내부 요소(DML, 변수, Decision 등) API 이름 규칙. 팀 간 일관성 확보와 유지보수성을 위한 표준.

---

## Flow 이름 패턴 — 타입별

| Flow 타입 | 이름 형식 | 예시 |
|---|---|---|
| Record-Triggered | `{Object}-{이벤트약어}-{동작}` | `Opportunity-AI-Create Projects` |
| Autolaunched (서브플로우 아님) | `{Object}-{동작}` | `Opportunity-Check On Close Won` |
| Subflow | `{Object}-SFL-{동작}` | `Resource Request-SFL-Populate Skill Requests` |
| Screen | `{Object}-SCR-{동작}` | `Resource Request-SCR-Create New RR` |
| Scheduled | `{Object}-SCH-{동작}` | `Project-SCH-Create Monthly Milestones` |
| Platform Event | `{Platform Event}-EVT-{동작}` | `Integration Log-EVT-Send Notification` |
| Orchestration | `{Object}-{이벤트약어}-ORCH-{동작}` | `Quote-ORCH-Approval Process` |
| Evaluation | `{Object}-EVAL-{동작}` | `Quote-EVAL-Check Level 1 Approvals` |

### 이벤트 약어 (Record-Triggered)

| 이벤트 | 약어 |
|---|---|
| Before Insert | `BI` |
| Before Update | `BU` |
| After Insert | `AI` |
| After Update | `AU` |
| Before Delete | `BD` |

> [!tip] Insert 대신 Create 사용 조직
> 일부 조직은 `AI` 대신 `AC`, `BI` 대신 `BC`를 선호. 팀 내에서 통일하면 된다.

---

## Flow 요소 API 이름 패턴

| 요소 타입 | API 이름 접두어 | 예시 |
|---|---|---|
| **DML - Get Records** | `Get_`, CMDT는 `Fetch_` | `Get_Projects`, `Fetch_DeactivateFlows` |
| **DML - Update Records** | `Update_`, 컬렉션은 `UpdateList_` | `Update_ActiveAssignment`, `UpdateList_ActiveAssignments` |
| **DML - Create Records** | `Insert_`, 컬렉션은 `InsertList_` | `Insert_Milestone`, `InsertList_Milestones` |
| **DML - Delete Records** | `Del_`, 컬렉션은 `DelList_` | `Del_ResourceRequest`, `DelList_ResourceRequests` |
| **Action - Apex** | `APEX_` | `APEX_CreateProjects` |
| **Action - Subflow** | `SUB_` | `SUB_AddSkillsToRRs` |
| **Action - Email Alert** | `EMAIL_` | `EMAIL_NewAssignmentToAssignee` |
| **Screen** | `SC01_`, +1 per new screen | `SC01_CreateResourceRequests` |
| **Screen Element** | `SC01_{name}` (속한 화면 번호로 시작) | `SC01_NumberOfMonths` |
| **Loop** | `LOOP_` | `LOOP_ActiveProjects` |
| **Transform** | `GET_`, `SET_`, `CALC_`, `ADD_` | `CALC_AggregateTotalCost` |

---

## 변수 / 리소스 이름 패턴

| 타입 | 접두어 | 표기법 | 예시 |
|---|---|---|---|
| Number 변수 | `num_` | camelCase | `num_numberOfMilestones` |
| 일반 변수 | `var_` | camelCase | `var_numberOfMilestones` |
| Text Template | `txt_` | camelCase | `txt_errorMessageTemplate` |

---

## Decision 요소 이름 패턴

```
API 이름: IsProjectBillable, CheckRecordType, CanProjectBeClosed
표시 이름: Is Project Billable?, Check Record Type, Can Project Be Closed?
```

**Outcome 이름:**
```
IsProjectBillable_Yes    → 표시: Yes
IsProjectBillable_No     → 표시: No
CheckRecordType_IsResource → 표시: Is Resource
```

> [!warning] Default Outcome 이름 변경 필수
> Flow Builder가 자동 생성하는 Default outcome 이름은 반드시 의미 있는 이름으로 바꾼다.

---

## Assignment 요소 이름 패턴

| 접두어 | 용도 |
|---|---|
| `SET_` | 변수 값 업데이트 (오브젝트 변수) |
| `ASSIGN_` | 변수 초기화 또는 Non-Object 변수 업데이트 |
| `ADD_` | 컬렉션에 항목 추가 |
| `REMOVE_` | 컬렉션에서 항목 제거 |
| `CALC_` | 수식 계산 또는 복잡한 컬렉션 조작 |

```
SET_ProjectValues, ADD_SelectedRoles, CALC_TotalCost
```

---

## 실전 예시 — Contact 레코드 트리거 Flow

```
Flow 이름:   Contact-BI-Set Default Fields
요소 이름:
  Get_AccountDefaults     (Get Records — Default 설정 조회)
  IsPersonAccount         (Decision — Person Account 여부)
  IsPersonAccount_Yes     (Outcome — Yes)
  IsPersonAccount_No      (Outcome — No, Default)
  SET_ContactFields       (Assignment — 필드 값 설정)
```

---

## 관련 노트

- [[Flow 설계 베스트 프랙티스]] — 설계 원칙 전반
- [[Flow 종류와 변수]] — processType 및 변수 구조
- [[Flow 요소 참조]] — XML 요소 상세 참조
