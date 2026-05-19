---
tags: [apex, datacloud, duplicate-management, duplicate-rules, find-duplicates, match-record, deduplication]
source: salesforce_apex_reference_guide.pdf (Apex Reference Guide v67.0, p.2741~2760)
created: 2026-05-20
aliases: [Datacloud Namespace, Datacloud.FindDuplicates, Datacloud.FindDuplicatesByIds, Datacloud.DuplicateResult, Datacloud.MatchRecord, Datacloud.MatchResult, 중복 레코드 탐지 Apex, 중복 관리 Apex, findDuplicates, FindDuplicatesResult]
---

# Datacloud Namespace

> Duplicate Management(중복 규칙)를 Apex에서 제어하는 API — 레코드 저장 전 중복 탐지, DML 에러에서 중복 결과 추출.

> [!warning] 이름에 주의 — Salesforce Data Cloud(CDP) 제품과 무관
> `Datacloud` 네임스페이스는 **Duplicate Management 기능**(중복 규칙)에 관한 API입니다. Salesforce Data Cloud(구 CDP) 제품과는 완전히 별개입니다. 이름만 보고 Data Cloud 관련 코드로 혼동하지 않도록 주의합니다.

---

## 개념

Salesforce의 Duplicate Management는 Setup > Duplicate Rules에서 활성화한 중복 규칙을 통해 레코드 저장 시 중복 여부를 감지하고 차단하거나 경고를 표시한다. `Datacloud` 네임스페이스는 이 중복 탐지 로직을 **Apex에서 직접 실행**하거나 **DML 에러에서 중복 결과를 추출**할 수 있게 해준다.

### 두 가지 사용 패턴

| 패턴 | 설명 | 클래스 |
|---|---|---|
| **DML 에러 추출** | insert/update 시 중복 에러 발생 → `Database.DuplicateError` → `DuplicateResult` → `MatchResult` → `MatchRecord` | DuplicateResult, MatchResult, MatchRecord |
| **사전 탐지** | DML 없이 중복 여부 먼저 확인 → 조건에 따라 DML 실행 여부 결정 | FindDuplicates, FindDuplicatesByIds, FindDuplicatesResult |

---

## 클래스 목록

| 클래스 | 설명 |
|---|---|
| `FindDuplicates` | sObject 배열로 중복 탐지 (static) |
| `FindDuplicatesByIds` | ID 배열로 중복 탐지 (static) |
| `FindDuplicatesResult` | FindDuplicates/FindDuplicatesByIds 결과 컨테이너 |
| `DuplicateResult` | 하나의 중복 규칙이 탐지한 결과 및 매치 정보 |
| `MatchResult` | 하나의 매칭 규칙 결과 — MatchRecord 목록 포함 |
| `MatchRecord` | 중복으로 탐지된 실제 레코드 |
| `FieldDiff` | 중복 레코드와 원본 레코드 간 필드 값 비교 |
| `AdditionalInformationMap` | 매칭 레코드의 추가 메타데이터 (name-value 쌍) |

---

## 패턴 1 — DML 에러에서 중복 결과 추출

레코드 저장 시 중복 규칙이 Block 액션이면 DML 에러가 발생한다. 이 에러에서 중복 정보를 꺼내는 패턴.

```apex
// false = partial success 허용 (true면 allOrNothing)
Database.SaveResult saveResult = Database.insert(contact, false);

if (!saveResult.isSuccess()) {
    for (Database.Error error : saveResult.getErrors()) {
        if (error instanceof Database.DuplicateError) {
            Database.DuplicateError dupError = (Database.DuplicateError) error;

            // DuplicateResult: 어떤 Duplicate Rule이 트리거됐는지
            Datacloud.DuplicateResult dupResult = dupError.getDuplicateResult();
            System.debug('Rule: ' + dupResult.getDuplicateRule());
            System.debug('ErrorMsg: ' + dupResult.getErrorMessage());
            System.debug('AllowSave: ' + dupResult.isAllowSave());

            // MatchResult → MatchRecord: 실제 중복 레코드 목록
            for (Datacloud.MatchResult matchResult : dupResult.getMatchResults()) {
                System.debug('MatchRule: ' + matchResult.getRule());
                for (Datacloud.MatchRecord matchRecord : matchResult.getMatchRecords()) {
                    System.debug('Duplicate: ' + matchRecord.getRecord());
                }
            }
        }
    }
}
```

---

## 패턴 2 — 사전 중복 탐지 (FindDuplicates)

DML을 실행하기 전에 중복 여부를 먼저 확인한다. 중복이 없을 때만 삽입하는 패턴.

```apex
// sObject 배열로 탐지 — 같은 타입만, 최대 50개
Account acct = new Account(
    Name = 'Test Account 123',
    BillingStreet = '123 Test Street',
    BillingCity = 'San Francisco',
    BillingState = 'CA',
    BillingCountry = 'US'
);

List<Datacloud.FindDuplicatesResult> results =
    Datacloud.FindDuplicates.findDuplicates(new List<Account>{ acct });

Datacloud.FindDuplicatesResult acctResult = results[0];

if (acctResult.isSuccess()) {
    Boolean duplicatesFound = false;

    for (Datacloud.DuplicateResult dupResult : acctResult.getDuplicateResults()) {
        for (Datacloud.MatchResult matchResult : dupResult.getMatchResults()) {
            if (!matchResult.getMatchRecords().isEmpty()) {
                duplicatesFound = true;
                System.debug('Duplicate found: ' + matchResult.getRule());
                for (Datacloud.MatchRecord mr : matchResult.getMatchRecords()) {
                    System.debug(mr.getRecord());
                }
            }
        }
    }

    if (!duplicatesFound) {
        insert acct;
        System.debug('Account inserted.');
    }
} else {
    for (Database.Error err : acctResult.getErrors()) {
        System.debug(err.getMessage());
    }
}
```

---

## 패턴 3 — ID 배열로 중복 탐지 (FindDuplicatesByIds)

기존 레코드 ID 목록으로 중복을 탐지한다.

```apex
List<Id> idList = new List<Id>{ 'EXISTING_RECORD_ID_18_DIGIT' };

List<Datacloud.FindDuplicatesResult> results =
    Datacloud.FindDuplicatesByIds.findDuplicatesByIds(idList);

Datacloud.FindDuplicatesResult idResult = results[0];

if (idResult.isSuccess()) {
    for (Datacloud.DuplicateResult dupResult : idResult.getDuplicateResults()) {
        for (Datacloud.MatchResult matchResult : dupResult.getMatchResults()) {
            if (!matchResult.getMatchRecords().isEmpty()) {
                System.debug('Duplicate found: ' + matchResult.getRule());
            }
        }
    }
}
```

---

## 클래스 메서드 레퍼런스

### FindDuplicates 클래스

```apex
public static List<Datacloud.FindDuplicatesResult>
    findDuplicates(List<SObject> sObjects)
```

### FindDuplicatesByIds 클래스

```apex
public static List<Datacloud.FindDuplicatesResult>
    findDuplicatesByIds(List<Id> ids)
```

### FindDuplicatesResult 클래스

| 멤버 | 타입 | 설명 |
|---|---|---|
| `duplicateresults` (property) | `List<Datacloud.DuplicateResult>` | 탐지된 중복 규칙 결과 목록 |
| `errors` (property) | `List<Database.Error>` | 탐지 중 발생한 에러 목록 |
| `success` (property) | `Boolean` | 탐지 성공 여부 |
| `getDuplicateResults()` | `List<DuplicateResult>` | 중복 규칙 결과 반환 |
| `getErrors()` | `List<Database.Error>` | 에러 반환 |
| `isSuccess()` | `Boolean` | 성공 여부 반환 |

### DuplicateResult 클래스

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getDuplicateRule()` | `String` | 트리거된 Duplicate Rule의 developer name |
| `getErrorMessage()` | `String` | 관리자가 설정한 중복 경고 메시지 |
| `getMatchResults()` | `List<MatchResult>` | 매칭 규칙별 결과 목록 |
| `isAllowSave()` | `Boolean` | 규칙이 저장을 허용하는지 여부 |

### MatchResult 클래스

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getMatchRecords()` | `Datacloud.MatchRecord[]` | 중복으로 탐지된 레코드 배열 |
| `getRule()` | `String` | 이 결과를 생성한 Matching Rule 이름 |
| `isSuccess()` | `Boolean` | 매칭 규칙 실행 성공 여부 |
| `getErrors()` | `List<Database.Error>` | 실행 중 에러 목록 |

### MatchRecord 클래스

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getRecord()` | `SObject` | 중복으로 탐지된 실제 레코드 |
| `getAdditionalInformation()` | `Map<String, Datacloud.AdditionalInformationMap>` | 매칭 레코드의 추가 메타데이터 |
| `getFieldDiffs()` | `List<Datacloud.FieldDiff>` | 원본과 중복 레코드 간 필드 비교 목록 |

### FieldDiff 클래스

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getName()` | `String` | 비교된 필드 이름 |
| `getDifference()` | `String` | `SAME` / `DIFFERENT` / `NULL` |

---

## 주의사항

### 1. Datacloud ≠ Salesforce Data Cloud

Apex Reference Guide p.2741 명시: **"The Datacloud namespace isn't related to the Salesforce Data Cloud product."** 이름이 매우 유사하지만 완전히 별개의 기능이다.

### 2. 입력 배열 최대 50개

`FindDuplicates.findDuplicates()` 와 `FindDuplicatesByIds.findDuplicatesByIds()` 모두 **입력 배열 크기가 50개를 초과하면 예외** 발생:
```
Configuration error: The number of records to check is greater than the permitted batch size.
```

### 3. 활성화된 Duplicate Rule 필요

대상 오브젝트 타입에 활성화된 Duplicate Rule이 없으면 `System.HandledException` 발생:
```
No active duplicate rules are defined for the {ObjectName} object type.
```

### 4. 커스텀 필드는 기본 미포함

`findDuplicates()`는 기본적으로 커스텀 필드를 반환하지 않는다. 커스텀 필드를 매칭 기준에 포함하려면 커스텀 Matching Rule을 구성하고 Duplicate Rule에 연결해야 한다.

### 5. DuplicateResult는 Database.DuplicateError 내부에 포함

DML 경로에서는 `SaveResult.getErrors()` → `instanceof Database.DuplicateError` → `getDuplicateResult()` 순서로 접근한다. `DuplicateResult`를 직접 생성하거나 외부에서 얻을 수 없다.

---

## 관련 노트

- [[DML 패턴]] — Database.insert(allOrNone), partial success 처리, DuplicateError 포함
- [[Database Namespace 상세]] — SaveResult, Database.Error, DMLOptions 전체 레퍼런스
