---
tags: [flow, screen-flow, screen-component, reference, catalog, selection, display]
source: extend_click_automate.pdf (Automate Your Business Processes, Spring '26)
created: 2026-07-11
aliases: [Flow Screen Selection Components, Flow Screen Display Components, 표준 화면 컴포넌트 선택, Flow 선택 컴포넌트, Flow 디스플레이 컴포넌트, Action Button 컴포넌트, Data Table 컴포넌트, Dependent Picklists 컴포넌트, Display Image 컴포넌트, File Upload 컴포넌트, Lookup 컴포넌트, Choice Lookup 컴포넌트, Picklist 컴포넌트, Radio Buttons 컴포넌트, Checkbox Group 컴포넌트, Multi-Select Picklist 컴포넌트, Slack Channel Selector, Slack Workspace Selector, Display Text 컴포넌트, Repeater 컴포넌트, Section 컴포넌트, Enhanced Message 컴포넌트, Order Management Product Selector]
---

# Screen Component 레퍼런스 - 디스플레이·선택·기타

> Salesforce 표준 Flow Screen Component 33종 중 **선택·데이터·디스플레이·기타 계열 18종**(Action Button·Checkbox Group·Choice Lookup·Data Table·Dependent Picklists·Display Image·Enhanced Message·File Upload·Lookup·Multi-Select Picklist·Order Management Product Selector·Picklist·Radio Buttons·Slack Channel Selector·Slack Workspace Selector·Display Text·Repeater·Section)의 속성 전수 레퍼런스. Spring '26 기준.

---

## 개요 — 이 노트의 18종

이 노트는 [[Screen Component 레퍼런스 - 입력]]과 짝을 이룬다. 입력 노트가 단일 값 입력 계열 15종(Address·Checkbox·Currency·Date·Date & Time·Email·Long Text Area·Name·Number·Password·Phone·Slider·Text·Toggle·URL)을 다루므로, **이 노트는 그와 겹치지 않는 나머지 18종**을 다룬다.

| 계열 | 컴포넌트 |
|---|---|
| **트리거** | Action Button |
| **선택 (choice)** | Checkbox Group, Choice Lookup, Multi-Select Picklist, Picklist, Radio Buttons |
| **데이터·검색** | Data Table, Dependent Picklists, Lookup |
| **파일·이미지** | Display Image, File Upload |
| **Slack** | Slack Channel Selector, Slack Workspace Selector |
| **메시징·오더** | Enhanced Message, Order Management Product Selector |
| **디스플레이·레이아웃** | Display Text (output), Repeater (display), Section (output) |

**Editions(대부분 공통):** both Salesforce Classic(일부 org 미제공)·Lightning Experience / Essentials, Professional, Enterprise, Performance, Unlimited, Developer Editions. **예외:** Enhanced Message(Messaging는 Digital Engagement add-on SKU 필요, Enterprise/Unlimited/Developer + Service Cloud 또는 Sales Cloud).

> 반응형(reactive) 화면 — 어떤 컴포넌트가 반응형을 지원하는지·reactive formula·제약은 [[Screen Flow 설계]]의 "Reactive Screen Components" 절 참조.

---

## 표기 규칙 — 공통 속성(†)·공통 블록

PDF는 여러 컴포넌트에 동일 문구의 속성과 4개 설정 블록을 반복한다. 그 전문은 입력 노트에 1회 정리돼 있으므로 이 노트에서는 축약 표기를 쓴다.

- **†** = 공통 속성. 전문은 [[Screen Component 레퍼런스 - 입력]]의 "공통 속성 표기 규칙" 표 참조 (API Name·Disabled·Read Only·Provide Help·Require·Required·Default Value·Label·Placeholder Text).
- **공통 블록: 표시 / 검증 / 재방문** = 각각 "Set the Component Visibility"(When to Display Component 옵션 4종), "Validate Input"(Error Message + Formula), "Specify the Behavior of Values on Revisited Screens"(Use values… / Refresh inputs…). 전문은 입력 노트 "공통 설정 블록" 참조. ✓ = PDF에 해당 블록 있음, ✗ = 없음.
- **재방문 주의(공통):** 일시정지 후 재개 시 사용자 지정 값이 유지되는 컴포넌트는 Checkbox, Checkbox Group, Currency, Long Text Area, Multi-Select Picklist, Number, Password, Picklist, Radio Buttons, Text **10종뿐**.
- **v58 이하 메모리 팁(공통):** Lightning runtime 58 이하 컴포넌트는 기본 메모리가 없어 화면 이동·일시정지·검증 오류 시 값이 사라진다. 속성을 설정하면 flow가 값을 기억한다(자동 저장, 수동 저장은 **Manually assign variables (advanced)**).

---

## Action Button (액션 버튼)

버튼 클릭으로 화면 액션(screen action)을 트리거. 화면 액션은 활성 autolaunched flow를 실행하고 결과를 같은 화면에 표시할 수 있다. 화면 수를 줄여 사용자가 screen flow를 더 빨리 완료하게 한다.

### Configure the Action Button Name

| 속성 | 설명 |
|---|---|
| API Name | † |
| Label | **Use Label as the table title**를 선택한 경우, 컴포넌트 위에 표시되는 사용자 친화적 텍스트 |
| Disabled | † |

### Configure the Action

| 속성 | 설명 |
|---|---|
| Action | autolaunched flow를 실행하는 화면 액션. 버튼 클릭 시 실행되는 flow. **autolaunched flow는 활성 상태여야 함** |
| Label | 컴포넌트에 연결된 액션의 사용자 친화적 이름. 선택한 flow의 레이블과 달라도 됨 |
| API Name | 액션의 API명. 선택한 flow의 API명과 달라도 됨. (밑줄·영숫자, 공백 불가, 문자로 시작, 밑줄로 끝 불가, 연속 밑줄 불가) |
| Set Input Values | 액션이 요구하는 각 입력 필드 값 지정. 예: Account ID를 입력으로 요구하는 autolaunched flow면 Account ID 제공. 입력 가능 변수가 이 영역에 나타남 |
| View Output Values | 액션이 만든 출력 조회. 출력을 flow 다른 곳에서 참조하려면 먼저 Results 필드를 참조: 예 `actionButtonApiName.Results.output`. 출력 값 포함: <br>• `ErrorMessage` — invocable action 실행 중 발생한 오류 설명<br>• `IsSuccess` — `true`면 오류 없이 실행됨<br>• `Action.Results.Flow__InterviewGuid` — flow interview 고유 식별자<br>• `Action.Results.Flow__InterviewStatus` — flow interview 상태<br>• `InProgress` — `true`면 화면 액션 실행 중 |

**In Progress 출력 속성으로 다른 컴포넌트 제어:** 사용자가 액션 버튼을 클릭하면 연결된 화면 액션의 In Progress가 `true`, 완료 시 `false`. 이를 다른 컴포넌트의 Disabled 필드에 지정하면, 액션 실행 중(In Progress `true`)에는 컴포넌트가 비활성화되고 완료 시 다시 활성화된다.

**Considerations**
- 웹 브라우저에서 실행 시 액션 출력이 브라우저에 노출됨 — **민감 정보를 Action Button 출력으로 공유하지 말 것.**
- Wait 요소를 포함하거나 Wait 요소가 있는 subflow를 포함한 autolaunched flow는 Action Button 액션으로 미지원(Wait 후 재개 안 됨).
- **Action Button은 Repeater 컴포넌트 내에서 미지원.**
- asynchronous path로 flow 실행 미지원.
- 액션 버튼에서 실행한 flow에 fault path가 없고 오류 발생 시 버튼 아래 일반 오류 메시지 표시. 도움되는 메시지를 보이려면 실행 flow에 fault path 추가 → 각 fault path에서 출력 변수를 `{!$Flow.FaultMessage}`로 설정 → 액션 버튼 화면에 조건부로 숨겨진 Display Text 컴포넌트로 표시. (참고: Display Text 내용이 오류 메시지여도 스크린 리더는 이를 오류로 안내하지 않음.)
- 화면 액션의 autolaunched flow 입/출력 변수가 record 변수인데 오브젝트 필드명을 바꾸면, 입출력 refresh 시 새 필드명이 반영되지 않음.
- 입/출력 변수가 Apex 변수인데 Apex 타입 구조를 바꾸면 refresh 시 반영되지 않음.

공통 블록: 표시 ✓ · 검증 ✗ · 재방문 ✓

---

## Checkbox Group (체크박스 그룹)

체크박스 형식으로 여러 옵션 선택.

| 속성 | 설명 |
|---|---|
| API Name | † |
| Choice | choice·record choice set·picklist choice set를 최소 1개 추가. 스크린 컴포넌트에 choice 컴포넌트를 추가했을 때만 사용 가능. collection choice set·record choice set 같은 동적 Choice 리소스 선택 시 각 값이 **고유**해야 함 — 중복 값을 선택하면 Salesforce에 잘못 저장됨 |
| Component Type | choice 컴포넌트 타입 변경. 단일 선택이면 Picklist·Radio Buttons, 다중 선택이면 Checkbox Group·Multi-select Picklist 사용 가능 |
| Data Type | **Text choice만 지원** |
| Default Value | 사전 선택 choice. 화면 미실행·표시 조건 미충족이면 저장값 `null` |
| Disabled | † |
| Label | † |
| Let Users Select Multiple Options | 단일 vs 다중 선택. Yes 선택 시 Data Type이 자동으로 Text로 설정되고 비-text Choice 리소스는 구성에서 제거됨 |
| Provide Help | † |
| Require | † |

**Considerations:** Checkbox Group의 info bubble 클릭 시 도움말이 **별도 창**에 표시된다(다른 Salesforce 제공 컴포넌트는 popover로 표시).

공통 블록: 표시 ✓ · 검증 ✗ · 재방문 ✓

---

## Choice Lookup (초이스 검색)

화면에서 choice 집합을 검색해 하나 선택. **Text 값만 지원.**

| 속성 | 설명 |
|---|---|
| Label | † |
| API Name | † |
| Require | † |
| Disabled | † |
| Placeholder Text | † |
| Let Users Select Multiple Options | 단일 vs 다중 선택. **최대 25개 옵션** 선택 가능 |
| Choice | record choice set·picklist choice set 같은 Choice 리소스 최소 1개 추가. choice 컴포넌트 추가 시만 사용 가능. 동적 Choice 리소스는 값이 고유해야 함(중복 선택 시 잘못 저장). **choice를 재정렬하거나 같은 choice를 두 번 선택할 수 없음.** Data Type 설정과 호환돼야 함 |

**Choice Lookup 값 접근(flow가 자동 저장 — 수동 저장 불가):**

| 속성 | 설명 |
|---|---|
| selectedChoiceLabels | 단일 선택이면 선택한 choice 옵션의 레이블. 다중이면 세미콜론으로 구분된 모든 선택 레이블. 참조: `{!choiceLookup.selectedChoiceLabels}` |
| selectedChoiceValues | 단일 선택이면 선택한 choice 옵션의 값. 다중이면 세미콜론으로 구분된 모든 선택 값. 참조: `{!choiceLookup.selectedChoiceValues}` |

**Considerations**
- 모바일 기기·standalone Aura 앱과 비호환.
- Choice 리소스의 **Choice Label 필드에서만** 매칭 검색.
- 다른 Choice 필드처럼 **Was Selected** 연산자 지원.
- **검색은 대소문자 구분(case-sensitive).**
- 초기 20개 choice 표시. 스크롤하면 100개 단위로 로드, **최대 1,020개**까지.
- 초기 choice 로드 후 필터 적용 시 표시가 리셋되어 새 20개를 보여줌.
- Choice 리소스의 **Display text input** 필드 미지원(Choice 리소스 구성 시 Display text input을 체크해도 런타임에 텍스트 입력 필드가 안 나타남).

공통 블록: 표시 ✓ · 검증 ✗ · 재방문 ✓

---

## Data Table (데이터 테이블)

flow의 테이블에서 레코드 선택.

### Configure the Data Table Name

| 속성 | 설명 |
|---|---|
| API Name | † |
| Label | **Use Label as the table title** 선택 시, 컴포넌트 위에 표시되는 텍스트 |
| Use Label as the table title | flow 실행 시 Label 값을 테이블 위에 표시할지 여부 |

### Configure the Data Table Source

| 속성 | 설명 |
|---|---|
| Source Collection | 테이블을 채울 레코드 컬렉션 |
| Show search bar | 사용자가 레코드 결과를 검색·필터링 가능하게 함 |

### Configure the Data Table Rows

| 속성 | 설명 |
|---|---|
| Row Selection Mode | 선택 가능 행 수: **Multiple**(Minimum~Maximum Row Selection 사이 임의 개수) · **Single**(최대 1행) · **View only**(선택 불가) |
| Minimum Row Selection | 사용자가 선택해야 하는 최소 행 수 |
| Maximum Row Selection | 사용자가 선택 가능한 최대 행 수 |
| Default Selection | 사전 선택할 레코드를 지정하는 컬렉션 |
| Require user to make a selection | 다음 화면 이동 전 행 선택 강제 여부 |

### Configure the Data Table Columns

첫 열은 아래 필드로 구성, 이후 열은 **Add column** 클릭. 드래그로 재정렬.

| 속성 | 설명 |
|---|---|
| Source Field | Source Collection 오브젝트에서 열에 표시할 필드. **anyType 데이터 타입 필드(예: AccountHistory의 NewValue)는 미지원** |
| Custom column label | 지정한 column Label을 헤더로 표시할지 여부 |
| Label | Custom column label 선택 시 헤더로 표시할 텍스트. 스크린 리더도 읽음 |
| Default Text Overflow Mode | 열 너비보다 긴 텍스트 처리: **Wrap Text**(여러 줄) · **Clip Text**(잘라서 맞춤) |

> 네임스페이스 필드는 source field 앞에 네임스페이스 추가(예: `Acme__FieldName__c`).

**Data Table 값 저장(자동 저장; 수동은 Manually assign variables (advanced)):**

| 속성 | 설명 |
|---|---|
| First Selected Row | 사용자가 선택한 첫 레코드. 2개 선택 시 위→아래로 첫 번째 |
| Selected Rows | 사용자가 선택한 레코드 목록. 테이블 위→아래 순서 |

**Considerations**
- 모바일 기기와 비호환.
- Get Records로 표시 레코드를 가져오면 **Choose fields and let Salesforce do the rest**를 선택해야 성능 최적.
- Data Table 최대 높이 **400 픽셀**.
- text wrap 시 테이블 압축(다열 중 하나)되면 오버플로 가능 — 테스트 필요.
- **최대 1,500개 레코드 표시. 단 검색은 전체 데이터셋 대상.**
- **최대 200개 레코드 선택 가능.**
- 초기 레코드 로드 후 필터 적용 시 새 결과만 표시(초기 레코드 제외).
- DB에 커밋되지 않은 formula 필드/레코드는 formula가 제대로 평가 안 됨 → DB에 없는 레코드는 static 값·Formula 리소스로 assignment, 업데이트된 기존 레코드는 invocable action으로 재평가하거나 IN 연산자로 refresh.
- lookup·master-detail 관계 필드 값은 표시 안 됨(관련 레코드의 Name 필드 표시 불가) → object formula 필드 사용. 관련 레코드 링크 예:

```
HYPERLINK( "/" & CASESAFEID(Id), Related_Record__r.Name, "_self" )
```

- **Time 필드는 검색 불가.**
- multi-currency org에서 사용자 personal currency와 다른 통화 레코드 미지원.
- 다국어 열 헤더는 `$Label` 글로벌 변수 사용.
- 런타임 선택은 client payload data limit(Lightning Aura Components Developer Guide) 적용 — 초과 시 일반 오류. ContentVersion의 VersionData 같은 필드는 source collection에서 피할 것.
- Object Manager에서 열에 매핑된 필드명 변경 시 열 이름 자동 갱신 안 됨 → 열 제거 후 재추가.
- 다른 페이지에서 사용자 타임존을 바꾸면 flow 페이지 새로고침 필요.
- 다른 Data Table의 row selection 사용 시 주의 — record ID 없는 중복 record 변수의 row selection 미지원.
- row selection이 single + required이거나 min·max가 모두 1이면 런타임에 **radio 버튼**, 그 외에는 **checkbox** 사용.
- Data Table 포함 flow 패키징 시 사용 필드가 자동으로 패키지에 추가되지 않음 — 수동 추가.
- Data Table가 쓰는 custom 필드 삭제 시 화면 flow에서도 열 제거 필요.
- 네임스페이스 없는 org에서 custom object/field를 쓴 Data Table에 나중에 네임스페이스 추가 시 열 필드에도 네임스페이스 추가.

공통 블록: 표시 ✓ · 검증 ✓ · 재방문 ✓

---

## Dependent Picklists (종속 피클리스트)

한 picklist 옵션이 다른 picklist 선택 값에 종속되는 화면. org의 기존 **field dependency**(같은 오브젝트의 두 picklist 필드를 연결)로 각 picklist 옵션을 결정. **Lightning runtime 필요.**

> **Tip:** 컴포넌트 추가 전 org에서 해당 picklist 필드에 field dependency를 정의할 것.

| 속성 | 설명 |
|---|---|
| API Name | † |
| Disabled | † |
| Object API Name | 오브젝트 API명. Picklist 1/2/3 API Name의 필드가 이 오브젝트에 속해야 함. 단일 값 리소스(텍스트 취급) |
| Picklist 1 API Name | 첫 picklist 필드 API명. Picklist 1↔2 field dependency의 **controlling** 필드여야 함. 단일 값(텍스트) |
| Picklist 1 Label | 첫 picklist 레이블. 단일 값(텍스트) |
| Picklist 1 Required | `$GlobalConstant.True`면 값 입력 필수. 단일 값 Boolean |
| Picklist 1 Value | 첫 picklist 기본 선택(사전 선택). 단일 값(텍스트) |
| Picklist 2 API Name | 둘째 picklist 필드 API명. Picklist 1↔2의 **dependent** 필드. 셋째를 표시하면 Picklist 2는 Picklist 2↔3의 controlling 필드. 단일 값(텍스트) |
| Picklist 2 Label | 둘째 picklist 레이블. 단일 값(텍스트) |
| Picklist 2 Required | `$GlobalConstant.True`면 필수. 단일 값 Boolean |
| Picklist 2 Value | 둘째 picklist 기본 선택. 단일 값(텍스트) |
| Picklist 3 API Name | 셋째 picklist 필드 API명. Picklist 2↔3의 dependent 필드. 단일 값(텍스트) |
| Picklist 3 Label | 셋째 picklist 레이블. 단일 값(텍스트) |
| Picklist 3 Required | `$GlobalConstant.True`면 필수. 단일 값 Boolean |
| Picklist 3 Value | 셋째 picklist 기본 선택. 단일 값(텍스트) |

> 네임스페이스 org면 object API명과 각 picklist API Name 앞에 네임스페이스 추가(예: `Acme__Insurance_Agent__c`).

**값 저장(자동; 수동 가능):** Picklist 1 Value / Picklist 2 Value / Picklist 3 Value — 각각 사용자가 선택한 값. 단일 값 Text 변수 또는 record 변수의 Text 필드에 저장.

**Example (PDF 원문):** Dinner Order flow — 사용자가 dessert를 선택하면 flavor 옵션이 바뀜. Guest Order custom object에 Dessert·Flavor picklist를 만들고 Dessert를 controlling으로 하는 field dependency 정의. 컴포넌트 구성: Object API Name `Guest_Order__c`, Picklist 1 API Name `Dessert__c`, Picklist 1 Label `Dessert`, Picklist 2 Value `Flavor__c`, Picklist 2 Label `Flavor`.

**Considerations:** 화면 입력 컴포넌트 값은 조건부 visibility로 숨겨지면 null이 된다. 하지만 **Dependent Picklists 안의 숨겨진 picklist는 컴포넌트 전체가 숨겨지지 않는 한 null이 되지 않는다.**

공통 블록: 표시 ✓ · 검증 ✓ · 재방문 ✓

---

## Display Image (이미지 표시)

화면에 이미지 삽입. 이미지를 static resource로 Salesforce에 업로드 후 컴포넌트 구성 시 참조. **Lightning runtime 필요.**

| 속성 | 설명 |
|---|---|
| API Name | † |
| Horizontal Alignment | 브라우저가 수평 정렬을 결정하지 않게 하려면 값 지정. 유효값: `left`, `center`, `right`. 단일 값(텍스트) |
| Image Alt Text | 스크린 리더·이미지 로드 실패 브라우저용 대체 텍스트. 순수 장식/중복이 아니면 의미 있는 설명 제공. 보조기술이 이미지를 건너뛰게 하려면 `{!$GlobalConstant.EmptyString}`. 미설정 시 보조기술이 img src의 파일 경로를 읽어 접근성 문제 유발 가능. 단일 값(텍스트) |
| Image CSS | 자체 CSS 문자열로 이미지 CSS 오버라이드. 예: `border-radius: 8px; box-shadow: 10px 5px 5px blue; opacity: 0.75;`. 단일 값(텍스트) |
| Image Height | 브라우저가 높이를 결정하지 않게 하려면 값 지정. 숫자+단위 또는 컨테이너 %(예: `200 px`, `2 cm`, `50%`). 단위 없이 숫자만 입력하면 기본 px. 단일 값(텍스트) |
| Image Name | **Required.** 이미지 파일을 담은 static resource 이름. **`.png` 또는 `.jpg`.** 단일 값(텍스트) |
| Image Width | 브라우저가 너비를 결정하지 않게 하려면 값 지정. 숫자+단위 또는 %(예: `200 px`, `2 cm`, `50%`). 단위 없으면 기본 px. 단일 값(텍스트) |

값은 자동 저장(수동은 Manually assign variables (advanced)).

공통 블록: 표시 ✓ · 검증 ✓ · 재방문 ✓

---

## Enhanced Message (향상된 메시지)

enhanced Messaging 세션에서 메시징 컴포넌트를 전송.

> **Editions 예외:** Messaging은 Lightning Experience + **Digital Engagement add-on SKU** 필요 / Enterprise, Unlimited, Developer Editions + **Service Cloud 또는 Sales Cloud**.

| 속성 | 설명 |
|---|---|
| API Name | † |
| Messaging Session ID | 메시징 세션의 record ID를 담은 변수 |
| Messaging Component Name | screen 기반 flow에 넣을 메시징 컴포넌트(예: time selector 컴포넌트). Setup의 Messaging Components 페이지에서 생성 |
| Time Slot Options | 고객에게 보여줄 time slot 옵션 목록. custom Apex action으로 생성. **time selector 메시징 컴포넌트 선택 시에만 표시** |
| Object Type | 고객에게 보여줄 레코드 타입(예: Case). **dynamic options 질문 메시징 컴포넌트 선택 시에만 표시** |
| Record Variable | 선택한 오브젝트 타입 중 어떤 레코드를 고객에게 보여줄지 결정하는 record 변수. **dynamic options 질문 컴포넌트 선택 시에만 표시** |
| Parameter Name | 선택한 메시징 컴포넌트의 custom 파라미터 이름 |
| Parameter Value Type | custom 파라미터 타입. 유효값: `Variable`, `Literal`. 기본값 `Variable` |
| Value | 파라미터로 전달할 값(예: 옵션 목록 앞의 질문) |
| Variable | 파라미터로 전달할 변수(예: 연락처 이름을 담은 변수) |

공통 블록: 표시 ✗ · 검증 ✗ · 재방문 ✗ (PDF에 없음)

---

## File Upload (파일 업로드)

화면에서 파일 업로드. **Lightning runtime 필요.**

| 속성 | 설명 |
|---|---|
| Accepted Formats | `.ext` 형식으로 업로드 허용 확장자를 콤마 구분 목록으로 입력. 단일 값(텍스트) |
| Allow Multiple Files | `$GlobalConstant.True`면 여러 파일 업로드 가능. 단일 값 Boolean |
| API Name | † |
| Disabled | † |
| File Upload Label | **Required.** 업로드 버튼 위에 표시되는 레이블. 단일 값(텍스트) |
| Hover Text | 컴포넌트에 hover 시 나타나는 툴팁. 단일 값(텍스트) |
| Related Record ID | **Required.** 파일을 연결할 레코드 ID. **값을 전달하지 않으면 컴포넌트가 비활성화됨.** 단일 값(텍스트) |

> ContentVersion 오브젝트 페이지에 추가한 custom 필드는 Experience Cloud 사이트에서 contentVersionEditWizard로 렌더됨(데스크톱 지원, 모바일 미지원). 모바일에는 custom 필드 편집 화면이 없어 custom 필드가 required면 업로드 실패.

**값 저장(대개 아래 중 하나 저장; 사용자가 다음 화면으로 이동할 때 flow 변수에 할당):**

| 속성 | 설명 |
|---|---|
| Content Document IDs | 업로드된 파일 ID들. **Text collection 변수**에 저장 |
| Uploaded File Names | 업로드된 파일 이름들. **Text collection 변수**에 저장 |

**File Upload Limits**
- 기본 **동시 10개** 업로드(Salesforce가 한도를 바꾸지 않은 경우).
- org 한도는 **동시 25개(최소 1개)**.
- **최대 파일 크기 2 GB.**
- Experience Cloud 사이트에서는 site file moderation 설정을 따름. **기본적으로 guest user 파일 업로드 차단.** Admin이 Setup > General Settings > **Allow site guest users to upload files**로 허용 가능(단 org에 **Secure guest user record access** 설정이 켜져 있어야 유효).

> File Upload 컴포넌트는 **URL로 접근하는 flow의 모바일 앱·브라우저에서 미지원**(Lightning App Builder·Experience Builder 사용 시 제외). **Lightning Out은 File Upload 미지원.**

**Considerations:** 사용자가 파일을 업로드하지 않으면 Content Document IDs·Uploaded File Names 출력 값은 빈 컬렉션 `[]`. ISBLANK·ISNULL 연산자로 확인하면 값은 항상 `false`.

공통 블록: 표시 ✓ · 검증 ✓ · 재방문 ✓

---

## Lookup (룩업)

flow에서 하나 이상의 레코드를 검색·선택.

| 속성 | 설명 |
|---|---|
| API Name | † |
| Field API Name | Object API Name이 참조하는 source 오브젝트의 lookup 필드 API명. 이 필드는 Object API Name 오브젝트에 있는 필드여야 함. 예: account lookup을 추가하려면 account lookup 필드가 있는 오브젝트를 찾음 — Contact의 account lookup 필드 API명이 `AccountId`이므로 Field API Name에 `AccountId`, Object API Name에 `Contact` |
| Label | 컴포넌트 상단에 표시되는, 사용법을 알리는 텍스트(예: account lookup이면 `Select Account`) |
| Object API Name | Field API Name의 lookup 필드를 가진 source 오브젝트 API명. **실행 사용자는 source 오브젝트에 Create 권한 필요.** 예: contact lookup은 Case의 contact lookup 필드 사용 — Object API Name `Case`, Field API Name `ContactId` |
| Disabled | † |
| Maximum Selections | 사용자가 선택 가능한 최대 레코드 수. **기본 1** |
| Record Id | Maximum Selections=1이거나 (>1이고 Record ID Collection이 null이면) 기본 선택 lookup record ID. 실행 시 사용자 선택으로 값 변경 |
| Record Id Collection | Maximum Selections>1이면 기본 record ID들. >1이고 Record ID가 null이면 첫 값이 기본 선택 record ID들. Maximum Selections까지 임의 개수 지정. 실행 시 사용자 선택으로 변경 |
| Required | † |

> 네임스페이스 org면 object·field API명 앞에 네임스페이스 추가.

**값 저장(자동; 수동 가능):**

| 속성 | 설명 |
|---|---|
| Record ID | Maximum Selections=1이면 사용자가 선택한 레코드 ID. Text 변수에 저장 |
| Record ID Collection | Maximum Selections>1이면 선택 레코드 ID 목록. =1이고 Record ID가 null이면 첫 값이 선택 레코드 ID. Text collection 변수 |
| Record Name | Maximum Selections=1이면 선택 레코드 Name 필드 값. >1이면 첫 선택 레코드의 Name. Text 변수. **Name 필드가 external object면 채워지지 않음** |

**Considerations**
- 모바일 기기·standalone Aura 앱과 비호환.
- **Dependent lookup filter는 flow의 Lookup 컴포넌트에서 강제되지 않음.** 다른 lookup filter는 Lightning Experience record 페이지와 동일하게 강제됨 — flow가 DB에 접근할 때(예: Create Records) lookup filter 미충족 시 실패.
- 리소스·flow 정보로 레코드를 필터링하려면 Choice Lookup 컴포넌트 고려.
- **user 레코드로의 custom lookup 필드 미지원.** (Tip: user 레코드 선택은 `CreatedById`·`LastModifiedById` 같은 표준 User lookup 필드 사용. **OwnerId 미지원.**)
- 실행 시 필드에 2글자 입력하면 Name 필드가 매칭되는 최근 레코드 **최대 5개** 표시.
- Field API Name의 lookup 필드가 할당된 page layout에 없으면 실행 시 `Search undefined...` 표시 → 실행 사용자에게 할당된 모든 page layout에 필드 추가.
- 잘못된 Record ID는 무시(유효 Salesforce Record ID가 아니거나 key prefix가 field API name 오브젝트와 불일치).
- Maximum Selections=1이고 Record ID Collection·Record ID가 둘 다 변경되면 **Record ID 우선**, Collection 무시. >1이면 Record ID가 채워졌을 때 Collection 우선; Collection이 안 채워졌으면 Record ID로 Collection을 single item으로 채움.
- **polymorphic 필드(둘 이상 오브젝트 관계, 예: task의 WhoId) 미지원.**
- Field API Name·Object API Name은 **대소문자 구분.**
- source 오브젝트 record type으로 필터링 미지원.

공통 블록: 표시 ✓ · 검증 ✓ · 재방문 ✓

---

## Multi-Select Picklist (다중 선택 피클리스트)

picklist 형식으로 여러 옵션 선택.

| 속성 | 설명 |
|---|---|
| API Name | † |
| Choice | choice·record choice set·picklist choice set 최소 1개 추가. choice 컴포넌트 추가 시만 사용 가능 |
| Component Type | choice 컴포넌트 타입 변경. 단일 선택이면 Picklist·Radio Buttons, 다중이면 Checkbox Group·Multi-select Picklist |
| Data Type | **Text choice만 지원** |
| Default Value | 사전 선택 choice. 미실행·visibility 미충족이면 `null` |
| Disabled | † |
| Label | † |
| Let Users Select Multiple Options | Yes 선택 시 Data Type 자동 Text, 비-text Choice 리소스 제거 |
| Provide Help | † |
| Require | † |

**Considerations:** **Rich text 미지원.**

공통 블록: 표시 ✓ · 검증 ✗ · 재방문 ✓

---

## Order Management Product Selector (오더 관리 제품 선택기)

반품·교환 등 거래 유형별 product selector에서 열에 표시할 필드를 선택. **Lightning runtime 필요.** flow의 데이터로 product 필드 설정.

### Configure (입력)

| 속성 | 설명 |
|---|---|
| Configure Columns | **Required.** 표시할 열 **최대 10개** 선택 |
| Order Product Summaries | **Required.** product summary 컬렉션 |
| Selected Order Product Summaries | **Required.** 변경 중인 product summary의 subset 컬렉션 |
| Selected Order Summary | **Required.** product summary가 속한 order summary |
| Transaction Type | **Optional.** 거래 유형. 유효값: `Cancel`, `RMS`, `Return`, `Reship`, `Discount`, `Exchange` |

### Attributes to Output (출력)

| 속성 | 설명 |
|---|---|
| Order Product Summaries | product summary 컬렉션 |
| Selected Order Summary | 선택된 order summary |
| Selected Order Product Summaries | 변경 중인 product summary의 subset 컬렉션 |
| Transaction Type | 거래 유형 |

공통 블록: 표시 ✗ · 검증 ✗ · 재방문 ✗ (PDF에 없음)

---

## Picklist (피클리스트)

picklist 형식으로 옵션 하나 선택.

> **Flow Run-time API version 52부터** 모든 picklist의 첫 옵션은 `--None--`. Flow Builder에서 기본값을 설정하지 않으면 실행 시 `--None--`이 자동 선택되며 **null 값으로 취급**된다. picklist를 required로 설정하고 사용자가 `--None--`을 선택하면 다음 화면 진행이 차단된다.

| 속성 | 설명 |
|---|---|
| API Name | † |
| Choice | choice·record choice set·picklist choice set 최소 1개 추가. 동적 Choice 리소스는 값이 고유해야 함(중복 선택 시 잘못 저장) |
| Component Type | choice 컴포넌트 타입 변경(단일: Picklist·Radio Buttons / 다중: Checkbox Group·Multi-select Picklist) |
| Data Type | 사용 가능 choice를 제어(예: Number 선택 시 Text choice 선택 불가) |
| Decimal Places | 소수점 오른쪽 자릿수 **최대 17자리**. 비우거나 0이면 정수만 표시. **Data Type이 Number 또는 Currency일 때만** 사용 가능 |
| Default Value | 사전 선택 choice. 미실행·visibility 미충족이면 `null` |
| Disabled | † |
| Label | † |
| Let Users Select Multiple Options | Yes 선택 시 Data Type 자동 Text, 비-text Choice 제거 |
| Provide Help | † |
| Require | † |

**Considerations:** **Rich text 미지원.**

공통 블록: 표시 ✓ · 검증 ✗ · 재방문 ✓

---

## Radio Buttons (라디오 버튼)

라디오 버튼 형식으로 옵션 하나 선택.

| 속성 | 설명 |
|---|---|
| API Name | † |
| Choice | choice·record choice set·picklist choice set 최소 1개 추가. 동적 Choice 리소스는 값 고유. **모든 multi-select choice 컴포넌트는 text 데이터 타입을 쓰지만, radio buttons·picklist는 number나 Boolean choice도 사용 가능** |
| Component Type | choice 컴포넌트 타입 변경(단일: Picklist·Radio Buttons / 다중: Checkbox Group·Multi-select Picklist) |
| Data Type | 사용 가능 choice 제어(예: Number 선택 시 Text choice 불가) |
| Decimal Places | 소수점 오른쪽 자릿수 최대 17자리. 비우거나 0이면 정수만. **Number 또는 Currency일 때만** |
| Default Value | 사전 선택 choice. 미실행·visibility 미충족이면 `null` |
| Disabled | † |
| Label | † |
| Let Users Select Multiple Options | Yes 시 Data Type 자동 Text, 비-text Choice 제거 |
| Provide Help | † |
| Require | † |

공통 블록: 표시 ✓ · 검증 ✗ · 재방문 ✓

---

## Slack Channel Selector (Slack 채널 선택기)

화면에서 Slack 메시지를 보낼 Slack 채널 선택. **Lightning runtime 필요.**

| 속성 | 설명 |
|---|---|
| API Name | † |
| Slack app id | Salesforce에 연결된 Slack 앱의 ID. **Text 변수** 허용. Slack 앱 소유자만 조회 가능 — api.slack.com > apps > Basic Information에서 앱 ID 확인 |
| Slack workspace id | Slack 앱이 설치된 workspace ID. **Text 변수** 허용. Slack 웹 버전에서 `T`로 시작하는 URL의 영숫자 부분 복사 |
| Use Bot Token | Slack 앱의 bot token 기반으로 채널 목록을 가져옴. Boolean 리소스 허용. `$GlobalConstant.False`면 bot token 대신 user token 사용 |
| Use Channel Search API | type-ahead Slack 채널 검색으로 채널 목록을 가져올지 여부. Boolean 리소스. Slack 앱이 private API 사용을 위해 Slack에 등록돼 있어야 함 |
| Label for dropdown | selector 헤딩에 표시되는 텍스트. 단일 값(텍스트) |
| Placeholder for dropdown | 필드가 비었을 때의 힌트 텍스트. 단일 값(텍스트) |
| Required | `$GlobalConstant.True`면 값 입력 필수. 단일 값 Boolean |
| Selected channel id | 선택된 Slack 채널 ID. 채널 ID는 채널 우클릭 > View channel details > About 탭에서 확인 |

공통 블록: 표시 ✓ · 검증 ✓ · 재방문 ✓

---

## Slack Workspace Selector (Slack 워크스페이스 선택기)

화면에서 Slack 메시지를 보낼 Slack workspace 선택. **Lightning runtime 필요.**

| 속성 | 설명 |
|---|---|
| API Name | † |
| Slack appID | Salesforce에 연결된 Slack 앱 ID. **Text 변수** 허용. 앱 소유자만 조회(api.slack.com > apps > Basic Information) |
| Workspace ID | Slack 앱이 설치된 workspace ID. **Text 변수** 허용. Slack 웹 버전에서 `T`로 시작하는 URL 영숫자 부분 복사 |
| Select... | 필드가 비었을 때의 placeholder 힌트 텍스트. 단일 값(텍스트) |
| Workspace Name | Slack 앱이 설치된 workspace 이름. 단일 값(텍스트) |
| Required | `true`면 값 입력 필수. 기본 `false`. Boolean 리소스 |

공통 블록: 표시 ✓ · 검증 ✓ · 재방문 ✓

---

## Display Text (텍스트 표시 — output)

화면에 정보 표시.

| 속성 | 설명 |
|---|---|
| API Name | † |
| Text box | flow 사용자에게 표시할 텍스트. URI를 포함하면 지원되는 URI prefix 사용: `http:`, `https:`, `//`, `/`, `file:`, `ftp:`, `mailto:`, `sfdc:`, `data:` |

**Example:** flow가 사용자를 대신해 한 작업을 요약하는 확인 메시지 표시.

> Password 컴포넌트를 Display Text에서 참조하면 값이 **마스킹되지 않고 노출**됨([[Screen Component 레퍼런스 - 입력]]의 Password 경고 참조).

공통 블록: 표시 ✓ · 검증 ✗ · 재방문 ✗

---

## Repeater (리피터 — display)

같은 유형의 여러 항목 정보를 한 화면에서 수집. 출력을 flow 다른 곳에서 쓰려면 출력을 loop해 관련 데이터를 변수에 저장하고 그 변수로 레코드 목록 구성. **최적 성능을 위해 flow·runtime을 API version 58.0 이상으로 설정 권장.**

### Configure the Repeater Component

| 속성 | 설명 |
|---|---|
| API Name | † (스크린 리더가 Repeater와 자식 컴포넌트를 안내할 때 API명 사용) |

### Configure Data Source

런타임에 Repeater를 사전 채우는 항목 컬렉션 선택. Repeater의 자식 컴포넌트가 이 컬렉션 값을 참조 가능.

| 속성 | 설명 |
|---|---|
| Collection for Prepopulated Items | 선택한 컬렉션의 필드가 Repeater 자식 컴포넌트에서 사용 가능해짐 |
| Unique Identifier for Items | 각 항목의 고유 식별자를 담은 필드 API명. **오브젝트의 ID 필드로 자동 설정됨** |

### Configure Display Options

| 속성 | 설명 |
|---|---|
| Let Users Add or Remove Items | screen flow 최종 사용자가 Repeater 인스턴스에서 새 항목을 추가하거나 사전 채워진 항목을 제거할 수 있는지 선택. **사용자가 직접 추가한 항목은 제거 가능** |

**Usage:** Repeater 구성 후 내부에 하나 이상의 자식 컴포넌트를 추가·구성. flow는 Repeater 사용자 입력을 **`AllItems` 속성**에 저장. 이 컬렉션을 loop해 나중에 쓸 collection 변수를 만듦.

**Considerations**
- **Action Button (Beta) 컴포넌트나 record 필드를 Repeater에 포함할 수 없음.**
- Repeater 출력은 **Transform, Collection Filter, Collection Sort** 요소에서 미지원.
- 다른 Repeater 컴포넌트의 출력을 Repeater 자식 컴포넌트에서 참조 불가.
- collection choice set 리소스를 Choice 필드에서 참조하는 Choice 컴포넌트는 Repeater 내에서 **반응형이 아님**.
- 화면 내에서 컴포넌트를 Repeater 안/밖으로 이동 가능하나, 이동된 컴포넌트로의 참조는 **깨짐**.
- Manually Assign Variables가 선택된 컴포넌트를 Repeater로 이동하면 수동 할당이 제거되고 체크박스 해제(변수 자체는 flow에 남음) — 이동 후 깨진 참조 검토 권장.
- 런타임에 **최대 30개** Repeater 인스턴스 추가 가능.
- 컴포넌트 자신 내 참조 형식은 `{!repeaterAPIName.fieldName}`. validation 메시지·flow 메타데이터 패키지에서 동일 참조 형식은 `{!repeaterAPIName.AllItems[$Items].fieldName}`.
- `AllItems`가 **비는 경우**: (1) Repeater가 Display Text처럼 사용자 입력을 받지 않는 자식 컴포넌트만 포함, (2) 사용자가 인스턴스를 추가하지 않음.
- `AllItems`가 **null인 경우**: 모든 자식 컴포넌트가 조건부 field visibility로 숨겨짐.

**Example:** Text·Date·Toggle·Checkbox Group 자식 컴포넌트가 있는 Repeater로 구독자 정보를 수집하는 화면.

공통 블록: 표시 ✓ · 검증 ✗ · 재방문 ✗

---

## Section (섹션 — output)

화면 컴포넌트와 record 필드를 조직화해 사용자 경험 향상. **Lightning runtime 필요.**

**Usage:** section으로 컴포넌트·필드를 조직화해 컨텍스트와 탐색 편의 제공. Section 컴포넌트는 **선택적 헤더**와 **최대 4개의 나란한 열(column)**을 가진다. 각 열은 여러 컴포넌트·필드를 담고, 한 화면에 여러 section을 배치 가능(각자 헤더·열 수 보유).

> **Tip:** section에 조건부 visibility 규칙을 적용하면 그 section의 모든 컴포넌트·필드에 영향. 열이 하나뿐이어도 많은 컴포넌트의 visibility를 한 번에 설정하는 용도로 활용.

> [!note] PDF에는 Section 구성 요소를 번호로 가리키는 **다이어그램**이 있다(pdftotext가 이미지를 못 잡음). 본문 설명은 그 번호 항목의 텍스트 캡션 그대로다.

Section 구성 요소(PDF 다이어그램 캡션):
- **Headers (1)** — section 헤더로 시각적 위계를 만들어 중요한 항목으로 안내. 헤더가 있는 모든 section은 접을 수 있고 사용자가 화면 방문 시마다 기본 열림. 헤더 레이블은 번역 가능.
- **Columns (2)** — 열로 화면을 조직화해 불필요한 스크롤 방지.
- **Column Width (3)** — 열 추가·삭제 시 Flow Builder가 해당 section의 모든 열 너비를 동일하게 설정. 변경하려면 사전 정의 옵션에서 너비 선택.
- **Column Deletion (4)** — 열 삭제 시 그 열의 모든 컴포넌트·필드가 삭제됨.

> **Tip:** 컴포넌트·필드를 가운데 정렬·들여쓰기하거나 padding을 넣으려면 화면에 빈 열을 포함.

**Considerations**
- section은 flow를 보여주는 **창 크기에 반응형**. 소형 폼팩터 기기에서는 열이 세로로 쌓임. 단 Lightning page 열·utility bar 너비에는 반응하지 않음(예: 사이드바에 flow를 표시해도 전체 창 너비가 열 배치를 결정).
- 화면에 Section 컴포넌트가 있으면, Experience Builder·Lightning App Builder·utility bar로 배포 시 **Layout 속성을 무시**. URL 배포 시 **`flowLayout` URL 파라미터도 무시**.

공통 블록: 표시 ✓ · 검증 ✗ · 재방문 ✗

---

## 관련 노트

- [[Screen Component 레퍼런스 - 입력]] — 짝 노트: 단일 값 입력 계열 15종(Address·Checkbox·Currency·Date·Email·Name·Slider·Text·Toggle·URL 등) + 공통 속성(†)·공통 블록 전문
- [[Screen Flow 설계]] — Screen Flow 메타데이터 구조(`flowruntime:` 컴포넌트 XML) + Reactive Screen Components(반응형 화면)
- [[quickChoice Screen Component]] — 표준 선택 컴포넌트로 부족할 때의 커스텀 선택 컴포넌트
- [[Flow Screen LWC 패턴]] — 커스텀 스크린 컴포넌트 제작 기본 패턴
- [[Flow 리소스 레퍼런스]] — Choice·Record Choice Set·Global Constant 등 선택 컴포넌트가 참조하는 리소스
