# Button

`lightning-button`  ·  카테고리: **Action & Menu**

클릭하면 동작을 실행하는 기본 버튼.

## 기본 예제 (Example)

```html
<lightning-button variant="brand" label="저장" title="저장" onclick={handleSave}></lightning-button>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-button` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **GA** · 최소 API 버전: 0.0

### 속성 (Attributes) — 10개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `disable-animation` |  |  |  | Reserved for internal use. If present, disables button animation. |
| `icon-name` | string |  |  | The Lightning Design System name of the icon. Names are written in the format 'utility:down' where 'utility' is the category, and 'down' i… |
| `icon-position` | string |  | left | Describes the position of the icon with respect to the button label. Options include left and right. This value defaults to left. |
| `label` | string |  |  | The text to be displayed inside the button. |
| `name` | string |  |  | The name for the button element. This value is optional and can be used to identify the button in a callback. |
| `stretch` | boolean |  | false | Setting it to true allows the button to take up the entire available width. This value defaults to false. |
| `tab-index` | number |  |  | Reserved for internal use only. Use the global tabindex attribute instead. Set tab index to -1 to prevent focus on the button during tab n… |
| `type` | string |  | button | Specifies the type of button. Valid values are button, reset, and submit. This value defaults to button. |
| `value` | string |  |  | The value for the button element. This value is optional and can be used when submitting a form. |
| `variant` | string |  | neutral | The variant changes the appearance of the button. Accepted variants include base, neutral, brand, brand-outline, destructive, destructive-… |

### 메서드 (Methods) — 2개

| 메서드 | 설명 |
|---|---|
| `click` | Simulates a mouse click on the button. |
| `focus` | Sets focus on the button. |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-button/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-button/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-button/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-button.html

---
[← 전체 목록으로 돌아가기](../components.html)
