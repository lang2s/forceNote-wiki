# Interface Feedback (System Messaging)

> 카테고리: SLDS 2 디자인 패턴 · [공식](https://www.lightningdesignsystem.com/2e1ef8501/p/12db58-interface-feedback)
> 하위: Overview · Feedback Priority · Feedback States

사용자 입력에 대한 **시스템의 반응** — 확인·안내·통제감을 줘 신뢰를 형성.

## 원칙
- **Timely, not noisy** — 적절한 순간에. 모든 상호작용에 응답할 필요 없음.
- **Informative, not verbose** — 꼭 필요한 것만 간결히.
- **Actionable, not static** — 관련 액션 바로가기 포함.
- **Cross-device, not duplicative** — 모든 기기에 알림, 읽으면 전부에서 해제.

## 피드백 유형 (사용자 상호작용 기준)
- **System** — 시스템 수준 이슈/상태(시스템이 시작). 예: "이번 주말 시스템 점검".
- **Engagement** — 데이터 갱신·기능 탐색 넛지. 예: "30일간 활동 없음 — 작업/이벤트 생성".
- **Access** — 접근 불가(삭제됨/권한 없음). 예: "Lead X 사용 불가".
- **Standard** — 대부분의 CRUD 액션 응답. 예: "계정 생성됨".

## 컴포넌트 선택 매트릭스 (유형 → 가능한 컴포넌트)
- **System**: Popover, Toast, Alert, (Illustration&Inline)
- **Engagement**: Inline Text, Popover, Toast, Alert, Illustration&Inline, Docked Composer
- **Access**: Inline Text, Illustration & Inline Text
- **Standard**: Popover, Toast, Modal, Prompt

## 선택 3단계
1. 상호작용에 맞는 **피드백 유형** 선택 → 2. 흐름·UI·가시성에 맞는 **컴포넌트** 선택 → 3. 어울리는 **상태**(success/error 등) 결정.
- 예: 판매 후 기회 레코드 저장 성공 = Standard 유형 → **Toast** 컴포넌트 → **Success** 상태 = 성공 토스트 표시.
