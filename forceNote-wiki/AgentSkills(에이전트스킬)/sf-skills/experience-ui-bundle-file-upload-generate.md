---
tags: [agent-skill, sf-skills, experience, ui-bundle, file-upload, contentversion]
source: forcedotcom/sf-skills (skills/experience-ui-bundle-file-upload-generate/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [experience-ui-bundle-file-upload-generate, UI Bundle 파일 업로드 API, file upload react ui bundle, upload() ContentVersion, 진행률 추적 onProgress, 드래그앤드롭 업로드]
---

# experience-ui-bundle-file-upload-generate — UI Bundle 파일 업로드 API (API-only)

> React UI bundle에 파일 업로드 기능을 추가하는 스킬. 진행률 추적과 Salesforce ContentVersion 통합을 제공하며 **프로그래밍 API만** 제공한다 — UI는 `upload()` API로 직접 만든다. FormData/XHR로 처음부터 만들지 말 것.

## 목적과 활성화 조건

**활성화(MUST):** `uiBundles/*/src/` 디렉터리가 있고 파일을 uploading/attaching/dropping하는 작업일 때. 진행률 추적과 ContentVersion 통합을 제공. 이 기능은 **프로그래밍 API만** 제공한다 — `upload()` API로 커스텀 UI를 직접 빌드한다. FormData나 XHR로 파일 업로드를 처음부터 만들지 말고 항상 이 기능을 사용한다.

### CRITICAL: API-only 패키지

패키지는 React 컴포넌트나 hook이 아닌 **프로그래밍 API**를 export한다. 따라서:

- `upload()` 함수로 진행률 추적과 함께 파일 업로드 처리
- 커스텀 UI(file input, dropzone, progress bar 등)는 직접 빌드
- `onProgress` 콜백으로 업로드 진행률 추적

**하지 말 것:**

- `<FileUpload />` 같은 사전 빌드 컴포넌트 기대 — export되지 않음
- `useFileUpload` 같은 React hook import 시도 — export되지 않음
- dropzone 컴포넌트 찾기 — export되지 않음

소스 코드에 데모용 reference 컴포넌트가 있으나 import로는 **사용 불가**하다. 자기 UI를 만드는 예시로만 사용한다.

## 워크플로 / 단계

### 1. 패키지 설치

```bash
npm install @salesforce/ui-bundle-template-feature-react-file-upload
```

의존성이 자동 설치된다:

- `@salesforce/ui-bundle` (API client)
- `@salesforce/sdk-data` (data SDK)

### 2. 세 가지 업로드 패턴 이해

#### Pattern A: Basic upload (record linking 없음)

파일을 Salesforce에 업로드하고 각 파일의 `contentBodyId`를 받는다. ContentVersion 레코드는 생성되지 않는다.

**언제 사용:**
- 파일을 먼저 업로드하고 나중에 레코드에 생성/연결하려 할 때
- 레코드가 아직 없는 multi-step 폼
- 지연 record linking 시나리오

```tsx
import { upload } from "@salesforce/ui-bundle-template-feature-react-file-upload";

const results = await upload({
  files: [file1, file2],
  onProgress: (progress) => {
    console.log(`${progress.fileName}: ${progress.status} - ${progress.progress}%`);
  },
});

// results[0].contentBodyId: "069..." (always available)
// results[0].contentVersionId: undefined (no record linked)
```

#### Pattern B: 즉시 record linking과 함께 업로드

파일을 업로드하고 ContentVersion 레코드를 생성해 기존 Salesforce 레코드에 즉시 연결한다.

**언제 사용:**
- 레코드가 이미 존재(Account, Opportunity, Case 등)
- 파일을 즉시 레코드에 첨부하려 할 때
- 직접 upload-and-attach 시나리오

```tsx
import { upload } from "@salesforce/ui-bundle-template-feature-react-file-upload";

const results = await upload({
  files: [file1, file2],
  recordId: "001xx000000yyyy", // Existing record ID
  onProgress: (progress) => {
    console.log(`${progress.fileName}: ${progress.status} - ${progress.progress}%`);
  },
});

// results[0].contentBodyId: "069..." (always available)
// results[0].contentVersionId: "068..." (linked to record)
```

#### Pattern C: 지연 record linking (record 생성 flow)

레코드 없이 파일을 업로드한 뒤 레코드 생성 후 연결한다.

**언제 사용:**
- "첨부와 함께 레코드 생성" 폼을 만들 때
- 폼 제출 전까지 레코드가 존재하지 않음
- 최종 record ID를 알기 전에 파일을 업로드해야 함

```tsx
import {
  upload,
  createContentVersion,
} from "@salesforce/ui-bundle-template-feature-react-file-upload";

// Step 1: Upload files (no recordId)
const uploadResults = await upload({
  files: [file1, file2],
  onProgress: (progress) => console.log(progress),
});

// Step 2: Create the record
const newRecordId = await createRecord(formData);

// Step 3: Link uploaded files to the new record
for (const file of uploadResults) {
  const contentVersionId = await createContentVersion(
    new File([""], file.fileName),
    file.contentBodyId,
    newRecordId,
  );
}
```

### 3. 커스텀 UI 빌드

패키지는 backend를 제공하고 frontend는 직접 만든다. 최소 예시:

```tsx
import {
  upload,
  type FileUploadProgress,
} from "@salesforce/ui-bundle-template-feature-react-file-upload";
import { useState } from "react";

function CustomFileUpload({ recordId }: { recordId?: string }) {
  const [progress, setProgress] = useState<Map<string, FileUploadProgress>>(new Map());

  const handleFileSelect = async (event: React.ChangeEvent<HTMLInputElement>) => {
    const files = Array.from(event.target.files || []);

    await upload({
      files,
      recordId,
      onProgress: (fileProgress) => {
        setProgress((prev) => new Map(prev).set(fileProgress.fileName, fileProgress));
      },
    });
  };

  return (
    <div>
      <input type="file" multiple onChange={handleFileSelect} />

      {Array.from(progress.entries()).map(([fileName, fileProgress]) => (
        <div key={fileName}>
          {fileName}: {fileProgress.status} - {fileProgress.progress}%
          {fileProgress.error && <span>Error: {fileProgress.error}</span>}
        </div>
      ))}
    </div>
  );
}
```

### 4. 업로드 진행률 추적

`onProgress` 콜백은 각 파일이 단계를 거치며 여러 번 발화한다.

| Status | When | Progress Value |
|--------|------|----------------|
| `"pending"` | File queued for upload | `0` |
| `"uploading"` | Upload in progress (XHR) | `0-100` (percentage) |
| `"processing"` | Creating ContentVersion (if recordId provided) | `0` |
| `"success"` | Upload complete | `100` |
| `"error"` | Upload failed | `0` |

**항상 시각 피드백 제공:**
- 파일 이름 표시
- 현재 status 표시
- "uploading" status에 progress bar 렌더
- status가 "error"면 에러 메시지 표시

### 5. 업로드 취소 (optional)

`AbortController`로 사용자가 업로드를 취소하게 한다.

```tsx
const abortController = new AbortController();

const handleUpload = async (files: File[]) => {
  try {
    await upload({
      files,
      signal: abortController.signal,
      onProgress: (progress) => console.log(progress),
    });
  } catch (error) {
    console.error("Upload cancelled or failed:", error);
  }
};

const cancelUpload = () => {
  abortController.abort();
};
```

### 6. 현재 사용자에게 연결 (special case)

사용자가 자기 profile/personal library에 파일을 업로드하려 할 때:

```tsx
import {
  upload,
  getCurrentUserId,
} from "@salesforce/ui-bundle-template-feature-react-file-upload";

const userId = await getCurrentUserId();
await upload({ files, recordId: userId });
```

## API Reference

### upload(options)

진행률 추적과 함께 전체 flow를 처리하는 main upload API.

```typescript
interface UploadOptions {
  files: File[];
  recordId?: string | null; // If provided, creates ContentVersion
  onProgress?: (progress: FileUploadProgress) => void;
  signal?: AbortSignal; // Optional cancellation
}

interface FileUploadProgress {
  fileName: string;
  status: "pending" | "uploading" | "processing" | "success" | "error";
  progress: number; // 0-100 for uploading, 0 for other states
  error?: string;
}

interface FileUploadResult {
  fileName: string;
  size: number;
  contentBodyId: string; // Always available
  contentVersionId?: string; // Only if recordId was provided
}
```

**Returns:** `Promise<FileUploadResult[]>`

### createContentVersion(file, contentBodyId, recordId)

이전에 업로드된 파일로부터 ContentVersion 레코드를 수동 생성한다.

```typescript
async function createContentVersion(
  file: File,
  contentBodyId: string,
  recordId: string,
): Promise<string | undefined>;
```

**Parameters:**
- `file` — File object (이름 등 metadata용)
- `contentBodyId` — 이전 업로드의 ContentBody ID
- `recordId` — FirstPublishLocationId용 Record ID

**Returns:** 성공 시 ContentVersion ID

### getCurrentUserId()

현재 사용자의 Salesforce ID를 가져온다.

```typescript
async function getCurrentUserId(): Promise<string>;
```

**Returns:** Current user ID

## Common UI patterns

### File input with button

```tsx
<input type="file" multiple accept=".pdf,.doc,.docx,.jpg,.png" onChange={handleFileSelect} />
```

### Drag-and-drop zone

native 이벤트로 직접 dropzone을 빌드한다.

```tsx
function DropZone({ onDrop }: { onDrop: (files: File[]) => void }) {
  const handleDrop = (e: React.DragEvent) => {
    e.preventDefault();
    const files = Array.from(e.dataTransfer.files);
    onDrop(files);
  };

  return (
    <div
      onDrop={handleDrop}
      onDragOver={(e) => e.preventDefault()}
      style={{ border: "2px dashed #ccc", padding: "2rem" }}
    >
      Drop files here
    </div>
  );
}
```

### Progress bar

```tsx
{
  progress.status === "uploading" && (
    <div style={{ width: "100%", background: "#eee" }}>
      <div
        style={{
          width: `${progress.progress}%`,
          background: "#0176d3",
          height: "8px",
        }}
      />
    </div>
  );
}
```

## Decision tree for agents

**사용자가 파일 업로드 기능을 요청하면:**

1. **record context를 묻는다:**
   - "업로드한 파일을 특정 레코드에 연결할까요, 아니면 먼저 업로드하고 나중에 연결할까요?"

2. **응답 기반:**
   - **기존 레코드에 연결** → `recordId`와 함께 Pattern B
   - **먼저 업로드, 나중에 연결** → Pattern A(recordId 없음) 후 Pattern C로 연결
   - **현재 사용자에게 연결** → `getCurrentUserId()`와 함께 Pattern B

3. **UI 빌드:**
   - file input 또는 dropzone 생성 (패키지가 제공하지 않음)
   - 각 파일의 진행률 표시 추가 (status + progress bar)
   - UI에서 에러 처리

4. **구현 테스트:**
   - progress 콜백이 올바르게 발화하는지 확인
   - `contentBodyId`가 반환되는지 확인
   - `recordId`를 제공했으면 `contentVersionId`가 반환되는지 확인

## Reference implementation

패키지는 `src/features/fileupload/`에 reference 구현을 포함한다:

- `FileUpload.tsx` — dropzone과 dialog가 있는 완전한 컴포넌트
- `FileUploadDialog.tsx` — 진행률 추적 dialog
- `FileUploadDropZone.tsx` — drag-and-drop zone
- `useFileUpload.ts` — state 관리용 React hook

**이들은 export되지 않지만** 예시로 볼 수 있다. 소스 파일을 읽어 자기 UI를 만드는 패턴을 이해한다.

## Troubleshooting

**Upload fails with CORS error:**
- UI bundle이 Salesforce에 제대로 배포됐거나 `localhost`에서 실행 중인지 확인
- org가 CORS 설정에서 해당 origin을 허용하는지 확인

**No progress updates:**
- `onProgress` 콜백이 제공됐는지 확인
- 콜백 함수가 React state를 올바르게 갱신하는지 확인

**ContentVersion not created:**
- `upload()` 함수에 `recordId`가 제공됐는지 확인
- record ID가 유효하고 org에 존재하는지 확인
- 사용자가 ContentVersion 레코드 생성 권한이 있는지 확인

**Files upload but don't appear in record:**
- `recordId`가 올바른지 확인
- ContentVersion이 생성됐는지 확인 (results의 `contentVersionId` 확인)
- 사용자가 레코드의 파일을 볼 권한이 있는지 확인

## 핵심 규칙·가드레일

### DO NOT do these things

- ❌ XHR/fetch 업로드 로직을 처음부터 빌드 — `upload()` API 사용
- ❌ `<FileUpload />` 컴포넌트 import 시도 — export 안 됨
- ❌ `useFileUpload` hook import 시도 — export 안 됨
- ❌ 이 기능이 있는데 third-party 파일 업로드 라이브러리 사용
- ❌ 진행률 추적 생략 — 항상 사용자 피드백 제공
- ❌ 에러 무시 — 항상 에러 메시지 처리·표시

## 번들 파일

- `SKILL.md` — API-only 워크플로 + 3 패턴 + API Reference (별도 참조 파일 없음)
- (참고) 패키지 내 `src/features/fileupload/`: `FileUpload.tsx`, `FileUploadDialog.tsx`, `FileUploadDropZone.tsx`, `useFileUpload.ts` — export 안 됨, 예시 전용

## 관련 노트
- [[experience-ui-bundle-app-coordinate]]
- [[experience-ui-bundle-frontend-generate]]
- [[experience-ui-bundle-agentforce-client-generate]]
