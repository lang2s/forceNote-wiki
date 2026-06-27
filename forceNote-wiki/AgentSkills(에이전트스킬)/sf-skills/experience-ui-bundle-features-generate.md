---
tags: [agent-skill, sf-skills, experience, ui-bundle, features, authentication-search]
source: forcedotcom/sf-skills (skills/experience-ui-bundle-features-generate/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [experience-ui-bundle-features-generate, UI Bundle 사전 빌드 기능 설치, authentication search feature, ui-bundle-features CLI, 충돌 해결 example 통합]
---

# experience-ui-bundle-features-generate — UI Bundle 사전 빌드 기능 설치 (인증·검색)

> features CLI로 사전 빌드·테스트된 패키지를 UI bundle에 설치하는 스킬. 처음부터 만들지 말고 항상 기존 feature를 먼저 확인한다. 이 스킬은 authentication과 search 두 기능을 다룬다.

## 목적과 활성화 조건

**활성화(MUST):** `uiBundles/*/src/` 디렉터리가 있고 앱에 authentication 또는 search를 추가하려 할 때. 이 두 기능은 처음부터 빌드하지 말고 항상 이 스킬을 사용한다.

다루는 두 기능:
- **authentication** — login, logout, protected routes, session management
- **search** — 페이지·콘텐츠 전반의 global search

features CLI는 foundational UI 라이브러리(shadcn/ui)부터 full-stack 기능(authentication, search, navigation, GraphQL, Agentforce AI)까지 사전 빌드·테스트된 패키지를 Salesforce UI bundle에 설치한다. **무엇이든 처음부터 만들기 전에 항상 기존 feature를 먼저 확인한다.**

## 워크플로 / 단계

features CLI 핵심 명령:

```bash
npx @salesforce/ui-bundle-features list --search <query> --verbose
npx @salesforce/ui-bundle-features describe <feature>
npx @salesforce/ui-bundle-features install <feature> --ui-bundle-dir <name> --dry-run
npx @salesforce/ui-bundle-features install <feature> --ui-bundle-dir <name> --on-conflict error
```

1. **프로젝트 코드 먼저 검색** — 설치 전 `src/`에서 기존 구현을 확인한다. 검색은 `src/`로 한정해 `node_modules/`·`dist/` 매칭을 피한다.

2. **사용 가능 feature 검색** — `--search <query>`로 키워드 필터.
   ```bash
   npx @salesforce/ui-bundle-features list --search <query>
   ```
   전체 설명은 `--verbose`.

3. **feature 설명 보기** — components, dependencies, copy 작업, example 파일을 본다.
   ```bash
   npx @salesforce/ui-bundle-features describe <feature>
   ```

4. **설치**
   ```bash
   npx @salesforce/ui-bundle-features install <feature> --ui-bundle-dir <name>
   ```
   주요 옵션:
   - `--dry-run` — 변경 미리보기
   - `--yes` — 비대화형 모드(충돌 skip)
   - `--on-conflict error` — 충돌 감지, 이후 `--conflict-resolution <file>`로 해결

   매칭 feature가 없으면 커스텀 구현 전 사용자에게 묻는다 — 다른 이름의 관련 feature가 있을 수 있다.

### Conflict Handling

비대화형 환경에서는 two-pass 접근:
1. `--on-conflict error`로 먼저 실행해 충돌 감지
2. resolution JSON 파일 생성(`{ "path": "skip" | "overwrite" }`) 후 `--conflict-resolution`으로 재실행

### Post-install: Example 파일 통합

feature는 통합 패턴을 보여주는 `__example__` 파일을 포함할 수 있다. 각각에 대해:

1. example 파일을 읽어 패턴 이해
2. 대상 파일을 읽음(`describe` 출력에 표시)
3. example의 패턴을 대상에 적용
4. 성공적 통합 후 example 파일 삭제

### Hint Placeholders

일부 copy 경로는 CLI가 해결하지 않는 `<descriptive-name>` placeholder(예: `<desired-page-with-search-input>`)를 쓴다. 설치 후 이 파일들을 의도한 대상으로 rename/relocate하거나, 패턴을 기존 파일에 통합한다.

## 핵심 규칙·가드레일

- 처음부터 빌드하기 전에 항상 기존 feature를 먼저 확인(`src/` 검색 + features list).
- 검색은 `src/`로 한정 — `node_modules/`·`dist/` 매칭 회피.
- 매칭 feature 없으면 커스텀 구현 전 사용자에게 질문.
- 비대화형 충돌은 two-pass(`--on-conflict error` → resolution JSON → `--conflict-resolution`).
- `__example__` 파일은 통합 후 삭제. hint placeholder 파일은 의도 대상으로 rename/relocate.

## 번들 파일

- `SKILL.md` — features CLI 워크플로 정의 (별도 참조 파일 없음)

## 관련 노트
- [[experience-ui-bundle-app-coordinate]]
- [[experience-ui-bundle-frontend-generate]]
