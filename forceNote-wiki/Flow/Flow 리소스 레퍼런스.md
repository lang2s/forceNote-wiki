---
tags: [flow, resource, global-variable, choice, stage, constant, formula, text-template, reference]
source: extend_click_automate.pdf (Automate Your Business Processes, Spring '26)
created: 2026-07-10
aliases: [Flow Resources, Flow 리소스, Flow Global Variables, Flow 전역 변수, Choice Resource, Choice 리소스, Record Choice Set, Collection Choice Set, Picklist Choice Set, Flow Stage, Stage 리소스, Text Template, Global Constant, EmptyString, $Record, $Record__Prior, $Flow.CurrentStage, $Flow.ActiveStages]
---

# Flow 리소스 레퍼런스

> Flow에서 참조 가능한 값 = 리소스. 17종 리소스 전수, 전역 변수($Api~$UserRole) 16종 전수, $Flow 하위 변수 8종, Choice 4종, Stage 진행 표시 패턴을 다루는 레퍼런스.

---

## 리소스 종류 전수 (17종)

Flow Builder의 **Manager 패널**에 현재 Flow에서 사용 가능한 리소스가 표시된다. 일부는 **New Resource** 버튼으로 직접 생성하고, 일부(전역 상수·전역 변수)는 시스템이 제공하며, 일부는 요소를 추가할 때 자동 생성된다(예: Decision 요소 추가 시 outcome마다 리소스 자동 생성).

> "Resources 탭에서 생성" 컬럼의 체크마크는 pdftotext로 안 잡혀 **PDF 페이지를 이미지화(pdftoppm)해 셀별로 직접 확인**한 값이다. PDF 원문 표기: 체크마크 = 생성 가능(✅), 빈칸 = 직접 생성 불가(❌).

| 리소스 | 설명 | Resources 탭에서 생성 |
|---|---|---|
| **Actions** | Action 요소의 출력값이 자동으로 저장되는 리소스 | ❌ (자동 생성) |
| **Choice** | Radio Buttons·Multi-Select Picklist 같은 화면 컴포넌트에서 쓸 선택 옵션 1개를 생성 | ✅ |
| **Collection Choice Set** | 기존 레코드 컬렉션(또는 외부 데이터)으로 선택지 집합 생성 | ✅ |
| **Constant** | Flow 전체에서 사용하는 고정값 저장 | ✅ |
| **Decision Outcome** | Decision 요소 추가 시 각 outcome이 Boolean 리소스로 제공. 해당 outcome 경로가 인터뷰에서 이미 실행됐으면 값이 `True` | ❌ (자동 생성) |
| **Element** | Flow에 추가한 모든 요소는 decision outcome 조건에서 `was visited` 연산자와 함께 리소스로 사용 가능. 인터뷰에서 실행되면 "visited". fault connector를 지원하는 요소는 Boolean 리소스로도 제공 — 성공 실행 시 `True`, 미실행 또는 오류 시 `False` | ❌ (자동 생성) |
| **Formula** | Flow에서 사용되는 시점에 값을 계산 | ✅ |
| **Global Constant** | 시스템 제공 고정값 — `EmptyString`, `True`, `False` | ❌ (시스템 제공) |
| **Global Variable** | 조직·실행 사용자 정보(사용자 ID, API 세션 ID 등)를 참조하는 시스템 제공 변수 | ❌ (시스템 제공) |
| **Wait Configuration** | Wait 요소 추가 시 각 configuration이 Boolean 리소스로 제공. 대기 조건 충족 시 `True`, 대기 조건이 없으면 항상 `True` | ❌ (자동 생성) |
| **Picklist Choice Set** | picklist / multi-select picklist 필드 값으로 선택지 집합 생성 | ✅ |
| **Picklist Values** | 레코드 변수·레코드 컬렉션 변수의 picklist 필드용 시스템 제공 값. **Assignment 요소와 조건에서만** 사용 가능 | ❌ (시스템 제공) |
| **Record Choice Set** | 필터링된 레코드 목록으로 선택지 집합 생성 | ✅ |
| **Screen Component** | Flow에 추가한 모든 화면 컴포넌트는 리소스로 제공. 값은 컴포넌트 유형에 따라 다름 — Text는 사용자 입력값, Picklist는 선택한 choice의 저장값, Display Text는 표시된 텍스트 | ❌ (자동 생성) |
| **Stage** | Flow 내 사용자의 진행 상태를 표현. stage 시스템 변수에 할당해 관련 stage를 식별하고, Flow 로직이나 UI(진행 표시기 등)에서 참조 | ✅ |
| **Text Template** | Flow 전체에서 변경·사용 가능한 텍스트 저장. HTML 태그로 서식 지정 | ✅ |
| **Variable** | Flow 전체에서 변경 가능한 값 저장 | ✅ |

---

## Variable (변수)

> 변수의 `.flow-meta.xml` XML 구조·dataType 종류·isInput/isOutput 조합·Apex-Defined 변수는 [[Flow 종류와 변수]] 참조. 여기서는 Flow Builder 리소스 필드 관점.

| 필드 | 설명 |
|---|---|
| Apex Class | Apex-defined 데이터 타입의 필드를 정의하는 Apex 클래스. **`@AuraEnabled` 어노테이션이 있는 필드만** Flow에서 사용 가능 |
| API Name | 고유성 요건은 현재 Flow 내 요소에만 적용 — 서로 다른 Flow라면 같은 API 이름 사용 가능. 밑줄·영숫자 사용(공백 불가), 문자로 시작, 밑줄로 끝날 수 없고 연속 밑줄 2개 불가 |
| Description | 다른 리소스와 구별하는 설명 |
| Data Type | 저장 가능한 값 유형 결정. **저장된 변수의 데이터 타입은 변경 불가.** Record 타입은 레코드 1건의 여러 필드 값 저장, Apex-defined 타입은 Apex 클래스 1개의 여러 필드 값 저장. sObject 타입은 Flow Builder에서 **Record**로 명칭 변경됨 |
| Allow multiple values (collection) | 선택 시 컬렉션 변수가 됨. 데이터 타입과 호환되는 값 목록만 저장 가능. Record 타입이면 지정 객체의 레코드 값만 저장 (예: 이메일 주소 여러 개를 담아 이메일 발송에 참조) |
| Object | 변수에 필드 값을 저장할 객체. **저장된 변수의 객체는 변경 불가.** Data Type이 Record일 때만 표시 |
| Decimal Places | 소수점 이하 자릿수 — **최대 17자리**. 비워두거나 0이면 정수만 표시. Data Type이 Number 또는 Currency일 때만 표시 |
| Availability Outside the Flow | input 가용 시 Flow 시작 시점에 값 설정 가능(Lightning 페이지·프로세스·다른 Flow 등에서 시작할 때). output 가용 시 Flow 밖(LWC·다른 Flow 등)에서 접근 가능. **기본값은 생성 시점에 따라 다름** — Summer '12 이후 또는 API 버전 25.0 이상에서 생성 → 기본 input·output 모두 불가 / Spring '12 이전 또는 API 버전 24.0 이하 → 기본 둘 다 가능. 기존 변수의 input/output 접근을 끄면 그 Flow를 호출하며 변수에 접근하는 앱·페이지(URL 파라미터·프로세스·다른 Flow 등)가 깨질 수 있음. 이 필드는 같은 Flow 내부에서의 할당·사용(Assignment·Create Records·Get Records·Apex Action 등)에는 영향 없음 |
| Default Value | Flow 시작 시 변수 값. 비워두면 `null`. Picklist·Multi-Select Picklist 변수에는 사용 불가 |

### 컬렉션 변수에 값 채우기

**Get Records 요소로는 (레코드가 아닌) 컬렉션 변수를 직접 채울 수 없다.** 우회 방법:

| 값의 출처 | 방법 |
|---|---|
| 화면 컴포넌트 | Assignment 요소로 입력값/저장값을 컬렉션 변수에 추가 |
| 변수 | Assignment 요소로 저장값을 컬렉션 변수에 추가 |
| 레코드 변수 | Assignment 요소로 레코드 변수의 필드 값 하나를 컬렉션 변수에 추가 |
| 레코드 컬렉션 변수 | Loop로 순회하며, 루프 안에서 Assignment 요소로 루프 변수의 필드 값을 컬렉션 변수에 추가 |

Flow 밖의 값을 쓰려면 컬렉션 변수를 input 가용으로 설정 — 외부 값은 **인터뷰 시작 시점에만** 설정 가능.

**샘플 (San Francisco 거주 직원 전원에게 이메일):** Send Email 코어 액션의 Recipients 파라미터는 텍스트 변수·텍스트 컬렉션 변수만 허용하므로 ① Get Records로 City = "San Francisco"인 User 레코드를 레코드 컬렉션 변수 `employeesInSF`에 저장 → ② Loop로 각 항목을 `loopVariable`에 복사 → ③ 반복마다 Assignment로 Email을 Text 컬렉션 변수 `emails_employeesInSF`에 추가 → ④ 루프 종료 후 그 컬렉션을 Email Addresses (collection) 파라미터로 사용. 컬렉션 조작 상세는 [[Flow 레코드 컬렉션 조작]] 참조.

---

## Constant (상수)

Flow 전체에서 **사용할 수 있지만 변경할 수 없는** 고정값.

| 필드 | 설명 |
|---|---|
| API Name | (Variable과 동일 규칙) |
| Description | 다른 리소스와 구별하는 설명 |
| Data Type | 상수가 저장할 값 유형. **저장된 상수의 데이터 타입은 변경 불가** |
| Value | 상수의 값 — Flow 실행 내내 변하지 않음 |

---

## Formula (수식)

Flow에서 사용되는 시점에 값을 계산한다.

| 필드 | 설명 |
|---|---|
| API Name | (Variable과 동일 규칙) |
| Description | 다른 리소스와 구별하는 설명 |
| Data Type | 수식이 반환하는 값의 데이터 타입. 저장 후 변경 불가 |
| Decimal Places | 소수점 이하 자릿수, 최대 17자리. 비우거나 0이면 정수만 표시. Number/Currency일 때만 |
| Formula | 런타임에 평가되는 수식 표현식. 반환값은 Data Type과 호환돼야 함. **일부 수식 함수는 Flow Builder에서 지원되지 않음** |

수식의 XML 예제는 [[Flow 종류와 변수]] 참조.

---

## Text Template (텍스트 템플릿)

Flow 전체에서 변경·사용 가능한 텍스트 저장. 다른 리소스 참조는 머지 필드 사용.

| 필드 | 설명 |
|---|---|
| API Name | (Variable과 동일 규칙) |
| Description | 다른 리소스와 구별하는 설명 |
| Text Template | 템플릿 텍스트. 다른 리소스 정보는 머지 필드로 참조 |
| Rich Text | 폰트·크기·색·정렬 제어, 머지 필드·HTML 링크·글머리표·번호 목록 추가. **기본값은 Rich Text** |
| Plain Text | **Send Email 코어 액션은 plain text 사용.** AppExchange나 Salesforce 개발자가 만든 일부 커스텀 액션도 plain text 기대 |

예: 이벤트 등록 Flow에서 등록자 이름·주소 등을 담은 텍스트 템플릿을 만들고, Flow 종료 시 발송하는 확인 이메일에 사용.

---

## Choice 계열 리소스 (4종)

화면 컴포넌트(Radio Buttons·Picklist·Multi-Select Picklist·Checkbox Group 등)에 선택지를 공급하는 리소스. 정적 1건은 Choice, 동적 집합은 Choice Set 3종.

| 리소스 | 선택지 출처 | 서버 쿼리 |
|---|---|---|
| Choice | 수동 정의 (1건씩) | 없음 |
| Picklist Choice Set | picklist / multi-select picklist 필드 값 | — |
| Record Choice Set | 필터링된 레코드 목록 | **사용할 때마다** 쿼리 |
| Collection Choice Set | 기존 레코드 컬렉션·외부 데이터 | Get Records **최초 실행 시에만** 쿼리 |

> **표준 vs 커스텀:** 위 4종은 표준 화면 컴포넌트에 붙는 표준 선택지 리소스다. 카드형 UI·동적 템플릿 전환 등 표준 컴포넌트가 못 하는 선택 UI가 필요하면 커스텀 LWC 선택기인 [[quickChoice Screen Component]] 패턴을 사용한다.

### Choice

| 필드 | 설명 |
|---|---|
| API Name | 밑줄·영숫자(공백 불가), 문자로 시작, 밑줄로 끝 불가, 연속 밑줄 2개 불가 |
| Description | 다른 리소스와 구별하는 설명 |
| Choice Label | 사용자에게 보이는 라벨 |
| Data Type | 이 choice를 쓸 수 있는 화면 컴포넌트를 결정 (예: Text choice는 Currency 라디오 버튼에 사용 불가). 저장 후 변경 불가 |
| Choice Value | 사용자가 이 choice를 선택하면 화면 컴포넌트에 설정되는 값. **예외:** ① choice value를 설정하지 않으면 choice label이 설정됨 ② choice value가 formula 리소스를 참조하면 choice label이 설정됨 |
| Display text input | choice 아래에 텍스트 입력 컴포넌트 표시. choice의 데이터 타입이 Boolean이면 사용 불가 |

**Configure Text Input** (Display text input 선택 시 표시):

| 필드 | 설명 |
|---|---|
| Input Label | 텍스트 입력 컴포넌트의 라벨 |
| Require | 진행/완료 전에 값 입력을 필수로 요구 |
| Validate | 입력값이 허용 가능한지 평가 |
| Error Message | 허용되지 않는 값 입력 시 입력 컴포넌트 아래에 표시되는 메시지. Validate 선택 시에만 |
| Formula | 입력값의 허용 여부를 평가하는 Boolean 수식. Validate 선택 시에만 |

예: 서비스 등급 선택 — Gold·Silver·Bronze choice를 만들고, 화면에 기능 설명과 함께 표시한 뒤 Radio Buttons 컴포넌트로 선택.

**서식(Formatting Choices):** 툴바로 리치 텍스트 서식 추가 가능. Display Text 화면 컴포넌트·Choice 리소스 라벨·도움말 텍스트·Pause 확인 화면·입력 검증을 열면 기존 HTML이 리치 텍스트로 변환되고 미지원 HTML은 제거된다. 리치 텍스트로 변환되는 태그: `<a>`, `<b>`, `<br>`, `<font>`, `<i>`, `<li>`, `<p>`, `<span>`, `<u>`, `<div>`. 리치 텍스트 편집기에 HTML을 붙여넣는 것은 지원되지 않음.

### Picklist Choice Set

| 필드 | 설명 |
|---|---|
| API Name / Description | (공통 규칙) |
| Object | 필드를 선택할 객체. 저장 후 변경 불가 |
| Data Type | picklist / multi-select picklist 중 선택. 저장 후 변경 불가 |
| Field | 선택지 목록을 생성할 picklist(또는 multi-select picklist) 필드 |
| Sort Order | 선택지 표시 순서. **실행 사용자 언어의 번역된 picklist 값 기준으로 정렬** |

standalone Choice보다 설정이 쉽고 유지보수가 줄어든다 — 누군가 필드에 옵션을 추가하면 Flow가 자동 반영.

**제약 (할 수 없는 것):**
- DB에서 반환되는 값 필터링 불가 — 페이지 레이아웃에서 record type으로 picklist를 좁혀도 **항상 모든 picklist 값 표시**
- 옵션별 라벨 커스터마이즈 불가 — 항상 picklist 값의 라벨 표시
- 옵션별 저장값 커스터마이즈 불가 — 항상 picklist 값의 **API 값** 저장
- Knowledge Article의 picklist는 미지원

**번역된 필드의 라벨·값:** picklist 필드가 번역된 경우 — 각 choice 라벨은 **실행 사용자 언어** 버전, 저장값은 **조직 기본 언어** 버전 사용.

### Record Choice Set

| 필드 | 설명 |
|---|---|
| API Name / Description | (공통 규칙) |
| Object | 선택지를 생성할 레코드의 객체. 저장 후 변경 불가 |

**Filter Object Records** — 선택지 집합에 포함할 레코드 결정 (예: Billing City = San Francisco 계정만). 필터 조건이 없으면 선택된 객체의 **모든 레코드**마다 choice가 생성되므로, 필터를 안 걸면 오름/내림차순 정렬을 걸 것.

**Sort Object Records:**

| 필드 | 설명 |
|---|---|
| Sort Order | 선택지 표시 순서 |
| Sort By | 오름/내림차순일 때 정렬 기준 필드 |
| Maximum Number of Choices | 이 record choice set을 쓰는 화면 컴포넌트에 표시할 최대 선택지 수. **기본 200** |

**Configure Each Choice** — 필터를 통과한 각 레코드로 choice 생성:

| 필드 | 설명 |
|---|---|
| Choice Label | 각 choice의 라벨로 쓸 필드. 데이터가 있는 필드를 선택할 것 — 값이 없으면 런타임에 라벨이 빈칸 |
| Data Type | choice 값의 데이터 타입. 저장 후 변경 불가 |
| Choice Value | 선택 시 저장할 필드 값. 값은 생성된 집합 내 **가장 최근 사용자 선택**으로 결정. 필드를 선택하지 않으면 choice label이 대신 사용됨 |

> Tip (PDF 원문): 대부분의 경우 choice label = **Name**, choice value = **ID**.

**Store More Object Field Values** — choice 선택 시 연관 레코드의 필드 값을 Flow 변수에 저장해 나중에 참조. **주의:** Checkbox Group·Multi-Select Picklist·Choice Lookup 화면 컴포넌트가 record choice set을 쓰면 **사용자가 마지막으로 선택한 레코드의 값만** 변수에 저장된다. 한 화면에서 여러 Checkbox Group/Multi-Select Picklist 컴포넌트가 같은 record choice set을 공유하면 그 모든 컴포넌트에서 마지막으로 선택된 레코드 기준으로 변수가 할당된다.

### Collection Choice Set

| 필드 | 설명 |
|---|---|
| API Name / Description | (공통 규칙) |
| Record Collection | 선택지를 생성할 컬렉션. 외부 서비스·Apex 액션·다른 화면 컴포넌트의 **Apex-defined 컬렉션**도 참조 가능 |

**Configure Each Choice** — Record Choice Set과 동일 구조 (Choice Label / Data Type / Choice Value, 값 미선택 시 라벨 사용).

**언제 쓰나:** 같은 데이터셋을 여러 화면에서 재사용할 때 유용. 예: IT 부서 지원 Flow에서 Get Records 1회로 직원 하드웨어 레코드 컬렉션을 만들고, Collection Filter로 조건별로 거른 뒤 분기마다 collection choice set으로 표시. **Collection choice set은 Get Records 최초 실행 시에만 서버 쿼리가 발생하는 반면, record choice set은 사용할 때마다 서버 쿼리가 필요하다.**

---

## Global Constant (전역 상수)

시스템 제공 고정값 — 전수 3개.

| Global Constant | 지원 데이터 타입 |
|---|---|
| `{!$GlobalConstant.True}` | Boolean |
| `{!$GlobalConstant.False}` | Boolean |
| `{!$GlobalConstant.EmptyString}` | Text |

Boolean 변수를 만들면 지원되는 값은 `$GlobalConstant.True`와 `$GlobalConstant.False`다.

### Null vs EmptyString

런타임에 `{!$GlobalConstant.EmptyString}`과 `null`은 **서로 다른 별개 값**으로 취급된다.

- `EmptyString` = 문자 0개인 텍스트 값. 필드/변수가 **비어 있는지** 판단용
- `null` = 값이 존재하지 않음. 필드/변수 값이 **존재하는지** 판단용
- 조건에서 값이 채워졌는지 확인 → 연산자 **Equals** + 값 `{!$GlobalConstant.EmptyString}`
- 조건에서 값이 없는지 확인 → 연산자 **Is Null** + 값 `{!$GlobalConstant.True}`
- 예: Get Records가 레코드를 찾았는지 확인 → Decision outcome 조건에서 Get Records 레코드 컬렉션 리소스 + **Is Null** + `{!$GlobalConstant.False}`

**고려사항:**
- 텍스트 필드/변수에 시작값을 주지 않으면 런타임 값은 `null`. 빈 문자열로 취급하려면 `EmptyString`으로 설정
- **Screen 요소에 놓인 텍스트 필드/컴포넌트에는 Is Null 연산자가 항상 false로 평가**된다. 값이 없는지 확인하려면 Equals + `EmptyString` 사용
- 두 텍스트 변수를 비교하는 조건이라면 기본값을 모두 `EmptyString`으로 하거나 모두 비워두어(null) 통일할 것
- `null`과 `EmptyString`을 **동시에** 확인하려면 `ISBLANK` 수식 함수 사용

---

## Global Variable (전역 변수) — 전수 16종

시스템 제공 변수. 조직·Flow·실행 사용자·트리거링 레코드 정보를 담는다. 예: `{!$User.Id}` = 인터뷰 실행 사용자의 ID.

| API 이름 | 라벨 | 설명 |
|---|---|---|
| `$Api` | API | 세션 ID와 SOAP API 엔드포인트. 머지 필드: `Enterprise_Server_URL_xxx`(Enterprise WSDL SOAP 엔드포인트, xxx = API 버전), `Partner_Server_URL_xxx`(Partner WSDL SOAP 엔드포인트), `Session_ID` |
| `$Client` | Running User's Client | 실행 사용자 기기의 폼팩터. **Lightning Scheduler flow에서만 제공, Decision 요소에서만 지원.** `$Client.FormFactor`가 기기에 따라 Large(컴퓨터)·Medium(태블릿)·Small(폰)로 자동 설정 — Decision으로 기기별 경로를 나누고 각 경로에 최적화된 화면 사용 |
| `$Event` | $Event | automation event-triggered flow를 실행시킨 이벤트(예: 폼 제출). 이벤트 이름 등 이벤트 정보에 접근 |
| `$Flow` | Running Flow Interview | 실행 중인 flow 인스턴스. 하위 변수 8종은 아래 [$Flow 전역 변수](#flow-전역-변수--전수-8종) 절 |
| `$Input` | $Input | Flow 밖에서 제공되는 입력 데이터. 예: Prompt Builder의 프롬프트 템플릿이 Recipient 입력을 설정하면 Flow가 `$Input > Recipient > First Name`으로 참조. **Prompt Flow process type에서만 제공** |
| `$Label` | Custom Label | 조직의 커스텀 라벨. **조직에 커스텀 라벨이 있을 때만 표시.** 반환값은 컨텍스트 사용자의 언어 설정에 따라 우선순위 순으로: ① 로컬 번역 텍스트 → ② 패키지 번역 텍스트 → ③ 기본(primary) 라벨 텍스트 |
| `$Organization` | Running Org | Flow가 실행 중인 Salesforce 조직. 조직 이름·주소 등 접근 |
| `$Permission` | Running User's Permission | 실행 사용자의 **커스텀 권한** 접근 여부 |
| `$Output` | $Output | Flow 안팎에서 사용 가능한 출력 데이터. 예: 프롬프트 템플릿에 연결된 Flow가 `$Output > Prompt`를 참조하거나, 프롬프트 템플릿이 `$Output` 값을 resolution에 머지. **Prompt Flow process type에서만 제공** |
| `$Profile` | Running User Profile | 실행 사용자의 프로필 — 라이선스 타입·이름 등. 표준 프로필은 프로필 이름으로 참조. 사용자는 자기 프로필 정보 접근 권한 없이도 이 머지 필드를 참조하는 Flow를 실행 가능 |
| `$Record` | Triggering Object (예: Triggering Account) | Flow를 트리거한 레코드. **트리거 있는 autolaunched flow에서만 제공.** record-triggered flow에서는 트리거링 레코드 값을 담고 Flow 전체에서 참조·변경 가능 — before-save면 변경값이 자동으로 DB에 적용, after-save면 Update Records 요소로 적용. schedule-triggered flow에서는 배치의 레코드마다 인터뷰가 실행되고 그 레코드의 모든 필드 값을 저장. $Record의 ID와 전체 필드 값으로 Update Records를 구성하면 조직 process automation 설정에서 **Filter inaccessible fields from flow requests** 활성화 필요 — 아니면 시스템 필드·읽기 전용 필드에 값을 쓰려다 실패 |
| `$Record__Prior` | Prior Values of Triggering Object | 변경이 Flow를 트리거하기 **직전의** 트리거링 레코드. **레코드 업데이트 시(또는 생성/업데이트 시) 실행되도록 구성된 record-triggered flow에서만 제공.** 값 변경 불가. 새로 생성된 레코드로 트리거되면 모든 값이 null |
| `$Setup` | Custom Hierarchy Settings | **hierarchy 타입** 커스텀 설정. 조직에 hierarchy 커스텀 설정이 있을 때만 표시 (list 타입은 Apex에서만 접근 가능). 값 우선순위: Organization(전체 기본) < Profile < User — 실행 사용자의 현재 컨텍스트 기준으로 결정 |
| `$System` | System | `$System.OriginDateTime` = 리터럴 값 **1900-01-01 00:00:00**. 날짜/시간 오프셋 계산용 |
| `$User` | Running User | 인터뷰 실행 사용자(ID·직함 등). 실행 사용자 = Flow를 시작하게 만든 사람. **Web-to-Case / Web-to-Lead 프로세스의 레코드 변경으로 시작되면 실행 사용자는 Default Lead Owner / Default Case Owner.** `$User.UITheme`(사용자가 보도록 되어 있는 룩앤필) vs `$User.UIThemeDisplayed`(실제로 보는 룩앤필 — 예: 구형 IE처럼 미지원 브라우저면 다른 값 반환). 반환값: `Theme1`(구식 테마) / `Theme2`(Classic 2005) / `Theme3`(Classic 2010) / `Theme4d`(Lightning Experience) / `Theme4t`(모바일 앱) / `Theme4u`(Lightning Console) / `PortalDefault`(Customer Portal) / `Webstore`(AppExchange) |
| `$UserRole` | Running User Role | 실행 사용자의 역할(이름·ID 등). 실행 사용자 = Flow를 시작하게 만든 사람. Web-to-Case / Web-to-Lead면 Default Lead Owner / Default Case Owner |

### 전역 변수 고려사항

- **화면 컴포넌트 visibility 조건에서 쓸 수 있는 전역 변수는 `$Flow`뿐**
- record-triggered flow의 `$Record`에는 다른 레코드에서 파생되는 필드 값이 없음 (예: `Contact.Name`, `User.MediumPhotoUrl`)
- multi-select picklist·time·location 전역 변수는 **수식에서만** 사용 가능
- DB 필드에 값이 없으면 머지 필드는 빈 값 반환 (예: 조직 Country 미설정 시 `{!$Organization.Country}`는 값 없음)
- `$Label` 전역 변수는 리소스 선택 목록 로딩이 느림 — 목록에 안 보이면 창을 닫고 몇 분 뒤 재시도

---

## $Flow 전역 변수 — 전수 8종

실행 중인 인터뷰의 정보를 제공. 일부는 시스템이 값을 채우고, 나머지는 Assignment나 출력값 저장으로 Flow 안에서 갱신한다.

| 전역 변수 | 지원 리소스 타입 | 설명 | 값 설정 주체 |
|---|---|---|---|
| `$Flow.ActiveStages` | Stage | Flow의 현재 경로에 관련된 stage 컬렉션. 예: 진행 표시기의 각 항목이 여기의 stage에 대응 | Assignment |
| `$Flow.CurrentDate` | Text, Date, Date/Time | 이 변수를 참조하는 요소가 실행되는 시점의 날짜 | System |
| `$Flow.CurrentRecord` | Text | 관련 레코드의 ID. 유효한 객체의 단일 ID여야 함 — 모든 커스텀 객체와 대부분의 표준 객체가 유효. 사용자가 인터뷰를 일시정지하거나 Wait 요소가 실행되면 **FlowRecordRelation** 레코드 생성으로 인터뷰가 이 레코드에 연결됨. ID가 유효하지 않으면 일시정지 실패 | Assignment |
| `$Flow.CurrentStage` | Stage | 현재 선택된 stage. 예: 진행 표시기의 선택 항목이 이 값에 대응 | Assignment |
| `$Flow.CurrentDateTime` | Text, Date, Date/Time | 이 변수를 참조하는 요소가 실행되는 시점의 날짜+시간 | System |
| `$Flow.FaultMessage` | Text | Flow 관리자의 런타임 문제 해결을 돕는 시스템 오류 메시지 | System |
| `$Flow.InterviewGuid` | Text | 인터뷰의 고유 식별자 | System |
| `$Flow.InterviewStartTime` | Text, Date, Date/Time | 인터뷰 시작 날짜+시간. **Subflow 요소로 실행된 Flow에서는 최초 마스터 Flow의 시작 시각** | System |

**FaultMessage 활용 예 (PDF 원문 발췌):** DB와 상호작용하는 각 요소의 fault connector를 화면으로 연결하고 Display Text 컴포넌트로 표시 —

```
Sorry, but you can't
read or update records at this time.
Please open a case with IT, and include the following error message:
{!$Flow.FaultMessage}
```

**InterviewGuid 활용 예 (잊혀질 권리):** Wait 요소 실행 또는 사용자 일시정지 시 인터뷰 데이터 전체가 직렬화되어 Paused Flow Interview 레코드로 저장된다(재개 시 삭제). 개인 데이터를 참조하는 인터뷰를 추적하려면 커스텀 객체를 만들어 lead ID와 `{!$Flow.InterviewGuid}`로 레코드를 생성하고, 최종 화면 전에 해당 GUID를 참조하는 커스텀 객체 레코드를 삭제 — DB에 저장된 인터뷰만 추적된다. 삭제 요청 시 LeadId가 일치하는 커스텀 객체 레코드를 보고서로 뽑아 GUID별 인터뷰를 삭제.

fault connector 설계 전반은 [[Flow 에러 처리]] 참조.

---

## Stage 리소스와 진행 표시 패턴

사용자가 Flow의 어느 단계에 있는지(breadcrumb·진행 표시기 등) 알려주는 리소스. 결제 Flow라면 stage는 payment details·shipping details·billing details·order confirmation.

### Stage 필드

| 필드 | 설명 |
|---|---|
| Label | 사용자에게 보이는 라벨. **머지 필드 미지원** |
| API Name | 고유성 요건은 현재 Flow 내에만 적용. 밑줄·영숫자(공백 불가), 문자로 시작, 밑줄 끝 불가, 연속 밑줄 불가 |
| Description | 다른 stage와 구별하는 설명 |
| Order | **필수.** Flow 내 다른 stage들 사이의 정렬 순서. Flow 내 모든 stage 중에서 고유해야 함 |
| Active by default | 인터뷰 시작 시 이 stage를 `{!$Flow.ActiveStages}`에 추가 |

**Usage:**
- Order 번호는 **사이를 띄워서** 부여 — 예: 10, 20, 30이면 나중에 15를 끼워 넣을 때 기존 stage를 수정할 필요가 없다
- stage는 대부분 **정규화된 이름**으로 해석됨: `namespace.flowName:stageName` 또는 `flowName:stageName`
- 다음 컨텍스트에서는 **라벨**로 해석됨: ① 표시 컨텍스트(choice 라벨, Display Text 화면 컴포넌트) ② Lightning 런타임이 필요한 화면 컴포넌트의 attribute

### 진행 표시 3단계 워크플로우

Flow Builder에서 flow를 열고 편집·생성하려면 **Manage Flow** 권한 필요.

**1) 계획 (Plan the Stages)** — stage를 추가하기 전에 가능한 stage를 전부 나열하고, 순서를 정하고, 기본 활성(active by default) stage를 식별한다. Decision이 있으면 분기별로 다른 stage 구성 가능. 기본 활성 stage를 지정해 두면 Flow 시작부에서 Assignment로 `$Flow.ActiveStages`·`$Flow.CurrentStage`를 채울 필요가 없다(선택 단계). 예: Review Cart / Shipping Details / Billing Details / Payment Details / Order Confirmation 5개 중, 배송지=청구지면 Billing Details를 건너뛰므로 Billing Details만 기본 활성에서 제외.

**2) 정의 (Define the Stages)** — Resources 탭에서 **Stage**를 더블클릭 → 라벨·순서 입력, 기본 활성 여부 지정.

**3) 식별 (Identify the Relevant Stages)** — Flow 진행 중 **Assignment 또는 Subflow 요소**로 stage 전역 변수를 갱신한다.
- `$Flow.ActiveStages` = 현재 분기에 관련된 stage들. `$Flow.CurrentStage` = 현재 stage — **반드시 `$Flow.ActiveStages`에 포함된 stage여야 함**

`$Flow.ActiveStages`에 stage 추가 연산자:

| 연산자 | 설명 |
|---|---|
| `add` | `$Flow.ActiveStages` 끝에 추가 |
| `add at start` | `$Flow.ActiveStages` 앞에 추가 |

두 stage **사이에** 삽입하려면: 다른 Flow에서 그 stage를 기본 활성으로 정의하고 Subflow 요소로 호출 — **참조된 Flow가 시작되면 그 기본 활성 stage들이 현재 stage 바로 뒤에 자동 삽입**된다.

`$Flow.ActiveStages`에서 stage 제거 연산자:

| 연산자 | 설명 |
|---|---|
| `remove after first` | 지정 stage의 첫 등장 **이후** 모든 stage 제거 |
| `remove all` | 지정 stage들의 모든 인스턴스 제거 |
| `remove before first` | 지정 stage의 첫 등장 **이전** 모든 stage 제거 |
| `remove first` | 지정 stage의 첫 인스턴스 제거 |
| `remove position` | 지정 위치의 stage 제거 |

- `$Flow.CurrentStage` 변경 → Assignment + `equals` 연산자
- 활성 stage 개수를 변수에 할당 → Assignment + `equals count` 연산자
- 다른 Flow의 stage 참조 → 정규화된 이름 입력 (`flowName:stageName` / `namespace.flowName:stageName`). 런타임에는 **Subflow 요소가 그 stage의 Flow를 호출할 때만** 할당이 동작

### 시각적 표현

**표준 flow 런타임은 stage를 표시하지 않는다.** 커스텀 컴포넌트로 표현:
- **화면 컴포넌트** — 커스텀 Aura/LWC를 화면에 추가하고 stage를 attribute에 매핑하면 stage의 **라벨**이 전달됨
- **`lightning:flow` 컴포넌트** — 커스텀 Aura 컴포넌트에 넣으면 표준 `lightning:flow`의 `onstatuschange` attribute가 활성 stage·현재 stage의 **이름과 라벨**을 반환

### 샘플 패턴 2종 (Online Purchase flow)

**패턴 A — Breadcrumbs (방문한 stage까지만 표시):** 첫 stage만 기본 활성.

| Stage Label | Unique Name | Order | Active by Default |
|---|---|---|---|
| Review Cart | Review_Cart | 0 | Yes |
| Shipping Details | Shipping_Details | 1 | No |
| Billing Details | Billing_Details | 2 | No |
| Payment Details | Payment_Details | 3 | No |
| Order Confirmation | Order_Confirmation | 4 | No |

시작 시 Review Cart가 자동으로 `$Flow.CurrentStage`가 되고 `$Flow.ActiveStages`의 유일한 stage. **stage가 바뀔 때마다 Assignment로 현재 stage를 재설정하고 새 stage를 active stages에 추가**한다. Different Billing Address 체크박스 값으로 Billing Details 분기 여부를 결정 — 다르면 Billing Details를 추가, 같으면 건너뛰고 Payment Details로.

**패턴 B — 전체 활성 stage 표시 (전체 여정 미리 보여주기):** 모두가 거치는 stage는 전부 기본 활성.

| Stage Label | Unique Name | Order | Active by Default |
|---|---|---|---|
| Review Cart | Review_Cart | 0 | Yes |
| Shipping Details | Shipping_Details | 1 | Yes |
| Payment Details | Payment_Details | 2 | Yes |
| Order Confirmation | Order_Confirmation | 3 | Yes |

Billing Details처럼 **선택적 stage는 별도 Flow**(기본 활성 stage: Billing Details, Order 1)로 만들어 Subflow로 호출 — 호출 시점의 현재 stage(Shipping Details) **바로 뒤에 자동 삽입**된다. stage 이동마다 Assignment로 `$Flow.CurrentStage`만 재설정.

> 두 샘플 모두 stage 표시는 커스텀 Aura 컴포넌트를 사용한다 (표준 런타임 미표시).

Screen Flow 화면 설계 전반은 [[Screen Flow 설계]], stage 표시용 커스텀 화면 컴포넌트 제작은 [[Flow Screen LWC 패턴]] 참조.

---

## 관련 노트

- [[Flow 종류와 변수]] — 변수 XML 구조·dataType·isInput/isOutput·Apex-Defined 변수·$Flow 요약
- [[Flow 요소 참조]] — 요소(Get/Create/Update Records·Decision·Assignment 등) XML 레퍼런스
- [[quickChoice Screen Component]] — 커스텀 LWC 선택기 (표준 Choice 리소스의 커스텀 대안)
- [[Screen Flow 설계]] — 화면 구성·visibility 조건 설계
- [[Flow Screen LWC 패턴]] — Flow 화면용 커스텀 LWC 제작 패턴
- [[Flow 에러 처리]] — faultConnector·$Flow.FaultMessage 활용
- [[Flow 레코드 컬렉션 조작]] — 컬렉션 필터·정렬·Assignment 조작
