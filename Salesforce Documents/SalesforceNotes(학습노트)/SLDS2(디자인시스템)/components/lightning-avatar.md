# Avatar

`lightning-avatar`  ·  카테고리: **Visual**

사용자/객체를 나타내는 원형/사각 이미지.

## 기본 예제 (Example)

```html
<lightning-avatar src="/avatar.jpg" fallback-icon-name="standard:user" alternative-text="홍길동"></lightning-avatar>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-avatar` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **GA** · 최소 API 버전: 0.0

### 속성 (Attributes) — 6개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `alternative-text` | string | ✔ |  | The alternative text used to describe the avatar, which is displayed as hover text on the image. |
| `fallback-icon-name` | string |  |  | The Lightning Design System name of the icon used as a fallback when the image fails to load. The initials fallback relies on this for its… |
| `initials` | string |  |  | If the record name contains two words, like first and last name, use the first capitalized letter of each. For records that only have a si… |
| `size` | string |  | medium | The size of the avatar. Valid values are x-small, small, medium, and large. This value defaults to medium. |
| `src` | string | ✔ |  | The URL for the image. |
| `variant` | string |  | square | The variant changes the shape of the avatar. Valid values are empty, circle, and square. This value defaults to square. |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-avatar/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-avatar/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-avatar/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-avatar.html

---
[← 전체 목록으로 돌아가기](../components.html)
