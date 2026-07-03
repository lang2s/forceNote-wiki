---
tags: [integration, connect-rest-api, files, folders, file-sharing]
source: salesforce_chatter_rest_api.pdf (Connect REST API Developer Guide, Version 67.0 Summer '26; PDF p446–465·742–749; Tier 1/2)
created: 2026-07-03
aliases: [Files, 파일, Salesforce Files, File Resources, Folders, 폴더, User Files, File Shares, 파일 공유, File Preview, File Rendition, Asset File]
---

# Files & Folders Resources

> Connect REST API의 네이티브 파일 리소스 — Salesforce Files의 정보·콘텐츠·이미지·렌디션·프리뷰·공유(`/connect/files/`), 폴더 계층(`/connect/folders/`), 사용자 파일 업로드·필터(`/connect/files/users/`)를 다루는 21개 엔드포인트.

---

이 노트는 Salesforce에 **네이티브로 저장되는** 파일·폴더 리소스만 다룬다. SharePoint·Google Drive·OneDrive 같은 외부 콘텐츠 저장소(`/connect/content-hub/`)는 자매 노트 [[Files Connect Repository Resources]] 참조.

**레거시 경로 병기:** 파일 리소스는 v24–35에서 `/chatter/files/...` 경로였고(**Chatter 활성화 필요**), v36.0부터 `/connect/files/...`로 이관됐다. 폴더는 v30–35에서 `/chatter/folders/...`, 사용자 파일은 v24–35에서 `/chatter/users/{id}/files`였다.

**바이너리 업로드 위임:** 파일 콘텐츠를 올릴 때 쓰는 multipart/form-data 요청 형식·base URI 구성은 이 노트에서 재서술하지 않는다 → [[Connect REST API 요청·응답 규약]] 참조. 응답 바디의 전체 스키마(File Detail, File Summary Page 등)는 Reference 챕터 소관이므로 이 노트에서는 응답 타입 **이름만** 표기한다.

---

## Files Resources (15 엔드포인트)

파일 정보·콘텐츠·이미지·렌디션·프리뷰·공유. base URI는 `/connect/files/`(v36.0+; v24–35는 `/chatter/files/`, Chatter 필요).

| # | 리소스 | URI (`/connect/` 이하) | 메서드 | 최소 버전 | 응답 |
|---|---|---|---|---|---|
| 1 | File Upload Config | `file/upload/config` | GET | 62.0 | File Upload Config |
| 2 | File Information | `files/{fileId}` | GET / POST / PATCH / DELETE | v36+ (쓰기 v26.0+) | GET·POST·PATCH → File Detail · DELETE → 204 |
| 3 | Asset File | `files/{fileId}/asset` | POST | 38.0 | File Detail |
| 4 | Asset File Information | `file-assets/{assetId}` | GET / PATCH | 38.0 (PATCH v43.0+) | File Detail |
| 5 | Asset File Content | `file-assets/{fullyQualifiedName}/content` | GET | 42.0 | 바이너리 스트림 |
| 6 | Asset File Rendition | `file-assets/{fullyQualifiedName}/rendition` | GET | 42.0 | 바이너리 스트림 |
| 7 | Asset Files Batch | `file-assets/batch/{assetIds}` | GET | 43.0 | Batch Results (최대 100) |
| 8 | File Content | `files/{fileId}/content` | GET | v36+ | 바이너리 스트림 |
| 9 | File Image | `files/{fileId}/image` | GET | 39.0 | Image File |
| 10 | File Shares | `files/{fileId}/file-shares` | GET / POST | v36+ (POST v30.0+) | File Shares Page |
| 11 | Files Shares Link | `files/{fileId}/file-shares/link` | GET / PUT / DELETE | v36+ | GET·PUT → File Share Link · DELETE → 204 |
| 12 | File Previews | `files/{fileId}/previews` | GET / HEAD / PATCH | 36.0 | File Preview Collection |
| 13 | File Preview | `files/{fileId}/previews/{previewFormat}` | GET / HEAD | 36.0 | File Preview |
| 14 | File Rendition | `files/{fileId}/rendition` | GET | v36+ | 바이너리 스트림(렌디션) |
| 15 | File Information Batch | `files/batch/{fileIds}` | GET / DELETE | v36+ | Batch Result Item (최대 100) |

### #2 File Information — 정보 조회·업로드·수정·삭제

한 파일의 정보를 조회하고, 새 버전을 업로드하고, 제목·설명·폴더 위치를 수정하고, 삭제한다.

- **GET** param: `versionNumber`(Integer v23.0; 미지정 시 최신 버전).
- **POST**(새 버전 업로드, multipart binary) — body `<fileInput>` = **File Input**(아래 [File Input 스키마](#file-input-스키마-20필드) 참조).
  POST query param:
  - `desc`(v26.0), `title`(v26.0)
  - `isDataSync`(v31.0)
  - `isInMyFileSync`(v31.0 — **retired**: Files Sync는 2018년 종료됨)
  - `isMajorVersion`(v31.0; major 버전은 replace 불가)
  - `sharingOption`(v35.0), `sharingPrivacy`(v41.0)
  - Files home에 새 파일을 올릴 때는 `/connect/files/users/me`를 사용.
- **PATCH**(제목 변경·폴더 이동) param: `desc`(v32.0), `title`(v26.0), `isInMyFileSync`, `parentFolderId`(v31.0), `sharingOption`, `sharingPrivacy`.
  예: `PATCH /connect/files/069D00000001FHF?title=A+New+Title`
  body 예:

  ```json
  // 구조 예시 — 덤프 발췌, 실제 동작 설정 아님
  { "desc": "Employee Survey Results", "title": "emp_surv_results" }
  ```
- **DELETE** → 204.

### #3 Asset File (POST)

기존 파일을 asset file(ContentAsset)로 변환한다. body 없음.

- param: `assetLabel`(v46.0; 내부 라벨, 번역되지 않음)·`developerName`(v46.0; 패키지 이름 충돌 방지)·`isVisibleByExternalUsers`(Boolean v43.0; 기본 false)·`shareWith`(String **v38.0 only**; org/site/workspace ID)·`shareWithIds`(String[] v39.0).
- 응답: File Detail.

### #4 Asset File Information (GET / PATCH)

- **PATCH** body `<fileAsset>`: `isVisibleByExternalUsers`(Boolean **Required** v43.0).
  예:

  ```json
  // 구조 예시 — 덤프 발췌, 실제 동작 설정 아님
  { "isVisibleByExternalUsers": "true" }
  ```

### #5 / #6 Asset File Content / Rendition

`fullyQualifiedName` = (namespace prefix가 있으면 그것 +) ContentAsset developer name.

- **#5 Content** param: `versionNumber`.
- **#6 Rendition** param:
  - `format`(jpg / png v60.0; 미지정 시 BMP·JPG → JPG, PNG → PNG)
  - `height` / `width`(Integer v42.0; 24px 초과 & 원본보다 작아야 함, 최대 25개 조합, 하나만 지정하면 다른 하나는 원본 유지)
  - `versionNumber`.

### #7 Asset Files Batch (GET)

여러 asset을 한 번에 조회. `assetIds` 최대 100개. 응답 Batch Results.

### #8 File Content (GET)

파일 원본 콘텐츠 바이너리 스트림 반환. param: `isDataSync`·`versionNumber`(v24.0).

### #9 File Image (GET)

이미지 파일 반환(Image File).

### #10 File Shares — 공유 조회·설정

파일이 공유된 대상 목록을 조회하거나, 사용자·그룹에 공유한다. 첫 share는 org record share이다(communities에서는 network record share).

- **GET** param: `page`(v24.0)·`pageSize`(1–100, 기본 25, v24.0).
- **POST** body `<fileShares>` = **File Shares Input**: `message`(v30.0; digital experiences 활성 시 email)·`shares`(**Share Input[]** v30.0).
- **POST** query param(사용자 공유용): `id1`–`id9`(**Required**; 최대 9명 user ID)·`message`·`sharingType1`–`sharingType9`(**Required**; C=collaborator / V=viewer, `id` 개수와 일치해야 함).

  ```json
  // 구조 예시 — 덤프 발췌, 실제 동작 설정 아님
  {
    "message": "...",
    "shares": [
      { "id": "005...", "sharingType": "V" },
      { "id": "005...", "sharingType": "C" }
    ]
  }
  ```

  query param 형태: `?id1=005...&id2=005...&sharingType1=C&sharingType2=V`

> 공유 대상은 **최대 9명**이며 `id{n}`과 `sharingType{n}`의 개수가 정확히 일치해야 한다.

### #11 Files Shares Link — 공유 링크

파일 공유 링크를 조회·설정·삭제한다.

- **PUT** body(v36–57에서는 불필요·무시됨, v58.0+에서는 선택) `<fileShareLink>` = **File Share Link Input**: `expirationDate`(v58.0)·`isPasswordRequired`(Boolean v58.0; true면 비밀번호 생성).

  ```json
  // 구조 예시 — 덤프 발췌, 실제 동작 설정 아님
  { "expirationDate": "2024-07-07T23:59:11.168Z", "isPasswordRequired": "true" }
  ```
- **DELETE** → 204.

### #12 File Previews (GET / HEAD / PATCH)

파일의 프리뷰 컬렉션. PATCH로 SVG를 on-demand 생성한다.

- GET / PATCH param: `versionNumber`(v40.0).

### #13 File Preview (GET / HEAD)

특정 `previewFormat`의 프리뷰.

- param: `endPageNumber`·`startPageNumber`(v35.0; **최대 500 페이지**)·`versionNumber`(v40.0).
- `previewFormat` enum → 아래 [enum 값](#enum-값) 참조.

### #14 File Rendition (GET)

파일의 렌디션(PDF 또는 썸네일) 바이너리 스트림.

- param:
  - `page`(**0만 유효**; PDF 렌디션은 전체 문서 대상)
  - `type`(**PDF** / **THUMB120BY90**[기본] / **THUMB240BY180** / **THUMB720BY480**).
- 공유 파일의 렌디션은 업로드 후 **비동기**로 생성되고, 비공개 파일은 **첫 preview 요청 시** 처리된다(즉시 사용 불가).

### #15 File Information Batch (GET / DELETE)

여러 파일 정보를 한 번에 조회·삭제. `fileIds` **최대 100개**(URL 길이 제한). 응답 Batch Result Item.

---

## Folders Resources (3 엔드포인트)

폴더 정보·내용·수정·삭제. base URI는 `/connect/folders/`(v36.0+; v30–35는 `/chatter/folders/`, Chatter 필요). `folderId` 자리에 `root`를 쓰면 계층 루트를 가리킨다.

| # | 리소스 | URI (`/connect/` 이하) | 메서드 | 최소 버전 | 응답 |
|---|---|---|---|---|---|
| 1 | Folder Information | `folders/{folderId}` | GET / HEAD / PATCH / DELETE | v36+ | GET·PATCH → Folder |
| 2 | Folder Contents | `folders/{folderId}/items` | GET / POST | v36+ | GET → Folder Item Page · POST → Folder Item |
| 3 | Folders Shares Link | `folders/{folderId}/folder-shares/link` | GET / PUT / DELETE | 44.0 | GET·PUT → Folder Share Link · DELETE → 204 |

> **#1 삭제 주의:** 폴더를 DELETE하면 **하위 폴더가 전부 삭제되고 그 안의 파일이 제거된다.**

### #1 Folder Information — 이동·이름변경

- **PATCH** body **Folder Input**.
  - 이동 param: `parentFolderId`(**Required** v30.0; `null`이면 현재 폴더에서 제거, `root`는 계층 루트)·`isInMyFileSync`(v33.0 **retired**).
  - 이름변경 param: `name`(**Required** v30.0)·`isInMyFileSync`.

### #2 Folder Contents — 조회·항목 추가

- **GET** param: `filter`(v33.0)·`page`(v30.0)·`pageSize`(1–100, 기본 25, v30.0).
- **POST** body **Folder Item Input**.
  - 파일 추가 param: `desc`·`isInMyFileSync`·`sharingOption`·`sharingPrivacy`·`title`·`type`(**Required** = `File`). 파일은 multipart body part 필수.
  - 폴더 생성 param: `folderPath`(**Required**)·`isInMyFileSync`·`type`(**Required** = `Folder`).

  ```json
  // 구조 예시 — 덤프 발췌, 실제 동작 설정 아님
  // 파일 추가
  { "file": { "description": "...", "title": "Yearly.txt" }, "type": "File" }
  // 폴더 생성
  { "folder": { "path": "my_documents/my_folder" }, "type": "Folder" }
  ```

### #3 Folders Shares Link

폴더 공유 링크 조회·설정·삭제. GET·PUT → Folder Share Link · DELETE → 204.

---

## User Files Resources (3 엔드포인트)

특정 사용자의 파일 조회·업로드 및 그룹/공유 기준 필터. base URI는 `/connect/files/users/`(v36.0+; v24–35는 `/chatter/users/{id}/files`, Chatter 필요).

| # | 리소스 | URI (`/connect/` 이하) | 메서드 | 최소 버전 | 응답 |
|---|---|---|---|---|---|
| 1 | Users Files (General) | `files/users/{userId}` (또는 `.../me`) | GET / POST / HEAD | v36+ (guest POST v62.0+) | GET → File Summary Page · POST → File Summary |
| 2 | Filtered by Group | `files/users/{userId}/filter/groups` | GET / HEAD | v36+ | File Summary Page |
| 3 | Filtered by Sharing | `files/users/{userId}/filter/shared-with-me` | GET / HEAD | v36+ | File Summary Page |

### #1 Users Files (General)

Files home에 업로드하는 파일은 **private**(소유자만 접근). 이 리소스는 지정 사용자가 **소유한** 파일 정보만 반환한다. 여러 파일을 한 번에 올리려면 Batch Resource를 사용한다.

> ⚠️ 반환량이 대용량일 수 있고 처리 시간이 걸릴 수 있다.

- **POST** body `<fileInput>` = **File Input**(multipart part `name="fileData"`).
  POST param: `contentModifiedDate`·`desc`·`includeExternalFilePermissionsInfo`·`isDataSync`·`isInMyFileSync`·`isMajorVersion`(기본 false)·`repositoryFileId`·`repositoryFileUri`·`repositoryId`·`reuseReference`·`sharingOption`·`sharingPrivacy`·`title`.
- **GET** param: `page`(v24.0)·`pageSize`(1–100, 기본 25)·`q`(검색어, 2자 이상, v27.0).

  ```json
  // 구조 예시 — 덤프 발췌, 실제 동작 설정 아님
  // 파일 업로드 정보
  { "desc": "Employee Survey Results", "title": "emp_surv_results" }
  // 외부 저장소 파일 참조 생성
  { "repositoryId": "0XCB...", "repositoryFileId": "document:1AnP..." }
  ```

> ⚠️ **원문 오타 병기(봉합 금지):** guest 업로드 예제에서 `"pathOnClient": "Screenshot..."` 값이 곧은 따옴표(`"`)가 아니라 **curly-quote(둥근 따옴표)로 잘못 표기**되어 있다. PDF 원문 그대로이며, 실제 요청에서는 표준 따옴표를 써야 한다.

### #3 Filtered by Sharing

`shared-with-me` 필터. 끝 키워드를 한 단어 `sharedwithme`로 붙여도 동일하게 접근할 수 있다.

---

## File Input 스키마 (19필드)

`<fileInput>` — #2 File Information POST·#2 Folder Contents 파일 추가·#1 User Files POST에서 사용.

| 필드 | 타입 | 버전 | 비고 |
|---|---|---|---|
| `contentBodyId` | String | v62.0 | |
| `contentModifiedDate` | String (ISO8601) | v32.0 | |
| `desc` | String | v24.0 | 설명 |
| `fieldName` | String | v62.0 | API명이 `fileupload__c`로 끝나야 함 |
| `fieldValue` | String | v62.0 | |
| `firstPublishLocationId` | String | v62.0 | |
| `includeExternalFilePermissionsInfo` | Boolean | v35.0 | `users/{id}` POST 전용 |
| `isInMyFileSync` | Boolean | v31.0 | **retired** (Files Sync 2018 종료) |
| `isMajorVersion` | Boolean | v31.0 | |
| `networkId` | String | v62.0 | |
| `parentFolderId` | String | v31.0 | |
| `pathOnClient` | String | v62.0 | |
| `repositoryFileId` | String | v32.0 | `users/{id}` 전용; `repositoryFileUri`와 동시 지정 금지 |
| `repositoryFileUri` | String | v39.0 | `users/{id}` 전용 |
| `repositoryId` | String | v32.0 | `repositoryFileId` 지정 시 **Required** |
| `reuseReference` | Boolean | v36.0 | |
| `sharingOption` | String | v35.0 | |
| `sharingPrivacy` | String | v41.0 | |
| `title` | String | v24.0 | |

### 그 밖의 Input 스키마

**File Share Link Input** (`<fileShareLink>`): `expirationDate`(String v58.0)·`isPasswordRequired`(Boolean v58.0).

**File Shares Input** (`<fileShares>`): `message`(String v30.0)·`shares`(Share Input[] v30.0).

**Folder Input** (`<folderInput>`): `isInMyFileSync`(Boolean v33.0 retired)·`name`(String v30.0; `path` 또는 `name` 필수, 둘 다면 `path` 사용)·`parentFolderId`(String v30.0; `parentFolderId` 또는 `path` 필수, 둘 다 지정 불가)·`path`(String v30.0).

**Folder Item Input** (`<folderItem>`): `file`(File Input; File POST 시 **Required**)·`folder`(Folder Input; Folder POST 시 **Required**)·`type`(String **Required**; `File` / `Folder`).

**Share Input**: `id`(String v30.0; 공유 대상 user ID)·`sharingType`(String; `C` / `V`).

```json
// 구조 예시 — 덤프 발췌, 실제 동작 설정 아님
{ "id": "005D0000001Az4l", "sharingType": "V" }
```

---

## enum 값

### previewFormat (#13 File Preview)

| 값 | 의미 |
|---|---|
| `jpg` | JPG |
| `pdf` | PDF (DOC/DOCX/PPT/PPTX/TEXT/XLS/XLSX 대상; File Content로 다운로드) |
| `svg` | on-demand — PATCH File Previews로 생성 |
| `thumbnail` | 240×180 PNG |
| `big-thumbnail` | 720×480 PNG |
| `tiny-thumbnail` | 120×90 PNG |

> ⚠️ **Hyperforce는 SVG를 지원하지 않는다 → 기본 JPG로 대체된다.**

### 그 밖의 enum

| enum | 값 |
|---|---|
| `sharingOption` | `Allowed`(resharing 허용) · `Restricted` |
| `sharingPrivacy` | `None`(record access 있으면 visible) · `PrivateOnRecords` |
| `sharingType` (Share) | `C`(collaborator) · `V`(viewer) |
| folder `type` | `File` · `Folder` |
| rendition `type` (#14) | `PDF` · `THUMB120BY90`(기본) · `THUMB240BY180` · `THUMB720BY480` |
| `format` (#6 asset rendition) | `jpg` · `png` |

---

## 관련 노트
- [[Files Connect Repository Resources]] — 외부 콘텐츠 저장소(SharePoint·Google Drive·OneDrive)의 파일 리소스
- [[Connect REST API 요청·응답 규약]] — 바이너리 multipart/form-data 업로드·base URI 구성
- [[Connect REST API 개요]] — Connect REST API 전체 개요(상위)
- [[Feed Elements Resources]] — 피드에 파일 첨부(files capability)
