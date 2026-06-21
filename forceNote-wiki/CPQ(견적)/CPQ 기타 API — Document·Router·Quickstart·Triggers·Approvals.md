---
tags: [CPQ, Salesforce CPQ, SBQQ, SBAA, ServiceRouter, Quote Document, Advanced Approvals, 견적서, 트리거제어, Apex, REST]
source: cpq_developer_guide.pdf (Salesforce CPQ Developer Guide, v65.0 Winter '26)
created: 2026-06-21
aliases: [Generate Quote Document API, QuoteDocumentAPI.SaveProposal, GenerateQuoteProposal, SBQQ.ServiceRouter, Service Router, CPQ API Quickstart, Disable CPQ Triggers, SBQQ.TriggerControl, TriggerControl, Advanced Approvals API, Approval API, Reject Approval API, SBAA.ApprovalRestApiProvider, 견적서 문서 생성, CPQ 트리거 비활성화, CPQ 승인 API, 견적 문서 PDF 생성, "CPQ 견적서 PDF 만드는 API", "CPQ 트리거 끄는 법", "CPQ 승인 거부 API"]
---

# CPQ 기타 API — Document·Router·Quickstart·Triggers·Approvals

> Salesforce CPQ(`SBQQ.*`) 및 Advanced Approvals(`SBAA.*`) 패키지의 나머지 API 묶음 — 견적서 문서 생성(Generate Quote Document), 모든 API의 진입점(`SBQQ.ServiceRouter`), 통합 예제(API Quickstart), 트리거 수동 제어(`SBQQ.TriggerControl`), 승인/거부(Advanced Approvals API).

이 문서의 API는 [[CPQ API Models]]의 데이터 모델(예: `QuoteProposalModel`)을 사용하며 `SBQQ.ServiceRouter`를 통해 호출된다. Configuration·Contract API는 [[CPQ Configuration·Contract API]] 참조.

---

## Generate Quote Document API

CPQ quote document(견적서 문서)를 생성·저장한다.

> **Note:** "Proposal" refers to Salesforce CPQ's Quote Document object.

| 속성 | 값 |
|---|---|
| Name (Service Provider) | `QuoteDocumentAPI.SaveProposal` |
| HTTP Method | POST |
| Formats | JSON, Apex |
| EDITIONS | Salesforce CPQ, Winter '19 and later |
| Authentication | Authorization: Bearer token |

**Request — Table 1: Parameters**

| Name | Type | Required | Definition |
|---|---|---|---|
| `Name` | String | No | The document name |
| `paperSize` | String | No | Values are Default, Letter, Legal, A4. Defaults to "Default." |
| `outputFormat` | String | No | Values are PDF, Word. Defaults to "PDF." |
| `quoteId` | ID | Yes | The quote's ID |
| `templateId` | ID | Yes | The quote template's ID |
| `language` | String | No | Defaults to "en_US." |

**Response — Table 2: Parameters**

| Name | Type | Description |
|---|---|---|
| `jobID` | ID | Apex queueable job ID |

**REST 호출 (curl)** (PDF verbatim):

```bash
curl \
"https://yourInstance.salesforce.com/services/apexrest/SBQQ/ServiceRouter?saver=QuoteDocumentAPI.SaveProposal" \
-H "Content-Type: application/json" -H "Authorization: Bearer token" -X POST -d @data.json
```

요청 본문 `data.json` — PDF verbatim:

```json
"{\"saver\":\"SBQQ.QuoteDocumentAPI.Save\",\"model\":\"{\\\"name\\\":\\\"test\\\",\\\"quoteId\\\":\\\"a0n0R000000jhVC\\\",\\\"templateId\\\":\\\"a0l0R000000vahe\\\",\\\"outputFormat\\\":\\\"PDF\\\",\\\"language\\\":\\\"en_US\\\",\\\"paperSize\\\":\\\"Default\\\"}\"}"
```

> 주: saver 값이 본문에서는 `SBQQ.QuoteDocumentAPI.Save`이고 endpoint querystring/Name에서는 `QuoteDocumentAPI.SaveProposal`이다 — PDF 원문 그대로 [sic].

응답 본문 (Apex job 생성 후) — PDF verbatim:

```text
"7070R00000Nj8mjQAB"
```

> **Note:** If the Bearer token contains special characters, enclose the Authorization header in single quotes instead of double quotes.

**Apex 예제 클래스 `GenerateQuoteProposal`** (PDF verbatim) — *Before saving the GenerateQuoteProposal example class, make sure that the CPQ model classes are added as individual APEX classes in your org.*

```apex
public with sharing class GenerateQuoteProposal {
    public String save(QuoteProposalModel context) {
        return SBQQ.ServiceRouter.save('SBQQ.QuoteDocumentAPI.Save',
            JSON.serialize(context));
    }
}
```

Anonymous Apex 사용 예 (Apex job ID 획득, PDF verbatim):

```apex
QuoteProposalModel model = new QuoteProposalModel();
model.quoteId = 'a0n0R000000jhVC';
model.templateId = 'a0l0R000000vahe';
GenerateQuoteProposal proposalGenerator = new GenerateQuoteProposal();
String jobId = proposalGenerator.save(model);
System.debug(jobId);
```

**Usage 주의** (PDF verbatim):

> - Attachments marked Required are ignored when you're using the API. In contrast, when you're using the Preview and Generate document buttons, the attachments are automatically generated as part of the document.
> - An attachment in the Template section is always included regardless of whether it's marked Required. This behavior is also observed when you're using Preview and Generate document buttons.
> - Guest users can't create quote documents in the Documents folder. See Salesforce Help and SOAP API Developer Guide for details.

**SEE ALSO**
- Salesforce Help: Guest User Security Policies and Timelines
- SOAP API Developer Guide: Folder

---

## Service Router

`SBQQ.ServiceRouter`는 모든 API 호출의 단일 진입점 역할을 하는 global Apex 클래스다. Apex 코드, Visualforce Remoting, REST 콜아웃 어디서든 사용할 수 있다.

> **EDITIONS** — Available in Salesforce CPQ, Summer '16 and later.

`SBQQ.ServiceRouter`는 세 개의 global 메서드를 가진다.

| 메서드 | 시그니처 | 설명 |
|---|---|---|
| `read` | `global static String read(String reader, String uid)` | Use the read() method only when it needs a simple unique ID as input. For example, you could use read() when querying for a quote from the database. Provide the quote's ID as the request, and read() returns the QuoteModel object. |
| `load` | `global static String load(String loader, String uid, String context)` | Use the load() method when you need more input information than a simple unique ID, but don't need to change anything in the database. For example, you could use load() if you wanted to load products for a given currency code and pricebook ID. The load() method passes the unique ID as the second parameter. It then passes the extra information as a serialized JSON string in the third parameter. |
| `save` | `global static String save(String saver, String model)` | Use the save() method when you save a model to the database, such as when you save a quote. The save() method passes the model as a serialized JSON string in the second parameter. |

PDF 원문 (라우팅 동작):

> Each method accepts the name of a service provider, such as SBQQ.ProductAPI.ProductLoader as its first parameter. This lets Salesforce CPQ route the API request to the appropriate internal handler. The internal handler isn't global and can't be called directly by code outside the Salesforce CPQ package.

> 주: 첫 번째 인자로 받는 service provider 이름이 어떤 내부 핸들러로 라우팅될지를 결정한다. 내부 핸들러는 global이 아니므로 CPQ 패키지 외부 코드가 직접 호출할 수 없다. REST에서 ServiceRouter를 직접 호출하는 NODEJS 예제는 아래 **CPQ API Quickstart Guide**의 NODEJS 섹션 참조.

---

## CPQ API Quickstart Guide

> **EDITIONS** — Available in Salesforce CPQ, Summer '16 and later.

Salesforce CPQ API를 자신의 플랫폼과 통합하는 예제를 모은 섹션이다.

**Anonymous Apex 예제 (read → add → save)** — *This example reads a quote, adds a product, and saves the quote.* (PDF verbatim)

```apex
/**
 * Note: this doesn't perform a calculation. Reference the calculate API to see how to
   calculate a quote.
 */
//the Id of the quote
String quoteId = 'a0Wf100000J1vk1';
//the Id of the product to add to the quote
String productId = '01tj0000003P1SN';
//the Id of the pricebook for the quote and product being added
String pricebookId = '01sj0000003THhKAAW';
//the currency code
String currencyCode = 'USD';
//the JSON formatted String representing the quote model to add a product to
String quoteModel = SBQQ.ServiceRouter.read('SBQQ.QuoteAPI.QuoteReader', quoteId);
//the JSON formatted String representing the product to be added to the quote
String productModel = SBQQ.ServiceRouter.load('SBQQ.ProductAPI.ProductLoader', productId,
    '{"pricebookId" : "' + pricebookId + '", "currencyCode" : "' + currencyCode + '"}');
//the JSON formatted String representing the quote with the product added to it
String updatedQuoteModel = SBQQ.ServiceRouter.load('SBQQ.QuoteAPI.QuoteProductAdder', null,
    '{"quote" : ' + quoteModel + ', "products" : [' + productModel + '], "ignoreCalculate" : true}');
//the JSON formatted String represeting the saved quote
String savedQuoteModel = SBQQ.ServiceRouter.save('SBQQ.QuoteAPI.QuoteSaver',
    updatedQuoteModel);
```

> 주: 마지막 주석의 "represeting"은 PDF 원문 오타 그대로 [sic].

**NODEJS 예제 (read → add → calculate → save)** — *This example reads a quote, adds a product, calculates the quote, and saves it.* (PDF verbatim)

```javascript
// 3rd party library to call into a Salesforce org
var jsforce = require('jsforce');
// login credentials to the org
var loginUrl = 'https://MyDomainName.my.salesforce.com'; // Your org's My Domain login URL is listed on the My Domain Setup page.
var username = 'admin.user@company.com';
var password = 'password';
// quote and product details
var quoteId = 'a0bA000000FW2o4';
var productId = '01tA0000005NsiA';
var pricebookId = '01tA0000005NsiA';
var currencyCode = 'USD';
// log in to the org with with a valid username and password using jsforce
var conn = new jsforce.Connection({loginUrl: loginUrl});
conn.login(username, password).then(function () {
    return Promise.resolve(conn);
})
.then(function (conn) {
    // read both the quote and the product to add
    var quotePromise =
        conn.apex.get('/SBQQ/ServiceRouter?reader=SBQQ.QuoteAPI.QuoteReader&uid=' + quoteId);
    var productPromise =
        conn.apex.patch('/SBQQ/ServiceRouter?loader=SBQQ.ProductAPI.ProductLoader&uid=' + productId,
        {
            context: JSON.stringify({
                pricebookId: pricebookId,
                currencyCode: currencyCode
            })
        });
    return Promise.all([quotePromise, productPromise]);
})
.then(function (models) {
    // add the retrieved product to the retrieved quote in the first group
    var quoteModel = JSON.parse(models[0]);
    var productModel = JSON.parse(models[1]);
    return conn.apex.patch('/SBQQ/ServiceRouter?loader=SBQQ.QuoteAPI.QuoteProductAdder',
    {
        context: JSON.stringify({
            quote: quoteModel,
            products: [productModel],
            groupKey: 0,
            ignoreCalculate: true
        })
    });
})
.then(function (quoteWithProduct) {
    var quote = JSON.parse(quoteWithProduct);
    // calculate the quote with the added product
    return conn.apex.patch('/SBQQ/ServiceRouter?loader=SBQQ.QuoteAPI.QuoteCalculator', {
        context: JSON.stringify({
            quote: quote
        })
    });
})
.then(function (calculatedQuote) {
    var quote = JSON.parse(calculatedQuote);
    // save the calculated quote
    return conn.apex.post('/SBQQ/ServiceRouter', {
        saver: 'SBQQ.QuoteAPI.QuoteSaver',
        model: JSON.stringify(quote)
    });
})
.then(function (savedQuoted) {
    // log the quote has been saved
    console.log('Quote finished processing', savedQuoted);
});
```

> 주: "with with" 중복은 PDF 원문 그대로 [sic].

---

## Disable CPQ Triggers in Apex

레코드 업데이트 시 Salesforce CPQ·Salesforce Billing 애플리케이션 로직을 수동으로 비활성화할 수 있다. 자신의 custom field를 업데이트할 때나, 한 트랜잭션에서 한 레코드를 여러 번 업데이트하면서 마지막 반복에서만 트리거를 돌리고 싶을 때 유용하다.

> **EDITIONS** — Available in Salesforce CPQ, Summer '16 and later.

PDF 원문:

> You can manually disable Salesforce CPQ and Salesforce Billing application logic when you update records. This process is helpful when you're updating your own custom field. It's also helpful when you update a record several times in one transaction and want triggers to run only on the last iteration.
> To ensure that operational issues don't affect your org when triggers are disabled, test thoroughly. Use the global Apex API `TriggerControl`—the same mechanism that Salesforce CPQ uses internally—to manually disable triggers for the CPQ and Billing and the Service Cloud for CPQ packages.

> **Note:** TriggerControl disables only triggers in CPQ and Billing and in the Service Cloud for CPQ package. Other triggers or Salesforce logic, or your own triggers, validations, workflow rules, or processes, are unaffected.

**Methods — `SBQQ.TriggerControl`** (PDF verbatim 시그니처):

| 메서드 | 시그니처 | 설명 |
|---|---|---|
| `disable` | `global static void disable();` | Disables built-in CPQ triggers within the current transaction. |
| `enable` | `global static void enable();` | Enables built-in CPQ triggers if they had previously been disabled. |
| `isEnabled` | `global static Boolean isEnabled()` | Returns true if CPQ triggers are currently enabled. Otherwise, returns false. |

> 주: `isEnabled()`만 시그니처에 세미콜론이 없다 — PDF 원문 그대로 [sic].

**Example (disable / enable)** (PDF verbatim, 문자열 리터럴 curly quote는 straight quote로 정규화 [sic]):

```apex
SBQQ.TriggerControl.disable();
try {
    // Do something simple and interesting without
    // running triggers.
    quote.MyStatus__c = 'Red';
    update quote;
} finally {
    SBQQ.TriggerControl.enable();
}
```

**Example (isEnabled)** (PDF verbatim):

```apex
if (SBQQ.TriggerControl.isEnabled()) {
    // Only run our logic if CPQ trigger logic is also enabled.
    myRelatedObject.Quote__c = quote.Id;
    insert myRelatedObject;
}
```

---

## Advanced Approvals API

Advanced Approvals 패키지(`SBAA.*`)의 API로 승인 프로세스를 커스터마이즈한다.

> **EDITIONS** — Available in Advanced Approvals Spring '21 and later.

> **Note:** Advanced Approvals API labels are available only in English.

PDF 원문:

> - **Approval API** — Call the Advanced Approvals approval resource from an outside source.
> - **Reject Approval API** — Call the Advanced Approvals reject approval service from an outside source.

두 API 모두 service router 호출 형태로 호출하며, `class`/`method`를 자신의 클래스·메서드 이름으로 치환한다:

```text
ServiceRouter?saver=AA.{class}.{method}
```

> 주: Advanced Approvals endpoint 네임스페이스 표기는 curl 예제에서는 소문자 `sbaa`, 설명·JavaScript 예제에서는 대문자 `SBAA`로 혼용된다 — PDF 원문 그대로 [sic].

---

### Approval API

외부 소스에서 Advanced Approvals approval 리소스를 호출한다.

> **EDITIONS** — Available in Advanced Approvals Spring '21 and later.

**Endpoint** (PDF verbatim):

```text
/services/apexrest/sbaa/ServiceRouter
```

**파라미터**

| Parameter | Required | Description |
|---|---|---|
| `approvalID` | Required | ID of the approval record in Salesforce. |
| `comments` | Optional | Comments about the approval. |

**Sample Request** (PDF verbatim):

> Include a saver in the request body model. When you send the approval request, the CPQ service router evaluates the model and finds the saver attribute. It then takes the value of the saver attribute - in this case, Approve - and maps that to the corresponding Advanced Approvals Apex class.

**Header** (PDF verbatim):

```text
Content type: application/json
Authorization: Bearer [Access token or session ID]
```

**Body** (PDF verbatim):

```json
{
"model":
"{\"approvalId\":\"a4H7Y000001makkUAA\",\"comments\":\"I approve!\"}",
"saver":"SBAA.ApprovalRestApiProvider.Approve"
}
```

**Sample CURL Request** (PDF verbatim — `-d` 페이로드에 curly quote가 섞여 있어 동작 가능한 straight quote로 정규화 [sic], 의미·식별자 동일):

```bash
curl -X POST \
https://velocity-efficiency-9575-dev-ed.develop.my.salesforce.com/services/apexrest/sbaa/ServiceRouter \
-H 'Authorization: Bearer 00D1h0000008LeO!ARIAQL4Aj0OVYWIIcROefe8SYP1579EMEAngBFgql7woUddDbz090f_UBaJ1AjCi3kkHoUvpmTwlCV_hb5w8518ZqbDlSCsl' \
-H 'Content-Type: application/json' \
-d '{"model":"{\"approvalId\":\"a061h000002pIlTAAU\",\"comments\":\"I approve!\"}","saver":"SBAA.ApprovalRestApiProvider.Approve"}'
```

**Example — Google Sheets에서 Approval Service API를 호출하는 JavaScript** (PDF verbatim):

```javascript
function reject() {
    var sheet = SpreadsheetApp.getActiveSheet();
    var data = sheet.getDataRange().getValues();
    // Make a POST request with a JSON payload.
    var model = {
        "approvalId": data[1][0],
        "comments": data[1][1]
    };
    var data = {
        'saver': 'SBAA.ApprovalRestApiProvider.Approve',
        'model': JSON.stringify(model)
    };
    var header = {
        'authorization' : 'Bearer 00Dx0000000IiXXXXX.IshlpUqRUQo3FXXXXXXXXXXXXX'
    };
    var options = {
        'method' : 'post',
        'contentType': 'application/json',
        'headers': header,
        'muteHttpExceptions': false,
        // Convert the JavaScript object to a JSON string.
        'payload' : JSON.stringify(data)
    };
    var response = UrlFetchApp.fetch('https://server/services/apexrest/SBAA/ServiceRouter',
        options);
    var responseText = response.getContentText();
```

> 주: Approve 예제임에도 함수명이 `reject()`로 추출됐고, 함수 본문이 닫는 `}` 없이 끝난다 — PDF 페이지 경계로 인한 분절로 PDF 원문 그대로 [sic]. endpoint 표기 `SBAA/ServiceRouter`(대문자)도 원문 그대로.

---

### Reject Approval API

외부 소스에서 Advanced Approvals reject approval 서비스를 호출한다.

> **EDITIONS** — Available in Advanced Approvals Spring '21 and later.

**Endpoint** (PDF verbatim — `<server>`를 본인 주소로 치환):

```text
<server>/services/apexrest/SBAA/ServiceRouter
```

**Table 3: Approval Service Parameters**

| Parameter | Required | Description |
|---|---|---|
| `approvalID` | Required | ID of the approval record in Salesforce. |
| `comments` | Optional | Comments about the approval. |

**Sample Request** (PDF verbatim):

> Include a saver in the request body model. When you send the approval request, the CPQ service router evaluates the model and finds the saver attribute. It then takes the value of the saver attribute - in this case, Reject - and maps that to the corresponding Advanced Approvals Apex class.

**Header** (PDF verbatim):

```text
Content type: application/json
Authorization: Bearer [Access token or session ID]
```

**Body** (PDF 원문은 유효 JSON이 아니었다 — 첫 `{` 없이 `model:{`로 시작하고 curly quote 혼용 [sic]. saver 값 `SBAA.ApprovalRestApiProvider.Reject`를 유지하며 Approval API Body 형식을 참고해 정규화):

```json
{
"model": "{\"approvalId\":\"a1Sx000000000gF\",\"comments\":\"ok then\"}",
"saver": "SBAA.ApprovalRestApiProvider.Reject"
}
```

**Sample CURL Request** (PDF verbatim — curly quote 정규화 [sic]):

```bash
curl -X POST \
https://velocity-efficiency-9575-dev-ed.develop.my.salesforce.com/services/apexrest/sbaa/ServiceRouter \
-H 'Authorization: Bearer 00D1h0000008LeO!ARIAQL4Aj0OVYWIIcROefe8SYP1579EMEAnXXXXXXXXXXXXXX' \
-H 'Content-Type: application/json' \
-d '{"model":"{\"approvalId\":\"a061h000002pIlTAAU\",\"comments\":\"Rejected\"}","saver":"SBAA.ApprovalRestApiProvider.Reject"}'
```

**Example — Google Sheets에서 Reject Service API를 호출하는 JavaScript** (PDF verbatim):

```javascript
function reject() {
    var sheet = SpreadsheetApp.getActiveSheet();
    var data = sheet.getDataRange().getValues();
    // Make a POST request with a JSON payload.
    var model = {
        "approvalId": data[1][0],
        "comments": data[1][1]
    };
    var data = {
        'saver': 'SBAA.ApprovalRestApiProvider.Reject',
        'model': JSON.stringify(model)
    };
    var header = {
        'authorization' : 'Bearer 00Dx0000000IiSD!ARoAQAiD7e.IshlpUqRUQo3Fu6MSox3y1ToMNdEl8MqXXXXXXXXXXXX'
    };
    var options = {
        'method' : 'post',
        'contentType': 'application/json',
        'headers': header,
        'muteHttpExceptions': false,
        // Convert the JavaScript object to a JSON string.
        'payload' : JSON.stringify(data)
    };
    var response = UrlFetchApp.fetch('server/services/apexrest/SBAA/ServiceRouter',
        options);
    var responseText = response.getContentText();
```

> 주: 함수 본문이 닫는 `}` 없이 끝나고 다음 페이지가 "Salesforce CPQ Plugins" 섹션으로 넘어간다 — PDF 페이지 경계. endpoint 표기 `'server/services/apexrest/SBAA/ServiceRouter'`(http 누락)도 PDF 원문 그대로 [sic].

---

## 관련 노트
- [[CPQ API Models]] — 이 API들이 사용하는 데이터 모델(QuoteProposalModel 등) 정의
- [[CPQ Configuration·Contract API]] — 번들 구성(Loader/Executor/Validator) 및 계약 수정·갱신(Amender/Renewer) API
- [[CPQ Quote API]] — 견적 Read/Add/Calculate/Save API. 여기서 다루는 `SBQQ.ServiceRouter`를 입출력 단일 진입점으로 사용
