---
tags: [devops, metadata-api, headers, AllOrNoneHeader, CallOptions, DebuggingHeader, SessionHeader, v67]
source: api_meta.pdf v67.0 Summer '26 — Chapter 14 (Headers)
created: 2026-05-22
aliases: [Metadata API Headers, AllOrNoneHeader, CallOptions, DebuggingHeader, SessionHeader, SOAP 헤더]
---

# Metadata API Headers

> Metadata API SOAP 호출에 옵션을 설정하는 헤더 레퍼런스. 세션 인증, 롤백 제어, 디버그 로그 등.

---

## 헤더 목록

| 헤더 | 지원 버전 | 지원 호출 |
|---|---|---|
| `AllOrNoneHeader` | v34.0+ | `createMetadata()`, `updateMetadata()`, `upsertMetadata()`, `deleteMetadata()` |
| `CallOptions` | 전 버전 | 모든 Metadata API 호출 |
| `DebuggingHeader` | 전 버전 | `deploy()` |
| `SessionHeader` | 전 버전 | 모든 Metadata API 호출 |

---

## AllOrNoneHeader

하나라도 실패 시 전체를 롤백할지 여부를 제어한다.

**버전:** v34.0+

**지원 호출:** `createMetadata()`, `updateMetadata()`, `upsertMetadata()`, `deleteMetadata()`

**기본 동작 (헤더 없음):** 성공한 레코드는 저장하고 실패한 레코드만 오류 반환 (부분 성공 허용).

### 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `allOrNone` | boolean | `true` = 하나라도 실패 시 전체 롤백. `false` = 성공한 것만 저장 |

### 예제

```java
// 전체 롤백 모드 활성화
metadataConnection.setAllOrNoneHeader(true);

SaveResult[] results = metadataConnection.createMetadata(new Metadata[]{co1, co2});
```

### AllOrNoneHeader 사용 예 — 전체 롤백 동작 확인

```java
import com.sforce.soap.metadata.*;
import com.sforce.soap.metadata.Error;
import com.sforce.ws.ConnectionException;

public class CallWithHeader {
    MetadataConnection metadataConnection = null;

    public CallWithHeader() throws ConnectionException {
        metadataConnection = MetadataLoginUtil.login();
    }

    public void createWithHeader() throws ConnectionException {
        // 첫 번째 커스텀 오브젝트 (정상)
        CustomObject co1 = new CustomObject();
        co1.setFullName("MyCustomObject1__c");
        co1.setDeploymentStatus(DeploymentStatus.Deployed);
        co1.setDescription("Created by the Metadata API");
        co1.setEnableActivities(true);
        co1.setLabel("MyCustomObject1 Object");
        co1.setPluralLabel("MyCustomObject1 Objects");
        co1.setSharingModel(SharingModel.ReadWrite);
        CustomField nf = new CustomField();
        nf.setType(FieldType.Text);
        nf.setLabel("MyCustomObject1__c Name");
        co1.setNameField(nf);

        // 두 번째 커스텀 오브젝트 (Name 필드 없음 — 의도적 오류)
        CustomObject co2 = new CustomObject();
        co2.setFullName("MyCustomObject2__c");
        co2.setDeploymentStatus(DeploymentStatus.Deployed);
        co2.setLabel("MyCustomObject2 Object");
        co2.setPluralLabel("MyCustomObject2 Objects");
        co2.setSharingModel(SharingModel.ReadWrite);

        // AllOrNone = true 설정
        metadataConnection.setAllOrNoneHeader(true);

        SaveResult[] results = metadataConnection
            .createMetadata(new Metadata[]{co1, co2});

        for (SaveResult r : results) {
            if (r.isSuccess()) {
                System.out.println("생성됨: " + r.getFullName());
            } else {
                System.out.println("오류 발생: " + r.getFullName());
                for (Error e : r.getErrors()) {
                    System.out.println("  메시지: " + e.getMessage());
                    System.out.println("  상태코드: " + e.getStatusCode());
                }
            }
        }
    }
}
```

**출력 결과 (co2 오류 → co1도 롤백):**
```
오류 발생: MyCustomObject1__c
  메시지: Record rolled back because not all records were valid and the request was using AllOrNone header
  상태코드: ALL_OR_NONE_OPERATION_ROLLED_BACK
오류 발생: MyCustomObject2__c
  메시지: Must specify a nameField of type Text or AutoNumber
  상태코드: FIELD_INTEGRITY_EXCEPTION
```

---

## CallOptions

API 클라이언트 식별자를 지정한다.

**버전:** 전 버전

**지원 호출:** 모든 Metadata API 호출

### 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `client` | string | API 클라이언트를 식별하는 값 |

### 예제

```java
metadataConnection.setCallOptions("MyClientApp/1.0");
```

---

## DebuggingHeader

배포 결과에 디버그 로그 출력을 포함하도록 설정한다. 배포 시 실행된 Apex 테스트의 로그를 포함.

**버전:** 전 버전

**지원 호출:** `deploy()`

### 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `categories` | LogInfo[] | 로그 카테고리와 레벨 목록 |
| `debugLevel` | LogType | **폐기 예정.** `categories`가 있으면 무시됨. (None/Debugonly/Db/Profiling/Callout/Detail) |

### LogInfo 객체

| 필드 | 타입 | 설명 |
|---|---|---|
| `category` | LogCategory | 로그 카테고리 (Db/Workflow/Validation/Callout/Apex_code/Apex_profiling/Visualforce/System/All) |
| `level` | LogCategoryLevel | 로그 레벨 (NONE/ERROR/WARN/INFO/DEBUG/FINE/FINER/FINEST) |

### 예제

```java
LogInfo[] logs = new LogInfo[1];
logs[0] = new LogInfo();
logs[0].setCategory(LogCategory.Apex_code);
logs[0].setLevel(LogCategoryLevel.Fine);
metadataConnection.setDebuggingHeader(logs);

// deploy() 호출
AsyncResult asyncResult = metadataConnection.deploy(zipBytes, options);

// 완료 후 checkDeployStatus()에서 debugLog 필드로 로그 확인
DeployResult result = metadataConnection.checkDeployStatus(asyncResult.getId(), true);
// result.getDetails()에 DebuggingInfo 헤더가 포함됨
```

---

## SessionHeader

로그인 호출이 반환한 세션 ID를 설정하여 이후 Metadata API 호출에서 인증한다.

**버전:** 전 버전

**지원 호출:** 모든 Metadata API 호출

### 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `sessionId` | string | 로그인 호출이 반환한 세션 ID |

### 예제

```java
metadataConnection.setSessionHeader("<session_ID>");
```

> **일반적 사용 패턴:** `MetadataLoginUtil.login()`이 내부적으로 세션 ID를 설정하므로, 직접 `setSessionHeader()`를 호출할 필요는 없다. 기존 세션 ID가 있을 때나 세션을 명시적으로 갱신할 때 사용.

---

## 관련 노트

- [[Metadata API 개요]]
- [[Metadata API CRUD 호출]]
- [[Metadata API File-Based 호출]]
- [[Metadata API Quick Start]]
