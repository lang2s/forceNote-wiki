---
tags: [agent-skill, sf-skills, reference, dx, code-analyzer, command-examples]
source: forcedotcom/sf-skills (skills/dx-code-analyzer-run/references/command-examples.md, 공식 Salesforce)
created: 2026-06-27
aliases: [Command Construction Examples, 명령어 구성 예시, 스캔 시나리오, rule-selector 예시]
---
# Command Construction Examples — 명령어 구성 예시

> 사용자의 자연어 요청별로 대응하는 `sf code-analyzer run` 명령어 전체 예시. 모든 명령어는 사전에 생성한 `${TIMESTAMP}`를 사용한다.

---

Full command examples for common scanning scenarios.

**Note:** All commands use `${TIMESTAMP}` which should be generated via `TIMESTAMP=$(date +%Y%m%d-%H%M%S)` before running the scan.

```bash
# Generate the timestamp once before any scan
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
```

| User Request | Constructed Command |
|---|---|
| "Scan my code" | `sf code-analyzer run --rule-selector Recommended --output-file "./code-analyzer-results-${TIMESTAMP}.json" --include-fixes` |
| "Check for security issues" | `sf code-analyzer run --rule-selector Security --output-file "./code-analyzer-results-${TIMESTAMP}.json" --include-fixes` |
| "Run PMD on my Apex" | `sf code-analyzer run --rule-selector pmd --target "**/*.cls,**/*.trigger" --output-file "./code-analyzer-results-${TIMESTAMP}.json" --include-fixes` |
| "Check only my changed files" | `git diff --name-only main...HEAD \| grep -E '...' → sf code-analyzer run --target <files> --output-file "./code-analyzer-results-${TIMESTAMP}.json" --include-fixes` |
| "Find duplicate code" | `sf code-analyzer run --rule-selector cpd --output-file "./code-analyzer-results-${TIMESTAMP}.json"` |
| "Check vulnerable libraries" | `sf code-analyzer run --rule-selector retire-js --output-file "./code-analyzer-results-${TIMESTAMP}.json"` |
| "Run deep security analysis" | `sf code-analyzer run --rule-selector sfge --workspace "force-app" --target "force-app" --output-file "./code-analyzer-results-${TIMESTAMP}.json" --include-fixes` |
| "Critical PMD violations in this file" | `sf code-analyzer run --rule-selector "pmd:1" --target <file> --output-file "./code-analyzer-results-${TIMESTAMP}.json" --include-fixes` |
| "ESLint performance on LWC" | `sf code-analyzer run --rule-selector "eslint:Performance" --target "**/lwc/**" --output-file "./code-analyzer-results-${TIMESTAMP}.json" --include-fixes` |
| "AppExchange security review" | `sf code-analyzer run --rule-selector all --output-file "./code-analyzer-results-${TIMESTAMP}.json" --include-fixes` |
| "Generate HTML report" | `sf code-analyzer run --rule-selector Recommended --output-file "./code-analyzer-results-${TIMESTAMP}.html" --include-fixes` |
| "Scan with severity threshold 2" | `sf code-analyzer run --rule-selector Recommended --severity-threshold 2 --output-file "./code-analyzer-results-${TIMESTAMP}.json" --include-fixes` |
| "Run ApexCRUDViolation rule" | `sf code-analyzer run --rule-selector "pmd:ApexCRUDViolation" --output-file "./code-analyzer-results-${TIMESTAMP}.json" --include-fixes` |
| "Scan my Flows" | `sf code-analyzer run --rule-selector flow --output-file "./code-analyzer-results-${TIMESTAMP}.json"` |
| "Check ESLint recommended rules" | `sf code-analyzer run --rule-selector "eslint:Recommended" --output-file "./code-analyzer-results-${TIMESTAMP}.json" --include-fixes` |
| "Scan all with fail on high" | `sf code-analyzer run --rule-selector all --severity-threshold 2 --output-file "./code-analyzer-results-${TIMESTAMP}.json" --include-fixes` |
| "What rules are available for security?" | `sf code-analyzer rules --rule-selector Security --view detail` |
| "Scan this file for performance" | `sf code-analyzer run --rule-selector Performance --target <file> --output-file "./code-analyzer-results-${TIMESTAMP}.json" --include-fixes` |
| "Run all rules, no suppressions" | `sf code-analyzer run --rule-selector all --no-suppressions --output-file "./code-analyzer-results-${TIMESTAMP}.json" --include-fixes` |

## 관련 노트
- [[dx-code-analyzer-run]]
- [[flag-reference]]
- [[quick-start]]
