---
tags: [slds, slds2, best-practices, reference]
source: SLDS2-Docs — lightningdesignsystem.com (SLDS 2 v2.30.4, Tier 2)
created: 2026-06-13
aliases: [SLDS Best Practices, SLDS 모범 사례, 커스터마이즈 모델, SLDS1 vs SLDS2]
---

# SLDS 2 개발 모범 사례 (Best Practices)

> 출처: [SLDS 2 · Best Practices](https://www.lightningdesignsystem.com/2e1ef8501/p/528a43-best-practices)
> SLDS 2(Spring '25 도입)로 새 컴포넌트를 만들거나 기존 스타일을 업데이트할 때의 공식 가이드를 한국어로 정리했습니다.

## SLDS 1 vs SLDS 2 한눈에

- SLDS는 이제 두 버전입니다. **SLDS 2**(Spring '25~)와 기존 **SLDS 1**.
- SLDS 2는 **구조와 시각 디자인을 분리**한 새 CSS 프레임워크이며, 그 핵심이 **스타일링 훅(CSS 변수)** 입니다.
- 조직에서 **Salesforce Cosmos 테마**를 선택하면 SLDS 2를 사용(opt-in)하게 됩니다.
- 공통 원칙: **하드코딩 값 대신** SLDS 2에서는 스타일링 훅을, SLDS 1에서는 디자인 토큰을 사용하세요.

---

## 1단계: 내 사용 사례부터 파악하기

조직은 대개 **SLDS 1 전용 / SLDS 2 전용 / 둘의 혼용** 중 하나입니다.

| 코드베이스 상황 | 예시 | 참고 가이드 |
|---|---|---|
| **SLDS 1 전용** | Experience Cloud, SLDS 2 미전환 기존 Sales/Service Cloud | SLDS 1 Development Best Practices |
| **SLDS 2 (+SLDS 1 복귀 옵션)** | 신규 Starter/Pro Suite 조직, 신규 Service Cloud Pro Edition | SLDS 2 Best Practices · Styling Hooks · Global Styling Hooks |
| **SLDS 1·2 혼용** | Experience Cloud + 신규 Service Cloud Pro 등 제품 조합 | SLDS 1 Best Practices + Transition 가이드 |
| **SLDS 1 → 2 완전 전환** | 기존 Sales/Service Cloud 조직 | Transition Your Org to SLDS 2 |
| **둘 다 아님** | Slack, Tableau | 각 제품 문서 참조 |

> ⚠️ SLDS 2를 켰다면 **SLDS 1로 되돌릴 수도** 있습니다. 되돌리면 SLDS 2 커스터마이즈는 **SLDS 1 fallback 값이 없으면 동작하지 않습니다.** 그래서 SLDS 2 코드에 항상 SLDS 1 fallback을 넣어 두는 것이 안전합니다.

**정리**
- SLDS 2 전용이면 → SLDS 2 모범 사례에 집중.
- 혼용이면 → 글로벌 스타일링 훅을 쓰되 **반드시 fallback 값**을 함께 지정.

---

## 2단계: 3단계 커스터마이즈 모델 (핵심)

SLDS 2는 세 개의 커스터마이즈 레이어를 제공합니다. **아래로 갈수록 제어력은 커지지만 복잡·세분화**됩니다.
**항상 사용 사례에 맞는 "가장 낮은(앞선) 단계"부터 쓰고**, 필요할 때만 다음 단계로 내려가세요.

### ① Lightning Base Components 사용 (가장 먼저)

경험을 만드는 기본 빌딩 블록. SLDS 2 모범 사례를 그대로 따르며, 스타일된 variant를 제공해 빠른 개발이 가능합니다.

```html
<lightning-button variant="brand" label="저장"></lightning-button>
```

### ② SLDS Blueprint에서 시작

베이스 컴포넌트로 원하는 수준의 커스터마이즈가 안 될 때, 다음 기반 레이어인 **컴포넌트 블루프린트**(프레임워크 비종속 HTML/CSS)를 사용합니다. SLDS 2와 호환되고 SLDS 1과도 하위 호환됩니다.

- 컴포넌트 상세: SLDS 2 사이트
- 블루프린트 마크업: SLDS 1 사이트

### ③ 커스텀 컴포넌트 생성 (마지막)

①②로도 부족하면, **블루프린트에서 출발**해 **글로벌 스타일링 훅**으로 커스터마이즈합니다. 글로벌 훅은 색·타이포·간격·사이징 등의 CSS 속성을 제공하는 CSS 변수입니다.

```css
.my-custom-class {
  padding: var(--slds-g-sizing-1, 0.25rem);
}
```

> 🔑 **글로벌 스타일링 훅은 "참조(reference)"만 하세요. 값을 "할당(assign)"하지 마세요.**
> 값 할당은 테마·브랜딩 도구의 몫입니다. (자세한 내용은 `SLDS2-Styling-Hooks.md` 참고)

---

## 그 밖에 기억할 점

- **시맨틱 스타일링 훅**(최신 글로벌 훅)은 **SLDS 2 지원 조직에서만** 사용 가능하며 SLDS 1에는 없습니다.
- SLDS 2는 **단계적으로 롤아웃** 중입니다. 조직에서의 가용 여부는 Salesforce help 문서를 확인하세요.
- 깊은 셀렉터로 SLDS 클래스를 덮어쓰는 방식은 업그레이드에 취약하므로 지양하고, **스타일링 훅으로 안전하게** 커스터마이즈하세요.

---

### 관련 문서
- 스타일링 훅 상세: `SLDS2-Styling-Hooks.md`
- 유틸리티 클래스: `SLDS-Utilities.md`
- 컴포넌트: `components.html` (Base Components) · `blueprints-index.html` (Blueprints)

---

## 관련 노트

- [[SLDS(디자인시스템)/index|SLDS(디자인시스템) 색인]]
- [[SLDS LWC 디자인 시스템]] — SLDS 2 개념·스타일링 훅·LWC 적용
- [[SLDS 2 Starter Kit - SLDS 1·2 로더와 Shadow DOM]] — SLDS 1 vs 2 전환을 `<link media>` 토글로 구현한 실전 로더
- [[SLDS 2 Starter Kit - UI 코딩 가이드라인]] — LBC 우선 5단계 결정 트리·스타일링 훅 시맨틱 사용 규칙(`.builderrules`)
- [[LWC MOC]]
