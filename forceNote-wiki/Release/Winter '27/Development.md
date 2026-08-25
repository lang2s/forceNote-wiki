---
tags: [release, winter_27, development, apex, lwc, api]
api_version: v68.0
release_date: 2026-10
created: 2026-08-24
source: help.salesforce.com Salesforce Winter '27 Release Notes (release=264, Tier 2) + Winter27-v68-Docs/api_tooling.pdf v68.0 + Winter27-v68-Docs/api_meta.pdf v68.0 Winter '27 (PREVIEW, 2026-08-21, BYOC 텔레포니 4종 부재 대조)
aliases: [Winter '27 Development, 윈터27 개발, v68 Apex 변경, Apex Symbol API, symbols 리소스, apexCompileResults, Elastic Limits Batch Apex, Apex Integration Tests, LWC API 68.0, testLevel 파라미터, explicitNamespace, SOQL FORMULA, Apex heap 10MB, ApexGuru 중복 코드, Headless 360, Claude Code Plugin, lwc:external]
---

# Winter '27 — Development (Apex · LWC · API · 개발 도구)

> v68.0 개발자 항목 전수. Apex heap 한도 인상(6→10 MB / 12→25 MB), Batch 잡 Elastic Limits(Beta), Apex Symbol API(Beta), Apex Integration Tests(Developer Preview), LWC 복합 템플릿 표현식·`lwc:external` GA, 그리고 Apex/API/Metadata/Tooling/LWC/Aura New & Changed 카탈로그를 포함한다. **LWC API 68.0은 버전별 변경이 없어 기존 컴포넌트 일괄 업그레이드에 적합한 릴리즈다.**

---

## 개요

이 노트는 [[Winter '27]] 릴리즈의 **개발자(Apex · LWC · API · 개발 도구)** 영역을 다룬다.

핵심 흐름:

- **Apex 실행 한도가 완화된다** — 동기 heap 6 MB → 10 MB, 비동기 heap 12 MB → 25 MB. Winter '27 비프로덕션 org에 한해 구 한도로 되돌리는 임시 설정이 제공되며 Spring '27에는 전역 강제된다.
- **비동기 Apex 운영 모델이 바뀐다** — Elastic Limits(Beta)가 future·Queueable에 이어 **Batch 잡**까지 확대. 비프로덕션 org에서 한도 override로 탄력 처리 동작을 시험할 수 있다.
- **툴링 계층이 두껍게 확장된다** — Apex Symbol API(Beta, `/tooling/symbols`), 무효 클래스만 재컴파일(`/tooling/apexCompileResults`), Test Discovery API의 `testLevel` 파라미터. IDE·AI 에이전트가 Apex 타입 정보를 정식 API로 얻는다.
- **LWC는 "언어 기능" 2건이 GA** — 복합 템플릿 표현식, 서드파티 웹 컴포넌트(`lwc:external`). 반면 **LWC API 68.0 자체에는 버전별 변경이 없다.**
- **개발 도구 릴리즈 노트 구조가 재편됐다** — Salesforce CLI · Agentforce Vibes · Agentforce Vibes IDE는 **Headless 360** 섹션으로 이동했고, Customization · Deployment · Development 섹션은 **Platform** 섹션으로 통합됐다.

상위 허브: [[Winter '27]] · 형제 스포크: [[Winter '27/Platform]] · [[Winter '27/Clouds]] · [[Winter '27/Agentforce]] · [[Winter '27/Release Updates]]

### 소스와 신뢰도

| 항목 | 내용 |
|---|---|
| 1차 소스 | help.salesforce.com **Salesforce Winter '27 Release Notes**(`release=264`) Development 영역 **62 페이지** — Tier 2 |
| 보조 소스 | **Tooling API Reference and Developer Guide, Version 68.0, Winter '27** — 파일 경로 **`Salesforce Documents/Winter27-v68-Docs/api_tooling.pdf`**(표지 확인: *Version 68.0, Winter '27* · PREVIEW · Last updated: August 21, 2026 · 1,027쪽) — Tier 2 |
| ⚠️ **파일 혼동 주의** | 레포에는 **`Salesforce Documents/api_tooling.pdf`** 도 있으나 그 파일은 **Version 67.0, Summer '26**(1,006쪽)이며 **이 노트가 인용한 v68.0 내용을 하나도 담고 있지 않다**(`apexCompileResults` 0회 · `typeStubs` 0회). 이 노트의 **모든 PDF 인용은 `Winter27-v68-Docs/` 하위 v68.0 파일**을 가리키며, 아래 본문의 인용 표기도 전부 `Winter27-v68-Docs/api_tooling.pdf` 로 적었다 |
| 인용 표기 | PDF 인용은 **인쇄 페이지 번호**(예: 인쇄 p.31 = 물리 43쪽, 오프셋 물리−12). 오프셋은 `Winter27-v68-Docs/api_tooling.pdf` 로 직접 대조 확인했다 |

> ⚠️ **1차 소스 추출 방식 주의.** 릴리즈 노트 62페이지는 *페이지 단위 축자(verbatim) 산문*이 아니라 **밀도 높은 사실 기록** 형태로 확보됐다. API 이름·한도 수치·에디션·Setup 경로·Where/When/Why/How 같은 기술적 실체는 온전하지만 **문장 표현은 압축돼 있다.** 따라서 이 노트에서 릴리즈 노트를 근거로 쓴 서술은 "사실"로는 신뢰할 수 있으나 **축자 인용이 아니다.** 코드 블록만이 소스에서 그대로 확보된 부분이며, 각 블록에 출처 주석을 달았다. Tooling API 관련 축자 인용이 필요한 곳은 PDF(Tier 2 원문)로 대체했다.

> ⚠️ **미확보 코드 3건.** 릴리즈 노트 3개 페이지의 코드 샘플이 브라우저 콘텐츠 안전 필터에 걸려 추출되지 않았다(**필터는 우회하지 않았다 — 올바른 처리**). 이 중 Apex Symbol API는 공식 v68.0 PDF로 완전 대체했고, 나머지 2건은 어느 소스에서도 확보되지 않아 **기억으로 재구성하지 않고 동작 설명 + 공식 문서 안내로 남겼다.** 상세는 아래 [#미확보 항목 (소스에서 재현 불가)](#미확보-항목-소스에서-재현-불가) 참조.

---

## GA (Generally Available) — 4건

이번 릴리즈 Development 영역에서 "Generally Available" 마커가 확인된 항목은 다음 4건이다.

### LWC 복합 템플릿 표현식 (Generally Available)

UI를 렌더하는 컴포넌트가 **HTML 템플릿 파일 안에서 복합 JavaScript 표현식**을 직접 쓸 수 있다. 정교한 표현 로직을 템플릿으로 옮겨 컴포넌트 구현부의 군더더기 코드를 없애는 것이 목적이며, **기본 프로퍼티를 쓸 수 있던 자리라면 어디서든** 복합 표현식을 쓸 수 있다.

- **Where:** Lightning Experience, Experience Builder 사이트, 모든 버전의 모바일 앱 — 전 에디션.
- **Why:** LWC 템플릿 시스템은 virtual DOM 기반으로 컴포넌트를 렌더한다. 복합 템플릿 표현식은 이 능력을 **JavaScript 표현식의 포괄적 부분집합**으로 확장하되, 컴포넌트의 성능 특성과 보안 모델은 유지한다.
- **How — 전제 조건:** 해당 컴포넌트의 `apiVersion`을 **66.0 이상**으로 설정해야 그 컴포넌트에서 복합 템플릿 표현식이 활성화된다. (68.0이 아니라 66.0이다.)

> 문법·예제는 Lightning Web Components Developer Guide의 *Template Expressions* 문서가 정본이다. 릴리즈 노트 페이지에는 코드 예제가 포함돼 있지 않았다 — [[LWC 템플릿 기초 (데이터 바인딩·표현식)]]와 함께 본다.

### LWC 서드파티 웹 컴포넌트 — `lwc:external` (Generally Available)

서드파티 웹 컴포넌트를 **다시 작성하지 않고** LWC 앱에 통합한다. LWC 템플릿에서 네이티브 웹 컴포넌트로 렌더하려면 `lwc:external` 지시자를 쓴다.

- **Where:** Lightning Experience — 전 에디션.
- **상태:** GA이며 **직전 beta 릴리즈 이후 변경 사항 없음**(no changes since the last beta release).
- **How:** Lightning Web Components Developer Guide의 *Use Third-Party Web Components in LWC* 참조.

### ApexGuru — 중복 코드 탐지 · 에이전틱 IDE 스캔 (Generally Available)

ApexGuru가 **완전 중복·근사 중복(exact and near-duplicate) Apex 코드**를 탐지한다. 결과는 **제거 가능한 문자 수(number of characters you can remove)** 기준으로 랭크된다. 또한 Cursor · VS Code · Agentforce Vibes 등 **에이전틱 IDE에서 안티패턴 스캔**을 실행할 수 있다.

- **Where:** ApexGuru가 활성화된 **프로덕션 및 Full Copy Sandbox** 환경. ApexGuru는 **Unlimited Edition · Signature Success Plan · Scale Test 고객에게 추가 비용 없이 GA**다. **Government Cloud 미지원.**
- **How (Setup 경로):**

```text
// 구조 예시 — 실제 동작 코드 아님 (릴리즈 노트 rn_apexguru의 Setup 탐색 경로)
Setup → Quick Find: "Scale"
  → Scale Center → Scale Insights → ApexGuru Insights
  → "Code Duplicates" 권고 확인
```

- **IDE 스캔:** 에이전틱 IDE에서 스캔하려면 **Salesforce DX MCP Server**를 통해 org를 연결한다. 참고 자료명: *Performance-First Apex Development with ApexGuru in Salesforce DX MCP Server*.

### Enable Field History Tracking for Users (Generally Available)

**User 오브젝트의 필드 변경 이력**을 추적한다. **최대 20개 필드**를 추적해 UI·대량 작업·Apex·API를 통한 변경을 모니터링하며, 이전 값/새 값·타임스탬프·변경자를 포함한 상세 로그를 본다. 리포트로 사용자 활동을 분석할 수 있다.

> 이 항목은 릴리즈 노트에서 **Customization → General Setup** 아래에 있으나, User 필드 이력은 Apex·API로 접근하는 감사 데이터이므로 개발 영역에서도 실질적 의미가 크다. 기능 자체의 상세는 [[Field History Tracking (필드 이력 추적)]] 참조.

---

## Beta — 5건

> **법적 고지에 대하여.** 소스에서 표준 Beta 법적 고지가 확인된 항목에는 다음이 붙는다 — Beta Services Terms(Agreements — Salesforce.com) 또는 고객이 체결한 Unified Pilot/Beta Agreement, 그리고 Product Terms Directory의 해당 조건을 따르며 **사용 여부는 고객의 단독 재량**이다. 아래에서는 각 항목마다 이 고지를 반복하지 않는다.
> 다만 **모든 Beta 항목에 고지가 붙어 있는 것은 아니다** — 아래 5번(Salesforce DX MCP Server and Tools)은 릴리즈 노트 페이지 본문에 beta 마커도 법적 고지도 없고, **beta 판정 근거가 링크된 개발자 가이드 제목**뿐이다(해당 절의 주의 박스 참조).

> **이 절에 없는 것 — 비프로덕션 org 한도 override.** *Test Elastic Limits by Overriding the Asynchronous Apex Job Limit in Nonproduction Orgs* 는 **Beta 항목이 아니다.** 소스에 `(Beta)` 표기도 beta 법적 고지도 없는 일반 기능이며, **Beta인 Elastic Limits를 시험하기 위한 도구**다. 따라서 아래 [#비프로덕션 org에서 비동기 Apex 잡 한도 override (Elastic Limits 테스트)](#비프로덕션-org에서-비동기-apex-잡-한도-override-elastic-limits-테스트) 절(Apex 본문 신기능)에 두었다.

### 1. Batch 잡 Elastic Limits (Beta)

Elastic limits beta가 future 메서드·Queueable 잡에 이어 **Batch 잡**에도 적용된다. org가 **표준 24시간 롤링 비동기 잡 한도**를 초과할 때 실행 실패·한도 예외를 예방하는 장치로, 더 높은 **elastic 비동기 잡 한도**까지 계속 큐잉할 수 있다.

- **초과 시 동작:** 비동기 잡이 표준 한도를 넘어서면 시스템이 **진행 중(in-flight) Batch 잡의 처리 속도를 스로틀**하고, **신규 Batch 잡은 동시에 1개만 활성**으로 제한한다.
- **Where:** *"Use elastic limits for asynchronous Apex jobs (beta)"* 설정이 켜진 org. Lightning Experience·Salesforce Classic의 Enterprise · Performance · Unlimited · Developer 에디션.
- **How:** Apex Settings에서 해당 설정을 켠다. org의 elastic 한도는 설정 옆 툴팁에 hover하면 보인다. 비동기 잡 사용량은 **`OrgLimits` 클래스**의 메서드로 확인한다.
- **한도 계산 변경 (프로덕션):**

  > 릴리즈 노트 원문(요지): *A production org's elastic limit equals its 24-hour rolling asynchronous Apex limit plus additional capacity.* 이 **추가 용량(additional capacity)** 이 이번 릴리즈에서 **"라이선스된 비동기 Apex 잡 한도" 또는 "200만(2 million) 잡" 중 더 낮은 값**으로 캡됐다. **이전 캡은 1,000만(10 million) 잡**이었다.

```text
// 구조 예시 — 실제 동작 코드 아님 (프로덕션 elastic 한도 산식 도식화)
프로덕션 elastic 한도 = 24시간 롤링 비동기 Apex 한도
                      + min(라이선스된 비동기 Apex 잡 한도, 2,000,000)   ← 이번 릴리즈에서 캡 축소
                                                                          (이전: 10,000,000)
```

### 2. Apex Symbol API (Beta) — `/tooling/symbols`

내장(built-in) · 커스텀 · 패키지 · 동적(dynamic) Apex 타입의 **상세 메타데이터**(클래스 · 인터페이스 · enum · 메서드 · 트리거)를 반환하는 **Tooling API REST 리소스**다. 용도는 ① IDE 코드 완성 ② Apex를 생성하는 AI 에이전트에 컨텍스트 제공 ③ 코드에 대한 관리자 질문에 답하는 setup 에이전트의 그라운딩이다.

- **Where:** **API 버전 68.0 이상**, Lightning Experience·Salesforce Classic의 Enterprise · Performance · Unlimited · Developer 에디션.
- **Why:** Apex **컴파일러가 사용하는 것과 동일한 타입 정보**를 노출해, 기존 `/completions` Tooling API 엔드포인트와 `SymbolTable` Tooling API 오브젝트가 남긴 공백을 메운다.
- **필요 권한:** **Author Apex** org 권한 + **View Setup** 사용자 권한 (PDF 기준).

> 아래 스펙 전체는 릴리즈 노트가 아니라 **공식 v68.0 Tooling API 가이드**(`Winter27-v68-Docs/api_tooling.pdf`, 인쇄 p.31–37)를 정본으로 삼았다. 릴리즈 노트 페이지의 요청 라인·JSON 응답 코드 블록은 안전 필터로 확보하지 못했고, PDF가 동일 내용을 더 완전하게 문서화한다.

**Syntax** (Winter27-v68-Docs/api_tooling.pdf v68.0 인쇄 p.31)

| 항목 | 값 |
|---|---|
| URI | `/services/data/vXX.X/tooling/symbols/` |
| HTTPS Method | `GET` |
| Authentication | `Authorization: Bearer token` |
| Format | JSON |
| Request Body | 없음 (None) |

**Request Query Parameters** (인쇄 p.32 — 셀 단위 대조 완료)

| 파라미터 | 타입 | 필수 | 설명 |
|---|---|---|---|
| `category` | String | **Required** | 조회할 Apex 타입 카테고리. 값: `builtin` — 표준 Apex 타입(예: System · Database · Messaging 네임스페이스의 타입) / `database` — 커스텀 및 패키지 Apex 타입 / `dynamic` — 동적 Apex 타입 |
| `namespace` | String | Optional | 특정 네임스페이스로 결과를 필터. **로컬 org 네임스페이스만** 조회하려면 빈 문자열을 전달한다(`namespace=`). 생략하면 해당 category의 **모든 네임스페이스** 타입이 반환된다 |
| `name` | String | Optional | 지정한 Apex 타입 이름으로 필터. `namespace`와 `name`을 함께 지정하면 **두 조건을 모두 만족**해야 한다 |

> 릴리즈 노트는 필터링의 이점을 이렇게 설명한다 — 대형 org에서 성능을 개선하고, 특정 네임스페이스·클래스 등 일부 타입 정보만 필요한 소비자에게 더 나은 경험을 준다.

**Response Body — 최상위**

| 이름 | 타입 | 설명 |
|---|---|---|
| `typeStubs` | Object[] | Apex 타입 배열. 각 객체는 Apex 클래스·인터페이스·enum·트리거 하나를 기술하며, 필드·프로퍼티·메서드·어노테이션·문서(가능한 경우)를 멤버로 포함한다 |

**`typeStubs` 각 객체의 프로퍼티 (전수, 인쇄 p.32–33)**

| 이름 | 타입 | 설명 |
|---|---|---|
| `name` | String | Apex 타입 스텁의 developer name |
| `namespacePrefix` | String | 타입의 네임스페이스. 네임스페이스가 없으면 `null` |
| `kind` | String | 타입 종류. 값: `CLASS` · `INTERFACE` · `ENUM` · `TRIGGER` |
| `modifiers` | String[] | 타입에 적용된 수정자 — 예: `public` · `global` · `virtual` · `abstract` |
| `annotations` | Object[] | 타입에 적용된 어노테이션 — 예: `AuraEnabled` · `IsTest` · `NamespaceAccessible` |
| `superClass` | Object | 상위 클래스의 타입 참조. 없으면 `null` |
| `interfaces` | Object[] | 타입이 구현한 인터페이스들의 타입 참조 |
| `fields` | Object[] | 타입에 선언된 필드. (필드 = 메서드 내부가 아니라 타입 수준에 선언된 변수) |
| `properties` | Object[] | 타입에 선언된 프로퍼티 |
| `methods` | Object[] | 타입에 선언된 메서드와 생성자 |
| `innerTypes` | Object[] | 타입 내부에 선언된 중첩 Apex 타입. 각 중첩 타입은 **최상위 타입 스텁과 동일한 구조**를 쓴다 |
| `triggerOperations` | String[] | 트리거의 경우 트리거 오퍼레이션(예: `BEFORE UPDATE`). 트리거가 아니면 `null` |
| `documentation` | String | 타입 문서. **내장 타입**은 공식 사용 지침을 포함할 수 있고, **커스텀 타입**은 ApexDoc 주석을 포함할 수 있다. **API 68.0에서는 관리 패키지의 ApexDoc 주석이 반환되지 않는다** |
| `triggerObjectType` | Object | 트리거의 경우 그 트리거가 정의된 sObject의 타입 참조. 트리거가 아니면 `null` |
| `compileError` | String | 해당 타입의 심볼 추출 중 컴파일 오류가 발생했으면 그 메시지, 아니면 `null` |

**`annotations` 배열 객체 (인쇄 p.33)**

| 이름 | 타입 | 설명 |
|---|---|---|
| `name` | String | 어노테이션 이름 |
| `parameters` | Object[] | 어노테이션 파라미터 |
| `documentation` | String | 어노테이션 문서(있는 경우) |

**어노테이션 `parameters` 배열 객체 (인쇄 p.33–34)**

| 이름 | 타입 | 설명 |
|---|---|---|
| `name` | String | 파라미터 이름 |
| `type` | Object | 파라미터 타입의 타입 참조 |
| `value` | String | 파라미터 값 |

**`fields` 배열 객체 (인쇄 p.34)**

| 이름 | 타입 | 설명 |
|---|---|---|
| `name` | String | 필드 이름 |
| `type` | Object | 필드 타입의 타입 참조 |
| `modifiers` | String[] | 필드 수정자 |
| `annotations` | Object[] | 필드 어노테이션 |
| `documentation` | String | 필드 문서(있는 경우) |
| `definingType` | Object | 이 필드를 **원래 선언한** Apex 타입의 타입 참조. **상속된 필드에만** 설정되며, 필드가 해당 타입에 직접 선언됐으면 생략된다 |

**`properties` 배열 객체 (인쇄 p.34)**

| 이름 | 타입 | 설명 |
|---|---|---|
| `name` | String | 프로퍼티 이름 |
| `type` | Object | 프로퍼티 타입의 타입 참조 |
| `modifiers` | String[] | 프로퍼티 수정자 |
| `annotations` | Object[] | 프로퍼티 어노테이션 |
| `getter` | Object | 프로퍼티에 `get` 접근자가 있으면 존재. 객체는 `modifiers` 배열과 `documentation` 프로퍼티를 포함 |
| `setter` | Object | 프로퍼티에 `set` 접근자가 있으면 존재. 객체는 `modifiers` 배열과 `documentation` 프로퍼티를 포함 |
| `documentation` | String | 프로퍼티 문서(있는 경우) |
| `definingType` | Object | 이 프로퍼티를 원래 선언한 Apex 타입의 타입 참조. 상속된 프로퍼티에만 설정 |

**`methods` 배열 객체 (인쇄 p.35)**

| 이름 | 타입 | 설명 |
|---|---|---|
| `name` | String | 메서드 또는 생성자 이름 |
| `isConstructor` | Boolean | 생성자면 `true`, 아니면 `null` |
| `returnType` | Object | 반환 타입의 타입 참조. **생성자면 `null`** |
| `modifiers` | String[] | 메서드 수정자 |
| `annotations` | Object[] | 메서드 어노테이션 |
| `parameters` | Object[] | 메서드 파라미터 |
| `documentation` | String | 메서드 문서(있는 경우) |
| `definingType` | Object | 이 메서드를 원래 선언한 Apex 타입의 타입 참조. 상속된 메서드에만 설정 |

**메서드 `parameters` 배열 객체 (인쇄 p.35)**

| 이름 | 타입 | 설명 |
|---|---|---|
| `name` | String | 파라미터 이름 |
| `type` | Object | 파라미터 타입의 타입 참조 |
| `annotations` | Object[] | 파라미터 어노테이션 |
| `documentation` | String | 파라미터 문서(있는 경우) |

**타입 참조(Type Reference) 구조 (인쇄 p.35–36)**

여러 응답 프로퍼티는 타입을 문자열로 반환하지 않고 **중첩된 타입 참조 객체**로 반환한다. 개발 도구가 소비할 수 있도록 타입을 부분으로 분리하기 위해서다. 타입 참조가 나타나는 위치:

- `superClass`
- `interfaces` 배열의 객체
- 필드 또는 프로퍼티의 `type`
- 메서드의 `returnType`
- 상속된 필드·메서드·프로퍼티의 `definingType`
- 파라미터의 `type`
- `triggerObjectType`

| 이름 | 타입 | 설명 |
|---|---|---|
| `namespacePrefix` | String | 참조 타입의 네임스페이스. 없으면 `null` |
| `name` | String | 참조 타입의 이름 |
| `typeParameters` | Object[] | 제네릭 타입 인자의 타입 참조 — 예: `List<String>`의 `String`. 타입이 파라미터화돼 있지 않으면 `null` |

**Usage — 이 API로 만들 수 있는 도구 (인쇄 p.36, 전수)**

- **제네릭 타입까지 온전한 코드 완성** — 예: `List<Account>`가 내부 인코딩이 아니라 읽을 수 있는 타입 파라미터로 표시된다.
- **내장 타입의 공식 문서 표시** — 사용 지침과 예제 포함.
- **커스텀 타입의 ApexDoc 주석 표시.**
- **생성자 시그니처 표시** — 파라미터 타입·어노테이션·수정자 포함.
- **트리거 오퍼레이션 식별** — 소스 코드를 파싱하지 않고 `before insert` · `after update` 등을 얻는다.
- **모든 표준 Apex 네임스페이스의 타입 정보 접근** — System · Database · Messaging 등.

**Considerations (인쇄 p.36)**

- **동시성 한도 = org당 요청 1건.** 요청이 진행 중일 때 같은 org에서 두 번째 요청을 하면 **두 번째 요청이 실패한다.** 같은 org에서 이 API를 병렬 호출하지 않는다.
- API 68.0에서는 **관리 패키지의 ApexDoc 주석이 반환되지 않는다.** global 식별자에 대한 패키지 ApexDoc은 이후 API 버전에 제공 예정.

**예제 — System 네임스페이스의 내장 `ApexPages` 타입 조회**

```text
// Winter27-v68-Docs/api_tooling.pdf v68.0 (인쇄 p.36) — Example Request 원문 발췌
GET
"https://MyDomain.my.salesforce.com/services/data/v68.0/tooling/symbols?category=builtin&namespace=System&name=ApexPages"
```

```json
// Winter27-v68-Docs/api_tooling.pdf v68.0 (인쇄 p.36–37) — Example Response Body (excerpt) 원문 발췌
{
  "typeStubs": [
    {
      "name": "ApexPages",
      "namespacePrefix": "System",
      "kind": "CLASS",
      "modifiers": [
        "global"
      ],
      "annotations": [],
      "superClass": null,
      "interfaces": [],
      "fields": [],
      "properties": [],
      "methods": [
        {
          "name": "addMessage",
          "isConstructor": null,
          "returnType": {
            "namespacePrefix": null,
            "name": "void",
            "typeParameters": null
          },
          "modifiers": [
            "global",
            "static"
          ],
          "annotations": [],
          "parameters": [
            {
              "name": "message",
              "type": {
                "namespacePrefix": "ApexPages",
                "name": "Message",
                "typeParameters": null
              },
              "annotations": [],
              "documentation": ""
            }
          ],
          "documentation": "Add a message to the current page context."
        }
      ],
      "innerTypes": [],
      "triggerOperations": null,
      "documentation": "Use ApexPages to add and check for messages associated...",
      "triggerObjectType": null,
      "compileError": null
    }
  ]
}
```

> 응답의 `documentation` 마지막 값이 `"Use ApexPages to add and check for messages associated..."` 로 끝나는 것은 **PDF 원문의 발췌 표기 그대로**다(생략 부호 포함). 임의로 완성하지 않는다.

### 3. SOQL 필드 간 비교 — `FORMULA()` (Beta)

**SOQL `WHERE` 절에서 산술 계산을 직접 수행**한다. 수식 필드를 추가하거나 후처리 로직을 붙이지 않고 **필드 간 값을 비교**할 수 있다.

- **Where:** Lightning Experience·Salesforce Classic의 Group · Professional · Enterprise · Performance · Unlimited · Developer · Database.com 에디션.
- **Beta 제공 범위 (중요):** 이 beta는 **샌드박스 · Developer Edition · 스크래치 org**에서 **API 버전 68.0 이상**으로 제공된다. **프로덕션 org에서는 제공되지 않는다.**
- 문법 정본: SOQL and SOSL Reference의 `FORMULA()`.

> 릴리즈 노트 페이지에는 `FORMULA()` 사용 예제 쿼리가 포함돼 있지 않았다. 문법 예시를 지어내지 않는다 — [[SOQL 문법 레퍼런스]]와 공식 레퍼런스를 함께 본다.

### 4. sObjects REST API OpenAPI 문서 생성 — 기타 개선 (Beta)

OpenAPI 명세 최신 버전으로 **모든 가용 리소스를 조회**하고 **URI에 와일드카드**를 쓸 수 있다.

- **Where:** **API 버전 64.0 이상**에 영향. API Enabled인 **모든** Salesforce 에디션·샌드박스·스크래치 org에서 제공되는 beta 기능.
- **개선 2건:**
  - `/async/specifications/oas3` 리소스가 포함돼 **유효한 리소스 전체 목록**을 반환한다.
  - **와일드카드 `*`** 로 URI 경로 세그먼트 **하나**를 매칭하거나, URI **끝에 쓰면 나머지 경로 전체**를 매칭한다.

### 5. Salesforce DX MCP Server and Tools (Beta)

LLM과 Salesforce org 간 상호작용을 위한 **Model Context Protocol(MCP) 구현**이다. IDE에서 자연어 프롬프트로 메타데이터 동기화 · Apex/에이전트 테스트 실행 · 스크래치 org 생성 같은 표준 DX 작업을 수행한다. 새 버전은 필요에 따라 릴리즈된다.

> **Beta 표기 위치 주의:** Winter '27 릴리즈 노트의 DX MCP Server 페이지 본문에는 beta 마커가 없고, 연결된 개발자 가이드 제목이 *Salesforce DX MCP Server and Tools (Beta)* 로 beta를 명시한다. 즉 **beta 판정 근거는 링크된 가이드 제목**이다. 위키 상세는 [[DX MCP Server (Beta)]] 참조.

---

## Developer Preview

### Apex Integration Tests — External Services · HTTP 콜아웃 (Developer Preview)

**mock 콜아웃 없이 실제 HTTP 엔드포인트를 호출하는 Apex 통합 테스트**를 작성한다. External Services 엔드포인트도 대상이다. 통합 테스트는 **콜아웃 제약과 트랜잭션 롤백 시맨틱을 완화**하므로, 스크래치 org에서 실제 서비스 상호작용을 검증하고 **실제 부수효과(side effects)에 대해 단언**할 수 있다. 새 `@BeforeClass` 어노테이션으로 **통합 테스트 클래스 내 메서드들이 공유하는 테스트 데이터**를 설정한다.

- **Where:** **스크래치 org**의 Lightning Experience·Salesforce Classic, **Developer 에디션**.
- **Important — Developer Preview 고지:** Salesforce가 문서·보도자료·공개 성명으로 GA를 발표하기 전까지 일반 제공이 아니다. 모든 명령·파라미터·기능은 **사전 통지 없이 변경·폐기될 수 있다.** **프로덕션에 구현하지 않는다.**
- **Why:** 이전에는 Apex 통합 테스트가 **Agentforce·Data 360 상호작용에만** 제공됐다. 이번 릴리즈부터 **Named Credentials로 구성된 External Services를 포함한 모든 엔드포인트**로 HTTP 콜아웃이 가능하다. 스크래치 org에서 실제 외부 시스템과 전체 요청-응답 사이클을 검증해, **직렬화 불일치 · 인증 실패 · 타임아웃 동작**처럼 mock이 드러낼 수 없는 문제를 잡는다.

**How — 절차 (릴리즈 노트 순서 그대로)**

1. 스크래치 org 정의 파일에서 `ApexIntegrationTests` feature를 활성화한다.

```json
// 릴리즈 노트 코드 블록 발췌 — help.salesforce.com rn_apex_integration_tests (Winter '27)
{
  "orgName": "My Company",
  "edition": "Developer",
  "features": ["ApexIntegrationTests"]
}
```

2. 통합 테스트 클래스를 작성할 때 **클래스와 각 테스트 메서드에 `@IntegrationTest` 어노테이션**을 단다.
3. 모든 메서드가 공유하는 테스트 데이터를 설정하려면 **`@BeforeClass`** 어노테이션을 쓴다.
4. 테스트 메서드 실행 중 커밋된 데이터를 정리하려면 **`@TearDown` 메서드**를 쓴다.
5. 통합 테스트를 실행하려면 Tooling API REST 리소스 `/services/data/vXX.X/tooling/runTestsAsynchronous/` 를 쓴다. **비동기 통합 테스트는 동시 1건만 실행할 수 있고, 통합 테스트의 동기 실행은 제공되지 않는다.**

- **Note:** `Test.setMock()`으로 mock이 등록돼 있으면 **mock이 실제 콜아웃보다 우선**한다. 실제 엔드포인트를 테스트하려면 mock을 제거한다. ([[HttpCalloutMock]] 패턴과의 관계가 여기서 뒤집힌다.)

> ⛔ **샘플 통합 테스트 클래스 코드는 이 노트에 없다.** 릴리즈 노트 페이지의 샘플 클래스(약 850자)는 엔드포인트 URL을 포함해 브라우저 안전 필터에 걸렸고(**우회하지 않음**), v68.0 Tooling API PDF에도 동일 샘플이 없다. **기억으로 재구성하지 않는다.** 코드가 필요하면 *Apex Developer Guide: Apex Integration Tests (Developer Preview)* 와 *BeforeClass Annotation (Developer Preview)* 문서를 직접 확인한다.

---

## Release Update (개발 영역)

> ⚠️ **강제 적용 시점(Complete Steps By / Enforced) 의 단일 정본은 [[Winter '27/Release Updates]] 다.** 이 절은 "개발자가 무엇을 고쳐야 하는가"만 다루고 **날짜는 반복하지 않는다.** 시점·테스트 런 절차는 반드시 그 노트를 본다.
> **예외 1건:** **"Salesforce Platform API 21.0–30.0 은퇴"** 는 그 노트에 대응 행이 없어 위임이 성립하지 않는다 → 시점·테스트 런을 아래 [#예외 — API 21.0–30.0 은퇴의 When·테스트 런은 이 노트에 기록한다](#예외--api-210300-은퇴의-when테스트-런은-이-노트에-기록한다) 절에 적었다.

| Release Update | 개발자 관점 영향 |
|---|---|
| **관리 패키지의 익명 Apex 실행 차단** (Block Apex Anonymous Code Execution from Managed Packages) | 관리 패키지 **세션 ID로 익명 Apex를 인증하는 경로를 차단**한다. 활성화되면 설치된 관리 패키지가 `UserInfo.getSessionId()`로 세션 ID를 얻어 익명 Apex를 실행할 수 없다. → 패키지 코드에서 익명 실행 의존을 제거해야 한다 ([[Anonymous Apex 실행]]) |
| **Salesforce Platform API 21.0–30.0 은퇴** | Bulk API `21.0`–`30.0`, SOAP API `21.0`–`30.0`, REST API `v21.0`–`v30.0` 이 지원·제공 중단된다. 요청은 **엔드포인트 비활성화 오류**로 실패한다. `/services/data/vXX.X/` 하위 **모든** REST API가 영향권 — Bulk · Connect REST · IoT REST · Lightning Platform REST · Metadata · Place Order REST · Reports and Dashboards REST · Tableau CRM REST · Tooling API. 에디션: Professional(API 접근 활성) · Enterprise · Performance · Unlimited · Developer, **샌드박스·스크래치 org 포함 모든 API-enabled org**. 사용 중인 구버전은 **API Total Usage 이벤트**로 식별한다 |
| **Instanced URL을 API 트래픽에서 갱신** | org로 향하는 API 트래픽이 org의 **My Domain 로그인 URL**을 쓰도록 보장한다. **Spring '27로 강제가 연기됐다** |
| **SOAP `login()` 에 Use Any API Auth 권한 필요** | 모든 사용자가 SOAP API `login()`으로 인증하려면 **"Use Any API Auth" 사용자 권한**이 있어야 한다. 권한이 없는 사용자는 인증할 수 없고 오류가 발생한다 |
| **SOAP API `login()` (v31.0–64.0) 은퇴** | SOAP API 버전 `31.0`–`64.0`의 `login()` 호출이 지원·제공 중단된다(대상 버전 34개 전수: 31.0–64.0). 애플리케이션은 **External Client Apps 기반 인증**으로 전환해야 한다. Release Updates에서 **테스트 런을 켜면 org의 SOAP `login()` 호출이 비활성화**되므로 영향 검증에 쓴다 ([[External Client App (외부 클라이언트 앱)]]) |
| **Setup Audit Trail 접근에 View Setup Audit Trail 권한** | 전용 **View Setup Audit Trail** 권한으로 Setup Audit Trail 접근을 통제한다. 더 넓은 **View Setup** 권한 없이도 부여할 수 있어 최소 권한 원칙에 부합한다. **기존 접근 권한은 자동 보존**되며, 새로 필요한 사용자에게는 프로파일 또는 권한 세트로 부여한다 ([[Setup Audit Trail (설정 감사 추적)]]) |

> **Tooling API 가이드의 현재형 서술 (참고):** v68.0 PDF는 `/executeAnonymous/` 리소스 설명에서 *"Salesforce blocks all /executeanonymous requests from components in managed packages."* 라고 **현재형으로** 기술하고 Release Update를 참조하도록 안내한다. (Winter27-v68-Docs/api_tooling.pdf v68.0 인쇄 p.4)

### 예외 — API 21.0–30.0 은퇴의 When·테스트 런은 이 노트에 기록한다

> ⚠️ **위임 예외.** 위 6건 중 **"Salesforce Platform API 21.0–30.0 은퇴"만은 [[Winter '27/Release Updates]]에 대응 행이 없다.** 시점을 그 노트로 위임하면 **정보가 어느 노트에도 남지 않으므로**, 이 항목에 한해 When과 테스트 런 절차를 여기에 적는다. 나머지 5건의 시점은 그 노트가 정본이다.

- **When (소스 `rn_api_retirement_delay_256rn`):** 21.0–30.0 은퇴는 **처음 Summer '23으로 예정**됐다가 **Summer '25로 연기**됐다. 해당 버전들은 **Summer '25부터 지원되지 않고 사용할 수 없으며**, 이를 소비하는 애플리케이션은 중단되고 요청은 **엔드포인트가 비활성화됐다는 오류 메시지**와 함께 실패한다.
- **How (선행 조치):** Summer '25 릴리즈 **이전에** 모든 애플리케이션을 현행 API 버전으로 수정·업그레이드한다. 구버전 SOAP·REST·Bulk API 요청은 **API Total Usage 이벤트**로 식별한다.
- **테스트 런 (은퇴를 미리 강제해 영향 검증):** Summer '25 이전에 은퇴를 앞당겨 적용해볼 수 있다.

```text
// 구조 예시 — 실제 동작 코드 아님 (릴리즈 노트 rn_api_retirement_delay_256rn의 Setup 탐색 경로)
Setup → Release Updates
  → "Salesforce Platform API Versions 21.0 Through 30.0 Retirement"
  → Get Started
      → Enable Test Run    // 은퇴 예정 API 버전으로의 호출을 거부한다
      → Disable Test Run   // 강제를 해제한다
```

> 위 [[Winter '27/Release Updates]] 위임 규칙은 그대로 유지된다 — **이 절은 그 노트에 행이 생기기 전까지의 단일 보관처**다. 그 노트에 행이 추가되면 여기 내용과 대조해 정본을 일원화한다.

---

## Apex — 본문 신기능

### Apex heap 한도 인상 (동기 10 MB · 비동기 25 MB)

더 큰 데이터셋을 다루고 더 복잡한 연산을 heap 제약 없이 수행한다. heap 한도 인상은 비즈니스 프로세스를 중단시키는 런타임 한도 오류 가능성을 줄인다.

| 트랜잭션 유형 | 이전 | Winter '27 |
|---|---|---|
| **동기(synchronous)** | 6 MB | **10 MB** |
| **비동기(asynchronous)** | 12 MB | **25 MB** |

- **Where:** Lightning Experience·Salesforce Classic에서 **커스텀 Apex 또는 관리형 Apex를 실행하는 모든 에디션**.
- **When:** Winter '27 릴리즈 일정에 따라 **모든 org에서 자동 활성화**된다. 인스턴스의 메이저 릴리즈 업그레이드 날짜는 Trust Status에서 인스턴스를 검색해 maintenance 탭에서 확인한다.
- **How — org의 현재 heap 한도 확인:**

```apex
// 릴리즈 노트 코드 블록 발췌 — help.salesforce.com rn_apex_heap_limit (Winter '27)
Limits.getLimitHeapSize()
```

- **하위 호환 안전장치 (기간 한정):** Winter '27 비프로덕션 org에서 만든 기능을 **Summer '26 프로덕션 org**에 배포할 계획이라면, 비프로덕션 org를 구 heap 한도로 임시 제한할 수 있다. 샌드박스 · Developer Edition · 스크래치 org에서 Setup → Quick Find `Apex Settings` → **"Enforce the Summer '26 Apex heap limit"** 를 켠다. 이 설정을 켜면 비프로덕션 org가 **낮은 heap 한도**를 사용하므로 Summer '26 프로덕션 환경에서 트랜잭션이 성공하는지 검증할 수 있다.
- **Important:** 이 설정은 **Winter '27 비프로덕션 org에서만** 제공된다. **Spring '27에는 설정 상태와 무관하게 높은 heap 한도가 전역 강제**된다.

> 관련: [[Governor Limits]] · [[실행 컨텍스트와 트랜잭션]]

### 비프로덕션 org에서 비동기 Apex 잡 한도 override (Elastic Limits 테스트)

> **분류 근거:** 소스(`rn_apex_elastic_limits_test_nonprod`)의 제목은 *Test Elastic Limits by Overriding the Asynchronous Apex Job Limit in Nonproduction Orgs* 로 **`(Beta)` 표기가 없고 beta 법적 고지도 붙어 있지 않다.** 즉 이 항목 자체는 beta가 아니라, **Beta인 [#1. Batch 잡 Elastic Limits (Beta)](#1-batch-잡-elastic-limits-beta)를 시험하기 위한 일반 기능**이다. 그래서 Beta 절이 아니라 이곳에 둔다.

탄력 처리(elastic processing) 상황에서 비동기 Apex 잡이 어떻게 동작하는지 **시험하기 위해** 표준 24시간 롤링 비동기 Apex 잡 한도를 비프로덕션 org에서 낮게 override한다. **override 값이 낮을수록 탄력 처리가 더 빨리 촉발된다.**

- **Where:** Enterprise · Performance · Unlimited · Developer 에디션의 Lightning Experience·Salesforce Classic. override는 **비프로덕션 org(샌드박스·Developer Edition·스크래치 org)에만** 적용된다.
- **Why:** 이전에는 elastic limits가 **프로덕션·데모 org에서만** 제공돼, org의 표준 24시간 롤링 한도를 실제로 초과하지 않고서는 동작을 테스트하기 어려웠다.
- **How:** 비프로덕션 org의 Setup → Apex Settings에서 *"Use elastic limits for asynchronous Apex jobs (beta)"* 를 켜고, *"Asynchronous Apex job limit override for nonproduction orgs"* 를 표준 한도보다 낮은 값으로 설정한다. 비우면 표준 한도가 그대로 적용된다. **Metadata API `ApexSettings` 타입의 `asyncApexExecutionsOverride` 필드**로도 구성할 수 있다.
- **Note (중요한 비대칭):** 비프로덕션 org에서 **override 값은 elastic limits 설정의 on/off와 무관하게 적용된다.** 설정이 켜져 있으면 elastic 한도는 **"override 값의 2배" 또는 "org의 라이선스된 표준 한도" 중 더 낮은 값**이다. 즉 탄력 동작을 관찰하려면 **설정 ON + override < 라이선스 표준 한도** 둘 다 필요하다.
- **소스 예시:** 표준 한도 250,000 잡 / override 250 잡 → elastic 한도 **500 잡**. override를 비우면 한도는 250,000으로 유지돼 탄력 동작이 아니라 **표준 한도 예외**가 발생한다.

> 관련: [[Batch Apex]] · [[Queueable]] · [[Governor Limits]]

### Test Discovery API — `testLevel` 파라미터

Test Discovery API의 **`testLevel` 쿼리 파라미터**로 반환할 테스트 메서드를 테스트 레벨 기준으로 필터한다. `testLevel`은 **API 버전 68.0 이상에서 `showAllMethods`를 대체**하며, 폐기된 `showAllMethods`는 **API 버전 67.0 이하에서만** 사용할 수 있다.

- **Where:** 파라미터는 API 버전 68.0 이상에서 제공. Test Discovery API 자체는 Lightning Experience·Salesforce Classic의 Enterprise · Performance · Unlimited · Developer 에디션.
- **Why:** Test Runner API의 **요청 본문 `testLevel` 파라미터와 정렬**하기 위해서다.
- **값:**

| 값 | 반환 대상 |
|---|---|
| `RunAllTestsInOrg` | org의 **모든** 테스트 — 네임스페이스 무관. **설치된 관리 패키지의 테스트 포함** (파라미터 미지정 시 **기본값**) |
| `RunLocalTests` | org 네임스페이스의 테스트 **+ flow 테스트**. 설치된 관리 패키지의 테스트 **제외** |

- **How:** `/services/data/v68.0/tooling/tests` 에 GET 요청을 보내고 `testLevel`을 쿼리 파라미터로 지정한다.

```text
// 릴리즈 노트 코드 블록 발췌 — help.salesforce.com rn_apex_discovery_api_testlevel (Winter '27)
// org 네임스페이스 + FlowTesting 네임스페이스의 유닛 테스트 조회 (설치된 관리 패키지 테스트 제외)
/services/data/v68.0/tooling/tests?testLevel=RunLocalTests
```

**보조 소스 — 같은 리소스의 나머지 쿼리 파라미터** (Winter27-v68-Docs/api_tooling.pdf v68.0 인쇄 p.6–7). 릴리즈 노트는 `testLevel`만 다루지만, 실제 호출에는 아래 파라미터가 함께 쓰인다.

| 파라미터 | 타입 | 설명 |
|---|---|---|
| `category` | Enum(String) | 테스트 카테고리 필터(**API 66.0 이상**). `apex` = Apex 테스트 클래스만, `flow` = 자동화 flow 테스트 클래스만. 한 호출에 복수 카테고리 지정 불가. 미지정 시 모든 카테고리 |
| `testLevel` | Enum(String) | 위 표 참조(**API 68.0 이상**, `showAllMethods` 대체) |
| `showAllMethods` | Boolean | **Deprecated.** API 67.0 이하 전용. 기본값 `false`. 결과는 표준 Apex 가시성 규칙을 따른다 |
| `namespacePrefix` | String | 테스트를 가져올 네임스페이스. 미지정 시 모든 네임스페이스. 자동화 flow 테스트는 모두 `FlowTesting` 네임스페이스에 있고, 네임스페이스 패키지·org에서는 전체 네임스페이스가 `FlowTesting.namespacePrefix` 다 |
| `nextRecord` | String | 다음 페이지의 첫 테스트 클래스를 지정하는 커서. 현재 페이지 응답의 `nextRecordUrl` 프로퍼티에 포함된다 |
| `pageSize` | Integer | 페이지당 테스트 클래스 수. **기본 1,000 · 최대 10,000** |

> 응답 인코딩 주의(PDF 인쇄 p.6): 이 리소스는 요청 헤더 **`X-Chatter-Entity-Encoding: false`** 를 설정해 클라이언트가 raw(인코딩되지 않은) 출력을 요청해야 한다.
> 관련: [[테스트 전략]] · [[Flowtesting Namespace]] · [[Tooling API 객체 — Apex 코드·테스트·커버리지]]

### 관리 패키지 SOQL의 필드명 충돌 해결 — `explicitNamespace`

패키지 필드와 구독자(subscriber)의 커스텀 필드가 **같은 이름**일 때 관리형 Apex SOQL 쿼리에서 발생하는 **중복 필드명 오류**를 막는다. `Database.QueryOptions` 객체의 **`explicitNamespace` 프로퍼티**를 설정하고, 이를 **SOQL `SET OPTIONS` 절의 바인드 변수**로 전달한다.

- **Where:** Lightning Experience·Salesforce Classic의 Enterprise · Performance · Unlimited · Developer 에디션.
- **문제 상황 (릴리즈 노트가 든 예):** 네임스페이스가 `ExPackageNS`인 관리 패키지에 `Age__c` 필드가 있고 구독자가 커스텀 필드 `Age__c`를 만들면, 두 필드를 동시에 쿼리할 때 **중복 필드명 오류**가 났다. 관리형 Apex 코드가 **구독자 필드만** 쿼리할 수단도 없었다. 명시적 네임스페이스가 없으면 Apex는 **두 필드 모두 패키지 네임스페이스 소속으로 해석**해, **API 버전 34.0 이상에서 강제되는 고유 필드명 요구**를 위반한다.
- **해결:** `explicitNamespace`를 쿼리 옵션으로 설정하면 패키지 필드가 **`ExPackageNS__Age__c`** 로 해석된다.
- **하위 호환:** `SET OPTIONS` 절이 없는 쿼리는 **기존 동작이 그대로 유지**된다.
- **How:** `Database.QueryOptions` 객체를 빌더 메서드로 만들되 **`.withExplicitNamespace(true)`** 를 포함한다. 그 객체를 `SET OPTIONS` 절의 바인드 변수로 전달한 뒤 쿼리를 `Database.query()` 또는 `Database.queryWithBinds()` 에 넘긴다.

**이 페이지에서 참조되는 API 표면 (전수):** `explicitNamespace` · `Database.QueryOptions` · `SET OPTIONS` · `.withExplicitNamespace(true)` · `Database.query()` · `Database.queryWithBinds()` · `ExPackageNS__Age__c`

> ⛔ **동적 SOQL 샘플 코드 2건은 이 노트에 없다.** 릴리즈 노트 페이지의 두 코드 블록(각각 `Database.query()` 용 246자, `Database.queryWithBinds()` 용 299자)이 브라우저 안전 필터에 걸려 확보되지 않았고(**우회하지 않음**), v68.0 Tooling API PDF에도 대응 샘플이 없다. **기억으로 재구성하지 않는다.** 코드는 *Apex Developer Guide: Prevent Field Name Collisions in Managed SOQL Queries*, *Apex Reference Guide: Database.QueryOptions Class*, *SOQL and SOSL Reference: SOQL SET OPTIONS Clause* 를 직접 확인한다.
> 관련: [[Dynamic SOQL]] · [[Database Namespace 상세]] · [[2GP Managed Package 개념과 1GP 비교]]

### 무효 Apex 클래스·트리거만 재컴파일 — `/tooling/apexCompileResults`

org 전체를 재컴파일하는 대신, **검증 오류가 있는 Apex 클래스·트리거의 컴파일 결과만** 반환한다. 결과는 **Setup 또는 Tooling API 엔드포인트**로 접근한다. Salesforce가 **재컴파일이 필요한 클래스·트리거만 자동 식별**하므로 컴파일 오버헤드가 줄고 잠재적 런타임 오류가 최소화된다.

- **Where:** **API 버전 68.0 이상**, Lightning Experience·Salesforce Classic의 Enterprise · Performance · Unlimited · Developer 에디션.
- **필요 권한 (PDF 기준):** **Author Apex** org 권한.
- **요청:** `/services/data/vXX.X/tooling/apexCompileResults` 에 **POST**. **요청 본문은 빈 JSON 객체 `{}` 여야 하며, 필드를 지정하면 오류**가 반환된다. 요청은 **동기(synchronous)** 다.

```text
// 릴리즈 노트 코드 블록 발췌 — help.salesforce.com rn_apex_recompile_invalid_apex (Winter '27)
POST /services/data/v68.0/tooling/apexCompileResults HTTP/1.1
Authorization: Bearer <session-id>
Content-Type: application/json

{}
```

**응답 본문 프로퍼티** (Winter27-v68-Docs/api_tooling.pdf v68.0 인쇄 p.29 — 전수)

| 이름 | 타입 | 설명 |
|---|---|---|
| `status` | String | 컴파일의 **오퍼레이션 수준 결과**. `OK` — 무효 클래스·트리거가 모두 성공적으로 컴파일됐거나 재컴파일이 필요한 항목이 없음 / `PARTIAL_FAILURE` — 무효 클래스·트리거 중 **최소 1건**이 컴파일 실패 |
| `results` | Object[] | **컴파일에 실패한** 클래스·트리거의 결과 배열. 각 객체는 이름·네임스페이스·성공 여부·오류·경고를 포함한다. **성공적으로 컴파일된 항목은 포함되지 않는다.** 경고는 **해당 클래스·트리거에 컴파일 오류도 있을 때만** 포함된다. 전체 컴파일이 실패 없이 끝나면 이 배열은 비어 있다 |

**`results` 배열 각 객체** (인쇄 p.29–30)

| 이름 | 타입 | 설명 |
|---|---|---|
| `name` | String | Apex 클래스·트리거의 developer name |
| `namespace` | String | 클래스·트리거의 네임스페이스. **기본 네임스페이스면 빈 문자열** |
| `success` | Boolean | 컴파일 성공 여부. 컴파일 문제가 없으면 `true`, 문제가 **1건 이상**이면 `false`. **경고만 있는 결과는 성공으로 간주**되어 `results` 배열에 반환되지 않는다 — ⚠️ **이 규칙은 릴리즈 노트 예제와 충돌한다. 아래 "충돌 2" 참조** |
| `problems` | Object[] | 컴파일 오류 배열. `success`가 `true`면 비어 있다 |
| `warnings` | Object[] | 컴파일 경고 배열. **컴파일 오류도 함께 있는 클래스·트리거에 대해서만** 반환된다 — ⚠️ 릴리즈 노트 예제는 **오류 없이 경고만 있는 항목**에도 `warnings` 를 채워 반환한다(아래 "충돌 2") |

**`problems` / `warnings` 배열 각 객체** (인쇄 p.30)

| 이름 | 타입 | 설명 |
|---|---|---|
| `line` | Integer | 오류·경고의 소스 라인. 라인이 해당 없으면 `0` |
| `column` | Integer | 오류·경고의 소스 컬럼. 컬럼이 해당 없으면 `0` |
| `message` | String | 컴파일 오류·경고 설명 |

```json
// Winter27-v68-Docs/api_tooling.pdf v68.0 (인쇄 p.30) — Example Response Body on Successful Compilation 원문 발췌
{
  "status": "OK",
  "results": []
}
```

```json
// Winter27-v68-Docs/api_tooling.pdf v68.0 (인쇄 p.31) — Example Response Body on Partial Failure 원문 발췌
{
  "status": "PARTIAL_FAILURE",
  "results": [
    {
      "name": "MyInvalidClass",
      "namespace": "MyNamespace",
      "success": false,
      "problems": [
        {
          "line": 14,
          "column": 9,
          "message": "Variable does not exist: var1"
        }
      ],
      "warnings": [
        {
          "line": 0,
          "column": 0,
          "message": "Apex API version 18.0 is scheduled for retirement. Update to the latest API version to avoid compile failures."
        }
      ]
    }
  ]
}
```

- **Setup 경로:** Quick Find → **Apex Classes** 또는 **Apex Triggers** → **"Compile only invalid classes"** / **"Compile only invalid triggers"** 버튼. 성공하면 확인 메시지가, 실패하면 영향받는 클래스·트리거별 오류·경고 목록이 표시된다.

> ⚠️ **두 Tier 2 소스가 충돌한다 (원문 그대로 기록).**
> - **릴리즈 노트(help.salesforce.com `rn_apex_recompile_invalid_apex`):** *"Compile only invalid classes/triggers" 버튼 **또는** `/apexCompileResults` 엔드포인트로 컴파일에 성공해도 해당 Apex 클래스·트리거의 `isValid` 필드는 갱신되지 않으며 값이 `false`로 남는다.*
> - **Winter27-v68-Docs/api_tooling.pdf v68.0 (인쇄 p.30):** *"Successful compilation via the Setup buttons updates the `IsValid` field on the corresponding Apex class or trigger to `true`. Retrieving compilation results via `apexCompileResults` doesn't update the field."* (= **Setup 버튼은 `IsValid`를 `true`로 갱신**, API 조회는 갱신하지 않음)
>
> 두 소스가 **Setup 버튼의 `IsValid` 갱신 여부**에서 정반대다. **API 조회가 필드를 갱신하지 않는다는 점만 양측이 일치**한다. 어느 쪽이 최종인지 임의 판단하지 않고 그대로 남긴다 — 10월 GA 시점에 재확인 대상.

> ⚠️ **충돌 2 — "경고만 있는 결과"가 `results` 에 반환되는가 (원문 그대로 기록).**
> - **Winter27-v68-Docs/api_tooling.pdf v68.0 (인쇄 p.29–30, 위 표의 규칙):** `results` 는 **컴파일에 실패한** 클래스·트리거만 담고 **성공한 항목은 포함되지 않는다.** `success` 는 문제가 없으면 `true`, 즉 **경고만 있는 결과는 성공으로 간주**되며, `warnings` 는 **컴파일 오류가 함께 있는 클래스·트리거에 대해서만** 반환된다.
> - **릴리즈 노트(help.salesforce.com `rn_apex_recompile_invalid_apex`)의 예제 응답:** 같은 `PARTIAL_FAILURE` 응답에 결과가 **2건** 들어 있고, 그중 하나가 **`"success": true` · `"problems": []` · `warnings` 만 채워진 항목**이다 — 즉 **경고만 있는 결과가 `results` 에 그대로 반환된다.**
>
> 두 소스는 **경고만 있는 결과의 반환 여부**에서 정면 충돌한다. 릴리즈 노트 예제를 아래에 원문 그대로 옮긴다 — 어느 쪽이 최종인지 임의 판단하지 않는다(10월 GA 시점 재확인 대상).

```json
// 릴리즈 노트 코드 블록 발췌 — help.salesforce.com rn_apex_recompile_invalid_apex (Winter '27)
// ⚠️ 위 PDF 규칙과 충돌하는 지점: 두 번째 결과는 success=true / problems=[] 인데도 results 배열에 있다.
{
  "status": "PARTIAL_FAILURE",
  "results": [
    { "name": "MyInvalidClass", "namespace": "MyNamespace", "success": false,
      "problems": [ { "line": 14, "column": 9, "message": "Variable does not exist: var1" } ],
      "warnings": [] },
    { "name": "MyClassWithWarnings", "namespace": "OtherNamespace", "success": true,
      "problems": [],
      "warnings": [ { "line": 0, "column": 0, "message": "Apex API version 16.0 is scheduled for retirement. Update to the latest API version to avoid compile failures" } ] }
  ]
}
```

> 참고로 두 소스는 **같은 시나리오의 예제 값도 다르다** — PDF 예제의 경고 메시지는 *"Apex API version 18.0 …"* 이고 릴리즈 노트 예제는 *"Apex API version 16.0 …"* 이다(둘 다 원문 그대로). 버전 숫자는 예시일 뿐이지만, 두 예제가 **동일 응답의 서로 다른 판본**임을 보여준다.

### API 버전 9.0–19.0 Apex에 컴파일러 경고

**API 버전 9.0–19.0으로 저장된 Apex 클래스·트리거는 향후 릴리즈에서 은퇴 예정**이다. 이제 해당 API 버전으로 컴파일·배포하면 Apex 컴파일러가 경고한다. **API 버전 20.0 이상으로 업데이트**해야 한다.

- **Where:** Apex API 버전 9.0–19.0, Lightning Experience·Salesforce Classic의 Enterprise · Performance · Unlimited · Developer 에디션. 경고는 컴파일러 출력을 노출하는 개발 도구 — **Setup · Salesforce CLI · Salesforce Extensions for VS Code · Web Console · Tooling API** — 에 표시된다.
- **경고 메시지:** *"Apex API version {XX} is scheduled for retirement. Update to the latest API version to avoid compile failures."*
- **⚠️ 적용 범위(오해 주의):** 이 은퇴는 **Apex 클래스·트리거의 메타데이터 버전에만** 적용된다. **Visualforce 페이지 버전 · Flow 버전 · Process Builder 버전에는 적용되지 않는다.** **커스텀 Apex REST·SOAP 웹서비스 엔드포인트 버전에도 적용되지 않는다.** 또한 이 은퇴는 **Salesforce Platform API 은퇴와는 무관**하다(위 Release Update의 API 21.0–30.0 은퇴와 별개 사안).
- **조치:** 식별된 클래스·트리거를 **Apex API 버전 20.0 이상**(가능하면 최신)으로 올리고, 업데이트 후 코드를 충분히 테스트한다. 각 메이저 버전의 이전 릴리즈 노트와 Apex Developer Guide의 *Apex Versioned Behavior Changes* 로 버전별 주요 동작 변경을 검토한 뒤 표준 배포 프로세스로 배포한다.
- **관리 패키지 주의:** org에 API 9.0–19.0의 관리형 Apex가 있으면 컴파일 시 그 클래스·트리거에도 경고가 나타난다. 그러나 **구독자는 관리 패키지 소스를 수정할 수 없다.** 패키지 개발사가 **API 20.0 이상 Apex를 포함한 새 패키지 버전을 릴리즈**해야 하며, 폐기 버전에 의존한다면 패키지 개발사에 연락한다.

> 관련: [[Apex 버전별 동작 변경 레퍼런스]]

---

## LWC · Aura — 본문 신기능

### LWC API 버전 68.0 — **버전별 변경 없음**

컴포넌트의 API 버전을 올리면 새 기능·개선을 사용할 수 있다. 버전 관리(versioning)는 Salesforce가 기존 동작을 바꾸는 새 기능·버그 수정·성능 개선을 배포할 때 **기존 컴포넌트가 영향받지 않도록** 보장하고, 레거시 기능 폐기를 돕는다.

```xml
<!-- 릴리즈 노트 코드 블록 발췌 — help.salesforce.com rn_lwc_versioning (Winter '27) -->
<?xml version="1.0" encoding="UTF-8"?>
<LightningComponentBundle xmlns="http://soap.sforce.com/2006/04/metadata">
  <apiVersion>68.0</apiVersion>
</LightningComponentBundle>
```

- **Where:** Lightning Experience · Experience Builder 사이트 · 모든 버전의 Salesforce 모바일 앱의 커스텀 Lightning 웹 컴포넌트.
- **Important:** 컴포넌트 API 버전은 **한 번에 한 버전씩** 올린다(예: 58.0 → 59.0에서 오류·경고를 고치고, 다시 다음 버전). 최신 버전에 도달할 때까지 반복한다.
- **프레임워크 버전과의 관계:** 컴포넌트의 LWC API 버전이 **59.0 이상**이면 그 값이 **LWC 프레임워크 버전으로 사용**된다. **58.0 이하**를 지정한 컴포넌트는 **Summer '23(API 58.0) 시점의 LWC 프레임워크 동작**으로 계속 작동한다. 낮은 API 버전을 유지하면 이후 버전에서만 제공되는 새 기능·버그 수정·개선을 받지 못한다.

> ✅ **핵심 사실 1 — LWC API 68.0에는 버전별 변경(version-specific changes)이 없다.** 릴리즈 노트가 이를 명시하며, 그래서 **기존 컴포넌트를 현재 API 버전으로 일괄 업그레이드하기 좋은 릴리즈**라고 안내한다. (Winter '26의 LWC API 65.0도 동일한 성격이었다 — [[Winter '26/Development]] 참조.)
> 관련: [[LWC API 버전 관리]]

### Lightning 콘솔 앱의 네비게이션 아이템 제어 — `lightning/platformNavigationItemApi`

**새 모듈 `lightning/platformNavigationItemApi`** 가 Lightning 콘솔 앱 **아이템 메뉴의 네비게이션 아이템**을 관리하는 메서드를 제공한다.

- **Where:** Enterprise · Performance · Unlimited · Developer 에디션의 **Lightning 콘솔 앱**.
- **Why:** 이 Navigation Item API 메서드들은 **Aura 컴포넌트 `lightning:navigationItemAPI`의 현대적 대안**이다.
- **How:** 모듈을 import해 메서드에 접근한다. 이 LWC용 API 메서드는 Lightning 콘솔 앱에서 제공된다. **모든 메서드는 Promise를 반환한다.**

| 메서드 | 동작 |
|---|---|
| `focusNavigationItem()` | 선택된 네비게이션 오브젝트에 포커스하고 그 오브젝트의 홈 페이지(보통 리스트 뷰)를 연다 |
| `getNavigationItems()` | 아이템 메뉴에서 사용 가능한 **모든** 네비게이션 아이템 정보를 반환한다 |
| `getSelectedNavigationItem()` | 현재 선택된 네비게이션 아이템 정보를 반환한다 |
| `setSelectedNavigationItem(developerName)` | developer name(API 이름)으로 네비게이션 아이템을 선택한다 — 예: `'standard-Account'` |
| `refreshNavigationItem()` | 현재 선택된 네비게이션 오브젝트의 홈 페이지 또는 split view를 새로 고친다 |

> 관련: [[Lightning Console JS API]] · [[Service Console (서비스 콘솔)]]

### State Manager 데이터 새로 고침 — `refresh()`

내장 state manager에서 **`refresh()` 액션**을 호출해 서버에서 최신 데이터를 가져온다. 관련 리스트 레코드처럼 **list·query 형태 데이터를 노출하는 state manager**를, state manager를 재구성하거나 페이지를 다시 로드하지 않고 갱신한다.

- **Where:** Lightning Experience — 전 에디션.
- **How:** state manager 인스턴스의 **status가 `loaded`일 때** `refresh()`를 호출한다. 이 액션은 **`Promise<void>`** 를 반환하며, state manager의 **`data` 프로퍼티가 갱신된 데이터를 담은 뒤에 resolve**된다. 상세는 Lightning Web Components Developer Guide의 *Refresh Action* 참조.

### LWC Skills — Agentforce Vibes

Agentforce Vibes에 **LWC 라이프사이클 전반을 안내하는 skills**가 포함된다. 접근성 · 데이터 · 디자인 · 개발 · 문서화 · 마이그레이션 · 테스트 · 보안 · 품질 리뷰를 다루며, **작업 내용이 일치하면 각 skill이 자동 적용**된다.

- **Where:** Developer · Enterprise · Partner Developer · Performance · Unlimited 에디션의 Lightning Experience. skill은 **`forcedotcom/sf-skills` GitHub 리포지토리**로 제공되며 **Agentforce Vibes와 Claude Code를 포함해 agent skills를 지원하는 AI 도구**에서 동작한다.
- **When:** **2026년 8월 17일 주**부터 제공.
- **How:** Agentforce Vibes 패널을 열고 자연어 프롬프트를 입력한다. 아래는 각 skill을 자동 로드시키는 **예시 프롬프트**다(조건이 아니라 예시).

| 분류 | Skill | 예시 프롬프트 |
|---|---|---|
| 컴포넌트 빌드·생성 | `experience-lwc-generate` | "Build a Lightning web component that displays a list of contacts." |
| | `experience-lwc-design-generate` | "Build a new Lightning web component from this Figma design." |
| | `experience-lwc-base-components-integrate` | "Which base component can I use to display a table for data?" |
| | `experience-lwc-typescript-migrate` | "Convert this LWC code to TypeScript and generate a .d.ts for its `@api` surface." |
| 데이터 관리 | `experience-lds-best-practices-apply` | "My component shows stale data after save. Should I use UI API or Apex, and how do I use refreshApex?" |
| | `experience-lds-graphql-generate` | "How do I use GraphQL query to update account records?" |
| | `experience-lds-data-requirements-generate` | "I need to show account data in this component. Turn that into a spec with the right object/field API names." |
| 컴포넌트 마이그레이션 | `experience-aura-lwc-migrate` | "Migrate this Aura component bundle to LWC. Convert the .cmp, controller, and helper, and map aura facets to slots." |
| 품질 리뷰 | `experience-lwc-accessibility-validate` | "Review this component for WCAG 2.2 accessibility issues." |
| | `experience-lwc-rtl-validate` | "Review this component for RTL correctness." |
| | `experience-lwc-runtime-observe` | "Preview this component locally." |
| | `experience-lwc-security-validate` | "Audit this component for Lightning Web Security violations and score its security compliance." |

> 관련: [[Aura → LWC 마이그레이션]] · [[스킬 ↔ 위키 토픽 맵]]

---

## API — 본문 신기능

### REST API 버전 관리 단순화 — `latest`

REST API URI에서 숫자 버전 대신 **`latest`** 를 쓴다. 요청은 **org가 지원하는 가장 최신 REST API 버전**으로 라우팅되며, 그 버전은 *List Available REST API Versions* 리소스 응답에 표시된다.

- **Where:** Lightning Experience·Salesforce Classic의 **API Enabled Group** · Professional · Enterprise · Performance · Unlimited · Developer · Database.com 에디션.

```text
// 릴리즈 노트 코드 블록 발췌 — help.salesforce.com rn_api_rest_latest (Winter '27)
https://<MyDomainName>.my.salesforce.com/services/data/latest/sobjects/Account
```

> 관련: [[REST API]]

### Streaming API — replay watermark 강화

**API 버전 68.0부터** Streaming API 서버가 성공한 모든 `/meta/connect` 응답에 **채널별 replay watermark를 `ext.replay`로 방출**한다. 클라이언트는 이 watermark로 **이벤트가 배달되기를 기다리지 않고** 재구독 시점의 replay ID를 갱신할 수 있어, 오래된 이벤트를 다시 처리할 필요가 없어지고 동기화가 빨라진다.

> 관련: [[Streaming API (CometD·PushTopic·Generic Streaming)]]

### Composite API 요청 모니터링 — EventLogFile 이벤트 타입

**`EventLogFile` 오브젝트를 `CompositeApi` · `CompositeApiSubrequest` 이벤트 타입으로 쿼리**해 composite API·composite graph API 요청과 하위 요청(subrequest) 상세를 얻는다.

- **Where:** **API 버전 64.0 이상**에 영향. **API Enabled인 모든** Salesforce 에디션·샌드박스·스크래치 org.

> 관련: [[Event Monitoring & 보안 감사 (EventLogFile · Real-Time Event Monitoring)]]

### Bulk API 2.0 — 마케팅 오브젝트·동의 데이터 대량 인제스트

Bulk API 2.0용 **새 마케팅 오브젝트**가 추가된다. 마케팅 오브젝트는 **insert · upsert** 오퍼레이션과 **마케팅 오브젝트 전용 신규 `refresh` 오퍼레이션**을 지원한다. **`refresh`는 대상 데이터 세트의 데이터를 전부 교체**한다.

- **Where:** Lightning Experience·Salesforce Classic의 Enterprise · Performance · Unlimited 에디션.
- **Who:** 마케팅 오브젝트 인제스트에는 **Marketing Cloud(Marketing on Core) 라이선스**가 필요하다.

> 관련: [[Bulk API 2.0]]

### GraphQL API

**① 게스트 사용자 접근 제어 (org 단위)**

- 신규 org, 그리고 **2026년 3월 이후 게스트 사용자 GraphQL 접근이 없던 org**에서는 게스트 사용자 접근이 **기본 OFF**다.
- **2026년 3월 이후 게스트 사용자 GraphQL 접근이 있던 기존 org**는 접근이 **활성 상태로 유지**되어 현재 동작이 바뀌지 않는다.
- 관리자는 Setup → Quick Find **`API Access Controls`** 에서 게스트 사용자 접근을 변경한다.
- OFF인 org에서는 게스트 사용자가 GraphQL API 엔드포인트에 접근할 수 없고 요청 시 오류를 받는다. ON인 org에서는 GraphQL API가 게스트 사용자의 **오브젝트 수준·필드 수준 권한을 동일하게 준수**한다.
- 대응 Metadata API 필드: `SecuritySettings.enableGraphQLApiGuestUserAccess`.

**② lookup 값 조회 — `lookupValues`**

Salesforce lookup·관계 필드에 대한 **lookup 검색**을 제공한다. **type-ahead 검색 · 최근 사용(mru) lookup · 전체 검색**을 지원한다.

```graphql
// 릴리즈 노트 코드 블록 발췌 — help.salesforce.com rn_api_graphql (Winter '27) — 스키마
type UIAPI {
  lookupValues(
    objectApiName: String!
    fieldApiName: String!
    q: String
    searchType: LookupSearchType
    targetApiName: String
    sourceRecord: RecordSnapshotInput
  ): [LookupValues!]
}
```

```graphql
// 릴리즈 노트 코드 블록 발췌 — help.salesforce.com rn_api_graphql (Winter '27)
// Opportunity 오브젝트에 대한 최근 사용 Account 레코드 lookup 값 조회
{
  uiapi {
    lookupValues(
      objectApiName: "Opportunity"
      fieldApiName: "AccountId"
      searchType: RECENT
    ) {
      targetApiName
      records { edges { node { Record { Id DisplayValue } } } }
      pageInfo { hasNextPage endCursor }
    }
  }
}
```

**③ 레코드 생성 기본값 — `recordCreateDefaults`**

특정 오브젝트 타입의 새 레코드에 대한 **기본 필드 값**을 제공한다. 응답에는 사용자가 Salesforce UI에서 빈 레코드 생성 폼을 열었을 때 보게 되는 **미리 채워진 필드 값**이 포함된다. 오브젝트 정보나 레이아웃 구조가 필요하면 **`objectInfos` · `recordLayouts` 호출을 별도로 체이닝**해 미리 채워진 생성 폼을 렌더할 재료를 모두 얻는다.

```graphql
// 릴리즈 노트 코드 블록 발췌 — help.salesforce.com rn_api_graphql (Winter '27) — 스키마
// ⚠️ 소스 페이지의 formFactor 기본값 표기가 원문에서 그대로 깨져 있다(따옴표 위치) — 원문 보존
type UIAPI {
  recordCreateDefaults(
    objectApiName: String!
    recordTypeIds: [ID!]
    formFactor = "LARGE: FormFactor
    mode = "LAYOUT": CreateDefaultsMode
    configs: [CreateDefaultsConfig!]
    optionalFields: [String!]
    first: Int
    after: String
  ): CreateDefaultsConnection
}

input CreateDefaultsConfig {
  recordTypeId: ID!
  formFactor = "LARGE": FormFactor
}
```

> 소스 페이지의 사용 메모: 새 account 레코드 생성 기본값을 얻는 예제에서는 **스칼라 필드에 `rawValue`** 를 쓰고 **참조(reference) 필드에는 단일 fragment**를 쓴다. (예제 쿼리 본문 자체는 소스에 코드 블록으로 포함돼 있지 않았다.)
> 관련: [[GraphQL Wire Adapter]]

### User Interface API

**① 변경된 응답 본문 — Actions → Platform Action**

다음 프로퍼티는 이 응답 본문에서 **제공되지 않는다**. (API 버전 67.0에서 제공된다고 문서화됐던 항목이다.)

- `pageDeveloperName`
- `targetParentField`
- `targetRecordTypeId`

**② 지원 오브젝트**

- **모든 새 표준 오브젝트는 User Interface API 사용이 자동 활성화**된다. 자동 활성화된 신규 오브젝트는 아래 [#새·변경 오브젝트](#새변경-오브젝트) 카탈로그로 확인한다.
- org에 새로 추가된 것은 아니지만 **User Interface API에 새로 지원되는 표준 오브젝트:** `LoyaltyAggrPointExprtLedger` · `VideoCallParticipant` · `VideoRecording`
- 이미 User Interface API에서 지원되던 오브젝트 중 **리스트 뷰와 최근 사용 리스트 뷰(most recently used list views)에 새로 지원되는 오브젝트:** `ReceivedDocument`

### Salesforce Edge Network 라우팅 셀프 서비스 설정

**My Domain 설정 페이지의 셀프 서비스 옵션**으로 네트워크 라우팅을 관리한다. 매번 Salesforce 고객 지원에 연락하지 않고도 연결 신뢰성을 유지할 수 있다. (대응 Metadata API 값: `MyDomainSettings.edgeRoutingMethod`의 새 값 `gsr` — 아래 Metadata API 카탈로그 참조.)

### API Catalog

API · MCP 서버 같은 **서비스를 한 곳에서 중앙 관리**한다. MuleSoft · Heroku · Apex 등에서 API를 가져와 Agentforce 에이전트와 flow에서 사용한다. **Salesforce 호스팅 MCP 서버를 활성화**해 외부 MCP 클라이언트와 함께 쓰고, **MuleSoft를 포함한 외부 MCP 서버를 등록**해 Agentforce에서 사용한다.

---

## Customization (General Setup)

> 릴리즈 노트 구조 변경: **Customization · Deployment · Development 섹션의 릴리즈 노트가 전용 Platform 섹션으로 이동**했다. 인프라·API·기반 업데이트를 찾기 쉽게 하기 위한 재편이다. 아래 항목은 개발과 직접 맞닿은 것만 옮긴다 — 나머지는 [[Winter '27/Platform]] 소관이다.

| 기능 | 핵심 |
|---|---|
| **Lightning App Builder의 Request Approvals 컴포넌트 — 다중 flow 승인 프로세스** | Experience Builder에서 Request Approvals 컴포넌트를 구성해, 제출자가 레코드에 대해 **최대 10개의 autolaunched flow 승인 프로세스** 중에서 선택하게 한다. Where: Lightning Experience의 Enterprise · Performance · Unlimited · Einstein 1 Editions · Agentforce 1 Editions · Developer 에디션 |
| **같은 오케스트레이션 실행의 다음 작업 항목 자동 열기** | Lightning App Builder에서 **Orchestration Work Guide 컴포넌트**를 구성해, 사용자가 작업 항목을 완료하면 **같은 오케스트레이션 실행의 다음 작업 항목을 자동으로** 열도록 한다. Where: 위와 동일 |
| **리스트 뷰 인라인 편집 유연화** | 두 개의 **User Interface Settings**로 리스트 뷰 인라인 편집을 더 세밀하게 제어한다. ① 사용자가 **편집 권한이 있는 모든 필드**를 페이지 레이아웃 포함 여부와 무관하게 인라인 편집 ② **여러 레코드 타입이 섞인 리스트 뷰**에서도 인라인 편집 허용. 설정이 없으면 페이지 레이아웃 제약이 적용되고, 리스트 뷰에 2개 이상 레코드 타입이 있으면 인라인 편집을 쓸 수 없다. 대응 Metadata API 필드: `UserInterfaceSettings.listViewIleBypassLayout` · `listViewIleMultiRecordType` |
| **Enable Field History Tracking for Users (GA)** | 위 [#Enable Field History Tracking for Users (Generally Available)](#enable-field-history-tracking-for-users-generally-available) 참조 |
| **View Setup Audit Trail 권한 (Release Update)** | 위 Release Update 표 참조 |

---

## 플랫폼 개발 도구 · Headless 360

### 릴리즈 노트 구조 재편 — 무엇이 어디로 갔나

Winter '27에서 개발 도구 릴리즈 노트의 소재지가 바뀌었다. **찾는 위치를 착각하면 "변경이 없다"고 오판**하기 쉬우므로 먼저 지도부터 본다.

| 도구 | Winter '27 릴리즈 노트 위치 |
|---|---|
| Salesforce CLI | **Headless 360** 섹션으로 이동 (Platform Development Tools에는 포인터만) |
| Agentforce Vibes Extension | **Headless 360** 섹션으로 이동 |
| Agentforce Vibes IDE | **Headless 360** 섹션으로 이동 |
| Salesforce Development Claude Code Plugin | **Headless 360** 섹션 (신규) |
| Setup with Agentforce | **Headless 360** 섹션 (아래 전용 절) |
| Agentforce DX · Salesforce DX MCP Server · Salesforce Extensions for VS Code · Scalability | **Platform Development Tools** 유지 |
| Customization · Deployment · Development | **Platform** 섹션으로 통합 |

**Headless 360**은 허브 페이지로, 기능·변경이 **월 단위로 자주** 릴리즈된다. Agentforce Vibes · Salesforce Multi-Framework · Salesforce MCP Servers 등 headless 기능을 지원하는 릴리즈 노트를 포괄한다. *Headless 360 Release Note Changes by Month* 의 **2026년 8월 추가분**: MuleSoft Anypoint Platform CLI · MuleSoft API Catalog Connect REST API · Service: Set Up a Help Agent (모두 **2026년 8월 17일 주** 추가).

### Salesforce CLI

Salesforce CLI로 Agentforce 에이전트를 작성하고, 개발·테스트 환경을 만들고, 소스를 동기화하고, 테스트를 실행하고, 애플리케이션 수명주기를 통제한다. **새 버전은 매주 릴리즈**되므로 주간 릴리즈 노트를 함께 본다.

- **Where:** 아래 변경은 **Salesforce CLI 버전 2.131.7 이상**에 적용된다.

#### 1. 명령 출력에서 자격 증명 제거 (Enhanced Credential Security)

Salesforce CLI가 아래 명령의 출력에 **access token · SFDX Auth URL · 사용자 비밀번호를 더 이상 포함하지 않는다.**

| 자격 증명이 제거된 명령 (전수) |
|---|
| `org display` |
| `org list --json` |
| `org create scratch --json` |
| `org resume scratch --json` |
| `org display user --json` |
| `org list users --json` |
| `org login jwt --json` |
| `org login web --json` |
| `org login sfdx-url --json` |
| `org login access-token --json` |
| `org list auth --json` |

자격 증명을 봐야 할 때는 **새 명령**을 쓴다.

| 새 명령 | 반환 |
|---|---|
| `org auth show-access-token` | 현재 access token |
| `org auth show-sfdx-auth-url` | SFDX Auth URL |
| `org auth show-user-password` | 저장된 사용자 비밀번호 |

- **전환기 임시 우회:** 환경 변수 **`SF_TEMP_SHOW_SECRETS=true`** 를 설정하면 이전 동작이 복원된다. **이 우회는 향후 릴리즈에서 꺼진다.** (CI 스크립트가 JSON 출력에서 토큰을 파싱하고 있다면 지금 새 명령으로 이관한다.)

#### 2. 스크래치 org에서 미검증 이메일 도메인 사용

스크래치 org 정의 파일에서 **`EmailAuthorizationSettings.enableSubstituteFromAddress` 를 `true`** 로 설정하면, **미검증 이메일 도메인을 가진 사용자에게도** 스크래치 org에서 메일을 보낼 수 있다. Salesforce에서 보내는 메일은 검증된 이메일 도메인이어야 한다는 요구를 우회하는 장치로, **테스트 사용자에게 메일을 보내는 Apex 테스트를 스크래치 org에서 실행할 때** 유용하다.

```json
// 릴리즈 노트 코드 블록 발췌 — help.salesforce.com rn_tools_cli_enhancements (Winter '27)
{
  "orgName": "My Company",
  "edition": "Developer",
  "features": ["EnableSetPasswordInApi"],
  "settings": {
    "lightningExperienceSettings": { "enableS1DesktopEnabled": true },
    "mobileSettings": { "enableS1EncryptedStoragePref2": false },
    "emailAuthorizationSettings": { "enableSubstituteFromAddress": true }
  }
}
```

> 관련: [[Scratch Org 생성과 정의 파일]] · [[Scratch Org Settings 레퍼런스]]

#### 3. 비동기 Apex 클래스 스캐폴딩 — 모범 사례 내장 템플릿

`template generate apex class` 의 **`--template` 플래그에 새 값 `Batchable` · `Queueable`** 이 추가됐다.

| 템플릿 | 생성되는 코드의 특징 |
|---|---|
| `Batchable` | **강타입 `Database.Batchable<SObject>`** — 타입 지정된 `List<SObject>` scope, 동적 문자열 쿼리 대신 **인라인(컴파일 검증되는) SOQL 쿼리**, 그리고 **`Database.RaisesPlatformEvents`** 를 포함해 배치 반복(iteration) 실패가 플랫폼 이벤트로 드러나게 한다 |
| `Queueable` | **`Finalizer`를 구현하고 부착하는 Queueable 클래스** — 처리되지 않은 예외가 발생한 뒤에도 후처리 로직이 확실히 실행되게 한다. 생성된 코드는 **`UNHANDLED_EXCEPTION` 케이스를 명시적으로 처리**한다 |

```bash
# 릴리즈 노트 코드 블록 발췌 — help.salesforce.com rn_tools_cli_enhancements (Winter '27)
sf template generate apex class --name ProcessAccounts --template Batchable
sf template generate apex class --name SendEmail --template Queueable
```

> 관련: [[Batch Apex]] · [[Queueable]] · [[Transaction Finalizer]]

#### 4. 설치 키로 보호된 패키지 의존성 조회

`package version displaydependencies` 에 **새 플래그 `--installation-key`(단축 `-k`)** 가 추가됐다.

```bash
# 릴리즈 노트 코드 블록 발췌 — help.salesforce.com rn_tools_cli_enhancements (Winter '27)
sf package version displaydependencies --package 04t.. --installation-key YOUR_KEY --target-dev-hub devhub@example.com
```

#### 5. 스크래치 org 사용자에게 역할(Role) 할당

`org create user` 가 사용하는 **사용자 정의 파일에 새 옵션 `roleDeveloperName`** 이 추가됐다. 역할의 **developer name(API 이름)** 을 지정하며, 값은 org의 **`UserRole.DeveloperName`** 에 대응한다.

```json
// 릴리즈 노트 코드 블록 발췌 — help.salesforce.com rn_tools_cli_enhancements (Winter '27)
{
  "Username": "tester1@sfdx.org",
  "LastName": "Hobbs",
  "Email": "tester1@sfdx.org",
  "Alias": "tester1",
  "TimeZoneSidKey": "America/Denver",
  "LocaleSidKey": "en_US",
  "EmailEncodingKey": "UTF-8",
  "LanguageLocaleKey": "en_US",
  "profileName": "Standard Platform User",
  "permsets": ["Dreamhouse", "Cloudhouse"],
  "generatePassword": true,
  "roleDeveloperName": "Customer_Support"
}
```

> 관련: [[sf CLI 명령 카탈로그 · sfdx→sf 매핑]] · [[Scratch Org 배포·유저·에러코드]]

### Agentforce Vibes (Extension)

VS Code 데스크톱과 Agentforce Vibes IDE에서 **VS Code 확장**으로 제공되는 AI 개발 도구다. **Agentforce Vibes 4.0 이상은 확장의 전면 재설계(full re-engineering)** 로, **Salesforce Coding Agent Platform** 위에 다시 만들어졌고 **Claude와 Mastra를 기반 에이전트 오케스트레이션 엔진**으로 쓴다. **Enterprise · Performance · Unlimited · Partner Developer · Developer 에디션에서 기본 활성화**된다.

- **Where(변경 적용 범위):** 아래 향상은 **Agentforce Vibes Extension 버전 4.0 이상**에 적용된다.

| 향상 | 내용 |
|---|---|
| **새 Agentforce Vibes Extension Developer Guide** | 이제 다음을 다룬다 — agentic development · plan mode · subagents · skills · **Model Context Protocol(MCP) 서버** · 모델 선택 · 컨텍스트 관리 · **빌링 및 entitlement 설정** · trust와 검증 · 워크플로 패턴 · 전환(transition) 가이드 |
| **AI 요청을 org에서 지리적으로 가장 가까운 모델 엔드포인트로 라우팅** | geo-aware 라우팅. 켜면 모델 선택기에 **org 리전에서 사용 가능한 모델만** 표시되고 요청이 **그 리전에서 처리**된다(기본값인 미국 라우팅 대신). **US 리전으로의 폴백을 끌 수도 있다** |
| **Flex Credit 소비량 추정** | metered billing을 확정하기 전에 Flex Credit 소비량을 추정하는 **새 레퍼런스 토픽**. Prompt Usage Types와 배수(multiplier) 작동 방식을 다루고, 단일 세션 예제에서 **Opus 4.8 · Sonnet 4.6 · GPT-5.4의 실측 토큰 데이터**를 포함하며, 팀 규모를 입력하는 월간 추정기를 제공한다 |
| **AI 거버넌스 정책 구성** | Agentforce Vibes가 **ALM Control Center Governance**에 구성된 AI 거버넌스 정책을 지원한다. org가 거버넌스를 활성화하면 Agentforce Vibes가 **활성 정책을 가져와 모든 세션의 에이전트 지시사항으로 적용**한다. 정책은 **Salesforce 관리자가 설정하며 엔드 유저는 수정하거나 끌 수 없다.** 활성 정책은 Agentforce Vibes Toolkit의 **Org Policies** 섹션에 **읽기 전용**으로, Rules와는 **별도로** 표시된다 |

### Agentforce Vibes IDE

**웹 기반 통합 개발 환경**으로, Visual Studio Code · Salesforce Extensions for VS Code · Salesforce CLI의 기능과 유연성을 **웹 브라우저에서** 제공한다. 새 버전은 필요에 따라 릴리즈되며, **off-cycle 릴리즈 노트는 GitHub**에 게시된다.

### Salesforce Development Claude Code Plugin

**Headless 360 플랫폼에서 앱과 에이전트를 만드는 Claude Code용 플러그인**이다. 자연어 프롬프트로 Salesforce 앱을 개발하며, 플러그인이 **Salesforce DX 프로젝트 환경을 감지**해 **호스팅된 MCP 서버를 통해 Salesforce 전용 skills와 org 컨텍스트**를 제공한다.

- **Where:** **Claude Plugin Marketplace**에서 제공. **Salesforce DX 프로젝트에 접근할 수 있는 모든 Claude Code 플랫폼** — CLI(터미널) · Desktop · VS Code · JetBrains IDE — 에서 동작한다.
- **How:** 먼저 사전 요구 소프트웨어를 설치한다. 그다음 Claude Code를 열고 플러그인을 설치·활성화한다.

```text
// 릴리즈 노트 코드 블록 발췌 — help.salesforce.com rn_headless360_cc_plugin (Winter '27)
/plugin install salesforce-development@claude-plugins-official
/reload-plugins
```

환경 정보와 팁이 담긴 Salesforce Development Welcome 페이지를 읽는다.

```text
// 릴리즈 노트 코드 블록 발췌 — help.salesforce.com rn_headless360_cc_plugin (Winter '27)
/salesforce-development:welcome
```

- **숙련 개발자 경로:** 메타데이터와 코드가 있는 DX 프로젝트를 열고 자연어 프롬프트를 입력한다. 소스가 제시한 **샘플 프롬프트**: Account 테리토리 할당을 처리하는 Apex 서비스 클래스 생성 / Name · Status · Due Date · Owner 필드를 가진 `Project` 커스텀 오브젝트 생성 / 현재 변경분을 샌드박스에 배포 / `AccountTerritoryService`의 테스트 클래스를 작성하고 실행.
- **신규 개발자 경로:** *"Let's build something in Salesforce."* 프롬프트를 실행하면 Claude가 Salesforce 개발 기본 정보를 보여주고 초기 프롬프트(예: *"Create a DX project called my-project."*)를 제안한다. 프로젝트를 만든 뒤 org 인가·연결 같은 다음 단계를 안내한다. 막히면 *"What do I do now?"* / *"What's the status?"* 를 쓴다.
- 이후 단계는 만들려는 대상(커스텀 오브젝트 · Apex 클래스 · LWC · 그 밖의 커스터마이제이션)에 따라 달라진다. 기술 상세와 skills 목록은 **Salesforce Skills and Plugin GitHub 리포지토리**에 있고, 이슈·기능 제안도 그 리포지토리의 issues 섹션에 올린다.

### Setup with Agentforce

Headless 360의 다섯 번째 자식 항목이다. **Setup의 새 AI 기반(AI-powered) 에이전트를 사용해 관리 작업(administrative tasks)을 단순화**한다.

> 소스(`rn_headless360`의 자식 항목 목록)가 이 항목에 대해 제공한 서술은 **위 한 줄이 전부**다. Where·When·How·에디션 정보는 추출 범위(62페이지)에 없다 — **지어내지 않는다.** 형제 항목(Salesforce CLI · Agentforce Vibes · Agentforce Vibes IDE · Claude Code Plugin)은 각자 전용 페이지가 있어 아래에서 상세를 다루지만, 이 항목은 전용 페이지가 추출되지 않았다. 어드민 관점 기능이므로 상세가 필요하면 [[Winter '27/Agentforce]] 와 Headless 360 허브 페이지를 확인한다.

### Agentforce DX

**Salesforce DX 프로젝트 안에서** 에이전트를 만들고, 미리 보고, 테스트한다. Salesforce CLI · VS Code 같은 프로 코드 도구를 쓴다. **업데이트는 필요에 따라 릴리즈**되며, Agentforce DX CLI 명령과 VS Code 확장 변경 공지는 **주간 Salesforce CLI 릴리즈 노트**에 포함된다.

### Salesforce Extensions for Visual Studio Code

Salesforce Extension 팩은 VS Code 편집기에서 Salesforce 플랫폼 개발을 위한 도구를 제공한다 — **개발 org(스크래치 org · 샌드박스 · DE org) · Apex · Lightning 웹 컴포넌트 · Aura 컴포넌트 · Visualforce** 작업. **새 버전은 매주 릴리즈**된다.

### Scalability

구현을 최적화·테스트한다. 오류를 진단하고, 애플리케이션 성능 문제를 식별하며, 확장 방식을 개선한다. (이번 릴리즈의 구체 항목은 위 [#ApexGuru — 중복 코드 탐지 · 에이전틱 IDE 스캔 (Generally Available)](#apexguru--중복-코드-탐지--에이전틱-ide-스캔-generally-available) 참조.)

---

## New and Changed Items — 카탈로그

> **New and Changed Items for Developers** 는 새·변경 오브젝트 · 호출 · 클래스 · 컴포넌트 · 명령의 색인 페이지다. 하위 페이지는 ① Lightning Components ② Apex ③ ConnectApi(Connect in Apex) ④ API 로 나뉜다. 아래는 각 카탈로그를 **요약하지 않고** 옮긴 것이다.

### Apex: New and Changed Items

소스 구성: **ConnectApi 네임스페이스 / Database 네임스페이스 / System 네임스페이스** 3개 절.

**ConnectApi 네임스페이스** — 새·변경 클래스·메서드·enum이 있다. Connect REST API 리소스 액션 다수가 ConnectApi 네임스페이스 Apex 클래스의 **static 메서드**로 노출되며, 이 메서드들은 입력·반환에 다른 ConnectApi 클래스를 쓴다. ConnectApi 네임스페이스는 **Connect in Apex**로 불린다.

> ⚠️ 새·변경 ConnectApi 클래스·메서드·enum의 **개별 목록은 별도 페이지**(*ConnectApi (Connect in Apex): New and Changed Classes and Enums*)에 있으며 **이번 추출 범위(62페이지)에 포함되지 않았다.** 목록을 지어내지 않는다 — 필요하면 해당 릴리즈 노트 페이지 또는 [[ConnectApi Namespace 개요]]를 확인한다.

**Database 네임스페이스 — 새 클래스**

| 클래스 | 설명 |
|---|---|
| `Database.QueryOptions` | SOQL **`SET OPTIONS` 절**에 쓸 쿼리 옵션을 제공 |
| `Database.QueryOptionsBuilder` | 위 객체를 만드는 빌더 |

빌더 메서드 (전수): **`withDataspace`** · **`withHonorEmptyStrings`** · **`withExplicitNamespace`**

> ⛔ **아래 블록은 코드가 아니라 "API 표면 요약"이다.** 릴리즈 노트의 **실제 샘플 2건은 안전 필터로 확보되지 않았고**(위 `explicitNamespace` 절의 ⛔ 경고 참조), 그 샘플을 재구성한 것이 **아니다.** 아래에 있는 것은 소스가 나열한 **식별자 목록과 호출 순서를 문장 대신 도식으로 적은 것뿐**이며, **컴파일되지 않고 실행할 수도 없다.** 실제 코드는 *Apex Reference Guide: Database.QueryOptions Class* 와 *SOQL and SOSL Reference: SOQL SET OPTIONS Clause* 에서 직접 확인한다.

```text
// 구조 예시 — 실제 동작 코드 아님 (Apex 코드가 아니라 API 표면 도식)
새 클래스   : Database.QueryOptions        — SET OPTIONS 절에 쓸 쿼리 옵션
            : Database.QueryOptionsBuilder — 위 객체를 만드는 빌더
빌더 메서드 : withDataspace / withHonorEmptyStrings / withExplicitNamespace
호출 순서   : 빌더로 QueryOptions 생성
            → SOQL의 SET OPTIONS 절에 바인드 변수로 전달
            → Database.query() 또는 Database.queryWithBinds() 에 쿼리를 넘김
```

**System 네임스페이스 — 기존 클래스의 새·변경 메서드**

**Data 360 커서 · 커서 행 · flex credits 사용량**의 최대 허용치와 현재 사용량을 조회하는 **`System.Limits` 메서드 6개**가 추가됐다(전수).

| 메서드 | 조회 대상 |
|---|---|
| `Limits.getDataCloudCursorRows` | Data 360 커서 행 — 현재 사용량 |
| `Limits.getLimitDataCloudCursorRows` | Data 360 커서 행 — 최대 허용치 |
| `Limits.getDataCloudCursors` | Data 360 커서 — 현재 사용량 |
| `Limits.getLimitDataCloudCursors` | Data 360 커서 — 최대 허용치 |
| `Limits.getDataCloudFlexCredits` | Data 360 flex credits — 현재 사용량 |
| `Limits.getLimitDataCloudFlexCredits` | Data 360 flex credits — 최대 허용치 |

> 이것이 System 네임스페이스 절의 **전체 내용**이다(소스 페이지 전량 확보). 관련: [[System Namespace]] · [[Governor Limits]]

### API: New and Changed Items

API 버전 68.0에서 더 많은 데이터 오브젝트와 메타데이터 타입에 접근한다. 하위 페이지 구성:

| 하위 페이지 | 내용 |
|---|---|
| New and Changed Objects | 새·변경 표준 오브젝트 |
| New and Changed Standard Platform Events | 새·변경 표준 플랫폼 이벤트 채널 |
| Connect REST API | 모바일 앱 · 인트라넷 사이트 · 서드파티 웹 앱 통합 |
| CRM Analytics REST API | Data 360 오브젝트의 확장 메타데이터(XMD) 조회·갱신, 미지원 기능 쿼리 |
| Metadata API | 새·변경 메타데이터 타입 |
| Tooling API | Apex Symbol API · 무효 Apex 컴파일 결과 · Test Discovery `testLevel` · 새·변경 Tooling 오브젝트 |
| User Interface API | 네이티브 모바일 앱·커스텀 웹 앱용 Salesforce UI 구축 |
| GraphQL API | GraphQL 변경 사항 |

> **API Release Note Changes by Month — 2026년 8월:** *API: New and Changed Items: Metadata API* 와 *API: New and Changed Items: Tooling API New and Changed Objects* 가 **2026년 8월 17일 주**에 추가됐다. (프리뷰 기간 중 카탈로그가 계속 채워지고 있다는 신호다.)

#### 새·변경 오브젝트

**ARCHIVE**

| 오브젝트 | 변경 |
|---|---|
| `ArchivePolicyDefinition` | 새 필드 `ArchivePolicyRelObjSelection` · `RelatedObjects` · `IsArchiveRelatedFiles` · `ContentDocumentObject` — 아카이브 작업에 포함된 관련 오브젝트·콘텐츠 파일 확인 |
| `ArchivePolicyDefinition` | 새 필드 `RetentionYears` · `RetentionMonths` · `RetentionSource` — 아카이브된 레코드의 보존 기간 |
| `ArchivePolicyDefinition` | 새 필드 `IsBoostEnabled` · `IsLogFailuresAndContinue` — 아카이브 정책 실행 성능·실패 처리 설정 |
| `ArchivePolicyDefinition` | 새 필드 `Schedule` · `IsAnalyzed` · `PreviewFields` · `FilterConditions` — 정책 실행 시점, 정책 분석 설정 |
| `ArchivePolicyDefinition` (프로퍼티 변경) | `DataProtectionThreshold` — **Group · Nillable 지원 추가** / `Description` — **Filter · Group · Nillable · Sort 추가** / `Query` — **Filter · Group · Sort 제거, Nillable 추가** / `RunFrequency` · `Type` — **Nillable 추가** |

**COMMERCE**

| 오브젝트 | 변경 |
|---|---|
| `WebCart` (기존) | 새 필드 `TotalProductItemAdjTaxAmount` — 카트 내 모든 제품 항목에 걸친 **항목별 조정(할인·추가요금 포함)의 총 세액** |
| `PaymentLink` (기존) | 새 필드 `CustomMetadata` — 서드파티 결제 게이트웨이가 거래를 대사(reconcile)하고 인보이스를 추적하도록 가맹점 지정 메타데이터 저장 |

**EVENT MONITORING**

| 오브젝트 | 변경 |
|---|---|
| `EventLogFile` (기존), **Invocable Action** 이벤트 타입 | 새 필드 `AGENT_ACTION` · `API_CALLER` · `INVOCATION_SOURCE` · `INVOKING_APEX_CLASS_NAME` · `PROMPT_TEMPLATE` — invocable action의 호출 출처 추적. **이 필드들은 API 버전 66.0에서 도입됐고, 이번에 Object Reference for Salesforce Platform 문서에 추가된 것** |

**SALES**

- **BEHAVIOR CHANGE** — `Event` 오브젝트의 **`IsRecurrence2Exclusion` 필드가 편집 가능**해졌다. **API 버전 67.0 이상**에서 Apex 또는 API로 쓰기 가능하다. **API 버전 65.0 이하에서는 읽기 전용**이며, 이벤트가 시리즈의 다른 이벤트와 다르다는 것을 프로그래밍 방식으로 표시할 수 없다.

**SECURITY AND IDENTITY**

- **BEHAVIOR CHANGE** — `RedirectWhitelistUrl` 접근에 **Customize Application 권한이 필요**하다. 이전에는 `RedirectWhitelistUrl` 오브젝트의 **편집 접근에만** 필요했으나, 이제 **읽기 접근에도** 필요하다.

**SERVICE**

| 오브젝트 | 변경 |
|---|---|
| `MessagingSessionMetrics` | `MessagingSessionMetricType` 필드에 새 값 **`ServiceRepAcceptToFirstResponseTime`** — 상담원이 메시징 세션을 처음 수락한 뒤 응답하기까지 걸린 시간 |
| `AgentWorkConversationalData` · `VoiceCall` (기존) | 새 필드 `AverageJitter` · `AveragePacketLoss` · `MaximumJitter` · `MaximumPacketLoss` — jitter·패킷 손실 지표로 음성 통화 품질 문제 탐지 |
| **`AgentQltyEvalFormCondition`** (신규) | 상담원 상호작용의 품질 평가 기준 정의 |
| **`AgentQltyEvalFormCriteria`** (신규) | 수신 상호작용을 올바른 평가 양식으로 라우팅 |
| **`AssessmentQuestionCatgData`** (신규) | 평가의 카테고리 수준 점수 추적 |
| `VoiceCallRecording` (기존) | 새 필드 `RecordingStartTime` — 음성 통화 녹음의 정밀한 타이밍 데이터 |
| `Assessment` (기존) | 새 필드 `AssessmentSummary` · `ConfidenceScore` |
| `AssessmentQstnVerChoice2` (기존) | 새 필드 `IsExcludedFromScoring` — 특정 답변 선택지를 채점에서 제외 |
| `MessagingChannelUsage` (기존) | 기존 `ErrorReason` 필드에 **10개의 새 값** — WhatsApp 연결·활성화·연결 해제·비활성화 중 발생한 오류의 투명성 향상 |
| `MessagingChannel` (기존) | 새 필드 `DefaultResponse`(고객이 메시징 대화를 시작할 때의 기본 응답 메시지); 기존 `MessageType` 필드에 새 값 **`Email`** |
| `MessagingEndUser` (기존) | 기존 `MessageType` 필드에 새 값 **`Email`** — Email 메시지와 연관된 엔드 유저 상세 확인 |
| `MessagingSession` (기존) | 새 필드 `CampaignId`(메시징 세션과 연관된 캠페인 ID 조회); 기존 `ChannelType` 필드에 새 값 **`Email`** |

#### 새·변경 표준 플랫폼 이벤트

| 영역 | 이벤트 | 알림 시점 |
|---|---|---|
| COMMERCE | **`WebCartAbandonedEvent`** (신규) | 장바구니 이탈(abandoned cart) 관련 알림 |
| INDUSTRIES | **`ObjectMilestoneCreatedEvent`** (신규) | 오브젝트 마일스톤의 **상세(detailed) 이벤트 레코드** 생성 프로세스 완료 시 / 오브젝트 마일스톤 생성 시 |
| INDUSTRIES | **`ObjectMilestoneCreatedDtlEvent`** (신규) | 오브젝트 마일스톤의 이벤트 레코드 생성 프로세스 완료 시 / 오브젝트 마일스톤 생성 시 |
| SERVICE | **`AgentQltyEvalEvent`** (신규) | 음성 · 메시징 · 케이스 전반에서 품질 평가가 발생할 때(상담원 상호작용이 평가될 때) |

> 두 Industries 이벤트는 소스 설명이 거의 동일하게 기재돼 있다(이름만 `Dtl` 유무로 다름). 원문 그대로 옮긴다.
> 관련: [[Platform Event 통합 패턴]] · [[Pub-Sub API (gRPC) — Platform Event·CDC 구독]]

#### Metadata API

API 버전 68.0의 새·변경 메타데이터 타입(영역별 전수).

**CUSTOMIZATION**

| 타입 | 변경 |
|---|---|
| `ActionsSettings` | 새 필드 `enableDynamicActionsMobileStdObj` — 모바일에서 Dynamic Actions 활성화/비활성화 |
| `SharingSettings` (기존) | 새 필드 `enableKeepManualSharesOnTransfer` — 레코드를 새 소유자에게 이전할 때 수동 공유 유지 |
| `CurrencySettings` (기존) | 새 필드 `corporateCurrency` · `currency` — 다중 통화를 켜고, 법인 통화를 설정하고, 활성 통화를 **한 번의 배포로** 시딩. **다중 통화는 한 번 켜면 끌 수 없다.** `currency` 필드는 **새 `Currency` 서브타입**을 쓴다. **API 68.0 이상** |
| `SharedTo` (기존) | 새 필드 `allRestrictedEmployeeUsers` — **Unified Employee 라이선스** 사용자에게 접근 확장. **API 68.0 이상** |
| `UserInterfaceSettings` (기존) | 새 필드 `listViewIleBypassLayout`(리스트 뷰 인라인 편집의 페이지 레이아웃 의존 제거) · `listViewIleMultiRecordType`(여러 레코드 타입이 있는 리스트 뷰에서 인라인 편집 허용) |

**DEVELOPMENT**

| 타입 | 변경 |
|---|---|
| **`DebugLevel`** (**신규** 메타데이터 타입) | **에이전틱 도구로 디버그 로그 수준을 구성** |
| `CodeCoverageResult` (기존) | 새 필드 `locationsCovered` — 배포에서 Apex 유닛 테스트가 커버한 **코드 위치** 식별 |
| `ApexSettings` (기존) | 새 필드 `asyncApexExecutionsOverride` — 비프로덕션 org에서 표준 Apex 비동기 잡 한도를 **더 낮은 값으로** override |
| `MyDomainSettings` (기존) | `edgeRoutingMethod` 필드에 새 값 **`gsr`** — 특정 네트워크 위치를 우회해 **가장 가까운 신뢰 가능 네트워크 노드**로 트래픽을 재전송. 방화벽 차단으로 Salesforce 사이트·Experience Cloud 사이트 접속에 문제가 있는 위치용 |

**EXPERIENCE CLOUD**

| 타입 | 변경 |
|---|---|
| `Network` (기존) | 새 필드 `NetworkOptionsBit` — Metadata API에서 **이메일 도메인 치환(email domain substitution)** 활성화 |

**GRAPHQL API**

| 타입 | 변경 |
|---|---|
| `SecuritySettings` (기존) | 새 필드 `enableGraphQLApiGuestUserAccess` — GraphQL API에 대한 게스트 사용자 접근 갱신 |

**SALESFORCE FLOW**

| 타입 | 변경 |
|---|---|
| `FlowStart` | 새 필드 `dataLookups` — **Record Query Flow**에서 관련 Data Model Object 레코드 접근 |
| `Flow` (기존) | 기존 `runInMode` 필드에 새 값 **`UserMode`** — flow를 **명시적으로 사용자 컨텍스트**에서 실행 |

**SECURITY AND IDENTITY**

- **BEHAVIOR CHANGE** — `CustomSite` 메타데이터 타입의 **`clickjackProtectionLevel` 필드가 더 이상 필수가 아니다.** clickjack 보호 수준을 지정하지 않고도 메타데이터 구성을 배포할 수 있다.

**SERVICE** — BYOC(Bring Your Own Carrier) 텔레포니 관련 **신규 타입 4개**

| 타입 | 용도 |
|---|---|
| **`TelephonyProvider`** (신규) | Agentforce Contact Center의 BYOC 텔레포니·신뢰(trust) 설정 관리 |
| **`SecondaryTelephonyProvider`** (신규) | BYOC의 보조 텔레포니 통합용 SIP 설정 구성 |
| **`TrustedTelephonyProvider`** (신규) | 조직을 신뢰된 텔레포니 통신사 구성에 매핑 |
| **`ScndTelephPrvdOtbdDtl`** (신규) | BYOC 보조 텔레포니의 아웃바운드 SIP 라우팅 관리 |

> ⚠️ **레퍼런스 미검증 — 이 4개는 v68.0 가이드에 문서화돼 있지 않다.**
> 위 표는 **릴리즈 노트가 선언한 내용**을 그대로 옮긴 것이다. 그런데 v68.0 PREVIEW **Metadata API 개발자 가이드**와 **Tooling API 가이드** 양쪽을 정확 일치·대소문자 무시·토큰 분할(`telephonyprovider` · `scndteleph` · `otbddtl` · `byoc`)로 검색한 결과 **출현 0회** — 접미사도, 디렉터리도, 필드 표도 없다. 대조군으로, 같은 릴리즈 노트가 함께 선언한 `VoiceTelephonyDefinition`은 Tooling 가이드에 실제 섹션이 있다(v68 Tooling p.962). 따라서 "프리뷰 가이드에는 원래 신규 항목이 안 실린다"로 설명되지 않고 **이 4개만 선별적으로 누락**된 상태다.
> **GA(비-PREVIEW) 가이드 배포 시 재확인 대상.** 판정 근거·상세는 [[Metadata Types — 개요 및 분류]]의 "릴리즈 노트 ↔ 레퍼런스 가이드 모순" 절 참조.

#### Tooling API

Apex Symbol API로 내장·커스텀 Apex 타입 정보를 얻고, 무효 Apex 클래스·트리거의 컴파일 결과를 조회하고, Test Discovery API 결과를 테스트 레벨로 필터하고, 새·변경 Tooling API 오브젝트로 더 많은 메타데이터에 접근한다. **모든 Tooling API 정보의 정본은 Tooling API Reference and Developer Guide다.**

**Tooling API Changed Calls and Resources**

| 구분 | 리소스 | 내용 |
|---|---|---|
| **새 REST 리소스** | `GET /services/data/v.XX.X/tooling/symbols` | Apex Symbol API(Beta)로 Apex 타입 정보 조회. ⚠️ **`v.XX.X` 오타는 소스 페이지에 있는 그대로**다(올바른 형식은 `vXX.X`) |
| **새 REST 리소스** | `POST /services/data/vXX.X/tooling/apexCompileResults` | 무효 Apex 클래스·트리거의 컴파일 결과 조회 |
| **변경 REST 리소스** | `GET /services/data/vXX.X/tooling/tests` | Test Discovery 결과를 테스트 레벨로 필터. 새 쿼리 파라미터 **`testLevel`** 이 폐기된 `showAllMethods`(API 67.0 이하 전용)를 대체 |

**Tooling API New and Changed Objects**

| 영역 | 오브젝트 | 변경 |
|---|---|---|
| SALES | `AuthorizedEmailDomain` (기존) | 새 필드 `IsEmailChangeVerfRqr` — 기존 `IsEmailVerificationRequired` 필드와 함께, 어떤 인가된 이메일 도메인이 이메일 주소 검증을 요구하는지 지정 |
| SALESFORCE FLOW | `FlowVersionView` (기존) | 기존 `RunInMode` 필드에 새 값 **`UserMode`** — flow를 명시적으로 사용자 컨텍스트에서 실행 |
| SERVICE | **`SensitiveDataRuleElmntGrp`** (신규) | 음성·메시징의 민감 데이터 편집(redaction) 규칙 정의 |
| SERVICE | **`SensitiveDataRuleElmnt`** (신규) | 사전 정의된 named-entity 타입으로 민감 데이터 편집 |
| SERVICE | **`VoiceTelephonyDefinition`** (신규) | Agentforce Contact Center의 org 수준 텔레포니 설정 구성 |
| SERVICE | **`VoiceTelephonyGroupOvride`** · **`VoiceTelephonyProfileOvride`** · **`VoiceTelephonyUserOvride`** (신규) | org 수준 텔레포니 설정을 **그룹 · 프로파일 · 사용자** 수준에서 override |
| SERVICE | **`TelephonyProvider`** (신규) | BYOC 텔레포니·신뢰 설정 관리 |
| SERVICE | **`SecondaryTelephonyProvider`** (신규) | BYOC 보조 텔레포니 통합용 SIP 설정 구성 |
| SERVICE | **`TrustedTelephonyProvider`** (신규) | 조직을 신뢰된 텔레포니 통신사 구성에 매핑 |
| SERVICE | **`ScndTelephPrvdOtbdDtl`** (신규) | BYOC 보조 텔레포니의 아웃바운드 SIP 라우팅 관리 |

**Tooling API Headers for REST and SOAP**

> ✅ **핵심 사실 2 — 이 페이지는 본문이 "TBD"로 게시돼 있다.** 추출 실패가 아니라 **게시된 본문 자체가 문자 그대로 `TBD`**(페이지 전체 41자)인 **플레이스홀더**다. Winter '27 프리뷰 문서의 미완성 지점이므로 **10월 GA 시점에 재확인 대상**으로 남긴다. 현행 헤더 정보는 [[Tooling API — SOAP·REST 헤더]] 와 v68.0 PDF를 본다.

> 관련: [[Tooling API — 개요·REST·SOAP 호출 기초]] · [[Tooling API — Objects and Namespaces (객체 분류)]]

### Lightning Components: New and Changed Items

#### 변경된 Lightning 웹 컴포넌트 (전수)

> **신규 컴포넌트는 없다.** 소스 페이지의 항목은 전부 기존 base 컴포넌트의 **변경**이며, 압도적 다수가 **접근성(a11y)** 작업이다.

| 컴포넌트 | 변경 내용 |
|---|---|
| `lightning-checkbox-group` | 새 접근성 동작: 필수 필드를 나타내는 별표(`*`)의 `<abbr>` 요소가 이제 **`aria-hidden="true"`** 를 지정한다. 스크린 리더용으로 **"required" 보조 텍스트를 담은 `<span>`** 이 추가됐다 |
| `lightning-button-icon` | **새 속성 `tooltip`.** 값을 제공하면 컴포넌트가 그 값을 **트리거 버튼의 `aria-description` 속성**에 할당한다 |
| `lightning-click-to-dial` | 컴포넌트가 **비활성(disabled) 상태**일 때, 스크린 리더용으로 **`role="link"` 와 `aria-disabled="true"` 를 지정한 `<span>`** 태그가 추가됐다 |
| `lightning-combobox` | **200%를 넘는 확대(zoom)** 를 수용하기 위해, 콤보박스의 텍스트 레이블이 잘리지(truncate) 않고 **다음 줄로 줄바꿈**된다 |
| `lightning-datatable` | 새 접근성 동작 — ① 컬럼 헤더 액션 드롭다운의 **버튼 크기가 24 px × 24 px로 확대**되어 터치 타깃 크기 개선 ② 컬럼 헤더 구분선의 **리사이즈 핸들러를 클릭하면 드래그 없이 크기 조절** 가능. 확정하려면 페이지 아무 곳이나 클릭하며, 컬럼 가장자리가 마우스 포인터를 따라간다. 확정하지 않고 클릭-리사이즈 모드를 빠져나가려면 **Esc** 를 누르거나 탭으로 컬럼 가장자리에서 포커스를 뺀다. **이전에는 클릭-드래그로만** 리사이즈할 수 있었다 ③ `errors` 속성의 `rows` 객체에 **새 프로퍼티 `rowTitle`** — 오류 아이콘의 보조 텍스트로 쓰이는 선택적 문자열로, 행의 scope 셀 값을 대체한다. scope 셀 값이 문자열이 아닐 때(예: 객체를 출력하는 커스텀 셀 타입) 설정하면 스크린 리더가 `[object Object]` 대신 의미 있는 행 레이블을 읽는다. `rowTitle`이 설정되지 않고 scope 셀 값도 쓸 수 없는 문자열이면 보조 텍스트는 **`"Row Number {N}"`**(N = 1부터 시작하는 행 인덱스)로 폴백한다 ④ `action` 타입에 **새 프로퍼티 `alternativeText`** — 행 액션 트리거 버튼의 접근 가능한 이름을 설정한다. **기본값은 `"Show actions"`** |
| `lightning-formatted-address` | 지도 링크에 스크린 리더용 **보조 텍스트(`"Show in Google Maps"`)를 담은 숨김 span** 태그가 추가됐다 |
| `lightning-helptext` | 터치 타깃 크기를 위해 **버튼 크기가 24 px × 24 px로 확대**. 버튼 아이콘이 **`container` variant** 를 지정하며 기본 크기는 **`small`**, 너비는 **16 px가 아니라 24 px** 다 |
| `lightning-input` | 새 접근성 동작 — ① **datetime**: 필드 세트에 검증 오류가 반환되면 이제 **time 필드에도 `aria-describedby`** 를 지정해 오류 메시지와 연결한다 ② **time**: **`aria-autocomplete="none"`** 을 지정한다 ③ **toggle**: on/off 상태 텍스트에 **`aria-hidden`** 을 지정한다 ④ **400% 이상 확대**를 수용하기 위해 **날짜 선택기가 세로 스크롤을 기본으로 하고 가로 스크롤을 억제**한다 ⑤ date·time 필드의 오류 메시지가 **`"h:mm a"` 같은 추상적 CLDR 패턴 문자열 대신 `"11:30 AM"` 같은 명확한 예시 시간 형식**을 제시한다 |
| `lightning-input-address` | 변경된 속성 — **`address-label`**: 상태 메시지가 스크린 리더 안내에 우편 주소(mailing address) 대신 **address label**을 사용한다 / **`show-address-lookup`**: `address-label` 값 **바로 뒤에 보이는 레이블("Search Address")** 이 표시된다 |
| `lightning-input-field` | **email 필드의 플레이스홀더가 `name@example.com`** 을 사용한다. 이 변경은 **레코드 상세 페이지의 email 필드에도** 적용된다 |
| `lightning-record-picker` | **`filter` 값이 있을 때** 콤보박스 래퍼가 **`role=group` 과 `aria-labelledby`** 를 지정한다 |
| `lightning-slider` | **새 속성 4개** — ① **`unit`**: 범위 표시에 단위 레이블을 덧붙인다. 백분율(`%`), 통화 기호(`$`·`EUR` 등), 커스텀 텍스트 접미사(`kg`·`px` 등). 예를 들어 `%` 단위면 범위 레이블이 `0-100` 대신 **`0-100%`** 로 표시된다. **기본값은 빈 문자열**(단위 없는 평범한 min-max 범위) ② **`unit-position`**: 단위가 범위를 기준으로 어디에 표시될지 제어. 유효 값은 **`prefix`**(범위와 값 **앞**에 배치 — 통화 단위에 사용, **기본값**) 과 **`suffix`**(범위와 값 **뒤**에 배치 — 백분율에 사용) ③ **`format-number`**: 범위 양 끝점과 값에 대해 숫자→텍스트 변환을 제공. `$1.5M` · `$50M` 같은 **커스텀 도메인·컴팩트 포맷팅**을 지원 ④ **`minimum-fraction-digits`**: step과 무관하게 **소수 자릿수의 최소 하한**을 설정. 0보다 크게 설정하면 **`min` 끝점은 그대로(0) 두고 `max` 끝점만 채운다(1500.0)**. **`step`의 정밀도가 `minimum-fraction-digits`보다 높으면 더 정밀한 step 정밀도가 우선**한다 — 예: `step="0.05"` 와 `minimum-fraction-digits="1"` 이면 범위가 **`0-1500.00`** 으로 표시된다. 또한 **범위 경계가 이제 step 정밀도로 표시**된다 — 예: `step="0.1"` 이면 범위 표시가 `0-100` 이 아니라 **`0.0-100.0`** |
| `lightning-tabset` | 오버플로 **"More" 버튼이 `role=tab` 대신 `role=presentation`** 을 사용한다. 탭 안에 상호작용 컨트롤이 중첩되는 것을 피하기 위해서다 |
| `lightning-vertical-navigation-item-icon` | **새 속성 `icon-assistive-text`** — 아이콘의 의미를 보조 기술에 설명하는 대체 텍스트(예: `"Open link in a new window"`). 아이콘이 **장식용이거나 주변 내용으로 의미가 전달되면 빈 문자열**로 설정한다 |

> 관련: [[lightning-datatable]] · [[lightning-slider]] · [[lightning-combobox]] · [[lightning-helptext]] · [[lightning-tabset]] · [[lightning-click-to-dial]] · [[lightning-vertical-navigation-item-icon]]

#### 새·변경 LWC 모듈

**새 모듈**

| 모듈 | 용도 |
|---|---|
| `lightning/platformNavigationItemApi` | Lightning 콘솔 앱 아이템 메뉴의 네비게이션 아이템 제어 (위 본문 절 참조) |

**변경된 모듈**

| 모듈 | 변경 |
|---|---|
| `lightning/analyticsWaveApi` | **새 wire adapter `getReplicatedFieldsWithAdvancedProps`** — CRM Analytics **replicated dataset**에 속한 필드 컬렉션을 **고급 프로퍼티(advanced properties)를 포함해** 조회 |

#### 변경된 Aura 컴포넌트 (전수)

> 항목은 전부 기존 Aura base 컴포넌트의 **변경**이며(신규 없음), 위 LWC 변경의 **camelCase 대응판**이다.

| 컴포넌트 | 변경 내용 |
|---|---|
| `lightning:checkboxGroup` | 새 a11y: 필수 필드 별표(`*`)의 `<abbr>` 가 **`aria-hidden="true"`** 지정, 스크린 리더용 **"required" 보조 텍스트 `<span>`** 추가 |
| `lightning:clickToDial` | 비활성 상태일 때 스크린 리더용 **`role="link"` · `aria-disabled="true"` `<span>`** 추가 |
| `lightning:combobox` | **200% 초과 확대**에서 콤보박스 텍스트 레이블이 잘리지 않고 다음 줄로 줄바꿈 |
| `lightning:datatable` | 새 a11y: 컬럼 헤더 액션 드롭다운 버튼 **24 px × 24 px** 로 확대; 컬럼 헤더 구분선의 리사이즈 핸들러 **클릭만으로 리사이즈**(확정 = 페이지 아무 곳 클릭 / 확정 없이 종료 = Esc 또는 탭 이동, 이전에는 클릭-드래그만). `action` 타입에 **새 프로퍼티 `alternativeText`** — 행 액션 트리거 버튼의 접근 가능한 이름, 기본값 `"Show actions"` |
| `lightning:formattedAddress` | 지도 링크에 보조 텍스트(`"Show in Google Maps"`) 숨김 span 추가 |
| `lightning:input` | 새 a11y: **datetime** — 필드 세트에 검증 오류가 반환되면 time 필드에도 `aria-describedby` 지정; **time** — `aria-autocomplete="none"` 지정. **400% 이상 확대**에서 날짜 선택기가 세로 스크롤 기본·가로 스크롤 억제. date/time 오류 메시지가 추상적 CLDR 패턴(`"h:mm a"`) 대신 명확한 예시 형식(`"11:30 AM"`) 제시 |
| `lightning:inputAddress` | 변경 속성: **`addressLabel`**(상태 메시지가 우편 주소 대신 address label 사용) · **`showAddressLookup`**(`addressLabel` 값 바로 뒤에 보이는 `"Search Address"` 레이블 표시) |
| `lightning:helptext` | 버튼 크기 **24 px × 24 px** 로 확대. 버튼 아이콘이 **`container` variant**, 기본 크기 **`small`**, 너비 **16 px → 24 px** |
| `lightning:inputField` | **email 필드 플레이스홀더 `name@example.com`** — 레코드 상세 페이지의 email 필드에도 적용 |
| `lightning:slider` | **새 속성:** `unit`(백분율 `%` · 통화 기호 `$`·`EUR` 등 · 커스텀 접미사 `kg`·`px` 등. `%` 단위면 `0-100` 대신 `0-100%`. 기본값 빈 문자열) · `unitPosition`(`prefix` = 범위·값 **앞**, 통화용, **기본값** / `suffix` = 범위·값 **뒤**, 백분율용) · `formatNumber`(범위 끝점·값의 숫자→텍스트 변환, `$1.5M`·`$50M` 같은 컴팩트 포맷 지원) · `minimumFractionDigits`(step과 무관한 소수 자릿수 최소 하한. 0보다 크면 min 끝점은 그대로(0), max 끝점만 채움(1500.0). step 정밀도가 더 높으면 step이 우선 — `step="0.05"` + `minimumFractionDigits="1"` → `0-1500.00`). **범위 경계가 step 정밀도로 표시** — `step="0.1"` → `0.0-100.0` |
| `lightning:verticalNavigationItemIcon` | **새 속성 `iconAssistiveText`** — 아이콘 의미를 보조 기술에 설명하는 대체 텍스트(예: `"Open link in a new window"`). 장식용이거나 주변 내용으로 의미가 전달되면 빈 문자열 |

> ⚠️ **LWC와 Aura 목록의 비대칭(소스 그대로 — 두 수치를 구분한다).** LWC 페이지는 **14개** 컴포넌트를, Aura 페이지는 **11개**를 나열한다.
>
> | 구분 | 건수 | 내용 |
> |---|---|---|
> | **소스가 명시한 비대칭** | **1건** | `lightning:tabset` — Aura 페이지에 **없다고 소스가 직접 밝힌** 유일한 항목이다(`role=presentation` 변경은 LWC 페이지에만 나타난다) |
> | **두 목록을 대조했을 때의 차이** | **3건** | 위 `lightning:tabset` + `lightning:buttonIcon`(새 `tooltip` 속성) · `lightning:recordPicker`(`role=group`·`aria-labelledby`) — 뒤 2건은 **14개 LWC 목록에는 있고 11개 Aura 목록에는 없다**는 사실만 확인될 뿐, **소스가 부재를 명시하지는 않았다** |
>
> 또한 LWC `lightning-datatable`의 새 프로퍼티 **`rowTitle`** 도 Aura `lightning:datatable` 항목에는 기재돼 있지 않다(이것도 목록 대조로만 확인되는 차이다). **소스가 명시하지 않은 차이를 "Aura에는 해당 변경이 없다"는 사실 주장으로 승격하지 않는다** — 대응 항목이 있으리라 가정하지도 않는다. 위 표는 소스에 있는 것만 옮겼다.
> 관련: [[Aura vs LWC]] · [[Aura 컴포넌트 구조]]

---

## 거버너·실행 한도 변경 요약

이번 릴리즈 개발 영역에서 **수치로 확인된 한도 변경·제약**만 모았다. 각 항목의 근거는 위 본문 절에 있다.

| # | 한도 | 이전 | Winter '27 | 근거 절 |
|---|---|---|---|---|
| 1 | Apex heap — **동기** 트랜잭션 | 6 MB | **10 MB** | [#Apex heap 한도 인상 (동기 10 MB · 비동기 25 MB)](#apex-heap-한도-인상-동기-10-mb--비동기-25-mb) |
| 2 | Apex heap — **비동기** 트랜잭션 | 12 MB | **25 MB** | 〃 |
| 3 | 프로덕션 elastic 한도의 **추가 용량 캡** | 10,000,000 잡 | **min(라이선스된 비동기 Apex 잡 한도, 2,000,000)** | [#1. Batch 잡 Elastic Limits (Beta)](#1-batch-잡-elastic-limits-beta) |
| 4 | 표준 한도 초과 시 **신규 Batch 잡 동시 실행** | — | **1개** (진행 중 Batch 잡은 처리 속도 스로틀) | 〃 |
| 5 | 비프로덕션 elastic 한도 (override 설정 시) | — | **min(override × 2, 라이선스된 표준 한도)** | [#비프로덕션 org에서 비동기 Apex 잡 한도 override (Elastic Limits 테스트)](#비프로덕션-org에서-비동기-apex-잡-한도-override-elastic-limits-테스트) |
| 6 | **Apex Symbol API 동시 호출** | — | **org당 1건** (진행 중 두 번째 요청은 실패) | [#2. Apex Symbol API (Beta) — `/tooling/symbols`](#2-apex-symbol-api-beta--toolingsymbols) |
| 7 | **Apex 통합 테스트 동시 실행** | — | **비동기 1건**, 동기 실행 미제공 | [#Apex Integration Tests — External Services · HTTP 콜아웃 (Developer Preview)](#apex-integration-tests--external-services--http-콜아웃-developer-preview) |
| 8 | Test Discovery `pageSize` (보조 소스) | — | 기본 **1,000** · 최대 **10,000** 클래스 | [#Test Discovery API — `testLevel` 파라미터](#test-discovery-api--testlevel-파라미터) |
| 9 | Request Approvals 컴포넌트의 flow 승인 프로세스 | — | **최대 10개** | [#Customization (General Setup)](#customization-general-setup) |
| 10 | User 오브젝트 필드 이력 추적 | — | **최대 20개 필드** | [#Enable Field History Tracking for Users (Generally Available)](#enable-field-history-tracking-for-users-generally-available) |

> **fabrication 방지 확인:** 위 10건 외에 이번 추출 범위(62페이지) + v68.0 Tooling API PDF의 해당 절에서 **개발 영역 거버너 수치 한도 변경은 확인되지 않았다.** SOQL row limit · CPU time · DML 행 수 · Queueable 스택 깊이 등에 대한 변경 근거는 없으므로 추가하지 않는다.

---

## 미확보 항목 (소스에서 재현 불가)

| 페이지 | 미확보 내용 | 처리 |
|---|---|---|
| `rn_apex_symbol_api` | 요청 라인(85자) + JSON 응답 발췌(861자) — 브라우저 안전 필터가 거부(**우회하지 않음**) | ✅ **해결.** 공식 **Winter27-v68-Docs/api_tooling.pdf v68.0**(인쇄 p.31–37)이 동일 리소스를 더 완전히 문서화한다. 위 Symbol API 절의 요청·응답 코드는 **PDF 원문**이다 |
| `rn_apex_integration_tests` | 샘플 통합 테스트 클래스(약 850자, 엔드포인트 URL 포함) — 필터가 거부(**우회하지 않음**) | ❌ **미확보.** PDF에도 대응 샘플 없음. **재구성하지 않음** — 동작 설명만 남기고 *Apex Developer Guide: Apex Integration Tests (Developer Preview)* 안내 |
| `rn_apex_namespace_shadowing_managed_packages` | 동적 SOQL 샘플 2건(246자 · 299자) — 필터가 거부(**우회하지 않음**) | ❌ **미확보.** PDF에도 대응 샘플 없음. **재구성하지 않음** — API 표면 목록과 *Apex Developer Guide: Prevent Field Name Collisions in Managed SOQL Queries* 안내 |
| `rn_api_nc` → *ConnectApi (Connect in Apex): New and Changed Classes and Enums* | ConnectApi 새·변경 클래스·메서드·enum **개별 목록** | ⛔ **범위 밖.** 이번 62페이지 추출에 미포함. 목록을 지어내지 않는다 |
| `rn_api_tooling_headers_rest_and_soap` | 본문 | ⚠️ **소스가 `TBD`.** 추출 실패가 아니라 **게시된 플레이스홀더** |

---

## 10월 GA 시점 재확인 목록

Winter '27 릴리즈 노트는 현재 **프리뷰** 상태이며, 프리뷰 기간 중 페이지가 추가·수정되고 있다(예: Metadata API·Tooling API 카탈로그가 2026-08-17 주에 추가). 아래는 GA 시점에 반드시 다시 확인할 지점이다.

1. **`Tooling API Headers for REST and SOAP` 페이지의 `TBD`** — 본문이 채워졌는지.
2. **`apexCompileResults` 의 소스 충돌 2건** — 둘 다 릴리즈 노트와 v68.0 PDF가 **정반대**로 서술한다(위 충돌 기록 참조).
   - **충돌 1 — `IsValid` 필드 갱신 여부:** Setup 버튼으로 컴파일에 성공했을 때 필드가 `true`로 갱신되는가.
   - **충돌 2 — 경고만 있는 결과의 반환 여부:** PDF는 `results` 에 반환되지 않는다고 하고, 릴리즈 노트 예제는 `success: true` · `problems: []` 인 항목을 `results` 에 담아 보여준다.
3. **미확보 코드 2건**(Apex 통합 테스트 샘플 · 동적 SOQL 샘플 2건) — 공식 개발자 가이드에서 확보해 보강.
4. **ConnectApi New and Changed 목록** — 별도 페이지 전수 추출.
5. **Developer Preview / Beta 상태 변화** — Apex Integration Tests · Apex Symbol API · SOQL `FORMULA()` · Batch Elastic Limits의 단계 변경.
6. **SOQL `FORMULA()` 의 프로덕션 제공 여부** — 현재 beta는 **프로덕션 org 미제공**.

---

## 관련 노트

- [[Winter '27]] — 상위 허브
- [[Winter '27/Release Updates]] — 형제 스포크. **강제 적용 시점(Enforced/Complete Steps By)의 단일 정본**
- [[Winter '27/Platform]] — 형제 스포크(Customization·Deployment·Development 섹션이 통합된 영역)
- [[Winter '27/Clouds]] — 형제 스포크(Sales·Service·Commerce·Data 360·Industries)
- [[Winter '27/Agentforce]] — 형제 스포크(Agentforce·Einstein AI)
- [[Winter '26/Development]] — 직전 릴리즈(v65.0) 개발 영역. LWC API 65.0도 "버전별 변경 없음"이었다
- [[Governor Limits]] — heap·비동기 한도의 상시 레퍼런스
- [[Batch Apex]] · [[Queueable]] · [[Transaction Finalizer]] — Elastic Limits와 CLI `Batchable`/`Queueable` 템플릿
- [[Dynamic SOQL]] · [[Database Namespace 상세]] — `Database.QueryOptions` · `SET OPTIONS` · `explicitNamespace`
- [[System Namespace]] — 새 `Limits` 메서드 6개
- [[Apex 버전별 동작 변경 레퍼런스]] — API 9.0–19.0 은퇴 경고 대응
- [[테스트 전략]] · [[Flowtesting Namespace]] · [[HttpCalloutMock]] — Test Discovery `testLevel`, 통합 테스트에서의 mock 우선순위
- [[Tooling API — 개요·REST·SOAP 호출 기초]] · [[Tooling API — SOAP·REST 헤더]] · [[Tooling API 객체 — Apex 코드·테스트·커버리지]] — `symbols`·`apexCompileResults`·`tests` 리소스
- [[LWC API 버전 관리]] · [[LWC 템플릿 기초 (데이터 바인딩·표현식)]] — API 68.0 업그레이드, 복합 템플릿 표현식
- [[Lightning Console JS API]] — `lightning/platformNavigationItemApi`
- [[lightning-datatable]] · [[lightning-slider]] — 변경 폭이 가장 큰 base 컴포넌트
- [[sf CLI 명령 카탈로그 · sfdx→sf 매핑]] · [[Scratch Org 생성과 정의 파일]] — CLI 자격 증명 변경·스크래치 org 정의
- [[DX MCP Server (Beta)]] — ApexGuru IDE 스캔·자연어 DX 작업
- [[REST API]] · [[Bulk API 2.0]] · [[GraphQL Wire Adapter]] · [[Streaming API (CometD·PushTopic·Generic Streaming)]] — API 본문 변경
- [[Release MOC]] — 릴리즈 노트 전체 지도
