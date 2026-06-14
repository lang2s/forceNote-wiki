---
tags: [index, search, navigation]
created: 2026-06-14
---

# SEARCH INDEX — 프론트엔드: LWC 베이스 컴포넌트 (개별 레퍼런스)
> `LWC/BaseComponents(베이스컴포넌트)/` 의 lightning-* 개별 컴포넌트 키워드 → 파일
> frontend.md에서 분할된 하위 샤드. SLDS·LDS·이벤트·Apex통합 등 다른 프론트엔드 주제는 `_index/frontend.md` 참조.
> 루트 라우터: `00 SEARCH_INDEX.md`

## LWC Base Components 상세 레퍼런스 (개별 페이지)

| 키워드 | 파일 |
|---|---|
| lightning-accordion 아코디언, sectiontoggle, allow-multiple-sections-open, 접고 펼치기, active-section-name | `LWC/BaseComponents(베이스컴포넌트)/lightning-accordion.md` |
| lightning-tabset, 탭 컨테이너, 탭셋, ontabchange, active-tab-value, variant default scoped vertical, lightning-tab | `LWC/BaseComponents(베이스컴포넌트)/lightning-tabset.md` |
| lightning-input, 입력 필드 type, text number date email checkbox toggle file search, 유효성 검사, change commit 이벤트 | `LWC/BaseComponents(베이스컴포넌트)/lightning-input.md` |
| lightning-combobox, 드롭다운 단일 선택, options 배열, label value, Picklist 드롭다운 | `LWC/BaseComponents(베이스컴포넌트)/lightning-combobox.md` |
| lightning-datatable 상세, columns type, 인라인 편집 onsave draftValues, 행 선택 rowselection, 행 액션 rowaction, 정렬 onsort, 커스텀 타입 customTypes | `LWC/BaseComponents(베이스컴포넌트)/lightning-datatable.md` |
| lightning-modal 상세, LightningModal extends, open size, close 반환값, LightningAlert LightningConfirm LightningPrompt | `LWC/BaseComponents(베이스컴포넌트)/lightning-modal.md` |
| lightning-record-form 상세, lightning-record-edit-form, lightning-record-view-form, lightning-input-field, lightning-output-field, onsubmit onsuccess onerror | `LWC/BaseComponents(베이스컴포넌트)/lightning-record-form.md` |
| lightning-record-picker 상세, filter criteria, clearSelection, displayInfo matchingInfo, 다중 선택 pills, dynamic target | `LWC/BaseComponents(베이스컴포넌트)/lightning-record-picker.md` |
| lightning-button 상세, variant brand destructive inverse, button-icon, button-menu, menu-item, button-stateful, onselect | `LWC/BaseComponents(베이스컴포넌트)/lightning-button.md` |
| lightning-button-icon, Button Icon, 아이콘 버튼, 아이콘 전용 버튼, alternative-text 필수, icon-name, 텍스트 없는 버튼 어떻게 만드나 | `LWC/BaseComponents(베이스컴포넌트)/lightning-button-icon.md` |
| lightning-button-group, Button Group, 버튼 그룹, 버튼 묶음, 버튼 여러 개 붙이기, 연관 버튼 한 묶음으로 | `LWC/BaseComponents(베이스컴포넌트)/lightning-button-group.md` |
| lightning-button-stateful, Button Stateful, 상태 버튼, 토글 버튼, 팔로우 버튼, label-when-on label-when-off, 선택 상태 라벨 바뀌는 버튼 | `LWC/BaseComponents(베이스컴포넌트)/lightning-button-stateful.md` |
| lightning-button-icon-stateful, Button Icon Stateful, 상태 아이콘 버튼, 토글 아이콘 버튼, 좋아요 버튼, selected, 눌림 상태 토글 아이콘 | `LWC/BaseComponents(베이스컴포넌트)/lightning-button-icon-stateful.md` |
| lightning-button-menu, Button Menu, 버튼 메뉴, 드롭다운 메뉴, lightning-menu-item, lightning-menu-divider, lightning-menu-subheader, 메뉴 항목 구분선 소제목, onselect, 드롭다운 액션 메뉴 어떻게 | `LWC/BaseComponents(베이스컴포넌트)/lightning-button-menu.md` |
| lightning-tab, Tab, 개별 탭, 탭 하나, tabset 안의 탭, label value icon-name, 탭 콘텐츠 | `LWC/BaseComponents(베이스컴포넌트)/lightning-tab.md` |
| lightning-accordion-section, Accordion Section, 아코디언 섹션, 개별 섹션, actions 슬롯, name label, 접고 펼치는 섹션 하나 | `LWC/BaseComponents(베이스컴포넌트)/lightning-accordion-section.md` |
| lightning-input-field, Input Field, 입력 필드, 레코드 입력 필드, edit form 필드, field-name, edit form 안에서 필드 편집 어떻게 | `LWC/BaseComponents(베이스컴포넌트)/lightning-input-field.md` |
| lightning-output-field, Output Field, 출력 필드, 읽기 전용 필드, view form 필드, field-name, 레코드 필드 읽기 전용으로 표시 | `LWC/BaseComponents(베이스컴포넌트)/lightning-output-field.md` |
| lightning-record-edit-form, Record Edit Form, 레코드 편집 폼, 레코드 생성 폼, edit form, onsubmit onsuccess onerror, record-id object-api-name, 레코드 만들거나 수정하는 폼 | `LWC/BaseComponents(베이스컴포넌트)/lightning-record-edit-form.md` |
| lightning-record-view-form, Record View Form, 레코드 보기 폼, 읽기 전용 폼, view form, record-id object-api-name, 레코드 읽기 전용으로 보여주는 폼 | `LWC/BaseComponents(베이스컴포넌트)/lightning-record-view-form.md` |
| lightning-alert, LightningAlert, 알림, 경고창, 알림 모달, LightningAlert.open, OK 버튼만 있는 알림 어떻게 띄우나 | `LWC/BaseComponents(베이스컴포넌트)/lightning-alert.md` |
| lightning-confirm, LightningConfirm, 확인, 확인 모달, 확인 다이얼로그, LightningConfirm.open, 확인 취소 묻는 다이얼로그 boolean 반환 | `LWC/BaseComponents(베이스컴포넌트)/lightning-confirm.md` |
| lightning-prompt, LightningPrompt, 프롬프트, 입력 모달, 입력 프롬프트, LightningPrompt.open, default-value, 사용자 입력값 받는 모달 어떻게 | `LWC/BaseComponents(베이스컴포넌트)/lightning-prompt.md` |
| lightning-card 상세, title icon-name, actions 슬롯, footer 슬롯, variant narrow | `LWC/BaseComponents(베이스컴포넌트)/lightning-card.md` |
| lightning-spinner 상세, isLoading 패턴, alternative-text, size variant, try finally, 오버레이 스피너 | `LWC/BaseComponents(베이스컴포넌트)/lightning-spinner.md` |
| lightning-avatar, Avatar, 아바타, 사용자/객체를 나타내는 원형/사각 이미지. | `LWC/BaseComponents(베이스컴포넌트)/lightning-avatar.md` |
| lightning-badge, Badge, 배지, 상태/카운트를 나타내는 작은 라벨. | `LWC/BaseComponents(베이스컴포넌트)/lightning-badge.md` |
| lightning-breadcrumb, Breadcrumb, 빵부스러기 항목, 빵부스러기 경로의 개별 항목. | `LWC/BaseComponents(베이스컴포넌트)/lightning-breadcrumb.md` |
| lightning-breadcrumbs, Breadcrumbs, 빵부스러기 내비, 현재 위치 경로를 보여주는 빵부스러기 내비. | `LWC/BaseComponents(베이스컴포넌트)/lightning-breadcrumbs.md` |
| lightning-carousel, Carousel, 캐러셀, 이미지를 슬라이드로 넘겨 보는 캐러셀. | `LWC/BaseComponents(베이스컴포넌트)/lightning-carousel.md` |
| lightning-carousel-image, Carousel Image, 캐러셀 이미지, 캐러셀 안의 개별 이미지. | `LWC/BaseComponents(베이스컴포넌트)/lightning-carousel-image.md` |
| lightning-checkbox-group, Checkbox Group, 체크박스 그룹, 여러 개를 선택할 수 있는 체크박스 묶음. | `LWC/BaseComponents(베이스컴포넌트)/lightning-checkbox-group.md` |
| lightning-click-to-dial, Click To Dial, 클릭 투 다이얼, 클릭하면 전화 발신되는 전화번호 링크(Open CTI). | `LWC/BaseComponents(베이스컴포넌트)/lightning-click-to-dial.md` |
| lightning-dual-listbox, Dual Listbox, 이중 리스트박스, 좌→우로 항목을 옮겨 선택하는 이중 리스트. | `LWC/BaseComponents(베이스컴포넌트)/lightning-dual-listbox.md` |
| lightning-dynamic-icon, Dynamic Icon, 동적 아이콘, 애니메이션이 있는 동적 아이콘(예: strength, scoreboard). | `LWC/BaseComponents(베이스컴포넌트)/lightning-dynamic-icon.md` |
| lightning-empty-state, Empty State (Beta), 빈 상태, 데이터가 없을 때 보여주는 빈 상태 화면. | `LWC/BaseComponents(베이스컴포넌트)/lightning-empty-state.md` |
| lightning-file-upload, File Upload, 파일 업로드, 레코드에 파일을 업로드. | `LWC/BaseComponents(베이스컴포넌트)/lightning-file-upload.md` |
| lightning-flow, Flow, 플로우 실행, Salesforce Flow를 컴포넌트 안에서 실행. | `LWC/BaseComponents(베이스컴포넌트)/lightning-flow.md` |
| lightning-formatted-address, Formatted Address, 주소 표시, 주소를 형식에 맞게 표시(지도 링크 옵션). | `LWC/BaseComponents(베이스컴포넌트)/lightning-formatted-address.md` |
| lightning-formatted-date-time, Formatted Date Time, 날짜시간 표시, 날짜/시간을 로케일 형식으로 표시. | `LWC/BaseComponents(베이스컴포넌트)/lightning-formatted-date-time.md` |
| lightning-formatted-email, Formatted Email, 이메일 표시, 이메일을 mailto 링크로 표시. | `LWC/BaseComponents(베이스컴포넌트)/lightning-formatted-email.md` |
| lightning-formatted-location, Formatted Location, 위치 표시, 위도/경도 좌표를 표시. | `LWC/BaseComponents(베이스컴포넌트)/lightning-formatted-location.md` |
| lightning-formatted-name, Formatted Name, 이름 표시, 이름을 로케일 순서로 표시. | `LWC/BaseComponents(베이스컴포넌트)/lightning-formatted-name.md` |
| lightning-formatted-number, Formatted Number, 숫자/통화 표시, 숫자/통화/백분율을 로케일 형식으로 표시. | `LWC/BaseComponents(베이스컴포넌트)/lightning-formatted-number.md` |
| lightning-formatted-phone, Formatted Phone, 전화 표시, 전화번호를 tel 링크로 표시. | `LWC/BaseComponents(베이스컴포넌트)/lightning-formatted-phone.md` |
| lightning-formatted-rich-text, Formatted Rich Text, 리치텍스트 표시, HTML 서식 텍스트를 안전하게 렌더링. | `LWC/BaseComponents(베이스컴포넌트)/lightning-formatted-rich-text.md` |
| lightning-formatted-text, Formatted Text, 텍스트 표시, URL/이메일/전화를 자동 링크화해 표시. | `LWC/BaseComponents(베이스컴포넌트)/lightning-formatted-text.md` |
| lightning-formatted-time, Formatted Time, 시간 표시, 시간을 로케일 형식으로 표시. | `LWC/BaseComponents(베이스컴포넌트)/lightning-formatted-time.md` |
| lightning-formatted-url, Formatted URL, URL 표시, URL을 하이퍼링크로 표시. | `LWC/BaseComponents(베이스컴포넌트)/lightning-formatted-url.md` |
| lightning-helptext, Helptext, 도움말 툴팁, 물음표 아이콘에 마우스를 올리면 뜨는 도움말 툴팁. | `LWC/BaseComponents(베이스컴포넌트)/lightning-helptext.md` |
| lightning-icon, Icon, 아이콘, SLDS 아이콘을 표시. | `LWC/BaseComponents(베이스컴포넌트)/lightning-icon.md` |
| lightning-illustration, Illustration (Beta), 일러스트, 빈 상태/오류 등을 위한 일러스트 + 메시지. | `LWC/BaseComponents(베이스컴포넌트)/lightning-illustration.md` |
| lightning-input-rich-text, Input Rich Text, 리치 텍스트 에디터, 서식 있는 텍스트(리치 텍스트) 편집기. | `LWC/BaseComponents(베이스컴포넌트)/lightning-input-rich-text.md` |
| lightning-layout, Layout, 레이아웃, 행/열 기반 반응형 레이아웃 컨테이너(flex). | `LWC/BaseComponents(베이스컴포넌트)/lightning-layout.md` |
| lightning-layout-item, Layout Item, 레이아웃 아이템, Layout 안의 개별 칸(크기/패딩 지정). | `LWC/BaseComponents(베이스컴포넌트)/lightning-layout-item.md` |
| lightning-map, Map, 지도, 지도에 마커를 표시. | `LWC/BaseComponents(베이스컴포넌트)/lightning-map.md` |
| lightning-pill, Pill, 필 태그, 제거 가능한 라벨(태그) 칩. | `LWC/BaseComponents(베이스컴포넌트)/lightning-pill.md` |
| lightning-pill-container, Pill Container, 필 컨테이너, 여러 pill을 묶어서 표시. | `LWC/BaseComponents(베이스컴포넌트)/lightning-pill-container.md` |
| lightning-platform-show-toast-event, Platform Show Toast Event, 토스트 이벤트, Aura/이벤트 방식으로 토스트를 띄우는 이벤트. | `LWC/BaseComponents(베이스컴포넌트)/lightning-platform-show-toast-event.md` |
| lightning-progress-bar, Progress Bar, 진행 막대, 수평 진행 막대. | `LWC/BaseComponents(베이스컴포넌트)/lightning-progress-bar.md` |
| lightning-progress-indicator, Progress Indicator, 진행 인디케이터, 여러 단계의 진행 상태(스텝). | `LWC/BaseComponents(베이스컴포넌트)/lightning-progress-indicator.md` |
| lightning-progress-ring, Progress Ring, 원형 진행, 원형 진행 표시. | `LWC/BaseComponents(베이스컴포넌트)/lightning-progress-ring.md` |
| lightning-progress-step, Progress Step, 진행 단계, 진행 인디케이터 안의 개별 단계. | `LWC/BaseComponents(베이스컴포넌트)/lightning-progress-step.md` |
| lightning-quick-action-panel, Quick Action Panel, 빠른 작업 패널, 화면 액션(Screen Action)의 본문 패널. | `LWC/BaseComponents(베이스컴포넌트)/lightning-quick-action-panel.md` |
| lightning-radio-group, Radio Group, 라디오 그룹, 하나만 선택하는 라디오 버튼 묶음. | `LWC/BaseComponents(베이스컴포넌트)/lightning-radio-group.md` |
| lightning-relative-date-time, Relative Date Time, 상대 시간, '3분 전'처럼 상대 시간으로 표시. | `LWC/BaseComponents(베이스컴포넌트)/lightning-relative-date-time.md` |
| lightning-rich-text-toolbar-button, Rich Text Toolbar Button, 리치텍스트 툴바 버튼, 리치 텍스트 편집기에 추가하는 커스텀 툴바 버튼. | `LWC/BaseComponents(베이스컴포넌트)/lightning-rich-text-toolbar-button.md` |
| lightning-rich-text-toolbar-button-group, Rich Text Toolbar Button Group, 리치텍스트 툴바 그룹, 커스텀 툴바 버튼들의 그룹. | `LWC/BaseComponents(베이스컴포넌트)/lightning-rich-text-toolbar-button-group.md` |
| lightning-select, Select, 네이티브 셀렉트, 네이티브 HTML select 기반 드롭다운. | `LWC/BaseComponents(베이스컴포넌트)/lightning-select.md` |
| lightning-slider, Slider, 슬라이더, 범위 값을 드래그로 조절하는 슬라이더. | `LWC/BaseComponents(베이스컴포넌트)/lightning-slider.md` |
| lightning-textarea, Text Area, 텍스트영역, 여러 줄 텍스트 입력. | `LWC/BaseComponents(베이스컴포넌트)/lightning-textarea.md` |
| lightning-tile, Tile, 타일, 레코드 요약을 보여주는 타일. | `LWC/BaseComponents(베이스컴포넌트)/lightning-tile.md` |
| lightning-toast, Toast, 토스트, 화면 모서리에 잠깐 뜨는 알림(LWR 사이트용). | `LWC/BaseComponents(베이스컴포넌트)/lightning-toast.md` |
| lightning-toast-container, Toast Container, 토스트 컨테이너, 여러 토스트의 위치/스택을 관리하는 컨테이너(LWR). | `LWC/BaseComponents(베이스컴포넌트)/lightning-toast-container.md` |
| lightning-tree, Tree, 트리, 펼침/접힘이 되는 계층 트리. | `LWC/BaseComponents(베이스컴포넌트)/lightning-tree.md` |
| lightning-tree-grid, Tree Grid, 트리 그리드, 트리 + 표가 결합된 계층형 데이터 그리드. | `LWC/BaseComponents(베이스컴포넌트)/lightning-tree-grid.md` |
| lightning-vertical-navigation, Vertical Navigation, 세로 내비게이션, 세로 사이드 내비게이션 메뉴. | `LWC/BaseComponents(베이스컴포넌트)/lightning-vertical-navigation.md` |
| lightning-vertical-navigation-item, Vertical Navigation Item, 세로 내비 항목, 세로 내비의 개별 항목. | `LWC/BaseComponents(베이스컴포넌트)/lightning-vertical-navigation-item.md` |
| lightning-vertical-navigation-item-badge, Vertical Navigation Item Badge, 세로 내비 배지, 배지(숫자)가 붙는 세로 내비 항목. | `LWC/BaseComponents(베이스컴포넌트)/lightning-vertical-navigation-item-badge.md` |
| lightning-vertical-navigation-item-icon, Vertical Navigation Item Icon, 세로 내비 아이콘, 아이콘이 붙는 세로 내비 항목. | `LWC/BaseComponents(베이스컴포넌트)/lightning-vertical-navigation-item-icon.md` |
