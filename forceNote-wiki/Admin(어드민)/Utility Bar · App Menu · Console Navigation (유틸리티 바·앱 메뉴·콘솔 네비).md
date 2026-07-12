---
tags: [admin, ui-customization, lightning-apps, utility-bar, console, split-view, app-manager, navigation]
source: help.salesforce.com (Salesforce Help — Add a Utility Bar to Lightning Apps / Customize Your Lightning Console App with Utilities / How Are Console Apps Different from Standard Apps? / Salesforce Console in Lightning Experience / Personalize the Navigation Menu for Lightning Console Apps / Create Lightning Apps; 라이브 공식 문서, Tier 2, 접속 2026-07-12)
official_doc: https://help.salesforce.com/s/articleView?id=platform.apps_lightning_utilities.htm&type=5
created: 2026-07-12
aliases: [Utility Bar, 유틸리티 바, App Menu, 앱 메뉴, Console Navigation, 콘솔 네비게이션, Standard Navigation, Split View, 분할 보기, Workspace Tabs, Subtabs, Background Utility, Pop-Out]
---

# Utility Bar · App Menu · Console Navigation (유틸리티 바·앱 메뉴·콘솔 네비)

> Lightning App 설정에서 [[Lightning Apps & Tabs (라이트닝 앱·탭)]]가 공식 문서로 위임했던 세 부분을 심화한다 — **Utility Bar**(하단 고정 유틸리티 footer), **App Navigation**(Standard vs Console navigation), **Console Navigation & Split View**(workspace 탭·subtab·분할 보기). 모두 **Setup → App Manager**에서 앱을 편집해 구성한다.

> [!note] Setup 라벨 캐비엇 (2026-07-12)
> 아래 Setup UI 라벨(탭·버튼·필드명)은 접속일(2026-07-12) 기준 공식 문서 표기다. Salesforce는 릴리스마다 Setup UI 라벨을 바꿀 수 있으니, 현재 org 릴리스에서 실제 라벨을 확인한다.

---

## 1. Utility Bar (유틸리티 바)

**Utility bar**는 사용자에게 Notes·Recent Items 같은 상시 생산성 도구로의 빠른 접근을 주는 **특수한 유형의 Lightning page**다. 앱 화면 하단에 **고정 footer**로 나타나고, 클릭하면 유틸리티가 **docked panel(도킹 패널)**로 열린다. 일부 유틸리티는 **pop-out**을 지원해 새 브라우저 창으로 뜬다.

- 유틸리티는 **Lightning 컴포넌트**로 동작한다. 유틸리티 바를 설정할 때 어떤 Lightning 컴포넌트를 유틸리티로 쓸지 고른다.
- **Background utility item(백그라운드 유틸리티)**: 일반 유틸리티와 같은 방식으로 추가하지만, footer에 항목으로 노출되지 않는다. 유틸리티 바에 **백그라운드 유틸리티만** 있으면 유틸리티 바 자체가 앱에 나타나지 않는다 — 바가 보이려면 **non-background 유틸리티가 최소 1개** 필요하다.

### 설정 절차 (App Manager)

```
// 구조 예시 — Setup 경로(실제 동작 코드 아님)
Setup → Quick Find "App" → App Manager
  · 기존 앱: 앱 옆 드롭다운 → Edit
  · 새 앱:   New Lightning App
→ [Utility Items] 탭 → 원하는 유틸리티 추가
   각 유틸리티의 컴포넌트·유틸리티 속성 지정:
     - 유틸리티 패널의 height / width
     - 유틸리티 바에 표시할 label / icon
     (일부 유틸리티는 변경 불가한 속성이 있음)
```

- 유틸리티 바는 **언제든** 추가·편집할 수 있다.
- **Tip:** 한 Lightning page region에는 컴포넌트를 최대 **100개**까지 담을 수 있으나, 유틸리티는 **10개 이하**로, 라벨은 짧게 유지하기를 권장한다(사용자가 도구를 빨리 찾도록).

### 고려사항 (제약)

| 항목 | 내용 |
|---|---|
| 할당 범위 | **Lightning App Wizard / Lightning App Builder**로 만든 유틸리티 바는 **Lightning 앱 1개**에만 할당 가능. **API로 만든** 유틸리티 바는 **여러 앱**에 할당 가능. |
| Visualforce | 유틸리티 바는 **Visualforce 페이지·컴포넌트를 지원하지 않음** |
| Chatter | **Chatter Publisher·Feed 컴포넌트를 완전 지원하지 않음** |
| History 유틸리티 | **Lightning console 앱에서만** 동작 |
| Omni-Channel 유틸리티 | **Lightning Service Console 앱에서만** 동작 |
| Notes 유틸리티 | 노트를 만들면 docked panel이 열리고 작성 중 자동 저장. 패널이 열린 채 같은 노트를 다시 열면 중복 패널이 뜨므로, 한 패널에서 작성 후 닫고 다시 연다. |
| 정렬(alignment) | 기본 정렬은 사용자 언어 설정 방향을 따름. 영어(좌→우)에서 **Default** 선택 시 유틸리티 바가 화면 **좌측 하단**에, **Mirrored** 선택 시 **우측 하단**에 나타남. |

### 에디션·권한

- **에디션:** Lightning Experience — Contact Manager, Group, Professional, Enterprise, Performance, Unlimited, Developer.
- **권한:** 앱 보기 = *View Setup and Configuration*. 앱 관리 = *Modify All Data*(일반 Lightning 앱) 또는 *Customize Application*(Lightning console 앱 유틸리티 문서 기준).

---

## 2. App Navigation — Standard vs Console (앱 네비게이션 유형)

Lightning 앱은 두 가지 네비게이션 유형 중 하나로 만든다. 유형은 **New Lightning App 마법사의 App Options 페이지**에서 정한다.

| 유형 | 동작 |
|---|---|
| **Standard navigation** | 한 번에 **레코드 1개**만 연다 |
| **Console navigation** | 한 번에 **여러 레코드**를 열고, 관련 레코드는 원래 레코드 아래 **subtab**으로 열린다 |

- Lightning console 앱에서는 앱의 **네비게이션 규칙(navigation rules)**이 레코드가 열리는 방식을 결정한다. 관련 레코드를 **workspace 탭**으로 열지, 새 workspace 탭의 **subtab**으로 열지 구성할 수 있다. 예: contact 레코드를 그 contact이 속한 account의 subtab으로 열기.
- console 앱은 여러 레코드를 효율적으로 다루므로 빠른 처리 속도가 필요한 업무(콜센터·서비스 등)에 적합하다.
- **에디션:** Salesforce Classic·Lightning Experience — Essentials, Professional, Enterprise, Performance, Unlimited, Developer. **Lightning console 앱**은 특정 제품의 Salesforce Platform 사용자 라이선스에 대해 **추가 비용**이 들 수 있다(일부 제한 적용, 가격은 account executive 문의).

### App Manager 마법사 흐름 (요약)

```
// 구조 예시 — New Lightning App 마법사(실제 원본 UI 아님)
Setup → App Manager → New Lightning App
1) App Details & Branding : 이름·설명·기본 브랜딩 색·로고
2) App Options           : Standard navigation | Console navigation 선택
3) Utility Items         : 유틸리티 바 구성 (§1)
4) Navigation Items      : Available Items → Selected Items (CTRL/Cmd 다중 선택, 화살표로 이동)
5) User Profiles         : 앱을 볼 수 있는 프로파일 할당
```

> **App Menu / App Launcher 노출·정렬**(어떤 앱이 App Launcher에 보이고 어떤 순서인지)은 [[Salesforce 네비게이션]]의 App Launcher 절에 위임한다. 앱 가시성은 위 5) User Profiles(프로파일 할당)로 통제된다.

---

## 3. Console Navigation & Split View (콘솔 네비·분할 보기)

Console navigation 앱(예: Service Console·Sales Console)의 런타임 화면 구조. Lightning console 앱은 App Launcher로 연다.

```
// 구조 예시 — Lightning console 앱 UI(실제 원본 다이어그램 아님)
┌──────────────────────────────────────────────────────────┐
│ (1) App Launcher   [앱 이름]                                │
├──────────────┬───────────────────────────────────────────┤
│ (2) 네비게이션 │ (3) Workspace 탭  ├ subtab ├ subtab        │
│    메뉴        │      (여러 레코드 동시)                     │
│ (4) Split view │      레코드 상세 …                          │
│    패널(리스트) │                                            │
├──────────────┴───────────────────────────────────────────┤
│ (5) Utility Bar : History · Notes · (Omni-Channel 등)      │
└──────────────────────────────────────────────────────────┘
```

| # | 요소 | 동작 |
|---|---|---|
| 1 | **App Launcher** | 앱 간 전환. 다른 console 앱이나 standard 앱으로 이동. 현재 앱 이름이 App Launcher 옆에 표시됨. |
| 2 | **Navigation menu(네비게이션 메뉴)** | 현재 선택한 네비게이션 항목 표시. 열어서 항목 보기·편집. 항목 선택 시 그 항목의 home page가 열리고, **오브젝트는 table view**로 열림. |
| — | **Table view ↔ Split view 전환** | 레코드를 열면 화면이 **split view**로 바뀜. split view에서 네비게이션 항목을 다시 클릭하거나 **Display as** 드롭다운으로 table view로 되돌림. |
| 3 | **Workspace 탭 / Subtab** | 레코드는 **workspace 탭**으로 열리고, workspace 탭 안에서 연 관련 레코드는 **subtab**으로 열림. 탭 메뉴로 refresh·pin·customize·close. **Ctrl+click / Cmd+click**으로 네비게이션 항목을 새 workspace 탭에 열기. |
| 4 | **Split view 패널** | 리스트와 workspace 탭·subtab을 동시에 보여줌(한 화면에서 여러 케이스 처리). 아이콘으로 숨길 수 있음. split view 패널에서 연 레코드는 **새 workspace 탭**으로 열림. |
| 5 | **Utility Bar** | History·Notes 등 상시 프로세스·도구 접근(§1). |

> [!note] Classic 콘솔과의 패리티
> Lightning console 앱은 아직 Salesforce Classic console 앱과 **완전한 패리티가 없다** — 예: push notifications, custom keyboard shortcuts는 Lightning console 앱에서 제공되지 않는다. **Classic console 앱은 Setup에서 LEX로 업그레이드할 수 없다.** LEX에서 시작하려면 Salesforce 제공 **Service Console·Sales Console** 앱을 커스터마이즈한다.

### 네비게이션 메뉴 개인화 (엔드 유저)

console 앱 사용자는 네비게이션 메뉴를 자기 방식에 맞게 개인화할 수 있다(관리자가 개인화를 허용한 범위 내).

- 네비게이션 메뉴의 **연필 아이콘**을 클릭.
- 관리자가 앱의 **기본 항목**을 정한다. 사용자는 항목을 **추가**하고, **자신이 추가한** 항목만 재정렬·이름 변경·제거할 수 있다. **관리자가 지정한 기본 항목(커스텀·표준 오브젝트 포함)은 이름 변경·제거 불가.**
- **재정렬:** 항목을 드래그. **제거:** 추가한 항목 옆 **x** 클릭. **추가:** **Add More Items** → org의 모든 사용 가능 항목 검색 후 선택.

### Split view 리스트 표시 (Salesforce Classic 콘솔 캐비엇)

> Salesforce **Classic** 콘솔에서는 관리자가 리스트 표시 방식을 3가지 중 선택한다(*Customize Application* 권한). Lightning console의 table/split view 전환과는 별개다.

| 유형(Classic) | 동작 |
|---|---|
| **Full screen, unpinned** | 네비게이션 탭을 선택했을 때만 리스트가 보임. 리스트에서 레코드 선택 시 새 탭으로 열림. |
| **Pinned to top** | 리스트가 페이지 상단에 항상 표시. 레코드 선택 시 리스트 아래 새 탭으로 열림. |
| **Pinned to left** | 리스트가 페이지 좌측에 항상 표시. 레코드 선택 시 리스트 오른쪽 새 탭으로 열림. |

---

## 관련 노트

- [[Lightning Apps & Tabs (라이트닝 앱·탭)]] — 이 노트가 심화하는 상위 개요(앱·탭·유틸리티 바 위임 지점)
- [[Service Console (서비스 콘솔)]] — Service Cloud 관점의 console 앱(Macros·Omni-Channel·Softphone 유틸리티)
- [[Salesforce 네비게이션]] — App Launcher·전역 검색·리스트뷰·레코드 페이지(App Menu 노출)
- [[Lightning App Builder & Pages (라이트닝 앱 빌더·페이지)]] — 앱 안 페이지·유틸리티 바 편집
- [[Macros (매크로)]] — console utility bar 도구
- [[Open CTI & Telephony (전화 통합)]] — Open CTI Softphone utility bar 컴포넌트
