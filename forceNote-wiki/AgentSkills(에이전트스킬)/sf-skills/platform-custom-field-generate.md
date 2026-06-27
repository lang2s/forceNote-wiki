---
tags: [agent-skill, sf-skills, platform, metadata, custom-field, rollup-summary, master-detail]
source: forcedotcom/sf-skills (skills/platform-custom-field-generate/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [platform-custom-field-generate, 커스텀 필드 생성, CustomField, Roll-Up Summary, Master-Detail, Lookup, formula field]
---

# platform-custom-field-generate — 커스텀 필드 메타데이터 생성

> CustomField 메타데이터 XML을 생성·검증한다. 배포 실패율이 가장 높은 Roll-Up Summary와 Master-Detail 관계 제약에 집중.

## 목적과 활성화 조건

`metadata.version: 1.0`

**TRIGGER:** custom field, field type, Roll-up Summary, Master-Detail, Lookup, formula field, picklist, field metadata. field 배포 오류(특히 Roll-up Summary 포맷, M-D 제약, formula 이슈) 트러블슈팅.

이 스킬이 다루는 작업: 모든 객체에 custom field 생성 · 모든 type의 field metadata 생성 · relationship field(Lookup/Master-Detail) 설정 · formula·roll-up summary field 생성 · 배포 오류 트러블슈팅.

## 워크플로 / 단계

### Universal Mandatory Attributes (모든 field)

| Attribute | 요구 | 비고 |
|---|---|---|
| `<fullName>` | Required | `<label>`에서 파생: 각 단어 capitalize, 공백→`_`, `__c` 추가. letter로 시작. 예 `Total Contract Value` → `Total_Contract_Value__c` |
| `<label>` | Required | UI 이름(Title Case) |
| `<description>` | Mandatory | 필드의 비즈니스 "why" |
| `<inlineHelpText>` | Mandatory | 사용자용 actionable 안내. label 이상 가치(예 "Enter the value in USD including tax") |

**External ID:** "integration"/"importing data"/"external system ID"/"unique key from [System]" 언급 시 `<externalId>true</externalId>`. 적용 type: Text, Number, Email.

### Precision / Scale / Length
- `precision`=총 자릿수, `scale`=소수 자릿수. **규칙: `precision ≤ 18` AND `scale ≤ precision`**. 정수부 = `precision - scale`.
- **"Fixed 255" 규칙:** standard TextArea는 UI에서 설정 불가여도 Metadata API가 `<length>255</length>` 요구.
- **Visible Lines:** Long/Rich text·Multi-select picklist에 mandatory(UI 높이 제어).

### Field Data Types

**Simple Attribute Types**

| Type | `<type>` | Required Attributes |
|---|---|---|
| Auto Number | `AutoNumber` | `displayFormat`(`{0}` 포함), `startingNumber` |
| Checkbox | `Checkbox` | `defaultValue` 기본 `false` |
| Date | `Date` | precision/length 불필요 |
| Date/Time | `DateTime` | precision/length 불필요 |
| Email | `Email` | 내장 포맷 검증 |
| Lookup | `Lookup` | `referenceTo`, `relationshipName`, `deleteConstraint` |
| Master-Detail | `MasterDetail` | `referenceTo`, `relationshipName`, `relationshipOrder` |
| Number | `Number` | `precision`, `scale` |
| Currency | `Currency` | default precision 18, scale 2 |
| Percent | `Percent` | default precision 5, scale 2 |
| Phone | `Phone` | 전화번호 포맷 표준화 |
| Picklist | `Picklist` | `valueSet`(`valueSetDefinition`, `restricted`) |
| Text | `Text` | `length`(Max 255) |
| Text Area | `TextArea` | `<length>255</length>` |
| Text (Long) | `LongTextArea` | `length`, `visibleLines`(default 3) |
| Text (Rich) | `Html` | `length`, `visibleLines`(default 25) |
| Time | `Time` | 시간만 저장 |
| URL | `Url` | protocol·포맷 검증 |

**Computed & Multi-Value**

| Type | `<type>` | Required Attributes |
|---|---|---|
| Formula | result type(예 `Number`) | `formula`, `formulaTreatBlanksAs` |
| Roll-Up Summary | `Summary` | Section 6 참조 |
| Multi-Select Picklist | `MultiselectPicklist` | `valueSet`, `visibleLines`(default 4) |

**Specialized:** Geolocation → `Location` (`scale`, `displayLocationInDecimal`)

**Picklist `restricted`:** 미지정 → default `true`(restricted, 대규모 value set 성능 회피). 사용자가 custom/new value 허용/"unrestricted"/"open" → `false`. restricted picklist는 총 1,000 value(active+inactive) 제한.

### Master-Detail 규칙 ⭐ CRITICAL

**Master-Detail에 NEVER 포함:**

| Forbidden | 이유 |
|---|---|
| `<required>` | M-D는 설계상 항상 required |
| `<deleteConstraint>` | M-D는 항상 cascade delete |
| `<lookupFilter>` | Lookup field에서만 지원 |

**Master-Detail vs Lookup**

| Attribute | Master-Detail | Lookup |
|---|---|---|
| `<required>` | ❌ FORBIDDEN | ✅ Optional |
| `<deleteConstraint>` | ❌ FORBIDDEN(항상 CASCADE) | ✅ Required(`SetNull`/`Restrict`/`Cascade`) |
| `<lookupFilter>` | ❌ FORBIDDEN | ✅ Optional |
| `<relationshipOrder>` | ✅ Required(0/1) | ❌ N/A |
| `<reparentableMasterDetail>` | ✅ Optional | ❌ N/A |
| `<writeRequiresMasterRead>` | ✅ Optional | ❌ N/A |

```xml
<CustomField xmlns="http://soap.sforce.com/2006/04/metadata">
  <fullName>Account__c</fullName>
  <label>Account</label>
  <description>Links this record to its parent Account</description>
  <type>MasterDetail</type>
  <referenceTo>Account</referenceTo>
  <relationshipLabel>Child Records</relationshipLabel>
  <relationshipName>ChildRecords</relationshipName>
  <relationshipOrder>0</relationshipOrder>
  <reparentableMasterDetail>false</reparentableMasterDetail>
  <writeRequiresMasterRead>false</writeRequiresMasterRead>
  <!-- NO required, deleteConstraint, lookupFilter -->
</CustomField>
```

추가 규칙: 첫 M-D=`0`, 두번째=`1` · `relationshipName`은 plural PascalCase · junction은 M-D 2개로 표준 many-to-many(roll-up 가능) · 객체당 M-D 최대 2개.

### Roll-Up Summary 규칙 ⭐ CRITICAL (최고 배포 실패율)

**Required:** `<type>`=`Summary` · `<summaryOperation>`(`count`/`sum`/`min`/`max`) · `<summaryForeignKey>`(`ChildObject__c.MasterDetailField__c`) · `<summarizedField>`(sum/min/max만 — count는 NOT).

**Forbidden:** `<precision>`, `<scale>`(summarized field에서 상속) · `<required>` · `<length>`.

**포맷:** `summaryForeignKey`와 `summarizedField` 모두 완전 한정 `ChildObjectAPIName__c.FieldAPIName__c`.

```xml
<CustomField xmlns="http://soap.sforce.com/2006/04/metadata">
  <fullName>Total_Amount__c</fullName>
  <label>Total Amount</label>
  <description>Sum of all line item amounts</description>
  <inlineHelpText>Automatically calculated from child line items</inlineHelpText>
  <type>Summary</type>
  <summaryOperation>sum</summaryOperation>
  <summarizedField>Order_Line_Item__c.Amount__c</summarizedField>
  <summaryForeignKey>Order_Line_Item__c.Order__c</summaryForeignKey>
  <!-- NO precision, scale, required, length -->
</CustomField>
```
COUNT operation은 `<summarizedField>` 없음. min/max는 sum과 동일 구조에 operation만 변경.

| Operation | summarizedField 필요? |
|---|---|
| `count` | NO |
| `sum` / `min` / `max` | YES |

전제: Roll-Up Summary는 M-D의 **parent** 객체에만 생성 가능 · child가 이 parent로의 M-D 필드 보유 · summarized field가 child에 존재.

### Formula Field 규칙
- Formula는 type이 아님. `<formula>`를 result data type을 가진 field에 추가: `Checkbox`/`Currency`/`Date`/`DateTime`/`Number`/`Percent`/`Text`.
- `<formula>` 내용은 `<![CDATA[ ... ]]>`로 래핑(`&`, `<`, `>`를 markup으로 해석 방지). 리터럴 `]]>` 포함 시 CDATA 블록 분할로 escape.
- `returnType` 태그/attribute 절대 사용 금지(Metadata API에 없음). `<type>`이 return type 정의.
- **formulaTreatBlanksAs:** result가 `Number`/`Currency`/`Percent` → `BlankAsZero`; `Text`/`Date`/`DateTime` → `BlankAsBlank`.

```xml
<CustomField xmlns="http://soap.sforce.com/2006/04/metadata">
  <fullName>Calculated_Value__c</fullName>
  <label>Calculated Value</label>
  <description>Sum of Field1 and Field2</description>
  <type>Number</type>
  <precision>18</precision>
  <scale>2</scale>
  <formula><![CDATA[Field1__c + Field2__c]]></formula>
  <formulaTreatBlanksAs>BlankAsZero</formulaTreatBlanksAs>
</CustomField>
```
formula가 참조하는 field는 먼저 배포되어 있어야 함.

**Function Guidelines:** `TEXT()` Text field에 사용 금지 · `CASE()` 마지막 파라미터=default, 총 파라미터 수 짝수 · `VALUE()` Text field만 · `DAY()`/`MONTH()` Date field만(DateTime은 `DATEVALUE()`로 변환) · `DATEVALUE()` DateTime field만 · `ISPICKVAL()` picklist 동등 비교 시 필수(`==` 금지) · `ISCHANGED()` 변경 확인용.

## 핵심 규칙·가드레일

### Common Deployment Errors
| Error | 원인 | Fix |
|---|---|---|
| `ConversionError: Invalid XML tags...` | root `<CustomField>` 앞 XML comment | comment 제거 |
| `Field [X] does not exist` | 참조 field 미존재/미배포 | 참조 field 먼저 배포 |
| `DUPLICATE_DEVELOPER_NAME` | fullName 중복 | 고유 이름 |
| `MAX_RELATIONSHIPS_EXCEEDED` | M-D >2 또는 Lookup >15 | 3번째부터 Lookup |
| Reserved keyword | `Order__c`, `Group__c` 등 | rename |

### Relationship Limit
객체당 Master-Detail ≤2, Lookup ≤15.

### Verification Checklist (요약)
fullName `__c` 포맷 · description+inlineHelpText 채움 · label Title Case · root 앞 comment 없음 · M-D에 required/deleteConstraint/lookupFilter 부재, relationshipOrder 0/1, parent sharingModel ControlledByParent · Lookup deleteConstraint 설정, relationshipName plural PascalCase · Summary에 precision/scale 부재, foreignKey/summarizedField 완전 한정, COUNT는 summarizedField 부재 · Formula type=result type, CDATA 래핑, returnType 부재, formulaTreatBlanksAs 설정 · `scale ≤ precision ≤ 18` · TextArea `length=255`, Long/Html visibleLines · M-D ≤2, Lookup ≤15 · reserved word 없음, 고유 이름.

## 번들 파일

번들 파일 없음 — `SKILL.md` 단일 파일.

## 관련 노트
- [[platform-custom-object-generate]]
- [[platform-validation-rule-generate]]
- [[platform-metadata-api-context-get]]
