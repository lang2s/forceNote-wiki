---
tags: [field-service, fsl, sobject, object-reference, asset, warranty, attribute, 현장서비스, 자산, 보증, 속성, asset-relationship, downtime, picklist]
source: field_service_dev.pdf (Field Service Developer Guide v67.0 Summer '26)
created: 2026-06-23
aliases: [Asset, AssetAccountParticipant, AssetAttribute, AssetContactParticipant, AssetDowntimePeriod, AssetRelationship, AssetWarranty, AttributeDefinition, AttributePicklist, AttributePicklistValue, WarrantyTerm, ProductWarrantyTerm, 자산, 보증, 자산 속성, 보증 조건, Asset 필드, AssetWarranty 필드, WarrantyTerm 필드, 자산 다운타임]
---

# Field Service 객체 레퍼런스 — Asset·Attribute·Warranty 클러스터

> Field Service Developer Guide v67.0 Summer '26 Object References 챕터의 자산(Asset)·자산 속성(Attribute)·보증(Warranty) 관련 12개 표준 객체를 필드 전수로 정리한다.

이 클러스터는 자산 자체(`Asset`)와 자산에 매달리는 참가자·속성·다운타임·관계, 그리고 자산/제품에 적용되는 보증 조건 객체들로 구성된다. 모든 필드 표기·오타(`AveragetimetoRepair`, `AveragetimeBetweenFailure` 등)는 PDF 원문 그대로 [sic] 보존한다.

> 데이터 모델 전체 그림(Warranty Management / Core Data Model ER)과 클러스터 위치는 [[Field Service 개요와 데이터 모델]] 참조. 다른 FSL 표준 객체(ServiceAppointment·WorkOrder 등) 색인은 [[Field Service Objects]] 참조.

아래 SOQL은 위 클러스터의 객체 간 관계(Asset → AssetWarranty → WarrantyTerm, Asset → AssetAttribute → AttributeDefinition)를 보여주는 예시다.

```sql
// 구조 예시 — 실제 동작 코드 아님 (필드명은 본 PDF 소스의 실제 API 이름)
SELECT Id, Name, SerialNumber, Status, AssetLevel,
       (SELECT AssetWarrantyNumber, WarrantyType, StartDate, EndDate,
               PartsCovered, LaborCovered, ExpensesCovered,
               WarrantyTermId, WarrantyTerm.WarrantyTermName
        FROM AssetWarranties),
       (SELECT AttributeName, AttributeValue,
               AttributeDefinition.Label, AttributeDefinition.DataType
        FROM AssetAttributes)
FROM Asset
WHERE Product2Id != null AND Status = 'Installed'
```

---

## Asset

상업적 가치가 있는 품목 — 회사 또는 경쟁사가 판매하는 제품으로 고객이 구매한 것 — 을 나타낸다.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

### Fields

| Field | Type | Properties | Description |
|---|---|---|---|
| AccountId | reference | Create, Filter, Group, Nillable, Sort, Update | (Required) ID of the Account associated with this asset. Must be a valid account ID. Required if ContactId isn't specified. Relationship field. **Relationship Name:** Account · **Type:** Lookup · **Refers To:** Account |
| Address | address | Filter, Nillable | Represents the physical address or geolocation of the asset. |
| AssetLevel | int | Filter, Group, Nillable, Sort | The asset's position in an asset hierarchy. If the asset has no parent or child assets, its level is 1. Assets that belong to a hierarchy have a level of 1 for the root asset, 2 for the child assets of the root asset, 3 for their children, and so forth. On assets created before the introduction of this field, the asset level defaults to –1. After the asset record is updated, the asset level is calculated and automatically updated. |
| AssetProvidedById | reference | Create, Filter, Group, Nillable, Sort, Update | The account that provided the asset, typically a manufacturer. Relationship field. **Relationship Name:** AssetProvidedBy · **Type:** Lookup · **Refers To:** Account |
| AssetServicedById | reference | Create, Filter, Group, Nillable, Sort, Update | The account in charge of servicing the asset. Relationship field. **Relationship Name:** AssetServicedBy · **Type:** Lookup · **Refers To:** Account |
| AssetTypeId | reference | Create, Filter, Group, Nillable, Sort, Update | The asset type associated with the asset. Relationship field. Available in API version 62.0 and later for users with the Health Cloud Appointment Management permission set. **Relationship Name:** AssetType · **Type:** Lookup · **Refers To:** AssetType |
| Availability | percent | Filter, Nillable, Sort | The percentage of expected uptime where the asset was available for use. |
| AveragetimetoRepair [sic] | double | Create, Filter, Nillable, Sort, Update | Represents the number of hours it typically takes to repair an asset after a failure. |
| AveragetimeBetweenFailure [sic] | double | Create, Filter, Nillable, Sort, Update | Represents the number of hours that typically elapses before the asset is likely to fail again. |
| AverageUptimePerDay | double | Create, Filter, Nillable, Sort, Update | The average number of hours per day the asset is expected to be available for use. |
| City | string | Create, Filter, Group, Nillable, Sort, Update | The city detail for the address. |
| ConsequenceOfFailure | picklist | Create, Filter, Group, Nillable, Sort, Update | The business impact associated with the asset's failure. Using this field, you can address the asset's health and take action using Flows. To enable this field, use Object Manager to update the field availability. Make sure that the field is visible for field-level security and for page layout. To learn more, see What Determines Field Access. The picklist values aren't predefined in orgs created before Winter '22 that aren't Field Service enabled. Available in API version 53.0 and later. **Possible values:** Insignificant · Minor · Moderate · Major · Critical |
| ContactId | reference | Create, Filter, Group, Nillable, Sort, Update | Required if AccountId isn't specified. ID of the Contact associated with this asset. Must be a valid contact ID that has an account parent (but doesn't need to match the asset's AccountId). Relationship field. **Relationship Name:** Contact · **Type:** Lookup · **Refers To:** Contact |
| Country | String | Create, Filter, Group, Nillable, Sort, Update | The country detail for the address. |
| CurrencyIsoCode | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Three-letter ISO 4217 currency code associated with the invoice. The default value is USD. Available in API version 55.0 and later. Available when CPQ Plus, Salesforce Billing, or Revenue Cloud is enabled. |
| CurrentAmount | currency | Filter, Nillable, Sort | Reserved for future use. Available in API version 50.0 and later. Available when CPQ Plus, Salesforce Billing, or Revenue Cloud is enabled. |
| CurrentLifecycleEndDate | dateTime | Filter, Nillable, Sort | Represents the end of the period shown as current. System-populated field inherited from the end date of the current asset state period. If that field is empty, as with an evergreen subscription, the Current Lifecycle End Date field is also empty. Available in API version 50.0 and later. Available when CPQ Plus, Salesforce Billing, or Revenue Cloud is enabled. |
| CurrentMrr | currency | Filter, Nillable, Sort | The asset's monthly recurring revenue during the current asset state period. System-populated field inherited from the monthly recurring revenue on the current asset state period. If no asset state period is current, the value is 0. Label is Current Monthly Recurring Revenue. Available in API version 50.0 and later. Available when CPQ Plus, Salesforce Billing, or Revenue Cloud is enabled. |
| CurrentQuantity | double | Filter, Nillable, Sort | The asset's quantity during the current asset state period. System-populated field inherited from the quantity on the current asset state period. If no asset state period is current, the value is 0. Available in API version 50.0 and later. Available when CPQ Plus, Salesforce Billing, or Revenue Cloud is enabled. |
| Description | textarea | Create, Nillable, Update | Description of the asset. |
| DigitalAssetStatus | picklist | Create, Filter, Group, Nillable, Sort, Update | Status of digital tracking of the asset. The default picklist includes the following values: On · Off · Warning · Error |
| ExternalIdentifier | string | Create, Filter, Group, Nillable, Sort, Update | The ID of the matching record in an external system. Available in API version 49.0 and later. |
| GeocodeAccuracy | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Accuracy level of the geocode for the address. |
| HasLifecycleManagement | boolean | Defaulted on create, Filter, Group, Sort | True if this asset is a lifecycle-managed asset, otherwise false. You can't switch an asset to a lifecycle-managed asset or the reverse. This field is system populated. The default value is false. Available in API version 50.0 and later. Available when CPQ Plus, Salesforce Billing, or Revenue Cloud is enabled. |
| InstallDate | date | Create, Filter, Group, Nillable, Sort, Update | Date when the asset was installed. |
| IsCompetitorProduct | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether this Asset represents a product sold by a competitor (true) or not (false). The default value is false. Its UI label is Competitor Asset. |
| IsInternal | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates that the asset is produced or used internally (true) or not (false). The default value is false. Its UI label is Internal Asset. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The date and time that the asset was last modified. Its UI label is Last Modified Date. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The date and time that the asset was last viewed. |
| Latitude | double | Create, Filter, Group, Nillable, Sort, Update | Used with Longitude to specify the precise geolocation of the address. |
| LifecycleEndDate | dateTime | Filter, Nillable, Sort | Represents the end of the asset's lifecycle. System-populated field inherited from the end date of the final asset state period. If that field is empty, as with an evergreen subscription, the lifecycle has no end date. Available in API version 50.0 and later. Available when CPQ Plus, Salesforce Billing, or Revenue Cloud is enabled. |
| LifecycleStartDate | dateTime | Filter, Nillable, Sort | Represents the beginning of the asset's lifecycle. System-populated field inherited from the start date of the earliest asset state period. This field can't be edited. When a new asset action affects the start date of an asset state period, the period is deleted and a new one is generated. Available in API version 50.0 and later. Available when CPQ Plus, Salesforce Billing, or Revenue Cloud is enabled. |
| LocationId | reference | Create, Filter, Group, Nillable, Sort, Update | The asset's location. Typically, this location is the place where the asset is stored, such as a warehouse or van. If you have access to the location entity, it doesn't necessarily mean you can access the location id field. To access the location, you must have userHasLocation user access. |
| Longitude | double | Create, Filter, Group, Nillable, Sort, Update | Used with Latitude to specify the precise geolocation of the address. |
| ManufactureDate | date | Create, Filter, Group, Nillable, Sort, Update | The date when the asset was manufactured. Available from API version 49.0 and later. |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | (Required) Name of the asset. Label is Asset Name. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | The asset's owner. By default, the asset owner is the user who created the asset record. Its UI label is Asset Owner. Relationship field. **Relationship Name:** Owner · **Type:** Lookup · **Refers To:** User |
| ParentId | reference | Create, Filter, Group, Nillable, Sort, Update | The asset's parent asset. Its UI label is Parent Asset. Relationship field. **Relationship Name:** Parent · **Type:** Lookup · **Refers To:** Asset |
| PostalCode | string | Create, Filter, Group, Nillable, Sort, Update | The postal code for the address. |
| Price | currency | Create, Filter, Nillable, Sort, Update | Price paid for this asset. |
| PricingSource | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Pricing source to use when amending or renewing an asset. **Valid values:** LastTransaction—Last Transaction · PriceBookListPrice—Price Book or List Price. Available in API version 60.0 and later. |
| Product2Id | reference | Create, Filter, Group, Nillable, Sort, Update | (Optional) ID of the Product2 associated with this asset. Must be a valid Product2 ID. Its UI label is Product. Relationship field. **Relationship Name:** Product2 · **Type:** Lookup · **Refers To:** Product2 |
| ProductCode | string | Filter, Group, Nillable, Sort | The product code of the related product. |
| ProductDescription | string | Filter, Sort, Nillable | The product description of the related product. |
| ProductFamily | picklist | Filter, Group, Sort, Nillable | The product family of the related product. |
| PurchaseDate | date | Create, Filter, Group, Nillable, Sort, Update | Date on which this asset was purchased. |
| Quantity | double | Create, Filter, Nillable, Sort, Update | Quantity purchased or installed. The Quantity field value isn't set by Customer Asset Lifecycle Management. Instead, you can populate the field as you need. |
| QuantityIncreasePricingType | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Specify which pricing type to use when the quantity of this asset is increased. Its UI label is Pricing Type for Quantity Increase. Available in API version 56.0 and later. Available when Revenue Cloud is enabled. **Possible values:** LastNegotiatedPrice—Available in API version 58.0 and later. · ListPrice |
| RecordTypeId | reference | Create, Filter, Group, Sort, Update | The unique identifier for the asset. Relationship field. **Relationship Name:** RecordType · **Type:** Lookup · **Refers To:** RecordType |
| Reliability | percent | Filter, Nillable, Sort | The percentage of expected uptime where the asset wasn't subject to unplanned downtime. |
| RenewalPricingType | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The price used when renewing a subscription. Its UI label is Pricing Type for Renewal. Available in API version 55.0 and later. Available when Revenue Cloud is enabled. **Possible values:** LastNegotiatedPrice · ListPrice |
| RenewalTerm | double | Create, Filter, Nillable, Sort, Update | With Renewal Term Unit, defines the default subscription term for renewal quotes. Available in API version 55.0 and later. Available when Revenue Cloud is enabled. |
| RenewalTermUnit | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The unit of time for a subscription term. Available in API version 55.0 and later. Available when Revenue Cloud is enabled. **Possible values:** Annual—Available in API version 58.0 and later. —UI label is Years. · Months |
| SalesStoreId | reference | Create, Filter, Group, Nillable, Sort, Update | ID of the RetailStore or WebStore associated with this Asset. This field is a polymorphic relationship field. To access this field, your org must have a Salesforce Order Management license or a B2B Commerce License. Available in API v60.0 and later. **Relationship Name:** SalesStore · **Type:** Lookup · **Refers To:** RetailStore, WebStore |
| SerialNumber | string | Create, Filter, Group, Nillable, Sort, Update | Serial number for this asset. |
| State | string | Create, Filter, Group, Nillable, Sort, Update | The state detail for the address. |
| Status | picklist | Create, Filter, Group, Nillable, Sort, Update | Customizable picklist of values. The default picklist includes the following values: Purchased · Shipped · Installed · Registered · Obsolete |
| StatusReason | picklist | Create, Filter, Group, Nillable, Sort, Update | The explanation of the device status. Available from API version 49.0 and later. **Possible values:** Not Ready · Off · Offline · Online · Paused · Standby |
| StockKeepingUnit | string | Filter, Group, Nillable, Sort | The SKU assigned to the related product. |
| Street | textarea | Create, Filter, Group, Nillable, Sort, Update | The street detail for the address. |
| SumDowntime | double | Filter, Nillable, Sort | Accumulated downtime (planned and unplanned), determined as follows: When only UptimeRecordStart is set, the sum of all downtime from UptimeRecordStart · When UptimeRecordStart and UptimeRecordEnd are set, the sum of all downtime from UptimeRecordStart to UptimeRecordEnd. Otherwise, downtime isn't accumulated. |
| SumUnplannedDowntime | double | Filter, Nillable, Sort | Accumulated unplanned downtime, determined as follows: When only UptimeRecordStart is set, the sum of all unplanned downtime from UptimeRecordStart · When UptimeRecordStart and UptimeRecordEnd are set, the sum of all unplanned downtime from UptimeRecordStart to UptimeRecordEnd. Otherwise, unplanned downtime isn't accumulated. |
| TotalLifecycleAmount | currency | Filter, Nillable, Sort | The total amount of revenue for the asset, including revenue from each stage in the asset lifecycle. Available when CPQ Plus, Salesforce Billing, or Revenue Cloud is enabled. |
| UptimeRecordEnd | dateTime | Create, Filter, Nillable, Sort, Update | The date until which SumDowntime and SumUnplannedDowntime are accumulated. |
| UptimeRecordStart | dateTime | Create, Filter, Nillable, Sort, Update | The date from which SumDowntime and SumUnplannedDowntime are accumulated. |
| UsageEndDate | date | Create, Filter, Group, Nillable, Sort, Update | Date when usage for this asset ends or expires. |
| Uuid | string | Create, Filter, Group, Nillable, Sort, Update | The unique ID for the asset. Available in API version 49.0 and later. |

### Usage

이 객체로 고객에게 판매된 제품을 추적한다. asset 추적을 사용하면 클라이언트 애플리케이션이 특정 account에서 이전에 판매되었거나 현재 설치된 제품을 빠르게 판단할 수 있다. 최대 10,000개 asset의 계층(hierarchy)도 생성 가능하다.

예를 들어 회사가 과거에 판매한 제품의 갱신·업셀 기회를 노린다고 하자. 마찬가지로, 제품이 교체·교환될 수 있는 고객 환경에서 경쟁 제품을 추적할 수도 있다. asset 추적은 제품 지원에도 유용하다 — `PurchaseDate`나 `SerialNumber`로 특정 제품에 제품 리콜을 포함한 유지보수 요구사항이 있는지 판단할 수 있고, `UsageEndDate`로 asset이 서비스에서 제거된 시점이나 라이선스/보증 만료 시점을 알 수 있다. 애플리케이션이 Asset 레코드를 생성하면 `Name`과 함께 `AccountId`·`ContactId` 중 하나(또는 둘 다)를 반드시 지정해야 한다.

REST API에서는 `getRelatedListInfo` 함수로 asset의 관련 목록(related list) 정보를 얻는다. 단, `PrimaryAssets`에 대한 정보를 요청하면 응답이 `Related Assets`로 레이블링되고, `RelatedAssets`에 대한 응답은 `Primary Assets`로 레이블링된다.

### Associated Objects

- **AssetChangeEvent** (API version 44.0) — Change events available
- **AssetFeed** — Feed tracking available
- **AssetHistory** — History available for tracked fields
- **AssetOwnerSharingRule** — Sharing rules available
- **AssetShare** — Sharing available

---

## AssetAccountParticipant

Asset와 Account 객체 사이의 junction으로, 참여 account와 asset 간 연관을 기술한다. API version 56.0 이상에서 사용 가능.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

### Fields

| Field | Type | Properties | Description |
|---|---|---|---|
| AccountId | reference | Create, Filter, Group, Sort, Update | The stakeholder account associated with the asset. Relationship field. **Relationship Name:** Account · **Type:** Lookup · **Refers To:** Account |
| AssetId | reference | Create, Filter, Group, Sort | The asset associated with the account. Relationship field. **Relationship Name:** Asset · **Type:** Lookup · **Refers To:** Asset |
| EffectiveEndDate | date | Create, Filter, Group, Nillable, Sort, Update | The date when the association between the stakeholder and the vehicle ended. |
| EffectiveStartDate | date | Create, Filter, Group, Sort, Update | The date when the association between the stakeholder and the vehicle was initiated. |
| IsActive | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether the association between the stakeholder and the vehicle is active (true) or not (false). The default value is false. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The most recent date on which a user referenced this record. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The most recent date on which a user viewed this record. |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | The name of the asset account participant. |
| RecordTypeId | reference | Create, Filter, Group, Nillable, Sort, Update | The record type associated with the asset account participant. Relationship field. **Relationship Name:** RecordType · **Type:** Lookup · **Refers To:** RecordType |
| StakeholderRole | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | Specifies the role of the associated account. **Possible values:** Customer-Preferred Dealer · Nominated Dealer · Closest Dealer · Sales Dealer · Service Dealer · Customer · Driver · Financier · Owner |
| UsageType | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | Specifies the usage type of the asset account participant. **Possible values:** Automotive · FieldServiceLightning—Field Service Lightning |
| VehicleId | reference | Create, Filter, Group, Nillable, Sort, Update | The vehicle that's marked as an asset. Relationship field. **Relationship Name:** Vehicle · **Type:** Lookup · **Refers To:** Vehicle |

### Associated Objects

- **AssetAccountParticipantChangeEvent** — Change events available
- **AssetAccountParticipantFeed** — Feed tracking available
- **AssetAccountParticipantHistory** — History available for tracked fields

---

## AssetAttribute

asset 속성을 저장해 asset 상태(condition)를 추적·분석하여 uptime을 개선한다. API version 57.0 이상에서 사용 가능.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `query()`, `update()`

**Special Access Rules:** Field Service must be enabled.

### Fields

| Field | Type | Properties | Description |
|---|---|---|---|
| AssetId | reference | Create, Filter, Group, Sort | The ID of the asset. Relationship field. **Relationship Name:** Asset · **Type:** Lookup · **Refers To:** Asset |
| AttributeDefinitionId | reference | Create, Filter, Group, Sort, Update | The ID of the attribute definition for this asset attribute. Relationship field. **Relationship Name:** AttributeDefinition · **Type:** Lookup · **Refers To:** AttributeDefinition |
| AttributeName | string | Filter, Group, Sort | The name given to the asset attribute in the UI by the user. |
| AttributePicklistValueId | reference | Create, Filter, Group, Nillable, Sort, Update | The ID of the attribute picklist value if the attribute is a picklist type. Relationship field. **Relationship Name:** AttributePicklistValue · **Type:** Lookup · **Refers To:** AttributePicklistValue |
| AttributeValue | string | Create, Filter, Group, Nillable, Sort, Update | Stores the value of an asset attribute, for example 5-TB storage. |
| ExternalId | string | Create, Filter, Group, Nillable, Sort, Update | An auto-generated ID of the attribute record saved in an external system (for example an HBase database). This field is reserved and used for internal purpose. |

### Usage

여러 개의 커스텀 속성을 asset에 만드는 대신 AssetAttribute 객체에 asset descriptor를 추가한다. 이렇게 하면 시스템에서 대량 asset으로 확장(scale)하는 데 도움이 된다.

---

## AssetContactParticipant

Asset와 Contact 객체 사이의 junction으로, 참여 contact와 asset 간 연관을 기술한다. API version 56.0 이상에서 사용 가능.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

### Fields

| Field | Type | Properties | Description |
|---|---|---|---|
| AssetId | reference | Create, Filter, Group, Sort | The asset associated with the contact. Relationship field. **Relationship Name:** Asset · **Type:** Lookup · **Refers To:** Asset |
| ContactId | reference | Create, Filter, Group, Sort, Update | The contact associated with the asset. Relationship field. **Relationship Name:** Contact · **Type:** Lookup · **Refers To:** Contact |
| EffectiveEndDate | date | Create, Filter, Group, Nillable, Sort, Update | The date when the association between the stakeholder and the vehicle ended. |
| EffectiveStartDate | date | Create, Filter, Group, Sort, Update | The date when the association between the stakeholder and the vehicle was initiated. |
| IsActive | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether the association between the stakeholder and the vehicle is active (true) or not (false). The default value is false. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The most recent date on which a user referenced this record. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The most recent date on which a user viewed this record. |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | The name of the asset contact participant. |
| StakeholderRole | picklist | Create, Filter, Group, Sort, Update | Specifies the role of the associated contact. |
| UsageType | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | Specifies the usage type of the asset contact participant. **Possible values:** Automotive · FieldServiceLightning—Field Service Lightning |
| VehicleId | reference | Create, Filter, Group, Nillable, Sort, Update | The vehicle that's marked as an asset. Relationship field. **Relationship Name:** Vehicle · **Type:** Lookup · **Refers To:** Vehicle |

### Associated Objects

- **AssetContactParticipantChangeEvent** — Change events available
- **AssetContactParticipantFeed** — Feed tracking available
- **AssetContactParticipantHistory** — History available for tracked fields

---

## AssetDowntimePeriod

asset이 기대대로 동작할 수 없는 기간을 나타낸다. downtime 기간은 유지보수 같은 계획된 활동(planned)과 기계 고장 같은 비계획 이벤트(unplanned)를 포함한다. API version 49.0 이상에서 사용 가능.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

### Fields

| Field | Type | Properties | Description |
|---|---|---|---|
| AssetDowntimePeriodNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | The unique number of this asset downtime period record. |
| AssetId | reference | Create, Filter, Group, Sort | The ID of the asset this asset downtime period record is for. |
| Description | textarea | Create, Nillable, Update | The description of this asset downtime period. |
| DowntimeType | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The type of this asset downtime period. **Possible values:** Planned · Unplanned |
| EndTime | dateTime | Create, Filter, Sort, Update | The time this asset downtime period ended. |
| IsExcluded | boolean | Defaulted on create, Filter, Group, Sort | Whether this asset downtime period is excluded from the calculation of accumulated downtime and accumulated unplanned downtime, and therefore not included in availability and reliability calculations. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The timestamp for when the current user last viewed a record related to this record. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The timestamp for when the current user last viewed this record. If this value is null, this record might only have been referenced (LastReferencedDate) and not viewed. |
| StartTime | dateTime | Create, Filter, Sort, Update | The time this asset downtime period started. |

---

## AssetRelationship

asset 수정(예: 교체, 업그레이드 등)으로 인한 asset 간 비계층(non-hierarchical) 관계를 나타낸다. Revenue Lifecycle Management에서는 이 객체가 번들/세트로 묶인 asset(들)을 나타낸다. API version 41.0 이상에서 사용 가능. asset 관계는 UI의 asset 레코드에서 Primary Assets·Related Assets 관련 목록에 나타난다.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

**Special Access Rules:** 일부 필드는 Revenue Cloud에서만 사용 가능. 필드 가용성은 필드 상세에 표기됨.

### Fields

표의 첫 열 헤더는 PDF 원문에서 다른 객체와 달리 `Field Name`이다 [sic].

| Field Name | Type | Properties | Description |
|---|---|---|---|
| AssetId | reference | Create, Filter, Group, Sort | The unique identifier of the new asset, which is the asset that is taking the place of the existing asset. Relationship field. **Relationship Name:** Asset · **Type:** Lookup · **Refers To:** Asset |
| AssetRelationshipNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | An auto-generated number identifying the asset relationship. |
| AssetRole | picklist | Filter, Group, Nillable, Restricted picklist, Sort | Describes the position of the main asset relative to the other assets in the relationship. Available in API version 58.0 and later. Available in orgs with Revenue Cloud. **Possible values:** Add-on—The main asset is an add-on. · Bundle—The main asset is the bundle parent. · Set—The asset is the main asset in the set. |
| CurrencyIsoCode | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Three-letter ISO 4217 currency code associated with the asset. The default value is USD. |
| FromDate | dateTime | Create, Filter, Nillable, Sort, Update | The date when the new asset was installed. |
| GroupingKey | string | Filter, Group, idLookup, Nillable, Sort | Read-only field used to indicate the bundle that an asset belongs to. For example, if two assets have the same GroupingKey value, then it means that the assets are bundled together. Available in API v.60.0 and later. Available in orgs with Revenue Cloud. |
| ProductRelationshipTypeId | reference | Filter, Group, Nillable, Sort | The unique identifier of the record that describes the relationship between the main and associated assets. Available in API version 58.0 and later. Available in orgs with Revenue Cloud. Relationship field. **Relationship Name:** ProductRelationshipType · **Type:** Lookup · **Refers To:** ProductRelationshipType |
| ProductRelatedComponent | reference | Filter, Group, Nillable, Sort | The product related component that's associated with the asset relationship. Relationship field. Available in API 60.0 and later in Revenue Cloud. **Relationship Name:** ProductRelatedComponent · **Type:** Lookup · **Refers To:** ProductRelatedComponent |
| RelatedAssetId | reference | Create, Filter, Group, Sort, Update | The existing asset that is being modified. Relationship field. **Relationship Name:** RelatedAsset · **Type:** Lookup · **Refers To:** Asset |
| RelatedAssetPricing | picklist | Filter, Group, Nillable, Restricted picklist, Sort | Specifies whether the price of the related asset is included in the bundle price. **Valid values:** IncludedInBundlePrice · NotIncludedInBundlePrice. Available in API version 59.0 and later in Revenue Cloud. |
| RelatedAssetQtyScaleMethod | picklist | Filter, Group, Nillable, Restricted picklist, Sort | Specifies how the quantity of the related asset changes relative to the quantity of the parent asset. **Valid values:** Constant · Proportional. Available in API version 59.0 and later in Revenue Cloud. |
| RelatedAssetRole | picklist | Filter, Group, Nillable, Restricted picklist, Sort | Describes the position of the associated asset relative to other assets in the relationship. Available in API version 58.0 and later. Available in orgs with Revenue Cloud. **Valid values:** Add-on—The main asset is an add-on. · Bundle—The main asset is the bundle parent. · Set—The asset is the main asset in the set. · Simple—The asset is purchased individually and isn't associated with variations. · Variation Parent——The main asset is the variation parent. [sic — 이중 em dash 원문 보존] |
| RelationshipType | picklist | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | The type of relationship between the existing asset and the new asset. This field comes with three values—Replacement, Upgrade, and Crossgrade—, but you can create more values in Setup. **Possible values:** Crossgrade—The new asset is a crossgrade of an existing asset. For example, changing a subscription to a plan with the same service, but that runs for a longer amount of time. · Replacement—The new asset is replacing an existing asset. For example, a customer's faulty widget that was under warranty is being replaced with a new one. · Upgrade—The new asset is an upgrade of an existing asset. For example, upgrading a customer's existing subscription plan to a new plan with more services. The default value is Replacement. |
| ToDate | dateTime | Create, Filter, Nillable, Sort, Update | The date when the modified asset is uninstalled. |

### Associated Objects

- **AssetRelationshipChangeEvent** (API version 62.0) — Change events available
- **AssetRelationshipFeed** — Feed tracking available
- **AssetRelationshipHistory** — History available for tracked fields
- **AssetRelationshipOwnerSharingRule** (API version 58.0) — Sharing rules available
- **AssetRelationshipShare** (API version 58.0) — Sharing available

---

## AssetWarranty

asset에 적용되는 보증 조건(warranty term)과 그에 대한 제외(exclusion)·연장(extension)을 정의한다. API version 50.0 이상에서 사용 가능.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

### Fields

| Field | Type | Properties | Description |
|---|---|---|---|
| AssetId | reference | Create, Filter, Group, Sort | The ID of the asset this warranty term applies to. |
| AssetWarrantyNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | The identifier of the asset warranty record. |
| EndDate | date | Create, Filter, Group, Nillable, Sort, Update | The date on which this warranty term expires. |
| ExchangeType | picklist | Create, Filter, Group, Nillable, Sort, Update | The type of exchange offered by this warranty term. |
| Exclusions | textarea | Create, Nillable, Update | Description of any exclusions. |
| ExpensesCovered | percent | Create, Filter, Nillable, Sort, Update | The percentage of expenses covered. |
| ExpensesCoveredEndDate | date | Create, Filter, Group, Nillable, Sort, Update | The date on which cover for expenses ends. |
| IsTransferable | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Defines whether the warranty term can be transferred to a new owner. |
| LaborCovered | percent | Create, Filter, Nillable, Sort, Update | The percentage of labor covered. |
| LaborCoveredEndDate | date | Create, Filter, Group, Nillable, Sort, Update | The date on which cover for labor ends. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The date when the asset warranty term was last modified. Its label in the user interface is Last Modified Date. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The date when the asset warranty term was last viewed. |
| PartsCovered | percent | Create, Filter, Nillable, Sort, Update | The percentage of parts covered. |
| PartsCoveredEndDate | date | Create, Filter, Group, Nillable, Sort, Update | The date on which cover for parts ends. |
| Pricebook2Id | reference | Create, Filter, Group, Nillable, Sort, Update | The ID of the price book item associated with this asset warranty term. |
| StartDate | date | Create, Filter, Group, Sort, Update | The date on which cover under this warranty term starts. |
| WarrantyTermId | reference | Create, Filter, Group, Nillable, Sort, Update | The ID of the warranty term this asset warranty term extends. |
| WarrantyType | picklist | Create, Filter, Group, Nillable, Sort, Update | The type of the warranty. |

### Associated Objects

- **AssetWarrantyChangeEvent** — Change events available

---

## AttributeDefinition

제품·asset·객체의 속성(예: 하드웨어 사양 또는 소프트웨어 상세)을 나타낸다. API version 57.0 이상에서 사용 가능.

> 원문 [sic]: "a hardward specification" — PDF 오타 그대로.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

**Special Access Rules:** Field Service must be enabled.

### Fields

| Field | Type | Properties | Description |
|---|---|---|---|
| DataType | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | The data type of the attribute definition. **Possible values:** Checkbox · Date · Datetime · Number · Picklist · Text |
| DefaultValue | string | Create, Filter, Group, Nillable, Sort, Update | The default value for this attribute. |
| Description | textarea | Create, Nillable, Update | Description of this attribute. |
| DeveloperName | string | Create, Filter, Group, Sort | The unique name of the attribute definition record. This name must begin with a letter and use only alphanumeric characters and underscores. It can't include spaces, end with an underscore, or have two consecutive underscores. The developer name is used for internal purpose and must be unique for all records (including deleted records). If the system doesn't find the name unique, it automatically overrides the user input and creates a unique name. For external use, the developer name need not be fixed. |
| IsActive | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates that the attribute definition is active. Active attributes definitions can be selected for assets. The default value is false. |
| IsRequired | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether the attribute definition is required for an asset. The default value is false. |
| Label | string | Create, Filter, Group, Sort, Update | The label for the attribute. Displays a friendly name for the attribute, for example, threshold monitor lightning component and recordset filter criteria rule. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The date the attribute definition was last referenced. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The date the attribute definition was last viewed. |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | The name of the attribute. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | The owner of the attribute definition. This field is a polymorphic relationship field. **Relationship Name:** Owner · **Type:** Lookup · **Refers To:** Group, User |
| PicklistId | reference | Create, Filter, Group, Nillable, Sort, Update | The ID of the attribute picklist with the valid values for this attribute. Relationship field. **Relationship Name:** Picklist · **Type:** Lookup · **Refers To:** AttributePicklist |
| SourceSystemIdentifier | string | Create, Filter, Group, Nillable, Sort, Update | The identifier of the attribute definition in an external system. |
| UnitOfMeasureId | reference | Create, Filter, Group, Nillable, Sort, Update | The ID of the measurement unit for this attribute. Relationship field. **Relationship Name:** UnitOfMeasure · **Type:** Lookup · **Refers To:** UnitOfMeasure |

### Usage

여러 개의 커스텀 속성을 asset에 만드는 대신 Asset 객체에 asset descriptor를 추가한다. 이렇게 하면 시스템에서 다양한 asset의 대량 처리로 확장하는 데 도움이 된다. AttributeDefinition을 생성할 때 고유한 API name을 줄 수 있는데, API name이 고유하지 않으면 시스템이 끝에 숫자를 붙인다. 이 숫자 값은 동일한 이름이 사용된 횟수에 따라 달라진다.

### Associated Objects

- **AttributeDefinitionHistory** — History available for tracked fields
- **AttributeDefinitionOwnerSharingRule** — Sharing rules available
- **AttributeDefinitionShare** — Sharing available

---

## AttributePicklist

asset 속성을 위한 커스텀 picklist를 나타낸다. API version 57.0 이상에서 사용 가능.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

**Special Access Rules:** Field Service must be enabled.

### Fields

| Field | Type | Properties | Description |
|---|---|---|---|
| DataType | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The data type of this picklist. **Possible values:** Boolean · Currency · Date · Datetime · Number · Percent · Text. The default value is Boolean. |
| Description | textarea | Create, Nillable, Update | A description of the picklist. Maximum size is 32000 alphanumeric characters. Can include the following special characters: @! - < > * ? + = % # ( ) / \ & ' £ € $ ". |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The date the attribute picklist was last referenced. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The date the attribute picklist was last viewed. |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | The name of the picklist. Names must be unique. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | The ID of the owner of the attribute picklist record. This field is a polymorphic relationship field. **Relationship Name:** Owner · **Type:** Lookup · **Refers To:** Group, User |
| Status | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The status of the attribute picklist. **Possible values:** Active · Draft · Inactive. The default value is Draft. |
| UnitOfMeasureId | reference | Create, Filter, Group, Nillable, Sort, Update | The ID of the unit of measure associated with the product. Relationship field. Available when Revenue Cloud is enabled. Available in API version 63.0 and later. **Relationship Name:** UnitOfMeasure · **Refers To:** UnitOfMeasure |

> [sic] UnitOfMeasureId는 PDF 원문에 **Relationship Type** 하위라벨이 누락되어 있다(Relationship Name·Refers To만 기재).

### Usage

AttributePicklist 객체가 부모(parent) 객체이고 AttributePicklistValue 객체가 picklist 값을 담는다. 예를 들어 T-shirt size(small/medium/large)를 추적하는 asset 속성이 필요하다고 하자. T-shirt size 속성용 AttributePicklist 부모 레코드를 Text 타입으로 만든 뒤, 각 picklist 값(small, medium, large)마다 AttributePicklistValue 레코드를 하나씩 만들어 부모 레코드에 연결한다.

### Associated Objects

- **AttributePicklistHistory** — History available for tracked fields
- **AttributePicklistOwnerSharingRule** — Sharing rules available
- **AttributePicklistShare** — Sharing available

---

## AttributePicklistValue

asset 속성 picklist의 값을 나타낸다. API version 57.0 이상에서 사용 가능.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

**Special Access Rules:** Field Service must be enabled.

### Fields

| Field | Type | Properties | Description |
|---|---|---|---|
| Abbreviation | string | Create, Filter, Group, Nillable, Sort, Update | A short name of the picklist value that's displayed at run time. Use up to 255 alphanumeric characters. Can include the following special characters: @ ! - < > * ? + = % # ( ) / \ & ' £ € $ ". |
| Code | string | Create, Filter, Group, Sort, Update | A picklist value code unique to the picklist. Maximum size is 80 alphanumeric characters. Can include the following special characters: @ ! - < > * ? + = % # ( ) / \ & ' £ € $ ". |
| DisplayValue | string | Create, Filter, Group, Nillable, Sort, Update | The displayed picklist value if it's different from the Name field. For example, the Name '5' could have a DisplayValue 'Five'. |
| IsDefault | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether the picklist value is the default for the associated picklist. Only one value can be the default for a picklist. The default value is false. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The date the attribute picklist value was last referenced. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The date the attribute picklist value was last viewed. |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | The name of the attribute picklist value. |
| PicklistId | reference | Create, Filter, Group, Sort | The ID of the picklist that the value is associated with. Relationship field. **Relationship Name:** Picklist · **Type:** Lookup · **Refers To:** AttributePicklist |
| Sequence | double | Create, Filter, Nillable, Sort, Update | The order in which the picklist value appears in the picklist. |
| Status | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The status of the attribute picklist value. **Possible values:** Active · Draft · Inactive. The default value is Draft. |
| Value | string | Create, Filter, Group, Sort, Update | The text value for a picklist item if the picklist data type is text. This value must be unique within a picklist. Maximum size is 255 alphanumeric characters. Can include the following special characters: @ ! - < > * ? + = % # ( ) / \ & ' £ € $ ". |

### Usage

AttributePicklistValue 객체가 자식(child) 객체이고 AttributePicklist 객체가 picklist를 담는다. 예를 들어 T-shirt size(small/medium/large)를 추적하는 asset 속성이 필요하다고 하자. T-shirt size 속성용 AttributePicklist 부모 레코드를 Text 타입으로 만든 뒤, 각 picklist 값마다 AttributePicklistValue 레코드를 하나씩 만들어 부모 레코드에 연결한다.

### Associated Objects

- **AttributePicklistValueHistory** — History available for tracked fields

---

## WarrantyTerm

제품 문제 해결을 위해 제공되는 보증 조건 — 커버되는 노동(labor)·부품(parts)·비용(expenses)과 교환(exchange) 옵션 — 을 정의한다. API version 50.0 이상에서 사용 가능.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

### Fields

| Field | Type | Properties | Description |
|---|---|---|---|
| Code | string | Create, Filter, Group, Nillable, Sort, Update | A code or other identifier associated with this warranty term. |
| Description | textarea | Create, Nillable, Update | Description of the warranty term. |
| EffectiveStartDate | picklist | Create, Filter, Group, Sort, Update | Date on which the warranty term became available for use. **Possible values:** InstallDate · ManufactureDate · PurchaseDate [sic — Type이 picklist임에도 라벨이 "Date on which…"] |
| ExchangeType | picklist | Create, Filter, Group, Nillable, Sort, Update | The type of exchange offered. **Possible values:** AdvanceExchange · Loaner · ReturnExchange |
| Exclusions | textarea | Create, Nillable, Update | Description of any exclusions. |
| ExpensesCovered | percent | Create, Filter, Nillable, Sort, Update | The percentage of expenses covered. |
| ExpensesCoveredDuration | int | Create, Filter, Group, Nillable, Sort, Update | The duration for which expenses are covered. |
| ExpensesCoveredUnitOfTime | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The unit in which expenses covered duration is measured. **Possible values:** Days · Months · Weeks · Years |
| IsActive | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Defines whether the warranty term is active. |
| IsTransferable | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Defines whether the warranty can be transferred to a new owner. |
| LaborCovered | percent | Create, Filter, Nillable, Sort, Update | The percentage of labor covered. |
| LaborCoveredDuration | int | Create, Filter, Group, Nillable, Sort, Update | The duration for which labor is covered. |
| LaborCoveredUnitOfTime | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The unit in which labor covered duration is measured. **Possible values:** Days · Months · Weeks · Years |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The date when the warranty term was last modified. Its label in the user interface is Last Modified Date. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The date when the warranty term was last viewed. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | The warranty term's assigned owner. |
| PartsCovered | percent | Create, Filter, Nillable, Sort, Update | The percentage of parts covered. |
| PartsCoveredDuration | int | Create, Filter, Group, Nillable, Sort, Update | The duration for which parts are covered. |
| PartsCoveredUnitOfTime | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The unit in which parts covered duration is measured. **Possible values:** Days · Months · Weeks · Years |
| Pricebook2Id | reference | Create, Filter, Group, Nillable, Sort, Update | The ID of the price book item associated with this warranty term. |
| WarrantyDuration | int | Create, Filter, Group, Sort, Update | The duration of the warranty offered by this term. |
| WarrantyTermName | string | Create, Filter, Group, idLookup, Sort, Update | The name of the warranty term. |
| WarrantyType | picklist | Create, Filter, Group, Sort, Update | The type of warranty. **Possible values:** Repair · Standard · Supplier |
| WarrantyUnitOfTime | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | The unit in which the warranty duration is measured. **Possible values:** Days · Months · Weeks · Years |

### Associated Objects

- **WarrantyTermChangeEvent** — Change events available

---

## ProductWarrantyTerm

제품 또는 제품군(product family)과 warranty term 사이의 관계를 정의한다. API version 50.0 이상에서 사용 가능.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

### Fields

| Field | Type | Properties | Description |
|---|---|---|---|
| CoveredProductFamily | picklist | Create, Filter, Group, Nillable, Sort, Update | The product family that the warranty term applies to. |
| CoveredProductId | reference | Create, Filter, Group, Nillable, Sort, Update | The ID of the product that the warranty term applies to. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The date when the product warranty term was last modified. Its label in the user interface is Last Modified Date. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The date when the product warranty term was last viewed. |
| ProductWarrantyTermNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | The identifier for this product warranty term. |
| WarrantyTermId | reference | Create, Filter, Group, Sort | The ID of the warranty term. |

### Associated Objects

- **ProductWarrantyTermChangeEvent** (API version 62.0) — Change events available

---

## 관련 노트

- [[Field Service 개요와 데이터 모델]] — Warranty Management·Core Data Model ER 다이어그램과 이 클러스터의 데이터 모델상 위치
- [[Field Service Objects]] — FSL 표준 객체(ServiceAppointment·WorkOrder·ServiceResource 등) 색인
- [[FSL Apex Namespace]] — Field Service Apex 네임스페이스
- [[Field Service REST API]] — Field Service REST 리소스(`getRelatedListInfo` 등)
- [[객체 레퍼런스 — Maintenance·PSC·Location]] — MaintenanceAsset·ProductServiceCampaignItem이 참조하는 Asset 클러스터
- [[객체 레퍼런스 — Inventory (Product·ReturnOrder·Shipment)]] — Asset을 참조하는 재고 객체(ReturnOrderLineItem.AssetId·SerializedProduct.AssetId)
