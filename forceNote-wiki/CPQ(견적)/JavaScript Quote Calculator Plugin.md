---
tags: [CPQ, Salesforce CPQ, SBQQ, JavaScript Quote Calculator Plugin, JSQCP, Page Security Plugin, 견적, 커스텀계산, JSForce, Promises]
source: cpq_developer_guide.pdf (Salesforce CPQ Developer Guide, v65.0 Winter '26)
created: 2026-06-21
aliases: [JavaScript Quote Calculator Plugin, Quote Calculator Plugin, JSQCP, onInit, onBeforeCalculate, onBeforePriceRules, onAfterPriceRules, onAfterCalculate, isFieldVisible, isFieldEditable, JavaScript Page Security Plugin, isFieldVisibleForObject, isFieldEditableForObject, Legacy Page Security Plugin, PageSecurityPlugin2, CPQ 커스텀 계산, CPQ 견적 계산 플러그인, CPQ 필드 가시성, CPQ 필드 편집잠금, JSForce conn, "CPQ에서 계산 커스터마이즈 어떻게", "CPQ 견적 필드 숨기기", "onAfterCalculate가 뭐야"]
---

# JavaScript Quote Calculator Plugin

> Salesforce CPQ의 quote line editor에 커스텀 JavaScript 코드를 붙여 계산 방식과 page-level 보안(필드 가시성·편집성)을 제어한다. 7개 메서드를 export해 동작을 정의하며, JavaScript 코드는 CPQ에 custom script로 저장된다.

**EDITIONS** — Available in Salesforce CPQ, Winter '16 and later.

CPQ에서 quote line editor에 추가 기능을 더하는 커스텀 JavaScript 코드다. 7개의 사용 가능 메서드로 계산 수행 방식을 바꾸고 필드 가시성 같은 page-level 보안을 관리한다. JavaScript 코드는 CPQ에 custom script로 저장된다.

> CPQ가 사용하는 데이터 모델(`QuoteModel`·`QuoteLineModel` 등)의 전체 필드는 [[CPQ API Models]] 참조. 이 노트에서는 plugin에서 모델에 접근하는 방법만 다룬다.

---

## A. Quote Calculator Plugin Guidelines

스크립트를 계획할 때 고려할 핵심 가이드라인. (EDITIONS — Available in Salesforce CPQ, Winter '16 and later.)

### Promises

`Promise`는 브라우저에서 비동기 프로그래밍을 가능하게 하는 JavaScript 내장 객체다. Promise는 어떤 동작을 다른 동작이 완료될 때까지 지연시킨다. Promise는 `.then(success, failure)` 메서드를 지원한다 — `success`는 promise가 성공적으로 resolve될 때 호출되는 함수, `failure`는 promise가 reject될 때 호출되는 함수다.

플러그인에서 server callout 같은 비동기 프로그래밍을 하려면, 그 동작이 완료될 때 resolve되는 promise를 **반드시 반환**해야 한다. 이로써 계산 단계가 올바른 순서로 일어나는 것이 보장된다. 메서드가 비동기 동작을 필요로 하지 않으면 `return Promise.resolve();`로 즉시 resolve되는 promise를 반환할 수 있다.

Promise는 값으로 resolve될 수 있고, 그 값은 `.then()` 콜백에 파라미터로 전달된다. 직접 작성한 코드에서 이 사실을 활용할 수 있으나, 이 메서드들이 반환하는 promise는 값으로 resolve될 필요는 없다는 점을 기억한다. **항상 파라미터로 제공된 quote·line 모델을 직접 수정**한다.

### QuoteModel and QuoteLineModel Types

JavaScript calculator는 `Quote__c`·`QuoteLine__c` 객체를 각각 `QuoteModel`·`QuoteLineModel` 객체로 표현한다. 두 객체 모두 `.record` 프로퍼티를 통해 기저 SObject에 접근할 수 있으며, 이를 통해 API name으로 필드를 참조한다.

예: 특정 `QuoteLineModel`의 커스텀 필드 `SBQQ__MyCustomField__c`는 `record["SBQQ__MyCustomField__c"]` 속성으로 참조한다. 관련 레코드의 필드도 참조할 수 있다 — quote에 연결된 account의 `MyField__c`를 참조하려면 `record["Account__r"]["MyField__c"]`로 접근한다.

External 필드는 기본적으로 로드되지 않는다. opportunity나 account의 external 필드를 쓰려면, 원하는 필드 값을 끌어오는 커스텀 quote formula field를 만든 뒤 그 커스텀 quote 필드를 스크립트에 포함한다. 또는 price action formula에서 이 external 필드를 참조해 preload한 뒤 스크립트에 포함할 수도 있다.

### Salesforce Field Types

JSON(JavaScript Object Notation)에 저장된 레코드를 변경할 수 있다. 이 레코드들은 org에서 serialize된다. Number·Text·Boolean 필드는 변환 없이 저장되지만, 다른 타입은 변환할 수 있다. 예를 들어 **date는 `"YYYY-MM-DD"` 형식의 문자열로 표현된다.** date를 담은 필드를 참조하거나 변경하면 그 형식을 보존해야 한다.

### JSForce

JSForce는 query 실행, Apex REST call, Metadata API 사용, 원격 HTTP 요청을 통일된 방식으로 제공하는 third-party 라이브러리다. 메서드는 옵셔널 파라미터 `conn`을 통해 jsforce에 접근한다.

> [!note]
> - JSQCP는 ES6 모듈이다. Babel로 transpile되며 기본적으로 module-scoped다. ES6 언어/문법의 모든 요소를 사용할 수 있다. 다만 플러그인은 browser와 node 환경 **양쪽에서** 실행 가능해야 한다. `window` 같은 global browser 변수는 사용 불가일 수 있다.
> - 플러그인에서 비동기 계산을 위한 non-Salesforce endpoint로의 callout(request)은 지원되지 않는다. 예: `requestGet`은 비동기 계산에서 실패한다.

### Field Availability

JavaScript Quote Calculator 플러그인은 consumption rate·consumption schedule의 커스텀 필드를 지원하지 않는다.

### Character Limits

JavaScript Quote Calculator Plugin에서 custom script의 최대 character limit을 늘릴 수 없다.

### API Version Management

일반적으로 CPQ는 **최신 Salesforce API보다 한 버전 뒤** API를 사용한다. 예를 들어 Salesforce Summer '21은 Salesforce API version 52.0을 쓰므로, CPQ Summer '21은 Salesforce API version 51.0을 쓴다.

CPQ에서 사용 중인 것보다 새 Salesforce API version의 entity·field를 참조해야 하면, JSforce 프로퍼티 할당 `conn.version='x';`를 사용해 `x`를 원하는 버전으로 바꾼다. 다음 메서드는 기본 API version을 52.0으로 덮어쓰는 방법을 보여준다.

```javascript
export function onInit(quote, conn) {
conn.version = '52.0';
return conn.query("SELECT Name FROM ConsumptionSchedule")
.then(function (results) {
console.log(results);
return Promise.resolve();
})
}
```

---

## B. Quote Calculator Plugin Methods (7개)

Quote Calculator Plugin은 다음 **7개 메서드**를 참조할 수 있다. 원하는 동작을 위해 이 중 임의의 일부·전부·전무를 export할 수 있다. (EDITIONS — Available in Salesforce CPQ, Winter '16 and later.)

> 호출 순서: `onInit` → (formula field 평가) → `onBeforeCalculate` → (price rule 평가 전) `onBeforePriceRules` → (price rule 평가 후) `onAfterPriceRules` → (계산 완료, formula field 재평가 전) `onAfterCalculate` → (계산 완료 후) `isFieldVisible` / `isFieldEditable`.

### onInit

| Param | Type | Description |
|---|---|---|
| `quoteLineModels` | `{QuoteLineModel[]}` | An array containing Javascript representations of all lines in a quote. |

calculator는 formula field가 평가되기 **전에** 이 메서드를 호출한다. Returns `{promise}`.

```javascript
export function onInit(quoteLineModels) {
return Promise.resolve();
};
```

### onBeforeCalculate

| Param | Type | Description |
|---|---|---|
| `quoteModel` | `{QuoteModel}` | Javascript representation of the quote you're evaluating |
| `quoteLineModels` | `{QuoteLineModel[]}` | An array containing Javascript representations of all lines in the quote |

calculator는 계산이 시작되기 전, 단 formula field가 평가된 **후에** 이 메서드를 호출한다. Returns `{promise}`.

```javascript
export function onBeforeCalculate(quoteModel, quoteLineModels) {
return Promise.resolve();
};
```

### onBeforePriceRules

| Param | Type | Description |
|---|---|---|
| `quoteModel` | `{QuoteModel}` | Javascript representation of the quote you're evaluating |
| `quoteLineModels` | `{QuoteLineModel[]}` | An array containing Javascript representations of all lines in the quote |

calculator는 price rule을 평가하기 **전에** 이 메서드를 호출한다. Returns `{promise}`.

```javascript
export function onBeforePriceRules(quoteModel, quoteLineModels) {
return Promise.resolve();
};
```

### onAfterPriceRules

| Param | Type | Description |
|---|---|---|
| `quoteModel` | `{QuoteModel}` | Javascript representation of the quote you're evaluating |
| `quoteLineModels` | `{QuoteLineModel[]}` | An array containing Javascript representations of all lines in the quote |

calculator는 price rule을 평가한 **후에** 이 메서드를 호출한다. Returns `{promise}`.

```javascript
export function onAfterPriceRules(quoteModel, quoteLineModels) {
return Promise.resolve();
};
```

### onAfterCalculate

| Param | Type | Description |
|---|---|---|
| `quoteModel` | `{QuoteModel}` | Javascript representation of the quote you're evaluating |
| `quoteLineModels` | `{QuoteLineModel[]}` | An array containing Javascript representations of all lines in the quote |

calculator는 계산을 완료한 후, 단 formula field를 재평가하기 **전에** 이 메서드를 호출한다. Returns `{promise}` [sic — PDF 원문 반환 설명줄에 마침표 없음].

```javascript
export function onAfterCalculate(quoteModel, quoteLineModels) {
return Promise.resolve();
};
```

### isFieldVisible

> [!note] This method can't be used to alter data.

| Param | Type | Description |
|---|---|---|
| `{FieldName}` | String | Name of the field that will be hidden or made visible |
| `{QuoteLineModelRecord}` | `quoteLineModelRecord` | Javascript representation of the SObject record of line you're evaluating |

calculator는 계산을 완료한 후 이 메서드를 호출한다. Returns `{Boolean}` [sic — PDF 원문 반환 설명줄에 마침표 없음].

```javascript
export function isFieldVisible(fieldName, quoteLineModelRecord) {
if (fieldName == 'SBQQ__Description__c') {
return false;
}
return true;
};
```

### isFieldEditable

> [!note] This method can't be used to alter data.

| Param | Type | Description |
|---|---|---|
| `{FieldName}` | String | Name of the field that will be made read-only or editable |
| `{QuoteLineModelRecord}` | `quoteLineModelRecord` | Javascript representation of the SObject record of line you're evaluating |

calculator는 계산을 완료한 후 이 메서드를 호출한다. Returns `{Boolean}`

```javascript
export function isFieldEditable(fieldName, quoteLineModelRecord) {
if (fieldName == 'SBQQ__Description__c') {
return false;
}
return true;
};
```

---

## C. 샘플 스크립트

아래 4종 샘플은 모두 PDF 원문에서 verbatim 발췌한 동작 코드다.

### C-1. Calculating True End Date and Subscription Term

커스텀 quote line 필드 True Effective End Date·True Effective Term의 값을 계산하고 최댓값을 저장하는 Quote Line Calculator 플러그인. (EDITIONS — Available in Salesforce CPQ, Winter '16 and later.)

1. quote line 객체에 다음 커스텀 필드를 만든다.
   - a. API name `True_Effective_End_Date__c`인 date 필드
   - b. API name `True_Effective_Term__c`인 number 필드
2. 임의 이름의 custom script 레코드를 만든다.
   - a. Quote Line Fields 필드에 `True_Effective_End_Date__c`·`True_Effective_Term__c`를 추가한다.
   - b. Code 필드에, calculator가 찾는 모든 메서드를 export하고 그 파라미터·반환 타입을 문서화하는 JavaScript 코드를 넣는다. custom script를 저장하고 그 이름을 CPQ 패키지 설정 Plugins 탭의 Quote Calculator Plugin 필드에 추가한다. 아래 샘플 custom script 제공.

```javascript
export function onAfterCalculate(quote, lineModels) {
var maxEffectiveEndDate = null;
var maxEffectiveTerm = 0;
if (lineModels != null) {
lineModels.forEach(function (line) {
var trueEndDate = calculateEndDate(quote, line);
var trueTerm = getEffectiveSubscriptionTerm(quote, line);
if (maxEffectiveEndDate == null || (maxEffectiveEndDate < trueEndDate))
{
maxEffectiveEndDate = trueEndDate;
}
if (maxEffectiveTerm < trueTerm) {
maxEffectiveTerm = trueTerm;
}
line.record["True_Effective_End_Date__c"] = toApexDate(trueEndDate);
line.record["True_Effective_Term__c"] = trueTerm;
});
quote.record["True_Effective_End_Date__c"] = toApexDate(maxEffectiveEndDate);
quote.record["True_Effective_Term__c"] = maxEffectiveTerm;
}
return Promise.resolve()
}
function calculateEndDate(quote, line) {
var sd = new Date(line.record["SBQQ__EffectiveStartDate__c"]);
var ed = new Date(line.record["SBQQ__EffectiveEndDate__c"]);
if (sd != null && ed != null ) {
ed = sd;
ed.setUTCMonth(ed.getUTCMonth() + getEffectiveSubscriptionTerm(quote, line));
ed.setUTCDate(ed.getUTCDate() - 1);
}
return ed;
}
function getEffectiveSubscriptionTerm(quote, line) {
if (line.record["SBQQ__EffectiveStartDate__c"] != null){
var sd = new Date(line.record["SBQQ__EffectiveStartDate__c"]);
}
if (line.record["SBQQ__EffectiveEndDate__c"] != null){
var ed = new Date(line.record["SBQQ__EffectiveEndDate__c"]);
}
if (sd != null && ed != null ) {
ed.setUTCDate(ed.getUTCDate() + 1);
return monthsBetween(sd, ed);
} else if (line.SubscriptionTerm__c != null) {
return line.SubscriptionTerm__c;
} else if (quote.SubscriptionTerm__c != null) {
return quote.SubscriptionTerm__c;
} else {
return line.DefaultSubscriptionTerm__c;
}
}
/**
* Takes a JS Date object and turns it into a string of the type 'YYYY-MM-DD', which
is what Apex is expecting.
* @param {Date} date The date to be stringified
* @returns {string}
*/
function toApexDate(/*Date*/ date) {
if (date == null) {
return null;
}
// Get the ISO formatted date string.
// This will be formatted: YYYY-MM-DDTHH:mm:ss.sssZ
var dateIso = date.toISOString();
// Replace everything after the T with an empty string
return dateIso.replace(new RegExp('[Tt].*'), "");
}
function monthsBetween(/*Date*/ startDate, /*Date*/ endDate) {
if(startDate != null && endDate != null ){
// If the start date is actually after the end date, reverse the arguments and
multiply the result by -1
if (startDate > endDate) {
return -1 * this.monthsBetween(endDate, startDate);
}
var result = 0;
// Add the difference in years * 12
result += ((endDate.getUTCFullYear() - startDate.getUTCFullYear()) * 12);
// Add the difference in months. Note: If startDate was later in the year than
endDate, this value will be
// subtracted.
result += (endDate.getUTCMonth() - startDate.getUTCMonth());
return result;
}
return 0;
}
```

### C-2. Custom Package Total Calculation

quote line 내 모든 component의 총 가격을 계산해 커스텀 필드에 저장하는 Quote Line Calculator 샘플. 이 샘플 코드는 calculator가 찾는 모든 메서드를 export하고 그 파라미터·반환 타입을 문서화한다. (EDITIONS — Available in Salesforce CPQ, Winter '16 and later.)

> [!note] 이 샘플 스크립트는 Salesforce admin이 Quote Line 객체에 커스텀 필드 Component Custom Total을 만든 것으로 가정한다.

```javascript
export function onInit(lines) {
if (lines != null) {
lines.forEach(function (line) {
line.record["Component_Custom_Total__c"] = 0;
});
}
};
export function onAfterCalculate(quoteModel, quoteLines) {
if (quoteLines != null) {
quoteLines.forEach(function (line) {
var parent = line.parentItem;
if (parent != null) {
var pComponentCustomTotal = parent.record["Component_Custom_Total__c"] ||
0;
var cListPrice = line.ProratedListPrice__c || 0;
var cQuantity = line.Quantity__c == null ? 1 : line.Quantity__c;
var cPriorQuantity = line.PriorQuantity__c || 0;
var cPricingMethod = line.PricingMethod__c == null ? "List" :
line.PricingMethod__c;
var cDiscountScheduleType = line.DiscountScheduleType__c || '';
var cRenewal = line.Renewal__c || false;
var cExisting = line.Existing__c || false;
var cSubscriptionPricing = line.SubscriptionPricing__c || '';
var cTotalPrice = getTotal(cListPrice, cQuantity, cPriorQuantity,
cPricingMethod, cDiscountScheduleType, cRenewal, cExisting, cSubscriptionPricing,
cListPrice);
pComponentCustomTotal += cTotalPrice;
parent.record["Component_Custom_Total__c"] = pComponentCustomTotal;
}
});
}
};
function getTotal(price, qty, priorQty, pMethod, dsType, isRen, isExist, subPricing,
listPrice) {
if ((isRen === true) && (isExist === false) && (priorQty == null)) {
// Personal note: In onAfterCalculate, we specifically make sure that priorQuantity
can't be null.
// So isn't this loop pointless?
return 0;
} else {
return price * getEffectiveQuantity(qty, priorQty, pMethod, dsType, isRen, isExist,
subPricing, listPrice);
}
}
function getEffectiveQuantity(qty, priorQty, pMethod, dsType, isRen, exists, subPricing,
listPrice) {
var delta = qty - priorQty;
if (pMethod == 'Block' && delta == 0) {
return 0;
} else if (pMethod == 'Block') {
return 1;
} else if (dsType == 'Slab' && (delta == 0 || (qty == 0 && isRen == true))) {
return 0;
} else if (dsType == 'Slab') {
return 1;
} else if (exists == true && subPricing == '' && delta < 0) {
return 0;
} else if (exists == true && subPricing == 'Percent Of Total' && listPrice != 0 &&
delta >= 0) {
return qty;
} else if (exists == true) {
return delta;
} else {
return qty;
}
}
```

> [sic — PDF 원문] 위 `getTotal`의 주석 `// Personal note: ...priorQuantity can't be null. // So isn't this loop pointless?` 은 PDF 공식 문서에 실재하는 개발자 메모로, verbatim으로 인용했다.

### C-3. Find Lookup Records

플러그인 안에서 레코드를 query하고, 그 레코드의 필드로 각 quote line의 Description 필드를 설정하는 Quote Line Calculator 샘플. 각 버전의 샘플 코드는 calculator가 찾는 모든 메서드를 export하고 그 파라미터·반환 타입을 문서화한다. (EDITIONS — Available in Salesforce CPQ, Winter '16 and later.)

resolving loop에서 JSON 에러를 피하려면 lookup 정보가 필요한 loop를 쓰기 **전에** `conn.query`를 사용한다.

#### 기본 버전

```javascript
export function onAfterCalculate(quote, lines, conn) {
if (lines.length > 0) {
var productCodes = [];
lines.forEach(function(line) {
if (line.record['SBQQ__ProductCode__c']) {
productCodes.push(line.record['SBQQ__ProductCode__c']);
}
});
if (productCodes.length) {
var codeList = "('" + productCodes.join("', '") + "')";
/*
* conn.query() returns a Promise that resolves when the query completes.
*/
return conn.query('SELECT Id, SBQQ__Category__c, SBQQ__Value__c FROM SBQQ__LookupData__c
WHERE SBQQ__Category__C IN ' + codeList)
.then(function(results) {
/*
* conn.query()'s Promise resolves to an object with three attributes:
* - totalSize: an integer indicating how many records were returned
* - done: a boolean indicating whether the query has completed
* - records: a list of all records returned
*/
if (results.totalSize) {
var valuesByCategory = {};
results.records.forEach(function(record) {
valuesByCategory[record.SBQQ__Category__c] = record.SBQQ__Value__c;
});
lines.forEach(function(line) {
if (line.record['SBQQ__ProductCode__c']) {
line.record['SBQQ__Description__c'] =
valuesByCategory[line.record['SBQQ__ProductCode__c']] || '';
}
});
}
});
}
}
return Promise.resolve();
}
```

#### Method-Chaining 사용 버전

이 플러그인은 method-chaining 스타일로 query를 구성하며, query를 동적으로 구성하고 싶을 때 유용하다.

```javascript
/**
* Created on 9/27/16.
*/
export function onAfterCalculate(quote, lines, conn) {
if (lines.length) {
var codes = [];
lines.forEach(function(line) {
var code = line.record['SBQQ__ProductCode__c'];
if (code) {
codes.push(code);
}
});
if (codes.length) {
var conditions = {
SBQQ__Category__c: {$in: codes}
};
var fields = ['Id', 'Name', 'SBQQ__Category__c', 'SBQQ__Value__c'];
/*
* Queries can also be constructed in a method-chaining style.
*/
return conn.sobject('SBQQ__LookupData__c')
.find(conditions, fields)
.execute(function(err, records) {
if (err) {
return Promise.reject(err);
} else {
var valuesByCategory = {};
records.forEach(function(record) {
valuesByCategory[record.SBQQ__Category__c] = record.SBQQ__Value__c;
});
lines.forEach(function(line) {
if (line.record['SBQQ__ProductCode__c']) {
line.record['SBQQ__Description__c'] =
valuesByCategory[line.record['SBQQ__ProductCode__c']] || '';
}
});
}
});
}
}
return Promise.resolve();
}
```

### C-4. Insert Records

레코드를 insert하는 Quote Line Calculator 샘플. 이 샘플 코드는 calculator가 찾는 모든 메서드를 export하고 그 파라미터·반환 타입을 문서화한다 [sic — PDF 원문 "JavaSciprt" 오타]. (EDITIONS — Available in Salesforce CPQ, Winter '16 and later.)

```javascript
export function onAfterCalculate(quote, lines, conn) {
if (lines.length) {
var codes = [];
lines.forEach(function(line) {
var code = line.record['SBQQ__ProductCode__c'];
if (code) {
codes.push(code);
}
});
if (codes.length) {
var conditions = {
SBQQ__Category__c: {$in: codes}
};
var fields = ['Id', 'Name', 'SBQQ__Category__c', 'SBQQ__Value__c'];
return conn.sobject('SBQQ__LookupData__c')
.find(conditions, fields)
.execute(function(err, records) {
console.log(records);
if (err) {
return Promise.reject(err);
} else {
var valuesByCategory = {};
records.forEach(function(record) {
valuesByCategory[record.SBQQ__Category__c] = record.SBQQ__Value__c;
});
var newRecords = [];
lines.forEach(function(line) {
var code = line.record['SBQQ__ProductCode__c'];
var desc = line.record['SBQQ__Description__c'];
if (code && desc && !valuesByCategory[code]) {
newRecords.push({
SBQQ__Category__c: code,
SBQQ__Value__c: line.record['SBQQ__Description__c']
});
}
});
if (newRecords.length) {
return conn.sobject('SBQQ__LookupData__c')
.create(newRecords, function(err, ret) {
console.log(ret);
});
}
}
});
}
}
return Promise.resolve();
}
```

---

## D. JavaScript Page Security Plugin

CPQ quote에서 필드 가시성·편집성을 제어하는 JavaScript 함수. (EDITIONS — Available in Salesforce CPQ, Summer '15 and later.)

JavaScript Page Security 플러그인은 **4개 함수**를 지원한다.
- `isFieldVisible`·`isFieldEditable` — CPQ Summer '15부터 사용 가능, **quote line 필드**의 가시성·편집성 제어.
- `isFieldVisibleForObject`·`isFieldEditableForObject` — CPQ Summer '19부터 사용 가능, **quote 필드와 quote line 필드 둘 다** 가시성·편집성 제어.

이 함수들 중 하나를 사용하는 메서드가 **False**를 반환하면 CPQ는 선택된 필드를 잠그거나 숨긴다. 메서드가 **Null 또는 True**를 반환하면 필드는 변경되지 않는다.

`isFieldVisibleForObject`·`isFieldEditableForObject`는 quote 또는 quote line을 받을 수 있으므로, object 파라미터 이름을 `quoteOrLine`으로 짓는 것을 권장한다.

> [!note]
> - CPQ는 page security plugin보다 **field-level security를 우선**한다. 어떤 필드가 read-only인데 그 필드의 editability 함수가 True를 반환해도, 필드는 read-only로 남는다.
> - page security plugin은 필드의 **숨김·표시·편집성 조정 전용**으로만 쓴다. 필드 값을 바꾸려면 JavaScript Quote Calculator Plugin을 쓴다.
> - quote line editor는 page security plugin으로 숨긴 quote line drawer 필드 자리에 빈 공간을 보여준다. 이 공간을 없애려면 CPQ line editor 패키지 설정에서 Enable Compact Mode를 선택한다.

page security plugin을 만들려면 custom script 레코드에 코드를 정의한 뒤, CPQ Plugin 패키지 설정의 Quote Calculator Plugin 필드에 그 레코드 이름을 참조한다. 이미 그 필드에 quote calculator plugin을 쓰고 있으면, page security plugin 코드를 calculator plugin의 custom script 레코드에 추가할 수 있다.

> 아래 Table 4–7은 4개 함수의 파라미터 정의표(Parameter / Type / Definition)다. 가시성 매트릭스가 아니다.

### Table 4 — isFieldVisible (Summer '15)

| Parameter | Type | Definition |
|---|---|---|
| `fieldname` | string | If `isFieldVisible` returns False, this quote line field is hidden. |
| `line` | SObject | The quote line object |
| `conn` | Object | Methods access jsforce through the optional parameter `conn`. |

### Table 5 — isFieldEditable (Summer '15)

| Parameter | Type | Definition |
|---|---|---|
| `fieldname` | string | If `isFieldEditable` returns False, this quote line field is locked from edits. |
| `line` | SObject | The quote line object |
| `conn` | Object | Methods access jsforce through the optional parameter `conn`. |

### Table 6 — isFieldVisibleForObject (Summer '19)

| Parameter | Type | Definition |
|---|---|---|
| `fieldName` | String | A field on the quote or quote line. If `isFieldVisibleForObject` returns False, this field is hidden. |
| `quoteOrLine` | SObject | The object containing the field that you're evaluating to determine whether `fieldName` is visible. Can be a quote or a quote line. |
| `conn` | Object | Methods access jsforce through the optional parameter `conn`. |
| `objectName` | String | The object that contains `fieldName`. If `quoteOrLine` is evaluating a quote, use `Quote__c`. If `quoteOrLine` is evaluating a quote line, use `QuoteLine__c`. Leave this parameter undefined to target the same field on the quote and the quote line. |

### Table 7 — isFieldEditableForObject (Summer '19)

| Parameter | Type | Definition |
|---|---|---|
| `fieldName` | String | A field on the quote or quote line. If `isFieldEditableForObject` returns False, this field is locked from edits. |
| `quoteOrLine` | SObject | The object containing the field that you're evaluating to determine whether `fieldName` is editable. Can be a quote or a quote line. |
| `conn` | Object | Methods access jsforce through the optional parameter `conn`. |
| `objectName` | String | The object that contains `fieldName`. If `quoteOrLine` is evaluating a quote, use `Quote__c`. If `quoteOrLine` is evaluating a quote line, use `QuoteLine__c`. Leave this parameter undefined to target the same field on the quote and the quote line. |

### Summer '19 권고 + objectName 분기

CPQ Summer '19 이상 사용자는 향상된 유연성 때문에 새 함수 사용을 **강력히 권장**한다. 플러그인이 `line` 파라미터를 쓰는 pre-Summer '19 함수를 `isFieldEditableForObject`·`isFieldVisibleForObject` 함수와 함께 사용하면, CPQ는 새 함수를 무시하고 옛 함수를 대신 사용한다.

변경을 quote 필드에 적용할지 quote line 필드에 적용할지 지정하려면, `isFieldVisibleForObject`·`isFieldEditableForObject` 코드 블록 안에서 `objectName`에 대한 if 문을 쓴다. 예를 들어 다음 코드는 quote의 Markup Rate 필드를 타깃으로 한다.

```javascript
export function isFieldEditableForObject(fieldName, quoteOrLine, conn, objectName){
if (objectName === 'Quote__c' && fieldName === 'SBQQ__MarkupRate__c')
```

그러나 다음 코드는 quote와 quote line **둘 다**의 Markup Rate를 타깃으로 한다.

```javascript
export function isFieldEditableForObject(fieldName, quoteOrLine, conn, objectName){
if fieldName === 'SBQQ__MarkupRate__c'
```

> [sic — PDF 원문] 위 두 번째 코드의 `if fieldName === ...` 은 PDF 원문 그대로로, 조건식 괄호가 누락돼 있다.

**Example:** quote의 Customer Discount가 10%를 초과하면 quote의 Markup Rate 필드를 편집 잠금한다.

```javascript
export function isFieldEditableForObject(fieldName, quoteOrLine, conn, objectName){
if (objectName === 'Quote__c' && fieldName === 'SBQQ__MarkupRate__c') {
if (quoteOrLine.SBQQ__CustomerDiscount__c > 10) {
return false;
}
}
}
```

**Example:** quote line의 Distributor Discount가 10%를 초과하면 quote line의 Markup Rate 필드를 숨긴다.

```javascript
export function isFieldVisibleForObject(fieldName, quoteOrline, conn, objectName){
if (objectName === 'QuoteLine__c' && fieldName === 'SBQQ__MarkupRate__c') {
if (quoteOrLine.SBQQ__CustomerDiscount__c > 10) {
return false;
}
}
}
```

> [sic — PDF 원문] 위 코드는 파라미터를 `quoteOrline`(소문자 l)으로 선언하지만 본문에서는 `quoteOrLine`을 참조한다. 또한 주석은 Distributor Discount를 숨긴다고 하지만 코드는 `SBQQ__CustomerDiscount__c`를 검사한다 — 코드-주석 불일치 역시 PDF 원문 그대로다.

**Example:** 한 함수가 twin field를 포함해 quote와 quote line 필드를 동시에 평가·처리할 수도 있다. 이 예에서, quote의 Customer Discount가 10%를 초과하면 quote의 Markup Rate 필드를 편집 잠금하고, quote line의 Distributor Discount가 10%를 초과하면 quote line의 Markup Rate 필드를 숨긴다.

```javascript
export function isFieldEditableForObject(fieldName, quoteOrLine, conn, objectName){
if (objectName === 'Quote__c' && fieldName === 'SBQQ__MarkupRate__c') {
if (quoteOrLine.SBQQ__CustomerDiscount__c > 10) {
return false;
}
}
if (objectName === 'QuoteLine__c' && fieldName === 'SBQQ__MarkupRate__c') {
if (quoteOrLine.SBQQ__DistributorDiscount__c > 10) {
return false;
}
}
}
```

---

## E. Legacy Page Security Plugin (Apex)

CPQ Apex page security plugin은 개발자가 CPQ VisualForce 페이지에서 field-level 가시성 또는 data entry mode를 제어하게 한다. (EDITIONS — Available in All Salesforce CPQ Editions.)

> [!note] CPQ는 Apex page security plugin 지원을 **deprecated**했다. 현재 지원되는 버전은 위 JavaScript Page Security Plugin을 참조한다.

Legacy Page Security Plugin은 두 가지 use case를 처리한다.

**각 quote line의 필드를 표시하거나 숨김**
예: training class를 판매하면서 수업에 참여하는 학생 수를 잡고 싶을 때, page security plugin으로 student number 필드를 숨긴다.

**quote line 필드를 read-only 또는 writable로 만듦**
예: 사용자가 각 quote line의 subscription term을 지정하도록 허용하지만 일부 제품은 12개월 단위로만 견적 가능할 때, page security plugin으로 그런 제품에 대해서는 Subscription Term 필드를 read-only로, 다른 제품에 대해서는 writable로 유지한다.

Legacy Page Security Plugin을 쓰려면 먼저 Apex class를 만든 뒤, CPQ 패키지 설정의 Legacy Page Security Plugin 항목에 그 Apex class 이름을 입력한다. Legacy Page Security Plugin에서는 **한 번에 하나의 Apex class만** 호출할 수 있다.

```apex
global class MyPageSecurityPlugin implements SBQQ.PageSecurityPlugin2 {
public Boolean isFieldEditable(String pageName, Schema.SObjectField field) {
return null;
}
public Boolean isFieldEditable(String pageName, Schema.SObjectField field, SObject
record) {
return null;
}
public Boolean isFieldVisible(String pageName, Schema.SObjectField field) {
return null;
}
public Boolean isFieldVisible(String pageName, Schema.SObjectField field, SObject
record) {
if ((pageName == 'EditLines') && (record instanceof SBQQ__QuoteLine__c)) {
SBQQ__QuoteLine__c line = (SBQQ__QuoteLine__c)record;
if ((line.SBQQ__Bundle__c == true) && (field !=
SBQQ__QuoteLine__c.SBQQ__ProductName__c)) {
return false;
}
}
return null;
}
}
```

`SBQQ.PageSecurityPlugin2` 인터페이스는 4개 메서드를 정의한다 — `isFieldEditable`·`isFieldVisible` 각각이 (1) `(String pageName, Schema.SObjectField field)` 와 (2) `(String pageName, Schema.SObjectField field, SObject record)` 두 오버로드를 가진다.

---

## F. Guidelines for Heroku in Quote Calculator Plugins

CPQ quote calculator plugin은 비동기 계산을 수행하기 위해 Heroku를 호출한다. quote calculator plugin을 작성할 때 Heroku 서비스 작업에 대한 가이드라인을 검토한다.

- Quote calculator plugin은 quote line editor UI에서 **동기** 계산을 수행한다 — 표준 웹 브라우저 안에서 모든 예상 platform·browser 정보가 사용 가능한 상태로. 그러나 **비동기** 계산은 웹 브라우저 밖의 Heroku 애플리케이션 안에서 일어난다. 플러그인이 계산을 실행하는 platform의 상태를 참조해야 한다면, quote line editor가 계산을 처리하는지 Heroku가 처리하는지를 반드시 고려한다.
- 플러그인이 본인이 소유한 endpoint로 callout하면, 로컬 Salesforce host와 외부 Heroku host 둘 다 그 endpoint URI에 접근할 수 있게 한다.
- 계산 시간과 시스템에서 Heroku로의 callout 시간을 합한 총 시간은 **30초를 초과할 수 없다.** 초과하면 Heroku가 계산을 종료한다.

---

## 관련 노트
- [[CPQ API Models]] — `QuoteModel`·`QuoteLineModel` 등 plugin이 다루는 11개 데이터 모델의 전체 필드 정의
- [[CPQ Plugins — Search·Recommended·Configurator·기타]] — Product Search·Recommended·External Configurator·Custom Action·Electronic Signature 등 자매 plugin 9종 (QCP 외 나머지)
