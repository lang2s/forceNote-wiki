---
tags: [release, summer_26, development, apex, lwc, api]
api_version: v67.0
release_date: 2026-06
created: 2026-06-15
source: salesforce_release_notes_5-17-2026.pdf (Salesforce Summer '26 Release Notes, Tier 2)
aliases: [Summer '26 Development, 서머26 개발, v67 파괴적 변경, Breaking Changes v67, USER_MODE 기본화, WITH SECURITY_ENFORCED 폐기, with sharing 기본, secure by default, String.template, State Managers]
---

# Summer '26 — Development (Apex · LWC · API)

> v67.0 개발자 항목 전수. 파괴적 변경 3건(① DB 작업 기본 USER_MODE, ② 공유 미선언 클래스 `with sharing` 기본, ③ `WITH SECURITY_ENFORCED` 제거)을 비롯해 Apex 신규·New/Changed 클래스·LWC·API·거버너 한도까지 포함.

---

## 개요

이 노트는 [[Summer '26]] 릴리즈의 **개발자(Apex·LWC·API)** 영역을 다룬다. v67.0의 핵심은 "secure by default" 보안 패러다임으로의 전환이다.

- **① SOQL/DML/Database가 기본 USER_MODE** — 시스템 모드가 필요하면 명시.
- **② 공유 미선언 Apex 클래스가 `with sharing` 기본값** — 우회는 명시적 `without sharing` 필요.
- **③ `WITH SECURITY_ENFORCED` 제거** — v67.0+ 클래스에서 컴파일 오류, `WITH USER_MODE`로 교체.

상위 허브: [[Summer '26]] · 강제 적용 항목: [[Summer '26/Release Updates]] · 플랫폼/보안: [[Summer '26/Platform]]

---

## 파괴적 변경 (Breaking Changes) — v67.0

### ① Database Operations Run in User Mode by Default, Not System Mode

Apex 데이터베이스 작업(SOSL·SOQL 쿼리, DML 문, Database 메서드)이 v67.0+에서 **기본 user mode**로 실행된다. user mode에서는 현재 사용자의 공유 룰·필드 수준 보안(FLS)·객체 권한이 적용된다. 이전 버전에서는 기본 system mode였고, 사용자가 권한과 무관하게 모든 데이터에 접근할 수 있었다.

> 적용 범위: API v67.0 이상의 버전 변경(versioned change). Enterprise·Performance·Unlimited·Developer 에디션.

접근 모드를 명시하는 권장 방법은 다음과 같다.

```apex
// PDF 원문 발췌 — salesforce_release_notes_5-17-2026.pdf
// SOSL/SOQL 쿼리: WITH USER_MODE 또는 WITH SYSTEM_MODE
Account acc = [SELECT Id FROM Account WHERE Name = 'Singha' WITH USER_MODE LIMIT 1];
```

> Note: `WITH SECURITY_ENFORCED` 절은 API v67.0부터 제거됨. 대신 `WITH USER_MODE`를 사용한다.

```apex
// PDF 원문 발췌 — salesforce_release_notes_5-17-2026.pdf
// DML 작업: as user 또는 as system 키워드
Account a = [SELECT Id, Name
             FROM Account
             WHERE Support__c = 'Premier'
             WITH USER_MODE];
a.Rating = 'Hot';
update as user a;
```

```apex
// PDF 원문 발췌 — salesforce_release_notes_5-17-2026.pdf
// Database 또는 Search 메서드: accessLevel 파라미터
Account a = Database.query('SELECT Id, Name
             FROM Account
             WHERE Rating = \'Hot\'', AccessLevel.USER_MODE);
```

> Note: 작업을 user mode로 설정하면 호출 클래스의 sharing 선언을 무시하고 사용자의 공유 룰을 따른다. system mode로 설정하면 호출 클래스의 sharing 선언이 사용자의 레코드 수준 권한 준수 여부를 결정한다.

### ② Apex Classes Enforce Sharing Rules by Default

명시적 sharing 선언이 없는 Apex 클래스가 v67.0+에서 **`with sharing` 모드 기본값**이 된다(조직 전체 공유 설정 + 커스텀 공유 룰 적용). 이전 버전에서는 일부 예외를 제외하고 `without sharing` 모드가 기본이었다.

sharing 선언이 없는 클래스의 모드를 결정하는 요소:

- v67.0+로 컴파일하면 → 생략 시 `with sharing` 기본. 다른 클래스를 상속하면 부모의 sharing 모드를 따른다.
- v66.0 이하로 컴파일하면 → 생략 시 `without sharing` 기본. 단 다음 예외:
  - 상속 체인의 어느 클래스라도 v67.0+로 저장되었으면 → 생략 시 `with sharing`.
  - Aura 컨트롤러이거나 Lightning web component에서 호출된 `@AuraEnabled` 메서드이면 → 생략 시 `with sharing`.
  - Apex 진입점이 아니면 → 호출 클래스의 sharing 모드를 따른다.

> 적용 범위: API v67.0 이상의 버전 변경. Enterprise·Performance·Unlimited·Developer 에디션.

### ③ The WITH SECURITY_ENFORCED SOQL Clause is Removed

SOQL/SOSL 쿼리를 user mode로 실행하려면 `WITH SECURITY_ENFORCED` 대신 `WITH USER_MODE` 절을 쓴다. v67.0+로 설정된 Apex 클래스가 `WITH SECURITY_ENFORCED`를 포함하면 **컴파일되지 않는다**.

`WITH USER_MODE`가 `WITH SECURITY_ENFORCED`를 대체하는 이유(추가 이점):

- `WITH USER_MODE`는 다형성 필드(예: `Owner`, `Task.whatId`)를 처리한다.
- `WITH USER_MODE`는 `WHERE` 절을 포함한 SOQL SELECT 문의 모든 절을 검사한다.
- `WITH USER_MODE`는 SOQL 쿼리의 모든 FLS 오류를 찾는다(`WITH SECURITY_ENFORCED`는 첫 번째 오류만 찾음). 또한 user mode에서는 `QueryException`의 **`getInaccessibleFields()`** 메서드로 전체 접근 오류 집합을 검사할 수 있다.

```apex
// PDF 원문 발췌 — salesforce_release_notes_5-17-2026.pdf
// v67.0+: WITH SECURITY_ENFORCED를 WITH USER_MODE로 교체
Account acc = [SELECT Id FROM Account WHERE Name = 'Singha' WITH USER_MODE LIMIT 1];
```

### ④ Apex Triggers Always Run in System Mode

Apex 트리거는 이제 **항상 system mode**로 실행되어 현재 사용자의 공유 룰·FLS·객체 권한을 우회한다. 이전에는 일부 엣지 케이스에서 중첩 트리거가 공유 룰을 적용했다. 트리거에 명시적 sharing이나 접근 모드를 선언할 수 없다. 데이터 접근 설정을 적용하려면 비즈니스 로직을 별도 트리거 핸들러로 위임해 거기서 sharing·접근 모드를 정의한다.

> 적용 범위: **모든 API 버전**(all API versions). Enterprise·Performance·Unlimited·Developer 에디션.

---

## Apex 신규

### 멀티라인 문자열 + String.template()

반복 문자열 연결 없이 여러 줄에 걸친 Apex 문자열을 선언할 수 있다. 일반/멀티라인 문자열에 값을 보간하려면 기존 `String.format()`(static) 대신 새 **`String.template()`** 인스턴스 메서드를 쓴다.

> 적용 범위: **모든 API 버전**. Lightning Experience·Salesforce Classic, Enterprise·Performance·Unlimited·Developer 에디션.

`String.format()`이 인덱스 기반 플레이스홀더에 의존하는 반면, `String.template()`은 `${variableName}` 구문의 **명명 변수 플레이스홀더**를 사용한다.

멀티라인 문자열은 텍스트 블록을 작은따옴표 세 개(`'''`)로 감싼다. 여는 따옴표 다음 줄에서 본문을 시작하고, 닫는 따옴표는 본문 바로 뒤나 새 줄에 둔다.

```apex
// PDF 원문 발췌 — salesforce_release_notes_5-17-2026.pdf
// 원문 오타(닫는 따옴표 누락) — PDF 원문 보존: "sportName 의 닫는 따옴표가 PDF에서 누락됨
String newCustomerJson = '''
{
"Name" : "John Doe",
"Type" : "New Customer",
"Interests":
[
{"id": "101", "sportName: "biking"},
{"id": "102", "sportName: "running"},
{"id": "103", "sportName: "football"}
]
}''';
```

문자열 보간은 `${variableName}` 형식의 명명 변수로 문자열을 선언한 뒤 `String.template(Map<String, Object> valueMap)`을 호출한다. 맵의 키는 문자열에 정의된 변수, 값은 대응 치환값이다.

```apex
// PDF 원문 발췌 — salesforce_release_notes_5-17-2026.pdf
String formatted = '''
{
"Account": "${accountName}",
"Last Updated": "${date}"
}'''.template(new Map<String, Object> {
'accountName' => 'My Account',
'date' => DateTime.newInstance(2018, 11, 15)
});
Assert.areEqual('''
{
"Account": "My Account",
"Last Updated": "2018-11-15 08:00:00"
}''', formatted);
```

### Elastic Limits for Async Jobs (Beta)

조직이 일일 비동기 작업 한도를 초과할 때 갑작스러운 실행 실패와 limit 예외를 방지한다. Queueable·future 메서드 작업을 새 **elastic limit**(조직 라이선스 일일 한도의 **2배**)까지 큐잉할 수 있다. 라이선스 일일 한도를 초과한 비동기 작업은 **스로틀링된 속도**로 처리된다.

> 적용 범위: "Use elastic limits for asynchronous Apex jobs (Beta)" 설정이 활성화된 **demo·production 조직에서만**. `DailyAsyncApexElasticExecutions`와 `DailyAsyncApexProcessed` OrgLimit 인스턴스는 **API v67.0 이상**에서 사용 가능. Enterprise·Performance·Unlimited·Developer 에디션.

> [!note] Beta — Elastic Limits for Queueable Apex and Future Methods는 Beta Services Terms의 적용을 받는 pilot/beta 서비스다.

설정: Setup → Apex Settings → "Use elastic limits for asynchronous Apex jobs (Beta)" 켜기. Apex Jobs 페이지 배너에서 지난 24시간 처리량과 일일·elastic 한도, 스로틀링 여부를 확인한다. 코드에서는 `System.OrgLimits.getMap()`으로 `DailyAsyncApexExecutions`, `DailyAsyncApexElasticExecutions`, `DailyAsyncApexProcessed` OrgLimit 인스턴스에 접근해 사용량을 확인할 수 있다.

관련: [[Queueable]]

### InvocableActionExtension 메타데이터 향상 (Flow Builder)

`InvocableActionExtension` 메타데이터 향상으로 Flow Builder에서 Apex 액션 구성 경험을 개선하고 입력 오류를 줄인다. 지정 입력 파라미터에 대해 **피클리스트 값 정의·메타데이터 타입 할당·커스텀 프로퍼티 에디터 추가**가 가능하고, 표준 프로퍼티 에디터에 커스텀 헤더도 추가할 수 있다.

### EventBus.publishWithAccessLevel()

`EventBus` 클래스에 기존 `publish()` 메서드를 모방하면서 **non-null `AccessLevel` 파라미터(필수)**를 받는 새 `publishWithAccessLevel()` 메서드 집합이 추가됐다. 이 메서드들은 Apex 코드가 필요로 하는 접근 유형을 더 명확히 정의하므로 기존 `publish()` 메서드보다 권장된다.

> 적용 범위: Developer·Enterprise·Performance·Unlimited 에디션.

관련: [[EventBus Namespace]]

### no-arg 생성자 필수 (Invocable Action 파라미터 클래스)

Invocable action 파라미터로 사용되는 Apex 클래스는 **가시적인(visible) no-argument 생성자**를 가져야 한다. 생성자는 비패키지 클래스에서는 `public`, 패키지 외부에서 호출되는 패키지 클래스에서는 `global`이어야 한다. 이전 동작을 유지하려면 release update를 비활성화한 채 API v65.0 이하를 쓴다.

> 적용 범위: API v66.0 이상. 이 변경은 더 이상 강제되지 않는 "Enforcing No-Argument Constructor" release update로 처음 도입됐으며, 해당 release update를 켜지 않았다면 이 버전 변경이 요구사항을 구현한다.

클래스에 명시적 생성자가 없으면 Apex가 클래스와 동일한 접근 수준의 암묵적 no-argument 생성자를 제공한다.

```apex
// PDF 원문 발췌 — salesforce_release_notes_5-17-2026.pdf
public class MyInvocableClass {
@InvocableVariable(required=true)
public String accountName;
@InvocableVariable
public Integer priority;
// No explicit constructor - Apex provides an implicit public no-argument
constructor
}
```

파라미터가 있는 생성자를 추가하면 Apex가 암묵적 no-argument 생성자를 더 이상 제공하지 않으므로, 적절한 가시성의 no-argument 생성자를 직접 추가해야 한다.

```apex
// PDF 원문 발췌 — salesforce_release_notes_5-17-2026.pdf
public class MyInvocableClass {
@InvocableVariable(required=true)
public String accountName;
@InvocableVariable
public Integer priority;
// Constructor with parameters
public MyInvocableClass(String accountName, Integer priority) {
this.accountName = accountName;
this.priority = priority;
}
// Explicit no-argument constructor now required
public MyInvocableClass() {
}
}
```

> 참고: API v66.0+에서 REST API 호출도 invocable action 파라미터 클래스가 가시적 no-argument 생성자를 갖는지 검증한다(Enforcing No-Argument Constructor release update를 켜지 않은 경우). 생성자가 가시적이지 않으면 API 호출이 실패한다.

### Web Console (Beta) / Apex Metrics in Setup (Beta)

- **Work with Apex Code in Web Console (Beta)** — Salesforce에 직접 임베드된 클라이언트 사이드 IDE인 Web Console에서 Apex를 빌드·디버그·배포한다. SOQL 쿼리 작성, trace flag/debug log 레벨 구성, 익명 Apex 실행이 가능하다. Setup의 Apex Classes·Apex Triggers·Apex Jobs 페이지에서 Apex 항목 접근 시 자동으로 열린다. 모든 조직에서 무료로 제공. (When: Spring '26 이후 2026년 4월 14일부터)
- **Get Key Apex Metrics in Setup with Agentforce (Beta)** — 업데이트된 Org Health and Usage 대시보드가 Agent for Setup에 Apex 메트릭을 제공한다. 오래된 API 버전의 Apex 클래스, Apex 컴파일 오류, 현재 비동기 Apex 작업 사용량을 보여준다.

### Blob.toPdf() Visualforce PDF 렌더링 (Release Update)

`Use Visualforce PDF Rendering Service with Apex Blob.toPdf()` — 이 update를 켜면 Apex `Blob.toPdf()` 메서드가 Visualforce와 동일한 렌더링 서비스를 사용한다(추가 폰트·멀티바이트 문자 지원 등 개선). → 상세·시점: [[Summer '26/Release Updates]]

---

## New & Changed 개발자 항목 (Apex 클래스)

> 출처: PDF "Apex: New and Changed Items" 섹션 전수. 각 클래스의 메서드를 빠짐없이 옮긴다.

### DocumentAI Namespace — 신규 클래스

| 용도 | 클래스 |
|---|---|
| Document AI 처리 중 발생한 오류·부가 컨텍스트 표현 | `Error`, `ExtractionMetadata` |
| 추출 데이터 처리를 위한 중복 탐지 규칙·객체별 엔티티 설정 구성 | `DuplicateRuleConfiguration`, `DuplicateObjectConfiguration`, `ObjectConfig` |
| Document AI post-transform 프로세스의 입력·출력 페이로드 관리 | `PostTransformInput`, `PostTransformResult` |
| 문서에서 추출한 구조 노드·필드 수준 속성·매칭 레코드 처리 | `Node`, `Attribute`, `MatchingRecord` |
| Document AI post-save 워크플로의 입력 처리·결과 캡처 | `PostSaveInput`, `PostSaveResult`, `SavedRecordDetail` |
| Document AI 처리용 배치 작업 스케줄 | `BatchProcessor` |

### hlthcrbilling Namespace — 신규 클래스

Salesforce Health Cloud의 제품 빌링 정보 캡처용.

- `ProductBillingDetails` — 주문된 제품의 빌링 상세(account·work type·shipping address 포함) 관리.
- `ProductDetails` — 개별 제품 라인 아이템 표현(price book entry·수량·가격 속성 포함).

### Invocable Namespace — 신규/변경

#### 신규 클래스 (각 메서드 전수)

| 클래스 | 용도 | 메서드 |
|---|---|---|
| `Action.DescribeResult` | invocable action 메타데이터 조회 | `getCategory()`, `getDescription()`, `getInputs()`, `getOutputs()`, `getTargetEntityName()` |
| `Action.InputParameter` | invocable action이 쓰는 입력 파라미터 메타데이터 조회 | `getAdditionalAttributes()`, `getApexClass()`, `getName()`, `getPicklistValues()`, `getType()` |
| `Action.OutputParameter` | invocable action이 반환하는 출력 파라미터 메타데이터 조회 | `getCategory()`, `getDescription()`, `getInputs()`, `getOutputs()`, `getTargetEntityName()` |
| `Action.GenericType` | invocable action에 쓰일 수 있는 제네릭 타입 파라미터 메타데이터 조회 | `getDescription()`, `getLabel()`, `getName()`, `getSuperType()` |
| `Action.AdditionalAttribute` | invocable action 관련 추가 속성 메타데이터 조회 | `getApexClass()`, `getDataType()`, `getIsCollection()`, `getName()`, `getValue()` |
| `Action.PicklistValue` | invocable action 파라미터가 쓰는 피클리스트 값 메타데이터 조회 | `getActive()`, `getDefaultValue()`, `getLabel()`, `getValidFor()`, `getValue()` |

> PDF 원문은 `Action.InputParameter`의 `getPicklistValues(` 닫는 괄호가 누락(`getPicklistValues(`)되어 있고 `InputParameterclass`로 공백도 누락되어 있다. 위 표는 컴파일/가독성을 위해 `getPicklistValues()`로 정정함.

#### 기존 클래스의 신규/변경 메서드

- `Action` 클래스에 신규 `getDescribe()` 메서드 — invocable action 메타데이터 반환.
- `Action` 클래스에 신규 `getVersion()` 메서드 — invocable action 버전 조회. API v66.0에서 도입됐고 Apex Reference Guide에 추가됨.

### System Namespace — 신규/변경

- **신규 클래스** `IntegrationTest` — Agentforce·Data 360 서비스와의 통합 테스트 실행용. (상세 코드 → [[Summer '26/Agentforce]])
- **기존 `String` 클래스의 신규 메서드** `template()` — 단일/멀티라인 문자열 보간 개선 (위 "Apex 신규" 참조).

---

## LWC 신규 / 변경

### 신규 / GA

- **State Managers for LWC (GA)** — 앱 내에서 데이터와 관련 로직을 더 효과적으로 그룹·관리한다. Beta 이후 일부 변경 포함. 빌트인 state manager 목록은 Summer '26에서 변경됐고, `lightning/stateManager*` 모듈로 제공된다. 문서는 Beta 대비 확장되어 추가 코드 예제 포함.
  > Note: **State managers는 Experience Cloud에서 사용 불가.** (Lightning Experience 전 에디션 적용)
- **Single Component Live Preview (GA)** — 이전 명칭 "Local Dev for single components". 조직에서 Lightning web component를 실시간 미리보기. (2026년 4월 13일 주부터 GA) Salesforce CLI가 Live Preview 플러그인을 자동 설치한다.
- **Live Preview VS Code Extension (GA)** — 이전 명칭 "Lightning Preview". VS Code/Code Builder에서 Lightning web component를 미리보기. (Lightning web component용 GA — 2026년 4월 13일 주부터)
- **`<details>` 요소 `name` 속성 그룹화** — `<details>` 요소에 `name` 속성을 추가해 그룹을 만들고 한 번에 하나의 요소만 열리게 유지할 수 있다(아코디언). 이전에는 이 속성 사용 시 컴파일러 경고가 발생했다. 그룹화하려는 각 `<details>` 요소에 같은 `name` 값을 할당한다.

### 변경

- **Hot Module Reloading 성능 개선** — LWC API v67.0에서 더 빠른 코드 실행과 메모리 관리를 위해 hot module reloading 성능이 향상됐다.
- **LWS — HTMLAnchorElement `data:` URI 차단** — `HTMLAnchorElement.prototype.href`의 새 distortion이 `data:` URI 스킴을 사용하는 URL을 차단한다. `data:` URI는 콘텐츠를 URL로 인라인 임베드해 LWS가 막는 보안 위험을 만든다. (Lightning Experience, LWR 기반 Experience Cloud 사이트, LWS 활성화된 Aura 사이트의 LWC에 적용)

```javascript
// PDF 원문 발췌 — salesforce_release_notes_5-17-2026.pdf
// EXAMPLE OF INSECURE DOWNLOAD LINK
// This technique is prevented by LWS
const textEncoded = `data:text/plain,${encodeURIComponent(
'text string'
)}`;
let anchorTag = document.createElement('a');
anchorTag.setAttribute('href', textEncoded);
anchorTag.setAttribute('download', 'nameoffile.crt');
anchorTag.click();
```

대신 `Blob`을 만들고 `blob:` URI 스킴으로 다운로드를 제공한다.

```javascript
// PDF 원문 발췌 — salesforce_release_notes_5-17-2026.pdf
const blob = new Blob(['text string'], { type: 'text/plain' });
const blobUrl = URL.createObjectURL(blob);
const anchorTag = document.createElement('a');
anchorTag.setAttribute('href', blobUrl);
anchorTag.setAttribute('download', 'nameoffile.crt');
anchorTag.click();
URL.revokeObjectURL(blobUrl);
```

### 신규 Lightning Web Components (API v67.0+ 필요)

| 컴포넌트 | 상태 | 설명 |
|---|---|---|
| `lightning-dynamic-list-container` | Developer Preview | 데이터 목록을 로드하고 스크롤 위치에 따라 데이터 관리. (Load Large Lists Dynamically) |
| `lightning-dynamic-list-item` | Developer Preview | 동적 목록의 개별 행 표현. 각 항목은 컨테이너가 동적으로 배치. |

### 변경된 Lightning Web Components (전수)

| 컴포넌트 | 변경 내용 |
|---|---|
| `lightning-carousel-image` | RTL 언어에서 현재 선택된 carousel 이미지가 보이도록 수정. |
| `lightning-click-to-dial` | RTL 언어에서 전화 아이콘이 전화번호 오른쪽에 표시. |
| `lightning-combobox` | `variant` 속성에 새 값 **`button`** 지원 — SLDS 아이콘을 지원하는 알약 모양 combobox. 각 옵션의 `iconName` 프로퍼티로 SLDS 아이콘명 지정. 옵션 선택 시 아이콘과 옵션 레이블이 버튼에 표시. |
| `lightning-dual-listbox` | 신규 접근성 동작: 왼쪽 미선택 시 이동 버튼 비활성화 / 오른쪽 항목 없으면 재정렬 버튼 비활성화 / 필수 옵션이 키보드 포커스 수신 가능(스크린 리더 안내) / zoom > 200%일 때 list box가 좌우 화살표 버튼 대신 상하 화살표 아이콘으로 분리되어 수직 스택 / 100% 줌에서 폭 약 683px에 도달하면 수평→수직 스택으로 reflow. |
| `lightning-datatable` | 신규 접근성 동작 추가. |
| `lightning-file-upload` | 최대 파일 크기 한도 **2 GB → 10 GB**로 증가. |
| `lightning-formatted-location` | RTL 언어에서 마이너스(-) 부호가 있는 위경도 값의 마이너스 부호가 왼쪽에 표시. |
| `lightning-formatted-number` | 총 15~16자리를 초과하는 큰 숫자도 올바르게 포맷 가능. |
| `lightning-input` | `checkbox` 타입에 신규 `indeterminate` 속성 — 존재 시 체크박스가 미정 상태(체크/빈 박스 대신 대시 표시). "전체 선택" 체크박스에 흔히 사용. 클릭하면 미정 상태 해제. 타입별 변경: `datetime`(read-only 시 time 필드 테두리 없이 아이콘 회색) / `checkbox-button`(RTL 지원) / `color`(color picker의 range indicator가 anchor link→button) / `time`(read-only 시 time 필드 테두리 없이 아이콘 회색). |
| `lightning-input-field` | time 필드 — read-only 시 테두리 없이 아이콘 회색. |
| `lightning-input-name` | read-only 시 salutation 필드가 테두리 없이 아이콘 회색. |
| `lightning-slider` | `max` 속성 값 지정 시 상호작용 중 이 값을 넘어 슬라이드 불가. |
| `lightning-tabset` | RTL 언어에서 왼쪽 화살표 키가 왼쪽 탭으로(첫 탭 포커스 시 마지막 탭으로) 이동. |
| `lightning-textarea` | `disabled`와 `read-only`를 함께 지정하면 `disabled`만 지정한 것과 동일한 스타일. |
| `lightning-tree-grid` | RTL 언어에서 chevron 아이콘이 예상대로 아래를 향함. |

> Aura 컴포넌트(`lightning:carouselImage` 등)에도 동일한 변경이 대응 적용된다(PDF "Changed Aura Components" 참조).

### New Modules / Changed Modules

**New Modules**

- `lightning/accApi` — Lightning Experience 내 네이티브 Agentforce 사이드 패널 상태 관리. (Agentforce Conversation Client API Developer Guide)
- `experience/blockBuilderApi` — Salesforce CMS Extension LWC가 Marketing Cloud Next 콘텐츠의 업데이트 컴포넌트를 가져오게 함. API v66.0에서 도입, 이번에 LWC Developer Guide에 추가.

**Changed Modules**

- `lightning/analyticsWaveApi` — 신규 wire adapter `getReplicatedFieldsWithAdvancedProps` — 고급 프로퍼티를 포함한 CRM Analytics replicated dataset의 필드 컬렉션을 검색.

---

## New & Changed API

### ConnectApi (Connect in Apex)

#### Rate Limit 변경

per user/per namespace/per hour ConnectApi rate limit의 제약을 피하기 위해, 조직이 per org/per 24-hour Salesforce Platform API rate limit로 마이그레이션됐다. Chatter가 필요한 메서드 호출만 per user/per namespace/per hour rate limit 대상.

#### 신규 Connect in Apex 클래스 — Commerce

`ConnectApi.CommerceCart` 클래스의 신규 메서드:

| 용도 | 메서드 | 신규 입력 클래스 | 신규 출력 클래스 |
|---|---|---|---|
| 승인된 quote에서 cart 생성 또는 draft quote 복제 | `createCartFromQuote(webstoreId, quoteId, cartFromQuoteInput)` | `ConnectApi.CartFromQuoteInput` | `ConnectApi.CartFromQuoteOutput` |
| 활성 cart에서 quote 생성 | `createQuoteFromCart(webstoreId, activeCartOrId, createQuoteFromCartInput)` | `ConnectApi.CreateQuoteFromCartInput` | `ConnectApi.CreateQuoteFromCartOutput` |

`ConnectApi.CommerceQuotes` 클래스의 신규 메서드:

| 용도 | 메서드 | 신규 입력 클래스 | 신규 출력 클래스 |
|---|---|---|---|
| 제품에서 quote 생성 | `createQuoteFromProduct(webstoreId, productId, createQuoteFromProductInput)` | `ConnectApi.CreateQuoteFromProductInput` | `ConnectApi.CreateQuoteFromProductOutput` |
| quote 재협상 시작 또는 quote 거절 | `updateQuote(webstoreId, quoteId, updateQuoteInput)` | `ConnectApi.updateQuoteInput` | `ConnectApi.UpdateQuoteOutput` |
| 사용자 account의 quote 상세 조회 | `getQuoteDetail(webstoreId, quoteId, effectiveAccountId, fields)` | — | `ConnectApi.CommerceQuoteDetail` |
| account의 모든 quote 조회 | `getQuotes(webstoreId, effectiveAccountId, fields, sortParam, pageSize, pageToken, earliestDate, latestDate)` | — | `ConnectApi.CommerceQuoteCollection` |

#### 변경된 Connect in Apex 출력 클래스 — Organization

- `ConnectApi.MaintenanceInfo` — `maintenanceType` 프로퍼티가 이제 **`ServiceAgreement`** maintenance type을 지원.

#### 변경된 Connect in Apex Enum

- `ConnectApi.MaintenanceType` — 신규 값 **`ServiceAgreement`** 추가.

### REST / Metadata / Tooling

#### Reports and Dashboards REST API — Analytics Download

Analytics 자산 다운로드 시 사용할 신규 파라미터 4개:

| 파라미터 | 설명 |
|---|---|
| `includeData` | 다운로드에 데이터 포함 여부 (`true`/`false`). |
| `pageId` | 다운로드할 Lightning 대시보드의 page ID. |
| `pageSize` | 다운로드의 페이지 크기. 유효 값: `A3`, `A4`, `LEGAL`, `LETTER`. |
| `savedViewId` | 다운로드할 Lightning 대시보드의 saved view ID. |

#### SOAP API

- `login()` — API v65.0 이상에서 사용 불가. v65.0 이상에서 HTTP 상태 코드 500과 예외 코드 `UNSUPPORTED_API_VERSION`을 반환.

#### Tooling API New & Changed Objects

- **Customization (BEHAVIOR CHANGE)**: 기존 `Group` 객체의 `DoesIncludeBosses` 필드가 큐에 사용 가능. 큐 사용자와 공유된 레코드가 역할 계층 상위 사용자에게도 공유되는지 표시.
- **Development**: 기존 `SandboxInfo` 객체에 `IsNonPreview` 필드 — 한 메이저 릴리즈에서 다른 릴리즈로 전환하는 동안 non-preview sandbox 생성. 기존 `ApexTestResult` 객체에 `TestCategory`·`TestName`·`TestNamespace` 필드 — test category·test class·namespace별 테스트 결과 쿼리(API v65.0 도입, Tooling API Reference에 추가).

#### User Interface API

- 신규 표준 객체는 모두 User Interface API용으로 자동 활성화(All new standard objects are auto-enabled). `event`·`task`가 UI API supported objects 목록에 추가됨.

### GraphQL — mutation field reference 개선

단일 요청에서 field reference로 여러 mutation 작업을 체이닝할 수 있다. `ref`가 같은 요청의 이전 mutation 작업 이름/별칭일 때 두 가지 새 패턴이 지원된다.

| Reference | 설명 |
|---|---|
| `@{ref.Record.Id}` | 명시적 레코드 ID 참조. |
| `@{ref.Record.FieldName.value}` | GraphQL 필드 참조. 예: 쿼리의 `Name { value }`는 `@{ref.Record.Name.value}`. |

> 이전에는 `@{ref}`만 지원됐다.

다음 예제는 account·contact·opportunity 생성을 한 요청에서 체이닝하며 지원되는 모든 field reference 패턴을 사용한다.

```graphql
// PDF 원문 발췌 — salesforce_release_notes_5-17-2026.pdf
mutation CreateAccountAndContact {
uiapi(input: { allOrNone: false }) {
AccountCreate(input: {
Account: {
Name: "Mutation Fun"
}
}) {
Record {
Id              # referenced in 'OpportunityCreate'
Name { value }  # referenced in 'ContactCreate'
}
}
ContactCreate(input: {
Contact: {
MailingCity: "Paris"
LastName: "@{AccountCreate.Record.Name.value}"
AccountId: "@{AccountCreate}"  # equivalent to AccountCreate.Record.Id
}
}) {
Record {
Id
LastName { value }     # referenced in 'OpportunityCreate'
MailingCity { value }  # referenced in 'OpportunityCreate'
}
}
OpportunityCreate(input: {
Opportunity: {
Name: "@{ContactCreate.Record.LastName.value}"          # 'ContactCreate' reference
Description: "@{ContactCreate.Record.MailingCity.value}" # 'ContactCreate' reference
AccountId: "@{AccountCreate.Record.Id}"                  # 'AccountCreate' reference
StageName: "Value Proposition"
CloseDate: "2026-12-31"
}
}) {
Record {
Id
AccountId { value }
Name { value }
Description { value }
}
}
}
}
```

응답:

```json
// PDF 원문 발췌 — salesforce_release_notes_5-17-2026.pdf
{
"data": {
"uiapi": {
"AccountCreate": {
"Record": {
"Id": "001LT000011naPRYAY",
"Name": {
"value": "Mutation Fun"
}
}
},
"ContactCreate": {
"Record": {
"Id": "003LT00000ArlizYAB",
"LastName": {
"value": "Mutation Fun"
},
"MailingCity": {
"value": "Paris"
}
}
},
"OpportunityCreate": {
"Record": {
"Id": "006LT000005R4HZYA0",
"AccountId": {
"value": "001LT000011naPRYAY"
},
"Name": {
"value": "Mutation Fun"
},
"Description": {
"value": "Paris"
}
}
}
}
},
"errors": [],
"extensions": {}
}
```

> 쿼리 체이닝도 동일하게 field reference를 지원한다(`@{ref.FieldName}`, `@{ref.FieldName.value}`, `@{ref.edges[*].node.FieldName}` 등).

---

## 거버너 한도 변경

| 한도 항목 | 이전 | 이후 (Elastic, Beta) | OrgLimit 인스턴스 |
|---|---|---|---|
| Queueable/future 비동기 작업 일일 한도 | 라이선스 기준 일일 한도 | **2배(elastic limit)** — 초과분은 스로틀링 처리 | `DailyAsyncApexElasticExecutions`, `DailyAsyncApexProcessed` (API v67.0+), `DailyAsyncApexExecutions` |

> `System.OrgLimits.getMap()`으로 위 3개 OrgLimit 인스턴스에 접근해 사용량을 확인한다. (위 "Elastic Limits for Async Jobs (Beta)" 참조)

---

## 관련 노트

- [[Summer '26]] — 상위 허브
- [[Summer '26/Release Updates]] — 강제 적용 항목 (Blob.toPdf 등)
- [[Summer '26/Platform]] — Admin·Security·Flow·DevOps·Architecture
- [[WITH USER_MODE]] — v67.0 기본 USER_MODE / `WITH SECURITY_ENFORCED` 폐기
- [[SOQL 패턴]] · [[DML 패턴]]
- [[Safely]] · [[StripInaccessible]] — FLS·공유 패턴
- [[Queueable]] — Elastic Limits 대상
- [[EventBus Namespace]] — `publishWithAccessLevel()`
</content>
