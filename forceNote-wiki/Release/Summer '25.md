---
tags: [release, summer_25]
api_version: v64.0
release_date: 2025-06
created: 2026-05-17
source: salesforce_summer25_release_notes.pdf
aliases: [Summer '25, 서머 25]
---

# Summer '25 릴리즈 노트

> API v64.0 | 출시: 2025년 06월  
> 공식 문서: [Release Notes](https://help.salesforce.com/s/articleView?id=release-notes.salesforce_release_notes.htm)

---

> [!note] 영역별 **전수 하위 노트(spoke)**로 분할됨. 아래 허브는 라우팅·하이라이트만 담고, 도메인별 GA 전수·코드·표는 하위 노트를 참조하세요. 빠른 목록은 [[Summer '25/index|폴더 인덱스]].

| 하위 노트 | 범위 |
|---|---|
| [[Summer '25/Development]] | Apex · LWC · API — GA 전수 + verbatim 코드 + 네임스페이스별 New&Changed + 거버너 한도 |
| [[Summer '25/Platform]] | Admin · Security · Flow/Automation · Mobile · DevOps · Architecture |
| [[Summer '25/Clouds]] | Sales · Service · Data · Analytics 등 클라우드 GA/Beta |
| [[Summer '25/Industries]] | Industries 클라우드 전용 기능 |
| [[Summer '25/Agentforce]] | Agentforce 3 · 기능 · Prompt Builder · Einstein Trust Layer · 지원 모델 |
| [[Summer '25/Release Updates]] | 강제 적용 항목 · 시점 맵 |

---

## ⭐ 주요 신기능

- **Agentforce 3** — 하이브리드 인력을 관리·확장하는 최초의 AI 에이전트 플랫폼. Agent API를 Apex 클래스 또는 Flow에서 직접 호출 가능 → [[Summer '25/Agentforce]]
- **Agentforce Employee Agent** — 사내 워크플로우 자동화용 에이전트. Developer Edition에서도 사용 가능 → [[Summer '25/Agentforce]]
- **Claude Sonnet 4 / GPT 5 / Gemini 2.5 모델 지원** — Einstein Platform에서 최신 외부 AI 모델 선택 사용 가능 → [[Summer '25/Agentforce]]
- **동적 수식 Template Mode 평가** — `parseAsTemplate()` 메서드로 DML 없이 머지 필드 인터폴레이션 수식 평가 → [[Summer '25/Development]]
- **Salesforce Platform API v21.0–30.0 폐기 강제 적용** — Summer '25에 실제 차단 시작, 구버전 API 사용 코드 즉시 업그레이드 필요 → [[Summer '25/Release Updates]]
- **Flow Approval Process GA** — 코드 없이 승인 프로세스를 Flow Builder에서 생성·실행·회수 → [[Summer '25/Platform]]
- **Dynamic Related Lists 모바일 지원 (Beta)** — 데스크탑과 동일한 Dynamic Related List 경험을 모바일에서도 제공 → [[Summer '25/Platform]]
- **ICU 로케일 형식 자동 활성화** — API v45+ 사용 조직에 Summer '25에서 자동 적용 → [[Summer '25/Release Updates]]
- **Salesforce Channels (Slack 통합)** — Salesforce 레코드 페이지 내에서 Slack 채널로 협업 직접 가능 → [[Summer '25/Platform]]
- **Shield Database Encryption Beta** — Sandbox에서 데이터베이스 암호화 베타 시작 → [[Summer '25/Platform]]

---

## 파괴적 변경 / 강제 적용 (요지)

> 전체 표·시점 맵은 → [[Summer '25/Release Updates]]

```text
# 강제 적용 요지 — 상세는 [[Summer '25/Release Updates]]
# Salesforce Platform API v21.0–30.0 폐기 → Summer '25에 호출 차단 (SOAP/REST/Bulk).
# 조치: 통합·코드의 API 버전을 v31.0 이상으로 업그레이드.
```

- **Salesforce Platform API v21.0–30.0 Retirement** — Summer '25에 SOAP/REST/Bulk API v21~30 호출 즉시 차단. v31+로 즉시 업그레이드.
- **Enable ICU Locale Formats** — Apex v45+ 조직에서 날짜·시간·통화 형식이 JDK→ICU로 자동 교체.
- **Enable Secure Roles Behavior** — "Roles and Subordinates" → "Roles and Internal Subordinates" 그룹명 변경 (Sandbox 강제, Production은 Winter '26).
- **Restrict User Access to Run Flows** — Winter '26 강제. FlowSites org permission 폐기 → 프로파일/Permission Set으로 Flow 실행 권한 명시 부여.
- **Outbound Message 타임아웃 60초 → 20초**, **Shift_JIS → Windows-31J 매핑 제거**, **`lightning/platformResourceLoader` 동적 import 차단** 등 개발자 영향 변경 → [[Summer '25/Development]]

---

## 섹션별 GA 하이라이트

| 도메인 | 하이라이트 (1줄) | 상세 |
|---|---|---|
| Apex | `FormulaBuilder.parseAsTemplate()`, `embeddedai`·`flowtesting`·`ComplianceMgmt`·`CommerceBuyGrp`·`Auth` 네임스페이스, Platform Event Trigger Batch Size UI | [[Summer '25/Development]] |
| LWC | `lightning/mediaUtils` GA, AgentforceInput/Output 타겟, `lightning-datatable`/`lightning-tree-grid` 신규 기능 | [[Summer '25/Development]] |
| API | v64.0, Composite API EventLogFile, sObjects REST OpenAPI (Beta), Connect REST API 레이트 리밋 마이그레이션 | [[Summer '25/Development]] |
| Flow / Automation | Flow Approval Process GA, 자동 트리거 Screen Actions GA, Orchestration Fault Path, MuleSoft for Flow 커넥터 | [[Summer '25/Platform]] |
| Admin / Setup | Object Manager 권한 일괄 수정, List Views LWC 전환, Heroku Apps in Setup GA, Salesforce Connect Hyperforce 한도 제거 | [[Summer '25/Platform]] |
| Security | External Client App + SAML, Shield Database Encryption Beta, AES-GCM/P1363, 신규 Event Log Objects | [[Summer '25/Platform]] |
| DevOps / CLI | 2GP 패키지 마이그레이션 GA, CLI push upgrade, ApexGuru, Scale Test 통합 | [[Summer '25/Platform]] |
| Architecture | Hyperforce 인도 하이데라바드 신규 리전, CDN 단일 도메인 인증서 전환, Salesforce Functions 퇴직 | [[Summer '25/Platform]] |
| Agentforce / Einstein | Agentforce 3, Service Agent GA, Prompt Builder Structured Outputs/Citations, 신규 지원 모델표 | [[Summer '25/Agentforce]] |

---

## 연관 패턴 노트 업데이트 필요

> 이 릴리즈로 인해 수정이 필요한 기존 노트 (릴리즈 콘텐츠가 아닌 후속 작업 목록)

- [ ] `Apex/Data(데이터)/` — `FormulaBuilder.parseAsTemplate()` 신규 메서드 패턴 추가 검토
- [ ] `Apex/PlatformEvents(플랫폼이벤트)/` — Platform Event Trigger Batch Size UI 노출, Outbound Message 타임아웃 변경 주석 추가
- [ ] `Apex/Testing(테스트)/` — `flowtesting` 네임스페이스 및 Flow 통합 테스트 패턴 추가
- [ ] `LWC/ComponentAPI(컴포넌트API)/` — `lightning-datatable` 신규 메서드, `lightning-tree-grid` 신규 기능 업데이트
- [ ] `LWC/Security(보안)/` — `data:` URL 보안 처리, `platformResourceLoader` 동적 import 차단 주의사항 추가
- [ ] `Flow/index.md` — Flow Approval Process GA, Orchestration Fault Path 신규 기능 반영
- [ ] `Apex/Security(보안)/` — API v21~30 폐기 강제 적용, SAML 프레임워크 마이그레이션 주의사항
- [ ] `Integration(통합)/통합 MOC.md` — MuleSoft for Flow 신규 커넥터, Heroku AppLink GA 반영

---

## 관련 노트

- [[Release MOC]]
- [[Spring '25]] — 이전 릴리즈
- [[Winter '26]] — 다음 릴리즈
