---
tags: [agent-skill, sf-skills, experience, lwc, jest, slds2]
source: forcedotcom/sf-skills (skills/experience-lwc-generate/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [experience-lwc-generate, LWC 생성, Lightning Web Component PICKLES, wire service apex graphql lms, 165-point scoring, SLDS2 dark mode jest]
---

# experience-lwc-generate — LWC 생성 (PICKLES 방법론·165점 채점)

> Lightning Web Component 번들·wire 패턴·Apex/GraphQL 통합·SLDS 2 스타일링·접근성·성능·Jest 단위 테스트 작업에 쓰는 스킬. PICKLES mindset과 8개 카테고리 165점 채점 루브릭을 적용한다.

## 목적과 활성화 조건

**활성화(TRIGGER):** 사용자가 LWC 컴포넌트를 생성/편집, `lwc/**/*.js`·`.html`·`.css`·`.js-meta.xml` 파일을 건드림, 또는 wire service/SLDS/Jest LWC 테스트에 대해 질문할 때.

**비활성화(DO NOT TRIGGER):** Apex 클래스(→ platform-apex-generate), Aura 컴포넌트, Visualforce.

이 스킬이 소유하는 작업: `lwc/**/*.js`·`.html`·`.css`·`.js-meta.xml`, 컴포넌트 스캐폴딩·번들 설계, wire service·Apex 통합·GraphQL 통합, SLDS 2·dark mode·접근성, LWC Jest 단위 테스트.

**위임:** Apex 컨트롤러/비즈니스 로직 우선 → [[platform-apex-generate]]; LWC screen 컴포넌트가 아닌 Flow XML → automation-flow-generate; 메타데이터 배포 → [[platform-metadata-deploy]].

## 먼저 수집할 컨텍스트

- 컴포넌트 목적과 target surface
- 데이터 소스: LDS, Apex, GraphQL, LMS, 또는 Apex 경유 외부 시스템
- 테스트 필요 여부
- 컴포넌트가 Flow, App Builder, Experience Cloud, dashboard 컨텍스트에서 실행되어야 하는지
- 접근성·스타일링 기대치

## 워크플로 / 단계

### 1. 올바른 아키텍처 선택 — PICKLES mindset

- **P**rototype
- **I**ntegrate the right data source
- **C**ompose component boundaries
- **K**(define) interaction model
- use platform **L**ibraries
- optimize **E**xecution
- enforce **S**ecurity

### 2. 올바른 데이터 접근 패턴 선택

| Need | Default pattern |
|---|---|
| single-record UI | LDS / `getRecord` |
| simple CRUD form | base record form components |
| complex server query | Apex `@AuraEnabled(cacheable=true)` |
| related graph data | GraphQL wire adapter |
| cross-DOM communication | Lightning Message Service |

### 3. 유용할 때 asset에서 시작

basic component 번들, datatable, modal 패턴, Flow screen 컴포넌트, GraphQL 컴포넌트, LMS message channel, Jest test, TypeScript 컴포넌트 등 제공 asset 사용.

### 4. frontend 품질 검증

접근성, SLDS 2/dark mode 준수, event contract, 성능/rerender 안전성, 필요 시 Jest coverage 확인.

### 5. 백엔드·배포 작업 hand off

[[platform-apex-generate]](컨트롤러/서비스), [[platform-metadata-deploy]](배포), [[platform-apex-test-run]](Apex측 테스트 루프만, Jest 아님).

### Output Format

마칠 때 순서: 1) 생성/수정 컴포넌트 2) 선택한 데이터 접근 패턴 3) 변경 파일 4) 접근성/스타일링/테스트 노트 5) 다음 구현/배포 단계.

```text
LWC work: <summary>
Pattern: <wire / apex / graphql / lms / flow-screen>
Files: <paths>
Quality: <a11y, SLDS2, dark mode, Jest>
Next step: <deploy, add controller, or run tests>
```

### Local Development Server

`scripts/local-dev-preview.sh`의 명령으로 배포 없이 hot reload 로컬 프리뷰(컴포넌트/앱/Experience Cloud site). Local Dev 명령은 첫 실행 시 just-in-time 설치되며, 브라우저에 live preview를 여는 long-running 프로세스다. `.js`·`.html`·`.css` 변경은 즉시 auto-reload. 데이터·Apex callout에 active org 연결 필요.

## 핵심 규칙·가드레일

- 컨트롤 재발명 대신 platform base component 선호.
- reactive read-only는 `@wire`, 명시적 action·DML 경로는 imperative 호출.
- 접근 불가(inaccessible) 커스텀 UI 도입 금지.
- 하드코딩 색상 금지 — SLDS 2 호환 styling hook/variable 사용.
- `renderedCallback()`에서 rerender 루프 회피.
- 컴포넌트 통신 패턴은 명시적·최소로.

## 번들 파일

### references — 시작점
| 파일 | 내용 |
|------|------|
| `references/component-patterns.md` | 컴포넌트 아키텍처 패턴·번들 설계 |
| `references/slds-design-guide.md` | SLDS 2 스타일링, dark mode, CSS hook |
| `references/lwc-best-practices.md` | high-signal 규칙·anti-pattern |
| `references/scoring-and-testing.md` | 8개 카테고리 165점 채점 루브릭 |
| `references/jest-testing.md` | Jest 단위 테스트 패턴·async 렌더링 helper |
| `references/slds-blueprints.json` | machine-readable SLDS 컴포넌트 blueprint |
| `references/cli-commands.md` | LWC 개발용 SF CLI 명령 |

### references — 접근성/성능/state/통합/고급
`accessibility-guide.md`(WCAG·ARIA·키보드), `performance-guide.md`(lazy loading·debounce·rerender 안전), `state-management.md`(reactive state·LMS), `template-anti-patterns.md`, `lms-guide.md`, `flow-integration-guide.md`, `advanced-features.md`(Spring '26: TypeScript·`lwc:on`·GraphQL mutation), `async-notification-patterns.md`, `triangle-pattern.md`(parent-child-sibling 통신).

### assets — 컴포넌트 템플릿
`basic-component`, `datatable-component`, `flow-screen-component`, `form-component`, `graphql-component`, `jest-test`(`componentName.test.js.example` — 복사 후 rename, `.example` 제거), `message-channel`(`lmsPublisher.js`/`lmsSubscriber.js`/`RecordSelected.messageChannel-meta.xml`), `modal-component`, `record-picker`, `state-store/store.js`, `typescript-component`(Spring '26), `workspace-api`, `apex-controller/LwcController.cls`(`@AuraEnabled(cacheable=true)` 패턴).

### scripts / hooks
| 파일 | 내용 |
|------|------|
| `scripts/local-dev-preview.sh` | component·app·site 프리뷰용 로컬 dev 서버 명령 |
| `hooks/scripts/` | LWC LSP 검증·post-tool 검증·SLDS linter(`validate_slds.py`·`slds_data/`·`template_validator.py`) |

### Score Guide

| Score | Meaning |
|---|---|
| 150+ | production-ready LWC 번들 |
| 125–149 | minor polish 남은 강한 컴포넌트 |
| 100–124 | 기능하지만 review 권장 |
| < 100 | significant improvement 필요 |

## 관련 노트
- [[experience-ui-bundle-salesforce-data-access]]
- [[platform-apex-generate]]
- [[platform-metadata-deploy]]
- [[platform-flexipage-generate]]
