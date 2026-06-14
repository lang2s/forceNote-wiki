---
tags: [scenario, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Salesforce Interview Questions Important]
---

# Salesforce Q&A 질문 (종합)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## 기본 Admin

**1. Salesforce?** 클라우드 기반 CRM. Sales/Service/Marketing Cloud 등.
**2. Object?** 데이터 저장 테이블. Standard(Account·Contact·Opportunity), Custom.
**3. Profile?** 사용자 권한·필드·오브젝트 접근 제어(보기·생성·편집·삭제).
**4. Permission Set?** 프로필 외 추가 권한 부여.
**5. Role vs Profile?** Profile은 오브젝트·필드 접근, Role은 레코드 가시성(공유 규칙). 사용자당 프로필 1개, 역할 1개(선택).
**6. Record Types?** 같은 오브젝트에 사용자별 다른 페이지 레이아웃·선택 목록.
**7. Page Layout?** 필드·섹션·버튼·관련 목록 표시 제어.

## 보안·접근 제어
**8. OWD?** 레코드 기준 접근 수준. Private(소유자만), Public Read-Only, Public Read/Write, Controlled by Parent.
**9. Sharing Rules?** 역할·공개 그룹·영역에 접근 확장(OWD가 Private일 때 특정 레코드 공유).
**10. Role Hierarchy?** 상위 사용자가 하위 레코드 자동 접근.

## 자동화
**11. Workflow Rule?** 조건 충족 시 이메일·필드 업데이트·태스크·아웃바운드 메시지.
**12. Workflow vs Process Builder?** Workflow는 단순(필드·이메일·태스크·아웃바운드), Process Builder는 고급(+레코드 생성·Chatter·Apex). 둘 다 Flow로 대체 중.
**13. Flow?** 데이터 수집·레코드 생성/업데이트·복잡한 결정을 코드 없이.

## 데이터 관리
**14. Data Loader?** 벌크 import/update/delete/export(최대 500만 건).
**15. Validation Rules?** 저장 전 비즈니스 규칙 강제(데이터 품질).

## 리포트·대시보드
**16. Report?** 행·열 필터 데이터. Tabular, Summary, Matrix, Joined.
**17. Dashboard?** 여러 리포트의 시각적 표현(KPI).
**18. Queue?** 레코드 관리 책임 공유 사용자 그룹.
**19. Public Group?** 사용자·역할·그룹 모음(공유 규칙·이메일 단순화).
**20. Approval Process?** 레코드 승인 워크플로우 자동화.

## Admin 시나리오 (Flow 활용)
1. **프로필 read만, edit 필요** → Permission Set로 edit 부여(프로필 변경 없이).
2. **다른 팀 Opportunity 안 보임** → OWD·Role Hierarchy·Sharing Rules·Manual Sharing 확인.
3. **Discount 필드 특정 사용자만 편집** → FLS + 검증 규칙 `AND(ISCHANGED(Discount__c), NOT($Profile.Name = "Sales Manager"))`.
4. **Lead 미접촉 3일 후 이메일** → Record-Triggered Flow + Scheduled Path(3일 지연) + Email Alert.
5. **공유 폴더 리포트 안 보임** → 폴더 권한·오브젝트 권한·FLS 확인.
6. **중복 Account 방지** → Matching Rule + Duplicate Rule(트리거보다 권장).
7. **역할별 다른 Stage 선택 목록** → Record Type 2개.
8. **할인 20% 초과 승인** → Approval Process(기준>20%, 매니저 단계).
9. **로그인 불가** → Login History·Login Hours·IP·MFA 확인.
10. **10,000 Contact import** → Data Loader(또는 5만 건 미만은 Import Wizard).

## Apex 기본
**1. Apex?** 강타입 객체지향 언어. 트리거·컨트롤러·배치·통합·테스트.
**2. 특징?** OOP, DB 통합(SOQL·DML), 거버너 한도, 비동기 처리, 예외 처리, 트리거 실행.
**3. 데이터 타입?** Primitive, Collection(List·Set·Map), Object(sObject), Enum.
**4. 클래스·메서드?**
```apex
public class MyClass {
    public String greet(String name) { return 'Hello, ' + name; }
}
```
**5. 클래스 vs 트리거?** 클래스는 비즈니스 로직(명시 호출), 트리거는 DML 이벤트 자동 실행·벌크 자동 처리.
**6. 컬렉션?** List(순서·중복), Set(고유), Map(키-값).
**7. SOQL vs SQL?** SOQL은 JOIN 없이 관계 쿼리. `SELECT Name, Email FROM Contact WHERE LastName = 'Smith'`
**8. SOQL vs SOSL?** SOQL은 특정 오브젝트 구조화 쿼리, SOSL은 다중 오브젝트 텍스트 검색. `FIND 'John' IN ALL FIELDS RETURNING Contact(Name), Account(Name)`
**9. 거버너 한도?** SOQL 100, DML 150, CPU 10,000ms, 힙 6MB(동기)/12MB(비동기).
**10. with/without sharing?** with는 사용자 보안(공유 규칙) 강제, without은 시스템 접근.

## Apex 중급
**11. 트리거 유형?** Before(저장 전), After(저장 후).
**12. before vs after?** Before는 저장 전 값 수정, After는 레코드 ID 접근·관련 레코드 DML.
**13. 컨텍스트 변수?** Trigger.new/old, isInsert/isUpdate/isDelete/isBefore/isAfter.
**14. 재귀 트리거 방지?** static boolean 변수.
**15. Future 메서드?** 비동기 장기 작업. 별도 스레드, 콜아웃(callout=true), 값 반환·Future 호출 불가.
**16. Queueable?** 비동기·유연. 체이닝, sObject·커스텀 객체, 모니터링.
**17. Batch Apex?** 대량 데이터 청크 처리(수백만 건). QueryLocator. `Database.executeBatch(batchJob, 100)`.
**18. Future vs Queueable vs Batch?** Future(단순·콜아웃), Queueable(체이닝·복합 객체), Batch(대량·청크).
**19. insert vs Database.insert()?** insert는 오류 시 전체 중단, Database.insert(list, false)는 부분 성공·SaveResult 반환.
**20. 동기 vs 비동기 Apex?** 동기는 실시간(트리거·클래스), 비동기는 백그라운드(Future·Queueable·Batch).
**21. 거버너 한도 회피?** 벌크 SOQL, DML 최소화, 비동기, Limits 클래스.
**22. @TestVisible?** private 메서드·변수를 테스트에 노출.
**23. Custom Metadata vs Settings?** Metadata는 배포 가능 구성, Settings는 SOQL 없이 정적 설정.
**24. @isTest vs startTest/stopTest?** @isTest는 테스트 정의, startTest/stopTest는 비동기 테스트 거버너 한도 격리.
**25. 예외 처리?** try-catch, 커스텀 예외, 커스텀 오브젝트 로깅.

## Apex 고급
**26. Apex 보안 강제(CRUD/FLS/Sharing)?** 자동 강제 안 됨(수동). `Schema.sObjectType.Account.isAccessible()`, `fields.Name.isAccessible()`, with sharing.
**27. 트리거 유형 + 예제** — 중복 방지(before insert + addError), Account 후 Contact 생성(after insert).
**28. 컨텍스트 변수** — 위 13 참조.
**29. 커스텀 예외?** `public class CustomException extends Exception {}`, throw로 사용.
**30. Wrapper 클래스?** 여러 객체를 한 단위로. 예: `AccountWrapper { Account acc; Boolean isSelected; }`.
**31. Platform Events?** 실시간 이벤트 기반 통신. `new MyEvent__e(Message__c='Test')` 발행.
**32. Queueable vs Batch?** Queueable은 단순 비동기·체이닝, Batch는 대량 청크.
**33. @AuraEnabled?** Apex 메서드를 LWC/Aura에 노출(cacheable=true는 캐싱).
**34. Apex에서 REST API 호출?** Http·HttpRequest·HttpResponse.
**35. Database.Stateful vs Batchable?** Stateful은 배치 간 상태 유지, Batchable은 배치 처리 인터페이스.
**38. Dynamic SOQL?** 런타임 문자열 쿼리(`Database.query()`).
**40. Polymorphic SOQL?** `SELECT Id, WhatId, What.Name FROM Task`(WhatId가 여러 오브젝트 참조).

## 전문가
**41. Apex 트랜잭션 모델?** 단일 트랜잭션 내 모든 DML 원자적(하나 실패 시 전체 롤백).
**43. 동시 업데이트 방지?** FOR UPDATE로 레코드 잠금.
**44. 대용량(LDV)?** Batch Apex, 인덱스 필드, Skinny Table.
**47. Transaction Finalizer?** Queueable 작업 완료 후 액션·재시도.
**53. Skinny Table?** 자주 쓰는 필드를 별도 테이블로 복제해 쿼리 성능 향상.
**54. OAuth 인증?** Named Credentials, JWT, Refresh Token Flow.

## LWC
**1. LWC vs Aura?** LWC는 네이티브 JS·웹 표준·빠름, Aura는 Aura 전용 프레임워크.
**3. 주요 파일?** HTML(.html), JavaScript(.js), Meta(.js-meta.xml).
**4. .js-meta.xml?** 컴포넌트 가시성·노출 위치 제어.
**5. Shadow DOM?** 컴포넌트 캡슐화로 스타일·DOM 격리(보안 향상).
**6. 라이프사이클 훅?** constructor, connectedCallback, renderedCallback, disconnectedCallback, errorCallback.
**7. Parent→Child?** 속성 바인딩.
**8. Child→Parent?** CustomEvent.
**9. 데코레이터?** @api(public), @track(private 반응형), @wire(데이터 조회).
**11. @wire로 Apex 호출?** `@wire(apexMethod, {param})`.
**12. Imperative Apex?** 명시 호출(then/catch).
**13. @wire vs imperative?** wire는 자동·캐시·읽기, imperative는 수동·DML 가능.
**14. LDS?** Apex 없이 CRUD(lightning-record-form 등).
**15. NavigationMixin?** 페이지 간 이동.
**16. 스타일?** CSS 파일, SLDS, 인라인.
**21. 보안(CRUD/FLS)?** Apex에서 enforce, WITH SECURITY_ENFORCED.
**22. 이벤트 유형?** 표준 DOM 이벤트, CustomEvent.
**23. Platform Events in LWC?** CometD API(empApi)로 구독.
**24. REST API 통합?** Apex 콜아웃 또는 fetch.
**25. Salesforce Connect?** 외부 데이터를 외부 오브젝트로 접근.
**27. Composition vs Inheritance?** LWC는 composition(슬롯) 선호.

## 통합
**Salesforce 통합?** Salesforce를 외부 시스템과 연결.
**유형:** Data Integration(CRM·ERP 동기화), Process Integration(프로세스 연결), UI Integration(앱 통합), Security Integration(인증·접근).
**인증:** OAuth 2.0(웹 앱), JWT(서버 간), SAML(SSO).

## 시나리오 요약
- 영업·지원팀 다른 선택 목록 → Record Type.
- Opportunity 안 보임 → OWD·Role·Profile·Sharing Rules·Manual Sharing 확인.

## 면접 팁
개념 이해(암기 X), 예시 설명, Developer Org 실습, 구조적·자신감 있는 답변.
