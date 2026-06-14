# SLDS 2 디자인 패턴 (Patterns)

> 출처: [SLDS 2 · Patterns](https://www.lightningdesignsystem.com/2e1ef8501/p/355656-patterns) 및 하위 21개 패턴 문서
> 패턴 = 일관성·확장성·사용성을 보장하는 **표준화된 재사용 솔루션**(UX 레이어). 각 패턴 상세는 `patterns/` 폴더 참고.

## 가이딩 원칙 (Guiding Principles)

Salesforce가 디자인 결정 시 항상 염두에 두는 4가지 원칙입니다.

- **Clarity (명확성)** — 모호함 제거. 사용자가 보고·이해하고·자신 있게 행동하게.
- **Efficiency (효율)** — 워크플로 최적화. 필요를 지능적으로 예측해 더 똑똑·빠르게.
- **Consistency (일관성)** — 같은 문제엔 같은 해법으로 친숙함·직관 강화.
- **Beauty (아름다움)** — 정교하고 우아한 craftsmanship으로 사용자의 시간·주의를 존중.

## 패턴 목록 (21개)

각 항목: 패턴 — 설명 · [상세](patterns/) · 공식 링크

| 패턴 | 설명 | 상세 |
|---|---|---|
| Agentic Experiences | 사용자가 통제권을 유지하면서 에이전트가 생성·추천·정제·실행하는 AI 보조 경험 | [md](patterns/agentic-experiences.md) |
| Builder | 앱·비즈니스 프로세스를 선언적으로 만들고 시각화 | [md](patterns/builder.md) |
| Currency | 통화 값을 일관된 형식·로케일 구분자·다중통화 인식으로 표시 | [md](patterns/currency.md) |
| Conversation Design | 사용자-시스템 간 자연스럽고 신뢰가는 양방향 대화 설계 | [md](patterns/conversation-design.md) |
| Data Entry | 정보 추가·편집·선택·삭제를 명확·효율적 입력으로 | [md](patterns/data-entry.md) |
| Charts | 복잡한 정보를 시각화해 패턴·추세·비교·진행을 이해하기 쉽게 | [md](patterns/charts.md) |
| Displaying Data | 정보를 스캔 가능한 레이아웃으로 — 탐색·비교·협업·레코드 액션 지원 | [md](patterns/displaying-data.md) |
| In App Feedback | 제품 경험 안에서 사용자 의견을 수집 | [md](patterns/in-app-feedback.md) |
| Interface Feedback | 액션 결과·시스템 상태·오류를 전달해 무슨 일이 났고 다음에 뭘 할지 알림 | [md](patterns/interface-feedback.md) |
| Layout | 콘텐츠·UI 요소를 구조화해 위계·정렬·간격·반응형 구성 | [md](patterns/layout.md) |
| Loading | 진행/대기 상태를 전달 | [md](patterns/loading.md) |
| Localization | 언어·지역·문화에 맞게 콘텐츠·형식·관례 적응 | [md](patterns/localization.md) |
| Markup and Style | 일관성·가독성·접근성을 위한 콘텐츠 구조·표현 방식 | [md](patterns/markup-and-style.md) |
| Messaging UI | 실시간·비동기 텍스트 대화 원칙 | [md](patterns/messaging-ui.md) |
| Metric Display | 핵심 값·진행 지표를 노출해 성과·상태·변화를 빠르게 파악 | [md](patterns/metric-display.md) |
| Navigation | 현재 위치 파악·영역 간 이동·필요 정보/액션 접근 | [md](patterns/navigation.md) |
| Notifications | 중요한 이벤트·업데이트·필요 액션을 적시·맥락에 맞게 알림 | [md](patterns/notifications.md) |
| Prompt Design Guide | AI 동작을 안내하는 명확·효과적 프롬프트 작성 | [md](patterns/prompt-design-guide.md) |
| Rules, Filters, and Logic | 조건·기준·결정 경로로 데이터 정제·자동화·동작 제어 | [md](patterns/rules-filters-and-logic.md) |
| Search | 쿼리·제안·결과로 정보·콘텐츠·액션을 빠르게 탐색 | [md](patterns/search.md) |
| User Engagement | 적시 프롬프트·안내·피드백으로 의미 있는 상호작용·채택·지속 사용 유도 | [md](patterns/user-engagement.md) |

> 참고: 일부 패턴(Conversation Design, Messaging UI, Charts, Builder, Agentic Experiences, Prompt Design Guide 등)은 공식 사이트에서 다단계 하위 가이드를 가집니다. 각 상세 md에 핵심을 정제하고 공식 링크를 달았습니다.

### 관련 문서
- 접근성: `SLDS2-Accessibility.md` · 모범 사례: `SLDS2-Best-Practices.md`
- 컴포넌트: `components.html` · 블루프린트: `blueprints-index.html`
