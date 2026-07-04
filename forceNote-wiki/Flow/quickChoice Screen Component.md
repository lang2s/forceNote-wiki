---
tags: [flow, lwc, screen-component, picklist, render, property-editor, pattern]
source: automation-components/src-ui/quickChoice, quickChoicePropertyEditor, automation-components-main/src-ui/main/default/lwc/flowCombobox/flowCombobox.js, flowComboboxUtils/flowComboboxUtils.js
created: 2026-05-17
aliases: [quickChoice, Flow Screen 선택기, render() 멀티 템플릿, Custom Property Editor, Flow Screen LWC 다중 템플릿, flowCombobox, 머지필드 선택기, builderContext 파싱, CPE validate 배열]
---

# quickChoice Screen Component

> Flow Screen에서 카드·드롭다운·라디오 세 가지 UI로 선택지를 제공하는 LWC 패턴. `render()`로 템플릿을 동적 교체하고, Picklist 또는 직접 입력 목록 두 소스를 지원한다.

> [!note] 기반 패턴 참조
> `render()` 멀티 템플릿, `FlowAttributeChangeEvent`, `validate()`, `FORM_FACTOR`, Custom Property Editor의 **기본 패턴** → [[Flow Screen LWC 패턴]]
> `getPicklistValues` → [[getPicklistValues 패턴]]
> 이 노트는 세 패턴이 **통합된 실전 예시**다.

---

## 핵심 패턴 1 — render()로 템플릿 동적 교체

HTML 파일 3개를 각각 import 후 `displayMode`에 따라 반환.

```javascript
import templateCards    from './quickChoiceCards.html';
import templatePicklist from './quickChoicePicklist.html';
import templateRadio    from './quickChoiceRadio.html';

render() {
    switch (this.displayMode.toLowerCase()) {
        case 'cards':    return templateCards;
        case 'picklist': return templatePicklist;
        case 'radio':    return templateRadio;
        default: throw new Error(`Unsupported display mode: ${this.displayMode}`);
    }
}
```

> [!tip] render() vs lwc:if
> 조건부 렌더링(`lwc:if`)은 같은 템플릿 안에서 분기. `render()`는 완전히 다른 HTML 파일로 전환 — UI 구조가 크게 다를 때 사용.

---

## 핵심 패턴 2 — inputSource에 따라 옵션 소스 분기

`connectedCallback()`에서 `inputSource` 값으로 분기.

```javascript
connectedCallback() {
    switch (this.inputSource.toLowerCase()) {
        case 'list':
            // 직접 입력한 choiceValues/choiceLabels 배열로 options 구성
            this.options = this.choiceValues.map((value, index) => ({
                value,
                label: this.choiceLabels ? this.choiceLabels[index] : value,
                iconName: this.choiceIcons?.[index]
            }));
            break;

        case 'picklist':
            // getPicklistValues wire 어댑터 활성화를 위해 _recordTypeId 세팅
            this._recordTypeId = this.recordTypeId ?? '012000000000000AAA'; // Master Record Type
            break;
    }
}

// picklist 소스: wire로 자동 로드
@wire(getPicklistValues, {
    recordTypeId: '$_recordTypeId',
    fieldApiName: '$qualifiedPicklistFieldName'  // 형식: 'Account.Type'
})
loadPicklistValues({ error, data }) {
    if (data) {
        this.options = data.values.map((option, index) => ({
            value: option.value,
            label: option.label,
            iconName: this.choiceIcons?.[index]
        }));
        // required=false면 '-- None --' 옵션을 맨 앞에 추가
        if (!this.required) {
            this.options.unshift({ label: '-- None --', value: '' });
        }
    }
}
```

---

## 핵심 패턴 3 — FlowAttributeChangeEvent로 값 전달

```javascript
handleChange(event) {
    const selectedValue = this.isCards()
        ? event.target.value      // 카드: 직접 value 읽기
        : event.detail.value;     // 드롭다운/라디오: detail에서 읽기

    // Flow에 값 변경 알림
    this.dispatchEvent(
        new FlowAttributeChangeEvent('value', selectedValue)
    );
}
```

---

## 핵심 패턴 4 — validate() Flow Next 클릭 시 검증

```javascript
@api
validate() {
    if (this.required && !this.value) {
        return {
            isValid: false,
            errorMessage: `Make a selection in '${this.label}' to continue`
        };
    }
    return { isValid: true };
}
```

---

## 핵심 패턴 5 — 모바일 반응형 컬럼 처리

```javascript
import FORM_FACTOR from '@salesforce/client/formFactor';

get columnClass() {
    // 모바일에서는 무조건 1컬럼 강제
    const isDualColumns = FORM_FACTOR === 'Small' ? false : this.numberOfColumns === 2;
    return isDualColumns
        ? 'slds-col slds-size_1-of-2 slds-var-m-bottom_x-small'
        : 'slds-col slds-size_1-of-1 slds-var-m-bottom_x-small';
}
```

---

## @api 속성 전체 목록

| 속성 | 타입 | 용도 |
|---|---|---|
| `value` | String | 선택된 값 (Flow 출력) |
| `label` | String | 컴포넌트 레이블 |
| `displayMode` | String | `cards` / `picklist` / `radio` |
| `inputSource` | String | `list` / `picklist` |
| `choiceValues` | String[] | list 소스일 때 값 목록 |
| `choiceLabels` | String[] | list 소스일 때 레이블 목록 |
| `choiceIcons` | String[] | 아이콘 이름 목록 (SLDS) |
| `required` | Boolean | 필수 선택 여부 |
| `recordTypeId` | Id | picklist 소스일 때 Record Type |
| `qualifiedPicklistFieldName` | String | picklist 소스일 때 필드 API명 (`Account.Type`) |
| `numberOfColumns` | Integer | 카드 컬럼 수 (1 또는 2) |

---

## Custom Property Editor 패턴 (quickChoicePropertyEditor)

Flow Builder에서 컴포넌트 속성을 편집하는 전용 UI.

```javascript
// 입력: builderContext(Flow 변수 목록), inputVariables(현재 설정값)
@api builderContext;
@api inputVariables;

// 값 변경 시 Flow Builder에 알리는 이벤트
handleValueChange(event) {
    const valueChangedEvent = new CustomEvent(
        'configuration_editor_input_value_changed',
        {
            bubbles: true,
            cancelable: false,
            detail: {
                name: event.target.name,   // 속성명
                newValue: event.target.value,
                newValueDataType: 'String'
            }
        }
    );
    this.dispatchEvent(valueChangedEvent);
}

// js-meta.xml에서 연결
// <configurationEditor>c-quick-choice-property-editor</configurationEditor>
```

---

## 실전 심화 1 — CPE validate() 계약은 배열, Screen validate()는 객체

Screen 컴포넌트의 `validate()`(핵심 패턴 4)는 `{ isValid, errorMessage }` **단일 객체**를 반환한다. 하지만 **CPE의 `validate()`는 다르다** — Flow Builder가 "Done" 클릭 시 호출하며, **오류 항목의 배열** `[{ key, errorString }]`을 반환한다. 배열이 비면 유효(빈 `[]` = 통과), 항목이 있으면 각 `errorString`을 빌더 상단에 표시한다.

```javascript
// quickChoicePropertyEditor.js — CPE validate() 실제 코드
@api
validate() {
    const validity = [];
    // 모든 입력 컴포넌트의 유효성 검사 (c-flow-combobox 포함)
    const inputCmps = this.template.querySelectorAll(
        'lightning-input, lightning-radio-group, lightning-slider, c-flow-combobox'
    );
    inputCmps.forEach((inputCmp) => {
        inputCmp.reportValidity();
        if (!inputCmp.checkValidity()) {
            validity.push({
                key: inputCmp.label,
                errorString: `Value for '${inputCmp.label}' is invalid.`
            });
        }
    });
    // 정규화된 필드 API명 형식 검사 (예: Account.Type)
    const errorString = this.validateQualifiedPicklistFieldName();
    if (errorString) {
        validity.push({
            key: 'Qualified Picklist Field Name',
            errorString
        });
    }
    return validity;  // [] 이면 통과 · [{key, errorString}...] 이면 오류
}
```

> [!important] 두 validate()를 혼동하지 말 것
> - **Screen 컴포넌트 validate()** → `{ isValid: false, errorMessage: '...' }` (단일 객체, Flow *실행* 중 Next 클릭 시)
> - **CPE validate()** → `[{ key, errorString }]` (배열, Flow *디자인* 중 Done 클릭 시)
> 반환 형태가 다르므로 CPE에서 `{ isValid }`를 반환하면 빌더가 인식하지 못한다.

형식 검사 헬퍼(`validateQualifiedPicklistFieldName`)는 정규식 `/.\../`로 `Object.Field` 꼴을 강제하고, 실패 시 `input.setCustomValidity(error)`로 인라인 오류도 세팅한다.

```javascript
validateQualifiedPicklistFieldName() {
    let error = null;
    if (this.qualifiedPicklistFieldName !== '' &&
        !/.\../.test(this.qualifiedPicklistFieldName)) {
        error = `Value is not a qualified field API name.`;
        const input = this.template.querySelector('.qualifiedPicklistFieldName');
        input?.setCustomValidity(error);
    }
    return error;
}
```

---

## 실전 심화 2 — flowCombobox 재사용 컴포넌트로 Flow 변수를 머지필드로 선택

CPE에서 사용자가 값을 직접 입력하는 대신 **Flow 변수/공식/레코드 조회를 골라 `{!변수명}` 머지필드 참조로 넣게** 해주는 재사용 콤보박스가 `c/flowCombobox`다. quickChoice CPE는 이 컴포넌트를 통해 `qualifiedPicklistFieldName` 등을 Flow 리소스로 바인딩한다.

### builderContext → 머지필드 옵션 변환

`builderContext` setter가 들어오면 `generateMergeFieldsFromBuilderContext()`가 컨텍스트를 파싱해 타입별 옵션 그룹을 만든다. 파싱 대상은 `flowComboboxUtils`의 `TYPE_DESCRIPTORS`가 정의한다 — `variables`·`constants`(Global Constants)·`textTemplates`·`stages`·`recordLookups`·`formulas`.

```javascript
// flowCombobox.js
@api get builderContext() {
    return this._builderContext;
}
set builderContext(value) {
    this._builderContext = value;
    this._mergeFields = this.generateMergeFieldsFromBuilderContext(
        this._builderContext
    );
    if (!this._selectedObjectType) {
        this.setOptions(this._mergeFields);
        this.determineSelectedType();
    }
}
```

```javascript
// flowComboboxUtils.js — 파싱할 Flow 리소스 타입 목록 (발췌)
const TYPE_DESCRIPTORS = [
    { apiName: 'variables',    label: 'Variables',        dataType: 'dataType', objectTypeField: 'objectType' },
    { apiName: 'constants',    label: 'Global Constants', dataType: 'String' },
    { apiName: 'textTemplates',label: 'Variables',        dataType: 'String' },
    { apiName: 'stages',       label: 'Variables',        dataType: 'String' },
    { apiName: 'recordLookups',label: 'Variables',        dataType: 'SObject',
      objectTypeField: 'object', isCollectionField: 'getFirstRecordOnly' },
    { apiName: 'formulas',     label: 'Formulas',         dataType: 'String' }
];
```

### 머지필드 포맷 변환 ({!var} ↔ raw)

`{!...}` 래핑/해제는 정규식 유틸이 담당한다. 표시할 땐 `formatValue`로 `{!var}` 형태로 감싸고, 저장/비교할 땐 `removeFormatting`으로 벗긴다.

```javascript
// flowComboboxUtils.js
const REFERENCE_REFEX = /^\{!(.*)\}$/;

const isReference = (value) =>
    value ? REFERENCE_REFEX.test(value.trim()) : false;

const formatValue = (value, dataType) => {
    if (isReference(value)) return value;
    return dataType === 'reference' ? `{!${value}}` : value;
};

const removeFormatting = (value) => {
    if (value) {
        const match = REFERENCE_REFEX.exec(value.trim());
        return match ? match[1] : value.trim();
    }
    return value;
};
```

### 선택 결과를 CPE에 알림

flowCombobox는 선택이 확정되면 `valuechanged` CustomEvent를 던진다. CPE는 이를 받아 `inputVariables`에 반영한다.

```javascript
// flowCombobox.js — 값 확정 시
dispatchValueChangedEvent() {
    const valueChangedEvent = new CustomEvent('valuechanged', {
        detail: {
            id: this.name,
            newValue: this._value ? this._value : '',
            newValueDataType: this._dataType
        }
    });
    this.dispatchEvent(valueChangedEvent);
}

// quickChoicePropertyEditor.js — 수신 → inputVariables 갱신 + config editor 전파
handleFlowComboboxChange(event) {
    const { id, newValueDataType, newValue } = event.detail;
    this.setInputVariableValue(id, newValueDataType, newValue);
    this.propagateChangeToConfigEditor(id, newValueDataType, newValue);
}
```

> `builderContextFilterType` / `builderContextFilterCollectionBoolean` @api로 특정 데이터 타입·컬렉션 여부만 옵션에 남기도록 필터링할 수 있다(`processOptions`).

---

## 실전 심화 3 — getObjectInfo wire로 SObject 필드를 병합필드 트리로 펼치기

머지필드 옵션이 SObject 타입(예: `recordLookups`로 조회한 Account 레코드)이면, 사용자가 그 옵션을 열 때(`doOpenObject`) `_selectedObjectType`이 세팅되고, `getObjectInfo` wire가 해당 오브젝트의 **전체 필드를 자식 옵션으로 펼친다.** 이렇게 `{!myAccount.Name}`처럼 필드 경로를 계층 선택할 수 있다.

```javascript
// flowCombobox.js
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

@wire(getObjectInfo, { objectApiName: '$_selectedObjectType' })
_getObjectInfo({ error, data }) {
    if (error) {
        // ShowToastEvent로 오류 표시 후 옵션 비움
        this.setOptions([]);
    } else if (data) {
        const options = Object.keys(data.fields).map((curField) => {
            const field = data.fields[curField];
            // Reference 타입은 SObject로 취급 → 추가 드릴다운 가능
            const type = field.dataType === 'Reference' ? 'SObject' : field.dataType;
            const objectType = field.referenceToInfos.length
                ? field.referenceToInfos[0].apiName
                : null;
            return {
                type,
                label: field.label,
                value: field.apiName,
                isCollection: false,
                objectType,
                optionIcon: TYPE_ICONS[type],
                isObject: type === 'SObject',
                displayType: type === 'SObject' ? objectType : type,
                key: DEFAULTS.KEY_PREFIX + this.key++,
                flowType: DEFAULTS.TYPE_REFERENCE
            };
        });
        this.setOptions([{ type: `${data.label} Fields`, options }]);
    }
}
```

핵심 포인트:
- `field.dataType === 'Reference'` → 타입을 `'SObject'`로 승격해 **재귀 드릴다운**(lookup 필드를 다시 펼침)을 허용한다.
- `field.referenceToInfos[0].apiName`으로 참조 대상 오브젝트를 얻어 다음 `getObjectInfo` wire의 입력으로 쓴다.
- `TYPE_ICONS`(flowComboboxUtils)가 각 dataType을 SLDS 아이콘으로 매핑(예: `Picklist → utility:picklist`, `reference → utility:merge_field`).
- 옵션 그룹 헤더는 `${data.label} Fields`(예: "Account Fields")로 표시.

---

## 비교표 — Screen Component 선택

| 상황 | 패턴 |
|---|---|
| 2~5개 선택지, 카드 UI | quickChoice (displayMode=cards) |
| 긴 목록, 드롭다운 | quickChoice (displayMode=picklist) |
| 라디오 버튼 | quickChoice (displayMode=radio) |
| Picklist 필드 값 그대로 표시 | quickChoice (inputSource=picklist) |
| Flow Builder에서 속성 커스텀 편집 | Custom Property Editor 패턴 |

---

## 관련 노트

- [[Flow Screen LWC 패턴]] — FlowAttributeChangeEvent, validate() 기본 패턴
- [[getPicklistValues 패턴]] — getPicklistValues wire 어댑터
- [[모바일 기능 패턴]] — FORM_FACTOR 활용
