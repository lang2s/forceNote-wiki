---
tags: [admin, automation, process-automation-settings, flow, workflow-rules, default-workflow-user, error-email]
source: help.salesforce.com — "Identify Your Salesforce Org's Default Workflow User" (https://help.salesforce.com/s/articleView?id=platform.workflow_defaultuser.htm&type=5) · "Select Flow and Process Error Email Recipients" (https://help.salesforce.com/s/articleView?id=platform.flow_troubleshoot_error_email.htm&type=5) · 라이브 공식 문서, Tier 2, 접속 2026-07-12
created: 2026-07-12
aliases: [Process Automation Settings, 프로세스 자동화 설정, Default Workflow User, 기본 워크플로 사용자, Send Process or Flow Email to, Flow Error Email Recipients, Flow 오류 이메일 수신자, Let users pause flows, Let users resume shared flow interviews, enhanced Flows page, 자동화 설정]
---

# Process Automation Settings (프로세스 자동화 설정)

> Setup 한 페이지에서 org 전체의 Flow·Process·Workflow 자동화 동작을 제어하는 **어드민 진입점** — 기본 워크플로 사용자, Flow/Process 오류 이메일 수신자, 인터뷰 일시정지·공유 재개, enhanced Flows 페이지 뷰 등. 위치: **Setup → Quick Find `Automation` → Process Automation Settings**.

---

## 진입점 · 필요 권한

```text
// 구조 예시 — Setup 내비게이션 경로 (실제 UI 라벨)
Setup
 └ Quick Find: "Automation"  또는  "Process Automation Settings"
    └ Process Automation Settings   ← 이 한 페이지에 아래 설정들이 모여 있다
```

| 작업 | 필요 권한 |
|---|---|
| process automation 설정 편집 | **Customize Application** |
| flow 목록 뷰 생성·수정·삭제 | **Manage Flow** |

이 페이지의 설정 조각들은 위키 곳곳(특히 [[Flow 디버깅과 모니터링 - 오류 이메일·인터뷰]])에 흩어져 있다. 이 노트는 그 조각들을 **어드민 관점의 단일 진입점**으로 모은 것이다.

---

## 1. Default Workflow User (기본 워크플로 사용자)

> workflow rule을 트리거한 사용자가 **비활성(inactive)** 일 때 Salesforce가 그 rule과 함께 표시할 기본 사용자.

**필수 조건:** org가 workflow rule에서 **time-dependent action(시간 종속 액션)** 을 사용하면 반드시 기본 워크플로 사용자를 지정해야 한다.

**어디에 표시되나 (트리거 사용자가 비활성일 때):**

| 액션 결과물 | 기본 워크플로 사용자명이 표시되는 필드 |
|---|---|
| Task(태스크) | **Created By** |
| Email(이메일) | **Sending User** |
| Field Update(필드 업데이트) | **Last Modified By** |
| Outbound Message(아웃바운드 메시지) | **표시되지 않음** (예외) |

**추가 동작:**
- 대기 중(pending) 액션에 문제가 생기면 **기본 워크플로 사용자에게 이메일 알림**이 발송된다.
- workflow 이메일 알림이 특정 한도에 근접하거나 초과하면 Salesforce가 **경고 이메일**을 보낸다 — 수신자는 기본 워크플로 사용자, **기본 워크플로 사용자가 설정돼 있지 않으면 활성 Salesforce admin**.

**설정 절차:**
1. Setup → Quick Find `Process Automation Settings` → **Process Automation Settings**.
2. **Default Workflow User** 에서 사용자 선택.
3. 저장.

**에디션:** Lightning Experience · Salesforce Classic / Enterprise · Performance · Unlimited · Developer.

> [!note] Workflow Rules 지원 종료
> Workflow Rules에 대한 지원·업데이트는 **2025년 12월 31일부로 종료**됐다 (버그 수정 없음). 기존 rule은 계속 실행·활성/비활성/편집 가능하나, 신규 자동화는 Flow Builder로 만들고 기존 rule은 **Migrate to Flow** 도구로 이전하도록 권장한다. → [[Workflow Rules & Migrate to Flow (워크플로 규칙·플로우 이전)]].
> 참고로 schedule-triggered flow의 실행 사용자(running user) 개념은 기본 워크플로 사용자와 별개의 flow 설정이다 — [[Flow 종류와 변수]] 참조.

---

## 2. Flow / Process 오류 이메일 수신자 (Send Process or Flow Email to)

> process 또는 flow 인터뷰가 실패하면, 기본적으로 **그 process/flow를 마지막으로 수정한 admin** 에게 상세 오류 이메일이 발송된다. 다만 그 admin이 대응 적임자가 아닐 수 있어, 수신자를 **Apex exception email 수신자**로 바꿀 수 있다.

**설정 절차:**
1. Setup → Quick Find `Automation` → **Process Automation Settings**.
2. **Send Process or Flow Email to** 에서 수신자 선택:
   - **User Who Last Modified the Process or Flow** — 오류가 난 flow를 **마지막으로 수정한 사용자**에게 발송.
   - **Apex Exception Email Recipients** — Setup의 **Apex Exception Email** 페이지에 등록된 주소들로 발송.
3. 저장.

**주의:** process·flow 오류 이메일에는 **process/flow가 다룬 데이터(사용자 입력 데이터 포함)** 가 들어간다.

**필요 권한:** 설정 편집 = Customize Application · flow 목록 뷰 관리 = Manage Flow.

> [!caution] Setup 라벨 캐비엇 (2026-07-12)
> 현재 공식 help 문서 본문·UI의 설정 라벨은 **"Send Process or Flow Email to"** 이다. 일부 자료·구버전에서는 같은 설정을 **"Send Process or Flow Error Email to"** 로 지칭한다 — 동일 설정의 표기 차이다. Setup 라벨은 릴리스에 따라 바뀔 수 있으니 실제 org의 Process Automation Settings 페이지 문구를 우선한다.

오류 이메일의 본문 구성·저장되는/저장되지 않는 인터뷰 타입·재시도 정책 등 **운영 상세**는 [[Flow 디버깅과 모니터링 - 오류 이메일·인터뷰]]에 전수돼 있다.

---

## 3. 기타 자동화 설정 (같은 페이지)

Process Automation Settings 페이지의 나머지 org 수준 스위치들. 상세 절차·공유 모델은 [[Flow 디버깅과 모니터링 - 오류 이메일·인터뷰]] 참조.

| 설정 (라벨) | 효과 |
|---|---|
| **Let users pause flows** | 활성화하면 Pause가 켜진 모든 화면에 Pause 버튼이 자동 표시 — 사용자가 screen flow 인터뷰를 일시정지 후 나중에 재개 가능. |
| **Let users resume shared flow interviews** | 기본은 Run Flows 권한/Flow User 라이선스 보유자가 edit 접근 있는 어떤 인터뷰든 재개 가능. **해제 시** 인터뷰 소유자 본인 또는 Manage Flow 권한 + 해당 인터뷰 view 접근이 있는 관리자만 재개 가능. |
| **enhanced Flows page 뷰** (In Lightning Experience, use the enhanced Flows page and separate Paused and Scheduled Automations page) | Setup의 Flows 페이지에 표준 flow까지 나열하고 패키지 정보를 표시하며, 일시정지 인터뷰/예약 액션을 **별도 페이지**로 분리. Classic에서 바꿔도 효과는 Lightning Experience 뷰에만 적용. |
| **Enable the Automation Lightning App** | 볼 권한이 있는 사용자에게 flow·오케스트레이션 모니터링용 Automation 앱을 노출. |
| **Require the Manage Flow permission to view all Automation Home charts** | 선택 시 View Setup and Configuration만 있는 사용자는 Automation Home 차트 중 Total Started Automations by Process Type 차트만 조회. |

---

## 관련 노트
- [[Flow 디버깅과 모니터링 - 오류 이메일·인터뷰]] — 오류 이메일 본문·인터뷰 일시정지/재개·모니터링 뷰의 운영 전수 (이 노트의 설정들이 실제로 동작하는 상세)
- [[Workflow Rules & Migrate to Flow (워크플로 규칙·플로우 이전)]] — 기본 워크플로 사용자가 쓰이는 레거시 workflow rule과 Flow 이전
- [[Flow 종류와 변수]] — schedule-triggered flow 등 flow 종류별 실행 컨텍스트
