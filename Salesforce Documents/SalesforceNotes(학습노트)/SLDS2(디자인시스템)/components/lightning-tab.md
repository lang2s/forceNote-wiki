# Tab

`lightning-tab`  ·  카테고리: **Container**

탭 세트 안의 개별 탭.

## 기본 예제 (Example)

```html
<lightning-tab label="개요" value="overview">내용</lightning-tab>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-tab` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **GA** · 최소 API 버전: 44.0

### 속성 (Attributes) — 8개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `end-icon-alternative-text` | string |  |  | The alternative text for the icon specified by end-icon-name. |
| `end-icon-name` | string |  |  | The Lightning Design System name of an icon to display at the end of the tab label. Specify the name in the format 'utility:check' where '… |
| `icon-assistive-text` | string |  |  | The alternative text for the icon specified by icon-name. |
| `icon-name` | string |  |  | The Lightning Design System name of an icon to display at the beginning of the tab label. Specify the name in the format 'utility:down' wh… |
| `label` | string |  |  | The text displayed in the tab header. |
| `show-error-indicator` | boolean |  |  | Specifies whether there's an error in the tab content. An error icon is displayed to the right of the tab label. |
| `title` | string |  |  | Specifies text that displays in a tooltip over the tab content. |
| `value` | string |  |  | The optional string to identify which tab was clicked during the tab's active event. This string is also used by active-tab-value in tabse… |

### 메서드 (Methods) — 1개

| 메서드 | 설명 |
|---|---|
| `load-content` | Reserved for internal use. |

### 슬롯 (Slots) — 1개

| 슬롯 | 설명 |
|---|---|
| `default` | Placeholder for your content in lightning-tab. |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-tab/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-tab/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-tab/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-tab.html

---
[← 전체 목록으로 돌아가기](../components.html)
