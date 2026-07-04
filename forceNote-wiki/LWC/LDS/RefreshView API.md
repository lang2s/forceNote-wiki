---
tags: [lwc, lds, refresh, refreshview, data, lightning-refresh]
source: developer.salesforce.com (Lightning Web Components Developer Guide — Work with Salesforce Data > Refresh Component Data with RefreshView API; 라이브 공식 문서, Tier 2, 접속 2026-07-04)
official_doc: https://developer.salesforce.com/docs/platform/lwc/guide/data-refreshview.html
created: 2026-07-04
aliases: [RefreshView API, lightning/refresh, RefreshViewEvent, view refresh, 데이터 새로고침, refreshApex, refreshGraphQL, notifyRecordUpdateAvailable, 컴포넌트 데이터 갱신]
---

# RefreshView API

> `lightning/refresh` 모듈로 전체 페이지 리로드 없이 컴포넌트 계층(view)의 데이터를 동기화한다 — refresh scope를 세밀하게 제어해 정제된 UX와 최소 서버 부하를 동시에 얻는다.

---

## 개요

RefreshView API는 `lightning/refresh` 모듈로 제공되며, **전체 페이지를 리로드하지 않고** 데이터를 동기화한다. 새로고침은 사용자가 유발(user-driven)하거나 앱이 호출(app-invoked)할 수 있다.

- **갱신 단위는 view = 컴포넌트 계층(component hierarchy)이다.** 페이지 전체가 아니라 지정된 컴포넌트 계층만 리로드 없이 갱신하므로, refresh scope를 세밀하게 제어해 정제된 UX와 서버 부하 최소화를 함께 달성한다.
- Salesforce **플랫폼 컨테이너**에 더해, **커스텀 LWC 및 Aura 컴포넌트**의 데이터 refresh를 지원한다.

## 동작

- **Lightning Data Service(LDS)가 RefreshView API를 지원한다.** 단, ⚠️ **RefreshView API 자체가 데이터를 다시 가져오지는 않으며, 커스텀 컴포넌트가 실제 refresh를 직접 개시(initiate)해야 한다.** 개시 수단:
  - `refreshApex()` (from `@salesforce/apex`) — Apex wire로 프로비저닝된 데이터를 새로고침.
  - `refreshGraphQL()` — GraphQL wire로 프로비저닝된 데이터를 새로고침.
  - (세부는 Salesforce의 Data Guidelines 참조.)
- **Lightning Web Security(LWS) 또는 Lightning Locker가 활성화된 org에서 동작한다.** 컨테이너 등록 프로토콜은 활성 보안 아키텍처에 따라 다르다.
- ⚠️ **Aura용 base component는 현재 RefreshView API를 지원하지 않는다.**
- 컴포넌트가 wire service를 사용하는 경우: record 데이터는 `@wire(getRecord)` + `notifyRecordUpdateAvailable`로 업데이트한다. LDS가 `@wire` 데이터를 fresh하게 유지한다.

## 코드 예시

RefreshView API는 `lightning/refresh` 모듈에서 `RefreshViewEvent`를 import해 사용하며, 실제 데이터 재조회는 커스텀 컴포넌트가 `refreshApex()` / `refreshGraphQL()`로 개시한다.

```js
// 구조 예시 — 실제 동작 코드 아님 (덤프 근거 개념만; 이벤트 dispatch/핸들링 세부는 위임 페이지 참조)
import { RefreshViewEvent } from 'lightning/refresh';
import { refreshApex } from '@salesforce/apex';
// import { refreshGraphQL } from 'lightning/graphql';  // GraphQL wire 데이터용

// 커스텀 컴포넌트가 refresh를 "직접 개시" — RefreshView API가 데이터를 다시 가져오지 않음
async function handleRefresh(wiredResult) {
    // Apex wire 데이터 새로고침
    await refreshApex(wiredResult);
    // GraphQL wire 데이터라면: await refreshGraphQL(graphqlResult);
}
```

> `RefreshViewEvent` / `RefreshViewId` 등 이벤트 메커니즘의 정확한 dispatch·핸들링 규약은 공식 문서의 *RefreshView API User Experience* 및 *Considerations for Using RefreshView API* 페이지(각 `data-refreshview-*`)에 있다. 본 노트는 개시(initiate) 개념까지만 다루고 이벤트 세부는 그 페이지에 위임한다(추측 재현하지 않음).

## 관련 노트
- [[@salesforce Modules 레퍼런스]] — `refreshApex`·`notifyRecordUpdateAvailable`
- [[GraphQL Wire Adapter]] — `refreshGraphQL`(GraphQL wire 데이터 refresh)
- [[getRecord 패턴]] — `@wire(getRecord)` + `notifyRecordUpdateAvailable`로 record 데이터 최신화
- [[UI API 개요]] — LDS 데이터 소스
- [[Wire 패턴]] — wire service 데이터 프로비저닝
- [[Lightning Web Security vs Lightning Locker]] — RefreshView가 동작하는 보안 아키텍처
- [[LWC MOC]]
