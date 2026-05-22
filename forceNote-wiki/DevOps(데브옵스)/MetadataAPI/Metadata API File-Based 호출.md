---
tags: [devops, metadata-api, deploy, retrieve, package-xml, destructive-changes, test-level, DeployOptions, DeployResult, RetrieveRequest, RetrieveResult, v67]
source: api_meta.pdf v67.0 Summer '26 — Chapter 4 (File-Based Metadata API Calls), Chapter 9 (File-Based Calls Reference)
created: 2026-05-22
aliases: [File-Based Metadata API, deploy, retrieve, package.xml, destructiveChanges.xml, DeployOptions, 배포 검색]
---

# Metadata API File-Based 호출

> .zip + package.xml 패키지로 메타데이터를 일괄 배포(deploy)하거나 조직에서 검색(retrieve)하는 File-Based API 호출 레퍼런스.

---

## package.xml (매니페스트 파일)

deploy와 retrieve 모두 `package.xml`을 사용해 대상 컴포넌트를 선언한다.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
    <types>
        <members>MyCustomObject__c</members>
        <members>AnotherObject__c</members>
        <name>CustomObject</name>
    </types>
    <types>
        <members>*</members>
        <name>ApexClass</name>
    </types>
    <version>67.0</version>
</Package>
```

- `<members>*</members>` — 해당 타입의 모든 컴포넌트
- `<version>` — API 버전 (현재: 67.0)

---

## destructiveChanges.xml (삭제 매니페스트)

컴포넌트를 삭제할 때 사용. `package.xml`과 함께 .zip에 포함.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
    <types>
        <members>MyOldObject__c</members>
        <name>CustomObject</name>
    </types>
</Package>
```

배포 순서:
- `destructiveChanges.xml` — 배포 **이후** 삭제
- `destructiveChangesPre.xml` — 배포 **이전** 삭제

---

## deploy()

조직에 메타데이터를 배포한다. 비동기 호출로, `AsyncResult`를 반환하며 `checkDeployStatus()`로 완료를 폴링한다.

### 시그니처
```java
AsyncResult deploy(base64Binary ZipFile, DeployOptions DeployOptions)
```

### DeployOptions 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `allowMissingFiles` | boolean | 매니페스트에 있지만 zip에 없는 파일 허용 여부 |
| `autoUpdatePackage` | boolean | 누락 컴포넌트를 자동으로 패키지에 추가 |
| `checkOnly` | boolean | `true` = 검증만 수행, 실제 저장 안 함 (빠른 배포 전 검증) |
| `ignoreWarnings` | boolean | 경고 시 배포 중단 여부 (`true` = 경고 무시하고 계속) |
| `performRetrieve` | boolean | 배포 후 자동 retrieve 수행 여부 |
| `purgeOnDelete` | boolean | 삭제된 컴포넌트를 휴지통으로 보내지 않고 영구 삭제 |
| `rollbackOnError` | boolean | 하나라도 오류 시 전체 롤백 (기본 false) |
| `runTests` | string[] | `testLevel = RunSpecifiedTests`일 때 실행할 테스트 클래스명 목록 |
| `singlePackage` | boolean | zip이 단일 패키지인지 여부 |
| `testLevel` | TestLevel | 테스트 실행 수준 (아래 참조) |

### TestLevel 열거형

| 값 | 설명 |
|---|---|
| `NoTestRun` | 테스트 실행 안 함 (sandbox에만 허용) |
| `RunSpecifiedTests` | `runTests`로 지정한 테스트만 실행 |
| `RunRelevantTests` | 배포된 코드와 관련된 테스트만 자동 선택 (Beta) |
| `RunLocalTests` | 관리 패키지 제외한 모든 로컬 테스트 실행 |
| `RunAllTestsInOrg` | org 전체 테스트 실행 |

> **Production 배포:** 기본적으로 `RunLocalTests` 이상 필요. code coverage 75% 미만이면 실패.

### 예제

```java
byte[] zipBytes = Files.readAllBytes(Paths.get("deploy.zip"));

DeployOptions options = new DeployOptions();
options.setRollbackOnError(true);
options.setTestLevel(TestLevel.RunLocalTests);
options.setCheckOnly(false);

AsyncResult asyncResult = metadataConnection.deploy(zipBytes, options);
String asyncResultId = asyncResult.getId();

// 폴링
DeployResult deployResult;
do {
    Thread.sleep(5000);
    deployResult = metadataConnection.checkDeployStatus(asyncResultId, true);
    System.out.println("상태: " + deployResult.getStatus());
} while (!deployResult.isDone());
```

---

## checkDeployStatus()

비동기 배포 작업의 현재 상태를 확인한다.

### 시그니처
```java
DeployResult checkDeployStatus(String asyncProcessId, boolean includeDetails)
```

- `includeDetails = true` — 컴포넌트별 성공/실패 세부 정보 포함

### DeployStatus 열거형

| 값 | 설명 |
|---|---|
| `Pending` | 대기 중 |
| `InProgress` | 처리 중 |
| `FinalizingDeploy` | 마무리 중 |
| `FinalizingDeployFailed` | 마무리 실패 |
| `Succeeded` | 완전 성공 |
| `SucceededPartial` | 부분 성공 |
| `Failed` | 실패 |
| `Canceling` | 취소 진행 중 |
| `Canceled` | 취소 완료 |

---

## cancelDeploy()

진행 중인 배포를 취소한다.

### 시그니처
```java
DeployResult cancelDeploy(String asyncProcessId)
```

```java
DeployResult result = metadataConnection.cancelDeploy(asyncResultId);
System.out.println("취소 상태: " + result.getStatus());
```

---

## deployRecentValidation()

`checkOnly=true`로 성공한 최근 검증 결과를 실제 배포한다. 테스트 재실행 없이 빠른 배포 가능 (4일 이내).

### 시그니처
```java
String deployRecentValidation(String validationId)
```

```java
// checkOnly=true 검증 후 얻은 ID를 사용
String deployId = metadataConnection.deployRecentValidation(validationId);
System.out.println("빠른 배포 시작: " + deployId);
```

---

## retrieve()

조직에서 메타데이터를 .zip 파일로 검색한다. 비동기 호출.

### 시그니처
```java
AsyncResult retrieve(RetrieveRequest retrieveRequest)
```

### RetrieveRequest 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `apiVersion` | double | **Required.** API 버전 (예: 67.0) |
| `packageNames` | string[] | 검색할 패키지 이름 목록 (설치된 패키지) |
| `singlePackage` | boolean | 단일 패키지 여부 |
| `specificFiles` | string[] | 특정 파일만 검색 |
| `rootTypesWithDependencies` | string[] | 의존성을 포함해 검색할 컴포넌트 타입 목록. 현재 `Bot` 타입만 허용. 일별 최대 25회, 1회당 최대 100개 컴포넌트 (v64.0+) |
| `unpackaged` | Package | 패키지에 포함되지 않은 컴포넌트 매니페스트 |

```java
RetrieveRequest request = new RetrieveRequest();
request.setApiVersion(67.0);

// unpackaged 컴포넌트 직접 지정
com.sforce.soap.metadata.Package pkg = new com.sforce.soap.metadata.Package();
PackageTypeMembers ptm = new PackageTypeMembers();
ptm.setName("ApexClass");
ptm.setMembers(new String[]{"*"});
pkg.setTypes(new PackageTypeMembers[]{ptm});
pkg.setVersion("67.0");
request.setUnpackaged(pkg);

AsyncResult asyncResult = metadataConnection.retrieve(request);
```

---

## checkRetrieveStatus()

비동기 검색 작업의 현재 상태를 확인한다. 완료 시 zip 파일 포함.

### 시그니처
```java
RetrieveResult checkRetrieveStatus(String asyncProcessId, boolean includeZip)
```

```java
RetrieveResult retrieveResult;
do {
    Thread.sleep(5000);
    retrieveResult = metadataConnection.checkRetrieveStatus(asyncResultId, true);
} while (!retrieveResult.isDone());

if (retrieveResult.isSuccess()) {
    byte[] zipBytes = retrieveResult.getZipFile();
    Files.write(Paths.get("retrieved.zip"), zipBytes);
    System.out.println("검색 완료. 파일 수: " + retrieveResult.getFileProperties().length);
}
```

---

## sf CLI 래핑 명령어

```bash
# 배포
sf project deploy start --source-dir force-app --target-org myOrg

# 검색
sf project retrieve start --metadata ApexClass --target-org myOrg

# 검증만 (checkOnly=true)
sf project deploy start --source-dir force-app --dry-run --target-org myOrg

# REST 방식으로 배포 (sf CLI)
sf config set org-metadata-rest-deploy true
sf project deploy start --source-dir force-app --target-org myOrg
```

---

## 관련 노트

- [[Metadata API 개요]]
- [[Metadata API REST]]
- [[Metadata API Result Objects]]
- [[Metadata API Headers]]
- [[Salesforce DX 개요]]
- [[CI CD 패턴]]
- [[Metadata API 에러 처리]]
- [[Metadata Types — 개요 및 분류]]
