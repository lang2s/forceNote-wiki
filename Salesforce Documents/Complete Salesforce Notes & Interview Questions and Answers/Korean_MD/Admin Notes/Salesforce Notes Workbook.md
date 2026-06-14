---
tags: [admin, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Salesforce Notes Workbook]
---

# Salesforce 노트 워크북 (Apex·통합·보안 종합)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## OOP 개념

Apex는 객체 지향 프로그래밍(OOP) 원칙을 지원하여 모듈식·재사용 가능·유지보수 가능한 코드를 작성하게 합니다.

**1. 클래스와 오브젝트:** 클래스는 오브젝트를 만드는 청사진(속성·메서드 정의), 오브젝트는 클래스의 인스턴스.

**추상 클래스(Abstract Class):** 직접 인스턴스화 불가, 다른 클래스의 기반 클래스. 추상 메서드(구현 없음, 서브클래스가 구현 필수)와 일반 메서드 포함 가능.
```apex
public abstract class Shape {
    public abstract Double area();
    public void display() { System.debug('This is a shape.'); }
}
public class Circle extends Shape {
    public Double radius;
    public Circle(Double radius) { this.radius = radius; }
    public override Double area() { return Math.PI * radius * radius; }
}
```

**Virtual 클래스:** Apex 클래스는 기본적으로 virtual(final이 아니면 확장 가능). 메서드를 서브클래스에서 override 가능 → 다형성.
```apex
public class Employee {
    public virtual String getRole() { return 'Employee'; }
}
public class Manager extends Employee {
    public override String getRole() { return 'Manager'; }
}
```

**인터페이스(Interface):** 구현 클래스가 따라야 할 계약 정의. 메서드 시그니처만 포함(구현 불가). 한 클래스가 여러 인터페이스 구현 가능(다중 상속).
```apex
public interface Drivable { void start(); void stop(); }
public class Car implements Drivable {
    public void start() { System.debug('Car is starting'); }
    public void stop() { System.debug('Car is stopping'); }
}
```

**Abstract vs Virtual vs Interface 비교:**

| 항목 | 추상 클래스 | Virtual 클래스 | 인터페이스 |
|---|---|---|---|
| 인스턴스화 | 직접 불가 | 직접 가능 | 직접 불가 |
| 메서드 구현 | 추상+일반 | 일반만 | 구현 불가 |
| 상속 | 한 서브클래스가 확장 | 서브클래스 확장 | 여러 클래스 구현 |
| 다중 상속 | 미지원 | 해당 없음 | 지원 |

**기타 OOP 개념:**
- **캡슐화(Encapsulation):** 오브젝트 컴포넌트 직접 접근 제한, 우발적 데이터 수정 방지.
- **상속(Inheritance):** 다른 클래스의 속성·메서드 상속, 코드 재사용.
- **다형성(Polymorphism):** 같은 이름 메서드가 오브젝트에 따라 다르게 동작. Method Overloading(같은 이름, 다른 매개변수), Method Overriding(서브클래스가 슈퍼클래스 메서드 재정의).
- **추상화(Abstraction):** 복잡한 구현을 숨기고 필요한 기능만 표시(추상 클래스·인터페이스).

## Apex 작동 방식

모든 Apex는 Lightning Platform에서 온디맨드 실행. 저장 시 추상 명령으로 컴파일되어 메타데이터에 저장. 실행 트리거 시 컴파일된 명령을 런타임 인터프리터로 처리.

## 동기 실행(Synchronous Execution)

코드가 즉시 실행되고 다음 줄로 넘어가기 전 응답을 기다림. 유형:

**1. DML 작업:** insert, update, delete, upsert, undelete. 동기적.

**2. SOQL과 SOSL 쿼리:**
- **SOQL:** Salesforce 오브젝트 쿼리. WHERE 필터, LIKE 와일드카드, ORDER BY, LIMIT, 집계 함수(COUNT), 관계 쿼리(부모-자식/자식-부모).
```apex
List<Account> accounts = [SELECT Id, Name FROM Account WHERE Name LIKE 'Ac%'];
List<Account> accounts = [SELECT Id, Name, (SELECT Id, Name FROM Contacts) FROM Account];
```
- **SOSL:** 여러 오브젝트에 걸친 텍스트 검색.
```apex
List<List<SObject>> searchResults = [FIND 'Acme' IN ALL FIELDS RETURNING Account(Id, Name), Contact(Id, Name)];
```

**SOQL vs SOSL:** SOQL은 데이터가 있는 오브젝트를 알 때, 단일/관련 오브젝트, 클래스·트리거 사용, 쿼리 결과에 DML 가능, 레코드 반환, 카운트 가능. SOSL은 오브젝트가 불확실할 때, 여러 오브젝트·필드, 클래스·익명 블록만, DML 불가, 필드 반환, 카운트 불가.

**3. 트리거:** 동기 실행. before/after 트리거. 이벤트: before/after insert/update/delete, after undelete.

**트리거 컨텍스트 변수:** Trigger.operationType, isExecuting, isInsert/isUpdate/isDelete, isBefore/isAfter, new/old, newMap/oldMap, size.

| Trigger.X | insert | update | delete | undelete |
|---|---|---|---|---|
| new | before·after | before·after | - | after |
| old | - | before·after | before·after | - |
| newMap | after | before·after | - | after |
| oldMap | - | before·after | before·after | - |

**트리거 모범 사례:** 트리거 프레임워크(Handler 패턴) 사용, 루프 안 SOQL/DML 회피, 코드 벌크화, 컨텍스트별 핸들러 메서드, 철저한 테스트.

**4. 동기 웹 서비스 콜아웃:** 응답이 필요할 때.
```apex
HttpRequest req = new HttpRequest();
req.setEndpoint('https://api.example.com/data');
req.setMethod('GET');
HttpResponse res = new Http().send(req);
```

## 비동기 실행(Asynchronous Execution)

메인 프로그램 흐름과 독립적으로 실행. 시간이 오래 걸리는 작업(복잡한 계산, 대량 데이터, 외부 통합)에 유용.

**1. Future Methods:** 백그라운드 비동기 실행. static이며 void만 반환. 매개변수는 primitive 타입(또는 컬렉션). 다른 future/batch/scheduled에서 호출 불가. 24시간당 250,000회 한도. 실행 순서 보장 안 됨. 주 용도: 웹 서비스 콜아웃, 장시간 프로세스, 대량 데이터.
```apex
public class HttpCalloutClass {
    @future(callout=true)
    public static void makeHttpCallout(String endpoint) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint); req.setMethod('GET');
        HttpResponse res = new Http().send(req);
    }
}
```

**2. Batch Apex:** 대량 데이터(최대 5천만 레코드)를 청크로 처리. Database.Batchable 인터페이스 구현(start, execute, finish). 기본 배치 크기 200(1~2,000). 각 배치는 별도 트랜잭션.
```apex
public class AccountBatchUpdate implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, Name FROM Account');
    }
    public void execute(Database.BatchableContext bc, List<Account> scope) {
        for (Account acc : scope) { acc.Name = 'NewName' + acc.Id; }
        update scope;
    }
    public void finish(Database.BatchableContext bc) { System.debug('Batch job completed.'); }
}
// 실행: Database.executeBatch(new AccountBatchUpdate(), 200);
```
관련 인터페이스: Database.AllowCallouts(콜아웃), Database.Stateful(상태 유지), Database.BatchableContext(getJobId 등), Database.QueryLocator(5만+ 레코드), Iterable<sObject>(커스텀 컬렉션).

**3. Queueable Apex:** future보다 유연(작업 체이닝, 복잡한 데이터 타입 지원). Queueable 인터페이스. 트랜잭션당 50개 큐 추가, 250,000개 큐 한도.
```apex
public class MyQueueableClass implements Queueable {
    public void execute(QueueableContext context) {
        Account acc = [SELECT Id, Name FROM Account WHERE Id = :someId];
        acc.Name = 'Updated by Queueable Apex'; update acc;
    }
}
// 실행: System.enqueueJob(new MyQueueableClass());
```

**Queueable vs Batch Apex:** Queueable은 작은 작업·체이닝·복잡한 타입·FIFO, Batch는 대용량·Database.Batchable·병렬/순차·Stateful 지원·최대 5개 동시 실행.

**4. Scheduled Apex:** 특정 시간·간격에 실행. Schedulable 인터페이스, cron 표현식.
```apex
public class ScheduledAccountUpdate implements Schedulable {
    public void execute(SchedulableContext sc) { /* 로직 */ }
}
// 예약: System.schedule('Job', '0 0 23 * * ?', new ScheduledAccountUpdate());
```
**Cron 표현식:** 초(0-59) 분(0-59) 시(0-23) 일(1-31) 월(1-12) 요일(1-7) [연도]. 예: 매일 자정 `0 0 0 * * ?`, 매시간 `0 0 * * * ?`, 매주 월 8시 `0 0 8 ? * MON`. 모니터링: Setup → Scheduled Jobs. 취소: System.abortJob(jobId).

**비동기 메서드 비교:** Future(콜아웃·단순, 체이닝 X), Batch(대용량, 트랜잭션 제어), Queueable(체인·복잡, 트랜잭션 제어), Scheduled(예약·주기).

## 실행 순서(Order of Execution)

1) 시스템 검증 규칙 → 2) Before 트리거 → 3) 커스텀 검증 규칙 → 4) Duplicate 규칙 → 5) DB 저장(미커밋) → 6) After 트리거 → 7) 할당 규칙 → 8) 자동 응답 규칙 → 9) 워크플로우 규칙(필드 업데이트 시 before/after 트리거 1회 재실행) → 10) Process Builder의 프로세스·플로우 → 11) 에스컬레이션 규칙 → 12) 엔타이틀먼트 규칙 → 13) 롤업 요약·크로스 오브젝트 워크플로우(부모 업데이트) → 14) 부모 롤업 요약(재귀) → 15) Criteria-Based Sharing 규칙 → 16) 커밋 → 17) 커밋 후 로직(이메일).

## 거버너 한도(주요)

- SOQL 쿼리: 100(동기)/200(비동기), 레코드 50,000
- SOSL 쿼리: 20, 단일 SOSL 레코드 2,000
- DML 문: 150, DML 레코드 10,000
- 콜아웃: 100, sendEmail: 10
- Heap: 6MB(동기)/12MB(비동기)
- CPU 시간: 10,000ms(동기)/60,000ms(비동기)
- 실행 코드 문: 200,000(동기)/1,000,000(비동기)
- Apex 클래스·트리거: 조직당 각 5,000
- Batch Apex 큐: 5개 활성/대기
- Future 호출: 24시간당 250,000(또는 라이선스×200)
- 단일 이메일 수신자 5,000/이메일, 일일 5,000건, 대량 이메일 일일 500건
- 콜아웃 타임아웃 120초, 트랜잭션당 enqueueJob 50개

**한도 회피 모범 사례:** 코드 벌크화, 컬렉션·효율적 쿼리, 루프 안 SOQL/DML 회피, 효율적 오류 처리, @future·Batch·Queueable 적절히 사용, 사용량 모니터링, 데이터 모델 최적화.

**거버너 한도 이유:** 멀티테넌트 환경에서 공유 리소스의 효율적·공정한 사용 보장. 한 고객의 자원 독점 방지.

## Managed vs Unmanaged 패키지

| 속성 | Managed | Unmanaged |
|---|---|---|
| 업그레이드 | 제공자가 자동 업그레이드 | 제거 후 재설치 필요 |
| 커스터마이징 | 코드·메타데이터 변경 불가 | 변경 가능 |
| 조직 한도 | 한도에 미포함 | 앱·탭·오브젝트 한도에 포함 |

## Salesforce API

- **REST API:** RESTful 원칙, CRUD, SOQL 쿼리, 복합 리소스·배치. 웹·모바일 통합.
- **SOAP API:** 표준 기반 웹 서비스, 전체 CRUD, 엔터프라이즈 시스템 통합.
- **Bulk API:** 대량 데이터 비동기 처리, 배치·작업 모니터링. 대량 임포트·업데이트·삭제.
- **Streaming API:** 거의 실시간 변경 알림(CometD), PushTopic. 실시간 대시보드·이벤트 통합.
- **Metadata API:** 메타데이터 검색·배포·생성·삭제. 샌드박스→운영 배포 자동화.
- **Tooling API:** 개발자 도구, 메타데이터·디버그 로그·Apex·Lightning 접근.
- **Apex REST API:** 커스텀 Apex 클래스를 RESTful 웹 서비스로 노출.

## 리포트

커스터마이징 가능한 데이터 뷰. 생성: 리포트 타입 선택 → 필터 → 열 커스터마이징 → 그룹·요약 → 실행·미리보기 → 저장·공유. 기능: Drill-Down, 차트·그래프, 예약 새로고침.

**유형:** Tabular(단순 표, 최대 2,000행), Summary(그룹·소계·평균), Matrix(행·열 그리드), Joined(여러 블록), Cross-Tab(교차표), Summary Matrix(요약+행렬).

## 대시보드

차트·그래프·표·메트릭으로 데이터 시각화. 생성: 소스 리포트 선택 → 컴포넌트 추가 → 배치·커스터마이징 → 미리보기 → 저장·공유. 기능: 실시간 데이터, 대화형 필터, Drill-Down/Across.

**유형:** Standard(기본), Dynamic(사용자별 개인화), Custom(완전 커스터마이징), Operational(실시간 운영 모니터링), Executive(경영진 고수준 뷰).

**사용 사례:** 영업 성과 모니터링, 서비스 케이스 분석, 마케팅 캠페인 효과, 경영진 대시보드.

## 데이터 보안 모델

**프로필 구성:** 오브젝트 권한(CRUD), 필드 수준 보안, 탭 설정(Default On/Off/Hidden), 앱 설정, 레코드 타입, 페이지 레이아웃, 사용자 권한(일반·관리·커스텀), 로그인 시간·IP 제한.

**표준 프로필:** System Administrator, Standard User, Read Only, Solution Manager, Marketing User.

**권한 집합:** 프로필 변경 없이 접근 확장. 세분화된 제어(오브젝트·필드·사용자·앱·Apex·VF 권한), 유연한 할당(여러 개), 임시 권한.

### 보안 계층

1. **조직 수준:** 로그인 접근 정책(IP 제한, 로그인 시간), 2FA.
2. **오브젝트 수준:** 프로필, 권한 집합.
3. **필드 수준:** 필드 접근성(프로필·권한 집합).
4. **레코드 수준:**
   - **OWD:** 기준 접근. Private, Public Read Only, Public Read/Write, Public Read/Write/Transfer(Lead·Case), Controlled by Parent.
   - **Role Hierarchy:** 상위 사용자가 하위 레코드 접근. OWD와 함께 작동(필드 수준 보안은 무시 안 함).
   - **Sharing Rules:** Owner-Based, Criteria-Based. Read Only/Read/Write. 대상: Public Group, Role, Roles & Subordinates, Territory.
   - **Manual Sharing:** 개별 레코드를 특정 사용자/그룹과 공유. 소유자·상위·관리자·전체 접근자가 가능. Read Only/Read/Write/Full Access.
   - **Sharing Sets:** 커뮤니티(Experience Cloud) 전용. 계정·연락처 관계 기반 자동 공유.
   - **Apex Sharing:** 프로그래밍 방식 접근 부여·취소. share/unshare 메서드.
```apex
AccountShare recordShare = new AccountShare();
recordShare.ParentId = recordId;
recordShare.UserOrGroupId = userId;
recordShare.AccountAccessLevel = 'Read';
recordShare.OpportunityAccessLevel = 'None';
insert recordShare;
```

## Flow

포인트 앤 클릭 시각적 디자이너로 비즈니스 프로세스 자동화. 드래그 앤 드롭 요소, 재사용 컴포넌트(subflow), 통합(Process Builder·Apex·외부), 모바일 지원.

**유형:** Screen Flow(사용자 입력), Schedule-Triggered Flow(예약), Record-Triggered Flow(레코드 변경), Platform Event-Triggered Flow(이벤트, 최대 2K 메시지), Auto-Launched Flow(Apex·REST API·Process Builder 호출).

- **Screen Flow:** 사용자 입력이 필요할 때. 컴포넌트: Text area, Picklist, Lookup, Name, Radio, Checkbox, Date/Time.
- **Record-Triggered Flow:** 트리거 레코드에 추가 업데이트. 생성/업데이트/생성·업데이트/삭제 시. 트리거 레코드 필드 값만 변경 가능, 다른 레코드 업데이트 불가, Assignment·Decision·Loop·Get Records만 지원.

**Flow에서 Apex 호출:** @InvocableMethod 어노테이션으로 invocable 메서드 정의 → Flow에 Apex Action 추가.
```apex
public with sharing class MyApexClass {
    @InvocableMethod(label='My Invocable Method')
    public static List<MyWrapperClass> myMethod(List<String> inputParams) {
        return myResultList;
    }
}
```

## Salesforce 통합

**핵심 개념:** 데이터 통합, 프로세스 통합, UI 통합, 인증·보안, API·통합 도구.

**REST API:** REST 아키텍처 스타일. 표준 HTTP 메서드(GET·POST·PUT·DELETE), URL 리소스, JSON/XML. 장점: 경량, 유연, stateless, 캐싱, 웹 표준. 사용: 모바일 앱, 웹 서비스, SPA, IoT.

**SOAP API:** 프로토콜. XML 메시지, WSDL 계약. 장점: 형식 계약, 보안(WS-Security), 신뢰 메시징, 상호운용성, 도구 지원. 사용: 엔터프라이즈 통합, 레거시 시스템, 정부·헬스케어, 금융.

**REST vs SOAP 선택:** REST는 경량·stateless·확장 가능 웹 서비스(모던 웹·모바일), SOAP는 복잡한 엔터프라이즈 통합(형식 계약·보안·신뢰 메시징).

**주요 용어:** Authorization(권한 부여), Authentication(인증), Web Services, Named Credential(외부 인증 안전 저장), Auth Provider(외부 ID 제공자 SSO), Connected App(API·OAuth 통합 외부 앱), JWT(JSON 보안 토큰), OAuth/OAuth 2.0(토큰 기반 인증·권한).

**통합용 Apex 어노테이션:**
- `@RestResource(urlMapping='/myApi/*')`: Apex 클래스를 REST 웹 서비스로 정의.
- `@HttpGet, @HttpPost, @HttpPut, @HttpDelete`: HTTP 메서드 처리.
- `@HttpHeader`: 커스텀 HTTP 헤더.
- compression='GZIP' 속성으로 응답 압축.

```apex
@RestResource(urlMapping='/myApi/*')
global class MyRestResource {
    @HttpGet global static String doGet() { /* GET 로직 */ }
    @HttpPost global static String doPost(String requestBody) { /* POST 로직 */ }
}
```

**HTTP 콜아웃 예시:**
```apex
public class HttpCalloutExample {
    public static void makeHttpCallout() {
        String endpoint = 'https://jsonplaceholder.typicode.com/posts/1';
        HttpRequest request = new HttpRequest();
        request.setMethod('GET'); request.setEndpoint(endpoint);
        Http http = new Http();
        try {
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200) {
                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                System.debug('Title: ' + (String) jsonResponse.get('title'));
            } else {
                System.debug('HTTP callout failed: ' + response.getStatusCode());
            }
        } catch (Exception e) { System.debug('Error: ' + e.getMessage()); }
    }
}
```

**SOAP vs REST:** SOAP은 프로토콜(XML만, 자체 보안, 엄격한 표준), REST는 아키텍처 스타일(URI, 다양한 형식, 전송 보안 상속, 더 선호됨).

**JSON vs XML:** JSON은 타입 있음(String·number·Object·Boolean), 값 검색 쉬움, 네임스페이스 미지원, 덜 안전. XML은 타입 없음, 값 검색 어려움, 네임스페이스 지원, 더 안전.

## Salesforce 라이선스 유형

| 유형 | 설명 | 사용 사례 |
|---|---|---|
| Salesforce | 표준 기능 전체 접근 | 종합 CRM 필요 사용자 |
| Salesforce Platform | 커스텀 앱+제한적 CRM | 커스텀 앱 접근 사용자 |
| Chatter Free | 내부 사용자 Chatter 기본 접근 | 협업만 필요한 직원 |
| Chatter External | 외부 사용자 Chatter | 외부 협업자 |
| Customer Community | 고객 커뮤니티(제한적 CRM) | 외부 고객 |
| Customer Community Plus | 향상된 외부 고객 접근(리포트·대시보드) | 고급 커뮤니티 외부 사용자 |
| Partner Community | 파트너 종합 접근(영업 데이터) | 파트너·리셀러 |
| Health Cloud | 헬스케어 맞춤 | 헬스케어 제공자 |
| Financial Services Cloud | 금융 서비스 맞춤 | 금융 어드바이저 |
| Service Cloud | 고객 서비스 전체 접근 | 고객 서비스 담당자 |
| Sales Cloud | 영업 전체 접근 | 영업 담당자·관리자 |
| Einstein Analytics | 고급 분석·AI 인사이트 | 분석·시각화 사용자 |
| Pardot | 마케팅 자동화 | 마케팅팀 |
| CPQ | 제품 구성·가격·견적 | 영업팀 |
| Salesforce Developer | 개발 도구·환경 | 개발자 |
| Salesforce Administrator | 관리·설정 기능 | 관리자 |
