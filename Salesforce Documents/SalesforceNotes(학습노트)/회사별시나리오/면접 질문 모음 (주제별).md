---
tags: [scenario, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Interview Questions]
---

# 면접 질문 모음 (주제별)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## Batch Apex
Batch Apex란? 거버너 한도? 인터페이스란? Database.Batchable 인터페이스? 메서드들? Iterable 인터페이스? Database.QueryLocator? start 메서드 목적? Database.BatchableContext? execute 메서드와 호출 횟수·매개변수? execute에서 Future 호출 가능? 이메일·콜아웃 호출? finish 메서드? finish에서 Future·콜아웃·다른 Batch 호출? Batch 직렬화? Batch에서 Future 선언? Database.AllowsCallouts? 동시 추가 가능 작업 수? 모범 사례? 테스트 클래스 작성? Test.startTest/stopTest? Spring 15 flex 개념? 프로젝트 시나리오·선택 이유? 기본·최대·최소 배치 크기? start로 조회 가능 최대 레코드? Batch당 콜아웃 수(10)? AsyncApexJob?

**모범 사례:** 거버너 한도 준수, 한도 이슈 시 배치 크기 축소, execute당 콜아웃 10개 초과 시 배치 크기 축소.

**시나리오:** ① 25~25일 마감 Opportunity 기반 월별 커미션 계산, ② 한 달 내 만료 의약품 목록 조회·벤더 환불 이메일, ③ 사용자 비활성화 전 소유 레코드를 보고 매니저에게 재할당, ④ 15일마다 역할 변경에 따른 권한 집합 재할당(Batch).

## Schedule Apex
Schedule Apex란? Schedulable 인터페이스·메서드? SchedulableContext? CronTrigger? 작업 상태·다음 스케줄 확인? CronExpression? System.Schedule()? Schedule에서 콜아웃·Future·Batch 호출? 수동 스케줄? 거버너 한도? 모범 사례·시나리오?

## 트리거
트리거란? 이벤트? 컨텍스트 변수? before/after 트리거? before insert의 Trigger.New(읽기/쓰기·SOQL 가능?)? before insert에 Trigger.NewMap 있나? after insert의 Trigger.New 읽기/쓰기·SOQL·DML? before vs after 선택·이유? 벌크 트리거? 동일 오브젝트에 before insert 2개 작성·단점? Trigger.old vs new? Trigger.oldMap vs newMap? insert 트리거로 Account 삽입? 재귀 방지? Trigger handler 커스텀 클래스·static 플래그 이유? before vs after update 선택? delete 트리거의 Trigger.old? delete에 Trigger.New 있나? after undelete에 Trigger.old? 트리거에서 Future·콜아웃·이메일? 모범 사례? Data Loader로 1000건 삽입 시 트리거 발동 횟수? Import Wizard 시 발동? 실행 순서? 워크플로우 필드 업데이트가 트리거 발동? 수식·롤업 변경이 트리거 발동? 한 트리거가 다른 오브젝트 트리거 발동? 최소 테스트 커버리지?

**프로젝트 시나리오:** ① Opportunity Closed Won 시 소유자·매니저 이메일, ② 수직팀→수평 영업팀 이관 시 Apex 공유·OpportunityTeam 추가, ③ 새 User 생성 시 보고 매니저 이메일, ④ Opportunity 생성/수정 시 SAP 데이터 조회·업데이트.

## Future 메서드
동기·비동기 작업? Future 필요성·정의? 기본 타입 매개변수? sObject·Apex 객체 매개변수? Future 콜아웃·@future(callout=true)? Future에서 Future? Spring 15 호출 수? 트리거·Batch·Schedule에서 Future? sObject 전달 방법? MIXED_DML_Exception? Setup·Non-Setup 오브젝트? 제약·추적?

**프로젝트 시나리오:** ① 외부 시스템에서 가져온 Lead 수정 시 웹서비스로 최신 값 조회·업데이트, ② Industry='Education' Account의 Contact 생성 시 커스터머 포털 User 생성, ③ Opportunity 수정 시 VF를 PDF로 생성해 이메일 첨부.

## Custom Settings
Custom Settings란? 유형? List Custom Setting·시나리오? Hierarchy Custom Setting·시나리오? 테스트 클래스 작성?

## Remote Action & Action Support & Action Function
JavaScript 사용 이유? VF에 외부 스크립트 포함? JS로 매개변수 전달? actionFunction·매개변수·반환 타입? actionSupport·JS 호출? Remote Action·@RemoteAction·매개변수·반환·호출 방법?

## JQuery & Ajax
jQuery란? VF 포함·로드 확인? jQuery.noConflict()? `j$(document).ready()`? toggle? VF 컴포넌트 읽기? autoComplete()? Ajax·reRender? sforce.connection·sessionId·레코드 수·SOQL·DML?

**시나리오:** ① jQuery·Ajax로 동적 자동완성 VF 컴포넌트, ② Account-Contact 트리 구조.

## DML
DML이란? 벌크화? 트랜잭션당 DML 수? insert vs Database.insert? savepoint·rollback? 휴지통 비우기? upsert·merge·undelete? Mixed DML?

## SOQL
SOQL이란? 조회 최대 레코드? 부모-자식·자식-부모 쿼리? 조인? 반환 타입? Map<Id,SObject> 반환? 동기·비동기 SOQL 수? SOQL:101 해결? Aggregate 함수·AggregateResult? LIMIT vs OFFSET·OFFSET 한도? GROUP BY·필드? 별칭? IN·LIKE? 휴지통 조회? 레코드 잠금? 고유 Email 조회? count() vs count(field)? AggregateResult 읽기? 특정 Account의 Contact·Opportunity 조회? Customer__c·Loan__c 마스터 조회? 페이지네이션? 생성자에서 SOQL? Database.getQueryLocator·한도? LIMIT·OFFSET? Aggregate SOQL 레코드 카운트?

**모범 사례:** for 루프 안 SOQL 회피(100 한도), 가능하면 List 대신 Map<Id,SObject> 반환.

## 컬렉션
**Array:** 정의? 순차 메모리 할당? 요소 참조? 정적 할당? 크기? `Integer[] ages = new Integer[]{10,20,40}; ages.size();`
**List:** 정의? 기반 구조? 삽입 순서·중복? clone vs deepClone()? 요소 참조? set vs add(index, element)? 정렬·삭제?
**Set:** 정의? 기반 구조? 중복·순서? 삭제·참조? retainAll()·containsAll()? List와 차이?
**Map:** 정의? 키·값 중복? 키 집합·값 목록? containsKey()?

**시나리오:** ① List·Set로 다중 선택 목록, ② City·Places 동적 선택 목록.
