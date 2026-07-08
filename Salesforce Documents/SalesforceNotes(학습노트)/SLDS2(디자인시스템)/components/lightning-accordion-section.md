# Accordion Section

`lightning-accordion-section`  ·  카테고리: **Container**

아코디언 안의 개별 섹션.

## 기본 예제 (Example)

```html
<lightning-accordion-section name="A" label="섹션 A">내용</lightning-accordion-section>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-accordion-section` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **GA** · 최소 API 버전: 41.0

### 속성 (Attributes) — 4개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `heading-level` | string \| number |  |  | Changes the 'aria-level' attribute value for the <h2> markup tag in the card's title element. Supported values are (1, 2, 3, 4, 5, 6). |
| `label` | string |  |  | The text that displays as the title of the section. |
| `name` | string |  |  | The unique section name to use with the active-section-name attribute in the accordion component. If you use the sectiontoggle event, prov… |
| `title` | string |  |  | Reserved for internal use. |

### 슬롯 (Slots) — 2개

| 슬롯 | 설명 |
|---|---|
| `actions` | Placeholder for actionable components, such as lightning-button or lightning-button-menu. Actions are displayed at the top right corner of… |
| `default` | Placeholder for your content in the accordion section. |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-accordion-section/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-accordion-section/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-accordion-section/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-accordion-section.html

---
[← 전체 목록으로 돌아가기](../components.html)
