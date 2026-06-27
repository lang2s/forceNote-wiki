---
tags: [agent-skill, sf-skills, dx, tooling, code-analyzer, static-analysis]
source: forcedotcom/sf-skills (skills/dx-code-analyzer-run/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [dx-code-analyzer-run, 코드 애널라이저 실행 스킬, sf code-analyzer run, 정적 분석 스캔, 위반 필터링, 엔진 자동 수정]
---

# dx-code-analyzer-run — Salesforce Code Analyzer 실행 스킬

> 자연어 요청을 올바른 `sf code-analyzer run` 명령으로 변환해 보안·성능·베스트프랙티스·코드스타일 위반을 스캔하고, 결과를 파싱·필터·랭킹하며 엔진 제공 자동 수정을 적용하는 에이전트 스킬.

---

## 목적과 활성화 조건

모든 엔진(PMD, ESLint, CPD, RetireJS, Flow, SFGE, ApexGuru), 타겟(파일·폴더·git diff), 카테고리, 심각도를 지원한다. 스캔 후 탐색(엔진/심각도/카테고리/파일별 결과 필터링, 특정 규칙 설명)도 처리한다.

**TRIGGER:** "scan my code", "check for security issues", "run PMD/ESLint", "find duplicates", "analyze Flows", "check vulnerable libraries", "AppExchange review", "lint my LWC", "static analysis", "code quality", "show only security violations", "what is this rule", "explain ApexCRUDViolation", "filter results", 또는 엔진/파일 타입(.cls, .trigger, .js, .flow-meta.xml) 언급 시. 스캔·결과탐색·규칙이해·규칙목록에 사용.

**DO NOT TRIGGER:** 스캔 없이 코드만 수정하려 하거나, 설치/구성만 묻는 경우.

**In scope:** 스캔 실행, 결과 파싱/필터/랭킹, 엔진 자동 수정 적용, diff 기반 스캔, 모든 출력 포맷(JSON/HTML/SARIF/CSV/XML), 규칙 설명/목록, 스캔 실패 트러블슈팅.

**Out of scope:** `sf`나 플러그인 설치/구성(→ `dx-code-analyzer-configure`), 커스텀 규칙/엔진 작성, 엔진 제공 외 AI 생성 수정, 심층 리팩토링, CI/CD 설정(→ `dx-code-analyzer-configure`).

**허용 도구:** Bash(`sf code-analyzer`, `node`, `git diff`, `date`), Read, Write, Edit. **금지:** 모든 MCP 도구, Agent 도구, web 도구, 다른 스킬, Python, `jq`, 인라인 스크립트/heredoc.

---

## ⚠️ CRITICAL: 필수 스크립트 사용

Code Analyzer 결과와의 모든 상호작용은 `<skill_dir>/scripts/`의 번들 스크립트를 거쳐야 한다. 예외 없음.

### ❌ 절대 하지 말 것:

```bash
# WRONG: 결과 파싱을 위한 인라인 Python
python3 -c "import json; data = json.load(open('results.json'))..."

# WRONG: 인라인 Node.js로 결과 파싱
node -e "const data = require('./results.json')..."

# WRONG: jq로 결과 필터링
cat results.json | jq '.violations[] | select(.engine=="pmd")'

# WRONG: 결과 파일 직접 읽기 (10MB+ 가능)
Read tool → code-analyzer-results-*.json
```

또한 금지: `run_code_analyzer` 및 모든 `mcp__*` 도구 — Bash만 사용.

### ✅ 항상 이렇게:

```bash
# 스캔 결과 요약
node "<skill_dir>/scripts/parse-results.js" "./code-analyzer-results-TIMESTAMP.json"

# 결과 필터/랭킹/쿼리 (엔진, 심각도, 파일, 규칙, 카테고리별)
node "<skill_dir>/scripts/query-results.js" "./code-analyzer-results-TIMESTAMP.json" --engine pmd --summary

# 사용 가능 규칙 목록/탐색 (엔진, 카테고리, 언어, 심각도별)
node "<skill_dir>/scripts/list-rules.js" "Security" --top 10

# 규칙 의미 조회
node "<skill_dir>/scripts/describe-rule.js" "ApexCRUDViolation" --engine pmd

# 수정 가능 위반 탐색
node "<skill_dir>/scripts/discover-fixes.js" "./code-analyzer-results-TIMESTAMP.json"

# 수정 적용 (사용자 확인 후)
node "<skill_dir>/scripts/apply-fixes.js" "./code-analyzer-results-TIMESTAMP.json"

# 적용된 수정 요약
node "<skill_dir>/scripts/summarize-fixes.js" "./code-analyzer-results-TIMESTAMP.json"

# 수정 적용 전 벤더 파일(jQuery, Bootstrap, *.min.js) 필터링
node "<skill_dir>/scripts/filter-violations.js" "./code-analyzer-results-TIMESTAMP.json" "./code-analyzer-results-TIMESTAMP-filtered.json" --report
```

`<skill_dir>`는 SKILL.md가 있는 디렉터리의 절대 경로. **절대** `./scripts/`를 쓰지 않는다 — 사용자의 CWD 기준으로 해석되기 때문.

집계·필터·랭킹 질문("어느 파일에 위반이 가장 많아?", "PMD 이슈 몇 개?", "count 상위 규칙", "심각도별 분류")은 모두 `query-results.js`로 답한다 — 출력에 이미 `topRules`, `topFiles`, `severityCounts`가 포함된다.

---

## 명령 문법 규칙 (먼저 읽을 것 — ABSOLUTE)

1. 명령은 **`sf code-analyzer run`** — `sf scanner run` 아님(deprecated v3).
2. **`--format` 플래그 없음.** `--output-file <path>.<ext>` 사용 — 확장자가 포맷을 결정.
3. **항상** 타임스탬프 이름으로 `--output-file` 전달 (예: `./code-analyzer-results-20260512-143022.json`) — stdout에 의존하지 않음.
4. **포그라운드 전용** (no `run_in_background`); 대형 스캔 timeout 1200000ms.
5. **에러를 일으키는 무효 v3 플래그:** `--format`, `--engine`, `--category`, `--json`. 대신 `--rule-selector` + `--output-file` 사용.
6. **도구 제한:** Bash, Read, Write, Edit만. MCP/Agent/web 도구·다른 스킬 금지.

이유: v4+ CLI가 플래그 인터페이스를 재설계 — v3 플래그는 이제 에러.

전체 플래그/셀렉터 문서: `<skill_dir>/references/flag-reference.md`.

---

## 전제조건

필요: **Salesforce CLI**(`sf`), **@salesforce/plugin-code-analyzer**(v5.x+), **Java 11+**(PMD/CPD/SFGE), **Node.js 18+**(ESLint/RetireJS), **Python 3**(Flow), **인증된 org**(ApexGuru).

Pre-flight: `sf code-analyzer --help 2>&1 | head -1` 실행. 이게 실패하거나 스캔이 엔진 시작 에러를 보고하면(예: "PMD failed to start", "java: command not found", "SFGE failed"):

1. **멈춤** — 전제조건을 직접 설치/진단하지 않는다.
2. **`dx-code-analyzer-configure`에 위임** — 모든 설정을 처리.
3. 끝나면 여기로 돌아와 스캔을 재실행.

다른 이유로 스캔이 실패하면 `<skill_dir>/references/error-handling.md` 참조.

---

## 워크플로 / 단계

### Quick Start: 흔한 패턴

요청이 아래에 매치되면 Step 3(명령 빌드)로 점프. 아니면 Step 1을 따른다.

| 사용자 표현 | Rule Selector | 비고 |
|-----------|---------------|-------|
| "scan my code" / "run code analyzer" | `Recommended` | 큐레이트 세트, 모든 파일 타입 |
| "check for security issues" / "security review" | `all:Security:(1,2)` | 모든 엔진, Critical+High |
| "scan my changes" / "check the diff" | (Step 1.5 참조) | `git diff`로 파일 획득 → 스캔 가능 타입 필터 → `--target` 전달 |
| "run PMD" / "check my Apex" | `pmd` | Apex 클래스·트리거 |
| "lint my LWC" / "check my JavaScript" | `eslint` | JavaScript/TypeScript/LWC |
| "find duplicates" / "check for copy-paste" | `cpd` | 코드 클론 |
| "check for vulnerabilities" / "scan libraries" | `retire-js` | JavaScript 라이브러리 CVE |
| "deep analysis" / "data flow analysis" | `sfge` | Java 11+, 10–20분, `--workspace "force-app"` 사용 |
| "performance analysis" / "governor limits" | `apexguru` | 인증된 org 필요 |
| "analyze my Flows" | `flow` | `--target **/*.flow-meta.xml`, Python 3 |
| "AppExchange security review" | `all:Security:(1,2)` | `<skill_dir>/references/special-behaviors.md` → AppExchange |

### Step 1 — 사용자 의도 파싱

7개 차원으로 분석하며, 어느 것이든 조합될 수 있다.

- **1.1 ENGINE:** PMD/Apex → `pmd` · ESLint/JS/TS/lint → `eslint` · Flows → `flow` · duplicates/CPD → `cpd` · vulnerabilities/CVE/RetireJS → `retire-js` · SFGE/data flow → `sfge` · performance/ApexGuru → `apexguru` · regex → `regex` · everything → `all` · 미지정 → `Recommended`.
- **1.2 CATEGORY:** security/OWASP → `Security` · performance → `Performance` · best practices → `BestPractices` · style/format → `CodeStyle` · design/complexity → `Design` · bugs → `ErrorProne` · docs → `Documentation`.
- **1.3 SEVERITY:** 1=Critical · 2=High · 3=Moderate · 4=Low · 5=Info. "critical only" → `1` · "critical+high" → `(1,2)` · "moderate and above" → `(1,2,3)`.
- **1.4 SPECIFIC RULE:** 사용자가 규칙을 지명하면(예: "ApexCRUDViolation", "no-unused-vars") `--rule-selector <engine>:<ruleName>`, 엔진이 모호하면 `<ruleName>`만.

  ⚠️ **부분 이름:** `--rule-selector`는 **정확한 전체** 규칙 이름이 필요하다(예: `@salesforce-ux/slds/no-hardcoded-values-slds2`, `no-hardcoded-values` 아님). 와일드카드 없음. 100% 확신이 없으면 먼저 lookup — **추측 금지**:
  ```bash
  sf code-analyzer rules --rule-selector all 2>&1 | grep -i "USER_KEYWORD"
  ```
  다중 매치 → 어느 것인지 질문. 0개 매치 → 매치 없음을 알림.
- **1.5 TARGET:** 특정 경로 → `--target <path>` · glob("all Apex") → `--target **/*.cls,**/*.trigger` · "my changes"/"diff" → `git diff --name-only [base]...HEAD`, 스캔 가능 타입 필터, `--target`으로 전달 · "LWC" → `--target **/lwc/**` · "Flows" → `--target **/*.flow-meta.xml` · 미지정 → 생략(전체 워크스페이스). Diff 필터링 상세: `<skill_dir>/references/special-behaviors.md`.
- **1.6 OUTPUT:** **기본 JSON.** 사용자가 명시 요청할 때만 변경. 이름: `./code-analyzer-results-<YYYYMMDD-HHmmss>.<ext>` via `TIMESTAMP=$(date +%Y%m%d-%H%M%S)`. 포맷: `.json`(기본), `.html`, `.sarif`, `.csv`, `.xml`.
- **1.7 COMPARISON / DELTA:** "new since main" → `git diff --name-only main...HEAD` → 그 파일들 스캔 · "since last commit" → `HEAD~1` · "vs develop" → `develop...HEAD`.

### Step 2 — Rule Selector 빌드

문법: `:` = AND, `,` = OR, `()` = 그룹화.

- Engine only: `pmd`
- Engine + category: `pmd:Security`
- Engine + severity: `pmd:2`
- Complex: `(pmd,eslint):Security:(1,2)` = (PMD 또는 ESLint) AND Security AND sev (1 또는 2)
- Specific rule: `pmd:ApexCRUDViolation`
- All: `all`

추가: `<skill_dir>/references/command-examples.md`.

### Step 3 — 전체 명령 빌드

```bash
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
sf code-analyzer run \
  --rule-selector <selector> \
  --target <targets> \                                              # optional
  --output-file "./code-analyzer-results-${TIMESTAMP}.json" \       # default JSON
  --include-fixes \                                                 # always
  --workspace <path>                                                # optional
```

- 기본은 타임스탬프 JSON; 명시 요청 시에만 포맷 변경.
- 항상 `--include-fixes` 전달(Step 6 자동 수정 활성화).
- `--target` 생략 시 전체 워크스페이스 스캔.
- Diff 스캔: `git diff --name-only` → 스캔 가능 타입 필터 → `--target`으로 전달.

특수 케이스(SFGE/ApexGuru/AppExchange/diff): `<skill_dir>/references/special-behaviors.md`.

### Step 4 — 스캔 실행

**Bash 도구만** 사용 — `run_code_analyzer` MCP 도구 절대 금지.

1. Bash로 타임스탬프 생성: `date +%Y%m%d-%H%M%S` → 예 `20260512-143022`.
2. 사용자에게 안내:
   ```
   Starting scan...
   Results: ./code-analyzer-results-20260512-143022.json
   Log:     ./code-analyzer-results-20260512-143022.log
   May take several minutes for large codebases.
   ```
3. **리터럴** 타임스탬프를 박아(`$TIMESTAMP` 아님) 포그라운드, timeout 1200000ms, `.log`로 `tee` 실행:
   ```bash
   sf code-analyzer run --rule-selector Recommended \
     --output-file "./code-analyzer-results-20260512-143022.json" \
     --include-fixes 2>&1 | tee "./code-analyzer-results-20260512-143022.log"
   ```
4. Exit 0 = 성공. 에러 시 로그 파일과 `<skill_dir>/references/error-handling.md` 둘 다 읽음.
5. **즉시** 결과 파싱(Step 5) — 사용자에게 다음을 묻지 않음.

### Step 5 — 결과 파싱·제시

스캔 직후 파싱 스크립트 실행 — 멈춰서 묻지 않음:

```bash
node "<skill_dir>/scripts/parse-results.js" "./code-analyzer-results-TIMESTAMP.json"
```

⚠️ **하지 말 것:** 스크립트 코드 직접 작성/생성 ❌ · `node scripts/parse-results.js` 같은 bare 상대 경로(사용자 CWD에서 해석 안 됨) ❌ · heredoc/인라인 스크립트 ❌ · 파싱 스크립트 대신 `jq`(셸 quoting 깨짐) ❌ · JSON 파일 직접 Read ❌.

**제시 템플릿:**

```
## Scan Complete

**Found X violations** across Y files.

| Severity | Count |
|----------|-------|
| Critical (1) | X |
| High (2) | X |
| Moderate (3) | X |
| Low (4) | X |
| Info (5) | X |

### Top Issues
| # | Rule | Engine | Sev | File | Line |
|---|------|--------|-----|------|------|
| 1 | ApexCRUDViolation | pmd | 2 | AccountService.cls | 42 |
| ... up to 10 most critical |

### Top Rules by Frequency
| Rule | Engine | Count |
|------|--------|-------|
| no-var | eslint | 170 |
| ... |

Full results: `./code-analyzer-results-20260512-143022.json`
```

결과 규모에 맞게 스케일: **0** → "no violations found"; **1–10** → 한 표에 전부; **11–50** → 심각도 count + top 10; **50–5000** → counts + top 10 위반 + top 10 규칙 + top 5 파일; **5000+** → 동일 + 범위 좁히기 제안(심각도/카테고리/폴더). 항상 출력 경로로 끝맺고 다음 액션 제안: filter / explain rule / apply fixes. 대형 결과 처리: `<skill_dir>/references/special-behaviors.md`.

### Step 6 — 엔진 제공 수정 적용 (스캔 후)

엔진 제공 수정은 **결정론적**(AI 생성 아님). 플로우: 벤더 필터(필요 시) → discover → present → **사용자 확인 대기** → apply → summarize.

- **6.1 벤더 파일 필터 (필요 시):** 사용자가 "fix my code" / "project source"라 했거나, top 위반 파일이 벤더 라이브러리(jQuery, Bootstrap, `*.min.js`)일 때 실행:
  ```bash
  node "<skill_dir>/scripts/filter-violations.js" \
    "./code-analyzer-results-TIMESTAMP.json" \
    "./code-analyzer-results-TIMESTAMP-filtered.json" \
    --report
  ```
  리포트: "Excluded X vendor files (Y violations) — jQuery, Bootstrap, etc. Applying fixes to Z project files only." 6.2+에서 필터된 파일 사용. 탐지 로직: `<skill_dir>/references/vendor-file-handling.md`.
- **6.2 Discover:**
  ```bash
  node "<skill_dir>/scripts/discover-fixes.js" "./code-analyzer-results-TIMESTAMP.json"
  ```
- **6.3 Present + ASK (그리고 STOP):**
  ```
  ### Engine-Provided Fixes Available
  **X of Y violations** have auto-fixes provided by the analysis engine:

  | Rule | Engine | Sev | Fixable Count |
  |------|--------|-----|---------------|
  | no-var | eslint | 3 | 170 |
  | ... |

  These are safe, deterministic fixes generated by the engines (not AI-generated).

  Would you like me to apply these fixes? (yes / no / select specific rules)
  ```
  ⚠️ **사용자의 답을 멈춰서 기다린다 — 처음에 "scan and fix everything"이라 했어도.** 다음 턴의 새 "yes"/"apply"/"go ahead"가 있을 때만 적용.
- **6.4 Apply:**
  ```bash
  node "<skill_dir>/scripts/apply-fixes.js" "./code-analyzer-results-TIMESTAMP.json"
  ```
  (6.1에서 필터 파일을 만들었으면 그 파일.)
- **6.5 Summarize (6.4 직후 MANDATORY):**
  ```bash
  node "<skill_dir>/scripts/summarize-fixes.js" "./code-analyzer-results-TIMESTAMP.json"
  ```
  그 후 제시:
  ```
  ### Engine-Provided Fixes Applied Successfully ✓
  **Applied X auto-fixes across Y files.**

  | Severity | Fixes Applied |
  |----------|---------------|
  | Critical (1) | X |
  | ... |

  | Rule | Fixes Applied |
  |------|---------------|
  | no-var | 169 |
  | ... |

  Want me to re-run the scan to verify the fixes resolved the violations?
  ```
- **6.6 사용자 선택 처리:** **Decline/"no"** → apply·summarize 건너뜀, 재스캔 안 함. **"Select rules"** → discovery 목록을 해당 규칙으로 필터해 `apply-fixes.js`에 전달. **"All"/"yes"** → 전체(또는 벤더 필터된) 결과 파일에 `apply-fixes.js` 실행.
- **6.7 검증용 선택적 재스캔:** 6.5 제안을 사용자가 수락하면 **새 타임스탬프**로 동일 스캔 재실행(원본 덮어쓰지 않음). 전/후 위반 count 비교해 delta 표시 — 깨끗이 해결된 수정은 빠지고, 남은 위반은 수동 처리가 필요하거나 무관한 것.

### Step 7 — 기존 결과 쿼리·필터

Step 5 후 사용자는 전체 재실행 없이 특정 부분집합으로 drill-in할 수 있다. 모든 결과 탐색 요청을 처리.

**트리거:** "Show me just the security violations", "What's in AccountService.cls?", "Show only PMD issues" / "Filter to critical and high", "What ESLint rules fired?" / "Show violations in the lwc folder", "Top 20 most severe" / "Which file has the most violations?", "What are the most common rules?" / "How many violations per engine?" / "Break it down by severity".

**중요:** 기존 스캔 결과에 대한 모든 질문(필터·랭킹·카운팅·집계)은 `query-results.js`를 써야 한다. 인라인 Python·`jq`·임시 스크립트로 결과 JSON을 파싱하지 **않는다**. 쿼리 스크립트가 이미 `topRules`, `topFiles`, `severityCounts`를 출력에 제공한다.

Step 4의 **동일 결과 파일**에 쿼리 스크립트 실행(재스캔 불필요):

```bash
node "<skill_dir>/scripts/query-results.js" "./code-analyzer-results-TIMESTAMP.json" [options]
```

| 사용자 표현 | 옵션 |
|-----------|---------|
| "security violations" | `--category Security` |
| "PMD issues only" | `--engine pmd` |
| "critical and high" / "sev 1-2" | `--severity 1,2` |
| "in AccountService.cls" | `--file AccountService.cls` |
| "the ApexCRUDViolation rule" | `--rule ApexCRUDViolation` |
| "top 20" | `--top 20` |
| "sort by file" | `--sort file` |
| "just give me counts" | `--summary` |
| "which file has the most violations?" | `--sort file --summary` (`topFiles` 읽기) |
| "which file has most PMD violations?" | `--engine pmd --summary` (`topFiles` 읽기) |
| "most common rules?" | `--summary` (`topRules` 읽기) |
| "how many per engine?" | Step 5 요약 사용, 또는 엔진별 `--engine X --summary` |
| Combinations | `--engine pmd --severity 1,2 --top 5` |

출력 포맷·제시 템플릿: `<skill_dir>/references/post-scan-workflows.md`.

### Step 8 — 규칙 설명

"what does this rule mean?" / "how do I fix this?" 같은 질문에 특정 규칙을 조회·설명.

**트리거:** "What is ApexCRUDViolation?", "Explain this rule" / "Why is this flagged?", "What does no-var mean?", "How do I fix OperationWithLimitsInLoop?", "Tell me about this violation".

```bash
node "<skill_dir>/scripts/describe-rule.js" "<rule-name>" [--engine <engine>]
```

엔진을 알면(스캔 컨텍스트에서) `--engine` 전달; 넓은 검색은 생략. `success` / `multiple_matches` / `not_found` 중 하나 반환. 상태 처리·템플릿: `<skill_dir>/references/post-scan-workflows.md`.

### Step 9 — 사용 가능 규칙 목록

트리거: "what security rules are available?", "list all PMD rules", "rules for JavaScript", "Recommended rules", "how many ESLint rules?", "rules for Apex".

```bash
node "<skill_dir>/scripts/list-rules.js" "<selector>" [options]
```

| 사용자 표현 | Selector | 옵션 |
|-----------|----------|---------|
| "security rules" | `Security` | |
| "PMD rules" | `pmd` | |
| "ESLint security rules" | `eslint:Security` | |
| "JavaScript rules" | `JavaScript` | |
| "Apex rules" | `Apex` | |
| "Recommended rules" | `Recommended` | |
| "high severity rules" | `(1,2)` | |
| "just give me counts" | `Recommended` | `--count-only` |
| "top 10 security rules" | `Security` | `--top 10` |

필터: `--engine`, `--severity`, `--top`(기본 100), `--count-only`. 스크립트가 selector 토큰을 사전 검증(`secruity` 같은 오타 탐지)한 뒤 CLI를 호출. 제시: `<skill_dir>/references/post-scan-workflows.md`.

---

## 핵심 규칙·가드레일 (Constraints & Gotchas)

| 항목 | 이유 / 수정 |
|------|-----------|
| 타임스탬프 JSON + `.log`(`tee`) 사용 | 덮어쓰기 방지; 로그-결과 매칭 |
| `--format` 플래그 | v4+에서 제거; `--output-file <path>.<ext>` 사용 |
| 포그라운드, 1200000ms timeout | SFGE는 10–20분 소요; 백그라운드는 출력 유실 |
| 스크립트는 절대 `<skill_dir>` 경로로 실행 | `./scripts/`는 사용자 CWD에서 해석됨 |
| 확인 없이 수정 적용 금지 | 사용자가 코드 변경을 승인해야 함 |
| 수정 전 벤더 파일 확인 | 50%+ 벤더(jQuery/Bootstrap/`*.min.js`)면 먼저 필터 |
| 수정 스크립트 순서: filter(필요 시) → discover → apply → summarize | summary 생략 시 결과 리포트 없음 |
| SFGE는 명시적 `--workspace` 필요 | 안 하면 템플릿 파일이 컴파일 에러 유발 |
| 부분 규칙 이름 먼저 lookup | 추측은 0개 결과; `sf code-analyzer rules` 사용 |
| **오직** Bash 도구, MCP 절대 금지 | `run_code_analyzer` 등 MCP는 스크립트 워크플로 우회 |
| 수정을 위해 다른 스킬 호출 금지 | 이 스킬이 전체 워크플로를 end-to-end 소유 |
| 기존 결과 쿼리, 재스캔 말 것 | Step 7이 기존 JSON을 즉시 필터 |
| 스캔이 0개 결과 반환 | 무효 rule selector — `sf code-analyzer rules --rule-selector <selector>`로 검증 |
| `jq` 파싱 실패 | 셸 quoting — `parse-results.js` / `query-results.js` 사용 |
| LLM이 작성한 인라인 스크립트 | 스크립트 작성 금지 — `<skill_dir>/scripts/`의 기존 것 사용 |
| 임시 Python으로 랭킹/집계 | 항상 `query-results.js`; 출력에 이미 `topFiles`/`topRules`/`severityCounts` |

---

## 번들 파일

**Scripts** (항상 절대 `<skill_dir>/` 접두로 `node` 실행, Read 금지):

| 파일 | 사용 시점 |
|------|-------------|
| `scripts/parse-results.js` | Step 5 — 스캔 JSON에서 요약 추출 |
| `scripts/filter-violations.js` | Step 6.1 — 수정에서 벤더 파일 제외 |
| `scripts/discover-fixes.js` | Step 6.2 — 수정 가능 위반 식별 |
| `scripts/apply-fixes.js` | Step 6.4 — 사용자 확인 후 엔진 수정 적용 |
| `scripts/summarize-fixes.js` | Step 6.5 — 적용된 변경 요약 |
| `scripts/query-results.js` | Step 7 — 재스캔 없이 기존 결과 필터/drill-in |
| `scripts/describe-rule.js` | Step 8 — 규칙 설명·문서 조회 |
| `scripts/list-rules.js` | Step 9 — selector로 규칙 목록/탐색(검증 포함) |
| `scripts/verify-execution.sh` | 실행 검증 스크립트 |

**References** (필요 시 읽음):

| 파일 | 읽을 시점 |
|------|--------------|
| `references/quick-start.md` | 명령 문법 템플릿 |
| `references/flag-reference.md` | 전체 플래그 문서, rule-selector 문법 |
| `references/error-handling.md` | 스캔 실패 진단 |
| `references/engine-reference.md` | 엔진 기능, 파일 타입, 규칙 태그 |
| `references/command-examples.md` | 덜 흔한 명령 시나리오 |
| `references/special-behaviors.md` | SFGE/ApexGuru/AppExchange/diff/대형 스캔 |
| `references/vendor-file-handling.md` | 벤더 파일 탐지·필터링 |
| `references/post-scan-workflows.md` | Step 7–9 — 쿼리·규칙 설명·규칙 목록 |

`examples/`에는 출력 구조 검증·명령 패턴(basic/large/security 스캔, 수정 워크플로)이 있다: `README.md`, `basic-scan-output.json`, `command-variations.md`, `fix-application-before-after.md`, `large-scan-output.json`, `security-focused-output.json`.

---

## 관련 노트
- [[dx-code-analyzer-configure]]
- [[dx-org-switch]]
- [[dx-app-analytics-query]]
