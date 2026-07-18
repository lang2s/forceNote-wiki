---
tags: [admin, formula, formula-field, examples, reference]
source: salesforce_useful_formula_fields.pdf (Examples of Advanced Formula Fields, Last updated 2026-03-31)
created: 2026-07-18
aliases: [Formula 예제, Advanced Formula Fields, 수식 필드 예제, Formula Examples, HYPERLINK IMAGE CASE 예제, Date 수식]
---

# Formula 필드 예제 카탈로그

> 18개 업무 카테고리(계정·케이스·커미션·연락처·날짜·할인·기회·이미지 링크 등)에 걸친 109개 고급 수식 필드 예제 — 각 예제의 목적·수식 코드를 공식 예제집(Examples of Advanced Formula Fields)에서 전수.

---

## 개요

이 노트는 Salesforce 공식 예제집 *Examples of Advanced Formula Fields*(Last updated 2026-03-31)에 실린 **바로 복사·수정해 쓰는 실무 수식 모음**이다. 각 수식은 특정 오브젝트의 커스텀 필드를 전제로 하므로, 자신의 조직 필드명(`__c`)·피클리스트 값에 맞춰 조정한다. 여기 실린 코드는 **소스 PDF 원문 그대로** 옮긴 것이며, pdftotext 추출 과정에서 발생한 부호 손실이나 원문 자체의 오탈자는 `> 아티팩트/원문 주의` 콜아웃으로 별도 표기했다.

수식이 사용하는 함수(`IF`·`CASE`·`HYPERLINK`·`IMAGE`·`ADDMONTHS`·`MOD` 등)의 정의·문법·컨텍스트별 가용성은 이 카탈로그가 다루지 않는다 — [[Formula 필드]](개념·문법 허브)와 [[Formula 연산자·함수 레퍼런스]]를 참조.

### 18 카테고리

1. Account Management (계정 관리)
2. Account Media Service (계정 미디어 검색 링크)
3. Case Management (케이스 관리)
4. Commission Calculations (커미션 계산)
5. Contact Management (연락처 관리)
6. Data Categorization (데이터 분류)
7. Date (날짜·시간)
8. Discounting (할인)
9. Employee Services (직원 서비스)
10. Expense Tracking (경비 추적)
11. Financial Calculations (재무 계산)
12. Image Link (이미지 링크)
13. Integration Link (통합 링크)
14. Lead Management (리드 관리)
15. Metric (미터법 환산)
16. Opportunity Management (기회 관리)
17. Pricing (가격)
18. Scoring Calculations (스코어링)

---

## 1. Account Management (계정 관리)

계정 상세를 관리하는 수식.

### Account Rating
Annual Revenue·Billing Country·Type를 평가해 "Hot"·"Warm"·"Cold" 값을 부여한다.

```
IF (AND (AnnualRevenue > 10000000,
CONTAINS (CASE (BillingCountry, "United States", "US", "America", "US",
"USA", "US", "NA"), "US")),
IF(ISPICKVAL(Type, "Manufacturing Partner"), "Hot",
IF(OR (ISPICKVAL (Type, "Channel Partner/Reseller"),
ISPICKVAL(Type, "Installation Partner")), "Warm", "Cold")),
"Cold")
```

이 Account Rating 수식 필드는 cross-object 수식으로 연락처(Contact) 오브젝트에서도 참조할 수 있다.

```
Account.Account_Rating__c
```

### Account Region
계정의 Billing State/Province에 따라 "North"·"South"·"East"·"West"·"Central" 텍스트를 반환한다.

```
IF(ISBLANK(BillingState), "None",
IF(CONTAINS("AK:AZ:CA:HA:NV:NM:OR:UT:WA", BillingState), "West",
IF(CONTAINS("CO:ID:MT:KS:OK:TX:WY", BillingState), "Central",
IF(CONTAINS("CT:ME:MA:NH:NY:PA:RI:VT", BillingState), "East",
IF(CONTAINS("AL:AR:DC:DE:FL:GA:KY:LA:MD:MS:NC:NJ:SC:TN:VA:WV",
BillingState), "South",
IF(CONTAINS("IL:IN:IA:MI:MN:MO:NE:ND:OH:SD:WI", BillingState), "North",
"Other"))))))
```

### Contract Aging
계정과의 계약이 활성화된 이후 경과 일수를 계산한다. 계약 Status가 "Activated"가 아니면 필드는 빈 값이다.

```
IF(ISPICKVAL(Contract_Status__c, "Activated"),
NOW() - Contract_Activated_Date__c, null)
```

---

## 2. Account Media Service (계정 미디어 검색 링크)

특정 검색 사이트·미디어 계정으로 연결하는 링크 수식 (모두 `HYPERLINK`).

### BBC™ News Search
Account Name 기반 BBC 뉴스 검색 사이트 링크.

```
HYPERLINK(
"http://www.bbc.co.uk/search/news/?q="&Name,
"BBC News")
```

### Bloomberg™ News Search
계정의 ticker symbol을 Bloomberg 웹사이트에서 조회하는 링크.

```
HYPERLINK(
"http://www.bloomberg.com/markets/symbolsearch?query="&TickerSymbol,
"Bloomberg News")
```

### CNN™ News Search
Account Name을 이용한 CNN 뉴스 검색 사이트 링크.

```
HYPERLINK(
"http://http://www.cnn.com/search/?query="&Name,
"CNN News")
```

> 원문 주의: URL의 `http://http://`는 **소스 PDF 원문 자체의 오탈자**다(pdftotext 아티팩트 아님). 실제 사용 시 앞의 `http://` 하나를 제거한다.

### MarketWatch™ Search
계정의 ticker symbol을 Marketwatch.com에서 조회하는 링크.

```
HYPERLINK(
"http://www.marketwatch.com/investing/stock/"&TickerSymbol,
"Marketwatch")
```

### Google™ Search
Account Name을 이용한 Google 검색 링크.

```
HYPERLINK(
"http://www.google.com/#q="&Name,
"Google")
```

### Google News Search
Account Name을 이용한 Google 뉴스 검색 링크.

```
HYPERLINK(
"http://news.google.com/news/search?en&q="&Name,
"Google News")
```

### Yahoo!™ Search
Account Name을 이용한 Yahoo! 검색 링크.

```
HYPERLINK(
"http://search.yahoo.com/search?p="&Name,
"Yahoo Search")
```

### Yahoo! News Search
Account Name을 이용한 Yahoo! 뉴스 검색 링크.

```
HYPERLINK(
"http://news.search.yahoo.com/search/news?p="&Name,
"Yahoo News")
```

---

## 3. Case Management (케이스 관리)

케이스 상세를 관리하는 수식.

### Autodial
클릭하면 전화번호를 자동으로 다이얼하는 링크 필드. 예제의 `"servername"`·`"call"`을 실제 다이얼링 도구 이름과 명령으로 교체한다. 병합 필드 `Id`는 연락처·리드·계정 레코드 식별자를, 첫 `Phone`은 다이얼할 번호를, 마지막 `Phone`은 클릭 가능한 표시 텍스트를 제공한다.

```
HYPERLINK("http://servername/call?id=" & Id & "&phone=" &
Phone, Phone)
```

### Case Categorization
케이스 연령 커스텀 텍스트 필드 값에 따라 "RED"·"YELLOW"·"GREEN" 텍스트를 표시한다.

```
IF(DaysOpen__c > 20, "RED",
IF(DaysOpen__c > 10, "YELLOW",
"GREEN") )
```

### Case Data Completeness Tracking
특정 커스텀 필드에 데이터가 채워진 비율을 계산한다. 두 커스텀 숫자 필드(Problem Num·Severity Num)를 검사해 비어 있으면 0, 값이 있으면 각 1을 부여하고 총합에 50을 곱해 백분율을 낸다.

```
(IF(ISBLANK(Problem_Num__c), 0, 1) + IF(ISBLANK(Severity_Num__c ),
0,1)) * 50
```

### Suggested Agent Prompts
과거 구매 내역 기반으로 상담원에게 cross-sell 제안을 프롬프트한다.

```
CASE(Product_Purch__c,
"Printer", "Extra toner cartridges", "Camera", "Memory cards",
"Special of the day")
```

### Suggested Offers
컴퓨터 리셀러의 지원 이력 기반으로 제품을 제안한다. Problem 커스텀 필드가 일치하면 제안을 반환한다.

```
CASE(Problem__c,
"Memory", "Suggest new memory cards", "Hard Drive failure", "Suggest
new hard drive with tape backup",
"")
```

---

## 4. Commission Calculations (커미션 계산)

커미션 금액을 계산하는 수식.

### Commission Amounts for Opportunities
기회 Amount의 정액 2%를 커미션으로 계산하는 단순 수식. "Closed Won" 단계에만 적용되며 open·lost는 0.

```
IF(ISPICKVAL(StageName, "Closed Won"),
ROUND(Amount *0.02, 2), 0)
```

### Commission Deal Size
딜 규모 기반 커미션율. 100,000 초과는 9%, 그 이하는 8%.

```
IF(Amount > 100000, 0.09, 0.08 )
```

### Commission Greater Than or Equal To
커미션이 100만 이상이면 "YES" 값을 부여한다. Commission이라는 커스텀 통화 필드를 사용하는 텍스트 수식 필드다.

```
IF(Commission__c >=
1000000, "YES", "NO")
```

### Commission Maximum
자산에 기록할 커미션을 세 값 중 최댓값으로 결정한다: 사용자의 가격 대비 커미션 비율, 계정에 저장된 할인율을 곱한 가격, 또는 100달러. 사용자·자산에 커스텀 백분율 필드가 각각 있다고 가정한다.

```
MAX($User.Commission_Percent__c * Price,
Price * Account_Discount__c, 100)
```

---

## 5. Contact Management (연락처 관리)

연락처 상세를 관리하는 수식.

### Contact's Account Discount Percent
계정의 Discount Percent 필드를 연락처 페이지에 표시하는 백분율 수식.

```
Account.Discount_Percent__c
```

### Contact's Account Name
표준 Account Name 필드를 연락처 페이지에 표시.

```
Account.Name
```

### Contact's Account Phone
표준 Account Phone 필드를 연락처 페이지에 표시.

```
Account.Phone
```

### Contact's Account Rating
Account Rating 필드를 연락처 페이지에 표시.

```
CASE(Account.Rating, "Hot", "Hot", "Warm", "Warm", "Cold", "Cold",
"Not Rated")
```

### Contact's Account Website
표준 Account Website 필드를 연락처 페이지에 표시.

```
Account.Website
```

계정 웹사이트 URL이 길면 `HYPERLINK` 함수로 URL 대신 "Click Here" 같은 레이블을 표시할 수 있다. 이 수식은 URL 필드에 `http://`·`https://`가 없으면 필요한 `https://`를 앞에 추가한다.

```
IF(Account.Website="", "",
IF(
OR(LEFT(Account.Website, 7) = "http://",LEFT(Account.Website, 8) =
"https://"),
HYPERLINK( Account.Website , "Click Here" ),
HYPERLINK( "https://" & Account.Website , "Click Here" )
)
)
```

### Contact's LinkedIn™ Profile
연락처 프로필 페이지에 LinkedIn 프로필로 이동하는 링크를 구성한다. 설정 절차:

1. 연락처(Contact)의 오브젝트 관리 설정에서 Buttons, Links, and Actions로 이동한다.
2. New Button or Link를 클릭한다.
3. 이 링크의 Label(예: `LinkedInLink`)을 입력한다.
4. content box에 아래 수식을 입력한다.

```
https://www.linkedin.com/search/fpsearch?type=people&keywords
={!Contact.FirstName}+{!Contact.LastName}
```

5. Save를 클릭한다. 링크가 표시되도록 Contact 페이지 레이아웃에 추가해야 한다.

### Contact Identification Numbering
이름 첫 5자와 SSN 마지막 4자를 대시로 구분해 표시한다. SSN이라는 텍스트 커스텀 필드를 사용한다.

```
TRIM(LEFT(LastName, 5)) &
"-" & TRIM(RIGHT(SSN__c, 4))
```

### Contact Preferred Phone
Preferred Phone 커스텀 피클리스트 선택값에 따라 work·home·mobile 전화를 연락처 관련 목록에 표시한다.

```
CASE(Preferred_Phone__c,
"Work", "w. " & Phone,
"Home", "h. " & HomePhone,
"Mobile", "m. " & MobilePhone,
"No Preferred Phone")
```

### Contact Priority
계정 등급과 연락처 직함에 따라 중요도를 평가한다. Hot/직함이 Executive로 시작 → 높음(P1), Warm/직함이 VP로 시작 → 중간(P2), Cold → 낮음(P3).

```
IF(OR(ISPICKVAL(Account.Rating, "Hot"), CONTAINS(Title, "Executive")),
"P1",
IF(OR(ISPICKVAL(Account.Rating, "Warm"), CONTAINS(Title, "VP")), "P2",

IF(ISPICKVAL(Account.Rating, "Cold"), "P3",
"P3")
)
)
```

### Contact Yahoo! ID
클릭 가능한 Yahoo! Messenger 아이콘을 표시해 로그인 여부를 나타내고, 클릭 시 대화를 시작한다. 연락처의 Yahoo Name 커스텀 텍스트 필드를 사용한다.

```
HYPERLINK("ymsgr:sendIM?" & Yahoo_Name__c,
IMAGE("https://opi.yahoo.com/online?u=" &
Yahoo_Name__c &
"&m=g&t=0", "Yahoo"))
```

> 아티팩트 주의: 소스 dump에서는 URL 파라미터가 `"&m;=g&t;=0"`로 나타나지만 이는 **pdftotext가 삽입한 세미콜론**이다. 실제 값은 `&m=g&t=0`이며(동일 URL이 12장 Image Link의 Yahoo! IM Image 예제에 `&m=g&t=0`으로 확인됨) 위 코드블록은 정정본이다.

---

## 6. Data Categorization (데이터 분류)

데이터 분류용 수식.

### Dynamic Address Formatting
국가에 따라 적절한 공백·줄바꿈을 넣어 연락처의 우편 주소를 표준 형식으로 표시한다.

```
CASE(ShippingCountry,
"USA",
ShippingStreet & BR() &
ShippingCity & ",
" & ShippingState & " " &
ShippingPostalCode & BR()
& ShippingCountry,
"France",
ShippingStreet & BR() &
ShippingPostalCode & " " &
ShippingCity & BR() &
ShippingCountry, "etc")
```

### Phone Country Code
연락처의 Mailing Country에 따라 전화 국가 코드를 결정한다.

```
CASE(MailingCountry,
"USA", "1",
"Canada", "1",
"France", "33",
"UK", "44",
"Australia", "61",
"Japan", "81",
"?")
```

### Unformatted Phone Number
북미 전화번호에서 괄호·대시 문자를 제거한다. 일부 auto-dialer 소프트웨어에 필요하다.

```
IF(Country_Code__c = "1", MID( Phone ,2, 3) & MID(Phone,7,3) &
MID(Phone,11,4), Phone)
```

### Deal Size Large and Small
100만 달러 초과 딜은 "Large Deal", 그 미만은 "Small Deal"을 표시한다.

```
IF(Sales_Price__c > 1000000,
"Large Deal",
"Small Deal")
```

### Deal Size Small
가격·수량이 1 미만이면 "Small"을 표시한다. 1 초과면 필드는 빈 값이다.

```
IF(AND(Price<1,Quantity<1),"Small", null)
```

### Product Categorization
Product_Type 커스텀 텍스트 필드에 "part"가 포함되면 "Parts", 아니면 "Service"를 반환한다. 대소문자를 구분하므로 "Part"·"PART"는 "Service"를 반환한다.

```
IF(CONTAINS(Product_Type__c, "part"), "Parts", "Service")
```

---

## 7. Date (날짜·시간)

날짜 수식은 결제 마감·계약 연령 등 시간·날짜에 의존하는 기능을 관리하는 데 유용하다.

### 개념 프리앰블

**세 가지 데이터 타입**
- **Date** — 연·월·일을 저장. 날짜를 다루는 대부분의 값이 이 타입.
- **Date/Time** — 날짜 값에 더해 시간 값을 저장(GMT로 저장, 사용자 시간대로 표시). `CreatedDate` 등이 이 타입. 정밀도는 초(second).
- **Time** — 날짜와 독립적으로 시간(업무 시간 등)을 추적. 정밀도는 밀리초(millisecond).

**날짜 연산**
- Date/Date-Time/Time 값에 덧셈·뺄셈을 적용해 미래 날짜나 경과 시간을 계산할 수 있다.
- Date에서 Date를 빼면 결과는 **일(day) 단위 차이**(Number 타입).
- Date/Time에서 Date/Time을 빼면 일·시·분 차이를 나타내는 **소수 값**. 예: 차이가 5.52면 5일 12시간(0.5일) 28분(0.02일).
- Time에서 Time을 빼면 밀리초. `TODAY() + 3`은 오늘로부터 3일 뒤를 반환.
- 예제 전반에서 변수 `date`·`date/time`은 실제 Date/Date-Time 필드나 값의 자리표시자로 쓰인다.
- 복잡한 날짜 함수는 텍스트·숫자 함수보다 컴파일 크기가 커져 formula compile size 문제가 발생할 수 있다.

**TODAY() · NOW() · TIMENOW()**
- `TODAY()` — 현재 일·월·연을 Date 타입으로 반환.
- `NOW()` — 현재 순간의 Date/Time 값 반환.
- `TIMENOW()` — 날짜 없이 GMT 기준 현재 시각(Time) 반환. 시(hour)·분·초·밀리초가 필요하면 `NOW()` 대신 이것을 사용.

**DATE() 함수**
- `DATE( year, month, day )`는 Date 값을 반환. 숫자 Y/M/D 값과 `YEAR()`·`MONTH()`·`DAY()` 함수가 유효 인자. 예: `DATE( 2013, 6, 1 )` → 2013-06-01.
- 유효하지 않은 날짜를 넣으면 오류를 반환하므로 error checking이 중요.

**변환 함수 (Date ↔ Date/Time ↔ Time ↔ Text)**
- `DATEVALUE( date/time )` — Date/Time → Date. `YEAR()`·`MONTH()`·`DAY()`는 Date에만 동작하므로 Date/Time을 먼저 변환해야 한다.
- `DATETIMEVALUE( date )` — Date → Date/Time (시간은 GMT 00:00으로 설정 후 뷰어 시간대로 변환). 문자열(`"YYYY-MM-DD HH:MM:SS"`)을 넘기면 GMT 기준 Date/Time 반환.
- `TIMEVALUE( value )` — Date/Time·텍스트·병합 필드·식을 Time 값("HH:MM:SS.MS", 24시간제)으로 반환.
- `TEXT( value )` — Date/Time/Time을 문자열로. Date는 "YYYY-MM-DD" 형식으로 반환.

**시간대 주의**
- Date·Date/Time 값은 GMT로 저장된다. Date/Time 변환은 항상 사용자 시간대가 아닌 **GMT 기준**으로 수행된다.
- 텍스트나 Date를 Date/Time으로 변환한 값이 계산에 섞이면 시간대 차이로 예상과 다른 결과가 나온다. `TEXT(date/time)`은 GMT를 뜻하는 "Z"를 끝에 붙인다(빈 필드면 "Z"만 반환).
- 수식에서 사용자 시간대를 알아낼 방법은 없다. Date/Time ↔ Text·Date 변환이 필요한 트랜잭션은 **Apex 사용**이 권장된다.

### Sample Date Formulas

#### Find the Day, Month, or Year from a Date
`DAY( date )`·`MONTH( date )`·`YEAR( date )`로 숫자 값을 반환한다. `date`를 Date 타입 값(예: `TODAY()`)으로 대체한다. Date/Time 값에 쓰려면 먼저 `DATEVALUE()`로 변환한다.

```
DAY( DATEVALUE( date/time ))
```

#### Find Out If a Year Is a Leap Year
윤년 판정: 400으로 나누어떨어지거나, 4로는 나누어떨어지되 100으로는 안 나누어떨어지면 윤년.

```
OR(
MOD( YEAR( date ), 400 ) = 0,
AND(
MOD( YEAR( date ), 4 ) = 0,
MOD( YEAR( date ), 100 ) != 0
)
)
```

#### Find Which Quarter a Date Is In
표준 분기: 월을 3으로 나눠 ceiling을 취해 분기 번호(1–4)를 반환한다.

```
CEILING( MONTH ( date ) / 3 )
```

이동된 분기(Q1이 2월 시작 등): 월을 회계연도 첫 분기까지의 개월 수만큼 이동시킨다.

```
CEILING( ( MONTH ( date ) - 1 ) / 3)
```

현재 분기 여부 확인: 날짜의 연·분기를 `TODAY()`의 연·분기와 비교한다.

```
AND(
CEILING( MONTH( date ) / 3 ) = CEILING( MONTH( TODAY() ) / 3 ),
YEAR( date ) = YEAR( TODAY() )
)
```

#### Find the Week of the Year a Date Is In
연중 주차를 반환한다. `IF()`가 주차가 52를 초과하지 않도록 보장한다.

```
IF(
CEILING( ( date - DATE( YEAR( date ), 1, 1) + 1) / 7) > 52,
52,
CEILING( ( date - DATE( YEAR( date ), 1, 1) + 1) / 7)
)
```

#### Find Whether Two Dates Are in the Same Month
두 Date가 같은 월(같은 연도)에 속하는지 판정한다(예: 검증 규칙에서 Close Date가 이번 달인지).

```
AND(
MONTH( date_1 ) == MONTH( date_2 ),
YEAR( date_1 ) == YEAR( date_2 )
)
```

#### Find the Last Day of the Month
다음 달 1일을 구해 하루를 빼는 방식으로 월 마지막 날을 찾는다.

```
IF(
MONTH( date ) = 12,
DATE( YEAR( date ), 12, 31 ),
DATE( YEAR( date ), MONTH ( date ) + 1, 1 ) - 1
)
```

#### Display the Month as a String instead of a Number
월을 숫자 대신 텍스트 문자열로 반환한다.

```
CASE(
MONTH( date ),
1, "January",
2, "February",
3, "March",
4, "April",
5, "May",
6, "June",
7, "July",
8, "August",
9, "September",
10, "October",
11, "November",
"December"
)
```

다국어 조직이면 월 이름을 커스텀 레이블로 대체할 수 있다.

```
CASE(
MONTH( date ),
1, $Label.Month_of_Year_1,
2, $Label.Month_of_Year_2,
3, $Label.Month_of_Year_3,
4, $Label.Month_of_Year_4,
5, $Label.Month_of_Year_5,
6, $Label.Month_of_Year_6,
7, $Label.Month_of_Year_7,
8, $Label.Month_of_Year_8,
9, $Label.Month_of_Year_9,
10, $Label.Month_of_Year_10,
11, $Label.Month_of_Year_11,
$Label.Month_of_Year_12
)
```

#### Find and Display the Day of the Week from a Date
알려진 일요일(1900-01-07)을 date에서 빼고 `MOD(..., 7)`로 요일 숫자(0=일 ~ 6=토)를 구해 이름을 반환한다. 01/07/1900 이후 날짜에만 동작한다.

```
CASE(
MOD( date - DATE( 1900, 1, 7 ), 7 ),
0, "Sunday",
1, "Monday",
2, "Tuesday",
3, "Wednesday",
4, "Thursday",
5, "Friday",
"Saturday"
)
```

주가 월요일에 시작하면 조건에 1900-01-08을 쓴다.

```
CASE(
MOD( date - DATE( 1900, 1, 8 ), 7 ),
0, "Monday",
1, "Tuesday",
2, "Wednesday",
3, "Thursday",
4, "Friday",
5, "Saturday",
"Sunday"
)
```

#### Find the Next Day of the Week After a Date
주어진 Date 이후 특정 요일(`day_of_week`, 0=일 ~ 6=토)의 다음 발생일을 찾는다. `IF()`는 `day_of_week`가 date의 요일보다 앞설 때 7을 더해 처리한다.

```
date + ( day_of_week - MOD( date - DATE( 1900, 1, 7 ), 7 ) )
+
IF(
MOD( date - DATE( 1900, 1, 7 ), 7 ) >= day_of_week,
7,
0
)
```

#### Find the Number of Days Between Two Dates
두 날짜 사이의 일수는 나중 날짜에서 이른 날짜를 뺀다: `date_1 — date_2`. 특정 날짜가 오늘로부터 30일 이전인지 판정하려면:

```
TODAY() - 30 > date
```

#### Find the Number of Weekdays Between Two Dates
두 날짜 사이의 평일(월–금) 수 계산. 과거의 기준 월요일을 잡아 각 날짜까지의 완전한 주 수와 부분 주를 구하고 5(주 5일 근무)를 곱한 뒤 **두 값의 차를 취한다**. `date_1`이 더 최근, `date_2`가 더 이른 날짜다.

```
(5 * ( FLOOR( ( date_1 - DATE( 1900, 1, 8) ) / 7 ) ) + MIN( 5, MOD(
date_1 - DATE( 1900, 1, 8), 7 ) ) )
-
(5 * ( FLOOR( ( date_2 - DATE( 1900, 1, 8) ) / 7 ) ) + MIN( 5, MOD(
date_2 - DATE( 1900, 1, 8), 7 ) ) )
```

> 아티팩트 주의: 소스 dump에는 두 `(5 * FLOOR...)` 블록 **사이의 감산 연산자 `-`가 누락**되어 있다(pdftotext가 줄바꿈 위치의 부호를 잃음). 본문 설명이 "difference between them is taken"(두 값의 차)이라고 명시하므로 위 코드블록에는 감산 `-`를 복원했다. 근무일이 5일이 아니면 모든 5를 근무일 수로 바꾼다.

#### Find the Number of Months Between Two Dates
나중 연도에서 이른 연도를 빼 12를 곱하고, 월 차이를 더한다.

```
((YEAR(date_1) - YEAR(date_2))*12) + (MONTH(date_1) - MONTH(date_2))
```

#### Add Days, Months, and Years to a Date
날짜에 일수를 더하려면 직접 더한다(예: 5일 추가 → `date + 5`). 개월 수를 더하려면 `ADDMONTHS()`를 쓴다.

```
ADDMONTHS()
```

예를 들어 4개월을 더하려면:

```
ADDMONTHS(date + 4)
```

> 원문 주의: 위 `ADDMONTHS(date + 4)`는 **소스 PDF 표기 그대로**다. 정상 문법은 `ADDMONTHS(date, 4)`(두 번째 인자로 개월 수 전달)이므로 실제 사용 시 콤마 구분 형태를 쓴다.

연수를 더하려면(제공한 날짜가 월말이면 결과 월의 마지막 날을 반환):

```
ADDMONTHS(date, 12*num_years)
```

제공한 날짜가 2월 29일이고 결과 연도가 윤년이 아니면 2월 28일을 반환한다. 이 경우 3월 1일을 원하면:

```
IF( MOD((Year (ADDMONTHS(date, 12* num_years)-1960),4)=0,
ADDMONTHS(date,12* num_years)+1,ADDMONTHS(date, 12*num_years))
```

> 원문 주의: 위 leap-year 처리식은 **소스 PDF 표기 그대로**다. 함수명 케이싱(`Year` — 정상은 `YEAR`)과 괄호 짝이 원문에서 불완전하게 나타난다. 로직 의도(윤년일 때 하루 더하기)는 유지하되 실제 배포 전 함수명·괄호를 검증한다.

#### Add Business Days to a Date
주어진 날짜로부터 3영업일 뒤를 찾는다. 날짜의 요일을 구해 수·목·금이면 주말 2일 + 평일 3일 = 5일을 더하고, 토요일이면 4일, 그 외에는 3일을 더한다.

```
CASE(
MOD( date - DATE( 1900, 1, 7 ), 7 ),
3, date + 2 + 3,
4, date + 2 + 3,
5, date + 2 + 3,
6, date + 1 + 3,
date + 3
)
```

#### Find the Hour, Minute, or Second from a Date/Time
Date/Time에서 시·분·초를 숫자로 얻는다. `TZoffset`은 사용자 시간대와 GMT의 차이다. 24시간제 시(hour):

```
VALUE( MID( TEXT( date/time - TZoffset ), 12, 2 ) )
```

12시간제 시(hour):

```
IF(
OR(
VALUE( MID( TEXT( date/time - TZoffset ), 12, 2 ) ) = 0,
VALUE( MID( TEXT( date/time - TZoffset ), 12, 2 ) ) = 12
),
12,
VALUE( MID( TEXT( date/time - TZoffset ), 12, 2 ) )
IF(
VALUE( MID( TEXT( date/time - TZoffset ), 12, 2 ) ) < 12,
0,
12
)
)
```

분(minutes):

```
VALUE( MID( TEXT( date/time - TZoffset ), 15, 2 ) )
```

초(seconds):

```
VALUE( MID( TEXT( date/time - TZoffset ), 18, 2 ) )
```

"AM"/"PM" 문자열:

```
IF(
VALUE( MID( TEXT( date/time - TZoffset ), 12, 2 ) ) < 12,
"AM",
"PM"
)
```

"HH:MM:SS A/PM" 형식의 시각 문자열:

```
IF(
OR(
VALUE( MID( TEXT( date/time - TZoffset ), 12, 2 ) ) = 0,
VALUE( MID( TEXT( date/time - TZoffset ), 12, 2 ) ) = 12
),
"12",
TEXT( VALUE( MID( TEXT( date/time - TZoffset ), 12, 2 ) )
IF(
VALUE( MID( TEXT( date/time - TZoffset ), 12, 2 ) ) < 12,
0,
12
)
)
)
& ":" &
MID( TEXT( date/time - TZoffset ), 15, 2 )
& ":" &
MID( TEXT( date/time - TZoffset ), 18, 2 )
& " " &
IF(
VALUE( MID( TEXT( date/time - TZoffset ), 12, 2 ) ) < 12,
"AM",
"PM"
)
```

#### Find the Elapsed Time Between Date/Times
두 Date/Time 값 `datetime_1`·`datetime_2`의 차를 일·시·분으로 변환한다.

```
IF(

datetime_1 - datetime_2 > 0 ,
TEXT( FLOOR( datetime_1 - datetime_2 ) ) & " days "
& TEXT( FLOOR( MOD( (datetime_1 - datetime_2 ) * 24, 24 ) ) ) & "
hours "
& TEXT( ROUND( MOD( (datetime_1 - datetime_2 ) * 24 * 60, 60 ), 0
) ) & " minutes",
""
)
```

#### Find the Number of Business Hours Between Two Date/Times
경과 영업일 수식을 확장해 두 Date/Time 사이 영업시간을 구한다. 기준 Date/Time(1900-01-08 16:00 GMT = 오전 9시 PDT)을 사용하고, 가장 가까운 시간으로 반올림하며 8시간(9:00 AM–5:00 PM) 근무일을 가정한다.

```
ROUND( 8 * (
( 5 * FLOOR( ( NOW() - DATETIMEVALUE( '1900-01-08 16:00:00') ) /
7) +
MIN(5,
FLOOR ( MOD ( NOW() - DATETIMEVALUE( '1900-01-08 16:00:00'), 7)
/ 1) +
MIN( 1, 24 / 8 * ( MOD( NOW () - DATETIMEVALUE( '1900-01-08
16:00:00' ), 1 ) ) )
)
)
-
( 5 * FLOOR( ( MQL_datetime_c - DATETIMEVALUE( '1900-01-08
16:00:00') ) / 7) +
MIN( 5,
FLOOR( MOD( MQL_datetime_c - DATETIMEVALUE( '1900-01-08
16:00:00'), 7) / 1) +
MIN( 1, 24 / 8 * ( MOD( MQL_datetime_c - DATETIMEVALUE(
'1900-01-08 16:00:00' ), 1) ) )
)
)
),
2 )
```

수식의 8을 바꿔 근무일 길이를 조정하고, 다른 시간대·업무 시작 시각이면 기준 시각을 GMT 기준 업무 시작 시각으로 바꾼다.

---

## 8. Discounting (할인)

할인 금액을 계산하는 수식.

### Maintenance and Services Discount
두 커스텀 통화 필드(Maintenance Amount·Services Amount)의 합이 기회 Amount와 다르면 "Discounted", 같으면 "Full Price"를 표시한다.

```
IF(Maintenance_Amount__c + Services_Amount__c <> Amount,
"Discounted",
"Full Price")
```

### Opportunity Discount Amount
제품 Amount에서 Discount Amount(커스텀 통화 필드)를 뺀 차이를 계산한다.

```
Amount - Discount_Amount__c
```

> 아티팩트 주의: 소스 dump에서는 `Amount Discount_Amount__c`로 **감산 연산자 `-`가 누락**되어 있다(pdftotext 부호 손실). 본문 설명이 "difference of the product Amount **less** the Discount Amount"이므로 위 코드블록에 `-`를 복원했다.

### Opportunity Discount Rounded
기회의 할인 금액을 소수 둘째 자리로 반올림한다. Discount Percent 커스텀 백분율 필드를 쓰는 숫자 수식 필드다.

```
ROUND(Amount-Amount* Discount_Percent__c,2)
```

### Opportunity Discount with Approval
기회에 "Discount Approved" 체크박스를 추가한다. 승인 플래그를 확인한 뒤 커미션을 계산한다.

```
IF(Discount_Approved__c, ROUND(Amount – Amount * DiscountPercent__c,
2), Amount)
```

---

## 9. Employee Services (직원 서비스)

직원 서비스용 수식.

### Bonus Calculation
직원 보너스를 두 값 중 작은 쪽으로 결정한다: 직원 총소득 × 보너스 비율, 또는 회사 성과 금액을 전 직원 수로 균등 분할한 금액. Number of Employees(숫자)·Bonus Percent(백분율)·Gross·Performance(통화) 커스텀 필드를 가정한다.

```
MIN(Gross__c * Bonus_Percent__c,
Performance__c / Number_of_Employees__c)
```

### Employee 401K
직원 기여금의 절반과 $250 중 작은 쪽을 401K 매칭 금액으로 결정한다. Contribution 커스텀 통화 필드를 가정한다.

```
MIN(250, Contribution__c /2)
```

### Hours Worked Per Week
일일 근무 시간을 추적하는 커스텀 탭을 사용해 주간 근무 시간을 합산한다.

```
MonHours__c + TuesHours__c + WedsHours__c + ThursHours__c + FriHours__c
```

### Total Pay Amount
정규 시간 × 정규 급여율에 초과 시간 × 초과 급여율을 더해 총 급여를 계산한다.

```
IF(Total_Hours__c <= 40, Total_Hours__c * Hourly_Rate__c,
40 * Hourly_Rate__c +
(Total_Hours__c - 40) * Overtime_Rate__c)
```

> 원문 주의: 소스 PDF는 수식 앞에 `Total Pay =` 접두를 붙여 표기하지만, 이는 **설명용 라벨**이며 실제 수식은 위 `IF(...)` 부분이다.

---

## 10. Expense Tracking (경비 추적)

경비 추적용 수식.

### Expense Identifier
"Expense-" 다음에 여행명과 경비 번호를 표시한다. 경비 번호 커스텀 필드를 사용하는 텍스트 수식 필드다.

```
"Expense-" &
Trip_Name__c & "-" & ExpenseNum__c
```

### Mileage Calculation
고객 사이트 방문 주행 거리 경비를 마일당 35센트로 계산한다.

```
Miles_Driven__c * 0.35
```

---

## 11. Financial Calculations (재무 계산)

재무 계산용 수식.

### Compound Interest
연 M회 복리로 T년 후 이자를 계산한다.

```
Principal__c * ( 1 + Rate__c / M ) ^ ( T * M )
```

> 아티팩트 주의: 소스 dump에서는 끝에 여분의 닫는 괄호 `)`가 붙어 `... ^ ( T * M) )`로 나타난다(pdftotext 괄호 이상). 괄호 짝을 맞춰 여분의 `)`를 제거한 형태를 위에 실었다.

### Compound Interest Continuous
연속 복리로 T년 후 누적 이자를 계산한다.

```
Principal__c * EXP(Rate__c * T)
```

### Consultant Cost
컨설팅 일수 × 1200(일당 $1200). 통화 데이터 타입 수식 필드로, Consulting Days는 커스텀 필드다.

```
Consulting_Days__c *
1200
```

### Gross Margin
매출 총이익의 단순 계산. Total Sales·Cost of Goods Sold는 커스텀 통화 필드다.

```
Total_Sales__c - Cost_of_Goods_Sold__c
```

### Gross Margin Percent
마진 백분율 기반으로 매출 총이익을 계산한다.

```
Margin_percent__c * Items_Sold__c * Price_item__c
```

### Payment Due Indicator
Payment Due Date가 빈 값이면 계약 시작일로부터 5일 뒤 날짜를 반환한다. Payment Due Date는 커스텀 날짜 필드다.

```
BLANKVALUE(Payment_Due_Date__c, StartDate + 5)
```

> 아티팩트 주의: 소스 dump에서는 선두에 여분의 여는 괄호 `(`가 붙어 `(BLANKVALUE(...)`로 나타난다(pdftotext 괄호 이상). 여분의 `(`를 제거한 형태를 위에 실었다.

### Payment Status
결제 마감일이 지났고 결제 상태가 "UNPAID"면 "PAYMENT OVERDUE"를, 아니면 빈 값을 반환한다. 계약(contracts)의 Payment Due Date(날짜)·Payment Status(텍스트) 커스텀 필드를 사용한다.

```
IF(
AND(Payment_Due_Date__c < TODAY(),
ISPICKVAL(Payment_Status__c, "UNPAID")),
"PAYMENT OVERDUE",
null )
```

---

## 12. Image Link (이미지 링크)

이미지 링크용 수식.

### Yahoo! Instant Messenger™ Image
연락처·사용자의 Yahoo! Instant Messenger 로그인 여부를 이미지로 표시하고, 클릭 시 창을 연다. Yahoo Name 커스텀 텍스트 필드를 사용한다.

```
IF(ISBLANK(Yahoo_Name__c),"", HYPERLINK("ymsgr:sendIM?" &
Yahoo_Name__c,
IMAGE("http://opi.yahoo.com/online?u=" & Yahoo_Name__c & "&m=g&t=0",
" ")))
```

### Flags for Case Priority
케이스 우선순위를 초록·노랑·빨강 깃발 이미지로 표시한다.

```
IMAGE(
CASE( Priority,
"Low", "/img/samples/flag_green.gif",
"Medium", "/img/samples/flag_yellow.gif",
"High", "/img/samples/flag_red.gif",
"/s.gif"),
"Priority Flag")
```

### Color Squares for Case Age
Case Age 커스텀 숫자 필드 값에 따라 30×30 픽셀 빨강·노랑·초록 이미지를 표시한다.

```
IF( Case_Age__c > 20,
IMAGE("/img/samples/color_red.gif", "red", 30, 30),
IF( Case_Age__c > 10,
IMAGE("/img/samples/color_yellow.gif", "yellow", 30, 30),
IMAGE("/img/samples/color_green.gif", "green", 30, 30)
))
```

### Traffic Lights for Status
Project Status 커스텀 피클리스트로 초록·노랑·빨강 신호등 이미지를 표시한다. 목록 보기·리포트에서 "Status Summary" 대시보드 뷰를 만들 때 사용한다.

```
IMAGE(
CASE(Project_Status__c,
"Green", "/img/samples/light_green.gif",
"Yellow", "/img/samples/light_yellow.gif",
"Red", "/img/samples/light_red.gif",
"/s.gif"),
"status color")
```

### Stars for Ratings
등급·점수를 별 1~5개로 표시한다.

```
IMAGE(
CASE(Rating__c,
"1", "/img/samples/stars_100.gif",
"2", "/img/samples/stars_200.gif",
"3", "/img/samples/stars_300.gif",
"4", "/img/samples/stars_400.gif",
"5", "/img/samples/stars_500.gif",
"/img/samples/stars_000.gif"),
"rating")
```

### Consumer Reports™—Style Colored Circles for Ratings
1~5 등급을 색 원으로 표시한다(1=솔리드 빨강, 2=반 빨강, 3=검정 외곽선, 4=반 검정, 5=솔리드 검정).

```
IMAGE(
CASE(Rating__c,
"1", "/img/samples/rating1.gif",
"2", "/img/samples/rating2.gif",
"3", "/img/samples/rating3.gif",
"4", "/img/samples/rating4.gif",
"5", "/img/samples/rating5.gif",
"/s.gif"),
"rating")
```

### Horizontal Bars to Indicate Scoring
숫자 점수에 비례하는 길이의 가로 색 막대(흰 배경 위 초록)를 표시한다. 이 예제에서 최대 막대 길이는 200픽셀이다.

```
IMAGE("/img/samples/color_green.gif", "green", 15, Industry_Score__c
* 2) &
IMAGE("/s.gif", "white", 15,
200 - (Industry_Score__c * 2))
```

---

## 13. Integration Link (통합 링크)

통합 링크용 수식.

### Application API Link
Salesforce 외부 애플리케이션으로 연결하고 파라미터를 전달해 SOAP API로 Salesforce에 연결·필요한 이벤트를 생성한다.

```
HYPERLINK ("https://www.myintegration.com?sId=" & GETSESSIONID() &
"?&rowID=" & Name & "action=CreateTask","Create a Meeting Request")
```

> **Important** — `$Api.Session_ID`와 `GETSESSIONID()`는 같은 값(현재 컨텍스트의 현재 세션 식별자)을 반환한다. 이 컨텍스트는 전역 변수·함수가 평가되는 위치에 따라 달라진다. 예를 들어 커스텀 수식 필드에 사용하고 그 필드가 Salesforce Classic의 표준 페이지 레이아웃에 표시되면 참조된 세션은 기본 Salesforce 세션이다. 같은 필드(또는 그 변수·수식 결과)를 Visualforce 페이지에서 쓰면 대신 Visualforce 세션을 참조한다.
>
> 세션 컨텍스트는 요청의 도메인 기반이다. 즉 `.salesforce.com`에서 `.vf.force.com`·`.lightning.force.com`으로 넘어가는 등 hostname 경계를 넘을 때마다 세션 컨텍스트가 바뀐다. 서로 다른 컨텍스트의 세션 식별자와 세션 자체는 다르다. 컨텍스트를 전환하면 새 세션이 이전 세션을 대체하고 이전 세션은 더 이상 유효하지 않으며, 이때 session ID도 바뀐다.
>
> 보통 Salesforce가 컨텍스트 간 세션 hand-off를 투명하게 처리하지만, session ID를 직접 전달한다면 유효한 session ID를 보장하기 위해 새 컨텍스트에서 `$Api.Session_ID`나 `GETSESSIONID()`를 다시 액세스해야 한다.
>
> 모든 세션이 동일하지 않다. 특히 Lightning Experience 컨텍스트에서 얻은 세션은 권한이 축소되어 API 액세스가 없다 — 이 session ID로는 API 호출을 할 수 없다. `{!$Api.Session_ID}`는 게스트 사용자에게는 생성되지 않는다.

### Shipment Tracking Integration
Shipping Method 커스텀 피클리스트 값에 따라 FedEx·UPS·DHL 배송 추적 사이트로 연결한다. 예제의 파라미터는 예시일 뿐 모든 상황에 맞는 정확한 값이 아니다.

```
CASE(Shipping_Method__c,
"Fedex",
HYPERLINK("http://www.fedex.com/Tracking?ascend_header=1&clienttype
=dotcom&cntry_code=us&language=english&tracknumbers= "&
tracking_id__c,"Track"),
"UPS",
HYPERLINK("http://wwwapps.ups.com/WebTracking/processInputRequest?HTMLVersion
=5.0&sort_by=status&loc=en_US&InquiryNumber1= "& tracking_id__c &
"&track.x=32&track.y=7", "Track") ,
"DHL",
HYPERLINK("http://track.dhl-usa.com/TrackByNbr.asp?ShipmentNumber=" &
tracking_id__c,"Track"), "")
```

### Skype™ Auto Dialer Integration
클릭하면 Skype VOIP 애플리케이션으로 전화번호를 자동 다이얼하는 링크 필드. 데스크톱에 Skype(서드파티 제품) 설치가 필요하다.

```
HYPERLINK("callto://+" & Country_Code__c & Phone_Unformatted__c, Phone)
```

---

## 14. Lead Management (리드 관리)

리드를 관리하는 수식.

### Lead Aging (for open leads)
리드가 열려 있으면 생성 일시를 현재 일시에서 빼 열린 일수(소수 0자리 반올림)를 계산한다. 열려 있지 않으면 빈 값이다.

```
IF(ISPICKVAL(Status,
"Open"), ROUND(NOW()-CreatedDate, 0), null)
```

### Lead Data Completeness
영업 담당자가 입력한 특정 리드 필드의 비율을 계산한다. Phone·Email 두 커스텀 숫자 필드를 검사해 비어 있으면 0, 값이 있으면 각 1을 부여하고 50을 곱한다.

```
(IF(Phone = "", 0, 1) + IF(Email = "", 0, 1) ) * 50
```

### Lead Numbering
auto-number 필드 Lead Number의 텍스트 값을 숫자 값으로 반환한다. round-robin 등 라우팅 계산에 유용하다(auto-number는 텍스트 필드라 숫자 계산 전 변환 필요).

```
VALUE(Lead_Number__c)
```

### Round-Robin Assignment of Cases or Leads
리드 큐 3개에 들어오는 리드를 균등 배정한다고 가정한다(케이스도 유사 수식으로 배정 가능).

```
MOD(VALUE(Lead_Number__c),
3)
```

`Round_Robin_ID` 커스텀 수식 필드에 각 리드가 0·1·2 값을 부여받는다. Lead Number(1부터 시작하는 auto-number)를 큐 수(여기선 3)로 나눈 나머지를 반환한다. 이 값을 리드 배정 규칙에서 사용해 큐에 배정한다.

- Round_Robin_ID = 0 → Queue A
- Round_Robin_ID = 1 → Queue B
- Round_Robin_ID = 2 → Queue C

---

## 15. Metric (미터법 환산)

미터법 온도·측정 단위 환산용 수식.

### Temperature Conversion
섭씨를 화씨로 변환한다.

```
1.8 * degrees_celsius__c + 32
```

### Unit of Measure Conversion
마일을 킬로미터로 변환한다.

```
Miles__c * 1.60934
```

---

## 16. Opportunity Management (기회 관리)

사업 경비·수익용 수식.

### Expected Product Revenue
서로 다른 성사 확률을 가진 여러 제품의 총 수익을 계산한다.

```
ProductA_probability__c * ProductA_revenue__c + ProductB_probability__c
* ProductB_revenue__c
```

### Maintenance Calculation
유지보수 수수료를 연간 라이선스 수수료의 20%로 계산한다. Maintenance Years는 기회의 커스텀 필드다.

```
Amount * Maint_Years__c * 0.2
```

### Monthly Subscription-Based Calculated Amounts
월 구독료 × 구독 기간으로 기회 금액을 계산한다.

```
Monthly_Amount__c * Subscription_Months__c
```

### Monthly Value
연간 총가치를 12개월로 나눈다.

```
Total_value__c / 12
```

### Opportunity Additional Costs
제품 Amount, 유지보수 금액, 서비스 수수료의 합을 계산한다. Maint amount·Service Fees는 커스텀 통화 필드다.

```
Amount + Maint_Amount__c +
Services_Amount__c
```

### Opportunity Categorization
Amount 표준 필드 값에 따라 Opportunity category 텍스트 필드를 채운다. $1500 미만은 "Category 1", $1500~$10,000은 "Category 2", 그 외는 "Category 3". 중첩 IF를 사용한다.

```
IF(Amount < 1500, "Category 1", IF(Amount > 10000, "Category 3",
"Category 2"))
```

### Opportunity Data Completeness
다섯 필드가 사용되는 비율을 계산한다. 각 필드가 비어 있으면 0, 값이 있으면 1을 세어 5로 나눈다. Advanced Formula 서브탭의 Blank Field Handling에서 "Treat blank fields as blanks"를 선택해야 한다.

```
(IF(ISBLANK(Maint_Amount__c), 0, 1) +
IF(ISBLANK(Services_Amount__c), 0,1) +
IF(ISBLANK(Discount_Percent__c), 0, 1) +
IF(ISBLANK(Amount), 0, 1) +
IF(ISBLANK(Timeline__c), 0, 1)) / 5
```

### Opportunity Expected License Revenue
성사 확률 기반으로 라이선스 예상 수익을 계산한다.

```
Expected_rev_licenses__c * Probability
```

### Opportunity Revenue Text Display
기회의 예상 수익 금액을 달러 기호 없이 텍스트 형식으로 반환한다. 예: "$200,000" → "200000".

```
TEXT(ExpectedRevenue)
```

### Opportunity Total Deal Size
유지보수·서비스 금액의 합을 계산한다.

```
Amount + Maint_Amount__c + Services_Amount__c
```

### Opportunity Total Price Based on Units
단가와 총 물량 기반으로 제안 가격을 생성한다.

```
Unit_price__c * Volume__c * 20
```

### Professional Services Calculation
전문 서비스 수수료를 평균 로디드 레이트 일당 $1200으로 추정한다. Consulting Days는 기회의 커스텀 필드다.

```
Consulting_Days__c * 1200
```

### Stage-Based Sales Document Selection
기회 Stage 기반으로 Documents 탭의 관련 문서를 식별한다. 문서 ID는 "00l30000000j7AO" 형태로 사용한다.

```
CASE(StageName,
"Prospecting", "Insert 1st Document ID",
"Qualification", "Insert 2nd Document ID",
"Needs Analysis", "Insert 3rd Document ID",
"Value Proposition", ...
)
)
```

> 원문 주의: 위 코드는 **소스 PDF 표기 그대로**다. `"Value Proposition", ...`의 `...`은 원문에 실린 미완성 예시(사용자가 이어서 채우는 자리)이고, 마지막 여분의 `)`도 원문 그대로다. 실제 사용 시 CASE 인자·괄호를 완성한다.

### Sales Coach
Documents 탭에 저장된 stage별 문서를 여는 하이퍼링크를 만든다. 위 Stage-Based Sales Document Selection 수식 필드를 사용한다.

```
HYPERLINK("/servlet/servlet.FileDownload?file=" & Relevant_Document__c,
"View Document in New Window")
```

### Shipping Cost by Weight
무게 기반으로 우편 요금을 계산한다.

```
package_weight__c * cost_lb__c
```

### Shipping Cost Percentage
배송비를 총액의 비율로 계산한다.

```
Ship_cost__c / total_amount__c
```

### Tiered Commission Rates
성사 확률 100%인 기회의 2% 커미션 금액을 계산한다. 그 외 기회의 커미션은 0.

```
IF(Probability = 1,
ROUND(Amount * 0.02, 2),
0)
```

### Total Contract Value from Recurring and Non-Recurring Revenue
계약 수명 동안의 반복·비반복 수익 흐름을 계산한다.

```
Non_Recurring_Revenue__c + Contract_Length_Months__c *
Recurring_Revenue__c
```

---

## 17. Pricing (가격)

총액·사용자 가격용 수식.

### Total Amount
단가와 총 단위 기반으로 총액을 계산한다.

```
Unit_price__c * Total_units__c
```

### User Pricing
사용자 라이선스당 가격을 계산한다.

```
Total_license_rev__c / Number_user_licenses__c
```

---

## 18. Scoring Calculations (스코어링)

리드 스코어링·고객 성공 스코어링용 수식.

### Lead Scoring
전화 요청에 웹 요청보다 높은 점수를 부여한다.

```
CASE(LeadSource, "Phone", 2, "Web", 1, 0)
```

리드 등급(rating) 기반으로 점수를 매기는 변형:

```
CASE(1, IF(ISPICKVAL(Rating, "Hot"), 1, 0), 3, IF(ISPICKVAL(Rating,
"Warm"), 1, 0), 2, IF(ISPICKVAL(Rating, "Cold"), 1, 0), 1))
```

### Customer Success Scoring
Salesforce의 긍정적 설문 결과에 높은 점수를 주는 단순 스코어링 알고리즘.

```
Survey_Question_1__c * 5 + Survey_Question_2__c *2
```

---

## 관련 노트
- [[Formula 필드]] — 수식 필드 개념·문법·데이터 타입·컴파일 한도 허브
- [[Formula 연산자·함수 레퍼런스]] — 이 예제들이 쓰는 IF·CASE·HYPERLINK·IMAGE·ADDMONTHS·MOD 등 함수 정의(형제 노트)
- [[Validation Rules 예제]] — 자매 예제집(검증 규칙 수식 모음)
