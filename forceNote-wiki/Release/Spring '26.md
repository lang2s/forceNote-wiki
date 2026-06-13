---
tags: [release, spring_26]
api_version: v66.0
release_date: 2026-02
created: 2026-06-13
source: salesforce_release_notes_6-13-2026.pdf (Salesforce Spring '26 Release Notes, Tier 2)
aliases: [Spring '26, 스프링 26, v66.0]
---

# Spring '26 릴리즈 노트

> API v66.0 | 출시: 2026년 02월 | 개발자 관점 큐레이션 (공식 Spring '26 Release Notes 발췌)

> [!note] Salesforce 공식 Spring '26 Release Notes(1342p)에서 **개발자 관련 섹션**(Development·Automation·Release Updates 등)만 발췌·정리했습니다. 전체 도메인(Marketing·Industries·Commerce 등)은 공식 노트를 참조하세요.

---

## ⭐ 주요 신기능

- **Apex Cursors GA** — 대용량 SOQL 결과를 분할 처리하는 표준/페이지네이션 커서가 정식 출시. Queueable과 결합해 Batch Apex의 한계를 대체.
- **RunRelevantTests (Beta)** — 배포 페이로드를 분석해 관련 테스트만 실행하는 새 테스트 레벨. 대형 조직 배포 속도 개선.
- **LWC 복합 템플릿 표현식 (Beta)** — 템플릿에서 복합 표현식 사용 가능.
- **전 Lightning Base Component TypeScript 타입 완성** — 모든 베이스 컴포넌트의 완전한 타입 정의 제공. ([[Lightning Base Components 레퍼런스]] 참조)
- **Apex/AuraEnabled 메서드를 Agent Action으로 노출 GA** — Apex 클래스 메서드를 어노테이션 → OpenAPI 스펙 → Agentforce 액션으로.
- **Named Query API로 REST에서 커스텀 SOQL 노출 GA**.

---

## Apex

### 신규

- **Apex Cursors / Pagination Cursors (GA)** — 대용량 SOQL 결과 집합을 분할 처리. `PaginationCursor` 클래스(`fetchPage()`, `fetchDeleted()`)로 UI 페이지네이션 구현. 양방향 순회 지원, API v66.0+.
  - 사용량 추적용 신규 거버너 메서드: `Limits.getApexCursors()` / `getLimitApexCursors()`, `Limits.getApexPaginationCursors()` / `getLimitApexPaginationCursors()`, `Limits.getApexPaginationCursorRows()` / `getLimitApexPaginationCursorRows()`.
  - AuraEnabled 직렬화/역직렬화에서 커서 지원.
- **`ConnectApi.RecordUi.getPicklistValuesByRecordType(objectApiName, recordTypeId)`** — Record Type별 모든 Picklist 필드 값을 추출 (IdeaExchange 반영).
- **`Blob.toPdf()` — Visualforce PDF 렌더링 서비스 사용 (Release Update)** — Apex `Blob.toPdf()`가 Visualforce와 동일한 렌더링 서비스 사용. 추가 폰트·멀티바이트 문자 지원.
- **Test Discovery API `category` 쿼리 파라미터** — flow 테스트만/Apex 테스트만 필터링. 기존에는 namespace·visibility로만 필터 가능.
- **`purgeOldAsyncJobs()` 오버로드** — 삭제할 가장 오래된 완료 async job 개수를 지정. 대량 삭제 시 점진적 처리.
- **DataWeave에서 중첩 SOQL 쿼리 지원** — 변환(Transformation)에 중첩 SOQL 사용 (IdeaExchange 반영).

### 변경

- **`RunRelevantTests` 테스트 레벨 (Beta)** — 배포 페이로드·의존성 분석으로 관련 테스트만 실행. `@IsTest(critical=true)`(항상 실행), `@IsTest(testFor='ApexClass:ClassName, ApexTrigger:TriggerName')`(지정 컴포넌트 변경 시 실행) 어노테이션(API v66.0+). Metadata API `DeployOptions.testLevel`, `deployRequest` REST, `sf project deploy start --test-level`로 지정.
- **`WITH USER_MODE` SOQL을 Automated Process User로 실행** — API v66.0+에서 Automated Process User가 user mode SOQL 실행 가능. v65.0 이하에서는 system mode가 아니면 실패.
- **Sharing 재계산 동작 변경 대비** — sharing recalculation 동작 변경. "Update Apex Code and Flows for Changed Sharing Recalculation Behavior" Release Update로 영향 코드 식별·수정.

### Deprecated / Release Update

- **Invocable Action 파라미터용 Apex 클래스의 no-argument 생성자 필수화 (API v66.0+)** — invocable action 파라미터로 쓰이는 Apex 클래스는 visible no-argument 생성자 필수(비패키지=public, 패키지=global). v65.0 이하 + Release Update 비활성화 시 기존 동작 유지.

### 신규 API 사용 예시

```apex
// 구조 예시 — Spring '26 릴리즈 노트 설명 기반으로 구성 (PDF 원문 코드 블록 아님)

// 1) RunRelevantTests — 배포 관련 테스트만 실행 (API v66.0+)
@IsTest(critical=true)                                  // 페이로드와 무관하게 항상 실행
private class CriticalTests { /* ... */ }

@IsTest(testFor='ApexClass:AccountService, ApexTrigger:AccountTrigger')  // 지정 컴포넌트 변경 시 실행
private class AccountServiceTests { /* ... */ }
// 배포: sf project deploy start --test-level RunRelevantTests

// 2) Record Type별 Picklist 값 추출
ConnectApi.RecordUi.getPicklistValuesByRecordType(objectApiName, recordTypeId);

// 3) Apex Pagination Cursor (GA) — UI 페이지네이션
PaginationCursor pc = Database.getPaginationCursor('SELECT Id, Name FROM Account');
pc.fetchPage();      // SOQL 쿼리/행 한도에 카운트
pc.fetchDeleted();
System.debug(Limits.getApexPaginationCursorRows() + '/' + Limits.getLimitApexPaginationCursorRows());

// 4) 삭제할 async job 개수 지정 (아래 4줄은 PDF 원문 예제 — Tier 2)
Integer maximumNumberOfJobsToDelete = 1000;
Integer count = System.purgeOldAsyncJobs(Date.today(), maximumNumberOfJobsToDelete);
System.debug('Deleted ' + count + ' old jobs.');  // 지정 날짜 이전 완료 job을 최대 N건 삭제
```

---

## LWC

### 신규

- **복합 템플릿 표현식 (Beta)** — LWC 템플릿에서 complex expression 사용.
- **빈 상태/일러스트 베이스 컴포넌트 (Beta)** — 테마 지원 일관된 Empty State Illustration.
- **Lightning Base Component 전체 TypeScript 타입 정의 완성** — 모든 베이스 컴포넌트 타입 제공.
- **Error Console** — 비치명적(non-fatal) 페이지 에러를 가로채지 않고 관리.
- **Lightning Types** — JSON 스키마로 오브젝트 기반 커스텀 Lightning Type 정의, Setup에서 생성. Agentforce 응답 구조화에 활용.
- **단일 LWC 브라우저 미리보기 (GA)** + **Local Dev → Live Preview**.
- **LWC 개발용 MCP 도구 확대 (Beta)**.

### 변경

- **Lightning Out 2.0 개선** — 외부 앱 임베드 개선.
- **Screen Flow가 LWC local action 지원** — 화면 플로우에서 LWC 로컬 액션 사용.
- **SLDS 컴포넌트 블루프린트 업데이트** + **다크 모드 에디션 확대 (Beta)**. ([[SLDS 블루프린트 카탈로그]], [[SLDS LWC 디자인 시스템]] 참조)

### Deprecated

- **LWS Trusted Mode 활성화 중단(Discontinued)** + Lightning Web Security API distortion 변경.
- **UTAM 문서가 Salesforce Developers 사이트로 이동**.

---

## Flow / Automation

### 신규

- **Agentforce로 record-triggered·scheduled 플로우 수정** — 자연어로 플로우 편집.
- **Flow Builder 탐색 개선** — collapsible path, 새 마우스 컨트롤.
- **Data Table 화면 컴포넌트에서 레코드 정렬·편집**.
- **화면 플로우 컴포넌트 레벨 스타일 오버라이드**.
- **비동기 broadcast 플로우** — 대규모 대상 메시지 전송 + Wait 요소.
- **Flow 승인 프로세스** — Flow Builder 내에서 승인 단계 화면 플로우 완료·디버깅, Request Approval 컴포넌트로 autolaunched 승인 시작.

### 변경

- **Automation Lightning App** — Action Hub 탭(어떤 Agentforce 에이전트·프롬프트 템플릿이 invocable action을 참조하는지), Flow Logs 탭(플로우 성능 가시성).
- **Flow Orchestration** — Automation Lightning App에서 오케스트레이션 생성·의존성 조회, Flow Builder 내 디버깅.
- **MuleSoft for Flow: Integration** — 자연어 플로우 빌드, AI 템플릿, 바이너리 파일 액션, 서드파티 커넥터 트리거 + Named Credentials.

---

## API

### 신규

- **Named Query API로 REST에서 커스텀 SOQL 노출 (GA)** — REST API 호출에서 커스텀 SOQL 사용.

### 변경 / 한도

- **Metadata 배포·검색 신규 한도** — Metadata Deployments and Retrievals에 새 한도 적용.
- **Data 360 SOQL 쿼리 결과 1회 12MB 제한**.

### Deprecated / Retired

- **`EventBusSubscriber`의 `Position`·`Tip` 필드 Deprecated**.
- **Outbound Message의 Session ID 전송 제거**.
- **SOAP API `login()` (v31.0–64.0) 은퇴 (Release Update)**.
- **Instanced URL 업데이트 (Release Update)** — API 트래픽의 instanced URL 갱신.
- **Invocable Action 호출이 생성자 visibility 검증 (API v66.0+)**.

---

## Packaging

- **Customized Push Upgrade로 패키지 업그레이드 관리** — 구독자에게 맞춤 푸시 업그레이드. ([[2GP — Push Upgrade]] 참조)
- **구독자에게 패키지 버전 추천**.
- **디버그 로그 활성화로 구독자 이슈 빠른 진단**.

---

## 거버너 한도 변경

| 항목 | 변경 |
|---|---|
| Apex Cursor 행 | 24시간당 신규 cursor row 누적 **최대 1억(100M)** |
| Metadata 배포/검색 | 새 한도 적용 (Metadata Deployments and Retrievals Have New Limits) |
| Data 360 SOQL | 쿼리 결과 1회 **12MB** 제한 |
| Cursor.fetch() | SOQL 쿼리 한도 + 행 한도에 계속 카운트 |

---

## Release Updates (필수 적용 항목)

### Spring '26에 강제 적용됨 (지금 적용 필수)

- **`<apex:inputField>` label 속성 이스케이프 (XSS 방지)** — Visualforce 페이지 XSS 방지를 위해 label 속성 이스케이프. Spring '23 최초 제공 → **Spring '26 강제 적용**.
- **Legacy Host Name 참조 업데이트** — 비강화(non-enhanced) 호스트명 임시 리다이렉션 종료. Spring '25 최초 제공 → **Spring '26 강제 적용**.

### Summer '26에 강제 적용 예정

- **Date Picker·Popover·하단 유틸리티 바·레코드 헤더 접근성 개선** (WCAG 2.2 Resize/Reflow).
- **Page Header·Modal 접근성 개선 (200% 확대 시)** (WCAG 2.2).

---

## 관련 노트

- [[Release MOC]]
- [[Winter '26]] — 이전 릴리즈 (v65.0)
- [[Summer '26]] — 다음 릴리즈 (v67.0)
- [[Lightning Base Components 레퍼런스]] — 베이스 컴포넌트 타입 정의 완성 관련
- [[SLDS LWC 디자인 시스템]] · [[SLDS 블루프린트 카탈로그]] — SLDS 다크모드·블루프린트 업데이트
- [[2GP — Push Upgrade]] — Customized Push Upgrade
