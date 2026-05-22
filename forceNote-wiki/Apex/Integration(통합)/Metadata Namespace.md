---
tags: [apex, metadata, namespace, custom-metadata, deploy, reference]
source: salesforce_apex_reference_guide.pdf v67.0 — Metadata Namespace (p.3101~3175)
created: 2026-05-18
aliases: [Metadata Namespace, CustomMetadata, DeployCallback, enqueueDeployment, Operations.enqueueDeployment, 메타데이터 배포]
---

# Metadata Namespace

> Apex에서 Custom Metadata Type 레코드를 읽고 배포하는 API. API v40.0 이상.

---

## 핵심 개념

| 역할 | 클래스 |
|---|---|
| 배포할 CMT 레코드 표현 | `Metadata.CustomMetadata` |
| 필드 값 표현 | `Metadata.CustomMetadataValue` |
| 배포 컨테이너 | `Metadata.DeployContainer` |
| 비동기 배포 실행 | `Metadata.Operations.enqueueDeployment()` |
| 동기 조회 | `Metadata.Operations.retrieve()` |
| 배포 콜백 인터페이스 | `Metadata.DeployCallback` |
| 배포 결과 | `Metadata.DeployResult` |

---

## 전형적인 배포 흐름

```
CustomMetadata → DeployContainer.addMetadata()
              → Operations.enqueueDeployment(container, callback)
              → (비동기) DeployCallback.handleResult(result, context)
              → result.status == DeployStatus.Succeeded
```

---

## CustomMetadata Class

Custom Metadata Type 레코드를 표현한다.

```apex
// 구조: namespace__TypeName.RecordName
Metadata.CustomMetadata customMetadata = new Metadata.CustomMetadata();
customMetadata.fullName = 'ISVNamespace__MetadataTypeName.MetadataRecordName';
customMetadata.label   = 'My Record Label';
customMetadata.description = '선택 설명';

Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
customField.field = 'customField__c';
customField.value = 'New value';
customMetadata.values.add(customField);
```

### Properties

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `description` | String | CMT 레코드 설명 |
| `label` | String | CMT 레코드 레이블 |
| `protected_x` | Boolean | 보호 컴포넌트 여부 |
| `values` | List\<CustomMetadataValue\> | 필드 값 목록 |

> **경고**: Protected CMT는 managed package 밖에서는 public처럼 동작. 비밀 정보(OAuth 토큰, 비밀번호)는 Custom Metadata에 저장하지 말 것 → Named Credentials 또는 암호화 필드 사용.

---

## CustomMetadataValue Class

CMT 레코드의 개별 필드 값을 표현한다.

```apex
Metadata.CustomMetadataValue val = new Metadata.CustomMetadataValue();
val.field = 'ApiEndpoint__c';   // 필드 API명
val.value = 'https://api.example.com'; // 필드 값 (Object 타입)
```

### Properties

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `field` | String | 필드 API명 |
| `value` | Object | 필드 값 |

---

## DeployContainer Class

배포할 CMT 컴포넌트의 컨테이너. 하나 이상의 컴포넌트를 담아 배포한다.

```apex
Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
mdContainer.addMetadata(customMetadata); // 같은 fullName 중복 추가 금지
```

### Methods

| 메서드 | 반환 | 설명 |
|---|---|---|
| `addMetadata(Metadata.Metadata md)` | void | 컴포넌트 추가 |
| `getMetadata()` | List\<Metadata.Metadata\> | 컴포넌트 목록 반환 |
| `removeMetadata(Metadata.Metadata md)` | Boolean | 컴포넌트 제거 |
| `removeMetadataByFullName(String fullName)` | Boolean | 이름으로 제거 |

---

## DeployCallback Interface

비동기 배포 완료 후 Salesforce가 호출하는 콜백. 반드시 구현해야 함.

```apex
public class MyCallback implements Metadata.DeployCallback {
    public void handleResult(
        Metadata.DeployResult result,
        Metadata.DeployCallbackContext context
    ) {
        if (result.status == Metadata.DeployStatus.Succeeded) {
            // 성공 처리
        } else {
            // 실패 처리 — result.details.componentFailures 확인
            for (Metadata.DeployMessage msg : result.details.componentFailures) {
                System.debug('실패: ' + msg.fullName + ' — ' + msg.problem);
            }
        }
    }
}
```

### handleResult(var1, var2)

```apex
public void handleResult(
    Metadata.DeployResult var1,
    Metadata.DeployCallbackContext var2
)
```

---

## DeployCallbackContext Class

콜백에서 배포 작업 ID를 얻는 데 사용한다.

```apex
public void handleResult(Metadata.DeployResult result,
                         Metadata.DeployCallbackContext context) {
    Id jobId = context.getCallbackJobId();
}
```

### Methods

| 메서드 | 반환 | 설명 |
|---|---|---|
| `getCallbackJobId()` | Id | 비동기 Apex 작업 ID |

---

## Operations Class

CMT 조회(`retrieve`)와 비동기 배포(`enqueueDeployment`)를 실행하는 클래스.

### enqueueDeployment(container, callback)

CMT 컴포넌트를 비동기로 배포한다.

```apex
public static Id enqueueDeployment(
    Metadata.DeployContainer container,
    Metadata.DeployCallback callback
)
```

동시 배포 대기 수에 제한 있음(가이드 참조).

### retrieve(type, fullNames)

CMT 레코드를 동기 조회한다.

```apex
public static List<Metadata.Metadata> retrieve(
    Metadata.MetadataType type,
    List<String> fullNames
)
```

---

## 전체 예제: 조회 → 수정 → 배포

```apex
// 1. 조회
List<String> names = new List<String>{
    'ISVNamespace__TestCustomMDType.MyTestCustomMDType'
};
List<Metadata.Metadata> components =
    Metadata.Operations.retrieve(Metadata.MetadataType.CustomMetadata, names);
Metadata.CustomMetadata rec = (Metadata.CustomMetadata) components.get(0);

// 2. 수정
for (Metadata.CustomMetadataValue v : rec.values) {
    if (v.field == 'testField__c') {
        v.value = 'updated value';
    }
}

// 3. 배포
Metadata.DeployContainer container = new Metadata.DeployContainer();
container.addMetadata(rec);

MyCallback callback = new MyCallback(); // implements DeployCallback
Id jobId = Metadata.Operations.enqueueDeployment(container, callback);
```

### 부모-자식 레코드 동시 생성

```apex
public Id doCreate(String parentDev, String parentLabel,
                   String childDev, String childLabel) {
    Metadata.DeployContainer c = new Metadata.DeployContainer();

    Metadata.CustomMetadata parent = new Metadata.CustomMetadata();
    parent.fullName = 'ParentType.' + parentDev;
    parent.label    = parentLabel;
    c.addMetadata(parent);

    Metadata.CustomMetadata child = new Metadata.CustomMetadata();
    child.fullName = 'ChildType.' + childDev;
    child.label    = childLabel;
    Metadata.CustomMetadataValue rel = new Metadata.CustomMetadataValue();
    rel.field = 'Parent__c';
    rel.value = parentDev; // 부모 DeveloperName 참조
    child.values.add(rel);
    c.addMetadata(child);

    // callback null 허용 (결과 처리 불필요 시)
    return Metadata.Operations.enqueueDeployment(c, null);
}
```

> 동일 타입끼리의 CMT 관계는 불가.

---

## DeployResult Properties

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `status` | DeployStatus | 현재 배포 상태 |
| `success` | Boolean | 성공 여부 |
| `done` | Boolean | Salesforce 처리 완료 여부 |
| `details` | DeployDetails | 성공/실패 컴포넌트 상세 |
| `id` | Id | 배포 작업 ID |
| `createdDate` | Datetime | 배포 큐 등록 시각 |
| `completedDate` | Datetime | 배포 완료 시각 |
| `startDate` | Datetime | 배포 시작 시각 |
| `numberComponentsTotal` | Integer | 전체 컴포넌트 수 |
| `numberComponentsDeployed` | Integer | 배포 완료 컴포넌트 수 |
| `numberComponentErrors` | Integer | 오류 컴포넌트 수 |
| `checkOnly` | Boolean | check-only 배포 여부 |
| `rollbackOnError` | Boolean | 오류 시 전체 롤백 여부 |
| `ignoreWarnings` | Boolean | 경고 무시 여부 |
| `errorMessage` | String | 오류 메시지 |
| `stateDetail` | String | 현재 배포 중인 컴포넌트 |
| `canceledBy` | String | 취소한 사용자 ID |

---

## DeployDetails Properties

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `componentSuccesses` | List\<DeployMessage\> | 성공 컴포넌트 목록 |
| `componentFailures` | List\<DeployMessage\> | 실패 컴포넌트 목록 |

---

## DeployMessage Properties

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `fullName` | String | 컴포넌트 전체 이름 |
| `componentType` | String | 메타데이터 타입 |
| `success` | Boolean | 배포 성공 여부 |
| `changed` | Boolean | 배포로 변경됨 여부 |
| `created` | Boolean | 신규 생성 여부 |
| `deleted` | Boolean | 삭제 여부 |
| `problem` | String | 오류/경고 설명 |
| `problemType` | DeployProblemType | 문제 유형 |
| `lineNumber` | Integer | 오류 발생 줄 번호 |
| `columnNumber` | Integer | 오류 발생 열 번호 |
| `id` | Id | 배포된 컴포넌트 ID |
| `createdDate` | Datetime | 컴포넌트 생성 시각 |

---

## Enums

### DeployStatus

| 값 | 설명 |
|---|---|
| `Pending` | 큐 등록, 아직 시작 안 됨 |
| `InProgress` | 배포 진행 중 |
| `FinalizingDeploy` | 마무리 단계 (취소 불가) |
| `Succeeded` | 배포 성공 |
| `SucceededPartial` | 일부 성공 (상세 확인 필요) |
| `Failed` | 배포 실패 |
| `Canceled` | 취소됨 |
| `Canceling` | 취소 진행 중 |
| `FinalizingDeployFailed` | 마무리 단계 실패 |

### DeployProblemType

| 값 | 설명 |
|---|---|
| `Error` | 오류 |
| `Warning` | 경고 |
| `Info` | 정보성 |

### MetadataType

| 값 | 설명 |
|---|---|
| `CustomMetadata` | Custom Metadata Type 레코드 |
| `Layout` | 페이지 레이아웃 |

---

## Layout 관련 클래스 (요약)

Layout 메타데이터를 Apex에서 다룰 때 사용. 주로 ISV/패키지 배포에 활용.

| 클래스 | 용도 |
|---|---|
| `Metadata.Layout` | 페이지 레이아웃 전체 |
| `Metadata.LayoutSection` | 레이아웃 섹션 |
| `Metadata.LayoutColumn` | 섹션 내 컬럼 |
| `Metadata.LayoutItem` | 레이아웃 아이템 |
| `Metadata.MiniLayout` | Console 탭 미니 뷰 |
| `Metadata.FeedLayout` | Feed 기반 레이아웃 |
| `Metadata.SummaryLayout` | Highlights Panel (Case Feed) |
| `Metadata.PlatformActionList` | 모바일 액션 바 목록 |
| `Metadata.QuickActionList` | Quick Action 목록 |
| `Metadata.RelatedList` | 관련 목록 |
| `Metadata.SidebarComponent` | Console 사이드바 컴포넌트 |

---

## 관련 노트

- [[Custom Metadata Types]] (미작성 — CMDT 설계 가이드)
- [[Queueable]] — 배포 후 Queueable 체이닝 패턴
- [[RestClient 패턴]] — 외부 API 호출 패턴
- [[MetadataAPI/Metadata API 개요]] — Metadata API Developer Guide (SOAP/REST 배포·검색 API)
- [[MetadataAPI/Metadata API CRUD 호출]] — createMetadata/readMetadata 등 동기 CRUD
