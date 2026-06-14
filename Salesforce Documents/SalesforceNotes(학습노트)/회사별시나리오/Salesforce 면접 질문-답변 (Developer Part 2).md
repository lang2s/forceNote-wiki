---
tags: [scenario, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Salesforce Developer part-2]
---

# Salesforce 면접 질문/답변 (Developer Part 2)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## Q1. 실행 순서
데이터 조회 → 시스템 검증(편집 페이지 미실행) → 사용자 정의 검증 → before 트리거 → 검증 규칙(커스텀+표준) → 중복 규칙 → 레코드 저장(미커밋) → after 트리거 → 할당 규칙 → 자동 응답 → 워크플로우(필드 업데이트 시 before/after update·시스템 검증 재실행) → 프로세스·Flow → 에스컬레이션 → 엔타이틀먼트 → 교차 오브젝트 수식 → 롤업 요약 → 기준 기반 공유 → DB 커밋 → 커밋 후 로직(이메일).

## Q2. Insert vs Database.Insert
insert는 오류 시 전체 중단. Database.insert는 유연성(부분 커밋·실패 목록·롤백). `Database.insert(list, false)`는 부분 성공.

## Q3. Flow 유형
Screen Flow(가이드·입력), Autolaunched Flow(트리거 없음), Triggered Flow(Record/Schedule/Platform Event-Triggered).

## Q4. 검증 규칙
저장 전 데이터 품질 강제 자동 검사. true 반환 시 오류 표시. System Validation, Custom Validation.

## Q5. Custom Settings 기반 검증 규칙
① 계층형 Custom Setting 생성(예: My_Custom_Settings__c.Validation_Flag__c), ② 값 설정, ③ 검증 규칙에 참조:
```
NOT($Setup.My_Custom_Settings__c.Validation_Flag__c)
```
> Custom Settings는 런타임에 읽기 전용.

## LWC 이벤트 유형
1. Parent → Child(Public Method/Property), 2. Custom Event(Child → Parent), 3. Pub/Sub 또는 LMS(관계 없는 컴포넌트). VF와 통신 시 LMS.

### 1) Parent → Child
**Public Method:**
```javascript
// childComp.js
import { LightningElement, track, api } from 'lwc';
export default class ChildComponent extends LightningElement {
    @track Message;
    @api changeMessage(strString) { this.Message = strString.toUpperCase(); }
}
// ParentComponent.js
export default class ParentComponent extends LightningElement {
    handleChangeEvent(event){
        this.template.querySelector('c-child-Comp').changeMessage(event.target.value);
    }
}
```
**Public Property:**
```javascript
// c-todo-item: @api itemName;
// 부모: <c-todo-item item-name="Milk"></c-todo-item>
```

### 2) Child → Parent (Custom Event)
```javascript
// childComp.js
handleChange(event) {
    const name = event.target.value;
    this.dispatchEvent(new CustomEvent('mycustomevent', { detail: name }));
}
```
부모: `<c-child-component onmycustomevent={listenerHandler}></c-child-component>` 또는 addEventListener.

### 3) Pub/Sub & LMS
관계 없는 컴포넌트 간 통신. LMS는 VF·Aura·LWC 간(Lightning Experience만). message channel + payload.

## LDS (Lightning Data Service)
Apex 없이 CRUD. lightning-record-form/view-form/edit-form.

## 데코레이터
@api(public·반응형), @track(private 반응형), @wire(데이터 조회·재렌더링).

## SOQL 최적화·거버너 한도
**타임아웃·거버너 한도:** 과도 리소스 방지. 타임아웃(쿼리 지연 종료), 거버너 한도(트랜잭션당 SOQL·레코드 제한).
**타임아웃 회피:** WHERE·LIMIT·OFFSET 필터, 인덱스(Id·Name·OwnerId 자동, External ID·Unique 커스텀), 선택적 쿼리, Query Plan 도구.
**거버너 한도 회피:** 벌크화·컬렉션, 트리거·Batch, 캐싱·static 변수, @future·Queueable.
**모니터링:** Developer Console, Apex Debugger, Apex Profiler, Execution Overview, Salesforce Optimizer.

## Batch 체이닝
finish 메서드에서 다른 Batch 호출. 또는 Queueable.

## Setup 오브젝트
사용자 접근에 영향: ObjectPermissions, PermissionSet, PermissionSetAssignment, QueueSObject, Territory, UserRole, User.

## Mixed DML 오류 해결
같은 트랜잭션에서 setup·non-setup DML 혼합 시. 해결: Future, System.runAs(테스트), @future.
```apex
public class MixedDMLErrorDemo {
    public static void myMethod() {
        insert new Account(Name='Trailhead Titans');
        UtilFutureDemo.insertUser();  // Setup 오브젝트는 future로
    }
}
public class UtilFutureDemo {
    @future
    public static void insertUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        UserRole r = [SELECT Id FROM UserRole WHERE Name='CEO'];
        User usr = new User(alias='TraTi', email='x@gmail.com', emailencodingkey='UTF-8',
            lastname='Titans', languagelocalekey='en_US', localesidkey='en_US',
            profileid=p.Id, userroleid=r.Id, timezonesidkey='America/Los_Angeles', username='x@gmail.com');
        insert usr;
    }
}
```
테스트는 System.runAs 블록 사용.

## 비동기 Apex
- **Batch:** 5만 건 초과 청크 처리. start/execute/finish.
- **Queueable:** 비동기·체이닝·복합 객체·모니터링. Batch 대비 유연.
- **Scheduled:** 지정 시간 실행. System.schedule.
- **Future:** 비동기 장기 작업. 제약: Future 호출 불가, 기본 타입만, 50개.

## ViewState
VF 페이지 데이터가 먼저 view state 거쳐 표시. 한도 170KB(초과 시 오류). 페이지네이션(SOQL limit·offset, offset 최대 2000)으로 회피.

## Flow
**요소:** Data(Create/Update/Get/Delete), Interaction(Screen/Action/Subflow), Logic.
**Fault Connector:** 오류·예외 처리.
**디버그:** Flow Builder의 Debug 버튼(실제 실행됨).

## 인증
**SSO:** 한 번 로그인으로 여러 앱 접근(Identity Flows).
**Social Sign-On:** 소셜 미디어 자격 증명으로 로그인.
**Connected Apps:** SAML·OAuth·OpenID Connect로 외부 앱 통합·SSO.

## Aura

### Attributes (Parent→Child 데이터)
기본(String/Boolean/Decimal/Integer/Double/Date/DateTime/Long), 컬렉션(Array/List/Map/Set), Object(JSON). 필수: name·type. access: public/global/private.

### Aura 이벤트
Component Event(자식→부모), Application Event(계층 무관), Standard Event(showToast).

### Apex 메서드 호출(Aura)
`@AuraEnabled` 메서드를 컨트롤러에서 호출.

## LWC에서 Apex 호출 (2가지)

### Wire 서비스
```apex
public with sharing class DisplayDataInLWC {
    @AuraEnabled(cacheable=true)
    public static List<Account> fetchAccountUsingWire() {
        return [SELECT Id, Name, Rating FROM Account WHERE Rating = 'Hot' LIMIT 5];
    }
}
```
```javascript
import { LightningElement, wire } from 'lwc';
import fetchAccountUsingWire from "@salesforce/apex/DisplayDataInLWC.fetchAccountUsingWire";
export default class DisplayDataSample extends LightningElement {
    @wire(fetchAccountUsingWire) accounts;
}
```

### Imperative
```apex
@AuraEnabled  // cacheable=true 아님(DML 가능)
public static List<Account> fetchAccountImperative() {
    return [SELECT Id, Name, Rating FROM Account WHERE Rating = 'Hot' LIMIT 5];
}
```
```javascript
import fetchAccountImperative from "@salesforce/apex/DisplayDataInLWC.fetchAccountImperative";
export default class DisplayDataImperatively extends LightningElement {
    @track accounts; @track error;
    handleClick() {
        fetchAccountImperative()
            .then(result => { this.accounts = result; })
            .catch(error => { this.error = error; });
    }
}
```

### @wire vs Imperative
wire는 반응형(데이터 변경 시 재렌더링)·서버 호출 감소. imperative는 호출 제어·DML 가능.
