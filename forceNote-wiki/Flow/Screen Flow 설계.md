---
tags: [flow, screen, lwc, component, design]
source: dreamhouse-lwc/Create_property, lwc-recipes/SimpleGreetingFlow
created: 2026-05-17
aliases: [Screen Flow, Flow Screen 설계, flowruntime, Flow 화면]
---

# Screen Flow 설계

> `processType: Flow`. 사용자가 단계별로 입력하는 마법사형 UI. LWC 컴포넌트 삽입 가능.

---

## Screen 기본 구조

```xml
<screens>
    <name>new_property</name>
    <label>New Property</label>
    <locationX>666</locationX>
    <locationY>158</locationY>

    <!-- 화면 이동 버튼 설정 -->
    <allowBack>true</allowBack>
    <allowFinish>true</allowFinish>
    <allowPause>true</allowPause>

    <showHeader>true</showHeader>
    <showFooter>true</showFooter>

    <connector>
        <targetReference>next_screen_or_element</targetReference>
    </connector>

    <fields><!-- 화면 구성 요소들 --></fields>
</screens>
```

---

## Screen Field 타입

### InputField — 사용자 입력

```xml
<fields>
    <name>property_name</name>
    <dataType>String</dataType>      <!-- String, Number, Currency, Date 등 -->
    <fieldText>Property Name</fieldText>
    <fieldType>InputField</fieldType>
    <isRequired>true</isRequired>
    <defaultValue>
        <stringValue>기본값</stringValue>
        <!-- 또는 <elementReference>변수명</elementReference> -->
    </defaultValue>
    <scale>0</scale>                 <!-- Number 타입: 소수점 자리수 -->
</fields>
```

### DisplayText — 읽기 전용 텍스트 (HTML 지원)

```xml
<fields>
    <name>Welcome_Message</name>
    <fieldText>&lt;p&gt;&lt;b&gt;환영합니다&lt;/b&gt;&lt;/p&gt;</fieldText>
    <fieldType>DisplayText</fieldType>
</fields>
```

> HTML 태그는 XML escape 필요: `<` → `&lt;`, `>` → `&gt;`, `&` → `&amp;`
> 수식 변수도 참조 가능: `{!User_Name_Display}`

---

## 표준 내장 컴포넌트 (flowruntime:)

> 표준 스크린 컴포넌트 33종의 **속성(attribute) 전수 카탈로그**는 두 레퍼런스 노트로 분리돼 있다. 이 절은 메타데이터(XML) 삽입 형태만 다룬다.
> - 단일 값 입력 계열 15종 → [[Screen Component 레퍼런스 - 입력]]
> - 선택·데이터·디스플레이·기타 18종 → [[Screen Component 레퍼런스 - 디스플레이·선택·기타]]

```xml
<!-- 주소 입력 -->
<fields>
    <name>property_address</name>
    <extensionName>flowruntime:address</extensionName>
    <fieldType>ComponentInstance</fieldType>
    <isRequired>true</isRequired>
    <storeOutputAutomatically>true</storeOutputAutomatically>
    <!-- 결과: property_address.street, .city, .province, .postalCode, .country -->
</fields>

<!-- 레코드 검색 (Lookup) -->
<fields>
    <name>property_broker</name>
    <extensionName>flowruntime:lookup</extensionName>
    <fieldType>ComponentInstance</fieldType>
    <inputParameters>
        <name>objectApiName</name>
        <value><stringValue>Property__c</stringValue></value>
    </inputParameters>
    <inputParameters>
        <name>fieldApiName</name>
        <value><stringValue>Broker__c</stringValue></value>
    </inputParameters>
    <inputParameters>
        <name>label</name>
        <value><stringValue>Broker</stringValue></value>
    </inputParameters>
    <isRequired>true</isRequired>
    <storeOutputAutomatically>true</storeOutputAutomatically>
    <!-- 결과: property_broker.recordId, .displayValue -->
</fields>

<!-- 파일 업로드 -->
<fields>
    <name>property_picture</name>
    <extensionName>forceContent:fileUpload</extensionName>
    <fieldType>ComponentInstance</fieldType>
    <inputParameters>
        <name>label</name>
        <value><stringValue>Upload Picture</stringValue></value>
    </inputParameters>
    <inputParameters>
        <name>accept</name>
        <value><stringValue>.jpg,.png,.gif</stringValue></value>
    </inputParameters>
    <inputParameters>
        <name>recordId</name>
        <value><elementReference>create_property</elementReference></value>
    </inputParameters>
    <inputParameters>
        <name>multiple</name>
        <value><booleanValue>true</booleanValue></value>
    </inputParameters>
    <isRequired>true</isRequired>
    <storeOutputAutomatically>true</storeOutputAutomatically>
</fields>
```

---

## 커스텀 LWC 컴포넌트 삽입

```xml
<fields>
    <name>navigate_to_record_lwc</name>
    <extensionName>c:navigateToRecord</extensionName>  <!-- c:컴포넌트명 -->
    <fieldType>ComponentInstance</fieldType>
    <inputParameters>
        <name>recordId</name>
        <value>
            <elementReference>create_property</elementReference>
        </value>
    </inputParameters>
    <isRequired>true</isRequired>
    <storeOutputAutomatically>true</storeOutputAutomatically>
    <inputsOnNextNavToAssocScrn>UseStoredValues</inputsOnNextNavToAssocScrn>
</fields>
```

LWC에서 Flow에 값 전달:
```javascript
// LWC → Flow 값 변경
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';
this.dispatchEvent(new FlowAttributeChangeEvent('value', newValue));
```

`inputsOnNextNavToAssocScrn` 옵션:
- `UseStoredValues`: 뒤로 가서 다시 Next 시 이전 값 유지
- `ResetValues`: 뒤로 가서 다시 Next 시 초기화

---

## LWC에서 Flow 기동

```javascript
// NavigationMixin으로 Screen Flow 열기
import { NavigationMixin } from 'lightning/navigation';

this[NavigationMixin.Navigate]({
    type: 'standard__flow',
    attributes: {
        flowApiName: 'SimpleGreetingFlow'
    },
    state: {
        userName: this.currentUser.Name  // isInput=true 변수에 값 전달
    }
});
```

---

## 다단계 Screen Flow 설계 패턴

```
[화면1: 기본 정보]
    ↓
[Apex Action: 주소 지오코딩]
    ↓ (성공)         ↓ (faultConnector: 오류 화면)
[화면2: 상세 정보]
    ↓
[Create Records]
    ↓ (성공)         ↓ (faultConnector: 오류 화면)
[화면3: 사진 업로드]
    ↓
[Get Records: 업로드된 파일 조회]
    ↓
[Decision: 파일 있음?]
    ↓ Yes                     ↓ No (default)
[Update Records: 썸네일 설정]
    ↓
[화면4: 완료]
```

**오류 화면 설계:**
- 각 DML/Action 요소에 `faultConnector` → 오류 화면 연결
- `allowBack: false` + `allowFinish: true` (닫기만 가능)
- `{!$Flow.FaultMessage}` 로 실제 오류 메시지 표시 가능

---

## Reactive Screen Components (반응형 화면)

반응성(reactivity)은 지원되는 화면 컴포넌트·수식이 **같은 화면 위 다른 컴포넌트의 변경에 실시간으로 반응**하게 한다. 화면을 SPA(single-page application)처럼 느끼게 만들고, 사용자가 거쳐야 할 화면 수를 줄인다. **API version 59.0 이상에서 지원.** (source: ECA "Make Your Screen Flows Reactive")

- **Editions:** both Salesforce Classic·Lightning Experience / Essentials, Professional, Enterprise, Performance, Unlimited, Developer Editions. 단 **Classic runtime에서는 반응성 미지원.**

### source ↔ reactive 컴포넌트

반응형 상호작용을 만들기 전, 어떤 컴포넌트가 **source**(변경의 근원)이고 어떤 컴포넌트가 그 변경에 **반응(react)**하는지 정한다. 예: Slider 2개(값 선택 = source)와 그 합을 표시하는 Number 컴포넌트(반응). **source와 reactive 값은 반드시 동일한 타입**이어야 한다(예시는 모두 number 타입). 반응형 화면은 표준 컴포넌트로 만드는 게 가장 쉽다. 커스텀 flow 컴포넌트를 쓰면 LWC Developer Guide의 reactivity 예시를 검토한다.

구성 절차: (1) screen flow 생성 후 Screen 요소 추가 → (2) source 컴포넌트 추가·구성(예: 이름 목록을 보여주는 Data Table) → (3) 반응 컴포넌트 추가(예: Name 컴포넌트의 First Name을 `DataTableAPIName.firstSelectedRow.FirstName`으로 설정) → (4) 저장·실행.

### 반응성 동작 규칙 (behaviors)

- **컴포넌트의 수동(manual) 출력은 반응성 미지원** — 컴포넌트 출력을 수동으로 변수에 설정하면 그 변수는 같은 화면의 다른 컴포넌트에서 참조돼도 변하지 않는다.
- **help text·label은 다른 컴포넌트 변경에 반응하지 않는다**(이벤트에 응답하도록 구성된 커스텀 LWC 레이블은 예외).
- 출력을 다른 컴포넌트 입력에 매핑할 때 **데이터 타입이 일치**해야 반응성 지원.
- 커스텀 컴포넌트에 validation 규칙이 있으면 reactive 변경은 validation을 트리거하지 않는다.
- **`$Flow` 글로벌 변수는 반응형.** Custom Labels·Custom Settings·`$Organization`·`$Profile` 등 그 외 글로벌 변수는 **비반응형.**
- DateTime 필드를 Time에 매핑하면 GMT로 변환되고 화면 이동 시에도 유지됨. DateTime 필드에 매핑하면 locale 보존.

### 표준 컴포넌트별 반응성 지원 (Level of Reactivity)

PDF "Standard Screen Flow Components that Support Reactivity" 표 전수. **Full** = 완전 지원. 그 외는 제약 사항.

| 컴포넌트 | 반응성 수준 |
|---|---|
| Address | Full |
| Checkbox | Full |
| Choice Lookup | Full |
| Currency | Full |
| Data Table | Full |
| Date | Full |
| Date & Time | Full |
| Dependent Picklist | 변경에 **반응하지는 않지만** 다른 컴포넌트에 변경을 **push**할 수 있음 |
| Display Text | 참조 출력이 Currency 타입 record 변수면 값이 다르게 표시됨(통화 기호 없이 렌더) → Currency formula로 감싸 회피. 이전 화면 Choice 리소스를 참조하면 Choice Value 대신 Choice Label 표시. 본문에 다른 컴포넌트 참조를 넣으면 텍스트가 reactive formula와 동일한 문자 한도 적용(bold 등 서식도 카운트) — 한도 초과 시 비반응. reactive Display Text 디버그 시 Debug Details 창은 텍스트 변경을 갱신하지 않음. 비-Text 컬렉션 참조 시 같은 화면의 다른 컴포넌트 출력을 함께 참조할 수 없음(오류) |
| Email | Full |
| Long Text Area | Display Text와 동일한 Currency·문자 한도·비-Text 컬렉션 제약 |
| Lookup | Full |
| Multi-Select Picklist | Full |
| Name | **Available Options·salutationOptions 입력 파라미터는 반응성 미지원** |
| Number | Full |
| Password | Full |
| Phone | **pattern·value 입력이 바뀌어도 validation이 트리거되지 않음** |
| Picklist | Full |
| Radio Buttons | Full |
| Repeater | 자식 컴포넌트끼리 서로 출력 참조 가능. 단 **다른** Repeater의 자식 출력은 참조 불가. collection choice set을 참조하는 Choice 컴포넌트는 Repeater 내에서 비반응. **수식에서 Repeater 참조 미지원** |
| Slider | 반응성 설정 시 값이 허용 범위 밖으로 설정될 수 있음 |
| Text | Full |
| Toggle | Full |
| URL | **pattern·value 입력이 바뀌어도 validation이 트리거되지 않음** |

- **LWC 반응성:** LWC도 반응성 지원. 다른 컴포넌트에 반응을 트리거하려면 attribute change event를 fire, 다른 컴포넌트 변경에 반응하려면 `@api` 파라미터 변경 시 상태 갱신.
- **반응성 미지원 컴포넌트:** Display Image · File Upload · Aura components.
- **반응성 미지원 리소스:** 컴포넌트 출력을 담은 변수 · record choice set.
- **반응성 미지원 필드:** 화면의 record 필드(Dynamic Forms for Flow).

### Reactive formula 연산자 (subset)

screen flow의 수식 연산자 중 일부만 반응성 지원. 반응형 컴포넌트를 참조하는 수식에 아래 연산자·함수를 쓰면 값 변경 시 실시간 재계산된다.

- **Math 연산자:** `+` `-` `*` `/` `^`
- **Logical 연산자:** `=` `<>` `<` `>` `<=` `>=`
- **Text 연산자:** `&` 와 `+` (Concatenate)
- **Date and Time 함수:** ADDMONTHS, DATE, DATEVALUE, DATETIMEVALUE, DAY, MONTH, NOW, TODAY, WEEKDAY, YEAR
- **Logical 함수:** AND, BLANKVALUE, CASE, IF, ISBLANK, ISNULL, ISNUMBER, NOT, NULLVALUE, OR
- **Math 함수:** ABS, CEILING, EXP, FLOOR, LN, LOG, MAX, MCEILING, MFLOOR, MIN, MOD, ROUND, SQRT
- **Text 함수:** BEGINS, CONTAINS, FIND, LEFT, LEN, LOWER, MID, RIGHT, SUBSTITUTE, TEXT, TRIM, UPPER, VALUE
- **Advanced 함수:** INCLUDES

**Formula considerations**
- **cross-object formula(두 관련 오브젝트에 걸쳐 merge 필드를 참조하는 수식)는 반응성 미지원.** 예: `myContactDataTable.FirstSelectedRow.Account.Name`은 비반응이며 같은 화면 컴포넌트에 나타나지 않음.
- 초기값이 null인 필드에 의존하는 reactive formula는 사용자가 값을 줄 때까지 계산되지 않음 → `BLANKVALUE({!resource},0)`으로 null을 0으로 설정.
- **reactive formula는 3,900자 제한.** 저장 시 Salesforce가 문자를 추가하므로 입력이 한도 미만이어도 초과할 수 있음. 초과 시 반응성 미지원.

### 반응형 화면 구축 권장사항

```text
<!-- 구조 예시 — 실제 동작 설정 아님 (PDF "Recommendations for Building Reactive Screens" 요지) -->
- 컴포넌트 입력을 다른 컴포넌트 출력에 직접 매핑. 'Hello there, {!Screen_Input_1}!' 같은
  merge 필드 참조 대신 formula 리소스 사용.
- 화면의 change 이벤트에 연결하지 않은 채 데이터를 폴링/쿼리하는 컴포넌트 지양.
  반응성으로 데이터 쿼리 시 사용자 권한 고려·결과 제한(성능).
- reactive formula에서 null/empty 값 계획. 조건부 visibility 미충족 null/empty는 반응성과 호환 안 됨.
- self-referencing 항목(자신에 텍스트를 덧붙이는 formula 필드 등)은 무한 재귀 유발 → 회피.
```

---

## 관련 노트

- [[Flow 종류와 변수]]
- [[Flow 요소 참조]]
- [[Screen Component 레퍼런스 - 입력]] — 표준 입력 컴포넌트 15종 속성 카탈로그
- [[Screen Component 레퍼런스 - 디스플레이·선택·기타]] — 표준 선택·디스플레이 컴포넌트 18종 속성 카탈로그
- [[Flow Screen LWC 패턴]]
- [[NavigationMixin 패턴]]
- [[Flow 에러 처리]] — Screen Flow의 Fault 경로·에러 처리 설계
