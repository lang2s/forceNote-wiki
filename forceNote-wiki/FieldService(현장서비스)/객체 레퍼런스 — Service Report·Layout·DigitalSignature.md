---
tags: [field-service, fsl, sobject, object-reference, service-report, digital-signature, 현장서비스, 서비스리포트, 전자서명]
source: field_service_dev.pdf (Field Service Developer Guide v67.0 Summer '26)
created: 2026-06-24
aliases: [ServiceReport, ServiceReportLayout, DigitalSignature, Service Report Template, DigitalSignatureChangeEvent, ServiceReportChangeEvent, ServiceReportLayoutChangeEvent, 서비스 리포트, 서비스 리포트 템플릿, 전자 서명, 디지털 서명, 서명 캡처]
---

# 객체 레퍼런스 — Service Report·Layout·DigitalSignature

> Field Service의 **서비스 리포트(Service Report) 클러스터** SOAP API 객체 3종 전수 레퍼런스 — 작업지시/약속을 요약하고 PDF로 공유·서명되는 ServiceReport, 그 템플릿을 나타내는 ServiceReportLayout, 리포트 위에 캡처되는 서명 DigitalSignature. 각 객체의 설명·Supported Calls·전 필드·Special Access Rules·enum·Usage·Associated Objects를 담는다.

> 이 노트는 Field Service의 **서비스 리포트(Service Report) 데이터 모델** 도메인 SOAP API 객체 정의를 다룬다. 전체 데이터 모델 개요와 객체 간 관계도는 [[Field Service 개요와 데이터 모델]], 객체 카탈로그 요약은 [[Field Service Objects]]를 참조한다. 서비스 리포트 템플릿을 REST로 다루는 방법은 [[Field Service REST API]]의 Service Report Template REST 리소스와 연계된다.
>
> **[sic] 보존:** PDF 원문의 오타·오기를 의도적으로 그대로 둔 곳에 `[sic]`을 달았다(DigitalSignature의 `audio/acc`, ServiceReport Supported Calls의 `undelete()update( )`, DocumentContentType 설명의 마침표 2개, 그 enum의 `text/calendar` 중복 등). 교정하지 않았다.

---

## 객체 한눈에 (3)

| # | 객체 | 한 줄 | 필드 수(전수) | API 도입 |
|---|---|---|---|---|
| 1 | ServiceReport | WO/WOLI/약속을 요약하는 리포트(고객 서명·PDF 공유 가능) | 12 | — |
| 2 | ServiceReportLayout | 서비스 리포트 템플릿 (읽기 전용 계열) | 5 | — |
| 3 | DigitalSignature | 서비스 리포트 위에 캡처된 서명 | 10 | — |

> 필드 표 형식: PDF는 2열(Field Name | Details)이고 Details 셀 안에 Type/Properties/Description/Relationship Name/Relationship Type/Refers To가 세로 나열돼 있다. 본 노트는 이를 4열(Field · Type · Properties · Description)로 펼치고, 관계 필드는 Description 끝에 `RelName / RelType / Refers To`를 표기했다. enum(picklist 값)은 표 아래 별도 목록으로 전수 게재했다.

---

## 1. ServiceReport

작업지시(work order), 작업지시 라인 아이템(work order line item), 또는 서비스 약속(service appointment)을 요약하는 **리포트**를 나타낸다. 서비스 리포트에 나타나는 필드는 그 서비스 리포트 템플릿이 결정한다. 서비스 리포트는 고객이 서명할 수 있고 PDF로 공유할 수 있다.

**Supported Calls:** `create()`, `delete()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `undelete()update( )` [sic — PDF 원문에서 `undelete()`와 `update()`가 공백 없이 붙고 `update` 괄호 안에 공백이 있음; 정상 형태는 `undelete(), update()`]
**Special Access Rules:** Field Service가 켜져 있어야 한다.

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| ContentVersionDocumentId | reference | Filter, Group, Nillable, Sort | ID of the service report version, used for storage. |
| DocumentBody | base64 | Create, Nillable | The report output. DocumentBody can't be retrieved via REST API. |
| DocumentContentType | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort | The type of data used for the report output.. [sic — 마침표 2개] 가능한 값은 아래 enum 참조. |
| DocumentLength | int | Filter, Group, Nillable, Sort | The length of the report output. |
| DocumentName | string | Create, Filter, Group, Nillable, Sort | The name of the report output, always set to Service Report. |
| DocumentTemplate | string | Create, Filter, Group, Nillable, Sort | Document Builder 기능용 서비스 문서를 생성하는 데 사용된 템플릿. Important 콜아웃 참조. |
| IsSigned | boolean | Create, Defaulted on create, Filter, Group, Sort | 서비스 리포트가 하나 이상의 서명을 포함하는지 여부. 이 필드는 Document Builder에서 지원되지 않음. Tip 참조. |
| ParentId | reference | Create, Filter, Group, Sort | 서비스 리포트가 요약하는 서비스 약속·작업지시·작업지시 라인 아이템의 ID. 예: 서비스 약속에서 Create Service Report를 클릭하면 이 필드에 그 서비스 약속의 레코드 ID가 표시된다. |
| ServiceReportLanguage | picklist | Create, Filter, Group, Nillable, Sort, Restricted picklist | 서비스 리포트에 사용된 언어. 연결된 작업지시의 ServiceReportLanguage 필드에서 선택된다. 작업지시가 서비스 리포트 언어를 지정하지 않으면, 리포트를 생성하는 사람의 Salesforce 기본 언어로 번역된다. |
| ServiceReportNumber | string | Autonumber, Defaulted on create, Filter, Sort | 서비스 리포트를 식별하는 자동 생성 번호. |
| Status | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | 서비스 리포트의 상태. API version 53.0 이상에서 사용 가능. 가능한 값은 아래 enum 참조. 기본값은 None. |
| Template | string | Create, Filter, Group, Nillable, Sort | 서비스 리포트를 생성하는 데 사용된 서비스 리포트 템플릿. Note 참조. |

**DocumentContentType enum (PDF 원문 8항목 — `text/calendar`가 두 번 등장 [sic]):**

```
// PDF 원문 picklist 값 — 순서·중복 그대로 보존
audio/ogg
text/calendar
video/3gpp2
video/3gpp
image/avif
text/calendar      [sic — 목록에 두 번째로 중복 등장]
audio/x-caf
image/webp
```

**Status enum (전수, 6값 — 기본값 None):**

```
Completed
Failed
Generating
In Progress
None
Queued
```

> **Important (DocumentTemplate 원문):** DocumentTemplate is different from Template. The document template needs to reference a flexipage that is of type serviceDocument and must target the object used to generate the service document. For example, you can't use an Account flexipage for a service report tied to a work order.

> **Tip (IsSigned 원문):** Add this field to the Service Reports related list on work orders, work order line items, and service appointments.

> **Note (Template 원문):** If the person creating the service report doesn't have access to certain objects or fields that are included in the service report template, those fields aren't visible in the report they create.

**Associated Objects:**
- `ServiceReportChangeEvent` — change events 사용 가능. API version 55.0 이상.
- `ServiceReportHistory` — 객체의 추적 필드에 대한 히스토리 사용 가능.

---

## 2. ServiceReportLayout

Field Service에서 **서비스 리포트 템플릿(service report template)**을 나타낸다.

**Supported Calls:** `describeSObjects()`, `query()`, `retrieve()`
**Special Access Rules:** Field Service가 켜져 있어야 한다. Field Service Standard user permission이 있는 모든 사용자가 API를 통해 ServiceReportLayout 객체를 볼 수 있다.

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| DeveloperName | string | Filter, Group, Sort | 서비스 리포트 템플릿의 developer name. Note 참조. |
| Language | picklist | Filter, Group, Restricted picklist, Sort | 서비스 리포트 템플릿이 사용하는 언어. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | 서비스 리포트 템플릿이 마지막으로 view된 날짜. |
| MasterLabel | string | Filter, Group, Sort | 서비스 리포트 템플릿의 이름. 예: Maintenance Report Template. |
| TemplateType | picklist | Defaulted on create, Filter, Group, Restricted picklist, Sort | 서비스 리포트 템플릿의 유형. API version 46.0 이상에서 사용 가능. 가능한 값은 아래 enum 참조. 기본값은 ServiceReport. |

**TemplateType enum (전수, 2값 — 기본값 ServiceReport):**

```
DigitalForm
ServiceReport
```

> **Note (DeveloperName 원문):** Only users with View DeveloperName OR View Setup and Configuration permission can view, group, sort, and filter this field.

**Associated Objects:**
- `ServiceReportLayoutChangeEvent` — change events 사용 가능. API version 55.0 이상.

---

## 3. DigitalSignature

Field Service에서 서비스 리포트 위에 캡처된 **서명(signature)**을 나타낸다.

**Supported Calls:** `create()`, `delete()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `undelete()`
**Special Access Rules:** Field Service가 켜져 있어야 한다.

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| DigitalSignatureNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | An auto-generated number identifying the signature. |
| DocumentBody | base64 | Create | The captured signature image. |
| DocumentContentType | picklist | Create, Filter, Group, Restricted picklist, Sort | 캡처된 서명의 데이터 타입. 가능한 값은 아래 enum 참조. |
| DocumentLength | int | Filter, Group, Nillable, Sort | The length of the captured signature. |
| DocumentName | string | Create, Filter, Group, Sort | The name of the captured signature image. |
| ParentId | reference | Create, Filter, Group, Sort | 서비스 리포트가 생성된 대상인 서비스 약속·작업지시·작업지시 라인 아이템의 ID. polymorphic 관계 필드. RelName: Parent; RelType: Lookup; Refers To: AuthorizationFormConsent, Order, ServiceAppointment, WorkOrder, WorkOrderLineItem. |
| Place | string | Create, Filter, Group, Nillable, Sort | The place where the report was signed. |
| SignatureType | picklist | Create, Defaulted on create, Filter, Group, Nillable, Sort | 서비스 리포트에 서명하는 사람의 역할. 자세한 내용은 아래 SignatureType 상세 참조. |
| SignedBy | string | Create, Filter, Group, Nillable, Sort | The name of the person signing. |
| SignedDate | dateTime | Create, Filter, Nillable, Sort | The date and time of the signing. |

**DocumentContentType enum (전수, 9값 — 순서 원문 그대로):**

```
// PDF 원문 picklist 값 — 순서 그대로 보존
audio/acc      [sic — 표준 MIME은 audio/aac이나 PDF 원문이 audio/acc]
audio/amr
audio/ogg
video/3gpp2
video/3gpp
image/avif
text/calendar
audio/x-caf
image/webp
```

> **SignatureType 상세 (원문):** The role of the person signing the service report. Your org comes with one signature type, Default. A service report template can only contain one signature per type. If you plan to collect multiple signatures on service reports, create additional values for the Signature Type field. Create at least one value for every role that might need to sign a service report. For example, Technician, Customer, Supervisor, or Supplier. If some service reports will be signed by multiple people in one role—for example, all technicians present at an appointment—create numbered types: Technician 1, Technician 2, and so forth.
>
> **Note (원문):** You can create up to 1,000 signature types. You can't delete signature types, but you can deactivate them so they can't be used in service report templates. When you deactivate a type, it still appears on service report templates that used it, but you can't use it on new service report templates.

**Usage:** 서비스 리포트 템플릿에 서명 블록(signature block)을 추가해 그 템플릿을 사용하는 리포트에서 어떤 서명을 수집해야 하는지 결정한다. 서비스 리포트 템플릿은 **최대 20개의 서명**을 포함할 수 있고, 각 서명은 **서로 다른 Signature Type**을 사용해야 한다. 예: 고객 서명과 기술자 서명을 포함하는 표준 서비스 리포트 템플릿을 만든다. 디지털 서명에 대한 자세한 내용은 Guidelines for Using Signatures on Service Reports 참조.

**Associated Objects:**
- `DigitalSignatureChangeEvent` (API version 57.0에서 사용 가능) — 객체의 change events 사용 가능.

---

## 관련 노트

- [[Field Service 개요와 데이터 모델]] — Service Report 클러스터가 데이터 모델상 어디에 위치하는지, WO/WOLI/약속과의 관계
- [[Field Service Objects]] — FSL 표준 객체(ServiceAppointment·WorkOrder 등) 색인
- [[Field Service REST API]] — Service Report Template REST 리소스(서비스 리포트 템플릿을 REST로 조회/생성)와 연계
- [[객체 레퍼런스 — Work Order·WorkOrderLineItem·Status]] — ServiceReport.ParentId·DigitalSignature.ParentId가 참조하는 WorkOrder·WorkOrderLineItem 도메인
- [[객체 레퍼런스 — WorkPlan·WorkStep·WorkType]] — WorkType.ServiceReportTemplateId가 이 노트의 서비스 리포트 템플릿을 참조
