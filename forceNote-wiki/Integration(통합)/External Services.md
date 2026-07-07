---
tags: [External-Services, OpenAPI, REST, Integration, Named-Credential, Flow, Apex]
source: Salesforce Help — External Services System Limits (external_services_schema_def_limits.htm), External Services Considerations (enhanced_external_services_considerations.htm), OpenAPI 2.0 and 3.0 Support (external_services_intro_openapi_2_3_support.htm); Apex Reference Guide — ExternalService Namespace (apex_namespace_ExternalService.htm); Winter '26 Release Notes (Upload and Download Files with External Services Binary File Support)
created: 2026-05-23
aliases: [External Services, 외부 서비스, OpenAPI Apex 통합, External Service Registration, 외부 서비스 등록]
---

# External Services

> Salesforce Admin이 OpenAPI 스펙을 등록하면 Apex 클래스와 Flow 액션이 자동 생성되는 선언적 외부 연동 도구

> 공식 문서: https://help.salesforce.com/s/articleView?id=platform.external_services.htm

---

## 개념 설명

External Services는 외부 REST API의 **OpenAPI 스키마**를 Salesforce에 등록하면, Apex 클래스와 Flow Invocable Action을 자동으로 생성하는 기능이다. 코드 없이도 외부 API를 Flow나 Apex에서 호출할 수 있다.

> [!tip] 등록 포맷 — OpenAPI 3.0 권장 (Spring '22 GA)
> External Services는 **OpenAPI 2.0(Swagger 2.0)** 과 **OpenAPI 3.0** 두 포맷을 모두 지원한다. **Spring '22부터 OpenAPI 3.0 JSON 포맷 직접 등록이 GA** — 스키마를 수정·변환하지 않고 그대로 업로드할 수 있다. 3.0이 현재 업계 표준이므로 **신규 통합은 OpenAPI 3.0 사용을 권장**한다. 아래 예시는 하위 호환용 Swagger 2.0 형식이며, 신규 등록 시 3.0(`"openapi": "3.0.0"`, `servers`/`components` 구조) 사용을 우선 고려한다.
> 근거: [Learn MOAR in Spring '22 — OpenAPI 3.0 Support for External Services](https://developer.salesforce.com/blogs/2022/02/learn-moar-in-spring-22-with-openapi-3-0-support-for-external-services) · [OpenAPI 2.0 and 3.0 Support](https://help.salesforce.com/s/articleView?id=platform.external_services_intro_openapi_2_3_support.htm)

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

한도 표의 등록 개수·스키마 크기만 충족해도, 아래 **스키마 구조 제약**을 위반하면 등록·매핑 시 오류로 막힌다. 스펙을 올리기 전에 반드시 확인한다.

| 제약 | 내용 |
|---|---|
| OpenAPI 버전 | **OpenAPI 2.0(Swagger)·3.0 모두 지원.** 3.0은 변환 없이 JSON 직접 등록(Spring '22 GA) |
| 타입 이름 길이 | 정의되거나 파생된 **parameter object type 이름**, 또는 object 타입을 갖는 **property**는 **255자 미만**이어야 Apex·Flow Builder에서 사용 가능 |
| nested/complex object | **지원됨.** 현재 External Services(구 Enhanced External Services)는 복합·중첩 object를 입력·출력으로 생성한다 — `ExternalService` 네임스페이스가 complex object data type용 Apex 클래스를 자동 생성 |
| 스키마 조합(composition) | OpenAPI 3.0의 `allOf`·`anyOf`·`oneOf` 및 `discriminator`(다형성) 지원 |
| 스키마 크기 | JSON **10,000,000자(10 MB)** · YAML **3,000,000자(3 MB)** 이내 (아래 한도 표 참조) |

> 과거 "표준 External Services"(중첩 객체 미지원)와 "Enhanced External Services"의 구분은 Enhanced가 표준으로 통합되면서 사실상 사라졌다 — 현재 External Services는 복합/중첩 스키마를 기본 지원한다. 스키마 업데이트 시 지원되는 변경/미지원 변경 상세는 공식 문서 `enhanced_external_services_considerations.htm`(External Services Considerations) 참조.

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

Request·Response 타입은 **서비스 클라이언트 클래스의 내부(nested) 클래스**로 생성된다 — `ExternalService.<Service>.<operationId>_Request` 형태(서비스명과 오퍼레이션 사이는 점 `.`, 밑줄 아님). 응답 클래스는 각 HTTP 상태코드마다 `Code<코드>` 프로퍼티를 가진다.

```apex
// 공식 Apex Reference Guide 예시 형태
// External Service "OpenLibrary" 로 등록한 경우
ExternalService.OpenLibrary api = new ExternalService.OpenLibrary();

// 요청 객체 (nested: 서비스.오퍼레이션_Request)
ExternalService.OpenLibrary.getBooks_Request request =
    new ExternalService.OpenLibrary.getBooks_Request();
request.q = 'salesforce';

// 호출 → 응답 (nested: 서비스.오퍼레이션_Response)
ExternalService.OpenLibrary.getBooks_Response response = api.getBooks(request);

// 응답 처리 — 상태코드별 프로퍼티(Code200, Code404 …)로 타입-안전 body 접근
// (response.Code200의 내부 필드는 스펙의 응답 스키마에 따라 생성됨)
System.debug(response.Code200);
```

> ⚠️ 응답 body는 `resp.Body`나 `resp.Code == 200` 형태가 아니라, 스펙에 정의된 각 응답 코드에 대응하는 **`Code<상태코드>` 프로퍼티**(예: `response.Code200`)로 접근한다. 오류 응답은 `<operationId>_ResponseException`(예: `exc.Code404`)으로 처리한다.

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

Winter '26부터 **바이너리 파일 업로드·다운로드**를 지원한다. OpenAPI 3.0 스펙에서 `application/octet-stream` 콘텐츠 타입으로 정의한 PUT(업로드)/GET(다운로드) 오퍼레이션이 Flow·Apex용 invocable action으로 자동 생성된다.

- 이미지·PDF 등 바이너리를 **`ContentDocument`와 주고받을 수 있다** — 업로드 시 전체 blob 대신 `contentDocumentId`를 body 파라미터로 넘겨 힙 메모리를 절약할 수 있다.
- 파일 크기 상한은 아래 한도 표의 "업로드/다운로드 파일 최대 크기" 참조.

> 근거: [The Salesforce Developer's Guide to the Winter '26 Release — Upload and Download Files with External Services Binary File Support](https://developer.salesforce.com/blogs/2025/09/winter26-developers)

---

## 한도 (Winter '26 기준 — 공식 System Limits)

공식 문서 `External Services System Limits`(platform.external_services_schema_def_limits.htm) 기준. 한도는 **org 단위**(스키마 단위 아님)다.

| 항목 | 한도 |
|---|---|
| 등록 가능 External Service | **700개 / org** (Winter '26에 150 → 700 증가) |
| 활성 오퍼레이션 수 | **3,000개 / org** (Winter '26에 1,250 → 3,000 증가) |
| 활성+비활성 오퍼레이션 | **10,000개 / org** |
| 활성 오브젝트 수 | **3,000개 / org** |
| 활성+비활성 오브젝트 | **10,000개 / org** |
| 오브젝트 프로퍼티 수 | **400,000개 / org** |
| 스키마 최대 크기 (JSON) | **10,000,000자 (10.0 MB)** |
| 스키마 최대 크기 (YAML) | **3,000,000자 (3.0 MB)** |
| 업로드/다운로드 파일 최대 크기 | **100 MB** |
| 타입 이름 길이 | parameter object type 이름·object property 이름 **255자 미만** (Apex·Flow 사용 조건) |
| 트랜잭션당 External Service callout | **100회** (Apex 거버너 한도. Developer Edition은 외부 도메인 동시 callout 20회 제한) |

> 구조 제약(타입 이름 255자·OpenAPI 버전·nested object 지원·composition)은 위 [스키마 구조 제약](#️-스키마-구조-제약-등록-실패-블로커) 소절 참조.

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

External Services 등록 시 자동 생성되는 Apex 클래스 구조. Request·Response·스키마 타입은 서비스 클라이언트 클래스 **안의 nested 클래스**로, 서비스명과 이름 사이를 점(`.`)으로 잇는다(밑줄 아님).

| 클래스/타입 | 설명 |
|---|---|
| `ExternalService.<ServiceName>` | 서비스 클라이언트 클래스 (`new`로 인스턴스화) |
| `ExternalService.<ServiceName>.<operationId>_Request` | 요청 파라미터 클래스 (nested) |
| `ExternalService.<ServiceName>.<operationId>_Response` | 응답 클래스 (nested). 각 HTTP 상태코드마다 `Code<코드>` 프로퍼티 보유 |
| `ExternalService.<ServiceName>.<operationId>_ResponseException` | 오류 응답 예외 클래스 (nested) |
| `ExternalService.<ServiceName>.<SchemaTypeName>` | 스키마 object 타입 클래스 (nested) |

> 오브젝트·오퍼레이션은 등록된 API 스펙에서 `ExternalService` 네임스페이스의 Apex 클래스·메서드로 매핑된다. 스펙의 object schema는 Apex 타입으로 매핑되며, complex object data type도 클래스로 생성된다.

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
