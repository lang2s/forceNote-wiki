---
tags: [integration, change-data-capture, cdc, allocations, limits, security, standard-objects, monitoring]
source: salesforce_change_data_capture.pdf (Change Data Capture Developer Guide, Version 66.0, Spring '26)
created: 2026-07-13
aliases: [CDC 할당량, CDC allocations, CDC limits, event delivery limit, 이벤트 전달 한도, PlatformEventUsageMetric, CDC 보안, FLS, encrypted change events, 표준객체 특수 이벤트, Person Account CDC, Lead Conversion CDC, Task Event CDC, data differences]
---

# Change Data Capture — 고려사항·할당량·표준객체

> CDC 운영에 필요한 사용량 모니터링(PlatformEventUsageMetric)·보안(권한·FLS·암호화)·edition별 할당량 셀 전수·표준객체 7종의 특수 이벤트 동작을 원문 수치 그대로 정리한다.

---

## 모니터링 — Monitor Publishing and Delivery Usage

이벤트 발행·전달 사용량(CometD·Pub/Sub API 클라이언트, empApi Lightning 컴포넌트, event relay 대상)을 얻으려면 **PlatformEventUsageMetric** 객체를 쿼리한다. **PlatformEventUsageMetric은 API version 50.0 이상에서 사용 가능**하다. **API 58.0 이상**에서는 **Enhanced Usage Metrics**를 활성화해 다양한 시간 구간의 세분화된 사용 데이터를 얻을 수 있다. Enhanced Usage Metrics가 활성화되지 않은 경우, 사용 데이터는 마지막 24시간(직전 정시까지)과 과거 일별 사용량에 대해 제공된다.

> **Important:** Salesforce는 Enhanced Usage Metrics 사용을 권장한다. 이벤트 이름(event name)·client ID·event type·usage type 기준으로 사용 지표를 분해할 수 있고, daily·hourly·15분 단위 등 다양한 시간 구간으로 사용 데이터를 얻을 수 있다. Platform Events Developer Guide의 Enhanced Usage Metrics 참조.

- PlatformEventUsageMetric에 저장된 사용 지표는 **REST API limits 값과 별개**다. 월간 전달 사용량을 할당량 대비 추적하려면 REST API limits를 쓴다. limits API가 반환하는 월간 이벤트 전달 사용량은 CometD·Pub/Sub API 클라이언트·empApi Lightning 컴포넌트·event relay에서 platform event와 change data capture event에 **공통**이다. PlatformEventUsageMetric은 platform event와 change data capture event 사용량을 분해해 별도로 추적하게 해준다.
- 날짜는 **협정 세계시(UTC)**로 저장되므로, 쿼리 시 로컬 날짜·시간을 UTC로 변환한다.

> **Note:**
> - 사용 데이터는 **최소 45일** 저장된다. 사용 데이터는 매시간 갱신되며 24시간 기간 동안 사용량이 0이 아닐 때만 제공된다. 사용 데이터는 1시간 간격이나 임의 간격으로는 제공되지 않는다. 지원되는 유일한 간격은 마지막 24시간과 daily 데이터다. 또한 standard-volume platform event에는 사용 데이터가 제공되지 않는다.
> - Salesforce major upgrade 후에는 upgrade window 내의 그날과 마지막 24시간에 대해 사용 데이터가 부정확할 수 있다. 새 사용 데이터가 5분 upgrade가 발생한 시간(hour)의 데이터를 덮어쓴다. 새 사용 데이터에는 그 시간에 대해 upgrade 후 시작된 지표가 포함된다.

**Change event 사용 지표 (첫 값 = 쿼리에 지정하는 metric name):**
- **CHANGE_EVENTS_PUBLISHED** — 발행된 change data capture event 수
- **CHANGE_EVENTS_DELIVERED** — CometD·Pub/Sub API 클라이언트, empApi Lightning 컴포넌트, event relay로 전달된 change data capture event 수

**Platform event 사용 지표:**
- **PLATFORM_EVENTS_PUBLISHED** — 발행된 platform event 수
- **PLATFORM_EVENTS_DELIVERED** — CometD·Pub/Sub API 클라이언트, empApi Lightning 컴포넌트, event relay로 전달된 platform event 수

### 마지막 24시간 사용 지표 얻기

마지막 24시간(직전 정시까지)의 사용 지표를 얻으려면 UTC로 start·end 날짜·시간과 metric name을 지정해 쿼리한다. 마지막 24시간 기간에서 end date는 현재 UTC 날짜이며 시간은 직전 정시로 내림한다. start date는 end date의 24시간 전이다. 날짜는 시간 단위(hourly) 정밀도를 갖는다.

**예시:** 현재 UTC 날짜·시간이 2020년 8월 4일 11:23이면 마지막 정시는 11:00이다.
- Start date (UTC): `2020-08-03T11:00:00.000Z`
- End date (UTC): `2020-08-04T11:00:00.000Z`

```sql
SELECT Name, StartDate, EndDate, Value FROM PlatformEventUsageMetric
WHERE Name='CHANGE_EVENTS_DELIVERED'
AND StartDate=2020-08-03T11:00:00.000Z AND EndDate=2020-08-04T11:00:00.000Z
```

Result:

| Name | StartDate | EndDate | Value |
|---|---|---|---|
| CHANGE_EVENTS_DELIVERED | 2020-08-03T11:00:00.000+0000 | 2020-08-04T11:00:00.000+0000 | 575 |

StartDate와 EndDate 사이 시간 간격은 저장된 24시간 사용량에 대해 24시간이다. 따라서 쿼리에 StartDate 또는 EndDate 중 하나만 지정해도 같은 결과를 얻는다.

### 과거 일별(Historical Daily) 사용 지표 얻기

1일 이상의 daily 사용 지표를 얻으려면 UTC로 start date·end date와 metric name을 지정해 쿼리한다.

**예시:** 2020년 7월 19일부터 7월 22일까지 3일 기간의 사용 지표. 시간 값은 0이다.
- Start date: `2020-07-19T00:00:00.000Z`
- End date: `2020-07-22T00:00:00.000Z`

```sql
SELECT Name, StartDate, EndDate, Value FROM PlatformEventUsageMetric
WHERE Name='CHANGE_EVENTS_DELIVERED'
AND StartDate>=2020-07-19T00:00:00.000Z and EndDate<=2020-07-22T00:00:00.000Z
```

Results:

| Name | StartDate | EndDate | Value |
|---|---|---|---|
| CHANGE_EVENTS_DELIVERED | 2020-07-19T00:00:00.000+0000 | 2020-07-20T00:00:00.000+0000 | 575 |
| CHANGE_EVENTS_DELIVERED | 2020-07-20T00:00:00.000+0000 | 2020-07-21T00:00:00.000+0000 | 899 |
| CHANGE_EVENTS_DELIVERED | 2020-07-21T00:00:00.000+0000 | 2020-07-22T00:00:00.000+0000 | 1,035 |

**Id 주의:** PlatformEventUsageMetric의 Id를 쿼리하면 반환되는 Id 값은 유효한 레코드 ID가 아니다. 예를 들어 아래 쿼리는 Id 필드 값으로 **`000000000000000AAA`**를 반환한다.

```sql
SELECT Id, Name, StartDate, EndDate, Value FROM PlatformEventUsageMetric WHERE Name='CHANGE_EVENTS_DELIVERED'
```

따라서 QueryLocator를 쓰는 batch Apex에서 PlatformEventUsageMetric을 사용할 수 없다 — QueryLocator는 execute 메서드에 유효한 레코드 ID가 전달돼야 하기 때문이다. batch Apex와 QueryLocator로 PlatformEventUsageMetric을 쓰면 예기치 않은 결과가 발생한다. 대신 batch Apex에서는 **iterable**을 PlatformEventUsageMetric과 함께 쓴다.

### Apex 트리거 구독자 조회 — Obtain Apex Trigger Subscribers

change event를 구독한 트리거 정보를 얻으려면 **EventBusSubscriber** 표준 객체를 SOQL로 쿼리한다. EventBusSubscriber는 Apex 트리거 정보를 포함하지만 CometD·Pub/Sub API 구독자는 포함하지 않는다.

```sql
SELECT ExternalId, Name, Topic, Position, Status, Tip, Type FROM EventBusSubscriber
```

반환 결과는 change event를 구독한 Apex 트리거가 둘 있음을 보여준다. 하나는 AccountChangeEvent, 하나는 ContactChangeEvent를 구독한다.

| ExternalId | Name | Topic | Position | Status | Tip | Type |
|---|---|---|---|---|---|---|
| 01q2J000000g0kb | MyAccountChangeTrigger | AccountChangeEvent | 226751 | Running | -1 | ApexTrigger |
| 01q2J000000g0kg | MyContactChangeTrigger | ContactChangeEvent | 226752 | Running | -1 | ApexTrigger |

WHERE 절로 필터할 수 있다. 예를 들어 topic이 ContactChangeEvent인 것만 필터한다.

```sql
SELECT ExternalId, Name, Topic, Position, Status, Tip, Type FROM EventBusSubscriber
WHERE Topic='ContactChangeEvent'
```

| ExternalId | Name | Topic | Position | Status | Tip | Type |
|---|---|---|---|---|---|---|
| 01q2J000000g0kg | MyContactChangeTrigger | ContactChangeEvent | 226752 | Running | -1 | ApexTrigger |

---

## 보안 — Security Considerations

### 구독 필수 권한 — Required Permissions for Change Event Subscribers

Change Data Capture는 **공유 설정(sharing settings)을 무시**하고 Salesforce 객체의 모든 레코드에 대한 change event를 전송한다. 채널에서 change event를 받으려면 구독한 사용자가 change event에 연관된 엔티티에 따라 하나 이상의 권한을 가져야 한다. 이 권한들은 **Pub/Sub API·CometD 구독자에게 적용되며 Apex 트리거에는 적용되지 않는다**. Apex 트리거는 **Automated Process** 엔티티 하에서 시스템 권한으로 실행되므로 이 권한들이 필요 없다.

**Change Event Permissions** (row = "change event를 받을 대상", col = "필수 권한"):

| change event를 받을 대상 | 필수 권한 |
|---|---|
| 특정 표준 또는 커스텀 객체 | 해당 객체에 대한 **View All Records** |
| User | **View All Users** |
| Task·Event처럼 View All Records 권한이 없는 표준 객체 | **View All Data** |
| 채널의 모든 엔티티 | **View All Data** (엔티티 중 하나가 User이면 **View All Users**도 함께) |

**권한 반영 — Permission Enforcement:**

표준 `/data/ChangeEvents` 채널과 커스텀 채널에 대해서는 사용자 권한이 **이벤트 전달 시점(on event delivery)**에 적용된다. 사용자는 엔티티 권한과 무관하게 `/data/ChangeEvents` 채널이나 임의의 커스텀 채널을 구독할 수 있다. 사용자는 필요한 권한을 가진 엔티티에 연관된 change event만 받고, 권한이 없는 change event는 받지 않는다. 구독 후 권한이 변경되면, 변경은 **Pub/Sub API 구독자의 경우 10분 이내에 반영**된다. **CometD 구독자의 경우 구독을 재시작(restart the subscription)하기 전까지는 반영되지 않는다.**

단일 엔티티 표준 채널(한 표준 또는 커스텀 객체의 change event만 포함)에 대해서는 사용자 권한이 **구독 시점(initially on subscription)**에 적용된다. 사용자가 해당 객체에 대한 충분한 권한이 없으면 구독이 거부되고 오류가 반환된다. 구독 성공 후 권한이 변경되어 사용자가 엔티티에 더 이상 접근할 수 없게 되면, 해당 change event 수신을 중단한다.

### 필드 수준 보안 — Field-Level Security

Change Data Capture는 **조직의 field-level security 설정을 준수한다**. 전달되는 이벤트는 구독한 사용자가 볼 수 있는 필드만 포함한다. 객체의 change event를 전달하기 전 구독한 사용자의 필드 권한을 확인한다. 사용자가 어떤 필드에 접근할 수 없으면 그 필드는 구독자가 받는 change event 메시지에 포함되지 않는다.

Salesforce 객체의 change event를 describe할 때, describe 호출은 그 객체에 대한 사용자의 field-level security 설정을 확인한다. describe 호출은 사용자가 접근 권한을 가진 필드만 change event의 describe 결과로 반환한다. change event 이름을 sObject 이름(예: `AccountChangeEvent`)으로 사용해 SOAP API 또는 REST API로 change event를 describe할 수 있다.

단, Salesforce 객체에 대응하는 change event schema를 얻을 때는 반환되는 schema에 사용자가 접근 권한이 없는 필드까지 포함한 **모든** 객체 필드가 포함된다.

### 암호화된 데이터의 Change Event — Encrypted Salesforce Data

Salesforce 레코드 필드가 **Shield Platform Encryption**으로 암호화된 경우, 암호화된 필드 값의 변경이 change event를 생성한다. Change event는 event bus에 **최대 3일(up to three days)** 저장된다. event bus에 저장되는 이벤트가 평문이 아니라 암호화되도록 하려면 **event bus tenant secret**을 생성하고 암호화를 활성화한다.

change event 암호화를 활성화하려면 먼저 Setup의 **Key Management** 페이지에서 event bus tenant secret을 생성한다. 그런 다음 **Encryption Policy** 페이지에서 change event 암호화를 활성화한다.

> **Warning:** 암호화를 활성화하기 전에 event bus tenant secret을 먼저 생성해야 한다. Setup에서 암호화 설정은 event bus tenant secret을 생성한 후에만 표시된다. Metadata API에서 tenant secret 없이 PlatformEncryptionSettings로 암호화를 활성화하면 오류가 발생한다.

#### Event Bus Tenant Secret 생성 — Generate an Event Bus Tenant Secret

**USER PERMISSIONS — tenant secret 관리:** Manage Encryption Keys

**Prerequisites:** Platform Encryption 페이지에서 tenant secret을 생성할 수 있는 사용자는 인가된 사용자뿐이다. Salesforce 관리자에게 **Manage Encryption Keys** 권한 할당을 요청한다. Event Bus tenant secret을 생성하기 전에 활성 **Fields and Files (Probabilistic)** 또는 **Fields (Deterministic)** tenant secret이 있어야 한다.

**Steps:**
1. Setup의 Quick Find box에 `Platform Encryption`을 입력하고 **Key Management**를 선택한다.
2. Key Management Table에서 **Event Bus**를 선택한다.
3. **Generate Tenant Secret**을 클릭하거나, 고객 제공 tenant secret을 업로드하려면 **Bring Your Own Key**를 클릭한다.

> **Note:**
> - event bus tenant secret은 **7일당 1회(once every 7 days)** 생성 또는 회전(rotate)할 수 있다.
> - **TenantSecret** 객체와 Type 필드 값 **EventBus**를 사용해 SOAP API 또는 REST API로도 tenant secret을 생성할 수 있다.

#### Change Event 암호화 활성화 — Enable Encryption of Change Events

event bus tenant secret을 생성하면 Encryption Settings 페이지에 change event 암호화를 시작하는 설정이 표시된다.

**Steps:**
1. Setup의 Quick Find box에 `Platform Encryption`을 입력하고 **Encryption Settings**를 선택한다.
2. **Encrypt Change Data Capture Events and Platform Events**를 선택한다.

> **Note:** change event 암호화를 활성화하면 platform event 암호화도 함께 활성화된다.

#### 변경 캡처와 페이로드 암호화 — Capturing Changes and Encrypting the Event Payload

레코드 변경을 캡처한 후 Change Data Capture는 change event를 생성해 event bus에 저장한다. 데이터 변경은 애플리케이션 서버에서 복호화된 형태로 내부적으로 캡처되므로, change event를 저장하기 전에 암호화해야 한다. 전체 이벤트 페이로드는 **Event Bus tenant secret type**에 기반한 data encryption key로 암호화된다.

Shield Platform Encryption이 활성화되면 Change Data Capture는 자신이 추적하는 **모든(all)** Salesforce 객체의 필드를 암호화한다. Change Data Capture는 **Shield Platform Encryption용으로 설정된 객체·필드 선택을 무시한다**. 변경이 추적되는 모든 객체의 필드는 Shield Platform Encryption용으로 선택되지 않은 객체라도 이벤트 저장 전에 암호화된다. 예를 들어 contact의 Mailing Address만 Shield Platform Encryption으로 암호화된 경우에도, account와 contact 모두에서 데이터 변경이 발생하면 둘 다의 change event가 암호화된다.

#### Change Event 전달 — Delivering Change Events

구독한 클라이언트에 change event를 전달하기 전, change event 페이로드는 data encryption key로 복호화된다. change event는 **HTTPS와 TLS**를 사용하는 보안 채널로 전송되어 전송 중(in transit) 데이터가 보호·암호화된다. 암호화 키가 회전되어 새 키가 발급된 경우, 저장된 이벤트는 재암호화되지 않지만 전달 전에 아카이브된 키로 복호화된다. 키가 파기되면 저장된 이벤트는 복호화될 수 없어 전달되지 않는다.

> **Note:** Classic Encryption은 지원되지 않는다.

---

## 일반 고려사항 — General Considerations

### 일부 작업은 Change Event를 생성하지 않음

다음 작업들은 영향받은 레코드에 대한 change event를 생성하지 않는다.
- 레코드 hard-delete(휴지통에서 레코드 삭제).
- **State and Country/Territory Picklists** 페이지에서 Setup으로 수행하는 state·country/territory picklist 관련 모든 작업.
- opportunity stage picklist 값의 type 변경.
- person account 조직에서 커스텀 picklist 필드가 Contact에 정의된 경우 그 필드는 Account에 `__pc` 접미사로 존재한다. 이 커스텀 picklist의 값을 교체하거나 이름을 변경하면 account change event는 생성되지 않고 영향받은 레코드의 contact change event만 생성된다. 반대로 커스텀 picklist 필드가 Account에 정의된 경우 그 필드는 Contact에 존재하지 않으며 예상대로 account change event만 생성된다.

### 한 트랜잭션 내 같은 레코드의 다중 변경

같은 트랜잭션 경계 내에서 한 레코드에 다중 DML 작업이 수행되면, **초기 변경 유형(initial change type)에 대해 하나의 change event만 생성된다**. change event는 트랜잭션 종료 시 Salesforce에 커밋된 데이터를 포함한다. 추가 작업들은 트랜잭션 내부적이므로 change event를 생성하지 않는다. 예를 들어 case 레코드가 생성되고 after-insert 트리거가 커밋 전에 이 case를 쿼리한다. 트리거가 case priority를 Medium에서 High로 바꾸고 update를 수행한다. 트랜잭션 커밋 후 changeType이 CREATE이고 priority가 High인 하나의 change event가 생성된다.

### Formula 필드 — 18자리 숫자 한도

커스텀 formula 필드는 change event에 포함되지만, formula 필드 업데이트가 항상 change event를 trigger하는 것은 아니다. Formula 필드는 ChangeEvent 객체의 Apex 트리거에서 변경된 레코드에 나타나지 않는다. **Derived 필드는 Change Data Capture에서 지원되지 않는다.**

숫자 formula 필드를 포함할 때는 값이 Salesforce 한도인 **18 total digits(정수부·소수부 합산)**를 초과하지 않도록 한다. formula 필드에 높은 소수 자릿수가 설정된 경우, 시스템이 설정된 정밀도를 맞추려 값에 0을 채워, 원래 값의 자릿수가 더 적더라도 총 자릿수가 18을 초과할 수 있다. 이 한도를 초과하는 값을 포함하는 change event는 **캡처되지 않고 대신 gap event가 생성된다**.

### Geolocation Compound 필드

geolocation compound 필드(type location)가 **커스텀 객체**에서 변경되면, 변경 여부와 무관하게 모든 구성 필드가 change event에 발행된다. 반면 geolocation 필드가 **표준 객체**에서 변경되면 변경된 필드만 발행된다.

### Data Cloud Channel for Data Streams

Data Cloud에서 Salesforce CRM 커넥터로 data stream을 생성할 때, 선택한 객체가 change event를 지원하면 data stream은 레코드 데이터 동기화에 Change Data Capture를 사용한다. 이 선택들은 **DataCloudEntities** 표준 채널에 추가된다. Metadata API나 Tooling API로 이 표준 채널의 선택을 수정하지 않도록 한다. API로 채널 선택을 업데이트하면 Data Cloud 관리자가 의도하지 않은 Salesforce 객체의 예기치 않은 동기화가 발생할 수 있다.

---

## 할당량 — Change Data Capture Allocations

change event에 대한 할당량(커스텀 채널 수, 채널의 선택 엔티티 수, 이벤트 전달)을 다룬다.

> **Pattern B 주의:** 아래 표들은 원문(dump)이 이미 row = 항목, col = edition 방향으로 명시했다. 방향 유지(transpose 금지). 모든 셀은 원문 verbatim.

### Common Change Event Allocations

**방향: row = 할당량 설명, col = edition (Performance and Unlimited / Enterprise / Developer).**

| 설명 | Performance and Unlimited Editions | Enterprise Edition | Developer Edition |
|---|---|---|---|
| 모든 채널·모든 event type에 걸친 최대 동시(concurrent) CometD 클라이언트(구독자) 수 | **2,000** | **1,000** | **20** |
| Salesforce가 발행할 수 있는 최대 이벤트 메시지 크기 (엔티티에 수백 개의 커스텀 필드나 여러 long text area 필드가 있으면 이 한도에 도달할 수 있고, 그 경우 change event 메시지는 전달되지 않고 gap event 메시지로 대체된다) | **1 MB** | **1 MB** | **1 MB** |

> **Note (동시 클라이언트 할당량):** 동시 클라이언트 할당량은 CometD에 적용되며 모든 이벤트 유형(platform event, change event, PushTopic event, generic event)에 적용된다. Apex 트리거·flow·Process Builder 프로세스 같은 non-CometD 클라이언트에는 적용되지 않는다. Flow·Process Builder 프로세스는 platform event에만 적용되고 change event에는 적용되지 않는다. empApi Lightning 컴포넌트는 CometD를 사용하므로 다른 CometD 클라이언트처럼 동시 클라이언트 할당량을 소비한다. empApi를 사용하는 로그인 사용자 각각은 하나의 동시 클라이언트로 계산된다. 한 사용자가 여러 브라우저 탭에서 empApi를 쓰면 streaming 연결이 공유되어 그 사용자에 대해 하나의 클라이언트로 계산된다. 동시 클라이언트 할당량을 초과하는 클라이언트는 오류를 받고 구독할 수 없다. 기존 클라이언트 중 하나가 연결을 끊고 연결이 가용해지면 새 클라이언트가 구독할 수 있다.

### Default Change Event Allocations for Event Delivery

조직에 add-on 라이선스가 없으면 이벤트 발행·전달에 초과 불가한 default 할당량이 적용된다. Default 할당량은 멀티테넌트 환경의 공정한 자원 공유를 보장하고 서비스를 보호하기 위해 강제된다.

- **이벤트 전달 할당량(event delivery allocation)**은 **24시간 기간(24-hour period)**에 Pub/Sub API·CometD 구독자, empApi Lightning 컴포넌트, event relay로 전달될 수 있는 이벤트 메시지 수다. Apex 트리거·flow·Process Builder 프로세스 같은 non-API 구독자는 제외한다. non-API 구독자로 전달되는 발행 이벤트 메시지는 전달 할당량에 계산되지 않는다.
- 이벤트 전달 할당량은 **high-volume platform event와 Change Data Capture event 간에 공유된다**.

> **Note:** Apex 트리거는 이벤트 전달 한도에 계산되지 않지만, 이벤트 처리율은 구독자 처리 시간과 수신 이벤트 볼륨에 따라 달라진다.

**모든 구독자에 대해 이벤트 전달 사용량 합산** — 클라이언트로 전달된 이벤트 수는 event relay를 포함해 **각(each)** 구독 클라이언트마다 계산된다. 여러 클라이언트 구독자가 있으면 사용량은 **모든 구독자에 걸쳐 합산된다**. 예: default 할당량이 24시간당 50,000 이벤트인 Unlimited Edition 조직. 몇 시간 내에 구독한 두 클라이언트에 각각 20,000 이벤트 메시지가 전달되면 40,000 이벤트를 소비한 것이고, 24시간 기간 내에 여전히 10,000 이벤트를 사용할 수 있다.

**이벤트 전달 사용량 계산 방식** — daily 이벤트 전달 한도는 **rolling limit**이다. 마지막 24시간에 전달된 이벤트 수로 계산된다. 시간이 지나면서 사용량이 갱신된다. 이벤트 전달 한도는 새 이벤트가 수신될 때 확인된다.

#### Table 1: Default Allocations

**방향: row = 할당량, col = Subscriber Clients / Performance and Unlimited Editions / Enterprise Edition / Developer Edition.**

| 설명 | Subscriber Clients | Performance and Unlimited Editions | Enterprise Edition | Developer Edition |
|---|---|---|---|---|
| default 표준 채널과 커스텀 채널을 포함한 모든 채널에 걸쳐 선택할 수 있는 표준·커스텀 객체를 포함한 최대 엔티티 수. (커스텀 채널에서 AppExchange 패키지가 만든 엔티티 선택에는 적용되지 않는다. 같은 엔티티가 여러 채널에서 선택되면 할당량에 한 번만 계산된다.) | Not applicable | **5** | **5** | **5** |
| 최대 커스텀 채널 수 (이 할당량은 커스텀 platform event 채널의 할당량과 별개다.) | Not applicable | **100** | **100** | **100** |
| Event Delivery: 마지막 24시간에 전달된 최대 이벤트 메시지 수, 모든 클라이언트 공유. | 적용 대상: Pub/Sub API, CometD, empApi Lightning 컴포넌트, Event relay. 적용 안 됨: Apex 트리거, Flow, Process Builder 프로세스. | **50,000** | **25,000** | **10,000** |

> **Note:** Salesforce는 레코드 변경에 응답해 change event를 발행하므로, 사용자가 발행되는 전체 이벤트를 제어하지 않기 때문에 Change Data Capture에 대해 발행 한도(publishing limit)를 강제하지 않는다.

### 이벤트 할당량 초과 회피 방법

이벤트 전달 사용량이 할당량에 근접하면 다음 방법으로 전달 이벤트 소비를 줄인다.
- **stream filtering**으로 구독자에게 전달되는 이벤트 양을 줄이고 관련 이벤트만 받는다.
- default ChangeEvents 채널 대신 **커스텀 채널**을 사용해 관심 엔티티 관련 이벤트만 받는다.
- 불필요한 구독자가 없도록 한다. 구독자에게 전달된 각 이벤트는 이벤트 전달 할당량에 계산된다.

### 이벤트 전달 할당량 초과 시 오류 코드

default 이벤트 전달 할당량을 초과하면 오류가 반환되고 구독이 끊긴다.
- **CometD 클라이언트 오류:** `403::Organization total events daily limit exceeded.` CometD 구독자가 처음 연결하거나 기존 구독자 연결에서 Bayeux `/meta/connect` 채널에 반환된다.
- **Pub/Sub API 클라이언트 오류 코드:** `sfdc.platform.eventbus.grpc.subscription.limit.exceeded`. 오류 메시지: `You have exceeded the event delivery limit for your org.`

클라이언트가 이벤트 전달 할당량에 도달하면 다음 중 하나를 수행한다.
- 구독자를 일시적으로 연결 해제 상태로 둔다. 연결 해제 동안 마지막 24시간의 이벤트 사용량이 얼마 후 감소한다. 연결 해제 상태에서 Salesforce가 수신한 이벤트는 **보존 기간 72시간(retention period of 72 hours)** 동안 저장된다. 사용량이 감소한 후 중단 지점부터 구독을 재개해 이벤트를 받는다. Replay ID를 사용해 Pub/Sub API·CometD로 저장된 이벤트 메시지를 조회할 수 있다.
- 이벤트 전달 한도에 자주 도달하고 이벤트 볼륨이 높으면 Salesforce Account Representative에게 문의해 add-on 구매를 검토한다.

### 증가 가능한 할당량

**이벤트 전달 할당량**을 늘리고 **변경 알림용 최대 선택 엔티티 수 한도를 제거**할 수 있다. 이를 위해 Salesforce Account Representative에게 문의해 Change Data Capture add-on을 구매한다. add-on은 이벤트 전달 사용량을 monthly entitlement 모델로 옮기고 사용량 급증을 허용한다.

### 선택 엔티티 수 조회

선택 엔티티 수를 얻으려면 Tooling API에서 **PlatformEventChannelMember**에 SOQL 쿼리를 수행한다.

```sql
SELECT COUNT_DISTINCT(SelectedEntity) FROM PlatformEventChannelMember
```

이 쿼리는 모든 채널에 걸쳐 선택된 고유 엔티티 수를 얻는다. AppExchange 패키지가 엔티티 선택을 하면 쿼리가 선택 엔티티 할당량보다 **높은** 수를 반환할 수 있다 — AppExchange 선택은 선택 엔티티 할당량에 계산되지 않기 때문이다.

### AppExchange 릴리즈 관리형 패키지 할당량

선택 엔티티 할당량에는 설치된 **AppExchange released managed package**가 패키지 일부인 커스텀 채널에서 만든 선택이 포함되지 않는다. **최대 5개의 엔티티 선택** 한도는 사용자가 하는 선택, 또는 unmanaged·managed 패키지가 하는 선택(**AppExchange released managed package는 제외**)에 적용된다. AppExchange released managed package를 설치하면 그 패키지가 커스텀 채널에서 한 선택은 조직 할당량에 계산되지 않는다. 조직이 최대 선택 엔티티 default 할당량에 도달했더라도 AppExchange 패키지를 설치할 수 있다. AppExchange 패키지 설치는 현재 선택 엔티티 수 사용량을 바꾸지 않는다. 이는 **1세대·2세대 패키지 모두**에 해당한다. 패키지 개발자의 경우 패키지 개발 조직에서는 엔티티 선택 할당량이 여전히 강제된다.

### Add-On License로 이벤트 전달 할당량 증가

Pub/Sub API·CometD·empApi Lightning 컴포넌트·event relay에 대한 이벤트 전달 할당량을 늘리려면 추가 change event용 add-on을 구매한다. add-on은 이벤트 발행 할당량도 늘린다. add-on은 이벤트 전달 사용량을 monthly usage-based entitlement 모델로 옮기고 사용량 급증을 허용한다.

add-on license의 이점·사실:
- add-on은 **24시간 전달 이벤트 메시지 할당량을 하루당 100,000개(월 3백만 개)** usage-based entitlement로 늘린다.
- add-on은 **변경 알림용 최대 선택 엔티티 수 한도를 제거**한다.
- daily 전달 사용량이 default 할당량만큼 엄격하게 강제되지 않는다. add-on은 **grace allocation**으로 사용량 급증을 허용한다. grace allocation은 add-on license로 구매한 할당량보다 높다. daily 이벤트 전달 사용량이 grace allocation 이내면 구독자는 중단되지 않고 계속 이벤트를 받을 수 있다. Salesforce는 언제든 grace allocation을 조정할 권리를 보유한다.
- entitlement는 계약 시작일 이후 **매월 재설정된다**.
- Entitlement 사용량은 **production 조직에서만** 계산된다. sandbox·trial 조직에서는 제공되지 않는다.
- Salesforce는 계약 시작일 기준 calendar month로 이벤트 초과를 모니터링한다. monthly entitlement를 초과하면 Salesforce가 연락한다. **월간 이벤트 초과 모니터링에 쓰이는 entitlement는 daily 할당량 × 30이다.**

#### Table 2: Example — Usage-Based Entitlement with One Change Data Capture Add-On License

**방향: row = 할당량, col = Subscriber Clients / Performance and Unlimited Editions / Enterprise Edition. (이 표에는 Developer Edition 열이 없음 — 원문 구조 그대로.)**

| 설명 | Subscriber Clients | Performance and Unlimited Editions | Enterprise Edition |
|---|---|---|---|
| Change Data Capture용으로 선택할 수 있는 표준·커스텀 객체를 포함한 최대 엔티티 수. | Not Applicable | **No limit** | **No limit** |
| Event Delivery: 전달 이벤트 메시지 entitlement, 모든 클라이언트 공유. (오류를 받기 전 일정량까지 이 entitlement를 초과할 수 있다. Salesforce는 이벤트 초과 모니터링에 monthly entitlement를 사용한다. monthly entitlement는 limits REST API 리소스로 반환된다.) | 적용 대상: Pub/Sub API, CometD, empApi Lightning 컴포넌트, Event relay. 적용 안 됨: Apex 트리거, Flow, Process Builder 프로세스. | **Last 24 hours: 150,000** (조직 라이선스 포함 50 K + add-on license 100 K + grace amount). **Monthly entitlement: 4.5 million** (조직 라이선스 포함 1.5 million + add-on license 3 million) | **Last 24 hours: 125,000** (조직 라이선스 포함 25 K + add-on license 100 K + grace amount). **Monthly entitlement: 3.75 million** (조직 라이선스 포함 0.75 million + add-on license 3 million) |

### 할당량 대비 이벤트 사용량 모니터링

Setup, REST API, Apex로 이벤트 발행·전달 사용량과 최대 할당량을 확인한다. UI에서(platform event와 공유) change event 전달 사용량 확인: Setup의 Quick Find box에 `Platform Events`를 입력하고 **Platform Events**를 선택한다. 사용량은 **Event Allocations** 섹션에 표시된다. 발행 사용량은 change event에 적용되지 않는다.

조직이 platform event 또는 change data capture add-on을 구매했으면, daily 이벤트 전달 할당량에 더해 **grace allocation**이 표시된다. 이 값은 **DailyDeliveredPlatformEvents** REST API limits 값에 대응한다. 월간 이벤트 전달 사용량도 표시되며 **MonthlyPlatformEvents** REST API limits 값에 대응한다.

**이벤트 사용량 확인 방법** (row = Allocation, col = Default Allocations / Add-On License):

| Allocation | Default Allocations | Add-On License |
|---|---|---|
| Event Delivery: CometD·Pub/Sub API 클라이언트, empApi Lightning 컴포넌트, event relay로 전달된 이벤트 알림 수 | add-on을 구매하지 않았으면 다음 중 하나로 사용량을 확인한다: • **REST API**로 마지막 24시간 daily 이벤트 전달 사용량: REST API limits 리소스로 `DailyDeliveredPlatformEvents` 값 확인. • **Apex**로 마지막 24시간 daily 이벤트 전달 사용량: `System.OrgLimit` 클래스로 `DailyDeliveredPlatformEvents` 값 확인. daily 이벤트 전달 사용량은 이벤트 전달 후 몇 분 이내에 갱신된다. | add-on을 구매했으면 다음 중 하나로 사용량을 확인한다: • 마지막 24시간 daily 이벤트 전달은 이전 열과 동일. • 월간 이벤트 전달 사용량: Setup의 Quick Find box에 `Platform Events` 입력 후 **Platform Events** 선택. 월간 이벤트 전달 사용량은 **Event Allocations** 섹션에 표시된다. REST API limits 리소스에서 이 값은 API version 47.0 이하의 `MonthlyPlatformEvents`에 대응한다. UI·API의 이 값은 이벤트 전달 후 몇 분 이내에 갱신된다. • Usage-based entitlement: Setup의 Quick Find box에 `Company Information` 입력 후 **Company Information** 선택. 사용량은 **Usage-based Entitlements** related list에 표시된다. REST API limits 리소스에서 이 값은 API version 48.0 이상의 `MonthlyPlatformEventsUsageEntitlement`에 대응한다. UI·API의 이 값은 하루에 한 번 갱신된다. |

**시간별 이벤트 사용량 모니터링** — 이벤트 전달 사용량을 시간(hour) 단위로 모니터링하려면 매시간 REST API로 daily 이벤트 전달 사용량을 조회한다.

**PlatformEventUsageMetric으로 SOQL 사용량 추세 추적** — PlatformEventUsageMetric에 SOQL 쿼리로 이벤트 사용량·추세를 확인한다. Enhanced usage metrics로 platform event와 change data capture event의 개별·결합 지표를 볼 수 있다.

---

## 표준객체별 특수 이벤트 — Standard Object Notes

일부 표준 객체의 change event 특성과 이벤트 메시지에 포함되는 필드를 다룬다. 아래 예시 JSON은 모두 원문(PDF) 발췌다.

### Tasks and Events

단일·반복(recurring) task와 calendar event의 change event를 받을 수 있으며 invitee가 있는 event도 포함된다.

#### Recurring Activities

activity series 레코드는 하나의 change event로 추적된다. series의 각 occurrence는 개별 change event로 추적된다.

**예시:** recurring calendar event 생성 시 Pub/Sub API 클라이언트에 두 change event가 전달된다. 첫 change event는 recurrence 패턴을 나타내는 event series 레코드용으로 **GroupEventType이 3**으로 설정된다. 두 번째 change event는 첫 occurrence용이다. ActivityDateTime과 ActivityDate는 **Epoch time**이다. 나머지 occurrence는 예시에서 생략된다.

```json
// Change event generated for the event series record.
{
  "ChangeEventHeader": {
    "entityName": "Event",
    "recordIds": ["00UZM000000wuBw2AI"],
    "changeType": "CREATE",
    "changeOrigin": "com/salesforce/api/soap/61.0;client=SfdcInternalAPI/",
    "transactionKey": "000a48c7-f73c-5d0b-7650-123ab3a20e70",
    "sequenceNumber": 1,
    "commitTimestamp": 1714408223000,
    "commitNumber": 72779532308,
    "commitUser": "005ZM000000M6o1YAC",
    "nulledFields": [], "diffFields": [], "changedFields": []
  },
  "WhoId": null, "WhatId": null, "Subject": "Product Planning",
  "Location": "San Francisco", "IsAllDayEvent": false,
  "ActivityDateTime": 1715014800000, "ActivityDate": 1714953600000,
  "DurationInMinutes": 60,
  "Description": "Let's meet to discuss product requirements.",
  "AccountId": null, "OwnerId": "005ZM000000M6o1YAC", "Type": null,
  "IsPrivate": false, "ShowAs": "Busy", "IsChild": false,
  "IsGroupEvent": false, "GroupEventType": "3",
  "CreatedDate": 1714408223000, "CreatedById": "005ZM000000M6o1YAC",
  "LastModifiedDate": 1714408223000, "LastModifiedById": "005ZM000000M6o1YAC",
  "RecurrenceActivityId": null, "IsRecurrence": false,
  "Recurrence2PatternText": "RRULE:FREQ=WEEKLY;BYDAY=MO;WKST=SU;INTERVAL=1;COUNT=13",
  "Recurrence2PatternVersion": "1",
  "ActivityRecurrence2Id": "828ZM0000000001YAA",
  "ActivityRecurrence2ExceptionId": null
}
// Change event generated for the first occurrence.
{
  "ChangeEventHeader": {
    "entityName": "Event",
    "recordIds": ["00UZM000000wuBx2AI"],
    "changeType": "CREATE",
    "sequenceNumber": 2,
    "commitTimestamp": 1714408224000,
    "commitNumber": 72779532308,
    "commitUser": "005ZM000000M6o1YAC",
    "nulledFields": [], "diffFields": [], "changedFields": []
  },
  "Subject": "Product Planning", "GroupEventType": "0",
  "CreatedDate": 1714408224000, "IsChild": false,
  "Recurrence2PatternText": "RRULE:FREQ=WEEKLY;BYDAY=MO;WKST=SU;INTERVAL=1;COUNT=13",
  "ActivityRecurrence2Id": "828ZM0000000001YAA"
}
```

#### Event Invitees

calendar event 레코드 외에 event invitee에 대해서도 change event가 생성된다. Salesforce 사용자가 calendar event에 초대되면 그 invitee를 위한 **child calendar event 레코드**가 생성된다. child calendar event는 **IsChild 필드가 true**이고 **OwnerId가 invitee의 user ID**인 Event 레코드다.

contact·lead·resource처럼 Salesforce 사용자가 아닌 invitee에게는 child calendar event가 **생성되지 않는다**. 추가된 invitee마다 calendar event와의 관계를 나타내는 **EventRelation** 레코드가 생성된다. recurring series에서는 각 occurrence마다 invitee용 child calendar event가 생성된다.

예를 들어 두 invitee와 함께 calendar event를 생성하면 Salesforce에 세 개의 calendar event 레코드(calendar event 1개 + invitee 2개)가 생성된다. 이 세 레코드는 Event 표준 객체 채널에서 세 change event를 낳는다. 추가로 두 EventRelation 레코드가 생성되어 EventRelation 채널에서 두 change event를 낳는다.

**예시:** calendar event를 생성하고 한 사용자를 초대할 때 Pub/Sub API 클라이언트에 전달되는 세 이벤트. 첫째는 calendar event용, 둘째는 invitee용 child calendar event(IsChild true, OwnerId = invitee user ID), 셋째는 EventRelation 레코드용.

```json
// Change event for the child calendar event record for the invitee.
{
  "ChangeEventHeader": {
    "entityName": "Event", "recordIds": ["00UZM00000165Pt2AI"],
    "changeType": "CREATE", "sequenceNumber": 2,
    "commitTimestamp": 1714411237000, "commitNumber": 72780631358
  },
  "Subject": "Meeting with Jane",
  "OwnerId": "005ZM000000MJSoYAO",
  "IsChild": true, "IsGroupEvent": true, "GroupEventType": "1"
}
// Change event for the EventRelation record.
{
  "ChangeEventHeader": {
    "entityName": "EventRelation", "recordIds": ["0REZM000000005o4AA"],
    "changeType": "CREATE", "sequenceNumber": 3,
    "commitTimestamp": 1714411237000, "commitNumber": 72780631358
  },
  "RelationId": "005ZM000000MJSoYAO", "EventId": "00UZM00000165Ps2AI",
  "IsWhat": false, "IsParent": false, "IsInvitee": true,
  "AccountId": null, "Status": "New", "RespondedDate": null, "Response": null
}
```

#### Updating Recurring Calendar Events

recurrence 패턴이나 recurrence 시작 날짜 변경 같은 critical 변경이 recurring calendar event에 가해지면 **series가 삭제·재생성된다**. recurring calendar event에 많은 invitee와 많은 occurrence가 있으면 critical 변경이 많은 change event를 낳을 수 있다. 예를 들어 100 occurrence·100 invitee인 calendar event의 recurrence 시작 날짜를 업데이트하면 **10,000개의 child Event 레코드(100 레코드 × 100 occurrence)와 10,000개의 EventRelation 레코드**가 삭제·재생성된다. 단일 트랜잭션 내 대량 변경은 **overflow event**를 생성할 수 있다.

#### Shared Activities and Parent Records for Tasks and Events

**Shared Activities**가 활성화되면 task와 그 parent 레코드(예: contact·lead) 간 관계(즉 **TaskRelation** 객체)가 change event로 추적된다. 마찬가지로 calendar event와 그 parent 레코드 간 관계(즉 **EventRelation** 객체)도 추적된다. task 관계의 change event는 `/data/TaskRelationChangeEvent` 채널에서, event 관계의 change event는 `/data/EventRelationChangeEvent` 채널에서 받을 수 있다. Shared Activities가 활성화되지 **않은** 경우 EventRelation 객체는 calendar event를 invitee와만 연결한다.

### Person Accounts

person account 레코드는 account와 contact의 필드를 결합하므로, person account를 변경하면 **두 change event(account용 하나, contact용 하나)**가 생성된다 — 단 두 객체 모두 change data capture용으로 선택된 경우다. 두 change event는 **create·update·delete·undelete**를 포함한 person account의 모든 변경에 대해 생성된다.

> **Note:** person account 레코드의 change event를 받으려면 **Account와 Contact 둘 다** change data capture용으로 활성화한다. Account만 선택되고 person account가 업데이트되면 account change event는 contact에서 유래한 필드(예: **PersonAssistantName** — contact의 AssistantName 필드에 대응 — 또는 contact 커스텀 필드)를 포함하지 않는다. 이 동작은 person account 생성·undelete 시에는 적용되지 않는다 — 이때는 Contact가 캡처용으로 선택되지 않았더라도 account change event가 contact 필드를 포함한다.

#### Creating and Undeleting a Person Account

person account 생성·undelete 시 account change event는 account와 contact 필드를 모두 포함한다. account 레코드 필드와 contact 레코드의 일부 필드를 포함한다. account change event가 포함하는 contact 필드는 **모든 contact 커스텀 필드와 Person 접두사로 시작하는 일부 표준 contact 필드**다. contact change event는 모든 contact 표준·커스텀 필드를 포함한다. contact change event는 person account의 account 필드를 포함하지 않는다. **Name 필드는 새로/undelete된 person account의 account와 contact change event 양쪽에 포함된다.**

```json
// Account change event — contact custom field ends with __pc suffix.
{
  "ChangeEventHeader": {
    "entityName": "Account", "recordIds": ["001ZL000001QS6mYAG"],
    "changeType": "CREATE", "sequenceNumber": 1
  },
  "Name": { "Salutation": "Ms.", "FirstName": "Martha", "LastName": "Brown" },
  "PersonContactId": "003ZL000001EDrPYAW",
  "PersonAssistantName": null,
  "CustomContactField__pc": "ABC"
}
// Contact change event — same custom field with __c suffix.
{
  "ChangeEventHeader": {
    "entityName": "Contact", "recordIds": ["003ZL000001EDrPYAW"],
    "changeType": "CREATE", "sequenceNumber": 2
  },
  "AccountId": "001ZL000001QS6mYAG", "IsPersonAccount": true,
  "Name": { "Salutation": "Ms.", "FirstName": "Martha", "LastName": "Brown" },
  "CustomContactField__c": "ABC"
}
```

#### Updating a Person Account

person account 업데이트 시 **어느 필드가 변경됐든** account용 하나·contact용 하나의 두 change event가 생성된다. Salesforce는 하나의 underlying 레코드에만 있는 필드가 업데이트되더라도 account와 contact 양쪽의 **LastModifiedDate** 시스템 필드를 항상 업데이트한다. person account는 하나의 account와 하나의 contact에 대응하므로 account·contact 레코드의 timestamp 필드가 일치해야 한다. account 전용 필드(예: Industry)가 업데이트되면 account change event는 변경 필드와 LastModifiedDate 필드를 포함하고, contact change event는 LastModifiedDate 필드만 포함한다. 업데이트된 필드가 contact에서 유래하거나 contact 커스텀 필드이면 두 change event 모두 모든 변경 필드와 LastModifiedDate 필드를 포함한다. 특히 person account의 first name·last name이 수정되면 해당 필드가 두 change event 모두에 포함된다.

#### Converting an Account

person account가 record type ID 수정을 통해 API로 **business account**로 변환되면 account용 change event가 생성된다. 이 change event는 account의 새 record type ID를 포함한다. 반대로 business account가 person account로 변환되면 새 record type ID를 가진 account change event가 생성된다.

#### Deleting a Person Account

person account 삭제 시 두 change event(삭제된 account용 하나, 삭제된 contact용 하나)가 생성된다. 이 change event들은 **레코드 필드를 포함하지 않는다. 이벤트 헤더 필드만 포함한다.**

### Users

change event의 user·email preference는 **enabled(true로 설정)된 preference만 Boolean 값 없이** 포함한다. disabled(false로 설정)된 preference는 이벤트 페이로드에 **포함되지 않는다**.

> **Note:** preference는 데이터베이스의 32-bit 정수 내부 필드에 저장된다. preference가 변경되면 대응하는 32-bit 정수 필드에서 변경이 감지되고, **그 내부 정수 필드로 표현되는 모든 enabled preference가 변경 여부와 무관하게 발행된다**.

```json
// User create change event — preferences under EmailPreferences and UserPreferences.
{
  "ChangeEventHeader": {
    "entityName": "User", "recordIds": ["0055f00000GBZR4AAP"],
    "changeType": "CREATE", "sequenceNumber": 1
  },
  "Username": "olga.brown@example.com",
  "EmailPreferences": ["AutoBcc", "StayInTouchReminder"],
  "UserPermissions": ["SFContentUser"],
  "ForecastEnabled": false,
  "UserPreferences": ["ActivityRemindersPopup", "EventRemindersCheckboxDefault",
    "TaskRemindersCheckboxDefault", "DisableLikeEmail", "SortFeedByComment",
    "ShowTitleToExternalUsers", "HideS1BrowserUI", "LightningExperiencePreferred",
    "HideSfxWelcomeMat"]
}
```

### Lead Conversion

lead를 변환하면 account·contact와 선택적으로 opportunity가 생성되고, **lead update**도 발생한다. lead 변환 시 lead update의 change event는 변환에 특화된 필드를 포함한다.

**lead 변환의 lead update change event에 포함되는 필드:**

| Field | Description |
|---|---|
| Status | lead 변환 status. 가능한 status 값은 LeadStatus 표준 객체에 있다. |
| IsConverted | lead가 변환되었는지 여부(true). |
| ConvertedDate | lead 변환 날짜. ConvertedDate는 시간을 포함하지 않는다. |
| ConvertedAccountId | lead 변환에서 생성된 account의 ID. |
| ConvertedContactId | lead 변환에서 생성된 contact의 ID. |
| ConvertedOpportunityId | lead 변환에서 생성된 opportunity의 ID. |

lead update의 change event는 **LastModifiedDate 필드를 포함하지 않는다.**

**sequenceNumber 순서:** 각 change event의 sequenceNumber 필드는 같은 트랜잭션 내 작업 순서를 나타낸다 — account 생성(1) → contact 생성(2) → opportunity 생성(3) → lead update(4).

```json
// Lead Update Change Event (sequenceNumber: 4)
{
  "ChangeEventHeader": {
    "entityName": "Lead", "recordIds": ["00Q5f000005bwLFEAY"],
    "changeType": "UPDATE", "sequenceNumber": 4,
    "changedFields": ["0x08F81000"]
  },
  "Status": "Closed - Converted",
  "IsConverted": true, "ConvertedDate": 1714089600000,
  "ConvertedAccountId": "0015f00002JUX1JAAX",
  "ConvertedContactId": "0035f00002EztxDAAR",
  "ConvertedOpportunityId": "0065f00000UloqVAAR",
  "LastModifiedDate": 1714153780000
}
```

**changedFields** bitmap 필드는 lead 레코드에서 변경된 필드를 포함한다. Pub/Sub API 클라이언트가 이 필드를 디코딩하면 변경 필드는 다음이다: Status, IsConverted, ConvertedDate, ConvertedAccountId, ConvertedContactId, ConvertedOpportunityId, LastModifiedDate.

### PricebookEntry

**Create Change Events payload는 시스템 필드를 포함하지 않는다** (`sCreatedById`, CreatedDate, LastModifiedById, LastModifiedDate). 이는 PricebookEntry 객체의 고도로 커스터마이즈된 특성 때문으로, 이 특정 필드들이 이벤트 생성 시점에 캡처되지 못하게 한다.

```json
// 구조 예시 — 실제 동작 설정 아님
// PricebookEntry Create payload에서 제외되는 시스템 필드 목록
{
  "excludedSystemFields": [
    "sCreatedById",   // 원문 오타 그대로 — CreatedById 의미
    "CreatedDate",
    "LastModifiedById",
    "LastModifiedDate"
  ]
}
```

> **Note (원문 오타 보존):** PDF는 ToC-매핑 intro와 이 하위 섹션 양쪽에서 필드명을 `sCreatedById`(선행 "s")로 문자 그대로 나열한다. CreatedById의 오타로 보이나 verbatim 재현한다.

### Fields / Data Differences

#### 업데이트 레코드의 데이터 차이 전송

이벤트 페이로드 크기를 줄이고 성능을 높이려 Salesforce는 업데이트된 텍스트 값의 **데이터 차이(data differences)**를 전송하기도 한다. Description이나 Long Text Area 필드처럼 **최소 1,000자(at least 1,000 characters)**를 포함하는 큰 텍스트 필드는 데이터 차이만 전송될 수 있다. 데이터 차이는 **unified diff 형식**을 쓴다. 값의 각 줄(line)마다 차이를 계산한다. diff 알고리즘은 값에서 찾은 줄바꿈으로 필드 값을 줄로 나눈다.

큰 텍스트 필드 업데이트의 diff를 보내도 필드 크기가 줄지 않으면 **전체 값이 전송된다**. 다음 조건에서는 diff 값이 **전송되지 않는다**:
- 필드 값 길이가 **1,000자 미만**이다.
- old·new 값의 차이가 **길이 기준 50%보다 크다**.
- old·new 값의 전체 줄 수 중 **25%를 초과**하는 줄이 변경됐다.
- diff의 길이가 new 값의 길이보다 크다.

diff 값은 전체 업데이트 값에 대해 계산된 **SHA-256 hash 값**을 포함한다. hash 값으로 재구성한 값이 diff로 변환되기 전 원본 값과 일치하는지 검증한다. diff 값을 확장한 후 SHA-256 hash를 계산하고 두 hash 값을 비교해 일치를 확인한다. SHA-256 hash 계산에는 UNIX `sha256sum` 명령이나 Apache Commons 라이브러리의 DigestUtils 클래스를 쓸 수 있다.

**Pub/Sub API 클라이언트** — 필드가 unified diff 값을 포함한다:
```
"<Field_Name>": "--- \n+++ <hash_value>\n
(Changes)"
```
unified diff로 값이 전송되는 필드는 ChangeEventHeader의 **diffFields**에 나열된다.

**Streaming API (CometD) 클라이언트** — 필드가 unified diff 값을 담는 **diff 서브필드**를 포함한다:
```json
"<Field_Name>": {
  "diff": "--- \n+++ <hash_value>\n
(Changes)"
}
```

#### diff 값에서 필드 재구성

diff 필드 값은 unified diff 형식이다. diff 유틸리티로 diff에서 전체 필드 값을 얻는다. 예를 들어 **Java Diff Utilities library**를 쓸 수 있다. `toLines()` 메서드(직접 구현)는 diff 값을 줄 목록으로 나눈다. BufferedReader Java 객체가 줄바꿈 문자 표현 방식을 판단하므로 newLine 값을 전달할 필요가 없다. `DiffUtils.parseUnifiedDiff()`로 diff 줄에서 patch를 얻는다. toLines()를 다시 호출해 원본 내용을 줄로 나눈다. `DiffUtils.patch()`로 patch를 원본 줄에 적용한다. `combineLines()`(직접 구현)로 업데이트된 줄을 하나의 문자열 변수로 결합한다. newLine 변수를 combineLines()에 전달해 원본 줄바꿈을 재도입하며, 원본 내용에 있던 줄바꿈 문자 시퀀스(`\r\n` 또는 `\n`)로 설정한다. 마지막으로 SHA-256 hash 값(Apache Common DigestUtils)을 생성해 원본 업데이트 값이 재구성 값과 일치하는지 검증하고, 이벤트로 전송된 hash와 비교해 두 값이 같은지 확인한다.

```java
public void BuildOriginalValueFromDiff(String original, String diff, String newLine) {
    // Split diff value into lines and get patches.
    List<String> diffLines = toLines(diff);
    Patch<String> patch = DiffUtils.parseUnifiedDiff(diffLines);
    // Split original text into lines.
    List<String> originalLines = toLines(original);
    // Apply patches to original lines, then combined lines.
    List<String> revisedLines = DiffUtils.patch(originalLines, patch);
    String revised = combineLines(revisedLines, newLine);
    // Generate SHA-256 hash on reconstructed value.
    String checkSum = DigestUtils.sha256Hex(revised);
    // Extract hash from the event diff field.
    // Compare extracted hash with generated hash and verify they are equal.
}

private List<String> toLines(String s) {
    BufferedReader rd = new BufferedReader(new StringReader(s));
    return rd.lines().collect(Collectors.toList());
}
private String combineLines(List<String> lines, String newLine) {
    StringBuilder sb = new StringBuilder();
    lines.forEach(l -> sb.append(l).append(newLine));
    sb.deleteCharAt(sb.length()-newLine.length()); // remove last newline added
    return sb.toString();
}
```

#### 줄바꿈 문자와 SHA-256 hash 계산 고려사항

Salesforce가 SHA-256 hash 생성에 쓰는 내용은 브라우저가 줄바꿈 문자를 변형했을 수 있다. 많은 브라우저는 레코드가 Salesforce에 저장되기 전 레코드 필드 값의 줄바꿈 문자를 `\r\n`으로 변형한다. 또한 Salesforce는 필드 값의 **선행·후행 공백을 잘라낸다(trims)**. SHA-256 hash를 생성하기 전, diff에서 재구성한 내용이 원본 내용과 같은 줄바꿈 문자를 포함하고 새 선행·후행 공백이 추가되지 않았는지 확인한다. 예를 들어 내용을 파일로 저장하면 운영체제가 후행 공백 문자를 추가할 수 있다.

> **Note:** API로 필드 값을 생성·업데이트했다면, 애플리케이션이 제공한 줄바꿈 문자가 추가 변형 없이 Salesforce에 저장된다.

Windows 시스템은 줄바꿈 문자를 carriage return + line-feed 시퀀스(`\r\n`)로 표현한다. UNIX와 macOS·Linux 같은 UNIX 기반 시스템은 줄바꿈 문자를 line-feed 문자(`\n`)로 표현한다.

### Custom Field Type Conversions

커스텀 필드의 type을 변경하면 일부 변환에 대해 데이터 변경용 change event 또는 gap event가 생성된다. 값을 보존하거나 절단하는 변환 같은 다른 변환은 이벤트를 생성하지 않는다.

#### Change Event를 생성하는 변환

커스텀 필드 type을 **호환되지 않는(isn't compatible)** 다른 type으로 변환하면 필드 데이터가 손실되어 그 객체에 대응하는 레코드에서 null로 설정된다. **영향받은 모든 레코드에 대해 하나의 change event가 생성되며, 이벤트 메시지는 레코드 필드를 포함하지 않는다.**

**비호환** 필드 변경 예:
- **Date 또는 Date/Time** 필드를 다른 필드 type으로, 또는 그 반대로 변경
- **Checkbox** 필드를 다른 필드 type으로 변경
- **Picklist (Multi-Select)** 필드를 다른 필드 type으로 변경

필드 type 변환은 많은 레코드에 영향을 줄 수 있으므로 이벤트 메시지의 **recordIds** 헤더 필드 값은 레코드 ID 배열 대신 **wildcard 값**을 포함한다. 이 값은 3자리 객체 ID 접두사로 시작하고 wildcard 문자 `*`가 뒤따른다. 예를 들어 Account 커스텀 필드의 경우:

```json
"ChangeEventHeader": {
  "entityName": "Account",
  "recordIds": ["001*"],
  ...
}
```

#### Gap Event를 생성하는 변환

일부 **Picklist에서의** 필드 변환에 대해 영향받은 모든 레코드에 **gap event**가 생성된다. gap event 메시지의 change event 헤더는 레코드 ID와 change type **GAP_UPDATE**를 포함한 레코드 정보를 담는다.

gap event를 생성하는 필드 type 변환:
- **Picklist** 필드를 **Checkbox**로 변경
- **Picklist** 필드를 **Picklist (Multi-Select)**로 변경

#### 이벤트를 생성하지 않는 변환

필드 데이터를 보존하거나 절단하는 커스텀 필드 type 변환, 그리고 Picklist와 Text 필드 간 변환에는 change event나 gap event가 생성되지 않는다.

**데이터 변경 없는 호환 필드 type** — 필드 type을 호환되는 다른 type으로 변환하면 필드 데이터가 변경되지 않고 이벤트가 생성되지 않는다. 호환 변환:
- **Text Area, Email, Url, Phone, Autonumber, Number, Percent, Currency** 필드를 **Text** 필드로 변경
- **Text** 필드를 **Text Area, Text Area (Long), Email, Url, Phone, Autonumber** 필드로 변경

**기타 필드 type 변환** — 다음도 이벤트를 생성하지 않는다:
- **Picklist** 필드를 **Text** 필드로 변경
- **Text** 필드를 **Picklist** 필드로 변경
- 대상 필드 type 크기가 더 작아 데이터가 절단되는 변환, 예를 들어 **Text Area (Long)** 필드를 **Text, Text Area, Email, Url, Phone** 필드로 변경

---

## 관련 노트
- [[Change Data Capture — 개요·채널 구독]]
- [[Change Data Capture — 이벤트 메시지·Gap·Overflow]]
- [[Change Data Capture — Enrichment·필터링]]
- [[Change Data Capture — 커스텀 채널]]
- [[ChangeEventHeader]]
- [[ChangeEvent Objects]]
