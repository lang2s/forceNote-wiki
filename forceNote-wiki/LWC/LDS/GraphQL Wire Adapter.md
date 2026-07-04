---
tags: [lwc, lds, graphql, wire-adapter, data, lightning-graphql]
source: developer.salesforce.com (Lightning Web Components Developer Guide — lightning/graphql Wire Adapter (v2) · graphql; 라이브 공식 문서, Tier 2, 접속 2026-07-04)
official_doc: https://developer.salesforce.com/docs/platform/lwc/guide/reference-graphql-wire.html
created: 2026-07-04
aliases: [GraphQL wire, lightning/graphql, gql, graphql wire adapter, GraphQL API LWC, variables getter, errors 프로퍼티, uiGraphQLApi, GraphQL 쿼리 LWC, 그래프QL]
---

# GraphQL Wire Adapter

> `lightning/graphql`의 `graphql` wire adapter로 GraphQL API를 통해 데이터를 fetch한다 — client-side caching·데이터 관리 내장, Lightning Data Service(LDS) 기반.

---

## 개요

`lightning/graphql` **Wire Adapter (v2)**는 Salesforce GraphQL API로 데이터를 조회하는 LWC wire adapter다. **client-side caching과 데이터 관리**가 내장돼 있다.

- ⚠️ **v2가 v1(`lightning/uiGraphQLApi`)을 대체(supersede)한다.** 가능하면 v2를 쓴다.
- ⚠️ `lightning/graphql`(v2)은 **Mobile Offline을 지원하지 않는다.** 오프라인이 필요하면 v1 `lightning/uiGraphQLApi`를 사용한다.
- wire adapter는 **Lightning Data Service(LDS) 위에 구축**돼 있어 별도 캐싱을 구현할 필요가 없다.
- Salesforce **GraphQL API schema**를 사용한다 — UI API가 활성화된 오브젝트, 그리고 **GraphQL Cursor Connections Specification(Relay)**을 따른다. 스키마 탐색은 introspection(예: Altair GraphQL client)으로 한다.

> uiGraphQLApi를 포함한 GraphQL 모듈 카탈로그는 [[LWC API Modules 레퍼런스]] 참조.

## import

`gql`(쿼리 파싱 함수)과 `graphql`(wire adapter)을 함께 import한다.

```js
import { gql, graphql } from 'lightning/graphql';
```

## @wire config 프로퍼티

| 프로퍼티 | 필수 | 설명 |
|---|---|---|
| `query` | Required | 파싱된 GraphQL 쿼리. JavaScript template literal 함수 **`gql`**로 파싱한다. |
| `variables` | | 쿼리용 동적 값의 key-value 쌍. ⚠️ **getter 함수와 함께 사용해야 wire adapter가 reactive**해진다. 값은 쿼리의 **모든 변수**에 대한 값을 담은 map이어야 한다. |
| `operationName` | | 수행할 operation 이름. 쿼리에 operation이 여러 개일 때 선택한다(예: `query bigAccounts`, `query serviceReports`). |

## 반환 (wire 프로퍼티)

| 프로퍼티 | 설명 |
|---|---|
| `data` | GraphQL API response. |
| `errors` | GraphQL API errors. ⚠️ GraphQL response 스펙과 호환하기 위해 **다른 LWC wire와 달리 `error`가 아니라 `errors`를 사용한다.** |
| `refresh` | promise를 반환한다. resolve되면 wire 데이터가 fresh해진다. 이 메서드는 `async`로 저장한다(Update Cached Query Results). |

## 사용·reactivity

`gql` identifier를 import하고 프로퍼티에 config를 제공한다. HTML 템플릿에서는 예를 들어 쿼리가 반환한 첫 10개 account name을 표시할 수 있다.

**reactivity 만들기:**

- `variables` 파라미터에 값을 전달하고, 그 반환값용 **getter를 생성**한다.
- 이 getter가 변수(예: `minAmount`) 변경에 따라 wire adapter를 reactive하게 만든다.
- 변수 타입은 `$minAmount`처럼 선언하고, 타입(예: `Currency`)은 GraphQL schema의 타입을 참조한다. Currency는 raw value(예: `1000`)를 받고 `displayValue`는 `"1,000"`처럼 포맷된다. 값 변경은 예를 들어 `handleMinAmountChange` 핸들러로 처리한다.

⚠️ 많은 Salesforce 필드가 **raw value와 `{ value, displayValue, format }` 객체 둘 다**로 매핑된다 — 이 객체를 사용하는 것이 권장된다.

> 샘플: lwc-recipes에서 `graphql`로 시작하는 컴포넌트(예: `graphqlContacts`)를 참고.

### 코드 예시

```js
// 구조 예시 — 실제 동작 코드 아님 (공식 문서의 문법 기반 재구성)
import { LightningElement, wire } from 'lwc';
import { gql, graphql } from 'lightning/graphql';

export default class GraphqlAccounts extends LightningElement {
    minAmount = 1000;

    // variables는 getter로 감싸야 wire가 reactive
    get variables() {
        return {
            minAmount: this.minAmount
        };
    }

    @wire(graphql, {
        query: gql`
            query bigAccounts($minAmount: Currency) {
                uiapi {
                    query {
                        Account(
                            first: 10
                            where: { AnnualRevenue: { gt: { value: $minAmount } } }
                        ) {
                            edges {
                                node {
                                    Id
                                    Name { value }
                                    AnnualRevenue { value displayValue }
                                }
                            }
                        }
                    }
                }
            }
        `,
        variables: '$variables'
    })
    graphqlResult;

    // 다른 wire와 달리 error가 아니라 errors
    get accounts() {
        return this.graphqlResult.data?.uiapi?.query?.Account?.edges ?? [];
    }
    get errors() {
        return this.graphqlResult.errors;
    }

    handleMinAmountChange(event) {
        this.minAmount = event.target.value;
    }
}
```

## Known Issues / 제약

- ⚠️ Salesforce 모바일 앱·Field Service·Mobile에서 GraphQL 쿼리 **prefetch가 실패**하면 "Unknown Field" 경고가 발생한다(Known Issue).
- ⚠️ **커스텀 오브젝트·커스텀 필드의 fragment 사용은 제약**이 있다 — referential integrity를 유지하기 위해 fragment를 제거·치환하는 것이 권장된다.
- ⚠️ 일부 필드는 **`where` filter로 필터할 수 없다** — Object Reference의 Properties에서 필터 지원 여부를 확인한다.

## 관련 노트

- [[LWC API Modules 레퍼런스]] — `lightning/graphql`·`uiGraphQLApi` 모듈 카탈로그
- [[UI API 개요]] — GraphQL API가 사용하는 UI API 스키마 기반 데이터 계층
- [[getRecord 패턴]] — LDS 단건 레코드 wire (대비: 그래프 쿼리 vs 단건 wire)
- [[Wire 패턴]] — `@wire` 일반 사용 패턴
- [[@salesforce Modules 레퍼런스]] — LWC 모듈 레퍼런스
- [[RefreshView API]] — `refreshGraphQL`로 GraphQL wire 데이터 refresh 개시(refresh 짝)
- [[GraphQL 뮤테이션 (executeMutation) — Create·Update·Delete]] — 이 wire(조회)의 쓰기 짝. `executeMutation`으로 Apex 없이 CRUD 완성
- [[LWC MOC]]
