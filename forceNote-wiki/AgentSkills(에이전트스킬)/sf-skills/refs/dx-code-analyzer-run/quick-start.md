---
tags: [agent-skill, sf-skills, reference, dx, code-analyzer, quick-start]
source: forcedotcom/sf-skills (skills/dx-code-analyzer-run/references/quick-start.md, 공식 Salesforce)
created: 2026-06-27
aliases: [Quick Start, 빠른 시작, 최소 명령어, code-analyzer run]
---
# Quick Start: Minimum Viable Commands — 최소 실행 명령어

> 확신이 서지 않을 때 그대로 복사해 쓰는 `sf code-analyzer run` 최소 명령어 모음. 항상 타임스탬프 변수를 먼저 생성한 뒤 출력 파일명에 사용한다.

---

If you're unsure about anything, use these EXACT commands as starting points.

**IMPORTANT:** Always generate a timestamp variable FIRST, then use it in the output filename:
```bash
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
```

Then use it:
```bash
# Simplest scan (entire workspace, recommended rules)
sf code-analyzer run --output-file "./code-analyzer-results-${TIMESTAMP}.json" --include-fixes

# Scan specific target
sf code-analyzer run --target "force-app/main/default" --output-file "./code-analyzer-results-${TIMESTAMP}.json" --include-fixes

# Scan for security
sf code-analyzer run --rule-selector Security --output-file "./code-analyzer-results-${TIMESTAMP}.json" --include-fixes

# Scan specific engine
sf code-analyzer run --rule-selector pmd --output-file "./code-analyzer-results-${TIMESTAMP}.json" --include-fixes

# Scan with HTML report (only if user explicitly asks for HTML)
sf code-analyzer run --output-file "./code-analyzer-results-${TIMESTAMP}.html" --include-fixes
```

**After the command completes**, read the output file and present a summary to the user.

## 관련 노트
- [[dx-code-analyzer-run]]
- [[command-examples]]
- [[flag-reference]]
