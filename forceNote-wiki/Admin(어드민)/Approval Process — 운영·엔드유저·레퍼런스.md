---
tags: [admin, approval-process, automation, approvals, approval-limits, approval-history-report, end-user]
source: extend_click_automate.pdf (Automate Your Business Processes, Spring '26, Last updated 2026-03-31) — 물리 846–886
created: 2026-07-18
aliases: [Approval operations, approval limits, approval history report, Respond to approval, Prepare Your Org for Approvals, Manage Multiple Approval Requests, 승인 한도, 승인 이력 리포트, 엔드유저 승인, 승인 응답, 승인 요청 회수]
---

# Approval Process — 운영·엔드유저·레퍼런스

> Classic 승인 프로세스를 활성화한 뒤의 **운영(org 준비·채널별 응답 설정)·한도·샘플·이력 리포트·대량 요청 관리·엔드유저 승인 경험**을 다루는 심화 노트. 개요·용어·Setup·마법사·자동화 액션은 companion [[Approval Process (승인 프로세스)]] 소관이며 여기서 재서술하지 않는다.

---

> [!note] 전역 EDITIONS / USER PERMISSIONS 반복 블록
> 이 챕터 대부분의 하위 페이지 사이드바에 아래가 반복된다. 섹션별로 다를 때만 그 섹션에서 별도 표기한다.
> - **Available in:** Salesforce Classic **and** Lightning Experience
> - **Available in:** Enterprise, Performance, Unlimited, and Developer Editions

---

## 1. Prepare Your Org for Approvals (org 준비)

> 사용자가 레코드를 승인 제출할 수 있게 하고, 승인자가 요청에 응답하기 쉽게 만든다.

### 1.1 Activate an Approval Process (활성화)
> 승인 프로세스에 최소 한 단계를 만든 뒤 활성화한다.
1. 승인 프로세스를 연다.
2. 올바르게 구성됐는지 확인한다.
3. **Activate**를 클릭한다.
- **USER PERMISSIONS** — To activate approval processes: **Customize Application**

### 1.2 Let Users Submit for Approval (제출 지원)
> 오브젝트에 승인 프로세스를 활성화한 뒤, 레코드 제출을 지원하도록 오브젝트 페이지 레이아웃을 커스터마이즈한다. 다음 컴포넌트를 페이지 레이아웃에 추가한다:
- **Submit for Approval** 버튼
- **Approval History** 관련 목록 — 사용자가 승인 요청을 제출하고, 레코드 상세 페이지에서 승인 프로세스 진행 상황을 추적할 수 있게 한다.
- **USER PERMISSIONS** — To modify page layouts: **Customize Application**

### 1.3 Override the Sender for Email Approval Notifications (발신자 재정의)
> 기본적으로 이메일 승인 알림의 발신자는 레코드를 승인 제출한 사용자다. 이를 조직 전체 주소(organization-wide address, 예: `approval@acmewireless.com`)로 재정의할 수 있다.

org에 organization-wide address를 추가한 뒤:
1. Setup에서 Quick Find에 `Process Automation Settings`를 입력하고 **Process Automation Settings**를 선택한다.
2. **Email Approval Sender**에서 organization-wide address를 선택한다.
3. 변경 사항을 저장한다.
- **USER PERMISSIONS** — To edit process automation settings: **Customize Application** · To create, update, and delete flow list views: **Manage Flow**

### 1.4 Let Users Respond to Approval Requests from Your Org (org 내 응답 뷰)
> Home 페이지나 navigation bar를 커스터마이즈해 승인 요청을 즉시 볼 수 있게 한다.

| 환경 | 추가할 것 | 비고 |
|---|---|---|
| **Lightning Experience** | **Items to Approve** 컴포넌트 | **Home 페이지 전용.** Setup의 Lightning App Builder로 추가 |
| **Lightning Experience** | **Approval Requests** navigation item | **Lightning 앱 전용.** Setup의 App Manager로 추가 |
| **Salesforce mobile app** | **Approvals** 항목 | 임의의 Lightning 앱의 navigation items에 추가 |
| **Salesforce Classic** | **Items to Approve** 관련 목록 | Home 페이지 레이아웃에 추가 |

### 1.5 Let Users Respond to Approval Requests by Email (이메일 응답)
> 이메일 알림에 승인 결정에 필요한 정보가 모두 포함돼 있다면 email approval response를 활성화한다. 그러면 사용자가 알림 이메일에 회신하는 것만으로 응답할 수 있다.

**Considerations — Compatibility with Approval Processes:** email approval response는 다음 승인 프로세스에서는 **지원되지 않는다**:
- 승인을 queue에 할당하는 경우
- 첫 단계 이후 승인자가 다음 승인자를 수동으로 선택하도록 한 경우

**Implicit Agreement with Salesforce** — email approval response 기능을 활성화하면 Salesforce가 다음을 하도록 동의하는 것이다:
- 이메일 승인 응답을 처리
- org 내 모든 활성 사용자의 승인 요청을 업데이트
- org 사용자를 대신해 승인 오브젝트를 업데이트

**Default Template for Email Approval Response** — email approval response를 활성화하면, 커스텀 템플릿을 지정하지 않는 한 Salesforce가 기본 이메일 템플릿을 사용한다. 기본 템플릿 본문(verbatim):

```
Requesting User has requested your approval for the following item.
To approve or reject this item, reply to this email with the word APPROVE, APPROVED, YES,
REJECT, REJECTED, or NO in the first line of the email message, or click this link:
Link to approval request page
```

- 이메일로 회신할 때 **두 번째 줄**에 comment를 추가할 수 있고, 이 comment는 승인 요청과 함께 Salesforce CRM에 저장된다.
- **Note:** Salesforce가 응답을 처리하려면 APPROVE·APPROVED·YES·REJECT·REJECTED·NO 중 하나가 회신 이메일의 **첫 줄**에 있어야 한다. comment는 반드시 **두 번째 줄**에 있어야 한다.
- Approvals in Chatter가 활성이고 승인자가 Chatter 게시물로 알림 받기를 택했다면, 기본 이메일 템플릿에 다음이 덧붙는다:
  ```
  You can also approve, reject, and comment on this request from your Chatter feed:
  Link to approval post in Chatter
  ```
- **Note:** 커스텀 이메일 템플릿을 쓴다면 두 응답 방식(링크 클릭·이메일 회신)을 모두 설명해야 한다. 사용자가 올바르게 응답하지 않으면(예: approve를 오타 내거나 잘못된 줄에 입력) Salesforce가 응답을 등록하지 않는다.

**Enable Email Approval Response** — 시작 전, 이메일로 승인 요청에 응답할 수 있도록 해당 사용자에게 **"API Enabled"** 사용자 권한을 부여한다.
1. Setup에서 Quick Find에 `Process Automation Settings`를 입력하고 **Process Automation Settings**를 선택한다.
2. **Enable email approval response**를 선택한다.
3. 변경 사항을 저장한다.
- **USER PERMISSIONS** — To enable Email Approval Response: **Customize Application**

### 1.6 Let Users Respond to Approval Requests from Chatter (Chatter 응답)
> 승인 결정에 심층 정보가 필요 없다면 Approvals in Chatter를 활성화한다. 사용자가 피드를 벗어나지 않고 응답할 수 있다.

**Prepare** — Approvals in Chatter를 활성화하기 전, 승인 요청을 Chatter에 표시할 각 오브젝트에 대해:
1. Feed tracking을 활성화한다.
2. approval post template를 만든다.
> **Tip:** 각 오브젝트마다 모든 승인 프로세스에 통하는 post template 하나를 만들고, 그것을 그 오브젝트의 기본값으로 지정한다.

**Enable Approvals in Chatter:** (USER PERMISSIONS — 필요 권한: **Customize Application**)
1. Setup에서 Quick Find에 `Chatter Settings` 입력 → **Chatter Settings** 선택.
2. **Edit** 클릭.
3. **Allow Approvals** 선택.
4. 저장.

**Considerations:**
- org에서 Approvals in Chatter를 활성화하면 **모든 사용자에게 켜진다.** 사용자는 자신의 Chatter 설정에서 opt out 할 수 있다.
- Chatter 게시물 승인 알림은 **feed tracking이 활성화된 오브젝트**의 승인 프로세스에서만 사용 가능하다.
- 승인 오브젝트가 master-detail 관계의 detail 오브젝트이면, 승인 페이지 레이아웃이나 approval post template에서 **Owner를 사용할 수 없다.**

**Limitations:**
- Approvals in Chatter는 **delegated approver나 queue를 지원하지 않는다.**
- 게시물에서 승인 요청을 recall하거나 reassign할 수 없다 — 대신 승인 레코드에서 수행한다.
- Sites 또는 portal 사용자의 승인 요청은 지원되지 않는다.

**Approval Posts 동작:**
- 승인 게시물은 Salesforce UI에서 삭제할 수 없고 **API로만** 삭제 가능하다.
- approval post template를 선택하지 않으면, 게시물은 시스템 기본 템플릿 또는 (있다면) 오브젝트 기본 템플릿을 사용한다.
- 승인 레코드에 접근 가능한 사용자만 승인 요청 게시물을 볼 수 있다. 승인 게시물의 comment는 승인 레코드에 **저장되지 않는다.**
- 사용자마다 승인 요청 게시물의 구성이 다르게 보인다:
  - 승인자만 자기 게시물에서 승인 액션 버튼을 본다(그것도 profile feed 또는 news feed에서만).
  - 승인자만 header에서 승인자 이름을 본다.
- 진행 중인 승인 프로세스에서 승인자·단계 이름·routing type을 바꿔도 **기존 승인 게시물은 갱신되지 않는다.**
- 승인 요청이 recall되면 **새 게시물**이 생성되어 submitter·모든 승인자·오브젝트 followers의 news feed와 record feed에 나타난다.
- 한 단계가 여러 승인자의 unanimous 승인을 요구하면, 그 단계의 승인 요청 게시물 header에 선택된 모든 승인자를 나열하지 않는다. 승인자는 header에서 자기 이름만 본다.

**Where Do Approval Request Posts Appear?** — 승인 레코드에 접근 가능해야 게시물을 볼 수 있으며, 다음 피드에 나타난다:
- 할당된 승인자의 Chatter feed
- Submitter의 profile
- (승인 요청 레코드를 팔로우 중이라면) submitter의 Chatter feed
- 승인 요청 레코드의 Chatter feed
- 승인 요청 레코드를 팔로우하는 모든 사람의 Chatter feed
- 승인 레코드를 팔로우하는 사람의 Chatter feed 오브젝트별 필터
- 승인 레코드에 접근 가능한 모든 사용자의 company 필터

**Chatter Post Templates — Considerations:**
- 연관 오브젝트는 approvals와 feed tracking이 활성화돼 있어야 한다.
- approval post template가 승인 프로세스에서 사용 중이면 삭제할 수 없다.
- **Chatter의 승인 요청 게시물은 Salesforce Classic에서만 나타난다.** Lightning Experience에서 응답하려면 사용자는 Approval Requests 탭으로 간다.
- (Dependencies) 커스텀 필드를 삭제하면 이를 참조하는 approval post template에서 제거된다(기존 게시물은 영향 없음). 커스텀 필드를 복원하면 available fields에는 복원되나 template에는 자동 복원되지 않는다. 커스텀 오브젝트 삭제/복원은 연관된 approval post template와 이미 피드에 있는 승인 요청 게시물도 함께 삭제/복원한다. 커스텀 오브젝트 이름을 바꾸면 연관 template도 그에 맞게 갱신된다.

**Create a Chatter Post Template:**
1. Setup → Quick Find `Post Templates` → **Post Templates**.
2. **New Template** 클릭.
3. 템플릿의 오브젝트 선택 → **Next**.
4. 이름·설명 입력.
5. 이 오브젝트의 기본값으로 만들려면 **Default** 선택.
6. 승인 요청 게시물에 표시할 필드를 **최대 4개** 추가한다. (Comments·Description 같은 텍스트가 많은 필드는 하단에 두기를 권장.)
7. 저장.
- **USER PERMISSIONS** — To create approval request post templates: **Customize Application**

### 1.7 Let Users Respond to Approval Requests in Slack (Slack 응답)
> 승인 결정에 심층 정보가 필요 없고 Slack에 연결돼 있다면 Approvals in Slack을 활성화한다.

**Considerations:** 사용자는 Slack에 **Salesforce Digital HQ** 앱이 있어야 한다. org에서 활성화하면 모든 사용자에게 켜진다.
- Salesforce Digital HQ 앱은 **단 하나의 Salesforce org**에만 연결할 수 있다.
- 사용 가능한 액션은 **Approve와 Reject뿐**이다.
- **Show More** 링크는 Salesforce Classic 사용자에게 작동하지 않는다.
- 승인자가 다음 승인자를 수동으로 선택해야 하면, 전체 Salesforce 사이트에 로그인해 완료해야 한다.
- 사용자는 **comment가 없는 승인 요청에만** 응답할 수 있다.
- 승인 요청의 필드는 Slack 알림에 **최대 4개만** 나타난다.

**Enable Approval Notifications in Slack:** org가 Approvals와 Salesforce Digital HQ 앱을 모두 쓰면 Slack 알림이 자동으로 켜진다.
> **Note:** Slack 알림은 자동으로 켜진다. 관리자는 Setup의 Notification Delivery Settings 페이지에서 끌 수 있다.
1. Setup → Quick Find `Notification Delivery Settings` → **Notification Delivery Settings**.
2. **Approval requests** 드롭다운에서 **Edit** 선택.
3. **Slack**을 선택하고 **Salesforce Digital HQ**를 활성화한다.
- **USER PERMISSIONS** — To enable approvals in Slack: **Customize Application**

**Where Do Slack Approval Notifications Appear?** — 승인 알림은 Salesforce Digital HQ 앱을 통해 Slack의 direct message로 승인자에게 전송된다. 사용자는 요청을 검토해 **Approve** 또는 **Reject**를 선택하거나, **Show More**로 Salesforce 앱에 이동해 상세를 본다. 사용자는 email·Lightning Experience·mobile 알림도 계속 받을 수 있다.

---

## 2. Limits and Considerations for Approvals

> 승인 프로세스로 자동화하기 전에 한도와 고려사항을 알아둔다. 사용자는 **Submit for Approval**을 클릭할 때 어떤 승인 프로세스가 트리거되는지 볼 수 없다. 레코드가 진입 기준을 충족하지 않거나 사용자가 어떤 승인 프로세스의 허용된 submitter도 아니면 Salesforce가 오류를 표시한다.

### 2.1 ⭐ Approval Limits (한도 표 — 셀 검증됨)
> Salesforce는 org의 승인 프로세스 수, 각 승인 프로세스의 단계·액션 수를 제한한다.

| Per-Org Limit | Value |
|---|---|
| Active approval processes | **1,000** |
| Total approval processes | **2,000** |
| Active approval processes per object | **300** |
| Total approval processes per object | **500** |
| Steps per approval process | **30** |
| Approvers per step | **25** |
| Initial submission actions per approval process² | **40** |
| Final approval actions per approval process² | **40** |
| Final rejection actions per approval process² | **40** |
| Recall actions per approval process² | **40** |
| Maximum characters in approval request comments | **4,000** — 중국어·일본어·한국어(CJK)에서는 **1,333** 자 |

> [!warning] 각주 "²" 본문 미확보
> 4개 action 항목(Initial submission / Final approval / Final rejection / Recall actions)에 위첨자 **²**가 붙어 있으나, PDF에서 각주 본문이 추출되지 않았다. 정의는 추측하지 않는다 — 원문 확인 시 각주 텍스트 별도 확보 필요.

### 2.2 Considerations for Configuring Approvals
- **Associated Object** — 승인 오브젝트가 master-detail의 detail 오브젝트이면 승인 페이지 레이아웃·approval post template에서 **Owner를 사용할 수 없다.**
- **Approval Criteria** — 진입 기준이든 단계 기준이든, **랜덤 값으로 해석되는 표현식을 참조하지 않는다.** 기준이 다시 평가돼도 레코드가 매번 동일하게 평가되도록.
- **Compatibility with Other Features** — Flow는 승인 대기 중인 레코드를 삭제할 수 있다. workflow rule과 approval process 양쪽에서 쓸 수 있도록 automated action을 설계한다.
- **Field Update Actions in Approvals:**
  - 승인 프로세스가 업데이트된 오브젝트에 대해 workflow rule을 재평가하는 field update action을 지정할 수 있다. 단, 재평가되는 workflow rule에 cross-object field update가 있으면 그 cross-object field update는 **무시된다.**
  - 승인 액션으로 실행되는 field update는 workflow rule이나 entitlement process를 **트리거하지 않는다.**
- **Anticipate Errors** — approvals 오류 콘텐츠를 검토해 흔한 문제를 예상하고 오류 가능성을 낮춘다.
- **Approvals in Unlocked Packages:**
  - unlocked package는 승인자로 related user·queue를 참조하는 step을 가진 Approvals를 포함할 수 있다 — **users는 지원되지 않는다.**
  - step이 참조하는 queue·related user 필드(lookup)는 unlocked package에 포함돼야 한다.
  - Approval Process는 **specified namespace가 없는** unlocked package에만 포함될 수 있다.

### 2.3 Merge Fields for Approvals
> 승인 merge field에는 `{!ApprovalRequest.fieldName}`과 `{!Approval_Requesting_User.fieldName}`이 있다. 특정 이메일 템플릿에서 지원되며, 승인 프로세스 인스턴스 상태에 따라 다른 값을 반환한다.
> **Tip:** submitter가 항상 현재 사용자인 것은 아니다. 커스텀 이메일 템플릿에서는 `{!User.fieldName}` 대신 `{!Approval_Requesting_User.fieldName}`을 쓴다.

**Where Are Approval Merge Fields Supported?** — 승인 프로세스 merge field는 **email template**에서 쓸 수 있으나 **mail merge template**에서는 쓸 수 없다. `{!ApprovalRequest.Comments}`를 제외하고, `{!ApprovalRequest.field_name}` 형태 merge field는 **승인 assignment email과 승인 프로세스용 email alert**에서만 값을 반환한다. 그 외 이메일(workflow rule용 email alert 포함)에서 쓰면 **null**을 반환한다.

**What Values Does a Merge Field Provide?** — ApprovalRequest merge field의 값은 승인 프로세스가 어느 단계에 있는지에 따라 다르다.
- 승인 요청 이메일에서 merge field는 **submitter 이름과 첫 단계 이름**을 반환한다.
- 요청이 승인되면 merge field는 **가장 최근 승인자 이름과 두 번째 단계 이름**(있는 경우)을 반환한다.
- 이후 액션에 대해서는 merge field 값이 **이전에 완료된 단계**를 반환한다.
- 여러 승인자의 unanimous 승인을 요구하는 단계에서 `{!ApprovalRequest.Comments}`는 이메일에서 **가장 최근에 입력된 comment만** 반환한다.

### 2.4 Considerations for Setting Approvers
- 다음 권한을 가진 사용자는 지정 승인자가 아니어도 승인 요청에 응답할 수 있다: **Modify All Data**, 오브젝트에 대한 **Modify All**.
- 할당된 승인자가 승인 요청 레코드를 **읽을 수 있는지** 확인한다(경비 레코드를 못 보는 사용자는 경비 승인 요청도 못 본다).
- 승인자를 수동 선택하게 하는 승인 프로세스는 사용자가 **자기 자신을 승인자로** 선택하는 것도 허용한다.
- 한 단계에서 같은 사용자에게 승인 요청을 여러 번 할당할 수 있으나, Salesforce는 사용자에게 **요청을 하나만** 보낸다.
- Lightning Experience에서 승인 요청에 승인자가 둘 이상이면 각 할당 승인자마다 ProcessInstanceStep이 생성된다. **Approval based on first response** 설정이 켜져 있으면 Assigned To·Actual Approver 표시 값에 영향이 있다:
  - **Assigned to** = 레코드에 할당된 승인자
  - **Actual Approver** = 실제로 요청을 승인한 승인자

**레코드가 단계에 진입한 뒤 승인 프로세스가 그 단계로 되돌아올 때의 승인자 목록** (예: 첫 단계가 사용자의 manager 승인을 요청하고, 두 번째 단계에서 거부되어 첫 단계로 돌아온 경우):

| If... | The Designated Approver Is... |
|---|---|
| 사용자의 manager가 원래 승인 요청에 응답했다. | The manager |
| 사용자의 manager가 원래 응답했고, 이후 사용자의 manager가 바뀌었다. | 원래 manager. **새 manager는 이 단계의 지정 승인자가 아니다.** |
| Modify All Data 권한을 가진 사용자가 원래 응답했다. | Modify All Data 권한을 가진 그 사용자. **이 단계 지정 승인자 목록에서 사용자의 manager를 대체한다.** |

- 이 동작은 승인자를 지정하는 필드 값이 바뀌어도, 응답한 사용자가 이미 지정 승인자 목록에 있으면 목록이 바뀌지 않는다(변경 없음).
- **manager의 manager는 지정 승인자 옵션이 아니다.**

**Assigning Approval Steps to Queues:** 연관 오브젝트가 queue를 지원할 때만 승인 요청을 queue에 할당할 수 있다. **Email approval response는 queue에 할당하는 승인 프로세스에서는 지원되지 않는다.** 할당된 승인자가 queue일 때:
- queue의 어느 멤버든 승인/거부할 수 있다.
- 승인 요청 이메일은 queue 이메일 주소로 전송된다. queue가 멤버에게 이메일을 보내도록 설정돼 있으면, (approval user preference가 승인 요청 이메일을 절대 받지 않도록 설정된 경우를 제외하고) queue 멤버에게 전송된다.
- queue로 가는 이메일 알림은 외부 대상이 아니므로 `{!ApprovalRequest.External_URL}`은 **동등한 internal URL**을 반환한다.
- **Salesforce mobile app 알림은 queue로 전송되지 않는다.** queue가 관련된 각 승인 단계에는 개별 사용자를 할당 승인자로 추가하기를 권장한다. queue와 개별 사용자를 모두 할당 승인자로 두려면 단계에서 **Automatically assign to queue** 대신 **Automatically assign to approver(s)**를 선택한다.
- 승인 요청이 거부되어 이전 승인자(queue였던 경우)에게 반환되면, 승인 요청은 queue가 아니라 **그것을 승인한 사용자**에게 할당된다.
- Approval History 관련 목록은 **Assigned To** 열에 queue 이름을, **Actual Approver** 열에 실제 승인/거부한 사용자를 표시한다.

### 2.5 Considerations for Managing Approvals
- **Admin Permissions** — 다음 권한 중 하나를 가진 사용자는 approval admin으로 간주된다: 해당 오브젝트에 대한 **Modify All** 오브젝트 수준 권한, **Modify All Data** 사용자 권한. approval admin은 (1) 승인 프로세스에 속하지 않아도 대기 중인 승인 요청을 승인/거부할 수 있고, (2) 승인용으로 잠긴 레코드를 편집할 수 있다.
- **Activating Approval Processes:**
  - 활성화 전에 최소 한 단계가 있어야 한다.
  - 활성화 전에 sandbox에서 테스트한다.
  - **활성화 후에는** (프로세스가 비활성이더라도) 단계를 추가·삭제·순서 변경하거나 reject/skip 동작을 변경할 수 **없다.**
- **Monitoring In-Flight Approval Processes** — 승인 요청용 표준 리포트는 **Administrative Reports** 폴더와 **Activity Reports** 폴더 양쪽에 포함된다.
- **Deploying over Existing Approval Processes** — 진입 기준이 없는 승인 프로세스를 배포해 진입 기준이 있는 기존 프로세스를 덮어쓰면, 기존 프로세스의 진입 기준이 배포된 프로세스에 적용된다.
- **Deleting Approval Processes** — 삭제 전:
  - 비활성 상태인지 확인한다.
  - 연관된 모든 승인 요청을 삭제하고 Recycle Bin에서도 제거한다.
  - 상태와 무관하게, 승인 프로세스를 통해 제출된 모든 레코드(예: accounts)를 삭제한다. 레코드를 삭제하면 연관된 ProcessInstanceWorkitem·ProcessInstance 레코드도 자동 삭제된다.
  - 승인 프로세스를 삭제할 수 없으면 **2일 후** 다시 시도한다. Salesforce가 recycle bin에서 제거한 파일을 삭제하는 데 최대 **2일**이 걸릴 수 있다.

### 2.6 Considerations for the Salesforce Mobile App
> [!note] EDITIONS 예외
> Available in: **Lightning Experience** (Classic 아님) / Enterprise, Performance, Unlimited, and Developer Editions.

- **Approval Responses** — 승인용으로 잠긴 레코드를 mobile app에서 **잠금 해제할 수 없다.**
- **Notifications:**
  - 승인 요청 알림은 **queue나 delegate에게 전송되지 않는다.** queue가 관련된 각 단계에 개별 사용자를 할당 승인자로 추가한다(위 2.4와 동일 권장).
  - 알림은 **승인 대상 레코드에 접근 가능한 사용자에게만** 전송된다. 레코드 접근 권한이 없는 할당 승인자는 이메일 승인 알림은 받을 수 있으나, 누군가 레코드 접근 권한을 부여할 때까지 승인 요청을 완료할 수 없다.
- **Approvals in Chatter** — mobile app에서는 Chatter에서 승인 요청에 응답할 수 없다. 응답하려면 **Approvals** navigation item으로 간다.
- **Approval Comments** — mobile app은 Approve/Reject를 탭한 뒤 comment를 묻는다. Approval History 관련 목록은 truncate된 comment를 표시하며, 전체 comment는 인스턴스를 탭한 뒤 **Comments**를 탭해 본다.
- **Approval History Related List** — mobile app의 이 관련 목록에는 **Submit for Approval 버튼이 없다.** Experience Cloud 사이트에서 role-based external user는 Approval History 관련 목록을 보고 액션할 수 있으나 승인 요청을 **제출할 수는 없다.**

---

## 3. Sample Approval Processes

> 흔한 승인 프로세스 샘플 4종. 각 샘플은 Prep(조직 준비) → Create(프로세스 생성) → Wrap(마무리)의 3단계.

### 3.1 PTO Requests (1단계, Manager)
- **Prep:** PTO Requests custom object·tab을 만들고 Start Date·End Date·Employee Name 등 필드를 추가한다. 승인자 알림용 email template(승인 프로세스 merge field 포함)을 만든다.
- **Create (jump start wizard):** PTO Request custom object에 승인 프로세스 생성.
  - 만든 email template 선택.
  - **filter criteria를 지정하지 않는다** — 속성과 무관하게 모든 PTO 요청이 포함되도록.
  - **Automatically assign an approver using a standard or custom hierarchy field** → **Manager** 선택.
  - jump start wizard가 자동으로 record owner를 유일한 submitter로 선택한다.
  > **Tip:** submitter가 제출한 PTO 요청을 철회하게 하려면 Edit → Initial Submitters → **Allow submitters to recall approval requests** 선택.
- **Wrap:** PTO Request 오브젝트 페이지 레이아웃에 Approval History 관련 목록 추가. custom home 페이지 레이아웃에 Items To Approve 관련 목록 추가 고려. sandbox가 있으면 테스트 후 활성화.

### 3.2 Expense Reports (2단계 병렬, $50 / $5,000, UNANIMOUS)
> 본사(HQ) 전 직원 대상 2단계 경비 승인. **$50 미만 자동 승인, $50 이상은 manager 승인, $5,000 초과는 2명의 VP 추가 승인.** 병렬 승인 프로세스와 "else" 옵션을 보여준다.
- **Prep:** Expense Reports custom object·tab (Amount·Description·Status·Start Date·End Date). user 오브젝트에 custom field **Office Location**을 만들고 본사 사용자에게 "HQ" 값 할당.
- **Create:** Expense Report custom object에 승인 프로세스 생성.
  - filter criteria: `Current User: Office Location equals HQ`. 제출 전에 이 기준을 충족해야 함.
  - **Manager** 필드를 다음 automated approver로 선택.
  - email template 생성(merge field 포함).
  - record owner 또는 경비 보고서를 제출할 수 있게 할 다른 사용자 선택.
  - **Step 1: Manager Approval** — **Enter this step if the following** → **criteria are met**, else 옵션 = **approve record**. filter: `Expense: Amount greater or equal 50`. **Automatically assign to approver(s)**에서 제출 사용자의 manager 선택. (필요 시 **The approver's delegate may also approve this request** 선택.)
  - **Step 2: Multiple VP Approval** — filter: `Expense Amount greater or equal 5000`. **Automatically assign to approver(s)**로 VP role 사용자 2명 선택. **Require UNANIMOUS approval from all selected approvers** 선택(둘 다 승인해야 승인됨). VP 중 하나가 거부하면 manager에게 반환되도록 **Perform ONLY the rejection actions for this step...** 선택.
  > **Tip (final approval actions 제안):** Status 필드를 "Approved"로 바꾸는 field update. 제출자에게 승인 알림 전송. 지급 수표 출력을 위해 back-office 재무 시스템으로 outbound message 전송.
- **Wrap:** Approval History 관련 목록 추가, Items To Approve 관련 목록 추가 고려, sandbox 테스트 후 활성화.

### 3.3 Discounting Opportunities (1단계, CEO, 40%)
> 40% 초과 할인 기회는 CEO 승인 필요. 1단계 승인 프로세스.
- **Prep:** email template(merge field 포함). Opportunity custom field 2개 — percent 필드 **Discount Percent**, checkbox 필드 **Discount Approved**.
- **Create:** Opportunity 오브젝트에 승인 프로세스.
  - filter criteria: `Discount Percent greater or equal 0.4`.
  - 나중에 CEO가 모든 요청을 승인하도록 지정하므로 automated approver로 custom field를 고를 필요 없음.
  - email template 선택. record owner를 유일한 submitter로 선택.
  - filter criteria 없는 승인 단계 1개 생성(제출된 모든 레코드가 승인/거부돼야 하므로).
  - **Automatically assign to approver(s)** → CEO 이름 선택.
  - final approval actions 제안: 제출자 알림 email alert, Discount Approved checkbox를 자동 선택하는 field update.
- **Wrap:** 해당 opportunity 페이지 레이아웃에 Approval History 관련 목록 추가, Items To Approve 추가 고려, sandbox 테스트 후 활성화.

### 3.4 Job Candidates (3단계, Manager → VP → CFO)
> 오퍼 레터 발송 전 여러 관리 레벨의 승인. Manager → VP → CFO 3단계.
- **Prep:** Candidates custom object·tab (Salary·Offer Extended checkbox·Date of Hire). email template(merge field 포함).
- **Create:** Candidate custom object에 승인 프로세스.
  - filter criteria 없음(모든 제출 오퍼를 승인하도록). **Manager** 필드를 다음 automated approver로 선택. email template 선택. record owner 또는 다른 submitter 선택.
  - **Step 1: Manager Approval** — filter 불필요. **Automatically assign to approver(s)**로 제출 사용자의 manager 선택.
  - **Step 2: VP Approval** — filter 불필요. manager가 적절한 VP를 고르도록 **Let the user choose the approver** 선택. VP가 거부하면 manager에게 반환되도록 **Perform ONLY the rejection actions for this step...** 선택.
  - **Step 3: CFO Approval** — filter 불필요. **Automatically assign to approver(s)** → CFO 이름 선택. CFO가 거부한 오퍼는 완전히 거부되도록 **Perform all rejection actions for this step AND all final rejection actions. (Final Rejection)** 선택.
  > **Tip:** final approval actions — 제출자 알림 email alert, Offer Extended checkbox 선택 field update. final rejection action — 오퍼를 낼 수 없음을 manager에게 알리는 email alert.
- **Wrap:** Candidates 오브젝트 페이지 레이아웃에 Approval History 관련 목록 추가, Items To Approve 추가 고려, sandbox 테스트 후 활성화.

---

## 4. Approval History Reports

> 승인 프로세스 인스턴스용 custom report type을 만들면, 사용자가 완료·진행 중인 승인 프로세스와 개별 단계의 이력 상세를 볼 수 있다. **Process Instance**를 primary 오브젝트로, **Process Instance Node**를 related 오브젝트로 하는 custom report type을 만든다.

> [!note] EDITIONS 예외 (이 페이지)
> Available in: Salesforce Classic (not available in all orgs) and Lightning Experience.
> Available in: **Essentials, Group (View Only), Essentials, Professional, Enterprise, Performance, Unlimited, and Developer** Editions. *(원문 그대로 — "Essentials"가 두 번, "Group (View Only)" 포함.)*
> Available in: Enhanced Folder Sharing and Legacy Folder Sharing.

### 4.1 Process Instance (필드 전수)
> process instance는 승인 프로세스의 한 인스턴스를 나타낸다. 레코드가 승인 제출될 때마다 새 process instance가 생성된다.

| Field | Description |
|---|---|
| Approval Process: Name | 승인 프로세스의 이름. |
| Approval Process Instance ID | 승인 프로세스 인스턴스의 ID. |
| Completed Date | 승인 프로세스 인스턴스가 완료 또는 recall된 날짜·시간. 단계 기준이 충족되지 않아 레코드가 자동 승인/거부되면 Completed Date와 Submitted Date 값이 같다. |
| Elapsed Days | 레코드가 승인 제출된 시점과 승인 프로세스가 완료/recall된 시점 사이의 기간(일). |
| Elapsed Hours | (같은 측정 — 시간) |
| Elapsed Minutes | (같은 측정 — 분) |
| Last Actor: Full Name | 승인 프로세스 인스턴스에 가장 최근 참여한 사용자의 전체 이름. 자동 승인/거부되면 Last Actor: Full Name과 Submitter: Full Name 값이 같다. |
| Object Type | 승인 제출된 레코드의 오브젝트 타입. |
| Pending Step Name | 레코드가 승인/거부를 기다리는 승인 단계의 이름. |
| Record Name | 승인 제출된 레코드의 이름. |
| Status | 승인 프로세스 인스턴스의 상태. |
| Submitted Date | 레코드가 승인 제출된 날짜·시간. |
| Submitter: Full Name | 레코드를 승인 제출한 사용자의 전체 이름. |

### 4.2 Process Instance Node (필드 전수)
> process instance node는 승인 단계의 한 인스턴스를 나타낸다. 레코드가 승인 프로세스의 단계에 진입할 때마다 새 process instance node가 생성된다. 레코드가 단계 기준을 충족하지 않거나 단계에 진입하지 않고 인스턴스가 완료되면 node가 생성되지 않는다.

| Field | Description |
|---|---|
| Step: Name | 승인 단계의 이름. |
| Step: Completed Date | 승인 단계 인스턴스가 완료 또는 recall된 날짜·시간. |
| Step Elapsed Days | 레코드가 단계에 진입한 시점과 단계 인스턴스가 완료/recall된 시점 사이의 기간(일). |
| Step Elapsed Hours | (같은 측정 — 시간) |
| Step Elapsed Minutes | (같은 측정 — 분) |
| Step Last Actor: Full Name | 승인 단계 인스턴스에 가장 최근 참여한 사용자의 전체 이름. |
| Step Start Date | 레코드가 승인 단계에 진입한 날짜·시간. |
| Step Status | 승인 단계 인스턴스의 상태. |

### 4.3 Examples of Approval History Reports

> [!note] 리포트 스크린샷은 PDF에 이미지로만 존재
> 물리 870–873의 리포트 결과 스크린샷은 pdftotext로 추출되지 않았다(이미지 위 번호 콜아웃 (1)~(9)). 아래는 캡션 텍스트만이며, 스크린샷 자체는 재현하지 않는다.

- **Opportunity Approvals Submitted Within a Date Range** — 지정 날짜 범위(1) 내에 제출된 승인 프로세스 인스턴스를 Opportunity 오브젝트(2)에 대해 표시. status(3)로 정렬하고 last actor(4)·submitted date(5)·completed date(6)·record name(7)·approval process instance ID(8)·approval process name(9)을 포함.
- **Approvals—Elapsed Times** — 모든 승인 프로세스 인스턴스(1)를 표시하고 approval process name(2)으로 그룹화. record name(3)·approval process instance ID(4)·status(5)·submitted date(6)·elapsed minutes(7)·completed date(8)를 포함.
- **Approval Steps—Elapsed Times** — 모든 승인 프로세스 인스턴스(1)를 표시하고 approval process name(2)·record name(3)으로 그룹화. step name(4)으로 정렬하고 step status(5)·step start date(6)·step elapsed minutes(7)·step completed date(8)·approval process instance ID(9)를 포함.

**각 단계의 승인자와 경과 시간**은 위 리포트에 포함되지 않는다. 이 정보를 얻으려면 리포트의 approval process instance ID로 SOQL 쿼리를 실행한다. 아래 쿼리는 첫 pending 단계의 **ActorId**(승인 요청을 받은 user 또는 queue)와 **ElapsedTimeInHours**(승인 요청 전송 이후 경과 시간)를 얻는다.

```soql
SELECT ActorId,ElapsedTimeInHours FROM ProcessInstanceWorkitem where processInstanceId = '04gD0000000LvIV'
```

결과 ActorID를 org base URL(`https://MyDomainName.my.salesforce.com/005D00000015vGGIAY`)에 붙이면 해당 승인자의 user profile 페이지로 redirect된다.

### 4.4 Considerations for Approval History Reports

**Summer '14 Rollout 전 완료/대기 중이던 승인 프로세스** — Summer '14가 조직에 제공됐을 때 완료·대기 중인 승인 프로세스에 대해 승인 이력 데이터가 자동 populate됐다. 단, 일부 필드 값은 절대 populate되지 않거나, rollout 후 승인 프로세스 인스턴스가 다음에 액션될 때만(사용자가 승인·거부·reassign할 때) populate된다. 추가 예외는 특정 오브젝트의 SOQL 쿼리로만 확인 가능하다(Object Reference의 ProcessInstance·ProcessInstanceNode·ProcessInstanceStep·ProcessInstanceWorkitem 참조).

| Object | When Fields are Populated |
|---|---|
| Process Instance | Summer '14 rollout **전에 완료된** 인스턴스는 모든 Process Instance 필드가 자동 populate되나 **예외 1개**: Completed Date는 **2013년 1월 1일 이전**에 완료된 인스턴스에서는 절대 populate되지 않는다. rollout 중 **대기 중이던** 인스턴스는 모든 필드가 자동 populate되나 **예외 2개**: Completed Date와 Last Actor: Full Name은 인스턴스가 완료된 후에만 populate된다. |
| Process Instance Node | rollout **전에 완료된** 인스턴스에서는 **절대 populate되지 않는다.** rollout 중 **대기 중이던** 인스턴스는 모든 Process Instance Node 필드가 rollout 후 인스턴스가 다음에 액션될 때만 populate된다. |

**Sandbox Environment** — 승인 이력 데이터를 sandbox에 복사하면 일부 필드 값이 덮어써져 실제 이력을 반영하지 않는다.

| Object | Field | Sandbox에 복사될 때... |
|---|---|---|
| Process Instance | Submitted Date | process instance 레코드가 sandbox에 복사된 날짜·시간으로 덮어써진다. |
| Process Instance | Submitter: Full Name | process instance 레코드를 sandbox에 복사한 사용자 이름으로 덮어써진다. |
| Process Instance Node | Step Start Date | process instance node 레코드가 sandbox에 복사된 날짜·시간으로 덮어써진다. |

---

## 5. Manage Multiple Approval Requests (대량 관리)

> 대기 중인 승인 요청을 한 사용자에서 다른 사용자로 이전(transfer)하거나, 승인 프로세스에서 제거(remove)한다.

### 5.1 Transfer Pending Approval Requests
> 사용자가 대기 중인 승인 요청을 모두 완료하기 전에 새 role로 이동하면 나머지를 다른 사용자에게 이전한다.
1. Setup → Quick Find `Mass Transfer Approval Requests` → **Mass Transfer Approval Requests**.
2. 이전할 승인 요청을 검색한다.
3. **Mass transfer outstanding approval requests to a new user**를 선택한다.
4. 이전 대상 사용자를 조회·선택한다. (그 사용자가 승인 요청 관련 레코드를 볼 수 있는지 확인.)
5. comment를 추가한다. (입력한 comment는 Approval History 관련 목록에 표시됨.)
6. 이전할 각 승인 요청을 선택한다.
7. **Transfer**를 클릭한다.
- **USER PERMISSIONS** — To transfer multiple approval requests: **Transfer Leads** AND **Transfer Record**

### 5.2 Remove Pending Approval Requests
> 오래된 승인 요청을 정리하려면(예: 승인 프로세스 삭제) org에서 제거한다. 제거 후 연관 레코드는 잠금 해제되고 모든 승인 프로세스에서 제외되어, 승인자의 대기 목록에 더 이상 나타나지 않는다.
1. Setup → Quick Find `Mass Transfer Approval Requests` → **Mass Transfer Approval Requests**.
2. 제거할 승인 요청을 검색한다.
3. **Mass remove records from an approval process**를 선택한다.
4. comment를 추가한다.
5. 제거할 각 승인 요청을 선택한다.
6. **Remove**를 클릭한다.
- **USER PERMISSIONS** — To remove multiple approval requests: **Transfer Leads** AND **Transfer Record**

---

## 6. Approval Requests for Users — 엔드유저 승인 경험

> 관리자가 설정한 승인 프로세스에 따라 사용자는 레코드를 승인 제출하고, 요청을 받아 응답한다.

### 6.1 Submit a Record for Approval
1. 승인 제출할 레코드로 이동한다.
2. 제출 준비가 됐는지 확인한다. (제출 전에 활성 승인 프로세스의 기준을 충족해야 한다. 요건이 불확실하면 관리자에게 문의.)
3. **Submit for Approval**을 클릭한다. (승인 프로세스가 적용되면 Salesforce가 프로세스를 시작한다. 이 버튼은 레코드가 제출된 후에는 사용할 수 없다.)
> 제출한 승인의 진행 상황을 파악하려면 Chatter에서 승인 레코드를 팔로우하는 것을 권장한다.
- **USER PERMISSIONS** — To submit a record for approval: **Read on the record**

### 6.2 Withdraw an Approval Request (회수)
> 레코드를 승인 제출한 뒤 정보를 갱신해야 하면 승인 요청을 recall한다. 단, 관리자가 승인 프로세스를 어떻게 구성했느냐에 따라 recall 가능 여부가 달라진다.
1. 승인 요청과 연관된 레코드의 상세 페이지로 이동한다.
2. Approval History 관련 목록에서 승인 요청을 recall한다.
- **USER PERMISSIONS** — To withdraw an approval request: **Read on the Record**

### 6.3 Respond to an Approval Request
> 승인 요청을 받으면 승인·거부·reassign으로 응답한다. 사용 중인 Salesforce experience에 따라 옵션이 다르다. 승인 요청 comment는 **4,000자**로 제한된다. 중국어·일본어·한국어에서는 **1,333자**.
- **USER PERMISSIONS** — To respond from within Salesforce: **Read on the associated record** · To respond from an email: **API Enabled**

**⭐ Respond 매트릭스** — 채널(행) × Salesforce experience(열). ✅ = 지원, — = 미지원 (PDF는 ✔ / 빈칸 두 값만 사용; 물리 878 이미지 렌더 기준 셀값, PDF 원 방향 유지):

| Respond from... | Lightning Experience | Salesforce Classic | Salesforce Mobile App |
|---|---|---|---|
| An in-app notification | ✅ | — | ✅ |
| An email notification | ✅ | ✅ | ✅ |
| The record | ✅ | ✅ | ✅ |
| Chatter | ✅ | ✅ | ✅ |
| Home | ✅ | ✅ | — |
| Slack | ✅ | — | ✅ |

**채널별 상세 (표 순서대로, verbatim 기반):**
- **In-App Notification** — approver preferences의 `Receive Approval Request Emails` 필드에 따른다. org에 알림이 활성이면 승인 요청 이메일을 받을 때마다 알림을 받는다. 관리자가 actionable notification을 활성화했다면 알림에서 바로 응답. 알림을 클릭해 승인 요청을 연다.
- **Email Notification** — approver preferences의 `Receive Approval Request Emails` 필드에 따른다. 이메일의 링크를 클릭해 승인 요청을 연다. 관리자가 email approval response를 활성화했다면 이메일에 회신.
- **Record** — Approval History 관련 목록에서 응답한다.
- **Chatter** — 관리자가 Approvals in Chatter를 활성화했고 사용자가 opt out 하지 않은 경우에 따른다. 관리자가 actionable notification을 활성화했다면 게시물에서 응답. 레코드 이름을 클릭한 뒤 Approval History 관련 목록에서 응답.
- **Home** — 관리자가 Items to Approve 컴포넌트를 home 페이지에 추가한 경우에 따른다. Home 탭의 Items to Approve 컴포넌트에서 응답. **Tip:** Salesforce Classic의 이 컴포넌트에서는 여러 요청에 한 번에 응답할 수 있다.
- **Slack** — Slack 알림은 기본으로 활성. 관리자가 끄지 않았다면 Slack의 Salesforce Digital HQ 앱 Messages 탭에서 응답. Show More 링크는 Salesforce에서 승인 요청 상세를 연다.

#### 6.3.1 Respond via Email (이메일 응답)
> 관리자가 email approval response를 활성화했다면 이메일 알림에 회신해 승인·거부한다. Salesforce experience나 mobile 이메일 클라이언트와 무관하다. Delegated approver도 이메일로 응답할 수 있다. 모든 지원 언어에서 동작하며, 응답 단어는 현재 사용자 언어 사전으로 확인되고, 매치가 없으면 다른 모든 언어 사전에서 확인된다.
1. 회신 이메일의 **첫 줄**에 지원 응답 단어 중 하나를 입력한다. (단어 끝에 마침표·느낌표 허용.)

| Approval Words | Rejection Words |
|---|---|
| approve | reject |
| approved | rejected |
| yes | no |

2. 선택적으로 **두 번째 줄**에 comment를 추가한다.
3. 이메일을 보낸다.
- **USER PERMISSIONS** — To respond via email: **API Enabled**

#### 6.3.2 Troubleshoot Email Responses (문제 해결 4)
- **승인 요청 이메일을 못 받음** — approval preference가 승인 요청 이메일을 opt out 했거나 / 메일 서버가 스팸으로 판단(이메일 관리자가 inbound 로그 확인 가능)하거나 / 이메일 관리자가 Salesforce 발신 주소를 허용 목록에 추가해야 하거나 / ISP·연결에 따라 전송 시간이 다를 수 있다.
- **응답이 전달되지 않음** — 이메일 승인 요청은 **한 번만** 처리된다(다른 사용자가 먼저 응답하면 오류). 이메일 응답에는 **"API Enabled"** 권한이 필요하다.
- **"The word used to approve or reject the item was not understood."** — Salesforce는 오류 이메일에 대한 회신을 처리하지 않는다. 원래 알림 이메일에 다시 회신하되, 지원되는 응답 단어를 사용한다.
- **"You are not authorized to update the referenced object."** — 승인 요청 이메일은 사용자의 이메일 주소에 묶여 있다. 다른 주소로 전달하거나 여러 주소에서 응답하면 이 오류가 난다. 승인 요청을 **받은 바로 그 주소**에서 다시 회신한다.

### 6.4 What Does This Approvals Error Mean? (오류 2)
- **"Manager undefined — This approval request requires the next approver to be determined by the [Field Name] field. This value is empty."** — Salesforce가 계층 필드(예: Manager)로 승인 요청을 라우팅하려 했으나 필드에 값이 없거나 비활성 사용자를 지정한다. 제출 시 또는 응답 시 발생할 수 있다.
- **"Required fields are missing: [FieldName]."** — 승인 프로세스에 해당 필드의 표준 validation rule을 통과하지 못하는 field update가 있다. 필드가 페이지 레이아웃에 보이지 않아도 발생할 수 있다.
  > **Note:** Salesforce는 field update가 필드의 **커스텀** validation rule을 통과하는지는 검사하지 않는다.

### 6.5 Approval History Status (상태 표)
> 레코드가 승인 프로세스의 어디에 있는지 추적하려면 Approval History 관련 목록을 본다.

| Status | Definition |
|---|---|
| Submitted | 레코드가 승인 제출됐다. |
| Pending | 레코드가 승인 제출됐고 승인 또는 거부를 기다리고 있다. |
| Approved | 레코드가 승인됐다. |
| Rejected | 레코드가 거부됐다. |
| Reassigned | 레코드가 승인 제출됐으나 다른 승인자에게 할당됐다. |
| Recalled | 레코드가 승인 제출됐으나 승인 프로세스에서 recall됐다. |

> [!note] EDITIONS
> Available in: Salesforce Classic (not available in all orgs) / Enterprise, Performance, Unlimited, and Developer Editions.

### 6.6 Approval User Preferences (사용자 설정)
> delegated approver를 지정하고 승인 요청 이메일 수신 여부를 제어한다. 개인 설정에서 Quick Find에 `Approver Settings`를 입력하고 **Approver Settings**를 선택한다(결과 없으면 `Personal Information` → **Personal Information**).

| Field | Description |
|---|---|
| Delegated Approver | 대체 승인자. populate되면 이 사용자가 나와 동일한 승인 요청을 받는다. **Delegated approver는 승인 요청을 reassign할 수 없고, 승인 또는 거부만 할 수 있다.** 내부 Salesforce 사용자는 Delegated Approver 조회 필드로 나열/추가한다. communities 라이선스 사용자를 delegated approver로 추가하려면 Data Loader와 CSV 파일을 쓰며, CSV는 `DelegatedApproverId`에 대해 `UserId`가 아니라 `CommunityUserId`를 사용한다(communities 라이선스는 Experience Cloud 사이트·레거시 portal에서 사용). |
| Manager | 관리자가 승인 프로세스를 어떻게 설정했느냐에 따라, 승인 요청이 자동으로 나의 manager에게 라우팅될 수 있다. |
| Receive Approval Request Emails | 승인 요청 알림을 email·Salesforce mobile app·Lightning Experience에서 받을지 제어한다. **Never**를 선택하면 승인 요청 알림을 받지 않는다. 단, 관리자가 queue 이메일을 어떻게 구성했느냐에 따라 **queue로부터의 승인 요청 이메일은 여전히 받는다.** |

> [!note] EDITIONS (User Preferences)
> Available in: Salesforce Classic and Lightning Experience / Enterprise, Performance, Unlimited, and Developer Editions.

### 6.7 Opt Out of Approval Request Posts in Chatter (Chatter opt-out)
> org에서 Approvals in Chatter를 활성화하면 기본적으로 이메일과 Chatter 게시물로 승인 요청 알림을 받는다. Chatter 게시물을 그만 보려면 opt out 한다. opt out 하면 게시물이 **내 피드**에는 나타나지 않으나 **연관 레코드의 피드**에는 나타난다.
1. 페이지 배너에서 profile 아바타를 클릭하고 **My Settings**(Classic) 또는 **Settings**(Lightning) 선택.
2. Quick Find에 `My Feeds` 입력 → **My Feeds** 선택.
3. **Receive approval requests as posts**를 해제한다. (org에 approvals가 활성일 때만 이 설정이 보인다.)
4. 저장.
- **USER PERMISSIONS** — To view an approval request post for a record: **Read on the record**
- **EDITIONS:** Salesforce Classic and Lightning Experience / Group, Professional, Enterprise, Performance, Unlimited, Developer, **and Contact Manager** Editions.

**What Happens When You Opt Out?** — org에 Approvals in Chatter가 활성일 때 기본으로 이메일·Chatter 알림을 받는다. Chatter 게시물을 opt out 하면:
- 내가 할당된 승인이 진행 중일 때 opt out 하면, **승인 레코드를 팔로우 중인 경우** 알림 게시물을 본다.
- 승인 레코드를 팔로우 중이면 그 레코드의 non-approver 콘텐츠 승인 게시물을 본다.
- 이미 받은 승인 알림 게시물에 대해서는 non-approver 콘텐츠를 본다.
- 내 피드의 기존 승인 게시물에서 **Approve·Reject 버튼이 제거된다.**

### 6.8 Record Locking (레코드 잠금)
> Record locking은 field-level security나 sharing 설정과 무관하게 사용자가 레코드를 편집하지 못하게 막는다. 기본적으로 Salesforce는 승인 대기 중인 레코드를 잠근다. **잠긴 레코드는 admin만 편집할 수 있다.**

---

## 관련 노트
- [[Approval Process (승인 프로세스)]] — 개요·용어(Terminology)·Setup 흐름·마법사(Jump Start/Standard)·자동화 액션. 이 노트의 companion(운영·엔드유저·레퍼런스 ↔ 개념·셋업)
- [[Approval Namespace]] — 프로그래밍 방식 승인(Apex `Approval.process()`), `ProcessInstanceWorkitem` 등 SOQL 대상 오브젝트의 코드 짝
- [[Outbound Messaging (아웃바운드 메시지) — SOAP 콜백·WSDL·리스너]] — 승인 액션의 Outbound Message가 외부 엔드포인트로 정보를 전송하는 방식
- [[Email Alerts, Templates & Auto-Response Rules (이메일 알림·템플릿·자동 응답)]] — 승인 단계·이메일 승인 응답에서 쓰는 email template·email alert
