---
tags: [apex, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Secure Apex Callouts to External Salesforce Orgs]
---

# 외부 Salesforce 조직으로의 안전한 Apex 콜아웃: 단계별 가이드

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

Apex에서 다른 Salesforce 조직에 콜아웃하는 절차:

## 1. 조직 간 인증 설정

OAuth 2.0 JWT Bearer Token Flow로 조직 간 안전하게 연결합니다. 대상 조직에 connected app 구성이 필요합니다.

## 2. 대상 조직에 Connected App 생성

- Setup → App Manager → New Connected App
- OAuth 스코프(Full Access 또는 API)로 API 접근 설정
- JWT Token Exchange 활성화, Consumer Key·Consumer Secret 기록
- 소스 조직의 인증서를 connected app에 추가

## 3. JWT 토큰 생성

X.509 인증서로 Apex에서 JWT 토큰에 서명합니다. JWT 토큰을 대상 조직에 보내 access token을 얻습니다.

```apex
public static String generateJWT(String consumerKey, String username) {
    Long exp = DateTime.now().getTime() / 1000 + 300; // 5분 후
    Map<String, Object> claims = new Map<String, Object>();
    claims.put('iss', consumerKey);
    claims.put('sub', username);
    claims.put('aud', 'https://login.salesforce.com');
    claims.put('exp', exp);
    Blob privateKey = EncodingUtil.base64Decode('<YOUR_BASE64_ENCODED_PRIVATE_KEY>');
    Blob jwtHeader = Blob.valueOf('{"alg":"RS256","typ":"JWT"}');
    String jwtBody = JSON.serialize(claims);
    Blob jwtToken = EncodingUtil.urlEncode(
        EncodingUtil.base64Encode(jwtHeader) + '.' + EncodingUtil.base64Encode(Blob.valueOf(jwtBody)), 'UTF-8');
    Blob signature = Crypto.sign('RSA-SHA256', jwtToken, privateKey);
    return jwtToken + '.' + EncodingUtil.base64Encode(signature);
}
```

## 4. Access Token 획득

생성한 JWT로 access token을 요청합니다.
```apex
HttpRequest req = new HttpRequest();
req.setEndpoint('https://login.salesforce.com/services/oauth2/token');
req.setMethod('POST');
req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
req.setBody('grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=' +
    EncodingUtil.urlEncode(generateJWT('<CONSUMER_KEY>', '<USERNAME>'), 'UTF-8'));
HttpResponse res = new Http().send(req);
if (res.getStatusCode() == 200) {
    Map<String, Object> tokenResponse = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
    String accessToken = (String)tokenResponse.get('access_token');
}
```

## 5. 대상 조직으로 콜아웃

access token으로 REST/SOAP API 콜아웃을 합니다.
```apex
HttpRequest req = new HttpRequest();
req.setEndpoint('https://<TARGET_ORG_INSTANCE>.salesforce.com/services/data/v57.0/sobjects/Account');
req.setMethod('GET');
req.setHeader('Authorization', 'Bearer ' + accessToken);
HttpResponse res = new Http().send(req);
```

## 6. 추가 사항

- 항상 오류·예외를 신중히 처리.
- Named Credentials로 인증을 단순화하고 자격 증명을 안전하게 관리.
- 운영 배포 전 샌드박스에서 충분히 테스트.
