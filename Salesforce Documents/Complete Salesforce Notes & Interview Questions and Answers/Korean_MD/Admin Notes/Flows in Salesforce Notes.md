# Salesforce의 Flow (노트)

Flow는 시각적 인터페이스로 복잡한 비즈니스 프로세스를 구축하는 강력한 자동화 도구입니다. 코드 없이 데이터 수집, 업데이트, 의사 결정 등 다양한 작업을 자동화합니다.

## Flow 유형

1. **Screen Flow:** 사용자를 위한 안내형·대화형·시각적 프로세스. 화면을 통해 데이터 수집, 정보 제시, 작업 자동화. 단계별로 사용자를 안내하는 시나리오에 이상적.
2. **Record-Triggered Flow:** 레코드 생성·업데이트·삭제 시 자동 실행. 코드 없이 레코드 변경 기반 비즈니스 프로세스 자동화(알림, 필드 업데이트, 관련 레코드 생성 등).
3. **Schedule-Triggered Flow:** 지정된 시간이나 반복 일정에 자동 실행. 루틴 예약 작업에 이상적.
4. **Auto-Launched Flow:** 사용자 상호작용 없이 자동 실행. 보통 Apex, 다른 플로우, 예약 액션이 호출.
5. **Platform Event-Triggered Flow:** 플랫폼 이벤트 발행 시 자동 트리거. 이벤트 기반 아키텍처로 실시간 정보 통신.

## Flow 요소(Elements)

- **Screen:** 양식·필드·메시지 표시(Screen Flow)
- **Assignment:** 변수에 값 할당
- **Decision:** if-else 로직(조건별 다른 경로)
- **Loop:** 레코드 컬렉션 반복
- **Action:** Apex 호출, 이메일 전송, HTTP 요청, 서드파티 연동
- **Create/Update/Delete Records:** CRUD 작업
- **Get Records:** Salesforce 레코드 쿼리
- **Subflow:** 현재 플로우에서 다른 플로우 호출(모듈식·재사용)

## 단계별 구현

1. Flow Builder로 이동: Setup → Quick Find에 "Flows" → New Flow.
2. Flow 유형 선택(Screen, Record-Triggered, Scheduled 등).
3. 트리거 정의(Record-Triggered면 오브젝트, 트리거 조건, 진입 기준).
4. Flow 요소 추가(Assignment, Decision, Loop, Create/Update Records, Screen).
5. 로직 구성(Decision으로 분기, Assignment로 값 설정, Loop로 다중 레코드).
6. Save & Activate(Record-Triggered면 레코드 생성/업데이트로 테스트).

## 이점

- 코딩 불필요
- 유연성(플랫폼 거의 모든 부분과 상호작용)
- 재사용 가능(subflow 호출)
- 시각적 인터페이스(드래그 앤 드롭)

## 왜 Flow인가?

- 비즈니스 프로세스 자동화(단순 업데이트부터 복잡한 다단계 워크플로우)
- 사용자 상호작용 향상(Screen Flow로 안내형·동적 경험)
- 시스템·데이터 연결(다른 Salesforce 제품·외부 시스템과 통합)
- 생산성 향상(트리거 플로우로 반복 작업 제거, 오류 감소)

## 모범 사례

- 단순·모듈식 유지(공유 로직은 subflow)
- 적절한 Flow 유형 사용
- 루프·중첩 루프 최소화(컬렉션으로 대량 처리)
- 변수·컬렉션 효과적 사용
- 오류 처리(fault path, 이메일 경고·로깅)
- 성능 최적화(쿼리 제한, fast field update)
- 명명 규칙
- 문서화·버전 관리
- Screen Flow의 UX(직관적 화면, 필드 사전 채우기, 도움말)
- 정기 모니터링·테스트(샌드박스)

## 일반적인 Flow 오류와 해결

- **FLOW_ELEMENT_ERROR(Null 값 오류):** 처리 전 필수 필드 채우기. Decision 요소로 빈 값 확인.
- **UNABLE_TO_LOCK_ROW(레코드 잠금):** 같은 레코드 동시 업데이트 회피. Get Records 후 Update Records, 필요 시 비동기 실행.
- **FIELD_CUSTOM_VALIDATION_EXCEPTION(검증 규칙 실패):** ISCHANGED()나 커스텀 기준으로 Flow가 업데이트한 레코드 제외.
- **CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY(재귀 루프):** Record-Triggered Flow의 조건부 진입 기준으로 무한 루프 방지.
- **SOQL_LIMIT(DML 문 과다):** Flow 벌크화. 루프 안 SOQL 회피(한 번 조회 후 Loop 요소 사용).

## 연습 사용 사례

1. Lead 단계가 In Progress일 때 Lead Owner 승인 프로세스 플로우 생성(Lead 생성·업데이트 시)
2. 생성된 Lead의 priority가 'high'이면 Case 생성
3. Contact 업데이트 시 Account의 Phone을 Contact에 자동 채우기
4. Opportunity 단계가 'Prospecting'으로 바뀌면 Owner에게 이메일·커스텀 알림
5. Account의 primary·non-primary Contact에 이메일 전송
6. 홈 페이지에 "Hello {User.name}!" 메시지 표시
7. OpportunityLineItem에 Dispatch Date 필드 생성, 모든 제품의 Dispatch Date가 채워지면 Opportunity 단계를 'Ready to Dispatch'로 변경
