---
tags: [scenario, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [CGI Salesforce Developer]
---

# CGI Salesforce 개발자 — 시나리오 기반 질문

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

1. **다중 통화 + 기업 통화 자동 변환** — 다중 통화 설정과 정확한 리포팅 구성 방법?
2. **지역·산업별 Account를 영업 담당에 할당** — Enterprise Territory Management 구현?
3. **매일 외부 시스템 작업 트리거** — Apex Scheduler + 콜아웃 사용?
4. **두 Salesforce 조직 간 Account·Opportunity 공유** — Salesforce-to-Salesforce 통합 구성?
5. **비즈니스 기준에 따라 특정 레코드 삭제 방지** — Apex 트리거 작성?
6. **컴플라이언스용 수백만 건 주간 내보내기** — 확장 가능·자동화 데이터 내보내기?
7. **모든 예약 작업 모니터링** — 예약 작업을 프로그래밍으로 추적·관리?
8. **레코드 변경 감사 추적** — Salesforce Shield의 Field Audit Trail 구현?
9. **OAuth 인증 외부 API** — 안전한 API 콜아웃 구현·관리?
10. **표준 예측 모델 부적합** — 커스텀 예측 솔루션?
11. **벌크 업로드 + 레코드별 검증** — Batch Apex 또는 Data Loader + 검증 규칙?
12. **오래된 레코드 아카이브(접근 유지)** — 데이터 아카이빙 전략?
13. **대용량 데이터에서 Lightning 컴포넌트 느림** — 성능 최적화?
14. **같은 영역 사용자만 Account 가시성** — 영역 기반 공유 규칙?
15. **딜 단계별 다른 승인자** — Approval Process 또는 Flow?
16. **역할별 업로드 파일 접근 제한** — 파일 접근 권한 관리?
17. **외부 ERP와 주문·송장 데이터 교환** — 데이터 일관성·오류 처리 통합 설계?
18. **관련 Opportunity 합계로 Account "Customer Tier" 자동 업데이트** — Apex 트리거?
19. **48시간 미해결 시 Case 매니저 에스컬레이션** — Escalation Rules?
20. **SOQL이 CPU 시간 한도 초과** — 쿼리 최적화·CPU 사용 감소?
21. **자주 쓰는 데이터(제품 상세) 빠른 접근** — Platform Cache 활용?
22. **외부 시스템 통합용 REST API** — 인증 오류·잘못된 요청 테스트·처리?
23. **지오로케이션 필드로 지도에 레코드 표시** — Lightning 컴포넌트 또는 외부 지도 API?
24. **새 Lead 생성 등 이벤트 Slack 알림** — Salesforce-Slack 통합?
25. **사용자 액션·기준에 따라 동적 레코드 가시성** — Apex Sharing Rules?
26. **승인 단계별 고유 메시지 이메일** — 알림 구성?
27. **다가오는 작업·마일스톤 자동 리마인더** — Scheduled Flow 또는 Apex Scheduler?
28. **IoT 디바이스(센서) 데이터 처리** — Salesforce IoT 통합 설계?
29. **시간에 따라 변하는 필드 값 기반 공유 규칙 동적 업데이트** — Apex 또는 선언적 도구?
30. **단계별 다른 승인자 다단계 승인** — Approval Process 또는 Flow?
31. **Master-Detail 없는 두 오브젝트 롤업 계산** — Apex 또는 서드파티?
32. **사용자 액션·선호 기반 고도 커스텀 이메일** — 프로그래밍 이메일 발송?
33. **3개 필드 고유 조합 보장** — 검증 규칙 또는 트리거?
34. **외부 시스템에서 수백만 건 가져오기** — 스토리지·성능 한도 없이?
