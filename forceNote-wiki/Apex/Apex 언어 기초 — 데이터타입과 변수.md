---
tags: [Apex, 언어기초, 데이터타입, 변수, 연산자, primitive, collection, enum, 형변환]
source: salesforce_apex_developer_guide.pdf (v67.0 Summer '26, Writing Apex 챕터 — Data Types and Variables p.28-57)
created: 2026-06-17
aliases: [Apex Data Types, Apex Primitive Types, Apex Operators, Operator Precedence, Apex 데이터타입, Apex 연산자, 연산자 우선순위, 형 변환]
---

# Apex 언어 기초 — 데이터 타입과 변수

> Apex의 primitive·collection·enum 데이터 타입, 변수 선언·스코프·상수, 연산자·우선순위·형 변환 규칙 전수. (Apex Developer Guide v67.0 — Data Types and Variables)

---

## 개요

Apex의 모든 변수·표현식은 데이터 타입을 가진다. 타입 체크는 **컴파일 타임에 엄격히** 적용되며, 컴파일 예외는 라인·컬럼 번호와 함께 fault code로 반환된다.

데이터 타입 분류:

- **primitive** — Integer, Double, Long, Date, Datetime, String, ID, Boolean 등
- **sObject** — 제네릭 sObject 또는 특정 sObject (Account, Contact, MyCustomObject__c)
- **collection** — list(또는 array), set, map
- **enum** — 값들의 타입 지정 리스트
- **user-defined Apex 클래스 객체**
- **system-supplied Apex 클래스 객체**
- **Null** — null 상수, 어떤 변수에도 할당 가능
- 메서드는 위 타입들을 반환하거나, 값을 반환하지 않으면 **Void** 타입

> 컬렉션의 메서드(add/get/put 등) 시그니처 전체는 [[Apex 표준 클래스 레퍼런스]] 참조. 이 노트는 선언 문법·리터럴·언어 규칙만 다룬다.

---

## Primitive Data Types

Apex는 SOAP API와 동일한 primitive 타입을 사용한다(단 특정 경우 고정밀 Decimal 타입 사용). **모든 Apex 변수(클래스 멤버·메서드 변수)는 null로 초기화**되므로, 사용 전 적절한 값으로 초기화해야 한다(예: Boolean은 false로).

### 표준 primitive 12종 (전수)

| Data Type | 설명 |
|---|---|
| **Blob** | 단일 객체로 저장된 이진 데이터 컬렉션. `toString`/`valueOf` 메서드로 String과 상호 변환 가능. Web service 인자로 사용·document 본문 저장·attachment 전송 가능. Crypto Class 참조. Salesforce가 제공하는 Apex 클래스 메서드로만 Blob 조작 지원. |
| **Boolean** | true, false, null만 할당 가능. 예: `Boolean isWinner = true;` |
| **Date** | 특정 날짜를 나타내는 값. Datetime과 달리 시간 정보 없음. 항상 system static 메서드로 생성. Date 값에 Integer를 더하거나 뺄 수 있음(Date 반환). Integer의 덧셈·뺄셈만 Date와 동작하는 산술 함수. 두 개 이상의 Date 값으로 산술 불가 — 대신 Date 메서드 사용. `String.valueOf()`로 타임스탬프 없는 날짜 획득. Date 값에 암시적 string 변환 시 타임스탬프가 붙음. |
| **Datetime** | 특정 날짜·시간(타임스탬프 등). 항상 system static 메서드로 생성. Datetime 값에 Integer 또는 Double을 더하거나 뺄 수 있음(Date 반환). Integer·Double의 덧셈·뺄셈만 Datetime과 동작. 두 개 이상의 Datetime 값으로 산술 불가 — 대신 Datetime 메서드 사용. |
| **Decimal** | 소수점 포함 숫자. 임의 정밀도(arbitrary precision). Currency 필드는 자동으로 Decimal 타입. 소수 자릿수를 명시 안 하면 Decimal 생성 출처가 scale 결정. `setScale`로 scale 설정. (1) 쿼리의 일부로 생성 시 → 쿼리 반환 필드의 scale 기준. (2) String에서 생성 시 → 소수점 뒤 문자 수. (3) non-decimal 숫자에서 생성 시 → 먼저 String 변환 후 소수점 뒤 문자 수로 scale 설정. **Note:** 수치적으로 같지만 scale이 다른 두 Decimal(예 1.1, 1.10)은 일반적으로 hashcode가 다름 — Set·Map 키 사용 시 주의. |
| **Double** | 소수점 포함 64-bit 숫자. 최솟값 -2^63, 최댓값 2^63-1. 예: `Double pi = 3.14159;` / `Double e = 2.7182818284D;`. Double에 대한 과학적 표기법(e)은 미지원. |
| **ID** | 유효한 18자 Lightning Platform 레코드 식별자. 예: `ID id='00300000003T2PGAA0';`. 15자 값 설정 시 Apex가 18자 표현으로 변환. 모든 무효 ID는 런타임 예외로 거부. |
| **Integer** | 소수점 없는 32-bit 숫자. 최솟값 -2,147,483,648, 최댓값 2,147,483,647. 예: `Integer i = 1;` |
| **Long** | 소수점 없는 64-bit 숫자. 최솟값 -2^63, 최댓값 2^63-1. Integer 범위보다 넓은 값 필요 시 사용. 예: `Long l = 2147483648L;` |
| **Object** | Apex가 지원하는 모든 데이터 타입. primitive·user-defined 커스텀 클래스·제네릭 sObject·특정 sObject(Account 등) 지원. 모든 Apex 데이터 타입은 Object를 상속. 더 구체적 타입을 나타내는 object를 그 하위 타입으로 cast 가능. |
| **String** | 작은따옴표로 둘러싼 문자 집합. 예: `String s = 'The quick brown fox jumped over the lazy dog.';`. 크기·이스케이프·비교 규칙은 아래 별도 정리. |
| **Time** | 특정 시간을 나타내는 값. 항상 system static 메서드로 생성. Time Class 참조. |

### Object 캐스팅

`Object` 타입에 담긴 값은 더 구체적인 타입으로 캐스팅한다.

```apex
Object obj = 10;
// Cast the object to an integer.
Integer i = (Integer)obj;
System.assertEquals(10, i);
```

```apex
Object obj = new MyApexClass();
// Cast the object to the MyApexClass custom type.
MyApexClass mc = (MyApexClass)obj;
// Access a method on the user-defined class.
mc.someClassMethod();
```

### String 상세

- **크기:** 문자 수 제한은 heap size limit가 좌우.
- **빈 문자열·후행 공백:** sObject String 필드 값은 SOAP API 규칙 — 절대 empty 불가(null만), 선·후행 공백 불가. 반면 Apex의 String은 null·empty 가능하고 선·후행 공백 포함 가능.
- **이스케이프 시퀀스:** SOQL과 동일하게 다음을 지원한다.

```text
\b  backspace
\t  tab
\n  line feed
\f  form feed
\r  carriage return
\s  space
\"  double quote
\'  single quote
\\  backslash
```

- **비교 연산자:** Java와 달리 Apex String은 `==`, `!=`, `<`, `<=`, `>`, `>=` 사용 가능. SOQL 비교 의미론 사용 — context user 로케일 기준 collate, 대소문자 무시.
- **String 메서드:** Java처럼 표준 메서드로 조작.

### Multiline String

여러 줄 텍스트 블록은 세 개의 작은따옴표(`'''`) 뒤 즉시 새 줄로 시작하고, 세 개의 작은따옴표(`'''`)로 종료한다.

```apex
String multilineStr = '''
{
"Name" : "John Doe",
"Type" : "New Customer"
}''';
```

Multiline String 사용 규칙:

- **Line Breaks:** 줄바꿈은 자동으로 newline 시퀀스로 변환.
- **Whitespace:** 가장 왼쪽 non-whitespace 문자 앞 공백은 strip. 각 줄 후행 공백도 strip. 컴파일 시 whitespace stripping이 이스케이프 시퀀스 처리보다 먼저.
- 의도적 후행 공백은 줄 끝 `\s` 이스케이프로 생성.
- 백슬래시 concatenate 시퀀스(단일 backslash 문자)를 줄 끝에 두면 여러 줄을 이어붙이고 newline 삽입을 방지한다.
- regular Apex string과 달리 multiline은 이스케이프 안 한 작은따옴표(`'`) 지원. 단 종료 `'''` 바로 앞 작은따옴표는 escape 필요 — backslash + 작은따옴표 + 종료 `'''` 형태로 쓴다.
- **SOQL:** 변수에 저장된 multiline string은 SOQL/SOSL에서 사용 가능. 단 regular string 리터럴과 달리 multiline 리터럴은 SOQL/SOSL에서 bind expression 외엔 사용 불가.

### 비표준 primitive 2종

다음 두 타입은 **변수/메서드 타입으로 사용 불가**하며, system static 메서드에만 등장한다.

- **AnyType** — `valueOf` static 메서드가 AnyType sObject 필드를 표준 primitive로 변환. field history tracking 테이블의 sObject 필드 용도로만 Lightning Platform DB 내부에서 사용.
- **Currency** — `Currency.newInstance` static 메서드가 Currency 타입 리터럴 생성. SOQL/SOSL WHERE절에서 sObject currency 필드 필터링 용도로만 사용. 다른 Apex 타입에서 Currency 인스턴스화 불가.

### Versioned Behavior

- API 16.0+ 에서 currency 등 특정 타입에 고정밀 Decimal 사용.
- API 15.0+ 에서 필드에 너무 긴 String 할당 시 런타임 에러.

---

## Collections

컬렉션 항목 수에는 제한이 없다(단 heap size 일반 제한은 적용). 이 절은 **선언 문법·리터럴만** 다룬다 — 메서드(add/get/put/sort 등) 전체는 [[Apex 표준 클래스 레퍼런스]] 참조.

### Lists

인덱스로 구분되는 ordered collection. 요소는 모든 데이터 타입 가능(primitive, collection, sObject, user-defined, built-in Apex). 첫 요소 인덱스는 항상 0. 최대 7단계 중첩(총 8단계). 선언은 `List` 키워드 + `<>` 안에 타입.

```apex
// Create an empty list of String
List<String> my_list = new List<String>();
// Create a nested list
List<List<Set<Integer>>> my_list_2 = new List<List<Set<Integer>>>();
```

**Array 표기법 (1차원 list):** 데이터 타입명 뒤 `[]`로 선언 가능.

```apex
String[] colors = new List<String>();
```

다음 두 문장은 동등하다.

```apex
List<String> colors = new String[1];
String[] colors = new String[1];
```

요소 참조: `colors[0] = 'Green';`. List는 elastic(add 메서드로 증가 가능)하지만, 대괄호로 추가 시 array처럼 동작해 선언 크기 초과 불가. 모든 list는 null로 초기화. 리터럴 표기로 값·메모리를 할당할 수 있다.

| Example | Description |
|---|---|
| `List<Integer> ints = new Integer[0];` | 요소 0개의 size-zero Integer list 정의 |
| `List<Integer> ints = new Integer[6];` | Integer 6개 메모리 할당된 Integer list 정의 |

**List Sorting:** `List.sort` 메서드. primitive(예 string)는 오름차순. 커스텀 타입은 `Comparable` 인터페이스 구현 시 정렬 가능, 또는 `Comparator` 구현 클래스를 `List.sort` 파라미터로 전달한다. (정렬 인터페이스 상세는 [[Comparator 인터페이스]] 참조.)

```apex
List<String> colors = new List<String>{
'Yellow',
'Red',
'Green'};
colors.sort();
System.assertEquals('Green', colors.get(0));
System.assertEquals('Red', colors.get(1));
System.assertEquals('Yellow', colors.get(2));
```

### Sets

중복 없는 unordered collection. 요소는 모든 데이터 타입 가능. 최대 7단계 중첩(총 8단계). 선언은 `Set` 키워드 + `<>` 안에 타입.

```apex
Set<String> myStringSet = new Set<String>();
```

```apex
// Defines a new set with two elements
Set<String> set1 = new Set<String>{'New York', 'Paris'};
```

**Set 제한사항:** Java와 달리 알고리즘(HashSet/TreeSet) 참조 불필요 — 모든 set은 hash 구조. 특정 인덱스 접근 불가, iterate만 가능. iteration 순서는 deterministic.

### Maps

각 unique 키가 단일 값에 매핑되는 key-value pair collection. 키·값은 모든 데이터 타입 가능. 키는 최대 7단계 중첩(총 8단계). 선언은 `Map` 키워드 + `<>` 안에 키·값 타입.

```apex
Map<String, String> country_currencies = new Map<String, String>();
Map<ID, Set<String>> m = new Map<ID, Set<String>>();
```

curly brace로 선언 시 채우기 — 키 먼저, `=>`로 값 지정한다.

```apex
Map<String, String> MyStrings = new Map<String, String>{'a' => 'b', 'c' => 'd'.toUpperCase()};
```

**Map Considerations:** 알고리즘(HashMap/TreeMap) 참조 불필요 — hash 구조. iteration 순서 deterministic(단 키로 접근 권장). 키는 null 가능. 기존 키와 일치하는 항목 추가 시 덮어씀. String 키는 **case-sensitive**. user-defined 타입 키 uniqueness는 `equals`·`hashCode`로 결정. sObject 등 non-primitive 키는 필드 값 비교로 결정(sObject가 변경되면 동일 값에 더 이상 매핑 안 됨 — 주의).

**JSON 직렬화 가능한 Map 키 타입:** Boolean, Date, DateTime, Decimal, Double, Enum, Id, Integer, Long, String, Time.

### Parameterized Typing

Apex는 정적 타입 언어다. list·map·set은 parameterized — 구성 시 실제 타입으로 대체된다.

```apex
List<String> myList = new List<String>();
```

**Subtyping with Parameterized Lists:** T가 U의 subtype이면 `List<T>`는 `List<U>`의 subtype.

```apex
List<String> slst = new List<String> {'alpha', 'beta'};
List<Object> olst = slst;
```

---

## Enums

지정한 유한 식별자 집합 중 정확히 하나의 값을 취하는 추상 데이터 타입. 각 값은 distinct integer에 대응하지만 구현은 숨겨진다. **Java와 달리 enum 타입 자체엔 constructor 구문이 없다.**

```apex
public enum Season {WINTER, SPRING, SUMMER, FALL}
```

```apex
Season southernHemisphereSeason = Season.WINTER;
public Season getSouthernHemisphereSeason(Season northernHemisphereSeason) {
if (northernHemisphereSeason == Season.SUMMER) return southernHemisphereSeason;
//...
}
```

enum을 class로도 정의 가능하다(class 키워드 미사용).

```apex
public enum MyEnumClass { X, Y }
```

webservice 메서드는 enum을 시그니처로 사용 가능(WSDL에 enum·값 정의 포함).

### System-defined enums (전수)

- `System.StatusCode` — API error code 대응 (예 `StatusCode.CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY`, `StatusCode.INSUFFICIENT_ACCESS_ON_CROSS_REFERENCE_ENTITY`)
- `System.XmlTag` — webservice 결과 XML 파싱용 XML 태그 리스트 반환
- `System.ApplicationReadWriteMode` — org가 5 Minute Upgrade read-only 모드인지 표시
- `System.LoggingLevel` — `system.debug` 메서드 로그 레벨 지정
- `System.RoundingMode` — 수학 연산 rounding 동작 지정 (Decimal divide, Double round 등)
- `System.SoapType` — field describe result의 `getSoapType` 반환
- `System.DisplayType` — field describe result의 `getType` 반환
- `System.JSONToken` — JSON 파싱용
- `ApexPages.Severity` — Visualforce 메시지 severity 지정
- `Dom.XmlNodeType` — DOM document의 node 타입 지정

> **Note:** System-defined enums는 Web service 메서드에서 사용 불가. 모든 enum 값은 공통 메서드를 보유(Enum Methods 참조). enum 값에 user-defined 메서드 추가 불가. ([[System Namespace]]의 enum 멤버 상세는 해당 노트 참조.)

---

## Variables

Java 스타일 구문으로 로컬 변수를 선언한다.

```apex
Integer i = 0;
String str;
List<String> strList;
Set<String> s;
Map<ID, String> m;
```

복수 변수를 단일 문장에서 콤마로 구분해 선언·초기화한다.

```apex
Integer i, j, k;
```

### Variable Naming Rules

- 변수명 case-insensitive.
- 문자(A-Z, a-z)·숫자(0-9)·underscore(_)만. 공백·특수문자($, - 포함) 불가.
- 문자로 시작해야 함. 숫자나 underscore로 시작 불가.
- underscore로 끝날 수 없음.
- 연속 underscore(`_ _`) 불가.
- 예약어 사용 불가.
- 최대 255자.
- 변수명과 클래스/메서드명 공유는 비권장(허용은 됨).

### Null Variables and Initial Values

초기화 안 한 변수는 null이다. primitive 타입 변수에도 null 할당 가능.

```apex
Boolean x = null;
Decimal d;
```

null 변수에 instance 메서드를 호출하면 실패한다(예 NullPointerException).

```apex
Date d;
d.addDays(2);
```

```apex
Integer i = 0, j, k = 1;  // j는 null
Boolean b;                // b는 null
```

> **Note (pitfall):** 초기화 안 한 boolean이 false로 초기화된다고 가정하면 안 됨 — 다른 변수처럼 null이다.

### Variable Scope

블록 내 어디든 정의 가능하며, 그 지점부터 scope. Sub-block은 부모 블록에 이미 쓴 변수명을 재정의할 수 없으나, parallel block은 재사용 가능하다.

```apex
Integer i;
{
// Integer i;   // This declaration is not allowed
}
for (Integer j = 0; j < 10; j++);
for (Integer j = 0; j < 10; j++);
```

### Case Sensitivity

Apex는 case-insensitive(변수·메서드명, object·field명, SOQL/SOSL 모두). SOQL 필터링 의미론을 사용한다. 예: `values < 'm'` 필터 시 null 필드도 반환된다. 다음은 모두 true로 평가된다.

```apex
String s;
System.assert('a' == 'A');
System.assert(s < 'b');
System.assert(!(s > 'b'));
```

> **Note:** `s < 'b'`는 true지만 `'b'.compareTo(s)`는 에러다(문자를 null과 비교).

---

## Constants

초기화 후 값이 변하지 않는 변수. `final` 키워드로 정의한다. final은 최대 1회 할당(선언 시 또는 클래스 내 static initializer 메서드).

```apex
public class myCls {
static final Integer PRIVATE_INT_CONST = 200;
static final Integer PRIVATE_INT_CONST2;
public static Integer calculate() {
return 2 + 7;
}
static {
PRIVATE_INT_CONST2 = calculate();
}
}
```

---

## Expressions and Operators

### Expressions

변수·연산자·메서드 호출로 구성되며 단일 값으로 평가된다. 유형:

- literal 표현식 (예 `1 + 1`)
- 새 sObject/Apex object/list/set/map (`new Account(...)`, `new Integer[<n>]`, `new Account[]{<elements>}`, `new List<Account>()`, `new Set<String>{}`, `new Map<String, Integer>()`, `new myRenamingClass(...)`)
- L-value가 될 수 있는 값 (변수, 1차원 list 위치, sObject/Apex object 필드 참조 — 예 `Integer i`, `myList[3]`, `myContact.name`, `myRenamingClass.oldName`)
- L-value가 아닌 sObject 필드 참조 (list 내 sObject의 ID, 연관 child 레코드 집합)
- 대괄호로 둘러싼 SOQL/SOSL 쿼리 (예 `[SELECT Id, Name FROM Account WHERE Name ='Acme']`, `[SELECT COUNT() FROM Contact WHERE LastName ='Weissman']`, FIND...RETURNING)
- static/instance 메서드 호출 (`System.assert(true)`, `myRenamingClass.replaceNames()`, `changePoint(new Point(x, y))`)

### Expression Operators (전수표)

| Operator | Syntax | Description |
|---|---|---|
| `=` | `x = y` | Assignment (Right associative). y 값을 L-value x에 할당. x·y 데이터 타입 일치, null 불가. |
| `+=` | `x += y` | Addition assignment (Right assoc). y를 x 원래값에 더해 x에 재할당. x·y null 불가. |
| `*=` | `x *= y` | Multiplication assignment (Right assoc). x·y는 Integer/Double 또는 조합. null 불가. |
| `-=` | `x -= y` | Subtraction assignment (Right assoc). x·y는 Integer/Double 또는 조합. null 불가. |
| `/=` | `x /= y` | Division assignment (Right assoc). x·y는 Integer/Double 또는 조합. null 불가. |
| `\|=` | `x \|= y` | OR assignment (Right assoc). Boolean x·y 둘 다 false면 x는 false, 아니면 true. null 불가. |
| `&=` | `x &= y` | AND assignment (Right assoc). Boolean x·y 둘 다 true면 x는 true, 아니면 false. null 불가. |
| `<<=` | `x <<= y` | Bitwise shift left assignment. x의 각 비트를 y만큼 왼쪽 시프트(high-order 비트 손실, 새 right 비트 0), x에 재할당. |
| `>>=` | `x >>= y` | Bitwise shift right signed assignment. x의 각 비트를 y만큼 오른쪽 시프트(low-order 손실, 새 left 비트: y 양수면 0, 음수면 1), x에 재할당. |
| `>>>=` | `x >>>= y` | Bitwise shift right unsigned assignment. 모든 y 값에 대해 새 left 비트 0. x에 재할당. |
| `? :` | `x ? y : z` | Ternary (Right assoc). Boolean x가 true면 y, 아니면 z. x는 null 불가. |
| `&&` | `x && y` | AND logical (Left assoc). Boolean 둘 다 true면 true. `&&`가 `\|\|`보다 우선. short-circuit(x가 true일 때만 y 평가). null 불가. |
| `\|\|` | `x \|\| y` | OR logical (Left assoc). 둘 다 false면 false. `&&`가 우선. short-circuit(x가 false일 때만 y 평가). null 불가. |
| `==` | `x == y` | Equality. 값 같으면 true. Java와 달리 object **값** 동등성 비교(user-defined 타입 제외). String 비교 case-insensitive(context user 로케일). ID 비교 case-sensitive(15/18자 구분 안 함). user-defined 타입은 reference 비교(equals·hashCode 오버라이드로 변경 가능). sObject·배열은 모든 필드 deep check. record는 모든 필드 같아야 true. x·y는 literal null 가능. 결과는 절대 null 아님. SOQL/SOSL은 `=` 사용. |
| `===` | `x === y` | Exact equality. x·y가 메모리 정확히 같은 위치 참조 시 true. |
| `<` | `x < y` | Less than. x<y면 true. tri-state Boolean 미지원(결과 절대 null 아님). x/y가 null이고 Integer/Double/Date/Datetime이면 false. non-null String/ID는 항상 null보다 큼. ID 비교 시 같은 object 타입이어야 함(아니면 런타임 에러). ID-String 비교 시 String이 ID로 검증·취급. x·y Boolean 불가. String 비교 case-insensitive(로케일). |
| `>` | `x > y` | Greater than. (`<`와 동일 Note 적용) |
| `<=` | `x <= y` | Less than or equal. (동일 Note 적용) |
| `>=` | `x >= y` | Greater than or equal. (동일 Note 적용) |
| `!=` | `x != y` | Inequality. 값 다르면 true. String 비교 case-insensitive. Java와 달리 값 비교(user-defined 제외). sObject·배열 deep check. record는 한 필드라도 다르면 true. user-defined는 reference 비교(equals·hashCode 오버라이드 가능). x·y literal null 가능. 결과 절대 null 아님. |
| `!==` | `x !== y` | Exact inequality. 메모리 정확히 같은 위치 참조 안 하면 true. |
| `+` | `x + y` | Addition. Integer/Double 더함(Double 쓰면 Double). x=Date·y=Integer면 일수 증가한 새 Date. x=Datetime·y=Integer/Double이면 일수(소수부=하루 일부) 증가한 새 Date. x=String이고 y가 String/non-null이면 concat. |
| `-` | `x - y` | Subtraction. Integer/Double 뺌. x=Date·y=Integer면 일수 감소 Date. x=Datetime·y=Integer/Double이면 일수 감소 Date. |
| `*` | `x * y` | Multiplication. Integer/Double 곱(Double 쓰면 Double). |
| `/` | `x / y` | Division. Integer/Double 나눔(Double 쓰면 Double). |
| `!` | `!x` | Logical complement. Boolean true↔false 반전. |
| `-` | `-x` | Unary negation. Integer/Double에 -1 곱. `+`도 구문상 유효하나 수학적 효과 없음. |
| `++` | `x++` / `++x` | Increment. 숫자형 x에 1 더함. prefix(++x)는 증가 후 값, postfix(x++)는 증가 전 값. |
| `--` | `x--` / `--x` | Decrement. 숫자형 x에서 1 뺌. prefix(--x)는 감소 후, postfix(x--)는 감소 전. |
| `&` | `x & y` | Bitwise AND. 두 비트 모두 1이면 결과 비트 1. |
| `\|` | `x \| y` | Bitwise OR. 둘 중 하나 이상 1이면 1. |
| `^` | `x ^ y` | Bitwise exclusive OR. 정확히 하나만 1이면 1. |
| `^=` | `x ^= y` | Bitwise exclusive OR + 결과를 x에 할당. |
| `<<` | `x << y` | Bitwise shift left. high-order 손실, 새 right 0. |
| `>>` | `x >> y` | Bitwise shift right signed. low-order 손실, 새 left: y 양수 0/음수 1. |
| `>>>` | `x >>> y` | Bitwise shift right unsigned. 모든 y에 대해 새 left 0. |
| `~` | `~x` | Bitwise Not/Complement. 각 이진수 토글(0↔1). Boolean True↔False. |
| `()` | `(x)` | Parentheses. 표현식 x 우선순위 상승(먼저 평가). |
| `?.` | `x?.y` | Safe navigation. null 값 연산 short-circuit, NullPointerException 대신 null 반환. 좌변이 null이면 우변 미평가. |

### Safe Navigation Operator (`?.`)

모든 Apex 타입은 암시적으로 nullable이며 연산자가 반환한 null을 보유할 수 있다. method·variable·property 체이닝에 사용한다.

```apex
a?.b // Evaluates to: a == null ? null : a.b
```

```apex
a[x]?.aMethod().aField // Evaluates to null if a[x] == null
```

```apex
a[x].aMethod()?.aField
```

```apex
Integer x = anObject?.anIntegerField; // type Integer
```

```apex
// New code using the safe navigation operator
String profileUrl = user.getProfileUrl()?.toExternalForm();
```

```apex
// New code using the safe navigation operator
return [SELECT Name FROM Account WHERE Id = :accId]?.Name;
```

**Safe Navigation Operator Use-Cases:**

| Allowed use-case | Example | More information |
|---|---|---|
| Method or variable or parameter chains | `aObject?.aMethod();` | top-level statement로 사용 가능 |
| 괄호 사용 (cast 등) | `((T)a1?.b1)?.c1()` | 연산자가 첫 닫는 괄호까지 메서드 체인 skip. 괄호 뒤에 연산자 추가로 전체 보호. 잘못된 예: `((T)a1?.b1).c1()` (b1까지만 보호) |
| SObject chaining | `String s = contact.Account?.BillingCity;` | 관계가 null이면 null 평가 |
| SOQL Queries | `String s = [SELECT LastName FROM Contact]?.LastName;` | 쿼리가 객체 0개 반환 시 null 평가(이전엔 예외) |

**사용 불가 케이스 (컴파일 에러):**

- Types/static 표현식 dots: Namespaces, `{Namespace}.{Class}`, `Trigger.new`, `Flow.interview.{flowName}`, `{Type}.class`
- Static 변수 접근·메서드 호출·표현식: `AClass.AStaticMethodCall()`, `AClass.AStaticVariable`, `String.format('{0}', 'hello world')`, `Page.{pageName}`
- Assignable 표현식: `foo?.bar = 42;`, `++foo?.bar;`
- SOQL bind 표현식 (예 `WHERE Name = :X?.query`, `FIND :X?.query`)
- SObject scalar 필드의 `addError()`: `c.LastName?.addError(...)`

> **Note:** lookup·master-detail 필드를 포함하는 SObjects에서는 `addError()`와 함께 사용 가능.

### Null Coalescing Operator (`??`)

좌변이 null일 때 우변을 반환하는 binary 연산자 `a ?? b` — a가 null이 아니면 a, 아니면 b. **left-associative**. 좌변은 1회만 평가. 우변은 좌변이 null일 때만 평가. 피연산자 타입은 호환되어야 한다.

```apex
// Before
Integer notNullReturnValue = (anInteger != null) ? anInteger : 100;
// With ?? 
Integer notNullReturnValue = anInteger ?? 100;
```

연산자 우선순위 주의: `top ?? 100 - bottom ?? 0`은 `top ?? (100 - bottom ?? 0)`로 평가된다(`(top ?? 100) - (bottom ?? 0)`이 아님).

> **Warning:** 하나의 statement에서 multiple SOQL 쿼리와 `??`를 함께 사용하는 것은 비권장.

```apex
Account defaultAccount = new Account(name = 'Acme');
Account a = [SELECT Id FROM Account
WHERE Id = '001000000FAKEID'] ?? defaultAccount;
Assert.areEqual(defaultAccount, a);

string city = [Select BillingCity
From Account
Where Id = '001xx000000001oAAA']?.BillingCity;
System.debug('Matches count: ' + city?.countMatches('San Francisco') ?? 0 );
```

**Usage 제한:**

- assignment 좌변 사용 불가: `foo??bar = 42;`, `foo??bar++;`
- SOQL bind 표현식 미지원: `WHERE Name = :X??query`, `FIND :X??query`

### Operator Precedence (전수표 — 15단계)

| Precedence | Operators | Description |
|---|---|---|
| 1 | `{} () ++ --` | Grouping and prefix increments and decrements |
| 2 | `~ ! -x +x (type) new` | Unary operators, additive operators, type cast and object creation |
| 3 | `* /` | Multiplication and division |
| 4 | `+ -` | Addition and subtraction |
| 5 | `<< >> >>>` | Shift Operators |
| 6 | `< <= > >= instanceof` | Greater-than and less-than comparisons, reference tests |
| 7 | `== !=` | Comparisons: equal and not-equal |
| 8 | `&` | Bitwise AND |
| 9 | `^` | Bitwise XOR |
| 10 | `\|` | Bitwise OR |
| 11 | `&&` | Logical AND |
| 12 | `\|\|` | Logical OR |
| 13 | `??` | Null Coalescing |
| 14 | `?:` | Ternary |
| 15 | `= += -= *= /= &= <<= >>= >>>=` | Assignment operators |

### Comments

단일/다중 줄 주석을 지원한다. `//`(단일), `/* */`(다중). ApexDoc 형식 권장.

---

## Assignment Statements

변수에 값을 넣는 모든 statement. 두 형태가 있다.

- `[LValue] = [new_value_expression];`
- `[LValue] = [ inline_soql_query ];` (대괄호로 둘러싼 inline SOQL 쿼리를 우변에 둔다)

LValue 종류: 단순 변수, de-referenced list 요소(`ints[0] = 1;`), 편집 권한 있는 sObject 필드 참조.

```apex
Account a = new Account(Name = 'Acme', BillingCity = 'San Francisco');
insert a;
Contact c = new Contact(LastName = 'Roth', Account = a);
c.Account.Name = 'salesforce.com';
```

**Assignment은 항상 reference로 수행된다.**

```apex
Account a = new Account();
Account b;
Account[] c = new Account[]{};
a.Name = 'Acme';
b = a;
c.add(a);
System.assertEquals(b.Name, 'Acme');
System.assertEquals(c[0].Name, 'Acme');
```

유효한 assignment 연산자: `=`, `+=`, `*=`, `/=`, `|=`, `&=`, `++`, `--`.

---

## Rules of Conversion

일반적으로 명시적 변환이 필요하다(예 Integer→String은 `string.format`). 단 일부는 암시적으로 변환된다.

**숫자 타입 계층 (낮음→높음):** 1. Integer → 2. Long → 3. Double → 4. Decimal. 낮은 타입은 명시 변환 없이 높은 타입에 할당 가능하다. (Java와 달리 base interface number 없음, 암시적 object 변환 없음.)

**기타 암시 변환 규칙:**

- ID는 항상 String에 할당 가능.
- String은 ID에 할당 가능(런타임에 유효 ID 검증, 무효 시 예외).
- `instanceOf` 키워드로 string이 ID인지 항상 테스트 가능.

---

## Additional Considerations for Data Types

- **Data Types of Numeric Values:** 숫자는 기본 Integer. L 접미사→Long, .0→Double/Decimal. `Long d = 123;`는 123(Integer)을 암시적 Long으로 변환. Integer 최대 초과 시 컴파일 에러 → `Long d = 2147483648L;`.
- **Overflow/Underflow:** Apex는 예외를 던지지 않음. `Integer i = 2147483647 + 1;` → -2147483648. `Long MillsPerYear = 365 * 24 * 60 * 60 * 1000;`는 Integer 오버플로로 잘못된 결과 → `365L * 24L * 60L * 60L * 1000L` (= 31536000000L).
- **Loss of Fractions in Divisions:** Integer/Long 나눗셈은 소수부 제거 후 변환. `Double d = 5/3;` → 1.0. `Double d = 5.0/3.0;` → 1.6666666666666667.
- **Conversion of Date to Datetime:** 암시·명시 캐스팅 지원, 시간 컴포넌트는 0으로.

---

## 관련 노트

- [[Apex MOC]]
- [[Apex 언어 기초 — 제어 흐름과 클래스]]
- [[Apex 언어 기초 — 예외 처리와 예약어]]
- [[Apex 표준 클래스 레퍼런스]]
- [[Comparator 인터페이스]]
- [[System Namespace]]
