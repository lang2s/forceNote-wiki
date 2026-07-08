# Input Rich Text

`lightning-input-rich-text`  ·  카테고리: **Input**

서식 있는 텍스트(리치 텍스트) 편집기.

## 기본 예제 (Example)

```html
<lightning-input-rich-text value={richText} onchange={handleChange}></lightning-input-rich-text>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-input-rich-text` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **GA** · 최소 API 버전: 0.0

### 속성 (Attributes) — 15개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `aria-described-by` | string |  |  | Reserved for internal use. Use the standard aria-describedby instead. |
| `custom-buttons` | object |  |  | Reserved for internal use. Custom buttons to add to the toolbar. |
| `disabled` | boolean |  | false | If present, the editor is disabled and users cannot interact with it. |
| `disabled-categories` | list |  |  | A comma-separated list of button categories to remove from the toolbar. |
| `field-level-help` | string |  |  | Help text detailing the purpose and function of the rich text editor. The text is displayed in a tooltip above the rich text editor when y… |
| `formats` | list |  |  | A list of allowed formats. By default, the list is computed based on enabled categories. The 'table' format is always enabled to support c… |
| `label` | string |  |  | The label of the rich text editor. |
| `label-visible` | boolean |  | false | If present, the label on the rich text editor is visible. |
| `message-when-bad-input` | string |  |  | Error message to be displayed when invalid input is detected. |
| `placeholder` | string |  |  | Text that is displayed when the field is empty, to prompt the user for a valid entry. |
| `required` | boolean |  |  | Specifies whether users must enter content in the editor. If present, an asterisk is displayed before the label when label-visible is pres… |
| `share-with-entity-id` | string |  |  | Entity ID to share the image with. |
| `valid` | boolean |  | true | Specifies whether the editor content is valid. This value defaults to true. |
| `value` | string |  |  | The HTML content in the rich text editor. |
| `variant` | string |  |  | The variant changes the appearance of the toolbar. Accepted variant is bottom-toolbar which causes the toolbar to be displayed below the t… |

### 메서드 (Methods) — 6개

| 메서드 | 설명 |
|---|---|
| `blur` | Removes focus from the rich text editor. |
| `focus` | Sets focus on the rich text editor. |
| `get-format` | Returns an object representing the formats applied to the current selection. Formats supported are align, background, bold, code, code-blo… |
| `insert-text-at-cursor` | Reserved for internal use. Insert text in the rich text editor at cursor position. |
| `set-format` | Sets a format in the editor from the cursor point onwards. The format also applies to currently selected content. Valid formats are font, … |
| `set-range-text` | Replaces a range of text in the rich text editor with a new string |

### 슬롯 (Slots) — 1개

| 슬롯 | 설명 |
|---|---|
| `toolbar` | Placeholder for lightning-rich-text-toolbar-button-group |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-input-rich-text/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-input-rich-text/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-input-rich-text/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-input-rich-text.html

---
[← 전체 목록으로 돌아가기](../components.html)
