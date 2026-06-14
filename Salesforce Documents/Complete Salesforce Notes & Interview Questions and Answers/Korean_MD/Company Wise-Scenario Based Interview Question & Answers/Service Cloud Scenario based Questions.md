---
tags: [scenario, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Service Cloud Scenario based Questions]
---

# Service Cloud 시나리오 기반 질문

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

1. **반복 이슈 고객** → Case Merge, Email Template·Auto-Response Rules 자동 응답.
2. **셀프 서비스 역량** → Self-Service Community/Experience Cloud(Knowledge Articles, Case 제출, 챗봇).
3. **다중 팀 SLA 준수 모니터링** → Reports·Dashboards로 Milestone 추적, SLA 위반 필터·실시간 알림.
4. **소셜 미디어 불만** → Social Customer Service(Twitter·Facebook), Omni-Channel 라우팅.
5. **셀프 서비스 Knowledge 검색 개선** → Einstein Article Recommendations, Data Category, SEO·필터.
6. **매니저 승인 필요 Case** → 기준 기반 Approval Process, 이메일/Salesforce 승인.
7. **Case 업데이트 SMS 알림** → SMS 게이트웨이(Twilio) 통합, Flow/Process Builder 트리거.
8. **사전 입력 에스컬레이션 이메일 버튼** → 커스텀 Lightning/Quick Action으로 Flow·Apex 실행.
9. **불완전 해결로 Case 재오픈** → 재오픈 패턴 리포트 분석, Knowledge 개선·교육·종료 체크리스트.
10. **계약별 엄격한 응답·해결 시간** → Entitlements·Milestone, 계약별 entitlement 프로세스.
11. **FCR(첫 접촉 해결률) 추적** → 커스텀 필드로 첫 상호작용 해결 캡처, FCR 리포트.
12. **ERP 통합으로 주문 동기화** → MuleSoft/API, 커스텀 오브젝트·Salesforce Connect로 표시.
13. **Case 이력 기반 이탈 예측** → Einstein Discovery, 예측 대시보드·고위험 워크플로우.
14. **에이전트 Knowledge 검색 최적화** → Service Console Knowledge Sidebar, Data Categories 필터.
15. **신규 에이전트 콘솔 온보딩** → Dynamic Forms·Quick Actions, Path 가이드, 인앱 가이던스.
16. **외부 CRM Case 동기화** → API/MuleSoft, 필드 매핑.
17. **에이전트별 CSAT 추적** → Case CSAT 필드, 설문 도구, 에이전트별 리포트·대시보드.
18. **관련 Case 업데이트 누락** → Case Feed Tracking, Chatter 알림.
19. **중복 Case 감소** → Duplicate Management Rules, Knowledge·챗봇.
20. **불완전 Case 정보** → Einstein Case Classification으로 누락 값 예측·채우기.
21. **공통 이슈 빠른 해결(새 Case 없이)** → Knowledge Management, Service Console Knowledge Search.
22. **프리미엄 지원 SLA** → Entitlement Process(레벨별 SLA), Milestone(First Response·Resolution).
23. **지역별 전문 팀 라우팅** → Omni-Channel(Region 필드 기반), 전용 큐·라우팅 규칙.
24. **서비스 데스크-현장 기술자 소통** → FSL(Field Service Lightning) 모바일 앱, Chatter 알림.
25. **다중 에스컬레이션 미해결 불만 고객** → Escalation Rules(우선순위·SLA 기반), Case Milestone 모니터링, 근본 원인 분석.
26. **모바일 앱으로 현장 기술자 성과 추적** → FSL 모바일 앱(활동 로그·상태 업데이트), Service Reports.
27. **실시간 Case 볼륨·해결 시간 뷰** → 커스텀 리포트, 실시간 대시보드, 예약 리포트.
28. **셀프 서비스 포털 검색 개선** → Einstein Search, Data Categories·필터, Article Suggestions.
29. **전화 시스템 통합으로 통화를 Case로** → CTI(Computer Telephony Integration), 자동 Case 로깅.
30. **복잡 Case 진행 추적** → Case History Tracking(상태·우선순위·소유자).
31. **고객 정보 통합 뷰** → Service Cloud Console, 커스텀 페이지 레이아웃, Omni-Channel·Lightning 컴포넌트.
32. **Knowledge Article 권한 관리** → Knowledge Article Permissions, Validation Rules, Profile·Permission Set.
33. **해결됐으나 추가 지원 필요 Case** → 상태를 "On Hold"/"Pending", Process Builder/Flow 알림.
34. **서드파티 라이브 챗 통합** → Salesforce Live Agent 또는 Zendesk/Olark(AppExchange), Case 자동 로깅.
35. **우선순위·상태별 Case 대시보드** → 커스텀 리포트(Priority·Status 그룹화), 차트 대시보드.
36. **에이전트 Knowledge 접근성** → Knowledge Components, Einstein Knowledge, 카테고리·태그.
37. **다중 Case 다른 에이전트 할당** → Mass Update/Case Queues, 벌크 업데이트·재할당.
38. **외부 서비스 도구 동기화** → Salesforce Connect/MuleSoft/Dell Boomi, 외부 오브젝트.
39. **이메일 요청 자동 Case 생성** → Email-to-Case, Email Services.
40. **CSAT 커스텀 필드 추가** → Object Manager에서 Picklist/Rating Scale 필드, 페이지 레이아웃(종료 후 표시).
41. **단종 제품 문의** → Knowledge Article(대안·지원), Archived 표시.
42. **Case 종료 후 피드백 수집** → Case 커스텀 필드, Flow/Process Builder, Salesforce Surveys.
43. **Case·관련 레코드 빠른 탐색** → Service Console 페이지 레이아웃(관련 목록), Lightning App Builder(Record Highlights·Quick Actions).
44. **웹사이트 실시간 챗** → Live Agent/Messaging for Service, Omni-Channel 라우팅.
45. **고우선 Case 평균 해결 시간 리포트** → 커스텀 리포트(High Priority 필터, Duration), Summary 리포트·대시보드.
46. **서드파티 Knowledge 시스템 통합** → Salesforce Connect/REST API, 외부 데이터 소스.
47. **신제품 출시 Knowledge Article** → 신규 Article 생성·게시, 카테고리, Article Validation·Approval Process.
