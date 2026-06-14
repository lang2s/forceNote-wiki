---
tags: [apex, async, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Future Method in Salesforce]
---

# Salesforce의 Future 메서드

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## 1. Future 메서드란?
시스템 리소스가 가용해지는 나중 시점에 별도 스레드에서 프로세스를 실행. 기술적으로 @future 어노테이션으로 비동기 메서드를 식별.

**일반적 용도:**
- **외부 웹서비스 콜아웃**: 트리거나 DML 후 콜아웃 시 future/queueable 필수. 멀티테넌트 환경에서 트리거 내 콜아웃은 DB 연결을 콜아웃 동안 열어두므로 금지.
- 자체 스레드에서 실행할 리소스 집약 계산·레코드 처리.
- 서로 다른 sObject 유형의 DML 분리로 Mixed DML 오류 방지.

## 구문
static·void만, 매개변수는 기본 타입·기본 타입 배열·기본 타입 컬렉션만(표준·커스텀 오브젝트 인수 불가). 흔한 패턴: 처리할 레코드 ID List 전달.
```apex
public class SomeClass {
    @future
    public static void someFutureMethod(List<Id> recordIds) {
        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Id IN :recordIds];
        // 레코드 처리
    }
}
```

**sObject를 매개변수로 못 쓰는 이유:** 호출 시점과 실제 실행 시점 사이에 객체가 변경될 수 있어, future 메서드가 옛 값으로 실행될 수 있기 때문.

## 콜아웃 가능?
가능. `@future(callout=true)`로 표시.
```apex
public class SMSUtils {
    @future(callout=true)
    public static void sendSMSAsync(String fromNbr, String toNbr, String m) {
        String results = sendSMS(fromNbr, toNbr, m);
        System.debug(results);
    }
    public static String sendSMS(String fromNbr, String toNbr, String m) {
        String results = SmsMessage.send(fromNbr, toNbr, m);
        insert new SMS_Log__c(to__c=toNbr, from__c=fromNbr, msg__c=results);
        return results;
    }
}
```

## 테스트 클래스
future 메서드 테스트는 startTest()와 stopTest() 사이에 코드를 둠. startTest() 후 비동기 호출이 수집되고, stopTest() 실행 시 동기 실행됨.

**Mock 응답(콜아웃 가짜 응답):**
```apex
@isTest
public class SMSCalloutMock implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"status":"success"}');
        res.setStatusCode(200);
        return res;
    }
}

@IsTest
private class Test_SMSUtils {
    @IsTest
    private static void testSendSms() {
        Test.setMock(HttpCalloutMock.class, new SMSCalloutMock());
        Test.startTest();
        SMSUtils.sendSMSAsync('111', '222', 'Greetings!');
        Test.stopTest();
        List<SMS_Log__c> logs = [SELECT msg__c FROM SMS_Log__c];
        System.assertEquals(1, logs.size());
        System.assertEquals('success', logs[0].msg__c);
    }
}
```

## 모범 사례
- future 메서드는 최대한 빨리 실행.
- 콜아웃은 별도 future가 아닌 같은 future에서 묶어 처리.
- 200건 트리거 컬렉션을 처리할 수 있는지 대규모 테스트.
- 대량 레코드는 future보다 Batch Apex 고려.

## 기억할 점
- static·void.
- 매개변수는 기본 타입(배열·컬렉션 포함)만, 객체 불가.
- 호출 순서 보장 안 됨, 동시 실행 시 같은 레코드 업데이트하면 락 발생 가능.
- Visualforce 컨트롤러의 getter/setter·생성자에서 사용 불가.
- future에서 future 호출 불가, future 실행 중 future 호출 트리거 불가.
- getContent()·getContentAsPDF() 사용 불가.
- Apex 호출당 50개 제한, 24시간 추가 한도.

## Future vs Queueable
| Future | Queueable |
|---|---|
| 어노테이션 기반(같은 클래스에 작성) | Queueable 인터페이스 구현 클래스 |
| 작업 모니터링 불가 | Job Id로 모니터링 |
| Future·Batch에서 호출 불가, 단일 호출당 50개 | 체이닝 가능(Dev org 스택 깊이 5, Enterprise 50) |
| 기본 타입만 | 기본·비기본 타입 모두 |
