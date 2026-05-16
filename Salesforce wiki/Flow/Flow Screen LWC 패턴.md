---
tags: [flow, lwc, screen, property-editor, pattern]
source: automation-components/quickChoice, quickChoicePropertyEditor
created: 2026-05-17
aliases: [Flow Screen, FlowAttributeChangeEvent, Property Editor, Flow LWC]
---

# Flow Screen LWC 패턴

> Flow Screen 컴포넌트와 Custom Property Editor 두 가지 패턴. 일반 LWC와 다른 진입점 사용.

---

## Flow Screen 컴포넌트

### 값 변경 통보 — FlowAttributeChangeEvent

```javascript
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';

handleChange(event) {
    const selectedValue = event.detail.value;

    // Flow 변수에 값 업데이트를 알림 (CustomEvent 아님)
    this.dispatchEvent(
        new FlowAttributeChangeEvent('value', selectedValue)
    );
}
```

> `FlowAttributeChangeEvent('속성명', 새값)` — `@api` 속성 이름과 일치해야 함.

---

### 화면 검증 — @api validate()

```javascript
@api
validate() {
    if (this.required && !this.value) {
        return {
            isValid: false,
            errorMessage: `'${this.label}'에서 선택하세요`
        };
    }
    return { isValid: true };
}
```

Flow가 Next 버튼 클릭 시 자동으로 호출. 반드시 `{ isValid, errorMessage }` 반환.

---

### 다중 HTML 템플릿 (displayMode별 렌더링)

```javascript
import templateCards from './quickChoiceCards.html';
import templatePicklist from './quickChoicePicklist.html';
import templateRadio from './quickChoiceRadio.html';

render() {
    switch (this.displayMode) {
        case 'cards': return templateCards;
        case 'picklist': return templatePicklist;
        case 'radio': return templateRadio;
        default: throw new Error(`Unsupported mode: ${this.displayMode}`);
    }
}
```

> 하나의 컴포넌트가 모드에 따라 완전히 다른 HTML 렌더링 가능.
> 파일명: `componentName.html`(기본), `componentNameCards.html` 등 추가.

---

### 폼 팩터 감지 (모바일 대응)

```javascript
import FORM_FACTOR from '@salesforce/client/formFactor';

get columnClass() {
    const isMobile = FORM_FACTOR === 'Small';
    return isMobile ? 'slds-size_1-of-1' : 'slds-size_1-of-2';
}
```

| FORM_FACTOR | 디바이스 |
|---|---|
| `'Small'` | 모바일 |
| `'Medium'` | 태블릿 |
| `'Large'` | 데스크탑 |

---

### 네비게이션 이벤트

```javascript
import {
    FlowNavigationNextEvent,
    FlowNavigationBackEvent,
    FlowNavigationFinishEvent
} from 'lightning/flowSupport';

handleNext() {
    this.dispatchEvent(new FlowNavigationNextEvent());
}

handleBack() {
    this.dispatchEvent(new FlowNavigationBackEvent());
}
```

---

### js-meta.xml — Flow Screen 노출 설정

```xml
<LightningComponentBundle>
    <apiVersion>60.0</apiVersion>
    <isExposed>true</isExposed>
    <targets>
        <target>lightning__FlowScreen</target>
    </targets>
    <targetConfigs>
        <targetConfig targets="lightning__FlowScreen">
            <configurationEditor>c-quick-choice-property-editor</configurationEditor>
        </targetConfig>
    </targetConfigs>
</LightningComponentBundle>
```

---

## Custom Property Editor

Flow Builder에서 컴포넌트 속성을 설정하는 **커스텀 UI**. 일반 LWC와 다른 전용 API 사용.

### 표준 구조

```javascript
import { LightningElement, api } from 'lwc';

export default class MyPropertyEditor extends LightningElement {
    @api builderContext;  // Flow Builder 컨텍스트 (변수 목록 등)

    _inputVariables = [];

    @api
    get inputVariables() {
        return this._inputVariables;
    }
    set inputVariables(variables) {
        this._inputVariables = variables || [];
    }

    // Flow Builder가 저장 전 유효성 검사 호출
    @api
    validate() {
        const validity = [];
        // 오류 있으면 push
        validity.push({
            key: '필드 레이블',           // 오류 식별자
            errorString: '오류 메시지'
        });
        return validity; // 빈 배열 = 유효
    }
}
```

---

### 변수 값 읽기/쓰기

```javascript
getInputVariableValue(varName) {
    const param = this._inputVariables.find(({ name }) => name === varName);
    return param?.value;
}

setInputVariableValue(varName, valueDataType, value) {
    // Proxy 문제 방지 — JSON 복사 후 수정
    const variables = JSON.parse(JSON.stringify(this._inputVariables));
    const index = variables.findIndex(({ name }) => name === varName);
    const updated = { name: varName, value, valueDataType };
    if (index === -1) {
        variables.push(updated);
    } else {
        variables[index] = updated;
    }
    this._inputVariables = variables;
}

// getter로 편리하게 접근
get displayMode() {
    return this.getInputVariableValue('displayMode');
}
```

---

### Flow Builder에 변경 전파 — configuration_editor_input_value_changed

```javascript
propagateChangeToConfigEditor(name, type, value) {
    this.dispatchEvent(
        new CustomEvent('configuration_editor_input_value_changed', {
            bubbles: true,
            cancelable: false,
            composed: true,
            detail: {
                name,
                newValue: value,
                newValueDataType: type  // 'String', 'Boolean', 'Number' 등
            }
        })
    );
}

handleChange(event) {
    const { name } = event.target;
    const { type } = event.target.dataset;  // data-type 속성으로 타입 지정
    const value = event.target.value;
    this.setInputVariableValue(name, type, value);
    this.propagateChangeToConfigEditor(name, type, value);
}
```

---

## Flow Screen vs 일반 LWC 차이

| 항목 | 일반 LWC | Flow Screen LWC |
|---|---|---|
| 값 변경 통보 | `CustomEvent` | `FlowAttributeChangeEvent` |
| 화면 이동 | `NavigationMixin` | `FlowNavigationNextEvent` |
| 검증 | 직접 구현 | `@api validate()` → `{ isValid, errorMessage }` |
| 설정 UI | 없음 | Custom Property Editor |
| 배포 대상 | 다양 | `lightning__FlowScreen` |

---

## 관련 노트

- [[@InvocableMethod 패턴]]
- [[멀티 패키지 구조]]
- [[@api 패턴]]
