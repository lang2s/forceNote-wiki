---
tags: [lwc, testing, jest, createElement, shadow-dom, dom-query]
source: developer.salesforce.com "Test Lightning Web Components" · github.com/salesforce/sfdx-lwc-jest 예제 · lwc.dev testing
created: 2026-07-08
aliases: [createElement, 컴포넌트 마운트, appendChild, shadowRoot querySelector, DOM 쿼리, teardown afterEach, flushPromises, microtask flush, dispatchEvent 테스트]
---

# 컴포넌트 마운트·DOM 쿼리 레퍼런스

> Jest 테스트에서 LWC를 마운트(`createElement` → `appendChild`)하고, `shadowRoot`로 DOM을 쿼리·검증하며, microtask flush로 재렌더를 기다리는 기본 절차 레퍼런스.

---

## 1. 마운트 — createElement → 프로퍼티 → appendChild

LWC는 브라우저처럼 `<c-foo>` 태그를 파싱해 만들 수 없다. 테스트에서는 `lwc`의 `createElement`로 인스턴스를 만들고, `@api` 프로퍼티를 설정한 뒤, `document.body`에 붙여야 컴포넌트가 렌더링된다.

```javascript
import { createElement } from 'lwc';
import Foo from 'c/foo';

// 1) 인스턴스 생성 — 첫 인자는 태그명(케밥케이스), is에 임포트한 클래스
const element = createElement('c-foo', { is: Foo });

// 2) @api 프로퍼티 설정 — appendChild 전에 설정하면 첫 렌더에 반영됨
element.recordId = '001xx0000000000';
element.title = 'Hello';

// 3) DOM에 붙이면 이 시점에 connectedCallback + 첫 렌더링이 발생
document.body.appendChild(element);
```

- 태그명은 반드시 케밥케이스(`c-foo`)이고 `is`에는 클래스를 넘긴다.
- `appendChild` **전에** 설정한 프로퍼티는 첫 렌더에 즉시 반영된다. `appendChild` **후에** 바꾼 프로퍼티는 재렌더(비동기)를 유발하므로 아래 "비동기 대기"가 필요하다.

---

## 2. 정리(teardown) — afterEach에서 DOM/jest 리셋

Jest는 하나의 JSDOM을 여러 테스트가 공유한다. 마운트한 엘리먼트를 지우지 않으면 이전 테스트의 DOM이 다음 테스트에 남아 오염된다. `afterEach`에서 `document.body`를 비우고 mock도 초기화한다.

```javascript
afterEach(() => {
    // JSDOM은 테스트 간 공유되므로 body를 직접 비운다
    while (document.body.firstChild) {
        document.body.removeChild(document.body.firstChild);
    }
    // jest.mock / jest.fn 호출 기록·구현 리셋
    jest.clearAllMocks();
});
```

| 리셋 메서드 | 효과 |
|---|---|
| `jest.clearAllMocks()` | mock 호출 기록만 초기화 (구현·반환값 유지) |
| `jest.resetAllMocks()` | 호출 기록 + 구현(`mockResolvedValue` 등)까지 초기화 |
| `jest.restoreAllMocks()` | `jest.spyOn`으로 감싼 원본 구현 복구 |

---

## 3. DOM 쿼리 — shadowRoot로 접근

LWC는 Shadow DOM을 쓰므로 `element.querySelector`가 아니라 **`element.shadowRoot.querySelector`** 로 컴포넌트 내부 마크업에 접근한다.

```javascript
// 단일 요소
const nameEl = element.shadowRoot.querySelector('.account-name');
expect(nameEl).not.toBeNull();

// 텍스트 검증
expect(nameEl.textContent).toBe('Test Account');

// 속성 검증
const link = element.shadowRoot.querySelector('a');
expect(link.getAttribute('href')).toBe('/detail');

// 클래스 검증
expect(nameEl.classList.contains('slds-truncate')).toBe(true);

// 여러 요소 — NodeList 반환, 개수/내용 검증
const items = element.shadowRoot.querySelectorAll('.contact-item');
expect(items.length).toBe(2);
expect(items[0].textContent).toBe('Amy Taylor');
```

- 자식 커스텀 컴포넌트(`<c-child>`)의 **내부**를 보려면 그 자식의 `shadowRoot`로 다시 들어가야 한다: `element.shadowRoot.querySelector('c-child').shadowRoot.querySelector(...)`.
- 요소가 없으면 `querySelector`는 `null`을 반환하므로 조건부 렌더링(`if:true`)의 부재도 `toBeNull()`로 검증할 수 있다.

---

## 4. 비동기 대기 — microtask flush로 재렌더 기다리기

`appendChild` 후 프로퍼티를 바꾸거나 mock 데이터를 주입하면, LWC는 DOM을 **즉시** 갱신하지 않고 **microtask 큐**에 재렌더를 예약한다. 따라서 값을 검증하기 전에 microtask를 flush해서 렌더가 반영될 시간을 줘야 한다.

```javascript
it('프로퍼티 변경이 DOM에 반영된다', () => {
    element.message = 'Updated';
    // ❌ 아직 이전 값 — 재렌더가 아직 일어나지 않음
    // 재렌더가 처리될 때까지 microtask를 flush하고 검증
    return Promise.resolve().then(() => {
        const el = element.shadowRoot.querySelector('.msg');
        expect(el.textContent).toBe('Updated');
    });
});
```

async/await로 더 읽기 쉽게 쓴다.

```javascript
it('프로퍼티 변경이 DOM에 반영된다', async () => {
    element.message = 'Updated';
    await Promise.resolve();   // microtask 한 번 flush = 재렌더 반영

    const el = element.shadowRoot.querySelector('.msg');
    expect(el.textContent).toBe('Updated');
});
```

왜 필요한가: LWC의 반응성 시스템은 트래킹된 값이 바뀌면 재렌더를 **microtask**로 스케줄한다. 테스트 코드는 동기적으로 이어 실행되므로, `await Promise.resolve()`로 현재 microtask 체인을 소진해야 예약된 재렌더가 실행된 뒤의 DOM을 볼 수 있다.

**flushPromises 유틸** — Promise 체인이 여러 단계이거나(예: fetch/Apex 이후 다시 렌더) 매크로태스크까지 걸쳐 있을 때는 `setTimeout(0)` 기반 헬퍼로 한 번에 flush한다.

```javascript
// 커스텀 유틸: microtask + 매크로태스크(0ms) 큐를 함께 비운다
function flushPromises() {
    return new Promise((resolve) => setTimeout(resolve, 0));
}

it('Apex 해결 후 목록을 렌더한다', async () => {
    getContactList.mockResolvedValue([{ Id: '1', Name: 'Amy' }]);
    element.shadowRoot.querySelector('lightning-button')
        .dispatchEvent(new CustomEvent('click'));

    await flushPromises();   // Promise 해결 + 뒤이은 재렌더까지 대기

    const items = element.shadowRoot.querySelectorAll('.contact-item');
    expect(items.length).toBe(1);
});
```

---

## 5. 이벤트 발생·핸들러 검증

사용자 상호작용은 대상 요소에 `dispatchEvent(new CustomEvent(...))`로 시뮬레이션하고, 컴포넌트가 발행하는 이벤트는 `jest.fn()` 리스너로 잡아 검증한다.

```javascript
it('버튼 클릭 시 select 이벤트를 detail과 함께 발행한다', async () => {
    // 1) 컴포넌트가 발행하는 이벤트를 잡을 mock 리스너
    const handler = jest.fn();
    element.addEventListener('select', handler);

    // 2) 내부 버튼에 click 이벤트를 디스패치해 상호작용 시뮬레이션
    const button = element.shadowRoot.querySelector('lightning-button');
    button.dispatchEvent(new CustomEvent('click'));

    await Promise.resolve();   // 핸들러 내 재렌더가 있으면 대기

    // 3) 발행 횟수 + payload 검증
    expect(handler).toHaveBeenCalledTimes(1);
    expect(handler.mock.calls[0][0].detail.id).toBe('001xx');
});
```

- `handler.mock.calls[0][0]`은 핸들러의 첫 호출에 전달된 첫 인자(= 이벤트 객체)다. `.detail`로 `CustomEvent`의 payload를 확인한다.
- 입력 변경은 `input.dispatchEvent(new CustomEvent('change', { detail: { value: 'x' } }))`처럼 `detail`을 실어 시뮬레이션한다.

---

## 마운트·검증 흐름 요약

```
createElement('c-foo', { is: Foo })   // 인스턴스
      ↓  @api 프로퍼티 설정 (첫 렌더 반영)
document.body.appendChild(element)    // connectedCallback + 첫 렌더
      ↓  이벤트/프로퍼티 변경 → 재렌더는 microtask에 예약
await Promise.resolve() / flushPromises()   // 재렌더·Promise flush
      ↓
element.shadowRoot.querySelector(...) // DOM 검증
      ↓
afterEach: body 비우기 + jest.clearAllMocks()  // 정리
```

---

## 관련 노트

- [[Jest 테스트 패턴]] — @wire mock · DOM 이벤트 · @salesforce/apex mock 3대 패턴
- [[sfdx-lwc-jest 설정·실행]] — 러너 설치·jest.config·`sfdx-lwc-jest` 실행
- [[LWC MOC]] — LWC 섹션 전체 목차
