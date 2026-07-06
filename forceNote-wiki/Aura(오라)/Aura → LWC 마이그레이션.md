---
tags: [aura, lwc, migration, interoperability, bundle-mapping]
source: developer.salesforce.com (Lightning Web Components Developer Guide — Migrate Aura Components to Lightning Web Components; 라이브 공식 문서, Tier 2, 접속 2026-07-04)
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

## 3. 기타 영역 매핑 (개념 포인터)

아래 영역들은 각각 별도 위키 노트가 메커니즘을 보유한다. 이 노트에서는 **Aura → LWC 대응 방향만** 남기고 세부는 위임한다.

- **Events (migrate-events)** — Aura 컴포넌트/애플리케이션 이벤트 → LWC는 **`CustomEvent`**(위로 전파). 관계 없는 컴포넌트 간에는 pubsub / **Lightning Message Service**. → 상세는 [[CustomEvent 패턴]] · [[Lightning Message Service]].
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
- [[CustomEvent 패턴]] — Aura 이벤트 → `CustomEvent`
- [[@api 패턴]] — `aura:method` → `@api` 퍼블릭 메서드 (호출 방식 상세)
- [[XML Config File Elements (js-meta.xml) 레퍼런스]] — `design` → `js-meta.xml` · quick action 타깃
- [[LWC MOC]]
