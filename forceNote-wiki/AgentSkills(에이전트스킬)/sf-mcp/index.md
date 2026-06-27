---
tags: [index, agent-skills, sf-mcp, mcp, catalog]
created: 2026-06-27
---

# sf-mcp — Salesforce DX MCP Server 카탈로그

> 공식 [`salesforcecli/mcp`](https://github.com/salesforcecli/mcp) — **Salesforce DX MCP Server**(`@salesforce/mcp`)의 10-패키지 모노레포 문서 허브. AI 에이전트가 Model Context Protocol(MCP)을 통해 Salesforce org·메타데이터·DevOps·코드 분석에 접근하도록 도구(tool)를 노출하는 서버다. 각 노트는 모노레포의 패키지(서버 본체 + provider-api SDK + 도메인별 provider 7종) 또는 개발 가이드 1편에 대응한다.

**상위:** [[AgentSkills(에이전트스킬)/index|AgentSkills]] · **키워드 검색:** `_index/agent-skills.md`

---

## 패키지 카탈로그

| 노트 | 역할 |
|---|---|
| [[sf-mcp - 개요]] | 허브 — Salesforce DX MCP Server 전체 구조·모노레포·provider 아키텍처·설치/설정 개요 |
| [[mcp]] | 서버 패키지(`@salesforce/mcp`) — MCP 서버 본체, 진입점·CLI·toolset 등록·provider 로딩 |
| [[mcp-provider-api]] | Provider SDK — provider 작성용 공개 API(추상 클래스·인터페이스·툴 등록 계약) |
| [[mcp-provider-dx-core]] | DX 코어 provider — org 인증·메타데이터 배포/조회(deploy_metadata)·SOQL 실행(run_soql_query) 등 핵심 DX 도구 |
| [[mcp-provider-code-analyzer]] | 코드 애널라이저 provider — `run_code_analyzer` 정적 분석·Apex 안티패턴·규칙 위반 탐지 도구 |
| [[mcp-provider-devops]] | DevOps provider — DevOps Center work item·파이프라인·릴리즈 관리 도구 |
| [[mcp-provider-metadata-enrichment]] | 메타데이터 보강 provider — `enrich_metadata` 메타데이터 컨텍스트 보강 도구 |
| [[mcp-provider-mobile-web]] | 모바일·웹 provider — 모바일/웹 관련 도구 노출 |
| [[mcp-provider-scale-products]] | Scale Products provider — Scale 제품군 관련 도구 노출 |
| [[sf-mcp - 프로바이더 개발 (Example + Test Client)]] | provider 개발 가이드 — example provider 작성 + MCP Test Client로 검증하는 절차 |

---

## 빠른 선택

- MCP 서버가 뭐고 어떻게 설치/설정? → [[sf-mcp - 개요]] → [[mcp]]
- 직접 provider를 만들고 싶다? → [[mcp-provider-api]] (SDK) → [[sf-mcp - 프로바이더 개발 (Example + Test Client)]]
- org에 메타데이터 배포·SOQL 실행 도구? → [[mcp-provider-dx-core]]
- 정적 분석·Apex 안티패턴 탐지 도구? → [[mcp-provider-code-analyzer]]
- DevOps Center work item 관리 도구? → [[mcp-provider-devops]]

---

## 관련 폴더

- 에이전트 스킬 라이브러리 카탈로그 → [[sf-skills/index|sf-skills]]
- 상위 인덱스 → [[AgentSkills(에이전트스킬)/index|AgentSkills]]
