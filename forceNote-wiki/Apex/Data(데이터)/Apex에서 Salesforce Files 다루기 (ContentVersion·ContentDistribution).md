---
tags: [apex, salesforce-files, contentversion, contentdocumentlink, contentdistribution, file-upload, public-link, data]
source: apex-recipes-main/force-app/main/default/classes/Files Recipes/FilesRecipes.cls (Tier 1 실전 예시) + developer.salesforce.com Object Reference — ContentVersion·ContentDocumentLink·ContentDistribution (Tier 2 레퍼런스)
created: 2026-07-04
aliases: [Salesforce Files Apex, ContentVersion insert, 파일 생성 Apex, 레코드에 파일 첨부, 공개 링크 생성, ContentDistribution public url, ContentDocumentLink share, 파일 첨부 Apex]
---

# Apex에서 Salesforce Files 다루기 (ContentVersion·ContentDistribution)

> Apex로 파일(ContentVersion)을 생성하고, 레코드에 연결(ContentDocumentLink)하며, 인증 없는 공개 링크(ContentDistribution)로 배포하는 전체 패턴 — 세 객체의 필드·옵션·제약을 레퍼런스로 정리한다.

---

## 0. Salesforce Files 데이터 모델 — 세 객체의 관계

Salesforce Files(구 Chatter Files)는 세 개의 객체가 삼각형을 이룬다. Apex에서 파일을 다룰 때 이 관계를 이해하는 게 핵심이다.

```
// 구조 예시 — 실제 원본 다이어그램 아님
ContentDocument (파일의 논리적 컨테이너, 버전들을 묶는 부모)
   │  1
   │
   ├──< ContentVersion  (N)  실제 바이너리·메타데이터를 담은 "버전"
   │        └ IsLatest=true 인 버전이 현재 버전
   │
   ├──< ContentDocumentLink (N)  파일 ↔ 레코드/사용자/그룹/라이브러리 공유 링크
   │
   └──< ContentDistribution (N)  파일 ↔ 외부 공개 배포 링크(인증 불필요)
```

| 객체 | 역할 | 삽입 시점에 만드는 것 |
|---|---|---|
| `ContentVersion` | 파일의 실제 내용(Blob)과 메타데이터를 담는 **버전**. 파일을 만들 때 **직접 insert 하는 것은 이것**이다. | 개발자가 insert |
| `ContentDocument` | 여러 버전을 묶는 논리적 파일. **직접 insert 하지 않는다** — 첫 ContentVersion을 insert하면 시스템이 자동 생성. | 시스템 자동 |
| `ContentDocumentLink` | 파일을 특정 레코드/사용자/그룹과 **공유**하는 링크. | 개발자 또는 `FirstPublishLocationId`로 자동 |
| `ContentDistribution` | 파일을 **인증 없이** 외부에 공개하는 배포 링크. `DistributionPublicUrl` 발급. | 개발자가 insert |

---

## 1. 파일 생성 + 레코드 첨부 — ContentVersion insert (실전 코드)

파일 하나를 만들어 곧바로 레코드에 붙이는 가장 간단한 길은 **ContentVersion 하나를 insert하면서 `FirstPublishLocationId`에 대상 레코드 Id를 넣는 것**이다. 그러면 ContentDocument와 ContentDocumentLink가 자동 생성된다.

`FilesRecipes.cls`의 실전 코드:

```apex
public static Database.SaveResult createFileAttachedToRecord(
    Blob fileContents,
    Id attachedTo,
    String fileName
) {
    ContentVersion fileToUpload = new ContentVersion();
    // S = Salesforce. The other options are: 'E' (external)
    // and 'L' (social customer service)
    fileToUpload.ContentLocation = 'S';
    fileToUpload.PathOnClient = fileName;
    fileToUpload.Title = fileName;
    fileToUpload.VersionData = fileContents;
    fileToUpload.FirstPublishLocationId = attachedTo;
    Database.SaveResult saveResult;
    try {
        saveResult = Database.insert(fileToUpload, AccessLevel.USER_MODE);
    } catch (DmlException DMLe) {
        System.debug(
            LoggingLevel.INFO,
            'Failed to insert fileToUpload, error is: ' + DMLe.getMessage()
        );
    }
    return saveResult;
}
```

문자열을 파일로 만드는 편의 래퍼(같은 클래스):

```apex
public static void createFileFromStringAttachedToRecord(
    String text,
    Id firstLocation
) {
    Blob fileContents = Blob.valueOf(text);
    FilesRecipes.createFileAttachedToRecord(
        fileContents,
        firstLocation,
        'AwesomeFile1'
    );
}
```

### 벌크 insert — 여러 파일을 한 DML로

`FilesRecipes.cls`는 내부 클래스 `FileAndLinkObject`(fileContents·attachedTo·fileName)로 파일들을 모아 한 번에 insert한다. 파일마다 개별 DML을 치지 않는 게 벌크 관용구다.

```apex
public static List<Database.SaveResult> createFilesAttachedToRecords(
    List<FilesRecipes.FileAndLinkObject> toCreate
) {
    List<ContentVersion> filesToCreate = new List<ContentVersion>();
    for (FilesRecipes.FileAndLinkObject files : toCreate) {
        ContentVersion fileToUpload = new ContentVersion();
        fileToUpload.ContentLocation = 'S';
        fileToUpload.PathOnClient = files.fileName;
        fileToUpload.Title = files.fileName;
        fileToUpload.VersionData = files.fileContents;
        fileToUpload.FirstPublishLocationId = files.attachedTo;
        filesToCreate.add(fileToUpload);
    }
    List<Database.SaveResult> saveResult = new List<Database.SaveResult>();
    try {
        saveResult = Database.insert(filesToCreate, AccessLevel.USER_MODE);
    } catch (DmlException DMLe) {
        System.debug(LoggingLevel.INFO, 'Failed... ' + DMLe.getMessage());
    }
    return saveResult;
}
```

> 실전 코드는 `Database.insert(..., AccessLevel.USER_MODE)`로 현재 사용자의 CRUD/FLS를 강제한다 → [[DML 패턴]] · [[Database Namespace 상세]] 참조.

---

## 2. ContentVersion 필드 레퍼런스 (Tier 2)

파일을 insert할 때 채우는 주요 필드. 출처: developer.salesforce.com Object Reference.

| 필드 | 타입 | insert 시 | 설명 |
|---|---|---|---|
| `VersionData` | base64(Blob) | **필수** | 파일의 실제 바이너리 내용. Apex에선 `Blob`으로 대입. base64 인코딩되어 저장. |
| `PathOnClient` | String | 권장 | 업로드하는 로컬 파일의 전체 경로/파일명. **파일 확장자로 FileType이 결정**되므로 확장자를 반드시 포함. |
| `Title` | String | 권장 | 파일 표시 이름. 미지정 시 PathOnClient에서 유추. |
| `FirstPublishLocationId` | Reference(Id) | 선택 | 파일을 **처음 게시할 위치**(레코드·라이브러리·User·Group Id). 지정하면 ContentDocumentLink가 자동 생성. **insert에만 적용, update 불가.** |
| `ContentLocation` | picklist | 선택 | `'S'` = Salesforce 내부(기본), `'E'` = 외부, `'L'` = Social Customer Service. |
| `Origin` | picklist | 선택 | `'C'` = Content(CRM Content), `'H'` = Chatter(기본). |
| `ContentDocumentId` | Reference | update 시 | 새 **버전**을 추가할 때 기존 ContentDocument의 Id를 지정. 새 파일이면 비워둔다(시스템 생성). |
| `IsLatest` | Boolean(RO) | — | 이 버전이 최신인지. 쿼리 시 `IsLatest = TRUE`로 현재 버전만 필터. |
| `FileType` | String(RO) | — | 파일 형식(`PDF`, `JPG`, `WORD_X` 등). 확장자에서 자동 결정. |
| `FileExtension` | String(RO) | — | 확장자. |
| `Title`/`Description`/`TagCsv` | String | 선택 | 설명·태그(CSV). |
| `NetworkId` | Reference | 선택 | Experience Cloud 사이트에 게시할 때 사이트 Id. |

> **핵심 규칙:** 새 파일 = ContentDocumentId **비움**(시스템이 ContentDocument 생성). 기존 파일에 새 버전 추가 = ContentDocumentId를 **채움**.

### VersionData 크기·힙 제약 (Tier 2)

| 제약 | 값 |
|---|---|
| Salesforce Files 파일 크기 상한(플랫폼) | 최대 2GB (조직·업로드 방식별 상이) |
| Apex Blob/ContentVersion으로 처리 시 | 파일을 `VersionData` Blob으로 메모리에 올리면 **파일 크기만큼 힙 소비** |
| 동기 Apex 힙 한도 | 6MB — 큰 파일 처리 불가 |
| 비동기 Apex 힙 한도 | 12MB |

큰 파일은 Apex Blob 경로 대신 REST/`ContentVersion` 멀티파트 업로드나 청크 업로드를 쓴다. 벌크 처리 시 파일을 한 개씩 re-query해 처리 후 해제한다(모든 VersionData를 한 번에 materialize 금지).

---

## 3. 레코드에 공유 — ContentDocumentLink (Tier 2)

`FirstPublishLocationId`를 안 쓰고 **명시적으로** 파일을 레코드에 공유하려면 ContentDocumentLink를 직접 insert한다. 이미 존재하는 파일을 **추가 레코드**에 공유할 때도 이 방식이다.

```apex
// 구조 예시 — 실제 동작 코드 아님 (필드 레퍼런스용)
ContentDocumentLink cdl = new ContentDocumentLink();
cdl.ContentDocumentId = someContentDocumentId; // ContentVersion.ContentDocumentId
cdl.LinkedEntityId    = recordId;              // 공유 대상 레코드/User/Group
cdl.ShareType         = 'V';                   // V=Viewer, C=Collaborator, I=Inferred
cdl.Visibility        = 'AllUsers';            // InternalUsers/AllUsers/SharedUsers
insert cdl;
```

| 필드 | 값·의미 |
|---|---|
| `ContentDocumentId` | 공유할 파일(ContentDocument)의 Id. ContentVersion의 `ContentDocumentId`에서 얻음. |
| `LinkedEntityId` | 공유 대상 — 레코드·User·Group·Library의 Id. |
| `ShareType` | `V`=Viewer(읽기), `C`=Collaborator(편집), `I`=Inferred(부모 권한 상속). |
| `Visibility` | `AllUsers`(내부+외부), `InternalUsers`(내부만), `SharedUsers`(공유된 사용자만). Experience Cloud 노출 제어. |

> **쿼리 제약:** ContentDocumentLink는 반드시 `Id`, `ContentDocumentId`, `LinkedEntityId` 중 하나로 **필터**해야 쿼리된다. (API 59.0+에서 "Query All Files" 권한이 있으면 필터 없이 가능.)

### 레코드에 딸린 파일 조회 — 실전 쿼리

`FilesRecipes.cls`는 레코드에 연결된 파일을 파일 종류(이미지/오디오/문서)로 필터해 가져온다. `LinkedEntityId`로 ContentDocumentLink를 먼저 찾고, 그 ContentDocumentId로 최신 ContentVersion을 조회하는 2단계다.

```apex
@SuppressWarnings('PMD.ApexCRUDViolation')
public static List<ContentVersion> getFilteredAttachmentsForRecord(
    FilesRecipes.GenericFileType genericFileType,
    Id recordId
) {
    Map<String, Object> recordBind = new Map<String, Object>{
        'recordId' => recordId
    };
    String queryString =
        'SELECT ContentDocumentId FROM ContentDocumentLink' +
        ' WHERE LinkedEntityId = :recordId';

    switch on genericFileType {
        when AUDIO {
            queryString += ' AND ContentDocument.FileType IN (\'M4A\')';
        }
        when IMAGE {
            queryString += ' AND ContentDocument.FileType IN (\'JPG\', \'GIF\', \'PNG\', \'JPEG\')';
        }
        when DOCUMENT {
            queryString += ' AND ContentDocument.FileType IN (\'WORD_X\', \'EXCEL_X\', \'POWER_POINT_X\', \'PDF\')';
        }
        when ALL {
            queryString += '';
        }
    }
    List<ContentDocumentLink> links = Database.queryWithBinds(
        queryString, recordBind, AccessLevel.USER_MODE
    );
    Set<Id> fileIds = new Set<Id>();
    for (ContentDocumentLink cdl : links) {
        fileIds.add(cdl.ContentDocumentId);
    }
    return [
        SELECT Id, Title
        FROM ContentVersion
        WHERE ContentDocumentId IN :fileIds AND IsLatest = TRUE
        WITH USER_MODE
        ORDER BY CreatedDate
    ];
}
```

`GenericFileType`은 실제 확장자를 추상화한 enum이다:

```apex
public enum GenericFileType { IMAGE, AUDIO, DOCUMENT, ALL }
```

> `Database.queryWithBinds(..., AccessLevel.USER_MODE)`와 인라인 SOQL의 `WITH USER_MODE`가 CRUD/FLS를 강제한다 → [[SOQL 문법 레퍼런스]].

---

## 4. 공개 링크 배포 — ContentDistribution (실전 + 레퍼런스)

ContentDistribution은 파일을 **Salesforce 인증 없이** 볼 수 있는 공개 URL로 배포한다. insert 후 시스템이 `DistributionPublicUrl` 등 URL을 자동 채운다.

`FilesRecipes.cls`의 실전 코드:

```apex
public static Database.SaveResult publishContent(ContentDocumentLink cdl) {
    ContentDistribution dist = new ContentDistribution();

    dist.Name = 'new distributrion of content';
    dist.PreferencesAllowOriginalDownload = true;
    dist.PreferencesAllowPDFDownload = true;
    dist.PreferencesAllowViewInBrowser = true;
    dist.RelatedRecordId = cdl.LinkedEntityId;
    dist.ContentVersionId = cdl.ContentDocument.LatestPublishedVersionId;

    try {
        return Database.insert(dist, AccessLevel.USER_MODE);
    } catch (DmlException DMLe) {
        System.debug(LoggingLevel.INFO, DMLe.getMessage());
        throw new FilesRecipesException(DMLe.getMessage());
    }
}
```

> 위 코드가 참조하는 `cdl.ContentDocument.LatestPublishedVersionId`는 호출부에서 아래처럼 쿼리해 넘긴다:
> `[SELECT LinkedEntityId, ContentDocument.LatestPublishedVersionId FROM ContentDocumentLink WHERE ... ]`

### ContentDistribution 필드 레퍼런스 (Tier 2)

| 필드 | 타입 | 설명 |
|---|---|---|
| `Name` | String | **필수.** 배포 이름. |
| `ContentVersionId` | Reference | 배포할 파일 버전. 보통 `ContentDocument.LatestPublishedVersionId`. |
| `ContentDocumentId` | Reference(RO) | 연관 ContentDocument(자동). |
| `RelatedRecordId` | Reference | 배포를 연결할 레코드(예: 원본 레코드 Id). |
| `PreferencesAllowViewInBrowser` | Boolean | 브라우저 내 미리보기 허용. |
| `PreferencesAllowOriginalDownload` | Boolean | 원본 파일 다운로드 허용. |
| `PreferencesAllowPDFDownload` | Boolean | PDF로 다운로드 허용. |
| `PreferencesPasswordRequired` | Boolean | 비밀번호 보호 요구. true면 `Password` 사용. |
| `Password` | String | 접근 비밀번호(PasswordRequired와 함께). |
| `PreferencesExpires` | Boolean | 만료 사용 여부. true면 `ExpiryDate` 필요. |
| `ExpiryDate` | DateTime | 링크 만료 시각. |
| `PreferencesNotifyOnVisit` | Boolean | 방문 시 소유자에게 알림. |
| `PreferencesLinkLatestVersion` | Boolean | 항상 최신 버전을 링크(고정 버전 대신). |
| `PreferencesNotifyRndVisits` | Boolean | 익명(랜덤) 방문 알림. |
| `DistributionPublicUrl` | URL(RO) | **공개 접근 URL**(자동 생성). |
| `ContentDownloadUrl` | URL(RO) | 원본 다운로드 직링크. |
| `PdfDownloadUrl` | URL(RO) | PDF 다운로드 직링크. |
| `ViewCount` | Number(RO) | 조회 수. |

> ⚠️ **최소 하나의 delivery 옵션 필수:** `PreferencesAllowViewInBrowser`/`AllowOriginalDownload`/`AllowPDFDownload` 중 최소 하나를 true로 안 하면 insert가 `MISSING_ARGUMENT, You must specify at least one delivery option` 오류로 실패한다.
>
> ⚠️ **전제 조건:** 조직에서 **Content Deliveries and Public Links**(콘텐츠 배포) 기능이 활성화돼 있어야 ContentDistribution을 만들 수 있다(Setup에서 활성화). 아카이브된 배포는 `ExpiryDate`·`PreferencesExpires`만 편집 가능.

---

## 5. 언제 무엇을 쓰나 — 선택 기준

| 목표 | 사용 객체 | 방법 |
|---|---|---|
| 파일 만들어 **한 레코드에** 붙이기 | ContentVersion | `FirstPublishLocationId = 레코드Id`로 insert (링크 자동) |
| 기존 파일을 **다른 레코드에도** 공유 | ContentDocumentLink | 직접 insert (`LinkedEntityId`·`ShareType`·`Visibility`) |
| 기존 파일에 **새 버전** 올리기 | ContentVersion | `ContentDocumentId = 기존파일Id`로 insert |
| 파일을 **인증 없이 외부 공개** | ContentDistribution | insert → `DistributionPublicUrl` 발급 |
| 레코드에 딸린 파일 **조회** | ContentDocumentLink → ContentVersion | `LinkedEntityId` 필터 후 `ContentDocumentId IN` + `IsLatest=TRUE` |

---

## 관련 노트

- [[DML 패턴]] — `Database.insert(..., AccessLevel.USER_MODE)`, SaveResult, 벌크 DML
- [[Database Namespace 상세]] — `Database.insert`/`SaveResult`/`queryWithBinds` 레퍼런스
- [[SOQL 문법 레퍼런스]] — `WITH USER_MODE`, ContentDocumentLink 필터 제약
- [[Sfc Namespace]] — Salesforce Files 다운로드 동작을 Apex로 커스터마이징(IRM·다운로드 제어)
- [[파일 업로드와 이미지 처리]] — LWC에서의 파일 업로드/이미지 처리
- [[lightning-file-upload]] — 표준 파일 업로드 베이스 컴포넌트
