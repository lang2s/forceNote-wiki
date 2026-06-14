---
tags: [scenario, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
updated: 2026-06-14
aliases: [CGI Salesforce Developer]
---

# CGI Salesforce 개발자 — 시나리오 기반 질문

> [!warning] 제3자 학습노트(시나리오 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 답변은 표준 Salesforce 기능 기준으로 작성했으나, 구현 전 공식 문서로 검증하세요.

> 형식: **Q** = 시나리오, **A** = 표준 해법.

---

**1. 다중 통화 + 기업 통화 자동 변환**
- **Q:** 다중 통화 설정과 정확한 리포팅을 어떻게 구성하나?
- **A:** Setup에서 **Multiple Currencies** 활성화 → corporate currency 지정 → **Advanced Currency Management**의 dated exchange rates로 환율 변동 반영. 리포트는 corporate currency로 환산 표시.

**2. 지역·산업별 Account를 영업 담당에 할당**
- **Q:** Enterprise Territory Management로 구현하려면?
- **A:** Territory Model 생성 → 지역/산업 기준 **assignment rules**로 Account를 Territory에 자동 배정 → Territory에 사용자 할당 → 모델 activate.

**3. 매일 외부 시스템 작업 트리거**
- **Q:** Apex Scheduler + 콜아웃 사용법은?
- **A:** `Schedulable` 클래스를 `System.schedule()`(cron)로 예약. 스케줄러에서 콜아웃을 직접 못 하므로 **Queueable(Database.AllowsCallouts)**을 enqueue해 그 안에서 HTTP 콜아웃.

**4. 두 Salesforce 조직 간 Account·Opportunity 공유**
- **Q:** Salesforce-to-Salesforce 통합 구성?
- **A:** 양쪽 org에서 **Salesforce to Salesforce** 활성화 → Connection 생성·수락 → 공유 오브젝트/필드 publish, 상대는 subscribe·매핑 → 레코드를 connection에 forward.

**5. 비즈니스 기준에 따라 특정 레코드 삭제 방지**
- **Q:** Apex 트리거 작성?
- **A:** `before delete` 트리거에서 `Trigger.old` 순회, 기준 충족 시 `record.addError('삭제 불가')`. (Validation Rule은 delete에 안 걸리므로 트리거 필요.)

**6. 컴플라이언스용 수백만 건 주간 내보내기**
- **Q:** 확장 가능·자동화 데이터 내보내기?
- **A:** **Bulk API 2.0 query job**(PK chunking)으로 추출하는 예약 통합, 또는 **Data Export Service**(주간 export) / Scheduled Apex가 외부 스토리지로 전송.

**7. 모든 예약 작업 모니터링**
- **Q:** 예약 작업을 프로그래밍으로 추적·관리?
- **A:** `CronTrigger`·`CronJobDetail` SOQL로 예약 조회, `AsyncApexJob`로 비동기 상태 확인, `System.abortJob(jobId)`로 중단.

**8. 레코드 변경 감사 추적**
- **Q:** Salesforce Shield Field Audit Trail 구현?
- **A:** Shield 라이선스 → 필드 history tracking 활성화 → **Field Audit Trail** retention policy(Metadata API `HistoryRetentionPolicy`)로 최대 10년 보관. `FieldHistoryArchive` Big Object 조회.

**9. OAuth 인증 외부 API**
- **Q:** 안전한 API 콜아웃 구현·관리?
- **A:** **Named Credential** + **External Credential**(OAuth 2.0)로 토큰·URL을 코드 밖에서 관리. 콜아웃은 `callout:MyNamedCred/path`. 하드코딩 금지.

**10. 표준 예측 모델 부적합**
- **Q:** 커스텀 예측 솔루션?
- **A:** Collaborative Forecasts가 안 맞으면 커스텀 오브젝트 + Apex 롤업/스케줄 집계로 예측 산출, 또는 **Einstein/Data Cloud** 예측 활용.

**11. 벌크 업로드 + 레코드별 검증**
- **Q:** Batch Apex 또는 Data Loader + 검증 규칙?
- **A:** 정기·복잡 검증이면 **Batch Apex**(`Database.Batchable`)에서 레코드별 검증·에러 수집. 단순하면 **Data Loader** + **Validation Rule**. 부분 성공은 `Database.insert(list, false)`.

**12. 오래된 레코드 아카이브(접근 유지)**
- **Q:** 데이터 아카이빙 전략?
- **A:** **Big Objects**로 아카이브(대용량, async SOQL 조회), 또는 외부 스토리지 + **External Objects**(OData)로 온디맨드 접근.

**13. 대용량 데이터에서 Lightning 컴포넌트 느림**
- **Q:** 성능 최적화?
- **A:** 서버측 **페이지네이션·필터링**(SOQL LIMIT/offset·cursor), `@wire` 캐싱, 지연 로딩, DOM 최소화, `lightning-datatable` 가상 스크롤.

**14. 같은 영역 사용자만 Account 가시성**
- **Q:** 영역 기반 공유 규칙?
- **A:** OWD를 **Private**로 두고 **Enterprise Territory Management**의 territory 기반 공유로 같은 territory 사용자에게만 접근 부여.

**15. 딜 단계별 다른 승인자**
- **Q:** Approval Process 또는 Flow?
- **A:** **Approval Process**의 단계별 entry criteria + step별 approver 지정, 동적 승인자는 **Flow(Submit for Approval)** + 결정 분기.

**16. 역할별 업로드 파일 접근 제한**
- **Q:** 파일 접근 권한 관리?
- **A:** 파일을 **Library(ContentWorkspace)**에 두고 라이브러리 권한으로 역할별 제어, 또는 `ContentDocumentLink`의 ShareType/Visibility 관리.

**17. 외부 ERP와 주문·송장 데이터 교환**
- **Q:** 데이터 일관성·오류 처리 통합 설계?
- **A:** REST/Platform Events 양방향 통합 + **멱등성(외부 ID upsert)**, 재시도·에러 큐, 미들웨어(MuleSoft)/Named Credential. 트랜잭션 경계·중복 방지 설계.

**18. 관련 Opportunity 합계로 Account "Customer Tier" 자동 업데이트**
- **Q:** Apex 트리거?
- **A:** Opportunity `after insert/update/delete` 트리거 → 부모 Account별 aggregate SOQL 집계 → `Account.Customer_Tier__c` 갱신. 벌크·재귀 방지.

**19. 48시간 미해결 시 Case 매니저 에스컬레이션**
- **Q:** Escalation Rules?
- **A:** **Case Escalation Rules**: 기준(Age>48h, 상태) + **Business Hours** 기반 에스컬레이션 액션(소유자 변경·알림).

**20. SOQL이 CPU 시간 한도 초과**
- **Q:** 쿼리 최적화·CPU 감소?
- **A:** **선택적 쿼리**(인덱스 필드 WHERE), 루프 내 SOQL/DML 제거, 컬렉션·Map 활용, 무거운 처리는 **비동기(Batch/Queueable)**, 불필요 필드/레코드 축소.

**21. 자주 쓰는 데이터(제품 상세) 빠른 접근**
- **Q:** Platform Cache 활용?
- **A:** **Platform Cache** Org Partition에 캐싱(`Cache.Org.put/get`), TTL 설정. 사용자별은 Session Partition.

**22. 외부 시스템 통합용 REST API**
- **Q:** 인증 오류·잘못된 요청 테스트·처리?
- **A:** `HttpResponse.getStatusCode()`로 4xx/5xx 분기·재시도, 커스텀 예외. 테스트는 **HttpCalloutMock**(`Test.setMock`)으로 성공/실패 응답 시뮬레이션.

**23. 지오로케이션 필드로 지도에 레코드 표시**
- **Q:** Lightning 컴포넌트 또는 외부 지도 API?
- **A:** **lightning-map** 베이스 컴포넌트(markers)로 Geolocation(위도/경도) 표시. 고급 요구는 Google Maps JS API를 Static Resource로 로드.

**24. 새 Lead 생성 등 이벤트 Slack 알림**
- **Q:** Salesforce-Slack 통합?
- **A:** **Flow의 Slack 액션**(Send Message to Slack) 또는 Slack 앱. record-triggered flow가 Lead 생성 시 채널에 알림.

**25. 사용자 액션·기준에 따라 동적 레코드 가시성**
- **Q:** Apex Sharing Rules?
- **A:** **Apex Managed Sharing**: `ObjectName__Share` 레코드를 코드로 insert(RowCause = Apex sharing reason)해 동적 접근 부여.

**26. 승인 단계별 고유 메시지 이메일**
- **Q:** 알림 구성?
- **A:** Approval Process 각 단계의 **Email Alert**(단계별 다른 템플릿), 또는 Flow에서 단계별 분기 후 이메일 발송.

**27. 다가오는 작업·마일스톤 자동 리마인더**
- **Q:** Scheduled Flow 또는 Apex Scheduler?
- **A:** **Scheduled-Triggered Flow**(매일 실행, 마감 임박 필터 → 알림), 복잡하면 Schedulable Apex.

**28. IoT 디바이스(센서) 데이터 처리**
- **Q:** Salesforce IoT 통합 설계?
- **A:** 디바이스 → **Platform Events**(또는 Data Cloud streaming) 수집 → 트리거/Flow 처리. 대용량은 Big Object 저장 + 비동기.

**29. 시간에 따라 변하는 필드 값 기반 공유 동적 업데이트**
- **Q:** Apex 또는 선언적 도구?
- **A:** **기준 기반(Criteria-Based) Sharing Rule**은 필드 변경 시 자동 재계산. 더 복잡하면 트리거에서 **Apex Managed Sharing** 재계산.

**30. 단계별 다른 승인자 다단계 승인**
- **Q:** Approval Process 또는 Flow?
- **A:** **Approval Process** 다단계(각 step에 approver·criteria), 동적 승인자는 사용자 필드 참조 또는 Flow 기반 승인.

**31. Master-Detail 없는 두 오브젝트 롤업 계산**
- **Q:** Apex 또는 서드파티?
- **A:** Lookup이라 Roll-Up Summary 불가 → **Apex 트리거**로 집계, 또는 **DLRS(Declarative Lookup Rollup Summaries)** 앱(선언적).

**32. 사용자 액션·선호 기반 고도 커스텀 이메일**
- **Q:** 프로그래밍 이메일 발송?
- **A:** Apex `Messaging.SingleEmailMessage`(+ 템플릿/머지 필드) 동적 조립 후 `Messaging.sendEmail()`. 대량은 거버너 한도 유의.

**33. 3개 필드 고유 조합 보장**
- **Q:** 검증 규칙 또는 트리거?
- **A:** 3필드 결합 **Unique 텍스트 필드(External ID, Unique)**를 트리거/Flow로 채워 DB 차원 고유성 강제. (Validation Rule만으로는 교차 레코드 중복 검사 불가.)

**34. 외부 시스템에서 수백만 건 가져오기**
- **Q:** 스토리지·성능 한도 없이?
- **A:** **Bulk API 2.0**(비동기 대량 ingest, ParentId 정렬로 잠금 회피, 데이터 스큐 방지). 상시 보관 불필요하면 **External Objects**(OData)로 외부에 두고 온디맨드 조회.
