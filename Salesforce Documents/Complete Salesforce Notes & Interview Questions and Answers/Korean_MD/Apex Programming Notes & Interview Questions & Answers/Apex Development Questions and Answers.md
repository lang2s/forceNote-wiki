# Apex 개발 질문과 답변

**1. Apex 언어란?** 멀티테넌트 환경에 존재하는 다목적 프로그래밍 언어. 세계 최초의 클라우드 기반 언어. 모든 OOP 원칙을 지원하는 객체 지향 언어.

**2. Apex의 특징.** DML(내장 예외 처리), SOQL·SOSL, 레코드 잠금 메커니즘, 멀티테넌트 실행, 메타데이터 저장, Java 유사 구문, 단위 테스트·코드 커버리지, 웹·이메일 서비스, 복잡한 비즈니스 프로세스·검증 규칙, 레코드 저장 같은 작업에 커스텀 로직 추가.

**3. Apex 작성 방법.** Standard Navigation, Developer Console, Execute Anonymous Window, Eclipse IDE.

**4. Apex 실행 방법.** Execute Anonymous Window, 트리거, Visualforce 페이지, Batch Apex, Schedule 프로그래밍, 이메일 서비스, API/웹서비스.

**5. 데이터 타입.** Primitive(Integer, Long, String, Decimal, Double, Boolean, Date, DateTime, ID, Blob), SObject(Account, Contact, Lead 등).

**6. 클래스란?** 변수·함수·속성·생성자 등을 담는 물리적 엔티티/청사진. 캡슐화 달성. 이름은 문자로 시작·단어 하나·대문자 시작 권장, 중복 불가, 메타데이터 저장소에 컴파일·저장.

**7. 오브젝트란?** 클래스 멤버에 접근하는 참조(클래스의 인스턴스). 클래스당 여러 오브젝트 가능, 각자 고유 이름·메모리.

**8. 캡슐화.** 코드와 데이터를 단일 단위로 묶음. 보안 제공.

**9. 다형성.** 한 작업이 다른 방식으로 수행됨. 메서드 오버로딩·오버라이딩으로 달성.

**10. 상속.** 자식이 부모의 속성·동작을 획득. 코드 재사용, 런타임 다형성. 부모(Parent/Base/Super), 자식(Derived/Child).

**11. 추상화.** 내부 세부사항 숨기고 기능만 표시. 추상 클래스·인터페이스로 달성. 접근 수준 키워드: private, protected, public, global.

**12. this 키워드.** 클래스의 현재 인스턴스 표현.

**13. final 키워드.** 변수 값 변경 불가(상수). 클래스가 final이면 상속 불가.

**14. super 키워드.** virtual/abstract에서 확장된 클래스가 사용. 부모 생성자·메서드 재정의. override 메서드에서만 사용.

**15. virtual 키워드.** 클래스 확장·override 허용 선언. global 불가.

**16. abstract 키워드.** abstract 클래스 선언. 구현을 모를 때 메서드를 abstract로(시그니처만, 본문 없음).

**17. with sharing.** 현재 사용자의 공유 규칙을 고려해 권한에 따라 작업.

**18. without sharing.** 시스템 모드 실행, 공유 규칙·필드 보안·오브젝트 권한과 무관하게 모든 오브젝트·필드 접근.

**19. interface 키워드.** 메서드 시그니처만 있고 구현이 없는 클래스 같은 것. 다른 클래스가 모든 메서드 본문을 구현해야 함.

**20. extends.** 다른 클래스를 확장하는 클래스 정의.

**21. implements.** 인터페이스를 구현하는 클래스 선언.

**22. return.** 메서드에서 값 반환.

**23. 예외 처리(try, catch, finally, throw).** try(예외 발생 가능 블록), catch(특정 예외 처리), finally(반드시 실행), throw(예외 발생).

**24. synchronous.** 순차적. 스레드가 작업 완료를 기다린 후 다음으로. 예: 트리거.

**25. asynchronous.** 스레드가 작업 완료를 기다리지 않고 다른 작업 실행. 예: Future 어노테이션.

**26. non-static vs static.** 기본은 non-static(같은 오브젝트 범위). static은 트랜잭션 전체 범위, 클래스 이름으로 호출, 모든 오브젝트 공통 속성(회사명 등), 클래스 로딩 시 한 번 메모리 할당, static 메서드에서만 사용, 메모리 효율적.

**27. Setter.** Visualforce 페이지의 값을 Apex 변수에 저장.

**28. Getter.** name 변수 호출 시 Visualforce 페이지에 값 반환.

**29. 생성자.** 오브젝트 생성 시 호출되는 특별 메서드. 클래스와 같은 이름, public, 생성 시 한 번만 호출, 데이터 멤버 초기화.

**30-33. 컬렉션.** List(순서·중복 허용·인덱스), Set(순서 없음·중복 불가·contains 가능), Map(키-값 쌍).
- List 메서드: add, addAll, add(index, element), size, isEmpty, get, equals, remove, clear, set, getSObjectType.
- Set 메서드: add, addAll, size, isEmpty, contains, equals.
- Map 메서드: keySet, values, containsKey, get, put.

**34-40. DML 문.** Insert, Update(ID 필요), Delete(휴지통 15일 보관), Undelete(휴지통에서 복원), Upsert(Insert+Update, ID 있으면 업데이트), Merge(레코드 병합, 자식 재할당 후 삭제).

**41. DML 거버너 한도.** 단일 트랜잭션 최대 150 DML 작업(초과 시 "Too Many DML Operations: 151"), 단일 작업 최대 10,000 레코드. Bulkification으로 회피.

**42. SOQL 실행 방법.** Query Editor, Apex, Data Loader, Workbench.

**43. SOQL 유형.** Static SOQL([] 대괄호), Dynamic SOQL(런타임에 Database.query()로 문자열 생성).

**44. SOQL 절.** WHERE, GROUP BY, HAVING, ORDER BY, LIMIT, OFFSET, ALL ROWS, FOR UPDATE.

**45. SOSL.** 하나 이상의 오브젝트에서 콘텐츠 검색. 모든 텍스트·이메일·전화 필드 검색. 트리거에서 사용 회피 권장.

**47-63. Batch Apex.** 대량 데이터를 여러 배치로 나눠 별도 처리. 거버너 한도 극복, 최대 5천만 레코드. global 접근자 필수, Database.Batchable<SObject> 인터페이스 구현. start·finish는 한 번, execute는 여러 번 실행(매번 새 거버너 한도). 콜아웃 최대 100개(Database.AllowCallouts). 기본 배치 크기 200(최소 1, 최대 2,000). 비동기 작업. Database.QueryLocator(50만 레코드까지), Iterable<SObject>(한도 유지). Batch에서 다른 Batch 호출 가능. Database.Stateful로 변수 값 유지. AsyncApexJob으로 작업 추적. 큐 한도 5개.

**64-70. 이메일 서비스.** Apex 클래스로 인바운드 이메일 콘텐츠·헤더·첨부 처리하는 자동화 프로세스.
- 유형: Outbound(Salesforce→외부), Inbound(외부→Salesforce).
- Outbound: SingleEmailMessage(단일 레코드, setToAddress 최대 100, setBcc/Cc 최대 25, setSubject, setPlainTextBody, setHtmlBody), MassEmailMessage(대량, 최대 250개).
- Inbound: Messaging.InboundEmailHandler 인터페이스 구현, handleInboundEmail 메서드. Messaging.InboundEmailResult(success), Messaging.InboundEmail(fromAddress·subject·plainTextBody 등), Messaging.InboundEnvelope(to·from 주소).

**71-81. 테스트 클래스.** 단위 테스트로 버그 발견·코드 커버리지. 운영 배포 시 최소 75% 커버리지 필요(미달 시 배포 실패). @isTest 어노테이션 필수, 클래스명+'Test' 권장.
- 테스트 메서드는 static, void 반환. 이메일 전송 불가. @testSetup으로 테스트 레코드 한 번 생성. 24시간당 최대 500개 테스트 클래스 실행.
- Apex 테스트는: DB에 커밋 안 함(단 SOQL은 테스트 중 생성 레코드 찾음), 외부 콜아웃 불가, 아웃바운드 이메일 불가, SOSL 결과 없음.
- 운영 테스트 요구: 75% 실행, 모든 트리거 호출, 예외·거버너 위반 없이 실행. 단계: Positive Path(유효 입력 예외 없이 완료), End State(System.assert로 검증), Negative Path(무효 입력 예외 처리), Governors(벌크 준비, 최대 200 레코드).
- seeAllData: 기본은 기존 데이터 인식 못 함. @isTest(seeAllData=true)면 인식(가능하면 사용 금지, 자체 데이터 생성).
- Test.startTest()/stopTest(): 새 거버너 한도 세트. testMethod당 한 번. 비동기 메서드를 동기적으로 실행.
- system.runAs(): 특정 사용자 컨텍스트로 실행, Mixed DML 회피, OWD·프로필 테스트.
- assert 문: System.assertEquals(같으면 성공), assertNotEquals(다르면 성공).
- @TestVisible: private 변수·메서드를 테스트 클래스에서 접근 가능하게.

**82-104. 트리거.** 레코드 insert/update/delete 전후 실행되는 코드. DML 이벤트 시 자동 발동. Before/After. 복잡한 검증·트랜잭션 흐름. 비동기 작업.
- 이벤트: before/after insert·update·delete, after undelete.
- Before Insert(검증), After Insert(이메일 알림·관련 레코드), Before Update(검증), After Update(값 복제·알림), Before Delete(접근 검증·자식 제거), After Delete(알림·롤업 업데이트), After Undelete(알림·롤업).
- 트리거 컨텍스트 변수: isInsert, isUpdate, isDelete, isBefore, isAfter, New, Old, NewMap, OldMap, Size, isExecuting.
- 트리거에서 콜아웃: @future 비동기 메서드로 가능.
- 재귀 트리거: 같은 오브젝트에 같은 DML이 트리거 발동 조건과 같을 때 발생. static 변수로 방지.
- 벌크화: 기본적으로 모든 트리거는 벌크 트리거(배치당 200 레코드).
- 오브젝트당 여러 트리거 가능하나 하나 권장(실행 순서 제어 불가).
- 트리거에서 Batch 호출: `Database.executeBatch(new BatchClass());`
- 실행 순서: DB fetch → 시스템 검증 → before 트리거 → 커스텀 검증 → 저장 → after 트리거 → 할당 규칙 → 자동 응답 → 워크플로우(필드 업데이트 시 트리거 재발동) → 에스컬레이션 → 롤업 요약 → criteria 기반 공유 → 커밋 → 이메일.
- 트리거 일반 오류: limit 예외(SOQL 101), null pointer, 재귀 트리거, 필수 필드 누락.
- 모범 사례: 오브젝트당 트리거 하나, 복잡 로직은 Apex 클래스에 위임, 헬퍼 벌크화, 200 레코드 처리, 컬렉션으로 DML, SOQL WHERE에 컬렉션 사용, 일관된 명명(AccountTrigger).

**105. Visualforce 모범 사례.** 컴포넌트 ID 접근, page block 컴포넌트, 컨트롤러·확장, 성능 개선(Static Resources, PDF 렌더링, 컴포넌트 facet), view state 오류(transient 키워드/action region/JavaScript로 회피).

**106. Visualforce 실행 순서.** 컨트롤러 호출 → 생성자 → 메서드 → getter·setter.

**107. 데이터 손실 원인.** 다른 타입에서 Number/Percent/Currency로 마이그레이션, Date/Time 변경, 다른 타입(picklist 제외)에서 Multi-Select로, Checkbox/Auto Number/Multi-Select에서 다른 타입으로.
