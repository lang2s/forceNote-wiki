---
tags: [integration, connect-rest-api, files-connect, external-repository, content-hub]
source: salesforce_chatter_rest_api.pdf (Connect REST API Developer Guide, Version 67.0 Summer '26; PDF p434–445; Tier 1/2)
created: 2026-07-03
aliases: [Files Connect, 파일 커넥트, External Repository, 외부 저장소, Content Hub, SharePoint, Google Drive, OneDrive, Repository File, Repository Permissions]
---

# Files Connect Repository Resources

> SharePoint·Google Drive·OneDrive for Business 같은 외부 콘텐츠 저장소(Files Connect repository)의 파일·폴더·디렉터리 엔트리·권한을 Salesforce에서 조회·수정하는 Connect REST API 리소스 묶음. 모든 URI base는 `/connect/content-hub/`.

---

## 개요

**Files Connect repository** = Salesforce에 연결된 외부 콘텐츠 저장소(SharePoint·Google Drive·OneDrive for Business 등). 이 리소스로 저장소 목록·정보·파일 콘텐츠·폴더 항목·directory entries·permissions·permission types를 조회하고 permissions를 업데이트한다.

- 모든 URI base: `/connect/content-hub/`
- Experience Cloud(digital experiences) 변형: `/connect/communities/{communityId}/content-hub/...` (v35.0+)
- 네이티브 Salesforce Files/Folders(`/connect/files/`·`/connect/folders/`)는 별도 노트 → [[Files & Folders Resources]] 참조.
- 바이너리 multipart 업로드 규약·base URI 세부는 [[Connect REST API 요청·응답 규약]] 위임.
- 응답 바디 전체 스키마(Files Connect Repository, Repository File Detail 등)는 Reference 챕터 위임 — 이 노트는 이름만 표기.

---

## 리소스 엔드포인트 (14)

| # | 리소스 | URI (`/connect/content-hub/`) | 메서드 | v | 응답 |
|---|---|---|---|---|---|
| 1 | Repository List | `repositories` | GET | 32.0 (communities 35.0+) | Files Connect Repository Collection |
| 2 | Repository | `repositories/{repositoryId}` | GET/HEAD | 32.0 | Files Connect Repository |
| 3 | Directory Entries | `repositories/{repositoryId}/directory-entries` | GET/HEAD | 35.0 | Repository Directory Entry Collection |
| 4 | Repository File | `repositories/{repositoryId}/files/{repositoryFileId}` | GET/HEAD/PATCH (PATCH v35.0+) | 32.0 | Repository File Detail |
| 5 | File Content | `repositories/{repositoryId}/files/{repositoryFileId}/content` | GET/HEAD | 32.0 | 바이너리 스트림 |
| 6 | File Previews | `repositories/{repositoryId}/files/{repositoryFileId}/previews` | GET/HEAD | 36.0 | File Preview Collection |
| 7 | File Preview | `repositories/{repositoryId}/files/{repositoryFileId}/previews/{formatType}` | GET/HEAD | 36.0 | File Preview |
| 8 | Repository Folder | `repositories/{repositoryId}/folders/{repositoryFolderId}` | GET/HEAD | 38.0 | Repository Folder Detail |
| 9 | Folder Allowed Item Types | `repositories/{repositoryId}/folders/{repositoryFolderId}/allowed-item-types` | GET/HEAD | 35.0 | Files Connect Allowed Item Type Collection |
| 10 | Folder Items | `repositories/{repositoryId}/folders/{repositoryFolderId}/items` | GET/HEAD/POST (POST v35.0+) | 32.0 | GET→Repository Folder Items Collection, POST→Repository Folder Item |
| 11 | Item Type | `repositories/{repositoryId}/item-types/{repositoryItemTypeId}` | GET/HEAD | 35.0 | Files Connect Item Type Detail |
| 12 | Permissions | `items/{repositoryItemId}/permissions` | GET/HEAD/PATCH | 35.0 | Files Connect Permission Collection |
| 13 | Permission Types | `items/{repositoryItemId}/permissions/types` | GET/HEAD | 35.0 | Repository Permission Type Collection |
| 14 | Repository for a File | `items/{repositoryItemId}/repository` | GET | 38.0 | Files Connect Repository |

### 참조용 files 리소스 3 (외부 파일 참조 작업)

외부 저장소 파일을 Salesforce Files로 **참조(reference)** 하는 작업은 네이티브 files 경로를 재사용한다:

| 리소스 | URI | 용도 |
|---|---|---|
| File Information | `/connect/files/{fileId}` | 참조 파일 정보·버전 |
| File Content | `/connect/files/{fileId}/content` | 참조 파일 콘텐츠 |
| Users Files General | `/connect/files/users/me` | 외부 파일 참조 생성 |

> 이 3개 리소스의 상세(파라미터·File Input 스키마)는 [[Files & Folders Resources]] 소관. 외부 참조 생성 시 `repositoryId` + `repositoryFileId`(또는 `repositoryFileUri`)를 File Input에 넘긴다.

---

## 리소스 상세

### #1 Repository List
GET param:
- `canBrowseOnly` (Boolean, v32.0)
- `canSearchOnly` (Boolean, v32.0)
- `page` (v32.0)
- `pageSize` (1–100, 기본 25, v32.0)

### #4 Repository File
GET param:
- `includeExternalFilePermissionsInfo` (Boolean, v36.0) — 외부 permission 관리는 **Google Drive·SharePoint Online·OneDrive for Business**만 지원.

PATCH body `<contentHubInputItem>` = **Files Connect Item Input**:
- `fields` (Files Connect Field Value Input[]) — **SharePoint 파일 생성 시 파일명 Req**
- `itemTypeId` (String) — 저장소 파일 생성 시 **Req**. `allowed-item-types`(#9)로 획득.

### #7 File Preview
GET param:
- `endPageNumber` (Integer, v36.0)
- `startPageNumber` (Integer, v36.0)

> File previews는 **Google Drive만** 지원(#6·#7 공통).

### #9 Folder Allowed Item Types
GET param:
- `filter` (String; `Any` / `FilesOnly` / `FoldersOnly`) — v35.0에서는 `FilesOnly`만.

폴더에 항목을 POST하기 전, 이 리소스로 허용 item type과 `itemTypeId`를 먼저 조회한다.

### #10 Folder Items
GET param:
- `page`, `pageSize` (1–100, 기본 25, v32.0)

POST body `<contentHubInputItem>` = **Files Connect Item Input**:
- **업로드 75 MB 제한**, `multipart/form-data`.
- 생성 전 `allowed-item-types`(#9) GET으로 허용 타입 확인.
- multipart 업로드 예제는 [[Connect REST API 요청·응답 규약]] 위임.

### #12 Permissions
`repositoryItemId` = 파일 ID. 외부 permission은 **Google Drive·SharePoint Online·OneDrive for Business**만.

PATCH body `<contentHubPermissions>` = **Files Connect Permission Collection Input**:
- `permissionsToApply` (Files Connect Permission Input[]) — `permissionsToRemove` 미지정 시 **Req**
- `permissionsToRemove` (Files Connect Permission Input[]) — `permissionsToApply` 미지정 시 **Req**

---

## Input 스키마

### Files Connect Field Value Input
| 프로퍼티 | 타입 | 필수 | v |
|---|---|---|---|
| `name` | String | Req | 35.0 |
| `value` | String | Req | 35.0 |

### Files Connect Item Input (`<contentHubInputItem>`)
| 프로퍼티 | 타입 | 필수 | v |
|---|---|---|---|
| `fields` | Files Connect Field Value Input[] | SharePoint 생성 시 Req | 35.0 |
| `itemTypeId` | String | 저장소 파일 생성 시 Req | 35.0 |

### Files Connect Permission Collection Input (`<contentHubPermissions>`)
| 프로퍼티 | 타입 | 필수 | v |
|---|---|---|---|
| `permissionsToApply` | Files Connect Permission Input[] | `permissionsToRemove` 미지정 시 Req | 35.0 |
| `permissionsToRemove` | Files Connect Permission Input[] | `permissionsToApply` 미지정 시 Req | 35.0 |

### Files Connect Permission Input (`<contentHubPermission>`)
| 프로퍼티 | 타입 | 필수 | v |
|---|---|---|---|
| `directoryEntryId` | String | Req (user/group ID) | 35.0 |
| `permissionTypesIds` | String[] | Req | 35.0 |

---

## enum

### filter (#9 Folder Allowed Item Types)
| 값 | 의미 |
|---|---|
| `Any` | files + folders 모두 포함 |
| `FilesOnly` | files만 |
| `FoldersOnly` | folders만 |

> v35.0에서는 `FilesOnly`만 유효.

### formatType (#7 File Preview)
[[Files & Folders Resources]]의 previewFormat과 동일 세트:

| 값 | 형식 |
|---|---|
| `jpg` | JPG |
| `pdf` | PDF (DOC/DOCX/PPT/PPTX/TEXT/XLS/XLSX 대상) |
| `svg` | on-demand SVG |
| `thumbnail` | 240 × 180 PNG |
| `big-thumbnail` | 720 × 480 PNG |
| `tiny-thumbnail` | 120 × 90 PNG |

---

## 요청 예시

아래는 PDF 발췌 기반 JSON 요청 바디다. 예시값(ID 등)은 형태만 나타낸다.

**#4 Repository File PATCH — 저장소 파일 생성/수정 (Files Connect Item Input):**

```json
{
  "itemTypeId": "L3NpdGVz...:...:0x0101",
  "fields": [
    { "name": "name", "value": "..." },
    { "name": "description", "value": "..." }
  ]
}
```

**#12 Permissions PATCH — 권한 적용·제거 (Files Connect Permission Collection Input):**

```json
{
  "permissionsToApply": [
    { "directoryEntryId": "Anyone", "permissionTypesIds": ["CanView"] }
  ],
  "permissionsToRemove": [
    { "directoryEntryId": "AnyoneInMyDomain", "permissionTypesIds": ["CanDelete", "CanEdit"] }
  ]
}
```

**Files Connect Permission Input 단일 항목 예:**

```json
{ "directoryEntryId": "AnyoneInMyDomain", "permissionTypesIds": ["CanView", "CanEdit"] }
```

---

## 관련 노트
- [[Files & Folders Resources]] — 네이티브 Salesforce Files/Folders(외부 저장소 대비 · 참조용 files 리소스 3 상세).
- [[Connect REST API 요청·응답 규약]] — 바이너리 multipart 업로드·base URI.
- [[Connect REST API 개요]] — Connect REST API 상위 개요.
