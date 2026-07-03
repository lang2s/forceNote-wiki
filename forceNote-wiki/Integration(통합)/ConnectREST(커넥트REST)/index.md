---
tags: [index, integration, connect-rest-api]
created: 2026-07-03
---

# ConnectREST(커넥트REST) — 로컬 인덱스

> Connect REST API(Chatter/협업 REST) 노트 클러스터 — 피드·그룹·사용자·댓글·토픽 등 협업 리소스의 HTTP 엔드포인트. Apex `ConnectApi`(Connect in Apex)의 HTTP 짝. **Phase 1 완료**: Foundation 2노트(개요·요청/응답 규약) + Resources 8노트(Feed Elements·Feeds·Comments/Likes/Mentions·Groups·Users 3분할·User Profiles/Subscriptions/Followers·Topics/Announcements/Q&A)로 Connect REST API 협업 코어 클러스터를 이룬다. (출처: Connect REST API Developer Guide v67.0 Summer '26)

**상위:** [[통합 MOC]] → [[00 Home]] · 키워드 검색은 `_index/connect-rest.md`

---

## 파일 목록

### Foundation

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Connect REST API 개요]] | Connect REST API 용도·아키텍처·인증(OAuth)·Limits·Quick Start·Connect in Apex 관계 | #overview |
| [[Connect REST API 요청·응답 규약]] | resource URL·HTTP 메서드·필터(filterGroup·exclude/include)·상태 코드·multipart 업로드 | #convention |

### Resources

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Feed Elements Resources]] | 피드 요소 POST·검색·capability(45)·Message Segment·Feed Item Input | #resource |
| [[Feeds Resources]] | 23개 feed type(news·record·groups·topics 등)·feed-elements 파라미터 | #resource |
| [[Comments · Likes · Mentions Resources]] | 댓글(조회·편집·verified·status·투표)·좋아요·멘션(자동완성·검증) REST | #resource |
| [[Groups Resources]] | Chatter 그룹 CRUD·멤버·멤버십 요청·사진·배너·공지·레코드·초대 REST(17 리소스) | #resource |
| [[Users Resources - 프로필·대화·메시지·팔로우]] | 사용자 정보·프로필·비공개 대화/메시지·팔로우·그룹·설정 REST(17 리소스) | #resource |
| [[Users Resources - Recommendations·Reputation]] | Chatter 추천 6종(channel·people also viewed·static 등)·평판(action·objectCategory·idPrefix) | #resource |
| [[User Profiles · Subscriptions · Followers on Records Resources]] | 사용자 프로필·사진/배너·구독(언팔)·레코드 팔로워 REST(5 리소스) | #resource |
| [[Topics · Announcements · Q&A Resources]] | 토픽 endorsement·knowledgeable people·opt-out·공지(announcements)·Q&A 제안 REST(10 리소스) | #resource |
| [[Files & Folders Resources]] | 네이티브 Salesforce Files 파일·폴더·공유·미리보기·렌디션 REST(21 엔드포인트) | #resource |
| [[Files Connect Repository Resources]] | 외부 저장소(SharePoint·Google Drive·OneDrive) 파일·권한 REST(14+3) | #resource |
| [[Notifications Resources]] | in-app/push 알림·알림 설정 REST(10 엔드포인트) | #resource |

---

## 빠른 선택

- Connect REST API가 뭐고 언제 쓰는지, 인증·한도부터? → [[Connect REST API 개요]]
- 요청 URL·메서드·필터·상태 코드 등 wire-level 규약? → [[Connect REST API 요청·응답 규약]]
- 피드에 글 올리기·좋아요/댓글 등 피드 요소 조작(capability)? → [[Feed Elements Resources]]
- 어떤 피드 타입(news·record·groups·topics 등)이 있고 어떻게 조회? → [[Feeds Resources]]

---

## 관련 폴더

- 통합 패턴 전반 → [[통합 MOC]]
- Apex에서 HTTP callout 없이 같은 기능 호출(Connect in Apex) → `Apex/Integration(통합)/index`
