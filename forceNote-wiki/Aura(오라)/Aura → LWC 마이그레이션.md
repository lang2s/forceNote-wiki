---
tags: [aura, lwc, migration, interoperability, bundle-mapping]
source: developer.salesforce.com (Lightning Web Components Developer Guide — Migrate Aura Components to Lightning Web Components; 라이브 공식 문서, Tier 2, 접속 2026-07-04) + lightningAura.pdf (Lightning Aura Components Developer Guide v67.0 Summer '26, Ch5 이벤트·Ch6 Lightning Message Service)
official_doc: https://developer.salesforce.com/docs/platform/lwc/guide/migrate-introduction.html
created: 2026-07-04
aliases: [Aura to LWC, Aura LWC 마이그레이션, migrate aura, 번들 파일 매핑, aura:attribute, aura:method, Aura 메서드 노출, cmp html, controller helper renderer, aura interop, Aura LWC 공존, 마이그레이션 치트시트]
---

# Aura → LWC 마이그레이션

> Aura 컴포넌트를 Lightning Web Component로 옮기는 절차 — 공존(interoperability)으로 한 번에 하나씩 점진 교체하며, 번들 파일·마크업·이벤트·인터페이스·CSS·JS·Apex·Quick Action을 영역별로 매핑한다.

---

## 공존과 상호운용 (LWC and Aura Working Together)

Aura와 LWC는 **interoperability layer** 위에서 한 앱 안에서 함께 동작한다. 그래서 전면 재작성 없이도:

- 이미 Aura 컴포넌트를 포함한 앱에 **새 LWC를 추가**하거나,
- 기존 Aura 컴포넌트를 **하나씩 LWC로 점진 교체**할 수 있다.

어드민과 엔드유저에게는 둘 다 똑같이 하나의 **Lightning component**로 보인다 — 사용 경험상 차이가 없다.

> ⚠️ **포함(containment) 방향은 한쪽으로만 열려 있다.**
> **Aura 컴포넌트는 LWC를 포함할 수 있으나, 반대는 불가** — LWC는 Aura 컴포넌트를 포함할 수 없다.
> 마이그레이션 순서를 설계할 때 이 비대칭이 핵심이다. LWC 안에 아직 남은 Aura 자식이 필요하면, 그 경계(부모)는 Aura로 유지해야 한다.

### 경계에서의 상호운용 — Aura 부모 ⊃ LWC 자식 (역방향 데이터·이벤트)

점진 교체 중에는 남아있는 Aura 컴포넌트가 새로 만든 LWC를 자식으로 감싸는 구간이 생긴다. 이 경계에서 데이터와 이벤트를 주고받는 방식은 다음과 같다 (부모→자식 직접 임베딩).

- **데이터 down (Aura → LWC):** Aura 마크업에서 LWC를 `<c:myLwcCmp>`로 참조하고, LWC의 **`@api` 퍼블릭 프로퍼티**를 마크업 속성으로 주입한다.
- **이벤트 up (LWC → Aura):** LWC가 `dispatchEvent(new CustomEvent(...))`로 올린 이벤트를 Aura 부모가 **`on<eventname>` 핸들러**로 수신한다. LWC 이벤트명은 **소문자**여야 하므로 Aura 핸들러도 `onmessagesent`처럼 소문자로 쓴다.

```xml
<!-- 구조 예시 — 실제 동작 코드 아님 -->
<!-- Aura 부모(.cmp)가 LWC 자식(c:myLwcCmp)을 포함 — 반대(LWC⊃Aura)는 불가 -->
<aura:component>
    <!-- 데이터 down: LWC @api 프로퍼티에 값 주입 / 이벤트 up: on<eventname> 핸들러로 수신 -->
    <c:myLwcCmp lwcProp="{!v.parentValue}"
                onmessagesent="{!c.handleFromLwc}"/>
</aura:component>
```

```javascript
// 구조 예시 — 실제 동작 코드 아님
// LWC 자식 (myLwcCmp.js): @api로 값 받고, CustomEvent로 Aura 부모에 통지
import { LightningElement, api } from 'lwc';

export default class MyLwcCmp extends LightningElement {
    @api lwcProp;                 // Aura가 주입한 값 수신

    notifyParent() {
        // Aura 부모의 onmessagesent 핸들러로 전달 (이벤트명 소문자)
        this.dispatchEvent(new CustomEvent('messagesent', { detail: { ok: true } }));
    }
}
```

```javascript
// 구조 예시 — 실제 동작 코드 아님
// Aura 부모 컨트롤러 (controller.js): LWC 이벤트 수신
({
    handleFromLwc: function(cmp, event, helper) {
        // event.detail 접근 등 세부 규칙은 아래 위임 링크 참조
    }
})
```

> 임베딩 속성 casing·이벤트 `detail` 접근 등 정확한 규칙은 LWC Developer Guide "Add Lightning Web Components to Aura Components" 소관이다. **관계가 없는(형제·원거리) 컴포넌트끼리 통신**해야 하면 이 부모-자식 임베딩 대신 [[Lightning Message Service]]를 쓴다 (아래 이벤트 이관 표 참조).

---

## 마이그레이션 10개 영역

공식 가이드(migrate-introduction)는 마이그레이션을 다음 10개 영역으로 나눈다.

1. **Migration Strategy** — 전략 수립
2. **Pick a Component to Migrate** — 옮길 컴포넌트 고르기
3. **Migrate Component Bundle Files** — 번들 파일 매핑
4. **Migrate Markup** — 마크업 매핑
5. **Migrate Events** — 이벤트 매핑
6. **Migrate Interfaces** — 인터페이스 매핑
7. **Migrate CSS** — CSS 이동
8. **Migrate JavaScript** — JS 로직 이동
9. **Migrate Apex** — Apex 연동 방식 전환
10. **Migrate Quick Actions** — Quick Action 전환

**보조 도구:**
- **MCP Tools for LWC / Aura-to-LWC Migration Tools** (mcp-aura) — 마이그레이션 지원 도구.
- Trailhead **"Lightning Web Components for Aura Developers"** — 학습 모듈.

전략상 원칙: **한 번에 컴포넌트 하나씩** 골라(Pick) 공존 상태에서 교체한다. 아래는 개별 영역별 매핑이다.

---

## 1. 번들 파일 매핑 (Migrate Component Bundle Files)

Aura 번들과 LWC 번들의 파일 대응 관계는 다음과 같다 (전수).

```text
// 구조 예시 — 실제 원본 다이어그램 아님 (아래 표를 정본으로 참조)
Aura 번들                         LWC 번들
──────────────────────────────    ──────────────────────
sample.cmp        (Markup)    ─▶  sample.html
sampleController.js           ─┐
sampleHelper.js               ─┼▶ sample.js   ← 3개 JS가 하나로
sampleRenderer.js             ─┘
sample.css        (CSS)       ─▶  sample.css
sample.design     (Design)    ─▶  sample.js-meta.xml
sample.auradoc    (Doc)       ─▶  (현재 없음)
sample.svg        (SVG)       ─▶  (현재 없음)
```

| Resource | Aura 파일 | LWC 파일 |
|---|---|---|
| Markup | `sample.cmp` | `sample.html` |
| Controller | `sampleController.js` | `sample.js` |
| Helper | `sampleHelper.js` | `sample.js` |
| Renderer | `sampleRenderer.js` | `sample.js` |
| CSS | `sample.css` | `sample.css` |
| Documentation | `sample.auradoc` | **현재 없음 (Not currently available)** |
| Design | `sample.design` | `sample.js-meta.xml` |
| SVG | `sample.svg` | **현재 없음** |

> ⚠️ **3 JS → 1 JS.** Aura의 **controller · helper · renderer** 세 개의 JavaScript 파일은 LWC에서 **하나의 JavaScript 파일**(`sample.js`)로 합쳐진다. JS 로직 이동 세부는 아래 [JavaScript](#8-javascript-migrate-javascript) 참조.

---

## 2. 마크업 매핑 (Migrate Markup)

마크업 마이그레이션은 다음 하위 영역으로 세분된다 (10, + Base Components 별도).

Migrate **Attributes · Iterations · Conditionals · Expressions · Global Value Providers · Initializers · Facets · Registered Events · Event Handlers · Access Controls**. (Migrate Base Components는 별도 다룸.)

아래는 이 노트가 본문 깊이로 다루는 두 축(Attributes·Expressions)이며, 나머지 하위 영역은 각 매핑 페이지 소관이다.

### 2a. Attributes (Migrate Attributes)

Aura의 `<aura:attribute>`는 LWC에서 **JavaScript 프로퍼티**가 된다.

- **`@api` 데코레이터**로 public property를 정의한다 (컴포넌트 외부에서 설정 가능한 값).
- HTML 파일에서는 그 프로퍼티를 참조한다.
- LWC는 변환 대상 Aura 컴포넌트의 속성을 **완전히 지원**해야 한다 (누락 없이 대응 프로퍼티를 만든다).

```javascript
// 구조 예시 — 실제 동작 코드 아님
// Aura:  <aura:attribute name="myAttribute" type="String" />
// LWC:   JS에서 @api public property로 정의
import { LightningElement, api } from 'lwc';

export default class Sample extends LightningElement {
    @api myAttribute;   // HTML에서 {myAttribute} 로 참조
}
```

> ⚠️ **Boolean 속성 규칙.** LWC 마크업에서는 Boolean 값을 `true`/`false`로 명시하지 않는다. **속성이 존재하면 `true`, 없으면 `false`** 다.

```html
<!-- 구조 예시 — 실제 동작 코드 아님 -->
<!-- 존재 = true -->
<c-sample is-active></c-sample>

<!-- 없음 = false -->
<c-sample></c-sample>
```

### 2b. Expressions (Migrate Expressions)

Aura의 마크업 표현식 문법은 LWC에서 **표현식을 JavaScript(프로퍼티/getter)로 옮기는** 방식으로 대체한다. JS로 옮기면 로직을 **단위 테스트**할 수 있다는 이점도 있다.

- 조건 분기는 `lwc:if`를 사용한다.
- **복잡한 식은 JS getter로** 캡슐화한다.

> ⚠️ **getter 참조에는 따옴표를 쓰지 않는다.** LWC HTML의 동적 콘텐츠에서 getter를 참조할 때 값을 따옴표로 감싸지 않는다 — 데이터 바인딩은 `{property}` 형태다. (바인딩 상세는 [[HTML 템플릿 Directives 레퍼런스]]의 Data Binding.)

```html
<!-- 구조 예시 — 실제 동작 코드 아님 -->
<!-- 데이터 바인딩: 따옴표 없음 -->
<p>{formattedName}</p>

<!-- 조건: lwc:if -->
<template lwc:if={isVisible}>
    <p>보임</p>
</template>
```

**조건·반복 directive 매핑** (세부는 [[HTML 템플릿 Directives 레퍼런스]] 위임):
- 조건 `aura:if` → **`lwc:if`**
- 반복 `aura:iteration` → **`for:each`** (key 필요)

각 매핑의 상세 규칙은 공식 migrate-conditionals · migrate-iterations 페이지 소관이다.

---

## 3. 이벤트 이관 (Migrate Events)

Aura의 두 이벤트 종류는 LWC에서 서로 다른 메커니즘으로 옮긴다. **Component Event는 `CustomEvent`로 1:1에 가깝게 대응**되지만, **Application Event는 직접 등가가 없어** 통신 성격에 따라 다른 도구로 재설계해야 한다.

| Aura 이벤트 | LWC 등가 | 매핑 노트 |
|---|---|---|
| **Component Event** (`type="component"` · 부모-자식 containment 계층) | **`CustomEvent`** | `this.dispatchEvent(new CustomEvent('name', { detail }))` — 계층 위로 전파. 부모는 `on<eventname>` 핸들러로 수신 |
| **Application Event** (`type="application"` · 전역 pub/sub) | ⚠️ **직접 등가 없음** → **[[Lightning Message Service]]** (또는 pubsub) | LWC엔 전역 이벤트 버스가 없다. containment 관계가 **없는** 컴포넌트끼리는 LMS(`lightning/messageService`)로 재설계. Aura는 `lightning:messageChannel`, LWC는 `publish`/`subscribe`로 같은 채널에 붙는다 |
| 이벤트 **phase** (`capture` / `bubble`) — Component Event 2단계, Application Event 3단계(+`default`) | `CustomEvent`의 `bubbles` · `composed` 옵션 (DOM 표준 전파) | Aura의 phase 기반 전파 → DOM 이벤트 전파 모델. **`CustomEvent`는 기본이 `bubbles:false`·`composed:false`** 이므로, Aura처럼 위로 올리려면 `bubbles:true`, shadow 경계를 넘기려면 `composed:true`를 명시한다 |

> ⚠️ **Application Event → CustomEvent 직역 금지.** Aura의 Application Event는 "구독한 모든 컴포넌트"에 전역 전파되지만, LWC `CustomEvent`는 DOM 트리(조상 방향)로만 전파된다. 형제·원거리 컴포넌트 간 전역 통신을 그대로 옮기려면 반드시 **Lightning Message Service**로 대체한다 — `CustomEvent`로는 재현되지 않는다.

Aura의 이벤트 phase·전파·`stopPropagation` 세부 동작은 [[Aura 이벤트]], LWC 측 `CustomEvent` 발행/수신 규칙은 [[CustomEvent 패턴]], 프레임워크 교차 통신 채널은 [[Lightning Message Service]] 소관이다.

---

## 4. 기타 영역 매핑 (개념 포인터)

아래 영역들은 각각 별도 위키 노트가 메커니즘을 보유한다. 이 노트에서는 **Aura → LWC 대응 방향만** 남기고 세부는 위임한다.

- **Events (migrate-events)** — 위 **3. 이벤트 이관** 섹션 참조 (Component Event → `CustomEvent`, Application Event → Lightning Message Service).
- **Methods (`aura:method`)** — Aura의 `<aura:method>`(부모가 자식 컴포넌트의 메서드를 직접 호출하도록 노출) → LWC는 **`@api` 퍼블릭 메서드**로 대응한다. JS 클래스 메서드에 `@api` 데코레이터를 붙이면 부모가 자식 요소 참조로 직접 호출할 수 있다.

  ```javascript
  // 구조 예시 — 실제 동작 코드 아님
  // Aura:  <aura:method name="refresh" />  +  controller의 refresh 함수
  // LWC:   @api 퍼블릭 메서드
  import { LightningElement, api } from 'lwc';

  export default class Sample extends LightningElement {
      @api refresh() {
          // 부모가 this.template.querySelector('c-sample').refresh() 로 호출
      }
  }
  ```

  → 호출 방식·언제 method vs property인지 등 상세는 [[@api 패턴]](패턴 2: @api Method) 위임.
- **Interfaces (migrate-interfaces)** — Aura 인터페이스(`force:hasRecordId` 등) → LWC의 대응 방식. (상세 페이지 위임.)
- **CSS (migrate-css)** — `sample.css`를 **그대로 이동**. 스코핑 규칙은 [[CSS 스타일시트와 스코핑]] 참조.
- **JavaScript (migrate-javascript)** — controller/helper/renderer 로직 → **하나의 JS 클래스**(ES modules).
- **Apex (migrate-apex)** — `@AuraEnabled` Apex → LWC는 **`@salesforce/apex`** import(wire / imperative). → 상세는 [[@salesforce Modules 레퍼런스]] · [[Wire 패턴]] · [[Imperative 호출 패턴]].
- **Quick Actions (migrate-quick-actions)** — Aura quick action → LWC quick action(`lightning__RecordAction` / `lightning__GlobalAction` 타깃). → [[XML Config File Elements (js-meta.xml) 레퍼런스]].

---

## 관련 노트
- [[Aura vs LWC]] — 두 컴포넌트 모델의 비교 (마이그레이션 판단의 짝)
- [[HTML 템플릿 Directives 레퍼런스]] — `lwc:if` · `for:each` · 데이터 바인딩
- [[CSS 스타일시트와 스코핑]] — CSS 마이그레이션과 스코핑 규칙
- [[@salesforce Modules 레퍼런스]] — `@AuraEnabled` Apex → `@salesforce/apex`
- [[Aura 이벤트]] — Aura Component/Application Event·phase 전파의 원본 메커니즘 (이관 전 이해)
- [[CustomEvent 패턴]] — Aura Component Event → `CustomEvent`
- [[Lightning Message Service]] — Aura Application Event 직접 등가 없음 → 프레임워크 교차 통신 채널
- [[@api 패턴]] — `aura:method` → `@api` 퍼블릭 메서드 (호출 방식 상세)
- [[XML Config File Elements (js-meta.xml) 레퍼런스]] — `design` → `js-meta.xml` · quick action 타깃
- [[VF → LWC 마이그레이션 전략]] — 대칭 결정 노트 (Visualforce → LWC. Aura와 달리 서버 렌더링 → 클라이언트 렌더링 모델 전환)
- [[LWC MOC]]
