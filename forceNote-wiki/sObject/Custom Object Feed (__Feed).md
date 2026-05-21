---
tags: [sobject-reference, custom-objects, chatter, feed, experience-cloud, rich-text]
source: object_reference.pdf pp.129-136 (v67.0 Summer '26)
created: 2026-05-22
aliases: [Custom Object Feed, __Feed, 커스텀 오브젝트 피드, Chatter Feed, Textile__Feed, IsRichText, NetworkScope, Visibility]
---

# Custom Object Feed `__Feed`

> 커스텀 Object의 Chatter 피드 — 포스트와 필드 변경 추적 레코드

---

## 개요

커스텀 Object 피드는 Object의 추적 필드 변경 및 포스트를 표시한다. Object 이름은 `CustomObject__Feed` 형식 (예: `Textile__c`에 대한 피드는 `Textile__Feed`).

Feed Tracking을 활성화하면 Salesforce가 자동으로 이 피드 Object를 생성한다.

**지원 호출**: `delete()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`

---

## 특수 접근 규칙

### 삭제 권한

```
내부 Org:
  · 자신이 만든 피드 아이템은 누구나 삭제 가능

Experience Cloud 사이트 (threaded discussions + delete-blocking 활성화 시):
  · 사이트 멤버: 자신이 만든 피드 아이템 삭제 가능
    ※ 단, 피드 아이템 아래 댓글·답변·중첩 콘텐츠가 있으면 삭제 불가
  · 중첩 콘텐츠가 있는 아이템: 피드 Moderator 또는 Modify All Data 권한 보유자만 삭제 가능

다른 사람의 아이템 삭제 시 필요한 권한 (다음 중 하나):
  · Modify All Data
  · Modify All Records on the parent object (예: Textile__c)
  · Moderate Chatter
    ※ Moderate Chatter 권한은 자신이 볼 수 있는 아이템·댓글만 삭제 가능
    ※ 비목록(unlisted) 그룹의 아이템 삭제는 이 권한이 있어야 함
```

---

## 전체 필드 참조표

| 필드 | 타입 | 속성 | 설명 |
|---|---|---|---|
| `BestCommentId` | reference | Filter, Group, Nillable, Sort | 질문 포스트에서 Best Answer로 표시된 댓글 ID. API v44.0+ |
| `Body` | textarea | Nillable, Sort | 포스트 본문. Type=TextPost이면 필수. Type=ContentPost·LinkPost이면 선택 |
| `CommentCount` | int | Filter, Group, Sort | 이 피드 아이템의 댓글 수. pre-moderation 피드에서는 댓글 승인 전까지 카운트 미반영. 모더레이션 피드에서는 CommentCount 루프 대신 페이지네이션 방식으로 댓글 조회 권장 |
| `ConnectionId` | reference | Filter, Group, Nillable, Sort | S2S(Salesforce to Salesforce) 활성화 시 사용. PartnerNetworkConnection이 추적 레코드를 수정하면 CreatedBy에 시스템 관리자 ID가, ConnectionId에 PartnerNetworkConnection ID가 설정됨 |
| `ContentData` | base64 | Nillable | API v36.0 이전에만 사용 가능. Type=ContentPost이면 필수. 0바이트 불가. 이 필드 설정 시 Type이 ContentPost로 자동 설정됨 |
| `ContentFileName` | string | Group, Nillable, Sort | API v36.0 이전에만 사용 가능. Type=ContentPost이면 필수. 피드에 업로드한 파일명. 이 필드 설정 시 Type이 ContentPost로 자동 설정됨 |
| `ContentSize` | int | Group, Nillable, Sort | API v36.0 이전에만 사용 가능. 업로드된 파일 크기(바이트). 읽기 전용 — insert 시 자동 결정 |
| `ContentType` | string | Group, Nillable, Sort | API v36.0 이전에만 사용 가능. 업로드된 파일의 MIME 타입. 읽기 전용 — insert 시 자동 결정 |
| `FeedPostId` | reference | Filter, Group, Nillable, Sort | API v22.0에서 제거됨. 이전 버전 하위 호환용으로만 존재. 연관된 FeedPost ID (추적 필드 변경·텍스트 포스트·링크 포스트·콘텐츠 포스트 표현) |
| `InsertedById` | reference | Group, Nillable, Sort | 이 아이템을 피드에 추가한 User ID. 예: 다른 앱에서 피드로 마이그레이션할 때, InsertedBy는 컨텍스트 사용자 ID로 설정 |
| `IsRichText` | boolean | Defaulted on create, Filter, Group, Sort | Body에 rich text가 포함됐는지 여부. SOAP API로 rich text 포스트 작성 시 true로 설정하고 HTML 엔티티를 이스케이프해야 함. 미설정 시 plain text로 렌더링 |
| `LikeCount` | int | Filter, Group, Sort | 이 피드 아이템의 좋아요 수 |
| `LinkUrl` | url | Nillable, Sort | LinkPost의 URL |
| `NetworkScope` | picklist | Group, Nillable, Restricted picklist, Sort | 피드 아이템이 사용 가능한 Experience Cloud 범위. API v26.0+, Digital Experiences 활성화 필요. 값: `NetworkId`(특정 사이트 ID) 또는 `AllNetworks`(전체 사이트) |
| `ParentId` | reference | Filter, Group, Sort | 피드에서 추적하는 커스텀 Object 레코드 ID. 이 레코드의 상세 페이지에 피드 표시 |
| `RelatedRecordId` | reference | Group, Nillable, Sort | ContentPost와 연결된 ContentVersion Object ID. ContentPost가 아닌 경우 null |
| `Title` | string | Group, Nillable, Sort | 피드 아이템 제목. Type=LinkPost이면 LinkUrl이 URL이고 이 필드가 링크 이름 |
| `Type` | picklist | Filter, Group, Nillable, Restricted picklist, Sort | 피드 아이템 유형 (아래 전체 목록 참조) |
| `Visibility` | picklist | Filter, Group, Nillable, Restricted picklist, Sort | 피드 아이템 가시성. API v26.0+, Digital Experiences 활성화 필요. 값: `AllUsers`·`InternalUsers` |

---

## Type picklist 전체 값

### 공통 값 (모든 커스텀 Object 피드)

| 값 | 설명 |
|---|---|
| `ActivityEvent` | Event 또는 Task 추가 시 자동 생성. 피드 활성화된 부모 레코드에 Task 연결 시 간접 생성 (케이스 이메일 Task 제외). 반복 Task의 경우 CaseFeed 비활성화 시 시리즈에 대해 이벤트 1개 생성, 활성화 시 시리즈+개별 발생 각각 이벤트 생성 |
| `AdvancedTextPost` | 그룹 공지 포스트 시 생성. API v39.0 이상 Lightning Experience에서 포스트 공유 시도 생성 |
| `AnnouncementPost` | 미사용 |
| `ApprovalPost` | 사용자가 승인 제출 시 자동 생성 |
| `BasicTemplateFeedItem` | 미사용 |
| `CanvasPost` | Canvas 앱이 피드에 게시한 포스트 |
| `CollaborationGroupCreated` | 사용자가 공개 그룹 생성 시 자동 생성 |
| `CollaborationGroupUnarchived` | 미사용 |
| `ContentPost` | 첨부 파일이 있는 포스트 |
| `CreatedRecordEvent` | 사용자가 publisher에서 레코드 생성 시 자동 생성 |
| `DashboardComponentAlert` | 대시보드 지표/게이지가 임계값 초과 시 자동 생성 |
| `DashboardComponentSnapshot` | 사용자가 피드에 대시보드 스냅샷 게시 시 생성 |
| `LinkPost` | URL이 첨부된 포스트 |
| `PollPost` | 피드에 게시된 투표 |
| `ProfileSkillPost` | 사용자의 Chatter 프로필에 스킬 추가 시 자동 생성 |
| `QuestionPost` | 사용자가 질문 게시 시 자동 생성 |
| `ReplyPost` | Chatter Answers가 답변 게시 시 자동 생성 |
| `RypplePost` | 사용자가 WDC에서 Thanks 배지 생성 시 자동 생성 |
| `TextPost` | 피드에 직접 입력한 텍스트 포스트 |
| `TrackedChange` | 추적 필드 변경 또는 변경 그룹 |
| `UserStatus` | 사용자가 포스트 추가 시 자동 생성. **Deprecated** |

### CaseFeed 전용 값

| 값 | 설명 |
|---|---|
| `CaseCommentPost` | 케이스 댓글 추가 시 자동 생성 |
| `EmailMessageEvent` | 케이스 관련 이메일 수발신 시 자동 생성 |
| `CallLogPost` | UI에서 통화 로그 시 자동 생성. CTI 통화도 이 이벤트 생성 |
| `ChangeStatusPost` | 케이스 상태 변경 시 자동 생성 |
| `AttachArticleEvent` | 케이스에 아티클 첨부 시 자동 생성 |

---

## IsRichText — 지원 HTML 태그

Body에 `IsRichText = true`로 설정 시 지원하는 HTML 태그:

```
<p>   — 단락 (줄바꿈은 <br> 미지원, <p>&nbsp;</p>로 대체)
<a>   — 링크
<b>   — 굵게
<code> — 코드
<i>   — 기울임
<u>   — 밑줄
<s>   — 취소선
<ul>  — 순서 없는 목록
<ol>  — 순서 있는 목록
<li>  — 목록 항목
<img> — 이미지 (API를 통해서만 접근 가능, Salesforce 파일 참조 필수)
       예: <img src="sfdc://069B0000000omjh"></img>
```

> [!note] API v35.0 이상: 시스템이 rich text 특수문자를 이스케이프된 HTML로 자동 변환. v34.0 이하: rich text가 plain text 표현으로 표시.

---

## NetworkScope 동작 규칙

```
값 설정:
  · NetworkId 값 — 해당 Experience Cloud 사이트에서만 사용 가능
    (빈 값이면 기본 Experience Cloud 사이트에서만 사용 가능)
  · AllNetworks — 모든 Experience Cloud 사이트에서 사용 가능

예외:
  · NetworkId 또는 null 설정 가능한 피드 아이템: Group 또는 User가 부모인 것만
  · 레코드가 부모인 피드 아이템: AllNetworks만 설정 가능
  · NetworkScope 필드로 피드 아이템 필터링 불가
```

## Visibility 동작 규칙

```
값:
  · AllUsers — 피드 아이템을 볼 권한이 있는 모든 사용자
  · InternalUsers — 내부 사용자만

예외:
  · 레코드 포스트: 기본값 InternalUsers (내부 사용자에게)
  · 외부 사용자: AllUsers만 설정 가능
  · 사용자/그룹 포스트: 내부 사용자만 InternalUsers로 설정 가능
```

---

## SOQL 사용 패턴 및 제한

```apex
// 커스텀 Object 피드 최근 포스트 조회
List<Textile__Feed> posts = [
    SELECT Body, Type, IsRichText, CreatedBy.Name, CreatedDate, LikeCount, CommentCount
    FROM Textile__Feed
    WHERE ParentId = :textileId
    ORDER BY CreatedDate DESC
    LIMIT 20
];

// 추적 필드 변경만 조회
List<Textile__Feed> changes = [
    SELECT Body, Type, CreatedDate
    FROM Textile__Feed
    WHERE ParentId = :textileId
    AND Type = 'TrackedChange'
    ORDER BY CreatedDate DESC
];

// ContentPost 조회 (첨부 파일 포함)
List<Textile__Feed> filePosts = [
    SELECT Body, Title, Type, RelatedRecordId
    FROM Textile__Feed
    WHERE ParentId = :textileId
    AND Type = 'ContentPost'
];
```

### SOQL 제한 규칙

```
· View All Data 권한 있는 사용자: SOQL 제한 없음
· 그 외: LIMIT 1,000 이하로 명시 필수
· ORDER BY: 관계(relationship) 필드 사용 불가
  → 루트 Object 필드에 대해서만 ORDER BY 사용 가능
```

---

## 관련 노트

- [[4 Custom Objects]] — Custom Object·Metadata·Feed 챕터 개요 (부모 챕터)
- [[Custom Object Standard Fields (__c)]] — __c 표준 필드 참조표
- [[Custom Metadata Type (__mdt)]] — __mdt 필드 참조표
- [[Feed Objects]] — 표준 Object 피드(AccountFeed·CaseFeed 등) 패턴 및 Type picklist 상세
- [[3 Associated Objects]] — Feed·History·Share·ChangeEvent 패턴 챕터
