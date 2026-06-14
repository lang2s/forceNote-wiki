# Global Navigation

블루프린트(CSS 전용) · 카테고리: **Component Blueprints**

헤더의 전역 내비게이션(앱 런처·앱명·페이지 탭). 내부적으로 컨텍스트 바 사용.

> ⚠️ 블루프린트는 **스타일 전용 HTML/CSS 스캐폴딩**입니다. JavaScript·로직·상호작용이 없어 동작·접근성(ARIA/키보드)은 직접 구현해야 합니다. 가능하면 Lightning Base Component를 먼저 검토하세요.

## 주요 SLDS 클래스

`.slds-context-bar`  (관련 클래스 약 22개)

```css
.slds-context-bar {
  display:-webkit-box;
 
  display:-ms-flexbox;
 
  display:flex;
 
  height:2.5rem;
 
  background-color:var(--slds-g-color-neutral-base-100, rgb(255, 255, 255));
 
  border-bottom:3px solid rgb(27, 150, 255);
 
  color:var(--slds-g-color-neutral-base-10, rgb(24, 24, 24));
 
  position:relative;
 
  padding:0 0 0 1.5rem;
}
```

## 사용 메모

- 기본 테마는 SLDS Lightning Blue이며, **스타일링 훅(`--slds-*`)** 으로 Cosmos 등 다른 테마에 맞게 커스터마이즈할 수 있습니다.
- 실제 마크업 예제·접근성 가이드·상호작용 가이드는 아래 SLDS 1 문서에 있습니다.

## 공식 문서 링크

- 📐 SLDS 1 블루프린트(마크업/가이드): https://v1.lightningdesignsystem.com/components/global-navigation/
- 📚 SLDS 2 Component Blueprints 개요: https://www.lightningdesignsystem.com/2e1ef8501/p/755aff-components/b/459d9d

---
[← 블루프린트 목록으로](../blueprints-index.html)
