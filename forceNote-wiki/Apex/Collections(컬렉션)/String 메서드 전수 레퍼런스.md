---
tags: [apex, reference, string, primitive, standard-class, methods]
source: salesforce_apex_reference_guide.pdf (v67.0 Summer '26, String Class)
created: 2026-07-08
aliases: [String 메서드, String Methods, Apex String, isBlank isEmpty, escapeSingleQuotes, substring split, String.format, String.join, String.valueOf, template 문자열 보간, String 인스턴스 메서드 전수]
---

# String 메서드 전수 레퍼런스

> Apex `System.String` 기본 타입의 인스턴스·정적 메서드 전수 — 검사·변환·추출·포맷·이스케이프 카테고리별 시그니처 표. 공식 Apex Reference Guide(Summer '26) `String Class` 발췌.

---

## 개요

- **네임스페이스:** `System`
- 모든 String 메서드 정의는 **Unicode Standard**를 따른다. 예를 들어 Unicode 로마 숫자는 digit이 아니라 number form으로 분류되므로 `isAlphanumeric()`은 로마 숫자가 포함된 String에 `false`를 반환한다.
- `String.xxx(...)` 형태의 **정적(static) 메서드**와 `str.xxx(...)` 형태의 **인스턴스 메서드**가 섞여 있다. 아래 표에서 시그니처에 `static`이 붙은 것이 정적 메서드다. (`isBlank`·`isEmpty`·`isNotBlank`·`isNotEmpty`·`escapeSingleQuotes`·`format`·`fromCharArray`·`getCommonPrefix`·`join`·`valueOf`·`valueOfGmt`가 정적.)

```apex
// 인스턴스 메서드 vs 정적 메서드
String s = 'Hello Maximillian';
String abbr = s.abbreviate(8);            // 인스턴스: 'Hello...'
Boolean blank = String.isBlank('   ');    // 정적:     true
```

---

## 1. 검사 (Boolean / 비교)

빈 값·문자 구성·포함·시작/끝·동등성·순서를 판정한다. `is*(inputString)` 4종만 정적이고 나머지는 인스턴스다.

| 메서드 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| isBlank(inputString) | `static Boolean isBlank(String inputString)` | Boolean | 지정 String이 공백·빈 문자열(`''`)·null이면 true |
| isEmpty(inputString) | `static Boolean isEmpty(String inputString)` | Boolean | 지정 String이 빈 문자열(`''`) 또는 null이면 true |
| isNotBlank(inputString) | `static Boolean isNotBlank(String inputString)` | Boolean | 공백도 빈 문자열도 null도 아니면 true |
| isNotEmpty(inputString) | `static Boolean isNotEmpty(String inputString)` | Boolean | 빈 문자열도 null도 아니면 true |
| isAllLowerCase() | `Boolean isAllLowerCase()` | Boolean | 모든 문자가 소문자면 true |
| isAllUpperCase() | `Boolean isAllUpperCase()` | Boolean | 모든 문자가 대문자면 true |
| isAlpha() | `Boolean isAlpha()` | Boolean | 모든 문자가 Unicode 문자(letter)만이면 true |
| isAlphaSpace() | `Boolean isAlphaSpace()` | Boolean | 모든 문자가 Unicode letter 또는 공백만이면 true |
| isAlphanumeric() | `Boolean isAlphanumeric()` | Boolean | 모든 문자가 Unicode letter 또는 digit만이면 true (로마 숫자는 false) |
| isAlphanumericSpace() | `Boolean isAlphanumericSpace()` | Boolean | 모든 문자가 letter·digit·공백만이면 true |
| isAsciiPrintable() | `Boolean isAsciiPrintable()` | Boolean | ASCII 인쇄 가능 문자만 포함하면 true |
| isNumeric() | `Boolean isNumeric()` | Boolean | Unicode digit만 포함하면 true (소수점 `1.2`는 digit 아님) |
| isNumericSpace() | `Boolean isNumericSpace()` | Boolean | Unicode digit 또는 공백만 포함하면 true |
| isWhitespace() | `Boolean isWhitespace()` | Boolean | 공백 문자만 있거나 비어 있으면 true |
| contains(substring) | `Boolean contains(String substring)` | Boolean | substring 시퀀스를 포함하면 true |
| containsAny(inputString) | `Boolean containsAny(String inputString)` | Boolean | inputString의 문자 중 하나라도 포함하면 true |
| containsIgnoreCase(substring) | `Boolean containsIgnoreCase(String substring)` | Boolean | 대소문자 무시하고 substring을 포함하면 true |
| containsNone(inputString) | `Boolean containsNone(String inputString)` | Boolean | inputString의 문자를 하나도 포함하지 않으면 true (inputString이 null이면 런타임 예외) |
| containsOnly(inputString) | `Boolean containsOnly(String inputString)` | Boolean | inputString의 문자만으로 구성되면 true |
| containsWhitespace() | `Boolean containsWhitespace()` | Boolean | 공백 문자를 하나라도 포함하면 true |
| startsWith(prefix) | `Boolean startsWith(String prefix)` | Boolean | prefix로 시작하면 true |
| startsWithIgnoreCase(prefix) | `Boolean startsWithIgnoreCase(String prefix)` | Boolean | 대소문자 무시하고 prefix로 시작하면 true |
| endsWith(suffix) | `Boolean endsWith(String suffix)` | Boolean | suffix로 끝나면 true |
| endsWithIgnoreCase(suffix) | `Boolean endsWithIgnoreCase(String suffix)` | Boolean | 대소문자 무시하고 suffix로 끝나면 true |
| equals(secondString) | `Boolean equals(String secondString)` | Boolean | **Deprecated** (`equals(stringOrId)`로 대체). null이 아니고 같은 이진 시퀀스면 true. 대소문자 구분 비교 |
| equals(stringOrId) | `Boolean equals(Object stringOrId)` | Boolean | null이 아니고 같은 이진 시퀀스면 true. String이나 ID를 나타내는 Object와 비교. 15자/18자 ID는 길이 달라도 동일 판정 |
| equalsIgnoreCase(secondString) | `Boolean equalsIgnoreCase(String secondString)` | Boolean | 대소문자 무시하고 같은 시퀀스면 true. context user의 locale 무시 → `==`보다 빠름 |
| compareTo(secondString) | `Integer compareTo(String secondString)` | Integer | 사전식(lexicographical) 비교. 음수=선행, 양수=후행, 0=동일. `equals`가 true면 항상 0 |

> `==` 연산자는 Apex 시맨틱상 **대소문자 무시** 비교다. 대소문자를 구분하려면 `equals()`/`compareTo()`를 쓴다.

```apex
System.assert(String.isBlank('   '));                 // true
System.assert(!'Hello'.equals('hello'));              // 대소문자 구분 → false
System.assert('abcd'.equalsIgnoreCase('ABCD'));       // true
System.assertEquals(1, 'abcde'.compareTo('abcd'));    // 선행 String이 더 김 → 양수
```

---

## 2. 검색·인덱스·거리 (위치/개수/코드포인트)

문자·부분문자열의 위치, 개수, 코드포인트, 편집거리 등 **Integer** 계열 조회.

| 메서드 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| length() | `Integer length()` | Integer | String에 포함된 16비트 Unicode 문자 수 |
| charAt(index) | `Integer charAt(Integer index)` | Integer | 지정 index 문자의 값. surrogate pair 시작이면 high-surrogate 코드포인트만 반환 |
| codePointAt(index) | `Integer codePointAt(Integer index)` | Integer | 지정 index의 Unicode 코드포인트 값 (surrogate pair면 보충 코드포인트) |
| codePointBefore(index) | `Integer codePointBefore(Integer index)` | Integer | 지정 index **이전**의 Unicode 코드포인트 값 |
| codePointCount(beginIndex, endIndex) | `Integer codePointCount(Integer beginIndex, Integer endIndex)` | Integer | beginIndex~endIndex−1 범위 내 코드포인트 개수 |
| offsetByCodePoints(index, codePointOffset) | `Integer offsetByCodePoints(Integer index, Integer codePointOffset)` | Integer | index에서 codePointOffset개 코드포인트만큼 이동한 index |
| indexOf(substring) | `Integer indexOf(String substring)` | Integer | substring 첫 출현 index. 없으면 −1 |
| indexOf(substring, index) | `Integer indexOf(String substring, Integer index)` | Integer | index부터 substring 첫 출현의 0-based index. 없으면 −1 |
| indexOfAny(substring) | `Integer indexOfAny(String substring)` | Integer | substring의 문자 중 하나라도 처음 나오는 0-based index. 없으면 −1 |
| indexOfAnyBut(substring) | `Integer indexOfAnyBut(String substring)` | Integer | substring에 **없는** 문자가 처음 나오는 0-based index. 없으면 −1 |
| indexOfChar(character) | `Integer indexOfChar(Integer character)` | Integer | 지정 문자값의 첫 출현 index (Unicode code unit). 없으면 −1 |
| indexOfChar(character, startIndex) | `Integer indexOfChar(Integer character, Integer startIndex)` | Integer | startIndex부터 지정 문자값 첫 출현 index. 없으면 −1 |
| indexOfDifference(stringToCompare) | `Integer indexOfDifference(String stringToCompare)` | Integer | 두 String이 처음 달라지는 0-based index |
| indexOfIgnoreCase(substring) | `Integer indexOfIgnoreCase(String substring)` | Integer | 대소문자 무시 substring 첫 출현 0-based index. 없으면 −1 |
| indexOfIgnoreCase(substring, startPosition) | `Integer indexOfIgnoreCase(String substring, Integer startPosition)` | Integer | startPosition부터 대소문자 무시 첫 출현 0-based index. 없으면 −1 |
| lastIndexOf(substring) | `Integer lastIndexOf(String substring)` | Integer | substring 마지막 출현 index. 없으면 −1 |
| lastIndexOf(substring, endPosition) | `Integer lastIndexOf(String substring, Integer endPosition)` | Integer | index 0~endPosition 범위 내 마지막 출현 index |
| lastIndexOfChar(character) | `Integer lastIndexOfChar(Integer character)` | Integer | 지정 문자값의 마지막 출현 index |
| lastIndexOfChar(character, endIndex) | `Integer lastIndexOfChar(Integer character, Integer endIndex)` | Integer | endIndex까지에서 지정 문자값 마지막 출현 index |
| lastIndexOfIgnoreCase(substring) | `Integer lastIndexOfIgnoreCase(String substring)` | Integer | 대소문자 무시 substring 마지막 출현 index |
| lastIndexOfIgnoreCase(substring, endPosition) | `Integer lastIndexOfIgnoreCase(String substring, Integer endPosition)` | Integer | index 0~endPosition 범위 내 대소문자 무시 마지막 출현 index |
| countMatches(substring) | `Integer countMatches(String substring)` | Integer | substring이 나타나는 횟수 |
| difference(secondString) | `String difference(String secondString)` | String | 두 String의 차이 부분 반환 (secondString이 null이면 예외, 빈 문자열이면 빈 문자열) |
| getCommonPrefix(strings) | `static String getCommonPrefix(List<String> strings)` | String | 모든 String에 공통인 선행 문자 시퀀스 |
| getLevenshteinDistance(stringToCompare) | `Integer getLevenshteinDistance(String stringToCompare)` | Integer | 두 String 간 Levenshtein 편집 거리(삽입·삭제·치환 횟수) |
| getLevenshteinDistance(stringToCompare, threshold) | `Integer getLevenshteinDistance(String stringToCompare, Integer threshold)` | Integer | 거리 ≤ threshold면 거리, 아니면 −1 |
| hashCode() | `Integer hashCode()` | Integer | 이 문자열의 해시 코드 값 (Java `String.hashCode` 기반) |

```apex
System.assertEquals(2, 'abcde'.indexOf('cd'));
System.assertEquals(4, 'abcdabcd'.indexOf('ab', 1));
System.assertEquals(2, 'Hello Hello'.countMatches('Hello'));
System.assertEquals(3, 'Hello Joe'.getLevenshteinDistance('Hello Max'));
System.assertEquals('SFDC', String.getCommonPrefix(new List<String>{'SFDCApex', 'SFDCVisualforce'}));
```

---

## 3. 변환 (대소문자·공백·case·패딩·축약)

원본을 정규화하거나 형태를 바꾼 **새 String**을 반환한다. 전부 인스턴스 메서드.

| 메서드 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| toLowerCase() | `String toLowerCase()` | String | 기본(en-US) locale 규칙으로 전부 소문자화 |
| toLowerCase(locale) | `String toLowerCase(String locale)` | String | 지정 locale 규칙으로 소문자화 |
| toUpperCase() | `String toUpperCase()` | String | 기본(en-US) locale 규칙으로 전부 대문자화 |
| toUpperCase(locale) | `String toUpperCase(String locale)` | String | 지정 locale 규칙으로 대문자화 (예: `'tr'` 터키어) |
| capitalize() | `String capitalize()` | String | 첫 글자를 title case로 변경 (`Character.toTitleCase` 기반) |
| uncapitalize() | `String uncapitalize()` | String | 첫 글자를 소문자로 변경 |
| swapCase() | `String swapCase()` | String | 모든 문자의 대소문자를 뒤바꿈 (기본 en-US locale) |
| reverse() | `String reverse()` | String | 모든 문자를 역순으로 |
| trim() | `String trim()` | String | 선행·후행 공백 문자 제거한 복사본 |
| normalizeSpace() | `String normalizeSpace()` | String | 선행·후행·반복 공백 문자 제거 |
| deleteWhitespace() | `String deleteWhitespace()` | String | 모든 공백 문자 제거 |
| stripHtmlTags() | `String stripHtmlTags()` | String | HTML 마크업 제거하고 plain text 반환 |
| abbreviate(maxWidth) | `String abbreviate(Integer maxWidth)` | String | maxWidth 길이로 축약, 길면 말줄임표(...) 추가 (maxWidth<4면 런타임 예외) |
| abbreviate(maxWidth, offset) | `String abbreviate(Integer maxWidth, Integer offset)` | String | 지정 offset부터 maxWidth 길이로 축약, 양끝 필요 시 말줄임표 |
| center(size) | `String center(Integer size)` | String | size 길이로 좌우 공백 패딩해 가운데 정렬 (size가 더 작으면 원본 반환) |
| center(size, paddingString) | `String center(Integer size, String paddingString)` | String | size 길이로 지정 문자열 좌우 패딩해 가운데 정렬 |
| leftPad(length) | `String leftPad(Integer length)` | String | length가 되도록 왼쪽에 공백 패딩 |
| leftPad(length, padStr) | `String leftPad(Integer length, String padStr)` | String | length가 되도록 왼쪽에 padStr 패딩 |
| rightPad(length) | `String rightPad(Integer length)` | String | length가 되도록 오른쪽에 공백 패딩 |
| rightPad(length, padStr) | `String rightPad(Integer length, String padStr)` | String | length가 되도록 오른쪽에 padStr 패딩 |
| repeat(numberOfTimes) | `String repeat(Integer numberOfTimes)` | String | 현재 String을 지정 횟수만큼 반복 |
| repeat(separator, numberOfTimes) | `String repeat(String separator, Integer numberOfTimes)` | String | separator로 구분하며 지정 횟수만큼 반복 |

```apex
System.assertEquals('Hello maximillian', 'hello maximillian'.capitalize());
System.assertEquals('HelloJane', ' Hello Jane '.deleteWhitespace());
System.assertEquals('Hello...', 'Hello Maximillian'.abbreviate(8));
System.assertEquals('--hello--', 'hello'.center(9, '-'));
```

---

## 4. 추출·조작 (substring·remove·replace·split)

부분 문자열을 잘라내거나, 제거/치환/분할한다.

| 메서드 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| substring(startIndex) | `String substring(Integer startIndex)` | String | 0-based startIndex부터 끝까지 |
| substring(startIndex, endIndex) | `String substring(Integer startIndex, Integer endIndex)` | String | startIndex부터 endIndex−1 문자까지 |
| substringAfter(separator) | `String substringAfter(String separator)` | String | separator 첫 출현 **뒤** 부분 |
| substringAfterLast(separator) | `String substringAfterLast(String separator)` | String | separator 마지막 출현 **뒤** 부분 |
| substringBefore(separator) | `String substringBefore(String separator)` | String | separator 첫 출현 **앞** 부분 |
| substringBeforeLast(separator) | `String substringBeforeLast(String separator)` | String | separator 마지막 출현 **앞** 부분 |
| substringBetween(tag) | `String substringBetween(String tag)` | String | 동일 tag 두 인스턴스 사이 부분 |
| substringBetween(open, close) | `String substringBetween(String open, String close)` | String | open·close 두 문자열 사이 부분 |
| left(length) | `String left(Integer length)` | String | 왼쪽에서 length개 문자 |
| right(length) | `String right(Integer length)` | String | 오른쪽에서 length개 문자 |
| mid(startIndex, length) | `String mid(Integer startIndex, Integer length)` | String | 0-based startIndex부터 length개 문자 |
| remove(substring) | `String remove(String substring)` | String | substring의 모든 출현 제거 |
| removeStart(substring) | `String removeStart(String substring)` | String | substring이 **시작**에 있을 때만 제거 |
| removeStartIgnoreCase(substring) | `String removeStartIgnoreCase(String substring)` | String | 대소문자 무시하고 시작 substring 제거 |
| removeEnd(substring) | `String removeEnd(String substring)` | String | substring이 **끝**에 있을 때만 제거 |
| removeEndIgnoreCase(substring) | `String removeEndIgnoreCase(String substring)` | String | 대소문자 무시하고 끝 substring 제거 |
| replace(target, replacement) | `String replace(String target, String replacement)` | String | 리터럴 target 시퀀스를 리터럴 replacement로 전부 치환 |
| replaceAll(regExp, replacement) | `String replaceAll(String regExp, String replacement)` | String | 정규식 regExp 매칭 부분을 전부 replacement로 치환 |
| replaceFirst(regExp, replacement) | `String replaceFirst(String regExp, String replacement)` | String | 정규식 regExp 첫 매칭만 replacement로 치환 |
| split(regExp) | `String[] split(String regExp)` | List\<String\> | 정규식 regExp 또는 문자열 끝으로 종료되는 각 부분문자열 리스트 |
| split(regExp, limit) | `String[] split(String regExp, Integer limit)` | List\<String\> | limit개까지 분할한 부분문자열 리스트 |
| splitByCharacterType() | `List<String> splitByCharacterType()` | List\<String\> | 문자 type별로 분할, 동일 type 연속 그룹을 토큰으로 |
| splitByCharacterTypeCamelCase() | `List<String> splitByCharacterTypeCamelCase()` | List\<String\> | 문자 type별 분할 (단, 소문자 앞의 대문자는 뒤 토큰에 속함 — camelCase 처리) |

```apex
System.assertEquals('cde', 'abcde'.substring(2));       // 2번부터 끝
System.assertEquals('ab', 'abcde'.left(2));
System.assertEquals(new List<String>{'a','b','c'}, 'a,b,c'.split(','));
System.assertEquals('a-b-c', 'a.b.c'.replace('.', '-'));
```

---

## 5. 포맷·조인·변환 (format·join·valueOf)

패턴 치환, 컬렉션 조인, 다른 타입 → String 변환. **정적 메서드가 많다.**

| 메서드 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| format(stringToFormat, formattingArguments) | `static String format(String stringToFormat, List<Object> formattingArguments)` | String | `{0}`,`{1}`... 패턴을 List 인자로 치환 (Java `MessageFormat`·`apex:outputText` 규칙). 비-String 값은 `toString()` 오버라이드 존중 |
| join(iterableObj, separator) | `static String join(Object iterableObj, String separator)` | String | List 등 iterable 요소를 separator로 이어붙임 |
| valueOf(toConvert) | `static String valueOf(Object toConvert)` | String | Object 인자의 문자열 표현 |
| valueOf(dateToConvert) | `static String valueOf(Date dateToConvert)` | String | Date를 `yyyy-MM-dd` 형식으로 |
| valueOf(datetimeToConvert) | `static String valueOf(Datetime datetimeToConvert)` | String | Datetime을 로컬 타임존 `yyyy-MM-dd HH:mm:ss` 형식으로 |
| valueOf(decimalToConvert) | `static String valueOf(Decimal decimalToConvert)` | String | Decimal의 문자열 표현 |
| valueOf(doubleToConvert) | `static String valueOf(Double doubleToConvert)` | String | Double의 문자열 표현 |
| valueOf(integerToConvert) | `static String valueOf(Integer integerToConvert)` | String | Integer의 문자열 표현 |
| valueOf(longToConvert) | `static String valueOf(Long longToConvert)` | String | Long의 문자열 표현 |
| valueOfGmt(datetimeToConvert) | `static String valueOfGmt(Datetime datetimeToConvert)` | String | Datetime을 GMT 타임존 `yyyy-MM-dd HH:mm:ss` 형식으로 |
| fromCharArray(charArray) | `static String fromCharArray(List<Integer> charArray)` | String | 정수 리스트(문자값)로부터 String 생성 |
| getChars() | `List<Integer> getChars()` | List\<Integer\> | 문자열의 각 문자값 배열. `/`가 있으면 unescape됨 |

> **`format()` 버전별 동작:** version 51.0 이상에서는 `stringToFormat` 파라미터의 **작은따옴표(`'`)를 지원**하고 `formattingArguments`로 포맷된 문자열을 반환한다. version 50.0 이하에서는 작은따옴표 미지원. → [[Apex 버전별 동작 변경 레퍼런스]]

```apex
String template = '{0} was last updated {1}';
List<Object> params = new List<Object>{'Universal Containers', DateTime.newInstance(2018,11,15)};
String formatted = String.format(template, params);

String joined = String.join(new List<Integer>{1,2,3}, '-');   // '1-2-3'
System.assertEquals('J', String.fromCharArray(new List<Integer>{74}));
System.assertEquals(74, 'Jane'.getChars()[0]);                // 'J' == 74
```

---

## 6. 인코딩·이스케이프 (escape / unescape)

CSV·HTML·XML·Java·EcmaScript·Unicode·SOQL 컨텍스트로 안전 이스케이프하거나 되돌린다.

| 메서드 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| escapeSingleQuotes(stringToEscape) | `static String escapeSingleQuotes(String stringToEscape)` | String | 작은따옴표(`'`)·백슬래시 앞에 이스케이프 문자(백슬래시)를 추가. **동적 SOQL 인젝션 방지**에 사용 |
| escapeCsv() | `String escapeCsv()` | String | CSV 컬럼용. 쉼표·개행·큰따옴표 있으면 큰따옴표로 감싸고 내부 `"`는 `""`로 |
| escapeEcmaScript() | `String escapeEcmaScript()` | String | EcmaScript 규칙 이스케이프 (작은따옴표·`/`도 이스케이프) |
| escapeHtml3() | `String escapeHtml3()` | String | HTML 3.0 엔티티로 이스케이프 |
| escapeHtml4() | `String escapeHtml4()` | String | HTML 4.0 엔티티로 이스케이프 |
| escapeJava() | `String escapeJava()` | String | Java String 규칙으로 이스케이프 (따옴표·tab·백슬래시·CR 등) |
| escapeUnicode() | `String escapeUnicode()` | String | Unicode 문자를 Unicode escape sequence로 |
| escapeXml() | `String escapeXml()` | String | XML 엔티티로 (기본 5개 gt·lt·quot·amp·apos만, 0x7f 초과는 이스케이프 안 함) |
| unescapeCsv() | `String unescapeCsv()` | String | CSV 컬럼 unescape |
| unescapeEcmaScript() | `String unescapeEcmaScript()` | String | EcmaScript 리터럴 unescape |
| unescapeHtml3() | `String unescapeHtml3()` | String | HTML 3.0 엔티티 unescape |
| unescapeHtml4() | `String unescapeHtml4()` | String | HTML 4.0 엔티티 unescape |
| unescapeJava() | `String unescapeJava()` | String | Java 리터럴 unescape (`\"`, `\t`, `\n` 등) |
| unescapeUnicode() | `String unescapeUnicode()` | String | 이스케이프된 Unicode 문자 unescape |
| unescapeXml() | `String unescapeXml()` | String | XML 엔티티 unescape |

```apex
// 동적 SOQL 인젝션 방지 — 사용자 입력을 쿼리에 넣기 전 이스케이프
String userInput = '\'; DELETE FROM Account; --';
String safe = String.escapeSingleQuotes(userInput);
// escapeCsv
System.assertEquals('"Max1, ""Max2"""', 'Max1, "Max2"'.escapeCsv());
```

> `escapeSingleQuotes`만으로는 충분하지 않다 — 바인드 변수 우선. 상세는 [[SOQL Injection 위협]] 참조.

---

## 7. Summer '26 관련 — `template()` 문자열 보간

`template()`는 문자열 내 `${variableName}` 플레이스홀더를 Map 값으로 치환한다. **일반 리터럴과 멀티라인 문자열 리터럴(`'''...'''`)을 모두 지원**한다.

| 메서드 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| template(valueMap) | `String template(Map<String, Object> valueMap)` | String | `${var}` 플레이스홀더를 valueMap의 대응 값으로 치환 |

- `${variableName}` 구문으로 플레이스홀더를 표기한다.
- `${}` 사이 리터럴 텍스트를 넣으려면 `$`로 이스케이프한다 (`$${hello}` → 리터럴 `${hello}`).
- valueMap의 비-String 값은 `toString()` 오버라이드로 암시적 문자열 변환된다.
- **누락 변수 기본값 미지원** — 문자열에 있는 변수가 valueMap 키에 없으면 `StringException` 발생.
- 날짜 포맷 등 암시적 포맷 조회 미지원 — 먼저 Apex 메서드로 포맷 후 값을 넘긴다.

```apex
// 단일 라인 리터럴
String formatted = '${name} was last updated ${date}'.template(new Map<String, Object>{
    'name' => 'My class',
    'date' => DateTime.newInstance(2018, 11, 15)
});

// 멀티라인 리터럴 — JSON body 구성
String schoolCity = 'exampleCity';
String schoolName = 'exampleSchool';
String jsonBody = '''
{
  "city" : "${sc}",
  "name" : "${sn}"
}
'''.template(new Map<String, Object>{ 'sc' => schoolCity, 'sn' => schoolName });
```

---

## 관련 노트

- [[Apex 표준 클래스 레퍼런스]] — Apex 내장 클래스 전체 개요(이 노트는 그 중 String 섹션의 전수 승격판)
- [[Date·Datetime·Math 메서드 전수 레퍼런스]] — 병렬 primitive 표준 클래스 전수 레퍼런스(Date/Datetime/Time/Math). 같은 계열의 짝 노트
- [[SOQL Injection 위협]] — `escapeSingleQuotes`의 실제 사용처, 바인드 변수 우선 원칙
- [[Apex 버전별 동작 변경 레퍼런스]] — `format()` v51.0 작은따옴표 지원 등 버전별 동작 변경
