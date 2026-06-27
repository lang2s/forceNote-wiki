---
tags: [agent-skill, sf-skills, integration, cdc, change-data-capture, platform-event-channel]
source: forcedotcom/sf-skills (skills/integration-eventing-cdc-configure/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [integration-eventing-cdc-configure, CDC 활성화 구성, Change Data Capture, PlatformEventChannelMember, PlatformEventChannel, EnrichedField, 변경 이벤트 필터]
---

# integration-eventing-cdc-configure — Change Data Capture 활성화 메타데이터 생성

> CDC 구독 메타데이터(`PlatformEventChannelMember`·`PlatformEventChannel`)를 enrichment field·filter expression과 함께 생성한다. Metadata API가 실제로 수락하는 canonical 네이밍·값 형식에 집중.

## 목적과 활성화 조건

`metadata.version: 1.0`

**TRIGGER:** "enable CDC", "turn on CDC", "subscribe X to change events", "only emit events for", "filter change events", "enrich change events", "create a custom event channel"; CDC·change events·`PlatformEventChannel`·`PlatformEventChannelMember`·`EnrichedField`·`ChangeEvents` channel·enrichment field·change event filter 언급; downstream 시스템이 Salesforce 데이터 변경을 수신하길 원할 때; `.platformEventChannelMember-meta.xml` / `.platformEventChannel-meta.xml` 파일 작업.

**SKIP:** platform event 발행·Pub/Sub API·REST/SOAP → [[integration-connectivity-generate]]; `ManagedEventSubscription`(CDC 범위 밖) → [[integration-eventing-subscription-configure]]. **CDC channel-membership metadata는 항상 이 스킬 사용.**

**In scope:** CDC용 `PlatformEventChannelMember`·`PlatformEventChannel` 생성, 표준/커스텀 객체 구독, enrichment field, filter expression, 커스텀 data channel 정의.
**Out of scope:** custom platform event(`PlatformEvent`) 발행, Pub/Sub API·외부 Kafka/Bayeux, pricing/limits([CDC Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.change_data_capture.meta/change_data_capture/) 참조), Apex event-bus subscriber.

## 워크플로 / 단계

모든 단계는 순차적. 건너뛰거나 재정렬 금지.

> **생성 전 — 유효한 CDC metadata type은 둘뿐:** `PlatformEventChannelMember`(구독 entity당 1개)와 `PlatformEventChannel`(커스텀 channel만). `<ChangeDataCapture>`, `.changeDataCapture-meta.xml`, `changeDataCapture/` 디렉토리, `EnableChangeDataCapture`, `ManagedEventSubscription`은 CDC 범위 밖 — 사용 금지.

### 1. Channel 식별
커스텀 channel 이름을 주면 `PlatformEventChannel` 파일 생성(step 4). 아니면 기본 channel의 리터럴 값 `ChangeEvents` 사용.

### 2. Source entity → ChangeEvent entity name 변환
`<selectedEntity>`는 **ChangeEvent** type이지 source 객체가 아니다:

| Source 객체 | `<selectedEntity>` 값 |
|---|---|
| `Account` | `AccountChangeEvent` |
| `Lead` | `LeadChangeEvent` |
| `Contact` | `ContactChangeEvent` |
| `Order__c` (custom) | `Order__ChangeEvent` |
| `MyThing__c` (custom) | `MyThing__ChangeEvent` |

표준 객체: `ChangeEvent` append. 커스텀 객체: 끝의 `__c`를 `__ChangeEvent`로 교체(double-underscore 보존).

### 3. Channel-member 파일 생성
`(entity, channel)` 쌍당 1개 파일. **파일명과 fullName은 entity stem과 `ChangeEvent` 사이에 항상 SINGLE underscore** — 이는 XML 본문의 `selectedEntity` 형식과 무관하다. 커스텀 객체는 파일명 형성 시 `__c` 제거:

| Source 객체 | 파일명 (= fullName) | `<selectedEntity>` (XML 내) |
|---|---|---|
| `Account` | `Account_ChangeEvent.platformEventChannelMember-meta.xml` | `AccountChangeEvent` |
| `Lead` | `Lead_ChangeEvent.platformEventChannelMember-meta.xml` | `LeadChangeEvent` |
| `Order__c` | `Order_ChangeEvent.platformEventChannelMember-meta.xml` (`Order__ChangeEvent` 아님) | `Order__ChangeEvent` |
| `MyThing__c` | `MyThing_ChangeEvent.platformEventChannelMember-meta.xml` (`MyThing__ChangeEvent` 아님) | `MyThing__ChangeEvent` |

> 커스텀 객체 케이스가 가장 실수하기 쉽다 — 파일명은 single underscore, `selectedEntity`는 double underscore 유지.

`assets/PlatformEventChannelMember-template.xml`(verbatim):

```xml
<?xml version="1.0" encoding="UTF-8"?>
<PlatformEventChannelMember xmlns="http://soap.sforce.com/2006/04/metadata">
    <!-- Optional: add one <enrichedFields><name>FIELD_API_NAME</name></enrichedFields> per field. Single-hop API names only (e.g. OwnerId, ParentId, MyLookup__c, Region__c). -->

    <!-- Default CDC channel: ChangeEvents (no path prefix). For a custom channel, use its DeveloperName, e.g. PartnerSync__chn. -->
    <eventChannel>ChangeEvents</eventChannel>
    <!-- Optional: add <filterExpression>YOUR_PREDICATE</filterExpression> if needed (predicate body only, no WHERE keyword). -->

    <!-- ChangeEvent entity name. Standard: <Object>ChangeEvent. Custom: replace __c with __ChangeEvent. -->
    <selectedEntity>AccountChangeEvent</selectedEntity>
</PlatformEventChannelMember>
```

### 4. 커스텀 channel — `PlatformEventChannel` 파일 생성
member가 non-default channel을 참조하면 필요. 사용자 label에서 DeveloperName 유도: 공백·비영숫자 제거 → CamelCase → **항상** 리터럴 suffix `__chn` append. 파일명과 channel의 `<eventChannel>` 참조는 이 형식이어야 하며, 아니면 `Invalid channel name`으로 배포 실패:

| 사용자 입력 | DeveloperName | 파일명 |
|---|---|---|
| `Partner Sync` | `PartnerSync__chn` | `PartnerSync__chn.platformEventChannel-meta.xml` |
| `Order Updates` | `OrderUpdates__chn` | `OrderUpdates__chn.platformEventChannel-meta.xml` |
| `data sync` | `DataSync__chn` | `DataSync__chn.platformEventChannel-meta.xml` |

member는 동일 DeveloperName으로 참조: `<eventChannel>PartnerSync__chn</eventChannel>`.

`assets/PlatformEventChannel-template.xml`(verbatim):

```xml
<?xml version="1.0" encoding="UTF-8"?>
<PlatformEventChannel xmlns="http://soap.sforce.com/2006/04/metadata">
    <channelType>data</channelType>
    <label>My Custom Channel</label>
</PlatformEventChannel>
```

### 5. Enrichment field 추가(요청 시)
필드마다 `<enrichedFields><name>FIELD_API_NAME</name></enrichedFields>` 블록 반복. name은 source entity의 **single-hop API name**이어야 함 — 검증됨: standard lookup ID(`OwnerId`, `ParentId`), custom lookup(`MyLookup__c`), custom 비관계 필드(`Region__c`, `Status__c`). `Owner.Name`·`Parent.Account.Industry` 같은 relationship traversal은 "The selected field, X.Y, isn't valid"로 거부.

### 6. Filter expression 추가(요청 시)
predicate를 `<filterExpression>...</filterExpression>`로 감쌈. body는 `WHERE` 키워드 없는 WHERE-clause body(예: `Status__c != null`, `WHERE Status__c != null` 아님). 지원 operator·field type·함정은 `references/filter-expressions.md` 참조.

## 핵심 규칙·가드레일

| 제약 | 근거 |
|---|---|
| `<selectedEntity>`는 ChangeEvent type name(source 객체명 아님) | `Account`를 직접 넘기면 "invalid event in selectedEntity" 실패 |
| Member fullName은 **single** underscore: `Account_ChangeEvent` | double-underscore(`Account__ChangeEvent`)는 `<namespace>__<name>`으로 파싱되어 "Cannot create a new component with the namespace: Account" 거부 |
| 기본 channel 값은 정확히 `ChangeEvents` — path prefix 없음 | 옛 fixture는 `data/ChangeEvents`를 보이나 배포가 "Unable to find the specified channel" 반환 |
| Enrichment field는 source entity의 single-hop API name | standard(`OwnerId`), custom lookup(`MyLookup__c`), custom 비관계(`Region__c`) 모두 검증; traversal(`Owner.Name`)은 거부 |
| `<filterExpression>` body에 `WHERE` 키워드 없음 | "filter expression has syntax errors: unexpected token: 'WHERE'" |
| filter는 `IsDeleted` 참조·relationship traversal(`Owner.Username`) 불가 | "field is invalid" |
| DateTime 필드는 filter에서 **equality만**(`=`, `!=`), `<` / `>` 불가 | "Only equality operators are supported for this field type or value"; named date literal 사용: `LastModifiedDate = TODAY` |
| filter RHS는 literal — field-to-field 비교 금지 | `BillingCity = ShippingCity`는 "unexpected token: 'ShippingCity'" |
| Compound 필드(예: `BillingAddress`)는 filter에서 dotted component 접근 필요 | `BillingAddress.City = 'X'` 배포됨; flat `BillingCity` 거부; raw `BillingAddress` 거부. **이는 flat name을 쓰는 `<enrichedFields>`와 반대** |
| 커스텀 channel 파일명은 meta-xml suffix 앞에 `__chn` | MDAPI 네이밍 규칙; 불일치 시 deploy ambiguity |
| 커스텀 channel XML은 `<channelType>data</channelType>` 포함 필수 | `data` 없으면 CDC용으로 거부(streaming/event channel용 type 별도 존재) |
| source 커스텀 객체가 이미 존재(또는 동일 트랜잭션 배포)해야 함 | `Foo__c`의 ChangeEvent entity는 `Foo__c` 존재 전엔 없음 |
| 기본 `ChangeEvents` channel용 `PlatformEventChannel` 파일 생성 금지 | 기본 channel은 시스템 제공; member에서 `<eventChannel>ChangeEvents</eventChannel>`로 참조만, 커스텀(`__chn`)만 channel-meta 파일 필요 |
| `PlatformEventChannelMember`는 4개 요소만 수락: `<enrichedFields>`, `<eventChannel>`, `<filterExpression>`, `<selectedEntity>` | `<description>`·`<isActive>`·`<masterLabel>` 등 추가 시 "Element {...} invalid at this location" |
| `PlatformEventChannel`은 2개 요소만 수락: `<channelType>`, `<label>` | `<masterLabel>` 등 추가 시 거부 — `<masterLabel>` 아닌 `<label>` 사용 |
| 생성 metadata 파일만 — 이 스킬에서 `sf project deploy start` 실행 금지 | 이 스킬은 artifact 생산; 배포는 별도 lifecycle |

### Gotchas

| 이슈 | 해결 |
|---|---|
| `Unable to find the specified channel` | `<eventChannel>ChangeEvents</eventChannel>`(`data/` prefix 없이) |
| `references an invalid event in the "selectedEntity" field` | source 객체 아닌 ChangeEvent name: `AccountChangeEvent` |
| `Cannot create a new component with the namespace: <Object>` | single underscore로 rename: `Account_ChangeEvent...` |
| `The selected field, X.Y, isn't valid` (`<enrichedFields>`) | `Owner.Name`을 `OwnerId`로 — CDC가 lookup 자동 enrich, single-hop만 유효 |
| `unexpected token: 'WHERE'` | `WHERE` 키워드 제거 |
| flat Address component 거부 | compound dotted form: `BillingAddress.City` |
| 커스텀 객체 member "ChangeEvent doesn't exist" | source 객체 미배포 — 동일 deploy에 포함 또는 org에 존재 |
| `DUPLICATE_VALUE` (2차 deploy) | 이미 구독됨 — 먼저 삭제 또는 skip(CDC member는 upsert 미지원) |
| `.changeDataCapture-meta.xml`에 `Could not infer a metadata type` | 그 확장자·type 미존재 — `platformEventChannelMembers/<Entity>_ChangeEvent.platformEventChannelMember-meta.xml`로 교체 |
| "subscribe Order__c"인데 표준 `Order` 의미 | 확인 — `OrderChangeEvent`(표준)와 `Order__ChangeEvent`(커스텀)는 다른 entity |

## 번들 파일

- **assets/** — `PlatformEventChannelMember-template.xml`(step 3 구조), `PlatformEventChannel-template.xml`(step 4 구조)
- **references/** — `filter-expressions.md`(step 6 — 지원 operator·field-type 매트릭스), `deploy-troubleshooting.md`(dry-run deploy 에러 → metadata-side fix 매핑)

> 산출물 검증: `sf project deploy start --dry-run -d <path> --target-org <alias>`로 dry-run 후 배포.

## 관련 노트
- [[integration-eventing-subscription-configure]]
- [[integration-connectivity-generate]]
- [[platform-custom-object-generate]]
- [[ChangeEventHeader]] — CDC 변경 이벤트 헤더 위키 노트
- [[Platform Event 정의와 구독]] — PE 정의·구독 패턴
- [[Metadata Types — Integration & Platform]] — PlatformEventChannel 메타타입
