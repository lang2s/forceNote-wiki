---
tags: [devops, metadata-api, utility, describeMetadata, describeValueType, listMetadata, checkStatus, v67]
source: api_meta.pdf v67.0 Summer '26 — Chapter 11 (Utility Calls Reference)
created: 2026-05-22
aliases: [Metadata API Utility, describeMetadata, listMetadata, describeValueType, checkStatus]
---

# Metadata API Utility Calls

> 메타데이터 타입 탐색, 컴포넌트 목록 조회 등 개발 지원용 Utility 호출 레퍼런스.

---

## checkStatus()

> **폐기 예정.** 비동기 작업 ID의 상태를 반환한다. `checkDeployStatus()`와 `checkRetrieveStatus()`로 대체.

### 시그니처
```java
AsyncResult[] checkStatus(String[] asyncProcessIds)
```

### AsyncResult 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `done` | boolean | 완료 여부 |
| `id` | string | 비동기 작업 ID |
| `message` | string | 오류 메시지 (있을 때) |
| `state` | string | 현재 상태 (Queued/InProgress/Completed/Error/Aborted) |
| `statusCode` | string | 오류 상태 코드 |

---

## describeMetadata()

현재 API 버전에서 지원되는 모든 메타데이터 타입과 속성을 조회한다.

### 시그니처
```java
DescribeMetadataResult describeMetadata(double asOfVersion)
```

### 예제

```java
DescribeMetadataResult result = metadataConnection.describeMetadata(67.0);

// 지원되는 메타데이터 타입 목록
DescribeMetadataObject[] metadataObjects = result.getMetadataObjects();
for (DescribeMetadataObject dmo : metadataObjects) {
    System.out.println("타입: " + dmo.getXmlName()
        + " | 디렉터리: " + dmo.getDirectoryName()
        + " | 접미사: " + dmo.getSuffix());
}

System.out.println("조직 네임스페이스: " + result.getOrganizationNamespace());
System.out.println("테스트 필수 여부: " + result.isTestRequired());
```

### DescribeMetadataResult 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `metadataObjects` | DescribeMetadataObject[] | 지원되는 메타데이터 컴포넌트 목록 |
| `organizationNamespace` | string | 조직의 네임스페이스 (Developer Edition 전용) |
| `partialSaveAllowed` | boolean | 부분 저장 허용 여부 (Production은 항상 false) |
| `testRequired` | boolean | 테스트 필수 여부 (partialSaveAllowed의 반대값) |

### DescribeMetadataObject 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `childXmlNames` | string[] | 하위 서브 컴포넌트 목록 |
| `directoryName` | string | .zip 내 디렉터리 이름 |
| `inFolder` | boolean | 폴더 기반 컴포넌트 여부 (문서, 이메일 템플릿, 보고서 등) |
| `metaFile` | boolean | 추가 메타데이터 파일 필요 여부 (클래스, S-Control 등) |
| `suffix` | string | 파일 접미사 (예: `cls`, `trigger`) |
| `xmlName` | string | 루트 XML 요소 이름. `package.xml`의 `<name>` 값과 동일 |

---

## describeValueType()

특정 메타데이터 타입의 필드 구조를 조회한다. CRUD 호출 전 필드 메타데이터를 확인할 때 유용.

### 시그니처
```java
DescribeValueTypeResult describeValueType(String type)
```

### 예제

```java
DescribeValueTypeResult result = metadataConnection.describeValueType(
    "{http://soap.sforce.com/2006/04/metadata}CustomObject"
);

System.out.println("생성 가능: " + result.isApiCreatable());
System.out.println("삭제 가능: " + result.isApiDeletable());
System.out.println("읽기 가능: " + result.isApiReadable());
System.out.println("수정 가능: " + result.isApiUpdatable());

for (ValueTypeField field : result.getValueTypeFields()) {
    System.out.println("필드: " + field.getName()
        + " (" + field.getSoapType() + ")"
        + (field.getMinOccurs() == 1 ? " [필수]" : ""));
}
```

### DescribeValueTypeResult 필드

| 필드 | 타입 | 설명 | 버전 |
|---|---|---|---|
| `apiCreatable` | boolean | `createMetadata()` 지원 여부 | v36.0+ |
| `apiDeletable` | boolean | `deleteMetadata()` 지원 여부 | v36.0+ |
| `apiReadable` | boolean | `readMetadata()` 지원 여부 | v36.0+ |
| `apiUpdatable` | boolean | `updateMetadata()` 지원 여부 | v36.0+ |
| `parentField` | ValueTypeField | 부모 필드 정보 (없으면 null) | v36.0+ |
| `valueTypeFields` | ValueTypeField[] | 이 타입의 모든 필드 메타데이터 | - |

### ValueTypeField 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `fields` | ValueTypeField | 다음 필드 (있을 때) |
| `foreignKeyDomain` | string | 외래 키 대상 객체 타입 (예: Account) |
| `isForeignKey` | boolean | 외래 키 여부 |
| `isNameField` | boolean | fullName 필드 여부 |
| `minOccurs` | int | 1 = 필수, 0 = 선택 |
| `name` | string | 필드 이름 (부모 필드는 null) |
| `picklistValues` | PicklistEntry[] | 피클리스트 값 목록 |
| `soapType` | string | 데이터 타입 (예: boolean, double) |
| `valueRequired` | boolean | 값 필수 여부 |

### PicklistEntry 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `active` | boolean | 활성 여부 |
| `defaultValue` | boolean | 기본값 여부 |
| `label` | string | 표시 이름 |
| `validFor` | string | 종속 피클리스트 비트마스크 |
| `value` | string | 피클리스트 값 |

---

## listMetadata()

특정 메타데이터 타입의 컴포넌트 목록을 조회한다. `FileProperties[]` 형태로 반환.

### 시그니처
```java
FileProperties[] listMetadata(ListMetadataQuery[] queries, double asOfVersion)
```

### ListMetadataQuery 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `type` | string | 조회할 메타데이터 타입 이름 (예: `ApexClass`) |
| `folder` | string | 폴더 기반 컴포넌트일 때 폴더 이름 |

### 예제

```java
// 여러 타입 동시 조회
ListMetadataQuery query1 = new ListMetadataQuery();
query1.setType("ApexClass");

ListMetadataQuery query2 = new ListMetadataQuery();
query2.setType("CustomObject");

FileProperties[] lmr = metadataConnection.listMetadata(
    new ListMetadataQuery[]{query1, query2},
    67.0
);

for (FileProperties fp : lmr) {
    System.out.println(fp.getType() + ": " + fp.getFullName()
        + " | 최종 수정: " + fp.getLastModifiedDate()
        + " | 네임스페이스: " + fp.getNamespacePrefix());
}

// 폴더 기반 컴포넌트 (예: EmailTemplate)
ListMetadataQuery folderQuery = new ListMetadataQuery();
folderQuery.setType("EmailTemplate");
folderQuery.setFolder("MyEmailFolder");
FileProperties[] templates = metadataConnection.listMetadata(
    new ListMetadataQuery[]{folderQuery}, 67.0
);
```

### 반환 FileProperties 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `createdById` | string | 생성자 ID |
| `createdByName` | string | 생성자 이름 |
| `createdDate` | dateTime | 생성 날짜 |
| `fileName` | string | 파일 이름 |
| `fullName` | string | 개발자 이름 (고유 식별자) |
| `id` | string | 컴포넌트 ID |
| `lastModifiedById` | string | 최종 수정자 ID |
| `lastModifiedByName` | string | 최종 수정자 이름 |
| `lastModifiedDate` | dateTime | 최종 수정 날짜 |
| `manageableState` | ManageableState | 패키지 관리 상태 (beta/deleted/deprecated/deprecatedEditable/installed/installedEditable/released/unmanaged) |
| `namespacePrefix` | string | 네임스페이스 접두사 |
| `type` | string | 메타데이터 타입 이름 |

---

## 관련 노트

- [[Metadata API 개요]]
- [[Metadata API CRUD 호출]]
- [[Metadata API Result Objects]]
- [[Metadata API MCP Tool]]
- [[Metadata Types — 개요 및 분류]]
