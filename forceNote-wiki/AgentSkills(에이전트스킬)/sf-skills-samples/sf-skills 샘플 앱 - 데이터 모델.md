---
tags: [agent-skill, sf-skills, samples, data-model, custom-object, schema]
source: forcedotcom/sf-skills (samples/.../objects/, 공식 Salesforce)
created: 2026-06-27
aliases: [샘플 앱 데이터 모델, Property__c, Tenant__c, Lease__c, Maintenance_Request__c, 부동산 임대 스키마, custom object 모델]
---

# sf-skills 샘플 앱 — 데이터 모델

> forcedotcom/sf-skills 의 `samples/` 템플릿 앱들이 공유하는 **부동산 임대·매매(property rental & sales) 도메인 스키마** — 17개 커스텀 객체와 127개 커스텀 필드로 구성된다. `Property__c`를 허브로 임대(Lease·Tenant·Payment), 매물(Listing·Image·Feature), 유지보수(Maintenance Request·Worker), 비용·매매·지원서·알림이 매달린다.

> 출처 경로: `samples/ui-bundle-template-app-react-sample-b2e/force-app/main/default/objects/` (여러 샘플 앱이 공유하는 canonical 사본). 모든 객체는 `deploymentStatus=Deployed`, `sharingModel` 기본값의 표준 커스텀 객체이며 별도 표기 없으면 필드는 `required=false`.

---

## 객체 개요

17개 커스텀 객체 전체. **Name 필드 유형**은 레코드 이름 필드(AutoNumber면 자동 채번, Text면 사용자 입력)를 의미한다.

| 객체 (API) | Label | Name 필드 | 필드 수 | 용도 |
|---|---|---|---|---|
| `Property__c` | Property | Text (Property Name) | 20 | 핵심 허브 — 부동산 매물/임대 단위 |
| `Tenant__c` | Tenant | AutoNumber (Tenant Number) | 6 | 임차인/사용자 — User 연결, 임대 생애주기 상태 |
| `Lease__c` | Lease | AutoNumber (Lease Number) | 7 | 임대 계약 — Property(master)·Tenant 연결 |
| `Payment__c` | Payment | AutoNumber (Payment Number) | 6 | 임대료 등 결제 — Lease(master) |
| `Application__c` | Application | AutoNumber (Application Number) | 6 | 임대 지원서 — Property·User 연결 |
| `Agent__c` | Agent | Text (Agent Name) | 8 | 부동산 에이전트 |
| `Maintenance_Request__c` | Maintenance Request | AutoNumber (Request Number) | 12 | 유지보수 요청 |
| `Maintenance_Worker__c` | Maintenance Worker | Text (Worker Name) | 8 | 유지보수 작업자/벤더 |
| `Property_Listing__c` | Property Listing | Text (Listing Title) | 7 | 매물 게시(마케팅 리스팅) |
| `Property_Image__c` | Property Image | Text (Image Name) | 5 | 매물 이미지 |
| `Property_Feature__c` | Property Feature | Text (Feature Name) | 4 | 매물 특징(편의시설 등) |
| `Property_Cost__c` | Property Cost | AutoNumber (Cost Number) | 6 | 부동산 운영 비용 |
| `Property_Sale__c` | Property Sale | AutoNumber (Sale Number) | 8 | 부동산 매매 거래 |
| `Property_Owner__c` | Property Owner | Text (Owner Name) | 3 | 부동산 소유주(독립 객체, 관계 없음) |
| `Property_Management_Company__c` | Property Management Company | Text (Company Name) | 5 | 관리 회사 |
| `Notification__c` | Notification | AutoNumber (Notification Number) | 8 | 사용자 알림 |
| `KPI_Snapshot__c` | KPI Snapshot | Text (Snapshot Name) | 8 | 대시보드용 월간 KPI 스냅샷 |

---

## 객체별 필드

관계 필드는 `→ 대상객체 (관계종류)` 형식. 관계종류: **M-D** = Master-Detail, **Lookup** = Lookup. 화살표 없는 필드는 일반 데이터 필드.

### Property__c (허브, 20필드)

| 필드 | 타입 | 핵심 속성 |
|---|---|---|
| `Agent__c` | Lookup | → Agent__c (관계명 Properties) |
| `Address__c` | Text | length 255 |
| `Type__c` | Picklist | Apartment / Single Family / Condo / Commercial |
| `Status__c` | Picklist | Available / Rented / Maintenance / Under Renovation |
| `Bedrooms__c` | Number | precision 2, scale 1 |
| `Bathrooms__c` | Number | precision 2, scale 1 |
| `Sq_Ft__c` | Number | precision 10, scale 0 |
| `Parking__c` | Number | precision 2, scale 0 |
| `Year_Built__c` | Number | precision 4, scale 0 |
| `Lease_Term__c` | Number | precision 3, scale 0 (개월) |
| `Monthly_Rent__c` | Currency | precision 10, scale 2 |
| `Deposit__c` | Currency | precision 10, scale 2 |
| `Available_Date__c` | Date | |
| `Pet_Friendly__c` | Checkbox | default false |
| `Features__c` | MultiselectPicklist | Balcony / In-unit Laundry / AC / Hardwood Floors |
| `Utilities__c` | MultiselectPicklist | Water / Electricity / Internet / Gas |
| `Coordinates__c` | Location | scale 6 (위경도) |
| `Hero_Image__c` | Url | |
| `Tour_URL__c` | Url | |
| `Description__c` | LongTextArea | length 32768 |

### Tenant__c (6필드)

| 필드 | 타입 | 핵심 속성 |
|---|---|---|
| `User__c` | Lookup | → User (관계명 Tenants) |
| `Property__c` | Lookup | → Property__c (관계명 Tenants) |
| `Status__c` | Picklist | Active / Expired / Terminated / Eviction Pending |
| `User_Status__c` | Picklist | Viewer / Applicant / Tenant / FormerTenant / Unknown |
| `Start_Date__c` | Date | |
| `End_Date__c` | Date | |

### Lease__c (7필드)

| 필드 | 타입 | 핵심 속성 |
|---|---|---|
| `Property__c` | **M-D** | → Property__c (관계명 Leases, reparentable=false) |
| `Tenant__c` | Lookup | → Tenant__c (관계명 Leases) |
| `Lease_Status__c` | Picklist | **required** · Active / Pending / Terminated / Expired |
| `Start_Date__c` | Date | **required** |
| `End_Date__c` | Date | **required** |
| `Monthly_Rent__c` | Currency | **required** · precision 18, scale 2 |
| `Security_Deposit__c` | Currency | precision 18, scale 2 |

### Payment__c (6필드)

| 필드 | 타입 | 핵심 속성 |
|---|---|---|
| `Lease__c` | **M-D** | → Lease__c (관계명 Payments) |
| `Amount__c` | Currency | **required** · precision 18, scale 2 |
| `Payment_Date__c` | Date | **required** |
| `Payment_Method__c` | Picklist | **required** · Cash / Check / Credit Card / Bank Transfer / Online Payment |
| `Payment_Status__c` | Picklist | **required** · Pending / Completed / Failed / Refunded |
| `Notes__c` | LongTextArea | length 32768 |

### Application__c (6필드)

| 필드 | 타입 | 핵심 속성 |
|---|---|---|
| `Property__c` | Lookup | → Property__c (관계명 Applications) |
| `User__c` | Lookup | → User (관계명 Applications) |
| `Status__c` | Picklist | Draft / Submitted / Background Check / Under Review / Approved / Rejected |
| `Start_Date__c` | Date | (희망 입주일) |
| `Employment__c` | LongTextArea | length 32768 |
| `References__c` | LongTextArea | length 32768 |

### Agent__c (8필드)

| 필드 | 타입 | 핵심 속성 |
|---|---|---|
| `Agent_Type__c` | Picklist | Residential / Commercial / Industrial / Short-term |
| `Availability__c` | Picklist | On-Duty / Off-Duty / On Vacation / On-Call |
| `Language__c` | Picklist | English / Spanish / French / Mandarin / Other |
| `Office_Location__c` | Picklist | Main Office / Downtown Branch / North Branch / South Branch / Remote |
| `Territory__c` | Picklist | Downtown / North District / South District / East District / West District |
| `License_Number__c` | Text | length 50, **unique** |
| `License_Expiry__c` | Date | |
| `Emergency_Alt__c` | Phone | |

### Maintenance_Request__c (12필드)

| 필드 | 타입 | 핵심 속성 |
|---|---|---|
| `Property__c` | Lookup | → Property__c (관계명 Maintenance_Requests) |
| `Assigned_Worker__c` | Lookup | → Maintenance_Worker__c (관계명 Maintenance_Requests) |
| `User__c` | Lookup | → **Tenant__c** (관계명 Maintenance_Requests) — 필드명은 User지만 Tenant 참조 |
| `Type__c` | Picklist | Plumbing / Electrical / HVAC / Appliance / Carpentry / Landscaping / Cleaning / Pest / Other |
| `Priority__c` | Picklist | Emergency / High / Standard |
| `Status__c` | Picklist | New / Assigned / In Progress / On Hold / Resolved |
| `Description__c` | LongTextArea | length 32768 |
| `Tenant_Home__c` | Checkbox | default false |
| `Est_Cost__c` | Currency | precision 10, scale 2 |
| `Actual_Cost__c` | Currency | precision 10, scale 2 |
| `Scheduled__c` | DateTime | |
| `Completed__c` | DateTime | |

### Maintenance_Worker__c (8필드)

| 필드 | 타입 | 핵심 속성 |
|---|---|---|
| `Type__c` | Picklist | Plumbing / Electrical / Landscaping / Grounds / HVAC (Heating & Cooling) / General Carpentry / Appliance Repair / Janitorial / Cleaning / Pest Control |
| `Employment_Type__c` | Picklist | Internal Employee / Contractor / Third-Party Vendor |
| `Hourly_Rate__c` | Currency | precision 8, scale 2 |
| `Rating__c` | Number | precision 2, scale 1 |
| `IsActive__c` | Checkbox | default true |
| `Location__c` | Text | length 255 |
| `Phone__c` | Phone | |
| `Certifications__c` | LongTextArea | length 32768 |

### Property_Listing__c (7필드)

| 필드 | 타입 | 핵심 속성 |
|---|---|---|
| `Property__c` | **M-D** | → Property__c (관계명 Property_Listings) |
| `Listing_Status__c` | Picklist | **required** · Active / Pending / Sold / Withdrawn / Draft |
| `Listing_Price__c` | Currency | **required** · precision 18, scale 0 |
| `Featured__c` | Checkbox | default false |
| `Display_Order__c` | Number | precision 3, scale 0 |
| `Short_Description__c` | Text | length 255 |
| `Marketing_Description__c` | LongTextArea | length 32768 |

### Property_Image__c (5필드)

| 필드 | 타입 | 핵심 속성 |
|---|---|---|
| `Property__c` | **M-D** | → Property__c (관계명 Property_Images) |
| `Image_URL__c` | Url | **required** |
| `Image_Type__c` | Picklist | **required** · Primary / Gallery / Floor Plan / Aerial / Virtual Tour |
| `Display_Order__c` | Number | precision 3, scale 0 |
| `Alt_Text__c` | Text | length 255 |

### Property_Feature__c (4필드)

| 필드 | 타입 | 핵심 속성 |
|---|---|---|
| `Property__c` | **M-D** | → Property__c (관계명 Property_Features) |
| `Feature_Category__c` | Picklist | **required** · Interior / Exterior / Amenities / Appliances / Safety and Security / Energy and Utilities / Location |
| `Display_on_Listing__c` | Checkbox | default true |
| `Description__c` | LongTextArea | length 1000 |

### Property_Cost__c (6필드)

| 필드 | 타입 | 핵심 속성 |
|---|---|---|
| `Property__c` | **M-D** | → Property__c (관계명 Property_Costs) |
| `Cost_Category__c` | Picklist | **required** · Maintenance / Repair / Taxes / Saving / Insurance / Utilities / Legal / Other |
| `Cost_Amount__c` | Currency | **required** · precision 18, scale 2 |
| `Cost_Date__c` | Date | **required** · default `TODAY()` |
| `Vendor__c` | Text | length 255 |
| `Description__c` | LongTextArea | length 32768 |

### Property_Sale__c (8필드)

| 필드 | 타입 | 핵심 속성 |
|---|---|---|
| `Property__c` | **M-D** | → Property__c (관계명 Property_Sales) |
| `Buyer_Tenant__c` | Lookup | → Tenant__c (관계명 Property_Sales) |
| `Sale_Type__c` | Picklist | **required** · Rental Payment / Property Sale / Security Deposit / Application Fee / Late Fee / Maintenance Fee / Other |
| `Sale_Status__c` | Picklist | **required** · Pending / Completed / Failed / Refunded |
| `Sale_Amount__c` | Currency | **required** · precision 18, scale 2 |
| `Sale_Date__c` | DateTime | **required** |
| `Payment_Method__c` | Picklist | Cash / Check / Credit Card / Bank Transfer / Online Payment |
| `Reference_Number__c` | Text | length 50 |

### Property_Owner__c (3필드, 독립 객체)

| 필드 | 타입 | 핵심 속성 |
|---|---|---|
| `Email__c` | Email | **required**, **unique** |
| `Phone__c` | Phone | |
| `Address__c` | TextArea | |

> Property_Owner__c는 다른 객체로의 관계 필드가 없다 — Property__c와 직접 연결되지 않는 독립 참조 객체.

### Property_Management_Company__c (5필드)

| 필드 | 타입 | 핵심 속성 |
|---|---|---|
| `Primary_Contact__c` | Lookup | → Contact (관계명 Managed_Companies) |
| `Company_Code__c` | Text | length 10, **required**, **unique**, **External ID** |
| `Email__c` | Email | |
| `Phone__c` | Phone | |
| `Active__c` | Checkbox | default true |

### Notification__c (8필드)

| 필드 | 타입 | 핵심 속성 |
|---|---|---|
| `User__c` | Lookup | → User (관계명 Notifications) |
| `Type__c` | Picklist | Application / Maintenance_Request / System / Worker_Assignment |
| `Priority__c` | Picklist | Low / Normal / High / Urgent |
| `Title__c` | Text | length 80 |
| `Message__c` | LongTextArea | length 32768 |
| `Related_Object_Type__c` | Text | length 50 (다형성 참조용 sObject 타입명) |
| `Related_Record_Id__c` | Text | length 18 (다형성 참조용 레코드 ID) |
| `Is_Read__c` | Checkbox | default false |

> `Related_Object_Type__c` + `Related_Record_Id__c` 조합은 표준 polymorphic lookup 대신 **문자열 기반 다형성 참조** 패턴(어떤 레코드든 가리킬 수 있게 타입명·ID를 텍스트로 저장).

### KPI_Snapshot__c (8필드)

| 필드 | 타입 | 핵심 속성 |
|---|---|---|
| `Snapshot_Date__c` | Date | **required** |
| `Total_Properties__c` | Number | **required** · precision 5, scale 0 |
| `Total_Sales_Count__c` | Number | **required** · precision 6, scale 0 |
| `Total_Sales_Amount__c` | Currency | **required** · precision 18, scale 2 |
| `Previous_Month_Sales__c` | Currency | precision 18, scale 2 |
| `Sales_MoM_Change__c` | Percent (formula) | precision 18, scale 4 · 전월 대비 매출 증감률 |
| `Units_Available__c` | Number | precision 6, scale 0 |
| `Units_Occupied__c` | Number | precision 6, scale 0 |

`Sales_MoM_Change__c`는 유일한 formula 필드다. 원본 정의:

```xml
<!-- KPI_Snapshot__c/fields/Sales_MoM_Change__c.field-meta.xml (원본 발췌) -->
<formula>IF(
  ISNULL(Previous_Month_Sales__c) || Previous_Month_Sales__c = 0,
  0,
  (Total_Sales_Amount__c - Previous_Month_Sales__c) / Previous_Month_Sales__c
)</formula>
<formulaTreatBlanksAs>BlankAsZero</formulaTreatBlanksAs>
```

---

## 관계 요약

`Property__c`가 중심 허브이며, 자식 객체들이 **Master-Detail** 또는 **Lookup**으로 매달린다.

```
// 구조 예시 — 실제 원본 다이어그램 아님 (위 객체별 referenceTo/type 에서 도출)

                        User (표준)        Contact (표준)
                          ▲                    ▲
                          │ Lookup             │ Lookup
   Agent__c ◀──Lookup── Property__c        Property_Management_Company__c
                          ▲  ▲  ▲  ▲  ▲  ▲
        ┌─────────────────┘  │  │  │  │  └──────────────┐
        │ M-D                │  │  │  │ Lookup           │ M-D
   Property_Listing__c       │  │  │  └ Application__c   Property_Sale__c
   Property_Image__c (M-D)   │  │  │    (Lookup→User)      │ Lookup
   Property_Feature__c (M-D) │  │  └ Maintenance_Request__c → Buyer_Tenant__c
   Property_Cost__c (M-D)    │  │      ├ Lookup → Property__c
                             │  │      ├ Lookup → Maintenance_Worker__c
              Tenant__c ─────┘  │      └ User__c Lookup → Tenant__c
              │ Lookup→Property  │
              │ Lookup→User      └─ Lease__c ──M-D──▶ Property__c
              │                       │ Lookup → Tenant__c
              │                       └◀─M-D── Payment__c
```

핵심 경로:
- **임대 라인**: `Payment__c` ─M-D→ `Lease__c` ─M-D→ `Property__c`; `Lease__c` ─Lookup→ `Tenant__c` ─Lookup→ `User`. 즉 결제는 임대의 종속 레코드, 임대는 매물의 종속 레코드(roll-up/cascade delete 적용).
- **매물 콘텐츠 라인**: `Property_Listing__c`·`Property_Image__c`·`Property_Feature__c`·`Property_Cost__c`·`Property_Sale__c` 가 모두 `Property__c`에 **Master-Detail**로 종속.
- **유지보수 라인**: `Maintenance_Request__c` 가 `Property__c`·`Maintenance_Worker__c`·`Tenant__c`(필드명 `User__c`) 세 객체를 Lookup으로 참조.
- **지원/매매**: `Application__c`(Property·User Lookup), `Property_Sale__c`(Property M-D, Buyer는 Tenant Lookup).
- **표준 객체 연결**: `User`(Tenant·Application·Notification), `Contact`(Property_Management_Company).
- **독립 객체**: `Property_Owner__c`(관계 없음), `KPI_Snapshot__c`(관계 없음 — 집계 스냅샷), `Property_Management_Company__c`(Contact만 참조, Property 미연결).

| 부모 | 자식 | 관계 유형 | 자식 필드 |
|---|---|---|---|
| Property__c | Lease__c | Master-Detail | Property__c |
| Property__c | Property_Listing__c | Master-Detail | Property__c |
| Property__c | Property_Image__c | Master-Detail | Property__c |
| Property__c | Property_Feature__c | Master-Detail | Property__c |
| Property__c | Property_Cost__c | Master-Detail | Property__c |
| Property__c | Property_Sale__c | Master-Detail | Property__c |
| Property__c | Application__c | Lookup | Property__c |
| Property__c | Maintenance_Request__c | Lookup | Property__c |
| Property__c | Tenant__c | Lookup | Property__c |
| Lease__c | Payment__c | Master-Detail | Lease__c |
| Tenant__c | Lease__c | Lookup | Tenant__c |
| Tenant__c | Maintenance_Request__c | Lookup | User__c |
| Tenant__c | Property_Sale__c | Lookup | Buyer_Tenant__c |
| Agent__c | Property__c | Lookup | Agent__c |
| Maintenance_Worker__c | Maintenance_Request__c | Lookup | Assigned_Worker__c |
| User (표준) | Tenant__c / Application__c / Notification__c | Lookup | User__c |
| Contact (표준) | Property_Management_Company__c | Lookup | Primary_Contact__c |

---

## 관련 노트
- [[sf-skills 샘플 앱 - 개요]]
- [[sf-skills 샘플 앱 - Apex 패턴]]
