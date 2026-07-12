---
tags: [admin, setup, user-interface, ui-settings, org-settings, 사용자인터페이스, 어드민]
source: help.salesforce.com/s/articleView?id=xcloud.customize_ui_settings.htm (Tier 2, 확인 2026-07-12)
created: 2026-07-12
aliases: [User Interface Settings, UI Settings, 사용자 인터페이스 설정, Inline Editing, Collapsible Sections, Enhanced Lists, Hover Details, 인라인 편집, 왜 인라인 편집이 안 되나]
---

# User Interface Settings (사용자 인터페이스 설정)

> Setup의 **User Interface** 페이지 — org 전역으로 UI 동작(인라인 편집·호버 상세·향상된 리스트·섹션 접기 등)을 켜고 끄는 단일 토글 페이지. "왜 이 UI 기능이 안 되나"의 첫 진입점.

---

## 개념 — org 전역 UI 동작 제어

`Setup` → 빠른 찾기(Quick Find)에서 **User Interface** 입력 → **User Interface** 페이지. 여기서 체크박스 하나를 켜고 끄면 **org 전체 모든 사용자**의 UI 동작이 바뀐다(프로필/사용자 단위가 아니라 org 전역). 인라인 편집·리스트뷰 편집·호버 오버레이·레코드 상세 페이지의 섹션 접기 같은 "당연히 되어야 할 것 같은" 동작이 실제로는 이 페이지의 토글에 좌우된다.

실무에서 "인라인 편집이 안 된다", "리스트에서 바로 수정이 안 된다", "관련 목록 호버 링크가 안 보인다" 같은 증상은 대부분 이 페이지에서 해당 토글이 꺼져 있거나(또는 Lightning의 Dynamic Forms 같은 상위 기능이 우선권을 가져) 발생한다.

```text
// 구조 예시 — 실제 원본 UI 스크린샷 아님 (Setup 탐색 경로)
Setup
 └─ Quick Find: "User Interface"
     └─ User Interface  (User Interface Settings 페이지)
         ├─ ☑ Enable Collapsible Sections
         ├─ ☑ Enable Hover Details
         ├─ ☑ Enable Related List Hover Links
         ├─ ☑ Enable Inline Editing
         ├─ ☑ Enable Enhanced Lists
         └─ … (아래 표의 나머지 토글)
```

> [!note] Setup 라벨 캐비엇 (2026-07-12)
> Salesforce는 릴리스마다 Setup UI 라벨·그룹핑을 바꾼다. 아래는 공식 Help 문서(`xcloud.customize_ui_settings.htm`)의 **SETTING/DESCRIPTION 표**를 그대로 반영한 것이다. 실제 org 화면에서는 에디션·릴리스·활성화된 기능(예: Dynamic Forms, SLDS 2)에 따라 일부 토글이 숨겨지거나 라벨/기본값이 다를 수 있다.

---

## 주요 토글 — 효과·기본값 (공식 확인 항목)

| 토글 (SETTING) | 효과 | 기본값·범위 |
|---|---|---|
| **Enable Collapsible Sections** | 사용자가 레코드 상세 페이지의 섹션을 헤딩 옆 화살표로 접기/펼치기. 탭별로 상태 유지, 레코드 타입별 별도 기억. **Dynamic Forms가 켜진 Lightning 레코드 페이지에는 적용 안 됨** — Dynamic Forms의 접기/펼치기가 우선. Salesforce Classic 및 Record Detail 컴포넌트를 쓰는 Lightning 페이지에만 적용 | (기본값 명시 없음) |
| **Show Quick Create** | 탭 홈 페이지에서 최소 정보로 레코드를 빠르게 생성하는 Quick Create 영역. 기본적으로 lead·account·contact·opportunity 탭 홈에 표시. 룩업 다이얼로그 내 레코드 생성 가능 여부도 좌우. 사용은 항상 해당 "Create" 권한 필요 | lead/account/contact/opportunity 탭 홈에 기본 표시 |
| **Enable Hover Details** | 최근 항목(사이드바)·룩업 필드의 레코드 링크에 마우스 오버 시, 레코드 세부를 담은 인터랙티브 오버레이 표시. 표시 필드는 **미니 페이지 레이아웃**이 결정(사용자 커스텀 불가). 공유·FLS 접근 권한이 있어야 필드가 보임 | **기본 활성화** |
| **Enable Related List Hover Links** | 레코드 상세·커스텀 오브젝트 상세 페이지 상단에 관련 목록 호버 링크 표시. 호버로 목록·레코드 수를 오버레이로 보고, 클릭 시 해당 관련 목록으로 점프 | **기본 활성화** |
| **Enable Separate Loading of Related Lists** | 주 레코드 상세를 먼저 보여주고 관련 목록은 진행 표시기와 함께 지연 로딩 → 관련 목록이 많은 org의 상세 페이지 성능 개선. **Salesforce Classic에만 적용**. Visualforce·Self-Service 포털 등 레이아웃 제어 불가 페이지엔 미적용 | **기본 비활성화**, Classic 전용 |
| **Enable Separate Loading of Related Lists of External Objects** | 외부 오브젝트 관련 목록을 주 레코드 상세 및 표준/커스텀 오브젝트 관련 목록과 분리 로딩. 외부 시스템 지연·가용성 때문에 유용. **Salesforce Classic에만 적용** | **기본 활성화**, Classic 전용 |
| **Enable Inline Editing** | 레코드 상세 페이지에서 필드 값을 인라인으로 즉시 편집. org의 모든 사용자에 적용 | **기본 활성화** |
| **Enable Enhanced Lists** | 리스트 데이터를 빠르게 보기·커스터마이즈·편집. **Enable Inline Editing과 함께 켜면** 리스트에서 페이지 이탈 없이 레코드 직접 편집 가능. (프로필 리스트뷰는 User Management Settings의 Enhanced Profile List Views로 별도 활성화) | **기본 활성화** |
| **Enable the Salesforce Classic 2010 User Interface Theme** | Lightning과 무관. 켜면 최신 Salesforce Classic(2010) 룩앤필, 끄면 2005 클래식 테마. **Chatter 등 일부 기능은 2010 테마 필요** — 끄면 Classic·Lightning 양쪽에서 Chatter 자동 비활성화. 지원 브라우저 사용자만 Classic 표시. 포털·Console 탭 미지원 | — |
| **Disable Navigation Bar Personalization in Lightning Experience** | 켜면 사용자가 모든 앱의 네비게이션 바 항목을 추가·재정렬 불가. (단 Salesforce 권장은 App Manager → App Options에서 앱별로 비활성화). **Lightning Experience 전용** | — |
| **Clear Workspace Tabs for Each New Console Session** | 켜면 새 콘솔 세션에서 이전 워크스페이스 탭을 불러오지 않음. (App Manager → 콘솔 앱 → App Options에서도 설정). 브라우저 새로고침 시엔 탭 복원됨(Safari 제외). **Lightning Experience 전용** | **기본 비활성화**, LEX 전용 |
| **Enable Tab Bar Organizer** | 메인 탭 바에서 탭을 정렬해 가로 스크롤 방지. 브라우저 폭에 따라 표시 탭 수를 동적 결정, 초과분은 드롭다운. partner/Customer Portal 미지원. **Salesforce Classic 전용** (2010 테마도 켜야 사용자에게 노출). IE6 미지원 | Classic 전용 |
| **Enable Printable List Views** | 리스트 뷰의 **Printable View** 링크 제공 → 인쇄용 포맷의 새 창. 링크는 제목 바의 "Help for this Page" 옆 | — |
| **Enable sort by multiple columns in List Views** | 켜면 리스트 뷰를 한 번에 최대 **5개 컬럼**으로 정렬 | — |
| **Enable sort by multiple columns in Related Lists** | 켜면 관련 목록을 한 번에 최대 **5개 컬럼**으로 정렬 | — |
| **Shared List view editing** | 켜면 "Create and Customize List Views" 권한 사용자가 자신에게 공유된 리스트 뷰를 편집. 끄면 공유받은 리스트 뷰는 보기 전용 | — |
| **Enable Spell Checker on Tasks and Events** | 태스크·이벤트 생성/편집 시 Check Spelling 버튼 활성화. 이벤트의 Description, 태스크의 Comments 필드를 검사. 전 에디션 사용 가능 | — |
| **Enable Customization of Chatter User Profile Pages** | 관리자가 Chatter 사용자 프로필 페이지의 탭을 커스터마이즈(커스텀 탭 추가·기본 탭 제거). 끄면 사용자는 Feed·Overview 탭만 표시 | — |
| **Change Default Display Density Setting in Lightning Experience** | 표시 밀도(필드 라벨 정렬·요소 간 여백)의 org 기본값을 Density Settings 페이지에서 결정. 사용자는 언제든 자기 밀도 선택 가능(관리자가 덮어쓰기 불가). **Comfy**=라벨 위·여백 넓음, **Compact**=라벨 왼쪽·여백 좁음. SLDS 2 활성화 시 영향 상이. Lightning Experience 전용(Classic·Experience Builder·모바일 무관) | 에디션별 org 기본값 상이 |
| **Disable Lightning Experience Transition Admin Reminders** | 켜면 Classic에서 작업하는 관리자(Modify All Data + Customize Application 권한)에게 45일마다 뜨는 Lightning 전환 카운트다운 리마인더·권장 작업이 표시되지 않음 | — |
| **Enable ICU formats for en_CA locale** | ICU 언어·로케일 포맷을 critical update로 활성화한 뒤, 이 설정으로 English (Canada) 로케일에도 ICU 포맷 적용 | — |
| **Disable Google Chrome Storage Partitioning for Salesforce Domains** | 켜면 Chrome 111~126 사용자에 대해 2024-09-03까지 Salesforce 도메인이 서드파티 컨텍스트에서 비분할 스토리지 사용(이후엔 설정 무관하게 Google 분할 적용). Chrome 127 업그레이드 주의 | **기본 비활성화**(신규·기존 org) |

> **범위 요약:** 대다수 토글은 org 전역·모든 사용자 적용. "Salesforce Classic 전용"(Separate Loading of Related Lists, Tab Bar Organizer, 2010 Theme)과 "Lightning Experience 전용"(Nav Bar Personalization, Clear Workspace Tabs, Display Density, Transition Reminders)은 인터페이스에 따라 효과가 갈리므로 증상 진단 시 어느 UI에서 발생했는지 먼저 확인한다.

---

## "왜 인라인 편집이 안 되나"류 진단 관점

| 증상 | 확인할 토글 / 원인 |
|---|---|
| 레코드 상세에서 필드 인라인 편집이 안 됨 | **Enable Inline Editing**(기본 ON) 꺼져 있는지. 개별 필드는 FLS/편집 권한도 필요 |
| 리스트에서 바로 수정이 안 됨 | **Enable Enhanced Lists** + **Enable Inline Editing** 둘 다 ON이어야 리스트 인라인 편집 가능 |
| 관련 목록 호버 링크가 안 보임 | **Enable Related List Hover Links**(기본 ON) 확인 |
| 최근 항목/룩업에서 호버 상세가 안 뜸 | **Enable Hover Details**(기본 ON). 표시 필드는 미니 페이지 레이아웃 + 공유·FLS 접근 |
| 섹션 접기 화살표가 안 보임 | **Enable Collapsible Sections**. 단 **Dynamic Forms 켜진 Lightning 페이지에선 무효**(Dynamic Forms가 우선) |
| 리스트/관련 목록 다중 컬럼 정렬이 안 됨 | **Enable sort by multiple columns in List Views / Related Lists** (최대 5컬럼) |
| 공유받은 리스트 뷰를 못 고침 | **Shared List view editing** OFF → 보기 전용 |
| Chatter가 갑자기 사라짐 | **Salesforce Classic 2010 User Interface Theme** 껐는지 — 끄면 Chatter 자동 비활성화 |

---

## 확인 못 한 항목 (이 문서에 없어 생략)

아래는 초기 요청에 있었으나 공식 `customize_ui_settings.htm` 표에서 **확인되지 않아** 이 노트에서 제외했다(별도 Setup 페이지이거나 라벨이 다를 수 있음): **Enable Enhanced Page Layout Editor**, **Enable Drag-and-Drop Scheduling**, 일반 **Enable Quick Create**(실제 라벨은 *Show Quick Create*), 일반 **Enable Spell Checker**(실제 라벨은 *Enable Spell Checker on Tasks and Events*). 또한 이 문서는 토글을 **Sidebar·Calendar·Setup·Advanced 하위 섹션으로 그룹핑하지 않고 단일 표**로 제시한다 — 섹션 그룹핑은 공식 근거를 확인하지 못해 매핑하지 않았다.

---

## 관련 노트
- [[Page Layouts (페이지 레이아웃)]] — Collapsible Sections·Hover Details의 표시 필드(미니 페이지 레이아웃)를 결정
- [[List Views (리스트 뷰)]] — Enhanced Lists·다중 컬럼 정렬·Shared List view editing이 좌우하는 리스트 동작
