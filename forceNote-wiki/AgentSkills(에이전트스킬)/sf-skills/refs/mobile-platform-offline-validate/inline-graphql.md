---
tags: [agent-skill, sf-skills, reference, mobile, offline, lwc, graphql, wire, komaci]
source: forcedotcom/sf-skills (skills/mobile-platform-offline-validate/references/inline-graphql.md, 공식 Salesforce)
created: 2026-06-27
aliases: [Inline GraphQL Wire Configuration, 인라인 GraphQL, wire getter 추출, GraphQL 오프라인 priming]
---

# Inline GraphQL Wire Configuration — 인라인 GraphQL 와이어 설정

> Komaci 오프라인 분석을 위해 `@wire` 어댑터 설정의 인라인 GraphQL 쿼리/변수를 컴포넌트 getter로 추출해야 하는 규칙과 검토 절차.

## Framework for the analysis

The Komaci offline static analysis engine requires GraphQL queries to be **extracted from `@wire` adapter configurations into separate getter methods** for proper offline data priming. Inline GraphQL query strings within `@wire` adapter calls prevent the static analysis engine from understanding and optimizing data dependencies for offline scenarios.

**FOCUS:** Only report improper usage of GraphQL queries and variables accessed outside of a component getter function. Do not provide feedback on any other adapter use.

Key points to consider:

- GraphQL queries and variables MUST be accessed from a getter function within the component class.
- GraphQL queries MUST NOT be inlined in the wire adapter configuration object.
- GraphQL variables MUST NOT be inlined in the wire adapter configuration object.
- GraphQL queries MUST NOT be defined as top-level constants.
- GraphQL variables MUST NOT be defined as top-level constants.
- If the query is already in a getter function, do not provide feedback.
- If the component does not use GraphQL, does not import GraphQL, does not use `@wire`, or does not contain a query in a `gql` template literal, do not provide feedback or analyze further.

## Request

Review the JavaScript files for `@wire` decorators with inline GraphQL queries:

1. Identify `@wire` decorators that use GraphQL wire adapters.
2. Look for literal GraphQL query strings within the wire configuration objects.
3. Check for template literals or string literals containing GraphQL syntax.
4. Analyze the complexity and reusability of the inline queries.
5. Determine appropriate getter method names for extracted queries.
6. Validate that extraction will not break existing functionality.
7. Report each violation with specific refactoring guidance.

For each violation, provide a strong suggested action that names a concrete getter — e.g. _"The query MUST be extracted into a getter function called `fooQuery` and accessed by the config `@wire(graphql, { query: '$fooQuery' })`."_

```js
// 구조 예시 — 실제 동작 코드 아님 (suggested action 형태 예시)
// ❌ Inline query in wire config (blocks Komaci priming)
@wire(graphql, { query: gql`query { ... }` })
data;

// ✅ Query extracted into a getter, referenced reactively
get fooQuery() {
  return gql`query { ... }`;
}
@wire(graphql, { query: '$fooQuery' })
data;
```

Rules to follow:

- If no action is required, return an empty list. Do not return null or any other value — return an empty array.
- Keep issues concise; avoid duplicated issues or unnecessary analysis for things that are not real violations.
- Stick to the instructions for the specific reviewer in scope. Issues outside that scope will be analyzed by other reviewers.
- For each violation, provide:
  - The exact violation type as defined by the reviewer in scope.
  - A description of why it is a problem in the context of mobile offline priming.
  - An intent analysis explaining what the developer likely intended.
  - A suggested action with concrete code-level remediation.
- Do not make assumptions about other components that may be referenced.

## 관련 노트
- [[mobile-platform-offline-validate]]
- [[grounding]]
- [[komaci-eslint]]
