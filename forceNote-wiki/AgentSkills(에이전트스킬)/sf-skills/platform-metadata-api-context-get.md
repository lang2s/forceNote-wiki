---
tags: [agent-skill, sf-skills, platform, metadata, metadata-api, reference]
source: forcedotcom/sf-skills (skills/platform-metadata-api-context-get/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [platform-metadata-api-context-get, 메타데이터 API 참조, Metadata API, 604 metadata types, section-specific consumption, wsdl_segment]
---

# platform-metadata-api-context-get — Metadata API 타입 참조 컨텍스트

> 604개 Salesforce Metadata API 타입 전체에 대한 문서를 제공한다. `*-meta.xml` 파일을 작성·이해·수정할 때 사용. JSON 파일을 통째로 읽지 않고 section-specific 소비가 핵심.

## 목적과 활성화 조건

`metadata.version: 1.0` · `minApiVersion: 67.0` · CLI tools: `jq >=1.6`, `python3 >=3.8`

**TRIGGER:** 모든 `*-meta.xml` 파일 작성/편집, metadata type의 field/format 질문, 'Salesforce metadata'/'sfdx project' 언급. 604개 metadata type(CustomObject, Flow, ApexClass, Profile, PermissionSet, Layout, ValidationRule, RecordType, EmailTemplate, ...).

**DO NOT TRIGGER:** SOQL/DML/runtime sObject access(→Enterprise API), Tooling API developer record(ApexExecutionOverlayAction, TraceFlag), 비-XML 로직(Apex code, LWC JS, Visualforce controller).

각 metadata type에 대해 제공: field 정의·data type · required vs optional · WSDL schema · sample XML · 파일 네이밍 · SFDX 디렉터리 위치.

## 워크플로 / 단계

### CRITICAL — Section-Specific Consumption
`data/metadata_api/*.json` 파일은 항상 `jq` 또는 프로그래밍 JSON 파싱으로 필요한 섹션만 추출. `Read`/`cat`/`read_file`로 통째 로드 금지 — verbose WSDL 등으로 토큰 60-80% 낭비. (작은 파일인 SKILL.md·index table을 `Read`로 읽는 것은 OK.)

대부분 use case는 1-2 섹션만 필요:
- field 정의 → `fields` 섹션만
- 목적 이해 → `description` 섹션만
- XML 예시 → `declarative_metadata_sample_definition` 섹션만
- default skip → `wsdl_segment`(verbose), `file_information`, `directory_location`

### JSON File Structure
```json
{
  "sections": ["title", "description", "fields", "wsdl_segment", "..."],
  "title": "MetadataTypeName - Metadata API",
  "description": "Plain-text description.",
  "fields": {
    "fieldName": { "type": "string", "description": "...", "required": true }
  },
  "file_information": ".object",
  "directory_location": "objects",
  "wsdl_segment": "<xsd:complexType>...</xsd:complexType>",
  "declarative_metadata_sample_definition": [
    { "description": "...", "code": "<?xml version=\"1.0\"?>..." }
  ]
}
```
string value(title/description/file_information/directory_location/wsdl_segment)는 plain text(markdown header·code fence 없음). `file_information`은 파일 suffix만(예 `.object`), `directory_location`은 SFDX 폴더명만(예 `objects`).

### Available Sections
`title` · `description` · `fields`(type 자체 field) · `sub_types`(composite type만, 참조 sub-type → 그 field) · `file_information` · `directory_location` · `wsdl_segment`(WSDL XML schema) · `declarative_metadata_sample_definition`(예시 XML).

### Section-Specific Loading 예시 (jq)
```bash
# fields 섹션만
jq '.fields' data/metadata_api/CustomObject.json

# field type 이름 확인 후 매칭 complexType만 추출 (sub-type 드릴인)
jq '.fields.objectPermissions' data/metadata_api/Profile.json
jq -r '.wsdl_segment' data/metadata_api/Profile.json | grep -A 30 'complexType name="ProfileObjectPermissions"'
```
`fields`가 `Foo[]` 타입을 반환하면 sub-field는 `fields`가 아닌 `wsdl_segment`에 있음 — `grep -A N` 윈도우로 ~150토큰만 사용.

**Token Impact:** section-specific 50-200토큰 vs 전체 파일 500-2000토큰(60-80% 절감). `read_file data/metadata_api/*.json`은 ~15MB 로드 — 절대 금지.

작업 코드 예시(전체): `examples/python_section_loading.py` · `examples/javascript_section_loading.js` · `examples/bash_section_loading.sh`.

## 핵심 규칙·가드레일

### XML Generation Requirements
모든 metadata 파일: XML 선언(`<?xml version="1.0" encoding="UTF-8"?>`) · 정확한 namespace `http://soap.sforce.com/2006/04/metadata` · root element가 type과 일치(CustomObject→`<CustomObject>` 등).
```xml
<?xml version="1.0" encoding="UTF-8"?>
<CustomObject xmlns="http://soap.sforce.com/2006/04/metadata">
```
잘못된 namespace(`http://salesforce.com/metadata`) 또는 namespace 누락은 오류.

### Required vs Optional (중요)
- **Schema-required**(JSON `required: true`): WSDL이 required로 표시.
- **Effectively required**: WSDL은 실제 authoring 계약보다 적은 field를 required로 표시. CustomObject가 대표 예 — JSON은 `externalDataSource`/`externalName`/`nameField`만 required로 표시하지만(앞 둘은 external-object 전용 quirk), 일반 `__c` CustomObject는 `label`/`pluralLabel`/`deploymentStatus`/`sharingModel`도 필요. 항상 `declarative_metadata_sample_definition` 예시와 cross-check.
- **Conditionally required**: 특정 feature 활성화 시에만.
- **Optional**: 대부분.

### Duplicate/Ambiguous Type Names
일부 Metadata API type 이름은 Enterprise/Data API나 Tooling API object로도 존재(ApexClass, ApexTrigger, CustomField, CustomObject, EmailTemplate, Layout, Profile, PermissionSet, RecordType, StaticResource, WebLink, ValidationRule, Flow). 모호하면 묻는다: 1) Metadata API XML authoring(이 스킬) 2) Enterprise/Data API runtime sObject 3) Tooling API record.
- **Heuristics:** `package.xml`/`force-app/`/`sfdx`/`.meta.xml`/"deploy"/"retrieve"/"permissions"(배포 의미) → Metadata API. "what fields on X"/"DML"/"SOQL"/"REST"/"sObject"/"runtime" → Enterprise/Data·Tooling. "Tooling API"/`ApexCodeCoverage`/`EntityDefinition`/`TraceFlag`/"code coverage"/`SymbolTable` → Tooling.
- **Default-when-no-signals:** signal 없고 이 스킬이 이름으로 직접 invoke되면 Metadata API로 default하고 가정을 명시 disclose.

### Troubleshooting
- **File Not Found:** 파일명은 case-sensitive PascalCase, separator 없음(`CustomObject.json`). 선언 전 `references/metadata_index_table.md` 참조 — two-pass recovery: 1) normalize-and-substring(case/separator 변형) 2) miss 시 fuzzy-match(`difflib.get_close_matches(..., cutoff=0.7)` 또는 Levenshtein ≤2). multi-hit tiebreaker는 normalized length 일치 우선, 아니면 최단 match.
- **SOAP Envelope/Header types(thin by design):** result type(`AsyncResult`/`SaveResult` 등 — `fields` 비고 `wsdl_segment` 채워짐, SOAP response wrapper, 배포 불가) / SOAP request header(`SessionHeader`/`CallOptions` 등 — `fields` 1-2개, `wsdl_segment` 없음, call-time option). thin JSON이 정상 — `.AsyncResult-meta.xml` authoring 금지.
- **Sub-Type pointer(`ProfileObjectPermissions[]` 등):** sub-field는 `fields`가 아닌 `wsdl_segment`에 — 위 jq+grep 패턴으로 드릴인.

### Validation Tips
배포 전: well-formed XML · required field 존재 · namespace 정확 · field 값 type 일치 · `sf project deploy validate`로 오류 catch.

## 번들 파일

> ⚠️ 이 스킬의 번들은 **612개 파일**(주로 metadata type별 JSON). 전부 나열하지 않고 카테고리+개수로 요약한다.

- **`data/metadata_api/*.json` — 604개 파일**: 각 Salesforce Metadata API type 1개당 JSON 1개(CustomObject.json, Flow.json, ApexClass.json, Profile.json, ...). 각 파일은 위 JSON 구조의 섹션을 담음. **section-specific(jq) 소비 필수, whole-file Read 금지.**
- **`references/` (2개)**: `metadata_index_table.md`(전체 type 목록·source of truth, file-not-found recovery 시 참조) · `usage_guide.md`(token 최적화 배경, worked example, 공통 workflow, section glossary, versioning/support).
- **`examples/` (4개)**: `README.md` · `python_section_loading.py` · `javascript_section_loading.js` · `bash_section_loading.sh`(각 언어별 section 추출 작업 코드).
- **루트**: `README.md` · `SKILL.md`.

**Quick Reference — Common Metadata Types:** CustomObject · Flow · ApexClass · ApexTrigger · Profile · PermissionSet · CustomField · Layout · ValidationRule · ApexPage · ApexComponent · CustomTab · CustomApplication · LightningComponentBundle · AuraDefinitionBundle · StaticResource · EmailTemplate · Report · Dashboard.

## 관련 노트
- [[platform-custom-object-generate]]
- [[platform-custom-field-generate]]
- [[platform-metadata-deploy]]
- [[platform-custom-lightning-type-generate]]
- [[Metadata Types — 개요 및 분류]] — 메타데이터 타입 카탈로그·분류 위키 노트
- [[Metadata API 개요]] — Metadata API 전체 개념
