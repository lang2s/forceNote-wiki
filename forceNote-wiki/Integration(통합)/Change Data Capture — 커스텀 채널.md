---
tags: [integration, change-data-capture, cdc, custom-channel, platform-event-channel, metadata-api, tooling-api]
source: salesforce_change_data_capture.pdf (Change Data Capture Developer Guide, Version 66.0, Spring '26)
created: 2026-07-13
aliases: [CDC 커스텀 채널, custom channel, PlatformEventChannel, PlatformEventChannelMember, __chn, 채널 멤버, compose streams, 커스텀 채널 만들기, SalesEvents__chn]
---

# Change Data Capture — 커스텀 채널

> 여러 객체의 change event를 구독자별 스트림으로 묶고 격리하는 커스텀 채널(`/data/YourChannelName__chn`) — Metadata API·Tooling API로만 생성하며 UI에서는 불가.

---

## 커스텀 채널이란 / 왜 쓰는가

**커스텀 채널(custom channel)** 은 change event를 구독자별로 그룹화·격리하는 스트림이다. 다음 상황에서 만든다.

- **구독자가 여러 명이고, 각 구독자가 서로 다른 엔티티 집합에서 change event를 받아야 할 때.** 커스텀 채널은 change event를 구독자별로 그룹화·격리하므로, 각 구독자는 자신이 필요로 하는 이벤트 타입만 받는다.
- **이벤트 강화(event enrichment)와 함께** 커스텀 채널을 사용해, 특정 채널에서만 강화 필드(enriched fields)를 격리 전송하고 싶을 때.

커스텀 채널에 포함되는 엔티티는 채널 생성 시 change event 알림용으로 **자동 선택(automatically selected)** 된다. 구독자는 자신이 구독한 채널에서 선택된 엔티티의 change event만 받고, 다른 채널에서 선택된 엔티티의 change event는 받지 않는다.

> PDF 원문(예시): *"if a subscriber uses real-time information about sales objects such as Account, Contact, or Order, you can create a custom channel with these objects. When you subscribe to the custom channel, you receive change events only for these objects. Your subscriber doesn't receive change events of entities selected in another channel."*

### 표준 `ChangeEvents` 채널과의 차이

| 구분 | 표준 `ChangeEvents` 채널 | 커스텀 채널 (`__chn`) |
|---|---|---|
| 대상 | Change Data Capture 페이지에서 선택한 모든 엔티티가 한 스트림에 | 구독자별로 엔티티 부분집합을 격리 |
| 생성/조작 (API 47.0+) | `PlatformEventChannel`로 **표현·생성·수정 불가**(표준 채널) | Metadata API·Tooling API로 생성·수정 |
| 강화 필드·필터 | 추가 가능하나 **권장하지 않음**(격리 안 됨) | 권장 — 채널 단위로 격리 |
| UI | Change Data Capture 페이지에서 관리 | UI에서 생성·조회 **불가** |

> PDF 원문: 표준 채널에도 강화 필드·필터를 *"add them to members belonging to the ChangeEvents channel"* 할 수는 있으나 *"it's best to add them on custom channels"* — 다중 구독자 시 강화 이벤트 격리를 위해 커스텀 채널이 최선이라고 명시.

---

## 채널 경로 규칙

커스텀 채널의 구독 채널 경로는 다음 형식이다.

```
/data/YourChannelName__chn
```

예: 채널 이름이 `SalesEvents`이면 구독 채널은 다음과 같다.

```
/data/SalesEvents__chn
```

- 채널 이름 뒤에 `__chn` 접미사가 붙는다.
- 이 슬라이스에는 채널 멤버(`__mbr`) 접미사·멤버 개수 한도가 언급되지 않는다 — 상세는 아래 "필드 요약" 및 위임 노트 참조.

---

## 만들기·조회 방법

커스텀 채널은 **Metadata API 또는 Tooling API**로만 생성·조회한다. **UI(Change Data Capture 페이지)에서는 생성·조회할 수 없다.**

| 방법 | 동작 |
|---|---|
| **Metadata API** | 지원 도구로 org에 채널 메타데이터를 **deploy / retrieve** |
| **Tooling API** | **REST**로 채널 생성, **SOQL**로 채널 메타데이터 쿼리 |
| **패키징** | 채널을 **패키지에 담아 앱과 함께 배포 가능**(package channels to distribute with your apps) |

채널 생성 시, `PlatformEventChannelMember`를 추가할 때 해당 오브젝트가 알림용으로 선택된다.

### Metadata type ↔ Tooling object 매핑

| API | 채널 생성 | 선택된 이벤트 엔티티 추가 |
|---|---|---|
| **Metadata API** | `PlatformEventChannel` (metadata type) | `PlatformEventChannelMember` (metadata type) |
| **Tooling API** | `PlatformEventChannel` (object) | `PlatformEventChannelMember` (object, REST 생성 · SOQL 쿼리) |

> 상세 정의(필드 타입·XML 정의)는 이 슬라이스에 없다. 각각 **Metadata API Developer Guide** 및 **Tooling API**의 `PlatformEventChannel` · `PlatformEventChannelMember` 문서를 참조.

---

## 채널 ↔ 멤버 관계 (ERD)

> ⚠️ 원본 PDF에는 채널과 채널 멤버의 관계를 나타내는 **Entity Relationship Diagram(ERD)** 이 이미지로 있으나, pdftotext가 이 다이어그램을 **전혀 캡처하지 못했다**(Pattern C). 박스 배치·화살표 방향은 원본에서 확인 불가하므로 아래는 **텍스트 단서(cardinality 규칙)만** 재현한 것이다.

ERD는 채널(channel)과 채널 멤버(channel member) 엔티티, 그리고 둘 사이 관계를 보여준다. 엔티티는 Metadata API·Tooling API에서 대응하는 타입·오브젝트로 접근한다.

**카디널리티 규칙 (PDF 원문 그대로):**

- A channel can have **zero or more** channel members. → 채널 : 채널멤버 = **0..\***
- A channel member can have **zero or more enriched fields**. → 채널멤버 : 강화필드 = **0..\***
- A channel member can have **zero or one filter expression**. → 채널멤버 : 필터표현식 = **0..1**

강화 필드·필터 표현식은 Metadata API 또는 Tooling API의 `PlatformEventChannelMember` 엔티티를 통해 추가·수정한다.

**FullName 제외:** 이 ERD의 엔티티에는 `FullName` 필드가 **포함되지 않는다.** `FullName`은 Metadata API 컴포넌트 또는 Tooling API 오브젝트의 고유 이름이며, 이들에 대한 작업(operation) 수행에 사용된다.

**API 47.0+ 표준 채널 제약:** API 버전 47.0 이상에서 Metadata API·Tooling API의 `PlatformEventChannel`은 **커스텀 채널만 나타내며, 표준 `ChangeEvents` 채널은 나타내지 않는다.**

- `ChangeEvents` 표준 채널은 **생성 불가**(can't create).
- `ChangeEvents` 표준 채널 속성 `ChannelType`과 `Label`은 **수정 불가**(can't modify).

아래는 위 카디널리티 규칙을 텍스트로 재현한 구조 예시다(원본 ERD는 텍스트로 재현).

```
// 구조 예시 — 실제 원본 다이어그램 아님 (원본 ERD는 pdftotext 미캡처, 텍스트 단서로 재현)
PlatformEventChannel (channel)
        │ 1
        │
        │ 0..*
PlatformEventChannelMember (channel member)
        ├── EnrichedFields ............ 0..*  (강화 필드)
        └── Filter expression ......... 0..1  (필터 표현식)

* FullName 필드는 ERD 표현에서 제외(엔티티 고유 이름, operation 수행용)
```

---

## 예제 채널 구성

> ⚠️ 아래 4개 예시는 원본 PDF에서 각각 다이어그램(박스 관계도)으로 제시되나 pdftotext가 캡처하지 못했다(Pattern C). 다이어그램의 박스 배치·화살표는 재현하지 않고, 캡션·본문 산문에 명시된 엔티티 구성만 그대로 옮긴다.

### 예 1 — ChangeEvents 표준 채널

- 선택 엔티티 4개: **Account, Contact, Opportunity, Case**.
- 이 채널 멤버들은 **강화 필드나 필터 표현식을 포함하지 않는다.** ChangeEvents 채널 소속 멤버에도 추가할 수는 있으나, 다중 구독자 사용 시 강화 이벤트를 격리하려면 **커스텀 채널에 추가하는 것이 최선.**
- 이 다이어그램에서 ChangeEvents 채널은 `PlatformEventChannel` 엔티티로 표현되지 않는다 — API 47.0 이상에서 표준 채널은 Metadata API·Tooling API로 직접 조작할 수 없기 때문.
- `AccountChangeEvent` 선택 엔티티는 다음 커스텀 채널 예시들에도 등장한다: 한 커스텀 채널에서는 강화 필드를 포함하고, 다른 커스텀 채널에서는 필터 표현식을 포함한다. 이 필드들은 ChangeEvents 채널에는 없으므로 이 채널 구독자에게 전송되지 않는다.

### 예 2 — `SalesEvents__chn` 커스텀 채널 (강화 필드)

- 채널 이름: **`SalesEvents__chn`**.
- 선택 엔티티: ChangeEvents 채널 선택 엔티티의 부분집합인 **Account, Contact** + 다른 엔티티 **Order** 하나.
- 채널 멤버의 선택 엔티티 중 하나인 `AccountChangeEvent`는 `EnrichedFields` 필드에 **강화 필드 2개**를 포함한다.
- `EnrichedFields` 필드는 각 강화 필드 이름을 담은 **배열(array)** — 여기서는 **`Industry`** 필드와 **`Phone`** 필드.
- 강화 필드 값은 이 채널의 account change event에서 이용 가능하며, 별도 지정이 없으면 다른 채널에서는 이용할 수 없다.

### 예 3 — `HREvents__chn` 커스텀 채널 (필터 표현식)

- 채널 이름: **`HREvents__chn`**. HR 앱 관련 엔티티용 — **Account** 및 커스텀 오브젝트 **`Employee__c`**.
- `HREvents__chn` 채널은 `AccountChangeEvent` 멤버에 대한 **필터 표현식**을 포함한다. 필터 기준: **`Industry = Agriculture`** — Industry 필드가 Agriculture인 account의 change event만 전달한다.
- `Employee__ChangeEvent` 채널 멤버는 필터가 없으므로 **모든 `Employee__c` 이벤트**가 해당 채널에서 전달된다.

**`AccountChangeEvent`의 세 채널 비교** (같은 엔티티가 세 채널 멤버에 걸쳐 다르게 전달됨):

| 채널 | 구독자가 받는 account change event |
|---|---|
| `ChangeEvents` (표준) | 강화 필드·필터 **없는** account change event |
| `SalesEvents__chn` (커스텀) | `Industry`·`Phone` 필드 값으로 **강화**된 account change event (필터 없음) |
| `HREvents__chn` (커스텀) | 필터 기준(`Industry = Agriculture`)에 맞는 account change event만. 강화 필드는 지정되지 않았으나 **필터링의 자동 강화(auto-enrichment) 기능** 때문에 `Industry` 필드로 강화됨 |

> PDF 원문: *"No enriched fields are specified, but the account change events received on the HREvents__chn channel are enriched with the Industry field due to filtering's auto-enrichment feature."*

---

## 필드 요약

이 슬라이스의 산문에 언급된 필드·속성만 정리한다.

| 필드/속성 | 소속 | 설명 |
|---|---|---|
| `ChannelType` | 채널 속성 | 표준 `ChangeEvents` 채널에서는 **수정 불가**(API 47.0+) |
| `Label` | 채널 속성 | 표준 `ChangeEvents` 채널에서는 **수정 불가**(API 47.0+) |
| `EnrichedFields` | 채널 멤버 | 강화 필드 이름을 담은 **배열(array)**. 예: `[Industry, Phone]` |
| filter expression | 채널 멤버 | 멤버당 **0..1**개. 예: `Industry = Agriculture`. 필터링 시 auto-enrichment 발생 |
| `FullName` | 채널/멤버 | Metadata/Tooling 컴포넌트의 고유 이름. operation 수행용 — ERD 표현에서는 제외 |

> ⚠️ 이 슬라이스에는 `PlatformEventChannel` / `PlatformEventChannelMember`의 **전체 필드 스키마·필드 타입 표·XML 정의가 없다.** 또한 멤버 접미사(`__mbr`)·멤버 수치 한도(멤버 개수 제한 등)도 이 슬라이스에는 없다(카디널리티는 "zero or more" 정성 규칙만).
> - **상세 필드 스키마·XML 정의** → Metadata API Developer Guide / Tooling API의 `PlatformEventChannel` · `PlatformEventChannelMember` 참조.
> - **정량 한도(채널·멤버 수치 할당량)** → [[Change Data Capture — 고려사항·할당량·표준객체]] 참조.
> - **강화 필드·필터링 상세** → [[Change Data Capture — Enrichment·필터링]] 참조.

---

## 관련 노트

- [[Change Data Capture — 개요·채널 구독]] — CDC 개요·표준 채널 구독
- [[Change Data Capture — Enrichment·필터링]] — 강화 필드·필터 표현식 상세
- [[Change Data Capture — 고려사항·할당량·표준객체]] — 채널·멤버 수치 한도·할당량
- [[Pub-Sub API (gRPC) — Platform Event·CDC 구독]] — 커스텀 채널 구독 방법(gRPC)
- [[ChangeEventHeader]] — change event 페이로드의 헤더 필드
