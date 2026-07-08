---
tags: [lwc, template, data-binding, expression, getter, event-handler, create-components]
source: developer.salesforce.com (Lightning Web Components Developer Guide — Create Components > "Data Binding in a Template" / "Templates"; 라이브 공식 문서, Tier 2, 접속 2026-07-08)
created: 2026-07-08
aliases: [LWC data binding, template binding, 데이터 바인딩, 템플릿 표현식, curly braces, property binding, getter binding, event handler binding, onclick 바인딩, 템플릿 getter]
---

# LWC 템플릿 기초 (데이터 바인딩·표현식)

> LWC 템플릿은 `{property}` 중괄호로 JS 프로퍼티/getter를 바인딩한다 — 표현식·함수 호출은 불가하며, 계산값은 반드시 getter로 만든다.

공식 문서: <https://developer.salesforce.com/docs/platform/lwc/guide/create-components-data.html>

---

## 1. `{property}` 바인딩 — 프로퍼티·getter만 허용

템플릿에서 중괄호 `{ }` 안에는 **JavaScript 클래스의 프로퍼티 이름** 또는 **getter 이름**만 넣을 수 있다. 중괄호와 프로퍼티 이름 사이에 공백을 넣지 않는다.

```html
<!-- helloBinding.html -->
<template>
    <p>Hello, {greeting}!</p>
</template>
```

```javascript
// helloBinding.js
import { LightningElement } from 'lwc';

export default class HelloBinding extends LightningElement {
    greeting = 'World';
}
```

### 표현식·함수 호출이 불가능한 이유

템플릿 바인딩은 **식(expression)이 아니라 식별자(identifier) 하나**만 받는다. 아래는 전부 **컴파일 에러 또는 무효**다.

```html
<!-- 구조 예시 — 실제 동작 코드 아님 (모두 금지 패턴) -->
<p>{price * quantity}</p>       <!-- ❌ 산술 표현식 불가 -->
<p>{getFullName()}</p>          <!-- ❌ 함수 호출 불가 -->
<p>{items.length > 0}</p>       <!-- ❌ 비교 표현식 불가 -->
<p>{value ? 'A' : 'B'}</p>      <!-- ❌ 삼항 연산자 불가 -->
```

- LWC는 템플릿 안에서 임의의 JS를 실행하지 않는다. 이는 **런타임 성능**(바인딩당 단순 프로퍼티 조회만)과 **보안·예측 가능성**(뷰에 로직을 숨기지 않음)을 위한 설계다.
- 따라서 **계산이 필요한 모든 값은 JS 쪽 getter로 옮긴다.**

---

## 2. computed 값은 getter로

표현식 대신 getter를 정의하고, 템플릿에서는 그 getter 이름만 바인딩한다.

```html
<!-- computed.html -->
<template>
    <p>Total: {total}</p>
    <p>Full name: {fullName}</p>
</template>
```

```javascript
// computed.js
import { LightningElement } from 'lwc';

export default class Computed extends LightningElement {
    price = 10;
    quantity = 3;
    firstName = 'Ada';
    lastName = 'Lovelace';

    get total() {
        return this.price * this.quantity;   // 계산 로직은 JS에
    }

    get fullName() {
        return `${this.firstName} ${this.lastName}`;
    }
}
```

- getter는 렌더링 시점에 평가되며, 참조하는 반응형 프로퍼티(`price`·`quantity` 등)가 바뀌면 재렌더와 함께 자동 재평가된다.
- getter 안에서 **다른 컴포넌트나 DOM을 변경하지 않는다** — 순수하게 값만 반환한다.

---

## 3. `{obj.prop}` 중첩 프로퍼티 접근

바인딩은 점 표기법으로 객체의 중첩 프로퍼티에 접근할 수 있다. 단 **점으로 이어진 프로퍼티 경로**만 허용되고, 그 이상(대괄호 인덱싱·메서드 호출)은 불가하다.

```html
<!-- nested.html -->
<template>
    <p>{contact.Name}</p>
    <p>{contact.Account.Industry}</p>
</template>
```

```javascript
// nested.js
import { LightningElement } from 'lwc';

export default class Nested extends LightningElement {
    contact = {
        Name: 'Amy Taylor',
        Account: { Industry: 'Technology' }
    };
}
```

- `{items[0]}` 같은 **인덱스 접근은 불가** — 리스트의 특정 항목이 필요하면 getter로 꺼내거나 `for:each`로 순회한다.
- 중첩 경로 중간이 `undefined`이면 바인딩은 조용히 빈 값으로 렌더링된다(에러를 던지지 않음).

---

## 4. 이벤트 핸들러 바인딩 `onclick={handleClick}`

DOM 이벤트는 `on` + 이벤트명 속성에 **핸들러 메서드 이름을 괄호 없이** 바인딩한다.

```html
<!-- clicker.html -->
<template>
    <button onclick={handleClick}>Click</button>
</template>
```

```javascript
// clicker.js
import { LightningElement } from 'lwc';

export default class Clicker extends LightningElement {
    count = 0;

    handleClick(event) {
        this.count += 1;          // this 는 컴포넌트 인스턴스로 바인딩됨
    }
}
```

- **괄호를 붙이지 않는다.** `onclick={handleClick()}`처럼 쓰면 렌더 시점에 함수를 즉시 호출한 뒤 그 반환값을 핸들러로 등록하려 하므로 잘못된 동작이다. 이름만 넘겨 "이 함수를 나중에 이벤트가 나면 호출하라"는 참조를 전달한다.
- LWC는 핸들러를 호출할 때 **`this`를 컴포넌트 인스턴스에 자동 바인딩**한다. 별도 `.bind(this)`가 필요 없다.
- 핸들러는 표준 DOM `Event` 객체를 인자로 받는다(`event.target`, `event.detail` 등).
- 핸들러에 인자를 넘기고 싶으면 `data-*` 속성으로 실어 `event.target.dataset`에서 읽는다(템플릿에서 인자를 직접 전달할 수 없기 때문).

```html
<!-- 구조 예시 — data-* 로 값 전달 -->
<button data-id="42" onclick={handleSelect}>Select</button>
```

```javascript
// 구조 예시 — dataset 에서 읽기
handleSelect(event) {
    const id = event.target.dataset.id;   // "42"
}
```

---

## 5. HTML 속성(attribute) vs 프로퍼티(property) 바인딩

HTML 표준 요소에서 대부분의 속성은 그대로 바인딩하되, **일부는 이름이 다르다.** LWC는 표준 DOM 규칙을 따른다.

| HTML 속성 | 바인딩 시 이름 | 이유 |
|---|---|---|
| `class` | `class` | 그대로 |
| `for` (label) | `for` | 그대로 (커스텀 컴포넌트에선 `for` 예약) |
| `tabindex` | `tabindex` | 소문자 |
| `maxlength` | `maxlength` | 소문자 |
| `readonly` | `readonly` | 소문자 |

```html
<!-- attr.html -->
<template>
    <input type="text" value={inputValue} maxlength="10">
    <div class={containerClass}>...</div>
</template>
```

- 커스텀 LWC 컴포넌트에 값을 넘길 때는 **`@api` 프로퍼티**로 바인딩되며, 카멜케이스 JS 프로퍼티(`itemLabel`)는 마크업에서 **케밥케이스**(`item-label`)로 쓴다.

```html
<!-- 구조 예시 — 자식 컴포넌트에 @api 프로퍼티 전달 -->
<c-child item-label={label}></c-child>   <!-- JS의 @api itemLabel 에 매핑 -->
```

---

## 6. boolean · class · style 바인딩

### Boolean 속성

`disabled`, `readonly` 같은 boolean 속성은 truthy/falsy 프로퍼티로 바인딩한다.

```html
<!-- bool.html -->
<template>
    <button disabled={isDisabled}>Save</button>
</template>
```

```javascript
// bool.js
isDisabled = true;   // false 면 속성이 제거되어 활성화됨
```

### class 바인딩 — 계산된 클래스는 getter로

`class`에 동적 값을 넣을 때도 표현식은 불가하므로 getter로 문자열을 만든다.

```html
<!-- class.html -->
<template>
    <div class={computedClass}>Status</div>
</template>
```

```javascript
// class.js
import { LightningElement } from 'lwc';

export default class StatusBox extends LightningElement {
    active = true;

    get computedClass() {
        return this.active ? 'box box--active' : 'box';
    }
}
```

- 정적 클래스와 동적 클래스를 섞고 싶으면 getter 반환 문자열 안에 모두 담는다.

### style 바인딩

인라인 스타일도 getter로 문자열을 조립해 `style`에 바인딩한다(개별 CSS 프로퍼티 바인딩은 지원하지 않음).

```html
<!-- style.html -->
<template>
    <div style={barStyle}>progress</div>
</template>
```

```javascript
// style.js
get barStyle() {
    return `width: ${this.percent}%;`;
}
```

---

## 7. 디렉티브는 별도 노트로 위임

조건부 렌더링(`lwc:if`·`lwc:elseif`·`lwc:else`, 구형 `if:true`), 리스트 렌더링(`for:each`·`for:item`·`for:index`·`iterator:`·`key`), 슬롯, `lwc:ref`, `lwc:spread`, `lwc:on` 등 **템플릿 디렉티브 전체 문법과 고려사항**은 이 노트 범위 밖이다. 다음 레퍼런스를 참조한다.

- 디렉티브 전수: [[HTML 템플릿 Directives 레퍼런스]]

---

## 관련 노트
- [[HTML 템플릿 Directives 레퍼런스]] — 조건·리스트 렌더링, 슬롯 등 디렉티브 전수
- [[LWC MOC]] — LWC 섹션 전체 목차
- [[LWC 리액티비티 (반응형 필드·재렌더 트리거)]] — 바인딩된 프로퍼티가 바뀔 때 재렌더가 트리거되는 원리 (병렬 노트)
