---
tags: [slds, slds2, accessibility, a11y, reference]
source: SLDS2-Docs — lightningdesignsystem.com (SLDS 2 v2.30.4, Tier 2)
created: 2026-06-13
aliases: [SLDS Accessibility, SLDS 접근성, 접근성, a11y, 색 대비, 키보드 인터랙션]
---

# SLDS 2 접근성 (Accessibility)

> 출처: [SLDS 2 · Accessibility](https://www.lightningdesignsystem.com/2e1ef8501/p/112ac5-accessibility) 및 하위 5개 문서
> 목표: 마우스/터치, 키보드, 스크린리더 등 **모든 사용자에게 일관된 경험**을 제공. 기준선은 **WCAG 2.1 AA**.

## ✅ 핵심 체크리스트 (개요 9원칙)

1. **기존 SLDS 컴포넌트 우선** — 접근성이 내장된 패턴에서 출발. 새 패턴이 필요하면 접근성 전문가와 사전 협의.
2. **시맨틱 HTML 사용** — `<button>`, `<a>`, `<input>` 등 네이티브 요소 우선, ARIA는 꼭 필요할 때만.
3. **색을 신중히** — 색만으로 정보/액션/피드백 전달 금지. 대비비 **본문 4.5:1**, **큰 글자(18pt/14pt bold) 3:1** 이상.
4. **접근성 있는 폼** — `<fieldset>`/`<legend>` + 명시적 라벨. **placeholder를 라벨 대용으로 쓰지 말 것**(검색 필드·리치텍스트 예외도 시각적 숨김 라벨 필요).
5. **명확한 소통** — 약 20%가 시각/청각/지체/인지 장애. 콘텐츠 의미가 모두에게 전달되도록.
6. **링크는 명확하게** — 본문 속 링크는 **색 + 밑줄** 둘 다로 구분.
7. **접근성 있는 이미지** — 정보 전달 이미지/아이콘/SVG엔 대체 텍스트. 장식용은 `aria-hidden`.
8. **필요한 곳에 ARIA** — 최신 ARIA Authoring Practices 준수. **상태 변화 시 ARIA 속성도 갱신**.
9. **출시 전 테스트** — 릴리스 전 WCAG **AA 적합성** 확인.

---

## 1. 텍스트·색 대비 (Text and Color Contrast)

- **색에만 의존 금지** — 색상 표시에 텍스트 라벨/아이콘/패턴을 함께. 예: 빨간 테두리만 X → 빨간 테두리 + 아이콘 + "이메일을 입력하세요" 메시지.
- **대비비** — 본문·아이콘 **4.5:1**, 큰 글자 **3:1**. 링크는 색+밑줄. (예: `#999` on `#fff` 실패 → `#333` on `#fff` 통과)
- **색각 이상(CVD) 고려** — 빨강↔초록, 파랑↔보라 등 혼동 조합 피하기. 차트는 색 + 패턴/모양/라벨 병행.
- **스타일링 훅 사용** — 고대비 모드·색맹 테마 등 사용자 테마를 컴포넌트가 그대로 수용.
- 근거: WCAG **SC 1.4.3 Contrast (Minimum) Level AA**.

## 2. 글로벌 포커스 (Global Focus) — 포커스 관리

- **논리적 포커스 순서** — 시각·논리 순서대로 Tab 이동. 시맨틱 요소 사용, `tabindex` 남용 금지.
- **시각적 포커스 표시** — SLDS의 포커스 전용 글로벌 스타일링 훅 사용. 대체 표시 없이 outline 제거 금지.
- **프로그래밍적 포커스 관리** 필요 시점: 모달 열기/닫기, 오류 처리, 동적 콘텐츠 갱신.
  - 모달 닫힘 → **트리거 요소로 포커스 복귀**. 폼 오류 → 첫 오류 필드/메시지로 이동.
- **포커스 트랩 방지** — 모달/드롭다운은 Tab 순환 + Esc 탈출 제공.
- **Skip 링크** — `<a href="#main-content" class="skip-link">Skip to Main Content</a>`.
- **모달 초기 포커스 결정(4단계)**: ① 멀티스텝 → 스텝 부제(`tabindex="-1"`) ② 제목 있는 표준 모달 → 제목 ③ 제목 없음 → 본문 첫 인터랙티브 요소(툴팁뿐이면 닫기 X) ④ 그 외 → 닫기 버튼.
- **글로벌 오케스트레이션** — 앱 전역 포커스 이동은 **Cmd/Ctrl + F6** (비모달 다이얼로그 → 유틸 패널 → 도킹 컴포저 → 알림 → 토스트 → 본문 → 분할뷰 순환).
- 리스트/테이블 항목 삭제·"더 보기"·무한스크롤 시 포커스가 "아래로" 자연스럽게 이동하도록 관리.

## 3. 키보드 인터랙션 (Keyboard Interaction)

- 원칙: **마우스로 가능한 모든 동작은 키보드만으로도 가능**해야 함.
- 기본 키: `Tab`/`Shift+Tab`(이동), `Arrow`(라디오·메뉴·위젯 내 이동), `Enter`(링크/버튼/폼 제출), `Space`(버튼/토글), `Esc`(메뉴·모달·팝오버 닫기).
- **테스트 체크리스트 7**: ① 모든 인터랙티브 요소에 도달 가능? ② 활성화 가능? ③ 비인터랙티브 요소에 포커스 안 되는가(되면 버그)? ④ 현재 위치가 시각적으로 보이는가? ⑤ 액션 시에만 포커스 이동하는가? ⑥ hover 툴팁이 focus에도 뜨는가? ⑦ 드래그앤드롭에 키보드 지원이 있는가?
- 컴포넌트별 키 패턴: Combobox(문자=필터, ↑↓=옵션, Enter=선택, Esc=닫기), Menu(Enter/Space=열기, 화살표=이동), Modal/Popover(포커스 트랩+Esc), Tabs(화살표=탭 전환), Data Grid(화살표=셀 이동, Enter=Action 모드, Esc=Nav 모드).
- 참고: ARIA Authoring Practices.

## 4. 모바일 디자인 (Mobile Design)

- 모든 토글·버튼에 **상태를 명시하는 보이는 라벨**(pressed/checked 반환).
- **커스텀 제스처**엔 한 손가락 대체 동작 + 스크린리더 커스텀 액션 등록 + 발견 가능한 도움말.
- **가로 스크롤 리스트 지양**(스크린리더가 위치 추적 곤란).
- **액션 바·플로팅 버튼 고정**(스크롤해도 뷰포트에 유지).
- **탭 타깃 최소 44pt/dp/px** (OS 무관).

## 5. 글로벌 접근성 표준 (Global Accessibility Standards)

- Salesforce 기준선: **WCAG 2.1 AA** (현행 WCAG는 2.2, 3.0은 초안).
- 지역별 표준은 대부분 WCAG 기반:

  | 지역 | 표준/정책 | 기반 |
  |---|---|---|
  | 🌎 국제 | WCAG | W3C |
  | 🇺🇸 미국 | Section 508, ADA | WCAG 2.0+ |
  | 🇪🇺 EU | EN 301 549, European Accessibility Act | WCAG 2.1 |
  | 🇨🇦 캐나다 | ACA, AODA(온타리오) | WCAG 2.0+ |
  | 🇬🇧 영국 | Equality Act 2010, 공공부문 규정 | WCAG 2.1 |
  | 🇦🇺 호주 | DDA | WCAG 2.0 |
  | 🇯🇵 일본 | JIS X 8341-3 | WCAG 정렬 |
  | 🇮🇳 인도 | GIGW | WCAG 기반 |
  | 🇨🇳 중국 | GB/T 37668 | WCAG 참고 |

- **요점**: WCAG 2.1 AA(또는 2.2 AA) 준수 시 전 세계적으로 무난. 단 분야별(교육·의료·정부) 지역 법규는 별도 확인. 모바일 접근성·보조기술 호환은 보편적으로 중요.

---

### 관련 문서
- 디자인 패턴: `SLDS2-Patterns.md`
- 모범 사례: `SLDS2-Best-Practices.md` · 스타일링 훅: `SLDS2-Styling-Hooks.md`
- 컴포넌트별 접근성 속성(aria-*)은 각 `components/lightning-*.md` 의 속성 표 참고.

### 출처 링크
- [Accessibility 개요](https://www.lightningdesignsystem.com/2e1ef8501/p/112ac5-accessibility)
- [Text and Color Contrast](https://www.lightningdesignsystem.com/2e1ef8501/p/99d436-text-and-color-contrast) · [Global Focus](https://www.lightningdesignsystem.com/2e1ef8501/p/92a50f-global-focus) · [Keyboard Interaction](https://www.lightningdesignsystem.com/2e1ef8501/p/3491fd-keyboard-interaction) · [Mobile Design](https://www.lightningdesignsystem.com/2e1ef8501/p/391e54-mobile-design) · [Global Accessibility Standards](https://www.lightningdesignsystem.com/2e1ef8501/p/23a1dd-global-accessibility-standards)

---

## 관련 노트

- [[SLDS(디자인시스템)/index|SLDS(디자인시스템) 색인]]
- [[SLDS LWC 디자인 시스템]] — SLDS 2 개념·스타일링 훅·LWC 적용
- [[design-systems-slds-validate]] (sf-skill — 실행형) — 접근성 포함 SLDS 준수 감사 실행형 스킬
- [[LWC MOC]]
