---
tags: [release, spring_26]
api_version: v66.0
release_date: 2026-02
created: 2026-06-13
source: salesforce_release_notes_6-13-2026.pdf (Salesforce Spring '26 Release Notes, Tier 2)
aliases: [Spring '26, 스프링 26, v66.0, 스프링26 릴리즈 노트, 2026 봄 릴리즈, Spring 26 허브]
---

# Spring '26 릴리즈 노트

> API v66.0 | 출시: 2026년 02월 | 공식 Spring '26 Release Notes(`salesforce_release_notes_6-13-2026.pdf`) 발췌 큐레이션

> [!note] 분량이 커서 **허브(라우팅) + 6개 영역별 하위 노트**로 분할했습니다. 도메인별 전수 내용은 아래 하위 노트를, 폴더 목록은 [[Spring '26/index|폴더 인덱스]]를 참조하세요.

---

## ⭐ 파괴적 / 중단 변경 — 요지

Spring '26은 Summer '26(v67.0)의 secure-by-default 같은 대규모 파괴적 변경은 없으나, 다음 **중단·필수 마이그레이션** 3건은 지금 또는 곧 영향을 준다.

1. **새 Connected App 생성 기본 비활성** — 모든 org에서 새 connected app을 생성할 수 없다(기존 app·패키지 배포는 영향 없음). External Client App으로 전환한다. → [[Spring '26/Platform]]
2. **Legacy Host Name 임시 리다이렉션 종료 — Spring '26 강제** + `<apex:inputField>` label XSS 이스케이프 **Spring '26 강제**. → [[Spring '26/Release Updates]]
3. **Email 도메인 소유권 검증 의무화** (Feb 25 / Apr 14 / May 4 단계) — 검증되지 않은 도메인은 이메일 발송이 차단된다. → [[Spring '26/Platform]]

---

## 하위 노트 (도메인별 분리)

| 하위 노트 | 다루는 범위 |
|---|---|
| [[Spring '26/Development]] | Apex · LWC · API · Visualforce · Packaging · Dev Environments — GA 전수 + verbatim 코드 + New&Changed(네임스페이스별) + 거버너 한도 |
| [[Spring '26/Platform]] | Admin/Customization · Automation+Flow · Security/Identity/Privacy · Mobile · Hyperforce · Salesforce Overall · Deployment |
| [[Spring '26/Clouds]] | Analytics · Data 360 · Commerce · Experience Cloud · Field Service · Industries · Sales · Service · MuleSoft · Omnistudio · Partner Cloud · Revenue Management · Marketing · CMS |
| [[Spring '26/Agentforce]] | Agentforce/Einstein GA · Beta · Dev Preview · 지원 모델 변경 · standard agent topics/actions |
| [[Spring '26/Release Updates]] | 강제 적용 시점의 **단일 권위 출처**(authoritative) |

빠른 선택은 [[Spring '26/index]] (폴더 인덱스) 참조.

```text
// 구조 예시 — 탐색 경로 안내(실제 동작 코드 아님)
00 Home → Release MOC → Spring '26 (허브)
                          ├─ Development     (Apex·LWC·API)
                          ├─ Platform        (Admin·Flow·Security·Mobile·Hyperforce)
                          ├─ Clouds          (Data 360·Analytics·Field Service·…)
                          ├─ Agentforce      (Einstein·AI 에이전트)
                          └─ Release Updates  (강제 적용 시점 단일 출처)
```

---

## 섹션별 GA 하이라이트

| 도메인 | 하이라이트 | 상세 |
|---|---|---|
| Apex | Apex Cursors GA · `purgeOldAsyncJobs` 오버로드 · `getPicklistValuesByRecordType` · RunRelevantTests **Beta** | [[Spring '26/Development]] |
| LWC | 복합 템플릿 표현식 **Beta** · 전 Base Component TypeScript 타입 완성 · 단일 컴포넌트 Live Preview GA | [[Spring '26/Development]] |
| API | Named Query API로 REST에서 커스텀 SOQL 노출 GA · GraphQL mutation GA | [[Spring '26/Development]] |
| Agentforce | 새 Agentforce Builder GA · Task Resolution 메트릭 GA · Agentforce Grid GA · HyperClassifier | [[Spring '26/Agentforce]] |
| Flow | Draft Flow with AI GA · Screen Flow URL GA · MuleSoft for Flow GA(커넥터·바이너리·IDP) | [[Spring '26/Platform]] |
| Security | Passkeys GA(4월) · Database Encryption GA · Connected App 생성 비활성 | [[Spring '26/Platform]] |
| Clouds | Data 360 8 · Analytics 5 · Field Service 5 · Service 2 · MuleSoft 2(API Catalog) 등 | [[Spring '26/Clouds]] |
| Release Updates | inputField XSS · Legacy Host Name Spring '26 강제 외 시점 맵 | [[Spring '26/Release Updates]] |

---

## 연관 패턴 노트 업데이트 필요

Spring '26 변경이 영향을 주는 기존 패턴 노트(작성·보완 후보):

- [ ] [[WITH USER_MODE]] — `WITH USER_MODE` SOQL을 Automated Process User로 실행(v66.0+)
- [ ] [[2GP — Push Upgrade]] — Customized Push Upgrade 반영
- [ ] [[Lightning Base Components 레퍼런스]] — 전 베이스 컴포넌트 TypeScript 타입 완성
- [ ] [[SLDS LWC 디자인 시스템]] · [[SLDS 블루프린트 카탈로그]] — 블루프린트·다크모드 확대
- [ ] [[EventBus Namespace]] — `EventBusSubscriber`의 `Position`·`Tip` 필드 Deprecated

---

## 관련 노트

- [[Release MOC]]
- [[Spring '26/index]] — 폴더 인덱스
- [[Winter '26]] — 이전 릴리즈 (v65.0)
- [[Summer '26]] — 다음 릴리즈 (v67.0)
- [[WITH USER_MODE]] · [[EventBus Namespace]] · [[ConnectApi Namespace 개요]]
- [[Lightning Base Components 레퍼런스]] · [[SLDS LWC 디자인 시스템]] · [[SLDS 블루프린트 카탈로그]]
- [[2GP — Push Upgrade]]
