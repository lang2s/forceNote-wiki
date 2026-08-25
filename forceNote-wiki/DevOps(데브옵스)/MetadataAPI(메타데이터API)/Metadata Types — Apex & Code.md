---
tags: [devops, metadata-api, metadata-types, apex, lwc, visualforce, debug-log, v67, v68]
source: api_meta.pdf v67.0 Summer '26 — Chapter 13 (Metadata Types) + Winter27-v68-Docs/api_meta.pdf v68.0 Winter '27 (PREVIEW, 2026-08-21) pp.229–233
created: 2026-05-22
aliases: [ApexClass 메타데이터, ApexTrigger 메타데이터, ApexPage 메타데이터, LightningComponentBundle 메타데이터, AuraDefinitionBundle 메타데이터, StaticResource 메타데이터, Apex 코드 메타데이터 타입, DebugLevel 메타데이터 타입, debugLevel 파일, debugLevels 폴더, ApexLogLevel]
---

# Metadata Types — Apex & Code

> Apex 클래스·트리거·페이지, LWC·Aura 번들, 정적 리소스 등 코드 관련 메타데이터 타입 상세 필드 정의.

---

## 이 그룹의 타입 목록

| 타입명 | 파일 경로 패턴 | API 버전 |
|---|---|---|
| ApexClass | `classes/ClassName.cls` + `ClassName.cls-meta.xml` | v10.0+ |
| ApexComponent | `components/ComponentName.component` + `-meta.xml` | v12.0+ |
| ApexEmailNotifications | `apexEmailNotifications/apexEmailNotifications.notifications` | v49.0+ |
| ApexPage | `pages/PageName.page` + `PageName.page-meta.xml` | v11.0+ |
| ApexTestSuite | `testSuites/SuiteName.testSuite` | v38.0+ |
| ApexTrigger | `triggers/TriggerName.trigger` + `-meta.xml` | v10.0+ |
| AuraDefinitionBundle | `aura/BundleName/` | - |
| DataWeaveResource | - | - |
| DebugLevel | `debugLevels/LevelName.debugLevel` | **v68.0+** (신규) |
| FunctionReference | - | - |
| LightningComponentBundle | `lwc/ComponentName/` | - |
| LightningMessageChannel | `messageChannels/ChannelName.messageChannel-meta.xml` | - |
| LightningTypeBundle | - | - |
| StaticResource | `staticresources/ResourceName.resource` + `-meta.xml` | - |

---

## ApexClass

Apex 클래스. 클래스, 사용자 정의 메서드, 변수, 예외 타입, 정적 초기화 코드 포함. `MetadataWithContent` 타입을 extends.

**Supported Calls:** CRUD-Based Calls 제외한 모든 Metadata API 호출.

**파일 경로:** `classes/ClassName.cls` + `ClassName.cls-meta.xml`

**주의:** 활성 Apex 작업이 있는 경우 기본적으로 업데이트 배포 불가. 해결:
1. 배포 전 Apex 작업 취소 후 재스케줄
2. Setup → Deployment Settings → "Enable deployments with Apex jobs" 활성화

### Fields

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `apiVersion` | double | - | 클래스 생성 시 지정된 API 버전 |
| `content` | base64 | - | Apex 클래스 정의. Base64 인코딩. `MetadataWithContent`에서 상속 |
| `fullName` | string | - | 클래스 이름. 문자·숫자·언더스코어만 허용, 문자로 시작, 언더스코어로 끝 불가. `Metadata`에서 상속 |
| `packageVersions` | PackageVersion[] | - | 참조된 관리형 패키지 버전 목록 (v16.0+) |
| `status` | ApexCodeUnitStatus (enum) | - | `Active` / `Deleted` (ApexClass는 `Inactive` 미지원) |

### PackageVersion 서브타입

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `namespace` | string | Required | 네임스페이스 프리픽스 (1~15자 영숫자, 대소문자 구분 없음) |
| `majorNumber` | int | Required | 메이저 버전 번호 |
| `minorNumber` | int | Required | 마이너 버전 번호 |

### Declarative Metadata 예시

```xml
<!-- MyHelloWorld.cls-meta.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<ApexClass xmlns="http://soap.sforce.com/2006/04/metadata">
  <apiVersion>66.0</apiVersion>
</ApexClass>
```

```java
// MyHelloWorld.cls
public class MyHelloWorld {
    public static void addHelloWorld(Account[] accs) {
        for (Account a : accs) {
            if (a.Hello__c != 'World') a.Hello__c = 'World';
        }
    }
}
```

**와일드카드(`*`) 지원:** 예

---

## ApexComponent

Visualforce 컴포넌트. `MetadataWithContent` 타입을 extends.

**파일 경로:** `components/ComponentName.component` + `ComponentName.component-meta.xml`

### Fields

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `apiVersion` | double | - | VF 컴포넌트 API 버전 (v16.0+) |
| `content` | base64Binary | - | 컴포넌트 내용. Base64 인코딩. `MetadataWithContent` 상속 |
| `description` | string | - | 컴포넌트 설명 |
| `fullName` | string | - | 컴포넌트 개발자 이름. `Metadata` 상속 |
| `label` | string | Required | 컴포넌트 레이블 |
| `packageVersions` | PackageVersion[] | - | 참조된 관리형 패키지 버전 (v16.0+) |

**와일드카드(`*`) 지원:** 예

---

## ApexEmailNotifications

Apex 오류 이메일 알림 수신자 정의. Flow 오류에도 사용.

**파일 경로:** `apexEmailNotifications/apexEmailNotifications.notifications`

**주의:** 배포 시 기존 org의 모든 알림이 삭제되고 배포된 목록으로 교체된다. `destructiveChanges.xml` 미지원.

### Fields

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `apexEmailNotification` | ApexEmailNotification | - | 개별 이메일 알림. 여러 개 지정 가능 |

### ApexEmailNotification 서브타입

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `email` | string | - | 외부 이메일 주소. `user` 필드와 상호 배타적 |
| `user` | string | - | Salesforce 사용자 이름. `email` 필드와 상호 배타적 |

### Declarative Metadata 예시

```xml
<!-- apexEmailNotifications.notifications — 외부 이메일 알림 -->
<?xml version="1.0" encoding="UTF-8"?>
<ApexEmailNotifications xmlns="http://soap.sforce.com/2006/04/metadata">
  <apexEmailNotification>
    <email>admin@example.com</email>
  </apexEmailNotification>
</ApexEmailNotifications>
```

```xml
<!-- package.xml — 와일드카드 사용 -->
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
  <types>
    <members>*</members>
    <name>ApexEmailNotifications</name>
  </types>
  <version>49.0</version>
</Package>
```

**와일드카드(`*`) 지원:** 예

---

## ApexPage

Visualforce 페이지. `MetadataWithContent` 타입을 extends.

**파일 경로:** `pages/PageName.page` + `PageName.page-meta.xml`

### Fields

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `apiVersion` | double | Required | VF 페이지 API 버전 (v15.0+). 15.0 미만 입력 시 15.0으로 변경 |
| `availableInTouch` | boolean | - | Salesforce 모바일 앱에서 VF 탭 사용 여부 (v27.0+). 표준 오브젝트 탭 VF 재정의는 미지원 |
| `confirmationTokenRequired` | boolean | - | GET 요청에 CSRF 토큰 필요 여부 (v28.0+). true로 변경 시 링크에 토큰 추가 필요 |
| `content` | base64Binary | - | 페이지 내용. Base64 인코딩. `MetadataWithContent` 상속 |
| `description` | string | - | 페이지 설명 |
| `fullName` | string | - | 페이지 개발자 이름. `Metadata` 상속 |
| `label` | string | Required | 페이지 레이블 |
| `packageVersions` | PackageVersion[] | - | 참조된 관리형 패키지 버전 (v16.0+) |

### Declarative Metadata 예시

```xml
<!-- SampleApexPage.page-meta.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<ApexPage xmlns="http://soap.sforce.com/2006/04/metadata">
  <description>This is a sample Visualforce page.</description>
  <label>SampleApexPage</label>
</ApexPage>
```

```html
<!-- SampleApexPage.page -->
<apex:page>
  <h1>Congratulations</h1>
  This is your new Page.
</apex:page>
```

**와일드카드(`*`) 지원:** 예

---

## ApexTestSuite

Apex 테스트 스위트 — 테스트 실행에 포함할 Apex 테스트 클래스 목록.

**파일 경로:** `testSuites/SuiteName.testSuite`

### Fields

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `testClassName` | string[] | - | 이 스위트에 포함할 Apex 테스트 클래스 이름 목록 |

### Declarative Metadata 예시

```xml
<!-- MyTestSuite.testSuite — 네임스페이스·와일드카드 혼용 -->
<?xml version="1.0" encoding="UTF-8"?>
<ApexTestSuite xmlns="http://soap.sforce.com/2006/04/metadata">
  <testClassName>LocalTestClass</testClassName>
  <testClassName>A*Class</testClassName>           <!-- AClass, AnotherClass 등 -->
  <testClassName>Namespace1.NamespacedTestClass</testClassName>
  <testClassName>*</testClassName>                 <!-- 로컬 테스트 전체 -->
  <testClassName>Namespace1.*</testClassName>       <!-- Namespace1의 모든 테스트 -->
</ApexTestSuite>
```

```xml
<!-- package.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
  <types>
    <members>*</members>
    <name>ApexClass</name>
  </types>
  <types>
    <members>Suite1</members>
    <members>Suite2</members>
    <name>ApexTestSuite</name>
  </types>
  <version>38.0</version>
</Package>
```

**와일드카드(`*`) 지원:** 예

---

## ApexTrigger

Apex 트리거. DML 이벤트 전후에 실행되는 Apex 코드. `MetadataWithContent` 타입을 extends.

**Supported Calls:** CRUD-Based Calls 제외한 모든 Metadata API 호출.

**파일 경로:** `triggers/TriggerName.trigger` + `TriggerName.trigger-meta.xml`

### Fields

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `apiVersion` | double | Required | 트리거 생성 시 지정된 API 버전 |
| `content` | base64 | - | Apex 트리거 정의. `MetadataWithContent` 상속 |
| `fullName` | string | - | 트리거 이름. `Metadata` 상속 |
| `packageVersions` | PackageVersion[] | - | 참조된 관리형 패키지 버전 목록 (v16.0+) |
| `status` | ApexCodeUnitStatus (enum) | Required | `Active` / `Inactive` / `Deleted` |

### Declarative Metadata 예시

```xml
<!-- MyHelloWorld.trigger-meta.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<ApexTrigger xmlns="http://soap.sforce.com/2006/04/metadata">
  <apiVersion>66.0</apiVersion>
</ApexTrigger>
```

```apex
// MyHelloWorld.trigger
trigger helloWorldAccountTrigger on Account (before insert) {
    Account[] accs = Trigger.new;
    MyHelloWorld.addHelloWorld(accs);
}
```

**와일드카드(`*`) 지원:** 예

---

## AuraDefinitionBundle

Aura 정의 번들. Aura 컴포넌트, 애플리케이션, 이벤트, 인터페이스, 토큰 컬렉션 및 관련 리소스(JavaScript 컨트롤러 등) 포함.

**파일 경로:** `aura/BundleName/`

---

## DataWeaveResource

DataWeave 스크립트 리소스. `DataWeaveScriptResource` 클래스가 생성되며, Apex에서 직접 호출 가능.

---

## DebugLevel (v68.0 신규)

> **Winter '27 (API 68.0) 신규 최상위 메타데이터 타입.** 출처: `Winter27-v68-Docs/api_meta.pdf` v68.0 Winter '27 (PREVIEW) p.229.

`TraceFlag` 오브젝트에 할당할 **로그 카테고리 레벨 묶음**. 하나의 debug level을 **여러 trace flag가 공유**할 수 있다. `Metadata` 타입을 extends하며 `fullName` 필드를 상속한다.

> PDF 원문(p.229): *"Represents a set of log category levels to assign to a TraceFlag object. Multiple trace flags can use a debug level."*

**파일 경로:** `debugLevels/LevelName.debugLevel` — 확장자 `.debugLevel`, 폴더 `debugLevels` (p.229)

**Version:** *"The DebugLevel metadata type is available in API version 68.0 and later."* (p.229)

### ⚠️ 이름 충돌 — 같은 이름, 다른 API

`DebugLevel`은 **Tooling API sObject**로도 존재한다. 이름만 같고 서로 다른 API의 서로 다른 아티팩트다.

| 구분 | Metadata API `DebugLevel` (이 노트) | Tooling API `DebugLevel` sObject |
|---|---|---|
| 성격 | 배포 가능한 선언적 메타데이터 타입 | SOQL 질의·DML 대상 sObject |
| 형태 | `debugLevels/*.debugLevel` XML 파일 | org 내 레코드 (`Id`로 참조) |
| 사용처 | `package.xml` retrieve/deploy, 소스 추적 | `TraceFlag.DebugLevelId`로 런타임 로그 활성화 |
| API 버전 | 68.0+ | [[Tooling API 디버그·로그·리플레이 sObject]] 참조 |

> 두 API의 **필드 집합이 동일하다고 가정하지 말 것.** 이 노트의 표는 v68 Metadata API 기준 `ApexLogLevel` 필드 **11개** + `label`이다. Tooling API sObject 쪽 카테고리 구성은 해당 노트가 정본이다.

### Fields (p.229–232)

`label`을 제외한 모든 필드는 타입이 `ApexLogLevel` (enumeration of type string)이며, 유효 값은 공통으로 **`NONE` · `ERROR` · `WARN` · `INFO` · `DEBUG` · `FINE` · `FINER` · `FINEST`** 8단계다.

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `apexCode` | ApexLogLevel (enum) | **Required** | Apex 코드 로그 카테고리 레벨. Apex 코드 정보 포함. DML 문, 인라인 SOQL·SOSL 쿼리, 트리거의 시작·완료, 테스트 메서드의 시작·완료 등이 생성한 로그 메시지도 포함될 수 있다 |
| `apexProfiling` | ApexLogLevel (enum) | **Required** | 프로파일링 정보 로그 카테고리 레벨. 네임스페이스의 한도, 발송된 이메일 수 등 누적(cumulative) 프로파일링 정보 포함 |
| `callout` | ApexLogLevel (enum) | **Required** | 콜아웃 로그 카테고리 레벨. 서버가 외부 웹 서비스와 주고받는 request-response XML 포함. SOAP API 호출 관련 이슈 디버깅에 유용 |
| `database` | ApexLogLevel (enum) | **Required** | 데이터베이스 활동 로그 카테고리. 모든 DML 문·인라인 SOQL·SOSL 쿼리를 포함한 DB 활동 정보 |
| `dataAccess` | ApexLogLevel (enum) | - | UI에서 접근한 오브젝트의 **규칙·정책(rules and policy) 정보** 로그 카테고리 레벨. 오브젝트에 접근되지 않는 이유를 판단하는 데 사용. ⚠️ **11개 로그 카테고리 중 유일하게 `Required.` 표기가 없는 필드** (p.230) |
| `label` | string | **Required** | 디버그 레벨의 이름. Developer Console과 Setup에도 표시된다 |
| `nba` | ApexLogLevel (enum) | **Required** | Einstein Next Best Action 활동 로그 카테고리 레벨. Strategy Builder의 전략 실행 상세 포함 |
| `system` | ApexLogLevel (enum) | **Required** | `System.debug` 같은 **모든 system 메서드** 호출 로그 카테고리 레벨 |
| `validation` | ApexLogLevel (enum) | **Required** | 검증 규칙 로그 카테고리 레벨. 규칙 이름, 규칙이 true/false 중 무엇으로 평가됐는지 등 |
| `visualforce` | ApexLogLevel (enum) | **Required** | Visualforce 로그 카테고리 레벨. view state의 직렬화·역직렬화, Visualforce 페이지의 수식 필드 평가 등 Visualforce 이벤트 정보 |
| `wave` | ApexLogLevel (enum) | **Required** | CRM Analytics 로그 카테고리 레벨. 템플릿 처리 오류, 규칙 실행 요약 등 |
| `workflow` | ApexLogLevel (enum) | **Required** | 워크플로우 규칙 로그 카테고리 레벨. 규칙 이름, 수행된 액션 등 |

### Declarative Metadata 예시 (p.233 원문 발췌)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<DebugLevel xmlns="http://soap.sforce.com/2006/04/metadata">
   <label>DebugLevel</label>
   <apexCode>DEBUG</apexCode>
   <apexProfiling>INFO</apexProfiling>
   <callout>FINEST</callout>
   <database>INFO</database>
   <dataAccess>INFO</dataAccess>
   <nba>INFO</nba>
   <system>DEBUG</system>
   <validation>INFO</validation>
   <visualforce>INFO</visualforce>
   <wave>INFO</wave>
   <workflow>FINEST</workflow>
</DebugLevel>
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
   <types>
       <members>*</members>
       <name>DebugLevel</name>
   </types>
   <version>68.0</version>
</Package>
```

**와일드카드(`*`) 지원:** 예 (p.233)

> 릴리즈 노트(`rn_api_meta`)는 이 타입의 목적을 "**에이전틱 도구로 디버그 로그 수준을 구성**"으로 설명한다 → [[Winter '27/Development]].

---

## FunctionReference

배포된 Salesforce Function 참조 정보. `Metadata` 타입을 extends.

---

## LightningComponentBundle

Lightning Web Component 번들. LWC 리소스를 포함하는 번들.

**파일 경로:** `lwc/ComponentName/`

---

## LightningMessageChannel

Lightning Message Channel. LWC, Aura, Visualforce 간 크로스-UI 통신을 위한 보안 채널.

**파일 경로:** `messageChannels/ChannelName.messageChannel-meta.xml`

---

## LightningTypeBundle

커스텀 Lightning 타입. 기본 UI 재정의로 비즈니스 요구에 맞는 커스텀 외관 구현.

---

## StaticResource

정적 리소스 파일. ZIP, 이미지, CSS, JavaScript 등. Visualforce 페이지에서 참조. org 내부 전용 (다른 앱/웹사이트 호스팅 불가).

**파일 경로:** `staticresources/ResourceName.resource` + `ResourceName.resource-meta.xml`

---

## 관련 노트

- [[Metadata Types — 개요 및 분류]] — 전체 타입 목록 및 분류
- [[Metadata API File-Based 호출]] — package.xml에 ApexClass, LightningComponentBundle 등 지정
- [[Metadata API CRUD 호출]] — createMetadata()로 Apex 클래스 생성
- [[Metadata API 에러 처리]] — Apex 배포 오류 처리
- [[2GP — Components - Apex & Code]] — 동일 컴포넌트의 2GP 패키징 관점 Manageability Rules 전수
- [[Tooling API 객체 — Apex 코드·테스트·커버리지]] — 동명 `ApexClass`·`ApexTrigger`의 Tooling API **sObject**(질의·저장본). declarative metadata 타입과 별개 — 필드·용법 상이(경계 구분)
- [[Tooling API 디버그·로그·리플레이 sObject]] — 동명 `DebugLevel`의 Tooling API **sObject**(`TraceFlag.DebugLevelId`로 참조되는 레코드). v68 신규 Metadata API 타입과 이름만 같고 별개
- [[Apex Debug Log]] — 로그 카테고리·레벨이 실제 로그 출력에 미치는 영향
- [[Winter '27/Development]] — `DebugLevel` 신규 타입을 포함한 v68.0 Metadata API 변경 릴리즈 노트 원문
