---
tags: [slds, slds2, design-pattern, ux, reference]
source: SLDS2-Docs — lightningdesignsystem.com SLDS 2 디자인 패턴 (Tier 2)
created: 2026-06-13
aliases: [Builder, SLDS Builder 패턴, builder]
---

# Builder

> 카테고리: SLDS 2 디자인 패턴 · [공식](https://www.lightningdesignsystem.com/2e1ef8501/p/450761-builder)

개발자·관리자·비즈니스 사용자가 앱·비즈니스 프로세스를 **선언적으로 만들고 시각화**하는 도구(예: Lightning App Builder, Flow Builder, Experience Builder, Bot Builder).

## 4가지 빌더 유형
- **Logic** — 프로세스/플로우/시퀀스 시각화
- **Content** — 웹페이지·시각 요소 디자인·구성
- **Data** — 표·차트·그래프 리포트/프레젠테이션
- **Code** — 코드 뷰·DB 스키마

## 언제 쓰나
- WYSIWYG 선언형 요소(클릭으로 추가, 폼으로 커스터마이즈), 빈 캔버스에 프로세스 설계, 논리적 액션 시퀀스 정의, 요소 간 관계 정의, 다중 드래프트/버전 저장·추적. (안 맞으면 directional modal·expression·form element·filter 고려)

## 워크플로 핵심
- **실행 위치**: 관리자/개발자용은 Setup에서 **풀스크린**으로. 앱/콘솔 사용자는 레코드 상세/앱 페이지에서 실행. 콘솔에선 **새 창/탭**으로(콘솔 탭/서브탭 X).
- **레코드 정보**(파일명·버전·상태)를 record list / detail / **빌더 헤더**에 일관 표시.
- **헤더**: 빌더명 + 파일명 + 저장 상태. 우상단은 설정·도움말 링크 전용.
- **저장**: 서버 측 스냅샷. 저장 ≠ 활성화/게시(별개 액션). 오류가 있어도 저장 허용, 활성화/게시를 막는 오류는 알림. 버전 관리는 Save As/자동 버전 + 되돌리기.
- **자동저장 고려**: 신뢰성(무엇이 저장됐는지 명확)·단순성·데이터 저장위치·성능.
- **활성화/게시**: 저장과 분리. Activate/Publish는 툴바 우측.
- **종료**: 헤더 좌상단 Back 또는 창 닫기 → 실행 출발점으로 복귀. 미저장 변경 시 경고.

---

## 관련 노트

- [[SLDS(디자인시스템)/index|SLDS(디자인시스템) 색인]]
- [[SLDS LWC 디자인 시스템]] — SLDS 2 개념·스타일링 훅·LWC 적용
- [[LWC MOC]]
