---
tags: [lwc, testing, jest, sfdx-lwc-jest, jest-config, npm-scripts]
source: https://github.com/salesforce/sfdx-lwc-jest, https://developer.salesforce.com/docs/platform/lwc/guide/unit-testing-using-jest-installation.html
created: 2026-07-08
aliases: [sfdx-lwc-jest, sfdx lwc jest setup, jest config lwc, test:unit, lwc test setup, npm test lwc, jest moduleNameMapper]
---

# sfdx-lwc-jest 설정·실행

> LWC 컴포넌트를 Jest로 단위 테스트하기 위한 `@salesforce/sfdx-lwc-jest` 설치·`jest.config.js` 프리셋·`__tests__` 폴더 규칙·npm 스크립트 실행 절차.

---

## 1. 개요

`@salesforce/sfdx-lwc-jest`는 Salesforce가 공식 제공하는 Jest 러너로, LWC 모듈(`@salesforce/apex`, `lightning/*`, `@salesforce/schema` 등 플랫폼 모듈)을 로컬 Node 환경에서 stub/mock으로 해석해 브라우저·org 없이 컴포넌트를 테스트하게 해준다. Jest를 감싼 preset이므로 표준 Jest API(`describe`/`it`/`expect`/`jest.fn()`)를 그대로 쓴다.

---

## 2. 설치

두 가지 방법이 있다.

```bash
# 방법 A — Salesforce CLI 플러그인으로 프로젝트에 설정 (jest.config.js·scripts 자동 생성)
sf force lightning lwc test setup

# 방법 B — npm 개발 의존성으로 직접 설치
npm install @salesforce/sfdx-lwc-jest --save-dev
```

- 방법 A는 SFDX 프로젝트(`sfdx-project.json` 존재)에서 실행하면 devDependency 추가 + `jest.config.js` + `package.json`의 test 스크립트를 함께 세팅한다.
- 방법 B는 이미 프로젝트가 있거나 스크립트를 수동 구성할 때 쓴다.

### package.json scripts

```json
{
  "scripts": {
    "test:unit": "sfdx-lwc-jest",
    "test:unit:watch": "sfdx-lwc-jest --watch",
    "test:unit:debug": "sfdx-lwc-jest --debug",
    "test:unit:coverage": "sfdx-lwc-jest --coverage"
  }
}
```

| 스크립트 | 동작 |
|---|---|
| `test:unit` | 전체 테스트 1회 실행 |
| `test:unit:watch` | 파일 변경 감지 후 자동 재실행 (개발 중) |
| `test:unit:debug` | Node inspector 연결 대기 (`chrome://inspect` 등으로 디버깅) |
| `test:unit:coverage` | 커버리지 리포트 생성 |

---

## 3. jest.config.js — preset

프로젝트 루트에 두며 `@salesforce/sfdx-lwc-jest/config` preset을 상속한다.

```js
const { jestConfig } = require('@salesforce/sfdx-lwc-jest/config');

module.exports = {
    ...jestConfig,
    moduleNameMapper: {
        // 커스텀 stub 매핑을 여기에 추가
        '^lightning/navigation$': '<rootDir>/force-app/test/jest-mocks/lightning/navigation',
    },
    setupFilesAfterEach: ['<rootDir>/jest.setup.js'],
};
```

- preset(`jestConfig`)이 기본 `moduleNameMapper`를 이미 제공한다 — `@salesforce/apex`, `lightning/*`(base component·서비스 모듈), `@salesforce/schema/*` 등을 sfdx-lwc-jest 내장 stub으로 자동 매핑한다.
- 스프레드(`...jestConfig`) 후 `moduleNameMapper`를 직접 지정하면 **preset 매핑을 덮어쓴다**. 커스텀 매핑만 추가할 때는 preset의 매핑과 병합하도록 주의한다(내장 stub이 없는 `lightning/navigation` 등은 직접 mock 파일을 만들어 매핑).

### moduleNameMapper가 해석하는 대표 모듈

| import 경로 | 매핑 대상 |
|---|---|
| `@salesforce/apex` | Apex 메서드 mock 유틸(`createApexTestWireAdapter` 등)이 담긴 stub |
| `lightning/*` | base Lightning 컴포넌트·서비스(`lightning/uiRecordApi`, `lightning/platformShowToastEvent` 등) stub |
| `@salesforce/schema` | 오브젝트/필드 스키마 참조 stub |

---

## 4. 폴더·파일 규칙

테스트는 컴포넌트 번들 안 `__tests__` 폴더에 두고 파일명은 `*.test.js`로 끝낸다. sfdx-lwc-jest는 이 패턴을 자동으로 수집한다.

```
force-app/main/default/lwc/
└── myComponent/
    ├── myComponent.js
    ├── myComponent.html
    ├── myComponent.js-meta.xml
    └── __tests__/
        └── myComponent.test.js
```

---

## 5. 실행

```bash
# 전체 실행
npm run test:unit

# watch 모드 (개발 중 변경 자동 재실행)
npm run test:unit:watch

# debug 모드 (inspector 연결)
npm run test:unit:debug

# 특정 파일/테스트만 실행 — '--' 뒤 인자는 Jest로 전달
npm run test:unit -- myComponent
npm run test:unit -- --testNamePattern="renders correctly"
```

- `npm run <script> -- <args>`에서 `--` 뒤 인자는 그대로 Jest CLI로 전달된다. 경로 조각(`myComponent`)은 해당 문자열을 포함하는 테스트 파일만, `--testNamePattern`(축약 `-t`)은 `describe`/`it` 이름으로 필터한다.
- watch 모드 실행 중에는 인터랙티브 프롬프트로 `p`(파일명 필터)·`t`(테스트명 필터)·`a`(전체) 등을 눌러 좁힐 수 있다.

---

## 관련 노트
- [[Jest 테스트 패턴]] — 설치·실행 후 실제로 작성하는 3대 테스트 패턴(@wire mock·DOM 이벤트·@salesforce/apex mock)
- [[컴포넌트 마운트·DOM 쿼리 레퍼런스]] — `createElement`/`appendChild` 마운트와 `shadowRoot.querySelector` DOM 쿼리 상세
- [[LWC MOC]] — LWC 섹션 전체 목차
