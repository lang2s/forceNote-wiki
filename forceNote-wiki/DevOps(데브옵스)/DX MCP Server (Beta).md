---
tags: [devops, mcp, ai, llm, vs-code, github-copilot, salesforce-dx, mcp-server]
source: sfdx_dev.pdf v67.0 Summer '26 — Ch.10 (p.232–245)
created: 2026-05-23
aliases: [DX MCP Server, Salesforce DX MCP, MCP Server Beta, @salesforce/mcp, DX MCP 도구, MCP 툴셋, Core DX MCP Tools]
---

# DX MCP Server (Beta)

> Salesforce DX MCP Server는 LLM(대형 언어 모델)과 Salesforce org 사이의 구조화된 인터페이스를 제공하는 MCP 구현체다 — 자연어로 DX 작업(메타데이터 배포·Scratch Org 생성·Apex 테스트 등)을 실행한다.

---

## 개요

`@salesforce/mcp` npm 패키지로 제공되는 Salesforce DX MCP Server는 60개 이상의 MCP 도구를 포함하며, IDE의 AI 채팅 창에서 자연어 프롬프트로 DX 작업을 완료할 수 있다.

> Note: Salesforce DX MCP Server는 Beta 서비스이며 Beta Services Terms가 적용된다.

### 동작 원리

```
사용자: "Deploy my metadata"
  ↓
LLM: deploy_metadata MCP 도구 선택
  ↓
DX MCP Server: 로컬 DX 프로젝트 컨텍스트에서 도구 실행
  ↓
결과: 성공/오류 메시지를 LLM에 반환 → LLM이 다음 단계 결정
```

MCP가 필요한 이유: LLM이 MCP 도구 없이 응답할 경우 훈련 데이터가 오래됐을 수 있어 부정확하거나 비효율적인 결과를 낼 수 있다.

---

## 보안 설계

Salesforce DX MCP Server는 보안을 최우선으로 설계되었다.

| 보안 특징 | 내용 |
|---|---|
| TypeScript 라이브러리 직접 사용 | CLI shelling-out 없음 → RCE(원격 코드 실행) 위험 대폭 감소 |
| 설정 파일에 시크릿 불필요 | 평문 시크릿 노출 위험 없음 |
| 암호화된 auth 파일 접근 | 로컬 머신의 기존 인증 파일을 암호화된 상태로 사용 |
| MCP 도구에서 시크릿 미노출 | 도구는 토큰 대신 username을 전달 |
| Granular 접근 제어 | 명시적으로 허용된 org만 접근 가능 (org allowlisting) |

---

## Agentforce Vibes Extension

Agentforce Vibes는 VS Code 확장팩으로, **DX MCP Server가 사전 설정**되어 있어 설치 즉시 DX MCP 도구를 사용할 수 있다. 별도 설정 불필요.

---

## MCP 도구 유형 (Toolset 분류)

DX MCP Server는 도구를 **toolset** 단위로 그룹화해 LLM 컨텍스트를 최적화한다.

| Toolset | 설명 |
|---|---|
| `core` | 항상 활성화된 기본 DX 도구 |
| `orgs` | org 관리 (목록 조회, Scratch Org 생성 등) |
| `metadata` | 메타데이터 배포·검색 |
| `data` | org 데이터 관리 (SOQL 쿼리 등) |
| `users` | org 사용자 관리 (권한 세트 할당 등) |
| `testing` | Apex 테스트·Agentforce 에이전트 테스트 |
| `aura-experts` | Aura → LWC 마이그레이션 도구 |
| `code-analysis` | Salesforce Code Analyzer 정적 분석 |
| `devops` | DevOps Center 작업 항목·병합 충돌·배포 문제 해결 |
| `enrichment` | DX 프로젝트 메타데이터 컴포넌트 보강 |
| `experts-validation` | LWC 프로덕션 준비성 검증 및 점수 |
| `lwc-experts` | LWC 설계·빌드·테스트·최적화 |
| `mobile` | 모바일/오프라인 LWC 패턴 전체 도구 |
| `mobile-core` | 모바일 LWC 핵심(최소) 도구 |
| `scale-products` | ApexGuru — Apex 성능 분석·개선 |
| `all` | 모든 toolset 활성화 (LLM 컨텍스트 과부하 주의) |

---

## MCP 용어 정의

| 용어 | 정의 |
|---|---|
| MCP Server | LLM과 시스템(Salesforce) 간 인터페이스. 도구·프롬프트·리소스를 LLM에 제공 |
| MCP Tools | LLM이 호출할 수 있는 실행 가능 함수 |
| MCP Toolsets | 기능 기반으로 묶인 MCP 도구 논리 그룹 |
| MCP Client | MCP 서버를 호스팅하는 IDE(Cursor 등) 또는 인터페이스(Agentforce). MCP Host라고도 함 |

---

## 빠른 시작 — VS Code + GitHub Copilot

### 전제 조건

- Node.js (Active LTS 버전 권장)
- Salesforce CLI
- VS Code
- GitHub 계정
- Salesforce DX 프로젝트 + 최소 1개 org 인증

### 1단계: mcp.json 파일 생성

```json
// .vscode/mcp.json (DX 프로젝트 루트에 생성)
{
  "servers": {
    "Salesforce DX": {
      "command": "npx",
      "args": ["-y", "@salesforce/mcp@latest",
        "--orgs", "DEFAULT_TARGET_ORG",
        "--toolsets", "orgs,metadata,data,users,testing"]
    }
  }
}
```

또는 VS Code 글로벌 `settings.json`의 `mcp:servers` 섹션에도 추가 가능.

### 2단계: 서버 시작

```
View → Command Palette → MCP: List Servers → Salesforce DX → Start Server
```

서버 준비 완료 메시지:
```
Salesforce MCP Server v0.21.2 running on stdio
```

### 3단계: GitHub Copilot 채팅 (Agent 모드)

```
View → Command Palette → Chat: Open Chat (Agent)
```

> Copilot 채팅 창이 **Agent 모드**인지 확인 (Ask/Edit 모드가 아니어야 함).

### 샘플 프롬프트

```
# org 목록 조회
"Do I have any active scratch orgs? What about inactive scratch orgs?"
"Show me all the available information about all my orgs."

# 데이터 조회
"Show me all the accounts in the org with the alias my-org."

# 배포
"Deploy the Apex classes in my DX project to the org with the alias my-org."

# 검색
"Retrieve all agents from my org."
```

---

## 설치 및 설정

### 지원 MCP 클라이언트

| 클라이언트 | 방법 |
|---|---|
| Agentforce Vibes | 사전 설정됨 — 별도 설치 불필요 |
| VS Code + GitHub Copilot | `.vscode/mcp.json` 업데이트 (위 예시 참조) |
| Cursor, Claude Code 등 | @salesforce/mcp GitHub README 참조 |

### args 옵션 플래그 전수

```json
// 예시 1: 기본 설정 (default org + 핵심 toolset)
"args": ["-y", "@salesforce/mcp@latest",
  "--orgs", "DEFAULT_TARGET_ORG",
  "--toolsets", "orgs,metadata,data,users,testing"]

// 예시 2: 2개 org + 특정 toolset
"args": ["-y", "@salesforce/mcp@latest",
  "--orgs", "DEFAULT_TARGET_DEV_HUB,test-org@example.com",
  "--toolsets", "data,orgs,metadata"]

// 예시 3: 별칭으로 지정된 org 2개
"args": ["-y", "@salesforce/mcp@latest",
  "--orgs", "my-scratch-org,my-dev-hub",
  "--toolsets", "data,orgs,metadata"]

// 예시 4: 모든 org + 모든 toolset + NON-GA 도구 (주의!)
"args": ["-y", "@salesforce/mcp@latest",
  "--orgs", "ALLOW_ALL_ORGS",
  "--toolsets", "all",
  "--allow-non-ga-tools"]

// 예시 5: toolset + 특정 도구 개별 지정
"args": ["-y", "@salesforce/mcp@latest",
  "--orgs", "DEFAULT_TARGET_ORG",
  "--toolsets", "data,orgs,metadata,lwc-experts,code-analysis",
  "--tools", "run_apex_test",
  "--allow-non-ga-tools"]

// 예시 6: toolset 없이 특정 도구만 지정
"args": ["-y", "@salesforce/mcp@latest",
  "--orgs", "DEFAULT_TARGET_ORG,DEFAULT_TARGET_DEV_HUB",
  "--tools", "list_all_orgs,deploy_metadata,run_apex_test"]

// 예시 7: toolset + 단일 추가 도구
"args": ["-y", "@salesforce/mcp@latest",
  "--orgs", "DEFAULT_TARGET_ORG",
  "--toolsets", "orgs",
  "--tools", "deploy_metadata"]
```

### --orgs 플래그 유효 값

| 값 | 설명 |
|---|---|
| `DEFAULT_TARGET_ORG` | 기본 org (로컬 설정 우선, 없으면 글로벌) |
| `DEFAULT_TARGET_DEV_HUB` | 기본 Dev Hub org |
| `ALLOW_ALL_ORGS` | 모든 인증된 org 접근 허용 (주의!) |
| `<username>` 또는 `<alias>` | 특정 org 지정 (예: `my-org`, `test@example.com`) |

### --toolsets / --tools / --dynamic-tools 중 최소 1개 필수

| 플래그 | 필수 여부 | 설명 |
|---|---|---|
| `--orgs` | 필수 | 접근 허용 org 지정 |
| `--toolsets` | 셋 중 최소 1개 | toolset 단위 활성화 |
| `--tools` | 셋 중 최소 1개 | 특정 도구 개별 활성화 |
| `--dynamic-tools` | 셋 중 최소 1개 | (실험적) 동적 도구 로딩 — 초기 컨텍스트 최소화 |
| `--no-telemetry` | 선택 | 텔레메트리 비활성화 |
| `--debug` | 선택 | 디버그 로그 출력 |
| `--allow-non-ga-tools` | 선택 | GA + NON-GA 도구 모두 허용 |

---

## Core DX MCP Tools 전수 참조

core toolset은 항상 활성화된다. 나머지는 지정한 toolset에 따라 활성화.

| 도구명 | Toolset | GA 여부 | 설명 |
|---|---|---|---|
| `get_username` | core | GA | 적절한 username/alias 결정. 항상 사용 가능 |
| `resume_tool_operation` | core | GA | 완료되지 않은 장시간 작업 재개. 항상 사용 가능 |
| `list_all_orgs` | orgs | GA | 모든 설정된 Salesforce org 목록 |
| `create_org_snapshot` | orgs | NON-GA | Scratch Org 스냅샷 생성 |
| `create_scratch_org` | orgs | NON-GA | Scratch Org 생성 |
| `delete_org` | orgs | NON-GA | 로컬 인증된 Scratch Org 또는 Sandbox 삭제 |
| `org_open` | orgs | NON-GA | 브라우저에서 Salesforce org 열기 |
| `run_soql_query` | data | GA | org 대상 SOQL 쿼리 실행 |
| `assign_permission_set` | users | GA | 사용자에게 권한 세트 할당 |
| `deploy_metadata` | metadata | GA | DX 프로젝트에서 org로 메타데이터 배포 |
| `retrieve_metadata` | metadata | GA | org에서 DX 프로젝트로 메타데이터 검색 |
| `run_agent_test` | testing | GA | org에서 Agentforce 에이전트 테스트 실행 |
| `run_apex_test` | testing | GA | org에서 Apex 테스트 실행 |

> NON-GA 도구를 사용하려면 `--allow-non-ga-tools` 플래그 필요.

---

## 서버 관리

```
# VS Code에서 MCP: List Servers → Salesforce DX 클릭 후
# - Stop / Restart / View Configuration 등 선택
```

- 재시작 시 새 버전의 `@salesforce/mcp` npm 패키지가 있으면 자동 업데이트
- 릴리스 노트 및 버그 신고: Salesforce DX MCP Server GitHub 이슈 트래커

---

## 관련 노트
- [[DX 도구 개요와 워크플로 전환]] — DX 시작 경로 전수
- [[DX 개발 워크플로]] — CLI 기반 Apex/LWC 개발 명령 전수
- [[DX 인증 방식]] — org 인증 방법 (MCP 서버 전제 조건)
- [[Scratch Org 생성과 정의 파일]] — MCP로 Scratch Org 생성 시 참조
- [[MetadataAPI(메타데이터API)/Metadata API MCP Tool]] — Metadata API 전용 MCP Tool (별개)
