---
tags: [lwc, api, property, method, getter-setter, pattern]
source: lwc-recipes/apiProperty, apiMethod, apiSetterGetter, apiSpread, lwc-recipes-main/force-app/main/default/lwc/dispatchEventHeadlessAction, navigateToRecordHeadlessAction, editRecordScreenAction
created: 2026-05-17
aliases: [@api, api property, api method, lwc:spread, invoke, headless action, screen action, 헤드리스액션, 퀵액션, 단방향 데이터 흐름, props down events up, @api 재할당]
---

# @api 패턴

> `@api`는 부모 → 자식 데이터 전달(property) 또는 부모에서 자식 메서드 직접 호출(method)에 사용. 외부 공개 인터페이스.

---

## 세 데코레이터 대조 레퍼런스 (@api · @track · @wire)

LWC의 필드 데코레이터는 세 개뿐이다. 모두 `lwc` 모듈에서 import한다 — `import { LightningElement, api, track, wire } from 'lwc';`. `@api`가 **공개 인터페이스**를 담당하고, 나머지 둘은 각각 **반응성**·**데이터 서비스 바인딩**을 담당한다.

| 데코레이터 | 목적 | 문법 | 언제 쓰나 |
|---|---|---|---|
| `@api` | 프로퍼티/메서드를 **공개(public)** — 부모가 값을 내려주거나 메서드를 직접 호출 | `@api firstName;` · `@api refresh() { … }` | 컴포넌트의 외부 인터페이스를 노출할 때 (부모→자식 데이터·명령) |
| `@track` | **객체/배열의 내부 변경**(속성 mutation, 요소 push 등)까지 반응성 추적 | `@track state = { … };` | 대부분 불필요 — 필드는 이미 반응형. 객체/배열을 **재할당하지 않고 내부만** 바꿔야 할 때만 |
| `@wire` | Apex 메서드·Lightning Data Service 등 **데이터 서비스에 프로퍼티/함수를 바인딩** | `@wire(getContacts) contacts;` | 데이터를 선언적으로 읽고 반응적으로 갱신받을 때 |

> [!note] @track은 이제 대부분 필요 없다
> LWC 필드는 기본적으로 반응형이라, 필드에 **새 값을 재할당**하면(`this.obj = {…}`) 데코레이터 없이도 재렌더된다. `@track`은 재할당 없이 **기존 객체/배열의 내부를 직접 mutate**할 때만 반응성을 살린다. 상세는 [[LWC 리액티비티 (반응형 필드·재렌더 트리거)]] 참조.
>
> `@wire`의 함수·프로퍼티 형태, 동적 파라미터(`'$recordId'`), 에러 처리 등 상세는 [[Wire 패턴]] 참조. 이 노트는 이하 `@api`의 실전 패턴에 집중한다.

---

## 패턴 1: @api Property (단순 전달)

```javascript
// child.js
import { LightningElement, api } from 'lwc';

export default class Child extends LightningElement {
    @api firstName;
    @api lastName;

    // @api + getter로 계산 속성 노출
    get fullName() {
        return `${this.firstName} ${this.lastName}`;
    }
}
```

```html
<!-- 부모에서 사용 -->
<c-child first-name={contact.FirstName} last-name={contact.LastName}></c-child>
```

> [!note] HTML 속성명 변환
> `@api firstName` → HTML 속성은 `first-name` (camelCase → kebab-case 자동 변환)

---

## 패턴 2: @api Method (부모 → 자식 명령)

```javascript
// clock.js (자식)
export default class Clock extends LightningElement {
    timestamp = new Date();

    @api
    refresh() {
        this.timestamp = new Date(); // 부모가 명시적으로 호출
    }
}

// apiMethod.js (부모)
export default class ApiMethod extends LightningElement {
    handleRefresh() {
        // querySelector로 자식 참조 후 직접 호출
        this.template.querySelector('c-clock').refresh();
    }
}
```

> [!tip] 언제 @api method?
> 이벤트가 아닌 **명령형 액션**이 필요할 때. 예: 폼 리셋, 타이머 재시작, 데이터 새로고침.

---

## 패턴 3: @api Getter/Setter (Validation + 파생 상태)

```javascript
// todoList.js
export default class TodoList extends LightningElement {
    _todos = []; // private (underscore convention)
    filteredTodos = [];

    @api
    get todos() {
        return this._todos;
    }
    set todos(value) {
        this._todos = value;
        this.filterTodos(); // setter에서 side-effect 처리
    }

    filterTodos() {
        this.filteredTodos = this.priorityFilter
            ? this._todos.filter(t => t.priority)
            : this._todos;
    }
}

// 부모에서 — 반드시 새 배열로 업데이트 (immutable)
this.todos = [...this.todos, newTodo]; // ✅
this.todos.push(newTodo);              // ❌ setter 트리거 안 됨
```

**Getter/Setter를 쓰는 이유:**
- 입력값 유효성 검사
- 파생 상태 동기화 (`filteredTodos`)
- 부수 효과 처리 (로깅, 이벤트 발행 등)

---

## 패턴 4: lwc:spread (다중 @api 한번에 전달)

```javascript
// 부모
export default class ApiSpread extends LightningElement {
    props = { firstName: 'Amy', lastName: 'Taylor' };

    handleChange(event) {
        // spread로 새 객체 생성 → 반응성 보장
        this.props = {
            ...this.props,
            [event.target.name]: event.target.value
        };
    }
}
```

```html
<!-- 부모 템플릿 -->
<c-child lwc:spread={props}></c-child>

<!-- c-child는 @api firstName, @api lastName 선언
     props 객체의 key가 @api 이름에 자동 매핑 -->
```

> props 객체의 key가 자식의 `@api` 이름과 **정확히 일치**해야 함.

---

## 패턴 5: @api invoke() — 헤드리스 / 스크린 퀵액션

`@api method` 중 특수한 계약이 하나 있다. 컴포넌트를 `lightning__RecordAction` 타깃으로 노출하면, **플랫폼이** 사용자가 레코드 페이지의 액션 버튼을 클릭할 때 `invoke()`라는 이름의 `@api` 메서드를 자동 호출한다. 즉 `refresh()`(패턴 2)처럼 부모 컴포넌트가 호출하는 게 아니라 **런타임이 진입점으로 호출**하는 예약 메서드다.

js-meta.xml의 `<actionType>`에 따라 두 모드로 갈린다.

| actionType | 템플릿(HTML) | invoke() | 동작 |
|---|---|---|---|
| `Action` (헤드리스) | 없음 / 빈 `<template> </template>` | 클릭 즉시 실행 | UI 없이 로직만 (toast·navigate·DML). 끝나면 자동 종료 |
| `ScreenAction` | 모달 패널 UI | 정의 안 함 | 퀵액션 모달을 띄우고, 버튼 핸들러가 로직 수행 후 `CloseActionScreenEvent`로 닫음 |

### 5-1. 헤드리스 액션 (actionType=Action) — 템플릿 없음

`invoke()`가 UI 없이 실행되고 완료되면 액션이 자동으로 사라진다. `async`로 선언해 await도 가능하다.

```javascript
// dispatchEventHeadlessAction.js
import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class DispatchEventHeadlessAction extends LightningElement {
    @api recordId;
    @api async invoke() {
        // Fire Toast message
        let event = new ShowToastEvent({
            title: 'I am a headless action!',
            message: 'Hi there! Starting...'
        });
        this.dispatchEvent(event);
        // Wait and fire another another Toast message
        await this.sleep(2000);
        // Fire Toast message
        event = new ShowToastEvent({
            title: 'I am a headless action on record with id ' + this.recordId,
            message: 'All done!'
        });
        this.dispatchEvent(event);
    }

    sleep(ms) {
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        return new Promise((resolve) => setTimeout(resolve, ms));
    }
}
```

```html
<!-- dispatchEventHeadlessAction.html — 렌더링할 UI가 없다 -->
<template> </template>
```

```xml
<!-- dispatchEventHeadlessAction.js-meta.xml -->
<targets>
    <target>lightning__RecordAction</target>
</targets>
<targetConfigs>
    <targetConfig targets="lightning__RecordAction">
        <actionType>Action</actionType>
    </targetConfig>
</targetConfigs>
```

> [!note] 레코드 컨텍스트
> 헤드리스 액션도 `@api recordId`로 대상 레코드 Id를 플랫폼에서 주입받는다. `invoke()` 안에서 그 Id로 후속 작업을 한다.

### 5-2. invoke() 안에서 navigate — NavigationMixin

`invoke()`는 헤드리스이므로 toast뿐 아니라 화면 전환도 트리거할 수 있다. `NavigationMixin`을 믹스인해 진입점에서 바로 네비게이트한다. (여기선 `async` 불필요 — 반환값을 기다리지 않는다.)

```javascript
// navigateToRecordHeadlessAction.js
import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class NavigateToRecordHeadlessAction extends NavigationMixin(
    LightningElement
) {
    @api invoke() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Contact',
                actionName: 'home'
            }
        });
    }
}
```

### 5-3. 스크린 액션 (actionType=ScreenAction) — 모달 UI + invoke 없음

`ScreenAction`은 `invoke()`를 **정의하지 않는다.** 대신 컴포넌트의 템플릿이 퀵액션 모달로 렌더링되고, 버튼 클릭 핸들러가 로직을 수행한 뒤 `CloseActionScreenEvent`로 모달을 닫는다. `@api recordId` / `@api objectApiName`는 플랫폼이 주입한다.

```javascript
// editRecordScreenAction.js (발췌)
import { CloseActionScreenEvent } from 'lightning/actions';
import { getRecord, updateRecord } from 'lightning/uiRecordApi';

export default class EditRecordScreenAction extends LightningElement {
    @api recordId;
    @api objectApiName;

    async handleSave() {
        // ...recordInput 구성...
        try {
            await updateRecord(recordInput);
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success', message: 'Contact updated', variant: 'success'
            }));
            this.dispatchEvent(new CloseActionScreenEvent()); // 모달 닫기
        } catch (error) {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error updating record, try again...',
                message: error.body.message, variant: 'error'
            }));
        }
    }

    handleCancel() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}
```

```xml
<!-- editRecordScreenAction.js-meta.xml -->
<targetConfig targets="lightning__RecordAction">
    <actionType>ScreenAction</actionType>
</targetConfig>
```

> [!tip] 언제 어느 쪽?
> - **UI 없이 즉시 실행**(레코드 상태 변경 후 toast, 다른 페이지로 이동) → `Action` + `@api invoke()`
> - **사용자 입력 폼이 필요**(필드 편집 후 저장) → `ScreenAction` + 템플릿 + `CloseActionScreenEvent`
>
> `js-meta.xml`의 `lightning__RecordAction` 타깃·`actionType` 등 config 요소 자체는 [[XML Config File Elements (js-meta.xml) 레퍼런스]] 참조. 여기서는 `@api invoke()` 계약과 두 actionType의 실행 흐름 차이에 집중한다.

---

## @api 규칙

| 규칙 | 이유 |
|---|---|
| @api는 public 인터페이스 | 외부 변경 가능 — 내부 상태는 private |
| **자식에서 @api 값 재할당 금지** | @api 프로퍼티는 **부모 소유(단방향 데이터 흐름)**. 자식이 `this.apiProp = ...`로 바꿔도 부모가 재렌더링되면 부모 값으로 **덮어써짐** → 변경이 유실되고 부모↔자식 상태가 어긋남 |
| Mutation 금지 | `this.apiProp.push(...)` ❌ → 새 객체/배열 생성 |
| Primitive + Object 모두 가능 | 단, 객체 전달 시 deep clone 고려 |
| @api method는 동기/async 모두 가능 | `@api async invoke() { ... }` |

---

## 자식에서 @api 값 변경이 필요하면 (props down, events up)

@api 값은 부모가 소유하므로 자식은 **직접 재할당하지 않는다.** 표준 처리법은 두 가지:

1. **로컬 private 복사본 사용** — @api getter/setter로 받아서 `_prop` 같은 private(reactive) 프로퍼티에 복사하고, 자식은 그 복사본만 수정 (패턴 3의 `_todos`가 바로 이 구조)
2. **CustomEvent로 부모에 변경 요청** — 자식은 이벤트만 올리고, 실제 값 변경은 소유자인 부모가 수행 → 부모가 새 값을 @api로 다시 내려보냄 (단방향 흐름 유지)

```javascript
// 구조 예시 — 실제 동작 코드 아님
// counter.js (자식)
import { LightningElement, api } from 'lwc';

export default class Counter extends LightningElement {
    _count; // ① 로컬 private 복사본 — 자식은 이것만 수정

    @api
    get count() {
        return this._count;
    }
    set count(value) {
        this._count = value; // 부모가 내려준 값을 복사
    }

    handleIncrement() {
        this._count += 1;              // ✅ 로컬 복사본 수정
        // this.count = this.count + 1; ❌ @api 재할당 — 부모 재렌더 시 덮어써짐

        // ② 소유자(부모)에게 변경 요청 — 부모가 값을 갱신해 다시 내려보냄
        this.dispatchEvent(
            new CustomEvent('countchange', { detail: this._count })
        );
    }
}
```

```javascript
// 구조 예시 — 실제 동작 코드 아님
// parent.js — 소유자가 값을 갱신 → @api로 다시 전달
handleCountChange(event) {
    this.count = event.detail; // 부모가 소유한 값을 변경
}
```

> [!tip] 원칙: **props down, events up**
> 데이터는 @api로 아래로(부모→자식), 변경 요청은 CustomEvent로 위로(자식→부모). 이벤트 발행 상세는 [[CustomEvent 패턴]] 참조.

---

## 관련 노트

- [[컴포지션 패턴]]
- [[CustomEvent 패턴]] — 자식 → 부모 방향
- [[상태 관리]] — 컴포넌트 내부 상태와 공유 데이터 관리
