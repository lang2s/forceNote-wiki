---
tags: [admin, ui-customization, search, search-layouts, lookups, global-search]
source: help.salesforce.com (Configure Search Settings in Salesforce Classic / Edit Your Search Layout / Search Layout Guidelines / Search Layout Features — 라이브 공식 문서, Tier 2, 접속 2026-07-12)
created: 2026-07-12
aliases: [Search Settings, Search Layouts, 검색 설정, 검색 레이아웃, Enhanced Lookups, Lookup Dialogs, Global Search, 글로벌 검색, 조회 대화상자, 검색 결과 열]
---

# Search Settings & Search Layouts (검색 설정·검색 레이아웃)

> **Search Settings**(Setup)은 org 전역 검색 동작(향상된 조회·자동완성·사이드바 검색·오브젝트별 결과 개수)을 켜고, **Search Layouts**(Object Manager → 오브젝트 → Search Layouts)는 검색 결과·조회 대화상자·리스트 뷰에 **어떤 열·필터·버튼**이 표시되는지를 오브젝트 단위로 제어한다.

---

## 개념

Salesforce 검색은 두 축으로 커스터마이즈한다.

| 축 | 위치 | 제어 대상 | 범위 |
|---|---|---|---|
| **Search Settings** | Setup → Quick Find `Search Settings` | 검색 *동작*: 향상된 조회, 조회 자동완성, 사이드바 검색 옵션, 오브젝트별 표시 결과 개수 | org 전역 |
| **Search Layouts** | Setup → Object Manager → 오브젝트 → **Search Layouts** | 검색 결과·조회 대화상자·리스트 뷰의 *표시 열·필터·버튼* | 오브젝트 단위 |

> Setup 라벨은 릴리스·에디션에 따라 위치가 다를 수 있다(2026-07-12 확인 기준). Lightning Experience와 Salesforce Classic에서 적용 방식이 갈리는 항목이 많으므로 아래 각 섹션의 캐비엇을 확인한다.

---

## Search Settings (Setup)

Setup의 Quick Find에 `Search Settings`를 입력해 연다. 공식 문서(Configure Search Settings)가 나열하는 설정은 다음과 같다.

### 사이드바·전역 검색 옵션

| 설정 | 동작 |
|---|---|
| **Enable "Limit to Items I Own" Search Checkbox** | 사용자가 사이드바 검색 결과를 **자신이 소유한 레코드**로만 좁힐 수 있게 한다. (이 옵션은 설정과 무관하게 advanced search에서는 항상 제공된다.) |
| **Enable Document Content Search** | 문서를 업로드·업데이트할 때 문서 **본문 전체 텍스트 검색**을 허용한다. |
| **Enable Search Optimization if your Content is Mostly in Japanese, Chinese, or Korean** | 검색 대상 필드의 콘텐츠가 주로 **CJKT**(일·중·한·태국어)일 때 사이드바·전역 검색을 최적화한다. |
| **Enable English-Only Spell Correction for Knowledge Search** | Knowledge 아티클·Article 탭·Case Feed 도구에서 **영어 철자 교정**을 활성화한다. |
| **Enable Drop-Down List for Sidebar Search** | 사이드바 검색에 **드롭다운**을 표시해 태그·특정 오브젝트·전체 오브젝트 중에서 검색 대상을 고르게 한다. |
| **Enable Sidebar Search Auto-Complete** | 사용자가 입력하는 동안 **최근 조회한 일치 레코드**를 자동완성으로 보여준다. |
| **Enable Single-Search-Result Shortcut for Sidebar and Advanced Search** | 결과가 **단 하나**일 때 레코드 상세 페이지로 바로 이동시킨다. |

### 조회(Lookup) 관련

| 설정 | 동작 |
|---|---|
| **Use Recently Viewed User Records for Blank and Auto-Complete Lookups** | 사용자 조회를 org 전체 접근이 아니라 **최근 조회 레코드** 기반으로 채운다. 검색 혼잡을 막기 위해 **200개 레코드**에서 멈춘다. |
| **Lookup Settings**(구성 섹션) | 조회가 가능한 오브젝트에 대한 **Enhanced Lookups**(향상된 조회)·**Lookup Auto-Completion**(조회 자동완성)을 관리한다. |

- **Enhanced Lookups**: Salesforce Classic에서 조회 결과를 **정렬·필터·페이지 이동**할 수 있게 한다.
- **Lookup Auto-Completion**: 조회 필드 편집 시, 일치하며 **최근 사용한 레코드**의 동적 목록에서 항목을 고르게 한다. Account·Contact·User·Opportunity·custom object 조회에 지원된다.

### 오브젝트별 결과 개수

| 구성 섹션 | 동작 |
|---|---|
| **Number of Search Results Displayed Per Object** | 결과 페이지에서 **오브젝트당 표시할 항목 수**를 제어한다. |

---

## Search Layouts (Object Manager)

**Setup → Object Manager → 오브젝트 선택 → Search Layouts**에서 그 오브젝트의 검색 레이아웃을 편집한다. 각 항목의 드롭다운에서 **Edit**를 선택한다.

### 검색 레이아웃 유형

| 유형 | 제어 대상 |
|---|---|
| **Search Results** | **전역 검색·조회 검색** 결과에 표시되는 열(필드). |
| **Lookup Dialog(s)** | 조회 대화상자에서 사용자가 결과를 **필터**하는 데 쓰는 필드 / 표시 필드. |
| **Lookup Phone Dialogs** | (Salesforce Classic) **전화번호 조회 대화상자**의 표시 필드. |
| **Search Filter Fields** | 검색 결과 페이지에서 **필터 가능한 필드**. |
| **List View** | 리스트 뷰에 표시되는 **버튼**(List View 버튼 옵션). |
| **Tab (오브젝트 탭)** | 표준/커스텀 오브젝트 탭의 **Recently Viewed(최근 조회 레코드)**에 표시되는 필드. |

> ⚠️ Lookup Dialog·Tab·List View·Filter Fields를 수정하는 기능이 **모든 표준 오브젝트에 있는 것은 아니다.** Activity·Service Contracts·Pricebook Entry 등 일부 오브젝트는 검색 레이아웃 구성 옵션이 제한된다.

### 편집 방법 (열 추가·순서)

1. Setup → **Object Manager** → 오브젝트 → **Search Layouts** → 항목 드롭다운에서 **Edit**.
2. **Available Fields ↔ Selected Fields** 사이로 필드를 이동해 열 머리글을 추가·제거한다.
3. **Up/Down**으로 순서를 바꾼다. **SHIFT+click**(연속 선택)·**CTRL+click**(개별 선택)으로 다중 선택.

### 제한·가이드라인 (Search Layout Guidelines)

- 각 검색 레이아웃에는 **필드 최대 10개**까지 추가할 수 있다.
- **모바일 앱(iOS·Android)**에서는 **처음 6개 필드**만 표시된다.
- 텍스트형 **Name 필드**를 가진 커스텀 오브젝트는 Name 필드가 **필수**이며 항상 **첫 번째 열**로 표시된다. Name이 autonumber 유형이 아니면 제거할 수 없다.
- **default layout은 Lightning Experience와 Salesforce Classic 검색 결과 페이지 모두에 적용**된다. 사용자는 자신의 프로필에 구성된 레이아웃을 본다.
- 검색 레이아웃이 결정하는 것: 인스턴트 결과의 **보조 필드**, 레코드 미리보기 콘텐츠, 사용자가 **정렬**할 수 있는 필드, 추천 결과 필드(Account·Contact·Case·Group·Lead·Opportunity·Person Account·User), 검색 결과 페이지의 **열**, 필터 가능한 필드.
- **버튼 캐비엇:** 표준·커스텀 **버튼은 Lightning Experience 검색 레이아웃에 표시되지 않는다**(Classic에서만 노출).
- **Override 캐비엇:** Salesforce Classic에서 오브젝트의 default layout을 편집할 때 **"Override the search result column customizations for all users"**를 선택하면 모든 사용자 커스터마이징을 org 전역 기본값으로 되돌린다. 이 기능은 **Salesforce Lightning에는 적용되지 않는다.**

```
// 구조 예시 — 실제 동작 코드 아님
Object Manager → Account → Search Layouts
├── Search Results        → 전역/조회 검색 결과 열 (최대 10, 모바일 첫 6)
├── Lookup Dialogs        → 조회 대화상자 표시·필터 필드
├── Lookup Phone Dialogs  → (Classic) 전화 조회 대화상자
├── Search Filter Fields  → 결과 페이지 필터 필드
├── List View             → 리스트 뷰 버튼
└── Tab                   → 탭 Recently Viewed 필드
```

---

## Global Search 동작

- Lightning Experience에서는 페이지 상단의 **global search** 바로 레코드를 찾고, 결과를 **필터·정렬**하며, 레코드 미리보기와 관련 quick link를 훑어 빠르게 찾는다.
- **인스턴트 결과·개인화:** global search 바에 커서를 두면 **최근 활동 기반**의 추천 검색·레코드 미리보기가 뜬다. 개인화는 사용자가 가장 자주 다루는 오브젝트·레코드 순으로 결과를 재정렬하는 AI 기능이다.
- **Recommended Result:** 검색어에 여러 결과가 일치하면, Einstein Search 또는 사용자의 클릭 가능성에 근거해 **가장 관련성 높은 레코드**를 추천한다.
- **검색 대상 오브젝트:** 검색어를 입력하면 검색 가능한 오브젝트를 찾을 수 있고, **프로필별로** 전역 검색과 Experience Cloud 구성에서 검색 대상 오브젝트를 관리할 수 있다.
- **Einstein Search(간단히):** Personalization·Recommended Results·Einstein Search Answers 등은 Einstein Search 계층의 AI 기능이다. 세부 설정은 Setup의 Einstein Search 구성 항목에서 관리한다(본 노트 범위 밖).

---

## 관련 노트
- [[List Views (리스트 뷰)]]
- [[Page Layouts (페이지 레이아웃)]]
