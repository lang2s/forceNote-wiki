# Progress Ring

`lightning-progress-ring`  ·  카테고리: **Progress**

원형 진행 표시.

## 기본 예제 (Example)

```html
<lightning-progress-ring value="75" variant="active-step"></lightning-progress-ring>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-progress-ring` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **GA** · 최소 API 버전: 48.0

### 속성 (Attributes) — 5개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `aria-label` | string |  |  | Descriptive label provided for assistive technologies. |
| `direction` | string |  | fill | Controls which way the color flows from the top of the ring, either clockwise or counterclockwise Valid values include fill and drain. The… |
| `size` | string |  | medium | The size of the progress ring. Valid values include medium and large. |
| `value` | number |  | 0 | The percentage value of the progress ring. The value must be a number from 0 to 100. A value of 50 corresponds to a color fill of half the… |
| `variant` | string |  | base | Changes the appearance of the progress ring. Accepted variants include base, active-step, warning, expired, base-autocomplete. |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-progress-ring/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-progress-ring/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-progress-ring/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-progress-ring.html

---
[← 전체 목록으로 돌아가기](../components.html)
