---
tags: [release, spring_24]
api_version: v60.0
release_date: 2024-02
created: 2026-05-17
source: salesforce_spring24_release_notes.pdf
aliases: [Spring '24, 스프링 24, v60.0, 스프링24 릴리즈 노트, 2024 봄 릴리즈, Spring 24 허브]
---

# Spring '24 릴리즈 노트

> API v60.0 | 출시: 2024년 02월
> 공식 문서: [Release Notes](https://help.salesforce.com/s/articleView?id=release-notes.salesforce_release_notes.htm)
> 이 릴리즈는 분량이 커서 도메인별 spoke로 분리되어 있다. 아래 라우팅에서 도메인을 골라 상세로 이동한다.

---

## 하위 노트 (도메인별 라우팅)

| Spoke | 다루는 범위 |
|---|---|
| [[Spring '24/Development]] | Apex(`??`·UUID·`releaseSavepoint`·Compression·FormulaEval) · LWC(Workspace API·record-picker·logger) · API v60.0 · Packaging · Platform Events |
| [[Spring '24/Automation]] | Flow Builder(Reactive·Repeater·Transform·Wait Until Event·HTTP Callout Schema·Template-Triggered Prompt Flow) · Flow Orchestration |
| [[Spring '24/Platform]] | Admin/Customization(Dynamic Forms·PSG 전 에디션·Connect SQL/Snowflake·ICU) · Security(OAuth Token Exchange·SAML·MFA) · Mobile · Hyperforce · Architecture |
| [[Spring '24/Clouds]] | Sales · Service · Data Cloud · Analytics · Commerce · Experience Cloud · Field Service · Industries · Marketing Cloud Growth · Revenue Lifecycle Management |
| [[Spring '24/Einstein]] | Einstein Copilot · Prompt Builder · Einstein Studio · Trust Layer · Einstein Bots |
| [[Spring '24/Release Updates]] | 27개 Release Update 시점 맵 (강제 적용 일정) |

---

## ⭐ 주요 신기능

- **Einstein Copilot (GA)** — CRM 내장 대화형 AI 어시스턴트(레코드 요약·이메일 초안·기회 분석). → [[Spring '24/Einstein]]
- **Prompt Builder (GA)** — 생성형 AI 프롬프트 템플릿 관리·배포 플랫폼. → [[Spring '24/Einstein]]
- **Apex Null 병합 연산자 (`??`)** — null 체크를 간결하게 표현하는 신규 연산자. → [[Spring '24/Development]]
- **Revenue Lifecycle Management (GA)** — Product Catalog·Pricing·Configurator·Quote/Order Capture·Asset Lifecycle 통합 신규 출시. → [[Spring '24/Clouds]]
- **Marketing Cloud Growth 에디션 (GA)** — Salesforce 플랫폼 기반 마케터용 캠페인 관리 솔루션 정식 출시. → [[Spring '24/Clouds]]
- **Hyperforce 한국·스웨덴 리전 (GA)** — Customer 360 앱 스위트를 한국·스웨덴에서 GA 제공(누적 13개국). → [[Spring '24/Platform]]
- **`lightning-record-picker` (GA)** — 레코드 검색·선택 컴포넌트, 최대 100건 조회·오프라인 지원. → [[Spring '24/Development]]

---

## ⚠️ 파괴적 / 주의 변경

> 상세·코드·이관 가이드는 각 spoke에 있음.

- **API v60.0 동작 변경** — Quiddity 기본값 `R`(Synchronous Uncategorized) → `UD`(undefined), `Type.forName()` 잘못된 네임스페이스 시 null 반환, LWC `this.childNodes`가 모든 노드(텍스트·주석 포함) 반환, 비-LightningElement 클래스 데코레이터 사용 시 SyntaxError. → [[Spring '24/Development]]

```apex
// 영향받는 식별자 요약 — 코드·이관 가이드는 [[Spring '24/Development]] 참조
Type.forName('badNamespace', 'MyClass'); // v60.0+: null 반환 (기존 불확정)
```
- **ICU Locale Formats (Rolling)** — JDK 로케일 형식 은퇴, ICU 로케일로 롤링 전환 시작(Spring '25까지 유예 가능). 날짜·시간·통화 형식 변경. → [[Spring '24/Platform]]
- **Spring '24 강제 적용 Release Update 5건** — Faster Account Sharing Recalculation · ICU Locale Formats · JsonAccess Annotation Validation(Visualforce Remoting) · RFC 7230 Validation for Apex RestResponse Headers · MFA Auto-Enablement for All Remaining Orgs. 시점 맵 전체(27건)는 → [[Spring '24/Release Updates]]

---

## 섹션별 GA 하이라이트

- **Development** — Apex `??`·UUID·`Database.releaseSavepoint()` GA, Compression·FormulaEval Developer Preview. LWC Workspace API·record-picker·logger GA, API v60.0. → [[Spring '24/Development]]
- **Automation** — Reactive Screen(Display/Long Text 실시간 반응) GA, Repeater·Transform Beta, Wait Until Event, HTTP Callout Schema 자동 감지, Template-Triggered Prompt Flow, Flow Orchestration 파우즈 한도 폐지. → [[Spring '24/Automation]]
- **Platform** — Dynamic Forms 관련 오브젝트 필드 배치, Permission Set Groups 전 에디션 지원, Salesforce Connect SQL(Snowflake 직접 연결), OAuth 2.0 Token Exchange Flow, SAML 다중 구성, MFA 자동 활성화 완료, Hyperforce 한국·스웨덴 GA. → [[Spring '24/Platform]]
- **Clouds** — Service(Einstein Search Answers GA·Lightning Editor GA·Work Summaries GA), Data Cloud(Amazon Kinesis GA·Einstein Studio GA), Analytics(Amazon Athena·Databricks 커넥터 GA·Semi-Join), RLM GA, Marketing Cloud Growth GA. → [[Spring '24/Clouds]]
- **Einstein** — Einstein Copilot GA, Prompt Builder GA, Einstein Studio GA, Trust Layer 데이터 마스킹, Einstein Bots Cross-Lingual Intent Model GA(19개 언어). → [[Spring '24/Einstein]]
- **Release Updates** — Spring '24 강제 5건 + Summer '24·Winter '25·Spring '25·Summer '25 예정 항목 포함 27개 시점 맵. → [[Spring '24/Release Updates]]

---

## 관련 노트

- [[Release MOC]]
- [[Winter '24]] — 이전 릴리즈 (v59.0)
- [[Summer '24]] — 다음 릴리즈 (v61.0)
- [[Spring '24/Development]]
- [[Spring '24/Automation]]
- [[Spring '24/Platform]]
- [[Spring '24/Clouds]]
- [[Spring '24/Einstein]]
- [[Spring '24/Release Updates]]
