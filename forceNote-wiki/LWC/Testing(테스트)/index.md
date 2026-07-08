---
tags: [index, lwc, testing]
created: 2026-05-17
---

# Testing(테스트) — 로컬 인덱스

> LWC Jest 테스트 패턴 — @wire mock, DOM 이벤트, @salesforce/apex mock

**상위:** [[LWC MOC]] → [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Jest 테스트 패턴]] | @wire 어댑터 mock(createTestWireAdapter·createApexTestWireAdapter·createLdsTestWireAdapter), DOM 이벤트 검증, @salesforce/apex mock 3종 패턴 | #pattern |
| [[sfdx-lwc-jest 설정·실행]] | `@salesforce/sfdx-lwc-jest` 설치·jest.config 프리셋·`__tests__` 규칙·npm 스크립트 실행 | #reference |
| [[컴포넌트 마운트·DOM 쿼리 레퍼런스]] | `createElement`→`appendChild` 마운트·`shadowRoot` DOM 쿼리·microtask flush·afterEach teardown | #reference |
| [[Jest 스냅샷·커버리지]] | `toMatchSnapshot` 렌더 회귀 검증·`__snapshots__`·`--coverage`/coverageThreshold 커버리지 측정·강제 | #pattern |

---

## 빠른 선택

- @wire 어댑터 테스트? → [[Jest 테스트 패턴]] → 패턴 1: @wire 어댑터 Mock
- 버튼 클릭·이벤트 검증? → [[Jest 테스트 패턴]] → 패턴 2: DOM 이벤트 테스트
- Apex 메서드 모킹? → [[Jest 테스트 패턴]] → 패턴 3: @salesforce/apex Mock
- Jest 설치·jest.config·npm 스크립트 설정? → [[sfdx-lwc-jest 설정·실행]]
- createElement로 마운트·shadowRoot 쿼리·재렌더 대기? → [[컴포넌트 마운트·DOM 쿼리 레퍼런스]]
- 스냅샷 회귀·코드 커버리지 측정? → [[Jest 스냅샷·커버리지]]

---

## 관련 폴더

Apex 테스트 → [[Apex/Testing(테스트)/index|Apex Testing(테스트)]]
