---
tags: [lwc, base-component, container, slds, reference]
source: Salesforce Lightning Component Reference (cx-router 메타데이터, Tier 2) + lightningdesignsystem.com (SLDS 2)
created: 2026-06-13
aliases: [lightning-layout-item, Layout Item]
---

# lightning-layout-item

> Layout 안의 개별 칸(크기/패딩 지정). · 카테고리: Container

> [!note] 속성·메서드·이벤트·슬롯 명세는 Salesforce 공식 cx-router 메타데이터(Tier 2)에서 추출했습니다. 속성 설명은 가독성을 위해 약 140자에서 줄였습니다 — 전체 문장은 공식 Specification 링크 참조.

---

## 기본 예제 (Example)

```html
<lightning-layout-item size="6" padding="around-small">콘텐츠</lightning-layout-item>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-layout-item` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **GA** · 최소 API 버전: 0.0

### 속성 (Attributes) — 7개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `alignment-bump` | string |  |  | Specifies a direction to bump the alignment of adjacent layout items. Allowed values are left, top, right, bottom. |
| `flexibility` | object |  |  | Make the item fluid so that it absorbs any extra space in its container or shrinks when there is less space. Allowed values are: auto (col… |
| `large-device-size` | number |  |  | If the viewport is divided into 12 parts, this attribute indicates the relative space the container occupies on device-types larger than d… |
| `medium-device-size` | number |  |  | If the viewport is divided into 12 parts, this attribute indicates the relative space the container occupies on device-types larger than t… |
| `padding` | string |  |  | Sets padding to either the right and left sides of a container, or all sides of a container. Allowed values are horizontal-small, horizont… |
| `size` | number |  |  | If the viewport is divided into 12 parts, size indicates the relative space the container occupies. Size is expressed as an integer from 1… |
| `small-device-size` | number |  |  | If the viewport is divided into 12 parts, this attribute indicates the relative space the container occupies on device-types larger than m… |

### 슬롯 (Slots) — 1개

| 슬롯 | 설명 |
|---|---|
| `default` | Placeholder for your content in lightning-layout-item. |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-layout-item/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-layout-item/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-layout-item/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-layout-item.html

## 관련 노트

- [[BaseComponents(베이스컴포넌트)/index|BaseComponents 색인]]
- [[Lightning Base Components 레퍼런스]] — 전체 컴포넌트 카테고리 목록
- [[LWC MOC]]
