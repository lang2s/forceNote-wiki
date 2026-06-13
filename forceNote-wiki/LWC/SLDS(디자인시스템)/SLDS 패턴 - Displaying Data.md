---
tags: [slds, slds2, design-pattern, ux, reference]
source: SLDS2-Docs — lightningdesignsystem.com SLDS 2 디자인 패턴 (Tier 2)
created: 2026-06-13
aliases: [Displaying Data, SLDS Displaying Data 패턴, displaying-data]
---

# Displaying Data

> 카테고리: SLDS 2 디자인 패턴 · [공식](https://www.lightningdesignsystem.com/2e1ef8501/p/7540d0-displaying-data)

정보를 **스캔 가능한 레이아웃**으로 조직해 탐색·비교·협업·레코드 액션을 지원.

## 표시 패턴 선택
- **Table / Tree Grid** — 고밀도 데이터, 정렬, 복잡한 관계·계층.
- **Tiles / Cards** — 가로 공간 제약, 10개 미만 목록, 시각적 강조.
- **Feeds** — 시간순 업데이트, 활동 추적, 사용자 간 소통.

## Record Lists
- table / tile list / interactive card로 표시. 항목 유형은 분리하거나 라벨링(PDF/JPG 등).
- 모든 상호작용에 보이는 affordance(아이콘/버튼). 리스트·필드에 라벨(이름·날짜·숫자는 라벨 없으면 모호).
- **빈 상태 메시지** 제공("표시할 항목 없음 — 필터를 수정하거나 뷰 전환").

## Table / Tree Grid
- **Table**: 레코드 1행, primary 필드 + 추가 컬럼, 인터랙티브 컬럼 헤더. 대량 레코드에 적합(정렬/필터/스크롤). 컬럼폭 조절 허용 시 가로 스크롤(반응형 리사이즈 X). 좁은 화면 → tile 리스트로 collapse.
- **Tree Grid**: 부모-자식 계층. 첫 컬럼이 관계 표현, chevron으로 펼침/접힘·자식 유무 표시. 부모·자식이 **같은 데이터 구조**일 때만(아니면 related list/master-detail). 좁은 화면 → tree 리스트로 collapse.

## Tiles / Cards
- **Tile**: primary 필드 + 아이콘/이미지 + label-value 쌍. 타일 전체가 아니라 내부 요소(버튼/링크)와 상호작용. 가로 제약·10개 미만에. 넓은 화면(2열 초과) → table로 확장.
- **Interactive Card**: 타일에 카드 래퍼 + 드래그앤드롭. 순서·배치가 중요할 때.

## Feeds
- 검색 기능 포함, 빈 상태 메시지 제공.
- **Discussion Feed**: 사용자 간 대화. 인라인 답글·댓글(중첩 스레딩 X), 작성자·날짜·좋아요·북마크/삭제(소유자), 멘션·첨부, 폴 등 메시지 유형.
- **Activity Feed**: 레코드 관련 한 일/할 일 추적(이메일·작업·이벤트·통화 로그 등), 과거·미래 이벤트 표시.

---

## 관련 노트

- [[SLDS(디자인시스템)/index|SLDS(디자인시스템) 색인]]
- [[SLDS LWC 디자인 시스템]] — SLDS 2 개념·스타일링 훅·LWC 적용
- [[LWC MOC]]
