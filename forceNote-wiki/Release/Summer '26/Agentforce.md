---
tags: [release, summer_26, agentforce, einstein, ai]
api_version: v67.0
release_date: 2026-06
created: 2026-06-15
source: salesforce_summer26_release_notes.pdf (Salesforce Summer '26 Release Notes, Tier 2)
aliases: [Summer '26 Agentforce, 서머26 에이전트포스, MCP Servers, IntegrationTest]
---

# Summer '26 — Agentforce / Einstein

> v67.0 Agentforce 영역. Hosted MCP Servers GA를 중심으로 GA(Named Query Agent Actions·OpenAI Search Provider), Beta(Multi-Agent Orchestration·Refined Analytics+Custom Scorers·Voice 언어 확장·ADL Connect·Metadata Context MCP), 그리고 Developer Preview(Apex 통합 테스트)를 다룬다.

---

## 개요

이 노트는 [[Summer '26]] 릴리즈의 **Agentforce / Einstein** 영역을 다룬다. 핵심은 **Hosted MCP Servers의 GA 전환**으로, AI 에이전트가 인프라 관리 없이 Salesforce 데이터·자동화에 안전하게 연결된다. Apex 통합 테스트(Developer Preview)는 [[Summer '26/Development]]의 `System.IntegrationTest` 신규 클래스와 직접 연결된다.

상위 허브: [[Summer '26]] · 개발자 항목: [[Summer '26/Development]]

---

## GA (General Availability)

### Hosted MCP Servers — Connect AI Agents to Salesforce Securely

Claude·ChatGPT·Cursor 또는 커스텀 에이전트를 포함한 MCP 호환 AI 클라이언트를 개방형 Model Context Protocol(MCP) 표준으로 Salesforce 조직에 연결한다. AI 에이전트가 표준 OAuth 인증으로 안전하게 거버넌스된 방식으로 Salesforce 데이터·자동화와 상호작용한다. **Hosted MCP 서버는 관리할 인프라가 필요 없다.** sObject 작업, Data 360 쿼리, Tableau 분석, product API에 접근하고, 통합 코드 작성 없이 자체 Apex 액션·flow·named query로 커스텀 도구를 만들 수 있다.

> 적용 범위: Lightning Experience, Enterprise·Performance·Unlimited·Developer 에디션.

### Named Query API — Create Agent Actions (GA)

Named Query API로 커스텀 SOQL 쿼리를 REST API 클라이언트와 AI 에이전트를 위한 확장 가능한 액션으로 정의·노출한다. named query는 기존 Flow나 Apex 프로세스보다 빠르고 효율적으로 데이터를 검색한다.

### OpenAI Search Provider in Search the Web Agent Action (GA)

OpenAI를 검색 공급자로 사용해 AI 에이전트 내에서 관련성 높은 실시간 웹 검색 결과를 얻는다. 이제 GA인 OpenAI 검색 공급자는 Beta 이후 기반 웹 검색 모델 업데이트를 포함한다.

---

## Beta

### Orchestrate Other Agents — Multi-Agent Orchestration (Beta)

Multi-Agent Orchestration for Agentforce(Beta)로 에이전트 역량을 확장한다. 한 Agentforce 에이전트를 같은 조직의 다른 특화 Agentforce 에이전트와 연결해 복잡한 작업을 협업한다. 단일 통합 접점을 제공해, 연결된 subagent가 사용자가 여러 분리된 세션을 오가지 않고도 더 많은 일을 처리하게 한다.

> 적용 범위: Lightning Experience, Enterprise·Performance·Unlimited·Developer 에디션(Foundations 또는 Agentforce 1 edition). 롤아웃: 2026년 5월 4일 주부터(일부 기능은 후속 롤아웃 — 예: 커스텀 변수 지원, NGA의 통합 trace view).

설정 요지: Agent Builder에서 draft 상태 에이전트(= orchestrator)를 열고 Explorer 패널의 **+** → **Connect Agent as Subagent (Beta)**로 연결할 에이전트를 선택. 각 연결된 subagent의 description을 커스터마이즈해 동작을 제어. Agent Router 사용 시 Canvas view의 Actions Available for Reasoning에 subagent를 추가하고 Instructions에서 `@` 기호로 참조.

> 신규 Agent Builder로 만든 에이전트는 새 버전을 만들어 활성화, legacy Agentforce Builder로 만든 에이전트는 새 Agent Builder로 업그레이드 후 사용.

### Agentforce Observability: Refined Agent Analytics and Custom Scorers (Beta)

Refined Agent Analytics가 Service Agent Analytics와 Employee Agent Analytics를 한곳에 통합해 **40개 이상의 메트릭**(Quality·Health·Effectiveness·Usage)을 제공하는 통합 뷰를 보여준다. 고수준 뷰에서 subagent·intent·action으로 드릴다운 가능. **Custom Scorers (Beta)**로 Salesforce 표준 품질 메트릭과 함께 자체 KPI 기준으로 세션을 평가한다(Sentiment Score·Tone of Voice·Product Interest·Escalation Trigger·Politeness 등).

> 적용 범위: Lightning Experience, Enterprise·Performance·Unlimited 에디션(Salesforce Foundations 또는 Agentforce 1 Edition, Agent Optimization·Analytics 활성화). When: 2026년 5월 4일 주부터. 권한: Custom Scorers(Beta)는 Agentforce Scorer Beta 권한 집합 필요(추가 라이선스 불필요), 활성화는 `AgentforceScorerActivation` 권한 집합.

> Legacy Agent Analytics 지원·업데이트는 2026년 5월 종료.

### Expanded Global Language Support with Agentforce Voice (Beta)

Agentforce Voice가 영어·프랑스어를 넘어 추가 글로벌 언어를 지원해 더 넓은 청중에 도달한다. 이 언어들은 현재 Beta로 지원된다.

### Manage Agentforce Data Libraries with ADL Connect API (Beta)

ADL Connect API로 Agentforce Data Libraries를 관리한다. (롤아웃: 2026년 5월 4일 주)

### Enable AI Assistants to Find and Create Metadata — Metadata API Context MCP (Beta)

Salesforce API Context MCP 서버가 이제 1개가 아닌 **5개의 Metadata API Context MCP tool**을 가진다. 더 세분화된 도구로 AI 에이전트 쿼리를 타깃팅하고 응답 시간을 단축하며 토큰 사용을 효율화한다. 이 도구들은 Salesforce 메타데이터 타입의 컨텍스트 정보(완전한 필드 정의·유효 값·제약·예시)를 제공해 정확한 메타데이터 파일 생성을 돕는다.

### Agentforce for Flow (Beta 복귀)

`Update Screen Flows with Natural Language Prompts` — Agentforce for Flow가 정확도 문제로 **GA에서 Beta로 복귀**했다. (상세는 [[Summer '26/Platform]]의 Flow 영역)

---

## Developer Preview

### Write Integration Tests for Agentforce and Data 360 in Apex

Agentforce·Data 360에 callout하는 end-to-end Apex 테스트를 작성한다. 통합 테스트는 callout 제약과 트랜잭션 롤백 시맨틱을 완화해, mock callout 없이 실제 서비스 상호작용을 검증하고 scratch org의 실제 부수 효과를 단언할 수 있다.

> 표준 Apex 단위 테스트는 callout에 mocking이 필요하고 각 테스트 끝에 모든 데이터를 롤백한다. 통합 테스트는 트랜잭션 중간에 데이터를 커밋하고, Agentforce·Data 360에 실제 callout하며, 전용 teardown 메서드로 테스트 데이터를 정리한다.

먼저 scratch org 정의 파일에서 `ApexIntegrationTests` 기능을 활성화한다.

```json
// PDF 원문 발췌 — salesforce_summer26_release_notes.pdf
{
"orgName": "My Company",
"edition": "Developer",
"features": ["ApexIntegrationTests"]
}
```

통합 테스트 클래스는 클래스와 각 테스트 메서드 모두에 `@IntegrationTest`를 쓴다. 트랜잭션 중간에 테스트 데이터를 커밋하려면 `IntegrationTest.commitTestOnly()` 메서드를 쓰고, 커밋된 데이터를 정리하려면 `@TearDown` 메서드를 추가한다.

```apex
// PDF 원문 발췌 — salesforce_summer26_release_notes.pdf
@IntegrationTest
public with sharing class MyServiceIntegrationTest {
@IntegrationTest
public static void testServiceInteraction() {
Account a = new Account(Name = 'Integration Test Account');
insert as user a;
IntegrationTest.commitTestOnly();
Account result = [SELECT Id, Name FROM Account WHERE Id = :a.Id WITH USER_MODE];
Assert.areEqual('Integration Test Account', result.Name);
}
@TearDown
public static void tearDown() {
delete as user [SELECT Id FROM Account WHERE Name = 'Integration Test Account' WITH USER_MODE];
}
}
```

통합 테스트 실행은 Tooling API REST 리소스 `/services/data/vXX.X/tooling/runTestsAsynchronous/`를 쓴다. **한 번에 하나의 통합 테스트만 비동기로 실행** 가능하며, 통합 테스트에 동기 실행은 제공되지 않는다.

> 이 Developer Preview는 [[Summer '26/Development]]의 `System.IntegrationTest` 신규 클래스에 대응한다.

---

## 관련 노트

- [[Summer '26]] — 상위 허브
- [[Summer '26/Development]] — `System.IntegrationTest`·`String.template` 등 개발자 항목
- [[Queueable]] — 비동기 Apex 실행 모델
