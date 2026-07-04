---
tags: [field-service, fsl, 현장서비스, data-model, work-order, service-appointment, inventory, preventive-maintenance, warranty, pricing, er-diagram]
source: field_service_dev.pdf (Field Service Developer Guide v67.0 Summer '26) · Trailhead "Install the Field Service Managed Package" (Tier 2) · Salesforce Help pfs_install.htm (Tier 2)
created: 2026-06-23
aliases: [Field Service, FSL, 현장 서비스, 필드 서비스, Field Service 데이터 모델, Field Service Data Model, Field Service 개요, Core Data Model, Inventory Management Data Model, Preventive Maintenance Data Model, Product Service Campaign Data Model, Warranty Management Data Model, Pricing Data Model]
---

# Field Service 개요와 데이터 모델

> Field Service는 멀티플랫폼·모바일 서비스 운영을 구성·관리하기 위한 고도로 커스터마이즈 가능한 기능 모음으로, 서로 다양하게 관계 맺는 표준·커스텀 Salesforce 오브젝트 묶음 위에 세워진다. 이 노트는 6개 데이터 모델(Core / Inventory Management / Preventive Maintenance / Product Service Campaign / Warranty Management / Pricing)의 개요와 오브젝트 관계도를 다룬다.

---

## Field Service란

Field Service는 멀티플랫폼·모바일 서비스 운영을 설정·관리하는 데 쓰는 강력하고 고도로 커스터마이즈 가능한 기능 toolbox다. Field Service Developer Guide는 Field Service 기능의 구조를 이해하고 코드로 커스터마이즈하도록 reference 정보와 코드 예제를 제공한다.

가이드 전체가 포함하는 것:

- field service 데이터 오브젝트 간 관계를 보여주는 **오브젝트 다이어그램**
- REST, Metadata, Tooling API에서의 field service 오브젝트 **reference 정보**
- Field Service managed package의 **Apex reference 정보**
- 일반적인 field service 작업을 완료하는 데 쓸 수 있는 **Apex 코드 예제**

field service가 처음이라면 Trailhead의 *Get on the Road with Field Service*를 권장하며, Field Service learning map(영어 전용)을 통해 문서·블로그·Trailhead 모듈 등 큐레이트된 링크를 찾을 수 있다.

> 이 노트는 가이드 Chapter 1의 **개요·데이터 모델·관계도**까지를 다루는 허브다. 객체별 상세 필드 dictionary는 `Field Service Object References`(미작성) 소관이며, REST/Metadata/Tooling API·Apex Namespace·Custom Triggers·Code Examples·Mobile App은 각 형제 노트 소관이다(아래 [관련 노트](#관련-노트) 참조).

---

## Get Ready to Develop with Field Service

field service 기능을 프로그래밍적으로 다루기 전, org에서 Field Service가 활성화되어 있는지 확인한다.

1. Setup에서 Quick Find 박스에 **Field Service Settings**를 입력한 뒤 **Field Service Settings**를 선택한다.
2. Field Service가 활성화(enabled)되어 있는지 확인한다.
3. **Save**를 클릭한다.

이제 이 가이드에 나열된 Salesforce의 표준 field service 오브젝트에 접근할 수 있다. 다만 이는 시작에 불과하며, 프로그래밍 작업 전 *Set Up Field Service*에 정리된 setup 작업을 한 번 훑어보는 것이 좋다.

### ⚠️ 전제조건 — 개발 착수 전 두 필수 선행 단계

위의 Field Service Settings 토글은 **표준 field service 오브젝트 접근을 여는 것뿐**이다. 그러나 FSL Apex 네임스페이스([[FSL Apex Namespace]])·스케줄링·디스패처 콘솔·최적화(optimization)·모바일 등 **개발자 가이드 대부분 기능이 의존하는 두 선행 단계**가 별도로 필요하다. 둘 중 하나라도 빠지면 관련 기능이 동작하지 않거나 **조용히 실패**한다.

1. **Field Service managed package(FSL) 설치** — Field Service를 켠 뒤, 스케줄링·최적화·디스패처 콘솔·모바일용 커스텀 오브젝트·Apex 클래스·Guided Setup을 제공하는 **Field Service managed package**를 org에 설치한다. FSL Apex 네임스페이스와 24개 커스텀 트리거는 이 패키지가 설치되어 있어야 존재한다.
2. **third-party 접근 승인 (Approve third-party access)** — 패키지 설치 과정에서 **geolocation / street-level routing 및 optimization 서비스용 third-party 접근을 승인**한다. 이 승인이 없으면 지오코딩(geocoding)과 스케줄 최적화가 **에러 없이 조용히 실패**하는 흔한 블로커가 된다. 반드시 설치 시점에 함께 승인한다.

> [!warning] third-party 접근 미승인은 field service 개발에서 가장 흔한 무증상 블로커다. 지오코딩·최적화가 실패하는데 명시적 에러가 안 뜨면 이 승인 여부를 먼저 확인한다.
>
> 근거: Trailhead *Install the Field Service Managed Package* (Enable Field Service → Install managed package → Approve third-party access for geolocation & optimization) · Salesforce Help `pfs_install.htm`

---

## API End-of-Life Policy

Salesforce는 각 API 버전을 **최초 릴리스일로부터 최소 3년간** 지원하기로 약속한다. API의 품질과 성능을 개선하기 위해, **3년이 넘은 버전은 더 이상 지원되지 않을 수 있다.** Salesforce는 deprecation이 예정된 API 버전을 사용하는 고객에게 해당 버전 지원 종료 **최소 1년 전에** 통지한다.

> [!note] 원문에 잔존하는 레거시 Note (v67.0 Summer '26 문서 기준)
> - REST API와 SOAP API의 **Version 20.0**은 이제 deprecated되어 더 이상 지원되지 않는다. Summer '22가 릴리스될 때까지 이 레거시 API 버전에 계속 접근할 수 있으나, 그 시점에 이 레거시 버전은 retire되어 사용 불가가 된다. (Knowledge Article: *Salesforce Platform API Versions 7.0 through 20.0 Retirement*)
> - REST API와 SOAP API의 **Versions 21.0 through 30.0**은 Summer '22 릴리스에서 deprecated될 예정이다. (Knowledge Article: *Salesforce Platform API Versions 21.0 through 30.0 Retirement*)

---

## Field Service Data Objects (개요)

Field Service는 서로 다양한 방식으로 관계 맺는 표준·커스텀 Salesforce 오브젝트 suite를 기반으로 한다. 이 오브젝트들은 Field Service managed package와 mobile app의 토대(foundation)이기도 하다.

오브젝트 관계 다이어그램과 reference 정보가 field service **오브젝트 dictionary** 역할을 한다. SOAP·REST API를 통해 field service 레코드와 오브젝트를 생성·조회·수정·삭제할 수 있고, SOQL(Salesforce Object Query Language)로 이 오브젝트들을 쿼리할 수 있다.

6개 데이터 모델 + Object References 구성:

| 데이터 모델 | 용도 |
|---|---|
| **Core Data Model** | work order 관리, service territory 정의, 인력(workforce) 추적 등 핵심 field service 작업 |
| **Inventory Management Data Model** | 재고 품목의 저장·요청·소비·반환·폐기 추적 |
| **Preventive Maintenance Data Model** | maintenance plan으로 특정 asset의 정기 유지보수 일정 관리(고객 service contract·entitlement 반영) |
| **Product Service Campaign Data Model** | 제품 리콜, 수동 펌웨어 업그레이드, 안전/규정 감사, EOL 통지 등 조치 기록 |
| **Warranty Management Data Model** | 판매·설치 제품 결함 시정에 제공되는 노동·부품·비용·교환 옵션을 warranty item으로 기록 |
| **Pricing Data Model** | work order를 product/asset에 연결해 제품 가격과 고객 설치 제품 작업 추적 |
| **Field Service Object References** | Field Service에 쓰이는 표준·커스텀 오브젝트 reference |

> **SEE ALSO (원문):** Salesforce SOAP API Developer Guide · Salesforce REST API Developer Guide · Salesforce SOQL and SOSL Reference

> 아래 6개 모델 narrative와 ER 관계도가 이어진다. 각 ER 블록은 원본 PDF 다이어그램(asterisk = 필수 필드)을 텍스트로 재현한 것이다. **객체별 전체 필드 목록은 이 허브 소관이 아니며 `Field Service Object References`(미작성)를 참조한다.**

---

## 1) Core Data Model

work order 관리, service territory 정의, 인력 추적 등 핵심 field service 작업에 Core 오브젝트를 쓴다.

**Work Order(작업 지시서)** 는 고객을 위해 완료할 작업을 나타내며 Salesforce field service 운영의 중심이다. 청구 목적의 작업 분할이나 subtask 추적을 위해 work order의 자식 레코드인 **work order line item(작업 지시서 라인)** 을 추가한다. Work order는 매우 유연해 다양한 레코드와 연관될 수 있다:

- **Assets** — 특정 asset에 수행한 작업 추적
- **Cases** — 고객 case의 일부로 작업이 수행됨을 표시
- **Accounts와 Contacts** — 고객 대표
- **Entitlements와 Service Contracts** — SLA 이행을 위한 작업임을 표시

work order가 *수행할 작업*을 기술한다면, **service appointment(서비스 예약)** 는 작업 수행을 위해 팀이 현장을 방문하는 *방문*을 나타낸다. arrival window, scheduled start/end time, appointment duration 같은 스케줄링 설정을 포함한다. 모든 service appointment에는 부모 레코드가 있으며 보통 work order나 work order line item이지만, account·asset·lead·opportunity에 자식 service appointment를 추가해 관련 방문을 추적할 수도 있다. 한 레코드는 여러 자식 service appointment를 가질 수 있다(예: 작업 완료에 두 번 방문이 필요하면 work order에 service appointment 둘).

여러 고객에게 동일 작업을 자주 수행한다면 **work type(작업 유형)** 을 만들어 field service 작업을 표준화한다. work type은 work order와 work order line item에 적용 가능한 템플릿으로, 작업 duration 정의와 필요 전문성 수준을 나타내는 skill requirement 추가가 가능하다. work type을 사용하는 레코드에 자식 service appointment 자동 생성도 선택할 수 있다.

### 누가 작업하는가 (Who Performs the Work)

모바일 인력은 **service resource(서비스 리소스)** 로 표현되며 service appointment에 배정될 수 있는 개별 기술자를 나타낸다. 상호 보완적 skill·경험을 가진 service resource 그룹인 **service crew(서비스 승무원)** 를 만들어 단위로 배정할 수도 있다.

service resource를 service appointment에 배정하려면 **assigned resource(배정 리소스)** 레코드를 만든다(service resource와 service appointment로의 lookup 포함). service crew를 배정하려면 먼저 resource type이 **Crew**인 대표 service resource 레코드를 만든 뒤, 그 Crew service resource를 lookup하는 assigned resource 레코드를 만든다.

service resource의 skill·가용성 정의 오브젝트:

- **Service resource skills** — service resource의 인증·전문성 수준
- **Resource capacity** records — 계약자의 시간/작업 기반 capacity 추적
- **Resource absences** — service resource의 결근(작업 누락) 시간
- **Resource preferences** — work order/account에서 특정 service resource를 preferred/required/excluded로 지정

### 어디서 작업하는가 (Where the Work Occurs)

**Service territory(서비스 영역)** 는 팀이 field service 작업을 수행할 수 있는 장소이며 service resource를 조직하는 방법이다. 보통 도시·카운티 같은 지리적 영역이지만 영업 vs 서비스 같은 기능적 구분일 수도 있다. work order는 하나의 service territory와 연관될 수 있다. service resource는 **service territory member**로서 하나 이상의 service territory에 배정되어 해당 영역에서 작업 가능함을 나타낸다.

### 언제 작업하는가 (When the Work Occurs)

**Operating hours(운영 시간)** 는 팀이 field service 작업을 수행할 수 있는 시점을 나타낸다. account·service territory·service territory member에 배정 가능하다. 세부 시간을 더하려면 특정 요일의 운영 시간대인 **time slot(타임 슬롯)** 을 만든다.

고객 entitlement에 field service 접근 시점에 관한 조건이 포함되면, entitlement의 Operating Hours 필드(API명: `SvcApptBookingWindowsId`)로 이 시간을 추적할 수 있다. 예: 고객 A는 월–금 8 AM–정오 서비스 자격, 고객 B는 24/7 서비스 자격이면 각각 operating hours를 만들어 관련 entitlement에 배정한다.

> **SEE ALSO (원문):** Guidelines for Creating Operating Hours for Field Service

### ER 관계도 — Core

```text
// 구조 예시 — 원본 ER 다이어그램 기반 텍스트 재현
// 표기: 객체(룩업필드, ...)  ·  * = 필수 필드  ·  self-Parent = 자기참조 계층
// 색상 범례: 파랑=표준 영업/서비스, 노랑=인력(workforce), 주황=영역/스케줄링, 초록=service appointment(중심), 청록=entitlement 관리
// 주석(다이어그램): "Full relationship model among related objects is not shown"

[Work Order/WOLI 골격]
  Work Order(blue)            : Case, Account, Entitlement, Contact, Asset, Work Type, Price Book ; self-Parent
  Work Order Line Item(blue)  : Work Order*, Asset, Work Type ; self-Parent  (= Work Order의 자식)

[Service Appointment 중심]
  Service Appointment(green)  : Parent Record*, Account, Contact, Service Territory, Work Type
    Parent Record 후보         = Work Order / Work Order Line Item / Account / Asset / Lead / Opportunity

[작업의 성격]
  Work Type(orange)
  Skill Requirement(yellow)   : Required For*(=Work Type/Work Order/WOLI), Skill Required*
  Skill(yellow)

[누가 — 인력]
  Service Resource(yellow)        : User*, Service Crew*
  Service Crew(yellow)
  Service Crew Member(yellow)     : Service Resource*, Service Crew*
  Assigned Resource(yellow)       : Service Appointment*, Service Resource*, Service Crew
  Service Resource Skill(yellow)  : Skill*, Service Resource*
  Service Resource Capacity(yellow): Service Resource*
  Resource Absence(yellow)        : Service Resource*
  Resource Preference(yellow)     : Service Resource*, Related Record*(=Work Order/Account)
  User(blue)

[어디 — 영역/스케줄링]
  Service Territory(orange)        : Parent Service Territory, Operating Hours* ; self-Parent
  Service Territory Member(orange) : Service Territory*, Service Resource*, Operating Hours
  Shift(yellow)                    : Service Resource*, Service Territory*

[언제 — 운영시간 (중심=Operating Hours)]
  Operating Hours(orange)
  Time Slot(orange)                : Operating Hours*
  연결: Service Territory(Operating Hours*), Entitlement(teal, Operating Hours),
        Service Contract, Account(Operating Hours),
        Service Territory Member, Service Resource, Service Resource Capacity, Resource Absence
  // 주석(원문):
  //   Operating hours define: 1.When service resources work. 2.When service appointment can be
  //   booked, based on entitlements. 3.When accounts can be serviced.
  //   Member operating hours override territory operating hours.
```

---

## 2) Inventory Management Data Model

재고 품목의 저장·요청·소비·반환·폐기 추적에 Inventory 오브젝트를 쓴다.

재고 관리는 **product item(제품 품목)** 에서 시작한다. product item은 특정 location에 있는 특정 product의 재고를 나타내며, Salesforce의 product와 location에 연관된다. 예: Warehouse A에 망치 50개, Warehouse B에 200개가 있으면 location마다 product item을 하나씩 만든다. product item은 location의 수량을 나열하며 재고 이동·소비 시 자동 갱신된다.

location에 **Inventory Location** 옵션이 선택되면 그곳에 재고를 저장할 수 있음을 의미하며, product item은 **inventory location에만** 연관될 수 있다. location은 여러 account·service territory에 연결 가능하다(예: location이 쇼핑몰이면 몰 내 점포를 운영하는 모든 account와 연관). location에 mailing·home 주소 같은 **address**를 만들 수 있고, 고객 사이트 추적을 위해 account와 location으로의 lookup을 담은 **associated location(연관 위치)** 을 만든다.

field service 작업에 특정 product가 필요하면 **products required(필요 제품)** 를 추가해 배정된 service resource가 준비된 채 도착하도록 한다. products required는 work order·work order line item·work type의 자식 레코드가 될 수 있다. work order와 work order line item은 work type의 products required를 상속한다.

work order 완료 중 product가 소비되면 **product consumed(소비 제품)** 레코드를 만들어 소비를 추적한다. work order나 work order line item에 추가할 수 있다(라인 아이템별 소비 추적 가능). 재고 상태를 얼마나 면밀히 추적할지에 따라 사용법이 달라진다 — 저장·이동·소비 등 전체 생애주기를 추적하려면 product consumed를 product item에 연결(재고 수치 자동 갱신). 소비만 추적하려면 각 product consumed에 **Price Book Entry**를 지정하고 Product Item 필드는 비워둔다.

재고의 입출고·location 간 이동 추적 오브젝트:

- **Product requests** — 재고가 부족할 때 만드는 제품 주문
- **Product request line items** — product request의 세부 분할
- **Product transfers** — inventory location 간 product item 이동 추적
- **Shipments** — location 간 product item 배송
- **Product item transactions** — product item에 수행된 액션 기술(자동 생성; 재고 보충·소비·조정 시점 추적)
- **Return orders** — 손상·주문 오류 등으로 인한 product item 반환 추적
- **Return order line items** — return order의 세부 분할

> **SEE ALSO (원문):** Set Up Your Field Service Inventory · Guidelines for Transferring Inventory · Guidelines for Consuming Inventory · Common Inventory Management Tasks

### ER 관계도 — Inventory Management

```text
// 구조 예시 — 원본 ER 다이어그램 기반 텍스트 재현
// 표기: 객체(룩업필드, ...)  ·  * = 필수 필드
// 색상 범례: 파랑=표준 영업/서비스, 초록=inventory 오브젝트, 주황=영역/스케줄링

[Product Item 핵심]
  Location(green) — Product Item(green: Product*, Location*) — Product(blue)

[Location 관계도]
  Associated Location(green)        : Account*, Location*
  Service Territory Location(green) : Location*, Service Territory*
  Account(blue), Service Territory(blue), Asset(blue) — Location(green, 중심)
  Location — Address(green) 다대다
    // "A location can have multiple addresses" / "Addresses can be associated with multiple locations"

[Products Required / Product Consumed]
  Product Required(green)        : Parent Record*(=Work Order/WOLI/Work Type), Product*
  Work Order(blue) ⊃ Work Order Line Item(Work Order*)
  Price Book Entry(blue)         : Price Book*
  Product Consumed(green)        : Price Book Entry, Product, Product Item, Work Order*, Work Order Line Item
  Product Item Transaction(green): Product Item*, Related Record(=Product Consumed/Product Transfer)

[재고 이동 오브젝트]
  Related Record 후보 = Work Order / Work Order Line Item / Account / Case
  Product Request(green)           : Related Record*, Source Location(Location), Destination Location(Location)
  Product Request Line Item(green) : Related Record*, Source Location(Location), Destination Location(Location), Product
  Return Order(green)              : Account, Contact, Case, Order, Product Request,
                                     Source Location(Location), Destination Location(Location)
  Return Order Line Item(green)    : Product Return*, Order Product, Product Request Line Item,
                                     Product Item, Product, Asset, Source Location(Location), Destination Location(Location)
  Product Transfer(green)          : Product Request, Product Request Line Item, Source Product Item(Product Item),
                                     Product, Source Location(Location), Destination Location(Location),
                                     Shipment, Received By(User), Return Order, Return Order Line Item
  Shipment(green)                  : Delivered To, Source Location(Location), Destination Location(Location)
```

---

## 3) Preventive Maintenance Data Model

특정 asset의 유지보수 일정을 정의하는 **maintenance plan(유지보수 계획)** 으로 정기 유지보수를 관리한다. maintenance plan은 보통 고객 service contract나 entitlement의 조건을 반영한다.

maintenance plan은 고객을 나타내는 **account·contact**에 연결될 수 있고, 고객이 가진 경우 **service contract**에도 연결된다. 하나의 maintenance plan은 여러 asset을 커버할 수 있다(예: 고객 사무실 건물에 설치된 레이저 프린터 20대의 월간 유지보수 추적). plan이 커버하는 asset은 plan의 자식 레코드인 **maintenance asset(유지보수 자산)** 으로 표현된다.

더 복잡한 반복 유지보수는 대부분의 asset과 maintenance plan에 **maintenance work rule(유지보수 작업 규칙)** 을 정의할 수 있다(예: 소규모 월간 유지보수 + 대규모 연간 서비스 일정). maintenance plan을 **location**에 연결해 asset 설치 장소를 나타낼 수도 있다(예: 프린터가 설치된 사무실 건물을 나타내는 Site 유형 location).

maintenance plan/maintenance work rule 생성 후 계획된 유지보수 방문용 work order를 생성한다. maintenance plan에는 **Generate Work Orders** quick action이 있으며 Apex 코드로도 호출 가능하다. plan 설정이 한 번에 생성되는 work order·work order line item 수와 그 설정을 결정한다. 방문마다 maintenance asset당 work order 하나를 생성하거나, 방문마다 부모 work order 하나에 maintenance asset당 work order line item 하나를 두도록 선택할 수 있다.

maintenance plan·maintenance asset·maintenance work rule은 work type과 연관 가능하다:

- maintenance **plan**에 work type 지정 → plan의 work order가 그 work type 사용
- maintenance **asset**에 work type 지정 → 그 maintenance asset과 연관된 생성 work order가 그 work type 사용
- maintenance **work rule**에 work type 지정 → 그 work rule과 연관된 생성 work order가 그 work type 사용

> **SEE ALSO (원문):** Generate Work Orders on Maintenance Plans with Apex — 자세한 Apex 호출은 [[Field Service Custom Triggers·Code Examples]](PART 2 코드 예제 2) 참조

### ER 관계도 — Preventive Maintenance

```text
// 구조 예시 — 원본 ER 다이어그램 기반 텍스트 재현
// 표기: 객체(룩업필드, ...)  ·  * = 필수 필드
// 색상 범례: 파랑=표준 영업/서비스, 노랑=인력, 주황=영역/스케줄링, 초록=entitlement 관리

  Account(blue)
  Associated Location(yellow) : Account*, Location*
  Location(yellow)
  Service Contract(teal)      : Account
  Asset(blue)                 : Account, Contact, Location, Product
  Contract Line Item(teal)    : Service Contract*, Asset, Product
  Maintenance Plan(orange)    : Account, Service Contract, Location, Work Type
  Maintenance Asset(orange)   : Asset*, Maintenance Plan*, Contract Line Item, Work Type
  Maintenance Work Rule(orange): Maintenance Asset*, Work Type
  Work Type(orange)           // 주석: "Also referenced by WO & WOLI"
  Work Order(blue), Work Order Line Item(blue)
  Service Appointment(green)  : Parent Record*
```

---

## 4) Product Service Campaign Data Model

**product service campaign(제품 서비스 캠페인)** 으로 제품 리콜, 수동 펌웨어 업그레이드, 안전·규정 감사, end-of-life 통지 같은 상황에 대응하는 조치를 기록한다. 영향받는 asset은 **product service campaign item(제품 서비스 캠페인 항목)** 을 통해 campaign에 연관된다. campaign과 campaign item은 필요에 따라 work order·return order와 연관되어 작업을 완료한다.

> [참고] 이 모델의 narrative는 다이어그램 외 추가 산문이 없다(원문 Note: "Asterisks mean these fields are required").

### ER 관계도 — Product Service Campaign

```text
// 구조 예시 — 원본 ER 다이어그램 기반 텍스트 재현
// 표기: 객체(룩업필드, ...)  ·  * = 필수 필드
// 색상 범례: 파랑=표준 영업/서비스, 주황=product service campaign 오브젝트

  Product(blue), Asset(blue)
  Product Service Campaign(orange)      : Product*   (= Product의 자식; Asset도 참조)
  Product Service Campaign Item(orange) : Asset*     (= Product Service Campaign의 자식)
  하단 연결(blue): Return Order, Return Order Line Item, Work Order, Work Order Line Item
  // narrative: "associated with work orders and return orders as needed"
```

---

## 5) Warranty Management Data Model

**warranty item(보증 항목)** 으로 판매·설치 제품의 문제를 시정하는 데 제공되는 노동·부품·비용과 교환 옵션 세부를 기록한다. product와 product family에 대한 standard warranty를 만들고, 설치 제품에는 추가/연장 warranty와 exclusion·void term 세부를 기록한다.

**warranty term(보증 조건)** 은 **product warranty term(제품 보증 조건)** 에 연결되어 product 또는 product family에 제공되는 표준 보증을 정의한다. product가 설치되면 standard warranty로부터 **asset warranty term(자산 보증 조건)** 세부가 생성된다. asset warranty term은 work order·work order line item·case·entitlement와 연관되어 보증 조건 이행 관련 조치를 추적할 수 있다.

### ER 관계도 — Warranty Management

```text
// 구조 예시 — 원본 ER 다이어그램 기반 텍스트 재현
// 표기: 객체(룩업필드, ...)  ·  * = 필수 필드
// 색상 범례: 파랑=표준 영업/서비스, 주황=warranty management 오브젝트

  Product(blue), Asset(blue)
  Warranty Term(orange)
  Product Warranty Term(orange) : Product*, Warranty Term*
  Asset Warranty Term(orange)   : Asset*, Warranty Term*
  Asset Warranty Term 연결(blue): Work Order, Work Order Line Item, Case, Entitlement
```

---

## 6) Pricing Data Model

work order를 org의 product·asset에 연결해 제품 가격과 고객 설치 제품에 수행되는 작업을 추적한다.

Salesforce에 제품 카탈로그를 설정해 두었다면 price book의 품목을 work order와 그 line item에 연관할 수 있다(opportunity·order에 product를 연관하는 방식과 유사). work order에 price book을 지정하면 각 work order line item을 그 price book의 **price book entry(제품)** 에 연결할 수 있다. list price·discount·quantity는 line-item 수준에서 정의된다.

예: solar panel 설치 work order를 만들면 work order의 Price Book lookup 필드에서 price book을 선택하고, work order line item의 Price Book Entry lookup 필드로 Site Assessment·Solar Panel·Inverter 같은 품목을 선택한다. 완료된 work order의 line item을 보면 카탈로그의 어떤 product가 판매되었는지 한눈에 알 수 있다.

product가 구매·설치되면 보통 **asset**으로 추적된다. work order와 work order line item의 Asset lookup 필드로 특정 asset에 수행되는 작업을 추적하고 그 asset에 완료된 모든 작업 이력을 볼 수 있다. asset이 교체·업그레이드되면 구·신 asset 간 관계가 **asset relationship(자산 관계)** 레코드로 추적된다. asset relationship은 start/end time(예: 교체 asset이 리스인 경우)과 admin이 정의하는 relationship type을 나열한다.

> **SEE ALSO (원문):** Work Order Pricing Guidelines for Field Service · Equal Asset Relationships

### ER 관계도 — Pricing

```text
// 구조 예시 — 원본 ER 다이어그램 기반 텍스트 재현
// 표기: 객체(룩업필드, ...)  ·  * = 필수 필드
// 색상 범례: 파랑=표준 영업/서비스 (이 다이어그램 객체 전부 blue 계열)

  Price Book(blue)
  Work Order(blue)            : Price Book, Account
  Work Order Line Item(blue)  : Work Order*, Price Book Entry
  Asset(blue)
  Asset Relationship(blue)    : Asset*, Related Asset*
  Product(blue)
  Price Book Entry(blue)      : Product*, Price Book*
```

---

## 관련 노트

- [[Field Service Objects]] — Object Reference 기준 FSL 표준 오브젝트 요약 카탈로그(SOQL 예제 포함). 본 허브는 데이터 모델·관계도 관점, 보완 관계.

### Field Service Object References (객체별 상세 필드 dictionary)
- [[객체 레퍼런스 — Service Appointment·Resource]] — ServiceAppointment·AssignedResource·Address 등 예약·배정 객체 (Core)
- [[객체 레퍼런스 — Service Resource·Crew·Skill]] — ServiceResource·ServiceCrew·Skill·ResourceAbsence 등 인력 객체 10종 (Core)
- [[객체 레퍼런스 — Service Territory·OperatingHours·Shift]] — ServiceTerritory·OperatingHours·Shift·TimeSlot 등 영역·스케줄링 객체 10종 (Core)
- [[객체 레퍼런스 — Inventory (Product·ReturnOrder·Shipment)]] — Pricebook2·Product2·ProductItem·ReturnOrder·Shipment 등 재고 객체 15종 (Inventory Management·Pricing)
- [[객체 레퍼런스 — Maintenance·PSC·Location]] — MaintenancePlan·ProductServiceCampaign·Location 등 8종 (Preventive Maintenance·Product Service Campaign)
- [[객체 레퍼런스 — Asset·Attribute·Warranty]] — Asset·AssetAttribute·AssetWarranty·WarrantyTerm 등 자산·보증 객체 (Warranty Management·Pricing)
- [[객체 레퍼런스 — Service Contract·Entitlement·Milestone]] — ServiceContract·Entitlement·ContractLineItem·EntityMilestone 등 계약·엔타이틀먼트 객체
- [[객체 레퍼런스 — Appointment Bundling]] — ApptBundlePolicy 계열 8개 예약 번들링 정책 객체
- [[객체 레퍼런스 — Work Order·WorkOrderLineItem·Status]] — WorkOrder·WorkOrderLineItem·OrderItem·Status 등 작업 주문 도메인 객체 (Core)
- [[객체 레퍼런스 — WorkPlan·WorkStep·WorkType]] — WorkPlan·WorkStep·WorkType·WorkTypeGroup 등 작업 절차·템플릿 객체 (Core)
- [[객체 레퍼런스 — WorkCapacity·RecordsetFilterCriteria]] — WorkCapacity·RecordsetFilterCriteria 등 용량·필터 기준 객체 (Core)
- [[객체 레퍼런스 — Service Report·Layout·DigitalSignature]] — ServiceReport·ServiceReportLayout·DigitalSignature 등 서비스 리포트 객체
- [[객체 레퍼런스 — Expense·TimeSheet]] — Expense·TimeSheet·TimeSheetEntry 등 경비·작업시간 객체
- [[객체 레퍼런스 — Mobile·Geolocation·LinkedArticle·ObjChange]] — 모바일·지오로케이션·연결 아티클·객체 변경 추적 객체
- [[객체 레퍼런스 — Custom Fields on Standard Objects]] — 표준 오브젝트(WorkOrder·ServiceAppointment 등)에 FSL이 추가하는 커스텀 필드 색인
- [[객체 레퍼런스 — Supplementary Objects (History·Feed·Share)]] — History·Feed·Share 등 FSL 객체별 부속 시스템 객체

### 형제 노트
- [[Field Service REST API]] — Field Service Flow / Mobile Settings / Service Report Template / Appointment Bundling REST 엔드포인트
- [[Field Service Metadata·Tooling API]] — Metadata API(FieldServiceSettings·Skill·TimeSheetTemplate) + Tooling API(CleanRule·TimeSheetTemplate) reference
- [[FSL Apex Namespace]] — Field Service managed package(FSL) Apex reference(19개 클래스 — scheduling·optimization·appointment booking)
- [[Field Service Custom Triggers·Code Examples]] — FSL 패키지 24개 커스텀 트리거 동작 가이드 + Apex 코드 예제(Service Report·Generate Work Orders·Dispatcher Console Custom Actions·Service Appointment Lists)
- [[Field Service Mobile App (LWC)]] — 모바일 앱(LWC 개발·디버그·딥링킹·플러그인)
