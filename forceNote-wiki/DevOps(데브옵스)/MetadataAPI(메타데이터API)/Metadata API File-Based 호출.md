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

컴포넌트를 삭제할 때 사용. 형식은 `package.xml`과 동일하나 **와일드카드(`*`) 미지원**. 삭제 전용 배포라도 **컴포넌트 없이 API 버전만 명시한 `package.xml`을 같은 디렉터리에 반드시 함께 포함**해야 한다.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
    <types>
        <members>MyOldObject__c</members>
        <name>CustomObject</name>
    </types>
</Package>
```

삭제 전용 배포에 동봉하는 빈 `package.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
    <version>67.0</version>
</Package>
```

### 삭제 매니페스트 3종 — 처리 시점

추가/업데이트(`package.xml`)와 삭제를 **한 번의 배포**에 섞을 수 있다.

| 매니페스트 | 처리 시점 | 비고 |
|---|---|---|
| `destructiveChanges.xml` | **기본값: 추가/업데이트 이전** 처리 ("By default, deletions are processed before component additions") | 삭제 전용 또는 혼합 배포 |
| `destructiveChangesPre.xml` | 추가/업데이트 **이전** 삭제 | v33.0+ |
| `destructiveChangesPost.xml` | 추가/업데이트 **이후** 삭제 | v33.0+. Post 삭제는 테스트 실행 **전**에 처리됨 |

**의존성 예시 (Post 사용):** Apex 클래스가 커스텀 오브젝트를 참조 중이면 그 오브젝트를 바로 삭제할 수 없다 → 한 번의 배포에서 `package.xml`로 클래스를 수정해 참조를 제거한 뒤, `destructiveChangesPost.xml`로 커스텀 오브젝트를 삭제한다.

**제약·주의:**
- **active Lightning page에 연관된 항목**(페이지가 참조하는 커스텀 오브젝트·페이지 위 컴포넌트·페이지 자체)은 `destructiveChanges.xml`로 삭제 불가 — 먼저 Lightning App Builder에서 페이지를 비활성화해 action override를 제거해야 한다.
- Recycle Bin을 우회하려면 `purgeOnDelete=true`. 단 roll-up summary 필드는 이 옵션과 무관하게 Recycle Bin에 저장되지 않고 영구 삭제된다.
- org에 존재하지 않는 컴포넌트가 삭제 목록에 있어도 나머지 삭제는 계속 시도된다.
- Apex 클래스/트리거 삭제 시, 남은 참조를 탐지하도록 해당 네임스페이스의 **로컬 테스트 전체 실행**을 권장.

**sf CLI 플래그:**

```bash
# 추가 이전 삭제 (Pre)
sf project deploy start --manifest package.xml --pre-destructive-changes destructiveChangesPre.xml

# 추가 이후 삭제 (Post)
sf project deploy start --manifest package.xml --post-destructive-changes destructiveChangesPost.xml
```

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
| `rollbackOnError` | boolean | 하나라도 오류 시 전체 롤백 (기본 false). `false`면 오류 없는 액션만 수행하고 나머지는 오류 반환(부분 성공). **프로덕션 org 배포 시 반드시 `true`여야 함 — 프로덕션은 부분 배포 불허** ("This parameter must be set to true if you're deploying to a production org") |
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

### RunRelevantTests (Beta)

배포 시간을 줄이기 위해, 배포와 **관련된 Apex 테스트만** 자동 선택해 실행하는 테스트 레벨(Beta).

> [!note] Beta 약관
> `RunRelevantTests` 테스트 레벨 및 관련 `@IsTest()` 어노테이션은 pilot/beta 서비스로, [Beta Services Terms](https://www.salesforce.com/company/legal/agreements/)(또는 체결된 Unified Pilot Agreement, Product Terms Directory의 해당 조항)가 적용된다. 사용은 고객 재량.

**자동 선택 근거**
Salesforce가 배포 **payload**와 **payload dependencies**를 분석해 관련 테스트를 자동 식별한다. `RunSpecifiedTests`처럼 적용 테스트를 수동 판별(흔히 custom DevOps tooling 필요)할 필요가 없고, `RunLocalTests`와 달리 실행 테스트 수가 **배포 크기에 비례**해 스케일된다(작은 배포 = 적은 관련 테스트).

**커버리지 요건 (최우선)**
`RunRelevantTests`를 설정해도 배포 패키지에 포함된 **모든 class와 trigger 각각이 최소 75% 코드 커버리지**를 충족해야 한다. 이 커버리지는 **class·trigger 단위로 개별 산정**되며, overall coverage percentage와는 **다르다**. 커버리지 미달 시 아래 어노테이션으로 테스트 스위트를 보강할 수 있다.

**어노테이션 오버라이드**
`RunRelevantTests`로 실행되는 테스트를 세밀하게 제어하려면 `@IsTest` 어노테이션을 쓴다. 구현 상세는 Apex Developer Guide의 [@IsTest(critical=true) / @IsTest(testFor='...')](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_annotation_istest.htm) 참조 (어노테이션 동작은 API **v66.0+** 한정 — 릴리즈 노트 → [[Spring '26/Development]] §변경).

| 어노테이션 | 동작 |
|---|---|
| `@IsTest(critical=true)` | 배포 payload의 class/trigger와 **무관하게 항상 실행** |
| `@IsTest(testFor='ApexClass:Name, ApexTrigger:Name')` | 지정한 컴포넌트가 payload에서 **새로 추가되거나 변경될 때** 실행 |

**설정법**

```java
// DeployOptions 객체 생성
DeployOptions deployOptions = new DeployOptions();

// 테스트 레벨 설정
deployOptions.setTestLevel(TestLevel.RunRelevantTests);

// deploy() 호출 시 인자로 전달
AsyncResult asyncResult = metadatabinding.deploy(zipBytes, deployOptions);
```

| 경로 | 지정 방법 |
|---|---|
| File-Based (deploy) | `deployOptions.setTestLevel(TestLevel.RunRelevantTests)` |
| REST | request body의 `deployOptions.testLevel`에 `RunRelevantTests` 설정 (→ [[Metadata API REST]]) |
| Salesforce CLI | `sf project deploy start --test-level RunRelevantTests` (지원 project 명령의 `--test-level` 플래그) |

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

`checkOnly=true`로 성공한 최근 검증 결과를 실제 배포한다. 테스트 재실행 없이 빠른 배포 가능 — 검증 성공 후 **10일 이내** ("validated successfully for the target environment within the last 10 days").

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

# 검증만 (checkOnly=true) — 일회성 확인용
sf project deploy start --source-dir force-app --dry-run --target-org myOrg

# 검증만 (checkOnly=true) — Quick Deploy용 Job ID 발급
sf project deploy validate --source-dir force-app --target-org myOrg
sf project deploy quick --job-id <검증 Job ID> --target-org myOrg

# REST 방식으로 배포 (sf CLI)
sf config set org-metadata-rest-deploy true
sf project deploy start --source-dir force-app --target-org myOrg
```

> **`--dry-run` vs `deploy validate`:** 둘 다 `checkOnly=true` 검증이지만, `--dry-run`의 Job ID는 **Quick Deploy(`deployRecentValidation()`)에 사용할 수 없다.** 나중에 `sf project deploy quick`으로 배포할 검증은 반드시 `sf project deploy validate`로 만든다 (검증 성공 후 10일 이내 — [[Metadata API 빌드·릴리스 워크플로]] 참조).

---

## 관련 노트

- [[Metadata API 개요]]
- [[Metadata API REST]]
- [[Metadata API Result Objects]]
- [[Metadata API Headers]]
- [[Salesforce DX 개요]]
- [[CI CD 패턴]]
- [[Metadata API 에러 처리]]
- [[Tooling API 배포]] — 또 다른 프로그래밍 방식 배포(peer). File-Based는 .zip+package.xml로 대규모·전체 메타데이터 일괄 배포, Tooling API는 complex type 안 단일 요소(클래스·트리거 등)만 fine-grained 컴파일·배포
- [[Metadata Types — 개요 및 분류]]
