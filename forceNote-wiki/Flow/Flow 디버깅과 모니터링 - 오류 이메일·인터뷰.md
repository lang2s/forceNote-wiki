---
tags: [flow, debugging, monitoring, flow-interview, error-email, troubleshooting, automation-app, admin]
source: extend_click_automate.pdf (Automate Your Business Processes, Spring '26)
created: 2026-07-10
aliases: [Flow Debugging, Flow Monitoring, 플로우 디버깅, 플로우 모니터링, Flow 오류 이메일, Flow error email, Paused Flow Interviews, 일시정지된 플로우 인터뷰, Flow 인터뷰 일시정지, Rollback 모드 디버그, Run flow as another user, Automation Lightning App, 자동화 라이트닝 앱, Troubleshoot Flow Errors, Flow 장애 진단]
---

# Flow 디버깅과 모니터링 — 오류 이메일·인터뷰

> Flow 인터뷰(일시정지·재개)와 운영 모니터링(Automation Lightning App·Setup 뷰·리포트), 그리고 장애 진단(오류 이메일·Flow Builder 디버그 옵션·디버그 로그)의 운영 절차 전수.

---

> [!note] 역할 분리 — 설계는 [[Flow 에러 처리]], 운영·진단은 이 노트
> fault connector 경로 설계·오류 화면·Chatter 게시·커스텀 에러 메시지 등 **flow 안에서 오류를 어떻게 처리할지(설계)**는 [[Flow 에러 처리]] 소관이다. 이 노트는 **이미 배포된 flow가 실패하거나 멈췄을 때 밖에서 무엇을 보고 어떻게 진단하는가(운영)**를 다룬다.

## Flow Interview — 실행 인스턴스

**Flow interview는 flow의 실행 중인 단일 인스턴스**다. 레코드와 오브젝트의 관계처럼, 링크·버튼·탭으로 flow를 실행하면 그 flow의 인스턴스 하나가 도는 것이다. (인쇄 p.225)

실행 시 주의(전수):
- **브라우저의 뒤로/앞으로 버튼으로 flow를 이동하지 않는다** — flow와 Salesforce 간 데이터 불일치가 생길 수 있다.
- **한 flow는 버전을 최대 50개**까지 가질 수 있다. 실행 시 보이는 것은 활성(active) 버전이지만, 관리자에게 더 최신 버전이 있을 수 있다.

> Apex 코드에서 `Flow.Interview`로 인터뷰를 직접 시작·재개하는 API는 [[Flow Interview API]] 참조. FlowInterview·FlowInterviewLog 등 런타임 sObject 목록은 [[Platform Admin Objects]] 참조.

## 인터뷰 일시정지·재개·삭제 (사용자 절차)

인쇄 p.225–227 전수:

### Pause (일시정지)
관리자가 해당 flow에 일시정지를 구성한 경우에만 가능(아래 "조직 준비" 참조). 통화가 끊기거나 고객이 계좌번호를 못 찾을 때 유용하다.
1. 열려 있는 flow 인터뷰에서 **Pause** 클릭.
2. 일시정지 사유 입력(선택 사항, **최대 255자**) — 같은 flow의 인터뷰를 여럿 정지했을 때 구분에 도움.
3. **OK** 클릭. 재개하거나 삭제할 때까지 인터뷰가 저장된다. **정지 전에 입력한 유효한 값은 인터뷰와 함께 저장**되어 재개 시 다시 입력할 필요가 없다.

필요 권한: **Run Flows** 또는 사용자 상세 페이지의 **Flow User** 필드 활성화 (Pause·Resume·Delete 공통).

### Resume (재개)
1. 일시정지된 인터뷰 목록이 있는 곳으로 이동. 관리자 구성에 따라 다음 중 하나:
   - Experience Builder 사이트 페이지의 **"Paused Flows"**
   - 풀 Salesforce 사이트 Home 탭의 **"Paused Flow Interviews"**
   - Salesforce 모바일 앱 내비게이션 메뉴의 **"Paused Flows"**
2. 해당 인터뷰를 재개한다.

주의(전수):
- **일시정지 후 flow가 업데이트돼도, 재개된 인터뷰는 업데이트된 flow가 아니라 일시정지 당시의 활성 버전을 사용**한다.
- 정지 전 입력값 중 **유효하지 않은 값은 저장되지 않는다** (예: 숫자 전용 필드에 "Acme, Inc." 입력 후 정지 → 재개 시 그 필드는 빈칸).
- **재개하는 순간 그 인터뷰는 Paused Flow Interviews 목록에서 제거**된다. 마음이 바뀌면 다시 **Pause**를 눌러야 하며, **일시정지하지 않고 인터뷰를 닫으면 나중에 재개할 수 없다.**

### Delete (삭제)
재개할 계획이 없는 인터뷰는 삭제해 pending 목록을 정리한다.
1. 일시정지된 인터뷰 목록으로 이동 — Salesforce Classic Home 탭의 "Paused Flow Interviews" 또는 모바일 앱의 "Paused Flows".
2. 불필요한 인터뷰 삭제.

관리자는 Setup에서도 삭제할 수 있다: **Setup → Flows → 각 인터뷰의 Del(또는 메뉴 → Delete)**. flow 버전을 업데이트·삭제하려면 장기 실행/일시정지 인터뷰를 먼저 삭제해야 한다. (인쇄 p.216)

## 조직 준비 — Pause 활성화·공유·찾기 쉽게 만들기

인쇄 p.208–216 ("Prepare Your Org for Paused Flow Interviews"):

### Let Users Pause Flows
1. Setup → Quick Find에 `Automation` → **Process Automation Settings**.
2. **Let users pause flows** 선택 → Save.
3. 활성화하면 **Pause가 켜진 모든 화면에 Pause 버튼이 자동 표시**된다.
(필요 권한: 설정 편집 = Customize Application, flow 목록 뷰 관리 = Manage Flow)

### 레코드 컨텍스트 연결 — $Flow.CurrentRecord
flow 시작부에 Assignment 요소로 **`$Flow.CurrentRecord` = 레코드 ID 변수(단일 ID)**를 설정하면, 일시정지되거나 Wait 요소가 실행될 때 **FlowRecordRelation 오브젝트를 통해 인터뷰가 그 레코드에 연결**된다. 예: Change Address flow에서 `$Flow.CurrentRecord`를 `{!recordId}`로 설정.

### 일시정지 인터뷰를 찾기 쉽게 (표시 위치 4곳 전수)
- **Lightning Experience** — Home 페이지에 **Paused Flow Interviews 컴포넌트** 추가 (Lightning App Builder의 Home 페이지 전용). 사용자가 read 접근 가능한 인터뷰 표시.
- **Experience Builder 사이트** — 사이트 페이지에 **Paused Flows 컴포넌트** 추가 (로그인·오류 페이지 등 제외 대부분 페이지 가능).
- **Salesforce 모바일 앱** — Lightning app 내비게이션 항목에 **Paused Flows** 추가.
- **Salesforce Classic** — 홈 페이지 레이아웃에 **Paused Flow Interviews 관련 목록** 추가 (본인이 정지한 인터뷰만 표시).

### 접근 제어 (Flow Interview 공유 모델)
- 기본적으로 사용자는 **edit 접근이 있는 한** 일시정지 인터뷰를 재개할 수 있다. 제어하려면 **Flow Interview 오브젝트의 공유 모델**(org-wide default + 공유 규칙)을 구성한다.
- **인터뷰의 기본 공유 모델은 Private** — 역할 계층을 쓰는 org에서는 계층 하위 사용자가 소유하거나 edit 접근을 가진 인터뷰를 상위 사용자가 재개할 수 있다.
- **CEO 역할 사용자는 org의 모든 flow 인터뷰에 read/write 접근**을 가진다 (인터뷰 소유자가 계층 밖이어도).
- 예: 모든 상담원이 아무 인터뷰나 재개하게 하려면 — Agents 공개 그룹 생성 → Flow Interview OWD는 Private 유지 → 공유 규칙로 "내부 사용자가 소유한 인터뷰"에 대해 Agents 그룹에 read/write 부여.
- **Restrict Who Can Resume Shared Flow Interviews**: 기본적으로 Run Flows 권한 또는 Flow User 라이선스 보유자는 edit 접근이 있는 어떤 인터뷰든 재개 가능. Setup → Process Automation Settings에서 **Let users resume shared flow interviews를 해제**하면, **인터뷰 소유자 본인** 또는 **Manage Flow 권한 + 해당 인터뷰 view 접근이 있는 관리자**만 재개할 수 있다. flow가 프로필/권한 집합으로 접근을 제한하도록 구성됐다면, 재개 사용자는 그 flow 접근 권한도 있어야 한다.

## FlowInterview 조회 — SOQL·Apex

레코드 페이지에서 그 레코드에 연결된 일시정지 인터뷰를 조회·재개·삭제하는 커스텀 Aura 컴포넌트 예제의 **Apex 컨트롤러** (인쇄 p.212 원문 발췌 — FlowRecordRelation → FlowInterview SOQL):

```java
public class interviewsByRecordController {
    @AuraEnabled
    public static List<FlowRecordRelation> getInterviews(Id recordId) {
        return [ SELECT
            ParentId, Parent.InterviewLabel, Parent.PauseLabel,
            Parent.CurrentElement, Parent.CreatedDate, Parent.Owner.Name
            FROM FlowRecordRelation
            WHERE RelatedRecordId = :recordId ];
    }
    @AuraEnabled
    public static FlowInterview deleteInterview(Id interviewId) {
        FlowInterview interview = [Select Id from FlowInterview Where Id = :interviewId];
        delete interview;
        return interview;
    }
}
```

- 조회 경로: **FlowRecordRelation**(`RelatedRecordId` = 레코드)에서 `Parent`(= FlowInterview)의 `InterviewLabel`·`PauseLabel`·`CurrentElement`·`CreatedDate`·`Owner.Name`을 읽는다. 재개는 Aura `lightning:flow`의 `resumeFlow(interviewId)`.
- PDF의 전체 예제는 Aura 컴포넌트(c:interviewsByRecord)·JS 컨트롤러·헬퍼까지 포함한다(인쇄 p.210–214). FlowInterview 오브젝트 자체의 위치는 [[Platform Admin Objects]] 참조.

**추적 팁 (인쇄 p.282):** 인터뷰가 Salesforce 레코드로 저장될 때 추가 정보를 남기려면 **인터뷰의 GUID를 참조하는 커스텀 오브젝트**를 만든다. 인터뷰는 **일시정지되어 레코드로 저장될 때에만 18자 Salesforce ID**를 부여받고, GUID는 진행 중이든 정지 중이든 항상 있다.

## 모니터링 — Setup 뷰·Automation Lightning App·리포트

### 뷰 방식 선택 (Control Your Views)
Setup → Quick Find `Automation Settings` → **Process Automation Settings** → **In Lightning Experience, use the enhanced Flows page and separate Paused and Scheduled Automations page** 선택/해제. Classic에서도 변경할 수 있지만 **효과는 Lightning Experience의 페이지·목록 뷰에만** 적용된다. (인쇄 p.228)

| 항목 | 선택 시 | 해제 시 |
|---|---|---|
| Setup의 Flows 페이지 | 표준(standard) + 커스텀 flow 모두 나열 | 커스텀 flow만 나열 |
| flow 목록 | flow가 설치된 패키지 표시 가능 | 패키지 정보 미표시 |
| 일시정지 인터뷰·프로세스 예약 액션 목록 | Setup의 **별도 Paused Flow Interviews 페이지**에 표시 | Flows 페이지의 **관련 목록**으로 표시 |

(권한: 설정 편집 = Customize Application, flow 목록 뷰 생성·수정·삭제 = Manage Flow)

### Automation Lightning App
기존 flow·오케스트레이션을 모니터링·관리하는 앱. Setup의 **Enable the Automation Lightning App** 설정으로 활성화하면 볼 권한이 있는 누구에게나 표시된다. Lightning Experience 전용, **Enterprise·Performance·Unlimited·Developer** 에디션. (인쇄 p.7–8)

| 탭 | 내용 |
|---|---|
| **Home** | 최근 수정한 flow 목록 뷰 + 오류로 구성된(configured with errors) flow 목록 뷰(segment-/form-triggered). label·description 키워드 검색, Trailhead·커뮤니티 링크. Action 메뉴로 활성/최신 버전 열기·소유자 변경·삭제 |
| **Flows** | 표준·커스텀 목록 뷰. 타입·진행 상태·최종 수정일·수정자·연결 레코드 필드로 필터/정렬. 권한이 있으면 **New**로 Flow Builder에서 바로 생성 |
| **Orchestrations** | 표준·커스텀 오케스트레이션 목록 뷰. 트리거 타입·상태·최종 수정일 필터/정렬, 선택한 오케스트레이션의 관련 실행(run) 보기·관리 |
| **Connections** | 연결 목록 뷰 — Salesforce admin이면 org의 모든 연결 표시 |

### On-Canvas Insights와 Flow 리포트
**Data Cloud-triggered·segment-triggered·form-triggered flow**는 요소 실행 데이터가 캔버스에 직접 표시된다. **Enterprise·Unlimited + Marketing Cloud Advanced Edition** 전용. **Winter '25 릴리스 이전에 완료된 flow 실행에는 지표가 없고**, Winter '25 이전에 만든 form-triggered flow에는 on-canvas insights가 없다. (인쇄 p.229–230)

- 활성·과거 실행 flow는 **read-only 모드**로 열리며 요소별 분석을 표시한다.
- 요소 클릭 → **View Element** → **Analytics 탭**: 실행 횟수·성공 횟수·오류 횟수·평균 소요 시간.
- Analytics 탭의 **More info in Reports**로 상세 리포트 — org에 **Flow Reports Analytics Package**(Marketing Cloud Setup에서 설치) 필요.
- read-only 모드 해제: **Edit as New Version** 또는 **Save As New Flow**.
- **Send Email 액션의 "성공"은 요소 실행 성공만 의미** — 메일 발송/전달 보장이 아니다. 상세는 Message Engagement DMO로 Data Cloud 리포트를 만들어 flow element ID로 필터.
- 리포트 고려사항: Flow Element Analytics 리포트를 수정하면 **같은 타입의 모든 리포트에 반영**된다(Element ID 필터를 첫 번째 필터로 유지 권장). 리포트는 개인 정보를 포함한 raw 실행 데이터를 보여준다.

### Automation Home (Beta)
자동화 유형별 사용 현황·총 오류·총 시작 자동화 수 차트, screen flow 완료 소요 시간 등을 보여준다. Setup → Quick Find `Automation` → **Automation Home (Beta)**. 보기 권한: **View Setup and Configuration**. (인쇄 p.230 — Beta 고지: 평가 목적 전용, 미지원, 언제든 중단 가능)

**차트 접근 제한 (Require Access to Automation Home Charts):** 기본은 View Setup and Configuration 보유자가 모든 차트를 본다. Setup → Process Automation Settings → **Require the Manage Flow permission to view all Automation Home charts** 선택 시, View Setup and Configuration만 있는 사용자는 **Total Started Automations by Process Type 차트만** 볼 수 있다. (인쇄 p.231)

### Screen Flow 리포트 (Sample Flow Report - Screen Flow)
Reports 탭의 **Sample Flow Report: Screen Flow**로 screen flow의 인터뷰 실행 횟수·화면 소요 시간·인터뷰 상태를 본다. Salesforce가 커스텀 리포트 타입 한도에 도달하지 않은 org에 **Screen Flows 커스텀 리포트 타입**과 리포트를 추가해 준다. (인쇄 p.231–232)

**한도 (전수):**
- Flow Interview Log Entries 오브젝트는 **최근 31일 내 활성이었던 screen flow마다 로그 레코드**를 생성한다.
- Flow Interview Log Entries 한도는 **직전 31일 기준 월 700만(7 million) 로그 레코드**. 한도 도달 시 신규 flow 지표 로깅이 중단되지만, 도달 시점에 진행 중이던 인터뷰는 계속 추적된다. **31일보다 오래된 로그는 자동 삭제**(한도 미도달 org 포함).

**제약 (전수):**
- 리포트는 기본으로 모든 사용자에게 보이지만, **각자 자신이 running user인 flow 정보만** 본다. 타인의 flow 로그는 **View All Data** 권한자만. 타인 flow 열람을 주려면 **Flow Interview Logs 오브젝트에 공유 설정으로 접근 부여**.
- 같은 API명의 커스텀 리포트 타입 또는 같은 리포트 타입 이름이 이미 있는 org는 Screen Flows 리포트 타입을 못 받는다 — Flow Interview Logs·Flow Interview Log Entries 오브젝트로 직접 커스텀 리포트 타입을 만든다.

**사용 절차:** App Launcher → `report` 검색 → Reports → **Public Folders** → Sample Flow Report: Screen Flow. 기본 정렬은 flow API명·인터뷰 상태. 총/평균 화면 소요 시간과 기간 내 로그 수 포함. **기본 날짜 범위는 최근 7일, 최대 최근 31일.** 접근을 제한하려면 리포트를 다른 폴더로 이동. (인쇄 p.232–233)

## 오류 이메일 (Troubleshoot Flow Errors)

flow 인터뷰가 실패하면 Salesforce가 **flow를 마지막으로 수정한 관리자 또는 Apex exception email 수신자**에게 이메일을 보낸다. 이메일에는 **오류 메시지, 인터뷰가 실행한 각 flow 요소의 상세, 실패한 인터뷰를 Flow Builder에서 여는 링크**가 포함된다. (인쇄 p.233)

- 인터뷰가 여러 요소에서 실패하거나 인터뷰 배치(batch)에서 실패가 나면, 수신자는 **이메일 여러 통 또는 실패별 오류 메시지가 담긴 한 통**을 받는다.
- **인터뷰가 오류를 만나 fault 경로를 타면 fault 이메일을 보내는 대신 fault 경로의 요소를 실행**한다 (fault 경로 설계는 [[Flow 에러 처리]]).
- 이메일의 **"Flow Error: Click here to debug the error in Flow Builder"** 링크로 실패한 인터뷰를 대화형 환경에서 연다.
- **오류 이메일에는 프로세스/flow에 관련된 데이터(사용자 입력 데이터 포함)가 들어간다.**

이메일 본문 예 (인쇄 p.233 원문):

```
An error occurred at element Apex_Plug_in_1.
List index out of bounds: 0.

An error occurred at element Delete_1.
DELETE --- There is nothing in Salesforce matching your delete criteria.

An error occurred at element Email_Alert_1.
Missing required input parameter: SObjectRowId.
```

### 수신자 설정 (Select Flow and Process Error Email Recipients)
마지막 수정 관리자가 대응 적임자가 아니면 Apex exception email 수신자로 보낼 수 있다. (인쇄 p.242 — 이 설정의 에디션은 **Enterprise·Performance·Unlimited·Developer**)

1. Setup → Quick Find `Automation` → **Process Automation Settings**.
2. **Send Process or Flow Email to**에서 선택:
   - **User Who Last Modified the Process or Flow** — 오류가 난 flow를 마지막으로 수정한 사용자에게 발송.
   - **Apex Exception Email Recipients** — Setup의 Apex Exception Email 페이지에 등록된 주소들로 발송.
3. 저장.
(권한: 설정 편집 = Customize Application)

### 오류 이메일 고려사항 (Considerations for Flow Error Emails — 인쇄 p.283–284 전수)

**일반:**
- flow를 시작한 사용자에게 이름(first name)이 없으면 그 자리에 **null**이 표시된다.
- 변수 할당 표기 패턴: `{!variable} (이전 값) = field/variable (새 값)`. 이전 값이 없으면 괄호가 빈 채 표시 — 예: `{!varStatus} () = Status (Delivered)`.
- **관리 패키지에서 설치한 비템플릿 flow**의 인터뷰 오류 이메일에는 개별 요소 상세가 없고, 수신자는 flow를 설치한 사용자 또는 Apex exception email 수신자.

**실패한 인터뷰가 저장되는 flow 타입** (free-form 레이아웃으로 만든 경우): Screen flow · Record-triggered flow · Schedule-triggered flow · 트리거 없는 autolaunched flow — 저장된 인터뷰는 Flow Builder에서 열 수 있다.

**저장되지 않는 경우 (전수):** 관리 패키지 설치본(템플릿 제외) / 일시정지 후 1회 이상 재개된 뒤 실패 / fault connector로 오류가 처리됨 / Apex 테스트 메서드 중 실패 / 표준(standard) flow / flow 메타데이터 status가 Draft·InvalidDraft / 실패 인터뷰가 1MB 초과 / DB에 저장된 실패 인터뷰 합계가 1GB 초과.

**저장 한도 (전수):**
- 실패한 인터뷰는 데이터·파일·일시정지 인터뷰 스토리지 한도에 집계되지 않고, **최대 14일 보관 후 자동 삭제**된다.
- 특정 flow당 **24시간에 최대 100개** 저장.
- **같은 트랜잭션의 최대 200개 실패 인터뷰 배치당 1개**만 저장.
- org 전체 **24시간에 최대 3,000개** 저장.
- **1MB 초과 인터뷰는 저장 안 됨**, 저장 합계 **1GB 초과 시 추가 저장 안 됨**.

**Screen 요소:** 비밀번호 필드가 **평문으로 표시**된다.

**Subflow 요소:** 참조된 flow의 변수는 머지필드 표기(`{!subVariable}`)가 아니라 `subVariable`로 표시 / 참조된 flow에서 오류가 나면 이메일은 **부모 flow 작성자**에게 가지만 제목은 참조된 flow 이름 / `Entered flow X version N`이 `Exited ...` 없이 반복되면 사용자가 뒤로 이동한 것 — 참조 flow 첫 화면에서 Previous를 막아 방지.

## Flow Builder 디버그

> [!warning] Rollback 모드 없이 디버그하면 실제로 실행된다
> **Run flow in rollback mode를 선택하지 않고 디버그하면 flow는 DML·Apex 코드 실행을 포함한 실제 액션을 수행**한다. 실행 중인 flow를 닫거나 재시작해도 이미 실행된 액션·콜아웃·DB 커밋은 롤백되지 않는다. (인쇄 p.234)

디버그는 모든 flow 타입에서 가능한 것은 아니다(아래 고려사항 참조). **디버그 권한: View All Data.** (인쇄 p.234)

1. Flow Builder에서 flow를 연다.
2. **Debug** 클릭.
3. **디버그 옵션과 입력 변수 설정** — 옵션은 flow 타입에 따라 다르다.
4. 다른 사용자로 디버그하려면(아래 참조) 설정 후 **Run flow as another user** 선택.
5. **Run** 클릭 → 실행의 디버그 상세가 오른쪽 패널에 표시된다.
6. 디버그 옵션에서 **Debug wait element behavior**를 선택했다면, flow의 Wait 요소마다 **Wait Path를 선택하고 Continue the Debug Run** 클릭.
7. (선택) 같은/다른 입력 변수로 재시작: **Debug Again**.
8. (선택) **record-triggered flow에 한해** 디버그 실행을 테스트로 변환: **Convert to Test** (→ [[Flow Tests (플로우 테스트)]]).

### Record-Triggered flow의 Debug flow 대화상자
PDF 인쇄 p.235의 스크린샷(이미지로 직접 확인)에 표시된 대화상자 구성:

- **Select Path** — "record-triggered flow에서는 한 번에 한 경로만 디버그할 수 있다." **Path for Debug Run** 드롭다운(예: Run Immediately).
- **Debug Options** — 체크박스 3종:
  - **Skip start condition requirements**
  - **Run flow as another user**
  - **Run flow in rollback mode**
- **Triggering Record** — "디버그 실행에서는 이 레코드가 created/updated/deleted된 것처럼 flow를 트리거한다." 대상 레코드 검색(예: Case).

### Run flow as another user (다른 사용자로 디버그)
1. Setup → Quick Find `Process` → **Process Automation Settings**.
2. **Let admins debug flows as other users** 활성화 후 저장 — 이 설정이 켜지면 **Manage Flow + View All Data 권한자가 디버그할 때마다 running user를 지정**할 수 있다.
3. Debug Options에서 **Run flow as another user** 선택 후 사용자 검색.
4. **다른 사용자로 디버그는 sandbox 환경에서만 가능하다.**

> [!warning] 다른 사용자로 디버그하면 레코드 변경·액션이 **그 사용자로** 수행된다. flow의 오브젝트 권한·필드 접근도 그 사용자의 프로필·권한 집합이 결정한다. 단, **항상 system context로 실행되는 flow는 사용자의 오브젝트 권한·필드 접근을 무시**한다.

### 타입별 디버그 예제 (인쇄 p.237–241)
- **Screen flow**: Debug → 옵션 설정 → Run → 필수 필드 입력 → Next → Debug Details 확인. 재시작은 **Change Inputs 또는 Run Again**. **디버그 실행을 테스트로 변환 불가.**
- **Template-triggered prompt flow**: **Run flow in rollback mode를 켜고** 디버그 권장. Winter '24에 만든 프롬프트 템플릿과는 비호환. **테스트로 변환 불가.** (에디션: Enterprise·Performance·Unlimited + Einstein for Sales/Platform/Service 애드온, Lightning Experience 전용)

> [!tip] Sandbox → Production 이동 후에는 항상 rollback 모드로 디버그
> sandbox에서 활성화한 flow를 production으로 옮기면 새 버전으로 저장할 때까지 Activate 버튼이 비활성화된다. sandbox와 production은 속성·ID가 다를 수 있으므로, **이동 후에는 항상 rollback 모드로 flow를 디버그**한다. (인쇄 p.220)

### 디버깅 고려사항 (Considerations for Troubleshooting Flows — 인쇄 p.282 전수)
- **Delete 요소가 있는 flow는 비활성 상태라도 디버그 시 삭제가 실제로 실행**되므로 주의.
- rollback 모드를 선택하지 않으면 DML·Apex 실행 포함 실제 액션 수행(위 경고와 동일).
- **collection·record·record collection 타입 입력 변수에는 값을 전달할 수 없다.**
- **Pause 클릭 또는 Wait 요소 실행은 flow를 닫고 디버깅을 종료**한다.
- 다른 사용자로 디버그 시의 권한 동작(위 경고와 동일).
- flow에서 Finish를 클릭하면 디버그 상세에 "Selected Navigation Button: NEXT"로 **잘못 표기**된다.
- **schedule-triggered flow 디버그는 레코드 1건에 대해서만 시작**된다.
- **record-triggered flow 디버그는 flow 내부만 검증**한다 — 다른 트리거된 flow·프로세스 때문에 디버그에서는 되는데 런타임에서는 안 되는 시나리오가 생길 수 있다. 실전 동작은 **sandbox org에서 테스트**하라.
- **Stages**: 오류 이메일은 인터뷰 시작 시점의 `$Flow.ActiveStages`·`$Flow.CurrentStage` 값을 알려주지 않는다 — 초기값 확인이 필요하면 텍스트 필드 등 임시 표시 요소를 추가한다.

## 디버그 로그

Record-triggered flow의 **scheduled path** 정보는 디버그 로그 이벤트로 확인할 수 있다 (인쇄 p.37):

| Debug Log Event | 설명 |
|---|---|
| `FLOW_SCHEDULED_PATH_QUEUED` | 레코드 생성/업데이트 후 scheduled path가 큐에 추가될 때 기록 |
| `FLOW_VALUE_ASSIGNMENT` | scheduled path가 실행될 때 기록 |

scheduled path 실패 시 재시도 규칙 (인쇄 p.38, 진단 시 참고):
- 1회 실패하면 오류 이메일이 발송되고 **15분 후 재시도, 최대 5회** — 15 → 30 → 60 → 120 → 240분 간격. 재시도 횟수는 Time-Based Workflow 페이지에 표시되지 않지만, 재시도가 예약되면 Scheduled Date 열에 다음 시도 시각이 표시된다.
- 벌크 실행에서 일부 인터뷰만 실패하면 트랜잭션이 롤백되고 성공했던 인터뷰가 즉시 재시도된다 — 이 시나리오의 **최대 재시도는 2회**.
- 예약된 경로가 지정 시각에 실행되지 않으면 flow 자체 문제(오류 이메일 수신) 또는 **rolling 24시간 한도 초과**일 수 있다 — 후자는 재예약되어 다시 시도된다.

## Flow URL 트러블슈팅

커스텀 버튼·링크·직접 flow URL이 동작하지 않을 때 (인쇄 p.241 전수):

**flow 확인:**
- URL이 참조하는 flow가 삭제·비활성화되지 않았는지.
- flow 이름 철자·대소문자가 **flow API Name과 대소문자까지 정확히 일치**하는지.
- URL이 특정 flow 버전을 참조하면 그 버전이 삭제·비활성화되지 않았는지.

**URL로 변수를 전달하는 경우** — URL이 변수에 접근하지 못하면 그 파라미터는 무시된다. 변수 확인:
- 철자·대소문자가 flow 변수와 정확히 일치하는지.
- 입력 접근(input access)을 허용하는지.
- flow에서 이름이 바뀌지 않았는지 / 제거되지 않았는지.
- **데이터 타입이 Record가 아닌지** (Record 타입은 불가).
- 전달하는 값이 변수의 데이터 타입과 호환되는지.

## 관련 노트

- [[Flow Tests (플로우 테스트)]] — 활성화 전 자동화 테스트 (이 노트의 짝: 테스트=활성화 전, 디버깅·모니터링=운영 중)
- [[Flow 에러 처리]] — fault connector·오류 화면·커스텀 에러 메시지 설계 (설계는 저쪽, 운영·진단은 이 노트)
- [[Flow Interview API]] — Apex `Flow.Interview`로 인터뷰 시작·변수 접근
- [[Platform Admin Objects]] — FlowInterview·FlowInterviewLog·FlowInterviewLogEntry 등 런타임 sObject 목록과 FlowDefinitionView 조회 패턴
- [[Flow — 선언적 자동화 개요 (플로우)]] — 어드민 관점 Flow 개요 허브
- [[Flow 설계 베스트 프랙티스]] — 실패를 줄이는 설계 원칙
