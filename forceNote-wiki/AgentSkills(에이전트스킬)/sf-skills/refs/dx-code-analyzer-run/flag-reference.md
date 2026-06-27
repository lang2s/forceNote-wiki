---
tags: [agent-skill, sf-skills, reference, dx, code-analyzer, flag-reference]
source: forcedotcom/sf-skills (skills/dx-code-analyzer-run/references/flag-reference.md, 공식 Salesforce)
created: 2026-06-27
aliases: [Flag Reference, 플래그 레퍼런스, rule-selector 문법, output-file 확장자, v4 플래그]
---
# Flag Reference for `sf code-analyzer run` — 플래그 전체 레퍼런스

> v4+ `sf code-analyzer run`의 모든 유효 플래그, v3에서 제거된 무효 플래그, rule-selector 표현식 문법, 출력 포맷 확장자 매핑을 정리한 레퍼런스.

---

Complete reference for all flags available in the `sf code-analyzer run` command (v4+).

## Valid Flags

| Flag | Short | Type | Description | Default |
|------|-------|------|-------------|---------|
| `--rule-selector` | `-r` | String | Rule selection expression (engine, category, severity, or specific rule) | `Recommended` |
| `--target` | `-t` | String[] | Files/folders/globs to scan (comma-separated) | Current directory |
| `--workspace` | `-w` | String | Workspace root directory | `.` (current directory) |
| `--output-file` | `-f` | String[] | Output file path(s) — format determined by extension (.json, .html, .sarif, .csv, .xml) | None (terminal only) |
| `--view` | `-v` | String | Terminal display format: `table` or `detail` | None |
| `--severity-threshold` | `-s` | Number | Exit non-zero if violations at or above this level (1-5) | None |
| `--config-file` | `-c` | String | Path to code-analyzer.yml configuration file | None |
| `--include-fixes` | | Boolean | Include fix data in results (enables auto-fix capability) | `false` |
| `--include-suggestions` | | Boolean | Include suggestion data in results | `false` |
| `--no-suppressions` | | Boolean | Ignore suppression markers in code | `false` |
| `--target-org` | `-o` | String | Salesforce org username or alias (required for ApexGuru engine) | None |

## Invalid Flags (DO NOT USE)

These flags existed in v3 but were removed in v4+. Using them causes errors:

| Deprecated Flag | Error Message | Replacement |
|----------------|---------------|-------------|
| `--format` | `Unknown flag: --format` | Use `--output-file <path>.<ext>` where extension determines format |
| `--format table` | `Unknown flag: --format` | Use `--view table` or `--view detail` |
| `--engine` | `Unknown flag: --engine` | Use `--rule-selector <engine>` |
| `--category` | `Unknown flag: --category` | Use `--rule-selector <category>` |
| `--json` | `Unknown flag: --json` | Use `--output-file "./results.json"` |

## Rule Selector Syntax

The `--rule-selector` flag uses a flexible expression syntax:

| Syntax | Description | Example |
|--------|-------------|---------|
| `<engine>` | Select all rules from an engine | `pmd`, `eslint`, `cpd` |
| `<category>` | Select rules by category | `Security`, `Performance` |
| `<severity>` | Select rules by severity (1-5) | `1`, `2`, `(1,2)` |
| `<engine>:<category>` | Engine AND category | `pmd:Security` |
| `<engine>:<severity>` | Engine AND severity | `eslint:2` |
| `(<a>,<b>)` | OR grouping | `(pmd,eslint)` for PMD OR ESLint |
| `<a>:<b>:<c>` | Multiple AND conditions | `pmd:Security:1` for PMD AND Security AND Severity 1 |
| `<engine>:<ruleName>` | Specific rule | `pmd:ApexCRUDViolation` |
| `all` | All available rules | `all` |
| `Recommended` | Default recommended rule set | `Recommended` (default) |

### Complex Rule Selector Examples

```bash
# PMD OR ESLint, Security category, Severity 1 or 2
--rule-selector "(pmd,eslint):Security:(1,2)"

# All Security rules across all engines
--rule-selector "Security"

# Specific rule from PMD
--rule-selector "pmd:ApexCRUDViolation"

# All rules from CPD (duplicate detection)
--rule-selector "cpd"

# High and Critical severity across all engines
--rule-selector "(1,2)"
```

## Output Format Extensions

The `--output-file` flag determines format by file extension:

| Extension | Format | Use Case |
|-----------|--------|----------|
| `.json` | JSON | Programmatic parsing, default for this skill |
| `.html` | HTML | Human-readable report for browser viewing |
| `.sarif` | SARIF | IDE integration (VS Code, IntelliJ) or GitHub Advanced Security |
| `.csv` | CSV | Spreadsheet import (Excel, Google Sheets) |
| `.xml` | XML | Legacy CI/CD systems |

You can specify multiple output files in a single run:
```bash
--output-file "./results.json" --output-file "./report.html"
```

## Why These Constraints Exist

**v4+ CLI redesign:** The Code Analyzer plugin underwent a major redesign from v3 to v4+:
- Old flags (`--format`, `--engine`, `--category`) were removed for a more flexible `--rule-selector` expression syntax
- Output format is now determined by file extension rather than a separate flag
- Terminal display was separated into `--view` flag
- These changes provide more flexibility but require different syntax than v3 documentation shows

**Always use `--output-file` for results:** Terminal stdout can be truncated, interrupted, or mixed with other output. Writing to a file ensures complete, parseable results.

**Foreground execution with timeout:** SFGE (Salesforce Graph Engine) scans can take 10-20 minutes for large codebases. Running in foreground with `timeout: 1200000` (20 minutes) ensures the scan completes and output is captured.

## 관련 노트
- [[dx-code-analyzer-run]]
- [[command-examples]]
- [[engine-reference]]
