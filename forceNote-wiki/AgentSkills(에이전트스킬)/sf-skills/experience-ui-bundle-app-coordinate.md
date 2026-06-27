---
tags: [agent-skill, sf-skills, experience, ui-bundle, orchestration, react-app]
source: forcedotcom/sf-skills (skills/experience-ui-bundle-app-coordinate/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [experience-ui-bundle-app-coordinate, UI Bundle 앱 전체 빌드 오케스트레이션, React app end-to-end, build full ui bundle, 의존성 그래프 빌드 순서]
---

# experience-ui-bundle-app-coordinate — UI Bundle 앱 전체 빌드 오케스트레이션

> 자연어 설명으로부터 배포 가능한 Salesforce React UI bundle 앱을 처음부터 끝까지, 전문화된 UI bundle 스킬들을 올바른 의존성 순서로 조율(orchestrate)해 빌드하는 상위 스킬.

## 목적과 활성화 조건

**활성화(MUST):** React 애플리케이션/React app/web application/SPA/frontend application을 build·create·generate하려 할 때 — 프로젝트 파일이 아직 없어도. `uiBundles/*/src/` 또는 `sfdx-project.json`이 있고 새 app/site/page를 처음부터 만들라고 할 때(스타일링 설명이 섞여 있어도). 작업이 둘 이상의 ui-bundle 스킬에 걸칠 때. 앱을 end-to-end로 빌드할 때.

**사용:**
- "React app", "UI bundle", "web app", "full-stack app" 요청
- "build an app" / "create an application" + 비-LWC(React) frontend 함의
- 스캐폴딩·기능·데이터 접근·UI를 모두 갖춘 완전한 UI bundle 산출 (단일 컴포넌트 X)

**사용 안 함:**
- 단일 페이지/컴포넌트 생성 → [[experience-ui-bundle-frontend-generate]]
- 기능만 설치 → [[experience-ui-bundle-features-generate]]
- 데이터 접근만 → `experience-ui-bundle-salesforce-data-access`
- 기존 앱 배포만 → [[experience-ui-bundle-deploy]]
- custom object/metadata 포함 Lightning Experience 앱 → `platform-lightning-app-coordinate`
- 기존 UI bundle 트러블슈팅/디버깅

각 스킬은 자신의 phase 실행 전 **반드시 명시적으로 로드**해야 한다.

## 워크플로 / 단계

### 의존성 그래프 & 빌드 순서 (7 Phase)

```
Phase 1: Scaffolding (Foundation)
  UI Bundle scaffold (sf template generate ui-bundle)
    → Install dependencies (npm install)
    → Bundle metadata (uibundle-meta.xml, ui-bundle.json)
    → CSP Trusted Sites (외부 도메인 필요 시)

Phase 2: Features (Optional)
  src/ 기존 구현 검색 → npm install → feature 검색/describe/install
    → 충돌 해결(two-pass: --on-conflict error, 그다음 --conflict-resolution)
    → __example__ 파일을 대상에 통합 후 삭제

Phase 3: Data Access (Backend Wiring)
  schema 획득(npm run graphql:schema) → entity schema 조회(graphql-search.sh, 최대 2회)
    → query/mutation 생성(검증된 필드명, 모든 record 필드에 @optional)
    → 검증·테스트(npx eslint, mutation 테스트 전 사용자 확인)

Phase 4: UI (Frontend)
  Layout/nav/header/footer(appLayout.tsx) → Pages(routed views) → Components
  (모든 boilerplate·placeholder 교체)

Phase 5: Integrations (Optional)
  Agentforce chat widget / File upload API (독립적, 둘 다면 병렬 가능)

Phase 6: Deployment
  org auth → pre-deploy build(npm install + npm run build) → deploy metadata
    → post-deploy config(permissions/profiles/named credentials/connected apps/custom settings/flow activation)
    → data import(data plan 존재 시) → GraphQL schema fetch + codegen(배포된 org에서 재fetch)
    → final UI bundle build(배포된 schema로 재빌드)

Phase 7: Hosting Target (둘 중 하나 선택)
  7a Experience Site (외부): site properties 해결 → site metadata(Network/CustomSite/DigitalExperience) → deploy
  7b Custom Application (내부): app properties 해결 → CustomApplication metadata
       → .uibundle-meta.xml에 <target>CustomApplication</target> 추가 → deploy
```

### 실행 워크플로

**STEP 1: 요구사항 분석 & 계획** — 자연어 파싱, app 이름·목적 식별, 페이지·네비게이션 구조 추출, 데이터 엔티티·Salesforce 객체 식별, feature 요구(auth/search/file upload/chat) 감지, Experience Site 필요 여부 판단, CSP 등록 대상 외부 도메인 식별. Build Plan과 SKILL LOAD ORDER를 산출한다.

```
SKILL LOAD ORDER:
1. experience-ui-bundle-metadata-generate
2. experience-ui-bundle-features-generate (features 필요 시)
3. experience-ui-bundle-salesforce-data-access (data access 필요 시)
4. experience-ui-bundle-frontend-generate
5a. experience-ui-bundle-agentforce-client-generate (chat 요청 시)
5b. experience-ui-bundle-file-upload-generate (file upload 요청 시)
6. experience-ui-bundle-deploy
7a. experience-ui-bundle-site-generate (Experience Site 요청 — 외부 사용자)
7b. experience-ui-bundle-custom-app-generate (Custom Application 요청 — 내부 사용자)
```

**STEP 2: Phase별 실행** — 각 phase를 순차 실행하고, phase 내 모든 단계를 끝낸 뒤 다음으로. phase마다:

| 단계 | 할 일 | 이유 |
|------|-------|------|
| 1. Load skill | 해당 phase 스킬을 호출(Skill tool 등) | 최신 규칙·패턴·제약·구현 가이드 확보 |
| 2. Execute | 로드한 스킬 워크플로 따라 코드/설정 생성 | 스킬이 올바른 방법 정의 |
| 3. Verify | UI bundle 디렉터리에서 lint·build 실행 | 다음 phase 전 에러 포착 |
| 4. Checkpoint | phase 완료 확인 후 진행 | 다음 phase 의존성 충족 보장 |

**Step 1(스킬 로드)을 절대 건너뛰지 않는다.** 내용을 기억하더라도 스킬은 진화하므로 항상 현재 버전을 로드한다.

**STEP 3: 최종 요약** — 모든 phase 완료 후 완료된 phase, 생성 파일·경로, NEXT STEPS(수동 작업)를 담은 build summary 제시.

### Validation (완료 선언 전)

```
[ ] Scaffold exists — UI bundle 디렉터리 + 유효한 meta XML + ui-bundle.json
[ ] Dependencies installed — node_modules/ 존재, package.json에 예상 패키지
[ ] Build passes — npm run build로 dist/ 생성, 에러 없음
[ ] Lint passes — npx eslint src/ 에러 0
[ ] No boilerplate — 모든 placeholder/기본 title/template 콘텐츠 교체됨
[ ] Navigation works — appLayout.tsx에 생성 페이지와 일치하는 실제 nav item
[ ] Data layer wired — 컴포넌트가 @salesforce/sdk-data 사용(data access phase 실행 시)
[ ] CSP registered — 모든 외부 도메인에 CSP Trusted Site metadata(해당 시)
```

## 핵심 규칙·가드레일

- **항상 Phase 순서 준수:** features 설치 전 UI 빌드 금지, build 전 deploy 금지. 의존성은 엄격(strict).
- **모든 boilerplate 교체:** "React App" title, "Vite + React" placeholder, 기본 콘텐츠를 실제 앱별 텍스트·브랜딩으로.
- **Design with Intent:** [[experience-ui-bundle-frontend-generate]]의 design thinking·aesthetics 가이드 준수. 모든 앱은 명확한 시각 방향(generic default X).
- **Deploy 규칙:** metadata 배포 → schema fetch 순서. permission 할당 → schema fetch. 모든 metadata 배포 후 schema fetch + codegen 재실행.

### Error Handling

- **Category 1 (멈추고 사용자에게 질문):** app 목적이 페이지/데이터를 정할 수 없을 만큼 모호, 충돌 feature 요청(예: "no auth" + "user별 데이터"), 대상 org 미상인데 배포 요청.
- **Category 2 (경고 로그, 계속):** feature 설치 minor 충돌(해결 후 계속), optional integration 비차단 이슈, build의 non-error warning.

## 번들 파일

- `SKILL.md` — 오케스트레이션 워크플로 정의 (별도 참조 파일 없음; 각 phase 세부는 개별 ui-bundle 스킬에 위임)

## 관련 노트
- [[experience-ui-bundle-frontend-generate]]
- [[experience-ui-bundle-features-generate]]
- [[experience-ui-bundle-deploy]]
- [[experience-ui-bundle-custom-app-generate]]
- [[experience-ui-bundle-agentforce-client-generate]]
- [[experience-ui-bundle-file-upload-generate]]
