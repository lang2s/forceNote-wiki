---
tags: [lwc, base-component, tab, tabs, container, navigation, reference]
source: SLDS2-Docs/components/lightning-tab.md — 공식 SLDS 문서 (Tier 2)
created: 2026-06-14
aliases: [lightning-tab, tab, 탭, 개별 탭]
---

# lightning-tab

> 탭 세트(`lightning-tabset`) 안의 개별 탭. 헤더 레이블과 탭 콘텐츠를 담는다. 카테고리: **Container**.

> [!note] 속성 설명은 공식 cx-router 메타데이터에서 약 140자로 잘려 추출되었습니다(원문에 `…` 표시). 전체 문장은 아래 **Specification** 링크를 참고하세요.

---

## 기본 사용

```html
<!-- SLDS2-Docs 공식 예제 (Tier 2) -->
<lightning-tab label="개요" value="overview">내용</lightning-tab>
```

`lightning-tabset` 안에 여러 개를 배치한다:

```html
<!-- 구조 예시 — 실제 동작 코드 아님 -->
<lightning-tabset active-tab-value="overview">
  <lightning-tab label="개요" value="overview" icon-name="utility:info">
    <p>개요 내용</p>
  </lightning-tab>
  <lightning-tab label="세부" value="detail" show-error-indicator>
    <p>세부 내용</p>
  </lightning-tab>
</lightning-tabset>
```

---

## 속성 (Attributes) — 8개

지원 상태: **GA** · 최소 API 버전: 44.0

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `end-icon-alternative-text` | string |  |  | The alternative text for the icon specified by end-icon-name. |
| `end-icon-name` | string |  |  | The Lightning Design System name of an icon to display at the end of the tab label. Specify the name in the format 'utility:check' where '… |
| `icon-assistive-text` | string |  |  | The alternative text for the icon specified by icon-name. |
| `icon-name` | string |  |  | The Lightning Design System name of an icon to display at the beginning of the tab label. Specify the name in the format 'utility:down' wh… |
| `label` | string |  |  | The text displayed in the tab header. |
| `show-error-indicator` | boolean |  |  | Specifies whether there's an error in the tab content. An error icon is displayed to the right of the tab label. |
| `title` | string |  |  | Specifies text that displays in a tooltip over the tab content. |
| `value` | string |  |  | The optional string to identify which tab was clicked during the tab's active event. This string is also used by active-tab-value in tabse… |

## 메서드 (Methods) — 1개

| 메서드 | 설명 |
|---|---|
| `load-content` | Reserved for internal use. |

## 슬롯 (Slots) — 1개

| 슬롯 | 설명 |
|---|---|
| `default` | Placeholder for your content in lightning-tab. |

---

## 공식 문서 링크

- Example (실행 예제): https://developer.salesforce.com/docs/component-library/bundle/lightning-tab/example
- Develop (개발 가이드): https://developer.salesforce.com/docs/component-library/bundle/lightning-tab/documentation
- Specification (명세): https://developer.salesforce.com/docs/component-library/bundle/lightning-tab/specification

---

## 관련 노트

- [[lightning-tabset]] — 탭들을 감싸는 컨테이너 컴포넌트
- [[lightning-card]] — 탭 내부에 카드 배치 패턴
