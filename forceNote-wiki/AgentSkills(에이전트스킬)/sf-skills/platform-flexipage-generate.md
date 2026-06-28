---
tags: [agent-skill, sf-skills, platform, metadata, flexipage, lightning-page]
source: forcedotcom/sf-skills (skills/platform-flexipage-generate/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [platform-flexipage-generate, 라이트닝 페이지 생성, FlexiPage, RecordPage, AppPage, HomePage, region facet]
---

# platform-flexipage-generate — Lightning 페이지(FlexiPage) 생성

> RecordPage/AppPage/HomePage를 CLI bootstrap으로 생성한다. 새 페이지는 반드시 CLI 템플릿으로 시작하고, base 검증 후 XML 수정을 멈추는 워크플로가 핵심.

## 목적과 활성화 조건

`metadata.version: 1.0`

**TRIGGER:** RecordPage/AppPage/HomePage, Lightning page, page layout, 페이지에 컴포넌트 추가, page customization, `*.flexipage-meta.xml` 편집. Salesforce 맥락에서 'page'만 언급해도 사용.

이 스킬이 다루는 작업: Lightning page 생성 · FlexiPage metadata XML 생성 · 기존 FlexiPage에 컴포넌트 추가 · 배포 오류 트러블슈팅 · FlexiPage 구조·컴포넌트 구성 이해.

> **CRITICAL:** 새 FlexiPage 생성 시 반드시 CLI 템플릿 명령으로 시작. 절대 XML을 scratch로 만들지 않는다 — CLI가 valid 구조·proper region·올바른 컴포넌트 구성을 제공해 배포 오류를 막는다.

## 워크플로 / 단계

### Step 1 — CLI로 Bootstrap (새 페이지는 NOT optional)
```bash
sf template generate flexipage \
  --name <PageName> \
  --template <RecordPage|AppPage|HomePage> \
  --sobject <SObject> \
  --primary-field <Field1> \
  --secondary-fields <Field2,Field3> \
  --detail-fields <Field4,Field5,Field6,Field7> \
  --output-dir force-app/main/default/flexipages
```
**명령 실패 시 STOP:** 1) `sf plugins install templates` 2) 명령 재시도 3) XML 파일 생성 확인. 성공 전까지 Step 2 진행 금지.

**Template별 요구:**
- **RecordPage:** `--sobject` 필요 + field 파라미터 — `--primary-field`(가장 중요한 식별 field, 예 Name), `--secondary-fields`(record summary, 권장 4-6, max 12), `--detail-fields`(전체 상세, required field 포함)
- **AppPage / HomePage:** 추가 요구 없음

**Field Selection Rules:** MCP/describe로 field 존재 검증 · compound field 선호(`Name`, `BillingAddress` 등) · required field(`Name`)는 `--detail-fields`에 항상 포함.

### Step 2 — Base Page 배포 (dry-run)
```bash
sf project deploy start --dry-run -d "force-app/main/default" --test-level NoTestRun --wait 10 --json
```
진행 전 모든 배포 오류 수정. 페이지가 성공적으로 검증되어야 함.

### Step 3 — STOP, 추가 수정 없음
Step 2 후 정지. 컴포넌트 추가·FlexiPage XML 편집 금지(사용자가 추가 컴포넌트·customization을 요청해도). 가능: 유용한 컴포넌트 제안·가능한 enhancement 설명·수동 추가 필요 사항 문서화. 불가: XML 수정·컴포넌트 추가·enhancement.

## 핵심 규칙·가드레일

### 1. Property Value Encoding (MOST COMMON ERROR)
HTML/XML 문자를 가진 property value는 다음 순서로 수동 인코딩(잘못된 순서는 double-encoding 손상):
```
1. & → &amp;   (FIRST!)
2. < → &lt;
3. > → &gt;
4. " → &quot;
5. ' → &apos;
```
`<value>` 태그는 raw `<`/`>`를 절대 포함하면 안 됨.

### 2. Field References
**ALWAYS** `Record.{FieldApiName}` · **NEVER** `{ObjectName}.{FieldApiName}`. (`<fieldItem>Record.Name</fieldItem>` ✅ / `Account.Name` ❌)

### 3. Region vs Facet
template region(header/main/sidebar) → `<type>Region</type>` · component slot(fieldSection 컬럼 등) → `<type>Facet</type>`.

### 4. fieldInstance 구조
```xml
<itemInstances>
   <fieldInstance>
      <fieldInstanceProperties>
         <name>uiBehavior</name>
         <value>none</value> <!-- none|readonly|required -->
      </fieldInstanceProperties>
      <fieldItem>Record.FieldName__c</fieldItem>
      <identifier>RecordFieldName_cField</identifier>
   </fieldInstance>
</itemInstances>
```
각 fieldInstance는 자체 `<itemInstances>` wrapper · `fieldInstanceProperties`에 `uiBehavior` 필수 · `Record.{Field}` 포맷.

### 5. Unique Identifiers & Region Names (DUPLICATE ERROR 방지)
모든 identifier·region/facet name은 파일 전체에서 고유해야 함.
- 같은 `<name>`의 `<flexiPageRegions>` 두 개 생성 금지
- 같은 facet에 속하는 여러 컴포넌트는 ONE region에 여러 `<itemInstances>`로 결합
- 같은 `<identifier>` 재사용 금지
- 항상 전체 파일을 먼저 읽고 기존 identifier·name 모두 추출

```xml
<!-- 올바름 — 같은 detail tab facet에 두 field section 결합 -->
<flexiPageRegions>
   <itemInstances>
      <componentInstance>
         <identifier>flexipage_property_details_fieldSection</identifier>
      </componentInstance>
   </itemInstances>
   <itemInstances>
      <componentInstance>
         <identifier>flexipage_pricing_fieldSection</identifier>
      </componentInstance>
   </itemInstances>
   <name>detailTabContent</name>
   <type>Facet</type>
</flexiPageRegions>
```
**Combine vs Separate:** 같은 tab/section에 논리적으로 속하면 combine, 다른 tab/section이면 separate(`detailTabContent` vs `relatedTabContent`).

### Common Deployment Errors
| 메시지 | 원인 | Fix |
|---|---|---|
| "We couldn't retrieve...field" | 잘못된 field API name | describe로 valid field 확인 |
| "Invalid field reference" | `ObjectName.Field` 사용 | `Record.{Field}`로 변경 |
| "Element fieldInstance is duplicated" | 한 itemInstances에 여러 fieldInstance | 각자 `<itemInstances>` wrapper |
| "Missing fieldInstanceProperties" | uiBehavior 미지정 | `fieldInstanceProperties` 추가 |
| "Unused Facet" | facet 정의되나 미참조 | 제거 또는 컴포넌트에서 참조 |
| "XML parsing error" | 미인코딩 HTML/XML | `<value>` 인코딩 |
| "Cannot create component with namespace" | 잘못된 page name(`__c` suffix) | `Volunteer_Record_Page`(not `Volunteer__c_...`) |
| "Region specifies mode that parent doesn't support" | region에 `<mode>` 태그 | `<mode>` 제거 |

### Identifier 생성 알고리즘
1. 기존 `<identifier>`·`<name>` 모두 추출 2. base name `{componentType}_{context}`(예 `relatedList_contacts`) 3. 첫 available 번호(`{base}_1`, `_2`...). Facet 네이밍 두 패턴: named facet(`detailTabContent`, `maintabs`, `sidebartabs`) / UUID facet(`Facet-{8hex}-{4hex}-{4hex}-{4hex}-{12hex}`, 내부 구조·field section 컬럼·anonymous slot).

### Region Selection
region 이름을 hardcode하지 말고 파일에서 parse(template마다 다름 — `recordHomeTemplateDesktop`은 header/main/sidebar, fieldservice는 header/main/footer). default 배치는 대상 region 끝(마지막 `<itemInstances>` 뒤).

### Container Components with Facets
tabs/accordion/field section은 facet 필요. **Facet region은 template region의 sibling(같은 레벨), nested 아님.**

### Component-Specific Tips
- **dynamicHighlights:** `header` region에만. primary field=식별, secondary field(max 12, 권장 6)=summary.
- **fieldSection:** 3-level nesting(Template Region → Column Facets → Field Facets).
- **richText(`flexipage:richText`):** 모든 page type의 어느 region에든. 단일 레벨(no facet). default text 특수문자 escape. identifier `flexipage_richText` 또는 `flexipage_richText_{sequence}`.

### Required Metadata Structure
```xml
<FlexiPage xmlns="http://soap.sforce.com/2006/04/metadata">
   <flexiPageRegions>
   </flexiPageRegions>
   <masterLabel>Page Label</masterLabel>
   <template>
      <name>flexipage:recordHomeTemplateDesktop</name>
   </template>
   <type>RecordPage</type>
   <sobjectType>Object__c</sobjectType> <!-- RecordPage only -->
</FlexiPage>
```
Page type: `RecordPage`(requires `<sobjectType>`) · `AppPage`(no sobjectType) · `HomePage`(no sobjectType).

### CLI 예시 (AppPage/HomePage)
```bash
sf template generate flexipage --name Sales_Dashboard --template AppPage --label "Sales Dashboard"
sf template generate flexipage --name Custom_Home --template HomePage --description "Custom home for sales team"
```
모든 template 지원 플래그: `--output-dir`(default 현재 dir) · `--api-version`(default latest) · `--label`(default page name) · `--description`.

> action override를 통해 이 FlexiPage를 객체 record/home page로 연결하는 작업은 [[platform-custom-application-generate]] 참조.

## 번들 파일

번들 파일 없음 — `SKILL.md` 단일 파일.

## 관련 노트
- [[platform-custom-application-generate]]
- [[platform-custom-object-generate]]
- [[platform-metadata-deploy]]
- 📘 [[Tooling API 객체 — UI·레이아웃 (페이지·액션·탭)]] — FlexiPage(라이트닝 페이지) Tooling sObject 필드·`Type` enum 레퍼런스(지식=위키·실행=스킬 프로토콜).
