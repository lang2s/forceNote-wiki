# Empty State (Beta)

`lightning-empty-state`  ·  카테고리: **Visual**

데이터가 없을 때 보여주는 빈 상태 화면.

## 기본 예제 (Example)

```html
<lightning-empty-state title="항목 없음" text="새 레코드를 추가하세요"></lightning-empty-state>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-empty-state` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **BETA** · 최소 API 버전: 66.0

### 속성 (Attributes) — 5개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `alternative-text` | string |  |  | Assistive text that describes the illustration. Provide this text for assistive devices if the description and title aren't meaningful eno… |
| `heading-level` | string \| number |  |  | Sets the aria-level value for the <h3> element in the empty state's title element. Specify headingLevel if the implicit value 3 isn't corr… |
| `illustration-name` | string |  |  | The illustration identifier in "set:symbol" format. See the Develop tab for valid illustration names. |
| `size` | string |  |  | Overrides the automatic illustration sizing. Valid values are x-small, small, medium. The default value is null, which triggers the automa… |
| `title` | string |  |  | Text to display as the title in an <h3> element in the component. |

### 슬롯 (Slots) — 2개

| 슬롯 | 설명 |
|---|---|
| `cta` | Placeholder for the call-to-action button. To use more than one button, use the slot on a <div> container element. |
| `description` | Required. Placeholder for the empty state description that's displayed below the illustration and title, if they're present. Use the slot … |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-empty-state/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-empty-state/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-empty-state/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-empty-state.html

---
[← 전체 목록으로 돌아가기](../components.html)
