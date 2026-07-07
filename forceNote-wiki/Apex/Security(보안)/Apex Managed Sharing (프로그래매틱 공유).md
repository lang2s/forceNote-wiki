---
tags: [apex, security, sharing, apex-managed-sharing, share-object, rowcause, recalculation]
source: salesforce_apex_developer_guide.pdf
created: 2026-07-08
aliases: [Apex Managed Sharing, 프로그래매틱 공유, __Share, Share 오브젝트, Sharing Reason, RowCause, 공유 재계산, JobShare, AccountShare]
---

# Apex Managed Sharing (프로그래매틱 공유)

> OWD Private + 선언적 공유로는 표현할 수 없는 동적 접근을, `__Share` 오브젝트에 레코드를 DML로 넣어 프로그래매틱하게 부여하는 방식. 커스텀 Sharing Reason(RowCause)로 추적하고, OWD 변경 시 배치로 재계산한다.

---

## 1. 언제 프로그래매틱 공유가 필요한가 — 3종 공유의 관계

Salesforce의 레코드 레벨 접근은 관리자가 **OWD(조직 전체 기본 공유)** 로 바닥을 깔고, 그 위에 여러 방식으로 추가 접근을 얹어 결정된다. 사용자의 최종 접근은 항상 **가장 관대한(most permissive) 레벨**이 이긴다.

Salesforce 공유는 세 종류다.

| 종류 | 부여 주체 | 예시 RowCause | 변경 가능 주체 |
|---|---|---|---|
| **Managed Sharing** (플랫폼) | 레코드 소유권·역할 계층·공유 규칙에 근거해 플랫폼이 자동 부여 | `Owner`, `Rule`, `ImplicitChild`, `ImplicitParent`, `Team`, `TerritoryRule` | UI/API/Apex로 직접 변경 불가 (implicit share) |
| **User Managed Sharing** (수동 공유) | 레코드 소유자 또는 Full Access 보유자가 단건 수동 공유 | `Manual`, `TerritoryManual` | 소유자·상위 역할·Modify All |
| **Apex Managed Sharing** (프로그래매틱) | 개발자가 Apex/SOAP API로 앱 로직에 따라 부여 | 개발자가 정의한 커스텀 Sharing Reason (`Recruiter__c` 등) | Modify All Data 보유자만 |

**프로그래매틱 공유가 필요한 지점:** OWD를 **Private**(또는 Public Read Only)로 잠근 뒤, 접근 대상이 **레코드 필드 값에 따라 동적으로 결정**돼 선언적 공유 규칙(criteria-based/owner-based sharing rule)으로는 표현할 수 없을 때. 예: "각 Job 레코드의 `Recruiter__c`/`Hiring_Manager__c` 룩업이 가리키는 사용자에게만 그 레코드 접근을 준다." 이건 규칙이 아니라 레코드별 데이터라서, 트리거에서 `Job__Share` 레코드를 만들어 부여한다.

- Apex managed sharing은 **소유자 변경(record owner change)에도 유지**된다 (수동 공유는 소유자 바뀌면 삭제됨). 이것이 Apex managed sharing과 수동 공유의 핵심 차이.
- **Modify All Data** 권한을 가진 사용자만 Apex managed sharing을 추가·변경할 수 있다.

> [!important] OWD 전제 조건
> 공유 레코드를 넣으려면 **오브젝트의 OWD가 가장 관대한 레벨이면 안 된다**(커스텀 오브젝트의 경우 Public Read/Write). 이미 전원이 Read/Write면 추가 공유는 "trivial"(무의미)해서 insert가 거부된다. 프로그래매틱 공유는 OWD Private/Public Read Only 전제에서만 의미가 있다.

> [!note] 커스텀 오브젝트 한정 기능
> **Apex Sharing Reason(커스텀 RowCause)과 Apex managed sharing 재계산은 커스텀 오브젝트에서만** 지원된다. 표준 오브젝트(`AccountShare` 등)에는 `Manual` share를 넣을 수 있지만 커스텀 Sharing Reason이나 재계산 클래스는 붙일 수 없다. 또한 Apex sharing reason은 Lightning Experience UI에서 정의할 수 없고 **Salesforce Classic**에서 만들어야 한다.

---

## 2. 레퍼런스 — `__Share` 오브젝트 구조

### Share 오브젝트 이름 규칙

접근을 프로그래매틱하게 다루려면 대상 오브젝트에 연결된 **share 오브젝트**를 쓴다.

| 대상 오브젝트 | Share 오브젝트 이름 | 규칙 |
|---|---|---|
| 표준 (Account) | `AccountShare` | `{StandardObject}Share` |
| 표준 (Contact) | `ContactShare` | `{StandardObject}Share` |
| 표준 (Lead) | `LeadShare` | `{StandardObject}Share` |
| 커스텀 (`Job__c`) | `Job__Share` | `{MyCustomObject}__Share` (커스텀은 `__c` → `__Share`) |

- **Master-Detail의 detail(자식) 오브젝트는 자체 share 오브젝트가 없다.** detail 레코드의 접근은 master의 share 오브젝트와 관계의 공유 설정으로 결정된다.
- 하나의 share 오브젝트는 세 종류(managed/user managed/Apex managed) 공유 레코드를 모두 담는다. 단, OWD·역할 계층·"View All/Modify All" 같은 **암시적(implicit) 접근은 share 오브젝트로 추적되지 않는다.**

### 모든 share 오브젝트의 프로퍼티

| 프로퍼티 | 설명 | 업데이트 가능 |
|---|---|---|
| **`{ObjectName}AccessLevel`** | 부여할 접근 레벨. 프로퍼티명은 `AccessLevel` 앞에 오브젝트명을 붙임 — 예: `LeadShare` → `LeadAccessLevel`. (커스텀은 보통 `AccessLevel` 필드로 접근) 유효값 `Edit`/`Read`/`All`. **`All`은 내부 값이라 부여 불가.** OWD보다 **더 관대한** 레벨로 설정해야 함 | — |
| **`ParentId`** | 공유 대상 레코드의 ID | ❌ 업데이트 불가 |
| **`RowCause`** | 접근을 부여하는 이유. 공유의 종류를 결정하고, 누가 이 공유 레코드를 변경할 수 있는지를 통제 | ❌ 업데이트 불가 |
| **`UserOrGroupId`** | 접근을 부여받는 사용자 또는 그룹 ID. 그룹은 public group·역할 연결 sharing group·territory group 가능 | ❌ 업데이트 불가 |

> [!note] 제약
> - **미인증 게스트 사용자에게는 Apex로 접근을 부여할 수 없다.**
> - `ParentId`/`RowCause`/`UserOrGroupId`는 insert 후 수정 불가 — 바꾸려면 삭제 후 재insert.

### AccessLevel — API 값 매핑

| UI 표시 | API Name | 의미 |
|---|---|---|
| Private | `None` | 소유자·상위 역할만 조회/편집. **`AccountShare`에만 적용** |
| Read Only | `Read` | 대상 사용자/그룹이 조회만 |
| Read/Write | `Edit` | 대상이 조회+편집 |
| Full Access | `All` | 조회·편집·이전·공유·삭제. **managed sharing으로만 부여 가능** — Apex로 부여 불가 |

### RowCause — Sharing Reason 값

**Managed Sharing** (플랫폼이 자동 생성 — Apex로 넣지 않음):

| Reason 필드 값 | rowCause 값 (Apex/API) |
|---|---|
| Account Sharing | `ImplicitChild` |
| Associated record owner or sharing | `ImplicitParent` |
| Owner | `Owner` |
| Opportunity Team | `Team` |
| Sharing Rule | `Rule` |
| Territory Assignment Rule | `TerritoryRule` |

**User Managed Sharing:**

| Reason 필드 값 | rowCause 값 (Apex/API) |
|---|---|
| Manual Sharing | `Manual` |
| Territory Manual | `TerritoryManual` (API v45.0+ Enterprise Territory Management에서는 `Territory2AssociationManual`로 대체) |

**Apex Managed Sharing:** RowCause 값은 **개발자가 정의한 커스텀 Sharing Reason** — 형식은 `MyReasonName__c` (예: `Recruiter__c`, `Hiring_Manager__c`).

프로그래매틱 참조는 `Schema.CustomObject__Share.rowCause.SharingReason__c` 형식:

```apex
// 구조 예시 — Job 오브젝트의 Recruiter Sharing Reason 참조
Schema.Job__Share.rowCause.Recruiter__c
```

---

## 3. 절차 — 커스텀 Sharing Reason 정의

Apex managed sharing은 **반드시 Apex Sharing Reason**을 써야 한다. 여러 Reason을 쓰면 공유의 update/delete 코드가 단순해지고, 같은 사용자/그룹을 다른 이유로 여러 번 공유할 수도 있다.

1. 커스텀 오브젝트의 관리 설정에서 **Apex Sharing Reasons** 관련 목록의 **New** 클릭 (Salesforce **Classic**에서).
2. **Label** 입력 — 레코드 공유를 UI에서 볼 때 Reason 열에 표시됨. Translation Workbench로 번역 가능.
3. **Name** 입력 — API/Apex에서 참조할 이름. 언더스코어·영숫자만, 문자로 시작, 공백 불가, 언더스코어로 끝나지 않고, 연속 언더스코어 불가, org 내 유니크.
4. **Save**. → `SharingReason__c` 형태로 `Schema.{Obj}__Share.rowCause.{Name}__c`로 참조 가능해진다.

---

## 4. 절차 — Share 레코드 생성·insert (수동 공유)

`__Share` sObject를 new 하고 4개 필드를 설정한 뒤 `Database.insert(..., false)`로 부분 처리(partial) insert 한다. `RowCause`를 생략하면 기본값 `Manual`이다. **`Manual` 공유만 소유자 변경 시 자동 삭제된다.**

```apex
// 출처: salesforce_apex_developer_guide.pdf — Creating User Managed Sharing Using Apex
public class JobSharing {
    public static boolean manualShareRead(Id recordId, Id userOrGroupId){
        // 커스텀 오브젝트 Job의 새 공유 오브젝트 생성
        Job__Share jobShr = new Job__Share();
        // 공유 대상 레코드 ID
        jobShr.ParentId = recordId;
        // 접근을 받을 사용자/그룹 ID
        jobShr.UserOrGroupId = userOrGroupId;
        // 접근 레벨
        jobShr.AccessLevel = 'Read';
        // rowCause를 'manual'로 — 생략 가능(기본값이 Manual)
        jobShr.RowCause = Schema.Job__Share.RowCause.Manual;
        // 공유 레코드 insert, 저장 결과 캡처
        // false = 여러 건 전달 시 부분 처리 허용
        Database.SaveResult sr = Database.insert(jobShr,false);
        if(sr.isSuccess()){
            return true;
        } else {
            Database.Error err = sr.getErrors()[0];
            // AccessLevel이 OWD보다 관대하지 않으면(trivial) FIELD_FILTER_VALIDATION_EXCEPTION
            // 이 공유는 불필요하므로 insert 예외를 허용(성공으로 간주)
            if(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION &&
               err.getMessage().contains('AccessLevel')){
                return true;
            } else {
                return false;
            }
        }
    }
}
```

**벌크 처리 관용구 핵심:** `Database.insert(list, false)` — `false`(allOrNothing=false)로 부분 성공 허용 → `SaveResult[]`를 순회하며 `isSuccess()`가 false인 건만 `getErrors()[0]`로 검사. **trivial access(OWD보다 관대하지 않은 공유)로 인한 `FIELD_FILTER_VALIDATION_EXCEPTION` + 메시지에 `AccessLevel` 포함**은 정상적 무시 대상이다. 그 외 에러만 실제 실패로 처리.

---

## 5. 절차 — 트리거에서 Apex Managed Sharing 부여

RowCause를 커스텀 Sharing Reason으로 설정하면 그 공유는 **Apex managed sharing**이 되어 소유자 변경에도 유지된다. `after insert` 트리거가 전형적 패턴이다.

```apex
// 출처: salesforce_apex_developer_guide.pdf — Apex Managed Sharing Example
trigger JobApexSharing on Job__c (after insert) {
    if(trigger.isInsert){
        List<Job__Share> jobShrs = new List<Job__Share>();
        Job__Share recruiterShr;
        Job__Share hmShr;
        for(Job__c job : trigger.new){
            recruiterShr = new Job__Share();
            hmShr = new Job__Share();
            // 공유 대상 레코드 ID
            recruiterShr.ParentId = job.Id;
            hmShr.ParentId = job.Id;
            // 접근받을 사용자 — 레코드 필드 값에서 동적으로
            recruiterShr.UserOrGroupId = job.Recruiter__c;
            hmShr.UserOrGroupId = job.Hiring_Manager__c;
            // 접근 레벨
            recruiterShr.AccessLevel = 'edit';
            hmShr.AccessLevel = 'read';
            // Apex Sharing Reason(RowCause) 지정 → Apex managed sharing으로 확정
            recruiterShr.RowCause = Schema.Job__Share.RowCause.Recruiter__c;
            hmShr.RowCause = Schema.Job__Share.RowCause.Hiring_Manager__c;
            jobShrs.add(recruiterShr);
            jobShrs.add(hmShr);
        }
        // 부분 처리 insert
        Database.SaveResult[] lsr = Database.insert(jobShrs,false);
        Integer i=0;
        for(Database.SaveResult sr : lsr){
            if(!sr.isSuccess()){
                Database.Error err = sr.getErrors()[0];
                // trivial access level 예외가 아니면 레코드에 에러 부착
                if(!(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION
                     && err.getMessage().contains('AccessLevel'))){
                    trigger.newMap.get(jobShrs[i].ParentId).
                        addError('Unable to grant sharing access due to following exception: '
                                 + err.getMessage());
                }
            }
            i++;
        }
    }
}
```

**insert가 update로 바뀌는 경우 (upsert 의미론):** 특정 상황에서 share row insert가 기존 row의 update가 된다.
- 기존 수동 공유가 `Read`인데 `Edit`(Write) 공유를 새로 넣으면, 원래 row가 `Edit`로 갱신됨(더 높은 접근 반영).
- 자식 레코드 접근으로 얻은 implicit 계정 공유가 있는데 계정 sharing rule이 생기면, rule의 RowCause(더 높은 접근)가 부모 implicit share의 RowCause를 대체.

> [!warning] Customer Community Plus(구 Customer Portal) 사용자
> `AccountShare`/`ContactShare` 등 share 오브젝트 자체는 이 사용자에게 노출되지 않는다. share 오브젝트에 DML이 필요하면 **트리거(기본 `without sharing`)** 를 쓰거나 같은 키워드의 inner/utility 클래스를 쓴다. 또한 digital experiences 활성화 후 "Roles and Subordinates"로 접근되던 Apex managed sharing은 자동으로 "Roles, Internal, and Portal Subordinates"까지 확장된다 — 외부 사용자 접근을 조이려면 코드가 **Role and Internal Subordinates** 그룹에 공유하도록 수정하고, 대규모 변환이므로 batch Apex를 고려.

---

## 6. 절차 — 소유권 변경·OWD 변경 시 재계산 (Recalculation Batch)

**언제 재계산이 필요한가:** 오브젝트의 **OWD 기본 접근 레벨이 바뀌면** Salesforce가 모든 레코드의 공유를 자동 재계산한다 — 적절하면 managed sharing을 추가하고, 부여 접근이 **redundant(잉여)** 가 된 공유는 모든 종류에서 제거한다(예: Private → Public Read Only로 바꾸면 Read Only를 주던 수동 공유는 삭제). 이때 **오브젝트에 연결된 Apex 재계산 클래스도 함께 실행**된다. 관리자는 locking 이슈로 앱 로직대로 접근이 안 부여됐을 때 수동으로 재계산을 돌릴 수도 있다.

**재계산 클래스는 `Database.Batchable`을 구현**한다 — 커스텀 오브젝트 detail 페이지의 **Apex Sharing Recalculation** 관련 목록에서 클래스를 연결하고, `Database.executeBatch`로 프로그래매틱하게도 호출할 수 있다. 실행 모니터링/중단은 Setup → Apex Jobs.

```apex
// 출처: salesforce_apex_developer_guide.pdf — Apex Managed Sharing Recalculation Example
global class JobSharingRecalc implements Database.Batchable<sObject> {
    static String emailAddress = 'admin@yourcompany.com';

    // start: 재계산 대상 레코드의 QueryLocator 반환
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, Hiring_Manager__c, Recruiter__c
                                         FROM Job__c]);
    }

    // execute: 청크마다 호출 — 기존 Apex 공유 삭제 후 새로 재구성
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        Map<ID, Job__c> jobMap = new Map<ID, Job__c>((List<Job__c>)scope);
        List<Job__Share> newJobShrs = new List<Job__Share>();
        // 이 앱의 Apex Sharing Reason을 쓰는 기존 공유만 조회 (RowCause로 필터)
        List<Job__Share> oldJobShrs = [SELECT Id FROM Job__Share WHERE ParentId IN
            :jobMap.keySet() AND
            (RowCause = :Schema.Job__Share.rowCause.Recruiter__c OR
             RowCause = :Schema.Job__Share.rowCause.Hiring_Manager__c)];
        for(Job__c job : jobMap.values()){
            Job__Share jobHMShr = new Job__Share();
            Job__Share jobRecShr = new Job__Share();
            jobHMShr.UserOrGroupId = job.Hiring_Manager__c;
            jobHMShr.AccessLevel = 'Read';
            jobHMShr.ParentId = job.Id;
            jobHMShr.RowCause = Schema.Job__Share.RowCause.Hiring_Manager__c;
            newJobShrs.add(jobHMShr);
            jobRecShr.UserOrGroupId = job.Recruiter__c;
            jobRecShr.AccessLevel = 'Edit';
            jobRecShr.ParentId = job.Id;
            jobRecShr.RowCause = Schema.Job__Share.RowCause.Recruiter__c;
            newJobShrs.add(jobRecShr);
        }
        try {
            // 기존 공유 삭제 → 처음부터 다시 기록 (delete-then-insert 관용구)
            Delete oldJobShrs;
            Database.SaveResult[] lsr = Database.insert(newJobShrs,false);
            for(Database.SaveResult sr : lsr){
                if(!sr.isSuccess()){
                    Database.Error err = sr.getErrors()[0];
                    // trivial access level 예외가 아니면 관리자에게 이메일
                    if(!(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION
                         && err.getMessage().contains('AccessLevel'))){
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setToAddresses(new String[] {emailAddress});
                        mail.setSubject('Apex Sharing Recalculation Exception');
                        mail.setPlainTextBody(
                            'The Apex sharing recalculation threw the following exception: '
                            + err.getMessage());
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    }
                }
            }
        } catch(DmlException e) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] {emailAddress});
            mail.setSubject('Apex Sharing Recalculation Exception');
            mail.setPlainTextBody(
                'The Apex sharing recalculation threw the following exception: ' + e.getMessage());
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }

    // finish: 재계산 종료 시 완료 알림 이메일
    global void finish(Database.BatchableContext BC){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {emailAddress});
        mail.setSubject('Apex Sharing Recalculation Completed.');
        // ... setPlainTextBody / sendEmail
    }
}
```

**재계산 관용구 정리:**
- `start`는 `Database.QueryLocator`로 재계산 대상 전체를 반환.
- `execute`는 청크마다 **① 이 앱의 RowCause를 가진 기존 공유만 조회·삭제 → ② 최신 필드 값으로 공유를 처음부터 재구성·insert** 하는 delete-then-insert 패턴.
- 오류는 `SaveResult` 순회에서 trivial-access 예외를 걸러내고 나머지만 이메일 알림.
- `finish`는 완료 알림.
- **소유권 변경 자체**로는 Apex managed sharing이 유지되므로 재작성이 필수는 아니지만, 필드 값(룩업 대상)이 바뀌었거나 OWD가 바뀐 뒤 정합성을 맞출 때 이 배치를 돌린다.

---

## 관련 노트

- [[Sharing 키워드 (with·without·inherited sharing)]] — 클래스 레벨 `with sharing`/`without sharing`/`inherited sharing` 실행 컨텍스트. Apex managed sharing은 "누구에게 접근을 주느냐"(레코드 공유), sharing 키워드는 "실행 중인 코드가 공유 규칙을 적용하느냐"(런타임 강제) — 서로 다른 층
- [[StripInaccessible]] — FLS(필드 레벨) 정제. Apex managed sharing은 레코드(row) 레벨 접근이고 StripInaccessible은 필드 레벨 접근 — 보완 관계
- [[WITH USER_MODE]] — SOQL/DML을 사용자 공유·FLS 모드로 실행. 공유를 부여한 뒤 조회 시 사용자 모드로 검증
- [[Apex MOC]] — Apex 섹션 전체 목차
