---
tags: [lwc, base-component, visual, slds, reference]
source: Salesforce Lightning Component Reference (cx-router 메타데이터, Tier 2) + lightningdesignsystem.com (SLDS 2)
created: 2026-06-13
aliases: [lightning-map, Map]
---

# lightning-map

> 지도에 마커를 표시. · 카테고리: Visual

> [!note] 속성·메서드·이벤트·슬롯 명세는 Salesforce 공식 cx-router 메타데이터(Tier 2)에서 추출했습니다. 속성 설명은 가독성을 위해 약 140자에서 줄였습니다 — 전체 문장은 공식 Specification 링크 참조.

---

## 기본 예제 (Example)

```html
<lightning-map map-markers={markers} zoom-level={5}></lightning-map>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-map` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **BETA** · 최소 API 버전: 44.0

### 속성 (Attributes) — 9개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `center` | object |  |  | A location to use as the map's center. If center is not specified, the map centers automatically. |
| `list-view` | string |  | auto | Displays or hides the list of locations. Valid values are visible, hidden, or auto. This value defaults to auto, which shows the list only… |
| `map-markers` | array | ✔ |  | One or more objects with the address or latitude and longitude to be displayed on the map. If latitude and longitude are provided, the add… |
| `markers-title` | string |  |  | Provides the heading title for the markers. Required if specifying multiple markers. The title is displayed below the map as a header for … |
| `options` | Object |  |  | Provides the list of map settings/options. The options contain different map settings with either true/false value. |
| `region` |  |  |  | Sets the region for the map. Defaults to user locale. Possible values can be found in the "Region Code" column in table at https://develop… |
| `selected-marker-value` | String |  |  | Provides the value of the currently selected marker. Returns undefined if you don't pass value to map-markers. |
| `show-footer` | Boolean |  | false | If present, the footer element is displayed below the map. The footer shows an 'Open in Google Maps' link that opens an external window to… |
| `zoom-level` | number |  |  | The zoom levels as defined by Google Maps API. If a zoom level is not specified, a default zoom level is applied to accommodate all marker… |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-map/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-map/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-map/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-map.html

## 관련 노트

- [[BaseComponents(베이스컴포넌트)/index|BaseComponents 색인]]
- [[Lightning Base Components 레퍼런스]] — 전체 컴포넌트 카테고리 목록
- [[LWC MOC]]
