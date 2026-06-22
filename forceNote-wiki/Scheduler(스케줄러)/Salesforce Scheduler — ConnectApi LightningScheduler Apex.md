---
tags: [scheduler, salesforce-scheduler, apex, connectapi, lightningscheduler, service-appointment-apex]
source: salesforce_scheduler_dev_guide.pdf (Salesforce Scheduler Developer Guide, v67.0 Summer '26)
created: 2026-06-22
aliases: [ConnectApi LightningScheduler, createServiceAppointment, updateServiceAppointment, ServiceAppointmentInput, Scheduler Apex 예약, CreateServiceAppointmentInput]
---

# Salesforce Scheduler — ConnectApi LightningScheduler Apex

> `ConnectApi.LightningScheduler` 클래스로 Apex에서 서비스 약속(service appointment)을 생성·수정한다 — `createServiceAppointment`·`updateServiceAppointment` 2개 static 메서드와 입출력 ConnectApi 클래스 일체.

---

## 개요

`ConnectApi` 네임스페이스(Apex에서는 **Connect**라고도 부름)는 서비스 약속을 생성·수정하는 클래스를 제공한다.

> The ConnectApi namespace (also called Connect in Apex) provides classes creating and updating service appointments.

핵심 클래스는 `ConnectApi.LightningScheduler`이며 **모든 메서드는 static**이다. 약속 후보·슬롯 조회(`getAppointmentCandidates`·`getAppointmentSlots`)는 이 네임스페이스가 아니라 **`LxScheduler` 네임스페이스의 `SchedulerResources` 인터페이스** 소관이므로 이 노트가 다루지 않는다 → [[LxScheduler Namespace]] 참조.

---

## Apex 메서드 ↔ Connect REST API 매핑

| Apex Method | Connect REST API | 네임스페이스 |
|---|---|---|
| `createServiceAppointment(createServiceAppointmentInput)` | `service-appointments` (POST) | **`ConnectApi.LightningScheduler`** — 이 노트 |
| `updateServiceAppointment(updateServiceAppointmentInput)` | `service-appointments` (PATCH) | **`ConnectApi.LightningScheduler`** — 이 노트 |
| `getAppointmentCandidates(getAppointmentCandidatesInput)` | `getAppointmentCandidates` (POST) | `LxScheduler.SchedulerResources` — [[LxScheduler Namespace]] 참조 |
| `getAppointmentSlots(getAppointmentSlotsInput)` | `getAppointmentSlots` (POST) | `LxScheduler.SchedulerResources` — [[LxScheduler Namespace]] 참조 |

> 후보·슬롯 조회 2종(`getAppointmentCandidates`·`getAppointmentSlots`)과 `LxScheduler` 9개 클래스는 이 노트 범위 밖이다. 메서드 시그니처·입출력 클래스는 [[LxScheduler Namespace]]에 있다. REST 엔드포인트 대응은 [[Salesforce Scheduler — Business REST·Connect 엔드포인트]] 참조.

---

## `ConnectApi.LightningScheduler` 클래스

| 항목 | 값 |
|---|---|
| 설명 | Create and update service appointments. |
| 네임스페이스 | `ConnectApi` |
| 메서드 | 전부 **static** |

### `createServiceAppointment`

| 항목 | 값 |
|---|---|
| 설명 | Create a service appointment. |
| API Version | **53.0** |
| Requires Chatter | No |

**Signature**

```apex
public static ConnectApi.ServiceAppointmentOutput createServiceAppointment(ConnectApi.CreateServiceAppointmentInput createServiceAppointmentInput)
```

**Parameters**

| Name | Type | Description |
|---|---|---|
| `createServiceAppointmentInput` | `ConnectApi.CreateServiceAppointmentInput` | Input parameters to create a service appointment. |

**Return** — `ConnectApi.ServiceAppointmentOutput`

**Usage (verbatim)**

Considerations for using engagement channel types with the `service-appointments` resource:

- Enable Schedule Appointments Using Engagement Channels in Salesforce Scheduler Settings in your Salesforce org.
- When you create or modify appointments, shifts must be defined in the scheduling policy. For more information on setting up shifts in the scheduling policy, see Define Shift Rules in Scheduling Policy.
  > **Note:** Engagement channel types are not supported with operating hours rules in the scheduling policy.
- When you use engagement channel type and shifts to create a service appointment, Salesforce Scheduler considers the default value for the Appointment Type (if not specified). However, Salesforce Scheduler only considers the engagement channel type and Appointment Type is ignored.

**Example — For an account (existing user) (verbatim)**

```apex
ConnectApi.ExtendedFieldInput extendedFieldEmail = new ConnectApi.ExtendedFieldInput();
extendedFieldEmail.name = 'Email';
extendedFieldEmail.value = 'rachael.adams@salesforce.com';
ConnectApi.ExtendedFieldInput extendedFieldPhone = new ConnectApi.ExtendedFieldInput();
extendedFieldPhone.name = 'Phone';
extendedFieldPhone.value = '1234567890';
List<ConnectApi.ExtendedFieldInput> extendedFieldList = new List<ConnectApi.ExtendedFieldInput>();
extendedFieldList.add(extendedFieldEmail);
extendedFieldList.add(extendedFieldPhone);
ConnectApi.ServiceAppointmentInput serviceAppInput = new ConnectApi.ServiceAppointmentInput();
serviceAppInput.extendedFields = extendedFieldList;
serviceAppInput.engagementChannelTypeId = '0eFRM00000000Bv2AI';
serviceAppInput.serviceTerritoryId = '0Hhxx0000004C92CAE';
serviceAppInput.workTypeId = '08qxx0000004C92AAE';
serviceAppInput.parentRecordId = '001xx000003GYR1AAO';
serviceAppInput.schedStartTime = DateTime.valueOf('2021-05-28 12:15:00');
serviceAppInput.schedEndTime = DateTime.valueOf('2021-05-28 12:45:00');
serviceAppInput.appointmentMode = 'Group';
serviceAppInput.attendeeLimit = 20;
ConnectApi.AssignedResourcesInput asResourceInput = new ConnectApi.AssignedResourcesInput();
asResourceInput.serviceResourceId = '0Hnxx0000004CAiCAM';
asResourceInput.isRequiredResource = true;
asResourceInput.isPrimaryResource = true;
List<ConnectApi.AssignedResourcesInput> asResourceInputList = new List<ConnectApi.AssignedResourcesInput>();
asResourceInputList.add(asResourceInput);
ConnectApi.CreateServiceAppointmentInput createInput = new ConnectApi.CreateServiceAppointmentInput();
createInput.serviceAppointment = serviceAppInput;
createInput.assignedResources = asResourceInputList;
try{
ConnectApi.ServiceAppointmentOutput appointmentResult = ConnectApi.LightningScheduler.createServiceAppointment(createInput);
String serviceAppointmentId = appointmentResult.result.serviceAppointmentId;
List<String> assignedResourceIds = appointmentResult.result.assignedResourceIds;
}catch(ConnectApi.ConnectApiException ex){
//Handle Exception
}
```

> `extendedFieldEmail.value = 'rachael.adams@...'` — create 예제는 철자 `rachael`, lead/update 예제는 `rachel`. PDF 원문 그대로 보존(`[sic]`).

**Example — For a lead (authenticated guest user) (verbatim)**

위 account 예제와 동일한 구조이되, `ConnectApi.LeadInput`을 추가로 구성해 `createInput.lead`로 전달한다. PDF 원문은 다음 변경점을 갖는다.

- 앞에 `ConnectApi.LeadInput leadInput = new ConnectApi.LeadInput();` 생성 후 `firstName = 'Rachel'`, `lastName = 'Adams'`, `phone = '012-345-6789'`, `email = 'rachel.adams@salesforce.com'`, `company = 'Salesforce'` 설정.
- `createInput.lead = leadInput;` 설정.
- `parentRecordId`·`appointmentMode`·`attendeeLimit`는 설정하지 않음(account 전용 필드).

### `updateServiceAppointment`

| 항목 | 값 |
|---|---|
| 설명 | Update a service appointment. |
| API Version | **53.0** |
| Requires Chatter | No |

**Signature**

```apex
public static ConnectApi.ServiceAppointmentOutput updateServiceAppointment(ConnectApi.UpdateServiceAppointmentInput updateServiceAppointmentInput)
```

**Parameters**

| Name | Type | Description |
|---|---|---|
| `updateServiceAppointmentInput` | `ConnectApi.UpdateServiceAppointmentInput` | Input parameters to update a service appointment. |

**Return** — `ConnectApi.ServiceAppointmentOutput`

**Usage** — `createServiceAppointment`과 동일한 engagement channel 고려사항 4개를 갖는다(마지막 항목 문구는 "to modify an appointment").

**Example (verbatim — multi-resource update)**

```apex
ConnectApi.ExtendedFieldInput extendedFieldEmail = new ConnectApi.ExtendedFieldInput();
extendedFieldEmail.name = 'Email'; extendedFieldEmail.value = 'rachel.adams@salesforce.com.example';
ConnectApi.ExtendedFieldInput extendedFieldPhone = new ConnectApi.ExtendedFieldInput();
extendedFieldPhone.name = 'Phone'; extendedFieldPhone.value = '0123456789';
ConnectApi.ExtendedFieldInput extendedFieldStatus = new ConnectApi.ExtendedFieldInput();
extendedFieldStatus.name = 'Status'; extendedFieldStatus.value = 'None';
List<ConnectApi.ExtendedFieldInput> extendedFieldList = new List<ConnectApi.ExtendedFieldInput>();
extendedFieldList.add(extendedFieldEmail); extendedFieldList.add(extendedFieldPhone); extendedFieldList.add(extendedFieldStatus);
ConnectApi.ServiceAppointmentInput serviceAppInput = new ConnectApi.ServiceAppointmentInput();
serviceAppInput.extendedFields = extendedFieldList;
serviceAppInput.serviceTerritoryId = '0Hhxx0000004C92CAE';
serviceAppInput.workTypeId = '08qxx0000004C92AAE';
serviceAppInput.schedStartTime = DateTime.valueOf('2021-05-28 12:15:00');
serviceAppInput.schedEndTime = DateTime.valueOf('2021-05-28 12:45:00');
ConnectApi.AssignedResourcesInput asResourceInput = new ConnectApi.AssignedResourcesInput();
asResourceInput.serviceResourceId = '0Hnxx0000004CAiCAM'; asResourceInput.isRequiredResource = true; asResourceInput.isPrimaryResource = true;
//Multi-resource
ConnectApi.AssignedResourcesInput asResourceInputReq = new ConnectApi.AssignedResourcesInput();
asResourceInputReq.serviceResourceId = '0Hnxx0000004CAgCAM'; asResourceInputReq.isRequiredResource = true; asResourceInputReq.isPrimaryResource = false;
List<ConnectApi.AssignedResourcesInput> asResourceInputList = new List<ConnectApi.AssignedResourcesInput>();
asResourceInputList.add(asResourceInput); asResourceInputList.add(asResourceInputReq);
ConnectApi.UpdateServiceAppointmentInput updateInput = new ConnectApi.UpdateServiceAppointmentInput();
updateInput.serviceAppointment = serviceAppInput;
updateInput.assignedResources = asResourceInputList;
updateInput.serviceAppointmentId = '08pxx0000004CYqAAM';
try{
ConnectApi.ServiceAppointmentOutput appointmentResult = ConnectApi.LightningScheduler.updateServiceAppointment(updateInput);
String serviceAppointmentId = appointmentResult.result.serviceAppointmentId;
List<String> assignedResourceIds = appointmentResult.result.assignedResourceIds;
}catch(ConnectApi.ConnectApiException ex){
//Handle Exception
}
```

---

## Input 클래스

> **Input 클래스 개요 (verbatim):** Some ConnectApi methods take arguments that are instances of ConnectApi input classes. Input classes are concrete unless marked abstract. Concrete input classes have public constructors that have no parameters. Some methods have parameters typed with an abstract class — pass in an instance of a concrete child class. Most input class properties can be set. Read-only properties are noted.

모든 Input 클래스는 no-arg 생성자를 갖는다.

### `ConnectApi.CreateServiceAppointmentInput`

| Property | Type | Description | Required/Optional | Ver |
|---|---|---|---|---|
| `assignedResources` | `List<ConnectApi.AssignedResourcesInput>` | Represents the service resources to be assigned to a service appointment. **Note:** When creating an appointment, use `extendedFields` to add values to any of the fields, including custom fields, in `assignedResources` as long as you have edit access. | Optional | 53.0 |
| `lead` | `ConnectApi.LeadInput` | Represents a prospect or lead. **Note:** Required to create a service appointment for unauthenticated guest users. | Required if `serviceAppointment` isn't provided. | 53.0 |
| `schedulingPolicyId` | `String` | The ID of the AppointmentSchedulingPolicy object. If no scheduling policy is passed in the request body, the default configurations are used. The only scheduling policy configuration used in determining time slots is the enforcement of account visiting hours. | Optional | 53.0 |
| `serviceAppointment` | `ConnectApi.ServiceAppointmentInput` | Represents the service appointment details to book an appointment. **Note:** use `extendedFields` to add values. | Required if `lead` isn't provided. | 53.0 |

### `ConnectApi.ExtendedFieldInput`

| Property | Type | Description | Req/Opt | Ver |
|---|---|---|---|---|
| `name` | `String` | The name of the field, including custom field. | Optional | 53.0 |
| `value` | `String` | The value of the field. | Optional | 53.0 |

### `ConnectApi.LeadInput`

| Property | Type | Description | Req/Opt | Ver |
|---|---|---|---|---|
| `company` | `String` | The company of the lead. | Optional | 53.0 |
| `email` | `String` | The email address of the lead. | Optional | 53.0 |
| `extendedFields` | `List<ConnectApi.ExtendedFieldInput>` | Use to add values to any of the fields, including custom fields. | Optional | 53.0 |
| `firstName` | `String` | The first name of the lead. | Optional | 53.0 |
| `lastName` | `String` | The last name of the lead. | Optional | 53.0 |
| `phone` | `String` | The phone number of the lead. | Optional | 53.0 |

### `ConnectApi.ServiceAppointmentInput` (20 properties)

| Property | Type | Description | Req/Opt | Ver |
|---|---|---|---|---|
| `additionalInformation` | `String` | Additional details about the service appointment. | Optional | 53.0 |
| `appointmentMode` | `ConnectApi.SvcApptModeEnum` | Mode of the service appointment. • **Group**—Service appointment mode is Group. • **Regular**—Default mode of service appointment. | Optional | 60.0 |
| `appointmentType` | `String` | Type of the appointment. | Optional | 53.0 |
| `attendeeLimit` | `Integer` | Maximum number of customers that's allowed to attend the service appointment. | Required if the appointment mode is Group. | 60.0 |
| `city` | `String` | Name of the city. | Optional | 53.0 |
| `comments` | `String` | Comments about the appointment. | Optional | 53.0 |
| `contactId` | `String` | ID of the contact associated with the parent record. | Optional | 53.0 |
| `country` | `String` | Name of the country. | Optional | 53.0 |
| `description` | `String` | Description of the appointment. | Optional | 53.0 |
| `engagementChannelTypeId` | `String` | ID of the engagement channel type to associate with the appointment. Use only if: • Schedule Appointments Using Engagement Channels is enabled in Salesforce Scheduler Settings. • Shifts are defined in the scheduling policy. **Note:** Engagement channel types are not supported with operating hours rules in the scheduling policy. | Optional | 56.0 |
| `extendedFields` | `List<ConnectApi.ExtendedFieldInput>` | Values to add to any of the fields, including custom fields. | Optional | 53.0 |
| `parentRecordId` | `String` | ID of the parent record associated with the account. | Required if `lead` isn't provided. | 53.0 |
| `postalCode` | `String` | Postal code of the city. | Optional | 53.0 |
| `schedEndTime` | `Datetime` | Time at which the appointment is scheduled to end. | Optional | 53.0 |
| `schedStartTime` | `Datetime` | Time at which the appointment is scheduled to start. | Optional | 53.0 |
| `serviceTerritoryId` | `String` | ID of the service territory associated with the service appointment. | Optional | 53.0 |
| `state` | `String` | Name of the state. | Optional | 53.0 |
| `street` | `String` | Name of the street. | Optional | 53.0 |
| `subject` | `String` | Short phrase describing the appointment. | Optional | 53.0 |
| `workTypeId` | `String` | ID of the work type associated with the service appointment. If specified, it is added to the service appointment record. | Optional | 53.0 |

### `ConnectApi.SvcApptModeEnum`

`ServiceAppointmentInput.appointmentMode`의 타입.

| Enum 값 | 의미 |
|---|---|
| `Group` | Service appointment mode is Group. |
| `Regular` | Default mode of service appointment. |

> 코드에서는 String literal로 할당한다 — `serviceAppInput.appointmentMode = 'Group';`

### PDF에 property 표가 없는 Input 클래스 (코드 기반만)

아래 두 클래스는 PDF에 **Property/Type/Required/Ver 표가 제공되지 않는다.** Apex 예제 코드에서 사용된 프로퍼티만 제시하며, **타입·필수 여부는 PDF에 명시되지 않았다(추측 금지).**

**`ConnectApi.UpdateServiceAppointmentInput`** (no-arg 생성자)

| Property | 코드상 할당 예 | 비고 |
|---|---|---|
| `serviceAppointment` | `ConnectApi.ServiceAppointmentInput` | PDF에 타입·필수 표 미제공 |
| `assignedResources` | `List<ConnectApi.AssignedResourcesInput>` | PDF에 타입·필수 표 미제공 |
| `serviceAppointmentId` | `String` | update 전용 (수정 대상 약속 ID). PDF에 표 미제공 |

**`ConnectApi.AssignedResourcesInput`** (no-arg 생성자)

| Property | 코드상 할당 예 | 비고 |
|---|---|---|
| `serviceResourceId` | `String` | PDF에 타입·필수 표 미제공 |
| `isRequiredResource` | `Boolean` | PDF에 타입·필수 표 미제공 |
| `isPrimaryResource` | `Boolean` | PDF에 타입·필수 표 미제공 |

> 위 두 표의 Type 열은 PDF의 공식 property 표가 아니라 Apex 예제 코드에서 추론한 사용 형태다. PDF가 해당 클래스의 정식 property 표를 싣지 않았다는 사실을 명시한다.

---

## Output 클래스

> **Output 클래스 개요 (verbatim):** Most ConnectApi methods return instances of ConnectApi output classes. All properties are read-only, except for instances of output classes created within test code. All output classes are concrete unless marked abstract. All concrete output classes have no-argument constructors that you can invoke only from test code.

### `ConnectApi.ServiceAppointmentOutput` (read-only)

| Property | Type | Description | Ver |
|---|---|---|---|
| `result` | `ConnectApi.ServiceAppointmentResult` | Result of the create or update service appointment request. | 53.0 |

### `ConnectApi.ServiceAppointmentResult` (read-only)

| Property | Type | Description | Ver |
|---|---|---|---|
| `assignedResourceIds` | `List<String>` | The IDs of the assigned resources. | 53.0 |
| `parentRecordId` | `String` | The ID of the parent record. | 53.0 |
| `serviceAppointmentId` | `String` | The ID of the service appointment record. | 53.0 |

---

## 예외

`ConnectApi.ConnectApiException` — `createServiceAppointment`·`updateServiceAppointment` 호출의 `catch` 블록에서 처리한다(위 예제 참조).

---

## 관련 노트

- [[LxScheduler Namespace]] — `getAppointmentCandidates`·`getAppointmentSlots` 및 `LxScheduler` 9개 클래스(후보·슬롯 조회 소관)
- [[Salesforce Scheduler — Business REST·Connect 엔드포인트]] — 위 Apex 메서드에 대응하는 `service-appointments` POST/PATCH 등 REST 엔드포인트
- [[Salesforce Scheduler — Connect API 요청·응답 표현형·Error Codes]] — 이 Apex 입력/출력 클래스에 대응하는 Connect 요청/응답 표현형·Error Codes
- [[Salesforce Scheduler — 커스텀 예약 시나리오 (익명·단일리소스)]] — 이 Apex 메서드를 호출하는 시나리오 워크플로우
- [[Salesforce Scheduler — 커스텀 예약 시나리오 (멀티리소스·동시·공유)]] — 멀티리소스·동시·공유 시나리오 워크플로우
- [[Salesforce Scheduler — Platform Events·Metadata API Types]]
- [[Salesforce Scheduler — 개요·셋업·데이터모델·인증·SOQL]]
- [[Salesforce Scheduler 표준객체 — 핵심 예약]]
