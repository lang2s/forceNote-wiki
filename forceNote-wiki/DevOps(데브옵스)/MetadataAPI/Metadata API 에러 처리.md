---
tags: [devops, metadata-api, error-handling, soap-fault, session-expiry, v67]
source: api_meta.pdf v67.0 Summer '26 — Chapter 7 (Error Handling)
created: 2026-05-22
aliases: [Metadata API 에러 처리, Metadata API Error Handling, INVALID_SESSION_ID, SOAP fault, 메타데이터 API 오류]
---

# Metadata API 에러 처리

> Metadata API 런타임 오류를 감지·처리하는 4가지 패턴. 인증 오류(SOAP fault), 비동기 CRUD 오류, 동기 CRUD 오류, deploy/retrieve 오류를 각각 다루는 방법.

---

## 에러 처리 유형 요약

Metadata API는 호출 방식에 따라 오류 정보를 반환하는 위치가 다르다.

| 에러 종류 | 에러 정보 위치 | 설명 |
|---|---|---|
| SOAP fault (인증·형식 오류) | SOAP fault message (enterprise/partner WSDL) | 잘못된 메시지 형식, 인증 실패, 네트워크 문제 등. 각 SOAP fault에는 `ExceptionCode` 포함 |
| 비동기 CRUD 오류 (`create()`, `update()`, `delete()`) | `AsyncResult.statusCode` | API v31.0 이전의 비동기 CRUD 호출 결과. `checkStatus()`로 폴링해 확인 |
| 동기 CRUD 오류 (`createMetadata()`, `updateMetadata()`, `deleteMetadata()`) | `Error.statusCode` (Result 객체의 `errors` 배열) | 예: `createMetadata()` → `SaveResult.errors[]` → `Error.statusCode` |
| deploy() 오류 | `DeployMessage.problem`, `DeployMessage.success` | 배포 실패 컴포넌트별 오류 메시지 |
| retrieve() 오류 | `RetrieveMessage.problem` | 검색 실패 메시지 |

> 샘플 코드는 [[Metadata API Quick Start]] → Step 3: Walk Through the Java Sample Code 참조.

---

## 1. SOAP Fault 오류

Metadata API는 인증에 enterprise/partner WSDL을 사용하므로, 잘못된 메시지나 인증 실패는 해당 WSDL에 정의된 SOAP fault로 반환된다.

```xml
<!-- SOAP fault 응답 예시 -->
<soapenv:Fault>
  <faultcode>soapenv:Client</faultcode>
  <faultstring>INVALID_SESSION_ID: Invalid Session ID found in SessionHeader: null</faultstring>
  <detail>
    <ExceptionCode>INVALID_SESSION_ID</ExceptionCode>
    <ExceptionMessage>Invalid Session ID...</ExceptionMessage>
  </detail>
</soapenv:Fault>
```

자세한 ExceptionCode 목록은 SOAP API Developer Guide → Error Handling 참조.

---

## 2. 비동기 CRUD 오류 (`AsyncResult.statusCode`)

API v31.0 이전의 `create()`, `update()`, `delete()` 비동기 호출은 `AsyncResult` 객체를 반환한다. `checkStatus()`를 폴링하여 완료 여부와 오류를 확인한다.

```java
// 비동기 CRUD 오류 확인 패턴 (API v30.0 이전)
AsyncResult[] asyncResults = metadataConnection.create(new CustomObject[]{customObject});

// 폴링 루프
do {
    asyncResults = metadataConnection.checkStatus(
        new String[]{asyncResults[0].getId()}
    );
    if (asyncResults[0].getStatusCode() != null) {
        // 오류 발생
        System.out.println("Error code: " + asyncResults[0].getStatusCode());
        System.out.println("Error msg:  " + asyncResults[0].getMessage());
        break;
    }
} while (!asyncResults[0].isDone());
```

> **주의:** 비동기 CRUD(`create()`, `update()`, `delete()`)는 API v31.0 이후 사용 불가. 동기 CRUD(`createMetadata()` 등)를 사용한다.

---

## 3. 동기 CRUD 오류 (`SaveResult.errors[]`)

`createMetadata()`, `updateMetadata()`, `upsertMetadata()` 등 동기 CRUD 호출은 Result 객체를 즉시 반환한다. 결과 객체의 `errors` 배열에서 `Error.statusCode`와 `Error.message`를 확인한다.

```java
// createMetadata() 오류 처리
SaveResult[] results = metadataConnection.createMetadata(new Metadata[]{ co });

for (SaveResult r : results) {
    if (r.isSuccess()) {
        System.out.println("Created: " + r.getFullName());
    } else {
        System.out.println("Failed: " + r.getFullName());
        for (Error e : r.getErrors()) {
            System.out.println("  Status code: " + e.getStatusCode());
            System.out.println("  Message:     " + e.getMessage());
            System.out.println("  Fields:      " + Arrays.toString(e.getFields()));
        }
    }
}
```

| Result 객체 | 사용하는 호출 |
|---|---|
| `SaveResult` | `createMetadata()`, `updateMetadata()` |
| `UpsertResult` | `upsertMetadata()` |
| `DeleteResult` | `deleteMetadata()` |

---

## 4. deploy() 오류 (`DeployMessage`)

`deploy()` 호출의 오류는 `DeployResult.details.componentFailures` 배열의 `DeployMessage` 객체에서 확인한다.

```java
// deploy() 오류 처리
AsyncResult asyncResult = metadatabinding.deploy(zipBytes, deployOptions);

// 완료될 때까지 폴링
DeployResult result;
do {
    Thread.sleep(ONE_SECOND);
    result = metadatabinding.checkDeployStatus(asyncResult.getId(), true);
} while (!result.isDone());

if (!result.isSuccess()) {
    for (DeployMessage msg : result.getDetails().getComponentFailures()) {
        System.out.println("Component: " + msg.getFullName());
        System.out.println("Problem:   " + msg.getProblem());
        System.out.println("Success:   " + msg.isSuccess());
    }
}
```

`DeployMessage` 주요 필드:

| 필드 | 타입 | 설명 |
|---|---|---|
| `fullName` | String | 실패한 컴포넌트 이름 |
| `problem` | String | 오류 메시지 |
| `problemType` | String | `Error` 또는 `Warning` |
| `success` | Boolean | 컴포넌트 배포 성공 여부 |
| `lineNumber` | Integer | 오류 발생 줄 번호 (코드 파일인 경우) |
| `columnNumber` | Integer | 오류 발생 열 번호 |

---

## 5. retrieve() 오류 (`RetrieveMessage`)

`retrieve()` 오류는 `RetrieveResult.messages` 배열의 `RetrieveMessage.problem` 필드로 확인한다.

```java
// retrieve() 오류 처리
AsyncResult asyncResult = metadatabinding.retrieve(retrieveRequest);

RetrieveResult result;
do {
    Thread.sleep(ONE_SECOND);
    result = metadatabinding.checkRetrieveStatus(asyncResult.getId(), true);
} while (!result.isDone());

if (result.getMessages() != null) {
    for (RetrieveMessage msg : result.getMessages()) {
        System.out.println("File: " + msg.getFileName());
        System.out.println("Problem: " + msg.getProblem());
    }
}
```

---

## 세션 만료 처리 (INVALID_SESSION_ID)

`login()` 호출로 세션이 시작되면, 세션은 Salesforce 보안 설정(기본 2시간)에 따라 자동 만료된다. 세션이 만료되면 `INVALID_SESSION_ID` 예외 코드가 반환된다.

```java
// 세션 만료 재시도 패턴
try {
    metadataConnection.describeMetadata(API_VERSION);
} catch (SoapFaultException e) {
    if ("INVALID_SESSION_ID".equals(e.getFaultCode().getLocalPart())) {
        // 세션 재로그인
        metadataConnection = MetadataLoginUtil.login();
        // 작업 재시도
        metadataConnection.describeMetadata(API_VERSION);
    } else {
        throw e;
    }
}
```

**세션 만료 처리 원칙:**
1. `INVALID_SESSION_ID` 수신 시 즉시 `login()`을 다시 호출한다.
2. 새 세션 ID로 MetadataConnection을 재구성한다.
3. 실패한 작업을 재시도한다.

> SOAP API `login()` 메서드에 대한 자세한 정보는 SOAP API Developer Guide 참조.

---

## 관련 노트

- [[Metadata API 개요]] — Metadata API 전체 개념 및 호출 유형
- [[Metadata API CRUD 호출]] — createMetadata / readMetadata / updateMetadata / deleteMetadata
- [[Metadata API File-Based 호출]] — deploy() / retrieve() 상세
- [[Metadata API Result Objects]] — SaveResult / DeployResult / AsyncResult / Error 객체 상세
- [[Metadata API Headers]] — SessionHeader, AllOrNoneHeader 설정
