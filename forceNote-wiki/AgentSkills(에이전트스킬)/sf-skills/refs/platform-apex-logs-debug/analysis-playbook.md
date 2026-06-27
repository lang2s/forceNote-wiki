---
tags: [agent-skill, sf-skills, reference, platform, debug, playbook]
source: forcedotcom/sf-skills (skills/platform-apex-logs-debug/references/analysis-playbook.md, 공식 Salesforce)
created: 2026-06-27
aliases: [Debug Analysis Playbook, 디버그 분석 플레이북, 로그 분석 워크플로우, 심각도 분류, 수정 제안]
---
# Debug Analysis Playbook — 디버그 분석 플레이북

> `platform-apex-logs-debug` 스킬이 활성화됐을 때 따르는 확장 워크플로우 — 컨텍스트 수집, 로그 조회, 분석 순서, 심각도 분류, 수정 제안, 인접 스킬 연동.

Use this playbook when `platform-apex-logs-debug` is active and you need the expanded workflow.

## 1. Gather context

Collect:
- org alias
- failing transaction or test context
- approximate time window
- relevant user / record / request identifiers

## 2. Retrieve logs

Preferred commands:

```bash
sf apex list log --target-org <alias> --json
sf apex get log --log-id <id> --target-org <alias>
sf apex tail log --target-org <alias> --color
```

See [cli-commands.md](cli-commands.md) for more options.

## 3. Analyze in this order

1. transaction entry point
2. exceptions and fatal errors
3. governor limits
4. SOQL / DML repetition patterns
5. CPU / heap hotspots
6. callout timing and external failures

## 4. Classify severity

- **Critical** — runtime failure, hard limit, data corruption risk
- **Warning** — near-limit, non-selective query, slow path
- **Info** — optimization opportunity, cleanup item, observability gap

## 5. Propose fixes

Prefer fixes that are:
- root-cause oriented
- bulk-safe
- testable
- deployable in one clean change set

## 6. Loop with adjacent skills

- use `sf-apex` for code fixes
- use `platform-apex-test-run` to reproduce and verify
- use `platform-metadata-deploy` to deploy fixes
- use `platform-data-manage` when the issue depends on missing or malformed test data

## 관련 노트
- [[platform-apex-logs-debug]]
- [[platform-apex-logs-debug/cli-commands|cli-commands]]
- [[common-issues]]
