---
tags: [integration, connect-rest-api, managed-topics, experience-cloud, site-navigation]
source: salesforce_chatter_rest_api.pdf (Connect REST API Developer Guide, Version 67.0 Summer '26; PDF p472–480; Tier 1/2)
created: 2026-07-04
aliases: [Managed Topics, 관리형 토픽, Experience Cloud Topics, Navigational Topic, Featured Topic, Content Topic, 사이트 내비게이션 토픽, topic hierarchy]
---

# Managed Topics Resources — Experience Cloud

> Experience Cloud 사이트의 managed topic — 내비게이션 메뉴·홈페이지 featured·content 토픽 계층을 조회·생성·삭제·재정렬하는 EC 전용 리소스.

---

## 개요

Managed topic은 **Experience Cloud site 전용** 개념이다. 일반 플랫폼 토픽(standard topic)을 사이트의 내비게이션 구조·featured 노출·content 연관에 매핑한다. 목록 조회, 계층(hierarchy) 생성, 개별 생성·삭제·재정렬을 지원한다.

- **Base URI:** `/connect/communities/{communityId}/managed-topics` — 다른 Connect REST 리소스와 달리 반드시 `communities/{communityId}` 하위로 접근한다. base URI 규약은 [[Connect REST API 요청·응답 규약]] 참조.
- ⚠️ **권한:** 생성·재정렬·삭제는 **community manager**만 수행할 수 있다 — **Create and Set Up Experiences** 또는 **Manage Experiences** 권한 필요.
- managed topic이 참조하는 standard topic 자체의 CRUD·병합·레코드 할당은 [[Topics Resources - 일반·레코드]] 소관이다.

### managedTopicType 3종

| 값 | 정의 |
|---|---|
| `Content` | native content와 연관된 토픽. |
| `Featured` | 예: 홈페이지에 노출되는 토픽. **내비게이션은 제공하지 않는다.** |
| `Navigational` | 사이트 내비게이션 메뉴에 표시되는 토픽. |

> 한 토픽이 3종 유형을 **동시에** 가질 수 있다 (예: 같은 토픽이 Featured이면서 Navigational).

---

## 엔드포인트

| # | URI (`/connect/communities/{communityId}/`) | 메서드 | v | 응답 |
|---|---|---|---|---|
| C1 Managed Topics | `managed-topics` | GET / POST / PATCH / HEAD | 32.0 | GET·PATCH → Managed Topic Collection, POST → Managed Topic |
| C2 Managed Topic | `managed-topics/{managedTopicId}` | GET / DELETE / HEAD | 32.0 | GET → Managed Topic, DELETE → 204 |

> 응답 스키마(Managed Topic, Managed Topic Collection)의 전체 필드는 Reference 챕터에 위임한다 — 이 노트에는 요청 파라미터·Input·한도만 정리한다.

---

## C1 — Managed Topics (`managed-topics`)

### GET — 목록 조회

**Usage 규칙:**
- 파라미터 없이 호출하면 **featured·navigational 토픽만** 반환한다.
- content 토픽을 얻으려면 `?managedTopicType=Content`.
- 전체 계층을 얻으려면 `?depth=8&managedTopicType=Navigational`.

**파라미터:**

| 파라미터 | 타입 | v | 설명 |
|---|---|---|---|
| `depth` | Integer, Opt (1–8, 기본 1) | 35.0 | 1 = children `null`, 2 = 직계 children, 3–8 = children의 children까지. |
| `managedTopicType` | String | 32.0 | enum 3종(Content·Featured·Navigational). `recordIds`·`depth`·Content 조회 시 **필수**. |
| `page` | Integer, Opt (0부터) | 44.0 | depth 2–8이면 top-level만 페이징. |
| `pageSize` | Integer (1–100, 기본 50) | 44.0 | |
| `recordId` | String | 35.0–37.0 | **v38.0+에서는 `recordIds`로 대체됨.** |
| `recordIds` | List\<String\>, Opt (최대 100) | 38.0 | 10개 초과 지정 시 depth 2–8 불가. |

### POST — 생성

body root `<managedTopic>`:

| 프로퍼티 | 타입 | v | 설명 |
|---|---|---|---|
| `managedTopicType` | String, Req | 32.0 | 생성할 유형. **아래 한도 적용.** |
| `name` | String | 32.0 | 신규 토픽 생성 시 필수. `name`·`recordId` **택 1.** |
| `parentId` | String, Opt | 35.0 | 지정 시 유형은 Navigational. 최대 8레벨, children 최대 10. |
| `recordId` | String | 32.0 | 기존 토픽 사용 시 필수(`name` 미사용). **topic ID여야 한다.** child는 Navigational + `parentId` 조합. |

**한도 (managedTopicType별):**

| 유형 | 한도 |
|---|---|
| Featured | 최대 **25**개 |
| Content | 최대 **5,000**개 |
| Navigational | 최대 **8레벨** / top-level **25**개 / 레벨당 children **10**개 / 총 **2,775**개 |

### PATCH — 재정렬

> **Content 토픽은 재정렬할 수 없다.** Featured·Navigational만 재정렬 대상.

body root `<managedTopicPositionCollection>`:

| 프로퍼티 | 타입 | v | 설명 |
|---|---|---|---|
| `managedTopicPositions` | Managed Topic Position Input[], Req | 32.0 | Featured·Navigational 포함 가능. 일부만 포함하면 포함된 것은 지정 position으로, 미포함은 다음 position으로 밀린다. |

**재정렬 동작 예:** 초기 A=0, B=1, C=2, D=3, E=4 상태에서 `D=0`, `E=2`만 포함해 PATCH하면 → **D=0, A=1, E=2, B=3, C=4** (지정된 D·E는 그 position에 놓이고, 미포함 A·B·C는 남은 자리로 밀림).

---

## C2 — Managed Topic (`managed-topics/{managedTopicId}`)

### GET — 개별 조회

| 파라미터 | 타입 | v | 설명 |
|---|---|---|---|
| `depth` | Integer, Opt (1–8, 기본 1) | 35.0 | C1 GET의 depth와 동일 의미. |

### DELETE — 삭제

- 응답 **204 No Content**.
- 삭제 역시 **community manager**(Create and Set Up Experiences / Manage Experiences)만 가능.

---

## 코드 예제

아래는 덤프의 실제 요청 body 예시다 (예시 ID 값은 형식 표시용 축약).

**POST — 기존 토픽을 Navigational child로 추가 (recordId 사용):**

```json
// POST /connect/communities/{communityId}/managed-topics
{
  "managedTopicType": "Navigational",
  "parentId": "0mtR...",
  "recordId": "0TOD..."
}
```

**POST — 신규 토픽을 Navigational child로 생성 (name 사용):**

```json
// POST /connect/communities/{communityId}/managed-topics
{
  "name": "Child Topic",
  "managedTopicType": "Navigational",
  "parentId": "0mtR..."
}
```

**PATCH — 재정렬 (position 지정, D=0·E=2만 포함):**

```json
// PATCH /connect/communities/{communityId}/managed-topics
{
  "managedTopicPositions": [
    { "managedTopicId": "0mtD...", "position": "0" },
    { "managedTopicId": "0mtD...", "position": "2" }
  ]
}
```

---

## enum / Input 요약

- **managedTopicType enum:** `Content` · `Featured` · `Navigational`
- **Input 타입:** Managed Topic Position Input (전체 필드는 Reference 챕터 위임)

---

## 관련 노트
- [[Topics Resources - 일반·레코드]] — 플랫폼 일반 토픽(managed topic이 참조하는 standard topic)의 CRUD·병합·레코드 할당.
- [[Connect REST API 요청·응답 규약]] — base URI 규약.
- [[Connect REST API 개요]] — Connect REST API 상위 개요.
