---
tags: [agent-skill, sf-skills, dx, tooling, code-analyzer, ci-cd]
source: forcedotcom/sf-skills (skills/dx-code-analyzer-configure/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [dx-code-analyzer-configure, 코드 애널라이저 구성 스킬, code-analyzer.yml, Code Analyzer 설정, 엔진 활성화 비활성화, CI/CD 파이프라인 설정]
---

# dx-code-analyzer-configure — Salesforce Code Analyzer 구성 스킬

> `code-analyzer.yml` 구성 파일을 생성·편집·트러블슈팅하여 Code Analyzer를 설치·설정하고, 엔진/규칙/무시패턴/억제(suppression)/심각도 override와 CI/CD 파이프라인을 관리하는 에이전트 스킬.

---

## 목적과 활성화 조건

이 스킬은 `code-analyzer.yml`을 관리한다 — 프로젝트에서 Code Analyzer 동작을 결정하는 단일 진실원천(single source of truth). 모든 커스터마이징(엔진·규칙·무시·억제)은 이 파일을 만들거나 편집해 수행한다. 파일이 없으면 현재 작업 디렉터리(CWD)에 생성한다.

**TRIGGER:** "set up code analyzer", "configure code analyzer", "install code analyzer", "code analyzer not working", "fix my setup", "scan is failing", "check my setup", "is code analyzer installed", "enable/disable engine", "exclude files", "change severity", "set up GitHub Actions", "set up CI/CD", "add code analyzer to pipeline", "make pipeline fail", "update my workflow", "quality gate", "fail on violations", "scan changed files only", "add SARIF", "code-analyzer.yml", "ESLint config", "increase SFGE memory", 또는 Code Analyzer 실행 에러 보고 시.

**DO NOT TRIGGER:** 스캔 실행(→ `dx-code-analyzer-run`), 위반 수정, 규칙 설명, 커스텀 규칙 생성, 위반 억제 관리.

### 스코프

**In scope:** 전제조건 확인(sf CLI, Java, Node.js, Python, org auth), 플러그인 설치/업데이트, `code-analyzer.yml` 생성(없을 때)·편집(모든 구성 변경), 엔진 설정·규칙 override·무시패턴·억제, CI/CD 파이프라인 설정(GitHub Actions, Jenkins 등), 환경 검증·트러블슈팅.

**Out of scope:** 스캔 실행(→ `dx-code-analyzer-run`), 위반 수정, 규칙 설명, 커스텀 규칙 생성, 억제 관리.

### 도구 사용 규칙

- **허용:** Bash (sf, java, node, python3, git, npm), Read, Write, Edit
- **금지:** MCP 도구, Agent 도구, Web 도구, 다른 스킬, `which`, `find`, `locate`, 바이너리 검색

---

## 핵심 원칙: 커스터마이징할 때만 YAML

Code Analyzer는 설정 파일 없이도 동작한다 — 모든 기본값이 도구에 내장돼 있다. `code-analyzer.yml`은 사용자가 명시적으로 커스터마이징을 요청할 때만 생성한다.

**규칙:**
- **`code-analyzer.yml`을 선제적으로 만들지 않는다** — 사용자가 변경을 요청할 때만.
- **내장 기본값을 중복 기재하지 않는다** — 의도적으로 동작을 override하는 항목만 작성.
- **항상 프로젝트 루트에 둔다** — `sfdx-project.json` 또는 `sf-project.json`이 있는 곳.
- **CLI가 자동 발견한다** — 프로젝트 루트에서 `sf code-analyzer run`을 실행하면 해당 디렉터리의 `code-analyzer.yml`을 자동으로 집어든다. `--config-file` 플래그 불필요.
- 사용자가 구체적 요구 없이 "configure code analyzer"라고만 하면 → **무엇을 커스터마이징할지 묻는다.** 빈/보일러플레이트 파일을 만들지 않는다.

**워크플로:**
1. 사용자가 커스터마이징 요청 (예: "disable PMD", "ignore test files", "increase SFGE memory")
2. 프로젝트 루트에 `code-analyzer.yml`이 있는지 확인
3. 없으면 → 요청한 override만 담아 프로젝트 루트에 생성
4. 있으면 → 읽은 뒤 요청한 변경을 편집
5. `sf code-analyzer config`로 검증

---

## 워크플로 / 단계

### Step 1 — 의도 파악 후 config 섹션에 매핑

사용자는 자연어로 어떤 구성 변경 조합이든 요청할 수 있다. (1) 무엇을 원하는지 파싱, (2) 각 요청을 `code-analyzer.yml`의 올바른 섹션에 매핑, (3) 파일이 없으면 생성 후 모든 변경 적용.

`code-analyzer.yml` 구조 (작성/편집 가능 항목):

```yaml
config_root: .                    # 상대 경로 해석의 루트
log_folder: <path>                # 로그 기록 위치
log_level: <1-5>                  # 1=Error, 2=Warn, 3=Info, 4=Debug, 5=Fine

ignores:                          # 스캔에서 제외할 파일/폴더
  files: [<glob patterns>]

engines:                          # 엔진별 설정
  <engine_name>:
    disable_engine: <bool>
    <engine_specific_keys>: ...

rules:                            # 규칙별 override
  <engine_name>:
    <rule_name>:
      severity: <1-5>
      tags: [<strings>]
      disabled: <bool>

suppressions:                     # 일괄 억제 구성
  disable_suppressions: <bool>
  "<file_or_folder_path>":
    - rule_selector: "<selector>"
      max_suppressed_violations: <number|null>
      reason: "<why>"
```

**의도 카테고리 → 매핑:**

| 의도 카테고리 | 매핑 대상 | 사용자 표현 예시 |
|----------------|-----------|-------------------------------|
| Setup / Install | Step 2 (전제조건 + 설치) | "set up", "install", "get started", "new laptop", "from scratch" |
| **Diagnose / Fix** | **Step 2A (체계적 디버그)** | **"not working", "broken", "fix my setup", "scan fails", "getting errors"** |
| Engine control | `engines.<name>.disable_engine` | "disable X", "turn off Y", "only use Z", "enable all" |
| Engine tuning | `engines.<name>.<property>` | "increase memory", "change heap", "use my eslint config", "set tokens to 50" |
| File exclusions | `ignores.files` | "exclude", "ignore", "skip", "don't scan X" |
| Rule severity | `rules.<engine>.<rule>.severity` | "make X critical", "promote", "demote", "change severity" |
| Rule disable | `rules.<engine>.<rule>.disabled` | "disable rule X", "turn off Y rule", "remove Z" |
| Rule tags | `rules.<engine>.<rule>.tags` | "tag X as security", "add recommended tag" |
| Suppressions | `suppressions` 섹션 | "suppress X in folder Y", "allow N violations" |
| CI/CD | 파이프라인 파일 생성 (config와 별개) | "github actions", "CI", "quality gate" |
| View/inspect | 파일 Read + `sf code-analyzer config` | "show config", "what's configured", "current settings" |

**파일 존재 여부 결정 (무엇이든 편집하기 전):**

```bash
ls code-analyzer.yml code-analyzer.yaml 2>/dev/null
```

- 파일 없음 → 프로젝트 루트에 요청 override만 담아 생성
- 파일 있음 → 읽은 뒤 요청 섹션을 Edit로 추가/수정

#### ⚠️ 규칙 이름 해석 — YAML 작성 전 항상

사용자가 부분/서술/근사 이름으로 규칙을 지칭하면("the doc rule", "CRUD violation", "console rule", "hardcoded values"), Step 6.1의 lookup으로 **정확한 규칙 이름을 먼저 해석**한 뒤 YAML을 쓴다. `code-analyzer.yml`은 정확히 일치하지 않는 규칙 이름을 **에러 없이 조용히 무시**한다 — override가 적용되지 않을 뿐 경고가 없다.

fuzzy → exact 해석 예시:
- "Disable the ApexDoc rule" → `ApexDoc` (engine: `pmd`)
- "Demote no-console to low" → `no-console` (engine: `eslint`)
- "Make CRUD violations critical" → `ApexCRUDViolation` (engine: `pmd`)
- "Turn off the hardcoded values check" → `@salesforce-ux/slds/no-hardcoded-values-slds2` (engine: `eslint`)
- "Disable the injection rule" → 다중 매치 가능 → 사용자에게 어느 것인지 질문

lookup을 **생략해도 되는 경우**는 사용자가 모호하지 않고 정확한 잘 알려진 이름을 줄 때뿐 (예: "ApexDoc", "no-console", "no-unused-vars").

**자주 쓰는 요청 → config 출력:**

| 사용자 표현 | 결과 YAML |
|-----------|---------------|
| "configure code analyzer" | 무엇을 커스터마이징할지 질문 — 실제 override가 있기 전엔 파일 생성 안 함 |
| "disable the ApexDoc rule" | `rules: pmd: ApexDoc: disabled: true` |
| "only scan Apex, no JavaScript" | `engines: eslint: disable_engine: true` + `engines: retire-js: disable_engine: true` |
| "ignore all test files" | `ignores: files: ["**/test/**", "**/__tests__/**", "**/*.test.js"]` |
| "make security rules critical" | 규칙 lookup 후 각각 `rules: <engine>: <rule>: severity: 1` |
| "increase SFGE memory to 8g" | `engines: sfge: java_max_heap_size: "8g"` |
| "use my project's ESLint config" | `engines: eslint: auto_discover_eslint_config: true` |
| "suppress CRUD violations in legacy folder" | `suppressions: "force-app/legacy/": [{rule_selector: "pmd:ApexCRUDViolation", reason: "..."}]` |

### Step 2 — 전제조건 확인 및 설치

`bash "<skill_dir>/scripts/check-prerequisites.sh"`를 실행하거나 수동 확인한다.

```bash
sf --version 2>&1                                    # sf CLI
sf plugins --core 2>&1 | grep -i "code-analyzer"    # 플러그인
java -version 2>&1                                   # Java 11+ (PMD, CPD, SFGE)
node --version 2>&1                                  # Node 18+ (ESLint, RetireJS)
python3 --version 2>&1                               # Python 3 (Flow 엔진)
```

빠진 것이 있으면 설치한다 (**항상 사용자에게 먼저 확인**).

```bash
npm install -g @salesforce/cli                       # sf CLI
sf plugins install @salesforce/plugin-code-analyzer  # Code Analyzer 플러그인
```

Java/Node/Python 설치는 `<skill_dir>/references/engine-prerequisites.md` 참조. 설치 실패 시 `<skill_dir>/references/troubleshooting.md` 참조.

### Step 2A — 망가진 설정 진단·수정

**TRIGGER:** "not working", "broken", "getting errors", "scan fails", "help me fix" 등.

전체 계층형 진단 절차·수정표·안티패턴은 `<skill_dir>/references/diagnostic-flow.md` 참조.

핵심 원칙(항상 적용):
- 바이너리를 검색하지 않는다 (`which`, `find`, `ls /opt/homebrew/bin/`)
- 우회책으로 `sfdx`를 쓰지 않는다 — 오직 `sf`
- 계층별로 수정: CLI → 플러그인 → 엔진 의존성 → 스캔 검증
- 한 번에 하나의 명령만 주고, 다음으로 넘어가기 전 확인을 기다린다
- 수정 성공 후 전체 스캔을 자동으로 진행한다

### Step 3 — `code-analyzer.yml` 생성 또는 편집

**사용자가 커스터마이징을 요청할 때만 발동.** 선제적으로 만들지 않는다.

**생성 (파일 없음)** — 아래 두 접근 중 **하나만** 선택 (둘 다 실행하지 않음):

- **Option A — 프로젝트 타입에서 자동 생성 (최초 설정 권장):** `bash "<skill_dir>/scripts/generate-config.sh"` 실행. Apex, LWC, Flow 마커를 감지해 프로젝트에 맞는 최소 `code-analyzer.yml`을 생성. (주의: `code-analyzer.yml`이 이미 있으면 스크립트는 에러로 종료한다. 재생성하려면 기존 파일을 먼저 삭제.)
- **Option B — 수동 작성 (특정 커스터마이징이 있을 때):** 구조 참고용으로 예시 config를 읽는다. Apex 전용 → `<skill_dir>/examples/apex-project-config.yml`, LWC 전용 → `<skill_dir>/examples/lwc-project-config.yml`, 풀스택(Apex+LWC+Flow) → `<skill_dir>/examples/fullstack-project-config.yml`. Write 도구로 프로젝트 루트에 작성하되 **요청한 변경만** 포함.

예: 사용자가 "ignore test files and increase SFGE memory"라고 했을 때 프로젝트 루트(`sfdx-project.json`이 있는 곳)에 작성:

```yaml
ignores:
  files:
    - "**/test/**"
    - "**/__tests__/**"

engines:
  sfge:
    java_max_heap_size: "4g"
```

사용자가 요청하지 않은 `config_root`, `log_folder` 등 다른 필드는 추가하지 않는다.

**편집 (파일 있음):** 파일을 읽고 Edit 도구로 관련 섹션만 추가/수정한다. 나머지는 보존.

**생성/편집 후 검증:** `bash "<skill_dir>/scripts/validate-config.sh"`로 YAML 문법·스키마 정확성을 검증하거나 CLI를 직접 사용:

```bash
sf code-analyzer config
```

(`--config-file` 불필요 — CLI가 CWD의 `code-analyzer.yml`을 자동 발견.)

구체적 요구 없이 "configure code analyzer"라고만 하면: "무엇을 커스터마이징할까요? 예: 특정 파일 무시, 규칙 심각도 변경, 엔진 설정 튜닝, 불필요한 엔진 비활성화" 라고 묻는다.

### Step 4 — 엔진 활성화/비활성화

`code-analyzer.yml`의 `engines` 섹션을 편집한다.

```yaml
engines:
  pmd:
    disable_engine: true       # PMD 비활성화
  eslint:
    disable_engine: false      # ESLint 활성화 (기본값)
```

유효 엔진 이름: `pmd`, `cpd`, `eslint`, `regex`, `retire-js`, `flow`, `sfge`, `apexguru`

편집 후 항상 검증:

```bash
sf code-analyzer config --config-file code-analyzer.yml
```

### Step 5 — 무시 패턴(Ignore Patterns)

`ignores` 섹션을 편집한다.

```yaml
ignores:
  files:
    - "**/node_modules/**"
    - "**/.sfdx/**"
    - "**/.sf/**"
    - "**/vendor/**"
    - "**/*.min.js"
```

자주 쓰는 패턴:

| 패턴 | 제외 대상 |
|---------|----------|
| `**/node_modules/**` | npm 의존성 |
| `**/.sfdx/**`, `**/.sf/**` | SF CLI 내부 파일 |
| `**/test/**`, `**/__tests__/**` | 테스트 디렉터리 |
| `**/*.test.js`, `**/*.spec.js` | 테스트 파일 |
| `**/jest-mocks/**` | Jest 모크 |
| `**/vendor/**`, `**/*.min.js` | 서드파티/minified |
| `**/staticresources/**` | 정적 리소스 |

### Step 6 — 규칙 Override

`rules` 섹션을 편집한다. 각 규칙은 `severity`, `tags`, `disabled` override를 가질 수 있다.

```yaml
rules:
  pmd:
    ApexCRUDViolation:
      severity: 1              # Critical로 승격
    AvoidGlobalModifier:
      disabled: true           # 완전히 끔
    ApexDoc:
      severity: 5              # Info로 강등
      tags: ["Documentation"]
  eslint:
    no-console:
      severity: 4              # Low로 강등
    no-unused-vars:
      severity: 2              # High로 승격
```

**심각도 값:** `1`/Critical, `2`/High, `3`/Moderate, `4`/Low, `5`/Info

#### 6.1 규칙 이름 해석 (Fuzzy Matching)

**⚠️ CRITICAL:** `code-analyzer.yml`의 오타나 부분 규칙 이름은 **조용히 무시**된다 — 에러 없이 override만 적용되지 않는다.

사용자가 근사 이름으로 규칙을 지칭하면("the doc rule", "CRUD violation", "hardcoded values"), YAML 작성 전 정확한 이름으로 해석한다:

```bash
sf code-analyzer rules --rule-selector all 2>&1 | grep -i "<USER_KEYWORD>"
```

- **1개 매치** → 그 정확한 이름 + 엔진을 YAML 경로에 사용
- **다중 매치** → 어느 것인지 사용자에게 질문
- **0개 매치** → 더 넓은 키워드 시도 또는 사용자에게 알림

이름이 모호하지 않고 정확할 때만(예: "ApexDoc", "no-console", "no-unused-vars") lookup을 생략한다. 상세 매칭 전략·fuzzy→exact 매핑·엔진 식별은 `<skill_dir>/references/rule-name-resolution.md` 참조.

### Step 7 — 엔진별 설정

`engines` 섹션을 편집한다. 가장 흔한 override:

```yaml
engines:
  sfge:
    java_max_heap_size: "4g"      # <200 클래스→"2g", 200-500→"4g", 500+→"6g"/"8g"
    java_thread_count: 4
    java_thread_timeout: 900000
  eslint:
    auto_discover_eslint_config: true    # 프로젝트 자체 ESLint config 사용
    eslint_config_file: "./eslint.config.mjs"
  pmd:
    custom_rulesets: ["./config/custom-pmd-rules.xml"]
    java_classpath_entries: ["./lib/custom-rules.jar"]
  cpd:
    minimum_tokens: { apex: 100, javascript: 100 }
  apexguru:
    target_org: "my-org-alias"
  flow:
    python_command: "python3"
  regex:
    custom_rules:
      NoHardcodedIds:
        regex: "/[a-zA-Z0-9]{15,18}/"
        file_extensions: [".cls", ".trigger"]
        description: "Detects hardcoded Salesforce record IDs"
        severity: 2
        tags: ["Security"]
```

엔진별 전체 속성 목록은 `<skill_dir>/references/config-schema.md` 참조.

### Step 8 — CI/CD 파이프라인 설정

워크스페이스에서 CI 시스템을 감지한다 (`.github/workflows/` → GitHub Actions, `Jenkinsfile` → Jenkins 등). 템플릿은 `<skill_dir>/references/ci-cd-templates.md` 참조. GitHub Actions 기반으로 `<skill_dir>/examples/ci-github-actions.yml` 사용. 핵심 플래그: `--severity-threshold 2`(게이트), `--output-file results.sarif`(GitHub scanning), `--config-file code-analyzer.yml`.

### Step 9 — 현재 구성 보기

```bash
sf code-analyzer config                               # 유효 구성 표시
sf code-analyzer config --rule-selector pmd:Security  # 특정 규칙
sf code-analyzer config --include-unmodified-rules    # 모든 기본값
```

---

## 크로스 스킬 통합

이 스킬은 [[dx-code-analyzer-run]]과 함께 동작하며, 에이전트는 둘 사이를 매끄럽게 handoff한다.

**`dx-code-analyzer-run`이 여기로 위임할 때:** 사용자가 "scan my code" / "run code analyzer"라 했는데 실패하면(CLI 없음, 플러그인 미설치, 스캔 에러) `dx-code-analyzer-run`이 이 스킬로 위임한다. 이때 (1) 진단·수정 플로우(Step 2A) 실행, (2) 모든 게 동작하면 **멈추지 말고 자동으로 스캔 진행** — 원래 의도가 스캔이었으므로, (3) `dx-code-analyzer-run` 동작으로 실행을 되돌린다.

**이 스킬이 `dx-code-analyzer-run`으로 넘길 때:** 성공적 구성 작업 후 스캔을 제안한다 ("Setup complete! Want me to run a scan?", "Config updated — want to scan and verify?"). 사용자가 yes면 `dx-code-analyzer-run` 동작으로 진행.

**의도가 두 스킬에 걸칠 때:** end-to-end 처리. "not working" → 진단 → 수정 → 스캔. "Set up and scan" → 설치 → 스캔. "Disable ESLint and scan Apex" → config 편집 → `--rule-selector pmd`로 실행. 항상 사용자의 최종 의도까지 따라간다.

---

## 핵심 규칙·가드레일

| 제약 | 근거 |
|-----------|-----------|
| 사용자가 커스터마이징을 요청할 때만 YAML 생성 | 파일 없이도 기본값이 동작 — 보일러플레이트 만들지 않음 |
| YAML은 프로젝트 루트에만 배치 | CLI가 CWD에서 `code-analyzer.yml`을 자동 발견 |
| override만 작성, 기본값 중복 금지 | 파일을 최소·의도적으로 유지 |
| 생성은 Write, 수정은 Edit 도구 | 기존 설정 보존 |
| 모든 변경 후 검증 | `sf code-analyzer config`가 YAML 에러를 잡음 |
| 전제조건 설치 전 사용자에게 질문 | 동의 없이 자동 설치 금지 |
| 기존 config를 묻지 않고 삭제 금지 | 사용자 커스텀 설정이 있을 수 있음 |
| 설정 후 스캔 제안 | 루프를 닫음 — 스캔 없는 설정은 미완성 |

### Gotchas

| 문제 | 해결 |
|-------|----------|
| Config가 적용 안 됨 | CWD에 `code-analyzer.yml`이 있어야 하거나 `--config-file` 사용 |
| YAML 검증 실패 | 공백만 사용(탭 금지), 콜론 간격 확인 |
| SFGE out of memory | engines 섹션의 `java_max_heap_size` 증가 |
| ESLint 규칙 누락 | `auto_discover_eslint_config: true` 설정 |

전체 트러블슈팅은 `<skill_dir>/references/troubleshooting.md` 참조.

---

## 번들 파일

`<skill_dir>`는 SKILL.md가 있는 디렉터리의 절대 경로.

| 파일 | 용도 |
|------|------|
| `scripts/check-prerequisites.sh` | 환경 확인 |
| `scripts/generate-config.sh` | 프로젝트 타입 자동 감지 후 config 생성 |
| `scripts/validate-config.sh` | 변경 후 YAML 검증 |
| `references/config-schema.md` | 전체 YAML 스키마 문서 |
| `references/diagnostic-flow.md` | Step 2A: 계층형 진단 절차·수정표 |
| `references/rule-name-resolution.md` | Step 6.1: fuzzy 규칙 이름 lookup 전략·매핑 |
| `references/engine-prerequisites.md` | 엔진별 설치 안내 |
| `references/ci-cd-templates.md` | CI/CD 파이프라인 템플릿 |
| `references/troubleshooting.md` | 흔한 설정 이슈·수정 |
| `examples/apex-project-config.yml` | Apex 전용 프로젝트 config |
| `examples/lwc-project-config.yml` | LWC 전용 프로젝트 config |
| `examples/fullstack-project-config.yml` | Apex + LWC + Flow config |
| `examples/ci-github-actions.yml` | GitHub Actions 워크플로 |

---

## 관련 노트
- [[dx-code-analyzer-run]]
- [[dx-org-switch]]
- [[dx-app-analytics-query]]
