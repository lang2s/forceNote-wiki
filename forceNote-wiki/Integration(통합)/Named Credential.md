---
tags: [salesforce, integration, named-credential, security, pattern]
source: apex-recipes/RestClient.cls, NamedCredentialRecipes.cls
created: 2026-05-17
aliases: [Named Credential, 네임드 크레덴셜, callout:]
---

# Named Credential

> 외부 시스템 URL과 인증 정보를 Salesforce에 저장하고 Apex에서 `callout:{NC_Name}` 형식으로 참조. 코드에 URL/비밀번호를 하드코딩하지 않는 Salesforce 표준 방식.

---

## Apex에서 사용하는 형식

```apex
// 기본 형식
req.setEndpoint('callout:GoogleBooksAPI/volumes?q=' + keyword);

// Named Credential 이름 + 경로
// callout:{DeveloperName}/{path}?{querystring}

// 예시
req.setEndpoint('callout:MyRestApi/api/v1/accounts/');
req.setEndpoint('callout:Stripe/v1/charges?limit=10');
```

---

## RestClient에서의 활용

```apex
// RestClient 상속 서비스 클래스
public with sharing class BookApiService extends RestClient {

    public BookApiService() {
        namedCredentialName = 'GoogleBooksAPI'; // ← Named Credential Developer Name
    }

    public List<BookModel> searchBooks(String keyword) {
        // RestClient.get()이 내부적으로 callout:GoogleBooksAPI/{path} 구성
        HttpResponse response = get('volumes?q=' + EncodingUtil.urlEncode(keyword, 'UTF-8'));
        // 응답 처리...
    }
}
```

---

## Named Credential 종류

| 종류 | 설명 |
|---|---|
| Legacy Named Credential | URL + 인증 정보 통합 (구형) |
| Named Credential (신형) | URL + External Credential 분리 |
| External Credential | 인증 정보만 별도 관리 |
| Per-User Principal | 사용자별 인증 정보 |

---

## 설정 경로

```
Setup → Security → Named Credentials → New Named Credential

필드:
- Label: 화면 표시명
- Name (Developer Name): Apex에서 참조하는 이름
- URL: 외부 시스템 Base URL
- Identity Type: Named Principal / Per-User
- Authentication Protocol: No Auth / Password / OAuth 2.0 / JWT / AWS Signature V4
```

---

## ConnectApi를 통한 Named Credential 생성 (코드)

```apex
// 코드로 Named Credential 생성 (apex-recipes/NamedCredentialRecipes.cls 패턴)
ConnectApi.ExternalCredentialInput credInput = new ConnectApi.ExternalCredentialInput();
credInput.developerName = 'MyExternalCred';
credInput.label = 'My External Credential';
credInput.authenticationProtocol = ConnectApi.CredentialAuthenticationProtocol.NoAuthentication;

ConnectApi.ExternalCredential cred =
    ConnectApi.NamedCredentials.createExternalCredential(credInput);
```

> [!note] ConnectApi 테스트 제약
> `ConnectApi.NamedCredentials`는 `@isTest(SeeAllData=true)` 없이 호출 불가.
> → 래퍼 클래스로 감싸서 `TestDouble`로 모킹. ([[StubProvider]] 참조)

---

## 인증 프로토콜별 선택

| 프로토콜 | 사용 시점 |
|---|---|
| No Authentication | API Key를 헤더로 직접 전달 (코드에서) |
| Password | 기본 인증 (Basic Auth) |
| OAuth 2.0 | OAuth flow (Salesforce가 토큰 관리) |
| JWT Token Bearer | JWT 기반 M2M |
| AWS Signature V4 | AWS 서비스 |

---

## 보안 모범 사례

> [!tip] Named Credential 사용 이유
> 1. URL/비밀번호가 Apex 코드에 노출되지 않음
> 2. 환경별(Sandbox/Production) URL 분리 관리
> 3. Salesforce가 토큰 갱신 자동 처리 (OAuth)
> 4. 감사 로그에서 추적 가능

---

## 관련 노트

- [[RestClient 패턴]]
- [[Custom REST Endpoint]]
- [[StubProvider]] — ConnectApi 래퍼 테스트

