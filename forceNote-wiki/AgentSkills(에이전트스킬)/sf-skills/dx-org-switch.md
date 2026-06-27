---
tags: [agent-skill, sf-skills, dx, tooling, cli, org]
source: forcedotcom/sf-skills (skills/dx-org-switch/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [dx-org-switch, 기본 org 전환 스킬, target-org 변경, sf config set target-org, default org switch]
---

# dx-org-switch — Salesforce 기본 org 전환 스킬

> Salesforce CLI(`sf` v2+)로 CLI 명령이 실행되는 활성 org(default `target-org`)를 전환하는 에이전트 스킬.

---

## 목적과 활성화 조건

사용자가 CLI 명령이 어떤 org를 대상으로 실행될지 바꾸고 싶을 때 사용한다. 트리거 표현 예시: "switch org", "change default org", "set my org to", "use alias", "point to", 또는 특정 org·scratch org·sandbox·production을 대상으로 작업하고 싶다는 서술.

호환성: Salesforce CLI (`sf`) v2+

---

## 워크플로 / 단계

### 1. org 식별

사용자가 username 또는 alias(`orgIdentifier`)를 제공한다. 제공하지 않으면 인증된 org 목록을 보여주고 어느 것을 쓸지 묻는다.

```bash
sf org list
```

### 2. 기본 org 설정

- **로컬 (기본):** 현재 프로젝트 디렉터리 내에서만 적용. 일반 프로젝트 작업에 사용.

```bash
sf config set target-org <orgIdentifier>
```

- **글로벌 (사용자가 명시적으로 요청할 때만):** 모든 디렉터리에 시스템 전역 적용. 프로젝트 밖에서 작업하거나 사용자가 전역 범위를 요청할 때 사용.

```bash
sf config set target-org <orgIdentifier> --global
```

- 실패하면 에러를 보고하고, org가 인증되지 않았을 수 있으니 `sf org login web` 실행을 제안한다.

### 3. 검증

```bash
sf config get target-org --json
```

- 주의: JSON 출력에는 scope/location 필드가 없어 값이 로컬인지 글로벌인지 확인할 수 없다. 값만 확인한다. 예: `target-org is now set to: <value>`
- 실패하면 에러를 보고하고 `sf config get target-org` 실행을 권한다.

---

## 핵심 규칙·가드레일

- Unified CLI는 `target-org`, `target-dev-hub` 같은 키를 쓴다. 레거시 sfdx 키(`defaultusername`, `defaultdevhubusername`)는 이 맥락에서 deprecated.
- `sf` CLI의 config set에는 `--local` 또는 `--scope` 플래그가 **없다**. 로컬 범위가 기본 동작이다.
- config를 설정해도 org가 바뀌지 않으면 `SF_TARGET_ORG` 환경 변수가 설정돼 있는지 확인한다 — 환경 변수가 config 값을 override한다.
- Salesforce CLI config(unified) 레퍼런스: https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_config_commands_unified.htm#cli_reference_config_set_unified

---

## 번들 파일

- `SKILL.md` — 단일 번들 파일 (28줄, references/examples/scripts 없음)
- frontmatter: `compatibility: Salesforce CLI (sf) v2+`, `version: 1.0`

---

## 관련 노트
- [[dx-code-analyzer-run]]
- [[dx-code-analyzer-configure]]
- [[dx-app-analytics-query]]
