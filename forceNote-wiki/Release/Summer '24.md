---
tags: [release, summer_24]
api_version: v61.0
release_date: 2024-06
created: 2026-05-17
source: salesforce_summer24_release_notes.pdf
aliases: [Summer '24, 서머 24, v61.0, 서머24 릴리즈 노트, 2024 여름 릴리즈, Summer 24 허브]
---

# Summer '24 릴리즈 노트

> API v61.0 | 출시: 2024년 06월
> 공식 문서: [Release Notes](https://help.salesforce.com/s/articleView?id=release-notes.salesforce_release_notes.htm)
> 이 릴리즈는 분량이 커서 도메인별 spoke로 분리되어 있다. 아래 라우팅에서 도메인을 골라 상세로 이동한다.

---

## 하위 노트 (도메인별 라우팅)

| Spoke | 다루는 범위 |
|---|---|
| [[Summer '24/Development]] | Apex(Cursors Beta·Data Cloud SOQL·5단계 부모-자식·Dynamic Formula Beta·InvocableVariable 수식자) · LWC(URL-Addressable·Utility Bar API·v61.0/OSS v6) · API v61.0 · Pub/Sub · Packaging |
| [[Summer '24/Automation]] | Flow Builder(Transform GA·Repeater GA·Einstein Draft Flow Beta·Action Button Beta·Reactive Collection Choice·Is Blank/Is Empty·Lock/Unlock) · Flow Orchestration |
| [[Summer '24/Platform]] | Admin(User Access Policy GA·Search Manager GA·Dynamic Forms) · Security(External Client App Manager·OAuth Token Exchange·MFA·SAML) · DevOps/CLI(Scratch Org Snapshots GA) · Architecture |
| [[Summer '24/Clouds]] | Sales · Service · Experience · Mobile · Data Cloud · Analytics · Commerce · Field Service · Industries · Marketing · Revenue · Slack |
| [[Summer '24/Einstein]] | Einstein Copilot Topics · Prompt Builder(Flex·RAG) · Einstein Studio(Anthropic Claude/Gemini) · Einstein Data Library GA · Models API Beta |
| [[Summer '24/Release Updates]] | 31개 Release Update 시점 맵 + 비-RU 은퇴 일정 |

---

## ⭐ 주요 신기능

- **Apex Cursors (Beta)** — 대용량 SOQL(최대 5천만 행) 커서 순회, Batch Apex 대안. → [[Summer '24/Development]]
- **Data Cloud SOQL in Apex** — DMO 대상 Static SOQL(v61.0+). → [[Summer '24/Development]]
- **SOQL 5단계 부모-자식 관계 쿼리** — 4→5단계 확장. → [[Summer '24/Development]]
- **Transform 요소 (Generally Available)** — Flow 컬렉션 변환 정식 출시. → [[Summer '24/Automation]]
- **Repeater 컴포넌트 (Generally Available)** — Screen Flow 반복 입력 수집. → [[Summer '24/Automation]]
- **Einstein이 Flow 초안 자동 생성 (Beta)** — 자연어로 Flow 생성(2024-07-16~). → [[Summer '24/Automation]]
- **Scratch Org Snapshots (Generally Available)** — 스냅샷 복제(90일). → [[Summer '24/Platform]]
- **User Access Policy (Generally Available)** + **Search Manager (Generally Available)**. → [[Summer '24/Platform]]
- **External Client App Manager** — OAuth 앱 관리 UI를 Setup에서 제공. → [[Summer '24/Platform]]
- **Einstein Copilot Topics 확장** + **Prompt Builder Flex/RAG**. → [[Summer '24/Einstein]]

---

## ⚠️ 파괴적 / 주의 변경

> 상세·코드·이관 가이드는 각 spoke에 있음.

- **API v61.0 동작 변경** — private method override 방지(서브클래스가 슈퍼클래스 `private` 메서드를 더 이상 오버라이드 안 함), LWC light DOM `<slot>` forwarding 시 `slot` 속성이 DOM에서 제거됨, `class`/`style` 속성에 추가 공백 렌더. → [[Summer '24/Development]]

```apex
// 영향받는 식별자 요약 — 코드·상세는 [[Summer '24/Development]] 참조
DescribeFieldResult.getRelationshipOrder(); // v61.0+: standard field에서 primary 0 / secondary 1 (기존 null)
```
- **My Domain Login URL 강제** — 2024-10-12부터 instanced URL을 사용하는 API 호출 차단, My Domain login URL 전환 필수. → [[Summer '24/Platform]]
- **MFA 기본 ON (2024-04-08~)** + **SAML 다중 구성 강제**(샌드박스 Summer '24 / 프로덕션 Spring '25). → [[Summer '24/Platform]]
- **Summer '24 강제 Release Update 4건** — Allow Only Trusted Cross-Org Redirections · Enable EmailSimple Invocable Action to Respect Organization-Wide Profile Settings · Enable ICU Locale Formats(rolling Spring '24 시작) · Grant Access to the Label Object In Custom Profiles. 전체 31건 시점 맵 → [[Summer '24/Release Updates]]

---

## 섹션별 GA 하이라이트

- **Development** — SOQL 5단계 부모-자식 쿼리 지원, REST API `updateOnly` 파라미터, Apex Cursors·Dynamic Formula·Data Cloud SOQL(Beta/신규), LWC API v61.0(= OSS v6.0.0, ElementInternals 지원). → [[Summer '24/Development]]
- **Automation** — Transform 요소·Repeater 컴포넌트 Generally Available, MuleSoft Services Setup Generally Available, Einstein Draft Flow(Beta), 일시정지·대기 Flow 무제한, Flow Orchestration 수동 Suspend/Resume·실패 복구·Omni-Channel 라우팅. → [[Summer '24/Automation]]
- **Platform** — User Access Policy·Permission Set Summary·Search Manager Generally Available, Scratch Org Snapshots Generally Available, Event Log File Browser Generally Available, External Client App Manager·OAuth Token Exchange Handler, MFA production default-on, New Setup Domain `*.salesforce-setup.com`. → [[Summer '24/Platform]]
- **Clouds** — Service(Einstein Work Summaries for Email·Bring Your Own Channel for Messaging·Unified Knowledge Generally Available), Experience(Data Cloud 통합·Search Manager 검색 결과 레이아웃 Generally Available), Data Cloud(Waterfall Segments Generally Available), Commerce(Tax Solution for Managed Checkout Generally Available), Revenue(Dynamic Revenue Orchestrator Generally Available), Mobile(Mobile Builder Generally Available). → [[Summer '24/Clouds]]
- **Einstein** — Einstein Data Library Generally Available, Einstein Copilot Topics 확장, Prompt Builder Flex/RAG·10개 언어, Models API(Beta), Anthropic Claude 3/Google Gemini 1.5 Pro/OpenAI GPT-4o 지원. → [[Summer '24/Einstein]]
- **Release Updates** — Summer '24 강제 4건 + Winter '25 13건 + Spring '25 12건 + Summer '25 2건, 총 31건 시점 맵 + 비-RU 은퇴 일정(Salesforce Functions·Standard-Volume Platform Events·Streaming API v23–36). → [[Summer '24/Release Updates]]

---

## 관련 노트

- [[Release MOC]]
- [[Spring '24]] — 이전 릴리즈 (v60.0)
- [[Winter '25]] — 다음 릴리즈 (v62.0)
- [[Summer '24/Development]]
- [[Summer '24/Automation]]
- [[Summer '24/Platform]]
- [[Summer '24/Clouds]]
- [[Summer '24/Einstein]]
- [[Summer '24/Release Updates]]
