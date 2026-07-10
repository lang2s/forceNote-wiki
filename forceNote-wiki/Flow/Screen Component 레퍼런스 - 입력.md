---
tags: [flow, screen-flow, screen-component, reference, input, catalog]
source: extend_click_automate.pdf (Automate Your Business Processes, Spring '26)
created: 2026-07-10
aliases: [Flow Screen Input Components, 표준 화면 컴포넌트 입력, Flow 입력 컴포넌트, Address 컴포넌트, Name 컴포넌트, Slider 컴포넌트, Toggle 컴포넌트, Flow 화면 텍스트 입력, Flow 이메일 입력, Flow 전화번호 입력, Flow URL 입력, Flow 통화 입력, Flow 날짜 입력]
---

# Screen Component 레퍼런스 - 입력

> Salesforce 표준 Flow Screen Component 33종 중 **단일 값 입력 계열 15종**(Address·Checkbox·Currency·Date·Date & Time·Email·Long Text Area·Name·Number·Password·Phone·Slider·Text·Toggle·URL)의 속성 전수 레퍼런스. Spring '26 기준.

---

## 개요 — 표준 Screen Component 33종

Salesforce는 화면에서 사용할 수 있는 입력 필드 유형을 확장하는 표준 스크린 컴포넌트를 제공한다. 더 많은 기능이 필요하면(예: 외부 라이브러리의 커스텀 스크린 컴포넌트 설치) 개발자가 커스텀 컴포넌트를 만든다 → [[Flow Screen LWC 패턴]], 실전 예시 [[quickChoice Screen Component]].

| 분류 | 컴포넌트 | 노트 |
|---|---|---|
| **입력 — 단일 값** (15) | Address, Checkbox, Currency, Date, Date & Time, Email, Long Text Area, Name, Number, Password, Phone, Slider, Text, Toggle, URL | **이 노트** |
| **선택·데이터·디스플레이·기타** (18) | Action Button, Checkbox Group, Choice Lookup, Data Table, Dependent Picklists, Display Image, Enhanced Message, File Upload, Lookup, Multi-Select Picklist, Order Management Product Selector, Picklist, Radio Buttons, Slack Channel Selector, Slack Workspace Selector, Display Text, Repeater, Section | [[Screen Component 레퍼런스 - 디스플레이·선택·기타]] |

**Editions(이 노트의 15종 공통):** Salesforce Classic(일부 org 미제공)·Lightning Experience 양쪽 / Essentials, Professional, Enterprise, Performance, Unlimited, Developer Edition.

> 반응형(reactive) 화면 — 지원 컴포넌트·reactive formula·제약은 [[Screen Flow 설계]]의 "Reactive Screen Components" 절 참조.

---

## 공통 설정 블록

PDF는 컴포넌트마다 아래 4개 블록을 동일 문구로 반복한다. 이 노트에서는 여기 1회 전문을 두고, 각 컴포넌트 절에는 `공통 블록: 표시 ✓ · 검증 ✓ · 재방문 ✓` 표기로 해당 블록의 존재 여부만 표시한다(✓ = PDF에 해당 섹션 있음, ✗ = 없음).

### 1. Set the Component Visibility (표시)

컴포넌트를 언제 표시할지 조건부 로직으로 설정. **When to Display Component** 옵션:

| 옵션 | 설명 |
|---|---|
| Always | 항상 표시 |
| When all conditions are met (AND) | 정의한 조건이 모두 충족될 때 표시. 조건 1개 이상 정의 |
| When any condition is met (OR) | 정의한 조건 중 하나 이상 충족될 때 표시. 조건 1개 이상 정의 |
| When custom conditional logic is met | 정의한 조건 로직이 충족될 때 표시. 조건 1개 이상 + 조건 로직 지정 |

### 2. Validate Input (검증)

사용자 입력의 유효성을 평가하는 수식과, 무효 시 표시할 오류 메시지 제공.

| 옵션 | 설명 |
|---|---|
| Error Message | 무효 값 입력 시 컴포넌트 아래 표시되는 오류 메시지 |
| Formula | Boolean을 반환하는 수식. `true`면 유효, `false`면 오류 메시지 표시. 필드가 비었고 필수가 아니면 검증을 수행하지 않음. 비었고 필수면 **커스텀 메시지가 아니라 기본 오류 메시지**를 표시 |

### 3. Specify the Behavior of Values on Revisited Screens (재방문 동작)

사용자가 값을 입력하고 이전 화면으로 갔다가 다시 돌아왔을 때의 동작.

| 옵션 | 설명 |
|---|---|
| Use values from when the user last visited this screen | 사용자가 지정한 값을 유지하고, 이전 화면 변경 사항을 반영하지 않음 |
| Refresh inputs to incorporate changes elsewhere in the flow | 이전 화면의 변경 사항을 반영해 값을 갱신. **일시정지 후 재개 시** 사용자 지정 값이 유지되는 컴포넌트는 Checkbox, Checkbox Group, Currency, Long Text Area, Multi-Select Picklist, Number, Password, Picklist, Radio Buttons, Text **10종뿐** |

### 4. Lightning 런타임 v58 이하 메모리 팁

Lightning runtime 버전 58 이하에서 실행되는 스크린 컴포넌트는 기본적으로 메모리가 없다. 사용자가 값을 입력한 뒤 (1) 다른 화면으로 갔다가 돌아오거나 (2) flow를 일시정지 후 재개하거나 (3) 다음 화면으로 이동하다 입력 검증 오류가 발생하면 값이 사라진다. 속성(attribute)을 설정하면 flow가 값을 기억한다. flow는 값을 자동 저장하며, 수동 저장하려면 **Manually assign variables (advanced)** 를 선택하고 속성의 output 값을 변수에 저장한다.

### 공통 속성 표기 규칙 (†)

여러 컴포넌트에 동일 문구로 반복되는 속성은 아래 전문을 기준으로 하고, 각 표에서는 †로 축약한다.

| 공통 속성 | 전문 |
|---|---|
| **API Name†** | 컴포넌트의 API명. 밑줄과 영숫자 사용 가능(공백 불가), 문자로 시작해야 하며 밑줄로 끝날 수 없고 밑줄 2개 연속 불가 |
| **Disabled†** | `true`면 사용자가 값을 수정할 수 없음. 기본값 `false`. Boolean 값 리소스 허용. **Classic 런타임 미지원** |
| **Read Only†** | `true`면 수정 불가·복사는 가능. 기본값 `false`. Boolean 값 리소스 허용. **Classic 런타임 미지원** |
| **Provide Help†** | 입력한 텍스트가 컴포넌트 옆 정보 버블(info bubble)로 제공됨 |
| **Require†** | 다음 화면으로 이동하기 전 값 입력(선택)을 요구 |
| **Required†** | `true`면 실행 사용자가 값을 입력해야 함. 기본값 `false`. Boolean 값 리소스 허용 |
| **Default Value†** | 컴포넌트에 미리 채워지는 값. 화면이 실행되지 않거나 표시 조건 미충족이면 저장값은 `null` |
| **Label†** | 실행 사용자에게 사용법을 알려주는, 컴포넌트와 함께 표시되는 텍스트 |
| **Placeholder Text†** | 필드가 비어 있을 때 표시되는 힌트 텍스트. 단일 값 리소스 허용(텍스트 취급) |

---

## Address (주소)

주소 폼 전체를 하나의 컴포넌트로 표시. org 설정에 맞게 커스터마이즈되며 State/Country Territory Picklists도 사용 가능. **Lightning runtime 필요.**

| 속성 | 설명 |
|---|---|
| API Name | † |
| City Value | City의 기본값. 단일 값 리소스(텍스트 취급) |
| Country Code | 주소의 국가 코드. Country 기본값 설정용. 단일 값 리소스(텍스트 취급) |
| Country Options | State/Country Territory Picklists에 구성된 활성 국가·영토. 콤마 구분 목록으로 오버라이드 가능. 드롭다운 옵션을 채움. 단일 값 리소스(텍스트 취급) |
| Country Value | 주소의 국가 값. Country 기본값 설정용. 단일 값 리소스(텍스트 취급) |
| Disabled | † |
| Label | 주소 필드 그룹 위 헤딩 레이블. 단일 값 리소스(텍스트 취급) |
| Postal Code Value | Postal Code의 기본값. 단일 값 리소스(텍스트 취급) |
| Required | † |
| Show Google Maps Search Field | Google Maps 기반 검색 필드 포함 여부. `true`(boolean) 입력 시 포함. 사용자가 검색 필드에서 주소를 선택하면 나머지 필드가 자동 채워짐. 기본값 `false` |
| Google Maps Search Field Label | Google Maps 검색 필드 위 레이블 |
| State or Province Code | 주/도의 코드. State/Province Options가 구성돼 있으면 이 값이 기본 선택됨. 단일 값 리소스(텍스트 취급) |
| State or Province Options | 구성된 활성 주(state) 목록. 콤마 구분 목록으로 오버라이드 가능. 드롭다운 옵션을 채움. 단일 값 리소스(텍스트 취급) |
| State or Province Value | 주/도의 값. Options 구성 시 기본 선택. 단일 값 리소스(텍스트 취급) |
| Street Value | Street의 기본값. 단일 값 리소스(텍스트 취급) |

**출력(Store) — 모두 단일 값 Text 변수 또는 record 변수의 Text 필드에 저장 가능:** City Value, Country Code, Country Value, Postal Code Value, State or Province Code, State or Province Value, Street Value.
State or Province Value 주의: **State and Country/Territory Picklists 설정이 켜진 org에서 레코드를 업데이트하려면 State or Province Code를 대신 사용.**

**Considerations**
- State/Country Territory Picklists 활성 org에서 레코드 업데이트 시 Country Value·State or Province Value 대신 **Country Code·State or Province Code 출력** 사용.
- Google Maps 검색 필드는 Playground, Experience Builder 사이트, Lightning Out, Lightning Components for Visualforce, standalone 앱에서 미지원.

공통 블록: 표시 ✓ · 검증 ✓ · 재방문 ✓

---

## Checkbox (체크박스)

예/아니오 선택을 체크박스로 제공.

| 속성 | 설명 |
|---|---|
| API Name | † |
| Default Value | † |
| Disabled | † |
| Label | † |
| Provide Help | † |

**Usage:** 체크 시 `true`, 미체크 시 `false`, 해당 화면이 실행되지 않으면 `null`로 평가.
예: 마케팅 캠페인 옵트인, 구매 후 후속 전화 동의, 중요 정책 이해 확인.

공통 블록: 표시 ✓ · 검증 ✓ · 재방문 ✓ (관련: Flow Resource Global Constant)

---

## Currency (통화)

통화 값 입력.

| 속성 | 설명 |
|---|---|
| API Name | † |
| Decimal Places | 소수점 오른쪽 자릿수를 **최대 17자리**까지 제어. 비워두거나 0이면 실행 시 정수만 표시 |
| Default Value | † |
| Disabled | † |
| Label | † |
| Provide Help | † |
| Read Only | † |
| Require | † |

공통 블록: 표시 ✓ · 검증 ✓ · 재방문 ✓

---

## Date (날짜)

날짜 값 입력.

| 속성 | 설명 |
|---|---|
| API Name | † |
| Default Value | † |
| Disabled | † |
| Label | † |
| Provide Help | † |
| Read Only | † |
| Require | † |

공통 블록: 표시 ✓ · 검증 ✓ · 재방문 ✓

---

## Date & Time (날짜와 시간)

날짜+시간 값 입력 (예: 예약 요청). 속성은 Date와 동일: API Name†, Default Value†, Disabled†, Label†, Provide Help†, Read Only†, Require†.

공통 블록: 표시 ✓ · 검증 ✓ · 재방문 ✓

---

## Email (이메일)

이메일 주소 입력. **Lightning runtime 필요.**

| 속성 | 설명 |
|---|---|
| API Name | † |
| Disabled | † |
| Label | 이메일 필드 위에 표시되는 레이블. 단일 값 리소스(텍스트 취급) |
| Placeholder Text | † |
| Read Only | † |
| Required | † |
| Value | 이메일 필드의 값. 설정하면 필드가 미리 채워짐. 사용자가 입력한 값을 쓰려면 이 속성의 output을 변수에 저장. 단일 값 리소스(텍스트 취급) |

**출력:** 모든 속성 저장 가능하지만 **Value**가 가장 유력 — 사용자가 입력한 이메일 주소를 Value 속성으로 flow 변수에 저장.

공통 블록: 표시 ✓ · 검증 ✓ · 재방문 ✓

---

## Long Text Area (장문 텍스트)

한두 문단 분량의 텍스트 입력. 속성: API Name†, Default Value†, Disabled†, Label†, Provide Help†, Read Only†, Require†.

공통 블록: 표시 ✓ · 검증 ✓ · 재방문 ✓

---

## Name (이름)

여러 이름 값을 하나의 컴포넌트로 입력. Text 필드 여러 개로도 가능하지만 구성이 훨씬 많이 든다. **Lightning runtime 필요.**

| 속성 | 설명 |
|---|---|
| API Name | † |
| Disabled | † |
| Fields to Display | 기본으로 First Name·Last Name만 표시. 표시할 필드를 콤마 구분 목록으로 지정: `firstName`, `lastName`, `middleName`, `informalName`, `salutation`, `suffix`. **표시 순서는 제어하지 않음.** 단일 값 리소스(텍스트 취급) |
| First Name | First Name 필드 값. 설정 시 미리 채움. 사용자 입력을 쓰려면 output을 변수에 저장. 단일 값 리소스(텍스트 취급) |
| Informal Name | Informal Name 필드 값. 동일 규칙 |
| Label | 이름 필드들 위에 표시되는 레이블. 단일 값 리소스(텍스트 취급) |
| Last Name | Last Name 필드 값. 동일 규칙 |
| Middle Name | Middle Name 필드 값. 동일 규칙 |
| Read Only | † |
| Salutation | Salutation 필드 값. 동일 규칙 |
| Salutation Options | 기본 옵션은 Mr., Mrs., Ms. 콤마 구분 값 목록으로 오버라이드. 단일 값 리소스(텍스트 취급) |
| Suffix | Suffix 필드 값. 동일 규칙 |

전체 필드 표시 예 (PDF 원문):

```text
firstName, lastName, middleName, informalName, salutation, suffix
```

**출력 — 모두 단일 값 Text 변수 또는 record 변수의 Text 필드:** First Name, Informal Name, Last Name, Middle Name, Salutation, Suffix.

공통 블록: 표시 ✓ · 검증 ✓ · 재방문 ✓

---

## Number (숫자)

숫자 값 입력.

| 속성 | 설명 |
|---|---|
| API Name | † |
| Decimal Places | 소수점 오른쪽 자릿수를 최대 17자리까지 제어. 비워두거나 0이면 정수만 표시 |
| Default Value | † |
| Disabled | † |
| Label | † |
| Provide Help | † |
| Read Only | † |
| Require | † |

공통 블록: 표시 ✓ · 검증 ✓ · 재방문 ✓

---

## Password (비밀번호)

민감 정보(예: 주민/사회보장번호) 입력 — 입력 텍스트가 마스킹된다.

> [!warning] 이 컴포넌트는 입력값을 **암호화하지 않는다.** Assignment 요소나 Display Text 컴포넌트 등에서 Password 컴포넌트를 참조하면 값이 **마스킹되지 않고 노출**된다.

| 속성 | 설명 |
|---|---|
| API Name | † |
| Default Value | † |
| Disabled | † |
| Label | † |
| Provide Help | † |
| Read Only | † |
| Require | † |

공통 블록: 표시 ✓ · 검증 ✓ · 재방문 ✓

---

## Phone (전화)

전화번호 입력. **Lightning runtime 필요.**

| 속성 | 설명 |
|---|---|
| API Name | † |
| Label | 전화 필드 위에 표시되는 레이블. 단일 값 리소스(텍스트 취급) |
| Disabled | † |
| Pattern | 값의 유효성을 판정. **기본 패턴 없음.** 단일 값 리소스(텍스트 취급) |
| Placeholder Text | † |
| Read Only | † |
| Required | † |
| Value | 전화 필드 값. 설정 시 미리 채움. 사용자 입력을 쓰려면 output을 변수에 저장. 단일 값 리소스(텍스트 취급) |

**출력:** Value가 가장 유력 — 입력된 전화번호는 Value 속성을 flow 변수에 매핑.

공통 블록: 표시 ✓ · 검증 ✓ · 재방문 ✓

---

## Slider (슬라이더)

숫자 값을 시각적으로 지정. **Lightning runtime 필요.**

| 속성 | 설명 |
|---|---|
| API Name | † |
| Label | 슬라이더 위에 표시되는 레이블. 단일 값 리소스(텍스트 취급) |
| Disabled | † |
| Range Maximum | 슬라이더 범위 최댓값. **기본 100.** 단일 값 Number 리소스 |
| Range Minimum | 슬라이더 범위 최솟값. **기본 0.** Number 리소스 |
| Slider Size | 슬라이더 크기. 허용값: `x-small`, `small`, `medium`, `large`. 단일 값 리소스(텍스트 취급) |
| Step Size | 슬라이더를 단계로 분할. **기본 1.** 예: 범위 0–100에서 Step Size 10이면 10 단위로 선택. 0.1·5 같은 값도 가능. 단일 값 Number 리소스 |
| Value | 슬라이더 위치가 나타내는 기본값. Inputs 탭에서 설정하면 값이 미리 지정됨. 단일 값 Number 리소스 |

**출력:** Value가 가장 유력 — 사용자가 선택한 값은 Value 속성을 **Number** flow 변수에 매핑.

공통 블록: 표시 ✓ · 검증 ✓ · 재방문 ✓

---

## Text (텍스트)

한 줄 텍스트 입력 (예: 회사명). 속성: API Name†, Default Value†, Disabled†, Label†, Provide Help†, Read Only†, Require†.

공통 블록: 표시 ✓ · 검증 ✓ · 재방문 ✓

---

## Toggle (토글)

토글 스위치. **Lightning runtime 필요.**

| 속성 | 설명 |
|---|---|
| Active Label | 토글 활성 시 토글 아래 표시되는 레이블. 활성의 의미를 명확히 하는 용도. 기본 레이블 "Active". 단일 값 리소스(텍스트 취급) |
| API Name | † |
| Disabled | † |
| Inactive Label | 토글 비활성 시 아래 표시되는 레이블. 기본 레이블 "Inactive". 단일 값 리소스(텍스트 취급) |
| Label | 토글 옆에 표시되며 사용자가 무엇을 켜는지 설명. 단일 값 리소스(텍스트 취급) |
| Value | 활성(`$GlobalConstant.True`)/비활성(`$GlobalConstant.False`). **Inputs 탭**에서 설정하면 기본 상태 제어, 사용자 선택을 변수에 저장하려면 **Outputs 탭**에서 설정. 단일 값 Boolean 리소스 |

**출력:** Value가 가장 유력 — Boolean flow 변수 또는 record 변수의 checkbox 필드에 매핑.

공통 블록: 표시 ✓ · 검증 ✓ · 재방문 ✓

---

## URL

URL 값 입력. **Lightning runtime 필요.**

| 속성 | 설명 |
|---|---|
| API Name | † |
| Disabled | † |
| Label | URL 필드 위에 표시되는 레이블. 단일 값 리소스(텍스트 취급) |
| Pattern | 값 유효성 판정. **기본 패턴은 첫 문자가 letter이고 콜론(`:`)을 포함하는지 검증.** 특정 포맷을 강제하려면 정규식 사용 — 정규식이 `https://`·`file:///` 같은 유효한 프로토콜을 확인하도록 작성. 단일 값 리소스(텍스트 취급) |
| Read Only | † |
| Required | † |
| Value | URL 필드 값. 설정 시 미리 채움. 사용자 입력을 쓰려면 output을 변수에 저장. 단일 값 리소스(텍스트 취급) |

Pattern 예 — 보안 HTTP 프로토콜(`https://`)과 특정 도메인(acmewireless.com) 확인 (PDF 원문 발췌):

```regex
^https?://(?:www\.)?acmewireless\.com/?.*
```

**출력:** Value가 가장 유력 — 입력된 URL은 Value 속성을 flow 변수에 매핑.

공통 블록: 표시 ✓ · 검증 ✓ · 재방문 ✓

---

## 관련 노트

- [[Screen Component 레퍼런스 - 디스플레이·선택·기타]] — 나머지 18종 (선택·데이터 테이블·파일·Slack·디스플레이·Repeater·Section)
- [[Screen Flow 설계]] — Screen Flow 메타데이터 구조 + Reactive Screen Components (반응형 화면)
- [[quickChoice Screen Component]] — 표준으로 부족할 때의 커스텀 선택 컴포넌트 (표준 vs 커스텀)
- [[Flow Screen LWC 패턴]] — 커스텀 스크린 컴포넌트 제작 기본 패턴
