---
tags: [apex, integration, chatter, connect-api, pattern, communities, user-profiles]
source: automation-components/src-messaging/PostRichChatter.cls, ConnectApiHelper.cls, salesforce_apex_reference_guide_v67
created: 2026-05-17
aliases: [ConnectApi, Chatter 게시, postFeedItemWithRichText, Chatter 멘션, ConnectApiHelper, getCommunities, getCommunity, getUserProfile, ConnectApi.Communities, ConnectApi.UserProfiles, postFeedElement, FeedItemInput, MentionSegmentInput, MessageBodyInput, 네이티브 멘션 게시]
---

# ConnectApi Chatter 패턴

> Apex에서 ConnectApi 네임스페이스로 Chatter 피드를 게시하는 패턴. 리치 텍스트, @멘션, 인라인 이미지를 지원한다. Experience Cloud 사이트 조회(Communities)와 사용자 프로필 접근(UserProfiles)도 다룬다.

---

## 기본 구조 — postFeedItemWithRichText

```apex
// ConnectApiHelper 유틸리티 클래스 경유 (권장)
ConnectApi.FeedElement feedElement = ConnectApiHelper.postFeedItemWithRichText(
    communityId,  // String: 커뮤니티 Id, 'internal', 또는 null
    targetId,     // Id: 사용자 Id, 그룹 Id, 또는 레코드 Id
    richTextBody  // String: HTML 마크업 본문
);

Id feedItemId = feedElement.id;
```

---

## targetId 결정 — 이름 또는 Id 자동 판별

```apex
Id targetId;
try {
    targetId = Id.valueOf(input.targetNameOrId);  // Id 형식이면 바로 사용
} catch (System.StringException e) {
    // 이름인 경우 그룹 또는 사용자 검색
    List<Group> groups = [SELECT Id FROM Group WHERE Name = :name WITH USER_MODE];
    if (!groups.isEmpty()) {
        targetId = groups[0].Id;
        return;
    }
    List<User> users = [SELECT Id FROM User WHERE Username = :name WITH USER_MODE];
    if (!users.isEmpty()) {
        targetId = users[0].Id;
        return;
    }
    throw new InvalidNameException('User or Group not found: ' + name);
}
```

---

## ConnectApi 리치 텍스트 지원 HTML 태그

```apex
// ConnectApiHelper가 지원하는 태그 → ConnectApi.MarkupType 변환
Map<String, ConnectApi.MarkupType> supportedMarkup = new Map<String, ConnectApi.MarkupType> {
    'b'    => ConnectApi.MarkupType.Bold,
    'i'    => ConnectApi.MarkupType.Italic,
    'u'    => ConnectApi.MarkupType.Underline,
    's'    => ConnectApi.MarkupType.Strikethrough,
    'code' => ConnectApi.MarkupType.Code,
    'p'    => ConnectApi.MarkupType.Paragraph,
    'ol'   => ConnectApi.MarkupType.OrderedList,
    'ul'   => ConnectApi.MarkupType.UnorderedList,
    'li'   => ConnectApi.MarkupType.ListItem
};
```

---

## @멘션 포함 게시

```apex
// {UserId} 형식으로 멘션 삽입
String body = 'Hello {005xx000001Ab2c}, please review this case.';

ConnectApi.FeedElement feedElement = ConnectApiHelper.postFeedItemWithMentions(
    null,       // communityId (internal = null)
    recordId,   // 레코드 피드에 게시
    body
);
```

---

## 네이티브 멘션 게시 — ConnectApiHelper 없이 postFeedElement 직접 사용

> ConnectApiHelper는 오픈소스 유틸(GitHub)이라 org에 없을 수 있다. 헬퍼 없이 표준 ConnectApi 입력 클래스만으로 멘션을 게시하는 패턴. 공식 문서도 "두 가지 방법 — ConnectApiHelper 한 줄 vs 이 메서드 예제"로 안내한다.

```apex
// 메서드: postFeedElement(communityId, feedElement) — API v36.0, Chatter 필수
// public static ConnectApi.FeedElement postFeedElement(String communityId,
//     ConnectApi.FeedElementInput feedElement)

ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();

// 1. 본문은 세그먼트 리스트 — 멘션·텍스트를 순서대로 add
messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

mentionSegmentInput.id = '005RR000000Dme9';           // 멘션할 사용자 Id
messageBodyInput.messageSegments.add(mentionSegmentInput);

textSegmentInput.text = 'Could you take a look?';
messageBodyInput.messageSegments.add(textSegmentInput);

// 2. FeedItemInput 조립
feedItemInput.body = messageBodyInput;
feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
feedItemInput.subjectId = '0F9RR0000004CPw';          // 게시 대상 (사용자/그룹/레코드 Id, 'me' 가능)

// 3. 게시
ConnectApi.FeedElement feedElement =
    ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);
```

### 입력 클래스 조립 구조

| 클래스 | 역할 |
|---|---|
| `ConnectApi.FeedItemInput` | 피드 아이템 전체 컨테이너 — `body` · `subjectId` · `feedElementType` · `capabilities` |
| `ConnectApi.MessageBodyInput` | 본문. `messageSegments` = `List<ConnectApi.MessageSegmentInput>` |
| `ConnectApi.TextSegmentInput` | 일반 텍스트 세그먼트 (`text`) |
| `ConnectApi.MentionSegmentInput` | @멘션 세그먼트 (`id` = 사용자 Id) |
| `ConnectApi.MarkupBeginSegmentInput` / `MarkupEndSegmentInput` | 리치 텍스트 마크업 (`markupType` = `ConnectApi.MarkupType.Bold` 등) |
| `ConnectApi.InlineImageSegmentInput` | 인라인 이미지 (`fileId` · `altText`) |
| `ConnectApi.FeedElementCapabilitiesInput` | 첨부 능력 컨테이너 — 파일 첨부 시 `files`에 `FilesCapabilityInput` 지정 |

### 파일 첨부 — FeedElementCapabilitiesInput

```apex
ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
feedItemInput.subjectId = 'me';

ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
textSegmentInput.text = 'Would you please review these docs?';

ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
messageBodyInput.messageSegments.add(textSegmentInput);
feedItemInput.body = messageBodyInput;

// 기존 업로드 파일(069) 최대 10개까지 첨부 가능
ConnectApi.FilesCapabilityInput filesInput = new ConnectApi.FilesCapabilityInput();
filesInput.items = new List<ConnectApi.FileIdInput>();
ConnectApi.FileIdInput idInput = new ConnectApi.FileIdInput();
idInput.id = '069xx00000000QO';
filesInput.items.add(idInput);

ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput =
    new ConnectApi.FeedElementCapabilitiesInput();
feedElementCapabilitiesInput.files = filesInput;
feedItemInput.capabilities = feedElementCapabilitiesInput;

ConnectApi.FeedElement feedElement =
    ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);
```

### 코멘트에 멘션 — postCommentToFeedElement

피드가 아니라 **기존 피드 요소의 코멘트**에 멘션할 때는 `ConnectApi.CommentInput`을 같은 방식으로 조립한다 (코멘트 최대 10,000자).

```apex
String communityId = null;
String feedElementId = '0D5D0000000KtW3';
ConnectApi.CommentInput commentInput = new ConnectApi.CommentInput();
ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();

messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
textSegmentInput.text = 'Does anyone in this group have an idea? ';
messageBodyInput.messageSegments.add(textSegmentInput);
mentionSegmentInput.id = '005D00000000oOT';
messageBodyInput.messageSegments.add(mentionSegmentInput);

commentInput.body = messageBodyInput;
ConnectApi.Comment commentRep = ConnectApi.ChatterFeeds.postCommentToFeedElement(
    communityId, feedElementId, commentInput, null);
```

---

## Flow 리치 텍스트 → Chatter 변환 처리

Flow의 리치 텍스트는 Chatter와 HTML 방언이 다르다. 변환 필수 항목:

```apex
// 1. span 태그 제거 (Chatter 미지원 — 색상, 폰트 크기 등)
body = Pattern.compile('<\\/?span[^>]*>').matcher(body).replaceAll('');

// 2. 들여쓰기 클래스 제거
body = Pattern.compile(' class="ql-indent-[1-4]"').matcher(body).replaceAll('');

// 3. 이미지 태그 → 텍스트 URL로 변환
body = Pattern.compile('<img src="([^"]+)">').matcher(body).replaceAll('image: $1');
```

---

## Communities Class — Experience Cloud 사이트 조회

> API v28.0부터 지원. Chatter 불필요. 게스트 사용자는 v35.0부터 `getCommunity()` 접근 가능.

```apex
// 1. 모든 사이트 목록 조회
ConnectApi.CommunityPage allSites = ConnectApi.Communities.getCommunities();

// 2. 상태 필터 조회 — Live / Inactive / UnderConstruction
ConnectApi.CommunityPage liveSites = ConnectApi.Communities.getCommunities(
    ConnectApi.CommunityStatus.Live
);

// 3. 특정 사이트 단건 조회
ConnectApi.Community site = ConnectApi.Communities.getCommunity(communityId);
// communityId는 null 또는 'internal' 불가 — 반드시 실제 사이트 Id
```

| 메서드 | 시그니처 | API 버전 |
|---|---|---|
| `getCommunities()` | `public static ConnectApi.CommunityPage getCommunities()` | v28.0 |
| `getCommunities(communityStatus)` | `public static ConnectApi.CommunityPage getCommunities(ConnectApi.CommunityStatus communityStatus)` | v28.0 |
| `getCommunity(communityId)` | `public static ConnectApi.Community getCommunity(String communityId)` | v28.0 |

> [!tip] communityId 활용 패턴
> `getCommunities()`로 전체 목록을 가져와 이름으로 필터링 후 `community.id`를 다른 ConnectApi 메서드의 `communityId` 파라미터로 전달한다.

---

## UserProfiles Class — 사용자 프로필 및 사진 접근

> Chatter 필수. 모든 메서드가 per-user, per-namespace, per-hour 레이트 한도 적용.

```apex
// 1. 사용자 프로필 조회 (API v29.0)
ConnectApi.UserProfile profile = ConnectApi.UserProfiles.getUserProfile(
    communityId,  // String: Experience Cloud 사이트 Id, 'internal', 또는 null
    userId        // String: 사용자 Id
);

// 2. 프로필 사진 조회 (API v35.0, 게스트 사용자도 접근 가능)
ConnectApi.Photo photo = ConnectApi.UserProfiles.getPhoto(
    communityId,
    userId
);

// 3. 배너 사진 조회 (API v36.0)
ConnectApi.BannerPhoto banner = ConnectApi.UserProfiles.getBannerPhoto(
    communityId,
    userId
);

// 4. 기존 파일로 프로필 사진 설정 (API v35.0)
ConnectApi.Photo updatedPhoto = ConnectApi.UserProfiles.setPhoto(
    communityId,
    userId,
    fileId,        // String: 파일 Id (키 prefix 069)
    versionNumber  // Integer: 파일 버전 번호, null이면 최신 버전
);

// 5. 기존 파일로 배너 사진 설정 (API v36.0)
ConnectApi.BannerPhoto updatedBanner = ConnectApi.UserProfiles.setBannerPhoto(
    communityId,
    userId,
    fileId,        // String: 파일 Id (키 prefix 069, 8MB 미만)
    versionNumber  // Integer: null이면 최신 버전
);
```

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getUserProfile(communityId, userId)` | `ConnectApi.UserProfile` | Chatter 프로필 페이지 데이터 (연락처 정보, 권한, 앱 탭) |
| `getPhoto(communityId, userId)` | `ConnectApi.Photo` | 프로필 사진 URL + 메타데이터 |
| `getBannerPhoto(communityId, userId)` | `ConnectApi.BannerPhoto` | 배너 사진 URL + 메타데이터 |
| `deletePhoto(communityId, userId)` | `Void` | 프로필 사진 삭제 (v35.0) |
| `deleteBannerPhoto(communityId, userId)` | `Void` | 배너 사진 삭제 (v36.0) |
| `setPhoto(communityId, userId, fileId, versionNumber)` | `ConnectApi.Photo` | 업로드된 파일을 프로필 사진으로 설정 |
| `setBannerPhoto(communityId, userId, fileId, versionNumber)` | `ConnectApi.BannerPhoto` | 업로드된 파일을 배너 사진으로 설정 |

> [!warning] 사진 처리 비동기
> `setPhoto()`, `setBannerPhoto()` 호출 후 사진이 즉시 표시되지 않을 수 있다. 처리가 비동기적으로 완료된다.

---

## 비교표 — Chatter 게시 방법

| 상황 | 방법 |
|---|---|
| 단순 텍스트 + 멘션 (헬퍼 있음) | `ConnectApiHelper.postFeedItemWithMentions()` |
| 멘션 게시 — 헬퍼 없는 org | `FeedItemInput` + `MentionSegmentInput` 조립 → `ConnectApi.ChatterFeeds.postFeedElement()` (위 "네이티브 멘션 게시" 섹션) |
| 코멘트에 멘션 | `CommentInput` 조립 → `ConnectApi.ChatterFeeds.postCommentToFeedElement()` |
| 리치 텍스트 (볼드, 목록) | `ConnectApiHelper.postFeedItemWithRichText()` |
| Flow에서 Chatter 게시 | `PostRichChatter` @InvocableMethod |
| 파일 첨부 포함 | `FeedElementCapabilitiesInput.files` → `ConnectApi.ChatterFeeds.postFeedElement()` 직접 사용 |
| Experience Cloud 사이트 목록 조회 | `ConnectApi.Communities.getCommunities()` |
| 사용자 프로필 조회 | `ConnectApi.UserProfiles.getUserProfile()` |
| 프로필/배너 사진 관리 | `ConnectApi.UserProfiles.setPhoto()` / `setBannerPhoto()` |

---

## 주의 사항

> [!warning] ConnectApi 테스트 제한
> `ConnectApi` 메서드는 테스트에서 실제 호출 불가. `Test.setMock()` 대신
> `ConnectApi.setTestGetFeedElement()` 등 ConnectApi 전용 mock 메서드 사용.

> [!tip] 커뮤니티 게시
> `communityId` 파라미터에 Experience Cloud 사이트 Id를 전달하면 해당 커뮤니티 피드에 게시.
> 내부 org는 `null` 또는 `'internal'` 사용.

---

## 관련 노트

- [[Flow 유틸리티 액션 모음]] — PostRichChatter Invocable Action
- [[@InvocableMethod 패턴]] — Invocable Action 구조
- [[ConnectApi Namespace 개요]] — ConnectApi 전체 클래스 목록, EinsteinLLM/CdpQuery/CommerceCart
- [[Connect REST API 개요]] — 같은 Chatter 피드 작업을 HTTP REST로 수행하는 짝(모바일·외부앱). Apex callout 없이 vs REST 접근 비교
- [[Feed Elements Resources]] — REST 측 피드 게시 엔드포인트(`/chatter/feed-elements` · Feed Item Input). Apex `ConnectApi.postFeedElement` ↔ REST POST 짝
- [[특정 표준 객체 트리거 고려사항 — Chatter · Knowledge]] — ConnectApi로 게시한 피드가 FeedItem 트리거에 미치는 영향·FeedItem/FeedComment 트리거 고유 제약
