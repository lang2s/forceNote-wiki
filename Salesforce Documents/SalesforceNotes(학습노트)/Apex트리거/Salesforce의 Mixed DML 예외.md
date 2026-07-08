---
tags: [apex, trigger, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Mixed DML Scenerio]
---

# Salesforce의 Mixed DML 예외

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## Mixed DML 예외란?

같은 트랜잭션에서 표준 오브젝트(Account, Contact, Opportunity)와 setup 오브젝트(User, Role, Profile)에 DML 작업을 수행하려 할 때 발생합니다. Salesforce가 보안 설정과 레코드 접근 무결성을 유지해야 하기 때문이며, 두 유형을 한 트랜잭션에 섞으면 일관되지 않은 접근 제어가 생길 수 있습니다.

예: User 레코드와 Account 레코드를 동시에 업데이트하면 사용자 역할·프로필 변경이 Account 접근에 영향을 줄 수 있어 권한 충돌 발생.

## 왜 발생하나?

보안 때문입니다. Salesforce는 일반 오브젝트와 setup 오브젝트에 서로 다른 트랜잭션 제어를 사용해 올바른 접근 수준을 유지합니다.

## 일반 시나리오

- 같은 트랜잭션에서 User와 Account 생성·업데이트.
- 같은 프로세스에서 Role·Profile을 Lead·Case 같은 표준 오브젝트와 연결.

## 해결 방법

**1. 별도 트랜잭션 사용:**

DML 작업을 분리. 비동기 프로세스 활용:
- **Future Methods:** 별도 트랜잭션에서 실행.
```apex
public class DmlOperations {
    public void performStandardObjectUpdate() {
        insert new Account(Name = 'Test Account');
        updateUser();
    }
    @future
    public static void updateUser() {
        User u = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        u.LastName = 'Updated User';
        update u;
    }
}
```
- **Queueable Apex:** future와 유사하나 더 많은 제어·작업 체이닝.
```apex
public class UserUpdateJob implements Queueable {
    public void execute(QueueableContext context) {
        User u = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        u.LastName = 'Updated';
        update u;
    }
}
// AccountHandler에서: insert acc; System.enqueueJob(new UserUpdateJob());
```
- **Batch Apex:** 대용량 작업을 별도 배치로 분리.

**2. Platform Events 사용:**

한 트랜잭션에서 이벤트를 발행하고(예: Case 업데이트 후), 별도 트랜잭션에서 이벤트 트리거 Flow나 Apex 구독자로 setup 오브젝트 업데이트 처리.

## 결론

Mixed DML 예외는 보안·데이터 무결성을 위한 안전장치입니다. Future Methods, Queueable Apex, Platform Events로 트랜잭션을 분리해 충돌을 피합니다.
