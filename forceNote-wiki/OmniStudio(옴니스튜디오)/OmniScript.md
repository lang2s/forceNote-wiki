---
tags: [omnistudio, omniscript, omniprocess, low-code, guided-process, lwc]
source: help.salesforce.com — OmniStudio OmniScript (xcloud.os_omniscript_basics_8079·os_omniscripts_8355·os_create_an_omniscript_8570·os_omniscript_element_reference_10533·os_omniscript_input_elements_16001·os_omniscript_display_elements_13849·os_omniscript_action_elements_10951·os_omniscript_group_elements_13946·os_omniscript_function_elements_13882·os_common_omniscript_element_properties_definitions__10687·os_embed_an_omniscript_in_another_omniscript_20581·requirements_for_creating_a_custom_lightning_web_component_for_omniscripts·os_enable_multi_language_omniscript_support_20725, 접속일 2026-07-13) [Tier 2]
created: 2026-07-13
aliases: [OmniScript, 옴니스크립트, OmniProcess, guided process, element reference, input elements, action elements, 다단계 폼, 가이드 프로세스, OmniscriptBaseMixin, 커스텀 LWC]
---

# OmniScript

> 클릭(선언형)으로 만드는 다단계 가이드 디지털 인터랙션 — element를 캔버스에 드래그해 데이터 조회·입력·저장·액션을 구성하고, 활성화하면 재사용 가능한 Lightning Web Component로 컴파일된다.

---

## OmniScript란

OmniScript는 사용자를 복잡한 프로세스에 따라 빠르고 개인화된 일관된 응답으로 안내하는 **가이드형 인터랙션**이다. 코드가 아니라 클릭으로 만드는 선언형(declarative) 스크립팅 도구로, 서로 다른 타입의 element를 캔버스에 드래그해 구조를 구성한다.

- **데이터 조회·표시·수정·저장·액션 실행** — 5가지 기본 작업을 element로 수행한다. Salesforce 오브젝트 또는 내·외부 데이터 소스에서 데이터를 가져오거나 갱신하며, Data Mapper·Integration Procedure·REST API·Apex를 통해 데이터에 접근한다.
- **멀티채널 배포** — 하나의 OmniScript를 Salesforce 앱, 모바일 디바이스, Experience Cloud 사이트, 웹 페이지에 배포할 수 있다. Lightning 페이지, 커스텀 LWC, Lightning 탭에서 실행(launch)한다.
- **실행 위치 예시** — 계정 페이지의 액션 버튼, 카드의 액션 링크 등 어디서든 실행할 수 있다.
- **드래그 앤 드롭 디자이너** — element를 캔버스에 놓고 탭 이동 없이 프로퍼티를 편집한다. 활성화(activation)는 즉시(instant) 반영된다.

### OmniProcess 객체와 컴파일된 LWC

OmniScript 정의는 **Omni Process(OmniProcess) 커스텀 오브젝트**에 저장된다. 활성화하면 OmniScript는 **Lightning Web Component로 컴파일**된다. 비즈니스 로직에 따라 일부 사용자는 생성된 OmniScript LWC를 수정하기도 한다.

컴포넌트 이름은 **Type + SubType + Language** 조합으로 만들어진다.

> PDF/원문: *"an Omniscript where Type=account, SubType=Create, and Language=English generates an LWC named `accountCreateEnglish`."*

- **Type** — 반드시 문자로 시작하고, 공백·언더스코어 없이 영숫자만 사용한다.
- **SubType** — 영숫자 텍스트, 공백·언더스코어 없이.
- **Language** — 언어. (다국어는 아래 [다국어](#다국어multi-language) 참조.)
- **길이 규칙** — 결합된 Type + SubType + Language는 **60자를 초과하면 안 된다**.

생성 절차: App Launcher에서 Omniscripts → New → Name 입력 → Type·SubType·Language 입력 → (선택) Description → Save.

- **Considerations for Single-Language OmniScripts** — 단일 언어 OmniScript에서는 표준 에러 메시지 등 시스템 라벨 번역을 OmniStudio가 사용자 locale에 맞춰 자동 표시한다. (예: locale이 일본어면 시스템 에러 메시지도 일본어로.)
- **Property Set 업그레이드** — 기존 OmniScript를 디자이너에서 쓸 때 새 버전을 만들어 property set을 갱신한다. 여러 개발자가 같은 OmniScript를 버전 없이 쓰면 디자이너에서 에러가 날 수 있어 property set 업그레이드로 예방·해결한다.

---

## Element Reference — 마스터 카탈로그 (8 카테고리)

OmniScript에서 사용 가능한 element는 아래 카테고리로 조직된다. **각 element는 확장 가능한(extendable) LWC**를 사용한다. 캔버스에 드래그하면 디자이너에 필드 라벨이 보이고, 관리형 패키지 디자이너에서는 element 이름이 보인다.

| # | 카테고리 | 용도 |
|---|---|---|
| 1 | **Common Element Properties** | 모든 element가 공유하는(일부는 element별 고유) 설정. Designer의 Properties pane에서 편집 |
| 2 | **Activate Elements** | 비활성(inactive) element를 Navigation Panel에서 선택해 활성화 |
| 3 | **Group Elements** | element를 조직 — step으로 섹션 분할, edit block으로 레코드 추가/편집/삭제, radio group으로 설문, type ahead block으로 자동완성 |
| 4 | **Data Mapper Action Elements** | 하나 이상의 관련 Salesforce 오브젝트에서 데이터를 조회·기록·재구조화 (상세는 [[Data Mapper (DataRaptor)]] 노트에 위임) |
| 5 | **Action Elements** | 데이터 get/update, 액션 연쇄 호출, 이메일·서명 문서 전송, 페이지 리디렉트 등 실행 |
| 6 | **Display Elements** | 리치 텍스트·이미지를 화면에 표시 (Line Break, Text Block) |
| 7 | **Function Elements** | Formula/Aggregate 계산, Messaging 검증 메시지 |
| 8 | **Input Elements** | 이메일·파일·날짜·비밀번호 등 데이터 타입별 입력, 목록 선택(radio·checkbox·multi-select·select·disclosure) |

> 추가 카테고리: **Omniscripts** — 재사용 가능한 OmniScript를 다른 OmniScript에 임베드하는 element. ([임베드](#임베드데이터-흐름) 참조.)

---

## Input Elements (전수 — 21종)

사용자가 데이터를 변경·추가·삭제할 때, 데이터 타입에 맞는 input element를 드래그한다. 프로퍼티에서 name·label·기타 설정을 지정한다.

| Element | 용도 |
|---|---|
| **Checkbox** | boolean 입력 컨트롤. 사용자의 yes/no를 레코드의 true/false 필드에 매핑. Data JSON에 true/false 반환 |
| **Currency** | 통화 금액 입력. 소수 자리수, 최소·최대값 등 기본 포맷 옵션 갱신 |
| **Custom LWC Element** | OmniScript element 컴포넌트를 **확장하지 않는** 커스텀 LWC를 OmniScript에 추가 |
| **Date** | date picker로 날짜 선택. 최소·최대 날짜, 날짜 포맷 설정 |
| **Date/Time** | 날짜와 시간을 함께 입력. date/time 포맷 설정 |
| **Time** | 시간 목록에서 선택. 표시 포맷·시간 간격 설정 |
| **Disclosure** | 고지(disclosure) 문안 동의. 리치 텍스트 에디터로 본문 입력 |
| **Email** | 이메일 주소 입력. Validation Options로 기본 허용 포맷 갱신 |
| **Lookup** | 텍스트 입력으로 쿼리를 실행해 Salesforce 데이터 조회. 결과는 value-label 쌍으로 반환되어 드롭다운에서 선택 가능 |
| **Number** | 숫자 입력. mask 설정으로 입력 제한 |
| **Password** | 비밀번호 입력. 최소·최대 길이 설정 |
| **Multi-Select** | 여러 항목 선택. 세로·가로·이미지로 표시. 읽기전용 이미지는 grayscale(커스텀 CSS로 컬러 가능) |
| **Select** | 드롭다운 선택. 텍스트 입력으로 필터. 옵션은 Apex 클래스·메서드 또는 Salesforce 오브젝트에서 가져옴 |
| **Radio** | 여러 항목 중 하나 선택. 세로·가로·이미지로 표시 |
| **Range** | 지정된 범위에서 숫자 선택. 증분값 지정, static value로 최소·최대 정의 |
| **Telephone** | 전화번호 입력. 길이·포맷 제한 |
| **Text Area** | 여러 줄 텍스트 입력. 문자 수 제한 |
| **Text** | 한 줄 텍스트 입력. 최소·최대값으로 길이 제한, mask 프로퍼티로 허용 정보 설정 |
| **URL** | 웹 주소 입력 (예: `https://salesforce.com`) |
| **File** (Upload) | 파일 업로드. 업로드 상세는 Data JSON의 Files 노드에 추가 |
| **Image** (Upload) | 이미지 업로드. 업로드 상세는 Data JSON의 Files 노드에 추가 |

> **옵션 추가** — Select·Multi-Select·Radio는 element 프로퍼티의 Options 섹션에서 `+ Add New Option`으로 값을 정의한다. Select에 값이 정의되지 않으면 Undefined Value가 반환된다.
> 각 element의 상세 how-to(클릭 패스)는 공식 문서에 위임한다.

---

## Display Elements

리치 텍스트·이미지를 화면에 표시해 UI를 향상한다.

| Element | 용도 |
|---|---|
| **Line Break** | step 내 다른 element를 분리. line break 뒤 element는 폭과 무관하게 다음 줄에서 시작. 새 줄에서 시작할 element 바로 위에 배치 |
| **Text Block** | 리치 텍스트 에디터로 텍스트·이미지·기타 리치 콘텐츠 추가 (FlexCard에서도 동일) |

---

## Action Elements (전수)

액션 element는 데이터 get/update, 액션 연쇄 호출, 이메일·서명 문서 전송, 페이지 리디렉트 등을 실행한다. Step 또는 Block 안에 놓으면 **버튼**으로 렌더되고, step 사이에 놓으면 **원격(remote)** 으로 실행된다. 어느 경우든 redirect page를 지정할 수 있고, 버튼이면 소스 step으로 돌아간다.

Integration Procedure나 Data Mapper 액션 element로 여러 필드를 prefill할 수 있다 — 결과가 OmniScript JSON을 갱신하면 런타임에 필드를 prefill한다.

> Note: OmniScript element와 Data Mapper 응답 노드에는 **고유한 이름**을 쓴다.

| Action Element | 용도 |
|---|---|
| **Decision Matrix** | 지정 입력으로 decision matrix를 호출하고 매칭 결과를 OmniScript에 반환 |
| **Delete** | Object Record Id로 하나 이상의 sObject 레코드 삭제. Id(또는 Id 목록)는 merge field로 참조하는 것이 모범 사례 |
| **Expression Set** | Business Rules Engine의 expression set 호출·결과 반환. 조건 평가·수학 연산·decision table/matrix 조회·다중 변환 동시 수행 |
| **Email** | 템플릿 또는 커스텀 메시지로 알림/공지 이메일 전송. 주소·본문에 Salesforce 오브젝트·기타 소스 데이터 사용 |
| **PDF** | Data Mapper로 기존 PDF 폼을 채움 |
| **HTTP** | 코딩·Salesforce API 호출 없이 내·외부 웹 서비스 호출. Apex·Named Credentials·SOAP/XML·Web을 허용하는 HTTP API 호출, OmniScript JSON을 입력으로 사용 |
| **Integration Procedure** | Integration Procedure를 호출해 Salesforce·외부 데이터 조회. JavaScript 또는 Apex Service를 통해 UI 없는 headless 서비스로 다중 액션 실행 |
| **Navigate** | 다양한 Salesforce 페이지·앱·리소스를 OmniScript에서 열기 |
| **Remote** (Apex) | Remote element로 Apex 클래스 호출. OmniScript JSON을 입력으로 사용 |
| **DocuSign Signature** | OmniScript 안에서 문서 서명·다운로드. Data Mapper Transform으로 필드 매핑 후 실행하면 prefill된 문서의 DocuSign 창이 열리고, 사용자는 서명/거부 후 진행 |
| **DocuSign Envelope** | prefill된 문서를 서명/검토용으로 한 명 이상 수신자에게 이메일 전송. Data Mapper Transform으로 필드 매핑 후 실행 |
| **Set Errors** | 미래 step의 조건에 따라 이전 step의 element에 에러/검증 메시지 추가. step 이후 실행되어 커스텀 에러 메시지와 함께 초기 step으로 사용자를 되돌림 |
| **Set Values** | 후속 step의 element 값 설정, JSON 노드 rename, 동적 값 생성, 데이터 연결(concatenate). merge field로 다른 element의 JSON 데이터 접근 |

**관련 지원 토픽 (element가 아닌 설정/패턴):**

- **Common Action Element Properties** — 액션 element 프로퍼티 설명.
- **Emailing an OmniScript** — OmniScript 링크를 Contact·Lead·User에게 이메일로 보내려면, remote action으로 이메일을 보내는 Integration Procedure를 만들어 OmniScript나 Apex에서 호출한다.
- **Set Up Access to Remote Action APIs** — OmniScript·FlexCard·Classic Card 등에서 호출하는 remote action의 Apex 클래스(Vlocity Open Interface Apex 클래스) 접근 설정.

> **Data Mapper Action** 카테고리(retrieve/write/restructure)의 상세는 [[Data Mapper (DataRaptor)]] 노트에 위임한다. 여기서는 액션 element로 Data Mapper를 호출할 수 있다는 점만 명시한다.

---

## Group Elements

group 카테고리로 element를 조직한다.

| Group Element | 역할 |
|---|---|
| **Step** | 사용자에게 **페이지**를 표시 — 입력을 요청하거나 정보를 표시. 마지막을 제외한 모든 Step에는 Previous 버튼이 있음. OmniScript를 섹션으로 분할 |
| **Block** | Step 내 논리적 element 그룹 결합 → 중첩 JSON 데이터 생성. Step 안에 포함되며 **repeat 가능**해 배열 데이터 캡처(예: street·city·state·postal code를 address block으로) |
| **Action Block** | 여러 OmniScript Action을 **비동기(병렬)** 로 실행하도록 그룹화. Action Block 내 액션은 병렬 실행되며 Action Block 설정을 상속 |
| **Edit Block** | 한 페이지에서 여러 Salesforce/외부 **레코드를 생성·편집·삭제**. 예: 계정의 Contact 정보 수집 시 각 Contact마다 레코드 추가 |
| **Type Ahead Block** | edit block에서 사용자가 입력하는 동안 가능한 항목을 제안(autosuggest/autocomplete) |
| **Radio Group** | 질문을 설문(questionnaire) 형식으로 생성·표시 |

> **Edit Block vs Block 선택 기준** — block 반복 제한, sObject 직접 수정, 접힘 상태에서 필드 표시, 다른 레이아웃 표시, Custom LWC element 사용 필요 여부로 판단한다.

---

## Function Elements

| Function Element | 용도 |
|---|---|
| **Formula / Aggregate** | 계산된 값을 설정하고 여러 필드에 걸쳐 데이터를 평가하는 expression 생성. 복잡한 계산은 Formula, **배열 입력의 복잡한 계산**은 Aggregate. (예: qualifying life event 날짜가 오늘로부터 30일 이내인지 판단하는 formula) |
| **Messaging** | validate expression이 True/False인지에 따라 comments·requirements·success·warning 메시지 표시. formula/aggregate 등 생성 후 구성. 메시지에 merge field 지원 |

---

## Common Element Properties (전수 — 프로퍼티 표)

모든 element가 공유하는 설정(일부는 element별 고유이며 모든 element에서 제공되지는 않음). Designer의 Properties pane에서 편집한다.

| Property | 설명 |
|---|---|
| **Add Condition** | element의 Conditional View에 추가 테스트 조건 추가 |
| **Add Group** | 조건을 그룹화해 복합 expression 생성. 그룹은 별도 AND/OR 연산자를 가짐 (예: 두 그룹을 OR로 연결, 각 그룹 내부는 AND) |
| **Available For Prefill When Hidden** | 조건으로 숨겨졌을 때도 Data JSON이 element를 prefill 가능 |
| **Autocomplete Input** | 입력의 정보 타입에 따라 값 자동완성 (예: Telephone에 `tel` 추가 시 전화번호 자동완성). 전체 속성은 HTML autocomplete 속성 참조 |
| **Conditional View** | 조건 충족 시 element가 표시/편집 가능/필수로 됨. Value 필드는 merge 구문 지원 |
| **Conditional Type** | 조건이 true일 때 element를 show/disable/read only/required 중 무엇으로 할지 결정 |
| **Control Width** | 페이지에서 컨트롤의 폭(1–12 범위) |
| **Default Value** | element 기본값 설정. 이미 prefill된 값은 덮어쓰지 않음. merge 구문 지원 |
| **Element Name** | element의 고유 식별자. 공백 불가, OmniScript 내 고유해야 함 |
| **Field Width** | `Label outside of field` 체크 시 표시. 입력 필드 폭을 Control Width와 별개로 지정(라벨이 입력보다 길 때 유용) |
| **Help Text** | 사용자가 help 아이콘 위에 호버 시 표시되는 텍스트 |
| **Help Text Position** | help text 위치 지정 |
| **Label outside of field** | input 컴포넌트에서 라벨을 필드 밖에 표시할지. Lightning Experience에서만 유효 |
| **Label** | 컨트롤 라벨 표시 |
| **Mask** | 사용자 입력 포맷 설정. A=문자, 9=숫자, *=임의 문자, `[ ]`=선택 문자 (예: `(999) 999-9999`). 텍스트 필드에 Mask 설정 시 커스텀 에러 대신 기본 에러 메시지 표시 |
| **Maximum Length** | 입력 가능한 최대 문자 수 |
| **Minimum Length** | 입력 가능한 최소 문자 수 |
| **Options** | 드롭다운·multi-select·radio 컨트롤의 입력 선택지 배열 |
| **Pattern Error Text** | 입력이 expression과 불일치 시 표시 메시지 |
| **Pattern** | 제출 전 데이터 검증 강제. 복잡한 패턴은 미지원(단순 패턴 매칭). regex와 커스텀 에러 텍스트 허용 |
| **Placeholder** | 빈 필드에 placeholder 텍스트 표시. masking 활성 시 미적용 |
| **Read-Only** | true면 사용자가 필드 값 수정 불가 |
| **Copy Elements / Repeat** (관리형 패키지에서는 Repeat) | true면 사용자가 `+`로 element/element 블록을 복사 |
| **Clone When Repeating** (관리형 패키지에서는 Repeat Clone) | true면 element/블록 값이 반복 인스턴스에 복사됨 |
| **Limit Repeat** | 반복 가능 횟수 지정 (예: 최대 2회면 Repeat Limit=1) |
| **Required** | 폼 제출을 위해 값 입력이 필수인지 |
| **Show/Hide Operator** | 다중 조건 렌더 방식. All Conditions Are Met=AND, Any Condition Is Met=OR |
| **Show Message As** | 메시지를 inline 또는 toast로 표시 |
| **Toast Mode** | toast 지속성. Sticky=사용자가 닫을 때까지, Pester=3초, Dismissable=3초 또는 닫을 때까지 |
| **Extra Payload** | 추가 Key/Value 쌍 전송. merge field 구문 지원 |
| **Remote Class** | Vlocity Open Interface Class 지정 |
| **Remote Method** | Vlocity Open Interface Method 지정 |
| **Remote Options** | 클래스 호출 추가 옵션의 Key/value 쌍 |

---

## 커스텀 LWC 확장

OmniScript element를 확장하거나 독립 실행형 커스텀 컴포넌트를 만들 때의 요건(OmniStudio LWC와 호환되게).

- **OmniscriptBaseMixin을 확장하는 커스텀 LWC** — OmniScript element LWC를 확장·오버라이드할 수 없다. 반드시 **Custom LWC input element**를 통해 OmniScript에 사용해야 한다.
- **독립 실행형(standalone) 컴포넌트** — OmniScript element LWC를 확장할 수 없고, `OmniscriptBaseMixin`도 확장할 수 없다. OmniScript와는 **`omniscriptaggregate` 이벤트**를 통해서만 상호작용한다.
- **Debug Mode** — 커스텀 LWC는 Debug Mode가 켜져야 에러를 throw한다.
- **isExposed** — OmniStudio LWC와 호환되도록 XML 구성 파일에 아래 메타데이터 태그를 `true`로 설정한다.

```xml
<!-- 원문 발췌 — 커스텀 LWC XML 구성 -->
<isExposed>True</isExposed>
```

- **JSON escape** — 커스텀 LWC에서 OmniStudio LWC로 데이터를 넘길 때 JSON 검증 에러를 막으려면 큰따옴표 앞에 백슬래시 escape 문자를 붙인다(`\"` 형태). 작은따옴표는 escape 불필요.
- 커스텀 컴포넌트 패키지를 설치하고, 컴포넌트의 프로퍼티·속성·메서드는 OmniScript ReadMe Reference에서 확인한다.

> OmniScript를 렌더하는 LWC base component `lightning-omnistudio-omniscript`의 사용법은 기존 LWC 노트에 있으므로 여기서는 언급만 한다.

---

## 다국어(Multi-Language)

하나의 OmniScript를 여러 언어로 실행하려면 custom label을 사용한다. 활성화는 **Omni Process 오브젝트**를 Salesforce Setup에서 수정해 한다.

1. Setup → Object Manager → **Omni Process** 오브젝트 → 커스텀 오브젝트 정의 표시.
2. Fields and Relationships → **Language** 필드 접근.
3. Language Picklist Values 관련 목록에 `Multi-Language`가 없으면 New 클릭.
4. `Multi-Language`를 추가하고 Save.
5. OmniScript에서 Edit → Language를 `Multi-Language`로 설정.

> 단일 언어 OmniScript는 시스템 라벨 번역이 사용자 locale에 맞춰 자동 적용된다(위 "Considerations" 참조).

---

## 임베드·데이터 흐름

### OmniScript 안에 OmniScript 임베드

OmniScript를 하나 이상의 기존 OmniScript에서 **재사용**할 수 있다. 작은 스크립트를 만들어 하나 이상의 부모 스크립트에 조립한다. 임베드된 OmniScript는 다른 element처럼 동작한다.

- **제약** — 재사용 OmniScript는 다른 재사용 OmniScript를 포함할 수 없다. 재사용 OmniScript의 어떤 element도 부모 스크립트의 element와 같은 이름을 가질 수 없다. 재사용 OmniScript는 부모 스크립트의 구성(configuration)을 채택한다.
- **Set Values 이름 충돌** — 각 임베드 OmniScript는 Set Values element에서 고유한 Element Name JSON 노드를 정의해야 한다. 같은 부모의 두 자식이 같은 JSON 노드에 값을 설정하면, 둘 다 조건부로 실행돼도 **첫 번째 자식의 값만** 설정된다.
- **재사용 절차** — 재사용할 OmniScript에서 Setup → Reusable 선택 → 활성화 → 부모 OmniScript의 elements 패널에서 Omniscripts 섹션 확장 → 드래그.
- **활성/비활성 전파** — 임베드 스크립트를 활성/비활성하면 Salesforce가 활성화된 모든 부모 OmniScript를 갱신한다. Affected Omniscripts를 확인 후 Proceed.
- **조건부 실행** — 부모의 Conditional View 프로퍼티로 특정 조건에서만 임베드 OmniScript를 실행할 수 있다. 실행 중 조건이 바뀌면 이후 임베드 element는 실행되지 않고, 조건이 false인 element는 skip된다.

### 데이터 흐름 (Data JSON)

- OmniScript는 런타임 데이터를 **Data JSON**에 보관한다. input element 값(Checkbox의 true/false, File/Image 업로드의 Files 노드 등)이 여기에 쌓인다.
- **Merge field** — Set Values·Messaging·Conditional View·Default Value 등에서 merge 구문으로 다른 element의 Data JSON 값을 참조한다.
- **Prefill** — Integration Procedure/Data Mapper 액션 결과가 Data JSON을 갱신하면 런타임에 필드를 prefill한다. `Available For Prefill When Hidden`이 true면 숨겨진 element도 prefill된다.

---

## 관련 노트

- [[OmniStudio 개요·오리엔테이션]] — 시리즈 허브·오리엔테이션
- [[FlexCard]] — OmniScript를 임베드·실행하는 카드 컴포넌트
- [[Data Mapper (DataRaptor)]] — Data Mapper Action element·PDF/DocuSign 필드 매핑의 소관
- [[Integration Procedure]] — Integration Procedure Action·headless 서비스의 소관
- [[OmniStudio Formula Functions 레퍼런스]] — OmniScript element·Set Values에서 쓰는 공용 수식 함수
- `lightning-omnistudio-omniscript` (OmniScript 렌더 LWC base component) — 기존 LWC 노트 참조
