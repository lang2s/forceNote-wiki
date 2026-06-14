# Toast

`lightning-toast`  ·  카테고리: **Status & Notification**

화면 모서리에 잠깐 뜨는 알림(LWR 사이트용).

## 기본 예제 (Example)

```html
import Toast from 'lightning/toast';
Toast.show({ label:'저장됨', variant:'success' }, this);
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-toast` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **GA** · 최소 API 버전: 59.0

### 속성 (Attributes) — 6개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `label` | string | ✔ |  | Title of the toast. |
| `label-links` |  |  |  | An array of { url, label }, which replaces the {0}... {N} placeholders in label string or a map of { name: { url, label } }, which replace… |
| `message` | string |  |  | Message of the toast. |
| `message-links` |  |  |  | An array of { url, label }, which replaces the {0}... {N} placeholders in message string or a map of { name: { url, label } }, which repla… |
| `mode` | string |  | 'sticky' | The mode of the toast. This value is optional and is used to determine whether the toast can be closed by the user via a close button and … |
| `variant` | string |  | 'info' | The variant of the toast element. This value is optional and is used to determine the icon, background color, and text color of the toast … |

### 메서드 (Methods) — 1개

| 메서드 | 설명 |
|---|---|
| `focus` | Set focus on the element with content css class selector |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-toast/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-toast/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-toast/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-toast.html

---
[← 전체 목록으로 돌아가기](../components.html)
