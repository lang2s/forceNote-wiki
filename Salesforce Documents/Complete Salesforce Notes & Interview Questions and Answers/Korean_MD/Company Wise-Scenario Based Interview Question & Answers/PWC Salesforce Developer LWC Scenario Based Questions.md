---
tags: [scenario, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [PWC Salesforce Developer LWC Scenario Based Questions]
---

# PWC Salesforce 개발자 — LWC 시나리오 질문

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## Q: 두 리스트 간 드래그앤드롭 LWC
**의도:** HTML5 드래그앤드롭 API, JS 이벤트(dragstart·dragover·drop), 동적 UI 업데이트.
**설명:** 리스트 항목에 `draggable="true"`, dragstart·dragover·drop 이벤트로 항목 이동.
**흔한 실수:** dragover·drop의 기본 동작 미방지, drop 후 데이터 모델 미갱신, 엣지 케이스(빈 리스트) 미처리.

## Q: 레코드(Account) 검색·선택 커스텀 lookup 컴포넌트
**의도:** 재사용 컴포넌트 생성, lightning-input·lightning-combobox 사용, Apex로 검색 결과 조회.
**설명:** lightning-input(검색바), lightning-combobox/커스텀 리스트(결과 표시), Apex로 검색어 기반 조회.
**흔한 실수:** 디바운싱 미처리, 입력 지움 시 결과 미초기화, 선택 레코드를 부모에 노출하는 @api 미사용.

## Q: Apex 호출 커스텀 오류 처리 LWC
**의도:** @wire/imperative Apex 오류 처리, 커스텀 오류 메시지 표시, try-catch.
**설명:** imperative Apex는 try-catch, lightning-messages/notifications로 오류 표시.
**흔한 실수:** @wire 오류 미처리, 오류 메시지 미표시, 반응형 속성에 @track/@api 미사용.
