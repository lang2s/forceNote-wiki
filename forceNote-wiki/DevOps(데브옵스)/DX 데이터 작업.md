---
tags: [devops, salesforce-dx, data-import, data-export, bulk-api, soql, sosl, data-tree]
source: sfdx_dev.pdf (Salesforce DX Developer Guide v67.0)
created: 2026-05-23
aliases: [sf data export tree, sf data import tree, data bulk commands, data query, data search, data create file, DX 데이터 이동, Bulk API 2.0 CLI]
---

# DX 데이터 작업

> Scratch Org·Sandbox에서 데이터를 채우고 조회하는 모든 CLI 명령 전수 — Small Datasets(tree), Large Datasets(bulk), Individual Records(record), SOQL/SOSL 쿼리, 파일 업로드.

---

## 개요

개발 환경(Scratch Org·Developer Sandbox)에는 테스트용 기본 데이터가 필요하다.
- Apex 테스트: 자체 데이터 생성 → 별도 데이터 불필요
- UI/API/사용자 수락 테스트: 기준 데이터 필요
- 규모·성능 테스트: 대용량 데이터 필요

Scratch Org는 기반 에디션과 동일한 데이터 세트를 포함한다 (예: Developer Edition → Account·Contact·Lead 각 10~15건).

---

## Small Datasets — data export|import tree

3,000건 미만의 소규모 데이터를 JSON 파일로 내보내고 가져온다.
`data export tree`는 SOQL 쿼리로 선택한 레코드를 JSON(sObject Tree 포맷)으로 저장한다.
`data import tree`는 해당 JSON 파일에서 레코드를 가져온다.

### 단일 오브젝트 내보내기

```bash
sf data export tree \
  --query "SELECT Name, Industry, TickerSymbol FROM Account" \
  --output-dir test-data
```

출력 파일 이름은 쿼리한 오브젝트명을 따른다 (`Account.json`).

```json
// Account.json — sObject Tree 포맷
{
  "records": [
    {
      "attributes": {
        "type": "Account",
        "referenceId": "AccountRef1"
      },
      "Name": "Edge Communications",
      "Industry": "Electronics",
      "TickerSymbol": "EDGE"
    },
    {
      "attributes": {
        "type": "Account",
        "referenceId": "AccountRef2"
      },
      "Name": "Burlington Textiles Corp of America",
      "Industry": "Apparel",
      "TickerSymbol": "BTXT"
    }
  ]
}
```

`referenceId`: 레코드의 임시 ID. 가져오기 시 새 ID가 발급되고 관계(Lookup)가 보존된다.

```bash
# 가져오기
sf data import tree \
  --files test-data/Account.json \
  --target-org new-scratch-org
```

### 부모-자식 관계 내보내기 (--plan 사용)

```bash
sf data export tree \
  --query "SELECT Name, Industry, TickerSymbol, (SELECT FirstName, LastName, Email, Phone FROM Contacts) FROM Account" \
  --output-dir test-data --plan
```

`--plan` 플래그 사용 시:
- `Account.json` (Account 레코드)
- `Contact.json` (Contact 레코드)
- `Account-Contact-plan.json` (가져오기 순서와 관계 정의)

```bash
# Plan 파일로 가져오기 (순서 자동 관리)
sf data import tree \
  --plan test-data/Account-Contact-plan.json \
  --target-org new-scratch-org
```

### Junction 관계(다대다) 내보내기

```bash
sf data export tree \
  --query "SELECT Name, Industry, TickerSymbol FROM Account" \
  --query "SELECT FirstName, LastName, Email, Phone FROM Contact" \
  --query "SELECT Id, ContactId, AccountId FROM AccountContactRelation" \
  --output-dir test-data-junction --plan
```

여러 `--query` 플래그 사용 시 plan 파일명은 항상 `plan.json`.

```bash
sf data import tree \
  --plan test-data-junction/plan.json \
  --target-org new-scratch-org
```

팁: Contact가 여러 Account에 연결되려면 Scratch Org Definition File에 `ContactsToMultipleAccounts` 기능 추가:
```json
{
  "features": ["Walkthroughs", "EnableSetPasswordInApi", "ContactsToMultipleAccounts"]
}
```

---

## Large Datasets — data bulk commands

수백만 건의 대용량 데이터를 Bulk API 2.0으로 비동기 처리한다. 주로 Sandbox 간 데이터 이동이나 Production 데이터 추출/로드에 사용.

### 전체 bulk 명령 목록

| 명령 | 설명 |
|---|---|
| `sf data export bulk` | 대용량 내보내기 요청 |
| `sf data export resume` | 내보내기 작업 상태 확인 |
| `sf data import bulk` | 대용량 가져오기 요청 |
| `sf data import resume` | 가져오기 작업 상태 확인 |
| `sf data delete bulk` | 대용량 삭제 요청 |
| `sf data delete resume` | 삭제 작업 상태 확인 |
| `sf data upsert bulk` | 대용량 업서트 요청 |
| `sf data upsert resume` | 업서트 작업 상태 확인 |
| `sf data update bulk` | 대용량 업데이트 요청 |
| `sf data update resume` | 업데이트 작업 상태 확인 |
| `sf data bulk results` | 완료된 bulk 작업 상세 결과 조회 |

### Bulk Export

```bash
sf data export bulk \
  --query "SELECT Name, Phone, Website FROM Account" \
  --output-file accounts.csv \
  --wait 10
```

주요 플래그:

| 플래그 | 설명 |
|---|---|
| `--query-file` | 파일에서 SOQL 쿼리 읽기 (쿼리가 길 때 유용) |
| `--result-format` | 출력 포맷. 기본은 CSV. `json`도 가능 (단, import는 CSV만 지원) |
| `--all-rows` | 소프트 삭제된 레코드도 포함 |
| `--column-delimiter` | CSV 구분자. 기본 COMMA. BACKQUOTE, CARET 등 지정 가능 |
| `--output-file` | 출력 파일 경로 |
| `--wait` | 완료 대기 시간 (분) |

```bash
# 파일에서 쿼리 읽기 + JSON 출력 + 삭제 레코드 포함
sf data export bulk \
  --query-file soql-query.txt \
  --result-format json \
  --all-rows \
  --output-file accounts-all.json \
  --wait 10 \
  --target-org my-org
```

타임아웃 시 resume:
```bash
sf data export resume --job-id 750xx00fake00005sAAA
# 또는 가장 최근 작업 재개
sf data export resume --use-most-recent
```

> 주의: Bulk API 2.0은 GROUP BY, LIMIT, 집계 함수(count()) 등을 지원하지 않는다.

### Bulk Import

```bash
sf data import bulk \
  --file accounts.csv \
  --sobject Account \
  --column-delimiter COMMA \
  --wait 10 \
  --target-org new-scratch-org
```

- CSV 포맷만 지원 (JSON 불가)
- 첫 행은 필드명 목록이어야 함
- 필수 필드 전부 포함 필요

타임아웃 시 resume:
```bash
sf data import resume --use-most-recent
```

### Bulk Delete

ID 목록이 담긴 CSV 파일로 여러 레코드를 한 번에 삭제한다.

```csv
Id
0017z00000m14R9AAI
0017z00000m5a0nAAA
0017z00000m5a0oAAA
```

```bash
sf data delete bulk \
  --sobject Account \
  --file delete-accounts.csv \
  --wait 10
```

기본 동작: Recycle Bin으로 이동 (소프트 삭제)
즉시 영구 삭제:
```bash
sf data delete bulk \
  --sobject Account \
  --file delete-accounts.csv \
  --hard-delete \
  --wait 10
```

> `--hard-delete`는 `Bulk API Hard Delete` 시스템 권한 필요 (기본 비활성화, 관리자만 활성화 가능)

### Bulk Update와 Upsert

CSV 파일 형식 (첫 열 = 레코드 ID):
```csv
Id,Name
0017z00000m14R9AAI,"New Name One"
0017z00000m5930AAA,"New Name Two"
0017z00000m5931AAA,"New Name Three"
```

```bash
# 기존 레코드만 업데이트
sf data update bulk \
  --file accounts-update.csv \
  --sobject Account \
  --wait 10

# 기존 레코드 업데이트 + 새 레코드 삽입
# Id 비어 있으면 새로 삽입
sf data upsert bulk \
  --file accounts-update.csv \
  --sobject Account \
  --external-id Id \
  --wait 10
```

Upsert CSV 예시 (빈 Id = 새 레코드 삽입):
```csv
Id,Name
0017z00000m14R9AAI,"New Name One"
,"New Account"
```

### Bulk 결과 상세 조회

완료된 bulk 작업의 상세 결과 조회 (Salesforce CLI 명령, Data Loader, AppExchange 도구 포함):

```bash
sf data bulk results \
  --job-id 75fake00CZBD1IAP \
  --target-org my-scratch
```

출력 예시:
```
Status: JobComplete
Operation: insert
Object: Account
Processed records: 13
Successful records: 13
Saved successful results to 75fake00CZBD1IAP-success-records.csv
```

- 성공 레코드: CSV 파일로 저장 (새 Salesforce ID 포함)
- 오류 발생 시: 실패 레코드와 미처리 레코드 CSV 파일 별도 생성

---

## Individual Records — data record commands

CSV/JSON 파일 없이 커맨드라인에서 직접 단건 레코드를 생성·조회·수정·삭제한다. 표준/커스텀 오브젝트 및 Tooling API 오브젝트 모두 지원.

### 레코드 생성

```bash
sf data create record \
  --sobject Account \
  --values "Name='Exciting Company' Website=www.example.com NumberOfEmployees=45 Phone='(415) 555-1212'"
```

- `--values`에 필드 API명 사용 (레이블 아님)
- 값에 공백이 있으면 작은따옴표 감싸기
- 필수 필드 전부 지정 필요

Tooling API 오브젝트 생성:
```bash
sf data create record \
  --use-tooling-api \
  --sobject TraceFlag \
  --values "DebugLevelId=7dl170000008U36AAE StartDate=2024-12-15T00:26:04.000+0000 ExpirationDate=2024-12-15T00:56:04.000+0000 LogType=CLASS_TRACING TracedEntityId=01p17000000R6bLAAS"
```

### 레코드 조회

```bash
# 필드값으로 조회
sf data get record \
  --sobject Account \
  --where "Name='Exciting Company' Website=www.example.com"

# ID로 조회
sf data get record \
  --sobject Account \
  --record-id 001Oy0000xyz123

# Tooling API 오브젝트 조회
sf data get record \
  --use-tooling-api \
  --sobject TraceFlag \
  --record-id 7tf8c00xx
```

`--where` 조건이 복수의 레코드와 매칭되면 명령 실패 (발견된 건수 오류 표시).
값이 없는 필드는 `null`로 표시.

### 레코드 업데이트

```bash
sf data update record \
  --sobject Account \
  --where "Name='Exciting Company'" \
  --values "Phone='(510) 555-1212'"
```

### 레코드 삭제

```bash
# 필드값으로 삭제
sf data delete record \
  --sobject Account \
  --where "Name='Exciting Company'"

# Tooling API 오브젝트 삭제
sf data delete record \
  --use-tooling-api \
  --sobject TraceFlag \
  --record-id 7tf8c00xx
```

---

## SOQL/SOSL 쿼리

### SOQL — data query

단일 Salesforce 또는 Tooling API 오브젝트 검색.

```bash
# 기본 SOQL 쿼리
sf data query \
  --query "SELECT Id, Name FROM Account WHERE Industry='Energy'"

# 파일에서 쿼리 읽기 (긴 쿼리에 유용)
sf data query \
  --file query.txt \
  --target-org new-scratch-org

# 소프트 삭제된 레코드 포함 + JSON 출력
sf data query \
  --query "SELECT Id, Name FROM Account WHERE Industry='Energy'" \
  --all-rows \
  --result-format json

# Tooling API 오브젝트 쿼리 + CSV 파일로 저장
sf data query \
  --query "SELECT Id, Name FROM ApexClass" \
  --use-tooling-api \
  --result-format csv \
  --output-file query-output.csv
```

> 팁: 2,000건 이상은 `sf data export bulk` 사용

주요 플래그:
- `--all-rows`: 소프트 삭제 레코드 포함
- `--result-format`: 출력 포맷 (기본: human-readable 표, `json`, `csv`)
- `--output-file`: CSV 출력 파일 경로
- `--use-tooling-api`: Tooling API 오브젝트 대상

### SOSL — data search

여러 오브젝트에 걸쳐 텍스트 검색.

```bash
# Contact와 Lead에서 'Jo'로 시작하는 이름 검색
sf data search \
  --query "FIND {Jo*} IN Name FIELDS RETURNING Contact(Name, Phone), Lead(Name, Phone)"

# 파일에서 SOSL 검색 쿼리 읽기
sf data search \
  --file query.txt \
  --target-org new-scratch-org

# CSV로 출력
sf data search \
  --file query.txt \
  --result-format csv
```

---

## 파일 업로드 — data create file

로컬 파일을 Org의 `ContentDocument` 오브젝트로 업로드한다.
Salesforce UI의 Files 탭에서 확인 가능.
같은 이름의 파일이 이미 있어도 새 레코드가 생성됨 (업데이트 불가).

```bash
# 기본 업로드
sf data create file \
  --file astro.png \
  --target-org new-scratch-org

# 타이틀 지정 (기본: 확장자 없는 파일명)
sf data create file \
  --file astro.png \
  --title "Astro Running" \
  --target-org new-scratch-org

# 특정 레코드에 첨부 (parent-id = Contact ID)
sf data create file \
  --file astro.png \
  --parent-id 003O300000WLdtwIAD \
  --title "Astro Running" \
  --target-org new-scratch-org
```

주요 플래그:
- `--file`: 업로드할 로컬 파일 경로
- `--title`: ContentDocument Title 필드 값 (기본: 확장자 없는 파일명)
- `--parent-id`: 첨부할 레코드 ID (미지정 시 레코드 미첨부)

---

## 관련 노트

- [[Scratch Org 생성과 정의 파일]] — 데이터 작업 대상 Scratch Org 생성
- [[Sandbox 관리]] — 데이터 이동 대상 Sandbox 생성
- [[DX 개발 워크플로]] — 개발 사이클에서 데이터 작업 위치
- [[Unlocked Package 개발과 버전]] — 패키지 버전 생성 시 테스트 데이터 필요
- [[DX 제약사항]] — data tree import 제약 (RecordType import 불가 등)
