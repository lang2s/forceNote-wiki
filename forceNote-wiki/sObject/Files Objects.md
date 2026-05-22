---
tags: [sobject-reference, standard-objects, files, content, contentdocument, contentversion, attachment]
source: object_reference.pdf (v67.0 Summer '26)
created: 2026-05-22
aliases: [Files Objects, ContentDocument, ContentVersion, ContentDocumentLink, ContentFolder, Attachment, Document, ContentNote]
---

# Files Objects — 파일·콘텐츠 오브젝트

> Object Reference v67.0 Ch6 — Salesforce Files(파일·콘텐츠) 도메인 표준 오브젝트 목록

---

## ContentDocument 계열 (Salesforce Files 핵심)

| Object | 설명 |
|---|---|
| `ContentDocument` | 파일 문서 — Salesforce Files의 핵심 Object |
| `ContentDocumentHistory` | ContentDocument 필드 변경 이력 |
| `ContentDocumentLink` | 레코드-파일 연결 (LinkedEntityId) |
| `ContentDocumentListViewMapping` | ContentDocument 목록 뷰 매핑 |
| `ContentDocumentSubscription` | ContentDocument 구독 |

---

## ContentVersion 계열

| Object | 설명 |
|---|---|
| `ContentVersion` | 파일 버전 — 실제 파일 데이터(VersionData) 저장 |
| `ContentVersionComment` | ContentVersion 댓글 |
| `ContentVersionHistory` | ContentVersion 이력 |
| `ContentVersionRating` | ContentVersion 평점 |

---

## ContentFolder · ContentWorkspace

| Object | 설명 |
|---|---|
| `ContentFolder` | 콘텐츠 폴더 |
| `ContentFolderItem` | 콘텐츠 폴더 항목 |
| `ContentFolderLink` | 콘텐츠 폴더 링크 |
| `ContentFolderMember` | 콘텐츠 폴더 멤버 |
| `ContentWorkspace` | 라이브러리 (Workspace) |
| `ContentWorkspaceDoc` | 라이브러리 문서 |
| `ContentWorkspaceMember` | 라이브러리 멤버 |
| `ContentWorkspacePermission` | 라이브러리 권한 |
| `ContentWorkspaceSubscription` | 라이브러리 구독 |

---

## 콘텐츠 배포·공유

| Object | 설명 |
|---|---|
| `ContentDistribution` | 콘텐츠 배포 (공개 링크 생성) |
| `ContentDistributionView` | 콘텐츠 배포 조회 이력 |
| `ContentHubItem` | Content Hub 외부 파일 항목 |
| `ContentHubRepository` | Content Hub 저장소 |
| `ContentAsset` | 정적 리소스처럼 사용하는 콘텐츠 에셋 |
| `ContentBody` | 콘텐츠 바디 (파일 바이너리) |
| `ContentNote` | 풍부한 텍스트 노트 |
| `ContentNotification` | 콘텐츠 알림 |
| `ContentTagSubscription` | 콘텐츠 태그 구독 |
| `ContentUserSubscription` | 콘텐츠 사용자 구독 |

---

## ContentTaxonomy (분류 체계)

| Object | 설명 |
|---|---|
| `ContentTaxonomy` | 콘텐츠 분류 체계 |
| `ContentTaxonomyRelatedTerm` | 분류 체계 관련 용어 |
| `ContentTaxonomyTerm` | 분류 체계 용어 |
| `ContentTaxonomyTermRelatedTerm` | 분류 체계 용어 관련 용어 |
| `ContentTaxonomyTermRelationshipType` | 분류 체계 용어 관계 타입 |

---

## 구형 파일 Object

| Object | 설명 |
|---|---|
| `Attachment` | 구형 파일 첨부 (Note 포함) — 신규 개발 미권장 |
| `Document` | 폴더 기반 문서 — 신규 개발 미권장 |
| `DocumentAttachmentMap` | 문서-첨부 매핑 |
| `DocumentRecipient` | 문서 수령인 |
| `DocumentTag` | 문서 태그 |
| `Note` | 구형 텍스트 노트 |
| `NoteAndAttachment` | Note와 Attachment 통합 뷰 |
| `NoteTag` | Note 태그 |

---

## 편의 뷰 Object (Read-Only)

| Object | 설명 |
|---|---|
| `AttachedContentDocument` | 레코드에 첨부된 ContentDocument 뷰 |
| `AttachedContentNote` | 레코드에 첨부된 ContentNote 뷰 |
| `OwnedContentDocument` | 사용자가 소유한 ContentDocument 뷰 |
| `FolderedContentDocument` | 폴더에 포함된 ContentDocument 뷰 |
| `CombinedAttachment` | Attachment + ContentDocument 통합 뷰 |

---

## DigitalSignature

| Object | 설명 |
|---|---|
| `DigitalSignature` | 전자 서명 |

---

## SOQL 패턴

```apex
// 특정 레코드에 첨부된 파일 조회
List<ContentDocumentLink> links = [
    SELECT ContentDocumentId,
           ContentDocument.Title,
           ContentDocument.FileType,
           ContentDocument.FileExtension,
           ContentDocument.ContentSize,
           ContentDocument.CreatedDate,
           ContentDocument.LatestPublishedVersionId,
           ContentDocument.LatestPublishedVersion.VersionData
    FROM ContentDocumentLink
    WHERE LinkedEntityId = :recordId
    ORDER BY ContentDocument.CreatedDate DESC
    WITH USER_MODE
];

// ContentVersion — 파일 업로드 (단일 파일)
ContentVersion cv = new ContentVersion();
cv.Title = 'My Document';
cv.PathOnClient = 'my_document.pdf';
cv.VersionData = Blob.valueOf('file content here');
cv.IsMajorVersion = true;
insert cv;

// 업로드 후 ContentDocument ID 조회하여 레코드에 링크
ContentVersion insertedCv = [
    SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id
];
ContentDocumentLink cdl = new ContentDocumentLink();
cdl.ContentDocumentId = insertedCv.ContentDocumentId;
cdl.LinkedEntityId = recordId;
cdl.ShareType = 'V'; // V=Viewer, C=Collaborator, I=Inferred
insert cdl;

// ContentDocument 폴더별 조회
List<ContentDocument> docs = [
    SELECT Id, Title, FileType, ContentSize, OwnerId, Owner.Name
    FROM ContentDocument
    WHERE ParentId = :folderId
    ORDER BY Title ASC
    WITH USER_MODE
    LIMIT 200
];
```

---

## 관련 노트

- [[6 Standard Objects]] — Ch6 전체 도메인 카탈로그 (상위 파일)
- [[Platform Admin Objects]] — StaticResource (파일 관련 플랫폼 Object)
- [[Service Cloud Objects]] — CaseArticle (케이스 파일 연결)
- [[Core CRM Objects]] — Account·Contact 레코드 파일 첨부
- [[Experience Cloud Objects]] — ManagedContent (CMS 파일)
