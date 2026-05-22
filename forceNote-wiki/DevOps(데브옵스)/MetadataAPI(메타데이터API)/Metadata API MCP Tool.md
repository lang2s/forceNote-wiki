---
tags: [devops, metadata-api, mcp, agentforce, ai, cursor, claude, v67, beta]
source: api_meta.pdf v67.0 Summer '26 — Chapter 8 (Quick Start: Metadata API Context MCP Tools)
created: 2026-05-22
aliases: [Metadata API MCP, MCP Tool, Metadata API Context MCP, salesforce-api-context, get_metadata_type_context, Agentforce MCP, 메타데이터 MCP 도구]
---

# Metadata API MCP Tool (Beta)

> Salesforce가 호스팅하는 MCP(Model Context Protocol) 서버를 통해 AI 코딩 도구(Cursor, Claude, Agentforce Vibes)에 Metadata API 타입 컨텍스트를 제공하는 기능. Beta 서비스.

---

## 개요

Metadata API Context MCP Tools는 AI 어시스턴트가 정확한 Salesforce 메타데이터 XML 파일을 생성할 수 있도록 메타데이터 타입 정보를 컨텍스트로 제공한다. 특정 메타데이터 타입에 대해 다음을 제공한다:

- 완전한 필드 정의 (complete field definitions)
- 유효한 값 (valid values)
- 제약 조건 (constraints)
- 예제 (examples)

> **Beta 주의:** Metadata API Context MCP Tools는 베타 서비스다. Salesforce Beta Services Terms 또는 Unified Pilot Agreement 적용. 사용은 고객의 재량에 따른다.

---

## MCP 서버 및 도구 목록

**서버 이름:** `platform/salesforce-api-context`

| 도구 이름 | 설명 |
|---|---|
| `get_metadata_type_sections` | 메타데이터 타입에서 사용 가능한 컨텍스트 섹션 목록 반환 |
| `get_metadata_type_context` | 요청된 메타데이터 타입 섹션의 컨텍스트 반환 |
| `get_metadata_type_fields` | 메타데이터 타입의 필드 이름 및 필드-컬럼 메타데이터 반환 |
| `get_metadata_type_fields_properties` | 지정된 필드의 속성(properties) 반환 |
| `search_metadata_types` | 제공된 문자열로 메타데이터 타입 이름을 검색하고 일치하는 타입 목록 반환 |

> API 사용량은 조직의 API 쿼터에 포함된다.

---

## 사전 요구사항: Salesforce Hosted MCP 서버 설정

### 1. MCP 서버 활성화

1. Setup에서 Quick Find에 **MCP Servers** 입력 → **MCP Servers** 선택
2. `salesforce-api-context` 클릭 → **Activate** 클릭

### 2. External Client App 생성

Agentforce Vibes 이외의 MCP 클라이언트(Cursor, Claude 등)를 사용할 때 필요하다. Agentforce Vibes를 사용하는 경우 이 단계를 건너뛴다.

```
1. Setup → Quick Find: "external client" → External Client App Manager
2. New External Client App 클릭
3. Basic Information 섹션 입력
4. API (Enable OAuth Settings) 섹션 확장 → Enable OAuth 체크박스 선택
5. Callback URL: http://localhost:8080/oauth/callback
   (다른 클라이언트는 해당 공급자의 문서 참조)
6. OAuth Scopes 추가:
   - Manage user data via APIs (api)
   - Access the Salesforce API Platform (sfap_api)
   - Perform requests at any time (refresh_token, offline_access)
   - (프롬프트 템플릿 사용 시) Access Einstein GPT services (einstein_gpt_api)
7. Security 섹션:
   a. Issue JSON Web Token (JWT)-based access tokens for named users 선택
   b. Require Proof Key for Code Exchange (PKCE) 선택
   c. 나머지 옵션 모두 해제
8. Create 클릭
9. Settings → Consumer Key and Secret → Consumer Key 복사하여 저장
```

### 3. Target Org 로그인

MCP 클라이언트가 인증할 때 OAuth 웹 브라우저를 열므로, 미리 준비가 필요하다:

```
1. 다른 모든 Salesforce org에서 로그아웃
2. 기본 브라우저로 접근할 org에 로그인 (External Client App을 만든 org)
3. 브라우저를 열어 두기 (MCP 클라이언트가 새 탭을 열 예정)
```

---

## Step 1: MCP 클라이언트 설정

### Agentforce Vibes 설정

1. Agentforce Vibes VS Code Extension 설치
2. 프로젝트 생성 또는 열기
3. Command Palette → `SFDX: Authorize an Org` 실행 → Salesforce 자격증명으로 로그인
4. VS Code Activity Bar → Agentforce 아이콘 클릭
5. Agentforce 패널 → MCP Servers 인터페이스 아이콘 클릭
6. Configure 탭 → **Salesforce API Context Server** 켜기

### Cursor 설정 (Developer Mode)

Cursor는 MCP를 지원하는 AI 코딩 편집기다. 사전에 Node.js 설치 필요.

```
1. Cursor > Settings > Cursor Settings > MCP
2. New MCP Server 클릭 → mcp.json 파일 생성됨
3. mcp.json 내용을 아래 코드로 교체
```

```json
{
  "mcpServers": {
    "salesforce-api-context": {
      "command": "npx",
      "args": [
        "-y",
        "mcp-remote@0.1.18",
        "https://api.salesforce.com/platform/mcp/v1-beta.2/platform/salesforce-api-context",
        "8080",
        "--static-oauth-client-info",
        "{\"client_id\":\"YOUR_CONSUMER_KEY\",\"client_secret\":\"\"}"
      ]
    }
  }
}
```

```
4. 플레이스홀더 교체:
   - YOUR_CONSUMER_KEY → External Client App에서 저장한 consumer key
   - client_secret은 빈 문자열로 유지
   - sandbox/scratch org 연결 시 URL을:
     https://api.salesforce.com/platform/mcp/v1-beta.2/sandbox/platform/salesforce-api-context
     로 변경
```

### Claude Desktop 설정 (Developer Mode)

```
1. GitHub에서 salesforce-hosted-mcp-servers.mcpb 파일 다운로드
2. .mcpb 파일 더블클릭 → Claude 데스크탑 클라이언트에서 Salesforce 확장 표시
3. Install 클릭
4. Server Name: platform/salesforce-api-context 입력
5. Consumer Key: External Client App에서 저장한 consumer key 붙여넣기 → Save
6. 확장 활성화 토글 켜기
   (오류 발생 시 Claude 재시작)
```

---

## Step 2: MCP 서버 연결 테스트

클라이언트 설정 완료 후 간단한 프롬프트로 연결을 확인한다.

**테스트 예시 1:**
```
Query the Salesforce API Context MCP tools to get the metadata context
for the CustomTab Metadata Type
```
→ 클라이언트가 CustomTab 메타데이터 타입 정보로 응답해야 한다.

**테스트 예시 2:**
```
Can you create a new custom object to track Projects with the following
fields: Start Date (date), End Date (date), and Budget (number).
Use the Salesforce API Context MCP tools as context when creating each
metadata type.
```
→ 클라이언트가 CustomObject와 CustomField 메타데이터 타입 정보를 조회하고, 올바른 메타데이터 XML 파일을 생성해야 한다.

---

## Step 3 (선택): AI 규칙 설정

MCP 서버가 최적으로 동작하도록 AI 어시스턴트에 규칙(rule)을 설정할 수 있다. 규칙은 마크다운 같은 플레인텍스트 파일로, AI에 특정 지침과 제약을 제공한다.

```markdown
# Rule: Salesforce Metadata Generation

## Description
To guarantee the creation of accurate and deployable Salesforce metadata files,
you must use these tools from the `salesforce-api-context` MCP server:
- `get_metadata_type_sections`
- `get_metadata_type_context`
- `get_metadata_type_fields`
- `get_metadata_type_fields_properties`
- `search_metadata_types`

These tools provide comprehensive contextual information—including complete field
definitions, valid values, and constraints—that's essential for correctly determining
the required entity shape and creating a valid Salesforce metadata file structure.

## Constraints
1. **One metadata type at a time** - finish one metadata type before starting the next
3. **One metadata type per tool call** - don't batch metadata types when calling MCP tools
4. **Child metadata types need their own context** - treat child metadata separately;
   don't rely on the parent's schema for creating child metadata

## Workflow

### Step 1: Metadata loop - Execute for each metadata type
For each metadata type, use these tools from `salesforce-api-context` MCP server:
- `get_metadata_type_sections`
- `get_metadata_type_context`
- `get_metadata_type_fields`
- `get_metadata_type_fields_properties`
- `search_metadata_types`

### Step 2: Verify deployment
```bash
sf project deploy start --dry-run -d "force-app/main/default" \
  --target-org <alias> --test-level NoTestRun --wait 10 --json
```
On failure: attempt to fix errors and re-run, up to 3 times.

## Anti-patterns
| Don't | Why | Do |
|-------|-----|-----|
| Batch types in MCP tool calls | Violates constraint | One type per call |
```

---

## 가용 에디션

- Professional, Enterprise, Unlimited, Developer, sandbox, scratch org
- API가 활성화된 org 필요

---

## 관련 노트

- [[Metadata API 개요]] — Metadata API 전체 개념
- [[Metadata API Utility Calls]] — describeMetadata, describeValueType (메타데이터 타입 조회 대안)
- [[Metadata Types — 개요 및 분류]] — Ch13 메타데이터 타입 전체 목록
- [[CI CD 패턴]] — sf project deploy start 자동화 배포
- [[Salesforce DX 개요]] — sf CLI 명령어 참조
- [[DX MCP Server (Beta)]] — Salesforce DX CLI 기반 MCP Server (이 파일과 별개 — DX 전용)
