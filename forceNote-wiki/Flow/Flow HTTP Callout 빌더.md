---
tags: [flow, http-callout, integration, external-services, named-credential, no-code]
source: extend_click_automate.pdf (Automate Your Business Processes, Spring '26)
created: 2026-07-10
aliases: [HTTP Callout, Flow HTTP Callout, HTTP 콜아웃, 플로우 HTTP 콜아웃, Flow 외부 API 호출, Create HTTP Callout, 코드 없이 API 연동]
---

# Flow HTTP Callout 빌더

> Flow Builder 안에서 코드 없이 외부 HTTP API와 데이터를 주고받는 빌더. 콜아웃 액션을 구성하면 External Service 등록·Invocable Action·Apex 클래스가 자동 생성된다.

---

## 개요

**HTTP Callout**은 코드 없이 Flow와 외부 시스템 간에 데이터를 가져오거나(pull) 보내는(send) 기능이다. 개발자나 미들웨어 도구 없이 필요할 때 직접 통합을 구성할 수 있다.

Flow에서 HTTP 콜아웃 액션을 구성하면 Flow Builder가 다음 3가지를 **자동 생성**한다:

1. **External Service 등록**(external service registration)
2. **Invocable Action**
3. **Apex 클래스** — Flow용 Apex-defined 리소스를 만드는 데 사용

API 요청의 데이터 출력을 Flow Builder 안에서, 그리고 Salesforce 전반에서 입력으로 재사용할 수 있다.

> **[[External Services]]와의 관계** — HTTP Callout 구성은 External Services가 구동한다(powered by). 그래서 생성된 액션이 Flow Builder와 org 전반에서 재사용·호출 가능하다. 차이: External Services는 **OpenAPI 스키마를 직접 등록**하는 방식이고, HTTP Callout 빌더는 **샘플 JSON 요청/응답에서 스키마를 추론**해 External Service 등록을 자동 생성하는 노코드 진입점이다. OpenAPI 등록 절차·스키마 제약·한도·`ExternalService` 네임스페이스 Apex 호출은 [[External Services]] 소관.

콜아웃 구성 전에 **Setup > Named Credentials**에서 인증을 먼저 설정해야 external service가 API에 연결할 수 있다. Named Credential 메커니즘 자체(신형 NC+External Credential 구조, merge field, Apex `callout:` 사용법)는 [[Named Credential]] 참조 — 이 노트는 HTTP Callout에 특화된 인증 준비 가이드라인만 다룬다.

---

## Flow에서 외부 시스템과 연동하는 5가지 옵션

Flow를 외부 데이터베이스에 연결하는 방법 (ECA "Integrate with External Systems from a Flow"):

| 옵션 | 설명 |
|---|---|
| **Platform Events** | Salesforce 내부 또는 외부 소스에서 안전하고 확장 가능한 커스텀 알림 전달. **발행**: Create Records 요소에서 대상 객체로 플랫폼 이벤트를 지정. **구독**: Wait 요소 추가. 상세 → [[Platform Event 정의와 구독]] |
| **External Objects** | Salesforce org 밖에 저장된 데이터를 외부 객체로 참조. 외부 시스템을 외부 객체에 매핑한 뒤, Flow 데이터 요소로 외부 시스템의 데이터를 get·create·update |
| **Custom Lightning Components** | Salesforce 서버를 거치지 않고 방화벽 뒤의 데이터베이스에 연결(로컬 액션 호출). 모든 로컬 액션은 Flow Builder에 Core Action 요소로 표시 |
| **External Services** | 코드 한 줄 없이 외부 시스템에 연결. 엔드포인트와 스키마를 지정하면 Apex 클래스가 생성되고, Flow Builder에 Apex 액션으로 표시. OpenAPI 2.0 JSON 스키마 포맷 지원 → [[External Services]] |
| **Apex** | 더 많은 제어가 필요하면 직접 Apex 작성. Flow Builder에 노출하려면 `@InvocableMethod` 어노테이션 또는 `Process.Plugin` 인터페이스 사용 → [[@InvocableMethod 패턴]] |

### 통합 옵션 특성 매트릭스

PDF 원본 표(printed p.105)의 체크마크는 그래픽이라 텍스트 추출이 안 되어 페이지 이미지를 직접 판독해 옮겼다(셀별 대조 완료).

| Integration Option | Declarative | Server-Side | Client-Side | Synchronous | Asynchronous |
|---|:---:|:---:|:---:|:---:|:---:|
| Platform events | ✅ | ✅ | — | — | ✅ |
| External objects | ✅ | ✅ | — | ✅ | — |
| Custom Lightning components | — | — | ✅ | ✅ | ✅ |
| External Services | ✅ | ✅ | — | ✅ | — |
| Apex | — | ✅ | — | ✅ | ✅ |

### 서드파티 커넥터 (Third-Party Connectors)

서드파티 커넥터는 서로 다른 애플리케이션·시스템 간 통신을 가능하게 하는 소프트웨어 도구로, **트리거 또는 액션**으로 Flow에 사용할 수 있다. 커넥터마다 자체 트리거·액션을 제공한다.

- 예: NetSuite에서 연락처가 업데이트되면 Salesforce의 관련 Contact 레코드 업데이트 / Salesforce에서 Order 레코드가 업데이트되면 QuickBooks Online 데이터 업데이트
- 필요 권한: Flow 생성 = **Manage Flow**, Flow에 서드파티 커넥터 추가 = **Manage Integration Connections**

> ⚠️ 소스 특이사항: Spring '26 PDF의 "Build a Flow with a Third Party Connector as an Action/Trigger" 하위 절들은 본문이 전부 **"TBD"**(작성 예정 placeholder)다. 절차 상세는 문서 자체에 아직 없다.

---

## 요구 사항 — 에디션·권한

| 항목 | 값 |
|---|---|
| UI | **Lightning Experience** |
| 에디션 | **Enterprise, Performance, Unlimited, Developer** (Configure·Considerations·Manage 절 기준) |
| HTTP Callout 사용 | **Customize Applications** 사용자 권한을 가진 Admin |
| Flow 열기·편집·생성 | **Manage Flow** |
| External Credential·Named Credential·HTTP 콜아웃 액션 생성 | **Customize Applications** |
| 사전 지식 | API 동작 방식에 익숙해야 하고, 호출할 엔드포인트의 **API 문서**를 보유해야 함 |

> ⚠️ 소스 특이사항: 같은 PDF 안에서 에디션 박스가 절마다 다르다 — HTTP Callout 개요 절과 인증 가이드라인 절은 "Enterprise, Unlimited, and Developer"(Performance 빠짐), Considerations·Configure·Manage 절은 "Enterprise, Performance, Unlimited, and Developer". 원문 그대로 병기한다.

---

## 1단계 — 인증 준비 (Guidelines for Authenticating HTTP Callout Actions)

HTTP Callout 액션을 구성하기 전에, 외부 시스템 호출을 인증할 Named Credential을 설정한다. Setup에서 **이 순서대로** 생성한다: **권한 세트 → Auth Provider → External Credential → Named Credential**, 그다음 User Credentials 객체 접근 권한 부여.

### 구성 요소별 가이드라인

| 구성 요소 | 필수 여부 | 역할 |
|---|---|---|
| **Permission Set** | 필수 | 사용자에게 콜아웃 실행 권한 부여. 없으면 생성 후 콜아웃할 각 사용자에게 할당. 대안: **legacy Named Credential**을 만들면 권한 세트가 필요 없어 시간 절약 가능 |
| **Auth. Provider** | OAuth 프로토콜 사용 시에만 필수 | ID 공급자와 상호작용해 토큰 획득 |
| **External Credential** | 필수 | 인증 방식 정의. Named Credential Setup 페이지의 External Credential 탭에서 생성 |
| **Named Credential** | 필수 | 엔드포인트의 이름과 URL 정의. Flow Builder에서 액션 생성 시 HTTP 콜아웃 액션에 연결됨 |
| **User Credentials 객체 접근** | 인증 불요 Open API 제외 전부 필수 | Named Credentials 서브시스템이 비밀 토큰·값을 User Credentials 객체에 저장. 권한 세트 또는 프로필로 필요한 접근(Read·Create·Edit·Delete) 부여 |

### External Credential — 프로토콜 선택

API 요구사항에 맞는 프로토콜을 선택한다:

- **Custom** — 다음 경우에 선택:
  - Basic 인증 (username/password)
  - Key 또는 token
  - 인증 없음
- **OAuth 2.0**
- **AWS Signature Version 4**

External Credential에 **Permission Set Mapping**을 추가하고 관련 권한 세트를 선택한다.

**헤더에 key/token을 요구하는 API:**
- Permission Set Mapping에 **Authentication Parameter** 추가 — 고유한 Name을 넣고 Value 필드에 key 입력
- **Custom Header** 추가 — API가 기대하는 정확한 Name 입력. Value는 Authentication Parameter 이름을 가리키게 함. 예: `$Credential.namedCredApiName.authParameterName`

**Basic 인증(username/password)을 요구하는 API:**
- Authentication Parameter로 username 값 저장 + 또 하나의 Authentication Parameter로 password 값 저장
- Custom Header 추가 — Name은 "Authorization", Value는 두 파라미터를 가리키는 수식:

```
{!'Basic ' & BASE64ENCODE(BLOB($Credential.BasicAuth.Username & ':' & $Credential.BasicAuth.Password))}
```

### Named Credential — 필드 설정

External Credential과 Named Credential이 분리된 이유: API는 흔히 **같은 인증으로 여러 엔드포인트**를 쓴다 (예: `calendar.google.com/api`와 `drive.google.com/api`).

| 필드 | 설정 |
|---|---|
| Label | 연결할 엔드포인트를 설명하는 이름 |
| URL | base URL |
| External Credential | 앞 단계에서 만든 것 선택 |
| **Generate Authorization Header** | 인증 없음·OAuth 사용 시 **체크 유지**. key/token·basic 인증 사용 시 **해제** |
| **Allow Formulas in HTTP Header** | 헤더에 수식이 포함되면 체크 (basic auth 사용 시 포함) |

---

## 2단계 — HTTP Callout 액션 구성 (Configure an HTTP Callout Action)

사전 준비: ① External Credential + Named Credential 생성(위 1단계), ② **JSON 형식 샘플 API 응답** 준비(API 문서에 샘플이 없으면 서드파티 API 플랫폼으로 응답을 받아 확보), ③ 문서화가 잘 된 API로 시작(필드 요건·정의가 부정확하면 디버깅에 시간 소요).

1. Setup > Quick Find에 `Flows` 입력 → **Flows** 선택
2. 콜아웃을 쓸 기존 Flow를 열거나 새로 생성
3. **+** 클릭 → **Action** 선택
4. **+Create HTTP Callout** 클릭
5. **External Service 구성** — Salesforce와 HTTP 기반 API 연결:
   - a. External service 이름 입력 (예: ConnectToMaps). **문자로 시작, 공백 없는 영숫자만** 허용
   - b. 참조용 설명 입력
   - c. 이 external service용으로 만든 **Named Credential 선택**
   - d. Next 클릭
6. **Invocable Action 구성** — Flow Builder 및 Salesforce 전반에서 사용할 액션:
   - a. Label — 콜아웃이 수행하는 동작 입력 (예: Connect to Maps)
   - b. 호출할 API가 요구하는 **operation(HTTP 메서드) 선택**. 일반적으로 **GET은 외부 데이터를 가져오고, 나머지 메서드는 외부 시스템의 데이터를 수정**한다 (실제 기능은 API에 따름)
   - c. 작업 설명 입력 + 나중에 콜아웃 변경 시 참조할 수 있게 **API 문서 링크 포함**
7. **요청 URL 엔드포인트 추가.** Base URL에는 external service의 Named Credential URL이 표시됨:
   - a. 슬래시(`/`)로 시작하고 물음표(`?`)를 포함하지 않는 URL path 입력
   - b. path 변수가 있으면 중괄호 `{}` 안에 넣고 데이터 타입 선택. path 변수는 **영숫자와 밑줄만** 허용
   - c. 변수 설명(사용 상세 포함) 입력
8. **쿼리 파라미터 키 추가** (API에 있는 경우). Flow에서 이 액션을 쓸 때 정의된 키에 값을 입력하게 된다:
   - a. **+Add Key** 클릭 → b. 키 값 입력 + 데이터 타입 선택 → c. Flow에서 호출 시 값을 필수로 만들려면 **Require** 선택 → d. 키 설명 입력
9. **POST·PUT·PATCH·DELETE의 경우 샘플 API 요청 body 제공.** Salesforce가 샘플 요청에서 데이터 구조를 생성:
   - New 클릭 → 샘플 JSON 요청 붙여넣기 → **Review** 클릭해 Apex 데이터 구조 확인 → 수정 필요 시 Sample JSON Request 텍스트 편집 또는 데이터 구조에서 타입 선택 → Review → Done
10. **샘플 API 응답 body 제공.** Salesforce가 샘플 응답에서 데이터 구조를 생성:
    - New 클릭 → 샘플 JSON 응답 붙여넣기 → **Review** 클릭해 Apex 데이터 구조 확인 → 수정 필요 시 편집 → Review → Done
11. **Save** — Flow Builder가 액션과 external service를 생성. 액션은 Flow의 Actions 창에서 사용 가능
12. **POST·PUT·PATCH·DELETE의 경우 body용 리소스 생성** — 외부 서버 body용 Apex 클래스를 선택:
    - body에서 **New Resource** 선택 → API 이름·설명 입력 → 데이터 타입과 Apex 클래스는 자동 설정 → Done → body에서 방금 만든 Apex-defined 변수 선택 → Done

### 자동 생성 Apex 클래스 네이밍 규칙

Flow Builder는 추론된 데이터 구조에서 Apex 클래스를 자동 생성해 Salesforce↔외부 서버 간 전송 데이터를 저장한다.

```
// 요청 body (POST 등 입력):  ExternalServiceName__HTTP Callout Label_IN_body
// GET 메서드 응답:           ExternalServiceName__HTTP Callout Label_OUT_2XX
// 라벨의 공백은 x20으로 표기
```

예: external service 이름이 `MyCustomES`, HTTP Callout 라벨이 `Get Accounts`면 —
- 요청 body 클래스: `MyCustomES_Getx20Accounts_IN_body`
- GET 응답 클래스: `MyCustomES_Getx20Accounts_OUT_2XX`

이 Apex-defined 변수 개념은 [[Flow 종류와 변수]] 참조.

### Transform·Assignment와의 조합

Flow 안에서 Salesforce와 외부 시스템 간 데이터를 변환하려면 **Transform 요소**를 쓴다 → [[Transform 요소]]. **POST·PUT·PATCH·DELETE** 메서드는 HTTP 콜아웃 액션 **앞에 Assignment 요소를 추가**해 Apex-defined 변수의 각 필드에 값을 할당한다. 콜아웃 액션은 이 Apex-defined 변수를 입력으로 참조해 외부 서버에 데이터를 만든다.

---

## 고려사항과 한도 (HTTP Callout Considerations)

- **JSON 리스트는 같은 데이터 타입만 지원.** 예: `[1, 2, 3, 4]`는 지원, `["one", 2, "three", "four"]`는 2가 숫자고 나머지가 문자열이라 미지원
- **Enum 데이터 타입 미지원.** API에 Accepted/Rejected 같은 유한값 Status 필드가 있어도 Flow Builder에 multi-picklist로 나타나지 않고 **string으로 추론**되며, 콜아웃 응답에는 값 하나가 들어옴
- **Float·long 데이터 타입 미지원.** 구성 시 제공한 API 응답에 float/long 필드가 있으면 **integer 또는 double로 설정** 가능
- **헤더는 Named Credential 안에 포함**해 인증을 구성 (global merge field 지원). 헤더는 invocable action이 아니라 **콜아웃 URL 엔드포인트 쪽에 설정**
- **한도:**
  - Flow Builder에서 HTTP 콜아웃 액션을 만들 때마다 **external service 등록이 하나씩 자동 생성**됨 — External Service org 한도를 소모한다. 한도 수치는 [[External Services]]의 한도 표 참조 (원문 SEE ALSO: "Callouts and Callbacks: Limits and Usage")
  - JSON 계층에서 **필드·객체 중첩은 최대 15레벨**

---

## 예제 Flow — 펫스토어 재고 주문 (Use the HTTP Callout Action)

공급업체 주문 시스템 API에 실시간 주문을 넣는 Screen Flow. 재고 수준을 확인하고 낮으면 공급업체 API 콜아웃을 트리거해, Submit Order 클릭 시 실시간 API 호출로 주문을 넣는다.

> PDF 원문(printed p.115–125)에는 각 단계 스크린샷이 있으나 본 노트는 텍스트 설명만 담는다.

**사전 준비** — External Credential `PetStore` + Named Credential `Acme Pet Supplies` 생성. 샘플 API 응답(원문 발췌):

```json
{
  "id": 0,
  "petId": 0,
  "quantity": 0,
  "shipDate": "2024-10-09T08:49:33.605Z",
  "status": "placed",
  "complete": true
}
```

**Flow 구성 절차** (22단계 원문 전수 — 구성값 요약):

| # | 요소/작업 | 핵심 구성값 |
|---|---|---|
| 1–2 | Flow Builder 열기 → Screen Flow 생성 | Setup·Automation 앱·Flows 탭 어디서든 New Flow → Start from Scratch → Screen Flow |
| 3 | **Get Records** | Label `Get Pet Inventory` / Object `Inventory` / 조건 None—Get All Inventory Records / All Records 저장 |
| 4 | **Screen** | Label `Reorder Pet Inventory`, Header·Footer 표시 |
| 5 | Section 컴포넌트 | Label `Pet Inventory`, API `Available_Pets`, 컬럼 구성 |
| 6 | **Data Table** (Pet Inventory 섹션의 자식) | API `petTable`, Label `Available Pets`, Source Collection `{!Get_Pet_Inventory}`, 검색바 표시 |
| 7 | Section 컴포넌트 | Label `Restock Selected Pet`, API `Reorder_Information` |
| 8 | Text 컴포넌트 | Label `Selected Pet`, Default Value `{!petTable.firstSelectedRow.Name}` |
| 9 | Currency 컴포넌트 | Label `Cost Per Unit`, Default Value `{!petTable.firstSelectedRow.Current_MSRP__c}` |
| 10 | Number 컴포넌트 | Label `Order Quantity`, 소수 자리 0 |
| 11 | Number 컴포넌트 | Label `Total Cost`, Default Value `{!formulaTotalCost}`, 소수 자리 2 |
| 12 | **Action → Create HTTP Callout** | External Service `OrderPetTest` / Named Credential `Acme Pet Supplies`(URL 자동 채움) / Label `Order Pet` / **Method POST** / URL Path `/store/order` / Sample JSON Request 입력 → Review / Select Sample Response Method에서 **Connect for Schema** 선택 / 액션 Label `Callout to Order Pets` / Set Body Request Value `{!Order_Pet_Input_Test}` |
| 13 | **Assignment** (콜아웃 앞) | Label `Assign Callout Request Fields`. `{!Order_Pet_Input_Test.id}` Equals `{!petTable.firstSelectedRow.Recommended_Reorder_Quantity__c}` / `{!Order_Pet_Input_Test.quantity}` Equals `{!Order_Quantity}` / `{!Order_Pet_Input_Test.shipDate}` Equals `{!$Flow.CurrentDate}` / `{!Order_Pet_Input_Test.status}` Equals `Placed` (원문 그대로 옮김) |
| 14 | **Decision** (콜아웃 뒤) | Label `Was Callout Successful?`. 성공 outcome 조건(AND): `{!Callout_to_Order_Pets.responseCode}` **Greater Than or Equal 200** + **Lesser Than or Equal 200** (원문 그대로). Default outcome `Callout Not Successful` |
| 15 | 실패 경로: **Screen** | Label `Error Screen` |
| 16 | 성공 경로: **Update Records** | Label `Update Inventory Quantity on Hand` / 조건 지정 방식 / Object `Inventory` / Record ID Equals `{!petTable.firstSelectedRow.Id}` / Quantity on Order 필드에 `{!UpdateQuantityOnHand}` |
| 17 | 성공 경로: **Screen** | Label `Order Placed`, 커스텀 버튼 라벨 `OK`, Previous·Pause 숨김, Display·Section 컴포넌트로 주문 요약 표시 |
| 18–22 | 저장 → **Debug** → Run → 재고 선택 → 수량 입력 → Submit Order | 실패 시 Flow 오류 트러블슈팅. (선택) Change Inputs/Run Again으로 재실행. **Screen Flow에서는 디버그 실행을 테스트로 전환할 수 없음** |

콜아웃 응답은 `{!Callout_to_Order_Pets.responseCode}`처럼 액션 출력으로 참조한다 — 성공/실패 분기는 이 responseCode 기반 Decision 패턴을 쓴다. 오류 처리 일반론은 [[Flow 에러 처리]] 참조.

---

## HTTP Callout 액션 관리 (Manage HTTP Callout Actions)

액션 생성 시 Flow Builder는 **external service 객체와 invocable action 객체**를 만든다. org에서 권한이 있는 누구나 그 invocable action을 Flow Builder와 Salesforce 전반(Apex·Einstein Bots·quick actions)에서 재사용할 수 있다.

- **Flow별 입력값 수정** (예: 쿼리 파라미터 값): Flow Builder 캔버스에서 해당 **Action 요소를 편집**
- **액션 구성 수정** (path URL·키·JSON 샘플 등): Setup > **External Services** 페이지에서 편집
  1. Setup Quick Find에 `External Services` 입력 → External Services 선택
  2. HTTP Callout으로 만든 external service 찾기 → 이름 클릭
  3. operation의 드롭다운 메뉴에서 **Edit HTTP Callout Action** 선택
  4. 액션과 샘플 응답 업데이트 → 저장
- **Named Credential 교체** (액션 생성 후):
  1. Setup > External Services → 해당 external service 찾기
  2. Actions 컬럼의 화살표 → **Edit**
  3. Select a Named Credential 드롭다운에서 다른 Named Credential 선택 → **Save & Next**
  4. Select operations에서 invocable action의 operation이 선택돼 있는지 확인 → Next → Done
- **삭제**: **external service 등록 레코드를 삭제**하는 방식. Setup > External Services → 해당 서비스 → Actions 화살표 → **Delete** → OK. 단, external service 등록과 HTTP Callout 액션이 **어느 Flow에서든 참조 중이면 삭제 불가**

---

## 활용 사례 (원문 예시)

- 지도 API로 주소 정보 조회 — Screen Flow에 주소 입력 시 Maps API 실시간 호출, 상세 주소와 영업시간을 화면에 표시
- 날씨 API로 기상 조건 확인 — 매일 콜아웃해 특정 지역 날씨 확인, 조건 충족 시 수업 실내/실외 알림
- 결제 처리 API로 결제 승인 정보 조회 — 인보이스 번호로 결제 완료·정산 여부 확인
- Salesforce에 제품 레코드 추가 시 재고 시스템에 레코드 추가
- 외부 마케팅 자동화 도구에 리드·연락처 추가
- 외부 결제 게이트웨이로 결제 트랜잭션 처리
- 외부 주문 관리 시스템의 기존 주문 정보 업데이트

### 외부 데이터로 Flow 선택지 생성 (Generate Flow Choice Options From External Data)

외부 데이터를 Flow 화면의 선택지로 쓸 수 있다: ① external service·Apex 액션·다른 화면 컴포넌트의 **Apex-defined 컬렉션**을 참조하는 collection choice set 생성 → ② 그 choice set을 picklist 같은 선택 컴포넌트에 추가. 런타임에 Apex-defined 컬렉션에 채워진 데이터 기준으로 선택지가 생성된다. (예: 자동차 딜러가 외부 재고 시스템의 차량 목록을 화면에서 선택)

---

## 선택 기준 — HTTP Callout 빌더 vs External Services 수동 등록 vs Apex

| 기준 | HTTP Callout 빌더 | [[External Services]] 수동 등록 | Apex [[@InvocableMethod 패턴]] |
|---|---|---|---|
| 스키마 입력 | **샘플 JSON 요청/응답에서 추론** (OpenAPI 문서 불필요) | OpenAPI 2.0/3.0 스펙 필요 | 없음 (코드로 직접) |
| 코드 | 불필요 | 불필요 | Apex 작성 |
| 산출물 | External Service 등록 + invocable action + Apex 클래스 자동 생성 | Apex 클래스 + Flow 액션 자동 생성 | 직접 작성한 invocable action |
| 적합 상황 | API 문서에 샘플만 있는 단건 REST 연동을 Admin이 즉시 구성 | 잘 정의된 OpenAPI 스펙이 이미 있는 API | 원문: "더 많은 제어가 필요하면"(복잡 인증·전처리·오류 로직) |
| 미지원 타입 주의 | enum·float·long 미지원, JSON 리스트 혼합 타입 미지원 | 스키마 제약은 [[External Services]] 참조 | 제약 없음 (직접 처리) |

---

## 관련 노트

- [[External Services]] — HTTP Callout이 자동 생성하는 등록의 본체. OpenAPI 등록·한도·ExternalService 네임스페이스
- [[Named Credential]] — 인증·엔드포인트 저장 메커니즘 (이 노트의 1단계가 연계)
- [[@InvocableMethod 패턴]] — 코드 방식 Flow 액션. 위 선택 기준 비교 참조
- [[Transform 요소]] — 콜아웃 요청/응답 데이터의 소스↔타깃 매핑 변환
- [[Flow 종류와 변수]] — Apex-Defined 변수 (콜아웃 body·응답 수신)
- [[Flow 에러 처리]] — 콜아웃 실패 경로 설계
- [[Platform Event 정의와 구독]] — 외부 연동 옵션 중 플랫폼 이벤트 발행(Create Records)·구독(Wait)
