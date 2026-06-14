# Alert

블루프린트(CSS 전용) · 카테고리: **Component Blueprints**

시스템 전체에 영향을 주는 상태를 알리는 경고 배너(페이지가 아닌 전역).

> ⚠️ 블루프린트는 **스타일 전용 HTML/CSS 스캐폴딩**입니다. JavaScript·로직·상호작용이 없어 동작·접근성(ARIA/키보드)은 직접 구현해야 합니다. 가능하면 Lightning Base Component를 먼저 검토하세요.

## 주요 SLDS 클래스

`.slds-notify_alert`

```css
.slds-notify_alert {
  position:relative;
 
  display:-webkit-inline-box;
 
  display:-ms-inline-flexbox;
 
  display:inline-flex;
 
  -webkit-box-align:center;
 
      -ms-flex-align:center;
 
          align-items:center;
 
  -webkit-box-pack:center;
 
      -ms-flex-pack:center;
 
          justify-content:center;
 
  width:100%;
 
  padding-top:var(--slds-c-alert-spacing-block-start, var(--slds-c-alert-spacing-blockstart, var(--sds-c-alert-spacing-block-start, 0.5rem)));
 
  padding-right:var(--slds-c-alert-spacing-inline-end, var(--slds-c-alert-spacing-inlineend, var(--sds-c-alert-spacing-inline-end, 2rem)));
 
  padding-bottom:var(--slds-c-alert-spacing-block-end, var(--slds-c-alert-spacing-blockend, var(--sds-c-alert-spacing-block-end, 0.5rem)));
 
  padding-left:var(--slds-c-alert-spacing-inline-start, var(--slds-c-alert-spacing-inlinestart, var(--sds-c-alert-spacing-inline-start, 0.5rem)));
 
  color:var(--slds-c-alert-text-color, var(--sds-c-alert-text-color, var(--slds-g-color-neutral-base-100, rgb(255, 255, 255))));
 
  font-weight:var(--slds-c-alert-font-weight, var(--sds-c-alert-font-weight));
 
  text-align:center;
 
  background-color:var(--slds-c-alert-color-background, var(--sds-c-alert-color-background, var(--slds-g-color-neutral-base-50, rgb(116, 116, 116))));
 
  background-image:var(--slds-c-alert-image-background, var(--sds-c-alert-image-background, linear-gradient(45deg, var(--slds-g-color-neutral-10-opacity-10, rgba(0, 0, 0, 0.025)) 25%, transparent 25%, transparent 50%, var(--slds-g-color-neutral-10-opacity-10, rgba(0, 0, 0, 0.025)) 50%, var(--slds-g-color-neutral-10-opacity-10, rgba(0, 0, 0, 0.025)) 75%, transparent 75%, transparent)));
 
  background-size:var(--slds-c-alert-size-background, var(--sds-c-alert-size-background, 64px 64px));
}
```

## 사용 메모

- 기본 테마는 SLDS Lightning Blue이며, **스타일링 훅(`--slds-*`)** 으로 Cosmos 등 다른 테마에 맞게 커스터마이즈할 수 있습니다.
- 실제 마크업 예제·접근성 가이드·상호작용 가이드는 아래 SLDS 1 문서에 있습니다.

## 공식 문서 링크

- 📐 SLDS 1 블루프린트(마크업/가이드): https://v1.lightningdesignsystem.com/components/alert/
- 📚 SLDS 2 Component Blueprints 개요: https://www.lightningdesignsystem.com/2e1ef8501/p/755aff-components/b/459d9d

---
[← 블루프린트 목록으로](../blueprints-index.html)
