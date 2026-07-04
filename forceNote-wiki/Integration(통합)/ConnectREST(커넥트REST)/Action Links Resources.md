---
tags: [integration, connect-rest-api, action-links, feed-actions, action-link-templates]
source: salesforce_chatter_rest_api.pdf (Connect REST API Developer Guide, Version 67.0 Summer '26; PDF p130–138·1032–1043; Tier 1/2)
created: 2026-07-04
aliases: [Action Links, 액션 링크, Action Link Group, actionType, Api ApiAsync, feed action button, Action Link Template, 피드 버튼]
---

# Connect REST API — Action Links Resources

> Action link는 피드 element에 붙는 버튼으로, 클릭 시 웹페이지 이동·파일 다운로드·Salesforce/외부 서버 API 호출을 수행해 Salesforce와 서드파티를 피드에 통합한다.

---

## 개념

**Action link**는 feed element의 버튼이다. 사용자가 클릭하면 웹페이지로 이동하거나, 파일을 다운로드하거나, Salesforce 또는 외부 서버로 API 호출을 보낸다. 각 action link는 URL과 HTTP 메서드를 포함하며 request body와 header(OAuth 토큰 등)를 실을 수 있다.

### 두 가지 뷰 (상호 배타)

Action link 데이터는 두 관점으로 노출된다.

| 뷰 | 내용 | 접근 |
|---|---|---|
| **Definition** | 민감정보(인증 정보 등) **포함** | 생성한 client app + (생성자 또는 View All Data) |
| **Context user view** | 가시성 옵션으로 필터링, 값은 context user 상태 반영 | action link에 접근 가능한 유저 |

### Group 소속 필수

모든 action link는 **group에 속한다.** 한 group 내의 action link들은 상호 배타적이며 일부 프로퍼티를 공유한다. 독립적으로 실행되는 action은 자체 group에 담는다.

Feed element에 연결하는 흐름:

1. Action link **group definition** 생성 → group ID 응답
2. 그 group ID를 feed element의 `associatedActions` capability로 게시 (자세한 게시 방법은 [[Feed Elements Resources]] 참조)

```json
// 덤프 발췌 — group ID를 feed element에 연결 (예시 ID)
POST /connect/action-link-group-definitions
  (body = Action Link Group Definition Input)
→ 응답에서 group ID(예: "0AgRR...") 획득

POST /chatter/feed-elements
{
  "...": "...",
  "capabilities": {
    "associatedActions": {
      "actionLinkGroupIds": ["0AgRR..."]
    }
  }
}
```

---

## 엔드포인트 (5개)

모든 URI는 `/connect/` 접두를 가지며, Experience Cloud 변형은 `/connect/communities/{communityId}/...` 형태를 병기한다. 응답 바디의 상세 스키마는 [[Connect REST API 개요]] 계열 Reference 챕터로 위임한다(여기서는 응답 바디명만 표기).

| # | URI (`/connect/`) | 메서드 | 버전 | 응답 |
|---|---|---|---|---|
| 1 | `action-link-group-definitions` | POST | 33.0 | Action Link Group Definition |
| 2 | `action-link-group-definitions/{actionLinkGroupId}` | GET / DELETE / HEAD | 33.0 | GET → Action Link Group Definition · DELETE → 204 |
| 3 | `action-link-groups/{actionLinkGroupId}` | GET / HEAD | 33.0 | Platform Action Group |
| 4 | `action-links/{actionLinkId}` | GET / PATCH / HEAD | 33.0 | Platform Action |
| 5 | `action-links/{actionLinkId}/diagnostic-info` | GET / HEAD | 33.0 | (원문에 응답 미표기) |

### #1 Group definition 생성 (POST)

Feed element에 연결하려면 먼저 group definition을 생성한다. POST는 **query parameter를 지원하지 않으며** Action Link Group Definition Input body가 필수다.

⚠️ `actionUrl`은 Salesforce 리소스면 상대경로가 가능하고, 그 외에는 절대 경로로 `https://`로 시작해야 한다.

### #2 Group definition 조회·삭제 (GET / DELETE)

Definition을 만든 **동일 client app**의, 생성자 또는 View All Data 권한 사용자만 읽기·수정·삭제할 수 있다(민감정보를 포함하기 때문). 삭제하면 feed element에 있던 모든 참조가 제거된다.

### #3 Group 인스턴스 조회 (GET)

`action-link-groups`는 group 인스턴스로, context user 상태를 포함한다. Definition과 달리 group 인스턴스는 client가 접근할 수 있다.

### #4 개별 action link 조회·상태 갱신 (GET / PATCH)

개별 action link를 조회하거나 status를 갱신한다. Action link의 UI 텍스트는 status와 Action Link Definition Input의 `labelKey`가 결정한다. Api/ApiAsync 트리거는 status를 `PendingStatus`로 PATCH한다.

#### status 워크플로우

| actionType | 동작 | status 전이 |
|---|---|---|
| **Api** | 동기 API. Salesforce가 `actionUrl`로 콜아웃 | HTTP 응답 코드에 따라 Successful / Failed |
| **ApiAsync** | 비동기 API. 호출 시 `PendingStatus` 유지 | 에러면 Failed. 서버가 완료 후 콜백으로 Successful / Failed를 PATCH |
| **Download / Ui** | Platform Action의 `actionUrl`로 유도 | 앱이 Successful / Failed로 PATCH하는 시점을 결정 |

#### ⚠️ PATCH 금지 조건 (4항)

1. 다른 상태에서 `NewStatus`로 변경 불가
2. 종료 상태(`Failed` / `Successful`)에서 `New` / `Pending`으로 변경 불가
3. `executionsAllowed=Unlimited`인 group에 속한 링크는 변경 불가
4. Api/ApiAsync이고 `executionsAllowed=Once`일 때 — 같은 유저가 다시 `PendingStatus`로 PATCH하면 콜아웃을 재전송하지 않고 현재 정보를 반환하며, 다른 유저가 시도하면 에러

PATCH body의 root는 `<actionLink>`이며 `status`(String, Req, v33.0) 하나를 담는다. query parameter `status`로도 지정 가능.

```json
// 덤프 발췌 — PATCH로 status 갱신
PATCH /connect/action-links/{actionLinkId}
{ "status": "SuccessfulStatus" }

// 또는 query parameter
PATCH /connect/action-links/{actionLinkId}?status=FailedStatus
```

### #5 diagnostic-info (GET)

실행 시 진단 정보를 반환한다. Action link에 접근 가능한 유저만 사용할 수 있다.

---

## Input 스키마 (5종)

### Action Link Definition Input (`<actionLinkDefinition>`)

개별 action link를 정의한다. 모든 프로퍼티는 v33.0이며 action link template에 정의할 수 있다.

| 프로퍼티 | 타입 | 필수 | 설명 |
|---|---|---|---|
| `actionType` | String | **Req** | enum(아래) |
| `actionUrl` | String | **Req** | Ui=웹페이지 · Download=파일 · Api/ApiAsync=REST 리소스(client에 미제공). Salesforce 리소스는 상대경로, 그 외는 절대 `https://`. 팁: 버전이 지정된 API를 사용 |
| `excludedUserId` | String | Opt | 실행에서 제외할 유저 1명. `userId`와 동시 지정 불가 |
| `groupDefault` | Boolean | Opt | group당 1개만. UI에서 강조 스타일 |
| `headers` | Request Header Input[] | Opt | Api/ApiAsync용 |
| `labelKey` | String | **Req** | UI에 표시할 **라벨 세트의 키.** Salesforce가 제공하는 미리 정의된 키 집합에서 선택한다(예제로 등장하는 키: `Approve`·`Like`·`Post` 등). 한 키는 NewStatus / PendingStatus / SuccessStatus / FailedStatus 4개 상태 라벨을 묶는다. 예: `Approve` 키 → Approve / Pending / Approved / Failed. 표준 키에 없는 커스텀 라벨이 필요하면 action link template로 정의 |
| `method` | String | **Req** | enum(아래) |
| `requestBody` | String | Opt | Api/ApiAsync용. ⚠️ 따옴표 escape 필요 |
| `requiresConfirmation` | Boolean | **Req** | 확인 대화 필요 여부 |
| `userId` | String | Opt | 실행 가능 유저. 미지정=아무나. `excludedUserId`와 동시 지정 불가 |

**Context Variables** (`actionUrl` · `headers` · `requestBody`에서 사용):

| 변수 | 값 |
|---|---|
| `{!actionLinkId}` | action link ID |
| `{!actionLinkGroupId}` | group ID |
| `{!communityId}` | 내부 org는 `"000000000000000000"` |
| `{!communityUrl}` | 내부 org는 `""` |
| `{!orgId}` | org ID |
| `{!userId}` | context user ID |

### Action Link Group Definition Input (`<actionLinkGroup>`)

Group을 정의한다. OAuth bearer 등 민감정보를 포함할 수 있어 생성한 client app + (생성자 또는 View All Data)만 읽기·수정·삭제할 수 있다. 프로퍼티는 v33.0.

| 프로퍼티 | 타입 | 필수 | 설명 |
|---|---|---|---|
| `actionLinks` | Action Link Definition Input[] | template 미사용 시 Req | 표시 순서 = 배열 순서 |
| `category` | String | template 미사용 시 Req | enum `Primary`(body에 표시, 최대 3) / `Overflow`(오버플로 메뉴, 최대 4) |
| `executionsAllowed` | String | template 미사용 시 Req | enum `Once`(전체 유저 1회) / `OncePerUser` / `Unlimited`(Api/ApiAsync는 사용 불가) |
| `expirationDate` | String (ISO8601) | template 미사용 시 Req / template면 Opt | **생성일로부터 1년 이내.** OAuth 토큰이 있으면 토큰 만료와 동일하게 설정 권장 |
| `templateBindings` | Action Link Template Binding Input[] | template 바인딩 변수 사용 시 Req | |
| `templateId` | String | template 인스턴스화 시 Req | |

```json
// 덤프 발췌 — templateless group definition (예시값)
POST /connect/action-link-group-definitions
{
  "actionLinks": [
    {
      "actionType": "Api",
      "labelKey": "Like",
      "groupDefault": "true",
      "actionUrl": "https://test.com/this",
      "method": "HttpPost",
      "requiresConfirmation": "false"
    },
    { "...Unlike...": "..." }
  ],
  "executionsAllowed": "OncePerUser",
  "expirationDate": "2014-07-07T23:59:11.168Z",
  "category": "Primary"
}

// 덤프 발췌 — template 인스턴스화 (예시 ID)
{
  "templateId": "07gD...",
  "templateBindings": [
    { "key": "Bindings.version", "value": "v33.0" }
  ]
}
```

### Action Link Input (`<actionLink>`)

| 프로퍼티 | 타입 | 필수 | 버전 |
|---|---|---|---|
| `status` | String | Req | 33.0 |

enum: `FailedStatus` · `NewStatus`(Download/Ui만) · `PendingStatus`(Api/ApiAsync 트리거) · `SuccessfulStatus`. 예: `{ "status": "SuccessfulStatus" }`.

### Action Link Template Binding Input (`<actionLinkTemplateBinding>`)

v33.0. template 바인딩 변수에 값을 채운다.

| 프로퍼티 | 타입 | 필수 | 설명 |
|---|---|---|---|
| `key` | String | Req | 예: `{!Binding.firstName}` → key `firstName` |
| `value` | String | Req | 바인딩 값 |

### Request Header Input (`headers` 타입)

v33.0.

| 프로퍼티 | 타입 | 필수 |
|---|---|---|
| `name` | String | Req |
| `value` | String | Req |

예: `{ "name": "Content-Type", "value": "application/json" }`.

---

## enum 종합

| enum | 값 |
|---|---|
| `actionType` | `Api`(동기 API, HTTP 코드로 status) · `ApiAsync`(비동기, 서드파티가 status 갱신) · `Download`(파일 다운로드) · `Ui`(웹페이지, 사전 입력·확인 필요 시) |
| `method` | `HttpDelete`(204) · `HttpGet`(200) · `HttpHead`(200 empty) · `HttpPatch`(200/204) · `HttpPost`(201/204, batch는 200) · `HttpPut`(200/204) |
| `category` | `Primary`(body 표시, 최대 3) · `Overflow`(오버플로 메뉴, 최대 4) |
| `executionsAllowed` | `Once`(전체 유저 1회) · `OncePerUser` · `Unlimited`(Api/ApiAsync 불가) |
| `status` | `FailedStatus` · `NewStatus`(Download/Ui만) · `PendingStatus`(Api/ApiAsync 트리거) · `SuccessfulStatus` |

> ⚠️ **원문 불일치:** templateless 예제에는 `"method": "Post"`(접두 없음)로 표기되지만, Properties 표는 `HttpPost`로 표기한다. 정식 값은 `Http*` 형태(`HttpDelete`/`HttpGet`/`HttpHead`/`HttpPatch`/`HttpPost`/`HttpPut`)다.

---

## 응답 바디명 (Reference 위임)

상세 스키마는 Connect REST API Reference 챕터로 위임한다.

- **Action Link Group Definition** — #1 POST · #2 GET 응답
- **Platform Action Group** — #3 GET 응답
- **Platform Action** — #4 GET 응답

---

## 대표 POST 예제 (정의)

덤프의 대표 예제는 `actionLinks` 배열에 Api(Confirm/Deny) + Ui(Review) action link를 담고, `headers`에 OAuth·Content-Type·Accept·X-PrettyPrint를, `executionsAllowed=OncePerUser`, `category=Primary`, `expirationDate`를 설정한 뒤, 응답 group ID를 feed-elements POST의 `actionLinkGroupIds`로 연결하는 흐름이다(구조는 위 [[Feed Elements Resources]] 연결 예제와 동일).

> PDF에는 action link 게시 흐름 다이어그램이 있으나 여기서는 텍스트 설명만 제공한다.

---

## 관련 노트
- [[Feed Elements Resources]] — `associatedActions` capability로 action link group을 피드에 게시
- [[Connect REST API 요청·응답 규약]] — base URI·인증 규약
- [[Connect REST API 개요]] — Connect REST API 상위 개요
