# Tab Set

`lightning-tabset`  ·  카테고리: **Container**

여러 탭을 전환하는 탭 컨테이너.

## 기본 예제 (Example)

```html
<lightning-tabset variant="scoped">
  <lightning-tab label="탭1">내용1</lightning-tab>
  <lightning-tab label="탭2">내용2</lightning-tab>
</lightning-tabset>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-tabset` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **GA** · 최소 API 버전: 44.0

### 속성 (Attributes) — 6개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `active-tab-value` | string |  |  | Sets a specific tab to open by default using a string that matches a tab's value string. If not used, the first tab opens by default. |
| `heading-label` | string\|null |  |  | Specifies text to use as custom assistive text for the tabset heading. The text is placed in a div element with role="heading" and aria-le… |
| `heading-level` | number |  |  | Specifies the value to pass through to aria-level when you specify heading-label. Accepts values from 1 to 6. The default value is 2. |
| `heading-visible` | boolean |  |  | Determines whether the text that's passed with the heading-label attribute is visible above the tabset. This attribute isn't present by de… |
| `title` | string |  |  | Displays tooltip text when the mouse moves over the tabset. |
| `variant` | string |  |  | The variant changes the appearance of the tabset. Accepted variants are standard, scoped, and vertical. |

### 메서드 (Methods) — 1개

| 메서드 | 설명 |
|---|---|
| `focus` | Focus currently selected tab. |

### 슬롯 (Slots) — 1개

| 슬롯 | 설명 |
|---|---|
| `default` | Placeholder for lightning-tab. |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-tabset/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-tabset/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-tabset/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-tabset.html

---
[← 전체 목록으로 돌아가기](../components.html)
