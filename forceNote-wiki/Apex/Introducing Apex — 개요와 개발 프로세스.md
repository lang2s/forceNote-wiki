---
tags: [Apex, 개요, 개발프로세스, 언어특성, org타입, 개발환경, 테스트, 배포]
source: salesforce_apex_developer_guide.pdf
created: 2026-06-19
aliases: [Introducing Apex, Apex 개요, Apex 개발 프로세스, What is Apex]
---

# Introducing Apex — 개요와 개발 프로세스

> Apex는 Lightning Platform 위에서 동작하는 강타입·객체지향 멀티테넌트 언어다. 이 노트는 Apex가 무엇인지·언제 쓰는지·어떻게 동작하는지(개념 프레이밍)와 개발→테스트→배포에 이르는 개발 프로세스 전반을 다룬다. 언어 문법(변수·문·컬렉션·분기·루프)의 세부는 별도 언어 기초 노트로 위임한다.

---

## What is Apex?

Apex는 **강타입(strongly typed)·객체지향(object-oriented)** 프로그래밍 언어로, 개발자가 API 호출과 함께 **Salesforce 서버에서 flow·transaction 제어문을 실행**할 수 있게 한다.

- **Java와 유사한 문법(syntax looks like Java)** 을 쓰면서 **데이터베이스 stored procedure처럼 동작(acts like database stored procedures)** 한다.
- 버튼 클릭, related record 업데이트, Visualforce 페이지 등 **대부분의 system event에 비즈니스 로직을 추가**할 수 있다.
- Apex 코드는 **Web service 요청** 과 **객체의 trigger** 로부터 기동(initiated)될 수 있다.

> Apex code is the first multitenant, on-demand programming language. (Apex는 최초의 멀티테넌트·온디맨드 프로그래밍 언어다.)

기존에는 Salesforce UI를 통한 커스터마이즈(새 필드·객체·workflow·승인 프로세스 정의) 외에도, 클라이언트 측 프로그램(Java·JavaScript·.NET 등)에서 SOAP API로 `delete()`·`update()`·`upsert()` 같은 DML 명령을 발행할 수 있었다. 그러나 이런 클라이언트 측 로직은 Salesforce 서버에 있지 않아 (1) 일반 비즈니스 트랜잭션을 위해 Salesforce 사이트로 여러 번 왕복(round-trip)하는 성능 비용과 (2) 서버 코드를 안전·견고한 환경에서 호스팅하는 비용·복잡성에 제약을 받는다. Apex는 로직을 플랫폼 서버 측에 두어 이 제약을 해소한다.

### 언어 특성 8종 (전수)

원문 `As a language, Apex is:` 목록 전체.

| 특성 | 설명 |
|---|---|
| **Integrated** | 공통 Lightning Platform 관용구(idiom)에 대한 내장 지원 제공 (하위 6항목은 아래 표) |
| **Easy to use** | 변수·표현식 문법, 블록·조건문 문법, 루프 문법, 객체·배열 표기 등 친숙한 Java 관용구 기반. 새 요소를 도입할 때도 이해하기 쉽고 플랫폼의 효율적 사용을 장려하는 문법·의미를 사용한다. 따라서 간결하고 작성하기 쉬운 코드를 만든다. |
| **Data focused** | 여러 query·DML 문을 Salesforce 서버상의 단일 작업 단위(single unit of work)로 엮도록 설계됨. 데이터베이스 stored procedure처럼 여러 트랜잭션 문을 엮는다. 다른 stored procedure처럼 **UI 요소 렌더링에 대한 범용 지원은 시도하지 않는다.** |
| **Rigorous** | 강타입 언어로, object·field 이름 같은 schema 객체를 직접 참조(direct reference)한다. 참조가 유효하지 않으면 **컴파일 타임에 빠르게 실패(fails quickly at compile time)**. 모든 custom field·object·class 의존성을 metadata에 저장해, active Apex 코드가 요구하는 동안 삭제되지 않도록 보장한다. |
| **Hosted** | Apex는 Lightning Platform에 의해 전적으로 인터프리트·실행·제어된다. |
| **Multitenant aware** | 멀티테넌트 환경에서 실행됨. Apex 런타임 엔진은 runaway code를 철저히 방어하도록 설계되어 공유 리소스 독점을 막는다. 한도(limit)를 위반하는 코드는 이해하기 쉬운 에러 메시지와 함께 실패한다. |
| **Easy to test** | 단위 테스트 생성·실행에 대한 내장 지원. 얼마나 많은 코드가 커버되는지, 어느 부분이 더 효율적일 수 있는지를 나타내는 테스트 결과 포함. Salesforce는 **모든 플랫폼 업그레이드 전에 모든 단위 테스트를 실행**해 custom Apex가 기대대로 동작하는지 보장한다. |
| **Versioned** | 서로 다른 API 버전에 대해 Apex 코드를 저장할 수 있다. 이를 통해 동작(behavior)을 유지(maintain)할 수 있다. |

#### Integrated 하위 6항목 (전수)

원문 `Apex provides built-in support for common Lightning Platform idioms, including:` 의 6개 불릿 전부.

1. **DML 호출** — `INSERT`, `UPDATE`, `DELETE` 같은 Data Manipulation Language(DML) 호출. 내장 `DmlException` 핸들링 포함.
2. **인라인 SOQL/SOSL** — sObject 레코드 리스트를 반환하는 인라인 Salesforce Object Query Language(SOQL) 및 Salesforce Object Search Language(SOSL) 쿼리.
3. **bulk 루핑** — 한 번에 여러 레코드를 bulk 처리(bulk processing)할 수 있게 하는 looping.
4. **레코드 락(locking) 문법** — 레코드 업데이트 충돌(record update conflicts)을 방지하는 locking 문법.
5. **커스텀 public API** — 저장된 Apex 메서드로부터 빌드할 수 있는 custom public API 호출.
6. **참조 객체/필드 삭제 경고** — 사용자가 Apex가 참조하는 custom object·field를 편집·삭제하려 할 때 발생하는 경고(warning)와 에러.

### 지원 에디션 (전수)

> Apex is included in **Performance Edition, Unlimited Edition, Developer Edition, Enterprise Edition, and Database.com.**

Performance · Unlimited · Developer · Enterprise · Database.com 에디션에 포함된다.

---

## When Should I Use Apex?

Salesforce는 prebuilt 앱을 조직에 맞게 커스터마이즈하는 기능을 제공한다. 복잡한 비즈니스 프로세스의 경우 Apex·Lightning Components 등 다양한 도구로 custom 기능과 UI를 구현한다. 아래는 도구별 선택 기준이다.

### Apex 사용 케이스 6종 (전수)

원문 `Use Apex if you want to:` 의 6개 불릿 전부.

| # | 케이스 |
|---|---|
| 1 | **Web service 생성** |
| 2 | **email service 생성** |
| 3 | **여러 객체에 걸친 복합 검증**(complex validation over multiple objects) 수행 |
| 4 | **Flow Builder가 지원하지 않는 복합 비즈니스 프로세스** 생성 |
| 5 | **custom transactional logic** 생성 — 단일 레코드·객체가 아니라 **트랜잭션 전체에 걸쳐 발생하는 로직** |
| 6 | **다른 작업에 custom 로직 부착** — 레코드 저장(saving a record) 같은 작업에 붙여, UI·Visualforce 페이지·SOAP API 어디서 비롯되든 그 작업이 실행될 때마다 발생하도록 함 |

### Lightning Components

Lightning Experience·Salesforce mobile app을 커스터마이즈하거나 독립형 앱을 빌드할 때 Lightning component를 개발한다. out-of-the-box component로 개발 속도를 높일 수도 있다.

- **Spring '19 (API version 45.0)** 부터 두 가지 프로그래밍 모델로 Lightning component를 빌드할 수 있다: **Lightning Web Components(LWC)** 모델과 원조 **Aura Components** 모델.
- LWC는 HTML과 modern JavaScript로 빌드되는 custom HTML element다. LWC와 Aura는 한 페이지에서 공존·상호운용(coexist and interoperate)할 수 있고, Lightning App Builder·Experience Builder에서 동작하도록 구성한다. 관리자·최종 사용자는 어떤 모델로 개발됐는지 알 필요 없이 모두 "Lightning components"로 본다.
- **Salesforce는 custom UI 생성에 LWC 모델 사용을 권장한다.** LWC는 W3C 웹 표준을 따르고 표준 JavaScript 문법으로 빌드·패키징할 수 있으며, Apex와 Lightning Data Service로 Salesforce 데이터를 쉽게 다룬다.

### Visualforce (레거시 성격)

태그 기반 markup 언어. Visualforce로 다음을 할 수 있다:

- 마법사(wizard)와 기타 multistep 프로세스 빌드
- 애플리케이션 전반의 custom flow control 생성
- 최적·효율적 애플리케이션 상호작용을 위한 navigation 패턴과 data-specific 규칙 정의

### SOAP API

**한 번에 한 종류의 레코드만 처리하고 transactional 제어(Savepoint 설정·롤백 등)가 필요 없는** composite 애플리케이션에 기능을 추가할 때 표준 SOAP API 호출을 사용한다.

---

## How Does Apex Work?

모든 Apex는 **Lightning Platform에서 전적으로 on-demand로 실행**된다. 개발자가 Apex 코드를 작성·저장하면, 최종 사용자가 UI를 통해 그 실행을 trigger한다.

```
// 구조 예시 — 실제 원본 다이어그램 아님
// PDF에 "Apex is compiled, stored, and run entirely on the Lightning Platform" 다이어그램 있음 — 아래는 본문 기반 텍스트 재현
[개발자] 작성·저장
   │
   ▼
[플랫폼 애플리케이션 서버]
   ① 코드를 Apex 런타임 인터프리터가 이해할 수 있는 추상 명령(abstract instructions)으로 컴파일
   ② 그 명령을 metadata로 저장
   │
   ▼  (최종 사용자가 버튼 클릭·Visualforce 페이지 접근 등으로 trigger)
[플랫폼 애플리케이션 서버]
   ③ metadata에서 컴파일된 명령을 검색
   ④ 런타임 인터프리터를 통해 실행 후 결과 반환
   │
   ▼
[최종 사용자]  — 표준 플랫폼 요청과 실행 시간 차이를 느끼지 못함
```

요약: **컴파일 → metadata 저장 → (trigger 시) metadata에서 명령 검색 → 런타임 인터프리터 실행 → 결과 반환**. 최종 사용자는 표준 플랫폼 요청 대비 실행 시간 차이를 관찰하지 못한다(observes no differences in execution time).

---

## Developing Code in the Cloud

Apex는 클라우드(멀티테넌트 플랫폼)에 저장·실행된다. 데이터 접근·조작과 system event에 custom 비즈니스 로직을 추가하는 데 특화돼 있으나, **범용(general purpose) 프로그래밍 언어가 아니다.**

### Apex로 할 수 없는 것 (제약 전수)

원문 `Apex cannot be used to:` 의 4개 불릿 전부.

| 제약 | 내용 |
|---|---|
| **UI 렌더링 불가** | 에러 메시지 외에 UI 요소를 렌더링할 수 없음(render elements in the user interface other than error messages) |
| **표준 기능 변경 불가** | standard functionality를 변경할 수 없음 — Apex는 그 기능이 **발생하는 것을 막거나(prevent)**, **추가 기능을 더할(add additional functionality)** 수만 있다 |
| **임시 파일 불가** | temporary file 생성 불가 |
| **스레드 생성 불가** | thread spawn 불가 |

### Governor Limits & bulk 패턴

> [원문 Tip] 모든 Apex 코드는 모든 다른 조직이 함께 쓰는 공유 리소스인 Lightning Platform에서 실행된다. 일관된 성능·확장성을 보장하기 위해 Apex 실행은 **governor limit**에 의해 제한되어, 단일 Apex 실행이 Salesforce 전체 서비스에 영향을 주지 않도록 한다. 즉 모든 Apex 코드는 한 프로세스 내에서 수행할 수 있는 연산(DML·SOQL 등) 횟수에 제한을 받는다.

> [원문] 모든 Apex 요청은 **1~50,000개 레코드**를 담은 collection을 반환한다. 코드가 한 번에 단일 레코드만 다룬다고 가정하면 안 된다. 따라서 반드시 **bulk 처리(bulk processing)를 고려한 프로그래밍 패턴**을 구현해야 하며, 그러지 않으면 governor limit에 부딪힐 수 있다.

> governor limit의 항목별 수치·관리 기법은 [[Governor Limits]] 참조. (이 노트는 개념 프레이밍만 담당)

---

## Understanding Apex Core Concepts — 위임 (요약)

PDF의 "Understanding Apex Core Concepts"는 변수·문(statement)·컬렉션·분기·루프 등 다른 언어에서 익숙한 요소를 다룬다. 이 노트는 **개념 프레이밍**만 담당하므로, 각 문법의 세부는 아래 언어 기초 노트로 위임한다(여기서 재서술하지 않음).

- **변수·데이터타입·표현식·Version Settings** → [[Apex 언어 기초 — 데이터타입과 변수]]
- **문(statement)·분기(if-else)·루프(Do-while/While/For)·클래스** → [[Apex 언어 기초 — 제어 흐름과 클래스]]
- **예외 처리·예약어(reserved keyword)** → [[Apex 언어 기초 — 예외 처리와 예약어]]

PDF 원문 발췌 — 변수 선언 문법(개념 프레이밍용 1개만, 세부는 위 노트):

```apex
// Apex Developer Guide 원문 발췌
datatype variable_name [ = value];

// The following variable has the data type of Integer with the name Count,
// and has the value of 0.
Integer Count = 0;
// The following variable has the data type of Decimal with the name Total. Note
// that no value has been assigned to it.
Decimal Total;
// The following variable is an account, which is also referred to as an sObject.
Account MyAcct = new Account();
```

> Tip(원문): 문장 끝 세미콜론(`;`)은 선택이 아니다 — 모든 statement는 세미콜론으로 끝나야 한다.

---

## Apex Development Process

To develop Apex, get a Developer Edition account, write and test your code, then deploy your code. (Developer Edition 계정을 얻고, 작성·테스트한 뒤 배포한다.)

### 권장 6단계 (전수)

원문 `We recommend the following process for developing Apex:` 의 6단계 전부.

1. Apex 개발용 Salesforce **org를 선택**한다.
2. Apex에 대해 **더 학습**한다.
3. **Apex를 작성**한다.
4. Apex를 작성하면서 **테스트도 함께 작성**한다.
5. (선택) Apex를 **sandbox 조직에 배포해 최종 단위 테스트**를 수행한다.
6. Apex를 **Salesforce production 조직에 배포**한다.

작성·테스트가 끝나면 class·trigger를 **AppExchange App 패키지**에 추가할 수도 있다.

### Org 타입 5종 (전수)

원문 `Choose a Salesforce Org for Apex Development` 의 모든 org 타입. **production org에서는 직접 Apex를 개발할 수 없다.**

| Org 타입 | 권장 여부 | 핵심 |
|---|---|---|
| **Sandbox** | Recommended | production org metadata의 복사본을 별도 환경에 둠. sandbox 타입에 따라 데이터 양이 다름. 새 기능 실험·검증에 안전한 공간. **source tracking이 켜진 Developer / Developer Pro sandbox**는 Salesforce CLI·Code Builder·DevOps Center 등 Salesforce DX source-driven 도구 기능 다수를 활용할 수 있다. |
| **Scratch Org** | Recommended | source-driven·**임시(temporary)** 배포. 완전 구성 가능(fully configurable)으로 서로 다른 Salesforce 에디션을 에뮬레이트. **최대 수명 30일, 기본값 7일(maximum 30-day lifespan, default 7 days).** |
| **Developer Edition (DE)** | — | Enterprise Edition 기능 다수에 접근 가능한 **무료** org. 시간이 지나면 out-of-date 될 수 있고 storage 제한. **source tracking 미지원** → DevOps Center에서 개발 환경으로 사용 불가. 정기적으로 로그인하지 않으면 만료. 원하는 만큼 가입 가능. |
| **Trial Edition** | — | 보통 **30일 후 만료**. 기능 평가에는 좋지만 영구 개발 환경용은 아님. trial에서 Apex trigger를 쓸 수 있으나 **다른 에디션으로 전환 시 비활성화** → 전환 전에 다른 org로 코드를 배포해야 trigger를 보존. |
| **Production** | **Not Supported** | 코드·앱의 최종 목적지로 live 사용자가 데이터에 접근. **production org에서는 Apex를 개발할 수 없으며**, production에서 코드·metadata를 직접 수정하는 것을 피하라고 권장. 개발 중 live 사용자가 시스템에 접근하면 데이터 불안정·앱 손상 가능. |

> org 생성·배포 워크플로우(scratch org/sandbox CLI 기반)는 [[Salesforce DX 개요]] 참조.

### 개발 환경

원문 `Choose a Development Environment for Writing Apex` 전체.

**Agentforce for Developers** — 자연어 prompt에서 Apex 코드를 생성하고 작성 중 코드 completion을 자동 제안하는 AI 기반 개발 도구. Apex용 단위 테스트 케이스를 쉽게 만들어 필요한 테스트 커버리지에 도달하도록 돕는다. 확장(`salesforcedx-einstein-gpt`)은 Salesforce Expanded Pack의 일부이며 **VS Code에서 기본 활성화**. (Generate Apex Code / Inline Auto Completion / Test Case Generation 기능)

**Salesforce Extensions for VS Code and Code Builder** — 경량·확장 가능한 VS Code 에디터에서 Salesforce 플랫폼 개발용 도구. 개발 org(scratch org·sandbox·DE org)·Apex·Lightning component·Visualforce 작업 기능 제공. **Code Builder**는 데스크톱 경험의 브라우저 기반 버전으로 모든 것이 설치·구성돼 있어 어떤 컴퓨터에서나 작업 가능.

**Developer Console** — Salesforce에 내장된 IDE. Apex class·trigger 생성·디버그·테스트에 사용. Lightning Experience에서는 quick access 메뉴 → Developer Console, Salesforce Classic에서는 `Your Name > Developer Console`로 연다. 지원 작업 7종(전수):

| # | 작업 | 내용 |
|---|---|---|
| 1 | **Writing code** | source code editor로 코드 추가. 조직 내 패키지 browse 가능 |
| 2 | **Compiling code** | trigger·class 저장 시 자동 컴파일. 컴파일 에러 보고 |
| 3 | **Debugging** | debug log 확인, 디버깅을 돕는 checkpoint 설정 |
| 4 | **Testing** | 특정 test class 또는 조직 내 모든 테스트 실행, 결과 확인, code coverage 검사 |
| 5 | **Checking performance** | debug log를 검사해 성능 병목(bottleneck) 위치 파악 |
| 6 | **SOQL queries** | Query Editor로 조직 데이터를 쿼리하고 결과 확인 |
| 7 | **Color coding and autocomplete** | source code editor의 색상 스킴으로 코드 요소 가독성↑, class·method 이름 자동완성 제공 |

**Salesforce Setup Code Editors** — Salesforce Setup에서 Apex class·trigger 확인·편집. 저장 시 모두 컴파일되고 syntax 에러가 표시되며, 에러 없이 컴파일되기 전엔 저장 불가. UI가 줄 번호를 매기고 주석·키워드·literal string 등을 색상으로 구분. Setup의 Quick Find에 `Apex` 입력 → class/trigger 선택 → Edit. trigger 생성은 Quick Find에 `Object` → Object Manager → 객체 → Triggers → New. **production org의 Apex는 Setup 코드 에디터로 수정할 수 없다.**

**Additional Editors** — Notepad 같은 임의의 텍스트 에디터로 작성한 뒤 애플리케이션에 복붙하거나 API 호출로 배포. 자체 Apex IDE를 개발하려면 trigger·class 컴파일·test method 실행에 **SOAP API** 메서드를, production 배포에 **Metadata API** 메서드를 사용한다.

### Learning Apex (리소스)

- **Apex Trailhead Content** (초·중급): Quick Start: Apex / Apex Basics & Database / Apex Triggers / Apex Integration Services / Apex Testing / Asynchronous Apex
- **Apex Developer Center** (초·고급): Apex 언어 관련 글·빠른 소개·best practice
- **Code Samples and SDKs** (초·고급): 오픈소스 코드 샘플·SDK·reference code. 공통 use case별 간결한 예제 라이브러리는 Apex-recipes
- **Training Courses**: Salesforce Trailhead Academy의 교육 과정, Salesforce Credentials

### 테스트·배포 요건 (전수)

원문 `Writing Tests` + 배포 섹션. test-driven development(코드 개발과 동시에 테스트 개발) 강력 권장.

단위 테스트(unit test)는 특정 코드가 제대로 동작하는지 검증하는 class method다. **인자를 받지 않고(take no arguments), DB에 데이터를 commit하지 않으며, 이메일을 보내지 않는다.** 이런 method는 method 정의에 **`@IsTest` 어노테이션**으로 표시되며, 단위 테스트 method는 **`@IsTest`로 어노테이트된 test class 안에 정의**돼야 한다.

> Note(원문): method의 `@IsTest` 어노테이션은 `testMethod` 키워드와 동등하다. **best practice로 Salesforce는 `testMethod`보다 `@IsTest` 사용을 권장**한다. `testMethod` 키워드는 향후 릴리스에서 versioned out 될 수 있다.

배포·AppExchange 패키징 전 충족 요건:

| 요건 | 내용 |
|---|---|
| **75% 커버리지** | 단위 테스트가 **Apex 코드의 최소 75%를 커버**해야 하고, 그 모든 테스트가 성공적으로 완료돼야 한다 |
| **production 기본 실행** | production 조직 배포 시 조직 namespace 내 각 단위 테스트가 기본적으로 실행됨 |
| **System.debug 미집계** | `System.debug` 호출은 Apex code coverage에 **포함되지 않음(aren't counted)** |
| **test 미집계** | test method·test class는 code coverage에 **포함되지 않음** |
| **커버리지 사고방식** | 75%는 최소치일 뿐 — 비율에 집착하지 말고 positive·negative, bulk·single 레코드를 포함한 모든 use case를 커버하라. 그러면 자연히 75% 이상 커버됨 |
| **trigger 커버리지** | **모든 trigger는 어느 정도의 test coverage가 있어야 함** |
| **컴파일** | 모든 class·trigger가 성공적으로 컴파일돼야 함 |

배포 경로:

- **Sandbox 배포**: VS Code용 Salesforce extension의 로컬 프로젝트에서 배포하거나, Metadata API `deploy()` 호출로 DE org → sandbox 배포. `runTests()` API로 특정 class·class 리스트·namespace의 단위 테스트 실행 가능. Salesforce CLI도 사용 가능.
- **Production 배포**: 모든 단위 테스트 완료·검증 후 최종 단계. VS Code/Code Builder에서 배포하거나, Salesforce UI의 **change set**으로 배포. (자세히는 [[Apex 배포 방법]])
- **AppExchange 패키지**: 패키지에 포함된 Apex는 **최소 75% 누적(cumulative) test coverage** 필요. 각 trigger도 일부 coverage 필요. 업로드 시 모든 테스트가 실행돼 에러 없이 통과하는지 확인. `@isTest(OnInstall=true)`로 어노테이트된 테스트는 패키지가 설치자 조직에 설치될 때 실행되며, 이 subset이 통과해야 설치가 성공한다.

> 코드를 production에 올리는 방법(change set·Metadata API·CLI)·익명 실행은 [[Apex 배포 방법]]·[[Anonymous Apex 실행]] 참조.

---

## 관련 노트

- [[Apex 언어 기초 — 데이터타입과 변수]] — 변수·데이터타입·표현식·Version Settings (Core Concepts 위임)
- [[Apex 언어 기초 — 제어 흐름과 클래스]] — 문·분기·루프·클래스 (Core Concepts 위임)
- [[Apex 언어 기초 — 예외 처리와 예약어]] — 예외 처리·reserved keyword (Core Concepts 위임)
- [[Apex 배포 방법]] — change set·Metadata API·CLI 배포 상세
- [[Anonymous Apex 실행]] — 익명 블록 실행
- [[Governor Limits]] — 한도 항목·수치·bulk 패턴 상세
- [[Salesforce DX 개요]] — scratch org·sandbox·source-driven 개발 워크플로우
