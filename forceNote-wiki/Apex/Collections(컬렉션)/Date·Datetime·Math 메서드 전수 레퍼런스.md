---
tags: [apex, reference, date, datetime, time, math, standard-class]
source: salesforce_apex_reference_guide.pdf (Date Class·Datetime Class·Time Class·Math Class)
created: 2026-07-08
aliases: [Date 메서드, Datetime 메서드, Time 메서드, Math 메서드, Date Class, Datetime Class, Time Class, Math Class, 날짜 메서드, 수학 메서드, addDays, daysBetween, formatGmt, roundToLong]
---

# Date·Datetime·Math 메서드 전수 레퍼런스

> `System.Date`·`System.Datetime`·`System.Time`·`System.Math` 네 클래스의 모든 메서드·필드를 시그니처·반환·설명까지 공식 레퍼런스 그대로 전수 수록. (기존 [[Apex 표준 클래스 레퍼런스]]의 Tier 3 부분발췌를 Tier 1/2 전수로 승격)

---

## GMT vs 로컬 타임존 — 반드시 이해할 함정

Date/Datetime 메서드의 절반은 **로컬(컨텍스트 사용자 타임존)** 판, 나머지 절반은 **GMT** 판으로 쌍을 이룬다. 같은 순간(instant)이라도 어느 판을 부르느냐에 따라 날짜·시간 성분이 달라진다.

> [!warning] 타임존 함정 핵심
> - `Datetime.now()`·`newInstance(...)`가 만드는 값은 **내부적으로 GMT 기준 순간**이다. `newInstance`의 인자는 **로컬 타임존**으로 해석되지만 저장은 GMT다 (반환 설명에 "The returned date is in the GMT time zone").
> - `day()`·`hour()`·`date()`·`format()` 등 접미사 없는 메서드는 **컨텍스트 사용자 타임존**으로 성분을 뽑는다. `dayGmt()`·`hourGmt()`·`dateGMT()`·`formatGmt()`는 **GMT**로 뽑는다.
> - 예: PST(GMT-8) 사용자가 `DateTime.newInstance(2006, 3, 16, 23, 0, 0)` (로컬 23시)를 만들면 → `date()`는 3/16, `dateGMT()`는 3/17 (GMT로는 이미 다음 날 07시).
> - `Time.newInstance(...)`는 **UTC 가정**이다.
> - `getTime()`은 항상 GMT 기준 epoch(1970-01-01 00:00:00 GMT) 이후 밀리초.
> - 배치·스케줄·정산처럼 "달의 경계"가 중요한 로직은 어느 타임존으로 성분을 뽑는지 반드시 명시할 것.

---

## 1. Date Class

`System` 네임스페이스. Date primitive 타입용 메서드. 인스턴스 메서드는 호출한 Date, static은 `Date.xxx()`.

### 1-1. 생성·파싱 (static)

| 메서드 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| `newInstance(year, month, day)` | `public static Date newInstance(Integer year, Integer month, Integer day)` | Date | year·month(1=Jan)·day 정수로 Date 생성 |
| `today()` | `public static Date today()` | Date | 현재 사용자 타임존의 오늘 날짜 |
| `parse(stringDate)` | `public static Date parse(String stringDate)` | Date | String → Date. 포맷은 **로컬 날짜 포맷**에 의존 |
| `valueOf(stringDate)` | `public static Date valueOf(String stringDate)` | Date | String → Date. 문자열은 로컬 타임존 표준 포맷 `yyyy-MM-dd HH:mm:ss` |
| `valueOf(fieldValue)` | `public static Date valueOf(Object fieldValue)` | Date | Object → Date. 히스토리 추적 필드(OldValue/NewValue) 변환용 |
| `daysInMonth(year, month)` | `public static Integer daysInMonth(Integer year, Integer month)` | Integer | 지정 연·월(1=Jan)의 일수 |
| `isLeapYear(year)` | `public static Boolean isLeapYear(Integer year)` | Boolean | 윤년이면 true |

### 1-2. 연산·성분 (인스턴스)

| 메서드 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| `addDays(additionalDays)` | `public Date addDays(Integer additionalDays)` | Date | 일수 가산 |
| `addMonths(additionalMonths)` | `public Date addMonths(Integer additionalMonths)` | Date | 월수 가산 |
| `addYears(additionalYears)` | `public Date addYears(Integer additionalYears)` | Date | 연수 가산 |
| `day()` | `public Integer day()` | Integer | 일(day-of-month) 성분 |
| `dayOfYear()` | `public Integer dayOfYear()` | Integer | 연중 일수(day-of-year) 성분 |
| `month()` | `public Integer month()` | Integer | 월 성분 (1=Jan) |
| `year()` | `public Integer year()` | Integer | 연 성분 |
| `daysBetween(secondDate)` | `public Integer daysBetween(Date secondDate)` | Integer | 두 날짜 사이 일수. 호출 Date가 secondDate보다 **뒤면 음수** |
| `monthsBetween(secondDate)` | `public Integer monthsBetween(Date secondDate)` | Integer | 두 날짜 사이 월수 (**일(day) 차이는 무시**) |
| `isSameDay(dateToCompare)` | `public Boolean isSameDay(Date dateToCompare)` | Boolean | 같은 날이면 true |
| `toStartOfMonth()` | `public Date toStartOfMonth()` | Date | 그 달의 1일 |
| `toStartOfWeek()` | `public Date toStartOfWeek()` | Date | 그 주의 시작(**로케일 의존** — 미국=일요일, 유럽=월요일) |
| `format()` | `public String format()` | String | 컨텍스트 사용자 로케일로 문자열 변환 |

```apex
// Date — 출처: salesforce_apex_reference_guide.pdf 예제 발췌
Date myDate = Date.newInstance(1960, 2, 17);
Date newDate = myDate.addDays(2);

Integer numberDays = Date.daysInMonth(1960, 2);   // 윤년 2월 → 29

Date firstDate  = Date.newInstance(2006, 12, 2);
Date secondDate = Date.newInstance(2012, 12, 8);
Integer months  = firstDate.monthsBetween(secondDate);
System.assertEquals(72, months);                  // 일 차이 무시

// American-English locale
Date d = Date.newInstance(2001, 3, 21);
System.assertEquals('3/21/2001', d.format());
```

> [!note] `Date.valueOf(Datetime)` 버전 변경 (API 54.0+)
> Datetime 객체를 `Date.valueOf`에 넘기면 API 54.0 이상에서는 **시간 정보 없는** 유효 Date로 변환된다. API 34.0~53.0에서는 Datetime을 어떻게 초기화했는지에 따라 시간 정보 포함 여부가 달라졌고, 33.0 이하에서는 시·분·초·밀리초를 그대로 포함했다.

---

## 2. Datetime Class

`System` 네임스페이스. Datetime primitive 타입용. Date → Datetime 캐스팅 시 시간 성분은 0으로 채워진다. **GMT/로컬 쌍**에 주의.

### 2-1. 생성 (static)

| 메서드 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| `now()` | `public static Datetime now()` | Datetime | 현재 Datetime (GMT 캘린더 기준). 반환 포맷 `MM/DD/YYYY HH:MM PERIOD` |
| `newInstance(milliseconds)` | `public static Datetime newInstance(Long milliseconds)` | Datetime | epoch(1970 GMT) 이후 밀리초로 생성. 반환은 **GMT** |
| `newInstance(date, time)` | `public static Datetime newInstance(Date date, Time time)` | Datetime | date+time (**로컬**)으로 생성 |
| `newInstance(year, month, day)` | `public static Datetime newInstance(Integer year, Integer month, Integer day)` | Datetime | 로컬 자정(00:00) |
| `newInstance(year, month, day, hour, minute, second)` | `public static Datetime newInstance(Integer year, Integer month, Integer day, Integer hour, Integer minute, Integer second)` | Datetime | 로컬 타임존 |
| `newInstanceGmt(date, time)` | `public static Datetime newInstanceGmt(Date date, Time time)` | Datetime | date+time (**GMT**) |
| `newInstanceGmt(year, month, date)` | `public static Datetime newInstanceGmt(Integer year, Integer month, Integer date)` | Datetime | GMT 자정 |
| `newInstanceGmt(year, month, date, hour, minute, second)` | `public static Datetime newInstanceGmt(Integer year, Integer month, Integer date, Integer hour, Integer minute, Integer second)` | Datetime | GMT 타임존 |
| `parse(datetimeString)` | `public static Datetime parse(String datetimeString)` | Datetime | 문자열 → Datetime. **로컬 타임존 + 사용자 로케일 포맷**. 반환은 GMT |
| `valueOf(dateTimeString)` | `public static Datetime valueOf(String dateTimeString)` | Datetime | 표준 포맷 `yyyy-MM-dd HH:mm:ss` (로컬). 반환은 GMT |
| `valueOf(fieldValue)` | `public static Datetime valueOf(Object fieldValue)` | Datetime | Object → Datetime. 히스토리 필드 변환용 |
| `valueOfGmt(dateTimeString)` | `public static Datetime valueOfGmt(String dateTimeString)` | Datetime | 표준 포맷 `yyyy-MM-dd HH:mm:ss` (**GMT**) |

### 2-2. 연산 (인스턴스)

| 메서드 | 시그니처 | 반환 |
|---|---|---|
| `addDays(additionalDays)` | `public Datetime addDays(Integer additionalDays)` | Datetime |
| `addHours(additionalHours)` | `public Datetime addHours(Integer additionalHours)` | Datetime |
| `addMinutes(additionalMinutes)` | `public Datetime addMinutes(Integer additionalMinutes)` | Datetime |
| `addMonths(additionalMonths)` | `public Datetime addMonths(Integer additionalMonths)` | Datetime |
| `addSeconds(additionalSeconds)` | `public Datetime addSeconds(Integer additionalSeconds)` | Datetime |
| `addYears(additionalYears)` | `public Datetime addYears(Integer additionalYears)` | Datetime |
| `getTime()` | `public Long getTime()` | Long — epoch(1970 GMT) 이후 밀리초 |

### 2-3. 성분 추출 — 로컬 vs GMT 쌍 (인스턴스)

| 로컬 메서드 | GMT 메서드 | 반환 | 설명 |
|---|---|---|---|
| `date()` → `public Date date()` | `dateGMT()` → `public Date dateGMT()` | Date | Date 성분 |
| `day()` → `public Integer day()` | `dayGmt()` → `public Integer dayGmt()` | Integer | 일(day-of-month) |
| `dayOfYear()` → `public Integer dayOfYear()` | `dayOfYearGmt()` → `public Integer dayOfYearGmt()` | Integer | 연중 일수 |
| `hour()` → `public Integer hour()` | `hourGmt()` → `public Integer hourGmt()` | Integer | 시 |
| `minute()` → `public Integer minute()` | `minuteGmt()` → `public Integer minuteGmt()` | Integer | 분 |
| `second()` → `public Integer second()` | `secondGmt()` → `public Integer secondGmt()` | Integer | 초 |
| `millisecond()` → `public Integer millisecond()` | `millisecondGmt()` → `public Integer millisecondGmt()` | Integer | 밀리초 |
| `month()` → `public Integer month()` | `monthGmt()` → `public Integer monthGmt()` | Integer | 월 (1=Jan) |
| `year()` → `public Integer year()` | `yearGmt()` → `public Integer yearGmt()` | Integer | 연 |
| `time()` → `public Time time()` | `timeGmt()` → `public Time timeGmt()` | Time | Time 성분 |
| `isSameDay(dateToCompare)` → `public Boolean isSameDay(Datetime dateToCompare)` | — | Boolean | 로컬 기준 같은 날이면 true |

### 2-4. 포맷 (인스턴스)

| 메서드 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| `format()` | `public String format()` | String | **로컬** 변환 + 컨텍스트 사용자 로케일. 타임존 미확정 시 GMT |
| `format(dateFormatString)` | `public String format(String dateFormatString)` | String | **로컬** 변환 + Java SimpleDateFormat 패턴 |
| `format(dateFormatString, timezone)` | `public String format(String dateFormatString, String timezone)` | String | 지정 타임존으로 변환 + 패턴. timezone은 Java `TimeZone.getAvailableIDs` 값(예: `America/New_York`, 3글자 약어 대신 full name 권장) |
| `formatGmt(dateFormatString)` | `public String formatGmt(String dateFormatString)` | String | **GMT** + Java SimpleDateFormat 패턴 |
| `formatLong()` | `public String formatLong()` | String | **로컬** 변환 + long date 포맷 (예: `12/28/2012 10:00:00 AM PST`) |

```apex
// Datetime — 출처: salesforce_apex_reference_guide.pdf 예제 발췌
// 로컬 vs GMT 경계 넘기 (PST 가정)
DateTime dt = DateTime.newInstance(2006, 3, 16, 23, 0, 0);
Date localDate = dt.date();      // 2006-3-16 (로컬)
Date gmtDate   = dt.dateGMT();   // 2006-3-17 (GMT는 +8h → 다음날 07시)

// format(pattern, timezone) — GMT 값을 뉴욕 시간으로 (DST 보정 포함)
Datetime gmt = Datetime.newInstanceGmt(2011, 6, 1, 12, 1, 5);
String s = gmt.format('MM/dd/yyyy HH:mm:ss', 'America/New_York');
System.assertEquals('06/01/2011 08:01:05', s);

// formatGmt
DateTime d = DateTime.newInstance(1993, 6, 6, 3, 3, 3);
System.assertEquals('Sun, Jun 6 1993 10:03:03', d.formatGMT('EEE, MMM d yyyy HH:mm:ss'));

// getTime — epoch 밀리초 (GMT)
DateTime e = DateTime.newInstanceGMT(2007, 6, 23, 3, 3, 3);
System.assertEquals(1182567783000L, e.getTime());
```

---

## 3. Time Class

`System` 네임스페이스. Time primitive 타입용. **UTC 가정.**

| 메서드 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| `newInstance(hour, minutes, seconds, milliseconds)` | `public static Time newInstance(Integer hour, Integer minutes, Integer seconds, Integer milliseconds)` | Time | 시·분·초·밀리초로 Time 생성 (**UTC 가정**) |
| `addHours(additionalHours)` | `public Time addHours(Integer additionalHours)` | Time | 시간 가산 |
| `addMinutes(additionalMinutes)` | `public Time addMinutes(Integer additionalMinutes)` | Time | 분 가산 |
| `addSeconds(additionalSeconds)` | `public Time addSeconds(Integer additionalSeconds)` | Time | 초 가산 |
| `addMilliseconds(additionalMilliseconds)` | `public Time addMilliseconds(Integer additionalMilliseconds)` | Time | 밀리초 가산 |
| `hour()` | `public Integer hour()` | Integer | 시 성분 |
| `minute()` | `public Integer minute()` | Integer | 분 성분 |
| `second()` | `public Integer second()` | Integer | 초 성분 |
| `millisecond()` | `public Integer millisecond()` | Integer | 밀리초 성분 |

```apex
// Time — 출처: salesforce_apex_reference_guide.pdf 예제 발췌
Time myTime   = Time.newInstance(18, 30, 2, 20);      // 18:30:02.020 (UTC)
Time expected = Time.newInstance(4, 2, 3, 4);
System.assertEquals(expected, Time.newInstance(1, 2, 3, 4).addHours(3));

Time t = Time.newInstance(3, 14, 15, 926);
System.assertEquals(926, t.millisecond());
```

---

## 4. Math Class

`System` 네임스페이스. 수학 연산. **모든 메서드는 static.** Decimal/Double 등 인자 타입별로 오버로드가 나뉜다.

### 4-1. 필드 (static final)

| 필드 | 시그니처 | 타입 | 설명 |
|---|---|---|---|
| `E` | `public static final Double E` | Double | 자연로그 밑 e |
| `PI` | `public static final Double PI` | Double | 원주율 π |

### 4-2. 절댓값·부호·나머지·거듭제곱·근

| 메서드 (오버로드) | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| `abs(decimalValue)` | `public static Decimal abs(Decimal decimalValue)` | Decimal | 절댓값 |
| `abs(doubleValue)` | `public static Double abs(Double doubleValue)` | Double | 절댓값 |
| `abs(integerValue)` | `public static Integer abs(Integer integerValue)` | Integer | 절댓값 |
| `abs(longValue)` | `public static Long abs(Long longValue)` | Long | 절댓값 |
| `signum(decimalValue)` | `public static Decimal signum(Decimal decimalValue)` | Decimal | 부호함수: 0/1.0/-1.0 |
| `signum(doubleValue)` | `public static Double signum(Double doubleValue)` | Double | 부호함수: 0/1.0/-1.0 |
| `mod(integerValue1, integerValue2)` | `public static Integer mod(Integer integerValue1, Integer integerValue2)` | Integer | v1 % v2 나머지 |
| `mod(longValue1, longValue2)` | `public static Long mod(Long longValue1, Long longValue2)` | Long | v1 % v2 나머지 |
| `pow(doubleValue, exponent)` | `public static Double pow(Double doubleValue, Double exponent)` | Double | doubleValue^exponent |
| `sqrt(decimalValue)` | `public static Decimal sqrt(Decimal decimalValue)` | Decimal | 양의 제곱근 |
| `sqrt(doubleValue)` | `public static Double sqrt(Double doubleValue)` | Double | 양의 제곱근 |
| `cbrt(decimalValue)` | `public static Decimal cbrt(Decimal decimalValue)` | Decimal | 세제곱근 (음수는 크기의 세제곱근에 음부호) |
| `cbrt(doubleValue)` | `public static Double cbrt(Double doubleValue)` | Double | 세제곱근 |
| `exp(exponentDecimal)` | `public static Decimal exp(Decimal exponentDecimal)` | Decimal | e^x |
| `exp(exponentDouble)` | `public static Double exp(Double exponentDouble)` | Double | e^x |
| `log(decimalValue)` | `public static Decimal log(Decimal decimalValue)` | Decimal | 자연로그(base e) |
| `log(doubleValue)` | `public static Double log(Double doubleValue)` | Double | 자연로그(base e) |
| `log10(decimalValue)` | `public static Decimal log10(Decimal decimalValue)` | Decimal | 상용로그(base 10) |
| `log10(doubleValue)` | `public static Double log10(Double doubleValue)` | Double | 상용로그(base 10) |
| `random()` | `public static Double random()` | Double | 0.0 ≤ x < 1.0 양의 난수 |

### 4-3. 최대·최소

| 메서드 | 시그니처 | 반환 |
|---|---|---|
| `max(decimalValue1, decimalValue2)` | `public static Decimal max(Decimal, Decimal)` | Decimal |
| `max(doubleValue1, doubleValue2)` | `public static Double max(Double, Double)` | Double |
| `max(integerValue1, integerValue2)` | `public static Integer max(Integer, Integer)` | Integer |
| `max(longValue1, longValue2)` | `public static Long max(Long, Long)` | Long |
| `min(decimalValue1, decimalValue2)` | `public static Decimal min(Decimal, Decimal)` | Decimal |
| `min(doubleValue1, doubleValue2)` | `public static Double min(Double, Double)` | Double |
| `min(integerValue1, integerValue2)` | `public static Integer min(Integer, Integer)` | Integer |
| `min(longValue1, longValue2)` | `public static Long min(Long, Long)` | Long |

### 4-4. 반올림·올림·내림

| 메서드 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| `ceil(decimalValue)` | `public static Decimal ceil(Decimal decimalValue)` | Decimal | 올림 (인자 이상 최소 정수, -∞ 방향에서 가장 가까움) |
| `ceil(doubleValue)` | `public static Double ceil(Double doubleValue)` | Double | 올림 |
| `floor(decimalValue)` | `public static Decimal floor(Decimal decimalValue)` | Decimal | 내림 (인자 이하 최대 정수) |
| `floor(doubleValue)` | `public static Double floor(Double doubleValue)` | Double | 내림 |
| `rint(decimalValue)` | `public static Decimal rint(Decimal decimalValue)` | Decimal | 가장 가까운 정수값 |
| `rint(doubleValue)` | `public static Double rint(Double doubleValue)` | Double | 가장 가까운 정수값 |
| `round(doubleValue)` | `public static Integer round(Double doubleValue)` | Integer | ⚠️ **Deprecated (Winter '08).** `roundToLong` 사용 권장. Int 범위 벗어나면 에러 |
| `round(decimalValue)` | `public static Integer round(Decimal decimalValue)` | Integer | **half-even(은행가) 반올림**, 0자리. Int 범위 벗어나면 에러 |
| `roundToLong(decimalValue)` | `public static Long roundToLong(Decimal decimalValue)` | Long | half-even 반올림, 0자리 |
| `roundToLong(doubleValue)` | `public static Long roundToLong(Double doubleValue)` | Long | 가장 가까운 Long |

> [!note] half-even 반올림 함정
> `Math.round(Decimal)`·`roundToLong(Decimal)`은 **half-even**(nearest-neighbor, 동점이면 짝수 쪽)이다. `Math.round(4.5)` → 4, `Math.round(5.5)` → 6. 통상적인 "5는 올림"과 다르니 금액 반올림 시 주의. (누적 오차를 통계적으로 최소화하는 모드)

### 4-5. 삼각·쌍곡선 함수 (전부 Decimal/Double 오버로드)

| 메서드 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| `sin(decimalAngle)` | `public static Decimal sin(Decimal decimalAngle)` | Decimal | 사인 |
| `sin(doubleAngle)` | `public static Double sin(Double doubleAngle)` | Double | 사인 |
| `cos(decimalAngle)` | `public static Decimal cos(Decimal decimalAngle)` | Decimal | 코사인 |
| `cos(doubleAngle)` | `public static Double cos(Double doubleAngle)` | Double | 코사인 |
| `tan(decimalAngle)` | `public static Decimal tan(Decimal decimalAngle)` | Decimal | 탄젠트 |
| `tan(doubleAngle)` | `public static Double tan(Double doubleAngle)` | Double | 탄젠트 |
| `asin(decimalAngle)` | `public static Decimal asin(Decimal decimalAngle)` | Decimal | 아크사인 (-π/2 ~ π/2) |
| `asin(doubleAngle)` | `public static Double asin(Double doubleAngle)` | Double | 아크사인 |
| `acos(decimalAngle)` | `public static Decimal acos(Decimal decimalAngle)` | Decimal | 아크코사인 (0.0 ~ π) |
| `acos(doubleAngle)` | `public static Double acos(Double doubleAngle)` | Double | 아크코사인 |
| `atan(decimalAngle)` | `public static Decimal atan(Decimal decimalAngle)` | Decimal | 아크탄젠트 (-π/2 ~ π/2) |
| `atan(doubleAngle)` | `public static Double atan(Double doubleAngle)` | Double | 아크탄젠트 |
| `atan2(xCoordinate, yCoordinate)` | `public static Decimal atan2(Decimal xCoordinate, Decimal yCoordinate)` | Decimal | 직교→극좌표 위상 theta (-π ~ π), arctan(x/y) |
| `atan2(xCoordinate, yCoordinate)` | `public static Double atan2(Double xCoordinate, Double yCoordinate)` | Double | 위 Double 오버로드 |
| `sinh(decimalAngle)` | `public static Decimal sinh(Decimal decimalAngle)` | Decimal | 쌍곡사인 (eˣ-e⁻ˣ)/2 |
| `sinh(doubleAngle)` | `public static Double sinh(Double doubleAngle)` | Double | 쌍곡사인 |
| `cosh(decimalAngle)` | `public static Decimal cosh(Decimal decimalAngle)` | Decimal | 쌍곡코사인 (eˣ+e⁻ˣ)/2 |
| `cosh(doubleAngle)` | `public static Double cosh(Double doubleAngle)` | Double | 쌍곡코사인 |
| `tanh(decimalAngle)` | `public static Decimal tanh(Decimal decimalAngle)` | Decimal | 쌍곡탄젠트, |값|<1 |
| `tanh(doubleAngle)` | `public static Double tanh(Double doubleAngle)` | Double | 쌍곡탄젠트 |

```apex
// Math — 출처: salesforce_apex_reference_guide.pdf 예제 발췌
System.assertEquals(42, Math.abs(-42));
System.assertEquals(156.6, Math.max(12.3, 156.6));
System.assertEquals(12.3, Math.min(12.3, 156.6));
System.assertEquals(0, Math.mod(12, 2));
System.assertEquals(2, Math.mod(8, 3));

// half-even 반올림
System.assertEquals(4, Math.round(4.5));   // 짝수 쪽으로
System.assertEquals(6, Math.round(5.5));
System.assertEquals(4L, Math.roundToLong(4.5));
```

> [!note] 이 PDF에는 없는 메서드
> 요청 목록의 `toDegrees`/`toRadians`는 이 버전 `salesforce_apex_reference_guide.pdf`의 Math Class 절에 존재하지 않아 수록하지 않았다(전수 원칙 — 소스에 없는 것은 만들지 않음). 각도↔라디안 변환이 필요하면 `angle * Math.PI / 180` 형태로 직접 계산한다.

---

## 관련 노트
- [[Apex 표준 클래스 레퍼런스]] — Apex 내장 클래스 전체 빠른 참조(허브). 이 노트는 그 Date/Time/DateTime·Math 절의 Tier 1/2 전수 승격판
- [[String 메서드 전수 레퍼런스]] — 병렬 문자열 클래스 전수 레퍼런스. 같은 Apex primitive 표준 클래스 계열
