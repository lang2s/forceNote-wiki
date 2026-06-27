---
tags: [agent-skill, sf-skills, reference, platform, lightning-types]
source: forcedotcom/sf-skills (skills/platform-custom-lightning-type-generate/assets/primitive-types-and-constraints.md, 공식 Salesforce)
created: 2026-06-27
aliases: [Primitive Types and Constraints, Lightning 기본 타입과 제약, lightning__textType, lightning:type]
---
# Primitive Types & Constraints — Lightning 기본 타입과 제약

> Custom Lightning Type(CLT) 속성에 사용 가능한 모든 Lightning primitive 타입과 각 타입에 허용되는 제약(키워드)의 레퍼런스.

---

Reference for all supported Lightning primitive types and their allowed constraints. Read this when authoring property-level `lightning:type` identifiers or determining which keywords are valid on a given property.

A property in a CLT schema combines a primitive `lightning:type` with the keywords allowed for that type:

```json
// 구조 예시 — 속성 정의 형태 (실제 동작 설정 아님)
{
  "amount": {
    "title": "Amount",
    "lightning:type": "lightning__numberType",
    "minimum": 0,
    "maximum": 1000000,
    "multipleOf": 0.01
  }
}
```

## Supported Types

- `lightning__textType`
  - Max length 255
- `lightning__multilineTextType`
  - Max length 2000
- `lightning__richTextType`
  - Max length 100000
- `lightning__urlType`
  - Max length 2000
  - Optional `lightning:allowedUrlSchemes` enum values: `https`, `http`, `relative`, `mailto`, `tel`
- `lightning__dateType`
  - Data pattern: YYYY-MM-DD
- `lightning__timeType`
  - Data pattern: HH:MM:SS.sssZ
- `lightning__dateTimeType`
  - Data shape is an object with required `dateTime` and optional `timeZone`
- `lightning__numberType`
  - Decimal numbers; optional `maximum`, `minimum`, `multipleOf`
- `lightning__integerType`
  - Whole numbers only; optional `maximum`, `minimum`
- `lightning__booleanType`
  - true/false

## Allowed Property-Level Keywords

When strict validation is enabled (`unevaluatedProperties: false`), keep each property minimal and prefer only keywords known to be allowed:

- `title`, `description`, `einstein:description`
- `type` (when used, ensure it matches the chosen `lightning:type`)
- `lightning:type`
- `maximum`, `minimum`, `multipleOf` (numeric)
- `maxLength`, `minLength` (string)
- `const`, `enum`
- `lightning:textIndexed`, `lightning:supportsPersonalization`, `lightning:localizable`
- `lightning:uiOptions`, `lightning:allowedUrlSchemes`
- `lightning:tags` (metaschema restricts values; currently `flow` is the only known allowed tag)

## 관련 노트
- [[platform-custom-lightning-type-generate]]
- [[widget-rendition]]
