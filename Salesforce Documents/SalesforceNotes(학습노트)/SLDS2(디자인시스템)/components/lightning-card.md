# Card

`lightning-card`  ·  카테고리: **Container**

제목/본문/푸터를 가진 카드 컨테이너.

## 기본 예제 (Example)

```html
<lightning-card title="연락처" icon-name="standard:contact">
  <p class="slds-p-horizontal_small">본문</p>
</lightning-card>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-card` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **GA** · 최소 API 버전: 0.0

### 속성 (Attributes) — 6개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `heading-level` | string \| number |  | 2 | The headingLevel changes the 'aria-level' attribute value of <h2> tag in the markup for the card's title element. It can take values of (1… |
| `hide-header` | boolean |  |  | Hides the header chunk of the card when set to `true`. Requires you to set the `label` attribute to supplement a non-rendered header. If `… |
| `icon-name` | string |  |  | The Lightning Design System name of the icon. Specify the name in the format 'utility:down' where 'utility' is the category, and 'down' is… |
| `label` | string |  |  | Assistive label for the card header. Only shown if `hideHeader` attribute is set to `true`. |
| `title` | string |  |  | The title can include text, and is displayed in the header. To include additional markup or another component, use the title slot. |
| `variant` | string |  | base | The variant changes the appearance of the card. Accepted variants include base or narrow. This value defaults to base. |

### 슬롯 (Slots) — 4개

| 슬롯 | 설명 |
|---|---|
| `actions` | Placeholder for actionable components, such as lightning-button or lightning-button-menu. Actions are displayed on the top corner of the c… |
| `default` | Placeholder for your content in the card body. |
| `footer` | Placeholder for the card footer, which is displayed at the bottom of the card and is usually optional. For example, the footer can display… |
| `title` | Placeholder for the card title, which can be represented by a header or h1 element. The title is displayed at the top of the card, after t… |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-card/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-card/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-card/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-card.html

---
[← 전체 목록으로 돌아가기](../components.html)
