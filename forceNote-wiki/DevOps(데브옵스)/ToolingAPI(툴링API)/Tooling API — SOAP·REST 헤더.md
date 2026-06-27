---
tags: [tooling-api, devops, soap, rest, headers, SessionHeader, CallOptions, DebuggingHeader, v67]
source: api_tooling.pdf v67.0 Summer '26 — Chapter 5 (SOAP Headers) · Chapter 6 (REST Headers)
created: 2026-06-27
aliases: [SOAP Headers, REST Headers, SessionHeader, CallOptions, DebuggingHeader, AllOrNoneHeader, PackageVersionHeader, Sforce-Call-Options, Sforce-Limit-Info, Sforce-Query-Options, Tooling API 헤더]
---

# Tooling API — SOAP·REST 헤더

> Tooling API SOAP 호출 동작을 제어하는 SOAP 헤더 8개와 REST 요청 동작을 제어하는 REST 헤더 4개. SOAP 헤더는 SOAP API 헤더와 유사하고, REST 헤더는 REST API 헤더의 서브셋이다.

---

## 개요

Tooling API는 두 가지 헤더 계열을 제공한다.

- **SOAP Headers (Ch5)** — SOAP API 헤더와 유사하며 SOAP 호출의 동작을 제어한다. 8개: `AllOrNoneHeader`, `AllowFieldTruncationHeader`, `CallOptions`, `DebuggingHeader`, `DisableFeedTrackingHeader`, `MetadataWarningsHeader`, `PackageVersionHeader`, `SessionHeader`.
- **REST Headers (Ch6)** — REST API에서 제공되는 REST 헤더의 **서브셋**이며 REST 요청 동작을 제어한다. 4개: `Call Options Header`, `Limit Info Header`, `Package Version Header`, `Query Options Header`.

> [!note] 원문 오타 기록
> Ch5 "In this chapter" 목록에 `AlowFieldTruncationHeader`(l 1개 누락)로 표기된 항목은 PDF 원문 오타다. 실제 섹션 제목과 정식 철자는 `AllowFieldTruncationHeader`다. 본 노트는 정식 철자를 사용한다.

> [!note] Metadata API 헤더와의 관계
> SOAP 헤더 중 `AllOrNoneHeader`·`CallOptions`·`DebuggingHeader`·`SessionHeader` 등은 Metadata API에도 동명 헤더가 있으나 지원 버전·지원 호출이 다를 수 있다(예: `AllOrNoneHeader`는 Metadata API에서 v34.0+, Tooling API SOAP에서는 v20.0+). Metadata API 헤더 레퍼런스는 [[Metadata API Headers]] 참조.

---

## SOAP Headers (Ch5)

### AllOrNoneHeader

호출 내 모든 레코드가 성공적으로 처리되지 않으면 모든 변경을 롤백하도록 허용한다. 헤더가 없으면 오류 없는 레코드는 커밋되고, 오류가 있는 레코드는 호출 결과에서 실패로 표시된다. **API version 20.0 이상**에서 사용 가능.

헤더가 활성화되어 있어도, 각 레코드의 호출 결과에서 `success` 필드를 검사해 오류 레코드를 식별해야 한다. 각 `success` 필드는 true/false를 담는다. 최소 하나의 레코드에 오류가 있으면 해당 레코드의 `errors` 필드가 더 많은 정보를 제공한다. 같은 호출의 다른 레코드에 오류가 없으면 그 레코드의 `errors` 필드는 다른 오류로 인해 롤백되었음을 나타낸다.

- **API Calls:** `create()`, `delete()`, `undelete()`, `update()`, `upsert()`

| Element Name | Type | Description |
|---|---|---|
| `allOrNone` | boolean | true이면 호출 내 실패 레코드가 호출의 모든 변경을 롤백시킨다. 모든 레코드가 성공적으로 처리되지 않는 한 레코드 변경은 커밋되지 않는다. 기본값은 false다. 일부 레코드는 성공 처리되고 다른 레코드는 호출 결과에서 실패로 표시될 수 있다. |

```java
public void allOrNoneHeaderSample() {
  try {
    // Create the first contact.
    SObject[] sObjects = new SObject[2];
    Contact contact1 = new Contact();
    contact1.setFirstName("Robin");
    contact1.setLastName("Van Persie");

    // Create the second contact. This contact doesn't
    // have a value for the required
    // LastName field so the create will fail.
    Contact contact2 = new Contact();
    contact2.setFirstName("Ashley");
    sObjects[0] = contact1;
    sObjects[1] = contact2;

    // Set the SOAP header to roll back the create unless
    // all contacts are successfully created.
    connection.setAllOrNoneHeader(true);
    // Attempt to create the two contacts.
    SaveResult[] sr = connection.create(sObjects);
    for (int i = 0; i < sr.length; i++) {
      if (sr[i].isSuccess()) {
        System.out.println("Successfully created contact with id: " +
          sr[i].getId() + ".");
      }
      else {
        // Note the error messages as the operation was rolled back
        // due to the all or none header.
        System.out.println("Error creating contact: " +
          sr[i].getErrors()[0].getMessage());
        System.out.println("Error status code: " +
          sr[i].getErrors()[0].getStatusCode());
      }
    }
  } catch (ConnectionException ce) {
    ce.printStackTrace();
  }
}
```

---

### AllowFieldTruncationHeader

일부 필드에서 문자열이 너무 클 때 작업을 실패시키도록 지정한다. 헤더가 없으면 이 필드들의 문자열은 잘린다(truncate). 영향을 받는 데이터 타입은 다음과 같다.

- `anyType` (이 목록의 다른 데이터 타입 중 하나를 나타내는 경우)
- `email`
- `encryptedstring`
- `multipicklist`
- `phone`
- `picklist`
- `string`
- `textarea`

15.0 이전 API 버전에서는 위 필드 값이 너무 크면 값이 잘린다. **API version 15.0 이상**에서는 값이 너무 크면 작업이 실패하고 fault code `STRING_TOO_LONG`이 반환된다. `AllowFieldTruncationHeader`는 15.0 이상에서도 이전 동작(절단)을 사용하도록 지정하게 해준다. **버전 14.0 이하에서는 이 헤더가 효과가 없다.**

- **API Calls:** `convertLead()`, `create()`, `merge()`, `process()`, `undelete()`, `update()`, `upsert()`
- **Apex:** `executeanonymous()`

| Element Name | Type | Description |
|---|---|---|
| `allowFieldTruncation` | boolean | true이면 너무 긴 필드 값을 절단한다(API 14.0 이하의 동작). 기본값은 false: 동작 변경 없음. string 또는 textarea 값이 너무 크면 작업이 실패하고 fault code STRING_TOO_LONG이 반환된다. 절단 및 이 헤더의 영향을 받는 필드 타입: anyType(목록의 다른 타입을 나타낼 때) · email · encryptedstring · multipicklist · phone · picklist · string · textarea. |

```java
public void allowFieldTruncationSample() {
  try {
    Account account = new Account();
    // Construct a string that is 256 characters long.
    // Account.Name's limit is 255 characters.
    String accName = "";
    for (int i = 0; i < 256; i++) {
      accName += "a";
    }
    account.setName(accName);
    // Construct an array of SObjects to hold the accounts.
    SObject[] sObjects = new SObject[1];
    sObjects[0] = account;
    // Attempt to create the account. It will fail in API version 15.0
    // and above because the account name is too long.
    SaveResult[] results = connection.create(sObjects);
    System.out.println("The call failed because: "
       + results[0].getErrors()[0].getMessage());
    // Now set the SOAP header to allow field truncation.
    connection.setAllowFieldTruncationHeader(true);
    // Attempt to create the account now.
    results = connection.create(sObjects);
    System.out.println("The call: " + results[0].isSuccess());
  } catch (ConnectionException ce) {
    ce.printStackTrace();
  }
}
```

---

### CallOptions

API 클라이언트 식별자를 지정한다.

- **Version:** 모든 API 버전에서 사용 가능.
- **Supported Calls:** 모든 Metadata API 호출.

| Field Name | Type | Description |
|---|---|---|
| `client` | string | API 클라이언트를 식별하는 값. |

```java
metadataConnection.setCallOptions("client ID");
```

---

### DebuggingHeader

배포 결과에 디버그 로그 출력을 포함하도록 지정하고, 로그에 포함될 세부 수준을 지정한다. 디버그 로그는 배포의 일부로 실행된 Apex 테스트의 출력을 담는다.

- **Version:** 모든 API 버전에서 사용 가능.
- **Supported Calls:** `deploy()`

| Field Name | Type | Description |
|---|---|---|
| `categories` | LogInfo[] | 로그 카테고리와 그에 연관된 로그 레벨의 목록. |
| `debugLevel` | LogType (enumeration of type string) | **Deprecated.** 하위 호환성을 위해서만 제공된다. debugLevel과 categories 둘 다 값을 제공하면 categories 값이 사용된다. debugLevel 필드는 디버그 로그에 반환되는 정보의 유형을 지정한다. 값은 정보량이 가장 적은 것에서 가장 많은 것 순으로 나열된다. |

**debugLevel enum 값 (least → most):** `None`, `Debugonly`, `Db`, `Profiling`, `Callout`, `Detail`

#### LogInfo (sub-object)

디버그 로그에 반환될 정보의 유형과 양을 지정한다. `categories` 필드가 이 객체들의 목록을 받는다. LogInfo는 카테고리 → 레벨의 매핑이다.

| Element Name | Type | Description |
|---|---|---|
| `category` | LogCategory | 디버그 로그에 반환되는 정보의 유형을 지정한다. |
| `level` | LogCategoryLevel | 디버그 로그에 반환되는 세부 수준을 지정한다. |

**LogCategory enum 값:** `Db`, `Workflow`, `Validation`, `Callout`, `Apex_code`, `Apex_profiling`, `Visualforce`, `System`, `All`

**LogCategoryLevel enum 값 (lowest → highest):** `NONE`, `ERROR`, `WARN`, `INFO`, `DEBUG`, `FINE`, `FINER`, `FINEST`

```java
LogInfo[] logs = new LogInfo[1];
logs[0] = new LogInfo();
logs[0].setCategory(LogCategory.Apex_code);
logs[0].setLevel(LogCategoryLevel.Fine);
metadataConnection.setDebuggingHeader(logs);
```

`deploy()` 호출의 결과는 `checkDeployStatus()`를 호출해 얻는다. 배포가 끝나고 테스트가 실행되었다면, checkDeployStatus()의 응답은 `DebuggingInfo` 출력 헤더의 `debugLog` 필드에 디버그 로그 출력을 담는다.

---

### DisableFeedTrackingHeader

현재 호출에서 만든 변경이 피드에 추적되도록(/추적되지 않도록) 지정한다. 레코드 관련 다양한 피드에 변경을 추적하지 않고 많은 레코드를 처리하려면 이 헤더를 사용한다. 조직에 Chatter 기능이 활성화되어 있을 때 사용 가능하다.

- **API Calls:** `convertLead()`, `create()`, `delete()`, `merge()`, `process()`, `undelete()`, `update()`, `upsert()`

| Element Name | Type | Description |
|---|---|---|
| `disableFeedTracking` | boolean | true이면 현재 호출에서 만든 변경이 피드에 추적되지 않는다. 기본값은 false다. |

```java
public void disableFeedTrackingHeaderSample() {
  try {
    // Insert a large number of accounts.
    SObject[] sObjects = new SObject[500];
    for (int i = 0; i < 500; i++) {
       Account a = new Account();
       a.setName("my-account-" + i);
       sObjects[i] = a;
    }
    // Set the SOAP header to disable feed tracking to avoid generating a
    // large number of feed items because of this bulk operation.
    connection.setDisableFeedTrackingHeader(true);
    // Perform the bulk create. This won't result in 500 feed items, which
    // would otherwise be generated without the DisableFeedTrackingHeader.
    SaveResult[] sr = connection.create(sObjects);
    for (int i = 0; i < sr.length; i++) {
      if (sr[i].isSuccess()) {
        System.out.println("Successfully created account with id: " +
          sr[i].getId() + ".");
      } else {
        System.out.println("Error creating account: " +
          sr[i].getErrors()[0].getMessage());
      }
    }
  } catch (ConnectionException ce) {
    ce.printStackTrace();
  }
}
```

---

### MetadataWarningsHeader

경고가 반환되더라도 메타데이터를 저장할 수 있게 한다.

- **Version:** **API version 35.0 이상**에서 사용 가능.
- **Supported Calls:** `delete()`, `update()`, `upsert()`

| Field Name | Type | Description |
|---|---|---|
| `ignoreSaveWarnings` | boolean | true이면 경고가 있어도(단, 오류가 있으면 안 됨) flow 같은 메타데이터를 저장할 수 있다. *Allow Metadata Save Operations to Complete with Returned Warnings*도 참조. |

> 원문 섹션 제목이 단수 "Field"(복수 "Fields"가 아님)다 — 필드가 1개이기 때문.

---

### PackageVersionHeader

설치된 각 managed package의 패키지 버전을 지정한다. 하나의 managed package는 내용·동작이 다른 여러 버전을 가질 수 있다. 이 헤더로 API 클라이언트가 참조하는 각 패키지의 사용 버전을 지정할 수 있다.

패키지 버전을 지정하지 않으면 API 클라이언트는 Setup에서 지정된 패키지 버전을 사용한다. Setup에서 Quick Find에 API를 입력 → **API** 선택 → **Enterprise Package Version Settings** 아래 **Configure Enterprise Package Version Settings** 클릭. **API version 16.0 이상**에서 사용 가능.

- **Associated API Calls:** `convertLead()`, `create()`, `delete()`, `describeGlobal()`, `describeLayout()`, `describeSObject()`, `describeSObjects()`, `describeSoftphoneLayout()`, `describeTabs()`, `executeAnonymous()`, `merge()`, `process()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

| Element Name | Type | Description |
|---|---|---|
| `packageVersions` | PackageVersion[] | API 클라이언트가 참조하는 설치된 managed package들의 패키지 버전 목록. |

#### PackageVersion (sub-object)

설치된 managed package의 한 버전을 지정한다. 패키지 버전은 `majorNumber.minorNumber` 형식이다(예: 2.1).

| Field | Type | Description |
|---|---|---|
| `majorNumber` | int | 패키지 버전의 메이저 버전 번호. |
| `minorNumber` | int | 패키지 버전의 마이너 버전 번호. |
| `namespace` | string | managed package의 고유 네임스페이스. |

```java
import com.sforce.soap.apex.SoapConnection;
import com.sforce.soap.apex.PackageVersion;
import com.sforce.soap.apex.ExecuteAnonymousResult;

public void PackageVersionHeaderSample(SoapConnection connection, String code) throws
Exception {

  com.sforce.soap.apex.PackageVersion pv = new com.sforce.soap.apex.PackageVersion();
  pv.setNamespace("installedPackageNamespaceHere");
  pv.setMajorNumber(1);
  pv.setMinorNumber(5);

  PackageVersion[] pvs = new PackageVersion[]{pv};
  connection.setPackageVersionHeader(pvs);

  ExecuteAnonymousResult result = connection.executeAnonymous(apexCode);

  if (result.isCompiled()) {
     System.out.println("Compiled successfully.");
    System.out.println("Execution result: " + (result.isSuccess() ? "SUCCESS" : "FAILED!"));

     if (!result.isSuccess()) {
         System.out.println("Cause: " + result.getExceptionMessage());
         System.out.println(result.getExceptionStackTrace());
     }
  } else {
     System.out.println("Failed to compile: " + result.getCompileProblem());
  }
}
```

---

### SessionHeader

성공적인 `login()` 후 로그인 서버에서 반환된 세션 ID를 지정한다. 이 세션 ID는 이후의 모든 호출에 사용된다. 버전 12.0 이상에서는 이 헤더와 연관된 SOAP 메시지에 API 네임스페이스를 포함한다. 네임스페이스는 enterprise 또는 partner WSDL에 정의되어 있다.

- **API Calls:** 유틸리티 호출을 포함한 모든 호출.

| Element Name | Type | Description |
|---|---|---|
| `sessionId` | string | 이후 호출 인증에 사용되도록 login() 호출이 반환한 세션 ID. |

**Sample Code:** `login()`에 제공된 예시 참조.

---

## REST Headers (Ch6)

Tooling API는 REST API에서 사용 가능한 REST 헤더의 서브셋을 제공한다.

### Call Options Header

REST API 리소스에 접근하는 데 사용하는 클라이언트의 옵션을 지정한다. 예를 들어 기본 네임스페이스 프리픽스를 제공해 코드에서 프리픽스를 매번 지정하지 않아도 된다.

이 헤더는 **sObject Basic Information, sObject Rows, sObject Rows by External ID, Query, QueryAll, Search**와 함께 사용할 수 있다. **Bulk API 및 Bulk API 2.0**에서도 지원된다.

- **Field name:** `Sforce-Call-Options`
- **Field values:**
  - `client` — 요청을 보내는 클라이언트의 식별자로 사용되는 문자열. 이 문자열은 로그 파일에 나타나 어느 클라이언트가 요청을 보냈는지 추적하는 데 도움이 된다.
  - `defaultNamespace` — 요청의 기본 네임스페이스로 사용되는 개발자 네임스페이스 프리픽스. 이 헤더 필드로 네임스페이스가 지정되지 않은 managed package의 필드명을 요청이 해결한다. **(Bulk API에서는 지원되지 않음.)**

```http
Sforce-Call-Options: client=caseSensitiveToken; defaultNamespace=battle
```

개발자 네임스페이스 프리픽스가 `battle`이고 패키지에 `botId`라는 커스텀 필드가 있을 때 위처럼 기본 네임스페이스를 설정하면, 다음과 같은 쿼리가 성공한다.

```
/services/data/vXX.X/query/?q=SELECT+Id+botID__c+FROM+Account
```

이 경우 실제 쿼리되는 필드는 `battle__botId__c`다. 이 헤더를 쓰면 네임스페이스 프리픽스를 지정하지 않고 클라이언트 코드를 작성할 수 있다(헤더 없이는 `battle__botId__c`라고 써야 한다).

이 필드를 설정하고 쿼리에서도 네임스페이스를 지정하면, 응답에는 프리픽스가 포함되지 않는다. 예를 들어 이 헤더를 `battle`로 설정하고 `SELECT+Id+battle__botID__c+FROM+Account` 쿼리를 보내면, 응답은 `battle_botId__c`가 아닌 `botId__c` 요소를 사용한다. describe 정보를 검색할 때는 `defaultNamespace` 필드가 무시되며, 이는 네임스페이스 프리픽스와 동명의 고객 필드 간 모호성을 피한다.

---

### Limit Info Header

REST API의 각 요청에 반환되는 **응답 헤더**다(단, 조직 한도에 포함되지 않는 Versions URI `/` 호출은 제외). 이 정보로 API 한도를 모니터링할 수 있다.

- **Field name:** `Sforce-Limit-Info`
- **Field values:**
  - `api-usage` — 호출이 이루어진 조직의 일일 API 사용량을 지정한다. 첫 번째 숫자는 사용된 API 호출 수, 두 번째 숫자는 조직의 API 한도다. 헤더에 반환되는 값은 표준 REST API 한도·사용량을 나타내되, Salesforce Functions를 사용한 호출은 예외다 — Salesforce Functions 호출은 Functions 전용 할당량에서 차감된다.

```http
Sforce-Limit-Info: api-usage=10018/100000
```

---

### Package Version Header

클라이언트가 참조하는 각 패키지의 버전을 지정한다. 패키지 버전은 패키지에 포함된 컴포넌트 집합과 동작을 식별하는 번호다. 이 헤더는 Apex REST 웹 서비스 호출 시 패키지 버전을 지정하는 데도 사용할 수 있다.

이 헤더는 다음 리소스와 함께 사용할 수 있다: **Describe Global, sObject Describe, sObject Basic Information, sObject Rows, sObject Layouts, Query, QueryAll, Search, sObject Rows by External ID**.

- **Field name and value:** `x-sfdc-packageversion-[namespace]: xx.x` — `[namespace]`는 managed package의 고유 네임스페이스, `xx.x`는 패키지 버전.

```http
x-sfdc-packageversion-clientPackage: 1.0
```

---

### Query Options Header

쿼리 결과 배치 크기 등 쿼리에 사용되는 옵션을 지정한다. 이 요청 헤더는 **Query** 리소스와 함께 사용한다.

- **Field name:** `Sforce-Query-Options`
- **Field values:**
  - `batchSize` — 쿼리 요청에 반환되는 레코드 수를 지정하는 숫자 값. 자식 객체도 배치 크기의 레코드 수에 포함된다(예: 관계 쿼리에서 부모 행당 여러 자식 객체가 반환됨). **기본값은 2,000, 최소값은 200, 최대값은 2,000**이다. 요청한 배치 크기가 실제 배치 크기가 된다는 보장은 없으며, 성능 극대화를 위해 필요에 따라 조정된다.

```http
Sforce-Query-Options: batchSize=1000
```

---

## SOAP 헤더 요약표

| 헤더 | 지원 버전 | 지원 호출 |
|---|---|---|
| `AllOrNoneHeader` | v20.0+ | `create()`, `delete()`, `undelete()`, `update()`, `upsert()` |
| `AllowFieldTruncationHeader` | v15.0+ (v14.0 이하 무효) | `convertLead()`, `create()`, `merge()`, `process()`, `undelete()`, `update()`, `upsert()`, Apex `executeanonymous()` |
| `CallOptions` | 전 버전 | 모든 Metadata API 호출 |
| `DebuggingHeader` | 전 버전 | `deploy()` |
| `DisableFeedTrackingHeader` | (Chatter 활성 시) | `convertLead()`, `create()`, `delete()`, `merge()`, `process()`, `undelete()`, `update()`, `upsert()` |
| `MetadataWarningsHeader` | v35.0+ | `delete()`, `update()`, `upsert()` |
| `PackageVersionHeader` | v16.0+ | `convertLead()`, `create()`, `delete()`, 각종 `describe*()`, `executeAnonymous()`, `merge()`, `process()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()` |
| `SessionHeader` | (v12.0+ 네임스페이스 포함) | 유틸리티 포함 모든 호출 |

## REST 헤더 요약표

| 헤더 | HTTP 필드명 | 종류 |
|---|---|---|
| `Call Options Header` | `Sforce-Call-Options` | 요청 (client, defaultNamespace) |
| `Limit Info Header` | `Sforce-Limit-Info` | 응답 (api-usage) |
| `Package Version Header` | `x-sfdc-packageversion-[namespace]` | 요청 |
| `Query Options Header` | `Sforce-Query-Options` | 요청 (batchSize 200~2,000, 기본 2,000) |

---

## 관련 노트

- [[Tooling API — 개요·REST·SOAP 호출 기초]] — Tooling API 호출 기초(REST/SOAP) 허브
- [[Tooling API — Objects and Namespaces (객체 분류)]] — 객체 분류·네임스페이스 색인(`MetadataWarningsHeader` 등 참조)
- [[Metadata API Headers]] — Metadata API SOAP 헤더 레퍼런스(동명 헤더 비교)
