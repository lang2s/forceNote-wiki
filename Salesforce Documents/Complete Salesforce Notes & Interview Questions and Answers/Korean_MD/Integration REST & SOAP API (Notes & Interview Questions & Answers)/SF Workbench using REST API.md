---
tags: [integration, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [SF Workbench using REST API]
---

# Workbench로 REST API 사용 단계별 가이드

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

> 원본은 이미지 PDF로 OCR 추출했습니다.

## Workbench란?
관리자·개발자가 Force.com API로 Salesforce 조직과 상호작용하는 웹 기반 도구 모음. 데이터 관리, SOQL 쿼리, REST API 테스트.

## Apex에서 REST API 생성
- **REST Resource 정의:** @RestResource 어노테이션.
- **URL 매핑:** urlMapping 속성.
- **HTTP 메서드 구현:** GET·POST·PUT·DELETE.

```apex
@RestResource(urlMapping='/testapi/')
global class PawanRevisionApiClass {
    // Opportunity 조회
    @HttpGet
    global static List<Opportunity> getOppRecord(){
        return [SELECT Id, Name FROM Opportunity];
    }
    // Account 생성
    @HttpPost
    global static String createAccountRecord(){
        String jsonBody = RestContext.request.requestBody.toString();
        Map<String,Object> reqMap = (Map<String,Object>) JSON.deserializeUntyped(jsonBody);
        Account acc = new Account();
        acc.Name = (String) reqMap.get('Name');
        acc.Phone = (String) reqMap.get('Phone');
        insert acc;
        return acc.Id;
    }
}
```

## Workbench에서 GET 요청
1. Workbench 로그인(Production/Sandbox 선택, 자격 증명).
2. Utilities 탭 → REST Explorer.
3. GET 선택, URL `/services/apexrest/testapi/` → Execute.
응답: Opportunity 목록 반환.

## Workbench에서 POST 요청
1. HTTP 메서드 POST 선택.
2. REST API 엔드포인트 URL 입력.
3. Request Body에 JSON 페이로드.
4. Execute.
