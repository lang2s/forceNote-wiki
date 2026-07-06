---
tags: [service-cloud, email-to-case, web-to-case, case-channels, case-creation]
source: help.salesforce.com (Salesforce Help — Service; Set Up Email-to-Case / Web-to-Case; 라이브 공식 문서, Tier 2, 접속 2026-07-03); Web-to-Case Guidelines and Limits (service.customizesupport_web_to_case_notes, Tier 2); Add Routing Addresses for Email-to-Case (service.customizesupport_configuring_routing_addresses, Tier 2); Email-to-Case FAQ (service.faq_cases_email, Tier 2); Email-to-Case and On-Demand Email-to-Case Overview (customizesupport_email, Tier 2 — web.archive.org 보존 공식 문서 원문 대조, 확인 2026-07-06); Salesforce Release Notes — Spring '24·Winter '25 Release Updates (Disable Ref ID and Transition to New Email Threading Behavior, Tier 2)
official_doc: https://help.salesforce.com/s/articleView?id=service.setting_up_web-to-case.htm&type=5
created: 2026-07-03
aliases: [Email-to-Case, Web-to-Case, 이메일 투 케이스, 웹 투 케이스, 케이스 자동 생성, On-Demand Email-to-Case, 온디맨드 이메일 투 케이스, 이메일 스레딩, Email Threading, Ref ID, Thread_Token]
---

# Email-to-Case & Web-to-Case (이메일·웹 투 케이스)

> 인바운드 채널에서 case를 자동 생성하는 기능. **Email-to-Case**는 지원 이메일을, **Web-to-Case**는 웹사이트 폼 제출을 case로 변환한다.

---

## 개요

Email-to-Case와 Web-to-Case는 고객의 인바운드 요청을 **자동으로 새 case로 변환**하는 Service Cloud 채널이다. 두 기능 모두 고객이 별도 로그인 없이 지원 요청을 보낼 수 있게 하고, 접수된 요청을 Salesforce case 레코드로 만들어 지원 팀이 추적·처리하도록 한다.

```
// 구조 예시 — Email/Web-to-Case(실제 원본 다이어그램 아님)
고객 이메일  → Email-to-Case → Case  (라우팅: Omni-Channel flow 권장)
웹사이트 폼  → Web-to-Case  → Case  (활성화 → 폼 생성 → 사이트 삽입)
```

---

## Email-to-Case

고객이 보낸 **지원 이메일을 case로 자동 생성**한다.

### 설정
- Setup → Quick Find에 **"Email-to-Case"** 입력 → **Email-to-Case** 선택.

#### 필수 설정 단계 (누락 시 케이스 미생성)
1. **Email-to-Case 활성화** — Email-to-Case Settings에서 **Enable Email-to-Case** 체크박스와 **On-Demand Service** 체크박스를 활성화한다.
2. **Routing Address(라우팅 주소) 추가 + 검증** — 라우팅 주소를 추가하면 Salesforce가 해당 주소로 **검증(verification) 이메일**을 보낸다. 그 주소를 **verify(검증)하기 전에는 케이스가 생성되지 않는다.**

> ⚠️ **가장 흔한 블로커:** "Email-to-Case가 케이스를 안 만든다"의 대표 원인은 **라우팅 주소 검증(verification) 누락**이다. 검증 이메일 링크로 주소를 활성화해야 인바운드 이메일이 case로 변환된다.

#### On-Demand Service 하드 한도
- **25MB 초과** 이메일은 거부된다.
- 이메일 **본문·헤더는 32,000자**를 초과하면 절삭된다.

### On-Demand vs 표준 Email-to-Case (Agent 설치형) — 무엇을 쓸까

Email-to-Case는 두 가지 방식이 있다. **표준 Email-to-Case**는 **Email-to-Case agent**를 다운로드해 사내(방화벽 안) 로컬 머신에 설치해야 Salesforce가 지원 이메일을 처리할 수 있고, **On-Demand Email-to-Case**는 agent 설치 없이 **Apex email services**로 이메일을 케이스로 변환한다.

| 항목 | 표준 Email-to-Case (Agent 설치형) | On-Demand Email-to-Case |
|---|---|---|
| **설치 방식** | Email-to-Case agent를 다운로드해 방화벽 안 로컬 머신에 설치 필수 | 설치물 없음 — Setup에서 **On-Demand Service** 체크박스 활성화만 (Apex email services 기반) |
| **트래픽 경로** | 모든 이메일 트래픽을 **사내 네트워크 방화벽 안에 유지** | 이메일 트래픽이 방화벽 **밖**(Salesforce 경유)으로 나감 |
| **이메일 크기 한도** | **25MB 초과 이메일도 수용** 가능 | **25MB 초과 거부** + 본문·헤더 32,000자 절삭 (위 하드 한도) |
| **유지보수** | 로컬 설치물이라 설치·운영·업그레이드 부담이 관리자 몫 | Salesforce가 처리 — 별도 유지보수 없음 |

**선택 기준** (공식 문서 원문 기준):
- 이메일 트래픽을 **방화벽 안에 유지해야 하거나**(보안·규제), 고객으로부터 **25MB보다 큰 이메일을 받아야 하면** → **표준(Agent 설치형)**.
- 트래픽의 방화벽 내 유지가 중요하지 않고 **25MB 초과 첨부를 받을 필요가 없으면** → **On-Demand** (설치·유지보수가 없어 일반적인 기본 선택).

> 원문 근거: "Email-to-Case requires downloading the Email-to-Case agent. This lets you keep all email traffic within your network's firewall and accept emails larger than 25 MB. … On-Demand Email-to-Case uses Apex email services to convert email to cases, without requiring you to download and install an agent behind your network's firewall." — Email-to-Case and On-Demand Email-to-Case Overview

### 라우팅 권장
- Email-to-Case를 사용할 때는 record-triggered flow보다 **Omni-Channel flow**로 case를 목적지에 라우팅하는 것을 권장한다.

### 이메일 스레딩 — 답장이 기존 케이스에 붙는 원리

고객이 지원 이메일에 답장하면 Salesforce는 그 답장을 **기존 케이스에 매칭(스레딩)**하려 시도하고, 매칭에 실패하면 **새 케이스를 생성**한다. 매칭 방식은 두 세대가 있다.

#### Lightning(보안 토큰 기반) 스레딩 — 현행 방식

아웃바운드 이메일에 **secure token**을 삽입하고, 인바운드 답장을 다음 순서로 매칭한다:

1. **제목/본문의 secure token** 매칭
2. (토큰이 없으면) **이메일 헤더 metadata** 매칭
3. 둘 다 실패 → **새 케이스 생성**

#### 레거시 Ref ID 방식 → 전환 Release Update

과거에는 아웃바운드 이메일 제목/본문에 **Ref ID** 식별자를 넣어 매칭했다. Release Update **"Disable Ref ID and Transition to New Email Threading Behavior"**(Winter '21 first available)가 이를 토큰 기반 Lightning 스레딩으로 전환한다 — 활성화하면 새 아웃바운드 이메일에 Ref ID가 더 이상 포함되지 않는다. 강제 시점은 Spring '24 릴리즈 노트에서 Spring '25 강제로 안내됐다가, Winter '25 릴리즈 노트 기준 **강제 시점 미정**으로 연기됐다. 상세는 [[Spring '24/Release Updates]] · [[Winter '25/Release Updates]] 참조.

전환 시 교체해야 하는 merge field·메서드 (릴리즈 노트 명시):

```apex
// 구조 예시 — 실제 동작 코드 아님

// 1) 이메일 템플릿의 merge field 교체
//    Case.Thread_Id  →  Case.Thread_Token

// 2) custom Apex 코드의 메서드 교체
//    Cases.getCaseIdFromEmailThreadId(...)
//      ↓ 아래 중 하나(또는 조합)로 교체
//    Cases.getCaseIdFromEmailHeaders(...)
//    EmailMessages.getRecordIdFromEmail(...)
```

> ⚠️ **되돌리기 경고:** Lightning 스레딩 활성화 후 Ref ID 방식으로 되돌리면, 그 사이에 생성된 케이스에는 답장이 스레딩되지 않아 **새 케이스가 중복 생성**될 수 있다.

#### 답장이 새 케이스로 생성될 때 — 원인 체크리스트

- **답장에서 토큰이 제거됨** — 고객이 제목을 수정하고 인용(quoted) 본문까지 삭제해 secure token이 사라진 경우. 헤더 metadata 매칭까지 실패하면 새 케이스가 된다.
- **헤더 metadata 유실** — 답장이 아니라 새 메일로 작성했거나, 포워딩 등으로 스레드 헤더가 끊긴 경우.
- **스레딩 방식 전환 직후** — Ref ID ↔ 토큰 방식을 전환하면 전환 이전 방식으로 만들어진 케이스와 매칭이 실패할 수 있다 (위 되돌리기 경고).
- **아웃바운드 템플릿에 merge field 누락** — 템플릿이 `Case.Thread_Token`(구 `Case.Thread_Id`)을 포함하지 않으면 애초에 토큰이 삽입되지 않는다.

---

## Web-to-Case

회사 웹사이트에서 **고객 지원 요청을 직접 수집해 새 case를 자동 생성**한다.

### 설정 단계
1. 기능 **활성화**
2. **웹 폼 생성·커스터마이즈**
3. 폼을 **웹사이트에 추가**

경로: Setup → Quick Find에 **"Web-to-Case"** 입력 → **Web-to-Case** → 필드 작성 → 저장.

> ⚠️ **전제조건:** 폼 설정 시 **Default Case Owner(기본 케이스 소유자)** 지정이 필수다. 유입된 요청이 할당될 소유자가 지정돼야 case가 정상 생성된다.

### 한도·주의
- **하루 최대 5,000건**의 Web-to-Case 요청만 생성된다.
- 5,000건을 **초과한 요청은 pending(보류) 상태**로 대기했다가 한도가 리셋되면 처리된다.
- **24시간 넘게** 초과가 지속되면 초과분은 **폐기**되거나, 지정한 **Default Email 계정으로 전송**된다.

> ⚠️ 대량 유입(예: 마케팅 캠페인·장애 상황) 시 이 한도로 인해 **케이스 유실**이 발생할 수 있는 대표적 하드 한도다. 초과 대비 Default Email 계정을 지정해 두는 것이 안전하다.

---

## 관련 노트
- [[Service Cloud 개요]] — Service Cloud 시리즈 허브
- [[Cases (케이스)]] — 생성 결과 레코드
- [[Spring '24/Release Updates]] — Disable Ref ID 스레딩 전환 RU (merge field·메서드 교체 상세)
- [[Winter '25/Release Updates]] — 스레딩 매칭 순서(secure token → 헤더 metadata) + 강제 시점 미정 기록
