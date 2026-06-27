---
tags: [agent-skill, sf-skills, experience, ui-bundle, graphql, data-sdk]
source: forcedotcom/sf-skills (skills/experience-ui-bundle-salesforce-data-access/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [experience-ui-bundle-salesforce-data-access, UI Bundle 데이터 접근, sdk-data graphql, uiapi GraphQL query mutation, @optional FLS, graphql-search.sh, React UI bundle Salesforce 레코드]
---

# experience-ui-bundle-salesforce-data-access — UI Bundle Salesforce 데이터 접근 (Data SDK·GraphQL·REST)

> React UI bundle에서 Salesforce 레코드를 읽기·생성·수정·삭제할 때 쓰는 스킬. 모든 데이터 접근은 `@salesforce/sdk-data` SDK를 통하며 레코드 작업은 `uiapi` GraphQL이 preferred, GraphQL로 안 되는 경우만 허용된 REST endpoint를 쓴다.

## 목적과 활성화 조건

**활성화(MUST):** 프로젝트에 `uiBundles/*/src/` 디렉터리가 있고 **어떤** Salesforce 레코드 작업(read/create/update/delete)이든 할 때. Salesforce에 submit하는 form, 레코드 표시 페이지, Salesforce 표준/커스텀 객체를 건드리는 코드. `uiBundles/*/src/` 아래 파일이 `@salesforce/sdk-data`를 import하거나, `*.graphql`·`codegen.yml`이 존재할 때 활성화. 이 스킬이 UI bundle의 모든 Salesforce 데이터 접근 패턴을 소유한다.

**사용 안 함:** 인증/OAuth 설정, schema 변경, Bulk/Tooling/Metadata API, 선언적 자동화.

## Data SDK 요구사항

> **모든 Salesforce 데이터 접근은 Data SDK(`@salesforce/sdk-data`)를 반드시 사용한다.** SDK가 인증·CSRF·base URL resolution을 처리한다.

```typescript
import { createDataSDK, gql } from "@salesforce/sdk-data";
import type { ResponseTypeQuery } from "../graphql-operations-types";

const sdk = await createDataSDK();

// GraphQL for record queries/mutations (PREFERRED)
const response = await sdk.graphql?.<ResponseTypeQuery>(query, variables);

// REST for Connect REST, Apex REST, UI API (when GraphQL insufficient)
const res = await sdk.fetch?.("/services/apexrest/my-resource");
```

**항상 optional chaining 사용** (`sdk.graphql?.()`, `sdk.fetch?.()`) — 일부 surface에서 undefined일 수 있다.

## Preconditions — 시작 전 검증

| # | 요건 | 검증 방법 | 누락 시 |
|---|------|-----------|---------|
| 1 | `@salesforce/sdk-data` 설치됨 | UI bundle dir의 `package.json` 확인 | 진행 불가 — 설치 요청 |
| 2 | 프로젝트 root에 `schema.graphql` | 파일 존재 확인 | UI bundle dir에서 `npm run graphql:schema` |
| 3 | 커스텀 객체/필드 배포됨 | `graphql-search.sh <Entity>` 실행 — 출력 없으면 미배포 | 메타데이터 배포 + permission set 할당 요청 |

**precondition 미충족 시**, 컴포넌트·route·layout·UI 로직은 스캐폴드해도 되지만 데이터는 빈 배열/`null`을 쓰고 query 위치를 `// TODO: add query after schema verification`로 표시한 뒤 plan에 후속 작업을 포함한다. schema 워크플로 완료 전 GraphQL query 문자열을 작성하지 않는다.

## Supported APIs

**다음 API만 허용된다.** 목록에 없는 endpoint는 사용 금지.

| API | Method | Endpoints / Use Case |
|-----|--------|----------------------|
| GraphQL | `sdk.graphql` | 모든 레코드 query/mutation, `uiapi { }` namespace |
| UI API REST | `sdk.fetch` | `/services/data/v{ver}/ui-api/records/{id}` — GraphQL로 부족할 때 레코드 메타데이터 |
| Apex REST | `sdk.fetch` | `/services/apexrest/{resource}` — 커스텀 server-side 로직, aggregate, multi-step transaction |
| Connect REST | `sdk.fetch` | `/services/data/v{ver}/connect/file/upload/config` — file upload config |
| Einstein LLM | `sdk.fetch` | `/services/data/v{ver}/einstein/llm/prompt/generations` — AI 텍스트 생성 |

**미지원:**
- **Enterprise REST query endpoint** (`/services/data/v*/query` with SOQL) — proxy 레벨에서 차단. 레코드 read는 GraphQL, server-side SOQL aggregate가 필요하면 Apex REST.
- **Aura-enabled Apex** (`@AuraEnabled`) — React UI bundle에서 호출 경로 없음(LWC/Aura 패턴).
- **Chatter API** (`/chatter/users/me`) — 대신 GraphQL `uiapi { currentUser { ... } }`.
- 위 표에 없는 **다른 모든 Salesforce REST endpoint**.

### Decision: GraphQL vs REST

| Need | Method | Example |
|------|--------|---------|
| 레코드 query/mutate | `sdk.graphql` | Account, Contact, 커스텀 객체 |
| 현재 user 정보 | `sdk.graphql` | `uiapi { currentUser { Id Name { value } } }` |
| UI API 레코드 메타데이터 | `sdk.fetch` | `/ui-api/records/{id}` |
| Connect REST | `sdk.fetch` | `/connect/file/upload/config` |
| Apex REST | `sdk.fetch` | `/services/apexrest/auth/login` |
| Einstein LLM | `sdk.fetch` | `/einstein/llm/prompt/generations` |

레코드 작업은 **GraphQL이 preferred**. GraphQL이 커버 못 하는 경우만 REST.

## GraphQL Non-Negotiable Rules

Salesforce GraphQL은 표준 GraphQL과 다른 플랫폼 특유 동작이 있다. 위반 시 silent runtime 실패.

1. **HTTP 200 ≠ 성공** — Salesforce는 작업 실패에도 HTTP 200을 반환. **항상 response body의 `errors` 배열을 파싱한다.**
2. **Schema가 single source of truth** — 모든 entity/field/type 이름은 사용 전 schema 검색 스크립트로 확인. 추측 금지 — 필드명 case-sensitive, 관계는 polymorphic일 수 있고, 커스텀 객체는 suffix(`__c`, `__e`) 사용. v60+에서 UI API에 추가된 객체는 `_Record` suffix 가능(예: `FeedItem` 대신 `FeedItem_Record`).
3. **read query의 모든 레코드 필드에 `@optional`** — FLS로 인해 한 필드라도 접근 권한이 없으면 query 전체가 실패한다. `@optional` directive(v65+)는 접근 불가 필드를 실패 대신 omit하라고 서버에 지시. 모든 scalar field, parent relationship, child relationship에 적용. 소비 코드는 optional chaining(`?.`)·nullish coalescing(`??`) 사용.
4. **올바른 mutation 문법** — Mutation은 bare `uiapi { ... }`가 아니라 `uiapi(input: { allOrNone: true/false })` 아래에 wrap. `allOrNone`은 항상 명시. output field에 child relationship·navigated reference field 포함 불가.
5. **명시적 pagination** — 모든 query에 `first:` 포함. 생략 시 서버가 silent하게 10 레코드로 default. pagination 가능성 있는 query는 `pageInfo { hasNextPage endCursor }` 포함. forward-only(`first`/`after`) — `last`/`before` 미지원.
6. **SOQL 파생 실행 한도** — 요청당 최대 10 subquery, child-to-parent traversal 최대 5 레벨, parent-to-child 최대 1 레벨(grandchild 없음), subquery당 최대 2,000 레코드. 초과 시 여러 요청으로 분할.
7. **요청한 필드만** — 사용자가 명시적으로 요청한 필드만 생성. 추가 필드 금지.
8. **Compound 필드** — 필터/정렬 시 constituent 필드(`BillingCity`, `BillingCountry`) 사용, compound wrapper(`BillingAddress`) 금지. compound wrapper는 selection 전용.

## GraphQL Workflow

| Step | Action | Key output |
|------|--------|------------|
| 1 | schema 획득 | `schema.graphql` 존재 |
| 2 | entity lookup | field 이름·type·관계 확인 |
| 3 | query 생성 | `.graphql` 파일 또는 inline `gql` tag |
| 4 | type 생성 | `graphql-operations-types.ts` |
| 5 | validate | lint + codegen pass |

### Step 1: Acquire Schema

`schema.graphql`(265K+ 줄)이 source of truth. **직접 열거나 파싱 금지** — cat/less/head/tail/editor/programmatic parser 모두 금지. precondition 1–3 검증 후 Step 2로.

### Step 2: Look Up Entity Schema

사용자 의도를 PascalCase 이름으로 매핑("accounts" → `Account`)한 뒤 **`sfdx-project` 폴더(프로젝트 root)에서 검색 스크립트 실행**:

```bash
bash scripts/graphql-search.sh Account
# 여러 entity:
bash scripts/graphql-search.sh Account Contact Opportunity
```

스크립트는 entity당 7개 섹션 출력:
1. **Type definition** — 모든 queryable field·관계
2. **Filter options** — `where:` 조건용 field
3. **Sort options** — `orderBy:`용 field
4. **Create mutation wrapper** — `<Entity>CreateInput`
5. **Create mutation fields** — `<Entity>CreateRepresentation` (create mutation이 받는 field)
6. **Update mutation wrapper** — `<Entity>UpdateInput`
7. **Update mutation fields** — `<Entity>UpdateRepresentation` (update mutation이 받는 field)

**스크립트 최대 2회 실행.** 그래도 못 찾으면 사용자에게 질문 — 객체가 미배포일 수 있음.

#### Entity 식별

후보가 안 맞으면: 커스텀 객체는 `__c`, 플랫폼 이벤트는 `__e` suffix 시도; v60+ 객체는 `<EntityName>_Record` suffix 시도; 그래도 안 되면 **사용자에게 질문** — 추측 금지.

#### Iterative Introspection (최대 3 cycle)

1. **Introspect** — 미해결 entity마다 스크립트 실행
2. **Fields** — type definition에서 요청 field 이름·type 추출
3. **References** — reference field 식별. polymorphic(다중 type)이면 inline fragment 사용. 새로 발견된 entity type을 작업 목록에 추가.
4. **Child relationships** — Connection type 식별, child entity type을 작업 목록에 추가.
5. 미해결 entity 남으면 **반복** (최대 3 cycle)

**Hard stop:** entity에 데이터 없으면 중단(미배포 가능성). 3 cycle 후에도 unknown entity 남으면 사용자에게 질문. 미확인 entity/field로 query 생성 금지.

### Step 3: Generate Query

모든 field 이름은 Step 2 스크립트 출력에서 검증 필수.

#### Read Query Template

```graphql
query QueryName($after: String) {
  uiapi {
    query {
      EntityName(
        first: 10
        after: $after
        where: { ... }
        orderBy: { ... }
      ) {
        edges {
          node {
            Id
            FieldName @optional { value }
            # Parent relationship (non-polymorphic)
            Owner @optional { Name { value } }
            # Parent relationship (polymorphic — use fragments)
            What @optional {
              ...WhatAccount
              ...WhatOpportunity
            }
            # Child relationship — max 1 level, no grandchildren
            Contacts @optional(first: 10) {
              edges { node { Name @optional { value } } }
            }
          }
        }
        pageInfo { hasNextPage endCursor }
      }
    }
  }
}

fragment WhatAccount on Account {
  Id
  Name @optional { value }
}
fragment WhatOpportunity on Opportunity {
  Id
  Name @optional { value }
}
```

소비 코드는 missing field를 방어:

```typescript
const name = node.Name?.value ?? "";
const relatedName = node.Owner?.Name?.value ?? "N/A";
```

#### Filtering

```graphql
# Implicit AND
Account(where: { Industry: { eq: "Technology" }, AnnualRevenue: { gt: 1000000 } })

# Explicit OR
Account(where: { OR: [{ Industry: { eq: "Technology" } }, { Industry: { eq: "Finance" } }] })

# NOT
Account(where: { NOT: { Industry: { eq: "Technology" } } })

# Date literal
Opportunity(where: { CloseDate: { eq: { value: "2024-12-31" } } })

# Relative date
Opportunity(where: { CloseDate: { gte: { literal: TODAY } } })

# Relationship filter (nested objects, NOT dot notation)
Contact(where: { Account: { Name: { like: "Acme%" } } })

# Polymorphic relationship filter
Account(where: { Owner: { User: { Username: { like: "admin%" } } } })
```

String equality(`eq`)는 case-insensitive. 15자·18자 레코드 ID 모두 허용.

#### Ordering

```graphql
Account(
  first: 10,
  orderBy: { Name: { order: ASC }, CreatedDate: { order: DESC } }
) { ... }
```

정렬 미지원: multi-select picklist, rich text, long text area, encrypted field. deterministic 정렬을 위해 `Id`를 tie-breaker로 추가.

#### UpperBound Pagination (v59+)

페이지당 >200 레코드 또는 총 >4,000 레코드면 `upperBound` 사용. set 시 `first`는 200–2000.

```graphql
Account(first: 2000, after: $cursor, upperBound: 10000) {
  edges { node { Id Name @optional { value } } }
  pageInfo { hasNextPage endCursor }
}
```

#### Semi-Join / Anti-Join

parent의 `Id`에 `inq`(semi-join) 또는 `ninq`(anti-join)로 child entity 조건으로 parent 필터. child 존재만이 조건이면 `Id: { ne: null }`.

```graphql
query SemiJoinExample {
  uiapi {
    query {
      Account(where: {
        Id: {
          inq: {
            Contact: { LastName: { like: "Smith%" } }
            ApiName: "AccountId"
          }
        }
      }, first: 10) {
        edges { node { Id Name @optional { value } } }
      }
    }
  }
}
```

anti-join은 `inq`를 `ninq`로 교체. 제약: subquery에 `OR` 없음, subquery에 `orderBy` 없음, join 간 중첩 없음.

#### Current User

표준 query 대신 `uiapi.currentUser`(인자 없음):

```graphql
query CurrentUser {
  uiapi { currentUser { Id Name { value } } }
}
```

#### Field Value Wrappers

schema field는 typed wrapper 사용 — `.value`로 접근:

| Wrapper Type | Underlying | Wrapper Type | Underlying |
|---|---|---|---|
| `StringValue` | `String` | `BooleanValue` | `Boolean` |
| `IntValue` | `Int` | `DoubleValue` | `Double` |
| `CurrencyValue` | `Currency` | `PercentValue` | `Percent` |
| `DateTimeValue` | `DateTime` | `DateValue` | `Date` |
| `PicklistValue` | `Picklist` | `LongValue` | `Long` |
| `IDValue` | `ID` | `TextAreaValue` | `TextArea` |
| `EmailValue` | `Email` | `PhoneNumberValue` | `PhoneNumber` |
| `UrlValue` | `Url` | | |

모든 wrapper는 `displayValue: String`(서버 렌더링, `toLabel()`/`format()`)도 노출 — UI 표시는 client-side 포매팅 대신 이걸 사용.

#### Mutation Template

Mutation은 API v66+에서 GA. 3개 operation: **Create**, **Update**, **Delete**.

```graphql
# Create
mutation CreateAccount($input: AccountCreateInput!) {
  uiapi(input: { allOrNone: true }) {
    AccountCreate(input: $input) {
      Record { Id Name { value } }
    }
  }
}

# Update — must include Id
mutation UpdateAccount {
  uiapi(input: { allOrNone: true }) {
    AccountUpdate(input: { Id: "001xx000003GYkZAAW", Account: { Name: "New Name" } }) {
      Record { Id Name { value } }
    }
  }
}
```

**Input 제약:**
- **Create:** 필수 field(단 `defaultedOnCreate` 제외), `createable` field만, child relationship 없음. reference field는 `ApiName`으로 set(예: `AccountId`).
- **Update:** `Id` 포함 필수, `updateable` field만, child relationship 없음.
- **Delete:** `Id`만.
- **`IdOrRef` type:** Update/Delete input의 `Id` field는 `IdOrRef` type으로, literal 레코드 ID(`"001xx..."`) 또는 mutation chaining reference(`"@{Alias}"`)를 받음. Create input의 reference field(예: `AccountId`)도 chaining용 `@{Alias}` 허용.
- **Raw value:** 콤마·통화기호·locale 포매팅 없음(예: `"$80,000"` 아니라 `80000`).

**Output 제약:**
- Create/Update: child relationship 제외, navigated reference field 제외(`ApiName` member만 허용). output field 이름은 항상 `Record`.
- Delete: `Id`만.

**`allOrNone` semantics:**
- `true`(default) — 전부 성공 또는 전부 rollback.
- `false` — 독립 operation은 개별 성공, 단 의존 operation(`@{alias}` 사용)은 함께 rollback.

#### Mutation Chaining

이전 mutation의 `Id`를 `@{alias}` reference로 참조해 관련 mutation을 chain. parent-child 생성에 필수(nested child create 미지원).

```graphql
mutation CreateAccountAndContact {
  uiapi(input: { allOrNone: true }) {
    AccountCreate(input: { Account: { Name: "Acme" } }) {
      Record { Id }
    }
    ContactCreate(input: { Contact: { LastName: "Smith", AccountId: "@{AccountCreate}" } }) {
      Record { Id }
    }
  }
}
```

규칙: `A`가 query에서 `B`보다 먼저 와야 함. `@{A}`는 항상 mutation `A`의 `Id`. `Create` 또는 `Delete`에서만 chain 가능(`Update` 불가).

#### Delete Mutation

Delete는 generic `RecordDeleteInput` 사용(entity별 아님). output은 `Id`만 — `Record` field 없음.

```graphql
mutation DeleteAccount($id: ID!) {
  uiapi(input: { allOrNone: true }) {
    AccountDelete(input: { Id: $id }) {
      Id
    }
  }
}
```

#### Object Metadata & Picklist Values

`uiapi { objectInfos(...) }`로 field 메타데이터/picklist 값 조회. `apiNames` **또는** `objectInfoInputs` 중 하나만 전달 — 둘 다 금지.

```typescript
// Object metadata
const GET_OBJECT_INFO = gql`
  query GetObjectInfo($apiNames: [String!]!) {
    uiapi {
      objectInfos(apiNames: $apiNames) {
        ApiName
        label
        labelPlural
        fields { ApiName label dataType updateable createable }
      }
    }
  }
`;

// Picklist values (use objectInfoInputs + inline fragment)
const GET_PICKLIST_VALUES = gql`
  query GetPicklistValues($objectInfoInputs: [ObjectInfoInput!]!) {
    uiapi {
      objectInfos(objectInfoInputs: $objectInfoInputs) {
        ApiName
        fields {
          ApiName
          ... on PicklistField {
            picklistValuesByRecordTypeIDs {
              recordTypeID
              picklistValues { label value }
            }
          }
        }
      }
    }
  }
`;
```

### Step 4: Generate Types (codegen)

query 작성 후(`. graphql` 파일이든 inline `gql`이든) TypeScript type 생성:

```bash
# Run from UI bundle dir
npm run graphql:codegen
```

Output: `src/api/graphql-operations-types.ts`

생성 type 네이밍: `<OperationName>Query`/`<OperationName>Mutation`(response type), `<OperationName>QueryVariables`/`<OperationName>MutationVariables`(variable type).

**항상 생성된 type을 import해서 사용** (`sdk.graphql` 호출 시):

```typescript
import type { GetAccountsQuery, GetAccountsQueryVariables } from "../graphql-operations-types";

const response = await sdk.graphql?.<GetAccountsQuery, GetAccountsQueryVariables>(GET_ACCOUNTS, variables);
```

`NodeOfConnection<T>`로 Connection에서 node type 추출(더 깔끔한 타이핑):

```typescript
import { type NodeOfConnection } from "@salesforce/sdk-data";

type AccountNode = NodeOfConnection<GetAccountsQuery["uiapi"]["query"]["Account"]>;
```

### Step 5: Validate & Test

1. **Lint:** UI bundle dir에서 `npx eslint <file>`
2. **codegen:** UI bundle dir에서 `npm run graphql:codegen`

#### Common Error patterns

| Error Contains | Resolution |
|----------------|------------|
| `Cannot query field` / `ValidationError` | field 이름 틀림 — `graphql-search.sh <Entity>` 재실행 |
| `Unknown type` | type 이름 틀림 — 스크립트로 PascalCase entity 이름 확인 |
| `Unknown argument` | argument 틀림 — 스크립트 출력의 Filter/OrderBy 섹션 확인 |
| `invalid syntax` / `InvalidSyntax` | error message대로 syntax 수정 |
| `VariableTypeMismatch` / `UnknownType` | schema에서 argument type 정정 |
| `invalid cross reference id` | entity 삭제됨 — 유효 Id 요청 |
| `OperationNotSupported` | 객체 가용성·API 버전 확인 |
| `is not currently available in mutation results` | mutation output에서 field 제거 |
| `Cannot invoke JsonElement.isJsonObject()` | update mutation `Record` selection은 API v64+ 사용 |

**PARTIAL 시:** mutation이 data와 errors를 함께 반환(partial success)하면: 접근 불가 field를 보고, mutation output에 넣을 수 없음을 설명, 제거 제안. **변경 전 사용자 동의 대기.**

## UI Bundle Integration (React)

두 통합 패턴:

### Pattern 1 — External `.graphql` 파일 (복잡한 query)

**파일당 operation 하나.** 각 파일은 정확히 하나의 `query` 또는 `mutation`(+ fragment) 포함. 한 파일에 여러 operation 결합 금지.

```typescript
import { createDataSDK, type NodeOfConnection } from "@salesforce/sdk-data";
import MY_QUERY from "./query/myQuery.graphql?raw"; // ?raw suffix required
import type { GetMyDataQuery, GetMyDataQueryVariables } from "../graphql-operations-types";

const sdk = await createDataSDK();
const response = await sdk.graphql?.<GetMyDataQuery, GetMyDataQueryVariables>(MY_QUERY, variables);
```

`.graphql` 파일 생성/변경 후 `npm run graphql:codegen`으로 `src/api/graphql-operations-types.ts`에 type 생성.

### Pattern 2 — Inline `gql` tag (간단한 query)

**반드시 `gql` 사용** — plain template string은 ESLint schema 검증을 우회한다.

```typescript
import { createDataSDK, gql } from "@salesforce/sdk-data";
import type { GetAccountsQuery } from "../graphql-operations-types";

const GET_ACCOUNTS = gql`
  query GetAccounts {
    uiapi {
      query {
        Account(first: 10) {
          edges { node { Id Name @optional { value } } }
        }
      }
    }
  }
`;

const sdk = await createDataSDK();
const response = await sdk.graphql?.<GetAccountsQuery>(GET_ACCOUNTS);
```

### Error Handling

```typescript
// Strict (default) — any errors = failure
if (response?.errors?.length) {
  throw new Error(response.errors.map(e => e.message).join("; "));
}

// Tolerant — log errors, use available data
if (response?.errors?.length) {
  console.warn("GraphQL partial errors:", response.errors);
}

// Discriminated — fail only when no data returned
if (!response?.data && response?.errors?.length) {
  throw new Error(response.errors.map(e => e.message).join("; "));
}

const accounts = response?.data?.uiapi?.query?.Account?.edges?.map(e => e.node) ?? [];
```

## REST API Patterns

GraphQL이 부족할 때 `sdk.fetch` 사용. 전체 allowlist는 Supported APIs 표 참조.

```typescript
declare const __SF_API_VERSION__: string;
const API_VERSION = typeof __SF_API_VERSION__ !== "undefined" ? __SF_API_VERSION__ : "65.0";

// Connect — file upload config
const res = await sdk.fetch?.(`/services/data/v${API_VERSION}/connect/file/upload/config`);

// Apex REST (no version in path)
const res = await sdk.fetch?.("/services/apexrest/auth/login", {
  method: "POST",
  body: JSON.stringify({ email, password }),
  headers: { "Content-Type": "application/json" },
});

// UI API — record with metadata (prefer GraphQL for simple reads)
const res = await sdk.fetch?.(`/services/data/v${API_VERSION}/ui-api/records/${recordId}`);

// Einstein LLM
const res = await sdk.fetch?.(`/services/data/v${API_VERSION}/einstein/llm/prompt/generations`, {
  method: "POST",
  body: JSON.stringify({ promptTextorId: prompt }),
});
```

**Current user:** Chatter(`/chatter/users/me`) 사용 금지. 대신 GraphQL:

```typescript
const GET_CURRENT_USER = gql`
  query CurrentUser {
    uiapi { currentUser { Id Name { value } } }
  }
`;
const response = await sdk.graphql?.(GET_CURRENT_USER);
```

## Directory Structure

```
<project-root>/                              ← SFDX project root
├── schema.graphql                           ← grep target (lives here)
├── sfdx-project.json
├── scripts/graphql-search.sh                ← schema lookup script
└── force-app/main/default/uiBundles/<app-name>/  ← UI bundle dir
    ├── package.json                         ← npm scripts
    └── src/
```

| Command | Run From | Why |
|---------|----------|-----|
| `npm run graphql:schema` | UI bundle dir | UI bundle package.json의 스크립트 |
| `npm run graphql:codegen` | UI bundle dir | GraphQL type 생성 |
| `npx eslint <file>` | UI bundle dir | eslint.config.js 읽음 |
| `bash scripts/graphql-search.sh <Entity>` | project root | schema lookup |

## 핵심 규칙·가드레일

- 모든 데이터 접근은 `@salesforce/sdk-data`. `sdk.graphql?.()`·`sdk.fetch?.()` optional chaining 필수.
- 레코드 작업은 GraphQL `uiapi`가 preferred. Supported APIs 표 밖의 endpoint 사용 금지(SOQL query endpoint·@AuraEnabled·Chatter 금지).
- HTTP 200 ≠ 성공 → `errors` 배열 항상 파싱. schema가 single source of truth → field는 `graphql-search.sh`로 검증, 추측 금지.
- read query 모든 필드에 `@optional`(FLS). mutation은 `uiapi(input: { allOrNone: ... })` wrap + `allOrNone` 명시.
- 모든 query에 `first:`(생략 시 silent 10). 한도: subquery 10, child→parent 5레벨, parent→child 1레벨, subquery당 2,000 레코드.
- 요청한 필드만 생성. 생성 type 항상 import 사용. 완료 전 `npx eslint` + `npm run graphql:codegen`.

## 번들 파일

| 파일 | 내용 |
|------|------|
| `scripts/graphql-search.sh` | `schema.graphql`에서 entity별 7개 섹션(type/filter/sort/create·update wrapper·representation) 조회. 프로젝트 root에서 실행, `-s`/`--schema`로 커스텀 schema 경로 지정 가능 |

## 관련 노트
- [[experience-ui-bundle-frontend-generate]]
- [[experience-ui-bundle-metadata-generate]]
- [[experience-ui-bundle-file-upload-generate]]
- [[experience-lwc-generate]]
