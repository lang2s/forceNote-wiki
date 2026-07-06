---
tags: [Apex, 언어기초, 예외처리, exception, try-catch, 커스텀예외, 예약어, reserved-keywords]
source: salesforce_apex_developer_guide.pdf (v67.0 Summer '26, Exceptions in Apex 인쇄 p.706-715 / Reserved Keywords 인쇄 p.817-818)
created: 2026-06-17
aliases: [Apex Exceptions, try catch finally, throw, Custom Exception, Apex Reserved Keywords, 예외 처리, 커스텀 예외, 예약어]
---

# Apex 언어 기초 — 예외 처리와 예약어

> try/catch/finally·throw·커스텀 예외 작성과 Apex 예약어 전수 목록. (Apex Developer Guide v67.0 — Exceptions in Apex + Reserved Keywords)

---

## 개요

Exceptions는 normal flow를 disrupt하는 errors·events다. **throw** statement로 예외를 생성하고, **try/catch/finally**로 우아하게 복구한다. 장점은 error handling 단순화 — 예외는 caller로 bubble up하며, finally로 한 곳에서 복구한다.

데이터 타입·연산자 기초는 [[Apex 언어 기초 — 데이터타입과 변수]], 클래스·상속(커스텀 예외 작성 기반)은 [[Apex 언어 기초 — 제어 흐름과 클래스]]를 참조한다.

### 예외 발생 시 동작 (What Happens When an Exception Occurs?)

- 코드 실행이 중단된다.
- 예외 전에 처리된 **DML은 rollback**(미커밋)된다.
- debug log에 기록된다.
- unhandled 예외는 Salesforce가 email을 발송한다.
- end user는 UI에 에러 메시지를 본다.

**Unhandled Exception Emails:** Apex stack trace·예외 메시지·org/user ID·org명·My Domain명을 포함한다. 기본적으로 failing 클래스/trigger의 LastModifiedBy 개발자에게 발송된다. Setup → Apex Exception Email로 설정하거나 ApexEmailNotification Tooling API로 설정 가능.

> **Note:** 동기/비동기 중복 예외는 첫 email만 발송(suppress). anonymous Apex·@AuraEnabled(Aura/LWC) 예외는 email 안 됨. application server당 시간당 10 email 제한.

---

## Throw·Try-Catch-Finally Statements

### Throw Statements

error를 신호하며 exception object를 제공한다.

```apex
throw exceptionObject;
```

### Try-Catch-Finally Statements

- **try** — 예외 발생 가능 코드 블록을 식별.
- **catch** — 특정 예외 타입 처리 블록. try당 0개 이상. 각 catch는 unique 예외 타입. 한 catch에서 잡히면 나머지는 미실행.
- **finally** — 항상 실행 보장(cleanup). try당 최대 1개. 예외 발생 여부·타입과 무관하게 실행.

**Syntax:**

```apex
try {
// Try block
code_block
} catch (exceptionType variableName) {
// Initial catch block.
code_block
} catch (Exception e) {
// Optional additional catch statement for other exception types.
// general 'Exception' type must be the last catch block.
code_block
} finally {
// Finally block.
code_block
}
```

try-catch:

```apex
try {
code_block
} catch (exceptionType variableName) {
code_block
}
// Optional additional catch blocks
```

try-finally:

```apex
try {
code_block
} finally {
code_block
}
```

skeleton:

```apex
try {
// Perform some operation that might cause an exception.
} catch(Exception e) {
// Generic exception handling code here.
} finally {
// Perform some clean up.
}
```

> try 블록엔 최소 catch 또는 finally 블록이 필요하다.

---

## 잡을 수 없는 예외 (Exceptions that Can't be Caught)

일부 built-in 예외는 잡을 수 없다(critical 상황). 예:

- `System.LimitException` — governor limit 초과(heap/CPU/SOQL/레코드 수 등).
- assertion 실패(System.assert).
- license 예외.

uncatchable 시 catch·finally 블록이 미실행된다.

**Versioned:** API 41.0+ unreachable statement는 컴파일 에러다.

```apex
Boolean x = true;
throw new NullPointerException();
x = false;  // unreachable → 컴파일 에러
```

---

## 예외 처리 예제

다음은 필수 필드를 채우지 않고 insert하여 DmlException이 발생하는 경우다.

```apex
Merchandise__c m = new Merchandise__c();
insert m;
```

발생하는 DmlException:

```text
System.DmlException: Insert failed. First exception on row 0; first error:
REQUIRED_FIELD_MISSING, Required fields are missing: [Description, Price, Total
Inventory]: [Description, Price, Total Inventory]
```

try-catch로 처리:

```apex
try {
Merchandise__c m = new Merchandise__c();
insert m;
} catch(DmlException e) {
System.debug('The following exception has occurred: ' + e.getMessage());
}
```

finally 블록 예제:

```apex
XmlStreamWriter w = null;
try {
w = new XmlStreamWriter();
w.writeStartDocument(null, '1.0');
w.writeStartElement(null, 'book', null);
w.writeCharacters('This is my book');
w.writeEndElement();
w.writeEndDocument();
String s;
Integer i = s.length();   // exception
} catch(Exception e) {
System.debug('An exception occurred: ' + e.getMessage());
} finally {
System.debug('Closing the stream writer in the finally block.');
w.close();
}
```

---

## 대표 빌트인 예외 5종

다음은 대표 built-in 예외다. 전체 카탈로그(빌트인 예외 클래스 전수)는 [[Apex 표준 클래스 레퍼런스]] 참조.

| Exception | 설명 |
|---|---|
| **DmlException** | DML statement 문제(예 insert 시 필수 필드 누락) |
| **ListException** | list 문제(예 out of bounds 인덱스 접근). 메시지: "List index out of bounds: 1" |
| **NullPointerException** | null 변수 dereference. 메시지: "Attempt to de-reference a null object" |
| **QueryException** | SOQL 문제(예 0개 또는 1개 초과 레코드를 singleton sObject에 할당). 메시지: "List has no rows for assignment to SObject" |
| **SObjectException** | sObject 레코드 문제(예 SELECT 안 한 필드 접근). 메시지: "SObject row was retrieved via SOQL without querying the requested field: ..." |

---

## 공통 예외 메서드

모든 예외가 상속하는 대표 메서드:

- `getCause` — 예외 원인을 exception object로 반환
- `getLineNumber` — 예외 발생 라인 번호
- `getMessage` — user에게 표시되는 error 메시지
- `getStackTraceString` — stack trace를 string으로
- `getTypeName` — 예외 타입(DmlException, ListException, MathException 등)

**DmlException 전용 메서드:** `getDmlFieldNames(index)`, `getDmlId(index)`, `getDmlMessage(index)`, `getNumDml`.

---

## 여러 예외 타입 catch

generic Exception 타입은 모든 예외를 catch한다. 여러 catch 블록 + 마지막 generic Exception을 둘 수 있다(순서대로 매치, 하나만 실행).

```apex
try {
Merchandise__c m = [SELECT Name FROM Merchandise__c LIMIT 1];
Double inventory = m.Total_Inventory__c;
} catch(DmlException e) {
System.debug('DmlException caught: ' + e.getMessage());
} catch(SObjectException e) {
System.debug('SObjectException caught: ' + e.getMessage());
} catch(Exception e) {
System.debug('Exception caught: ' + e.getMessage());
}
```

---

## 커스텀 예외 만들기 (Create Custom Exceptions)

상세 error 메시지·custom handling을 위해 작성한다. 예외는 top-level 클래스가 될 수 있고 member 변수·메서드·생성자를 갖거나 interface를 구현할 수 있다. **built-in Exception 클래스를 extend하고 이름이 "Exception"으로 끝나야 한다**(예 MyException, PurchaseException). 모든 예외는 system base 클래스 Exception을 extend하므로 common 메서드를 상속한다.

```apex
public class MyException extends Exception {}
```

inheritance tree:

```apex
public class ExceptionExample {
public virtual class BaseException extends Exception {}
public class OtherException extends BaseException {}
public static void testExtendedException() {
try {
Integer i=0;
if (i < 5) throw new OtherException('This is bad');
} catch (BaseException e) {
System.debug(e.getMessage());
}
}
}
```

**예외 객체 생성 방법 (4개 implicit 생성자):**

- 인자 없음: `new MyException();`
- 단일 String(error 메시지): `new MyException('This is bad');`
- 단일 Exception(cause, stack trace 표시): `new MyException(e);`
- String 메시지 + chained exception cause: `new MyException('This is bad', e);`

### Rethrowing Exceptions and Inner Exceptions

```apex
public class My1Exception extends Exception {}
public class My2Exception extends Exception {}
try {
throw new My1Exception('First exception');
} catch (My1Exception e) {
throw new My2Exception('Thrown with inner exception', e);
}
```

**Inner Exception Example:**

```apex
public class MerchandiseException extends Exception {
}
```

```apex
public class MerchandiseUtility {
public static void mainProcessing() {
try {
insertMerchandise();
} catch(MerchandiseException me) {
System.debug('Message: ' + me.getMessage());
System.debug('Cause: ' + me.getCause());
System.debug('Line number: ' + me.getLineNumber());
System.debug('Stack trace: ' + me.getStackTraceString());
}
}
public static void insertMerchandise() {
try {
Merchandise__c m = new Merchandise__c();
insert m;
} catch(DmlException e) {
throw new MerchandiseException(
'Merchandise item could not be inserted.', e);
}
}
}
```

---

## Apex 예약어 (Reserved Keywords)

다음은 Table 12: Reserved Keywords의 전체 목록(알파벳순 전수)이다.

```text
abstract, activate, and, any, array, as, asc, autonomous, begin, bigdecimal,
blob, boolean, break, bulk, by, byte, case, cast, catch, char, class, collect,
commit, const, continue, currency, date, datetime, decimal, default, delete,
desc, do, double, else, end, enum, exception, exit, export, extends, false,
final, finally, float, for, from, global, goto, group, having, hint, if,
implements, import, in, inner, insert, instanceof, int, integer, interface,
into, join, like, limit, list, long, loop, map, merge, new, not, null, nulls,
number, object, of, on, or, outer, override, package, parallel, pragma,
private, protected, public, retrieve, return, rollback, select, set, short,
sObject, sort, static, string, super, switch, synchronized, system, testmethod,
then, this, throw, time, transaction, trigger, true, try, undelete, update,
upsert, using, virtual, void, webservice, when, where, while
```

**예약어가 아니지만 identifier로 사용 가능한 특수 키워드 (10개 전수):**

```text
after, before, count, excludes, first, includes, last, order, sharing, with
```

---

## 관련 노트

- [[Apex MOC]]
- [[Apex 언어 기초 — 제어 흐름과 클래스]]
- [[Apex 언어 기초 — 데이터타입과 변수]]
- [[Apex 표준 클래스 레퍼런스]]
- [[Apex Best Practices]]
- [[ApexDoc 주석 작성 가이드]] — `@throws` 등 예외 문서화 주석 작성
- [[Apex Debug Log]] — 예외·스택트레이스를 디버그 로그로 추적
- [[JSON 직렬화 심화 — JSONParser·JSONGenerator·예약어 충돌]] — JSON 키가 예약어라 래퍼 선언이 안 될 때의 우회 패턴
