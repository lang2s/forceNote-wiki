---
tags: [slds, slds2, design-pattern, ux, reference]
source: SLDS2-Docs — lightningdesignsystem.com SLDS 2 디자인 패턴 (Tier 2)
created: 2026-06-13
aliases: [Notifications (System Messaging), SLDS Notifications 패턴, notifications]
---

# Notifications (System Messaging)

> 카테고리: SLDS 2 디자인 패턴 · [공식](https://www.lightningdesignsystem.com/2e1ef8501/p/70cff7-notifications)
> 하위: Overview · Notification Priority · Delivery Channels

중요한 이벤트·업데이트·필요 액션을 **적시·맥락**에 맞게 알림. 워크플로 방해를 최소화하며 명확한 다음 단계를 제공.

## 효과적 알림의 3속성
- **Timely** — 빠른 액션 기회를 주는 적절한 순간.
- **Relevant** — 최적 채널·맥락으로.
- **Pursuable** — 명확하고 직접적인 액션 경로.

## 알림의 구성 4요소
- **Origin** — 보낸 사용자/시스템 정체.
- **Content** — 참여를 유도하는 핵심 메시지.
- **Action** — 수신자가 취할 수 있는 명확한 액션.
- **Timing** — 전달 시각 또는 사건 이후 경과 시간.

## Notifications vs Interface Feedback
- **Interface Feedback** — 사용자 액션에 대한 직접 반응(예: 저장 확인 토스트). 닫으면 **다시 못 봄**.
- **Notifications** — **추적 가능**. 보고·해제·나중에 다시 보기 가능. 시스템 이벤트·타인에 의해서도 발생.

## 분포 전략
- 한쪽에 치우치지 않게 유형 혼합 권장: **약 45% standard · 30% urgent · 25% discreet**. 중요한 정보가 사용자를 압도하지 않으면서 눈에 띄도록.

---

## 관련 노트

- [[SLDS(디자인시스템)/index|SLDS(디자인시스템) 색인]]
- [[SLDS LWC 디자인 시스템]] — SLDS 2 개념·스타일링 훅·LWC 적용
- [[LWC MOC]]
