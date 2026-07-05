---
tags: [External-Services, OpenAPI, REST, Integration, Named-Credential, Flow, Apex]
source: external-knowledge; Salesforce 공식 문서 (Tier 2) — enhanced_external_services_considerations.htm, external_services_schema_def_limits.htm, external_services_intro_openapi_2_3_support.htm (OpenAPI 2.0 and 3.0 Support)
created: 2026-05-23
aliases: [External Services, 외부 서비스, OpenAPI Apex 통합, External Service Registration, 외부 서비스 등록]
---

# External Services

> Salesforce Admin이 OpenAPI 스펙을 등록하면 Apex 클래스와 Flow 액션이 자동 생성되는 선언적 외부 연동 도구

> [!warning] 이 노트는 외부 지식 기반으로 작성되었으며 공식 소스와 대조되지 않았습니다.
> 공식 문서: https://help.salesforce.com/s/articleView?id=sf.external_services.htm

---

## 개념 설명

External Services는 외부 REST API의 **OpenAPI 스키마**를 Salesforce에 등록하면, Apex 클래스와 Flow Invocable Action을 자동으로 생성하는 기능이다. 코드 없이도 외부 API를 Flow나 Apex에서 호출할 수 있다.

> [!tip] 등록 포맷 — OpenAPI 3.0 권장 (Spring '22 GA)
> External Services는 **OpenAPI 2.0(Swagger 2.0)** 과 **OpenAPI 3.0** 두 포맷을 모두 지원한다. **Spring '22부터 OpenAPI 3.0 JSON 포맷 직접 등록이 GA** — 스키마를 수정·변환하지 않고 그대로 업로드할 수 있다. 3.0이 현재 업계 표준이므로 **신규 통합은 OpenAPI 3.0 사용을 권장**한다. 아래 예시는 하위 호환용 Swagger 2.0 형식이며, 신규 등록 시 3.0(`"openapi": "3.0.0"`, `servers`/`components` 구조) 사용을 우선 고려한다.
> 근거: [Learn MOAR in Spring '22 — OpenAPI 3.0 Support for External Services](https://developer.salesforce.com/blogs/2022/02/learn-moar-in-spring-22-with-openapi-3-0-support-for-external-services) · [OpenAPI 2.0 and 3.0 Support](https://help.salesforce.com/s/articleView?id=sf.external_services_intro_openapi_2_3_support.htm)

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
3. **OpenAPI 스펙 파일** (JSON 형식) 또는 URL — OpenAPI 2.0(Swagger 2.0) 또는 **OpenAPI 3.0**(Spring '22부터 GA, 신규 권장)

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

### ⚠️ 스키마 구조 제약 (등록 실패 블로커)

한도 표의 등록 개수·오퍼레이션 수만 충족해도, 아래 **스키마 구조 제약**을 위반하면 등록 시 `unsupported schema` 오류로 막힌다. 스펙을 올리기 전에 반드시 확인한다.

| 제약 | 내용 |
|---|---|
| 모든 parameter는 named여야 함 | 이름 없는(unnamed) 파라미터는 지원 안 됨 |
| 모든 property는 값이 할당돼야 함 | 값이 없는(빈) property가 있으면 등록 실패 |
| nested/complex object 입력·출력 | **표준 External Services에서는 미지원.** nested/complex object를 입력·출력으로 쓰려면 **Enhanced External Services**여야 함 |
| 스키마 정의 최대 크기 | **100,000자** (스키마 정의 문자 수 상한) |

> 표준 External Services에서 중첩 객체를 입력·출력으로 사용하려면 Enhanced External Services로 등록해야 한다. 자세한 고려사항은 공식 문서 `enhanced_external_services_considerations.htm` 참조.

### OpenAPI 스펙 예시 (등록용)

> 아래는 하위 호환용 **Swagger 2.0** 형식이다. 신규 등록은 **OpenAPI 3.0**(`"openapi": "3.0.0"` + `servers`/`components/schemas` 구조)을 권장한다 — Spring '22부터 3.0 JSON을 변환 없이 직접 업로드 가능.

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
| 스키마 정의 최대 크기 | **100,000자** (이 상한을 넘으면 등록 불가) |
| 동시 Callout 제한 | Apex 거버너 한도 동일 (트랜잭션 당 100회) |

> 구조 제약(parameter named·property 값 할당·nested object 미지원)은 위 [스키마 구조 제약](#️-스키마-구조-제약-등록-실패-블로커) 소절 참조.

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
- [[Tooling API 객체 — 통합·데이터·결제·마케팅 (외부서비스·Data Kit·페이먼트·Account Engagement)]] — ExternalServiceRegistration의 Tooling API sObject facet(등록 메타데이터를 API로 조회·관리하는 쪽)
- [[integration-connectivity-generate]] (sf-skill — 실행형) — External Services·통합 커넥티비티 구성 실행형 스킬
