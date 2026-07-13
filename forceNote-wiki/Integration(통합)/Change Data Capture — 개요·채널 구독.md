---
tags: [integration, change-data-capture, cdc, platform-events, event-driven, streaming, replication]
source: salesforce_change_data_capture.pdf (Change Data Capture Developer Guide, Version 66.0, Spring '26)
created: 2026-07-13
aliases: [Change Data Capture, CDC, 변경 데이터 캡처, CDC 개요, 구독 채널, subscription channels, ChangeEvents 채널, 채널명 형식, 이벤트 버스 보존, transaction-based replication, ReplayId]
---

# Change Data Capture — 개요·채널 구독

> Salesforce 레코드의 생성·수정·삭제·복원 변경을 near-real-time 이벤트(change event)로 발행해 외부 시스템과 지속 동기화하는 CDC의 개념·지원 객체·엔티티 선택·구독 채널명 형식·이벤트 버스 저장/전달·트랜잭션 기반 복제 절차를 정리한 허브 노트.

**Editions:** Salesforce Classic·Lightning Experience 모두 지원. **Enterprise, Performance, Unlimited, Developer** editions에서 사용 가능.

---

## CDC란 / 언제 쓰나

Change Data Capture는 Salesforce 레코드의 변경(새 레코드 생성, 기존 레코드 수정, 레코드 삭제, 레코드 복원)을 나타내는 **change event**를 발행한다. 구독자는 이 이벤트를 near-real-time으로 받아 외부 데이터 저장소의 대응 레코드를 동기화한다.

### Keep Your External Data Current — 외부 데이터를 최신으로 유지

주기적 export/import나 반복적 API 호출 대신 CDC를 사용해 외부 시스템의 데이터를 갱신한다. CDC 이벤트 알림으로 변경을 캡처하면 외부 데이터를 실시간으로 갱신해 항상 fresh하게 유지할 수 있다.

### When Do You Use Change Data Capture? — 실시간 데이터 복제의 일부

CDC는 클라우드를 위한 **real-time 데이터 복제(replication) 프로세스**의 일부로 생각할 수 있다. 데이터 복제는 다음 단계로 구성된다.

1. **Initial (day 0) copy** — 전체 데이터셋을 외부 시스템으로 최초 복사.
2. **Continuous synchronization** — 신규·변경 데이터를 외부 시스템으로 지속 동기화.
3. **Reconciliation** — 두 시스템 간 중복 데이터 조정.

CDC는 이 중 **2단계(continuous synchronization)**를 담당한다. 신규·변경 레코드의 delta(변경분)를 발행한다. CDC는 이벤트를 수신하고 외부 시스템에서 갱신을 수행할 **integration app이 필요**하다.

예: Salesforce의 employee 커스텀 객체 레코드 사본을 가진 HR 시스템이 있으면, change event를 받아 HR 시스템의 employee 레코드를 동기화할 수 있다. 대응하는 insert/update/delete/undelete 연산을 HR 시스템에서 처리하고, 변경이 near real time으로 수신되므로 HR 시스템 데이터가 최신으로 유지된다.

CDC는 다운스트림 시스템으로의 secure·scalable event streaming을 가능하게 한다. integration app은 하루 수백만 이벤트를 받아 다른 시스템과 데이터를 동기화할 수 있다. **event retention 3일** 덕분에 CometD 또는 Pub/Sub API 구독자가 과거 이벤트 메시지를 받을 수 있다. 암호화와 field-level security로 보안 이벤트 저장·통신을 지원한다.

### Use Change Data Capture to: (전수 12항목)

- Keep external systems in sync with Salesforce data. (외부 시스템을 Salesforce 데이터와 동기화)
- Receive notifications of Salesforce record changes, including create, update, delete, and undelete operations. (레코드 변경 알림 수신 — create/update/delete/undelete)
- Subscribe using CometD, Pub/Sub API, or Apex triggers. (CometD, Pub/Sub API, Apex 트리거로 구독)
- Capture field changes for all records. (모든 레코드의 필드 변경 캡처)
- Get broad access to all data regardless of sharing rules. (sharing rule과 무관하게 모든 데이터에 광범위 접근)
- Deliver only the fields a user has access to based on field-level security. (FLS 기반으로 사용자가 접근 가능한 필드만 전달)
- Encrypt change event fields at rest. (change event 필드를 저장 시 암호화)
- Get information about the change in the event header, such as the origin of the change, which allows ignoring changes that your client generates. (이벤트 헤더에서 변경 정보 — 변경 origin 등 — 획득해 클라이언트 자체 변경 무시 가능)
- Perform data updates using transaction boundaries. (트랜잭션 경계 기반 데이터 갱신)
- Use a versioned event schema. (버전 관리되는 이벤트 스키마 사용)
- Subscribe to mass changes in a scalable way. (대량 변경을 scalable하게 구독)
- Get access to retained events for up to three days. (최대 3일간 보존된 이벤트에 접근)

### We don't recommend using Change Data Capture to: (전수 2항목)

- **Perform audit trails based on record and field changes.** (레코드·필드 변경 기반 감사 추적 용도)
- **Update the UI for many users in apps subscribed with CometD or Pub/Sub API.** CDC는 다운스트림 시스템 동기화를 위한 것이지 개별 사용자를 위한 것이 아니다. 많은 사용자가 CometD 또는 Pub/Sub API 클라이언트로 구독하면 concurrent client limit에 도달할 수 있다. → [[Change Data Capture — 고려사항·할당량·표준객체]] 참조.

### Change Data Capture Reliability — 신뢰성

이벤트 버스에 change event를 임시 저장하는 것이 이벤트 전달의 신뢰성을 높인다. CometD·Pub/Sub API 구독자는 오프라인 상태나 연결 오류로 놓친 이벤트를 catch up 할 수 있다. Pub/Sub API로 이벤트를 replay 하는 방법은 Pub/Sub API Developer Guide의 Subscribe RPC Method 참조.

change event는 industry-standard distributed system에 임시 저장·서빙된다. distributed system은 transactional database와 동일한 semantics나 guarantee를 갖지 않는다. change event는 queue·buffer되고 Salesforce가 비동기로 발행을 시도한다. **드문 경우, 일부 이벤트 메시지가 최초 또는 후속 시도에서 distributed system에 persist되지 못한다. 이 경우 이벤트는 구독자에게 전달되지 않으며 복구 불가능하다.**

---

## Change Event Object Support — 어떤 객체가 지원되나

change event는 org에 정의된 **모든 커스텀 객체**와 **표준 객체의 subset**에서 사용 가능하다.

change event를 지원하는 객체 목록은 Object Reference for Salesforce and Lightning Platform의 `StandardObjectNameChangeEvent`를 참조한다. (위키 내 → [[ChangeEvent Objects]])

> **Note:** 모든 객체가 여러분의 org에서 사용 가능한 것은 아니다. 일부 객체는 특정 feature setting과 permission이 enable 되어야 한다.

관련 참고: Object Reference(Standard Objects), Salesforce Help(Create Partner Users), Loyalty Management Developer Guide(Standard Objects).

---

## CDC 엔티티 선택

CDC로 변경 알림을 받으려면 관심 있는 객체를 **엔티티로 선택**해야 한다. UI(Setup) 또는 Metadata/Tooling API로 설정한다.

> 이 노트는 **채널·메타데이터 관점**의 엔티티 선택을 다룬다. Apex 트리거 작성 시의 엔티티 선택 전제조건·헤더 필드는 [[ChangeEventHeader]]에 위임한다.

### Select Objects in the User Interface

default standard channel에서 레코드 변경 알림을 받으려면 Change Data Capture 페이지에서 관심 있는 커스텀 객체·지원 표준 객체를 선택한다.

**USER PERMISSIONS**

- Change Data Capture 페이지 보기: **View Setup and Configuration**
- 엔티티 선택 추가/수정: **Customize Application**

Setup → Quick Find에 `Change Data Capture` 입력 → **Change Data Capture** 클릭. Available Entities 목록은 org에서 CDC 가능한 객체를 보여준다.

- 표준·커스텀 객체 포함 **최대 5개 엔티티(five entities)**까지 선택 가능.
- 더 많은 엔티티를 enable 하려면 Salesforce Account Representative에게 **add-on license** 구매를 문의한다. add-on license는 선택 가능 엔티티 수 제한을 없애고, CometD·Pub/Sub API 클라이언트의 event delivery allocation도 증가시킨다. add-on license가 있으면 Available Entities 목록에서 **한 번에 최대 10개 엔티티(10 entities at a time)** 선택 가능하며, 처음 10개를 선택한 뒤 더 추가할 수 있다.

> **Note:** Change Data Capture 페이지는 **default standard channel의 객체 선택만** 표시한다. 커스텀 채널의 선택은 표시하지 않는다. → [[Change Data Capture — 커스텀 채널]] 참조.

각 목록 항목은 **`"Entity Label (API Name)"`** 형식이다. 엔티티 label은 rename 될 수 있으므로, 엔티티를 정확히 식별하기 위해 API name을 괄호 안에 함께 제공한다.

### Select Objects with Metadata API and Tooling API

Metadata API 또는 Tooling API에서 **`PlatformEventChannelMember`**를 사용해 default standard channel 또는 커스텀 채널의 객체 이벤트 선택을 생성·조회한다.

- default standard channel인 **`ChangeEvents`**는 Setup의 Change Data Capture 페이지에서 구성하는 선택에 대응한다.
- 커스텀 채널의 경우 선택은 channel member를 생성할 때 설정된다.
- `PlatformEventChannelMember`의 **`SelectedEntity`** 필드가 선택된 이벤트를 나타낸다.

> **Note:** 커스텀 채널을 위해 `PlatformEventChannelMember`에서 만든 선택은 Change Data Capture 페이지에 반영되지 않는다. 이 페이지는 default standard channel(`ChangeEvents`)의 선택만 보여주고 커스텀 채널은 보여주지 않는다.

---

## 구독 채널명 형식 (핵심 허브 표)

**subscription channel**은 하나 이상의 엔티티에 대응하는 change event의 stream이다. 채널을 구독해 레코드 create/update/delete/undelete 변경 알림을 받는다. CDC는 미리 정의된 standard channel을 제공하며 커스텀 채널도 만들 수 있다. **채널 이름은 case-sensitive(대소문자 구분)이다.**

채널 endpoint를 지정해 구독한다. 예를 들어 선택한 모든 엔티티의 이벤트를 구독하려면 `/data/ChangeEvents`를 구독한다. **Apex 트리거는 채널을 구독할 수 없고 단일 이벤트만 구독**할 수 있다 (예: `AccountChangeEvent` 트리거는 Account change event만 구독).

- **Standard Channels — `ChangeEvents`**: 선택한 하나 이상의 엔티티의 change event를 단일 stream에 담는다. 둘 이상 엔티티의 change event가 예상되면 이 채널을 쓴다. UI 또는 Metadata/Tooling API로 엔티티를 선택한 뒤 구독한다.
- **Single-Entity Channels**: 단 하나의 커스텀 객체 또는 표준 객체의 change event만 구독. Setup의 CDC 페이지 또는 커스텀 채널에서 엔티티를 선택한다.

### 채널 이름 정리 표 (verbatim, unique 값 전수 · case-sensitive)

| 채널 종류 | 포맷 | 예시 |
|---|---|---|
| 전체 선택 엔티티 (표준) | `/data/ChangeEvents` | `/data/ChangeEvents` |
| 표준 오브젝트 단일 | `/data/<Standard_Object_Name>ChangeEvent` | `/data/AccountChangeEvent`, `/data/OpportunityChangeEvent` |
| 커스텀 오브젝트 단일 | `/data/<Custom_Object_Name>__ChangeEvent` | `/data/Employee__ChangeEvent` |
| 커스텀 채널 | `/data/Channel_Name__chn` | `/data/HREvents__chn` |
| (Pub/Sub generic 표준) | `/data/Channel_Name` | — |

> ⚠️ **커스텀 객체 채널명 주의:** `Employee__c` 커스텀 객체의 채널은 `/data/Employee__ChangeEvent`이다. 즉 `__c`의 `c`가 빠지고 `__ChangeEvent`가 붙는다 (`Employee__c` → `Employee__ChangeEvent`).
>
> ⚠️ **모든 채널 이름은 case-sensitive.**

원문 그대로의 포맷 정의:

```
/data/ChangeEvents                              # 전체 선택 엔티티(표준)
/data/<Standard_Object_Name>ChangeEvent         # 표준 오브젝트 단일 → 예: /data/AccountChangeEvent
/data/<Custom_Object_Name>__ChangeEvent         # 커스텀 오브젝트 단일 → 예: /data/Employee__ChangeEvent
/data/Channel_Name                              # (Pub/Sub) 표준 채널 generic
/data/Channel_Name__chn                         # 커스텀 채널
```

---

## Change Event Storage and Delivery — 저장·전달

change event는 임시 저장되며 구독자는 retention window 동안 조회할 수 있다. 전달되는 이벤트 순서는 대응하는 committed transaction의 순서를 따른다. 적절한 permission을 가진 사용자가 채널에서 이벤트를 받을 수 있다.

### Temporary Storage in the Event Bus — 이벤트 버스 임시 저장

change event는 platform event 기반이며 저장 특성 일부를 공유한다. change event 메시지는 **이벤트 버스에 3일(three days, 72시간) 동안 저장**된다. 저장된 이벤트 메시지를 이벤트 버스에서 조회할 수 있다. 각 이벤트 메시지는 **`ReplayId`** 필드를 포함하며, 이는 stream 내에서 이벤트를 식별하고 특정 이벤트 이후부터 stream을 replay 할 수 있게 한다. (Pub/Sub API Developer Guide의 Event Message Durability 참조)

### Order of Events — 이벤트 순서

이벤트 버스에 저장된 change event의 순서는 레코드 변경에 대응하는 트랜잭션이 Salesforce에서 commit 된 순서에 대응한다. 한 트랜잭션에 여러 변경(예: lead conversion)이 포함되면, 각 변경마다 change event가 생성되되 헤더의 **`transactionKey`는 동일**하고 **`sequenceNumber`는 다르게** 부여된다. sequenceNumber는 트랜잭션 내 변경의 순서다.

Salesforce가 change event를 받으면 **replay ID** 값을 부여해 이벤트 버스에 persist 한다. 구독자는 replay ID 순서로 이벤트 버스에서 change event를 받는다.

### User Permissions Required — 필요 권한

구독자는 subscription channel에 따라 다음 permission 중 하나 이상이 필요하다: **View All Data**, **View All Users**, 그리고 특정 객체에 대한 **View All Records**. (Required Permissions for Change Event Subscribers 참조)

---

## Transaction-Based Replication Steps — 트랜잭션 기반 복제

다른 시스템에 Salesforce org 데이터의 정확한 replica를 유지하려면 **transaction-based approach**로 구독한다.

### CDC가 생성하는 이벤트 종류: Change / Gap / Overflow

일반적으로 Salesforce는 change event를 보내 레코드 변경을 캡처하고, 구독자는 이를 받아 외부 시스템 데이터를 동기화한다. 때때로 **gap event** 또는 **overflow event**가 생성된다.

- **Gap events** — change event를 생성할 수 없을 때 생성된다. Salesforce application server 외부에서 수행된 오류·연산을 구독자에게 알린다. gap event는 레코드 데이터를 포함하지 않지만 **record ID를 포함**하므로 이를 사용해 Salesforce에서 레코드를 조회할 수 있다. 헤더의 **`changeType`** 필드가 gap event와 연관 연산을 식별하며 다음 값 중 하나를 갖는다:
  - `GAP_CREATE`
  - `GAP_UPDATE`
  - `GAP_DELETE`
  - `GAP_UNDELETE`
- **Overflow events** — 단일 트랜잭션이 **100,000 changes를 초과**할 때 생성된다. 처음 100,000 changes는 change event를 생성하고, 그 이후 변경 집합은 포함된 각 entity type마다 하나의 overflow event를 생성한다. overflow event는 헤더 필드만 포함하고 레코드 데이터·record ID가 없다. `changeType` 헤더 값은 구체적 변경 타입 대신 **`GAP_OVERFLOW`**다.

> Gap·Overflow 이벤트의 메시지 구조·상세 처리는 [[Change Data Capture — 이벤트 메시지·Gap·Overflow]]에 위임.

### Transaction-Based Replication Approach

각 change event는 헤더에 그 변경이 속한 트랜잭션을 고유 식별하는 **transaction key**를 포함한다. 또한 트랜잭션 내 변경 순서를 식별하는 **sequence number**를 포함한다. sequence number는 lead conversion처럼 여러 단계를 포함하는 연산에 유용하다. 트랜잭션에 관여한 모든 객체가 CDC로 enable 되지 않았다면 sequence number에 gap이 생긴다. 한 트랜잭션의 모든 변경을 여러분 시스템에서 **single commit으로 복제**하기를 권장한다. 한 가지 방법은 트랜잭션 관련 변경을 모두 buffer 했다가 한 번에 commit 하는 것이다.

transaction-based 복제 프로세스를 사용하지 않으면, 구독이 중단될 때 복제 데이터가 불완전해질 수 있다. 예를 들어 한 트랜잭션의 이벤트 stream 중간에 구독이 멈추면 그 트랜잭션 변경의 일부만 복제된다.

### High-Level Steps (6단계 전수)

transaction-based 복제 프로세스는 다음 고수준 단계로 구성된다:

1. 구독 클라이언트에서 각 transaction key마다 transaction buffer를 할당한다. 예: transactionKey 값을 키로 하는 map(`Map<String, List<ChangeEvent>>`)을 만든다.
2. 모든 enable 된 이벤트를 캡처하는 일반 `/data/ChangeEvents` 채널로 구독을 연다.
3. 채널로 수신한 각 change event마다 `changeType` 필드를 확인한다.
   - a. `changeType`이 `GAP_CREATE`, `GAP_UPDATE`, `GAP_DELETE`, `GAP_UNDELETE`이면 gap event다. How to Handle a Gap Event의 권장 절차를 따른다.
   - b. `changeType`이 `GAP_OVERFLOW`이면 overflow event다.
     - i. map에 이전에 저장한 change event를 처리한다. 변경을 commit 하고 대응 map entry를 purge 한다.
     - ii. overflow event에 대해서는 How to Handle an Overflow Event의 권장 절차를 따른다.
     - iii. *(원문 내용 없음 — PDF 원본 절단. pdftotext가 "iii. n"으로만 추출함. 날조하지 않음.)*
4. 이벤트가 gap·overflow event가 아니면 change event다. change event를 deserialize 하고 transaction key에 해당하는 map entry에 추가한다.
5. 다음 change event에서 transactionKey 값이 바뀌면, 이전 transaction key의 map entry에 있는 변경을 commit 하고 그 map entry를 purge 한다.
6. 수신하는 각 새 이벤트에 대해 3~5단계를 반복한다.

### 트랜잭션 버퍼 코드 (verbatim)

```apex
// 구조 예시 — 실제 동작 코드 아님 (PDF는 map 타입만 산문으로 제시)
// 트랜잭션 키를 키로 하는 버퍼 맵 (PDF Transaction-Based Replication Steps step 1)
Map<String, List<ChangeEvent>> buffer = ...;
// key = transactionKey value
```

> 위는 PDF가 예시로 제시한 map 타입 `Map<String, List<ChangeEvent>>`이다. Gap event / Overflow event의 구체적 reconciliation 절차(dirty flag, isDeleted 재동기화, Replay ID 재구독 등)는 [[Change Data Capture — 이벤트 메시지·Gap·Overflow]]에 위임한다.

**Gap 처리 요약:** gap event 수신 시 Salesforce에서 최신 데이터를 가져온다. gap event는 영향받은 record ID를 포함하므로 레코드를 조회할 수 있다. 한 가지 방법은 대응 레코드를 dirty로 표시하고, 조정될 때까지 그 레코드의 change event를 처리하지 않는 것이다. (`commitTimestamp`·`LastModifiedDate` 필드 비교로 순서 판정 → 상세는 위임 노트)

**Overflow 처리 요약:** 단일 트랜잭션이 100,000 events를 초과하면 첫 100,000 이후 이벤트에 대해 overflow event를 받는다. entity type마다 하나의 overflow event가 생성된다. overflow event는 dummy record ID만 가지므로, 한 가지 방법은 overflow event 수신 후 해당 entity의 모든 레코드를 조회해 외부 시스템을 갱신/삭제하는 것이다. (unsubscribe → Replay ID 저장 → 전체 재동기화 → 저장한 Replay ID부터 resubscribe → 상세는 위임 노트)

---

## 구독 방법 3갈래 (라우팅)

| 구독 방법 | 무엇 | 어디로 |
|---|---|---|
| **Pub/Sub API (gRPC)** | 외부 클라이언트에서 하나의 API로 publish·subscribe·schema 조회. gRPC·HTTP/2 기반, Avro binary 메시지. Subscribe 호출당 이벤트 수 제어 가능 | [[Pub-Sub API (gRPC) — Platform Event·CDC 구독]] |
| **CometD (Streaming API)** | 롱 폴링 기반 스트리밍 구독. 오프라인/오류 후 replay 지원 | [[Streaming API (CometD·PushTopic·Generic Streaming)]] |
| **Apex Trigger** | Lightning Platform 내에서 change event 캡처·처리. DB 트랜잭션 완료 후 비동기 실행. 채널이 아니라 **단일 이벤트**(예: `AccountChangeEvent`)만 구독 | [[ChangeEventHeader]] |

> Compound field(예: Name, Address, Geolocation)는 이벤트 메시지에서 nested field 구조로 표현되며, record update 시 `changedFields` 헤더가 `CompoundField.ComponentField` 형식으로 나열한다. 이벤트 메시지 구조·compound field 상세는 [[Change Data Capture — 이벤트 메시지·Gap·Overflow]] 및 [[ChangeEventHeader]] 참조.

---

## 관련 노트

- [[Change Data Capture — 커스텀 채널]] — 커스텀 채널 구성·channel member·ERD
- [[Change Data Capture — 이벤트 메시지·Gap·Overflow]] — change event 메시지 구조, Merged/Gap/Overflow 이벤트 처리
- [[Change Data Capture — Enrichment·필터링]] — event enrichment·채널 필터링
- [[Change Data Capture — 고려사항·할당량·표준객체]] — allocation·concurrent client limit·표준 객체 노트
- [[ChangeEventHeader]] — Apex 트리거로 change event 구독, 헤더 필드
- [[Pub-Sub API (gRPC) — Platform Event·CDC 구독]] — 외부 gRPC 구독
- [[Streaming API (CometD·PushTopic·Generic Streaming)]] — CometD 구독
- [[ChangeEvent Objects]] — sObject 레퍼런스(지원 표준 객체)
- [[Salesforce Connect — 어댑터·Cross-Org·writable·External CDC]] — **혼동 주의:** External Change Data Capture(외부 시스템 데이터 변경을 OData 폴링으로 추적)는 이 내부 CDC와 완전히 다른 기능
