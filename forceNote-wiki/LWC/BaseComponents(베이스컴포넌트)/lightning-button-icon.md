---
tags: [lwc, base-components, button, button-icon, action-menu, reference]
source: SLDS2-Docs/components/lightning-button-icon.md (Tier 2)
created: 2026-06-14
aliases: [lightning-button-icon, button-icon, 아이콘 버튼, 아이콘 전용 버튼]
---

# lightning-button-icon

> 아이콘만 있는 버튼 (텍스트 레이블 없음). 카테고리: **Action & Menu**.

---

## 기본 예제

```html
<!-- 구조 예시 — SLDS2-Docs 소스 기본 예제 -->
<lightning-button-icon
    icon-name="utility:settings"
    alternative-text="설정"
></lightning-button-icon>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 공식 **Example** 탭에서 직접 확인/편집할 수 있습니다.

`lightning-button-icon`은 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다. 아이콘만 표시되므로 스크린리더 사용자를 위해 `alternative-text`(필수)를 반드시 제공해야 합니다.

---

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다.

> [!note] 속성 설명은 소스(SLDS2-Docs)에서 **약 140자에서 잘려** 있습니다(`…`로 표기). 전체 문장은 아래 Specification 링크를 참고하세요.

지원 상태: **GA** · 최소 API 버전: 0.0

### 속성 (Attributes) — 12개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `alternative-text` | string |  |  | The alternative text used to describe the icon. This text should describe what happens when you click the button, for example 'Upload File… |
| `disable-alternative-text-title` | boolean |  | false | Reserved for internal use only. Disables the alternative text being used for the button title when the title has not been provided. |
| `icon-class` | string |  |  | The class to be applied to the contained icon element. Only Lightning Design System utility classes are currently supported. |
| `icon-name` | string | ✔ |  | The Lightning Design System name of the icon. Names are written in the format 'utility:down' where 'utility' is the category, and 'down' i… |
| `name` | string |  |  | The name for the button element. This value is optional and can be used to identify the button in a callback. |
| `size` | string |  | medium | The size of the button-icon. For the bare variant, options include x-small, small, medium, and large. For non-bare variants, options inclu… |
| `tab-index` | number |  |  | Reserved for internal use only. Use the global tabindex attribute instead. Set tab index to -1 to prevent focus on the button during tab n… |
| `tooltip` | string |  |  | Text to display when the user mouses over or focuses on the button. The tooltip is auto-positioned relative to the button and screen space. |
| `tooltip-type` | string |  | info | Reserved for internal use only. Specifies the type of tooltip to be used. Use info in cases where target already has click handlers. Use t… |
| `type` | string |  | button | Specifies the type of button. Valid values are button, reset, and submit. This value defaults to button. |
| `value` | string |  |  | The value for the button element. This value is optional and can be used when submitting a form. |
| `variant` | string |  | border | The variant changes the appearance of button-icon. Accepted variants include bare, container, brand, border, border-filled, bare-inverse, … |

#### variant 설명표

위 명세의 `variant` 설명은 소스에서 `…`로 잘려 있어, 각 값의 의미를 한글로 정리한다(기본값: `border`).

| variant | 설명 |
|---|---|
| `bare` | 테두리 없음, 배경 없음 |
| `container` | 정사각형 배경 |
| `brand` | 파란 채운 원 |
| `border` | 테두리 있는 정사각형 |
| `border-filled` | 테두리 + 채운 배경 |
| `border-inverse` | 흰색 아이콘, 어두운 배경 |
| `inverse` | 흰색 아이콘 |

### 메서드 (Methods) — 2개

| 메서드 | 설명 |
|---|---|
| `click` | Simulates a mouse click on the button. |
| `focus` | Sets focus on the button. |

---

## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-button-icon/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-button-icon/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-button-icon/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-button-icon.html

---

## 관련 노트

- [[lightning-button]] — 표준 텍스트 버튼 (아이콘 버튼 패밀리의 기본형)
- [[lightning-button-icon-stateful]] — 상태 토글되는 아이콘 버튼 (선택/해제)
- [[lightning-button-group]] — 여러 버튼을 한 그룹으로 묶는 컨테이너
- [[lightning-icon]] — 버튼 없이 아이콘만 표시
