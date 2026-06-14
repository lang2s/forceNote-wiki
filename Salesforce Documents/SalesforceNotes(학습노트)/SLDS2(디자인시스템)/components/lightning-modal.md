# Modal

`lightning-modal`  ·  카테고리: **Container**

화면 위에 띄우는 모달 대화상자(LWC 클래스 확장).

## 기본 예제 (Example)

```html
import LightningModal from 'lightning/modal';
export default class MyModal extends LightningModal {}
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-modal` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **GA** · 최소 API 버전: 55.0

### 속성 (Attributes) — 4개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `description` | string |  | false | Sets the modal's accessible description. |
| `disable-close` | boolean |  | false | Prevents closing the modal by normal means like the ESC key, the close button, or `.close()`. |
| `label` | string | ✔ | false | Sets the modal's title and assistive device label. |
| `size` | string |  | medium | How much of the viewport width the modal uses. Supported values are small, medium, large, or full. You can't change the modal size after t… |

### 메서드 (Methods) — 1개

| 메서드 | 설명 |
|---|---|
| `close` | Closes the modal and resolves with an optional result. |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-modal/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-modal/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-modal/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-modal.html

---
[← 전체 목록으로 돌아가기](../components.html)
