---
tags: [lwc, base-component, spinner, loading, reference]
source: TrailheadApp/lwc-recipes-main (Tier 1) + external-knowledge (Tier 3)
created: 2026-05-17
aliases: [lightning-spinner, 로딩 스피너, 로딩 인디케이터, isLoading]
---

# lightning-spinner

> 비동기 작업이 진행 중임을 나타내는 로딩 스피너. `lwc:if`로 조건부 렌더링하는 것이 기본 패턴.

> [!warning] 속성 세부사항 일부는 외부 지식(Tier 3). 코드 예시는 `lwc-recipes-main` (Tier 1).

---

## 기본 사용 패턴 *(lwc-recipes-main/graphqlMutationDelete — Tier 1)*

```html
<template>
    <!-- isLoading이 true일 때만 스피너 표시 -->
    <lightning-spinner
        lwc:if={isLoading}
        alternative-text="Loading"
        size="small"
        variant="brand"
    ></lightning-spinner>

    <!-- 주요 콘텐츠 -->
    <template lwc:if={contacts}>
        <template for:each={contacts} for:item="contact">
            <lightning-layout key={contact.Id}>
                <lightning-layout-item flexibility="grow">
                    {contact.Name}
                </lightning-layout-item>
                <lightning-layout-item>
                    <lightning-button-icon
                        icon-name="utility:delete"
                        alternative-text="Delete"
                        onclick={handleDeleteContact}
                        data-id={contact.Id}
                    ></lightning-button-icon>
                </lightning-layout-item>
            </lightning-layout>
        </template>
    </template>
</template>
```

---

## 버튼 옆 인라인 스피너 *(lwc-recipes-main/graphqlMutationCreate — Tier 1)*

```html
<template>
    <lightning-input
        label="Account Name"
        value={accountName}
        onchange={handleNameChange}
        class="slds-var-m-bottom_small"
    ></lightning-input>
    <lightning-button
        label="Create Account"
        variant="brand"
        onclick={handleCreateAccount}
        disabled={isLoading}
    ></lightning-button>
    <!-- 버튼 바로 옆에 작은 스피너 -->
    <lightning-spinner
        lwc:if={isLoading}
        alternative-text="Creating..."
        size="small"
        class="slds-var-m-left_medium"
    ></lightning-spinner>
</template>
```

```javascript
import { LightningElement } from 'lwc';

export default class CreateAccount extends LightningElement {
    accountName = '';
    isLoading = false;

    handleNameChange(event) {
        this.accountName = event.target.value;
    }

    async handleCreateAccount() {
        this.isLoading = true;
        try {
            // 비동기 작업
            await createRecord({ ... });
        } finally {
            this.isLoading = false; // 성공·실패 모두 스피너 제거
        }
    }
}
```

---

## 전체 화면 오버레이 스피너

컴포넌트 전체를 덮는 로딩 오버레이 패턴.

```html
<template>
    <!-- 상대 위치 컨테이너 필요 -->
    <div class="slds-is-relative">
        <lightning-spinner
            lwc:if={isLoading}
            alternative-text="Loading"
            size="medium"
        ></lightning-spinner>

        <!-- 로딩 중에도 렌더링되는 콘텐츠 -->
        <lightning-datatable
            key-field="Id"
            data={tableData}
            columns={columns}
        ></lightning-datatable>
    </div>
</template>
```

> [!note] `lightning-spinner`는 절대 위치(`position: absolute`)로 렌더링되므로, 부모 컨테이너에 `slds-is-relative` 클래스를 적용해 오버레이 범위를 제한한다.

---

## try/catch/finally 패턴 (표준 isLoading 처리)

```javascript
import { LightningElement } from 'lwc';
import saveData from '@salesforce/apex/Controller.saveData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class LoadingPattern extends LightningElement {
    isLoading = false;

    async handleSave() {
        this.isLoading = true; // 스피너 ON
        try {
            await saveData({ ... });
            this.dispatchEvent(new ShowToastEvent({
                title: '완료', message: '저장되었습니다.', variant: 'success'
            }));
        } catch (error) {
            this.dispatchEvent(new ShowToastEvent({
                title: '오류', message: error.body.message, variant: 'error'
            }));
        } finally {
            this.isLoading = false; // 스피너 OFF (항상 실행)
        }
    }
}
```

---

## 속성

| 속성 | 타입 | 기본값 | 설명 |
|---|---|---|---|
| `alternative-text` | string | — | 접근성 대체 텍스트 (필수) |
| `size` | string | `medium` | `xx-small` / `x-small` / `small` / `medium` / `large` |
| `variant` | string | — | `base` / `brand` / `inverse` |

### size별 시각적 크기

| size | 용도 |
|---|---|
| `xx-small` | 아이콘 버튼 내부 |
| `x-small` | 소형 UI 요소 |
| `small` | 버튼 옆, 인라인 |
| `medium` | 컴포넌트 영역 (기본) |
| `large` | 전체 페이지 |

### variant별 색상

| variant | 색상 | 사용 환경 |
|---|---|---|
| (없음 / `base`) | 회색 | 기본 배경 |
| `brand` | 파란색 | 밝은 배경 강조 |
| `inverse` | 흰색 | 어두운 배경 |

---

## 접근성 (Accessibility)

- `alternative-text`는 반드시 제공 — 스크린리더가 "로딩 중"을 알릴 수 있도록
- 스피너가 표시될 때 주요 콘텐츠도 `aria-busy="true"` 추가 권장

---

## 사용 고려사항

- `lwc:if`로 조건부 렌더링하는 것이 `hidden` 속성 사용보다 DOM 효율적
- 버튼 클릭 시 버튼도 `disabled={isLoading}`으로 중복 클릭 방지
- `try/finally` 패턴으로 에러 발생 시에도 반드시 `isLoading = false` 처리
- 전체 화면 오버레이 시 부모에 `slds-is-relative` 필수

---

## 관련 노트

- [[Lightning Base Components 레퍼런스]] — 전체 컴포넌트 목록
- [[Imperative 호출 패턴]] — async/await + isLoading 전체 패턴
- [[Toast & 모달 패턴]] — 저장 결과 토스트 알림
