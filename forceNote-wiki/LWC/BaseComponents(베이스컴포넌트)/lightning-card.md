---
tags: [lwc, base-component, card, layout, reference]
source: TrailheadApp/lwc-recipes-main (Tier 1) + external-knowledge (Tier 3)
created: 2026-05-17
aliases: [lightning-card, 카드, 카드 컨테이너, 레이아웃 카드]
---

# lightning-card

> 콘텐츠를 감싸는 카드 컨테이너. 헤더(아이콘+제목), 바디, 액션 버튼, 푸터 4개 영역으로 구성된다.

> [!warning] 속성 세부사항 일부는 외부 지식(Tier 3). 코드 예시는 `lwc-recipes-main` (Tier 1).

---

## 기본 구조 *(lwc-recipes-main 전반 — Tier 1)*

```html
<lightning-card title="Account Detail" icon-name="standard:account">
    <p class="slds-p-horizontal_small">카드 바디 내용</p>
</lightning-card>
```

---

## 헤더 액션 슬롯

```html
<lightning-card title="Contact List" icon-name="standard:contact">
    <!-- 헤더 오른쪽에 버튼 배치 -->
    <div slot="actions">
        <lightning-button label="New" onclick={handleNew}></lightning-button>
        <lightning-button-icon
            icon-name="utility:refresh"
            alternative-text="Refresh"
            onclick={handleRefresh}
        ></lightning-button-icon>
    </div>

    <!-- 기본 슬롯 = 바디 -->
    <div class="slds-var-m-around_medium">
        <p>콘텐츠가 여기에 들어갑니다.</p>
    </div>
</lightning-card>
```

---

## 푸터 슬롯

```html
<lightning-card title="Contact" icon-name="standard:contact">
    <div class="slds-var-m-around_medium">
        <p>레코드 상세 정보</p>
    </div>

    <div slot="footer">
        <lightning-button label="전체 보기" variant="base" onclick={handleViewAll}></lightning-button>
    </div>
</lightning-card>
```

---

## 아이콘 없는 카드 + 제목 없는 카드

```html
<!-- 아이콘 없이 제목만 -->
<lightning-card title="요약">
    <p class="slds-p-horizontal_small">내용</p>
</lightning-card>

<!-- 제목·아이콘 없이 바디만 (내용을 독립 블록으로 감쌀 때) -->
<lightning-card>
    <div class="slds-var-m-around_medium">콘텐츠</div>
</lightning-card>
```

---

## 중첩 카드 (Narrow variant)

카드 안에 카드를 넣을 때 `variant="narrow"` 사용 시 패딩이 축소된다.

```html
<lightning-card title="Parent Card">
    <div class="slds-var-m-around_medium">
        <lightning-card variant="narrow" title="Child Card">
            <p class="slds-p-horizontal_small">중첩 내용</p>
        </lightning-card>
    </div>
</lightning-card>
```

---

## lwc-recipes-main 실제 사용 패턴 *(Tier 1)*

```html
<!-- 대부분의 레시피 컴포넌트 패턴 -->
<lightning-card title="DatatableInlineEditWithApex" icon-name="custom:custom62">
    <div class="slds-var-m-around_medium">
        <!-- 주요 콘텐츠 -->
        <template lwc:if={contacts.data}>
            <lightning-datatable ...></lightning-datatable>
        </template>
        <template lwc:elseif={contacts.error}>
            <c-error-panel errors={contacts.error}></c-error-panel>
        </template>
    </div>
    <!-- 소스 보기 링크를 푸터에 -->
    <c-view-source source="lwc/..." slot="footer">
        설명 텍스트
    </c-view-source>
</lightning-card>
```

---

## 속성

| 속성 | 타입 | 기본값 | 설명 |
|---|---|---|---|
| `title` | string | — | 카드 헤더 제목 |
| `icon-name` | string | — | 제목 왼쪽 아이콘 (`utility:*`, `standard:*` 등) |
| `variant` | string | `base` | `base` / `narrow` |
| `href` | string | — | 제목을 클릭 가능한 링크로 만드는 URL |

---

## 슬롯 (Slots)

| 슬롯 이름 | 위치 | 용도 |
|---|---|---|
| (기본 슬롯) | 카드 바디 | 주요 콘텐츠 |
| `actions` | 헤더 오른쪽 | 버튼, 아이콘 버튼 |
| `footer` | 카드 하단 | 부가 링크, 안내 텍스트 |

---

## SLDS 여백 클래스 활용

카드 바디 내부에 SLDS 여백 클래스를 사용해 적절한 공백을 준다.

```html
<!-- 기본 여백 -->
<lightning-card title="Basic">
    <div class="slds-var-m-around_medium">콘텐츠</div>
</lightning-card>

<!-- 좌우 여백만 -->
<lightning-card title="Horizontal">
    <div class="slds-p-horizontal_small">콘텐츠</div>
</lightning-card>

<!-- 여백 없이 전체 너비 (테이블 등) -->
<lightning-card title="Full Width">
    <lightning-datatable ...></lightning-datatable>
</lightning-card>
```

---

## 관련 노트

- [[Lightning Base Components 레퍼런스]] — 전체 컴포넌트 목록
- [[lightning-accordion]] — 접고 펼치는 레이아웃
- [[lightning-tabset]] — 탭 레이아웃
