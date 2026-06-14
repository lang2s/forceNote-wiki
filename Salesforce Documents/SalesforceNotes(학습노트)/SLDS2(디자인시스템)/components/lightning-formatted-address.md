# Formatted Address

`lightning-formatted-address`  ·  카테고리: **Output**

주소를 형식에 맞게 표시(지도 링크 옵션).

## 기본 예제 (Example)

```html
<lightning-formatted-address street="123" city="서울" country="KR" show-static-map></lightning-formatted-address>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-formatted-address` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **GA** · 최소 API 버전: 42.0

### 속성 (Attributes) — 11개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `city` | string |  |  | The city detail for the address. |
| `country` | string |  |  | The country detail for the address. |
| `disabled` | boolean |  | false | If present, the address is displayed as plain text and cannot be clicked or focused on. |
| `latitude` | string |  |  | The latitude of the location if known. Latitude values must be within -90 and 90. |
| `locale` | string |  |  | The locale of the address. The default value is 'en-US'. |
| `longitude` | string |  |  | The longitude of the location if known. Longitude values must be within -180 and 180. |
| `postal-code` | string |  |  | The postal code detail for the address. |
| `province` | string |  |  | The province detail for the address. |
| `show-static-map` |  |  | false | Displays a static map of the location using Google Maps. This value defaults to false. |
| `street` | string |  |  | The street detail for the address. |
| `variant` | string |  | truncate | Whether the slds-truncate class is assigned to each address line. Accepted variants are truncate and plain. The default variant is truncate. |

### 메서드 (Methods) — 1개

| 메서드 | 설명 |
|---|---|
| `click` | Simulates a mouse click on the address and navigates to Google Maps on a new tab. |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-formatted-address/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-formatted-address/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-formatted-address/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-formatted-address.html

---
[← 전체 목록으로 돌아가기](../components.html)
