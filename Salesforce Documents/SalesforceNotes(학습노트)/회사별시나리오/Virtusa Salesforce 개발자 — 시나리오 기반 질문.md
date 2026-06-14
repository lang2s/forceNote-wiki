---
tags: [scenario, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Virtusa Salesforce Developer Scenario Based Questions]
---

# Virtusa Salesforce 개발자 — 시나리오 기반 질문

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

1. **외부 시스템 타임아웃으로 예약 작업 간헐 실패** — 수동 개입 없이 성공하도록 오류 처리?
2. **Opportunity별 고객 피드백(다중 항목) 추적** — 데이터 모델 설계? 어떤 관계·이유?
3. **CSV 50,000건 업로드·처리** — 거버너 한도 고려 효율 처리?
4. **이전 응답에 의존하는 다중 외부 API 순차 호출** — Queueable Apex 관리·고려사항?
5. **영업 담당 활동 주간 리포트를 매니저에게 이메일** — Scheduled Apex 구현·이슈 처리?
6. **Case 업데이트 시 외부 시스템 알림** — Platform Events 구현? 아웃바운드 메시지 대비 장점?
7. **다중 트리거 실행 순서로 예기치 않은 동작** — 실행 순서 보장? 기존 트리거 수정 vs 프레임워크?
8. **관련 Contact 수정 시 Account 필드 업데이트(선언적 불가)** — Apex 구현?
9. **SSN 같은 민감 데이터 필드 수준 암호화** — 구현? 컴플라이언스·접근 고려?
10. **Account의 관련 Contact·Opportunity·Task 단일 뷰** — Lightning App Builder + 커스텀 컴포넌트?
11. **다중 선택 목록 특정 값 포함 레코드 리포트** — SOQL 쿼리·필터?
12. **Opportunity 중요 필드 변경·과거 값 추적** — 필드 히스토리 추적 vs 커스텀 오브젝트?
13. **Account 필드 변경 시 관련 Contact 모두 업데이트** — 재귀 트리거 회피·효율?
14. **Closed Won Opportunity 권한 없으면 수정 불가** — 검증 규칙 vs 트리거?
15. **이메일에 Opportunity 상세 PDF 첨부** — PDF 생성·첨부?
16. **커스텀 오브젝트가 두 오브젝트와 다대다** — 데이터 모델 설계?
17. **웹사이트 커스텀 폼이 Salesforce에 직접 기록** — Sites 또는 Experience Cloud?
18. **단일 부모의 과도한 자식으로 데이터 스큐 성능 문제** — 식별·해결?
19. **프로필·역할 기반 다른 필드·데이터 Lightning 페이지** — 동적 LWC?
20. **프로덕션에서만 트리거 오작동(샌드박스 정상)** — 디버그·해결?
21. **Lead 저장 전 외부 시스템으로 이메일 실시간 검증** — 콜아웃 vs Lightning 컴포넌트?
22. **대용량으로 리포트 한도 초과** — 최적화?
23. **수백만 건 벌크 업로드(거버너 한도 준수)** — 솔루션 설계?
24. **무거운 계산 + 대량 데이터셋** — Batch 또는 Queueable 비동기?
25. **다중 부모 커스텀 오브젝트(다대다)** — Junction 오브젝트 설계?
26. **규칙 기반 Account 영역 자동 할당** — 선언적 또는 Apex?
27. **레거시 앱 마이그레이션 + 커스텀 화면** — Visualforce 설계·통합?
28. **외부 통합으로 API 한도 근접** — 모니터링·최적화?
29. **사용자 활동(로그인·API·변경) 상세 로그** — Event Monitoring?
30. **마이그레이션 후 데이터 정확성 검증** — 도구·기법?
31. **자식 필드가 부모 필드 기준 충족 검증** — 접근법?
32. **API 호출 일일 한도 도달** — 관리·최적화?
33. **매일 활성 레코드 필드 업데이트** — Scheduled Apex?
34. **Opportunity Stage 값 시간별 변화 분석** — 과거 데이터 캡처·리포트?
35. **커뮤니티 사용자 커스텀 브랜드 로그인 페이지** — 생성·구성?
