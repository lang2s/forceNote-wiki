# Popovers

블루프린트(CSS 전용) · 카테고리: **Component Blueprints**

비모달 다이얼로그. 클릭 가능한 트리거와 함께 사용, 포커스 가능한 요소 1개 이상 포함.

> ⚠️ 블루프린트는 **스타일 전용 HTML/CSS 스캐폴딩**입니다. JavaScript·로직·상호작용이 없어 동작·접근성(ARIA/키보드)은 직접 구현해야 합니다. 가능하면 Lightning Base Component를 먼저 검토하세요.

## 주요 SLDS 클래스

`.slds-popover`  (관련 클래스 약 49개)

```css
.slds-popover {
  position:relative;
 
  border-radius:0.25rem;
 
  width:20rem;
 
  min-height:2rem;
 
  z-index:var(--slds-c-popover-position-zindex, 6000);
 
  background-color:var(--slds-g-color-neutral-base-100, rgb(255, 255, 255));
 
  display:inline-block;
 
  -webkit-box-shadow:0 2px 3px 0 rgba(0, 0, 0, 0.16);
 
          box-shadow:0 2px 3px 0 rgba(0, 0, 0, 0.16);
 
  border:1px solid var(--slds-g-color-border-base-1, rgb(229, 229, 229));
}
```

## 사용 메모

- 기본 테마는 SLDS Lightning Blue이며, **스타일링 훅(`--slds-*`)** 으로 Cosmos 등 다른 테마에 맞게 커스터마이즈할 수 있습니다.
- 실제 마크업 예제·접근성 가이드·상호작용 가이드는 아래 SLDS 1 문서에 있습니다.

## 공식 문서 링크

- 📐 SLDS 1 블루프린트(마크업/가이드): https://v1.lightningdesignsystem.com/components/popovers/
- 📚 SLDS 2 Component Blueprints 개요: https://www.lightningdesignsystem.com/2e1ef8501/p/755aff-components/b/459d9d

---
[← 블루프린트 목록으로](../blueprints-index.html)
