---
tags: [index, lwc, base-component, reference, slds]
created: 2026-06-13
---

# BaseComponents(베이스컴포넌트) — 로컬 인덱스

> Lightning Base Component 각 컴포넌트의 상세 레퍼런스. 속성·이벤트·코드 예시·접근성·전체 공식 명세 포함.
> **SLDS 2 / @salesforce-ux/design-system v2.30.4 기준.** 신규 항목은 공식 cx-router 메타데이터(Tier 2).

**상위:** [[LWC MOC]] → [[00 Home]]
**빠른 선택 (카테고리 목록):** [[Lightning Base Components 레퍼런스]]

---

## 핵심 패밀리 노트 (기존 · Tier 1 예제 + 전체 명세 보강)

| 파일 | 컴포넌트 | 한 줄 요약 |
|---|---|---|
| [[lightning-accordion]] | `lightning-accordion` | 접고 펼 수 있는 아코디언 |
| [[lightning-tabset]] | `lightning-tabset` | 탭 그룹 컨테이너 |
| [[lightning-input]] | `lightning-input` | 다목적 입력 필드(type 14종) |
| [[lightning-combobox]] | `lightning-combobox` | 단일 선택 드롭다운 |
| [[lightning-datatable]] | `lightning-datatable` | 정렬·선택·인라인편집 테이블 |
| [[lightning-modal]] | `lightning-modal` | 모달 다이얼로그(+Alert/Confirm/Prompt) |
| [[lightning-record-form]] | `lightning-record-form` 외 | 레코드 폼 3종(+input/output-field) |
| [[lightning-record-picker]] | `lightning-record-picker` | 레코드 검색·선택 위젯 |
| [[lightning-button]] | `lightning-button` 외 | 버튼 패밀리(icon/menu/group/stateful) |
| [[lightning-card]] | `lightning-card` | 카드 컨테이너 |
| [[lightning-spinner]] | `lightning-spinner` | 로딩 스피너 |

## 전체 컴포넌트 (SLDS 2 · 카테고리별)

### Action & Menu

| 파일 | 한 줄 요약 |
|---|---|
| [[lightning-click-to-dial]] | 클릭하면 전화 발신되는 전화번호 링크(Open CTI). |
| [[lightning-flow]] | Salesforce Flow를 컴포넌트 안에서 실행. |
| [[lightning-button-icon]] | 아이콘만 있는 버튼(alternative-text 필수). |
| [[lightning-button-group]] | 연관 버튼을 한 묶음으로 붙여 표시하는 컨테이너. |
| [[lightning-button-stateful]] | 선택/비선택에 따라 라벨·아이콘이 바뀌는 버튼(팔로우/팔로잉). |
| [[lightning-button-icon-stateful]] | 눌림(선택) 상태를 토글하는 아이콘 버튼(좋아요). |
| [[lightning-button-menu]] | 드롭다운 메뉴 버튼 + menu-item·menu-divider·menu-subheader. |

### Container

| 파일 | 한 줄 요약 |
|---|---|
| [[lightning-carousel]] | 이미지를 슬라이드로 넘겨 보는 캐러셀. |
| [[lightning-carousel-image]] | 캐러셀 안의 개별 이미지. |
| [[lightning-layout]] | 행/열 기반 반응형 레이아웃 컨테이너(flex). |
| [[lightning-layout-item]] | Layout 안의 개별 칸(크기/패딩 지정). |
| [[lightning-quick-action-panel]] | 화면 액션(Screen Action)의 본문 패널. |
| [[lightning-tile]] | 레코드 요약을 보여주는 타일. |
| [[lightning-tab]] | tabset 안의 개별 탭(label·value·icon-name). |
| [[lightning-accordion-section]] | 아코디언 안의 개별 섹션(actions 슬롯). |

### Visual

| 파일 | 한 줄 요약 |
|---|---|
| [[lightning-avatar]] | 사용자/객체를 나타내는 원형/사각 이미지. |
| [[lightning-badge]] | 상태/카운트를 나타내는 작은 라벨. |
| [[lightning-dynamic-icon]] | 애니메이션이 있는 동적 아이콘(예: strength, scoreboard). |
| [[lightning-empty-state]] | 데이터가 없을 때 보여주는 빈 상태 화면. |
| [[lightning-helptext]] | 물음표 아이콘에 마우스를 올리면 뜨는 도움말 툴팁. |
| [[lightning-icon]] | SLDS 아이콘을 표시. |
| [[lightning-illustration]] | 빈 상태/오류 등을 위한 일러스트 + 메시지. |
| [[lightning-map]] | 지도에 마커를 표시. |
| [[lightning-pill]] | 제거 가능한 라벨(태그) 칩. |
| [[lightning-pill-container]] | 여러 pill을 묶어서 표시. |

### Input

| 파일 | 한 줄 요약 |
|---|---|
| [[lightning-checkbox-group]] | 여러 개를 선택할 수 있는 체크박스 묶음. |
| [[lightning-dual-listbox]] | 좌→우로 항목을 옮겨 선택하는 이중 리스트. |
| [[lightning-file-upload]] | 레코드에 파일을 업로드. |
| [[lightning-input-rich-text]] | 서식 있는 텍스트(리치 텍스트) 편집기. |
| [[lightning-radio-group]] | 하나만 선택하는 라디오 버튼 묶음. |
| [[lightning-rich-text-toolbar-button]] | 리치 텍스트 편집기에 추가하는 커스텀 툴바 버튼. |
| [[lightning-rich-text-toolbar-button-group]] | 커스텀 툴바 버튼들의 그룹. |
| [[lightning-select]] | 네이티브 HTML select 기반 드롭다운. |
| [[lightning-slider]] | 범위 값을 드래그로 조절하는 슬라이더. |
| [[lightning-textarea]] | 여러 줄 텍스트 입력. |

### Form

| 파일 | 한 줄 요약 |
|---|---|
| [[lightning-record-edit-form]] | 레코드 생성·편집 폼(input-field 자식 배치). |
| [[lightning-record-view-form]] | 레코드 읽기 전용 폼(output-field 자식 배치). |
| [[lightning-input-field]] | edit form 안에서 객체 필드 하나를 편집. |
| [[lightning-output-field]] | view form 안에서 객체 필드 하나를 읽기 전용 표시. |

### Navigation

| 파일 | 한 줄 요약 |
|---|---|
| [[lightning-breadcrumb]] | 빵부스러기 경로의 개별 항목. |
| [[lightning-breadcrumbs]] | 현재 위치 경로를 보여주는 빵부스러기 내비. |
| [[lightning-vertical-navigation]] | 세로 사이드 내비게이션 메뉴. |
| [[lightning-vertical-navigation-item]] | 세로 내비의 개별 항목. |
| [[lightning-vertical-navigation-item-badge]] | 배지(숫자)가 붙는 세로 내비 항목. |
| [[lightning-vertical-navigation-item-icon]] | 아이콘이 붙는 세로 내비 항목. |

### Status & Notification

| 파일 | 한 줄 요약 |
|---|---|
| [[lightning-platform-show-toast-event]] | Aura/이벤트 방식으로 토스트를 띄우는 이벤트. |
| [[lightning-toast]] | 화면 모서리에 잠깐 뜨는 알림(LWR 사이트용). |
| [[lightning-toast-container]] | 여러 토스트의 위치/스택을 관리하는 컨테이너(LWR). |
| [[lightning-alert]] | LightningAlert.open() 정적 메서드 호출형 알림 모달(OK). |
| [[lightning-confirm]] | LightningConfirm.open() 확인/취소 모달, boolean 반환. |
| [[lightning-prompt]] | LightningPrompt.open() 입력 프롬프트 모달, 문자열 반환. |

### Output

| 파일 | 한 줄 요약 |
|---|---|
| [[lightning-formatted-address]] | 주소를 형식에 맞게 표시(지도 링크 옵션). |
| [[lightning-formatted-date-time]] | 날짜/시간을 로케일 형식으로 표시. |
| [[lightning-formatted-email]] | 이메일을 mailto 링크로 표시. |
| [[lightning-formatted-location]] | 위도/경도 좌표를 표시. |
| [[lightning-formatted-name]] | 이름을 로케일 순서로 표시. |
| [[lightning-formatted-number]] | 숫자/통화/백분율을 로케일 형식으로 표시. |
| [[lightning-formatted-phone]] | 전화번호를 tel 링크로 표시. |
| [[lightning-formatted-rich-text]] | HTML 서식 텍스트를 안전하게 렌더링. |
| [[lightning-formatted-text]] | URL/이메일/전화를 자동 링크화해 표시. |
| [[lightning-formatted-time]] | 시간을 로케일 형식으로 표시. |
| [[lightning-formatted-url]] | URL을 하이퍼링크로 표시. |
| [[lightning-relative-date-time]] | '3분 전'처럼 상대 시간으로 표시. |

### Progress

| 파일 | 한 줄 요약 |
|---|---|
| [[lightning-progress-bar]] | 수평 진행 막대. |
| [[lightning-progress-indicator]] | 여러 단계의 진행 상태(스텝). |
| [[lightning-progress-ring]] | 원형 진행 표시. |
| [[lightning-progress-step]] | 진행 인디케이터 안의 개별 단계. |

### Table & Tree

| 파일 | 한 줄 요약 |
|---|---|
| [[lightning-tree]] | 펼침/접힘이 되는 계층 트리. |
| [[lightning-tree-grid]] | 트리 + 표가 결합된 계층형 데이터 그리드. |

> 겹치는 11개 패밀리의 전체 공식 속성 명세는 `_full-spec/` 참조(병합 가이드: `_full-spec/MERGE-GUIDE.md`).
