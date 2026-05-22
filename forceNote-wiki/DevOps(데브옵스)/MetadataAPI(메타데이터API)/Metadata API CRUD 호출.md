---
tags: [devops, metadata-api, crud, createMetadata, readMetadata, updateMetadata, upsertMetadata, deleteMetadata, renameMetadata, SaveResult, DeleteResult, UpsertResult, v67]
source: api_meta.pdf v67.0 Summer '26 — Chapter 5 (CRUD-Based Development), Chapter 10 (CRUD Calls Reference)
created: 2026-05-22
aliases: [CRUD Metadata API, createMetadata, readMetadata, updateMetadata, upsertMetadata, deleteMetadata, renameMetadata, 동기 메타데이터 호출]
---

# Metadata API CRUD 호출

> 개별 메타데이터 컴포넌트를 동기(synchronous) 방식으로 생성·조회·수정·삭제하는 CRUD-Based API 레퍼런스.

---

## CRUD vs File-Based 비교

| 항목 | CRUD-Based | File-Based |
|---|---|---|
| 처리 방식 | 동기 (결과 즉시 반환) | 비동기 (폴링 필요) |
| 적용 범위 | 단일 또는 소수 컴포넌트 | 대규모 일괄 처리 |
| 반환값 | SaveResult[], DeleteResult[] 등 | AsyncResult → DeployResult |
| 테스트 실행 | 없음 | 옵션 있음 |
| 권장 사용 | 프로그래밍 방식 단일 변경 | 전체 배포/검색 파이프라인 |

> **API v31.0 이전 비동기 CRUD (`create()`, `delete()`, `update()`)는 폐기됨.** 동기 CRUD 메서드(`createMetadata()` 등)를 사용한다.

---

## createMetadata()

새 메타데이터 컴포넌트를 생성한다.

### 시그니처
```java
SaveResult[] createMetadata(Metadata[] metadata)
```

- v34.0+: `AllOrNoneHeader` 지원. 헤더 없으면 부분 성공 허용(일부 실패해도 성공한 것은 저장).
- 배치 한도: 최대 10개 컴포넌트/호출.

### 예제 — CustomObject 생성

```java
CustomObject co = new CustomObject();
co.setFullName("MyNewObject__c");
co.setLabel("My New Object");
co.setPluralLabel("My New Objects");
co.setSharingModel(SharingModel.ReadWrite);
co.setDeploymentStatus(DeploymentStatus.Deployed);
co.setDescription("Created by Metadata API");
co.setEnableActivities(true);

// Name 필드 (필수)
CustomField nameField = new CustomField();
nameField.setType(FieldType.Text);
nameField.setLabel("My New Object Name");
co.setNameField(nameField);

SaveResult[] results = metadataConnection.createMetadata(new Metadata[]{co});

for (SaveResult r : results) {
    if (r.isSuccess()) {
        System.out.println("생성 성공: " + r.getFullName());
    } else {
        for (com.sforce.soap.metadata.Error e : r.getErrors()) {
            System.out.println("오류: " + e.getMessage() + " / " + e.getStatusCode());
        }
    }
}
```

---

## readMetadata()

기존 메타데이터 컴포넌트를 조회한다.

### 시그니처
```java
ReadResult readMetadata(String type, String[] fullNames)
```

- 반환: `ReadResult` (내부에 `Metadata[]`)
- 사용 가능: API v30.0+

### 예제

```java
ReadResult readResult = metadataConnection.readMetadata(
    "CustomObject",
    new String[]{"MyCustomObject1__c", "MyCustomObject2__c"}
);

Metadata[] records = readResult.getRecords();
for (Metadata md : records) {
    System.out.println("조회된 컴포넌트: " + md.getFullName());
}
```

---

## updateMetadata()

기존 메타데이터 컴포넌트를 업데이트한다.

### 시그니처
```java
SaveResult[] updateMetadata(Metadata[] metadata)
```

- v34.0+: `AllOrNoneHeader` 지원.
- 배치 한도: 최대 10개 컴포넌트/호출.

### 예제

```java
// 먼저 readMetadata로 기존 객체 조회
ReadResult readResult = metadataConnection.readMetadata(
    "CustomObject", new String[]{"MyCustomObject1__c"}
);
CustomObject co = (CustomObject) readResult.getRecords()[0];

// 필드 수정
co.setDescription("Updated description");

SaveResult[] results = metadataConnection.updateMetadata(new Metadata[]{co});
for (SaveResult r : results) {
    System.out.println(r.isSuccess() ? "업데이트 성공" : "실패: " + r.getErrors()[0].getMessage());
}
```

---

## upsertMetadata()

컴포넌트가 없으면 생성하고, 있으면 업데이트한다.

### 시그니처
```java
UpsertResult[] upsertMetadata(Metadata[] metadata)
```

- v31.0+에서 사용 가능.
- v34.0+: `AllOrNoneHeader` 지원.
- 배치 한도: 최대 10개 컴포넌트/호출.

### UpsertResult 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `created` | boolean | `true` = 새로 생성됨, `false` = 업데이트됨 |
| `fullName` | string | 처리된 컴포넌트의 전체 이름 |
| `success` | boolean | 성공 여부 |
| `errors` | Error[] | 실패 시 오류 배열 |

### 예제

```java
CustomObject co = new CustomObject();
co.setFullName("MyCustomObject1__c");
co.setDescription("Upserted by Metadata API");

UpsertResult[] results = metadataConnection.upsertMetadata(new Metadata[]{co});
for (UpsertResult r : results) {
    if (r.isSuccess()) {
        System.out.println((r.isCreated() ? "생성됨" : "업데이트됨") + ": " + r.getFullName());
    }
}
```

---

## deleteMetadata()

메타데이터 컴포넌트를 삭제한다.

### 시그니처
```java
DeleteResult[] deleteMetadata(String type, String[] fullNames)
```

- v34.0+: `AllOrNoneHeader` 지원. 헤더 없으면 부분 삭제 가능.
- 배치 한도: 최대 10개 컴포넌트/호출.

### DeleteResult 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `fullName` | string | 삭제된 컴포넌트의 전체 이름 |
| `success` | boolean | 삭제 성공 여부 |
| `errors` | Error[] | 실패 시 오류 배열 |

### 예제

```java
DeleteResult[] results = metadataConnection.deleteMetadata(
    "CustomObject",
    new String[]{"MyCustomObject1__c"}
);

for (DeleteResult r : results) {
    if (r.isSuccess()) {
        System.out.println("삭제 성공: " + r.getFullName());
    } else {
        for (com.sforce.soap.metadata.Error e : r.getErrors()) {
            System.out.println("삭제 실패: " + e.getMessage());
        }
    }
}
```

---

## renameMetadata()

메타데이터 컴포넌트의 이름을 변경한다.

### 시그니처
```java
SaveResult[] renameMetadata(String type, String oldFullName, String newFullName)
```

### 예제

```java
SaveResult[] results = metadataConnection.renameMetadata(
    "CustomObject",
    "MyCustomObject1__c",
    "MyCustomObject1New__c"
);

for (SaveResult r : results) {
    System.out.println(r.isSuccess() ? "이름 변경 성공" : "실패: " + r.getErrors()[0].getMessage());
}
```

---

## Error 객체

CRUD 호출 실패 시 `SaveResult`, `DeleteResult`, `UpsertResult`에 포함되는 오류 정보.

| 필드 | 타입 | 설명 |
|---|---|---|
| `extendedErrorDetails` | ExtendedErrorDetails | 추가 오류 세부 정보 (향후 사용 예약) |
| `fields` | string[] | 오류를 유발한 필드 이름 배열 |
| `message` | string | 오류 메시지 텍스트 |
| `statusCode` | StatusCode | 오류 상태 코드 (SOAP API Guide의 StatusCode 참조) |

---

## AllOrNoneHeader 사용 (v34.0+)

```java
// 하나라도 실패하면 전체 롤백
metadataConnection.setAllOrNoneHeader(true);

SaveResult[] results = metadataConnection.createMetadata(new Metadata[]{co1, co2});
```

---

## 관련 노트

- [[Metadata API 개요]]
- [[Metadata API Quick Start]]
- [[Metadata API Result Objects]]
- [[Metadata API Headers]]
- [[Metadata API 에러 처리]]
- [[Metadata Types — 개요 및 분류]]
