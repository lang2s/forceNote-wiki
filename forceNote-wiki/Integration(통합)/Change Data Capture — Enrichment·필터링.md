---
tags: [integration, change-data-capture, cdc, enriched-fields, event-filtering, filter-expression, platform-event-channel-member]
source: salesforce_change_data_capture.pdf (Change Data Capture Developer Guide, Version 66.0, Spring '26)
created: 2026-07-13
aliases: [CDC enrichment, enriched fields, extra fields, 추가 필드, filter event streams, 이벤트 필터, filterExpression, 필터 표현식, EnrichedFields, 채널 필터, FIELD_INTEGRITY_EXCEPTION]
---

# Change Data Capture — Enrichment·필터링

> Change event message에 변경되지 않은 extra 필드를 붙이는 **enrichment**와, 채널 member에 SOQL 기반 **filter expression**을 걸어 매칭되는 event만 받는 **filtering** — 둘 다 `PlatformEventChannelMember`(Tooling / Metadata API)로 구성한다.

---

## 섹션 A — Enrich Change Events with Extra Fields

### A-1. 개요

Change event message는 새 필드·변경된 필드 값만 포함하지만, 데이터 처리·복제를 위해 **변경되지 않은 필드 값**이 필요할 때가 있다. 예를 들어 외부 시스템에서 레코드를 매칭할 external ID 필드를 항상 포함시키거나, 변경된 레코드에 대한 중요 정보를 담는 필드를 항상 넣고 싶을 때 enrichment를 쓴다. **지원되는 타입의 어떤 필드든** enrich 대상으로 선택할 수 있다.

- **지원 subscriber:** Pub/Sub API, CometD (Streaming API), event relays.
- **포함되는 operation:** enriched field는 **update, delete** operation의 change event에 포함된다.
- **미포함 operation:** **create, undelete** operation event에는 포함되지 않는다 (이 event들은 populated field를 모두 담고 있기 때문).
- **hard-deleted record** (Recycle Bin에서 삭제된 레코드): change event가 생성되지 않으므로 enriched field를 사용할 수 없다.
- **enriched field가 empty value일 때:** CometD client·event relay에서는 event message에 **포함되지 않음** / Pub/Sub API client에서는 **null 값으로 포함**.
- **enriched field가 null로 update되면:** enriched field가 아니라 **changed field로** event에 포함된다.

> Note: 클라이언트 측 파싱 코드가 payload에서 changed field만 기대한다면, enriched field의 존재가 코드 변경을 요구할 수 있다. 어떤 필드가 changed인지는 `changedFields` header 필드로 판단한다 (ChangeEventHeader Fields 참조).

**Enrichment 가능 채널:**
- multi-entity를 지원하는 채널 — 표준 `/data/ChangeEvents` 채널, 또는 커스텀 채널(예: `/data/SalesEvents__chn`).
- **single-entity 채널(`/data/<Entity>ChangeEvent`)에는 직접 enrichment를 추가할 수 없다.**
- 예: Account `Industry` 필드를 enrich하려면 `AccountChangeEvent`가 member인 커스텀 채널 `SalesEvents__chn`에 추가한다. 그러면 `/data/SalesEvents__chn` 구독 시 account change event에 `Industry`가 포함된다. 이 필드로 enrich되지 않은 다른 채널(`/data/ChangeEvents` 등)을 구독하면 account change event에 `Industry`가 포함되지 않는다.
- **권장:** enrichment는 표준 `/data/ChangeEvents`가 아니라 **커스텀 채널**에 구성한다. 그래야 표준 채널을 받는 다른 subscriber가 기대하지 않은 unchanged 필드를 받지 않는다. 커스텀 채널 생성은 [[Change Data Capture — 커스텀 채널]] 참조.

### A-2. Enriched fields 지원 필드 타입 (20종 전수)

change event 객체가 담는 필드 중, 아래 필드 타입이 enriched field로 지원된다.

| # | 지원 필드 타입 |
|---|---|
| 1 | Address |
| 2 | Auto Number |
| 3 | Checkbox |
| 4 | Currency |
| 5 | Date, Date/Time, Time |
| 6 | Email |
| 7 | External Lookup Relationship |
| 8 | Geolocation |
| 9 | Hierarchical Relationship on User |
| 10 | Lookup Relationship |
| 11 | Master-Detail Relationship |
| 12 | Name |
| 13 | Number |
| 14 | Percent |
| 15 | Phone (and Fax) |
| 16 | Picklist |
| 17 | Roll-Up Summary |
| 18 | Text |
| 19 | TextArea |
| 20 | URL |

> Note (원문):
> - **Formula fields는 enriched field로 미지원** — change event 자체가 formula 필드를 지원하지 않기 때문.
> - **TextArea는 plain TextArea 타입만 지원.** `TextArea (Long)`, `TextArea (Rich)`, `TextArea (Encrypted)`는 미지원.
> - **Compound field**(Name, Address, Geolocation)는 enriched field로 지원되지만, **전체 compound field만** 지정할 수 있고 **개별 constituent field는 지정할 수 없다.** 예를 들어 Lead의 `Name` 필드로 event를 enrich하면, enriched change event는 `Name` 필드의 일부로 constituent field들(`FirstName`, `MiddleName`, `LastName`, `Suffix`)을 포함한다. CometD client에서는 non-empty constituent field만 compound field의 일부로 반환된다. Pub/Sub API client에서는 null 필드를 포함한 모든 constituent field가 반환된다.
> - **Relationship field**는 그 필드 자체만 enriched field로 선택할 수 있고, related object의 필드로 **traverse할 수 없다.** enriched change event는 related record의 **ID**를 포함한다. 예를 들어 contact change event를 관련 account의 ID로 enrich하려면, `ContactChangeEvent`의 enriched field 이름으로 `Account` relationship 필드를 선택한다(`Account.Name`이 아님). 커스텀 relationship 필드는 `__c` suffix를 붙여 지정한다(예: `RelField__c`).

**📏 한도:**
- **채널 member당 최대 10개**의 enriched field를 추가할 수 있다. Compound field는 1개로 카운트한다.
- 이 allocation은 **per channel member**다. 예: 채널에 channel member가 2개면, 채널 전체는 최대 **20개** 필드로 enrich될 수 있다(각 member당 10개).

enrich 필드는 Tooling API 또는 Metadata API의 `PlatformEventChannelMember` 객체로 선택한다.

### A-3. Example: Add Event Enrichment Fields with Tooling API

enrichment 필드를 추가하려면 `PlatformEventChannelMember` Tooling API 객체를 사용해 필드·채널·채널 member를 지정한다.

> Note: Trailhead에서 유사 단계를 수행하고 badge를 얻으려면 "Create a Custom Channel and Enrich Change Events"를 참고한다.

enrich하려는 channel member가 커스텀 채널의 일부라면, 먼저 커스텀 채널을 생성한다(이 예제처럼). `ChangeEvents` 표준 채널을 쓰거나 커스텀 채널을 앞서 만들었다면 이 단계는 건너뛴다.

이 REST endpoint로 POST 요청을 보낸다:

```
/services/data/v66.0/tooling/sobjects/PlatformEventChannel
```

커스텀 채널의 request body:

```json
{
"FullName": "SalesEvents__chn",
"Metadata": {
"channelType": "data",
"label": "Custom Channel for Sales App"
}
}
```

enrichment 필드를 추가하려면 Tooling API로 `PlatformEventChannelMember` 컴포넌트를 생성하는 REST 요청을 수행한다. 이 예제에서 컴포넌트는 `SalesEvents` 커스텀 채널의 `AccountChangeEvent`에 대해 `enrichedFields` array에 세 개의 enriched field를 포함한다. 이 channel member를 만들기 전에, Account에 label이 `External Account ID`인 커스텀 `Text(20)` 필드를 먼저 만든다.

이 REST endpoint로 POST 요청을 보낸다 (enrichment 필드는 **API version 51.0 이상** 지원):

```
/services/data/v66.0/tooling/sobjects/PlatformEventChannelMember
```

channel member에 enrichment 필드를 추가한 request body:

```json
{
"FullName": "SalesEvents_AccountChangeEvent",
"Metadata": {
"enrichedFields": [
{
"name": "External_Account_ID__c"
},
{
"name": "Industry"
},
{
"name": "BillingAddress"
}
],
"eventChannel": "SalesEvents__chn",
"selectedEntity": "AccountChangeEvent"
}
}
```

#### Query Enriched Fields

어떤 channel member와 필드를 구성했는지 확인하려면 Tooling API의 `EnrichedField` 객체를 쿼리한다. 예를 들어 이 쿼리는 선택된 enriched field와 channel member ID를 반환한다.

```sql
SELECT ChannelMemberId,Field FROM EnrichedField ORDER BY ChannelMemberId
```

Developer Console의 Query Editor에서 **Use Tooling API**를 체크해 쿼리할 수 있다. 또는 REST API로 실행한다. 아래 URI로 GET 요청을 수행한다(공백을 `+`로 치환):

```
/services/data/v66.0/tooling/query/?q=SELECT+ChannelMemberId,Field+FROM+EnrichedField+ORDER+BY+ChannelMemberId
```

이 쿼리 결과에서 반환된 행들은 같은 channel member에 대한 것으로, `Industry`, `External_Account_ID__c` 커스텀 필드(값이 ID), `BillingAddress` enriched field를 담는다.

| ChannelMemberId | Field |
|---|---|
| 0v8RM00000000JsYAI | Industry |
| 0v8RM00000000JsYAI | 00NRM000001gEx32AE  *(= `External_Account_ID__c` 필드의 ID 값)* |
| 0v8RM00000000JsYAI | BillingAddress |

#### Update a Channel Member with Enriched Fields

같은 selected entity와 채널에 대한 channel member가 이미 있으면, POST 요청으로 중복 channel member를 만들 수 없다. 대신 **PATCH 요청**으로 channel member를 업데이트한다. 또는 channel member를 삭제하고 enriched field와 함께 재생성한다.

channel member 업데이트 절차:

1. 커스텀 채널을 쓴다면, 이 쿼리로 channel ID를 얻는다:

```sql
SELECT Id FROM PlatformEventChannel WHERE DeveloperName=Channel_Name
```

`DeveloperName`은 커스텀 채널명의 `__chn` suffix를 포함하지 않는다. 예를 들어 `SalesEvents__chn` 채널의 경우:

```sql
SELECT Id FROM PlatformEventChannel WHERE DeveloperName='SalesEvents'
```

2. 이 Tooling API 쿼리로 channel member ID를 얻는다. 커스텀 채널은 `Channel_ID`를 이전 단계에서 얻은 ID로, 표준 `ChangeEvents` 채널은 `Channel_ID`를 `ChangeEvents`로 치환한다. `EntityChangeEvent`는 selected entity 이름으로 치환한다.

```sql
SELECT Id,DeveloperName,EventChannel,SelectedEntity FROM PlatformEventChannelMember
WHERE EventChannel='Channel_ID' AND SelectedEntity='EntityChangeEvent'
```

예를 들어 커스텀 채널 ID `0YLRM00000000434AA`의 `AccountChangeEvent`:

```sql
SELECT Id,DeveloperName,EventChannel,SelectedEntity FROM PlatformEventChannelMember
WHERE EventChannel='0YLRM00000000434AA' AND SelectedEntity='AccountChangeEvent'
```

또는 표준 `ChangeEvents` 채널의 경우:

```sql
SELECT Id,DeveloperName,EventChannel,SelectedEntity FROM PlatformEventChannelMember
WHERE EventChannel='ChangeEvents' AND SelectedEntity='AccountChangeEvent'
```

3. 이 URI에 이전 단계에서 얻은 channel member ID를 append해 PATCH 요청을 보낸다.

```
/services/data/v66.0/tooling/sobjects/PlatformEventChannelMember/Channel_Member_ID
```

request body에 channel member의 JSON 정의를 포함한다. 예를 들어 channel member ID `0v8RM00000000JsYAI`의 `AccountChangeEvent`를 업데이트해 enriched field를 `Phone` 필드 하나로만 설정하려면, 이 URI로 PATCH 요청:

```
/services/data/v66.0/tooling/sobjects/PlatformEventChannelMember/0v8RM00000000JsYAI
```

이 request body로:

```json
{
"FullName": "SalesEvents_chn_AccountChangeEvent",
"Metadata": {
"enrichedFields": [
{
"name": "Phone"
}
],
"eventChannel": "SalesEvents__chn",
"selectedEntity": "AccountChangeEvent"
}
}
```

channel member가 이전에 enriched field로 구성돼 있었다면, 업데이트는 그것들을 clear하고 request body에 지정된 필드로 교체한다. 이 예제는 enriched field 하나(`Phone`)만 지정한다. channel member에 enriched field가 없었다면, 업데이트는 지정된 enriched field를 추가한다.

**PATCH 요청에는 `PlatformEventChannelMember`의 전체 정의를 포함해야 한다.** enriched field만 담은 partial 정의는 지원되지 않는다.

### A-4. Example: Add Event Enrichment Fields with Metadata API

enrichment 필드를 추가하려면 `PlatformEventChannelMember` metadata type을 사용해 필드·채널·채널 member를 지정한다.

enrich하려는 channel member가 커스텀 채널의 일부라면 먼저 커스텀 채널을 생성한다(이 예제처럼). `ChangeEvents` 표준 채널을 쓰거나 커스텀 채널을 앞서 만들었다면 이 단계는 건너뛴다.

커스텀 채널용 샘플 metadata 컴포넌트:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<PlatformEventChannel xmlns="http://soap.sforce.com/2006/04/metadata">
<channelType>data</channelType>
<label>Custom Channel for Sales Events</label>
</PlatformEventChannel>
```

이 `package.xml`은 앞의 정의를 참조한다. 커스텀 채널명은 `SalesEvents__chn`이다.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
<types>
<members>SalesEvents__chn</members>
<name>PlatformEventChannel</name>
</types>
<version>66.0</version>
</Package>
```

enrichment 필드를 추가하려면 enriched field를 담은 `PlatformEventChannelMember` 컴포넌트를 배포한다. 이 예제에서 컴포넌트는 `SalesEvents` 커스텀 채널의 `AccountChangeEvent`에 대해 세 개의 enriched field를 담는다. 이 channel member를 만들기 전에, Account에 label이 `External Account ID`인 커스텀 `Text(20)` 필드를 먼저 만든다.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<PlatformEventChannelMember xmlns="http://soap.sforce.com/2006/04/metadata">
<enrichedFields>
<name>External_Account_ID__c</name>
</enrichedFields>
<enrichedFields>
<name>Industry</name>
</enrichedFields>
<enrichedFields>
<name>BillingAddress</name>
</enrichedFields>
<eventChannel>SalesEvents__chn</eventChannel>
<selectedEntity>AccountChangeEvent</selectedEntity>
</PlatformEventChannelMember>
```

이 `package.xml` manifest 파일로 channel member 정의를 배포/조회한다. enriched field는 **API version 51.0 이상만** 지원한다.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
<types>
<members>SalesEvents_AccountChangeEvent</members>
<name>PlatformEventChannelMember</name>
</types>
<version>66.0</version>
</Package>
```

> Note: member가 이미 채널의 일부라면, 업데이트된 정의로 `PlatformEventChannelMember` 컴포넌트를 재배포해 enriched field를 업데이트할 수 있다.

### A-5. Example: Delivered Enriched Event Messages

update·delete operation에 대해 enriched field를 담은 event message 예시.

이 account update change event는 다음 enriched field를 포함한다: `External_Account_ID__c` 커스텀 필드, `BillingAddress`, `Industry`. `changedFields` 필드는 어떤 필드가 변경됐는지 나타낸다. 이 예제에서는 `Fax` 필드와 시스템 필드 `LastModifiedDate`만 변경됐지만, `External_Account_ID__c`·`BillingAddress`·`Industry`의 필드 값도 enriched field이므로 포함된다.

```json
{
"ChangeEventHeader": {
"entityName": "Account",
"recordIds": [
"001ZM000001QkdOYAS"
],
"changeType": "UPDATE",
"changeOrigin": "com/salesforce/api/soap/61.0;client=SfdcInternalAPI/",
"transactionKey": "00097360-44a0-7c2e-a172-97381ae22f82",
"sequenceNumber": 1,
"commitTimestamp": 1714172795000,
"commitNumber": 72657170033,
"commitUser": "005ZM000000M6o1YAC",
"nulledFields": [],
"diffFields": [],
"changedFields": [
"0x400080"
]
},
"Name": null,
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
"Fax": "4155551212",
"AccountNumber": null,
"Website": null,
"Sic": null,
"Industry": "Biotechnology",
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
"LastModifiedDate": 1714172795000,
"LastModifiedById": null,
"Jigsaw": null,
"JigsawCompanyId": null,
"AccountSource": null,
"SicDesc": null,
"External_Account_ID__c": "1ABC"
}
```

Pub/Sub API client에서 decode한 후 `changedFields` 필드는 변경된 필드를 나열하며 `Fax` 필드를 포함한다.

```
2024-04-26 16:15:52,375 [grpc-default-executor-0] java.lang.Class ============================
2024-04-26 16:15:52,375 [grpc-default-executor-0] java.lang.Class -

Changed Fields

2024-04-26 16:15:52,375 [grpc-default-executor-0] java.lang.Class ============================
2024-04-26 16:15:52,375 [grpc-default-executor-0] java.lang.Class - Fax
2024-04-26 16:15:52,375 [grpc-default-executor-0] java.lang.Class - LastModifiedDate
2024-04-26 16:15:52,375 [grpc-default-executor-0] java.lang.Class ============================
```

delete operation에 대한 change event message는 enriched field `External_Account_ID__c`, `BillingAddress`, `Industry`를 포함한다.

```json
{
"ChangeEventHeader": {
"entityName": "Account",
"recordIds": [
"001ZM000001QkdOYAS"
],
"changeType": "DELETE",
"changeOrigin": "com/salesforce/api/soap/61.0;client=SfdcInternalAPI/",
"transactionKey": "00097379-d9df-704f-ed2f-c1d2ca3ac266",
"sequenceNumber": 1,
"commitTimestamp": 1714172911000,
"commitNumber": 72657195312,
"commitUser": "005ZM000000M6o1YAC",
"nulledFields": [],
"diffFields": [],
"changedFields": []
},
"Name": null,
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
"Industry": "Biotechnology",
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
"External_Account_ID__c": "1ABC"
}
```

### A-6. Event Enrichment Considerations (5개 전수)

1. **No Apex Trigger Support** — Event enrichment는 Apex change event trigger에서 사용할 수 없다.

2. **Latest Enriched Field Value Returned When Replaying an Event Message** — Change event message는 event bus에 임시로 저장된다. **enriched field는 event bus에 event message와 함께 저장되지 않는다.** replay 옵션으로 event bus에서 event를 검색하면, enriched field는 **DB에서 검색**되어 전달 전에 event message에 추가된다. 따라서 event가 저장된 후 enriched field가 업데이트되면, replay된 event message는 원본이 아니라 **최신 값**을 담는다. 유일한 예외는 enriched field가 그 event의 changed field에 포함된 경우로, 이때는 올바른 changed 값을 반영한다.

3. **Duplicate Replay ID for Ungrouped Enriched Event Messages** — Salesforce는 한 트랜잭션에서 같은 변경이 한 객체의 여러 레코드에 발생하면 event message를 **grouping**하기도 한다(ChangeEventHeader Fields의 `recordIds` 참조). 그러나 change event message가 enrich되면, external ID 필드 값이 레코드마다 다를 수 있으므로 **single event message로 전송**된다. 이 event message들은 먼저 grouping됐다가 ungrouping되므로, **중복 `ReplayId` 값**과 `recordIds` 필드에 record ID 하나만 담는다. 그래도 Streaming API(CometD) 또는 Pub/Sub API의 `ReplayId` 옵션으로 replay할 수 있다. 또한 change event message가 전달 전에 optimistic grouping되지 않으므로 **event allocation usage가 더 높아질 수 있다.**

4. **CampaignMember Change Event** — CampaignMember가 campaign에서 삭제되면, hard deletion(레코드가 DB에 더 이상 존재하지 않음)이므로 change event message에 enriched field가 포함되지 않는다. 시스템이 그 레코드의 enriched field 값을 쿼리할 수 없다. 그러나 CampaignMember가 campaign의 cascade delete의 일부로 삭제되면, 이 삭제는 soft deletion이고 레코드가 Recycle Bin에 있다. 시스템이 soft-deleted 레코드를 쿼리해 enriched field를 얻을 수 있다.

5. **Gap and Overflow Events** — gap 또는 overflow event에는 enriched field가 지원되지 않는다.

---

## 섹션 B — Filter Your Stream of Change Events with Channels

### B-1. 개요

채널의 미리 정의된 filter에 매칭되는 change event message만 subscriber에서 받는다. 더 적은 event가 전달되므로 event 처리가 최적화되고, subscriber가 event delivery allocation을 더 효율적으로 사용한다. 이 기능은 **Pub/Sub API, CometD (Streaming API), event relays**를 지원하며 **Apex trigger는 미지원**이다.

> Note: Government Cloud를 사용하고 org가 **2022년 1월 14일 이전**에 생성됐다면, 이 기능을 활성화하려면 Salesforce에 문의해야 한다. **2022년 1월 14일 이후** 생성된 Government Cloud org는 이 기능이 활성화돼 있다. 이 기능은 다른 모든 cloud에서 사용 가능하다.

### B-2. Change Event Filters

channel member에 filter expression을 추가해 change event stream을 필터링한다. filter expression은 Salesforce entity 필드와, `ChangeEventHeader`의 일부인 event header 필드를 담을 수 있다. 한 change data capture 채널은 하나 이상의 channel member를 가질 수 있고, 각 channel member는 자체 filter를 가질 수 있다.

subscriber가 filter expression의 필드에 view access가 없어도 filter는 평가된다 (Field Considerations의 field-level security 참조).

**Auto-Enrichment of Filtered Fields:** filter expression에 참조된 각 Salesforce entity 필드는 **자동으로 enrich**된다 — 즉 change event message가 **항상 그 filtered 필드를 포함**한다. enrichment가 없으면 change event는 레코드의 new·changed 필드만 담는다. filter와 auto-enrichment가 있으면, filter expression에 참조된 필드가 change event message에 포함된다(단 empty가 아니고 subscriber가 view access를 가진 경우). event enrichment 상세는 섹션 A 참조.

**Change Event Header Fields:** filter expression에 `ChangeEventHeader` 필드를 추가할 수 있으나, **array인 필드는 제외**한다. header 필드 목록은 [[Change Data Capture — 이벤트 메시지·Gap·Overflow]] 참조.

**❌ 미지원 array 필드 (전수):**

| # | 미지원 array 필드 |
|---|---|
| 1 | `recordIds` |
| 2 | `nulledfields` |
| 3 | `diffFields` |
| 4 | `changedFields` |

`ChangeEventHeader` 필드는 change type이나 변경을 수행한 사용자 ID 같은 변경 정보를 담는다. 예를 들어 `ChangeEventHeader.changeType` 필드를 filter expression에 써서 레코드 update에 대한 event만 받을 수 있다.

### B-3. Filter Expression Format

filter expression 포맷은 SOQL을 기반으로 하며 SOQL operator·field type의 subset을 지원한다. filter expression은 하나 이상의 field expression을 logical operator로 join해 담을 수 있다.

Single-field expression:

```
<FieldName> <Comparison Operator> <Value>
```

logical operator로 join된 multiple-field expression 예시:

```
<FieldName> <Comparison Operator> <Value> AND (<FieldName> <Comparison Operator> <Value>
OR <FieldName> <Comparison Operator> <Value>) ...
```

Text 필드 값은 single quote 안에 넣는다. Text 필드 필터링 single-field expression 예시:

```
Industry = 'Agriculture'
Industry LIKE 'A%'
```

Date 필드 필터링 single-field expression 예시:

```
LastViewedDate > 2021-11-03T09:30:11-08:00
```

Time 필드 필터링 single-field expression 예시 (UTC time zone designator `Z` 필수):

```
OpenTime__c >= 14:30:00Z
```

`ChangeEventHeader` 필드 필터링 single-field expression 예시:

```
ChangeEventHeader.changeType = 'UPDATE'
```

multiple-field expression 예시:

```
Industry = 'Agriculture' AND NumberOfEmployees > 1000
```

괄호와 `AND`·`OR` logical operator를 쓴 multiple-field expression 예시:

```
NumberOfEmployees > 1000 AND (Industry = 'Agriculture' OR Industry = 'Banking')
```

#### Supported Field Types (21종 전수)

enriched field로 지원되는 모든 필드 타입이 filter expression에서 지원된다.

| # | 지원 필드 타입 |
|---|---|
| 1 | Address |
| 2 | Auto Number |
| 3 | Checkbox |
| 4 | Currency |
| 5 | Date, Date/Time, Time |
| 6 | Email |
| 7 | External Lookup Relationship |
| 8 | Geolocation |
| 9 | Hierarchical Relationship on User |
| 10 | Lookup Relationship |
| 11 | Master-Detail Relationship |
| 12 | Name |
| 13 | Number |
| 14 | Percent |
| 15 | Phone (and Fax) |
| 16 | Picklist |
| 17 | **Picklist (Multi-select)** |
| 18 | Roll-Up Summary |
| 19 | Text |
| 20 | TextArea |
| 21 | URL |

> ⚠️ **enriched vs filter 지원 필드 타입 차이:** filter 목록은 enriched 목록(20종)에 **`Picklist (Multi-select)`** 가 추가돼 **21종**이다. 나머지는 동일하다.

> Note (원문):
> - **TextArea는 plain TextArea 타입만 지원.** `TextArea (Long)`, `TextArea (Rich)`, `TextArea (Encrypted)`는 미지원.
> - **Picklist (Multi-select)** 필드는 선택된 picklist 값들이 delimited string으로 있다. 지원되는 comparison operator를 아무거나 쓸 수 있으나, **`INCLUDES`와 `EXCLUDES`는 지원되지 않으므로** 쓸 수 없다.
> - **Formula fields는 filter expression에서 미지원** — change event 자체가 formula 필드를 지원하지 않기 때문.

#### Compound fields in filter (표)

표준·커스텀 compound field는 filter expression에서 **component field를 지정할 때** 지원되며, **compound field 자체는 지정할 수 없다.** 이 표는 compound field와, filter expression에서 쓸 수 있는 component field 예시를 담는다.

> ⚠️ **enriched와 정반대:** filter에서는 **component field를 지정**한다(compound field 자체 불가). enriched에서는 **전체 compound field만** 지정한다(개별 component 불가).

| Compound field | filter expression에서 쓸 수 있는 component field 예시 |
|---|---|
| **Name** | contact, lead, person account의 `FirstName`·`LastName` 같은 Name component field:<br>`Name.FirstName = 'John'`<br>`Name.LastName = 'Smith'`<br>Salesforce에서 person account를 활성화했지만 business account를 참조하거나 person account를 활성화하지 않았다면, account `Name` 필드를 text 값으로 지정:<br>`Name = 'John Smith'` |
| **Address** | `BillingAddress.City = 'San Francisco'`<br>상세는 Object Reference for Salesforce and Lightning Platform의 Address Compound Fields 참조. |
| **Geolocation** | `My_Location__c.Latitude > 40`<br>상세는 Object Reference for Salesforce and Lightning Platform의 Geolocation Compound Field 참조. |

#### Supported Comparison Operators (7개 전수)

filter expression에서 지원되는 comparison operator:

| # | operator |
|---|---|
| 1 | `=` |
| 2 | `!=` |
| 3 | `>` |
| 4 | `<` |
| 5 | `>=` |
| 6 | `<=` |
| 7 | `LIKE` |

**Considerations for the LIKE Operator:** `LIKE` operator는 **Text 필드**에서 지원된다. text string 값은 single quote로 감싼다. `LIKE`는 `%`와 `_` wildcard로 부분 text string 값을 매칭할 수 있다. **`%` wildcard는 0개 이상의 문자**를, **`_` wildcard는 정확히 1개의 문자**를 매칭한다.

예를 들어 이 expression은 `Industry` 값이 'A'로 시작하는 message(예: 'Agriculture', 'Apparel')를 매칭한다. 그러나 'Education'처럼 'A'로 시작하지 않는 `Industry` 값은 매칭하지 않는다.

```
Industry LIKE 'A%'
```

이 expression은 'Agricultur'로 시작하고 임의의 단일 문자로 끝나는 `Industry` 값의 message를 매칭한다. 예를 들어 'Agriculture'가 매칭이다.

```
Industry LIKE 'Agricultur_'
```

#### Supported Logical Operators (3개 전수)

filter expression에서 지원되는 logical operator:

| # | operator |
|---|---|
| 1 | `AND` |
| 2 | `OR` |
| 3 | `NOT` |

**Considerations for the NOT Operator:** `NOT` operator로 expression을 negate한다. 예를 들어 이 expression은 industry가 Banking이 아니라고 명시한다.

```
NOT Industry = 'Banking'
```

다음 expression에서 `NOT`은 `AND`로 평가된 두 조건을 negate한다. 이 filter는 industry가 Banking 이외의 값이거나 `NumberOfEmployees`가 1,000 이하인 event를 매칭한다. event가 industry가 Banking이면서 `NumberOfEmployees`가 1,000 초과이면 filter 기준에 매칭되지 않아 전달되지 않는다.

```
NOT(Industry = 'Banking' AND NumberOfEmployees>1000)
```

`NOT` operator를 포함해 expression이 하나 이상이면, `NOT`과 그 expression을 감싸는 괄호가 **필수**다. 이 예제에서는 두 field expression이 `AND`로 join되고, `NOT`은 첫 번째 expression에만 쓰였다. expression이 둘이므로 괄호로 감싸야 한다. 전체 expression은 industry가 Banking이 아니고 `NumberOfEmployees`가 1,000 초과라고 명시한다.

```
(NOT(Industry = 'Banking')) AND (NumberOfEmployees>1000)
```

이 예제도 `NOT` operator를 괄호로 감싸야 한다. 이 filter expression은 Pacific time zone에서 last viewed date가 `2021-10-21T09:30:11`보다 크고, industry가 Banking이 아니거나 `NumberOfEmployees`가 1,000 이하인 event를 매칭한다.

```
LastViewedDate>2021-10-21T09:30:11-08:00 AND (NOT(Industry = 'Banking' AND
NumberOfEmployees>1000))
```

**미지원 연산자:** `INCLUDES`, `EXCLUDES` (Picklist Multi-select 필드에서도 지원되지 않음).

#### Filter Expression Allocations (numeric limits 전수)

- filter expression에 **최대 10개의 필드**를 추가할 수 있다.
- filter expression의 **최대 길이는 131,072 characters**다.
- 각 channel member는 filter expression을 **1개** 담을 수 있다.

> 📏 **Number 필드 한도:** filter expression에 값이 **2147483647 초과**인 Number 필드가 있으면, 그 filter expression을 담은 channel member를 저장하려 할 때 "A number format error occurred"로 시작하는 메시지와 함께 **`FIELD_INTEGRITY_EXCEPTION`** 이 발생한다. 이는 SOQL 제한 때문이다. 저장하려면 값에 **`.0`을 append**해 decimal 값으로 만든다. 예: `"filterExpression" : "MyNumberField__c = 1657093404000.0"`. (Number Field Considerations 참조)

### B-4. Field Considerations (전수)

filter expression의 필드에 대한 고려사항.

**Text Field Considerations**
- Text 필드 값을 single quote로 감싼다. 예: `MyTextField__c='Hello'`는 유효, `MyTextField__c=Hello`는 무효.
- Text 값은 **case-insensitive** — 단, Unique 필드 속성으로 case-sensitive로 표시된 커스텀 필드는 제외. 예를 들어 case-sensitive가 아닌 필드는 `MyTextField__c='ABC'`와 `MyTextField__c='abc'`가 같은 것으로 취급된다. 필드 값의 대문자·소문자 조합이 어떻든 filter에 매칭돼 전달된다.
- 관리자가 커스텀 Text 필드의 case sensitivity를 변경하면, active subscription의 filter에는 subscription을 stop/restart할 때까지 변경이 반영되지 않는다.
- Text 값은 단어 사이에 space·tab을 담을 수 있다. leading/trailing space·tab은 수신 event message에서 stripped되므로 **filter string에 넣지 않는다.** 넣으면 filter 비교가 실패한다.
- Text 필드는 모든 comparison operator를 지원한다. Text 필드를 `<`, `<=`, `>`, `>=`로 비교하는 것은 SOQL과 유사하게 **lexicographic**하다.
- Text 필드 값에 double quote(`"`) 같은 특수문자가 있으면 escape할 수 있으나 일부 예외가 있다. **backslash · underscore · percent 문자(즉 `\ _ %`)는 escape할 수 없다.** (SOQL and SOSL Reference의 Quoted String Escape Sequences 참조)

**Checkbox Field Considerations**
- Checkbox 필드는 **`=`와 `!=` comparison operator만** 지원한다. 다른 operator를 쓰면 에러가 난다.
- Checkbox 필드를 null과 비교하는 것은 `false` 값과 비교하는 것과 동일하다.

**Date and Time Field Considerations**
- Date/Time 필드는 `+` 또는 `-`로 시작하는 time zone offset을 포함하는 포맷 `YYYY-MM-DDThh:mm:ss+hh:mm`과 `YYYY-MM-DDThh:mm:ss-hh:mm`, 그리고 UTC time zone designator `Z`를 포함하는 포맷 `YYYY-MM-DDThh:mm:ssZ`를 지원한다.
- Time 필드 값은 `hh:mm:ssZ` 포맷에 UTC time zone designator `Z`를 포함해야 한다. Time 필드 값은 UTC로 저장·검색된다.
- Date·Date/Time 필드는 `2021-07-09`나 `2021-07-09T10:30:11-08:00` 같은 **hardcoded date 값에만** 비교할 수 있다. `TOMORROW` 같은 date literal에는 비교할 수 없다. (SOQL and SOSL Reference의 Date Formats and Date Literals 참조)

**Number Field Considerations**
- filter expression에 값이 **2147483647 초과**인 Number 필드가 있으면, filter expression을 담은 channel member를 저장하려 할 때 "A number format error occurred"로 시작하는 메시지와 함께 **`FIELD_INTEGRITY_EXCEPTION`** 이 발생한다. SOQL 제한 때문이다. 저장하려면 값에 **`.0`을 append**해 decimal 값으로 만든다. 예: `"filterExpression" : "MyNumberField__c = 1657093404000.0"`.

**Null Field Considerations**
- 필드를 null과 비교할 때는 **`=`와 `!=` operator만** 지원된다.

**Relationship Field Considerations**
- filter expression은 `LastModifiedById` 같은 change event에 포함된 relationship 필드를 담을 수 있다. `LastModifiedBy.Name` 같은 **traverse된 relationship 필드는 지원되지 않는다** — 그 필드들이 change event에 포함되지 않기 때문. 예를 들어 filter expression은 field expression `LastModifiedById='005RM000001dTr0YAE'`는 담을 수 있으나 `LastModifiedBy.Name='Joe Smith'`는 담을 수 없다.

**General Field Considerations**
- **필드 삭제** — filter expression에 참조된 필드는 삭제할 수 없다. 삭제하면 에러가 난다.
- **커스텀 객체 삭제** — filter expression이 커스텀 객체의 필드를 참조하면 그 커스텀 객체를 삭제할 수 없다.
- **필드 rename** — filter expression에 참조된 필드를 rename해도 filter는 계속 올바르게 적용된다. 시스템이 old 필드명을 renamed 필드에 매핑한다. filter expression의 필드명을 업데이트할 필요가 없다. field label을 rename해도 field name은 변하지 않고 filtering은 계속 올바르게 동작한다.
  - Note: filter expression이 Winter '23 이전에 생성됐다면, renamed 필드는 filter expression을 업데이트하고 channel member를 다시 저장한 후에만 동작한다.
- **Namespace prefix** — org에 namespace가 생기기 전에 생성된 filter expression이 field name에 namespace prefix를 담지 않았다면, filter expression이 namespace prefix로 자동 업데이트되고 계속 동작한다.
- **필드 타입 변경** — filter expression에 참조된 필드의 타입은 변경할 수 없다. 변경하면 에러가 난다.
- **filter expression의 field name case** — filter expression에 쓰인 field name은 case-insensitive다. filter expression과 change event schema의 field name case가 다를 수 있다.
- **Null enriched fields** — filter expression의 필드는 enriched field이기도 하다. enriched field가 null이면 change event message에서 제외된다. filter expression에서 그 필드는 null로 평가된다.
- **Field-level security** — filter expression이 평가될 때 **field-level security는 무시된다.** filter expression은 subscriber가 필드에 접근 권한이 없어도 포함된 모든 필드에서 평가된다. filtered stream으로 전달된 event는 subscriber가 접근 권한을 가진 필드만 포함하고, 접근 권한이 없는 필드는 제외한다.

### B-5. Event Delivery Usage for Filtered Streams

event delivery allocation은 filtering **후에** 전달된 event 수에 적용되며 filtering **전**이 아니다. filter가 subscriber에 전달되는 event 수를 줄일 수 있으므로, filter를 쓰면 subscriber의 event delivery allocation 사용량을 낮추는 데 도움이 된다.

예를 들어 client가 account change event를 받으려고 채널을 구독하고, event bus에 전달할 그런 event가 100개 있다. 그러나 `AccountChangeEvent`의 channel member에 `Industry` 필드가 `Agriculture`로 설정된 account만 매칭하는 filter가 있다. 100개 account change event 중 15개가 이 필드 값에 매칭돼 전달된다. 이 경우 event delivery usage는 **100이 아니라 15 events**다. event delivery allocation 상세는 [[Change Data Capture — 고려사항·할당량·표준객체]] 참조.

### B-6. Filter Expressions in Channel Members

커스텀 채널 또는 표준 `ChangeEvents` 채널과 연결된 channel member에 filter expression을 추가한다. **커스텀 채널 사용을 권장**한다 — filtered stream이 표준 event stream에서 격리되고 subscriber가 stream이 필터링됐다고 기대하기 때문. 채널은 지정된 change event에 대해 filter expression에 매칭되는 filtered event stream을 담는다.

- Tooling API / Metadata API 모두 **API version 56.0 이상**을 사용해 채널과 channel member를 생성한다.

### B-7. Add a Filter with Tooling API

**API version 56.0 이상**을 사용해 Tooling API에서 채널과 channel member를 생성한다. 선호하는 REST API 도구를 쓸 수 있다(Salesforce Platform APIs collection이 있는 Postman 권장). 단계는 커스텀 채널 기반이다. 표준 채널을 대신 쓸 수도 있는데, 그러면 step 1·2를 건너뛰고 step 4에서 `FullName` 필드를 조정하고 `"eventChannel": "ChangeEvents"` 값을 쓴다.

> **USER PERMISSIONS**
> - `PlatformEventChannel` 및 `PlatformEventChannelMember` 객체 생성·업데이트: **Customize Application**
> - REST API 사용: **API Enabled**

1. 채널을 생성하려면 이 URI로 POST 요청을 보낸다.

```
/services/data/v66.0/tooling/sobjects/PlatformEventChannel
```

Postman을 쓴다면 Event Platform > Custom Channels > Platform Event를 펼치고 **Create channel**을 클릭한다.

2. 이 예제 request body를 쓴다. change event용 채널이므로 `channelType`은 `data`다.

```json
{
"FullName": "FilteredChannel__chn",
"Metadata": {
"channelType": "data",
"label": "My Custom Filtered Channel"
}
}
```

이 예제 응답과 유사한 응답을 받는다.

```json
{
"id" : "0YLRM000000004m4AA",
"success" : true,
"errors" : [ ],
"warnings" : [ ],
"infos" : [ ]
}
```

3. `Industry` 필드를 enriched field로, change event type을 `AccountChangeEvent`로, filter expression을 지정하는 channel member를 추가한다.

```
/services/data/v66.0/tooling/sobjects/PlatformEventChannelMember
```

Postman을 쓴다면 Event Platform > Custom Channels > Platform Event를 펼치고 **Create channel member**를 클릭한다.

4. 이 예제 request body를 쓴다.

```json
{
"FullName": "FilteredChannel_chn_AccountChangeEvent",
"Metadata": {
"eventChannel": "FilteredChannel__chn",
"filterExpression": "Industry='Agriculture' AND NumberOfEmployees>1000",
"selectedEntity": "AccountChangeEvent"
}
}
```

이 예제 응답과 유사한 응답을 받는다.

```json
{
"id" : "0v8RM0000004VAKYA2",
"success" : true,
"errors" : [ ],
"warnings" : [ ],
"infos" : [ ]
}
```

filter expression을 업데이트하려면 `/services/data/v66.0/tooling/sobjects/PlatformEventChannelMember/<ChannelMemberID>`로 PATCH 요청을 수행하고, 새 filter expression을 담은 전체 request body를 전달한다. channel member는 **filter expression과 enriched field만** 업데이트할 수 있다. 다른 필드는 업데이트할 수 없다.

Salesforce org에 namespace가 있으면, `PlatformEventChannelMember` request body의 `filterExpression`에 쓰인 각 필드와 `selectedEntity` 값에 namespace prefix를 붙인다. 예를 들어 namespace가 `ns`면 이 예제의 request body는 다음이 된다:

```json
{
"FullName": "FilteredChannel_chn_AccountChangeEvent",
"Metadata": {
"eventChannel": "FilteredChannel__chn",
"filterExpression": "ns__Industry='Agriculture' AND ns__NumberOfEmployees>1000",
"selectedEntity": "AccountChangeEvent"
}
}
```

다른 change event에 대한 filter를 같은 채널에 추가하려면 또 다른 channel member를 추가한다. 예를 들어 lead change event를 필터링하려면 `FilteredChannel__chn` 채널에 두 번째 channel member를 추가한다. 이 member에서 `selectedEntity`를 `LeadChangeEvent`로 지정하고 filter expression을 지정한다. 예:

```json
{
"FullName": "FilteredChannel_chn_LeadChangeEvent",
"Metadata": {
"eventChannel": "FilteredChannel__chn",
"filterExpression": "AnnualRevenue>1000000",
"selectedEntity": "LeadChangeEvent"
}
}
```

### B-8. Add a Filter with Metadata API

app을 개발·테스트·배포·릴리스하는 application lifecycle management 프로세스의 일부로 Metadata API 사용을 권장한다. 채널과 filter expression을 만들려면 REST와 함께 Tooling API를 쓰는 것이 권장된다. **API version 56.0 이상**을 사용해 Metadata API에서 채널과 channel member를 생성한다. Salesforce Extension pack이 있는 Visual Studio Code나 Salesforce CLI 같은 도구를 쓸 수 있다. 단계는 커스텀 채널 기반이다. 표준 `ChangeEvents` 채널을 대신 쓸 수도 있는데, 그러면 커스텀 채널 정의를 건너뛰고 `PlatformEventChannelMember` 정의에서 파일명을 조정하고 `<eventChannel>ChangeEvents</eventChannel>` 값을 쓴다.

> **USER PERMISSIONS**
> - metadata type 배포·조회: **Customize Application**
> - metadata type 업데이트: **Modify Metadata Through Metadata API Functions**
> - Metadata API 사용: **API Enabled**

이 샘플 커스텀 채널 정의는 `FilteredChannel__chn` 채널용이다. 파일명은 `FilteredChannel__chn.platformEventChannel`이다.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<PlatformEventChannel xmlns="http://soap.sforce.com/2006/04/metadata">
<channelType>data</channelType>
<label>My Custom Filtered Channel</label>
</PlatformEventChannel>
```

다음으로 channel member를 추가한다. 이 channel member는 enriched field `Industry`와 `NumberOfEmployees`, filter expression, selected entity `AccountChangeEvent`를 지정한다. 파일명은 `FilteredChannel_chn_AccountChangeEvent.platformEventChannelMember`이다.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<PlatformEventChannelMember xmlns="http://soap.sforce.com/2006/04/metadata">
<eventChannel>FilteredChannel__chn</eventChannel>
<filterExpression><![CDATA[Industry='Agriculture' AND
NumberOfEmployees>1000]]></filterExpression>
<selectedEntity>AccountChangeEvent</selectedEntity>
</PlatformEventChannelMember>
```

> Note: filter expression에 `<`와 `&` 특수문자가 있으면 XML 데이터에서 literal 형태로 허용되지 않는다. 이 문자들을 `&lt;`와 `&amp;`로 escape하거나, 전체 filter expression 값을 `<![CDATA[...]]>` 섹션으로 감싼다. 앞 예제에 특수문자가 없지만 편의상 `<![CDATA[...]]>`를 포함했다. (XML 명세의 CData sections 참조)

Salesforce org에 namespace가 있으면, `PlatformEventChannelMember` request body의 `filterExpression`에 쓰인 각 필드와 `selectedEntity` 값에 namespace prefix를 붙인다. 예를 들어 namespace가 `ns`면 이 예제의 request body는 다음이 된다:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<PlatformEventChannelMember xmlns="http://soap.sforce.com/2006/04/metadata">
<eventChannel>FilteredChannel__chn</eventChannel>
<filterExpression><![CDATA[ns__Industry='Agriculture' AND
ns__NumberOfEmployees>1000]]></filterExpression>
<selectedEntity>AccountChangeEvent</selectedEntity>
</PlatformEventChannelMember>
```

이 `package.xml` 파일은 채널과 channel member를 참조한다.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
<types>
<members>FilteredChannel__chn</members>
<name>PlatformEventChannel</name>
</types>
<types>
<members>FilteredChannel_chn_AccountChangeEvent</members>
<name>PlatformEventChannelMember</name>
</types>
<version>66.0</version>
</Package>
```

filter expression을 업데이트하려면 `PlatformEventChannelMember` 컴포넌트의 `filterExpression` 필드 값을 업데이트해 package를 재배포한다. channel member는 **filter expression과 enriched field만** 업데이트할 수 있다. 다른 필드는 업데이트할 수 없다.

다른 change event에 대한 filter를 같은 채널에 추가하려면 channel member를 추가한다. 예를 들어 lead change event를 필터링하려면 `FilteredChannel__chn` 채널에 두 번째 channel member를 추가한다. 이 member에서 `selectedEntity`를 `LeadChangeEvent`로 지정하고 filter expression과 enriched field를 지정한다. 이 `PlatformEventChannelMember` 정의는 파일명이 `FilteredChannel_chn_LeadChangeEvent.platformEventChannelMember`인 예제 컴포넌트다.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<PlatformEventChannelMember xmlns="http://soap.sforce.com/2006/04/metadata">
<eventChannel>FilteredChannel__chn</eventChannel>
<filterExpression><![CDATA[AnnualRevenue>1000000]]></filterExpression>
<selectedEntity>LeadChangeEvent</selectedEntity>
</PlatformEventChannelMember>
```

이 `package.xml` 파일은 두 channel member를 모두 참조한다.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
<types>
<members>FilteredChannel__chn</members>
<name>PlatformEventChannel</name>
</types>
<types>
<members>FilteredChannel_chn_AccountChangeEvent</members>
<members>FilteredChannel_chn_LeadChangeEvent</members>
<name>PlatformEventChannelMember</name>
</types>
<version>66.0</version>
</Package>
```

### B-9. Subscribe to the Channel and Receive the Filtered Event Stream

filter를 구성한 후 채널을 구독해 filter expression에 매칭되는 event message를 받는다. 구독할 채널은 `/data/ChannelName__chn`이다. **Pub/Sub API와 CometD client만** stream filtering을 지원한다. Apex trigger는 채널을 지원하지 않으므로 filtered event stream 구독에 쓸 수 없다.

> Note: 채널을 구독하기 전에 앞 섹션의 단계를 따라 `FilteredChannel__chn` 채널을 만들고, Tooling API 또는 Metadata API로 `AccountChangeEvent`의 filter expression을 구성한다.

이 예제는 Pub/Sub API Java client를 쓴다. `arguments.yaml`의 Step 3: Configure Client Parameters에서 값을 공급한다:

- `TOPIC: /data/FilteredChannel__chn`
- `PROCESS_CHANGE_EVENT_HEADER_FIELDS: true` — 이 값은 `ChangeEventHeader`의 `changedFields` 같은 bitmap 필드가 확장되도록 보장한다.

Terminal에서 top-level `java` 폴더로 이동해 Subscribe RPC 예제를 실행한다: `./run.sh genericpubsub.Subscribe`. 그런 다음 account 몇 개를 만들고 하나를 업데이트한다:

- Acme North — Industry: `Agriculture`, NumberOfEmployees: `1500`
- Acme South — Industry: `Agriculture`, NumberOfEmployees: `20`
- Acme West — NumberOfEmployees: `1100` (Industry 없음)
- Acme North 업데이트 — Type: `Prospect`

앞 섹션에서 설정한 filter expression:

```
Industry='Agriculture' AND NumberOfEmployees>1000
```

생성된 account에 대응해 Salesforce가 발행한 change event message 중, filter 기준에 매칭되는 것은 **Acme North의 첫 event뿐**이다. 이 첫 event message가 client에 전달된다. 또한 Acme North account 업데이트에 대응하는 마지막 change event도, account가 계속 기준에 매칭되므로 전달된다. `Type` 필드만 업데이트됐어도 change event는 `NumberOfEmployees`와 `Industry` 필드를 포함하는데, **auto-enrich되기 때문**이다. 두 번째·세 번째 event는 기준에 매칭되지 않아 전달되지 않는다 — 두 번째는 `NumberOfEmployees`가 1,000 미만이고, 세 번째는 `Industry`가 blank(null)이다.

`/data/FilteredChannel__chn` 채널 구독 후 수신한 CREATE event message (Acme North):

```json
{
"ChangeEventHeader": {
"entityName": "Account",
"recordIds": [
"001ZM000002JNaXYAW"
],
"changeType": "CREATE",
"changeOrigin": "com/salesforce/api/soap/61.0;client=SfdcInternalAPI/",
"transactionKey": "00007816-6798-4836-5275-80afa466c4d4",
"sequenceNumber": 1,
"commitTimestamp": 1722531023000,
"commitNumber": 77390604774,
"commitUser": "005ZM000000M6o1YAC",
"nulledFields": [],
"diffFields": [],
"changedFields": []
},
"Name": "Acme North",
"Type": null,
"ParentId": null,
"BillingAddress": null,
"ShippingAddress": null,
"Phone": null,
"Fax": null,
"AccountNumber": null,
"Website": null,
"Sic": null,
"Industry": "Agriculture",
"AnnualRevenue": null,
"NumberOfEmployees": 1500,
"Ownership": null,
"TickerSymbol": null,
"Description": null,
"Rating": null,
"Site": null,
"OwnerId": "005ZM000000M6o1YAC",
"CreatedDate": 1722531023000,
"CreatedById": "005ZM000000M6o1YAC",
"LastModifiedDate": 1722531023000,
"LastModifiedById": "005ZM000000M6o1YAC",
"Jigsaw": null,
"JigsawCompanyId": null,
"AccountSource": null,
"SicDesc": null,
"External_Account_ID__c": null
}
with schema name: AccountChangeEvent
```

수신한 UPDATE event message (Acme North, Type=Prospect):

```json
{
"ChangeEventHeader": {
"entityName": "Account",
"recordIds": [
"001ZM000002JNaXYAW"
],
"changeType": "UPDATE",
"changeOrigin": "com/salesforce/api/soap/61.0;client=SfdcInternalAPI/",
"transactionKey": "000077fe-1655-b8fc-44ab-27df66fccbf6",
"sequenceNumber": 1,
"commitTimestamp": 1722531115000,
"commitNumber": 77390686560,
"commitUser": "005ZM000000M6o1YAC",
"nulledFields": [],
"diffFields": [],
"changedFields": [
"0x400004"
]
},
"Name": null,
"Type": "Prospect",
"ParentId": null,
"BillingAddress": null,
"ShippingAddress": null,
"Phone": null,
"Fax": null,
"AccountNumber": null,
"Website": null,
"Sic": null,
"Industry": "Agriculture",
"AnnualRevenue": null,
"NumberOfEmployees": 1500,
"Ownership": null,
"TickerSymbol": null,
"Description": null,
"Rating": null,
"Site": null,
"OwnerId": null,
"CreatedDate": null,
"CreatedById": null,
"LastModifiedDate": 1722531115000,
"LastModifiedById": null,
"Jigsaw": null,
"JigsawCompanyId": null,
"AccountSource": null,
"SicDesc": null,
"External_Account_ID__c": null
}
with schema name: AccountChangeEvent
```

Decoded `changedFields` 로그 (UPDATE):

```
2024-08-01 09:52:08,030 [grpc-default-executor-1] java.lang.Class ============================
2024-08-01 09:52:08,030 [grpc-default-executor-1] java.lang.Class -

ChangedFields

2024-08-01 09:52:08,030 [grpc-default-executor-1] java.lang.Class ============================
2024-08-01 09:52:08,030 [grpc-default-executor-1] java.lang.Class - Type
2024-08-01 09:52:08,030 [grpc-default-executor-1] java.lang.Class - LastModifiedDate
2024-08-01 09:52:08,030 [grpc-default-executor-1] java.lang.Class ============================
```

> Pub/Sub API Java client 구축·구독 절차 상세는 [[Pub-Sub API (gRPC) — Platform Event·CDC 구독]] 참조.

### B-10. Get Custom Channels and Channel Members

Salesforce org에 어떤 채널·channel member가 설정돼 있는지 Tooling API의 SOQL 쿼리로 찾을 수 있다.

> **USER PERMISSIONS**
> - `PlatformEventChannel` 및 `PlatformEventChannelMember` Tooling 객체 쿼리: **View Setup and Configuration**
> - Tooling API로 REST 사용: **API Enabled**

SOQL 쿼리를 수행하려면 REST query 호출을 하거나 Developer Console의 Query Editor에서 Tooling API 옵션을 선택한다. SOQL 쿼리를 append해 이 endpoint로 GET 요청을 수행한다.

```
/services/data/v66.0/tooling/query?q=<query>
```

이 쿼리는 모든 커스텀 채널을 반환한다.

```sql
SELECT Id, DeveloperName, ChannelType, MasterLabel FROM PlatformEventChannel
```

Postman을 쓴다면 Event Platform > Custom Channels를 펼치고 **List event channels**를 클릭한다.

Sample result:

| Id | DeveloperName | ChannelType | MasterLabel |
|---|---|---|---|
| 0YLRM000000004m4AA | FilteredChannel | data | My Custom Filtered Channel |

그리고 이 쿼리는 모든 channel member를 반환한다.

```sql
SELECT Id, DeveloperName,EventChannel,FilterExpression, SelectedEntity FROM
PlatformEventChannelMember
```

Postman을 쓴다면 Event Platform > Custom Channels를 펼치고 **List channel members**를 클릭한다.

Sample result (`SelectedEntity` 필드는 커스텀 platform event의 ID를 참조):

| Id | DeveloperName | EventChannel | FilterExpression | SelectedEntity |
|---|---|---|---|---|
| 0v8RM0000004VAKYA2 | FilteredChannel_chn_AccountChangeEvent | 0YLRM000000004m4AA | Industry='Agriculture' AND NumberOfEmployees>1000 | AccountChangeEvent |

---

## 버전 게이트 요약 표

| 기능 | 필요 API version | API |
|---|---|---|
| Event Enrichment (enriched fields) | **v51.0 이상** | Tooling API / Metadata API (`PlatformEventChannelMember.enrichedFields`) |
| Filter Expression 추가 | **v56.0 이상** | Tooling API (POST/PATCH `PlatformEventChannelMember`) |
| Filter Expression 배포 | **v56.0 이상** | Metadata API (`PlatformEventChannelMember.filterExpression`) |
| Filter Expressions in Channel Members | **v56.0 이상** | Tooling / Metadata API |

> Government Cloud org 게이트: 2022-01-14 **이전** 생성 org는 filtering 기능을 쓰려면 Salesforce에 문의(활성화 요청). **이후** 생성 org·그 외 모든 cloud는 활성화됨.

---

## 관련 노트
- [[Change Data Capture — 커스텀 채널]]
- [[Change Data Capture — 개요·채널 구독]]
- [[Change Data Capture — 고려사항·할당량·표준객체]]
- [[Change Data Capture — 이벤트 메시지·Gap·Overflow]]
- [[Pub-Sub API (gRPC) — Platform Event·CDC 구독]]
