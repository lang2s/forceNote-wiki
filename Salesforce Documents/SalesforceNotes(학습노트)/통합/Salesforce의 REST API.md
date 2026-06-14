---
tags: [integration, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Rest API in Salesforce]
---

# Salesforce의 REST API

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

REST는 경량·stateless 통신. GET·POST·PUT·PATCH·DELETE. Inbound(외부→SF), Outbound(SF→외부, Apex).

## Salesforce REST API 유형
1. **SObject REST API:** 오브젝트 CRUD. `/services/data/v58.0/sobjects/Account/{Id}`
2. **Query REST API (SOQL):** SOQL 조회. `/services/data/v58.0/query?q=SELECT+...`
3. **Search REST API (SOSL):** 전체 텍스트 검색. `/services/data/v58.0/search?q=Acme`
4. **Chatter REST API:** 피드·댓글·그룹. `/services/data/v58.0/chatter/feeds`
5. **Tooling API:** 메타데이터(Apex·트리거·VF). `/services/data/v58.0/tooling/sobjects/ApexClass`
6. **Composite REST API:** 여러 요청 단일 호출. `/services/data/v58.0/composite`
7. **Batch REST API:** 다중 요청 배치. `/services/data/v58.0/composite/batch`
8. **Analytics REST API:** 리포트·대시보드. `/services/data/v58.0/analytics/reports/{id}`
9. **Connect REST API:** 외부 소셜·앱 통합. `/services/data/v58.0/connect/organization`
10. **Bulk REST API:** 대량 비동기(작업당 1,500만 건). `/services/data/v58.0/jobs/ingest`

## 표준 REST API 사용
인증: OAuth 2.0 액세스 토큰. `curl -X POST -H "Authorization: Bearer <Token>" https://.../services/data/v58.0/sobjects/Account`. Postman: Connected App 설정→토큰→엔드포인트 테스트.

## 커스텀 REST API
비즈니스 로직 노출.
```apex
@RestResource(urlMapping='/LoanEligibility/*')
global class LoanEligibilityAPI {
    @HttpPost
    global static String checkEligibility(String customerId, Decimal income) {
        // 비즈니스 로직
        return 'Eligible';
    }
}
```
메서드: @HttpGet(조회), @HttpPost(생성), @HttpPut(업데이트), @HttpPatch(upsert), @HttpDelete(삭제).
테스트: `curl -X POST -H "Authorization: Bearer <Token>" -H "Content-Type: application/json" -d '{"customerId":"12345","income":75000}' https://.../services/apexrest/LoanEligibility/`

## Inbound vs Outbound

### Inbound (외부 → Salesforce)
예: Stripe 거래 전송, 마케팅 도구 Lead 조회. OAuth 2.0·세션 ID 인증.
```apex
@RestResource(urlMapping='/PaymentAPI/*')
global class PaymentAPI {
    @HttpPost
    global static void receiveTransaction() {
        RestRequest req = RestContext.request;
        String transactionDetails = req.requestBody.toString();
        // 처리·저장
    }
}
```

### Outbound (Salesforce → 외부)
예: ERP에 주문 전송, 날씨 API 조회. Named Credentials.
```apex
public class WeatherService {
    public static void getWeather(String city) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://abc.com/animals');
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        req.setBody('{"name":"Elon Musk"}');
        HttpResponse res = new Http().send(req);
        System.debug('Response: ' + res.getBody());
    }
}
```

## 실전 사용 사례
- **Inbound:** 고객 피드백 제출, Shopify 주문 동기화.
- **Outbound:** Slack·Teams 알림, ERP 송장 전송.

## 설정·테스트
**Inbound:**

API 접근 활성화 → 커스텀 REST(@RestResource) → OAuth 2.0 → Postman 테스트.
**Outbound:**

Named Credentials → HttpRequest/Response Apex → Developer Console 테스트 → 오류 처리(404·500).

## 모범 사례
OAuth 2.0, 의미 있는 오류·상태 코드, 필요 필드만, Composite/Batch로 한도 관리, 프로필·권한 집합, 한도 모니터링, Named Credentials.

## 장점
표준 HTTP 통합, 경량·stateless, 실시간 동기화, 다중 시스템, JSON·XML, ERP·CRM·IoT.

> 대규모 통합은 Bulk·Streaming API 고려.
