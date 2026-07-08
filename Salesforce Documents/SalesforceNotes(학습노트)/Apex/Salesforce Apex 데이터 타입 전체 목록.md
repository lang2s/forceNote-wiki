---
tags: [apex, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Apex Data Type]
---

# Salesforce Apex 데이터 타입 전체 목록

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## Primitive 데이터 타입

- **Boolean:** true/false 값.
- **Integer:** 소수점 없는 32비트 숫자.
- **Long:** 소수점 없는 64비트 숫자.
- **Decimal:** 소수점 있는 64비트 숫자. 통화 같은 정밀 계산에 사용.
- **Double:** 소수점 있는 64비트 숫자. Decimal과 유사하나 배정밀도.
- **Date:** 일·월·년으로 구성된 날짜 값.
- **Datetime:** 시간대 포함 특정 날짜와 시간.
- **Time:** 날짜 없는 특정 시간.
- **String:** 문자 시퀀스.
- **ID:** Salesforce 레코드의 고유 식별자.
- **Blob:** 바이너리 데이터(파일·이미지).

## List (배열)

순서가 있고 중복을 포함할 수 있는 컬렉션. 요소가 인덱싱됨(인덱스 0부터). 순서 유지나 위치 접근이 필요할 때 유용.
```apex
List<String> fruits = new List<String>();
fruits.add('Apple'); fruits.add('Banana'); fruits.add('Apple'); // 중복 허용
System.debug(fruits[1]); // Banana
```

## Set

순서 없는 고유 요소 컬렉션. 중복 불가. 중복 제거·멤버십 테스트·집합 연산에 유용.
```apex
Set<String> uniqueFruits = new Set<String>();
uniqueFruits.add('Apple'); uniqueFruits.add('Banana'); uniqueFruits.add('Apple'); // 추가 안 됨
System.debug(uniqueFruits.contains('Banana')); // true
```

## Map

키-값 쌍 컬렉션. 각 고유 키가 하나의 값에 매핑. 키는 primitive, 값은 컬렉션 포함 모든 타입.
```apex
Map<String, Integer> fruitCounts = new Map<String, Integer>();
fruitCounts.put('Apple', 10); fruitCounts.put('Banana', 20);
System.debug(fruitCounts.get('Apple')); // 10
fruitCounts.put('Apple', 15); // 값 업데이트
```

## 각 타입 상세

**Integer:**

소수점 없는 32비트 정수(-2,147,483,648 ~ 2,147,483,647). 카운팅·루프 반복에 사용. 예: 장바구니 itemCount.

**Boolean:**

true/false/null. 제어문에서 프로그램 흐름 결정. 예: 할인 자격 isDiscountApplicable.

**Date:**

시간 정보 없는 날짜. 날짜+시간은 DateTime. 예: `Date projectDeadline = projectStart.addDays(30);`

**Long:**

큰 정수 저장용 64비트 숫자. 예: 센트 단위 거래 금액 `Long totalTransactionAmountInCents = 2500000000L;`

**Decimal:**

고정밀 64비트 숫자(금융 계산). 예: `Decimal totalPrice = itemPrice + (itemPrice * taxRate);`

**Double:**

큰 범위·소수점 64비트 숫자(과학 계산, 정밀도 덜 중요). 예: 천문 거리.

**Time:**

날짜와 무관한 시간. 예: `Time reminderTime = Time.newInstance(14, 30, 0, 0); // 2:30 PM`

**Enum:**

상수 집합 정의. 가독성 향상·값 제한. 예:
```apex
public Enum TicketStatus { NEW, OPEN, PENDING, RESOLVED, CLOSED }
TicketStatus currentStatus = TicketStatus.NEW;
```

**String:**

텍스트. 예: `String customerName = 'Jane Doe';`

**ID:**

Salesforce 레코드 고유 식별. 예: `ID contactId = '0031N00001bXkQ9QAK';`

**Blob:**

바이너리 데이터(파일·이미지). 예: `Blob fileContent = Blob.valueOf('...');`
