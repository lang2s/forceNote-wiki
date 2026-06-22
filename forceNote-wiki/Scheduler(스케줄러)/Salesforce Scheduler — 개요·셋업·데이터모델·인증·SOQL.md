---
tags: [scheduler, salesforce-scheduler, lightning-scheduler, appointment-booking, overview, soql-tolabel]
source: salesforce_scheduler_dev_guide.pdf (Salesforce Scheduler Developer Guide, v67.0 Summer '26)
created: 2026-06-22
aliases: [Salesforce Scheduler, Lightning Scheduler, Scheduler 셋업, toLabel SOQL, Scheduler 인증, 예약 데이터모델]
---

# Salesforce Scheduler — 개요·셋업·데이터모델·인증·SOQL

> Salesforce Scheduler(구 Lightning Scheduler)의 개발자 진입점 — 개요·셋업 선행작업·데이터 모델 구성·API 인증(OAuth)·SOQL 결과 번역(toLabel)을 다룬다.

---

## 1. Introduction — Salesforce Scheduler란

Salesforce Scheduler(구 **Lightning Scheduler**)는 Salesforce에서 예약(appointment) 스케줄링을 단순화하는 도구와 개발자 리소스를 제공한다. 적절한 사람을 적절한 장소·시간에 매칭해 대면(in person), 전화(phone), 화상(video)으로 고객 예약을 잡는 개인화된 경험을 만들 수 있다.

예약 스케줄링에는 **참석자(appointment attendees), 장소(locations), 주제(topics), 시간(timings), 소요시간(duration)** 등 여러 리소스가 관여하며, Salesforce Scheduler는 이 리소스들을 관리하는 도구를 제공한다.

### 개발자 리소스 4종

Salesforce Scheduler로 매끄러운 예약 스케줄링 애플리케이션을 쉽게 구축할 수 있게 해 주는 개발자 리소스는 다음과 같다.

- **REST APIs**
- **Connect REST APIs**
- **Salesforce Platform Events**
- **Apex 클래스**

### Scheduler 구성 — 사용 전 설정할 항목 (5단계)

Scheduler 리소스를 사용하기 전에 다음 항목으로 Scheduler를 구성해야 한다.

- **Service resources 생성** — 예약 참석자(appointment attendees)를 나타내며, 전문 분야(skills), 위치(location), 가용성(availability)에 대한 세부 정보를 추가한다.
- **Service territories 설정** — 예약 참석자가 근무하거나 고객을 만나는 지점/사무실 위치(branch or office locations)를 나타낸다.
- **Work type groups 생성** — home loan(주택 담보 대출), investment(투자) 같은 예약 주제(appointment topics)를 나타낸다.
- **Work types 생성** — 예약 주제를 특정 위치와 연결하고, 예약 소요시간(duration), 준비·마무리 버퍼(preparation and wrap-up buffers), 가용성 타이밍(availability timings) 같은 핵심 파라미터를 정의하는 예약 템플릿(appointment templates)을 나타낸다.
- **Schedule customer appointments** — 정의된 주제, 참석자, 소요시간, 위치로 고객 예약을 스케줄링한다.

---

## 2. Set Up Salesforce Scheduler — 셋업 선행작업

조직에 Salesforce Scheduler를 설정한다. 사용자에게 권한과 객체 접근 권한을 할당하고, 관련 목록(related lists)과 탭 가시성(tab visibility)을 갱신하며, multi-resource 스케줄링·concurrent 스케줄링·다중 시간대 선택(multiple time zone selection)·지도 및 위치 서비스(map and location services)를 위한 Salesforce Scheduler 설정을 구성한다. 선택적으로 Salesforce Scheduler용 **Asset Scheduling**을 설정한다.

스케줄러 개발자 리소스를 사용하기 전에 Salesforce Scheduler를 셋업해야 한다. 해야 할 일 중 일부는 다음과 같다.

- 사용자에게 **권한과 객체 접근 권한(permissions and object access)** 할당.
- **multi-resource 스케줄링, concurrent 스케줄링, 다중 시간대 선택, 지도 및 위치 서비스**를 위한 Salesforce Scheduler 설정 구성.
- **service resources, service territory members, work type groups, work types, time slots, work type group members, service territory work types** 구성.
- Salesforce Scheduler용 **Asset Scheduling** 설정.
- **operating hours**(운영 시간), **employee attendees**(service resources), **location**(service territories), **skills**, **appointment templates**(work types)를 나타내는 레코드 생성·관리.

---

## 3. Data Model Overview — 데이터 모델 개요

Salesforce Scheduler 데이터 모델 내의 **객체와 관계**를 학습한다. 이 모델은 예약(appointments)과, 예약에 참석하도록 스케줄링될 수 있는 직원(employees)을 나타낸다.

> **Note:** Not all fields are specified in this data model. (이 데이터 모델에 모든 필드가 명시되어 있지는 않다.)

Salesforce Scheduler 데이터 모델은 Salesforce Developer 문서에서 확인할 수 있다.

> **PDF에 ERD 다이어그램 있음 — 본 wiki에는 텍스트 설명만.** 원본 가이드 p.11에 데이터 모델 ERD(Entity-Relationship Diagram) 이미지가 있으나 pdftotext로 추출되지 않았다. 엔티티/관계 다이어그램은 fabricate하지 않는다. 개별 표준 객체(엔티티)의 필드·관계는 Chapter 4 "Salesforce Scheduler Standard Objects"(별도 노트 — 표준 객체 참조)를 참조한다.

---

## 4. Authenticate APIs — API 인증 (OAuth)

API 기반 통합의 **첫 단계**는 OAuth를 사용해 Salesforce에 연결하고 **access token**을 얻는 것이다. OAuth access token 인증은 **SOAP 및 REST API 호출을 인증하는 가장 안전한 방법**이다.

> **Note:** Salesforce Scheduler API를 사용해 **prospects 또는 인증되지 않은 사용자(unauthenticated users)**를 위한 커스텀 예약 스케줄링 애플리케이션을 구축하려면, **로그인된 사용자(logged-in user)**를 사용해 구축해야 한다. 예를 들어 integration user 또는 administrator.

### API Enabled 권한

**Developer Edition, Enterprise Edition, 또는 그 이상**을 가진 Salesforce 조직에서 작업하는 경우, **API Enabled** 권한이 있는지 확인한다. 이 권한은 **기본적으로 활성화(enabled by default)**되어 있다. 이 권한은 모든 Salesforce API에 접근할 수 있게 해 준다.

이 권한이 있으면 Salesforce에 연결해 인증할 수 있다. 그런 다음 REST 또는 Connect API에 요청을 보내고 응답을 확인한다. 자세한 내용은 Connect REST API Quick Start를 참조한다.

---

## 5. Translate SOQL Query Results — toLabel로 SOQL 결과 번역

쿼리를 제출한 사용자의 언어로 SOQL 쿼리 결과를 번역하려면 **`toLabel` 메서드**를 사용한다. 번역이 없으면 메서드는 조직의 기본 언어(default language)로 검색 결과를 반환한다.

**모든 조직**이 `toLabel()` 메서드를 사용할 수 있다. 데이터 번역(data translation)을 활성화한 조직에 유용하다. 데이터 번역 활성화 방법은 Salesforce Scheduler Help의 "Manage Entities' Data Translation"을 참조한다.

### 구문 (syntax)

```sql
toLabel(object.field)
```

### 지원 객체 및 필드

이 메서드는 **WorkTypeGroup, ServiceResource, ServiceTerritory** 객체에서 지원된다. 다음 필드에서 번역된 검색 결과를 반환하는 데 사용한다.

- **Name**
- **Description**
- **커스텀 필드** — 타입이 **Text, MultiLine Text, Long Text Area, Rich Text Area, URL**인 커스텀 필드

### 제한

- `ORDER BY` 절에서는 `toLabel()` 메서드를 **사용할 수 없다.** 번역에 적용되는 제한은 SOQL and SOSL Reference의 "Translate Returned SOQL Results"를 참조한다.

### Sample Request

WorkTypeGroup 데이터 번역 요청 예시:

```
https://yourInstance.salesforce.com/services/data/vXX.X/
query/?q=SELECT+toLabel(Name),+toLabel(Description),+toLabel(Details__c),+toLabel(Disclaimer__c)+From+WorkTypeGroup
```

ServiceResource 데이터 번역 요청 예시:

```
https://yourInstance.salesforce.com/services/data/vXX.X/
query/?q=SELECT+toLabel(Name),+toLabel(Description),+toLabel(Profile_URL__c)+From+ServiceResource
```

ServiceTerritory 데이터 번역 요청 예시:

```
https://yourInstance.salesforce.com/services/data/vXX.X/
query/?q=SELECT+toLabel(Name),+toLabel(Description),+toLabel(Notes__c)+From+ServiceTerritory
```

### Sample Response

> 아래 JSON은 원본 가이드에서 verbatim 발췌한 응답이다. WorkTypeGroup 첫 레코드의 `Name`·`Description`·`Disclaimer__c` 값은 원문에서 비ASCII 글자였으나 pdftotext가 글리프를 추출하지 못해 빈 칸(공백)으로 보존됐다. ServiceResource(키릴 "Адам Смит" 등)·ServiceTerritory(프랑스어 "l'apollon" 등)의 비ASCII 값은 정상 추출됐다.

WorkTypeGroup 번역 쿼리 결과 예시:

```json
{
"totalSize": 6,
"done": true,
"records": [
{
"attributes": {
"type": "WorkTypeGroup",
"url":
"/services/data/v54.0/sobjects/WorkTypeGroup/0VSx00000000ZTDGA2"
},
"Name": " ",
"Description": " ",
"Details__c": "<ul><li><b><i><u>
</u></i></b><span
style=\"color: rgb(0, 0, 0);\"></span></li></ul>",
"Disclaimer__c": " "
},
{
"attributes": {
"type": "WorkTypeGroup",
"url":
"/services/data/v54.0/sobjects/WorkTypeGroup/0VSx00000000ZTAGA2"
},
"Name": "WTG 3",
"Description": null,
"Details__c": null,
"Disclaimer__c": null
}
]
}
```

ServiceResource 번역 쿼리 결과 예시:

```json
{
"totalSize": 2,
"done": true,
"records": [
{
"attributes": {
"type": "ServiceResource",
"url":
"/services/data/v54.0/sobjects/ServiceResource/0Hnx000000003I6CAI"
},
"Name": "Адам Смит",
"Description": "описание",
"Profile_URL__c": "http:// профиль"
},
{
"attributes": {
"type": "ServiceResource",
"url":
"/services/data/v54.0/sobjects/ServiceResource/0Hnx000000003I9CAI"
},
"Name": "Stacy Simon",
"Description": null,
"Profile_URL__c": null
}
]
}
```

ServiceTerritory 번역 쿼리 결과 예시:

```json
{
"totalSize": 2,
"done": true,
"records": [
{
"attributes": {
"type": "ServiceTerritory",
"url":
"/services/data/v54.0/sobjects/ServiceTerritory/0Hhx00000000c9tCAA"
},
"Name": "l'apollon",
"Description": "à la mode",
"Notes__c": "française"
},
{
"attributes": {
"type": "ServiceTerritory",
"url":
"/services/data/v54.0/sobjects/ServiceTerritory/0Hhx00000000cgaCAA"
},
"Name": "tempST",
"Description": null,
"Notes__c": null
}
]
}
```

---

## 관련 노트

이 노트는 Salesforce Scheduler 개발자 가이드의 개요·셋업·데이터 모델·인증·SOQL 부분만 다룬다. 표준 객체별 필드 상세, Business API(REST·Connect), Apex 네임스페이스는 형제 노트에서 다룬다.

- [[Salesforce Scheduler 표준객체 — 핵심 예약]] — ServiceAppointment·AssignedResource·Waitlist 등 예약 흐름 표준객체 (Chapter 4).
- [[Salesforce Scheduler 표준객체 — 리소스·영역·스킬·시프트]] — ServiceResource·ServiceTerritory·Skill·Shift.
- [[Salesforce Scheduler 표준객체 — 정책·운영시간·작업유형]] — AppointmentSchedulingPolicy·OperatingHours·WorkType.
- [[Salesforce Scheduler 표준객체 — 초대·집계·로그]] — AppointmentInvitation·AppointmentInvitee 등.
- [[Salesforce Scheduler 커스텀객체]] — WorkTypeGroupMember·EngagementChannelType 등 junction 객체.
- [[Salesforce Scheduler — Business REST·Connect 엔드포인트]] — Business APIs(REST·Connect) 엔드포인트 (Chapter 10).
- [[Salesforce Scheduler — Connect API 요청·응답 표현형·Error Codes]] — 요청/응답 표현형·Error Codes.
- [[Salesforce Scheduler — ConnectApi LightningScheduler Apex]] — ConnectApi LightningScheduler Apex 메서드.
- [[Salesforce Scheduler — Platform Events·Metadata API Types]] — Platform Events·Metadata API Types.
- [[LxScheduler Namespace]] — Salesforce Scheduler의 Apex 네임스페이스(예약 후보 리소스/슬롯 조회, 외부 캘린더 연동).
