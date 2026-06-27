---
tags: [agent-skill, sf-skills, platform, metadata, permission-set, fls]
source: forcedotcom/sf-skills (skills/platform-permission-set-generate/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [platform-permission-set-generate, 권한 집합 생성, PermissionSet, field-level security, FLS, objectPermissions, tabSettings]
---

# platform-permission-set-generate — 권한 집합 메타데이터 생성

> 객체·필드·사용자·앱 권한을 포함한 배포 가능한 PermissionSet XML을 생성·편집한다. 필수 필드에 FLS 부여 금지가 핵심 가드레일.

## 목적과 활성화 조건

`metadata.version: 1.0` · `compatibility: Salesforce Metadata API v60.0+`

**TRIGGER:** permission set metadata 생성/편집, object permission, field-level security(FLS), tab visibility, permission set 배포. 객체·필드·사용자·앱 권한 부여.

## 워크플로 / 단계

### Step 1 — Core Properties
```xml
<PermissionSet xmlns="http://soap.sforce.com/2006/04/metadata">
    <fullName>YourPermissionSetName</fullName>
    <label>Display Name for Administrators</label>
    <description>Clear description of purpose and intended audience</description>
</PermissionSet>
```
네이밍: 설명적 API name(예 `Sales_Manager_Access`).

### Step 2 — Object Permissions (CRUD)
```xml
<objectPermissions>
    <allowCreate>true</allowCreate>
    <allowRead>true</allowRead>
    <allowEdit>true</allowEdit>
    <allowDelete>false</allowDelete>
    <modifyAllRecords>false</modifyAllRecords>
    <viewAllRecords>false</viewAllRecords>
    <viewAllFields>false</viewAllFields>
    <object>Account</object>
</objectPermissions>
```

### Step 3 — Field-Level Security
```xml
<fieldPermissions>
    <editable>true</editable>
    <readable>true</readable>
    <field>Account.SSN__c</field>
</fieldPermissions>
```
- **Required field는 `<fieldPermissions>`에 NEVER 등장** — required field에 FLS 부여는 플랫폼이 불허, 배포 실패. field 추가 전 object metadata에서 존재·non-required 확인.
- field가 required인 경우: metadata에 `<required>true</required>` 포함. Formula field는 editable 불가. Master-detail field는 child(detail) 객체에서 required field.
- 포맷 `ObjectName.FieldName`. edit 필요 시 readable+editable 둘 다 true(editable이 readable 함의). 모든 field visible은 `viewAllFields` object permission으로 대체 가능.

### Step 4 — User Permissions
```xml
<userPermissions>
    <enabled>true</enabled>
    <name>ApiEnabled</name>
</userPermissions>
<userPermissions>
    <enabled>true</enabled>
    <name>RunReports</name>
</userPermissions>
```
Common: `ApiEnabled`, `ViewSetup`, `ManageUsers`, `RunReports`. Security review 필요: `ViewAllData`, `ModifyAllData`, `ManageUsers`.

### Step 5 — App & Tab Visibility
```xml
<applicationVisibilities>
    <application>Sales_Console</application>
    <visible>true</visible>
</applicationVisibilities>
<tabSettings>
    <tab>CustomTab__c</tab>
    <visibility>Visible</visibility>
</tabSettings>
```
Tab visibility: `Visible`(All Tabs + 연결 앱 visible 탭에 노출, 커스터마이즈 가능) · `Available`(All Tabs에만, 개별 사용자가 visible로 커스터마이즈) · `None`(비표시).
**CRITICAL Tab Naming:** custom object tab은 `__c` suffix 포함(예 `MyCustomObject__c`) · standard object tab은 `standard-` prefix(예 `standard-Account`) · tab 이름은 객체 API name과 정확히 일치.

### Step 6 — Apex & Visualforce Access (Optional)
```xml
<classAccesses>
    <apexClass>CustomController</apexClass>
    <enabled>true</enabled>
</classAccesses>
<pageAccesses>
    <apexPage>CustomPage</apexPage>
    <enabled>true</enabled>
</pageAccesses>
```

### Step 7 — License & Record Type (Optional)
```xml
<license>Salesforce</license>
<hasActivationRequired>false</hasActivationRequired>
<recordTypeVisibilities>
    <recordType>Account.Business</recordType>
    <visible>true</visible>
    <default>true</default>
</recordTypeVisibilities>
```

### Step 8 — Agent Access (Optional)
Agentforce Employee Agent 접근 부여:
```xml
<agentAccesses>
    <agentName>Sales_Assistant_Agent</agentName>
    <enabled>true</enabled>
</agentAccesses>
```
- `agentName`(Required): employee agent의 developer name · `enabled`(Required): true 부여 / false 거부. agent 이름은 기존 Agentforce Employee Agent developer name과 일치해야 함.

## 핵심 규칙·가드레일

### Validation Checklist
fullName/label/description 설정 · 최소 권한 원칙 · `<fieldPermissions>`에 required field 없음 · 중복 권한 없음 · 긴 주석 없음.

### What Causes Deployment Failure
- **Required field에 field permission:** `<fieldPermissions>`의 모든 required field가 배포 실패. required field는 FLS 불가 — 전부 생략. object/field metadata에서 존재·non-required 항상 확인(가정 금지).
- **잘못된 API name:** 틀린 이름이나 suffix 누락(custom object/field/tab의 `__c` 누락)이 실패 유발.

### Deployment
Salesforce CLI로 배포(→ [[platform-metadata-deploy]] 참조).

## 번들 파일

번들 파일 없음 — `SKILL.md` 단일 파일.

## 관련 노트
- [[platform-custom-object-generate]]
- [[platform-custom-field-generate]]
- [[platform-custom-tab-generate]]
- [[platform-metadata-deploy]]
