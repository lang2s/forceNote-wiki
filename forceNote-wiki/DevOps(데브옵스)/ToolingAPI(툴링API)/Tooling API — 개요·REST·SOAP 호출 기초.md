---
tags: [tooling-api, devops, rest, soap, unit-testing, composite, executeAnonymous]
source: api_tooling.pdf (Tooling API Reference and Developer Guide v67.0 Summer '26); Winter27-v68-Docs/api_tooling.pdf (Tooling API Reference and Developer Guide v68.0 Winter '27, 2026-08-21 갱신) 인쇄 p.3–7 — REST 리소스 카탈로그·Test Discovery testLevel, 인쇄 p.37–38 — API End-of-Life Policy 버전 지원 표(v68.0 판, 2026-08-25 갱신)
created: 2026-06-27
aliases: [Tooling API, 툴링 API, REST Resources, REST 리소스, SOAP Calls, SOAP 호출, executeAnonymous, runTestsAsynchronous, runTestsSynchronous, Test Discovery API, Test Runner API, Composite Resource, API End-of-Life, testLevel, showAllMethods deprecated, apexCompileResults 리소스, symbols 리소스, RunAllTestsInOrg, RunLocalTests, API 버전 지원 종료, API 버전 은퇴, 410 GONE, UNSUPPORTED_API_VERSION]
---

# Tooling API — 개요·REST·SOAP 호출 기초

> Tooling API는 개발 도구·앱이 org 메타데이터에 **세밀하게(fine-grained)** 접근하도록 SOAP·REST 두 인터페이스를 제공한다. 많은 메타데이터 타입에 SOQL이 가능해 작은 단위로 retrieve할 수 있어 인터랙티브 앱에 적합하다. 이 노트는 Ch1(개요·REST·단위테스트·Composite·EOL)과 Ch2(SOAP 호출)를 다루는 **폴더 허브**다.

---

## 개요 — Tooling API란

Use Tooling API to build custom development tools or apps for Lightning Platform applications. Tooling API의 SOQL 능력은 많은 메타데이터 타입에 대해 더 작은 조각의 메타데이터를 retrieve하게 해준다. 작은 retrieve는 성능을 개선하므로 Tooling API는 인터랙티브 애플리케이션 개발에 더 적합하다. Tooling API는 SOAP·REST 인터페이스를 제공한다.

예를 들어 다음을 할 수 있다.

- 기존 Lightning Platform 도구에 기능을 추가한다.
- Lightning Platform 개발용 동적 모듈을 엔터프라이즈 통합 도구에 빌드한다.
- 특정 애플리케이션·서비스를 위한 전문 개발 도구를 빌드한다.

Tooling API exposes metadata used in developer tooling that you can access through REST or SOAP. 각 Tooling API 객체와 그 객체가 지원하는 REST 리소스·SOAP 호출에 대한 상세 설명은 **Tooling API Objects**(객체 카탈로그, 별도 노트로 작성 예정) 참조.

> [!note] Tooling sObject ≠ Metadata API 타입
> Tooling API가 노출하는 `ApexClass`·`CustomObject` 등의 sObject는 SOQL 가능한 런타임 객체이고, Metadata API의 동명 **타입**은 declarative 메타데이터 타입이다. 동명이라도 필드·용법이 다른 별개 개념이다. Metadata API 타입 카탈로그는 [[Metadata API 개요]] 및 MetadataAPI 폴더 참조.

---

## When to Use Tooling API

Use Tooling API when you need fine-grained access to an org's metadata. Tooling API의 SOQL 능력은 많은 메타데이터 타입에 대해 더 작은 메타데이터 조각을 retrieve하게 해주고, 작은 retrieve는 성능을 개선해 인터랙티브 앱에 더 적합하게 만든다.

Tooling API는 복잡한 타입 안에서 **단 하나의 요소만** 변경할 수 있게 해주므로 Metadata API보다 사용이 더 쉬울 수 있다. 그 밖의 use case:

- Source control integration
- Continuous integration
- Apex classes or trigger deployment

**Tooling API로 수행할 수 있는 구체 작업(task → 사용 객체):**

| 작업(task) | 사용 객체/방법 |
|---|---|
| Retrieve metadata about an object's field | Use **FieldDefinition**. |
| Retrieve custom or standard object properties | Use **EntityDefinition**. |
| Manage working copies of Apex classes and triggers and Visualforce pages and components. | Use **ApexClassMember, ApexTriggerMember, ApexPageMember, ApexComponentMember, and MetadataContainer**. |
| Manage working copies of static resource files. | Use **StaticResource**. |
| Check for updates and errors in working copies of Apex classes and triggers and Visualforce pages and components. | **ContainerAsyncRequest** |
| Commit changes to your organization. | Use **ContainerAsyncRequest**. |
| Set heap dump markers. | Use **ApexExecutionOverlayAction** |
| Overlay Apex code or SOQL statements on an Apex execution. | Use **ApexExecutionOverlayAction**. |
| Execute anonymous Apex. | For sample code, see **SOAP Calls and REST Overview**. |
| Generate log files for yourself or for other users. | Set checkpoints with **TraceFlag** |
| Access debug log and heap dump files. | Use **ApexLog and ApexExecutionOverlayResult**. |
| Manage custom fields on custom objects. | Use **CustomField**. |
| Access code coverage results. | Use **ApexCodeCoverage, ApexOrgWideCoverage, and ApexCodeCoverageAggregate**. |
| Execute tests, and manage test results. | Use **ApexTestQueueItem and ApexTestResult**. |
| Manage validation rules and workflow rules. | Use **ValidationRule and WorkflowRule**. |

> [!info] 위임 경계 — 객체 상세는 별도 노트
> 위 표는 "전체 그림"용 task 매핑이다. 각 객체의 **필드 카탈로그·SOQL 사용법**은 소관 노트가 권위를 가진다.
> - 작업 사본·컨테이너 배포 패밀리(`MetadataContainer`·`ContainerAsyncRequest`·`ApexClassMember`·`ApexTriggerMember`·`ApexPageMember`·`ApexComponentMember`) → [[Tooling API 배포]]
> - 디버그·로그·리플레이(`TraceFlag`·`ApexLog`·`ApexExecutionOverlayAction`·`ApexExecutionOverlayResult`·HeapDump) → [[Tooling API 디버그·로그·리플레이 sObject]]

---

## Tooling API Release Notes

Salesforce Release Notes로 Tooling API의 최신 업데이트·변경을 확인한다. Tooling API를 포함해 Salesforce Platform에 영향을 주는 업데이트·변경은 API Release Notes를 참조하고, 신규·변경·deprecated된 Tooling API 객체 등 Tooling API 고유 변경은 Tooling API New and Changed Objects를 참조한다.

---

## REST Overview

언어가 JavaScript처럼 strongly typed가 아니라면 REST를 사용한다. 사용법·구문·인증 상세는 REST API Developer Guide 참조.

이 섹션이 다루는 하위 항목:

- **REST Resources** — REST 리소스로 Tooling API 객체에 접근한다. REST 리소스로 Tooling API 객체를 쿼리할 때, 접근에 필요한 사용자 권한은 엔드포인트마다·객체마다 다르다는 점에 유의한다. 사용하려는 엔드포인트와 객체의 설명에서 접근에 필요한 사용자 권한 요구사항을 확인한다.
- **REST Resources for Unit Testing** — Apex·flow 테스트를 한곳에서 retrieve·실행한다. Test Discovery API로 테스트 전모를 본다. Test Runner API로 비동기/동기 실행한다. 둘 다 Tooling API REST 리소스다.
- **REST Resource Examples** — Tooling API REST 리소스를 사용하는 견고한 예제들.
- **REST Headers** — strongly typed가 아닌 언어용 REST.
- **REST Header Examples** — REST 헤더 사용 예.
- **Improve Performance with the Composite Resource** — `/composite` 리소스로 일련의 Tooling API 요청을 단일 호출로 실행해 클라이언트↔서버 왕복 횟수를 최소화한다. API 버전 40.0 이상.
- **Retrieve Compilation Results for Invalid Apex with the `apexCompileResults` Resource** *(v68.0 신규)* — validation error가 있는 Apex 클래스·트리거의 컴파일 결과를 retrieve한다. 결과를 정기적으로 모니터링하면 컴파일 이슈를 탐지·대응할 수 있다. API 68.0 이상. **이 리소스는 Author Apex org 권한을 요구한다.**
- **Retrieve Apex Type Information with the Symbols Resource (Beta)** *(v68.0 신규)* — Apex Symbol API로 built-in·custom·packaged·dynamic Apex 타입(클래스·인터페이스·enum·메서드·트리거 포함)의 상세 메타데이터를 retrieve한다. API 68.0 이상. **이 리소스는 Author Apex org 권한과 View Setup 사용자 권한을 요구한다.**

> 위 두 v68.0 신규 리소스의 **전체 레퍼런스**(파라미터·응답 필드 전수·한도·예제)는 Apex 도메인 노트 [[Tooling API 객체 — Apex 코드·테스트·커버리지]]의 "v68.0 신규 REST 리소스" 절에 있다. 이 노트는 리소스 **카탈로그 등재**만 담당한다.

---

## REST Resources

REST 리소스로 Tooling API 객체에 접근한다. REST 리소스로 쿼리할 때 접근에 필요한 사용자 권한은 엔드포인트·객체마다 다르므로 각 설명에서 확인한다.

각 Tooling API REST 리소스의 base URI는 다음과 같다.
`https://domain/services/data/vXX.X/tooling/`
여기서 `domain`은 org의 My Domain 로그인 URL, `vXX.X`는 API 버전이다. 예:
`https://MyDomainName.my.salesforce.com/services/data/v67.0/tooling/`

### REST Resources Supported by Tooling API (14개 전수 — v68.0 기준)

| REST 리소스 URI | Supported methods | 설명 |
|---|---|---|
| `/apexCompileResults/` | POST | **v68.0 신규.** validation error가 있는 Apex 클래스·트리거의 컴파일 결과를 retrieve. API 68.0+. Author Apex org 권한 필요. 상세는 [[Tooling API 객체 — Apex 코드·테스트·커버리지]] 참조. |
| `/completions?type=` | GET | 참조된 타입의 사용 가능한 code completion을 retrieve. `type=apex`는 Apex system method 심볼 (API 28.0+). `type=visualforce`는 Visualforce 마크업 (API 38.0+). |
| `/executeAnonymous/?anonymousBody=<url encoded body>` | GET | Apex 코드를 익명 실행. API 29.0+. Salesforce는 managed package 내 컴포넌트의 모든 `/executeanonymous` 요청을 차단한다. Block Execute Anonymous from Managed Packages (Release Update) 참조. |
| `/query/?q=SOQL_Query_Statement` | GET | 객체에 대해 쿼리를 실행하고 조건에 맞는 데이터를 반환. Tooling API는 EntityDefinition·FieldDefinition처럼 external object framework를 쓰는 객체를 노출한다 — DB에 존재하지 않고 동적으로 구성된다. virtual entity에는 특수 쿼리 규칙이 적용된다. 결과가 너무 크면 batch로 쪼개진다. 응답은 첫 batch와 query identifier를 포함하고, identifier로 다음 batch를 retrieve할 수 있다. |
| `/runTestsAsynchronous/` | POST | Apex·자동화 flow 테스트를 비동기 실행. Apex 테스트 API 30.0+, 자동화 flow 테스트 API 65.0+. Run Unit Tests Asynchronously 참조. |
| `/runTestsSynchronous/` | POST | Apex·자동화 flow 테스트를 동기 실행. Apex 테스트 API 30.0+, 자동화 flow 테스트 API 65.0+. Run Unit Tests Synchronously 참조. |
| `/search/?q=SOSL_Search_Statement` | GET | 지정 값을 포함하는 레코드를 검색. |
| `/sobjects/` | GET | 사용 가능한 Tooling API 객체와 그 메타데이터를 나열. |
| `/sobjects/SObjectName/` | GET, POST | 지정 객체의 개별 메타데이터를 describe하거나 해당 객체의 레코드를 생성. • ApexExecutionOverlayAction 메타데이터 retrieve는 GET. • ApexExecutionOverlayAction 객체 생성은 POST. |
| `/sobjects/SObjectName/describe/` | GET | 지정 객체의 모든 레벨의 개별 메타데이터를 완전히 describe. 예: Tooling API 객체의 필드·URL·자식 관계를 retrieve. |
| `/sobjects/SObjectName/id/` | GET, PATCH, DELETE | 지정 객체 ID로 레코드에 접근. GET=레코드/필드 retrieve, DELETE=레코드 삭제, PATCH=레코드 업데이트. |
| `/sobjects/ApexLog/id/Body/` | GET | ID로 raw debug log를 retrieve. API 28.0+. |
| `/symbols?category=<builtin, database, or dynamic>` | GET | **v68.0 신규(Beta).** built-in·custom·packaged·dynamic Apex 타입(클래스·인터페이스·enum·메서드·트리거 포함)의 상세 메타데이터를 retrieve. 이 리소스는 API 68.0+. Author Apex org 권한 + View Setup 사용자 권한 필요. 상세는 [[Tooling API 객체 — Apex 코드·테스트·커버리지]] 참조. |
| `/tests/` | GET | Apex·자동화 flow 테스트를 retrieve. API 65.0+. Retrieve Unit Tests 참조. |

---

## REST Resources for Unit Testing

Apex·flow 테스트를 한곳에서 retrieve·실행한다. **Test Discovery API**로 테스트 전모를 보고, **Test Runner API**로 비동기/동기 실행한다. 둘 다 Tooling API REST 리소스다.

> **Note:** Test Discovery API와 Test Runner API는 Flow Builder의 automated flow testing으로 생성된 flow 테스트만 지원한다.

base URI는 `https://domain/services/data/vXX.X/tooling/` (예: `.../v67.0/tooling/`).

하위 항목:
- **Retrieve Unit Tests** — Test Discovery API. Tooling API 65.0+.
- **Run Unit Tests Asynchronously** — Test Runner API. Apex 30.0+, 자동화 flow 65.0+.
- **Run Unit Tests Synchronously** — Test Runner API. 동기 실행 시 모든 테스트 메서드는 같은 클래스에 있어야 한다. Apex 30.0+, 자동화 flow 65.0+.

### Retrieve Unit Tests (Test Discovery API)

Test Discovery API는 Apex·자동화 flow 테스트의 상세를 반환한다. Tooling API 65.0+.

**Syntax**
- **URI:** `/services/data/vXX.X/tooling/tests/`
- **HTTPS Method:** GET
- **Authentication:** `Authorization: Bearer token`
- **Response Encoding:** `X-Chatter-Entity-Encoding: false`
  - **Important:** `X-Chatter-Entity-Encoding` HTTP 요청 헤더를 `false`로 설정해야 클라이언트가 raw(unencoded) 출력을 요청한다. Response Body Encoding 참조.
- **Format:** JSON

**Request Query Parameters**

| Parameter | Type | Description |
|---|---|---|
| `category` | Enum of type String | 테스트를 retrieve할 카테고리 지정. 미지정 시 모든 카테고리의 테스트를 retrieve. 한 호출에 여러 카테고리 지정 불가. API 66.0+. 카테고리: • `apex`—Apex 테스트 클래스만. • `flow`—자동화 flow 테스트 클래스만. |
| `testLevel` | Enum of type String | **v68.0 신규.** test level 기준으로 retrieve할 테스트를 지정. 생략하면 **`RunAllTestsInOrg`이 기본값**. Test Runner API의 `testLevel` **request body 파라미터와 정렬**된다. API 68.0+이며 **`showAllMethods`를 대체(replaces)** 한다. 유효 값: • `RunAllTestsInOrg` — org의 모든 테스트, namespace 무관. **설치된 managed package의 테스트를 포함**한다. • `RunLocalTests` — org namespace의 테스트 + flow 테스트. **설치된 managed package의 테스트를 제외**한다. |
| `showAllMethods` | Boolean | **Deprecated. API 67.0 이하에서만 사용 가능.** API 68.0+에서는 대신 `testLevel`을 쓴다. 테스트 클래스의 모든 메서드(`true`)인지 visible 메서드만(`false`)인지 지정. 미지정 시 기본값 `false`. 표준 Apex visibility 규칙을 따름(namespace·managed package origin·접근 한정자·사용자 권한 영향). 예: private 테스트 클래스는 `showAllMethods=true`가 아니면 retrieve되지 않는다. |
| `namespacePrefix` | String | 테스트를 retrieve할 namespace 지정. 미지정 시 모든 namespace. 모든 자동화 flow 테스트는 FlowTesting namespace에 있다. namespaced 패키지·org에서 자동화 flow 테스트의 full namespace는 `FlowTesting.namespacePrefix`. • API 66.0+: 모든 namespace의 flow 테스트만 쿼리하려면 `category=flow`로 설정하고 `namespacePrefix` 미지정. 특정 namespaced 패키지·org의 flow 테스트만 쿼리하려면 `category=flow` + `namespacePrefix`=namespace. • API 65.0: flow 테스트만 쿼리하려면 `namespacePrefix=FlowTesting`. 특정 namespaced 패키지·org의 flow 테스트는 `namespacePrefix=FlowTesting.namespacePrefix`. |
| `nextRecord` | String | 다음 결과 페이지에서 retrieve할 첫 테스트 클래스를 지정하는 cursor. 현재 페이지의 `nextRecordUrl` 속성에 포함된 값. |
| `pageSize` | Integer | 페이지당 retrieve할 테스트 클래스 수. 미지정 시 기본값 1000 클래스. 최대값 10000 클래스. |

> **v68.0 변경 요약** (`Winter27-v68-Docs/api_tooling.pdf` v68.0 인쇄 p.6–7): `testLevel` 파라미터가 추가되고 `showAllMethods`가 **deprecated** 됐다. `category`·`namespacePrefix`·`nextRecord`·`pageSize`와 Syntax(`X-Chatter-Entity-Encoding: false` 포함)·응답 필드는 v67.0과 동일하다. 릴리즈 맥락은 [[Winter '27/Development]] 참조.

**Request Body:** None.

**Response Body Properties**

| Name | Type | Description |
|---|---|---|
| `apexTestClasses` | Object[] | Apex 테스트 클래스 객체 배열. 결과셋에 테스트가 없으면 `[]`. |
| `size` | Integer | 모든 페이지에 걸친 결과셋의 총 테스트 클래스 수. 결과셋이 비면 `0`. |
| `nextRecordsUrl` | String | 결과셋 다음 페이지의 URL. 현재 페이지가 마지막이면 `null`. |
| `testSetSignature` | String | 결과셋의 테스트 클래스·메서드를 나타내는 MD5 해시. 테스트가 없으면 `""`. 결과셋이 여러 페이지에 걸치면 페이지마다 `testSetSignature`가 달라질 수 있다. 값이 다르면 이전 페이지 retrieve 이후 결과셋의 테스트가 변경된 것이다. |
| `message` | String | 요청에 대한 정보성 메시지(예: 입력 검증 경고), 해당 없으면 `null`. |

`apexTestClasses` 리스트의 각 Apex 테스트 클래스 객체는 다음 속성을 포함한다.

| Name | Type | Description |
|---|---|---|
| `id` | String | 테스트 클래스의 Salesforce ID. 모든 Apex 테스트 클래스는 ID를 가진다. 모든 flow 테스트 클래스가 ID를 갖지는 않는다. flow 테스트 클래스에 ID가 없으면 `id`는 `""`. |
| `name` | String | 테스트 클래스 이름. flow 테스트는 flow의 API name. |
| `namespacePrefix` | String | 테스트 클래스의 namespace. Apex 테스트는 default namespace. namespaced 패키지·org의 Apex 테스트면 `"NamepacePrefix"`, 아니면 `""`. 모든 flow 테스트는 FlowTesting namespace. namespaced 패키지·org의 flow 테스트면 `"FlowTesting.NamepacePrefix"`, 아니면 `"FlowTesting"`. |
| `testMethods` | Object[] | 테스트 클래스의 테스트 메서드 배열. 각 메서드 객체는 메서드명으로 설정된 `name` 속성 포함. 예: `{"name": "testSimpleAddition"}`. flow 테스트 메서드명은 flow API name + 언더스코어(`_`) + flow 테스트 API name. 예: `{"name":"FlowName_UpdateRecordFlowTest"}` |

**Example Request**
```bash
curl
"https://MyDomain.my.salesforce.com/services/data/v67.0/tooling/tests?namespacePrefix=my_namespace&pageSize=2"
\
-H "Authorization: Bearer token" \
-H "X-Chatter-Entity-Encoding: false"
```

**Example Response Body**
```json
{
"apexTestClasses":[
{
"id":"01pxx0000004UVl",
"name":"BAAdditionTest",
"namespacePrefix":"my_namespace",
"testMethods":[
{"name":"testNegativeAddition"},
{"name":"testSimpleAddition"}
]
},
{
"id":"01pxx0000004UXN",
"name":"BABitwiseTest",
"namespacePrefix":"my_namespace",
"testMethods":[
{"name":"testBitwiseAND"},
{"name":"testBitwiseOR"}
]
}
],
"message":null,
"nextRecordsUrl":"/services/data/v67.0/tooling/tests?namespacePrefix=my_namespace&pageSize=2&nextRecord=my_namespace.BAComparisonTest",
"size":10,
"testSetSignature":"91a678b54197669171f11eb824d6765a"
}
```

### Run Unit Tests Asynchronously (Test Runner API)

Test Runner API로 Apex·flow 테스트를 비동기 실행한다. Apex 30.0+, 자동화 flow 65.0+.

**Syntax**
- **URI:** `/services/data/vXX.X/tooling/runTestsAsynchronous/`
- **HTTPS Method:** POST
- **Authentication:** `Authorization: Bearer token`
- **Format:** JSON
- **Request Parameters:** None.

**Request Body Properties** — 지원되는 JSON 요청 본문 형식이 두 가지다.

**(형식 1)** test level 또는 test category로 비동기 테스트를 실행할 수 있다. Apex 테스트는 test class·test suite를 지정할 수 있다.

| Name | Type | Description |
|---|---|---|
| `testLevel` | String | Optional. 실행할 테스트 레벨. `RunSpecifiedTests` 외의 값이면 `classNames`·`classids`·`suitenames`·`suiteids`를 생략한다. 미지정 시 기본값 `RunSpecifiedTests`. 가능한 값: – `RunLocalTests`—installed managed package에서 온 테스트를 제외한 org의 모든 테스트 실행. – `RunAllTestsInOrg`—managed package 테스트를 포함한 org의 모든 테스트 실행. – `RunSpecifiedTests`—지정한 test suite·class만 실행. |
| `Category` | String[] | Optional. 실행할 테스트 카테고리. 미지정 시 모든 카테고리 실행. 배열 값: – `Apex`–Apex 테스트 실행. – `Flow`–flow 테스트 실행. |
| `maxFailedTests` | String | Optional. 허용할 최대 실패 Apex 테스트 수, `"0"`~`"1,000,000"` 정수. 미지정 시 통과/실패 수와 무관하게 모든 Apex 테스트 실행. `"0"`은 실패 발생 시 즉시 중단, `"1"`은 두 번째 실패에서 중단, 이런 식. 높은 값은 성능 저하 가능. `maxFailedTests` 값에 1,000 테스트를 더할 때마다 테스트 실행에 약 3초가 추가된다(테스트 실행 시간 제외). `maxFailedTests`는 flow 테스트를 지원하지 않는다. 테스트 실행 중 실패한 flow 테스트는 `maxFailedTests` 카운트에 포함되지 않는다. |
| `skipCodeCoverage` | String | Optional. 테스트 실행 중 code coverage 수집을 opt out(`"true"`)할지 수집(`"false"`)할지. 미지정 시 기본값 `false`. |
| `classNames` | String | Optional. Apex·flow 테스트 클래스의 쉼표구분 목록. 미지정 시 다른 지정 속성 기준을 충족하는 org의 모든 테스트 클래스 실행. Apex 테스트 클래스는 namespace prefix + 마침표(`.`) + 클래스명. 예: `"customNamepacePrefix.TestClassName"`. namespaced 패키지·org에서 오지 않은 Apex 테스트는 namespace 생략. 예: `"TestClassName"`. 모든 flow 테스트는 FlowTesting namespace이고 flow 테스트 클래스명은 flow의 API name이므로, namespaced가 아닌 flow 테스트는 `"FlowTesting.flowName"`, namespaced 패키지·org의 flow 테스트는 `"FlowTesting.customNamepacePrefix.flowName"`. `classNames`는 flow 테스트를 지원하지 않는다. |
| `classids` | String | Optional. Apex 테스트 클래스 ID의 쉼표구분 목록. 미지정 시 기준 충족하는 모든 Apex 테스트 클래스 실행. `classids`는 flow 테스트를 지원하지 않는다. |
| `suiteNames` | String | Optional. Apex 테스트 suite 이름의 쉼표구분 목록. 미지정 시 기준 충족하는 모든 Apex 테스트 suite 실행. `suiteNames`는 flow 테스트를 지원하지 않는다. |
| `suiteids` | Strings | Optional. Apex 테스트 suite ID의 쉼표구분 목록. 미지정 시 기준 충족하는 모든 Apex 테스트 suite 실행. `suiteids`는 flow 테스트를 지원하지 않는다. |

**(형식 2)** 또는 특정 테스트 클래스·메서드 단위로 비동기 테스트를 실행할 수 있다. 이 형식은 Apex·flow 테스트를 모두 지정할 수 있다.

| Name | Type | Description |
|---|---|---|
| `tests` | Object[] | Required. 실행할 테스트를 나타내는 객체 배열. 각 테스트 객체는 테스트 클래스명 또는 테스트 클래스 ID와, 선택적으로 그 클래스의 메서드를 포함. |
| `maxFailedTests` | String | Optional. 허용할 최대 실패 Apex 테스트 수, `"0"`~`"1,000,000"` 정수. 미지정 시 모든 Apex 테스트 실행. `"0"`=첫 실패 시 중단, `"1"`=두 번째 실패에서 중단. 높은 값은 성능 저하 가능. 1,000 테스트마다 약 3초 추가. `maxFailedTests`는 flow 테스트 미지원. 실패한 flow 테스트는 카운트 제외. |
| `skipCodeCoverage` | String | Optional. code coverage 수집 opt out(`"true"`)/수집(`"false"`). 미지정 시 기본값 `"false"`. |

`tests` 배열의 각 테스트 객체는 다음 속성을 포함할 수 있다.

| Name | Type | Description |
|---|---|---|
| `className` | String | `classId`가 없으면 Required. namespace prefix + 마침표(`.`) + 클래스명. 예: `"customNamepacePrefix.TestClassName"`. namespaced가 아닌 Apex 테스트는 namespace 생략(`"TestClassName"`). 모든 flow 테스트는 FlowTesting namespace, 클래스명은 flow API name → namespaced 아니면 `"FlowTesting.flowName"`, namespaced면 `"FlowTesting.customNamepacePrefix.flowName"`. |
| `classId` | String | `className`이 없으면 Required. Apex 테스트 클래스의 Salesforce ID. `classId`는 flow 테스트 미지원. |
| `testMethods` | String[] | Optional. 실행할 테스트 클래스 내 메서드명. 미지정 시 모든 메서드 실행. flow 테스트는 flow API name + 언더스코어(`_`) + flow 테스트 API name 포함. 예: `FlowName_UpdateRecordFlowTest`. `testMethods` 배열의 중복 메서드명은 무시. 존재하지 않는 테스트 메서드는 skip. |

**Response Body Properties**

| Name | Type | Description |
|---|---|---|
| `root` | String | 실행된 테스트 집합을 식별하는 AsyncApexJob ID. |

**Usage**
- 테스트 진행·결과 요약을 보려면 ApexTestRunResult를 AsyncApexJob ID로 필터해 쿼리한다.
- 완료 후 상세 결과를 보려면 ApexTestResult를 ApexTestRunResult ID로 필터해 쿼리한다.
- `skipCodeCoverage`를 `false`로 설정하면 각 테스트 메서드의 code coverage가 ApexCodeCoverage Tooling API 객체에 저장된다. Testing and Code Coverage 참조.

**Example Request Body: All Tests By Category** (test level·test category 기준 실행)
```json
{
"testLevel": "RunAllTestsInOrg",
"Category": ["Flow", "Apex"],
"skipCodeCoverage": "true"
}
```

**Example Request Body: Specific Tests** (특정 테스트 클래스·메서드 실행)
```json
{
"tests": [
{
"className": "FlowTesting.UpdateAccountDescriptionFlow",
"testMethods": [
"UpdateAccountDescriptionFlow_TestAccountDescriptionUpdated",
"UpdateAccountDescriptionFlow_TestAccountDescriptionHasWords"
]
},
{
"className": "FlowTesting.pkgNs1.UpdateContactDescriptionFlow"
},
{
"className": "my_namespace.BAAdditionTest"
},
{
"className": "SimpleApexTest"
}
],
"maxFailedTests": "2",
"skipCodeCoverage": "false"
}
```

**Example Response Body**
```json
{"root": "707xx0000000bnbh"}
```

### Run Unit Tests Synchronously (Test Runner API)

Test Runner API로 하나 이상의 Apex·flow 테스트를 동기 실행한다. 동기 실행 시 모든 테스트 메서드는 같은 클래스에 있어야 한다. Apex 30.0+, 자동화 flow 65.0+.

API 40.0+에서 `/runTestsSynchronous/`의 POST로 Apex 테스트를 동기 실행하려면 **View Setup** 사용자 권한이 필요하다.

**Syntax**
- **URI:** `/services/data/vXX.X/tooling/runTestsSynchronous/`
- **HTTPS Method:** POST
- **Authentication:** `Authorization: Bearer token`
- **Format:** JSON
- **Request Parameters:** None.

**Request Body Properties**

| Name | Type | Description |
|---|---|---|
| `tests` | Object[] | Required. 테스트 객체를 담은 배열. 테스트 객체는 Apex·flow 테스트 클래스명, Apex 테스트 클래스 ID, 선택적으로 실행할 메서드를 포함. 배열에는 테스트 객체 **하나만** 허용. 속성 정의는 다음 표 참조. |
| `maxFailedTests` | String | Optional. 허용할 최대 실패 Apex 테스트 수, `"0"`~`"1,000,000"` 정수. 미지정 시 모든 Apex 테스트 실행. `"0"`=첫 실패 시 중단, `"1"`=두 번째 실패에서 중단. 높은 값은 성능 저하 가능. 1,000 테스트마다 약 3초 추가. flow 테스트 미지원, 실패한 flow 테스트는 카운트 제외. |
| `skipCodeCoverage` | String | Optional. code coverage 수집 opt out(`"true"`)/수집(`"false"`). 미지정 시 기본값 `"false"`. |

`tests` 배열의 테스트 객체는 다음 속성을 포함할 수 있다.

| Name | Type | Description |
|---|---|---|
| `className` | String | `classId`가 없으면 Required. namespace prefix + 마침표(`.`) + 클래스명. 예: `"customNamepacePrefix.TestClassName"`. namespaced가 아닌 Apex 테스트는 namespace 생략. 모든 flow 테스트는 FlowTesting namespace → `"FlowTesting.flowName"` 또는 `"FlowTesting.customNamepacePrefix.flowName"`. |
| `classId` | String | `className`이 없으면 Required. Apex 테스트 클래스의 Salesforce ID. `classId`는 flow 테스트 미지원. |
| `testMethods` | String[] | Optional. 실행할 메서드명. 미지정 시 모든 메서드 실행. flow 테스트는 flow API name + `_` + flow 테스트 API name. 예: `FlowName_UpdateRecordFlowTest`. 중복 메서드명 무시, 존재하지 않는 메서드 skip. |

**Response Body Properties**

| Name | Type | Description |
|---|---|---|
| `apexLogId` | String | debug logging이 켜져 있으면 테스트 실행 정보를 담은 ApexLog 객체의 ID. debug logging이 꺼져 있으면 `null`. |
| `codeCoverage` | CodeCoverageResult[] | `skipCodeCoverage`가 `"true"`이거나 flow 테스트만 실행되면 빈 배열. `"false"`이고 Apex 테스트를 포함하면 지정 단위 테스트의 code coverage 상세를 담은 CodeCoverageResult 배열. |
| `codeCoverageWarnings` | CodeCoverageWarning[] | `skipCodeCoverage`가 `"true"`이거나 flow 테스트만 실행되면 빈 배열. `"false"`이고 Apex 테스트를 포함하면 실행 가능했던 총 라인 수와, 실행되지 않은 코드의 개수·라인·컬럼 위치를 담은 CodeCoverageWarning 배열. |
| `failures` | Object[] | 테스트 실행 중 실패한 테스트 메서드를 나타내는 객체 배열. |
| `flowCoverage` | FlowCoverageResult[] | `skipCodeCoverage`가 `"true"`이거나 Apex 테스트만 실행되면 빈 배열. `false`이고 flow 테스트를 포함하면 flow 버전과 테스트 실행으로 실행된 요소 수를 담은 FlowCoverageResult 배열. |
| `flowCoverageWarnings` | FlowCoverageWarning[] | `skipCodeCoverage`가 `"true"`이거나 Apex 테스트만 실행되면 빈 배열. `false`이고 flow 테스트를 포함하면 경고를 생성한 flow 버전 정보를 담은 FlowCoverageWarning 배열. |
| `numFailures` | Integer | 테스트 실행 중 실패한 테스트 메서드 수. |
| `numTestsRun` | Integer | 실행된 총 테스트 메서드 수. |
| `successes` | Object[] | 테스트 실행 중 성공한 테스트 메서드를 나타내는 객체 배열. |
| `totaltime` | Integer | 테스트 실행 총 소요시간(밀리초). |

`failures`·`successes` 배열은 테스트 메서드를 나타내는 객체로 구성된다. 각 테스트 객체는 다음 속성을 가진다.

| Name | Type | Description |
|---|---|---|
| `id` | String | 테스트 메서드의 Salesforce ID. |
| `methodName` | String | 테스트 메서드 이름. flow 테스트는 flow 테스트의 API name. |
| `name` | String | 테스트 클래스 이름. flow 테스트는 flow의 API name. |
| `namespace` | String | 테스트 메서드를 담은 테스트 클래스의 namespace prefix. namespaced 패키지·org에서 온 flow 테스트는 `"FlowTesting.NamespacePrefix"`. namespaced가 아닌 Apex·flow 테스트는 `null`. |
| `seeAllData` | Boolean | 테스트 실행 중 메서드가 org의 모든 레코드 데이터에 접근 가능했는지(`true`)/아닌지(`false`). Apex 테스트는 테스트 클래스·메서드의 `isTest(SeeAllData=True)` 어노테이션으로 설정. 자동화 flow 테스트는 항상 `true`. |
| `time` | Integer | 테스트 메서드 실행 소요시간(밀리초). |

`failures` 배열은 추가로 다음 속성을 포함할 수 있다.

| Name | Type | Description |
|---|---|---|
| `message` | String | 실패한 테스트가 반환한 에러 메시지. |
| `stackTrace` | String | 실패한 테스트에서 예외의 위치. |
| `type` | String | For internal use only. 가능한 값: Class |

**Example Request Body**
```json
{
"tests": [
{
"className": "FlowTesting.pkgNs1.UpdateAccountDescriptionFlow",
"testMethods": ["UpdateAccountDescriptionFlow_TestUpdateDescriptionDeleted",
"UpdateAccountDescriptionFlow_TestAccountDescriptionHasWords"]
}
],
"maxFailedTests": "2",
"skipCodeCoverage": "true"
}
```

**Example Response Body**
```json
{
"apexLogId": null,
"codeCoverage": [],
"codeCoverageWarnings": [],
"failures": [],
"flowCoverage": [],
"flowCoverageWarnings": [],
"numFailures": 0,
"numTestsRun": 2,
"successes": [
{
"id": "07Mxx00000000NuEAI",
"methodName": "TestUpdateDescriptionDeleted",
"name": "UpdateAccountDescriptionFlow",
"namespace": "FlowTesting.PkgNs1",
"seeAllData": true,
"time": 12
},
{
"id": "07Mxx00000000NtEAI",
"methodName": "TestAccountDescriptionHasWords",
"name": "UpdateAccountDescriptionFlow",
"namespace": "FlowTesting.PkgNs1",
"seeAllData": true,
"time": 129
}
],
"totalTime": 12189
}
```

---

## REST Resource Examples

Tooling API REST 리소스를 사용하는 예제. 아래 예제는 Apex로 REST 요청을 실행하지만 어떤 표준 REST 도구를 써도 Tooling API에 접근할 수 있다.

> **Note:** 이 가이드의 예제는 org의 My Domain 이름 자리에 MyDomainName을 넣은 production 로그인 URL을 쓴다. sandbox 로그인 URL 형식은 다르다. 예제를 사용하려면 로그인 URL을 갱신한다. My Domain 이름과 My Domain 로그인 URL은 Setup의 My Domain 페이지에서 확인한다.

먼저 org 연결과 HTTP 요청 타입을 설정한다.
```apex
HttpRequest req = new HttpRequest();
req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
req.setHeader('Content-Type', 'application/json');
```

각 요청 끝에 다음 코드를 추가해 요청을 보내고 응답 본문을 retrieve한다.
```apex
Http h = new Http();
HttpResponse res = h.send(req);
system.debug(res.getBody());
```

**Retrieve a Description** — Tooling API의 모든 사용 가능 객체 description:
```apex
req.setEndpoint('https://MyDomainName.my.salesforce.com/services/data/v67.0/tooling/sobjects/');
req.setMethod('GET');
```

특정 Tooling API 객체(예: TraceFlag) description:
```apex
req.setEndpoint('https://MyDomainName.my.salesforce.com/services/data/v67.0/tooling/sobjects/
TraceFlag/');
req.setMethod('GET');
```

특정 객체(예: TraceFlag)의 모든 메타데이터 description:
```apex
req.setEndpoint('https://MyDomainName.my.salesforce.com/services/data/v67.0/tooling/sobjects/
TraceFlag/describe/');
req.setMethod('GET');
```

**Manipulate Objects by ID** — 새 Tooling API 객체(예: MetadataContainer) 생성:
```apex
req.setEndpoint('https://MyDomainName.my.salesforce.com/services/data/v67.0/tooling/sobjects/
MetadataContainer/');
req.setBody('{"Name":"TestContainer"}');
req.setMethod('POST');
```

> **Tip:** 이 호출에서 받은 ID를 나머지 예제에서 사용한다.

ID로 Tooling API 객체(예: MetadataContainer) retrieve:
```apex
req.setEndpoint('https://MyDomainName.my.salesforce.com/services/data/v67.0/tooling/sobjects/
MetadataContainer/ + containerID + '/');
req.setMethod('GET');
```

ID로 객체 업데이트:
```apex
req.setEndpoint('https://MyDomainName.my.salesforce.com/services/data/v67.0/tooling/sobjects/
MetadataContainer/ + containerID + '/');
req.setBody('{"Name":"NewlyNamedContainer"}');
req.setMethod('PATCH');
```

ID로 객체 쿼리:
```apex
req.setEndpoint('https://MyDomainName.my.salesforce.com/services/data/v67.0/tooling/query/?q=
Select+id,Name+from+MetadataContainer+Where+ID=\'' + containerID + '\'');
req.setMethod('GET');
```

**Query Within MetadataContainer** — MetadataContainer 내부 객체 쿼리:
```apex
req.setEndpoint('https://MyDomainName.my.salesforce.com/services/data/v67.0/tooling/query/?q=
Select+id,Body,LastSyncDate,Metadata+from+ApexClassMember+Where+MetadataContainerID=\'
+ containerID + '\'');
req.setMethod('GET');
```

**Check Deployment Status** — ContainerAsyncRequest로 배포 상태 확인:
```apex
req.setEndpoint('https://MyDomainName.my.salesforce.com/services/data/v67.0/tooling/sobjects/
ContainerAsyncRequest/' + requestID + '/');
req.setMethod('GET');
```

**Execute Anonymous Apex** — 익명 Apex 실행:
```apex
req.setEndpoint('https://MyDomainName.my.salesforce.com/services/data/v67.0/tooling/executeAnonymous/?
anonymousBody=System.debug('Test')%3B');
req.setMethod('GET');
```

**Retrieve Apex** — 내 Apex 클래스·트리거 및 installed managed package의 global Apex 클래스·트리거 retrieve:
```apex
req.setEndpoint('https://MyDomainName.my.salesforce.com/services/data/v67.0/tooling/apexManifest');
req.setMethod('GET');
```

**Execute Apex Unit Tests** — `runTestsSynchronous` 또는 `runTestsAsynchronous` 리소스를 사용한다. 아래 예제는 JavaScript로 `runTestsSynchronous`에 POST하는 방법을 보여준다. 주석 블록은 이 호출들이 반환하는 객체를 나타낸다.
```javascript
var xhttp = new XMLHttpRequest();
xhttp.open("POST",
"https://MyDomainName.my.salesforce.com/services/data/v67.0/tooling/runTestsSynchronous/",
true)
// SESSION_ID is the session ID
xhttp.setRequestHeader("Authorization", "OAuth <SESSION_ID>")
xhttp.setRequestHeader('Accept', "application/json");
// testObject should include a list of object(s) with the classId and list of
//
desired test methods for the desired classes to be tested
testObject = {tests: [{classId: "N0tARealClassId", testMethods: ["testMethod1",
"testMethod2"]}]}
requestObject = json.stringify(testObject);
response = xhttp.send(requestObject)
response = JSON.parse(response)
/*
{
"successes": [
{
"namespace": null,
"name": "MyTestClass",
"methodName": "testMethod1",
"id": "N0tARealTestId1",
"time": 1167,
"seeAllData": false
},
{
"namespace": null,
"name": "MyTestClass",
"methodName": "testMethod2",
"id": "N0tARealTestId2",
"time": 47,
"seeAllData": false
}
],
"failures": [
{
"type": "Class",
"namespace": null,
"name": "MyTestClass",
"methodName": "testMethod3",
"message": "System.AssertException: Assertion Failed",
"stackTrace": "Class.MyTestClass.testMethod3: line 13, column 1",
"id": "01pxx0000000JTpAAM",
"seeAllData": false,
"time": 27,
"packageName": "MyTestClass"
},
{
"type": "Class",
"namespace": null,
"name": "MyTestClass",
"methodName": "testMethod4",
"message": "System.AssertException: Assertion Failed",
"stackTrace": "Class.MyTestClass.testMethod4: line 17, column 1",
"id": "01pxx0000000JTpAAM",
"seeAllData": false,
"time": 32,
"packageName": "MyTestClass"
}
],
"totalTime": 143,
"apexLogId": "07Lxx0000000A9NEAU",
"numFailures": 2,
"codeCoverage": [
],
"codeCoverageWarnings": [
],
"numTestsRun": 4
}
*/
// Check how many tests ran
response["numTestRun"] === 4
// Check how many tests passed
response["successes"].length === 2
// Return a list of objects that correspond to the tests that passed
response["successes"]
/*
[
{
"id": "N0tARealTestId1",
"methodName": "testMethod1",
"name": "MyTestClass",
"namespace": null,
"seeAllData": false,
"time": 1167
}
]
*/
// Access the first object in the list
response["successes"][0]["name"] === "MyTestClass"
response["successes"][0]["methodName"] === "testMethod1"
// This ID refers to the classId
response["successes"][0]["id"] === "MyTestClass"
response["successes"][0]["time"] === 1167 // milliseconds
response["failures"]
/*
{
"type": "Class",
"namespace": null,
"name": "MyTestClass",
"methodName": "testMethod3",
"message": "System.AssertException: Assertion Failed",
"stackTrace": "Class.MyTestClass.testMethod3: line 13, column 1",
"id": "01pxx0000000JTpAAM",
"seeAllData": false,
"time": 27,
"packageName": "MyTestClass"
},
{
"type": "Class",
"namespace": null,
"name": "MyTestClass",
"methodName": "testMethod4",
"message": "System.AssertException: Assertion Failed",
"stackTrace": "Class.MyTestClass.testMethod4: line 17, column 1",
"id": "01pxx0000000JTpAAM",
"seeAllData": false,
"time": 32,
"packageName": "MyTestClass"
}
*/
response["failures"][0]["name"] === "MyTestClass"
response["failures"][0]["methodName"] === "testMethod3"
response["failures"][0]["message"] === "System.AssertException: Assertion Failed"
response["failures"][0]["stackTrace"] === "Class.MyTestClass.testMethod3: line 13, column
1"
response["failures"][0]["time"] === 27
```

> 원문 표기 주의: 위 코드의 `response["numTestRun"]`은 Response 속성명 `numTestsRun`과 철자가 다르나 PDF 원문 그대로 유지함.

> 위 예제에 등장하는 `MetadataContainer`·`ApexClassMember`·`ContainerAsyncRequest`는 REST **호출 표면**을 보여주기 위한 것이다. 각 객체의 필드 카탈로그·컨테이너 배포 워크플로우는 [[Tooling API 배포]]에서 다룬다.

---

## REST Headers

언어가 strongly typed가 아니라면 REST를 사용한다. 사용법·구문·인증 상세는 REST API Developer Guide 참조. Tooling API WSDL의 REST 헤더는 가이드의 **REST Headers for Tooling API**(Ch6, 인쇄 p993)에 기술되며, 해당 헤더 전수는 별도 헤더 노트(작성 예정)에서 다룬다.

### REST Header Examples

REST 헤더를 사용하는 예제. 아래는 Apex로 헤더를 포함해 REST 요청을 실행하지만 어떤 표준 REST 도구를 써도 된다.

먼저 org 연결과 HTTP 요청 타입을 설정한다.
```apex
HttpRequest req = new HttpRequest();
req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
req.setHeader('Content-Type', 'application/json');
```

각 요청 끝에 다음을 추가해 요청을 보내고 응답을 retrieve한다.
```apex
Http h = new Http();
HttpResponse res = h.send(req);
system.debug(res.getBody());
```

---

## Improve Performance with the Composite Resource

`/composite` 리소스는 Tooling API로 빌드한 개발 도구·앱의 성능을 개선한다. 일련의 Tooling API 요청을 **단일 호출**로 실행해 클라이언트↔서버 왕복을 최소화한다. 한 요청의 출력을 후속 요청의 입력으로 쓸 수 있다. 각 요청의 응답 본문과 HTTP 상태가 단일 응답 본문으로 반환된다. **전체 요청은 API 한도에서 단일 호출로 계산된다.** API 버전 40.0 이상.

최신 API 한도는 Salesforce Developer Limits Quick Reference 참조. Salesforce 계약에 따른 contractual limit도 적용될 수 있다.

composite 호출 안의 요청들을 **subrequest**라 하며, 모두 같은 사용자 컨텍스트에서 실행된다. subrequest 본문에 reference ID를 지정해 응답에 매핑하고, 이후 subrequest의 `url`·`body` 필드에서 JavaScript 유사 reference 표기로 그 ID를 참조한다.

한 subrequest의 에러가 전체 composite를 roll back할지, 의존하는 subrequest만 영향받을지 지정할 수 있다. subrequest별 헤더도 지정할 수 있다.

composite를 지원하는 리소스:
- 모든 sObject 리소스 (`vXX.X/tooling/sobjects/`)
- Query 리소스 (`vXX.X/tooling/query/?q=soql`)

> **Note:** 단일 호출에 최대 **25개** subrequest를 둘 수 있고, 그중 최대 **5개**가 query 연산일 수 있다.

- **URI:** `/vXX.X/composite`
- **Formats:** JSON
- **HTTP method:** GET(사용 가능한 다른 composite 리소스 나열), POST
- **Authentication:** `Authorization: Bearer token`
- **Parameters:** None required
- **Request body:** Composite Request Body
- **Response body:** Composite Response Body

**Example** — 다음 composite 요청 본문은 5개 subrequest를 포함한다.
- 첫 번째: MetadataContainer 생성.
- 두 번째: ApexClassMember 생성.
- 세 번째: ContainerAsyncRequest 생성 + 비동기 배포 시작.
- 네 번째: 생성된 ContainerAsyncRequest 조회.
- 다섯 번째: 생성된 MetadataContainer 조회.

다섯 subrequest는 API 한도에서 단일 호출로 계산된다.
```json
{
"allOrNone":false,
"compositeRequest":
[
{
"method":"POST",
"body":{
"Name":"MetadataContainer Unique Name"
},
“url":"/services/data/v40.0/tooling/sobjects/metadatacontainer/",
"referenceId":"metadatacontainer_reference_id"
},
{
"method":"POST",
"body":{
"contententityid":"<ID of an ApexClass you want to update>" ,
"fullname":"ApexClassMemberUniqueFullName",
"body":"public class Classtest2test {}",
"MetadataContainerId":"@{metadatacontainer_reference_id.id}"
},
"url":"/services/data/v40.0/tooling/sobjects/apexclassmember/",
"referenceId":"apexclassmember_reference_id"
},
{
"method":"POST",
"body":{
"IsCheckOnly":"false",
"MetadataContainerId":"@{metadatacontainer_reference_id.id}"
},
"url":"/services/data/v40.0/tooling/sobjects/containerasyncrequest/",
"referenceId":"containerasyncrequest_reference_id"
},
{
"method":"GET",
"url":"/services/data/v40.0/tooling/sobjects/containerasyncrequest/@{containerasyncrequest_reference_id.id}",
"referenceId":"containerasyncrequest_GET_reference_id"
},
{
"method":"GET",
"url":"/services/data/v40.0/tooling/sobjects/metadatacontainer/@{metadatacontainer_reference_id.id}",
"referenceId":"metadatacontainer_GET_reference_id"
}
]
}
```

> 위 composite 예제의 `“url"`(첫 subrequest 여는 따옴표가 곡선따옴표)은 PDF 원문 표기 그대로 유지함. 등장하는 컨테이너 배포 객체 상세는 [[Tooling API 배포]] 참조.

### Composite Request Body

`/composite` 리소스로 실행할 subrequest 컬렉션을 기술한다.

**Composite Collection Input** — 요청 본문은 에러 롤백 방식을 지정하는 `allOrNone` 플래그와, 실행할 subrequest를 담은 `compositeRequest` 컬렉션을 포함한다.

**Properties**

| Name | Type | Description | Required or Optional |
|---|---|---|---|
| `allOrNone` | Boolean | subrequest 처리 중 에러 발생 시 동작. `true`면 전체 composite 요청이 roll back. `false`면 실패한 subrequest에 의존하지 않는 나머지 subrequest가 실행되고, 의존하는 subrequest는 실행되지 않는다. 어느 경우든 top-level 요청은 HTTP 200을 반환하고 각 subrequest의 응답을 포함한다. | Optional |
| `compositeRequest` | Composite Subrequest[] | 실행할 subrequest 컬렉션. | Required |

**JSON example**
```json
{
"allOrNone" : true,
"compositeRequest" : [{

Composite Subrequest
},{

Composite Subrequest
},{

Composite Subrequest
}]
}
```

**Composite Subrequest** — subrequest의 resource·method·headers·body·reference ID를 담는다.

**Properties**

| Name | Type | Description | Required or Optional |
|---|---|---|---|
| `body` | The type depends on the request specified in the `url` property. | subrequest의 입력 본문. | Optional |
| `httpHeaders` | Map<String, String> | subrequest에 포함할 요청 헤더와 값. 단 subrequest는 top-level 요청의 값을 상속하므로 다음 헤더는 포함할 수 없다: • Accept • Authorization • Content-Type. subrequest에 이 헤더들을 지정하면 top-level 요청이 실패하고 HTTP 400을 반환한다. | Optional |
| `method` | String | 요청 리소스에 사용할 method. 가능한 값: POST, PUT, PATCH, GET, DELETE(대소문자 구분). 유효한 method 목록은 해당 리소스 문서 참조. | Required |
| `referenceId` | String | subrequest 응답에 매핑되어 이후 subrequest에서 응답을 참조하는 데 쓰는 Reference ID. `referenceId`는 subrequest의 body·URL에 포함할 수 있다. 참조 구문: `@{referenceId.FieldName}`. `referenceId`는 대소문자 구분. 두 연산자를 쓸 수 있다: `.`는 응답의 JSON 객체 필드 참조, `[]`는 응답의 JSON 컬렉션 인덱싱. 응답 컨텍스트에서 의미가 있는 한 각 연산자를 재귀적으로 쓸 수 있다. | Required |
| `url` | String | 요청할 리소스. • subrequest가 지원하는 query string 파라미터를 포함할 수 있다. query string은 URL-encoded 여야 한다. • URL은 `/services/data/vXX.X/tooling`으로 시작해야 한다. • 파라미터로 응답 본문을 필터할 수 있다. | Required |

**Usage** — `referenceId`는 대소문자 구분이므로 참조하는 필드의 대소문자가 정확한지 확인한다. 같은 필드도 컨텍스트에 따라 대소문자가 다를 수 있다.

> **Note:** 단일 호출에 최대 25개 subrequest, 그중 최대 5개가 query 연산.

### Composite Response Body

`/composite` 요청의 결과를 기술한다.

**Composite Results — Properties**

| Name | Type | Description |
|---|---|---|
| `compositeResponse` | Composite Subrequest Result[] | subrequest 결과 컬렉션 |

**JSON Example**
```json
{
"compositeResponse" : [{

Composite Subrequest Result
},{

Composite Subrequest Result
},{

Composite Subrequest Result
}]
}
```

**Composite Subrequest Result — Properties**

| Name | Type | Description |
|---|---|---|
| `body` | The type depends on the response type of the subrequest. | 이 subrequest의 응답 본문. subrequest가 에러를 반환하면 본문에 에러 코드·메시지를 포함. |
| `httpHeaders` | Map<String, String> | 이 subrequest의 응답 헤더와 값. `/composite` 리소스는 Content-Length 헤더를 지원하지 않으므로 subrequest 응답에도 top-level 응답에도 이 헤더가 없다. |
| `httpStatusCode` | Integer | 이 subrequest의 HTTP 상태 코드. composite 요청에서 `allOrNone`이 `true`이고 한 subrequest가 에러를 반환하면 다른 모든 subrequest는 400 HTTP 상태 코드를 반환한다. |
| `referenceID` | String | subrequest에 지정된 reference ID. subrequest와 결과를 연결하는 데 사용. |

**JSON example**
```json
{
"body" : {
"id" : "001R00000033I6AIAU",
"success" : true,
"errors" : [ ]
},
"httpHeaders" : {
"Location" :
"/services/data/v40.0/tooling/sobjects/apexclassmember/001R00000033I6AIAU"
},
"httpStatusCode" : 201,
"referenceId" : "apexclassmember_reference_id"
}
```

---

## API End-of-Life Policy

어떤 Tooling REST·SOAP API 버전이 supported / unsupported / unavailable인지 확인한다.

Salesforce는 각 API 버전을 최초 릴리스로부터 **최소 3년** 지원한다. 품질·성능 개선을 위해 3년 이상 된 버전은 더 이상 지원되지 않을 수 있다. Salesforce는 deprecation 예정 API 버전을 사용하는 고객에게 지원 종료 **최소 1년 전**에 통지한다.

**버전 지원 표 — v68.0(Winter '27) 판** (출처: `Winter27-v68-Docs/api_tooling.pdf` 인쇄 **p.37–38**. 표는 p.37에서 시작해 p.38로 이어지며 헤더 행이 반복된다. `-layout`·비-layout 양쪽 추출로 셀별 대조 완료)

| Salesforce API Versions | Version Support Status | Version Retirement Info |
|---|---|---|
| Versions 41.0 through 66.0 | Supported. | *(원문 셀 비어 있음)* |
| Versions 31.0 through 40.0 | Supported.<br>Deprecated and unsupported from Summer '27.<br>Retired from Summer '28. | Salesforce Platform API Versions 31.0 through 40.0 Retirement |
| Versions 21.0 through 30.0 | As of Summer '25, these versions are retired and unavailable. | Salesforce Platform API Versions 21.0 through 30.0 Retirement |
| Versions 7.0 through 20.0 | As of Summer '22, these versions are retired and unavailable. | Salesforce Platform API Versions 7.0 through 20.0 Retirement |

> **PDF 원문 (인쇄 p.38, `Versions 31.0 through 40.0` 행)**: *"Supported. / Deprecated and unsupported from Summer '27. / Retired from Summer '28."* — Version Retirement Info 열은 *"Salesforce Platform API Versions 31.0 through 40.0 Retirement"*.

**읽는 법 — 31.0–40.0은 "지금은 지원, 예고된 2단계 종료"다.** v68.0 시점에 31.0–40.0은 여전히 **Supported**이고, ① **Summer '27부터 deprecated·unsupported**, ② **Summer '28부터 retired**(요청 불가)로 두 시점이 따로 예고돼 있다. 41.0–66.0만이 종료 예고 없는 순수 지원 구간이다.

> [!warning] 판(edition) 표시 — 다음 drift를 눈에 보이게
> 위 표는 **v68.0 (Winter '27) 판**이다. **v67.0(Summer '26) 판에서는 `Versions 31.0 through 66.0 | Supported. | (없음)` 한 행**이었고, v68.0에서 이 행이 **41.0–66.0**과 **31.0–40.0**(신규 종료 예고 포함) **두 행으로 분리**됐다. 다음 릴리즈 PDF에서도 이 표를 최우선으로 재대조한다.

**릴리즈 노트와의 정합성 (교차 확인함)**

| 대역 | v68.0 PDF (인쇄 p.37–38) | Winter '27 릴리즈 노트 | 판정 |
|---|---|---|---|
| 41.0–66.0 | Supported. 종료 정보 없음 | 대응 항목 없음 | 상충 없음 |
| 31.0–40.0 | Supported → Summer '27 deprecated·unsupported → Summer '28 retired | **대응 릴리즈 노트 항목 없음** (Winter '27 노트의 31.0–64.0 항목은 **SOAP `login()` 호출 은퇴**로 *별개 항목*이다 — API 버전 은퇴가 아님) | 상충 없음. 현재는 **PDF만이 소스** |
| 21.0–30.0 | As of Summer '25, retired and unavailable. | `rn_api_retirement_delay_256rn` — 당초 Summer '23 예정 → **Summer '25로 연기**, Summer '25부터 미지원·사용 불가 ([[Winter '27/Development]], [[Winter '27/Release Updates]]) | **일치** (PDF의 "As of Summer '25" = 릴리즈 노트의 연기 후 확정 시점) |
| 7.0–20.0 | As of Summer '22, retired and unavailable. | 대응 항목 없음 | 상충 없음 |

> 21.0–30.0의 **연기 이력(Summer '23 → Summer '25)** 과 Test Run 절차는 PDF 표에 없고 릴리즈 노트에만 있다 — [[Winter '27/Development]]의 "API 21.0–30.0 은퇴" 절이 그 정본이다. 31.0–40.0 대역의 은퇴 Release Update가 향후 릴리즈 노트에 등장하면 이 표와 대조한다.

- retired API 버전의 리소스·연산을 요청하면 REST API는 `410:GONE` 에러 코드를 반환한다.
- retired API 버전의 리소스·연산을 요청하면 SOAP API는 `500:UNSUPPORTED_API_VERSION` 에러 코드를 반환한다.
- 오래되거나 unsupported된 API 버전에서 온 요청을 식별하려면 API Total Usage event type을 사용한다.

---

## SOAP Calls

Java처럼 strongly typed이고 web service 클라이언트 코드를 생성하는 언어라면 SOAP를 사용한다. 사용법·구문·인증 상세는 SOAP API Developer Guide 참조.

Tooling API WSDL에 접근하려면 Setup에서 Quick Find에 `API`를 입력하고 **API** 선택 후 **Generate Tooling WSDL**을 클릭한다.

Salesforce SOAP API처럼 Tooling API도 다음 호출을 사용한다. (16개 전수)

| SOAP Call | 설명 |
|---|---|
| `create()` | 조직 데이터에 하나 이상의 레코드를 추가. Metadata 필드를 가진 객체를 생성할 때는 한 요청에 객체 하나만 처리할 수 있다. |
| `delete()` | 조직 데이터에서 하나 이상의 레코드를 삭제. |
| `describeLayout()` | 지정 SObject의 page layout 메타데이터를 retrieve. (원문 표기 `SOjbect`) |
| `describeGlobal()` | 사용 가능한 Tooling API 객체와 그 메타데이터를 나열. |
| `describeSObjects()` | 지정 객체(또는 객체 배열)의 메타데이터(필드 목록·객체 속성)를 describe. `describeGlobal()`로 모든 Tooling API 객체 목록을 retrieve한 뒤 순회하며 `describeSObjects()`로 개별 객체 메타데이터를 얻는다. |
| `describeValueType()` | 지정 namespace와 value type의 메타데이터를 describe. describeValueType 정보는 Metadata API Developer Guide 참조. |
| `describeWorkitemActions()` | 지정 work item에 사용 가능한 action을 describe. |
| `executeanonymous(string apexcode)` | 지정한 Apex 블록을 익명 실행하고 결과를 반환. |
| `query()` | Tooling API 객체에 대해 쿼리를 실행하고 조건에 맞는 데이터를 반환. |
| `queryMore()` | `query()`로부터 다음 batch의 객체를 retrieve. |
| `retrieve()` | 지정 ID 기반으로 하나 이상의 레코드를 retrieve. |
| `runTests()` | 동기 테스트 실행 메커니즘으로 Apex 클래스 내 하나 이상의 메서드를 실행. 동기 실행 시 모든 테스트 메서드는 같은 클래스에 있어야 한다. 동기 `runTests()`는 RunTestsRequest 객체를 받는다. 샘플 코드·상세는 runTests() 참조. |
| `runTestsAsynchronous()` | 비동기 테스트 실행 메커니즘으로 하나 이상 Apex 클래스 내 하나 이상의 메서드를 실행. (상세는 아래 참조) |
| `search()` | 지정 텍스트 문자열에 일치하는 레코드를 검색. |
| `update()` | 조직 데이터의 기존 레코드 하나 이상을 업데이트. Metadata 필드를 가진 객체 업데이트 시 한 요청당 객체 하나만 업데이트할 수 있다. |
| `upsert()` | 레코드를 생성하고 기존 레코드를 업데이트; custom 필드로 기존 레코드 존재 여부를 판단. Metadata 필드를 가진 객체 upsert 시 한 요청당 객체 하나만 전달한다. |

### runTestsAsynchronous() 상세

비동기 테스트 실행 메커니즘으로 하나 이상 Apex 클래스 내 하나 이상의 메서드를 실행한다. 다음 예제는 runTestsAsynchronous 엔드포인트를 호출하는 클래스 호출을 보여준다.
```java
conn.runTestsAsynchronous(classids, suiteids, maxFailedTests,
testLevel.value,
classNames, suiteNames, tests, skipCodeCoverage)
```

더 많은 runTestsAsynchronous() 예제 코드는 ApexTestQueueItem 참조.

**모든 파라미터는 mandatory.** 일부 파라미터만 값을 주려면 나머지는 `null`로 지정한다.

- `classids`·`suiteids`·`classNames`·`suiteNames`는 모두 지정해야 한다. 일부만 값을 주려면 나머지는 `null`. `TestLevel.RunLocalTests` 또는 `TestLevel.RunAllTestsInOrg`를 쓰려면 class·suite 관련 파라미터를 모두 `null`로.
- `maxFailedTests` 값은 mandatory. 실패 수와 무관하게 org의 모든 테스트를 실행하려면 `-1`로 설정. 일정 수 실패 후 새 테스트 실행을 중단하려면 `0`~`1,000,000` 정수로 설정. 이 정수가 최대 허용 실패 수다. `0`=실패 발생 시 즉시 중단, `1`=두 번째 실패에서 중단. 높은 값은 성능 저하 가능. 1,000 테스트마다 약 3초 추가(테스트 실행 시간 제외).
- `testLevel`은 API 37.0+에서 사용 가능·required지만 값은 `null`일 수 있다. 허용 값:
  - **RunSpecifiedTests** — 지정한 테스트만 실행.
  - **RunLocalTests** — installed managed package에서 온 것을 제외한 org의 모든 테스트 실행. 이 값을 쓸 때는 특정 테스트 식별자를 생략.
  - **RunAllTestsInOrg** — 모든 테스트 실행(managed package 테스트 포함). 이 값을 쓸 때는 특정 테스트 식별자를 생략.
- `tests`는 API 41.0+에서 사용 가능·required지만 값은 `null`일 수 있다. TestsNode 타입의 배열이다.
- `skipCodeCoverage`는 API 43.0+에서 사용 가능하나 값은 `null`일 수 있다. 테스트 실행 중 code coverage 수집을 opt out할지 나타내는 boolean이다.

### SOAP Headers

Tooling API WSDL의 SOAP 헤더는 가이드의 **SOAP Headers for Tooling API**(Ch5)에 기술되며, 헤더 전수는 별도 헤더 노트(작성 예정)에서 다룬다.

### SOAP Examples

다음 예제는 C#을 쓰지만 web service를 지원하는 어떤 언어든 사용할 수 있다.

Developer Edition·sandbox org에서 Apex 클래스·트리거를 컴파일하려면 `create()`를 사용한다. 다음 샘플은 ApexClass로 SayHello 메서드 하나를 가진 단순 클래스를 컴파일한다.
```csharp
String classBody = "public class Messages {\n"
+ "public string SayHello() {\n"
+ " return 'Hello';\n" + "}\n"
+ "}";
// create an ApexClass object and set the body
ApexClass apexClass = new ApexClass();
apexClass.Body = classBody;
ApexClass[] classes = { apexClass };
// call create() to add the class
SaveResult[] saveResults = sforce.create(classes);
for (int i = 0; i < saveResults.Length; i++)
{
if (saveResults[i].success)
{
Console.WriteLine("Successfully created Class: " +
saveResults[i].id);
}
else
{
Console.WriteLine("Error: could not create Class ");
Console.WriteLine("
The error reported was: " +
saveResults[i].errors[0].message + "\n");
}
}
```

ContainerAsyncRequest의 `IsCheckOnly` 파라미터는 비동기 요청이 코드를 컴파일하되 실행·저장하지 않는지(`true`), 컴파일하고 저장하는지(`false`)를 나타낸다.

다음 예제는 `SayHello()` 메서드를 first·last name을 받도록 수정한다. MetadataContainer + ApexClassMember로 클래스를 retrieve·업데이트하고, ContainerAsyncRequest로 변경을 컴파일·배포한다. 같은 방법을 ApexTriggerMember·ApexComponentMember·ApexPageMember에도 쓸 수 있다.

> **Note:** 코드를 테스트하려면 다음 샘플의 IsCheckOnly 파라미터를 수정하고, 성공 실행 후 org에 로그인해 결과를 확인한다.
> • `IsCheckOnly = true`면 `SayHello()`는 그대로다. ApexClassMember는 컴파일 결과를 담지만 서버의 클래스는 변하지 않는다.
> • `IsCheckOnly = false`면 `SayHello()`가 first·last name을 받도록 변경된다.

```csharp
String updatedClassBody = "public class Messages {\n"
+ "public string SayHello(string fName, string lName) {\n"
+ " return 'Hello ' + fName + ' ' + lName;\n" + "}\n"
+ "}";
//create the metadata container object
MetadataContainer Container = new MetadataContainer();
Container.Name = "SampleContainer";
MetadataContainer[] Containers = { Container };
SaveResult[] containerResults = sforce.create(Containers);
if (containerResults[0].success)
{
String containerId = containerResults[0].id;
//create the ApexClassMember object
ApexClassMember classMember = new ApexClassMember();
//pass in the class ID from the first example
classMember.ContentEntityId = classId;
classMember.Body = updatedClassBody;
//pass the ID of the container created in the first step
classMember.MetadataContainerId = containerId;
ApexClassMember[] classMembers = { classMember };
SaveResult[] MembersResults = sforce.create(classMembers);
if (MembersResults[0].success)
{
//create the ContainerAsyncRequest object
ContainerAsyncRequest request = new ContainerAsyncRequest();
//if the code compiled successfully, save the updated class
to the server
//change to IsCheckOnly = true to compile without saving
request.IsCheckOnly = false;
request.MetadataContainerId = containerId;
ContainerAsyncRequest[] requests = { request };
SaveResult[] RequestResults = sforce.create(requests);
if (RequestResults[0].success)
{
string requestId = RequestResults[0].id;
//poll the server until the process completes
QueryResult queryResult = null;
String soql = "SELECT Id, State, ErrorMsg
FROM ContainerAsyncRequest
Where id = '" + requestId + "'";
queryResult = sforce.query(soql);
if (queryResult.size > 0)
{
ContainerAsyncRequest _request =
(ContainerAsyncRequest)queryResult.records[0];
while (_request.State.ToLower() == "queued")
{
//pause the process for 2 seconds
Thread.Sleep(2000);
//poll the server again for completion
queryResult = sforce.query(soql);
_request =
(ContainerAsyncRequest)queryResult.records[0];
}
//now process the result
switch (_request.State)
{
case "Invalidated":
break;
case "Completed":
//class compiled successfully
//see the next example on how to process the
SymbolTable
break;
case "Failed":
. .
break;
case "Error":
break;
case "Aborted":
break;
}
}
else
{
//no rows returned
}
}
else
{
Console.WriteLine("Error: could not create
ContainerAsyncRequest object");
Console.WriteLine("
The error reported was: " +
RequestResults[0].errors[0].message + "\n");
}
}
else
{
Console.WriteLine("Error: could not create Class Member ");
Console.WriteLine("
The error reported was: " +
MembersResults[0].errors[0].message + "\n");
}
}
else
{
.. Console.WriteLine("Error: could not create MetadataContainer
");
Console.WriteLine("
The error reported was: " +
containerResults[0].errors[0].message + "\n");
}
}
```

Apex 클래스·트리거 데이터를 구조화된 형식으로 접근하려면 SymbolTable을 사용한다. 다음 샘플은 이전 예제에서 생성한 ApexClassMember를 쿼리해 수정 클래스의 SymbolTable을 얻는다.

> **Note:** 사용하는 SOQL 문은 데이터를 언제 retrieve하는지에 따라 다르다.
> • 이전 샘플 내부에서 쿼리를 실행하려면 ContainerAsyncRequest의 ID를 쓴다. 예: `SELECT Body, ContentEntityId, SymbolTable FROM ApexClassMember where MetadataContainerId = '" + requestId + "'"`
> • 그렇지 않으면 다음 샘플처럼 수정 클래스의 ID를 쓴다. 예: `SELECT ContentEntityId, SymbolTable FROM ApexClassMember where ContentEntityId = '" + classId + "'"`

```csharp
//use the ID of the class from the previous step
string classId = "01pA00000036itIIAQ";
QueryResult queryResult = null;
String soql = "SELECT ContentEntityId, SymbolTable FROM
ApexClassMember where ContentEntityId = '" + classId + "'";
queryResult = sforce.query(soql);
if (queryResult.size > 0)
{
ApexClassMember apexClass =
(ApexClassMember)queryResult.records[0];
SymbolTable symbolTable = apexClass.SymbolTable;
foreach (Method _method in symbolTable.methods)
{
//here's the SayHello method
String _methodName = _method.name;
//report the modifiers on the method such as global, public,
private, or static
String _methodVisibility = _method.modifiers;
//get the method's return type
string _methodReturnType = _method.returnType;
//get the fName & lName parameters
foreach (Parameter _parameter in _method.parameters)
{
string _paramName = _parameter.name;
string _parmType = _parameter.type;
}
}
}
else
{
//unable to locate class
}
```

코드에 디버깅용 checkpoint를 추가하려면 ApexExecutionOverlayAction을 사용한다. 다음 샘플은 이전 샘플의 클래스에 checkpoint를 추가한다.
```csharp
//use the ID of the class from the first sample.
string classId = "01pA00000036itIIAQ";
ApexExecutionOverlayAction action = new
ApexExecutionOverlayAction();
action.ExecutableEntityId = classId;
action.Line = 3;
action.LineSpecified = true;
action.Iteration = 1;
action.IterationSpecified = true;
ApexExecutionOverlayAction[] actions = { action };
SaveResult[] actionResults = sforce.create(actions);
if (actionResults[0].success)
{
// checkpoint created successfully
}
else
{
Console.WriteLine("Error: could not create Checkpoint ");
Console.WriteLine("
The error reported was: " +
actionResults[0].errors[0].message + "\n");
}
```

> 위 C# 예제들은 SOAP **호출 표면**(create/query 등)을 보여준다. `MetadataContainer`·`ApexClassMember`·`ContainerAsyncRequest`의 필드·컨테이너 배포 워크플로우 상세는 [[Tooling API 배포]], `ApexExecutionOverlayAction` 등 디버그/체크포인트 sObject는 [[Tooling API 디버그·로그·리플레이 sObject]] 참조.

---

## 관련 노트

- [[Tooling API 배포]] — MetadataContainer·ContainerAsyncRequest·*Member 컨테이너 배포 패밀리 (이 노트의 위임 대상)
- [[Tooling API 디버그·로그·리플레이 sObject]] — TraceFlag·ApexLog·ApexExecutionOverlayAction/Result·HeapDump 디버그/로그 패밀리 (이 노트의 위임 대상)
- [[Apex 배포 방법]] — 배포 경로(Metadata API·Tooling API·DX) 비교 허브
- [[Metadata API 개요]] — Metadata API 타입(declarative) 카탈로그 (Tooling sObject ≠ Metadata type 경계)
- [[Winter '27/Development]] — v68.0 릴리즈 맥락. Test Discovery API `testLevel` 신설·`showAllMethods` deprecated, 신규 REST 리소스 `symbols`·`apexCompileResults`의 릴리즈 노트 측 서술.
- [[Winter '27/Release Updates]] — API 버전 은퇴 Release Update의 강제 시점·Test Run 절차 (EOL 표의 21.0–30.0 대역 대조처)
