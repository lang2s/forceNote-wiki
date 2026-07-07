---
tags: [Apex, version, behavior-change, api-version, reference, lookup-index]
source: salesforce_apex_developer_guide.pdf
created: 2026-06-19
aliases: [Apex Versioned Behavior Changes, 버전별 동작 변경, API version behavior, versioned behavior, API 버전 설정, Version Settings, 버전 업그레이드, Setting the Salesforce API Version]
---

# Apex 버전별 동작 변경 레퍼런스

> API 버전(`apiVersion`)에 따라 달라지는 Apex의 주요 동작 변경을 버전 내림차순으로 모은 version-gated lookup 인덱스. 개별 동작의 상세 메커니즘은 각 항목의 deep-link 노트 소관.

---

## 머리말 — 범위와 가이드라인

이 문서는 Apex Developer Guide v67.0 (Summer '26)의 부록 *"Apex Versioned Behavior Changes"*를 전수 정리한 것이다.

- **exhaustive 목록이 아니다.** 버전별 Apex 동작 변경을 모두 담지는 않는다. 예를 들어 **Connect in Apex와 `ConnectApi` 네임스페이스의 버전별 변경은 이 정리에서 제외**된다.
- 동작은 코드를 **저장(save)한 API 버전**(클래스/트리거의 `apiVersion`)에 따라 결정된다. 일부 항목은 메서드를 *호출하는* 클래스의 버전을 따른다(예: `SObject.getPopulatedFieldsAsMap()`).

### API 버전 사용 가이드라인 (공식 권장)

> PDF 원문:
> - *"Salesforce strongly recommends that you use the latest available API version."*
> - *"If you can't upgrade to the latest version yet, use API versions released in the past three years for improved performance, security, and compatibility."*
> - *"To reduce complexity, consolidate your Apex codebase to use the minimal number of API versions, ideally, just one API version."*

1. **최신 버전 사용을 강력 권장**.
2. 최신으로 못 올리면, **최근 3년 내 출시된 API 버전**을 쓴다(성능·보안·호환성).
3. 복잡도를 줄이기 위해 코드베이스를 **최소한의 API 버전(이상적으로는 단일 버전)으로 통합**한다.

> **Apex 클래스·메서드 자체의 가용성은 저장 버전에 무관.** 언어에 추가된 클래스/메서드는 도입된 릴리스와 상관없이 모든 API 버전의 Apex에서 쓸 수 있다(예: v33.0에서 추가된 메서드도 v25.0으로 저장된 클래스에서 호출 가능). **유일한 예외는 `ConnectApi` 네임스페이스** — 문서에 명시된 API 버전에서만 지원된다(v33.0에 도입되면 그 이전 버전에서는 사용 불가). 즉 이 레퍼런스가 다루는 "version-gated 동작"은 *같은 메서드의 런타임 동작 차이*이지, 메서드 존재 여부가 아니다.

---

## API 버전 설정·업그레이드 절차

위의 version-gated 동작은 **코드가 저장(save)된 Salesforce API 버전**으로 결정된다. 그 버전을 어디서·어떻게 정하고 바꾸는지가 이 절차층이다.

### 조직 기본 버전 vs 클래스별 버전

조직 전체를 지배하는 단일 "Apex 버전"은 없다. **버전은 클래스·트리거마다 개별로 저장**된다(각 `ApexClass`/`ApexTrigger` 메타데이터의 `apiVersion` 필드). 새 클래스/트리거를 만들면서 API 버전을 명시하지 않으면 **조직에 설치된 최신 버전으로 기본 연결**된다("If you save an Apex class or trigger without specifying the Salesforce API version, the class or trigger is associated with the latest installed version by default"). 마찬가지로 관리형 패키지를 참조하는데 패키지 버전을 명시하지 않으면 최신 설치 버전으로 기본 연결된다.

- 하위 호환을 위해 클래스·트리거는 특정 Salesforce API 버전의 version settings와 함께 저장된다("classes and triggers are stored with the version settings for a specific Salesforce API version"). Apex·API·패키지 컴포넌트가 이후 릴리스에서 진화해도, 그 클래스/트리거는 알려진 동작을 갖는 버전에 계속 바인딩된다.

### 클래스/트리거의 API 버전 설정 위치

| 경로 | 절차 (PDF 원문 절차 옮김) |
|---|---|
| **Setup — Apex Class** | Setup → Quick Find `Apex Classes` → **New** (또는 기존 클래스 Edit) → **Version Settings** 클릭 → **Version of the Salesforce API** 선택(이 버전이 곧 연결되는 Apex 버전) → **Save**. 조직에 관리형 패키지가 설치돼 있으면 각 패키지의 사용 버전도 함께 지정 가능(기본값 = 최신). |
| **Setup — Trigger** | 해당 오브젝트 관리 설정 → **Triggers** → New/Edit → **Version Settings** 클릭 → API·Apex 버전 선택 → Save. (Attachment·ContentDocument·Note 표준 오브젝트는 UI로 트리거 생성 불가 → Developer Console·VS Code 확장·Metadata API 사용) |
| **Developer Console** | 클래스/트리거 편집기의 우측 속성 패널에서 API Version 지정. |
| **Metadata (`apiVersion`)** | `.cls-meta.xml` / `.trigger-meta.xml`의 `<apiVersion>` 요소로 소스 컨트롤·배포 시 버전 고정(아래 예시 참조). |

**Version Settings 공식 절차(클래스/트리거 공통):**
1. 클래스 또는 트리거를 Edit하고 **Version Settings** 클릭.
2. **Version of the Salesforce API** 선택 — 이 버전이 클래스/트리거에 연결되는 Apex 버전이기도 하다.
3. **Save**.

```xml
<!-- MyClass.cls-meta.xml — apiVersion 요소가 곧 저장 버전(version-gated 동작 결정) -->
<?xml version="1.0" encoding="UTF-8"?>
<ApexClass xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>66.0</apiVersion>
    <status>Active</status>
</ApexClass>
```

### 버전 변경 방법과 그 영향

버전을 올리거나 내리는 것은 위 Version Settings에서 값을 바꿔 다시 Save/deploy하는 것이다. 바뀐 버전이 **version-gated 동작 전체를 재결정**한다 — 위 [버전별 동작 변경 전수표](#버전별-동작-변경-내림차순-전수)의 해당 임계 버전을 넘거나 밑돌면 동작이 달라진다(예: v67.0로 올리면 DB 작업이 user mode 기본으로, sharing이 현재 사용자 컨텍스트로 전환).

**클래스 간 버전 경계 — 호출된 클래스의 버전이 지배.** 클래스 C1이 객체를 파라미터로 C2에 넘기고 C2가 다른 API 버전으로 저장돼 노출 필드가 다르면, **그 객체의 필드는 C2의 version settings로 통제된다**("the fields in the objects are controlled by the version settings of C2"). PDF 예시: `Idea.Categories` 필드는 API v13.0에 없으므로, v16.0 테스트 클래스 C1이 v13.0 클래스 C2의 `insertIdea`를 호출하면 insert 후 Categories가 `null`이 된다.

### 관리형 패키지 컴포넌트 version settings (참조 버전 고정)

관리형 패키지를 참조하는 클래스/트리거는 **참조하는 패키지 버전을 개별로 고정**할 수 있다. 이렇게 하면 최신 버전에서 deprecated된 컴포넌트를 계속 참조하거나, 옛 shape에 의존하는 코드의 하위 호환을 유지할 수 있다.

- **기본값:** 클래스/트리거가 **마지막으로 저장·배포된 시점에 설치돼 있던 패키지 버전**과 연결된다. 이후 패키지를 상위 버전으로 업그레이드해도, 클래스를 재배포하지 않는 한 옛 버전에 계속 묶여 있다(재배포하면 그때 최신으로 갱신).
- **Setup 절차:** Setup → `Apex Classes` 또는 `Apex Triggers` → 대상의 **Edit** → **Version Settings 탭** → 관리형 패키지의 **Version 드롭다운**에서 원하는 버전 선택 → **Save**. 이후 더 최신 패키지를 설치해도 수동으로 바꾸기 전까지 이 버전을 계속 사용한다.
- **제거 불가:** 패키지를 참조 중이면 그 version setting을 제거할 수 없다. 참조 위치는 클래스/트리거 Detail 페이지의 **Show Dependencies**로 확인.
- **Metadata API:** 클래스/트리거 메타데이터에 `<packageVersions>` 요소로 지정 — `majorNumber`·`minorNumber` + **2GP는 `packageId`**, **1GP는 `namespace`**. (retrieve 시 API v62.0 이상은 `<packageId>`, v61.0 이하는 `<namespace>`로 표기.)
- **API 요청 헤더:** REST는 `x-sfdc-packageversion-[packageId/namespace]`, SOAP는 `PackageVersionHeader`. 헤더에 버전을 안 주면 Setup의 값(Setup → `API` → Configure Enterprise Package Version Settings)이 쓰인다.
- **Summer '25 이후:** 1GP에서 마이그레이션된 2GP 패키지도 subscriber가 version settings로 참조 버전을 지정할 수 있다(1GP는 종전부터 지원, 1GP 변환이 아닌 순수 2GP는 아직 미지원).

```xml
<!-- 구조 예시 — 관리형 패키지 참조 버전 고정 (PDF 발췌: 2GP는 packageId) -->
<?xml version="1.0" encoding="UTF-8"?>
<ApexClass xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>66.0</apiVersion>
    <packageVersions>
        <majorNumber>3</majorNumber>
        <minorNumber>0</minorNumber>
        <packageId>033xx0000000001</packageId>   <!-- 1GP면 <namespace>pkg1</namespace> -->
    </packageVersions>
    <status>Active</status>
</ApexClass>
```

---

## 버전별 동작 변경 (내림차순 전수)

각 버전 아래에 (a) 산문형 동작 변경 항목과 (b) PDF의 *"API Reference Changes"* 표(Namespace / Class / Behavior Change)를 둔다.

### Version 67.0

- **Database Operations in User Mode by Default** — API v67.0 이상에서 Apex는 기본적으로 **user context**로 실행된다. 즉 실행 시 현재 사용자의 권한과 FLS(field-level security)가 강제된다. v66.0 이하에서는 system mode가 기본. → `Set an Access Mode for Database Operations` 참조. (상세: [[Database Namespace 상세]])
- **Apex Classes Enforce Sharing by Default** — API v67.0 이상에서 명시적 sharing 선언이 없는 클래스는 **현재 사용자 컨텍스트**로 실행된다. v66.0 이하에서는 sharing 선언이 없으면 현재 sharing rule이 그대로 유지된다. → `with sharing / without sharing / inherited sharing` 키워드 참조.
- **WITH_SECURITY_ENFORCED Not Supported in SOQL Queries** — API v67.0 이상에서는 SOQL `SELECT` 쿼리에 **`WITH SECURITY_ENFORCED` 절을 사용할 수 없다.** 대신 user mode로 쿼리하려면 **`WITH USER_MODE`** 절을 쓴다. (cf. v45.0의 `WITH SECURITY_ENFORCED` 도입 항목)

### Version 65.0

- **Access Modifiers with Abstract and Override Methods** — API v65.0 이상에서 `abstract` 또는 `override` 메서드는 **`protected`, `public`, `global` 접근 한정자 중 하나가 필수**다. 명시하지 않으면 접근 수준이 `private`로 기본 설정되는데, 구현 클래스가 abstract 메서드에 접근할 수 없으므로 private은 유효하지 않다. 허용된 한정자 없이 abstract/override 메서드를 선언하면 컴파일 에러 발생: `Abstract methods require at least one of these modifiers: global, public, protected`. → `Extending a Class` 참조. (상세: [[Apex 언어 기초 — 제어 흐름과 클래스]])

### Version 63.0

- **DataWeave Version** — API v63.0 이상은 **DataWeave 2.9** 스크립트 구문을 지원. (v62.0은 DataWeave 2.8, v61.0 이하는 DataWeave 2.5.) (상세: [[DataWeave Namespace]])
- **JSON Serialization of Exceptions** — API v63.0 이상에서 커스텀 예외 및 대부분의 내장 예외에 대한 **JSON 직렬화는 지원되지 않는다.** 예외를 직렬화하려 하면 에러: `Type unsupported in JSON: MyException`. → `JSON Support` 참조.

### Version 62.0

- **DataWeave Version** — API v62.0은 **DataWeave 2.8** 스크립트 구문을 지원. v61.0 이하는 DataWeave 2.5. (상세: [[DataWeave Namespace]])

### Version 61.0

- **Private Method Override** — API v61.0 이상에서 private 메서드는 서브클래스의 동일 시그니처 인스턴스 메서드에 의해 **더 이상 오버라이드되지 않는다.** v60.0 이하에서는 서브클래스가 슈퍼클래스의 private 메서드와 동일 시그니처의 인스턴스 메서드를 선언하면 서브클래스 메서드가 private 메서드를 오버라이드했다. → `Interfaces` 참조.
- **DMO Information** — API v61.0 이상에서 `SObjectType.getDescribe()`로 특정 DMO 정보를 얻을 수 있다. DMO의 모든 필드는 field describe와 보안 모델 체크에서 read-only이므로 **FLS는 강제되지 않는다.** → `Data Cloud In Apex` 참조.

### Version 60.0

- **instanceof Operator with List and Iterable** — API v60.0 이상에서 `List` 데이터 타입이 `Iterable` 데이터 타입을 구현하면 **컴파일이 실패**한다. → `Using the instanceof Keyword` 참조. (상세: [[Apex 언어 기초 — 제어 흐름과 클래스]])
- **Transaction Control: Savepoints** — API v60.0 이상에서 모든 Apex 테스트 savepoint는 `Test.startTest()`와 `Test.stopTest()` 호출 시 해제된다. savepoint가 reset되면 `SAVEPOINT_RESET` 이벤트가 로깅된다. v59.0 이하에서는 savepoint 생성 후 callout을 하면, uncommitted DML 여부나 savepoint로의 rollback 여부와 무관하게 `CalloutException`이 발생했다. 또한 v60.0 이상에서 `Database.rollback(databaseSavepoint)`와 `Database.setSavepoint()` 호출은 **DML row usage limit를 증가시키지 않는다** (v59.0 이하에서는 증가시켰다). → `Transaction Control` 참조. (상세: [[Database Namespace 상세]])

**API Reference Changes**

| Namespace | Class | Behavior Change |
|---|---|---|
| `System` | `Database` | API v60.0 이상: `Database.rollback(databaseSavepoint)`와 `Database.setSavepoint()` 호출은 DML row usage limit를 증가시키지 않는다. v59.0 이하에서는 이 메서드들이 DML row usage limit를 증가시켰다. → `Database.rollBack()`. |
| `System` | `Test` | API v60.0 이상: Apex 테스트 savepoint는 `Test.startTest()`와 `Test.stopTest()` 호출 시 해제된다. savepoint가 reset되면 `SAVEPOINT_RESET` 이벤트가 로깅된다. v59.0 이하에서는 savepoint 생성 후 callout 시, uncommitted DML 여부나 savepoint rollback 여부와 무관하게 `CalloutException`이 발생했다. → `Database.rollBack()`. |
| `System` | `Type` | API v60.0 이상: 이 메서드 호출 시 invalid namespace를 사용하면 `null`을 반환한다. 이전에는 `Type.forName('InvalidNamespace', 'OuterClass.InnerClass')`처럼 invalid namespace를 지정하거나 outer class를 namespace로 쓰는 `Type.forName('OuterClass', 'InnerClass')`를 허용했고 결과가 불확정적이었다. → `Type.forName()`. |

### Version 57.0

**API Reference Changes**

| Namespace | Class | Behavior Change |
|---|---|---|
| `System` | `Object` | API v57.0 이상: `toString()` 메서드는 현재 namespace에서 보이는 Apex 객체의 멤버 변수만 포함한다. managed Apex 타입에서 `toString()`을 호출하면 non-global 프로퍼티는 출력에서 억제된다. 객체의 non-global 상태를 debug 출력에 계속 보이게 하려면 `toString()` 메서드를 명시적으로 오버라이드한다. → `Object.toString()`. |

### Version 55.0

- **@AuraEnabled Annotation** — API v55.0 이상에서 `@AuraEnabled`로 어노테이션된 메서드에는 **overload(오버로드)가 허용되지 않는다.** → `AuraEnabled Annotation` 참조.

### Version 54.0

**API Reference Changes**

| Namespace | Class | Behavior Change |
|---|---|---|
| `System` | `Date` | API v54.0 이상: `Date.valueOf`를 `Datetime` 객체와 함께 호출하면, 시간 정보 없이 유효한 `Date`로 변환한다. → `Date.valueOf()`. |
| `System` | `Id` | API v54.0 이상: invalid한 15자 또는 18자 ID를 변수에 할당하면 `System.StringException` 예외가 발생한다. → `Id.valueOf()`. |
| `Schema` | `DescribeSObjectResult` | API v54.0 이상: 커스텀 설정(custom settings)과 커스텀 메타데이터 타입 객체의 경우, 사용자가 쿼리된 객체에 접근 권한이 없으면 `DescribeSObjectResult.isAccessible()`이 `false`를 반환한다. v53.0 이하에서는 사용자가 필요한 권한이 없어도 `true`를 반환했다. → `DescribeSObjectResult.isAccessible()`. |
| `System` | `Messaging` | API v54.0 이상: `null`인 `emailMessageIds` 파라미터는 `System.IllegalArgumentException` 예외를 발생시킨다. v53.0 이하에서는 `null` `emailMessageIds` 파라미터가 에러를 발생시켰다. → `Messaging.sendEmailMessage()`. |

### Version 53.0

- **DataWeave Integration** — DataWeave integration 메서드에 접근하려면 Apex 클래스가 API v53.0 이상이어야 한다. → `Implementing DataWeave in Apex` 참조. (상세: [[DataWeave Namespace]])
- **JSON DateTime Format** — API v53.0 이상에서 DateTime 포맷과 처리가 업데이트되었다. JSON 요청에서 소수점 이하 3자리를 초과하는 DateTime 값을 올바르게 처리한다. 지원되지 않는 DateTime 포맷(예: `123456000`)을 사용하는 요청은 에러를 발생시킨다. → `Valid Date and DateTime Formats` 참조.
- **Trigger Order of Execution** — API v53.0 **이하**에서 after-save record-triggered flow는 entitlement 실행 *후*에 실행된다. → `Triggers and Order of Execution` 참조. (상세: [[Trigger Order of Execution]])

**API Reference Changes**

| Namespace | Class | Behavior Change |
|---|---|---|
| `Database` | `SaveResult` | API v53.0 이상: `getId()` 메서드는 sObject ID를 반환한다. 단, update 작업 중 record locking이 실패하면 `null` 값을 반환한다. v52.0 이하에서는 레코드가 성공적으로 update되지 않으면 `getId()`가 `null` 값을 반환했다. → `SaveResult.getId()`. |
| `Database` | `UpsertResult` | API v53.0 이상: `getId()` 메서드는 sObject ID를 반환한다. 단, update 작업 중 record locking이 실패하면 `null` 값을 반환한다. v52.0 이하에서는 레코드가 성공적으로 update되지 않으면 `getId()`가 `null` 값을 반환했다. → `UpsertResult.getId()`. |

### Version 52.0

- **CardPaymentMethods and DigitalWallets** — API v52.0 이상에서 `CardPaymentMethods`와 `DigitalWallets`는 동일 레코드에서 `GatewayTokenEncryption`과 `GatewayToken` 값을 동시에 저장할 수 없다. 한쪽이 존재하는데 다른 쪽을 할당하려 하면 Salesforce가 에러를 발생시킨다. → `Tokenization Service Apex Class Implementation` 참조.

**API Reference Changes**

| Namespace | Class | Behavior Change |
|---|---|---|
| `System` | `Database` | API v52.0 이상: `executeBatch` 호출이 Apex flex queue lock 획득에 실패하면, 호출은 `System.AsyncException`을 throw한다. v51.0 이하에서는 `executeBatch` 호출이 Apex flex queue lock 획득에 실패하면, 예외를 throw하는 대신 빈 ID `"000000000000000"`을 반환했다. → `Database.executeBatch()`. |

### Version 51.0

**API Reference Changes**

| Namespace | Class | Behavior Change |
|---|---|---|
| `Schema` | `DescribeFieldResult` | API v51.0 이상: `getReferenceTo()` 메서드는 context user가 접근할 수 없는 참조 객체도 반환한다. context user가 다른 객체를 참조하는 객체의 필드에 접근 권한이 있으면, cross-referenced 객체에 대한 context user의 접근 권한과 무관하게 메서드가 참조를 반환한다. v50.0 이하에서는 context user가 cross-referenced 객체에 접근 권한이 없으면 빈 리스트를 반환했다. → `DescribeFieldResult.getReferenceTo()`. |
| `System` | `String` | API v51.0 이상: `format()` 메서드는 `stringToFormat` 파라미터의 single quote를 지원하며 `formattingArguments` 파라미터를 사용해 포맷된 문자열을 반환한다. v50.0 이하에서는 single quote가 지원되지 않았다. → `String.format()`. |
| `System` | `System` | API v51.0 이상: `hashCode()` 메서드는 동일한 `Id` 값에 대해 동일한 hashCode를 반환한다. v50.0 이하에서는 동일한 `Id` 값이 항상 동일한 hashCode 값을 생성하지는 않았다. → `System.hashCode()`. |

### Version 50.0

- **@NamespaceAccessible Annotation** — API v50.0 이상에서 `@NamespaceAccessible`로 어노테이션된 Apex 변수, 메서드, inner class, interface에 scope와 접근성 규칙이 강제된다. → `NamespaceAccessible Annotation` 및 `Class Variables` 참조.

### Version 49.0

- **@JsonAccess Annotation** — API v49.0 이상에서 직렬화와 역직렬화 모두의 기본 접근은 `sameNamespace`다. v48.0 이하에서는 역직렬화 기본 접근은 항상 `always`였고 직렬화 기본 접근은 `sameNamespace`로 기존 동작을 보존했다. → `JsonAccess Annotation` 참조.
- **@ReadOnly Annotation on REST Methods** — API v49.0 이상에서 Apex REST 메서드에 `@ReadOnly`만 어노테이션할 수 있다. v49.0 이하에서는 `@ReadOnly` 어노테이션이 붙은 Apex REST 메서드에 `@RemoteAction` 어노테이션도 함께 필요했다. → `ReadOnly Annotation` 참조.

> 참고: PDF 원문은 본 항목의 두 번째 문장을 *"In API version 49.0 and earlier, Apex REST methods with the @ReadOnly annotation also require the @RemoteAction annotation."*로 적는다(원문 그대로 옮김).

### Version 47.0

- **@NamespaceAccessible Annotation** — API v47.0 이상에서 `@NamespaceAccessible`는 `@AuraEnabled`로 표시된 entity에 허용되지 않는다. 따라서 패키지에서 설치된 Aura/Lightning web component는, 두 패키지가 동일 namespace에 있더라도 다른 패키지의 Apex 메서드를 호출할 수 없다. 다만 한 패키지의 `@AuraEnabled` public 메서드는 동일 namespace 내 다른 패키지의 `@NamespaceAccessible` public 메서드를 호출할 수 있다. → `NamespaceAccessible Annotation` 참조.

**API Reference Changes**

> PDF 원문은 이 버전의 변경을 3열 표가 아니라 산문 형태로 적는다(아래는 원문 그대로):
>
> *"changedfields Properties in EventBus.ChangeEventHeader: A list of the fields that were changed in an update operation, including the LastModifiedDate system field. This field is empty for other operations, including record creation. This property is available in Apex saved using API version 47.0 or later. See ChangeEventHeader Properties."*

`EventBus.ChangeEventHeader`의 `changedfields` 프로퍼티 — update 작업에서 변경된 필드(시스템 필드 `LastModifiedDate` 포함) 리스트. record 생성을 포함한 다른 작업에서는 비어 있다. 이 프로퍼티는 API v47.0 이상으로 저장된 Apex에서 사용할 수 있다. → `ChangeEventHeader Properties`.

### Version 45.0

- **WITH SECURITY_ENFORCED Clause in SOQL** — `WITH SECURITY_ENFORCED` 절은 Apex에서만 사용 가능하다. **API v45.0보다 이전 버전의 Apex 클래스/트리거에서 `WITH SECURITY_ENFORCED`를 사용하는 것은 권장되지 않는다.** → `Filter SOQL Queries Using WITH SECURITY_ENFORCED` 참조. (cf. v67.0에서 SOQL 쿼리의 `WITH SECURITY_ENFORCED` 미지원 — `WITH USER_MODE`로 대체)

**API Reference Changes**

| Namespace | Class | Behavior Change |
|---|---|---|
| `System` | `TimeZone` | API v45.0 이상: daylight savings가 적용 중일 때 `getDisplayName()`이 Daylight Savings Time을 적절히 표시한다. 예를 들어 `Europe/London`에는 British Summer Time, `America/Los_Angeles`에는 Pacific Daylight Time이 표시된다. → `TimeZone.getdisplayName()`. |

### Version 44.0

- **BatchApexErrorEvent** — `BatchApexErrorEvent` 객체는 batch Apex 클래스와 연관된 platform event를 나타낸다. 이 객체는 API v44.0 이상에서 사용 가능하다. batch Apex 작업의 `start`, `execute`, `finish` 메서드가 처리되지 않은 예외를 만나면 `BatchApexErrorEvent` platform event가 발생한다. → `BatchApexErrorEvent` 참조. (상세: [[Batch Apex]])
- **AuraEnabled Annotation** — API v44.0 이상에서 `@AuraEnabled(cacheable=true)` 어노테이션을 사용해 클라이언트에서 메서드 결과를 캐싱하여 런타임 성능을 개선할 수 있다. 데이터를 조회만 하고 수정하지 않는 메서드에 대해서만 결과를 캐싱할 수 있다. 이 어노테이션을 사용하면 Apex 메서드를 호출하는 모든 action에서 JavaScript 코드의 `setStorable()` 호출이 필요 없어진다. → `AuraEnabled Annotation` 참조.

### Version 42.0

- **Hierarchy Custom Settings** — API v42.0 이상에서 hierarchy custom setting이 `testSetup` 메서드에 insert되면, 동일 `SetupOwnerId`를 가진 hierarchy custom setting 레코드를 test 메서드에서 insert하면 `DUPLICATE_VALUE` 예외가 발생한다. v41.0 이하에서는 `testSetup` 메서드를 포함한 Apex 테스트 클래스의 각 메서드가 hierarchy custom setting 값을 insert할 수 있었다. 이는 메서드들이 다른 test 메서드에서 insert된 hierarchy custom setting 레코드와 동일한 `SetupOwnerId` 값을 가져도 마찬가지였다. → `Hierarchy Custom Setting Methods` 참조.
- **Apex Properties** — API v42.0 이상에서 변수 값이 set accessor에서 설정되지 않은 한, get accessor에서 그 값을 update할 수 없다. → `Apex Properties` 참조.

### Version 41.0

- **Exception Handling** — API v41.0 이상에서 코드 내 도달 불가능(unreachable) 문장은 컴파일 에러를 유발한다. → `Exception Statements` 참조. (상세: [[Apex 언어 기초 — 예외 처리와 예약어]])

**API Reference Changes**

| Namespace | Class | Behavior Change |
|---|---|---|
| `System` | `URL` | API v41.0 이상: Apex `URL` 객체는 `java.net.URL` 타입이 아니라 `java.net.URI` 타입으로 표현된다. `URL` 객체가 인스턴스화된 API 버전이 해당 인스턴스에 대한 후속 메서드 호출의 동작을 결정한다. 복잡한 URL 구조의 edge case를 적절히 처리하는 완전한 RFC 준수 URL 파싱을 위해 API v41.0 이상 사용을 강력히 권장한다. API v41.0 이상에서 입력은 valid한 RFC 준수 URL 또는 URI 문자열이어야 한다. → `URL Class`. |

### Version 39.0

**API Reference Changes**

| Namespace | Class | Behavior Change |
|---|---|---|
| `System` | `SObject` | API v39.0 이상: `getPopulatedFieldsAsMap()`은 레코드가 쿼리된 *후*에 값이 설정되었더라도 SObject에 설정된 모든 값을 반환한다. 이 동작은 이 메서드를 호출하는 Apex 클래스의 버전에 의존하며, SObject를 생성한 클래스의 버전에 의존하지 않는다. API v20.0에서 SObject를 쿼리한 뒤 API v40.0 클래스에서 이 메서드를 호출하면 전체 필드 집합을 얻는다. → `SObject.getPopulatedFieldsAsMap()`. |

### Version 35.0

- **Serialization of IDs** — API v35.0 이상에서 roundtrip JSON 직렬화·역직렬화를 거친 ID에 대해 `==`를 사용한 ID 비교가 실패하지 않는다. → `Roundtrip Serialization and Deserialization` 참조.

**API Reference Changes**

| Namespace | Class | Behavior Change |
|---|---|---|
| `System` | `JSON` | JSON 콘텐츠를 임의의 API 버전에서 Apex 클래스로, 또는 API v35.0 이상에서 객체로 역직렬화할 때, 예외가 throw되지 않는다. Salesforce API v34.0 이하를 사용해 JSON 콘텐츠를 커스텀 객체나 sObject로 역직렬화할 때, `deserialize(jsonString, apexType)`와 `readValueAs(apexType)` 메서드는 불필요한(extraneous) attribute가 전달되면 런타임 예외를 throw한다. → `JSON.deserialize(jsonString, apexType)` 및 `JSONParser.readValueAs()`. |
| `System` | `PageReference` | API v34.0 이상에서 `getContent()`와 `getContentAsPDF()`는 callout으로 취급된다. test 메서드에서 `getContent()` 또는 `getContentAsPDF()`를 사용하면 test 메서드가 실패한다. → `PageReference.getContent()`. |
| `System` | `Pattern` | API v35.0 이상에서 zero-width regExp 파라미터를 사용하면 `split()` 메서드가 올바르게 동작한다. v34.0 이하에서는 zero-width regExp 값이 `split()` 메서드 출력 시작 부분에 빈 list item을 생성했다. → `Pattern.split()`. |

> 셀단위 주의(Pattern B): 이 버전 표의 세 행은 pdftotext에서 페이지 경계(print p.801→802)에 걸쳐 풀려 나온다. `JSON`(`System`)·`PageReference`(`System`)·`Pattern`(`System`) 매핑을 PDF 인접 행과 재대조해 확정함. 세 항목 모두 `System` namespace.

### Version 34.0

- **Schema Namespace Prefixes** — API v34.0 이상에서 커스텀 `SObjectType`에 대한 `Schema.DescribeSObjectResult`는, 현재 실행 중인 코드의 namespace이더라도 namespace로 prefix된 map key를 포함한다. 여러 namespace를 다루고 런타임 describe 데이터를 생성하면, 코드가 namespace prefix를 사용해 key에 올바르게 접근하도록 한다. → `Namespace Prefix` 참조. (상세: [[Schema Namespace 상세]])

**API Reference Changes**

| Namespace | Class | Behavior Change |
|---|---|---|
| `System` | `Date` | API v34.0 ~ v53.0: `Date.valueOf`를 `Datetime` 객체와 함께 호출하면 `Datetime`을 시간 정보 없는 유효한 `Date`로 변환하지만, 결과는 `Datetime` 객체가 초기화된 방식에 따라 달라진다. 예를 들어 `Datetime` 객체가 `Datetime.valueOf(stringDate)`로 초기화되면 반환된 `Date` 값에 시간(hours) 정보가 포함된다. `Datetime` 객체가 `Datetime.newInstance(year, month, day, hour, minute, second)`로 초기화되면 반환된 `Date` 값에 시간 정보가 포함되지 않는다. → `Date.valueOf()`. |
| `System` | `SObject` | API v34.0 이상에서 `get(fieldName)` 메서드로 field Map에서 필드를 조회하려면 namespace 이름을 포함해야 한다. 예를 들어 `MyNamespace` namespace의 `account__c` 필드를 `"fields"`라는 field Map에서 가져오려면 `fields.get('MyNamespace__account__c')`를 사용한다. → `SObject.get(fieldName)`. |

### Version 33.0

**API Reference Changes**

| Namespace | Class | Behavior Change |
|---|---|---|
| `System` | `Date` | API v33.0 이하에서 `Date.valueOf`를 `Datetime` 객체와 함께 호출하면, hours·minutes·seconds·milliseconds가 설정된 `Date` 값을 반환한다. → `Date.valueOf()`. |

### Version 32.0

- **instanceof Operator** — API v32.0 이상에서 좌측 피연산자가 `null` 객체이면 `instanceof`는 `false`를 반환한다. v31.0 이하에서는 이 경우 `instanceof`가 `true`를 반환했다. → `Using the instanceof Keyword` 참조. (상세: [[Apex 언어 기초 — 제어 흐름과 클래스]])

### Version 28.0

- **Null Fields in JSON Serialization** — API v28.0 이상에서 이전 버전과 달리 `null` 필드는 직렬화되지 않고 JSON 문자열에 포함되지 않는다. 이 변경은 `Json.deserialize()` 등 JSON 메서드로 JSON 문자열을 역직렬화하는 데는 영향을 주지 않는다. JSON 문자열을 검사할 때 이 변경이 눈에 띈다.
- **VLOOKUP Validation Rule Function** — API v28.0 이상에서 `VLOOKUP` validation rule 함수는 실행 중인 Apex 테스트에서 조직 데이터에 더 이상 접근하지 않는다. 테스트 클래스/메서드가 `IsTest(SeeAllData=true)`로 어노테이션되지 않는 한, 이 함수는 테스트가 생성한 데이터만 조회한다. v27.0 이하에서는 `VLOOKUP` validation rule 함수가 실행 중인 Apex 테스트에 의해 발동될 때 테스트 데이터에 더해 항상 org 데이터를 조회했다. → `Isolation of Test Data from Organization Data in Unit Tests` 참조.

### Version 26.0

- **Chaining Batch Jobs** — API v26.0 이상에서 기존 batch job에서 다른 batch job을 시작해 job들을 chain하여 엄격한 순차 실행을 강제할 수 있다. → `Use Batch Apex` 참조. (상세: [[Batch Apex]])
- **Calling Database.executeBatch and System.scheduleBatch Methods** — API v26.0 이상에서 임의의 batch Apex 메서드에서 `Database.executeBatch`와 `System.scheduleBatch`를 호출할 수 있다. → `Use Batch Apex` 참조.

### Version 24.0

- **Apex Test Methods** — API v24.0 이상에서 Apex 테스트 메서드는 기본적으로 표준 객체, 커스텀 객체, 커스텀 설정 데이터 등 기존 org 데이터에 접근할 수 없다. 자신이 생성한 데이터에만 접근할 수 있다. 단, 조직 관리에 사용되는 객체나 metadata 객체는 여전히 테스트에서 접근할 수 있다. v23.0 이하에서는 테스트 코드가 조직 내 모든 데이터에 계속 접근할 수 있었고 데이터 접근이 변경되지 않았다. → `Isolation of Test Data from Organization Data in Unit Tests` 참조.

### Version 22.0

- **Batch Apex Exceptions with Test Methods** — API v22.0 이상에서 테스트 메서드가 호출한 batch Apex job 실행 중 발생한 예외는 호출 테스트 메서드로 전달된다. 그 결과 이 예외들은 테스트 메서드를 실패시킨다. → `Use Batch Apex` 참조. (상세: [[Batch Apex]])

### Version 21.0

- **Bulk API Requests** — API v21.0 이상에서 Bulk API 요청이 트리거를 발동시키면, 트리거가 처리할 200 레코드 chunk가 더 이상 작은 chunk로 분할되지 않는다. Bulk API 요청이 200 레코드 chunk에 대해 트리거를 여러 번 발동시키면, 동일 HTTP 요청에 대한 이 트리거 호출들 사이에서 governor limit가 reset된다. static 변수는 동일 Bulk API 요청에 대한 여러 트리거 호출 내에서 reset되지 않는다. v20.0 이하에서는 Bulk API 요청이 트리거를 발동시키면, 트리거가 처리할 200 레코드 chunk가 100 레코드 chunk로 분할되었다.
- **FeedPost Objects** — API v21.0에서 `FeedPost` 객체에 대한 insert·delete 트리거가 지원된다. v20.0 이하에서는 `FeedPost`에 대한 이 트리거 작업이 지원되지 않았다. → `Triggers for Chatter Objects` 참조.
  > 참고(PDF 원문): `FeedPost` 객체는 API v22.0 이상에서 중단(discontinued)되었다. 대신 `FeedItem`을 사용한다. → `FeedItem`.

### Version 17.0

- **HTTP Response Decoding** — API v17.0 이상에서 HTTP 응답은 `Content-Type` 헤더에 지정된 인코딩으로 디코딩된다. v16.0 이하에서는 callout의 HTTP 응답이 `Content-Type` 헤더와 무관하게 항상 UTF-8로 디코딩되었다. → `SOAP Services: Defining a Class from a WSDL Document` 참조.

### Version 16.0

- **Decimal Data Type** — API v16.0 이상에서 Apex는 currency 같은 특정 타입에서 더 높은 정밀도의 `Decimal` 데이터 타입을 사용한다. → `Primitive Data Types` 참조.

### Version 15.0

- **anyType datatype** — Salesforce 데이터 타입 `anyType`은 API v15.0 이상으로 저장되는 Apex 코드를 생성하는 데 사용되는 WSDL에서 지원되지 않는다. v14.0 이하에서는 `anyType`이 `String`으로 매핑되었다. → `SOAP Services: Defining a Class from a WSDL Document` 참조.
- **DMLOptions Settings** — `DMLOptions` 설정은 API v15.0 이상으로 저장된 Apex에서만 사용 가능하다. `DMLOptions` 설정은 Apex DML로 수행되는 레코드 작업에만 적용되고 Salesforce UI를 통한 작업에는 적용되지 않는다. API v15.0 이상에서 `Database.DMLOptions`의 `emailHeader` 프로퍼티는 Apex DML 코드 실행으로 이벤트가 발생할 때 보내는 이메일에 대한 정보를 지정할 수 있게 한다. → `Setting DML Options` 참조.
- **String values** — API v15.0 이상에서 필드에 비해 너무 긴 `String` 값을 할당하면 런타임 에러가 발생한다.

---

## 빠른 조회 (버전 → 키 변경)

```
// 구조 예시 — 빠른 조회 인덱스 (위 전수표의 한 줄 요약, 실제 동작 규칙은 각 버전 항목 참조)
v67  user mode 기본 / sharing 기본 / WITH SECURITY_ENFORCED 미지원(→ WITH USER_MODE)
v65  abstract·override 메서드 접근 한정자 필수
v63  DataWeave 2.9 / 예외 JSON 직렬화 미지원
v62  DataWeave 2.8
v61  private 메서드 오버라이드 안 됨 / DMO describe
v60  List가 Iterable 구현 시 컴파일 실패 / savepoint·DML row limit
v57  Object.toString() namespace 가시성
v55  @AuraEnabled 오버로드 금지
v54  Date.valueOf(Datetime) / Id 검증 / isAccessible / Messaging
v53  DataWeave 진입 / JSON DateTime / Trigger 순서 / Save·UpsertResult.getId
v52  CardPaymentMethods·DigitalWallets / executeBatch AsyncException
v51  getReferenceTo / String.format single quote / hashCode
v50  @NamespaceAccessible scope 강제
v49  @JsonAccess 기본 sameNamespace / @ReadOnly 단독 허용
v47  @NamespaceAccessible + @AuraEnabled / ChangeEventHeader.changedfields
v45  WITH SECURITY_ENFORCED 도입 / TimeZone DST
v44  BatchApexErrorEvent / @AuraEnabled(cacheable=true)
v42  Hierarchy custom setting testSetup / Apex Properties
v41  unreachable 컴파일 에러 / URL=java.net.URI
v39  getPopulatedFieldsAsMap 전체 반환
v35  ID roundtrip == / JSON·PageReference·Pattern
v34  Schema namespace prefix / Date.valueOf / SObject.get
v33  Date.valueOf 시간 포함
v32  instanceof null → false
v28  null 필드 직렬화 제외 / VLOOKUP
v26  batch chaining / executeBatch·scheduleBatch
v24  테스트 org 데이터 격리
v22  batch 예외 테스트 전파
v21  Bulk API chunk·FeedPost
v17  HTTP Content-Type 디코딩
v16  Decimal 데이터 타입
v15  anyType 미지원 / DMLOptions / String 길이
```

---

## 관련 노트

- [[System Namespace]] — `Database`·`Test`·`Type`·`Object`·`Date`·`Id`·`Messaging`·`String`·`URL`·`SObject`·`JSON`·`PageReference`·`Pattern`·`TimeZone` 등 동작 변경 대상 클래스의 상세
- [[Schema Namespace 상세]] — `DescribeSObjectResult`·`DescribeFieldResult`·namespace prefix 변경 상세
- [[Database Namespace 상세]] — `SaveResult`·`UpsertResult`·`executeBatch`·savepoint·user mode 상세
- [[Apex 언어 기초 — 제어 흐름과 클래스]] — abstract/override 접근 한정자, `instanceof`, 메서드 오버라이드 상세
- [[Apex 언어 기초 — 예외 처리와 예약어]] — unreachable 문장 컴파일 에러 상세
- [[DataWeave Namespace]] — DataWeave 버전별(2.5/2.8/2.9) 지원 상세
- [[Trigger Order of Execution]] — after-save flow·entitlement 실행 순서 상세
- [[Batch Apex]] — batch chaining, `BatchApexErrorEvent`, 테스트 예외 전파 상세
- [[권한과 접근 제어 위협]] — user mode·sharing·FLS 강제와 보안 관점
