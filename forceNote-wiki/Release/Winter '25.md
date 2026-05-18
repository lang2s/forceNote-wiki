---
tags: [release, winter_25, v62, apex, lwc, flow, agentforce]
api_version: v62.0
release_date: 2024-10
created: 2026-05-18
source: external-knowledge
aliases: [Winter '25, Winter25, v62.0, API 62, 윈터 25]
---

# Winter '25 릴리즈 노트

> [!warning] 이 노트는 외부 지식 기반으로 작성되었으며 공식 소스와 대조되지 않았습니다. Winter '25 릴리즈 노트 PDF가 로컬에 미확보 상태입니다. 공식 릴리즈 노트: https://help.salesforce.com/s/articleView?id=release-notes.salesforce_release_notes.htm&release=248

> API v62.0 | 출시: 2024년 10월

---

## 주요 신기능

- **Agentforce 2.0 (Copilot → Agentforce 리브랜드)** — Einstein Copilot이 Agentforce로 전환. Agentforce Studio(이전 Copilot Studio)에서 에이전트 구성
- **Prompt Builder GA** — Spring '24 Beta로 소개된 Prompt Builder 정식 출시. Flex Template, Field Generation Template, Sales Email Template 지원
- **Compression Namespace Beta** — Apex 네이티브 Zip 압축/해제 라이브러리 Beta 시작 (GA는 Spring '25)
- **DataWeave in Apex 업데이트** — DataWeave 스크립트 추가 기능
- **Metadata API 서비스 보호 강화** — Winter '25 이상 신규 Org에서 `readMetadata()` / `retrieve()` 과부하 시 오류 반환 가능
- **Agentforce 패키징 지원** — Agent Topic, Agent Action, Prompt Template을 관리형 패키지에 포함 가능

---

## Agentforce & Einstein

### Agentforce 전환 (Copilot → Agentforce)

Einstein Copilot이 **Agentforce**로 재브랜딩. 에이전트를 Agentforce Studio(구 Copilot Studio)에서 구성.

| 이전 명칭 | Winter '25 명칭 |
|---|---|
| Einstein Copilot | Agentforce (Service Agent 등) |
| Copilot Studio | Agentforce Studio |
| Copilot Action | Agent Action |
| Copilot Topic | Agent Topic |

### Prompt Builder GA

Spring '24 Beta로 등장한 Prompt Builder가 Winter '25에서 GA.

```apex
// Prompt Builder — Apex에서 Prompt Template 실행 (구조 예시 — 실제 동작 코드 아님)
// ConnectApi.EinsteinPrompt 또는 InvocableMethod를 통해 호출
// 실제 코드는 공식 릴리즈 노트 참조 필요
Map<String, ConnectApi.WrappedValue> inputParams = new Map<String, ConnectApi.WrappedValue>();
ConnectApi.WrappedValue wrappedVal = new ConnectApi.WrappedValue();
wrappedVal.value = recordId;
inputParams.put('Input:recordId', wrappedVal);
```

---

## Apex

### Compression Namespace — Beta 시작

`Compression.ZipWriter` / `Compression.ZipReader` Beta 도입. (Spring '25에서 GA)

```apex
// 구조 예시 — 실제 동작 코드 아님 (GA는 Spring '25, Winter '25는 Beta)
// Compression.ZipWriter writer = new Compression.ZipWriter();
// writer.addEntry('file.txt', Blob.valueOf('hello'));
// Blob zipBlob = writer.getArchive();
```

### Metadata API 서비스 보호 강화

Winter '25 이상에서 생성된 신규 Org에 적용. `readMetadata()` 및 `retrieve()` 요청이 과부하 상태일 때 오류를 반환할 수 있다.

```apex
// 서비스 보호 대응 패턴 — 재시도 로직 (구조 예시 — 실제 동작 코드 아님)
// try {
//     MetadataService.MetadataPort service = new MetadataService.MetadataPort();
//     // readMetadata 호출
// } catch (CalloutException e) {
//     // 503 / LIMIT_EXCEEDED 처리 후 재시도
// }
```

---

## LWC

### API v62.0 변경사항

| 변경 | 설명 |
|---|---|
| Shadow DOM 마이그레이션 계속 | Native Shadow DOM 전환 준비 계속. 내부 DOM 셀렉터 의존 코드 수정 권고 |
| Base Components 업데이트 | 접근성(Accessibility) 개선 및 내부 구조 변경 |

---

## Flow

### Enhance Flexibility and Reusability in Prompt Flows (Release Update)

Prompt Flow의 유연성·재사용성 향상 업데이트. Winter '25부터 활성화 가능 (Spring '25 PDF p.191 확인).

### Screen Flow 개선

| 기능 | 설명 |
|---|---|
| Autolaunched Sub-flows 개선 | Sub-flow 내 에러 처리 강화 |
| 데이터 테이블 컴포넌트 업데이트 | 화면 Flow 내 데이터 테이블 기능 확장 |

---

## Admin / Setup

### Agentforce Agent Builder

Agentforce 에이전트를 Setup에서 구성. Agent Topic → Agent Action 매핑. 에이전트 테스트 패널 내장.

### Dynamic Forms 확장

Dynamic Forms — 추가 오브젝트 지원 확대.

---

## Release Updates (강제 적용 예정)

Winter '24 wiki에서 확인된 항목: Winter '25에 강제 적용 예정으로 명시된 항목들.

| Release Update | 강제 적용 시기 | 설명 |
|---|---|---|
| Restrict User Access to Run Flows | Winter '25 | 권한 없는 사용자의 Flow 실행 제한 강화. `FlowDefinitionView.IsActive` 대신 권한 확인 |
| Migrate from Maintenance Plan Frequency Fields to Maintenance Work Rules | Winter '25 | 유지보수 계획의 빈도 필드 → Work Rules로 마이그레이션 |

---

## 관련 노트

- [[Release MOC]]
- [[Summer '24]] — 이전 릴리즈
- [[Spring '25]] — 다음 릴리즈
