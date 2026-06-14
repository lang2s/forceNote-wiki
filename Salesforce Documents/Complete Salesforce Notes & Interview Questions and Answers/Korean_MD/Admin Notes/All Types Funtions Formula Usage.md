# Salesforce 수식 함수 종합 가이드

> Account 오브젝트 예시와 함께 Salesforce 함수 목록을 정리했습니다. (수식과 예시는 원문 유지, 시나리오 설명은 한글 번역)

**1. ABS(number)** — 목표 매출과 실제 매출의 절대 차이 계산.
`ABS(AnnualRevenue - Target_Revenue__c)` → AnnualRevenue=50000, Target=60000이면 결과 10000.

**2. ACOS(number)** — 커스텀 필드의 아크코사인(라디안) 계산.
`ACOS(Cosine_Value__c)` → 0.5이면 1.047 라디안.

**3. ADDMONTHS(date, num)** — CreatedDate에 6개월 추가(후속일 계산).
`ADDMONTHS(CreatedDate, 6)` → "2024-01-31"이면 2024-07-31.

**4. AND(logical1, logical2, ...)** — VIP이면서 연 매출 $1,000,000 초과인지 확인.
`AND(VIP__c = TRUE, AnnualRevenue > 1000000)` → 둘 다 충족 시 TRUE.

**5. ASCII(text)** — 이름 첫 글자의 ASCII 값(검증용).
`ASCII(LEFT(Name, 1))` → "Acme Corp"이면 65("A").

**6. ASIN(number)** — 커스텀 숫자 필드의 아크사인.
`ASIN(Sine_Value__c)` → 0.5이면 0.523 라디안.

**7. ATAN(number)** — 비율 기반 필드의 아크탄젠트.
`ATAN(Ratio__c)` → 1이면 0.785 라디안.

**8. ATAN2(y, x)** — 두 위치 기반 필드 간 각도 계산.
`ATAN2(Y_Coordinate__c, X_Coordinate__c)` → (2,1)이면 1.107 라디안.

**9. BEGINS(text, compare_text)** — 이름이 "Global"로 시작하는지 확인.
`BEGINS(Name, "Global")` → "Global Tech Inc"이면 TRUE.

**10. BLANKVALUE(expression, substitute)** — Industry가 비어 있으면 기본값 제공.
`BLANKVALUE(Industry, "Not Specified")` → 비어 있으면 "Not Specified".

**11. BR()** — 여러 필드를 줄바꿈으로 연결.
`Name & BR() & BillingCity & BR() & BillingCountry` → Acme Corp / New York / USA.

**12. CASE(expression, value1, result1, ..., else)** — 직원 수로 계정 분류.
`CASE(NumberOfEmployees, 50, "Small", 500, "Medium", 5000, "Large", "Enterprise")` → 50이면 "Small".

**13. CASESAFEID(id)** — 15자리 ID를 18자리 case-safe ID로 변환.
`CASESAFEID(Id)` → 001xx000003NG1E를 001xx000003NG1EAAA로.

**14. CEILING(number)** — 예상 매출을 가장 가까운 정수로 올림.
`CEILING(Projected_Revenue__c)` → 125.4이면 126.

**15. CHR(number)** — ASCII 코드로 문자 생성.
`CHR(65)` → A.

**16. CONTAINS(text, compare_text)** — 설명에 "Partner"가 포함되는지 확인.
`CONTAINS(Description, "Partner")` → "Global Partner for Solutions"이면 TRUE.

**17. COS(number)** — 커스텀 필드 각도의 코사인.
`COS(Angle_Radians__c)` → PI()/3이면 0.5.

**18. CURRENCYRATE(IsoCode)** — 외화 매출을 기업 통화로 변환.
`AnnualRevenue * CURRENCYRATE(CurrencyIsoCode)` → 100000, EUR(환율 1.1)이면 110000.

**19. DATE(year, month, day)** — 커스텀 계약 시작일 생성.
`DATE(2024, 11, 19)` → 2024-11-19.

**20. DATETIMEVALUE(expression)** — 텍스트 일시를 datetime 형식으로 변환.
`DATETIMEVALUE(Custom_Text_Date__c)` → "2024-11-19 10:30:00"이면 2024-11-19T10:30:00.000Z.

**21. DATEVALUE(expression)** — CreatedDate의 날짜 부분 추출.
`DATEVALUE(CreatedDate)` → 2024-11-19.

**22. DAY(date)** — CloseDate의 일(day) 추출.
`DAY(CloseDate)` → "2024-11-19"이면 19.

**23. DAYOFYEAR(date)** — 연중 며칠째인지 계산.
`DAYOFYEAR(CloseDate)` → "2024-11-19"이면 324.

**24. DISTANCE(location, location, unit)** — 두 위치 간 거리(km).
`DISTANCE(GEOLOCATION(BillingLatitude, BillingLongitude), GEOLOCATION(37.7749, -122.4194), 'km')` → LA-SF 약 559km.

**25. EXP(number)** — 성장 계수의 지수 계산.
`EXP(Growth_Rate__c)` → 1이면 2.718.

**26. FIND(search_text, text [, start])** — 이름에서 특정 단어 위치 찾기.
`FIND("Corp", Name)` → "Acme Corp"이면 6.

**27. FLOOR(number)** — 연 매출을 가장 가까운 정수로 내림.
`FLOOR(AnnualRevenue / 1000)` → 345600이면 345.

**28. FORMATDURATION(numSeconds [, includeDays])** — SLA 시간을 HH:MM:SS로 표시.
`FORMATDURATION(Resolution_Time__c)` → 3661초이면 01:01:01.

**29. FROMUNIXTIME(number)** — Unix 타임스탬프를 datetime으로 변환.
`FROMUNIXTIME(Last_Activity_Timestamp__c)` → 1700000000이면 2023-11-14T13:33:20.000Z.

**30. GEOLOCATION(latitude, longitude)** — 본사 위치 geolocation 필드 생성.
`GEOLOCATION(BillingLatitude, BillingLongitude)` → 34.0522, -118.2437.

**31. GETSESSIONID()** — 외부 시스템 통합용 세션 ID 사용.
`GETSESSIONID()` → 현재 세션 ID 반환.

**32. HOUR(expression)** — LastModifiedDate에서 시(hour) 추출.
`HOUR(LastModifiedDate)` → "14:45:00"이면 14.

**33. HYPERLINK(url, friendly_name [, target])** — 웹사이트 클릭 링크 생성.
`HYPERLINK(Website, "Visit Website", "_blank")`.

**34. IF(logical_test, value_if_true, value_if_false)** — 연 매출 $1M 초과 시 "Large Account".
`IF(AnnualRevenue > 1000000, "Large Account", "Small Account")` → 500000이면 "Small Account".

**35. IMAGE(image_url, alternate_text [, height, width])** — 로고 표시.
`IMAGE(Logo_URL__c, "Company Logo", 100, 100)`.

**36. INCLUDES(multiselect_picklist, text)** — 다중 선택에 "Enterprise" 포함 확인.
`INCLUDES(Account_Types__c, "Enterprise")` → "Enterprise; SMB"이면 TRUE.

**37. INITCAP(text)** — 이름의 첫 글자 대문자화.
`INITCAP(Name)` → "acme corporation"이면 "Acme Corporation".

**38. ISBLANK(expression)** — Phone 필드가 비어 있는지 확인.
`ISBLANK(Phone)` → ""이면 TRUE.

**39. ISNULL(expression)** — 커스텀 필드가 null인지 확인.
`ISNULL(Customer_Code__c)` → null이면 TRUE.

**40. ISNUMBER(text)** — Account Code가 숫자만 포함하는지 검증.
`ISNUMBER(Account_Code__c)` → "12345"이면 TRUE.

**41. ISOWEEK(date)** — 마지막 활동일의 ISO 주 번호.
`ISOWEEK(LastActivityDate)` → "2024-01-03"이면 1.

**42. ISOYEAR(date)** — 마지막 활동의 ISO 연도.
`ISOYEAR(LastActivityDate)` → "2024-01-03"이면 2024.

**43. ISPICKVAL(picklist, text)** — Industry가 "Technology"인지 확인.
`ISPICKVAL(Industry, "Technology")` → TRUE.

**44. LEFT(text, num_chars)** — 이름의 첫 5글자.
`LEFT(Name, 5)` → "Acme Corporation"이면 "Acme ".

**45. LEN(text)** — 이름 길이.
`LEN(Name)` → "Acme Corporation"이면 16.

**46. LN(number)** — 성장률의 자연로그.
`LN(Growth_Rate__c)` → 2.718이면 1.

**47. LOG(number)** — 밑 10 로그.
`LOG(Revenue_Growth__c)` → 1000이면 3.

**48. LOWER(text)** — 이름 소문자화.
`LOWER(Name)` → "acme corporation".

**49. LPAD(text, length [, pad_string])** — 계정 번호를 선행 0으로 10자리 패딩.
`LPAD(Account_Number__c, 10, "0")` → "1234"이면 "0000001234".

**50. MAX(number, ...)** — 두 매출 필드 중 최대값.
`MAX(AnnualRevenue, Projected_Revenue__c)` → (500000, 750000)이면 750000.

**51. MCEILING(number)** — 음수면 0 방향으로 올림.
`MCEILING(Discount_Percentage__c)` → -4.3이면 -4.

**52. MFLOOR(number)** — 음수면 0 반대 방향으로 내림.
`MFLOOR(Discount_Percentage__c)` → -4.3이면 -5.

**53. MID(text, start_num, num_chars)** — 6번째부터 5글자 추출.
`MID(Name, 6, 5)` → "Acme Corporation"이면 "Corpo".

**54. MILLISECOND(expression)** — 밀리초 추출.
`MILLISECOND(LastModifiedDate)` → ...30.123Z이면 123.

**55. MIN(number, ...)** — 연 매출과 임계값 중 작은 값.
`MIN(AnnualRevenue, 100000)` → 50000이면 50000.

**56. MINUTE(expression)** — 분 추출.
`MINUTE(CreatedDate)` → 14:45:30이면 45.

**57. MOD(number, divisor)** — 나머지(티어 시스템).
`MOD(AnnualRevenue, 10000)` → 253000이면 3000.

**58. MONTH(date)** — 생성 월.
`MONTH(CreatedDate)` → "2024-11-19"이면 11.

**59. NOT(logical)** — VIP가 아닌지 확인.
`NOT(VIP__c)` → TRUE이면 FALSE.

**60. NOW()** — 현재 일시.
`NOW()` → 2024-11-19T14:45:00.000Z.

**61. NULLVALUE(expression, substitute)** — Phone이 null이면 기본값.
`NULLVALUE(Phone, "No Phone Provided")`.

**62. OR(logical1, ...)** — VIP이거나 연 매출 $1M 초과.
`OR(VIP__c = TRUE, AnnualRevenue > 1000000)` → 하나라도 충족 시 TRUE.

**63. PI()** — 원형 영역 면적 계산.
`PI() * (Territory_Radius__c ^ 2)` → 10이면 314.16.

**64. PICKLISTCOUNT(multiselect_picklist)** — 다중 선택의 선택 값 개수.
`PICKLISTCOUNT(Account_Types__c)` → "Enterprise; SMB; Partner"이면 3.

**65. REVERSE(text)** — 이름 뒤집기.
`REVERSE(Name)` → "Acme Corp"이면 "proC emcA".

**66. RIGHT(text, num_chars)** — 이름의 마지막 5글자.
`RIGHT(Name, 5)` → "Acme Corporation"이면 "ation".

**67. ROUND(number, num_digits)** — 천 단위 반올림.
`ROUND(AnnualRevenue, -3)` → 123456이면 123000.

**68. RPAD(text, length [, pad_string])** — 후행 0으로 10자리 패딩.
`RPAD(Account_Number__c, 10, "0")` → "1234"이면 "1234000000".

**69. SECOND(expression)** — 초 추출.
`SECOND(CreatedDate)` → 14:45:30이면 30.

**70. SIN(number)** — 각도의 사인.
`SIN(Angle_Radians__c)` → PI()/2이면 1.

**71. SQRT(number)** — 제곱근.
`SQRT(Area__c)` → 144이면 12.

**72. SUBSTITUTE(text, old, new)** — "Corp"를 "Corporation"으로 교체.
`SUBSTITUTE(Name, "Corp", "Corporation")` → "Acme Corp"이면 "Acme Corporation".

**73. TAN(number)** — 각도의 탄젠트.
`TAN(Angle_Radians__c)` → PI()/4이면 1.

**74. TEXT(value)** — 연 매출을 텍스트로 변환.
`TEXT(AnnualRevenue)` → 500000이면 "500000".

**75. TIMENOW()** — 날짜 없는 현재 시간.
`TIMENOW()` → "14:45:00".

**76. TIMEVALUE(expression)** — 시간 부분 추출.
`TIMEVALUE(LastModifiedDate)` → "14:45:00".

**77. TODAY()** — 현재 날짜.
`TODAY()` → "2024-11-19".

**78. TRIM(text)** — 여분 공백 제거.
`TRIM(Name)` → " Acme Corp "이면 "Acme Corp".

**79. TRUNC(number, num_digits)** — 천 단위 절삭.
`TRUNC(AnnualRevenue, -3)` → 123456이면 123000.

**80. UNIXTIMESTAMP(date/time)** — CreatedDate를 Unix 타임스탬프로.
`UNIXTIMESTAMP(CreatedDate)` → 2024-11-19T00:00:00Z이면 1731974400.

**81. UPPER(text)** — 대문자화.
`UPPER(Name)` → "ACME CORP".

**82. VALUE(text)** — 숫자 텍스트를 숫자로 변환.
`VALUE(Account_Code__c)` → "12345"이면 12345.

**83. WEEKDAY(date)** — 생성 요일.
`WEEKDAY(CreatedDate)` → "2024-11-19"이면 3(화요일).

**84. YEAR(date)** — 연도 추출.
`YEAR(CreatedDate)` → "2024-11-19"이면 2024.
