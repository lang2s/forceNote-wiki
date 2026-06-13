---
tags: [slds, slds2, design-pattern, ux, reference]
source: SLDS2-Docs — lightningdesignsystem.com SLDS 2 디자인 패턴 (Tier 2)
created: 2026-06-13
aliases: [Data Entry, SLDS Data Entry 패턴, data-entry]
---

# Data Entry

> 카테고리: SLDS 2 디자인 패턴 · [공식](https://www.lightningdesignsystem.com/2e1ef8501/p/33f0d7-data-entry)

정보를 추가·편집·선택·삭제하는 **주요 상호작용 방식**. 명확한 라벨·제약·맥락 보조로 사용자 노력과 오류를 최소화.

## 입력 유형 선택 기준
- **자유 입력(Freeform)** — 이름·설명·이메일·숫자 등 고유 데이터.
- **선택 입력(Selection)** — 적고 한눈에 보이는 옵션은 체크박스/라디오, 많으면 **Picklist**로 공간 절약.
- **특수 피커** — Date Picker·Lookup으로 수동 입력·형식 오류 감소.
- **즉시 적용** — Toggle은 "저장" 없이 즉시 반영되는 설정에.

## 기본 텍스트 입력
- 단일행(형식 제한 가능: 숫자/이메일), 다중행 textarea(형식 제한 불가).
- **라벨은 위(stacked)가 기본**(가독성). 세로 공간 절약 + 필드 10개 미만일 때만 가로 라벨.
- 관련 필드(주소 등)는 **compound input**으로 묶기. 입력 폭은 컨테이너의 100%.
- **도움말**: 길면 info 아이콘+툴팁, 짧으면 필드 아래. placeholder는 형식 예시로.

## 복합/특수 입력
- **Date Picker** — 단일 날짜/범위를 시각적으로 선택.
- **Lookup** — DB 레코드 검색으로 필드 채움(단일/다중).

## 선택 입력
- **Checkbox** — Boolean(참/거짓, on/off) 단일 항목.
- **Radio List** — 10개 미만에서 하나 선택, 모두 한 번에 보여 비교 쉽게(보통 독립 필드).
- **Checkbox Toggle** — 이진 선택을 **즉시 저장**(dirty 상태 없음). 필드 라벨 + 상태 라벨(Enabled/Disabled 등) 2개 동반. 다른 폼 컴포넌트·제출 버튼과 함께 쓰지 말 것(단독 사용).
- **Picklist(드롭다운)** — 큰 폼 안에서 라디오/체크박스 대신, 옵션 수 유연.
- **Dual Listbox** — 두 목록 간 항목 이동 + 순서 정의(다중 선택+정렬).

## 인라인 편집 (Inline Edit)
- 보기↔편집 전환 없이 레코드 일부를 즉석 편집. 편집 가능 필드엔 연필 아이콘, 더블클릭/연필클릭으로 활성화.

---

## 관련 노트

- [[SLDS(디자인시스템)/index|SLDS(디자인시스템) 색인]]
- [[SLDS LWC 디자인 시스템]] — SLDS 2 개념·스타일링 훅·LWC 적용
- [[LWC MOC]]
