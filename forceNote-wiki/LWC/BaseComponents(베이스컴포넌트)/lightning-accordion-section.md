---
tags: [lwc, base-component, accordion-section, accordion, container, reference]
source: SLDS2-Docs/components/lightning-accordion-section.md — 공식 SLDS 문서 (Tier 2)
created: 2026-06-14
aliases: [lightning-accordion-section, accordion-section, 아코디언 섹션, 개별 섹션]
---

# lightning-accordion-section

> 아코디언(`lightning-accordion`) 안의 개별 섹션. 펼치거나 접을 수 있는 콘텐츠 영역이며 우측 상단에 액션을 배치할 수 있다. 카테고리: **Container**.

> [!note] 속성 설명은 공식 cx-router 메타데이터에서 약 140자로 잘려 추출되었습니다(원문에 `…` 표시). 전체 문장은 아래 **Specification** 링크를 참고하세요.

---

## 기본 사용

```html
<!-- SLDS2-Docs 공식 예제 (Tier 2) -->
<lightning-accordion-section name="A" label="섹션 A">내용</lightning-accordion-section>
```

`lightning-accordion` 안에 여러 섹션을 배치하고, `actions` 슬롯에 버튼을 둘 수 있다:

```html
<!-- 구조 예시 — 실제 동작 코드 아님 -->
<lightning-accordion active-section-name="A">
  <lightning-accordion-section name="A" label="섹션 A">
    <div slot="actions">
      <lightning-button-menu alternative-text="액션"></lightning-button-menu>
    </div>
    <p>섹션 A 내용</p>
  </lightning-accordion-section>
  <lightning-accordion-section name="B" label="섹션 B">
    <p>섹션 B 내용</p>
  </lightning-accordion-section>
</lightning-accordion>
```

---

## 속성 (Attributes) — 4개

지원 상태: **GA** · 최소 API 버전: 41.0

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `heading-level` | string \| number |  |  | Changes the 'aria-level' attribute value for the &lt;h2&gt; markup tag in the card's title element. Supported values are (1, 2, 3, 4, 5, 6). |
| `label` | string |  |  | The text that displays as the title of the section. |
| `name` | string |  |  | The unique section name to use with the active-section-name attribute in the accordion component. If you use the sectiontoggle event, prov… |
| `title` | string |  |  | Reserved for internal use. |

## 슬롯 (Slots) — 2개

| 슬롯 | 설명 |
|---|---|
| `actions` | Placeholder for actionable components, such as lightning-button or lightning-button-menu. Actions are displayed at the top right corner of… |
| `default` | Placeholder for your content in the accordion section. |

---

## 공식 문서 링크

- Example (실행 예제): https://developer.salesforce.com/docs/component-library/bundle/lightning-accordion-section/example
- Develop (개발 가이드): https://developer.salesforce.com/docs/component-library/bundle/lightning-accordion-section/documentation
- Specification (명세): https://developer.salesforce.com/docs/component-library/bundle/lightning-accordion-section/specification

---

## 관련 노트

- [[lightning-accordion]] — 섹션들을 감싸는 아코디언 컨테이너
- [[lightning-button-menu]] — actions 슬롯에 배치하는 메뉴 버튼
