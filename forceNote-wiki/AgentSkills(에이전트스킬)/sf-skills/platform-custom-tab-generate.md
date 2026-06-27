---
tags: [agent-skill, sf-skills, platform, metadata, custom-tab, navigation]
source: forcedotcom/sf-skills (skills/platform-custom-tab-generate/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [platform-custom-tab-generate, 커스텀 탭 생성, CustomTab, object tab, web tab, Visualforce tab, motif]
---

# platform-custom-tab-generate — 커스텀 탭 메타데이터 생성

> 객체·웹 콘텐츠·Visualforce 페이지로 navigate하는 Salesforce CustomTab을 생성한다. 엄격한 element allowlist 준수가 핵심.

## 목적과 활성화 조건

`metadata.version: 1.0`

**TRIGGER:** tab, navigation tab, object tab, web tab, Visualforce tab, Lightning component tab, app page tab, tab 구성. custom object에 navigation 추가, 외부 콘텐츠용 탭 생성, Lightning page tab 설정.

이 스킬이 다루는 작업: 객체·웹·Visualforce 페이지용 탭 생성 · 앱에 navigation 탭 추가 · 탭 visibility/access 구성 · 배포 오류 트러블슈팅.

## 워크플로 / 단계

### Core Tab Properties
- **customObject**: object tab은 `true`, 그 외 전부 `false`
- **motif**: 탭 아이콘 스타일 — 객체 목적에 의미상 맞는 motif 선택. 모든 탭에 같은 motif 재사용 금지.
- **label**: 표시 이름(non-object 탭만 required; object 탭은 객체에서 label 상속)
- **url**: web tab의 웹 URL
- **page**: Visualforce tab의 페이지 이름

### STRICT ELEMENT ALLOWLIST (먼저 읽을 것)
root element는 항상 `<CustomTab>`(NOT `<Tab>`), namespace는 `xmlns="http://soap.sforce.com/2006/04/metadata"`. 아래 표 외 element는 모두 배포 오류.

| Tab Type | 허용 element (이것만) |
|---|---|
| **Object tabs** | `<customObject>`(required, `true`), `<motif>`(required), `<description>`(optional) |
| **Web tabs** | `<customObject>`(`false`), `<label>`, `<motif>`, `<url>`, `<urlEncodingKey>`(`UTF-8`), `<description>`(opt), `<frameHeight>`(opt) — 전부 required 표시된 것 + optional |
| **Visualforce tabs** | `<customObject>`(`false`), `<label>`, `<motif>`, `<page>`, `<description>`(opt) |

### FORBIDDEN ELEMENTS (각각 배포 오류)
`<sobjectName>`, `<name>`, `<fullName>`, `<apiVersion>`, `<isHidden>`, `<tabVisibility>`, `<type>`, `<mobileReady>`, `<urlFrameHeight>`, `<urlType>`, `<urlRedirect>`, `<encodingKey>`, `<height>`, `<auraComponent>`
또한: object tab에 `<label>` 금지(객체에서 상속) · web tab에 `<page>` 금지 · 빈 element(`<page></page>`, `<description></description>`) 금지.

### Object Tab
파일명이 객체 결정: `{ObjectApiName}.tab-meta.xml` (예 `Space_Station__c.tab-meta.xml`)
```xml
<?xml version="1.0" encoding="UTF-8"?>
<CustomTab xmlns="http://soap.sforce.com/2006/04/metadata">
    <customObject>true</customObject>
    <motif>Custom39: Telescope</motif>
</CustomTab>
```

### Web Tab
파일명: `{TabName}.tab-meta.xml`. 아래 정확한 템플릿 복사 — placeholder만 교체, element 추가/제거/rename 금지. 이 7개가 web tab의 유일한 허용 element.
```xml
<?xml version="1.0" encoding="UTF-8"?>
<CustomTab xmlns="http://soap.sforce.com/2006/04/metadata">
    <customObject>false</customObject>
    <description>REPLACE_WITH_DESCRIPTION</description>
    <frameHeight>600</frameHeight>
    <label>REPLACE_WITH_LABEL</label>
    <motif>REPLACE_WITH_MOTIF</motif>
    <url>REPLACE_WITH_URL</url>
    <urlEncodingKey>UTF-8</urlEncodingKey>
</CustomTab>
```
`<description>`는 optional — 필요 없으면 제거 가능, 그 외는 추가 금지.

### Visualforce Tab
파일명: `{TabName}.tab-meta.xml`. required: `<customObject>false</customObject>`, `<label>`, `<motif>`, `<page>`.
```xml
<?xml version="1.0" encoding="UTF-8"?>
<CustomTab xmlns="http://soap.sforce.com/2006/04/metadata">
    <customObject>false</customObject>
    <label>Custom Page</label>
    <motif>Custom46: Computer</motif>
    <page>CustomPage</page>
</CustomTab>
```

## 핵심 규칙·가드레일

- 명확하고 설명적인 label 사용
- **각 탭마다 고유·맥락 적합한 motif 선택** — 모든 탭을 같은 아이콘으로 기본값 처리 금지
- object tab 파일은 `<customObject>true</customObject>` + `<motif>`만 — 그 외 아무것도 없음
- web tab 파일은 위 allowlist만
- `<isHidden>`, `<tabVisibility>`, `<type>`, `<mobileReady>`, 빈 element 절대 포함 금지

**Tab Visibility / Style:** default는 access 가진 모든 사용자에게 visible, standard 스타일. 커스텀은 특정 profile/스타일로 구성 가능. (탭이 어느 profile에 보이는지는 permission set/profile 소관 → [[platform-permission-set-generate]] 참조)

## 번들 파일

번들 파일 없음 — `SKILL.md` 단일 파일.

## 관련 노트
- [[platform-custom-application-generate]]
- [[platform-custom-object-generate]]
- [[platform-permission-set-generate]]
