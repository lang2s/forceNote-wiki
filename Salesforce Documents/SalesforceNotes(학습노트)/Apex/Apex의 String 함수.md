---
tags: [apex, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [String Function in Apex]
---

# Apex의 String 함수

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

Apex의 String 클래스는 문자열을 조작·처리하는 다양한 메서드를 제공합니다.

## 1. 문자열 조작 함수

**toUpperCase() & toLowerCase():** 대/소문자 변환.
```apex
'Hello Apex'.toUpperCase(); // "HELLO APEX"
'Hello Apex'.toLowerCase(); // "hello apex"
```

**trim() & trimLeft() & trimRight():** 공백 제거(양쪽/왼쪽/오른쪽).

**replace() & replaceAll():** 문자열 일부 교체.
```apex
'Hello Apex'.replace('Apex', 'Salesforce'); // "Hello Salesforce"
'123456789'.replaceAll('\\d', '*'); // "*********"
```

**substring(start, end):** 부분 문자열 추출.
```apex
'Salesforce'.substring(0, 5); // "Sales"
'Salesforce'.substring(5);    // "force"
```

**split(regex):** 문자열을 리스트로 분할.
```apex
'Apex,Java,Python'.split(','); // (Apex, Java, Python)
```

**String.join(List, separator):** 리스트를 하나의 문자열로 결합.
```apex
String.join(new List<String>{'Hello', 'Apex', 'World'}, ' '); // "Hello Apex World"
```

## 2. 문자열 검색 함수

**contains():** 부분 문자열 포함 여부.
**startsWith() & endsWith():** 시작/끝 확인.
**indexOf() & lastIndexOf():** 부분 문자열 첫/마지막 위치.
```apex
'Apex is great, and Apex is powerful'.indexOf('Apex');     // 0
'Apex is great, and Apex is powerful'.lastIndexOf('Apex'); // 18 (예시)
```

## 3. 문자열 비교 함수

**equals() & equalsIgnoreCase():** 두 문자열 비교(대소문자 무시 여부).
```apex
'Hello'.equals('hello');            // false
'Hello'.equalsIgnoreCase('hello');  // true
```

**compareTo() & compareToIgnoreCase():** 사전순 비교(음수/양수).

**deleteWhitespace():** 문자열의 공백 제거. `'Hello World'.deleteWhitespace(); // HelloWorld`

## 4. 기타 유용한 함수

**isBlank() & isEmpty():** 빈 문자열·공백 확인. isEmpty()는 ""일 때만 true, isBlank()는 빈 문자열이거나 공백만 있어도 true.

**valueOf():** 다른 데이터 타입을 문자열로 변환. `String.valueOf(100); // "100"`

**String.format():** 플레이스홀더({0}, {1})로 문자열 형식화.
```apex
String.format('Hello {0}, welcome to {1}!', new List<Object>{'Muthu', 'Apex'});
// "Hello Muthu, welcome to Apex!"
```

## 요약표

toUpperCase/toLowerCase(대소문자), trim/trimLeft/trimRight(공백 제거), replace/replaceAll(교체), substring(추출), split(분할), join(결합), contains(포함), startsWith/endsWith(시작·끝), indexOf/lastIndexOf(위치), equals/equalsIgnoreCase(일치), compareTo(사전순 비교), isBlank/isEmpty(빈 값 확인), valueOf(타입 변환), format(형식화).
