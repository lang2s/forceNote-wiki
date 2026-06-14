---
tags: [scenario, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [TCS Interview Question PPT]
---

# Salesforce 개발자 면접 질문 (Admin + 개발)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## Q1. Custom Metadata vs Custom Settings

| Custom Settings | Custom Metadata |
|---|---|
| 조직·프로필·사용자별 커스텀 데이터, 앱 캐시 노출 | 레코드가 데이터가 아닌 메타데이터로 간주, 환경 간 마이그레이션·패키징 |
| 인스턴스 메서드 접근(SOQL 회피) | Apex 트랜잭션당 무제한 SOQL |
| public/protected 가시성 | public/protected 가시성 |
| List·Hierarchy 2종(생성 후 변경 불가) | 계층 미지원 |
| 관계 필드 미지원 | 다른 메타데이터·오브젝트·필드·정적 리소스 lookup 가능 |
| 편집·구성 모두 "Configure Application" | 레코드 편집은 "Configure Application", 구성은 "Author Apex" |
| 마이그레이션 시 메타데이터만(데이터 별도 업로드) | 마이그레이션 시 연관 데이터도 배포 |
| 수식·검증·Flow·Apex·SOAP·VF·워크플로우 사용 | 선택 목록·긴 텍스트·페이지 레이아웃·검증 규칙 등 더 많은 옵션 |
| List는 검증 규칙에서 접근 불가(Hierarchy만) | — |
| Apex에서 CUD 가능 | Apex에서 CUD 불가 |
| 테스트에서 SeeAllData 필요 | 테스트에서 SeeAllData 불필요 |

메서드: List는 getAll(), getInstance(name), getValues(name). Hierarchy는 getOrgDefaults(), getInstance(UserId/profileId), getValues(...).

## Q2. Role vs Profile
| Profile | Role |
|---|---|
| 사용자가 할 수 있는 것 | 역할 계층에 따라 볼 수 있는 것 |
| 계층 없음 | 계층 방식 |
| 필수 | 비필수 |
| 오브젝트·필드 수준 보안 | 레코드 수준 보안 |
| 시스템 권한 처리 | 공유 규칙으로 특정 역할에 공유 |

> 단일 사용자에 다중 프로필·역할 할당 불가. Professional Edition은 커스텀 프로필 생성 불가.

## Q3. Data Loader vs Import Wizard
**Import Wizard:** 5만 건 이하 단순 import, 일부 표준 오브젝트(Account·Contact·Lead·Solution)+커스텀, 삭제 불가, 설치 불필요, 중복 무시 가능, 웹 기반.
**Data Loader:** 5만 건 초과 복잡 import, 모든 표준·커스텀, 삭제 가능, 설치 필요, 중복 무시 불가. 작업: Insert/Update/Upsert/Delete/Hard Delete/Export/Export All. 배치 크기 최소 1·최대 2000·기본 200.

## Q4. Flow 유형
- **Screen Flow**: 사용자 가이드·입력 수집.
- **Autolaunched Flow (No Trigger)**: Apex·프로세스·REST API로 호출, 백그라운드.
- **Record-Triggered Flow**: 레코드 생성·수정·삭제 시.
- **Schedule-Triggered Flow**: 지정 시간·빈도.
- **Platform Event-Triggered Flow**: 플랫폼 메시지 수신 시.

## Q5. Sharing Setting / OWD / Role Hierarchy / 기타

**레코드 수준 접근 4가지:** OWD → Role Hierarchy → Sharing Rule → Manual Sharing.

**OWD(조직 전체 기본값):** 모든 사용자의 최소·기준 접근. 가장 제한적으로 잠근 후 다른 도구로 선택적 개방.
- Private: 소유자·상위 역할만 보기·편집.
- Public Read Only: 모두 보기, 소유자·상위만 편집.
- Public Read/Write: 모두 보기·편집, 소유자만 삭제.
- Public Read/Write/Transfer: Case·Lead만.
- Public Full Access: Campaign만.
- Controlled by Parent: Master-Detail 자식이 부모 접근 복사.

**Role Hierarchy:** 상위 역할이 하위 소유 레코드 접근.

**Sharing Rules:** 공개 그룹·역할·영역에 접근 확장(OWD보다 엄격할 수 없음). 오브젝트당 최대 300개(criteria 기반 50개). Owner-Based·Criteria-Based.

**Manual Sharing:** share 버튼으로 수동 공유. 소유자·상위 역할·Full 접근·관리자만. OWD가 Private/Read Only일 때만 활성(Lightning 미지원).

**Groups:** Public Groups(관리자 생성), Collaborative Groups(개인 생성). 구성원: 사용자·다른 그룹·역할·영역.

**Queues:** Lead·Order·Case·Service Contract·커스텀 오브젝트 관리용. 큐 멤버가 소유권 가져갈 때까지 보관. Lead·Case만 자동 할당 규칙.

**Login Hours:** 비로그인 시간 제한. 로그인 중 시간 종료 시 현재 페이지는 보되 추가 작업 불가.

**Session Settings:** 세션 보안·만료 타임아웃(Setup → Security Controls → Session Settings).

## 개발

### 실행 순서
데이터 조회 → 시스템 검증(편집 페이지 미실행) → 사용자 정의 검증 → before 트리거 → 검증 규칙(커스텀+표준) → 중복 규칙 → 레코드 저장(미커밋) → after 트리거 → 할당 규칙 → 자동 응답 → 워크플로우(필드 업데이트 시 before/after update·시스템 검증 재실행, 커스텀 검증·중복·할당은 미실행) → 프로세스·Flow → 에스컬레이션 → 엔타이틀먼트 → 교차 오브젝트 수식 → 롤업 요약 → 기준 기반 공유 → DB 커밋 → 커밋 후 로직(이메일).

### 거버너 한도
| 항목 | 동기 | 비동기 |
|---|---|---|
| SOQL 쿼리 | 100 | 200 |
| SOQL 반환 레코드 | 50,000 | 50,000 |
| getQueryLocator 레코드 | 10,000 | 10,000 |
| SOSL 쿼리 | 20 | 20 |
| 단일 SOSL 반환 | 2,000 | 2,000 |
| DML 문 | 150 | 150 |
| DML 처리 레코드 | 10,000 | 10,000 |
| 재귀 트리거 스택 깊이 | 16 | 16 |
| 콜아웃 | 100 | 100 |
| 콜아웃 누적 타임아웃 | 120초 | 120초 |
| Future 메서드 | 50 | batch·future 0, queueable 1 |
| enqueueJob | 50 | 1 |
| sendEmail | 10 | 10 |
| 힙 크기 | 6MB | 12MB |
| CPU 시간 | 10,000ms | 60,000ms |

배치 크기: 최소 1, 최대 2000, 기본 200. 한도 유형: Per-Transaction Apex, Certified Managed Package, Platform Apex, Static Apex, Size-Specific Apex, Miscellaneous.

### 테스트 클래스를 쓰는 이유·모범 사례
코드 품질 보장, 변경 관리(75% 커버리지), 문서화, 회귀 테스트.

모범 사례: @isTest, 긍정·부정 assert, @testSetup, Test.startTest()/stopTest(), System.runAs(), seeAllData=true 회피, ID 하드코딩 금지, 200건 테스트, 최소 75%(가능하면 95%), @TestVisible(private/protected 노출), 콜아웃은 CalloutMock, 메서드당 startTest/stopTest 1개, static·void, 24시간 500회 또는 10배 제한.

### 롤업 요약 함수
Count(자식 수), Sum(필드 합), Min, Max.

### Lockout 오류
다중 로그인 실패·보안 이슈로 계정 일시 잠금. 원인: 실패 로그인, 비밀번호 정책 위반, 보안 토큰 이슈, IP 제한, 2FA 이슈. 해결: 대기, 비밀번호 재설정, 토큰 재생성, 관리자 문의.

### Reparenting
편집 불가한 부모 상세 편집. Master-Detail은 기본 reparent 불가하나 "Allow reparenting" 옵션 활성화 시 가능.

### 배포 프로세스
환경 간(개발 org·Sandbox·Production) 코드·구성 배포. 방법: Change Sets, Packages.

### Batch 클래스
5만 건 초과 처리·동기 시간 한도 우회.
```apex
global class MyBatchClass implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc) { }
    global void execute(Database.BatchableContext bc, List<sObject> records) { }
    global void finish(Database.BatchableContext bc) { }
}
```

### 예외 유형
**DmlException:** 필수 필드 누락, Mixed DML(setup·non-setup 한 트랜잭션), Invalid Data(insert에 Id 지정). **System.FinalException:** Record is read-only(after 트리거에서 Trigger.new 편집). **ListException:** index out of bounds(size로 회피). **NullPointerException:** null 역참조. **QueryException:** 행 없음/대용량 비선택 쿼리. **SObjectException:** 미쿼리 필드 접근. **LimitException:** Too Many SOQL(101), DML(151), CPU 시간, Query rows(50001) — 잡을 수 없는 하드 한도. **StringException** (Invalid Id → null 사용), **JSONException**(Wrapper로 역직렬화), **UnexpectedException**, **FlowException**.

```apex
// 필수 필드 누락 처리
try {
    Contact cont = new Contact(FirstName='ABHI');
    insert cont;
} catch(DmlException e) {
    System.debug('Exception: ' + e.getMessage());
}
```

### LWC 라이프사이클 훅
constructor(부모→자식) → connectedCallback(DOM 추가, 데이터 조회) → render(기능 오버라이드) → renderedCallback(렌더링 후, 자식→부모) → disconnectedCallback(DOM 제거, PUB-SUB) → errorCallback(오류 캐치).

### LWC 데코레이터
@api(public·반응형), @track(private 반응형), @wire(반응형 데이터 조회).

### wire vs imperative wire
wire는 서버 데이터 실시간 조회·자동 업데이트. imperative는 필요 시에만 조회·자동 미업데이트.

### SLDS 클래스
slds-button(_neutral/_brand), slds-text-heading_large, slds-form(_horizontal), slds-input(_stacked/_inline), slds-grid·slds-col, slds-card, slds-tabs, slds-modal, slds-icon, slds-spinner, slds-notify(_alert/_toast), slds-is-active, slds-hidden 등.

### Lightning Data Service (LDS)
Apex 없이 CRUD. 3개 컴포넌트: lightning-record-view-form(보기), lightning-record-edit-form(생성·편집), lightning-record-form(보기·편집·생성).

### Lightning Message Service (LMS)
Lightning 페이지에서 Visualforce·Aura·LWC 간 통신. 메시지 발행·구독.

### 프로그램: Account 저장 시 Number of Contacts만큼 Contact 생성
```apex
trigger CreateContactsOnAccountSave on Account (after insert, after update) {
    List<Contact> newContacts = new List<Contact>();
    for (Account acc : Trigger.new) {
        if(Trigger.oldMap != null
           && acc.Number_of_Contacts__c != Trigger.oldMap.get(acc.Id).Number_of_Contacts__c
           && acc.Number_of_Contacts__c > 0) {
            for (Integer i = 0; i < acc.Number_of_Contacts__c; i++) {
                newContacts.add(new Contact(AccountId=acc.Id, FirstName='Contact', LastName='Name' + i));
            }
        }
    }
    if (!newContacts.isEmpty()) insert newContacts;
}
```
