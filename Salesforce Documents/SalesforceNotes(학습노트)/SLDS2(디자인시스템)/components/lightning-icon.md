# Icon

`lightning-icon`  ·  카테고리: **Visual**

SLDS 아이콘을 표시.

## 기본 예제 (Example)

```html
<lightning-icon icon-name="utility:favorite" size="small" alternative-text="즐겨찾기"></lightning-icon>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-icon` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **GA** · 최소 API 버전: 0.0

### 속성 (Attributes) — 5개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `alternative-text` | string |  |  | The alternative text used to describe the icon. This text should describe what happens when you click the button, for example 'Upload File… |
| `icon-name` | string | ✔ |  | The Lightning Design System name of the icon. Names are written in the format 'utility:down' where 'utility' is the category, and 'down' i… |
| `size` | string |  | medium | The size of the icon. Options include xx-small, x-small, small, medium, or large. The default is medium. |
| `src` | string |  |  | A uri path to a custom svg sprite, including the name of the resouce, for example: /assets/icons/standard-sprite/svg/test.svg#icon-heart |
| `variant` | string |  |  | The variant changes the appearance of a utility icon. Accepted variants include inverse, success, warning, and error. Use the inverse vari… |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-icon/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-icon/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-icon/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-icon.html

---
[← 전체 목록으로 돌아가기](../components.html)
