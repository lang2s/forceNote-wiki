---
tags: [sf-mcp, mcp, salesforce-dx, code-analyzer, tools, static-analysis]
source: salesforcecli/mcp (packages/mcp-provider-code-analyzer/, 공식 Salesforce)
created: 2026-06-27
aliases: [mcp-provider-code-analyzer, Code Analyzer MCP, run_code_analyzer, 커스텀 룰 생성, XPath PMD 룰, 정적 분석 MCP]
---

# mcp-provider-code-analyzer — 코드 애널라이저 도구

> Salesforce DX MCP 서버에 Code Analyzer(정적 분석) 기능을 6개 MCP 도구로 노출하는 provider 패키지 — 코드 스캔·룰 조회·결과 질의·커스텀 룰(PMD XPath / Regex) 생성을 담당한다.

---

## 역할

`@salesforce/mcp` 모노레포의 한 provider 패키지로, `CodeAnalyzerMcpProvider`(McpProvider 서브클래스) 하나를 export한다. `provideTools(services)`가 호출되면 Code Analyzer 관련 MCP 도구 6개를 생성해 반환한다. 모든 도구는 `Toolset.CODE_ANALYSIS` 툴셋에 속한다.

```ts
// 출처: src/index.ts — provideTools()가 등록하는 6개 도구
new CodeAnalyzerRunMcpTool(...)            // run_code_analyzer (GA)
new CodeAnalyzerDescribeRuleMcpTool(...)   // describe_code_analyzer_rule (GA)
new CodeAnalyzerListRulesMcpTool(...)      // list_code_analyzer_rules (GA)
new CodeAnalyzerQueryResultsMcpTool(...)   // query_code_analyzer_results (GA)
new GenerateXpathPromptMcpTool(...)        // get_ast_nodes_to_generate_xpath (NON_GA)
new CreateCustomRuleMcpTool(...)           // create_custom_rule (NON_GA)
```

- 실제 분석 엔진은 `@salesforce/code-analyzer-core` / `@salesforce/code-analyzer-engine-api` / `@salesforce/code-analyzer-pmd-engine` (외부 의존성). 이 패키지는 그 위에 MCP 도구 래퍼·룰 생성 파이프라인·텔레메트리를 얹는다.
- 각 도구는 얇은 래퍼(입력 검증·정책·텔레메트리)이고 실제 로직은 `src/actions/*` Action 구현 또는 `src/strategies/*` 전략에 위임한다.
- `index.ts` 주석에 따르면 `create_regex_rule` 도구는 **등록되지 않는다**(코드에는 참고용으로 남아 있음). regex 룰은 `create_custom_rule`에 `engine: "regex"`로 생성한다.
- 텔레메트리: `services.getTelemetryService()`로 주입. 이벤트명 `code-analyzer`, source `MCP`. 이벤트: `engine_selection`, `engine_execution`, `results_query`, `custom_rule_created`, `xpath_prompt_generated`.
- 경로 검증: 파일/디렉터리 입력은 `sanitizePath`로 절대경로 + traversal(`..`) 없음을 강제한다.

> 패키지 README는 "For Internal Use Only — 내부용, 사전 호환성 보장 없음"으로 표기되어 있다.

---

## 제공 도구 (6개)

### 1. `run_code_analyzer` (GA, `readOnlyHint: false`)

코드에 정적 분석을 실행한다. 결과 JSON 파일을 생성하고 그 절대경로와 성공/실패 상태를 반환한다.

| 입력 | 타입 | 설명 |
|---|---|---|
| `target` | string[] (필수) | 스캔할 파일들의 **절대경로** 배열. 1~10개(`MAX_ALLOWABLE_TARGET_COUNT = 10`). 디렉터리 불가, 존재해야 함. |
| `directory` | string (필수) | 워크스페이스/프로젝트 루트 절대경로. 이 안에서 `code-analyzer.yml` / `code-analyzer.yaml` config를 자동 탐색. 없으면 기본 설정 사용. |
| `selector` | string (선택) | 실행할 룰 선택자. 생략 시 `"recommended"` 룰 실행. |
| `configPath` | string (선택) | config 파일이 비표준 이름/위치일 때. 제공 시 `directory` 내 config보다 **우선**. |

- 출력: `status`("success" 또는 에러 메시지), `resultsFile`(결과 JSON 절대경로), `summary` = `{ total, sev1, sev2, sev3, sev4, sev5 }`(심각도별 위반 수).
- 결과 파일은 `os.tmpdir()`에 `code-analyzer-results-<YYYY_MM_DD_HH_mm_ss_SSS>.json` 형식, OutputFormat.JSON으로 기록.
- selector에 미지원 엔진 `sfge` 또는 `flow`가 포함되면 토큰 경계 매칭으로 감지해 거부(`Unsupported engine(s)...`).
- 후속: `query_code_analyzer_results`로 결과 파일을 필터링·설명.

### 2. `list_code_analyzer_rules` (GA, `readOnlyHint: true`)

selector에 매칭되는 룰 목록을 반환한다.

| 입력 | 타입 | 설명 |
|---|---|---|
| `selector` | string (필수) | 콜론(`:`) 구분 토큰. 같은 타입 토큰은 괄호+콤마로 OR — `(Performance,Security)`. |
| `allowFullList` | boolean (선택) | 전체 룰 목록 반환 명시적 opt-in. 기본 false, 권장 안 함. |

- 정책: selector가 전체 미필터 목록으로 귀결되면 `allowFullList=true`가 없는 한 거부(`POLICY_FULL_LIST_REJECTED`). 최소 2개 필터 권장(예: `pmd:Security`).
- selector 토큰은 `validateSelector`로 사전 검증(허용 토큰 집합과 대소문자 무시 비교). 무효 토큰이 있으면 `Invalid selector token(s): ...` 반환.
- 출력: `rules[]` = `{ name, engine, severity(1~5, 낮을수록 더 심각), tags[] }`.
- 응답에 "describe_code_analyzer_rule 로 상세 조회하라"는 팁 텍스트가 함께 붙는다.

### 3. `query_code_analyzer_results` (GA, `readOnlyHint: true`)

`run_code_analyzer`가 만든 결과 JSON 파일을 읽어 위반을 필터링·정렬해 반환한다.

| 입력 | 타입 | 설명 |
|---|---|---|
| `resultsFile` | string (필수) | 결과 JSON 절대경로. |
| `selector` | string (필수) | list-rules와 동일 의미. `rule=MyRuleName`, `file=src/app` 같은 키 필터도 지원. |
| `topN` | int (기본 = `DEFAULT_TOPN_POLICY_LIMIT`, max 1000) | 필터·정렬 후 반환 최대 개수. |
| `allowLargeResultSet` | boolean (선택) | `DEFAULT_TOPN_POLICY_LIMIT` 초과 요청 opt-in. 기본 false. |
| `sortBy` | enum (선택) | `severity` / `rule` / `engine` / `file` / `none`. |
| `sortDirection` | enum (선택) | `asc` / `desc`. |

- 정책: 기본적으로 상위 N개만 반환. 초과 시 `allowLargeResultSet=true` + `topN` 상향 필요. 잘리면 "Showing only the first N..." 안내 텍스트 추가.
- 출력: `status`, `resultsFile`, `totalViolations`, `totalMatches`(필터 후·topN 전), `violations[]` = `{ rule, engine, severity, severityName, tags[], message, primaryLocation{file,startLine,startColumn}, resources[] }`.
- `results_query` 텔레메트리 이벤트 emit(성공/실패 모두).

### 4. `describe_code_analyzer_rule` (GA, `readOnlyHint: true`)

특정 룰의 상세 설명을 반환한다(수정 방법 정보 포함 가능).

| 입력 | 타입 | 설명 |
|---|---|---|
| `ruleName` | string (필수) | 룰 이름. |
| `engineName` | string (필수) | 룰이 속한 엔진. 동명 룰의 모호성 해소용. |

- 출력: `rule` = `{ name, engine, severity, tags[], description, resources[] }`(resources는 비어 있을 수 있는 문서 링크 배열).
- 사용 시점: 결과 파일만으로 위반을 못 고칠 때, 또는 특정 룰/위반 정보를 요청받았을 때.

### 5. `get_ast_nodes_to_generate_xpath` (NON_GA, `readOnlyHint: false`)

> 클래스명은 `GenerateXpathPromptMcpTool`(파일 `generate_xpath_prompt.ts`)이나, 실제 등록되는 도구 **이름은 `get_ast_nodes_to_generate_xpath`**, title은 "Generate XPath Prompt".

PMD XPath 기반 커스텀 룰 생성의 **1단계**. 위반 샘플 코드의 AST를 덤프해, XPath 작성을 LLM에게 안내하는 프롬프트를 생성한다.

| 입력 | 타입 | 설명 |
|---|---|---|
| `sampleCode` | string (필수) | 의도한 룰을 **위반하는** 최소·자족적 스니펫. |
| `language` | string (필수) | 샘플 코드 언어(예: `apex`, `visualforce`). |
| `engine` | string (필수) | 분석 엔진. 현재 `pmd`만 지원. |

- 검증: engine은 `pmd`만, language는 **Apex / Visualforce만** AST 노드 반환. 그 외 언어는 "직접 XPath를 만들어 create_custom_rule을 바로 호출하라"는 안내 반환.
- 출력: `status`, `prompt`(AST 노드+메타데이터로 채워진 XPath 작성 가이드 텍스트). 임시 파일을 만들어 AST를 생성하고 자동 정리한다.
- 후속: 생성된 XPath로 `create_custom_rule`(engine `pmd`) 호출.

### 6. `create_custom_rule` (NON_GA, `readOnlyHint: false`, `destructiveHint: false`, `openWorldHint: false`)

커스텀 룰을 생성한다. 엔진에 따라 두 전략으로 분기(strategy 패턴).

공통 필수 입력: `engine`("pmd" 또는 "regex"), `ruleName`, `description`, `workingDirectory`(절대경로).

**PMD (XPath 기반 — Apex/Visualforce 등):**

| 입력 | 설명 |
|---|---|
| `xpath` | 위반을 매칭할 XPath 식 (필수). Apex/VF는 `get_ast_nodes_to_generate_xpath`로 먼저 생성 권장. |
| `language` | 룰 언어(예: `apex`, `visualforce`) (필수). |
| `priority` | PMD 우선순위 정수 1~5 (필수). |

→ 출력: `ruleXml`, `rulesetPath`(`custom-rules/<slug>-pmd-rules.xml` 생성), `configPath`(`code-analyzer.yml` 신규 생성 또는 갱신).

**Regex (패턴 기반):**

| 입력 | 설명 |
|---|---|
| `regex` | `/pattern/flags` 형식 (필수, 예 `/todo/gi`). |
| `violationMessage` | 위반 시 표시 메시지 (필수). |
| `tags` | 태그 배열 (필수, 최소 1개). |
| `severity` | 1~5 (필수, 1=Critical … 5=Info). |
| `fileExtensions` | (선택) 스캔 확장자 배열, 각 항목은 `.`로 시작해야 함(예 `.cls`). |
| `regexIgnore` | (선택) 제외 패턴. |
| `includeMetadata` | (선택) 메타데이터 포함 플래그. |

→ 출력: `ruleYaml`, `configPath`(`code-analyzer.yml`의 `engines.regex.custom_rules`에 인라인 추가).

- 미지원 엔진을 주면 `Unsupported engine: '...'. Supported engines: pmd, regex` 반환.
- 성공 시 `custom_rule_created` 텔레메트리 emit.

---

## 선택자(selector) 토큰 레퍼런스

`run` / `list` / `query` 도구가 공유하는 토큰 어휘(`src/constants.ts`):

| 범주 | 값 |
|---|---|
| 엔진 | `eslint`, `regex`, `retire-js`, `flow`, `pmd`, `cpd`, `sfge` |
| 심각도(이름) | `Critical`, `High`, `Moderate`, `Low`, `Info` |
| 심각도(숫자) | `1`, `2`, `3`, `4`, `5` (1=Critical … 5=Info, 낮을수록 더 심각) |
| 일반 태그 | `Recommended`, `Custom`, `All` |
| 카테고리 | `BestPractices`, `CodeStyle`, `Design`, `Documentation`, `ErrorProne`, `Security`, `Performance` |
| 언어 | `Apex`, `CSS`, `HTML`, `JavaScript`, `TypeScript`, `Visualforce`, `XML` |
| 엔진별 태그 | `DevPreview`, `LWC` |

```text
// selector 예시
"WhileLoopsMustUseBraces"          // 이름으로 특정 룰
"Security:pmd"                      // Security 태그 PMD 룰
"Critical"                         // 모든 Critical 룰
"(Security,Performance):eslint"    // Security OR Performance 태그의 ESLint 룰
"pmd:(Performance,Security):2"     // PMD + (Performance OR Security) + 심각도 2
"rule=MyRuleName"                  // (query 전용) 룰명 필터
"file=src/app"                     // (query 전용) 파일경로 필터
```

> `run_code_analyzer`는 selector의 `sfge`·`flow`를 거부한다(이 도구는 미지원 엔진). `list`/`query`의 토큰 어휘에는 포함되어 있다.

---

## 아키텍처

도구 래퍼(`src/tools/`) → Action(`src/actions/`) 또는 Strategy(`src/strategies/`) 위임 구조.

**분석 실행 경로 (run/list/describe):**
- `RunAnalyzerActionImpl` 등은 `CodeAnalyzerConfigFactory` + `EnginePluginsFactory`로 `@salesforce/code-analyzer-core`의 `CodeAnalyzer`를 구성한다.
- run 흐름: config 생성 → `ErrorCapturer`/`TelemetryListener` 부착 → 엔진 플러그인 추가 → `createWorkspace(target)` → `selectRules([selector])`(기본 `recommended`) → `run()` → 결과를 tmp JSON으로 기록 → 심각도별 summary 집계.

**룰 생성 경로 (create_custom_rule):**
- `RuleCreationStrategyFactory`가 `IRuleCreationStrategy` 구현을 엔진명으로 등록·조회한다. 기본 등록: `XPathRuleStrategy`(`pmd`), `RegexRuleStrategy`(`regex`).
- 인터페이스: `validate(input)` → `execute(input)` → `getSupportedEngine()`. 도구는 공통 검증 → 전략 선택 → 엔진별 검증 → 실행 순으로 호출.
- `XPathRuleStrategy` → `CreateXpathCustomRuleActionImpl`: `templates/pmd-ruleset.xml`을 채워 `custom-rules/<slug>-pmd-rules.xml` 작성 후 `code-analyzer.yml`의 `engines.<engine>.custom_rulesets`에 상대경로 upsert(없으면 `templates/code-analyzer.yml`로 신규 생성). config 우선순위 `.yaml` > `.yml`.
- `RegexRuleStrategy` → `CreateRegexCustomRuleActionImpl`: 별도 XML 없이 config의 `engines.regex.custom_rules`에 YAML 인라인 추가.

**AST 파이프라인 (XPath 프롬프트용):**
- `AstNodePipeline`(Template Method): `run()` = `generateAstXml` → `extractNodes` → `enrichMetadata`. `PmdAstNodePipeline`이 PMD용으로 오버라이드.
- `engines/engine-strategies.ts`의 `EngineStrategy` = `{ astGenerator, metadataProvider, promptBuilder }`. `getEngineStrategy("pmd")`만 지원(그 외 throw).
  - `PmdAstGenerator`: `generateAstXmlFromSource(code, language)`.
  - `pmd-engine-adapter.ts` `PmdEngineAstXmlAdapter`: `@salesforce/code-analyzer-pmd-engine`의 `PmdEngine.generateAst()`를 임시 파일에 대해 호출(CLI 대신 엔진 API 직접 사용). 소스 크기 상한 `MAX_SOURCE_BYTES = 1,000,000`바이트. 언어 정규화(`vf`→`visualforce`, `js`/`ecmascript`→`javascript` 등).
  - `extract-ast-nodes.ts`: `fast-xml-parser`로 AST XML을 ancestry 포함 평면 노드 목록(`AstNode`)으로 파싱.
  - `PmdAstMetadataProvider`: `data/pmd/{apex,visualforce,html,javascript}-ast-reference.json`에서 노드 메타데이터 보강(없으면 빈 배열).
  - `PmdPromptBuilder.buildPrompt`: AST 노드+메타데이터 + 언어별 가이드(Apex/Visualforce 패턴 템플릿)로 XPath 작성 프롬프트를 조립.

---

## 관련 노트
- [[sf-mcp - 개요]] — sf-mcp 서버 전체 개요
- [[mcp-provider-api]]
