---
tags: [apex, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Apex Development]
---

# Apex 기본 개발 주제

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## Apex 언어 구성 요소

**데이터 타입** — 모든 정보를 데이터라 합니다. Salesforce의 데이터 유형: 1) Primitive, 2) sObject, 3) Collection, 4) Enum.

## Primitive 데이터 타입

개발자가 간단한 값을 다루도록 제공됩니다. 변수 선언, 연산, 데이터 조작에 사용합니다. 유형: Integer, Long, Double, Decimal, Date, Date/Time, Boolean, String, ID.

**Integer:** 정수 저장. 범위 -2,147,483,648 ~ 2,147,483,648. `Integer x=10;`

**Long:** 9자리 초과 정수. 범위 약 ±9.22×10¹⁸. `Long num3 = 1234567890123456L;`

**Double:** 소수점이 있는 부동소수점. 범위 -1.79E308 ~ 1.79E308.

**Decimal:** 정밀한 소수 값. 금융 처리·고정밀에 사용. 범위 -10³⁸ ~ 10³⁸. `Decimal num1 = 10.5;`

**Decimal vs Double:** Decimal은 고정밀(금융), Double은 부동소수점.

**String:** 이름·제품 설명 같은 텍스트. `String name = 'Monika';`

**Date:** 날짜 값(시간 미포함). 날짜+시간은 DateTime. `Date.today()`로 오늘 날짜.

## 예제 코드

```apex
// Decimal: 삼각형 넓이 = Base*Height*0.5
Decimal Base=100.56; Decimal Height=95.21;
Decimal Area=0.5*Base*Height;
System.debug('Area: ' + Area);

// 단리 계산기
Integer p=200; Decimal t=10.4; Double r=78.9;
Double Result = p*t*r/100;

// String
String Fullname = 'Monika' + ' ' + 'Perumal';
System.debug('Length: ' + Fullname.length());

// Date
Date dt1 = Date.today();
DateTime dt2 = DateTime.now();
Date dt3 = Date.newInstance(2024,4,13);
Date dt4 = Date.today().addDays(6);
```

## 연습 문제

1. 원기둥 넓이 = 2*pi*r*h + 2*pi*r²
2. 원뿔 표면적 = pi*r*s + pi*r²
3. 원 넓이 = pi*r*r
4. 5% 세금 = TaxableIncome*5/100 (TaxableIncome = Gross Salary − Total Deduction − Total Exemption)
