---
tags: [release, spring25, v63, apex, lwc, flow, agentforce, slds, orchestration, mulesoft, devops, cli]
api_version: v63.0
release_date: 2025-02
source: salesforce_spring25_release_notes.pdf — Salesforce Spring '25 Release Notes
created: 2026-05-18
aliases: [Spring '25, Spring25, v63.0, API 63, 스프링 25]
---

# Spring '25 Release Notes

> API v63.0 | 출시: 2025년 02월  
> 공식 문서: [Release Notes](https://help.salesforce.com/s/articleView?id=release-notes.salesforce_release_notes.htm)

---

> [!note] 영역별 **전수 하위 노트(spoke)**로 분할됨. 아래 허브는 라우팅·하이라이트만 담고, 도메인별 GA 전수·코드·표는 하위 노트를 참조하세요. 빠른 목록은 [[Spring '25/index|폴더 인덱스]].

| 하위 노트 | 범위 |
|---|---|
| [[Spring '25/Development]] | Apex · LWC · API — GA 전수 + verbatim 코드 + 네임스페이스별 New&Changed + 거버너 한도 |
| [[Spring '25/Platform]] | Admin · Security · Flow/Automation · Mobile · DevOps · Architecture |
| [[Spring '25/Clouds]] | Sales · Service · Data · Analytics 등 클라우드 GA/Beta |
| [[Spring '25/Industries]] | Industries 클라우드 전용 기능 |
| [[Spring '25/Agentforce]] | Agentforce · Einstein · Prompt Builder · 지원 모델 |
| [[Spring '25/Release Updates]] | 강제 적용 항목 · 시점 맵 |

---

## ⭐ 주요 신기능

- **Compression Namespace GA** — Zip 파일 압축·해제를 Apex 네이티브로 처리 (`Compression.ZipWriter`/`ZipReader`) → [[Spring '25/Development]]
- **FormulaEval Namespace GA** — `FormulaEval`로 SObject·Apex 객체에 동적 수식 평가, 다형성 관계 필드 지원 → [[Spring '25/Development]]
- **Scheduled Jobs Pause/Resume** — `System` 클래스로 스케줄 잡 프로그래밍적 일시정지·재개 → [[Spring '25/Development]]
- **Local Dev GA** — Lightning 앱에서 로컬 개발 서버 실시간 브라우저 미리보기 정식 출시 → [[Spring '25/Development]]
- **SLDS 2 지원 (Beta)** — 베이스 컴포넌트가 SLDS 2 테마/브랜딩 베타 지원 (`--slds-c-*` 훅 미지원 주의) → [[Spring '25/Development]]
- **LWC `apiVersion` 필수화** — 모든 커스텀 컴포넌트 `.js-meta.xml`에 `apiVersion` 필수 → [[Spring '25/Development]]
- **Einstein for Flow GA** — 자연어로 Flow 자동 생성, Flow Formula Builder·Description 생성 포함 → [[Spring '25/Platform]]
- **MuleSoft for Flow: Integration GA** — Flow Builder에서 40+ 서드파티 커넥터 노코드 연동 → [[Spring '25/Platform]]
- **Flow Approval Processes** — Orchestration 기반 신규 승인 워크플로우, Queue/그룹 배정·이메일 회신 승인 → [[Spring '25/Platform]]
- **Flow Orchestration 개선** — Stage Fault Path, 인터랙티브 스텝 커스텀 이메일, Run Details 개선 → [[Spring '25/Platform]]
- **Agentforce DX (Beta)** — Salesforce CLI·VS Code로 Agent 프로코드 생성·테스트 (`@salesforce/plugin-agent`) → [[Spring '25/Development]] · [[Spring '25/Agentforce]]
- **DevOps Testing GA** — DevOps Center AI 기반 테스트·QA 정식 출시 → [[Spring '25/Development]]
- **API v21.0–30.0 폐기 일정 연기** — Summer '23 → Summer '25로 연기, 즉시 업그레이드 필요 → [[Spring '25/Release Updates]]

---

## 파괴적 변경 / 강제 적용 (요지)

> 전체 표·시점 맵은 → [[Spring '25/Release Updates]]

```text
# 강제 적용 요지 — 상세는 [[Spring '25/Release Updates]]
# LWC Stacked Modals → Spring '25 강제 (Aura → LWC 모달 전환).
# Prompt Flows Flex 제거 → Spring '25 강제 (Manual Input 전환 필요).
# 조치: 영향받는 모달·Prompt Flow를 즉시 마이그레이션.
```

- **LWC Stacked Modals** — Spring '25 강제 적용. Aura → LWC 모달 전환, Dynamic Forms 지원 확대.
- **Enhance Flexibility in Prompt Flows** — Spring '25 강제. Template-Triggered Prompt Flow에서 Flex Prompt Template 제거 → Manual Input 전환 필요.
- **발신자 이메일 주소 인증** — Spring '25 이후. My Email Settings 이메일 주소 인증 필수.
- **Platform API v21.0–30.0 폐기** — Summer '25에 SOAP/REST/Bulk 레거시 API 요청 차단.
- **마스터-디테일 리패런팅 제한 강화·예외 타입 JSON 직렬화 금지** (API v63.0+) 등 개발자 영향 변경 → [[Spring '25/Development]]

---

## 섹션별 GA 하이라이트

| 도메인 | 하이라이트 (1줄) | 상세 |
|---|---|---|
| Apex | Compression·FormulaEval 네임스페이스 GA, Scheduled Jobs Pause/Resume, 동시 장기 요청 한도 라이선스 확장, master-detail 리패런팅·예외 직렬화 변경 | [[Spring '25/Development]] |
| LWC | `apiVersion` 필수화, Local Dev GA, SLDS 2 Beta, Native Shadow DOM 추가 컴포넌트, LWS API distortion 추가 | [[Spring '25/Development]] |
| API | v21.0–30.0 폐기 연기, Instance URL → My Domain URL 전환 필수, Bulk API V2 쿼리 Platform Event Beta, sObjects REST OpenAPI Beta | [[Spring '25/Development]] |
| Flow / Automation | Einstein for Flow GA, Transform 컬렉션 Join, Screen Action Beta·진행 표시기, Flow Approval Processes, Orchestration Fault Path | [[Spring '25/Platform]] |
| Admin / Setup | Automation Lightning App Monitor 탭, Data Cloud 트리거드 플로우 프로덕션 배포, Flow Builder UX 개선 | [[Spring '25/Platform]] |
| Security | LWS 신규/변경 distortion, ESLint 규칙, Metadata API 서비스 보호 강화 | [[Spring '25/Platform]] |
| DevOps / CLI | DevOps Testing GA, Salesforce CLI v2.53.6+ (data·api request·ARM64), Data Mask Einstein 라이브러리·Run on Refresh | [[Spring '25/Development]] |
| Architecture | Source Tracking 개별 샌드박스 활성화, Database Access 디버그 로그 카테고리 | [[Spring '25/Platform]] |
| Clouds | Sales · Service · Data Cloud · Analytics GA/Beta | [[Spring '25/Clouds]] |
| Industries | Health · FSC · Public Sector · Manufacturing 등 산업별 기능 | [[Spring '25/Industries]] |
| Agentforce / Einstein | Agentforce DX Beta, Agentforce 패키징(1GP/2GP), Einstein Flow Formula/Description, Developer Edition Agentforce 포함 | [[Spring '25/Agentforce]] |

---

## 관련 노트

- [[Release MOC]]
- [[Winter '25]] — 이전 릴리즈
- [[Summer '25]] — 다음 릴리즈
- [[Spring '25/index]] — 폴더 인덱스
</content>
</invoke>
