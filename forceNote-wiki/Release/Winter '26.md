---
tags: [release, winter_26]
api_version: v65.0
release_date: 2025-10
created: 2026-05-17
source: salesforce_winter26_release_notes.pdf
aliases: [Winter '26, 윈터 26]
---

# Winter '26 릴리즈 노트

> API v65.0 | 출시: 2025년 10월  
> 공식 문서: [Release Notes](https://help.salesforce.com/s/articleView?id=release-notes.salesforce_release_notes.htm)

---

> [!note] 영역별 **전수 하위 노트(spoke)**로 분할 완료. 아래 허브는 라우팅·하이라이트만 담고, 도메인별 GA 전수·코드·표는 하위 노트를 참조하세요. 빠른 목록은 [[Winter '26/index|폴더 인덱스]].

| 하위 노트 | 범위 |
|---|---|
| [[Winter '26/Development]] | Apex · LWC · API — GA 전수 + verbatim 코드 + 네임스페이스별 New&Changed + 거버너 한도 |
| [[Winter '26/Platform]] | Admin · Security · Flow/Automation · Mobile · DevOps · Architecture |
| [[Winter '26/Clouds]] | Sales · Service · Commerce · Data 360 · Analytics · Industries 등 클라우드 GA/Beta |
| [[Winter '26/Agentforce]] | Agentforce & Einstein — GA·Beta·모델·과금·표준 토픽/액션 |
| [[Winter '26/Release Updates]] | 강제 적용 항목 · 시점 맵 |

---

## ⭐ 주요 신기능

- **SLDS 2 (GA)** — CSS Styling Hook 기반 새 디자인 시스템 정식 출시 (다크 모드 Beta, 밀도 인식 styling hook) → [[Winter '26/Development]]
- **Test Discovery/Runner API** — Apex 테스트를 REST API로 탐색·실행 (CI/CD 파이프라인 통합) → [[Winter '26/Development]]
- **Flow 내 Transform 인라인 처리** — 별도 Transform 요소 없이 액션 설정 안에서 데이터 변환 → [[Winter '26/Platform]]
- **LWC Local Actions for Screen Flow** — LWC로 Flow 로컬 액션 제작 가능 → [[Winter '26/Platform]]
- **New Agentforce Builder (Beta) + Agent Script** — 서비스·직원 에이전트 통합 빌더, 결정론적 로직 + LLM 결합 → [[Winter '26/Agentforce]]
- **Database Encryption (GA)** — Hyperforce 전체 org 암호화 정식 출시 → [[Winter '26/Platform]]
- **DevOps Center MCP Tools** — LLM으로 머지 충돌 분석·해결, Apex/Flow 테스트를 DevOps Testing에 통합 → [[Winter '26/Platform]]
- **새 Setup 도메인 (`*.salesforce-setup.com`)** — Setup 페이지 도메인 이전, Winter '26부터 프로덕션 순차 적용 → [[Winter '26/Platform]]
- **Agentforce 모델 GA** — O3/O4 Mini · Claude Sonnet/Haiku 4.5 · GPT 5.x · Gemini 3 Flash/Pro 등 신규 모델 → [[Winter '26/Agentforce]]
- **4개 항목 Winter '26 강제 적용** — 이메일 인증, Secure Roles, Flow 실행 권한 제한, Agentforce Service Assistant 라이선스 → [[Winter '26/Release Updates]]

---

## 파괴적 변경 / 강제 적용 (요지)

> 전체 표·시점 맵은 → [[Winter '26/Release Updates]]

```text
# 강제 적용 요지 — 상세는 [[Winter '26/Release Updates]]
# Winter '26에 강제 적용된 4건. Setup → Release Updates 페이지에서 기한 전 반드시 적용·테스트.
```

- **Confirm Verified Email Addresses for Users Created in 2016 and Earlier** — 2016년 11월 1일 이전 생성 사용자 이메일 미인증 시 발송 불가. 해당 사용자 이메일 인증.
- **Enable Secure Roles Behavior (Production)** — "Roles and Subordinates" → "Roles and Internal Subordinates" 그룹명 변경. 코드·커스터마이징의 그룹명 참조 업데이트.
- **Restrict User Access to Run Flows** — 올바른 Profile/Permission Set 없는 사용자는 Flow 실행 불가. FlowSites org 권한 deprecated.
- **Update Licenses for Agentforce Service Assistant Users** — Service Assistant 권한 제거, Service Planner User PSL 필요.
- **SOAP API login() (v31.0–64.0) 은퇴 예고 (Summer '27)**, **Salesforce Functions 서비스 종료** 등 개발자 영향 변경 → [[Winter '26/Development]] · [[Winter '26/Platform]]

---

## 섹션별 GA 하이라이트

| 도메인 | 하이라이트 (1줄) | 상세 |
|---|---|---|
| Apex | Test Discovery/Runner API, ApexDoc, abstract/override 접근 제어자, 대용량 External Service Callout | [[Winter '26/Development]] |
| LWC | API v65.0 (커스텀 컴포넌트 버전별 변경 없음), Local Dev 미리보기 개선 | [[Winter '26/Development]] |
| API | v65.0, Test Discovery `tooling/tests/`, Test Runner `runTestsAsynchronous/`, Flow Run-Time 변경 | [[Winter '26/Development]] |
| Flow / Automation | 인라인 Transform, LWC Local Actions, 중첩 루프(Beta), Persistent Logging, 버전 비교 | [[Winter '26/Platform]] |
| Admin / Setup | 리스트 뷰 다중 컬럼 정렬 GA, 새 Setup Home, PSL 자동 회수, External Services 한도 증가 | [[Winter '26/Platform]] |
| Security | Database Encryption GA, JWT 토큰 12시간, External Client App 로테이션, Data Detect 확장 | [[Winter '26/Platform]] |
| DevOps / CLI | DevOps Center MCP Tools, DX MCP Server(Beta), `sf package version retrieve`, 2GP 완전 전환 | [[Winter '26/Platform]] |
| Architecture | 새 Setup 도메인, Lightning CDN → CloudFront, Hyperforce 리전 확장, TLS 인증서 수명 단축 | [[Winter '26/Platform]] |
| Agentforce / Einstein | New Agentforce Builder(Beta)+Agent Script, Agent Analytics GA, 24개 언어 GA, 신규 모델 GA | [[Winter '26/Agentforce]] |
| Clouds | Sales · Service · Commerce · Data 360 · Analytics · Industries GA/Beta | [[Winter '26/Clouds]] |

---

## 연관 패턴 노트 업데이트 필요

> 이 릴리즈로 인해 수정이 필요한 기존 노트 (릴리즈 콘텐츠가 아닌 후속 작업 목록)

- [x] [[@InvocableMethod 패턴]] — `InvocableActionExtension` 메타데이터로 액션 설정 강화 내용 추가
- [ ] [[Flow 설계 베스트 프랙티스]] — 인라인 Transform 처리, 중첩 루프, LWC Local Action 패턴 추가
- [ ] [[Flow 에러 처리]] — Persistent Logging 및 디버거 개선 내용 반영
- [ ] [[Batch Apex]] — Test Discovery/Runner API를 이용한 CI 자동화 패턴 참조 추가
- [ ] [[Permission Set 설계]] — Permission Set License 자동 회수, Secure Roles Behavior 강제 적용 내용 추가
- [x] [[External Services]] — Binary File 지원, 한도 증가(3,000 오브젝트/오퍼레이션, 700 등록) 반영
- [x] [[Platform Encryption]] — Database Encryption GA, Field Audit Trail 선언적 보존 정책 내용 추가
- [ ] [[Salesforce DX 개요]] — MCP Tools (DevOps Center, LWC), `sf package version retrieve`, Quick Create/Clone 내용 추가
- [x] [[SLDS LWC 디자인 시스템]] — SLDS 2 GA, 다크 모드, 밀도 인식 Styling Hook 내용 추가

---

## 관련 노트

- [[Release MOC]]
- [[Summer '25]] — 이전 릴리즈
- [[Summer '26]] — 다음 릴리즈
