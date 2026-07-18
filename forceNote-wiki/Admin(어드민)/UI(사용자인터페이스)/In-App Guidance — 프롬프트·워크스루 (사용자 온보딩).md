---
tags: [admin, in-app-guidance, prompt, walkthrough, onboarding, metadata, lightning-experience, user-adoption]
source: dreamhouse-lwc-main/force-app/main/default/prompts/Property.prompt-meta.xml·PropertyExplorer·PropertyFinder (실전 예시) + developer.salesforce.com/docs/atlas.en-us.api_meta.meta/api_meta/meta_prompt.htm + help.salesforce.com customhelp_lex_prompt_consider.htm (레퍼런스)
created: 2026-07-04
aliases: [In-App Guidance, In App Guidance, Prompt, Walkthrough, Prompt metadata, promptVersions, displayType, FloatingPanel, DockedComposer, Targeted prompt, 인앱 가이던스, 인앱 안내, 프롬프트, 워크스루, 사용자 온보딩, 기능 도입]
---

# In-App Guidance — 프롬프트·워크스루 (사용자 온보딩)

> Lightning Experience 화면 위에 뜨는 프롬프트(단일)·워크스루(멀티스텝)로 사용자를 온보딩·기능 안내하는 선언적 도구. Setup UI로 만들거나 `Prompt` 메타데이터 타입으로 정의·배포한다.

---

## 1. 개념 — In-App Guidance란

In-App Guidance는 관리자가 코드 없이 Lightning Experience 페이지 위에 **안내 메시지**를 얹는 기능이다. 새 기능 홍보, 온보딩, 프로세스 안내, 정책 공지에 쓴다. 두 가지 형태가 있다.

| 형태 | 구성 | 용도 |
|---|---|---|
| **단일 프롬프트(Single Prompt)** | 프롬프트 1개 (`promptVersions` 1개, `stepNumber` 없음/1) | 단일 팁·공지·기능 강조 |
| **워크스루(Walkthrough)** | 순차 스텝 2~10개 (`stepNumber` 1..N) | 다단계 온보딩 투어. 스텝을 넘기며 화면 곳곳을 안내 |

각 프롬프트는 다시 **3가지 표시 타입(`displayType`)** 중 하나다.

| displayType | 모습 | 특징 | API |
|---|---|---|---|
| `FloatingPanel` | 화면 위 떠 있는 패널 | 페이지 아무 위치(6방향)에 배치. 짧은 팁 | 46.0+ |
| `DockedComposer` | 하단 모서리 고정 | 헤더·비디오·긴 본문 가능. 최소화/최대화 | 46.0+ |
| `Targeted` | 특정 UI 요소에 붙음 | 버튼·필드 등 요소 옆에 말풍선처럼. `referenceElementContext`로 요소 지정 | 52.0+ |

> 프롬프트 실체는 `Prompt` 메타데이터 타입(파일 접미사 `.prompt`, `prompts/` 폴더, API v46.0+)이다. 한 `Prompt` 파일 안에 여러 `promptVersions`가 들어가며, **워크스루는 스텝마다 하나의 `promptVersions`**로 표현된다.

---

## 2. 실전 예시 — Dreamhouse 샘플 앱 (Tier 1, 로컬 소스 발췌)

Dreamhouse 앱은 `prompts/` 폴더에 3개의 `Prompt`를 두고, 세 화면(레코드 페이지·2개 탭 페이지)에 걸친 **연결된 워크스루**를 구성한다. 아래는 실제 소스 그대로다.

### 2-1. 워크스루 첫 스텝 — 레코드 페이지 대상 (`Property.prompt-meta.xml`)

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<Prompt xmlns="http://soap.sforce.com/2006/04/metadata">
    <masterLabel>Property</masterLabel>
    <promptVersions>
        <body>On the Property record page, we have a component that displays the number of days a property has been on the market. This is a pretty important detail for sales reps!</body>
        <delayDays>1</delayDays>
        <dismissButtonLabel>Close</dismissButtonLabel>
        <displayPosition>BottomLeft</displayPosition>
        <displayType>FloatingPanel</displayType>
        <isPublished>true</isPublished>
        <masterLabel>Property Step 1</masterLabel>
        <publishedDate>2020-06-29</publishedDate>
        <shouldDisplayActionButton>false</shouldDisplayActionButton>
        <shouldIgnoreGlobalDelay>true</shouldIgnoreGlobalDelay>
        <startDate>2020-06-29</startDate>
        <stepNumber>1</stepNumber>
        <customApplication>Dreamhouse</customApplication>
        <targetPageKey1>Property__c</targetPageKey1>
        <targetPageKey2>view</targetPageKey2>
        <targetPageType>standard__recordPage</targetPageType>
        <timesToDisplay>1</timesToDisplay>
        <title>Days on the Market</title>
        <userAccess>Everyone</userAccess>
        <userProfileAccess>Everyone</userProfileAccess>
        <versionNumber>1</versionNumber>
    </promptVersions>
    <!-- Step 2~4 생략: 같은 레코드 페이지에서 stepNumber 2,3,4 로 이어짐 -->
</Prompt>
```

관찰 포인트(실제 소스 기준):
- **레코드 페이지 타겟팅**: `targetPageType=standard__recordPage`, `targetPageKey1=Property__c`(오브젝트 API명), `targetPageKey2=view`(액션). 이 3개가 "어느 페이지에 뜰지"를 결정한다.
- **스텝 1에만 스케줄 필드**: `delayDays`·`startDate`·`timesToDisplay`·`publishedDate`는 워크스루 **첫 스텝에만** 지정한다(스텝 2~4엔 없음). 이는 워크스루 전체에 적용된다.
- **첫 스텝만 `isPublished=true`**: 워크스루 전체의 발행 상태를 첫 스텝이 대표한다(스텝 2~4는 `false`).
- `shouldIgnoreGlobalDelay=true`: 24시간 글로벌 지연을 무시하고 페이지 로드 시 표시.

### 2-2. 마지막 스텝의 액션 버튼 — 외부 링크·다음 투어 연결

`Property` 워크스루 마지막 스텝(Step 4)은 액션 버튼으로 외부 URL을 연다.

```xml
<promptVersions>
    <actionButtonLabel>Code Tours</actionButtonLabel>
    <actionButtonLink>https://github.com/trailheadapps/dreamhouse-lwc#code-tours</actionButtonLink>
    <body>You&#39;ve now completed the Dreamhouse sample app tour. &lt;b&gt;We hope that you&#39;ve enjoyed the trip! &lt;/b&gt; ...</body>
    <displayPosition>TopCenter</displayPosition>
    <displayType>FloatingPanel</displayType>
    <shouldDisplayActionButton>true</shouldDisplayActionButton>
    <stepNumber>4</stepNumber>
    <title>Wrapping It Up</title>
    ...
</promptVersions>
```

`PropertyExplorer` 워크스루의 마지막 스텝(Step 7)은 **다음 워크스루로 내비게이트**한다 — 여러 화면에 걸친 투어를 사슬로 잇는 패턴:

```xml
<actionButtonLabel>Next Tour</actionButtonLabel>
<actionButtonLink>/lightning/n/Property_Finder</actionButtonLink>
```

관찰 포인트:
- `shouldDisplayActionButton=true` + `actionButtonLabel`(≤25자) + `actionButtonLink`(≤1000자) 3종이 세트.
- `body`는 HTML을 허용한다 — `<b>`, `<a href target="_blank">` 등. XML이므로 `&lt;`·`&#39;`로 이스케이프해 저장된다.

### 2-3. 탭(내비게이션 아이템) 페이지 타겟팅 (`PropertyExplorer`·`PropertyFinder`)

레코드 페이지 대신 커스텀 탭을 겨냥할 땐 `targetPageType`이 다르다.

```xml
<targetPageKey1>Property_Explorer</targetPageKey1>
<targetPageType>standard__navItemPage</targetPageType>
```

- `standard__navItemPage` → `targetPageKey1`은 탭(내비 아이템)의 API명. `targetPageKey2` 불필요.
- `standard__recordPage` → `targetPageKey1`=오브젝트, `targetPageKey2`=`view`.

세 파일 전체에서 `displayType`은 모두 `FloatingPanel`, `displayPosition`은 스텝별로 `BottomLeft`/`BottomCenter`/`BottomRight`/`TopCenter`를 섞어 화면 각 영역을 가리킨다.

---

## 3. 전체 API 레퍼런스 — `Prompt` 메타데이터 (Tier 2, 공식 문서)

### 3-1. 최상위 `Prompt`

파일: `prompts/<name>.prompt-meta.xml`. `Metadata`를 상속(`fullName` 보유). API v46.0+.

| 필드 | 타입 | 필수 | 설명 |
|---|---|---|---|
| `masterLabel` | string | Y | 프롬프트 레이블. 최대 80자 |
| `promptVersions` | PromptVersion[] | N | In-App Guidance 항목 목록(단일=1개, 워크스루=스텝 수만큼) |

### 3-2. `PromptVersion` — 전체 필드

| 필드 | 타입 | 필수 | 값 / 제약 |
|---|---|---|---|
| `masterLabel` | string | Y | 이 스텝의 레이블 |
| `title` | string | Y | 제목. 최대 36자 |
| `body` | string | Y | 본문. 최대 4,000자(API v60+). 이전 버전은 floating/targeted 240자·docked 4,000자. HTML 허용 |
| `displayType` | enum | Y | `DockedComposer` · `FloatingPanel` · `Targeted`(v52+) |
| `displayPosition` | enum | N | floating 위치: `BottomCenter` `BottomLeft` `BottomRight` `TopCenter` `TopLeft` `TopRight` |
| `elementRelativePosition` | enum | N | targeted 말풍선 위치(v52+): `BottomCenter` `BottomLeft` `BottomRight` `LeftBottom` `LeftCenter` `LeftTop` `RightBottom` `RightCenter` `RightTop` `TopCenter` `TopLeft` `TopRight` |
| `referenceElementContext` | textarea | N | targeted가 붙을 UI 요소 식별자(v52+) |
| `targetPageType` | string | Y | 페이지 타입. 예: `standard__recordPage`, `standard__navItemPage`, `standard__objectPage`, App/Home 페이지 |
| `targetPageKey1` | string | Y | 페이지 위치 식별자 1. recordPage=오브젝트 API명, navItemPage=탭 API명 |
| `targetPageKey2` | string | N | 식별자 2. recordPage=액션(`view`) |
| `targetPageKey3` | string | N | 식별자 3 |
| `targetPageKey4` | string | N | 식별자 4(v53+) |
| `targetRecordType` | string | N | 특정 레코드 타입에만 표시(new/clone 페이지, v53+) |
| `stepNumber` | int | 조건 | 워크스루 스텝 번호. **워크스루면 필수**, 최대 10스텝, 연속 번호(v49+). 단일 프롬프트는 생략/1 |
| `dismissButtonLabel` | string | N | 닫기 버튼 레이블. 최대 15자 |
| `shouldDisplayActionButton` | boolean | N | 액션 버튼 포함 여부 |
| `actionButtonLabel` | string | N | 액션 버튼 레이블. 최대 25자. 워크스루는 마지막 스텝에 지정 |
| `actionButtonLink` | string | N | 액션 버튼 URL. 최대 1,000자 |
| `header` | string | N | docked 프롬프트 헤더. 최대 36자 |
| `image` | string | N | ContentAsset 개발자명. `imageLink`와 배타 |
| `imageLink` | string | N | 이미지 URL. 최대 1,000자. `image`와 배타(v53+) |
| `imageAltText` | string | 조건 | 이미지 지정 시 필수(대체 텍스트) |
| `imageLocation` | picklist | 조건 | `Top` `Bottom` `Right`(floating/targeted 전용) `Left`(floating/targeted 전용) |
| `videoLink` | string | N | 임베드 비디오 URL. 최대 1,000자. docked 전용. `image`와 배타(v48+) |
| `themeColor` | enum | 조건 | `Theme1`(브랜드색) `Theme2`(페이지 배경) `Theme3`(글로벌 헤더) `Theme4`(앱 테마). `themeSaturation` 지정 시 필수 |
| `themeSaturation` | enum | 조건 | `Dark` `Light`. `themeColor` 지정 시 필수 |
| `isPublished` | boolean | N | 활성 상태. 워크스루는 첫 스텝이 대표 |
| `startDate` | date | 조건 | 표시 시작일. API v48- 필수. 워크스루는 첫 스텝 |
| `endDate` | date | N | 표시 종료일. 워크스루는 첫 스텝 |
| `publishedDate` | date | N | 활성화(발행)일 |
| `delayDays` | int | 조건 | 재표시 간격(일). 반복 스케줄 시 필수. 워크스루는 첫 스텝 |
| `timesToDisplay` | int | 조건 | 최대 표시 횟수. 반복 시 필수. **최대 30**. 워크스루는 첫 스텝 |
| `shouldIgnoreGlobalDelay` | boolean | N | true면 글로벌 24h 지연 무시하고 페이지 로드 시 표시(v48+) |
| `userAccess` | enum | 조건 | `Everyone` · `SpecificPermissions`. API v48- 필수 |
| `userProfileAccess` | enum | N | `Everyone` · `SpecificProfiles`(v48+) |
| `uiFormulaRule` | UiFormulaRule[] | N | 권한/프로필 기반 표시 조건 필터 |
| `description` | string | N | 설명. 최대 255자 |
| `versionNumber` | int | Y | 항상 1(다중 버전 저장 안 함) |
| `customApplication` | string | N | (내부용, 데이터 미채움) |

> `targetAppDeveloperName`·`targetAppNamespacePrefix`는 v51.0부터 **deprecated**. `publishedByUser`·`indexWith(out)IsPublished`·`customApplication`은 내부용 필드다.

### 3-3. `UiFormulaRule` / `UiFormulaCriterion` — 권한·프로필 조건

`SpecificPermissions`/`SpecificProfiles`로 대상을 좁힐 때 사용.

| 타입 | 필드 | 설명 |
|---|---|---|
| UiFormulaRule | `booleanFilter` | AND/OR 조합 로직 문자열 |
| UiFormulaRule | `criteria` | UiFormulaCriterion[] |
| UiFormulaCriterion | `leftValue` | `{!$Permission.CustomPermission.<명>}` · `{!$Permission.StandardPermission.<명>}` · `{!ENCODED:{!ID:$User.Profile.Key}}` |
| UiFormulaCriterion | `operator` | `EQUAL` |
| UiFormulaCriterion | `rightValue` | 권한이면 `true`, 프로필이면 프로필명(예: `Standard`) |

```xml
<!-- 구조 예시 — 실제 동작 설정 아님: 특정 권한 보유자에게만 표시 -->
<userAccess>SpecificPermissions</userAccess>
<uiFormulaRule>
    <criteria>
        <leftValue>{!$Permission.CustomPermission.Can_See_Onboarding}</leftValue>
        <operator>EQUAL</operator>
        <rightValue>true</rightValue>
    </criteria>
</uiFormulaRule>
```

---

## 4. 제약·고려사항 (Tier 2, 공식 Considerations)

| 항목 | 제약 |
|---|---|
| 워크스루 스텝 수 | 최대 **10 스텝**, `stepNumber` 연속 |
| 재표시 | 같은 안내를 **최대 30회**, 표시 간 **최대 30일** 간격 |
| 기본 지연 | 사용자·앱당 안내 표시 간 **24시간** 최소 지연(글로벌). `shouldIgnoreGlobalDelay`/"페이지 로드 시 표시"로 무시 |
| 프로필·권한 제한 | 프롬프트당 프로필+권한 **최대 10개** 조합. 여러 프로필=OR, 여러 권한=AND, 혼합=둘 다 |
| 위치 범위 | "This Page, This App" / "This Page, Any App" / "Any Page, This App" / "Any Page, Any App" |
| 지원 페이지 | 오브젝트 레코드 페이지, 오브젝트 홈, New/Edit/Clone 레코드 페이지(윈도우 포함, 레코드 타입 지정 가능) |
| 타겟 불가 | 글로벌 액션 윈도우(대신 floating으로 표시), split view의 Task 레코드 페이지 |
| 이미지 | .jpg/.jpeg/.png/.gif(애니 gif O, 애니 png X). 상/하단 324×132px, 좌/우 148×148px, 최대 5MB |
| 미지원 | **Salesforce 모바일 앱**에서는 In-App Guidance 미표시. Experience Cloud 사이트 프롬프트는 커스텀 테마색 미지원 |

> ⚠️ Dreamhouse의 Property Step 3 본문("Salesforce Mobile app에서 확인하라")은 **안내 내용**일 뿐 — 프롬프트 자체는 모바일 앱에 뜨지 않는다.

---

## 5. 비교 — 언제 무엇을 쓰나

| 상황 | 선택 |
|---|---|
| 짧은 팁 한 개, 화면 특정 코너 | 단일 프롬프트 + `FloatingPanel` + `displayPosition` |
| 특정 버튼/필드를 콕 집어 설명 | `Targeted` + `referenceElementContext` (v52+) |
| 긴 설명·비디오·헤더, 사용자가 접었다 폈다 | `DockedComposer` (+ `header`, `videoLink`) |
| 여러 화면·단계를 순서대로 온보딩 | 워크스루(`stepNumber` 1..10), 마지막 스텝 액션 버튼으로 다음 투어 연결 |
| 특정 프로필/권한 사용자에게만 | `userAccess=SpecificPermissions`/`userProfileAccess=SpecificProfiles` + `uiFormulaRule` |
| 반복 리마인드 | `delayDays` + `timesToDisplay`(≤30) 첫 스텝 지정 |

---

## 관련 노트
- [[Lightning App Builder & Pages (라이트닝 앱 빌더·페이지)]] — 프롬프트가 얹히는 Lightning 페이지의 타입(`targetPageType`)을 만드는 곳
- [[Lightning Apps & Tabs (라이트닝 앱·탭)]] — `standard__navItemPage` 타겟이 되는 탭 정의
- [[Salesforce 네비게이션]] — 액션 버튼 `actionButtonLink`의 `/lightning/n/...` 내비게이션 패턴
- [[Quick Actions & Global Actions (퀵 액션·글로벌 액션)]] — 글로벌 액션 윈도우(프롬프트 타겟 불가 케이스)
- [[Salesforce 어드민 종합 개요]] — 어드민 도구 전체 지도
