---
tags: [lwc, testing, jest, snapshot, coverage, ci, code-coverage]
source: https://github.com/salesforce/sfdx-lwc-jest, https://developer.salesforce.com/docs/platform/lwc/guide/unit-testing-using-jest.html, https://jestjs.io/docs/snapshot-testing
created: 2026-07-08
aliases: [Jest 스냅샷, snapshot testing, toMatchSnapshot, __snapshots__, updateSnapshot, LWC 커버리지, jest coverage, collectCoverageFrom, coverageThreshold, LWC code coverage]
---

# LWC Jest 스냅샷·커버리지

> LWC 단위 테스트에서 렌더 결과를 스냅샷으로 회귀 검증(`toMatchSnapshot`)하고, `sfdx-lwc-jest --coverage`로 코드 커버리지를 측정·강제하는 절차. Apex 배포 커버리지와는 별개다.

---

## 1. 스냅샷 테스트 (Snapshot Testing)

스냅샷 테스트는 컴포넌트가 렌더한 **DOM 구조(마크업)** 를 파일로 저장해 두고, 이후 테스트 실행 때마다 렌더 결과가 저장본과 **바뀌지 않았는지** 비교하는 회귀(regression) 검사다. 값 하나하나를 `expect().toBe()`로 단언하는 대신 "전체 출력이 그대로인가"를 한 번에 검증한다.

### 기본 사용 — `toMatchSnapshot()`

```javascript
// __tests__/myComponent.test.js — 구조 예시 (실제 컴포넌트명에 맞춰 수정)
import { createElement } from 'lwc';
import MyComponent from 'c/myComponent';

describe('c-my-component', () => {
    afterEach(() => {
        // DOM 정리 — 각 테스트가 깨끗한 상태에서 시작
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('renders the default markup', () => {
        const element = createElement('c-my-component', { is: MyComponent });
        document.body.appendChild(element);

        // 렌더된 element 트리 전체를 스냅샷과 비교
        expect(element).toMatchSnapshot();
    });
});
```

- **최초 실행**: 스냅샷 파일이 없으므로 Jest가 현재 렌더 결과를 저장하고 통과시킨다.
- **이후 실행**: 저장본과 다르면 diff를 출력하며 **실패**시킨다.

### `__snapshots__` 폴더

`toMatchSnapshot()`이 처음 실행되면 테스트 파일과 같은 위치에 `__snapshots__/` 폴더와 `<테스트파일명>.snap` 파일이 생성된다.

```
force-app/main/default/lwc/myComponent/
├── myComponent.js
├── myComponent.html
└── __tests__/
    ├── myComponent.test.js
    └── __snapshots__/
        └── myComponent.test.js.snap   ← 자동 생성·커밋 대상
```

- `.snap` 파일은 **소스 컨트롤에 커밋**한다. 팀 전체가 같은 기준 스냅샷을 공유해야 회귀를 잡을 수 있다.
- 한 `.snap` 파일 안에 `exports["describe명 it명 1"]` 형태로 테스트별 스냅샷이 나열된다(실제 파일은 키를 백틱으로 감싼다).

### 인라인 스냅샷 — `toMatchInlineSnapshot()`

별도 `.snap` 파일 대신 스냅샷을 테스트 코드 안에 직접 기록한다. 작은 출력에 유용하다.

```javascript
expect(element.shadowRoot.querySelector('h1').textContent)
    .toMatchInlineSnapshot(`"Hello World"`); // 첫 실행 시 Jest가 백틱 안을 자동 채움
```

### 스냅샷 갱신 — `--updateSnapshot` / `-u`

의도적으로 마크업을 바꿨다면(정당한 변경) 저장본을 새 결과로 덮어써야 한다.

```bash
# 실패한 스냅샷을 전부 현재 렌더 결과로 갱신
npm run test:unit -- --updateSnapshot
# 축약 플래그
npm run test:unit -- -u
```

> `--`는 npm이 뒤 인자를 스크립트(sfdx-lwc-jest → jest)로 그대로 전달하게 한다.

갱신 후에는 반드시 `.snap`의 **diff를 검토**한다. 변경이 의도한 대로인지 사람이 확인하지 않으면 스냅샷 테스트는 회귀 방어력을 잃는다.

### 언제 유용한가 / 주의 (과용 금지)

| 상황 | 판단 |
|---|---|
| 순수 프레젠테이션 컴포넌트(입력 → 마크업)의 렌더 안정성 확인 | ✅ 유용 |
| 리팩터링 중 "출력이 안 바뀌었음"을 빠르게 보장 | ✅ 유용 |
| 자잘한 값 단언을 일일이 쓰기 번거로운 큰 트리 | ✅ 유용 |
| 비즈니스 로직·이벤트 핸들러·조건 분기 검증 | ❌ 명시적 단언(`toBe`/`dispatchEvent`)이 더 명확 |
| 자주 바뀌는 UI — 매번 `-u`로 갱신하게 됨 | ❌ 스냅샷이 무의미해짐(rubber-stamping) |

주의점:
- **거대 스냅샷 금지**: 컴포넌트 전체를 통째로 스냅샷 찍으면 diff가 커서 리뷰가 무력화된다. 관심 있는 하위 요소만 `querySelector` 후 스냅샷하는 편이 낫다.
- **무비판 갱신 금지**: 실패를 반사적으로 `-u`로 덮으면 진짜 회귀를 놓친다. diff를 읽고 통과시킨다.
- **동적 값 처리**: 날짜·랜덤 ID 등은 매 실행 달라져 스냅샷이 불안정해진다. 렌더 전에 mock으로 고정한다.

---

## 2. 코드 커버리지 (Code Coverage)

### 측정 실행 — `--coverage`

```bash
# 모든 테스트를 돌리며 커버리지 리포트 생성
npm run test:unit -- --coverage

# 직접 러너 호출 (package.json 스크립트가 sfdx-lwc-jest일 때)
sfdx-lwc-jest --coverage
```

실행하면 터미널에 파일별 표가 출력된다.

```
------------------|---------|----------|---------|---------|-------------------
File              | % Stmts | % Branch | % Funcs | % Lines | Uncovered Line #s
------------------|---------|----------|---------|---------|-------------------
All files         |   87.5  |   75.0   |   90.0  |   88.2  |
 myComponent.js   |   87.5  |   75.0   |   90.0  |   88.2  | 42,58
------------------|---------|----------|---------|---------|-------------------
```

| 열 | 의미 |
|---|---|
| **% Stmts** | 실행된 구문(statement) 비율 |
| **% Branch** | 실행된 분기(if/else·삼항·`&&`) 비율 |
| **% Funcs** | 호출된 함수 비율 |
| **% Lines** | 실행된 라인 비율 |
| **Uncovered Line #s** | 한 번도 실행되지 않은 라인 번호 — 여기부터 테스트를 보강한다 |

`coverage/` 폴더에 HTML 리포트(`coverage/lcov-report/index.html`)와 `lcov.info`(CI 도구용)도 함께 생성된다. HTML을 열면 커버되지 않은 줄이 색으로 하이라이트된다.

### `jest.config.js` 설정 — `collectCoverageFrom` · `coverageThreshold`

`sfdx-lwc-jest`는 Jest preset이므로 표준 Jest 커버리지 옵션을 `jest.config.js`에 얹을 수 있다.

```javascript
// jest.config.js — 구조 예시 (실제 프로젝트 경로에 맞춰 조정)
const { jestConfig } = require('@salesforce/sfdx-lwc-jest/config');

module.exports = {
    ...jestConfig,

    // 커버리지 집계 대상 파일 (테스트가 없어도 0%로 포함되게 함)
    collectCoverageFrom: [
        'force-app/main/default/lwc/**/*.js',
        '!**/__tests__/**',        // 테스트 파일 제외
        '!**/*.test.js'
    ],

    // 최소 커버리지 강제 — 미달 시 명령이 실패(exit 1)
    coverageThreshold: {
        global: {
            statements: 80,
            branches: 75,
            functions: 80,
            lines: 80
        }
    }
};
```

- **`collectCoverageFrom`**: 명시하면 테스트가 아직 없는 파일도 0%로 리포트에 나타난다(사각지대 방지). 지정하지 않으면 실행된 파일만 집계된다.
- **`coverageThreshold`**: 임계값 미달이면 명령이 **exit 코드 1**로 실패한다 → CI에서 커버리지 게이트로 작동. `global` 외에 특정 경로(glob)별 임계값도 지정 가능하다.

### LWC 커버리지 vs Apex 배포 커버리지 — 반드시 구분

| 구분 | LWC Jest 커버리지 | Apex 배포 커버리지 |
|---|---|---|
| 측정 대상 | LWC JavaScript(`.js`) | Apex 클래스·트리거 |
| 실행 위치 | 로컬 Node(브라우저·org 불필요) | Salesforce 서버(테스트 실행) |
| 도구 | `sfdx-lwc-jest --coverage` / Jest | `sf apex run test` / 배포 시 자동 |
| 배포 게이트 | **없음** — 프로덕션 배포에 LWC 커버리지 요건 없음 | **있음** — 프로덕션 배포는 조직 전체 **75%** Apex 커버리지 필요 |
| 강제 방법 | `coverageThreshold`(팀 자율 기준) | 플랫폼이 강제(75% 미달 시 배포 거부) |

> 핵심: **LWC Jest 커버리지는 플랫폼이 강제하는 75% 규칙과 무관하다.** 그 75%는 Apex에만 적용된다. LWC 커버리지 임계값은 팀이 `coverageThreshold`로 스스로 정하는 품질 기준이며, 채우지 못해도 org 배포는 막히지 않는다.

---

## 3. CI 통합

CI 파이프라인에서는 대화형 watch가 아니라 1회성 실행(`--` 뒤에 `sfdx-lwc-jest`가 이해하는 플래그)을 쓴다.

```bash
# CI 표준 — 1회 실행 + 커버리지, 임계 미달 시 exit 1로 빌드 실패
npm ci
npm run test:unit -- --coverage

# CI 환경 최적화 플래그 (Jest passthrough)
sfdx-lwc-jest --coverage --ci --runInBand
```

- `--ci`: CI 모드. 스냅샷이 없을 때 **새로 쓰지 않고 실패**시킨다 → 커밋 안 된 스냅샷을 CI가 잡아낸다.
- `--runInBand`: 워커를 병렬로 띄우지 않고 직렬 실행 — 리소스가 제한된 CI 러너에서 안정적.
- `coverageThreshold`가 설정돼 있으면 미달 시 자동으로 빌드가 실패하므로 별도 게이트 스크립트가 필요 없다.

GitHub Actions 예시 스텝:

```yaml
# 구조 예시 — 실제 워크플로 YAML에 맞춰 조정
- name: Run LWC Jest tests
  run: npm run test:unit -- --coverage --ci --runInBand
```

`lcov.info`를 Codecov·Coveralls 같은 서비스에 업로드하면 PR별 커버리지 추이를 추적할 수 있다.

---

## 관련 노트
- [[Jest 테스트 패턴]]
- [[sfdx-lwc-jest 설정·실행]]
- [[LWC MOC]]
