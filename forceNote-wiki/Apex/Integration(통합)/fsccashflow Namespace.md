---
tags: [Apex, Namespace, fsccashflow, FSC, Financial-Services-Cloud, Callable, FlexCard, CashFlow]
source: salesforce_apex_reference_guide.pdf (v67.0)
created: 2026-05-23
aliases: [fsccashflow, FSCCashFlowUtil, Financial Services Cloud CashFlow, FSC CashFlow Apex, 현금흐름 FlexCard]
---

# fsccashflow Namespace

> FSCCashFlow FlexCard 및 자식 FlexCard에서 사용하는 유틸리티 클래스 모음 — Callable 인터페이스로 수입·지출 데이터 관리 및 유효성 검사

---

## 개념 설명

`fsccashflow` 네임스페이스는 **Financial Services Cloud(FSC)의 CashFlow FlexCard**와 그 자식 FlexCard에서 사용하는 클래스를 제공한다. 핵심 클래스는 `FSCCashFlowUtil`로, Callable 인터페이스를 구현해 Action 이름과 인자 Map으로 다양한 수입·지출 유틸리티 기능을 제공한다.

FSC의 Financial Goals FlexCard는 Integration Procedure에서 `FSCHouseholdService` 클래스를 호출하며, FlexCard는 당사자(Party)의 수입과 지출 정보를 표시한다.

---

## 클래스 목록

| 클래스 | 설명 |
|---|---|
| `FSCCashFlowUtil` | Callable 유틸리티 클래스 — 수입·지출 데이터 관리 및 유효성 검사 |

---

## FSCCashFlowUtil Class

Callable 인터페이스를 구현한 유틸리티 클래스로, action 이름과 인자 Map을 통해 호출한다.

**네임스페이스:** `fsccashflow`

**시그니처:**
```apex
call(String action, Map<String, Object> args)
```

### FSCCashFlowUtil Methods

| 메서드(Action 이름) | 설명 | 반환 값 |
|---|---|---|
| `GetPartyIncomeFrequencyLabel` | 수입 빈도 필드 피클리스트 값 목록 | 피클리스트 레이블 목록 |
| `GetPartyIncomeTypeLabel` | 수입 유형 필드 피클리스트 값 목록 | 피클리스트 레이블 목록 |
| `GetPartyIncomeStatusLabel` | 수입 상태 필드 피클리스트 값 목록 | 피클리스트 레이블 목록 |
| `CalculateIncomeExpenseSummary` | 수입·지출 목록에서 월간/총 수입·지출·잉여금 계산 | 수입·지출 집계 상세 |
| `GetPartyExpenseFrequencyLabel` | 지출 빈도 필드 피클리스트 값 목록 | 피클리스트 레이블 목록 |
| `GetPartyExpenseTypeLabel` | 지출 유형 필드 피클리스트 값 목록 | 피클리스트 레이블 목록 |
| `GetPartyExpenseStatusLabel` | 지출 상태 필드 피클리스트 값 목록 | 피클리스트 레이블 목록 |
| `PerformIncomeValidation` | Party Income 레코드 유효성 검사 (시작일 > 종료일 방지) | 검사 결과 목록 |
| `PerformExpenseValidation` | Party Expense 레코드 유효성 검사 | 검사 결과 |
| `GetDurationDateRange` | 기간(Duration)과 현재 날짜로 시작·종료 날짜 계산 | 날짜 범위 |
| `HandleUpsertError` | partyIncome/partyExpense upsert 오류 응답 구성 | 오류 목록 |
| `CheckReadAccess` | partyIncome·partyExpense 엔티티 읽기 권한 확인 | True/False |
| `CheckCrudOnIncome` | partyIncome 엔티티 생성·수정·삭제 권한 확인 | True/False |
| `CheckCrudOnExpense` | partyExpense 엔티티 생성·수정·삭제 권한 확인 | True/False |

---

## 코드 예제

### Callable 호출 패턴

```apex
// FSCCashFlowUtil은 Callable 인터페이스를 구현함
// Type.forName으로 동적 인스턴스화 후 call() 메서드로 호출

// 1. Callable 인스턴스 획득
Callable cashFlowUtil = (Callable) Type.forName('fsccashflow', 'FSCCashFlowUtil').newInstance();

// 2. 수입 빈도 피클리스트 조회
List<Object> incomeFrequencies = (List<Object>) cashFlowUtil.call(
    'GetPartyIncomeFrequencyLabel', 
    new Map<String, Object>()
);
System.debug('Income Frequencies: ' + incomeFrequencies);

// 3. 읽기 권한 확인
Map<String, Object> accessResult = (Map<String, Object>) cashFlowUtil.call(
    'CheckReadAccess',
    new Map<String, Object>()
);
Boolean isAccessible = (Boolean) accessResult.get('isAccessible');
System.debug('Is Accessible: ' + isAccessible);

// 4. CRUD 권한 확인 (Income)
Map<String, Object> crudResult = (Map<String, Object>) cashFlowUtil.call(
    'CheckCrudOnIncome',
    new Map<String, Object>()
);
Boolean isCreatable = (Boolean) crudResult.get('isCreatable');
Boolean isUpdateable = (Boolean) crudResult.get('isUpdateable');
Boolean isDeletable = (Boolean) crudResult.get('isDeletable');
```

### CalculateIncomeExpenseSummary 입력/출력 예시

```json
// 입력 형식 (args)
[
  {
    "Duration": "12",
    "PartyExpenseList": [
      {
        "Name": "PE-0000000004",
        "UsageType": "CashFlow",
        "RecurrenceInterval": "Monthly",
        "Type": "Child Care",
        "Id": "2n3SG000007dkzpYAA",
        "TotalAmount": 999.99,
        "PartyId": "001SG000004TCczYAG",
        "Status": "Active",
        "StartDate": "2024-01-29T08:00:00.000Z"
      }
    ],
    "PartyIncomeList": [
      {
        "Name": "PI-0000000003",
        "UsageType": "CashFlow",
        "IncomeFrequency": "Monthly",
        "IncomeType": "Salary",
        "Id": "2m3SG000007dkzpYAA",
        "IncomeAmount": 999.99,
        "PartyId": "001SG000004TCczYAG",
        "IncomeStatus": "Active",
        "StartDate": "2024-01-29T08:00:00.000Z"
      }
    ]
  }
]
```

```json
// 출력 형식
[
  {
    "MonthlyIncome": {
      "Jan 2024": 96.77,
      "Feb 2024": 999.99,
      "Mar 2024": 999.99
    },
    "MonthlyExpense": {
      "Jan 2024": 96.77,
      "Feb 2024": 999.99
    },
    "AvgMonthlyExpense": 674.72,
    "TotalIncome": 8096.69,
    "TotalSurplus": 0,
    "AvgMonthlyIncome": 674.72,
    "AvgMonthlySurplus": 0,
    "TotalExpense": 8096.69
  }
]
```

### GetDurationDateRange 출력 예시

```json
// 입력: Duration 3, 기준일 2024-10-29
// 출력
{
  "DurationStartDate": "2024-07-01T00:00:00.000Z",
  "DurationEndDate": "2024-10-01T00:00:00.000Z"
}
```

### HandleUpsertError 예시

```json
// 입력: partyIncome 레코드 목록
// 출력
[{ "UpsertError": "Invalid Id" }]
```

### CheckReadAccess 출력 예시

```json
{ "isAccessible": "true" }
```

### CheckCrudOnIncome / CheckCrudOnExpense 출력 예시

```json
{
  "isCreatable": "true",
  "isUpdateable": "true",
  "isDeletable": "true"
}
```

---

## 관련 노트
- [[ComplianceMgmt Namespace]]
- [[IndustriesDigitalLending Namespace]]
- [[industriesNlpSvc Namespace]]
- [[ConnectApi Namespace 개요]]
