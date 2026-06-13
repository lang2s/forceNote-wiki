---
tags: [slds, slds2, design-pattern, ux, reference]
source: SLDS2-Docs — lightningdesignsystem.com SLDS 2 디자인 패턴 (Tier 2)
created: 2026-06-13
aliases: [Conversation Design (CXD), SLDS Conversation Design 패턴, conversation-design]
---

# Conversation Design (CXD)

> 카테고리: SLDS 2 디자인 패턴 · [공식](https://www.lightningdesignsystem.com/2e1ef8501/p/33c7b6-conversation-design-)
> 하위 섹션: Overview · Language and Style · Best Practices · Bot Personality · Accessibility · Resources

챗봇·보이스봇·IVR 등 대화형 인터페이스의 상호작용을 설계하는 UX 분야. **사람 간 대화 원칙**에 기반해 자연스럽고 신뢰가는 양방향 대화를 만들되, **항상 봇임을 명확히** 합니다. 핵심은 사용자 신뢰.

## 누구를 위한 가이드인가
전담 Conversation Designer뿐 아니라 UX/기술 작가, UX 디자이너, PM, 영업/계정 관리자, Customer Success 등 봇을 만들거나 다루는 모두.

## 봇 대화의 핵심 요소
- **Menu** — 사용자를 안내하는 세로 옵션 목록 / **Buttons**(가로 목록)은 빠른 액션용
- **User Utterance** — 사용자가 입력한 것 / **Bot Response** — 그에 대한 봇의 응답
- **Entity** — 고객에게서 수집할 데이터 유형 / **Intent** — 고객이 봇과 상호작용하는 이유

## 대화 구성 요소(컴포넌트)와 예시 문구
- **Welcome** — 첫 인사. 봇임을 투명하게 밝히고 다음 단계 안내. ("안녕하세요 OO님! [봇명] 자동 어시스턴트예요.")
- **Agent Transfer** — 상담원 전환 전 메시지. 필요한 정보 수집 후 매끄럽게 인계.
- **Conversation Loopback** ("Anything Else?") — 종료 전 추가 도움 확인. 재시작 시 Welcome 다음 단계(보통 Main Menu)로.
- **Closing** — CTA(리뷰·설문) 포함해 마무리.
- **Error Handling** — 시스템 오류 시 발생 사실 전달 + 다음 단계(보통 상담원 전환).
- **Confused / Conversation Repair** — 이해 못 했을 때 재입력 요청 + 다음 단계.
- **Bot Response Delay** — 대화 리듬을 위해 응답 지연을 기본 이상으로 항상 활성화(너무 로봇 같거나 압도하지 않게).

> 더 깊은 지침(Language and Style, Best Practices, Bot Personality, Accessibility)은 공식 페이지의 각 탭 참고.

---

## 관련 노트

- [[SLDS(디자인시스템)/index|SLDS(디자인시스템) 색인]]
- [[SLDS LWC 디자인 시스템]] — SLDS 2 개념·스타일링 훅·LWC 적용
- [[LWC MOC]]
