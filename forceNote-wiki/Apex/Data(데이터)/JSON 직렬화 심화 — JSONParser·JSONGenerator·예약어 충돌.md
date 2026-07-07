---
tags: [apex, data, json, serialization, deserialization, parser, generator]
source: salesforce_apex_reference_guide.pdf — System.JSON·JSONGenerator·JSONParser·JSONToken (pp. 3936–3969) + salesforce_apex_developer_guide.pdf — JSON Support (pp. 655–661)·Reserved Keywords (pp. 816–817)
created: 2026-07-05
aliases: [JSONParser, JSONGenerator, JSONToken, JSON 예약어 충돌, deserializeUntyped, deserializeStrict, JSON reserved word]
---

# JSON 직렬화 심화 — JSONParser·JSONGenerator·예약어 충돌

> JSON 필드명이 Apex 예약어(`from`, `case`, `currency` 등)라서 래퍼 클래스로 못 받을 때의 우회 4패턴(deserializeUntyped·JSONParser 토큰 순회·문자열 치환·JSONGenerator)과 System.JSON / JSONParser / JSONGenerator / JSONToken 전수 레퍼런스.

---

## 1. 문제 — 예약어 필드명과 래퍼 클래스 컴파일 오류

외부 API 응답의 JSON 키가 Apex **예약어**(reserved keyword)이면, 그 이름으로 래퍼 클래스 멤버 변수를 선언할 수 없어 `JSON.deserialize(json, Wrapper.class)`용 클래스 자체가 **컴파일되지 않는다**.

```apex
// 구조 예시 — 실제 동작 코드 아님 (컴파일 실패를 보여주는 예)
public class EmailMessageWrapper {
    public String from;      // ❌ 컴파일 오류 — 'from'은 Apex 예약어 (식별자 사용 불가)
    public String subject;   // OK
    public Integer size;     // OK ('size'는 예약어 아님)
}
// (EmailMessageWrapper) JSON.deserialize('{"from":"a@x.com",...}', EmailMessageWrapper.class)
// → 래퍼가 컴파일되지 않으므로 이 접근 자체가 불가능
```

`JSON.deserialize` / `deserializeStrict`는 **JSON 키 이름 = Apex 멤버 변수 이름** 매칭으로만 동작하고 키 이름을 바꾸는 어노테이션(다른 언어의 `@JsonProperty` 같은 것)이 Apex에는 없다. 따라서 예약어 키는 아래 우회 패턴으로 처리한다. 어떤 키가 예약어인지 판별은 §7 참조 (전수 목록은 [[Apex 언어 기초 — 예외 처리와 예약어]] 소관).

---

## 2. 우회 패턴 4가지 (핵심 답)

### 패턴 A — `deserializeUntyped` 후 Map 접근 (가장 간단)

`JSON.deserializeUntyped`는 래퍼 클래스 없이 `Map<String, Object>` / `List<Object>` / 프리미티브 컬렉션으로 역직렬화한다. **Map 키는 문자열이므로 예약어 제약이 없다.**

```apex
// 구조 예시 — 실제 동작 코드 아님
String jsonInput = '{"from":"a@x.com","subject":"Hi","size":2048}';

Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(jsonInput);
String fromAddr = (String) m.get('from');      // 예약어 키도 문자열 키로 자유롭게 접근
String subject  = (String) m.get('subject');
Integer size    = (Integer) m.get('size');

// 중첩 구조는 단계별 캐스팅
// List<Object> items = (List<Object>) m.get('items');
// Map<String, Object> nested = (Map<String, Object>) items[0];
```

- 장점: 코드 최소, 예약어 개수와 무관하게 동작.
- 단점: 타입 안전성 없음(모든 값이 `Object` → 수동 캐스팅), 중첩이 깊으면 캐스팅 체인이 길어짐. 숫자는 JSON 표기에 따라 `Integer`/`Long`/`Decimal`/`Double`로 들어오므로 캐스팅 주의.

#### 패턴 A 심화 — 방어적 역직렬화 (instanceof 가드 + try-catch)

`deserializeUntyped` 결과는 모든 값이 `Object`라 **캐스팅이 항상 성공한다는 보장이 없다.** 신뢰할 수 없는(외부 API·사용자 입력) 페이로드는 구조가 예상과 다르면 `(Map<String,Object>) ...` 같은 캐스팅에서 **`System.TypeException`**, JSON 문자열 자체가 깨졌으면 `deserializeUntyped` 호출에서 **`System.JSONException`**이 난다. 따라서 ① 캐스팅 전에 `instanceof`로 실제 타입을 확인하고, ② 파싱·캐스팅을 `try-catch`로 감싼다.

```apex
// 구조 예시 — 실제 동작 코드 아님
Object parsed;
try {
    parsed = JSON.deserializeUntyped(rawBody);
} catch (JSONException e) {
    // 깨진 JSON 문자열 — 파싱 자체 실패
    throw new CalloutException('Malformed JSON: ' + e.getMessage());
}

// 루트가 객체라고 가정하지 말고 instanceof로 먼저 확인
if (!(parsed instanceof Map<String, Object>)) {
    throw new CalloutException('Expected a JSON object at root');
}
Map<String, Object> m = (Map<String, Object>) parsed;

try {
    // 중첩 List — 값이 List인지 확인 후 순회
    Object accVal = m.get('accessories');
    if (accVal instanceof List<Object>) {
        for (Object item : (List<Object>) accVal) {
            if (item instanceof String) {
                String s = (String) item;              // 문자열 원소
            } else if (item instanceof Map<String, Object>) {
                Map<String, Object> nested = (Map<String, Object>) item;  // 객체 원소
                Object right = nested.get('right');
                String rightText = (right instanceof String) ? (String) right : null;
            }
        }
    }
} catch (TypeException e) {
    // instanceof로 좁히지 못한 예상 밖 캐스팅 — 방어적으로 흡수
    System.debug('Unexpected shape: ' + e.getMessage());
}
```

**숫자 분기 — `Integer`/`Long`/`Decimal`/`Double`:** `deserializeUntyped`는 JSON 숫자를 표기에 따라 정수는 `Integer`(범위 초과 시 `Long`), 소수는 `Decimal`(또는 `Double`)로 넣는다(§3 공식 예제에서 `2000`→Integer, `1023.45`→Decimal). 어떤 숫자 타입이 올지 확정할 수 없으면 `instanceof`로 분기해 하나의 `Decimal`로 정규화한다.

```apex
// 구조 예시 — 실제 동작 코드 아님
Decimal asDecimal(Object raw) {
    if (raw == null)                return null;
    if (raw instanceof Integer)     return (Integer) raw;
    if (raw instanceof Long)        return (Long) raw;
    if (raw instanceof Decimal)     return (Decimal) raw;
    if (raw instanceof Double)      return Decimal.valueOf((Double) raw);
    // 숫자가 문자열로 온 경우("2048")까지 방어
    if (raw instanceof String)      return Decimal.valueOf((String) raw);
    throw new TypeException('Not a number: ' + raw);
}
// Decimal qty = asDecimal(m.get('inventory'));   // 2000 (Integer) → 2000 (Decimal)
// Decimal price = asDecimal(m.get('price'));     // 1023.45 (Decimal) 그대로
```

- 잘못된 캐스팅을 미리 막으므로 `TypeException`이 콜아웃 전체를 중단시키지 않는다. `String.valueOf(obj)`는 어떤 타입이든 문자열로 강제 변환하므로 **문자열만 필요할 땐 캐스팅 대신 `String.valueOf(m.get('key'))`가 더 안전**하다(§4의 upsertRows 공식 예제가 이 방식).

#### 타입드 리스트 역직렬화 — 배열 JSON을 제네릭 리스트로

JSON 최상위가 **배열**이고 원소 구조가 고정이면, `deserializeUntyped`로 `List<Object>`를 받아 원소마다 캐스팅하는 대신 **`List<T>.class`를 타입 토큰으로 넘겨** 한 번에 타입드 리스트로 역직렬화한다. 예약어 키가 없을 때 패턴 A보다 타입 안전하다.

```apex
// Apex Developer Guide 공식 예제 발췌 — 직렬화한 리스트를 그대로 타입드 리스트로 왕복
List<InvoiceStatement> deserializedInvoices =
    (List<InvoiceStatement>) JSON.deserialize(JSONString, List<InvoiceStatement>.class);
// 일반형: List<MyClass> items = (List<MyClass>) JSON.deserialize(jsonArray, List<MyClass>.class);
```

sObject 리스트도 동일하게 `List<Account>.class`를 넘길 수 있고, 신뢰 경계에서는 `deserializeStrict` + `Security.stripInaccessible`로 여분/무권한 필드를 걸러낸다(공식 예제).

```apex
// Apex Developer Guide 공식 예제 발췌 — 신뢰할 수 없는 소스의 sObject 리스트 정제
List<Account> accounts =
    (List<Account>) JSON.deserializeStrict(jsonInput, List<Account>.class);
SObjectAccessDecision securityDecision =
    Security.stripInaccessible(AccessType.UPDATABLE, accounts);
update securityDecision.getRecords();   // 권한 없는 필드(AnnualRevenue)는 갱신 제외
```

- 타입 토큰 없이 `(List<MyClass>) JSON.deserialize(json)`처럼 두 번째 인자를 빼면 컴파일되지 않는다 — `List<T>.class`를 반드시 넘긴다.

### 패턴 B — JSONParser 토큰 순회로 수동 파싱 (타입 안전, 대형 페이로드)

`JSON.createParser()`로 파서를 만들고 토큰을 순회하면서, JSON의 `from` 값을 **예약어가 아닌 멤버**(예: `fromAddr`)에 직접 담는다. 필드명은 `getText()` 문자열 비교로 판별하므로 예약어 제약이 없다. Apex Reference Guide의 TaxEngineAdapter `Addresses(JSONParser parser)` 예제와 동일한 형태의 공식 패턴이다.

```apex
// 구조 예시 — 실제 동작 코드 아님
public class EmailMessageWrapper {
    public String fromAddr;   // JSON 'from' → 예약어 아닌 이름으로 보관
    public String subject;
    public Integer size;

    public EmailMessageWrapper(JSONParser parser) {
        while (parser.nextToken() != JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                String fieldName = parser.getText();   // 필드명은 문자열 — 예약어 제약 없음
                parser.nextToken();                    // 값 토큰으로 전진
                if (fieldName == 'from') {
                    fromAddr = parser.getText();
                } else if (fieldName == 'subject') {
                    subject = parser.getText();
                } else if (fieldName == 'size') {
                    size = parser.getIntegerValue();
                } else if (parser.getCurrentToken() == JSONToken.START_OBJECT
                        || parser.getCurrentToken() == JSONToken.START_ARRAY) {
                    parser.skipChildren();             // 관심 없는 중첩 구조는 통째로 건너뜀
                }
            }
        }
    }
}

// 사용: EmailMessageWrapper w = new EmailMessageWrapper(JSON.createParser(jsonInput));
```

**하이브리드:** 예약어가 최상위 일부 키에만 있으면, 예약어 없는 하위 객체는 순회 중 `parser.readValueAs(SubType.class)`로 통째로 역직렬화해 수동 파싱 범위를 최소화할 수 있다 (§4의 readValueAs 공식 예제 참조).

### 패턴 C — 문자열 치환 후 deserialize (임시방편)

역직렬화 전에 예약어 키를 안전한 이름으로 치환하고, 래퍼는 치환된 이름으로 선언한다.

```apex
// 구조 예시 — 실제 동작 코드 아님
public class EmailMessageWrapper {
    public String fromAddr;   // 치환 후 키와 동일한 이름
    public String subject;
}

String safe = jsonInput.replace('"from":', '"fromAddr":');   // 키 패턴("키":)만 치환
EmailMessageWrapper w =
    (EmailMessageWrapper) JSON.deserialize(safe, EmailMessageWrapper.class);
```

- ⚠️ 값(value) 문자열 안에 `"from":` 이 우연히 포함되면 **데이터가 오염**된다. 키 패턴(`"키":`)으로 최대한 좁게 치환하고, 신뢰할 수 없는 대형 페이로드에는 패턴 A/B를 권장.

### 패턴 D — 직렬화(생성) 방향: JSONGenerator 또는 Map 직렬화

예약어 키를 가진 JSON을 **만들어야** 할 때. `writeFieldName` / `write*Field`는 필드명을 문자열로 받으므로 예약어 제약이 없다.

```apex
// 구조 예시 — 실제 동작 코드 아님
JSONGenerator gen = JSON.createGenerator(false);
gen.writeStartObject();
gen.writeStringField('from', 'a@x.com');   // 예약어 키도 문자열이라 자유롭게 출력
gen.writeStringField('subject', 'Hi');
gen.writeEndObject();
String out = gen.getAsString();            // {"from":"a@x.com","subject":"Hi"}

// 또는 String 키 Map을 직렬화 — Map 키가 JSON 키가 된다
String out2 = JSON.serialize(new Map<String, Object>{
    'from' => 'a@x.com', 'subject' => 'Hi' });
```

### 선택 기준 요약

| 상황 | 패턴 |
|---|---|
| 키 몇 개만 빠르게 읽으면 됨 | A. `deserializeUntyped` + Map |
| 타입 안전한 래퍼 필요 / 대형·중첩 페이로드 / 스트리밍 파싱 | B. JSONParser 토큰 순회 (+ `readValueAs` 하이브리드) |
| 래퍼 재사용이 목적이고 페이로드를 신뢰함 | C. 문자열 치환 후 `deserialize` |
| 예약어 키 JSON을 **생성**해야 함 | D. JSONGenerator `writeFieldName` / Map 직렬화 |

---

## 3. System.JSON 메서드 전수

System.JSON — Apex 객체 ↔ JSON 왕복(roundtrip) 직렬화·역직렬화. **모두 static.** 실행 중 문제가 생기면 이 계열 클래스들은 `JSONException`을 던진다.

| 메서드 | 시그니처 | 설명 |
|---|---|---|
| `createGenerator(prettyPrint)` | `public static System.JSONGenerator createGenerator(Boolean prettyPrint)` | 새 JSON 생성기 반환. `true`면 pretty-print(들여쓰기) 포맷 |
| `createParser(jsonString)` | `public static System.JSONParser createParser(String jsonString)` | 새 JSON 파서 반환 |
| `deserialize(jsonString, apexType)` | `public static Object deserialize(String jsonString, System.Type apexType)` | JSON 문자열을 지정 Apex 타입 객체로 역직렬화 |
| `deserializeStrict(jsonString, apexType)` | `public static Object deserializeStrict(String jsonString, System.Type apexType)` | JSON의 **모든 속성이 지정 타입에 존재**해야 하는 엄격 역직렬화 |
| `deserializeUntyped(jsonString)` | `public static Object deserializeUntyped(String jsonString)` | 프리미티브 타입 컬렉션(`Map<String,Object>`/`List<Object>` 등)으로 역직렬화 |
| `serialize(objectToSerialize)` | `public static String serialize(Object objectToSerialize)` | Apex 객체를 JSON으로 직렬화 |
| `serialize(objectToSerialize, suppressApexObjectNulls)` | `public static String serialize(Object objectToSerialize, Boolean suppressApexObjectNulls)` | `true`면 직렬화 전에 null 값 제거. **SOQL로 조회한 sObject에는 이 파라미터가 적용되지 않음** |
| `serializePretty(objectToSerialize)` | `public static String serializePretty(Object objectToSerialize)` | pretty-print(들여쓰기) 포맷으로 직렬화 |
| `serializePretty(objectToSerialize, suppressApexObjectNulls)` | `public static String serializePretty(Object objectToSerialize, Boolean suppressApexObjectNulls)` | null 억제 + pretty-print |

### deserialize vs deserializeStrict — 여분(extraneous) 속성 처리

JSON에 대상 타입에 없는 속성이 있을 때의 동작 차이 (Apex Reference Guide 원문 기준):

| 대상 타입 | `deserialize` | `deserializeStrict` |
|---|---|---|
| **Apex 클래스** | 모든 API 버전에서 예외 없음 — 여분 속성 무시하고 나머지 파싱 | **모든 API 버전에서 예외 발생** |
| **커스텀 오브젝트 / sObject** | API v34.0 이하: 런타임 예외 발생. **v35.0 이상: 예외 없음**(여분 속성 무시) | 예외 없음 |

`deserializeStrict` 공식 예제 (PDF 발췌):

```apex
public class Car {
    public String make;
    public String year;
}
public void parse() {
    Car c = (Car)JSON.deserializeStrict(
        '{"make":"SFDC","year":"2020"}',
        Car.class);
    System.assertEquals(c.make, 'SFDC');
    System.assertEquals(c.year, '2020');
}
```

`deserializeUntyped` 공식 예제 (PDF 발췌, 축약 없음 — 중첩 배열·객체·null·숫자·불리언 전부):

```apex
String jsonInput = '{\n' +
    ' "description" :"An appliance",\n' +
    ' "accessories" : [ "powerCord", ' +
    '{ "right":"door handle1", ' +
    '"left":"door handle2" } ],\n' +
    ' "dimensions" : ' +
    '{ "height" : 5.5 , ' +
    '"width" : 3.0 , ' +
    '"depth" : 2.2 },\n' +
    ' "type" : null,\n' +
    ' "inventory" : 2000,\n' +
    ' "price" : 1023.45,\n' +
    ' "isShipped" : true,\n' +
    ' "modelNumber" : "123"\n' +
    '}';
Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(jsonInput);

System.assertEquals('An appliance', m.get('description'));
List<Object> a = (List<Object>) m.get('accessories');
System.assertEquals('powerCord', a[0]);
Map<String, Object> a2 = (Map<String, Object>) a[1];
System.assertEquals('door handle1', a2.get('right'));
System.assertEquals('door handle2', a2.get('left'));
Map<String, Object> dim = (Map<String, Object>) m.get('dimensions');
System.assertEquals(5.5, dim.get('height'));
System.assertEquals(3.0, dim.get('width'));
System.assertEquals(2.2, dim.get('depth'));
System.assertEquals(null, m.get('type'));
System.assertEquals(2000, m.get('inventory'));
System.assertEquals(1023.45, m.get('price'));
System.assertEquals(true, m.get('isShipped'));
System.assertEquals('123', m.get('modelNumber'));
```

---

## 4. JSONParser 메서드 전수 (21) + JSONToken enum 전수 (13)

`System.JSONParser` — JSON 인코딩 콘텐츠의 파서. 웹서비스 콜아웃 응답 같은 외부 서비스의 JSON 응답 파싱에 사용. **모두 인스턴스 메서드.**

| 메서드 | 시그니처 | 설명 / 토큰 요건 |
|---|---|---|
| `clearCurrentToken()` | `public Void clearCurrentToken()` | 현재 토큰 제거. 이후 `hasCurrentToken()`은 false, `getCurrentToken()`은 null. 제거된 토큰은 `getLastClearedToken()`으로 회수 |
| `getBlobValue()` | `public Blob getBlobValue()` | 현재 토큰을 Blob으로 반환. 토큰이 `VALUE_STRING`이고 Base64 인코딩이어야 함 |
| `getBooleanValue()` | `public Boolean getBooleanValue()` | 토큰이 `VALUE_TRUE` 또는 `VALUE_FALSE`여야 함 |
| `getCurrentName()` | `public String getCurrentName()` | 현재 토큰의 이름. `FIELD_NAME`이면 `getText()`와 동일 값, 값 토큰이면 직전 필드명, 배열 값·루트 값은 null |
| `getCurrentToken()` | `public System.JSONToken getCurrentToken()` | 파서가 가리키는 토큰(없으면 null) |
| `getDatetimeValue()` | `public Datetime getDatetimeValue()` | `VALUE_STRING` + ISO-8601 Datetime이어야 함 |
| `getDateValue()` | `public Date getDateValue()` | `VALUE_STRING` + ISO-8601 Date여야 함 |
| `getDecimalValue()` | `public Decimal getDecimalValue()` | `VALUE_NUMBER_FLOAT` 또는 `VALUE_NUMBER_INT`, Decimal 변환 가능 값 |
| `getDoubleValue()` | `public Double getDoubleValue()` | `VALUE_NUMBER_FLOAT`, Double 변환 가능 값 |
| `getIdValue()` | `public ID getIdValue()` | `VALUE_STRING` + 유효한 ID여야 함 |
| `getIntegerValue()` | `public Integer getIntegerValue()` | `VALUE_NUMBER_INT` + Integer 표현이어야 함 |
| `getLastClearedToken()` | `public System.JSONToken getLastClearedToken()` | `clearCurrentToken()`으로 마지막에 제거된 토큰 |
| `getLongValue()` | `public Long getLongValue()` | `VALUE_NUMBER_INT`, Long 변환 가능 값 |
| `getText()` | `public String getText()` | 현재 토큰의 텍스트 표현. `nextToken()` 최초 호출 전이거나 입력 끝이면 null |
| `getTimeValue()` | `public Time getTimeValue()` | `VALUE_STRING` + ISO-8601 Time이어야 함 |
| `hasCurrentToken()` | `public Boolean hasCurrentToken()` | 현재 토큰을 가리키고 있으면 true |
| `nextToken()` | `public System.JSONToken nextToken()` | 다음 토큰 반환(입력 끝이면 null). 다음 토큰 타입 판별에 필요한 만큼 스트림 전진 |
| `nextValue()` | `public System.JSONToken nextValue()` | **값 타입**인 다음 토큰 반환(배열·객체 시작/끝 마커 포함, 입력 끝이면 null) |
| `readValueAs(apexType)` | `public Object readValueAs(System.Type apexType)` | 현재 값을 지정 Apex 타입으로 역직렬화. 여분 속성 처리 규칙은 `JSON.deserialize`와 동일(v34 이하 sObject 예외 / v35+·Apex 클래스 무시) |
| `readValueAsStrict(apexType)` | `public Object readValueAsStrict(System.Type apexType)` | 엄격 버전 — JSON의 모든 속성이 지정 타입에 존재해야 함. Apex 클래스 대상 여분 속성은 전 버전 예외, 커스텀 오브젝트/sObject는 예외 없음 |
| `skipChildren()` | `public Void skipChildren()` | 현재 가리키는 `START_ARRAY`/`START_OBJECT`의 자식 토큰 전부 건너뜀 |

### JSONToken enum — 13개 전수

| Enum 값 | 설명 |
|---|---|
| `END_ARRAY` | 배열 끝 — `]` 를 만나면 반환 |
| `END_OBJECT` | 객체 끝 — `}` 를 만나면 반환 |
| `FIELD_NAME` | 필드명인 문자열 토큰 |
| `NOT_AVAILABLE` | 요청한 토큰을 사용할 수 없음 |
| `START_ARRAY` | 배열 시작 — `[` 를 만나면 반환 |
| `START_OBJECT` | 객체 시작 — `{` 를 만나면 반환 |
| `VALUE_EMBEDDED_OBJECT` | START/END_OBJECT 토큰 구조로 접근할 수 없는, raw 객체로 표현되는 내장 객체 |
| `VALUE_FALSE` | 리터럴 "false" 값 |
| `VALUE_NULL` | 리터럴 "null" 값 |
| `VALUE_NUMBER_FLOAT` | float 값 |
| `VALUE_NUMBER_INT` | integer 값 |
| `VALUE_STRING` | 문자열 값 |
| `VALUE_TRUE` | "true" 문자열 리터럴에 해당하는 값 |

### 공식 파싱 예제 — 콜아웃 응답을 토큰 순회로 Map 구축 (PDF 발췌)

```apex
public class JSONParserUtil {
    public static void parseJSONResponse() {
        // Create HTTP request to send.
        HttpRequest request = new HttpRequest();
        String endpoint = URL.getOrgDomainUrl().toExternalForm() + '/services/data';
        request.setEndPoint(endpoint);
        request.setMethod('GET');
        request.setHeader('Accept', 'application/json');
        Http httpProtocol = new Http();
        HttpResponse response = httpProtocol.send(request);
        System.debug(response.getBody());

        // Parse JSON response to build a map from API version numbers to labels
        JSONParser parser = JSON.createParser(response.getBody());
        Map<double, string> apiVersionToReleaseNameMap = new Map<double, string>();
        string label = null;
        double version = null;
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                switch on parser.getText() {
                    when 'label' {
                        parser.nextToken();
                        label = parser.getText();
                    }
                    when 'version' {
                        parser.nextToken();
                        version = Double.valueOf(parser.getText());
                    }
                }
            }
            if(version != null && String.isNotEmpty(label)) {
                apiVersionToReleaseNameMap.put(version, label);
                version = null;
                label = null;
            }
        }
        system.debug('Release with Rainbow logo = ' +
            apiVersionToReleaseNameMap.get(39.0D));
    }
}
```

### 공식 readValueAs 예제 — 순회 중 하위 객체 통짜 역직렬화 (PDF 발췌)

```apex
public class Person {
    public String name;
    public String phone;
}
```

```apex
// JSON string that contains a Person object.
String JSONContent =
    '{"person":{' +
    '"name":"John Smith",' +
    '"phone":"555-1212"}}';
JSONParser parser = JSON.createParser(JSONContent);
// Make calls to nextToken() to point to the second start object marker.
parser.nextToken();
parser.nextToken();
parser.nextToken();
// Retrieve the Person object from the JSON string.
Person obj = (Person)parser.readValueAs(Person.class);
System.assertEquals(obj.name, 'John Smith');
System.assertEquals(obj.phone, '555-1212');
```

---

## 5. JSONGenerator 메서드 전수 (34) + 생성 패턴

`System.JSONGenerator` — 표준 JSON 인코딩으로 요소 단위(element by element) JSON 생성. 출력 구조를 세밀하게 제어할 때 사용. **모두 인스턴스 메서드.** `JSON.createGenerator(prettyPrint)`로 생성.

| 메서드 | 시그니처 | 설명 |
|---|---|---|
| `close()` | `public Void close()` | 생성기 닫기 — 이후 콘텐츠 쓰기 불가 |
| `getAsString()` | `public String getAsString()` | 생성된 JSON 반환. **아직 안 닫혔으면 생성기를 닫음** |
| `isClosed()` | `public Boolean isClosed()` | 닫혔으면 true |
| `writeBlob(blobValue)` | `public Void writeBlob(Blob blobValue)` | Blob을 base64 인코딩 문자열로 출력 |
| `writeBlobField(fieldName, blobValue)` | `public Void writeBlobField(String fieldName, Blob blobValue)` | 필드명 + Blob 값 쌍 출력 |
| `writeBoolean(blobValue)` | `public Void writeBoolean(Boolean blobValue)` | Boolean 값 출력 (PDF 원문의 파라미터명이 `blobValue`) |
| `writeBooleanField(fieldName, booleanValue)` | `public Void writeBooleanField(String fieldName, Boolean booleanValue)` | 필드명 + Boolean 값 쌍 출력 |
| `writeDate(dateValue)` | `public Void writeDate(Date dateValue)` | Date를 ISO-8601 포맷으로 출력 |
| `writeDateField(fieldName, dateValue)` | `public Void writeDateField(String fieldName, Date dateValue)` | 필드명 + Date(ISO-8601) 쌍 출력 |
| `writeDateTime(datetimeValue)` | `public Void writeDateTime(Datetime datetimeValue)` | Datetime을 ISO-8601 포맷으로 출력 |
| `writeDateTimeField(fieldName, datetimeValue)` | `public Void writeDateTimeField(String fieldName, Datetime datetimeValue)` | 필드명 + Datetime(ISO-8601) 쌍 출력 |
| `writeEndArray()` | `public Void writeEndArray()` | 배열 종료 마커 `]` 출력 |
| `writeEndObject()` | `public Void writeEndObject()` | 객체 종료 마커 `}` 출력 |
| `writeFieldName(fieldName)` | `public Void writeFieldName(String fieldName)` | 필드명 출력 — **문자열이므로 예약어 키 가능 (패턴 D)** |
| `writeId(identifier)` | `public Void writeId(ID identifier)` | ID 값 출력 |
| `writeIdField(fieldName, identifier)` | `public Void writeIdField(String fieldName, Id identifier)` | 필드명 + ID 쌍 출력 |
| `writeNull()` | `public Void writeNull()` | JSON null 리터럴 출력 |
| `writeNullField(fieldName)` | `public Void writeNullField(String fieldName)` | 필드명 + null 리터럴 쌍 출력 |
| `writeNumber(number)` ×4 오버로드 | `public Void writeNumber(Decimal number)` / `(Double number)` / `(Integer number)` / `(Long number)` | Decimal/Double/Integer/Long 값 출력 |
| `writeNumberField(fieldName, number)` ×4 오버로드 | `public Void writeNumberField(String fieldName, Decimal number)` / `(String, Double)` / `(String, Integer)` / `(String, Long)` | 필드명 + 숫자 값 쌍 출력 |
| `writeObject(anyObject)` | `public Void writeObject(Object anyObject)` | Apex 객체를 JSON 포맷으로 출력 |
| `writeObjectField(fieldName, value)` | `public Void writeObjectField(String fieldName, Object value)` | 필드명 + Apex 객체 쌍 출력 |
| `writeStartArray()` | `public Void writeStartArray()` | 배열 시작 마커 `[` 출력 |
| `writeStartObject()` | `public Void writeStartObject()` | 객체 시작 마커 `{` 출력 |
| `writeString(stringValue)` | `public Void writeString(String stringValue)` | 문자열 값 출력 |
| `writeStringField(fieldName, stringValue)` | `public Void writeStringField(String fieldName, String stringValue)` | 필드명 + 문자열 쌍 출력 |
| `writeTime(timeValue)` | `public Void writeTime(Time timeValue)` | Time을 ISO-8601 포맷으로 출력 |
| `writeTimeField(fieldName, timeValue)` | `public Void writeTimeField(String fieldName, Time timeValue)` | 필드명 + Time(ISO-8601) 쌍 출력 |

### 공식 생성 패턴 예제 (Apex Developer Guide 발췌 — pretty print + 중첩 객체/리스트/객체 필드)

```apex
public class JSONGeneratorSample{
    public class A {
        String str;
        public A(String s) { str = s; }
    }

    static void generateJSONContent() {
        // Create a JSONGenerator object.
        // Pass true to the constructor for pretty print formatting.
        JSONGenerator gen = JSON.createGenerator(true);

        // Create a list of integers to write to the JSON string.
        List<integer> intlist = new List<integer>();
        intlist.add(1);
        intlist.add(2);
        intlist.add(3);

        // Create an object to write to the JSON string.
        A x = new A('X');

        // Write data to the JSON string.
        gen.writeStartObject();
        gen.writeNumberField('abc', 1.21);
        gen.writeStringField('def', 'xyz');
        gen.writeFieldName('ghi');
        gen.writeStartObject();
        gen.writeObjectField('aaa', intlist);
        gen.writeEndObject();
        gen.writeFieldName('Object A');
        gen.writeObject(x);
        gen.writeEndObject();

        // Get the JSON string.
        String pretty = gen.getAsString();

        System.assertEquals('{\n' +
            '  "abc" : 1.21,\n' +
            '  "def" : "xyz",\n' +
            '  "ghi" : {\n' +
            '    "aaa" : [ 1, 2, 3 ]\n' +
            '  },\n' +
            '  "Object A" : {\n' +
            '    "str" : "X"\n' +
            '  }\n' +
            '}', pretty);
    }
}
```

---

## 6. JSON 지원 고려사항 (Apex Developer Guide)

**직렬화 지원 대상:** sObject(표준·커스텀), Apex 프리미티브·컬렉션 타입, Database 메서드 반환 타입(`SaveResult`, `DeleteResult` 등), 사용자 Apex 클래스 인스턴스.

- 관리 패키지 외부 코드에서는 관리 패키지의 **커스텀 오브젝트(sObject 타입)만** 직렬화 가능 — 패키지 내부에 정의된 Apex 클래스 인스턴스는 직렬화 불가.
- **Map 직렬화 가능 키 타입 (전수):** Boolean, Date, DateTime, Decimal, Double, Enum, Id, Integer, Long, String, Time.
- 부모 타입으로 선언된 변수에 서브타입 인스턴스를 담으면 부모 타입으로 직렬화·역직렬화되어 **서브타입 전용 필드가 유실**될 수 있음.
- 자기 자신을 참조하는 객체는 직렬화되지 않고 `JSONException` 발생.
- 같은 객체를 두 번 참조하는 참조 그래프는 역직렬화 시 **참조 객체의 복사본이 여러 개** 생성됨.
- `System.JSONParser` 타입 자체는 직렬화 불가 — 직렬화 가능한 클래스(예: Visualforce 컨트롤러)의 멤버 변수로 두면 예외. 메서드 내 로컬 변수로 사용할 것.

**버전별 동작 변화:**

- **API v63.0+:** 커스텀 예외 및 대부분의 내장 예외의 JSON 직렬화 미지원 — 시도 시 `Type unsupported in JSON: MyException` 오류.
- **API v53.0+:** DateTime 처리 개선 — 소수점 이하 3자리 초과 자릿수 정상 처리, 미지원 포맷(예: `123456000`)은 오류.

**직렬화 동작 (serialize 메서드, 저장된 Apex의 API 버전 기준):**

- **쿼리 후 추가 설정한 필드:** v27.0 이하는 직렬화 결과에 미포함, **v28.0+ 포함**.
- **집계 쿼리 결과:** v27.0에서만 SELECT 필드 미포함(그 외 버전은 포함).
- **null 필드:** **v28.0+에서는 직렬화 결과에서 제외**(이전 버전은 포함). 역직렬화에는 영향 없음.
- **ID 왕복:** v34.0 이하에서는 JSON 왕복을 거친 ID의 `==` 비교가 실패.

**역직렬화 고려사항:** 집계 결과(AggregateResult) JSON은 이름 있는 필드가 없어 Apex `AggregateResult` 객체로 역직렬화 불가.

---

## 7. 어떤 JSON 키가 충돌하나 — 예약어 판별

> Apex 예약어 **전체 목록(Table 12, 121개 전수)과 식별자 사용 가능 특수 키워드 10개**는 [[Apex 언어 기초 — 예외 처리와 예약어]] 참조 — 이 노트에서는 재수록하지 않는다.

JSON 키가 그 목록에 있으면 래퍼 멤버 변수로 선언할 수 없으므로 §2의 우회 패턴이 필요하다. 외부 API 페이로드에서 **실제로 자주 부딪히는** 예약어 키:

| 예약어 키 | 흔한 등장 맥락 |
|---|---|
| `from` | 이메일·메시징 API (발신자) |
| `case` | 티켓팅·서포트 API |
| `currency`, `number` | 결제·주문 API |
| `date`, `time` | 일정·로그 API |
| `object`, `group`, `limit`, `select` | 범용 메타 필드 |

반대로 `after`, `before`, `count`, `order` 등 특수 키워드 10개는 예약어가 **아니라서** 멤버 변수명으로 그대로 쓸 수 있다 — 우회 불필요.

---

## 관련 노트

- [[Apex 표준 클래스 레퍼런스]] — §8 JSON 기본 사용법 (serialize/deserialize/deserializeUntyped 입문)
- [[Apex 언어 기초 — 예외 처리와 예약어]] — Apex 예약어 전체 목록(Table 12 전수) + 특수 키워드 10개
- [[RestClient 패턴]] — 콜아웃 응답을 받는 쪽 HTTP 래퍼 패턴
- [[Custom REST Endpoint]] — 인바운드 REST에서 요청 본문 JSON 파싱
- [[DataWeave Namespace]] — 스크립트 기반 JSON/CSV 변환 대안 (복잡한 매핑·변환 로직)
- [[Dom Namespace]] — XML 응답일 때의 카운터파트 (Dom.Document / Dom.XmlNode)
