---
tags: [Service, Chat, LiveAgent, PreChatAPI, findOrCreate, Visualforce, 채팅]
source: chat_dev_guide
created: 2026-06-18
aliases: [Pre-Chat API, pre-chat form, findorcreate, doFind, isExactMatch, doCreate, displayToAgent, preChatInit, 프리챗, 방문자 정보 수집]
---

# Pre-Chat API — 방문자 정보 수집 & 컨텍스트 설정

> [!warning] 레거시 Chat 제품은 2026년 2월 14일 은퇴했습니다. 신규 채널 구현은 권장되지 않으며, **Messaging for In-App and Web**로 이전하세요. 이 노트는 마이그레이션·이력 참조용입니다.

> Pre-Chat API 9개 메서드 전수. 고객이 pre-chat 폼(Visualforce `<input type="hidden">`)을 작성할 때 레코드를 자동 검색·생성하는 `findOrCreate.map` 계열(숨은 `doFind`/`isExactMatch`/`doCreate` 포함)과 `saveToTranscript`/`showOnCreate`/`linkToEntity`/`displayToAgent`, 그리고 deployment 정보를 가져오는 `preChatInit`을 다룬다.

---

## Ch5 개요 — Use Pre-Chat to Gather Visitor Information and Set Context for the Agent

pre-chat 폼으로 방문자 정보를 수집하고 pre-chat 경험을 커스터마이즈한다. pre-chat 폼은 고객 이름·이메일·문의 사유 등의 정보를 모아 채팅 요청을 더 효율적으로 라우팅하고, 에이전트가 직접 정보를 수집하는 시간을 줄인다. 이 정보로 채팅 중 고객 경험을 커스터마이즈할 수도 있다(예: chat window에 고객의 이름 표시). pre-chat 폼은 Visualforce 페이지로 호스팅하거나 직접 개발할 수 있다 — 이 가이드는 Visualforce 사용에 초점을 둔다.

**하위 섹션 2개:** Find and Create Records Automatically with the Pre-Chat APIs / Access Chat Details with the Pre-Chat APIs.

> 9개 메서드 구성: Pre-Chat API는 VF `<input type="hidden">` 형태다. ①`findOrCreate.map` ②`findOrCreate.map.doFind` ③`findOrCreate.map.isExactMatch` ④`findOrCreate.map.doCreate` ⑤`findOrCreate.saveToTranscript` ⑥`findOrCreate.showOnCreate` ⑦`findOrCreate.linkToEntity` ⑧`findOrCreate.displayToAgent` ⑨`preChatInit`. (②③④는 본문에는 H3로 존재하나 TOC에서 누락된 숨은 서브메서드.)
>
> Deployment API판 `findOrCreate` 계열은 [[Deployment API — 레코드 자동 검색·생성·자동 채팅 초대 & 코드 샘플]] 참조.

---

## Find and Create Records Automatically with the Pre-Chat APIs (개요)

Pre-Chat API로 고객이 pre-chat 폼을 작성하면 고객 레코드를 자동으로 검색·생성한다.

---

## ① findOrCreate.map (Pre-Chat판)

특정 고객 detail을 포함하는 레코드를 검색·생성한다.

**Usage:** 고객이 작성한 pre-chat 폼에 지정된 고객 데이터를 포함하는 레코드를 검색·생성한다. 이 메서드는 custom detail의 값을 Salesforce console의 지정 레코드 필드에 매핑한다. 적절한 레코드를 찾기 위해 필요한 만큼 여러 번 호출할 수 있다. 여러 필드와 대응 detail을 나열해 detail 값을 레코드의 적절한 필드에 매핑할 수 있다. API versions 29.0 이상.

**Syntax:**

```html
<input type= "hidden" name= "liveagent.prechat.findorcreate.map: String entityName"
value= "String fieldName, String detailName;" />
```

| Name | Type | Description | Available Versions |
|---|---|---|---|
| entityName | String | The type of record to search for or create when an agent accepts a chat with a customer, for example, a contact record | Available in API versions 29.0 and later. |
| fieldName | String | The name of the field in the record EntityName to which to map the corresponding custom detail value | Available in API versions 29.0 and later. |
| detailName | String | The value of the custom detail to map to the corresponding field fieldName | Available in API versions 29.0 and later. |

**하위 메서드:** `findOrCreate.map.doFind`, `findOrCreate.map.isExactMatch`, `findOrCreate.map.doCreate`.

### ② findOrCreate.map.doFind

고객이 pre-chat 폼을 작성할 때 기존 고객 레코드를 어떤 필드로 검색할지 지정한다.

**Usage:** `findOrCreate.map`에서 기존 레코드를 검색하는 데 사용할 필드를 지정한다. 하나 이상의 필드로 검색할 수 있으나, 여러 필드를 지정하면 논리 관계는 **AND**다 — 지정한 모든 필드가 기존 레코드와 일치해야 찾을 수 있다.

custom field 사용 시 지침:

- Checkbox는 검색·생성 시 유효 값이 `true`/`false`다.
- Date는 `YYYY-MM-DD` 형식을 쓴다.
- Currency 필드 숫자에는 통화 기호를 넣지 않는다.
- Percentage 필드 숫자에는 퍼센트 기호를 넣지 않는다.

API versions 29.0 이상.

**Syntax:**

```html
<input type= "hidden" name= "liveagent.prechat.findorcreate.map.doFind: String
entityName" value= "String fieldName, Boolean find;" />
```

| Name | Type | Description | Available Versions |
|---|---|---|---|
| entityName | String | The type of record to search for or create when an agent accepts a chat with a customer—for example, a contact record. | Available in API versions 29.0 and later. |
| fieldName | String | The name of the API field to search for in existing records. | Available in API versions 29.0 and later. |
| find | Boolean | Specifies whether to search for existing records that contain the field fieldName (true) or not (false). | Available in API versions 29.0 and later. |

`find`가 `true`인 필드만 지정하면 된다. `find`가 `false`인 필드를 포함하는 레코드는 검색하지 않는다.

### ③ findOrCreate.map.isExactMatch

`findOrCreate.map`으로 검색할 때 필드 값이 기존 레코드의 필드 값과 정확히 일치해야 하는지 지정한다.

**Usage:** `findOrCreate.map`에서 기존 레코드 검색 시 정확한 필드 값 일치가 필요한 필드를 지정한다. 하나 이상의 필드에 지정할 수 있다. API versions 29.0 이상.

**Syntax:**

```html
<input type= "hidden" name= "liveagent.prechat.findorcreate.map.isExactMatch: String
entityName" value= "String fieldName, Boolean exactMatch;" />
```

> ⚠️ 아래 Parameters 표의 3번째 행 Name 컬럼이 PDF상 `find`로 표기되어 있다 — **원문 표기 그대로**(오류로 보임). `value` 속성명은 `exactMatch`이나 파라미터 표는 `find`로 적혀 있다.

| Name | Type | Description | Available Versions |
|---|---|---|---|
| entityName | String | The type of record to search for or create when an agent accepts a chat with a customer—for example, a contact record. | Available in API versions 29.0 and later. |
| fieldName | String | The API name of the field to search for in existing records. | Available in API versions 29.0 and later. |
| find | Boolean | Specifies whether to search for existing records that contain an exact match to the field fieldName (true) or not (false). | Available in API versions 29.0 and later. |

표준 객체 필드의 API name은 API 문서를, 비표준 객체는 Setup의 객체 필드 detail을 본다. `exactMatch`가 `true`인 필드만 지정하면 된다 — `exactMatch`가 `false`인 필드를 포함하는 레코드는 검색하지 않는다.

### ④ findOrCreate.map.doCreate

기존 레코드를 찾지 못했을 때 새 레코드를 생성하는 데 사용할 필드를 지정한다.

**Usage:** `findOrCreate.map`에서 기존 레코드를 찾지 못하면 새 레코드를 생성하는 데 사용할 필드를 지정한다. 새 레코드 생성을 위해 하나 이상의 필드를 지정할 수 있다. API versions 29.0 이상.

**Syntax:**

```html
<input type= "hidden" name= "liveagent.prechat.findorcreate.map.doCreate: String
entityName" value= "String fieldName, Boolean create;" />
```

| Name | Type | Description | Available Versions |
|---|---|---|---|
| entityName | String | The type of record to create when an agent accepts a chat with a customer and an existing record isn't found—for example, a contact record. | Available in API versions 29.0 and later. |
| fieldName | String | The API name of the field to include in new records. The findOrCreate method begins the API call that finds existing records or create new records when an agent begins a chat with a customer. You must use this method before calling any of the other findOrCreate sub-methods for finding or creating records with the Deployment API. | Available in API versions 29.0 and later. |
| create | Boolean | Specifies whether to create a new record that contains the field fieldName (true) or not (false). You only need to specify fields for which create equals true. The method will not create records containing fields for which create equals false. | Available in API versions 29.0 and later. |

---

## ⑤ findOrCreate.saveToTranscript (Pre-Chat판)

찾거나 생성한 레코드를 채팅과 연결된 chat transcript에 저장한다.

**Usage:** `findOrCreate.map.doCreate` 또는 `findOrCreate.map.doFind`로 찾거나 생성한 레코드를, 채팅이 끝날 때 채팅과 연결된 chat transcript에 저장한다. API versions 29.0 이상.

**Syntax:**

```html
<input type="hidden" name= "liveagent.prechat.findorcreate.saveToTranscript: String
entityName" value= "String transcriptFieldName" />
```

| Name | Type | Description | Available Versions |
|---|---|---|---|
| entityName | String | The type of record to search for or create when an agent accepts a chat with a customer—for example, a contact record. | Available in API versions 29.0 and later. |
| transcriptFieldName | String | The API name of the field on the chat transcript record to which to save the ID of the record you found or created. | Available in API versions 29.0 and later. |

---

## ⑥ findOrCreate.showOnCreate (Pre-Chat판)

찾거나 생성한 레코드를 Salesforce console의 subtab에 자동으로 연다.

**Usage:** `findOrCreate.map.doCreate`·`findOrCreate.map.doFind`로 생성한 레코드를 Salesforce console의 subtab에 자동으로 연다. API versions 29.0 이상.

**Syntax:**

```html
<input type= "hidden" name= "liveagent.prechat.findorcreate.showOnCreate: String
entityName" value= "Boolean show" />
```

| Name | Type | Description | Available Versions |
|---|---|---|---|
| entityName | String | The type of record to search for or create when an agent accepts a chat with a customer—for example, a contact record. | Available in API versions 29.0 and later. |
| show | Boolean | Specifies whether to display the record you created in a subtab in the Salesforce console (true) or not (false). | Available in API versions 29.0 and later. |

---

## ⑦ findOrCreate.linkToEntity (Pre-Chat판)

찾거나 생성한 레코드를 다른 record type에 링크한다.

**Usage:** `findOrCreate.map.doFind`·`findOrCreate.map.doCreate`로 찾거나 생성한 레코드를, 별도의 `findOrCreate.map` API 호출로 생성한 다른 record type의 레코드에 링크한다. 예: 조직에서 찾은 case 레코드를 생성한 contact 레코드에 링크. `findOrCreate.linkToEntity`는 찾거나 생성한 레코드를 **하나의** 레코드에만 링크한다. 여러 레코드에 링크를 시도하면 첫 번째 레코드에만 링크된다. 이 메서드는 `findOrCreate` API 호출로 생성한 레코드의 필드를 채우는 데는 쓸 수 없다 — 대신 `findOrCreate.map`으로 필드 값을 업데이트한다.

> Note: 부모 레코드가 `findOrCreate` API 호출로 **생성된** 경우에만 레코드를 링크할 수 있다. `findOrCreate.linkToEntity`로 찾은 레코드에는 자식 레코드를 링크할 수 없다.

API versions 29.0 이상.

**Syntax:**

```html
<input type= "hidden" name= "liveagent.prechat.findorcreate.linkToEntity: String
entityName" value= "String parentEntityName, String fieldName" />
```

| Name | Type | Description | Available Versions |
|---|---|---|---|
| entityName | String | The type of record which is linked to the parent record you found or created. | Available in API versions 29.0 and later. |
| parentEntityName | String | The type of parent record to link to the child record you found or created. | Available in API versions 29.0 and later. |
| fieldName | String | The name of the field in the record parentEntityName where the ID of the child record you found or created is saved. | Available in API versions 29.0 and later. |

---

## ⑧ findOrCreate.displayToAgent

들어오는 채팅에 대해 widget과 Details tab에서 에이전트에게 표시할 pre-chat detail을 지정한다.

**Usage:** 에이전트가 채팅 요청을 받을 때 Salesforce console의 Details tab에 표시할 pre-chat detail을 지정한다. 일반적으로 특정 custom detail을 에이전트로부터 숨기는 데(값을 `false`로 설정) 사용한다. API versions 29.0 이상.

**Syntax:**

```html
<input type= "hidden" name= "liveagent.prechat.findorcreate.displayToAgent: String
detailName" value= "Boolean display" />
```

| Name | Type | Description | Available Versions |
|---|---|---|---|
| detailName | String | The name of the detail to display to an agent when they receive a chat request. | Available in API versions 29.0 and later. |
| display | Boolean | Specifies whether to display the custom detail to an agent in the chat notifications and Details tab (true) or not (false). | Available in API versions 29.0 and later. |

`display`가 `false`인 detail만 지정하면 된다. `display`를 지정하지 않으면 기본값은 `true`다.

---

## 코드 샘플 4 — Find and Create Records Pre-Chat API Code Sample

다음 코드는 `findOrCreate.map`, `findOrCreate.map.doFind`, `findOrCreate.map.isExactMatch`, `findOrCreate.map.doCreate`, `findOrCreate.saveToTranscript`, `findOrCreate.showOnCreate`, `findOrCreate.linkToEntity`를 사용해 고객이 pre-chat 폼을 작성할 때 레코드를 검색·생성한다.

```html
<form method="post" action="#">
<label>First Name: </label> <input type='text' name='liveagent.prechat:ContactFirstName'
/><br />
<label>Last Name: </label> <input type='text' name='liveagent.prechat:ContactLastName'
/><br />
<label>Subject: </label> <input type='text' name='liveagent.prechat:CaseSubject' /><br />
<input type="hidden" name="liveagent.prechat:CaseStatus" value="New" /><br />
<input type="hidden" name="liveagent.prechat.findorcreate.map:Contact"
value="FirstName,ContactFirstName;LastName,ContactLastName" />
<input type="hidden" name="liveagent.prechat.findorcreate.map.doFind:Contact"
value="FirstName,true;LastName,true" />
<input type="hidden" name="liveagent.prechat.findorcreate.map.isExactMatch:Contact"
value="FirstName,true;LastName,true" />
<input type="hidden" name="liveagent.prechat.findorcreate.map.doCreate:Contact"
value="FirstName,true;LastName,true" />
<input type="hidden" name="liveagent.prechat.findorcreate.saveToTranscript:Contact"
value="ContactId" />
<input type="hidden" name="liveagent.prechat.findorcreate.showOnCreate:Contact" value="true"
 />
<input type="hidden" name="liveagent.prechat.findorcreate.linkToEntity:Contact"
value="Case,ContactId" />
<input type="hidden" name="liveagent.prechat.findorcreate.map:Case"
value="Subject,CaseSubject;Status,CaseStatus" />
<input type="hidden" name="liveagent.prechat.findorcreate.map.doCreate:Case"
value="Subject,true;Status,true" />
<input type="submit" value="Submit" />
</form>
```

---

## Access Chat Details with the Pre-Chat APIs

Pre-Chat API로 Deployment API에서 넘어온 custom detail에 접근해 pre-chat에 통합한다.

## ⑨ preChatInit

`addCustomDetail` Deployment API 메서드를 통해 채팅에 전달된 deployment 정보에 접근한다.

**Usage:** Custom Details를 포함한 chat deployment 정보를 추출해 pre-chat에서 사용한다. `preChatInit`을 사용할 때는 `prechat.js` 파일을 `deployment.js`와 **같은 Apex 페이지·같은 경로**에 포함한다. API versions 29.0 이상.

**Syntax:** `liveagent.details.preChatInit(String chatUrl, function detailCallback, (optional) String chatFormName)`

| Name | Type | Description | Available Versions |
|---|---|---|---|
| chatUrl | String | The URL of the chat to retrieve custom details from. | Available in API versions 29.0 and later. |
| detailCallback | String | Name of the JavaScript function to call upon completion of the method. | Available in API versions 29.0 and later. |
| (Optional) chatFormName | String | The name of the HTML form tag for the pre-chat form to which to incorporate the custom details. | Available in API versions 29.0 and later. |

**Responses:**

| Name | Type | Description | Available Versions |
|---|---|---|---|
| details | Object | An object containing the deployment information included in the pre-chat form using the preChatInit method. | Available in API versions 29.0 and later. |

**detailCallback:** `preChatInit`이 `details` 객체를 반환한 후 일어나는 동작을 지정한다.

| Syntax | Parameters | Description | Available Versions |
|---|---|---|---|
| `function myCallBack(details) { // Customer specific code }` | details | Specifies the actions to occur after the custom details are retrieved using the preChatInit method. | Available in API versions 29.0 and later. |

> Ch5에는 `preChatInit`/`detailCallback` 전용 전체 코드 샘플 블록이 별도로 없다(위 Syntax 코드만 존재). N3의 전체 코드 예제는 위 "코드 샘플 4"를 참조한다.

---

## 비교표 — Deployment vs Pre-Chat findOrCreate

같은 `findOrCreate` 의미를 두 API가 다른 형태로 노출한다. Deployment API는 JavaScript 메서드 체이닝, Pre-Chat API는 VF `<input type="hidden">` name/value 쌍이다.

| 항목 | Deployment API | Pre-Chat API |
|---|---|---|
| 형태 | JavaScript: `liveagent.findOrCreate(...).map(...)` | VF hidden input: `name="liveagent.prechat.findorcreate.map:..."` |
| 데이터 소스 | `addCustomDetail`로 설정한 custom detail | 고객이 작성한 pre-chat 폼 입력 |
| `map` 파라미터 | `map(FieldName, DetailName, doFind, isExactMatch, doCreate)` — 단일 호출에 5인자 | `map` + 별도 hidden input `map.doFind` / `map.isExactMatch` / `map.doCreate` (분리) |
| 숨은 서브메서드 | 없음 (인자로 포함) | `doFind` / `isExactMatch` / `doCreate` 가 독립 input |
| `displayToAgent` | `addCustomDetail`의 3번째 인자 | 독립 메서드 `findorcreate.displayToAgent` |
| Chasitor 연결 | Visitor에 연결 (후속 요청은 새 Chasitor) | 하나의 Chasitor에만 연결 가능 |
| 권장 사용 | deployment 코드 내 자동화 | 방문자 입력 기반 |

---

## 관련 노트

- [[Chat 개발자 가이드 개요 & Deployment API — 로깅·윈도우·버튼]]
- [[Deployment API — 레코드 자동 검색·생성·자동 채팅 초대 & 코드 샘플]]
- [[커스텀 Chat 윈도우(Visualforce) · Post-Chat · Direct-to-Agent 라우팅]]
- [[Chat REST API 개요 & 시작]]
- [[Service Cloud Objects]]

> 이 노트(chat_dev_guide) = JavaScript Deployment/Pre-Chat API·Visualforce 기반 웹페이지 임베드 관점. ING-13a(chat_rest) = 네이티브 앱·커스텀 클라이언트용 REST API 관점.
