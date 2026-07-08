# Carousel

`lightning-carousel`  ·  카테고리: **Container**

이미지를 슬라이드로 넘겨 보는 캐러셀.

## 기본 예제 (Example)

```html
<lightning-carousel>
  <lightning-carousel-image src="/a.jpg" header="제목"></lightning-carousel-image>
</lightning-carousel>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-carousel` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **BETA** · 최소 API 버전: 42.0

### 속성 (Attributes) — 3개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `disable-auto-refresh` | boolean |  | false | If present, the carousel doesn't loop after the last image is displayed. |
| `disable-auto-scroll` | boolean |  | false | If present, images do not automatically scroll and users must click the indicators to scroll. |
| `scroll-duration` | number |  | 5 | The auto scroll duration. The default is 5 seconds, after that the next image is displayed. |

### 슬롯 (Slots) — 1개

| 슬롯 | 설명 |
|---|---|
| `default` | Placeholder for carousel-image. Up to 5 carousel-image components are allowed. |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-carousel/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-carousel/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-carousel/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-carousel.html

---
[← 전체 목록으로 돌아가기](../components.html)
