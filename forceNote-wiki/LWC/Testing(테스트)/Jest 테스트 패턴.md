---
tags: [lwc, testing, jest, wire-mock, dom-event, apex-mock]
source: github.com/salesforce/wire-service-jest-util README, developer.salesforce.com "Write Jest Tests for Wire Service" (unit-testing-using-wire-utility.html), github.com/salesforce/sfdx-lwc-jest README
created: 2026-05-18
aliases: [Jest 테스트, LWC Jest, wire mock, DOM 이벤트 테스트, apex mock, @salesforce/apex mock, createTestWireAdapter, createApexTestWireAdapter, createLdsTestWireAdapter]
---

# LWC Jest 테스트 패턴

> LWC 컴포넌트를 Jest로 테스트하는 3가지 핵심 패턴: @wire 어댑터 mock, DOM 이벤트 검증, @salesforce/apex mock.

---

## 환경 전제 조건

```bash
# @salesforce/sfdx-lwc-jest 패키지가 설치되어야 함
npm install @salesforce/sfdx-lwc-jest --save-dev
# jest.config.js에 lwc 관련 transform 설정 필요
```

---

## 패턴 1 — @wire 어댑터 Mock

`@wire`로 데이터를 가져오는 컴포넌트는 **테스트 wire 어댑터**로 목킹한다. 어댑터 팩토리는 `@salesforce/wire-service-jest-util`이 제공하며, `@salesforce/sfdx-lwc-jest`가 그대로 **재노출(re-export)** 하므로 `package.json`에 별도 의존성을 추가하지 않고 `@salesforce/sfdx-lwc-jest`에서 import한다.

> ⚠️ 옛 2.x API인 `registerTestWireAdapter(adapter)` / `registerApexTestWireAdapter(adapter)` / `registerLdsTestWireAdapter(adapter)`는 **더 이상 사용하지 않는다**. 3.x부터는 어댑터를 "등록"하는 게 아니라 팩토리로 **어댑터 자체를 생성**한다.

| 3.x 팩토리 (현행) | 반환값 | 용도 |
|---|---|---|
| `createTestWireAdapter()` | 제네릭 어댑터 (임의 shape 방출) | 커스텀 `@wire` 어댑터 |
| `createLdsTestWireAdapter()` | LDS 동작을 모방한 어댑터 (`{ data, error }` shape) | 커스텀 LDS 스타일 어댑터 |
| `createApexTestWireAdapter()` | Apex 메서드 연결 어댑터 (`{ data, error }` shape) | Apex `@wire` |

각 어댑터가 제공하는 방출 API (원본은 `@salesforce/wire-service-jest-util` README):

| 메서드 | 시그니처 | 설명 |
|---|---|---|
| `emit` | `emit(value, filterFn?)` | 컴포넌트로 데이터를 방출. `filterFn(config)`가 `true`인 인스턴스에만 선택 방출 가능 |
| `emitError` | `emitError(errorOptions?, filterFn?)` | 에러 방출. `errorOptions`는 `{ body, status, statusText }` |
| `error` | `error(body?, status?, statusText?)` | 기본값(status 404 등)으로 에러 방출하는 단축형 |
| `getLastConfig` | `getLastConfig()` | 마지막으로 해석된 `@wire` config 반환 (동적 파라미터 검증용) |

### 1-a. LDS 어댑터 (`lightning/uiRecordApi` 등) — 이미 스텁됨

`sfdx-lwc-jest`는 `lightning/*` 플랫폼 모듈의 스텁을 자동 설치하며, `getRecord` 같은 LDS 어댑터는 **이미 테스트 wire 어댑터로 스텁**돼 있다. 따라서 팩토리 생성 없이 어댑터를 그대로 import해 `.emit()` / `.error()`를 호출한다 (별도 `jest.mock` 불필요).

```javascript
// myComponent/__tests__/myComponent.test.js
import { createElement } from 'lwc';
import MyComponent from 'c/myComponent';
import { getRecord } from 'lightning/uiRecordApi';   // 이미 테스트 어댑터로 스텁됨

// 현실적인 mock 데이터 (보통 ./data/getRecord.json 로 분리)
const mockGetRecord = {
    fields: { Name: { value: 'Test Account' } }
};

describe('c-my-component wire mock', () => {
    let element;

    beforeEach(() => {
        element = createElement('c-my-component', { is: MyComponent });
        document.body.appendChild(element);
    });

    afterEach(() => {
        // 테스트 간 DOM 정리
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('레코드 데이터가 있을 때 이름을 표시한다', async () => {
        // 컴포넌트가 연결된 뒤 어댑터로 데이터 방출
        getRecord.emit(mockGetRecord);

        // 재렌더(microtask)에 예약되므로 flush 후 DOM 검증
        await Promise.resolve();

        const nameEl = element.shadowRoot.querySelector('.account-name');
        expect(nameEl.textContent).toBe('Test Account');
    });

    it('에러 발생 시 에러 패널을 표시한다', async () => {
        // 단축형 error() 또는 emitError({ body, status, statusText }) 사용
        getRecord.error('Not found', 404);
        await Promise.resolve();

        const errorEl = element.shadowRoot.querySelector('.error-panel');
        expect(errorEl).not.toBeNull();
    });
});
```

### 1-b. 커스텀 `@wire` 어댑터 — 모듈을 mock 해 팩토리로 생성

플랫폼 스텁이 없는 커스텀 wire 어댑터(예: `c/todoApi`의 `getTodo`)는 그 모듈을 `jest.mock`으로 대체하고 export를 `createTestWireAdapter()`로 만든다. 테스트에서 같은 심볼을 import해 `.emit()`을 호출한다.

```javascript
// myComponent/__tests__/myComponent.test.js
import { createElement } from 'lwc';
import MyComponent from 'c/myComponent';
import { getTodo } from 'c/todoApi';   // @wire(getTodo, { id: 1 }) 로 쓰이는 커스텀 어댑터

// 커스텀 모듈을 테스트 어댑터로 대체
jest.mock(
    'c/todoApi',
    () => {
        const { createTestWireAdapter } = require('@salesforce/sfdx-lwc-jest');
        return { getTodo: createTestWireAdapter() };
    },
    { virtual: true }
);

describe('c-my-component 커스텀 wire', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('데이터 방출을 처리한다', async () => {
        const element = createElement('c-my-component', { is: MyComponent });
        document.body.appendChild(element);

        getTodo.emit({ id: 1, title: 'delectus aut autem', completed: false });
        await Promise.resolve();

        const titleEl = element.shadowRoot.querySelector('.todo-title');
        expect(titleEl.textContent).toBe('delectus aut autem');
    });
});
```

### 1-c. Apex `@wire` — `createApexTestWireAdapter`

`@wire(getContactList)`처럼 Apex 메서드를 `@wire`로 부르는 경우, 해당 Apex 모듈을 `createApexTestWireAdapter()`로 대체한다. `emit(data)`는 `{ data }` shape로, `error()`는 `{ error }` shape로 방출된다.

```javascript
import { createElement } from 'lwc';
import MyComponent from 'c/myComponent';
import getContactList from '@salesforce/apex/ContactController.getContactList';

jest.mock(
    '@salesforce/apex/ContactController.getContactList',
    () => {
        const { createApexTestWireAdapter } = require('@salesforce/sfdx-lwc-jest');
        return { default: createApexTestWireAdapter(jest.fn()) };
    },
    { virtual: true }
);

const MOCK_CONTACTS = [{ Id: '001', Name: 'Amy Taylor' }];

describe('c-my-component apex wire', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('연락처를 목록으로 표시한다', async () => {
        const element = createElement('c-my-component', { is: MyComponent });
        document.body.appendChild(element);

        getContactList.emit(MOCK_CONTACTS);   // { data: MOCK_CONTACTS } 로 방출
        await Promise.resolve();

        const items = element.shadowRoot.querySelectorAll('.contact-item');
        expect(items.length).toBe(MOCK_CONTACTS.length);
    });
});
```

> 참고 — Apex를 **`@wire`가 아니라 명령형(imperative)으로** 호출하면 어댑터가 아니라 `jest.fn()`을 반환하는 mock으로 대체한다(아래 패턴 3). `createApexTestWireAdapter`는 `@wire` 전용이다.

---

## 패턴 2 — DOM 이벤트 테스트

사용자 상호작용(버튼 클릭, 입력 변경)을 시뮬레이션하고 이벤트 발행 여부를 검증한다.

```javascript
// contactTile/__tests__/contactTile.test.js
import { createElement } from 'lwc';
import ContactTile from 'c/contactTile';

describe('c-contact-tile DOM event', () => {
    let element;

    beforeEach(() => {
        element = createElement('c-contact-tile', { is: ContactTile });
        element.contact = { Id: '001xx', Name: 'Jane Doe', Phone: '555-1234' };
        document.body.appendChild(element);
    });

    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('버튼 클릭 시 contactselect 이벤트를 발행한다', async () => {
        // 이벤트 리스너 등록
        const handler = jest.fn();
        element.addEventListener('contactselect', handler);

        // 버튼 클릭 시뮬레이션
        const button = element.shadowRoot.querySelector('lightning-button');
        button.dispatchEvent(new CustomEvent('click'));

        await Promise.resolve();

        // 이벤트 발행 여부 및 detail 검증
        expect(handler).toHaveBeenCalledTimes(1);
        expect(handler.mock.calls[0][0].detail.contactId).toBe('001xx');
    });

    it('입력 변경 시 내부 상태가 업데이트된다', async () => {
        const input = element.shadowRoot.querySelector('lightning-input');

        // input 이벤트 발행으로 change 시뮬레이션
        input.dispatchEvent(new CustomEvent('change', {
            detail: { value: 'New Name' }
        }));

        await Promise.resolve();

        // 바인딩된 값이 DOM에 반영됐는지 확인
        expect(input.value).toBe('New Name');
    });

    it('렌더링 시 연락처 이름을 표시한다', () => {
        // 동기 DOM 접근 (이벤트 없이 초기 렌더링 검증)
        const name = element.shadowRoot.querySelector('h3');
        expect(name.textContent).toBe('Jane Doe');
    });
});
```

---

## 패턴 3 — @salesforce/apex Mock

`@salesforce/apex`로 가져온 Apex 메서드를 Jest 함수로 교체하여 테스트한다.

```javascript
// apexImperativeCall/__tests__/apexImperativeCall.test.js
import { createElement } from 'lwc';
import ApexImperativeCall from 'c/apexImperativeCall';

// Apex 메서드 mock으로 교체 (jest.fn()으로 자동 치환됨)
import getContactList from '@salesforce/apex/ContactController.getContactList';

// jest.mock()으로 전체 모듈 mock
jest.mock(
    '@salesforce/apex/ContactController.getContactList',
    () => {
        return { default: jest.fn() };
    },
    { virtual: true }  // virtual: true — 실제 파일 없이 mock 등록
);

const MOCK_CONTACTS = [
    { Id: '001', Name: 'Amy Taylor', Phone: '555-1234' },
    { Id: '002', Name: 'Michael Jones', Phone: '555-5678' }
];

describe('c-apex-imperative-call', () => {
    let element;

    beforeEach(() => {
        element = createElement('c-apex-imperative-call', {
            is: ApexImperativeCall
        });
        document.body.appendChild(element);
    });

    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks();
    });

    it('버튼 클릭 시 연락처 목록을 불러온다', async () => {
        // Apex mock이 성공 데이터를 반환하도록 설정
        getContactList.mockResolvedValue(MOCK_CONTACTS);

        const button = element.shadowRoot.querySelector('lightning-button');
        button.dispatchEvent(new CustomEvent('click'));

        // Promise 해결 대기
        await Promise.resolve();
        await Promise.resolve();  // LWC 렌더링 사이클 추가 대기

        const items = element.shadowRoot.querySelectorAll('.contact-item');
        expect(items.length).toBe(MOCK_CONTACTS.length);
    });

    it('Apex 호출 실패 시 에러 메시지를 표시한다', async () => {
        // Apex mock이 에러를 반환하도록 설정
        getContactList.mockRejectedValue({ body: { message: 'Error fetching contacts' } });

        const button = element.shadowRoot.querySelector('lightning-button');
        button.dispatchEvent(new CustomEvent('click'));

        await Promise.resolve();
        await Promise.resolve();

        const errorEl = element.shadowRoot.querySelector('.error-message');
        expect(errorEl).not.toBeNull();
    });
});
```

---

## @wire vs Imperative Apex 테스트 비교

| | @wire 어댑터 Mock | Imperative Apex Mock |
|---|---|---|
| 대체 방법 | `createTestWireAdapter()` / `createApexTestWireAdapter()` (LDS 어댑터는 자동 스텁) | `jest.mock('@salesforce/apex/...', () => ({ default: jest.fn() }))` |
| 데이터 주입 | `adapter.emit(data)` | `mockFn.mockResolvedValue(data)` |
| 에러 주입 | `adapter.emitError({ body, status, statusText })` / `adapter.error()` | `mockFn.mockRejectedValue(error)` |
| 사용 시기 | `@wire` 데코레이터로 선언된 데이터 로드 | 버튼 클릭 등 이벤트로 직접 호출하는 Apex |

---

## microtask flush — 왜 `await`가, 왜 때로 2회 필요한가

LWC의 재렌더는 **동기적으로 일어나지 않는다.** `emit()`으로 데이터를 방출하거나 이벤트로 반응형(reactive) 프로퍼티를 바꾸면 컴포넌트가 "더티" 표시되고 재렌더가 **microtask 큐에 예약**된다. 현재 실행 중인 동기 코드가 끝난 뒤에야 그 microtask가 소진되며 DOM이 갱신된다. 따라서 프로퍼티를 바꾼 직후 곧바로 `shadowRoot`를 쿼리하면 아직 옛 DOM이라 검증이 실패한다. `await Promise.resolve()`(또는 `flushPromises`)는 테스트를 microtask 경계에서 한 번 양보시켜 예약된 재렌더가 끝나도록 한다.

**2회가 필요한 경우**는 microtask가 사슬(chain)로 이어질 때다. 대표적으로 명령형 Apex: (1) 첫 `await`는 Apex 호출의 Promise 해결을 소진하고 — 이때 핸들러가 결과를 반응형 프로퍼티에 대입하면 — (2) 그 대입이 **또 하나의 재렌더 microtask**를 예약하므로 두 번째 `await`로 그 재렌더까지 flush해야 최종 DOM이 나온다. 즉 "Promise 해결 1 microtask + 재렌더 1 microtask"라서 2회다. 사슬 깊이를 세기 번거로우면 `setTimeout(…, 0)` 기반 `flushPromises`(매크로태스크까지 비움)를 한 번 쓰는 편이 안전하다.

---

## 자주 쓰는 Jest 유틸리티

```javascript
// DOM 업데이트 대기 (flushPromises 헬퍼 대신 Promise.resolve() 체인 사용)
await Promise.resolve();

// 비동기 Apex 호출 이후 2회 대기 필요할 때 (Promise 해결 + 재렌더 microtask)
await Promise.resolve();
await Promise.resolve();

// flushPromises 패턴 (커스텀 유틸)
function flushPromises() {
    return new Promise(resolve => setTimeout(resolve, 0));
}
await flushPromises();

// mock 초기화
jest.clearAllMocks();      // mock 호출 기록만 초기화
jest.resetAllMocks();      // mock 구현도 초기화
jest.restoreAllMocks();    // jest.spyOn 원본 복구
```

---

## 관련 노트

- [[sfdx-lwc-jest 설정·실행]] — `@salesforce/sfdx-lwc-jest` 설치·`jest.config.js`·npm 스크립트
- [[컴포넌트 마운트·DOM 쿼리 레퍼런스]] — `createElement`→`appendChild`·`shadowRoot` 쿼리·microtask flush 절차
- [[Jest 스냅샷·커버리지]] — 스냅샷 테스트·커버리지 리포트
- [[Wire 패턴]] — @wire 어댑터 사용법 (컴포넌트 구현)
- [[Imperative 호출 패턴]] — async/await Apex 직접 호출 (컴포넌트 구현)
- [[테스트 전략]] — Apex 테스트 전략 (비교 참조)
