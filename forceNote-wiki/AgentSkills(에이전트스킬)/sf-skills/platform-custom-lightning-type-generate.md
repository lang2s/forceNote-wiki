---
tags: [agent-skill, sf-skills, platform, metadata, lightning-type, agentforce, json-schema]
source: forcedotcom/sf-skills (skills/platform-custom-lightning-type-generate/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [platform-custom-lightning-type-generate, 커스텀 라이트닝 타입 생성, CustomLightningType, CLT, lightning__objectType, widget rendition]
---

# platform-custom-lightning-type-generate — 커스텀 Lightning Type(CLT) 생성

> Einstein Agent action용 구조화 입출력 스키마인 Custom Lightning Type(JSON Schema 기반)을 생성한다. CLT 메타스키마의 엄격한 검증 규칙 준수가 핵심.

## 목적과 활성화 조건

`metadata.version: 1.0`

**TRIGGER:** CLT, Custom Lightning Types, widget/mosaic/fragment rendition/renderer 포함 CLT, agent용 JSON schema, type definition, `lightning__objectType`, editor/renderer 구성. widget rendition 요청 시 반드시 먼저 `references/widget-rendition.md`를 읽고 전체 workflow를 따른다.

이 스킬이 다루는 작업: 구조화 입출력용 CLT 생성 · JSON Schema 기반 type definition 생성 · Einstein Agent action용 CLT 구성 · 커스텀 UI editor/renderer 설정 · widget/mosaic/fragment rendition CLT 생성.

## 워크플로 / 단계

### Configuration 선택
- **Referenced CLT 패턴(nested object):** 재사용 가능/별도 배포 nested type은 별도 CLT로 만들고 `"lightning:type": "c__<CLTName>"`로 참조. 이 문자열은 참조 type의 **`lightning:type` value/FQN/registered identifier** — JSON Schema `title`이 아님.
- **Standard Lightning types:** 구조가 단순하고 properties + primitive `lightning:type`로 표현 가능할 때.
- **Apex class types(`@apexClassType/...`):** 구조가 이미 서버 측에 존재하고 Apex class가 shape를 정의할 때.
- **editor/renderer config:** 커스텀 UI(커스텀 LWC input/output 컴포넌트)가 필요할 때만 포함, 아니면 생략.

### Critical Rules (먼저 읽을 것)
- **NEVER `"$schema"` 필드를 schema.json에 포함** — 유효한 JSON Schema 선언이어도 CLT validator가 거부.
- **Root object schema는 MUST 포함:** `"type": "object"` · `"title"` · `"lightning:type": "lightning__objectType"` · `"unevaluatedProperties": false`
- `"unevaluatedProperties"`는 메타스키마가 `false`로 강제 — `true` 설정 금지.
- root에 `"unevaluatedProperties": false` 설정 시 `"examples"` MUST NOT 포함.
- **Nested object(properties 안)는 `"lightning:type": "lightning__objectType"` 설정 금지** — `c__<CLTName>` 참조 가능.
- **List/array는 메타스키마가 매우 제한적:**
  - `items` 키워드는 default로 disallowed 취급.
  - **Root-level array:** `"lightning:type": "lightning__listType"` MUST · `"items"` MUST NOT · `"type": "array"` OPTIONAL
  - **Nested array(가장 흔한 실패):** `"type": "array"` MUST · `"lightning:type": "lightning__listType"` MUST NOT · `"items"` MUST NOT
- `"unevaluatedProperties": false`일 때 unknown 키워드는 검증 실패 — 키워드 제거를 strictness 완화보다 우선.
- **Apex class CLT는 minimal:** `title`, `description`(optional), `lightning:type`(`@apexClassType/...`)만. `type`/`properties`/`required`/`unevaluatedProperties` 추가 금지.

### Additional Metaschema Validations
org namespace validation(disallowed 위치에 org namespace 금지) · lightning type validation(internal namespace 참조 금지, 예 `sfdc_cms`) · object type validation(root `lightning:type`이 정확히 `lightning__objectType`).

### Generation Workflow
1. **CLT 접근 확정** — Apex 참조면 정확한 class 참조(`@apexClassType/namespace__ClassName$InnerClass`); standard primitive면 field·Lightning primitive type·required 목록.
2. **`schema.json` 작성** — `"$schema"` 미포함, root object 구조로 시작, valid primitive `lightning:type`로 properties 추가, nested object는 `c__<CLTName>` 참조(참조 CLT를 parent보다 먼저 배포), 진짜 nested object output이 필요하면 Apex 기반 CLT 선호, array는 strict list 규칙, 배포 전 `lightning:type` 철자 검증(예 `lightning__richTextType`, 오타 변형 아님).
3. **(Optional) `editor.json`** — top-level `editor` object에 `editor.componentOverrides`·`editor.layout`. `propertyRenderers`/`view`는 DEPRECATED. root override `editor.componentOverrides["$"]`, `{!$attrs.<name>}`로 schema 값 바인딩(`<name>`은 schema에 정의된 property여야 함). property-level은 `es_property_editors/inputText` 등(`inputList` 금지). `lightning/propertyLayout`은 `property` attribute만 허용(label/title 추가 시 `additionalProperties: false` 오류).
4. **(Optional) `renderer.json`** — `renderer.componentOverrides`·`renderer.layout`. property-level은 `es_property_editors/outputText/outputNumber/outputImage` 등 output-style. **Widget renderer(mosaic/widget/fragment/cross-platform):** `renderer.componentOverrides["$"] = { "type": "mosaic", "definition": "tile/mosaic", "children": [...] }` — STOP, 직접 만들지 말고 MANDATORY 먼저 `references/widget-rendition.md` 가져와 전체 workflow(discoverUiComponents → getUiComponentSchemas → UEM tree → renderer.json) 수행.
5. **번들 구조 배치:**
   - `lightningTypes/<TypeName>/schema.json`
   - (Optional) `lightningTypes/<TypeName>/lightningDesktopGenAi/editor.json`
   - (Optional) `lightningTypes/<TypeName>/lightningDesktopGenAi/renderer.json`
   - Gen AI/Copilot 표준 경로는 `lightningDesktopGenAi/`; 다른 타깃은 `experienceBuilder/`/`lightningMobileGenAi/`/`enhancedWebChat/`.
6. **커스텀 LWC 컴포넌트 target 구성** — editor 컴포넌트는 `<target>lightning__AgentforceInput</target>`, renderer 컴포넌트는 `<target>lightning__AgentforceOutput</target>` 필수.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<LightningComponentBundle xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>60.0</apiVersion>
    <isExposed>true</isExposed>
    <targets>
        <target>lightning__AgentforceOutput</target>
    </targets>
</LightningComponentBundle>
```
> target 누락 시: `Invalid target configuration. To use 'c/componentName' as a renderer/editor, your js-meta.xml file must include valid target 'lightning__AgentforceOutput/Input'.`

## 핵심 규칙·가드레일

### Common Deployment Errors (발췌)
| Error | 원인 | Fix |
|---|---|---|
| unknown 키워드 검증 실패 | `unevaluatedProperties: false` + disallowed 키워드(`examples`, `items`) | 키워드 제거, schema minimal |
| nested object 검증 실패 | `LightningTypeBundle`이 nested object typing 거부 | CLT 참조(`c__<CLTName>`) 또는 Apex class type |
| Invalid CLT reference | 참조 CLT 미존재/잘못된 syntax | 참조 CLT 먼저 배포; `c__<CLTName>`는 FQN/registered identifier와 일치(title 아님) |
| 오타난 `lightning:type` | 잘못된 type 이름 | 지원 type 이름과 대조 |
| array property 거부 | `items` 사용 또는 nested array의 `lightning:type` | nested array는 `type:"array"`만, root array는 `items` 제거 |
| Apex CLT 거부 | 추가 필드(`type`/`properties`) | `title`/optional `description`/`lightning:type`만 |
| layout attribute `additionalProperties` 오류 | `lightning/propertyLayout`에 `label` 등 추가 | `property` attribute만 |
| Invalid target | 커스텀 LWC `-meta.xml` target 누락 | editor=`lightning__AgentforceInput`, renderer=`lightning__AgentforceOutput` |
| deprecated key | `propertyRenderers`/`view` 사용 | `componentOverrides`/`layout`로 교체 |

## 번들 파일

- `assets/primitive-types-and-constraints.md` — 지원되는 primitive `lightning:type` identifier 전체 목록, 제약, property-level 허용 키워드. full primitive list가 필요할 때 읽음.
- `references/widget-rendition.md` — widget(mosaic) rendition 전체 생성 workflow. widget renderer 작성 시 MANDATORY 선행 참조.

## 관련 노트
- [[platform-metadata-api-context-get]]
- [[platform-metadata-deploy]]
- [[platform-custom-field-generate]]
