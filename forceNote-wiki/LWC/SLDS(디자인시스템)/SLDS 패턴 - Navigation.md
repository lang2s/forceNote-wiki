---
tags: [slds, slds2, design-pattern, ux, reference]
source: SLDS2-Docs — lightningdesignsystem.com SLDS 2 디자인 패턴 (Tier 2)
created: 2026-06-13
aliases: [Navigation, SLDS Navigation 패턴, navigation]
---

# Navigation

> 카테고리: SLDS 2 디자인 패턴 · [공식](https://www.lightningdesignsystem.com/2e1ef8501/p/47ae1f-navigation)

사용자가 **현재 위치 파악·영역 간 이동·필요 정보/액션 접근**을 돕는 패턴. 핵심 도구: Tabs, Trees, Breadcrumbs, Modals.

## 한눈에 보는 전략
- **Tabs** — 관련 있는 비선형 콘텐츠 섹션 간 측면 이동.
- **Trees** — 깊은 계층의 고수준 개요가 필요할 때.
- **Breadcrumbs** — 부모-자식 경로를 상시 표시해 상위로 이동.
- **Modals** — 페이지 맥락을 떠나지 않고 집중이 필요한 작업.

## Tabs
- 기능/유스케이스별 논리 섹션 분리. 섹션은 독립적 → **선형 순서 프로세스에는 쓰지 말 것**. 탭 이름은 같은 품사로 일관.
- 가로 공간 부족 시 마지막 탭 위치에 **overflow 메뉴**. 선택 시 마지막 보이는 탭과 교체.
- **Global Tab**(하위 전체 변경) vs **Scoped Tab**(컨테이너 안만 변경). 글로벌 탭 안에 scoped 탭 중첩은 가능하나 **글로벌 탭 중첩 금지**(더 필요하면 Tree).

## Trees
- 탭으로 표현 못 하는 다층 내비. 페이지 로드 없이 중첩 자식 탐색. 과도한 중첩 지양(flat이 쉬움). breadcrumbs와 병행 가능. 모든 항목이 페이지를 가질 필요 없음(label group 활용).

## Breadcrumbs
- 브라우징 기록이 아니라 **계층 경로(부모-자식)** 표시. 깊은 페이지에 직접 진입한 사용자가 상위로 가기 좋음.
- **3단계 초과 시 마지막 2개 링크만** 표시, 나머지는 truncate.

## Modals
- 원래 페이지 맥락 안에서 특정 작업에 집중(다른 요소 상호작용 차단). 폼 입력/편집, wizard(directional modal)에.
- 구조: **Header**(제목=트리거 버튼 텍스트 + 선택적 태그라인) / **Body**(폼·텍스트·미디어, wizard는 step indicator) / **Footer**(액션 버튼 우측, primary는 맨 오른쪽; wizard는 Back 좌·Next 우).
- **크기**: 기본 뷰포트 50%, 큰 모달 90%(min/max width 지정). 높이는 콘텐츠 기준, 길면 내부 스크롤(헤더·푸터 고정).

---

## 관련 노트

- [[SLDS(디자인시스템)/index|SLDS(디자인시스템) 색인]]
- [[SLDS LWC 디자인 시스템]] — SLDS 2 개념·스타일링 훅·LWC 적용
- [[LWC MOC]]
