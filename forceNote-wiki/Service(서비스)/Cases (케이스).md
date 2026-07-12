---
tags: [service-cloud, cases, case-management, support]
source: help.salesforce.com (Salesforce Help — Service; What's a Case? / Set Up and Manage Cases in Service Cloud; 라이브 공식 문서, Tier 2, 접속 2026-07-03. 보강 2026-07-12: Customize Support Settings / Create Support Processes / Close Cases / Use Case Feed in Salesforce Classic·Enable Case Feed Actions and Feed Items / What's a Case Team?·Create Case Team Roles·Predefine Case Teams / Create and Edit Case Comments / Case Contact Roles — help.salesforce.com)
official_doc: https://help.salesforce.com/s/articleView?id=service.cases_def.htm&type=5
created: 2026-07-03
aliases: [Cases, 케이스, Case, Case Management, 케이스 관리, 지원 요청]
---

# Cases (케이스)

> **Case**는 고객의 질문·피드백·이슈를 담는 Service Cloud 핵심 오브젝트. 서비스 담당자(rep)가 case로 고객과 상호작용하며, 여러 채널로 생성되고 규칙·큐·Omni-Channel로 라우팅된다.

---

## Case란 무엇인가

**Case**는 고객의 **질문(question)·피드백(feedback)·이슈(issue)** 를 담는 레코드다. 서비스 담당자(support rep)는 case를 사용해 고객과 상호작용하며 — 문의를 접수하고, 진행 상황을 추적하고, 해결까지 이끈다. Case는 Service Cloud에서 고객 지원 업무의 중심 단위다.

## 생성 채널

Case는 여러 채널을 통해 생성된다.

- **Email-to-Case** — 고객이 보낸 이메일이 자동으로 case로 전환
- **Web-to-Case** — 웹 폼 제출이 case로 접수
- **Chat** — 실시간 채팅 세션에서 case 생성
- **Messaging** — 메시징 채널(SMS 등)에서 case 생성
- **수동 생성** — rep가 콘솔에서 직접 case 생성

## 관리와 라우팅

Case는 생성 후 적절한 담당자에게 라우팅되고, 콘솔에서 처리되며, SLA로 추적된다.

- **라우팅:** Queue(큐), Assignment Rules / Escalation Rules, **Omni-Channel** 로 case를 담당자에게 배정
- **처리:** **Service Console** 에서 case를 작업
- **SLA 추적:** **Entitlements & Milestones** 로 서비스 수준 계약(SLA)을 추적

## Case Lifecycle

```
// 구조 예시 — Case Lifecycle(실제 원본 다이어그램 아님)
채널(Email/Web/Chat/Messaging/수동) → Case 생성
  Assignment Rules/Queue/Omni-Channel → 담당자 배정
  처리(Service Console + Knowledge + Macros)
  Escalation Rules(시간/기준) · Entitlements & Milestones(SLA)
  → 해결(Closed)
```

> 라이프사이클 실무 구성(상태·소유권·클로징/재오픈·Case Feed·Case Team·코멘트·연락처 역할)은 아래 소절에 담았다. Case 오브젝트의 전체 필드 레퍼런스는 [[Service Cloud Objects]]와 공식 Object Reference를, 더 깊은 세부 설정은 공식 문서(위 `official_doc`)를 참조한다.

> [!note] Setup 라벨 캐비엇 (2026-07-12 기준)
> 아래 Setup 경로·체크박스 라벨은 라이브 help.salesforce.com 기준이다. Salesforce는 릴리스마다 UI 라벨을 바꾸므로(예: Support Settings 항목 명칭·위치) 실제 org에서 명칭이 다를 수 있다. 개념·동작은 유지되나 정확한 라벨은 org에서 확인한다.

---

## 케이스 상태 (Status)

**Status**는 케이스의 라이프사이클 단계를 나타내는 표준 picklist 필드다.

**표준 Status 값** — 신규 org의 기본 picklist:

| 값 | 의미 |
|---|---|
| **New** | 접수된 신규 케이스 (아직 작업 시작 전) |
| **Working** | 담당자가 처리 중 |
| **Escalated** | 에스컬레이션됨 (Escalation Rule 또는 수동) |
| **Closed** | 해결·종료됨 (`IsClosed` = true) |

- **Escalated**는 [[Case Assignment & Escalation Rules (케이스 배정·에스컬레이션 규칙)]]의 Escalation Rule이 조건 충족 시 자동 설정하거나 담당자가 수동 설정한다.
- **Closed**는 케이스가 닫힐 때 부여되는 시스템 "closed" 상태 값. 여러 개의 closed 상태 값을 둘 수 있다(Support Process로 정의).

**상태 값 커스터마이징 — Support Process (지원 프로세스):**

Record Type별로 사용 가능한 Status 값의 부분집합을 정의한다. 케이스 유형(제품 지원 vs 일반 문의 등)마다 다른 상태 흐름을 강제할 수 있다.

```
// 구조 예시 — Setup 경로(실제 org 라벨은 다를 수 있음)
Setup → Quick Find "Support Processes" → Support Processes → New
  → 기존 Master picklist에서 이 프로세스가 쓸 Status 값 선택
  → Record Type에 Support Process 지정 → 그 Record Type 케이스는 지정된 Status 값만 노출
```

**상태 자동화:**

- **Email-to-Case 응답**으로 상태 갱신(예: 고객 회신 시 Working으로) — Flow/자동화로 구현.
- **Escalation Rules** — 시간·기준 충족 시 Escalated로 전환 + 알림/재배정.
- **Flow / Approval** — 조건 기반 상태 전환.

## 소유권 (Ownership)

**Case Owner**는 **사용자(User)** 또는 **큐(Queue)** 중 하나다.

- **사용자 소유** — 개별 담당자가 케이스를 소유·작업한다.
- **큐 소유** — [[Queues (큐)]]에 배정되어 큐 멤버가 집어(accept)갈 때까지 대기. Omni-Channel·Assignment Rule의 라우팅 대상.

**소유권 이전:**

- 케이스 상세에서 **Owner 필드 변경(Change Owner)** 으로 사용자↔큐 간 이전.
- Support Settings의 **"Notify Case Owners on ownership change"**(소유권 변경 시 소유자 알림)를 켜면 새 소유자에게 *"Case transferred to you"* 이메일 알림이 발송된다.

**Assignment Rule 연계 · Default Case Owner:**

- 케이스 생성 시 [[Case Assignment & Escalation Rules (케이스 배정·에스컬레이션 규칙)]]의 Assignment Rule이 소유자(사용자/큐)를 결정한다. (규칙 상세는 해당 노트에 위임)
- **Default Case Owner**(Support Settings) — 어떤 Assignment Rule에도 매칭되지 않은 케이스가 배정될 **폴백 사용자 또는 큐**. 기본 소유자로 배정될 때 시스템 알림을 보낼 수 있다.

## 클로징 / 재오픈 (Closing / Reopening)

**케이스 닫기(수동) 방법:**

- 케이스 상세 페이지의 **Close Case** 버튼
- Cases 관련 목록의 **Cls** 링크
- 편집 중 **Save & Close**
- Case Feed 퍼블리셔의 **Change Status → Closed**(또는 Close Case 액션)
- 관리자가 허용하면(Support Settings), 편집 페이지에서 **Status를 Closed로 선택하고 저장**만으로 닫기 — 추가 단계 없이 종료

**대량 닫기:** **Manage Cases** 권한이 있으면 케이스 리스트뷰의 **Close** 버튼으로 여러 케이스를 한 번에 닫는다.

**닫기 시 알림·closed 상태:**

- Support Settings의 **Case Close 템플릿**으로 케이스 닫힐 때 연락처에 종료 알림 이메일을 보낼 수 있다.
- **여러 closed 상태 값** — Support Process에서 둘 이상의 closed 상태를 정의해 종료 사유를 구분할 수 있다.
- **"Show Closed Statuses in Case Status Field"**(Support Settings) — 켜면 편집 페이지의 Status picklist에 closed 상태 값이 노출되어, 별도 Close 흐름 없이 상태만 바꿔 닫을 수 있다.

**닫힌 케이스 편집 / 재오픈:**

- 닫힌 케이스도 **Edit 권한**이 있으면 편집 가능하며, Status를 open 값(New/Working 등)으로 되돌려 **재오픈**한다.
- 재오픈·편집 가능 여부는 별도 org 전역 토글이 아니라 **프로파일/권한(Edit)과 페이지 레이아웃**으로 통제된다.

> [!warning] Auto-Close 확인 필요
> 표준 케이스에는 "일정 시간 후 자동 종료"라는 **네이티브 스케줄 Auto-Close 설정이 없다.** 자동 종료는 보통 **Flow·Approval·Email-to-Case 규칙 등 자동화**로 구현한다. (Messaging/Chat 세션의 비활성 대화 자동 종료는 별개 기능.) 공식 문서에서 표준 케이스용 단일 Auto-Close 토글은 확인하지 못함 — 실무는 자동화 기반으로 이해할 것.

## Case Feed

**Case Feed**는 케이스를 **피드 중심(feed-first)** 으로 보는 화면이다. 담당자가 이메일 전송·포털 게시·통화 기록·상태 변경·케이스 노트 작성 같은 작업을 **한 페이지에서** 처리하고, 그 작업에 연동된 피드 아이템을 시간순으로 본다.

**퍼블리셔(Publisher) 액션** — 담당자가 케이스에서 쓰는 작업들:

- **Email** — 케이스 연락처에 이메일 전송
- **Case Note** — 케이스 노트 작성
- **Log a Call** — 통화 기록
- **Change Status** — 상태 변경(Current Status / Change to 필드 자동 포함)
- **Post / Portal** — 포털·Experience Cloud 사이트에 게시
- **Question** 등 추가 액션

**활성화:**

```
// 구조 예시 — Setup 경로(실제 org 라벨은 다를 수 있음)
Setup → Quick Find "Support Settings" → Support Settings → Edit
  → "Enable Case Feed Actions and Feed Items" 체크 → Save
```

- Winter '14 **이후** 생성된 org은 케이스 피드 트래킹과 Case Feed 액션·피드 아이템이 **자동 활성화**된다.
- Winter '14 **이전** org은 Case Feed 액션을 켜기 전에 **Case에 대한 피드 트래킹(feed tracking)** 을 먼저 활성화해야 한다.
- 활성화 후 **Page Layout Editor**로 퍼블리셔 액션을 구성한다(활성화 전에는 이 옵션이 보이지 않음).

## Case Team

**Case Team(케이스 팀)**은 하나의 케이스를 함께 처리하는 사람들의 그룹이다. 예: 지원 담당자 + 지원 매니저 + 제품 매니저.

**Case Team Role(역할)과 접근 수준:**

역할마다 케이스에 대한 **Case Access**(접근 수준)를 지정한다.

| 접근 수준 | 권한 |
|---|---|
| **Read/Write** | 케이스 조회·편집 + 관련 레코드·노트·첨부 추가 |
| **Read Only** | 케이스 조회 + 관련 레코드 추가 |
| **Private** | 케이스에 접근 불가 |

- 역할 생성: **Setup → Case Team Roles**. 각 역할에 위 접근 수준을 지정하고, 필요 시 **"Visible in Customer Portal"**(고객 포털에 표시)을 체크한다.

**미리 정의된 팀 (Predefined Case Team):**

자주 함께 일하는 사람들을 팀으로 미리 묶어 케이스에 빠르게 추가한다.

```
// 구조 예시 — Setup 경로(실제 org 라벨은 다를 수 있음)
Setup → Quick Find "Predefine Case Teams" → Predefined Case Teams → New
  → Team Name 입력
  → Team Members: User / Contact / Customer Portal User 선택 + Member Role 지정
  → Save
```

**케이스에 팀 추가:** 케이스의 **Case Team 관련 목록 → Add Team**에서 미리 정의된 팀을 선택(또는 멤버를 개별 추가하며 역할 지정).

- **연락처(Contact)** 를 케이스 팀에 추가할 수 있으나, 해당 연락처가 **고객 포털(Experience Cloud) 사용자로 활성화**되고 케이스 페이지 레이아웃에 배정된 경우에만 케이스에 접근한다.

## Case Comments (케이스 코멘트)

**Case Comment**는 케이스에 대한 메모·진행 기록이다. Case Comments 관련 목록 또는 Case Note 액션으로 추가한다.

- **Public vs Private:**
  - **Public** 코멘트는 포털/Self-Service 사용자(케이스 연락처)에게 보인다.
  - **Private** 코멘트는 내부 담당자에게만 보인다.
- 담당자는 public·private 코멘트를 **모두** 읽을 수 있다.
- **포털 사용자가 입력한 코멘트는 항상 Public** 이다(포털 사용자는 private로 지정할 수 없음).

## Case Contact Roles (케이스 연락처 역할)

**Contact Role**은 한 케이스에 **여러 연락처를 각자의 역할과 함께** 연결한다(예: 최종 사용자, 결정권자, 청구 담당).

- 페이지 레이아웃에 **Contact Roles 관련 목록**을 추가해 사용한다.
- 케이스 Contact Role에는 **Primary 옵션이 없다** — 케이스의 주 연락처는 항상 Case Detail의 **Contact Name** 에 표시된 연락처다.
- Lightning Experience에서 Contact Roles는 케이스·계약·상품기회에 사용 가능하다.

## 관련 노트
- [[Service Cloud 개요]] — Service Cloud 시리즈 허브
- [[Service Cloud Objects]] — Case 표준 오브젝트 레퍼런스
- [[Email-to-Case & Web-to-Case (이메일·웹 투 케이스)]] — case를 생성하는 채널
- [[Case Assignment & Escalation Rules (케이스 배정·에스컬레이션 규칙)]] — case 배정·에스컬레이션 규칙
- [[Queues (큐)]] — 큐 소유 케이스의 라우팅·수락
- [[Service Console (서비스 콘솔)]] — Case Feed·퍼블리셔로 케이스를 처리하는 작업 공간
- [[Entitlements & Milestones (엔타이틀먼트·마일스톤)]] — 케이스 SLA 추적
- [[Macros (매크로)]] — 케이스 반복 작업 자동화
