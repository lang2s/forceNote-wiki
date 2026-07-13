---
tags: [omnistudio, formula, functions, reference, expression, operators]
source: help.salesforce.com — OmniStudio Formulas and Functions (xcloud.os_omnistudio_formulas_and_functions·os_omnistudio_conditional_functions·os_omnistudio_mathematical_functions·os_omnistudio_date_and_time_functions·os_omnistudio_string_functions·os_omnistudio_list_functions·os_omnistudio_json_object_functions·os_omnistudio_invocation_functions·os_omnistudio_data_mapper_and_integration_procedure_operators·os_omnistudio_data_mapper_and_integration_procedure_data_types, 접속일 2026-07-13) [Tier 2]
created: 2026-07-13
aliases: [OmniStudio Formula Functions, 옴니스튜디오 함수, formula reference, conditional functions, math functions, date functions, string functions, list functions, JSON functions, invocation functions, 연산자, operators, data types, VALUELOOKUP, QUERY, SUM]
---

# OmniStudio Formula Functions 레퍼런스

> OmniStudio Data Mapper·Integration Procedure(그리고 OmniScript formula/aggregate) 전반에서 값을 평가·조작하는 공유 수식 라이브러리 — 연산자·데이터 타입 + 7개 카테고리 54개 함수 전수 레퍼런스.

---

## 개요

OmniStudio 수식(formula)은 **연산자(operators)**, **데이터 타입(data types)**, **함수(functions)** 세 요소로 값을 표현하고 조작한다. 함수는 조건 연산, 숫자·날짜/시간·문자열·리스트·JSON 객체 처리, 쿼리·커스텀 함수 호출을 수행한다.

**수식을 쓰는 곳:**
- Data Mapper (DataRaptor)의 formula 필드
- Integration Procedure의 **Set Values** action, filter, formula
- OmniScript의 **Set Values** / **Aggregate** / formula element

> ⚠️ **소관 분리:** 이 노트의 연산자·데이터 타입 표는 **Data Mapper·Integration Procedure 수식** 기준이다(Summer '25 업데이트 반영). OmniScript formula/aggregate 전용 연산자·데이터 타입은 소스가 별도 페이지("Create a Formula or Aggregate in an Omniscript")로 분리하며, 본 노트 범위 밖이다. 대부분의 함수는 세 컨텍스트에서 공유되나, `SORTBY`처럼 **Data Mappers only**로 표시된 것은 각 함수 항목에 명시했다.

**표기법(notation):**
- 함수: 이름은 **모두 대문자**로 입력해야 한다(`Sqrt(4)`는 "not a Function or Operator" 오류). 시그니처는 `NAME(param, param...)` 형식.
- `param...` = 콤마로 구분된 하나 이상의 값(가변 인자).
- 노드 참조: `Contact` 또는 `%Contact%`(merge field). 경로는 콜론으로 — `Account:Cases:Case1:CreatedDate`.
- 한 formula는 **단일 operation**만 포함할 수 있다(중첩 함수·연산자는 가능, 독립 연산 2개는 불가). 줄바꿈은 단일 operation 내에서만 허용.

**엔진 특성:** OmniStudio 엔진은 loosely typed다. 결과 타입이 명확하면 자동 형 변환(type coercion)한다 — 문자열과 숫자를 concat하면 숫자를 문자열로 변환. 오류 시 `{}`(빈 중괄호)를 반환한다.

---

## Conditional Functions (조건 함수 — 3)

| 함수 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| **IF** | `IF(expression, trueResult, falseResult)` | Any | expression이 true면 trueResult, 아니면 falseResult 반환. |
| **ISBLANK** | `ISBLANK(expression)` | Boolean | expression이 blank/empty면 true, 아니면 false. |
| **ISNOTBLANK** | `ISNOTBLANK(expression)` | Boolean | expression이 blank/empty가 **아니면** true, 아니면 false. |

> [!warning] **IF 부작용 주의 (원문 Important):** true·false 두 분기가 **항상 모두 평가되며** false 분기의 결과를 반환한다. 어느 분기든 side effect가 있는 연산(InvokeIP, DML, callout 등)을 포함하면, 조건이 false여도 **true 분기의 액션이 실행될 수 있다.**

```
// 원문 예시 — Data by Zero 회피
IF(Amount > 0, 1 / IF(Amount > 0, Amount, 1), 0)
   // Amount=2 → 0.5 · Amount=0 → 0
```

```
// 원문 예시 — 문자열/날짜 비교
IF(("abc" LIKE "a"), "true", "false")   → "true"
IF(InputDate < "2000-01-01", "20th Century", "21st Century")   // "1999-07-01" → "20th Century"
```

- `ISBLANK("")` → true · `ISBLANK(())` → true · `ISBLANK([])` → true · JSON `%EmptyList%`([]) → true
- `ISNOTBLANK('Hello world')` → true · `ISNOTBLANK(("a","b"))` → true · `ISNOTBLANK([1,2])` → true

---

## Mathematical Functions (수학 함수 — 3)

| 함수 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| **ABS** | `ABS(expression)` | Number | 숫자 표현식의 절대값 반환. |
| **ROUND** | `ROUND(expression, precision, direction)` | Number | 숫자를 지정 정밀도로 올림/내림. precision·direction은 optional. |
| **SQRT** | `SQRT(expression)` | Number | 음이 아닌 숫자의 제곱근 반환. |

**ROUND** — `precision`은 소수 자릿수(음수·소수 금지, 0=정수, 기본 2자리). `direction` 지정 시 `precision`도 반드시 지정. `direction` 상수:

| 상수 | 동작 |
|---|---|
| `CEILING` | 최하위 자리 올림 |
| `DOWN` | 최하위 자리 내림(오른쪽 숫자 무관) |
| `FLOOR` | 최하위 자리 내림 |
| `HALF_DOWN` | 오른쪽 숫자가 5 이하면 내림 |
| `HALF_EVEN` | 오른쪽이 5면 가장 가까운 짝수로 올림/내림 |
| `HALF_UP` | 오른쪽 숫자가 5 이상이면 올림 |
| `UP` | 최하위 자리 올림(오른쪽 숫자 무관) |

```
// 원문 예시
ROUND(4.115)              → 4.12   (precision·direction 없음, 기본 2자리)
ROUND(4.115, 0)           → 4
ROUND(2.119, 2, DOWN)     → 2.11
ROUND(2.55, 1, CEILING)   → 2.6
ROUND(2.225, 2, HALF_EVEN)→ 2.22
```

- `ABS(-4.50)` → 4.5 · `ABS(2 - (2 * 3))` → 4
- `SQRT(3 * 12)` → 6 · `SQRT(2.5)` → 1.5811388300841898 · `SQRT(-4)` → `{}` (오류: 음수)

---

## Date and Time Functions (날짜·시간 함수 — 20)

날짜는 Day.js 형식 문자열로 지정하며 single/double 따옴표로 감싼다. 날짜와 시간을 함께 지정할 때 `"YYYY-MM-DD"` 형식은 입력 시간을 보존하고, `"MM/DD/YYYY"` 형식은 시간을 00:00:00으로 리셋한다(ADDDAY/ADDMONTH/ADDYEAR).

| 함수 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| **ADDDAY** | `ADDDAY(date, days)` | Datetime | date에 days일을 더한 날짜/시간(음수면 빼기). |
| **ADDMONTH** | `ADDMONTH(date, months)` | Datetime | date에 months개월을 더한 날짜/시간(음수면 빼기). |
| **ADDYEAR** | `ADDYEAR(date, years)` | Datetime | date에 years년을 더한 날짜/시간(음수면 빼기). |
| **AGE** | `AGE(birthDate)` | Integer | 지정 출생일 기준 만 나이(년). |
| **AGEON** | `AGEON(birthDate, date)` | Integer | 지정 date 시점의 만 나이(년). 날짜만 사용(시간 무시), 1년 미만/이전이면 0. |
| **DATEDIFF** | `DATEDIFF(firstDate, secondDate)` | Integer | 두 날짜 간 일수 차(second − first). first가 크면 음수. 시간·타임존 포함 계산. |
| **DATETIMETOUNIX** | `DATETIMETOUNIX(datetime)` | Integer | 지정 날짜/시간의 UNIX time **밀리초** 수. |
| **DAY** | `DAY(date)` | Integer | 지정 날짜의 '일(day)' 정수값. |
| **EOM** | `EOM(date)` | Datetime | 지정 날짜가 속한 달의 마지막 날 날짜/시간. |
| **FORMATDATETIME** | `FORMATDATETIME(datetime, format, timezone)` | String | 지정 format·timezone 문자열로 날짜/시간 반환. timezone 지정 시 format 필수. |
| **FORMATDATETIMEGMT** | `FORMATDATETIMEGMT(datetime, timezone, format)` | String | GMT 타임존 기준으로 지정 format 문자열 반환. format 지정 시 timezone 필수. |
| **HOUR** | `HOUR(time)` | Integer | 지정 시간의 '시(hour)' 정수값. |
| **MINUTE** | `MINUTE(time)` | Integer | 지정 시간의 '분(minute)' 정수값. |
| **MONTH** | `MONTH(date)` | Integer | 지정 날짜의 '월(month)' 정수값. |
| **NOW** | `NOW(format)` | Datetime | 현재 날짜/시간을 지정 format으로. 기본 UTC(GMT). format optional. |
| **SECOND** | `SECOND(time)` | Integer | 지정 시간의 '초(second)' 정수값. |
| **TIMEDIFF** | `TIMEDIFF(firstTime, secondTime)` | Integer | 두 시간 간 **밀리초** 차(first − second). second가 크면 음수. |
| **TODAY** | `TODAY()` | Datetime | 현재 날짜("YYYY-MM-DD"). 기본 UTC(GMT). 파라미터 없음. |
| **UNIXTODATETIME** | `UNIXTODATETIME(timestamp)` | Datetime | UNIX time(초 또는 밀리초)을 날짜/시간으로. |
| **YEAR** | `YEAR(date)` | Integer | 지정 날짜의 '연(year)' 정수값. |

> **NOW / TODAY 타임존:** 기본 반환은 UTC(GMT). 사용자/조직의 타임존을 적용하려면 `$Vlocity.NOW` 환경 변수를 사용한다. `FORMATDATETIME`/`NOW`의 format은 Java `SimpleDateFormat` 표기, `datetime` 입력은 Day.js 형식.

```
// 원문 예시
ADDDAY("2025-01-01", 31)           → "2025-02-01T00:00:00.000Z"
ADDDAY("2025-01-01T12:00:00Z", 31) → "2025-02-01T12:00:00.000Z"   // YYYY-MM-DD는 시간 보존
ADDMONTH("2025-01-25T16:35:30Z", 15) → "2026-04-25T16:35:30.000Z"
AGE("2002-02-15")                  → 23
AGEON("2002-02-15", "2030-02-28T16:35:30Z") → 28
DATEDIFF("02/01/2000", "2001-02-01")        → 366   (second − first)
DATETIMETOUNIX("2002-02-01T16:35:30")       → 1012581330000
EOM("2024-02-01")                  → "2024-02-29T00:00:00.000Z"
FORMATDATETIME("01/31/2025T12:00:00", "yyyy-MM-dd'T'HH:mm:ssZ", "America/New_York")
                                   → "2025-01-31T07:00:00-0500"
NOW("yyyy-MM-dd'T'HH:mm:ss")       → "2025-03-08T22:10:42"
TIMEDIFF("16:35:30", "08:00:15")   → 30915000
TODAY()                            → "2025-01-15"
CONCAT(YEAR(ADDYEAR(TODAY(), 1)), "-01-01")  → "2026-01-01"   // 함수 조합
UNIXTODATETIME(1012581330)         → "2002-02-01T16:35:30.000Z"
```

---

## String Functions (문자열 함수 — 8)

문자열은 single/double 따옴표로 감싼다. 연산자·대부분 함수의 비교는 case-insensitive지만, **string 함수의 검색/비교는 case-sensitive**다(MAXSTRING·SPLIT·STRINGINDEXOF·SUBSTRING).

| 함수 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| **BASE64ENCODE** | `BASE64ENCODE(data)` | String | 입력값을 Base64 형식으로 인코딩. null·빈 문자열 불가. |
| **CONCAT** | `CONCAT(string...)` | String | 둘 이상의 문자열을 하나로 연결. null·빈 문자열은 무시(단독 입력 불가). |
| **JOIN** | `JOIN(string..., token)` | String | 문자열들을 token으로 구분해 연결. |
| **MAXSTRING** | `MAXSTRING(string...)` | String | 둘 이상 문자열 중 사전식(lexicographical)으로 **마지막** 문자열(case-sensitive). |
| **SPLIT** | `SPLIT(string, token)` | String[] | token(Java regex 패턴) 위치마다 문자열을 분할해 배열 반환. |
| **STRINGINDEXOF** | `STRINGINDEXOF(string, substring)` | Integer | 문자열 내 substring의 시작 인덱스(첫 문자=0, 없으면 −1, case-sensitive). |
| **SUBSTRING** | `SUBSTRING(string, startIndex, endIndex)` | String | start/end 인덱스 기반 부분 문자열. 인덱스는 정수 또는 문자열 가능. |
| **TOSTRING** | `TOSTRING(data)` | String | 입력 데이터를 문자열로 변환. null·빈 문자열 불가. |

> **SUBSTRING 인덱스 규칙:** 첫 문자 위치=0, startIndex는 inclusive, endIndex는 exclusive. 인덱스로 단일 문자를 주면 그 문자의 첫 등장 위치를, 문자열을 주면 그 문자열의 첫 등장 첫 문자 위치를 사용(endIndex는 −1). start를 생략하면 0(이 경우 end도 생략), end 지정 시 start 필수. **SPLIT token**은 Java regex — `.` `*` `+` `?` `|` `(` `)` `[` `]` `{` `}` `^` `$` 및 백슬래시는 특수문자이므로, 리터럴로 쓰려면 앞에 백슬래시를 붙여 escape한다(예: 마침표는 `\.`).

```
// 원문 예시
BASE64ENCODE("Encode this string.")  → "RW5jb2RlIHRoaXMgc3RyaW5nLg=="
CONCAT("AGE", ": ", 23)               → "AGE: 23"
JOIN(NumericArray, " / ")             → "1 / 2 / 3 / 4"   // NumericArray=[1,2,3,4]
MAXSTRING("Amy", "Ziggy", "Michael")  → "Ziggy"
MAXSTRING("A", "b", "C")              → "b"   // case-sensitive: 소문자 b가 최대
SPLIT("Anne Marie Gupta", " ")        → [ "Anne", "Marie", "Gupta" ]
STRINGINDEXOF("This is the test string.", "test")  → 12
STRINGINDEXOF("This is the test string.", "testy") → -1
SUBSTRING("The string.", 4, 10)       → "string"
SUBSTRING("The string.", "r", ".")    → "ring"   // 문자 인덱스
TOSTRING(3.0)                         → "3.0"
TOSTRING({ "key": "value" })          → "key, value"   // ≠ SERIALIZE 결과
```

---

## List and Array Functions (리스트·배열 함수 — 11)

리스트(List)는 `()`로 감싼 콤마 구분 익명 시리즈, 배열(Array)은 `[]`로 감싸며 named 또는 anonymous. **anonymous array = JSON list**. 여러 함수(FILTER·LISTMERGE·LISTMERGEPRIMARY·SERIALIZE·SORTBY·커스텀 FUNCTION)는 입력으로 JSON list를 요구하므로 `LIST()`로 감싸 전달한다.

| 함수 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| **AVG** | `AVG(list)` | Number | 숫자 리스트/JSON 배열의 평균. null도 분모에 포함되어 평균을 낮춘다. |
| **FILTER** | `FILTER(LIST(list), condition)` | JSON list | JSON 객체 리스트를 condition으로 필터링(문자열 매칭 case-insensitive). |
| **LIST** | `LIST(expression)` | JSON list | 리스트 또는 named JSON 배열을 anonymous JSON 배열로 변환. |
| **LISTMERGE** | `LISTMERGE(mergeKey..., LIST(list)...)` | JSON list | 둘 이상 JSON 리스트를 mergeKey 일치로 병합. 모든 노드·키 결합(mergeKey 매칭 case-insensitive). |
| **LISTMERGEPRIMARY** | `LISTMERGEPRIMARY(mergeKey..., LIST(list)...)` | JSON list | **첫(primary) 리스트** 노드를 다른 리스트 데이터로 증강. primary에 있는 노드만 결과 포함. |
| **LISTSIZE** | `LISTSIZE(list)` | Number | 리스트/JSON 배열의 항목 수. 빈 배열 테스트는 ISBLANK 사용. |
| **MAPTOLIST** | `MAPTOLIST(jsonObject)` | JSON list | JSON 객체(또는 객체 계층)를 JSON 리스트로 변환. |
| **MAX** | `MAX(list)` | Number | 숫자 리스트/JSON 배열의 최댓값. |
| **MIN** | `MIN(list)` | Number | 숫자 리스트/JSON 배열의 최솟값. |
| **SORTBY** | `SORTBY(LIST(list), key..., [:DSC])` | JSON list | JSON 객체 리스트를 지정 key로 정렬. `'[:DSC]'`면 내림차순(기본 오름차순). **Data Mappers only.** |
| **SUM** | `SUM(list)` | Number | 숫자 리스트/JSON 배열의 합. |

> **LISTMERGE vs LISTMERGEPRIMARY:** LISTMERGE는 **모든** 리스트의 노드를 결합(합집합적)한다. LISTMERGEPRIMARY는 **primary(첫) 리스트에 존재하는 노드만** 결과에 남기고 나머지 리스트의 데이터로 그 노드를 증강한다(primary에 없는 뒤 리스트의 노드는 제외). 두 함수 모두 동일 mergeKey에 다른 값이 있으면 뒤 노드 값이 앞 값을 덮어쓴다. **LISTSIZE 주의:** 빈 배열 `[]`은 LISTSIZE가 1을 반환할 수 있으므로, 진짜 0을 얻으려면 `IF(ISBLANK(x), 0, LISTSIZE(x))` 패턴을 쓴다.

```
// 원문 예시
AVG(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)  → 5.5
SUM(List:Item)                       → 13.5   // List:Item = 3.5, 4.25, 5.75
MAX(List:Item) → 5 · MIN(List:Item) → 3
LISTSIZE(6, 7, 8, 9, 10)             → 5
IF(ISBLANK(EmptyList), 0, LISTSIZE(EmptyList))  → 0
```

```
// 원문 예시 — FILTER
FILTER(LIST(NameList), 'LastName == "Xavier"')
// → LastName이 "Xavier"인 객체만 담은 JSON 배열 반환
// 변수 사용: FILTER(LIST(NameList), 'LastName == "' + FindName + '"')
```

```
// 원문 예시 — LISTMERGE ("id" 키로 3개 리스트 병합)
LISTMERGE("id", LIST(ContactNames), LIST(ContactAddresses), LIST(ContactBirthdates))
// 각 id별로 name·address·birthdate 키가 하나의 객체로 합쳐진 리스트
```

```
// 원문 예시 — SORTBY (LastName, FirstName 오름차순 / 내림차순)
SORTBY(LIST(NameList), 'LastName', 'FirstName')
SORTBY(LIST(NameList), 'LastName', 'FirstName', '[:DSC]')
```

---

## JSON Object Functions (JSON 객체 함수 — 4)

| 함수 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| **DESERIALIZE** | `DESERIALIZE(jsonString)` | JSON object | JSON 문자열을 JSON 객체 구조로 변환. |
| **RESERIALIZE** | `RESERIALIZE(jsonString)` | JSON string | 이미 직렬화된 JSON 문자열을 재직렬화. `DESERIALIZE(SERIALIZE())`와 동등. |
| **SERIALIZE** | `SERIALIZE(jsonObject)` | JSON string | JSON 객체를 JSON 문자열로 변환. JSON 배열은 `LIST()`로 전달. |
| **VALUELOOKUP** | `VALUELOOKUP(startNode, node...)` | String | JSON 객체 계층 임의 깊이의 노드 값을 동적으로 반환. |

> **RESERIALIZE 용도:** 제네릭 `Map<String, Object>` 포맷으로 변환하므로, remote action에서 **Apex 클래스 출력을 Data Mapper·Integration Procedure가 받을 수 있는 형태로 변환**할 때 유용. **SERIALIZE ≠ TOSTRING** — 결과 형식이 다르다(SERIALIZE는 복원 가능한 JSON 문자열).

```
// 원문 예시
SERIALIZE(%Contact%)   → "{\"LastName\":\"Edison\",\"MiddleName\":\"Alva\",\"FirstName\":\"Thomas\"}"
SERIALIZE(LIST(%Contacts%))  // JSON 배열은 LIST로 감싸 직렬화
DESERIALIZE(%SerializedContact%)  // 문자열 → JSON 객체 구조
```

```
// 원문 예시 — VALUELOOKUP (startNode + 노드 경로)
VALUELOOKUP(Contact, GetNameGroup, GetLastNameField)  → "Edison"
VALUELOOKUP(Contact:Name, GetLastNameField)           → "Edison"   // 동등
VALUELOOKUP(AccountList:CaseList:Case2, GetNextCase)  → "Case3"    // JSON 배열 탐색
```

---

## Invocation Functions (호출 함수 — 5)

| 함수 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| **COUNTQUERY** | `COUNTQUERY(query)` | Integer | SOQL 쿼리 실행 후 매칭 행 **수** 반환. 단일 컬럼(필드)만 조회 가능. |
| **FUNCTION** | `FUNCTION(class, method, input...)` | Any | Apex 클래스 메서드로 정의된 커스텀 함수 실행. class는 `Callable` 인터페이스 구현 필수. |
| **GENERATEGLOBALKEY** | `GENERATEGLOBALKEY(prefix)` | String | data pack의 Id로 쓸 global key 생성. prefix optional(하이픈으로 접합). |
| **QUERY** | `QUERY(query)` | JSON list | SOQL 쿼리 실행 후 결과를 JSON 리스트로 반환. 단일 컬럼만 조회 가능. |
| **GLOBALAUTONUMBER** | `GLOBALAUTONUMBER("GlobalAutoNumber")` / `GLOBALAUTONUMBER("Name")` | String | Omni Global Auto Number 페이지 설정에 따라 고유 번호 생성. |

> **QUERY / COUNTQUERY WHERE 절:** WHERE 절에 문자열을 직접 넣거나 `'{0}'`로 추가 전달값(문자열·JSON 키·표현식)을 참조할 수 있다. QUERY 결과 크기는 먼저 `ISBLANK`로 빈 리스트 여부를 확인한 뒤 `LISTSIZE`로 구한다(빈 리스트는 LISTSIZE가 1 반환). 매칭 행 수 자체는 `COUNTQUERY`가 반환. **FUNCTION**: 리스트/JSON 배열을 input으로 넘길 땐 `LIST()`로 감싼다. **GLOBALAUTONUMBER**: 값 없이 호출하면 이름이 자동으로 `GlobalAutoNumber`로 설정되며, 해당 이름 데이터가 없으면 오류.

```
// 원문 예시
COUNTQUERY("SELECT Name FROM Account WHERE BillingState = 'CA'")  → 2
QUERY("SELECT Name FROM Account WHERE BillingState LIKE '{0}'", %InputStateWest%)
                                        → [ "GenePoint", "Pyramid Construction" ]
FUNCTION('MyCustomFunctions', 'formatPhoneNumber', 1234567890)   → "(123) 456-7890"
FUNCTION('MyCustomFunctions', 'convert', LIST("abc","def","ghi"), 'Item')  // 리스트는 LIST()
GENERATEGLOBALKEY()       → "15c4ec2d-be7a-4f54-b342-652fdf159f30"
GENERATEGLOBALKEY("SUB")  → "SUB-f72bd2ca-a03b-48e3-af30-485efb4fa4d9"
GLOBALAUTONUMBER("Loan Application Number")  → "LI-6298525"
```

> 커스텀 함수 Apex 클래스 작성은 소스의 "Sample Apex Code for Custom Functions" 참조(세 메서드 예제 클래스). 클래스는 `Callable` 인터페이스를 구현해야 한다.

---

## 연산자 (Operators)

> Data Mapper·Integration Procedure 수식 기준(**Summer '25 업데이트**: `=`는 assignment가 아닌 equality 연산자 · 모든 문자열 비교는 case-insensitive여서 `==`·`=`·`~=`가 동일 결과 · `NOT` 논리 보수 연산자 문서화 추가 · `%` remainder 연산자 문서에서 제거). OmniScript 수식 연산자는 별도 페이지 소관.

### Logical (논리) — true/false 반환, NULL 불허·NULL 반환 없음

| 연산자 | 구문 | 설명 |
|---|---|---|
| `&&` / `AND` | `x && y` / `x AND y` | AND. x·y 둘 다 true면 true, 아니면 false. |
| `\|\|` / `OR` | `x \|\| y` / `x OR y` | OR. x·y 둘 다 false면 false, 아니면 true. |
| `NOT` | `NOT(x)` / `NOT(x == y)` | 논리 보수. Boolean 값/표현식을 반전(true↔false). |

### Comparison (비교) — true/false 반환, 숫자 기반·문자열은 case-insensitive/lexicographical

| 연산자 | 구문 | 설명 |
|---|---|---|
| `>` | `x > y` | 초과. x가 y보다 크면 true. |
| `>=` | `x >= y` | 이상. x가 y 이상이면 true. |
| `<` | `x < y` | 미만. x가 y보다 작으면 true. |
| `<=` | `x <= y` | 이하. x가 y 이하면 true. |
| `==` / `=` | `x == y` / `x = y` | 동등(equality). x가 y와 같으면 true. |
| `!=` / `<>` | `x != y` / `x <> y` | 부등(inequality). x가 y와 다르면 true. |

> 비교 연산자는 날짜·시간을 **문자열로 취급**하므로 날짜/시간 비교에 의존하지 말 것.

### Mathematical (수학) — 숫자 반환(한 피연산자라도 소수면 결과는 소수)

| 연산자 | 구문 | 설명 |
|---|---|---|
| `+` | `x + y` | 덧셈. |
| `-` | `x - y` | 뺄셈. |
| `*` | `x * y` | 곱셈. |
| `/` | `x / y` | 나눗셈. 분수 결과면 소수값. |
| `^` | `x ^ y` | 거듭제곱. 예: `2 ^ 3` → 8. |

### String (문자열) — true/false 반환, NULL 불허·NULL 반환 없음

| 연산자 | 구문 | 설명 |
|---|---|---|
| `LIKE` | `x LIKE y` | case-insensitive 부분문자열. y가 x의 substring이면 true. `"ABC" LIKE "a"` → true. |
| `NOTLIKE` | `x NOTLIKE y` | case-insensitive 부분문자열 보수. y가 x의 substring이 아니면 true. `"ABC" NOTLIKE "a"` → false. |
| `~=` | `x ~= y` | case-insensitive 문자열 동등. 대소문자 무시하고 같으면 true. `"ABC" ~= "abc"` → true. (숫자 불가) |

### Precedence (우선순위) — `( )`

`( )`는 precedence 연산자로 감싼 표현식의 우선순위를 높인다(중첩 가능).

**우선순위 표(전수, 낮은 숫자 = 높은 우선순위, 같은 행은 좌→우 평가):**

| 우선순위 | 연산자 | 설명 |
|---|---|---|
| 1 | `( )` | Precedence operator |
| 2 | `NOT` | Logical complement operator |
| 3 | `^` | Exponential operator |
| 4 | `*  /` | Multiplication and division |
| 5 | `+  -` | Addition and subtraction |
| 6 | `>  >=  <  <=` | Greater-than / less-than comparison |
| 7 | `==  =  !=  <>` | Equality and inequality comparison |
| 8 | `LIKE  NOTLIKE  ~=` | String comparison |
| 9 | `&&  AND` | AND logical |
| 10 | `\|\|  OR` | OR logical |

---

## 데이터 타입 & 상수

OmniStudio 엔진은 loosely typed이며 결과 타입이 명확할 때 type coercion을 수행한다. 예: `CONCAT("abc", ' ', 123)` 및 `"abc" + ' ' + 123` → `"abc 123"`. 그러나 알파벳+숫자 혼합에 `-` `*` `/`를 쓰면 오류 `{}`를 반환한다.

### 데이터 타입 (7)

| 데이터 타입 | 예시 | 설명 |
|---|---|---|
| **Boolean** | `true`, `false` | 논리 표현식용 참/거짓 값. |
| **Number** | `1`, `1.50`, `-1`, `-1.50` | 수치 값. 서브타입: Integer(정수), Float(제한된 크기·정밀도 소수), Double(Float의 2배 크기·정밀도 소수). |
| **Datetime** | `"2002-02-15 16:35:30"`, `"2002-02-15T16:35:30-0500"`, `"2002-02-15T00:00:00.000Z"` 등 | 날짜/시간 값. 서브타입: Date(날짜만, YYYY-MM-DD·MM/DD/YYYY), Time(시간만, `16:35:30`·`T16:35:00:500`). Day.js 형식, 따옴표 필수. 함수는 필요한 부분만 추출. |
| **String** | `"abc, DEF: 123."`, `'abc, DEF: 123.'` | 문자 시퀀스. lexicographical 정렬. single/double 따옴표 필수(짝만 맞으면 중첩 가능 `"a 'b' c"`). 연산자·대부분 함수는 case-insensitive, string 함수는 case-sensitive. |
| **List** | `1, 2, 3` · `("a", "b", "c")` | `()`로 감싸는 콤마 구분 값 시리즈(생략 가능). 어떤 타입도 가능·중첩 가능. **항상 anonymous(unnamed).** |
| **Array** | `[ 1, 2, 3 ]` · `[ { "Item": 1 } ]` | `[]`로 감싸는 콤마 구분 값. named 또는 anonymous. **anonymous array = JSON list.** |
| **JSON object** | `{ "Name": "Mike Smith" }` | key-value 쌍으로 정보를 캡슐화. 중첩·배열 그룹화 가능. 객체·key-value = JSON node. JSON string은 JSON object의 직렬화 형태. |

> **노드 참조:** 이름 또는 객체·키 경로로 참조하며 merge field(`%...%`) 사용 가능. `Contact`/`%Contact%` = 객체 전체 · `Contact:FirstName` = FirstName 값 · `Account:Cases:Case1:CreatedDate` = 배열 첫 객체의 CreatedDate 값.

### 상수 (Constants)

| 상수 | 예시(동등 표현) | 설명 |
|---|---|---|
| **TRUE** / True / true | `1 = 1`, `2 > 1`, `"abc" == "abc"` | true인 Boolean 상수. 다른 truthy 값도 있음 — `(1)`·`(1.5)`·`("abc")`는 IF에서 trueResult 반환. |
| **FALSE** / False / false | `2 = 1`, `2 < 1`, `"abc" == "def"` | false인 Boolean 상수. |
| **NULL** / Null / null | `IF((NULL), ...)` → falseResult | 미정의 값. null은 false로 resolve. 다수 연산자·함수가 null 불허. `()`·`(0)`·`([])`·따옴표 없는 비객체 문자열도 null(false)로 resolve. |

> 일부 함수는 자체 상수를 정의한다 — 예: `ROUND`의 방향 상수 `CEILING`·`DOWN`·`FLOOR`·`HALF_DOWN`·`HALF_EVEN`·`HALF_UP`·`UP`.

### Error Cases (오류)

함수·연산자는 기대한 값/파라미터가 없거나 타입이 틀리거나, 값·표현식을 평가할 수 없을 때 `{}`(빈 중괄호)를 반환한다.

| 오류 예 | 원인 |
|---|---|
| `SQRT(-4)` | 음수의 제곱근 불가. |
| `3 / 0` | 0으로 나눔. |
| `IF(([""]), ...)` | 빈 문자열 포함 배열 평가 불가. |
| `1.2 ~= 1.2` | `~=`는 숫자 아닌 문자열만 허용. |
| `BASE64ENCODE(null)`, `CONCAT("")`, `TOSTRING(null)`, `TOSTRING("")` | 이 string 함수들은 null·빈 값 불허. |
| `JOIN("The string.")`, `SPLIT("The string.")` | JOIN·SPLIT은 token 파라미터 필수. |
| `AGE("01 Jan 2025")`, `HOUR("21:00:56 +0900")` | 미지원 날짜 형식 / 공백 구분 타임존. |

중요한 문제(존재하지 않거나 오타난 함수/연산자명)에는 **오류 메시지**를 반환한다:

| 오류 예 | 메시지 |
|---|---|
| `Sqrt(4)` | "Sqrt is not a Function or Operator" — 함수명은 **모두 대문자**여야 함. |
| `IF(NO(true), ...)` | "NO is not a Function or Operator" — 의도한 연산자는 `NOT`. |
| `DAYOFWEEK("2025-01-01")` | "DAYOFWEEK is not a Function or Operator" — DAYOFWEEK는 **OmniScript 전용** 함수로 Data Mapper·IP 수식에서 사용 불가. |
| 독립 연산 2개 포함 | "IF is not a Function or Operator" — 한 formula는 단일 operation만. 중첩·줄바꿈은 가능하나 line-continuation(백슬래시)·termination(`;`) 문자로 독립 연산을 잇는 것은 불가. |

---

## 관련 노트
- [[OmniStudio 개요·오리엔테이션]]
- [[Data Mapper (DataRaptor)]]
- [[Integration Procedure]]
- [[OmniScript]]
- [[FlexCard]]
