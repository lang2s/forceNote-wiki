---
tags: [Apex, Namespace, sfdc_surveys, Surveys, SurveyInvitation, URL-Shortener, Feedback-Management]
source: salesforce_apex_reference_guide.pdf (v67.0)
created: 2026-05-23
aliases: [sfdc_surveys, SurveyInvitationLinkShortener, 설문 초대 URL 단축, Surveys Apex, Feedback Management]
---

# sfdc_surveys Namespace

> 설문 초대 링크를 단축하는 인터페이스 모음 — SMS·WhatsApp·Facebook Messenger 등 고객 채널에서 짧은 URL로 설문 배포

---

## 개념 설명

`sfdc_surveys` 네임스페이스는 **Salesforce Feedback Management**에서 설문 초대(Survey Invitation) URL을 단축하기 위한 인터페이스를 제공한다.

커스텀 URL 단축 서비스(Bit.ly 등)와 연동해 긴 설문 초대 링크를 짧은 URL로 변환, SMS·WhatsApp·Facebook Messenger 같은 채널에서 배포할 때 사용한다.

**라이선스 요건:** `Salesforce Feedback Management` 라이선스가 org에 활성화되어 있어야 한다.

---

## 클래스 목록

| 클래스/인터페이스 | 설명 |
|---|---|
| `SurveyInvitationLinkShortener` | 커스텀 URL 단축 구현 인터페이스 (클래스 팩토리 패턴) |

---

## SurveyInvitationLinkShortener Interface

Salesforce가 커스텀 `SurveyInvitationLinkShortener` 인스턴스를 생성할 때 호출하는 인터페이스.

**네임스페이스:** `sfdc_surveys`

### 메서드

#### getShortenedURL(var1)

설문 초대에 대한 단축 URL을 반환한다.

```apex
// 시그니처
public String getShortenedURL(String var1)
```

**파라미터:**

| 파라미터 | 타입 | 설명 |
|---|---|---|
| `var1` | `String` | 단축할 원본 설문 초대 URL |

**반환값:** `String` — 단축된 URL

---

## 코드 예제

### Bit.ly Named Credential 기반 구현

```apex
// Named Credential 'bitly'를 사용한 URL 단축 구현
public class SurveyInvitationLinkShortenerImpl 
    implements sfdc_surveys.SurveyInvitationLinkShortener {
    
    public String getShortenedURL(String invitationURL) {
        return shortenUrlUsingBitlyService(invitationURL);
    }
    
    public String shortenUrlUsingBitlyService(String invitationURL) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:bitly/v4/shorten');
        request.setMethod('POST');
        request.setHeader('Authorization', 'Bearer {!$Credential.Password}');
        request.setHeader('Accept', 'application/json');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(JSON.serialize(new Map<String, Object>{
            'group_guid' => '{!$Credential.UserName}',
            'long_url' => invitationURL
        }));
        
        Http http = new Http();
        HttpResponse res = http.send(request);
        Object result = JSON.deserializeUntyped(res.getBody());
        
        if (result instanceof Map<String, Object>) {
            Map<String, Object> resultMap = (Map<String, Object>) result;
            Object shortenedLinkVal = resultMap.get('link');
            if (shortenedLinkVal != null && shortenedLinkVal instanceof String) {
                return (String) shortenedLinkVal;
            }
        }
        // 단축 실패 시 원본 URL 반환
        return invitationURL;
    }
}
```

### SurveySubject와 SurveyInvitation 연결 (보조 유틸리티)

설문 응답이 없을 때 SurveySubject와 SurveyInvitation·SurveyResponse를 연결하는 커스텀 코드 패턴:

```apex
public class CreateEntriesInSurveyInvitationRespRL {
    
    // SurveyInvitation 생성 + SurveySubject 연결
    public static void addEntry(
        String associatedRecordId, 
        String surveyId, 
        String participantId
    ) {
        String invitationId = createSurveyInvitation(surveyId, participantId);
        createSurveySubject(invitationId, associatedRecordId);
    }
    
    // 비인증 초대장 생성 (Guest User 응답 허용)
    private static String createSurveyInvitation(String surveyId, String participantId) {
        SurveyInvitation surveyInv = new SurveyInvitation();
        surveyInv.Name = 'SurveyInvitationForCase';
        surveyInv.ParticipantId = participantId;
        surveyInv.CommunityId = '0DBRM0000004n4y'; // Experience Cloud 사이트 ID
        surveyInv.OptionsAllowGuestUserResponse = true;
        surveyInv.SurveyId = surveyId;
        insert surveyInv;
        return surveyInv.Id;
    }
    
    // 관련 레코드(케이스, Opportunity 등)에 초대장 연결
    private static void createSurveySubject(String invitationId, String associatedRecordId) {
        SurveySubject subj = new SurveySubject();
        subj.Name = 'Sur_Subject_for_invitation';
        subj.ParentId = invitationId;
        subj.SubjectId = associatedRecordId;
        insert subj;
    }
}
```

### SurveyResponse 연결 트리거 패턴

```apex
// 설문 응답 레코드에 SurveySubject 연결 트리거
trigger SurveyResponseForCaseTrigger on SurveyResponse (after insert) {
    for (SurveyResponse sr : Trigger.New) {
        SurveySubject subj = new SurveySubject();
        subj.Name = 'Sur_Subject_for_response';
        subj.ParentId = sr.Id; // SurveyResponse ID에 연결
        
        // SurveyInvitation에 연결된 SurveySubject에서 관련 레코드 ID 조회
        List<SurveySubject> surSubjList = [
            SELECT SubjectId FROM SurveySubject WHERE ParentId = :sr.InvitationId
        ];
        
        for (SurveySubject sub : surSubjList) {
            String ids = String.valueOf(sub.SubjectId).substring(0, 3);
            if ('500'.equals(ids)) { // Case 오브젝트 prefix
                subj.SubjectId = sub.SubjectId;
                insert subj;
                break;
            }
        }
    }
}
```

---

## 비교표 (설문 관련 패턴)

| 방법 | 용도 |
|---|---|
| `sfdc_surveys.SurveyInvitationLinkShortener` | 설문 초대 URL 단축 (커스텀 서비스 연동) |
| `SurveyInvitation` sObject | 설문 초대 레코드 생성 |
| `SurveySubject` sObject | 설문 초대/응답을 관련 레코드와 연결 |
| `SurveyResponse` sObject + 트리거 | 설문 응답 후처리 자동화 |

---

## 관련 노트
- [[Named Credential]]
- [[Custom REST Endpoint]]
- [[Platform Event 통합 패턴]]
