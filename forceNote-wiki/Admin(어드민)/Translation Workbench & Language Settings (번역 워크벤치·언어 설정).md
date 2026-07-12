---
tags: [admin, localization, translation, translation-workbench, language-settings, multilingual, i18n]
source: help.salesforce.com — Supported Languages(xcloud.faq_getstart_what_languages_does.htm) · Translation Workbench(platform.workbench.htm) · Metadata Available for Translation(platform.translatable_customizations.htm) · Metadata API Developer Guide — Translations / CustomObjectTranslation (Tier 2, 접속 2026-07-12)
official_doc: https://help.salesforce.com/s/articleView?id=platform.workbench.htm&type=5
created: 2026-07-12
aliases: [Translation Workbench, 번역 워크벤치, Language Settings, 언어 설정, Supported Languages, 지원 언어, Fully Supported Language, End-User Language, Platform-Only Language, Metadata Translation, 메타데이터 번역, Override Translation, 번역 재정의, Translator, 번역자, 다국어 org, org 언어 번역하는 방법, 표준 필드 라벨 번역, picklist 번역, 번역 export import]
---

# Translation Workbench & Language Settings (번역 워크벤치·언어 설정)

> 다국어 org를 현지화하는 두 축 — **Language Settings**(어떤 언어를 org에 허용할지·각 언어의 지원 등급)와 **Translation Workbench**(그 언어들로 커스텀 메타데이터 라벨을 번역·재정의하는 도구). Custom Label을 비롯한 커스텀 라벨을 번역하려면 이 워크벤치가 선행 전제다.

> [!note] Setup 라벨 캐비엇 (2026-07-12 확인)
> Setup 메뉴 항목명·클릭 경로는 릴리즈·에디션·Classic/Lightning에 따라 달라질 수 있다. 아래 경로는 2026-07-12 기준 공식 문서 표기이며, 조직에서 정확한 항목명이 다르면 Quick Find로 "Translation" / "Language"를 검색해 찾는다.

---

## 1. Language Settings — 언어 등급과 활성화

### 조직 언어 (org default / display language)

org에는 **default language**(조직 기본 언어)가 있고, 개별 사용자는 자신의 **개인 language**(User 레코드의 Language 필드)를 조직이 허용한 언어 중에서 고를 수 있다. 사용자에게 보이는 표준 UI 텍스트는 그 사용자의 언어 설정을 따른다.

### 지원 언어 3등급 (Levels of language support)

Salesforce는 언어를 세 등급으로 나눈다. 등급에 따라 **표준 UI·Help가 번역돼 제공되는 범위**가 다르다.

| 등급 | 표준 UI 제공 범위 | 용도 |
|---|---|---|
| **Fully supported (완전 지원)** | Salesforce 기능·UI 텍스트가 해당 언어로 표시된다. org의 display language(모든 사용자용)로 쓸 수 있다. | 조직 전체 언어로 사용 |
| **End-user (엔드유저 전용)** | 표준 오브젝트·페이지의 라벨은 번역돼 제공되지만 **admin 페이지·Setup·Help는 제외**(영어). 번역이 없는 라벨과 Salesforce Help는 영어로 표시. | 개인 사용자가 회사 기본 언어 대신 개인 언어로 사용 |
| **Platform-only (플랫폼 전용)** | Salesforce가 기본 번역을 제공하지 **않는** 언어. 표준 라벨은 영어(일부는 end-user/fully supported 언어)로 폴백. 로컬라이즈된 표준 UI 없음. | Platform 위에 만든 커스텀 앱·기능(custom label·custom object·field name 등)만 번역해 현지화 |

> 즉 **fully supported → end-user → platform-only** 순으로 Salesforce가 대신 번역해 주는 표준 UI 범위가 줄어든다. platform-only는 "표준 UI 번역은 없지만, 내가 만든 커스텀 라벨은 이 언어로 번역할 수 있게 언어 슬롯을 열어 주는" 등급이다.

**Fully supported 언어(공식 나열 — 접속 시점 기준):** Chinese (Simplified), Chinese (Traditional), Danish, Dutch, English, Finnish, French, German, Italian, Japanese, Korean, Portuguese (Brazil), Russian, Spanish, Swedish, Thai.
> ⚠️ end-user·platform-only 등급의 **전체 언어 목록과 개수**는 릴리즈마다 갱신된다 — 최신 전수 목록은 공식 [Supported Languages](https://help.salesforce.com/s/articleView?id=xcloud.faq_getstart_what_languages_does.htm&type=5) 참조. 본 노트는 등급 정의와 fully supported 나열만 확정한다.

### 언어 활성화

- 조직에 언어를 추가하려면 Setup에서 언어를 **활성(Active)** 으로 만든다. 활성 언어만 사용자 language 선택지·번역 UI에 나타난다.
- **주의:** 번역 UI(Translation Workbench의 Translate/Override)에서 특정 언어로 번역하려면 그 언어가 워크벤치의 번역 언어로 추가·활성돼 있어야 한다(아래 2절).

---

## 2. Translation Workbench — 활성화·언어·번역자

Translation Workbench는 **기본 비활성**이다. custom label을 비롯한 커스텀 메타데이터를 여러 언어로 번역하려면 먼저 활성화해야 한다(비활성 상태면 번역 탭 자체가 없다).

### 2-1. 활성화 (Enable)

```
// 구조 예시 — Setup 클릭 경로 (실제 동작 코드 아님)
Setup → Quick Find: "Translation Language Settings" → Translation Language Settings
   → (welcome 페이지) Enable
```
> Classic/구버전 표기: **Setup → Translation Workbench → Translation Settings → Enable**. 어느 경로든 결과는 워크벤치 활성화다(Setup 라벨 캐비엇 참조).

### 2-2. 번역 언어 추가 + 번역자 지정 (Add Translated Languages and Translators)

활성화 후 **번역할 언어를 추가**하고, 언어마다 **번역자(Translator)** 를 지정한다.

| 설정 | 의미 |
|---|---|
| **Language** | 번역 대상 언어(조직이 지원·활성한 언어 중 선택) |
| **Active** | 활성화해야 그 언어의 번역 UI가 열리고 번역 값이 사용자에게 적용된다 |
| **Translator(s)** | 그 언어의 번역 값을 입력·편집할 수 있는 사용자. 번역자는 별도 권한 없이도 워크벤치의 Translate 탭에서 자신에게 배정된 언어를 편집할 수 있다 |

### 2-3. Translate 뷰 vs Override 뷰

Translation Workbench는 두 작업 뷰를 가진다.

| 뷰 | 하는 일 |
|---|---|
| **Translate** | Setup Component(번역 가능한 메타데이터 유형)와 Language를 고른 뒤, 각 라벨의 번역 값을 표에서 입력·수정한다. 커스텀 메타데이터 라벨 번역의 기본 경로. |
| **Override** | 이미 번역된 값(특히 **설치된 second-generation managed package·unlocked package**에서 온 번역 라벨)을 조직에서 **재정의**한다. 패키지가 해당 언어를 지원해야 한다. 레코드 타입·picklist 값 등 특정 컴포넌트의 번역을 조직 상황에 맞게 덮어쓸 때 사용. |

> ⚠️ Override의 "레이아웃별·레코드 타입별 표준 필드 라벨 재정의" 세부 스코프는 이번 세션에서 원문 본문(SPA)으로 확정하지 못했다. 최신 정의는 공식 [Override Translations in Second-Generation Managed Packages and Unlocked Packages](https://help.salesforce.com/s/articleView?id=platform.entering_translated_terms_in_packages.htm&type=5) 참조.

---

## 3. 번역 가능한 메타데이터 유형 (레퍼런스)

Translation Workbench(및 Metadata API의 `Translations`/`CustomObjectTranslation` 타입)로 번역할 수 있는 커스텀 메타데이터. 아래는 공식 Metadata API Developer Guide로 확인된 유형이다.

### 3-1. 조직 수준 컴포넌트 (`Translations` 타입)

| 메타데이터 | 번역 대상 | 비고 |
|---|---|---|
| `customApplications` | 커스텀 앱 이름·설명 | |
| `customLabels` | **Custom Label** 텍스트 | 번역 짝 노트 참조 |
| `customTabs` | 커스텀 탭 이름 | |
| `customPageWebLinks` | 홈페이지 컴포넌트의 웹 링크 | |
| `quickActions` | **글로벌** Quick Action 라벨 | 오브젝트별 액션은 CustomObjectTranslation |
| `reportTypes` | 커스텀 리포트 타입 | |
| `flowDefinitions` | Flow·autolaunched flow (화면 라벨 등) | API 41.0+ · Flow 구성요소 세부는 별도 |
| `globalPicklists` | 글로벌 picklist 값 | |
| `scontrols` | S-control 이름 | |
| `prompts` | In-App Guidance 프롬프트 | API 48.0+ |
| `bots` / `botBlocks` / `botTemplates` | 봇 라벨 | API 53.0/59.0+ |

> 위 목록은 릴리즈마다 신규 유형이 추가된다(예: 최신 API에서 conversation message definition, data connector, service catalog item 등). 최신 전수는 [Translations (Metadata API)](https://developer.salesforce.com/docs/atlas.en-us.api_meta.meta/api_meta/meta_translations.htm) 참조.

### 3-2. 오브젝트 수준 컴포넌트 (`CustomObjectTranslation` 타입)

| 요소 | 번역 대상 |
|---|---|
| Field `label` | **필드 라벨**(표준·커스텀 필드 라벨) |
| Field `description` / `help` | 필드 설명·필드 레벨 도움말 |
| Field `relationshipLabel` | 조회(lookup) 관계 라벨 |
| Field `picklistValues` | **Picklist 값** |
| `recordTypes` (label/description) | **Record Type** 이름·설명 |
| `validationRules` (errorMessage) | **Validation Rule 오류 메시지** |
| `webLinks` (label) | 커스텀 **버튼·링크** 라벨 |
| `layouts` (sections label) | 레이아웃 섹션 헤딩 |
| `sharingReasons` (label) | Apex 공유 사유 라벨 |
| `fieldSets` (label) | 필드셋 라벨 |
| `workflowTasks` (subject/description) | 워크플로 태스크 제목·설명 |
| `nameFieldLabel` / `caseValues` | 표준 이름 필드 라벨·문법 변형(성/수/격) |

### 3-3. 그 밖에 확인된 번역 유형

- **Standard picklist values** — `StandardValueSetTranslation` (표준 picklist 번역)
- **Global value set** — `GlobalValueSetTranslation`
- **Data Categories** — Data Category(Group) 라벨은 Translate 뷰의 Setup Component로 번역 가능(다국어 Knowledge 카테고리 현지화에 사용)

---

## 4. Translate / Export / Import 워크플로

번역은 두 방식으로 관리한다.

**(A) 워크벤치에서 직접 입력 (소량·즉시)**
```
// 구조 예시 — 실제 동작 코드 아님
Translation Workbench → Translate
   Language 선택 → Setup Component 선택(예: Custom Label / Picklist Value / Record Type)
   → 표의 번역 열을 더블클릭해 값 입력 → Save
```

**(B) 파일 export/import (대량·외부 번역 벤더)**
1. **Export Metadata Translation Files** — Setup에서 번역 파일을 export. 파일 종류: **Source**(전체), **Untranslated**(미번역만), **Bilingual**(원문+번역 병기, 수정용) 등.
2. 외부에서 번역 후, **Import Translated Files** — export한 것과 **같은 org**에서 나온 파일 구조·확장자를 유지해 import.
3. import 후 값이 활성 언어 사용자에게 반영된다. (import/export 오류는 파일 구조·키 불일치가 원인인 경우가 많다.)

> 워크벤치는 Metadata Translation(설정 라벨)과 Data Translation(레코드 데이터 값)을 구분한다. 본 노트는 **Metadata Translation**(설정·라벨 번역)을 다룬다. 레코드 데이터 값 번역은 Data Translation(Enable Data Translation) 별도 기능이다.

---

## 관련 노트

- [[Custom Labels (커스텀 레이블)]] — 번역 짝. custom label 텍스트를 여러 언어로 번역하려면 본 워크벤치 활성화가 전제.
- [[Custom Buttons & Links (커스텀 버튼·링크)]] — webLinks 라벨이 번역 대상.
- [[Lightning Knowledge 다국어 & 번역]] — Service Cloud 쪽 아티클 콘텐츠 번역(별개 파이프라인이지만 다국어 org 맥락에서 짝).
