---
tags: [apex, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Apex Basics part 1]
---

# Apex 기초 Part 1

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

> (원본은 이미지 PDF로 OCR 추출했습니다.)

## Apex의 데이터 타입

Apex는 Salesforce 플랫폼 애플리케이션 구축용 언어입니다. Primitive 데이터 타입은 단일 값을 저장하는 기본 타입: Integer, Decimal, Double, Boolean, String, Date, Time, Datetime.

- **Decimal:** 128비트 십진 표현으로 높은 정밀도. 금융 계산·정밀도가 중요한 상황에 적합. `Decimal myDecimal = 3.141592653589793238;`
- **Double:** Decimal보다 낮은 정밀도의 64비트 배정밀도 부동소수점. 더 빠르고 메모리 적게 사용하나 정밀도가 중요하면 부적합. `Double myDouble = 3.141592653589793;`
- **Long:** 큰 정수(64비트). `Long largeNumber = 999999999L;`
- **Integer:** 소수점 없는 정수(32비트).

## 변수 선언

```apex
Integer Number = 2;
```
Apex는 정적 타입 언어로 변수 생성 시 데이터 타입을 선언해야 합니다. `=`는 할당 연산자, `;`는 문장 종결자입니다.

## 문자열 변수

Apex에서 문자열 리터럴은 작은따옴표(')로 감쌉니다. 큰따옴표(")는 사용하지 않습니다(컴파일 오류 발생).
```apex
String Name = 'ash';
system.debug(Name);
```

## 상수 변수

`final` 키워드로 선언하면 한 번만 값을 할당할 수 있습니다. 재할당 시 `System.FinalException: Final variable has already been initialized` 오류.
```apex
Final Integer Price = 25000;
```

## Null

명시적 값이 없으면 변수는 자동으로 null로 초기화됩니다. null은 0이나 빈 문자열과 다르며 값의 부재를 의미합니다. null 객체를 역참조하면 `System.NullPointerException`.

## Illegal Assignment

Apex는 강타입 언어로 변수의 데이터 타입이 할당 값과 호환되어야 합니다. (예: Integer를 String으로 직접 캐스팅 불가. `String y = String.valueOf(x);` 사용.)

## 조건문

**if-else:**

짝수/홀수 확인.
```apex
Integer num = 20;
if (num % 2 == 0) { System.debug('Even'); }
else { System.debug('Odd'); }
```

**Nested IF:**

여러 조건을 계층적으로 확인(예: 금액 구간별 할인율).

**Switch:**

표현식이 여러 값 중 하나와 일치하는지 테스트. 일치하지 않으면 `when else` 실행. 표현식 타입은 Integer, Long, sObject, String, Enum만 가능(Decimal·Boolean 불가).
```apex
Switch on fruitName {
    When 'Apple' { System.debug('sweet and crisp'); }
    When else { System.debug('Unknown fruit'); }
}
```

## 삼항 연산자(Ternary)

`result = (condition) ? expression_if_true : expression_if_false;` — if-else를 간결하게 표현. 단순 로직·가독성에 적합(복잡한 로직·중첩 조건에는 if-else).

## 루프

**For 루프:**

`for (initialization; condition; increment) { }`. i가 5를 초과하면 자연스럽게 종료.

**While 루프:**

조건이 참인 동안 반복. 처음부터 거짓이면 아무것도 실행 안 함.

**Do-While:**

본문을 최소 한 번 실행 후 조건 확인. (최소 한 번 실행이 필요하면 do-while, 처음부터 조건 불충족 시 건너뛰려면 while.)

**Break:**

루프 종료. 과도한 사용은 가독성을 해침.

**Continue:**

현재 반복의 나머지를 건너뛰고 다음 반복으로. (continue 전에 증감을 하지 않으면 무한 루프로 CPU 시간 한도 초과 가능.)

## 루프의 장점

동적 반복(요소 수를 미리 몰라도 컬렉션 반복), 반복 작업 자동화, 효율성·재사용성(한 번 작성해 여러 번 실행, 중복 감소), 짧고 깔끔한 코드.
