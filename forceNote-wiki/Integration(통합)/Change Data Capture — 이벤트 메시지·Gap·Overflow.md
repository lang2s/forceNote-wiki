---
tags: [integration, change-data-capture, cdc, change-event, changeeventheader, gap-event, overflow-event, compound-fields]
source: salesforce_change_data_capture.pdf (Change Data Capture Developer Guide, Version 66.0, Spring '26)
created: 2026-07-13
aliases: [change event message, 이벤트 메시지 구조, ChangeEventHeader fields, changeType, Gap Event, Overflow Event, GAP_OVERFLOW, Merged Change Events, compound fields, 병합 이벤트, 누락 이벤트, 오버플로우]
---

# Change Data Capture — 이벤트 메시지·Gap·Overflow

> Change Event 메시지의 wire-level 구조 — ChangeEventHeader 12필드, changeType enum 10종, 병합(Merged)·누락(Gap)·오버플로우(Overflow) 이벤트, compound 필드 중첩 표현.

---

## Change Event Message Structure

Change event 메시지는 **header 필드 + record 필드**로 구성된다. 아래는 Pub/Sub API 클라이언트에서 수신한 이벤트 메시지 payload의 구조다.

```json
{
"ChangeEventHeader": {
"entityName": "...",
"recordIds": [...],
"changeType": "",
"changeOrigin": "",
"transactionKey": "",
"sequenceNumber": ,
"commitTimestamp": ,
"commitNumber": ,
"commitUser": "",
"nulledFields": [...],
"diffFields": [...],
"changedFields": [...]
},
"field1": "...",
"field2": "...",
...
}
```

> Note: Pub/Sub API 클라이언트에서 수신한 이벤트 메시지는 binary Apache Avro 포맷이다. 수신 이벤트에서 schema, replay ID, payload를 각각 조회하고 payload를 디코드해 ChangeEventHeader와 record 필드를 얻는다. 위 예제는 payload 필드만 보여준다. 자세한 내용은 Pub/Sub API 문서의 *Pub/Sub API as a gRPC API* 참조. 또한 Pub/Sub API로 수신한 이벤트는 이 ChangeEventHeader 필드들을 포함한다: `nulledfields`, `diffFields`.

### Change Event Fields

Change event가 포함할 수 있는 필드는 연결된 상위 Salesforce 오브젝트의 필드에 대응한다 (몇 가지 예외 있음). 예를 들어 AccountChangeEvent 필드는 Account의 필드에 대응한다.

Change event가 **포함하지 않는** 필드:

- **IsDeleted** 시스템 필드.
- **SystemModStamp** 시스템 필드.
- 값이 레코드에 있지 않고 다른 레코드나 formula에서 파생되는 모든 필드. 단 **roll-up summary 필드와 custom formula 필드는 포함**된다. 파생 값을 갖는 필드 예: **LastActivityDate**, **PhotoUrl**.

각 change event는 header 필드도 포함한다. Header 필드는 `ChangeEventHeader` 필드 안에 들어 있으며, 변경이 update인지 delete인지, 오브젝트명(예: Account) 등 이벤트에 대한 정보를 담는다.

### API Version and Event Schema

Change event를 구독하면, 구독은 클라이언트가 쓰는 API 버전과 무관하게 **최신 API 버전**을 사용한다. 수신되는 이벤트 메시지는 해당 Salesforce 오브젝트의 최신 필드 정의를 반영한다. 오브젝트 스키마가 바뀌면(필드 추가·필드 타입 변경 등) schema ID가 바뀐다. Change event는 새 schema ID를 `schema` 필드에 담는다.

이벤트 스키마는 REST API 또는 Pub/Sub API로 얻을 수 있다.

Pub/Sub API로 이벤트를 구독하는 경우, `GetSchema` RPC 메서드로 이벤트 스키마를 얻는다.

```
rpc GetSchema (SchemaRequest) returns (SchemaInfo);
```

자세한 내용은 Pub/Sub API Developer Guide의 *GetSchema RPC Method* 참조.

CometD 클라이언트를 쓰는 경우 REST API로 이벤트 스키마를 얻는다. Change event 메시지의 전체 스키마를 얻으려면, 이벤트 메시지에 담겨 온 schema ID를 포함해 REST API에 GET 요청한다:

```
/vXX.X/event/eventSchema/<Schema_ID>?payloadFormat=COMPACT
```

또는 다음 리소스에 GET 요청한다.

```
/vXX.X/sobjects/<EventName>/eventSchema?payloadFormat=COMPACT
```

`<EventName>`은 change event의 이름 (예: `AccountChangeEvent`).

이벤트 스키마 REST API 리소스는 schema ID를 `uuid` 필드로 반환한다. 스키마를 이전 버전과 비교하려면 이전 schema ID와 현재 schema ID로 각각 스키마를 조회한다. 이벤트 스키마 REST API 리소스는 platform event에도 쓰인다. 자세한 내용은 REST API Developer Guide의 *Platform Event Schema by Event Name*, *Platform Event Schema by Schema ID* 참조.

### Change Event Example (Pub/Sub API) — CREATE Account

새 account에 대해 Pub/Sub API 클라이언트로 전송되는 이벤트 메시지다.

> ⚠️ 아래 JSON은 PDF(pdftotext) 출력을 **원문 그대로** 재현한 것이다. `SLAExpirationDate__c` 줄에 trailing comma가 없고, 끝에 닫는 중괄호가 여분으로 하나 더 있다 — PDF quirk를 검증용으로 그대로 보존한다.

```json
{
"ChangeEventHeader": {
"entityName": "Account",
"recordIds": [
"0015f00002J9YYEAA3"
],
"changeType": "CREATE",
"changeOrigin": "com/salesforce/api/soap/60.0;client=SfdcInternalAPI/",
"transactionKey": "0001ade9-3f74-0b99-dbc4-42e73424b774",
"sequenceNumber": 1,
"commitTimestamp": 1712693965000,
"commitNumber": 1082985383811,
"commitUser": "0055f000005mc66AAA",
"nulledFields": [],
"diffFields": [],
"changedFields": []
},
"Name": "Acme",
"Type": null,
"ParentId": null,
"BillingAddress": null,
"ShippingAddress": null,
"Phone": null,
"Fax": null,
"AccountNumber": null,
"Website": null,
"Sic": null,
"Industry": null,
"AnnualRevenue": null,
"NumberOfEmployees": null,
"Ownership": null,
"TickerSymbol": null,
"Description": "Sample account record.",
"Rating": null,
"Site": null,
"OwnerId": "0055f000005mc66AAA",
"CreatedDate": 1712693965000,
"CreatedById": "0055f000005mc66AAA",
"LastModifiedDate": 1712693965000,
"LastModifiedById": "0055f000005mc66AAA",
"Jigsaw": null,
"JigsawCompanyId": null,
"CleanStatus": "Pending",
"AccountSource": null,
"DunsNumber": null,
"Tradestyle": null,
"NaicsCode": null,
"NaicsDesc": null,
"YearStarted": null,
"SicDesc": null,
"DandbCompanyId": null,
"OperatingHoursId": null,
"CustomerPriority__c": null,
"SLA__c": null,
"Active__c": null,
"NumberofLocations__c": null,
"UpsellOpportunity__c": null,
"SLASerialNumber__c": null,
"SLAExpirationDate__c": null
"Custom_Formula_Field_Example_Priority__c": "Low Priority",
"Custom_Formula_Field_Example_Number__c": 1,
"Custom_Formula_Field_Example_Email__c": "example@salesforce.com"}
}
```

---

## ChangeEventHeader Fields

각 change event header는 아래 12필드를 담는다. **여기 정의는 메시지(wire) 레벨 필드 정의**다. Apex 트리거 안에서 `ChangeEventHeader` 프로퍼티에 접근하는 방법은 [[ChangeEventHeader]] 참조.

| 필드 | 타입 | 설명 |
|---|---|---|
| **entityName** | string | 변경이 발생한 표준/커스텀 오브젝트의 API 이름. 예: `Account` 또는 `MyObject__c`. |
| **recordIds** | string[] | 변경된 레코드의 하나 이상 ID. 일반적으로 ID 하나. 한 트랜잭션에서 같은 오브젝트 타입 여러 레코드에 1초 내 동일 변경이 발생하면 Salesforce가 알림을 병합해 모든 영향 레코드에 대해 하나의 change event를 보내고, `recordIds`에 동일 변경을 가진 모든 레코드 ID를 담는다. 동일 변경 예: (1) Account 레코드들의 fieldA를 valueA로 update, (2) Account 레코드 삭제, (3) picklist 값 rename/replace로 모든 영향 레코드의 필드 값 변경. **와일드카드 값**: 커스텀 필드 타입 변환으로 데이터 손실이 발생하는 경우, `recordIds` 값은 오브젝트의 3글자 prefix 뒤에 와일드카드 `*`를 붙인 값이 된다. 예: account는 `001*`. (*Conversions That Generate a Change Event* 참조) |
| **changeType** | Enumeration | 변경을 일으킨 작업. 아래 enum 값 중 하나. |
| **changeOrigin** | string | API 앱 또는 Lightning Experience에서 수행된 변경에 대해서만 채워짐; 그 외에는 빈 값. 변경을 시작한 Salesforce API와 API 클라이언트 ID(클라이언트가 설정한 경우). 이 필드로 내 앱이 변경을 시작했는지 감지해, 변경을 다시 처리하지 않고 깊은 변경 순환을 피한다. 형식: `com/salesforce/api/<API_Name>/<API_Version>;client=<Client_ID>`. `<API_Name>`은 데이터 변경에 쓰인 Salesforce API 이름으로 다음 값 중 하나: `soap`, `rest`, `bulkapi`, `xmlrpc`, `oldsoap`, `toolingsoap`, `toolingrest`, `apex`, `apexdebuggerrest`. `<API_Version>`은 변경한 API 호출의 버전(`XX.X` 형식). `<Client_ID>`는 변경을 시작한 앱의 client ID 문자열. API 호출에 client ID가 설정되지 않으면 `client=<Client_ID>`는 붙지 않는다. 예: `com/salesforce/api/soap/49.0;client=Astro`. Client ID는 API 호출의 Call Options header에 설정한다 — REST API: *Sforce-Call-Options Header* (Bulk API·Bulk API 2.0도 Sforce-Call-Options 사용), SOAP API: *CallOptions Header* (Apex API도 CallOptions element 사용). |
| **transactionKey** | string | 각 Salesforce 트랜잭션을 고유하게 식별하는 문자열. 이 키로 동일 트랜잭션에서 이뤄진 모든 변경을 식별·그룹핑한다. |
| **sequenceNumber** | int | 트랜잭션 내 변경의 순번. 1부터 시작. Lead conversion이 여러 변경을 가질 수 있는 트랜잭션의 예로, 동일 트랜잭션 내에서 다음 순서의 변경을 일으킨다: (1) account 생성, (2) contact 생성, (3) opportunity 생성, (4) lead 업데이트. (*Change Events for Lead Conversion* 참조) |
| **commitTimestamp** | long | 변경이 발생한 날짜·시간. 1970-01-01 00:00:00 GMT 이후 밀리초 수. |
| **commitUser** | string | 변경 작업을 실행한 사용자의 ID. |
| **commitNumber** | long | 커밋된 트랜잭션의 system change number (SCN). 순차적으로 증가. 진단 목적으로 제공. 값이 Salesforce 내에서 고유하다고 보장되지 않으며 — 단일 데이터베이스 인스턴스 내에서만 고유. org가 다른 데이터베이스 인스턴스로 마이그레이션되면 commit number가 고유하지 않거나 순차적이지 않을 수 있다. |
| **nulledfields** | string[] | Apex 트리거·Pub/Sub API에서만 사용 가능. CometD에서는 불가. update 작업에서 값이 null로 바뀐 필드 이름들을 담는다. update에서 필드가 null로 바뀌었는지(변경되지 않은 필드가 아니라) 판단하는 데 쓴다. Pub/Sub API에서는 내용을 읽기 전에 이 필드를 디코드한다. (*Event Deserialization Considerations* 참조) |
| **diffFields** | string[] | Apex 트리거·Pub/Sub API에서만 사용 가능. CometD에서는 불가. 큰 텍스트 값을 담고 있어 unified diff로 전송되는 필드 이름들을 담는다. (*Sending Data Differences for Fields of Updated Records* 참조) Pub/Sub API에서는 내용을 읽기 전에 디코드한다. |
| **changedFields** | string[] | update 작업에서 변경된 필드 목록. LastModifiedDate 시스템 필드 포함. 레코드 생성 등 다른 작업에서는 이 필드가 비어 있다. Pub/Sub API에서는 내용을 읽기 전에 디코드한다. |

> [!note] **원문 casing quirk:** PDF의 필드 표에서 null 필드 header 행은 `nulledfields`(소문자 f)로 표기돼 있고, 메시지 구조 envelope과 JSON 예제에서는 `nulledFields`(대문자 F)로 표기된다. 표와 envelope 양쪽 모두 원문 그대로 보존했다.

### changeType Enum — 전수 (10종)

**Normal change events (5):**

- `CREATE`
- `UPDATE`
- `DELETE`
- `UNDELETE`
- `SNAPSHOT` — reserved for future use (향후 사용을 위해 예약)

**Gap events — `GAP_` prefix (4):**

- `GAP_CREATE`
- `GAP_UPDATE`
- `GAP_DELETE`
- `GAP_UNDELETE`

**Overflow events (1):**

- `GAP_OVERFLOW`

> 총 distinct 값 10종: CREATE, UPDATE, DELETE, UNDELETE, SNAPSHOT, GAP_CREATE, GAP_UPDATE, GAP_DELETE, GAP_UNDELETE, GAP_OVERFLOW.

---

## Change Event Body Fields

Change event 메시지의 body는 해당 Salesforce 레코드의 필드와 값을 담는다. 어떤 필드가 포함되는지는 **클라이언트 종류(Pub/Sub API · Apex · CometD)와 작업(Create/Update/Delete/Undelete)**에 따라 다르다.

| 작업 | Pub/Sub API 클라이언트 | Apex 트리거 | CometD (JSON) 클라이언트 |
|---|---|---|---|
| **Create** | 모든 record·system 필드 포함 (비어 있어도). | 채워졌든 비었든 모든 필드 포함. default 값 필드와 시스템 필드(CreatedDate, OwnerId 등) 포함. | 비어 있지 않은 모든 필드 + 시스템 필드(CreatedDate, OwnerId 등) 포함. |
| **Update** | 모든 record·system 필드 포함 (변경 없거나 비어 있어도). 변경 안 된 필드는 레코드에 값이 있어도 빈 값. null로 설정된 필드는 빈 값으로 포함. 변경된 필드 판별은 `changedFields`(디코드 후) 확인. null로 설정된 필드만 찾으려면 `nulledFields`(디코드 후) 확인. | 변경된 필드에 대해서만 값 포함. 변경 안 된 필드는 present이나 빈(null) 값(레코드에 값이 있어도). `LastModifiedDate` 시스템 필드 포함. `LastModifiedById`는 변경된 경우에만 포함 — 레코드를 수정한 사용자가 이전에 저장한 사용자와 다를 때. | 변경된 필드만 포함. 빈 값(null)으로 업데이트된 경우에만 빈 필드 포함. `LastModifiedDate` 시스템 필드 포함. `LastModifiedById`는 변경된 경우에만 포함. |
| **Delete** | record·system 필드 값 없음. 모든 필드는 포함되나 빈 값. | 모든 record 필드가 빈(null) 값. | 어떤 필드도, 시스템 필드도 포함하지 않음. |
| **Undelete** | 원본 레코드의 모든 record·system 필드 포함. 빈 필드는 빈 값으로 포함. | 원본 레코드의 모든 필드 포함 — 빈(null) 필드와 시스템 필드 포함. | 원본 레코드의 비어 있지 않은 모든 필드 + 시스템 필드 포함. |

Apex의 경우: change event 메시지의 필드는 다른 Apex 타입처럼 **정적으로 정의**되므로, 수행된 작업과 무관하게 모든 record 필드가 change event 메시지에서 사용 가능하다. 메시지는 빈(null) 필드를 포함할 수 있다.

Change event 메시지 예제는 *Change Data Capture Basics* Trailhead 모듈 참조.

---

## Merged Change Events

효율을 위해, 같은 오브젝트 타입의 여러 레코드에 1초 내 동일 변경이 발생하면 한 트랜잭션의 change event들이 하나의 이벤트로 병합될 때가 있다. 병합 시 Salesforce는 모든 영향 레코드에 대해 하나의 change event를 보내고, `recordIds`에 동일 변경을 가진 모든 레코드 ID를 담는다.

동일 변경 예:

- Account 레코드들의 fieldA를 valueA로 update.
- Account 레코드 삭제.
- picklist 값 rename/replace로 모든 영향 레코드의 필드 값 변경.

`recordIds` 필드에 대한 자세한 내용은 위 *ChangeEventHeader Fields* 참조.

> Example: 하나의 update Apex DML 문으로 세 Account 레코드의 Industry 필드를 Apparel로 update하면, 아래처럼 하나의 병합된 change event가 전송된다. `recordIds`는 동일 변경을 가진 Account 레코드 ID들을 담는다.

```json
{
"ChangeEventHeader": {
"entityName": "Account",
"recordIds": [
"0015f00002JUZPDAA5",
"0015f00002JUZPXAA5",
"0015f00002JUZPcAAP"
],
"changeType": "UPDATE",
"changeOrigin": "com/salesforce/api/soap/60.0;client=devconsole",
"transactionKey": "00065380-d1a9-a64a-9341-14f6f12f674c",
"sequenceNumber": 1,
"commitTimestamp": 1714170102000,
"commitNumber": 1100823480049,
"commitUser": "0055f000005mc66AAA",
"nulledFields": [],
"diffFields": [],
"changedFields": [
"0x400800"
]
},
"Name": null,
"Type": null,
"ParentId": null,
"BillingAddress": null,
"ShippingAddress": null,
"Phone": null,
"Fax": null,
"AccountNumber": null,
"Website": null,
"Sic": null,
"Industry": "Apparel",
"AnnualRevenue": null,
"NumberOfEmployees": null,
"Ownership": null,
"TickerSymbol": null,
"Description": null,
"Rating": null,
"Site": null,
"OwnerId": null,
"CreatedDate": null,
"CreatedById": null,
"LastModifiedDate": 1714170102000,
"LastModifiedById": null,
"Jigsaw": null,
"JigsawCompanyId": null,
"CleanStatus": null,
"AccountSource": null,
"DunsNumber": null,
"Tradestyle": null,
"NaicsCode": null,
"NaicsDesc": null,
"YearStarted": null,
"SicDesc": null,
"DandbCompanyId": null,
"OperatingHoursId": null,
"CustomerPriority__c": null,
"SLA__c": null,
"Active__c": null,
"NumberofLocations__c": null,
"UpsellOpportunity__c": null,
"SLASerialNumber__c": null,
"SLAExpirationDate__c": null
}
```

Pub/Sub API 클라이언트에서 디코드한 후, `changedFields` 필드는 Industry 필드를 변경된 필드 중 하나로 나열한다.

```
2024-04-26 15:21:43,674 [grpc-default-executor-0] java.lang.Class ============================
2024-04-26 15:21:43,674 [grpc-default-executor-0] java.lang.Class Changed Fields
2024-04-26 15:21:43,674 [grpc-default-executor-0] java.lang.Class ============================
2024-04-26 15:21:43,674 [grpc-default-executor-0] java.lang.Class - Industry
2024-04-26 15:21:43,674 [grpc-default-executor-0] java.lang.Class - LastModifiedDate
2024-04-26 15:21:43,674 [grpc-default-executor-0] java.lang.Class ============================
```

---

## Gap Events

Salesforce는 때때로 change event 대신 **gap event**를 보내 구독자에게 오류를 알리거나, change event 생성이 불가능함을 알린다. Gap event는 header에 변경 타입·레코드 ID 같은 변경 정보를 담지만, record 필드 같은 변경 상세는 포함하지 않는다.

Gap event를 일으키는 조건 (4가지):

- Change event 크기가 최대 **1 MB** 메시지 크기를 초과.
- 일부 커스텀 필드 타입 변환. (*Conversions That Generate a Gap Event* — page 107 참조)
- Salesforce 내부 오류가 발생해 change event 생성이 막힐 때.
- Application server 트랜잭션 밖에서 발생해 데이터베이스에 직접 적용되는 변경. 예: activity 아카이빙 또는 데이터베이스의 data cleanup job. 이런 작업을 놓치지 않도록 gap event가 생성돼 변경을 알린다.

Gap event가 header에 가질 수 있는 `changeType` 값 (4가지):

- `GAP_CREATE`
- `GAP_UPDATE`
- `GAP_DELETE`
- `GAP_UNDELETE`

> Note: `changeType` 값이 `GAP_OVERFLOW`이면 그 이벤트는 overflow event다. 자세한 내용은 아래 *Overflow Events* 참조.

Gap event 메시지를 수신하면, 애플리케이션은 record ID 값으로 Salesforce 레코드를 조회해 현재 데이터를 얻을 수 있다. Gap event 처리는 *How to Handle a Gap Event in Transaction-Based Replication Steps* 참조.

**transactionKey semantics:** Gap event의 `transactionKey`는, 변경이 application server 트랜잭션 밖 데이터베이스 계층에서 적용된 경우 내부 데이터베이스 트랜잭션 ID를 나타낸다. Gap event가 다른 이유(예: 1 MB 이벤트 크기 한도 도달 또는 내부 오류)로 발행된 경우엔 application server 트랜잭션 ID를 담는다.

> Note: 동일 타입의 변경이 동일 트랜잭션 내 동일 Salesforce entity에 발생하면, 여러 gap event가 하나의 gap event로 병합될 때가 있다. 변경된 레코드 ID들은 `recordIds` header 필드에 포함된다. (*Merged Change Events* 참조)

> Example: 아래 샘플 gap event는 account 생성에 대한 것이며 header에 변경 정보를 담는다. 변경 타입은 `GAP_CREATE`다.

```json
{
"ChangeEventHeader": {
"entityName": "Account",
"recordIds": [
"001ZM000001n4n5YAA"
],
"changeType": "GAP_CREATE",
"changeOrigin": "",
"transactionKey": "000a50de-05dd-07c4-22fb-44b7f9e72ab5",
"sequenceNumber": 19,
"commitTimestamp": 1714417112000,
"commitNumber": 72784468115,
"commitUser": "005ZM000000Q6ipYAC",
"nulledFields": [],
"diffFields": [],
"changedFields": []
},
"Name": null,
"Type": null,
"ParentId": null,
"BillingAddress": null,
"ShippingAddress": null,
"Phone": null,
"Fax": null,
"AccountNumber": null,
"Website": null,
"Sic": null,
"Industry": null,
"AnnualRevenue": null,
"NumberOfEmployees": null,
"Ownership": null,
"TickerSymbol": null,
"Description": null,
"Rating": null,
"Site": null,
"OwnerId": null,
"CreatedDate": null,
"CreatedById": null,
"LastModifiedDate": null,
"LastModifiedById": null,
"Jigsaw": null,
"JigsawCompanyId": null,
"AccountSource": null,
"SicDesc": null,
"External_Account_ID__c": null
}
```

---

## Overflow Events

변경을 더 효율적으로 캡처하기 위해, **임계값을 초과하는 단일 트랜잭션**에 대해 overflow event가 생성된다.

첫 **100,000개** 변경은 change event를 생성한다. 그 양을 초과하는 변경 집합은 그 집합에 포함된 **entity 타입마다 하나의 overflow event**를 생성한다. Overflow event는 단일 트랜잭션에 100,000개를 초과하는 변경이 있을 때 생성된다. Overflow event는 header 필드만 담는다. `changeType` header 값은 구체적 변경 타입 대신 `GAP_OVERFLOW`다. 변경에 해당하는 오브젝트 타입은 `entityName` 필드에 있다. Overflow event는 record 필드나 record ID 같은 변경 상세를 포함하지 않는다.

레코드 생성·삭제·복원은 임계값에 대해 1개 변경으로 계산된다. 레코드 update에서는 **각 필드 변경**이 overflow 임계값에 계산된다. 예: 한 레코드 update에서 세 필드 값이 수정되면 overflow 임계값에 대해 3개 작업으로 계산된다.

대량 작업 트랜잭션은 흔치 않지만, 특정 상황(수백 개 occurrence·참석자가 있는 recurring event 등)에서 발생할 수 있다. 다른 예는 많은 opportunity·contact·activity와 연결된 account의 cascade delete로, 동일 트랜잭션에서 훨씬 많은 레코드를 삭제하게 되는 경우다. **Cascade delete가 동일 트랜잭션에서 120,000개의 account·opportunity·contact·activity 레코드 삭제를 초래하면, 첫 100,000개 레코드 삭제는 delete change event를 생성하고, 나머지 20,000개 레코드는 unique entity마다 하나의 overflow event를 생성한다.**

> Note: 변경이 하나의 change event로 병합될 때가 있으므로, 생성된 change event 수가 항상 변경 수와 같지는 않다. 예: 연속적인 account 삭제는 하나의 change event로 병합될 수 있다. (ChangeEventHeader Fields의 `recordIds` 필드 참조) Apex 트리거가 실행돼 다른 레코드를 생성하면, 동일 트랜잭션에서 더 많은 change event가 생성된다. (*Merged Change Events* 참조)

Overflow event 처리는 *How to Handle an Overflow Event in Transaction-Based Replication Steps* 참조.

> Example: 아래 overflow event는 account에 대한 것이며 header에 변경 정보를 담는다. 변경 타입은 `GAP_OVERFLOW`다. 변경에 대한 record ID는 항상 `000000000000000AAA` (empty record ID)로 설정된다.

```json
{
"ChangeEventHeader": {
"entityName": "Account",
"recordIds": [
"000000000000000AAA"
],
"changeType": "GAP_OVERFLOW",
"changeOrigin": "com/salesforce/api/soap/61.0;client=Workbench/",
"transactionKey": "000a5148-405c-21fe-86ce-03205d7404ad",
"sequenceNumber": 6,
"commitTimestamp": 1714417568000,
"commitNumber": 72784848482,
"commitUser": "005ZM000000M6o1YAC",
"nulledFields": [],
"diffFields": [],
"changedFields": []
},
"Name": null,
"Type": null,
"ParentId": null,
"BillingAddress": null,
"ShippingAddress": null,
"Phone": null,
"Fax": null,
"AccountNumber": null,
"Website": null,
"Sic": null,
"Industry": null,
"AnnualRevenue": null,
"NumberOfEmployees": null,
"Ownership": null,
"TickerSymbol": null,
"Description": null,
"Rating": null,
"Site": null,
"OwnerId": null,
"CreatedDate": null,
"CreatedById": null,
"LastModifiedDate": null,
"LastModifiedById": null,
"Jigsaw": null,
"JigsawCompanyId": null,
"AccountSource": null,
"SicDesc": null,
"External_Account_ID__c": null
}
```

---

## Get Compound Fields in Change Events

Lead·contact의 Name, Address, Geolocation 필드 같은 **compound 필드**는 이벤트 메시지에서 **중첩 필드 구조**로 표현된다. 레코드 update에서 `changedFields` header 필드는 각 업데이트된 component 필드를 다음 포맷으로 나열한다: `CompoundField.ComponentField`. 업데이트된 component 필드는 이벤트 메시지에 중첩 필드 구조로 포함된다.

> Note: component 필드 이름은 해당 Salesforce 오브젝트의 필드 이름과 다를 수 있다. 예: change event에서 BillingAddress의 `Street` 중첩 component 필드는 Account 오브젝트에서 `BillingStreet`다.

Change event의 필드 이름과 구조를 알아내려면 이벤트 스키마를 조회한다. (위 *Change Event Message Structure* 참조) Salesforce 오브젝트에 대한 자세한 내용은 *Standard Objects in the Object Reference for Salesforce and Lightning Platform* 참조.

**관찰된 compound/nested component 필드 (Address 타입):** Street, City, State, PostalCode, Country, Latitude, Longitude, GeocodeAccuracy.

### Compound Field in a New Record

> Example: BillingAddress compound 필드를 가진 account가 생성된 후 수신한 change event. BillingAddress 필드는 component 필드들을 중첩 필드로 담는다.

```json
{
"ChangeEventHeader": {
"entityName": "Account",
"recordIds": [
"0015f00002JUXA8AAP"
],
"changeType": "CREATE",
"changeOrigin": "com/salesforce/api/soap/60.0;client=SfdcInternalAPI/",
"transactionKey": "00006bec-ce66-0611-9018-30a98446c9f2",
"sequenceNumber": 1,
"commitTimestamp": 1714156685000,
"commitNumber": 1100670838951,
"commitUser": "0055f000005mc66AAA",
"nulledFields": [],
"diffFields": [],
"changedFields": []
},
"Name": "Acme",
"Type": null,
"ParentId": null,
"BillingAddress": {
"Street": "415 Mission Street",
"City": "San Francisco",
"State": "CA",
"PostalCode": "94105",
"Country": "United States",
"Latitude": null,
"Longitude": null,
"GeocodeAccuracy": null
},
"ShippingAddress": null,
"Phone": null,
"Fax": null,
"AccountNumber": null,
"Website": null,
"Sic": null,
"Industry": null,
"AnnualRevenue": null,
"NumberOfEmployees": null,
"Ownership": null,
"TickerSymbol": null,
"Description": null,
"Rating": null,
"Site": null,
"OwnerId": "0055f000005mc66AAA",
"CreatedDate": 1714156685000,
"CreatedById": "0055f000005mc66AAA",
"LastModifiedDate": 1714156685000,
"LastModifiedById": "0055f000005mc66AAA",
"Jigsaw": null,
"JigsawCompanyId": null,
"CleanStatus": "Pending",
"AccountSource": null,
"DunsNumber": null,
"Tradestyle": null,
"NaicsCode": null,
"NaicsDesc": null,
"YearStarted": null,
"SicDesc": null,
"DandbCompanyId": null,
"OperatingHoursId": null,
"CustomerPriority__c": null,
"SLA__c": null,
"Active__c": null,
"NumberofLocations__c": null,
"UpsellOpportunity__c": null,
"SLASerialNumber__c": null,
"SLAExpirationDate__c": null
}
```

### Compound Field in an Updated Record

> Example: BillingAddress의 Street component 필드를 update한 후 수신한 change event. Street 필드는 BillingAddress 아래 중첩된다.

```json
{
"ChangeEventHeader": {
"entityName": "Account",
"recordIds": [
"0015f00002JUXA8AAP"
],
"changeType": "UPDATE",
"changeOrigin": "com/salesforce/api/soap/60.0;client=SfdcInternalAPI/",
"transactionKey": "00006bf0-edfd-6e54-a3f9-e8cefdb2c2b7",
"sequenceNumber": 1,
"commitTimestamp": 1714156703000,
"commitNumber": 1100671026205,
"commitUser": "0055f000005mc66AAA",
"nulledFields": [],
"diffFields": [],
"changedFields": [
"0x400000",
"4-0x01"
]
},
"Name": null,
"Type": null,
"ParentId": null,
"BillingAddress": {
"Street": "415 Mission Street Suite B",
"City": null,
"State": null,
"PostalCode": null,
"Country": null,
"Latitude": null,
"Longitude": null,
"GeocodeAccuracy": null
},
"ShippingAddress": null,
"Phone": null,
"Fax": null,
"AccountNumber": null,
"Website": null,
"Sic": null,
"Industry": null,
"AnnualRevenue": null,
"NumberOfEmployees": null,
"Ownership": null,
"TickerSymbol": null,
"Description": null,
"Rating": null,
"Site": null,
"OwnerId": null,
"CreatedDate": null,
"CreatedById": null,
"LastModifiedDate": 1714156703000,
"LastModifiedById": null,
"Jigsaw": null,
"JigsawCompanyId": null,
"CleanStatus": null,
"AccountSource": null,
"DunsNumber": null,
"Tradestyle": null,
"NaicsCode": null,
"NaicsDesc": null,
"YearStarted": null,
"SicDesc": null,
"DandbCompanyId": null,
"OperatingHoursId": null,
"CustomerPriority__c": null,
"SLA__c": null,
"Active__c": null,
"NumberofLocations__c": null,
"UpsellOpportunity__c": null,
"SLASerialNumber__c": null,
"SLAExpirationDate__c": null
}
```

Pub/Sub API 클라이언트에서 `changedFields` header 필드를 디코드한 후, 업데이트된 Street 필드는 `BillingAddress.Street`로 나열된다.

```
2024-04-26 11:38:24,375 [grpc-default-executor-0] java.lang.Class ============================
2024-04-26 11:38:24,375 [grpc-default-executor-0] java.lang.Class Changed Fields
2024-04-26 11:38:24,375 [grpc-default-executor-0] java.lang.Class ============================
2024-04-26 11:38:24,375 [grpc-default-executor-0] java.lang.Class - LastModifiedDate
2024-04-26 11:38:24,375 [grpc-default-executor-0] java.lang.Class - BillingAddress.Street
2024-04-26 11:38:24,375 [grpc-default-executor-0] java.lang.Class ============================
```

---

## 관련 노트

- [[Change Data Capture — 개요·채널 구독]]
- [[Change Data Capture — Enrichment·필터링]]
- [[Change Data Capture — 고려사항·할당량·표준객체]] — 표준객체별 특수 이벤트
- [[ChangeEventHeader]] — Apex 트리거에서 header 필드 접근 (프로퍼티 목록)
- [[ChangeEvent Objects]] — Change Event sObject
- [[Pub-Sub API (gRPC) — Platform Event·CDC 구독]]
