---
tags: [release, spring_25, development, apex, lwc, api, devtools]
api_version: v63.0
release_date: 2025-02
created: 2026-06-16
source: salesforce_spring25_release_notes.pdf (Salesforce Spring '25 Release Notes, Tier 2)
aliases: [Spring '25 Development, 스프링25 개발, Compression GA, FormulaEval GA, pauseJobById, apiVersion 필수화, SLDS2 Beta, Native Shadow DOM, Agentforce DX, Salesforce CLI v2.53.6, OpenAPI sObjects Beta, Scale Center, ApexGuru]
---

# Spring '25 — Development (Apex · LWC · API · 개발 도구)

> Spring '25(API v63.0)의 개발자 영역 변경 전수 — Apex Zip 압축(`Compression`)·동적 수식(`FormulaEval`) GA, scheduled job pause/resume(`pauseJobById`), 라이선스 기반 동시 장기 Apex 한도, LWC `apiVersion` 필수화·Native Shadow DOM 추가 적응·Wire 타입체크·SLDS 2 (Beta)·LWS distortion, API v21.0–30.0 폐기 연기·Instance URL→My Domain 전환·Bulk API V2 Platform Event(Beta)·OpenAPI sObjects(Beta), Agentforce DX (Beta)·Salesforce CLI v2.53.6+·DevOps Testing GA.

---

## 개요

이 노트는 Spring '25 릴리즈 노트의 **Development 섹션**을 Apex·LWC·API·개발 도구 축으로 정리한 spoke다.

| 링크 | 역할 |
|---|---|
| [[Spring '25]] | 상위 허브 |
| [[Spring '25/Release Updates]] | 강제 적용 항목(Release Updates) — API v21.0–30.0 폐기 강제 시점표 등 |
| [[Spring '25/Platform]] | 플랫폼/자동화/통합 |
| [[Spring '25/Agentforce]] | AI/에이전트 |

**핵심 메타데이터**

| 항목 | 값 |
|---|---|
| API 버전 | v63.0 |
| LWC API 버전 | 63.0 (version-specific 변경 **없음** — 버저닝 필수화 릴리즈) |
| 출시 | 2025년 02월 |

> 도입부 요약: LWC API version 63.0은 wire adapter 타입 검증을 개선하고, 더 많은 base Lightning components가 native shadow DOM을 지원하며, iframe element는 새 Lightning Web Security 제약을 따라야 한다. Local Dev가 Lightning apps에 대해 GA가 되었다. Apex에서는 Zip 압축/해제와 동적 수식 평가가 GA이고, 동시 장기 Apex 요청 한도가 org 라이선스 type·수에 따라 달라지며, `System` 클래스의 새 메서드로 scheduled job을 pause·resume할 수 있다.

---

## Apex — GA

도입부: "Compressing and extracting Zip files and evaluating dynamic formulas in Apex are now generally available. The concurrent long-running Apex requests limit now depends on the type and number of org licenses. Pause and resume Apex scheduled jobs by using new methods in the System class."

### Compression Namespace GA

**(Generally Available / Delivered Idea — IdeaExchange.)** `Compression` 네임스페이스로 native Apex Zip library를 활용한다. blob을 Zip으로 압축하고, Zip 내 파일을 blob으로 해제한다. compression method·level을 지정해 최적화할 수 있고, 여러 attachment/document를 Apex blob으로 Zip archive에 압축한다. 전체 해제 없이 특정 데이터만 추출할 수 있다. (Summer '24 Beta → GA)

- **Where:** 모든 에디션.
- **How:** zip entry 세부(entry name, comment, compression method) 추가는 `ZipWriter` 클래스의 `addEntry(String name, Blob data)`, `addEntry(compression.ZipEntry prototype)`, `setMethod(compression.Method method)`로 한다. zipped archive를 Apex blob으로 반환하려면 `getArchive()`. Zip entry 추출은 `ZipReader` 클래스의 `getEntries()`, `getEntry(String name)`, `extract(ZipEntry entry)` 등으로 한다.

```apex
// 구조 예시 — 실제 동작 코드 아님 (PDF 시그니처 기반 축약본)
// 여러 첨부 파일을 Zip으로 압축
Compression.ZipWriter writer = new Compression.ZipWriter();
for (ContentVersion cv : [SELECT PathOnClient, VersionData FROM ContentVersion
                           WHERE ContentDocumentId IN :ids]) {
    writer.addEntry(cv.PathOnClient, cv.VersionData);
}
Blob zipBlob = writer.getArchive();

// Zip에서 특정 항목 추출
Compression.ZipReader reader = new Compression.ZipReader(zipBlob);
ZipEntry entry = reader.getEntry('translations/fr.json');
Blob data = reader.extractEntry(entry);
```

> PDF 표기 주의: detail 본문은 추출 메서드를 `extract(ZipEntry entry)`로 소개하나 실제 코드 예제는 `reader.extractEntry(...)`를 사용한다 — 두 표기 모두 PDF 원문 그대로다. Apex New/Changed Items 카탈로그(Compression Namespace)에는 기존 클래스의 신규/변경 메서드로 `ZipWriter.addEntry(String name, String comment, Datetime modTime, Compression.Method method, Blob data)`와 `ZipWriter.getEntryNames()`가 추가됐다.

상세 백링크: [[Compression Namespace]]

### FormulaEval GA

**(Generally Available / Delivered Idea.)** Apex의 dynamic formula가 SObject와 Apex object를 context object로 지원한다. `FormulaEval` 네임스페이스의 클래스 메서드로 dynamic formula를 빌드·평가한다. polymorphic relationship field 접근을 지원하고, formula field에서 standard·custom lookup을 참조할 수 있다. (Summer '24 Beta → GA)

- **Where:** 모든 에디션.
- **How:** `build()`와 `evaluate()` 메서드로 formula 인스턴스를 검증·계산하고 결과를 반환한다.

```apex
// 구조 예시 — 실제 동작 코드 아님 (PDF 시그니처 기반 축약본)
FormulaEval.FormulaInstance ff = Formula.builder()
    .withType(Schema.Account.class)
    .withReturnType(FormulaEval.FormulaReturnType.STRING)
    .withFormula('name & " (" & website & ")"')
    .build();
String fieldNameList = String.join(ff.getReferencedFields(), ',');
Account a = Database.query('SELECT ' + fieldNameList + ' FROM Account LIMIT 1');
System.debug(ff.evaluate(a));
```

> 핵심 식별자: 네임스페이스 `FormulaEval`, 클래스 `FormulaEval.FormulaInstance`, `Formula.builder()`, `.withType(Schema.Account.class)`, `.withReturnType(FormulaEval.FormulaReturnType.STRING)`, `.withFormula(...)`, `.build()`, `getReferencedFields()`, `evaluate()`. (PDF 본문은 메서드를 `getReferenced`로 약칭하나 코드는 `getReferencedFields()`이다.)

상세 백링크: [[FormulaEval Namespace]]

### Scheduled Jobs Pause/Resume

`System` 클래스의 새 메서드로 Apex scheduled job을 프로그래밍 방식으로 pause·resume한다. Summer '24에 도입된 Setup UI 모니터링 기능을 보완한다. job의 name 또는 cronTriggerId를 지정한다. **pause·resume 호출은 DML statement limit에 카운트된다.**

- **Where:** 모든 에디션.
- **How:** detail 블록 기준 새 메서드는 `pauseJobByName()`, `pauseJobById()`, `resumeJobByName()`, `resumeJobById()` (System 메서드)이다.

```apex
// pauseJobByName(), pauseJobById(), resumeJobByName(), resumeJobById()
Id apexClassId = '01p4u000000dVf7AAE';
List<AsyncApexJob> jobs = [SELECT CronTriggerId FROM AsyncApexJob
                            WHERE ApexClassId = :apexClassId];
for (AsyncApexJob j : jobs) {
    System.pauseJobById(j.CronTriggerId);
}
```

> **PDF 내부 메서드명 불일치:** detail 블록(Apex 본문)은 `pauseJobById`/`resumeJobById`로 표기하나, Apex New/Changed Items 카탈로그(System Namespace)는 `System.pauseJobByName(JobName)`, `System.pauseJobByJobId(JobId)`, `System.resumeJobByName(JobName)`, `System.resumeJobByJobId(JobId)`로 표기한다 — 즉 `pauseJobById` ↔ `pauseJobByJobId` 불일치가 PDF 내에 존재한다. 코드 예제는 `System.pauseJobById(...)`를 사용한다. 최종 메서드명은 Apex Reference Guide의 System 네임스페이스로 확정 권장.

상세 백링크: [[Scheduled Apex]]

---

## Apex — 한도 / 산문 변경

### 동시 장기 Apex 요청 한도 (라이선스 기반 확장)

long-running Apex request의 synchronous concurrent transaction 기본 limit이 org 라이선스 type·개수에 따라 달라진다. **최대 50 Apex requests로 cap**되고, **최소 long-running concurrent Apex requests는 10으로 유지**된다.

- **Where (카운트되는 라이선스 type):** full Salesforce 및 Salesforce Platform user license, App Subscription user license, Chatter Only user, Identity user, Company Communities user.

| org 라이선스 수 | 동시 장기 Apex 요청 한도 | 산정 방식 |
|---|---|---|
| **1,000개 이하** | **10** | minimum floor limit |
| **1,000 ~ 5,000개** | 라이선스 수 × (1/100) — 예: 4,000 licenses → **40** | 100 licenses당 1 concurrent request 비율 |
| **5,000개 이상** | **50** | maximum capped limit |

> PDF 원문: *"For orgs with 1,000 to 5,000 licenses, the limit is calculated based on the ratio of 100 licenses to one concurrent long-running Apex request. For example, if your org has 4,000 licenses, the concurrent long-running Apex requests limit is set at 40. If your org has 5,000 or more licenses, the concurrent long-running Apex requests limit is set at 50, which is the maximum capped limit. If your org has 1,000 or fewer licenses, the concurrent long-running Apex requests limit is set at 10 due to the minimum floor limit."*

### 기타 Apex 변경

**마스터-디테일 리패런팅 제한 강화** — **API version 63.0 이상**에서, master-detail 정의에 reparenting 허용 옵션이 미선택이면 Apex에서 child record를 reparent하려 할 때 `System.DmlException`을 던진다. **versioned behavior.** API 62.0 이하에서는 필드 설정 순서에 따라 성공하거나 예외가 없을 수 있다.

- **Where:** 모든 에디션.
- **How:** field value 설정 순서에 의존한다. master-detail relationship field를 ID field 전에 설정하면 `System.DmlException`. ID field를 master-detail 전에 설정하면 `.put` 시점에 validation → `System.SObjectException: Field master__c is not editable`.

```apex
master__c parentRecord1 = new master__c(Name = 'Sample Parent 1');
insert parentRecord1;
child__c childRecord = new child__c(
    Name = 'Sample Child Record',
    master__c = parentRecord1.Id
);
insert childRecord;
master__c parentRecord2 = new master__c(Name = 'Sample Parent 2');
insert parentRecord2;
// Attempting to directly change the master-detail relationship field is not permitted
// when reparenting is disabled
try {
    childRecord.master__c = parentRecord2.Id;
    update childRecord;
} catch (System.SObjectException ex) {
    Assert.areEqual('Field is not writeable: Child__c.Master__c', ex.getMessage());
}
SObject record = new child__c();
// If the Id is set before the master-detail relationship field then the exception occurs
// when attempting to change the relationship when reparenting is disabled
try {
    record.put('Id', childRecord.Id);
    record.put('master__c', parentRecord2.Id);
} catch (System.SObjectException ex) {
    Assert.areEqual('Field master__c is not editable', ex.getMessage());
}
// reset
record = new child__c();
// New API versioned validation when the master-detail field is set before the record Id
record.put('master__c', parentRecord2.Id);
record.put('Id', childRecord.Id);
try {
    Database.SaveResult[] updateResults = Database.update(new List<SObject> {record}, true);
} catch (System.DmlException ex) {
    Assert.isTrue(ex.getMessage().contains(
        'INVALID_FIELD_FOR_INSERT_UPDATE, Unable to create/update fields: Master__c'));
}
```

**예외 타입 JSON 직렬화 금지** — **API version 63.0 이상**에서 Apex는 커스텀 exception type 및 대부분의 built-in exception의 JSON serialization을 지원하지 않는다. serialize 시도 시 `Type unsupported in JSON: MyException` 에러가 발생한다. **versioned.** API 62.0 이하에서는 serialize가 가능했으나 불완전했고 예기치 않은 exception을 유발했다.

- **Where:** 모든 에디션.

```apex
MyException e = new MyException();
String js = JSON.serialize(e);
```

**JavaScript Remoting 예외 커버리지 확대** — `@RemoteAction` annotation을 entry point로 하는 transaction이 던진 exception이 이제 **Apex Unexpected Exception** event type에 캡처된다. event log file로 분석한다. 커버리지 확대로 로그 데이터에 스파이크가 발생할 수 있다.

- **Where:** 모든 에디션.

---

## LWC — API v63.0

### 주요 변경사항

도입부: LWC API version 63.0은 wire adapter 타입 검증을 개선하고, 더 많은 base Lightning components가 native shadow DOM을 지원하며, iframe element는 새 Lightning Web Security 제약을 따른다.

- **LWC API Version 63.0:** API 버전을 올려 새 기능/개선을 사용한다. 컴포넌트 버저닝으로 기존 컴포넌트가 신규 기능·버그픽스·성능개선에 영향받지 않게 한다. LWC API version **59.0 이상**은 해당 API 버전에 대응하는 LWC 프레임워크 버전을 사용하고, **58.0 이하**는 Summer '23(API 58.0) LWC 프레임워크 동작 기준으로 계속 동작한다. `.js-meta.xml`에서 변경한다. **63.0에는 version-specific 변경이 없다.** 컴포넌트 API 버전은 한 번에 한 버전씩 업그레이드 권장(예: 58.0 → 59.0 → 오류 수정 → 반복).

| 변경 | 설명 |
|---|---|
| `apiVersion` 필수화 | `apiVersion` 키가 모든 커스텀 컴포넌트의 필수 요소. 이전에 키 없이 저장된 컴포넌트는 retrieve 시(Salesforce CLI, VS Code add-ons 등) `.js-meta.xml`에 자동 추가. **Where:** 커스텀 LWC — Lightning Experience, Experience Builder sites, 모든 버전 mobile app. **When:** 이번 릴리즈부터 필수이며 API 63.0 이상뿐 아니라 **모든** 커스텀 컴포넌트에 적용. **Why:** 컴포넌트 레벨 API 버저닝은 Winter '24에 도입됨 — 이전엔 미설정 저장 시 내부 API 버전으로 컴파일되어 프레임워크 버전이 모호했음. 소스 수준 변경이며 deploy 시 저장됨(외부 버전관리 사용 시 변경 보존 권장). |
| Base Components 내부 DOM 구조 변경 | 성능 향상·웹 컴포넌트 표준 준수를 위해 base Lightning components를 native shadow DOM으로 전환 준비 중. 내부 DOM 구조가 변경되므로 테스트가 이전 내부 구조에 의존하지 않게 한다. Spring '23 이후 **79개** 컴포넌트가 적응됨. **Important:** protected 내부 DOM 구조에 의존하는 테스트는 즉시 재작성. UTAM(UI Test Automation Model)·UTAM Page Objects 권장. (추가 적응 컴포넌트는 아래 별도 섹션 참조.) |
| Wire Adapter 타입 체크 강화 | Spring '25부터 TypeScript 사용자는 `@wire` 구성·프로퍼티 값의 타입 체킹이 개선됨. reactive props(`$reactiveProp`처럼 `$`로 시작하는 문자열)를 컴포넌트가 사용하는 타입으로 resolve. `@wire(adapter, config) prop`에서 `config`와 `prop`의 타입이 `adapter`가 사용하는 타입과 일치해야 함. **특정 API 버전에 국한되지 않음.** **Note:** TypeScript의 `experimentalDecorators`가 더 이상 지원되지 않음 — `tsconfig.json`에서 `"experimentalDecorators": false`로 지정하거나 옵션 제거(GitHub LWC Repo v8.0.0 참조). |
| JS 셀렉터 공백 처리 변경 | JS selector가 공백(스페이스·탭 등)을 무시하도록 수정. 여분 공백 렌더링의 비일관성 제거. 빈 `class`·`style` 속성은 더 이상 렌더되지 않음. **특정 API 버전 비종속.** |
| LWC Stacked Modals (Release Update) | Aura → LWC 모달 마이그레이션. Dynamic Forms 지원 확대. 강제 적용 상세는 [[Spring '25/Release Updates]]. |

JS 셀렉터 공백 처리 변경 예시 — 마크업 `<div class=" slds-var-m-around_medium highlight yellow ">`는 여분 공백 없이 `<div class="slds-var-m-around_medium highlight yellow">`로 렌더된다. 빈 속성은 제거된다:

```html
<!-- myCmp.html -->
<div class="">Content here</div>
<div style=" ">Content here</div>
```

```html
<!-- DOM Rendering — Spring '25부터 빈 class·style 속성 제거 -->
<div>Content here</div>
<div>Content here</div>
```

```js
// 정확한 문자열 매칭을 위해 공백을 포함한 쿼리는 더 이상 작동하지 않음
document.querySelector(".slds-var-m-around_medium.highlight.yellow");
```

```js
/* Don't do this */
document.querySelector('[class="highlight yellow"]');
```

### Local Dev GA

**(Generally Available.)** Local Dev가 Lightning apps에 대해 GA가 되었다. beta 릴리즈 이후 일부 변경됨. 코드 배포나 수동 브라우저 새로고침 없이 실시간 프리뷰에서 LWC를 개발한다. **단, Local Dev는 Lightning Web Runtime sites에 대해서는 여전히 beta다.**

- **Where:** Lightning Experience, 모든 버전 mobile app, 모든 에디션.
- **How:** Salesforce CLI를 설치하고 Setup → Quick Find에 `Local Dev` 입력 → Local Dev 선택. 모든 org 사용자에게 켜려면 Enable Local Dev. plug-in 설치 CLI 명령:

```
sf plugins install @salesforce/plugin-lightning-dev
```

### SLDS 2 (Beta) 지원

**(Beta.)** Spring '25부터 base Lightning components가 Salesforce Lightning Design System 2 (SLDS 2, Beta)를 지원해 고급 테마·브랜딩 기능을 제공한다. 단 SLDS 2 (Beta)는 이전 세대 SLDS의 일부 커스터마이징 기능(예: component-specific styling hooks)을 아직 미지원한다.

- **Where:** Lightning Experience와 모든 버전 mobile app의 커스텀 컴포넌트, 모든 에디션.
- **Important:** SLDS 2는 beta service (Beta Services Terms 적용).
- **Why:** SLDS 2 (Beta) 아키텍처 개발의 중간 단계. "Prepare Customizations for SLDS Architecture Updates"를 먼저 방문 권장.
- **How:** org를 SLDS 2 standard Salesforce Cosmos theme (Beta)로 전환하면, default styling을 사용하는 base components가 새 테마로 표시된다.
- **Note:** SLDS component-specific styling hooks(`--slds-c-*` prefix)는 SLDS 2에서 예기치 않은 동작을 유발할 수 있다 — 사용 시 SLDS 2와 Salesforce Cosmos theme가 GA될 때까지 SLDS themes로 제한한다.

```xml
<!-- .js-meta.xml — apiVersion 63.0 예시 -->
<?xml version="1.0" encoding="UTF-8"?>
<LightningComponentBundle xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>63.0</apiVersion>
    <isExposed>true</isExposed>
</LightningComponentBundle>
```

**SLDS / SLDS 2 관련 추가 도구·블루프린트**

- **Introducing SLDS 2 (Beta)** — Lightning Platform용 최신 디자인 시스템. CSS 업데이트와 styling hooks 구현으로 달성(마크업·구조 변경 없음). SLDS 2는 신규·기존 Starter 및 Pro Suite orgs에 default 활성화. 모든 에디션의 신규 Sales orgs와 일부 신규 Service orgs에 활성화. Spring '25부터 Salesforce Cosmos에 opt-in하는 신규·기존 orgs에 available. **As of February 25, 2025**, `lightningdesignsystem.com`은 SLDS 2 (beta) 콘텐츠를 제공하고, SLDS 1 콘텐츠는 `v1.lightningdesignsystem.com`에서 확인 가능.
- **SLDS Validator (version 2.0 이상)** — UI 코드를 스캔·검증하고 개선을 추천. SLDS·SLDS 2 linting, 추천 SLDS tokens 검증, SLDS 2 styling hooks, utility classes를 지원. 신규 버전은 연중 Visual Studio Marketplace에 릴리즈. VS Code에 extension 설치.
- **SLDS Linter (Beta)** — Lightning 컴포넌트를 SLDS 2 준비. Aura·LWC의 CSS·마크업 파일을 검사. pilot/beta service. dev system에서 VS Code 또는 command line으로 실행. (SLDS Linter github repository 참조.)
- **Component Blueprints Updates** — Spring '25에 modals blueprint 업데이트: 닫기 버튼(X)에 흰 배경 표시(저시력자 가시성 개선), 닫기 버튼 색을 흰색→회색으로 변경(`slds-button_icon-inverse` 클래스 제거). 닫기 버튼 마크업에 `slds-button_icon-inverse` 클래스를 사용하지 말 것.

### Lightning Web Security — API Distortion

LWS에 web API용 distortion이 추가되었고, distortion에 매칭되는 ESLint 규칙도 제공된다. (LWS Distortion Viewer에 문서화, 대응 ESLint 규칙은 ESLint 패키지에 포함.)

- **Where:** Lightning Experience(모든 에디션), LWR-based Experience Cloud sites, LWS 활성화 시 Aura sites의 LWC.

신규 distortion이 적용된 API:
- `Document.prototype.requestStorageAccess`
- `Element.prototype.setHTMLUnsafe`
- `HTMLIFrameElement.prototype.sandbox getter`
- `HTMLIFrameElement.prototype.sandbox setter`

변경된 distortion:
- `HTMLIFrameElement.prototype.src setter`
- `Window.open`
- `Window: securitypolicyviolation event`

> 참고: 보안 문서(secure Aura/LWC)가 새 "Security for Lightning Components developer guide"로 통합 이동되었다 (`developer.salesforce.com/docs/platform/lightning-components-security/guide`).

### Native Shadow DOM 전환 — 추가 컴포넌트

Spring '25에서 추가로 native shadow DOM 준비가 완료된 base components와 Aura 카운터파트:

| LWC 컴포넌트 | Aura 대응 (영향받는 base components) |
|---|---|
| `lightning-carousel`, `lightning-carousel-image` | `lightning:carouselImage` |
| `lightning-click-to-dial` | `lightning:clickToDial` |
| `lightning-datatable` | `lightning:datatable` |
| `lightning-file-upload` | `lightning:fileUpload` |
| `lightning-input-field`, `lightning-output-field` | `lightning:inputField`, `lightning:outputField` |
| `lightning-record-form`, `lightning-record-edit-form`, `lightning-record-view-form` | `lightning:recordForm` |
| `lightning-tree` | `lightning:tree` |

native shadow DOM 준비를 위해 적응된 모듈: `lightning/logger`, `lightning/pageReferenceUtils`, `lightning/platformShowToastEvent`.

> 테스트가 protected 내부 DOM 구조에 의존하면 즉시 수정한다. 통합 테스트·Selenium 기반 테스트를 검토하고 UTAM·UTAM Page Objects 사용을 권장한다.

---

## API (v63.0)

도입부: "Get standard platform event for Bulk API V2 query jobs. Update instanced URLs in API calls to prevent service interruptions."

### API v21.0–30.0 폐기 일정 변경

**(Release Update.)** v21.0~30.0 폐기는 처음 Summer '23 예정이었으나 **Summer '25로 연기**되었다. 계속 사용 가능하나 미지원이며 **Summer '25부터 unavailable**이다. 소비 앱은 중단되고, 요청은 "endpoint is deactivated" 에러로 실패한다. legacy API를 사용하는 앱은 breaking change 전에 현재 버전으로 업그레이드한다.

- **영향받는 API 버전 (표기 차이 보존):**
  - **Bulk API:** 21.0, 22.0, 23.0, 24.0, 25.0, 26.0, 27.0, 28.0, 29.0, 30.0 (숫자 형식, "v" 없음)
  - **SOAP API:** 21.0, 22.0, 23.0, 24.0, 25.0, 26.0, 27.0, 28.0, 29.0, 30.0 (숫자 형식, "v" 없음)
  - **REST API:** v21.0, v22.0, v23.0, v24.0, v25.0, v26.0, v27.0, v28.0, v29.0, v30.0 (**"v" 접두 형식**)
- **영향받는 REST API** (`/services/data/vXX.X/` 하위 URI 사용): Bulk API, Connect REST API, IoT REST API, Lightning Platform REST API, Metadata API, Place Order REST API, Reports and Dashboards REST API, Tableau CRM REST API, Tooling API.
- **에디션:** Professional(API access enabled), Enterprise, Performance, Unlimited, Developer. 모든 API-enabled orgs(sandboxes·scratch orgs 포함).

> 이 노트는 폐기 "일정 변경 사실"만 다룬다. **강제 시점·Test Run 절차 등 강제 적용 상세는 → [[Spring '25/Release Updates]].**

### Metadata API 서비스 보호 강화

서비스 건강 보호를 위해 `readMetadata()`·`retrieve()` 요청이 **Winter '25 이후 생성된 신규 org**에서 에러를 반환할 수 있다. 서버가 처리 가능량을 초과한 요청을 받을 때 에러가 발생한다.

- **Where:** Lightning Experience, Salesforce Classic(일부 org 미제공) — Enterprise, Performance, Unlimited, Developer editions.

### Instance URL → My Domain URL 전환

API traffic에 instance-specific URL을 쓰고 있으면 My Domain URL로 교체해야 한다. Salesforce가 instance name 하드코딩 참조 서비스를 폐기한다.

- **Where:** Lightning Experience, Salesforce Classic(일부 org 미제공) — Enterprise, Performance, Unlimited, Developer editions.
- **When (시점):**
  - **샌드박스:** 이 서비스가 **Winter '26에 중지**되며 **2025년 8월부터 시작(starting in August 2025).**
  - **프로덕션:** 이 서비스가 **Spring '26에 중지**되며 **2026년 1월부터 시작(starting in January 2026).**
  - Trust Status → 도메인/instance 검색 → Maintenance 탭에서 메이저 릴리즈 업그레이드 날짜를 확인한다.
- **How:** 예) `https://na44.salesforce.com/services/Soap/class/AcmeDemoService` → `https://acme.my.salesforce.com/services/Soap/class/AcmeDemoService`.

### Bulk API V2 쿼리 Platform Event (Beta) — BulkApi2JobEvent

**(Beta.)** `BulkApi2JobEvent` platform event를 구독해 Bulk API V2 query job의 진행·완료 알림을 수신한다. API polling이나 결과 다운로드 전 job 완료 대기를 회피한다.

- **Where:** **API version 63.0 이상.** API Enabled인 모든 Salesforce edition, sandboxes, scratch orgs.
- **Note:** pilot/beta service.
- **How:** Setup → Quick Find → `User Interface` → User Interface 페이지에서 **Enable Salesforce Platform Bulk API 2.0 Query Partial Download and Job Completion Events (Beta)** 선택 → `BulkApi2JobEvent` 구독.

### OpenAPI Document for sObjects REST API (Beta)

**(Beta.)** 최신 OpenAPI Specification으로 sObjects REST API에 대한 OpenAPI document를 생성한다. updated sObjects 리스트 반환, 짧은 base URI 등의 개선이 있다.

- **Where:** **API version 63.0 이상.** API Enabled인 모든 Salesforce edition, sandboxes, scratch orgs.
- **Note:** pilot/beta service.
- **주요 변경:**
  - `/sobjects/{sObject}/updated`, `/query`, `/query/queryLocator` 리소스 포함
  - API Enabled인 모든 Salesforce edition 지원
  - 짧은 base URI 사용
  - org당 queue 내 requests의 6-hour limit 제거
  - parameterized sObjects spec 사용

---

## 개발 도구

도입부: Salesforce Developer Experience (DX) — Salesforce에서의 custom app development를 위한 개방·통합 경험.

### Agentforce DX (Beta)

**(Beta.)** Agentforce DX beta 릴리즈로, 새 Salesforce CLI commands와 VS Code extension을 포함한다. Salesforce DX 프로젝트에서 직접 agent를 생성·테스트한다. Agentforce DX는 low-code Agent Studio tools(Agent Builder, Testing Center)의 pro-code 등가물이다.

- **Where:** **Salesforce CLI version 2.80.6 이상.**
- **Note:** pilot/beta service.
- **Agentforce DX로 가능한 작업:**
  - **Generate YAML Spec Files** — CLI 명령으로 agent·agent test를 기술하는 YAML spec 생성.
  - **Create Agents and Agent Tests** — spec 파일을 CLI 명령 입력으로 전달해 dev org에 agent·agent test 생성.
  - **Run Agent Tests** — VS Code testing panel 또는 CLI 명령으로 agent test 실행·결과 확인.
  - **Interact with Active Agents** **(Developer Preview)** — CLI 명령으로 active agents와 직접 상호작용. (이 하위 항목만 Developer Preview.)
- **How:** agent CLI commands는 `@salesforce/plugin-agent` Salesforce CLI plugin의 일부다.

```bash
# 플러그인 설치
sf plugins install agent

# Agent YAML 스펙 생성
sf agent generate agent-spec \
    --type customer \
    --role "Field customer complaints and manage employee schedules." \
    --output-file specs/resortManagerAgent.yaml

# Agent 생성
sf agent create \
    --agent-name "Resort Manager" \
    --spec specs/resortManagerAgent.yaml
```

### Salesforce CLI 주요 개선 (v2.53.6+)

Salesforce CLI는 매주 신규 버전을 릴리즈한다. **Salesforce CLI version 2.53.6 이상**의 개선 사항:

- **data 명령어 확장**
  - **Tree:** `data export tree`에 다중 `--query` flag 지정 가능. junction object와 부모를 export하고 `data import tree`로 many-to-many 관계 보존(예: `AccountContactRelation`).
  - **Bulk:** 대용량 데이터셋용 새 명령 `data export|resume bulk`, `data import|resume bulk`, `data update|resume bulk` 추가. 기존 `data delete|upsert bulk`와 함께 Bulk API 2.0의 모든 ingest operation을 CLI로 실행. 완료된 결과는 새 `data bulk results` 명령으로 획득(CLI 또는 Data Loader로 실행된 job 모두 작동).
  - **Query:** 새 `data search` 명령으로 SOSL search 실행. `data query`의 새 `--output-file` flag로 SOQL 결과를 CSV·JSON 파일로 작성.
- **api request (Beta)** — 새 `api request rest`로 org에 authenticated HTTP(REST API) 요청. 새 `api request graphql`로 GraphQL statement 실행.

```bash
sf api request rest 'services/data/v63.0/limits' --target-org my-org
```

```bash
sf api request graphql --body "query accounts { uiapi { query { Account { edges { node { Id \n Name { value } } } } } } }"
```

- **Apex 테스트 커버리지** — `apex get test`의 새 `--detailed-coverage` flag로 이전 실행 Apex test의 상세 커버리지(human-readable만).

```bash
sf apex get test --test-run-id <ID> --code-coverage --detailed-coverage
```

- **Open Agent in Agent Builder** — 새 `org open agent` 명령으로 org Agent Builder UI에서 agent를 연다(`--name`으로 API name 지정).

```bash
sf org open agent --name Coral_Cloud_Agent
```

- **Sandbox 생성 옵션 확장** — `org create sandbox`로 접근 가능한 public group 구성. sandbox definition file에 `activationUserGroupId` 또는 `activationUserGroupName`을 포함(둘 다 아님). 추가로 새 `apexClassName` 옵션(복사 후 실행 Apex class 이름; 이전엔 `apexClassId`만), 새 `--source-id` flag 또는 `sourceId` 옵션(clone할 sandbox ID; 이전엔 `--source-sandbox-name`만).

```json
{
  "sandboxName": "dev1",
  "licenseType": "Developer",
  "activationUserGroupName": "ExpertUsers"
}
```

- **Windows ARM64 지원** — 새 `sf-arm64.exe` installer로 Windows ARM64에 설치.
- **multi-stage output** — `org create scratch` 등 multi-stage 명령의 진행 단계를 출력. 다른 multi-stage 명령: `project deploy start`, `project deploy retrieve`. CI 출력 제어 환경변수: `SF_CI_UPDATE_FREQUENCY_MS`, `SF_CI_HEARTBEAT_FREQUENCY_MS`.
- **better table output** — `org list limits` 같은 tabular 출력 개선. 커스터마이즈 환경변수: `SF_NO_TABLE_STYLE`, `SF_TABLE_OVERFLOW`, `SF_TABLE_BORDER_STYLE`.

> 관련 DX 도구: **Salesforce Extensions for VS Code**(매주 릴리즈), **Code Builder**(웹 기반 IDE), **Agentforce for Developers**(CodeGen·xGen-Code 기반 — Enterprise/Performance/Unlimited/Partner Developer/Developer editions에 default 활성화).

### DevOps Testing GA

**(Generally Available.)** DevOps Testing이 DevOps Center에 AI-powered testing·QA 기능을 제공한다. 여러 test provider 간 test asset을 관리할 필요 없이 test asset의 single source of truth를 제공한다. Salesforce testing tools·partner test providers를 통합하고, quality gates를 설정하며, test suites를 실행하고 결과를 분석한다.

- **Where:** Lightning Experience — Professional, Enterprise, Performance, Unlimited, Developer editions.
- **Who:** DevOps Testing Manager 또는 DevOps Testing User permission set 보유 고객(DevOps Center 접근·권한 필요).
- **How:** AppExchange에서 DevOps Testing managed package 설치 → Setup → Quick Find → `DevOps Testing`.

### Data Mask 개선

- **Use Einstein to Generate Data Mask Custom Libraries** — Einstein으로 custom Data Mask library 값을 생성. **Where:** Lightning Experience, Salesforce Classic(일부 미제공) — Enterprise, Unlimited, Developer editions(Data Mask 설치). **How:** Data Mask → Custom Libraries 탭 → 새 라이브러리 생성·저장 → **Create with Einstein**.
- **Run on Refresh** — 새 데이터 진입과 다음 masking config 실행 사이 downtime을 제거. **Where:** Enterprise, Unlimited, Developer editions(Data Mask 설치).
- **FedRAMP High 인증** — Data Mask가 Public Sector·Government Cloud 포함 모든 high-assurance org(Salesforce Government Cloud Plus)에 승인.

### Database Access Debug Log 카테고리

새 debug log category **Database Access**가 추가되었다. UI에서 접근하는 object의 rule·policy 정보를 로깅해 object 레벨 접근성 문제를 판별한다.

- **Where:** Lightning Experience, Salesforce Classic, 모든 버전 Salesforce app, 모든 에디션.

---

## 개발 환경

### Source Tracking — 특정 Developer Sandbox 활성화

특정 Developer/Developer Pro sandbox에서 source tracking을 켜서 Salesforce DX tooling이 신규·변경 metadata를 식별하게 한다. 활성화 이후 변경만 추적한다. 일부 DX 기능(예: DevOps Center)에 source tracking이 필요하다.

- **Where:** Lightning Experience — Developer 및 Developer Pro sandboxes.
- **When:** **2025년 2월 말(late February 2025)부터 rolling basis로 available.**
- **Who:** View Setup and Configuration AND Customize Applications 권한 보유 사용자.
- **Why:** 이전엔 모든 Developer/Developer Pro sandbox에 활성화 후 새로고침이 필요했으나, 이제 개별 sandbox에 활성화 가능하고 새로고침이 불필요하다.
- **How:** Setup(Developer/Developer Pro sandbox 내) → Sandbox Settings → **Enable Source Tracking in This Sandbox** 켜기.

### Agentforce 포함 Developer Edition org

통합 Salesforce 플랫폼에서 agent·app을 생성한다. 업데이트된 Developer Edition은 무료이며 Agentforce·Data Cloud 접근을 제공한다.

- **Where:** Lightning Experience — Developer Editions.
- **How:** Developer Edition에 가입. Agent Builder에서 AI agents를 빌드·커스터마이즈하고, Data Cloud로 데이터를 harmonize하며, 구조·비구조 데이터로 agents를 강화한다.

### Scalability (Scale Center · ApexGuru GA)

도입부 (PDF Development → Scalability): *"Optimize and test your implementations. Troubleshoot errors, identify issues with application performance, and improve how you scale."* 구현을 최적화·테스트하고, 오류를 트러블슈팅하며 application performance 이슈를 식별하고 scale 방식을 개선한다.

#### Identify Slow Reports, View Decrypted URLs, and Access Scale Center Deep Links — Scale Center GA

**(Scale Center generally available.)** Report Insights 기능은 지난 한 주 동안 어떤 report가 느렸는지 보여준다. Integrations analysis의 Callout summary에 fully decrypted URL이 표시된다. Signature Customer는 CSS Portal의 Technical Health Score (THS)에서 Scale Center deep linking을 본다.

> PDF 원문: *"The Report Insights feature shows you which reports were slow over the last week. Fully decrypted URLs appear in the Callout summary of the Integrations analysis. Signature Customers see Scale Center deep linking in the Technical Health Score (THS) on the CSS Portal."*

- **Where:** Lightning Experience — Unlimited Edition. Scale Center는 Government Cloud Plus에서 미지원. **Scale Center is generally available at no additional cost for all Unlimited Edition Full sandbox, Signature, and Scale Test customers.** org당 Standard(non-SysAdmin) user 5명에 대해 Scale Center를 활성화할 수 있다.

  > PDF 원문: *"Scale Center is generally available at no additional cost for all Unlimited Edition Full sandbox, Signature, and Scale Test customers. You can enable Scale Center for five Standard (non-SysAdmin) users per org."*

- **How:** Setup → Quick Find에 `Scale` 입력 → **Scale Center** 클릭.

#### Optimize Code with ApexGuru — ApexGuru GA

**(ApexGuru generally available.)** Antipattern 탐지 기능이 Apex code를 최적화하고 performance를 개선한다. 루프 내 SOQL query를 확인하고, 비효율적인 query filter·operation을 식별하며, 비용이 큰 string operation·debug statement를 줄이기 위한 권고를 받는다.

> PDF 원문: *"Antipattern detection features optimize Apex code and improve performance. View SOQL queries in loops, identify inefficient query filters and operations, and get recommendations for reducing expensive string operations and debug statements."*

- **Where:** ApexGuru가 활성화된 Full sandbox 및 production 환경. **ApexGuru is generally available at no additional cost for all Unlimited Edition Full Sandbox, Signature, and Scale Test customers.**

  > PDF 원문: *"These updates apply to Full sandbox and production environments with ApexGuru enabled. ApexGuru is generally available at no additional cost for all Unlimited Edition Full Sandbox, Signature, and Scale Test customers."*

- **How:** Setup → Quick Find에 `Scale` 입력 → **Scale Center** 클릭 → Scale Insights로 이동 → **ApexGuru Insights** 클릭.

#### Book Sandbox Slots for Peak Load Testing with Scale Test (동반)

Scale Test로 sandbox instance calendar에 slot을 예약해 production peak load로 테스트한다. business metric·use case·flow에 더 많은 input option이 추가됐다. Trial Accuracy Checker로 production과 동일한 코드를 사용해 sandbox trial run을 생성한다. Test Execution 페이지의 Compare Tests 탭에 Scale Center 링크가 포함된다. (PDF heading에 GA 라벨 없음 — Scale Center/ApexGuru GA의 동반 기능.)

> PDF 원문: *"Book a slot on your sandbox instance calendar and test at production peak load by using Scale Test. Business metrics, use cases, and flows now have more input options. Use Trial Accuracy Checker to create a sandbox trial run by using the same code from production. The Test Execution page now includes a link to Scale Center on the Compare Tests tab."*

- **Where:** Lightning Experience — 모든 에디션. Scale Test는 Singapore를 제외한 모든 Hyperforce region의 Full sandbox 보유 고객에게 제공. 접근하려면 customer success representative 또는 account executive에 문의.
- **How:** Setup → Quick Find에 `Scale` 입력 → **Scale Test** 클릭.

---

## 관련 노트

- [[Spring '25]] — 상위 허브
- [[Spring '25/Release Updates]] — API v21.0–30.0 폐기 강제 시점, LWC Stacked Modals 등
- [[Spring '25/Platform]] — 플랫폼/자동화/통합
- [[Spring '25/Agentforce]] — AI/에이전트
- [[Compression Namespace]] — Spring '25에 GA된 Apex Zip 압축 API
- [[FormulaEval Namespace]] — GA된 동적 수식 평가
- [[Scheduled Apex]] — pauseJobById/resumeJobById
