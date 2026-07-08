---
tags: [scenario, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
updated: 2026-06-14
aliases: [TCS Apex SBQ]
---

# TCS Salesforce 개발자 — Apex 시나리오 질문

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 답변·코드는 표준 Apex 기준으로 작성했으나, 구현 전 공식 문서로 검증하세요.

> 형식: **의도** = 평가 포인트, **자주 막히는 부분** = 흔한 실수, **A** = 표준 해법(구조 예시).

---

## Q: 매일 새벽 2시에 배치 작업을 실행하는 Schedulable Apex 작성
**의도:**

Schedulable 클래스, cron 표현식, 배치 작업 이해. 프로세스 자동화 능력.

**자주 막히는 부분:**

cron 표현식 미이해(2시 매일 = `0 0 2 * * ?`), 스케줄러 오류·재시도 미처리, 스케줄러 테스트 부족.

- **A:** `Schedulable`을 구현하고 `execute`에서 배치를 enqueue. cron은 `초 분 시 일 월 요일`.
```apex
// 구조 예시 — 실제 동작 코드 아님
public class NightlyJobScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new MyDataBatch(), 200);
    }
}
// 1회 예약 (매일 02:00)
// System.schedule('Nightly 2AM', '0 0 2 * * ?', new NightlyJobScheduler());
```
테스트는 `Test.startTest()`/`stopTest()`로 감싸 `System.schedule` 호출 후 `CronTrigger` 조회로 검증.

---

## Q: 외부 REST API로 HTTP 콜아웃 후 응답 처리하는 Apex 메서드
**의도:**

콜아웃, Future 메서드, 비동기 처리 이해. 외부 통합·JSON 파싱 능력.

**자주 막히는 부분:**

트리거·동기 컨텍스트에서 `@future(callout=true)` 미사용, 타임아웃·오류 응답 미처리, JSON 파싱 오류.

- **A:** 트리거 컨텍스트면 `@future(callout=true)`(또는 Queueable)로 분리, `Http`로 요청·응답 처리, 상태 코드 분기.
```apex
// 구조 예시 — 실제 동작 코드 아님
@future(callout=true)
public static void fetchData(String recordId) {
    HttpRequest req = new HttpRequest();
    req.setEndpoint('callout:My_Named_Cred/data/' + recordId);  // Named Credential
    req.setMethod('GET');
    req.setTimeout(120000);
    try {
        HttpResponse res = new Http().send(req);
        if (res.getStatusCode() == 200) {
            Map<String, Object> body = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            // ... 처리
        } else {
            // 4xx/5xx 로깅·재시도
        }
    } catch (CalloutException e) {
        // 타임아웃·연결 오류 처리
    }
}
```
테스트는 `HttpCalloutMock`(`Test.setMock`)으로 성공/실패 응답 시뮬레이션.

---

## Q: 커스텀 오브젝트 필드 변경을 추적해 관련 오브젝트(Field_History__c)에 로깅
**의도:**

트리거 로직, 필드 히스토리 추적, 커스텀 로깅 이해.

**자주 막히는 부분:**

null·누락 필드 미처리, 벌크화 안 함, 모든 변경 시나리오 미테스트.

- **A:** `after update` 트리거에서 `Trigger.oldMap`과 비교해 변경된 필드만 히스토리 레코드로 **벌크 insert**.
```apex
// 구조 예시 — 실제 동작 코드 아님
trigger TrackChanges on My_Object__c (after update) {
    List<Field_History__c> logs = new List<Field_History__c>();
    for (My_Object__c rec : Trigger.new) {
        My_Object__c old = Trigger.oldMap.get(rec.Id);
        if (rec.Status__c != old.Status__c) {  // null-safe 비교
            logs.add(new Field_History__c(
                Record__c   = rec.Id,
                Field_Name__c = 'Status__c',
                Old_Value__c  = old.Status__c,
                New_Value__c  = rec.Status__c));
        }
    }
    if (!logs.isEmpty()) insert logs;  // 루프 밖 단일 DML
}
```

---

## Q: 수신자 목록에 동적 콘텐츠(머지 필드) 이메일 발송 메서드
**의도:**

이메일 서비스, 템플릿, 동적 콘텐츠 이해.

**자주 막히는 부분:**

이메일 템플릿·머지 필드 오용, 이메일 한도(일 5,000) 미처리, 전달 테스트 부족.

- **A:** `Messaging.SingleEmailMessage`를 수신자별로 조립(또는 `setTemplateId` + `setWhatId`로 머지 필드 평가), `Messaging.sendEmail`로 **한 번에** 발송해 한도 절약.
```apex
// 구조 예시 — 실제 동작 코드 아님
public static void sendDynamicEmails(List<Contact> recipients, Id templateId) {
    List<Messaging.SingleEmailMessage> msgs = new List<Messaging.SingleEmailMessage>();
    for (Contact c : recipients) {
        Messaging.SingleEmailMessage m = new Messaging.SingleEmailMessage();
        m.setTargetObjectId(c.Id);     // 머지 필드 평가 대상
        m.setTemplateId(templateId);   // 템플릿의 머지 필드 자동 치환
        m.setSaveAsActivity(false);
        msgs.add(m);
    }
    if (!msgs.isEmpty()) Messaging.sendEmail(msgs);  // 일일 한도(5,000) 유의
}
```
테스트는 `Messaging.sendEmail`의 `SendEmailResult.isSuccess()`로 검증, `Limits.getEmailInvocations()`로 한도 확인.
