---
tags: [scenario, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
updated: 2026-06-14
aliases: [Virtusa Salesforce Developer Scenario Based Questions]
---

# Virtusa Salesforce 개발자 — 시나리오 기반 질문

> [!warning] 제3자 학습노트(시나리오 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 답변은 표준 Salesforce 기능 기준으로 작성했으나, 구현 전 공식 문서로 검증하세요.

> 형식: **Q** = 시나리오, **A** = 표준 해법.

---

**1. 외부 시스템 타임아웃으로 예약 작업 간헐 실패**
- **Q:** 수동 개입 없이 성공하도록 오류 처리?
- **A:** 콜아웃을 `Queueable(AllowsCallouts)`로 분리하고 `CalloutException` catch → **재시도 카운터 + 백오프**로 재enqueue. 멱등성(외부 ID upsert) 보장, 최대 재시도 초과 시 에러 로그/알림.

**2. Opportunity별 고객 피드백(다중 항목) 추적**
- **Q:** 데이터 모델 설계? 어떤 관계·이유?
- **A:** 자식 커스텀 오브젝트 `Feedback__c` + Opportunity로의 **Master-Detail**(1:다). MD면 롤업 요약·캐스케이드 삭제 가능. 소유권 독립 필요 시 Lookup.

**3. CSV 50,000건 업로드·처리**
- **Q:** 거버너 한도 고려 효율 처리?
- **A:** **Data Loader(Bulk API)** 또는 **Batch Apex**(200건 단위 청크, 벌크화). 루프 내 SOQL/DML 금지.

**4. 이전 응답에 의존하는 다중 외부 API 순차 호출**
- **Q:** Queueable Apex 관리·고려사항?
- **A:** **Queueable 체이닝** — 각 Queueable이 콜아웃 1회 후 다음을 `System.enqueueJob`. `Database.AllowsCallouts` 구현, 체인 깊이·콜아웃 한도 유의, 상태는 인스턴스 변수로 전달.

**5. 영업 담당 활동 주간 리포트를 매니저에게 이메일**
- **Q:** Scheduled Apex 구현·이슈 처리?
- **A:** `Schedulable`을 주간 cron으로 예약, 활동 집계 후 `Messaging.sendEmail`. 대용량은 **Batch + Schedulable** 결합, 이메일 일일 한도 유의.

**6. Case 업데이트 시 외부 시스템 알림**
- **Q:** Platform Events 구현? 아웃바운드 메시지 대비 장점?
- **A:** Case 트리거에서 `EventBus.publish`. **PE 장점**: 유연한 페이로드, 다중 구독자, 디커플드, Apex/Flow/API 발행, Pub/Sub·CometD 구독. Outbound Message는 SOAP 단일 엔드포인트·선언적 한정.

**7. 다중 트리거 실행 순서로 예기치 않은 동작**
- **Q:** 실행 순서 보장? 기존 트리거 수정 vs 프레임워크?
- **A:** 같은 오브젝트의 여러 트리거 실행 순서는 **보장 안 됨** → **오브젝트당 트리거 1개 + 핸들러 프레임워크**로 통합해 로직 순서 제어.

**8. 관련 Contact 수정 시 Account 필드 업데이트(선언적 불가)**
- **Q:** Apex 구현?
- **A:** Contact `after update` 트리거 → 부모 AccountId 수집 → 집계 후 Account 벌크 업데이트.

**9. SSN 같은 민감 데이터 필드 수준 암호화**
- **Q:** 구현? 컴플라이언스·접근 고려?
- **A:** **Shield Platform Encryption**(저장 시 암호화) 또는 Classic Encryption. 복호화 보기는 "View Encrypted Data" 권한 + FLS. 키 관리·검색/정렬 제약 고려.

**10. Account의 관련 Contact·Opportunity·Task 단일 뷰**
- **Q:** Lightning App Builder + 커스텀 컴포넌트?
- **A:** 레코드 페이지에 관련 목록 + 탭/아코디언, 또는 커스텀 **LWC**(여러 관련 데이터를 `@wire`/Apex로 한 화면에).

**11. 다중 선택 목록 특정 값 포함 레코드 리포트**
- **Q:** SOQL 쿼리·필터?
- **A:** `WHERE MultiPicklist__c INCLUDES('값1','값2')` (다중 선택은 `INCLUDES`/`EXCLUDES`).

**12. Opportunity 중요 필드 변경·과거 값 추적**
- **Q:** 필드 히스토리 추적 vs 커스텀 오브젝트?
- **A:** **Field History Tracking**(오브젝트당 최대 20필드, 보존 한정) 간단·선언적. 장기/대량은 **Field Audit Trail**(Shield) 또는 커스텀 히스토리 오브젝트.

**13. Account 필드 변경 시 관련 Contact 모두 업데이트**
- **Q:** 재귀 트리거 회피·효율?
- **A:** Account `after update` 트리거 → 자식 Contact 벌크 업데이트, **static 플래그로 재귀 차단**, 변경된 레코드만 처리.

**14. Closed Won Opportunity 권한 없으면 수정 불가**
- **Q:** 검증 규칙 vs 트리거?
- **A:** **Validation Rule**: `AND(ISWON, ISCHANGED(...), NOT($Permission.Edit_Closed_Won))` 또는 Custom Permission 체크. 복잡하면 트리거.

**15. 이메일에 Opportunity 상세 PDF 첨부**
- **Q:** PDF 생성·첨부?
- **A:** **Visualforce `renderAs="pdf"`** 페이지 또는 Apex `Blob.toPdf()`로 PDF 생성 → `Messaging.EmailFileAttachment`로 첨부해 `sendEmail`.

**16. 커스텀 오브젝트가 두 오브젝트와 다대다**
- **Q:** 데이터 모델 설계?
- **A:** **Junction 오브젝트** — 두 부모로의 Master-Detail 2개(다대다 구현).

**17. 웹사이트 커스텀 폼이 Salesforce에 직접 기록**
- **Q:** Sites 또는 Experience Cloud?
- **A:** **Web-to-Lead/Case**(간단), 또는 **Experience Cloud/Sites** 페이지 + Apex, 또는 **REST API**로 외부 폼에서 기록.

**18. 단일 부모의 과도한 자식으로 데이터 스큐 성능 문제**
- **Q:** 식별·해결?
- **A:** **데이터 스큐** — 부모당 자식 **1만 건 이하**로 분산, ParentId 기준 배치 그룹핑, 레코드 잠금/공유 재계산 회피.

**19. 프로필·역할 기반 다른 필드·데이터 Lightning 페이지**
- **Q:** 동적 LWC?
- **A:** LWC에서 `@salesforce/userPermission/*`·custom permission 확인해 조건부 렌더, 또는 프로필별 **다른 페이지 할당**(App Builder activation).

**20. 프로덕션에서만 트리거 오작동(샌드박스 정상)**
- **Q:** 디버그·해결?
- **A:** 프로덕션의 **데이터 볼륨/스큐·다른 데이터·거버너 한도** 차이 의심. 디버그 로그 분석, 벌크 데이터로 테스트, 풀 카피 샌드박스 재현.

**21. Lead 저장 전 외부 시스템으로 이메일 실시간 검증**
- **Q:** 콜아웃 vs Lightning 컴포넌트?
- **A:** before-save 트리거에선 동기 콜아웃 불가 → **LWC/Screen Flow에서 저장 전 Apex 임퍼러티브 콜아웃**으로 검증 후 저장.

**22. 대용량으로 리포트 한도 초과**
- **Q:** 최적화?
- **A:** 필터로 범위 축소, 요약/버킷, **Skinny Table**, 또는 대용량은 **CRM Analytics**로 이관.

**23. 수백만 건 벌크 업로드(거버너 한도 준수)**
- **Q:** 솔루션 설계?
- **A:** **Bulk API 2.0**(자동 배치·병렬) 또는 Batch Apex. 데이터 스큐·잠금 회피.

**24. 무거운 계산 + 대량 데이터셋**
- **Q:** Batch 또는 Queueable 비동기?
- **A:** 대량 레코드는 **Batch Apex**(필요 시 Stateful), 연쇄 무거운 작업은 **Queueable**. 볼륨·체이닝 요구로 선택.

**25. 다중 부모 커스텀 오브젝트(다대다)**
- **Q:** Junction 오브젝트 설계?
- **A:** **Junction 오브젝트** + 두 Master-Detail. 합계는 부모에서 롤업.

**26. 규칙 기반 Account 영역 자동 할당**
- **Q:** 선언적 또는 Apex?
- **A:** **Enterprise Territory Management** assignment rules(선언적), 복잡 규칙은 Apex.

**27. 레거시 앱 마이그레이션 + 커스텀 화면**
- **Q:** Visualforce 설계·통합?
- **A:** Visualforce(또는 신규는 **LWC**) + Apex 컨트롤러로 통합. 점진적 마이그레이션·표준 컴포넌트 우선 검토.

**28. 외부 통합으로 API 한도 근접**
- **Q:** 모니터링·최적화?
- **A:** `Limits` 클래스·**Event Monitoring**으로 모니터, 벌크화·캐싱·호출 빈도 감소·**Composite API**로 왕복 축소.

**29. 사용자 활동(로그인·API·변경) 상세 로그**
- **Q:** Event Monitoring?
- **A:** **Event Monitoring**(Shield) Event Log Files, **Login History**, **Field Audit Trail**로 활동 추적.

**30. 마이그레이션 후 데이터 정확성 검증**
- **Q:** 도구·기법?
- **A:** 레코드 수 대조, 리포트/검증 SOQL, 샘플링, 체크섬, 관계 무결성 확인.

**31. 자식 필드가 부모 필드 기준 충족 검증**
- **Q:** 접근법?
- **A:** **Master-Detail**이면 Validation Rule이 부모 필드 참조 가능. 아니면 트리거에서 부모 조회 후 검증.

**32. API 호출 일일 한도 도달**
- **Q:** 관리·최적화?
- **A:** 모니터링, Bulk/Composite로 호출 감소, 캐싱, 통합 빈도 조정, 필요 시 한도 증설 요청.

**33. 매일 활성 레코드 필드 업데이트**
- **Q:** Scheduled Apex?
- **A:** **Scheduled Apex**(Batchable + Schedulable) 또는 **Scheduled-Triggered Flow**로 매일 대상 필터·업데이트.

**34. Opportunity Stage 값 시간별 변화 분석**
- **Q:** 과거 데이터 캡처·리포트?
- **A:** 표준 **Opportunity Field History / OpportunityHistory**(스테이지 변경 추적), 또는 커스텀 스냅샷 오브젝트 + 리포트.

**35. 커뮤니티 사용자 커스텀 브랜드 로그인 페이지**
- **Q:** 생성·구성?
- **A:** **Experience Cloud** 로그인 페이지 브랜딩(로고·색·커스텀 LWC 로그인 컴포넌트), Login & Registration 설정.
