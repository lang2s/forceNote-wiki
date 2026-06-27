---
tags: [agent-skill, sf-skills, mobile, offline, komaci]
source: forcedotcom/sf-skills (skills/mobile-platform-offline-validate/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [mobile-platform-offline-validate, 모바일 오프라인 검증, Komaci 오프라인 분석, offline priming, lwc-graph-analyzer, inline GraphQL lwc:if 리뷰]
---

# mobile-platform-offline-validate — LWC 모바일 오프라인(Komaci) 검증

> LWC를 모바일 오프라인 호환성에 대해 검토하는 스킬. Komaci 오프라인 정적 분석기가 데이터 그래프를 사전 프라이밍(pre-prime)하며, inline GraphQL `@wire` 설정·`lwc:if`/`lwc:elseif`/`lwc:else` 디렉티브·Komaci ESLint 규칙 위반을 코드 레벨 수정과 함께 finding 리스트로 산출한다 (Salesforce Mobile App Plus, Field Service Mobile App 대상).

---

## 목적과 활성화 조건

LWC에 대해 구조화된 오프라인 프라이밍 컴플라이언스 패스를 실행해, 발견된 이슈와 코드 레벨 수정 보고서를 산출한다. Komaci의 정적 분석 요구사항(Salesforce Mobile App Plus, Field Service Mobile App)에 맞춰 컴포넌트를 준수시킨다.

**사용 시점:**
- 특정 LWC에 "mobile offline review", "Komaci check", "offline priming audit" 요청
- Salesforce Mobile App Plus 또는 Field Service Mobile App 오프라인 모드로 출하 준비
- 오프라인 분석기가 보고한 프라이밍 실패 조사

**사용 금지:**
- 네이티브 모바일 기능(바코드 스캐너·생체인증·위치 등)을 쓰는 LWC 빌드 → `mobile-platform-native-capabilities-integrate`
- 일반 LWC 코드 리뷰 → 적절한 도메인 스킬(`reviewing-lws-security`, `reviewing-lwc-rtl`, `accessibility-code-review`)

**전제조건:**
- 컴포넌트 경로(`modules/…` 하위 LWC 번들).
- 컴포넌트의 JS/TS와 HTML 템플릿 접근.
- 로컬 Node + npm; `@salesforce/eslint-plugin-lwc-graph-analyzer` 플러그인으로 `npx eslint` 실행 능력.

**Knowledge Base:** `references/grounding.md`가 세 가지 위반 카테고리와 각각이 오프라인 프라이밍을 막는 이유를 설명한다. 판정 전에 읽는다. 아래 reviewer reference들이 규칙·remediation의 source of truth다 — Inline GraphQL(`inline-graphql.md`), `lwc:if`(`lwc-if.md`), Komaci ESLint(`komaci-eslint.md`).

---

## 워크플로 / 단계

### Step 1 — 리뷰 스코프 설정
컴포넌트 번들 식별: `.html`, `.js`/`.ts`. CSS·meta 파일은 오프라인 프라이밍 스코프 밖. 번들에 HTML 템플릿이 여러 개면 모두 리뷰.

### Step 2 — grounding + reviewer reference 읽기
`grounding.md`와 세 reviewer reference를 판정 전에 end-to-end로 읽는다. 보고서가 감사 가능하도록 각 finding 방출 시 해당 reviewer를 인용한다.

### Step 3 — `lwc:if` / `lwc:elseif` / `lwc:else` (HTML)
번들의 모든 `.html` 파일을 훑으며 `lwc-if.md` 규칙 적용. `lwc:if={…}`, `lwc:elseif={…}`, `lwc:else` 각 발생마다 정확한 `if:true` / `if:false` 재작성(`lwc:elseif`·`lwc:else` 의미 보존에 필요한 중첩 포함)과 함께 finding 방출.

### Step 4 — `@wire` 내 Inline GraphQL (JS)
번들의 모든 `.js`/`.ts` 파일을 훑으며 `inline-graphql.md` 규칙 적용. `gql` 템플릿 리터럴을 직접(또는 top-level 상수 경유) 참조하는 각 `@wire`마다, 구체적 getter를 명명하고 재작성된 `@wire` 설정을 보이는 finding 방출.

### Step 5 — Komaci ESLint 패스 (JS)
번들 스크립트로 번들의 JS 파일에 Komaci ESLint 분석기 실행. `@salesforce/eslint-plugin-lwc-graph-analyzer` recommended 룰셋을 `bundleAnalyzer` processor 활성화로 적용.

```bash
scripts/run-komaci.sh path/to/component.js
```

스크립트는 working directory에서 `@salesforce/eslint-plugin-lwc-graph-analyzer`가 resolvable이어야 하고, 컴포넌트의 sibling HTML 템플릿이 JS 파일 옆에 있어야 한다(플러그인의 `bundleAnalyzer` processor가 오프라인 데이터 그래프 resolve에 사용). 출력은 stdout에 ESLint `--format json`.

출력의 각 `messages[*]` 항목마다 `ruleId`로 그룹화해 `komaci-eslint.md`에서 per-rule remediation을 찾는다. (rule, line) 쌍당 finding 방출, reference의 정확한 remediation 텍스트 사용 — 새 advice 발명 금지. 스크립트가 런타임 환경에 없으면 reference의 수동 `npx eslint ...` 호출 참조.

### Step 6 — 보고서 산출
다음 형태로 보고서 방출:

```
## Mobile Offline (Komaci priming)
- <reviewer> — <file>:<startLine>:<startColumn>-<endLine>:<endColumn> — <type>
  Description: <reviewer reference에서 verbatim>
  Intent analysis: <reviewer reference에서 verbatim>
  Suggested action: <reviewer reference에서 verbatim>
  Code: |
    <startLine부터 endLine까지 source snippet — 위반이 여러 줄에
     걸칠 때 권장>
  Applied: yes/no

## Summary
- <n> issues found; <m> fixed; <k> deferred (with reason)
```

Komaci ESLint finding은 `startLine`/`startColumn`/`endLine`/`endColumn`을 ESLint 메시지의 `line`/`column`/`endLine`/`endColumn`에서 취한다. Inline GraphQL·`lwc:if` finding은 source에서 관찰한 line/column 범위를 제공한다. `endLine`/`endColumn`이 없으면 `<file>:<startLine>`로 fallback하고 trailing range 생략. 모든 finding에 reviewer(Inline GraphQL / lwc:if / Komaci ESLint rule id) 인용.

### Step 7 — 수정 적용
사용자가 수정을 요청했으면 remediation을 직접 적용. remediation이 오프라인 밖 컴포넌트 동작과 충돌하면(예: 개발자가 가독성을 위해 `lwc:elseif`에 의존하고 아직 모바일 오프라인 출하 전), silent 재작성 대신 deferred 리스트에 충돌을 노출.

---

## 핵심 규칙·가드레일

**Verification Checklist:**
- [ ] 모든 `lwc:if` / `lwc:elseif` / `lwc:else`가 flag되거나 부재.
- [ ] `gql`을 참조하는 모든 `@wire` 점검; inline query를 getter로 추출.
- [ ] Komaci ESLint 분석기를 실제로 실행; finding이 발명 아닌 실제 rule id 인용.
- [ ] 각 finding이 originating reviewer 또는 rule id 인용.
- [ ] 위 세 카테고리 밖 remediation 없음 (다른 우려는 다른 스킬 소관).

**Troubleshooting:**
- **`npx eslint`가 플러그인을 못 찾음** — 워크스페이스에 `@salesforce/eslint-plugin-lwc-graph-analyzer` 설치, 또는 pinned local install 경로 사용. 플러그인이 Komaci 규칙의 canonical source.
- **`bundleAnalyzer` 관련 에러** — recommended config가 bundle processor를 구동하므로 strip 금지. processor는 sibling HTML 파일이 discoverable하길 기대. 축소된 JS 파일로 실행 시 temp 디렉터리에 매칭 HTML 제공.
- **실패를 기대한 컴포넌트에 finding 없음** — recommended 룰셋이 적용됐는지 확인(빈 rules의 `bundleAnalyzer`만 아님). 일부 규칙은 JS 옆에 HTML이 있어야 함.
- **`lwc:if` finding이 전용 reviewer와 중복** — Komaci 플러그인은 템플릿을 검사하지 않음; `lwc:if` 검사는 HTML 전용(Step 3), Step 5 finding은 JS 전용.

---

## 번들 파일

- `SKILL.md` — 워크플로 본문
- `references/` — `grounding.md`(세 위반 카테고리 설명), `inline-graphql.md`, `lwc-if.md`, `komaci-eslint.md` (각 reviewer의 규칙·remediation source of truth)
- `scripts/`:
  - `run-komaci.sh` — Komaci 오프라인 정적 분석 runner. recommended 룰셋으로 ESLint를 실행하고 JSON 출력. 첫 실행 시 pinned deps를 `scripts/node_modules`에 설치. `KOMACI_ESLINT_BIN` 환경변수로 eslint 바이너리 override 가능.
  - `komaci.config.mjs` — `@salesforce/eslint-plugin-lwc-graph-analyzer`의 recommended 룰셋(`bundleAnalyzer` processor 포함)을 적용하는 ESLint flat config.
  - `package.json` — pinned 버전: `@salesforce/eslint-plugin-lwc-graph-analyzer` `^1.1.0-beta.2`, `eslint` `^9.35.0`.

---

## 관련 노트
- [[mobile-apps-create]]
- [[mobile-platform-native-capabilities-integrate]]
- [[모바일 & 오프라인 (LWC)]] — Offline GraphQL·Komaci 정적분석 위키 노트
