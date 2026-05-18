---
tags: [lwc, testing, jest, wire-mock, dom-event, apex-mock]
source: external-knowledge
created: 2026-05-18
aliases: [Jest 테스트, LWC Jest, wire mock, DOM 이벤트 테스트, apex mock, @salesforce/apex mock]
---

# LWC Jest 테스트 패턴

> [!warning] 이 노트는 외부 지식 기반으로 작성되었으며 공식 소스와 대조되지 않았습니다.

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

`@wire`로 데이터를 가져오는 컴포넌트를 테스트할 때 `@salesforce/wire-service-jest-util`의 `registerTestWireAdapter` 또는 `registerApexTestWireAdapter`를 사용한다.

```javascript
// myComponent/__tests__/myComponent.test.js
import { createElement } from 'lwc';
import MyComponent from 'c/myComponent';
import { registerTestWireAdapter } from '@salesforce/sfdx-lwc-jest';
import { getRecord } from 'lightning/uiRecordApi';

// getRecord 어댑터를 테스트 어댑터로 등록
const mockGetRecord = registerTestWireAdapter(getRecord);

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
        // mock 데이터 주입 — data 또는 error 선택
        mockGetRecord.emit({
            fields: {
                Name: { value: 'Test Account' }
            }
        });

        // DOM 업데이트 대기
        await Promise.resolve();

        const nameEl = element.shadowRoot.querySelector('.account-name');
        expect(nameEl.textContent).toBe('Test Account');
    });

    it('에러 발생 시 에러 패널을 표시한다', async () => {
        mockGetRecord.emitError({ status: 404, body: 'Not found' });
        await Promise.resolve();

        const errorEl = element.shadowRoot.querySelector('.error-panel');
        expect(errorEl).not.toBeNull();
    });
});
```

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
| 등록 방법 | `registerTestWireAdapter(adapter)` | `jest.mock('@salesforce/apex/...')` |
| 데이터 주입 | `mockAdapter.emit(data)` | `mockFn.mockResolvedValue(data)` |
| 에러 주입 | `mockAdapter.emitError(error)` | `mockFn.mockRejectedValue(error)` |
| 사용 시기 | `@wire` 데코레이터로 선언된 데이터 로드 | 버튼 클릭 등 이벤트로 직접 호출하는 Apex |

---

## 자주 쓰는 Jest 유틸리티

```javascript
// DOM 업데이트 대기 (flushPromises 헬퍼 대신 Promise.resolve() 체인 사용)
await Promise.resolve();

// 비동기 Apex 호출 이후 2회 대기 필요할 때 (렌더링 사이클)
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

- [[Wire 패턴]] — @wire 어댑터 사용법 (컴포넌트 구현)
- [[Imperative 호출 패턴]] — async/await Apex 직접 호출 (컴포넌트 구현)
- [[테스트 전략]] — Apex 테스트 전략 (비교 참조)
