---
tags: [apex, integration, chatter, connect-api, pattern, communities, user-profiles]
source: automation-components/src-messaging/PostRichChatter.cls, ConnectApiHelper.cls, salesforce_apex_reference_guide_v67
created: 2026-05-17
aliases: [ConnectApi, Chatter 게시, postFeedItemWithRichText, Chatter 멘션, ConnectApiHelper, getCommunities, getCommunity, getUserProfile, ConnectApi.Communities, ConnectApi.UserProfiles]
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
| 단순 텍스트 + 멘션 | `ConnectApiHelper.postFeedItemWithMentions()` |
| 리치 텍스트 (볼드, 목록) | `ConnectApiHelper.postFeedItemWithRichText()` |
| Flow에서 Chatter 게시 | `PostRichChatter` @InvocableMethod |
| 파일 첨부 포함 | `ConnectApi.ChatterFeeds.postFeedElement()` 직접 사용 |
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
