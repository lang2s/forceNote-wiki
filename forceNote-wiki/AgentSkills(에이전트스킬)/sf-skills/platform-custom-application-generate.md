---
tags: [agent-skill, sf-skills, platform, metadata, custom-application, lightning-app]
source: forcedotcom/sf-skills (skills/platform-custom-application-generate/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [platform-custom-application-generate, 커스텀 애플리케이션 생성, CustomApplication, Lightning App, navType, action override]
---

# platform-custom-application-generate — 커스텀 Lightning 애플리케이션 메타데이터 생성

> 탭·브랜딩·액션 오버라이드를 갖춘 탭 기반 Salesforce CustomApplication(Lightning App) 메타데이터를 생성한다. navType 선택과 action override 가드레일에 집중.

## 목적과 활성화 조건

`metadata.version: 1.0`

**TRIGGER:** 커스텀 앱, application metadata, 앱 navigation, 탭을 앱으로 묶기, 탭/페이지를 담는 앱 컨테이너 작업.

**DO NOT TRIGGER:** App Launcher에서 React UI bundle 호스팅이 목적이면 → `experience-ui-bundle-custom-app-generate`.

이 스킬이 다루는 작업:
- Lightning 애플리케이션 생성, 탭·기능을 focused app으로 조직
- 앱 navigation·브랜딩 구성, 객체용 커스텀 page layout 설정
- 커스텀 애플리케이션 배포 오류 트러블슈팅

## 워크플로 / 단계

CustomApplication은 항상 Lightning Experience용으로 구성된다(`uiType` = `Lightning`).

### 핵심 속성 (Required)
- **fullName**: 앱 API name
- **label**: 표시 이름
- **uiType**: 모던 앱은 항상 `"Lightning"`
- **navType**: CRITICAL — 워크플로 패턴 기반 선택
  - `"Standard"`: DEFAULT, 일반 비즈니스 앱(sales, marketing, operations)
  - `"Console"`: split-view나 multi-tab workspace로 여러 레코드를 동시에 관리해야 할 때만(고객 서비스, 콜센터, 지원 운영)
- **formFactors**: form factor 배열 — `["LARGE"]`(desktop), `["SMALL"]`(mobile), 또는 둘 다

### 선택 속성
- **description**, **tabs**(탭 이름 배열), **utilityBar**(Utility Bar API name)
- **brand**: HIGHLY RECOMMENDED — headerColor, shouldOverrideOrgTheme, footerColor
- **actionOverrides**: 커스텀 레코드 페이지가 존재할 때 REQUIRED
- **profileActionOverrides**: profile별 액션 오버라이드
- **isNavAutoTempTabsDisabled** / **isNavPersonalizationDisabled** / **isNavTabPersistenceDisabled** (각 default `false`)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<CustomApplication xmlns="http://soap.sforce.com/2006/04/metadata">
    <label>Mission Control</label>
    <uiType>Lightning</uiType>
    <navType>Standard</navType>
    <formFactors>Large</formFactors>
    <brand>
        <headerColor>#0070D2</headerColor>
        <shouldOverrideOrgTheme>false</shouldOverrideOrgTheme>
    </brand>
    <actionOverrides>
        <actionName>View</actionName>
        <content>Space_Station_Record_Page</content>
        <formFactor>Large</formFactor>
        <type>Flexipage</type>
        <pageOrSobjectType>Space_Station__c</pageOrSobjectType>
    </actionOverrides>
    <tabs>standard-Home</tabs>
    <tabs>Space_Station__c</tabs>
</CustomApplication>
```
> 위 XML은 SKILL.md 본문 속성 설명을 바탕으로 구성한 예시 구조다 — `// 구조 예시 — 실제 동작 코드 아님`. 실제 배포 전 각 탭·flexipage 이름이 org에 존재하는지 확인.

## 핵심 규칙·가드레일

### navType 결정 (CRITICAL)
- **Standard 선택:** 일반 비즈니스 앱, 단일 레코드 포커스/linear navigation, 표준 탭 navigation으로 충분할 때
- **Console 선택(ONLY when):** split-view로 여러 관련 레코드 동시 관리 / 복잡·상호연결 데이터의 multi-tab workspace / 여러 소스의 컨텍스트 정보 동시 표시. 예: 고객 서비스, 콜센터, 지원 데스크
- **애매하면 → Standard** (대부분의 일반 비즈니스 use case)

### Branding (HIGHLY RECOMMENDED — 건너뛰지 말 것)
- `brand.headerColor`: hex(예 `"#0070D2"` Salesforce Blue) — 권장
- `brand.shouldOverrideOrgTheme`: default `false`
- `brand.footerColor`: footer 색
- 접근성: hex 색은 WCAG AA 대비 충족

### Action Overrides (MANDATORY — 커스텀 레코드 페이지가 있으면)
- flexipage expert가 생성한 record page를 가진 모든 custom object 탭마다 action override를 만든다.
- `actionName`: `"View"`(record page) 또는 `"Tab"`(home/app page)
- `content`: 정확한 FlexiPage 이름과 일치
- `type`: `"Default"`/`"Visualforce"`/`"Flexipage"`/`"LightningComponent"`/`"Scontrol"` — Lightning record/home 페이지는 `"Flexipage"` 권장
- `formFactor`: `"Large"`(desktop)/`"Small"`(mobile)
- `pageOrSobjectType`: override 대상 객체 API name
- `comment`(optional, max 1000자) / `skipRecordTypeSelect`(default false)

### Profile Action Overrides
profile별로 다른 page layout 제공. `actionName`/`content`/`formFactor`/`pageOrSobjectType`/`type`/`profile`(예 `"Admin"`, `"Standard User"`) 지정.

### 검증 체크리스트 (MUST VERIFY)
- 모든 탭 포함 · navType 올바름(애매하면 Standard) · branding 구성 · 커스텀 레코드 페이지를 가진 각 객체에 action override 존재 · `content`가 정확한 FlexiPage 이름과 일치 · 필수 필드(fullName, label, uiType, navType, formFactors) 채움

## 번들 파일

번들 파일 없음 — `SKILL.md` 단일 파일.

## 관련 노트
- [[platform-custom-tab-generate]]
- [[platform-flexipage-generate]]
- [[platform-custom-object-generate]]
- [[platform-metadata-deploy]]
