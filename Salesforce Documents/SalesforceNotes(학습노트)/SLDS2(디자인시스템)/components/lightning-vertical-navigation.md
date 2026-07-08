# Vertical Navigation

`lightning-vertical-navigation`  ·  카테고리: **Navigation**

세로 사이드 내비게이션 메뉴.

## 기본 예제 (Example)

```html
<lightning-vertical-navigation>
  <lightning-vertical-navigation-item label="홈" name="home"></lightning-vertical-navigation-item>
</lightning-vertical-navigation>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-vertical-navigation` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **GA** · 최소 API 버전: 41.0

### 속성 (Attributes) — 3개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `compact` | boolean |  | false | If present, spacing between navigation items is reduced. |
| `selected-item` | string |  |  | Name of the navigation item to make active. An active item is highlighted in blue. |
| `shaded` | boolean |  | false | If present, the vertical navigation is displayed on top of a shaded background. |

### 슬롯 (Slots) — 1개

| 슬롯 | 설명 |
|---|---|
| `default` | Placeholder for lightning-vertical-navigation-section and lightning-vertical-navigation-overflow. |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-vertical-navigation/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-vertical-navigation/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-vertical-navigation/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-vertical-navigation.html

---
[← 전체 목록으로 돌아가기](../components.html)
