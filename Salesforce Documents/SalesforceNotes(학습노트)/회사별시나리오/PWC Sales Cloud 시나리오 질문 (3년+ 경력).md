---
tags: [scenario, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
updated: 2026-06-14
aliases: [PWC Sales Cloud Scenario Based Questions (3+ YOE)]
---

# PWC Sales Cloud 시나리오 질문 (3년+ 경력)

> [!warning] 제3자 학습노트(Sales Cloud 시나리오 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 답변은 표준 Sales Cloud 기능 기준으로 작성·검증했으나, 구현 전 공식 문서로 재확인하세요.

> 형식: 굵은 줄 = **시나리오(Q)**, `- **A:**` = 표준 해법.

---

**1. 할인이 승률에 미치는 영향 분석**
- **A:** Opportunity에 `Discount__c`(할인율) 필드를 두고, **할인 구간 vs 승률(Won 비율)** 을 매트릭스 리포트로 교차 분석. 트렌드 대시보드로 시각화해 할인이 승률을 끌어올리는 임계점을 파악.

**2. 분기 성과 대시보드(파이프라인·마감·실주)**
- **A:** 분기별 Opportunity 리포트 3종(열린 파이프라인·Closed Won·Closed Lost) — Stage·Amount·Loss Reason 그룹핑 → 차트+테이블 **대시보드**로 구성. 회계 분기(Fiscal Quarter) 기준 필터.

**3. 마감 외 활동 지표(통화·이메일·미팅) 추적**
- **A:** 표준 **Activity**(Task/Event)와 Activity Type으로 추적하거나 **Einstein Activity Capture**(이메일·캘린더 자동 캡처). 활동량 vs 마감 상관 리포트로 선행 지표 분석.

**4. 웹 폼 Lead를 제품 관심·점수 기반 라우팅**
- **A:** **Web-to-Lead**(또는 API)로 수집 → **Lead Assignment Rules**(제품 관심·지역 기준) → **Einstein Lead Scoring**으로 우선순위. 고점수 Lead는 전담 큐/담당자로 라우팅.

**5. 후속 Task 자동 생성**
- **A:** **Record-Triggered Flow**로 Opportunity 단계 변경 시 후속 Task 자동 생성(담당자·기한 설정). 활동 자동화는 Einstein Activity Capture 보조.

**6. 고액 딜 리더십 승인(Deal Review)**
- **A:** `Deal_Review_Status__c` 필드 + **Approval Process**(entry criteria: Amount > 임계값). 제출 시 레코드 **잠금**(Lock Record), 승인 단계별 승인자 지정.

**7. 소매·도매 다른 가격 모델**
- **A:** 별도 **Price Book** 2개(Retail/Wholesale) 구성 → Account 유형에 따라 올바른 Price Book을 자동 적용(Flow 또는 CPQ). 제품별 가격은 Price Book Entry로 관리.

**8. 비관리자 특정 Opportunity 필드 접근 제한**
- **A:** **Field-Level Security**(Profile/Permission Set)로 필드 가시성 제어. 편집만 막으려면 FLS read-only 또는 레코드 타입·페이지 레이아웃 + 검증 규칙 조합.

**9. 단계별 필수 필드**
- **A:** **Validation Rule**로 특정 Stage 진입 시 필드를 강제. **Path**로 단계별 가이드 필드 안내.
```
AND(
  ISPICKVAL(StageName, "Negotiation/Review"),
  ISBLANK(Next_Step__c)
)
```

**10. Opportunity에서 동적 가격 견적**
- **A:** **Salesforce CPQ** — Price Rules·Product Rules로 동적 가격 산출, Quote Template으로 PDF 견적 생성. 표준 기능만이면 Quote 오브젝트 + Quote Line Item.

**11. Closed Won 후 온보딩 추적**
- **A:** 커스텀 `Onboarding__c` 오브젝트(Opportunity lookup) — Closed Won 시 Flow로 자동 생성, 마일스톤·Task 체크리스트, 진행률 대시보드.

**12. 실시간 커미션 표시**
- **A:** `Commission__c` 필드/오브젝트 + Flow로 마감 시 자동 계산, 담당자별 커미션 대시보드. 복잡 정산은 외부 ICM 툴 연동.

**13. 사업부별 예측(고유 할당·KPI)**
- **A:** **Collaborative Forecasts**에서 여러 forecast type(부서별), 사용자별 **Quota** 설정, 부서별 예측 리포트·대시보드.

**14. 고객 감정 추적**
- **A:** Opportunity `Sentiment__c` 선택 목록(Positive/Neutral/Negative) + 영업 입력 교육, 감정별 승률·리포트·대시보드.

**15. 교육 효과 추적**
- **A:** `Training_Attendance__c` 오브젝트(이수·인증 추적) → 교육 전후 성과(승률·매출) 상관 리포트.

**16. 산업·매출 규모 세분화 캠페인**
- **A:** Account 커스텀 필드(Industry·Revenue Band) → Campaign Member를 기준 기반으로 추가(Flow/리포트), 세그먼트별 응답 대시보드.

**17. Opportunity의 다중 Contact 역할(의사결정자·영향자·사용자)**
- **A:** 표준 **Opportunity Contact Roles**(Role = Decision Maker/Influencer/User) 활용. 역할별 참여도 리포트·대시보드.

**18. 영역 내 Account만 Opportunity 접근**
- **A:** **Enterprise Territory Management** — OWD를 Private로 두고 territory 기반 공유로 같은 영역 사용자만 접근. Role Hierarchy 보완.

**19. 참여·구매 행동 세분화**
- **A:** Account·Opportunity 참여 필드(최근 활동·구매 빈도) → 세그먼트 리포트·대시보드, 고급 분석은 **CRM Analytics**.

**20. 파트너 생성 Opportunity 추적**
- **A:** **PRM(Partner Relationship Management)** + Experience Cloud 파트너 포털. Opportunity에 Partner Account 연결, Revenue Sharing 모델·리포트.

**21. 파트너별 Opportunity·매출·승률 리포트**
- **A:** Partner Account lookup으로 그룹핑한 **Partner Performance Report**(Opportunity 수·매출·승률), 파트너 대시보드.

**22. Closed Won 3일 후 후속 이메일**
- **A:** **Record-Triggered Flow + Scheduled Path**(Closed Won 후 3일) → Email Alert 발송. Opportunity당 1회만 실행되도록 조건 가드.

**23. 구독 기반 매출 인식**
- **A:** **Salesforce CPQ & Billing**의 Subscription·반복 청구·갱신, 또는 커스텀 Subscription 오브젝트 + 매출 인식(Revenue Recognition) 리포트.

**24. 볼륨 기반 가격 자동 적용(CPQ)**
- **A:** **Salesforce CPQ**의 **Discount Schedules**(수량 구간별 할인)·Price Rules·Product Rules로 볼륨 기반 가격 자동 적용.

**25. Account에 관련 Opportunity 총액 표시**
- **A:** ⚠️ Account-Opportunity는 **Lookup**(Master-Detail 아님)이라 표준 **Roll-Up Summary 필드를 쓸 수 없다.** 정확한 해법은 **Apex 트리거**로 Closed Won Amount를 집계하거나 **DLRS(Declarative Lookup Rollup Summaries)** 앱(선언적)으로 롤업.

**26. 소유자·단계별 실시간 파이프라인 리포트**
- **A:** **Sales Pipeline Report**(StageName·Owner 그룹핑·Amount 합계) + **Dynamic Dashboard**(보는 사용자 기준)로 담당자별 실시간 파이프라인 표시.
