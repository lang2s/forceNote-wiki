---
tags: [agent-skill, sf-skills, reference, dx, code-analyzer, engine-reference]
source: forcedotcom/sf-skills (skills/dx-code-analyzer-run/references/engine-reference.md, 공식 Salesforce)
created: 2026-06-27
aliases: [Engine Reference, 엔진 레퍼런스, 파일 타입 지원, 룰 태그, engine file type]
---
# Engine Reference — 엔진별 파일 타입 및 룰 태그

> 각 Code Analyzer 엔진(pmd, eslint, cpd, retire-js, regex, flow, sfge, apexguru)이 지원하는 파일 확장자와, rule selector에 사용할 수 있는 공통 룰 태그 목록.

---

## Engine File Type Support

| Engine | File Extensions |
|---|---|
| **pmd** | `.cls`, `.trigger`, `.js`, `.html`, `.htm`, `.vfp`, `.component`, `.page`, `.xml` |
| **eslint** | `.js`, `.ts`, `.jsx`, `.tsx` |
| **cpd** | `.cls`, `.trigger`, `.js`, `.ts`, `.html`, `.htm`, `.vfp`, `.component`, `.page`, `.xml` |
| **retire-js** | `.js`, `.ts`, `package.json`, `package-lock.json` |
| **regex** | Configurable per rule via `file_extensions` |
| **flow** | `.flow-meta.xml` |
| **sfge** | `.cls`, `.trigger` |
| **apexguru** | `.cls`, `.trigger` |

## Common Rule Tags

These tags can be used in rule selectors:

| Tag | Meaning |
|---|---|
| `Recommended` | Default ruleset — curated for most projects |
| `Security` | Security vulnerabilities (CRUD, XSS, injection, crypto) |
| `Performance` | Performance anti-patterns (SOQL in loops, limits) |
| `BestPractices` | Coding standards and conventions |
| `CodeStyle` | Naming, formatting, braces |
| `Design` | Complexity, coupling, architecture |
| `ErrorProne` | Common bug patterns |
| `Documentation` | Missing docs, comments |
| `Apex` | Rules applying to Apex language |
| `JavaScript` | Rules applying to JavaScript |
| `TypeScript` | Rules applying to TypeScript |
| `HTML` | Rules applying to HTML/Visualforce |
| `Custom` | User-defined rules |

These tags appear in a `--rule-selector` expression, for example:

```bash
sf code-analyzer run --rule-selector "Security"
sf code-analyzer run --rule-selector "pmd:Performance"
```

## 관련 노트
- [[dx-code-analyzer-run]]
- [[flag-reference]]
- [[special-behaviors]]
