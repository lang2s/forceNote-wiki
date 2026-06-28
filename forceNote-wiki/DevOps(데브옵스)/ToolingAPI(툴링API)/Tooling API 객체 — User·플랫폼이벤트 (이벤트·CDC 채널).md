---
tags: [tooling-api, devops, user, platform-event, change-data-capture, event-relay]
source: api_tooling.pdf v67.0 (Summer '26)
created: 2026-06-28
aliases: [User, EventDelivery, EventRelayConfig, EventSubscription, PlatformEventChannel, PlatformEventChannelMember, PlatformEventSubscriberConfig, 사용자, 플랫폼 이벤트, 이벤트 채널, CDC 채널, 이벤트 릴레이, EventBridge, 플랫폼 이벤트 구독 설정]
---

# Tooling API 객체 — User·플랫폼이벤트 (이벤트·CDC 채널)

> User·플랫폼이벤트·CDC 채널·이벤트 릴레이 Tooling sObject 7종 전수 — User identity·PlatformEventChannel(Member)·PlatformEventSubscriberConfig·EventRelayConfig + 제거된 EventDelivery/EventSubscription. User는 표준 필드만 노출하고, PlatformEventChannel/Member는 CDC 커스텀 채널과 엔티티 선택을 정의하며, PlatformEventSubscriberConfig는 플랫폼이벤트 Apex 트리거를 구성하고, EventRelayConfig는 Amazon EventBridge로 이벤트를 중계한다.

이 노트는 Tooling API Reference & Developer Guide v67.0(Summer '26)의 "Tooling API Objects" 챕터 중 **사용자 신원(User) + 플랫폼이벤트·CDC·스트리밍 채널 도메인 sObject 군**을 다룬다. `User`는 Tooling을 통해 **표준 필드만** 노출하고 커스텀 필드는 조회할 수 없다. `PlatformEventChannel`은 Change Data Capture(CDC) 커스텀 채널을 정의하고, `PlatformEventChannelMember`는 그 채널에 선택된 엔티티(또는 커스텀 채널의 플랫폼 이벤트)를 담는다. `PlatformEventSubscriberConfig`는 플랫폼이벤트 Apex 트리거의 배치 크기·실행 사용자 등을 구성하고, `EventRelayConfig`는 플랫폼 이벤트·CDC 이벤트를 Salesforce에서 Amazon EventBridge로 중계한다. 전부 `query()`로 SOQL 조회가 가능하다.

> [!warning] 제거된 객체 (v46.0)
> **EventDelivery**, **EventSubscription** 두 객체는 **API version 46.0에서 제거(Removed)되었다.** API version 41.0~45.0에서만 사용 가능했다. 현재 org에서는 사용할 수 없으므로 "Tooling API로 다룰 수 있다"고 쓰면 안 된다. 다만 v67.0 문서에는 두 객체의 Supported Calls + 전체 Fields 표(각 10필드)가 그대로 남아 있어, 이 노트에는 각 섹션 최상단에 제거 배너를 달고 **역사적 기록(historical record)**으로 필드를 전수 보존한다.

> [!warning] Tooling Ch4에 없는 User/이벤트 객체 (fabricate 금지 — 실제 coverage 신호)
> 아래 객체들은 User·플랫폼이벤트/CDC 도메인에서 흔히 기대되지만 **Tooling API Ch4(Tooling API Objects)에는 존재하지 않는다**(heading 0 hits). 누락이 아니라 실제 coverage gap 신호이므로 Tooling으로 다룰 수 있다고 쓰면 안 된다. 이들은 Metadata API / 일반 SOAP API 전용이다.
> - **StreamingChannel**
> - **ChangeDataCaptureChannel**
> - **ChangeDataCapture**
> - **EventRelayFeedback**
> - **UserAppInfo**
> - **UserAppMenuItem**
> - **UserEmailPreferredPerson**
> - **UserPackageLicense**
> - **UserProvisioning**
> - **UserAuthCertificate**
> - **UserListView**
> - **SessionSetting**

> [!note] 이미 다른 노트에 작성됨 / 다른 그룹 (link-only)
> - **PlatformEventMigration** → [[Tooling API 객체 — 운영·라이프사이클 (Sandbox·배포·릴리즈)]] 소관(C4-7a).
> - **UserAccessPolicy · UserAccessPolicyAction · UserAccessPolicyFilter · UserEntityAccess · UserFieldAccess** → [[Tooling API 객체 — 보안·권한]] 소관(C4-5).
> - **UserCriteria** (Experience Cloud 사이트 모더레이션 기준) → 차기 C4-9 verticals 소관.
> - **User** 객체는 Tooling에서 표준 필드만 노출(커스텀 필드 조회 불가).

> 표기 규약: 필드표는 PDF `-layout` 추출본의 충실 transcription이며, 원문 오타/quirk는 `[sic]`로 보존한다. EventDelivery.Type(StartFlow/ResumeFlow), EventSubscription.ReferenceData, PlatformEventChannel Usage, PlatformEventChannelMember Usage, PlatformEventSubscriberConfig Usage 5건은 물리 페이지 경계로 절단되었던 것을 stitch했다(AP-09).

---

## 객체 빠른 색인

| 객체 | 분류 | 필드 수 | API 최소 버전 |
|---|---|---|---|
| [EventDelivery](#eventdelivery) | 이벤트 (v46 제거) | 10 | 41.0~45.0 (제거) |
| [EventRelayConfig](#eventrelayconfig) | 이벤트 릴레이 | 12 | 56.0 |
| [EventSubscription](#eventsubscription) | 이벤트 (v46 제거) | 10 | 41.0~45.0 (제거) |
| [PlatformEventChannel](#platformeventchannel) | 플랫폼이벤트·CDC 채널 | 9 | 47.0 |
| [PlatformEventChannelMember](#platformeventchannelmember) | 플랫폼이벤트·CDC 채널 | 9 | 47.0 |
| [PlatformEventSubscriberConfig](#platformeventsubscriberconfig) | 플랫폼이벤트 트리거 config | 10 | 51.0 |
| [User](#user) | 사용자 신원 | 5 | 32.0 |

> 필드 수 합계 = **65** (10 + 12 + 10 + 9 + 9 + 10 + 5). 빠른 색인은 알파벳순이며, 아래 본문은 가독성을 위해 도메인별(`####`)로 묶었다.

---

## User (User)

### User

Represents a user. **You can retrieve standard fields on User with the Tooling API, but custom fields can't be retrieved.** This object is available in API version 32.0 and later.

> **Note:** User fields are exposed in SOAP API version 45.0 and later. You can use Tooling API to query for User fields in guest user mode in API version 44.0 and earlier. In API version 45.0 and later, use SOAP API to get this data in guest user mode. User is still exposed in Tooling API to User Profiles with the ViewSetup permission.

- **Version:** API version 32.0 and later.
- **Supported SOAP Calls:** describeLayout(), getDeleted(), getUpdated(), query(), retrieve(), search(), update()
- **Supported REST HTTP Methods:** GET, PATCH
- **Special Access Rules:** 별도 섹션 없음 — 위 Note가 접근 제약(SOAP API 45.0+ 노출, guest user mode 분기, ViewSetup 권한)을 설명한다.

Tooling이 노출하는 **표준(STANDARD) 필드만** 기재한다(커스텀 필드는 Tooling으로 조회 불가).

| Field | Type | Properties | Description |
|---|---|---|---|
| FirstName | string | Create, Filter, Group, NillableSort, Update `[sic: "NillableSort" — 원문 그대로, 정상은 "Nillable, Sort"]` | The user's first name. |
| LastName | string | Create, Filter, Group, NillableSort, Update `[sic: "NillableSort"]` | The user's last name. |
| Name | string | Filter, Group, Sort | Concatenation of FirstName and LastName. Limited to 121 characters. |
| Username | string | Create, Filter, Group, idLookup, Sort, Update | The name of the user in your organization. |
| WorkspaceId | ID | Filter, Group, Nillable, Sort, Update | The ID of the last open Developer Console workspace. |

> User가 Tooling에 노출하는 표준 필드 목록(5개): **FirstName, LastName, Name, Username, WorkspaceId.** 커스텀 필드는 Tooling으로 조회 불가.

---

## Platform Event & CDC Channels (PlatformEventChannel, PlatformEventChannelMember, PlatformEventSubscriberConfig)

### PlatformEventChannel

Represents a custom channel that you can subscribe to in order to receive a stream of change data capture events. This object is available in API version 47.0 and later.

> CDC 이벤트 페이로드의 공통 헤더는 [[ChangeEventHeader]] 참조. 플랫폼 이벤트의 정의·구독 개념은 [[Platform Event 정의와 구독]] 참조. CDC 채널 설정의 실제 실행 절차는 ⚙️ [[integration-eventing-cdc-configure]] 참조.

- **Version:** API version 47.0 and later.
- **Supported SOAP Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST HTTP Methods:** DELETE, GET, HEAD, PATCH, POST, Query
- **Special Access Rules:**
  - To retrieve or query this object, you must have the **View Setup and Configuration** permission.
  - To create, update, or delete this object, you must have the **Customize Application** permission.

| Field | Type | Properties | Description |
|---|---|---|---|
| ChannelType | picklist | Filter, Group, Restricted picklist, Sort | **Required.** The channel type. Valid values are: • **data**—Change Data Capture channel corresponding to the selected entities. • **event**—A channel that contains platform events. |
| DeveloperName | string | Filter, Group, Sort | The unique name for the PlatformEventChannel object. The developer name doesn't include the __chn custom channel suffix. For example, the developer name of the MyChannel__chn custom channel is MyChannel. This name can contain only underscores and alphanumeric characters, and must be unique in your org. It must begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. This field is automatically generated, but you can supply your own value if you create the record using the API. **Note:** • When creating large sets of data, always specify a unique DeveloperName for each record. If no DeveloperName is specified, performance slows down while Salesforce generates one for each record. • Only users with View DeveloperName OR View Setup and Configuration permission can view, group, sort, and filter this field. |
| EventType | picklist | Filter, Group, Nillable, Restricted picklist, Sort | The type of events that the channel can hold. A channel can hold only one type of events. Use this field to optionally specify a specific type of events for a channel in combination with the ChannelType field. Valid values are: • **custom**—The channel contains custom platform events. This value is valid with the channelType of event. • **data**—The channel contains change data capture events. This value is valid with the channelType of data. • **monitoring**—The channel contains Real-Time Event Monitoring events. This value is valid with the channelType of event. • **standard**—Reserved for internal use. Available in API version 61.0 and later. |
| FullName | string | Create, Group, Nillable | The full name of the associated PlatformEventChannel in Metadata API. The full name can include a namespace prefix. The full name includes the __chn custom channel suffix. For example, the full name of the MyChannel custom channel is MyChannel__chn. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The language of the MasterLabel. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: • beta • deleted • deprecated • deprecatedEditable • installed • installedEditable • released • unmanaged |
| MasterLabel | string | Filter, Group, Sort | The channel label. The label of this field is Label. |
| Metadata | complexvalue | Create, Nillable, Update | Platform event channel metadata. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace prefix that is associated with this object. Each Developer Edition org that creates a managed package has a unique namespace prefix. Limit: 15 characters. You can refer to a component in a managed package by using the namespacePrefix__componentName notation. The namespace prefix can have one of the following values. • In Developer Edition orgs, NamespacePrefix is set to the namespace prefix of the org for all objects that support it, unless an object is in an installed managed package. In that case, the object has the namespace prefix of the installed managed package. This field's value is the namespace prefix of the Developer Edition org of the package developer. • In orgs that are not Developer Edition orgs, NamespacePrefix is set only for objects that are part of an installed managed package. All other objects have no namespace prefix. |

#### PlatformEventChannel — Usage (verbatim)

This JSON example is the body of a REST API POST request that creates the SalesEvents__chn custom channel. The corresponding REST endpoint is `/services/data/v67.0/tooling/sobjects/PlatformEventChannel`.

```json
{
    "FullName": "SalesEvents__chn",
    "Metadata": {
      "channelType": "data",
      "label": "My Custom Channel"
    }
}
```

> **Note:**
> • You can update only the FullName field and the metadata label field of a PlatformEventChannel.
> • If you delete a PlatformEventChannel, all its member PlatformEventChannelMember components are also deleted.

You can query custom channels in SOQL over Tooling API but not the standard channel (ChangeEvents). For example, this query returns fields of channel members from all custom channels.

```sql
SELECT Id, DeveloperName, ChannelType, MasterLabel FROM PlatformEventChannel
```

**SEE ALSO:**
- Change Data Capture Developer Guide: Subscription Channels
- Change Data Capture Developer Guide: Compose Streams of Change Data Capture Notifications with Custom Channels
- PlatformEventChannelMember

---

### PlatformEventChannelMember

Represents an entity selected for Change Data Capture notifications on a standard or custom channel, or a platform event selected on a custom channel. This object is available in API version 47.0 and later.

> CDC 이벤트 헤더는 [[ChangeEventHeader]] 참조. 플랫폼 이벤트의 정의·구독 개념은 [[Platform Event 정의와 구독]] 참조.

- **Version:** API version 47.0 and later.
- **Supported SOAP Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update()  `[upsert() 없음 — PlatformEventChannel과 다름]`
- **Supported REST HTTP Methods:** DELETE, GET, HEAD, PATCH, POST, Query
- **Special Access Rules:**
  - To retrieve or query this object, you must have the **View Setup and Configuration** permission.
  - To create, update, or delete this object, you must have the **Customize Application** permission.
  - The **EventChannel** and **SelectedEntity** fields can't be updated.

| Field | Type | Properties | Description |
|---|---|---|---|
| DeveloperName | string | Filter, Group, Sort | The unique name for the PlatformEventChannelMember object. This name can contain only underscores and alphanumeric characters, and must be unique in your org. It must begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. This field is automatically generated, but you can supply your own value if you create the record using the API. The developer name is in the format **ChannelName_EventName**. If your channel member name contains a custom channel name to make it unique, ensure to replace the double underscores in the name with one underscore. For example, the developer name of a member of the MyChannel__chn custom channel is MyChannel_chn_AccountChangeEvent. And the developer name of a member of the default standard channel is ChangeEvents_AccountChangeEvent. **Note:** • When creating large sets of data, always specify a unique DeveloperName for each record. If no DeveloperName is specified, performance slows down while Salesforce generates one for each record. • Only users with View DeveloperName OR View Setup and Configuration permission can view, group, sort, and filter this field. |
| EventChannel | picklist | Filter, Group, Nillable, Restricted picklist, Sort | The name of a channel. For the standard channel, the name is ChangeEvents. For a custom channel, the name is in this format: MyChannel__chn. |
| FilterExpression | textarea | Nillable | An expression that is used to filter the stream of events and deliver only the events that match specific criteria. The filter expression can contain one or more field-value expressions. The filter expression format is based on SOQL and supports a subset of SOQL operators and field types. For example, this filter expression delivers only events that contain the City__c field with a value of 'San Francisco'. `City__c = 'San Francisco'` For more information, see Filter Your Stream of Platform Events with Channels in the Platform Events Developer Guide and Filter Your Stream of Change Events with Channels in the Change Data Capture Developer Guide. **Available in API version 56.0 and later.** |
| FullName | string | Create, Group, Nillable | The full name of the associated PlatformEventChannelMember object in Metadata API. The full name is in the format ChannelName_EventName and can include a namespace prefix. Two consecutive underscores in full names designate either a component name suffix or a namespace prefix. In all other cases, two consecutive underscores aren't supported in full names. If your channel member name contains a custom channel name to make it unique, be sure to replace the double underscores in the name with one underscore. For example, the member name would be MyChannel_chn_AccountChangeEvent and not MyChannel__chn_AccountChangeEvent. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| Language | picklist | Defaulted on create, Filter, Group, Restricted picklist, Sort | The language of the MasterLabel. `[참고: 다른 객체와 달리 Properties에 Nillable 없음]` |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: • beta • deleted • deprecated • deprecatedEditable • installed • installedEditable • released • unmanaged |
| Metadata | complexvalue | Create, Nillable, Update | Platform event channel member metadata. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace prefix that is associated with this object. Each Developer Edition org that creates a managed package has a unique namespace prefix. Limit: 15 characters. You can refer to a component in a managed package by using the namespacePrefix__componentName notation. The namespace prefix can have one of the following values. • In Developer Edition orgs, NamespacePrefix is set to the namespace prefix of the org for all objects that support it, unless an object is in an installed managed package. In that case, the object has the namespace prefix of the installed managed package. This field's value is the namespace prefix of the Developer Edition org of the package developer. • In orgs that aren't Developer Edition orgs, NamespacePrefix is set only for objects that are part of an installed managed package. All other objects have no namespace prefix. |
| SelectedEntity | picklist | Filter, Group, Nillable, Restricted picklist, Sort | The change event name of an entity selected for Change Data Capture notifications. For example, for the Account standard object, the name is AccountChangeEvent, or for a custom object MyObject__c, the name is MyObject__ChangeEvent. |

#### PlatformEventChannelMember — Usage (verbatim)

This JSON example is the body of a REST API POST request. It adds a member to a custom channel named SalesEvents__chn. The corresponding REST endpoint is `/services/data/v67.0/tooling/sobjects/PlatformEventChannelMember`.

```json
{
    "FullName": "SalesEvents_chn_AccountChangeEvent",
    "Metadata": {
      "eventChannel": "SalesEvents__chn",
      "selectedEntity": "AccountChangeEvent"
    }
}
```

To add a member to the ChangeEvents default channel, the request body looks as follows.

```json
{
    "FullName": "ChangeEvents_AccountChangeEvent",
    "Metadata": {
      "eventChannel": "ChangeEvents",
      "selectedEntity": "AccountChangeEvent"
    }
}
```

You can query PlatformEventChannelMember in SOQL over Tooling API. For example, this query returns fields of all channel members on all channels.

```sql
SELECT Id,DeveloperName,EventChannel,SelectedEntity FROM PlatformEventChannelMember
```

> **Note:** For custom channels, the EventChannel value that the query returns is the channel ID, which starts with the 0YL prefix.

You can configure a channel member to include extra fields in change events as part of Change Data Capture Enrichment. For more information, see Example: Add Event Enrichment Fields with Tooling API in the Change Data Capture Developer Guide.

**SEE ALSO:**
- Change Data Capture Developer Guide: Filter Your Stream of Change Events with Channels
- Platform Events Developer Guide: Filter Your Stream of Platform Events with Channels
- Change Data Capture Developer Guide: Example Diagrams for Channels and Channel Members
- Platform Events Developer Guide: Filter Your Stream of Platform Events with Channels (Beta)
- PlatformEventChannel

---

### PlatformEventSubscriberConfig

Represents configuration settings for a platform event Apex trigger, including the batch size and the trigger's running user. This object is available in API version 51.0 and later.

> 플랫폼 이벤트 트리거의 배치 처리·병렬 구독·실행 한도는 [[Platform Event 한도와 고려사항]] 참조.

- **Version:** API version 51.0 and later.
- **Supported SOAP API Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query
- **Special Access Rules:** 별도 섹션 없음 — 문서에 별도 Special Access Rules 섹션이 없다.

| Field | Type | Properties | Description |
|---|---|---|---|
| BatchSize | int | Create, Filter, Group, Nillable, Sort, Update | A custom batch size, from 1 through 2,000, for the platform event Apex trigger. The batch size corresponds to the maximum number of event messages that can be sent to a trigger in one execution. The default batch size is 2,000 for platform event triggers. We don't recommend setting the batch size to 1 to process one event at a time. Small batch sizes can slow down the processing of event messages. |
| DeveloperName | string | Create, Filter, Group, Sort, Update | The unique name for the PlatformEventSubscriberConfig object. This name can contain only underscores and alphanumeric characters, and must be unique in your org. It must begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. This field is automatically generated, but you can supply your own value if you create the record using the API. **Note:** When creating large sets of data, always specify a unique DeveloperName for each record. If no DeveloperName is specified, performance can slow down while Salesforce generates one for each record. **Note:** Only users with View DeveloperName OR View Setup and Configuration permission can view, group, sort, and filter this field. |
| Language | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The language of PlatformEventSubscriberConfig. Possible values are: • da—Danish • de—German • en_US—English • es—Spanish • es_MX—Spanish (Mexico) • fi—Finnish • fr—French • it—Italian • ja—Japanese • ko—Korean • nl_NL—Dutch • no—Norwegian • pt_BR—Portuguese (Brazil) • ru—Russian • sv—Swedish • th—Thai • zh_CN—Chinese (Simplified) • zh_TW—Chinese (Traditional) |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: • beta • deleted • deprecated • deprecatedEditable • installed • installedEditable • released • unmanaged |
| MasterLabel | string | Create, Filter, Group, Sort, Update | Label for PlatformEventSubscriberConfig. In the UI, this field is **Platform Event Subscriber Configuration**. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace prefix that is associated with this object. Each Developer Edition org that creates a managed package has a unique namespace prefix. Limit: 15 characters. You can refer to a component in a managed package by using the namespacePrefix__componentName notation. The namespace prefix can have one of these values. • In Developer Edition orgs, NamespacePrefix is set to the namespace prefix of the org for all objects that support it, unless an object is in an installed managed package. In that case, the object has the namespace prefix of the installed managed package. This field's value is the namespace prefix of the Developer Edition org of the package developer. • In orgs that aren't Developer Edition orgs, NamespacePrefix is set only for objects that are part of an installed managed package. All other objects have no namespace prefix. |
| NumPartitions | int | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | Specifies the number of parallel subscriptions, or partitions, that are created internally for an Apex trigger. Use this field to set up parallel subscriptions for the platform event Apex trigger. It can be a number from 1 through 10. See Platform Event Processing at Scale with Parallel Subscriptions for Apex Triggers in the Platform Events Developer Guide. The default value is 1. **This field is available in API version 62.0 and later.** |
| PartitionKey | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Can be the standard EventUuid field name, or the name of a required custom field of the custom platform event that the Apex trigger subscribes to. For the standard EventUuid field, the partition key format is the field name without the event name: EventUuid. For a custom field, the partition key includes the event name as a prefix in this format: EventName__e.FieldName__c. Based on the field's generated hash value, the system determines which partition to send the event to. Use this field to specify the platform event field that is used as a partition key for parallel subscriptions. See Platform Event Processing at Scale with Parallel Subscriptions for Apex Triggers in the Platform Events Developer Guide. The default value is EventUuid. **This field is available in API version 62.0 and later.** |
| PlatformEventConsumerId | reference | Create, Filter, Group, Sort, Update | The ID of the platform event Apex trigger to configure. This field is unique within your Salesforce org. To get the Apex trigger ID, perform a query in Tooling API after replacing the placeholder name with the trigger name. `SELECT Id FROM ApexTrigger WHERE Name='<Trigger_Name_Placeholder>'`. You can run the Tooling API query in the Developer Console's Query Editor. For more information, see Developer Console in Salesforce Help. |
| UserId | reference | Create, Filter, Group, Nillable, Sort, Update | The ID of the user that the platform event Apex trigger runs as. By default, the platform event trigger runs as the Automated Process entity. Setting the running user to a specific user has these benefits: • Records are created or modified as this user. • Records with OwnerId fields have their OwnerId fields populated to this user when created or modified. • Debug logs for the trigger execution are created by this user. • You can send email from the trigger, which isn't supported with the default Automated Process user. |

#### PlatformEventSubscriberConfig — Usage (verbatim)

To add a configuration, perform a POST request to this endpoint.

```
/services/data/v67.0/tooling/sobjects/PlatformEventSubscriberConfig
```

Provide the values in the request body. This example request configures an existing trigger with the batch size of 200 and specifies the ID of a running user.

```json
{
     "BatchSize": "200",
     "DeveloperName":"OrderEventTriggerConfig",
     "MasterLabel":"OrderEventTriggerConfig",
     "PlatformEventConsumerId": "01qRM0000004PEhYAM",
     "UserId": "005RM00000231cZYAQ"
}
```

To get or manipulate a configuration, use this endpoint with the ID of your PlatformEventSubscriberConfig record appended.

```
/services/data/v67.0/tooling/sobjects/PlatformEventSubscriberConfig/<ID>
```

All these requests use the endpoint with the PlatformEventSubscriberConfig record ID appended.
- Get a specific configuration with a GET request.
- Delete a specific configuration with a DELETE request.
- Update a specific configuration with a PATCH request. For this request, include the PlatformEventSubscriberConfig definition in the request body.

Also, you can query retrieve the configurations in your org with SOQL. If querying from the Developer Console Query Editor, ensure you select Use Tooling API. This example query retrieves all configurations set up in your Salesforce org.

```sql
SELECT Id,DeveloperName,BatchSize,PlatformEventConsumerId,UserId FROM
PlatformEventSubscriberConfig
```

---

## Event Relay (EventRelayConfig)

### EventRelayConfig

Represents the configuration of an event relay, which relays platform events and change data capture events from Salesforce to Amazon EventBridge. This object is available in API version 56.0 and later.

> **Important:** Where possible, we changed noninclusive terms to align with our company value of Equality. We maintained certain terms to avoid any effect on customer implementations.

> Salesforce → 외부 시스템으로의 이벤트 통합 패턴(EventBridge 중계 포함)은 [[Platform Event 통합 패턴]] 참조.

- **Version:** API version 56.0 and later.
- **Supported SOAP API Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query
- **Special Access Rules:**
  - To retrieve or query this object, you must have the **View Setup and Configuration** permission.
  - To create, update, or delete this object, you must have the **Customize Application** permission.
  - You can update only the **state** and **relayOption** fields and not **eventChannel** or **destinationResourceName**. Update the state and relayOption fields through the **Metadata** field.

| Field | Type | Properties | Description |
|---|---|---|---|
| DestinationResourceName | string | Filter, Group, Sort | The developer name of the named credential, which stores the AWS account information. The destinationResourceName value contains the callout: prefix. For example: `callout:MyRelayNamedCredential` |
| DeveloperName | string | Filter, Group, Sort | **Required.** The unique name of the object in the API. This name can contain only underscores and alphanumeric characters, and must be unique in your org. It must begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. In managed packages, this field prevents naming conflicts on package installations. With this field, a developer can change the object's name in a managed package and the changes are reflected in a subscriber's organization. **Label is Record Type Name.** This field is automatically generated, but you can supply your own value if you create the record using the API. **Note:** When creating large sets of data, always specify a unique DeveloperName for each record. If no DeveloperName is specified, performance may slow while Salesforce generates one for each record. |
| EventChannel | picklist | Filter, Group, Restricted picklist, Sort | The full name of the event channel used in the event relay. For example: `MyRelayChannel__chn` |
| FullName | string | Create, Group, Nillable | The full name of the associated EventRelayConfig in Metadata API. The full name can include a namespace prefix. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The language of the EventRelayConfig. Possible values are: • da—Danish • de—German • en_US—English • es—Spanish • es_MX—Spanish (Mexico) • fi—Finnish • fr—French • it—Italian • ja—Japanese • ko—Korean • nl_NL—Dutch • no—Norwegian • pt_BR—Portuguese (Brazil) • ru—Russian • sv—Swedish • th—Thai • zh_CN—Chinese (Simplified) • zh_TW—Chinese (Traditional) |
| ManageableState | ManageableState enumerated list `[원문은 Type=picklist으로 표기 후 셀 내부에 Type=ManageableState enumerated list를 중첩 표기하는 PDF 추출 quirk; 실효 타입=ManageableState enumerated list]` | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: • beta • deleted • deprecated • deprecatedEditable • installed • installedEditable • released • unmanaged |
| MasterLabel | string | Filter, Group, Sort | The label for the event relay, which corresponds to the label of the EventRelayConfig metadata type. The label is displayed in the user interface. If the label isn't provided in the metadata type, MasterLabel is the DeveloperName value. |
| Metadata | EventRelayConfig | Create, Nillable, Update | The EventRelayConfig's metadata. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace prefix associated with this object. Each Developer Edition organization that creates a managed package has a unique namespace prefix. Limit: 15 characters. You can refer to a component in a managed package by using the namespacePrefix__componentName notation. The namespace prefix can have one of the following values: • In Developer Edition organizations, the namespace prefix is set to the namespace prefix of the organization for all objects that support it. There is an exception if an object is in an installed managed package. In that case, the object has the namespace prefix of the installed managed package. This field's value is the namespace prefix of the Developer Edition organization of the package developer. • In organizations that are not Developer Edition organizations, NamespacePrefix is only set for objects that are part of an installed managed package. There is no namespace prefix for all other objects. |
| RelayOption | textarea | Nillable | A JSON-encoded string that contains an option for resuming an event relay after the system recovers from an error. This option is used if the event relay can't resume after the last relayed event. The options available are: • `"{\"ReplayRecovery\":\"LATEST\"}"`—(Default) Start relaying events from new events received in the event bus. Use this option if you aren't interested in missed events while the relay was down. • `"{\"ReplayRecovery\":\"EARLIEST\"}"`—Resend all events stored in the event bus and relay new events thereafter. The event bus stores events for up to three days. Use this option if you want to reprocess all stored events and catch up on missed events. |
| State | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The execution state of the event relay. Possible values are: • **RUN**—The event relay is running and actively relaying event messages from Salesforce to Amazon EventBridge. • **PAUSE**—An administrator paused the event relay. No events are relayed to Amazon EventBridge during this status. All current state information is saved. • **STOP**—(Default) The event relay is stopped and no events are relayed to Amazon EventBridge. All current state information is deleted. • **DELETE**—Reserved for future use. |
| UsageType | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | Reserved for future use. |

> **State enum 전수(4값):** RUN / PAUSE / STOP / DELETE — 4값 전부 동일 페이지에 표시되며 hidden next-page 값은 없다. UsageType이 State 다음에 와서 페이지가 자연 종료되므로 누락 없음. 이 객체에 별도 "Status" 필드는 없으며, State 단일 필드가 실행 상태를 나타낸다.

#### EventRelayConfig — Usage (verbatim)

This JSON example is the body of a REST API POST request that creates an event relay named MyEventRelay. It includes the optional fields relayOption and state. The corresponding REST endpoint is `/services/data/v67.0/tooling/sobjects/EventRelayConfig`.

```json
{
        "FullName": "Carbon_Comparison_Relay",
        "Metadata": {
            "destinationResourceName": "callout:AWS_Account",
            "eventChannel": "Carbon_Comparison_Channel__chn",
            "label": "Carbon Comparison Relay",
            "relayOption": "{\"ReplayRecovery\":\"LATEST\"}",
            "state": "STOP"
        }
}
```

> `[원문 quirk: Usage JSON의 "label" 키가 curly/smart quotes로 표기됨 — 위에서 일반 ASCII 따옴표로 정규화함.]`

---

## 제거됨 (EventDelivery, EventSubscription)

### EventDelivery

> [!warning] 제거됨 — API version 46.0에서 제거(Removed). API version 41.0~45.0에서만 사용 가능했다. 현재 org에서는 사용할 수 없으며, 아래 필드 표는 v67.0 문서에 남아 있는 **역사적 기록**이다.

Represents how an event instant maps to a target payload. **Removed in API version 46.0. Available in API version 41.0 to 45.0.**

- **Version:** (제거 객체) API version 41.0~45.0.
- **Supported SOAP Calls:** create(), delete(), query(), retrieve(), update(), upsert()
- **Supported REST HTTP Methods:** GET, POST, PUT, PATCH, HEAD
- **Special Access Rules:** 문서에 별도 섹션 없음.

| Field | Type | Properties | Description |
|---|---|---|---|
| DeveloperName | string | Filter, Group, Sort | The developer's internal name for the event delivery used in the API. **Note:** Only users with View DeveloperName OR View Setup and Configuration permission can view, group, sort, and filter this field. |
| EventSubscriptionId | reference | Filter, Group, Sort | **Required.** The ID of the subscription to deliver the data to. |
| FullName | string | Create, GroupGroup, Nillable `[sic: "GroupGroup"]` | The unique name used as the event delivery identifier for API access. The fullName can contain only underscores and alphanumeric characters. It must be unique, begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. |
| Language | picklist | Defaulted on create, Filter, GroupGroup, Nillable, Restricted picklist, Sort, `[sic: "GroupGroup"; 끝에 매달린 쉼표]` | The language of the MasterLabel. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: • beta • deleted • deprecated • deprecatedEditable • installed • installedEditable • released • unmanaged |
| MasterLabel | string | Filter, Group, Sort | Master label for the event delivery. This internal label doesn't get translated. |
| Metadata | mns:EventDelivery | Create, Nillable, Update | The event delivery's metadata. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace prefix that is associated with this object. Each Developer Edition org that creates a managed package has a unique namespace prefix. Limit: 15 characters. You can refer to a component in a managed package by using the namespacePrefix__componentName notation. The namespace prefix can have one of the following values. • In Developer Edition orgs, NamespacePrefix is set to the namespace prefix of the org for all objects that support it, unless an object is in an installed managed package. In that case, the object has the namespace prefix of the installed managed package. This field's value is the namespace prefix of the Developer Edition org of the package developer. • In orgs that are not Developer Edition orgs, NamespacePrefix is set only for objects that are part of an installed managed package. All other objects have no namespace prefix. |
| ReferenceData | string | Filter, Group, Nillable, Sort | User-defined non-unique identifier. |
| Type | picklist | Filter, Group, Restricted picklist, Sort | **Required.** Determines what action occurs when the event is delivered to the listeners on behalf of the subscribers. Valid values are: • **StartFlow**—When the event occurs, it's delivered to a flow of type CustomEvent. Those flows are built through Process Builder. • **ResumeFlow**—Reserved for future use. |

---

### EventSubscription

> [!warning] 제거됨 — API version 46.0에서 제거(Removed). API version 41.0~45.0에서만 사용 가능했다. 현재 org에서는 사용할 수 없으며, 아래 필드 표는 v67.0 문서에 남아 있는 **역사적 기록**이다.

Represents a subscription to an event type. **Removed in API version 46.0. Available in API version 41.0 to 45.0.**

- **Version:** (제거 객체) API version 41.0~45.0.
- **Supported SOAP Calls:** create(), delete(), query(), retrieve(), update(), upsert()
- **Supported REST HTTP Methods:** GET, POST, PUT, PATCH, HEAD
- **Special Access Rules:** 문서에 별도 섹션 없음.

| Field | Type | Properties | Description |
|---|---|---|---|
| Active | boolean | Defaulted on create, Filter, Group, Sort | If the subscription isn't active, it never receives any events. |
| DeveloperName | string | Filter, Group, Sort | The developer's internal name for the event delivery used in the API. **Note:** Only users with View DeveloperName OR View Setup and Configuration permission can view, group, sort, and filter this field. |
| EventType | picklist | Filter, Group, Restricted picklist, Sort | The type of event to subscribe to. Valid values are: • **AlarmEvent**—An alarm that's offset from an absolute time (supported only if the EventDelivery type is ResumeFlow) • **CustomEvent**—Reserved for future use • **DateRefAlarmEvent**—An alarm that's offset from a date/time field value (supported only if the EventDelivery type is ResumeFlow) • **EventObject**—A custom platform event • **StandardPlatformEvent**—A standard platform event |
| FullName | string | Create, Group, Nillable | The unique name used as the event delivery identifier for API access. The fullName can contain only underscores and alphanumeric characters. It must be unique, begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The language of the MasterLabel. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: • beta • deleted • deprecated • deprecatedEditable • installed • installedEditable • released • unmanaged |
| MasterLabel | string | Filter, Group, Sort | Master label for the event subscription. This internal label doesn't get translated. |
| Metadata | mns:EventSubscription | Create, Nillable, Update | The event subscription's metadata. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace prefix that is associated with this object. Each Developer Edition org that creates a managed package has a unique namespace prefix. Limit: 15 characters. You can refer to a component in a managed package by using the namespacePrefix__componentName notation. The namespace prefix can have one of the following values. • In Developer Edition orgs, NamespacePrefix is set to the namespace prefix of the org for all objects that support it, unless an object is in an installed managed package. In that case, the object has the namespace prefix of the installed managed package. This field's value is the namespace prefix of the Developer Edition org of the package developer. • In orgs that are not Developer Edition orgs, NamespacePrefix is set only for objects that are part of an installed managed package. All other objects have no namespace prefix. |
| ReferenceData | string | Filter, Group, Sort | If the subscriber is a flow of type CustomEvent, referenceData is `flowName_versionNumber`. For example, `Printer_Management_2`. |

---

## 관련 노트

**Tooling API 형제 노트**
- [[Tooling API — 개요·REST·SOAP 호출 기초]]
- [[Tooling API — Objects and Namespaces (객체 분류)]]
- [[Tooling API — SOAP·REST 헤더]]
- [[Tooling API 객체 — Apex 코드·테스트·커버리지]] — PlatformEventSubscriberConfig가 참조하는 ApexTrigger 등 Apex 코드 sObject 소관
- [[Tooling API 객체 — Entity·Field·스키마]]
- [[Tooling API 객체 — 보안·권한]] — UserAccessPolicy·UserEntityAccess·UserFieldAccess 등 User 권한 sObject 소관(link-only)
- [[Tooling API 객체 — 자동화 (Flow·Workflow·룰)]]
- [[Tooling API 객체 — UI·레이아웃 (페이지·액션·탭)]]
- [[Tooling API 객체 — Lightning (Aura·LWC 번들)]]
- [[Tooling API 객체 — 운영·라이프사이클 (Sandbox·배포·릴리즈)]] — PlatformEventMigration 등 운영·라이프사이클 sObject 소관(link-only)
- [[Tooling API 객체 — 패키징·브랜딩 (1GP·2GP·정적콘텐츠)]]

**Platform Event / CDC 도메인**
- [[Platform Event 정의와 구독]] — PlatformEventChannel·PlatformEventChannelMember 가 다루는 플랫폼 이벤트·구독 개념
- [[ChangeEventHeader]] — CDC 채널이 전달하는 변경 이벤트 공통 헤더
- [[Platform Event 통합 패턴]] — EventRelayConfig 의 EventBridge 중계를 포함한 통합 패턴
- [[Platform Event 한도와 고려사항]] — PlatformEventSubscriberConfig 의 배치·병렬 구독 한도

**sf-skill (실행)**
- ⚙️ [[integration-eventing-cdc-configure]] — CDC 채널 설정 실행 대응(지식=위키·실행=스킬)
