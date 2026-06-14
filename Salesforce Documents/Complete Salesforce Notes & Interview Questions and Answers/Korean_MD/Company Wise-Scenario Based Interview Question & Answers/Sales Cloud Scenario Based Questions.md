# Sales Cloud 시나리오 기반 질문

**1. Opportunity의 "Expected Close Date"가 오늘 이후여야 함** → Opportunity 검증 규칙 `Expected_Close_Date__c <= TODAY()` + 오류 메시지. 샌드박스 테스트 후 배포, 팀 공지.

**2. 중복 Lead 방지·정리** → Duplicate Rules·Matching Rules 활성화, Duplicate Jobs/DemandTools/DupeCatcher로 기존 병합, 사용자 교육, 중복 알림.

**3. Opportunity Amount·Close Date 변경 추적** → Field History Tracking 활성화(필드 선택). 20개 초과 시 Shield.

**4. 지역별 다른 가격** → 지역별 Price Book 생성·가격 설정, 공유 설정으로 접근 제한, 올바른 Price Book 선택 교육.

**5. 생성 60일 내 마감, 데드라인 임박 알림** → 시간 종속 워크플로우/Flow로 10일 전 리마인더, 수식 필드로 잔여일 표시, 연체 리포트.

**6. 분기 목표 달성 추적** → Forecasts 활성화·할당 설정, 성과 추적 리포트, 매니저 대시보드, 저성과 알림.

**7. Lead 전환 시 필수 필드(Budget·Decision Maker)** → Lead 검증 규칙 또는 전환 시 Screen Flow, 사용자 교육.

**8. 총 매출·승률·파이프라인·우수 담당 대시보드** → 지표별 커스텀 리포트, 차트·KPI 대시보드, 자동 새로고침·공유.

**9. 단계별 소요 시간 추적** → Stage History Tracking 활성화, Opportunity History 관련 목록 추가, 평균 시간 리포트로 병목 식별.

**10. 참여 지표로 Account 우선순위** → 점수 계산 수식 필드, Einstein Lead Scoring 또는 Apex/Flow, 고우선 대시보드.

**11. 다중 담당 협업·딜 크레딧 공유** → Opportunity Team Selling 활성화, 역할 정의, Splits로 크레딧 배분.

**12. Lead-Opportunity 단계 전환율 분석** → Lead Conversion·Opportunity Stage History 리포트, Custom Report Type, 전환율 대시보드.

**13. 외부 재고 시스템 실시간 업데이트** → Salesforce Connect 외부 데이터 소스 또는 Apex REST 통합, 커스텀 Lightning 컴포넌트로 표시.

**14. 제품별 할인 한도** → Quote Line Item/Opportunity Product에 할인율 필드, 검증 규칙으로 제한, 교육·모니터링.

**15. 다국 통화 관리** → Multi-Currency 활성화, 기업 통화·로컬 통화·환율 설정, 사용자 통화 할당.

**16. 캠페인별 매출·참여** → Campaign Influence 활성화, 매출·참여 리포트, ROI 대시보드.

**17. Stage="Negotiation" 시 "Expected Discount" 자동 업데이트** → Flow로 단계 변경 시 업데이트.

**18. 영역(도시·우편번호) 기반 Lead 할당** → Lead Assignment Rules, 복잡 시 Apex/Flow, Enterprise Territory Management.

**19. Cross-sell/Up-sell 제안** → CPQ Product Relationships, 커스텀 오브젝트/관련 목록, Einstein Opportunity Insights.

**20. 6개월 미접촉 Lead 재참여** → 무활동 리포트, Flow로 재참여 이메일, "Re-engagement Campaign" 필드 태깅, 대시보드 모니터링.
