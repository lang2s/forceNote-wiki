---
tags: [index, search, navigation, connect-rest-api]
created: 2026-07-03
---

# SEARCH INDEX — Connect REST API (Chatter/협업 REST)
> Connect REST API(구 Chatter REST API) — 모바일·인트라넷·서드파티 웹앱을 Salesforce 협업(피드·그룹·사용자·댓글·토픽)과 통합하는 REST API. 응답이 지역화·프레젠테이션용으로 구조화·필터링된다. Apex `ConnectApi` 네임스페이스(Connect in Apex)의 HTTP 짝. (출처: Connect REST API Developer Guide v67.0 Summer '26)
> 루트 라우터: `00 SEARCH_INDEX.md` · 다른 샤드는 라우터에서 이동.
>
> ℹ️ 코드(Apex)로 같은 기능을 호출하는 Connect in Apex(`ConnectApi`)는 `_index/apex-namespaces.md` 샤드. 이 샤드는 HTTP REST 엔드포인트 측.

---

## Foundation — 개요·규약

| 키워드 | 파일 |
|---|---|
| Connect REST API, Chatter REST API, 커넥트 REST API, 채터 REST API, Connect in Apex 관계, base URI, OAuth, rate limit, bearer token, API 개요, Connect REST API가 뭐야, 언제 쓰나, 인증 방법, Limits | `Integration(통합)/ConnectREST(커넥트REST)/Connect REST API 개요.md` |
| resource URL, HTTP 메서드, filterGroup, exclude include 필터, status codes, multipart 업로드, 와일드카드, 요청 응답 규약, 상태 코드, 요청 조립 방법, 응답 필터링 방법 | `Integration(통합)/ConnectREST(커넥트REST)/Connect REST API 요청·응답 규약.md` |

## Resources — 협업 리소스

| 키워드 | 파일 |
|---|---|
| feed elements, 피드 요소, feed-elements, capabilities, message segment, feed item input, 피드 게시, 좋아요 댓글 투표 REST, capability, 피드 요소 POST 검색, 피드에 글 어떻게 올려, 45개 capability | `Integration(통합)/ConnectREST(커넥트REST)/Feed Elements Resources.md` |
| feeds, 피드, feed type, 피드 타입, news feed, record feed, feed directory, groups feed, topics feed, 23 feed type, 뉴스 피드, 레코드 피드, 그룹 피드, 토픽 피드, 피드 종류 뭐가 있어, feed-elements 파라미터 | `Integration(통합)/ConnectREST(커넥트REST)/Feeds Resources.md` |
