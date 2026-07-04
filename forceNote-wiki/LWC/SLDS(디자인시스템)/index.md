---
tags: [index, slds, slds2, design-system, reference]
created: 2026-06-13
---

# SLDS(디자인시스템) — 로컬 인덱스

> Salesforce Lightning Design System 2 문서 허브 — 유틸리티 클래스·디자인 패턴·접근성·모범사례·스타일링 훅·블루프린트. **SLDS v2.30.4 기준, 출처 lightningdesignsystem.com (Tier 2).**

**상위:** [[LWC MOC]] → [[00 Home]]
**개념·LWC 적용:** [[SLDS LWC 디자인 시스템]]

---

## 레퍼런스

| 파일 | 한 줄 요약 |
|---|---|
| [[SLDS 유틸리티 클래스 레퍼런스]] | 마진·패딩·그리드·타이포 등 24개 카테고리 유틸리티 클래스 전수 + HTML 예제 |
| [[SLDS 스타일링 훅]] | `--slds-g-*`/`--slds-c-*` CSS 커스텀 속성 — 테마·다크모드 |
| [[SLDS 접근성]] | 색 대비·포커스·키보드·모바일·글로벌 표준 9원칙 |
| [[SLDS 모범 사례]] | SLDS 1 vs 2, 3단계 커스터마이즈 모델 |
| [[SLDS 개발 도구]] | Figma Kit, SLDS Linter/Validator 등 |
| [[SLDS 블루프린트 카탈로그]] | CSS 전용 블루프린트 30종 인덱스 |
| [[design-system-react — SLDS React 컴포넌트 라이브러리]] | design-system-react(DSR) — React on Salesforce UI 번들용 SLDS 컴포넌트, IconSettings/iconPath 아이콘 경로 3방식, blueprint vs shadcn+Tailwind, optimizeDeps CJS pre-bundle |

## 디자인 패턴 (SLDS 2)

| 파일 | 카테고리 |
|---|---|
| [[SLDS 패턴 - Agentic Experiences]] | SLDS 2 디자인 패턴 |
| [[SLDS 패턴 - Builder]] | SLDS 2 디자인 패턴 |
| [[SLDS 패턴 - Charts]] | SLDS 2 디자인 패턴 |
| [[SLDS 패턴 - Conversation Design]] | SLDS 2 디자인 패턴 |
| [[SLDS 패턴 - Currency]] | SLDS 2 디자인 패턴 |
| [[SLDS 패턴 - Data Entry]] | SLDS 2 디자인 패턴 |
| [[SLDS 패턴 - Displaying Data]] | SLDS 2 디자인 패턴 |
| [[SLDS 패턴 - In App Feedback]] | SLDS 2 디자인 패턴 |
| [[SLDS 패턴 - Interface Feedback]] | SLDS 2 디자인 패턴 |
| [[SLDS 패턴 - Layout]] | SLDS 2 디자인 패턴 |
| [[SLDS 패턴 - Loading]] | SLDS 2 디자인 패턴 |
| [[SLDS 패턴 - Localization]] | SLDS 2 디자인 패턴 |
| [[SLDS 패턴 - Markup and Style]] | SLDS 2 디자인 패턴 |
| [[SLDS 패턴 - Messaging UI]] | SLDS 2 디자인 패턴 |
| [[SLDS 패턴 - Metric Display]] | SLDS 2 디자인 패턴 |
| [[SLDS 패턴 - Navigation]] | SLDS 2 디자인 패턴 |
| [[SLDS 패턴 - Notifications]] | SLDS 2 디자인 패턴 |
| [[SLDS 패턴 - Prompt Design Guide]] | SLDS 2 디자인 패턴 |
| [[SLDS 패턴 - Rules, Filters, and Logic]] | SLDS 2 디자인 패턴 |
| [[SLDS 패턴 - Search]] | SLDS 2 디자인 패턴 |
| [[SLDS 패턴 - User Engagement]] | SLDS 2 디자인 패턴 |

## SLDS 2 Starter Kit (로컬 프로토타이핑)

> design-system-2-starter-kit (salesforce-ux GitHub, Tier 2) — LWC + Vite 기반 로컬 프로토타이핑 스캐폴드. 디자인 시스템 레퍼런스(위)와 달리 툴링/scaffold 클러스터다.

| 파일 | 한 줄 요약 |
|---|---|
| [[SLDS 2 Starter Kit - 개요와 프로젝트 구조]] | 개요·프로젝트 구조·컴포넌트 네임스페이스(shell/page/ui/data)·기술 스택·vite config·엔트리 플로우·컨벤션 (클러스터 허브) |
| [[SLDS 2 Starter Kit - 라우팅과 멀티앱 셸]] | 클라이언트 라우터(router.js)·routes.config.js·apps.config.js·Standard/Console/Builder 앱·ROUTE_COMPONENTS·navPage vs navHighlight·History API SPA |
| [[SLDS 2 Starter Kit - SLDS 1·2 로더와 Shadow DOM]] | slds-loader.js·SLDS 1/2 lazy CSS 로딩·테마 전환·다크모드·synthetic vs native shadow |
| [[SLDS 2 Starter Kit - 아이콘·모달·폼·배포]] | 아이콘 prebuild 코드젠·LightningModal 패턴·Lightning Base Component 폼·GitHub Pages 배포·SLDS agent skills |
| [[SLDS 2 Starter Kit - 셸 UI 컴포넌트]] | 셸 UI 구현 — 글로벌 헤더·글로벌 내비(App Launcher waffle/Console object switcher/Standard tabs)·도킹 패널(shell-panel/ui-panel 4종)·재사용 빌딩블록(pageHeader/homeIntro/builderHeader)·예제 페이지(contacts/contactDetail/builder/home)·contacts fixture |
| [[SLDS 2 Starter Kit - UI 코딩 가이드라인]] | `.builderrules`(Salesforce UI Guidelines) 전수 — UI 코드 작성 5단계 결정 트리(LBC→blueprint→utility→styling hook→hardcoded)·스타일링 훅 시맨틱 사용 규칙·템플릿 배치 |
| [[SLDS 2 Starter Kit - 빌드 설정과 진입 HTML]] | 빌드/런타임 설정(lwc.config.json·lwcRuntimeFlags·게이트 심)·진입 HTML(index.html)·로딩 UX(loading.css reveal-on-ready)·무시 파일(.gitignore/.nvmrc) |
