# Visual Picker

블루프린트(CSS 전용) · 카테고리: **Component Blueprints**

시각적으로 강화된 라디오·체크박스·링크 선택.

> ⚠️ 블루프린트는 **스타일 전용 HTML/CSS 스캐폴딩**입니다. JavaScript·로직·상호작용이 없어 동작·접근성(ARIA/키보드)은 직접 구현해야 합니다. 가능하면 Lightning Base Component를 먼저 검토하세요.

## 주요 SLDS 클래스

`.slds-visual-picker`  (관련 클래스 약 10개)

```css
.slds-visual-picker {
  display:-webkit-inline-box;
 
  display:-ms-inline-flexbox;
 
  display:inline-flex;
 
  position:relative;
 
  -webkit-box-orient:vertical;
 
  -webkit-box-direction:normal;
 
      -ms-flex-direction:column;
 
          flex-direction:column;
 
  border:0;
 
  border-radius:0;
 
  text-align:center;
 
  cursor:pointer;
}
```

## 사용 메모

- 기본 테마는 SLDS Lightning Blue이며, **스타일링 훅(`--slds-*`)** 으로 Cosmos 등 다른 테마에 맞게 커스터마이즈할 수 있습니다.
- 실제 마크업 예제·접근성 가이드·상호작용 가이드는 아래 SLDS 1 문서에 있습니다.

## 공식 문서 링크

- 📐 SLDS 1 블루프린트(마크업/가이드): https://v1.lightningdesignsystem.com/components/visual-picker/
- 📚 SLDS 2 Component Blueprints 개요: https://www.lightningdesignsystem.com/2e1ef8501/p/755aff-components/b/459d9d

---
[← 블루프린트 목록으로](../blueprints-index.html)
