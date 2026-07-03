---
tags: [integration, connect-rest-api, topics, announcements, questions-answers]
source: salesforce_chatter_rest_api.pdf (Connect REST API Developer Guide, Version 67.0 Summer '26; PDF p753–758·974–975·988–992; Tier 1/2)
created: 2026-07-03
aliases: [Announcements, 공지, Question and Answers, Q&A, 질문 답변, Topics, 토픽, Topic Endorsement, 토픽 추천, Knowledgeable People, Topic Opt Out]
---

# Connect REST API — Topics · Announcements · Q&A Resources

> 공지(Announcements) 생성·관리, Q&A 제안·미답변 질문 조회, 토픽의 추천(endorsement)·정통한 사람(knowledgeable people)·옵트아웃을 다루는 Connect REST 리소스 10종. 여기서 다루는 **Topics는 Chatter 클러스터**(endorsement·knowledgeable·opt-out)로, 일반 Topics·Managed Topics·Topics on Records와는 별개다.

---

이 노트의 모든 리소스는 **Requires Chatter: Yes**이며, `/connect/...` 경로와 함께 Experience Cloud 변형 `/connect/communities/{communityId}/...`가 병존한다. 응답 바디는 이름만 기재하고, 전체 스키마는 Reference 챕터에 위임한다(재서술하지 않음). 요청 Input·enum·파라미터는 전수 기재했다.

base URI·페이지네이션 규약은 [[Connect REST API 요청·응답 규약]] 참조.

---

## Announcements

지정 parent 엔티티의 공지를 조회·생성하고, 개별 공지를 조회·수정·삭제한다. 공지는 정보를 강조하는 데 사용하며 사용자가 토론·좋아요·댓글을 달 수 있다.

동작 규칙:
- 공지 생성 시 공지 텍스트를 담은 **피드 아이템도 함께 생성**된다. 그 **피드 포스트를 삭제하면 공지도 삭제**된다.
- 만료일이 지정한 날짜의 **오후 11:59(23:59)까지** UI 지정 위치에 표시된다. 다른 공지가 먼저 지정되거나 삭제/대체되면 그 전에 사라진다.
- 그룹 공지 게시(그룹 컨텍스트)는 [[Groups Resources]]의 announcements 리소스가 담당하고, 여기서는 개별 공지 관리를 다룬다.

| 리소스 | URI | 버전 | 메서드 | 응답 |
|---|---|---|---|---|
| Announcements (컬렉션) | `/chatter/announcements` | 36.0 | GET · POST · HEAD | GET→Announcement Page, POST→Announcement |
| Announcement (단건) | `/chatter/announcements/{announcementId}` | 31.0 | GET · PATCH · DELETE · HEAD | GET/PATCH→Announcement, DELETE→204 |

### Announcements (컬렉션) — GET 파라미터

| Param | Type | 필수 | 설명 |
|---|---|---|---|
| page | Integer | Opt | 페이지 번호(0부터) |
| pageSize | Integer | Opt | 페이지당 항목 수 |
| parentId | String | **Req** | 공지 parent 엔티티 ID. 그룹 공지면 group ID |

### Announcement Input (POST 컬렉션 body / PATCH 단건 body 공통 6프로퍼티)

POST 컬렉션 root 요소는 `<announcement>`. 아래 6프로퍼티를 사용한다.

| Name | Type | 설명 | 필수 여부 | v |
|---|---|---|---|---|
| body | Message Body Input | 공지 텍스트 | feedItemId 미지정 시 생성 **Req**; 수정 시 미지정 | 31.0 |
| expirationDate | String | ISO 8601. UI는 이 날짜 **23:59까지** 표시(다른 공지가 먼저면 대체). 시간값은 무시(자체 UI 로직엔 활용 가능) | 생성 **Req** / 수정 Opt | 31.0 |
| feedItemId | String | 공지 본문이 되는 **AdvancedTextPost** 피드 아이템 ID | body 미지정 시 생성 **Req**; 수정 시 미지정 | 36.0 |
| isArchived | Boolean | 공지 아카이브 여부 | Opt | 36.0 |
| parentId | String | 공지 parent 엔티티 ID(그룹 ID) | feedItemId 미지정 시 생성 **Req**; 수정 시 미지정 | 36.0 |
| sendEmails | Boolean | 그룹 멤버 email 설정과 무관하게 전원에게 email 발송. Chatter email이 비활성인 org는 미발송. **기본 false** | 생성 Opt; 수정 시 미지정 | 36.0 |

body와 feedItemId는 **택일**이다 — 새 메시지로 만들거나(body), 기존 AdvancedTextPost 피드 아이템을 본문으로 삼는다(feedItemId).

```json
// 아래는 덤프 발췌 예시값 — 실제 ID는 org마다 다름
POST /connect/chatter/announcements
{
  "body": {
    "messageSegments": [
      { "text": "Please install the updates...", "type": "Text" }
    ]
  },
  "parentId": "0F9B0000000004S",
  "expirationDate": "2016-02-22T00:00:00.000Z"
}
```

기존 피드 아이템을 공지 본문으로 지정할 때:

```json
// 예시값 — feedItemId는 AdvancedTextPost 타입이어야 함
{
  "feedItemId": "0D5D0000000DaZBKA0",
  "expirationDate": "2016-02-22T00:00:00.000Z"
}
```

### Announcement (단건)

PATCH root 요소도 `<announcement>`. 컬렉션 POST와 동일한 6프로퍼티를 쓰되, **수정 시에는 body·feedItemId·parentId·sendEmails를 미지정**하고 isArchived·expirationDate만 수정한다.

- PATCH 파라미터: `expirationDate`(String **Req**, v31.0)
- DELETE → HTTP 204

```json
// 예시값 — 단건 PATCH
{
  "expirationDate": "2016-02-22T00:00:00.000Z",
  "isArchived": "false"
}
```

---

## Question and Answers

Q&A 제안을 조회하고, Experience Cloud 사이트에서 컨텍스트 사용자의 top unanswered 질문을 조회한다.

| 리소스 | URI | 버전 | 메서드 | 응답 |
|---|---|---|---|---|
| Q&A Suggestions | `/connect/question-and-answers/suggestions` | 32.0 | GET | Question and Answers Suggestion Collection |
| Top Unanswered (Pilot) | `/connect/communities/{communityId}/question-and-answers/top-unanswered` | 42.0 | GET | Feed Element Page |

두 리소스 모두 GET 전용이며 요청 Input이 없다.

### Q&A Suggestions — GET 파라미터

| Param | Type | 필수 | 설명 |
|---|---|---|---|
| includeArticles | Boolean | Opt | true면 knowledge article 포함, false면 질문만 |
| maxResults | Integer | Opt | 항목 유형별 최대 결과. **1–10, 기본 5** |
| q | String | **Req** | 검색 문자열(와일드카드 제외 **최소 2자, 최대 255자**) |
| subjectId | String | Opt | 특정 오브젝트의 질문만 검색. **ID가 topic 또는 user이면 무시됨** |

### Top Unanswered — GET 파라미터

> [!warning] 이 리소스는 파일럿이다. 원문 Note: top-5 unanswered 질문을 파일럿으로 선택 고객에게 제공했으나, **이 파일럿은 종료됐고 신규 참가가 불가능하다.**

| Param | Type | 필수 | 설명 |
|---|---|---|---|
| filter | String | Opt | **유일한 유효값 `UnansweredQuestionsWithCandidateAnswers`** (v42.0) |
| pageSize | Integer | Opt | **0–10, 기본 5** (v42.0) |

피드 레벨의 topics·question-and-answers capability(피드 엘리먼트에 붙는 능력)는 [[Feed Elements Resources]]가 담당한다.

---

## Topics — Chatter 클러스터

> [!info] 이 절의 Topics는 **Chatter 클러스터**(endorsement·knowledgeable people·opt-out)이며 URI가 `/connect/topics/{topicId}/...`·`/connect/topic-endorsements/...`·`/connect/topic-opt-outs/...`이다. **일반 Topics·Managed Topics·Topics on Records와는 별개**이므로 혼동하지 않는다.

토픽 endorsement(추천)를 조회·부여하고, 토픽에 최근 기여한 그룹, 토픽에 정통한 사람(knowledgeable people)을 조회하며, Knowledgeable People 목록에서 opt out·opt back in 한다.

Key prefix:
- endorsement 레코드 = **`0en`**
- topic opt out 레코드 = **`0eb`**

| 리소스 | URI | 버전 | 메서드 | 응답 |
|---|---|---|---|---|
| Endorse People | `/connect/topics/{topicId}/endorsements` | 30.0 | GET · HEAD · POST | GET→Topic Endorsement Collection, POST→Topic Endorsement |
| Topic Endorsement (단건) | `/connect/topic-endorsements/{endorsementId}` | 30.0 | GET · HEAD · DELETE | GET→Topic Endorsement, DELETE→204 |
| Topic Groups | `/connect/topics/{topicId}/groups` | 29.0 | GET · HEAD | Group Page |
| Knowledgeable People | `/connect/topics/{topicId}/knowledgeable-users` | 30.0 | GET · HEAD | Knowledgeable People Collection |
| Topic Opt Outs (컬렉션) | `/connect/topics/{topicId}/topic-opt-outs` | 30.0 | GET · HEAD · POST | GET→Topic Opt Out Collection, POST→Topic Opt Out |
| Topic Opt Out (단건) | `/connect/topic-opt-outs/{topicOptOutId}` | 30.0 | GET · HEAD · DELETE | GET→Topic Opt Out, DELETE→204 |

### Endorse People — GET 파라미터 / POST Input

GET 파라미터:

| Param | Type | 필수 | v | 설명 |
|---|---|---|---|---|
| endorseeId | String | Opt | 31.0 | endorsement를 받은 user |
| endorserId | String | Opt | 31.0 | endorse한 user |
| page | Integer | Opt | 30.0 | > 0, 기본 0 |
| pageSize | Integer | Opt | 30.0 | 1–100, 기본 25 |

POST root 요소는 `<topicEndorsement>`. 프로퍼티는 `userId`(String **Req**, v30.0 — endorse할 user). POST 파라미터 userId.

```json
// 예시값 — 특정 user를 이 토픽에 대해 추천
POST /connect/topics/{topicId}/endorsements
{
  "userId": "005B0000000Ge16"
}
```

### Topic Endorsement (단건)

user를 endorse하면 prefix `0en` 레코드가 생성된다. 제거하려면 그 endorsement 레코드를 삭제한다.

```
// 예시값 — endorsement 레코드 삭제(0en prefix)
DELETE /connect/topic-endorsements/0enD0000000003UIAQ
→ HTTP 204
```

### Topic Groups

토픽에 최근 기여한 그룹 5개를 조회한다. 응답은 Group Page.

> 경로 노트: **v28.0에서는** `/chatter/topics/{topicId}/groups` 경로였다(v29.0부터 `/connect/...`).

### Knowledgeable People

토픽에 정통한 사람 목록을 조회한다.

| Param | Type | 필수 | v | 설명 |
|---|---|---|---|---|
| page | Integer | Opt | 30.0 | > 0, 기본 0 |
| pageSize | Integer | Opt | 30.0 | 1–100, 기본 25 |

응답은 Knowledgeable People Collection.

### Topic Opt Outs (컬렉션) / Topic Opt Out (단건)

Knowledgeable People 목록에서 자신을 숨긴다(opt out). opt out 후 다시 보이게 하려면(opt back in) 해당 opt out 레코드를 삭제한다. opt out하면 prefix `0eb` 레코드가 생성된다.

- 컬렉션 POST의 request body/파라미터 표는 PDF에 명시돼 있지 않다.

```
// 예시값 — opt out 레코드 삭제 → 다시 목록에 표시(0eb prefix)
DELETE /connect/topic-opt-outs/0ebD0000000003oIAA
→ HTTP 204
```

---

## 응답 스키마 위임

아래 응답 바디의 전체 스키마는 이 노트에서 재서술하지 않고 Reference 챕터에 위임한다: Announcement · Announcement Page · Message Body Input · Question and Answers Suggestion Collection · Feed Element Page · Topic Endorsement · Topic Endorsement Collection · Group Page · Knowledgeable People Collection · Topic Opt Out · Topic Opt Out Collection.

---

## 관련 노트
- [[Feed Elements Resources]] — 피드 엘리먼트의 topics·question-and-answers capability(피드 레벨) vs 이 노트(토픽 endorsement·공지)
- [[Groups Resources]] — 그룹 공지 게시(announcements)·그룹의 토픽
- [[Connect REST API 요청·응답 규약]] — base URI·페이지네이션
- [[Connect REST API 개요]] — 상위 개요
