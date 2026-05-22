---
tags: [External-Services, OpenAPI, REST, Integration, Named-Credential, Flow, Apex]
source: external-knowledge
created: 2026-05-23
aliases: [External Services, 외부 서비스, OpenAPI Apex 통합, External Service Registration, 외부 서비스 등록]
---

# External Services

> Salesforce Admin이 OpenAPI 스펙을 등록하면 Apex 클래스와 Flow 액션이 자동 생성되는 선언적 외부 연동 도구

> [!warning] 이 노트는 외부 지식 기반으로 작성되었으며 공식 소스와 대조되지 않았습니다.
> 공식 문서: https://help.salesforce.com/s/articleView?id=sf.external_services.htm

---

## 개념 설명

External Services는 외부 REST API의 **OpenAPI 2.0 또는 JSON 스키마**를 Salesforce에 등록하면, Apex 클래스와 Flow Invocable Action을 자동으로 생성하는 기능이다. 코드 없이도 외부 API를 Flow나 Apex에서 호출할 수 있다.

### 동작 원리

```
OpenAPI 스펙 업로드
    → External Service Registration 생성
    → Salesforce가 Apex 래퍼 클래스 자동 생성 (ExternalService 네임스페이스)
    → Flow에서 "External Service" 액션으로 직접 호출 가능
    → Apex에서 ExternalService 타입-안전 클래스로 호출 가능
```

---

## 설정 방법

### 사전 요건

1. **Named Credential** — 외부 API의 인증 정보 및 엔드포인트 URL
2. **Remote Site Settings 또는 CSP** — 외부 도메인 허용
3. **OpenAPI 2.0 스펙 파일** (JSON 형식) 또는 URL

### 등록 절차

```
1. Setup > External Services > New External Service
2. 이름 입력 (Apex 클래스 이름의 기반)
3. 서비스 스키마 방식 선택:
   - URL에서 가져오기 (OpenAPI 스펙 엔드포인트)
   - 파일 업로드 (JSON 형식 OpenAPI 스펙)
4. Named Credential 연결
5. 작업(Operations) 선택 — 사용할 API 엔드포인트 선택
6. Save → Apex 클래스 자동 생성 확인
```

### OpenAPI 스펙 예시 (등록용)

```json
{
  "swagger": "2.0",
  "info": {
    "title": "Acme API",
    "version": "1.0.0"
  },
  "host": "api.acme.com",
  "basePath": "/v1",
  "schemes": ["https"],
  "paths": {
    "/accounts/{id}": {
      "get": {
        "operationId": "getAccount",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "required": true,
            "type": "string"
          }
        ],
        "responses": {
          "200": {
            "description": "Account data",
            "schema": {
              "$ref": "#/definitions/Account"
            }
          }
        }
      }
    }
  },
  "definitions": {
    "Account": {
      "type": "object",
      "properties": {
        "id": { "type": "string" },
        "name": { "type": "string" }
      }
    }
  }
}
```

---

## Apex에서 호출

자동 생성된 Apex 클래스는 `ExternalService` 네임스페이스 하위에 위치한다.

```apex
// External Service: "AcmeAPI" 로 등록한 경우
// 자동 생성 클래스: ExternalService.AcmeAPI

// 입력 파라미터 객체 생성
ExternalService.AcmeAPI_getAccount_Request req = 
    new ExternalService.AcmeAPI_getAccount_Request();
req.id = '12345';

// API 호출 실행
ExternalService.AcmeAPI client = new ExternalService.AcmeAPI();
ExternalService.AcmeAPI_getAccount_Response resp = client.getAccount(req);

// 응답 처리
if (resp.Code == 200) {
    ExternalService.AcmeAPI_Account account = resp.Body;
    System.debug('Account Name: ' + account.name);
}
```

---

## Flow에서 호출

External Service 등록 후 Flow Builder에서 **Action** 요소로 외부 API를 직접 호출 가능.

```
Flow Builder > Action 요소 추가
    > External Service 카테고리 선택
    > 등록된 서비스 및 작업(Operation) 선택
    > 입력/출력 변수 매핑
    > 저장 및 활성화
```

---

## Binary File 지원 (Winter '26 신규)

Winter '26부터 **Binary File 유형 응답** 지원:

```apex
// Binary 응답 처리 (예: PDF 다운로드)
ExternalService.DocAPI_getDocument_Response resp = client.getDocument(req);
if (resp.Code == 200) {
    Blob fileContent = resp.Body_Blob; // Binary 응답
    ContentVersion cv = new ContentVersion();
    cv.Title = 'Document.pdf';
    cv.PathOnClient = 'Document.pdf';
    cv.VersionData = fileContent;
    insert cv;
}
```

---

## 한도 (Winter '26 기준)

| 항목 | 한도 |
|---|---|
| 등록 가능 External Service | **700개** (기존 200개에서 증가) |
| 스키마 당 오브젝트/오퍼레이션 수 | **3,000개** (기존 100개에서 증가) |
| 단일 스키마 파일 크기 | 1MB |
| 동시 Callout 제한 | Apex 거버너 한도 동일 (트랜잭션 당 100회) |

---

## Named Credential과의 관계

External Services는 **Named Credential**을 인증 수단으로 사용한다.

```
Named Credential 설정:
  - URL: https://api.acme.com
  - 인증: OAuth 2.0 / Basic / JWT / 사용자 정의 헤더

External Service에서 Named Credential 선택
    → callout:AcmeAPI/v1/accounts/123 형태로 호출됨
```

---

## ExternalService Namespace (Apex)

External Services 등록 시 자동 생성되는 Apex 클래스 구조:

| 클래스/타입 | 설명 |
|---|---|
| `ExternalService.<ServiceName>` | 서비스 클라이언트 클래스 |
| `ExternalService.<ServiceName>_<OperationId>_Request` | 요청 파라미터 클래스 |
| `ExternalService.<ServiceName>_<OperationId>_Response` | 응답 클래스 (Code, Body 포함) |
| `ExternalService.<ServiceName>_<SchemaName>` | 스키마 정의 타입 클래스 |

---

## 비교표 (External Services vs 직접 HTTP Callout)

| 항목 | External Services | 직접 HttpRequest |
|---|---|---|
| 코드 필요 여부 | 최소 (자동 생성) | 직접 작성 |
| Flow 연동 | ✅ 자동 Action 생성 | ❌ Apex 래퍼 별도 필요 |
| 타입 안전성 | ✅ 자동 클래스 | ❌ JSON 수동 파싱 |
| OpenAPI 요건 | 필수 | 없음 |
| Binary 지원 | ✅ (Winter '26) | ✅ (Blob 직접) |
| 유연성 | 제한적 | 완전 자유 |
| 권장 상황 | Admin 설정 연동, 표준 REST API | 복잡한 커스텀 로직 |

---

## 관련 노트
- [[Named Credential]]
- [[CSP와 RemoteSite]]
- [[Queueable + Callout 패턴]]
- [[ExternalService Namespace]]
