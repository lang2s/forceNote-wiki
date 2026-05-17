---
tags: [apex, security, permission-set, architecture, pattern]
source: dreamhouse-lwc/permissionsets/dreamhouse
created: 2026-05-17
aliases: [Permission Set, 권한 세트, permissionset]
---

# Permission Set 설계

> Salesforce 권한 세트(.permissionset-meta.xml)의 표준 구성 요소와 설계 원칙. 프로파일 대신 Permission Set으로 권한을 관리하는 것이 현대 Salesforce 개발 표준.

---

## 파일 구조

```
force-app/main/default/
└── permissionsets/
    └── dreamhouse.permissionset-meta.xml
```

---

## 전체 구성 요소

```xml
<?xml version="1.0" encoding="UTF-8"?>
<PermissionSet xmlns="http://soap.sforce.com/2006/04/metadata">
    <label>dreamhouse</label>
    <hasActivationRequired>false</hasActivationRequired>

    <!-- 1. Apex 클래스 접근 -->
    <classAccesses>
        <apexClass>PropertyController</apexClass>
        <enabled>true</enabled>
    </classAccesses>

    <!-- 2. 오브젝트 CRUD 권한 -->
    <objectPermissions>
        <object>Property__c</object>
        <allowCreate>true</allowCreate>
        <allowRead>true</allowRead>
        <allowEdit>true</allowEdit>
        <allowDelete>true</allowDelete>
        <viewAllRecords>true</viewAllRecords>
        <modifyAllRecords>true</modifyAllRecords>
    </objectPermissions>

    <!-- 3. 필드 권한 (FLS) -->
    <fieldPermissions>
        <field>Property__c.Price__c</field>
        <readable>true</readable>
        <editable>true</editable>
    </fieldPermissions>
    <!-- 수식 필드 — editable 반드시 false -->
    <fieldPermissions>
        <field>Property__c.Days_On_Market__c</field>
        <readable>true</readable>
        <editable>false</editable>
    </fieldPermissions>

    <!-- 4. 앱 가시성 -->
    <applicationVisibilities>
        <application>Dreamhouse</application>
        <visible>true</visible>
    </applicationVisibilities>

    <!-- 5. 탭 가시성 -->
    <tabSettings>
        <tab>Property__c</tab>
        <visibility>Visible</visibility>
    </tabSettings>
</PermissionSet>
```

---

## 구성 요소별 설계 기준

### classAccesses — Apex 클래스

```xml
<!-- @AuraEnabled 메서드가 있는 모든 클래스 포함 -->
<classAccesses>
    <apexClass>PropertyController</apexClass>
    <enabled>true</enabled>
</classAccesses>
<classAccesses>
    <apexClass>PagedResult</apexClass>  <!-- 반환 타입 DTO도 포함 -->
    <enabled>true</enabled>
</classAccesses>
```

### objectPermissions — 오브젝트 CRUD

| 권한 | 설명 | 일반 앱 유저 | 관리자 |
|---|---|---|---|
| `allowRead` | 레코드 조회 | ✅ | ✅ |
| `allowCreate` | 레코드 생성 | ✅ | ✅ |
| `allowEdit` | 레코드 수정 | ✅ | ✅ |
| `allowDelete` | 레코드 삭제 | ❌ | ✅ |
| `viewAllRecords` | 전체 레코드 조회 | ❌ | ✅ |
| `modifyAllRecords` | 전체 레코드 수정/삭제 | ❌ | ✅ |

### fieldPermissions — FLS

```xml
<!-- 일반 편집 가능 필드 -->
<fieldPermissions>
    <field>Property__c.Price__c</field>
    <readable>true</readable>
    <editable>true</editable>
</fieldPermissions>

<!-- 수식 필드 — editable=false 필수 (editable=true 설정 불가) -->
<fieldPermissions>
    <field>Property__c.Days_On_Market__c</field>  <!-- Formula -->
    <readable>true</readable>
    <editable>false</editable>
</fieldPermissions>

<!-- 자동 계산 필드 (Picture_IMG__c — formula from Picture__c URL) -->
<fieldPermissions>
    <field>Property__c.Picture_IMG__c</field>
    <readable>true</readable>
    <editable>false</editable>
</fieldPermissions>
```

### tabSettings — 탭 가시성

| visibility | 설명 |
|---|---|
| `Visible` | 탭 표시 |
| `Hidden` | 탭 숨김 |
| `DefaultOn` | 기본 ON (사용자 변경 가능) |
| `DefaultOff` | 기본 OFF (사용자 변경 가능) |

---

## CI/CD 자동 할당 패턴

```yaml
# GitHub Actions ci.yml — 스크래치 조직에 Permission Set 자동 할당
- name: 'Assign permissionset to default user'
  run: sf org assign permset -n dreamhouse
```

---

## 설계 원칙

1. **프로파일 대신 Permission Set** — 프로파일은 최소 권한만, 기능별 권한은 Permission Set으로
2. **용도별 분리** — `dreamhouse_admin.permissionset`, `dreamhouse_user.permissionset` 등 역할별 분리
3. **수식/자동 필드** — `editable=false` 로 명시
4. **Apex 클래스** — `@AuraEnabled` 포함 클래스 + 반환 타입 DTO 모두 포함
5. **최소 권한 원칙** — `viewAllRecords`, `modifyAllRecords`는 관리자 전용 Permission Set에만

---

## 관련 노트

- [[Safely]]
- [[CanTheUser]]
- [[LWC 보안 패턴]]
- [[서비스 레이어 패턴]]
