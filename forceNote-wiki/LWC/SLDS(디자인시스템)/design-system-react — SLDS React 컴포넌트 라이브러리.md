---
tags: [slds, design-system-react, react, ui-bundle, icon-settings, blueprint, shadcn, tailwind, styling]
source: multiframework-recipes-main/force-app/main/react-recipes/uiBundles/reactRecipes/src/recipes/styling/*.tsx + src/app.tsx + vite.config.ts (실전 예시, Tier 1) + github.com/salesforce/design-system-react README + developer.salesforce.com/docs/platform/lwc/guide/create-components-css-slds-blueprint.html (레퍼런스, Tier 2)
created: 2026-07-04
aliases: [design-system-react, SLDS React, IconSettings, iconPath, SLDS blueprint React, React SLDS UI, DSR, shadcn SLDS, React on Salesforce styling]
---

# design-system-react — SLDS React 컴포넌트 라이브러리

> React on Salesforce(UI Bundle)에서 SLDS 룩앤필 UI를 만드는 세 갈래 — `@salesforce/design-system-react`(컴포넌트가 마크업 생성) · raw SLDS blueprint(직접 `slds-*` 클래스) · shadcn/Tailwind(비-SLDS 커스텀) — 를 API·설정·제약과 실전 코드로 정리한다.

---

## 1. 배경 — React on Salesforce에서 SLDS를 입히는 세 가지 방법

LWC에는 `<lightning-card>`·`<lightning-button>`·`<lightning-icon>` 같은 **베이스 컴포넌트**가 SLDS 마크업을 캡슐화해준다. React UI Bundle에는 그런 프레임워크 내장 컴포넌트가 없으므로, SLDS 스타일을 얻는 방법이 세 가지로 갈린다.

| 방법 | 무엇 | LWC 대응 | 마크업 소유권 |
|---|---|---|---|
| **design-system-react (DSR)** | SLDS 마크업을 생성해주는 React 컴포넌트 라이브러리 (`<Card>`·`<Button>`·`<Icon>`) | `<lightning-*>` 베이스 컴포넌트에 가장 가까움 | 라이브러리가 소유 (props만 전달) |
| **raw SLDS blueprint** | 순수 JSX에 `slds-*` 유틸리티/BEM 클래스를 직접 부착 | 없음 (직접 작성) | 개발자가 소유 |
| **shadcn/ui + Tailwind** | Radix UI primitive + Tailwind 기반 중립 디자인 시스템 | 없음 (Salesforce 룩 아님) | 개발자가 소유 |

- **DSR·blueprint** 는 둘 다 `@salesforce-ux/design-system` CSS(약 980 KB)에 의존한다 — Salesforce 룩앤필.
- **shadcn/Tailwind** 는 SLDS CSS와 무관한 별도 디자인 시스템 — "Salesforce처럼 안 보여도 되는 커스텀 UI"용.

> [!note] SLDS blueprint 정의 (공식)
> 블루프린트는 **프레임워크 비종속의 접근성 있는 HTML·CSS**로, 컴포넌트의 겉모습과 상호작용을 정의하되 **로직은 포함하지 않는다.** 베이스 컴포넌트가 지원되지 않는 곳에서 쓴다. 블루프린트로 만들면 **그 마크업이 네 컴포넌트 코드의 일부가 되며**, SLDS가 블루프린트를 갱신해도 네 코드는 자동 갱신되지 않는다(수동 유지보수 부담). — [SLDS Blueprints, LWC Dev Guide](https://developer.salesforce.com/docs/platform/lwc/guide/create-components-css-slds-blueprint.html)

---

## 2. design-system-react (DSR) — 설정과 API

### 2-1. 설치와 의존성

```bash
# 구조 예시 — 공식 README 기준
npm install @salesforce-ux/design-system @salesforce/design-system-react
```

- **peer 의존성:** React 16+, `react-dom`, 그리고 CSS 프레임워크 `@salesforce-ux/design-system`. (레시피 앱은 React 19 + DSR `^0.10.65` + design-system `2.29.0` 조합을 `overrides`로 고정.)
- **CSS 스타일시트 필수:** SLDS CSS를 페이지에 로드하고 공개 폴더에서 서빙해야 한다. 레시피 앱은 `slds.css`에서 `@layer`로 임포트한다.

```css
/* src/styles/slds.css — 실제 코드 */
@layer base, slds;
@import '@salesforce-ux/design-system/assets/styles/salesforce-lightning-design-system.min.css' layer(slds);
```

- 라이선스: 소스는 BSD 3-Clause, 아이콘·이미지는 CC BY-ND 4.0. SLDS 40여 개 컴포넌트를 래핑한다.

### 2-2. 컴포넌트 임포트 — 두 방식

```javascript
// 구조 예시 — 공식 README 기준
// (A) named import — 트랜스파일된 번들, CRA 호환 (레시피 앱이 쓰는 방식)
import { Button, Card, Icon, IconSettings } from '@salesforce/design-system-react';

// (B) cherry-pick 경로 import — 고급 Babel 설정 필요, 번들 축소
import Button from '@salesforce/design-system-react/components/button';
```

### 2-3. ⚠️ Vite `optimizeDeps` — CJS 프리번들 (핵심 제약)

`@salesforce/design-system-react`는 **CommonJS로 배포**된다. Vite의 ESM dev 서버가 이를 처리하려면 `optimizeDeps.include`로 미리 프리번들해야 한다. 누락 시 dev 서버에서 임포트/인터롭 에러가 난다.

```typescript
// vite.config.ts — 실제 코드
export default defineConfig(({ mode }) => {
  return {
    // design-system-react ships CJS — pre-bundle for Vite's ESM dev server
    optimizeDeps: {
      include: ['@salesforce/design-system-react'],
    },
    build: {
      // SLDS CSS alone is ~980 KB — raise the limit to avoid noisy warnings
      chunkSizeWarningLimit: 1024,
    },
    resolve: {
      dedupe: ['react', 'react-dom'],  // DSR가 별도 React를 끌어오지 않도록 중복 제거
    },
  };
});
```

---

## 3. IconSettings / Icon — 아이콘 경로 설정

DSR 아이콘은 SLDS SVG 스프라이트에서 온다. `<Icon>`을 쓰기 전에 반드시 **`<IconSettings>`로 스프라이트 base 경로를 설정**해야 한다(보통 앱 최상단에서 한 번).

### 3-1. IconSettings props

| prop | 타입 | 설명 |
|---|---|---|
| `iconPath` | string | 스프라이트 파일 경로 앞에 붙는 base. 예: `/assets/icons` → `/assets/icons/standard-sprite/svg/symbols.svg#account` |
| `onRequestIconPath` | function | 아이콘 경로를 동적으로 반환하는 콜백. **CORS** 이슈가 있는 배포에서 커스텀 경로가 필요할 때 사용 (iconPath 대신) |

앱 루트에서 한 번 감싸면 그 트리 안의 모든 `<Icon>`이 상속받는다.

```tsx
// src/app.tsx — 실제 코드 (앱 최상단에서 IconSettings 1회 래핑)
import { IconSettings } from '@salesforce/design-system-react';
import './styles/global.css';
import './styles/slds.css';

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <IconSettings iconPath="/assets/icons">
      <RouterProvider router={router} />
    </IconSettings>
  </StrictMode>
);
```

### 3-2. Icon props (레시피에서 쓰인 것)

| prop | 설명 |
|---|---|
| `category` | 스프라이트 카테고리 — `utility` · `standard` · `action` · `doctype` |
| `name` | 스프라이트 내 심볼 이름 (예: `account`, `add`) |
| `size` | `xx-small` · `x-small` · `small` · `medium` · `large` |
| `assistiveText` | `{ label: string }` — 스크린리더용 |

```tsx
// src/recipes/styling/IconsDSR.tsx — 실제 코드 (발췌)
import { Icon, IconSettings } from '@salesforce/design-system-react';

export default function IconsDSR() {
  return (
    // IconSettings tells DSR where the sprites are served from
    <IconSettings iconPath="/assets/icons">
      {/* ... category별 그룹 매핑 ... */}
      <Icon
        assistiveText={{ label: name }}
        category={category}   // 'utility' | 'standard' | 'action'
        name={name}
        size="small"
      />
    </IconSettings>
  );
}
```

---

## 4. 실전 예시 — 같은 UI를 세 방식으로

레시피 앱(`recipes/styling/`)은 **같은 Account 카드·버튼·아이콘 세트**를 DSR · SLDS blueprint · shadcn 세 방식으로 나란히 구현해 대조한다. 아래는 실제 코드 발췌.

### 4-1. Card — DSR vs blueprint vs shadcn

**(A) DSR `<Card>`** — 마크업을 라이브러리가 생성, props만 전달 (LWC `<lightning-card>`에 가장 근접):

```tsx
// AccountCardDSR.tsx — 실제 코드 (발췌)
import { Card } from '@salesforce/design-system-react';

<Card
  heading={account.Name?.value ?? ''}
  bodyClassName="slds-card__body_inner"
  footer={
    <a className="slds-card__footer-action" href="#">View Account</a>
  }
>
  <dl className="slds-list_horizontal slds-wrap">
    <dt className="slds-item_label slds-text-color_weak slds-truncate" title="Industry">Industry</dt>
    <dd className="slds-item_detail slds-truncate">{account.Industry?.value ?? '—'}</dd>
  </dl>
</Card>
```

**(B) raw SLDS blueprint** — `slds-card__*` BEM 클래스를 직접 부착, 마크업 전부 소유 (LWC `<lightning-card>`의 수동 등가물):

```tsx
// AccountCardSLDS.tsx — 실제 코드 (발췌)
<article className="slds-card">
  <div className="slds-card__header slds-grid">
    <header className="slds-media slds-media_center slds-has-flexi-truncate">
      <div className="slds-media__figure">
        {/* slds-icon-standard-account: 오브젝트 색 배경. 표준 오브젝트마다 클래스 존재 */}
        <span className="slds-icon_container slds-icon-standard-account" title="Account">
          <svg className="slds-icon slds-icon_small" aria-hidden="true">
            <use href="/assets/icons/standard-sprite/svg/symbols.svg#account" />
          </svg>
          <span className="slds-assistive-text">Account</span>
        </span>
      </div>
      <div className="slds-media__body">
        <h2 className="slds-card__header-title">
          <span className="slds-truncate">{account.Name?.value}</span>
        </h2>
      </div>
    </header>
  </div>
  <div className="slds-card__body slds-card__body_inner"> {/* ...dl... */} </div>
  <footer className="slds-card__footer">
    <a className="slds-card__footer-action" href="#">View Account</a>
  </footer>
</article>
```

**(C) shadcn/ui** — SLDS와 무관한 컴포넌트 + Tailwind 유틸리티:

```tsx
// AccountCardShadcn.tsx — 실제 코드 (발췌)
import { Card, CardContent, CardFooter, CardHeader, CardTitle } from '@/components/ui/card';

<Card>
  <CardHeader><CardTitle>{account.Name?.value}</CardTitle></CardHeader>
  <CardContent>
    <dl className="grid grid-cols-2 gap-x-4 gap-y-1 text-sm">
      <dt className="text-muted-foreground">Industry</dt>
      <dd>{account.Industry?.value ?? '—'}</dd>
    </dl>
  </CardContent>
  <CardFooter>
    <a href="#" className="text-sm text-primary hover:underline">View Account</a>
  </CardFooter>
</Card>
```

### 4-2. Button — variant 매핑 차이

DSR `<Button>`은 `variant`/`label`/아이콘 props로 SLDS 버튼 마크업을 생성. blueprint는 `slds-button_*` 클래스를 직접 붙인다. **같은 변형 집합**을 두 방식이 다르게 표현한다:

| 변형 | DSR `variant` | blueprint className |
|---|---|---|
| Neutral | `neutral` | `slds-button_neutral` |
| Brand | `brand` | `slds-button_brand` |
| Outline Brand | `outline-brand` | `slds-button_outline-brand` |
| Destructive | `destructive` | `slds-button_destructive` |
| Text Destructive | `text-destructive` | `slds-button_text-destructive` |
| Success | `success` | `slds-button_success` |

```tsx
// ButtonDSR.tsx — 실제 코드 (발췌): 아이콘 버튼도 props로
import { Button } from '@salesforce/design-system-react';

<Button label="Neutral" variant="neutral" />
<Button label="Brand" variant="brand" disabled />
<Button
  label="New Record"
  variant="neutral"
  iconCategory="utility"   // 아이콘 카테고리
  iconName="add"           // 아이콘 이름
  iconPosition="left"      // left | right
/>
```

```tsx
// ButtonSLDS.tsx — 실제 코드 (발췌): 아이콘은 <svg><use> 직접 작성
<button className={`slds-button slds-button_neutral`}>Neutral</button>
{/* 라벨 + 아이콘 */}
<button className="slds-button slds-button_neutral">
  <svg className="slds-button__icon slds-button__icon_left" aria-hidden="true">
    <use href="/assets/icons/utility-sprite/svg/symbols.svg#add" />
  </svg>
  New Record
</button>
{/* 아이콘 전용 */}
<button className="slds-button slds-button_icon slds-button_icon-border-filled" title="Settings">
  <svg className="slds-button__icon" aria-hidden="true">
    <use href="/assets/icons/utility-sprite/svg/symbols.svg#settings" />
  </svg>
  <span className="slds-assistive-text">Settings</span>
</button>
```

> shadcn의 `<Button>`은 variant 어휘 자체가 다르다 — `default`·`destructive`·`outline`·`secondary`·`ghost`·`link` + `size`(`sm`·`lg`·`icon`). SLDS variant와 1:1 대응하지 않는다.

### 4-3. Icon — 세 방식의 아이콘 소스

| 방식 | 아이콘 소스 | 코드 형태 |
|---|---|---|
| **DSR** | SLDS SVG 스프라이트 | `<Icon category name size>` (IconSettings 필요) |
| **blueprint** | SLDS SVG 스프라이트 | `<svg><use href="/assets/icons/{sprite}/svg/symbols.svg#{name}"/></svg>` + `slds-icon_container` 컨테이너 클래스 |
| **Lucide** (shadcn 계열) | tree-shakable React 컴포넌트 | `import { Home } from 'lucide-react'` → `<Home className="h-5 w-5" />` |

blueprint 아이콘의 스프라이트/클래스 명명 규칙 (실제 코드 기준):
- 스프라이트: `utility-sprite` · `standard-sprite` · `action-sprite`
- 표준 아이콘 컨테이너: `slds-icon_container slds-icon-standard-{name}` (오브젝트 색 배경)
- 액션 아이콘: `slds-icon_container slds-icon_container_circle slds-icon-action-{name}` — ⚠️ **스프라이트 심볼명은 언더스코어(`log_a_call`), CSS 클래스는 하이픈(`log-a-call`)** 을 쓴다.

---

## 5. 선택 기준 — 언제 무엇을

| 기준 | DSR (design-system-react) | raw SLDS blueprint | shadcn/Tailwind |
|---|---|---|---|
| 룩앤필 | Salesforce SLDS | Salesforce SLDS | 중립/커스텀 (비-SLDS) |
| 작성량 | 적음 (props) | 많음 (마크업 직접) | 중간 |
| 마크업 제어 | 낮음 (라이브러리 소유) | 높음 (전부 소유) | 높음 |
| SLDS 갱신 추종 | 라이브러리 업데이트로 | 수동 (직접 갱신) | 해당 없음 |
| 의존성 | DSR + SLDS CSS(~980KB) + CJS 프리번들 | SLDS CSS(~980KB)만 | Tailwind + Radix, SLDS 불필요 |
| 접근성 마크업 | 내장 | 직접 챙겨야 함 | shadcn/Radix 내장 |
| 언제 | SLDS UI를 빠르게, LWC 베이스컴포넌트처럼 | 특정 마크업/SLDS에 없는 조합이 필요할 때 | Salesforce 룩이 필요 없는 커스텀 앱 셸 |

- **DSR** — SLDS 40여 컴포넌트가 커버하는 범위 안에서 가장 빠르고 접근성도 챙겨준다. LWC 개발자에게 가장 익숙한 "props 전달" 모델.
- **blueprint** — DSR가 래핑하지 않은 컴포넌트/변형이 필요하거나 마크업을 완전히 통제해야 할 때. `slds-*` 유틸리티는 [[SLDS 유틸리티 클래스 레퍼런스]], 컴포넌트는 [[SLDS 블루프린트 카탈로그]] 참조.
- **shadcn** — 이 레시피 앱의 자체 셸도 shadcn을 쓴다. Salesforce 룩앤필이 목표가 아닌 UI에 적합.

> 세 방식은 한 앱에서 **혼용** 가능하다 (레시피 앱이 실증). 셸은 shadcn, 업무 카드는 DSR/blueprint 식으로. 단 DSR/blueprint를 쓰려면 SLDS CSS 로드 + `IconSettings` 래핑이 전제.

---

## 관련 노트
- [[SLDS 블루프린트 카탈로그]] — CSS 전용 blueprint 컴포넌트 인덱스 (raw blueprint 방식의 재료)
- [[SLDS 유틸리티 클래스 레퍼런스]] — `slds-*` 마진·그리드·타이포 유틸리티
- [[SLDS LWC 디자인 시스템]] — LWC에서 SLDS 적용 (베이스컴포넌트 관점)
- [[lightning-card]] — DSR `<Card>`의 LWC 대응 베이스 컴포넌트
- [[lightning-button]] — DSR `<Button>`의 LWC 대응
- [[lightning-icon]] — DSR `<Icon>`의 LWC 대응
- [[SLDS 2 Starter Kit - 빌드 설정과 진입 HTML]] — Vite 기반 SLDS 앱 빌드/진입 설정 (optimizeDeps 맥락)
- [[experience-ui-bundle-frontend-generate]] — React UI Bundle 프런트엔드 생성 sf-skill (실행 레이어)
