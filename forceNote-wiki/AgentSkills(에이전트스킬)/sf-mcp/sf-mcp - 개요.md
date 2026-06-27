---
tags: [sf-mcp, mcp, salesforce-dx, ai-tooling, overview]
source: salesforcecli/mcp (README.md + package.json, 공식 Salesforce)
created: 2026-06-27
aliases: [Salesforce DX MCP Server, @salesforce/mcp, DX MCP, MCP 서버, Model Context Protocol Salesforce]
---

# Salesforce DX MCP Server (sf-mcp) — 개요

> LLM(대규모 언어 모델)과 Salesforce org를 안전하게 연결하는 공식 Model Context Protocol(MCP) 서버. `npx @salesforce/mcp`로 실행하며 toolset 단위로 60여 개 MCP 도구를 선택 활성화한다.

---

## 개요 (무엇인가)

**Salesforce DX MCP Server**는 LLM과 Salesforce org 사이의 상호작용을 매끄럽게 만들기 위해 설계된 전용 Model Context Protocol(MCP) 구현체다. README 원문 정의:

> The Salesforce DX MCP Server is a specialized Model Context Protocol (MCP) implementation designed to facilitate seamless interaction between large language models (LLMs) and Salesforce orgs. This MCP server provides a robust set of tools and capabilities that enable LLMs to read, manage, and operate Salesforce resources securely.

- npm 패키지: **`@salesforce/mcp`** (License: Apache-2.0)
- 저장소: `forcedotcom/mcp` (이슈·Discussion·릴리즈 노트 호스팅)
- 공식 문서: _Salesforce DX Developer Guide_ → "Salesforce DX MCP Server" 섹션 (보안 기능 상세, Quick start, 클라이언트 설정 예시, 코어 도구 샘플 프롬프트 포함)
- VS Code(Copilot), Claude Code, Cline, Cursor, Trae, Windsurf, Zed 등 MCP 클라이언트에서 사용 가능
- 도구는 **toolset**(기능별 도구 묶음) 단위로 선택 활성화. 서버 전체에 60개 이상의 MCP 도구가 있으므로 `--toolsets all`보다 필요한 toolset만 켜는 것을 README가 권장한다(LLM 컨텍스트 절약).

---

## 설정 (MCP 클라이언트 config)

MCP 클라이언트의 MCP JSON 파일을 갱신해 설정한다. 클라이언트마다 파일 위치·키 이름이 조금씩 다르다(VS Code는 `servers`, 그 외 다수 클라이언트는 `mcpServers`). `args` 배열의 형식은 모든 클라이언트에서 동일하다.

README의 VS Code + Copilot 예시 (`.vscode/mcp.json`) — verbatim:

```json
{
  "servers": {
    "Salesforce DX": {
      "command": "npx",
      "args": ["-y", "@salesforce/mcp",
              "--orgs", "DEFAULT_TARGET_ORG",
              "--toolsets", "orgs,metadata,data,users",
              "--tools", "run_apex_test",
              "--allow-non-ga-tools"]
    }
  }
}
```

이 저장소의 로컬 개발용 `.vscode/mcp.json` (로컬 빌드를 직접 실행) — verbatim:

```json
{
  "servers": {
    "Salesforce DX": {
      "command": "node",
      "args": [
        "${workspaceFolder}/packages/mcp/bin/run.js",
        "--toolsets",
        "all",
        "--orgs",
        "DEFAULT_TARGET_ORG",
        "--no-telemetry",
        "--allow-non-ga-tools"
      ]
    }
  }
}
```

설정 시 주의(README):
- `"-y", "@salesforce/mcp"`는 npx가 패키지를 묻지 않고 자동 설치하게 한다. 변경 금지.
- `args`에서는 flag 이름과 값을 모두 큰따옴표로 감싸고 콤마로 구분한다. Boolean flag는 값을 받지 않는다.

### `args` 플래그 (README 표 전수)

| 플래그 | 설명 | 필수 | 비고 |
|---|---|---|---|
| `--orgs` | 로컬에서 인증(authorize)한 하나 이상의 org | **Yes** | 최소 1개 필수. 값은 아래 "org 지정" 참조 |
| `--toolsets` | 기능별로 묶인 도구 집합(toolset) | No | `all`이면 모든 toolset의 모든 도구. 콤마로 다중 지정 |
| `--tools` | 개별 도구 이름 | No | `--toolsets`와 병행 가능. 한 toolset 전체 + 다른 toolset의 도구 1개 식으로 조합 |
| `--allow-non-ga-tools` | GA + NON-GA 도구 모두 사용 허용 (Boolean) | No | 기본값은 GA 도구만 사용 |
| `--dynamic-tools` | (실험적) 동적 도구 탐색·로딩. 최소 코어 도구로 시작해 필요 시 로드 (Boolean) | No | 초기 컨텍스트 크기 축소·LLM 성능 개선용. 기본 비활성. VSCode·Cline에서 동작, 그 외 환경은 미지원 가능 |
| `--debug` | 디버그 로그 출력 요청 (Boolean) | No | 기본 비활성. 일부 클라이언트는 MCP 로그를 노출하지 않아 동작 안 할 수 있음 |
| `--no-telemetry` | 텔레메트리(모니터링·분석용 자동 데이터 수집) 비활성 (Boolean) | No | 텔레메트리는 기본 활성 — 끄려면 이 플래그 지정 |

### `--orgs` 값 (README 표 전수)

org는 사전에 로컬에서 명시적으로 인증해야 한다(`org login web` CLI 명령 또는 VS Code 명령 팔레트의 **SFDX: Authorize an Org**). 다중 값은 콤마로 구분.

| `--orgs` 값 | 설명 |
|---|---|
| `ALLOW_ALL_ORGS` | 인증된 모든 org 접근 허용. **주의해서 사용** |
| `DEFAULT_TARGET_DEV_HUB` | 기본 Dev Hub org 접근. DX 프로젝트의 로컬 기본 Dev Hub가 있으면 그것을, 없으면 전역 기본 Dev Hub를 사용 |
| `DEFAULT_TARGET_ORG` | 기본 org 접근. 로컬 기본 org가 있으면 그것을, 없으면 전역 기본 org를 사용 |
| `<username or alias>` | username 또는 alias로 특정 org 지정 |

---

## 툴셋 (toolsets)

`--toolsets` 플래그로 활성화. README의 toolset 표 전수 (≈60+ 도구가 이 toolset들에 분산):

| Toolset | 설명 |
|---|---|
| `all` | 모든 toolset의 모든 도구. (권장하지 않음 — 60+ 도구가 LLM 컨텍스트를 압도할 수 있음) |
| `core` | 코어 DX MCP 도구. **항상 활성화됨** |
| `orgs` | 인증된 org 관리 |
| `data` | org의 데이터 관리 (예: 모든 account 나열) |
| `metadata` | org ↔ DX 프로젝트 간 메타데이터 배포/검색 |
| `users` | org 사용자 관리 (예: permission set 할당) |
| `testing` | 코드·기능 테스트 |
| `code-analysis` | Salesforce Code Analyzer 기반 정적 분석 |
| `devops` | DevOps Center 리소스 read/manage/operate |
| `enrichment` | DX 프로젝트의 메타데이터 컴포넌트 enrich |
| `aura-experts` | Aura 컴포넌트 분석·블루프린트·LWC 마이그레이션 전문 |
| `lwc-experts` | LWC 개발·테스트·최적화·베스트 프랙티스 지원 |
| `experts-validation` | LWC를 접근성·보안·베스트 프랙티스 기준으로 검증·점수화(프로덕션 준비도) |
| `mobile` | 모바일 개발·기능 도구 |
| `mobile-core` | `mobile`의 부분집합 — 핵심 모바일 기능 |
| `scale-products` | Apex 성능(안티패턴) 탐지·수정 |

> 각 toolset에 속한 개별 도구 목록(GA/NON-GA 표시 포함)과 샘플 프롬프트는 README 및 공식 문서, 그리고 해당 provider 패키지 노트를 참조. NON-GA 도구는 `--allow-non-ga-tools` 플래그가 있어야 사용 가능.

---

## 보안 (security features)

README는 보안 기능의 *상세*는 공식 _Salesforce DX Developer Guide_의 개요 섹션으로 위임한다("Comprehensive overview, including details about the security features"). README 본문에서 확인되는 보안 설계 원칙:

- **명시적 org 인증 필수** — MCP 서버가 org에 접근하려면 사전에 로컬에서 org를 명시적으로 authorize해야 하고, `--orgs` 플래그로 접근 가능한 org를 명시해야 한다(최소 1개 필수). 인증되지 않은 org에는 접근 불가.
- **org 접근 범위 최소화** — `DEFAULT_TARGET_ORG` / `DEFAULT_TARGET_DEV_HUB` / 특정 username·alias로 범위를 좁히는 것이 기본. 모든 org를 여는 `ALLOW_ALL_ORGS`는 README가 명시적으로 "주의해서 사용"이라 경고한다.
- **GA-only 기본값** — 기본적으로 GA로 표시된 도구만 사용. NON-GA(아직 일반 공개 전) 도구는 `--allow-non-ga-tools`를 명시해야만 활성화된다.
- **컨텍스트 최소화** — toolset 단위 선택 활성화 및 `--dynamic-tools`로 LLM에 노출되는 도구·컨텍스트를 줄인다.
- **텔레메트리 제어** — 텔레메트리는 기본 활성이며 `--no-telemetry`로 비활성화 가능.

---

## 모노레포 구조 (10개 패키지)

루트 `package.json`은 yarn workspaces 모노레포(`monorepo-for-salesforce-mcp-server-and-providers`, private, Apache-2.0)로, `packages/*`를 워크스페이스로 둔다(`nohoist: ["**"]`). 빌드·테스트·lint·package는 `yarn workspaces run <script>`로 전체에 일괄 실행된다.

| 패키지 | npm name | 역할 (package.json description) |
|---|---|---|
| `mcp` | `@salesforce/mcp` | MCP Server for interacting with Salesforce instances (배포되는 서버 본체) |
| `mcp-provider-api` | `@salesforce/mcp-provider-api` | (내부용) MCP 서버가 등록할 prompt·resource·tool을 제공하는 McpProvider 구현 API |
| `mcp-provider-dx-core` | `@salesforce/mcp-provider-dx-core` | 코어 Salesforce DX 기능을 제공하는 MCP provider |
| `mcp-provider-code-analyzer` | `@salesforce/mcp-provider-code-analyzer` | (내부용) Salesforce Code Analyzer용 MCP 도구 제공 |
| `mcp-provider-devops` | `@salesforce/mcp-provider-devops` | DevOps 도구·작업용 MCP provider |
| `mcp-provider-metadata-enrichment` | `@salesforce/mcp-provider-metadata-enrichment` | DX 프로젝트의 메타데이터 enrich용 MCP provider |
| `mcp-provider-mobile-web` | `@salesforce/mcp-provider-mobile-web` | 모바일 웹 개발 도구·유틸리티 MCP provider |
| `mcp-provider-scale-products` | `@salesforce/mcp-provider-scale-products` | (내부용) Scale Products — Apex 안티패턴 탐지·권고 MCP provider |
| `EXAMPLE-MCP-PROVIDER` | `@salesforce/EXAMPLE-MCP-PROVIDER` | (내부용) provider 작성 예시 템플릿 |
| `mcp-test-client` | `@salesforce/mcp-test-client` | Zod 스키마 검증을 갖춘 타입 안전 MCP 테스트 클라이언트 |

> 아키텍처: `mcp`(서버)가 여러 `mcp-provider-*` 패키지를 통해 toolset을 등록하고, 각 provider는 `mcp-provider-api`가 정의한 McpProvider 인터페이스를 구현한다.

---

## 관련 노트
- [[mcp-provider-api]]
- [[mcp-provider-dx-core]]
- [[mcp-provider-code-analyzer]]
- [[mcp-provider-devops]]
- [[mcp-provider-metadata-enrichment]]
- [[mcp-provider-mobile-web]]
- [[SLDS 2 Starter Kit - 아이콘·모달·폼·배포]]
