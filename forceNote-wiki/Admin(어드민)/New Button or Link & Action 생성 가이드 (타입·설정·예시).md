---
tags: [admin, ui-customization, custom-buttons, custom-links, quick-actions, action-types]
source: help.salesforce.com (Custom Button and Link Fields / Edit Window Open Properties / Action Types / Quick Actions; 라이브 공식 문서, Tier 2, 접속 2026-07-04)
official_doc: https://help.salesforce.com/s/articleView?id=platform.defining_custom_links_fields.htm&type=5
created: 2026-07-04
aliases: [New Button or Link, 버튼 링크 생성, Display Type, Content Source, Behavior, Window Open Properties, Action Type, 액션 타입, Create a Record, Log a Call, merge field 버튼]
---

# New Button or Link & Action 생성 가이드 (타입·설정·예시)

> Object Manager의 **Buttons, Links, and Actions**에서 커스텀 버튼·링크·액션을 만들 때 타입·설정·예시를 전수 정리한 생성 심화 가이드. 개요는 [[Custom Buttons & Links (커스텀 버튼·링크)]]·[[Quick Actions & Global Actions (퀵 액션·글로벌 액션)]] 참조.

**진입점:** Object Manager → (오브젝트) → **Buttons, Links, and Actions**
**Editions:** 커스텀 버튼/링크 = Salesforce Classic, 전 에디션. Visualforce/s-controls 기반 = Contact Manager·Group·Professional·Enterprise·Performance·Unlimited·Developer.

---

## Part 1 — New Button or Link (커스텀 버튼·링크 생성)

> "Custom buttons and links define the action that occurs when a user clicks them." — Salesforce 내 동작을 간소화하거나 Salesforce 데이터를 외부 URL·앱·시스템과 통합한다.

### 필드 전수 (Custom Button and Link Fields)

| 필드 | 설명 |
|---|---|
| **Label** | UI에 표시되는 텍스트. |
| **Name** | API에서 참조할 고유 이름(자동 생성 또는 입력). |
| **Namespace Prefix** | 패키지를 고유 식별하는 접두(패키징 org). |
| **Protected Component** | 구독자 org에서 사용 제한(선택). Protected component는 다른 패키지 컴포넌트가 링크·참조할 수 없다. |
| **Description** | 다른 버튼·링크와 구분하는 설명 텍스트. |
| **Display Type** | 페이지 레이아웃에서 버튼/링크가 나타나는 위치(아래 3종). |
| **Behavior** | 클릭 시 결과(창 열림 방식, 아래). |
| **Content Source** | URL / s-control / JavaScript action(OnClick JavaScript, 레거시) / Visualforce 중 선택. |
| **Content** | URL·링크 유형의 콘텐츠(merge field·operator·function 삽입). |
| **Link Encoding** | 인코딩. 기본 **Unicode (UTF-8)**. |

### Display Type (3종) — 버튼/링크가 나타나는 위치

- **Detail Page Link** — 레코드 상세 페이지의 **Custom Links 섹션**에 링크를 추가한다.
- **Detail Page Button** — 레코드 상세 페이지에 버튼을 추가한다.
- **List Button** — list view·search result layout·related list에 버튼을 추가한다. **"Display Checkboxes (for Multi-Record Selection)"** 옵션을 켜면 다중 레코드 선택이 가능해져 mass action으로 동작한다.

### Behavior (창 열림 방식)

문서화된 옵션:

- Display in existing window without sidebar or header
- Display in existing window with sidebar
- Display in existing window without sidebar
- **Display in new window** — Window Open Properties 적용 가능
- Display in sidebar
- **Execute JavaScript** — ⚠️ Content Source가 **OnClick JavaScript**일 때만 표시된다.

> ⚠️ **일부 behavior는 변경 불가:**
> ① URL로 Visualforce 페이지를 링크하는 커스텀 버튼은 강제로 **Display in new window**로 설정된다.
> ② Experience Builder 사이트에서 커스텀 버튼 링크는 "Display in existing window" 설정이어도 **새 탭**에서 열린다.

### Content Source (4종)

- **URL** — 외부 URL·인트라넷·상대 경로. 저장 시 Salesforce가 URL의 정확성을 검증한다. 허용 프로토콜: `http://`, `https://`, `file://`, `ftp://`, `mailto://`.
- **Visualforce Page** — 커스텀 페이지/코드를 실행한다. Experience Builder 사이트에서도 동작(클릭 시 연결된 VF 페이지 표시).
- **JavaScript (OnClick JavaScript)** — ⚠️ **레거시**. Lightning Experience 미지원, Salesforce Classic 전용. Execute JavaScript behavior와 함께 사용한다.
- **s-control** — ⚠️ 레거시(사실상 은퇴).

> 💡 **의존 관계:** Content Source가 Behavior 옵션을 제약한다. `Execute JavaScript` behavior는 Content Source가 `OnClick JavaScript`일 때만 나타나고, URL로 VF 페이지를 링크하면 behavior가 `Display in new window`로 강제된다.

### Content — merge field · operator · function

URL/링크 유형에서 Content 필드에 삽입한다:

- **Merge field**: `{!Object.Field}` 토큰으로 레코드 값을 삽입한다. Select Field Type에서 필드를 선택. Activity merge field는 Event / Task 중 선택.
- **Operator**: Insert Operator에서 삽입.
- **Function**: Functions 목록에서 더블클릭하거나 Insert Selected Function.

**⚠️ URL 인코딩:** 인터넷 표준상 특수 인코딩이 필요하며, Salesforce가 merge field 값을 자동 인코딩한다.

```text
// 구조 예시 — URL 버튼 콘텐츠(실제 동작 코드 아님)

// 예시 1: 공백 → +, 퍼센트(%) → %25 자동 인코딩
입력한 URL:
  http://www.google.com/search?q={!user.name} Steve Mark 50%
Salesforce가 사용하는 URL:
  http://www.google.com/search?q={!user.name}+Steve+Mark+50%25

// 예시 2: Content Source가 URL이면 큰따옴표(") 제거 후 %22로 인코딩
입력한 URL:
  ...?q="salesforce foundation"
Salesforce가 사용하는 URL:
  ...?q=%22salesforce+foundation%22

// 예시 3: Yahoo 검색 (merge field 사용)
  http://search.yahoo.com/bin/search?p={!Account_Name}
```

- 공백 → `+`, `%` → `%25`로 자동 변환된다.
- Content Source가 URL이면 Salesforce가 URL의 **큰따옴표를 제거**한 뒤 `%22`로 인코딩한다.

### Window Open Properties (Behavior = Display in new window일 때)

버튼/링크 편집 화면에서 **Window Open Properties**를 클릭한다. 필요 권한: **Customize Application**.

| 속성 | 설명 |
|---|---|
| **Width** | 창 너비(픽셀). |
| **Height** | 창 높이(픽셀). |
| **Window Position** | 창이 열릴 화면 위치. |
| **Resizeable** | 사용자가 창 크기를 조정하도록 허용. |
| **Show Address Bar** | URL이 담긴 주소 표시줄 표시. |
| **Show Scrollbars** | 스크롤바 표시. |
| **Show Toolbars** | 도구 모음(Back/Forward 등) 표시. |
| **Show Menu Bar** | 메뉴(File/Edit 등) 표시. |
| **Show Status Bar** | 하단 상태 표시줄 표시. |

> ⚠️ behavior에 따라 일부 속성이 제공되지 않는다(예: Execute JavaScript).

### 페이지 레이아웃 배치 (자동 노출 안 됨)

생성한 버튼/링크는 자동으로 노출되지 않는다.

- **Detail Page Button / Link** → **page layout**의 Custom Buttons / Custom Links 섹션에 추가해야 표시된다.
- **List Button** → **List View Button Layout**·related list에 추가해야 표시된다.

> 배치 위치는 [[Page Layouts (페이지 레이아웃)]] 참조.

---

## Part 2 — Actions (액션)

> 어떤 액션이 사용 가능한지는 org의 나이·구성에 따라 다르다.

> ⚠️ **Summer '26부터 신규 org는 Chatter가 기본 OFF.** Standard Chatter Actions 등 Chatter가 필요한 기능은 Setup → Chatter Settings → Enable로 켜야 사용할 수 있다.

### Action 카테고리 (Action Types) — 6종

- **Standard Chatter Actions** — Post·Poll·Question·Announcements(그룹 전용). Chatter가 활성화된 경우에만 제공.
- **Default Actions** — 시작용으로 사전 정의된 액션 세트.
- **Mobile Smart Actions** — 사전 구성된 quick action 세트(account·case·contact·lead·opportunity).
- **Productivity Actions** — 사전 정의되어 제한된 오브젝트에 부착된다(Send Email·Log a Call 등). ⚠️ **편집·삭제 불가.**
- **Quick Actions** — object-specific + global(아래 유형 참조).
- **Mass Quick Actions** — list view/related list에서 **최대 100 레코드**를 생성·업데이트.

표시 위치: Lightning Experience(Global Actions 메뉴·related list·record page), Salesforce Mobile App Action Bar.

### Quick Action 유형 (action type 드롭다운)

| Action Type | 설명 | 범위 |
|---|---|---|
| **Create a Record** | 레코드 생성(New Contact·New Opportunity·New Lead 등). | object-specific 또는 global |
| **Update a Record** | 레코드 수정. | ⚠️ **반드시 object-specific** (global 불가) |
| **Log a Call** | 통화·상호작용 기록. 완료된 task로 저장. | object-specific 또는 global |
| **Custom (Lightning / Flow / Visualforce / Canvas)** | 사용자 정의 기능 호출(Lightning 컴포넌트·flow·Visualforce 페이지·canvas 앱). | object-specific 또는 global |
| **Send Email** | ⚠️ **case 전용** object-specific. Salesforce 모바일 앱의 간소화된 Case Feed Email 액션. | object-specific(case) |

> 그 외 Send Notification 등 기능별 액션 타입이 org 구성에 따라 나타날 수 있다.

### Object-specific vs Global

- **Object-specific actions** — 특정 오브젝트 레코드 컨텍스트에서 동작하며, 관련 레코드와 **자동으로 관계**가 맺어진다. 해당 object의 page layout에 추가한다.
- **Global actions** — 컨텍스트(현재 레코드)와 무관하게 어디서나 배치 가능. 레코드 생성·통화 로그·이메일을 페이지 이탈 없이 수행. **Global Publisher Layout**에 추가한다.

> 💡 **의존 관계 (범위 규약):**
> - **Create a Record / Log a Call / Custom** = object-specific 또는 global 둘 다 가능.
> - **Update a Record** = object-specific만 (global로 만들 수 없다).

### 예시 (how-to)

- **Create 액션** — Case object → (New Button or Link가 아니라) **Actions → New Action → Action Type = Create a Record, Target Object = Task** → layout 지정 → page layout에 추가.
- **Custom(Flow) 액션** — Action Type = Custom → Lightning Component 또는 Flow 선택. 호출되는 Flow는 [[Flow — 선언적 자동화 개요 (플로우)]] 참조.
- **Log a Call** — Action Type = Log a Call → 완료된 task로 저장.

### 버튼/링크 vs Quick Action (구분)

- 커스텀 **버튼/링크**(Part 1) = 주로 Salesforce Classic·URL/VF 통합·목록 버튼.
- **Quick Action**(Part 2) = Lightning·모바일·publisher/action bar.
- 현대 Lightning UI에서는 Quick Action이 권장되며, JavaScript 버튼은 Quick Action/Flow로 대체한다.

---

## 관련 노트
- [[Custom Buttons & Links (커스텀 버튼·링크)]] — 버튼·링크 개요(이 노트는 생성 심화).
- [[Quick Actions & Global Actions (퀵 액션·글로벌 액션)]] — 액션 개요.
- [[Page Layouts (페이지 레이아웃)]] — 버튼·액션 배치.
- [[Flow — 선언적 자동화 개요 (플로우)]] — Custom 액션이 호출하는 Flow.
