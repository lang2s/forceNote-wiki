---
tags: [apex, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Sending Emails in Apex]
---

# Apex에서 이메일 보내기

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## 1. 필요한 클래스

Messaging 네임스페이스를 사용합니다.
```apex
Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
```

## 2. 이메일 속성 설정
```apex
email.setSubject('Your Subject Here');
email.setPlainTextBody('Your email body goes here.');
email.setToAddresses(new String[]{'recipient@example.com'});
```

## 3. HTML 콘텐츠(선택)
```apex
email.setHtmlBody('<p>This is your HTML content.</p>');
```

## 4. 첨부 파일(선택)
```apex
Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
attachment.setFileName('Attachment.txt');
attachment.setBody(Blob.valueOf('Attachment content'));
email.setFileAttachments(new Messaging.EmailFileAttachment[]{attachment});
```

## 5. 이메일 전송
```apex
Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
```

## 동적 이메일 시나리오

사용자별 정보 같은 동적 콘텐츠 전송:
```apex
String recipientEmail = 'user@example.com';
String dynamicContent = 'Hello, ' + recipientEmail + '! This is your dynamic content.';
email.setToAddresses(new String[]{recipientEmail});
email.setPlainTextBody(dynamicContent);
```

## 주요 메서드

- `Messaging.SingleEmailMessage`: 단일 이메일 메시지
- `setSubject`: 제목, `setPlainTextBody`: 일반 텍스트 본문, `setHtmlBody`: HTML 본문, `setToAddresses`: 수신자 주소
- `Messaging.EmailFileAttachment`: 첨부 파일(setFileName, setBody)
- `Messaging.sendEmail`: 하나 이상의 이메일 전송

## 예외 처리와 오류 알림

try-catch로 이메일 전송 중 예외를 잡고 오류 알림 이메일을 보냅니다.
```apex
try {
    email.setSubject('Greetings from Salesforce');
    email.setPlainTextBody('Hello there!');
    email.setToAddresses(new String[]{'recipient@example.com'});
    Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
} catch (Exception e) {
    Messaging.SingleEmailMessage errorEmail = new Messaging.SingleEmailMessage();
    errorEmail.setSubject('Error Notification');
    errorEmail.setPlainTextBody('An error occurred. Error message: ' + e.getMessage());
    errorEmail.setToAddresses(new String[]{'admin@example.com'});
    Messaging.sendEmail(new Messaging.SingleEmailMessage[]{errorEmail});
}
```

## 관련 시나리오/면접 질문 15가지

1. 기본 이메일 전송, 2. 동적 이메일 콘텐츠(수신자별 인사), 3. 첨부 파일, 4. HTML 콘텐츠, 5. 예외 처리(try-catch), 6. 오류 알림 이메일, 7. 여러 수신자, 8. 이메일 템플릿 통합, 9. 예약 전송, 10. 샌드박스에서 테스트 시 주의사항, 11. 조건에 따른 동적 제목, 12. 이메일 전달 확인, 13. 병합 필드가 있는 이메일 템플릿, 14. "From" 주소 설정, 15. 대량 이메일 전송 시 고려사항·최적화.
