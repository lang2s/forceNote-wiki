---
tags: [agent-skill, sf-skills, platform, metadata, custom-object, sharing-model]
source: forcedotcom/sf-skills (skills/platform-custom-object-generate/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [platform-custom-object-generate, 커스텀 오브젝트 생성, CustomObject, sharingModel, nameField, ControlledByParent]
---

# platform-custom-object-generate — 커스텀 오브젝트 메타데이터 생성

> Metadata API 배포 오류를 막는 필수 제약을 검증하며 `.object-meta.xml`을 생성한다. sharing model과 Master-Detail 처리에 집중.

## 목적과 활성화 조건

`metadata.version: 1.0`

**TRIGGER:** custom object, 객체 생성, object metadata, `.object` 파일, sharing model, name field, 객체 위 validation rule 작업. "create a custom object", "generate object metadata", 객체 배포 오류(특히 sharing model·Master-Detail) 트러블슈팅.

이 스킬이 다루는 작업: 새 커스텀 객체 생성 · object metadata XML 생성 · object sharing/security 설정 · object feature 활성화 · 배포 오류 트러블슈팅.

**파일 확장자:** `.object-meta.xml`

## 워크플로 / 단계

### Tier 1 — Syntactic Essentials (필수 요소)

| Element | 요구 | 비고 |
|---|---|---|
| `<label>` | Required | 단수 UI 이름 |
| `<pluralLabel>` | Required | 복수 UI 이름 |
| `<sharingModel>` | Required | 아래 규칙 참조 |
| `<deploymentStatus>` | Required | 항상 `Deployed` |
| `<nameField>` | Required | `<label>` + `<type>` 필요 |
| `<visibility>` | Required | 항상 `Public` |

> **API Name(fullName)은 태그가 아니라 파일명이다** (예: `Vehicle__c.object-meta.xml`). XML root에 `<fullName>` 넣지 않는다.

### Sharing Model 규칙
- **Default:** `<sharingModel>` = `ReadWrite`
- **Exception:** 객체가 Master-Detail 관계 필드를 포함하면 `<sharingModel>` MUST be `ControlledByParent`
- Master-Detail 필드를 기존 child 객체에 추가하면 그 기존 객체의 sharingModel도 `ControlledByParent`로 갱신해야 함
- 위반 시 오류: `Cannot set sharingModel to ReadWrite on a CustomObject with a MasterDetail relationship field`

```xml
<CustomObject xmlns="http://soap.sforce.com/2006/04/metadata">
  <label>Order Line Item</label>
  <pluralLabel>Order Line Items</pluralLabel>
  <sharingModel>ControlledByParent</sharingModel>  <!-- M-D 필드 있을 때 -->
  <deploymentStatus>Deployed</deploymentStatus>
</CustomObject>
```

### Tier 2 — Smart Defaults & Decision Logic

**A. Name Field 결정**

| Type | 사용 시점 | 추가 요구 |
|---|---|---|
| **Text** | 사람이 이름 붙이는 엔티티(Projects, Locations, Teams) 기본 | 없음 |
| **AutoNumber** | 트랜잭션·로그·ID(Invoices, Requests, Tickets) | `<displayFormat>`(예 `INV-{0000}`) + `<startingNumber>1</startingNumber>` |

```xml
<nameField>
  <label>Invoice Number</label>
  <type>AutoNumber</type>
  <displayFormat>INV-{0000}</displayFormat>
  <startingNumber>1</startingNumber>
</nameField>
```

**B. Object Description** — Mandatory. 의도가 모호하면: "Object used to track and manage [Intent] within the organization." 형태로 생성.

**C. Junction Object 네이밍** — many-to-many 링크는 두 parent를 결합해 명명(`Position_Candidate__c`, `Job_Application__c`).

**D. Feature Enablement (Clean XML)** — 플랫폼 기본값 `false`에서 벗어날 때만 optional 태그 포함.
- **User-Facing 객체:** `<enableSearch>`, `<enableReports>`, `<enableActivities>`, `<enableHistory>` = `true`
- **System-Facing 객체(junction, 백그라운드 로그):** 위 태그 생략

## 핵심 규칙·가드레일

### Reserved Words (API name으로 사용 금지)
| 분류 | 단어 |
|---|---|
| SOQL/SQL | `Select`, `From`, `Where`, `Limit`, `Order`, `Group` |
| System | `User`, `External`, `View`, `Type` |
| Temporal | `Date`, `Number` |

### Relationship Cap
한 객체당 Master-Detail 관계 **2개 초과 금지**. 3번째가 필요하면 Lookup 사용.

### Validation Rule 네이밍 (custom field와 다름)
- 영숫자·underscore만, letter로 시작, underscore로 끝나지 않음, 연속 underscore 금지
- **`__c`로 끝나면 안 됨** (custom field와 달리)

| Metadata Type | 패턴 | 예 |
|---|---|---|
| Custom Fields | `__c`로 끝남 | `Start_Date__c` |
| Validation Rules | suffix 없음 | `Require_Start_Date` |
| Custom Objects | `__c`로 끝남 | `Vehicle__c` |

```xml
<validationRules>
  <fullName>Require_Start_Date</fullName>  <!-- __c suffix 없음 -->
  <active>true</active>
  <errorMessage>Start Date is required.</errorMessage>
  <formula>ISBLANK(Start_Date__c)</formula>
</validationRules>
```

### Verification Checklist
label+pluralLabel 존재 · deploymentStatus=Deployed · visibility=Public · nameField에 label+type · AutoNumber면 displayFormat+startingNumber · M-D 있으면 sharingModel=ControlledByParent · reserved word 없음 · M-D ≤2 · root에 `<fullName>` 없음 · validation rule 이름 `__c` 없음 · description 존재.

## 번들 파일

번들 파일 없음 — `SKILL.md` 단일 파일.

## 관련 노트
- [[platform-custom-field-generate]]
- [[platform-validation-rule-generate]]
- [[platform-custom-tab-generate]]
- [[platform-metadata-api-context-get]]
