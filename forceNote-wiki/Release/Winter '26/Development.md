---
tags: [release, winter_26, development, apex, lwc, api]
api_version: v65.0
release_date: 2025-10
created: 2026-05-17
source: salesforce_winter26_release_notes.pdf (Salesforce Winter '26 Release Notes, Tier 2)
aliases: [Winter '26 Development, 윈터26 개발, v65 Apex 변경, Test Discovery API, Test Runner API, ApexDoc, SLDS 2 GA, TypeScript for LWC, Org-to-org Data Deployment]
---

# Winter '26 — Development (Apex · LWC · API)

> v65.0 개발자 항목 전수. SLDS 2 GA, ApexDoc 표준화, Test Discovery/Runner API(Apex+Flow 통합 실행), abstract/override 접근 제어자, External Services 16MB binary callout, 그리고 Apex/API/LWC New & Changed 카탈로그를 포함한다.

---

## 개요

이 노트는 [[Winter '26]] 릴리즈의 **개발자(Apex·LWC·API)** 영역을 다룬다. v65.0은 파괴적 변경이 적고, 기존 개발 워크플로를 다듬는 GA·신기능이 중심이다.

핵심 흐름:

- **SLDS 2 (GA)** — CSS Styling Hook 기반 새 디자인 시스템 정식 출시. SLDS Linter도 GA.
- **Test Discovery API + Test Runner API** — Apex와 Flow 테스트를 하나의 Tooling REST 뷰에서 탐색·실행. CI/CD 통합용.
- **ApexDoc** — JavaDoc 기반 표준 주석 포맷.
- **abstract/override 접근 제어자 필수** — v65.0+ 컴파일 규칙 변경.
- **External Services binary callout (≤16 MB)** — Apex heap limit 우회.

상위 허브: [[Winter '26]] · 형제 스포크: [[Winter '26/Platform]] · [[Winter '26/Clouds]] · [[Winter '26/Agentforce]] · [[Winter '26/Release Updates]]

> 추출 범위: PDF 인쇄 p.360–471(Development 섹션). v65.0 / Winter '26.

---

## GA (Generally Available)

> PDF에서 "Generally Available" 마커가 명시된 항목은 정확히 **6건**이다. (researcher grep 다형 전수 확인 — fabricate 없음.)

### SLDS 2 (Generally Available)

**SLDS 2**는 agentic design system의 기반이 되는 새 CSS 프레임워크로, 구조(structure)와 테마(theme)를 **styling hooks**(CSS custom properties)로 분리한다. 이제 GA이며 지난 릴리즈 이후 일부 변경이 포함됐다.

GA가 된 이유(PDF 원문 불릿):

- **New architecture** — structure를 visual style에서 decouple → agentic·dark mode의 기반.
- **Styling hooks** — design token 사용을 줄이고 CSS custom properties를 visual language로 우선.
- **Next-gen components** — out-of-the-box Lightning base components를 선호 솔루션으로 강조.
- **Modern web standards** — Aura/Sass 대신 CSS custom properties + direct authoring.
- **Advanced tooling** — SLDS Linter로 검증·마이그레이션·생성.

새 default theme은 **Salesforce Cosmos**다. SLDS 2는 SLDS 1과 backward-compatible하다. 새 org는 이미 SLDS 2일 가능성이 높고, SLDS 1 org는 SLDS Linter + "Transition to SLDS 2" 가이드로 전환한다.

styling hook은 CSS custom property이므로, 컴포넌트 CSS에서 직접 override한다.

```css
/* PDF 원문 발췌 — salesforce_winter26_release_notes.pdf (인쇄 p.379) */
/* This hook provides different values based on density setting */
.my-component {
  padding: var(--slds-g-spacing-var-inline-1);
}
```

> **density-aware styling hooks** — SLDS 2의 density-aware hook은 사용자 display density 설정에 따라 spacing/typography를 자동 조정한다. hook 이름에 `var` 키워드가 포함된다(예: `--slds-g-spacing-var-inline-1`, `--slds-g-spacing-var-1`).

SLDS 2 관련 추가 항목:

- **Visualforce에서 SLDS 2** — Setup > User Interface에서 "Use SLDS 2 for pages that include `<apex:slds>`" 옵션을 켜면 `apex:slds` 컴포넌트를 포함한 Visualforce 페이지가 SLDS 2 스타일로 렌더된다.
- styling hook 변경(GA 후 정리) 상세 — disabled-state hook color contrast, deprecated→replacement 매핑 등 — 은 아래 [#SLDS 2 — Styling Hook 변경](#slds-2--styling-hook-변경-component-design-updates-beta)에서 다룬다.

### SLDS Linter (Generally Available)

**SLDS Linter**가 GA가 됐다. UI 코드를 SLDS 2 규칙에 대조하고, 검증된 제안을 제공하며, 리포지토리 전반에 일괄 fix를 적용한다. beta 이후 여러 new rule이 추가됐다. SLDS Linter 신버전이 자주 릴리즈되므로 "Set Up SLDS Linter" 문서를 참조한다.

### Agentforce DX (Generally Available)

모든 Agentforce DX CLI command와 VS Code extension이 GA다. 단 `agent preview` command는 여전히 **beta**다. `agent create`, `agent test run` 등 Agentforce DX command는 **just-in-time(JIT)**으로 마킹되어, 실행 시 Salesforce CLI가 연관 `plugin-agent` 설치 여부를 확인하고 없으면 자동 설치 후 command를 실행한다.

### Source Mobility (Generally Available)

로컬 Salesforce DX 프로젝트 내에서 소스 파일을 이동할 때 source-tracking이 삭제+재생성으로 오인하지 않는다.

- 기본 활성화. opt-out하려면 새 env var `SF_DISABLE_SOURCE_MOBILITY`를 `true`로(기본 `false`).
- Beta opt-in용 구 env var `SF_BETA_TRACK_FILE_MOVES`는 제거됨.
- 파일 **이동**만 지원하고 이름 변경(rename)은 미지원 — rename은 삭제+생성으로 해석된다.
- child source 파일은 **이름이 동일한 parent로만** 이동 가능(예: custom field는 양쪽 Object 폴더 이름이 같을 때만 다른 package directory로 이동).

### Agentforce Vibes Extension (Generally Available)

구 "Agentforce for Developers" extension이 **Agentforce Vibes Extension**으로 GA가 됐다. MCP server/tool 기반 agentic chat인 Agentforce를 도입해 단순 prompt/suggestion을 넘어 planning·reasoning·multi-step action을 수행한다. (Agentforce Vibes 자체는 CodeGen·xGen-Code 보안 커스텀 AI 모델 기반으로 Enterprise·Performance·Unlimited·Partner Developer·Developer edition에서 **기본 활성화**된다.)

---

## Beta

> Development 본문(인쇄 p.360–419)에서 Beta 마커가 직접 달린 항목 전수. 각 항목엔 "pilot or beta service" 표준 법적 Note가 부착돼 있으나 요약했다. 개별 H3 없이 표로 depth balance를 유지한다.

| # | Beta 기능 | 요약 |
|---|---|---|
| B-1 | **Preview a Single LWC in Your Browser Using Local Dev (Beta)** | 단일 LWC 브라우저 미리보기에서 이제 platform module(public LDS wire adapter, `@salesforce` scoped module, Apex controller) 접근 가능. 이전엔 단일 컴포넌트 미리보기에서 불가했다. |
| B-2 | **Preview a Single LWC in VS Code Using Lightning Preview (Beta)** | Lightning Preview — Local Dev용 신기능. VS Code/Code Builder 안에서 LWC 실시간 미리보기, 로컬 저장 시 자동 업데이트. |
| B-3 | **Simplify Data Interactions with State Management for LWC (Beta)** | state manager로 data와 관련 logic을 앱 내에서 그룹화·관리. prop drilling 감소, data/presentation 분리, 재사용성 향상. |
| B-4 | **Accelerate Development with LWC MCP Tools (Beta)** | natural language prompt로 LWC 개발·테스트·최적화·Aura→LWC 마이그레이션 지원. `lwc-experts` + `aura-experts` toolset. (도구 목록은 아래 절 참조.) |
| B-5 | **SLDS Component Design Updates (Beta)** | SLDS 컴포넌트·styling hook·utility 향상 및 버그 fix. (Dark mode가 beta.) 상세는 아래 절. |
| B-6 | **Customize Your Themes with Dark Mode (Beta)** | Salesforce Starter Suite org에서 SLDS 2 테마 dark mode 활성화. light scheme 반전(밝은 텍스트/어두운 배경), preview mode·accent color 구성. 사용자별 dark/light/시스템 따름 선택. |
| B-7 | **Expose AuraEnabled Controller Methods as Agent Actions (Beta)** | MuleSoft API Catalog 통합으로 Apex `@AuraEnabled` controller 메서드를 agent action으로 노출. Agentforce for Developers extension 필요. OpenAPI 문서 생성(beta). 2025년 9월 제공. |
| B-8 | **Enable AI Assistants to Securely Create Metadata, Tooling and Data Objects (Beta)** | Salesforce API Context MCP server — 2개 tool: Metadata API Context MCP tool(metadata type 컨텍스트·필드 정의·유효값·제약·예제), Tooling and Data API Context MCP tool(API call payload 생성 지원). |
| B-9 | **Expose Custom SOQL in REST API Calls Using Named Query API (Beta)** | Named Query API로 custom SOQL을 REST API client·Salesforce agent용 scalable action으로 정의/노출. 2025-10-06 주 제공. |
| B-10 | **Use Natural Language to Perform Salesforce DX Tasks (Beta)** | Salesforce DX MCP Server(beta). IDE에서 natural language prompt로 metadata 동기화·Apex/agent test 실행·scratch org 생성 등 표준 DX 작업. 60개 이상 MCP tool. |
| B-11 | **Optimize Pages with Lightning Experience Insights (Beta)** | on-demand insight로 org의 LEX 성능 개요. key insight + best practice. 느린 page/component/action 개선 actionable insight. |

> **Beta 개수 메모:** 작업 지시의 "~40건"은 Winter '26 *Development 챕터 전체*(다른 챕터 cross-link 포함) 추정치로 보인다. 본 추출 범위(인쇄 p.360–419 본문)에서 Beta 마커가 직접 달린 항목은 위 **11건**이며, New & Changed 카탈로그 항목엔 Beta 마커가 없다. 근거 없는 추가는 하지 않는다.

---

## Developer Preview

- **TypeScript for LWC (Developer Preview)** — base component의 type definition을 `@salesforce/lightning-types` npm package로 제공한다. 여러 제약이 있으며 "More Type Definitions for Base Components" 본문에서 "TypeScript for LWC is in developer preview"로 명시된다. (See Also: "TypeScript Type Definitions for LWC (Developer Preview)")
- **Org-to-org Data Deployment (Developer Preview)** — ⚠️ 작업 지시에 언급됐으나 **본 추출 범위(인쇄 p.360–471 Development 섹션) 텍스트에는 없다.** 다른 챕터에 위치할 가능성이 있으며, 본 노트에서는 fabricate하지 않고 "Development 범위 내 미발견"으로 둔다.

---

## 본문 신규 기능 (GA/Beta 마커 없는 일반 신기능)

### LWC / Aura

| 기능 | 핵심 |
|---|---|
| **New Lightning Component Reference** | 신 site(`https://developer.salesforce.com/docs/platform/lightning-component-reference`)가 legacy Lightning Component Reference를 대체. LWC+Aura 최신 usage, LWC 예제 live(SLDS 2 Cosmos theme). Go-live 2025-11-04, legacy는 Spring '26에 redirect. |
| **LWC API Version 65.0** | custom component를 v65.0으로 업데이트 권장. **버전별 변경 없음**(no version-specific changes) → 업데이트하기 좋은 릴리즈. 한 번에 한 버전씩 업그레이드 권장. v59.0+는 LWC framework version에 그 값 사용, v58.0↓는 Summer '23(API 58.0) 동작 유지. |
| **Use LWC Components for Local Actions in Screen Flows** | 새 target `lightning__FlowAction`으로 screen flow에서 LWC local action(toast·navigate 등 브라우저 내 직접 실행). 코드는 아래 참조. |
| **Dynamic Boxcar Optimization (Aura)** | Aura의 boxcar'ing(server-side action을 XHR 1개로 그룹화)에 Winter '26부터 **dynamic boxcar optimization** 자동 적용. callback 실행 순서가 바뀔 수 있어 implicit timing dependency가 있으면 오류가 표면화될 수 있다. "Disable Dynamic Boxcar Optimization for Aura Actions"로 비활성화 가능. |
| **Lightning Out 2.0** | custom LWC를 외부 앱에 embed. (beta) Lightning Out supersede. LWR 기반, shadow DOM 내 iframe 캡슐화. SLDS 1/2 styling hook 등 CSS custom attribute override 가능, UI Bridge API 지원. Lightning Out 2.0 App Manager에서 New Lightning Out 2.0 App. |
| **LWS Trusted Mode** | business-critical 3rd-party script를 LWS/Lightning Locker 제약 없이 실행(jQuery·D3 등 global context 라이브러리). 장점: Unrestricted API Access / Full DOM Manipulation / Improved Performance / Enhanced Compatibility. **Important:** Non-SFDC Application 보안 책임은 고객. |
| **API Distortion Changes in LWS** | 신규/변경 distortion: `Window.fetchLater`(new), `HTMLIFrameElement.prototype.src setter`(changed). 매칭 ESLint rule 추가. |

screen flow local action 컴포넌트(config + JS):

```xml
<!-- PDF 원문 발췌 — salesforce_winter26_release_notes.pdf (인쇄 p.365) -->
<?xml version="1.0" encoding="UTF-8"?>
<LightningComponentBundle xmlns="http://soap.sforce.com/2006/04/metadata">
  <apiVersion>65.0</apiVersion>
  <isExposed>true</isExposed>
  <targets>
    <target>lightning__FlowAction</target>
  </targets>
  <targetConfigs>
    <targetConfig targets="lightning__FlowAction">
      <property name="toastTitle" type="String" label="Toast title to display" />
      <property name="toastMessage" type="String" label="Toast message to display" />
    </targetConfig>
  </targetConfigs>
</LightningComponentBundle>
```

```javascript
// PDF 원문 발췌 — salesforce_winter26_release_notes.pdf (인쇄 p.366)
// ⚠️ PDF 페이지 경계에서 invoke() 본문이 잘려 출력됨 — 닫는 중괄호는 // 구조 예시 — 일부 생략
import { api, LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ShowToastExampleComponent extends LightningElement {
  @api toastTitle;
  @api toastMessage;

  @api invoke() {
    this.dispatchEvent(new ShowToastEvent({
      title: this.toastTitle,
      message: this.toastMessage,
    }));
    // 구조 예시 — 일부 생략 (PDF에서 메서드 본문 닫힘이 페이지 경계로 잘림)
  }
}
```

### Apex 본문 신기능

#### Test Discovery API + Test Runner API

새 **Test Discovery API**(Apex+Flow 테스트 통합 뷰)와 업데이트된 **Test Runner API**(Apex와 Flow 테스트를 동일 run으로 실행)가 추가됐다. 둘 다 Tooling API REST resource이며 Setup에서 선언적으로도 실행할 수 있다(v65.0+).

- Setup 권한/페이지: "Application Test Execution" / "View Test History". **Application Test Execution/History** 페이지가 Apex Test Execution/History 페이지를 대체한다. 단 Application Test History는 현재 async Apex test history만 보여주고 flow test history는 아직 미지원이다.
- REST resource·코드는 아래 [#REST / Tooling API — Test Discovery & Runner](#rest--tooling-api--test-discovery--runner) 참조.

#### ApexDoc Comment Format

**ApexDoc** — JavaDoc 기반의 새 표준 주석 포맷. 사람·문서 생성기·AI agent가 코드베이스를 이해하기 쉽도록 특화 tag와 guideline을 제공한다. Apex compiler가 ApexDoc syntax/정확성을 강제하지는 않는다.

```apex
// PDF 원문 발췌 — salesforce_winter26_release_notes.pdf (인쇄 p.383)
public class OpportunityService {
  /**
   * Retrieves a list of open opportunities for a given account.
   * Accessible from Lightning web components. If the set of open opportunities
   * can change during interaction with the component, the author will
   * need to use {@code refreshApex()}.
   * @param accountId The ID of the Account to retrieve opportunities for.
   * @return A List of open Opportunity records. Returns an empty list if no
   * open opportunities are found or if accountId is invalid.
   * @see OpportunitySelector
   */
  @AuraEnabled(cacheable=true)
  public static List<Opportunity> getOpenOpportunities(Id accountId) {
    List<Opportunity> result = new List<Opportunity>();
    //... implementation details...
    return result;
  }
}
```

#### Access Modifiers on Abstract and Override Methods

v65.0+에서 `abstract`·`override` 메서드는 `protected`/`public`/`global` access modifier가 **필수**다. `private`는 불가하며(구현 클래스가 메서드에 접근하지 못함), 지정하지 않으면 compilation error가 발생한다.

```apex
// PDF 원문 발췌 — salesforce_winter26_release_notes.pdf (인쇄 p.384)
// Abstract class
public with sharing abstract class Shape {
  public abstract Double calculateArea();
}
// Extend the class and override the method
public with sharing class Square extends Shape {
  public Double side;
  public Square (Double s) {
    this.side = s;
  }
  public override Double calculateArea() {
    return side * side;
  }
}
```

#### External Service Callouts Without Hitting Apex Heap Limits (≤16 MB Binary File)

External Service에서 large blob을 binary file로 upload/download할 수 있다. 기존엔 Apex heap limit에 묶였으나, 이제 External Services가 응답을 heap에 직접 로드하지 않고 **ContentDocument object ID 포인터**를 사용한다. **binary file 최대 16 MB.** (Enterprise/Performance/Unlimited/Developer.) 한도·가시성은 아래 [거버너 한도 변경](#거버너-한도-변경) 참조.

### API 본문 신기능

| 기능 | 핵심 |
|---|---|
| **OAuth 2.0 Device Flow 제거 (Data Loader)** | 2025-09-02 — auto-installed Data Loader Connected App에서 OAuth 2.0 Device Flow 제거(예외·연장 없음). password 또는 OAuth 2.0 User-Agent Flow로 전환. |
| **SOAP API login() v31.0–64.0 은퇴 (Release Update)** | Summer '27에 SOAP API v31.0–64.0의 `login()` 미지원. external client app으로 마이그레이션 필요. → [[Winter '26]] Release Updates 참조. |
| **Update Instanced URLs in API Traffic (Release Update)** | API traffic이 org My Domain login URL을 사용하도록. Summer '25 최초 → Spring '26 예정 → **Summer '26 연기**. |
| **External Services Limits API 추가** | Limits API에 6개 추가(아래 거버너 한도 참조). v65.0+. |
| **Metadata Deployment 신규 state** | `DeployResult.DeployStatus`에 2개 state 추가: **Finalizing Deploy**, **Finalizing Deploy Failed**. 최종 처리 단계 deployment는 취소 불가(metadata 손상 방지). CLI 자동 업그레이드를 끈 경우 v2.101.5+로 수동 업그레이드(`sf update`). |
| **Metadata Deployment Sizes** | Deployment Settings detail 페이지(Setup > Deploy \| Deployment Settings)에서 파일 수 + total unzipped 크기(bytes) 표시. |
| **SOAP API login() New Orgs에서 기본 비활성** | 신규 org에서 admin이 `login()`을 활성화해야 한다(User Interface > "Enable SOAP API login()"). 활성화해도 v65.0+ `login()`은 unavailable. 2025-11-03 주 enforce. 활성화는 되돌릴 수 없음. |
| **Data Cloud SOQL — MIN/MAX Aggregate** | SOQL이 MIN/MAX aggregate 지원. AVG/SUM/COUNT/MIN/MAX 전부 DLO(data lake object)에서 사용 가능(DMO에 추가). v65.0+. |
| **Enhanced Usage Metrics — Client Field** | `Client` field가 이전엔 값이 있을 때만 표시됐으나 이제 항상 표시. event notification 생산/소비 client 유형 식별. v65.0+. |
| **Data 360 SOQL Semi-Joins** | semi-join 쿼리로 child DMO 속성으로 Salesforce object 필터(outer=parent Salesforce object, inner=직접 관계 child DMO). identity resolution 기반 관계는 불가. v65.0+. |

```sql
-- PDF 원문 발췌 — salesforce_winter26_release_notes.pdf (인쇄 p.395)
SELECT Id, FirstName
FROM Contact
WHERE Id IN (
  SELECT rel_1742409865191_end__c
  FROM EmailEngagement__dlm
  WHERE ssot__Id__c = '...'
)
```

### Packaging

| 기능 | 핵심 |
|---|---|
| **Multilevel Dependencies (2GP/Unlocked)** | direct dependency만 지정하면 indirect(transitive) dependency 자동 계산. `sfdx-project.json`에 `calculateTransitiveDependencies` 파라미터를 `true`로, `dependencies`엔 direct만. `package version displaydependencies` CLI로 계층 그래프 확인. |
| **Revert Released 1GP to Beta** | Managed-Released 1GP 버전을 beta로 되돌리기(version detail page > "Revert to Beta"). 조건: subscriber org 미설치, patch version/org 없음. 설치돼 있으면 먼저 uninstall. |
| **Fully Shift 1GP → 2GP** | 1GP→2GP 완전 전환. 최소 1개 1GP→2GP 변환 후 packaging org Setup > package detail > "Move to 2GP". 새 major/minor 1GP 버전 미생성. |
| **Download Package Metadata for a Version** | 새 `sf package version retrieve` command. 2GP managed 또는 unlocked package version의 metadata retrieve/download. |

```bash
# PDF 원문 발췌 — salesforce_winter26_release_notes.pdf (인쇄 p.397)
sf package version retrieve --package 04tXXX --output-dir my-directory/ --target-dev-hub devhub@example.com
```

> **Note (PDF):** `sf package version retrieve`는 기본적으로 1GP→변환 2GP managed에서 사용 가능. unlocked/순수 2GP managed면 Tooling API `Package2VersionCreateRequest`의 `IsDevUsePkgZipRequested=true` 설정이 필요하다.

### DevOps / Dev Environments / Scalability / 기타

- **DevOps Center MCP Tools** — Salesforce DX MCP Server(beta)에서 merge conflict 해결. LLM 분석/설명/제안, Agentforce Vibes Extension에 preconfigured.
- **Integrate Apex Unit Testing with DevOps Testing** — Apex Unit Testing을 test provider로 추가(quality gate·assign·run·analyze). 2025년 늦은 10월.
- **Integrate Flow Testing with DevOps Testing** — Flow Testing을 test provider로 추가. 2025년 늦은 10월.
- **Create Full Sandboxes Faster with Quick Create** — Hyperforce에서 Full sandbox 생성/refresh 2~3배 빠름(point-in-time snapshot). Manage Sandbox perm, Gov Cloud 제외.
- **Clone All Sandboxes Faster with Quick Clone** — 모든 sandbox type(Developer/Developer Pro/Partial/Full) 지원. Hyperforce 2~3배 빠름, Gov Cloud 제외.
- **Data Export Download Limits** — Data Export 파일 rate limiting. 한 번에 1개, 다운로드 시작 간 **60초 대기** 필수(Summer '25부터). Weekly Data Export perm.
- **Data Mask: Salesforce Seeding & Anonymize** — Data Mask 구매 시 Salesforce Seeding·Anonymize 제품 접근. 2025년 10월.
- **Salesforce Optimizer Has Been Retired** — 이번 릴리즈로 Optimizer app retire.
- **Salesforce Functions Is Being Retired** — 구매/갱신 불가. 기존 order term까지 사용, 대안 배포 필요.
- **Remove Shift_JIS → Windows-31J Character Mapping** — system property `sun.nio.cs.map` 제거(Summer '25 예고). 영향: Apex `EncodingUtil`, Visualforce CSV, External Services. IANA 정의 준수.

**Agentforce DX 하위(CLI/VS Code):**

- `agent activate` / `agent deactivate`(`--api-name` flag), VS Code "SFDX: Activate/Deactivate Agent".
- Preview an Agent in VS Code — active agent와 chat preview, Apex action 오류 시 Debug Mode로 Apex Replay Debugger.
- `agent generate test-spec` — custom evaluation·boilerplate conversation history 추가 prompt(Agentforce Testing API 사용).
- `agent preview --apex-debug` — Apex debug log file 생성.
- Agent Test Results에 invoked action JSON 상세 포함(`--verbose` flag, VS Code "Show Generated Data").

**Salesforce CLI 하위:**

```bash
# PDF 원문 발췌 — salesforce_winter26_release_notes.pdf (인쇄 p.408)
# Run flow tests in your org (JIT plugin-flow)
sf flow run test --target-org my-scratch --class-names Flow1 --class-names Flow2
```

- `flow run test`(org에서 flow test invoke), `flow get test`(async test run 결과).
- Push upgrade: `package push-upgrade schedule` / `abort` / `list` / `report`(unlocked·2GP).
- Multi-App Authentication — `org login web` 재실행 + `--client-app`, `--username`, `--scopes` 신규 flag. `--client-app` string을 `agent preview`에 전달.
- `project deploy start` / `project retrieve start` 성능 향상(커뮤니티 기여).

```bash
# PDF 원문 발췌 — salesforce_winter26_release_notes.pdf (인쇄 p.409)
sf package version displaydependencies --package 04t... --edge-direction root-last --target-dev-hub devhub@example.com
```

```bash
# PDF 원문 발췌 — salesforce_winter26_release_notes.pdf (인쇄 p.409)
sf org refresh sandbox --name devSbx2 --source-sandbox-name devSbx3 --target-org prodOrg
```

**Scalability:**

- **Scale Test** — New Booking 페이지 trial run 입력, Test Reports tab. RPS·throttle·governor limit·user 성장률. Full sandbox(Singapore 제외 Hyperforce region).
- **Scale Center** — 모든 edition + Partner LDV에 무료(Production/Full sandbox). Search Insights, LEX Insights(EPT). Gov Cloud Plus 미지원, org당 5 Standard user.
- **ApexGuru** — 새 Test Cases tab(test class bad practice/filler). 반복 SOQL → Platform Cache 캐싱 탐지. 추가 antipattern(비효율 map, Apex sorting, 데이터 집계에 SOQL 대신 Apex loop) 탐지.

**Change Data Capture:**

- **Receive Change Event Notifications for More Objects** — Industries: `BenefitAssignmentAsset`, `PartyRelationshipGroup`.
- **Include Custom Formula Fields in CDC Events** — change event가 custom formula field 값을 포함. formula field는 ChangeEvent object의 Apex Trigger에서 changed record에는 나타나지 않으며, `changedFields` header property·Avro schema `doc` tag로 식별. (PDF에 General/Cross-object/Time-based/Field-definition-change/Roll-Up Summary별 Yes/No 시나리오 표가 있음 — 본 노트엔 텍스트 요약만; 시나리오별 Yes/No 매핑은 셀 흩어짐으로 PDF 직접 대조 권장.)

**Platform Events:**

- **Event Studio dashboard** — platform event·event relay·LWC가 publish/delivery entitlement에 미치는 영향 insight. Setup > Event Studio > Event Publishers / Event Subscribers.

**Heroku / Functions:**

- **Authorize Salesforce Users for Heroku AppLink with JWT** — Heroku AppLink add-on으로 Salesforce/Data Cloud에 JWT 인증. AppLink SDK로 credential 조회, interactive OAuth 불필요(CI/CD 자동화). Manage Heroku AppLink perm.

---

## SLDS 2 — Styling Hook 변경 (Component Design Updates, Beta)

> SLDS Component Design Updates (Beta)의 styling hook 변경. **매트릭스 추출 주의(Pattern B):** disabled-state hook의 Light/Dark Mode 값 표는 pdftotext에서 hook 이름 열과 값 열이 어긋나게 출력되어, 6행×2열 셀별 정확 매핑을 PDF 텍스트만으로 단정할 수 없다. 따라서 **확정된 unique 값만** 기록하고, 셀 매핑은 공식 SLDS 2 Global Styling Hooks Index 대조를 권장한다.

**disabled-state global styling hook color contrast 업데이트:**

- 영향받은 hook(이름): `--slds-g-color-disabled-1`, `--slds-g-color-ondisabled-1`, `--slds-g-color-ondisabled-2`, `--slds-g-color-disabledcontainer-1`, `--slds-g-color-disabledcontainer-2`, `--slds-g-color-borderdisabled-1`.
- 표에 등장하는 Light/Dark(Beta) Mode 값(unique): `Neutral 20`, `Neutral 30`, `Neutral 50`, `Neutral 60`, `Neutral 80`, `Neutral 90`.
- ⚠️ hook ↔ Light ↔ Dark 셀 매핑은 PDF 추출 한계로 단정하지 않음(공식 SLDS Global Styling Hooks Index 대조 필요).

**deprecated → replacement global styling hook 매핑(검증된 쌍, 전수):**

| Deprecated Hook | Replacement Hook |
|---|---|
| `--slds-g-color-accent-dark-1` | `--slds-g-color-brand-base-20` |
| `--slds-g-color-accent-dark-2` | `--slds-g-color-brand-base-10` |
| `--slds-g-color-accent-light-1` | `--slds-g-color-brand-base-95` |
| `--slds-g-color-accent-light-2` | `--slds-g-color-brand-base-90` |
| `--slds-g-color-brand-base-100` | `--slds-g-color-neutral-base-100` |
| `--slds-g-color-error-base-100` | `--slds-g-color-neutral-base-100` |
| `--slds-g-color-info-base-100` | `--slds-g-color-neutral-base-100` |
| `--slds-g-color-success-base-100` | `--slds-g-color-neutral-base-100` |
| `--slds-g-color-warning-base-100` | `--slds-g-color-neutral-base-100` |
| `--slds-g-font-family` | `--slds-g-font-family-base` |
| `--slds-g-font-lineheight-base` | `--slds-g-font-line-height-base` |
| `--slds-g-font-lineheight-1` | `--slds-g-font-line-height-1` |
| `--slds-g-font-lineheight-2` | `--slds-g-font-line-height-2` |
| `--slds-g-font-lineheight-3` | `--slds-g-font-line-height-3` |
| `--slds-g-font-lineheight-4` | `--slds-g-font-line-height-4` |
| `--slds-g-font-lineheight-5` | `--slds-g-font-line-height-5` |
| `--slds-g-font-lineheight-6` | `--slds-g-font-line-height-6` |

추가 정리:

- SLDS 1 parity 위해 SLDS 2에 추가된 hook: `--slds-g-color-border-disabled-2`, `--slds-g-color-disabled-2`, `--slds-g-color-neutral-base-0`, `--slds-g-font-line-clamp`.
- 새 duration category: `--slds-g-duration-immediately`, `--slds-g-duration-paused` 등.
- `font-lineheight` deprecation → `font-line-height` category 도입(`--slds-g-font-line-height-base`, `--slds-g-font-line-height-4` 등).
- 200%+ zoom 표시 동작 조정 컴포넌트: Docked utility bar, Datepicker, Record header, Popover. Tree grid white box 버그 fix. Modal close button(X) color white→gray(`slds-button_icon-inverse` 클래스 제거, 임시 fix는 Spring '26으로 연기).

**LWC MCP Tools (Beta) — 전체 tool 목록(B-4 상세):** `lwc-experts` + `aura-experts` toolset.

- *LWC Development:* `guide_lwc_development`, `guide_lwc_best_practices`, `create_lwc_component_from_prd`, `orchestrate_lwc_component_creation`, `orchestrate_lwc_component_optimization`, `guide_lwc_accessibility`, `guide_lwc_rtl_support`, `guide_lwc_slds2_uplift_linter_fixes`, `orchestrate_lwc_slds2_uplift`
- *LWC Testing:* `orchestrate_lwc_component_testing`, `create_lwc_jest_tests`, `review_lwc_jest_tests`, `run_lwc_accessibility_jest_tests`
- *Lightning Data Service:* `guide_lds_development`, `guide_lds_data_consistency`, `guide_lds_referential_integrity`, `explore_lds_uiapi`, `guide_lds_graphql`, `explore_lds_graphql_schema`, `create_lds_graphql_read_query`
- *Design/SLDS/Migration/Security:* `guide_figma_to_lwc_conversion`, `guide_design_general`, `verify_aura_migration_completeness`, `guide_lwc_security`
- *aura-experts:* `create_aura_blueprint_draft`, `enhance_aura_blueprint_draft`, `transition_prd_to_lwc`, `orchestrate_aura_migration`

---

## Apex — New and Changed Classes

> PDF "Apex: New and Changed Items" 섹션 전수(인쇄 p.428–432). 요약하지 않고 클래스·메서드·프로퍼티·enum을 모두 옮긴다.

### CommercePayments Namespace

**New Classes (4):**

| 클래스 | 설명 |
|---|---|
| `BankPaymentMethodRequest` | payment gateway에 bank payment method 상세 지정 |
| `BankPaymentMethodResponse` | payment gateway로부터 bank payment method response 상세 retrieve |
| `SaleNotification` | payment gateway로부터 sale payment notification capture |
| `TokenizeNotification` | payment gateway로부터 payment tokenization notification capture |

**New or Changed Methods in Existing Classes (전수):**

| 메서드 | 소속 클래스 | 설명 |
|---|---|---|
| `setAmount(amount)` | `PaymentMethodTokenizationResponse` | tokenization amount 지정 |
| `setAsync(async)` | `PaymentMethodTokenizationResponse` | saved payment method에 async gateway response 표시 |
| `setBankName(bankName)` | `PaymentMethodTokenizationResponse` | tokenization bank name 지정 |
| `setChecksum(checksum)` | `PaymentMethodTokenizationResponse` | gateway 반환 payment unique hash 지정 |
| `setCustomerReference(customerReference)` | `PaymentMethodTokenizationResponse` | gateway 반환 customer reference number 지정 |
| `setGatewayReferenceDetails(gatewayReferenceDetails)` | `PaymentMethodTokenizationResponse` | gateway 반환 추가 reference 상세 지정 |
| `setGatewayReferenceNumber(gatewayReferenceNumber)` | `PaymentMethodTokenizationResponse` | gateway 반환 reference number 지정 |
| `setAsync(async)` | `SaleResponse` | sale payment에 async gateway response 표시 |

**New or Changed Properties in Existing Classes (전수):**

| 프로퍼티 | 소속 클래스 | 설명 |
|---|---|---|
| `bankPaymentMethod` | `PaymentMethodTokenizationRequest` | tokenization용 bank payment method property capture |
| `standardEntryClassCode` | `SaleApiPaymentMethodRequest` | payment method standard entry class code 상세 capture |
| `paymentMethodData` | `SaleRequest` | sale request용 payment method 상세 capture |

**New Enums (4):**

| Enum | 설명 |
|---|---|
| `AccountType` | account type 지정 |
| `AccountHolderType` | account holder type 지정 |
| `BankType` | bank type 지정 |
| `StandardEntryClassCode` | electronic payment transaction type 식별 3-letter code 지정 |

> ⚠️ enum의 개별 **값**은 PDF 본문에 나열되지 않음(이름만). 값은 Apex Reference Guide의 CommercePayments Namespace를 확인한다 — fabricate 금지.

### ConnectApi (Connect in Apex)

**Rate Limit Changes:** per user/namespace/hour rate limit → per org/24-hour Salesforce Platform API rate limit으로 마이그레이션. Summer '24+ org은 이미 적용. 마이그레이션·신규 org은 Chatter가 필요한 method 호출만 per user/namespace/hour rate limit 대상.

**New Connect in Apex Classes — 메서드 전수:**

*Data 360 — `ConnectApi.CdpQuery` 신규 메서드:*

- `getDataGraphData(dataGraphEntityName, id)`
- `getDataGraphData(dataGraphEntityName, id, dataspace)`
- `getDataGraphData(dataGraphEntityName, id, live)`
- `getDataGraphData(dataGraphEntityName, id, dataspace, live)` → Output: `ConnectApi.CdpQueryOutput`
- `getDataGraphDataWithLookupKeys(dataGraphEntityName, lookupKeys)`
- `getDataGraphDataWithLookupKeys(dataGraphEntityName, lookupKeys, dataspace)`
- `getDataGraphDataWithLookupKeys(dataGraphEntityName, lookupKeys, dataspace, noCache)` → Output: `ConnectApi.CdpQueryOutput`
- `getDataGraphMetadata()`
- `getDataGraphMetadata(dataGraphEntityName)`
- `getDataGraphMetadata(dataGraphEntityName, dataspace)` → New output: `ConnectApi.CdpDgMetadata`

*Salesforce CMS — `ConnectApi.ManagedContent` 신규 메서드:*

- `createManagedContentProvider(providerInstanceInput)` → New input `ConnectApi.ManagedContentProviderInstanceInput`, output `ConnectApi.ManagedContentProviderInstance`
- `deleteManagedContentProviderInstance(providerInstanceId)`
- `getManagedContentProviders()` → New output `ConnectApi.ManagedContentProviderCollection`

**Changed Connect in Apex Output Classes (Einstein Search):**

| Output 클래스 | 신규 property | 설명 |
|---|---|---|
| `ConnectApi.SearchResult` | `chunks` | search result용 content chunks |
| `ConnectApi.SearchResult` | `sourceUrl` | record 출처 source URL |
| `ConnectApi.QueryInfo` | `queryId` | search query 추적용 unique identifier |
| `ConnectApi.ScopedSearchResults` | `queryId` | search query 추적용 unique identifier |

**Changed Connect in Apex Enums:**

| Enum | 신규 값 | 설명 |
|---|---|---|
| `ConnectApi.AdjustItemInputRepresentation` | `AmountTaxOnly` | amount 값이 tax-only adjustment |
| `ConnectApi.AdjustItemInputRepresentation` | `ProductOnly` | amount 값이 product-only adjustment |

---

## LWC — New and Changed Items

> PDF "LWC: New and Changed Items" 카탈로그 전수(인쇄 p.420–427).

### Changed Lightning Web Components (전수)

| 컴포넌트 | 변경 내용 |
|---|---|
| `lightning-accordion` | `allow-multiple-sections-open` 변경: section이 1개면 닫을 수 없음(이전엔 false여도 닫힘). |
| `lightning-datatable` | 새 attr `disabled-rows`(key-field 값 list로 row 선택 방지), `hide-borders`(`hide-table-header`와 함께면 border 숨김). 새 cell attr `highlightClass`(row hover/focus 시 column에 SLDS class; custom class 미지원; `class` cell attr 동시 존재 시 `highlightClass`만 적용). |
| `lightning-dual-listbox` | 새 접근성: type-ahead(문자 입력 시 해당 문자로 시작하는 다음 item으로 focus, Ctrl+Space로 선택), 라벨 첫 문자 매칭. 멀티바이트(중/일) 미지원. |
| `lightning-formatted-name` | 새 attr `locale`(name field layout/order 결정; LEX 기본=user personal settings Locale). |
| `lightning-input` | **checkbox**: read-only checkbox는 focusable 아님/상호작용 불가, read-only+required면 asterisk 없음(required 무효), selected read-only는 border 없는 checkmark, unselected read-only는 dotted border 빈 checkbox(접근성: True/False hover text + assistive text). **file**: 더 이상 read-only 아님, `FileList`/`File`/`File` array 할당 가능. **search**: X 버튼 clear & focus 시 `blur`/`change`/`commit` event를 그 순서로 각 1회 fire. 새 attr `time-step-minutes`(date/datetime/time; dropdown 분 간격, 최소 5분, 기본 15분). required type 접근성: required indicator(*) `aria-hidden="true"`. `commit` event: 값이 이전 commit 값과 같으면 미발생. |
| `lightning-input-name` | 새 attr `locale`(위와 동일). |
| `lightning-omnistudio-flexcard` | unique name으로 Flexcard 표시(신규). |
| `lightning-omnistudio-omniscript` | custom component 내 Omniscript 사용(신규). |
| `lightning-output-field` | checkbox field type 변경(`lightning-input` checkbox와 동일 read-only 동작·접근성). |
| `lightning-select` | 새 접근성: validation error message를 `role="status"` element로 렌더, field label을 스크린리더 assistive text로. |
| `lightning-textarea` | 새 접근성: maxlength 도달 시 `role="alert"` assistive text error. read-only면 bottom border만(높이 제어 불가, focus/tab은 가능), `disabled`+`read-only` 동시 적용 시 예기치 않은 동작. |
| `lightning-tree-grid` | 새 attr `disabled-rows`, `hide-table-header`, `hide-borders`(hide-table-header와 함께), `row-toggle-icon`(nested toggle icon 커스터마이즈; collapsed/expanded 각각 또는 공통, 기본 `utility:chevronright`). |

### New and Changed Modules

**New Modules:**

- `lightning/graphql` — UI API enabled object를 GraphQL API로 fetch(현 user의 object/field level security). `lightning/uiGraphQLApi`의 모든 기능 + optional fields + dynamic query construction. Mobile Offline 미지원.
- `lightning/omnistudioPubsub` — custom component가 Flexcard/Omniscript와 publish-subscribe 통신.

**Changed Modules:**

- `lightning/conversationToolkitApi` — 새 메서드 `inactivateConversation(recordId)`(record ID conversation inactivate; 성공 시 true resolve promise, 오류 시 reject).
- `lightning/uiGraphQLApi` — graphql wire adapter + `refreshGraphQL()` 포함. `lightning/graphql`로 superseded, feature update 중단. Mobile Offline 지원 시에만 사용.

### New Targets

- `lightning__FlowAction` — LWC를 screen flow의 local action으로 사용 가능.

### Changed Aura Components (전수)

| 컴포넌트 | 변경 내용 |
|---|---|
| `lightning:datatable` | 새 attr `disabledRows`, `hideTableHeader`(기본 false), `hideBorders`(hideBorders+hideTableHeader=true 시 숨김, 기본 false). 새 cell attr `highlightClass`(LWC와 동일). |
| `lightning:dualListbox` | 접근성(type-ahead, Ctrl+Space, 멀티바이트 미지원) — LWC와 동일. |
| `lightning:input` | checkbox/file/search/date·datetime·time(`time-step-minutes`)/required 접근성/commit 동작 — `lightning-input`과 동일. |
| `lightning:inputName` | 새 attr `locale`. |
| `lightning:outputField` | checkbox field type 변경(동일). |
| `lightning:textarea` | 접근성(maxlength `role="alert"`; `readonly="true"` 시 bottom border만; disabled+readonly 주의). |
| `lightning:treeGrid` | 새 attr `disabledRows`, `hideTableHeader`(기본 false), `hideBorders`(기본 false), `rowToggleIcon`(기본 `utility:chevronright`). |

### Changed Aura Component Events

- `lightning:omniChannelStatusChanged` — 새 event attr `reason`(Omni-Channel user status 변경 이유). 가능 값: `OmniToolkitStatusChange`, `OmniPushTimeout`, `OmniDeclineWork`, `OmniManualStatusChange`, `OmniSupervisorStatusChange`, `OmniLoginStatusChange`.

---

## API — New and Changed Objects

> PDF "API: New and Changed Items" 카탈로그 전수(인쇄 p.433–471).

### New and Changed Objects

**Commerce:**

- `IdentityVerificationEvent`(기존): `Activity` field에 새 picklist 값 `VerifyEmail`.
- 신규 객체: `PaymentCredit`, `PaymentCreditLinePayment`, `PaymentCreditTransaction`.
- `OrderPaymentSummary`(기존): 새 field `PaymentCreditedAmount`.
- `Payment`(기존): 새 field `TotalPaymentCreditApplied`, `NetPaymentCreditApplied`, `TotalPaymentCreditUnapplied`.
- `ReturnOrder`(기존): 새 field `RefundInstructionsHint`.
- `WebStoreInventorySource`(기존): 새 field `ShowGuestInventoryLevel`.
- `OrderSummary`(기존): 새 field `EffectiveDate`.
- **BEHAVIOR CHANGE** `CreditMemo`: `CreditDate` field의 Update property 제거 — v65.0+ 생성 후 갱신 불가.
- `CartItem`(기존): 새 field `AssociatedItemPricing`, `ConfigureDuringSale`, `ProductRelationshipTypeId`, `QtyScaleMethod`.

**Development:**

- `DataMaskCustomValueLibrary`: **BEHAVIOR CHANGE**(v64.0) `ContentType` Update property 제거(생성 후 갱신 불가). **NEW VALUES**(v64.0) `ContentType` field에 `email`, `number`, `phone_number`, `url` 추가(이전엔 `string`만).
- `BackgroundOperation`: **UPDATED VALUES**(v64.0) `Type` field — 추가: `PrivateConnectMigration`, `SingularityMDSSync`, `SingularitySchemaEvolutionTrigger`; 제거: `SingularityMDSSubsetSync`.

**Event Monitoring:** API Total Usage event에 새 field `apiClientCategory`.

**Files:** `ContentDocument`에 새 field `ContentSizeLong`(2GB 초과 파일 관리).

**Sales:**

- 신규 객체 `AiResearchPromptResult`.
- `Event`(기존): 새 read-only field `ActivityRecurrence2Id`, `ActivityRecurrence2ExceptionId`; 새 field `Attendees`(internal use only).
- `EmailMessage`(기존): `Source` field에 새 값 `Migrated Captured Email Header Only`, `Migrated Captured Email`.

**Salesforce Flow:**

- `FlowOrchestration`·`FlowOrchestrationVersion`(기존): `Status` field에 새 값 `UnderReview`.

**Security and Identity:**

- `ExternalEncryptionRootKey`: 지원 function 기술 + query function 예제 개선.
- `ConnectedApplication`(기존): `NamedUserUvidTimeout`·`UvidTimeout` field 새 값 — `60`(1 Hour), `90`(90 Min), `120`(2 Hours), `240`(4 Hours), `480`(8 Hours), `720`(12 Hours).
- 신규 객체: `TenantScrAIPrmptInjection`(prompt injection data), `TenantSecurityAIGtwyUsage`(Einstein gen AI gateway usage), `TenantSecurityConfigAgent`(Agentforce Agent metric). 새 Event Log Objects(standard object에 event 데이터 surface).

**Service (Bring Your Own Channel 다수):**

- `ConversationVendorInfo`(기존): 새 field `CapabiltiesSupportsMultiVendorConfig`(원문 철자 그대로 — "Capabilties") — multiple connector URL. v65.0+, Service Cloud Voice with Partner Telephony.
- 신규 객체 `CustExpIntlTransfSetup`(customer insight data source).
- `ConversationChannelDefinition`(기존): 새 field `EventCapabilitiesIsProgressIndicatorOptExposed`, `EventCapabilitiesIsInboundAcknwOptionExposed`, `EventCapabilitiesIsRoutingWorkResultSupported`, `EventCapabilitiesIsTypingIndicatorOptionHidden`.
- `CustomMsgChannel`(기존): 새 field `EventCapabilitiesIsProgressIndicatorEnabled`, `EventCapabilitiesIsInboundAcknowledgementEnabled`, `EventCapabilitiesIsTypingIndicatorDisabled`.
- **DEPRECATED**(`ConversationChannelDefinition`, v66.0 제거 예정): `IsInboundReceiptsEnabled`→`EventCapabilitiesIsInboundAcknwOptionExposed`; `IsRoutingWorkResultEnabled`→`EventCapabilitiesIsRoutingWorkResultSupported`; `IsTypingIndicatorDisabled`→`EventCapabilitiesIsTypingIndicatorOptionHidden`.
- **DEPRECATED**(`CustomMsgChannel`, v66.0 제거 예정): `HasInboundReceipts`→`EventCapabilitiesIsInboundAcknowledgementEnabled`; `HasTypingIndicator`→`EventCapabilitiesIsTypingIndicatorDisabled`.

### New and Changed Standard Platform Events

- **Commerce:** `WebCartAbandonedEvent`(cart abandon).
- **Industries:** `InsPlcyEndrStatusEvent`(insurance policy endorsement 완료; status Success/Failure + 상세).
- **Service:** `SvcMgmtProacAgntUpdtEvnt`(proactive agent action 업데이트; source record/message type/response status).

### Metadata API (요약)

> 전수 카탈로그(인쇄 p.452–462). 주요 항목 발췌:

- **Salesforce Overall:** REMOVED `enableHelpMenuShowHelp`/`enableHelpMenuShowNewUser`/`enableHelpMenuShowSearch`(UserEngagementSettings); 새 `enableHelpMenuShowSupport`.
- **Customization:** REMOVED `serviceName`(ExternalServiceRegistration) — v65.0+ 미지원.
- **Development:** BrandingSet의 BrandingSetProperty 새 property `ACCENT_CONTAINER_CONTENT_COLOR_1/2/3`(SLDS 2 theme accent container icon/text color). SessionSettings 새 `auraBoxcarReductionPref`(dynamic boxcar optimization 제어).
- **Experience Cloud:** 신규 type `DgtAssetMgmtProvider`, `DgtAssetMgmtPrvdLghtCpnt`.
- **Salesforce Flow:** 신규 type `InvocableActionExtension`; FlowActionCall/StrategyAction의 `InvocableActionType` 새 값 다수(`adjustPartnerInvShipAndDebit`, `getSalesAgreementDetails`, `transformMfgProgramForecasts` 등); FlowDecision 새 field `attributes`(AI conditions); FlowStart 새 field `conditionLogic`/`conditions`(data graph-triggered flow). BEHAVIOR CHANGE: `ExternalSystemChange`를 approval process/orchestration 생성에 사용 가능.
- **Security and Identity:** MyDomainSettings 새 `edgeRoutingMethod`. ExtlClntAppOauthConfigurablePolicies 새 `namedUserJwtSessionTimeoutType`·`guestJwtSessionTimeoutType`; `namedUserJwtTimeout`/`guestJwtTimeout` 새 값 `60/90/120/240/480/720`(1H/90M/2H/4H/8H/12H). BEHAVIOR CHANGE: timeout은 SessionTimeoutType=`Custom`일 때만.
- **Sales:** 신규 `AccountPlanSettings`(v63.0+), `AccountPlanObjMeasCalcDef`(v63.0+), `AccountPlanObjMeasCalcCond`(v63.0+), `AiCoachAgentScnrDefTranslation`(v64.0).
- **Life Sciences Cloud:** 신규 type `LifeSciConfigCategory`, `LifeSciConfigRecord`.

### Other API Surfaces (요약)

- **Connect REST API:** ConnectApi와 동일 rate limit 마이그레이션. Commerce(subscription renew/amend), Data 360(ssot connections/data-model-objects/machine-learning 다수), Salesforce CMS(digital-asset-management-providers), Personalization recommenders 등 신규/변경 resource 다수. 전수 목록은 Connect REST API Developer Guide 참조.
- **CRM Analytics REST API:** Load Connected Dataset Input `mode`(Full/Incremental/PeriodicFull), `preserveCurrencyFields`, `dataspaces`, `namedCredential` 등 request/response body 변경.
- **Reports and Dashboards REST API:** Dashboards Properties(Report component)에 새 `useReportTableSetting`(Boolean). Analytics 다운로드 신규 파라미터 `includeData`, `pageId`, `pageSize`(`A3`/`A4`/`LEGAL`/`LETTER`), `savedViewId`.
- **SOAP API:** `login()` v65.0+ unavailable — HTTP 500 + exception code `INVALID_OPERATION`. v31.0–64.0 `login()`은 Summer '27 은퇴 예정.
- **Tooling API:** REMOVED `serviceName`(ExternalServiceRegistration). Package2VersionCreateRequest 새 field `CalcTransitiveDependencies`. 신규 type `LightningOutApp`(Lightning Out 2.0), `InvocableActionExtension`. Service 신규 object `PresenceDeclineReason`, `PresenceUserConfig`, `QueueRoutingConfig`, `ServiceChannel`, `ServicePresenceStatus`. (Test resource는 아래 절.)
- **User Interface API:** 모든 new standard object auto-enable. UI API 신규 지원(기존 object): `event`, `task`, `ForecastingFact`, `ForecastingQuota`, `ForecastingType`, `FlowOrchestrationLog`, `ServiceAppointmentStatus`. Related List Record Collection에 새 property `columnLabels`, Field에 새 property `digits`.

---

## REST / Tooling API — Test Discovery & Runner

> **Test Discovery API**와 **Test Runner API**는 Tooling API REST resource다. Apex와 Flow 테스트를 동일 run으로 탐색·실행한다(v65.0+).

| Resource | 메서드 | 용도 |
|---|---|---|
| `/services/data/v65.0/tooling/tests/` | `GET` | Apex/Flow test 조회(Test Discovery) |
| `/services/data/v65.0/tooling/runTestsAsynchronous/` | `POST` | Apex+Flow test 비동기 실행 |
| `/services/data/v65.0/tooling/runTestsSynchronous/` | `POST` | Apex+Flow test 동기 실행 |

**Test Discovery — GET 요청·응답:**

요청 예: `GET /services/data/v65.0/tooling/tests?namespacePrefix=my_namespace&pageSize=2`

```json
// PDF 원문 발췌 — salesforce_winter26_release_notes.pdf (인쇄 p.390)
{
  "apexTestClasses": [
    {
      "id": "01pxx0000004UVl",
      "name": "BAAdditionTest",
      "namespacePrefix": "my_namespace",
      "testMethods": [
        { "name": "testNegativeAddition" },
        { "name": "testSimpleAddition" }
      ]
    },
    {
      "id": "01pxx0000004UXN",
      "name": "BABitwiseTest",
      "namespacePrefix": "my_namespace",
      "testMethods": [
        { "name": "testBitwiseAND" },
        { "name": "testBitwiseOR" }
      ]
    }
  ],
  "message": null,
  "nextRecordsUrl": "/services/data/v65.0/tooling/tests?namespacePrefix=my_namespace&pageSize=2&nextRecord=my_namespace.BAComparisonTest",
  "size": 10,
  "testSetSignature": "91a678b54197669171f11eb824d6765a"
}
```

**Test Runner — async 요청 body** (`POST .../tooling/runTestsAsynchronous/`):

```json
// PDF 원문 발췌 — salesforce_winter26_release_notes.pdf (인쇄 p.391)
{
  "tests": [
    {
      "className": "FlowTesting.UpdateAccountDescriptionFlow",
      "testMethods": [
        "UpdateAccountDescriptionFlow_TestAccountDescriptionUpdated"
      ]
    }
  ]
}
```

> async response body = `AsyncApexJobId`. 결과는 `ApexTestRunResult`/`ApexTestResult`로 조회.

**Test Runner — sync 응답 body** (`POST .../tooling/runTestsSynchronous/`):

```json
// PDF 원문 발췌 — salesforce_winter26_release_notes.pdf (인쇄 p.391)
{
  "apexLogId": null,
  "codeCoverage": [],
  "codeCoverageWarnings": [],
  "failures": [],
  "flowCoverage": [],
  "flowCoverageWarnings": [],
  "numFailures": 0,
  "numTestsRun": 1,
  "successes": [
    {
      "id": "07Mxx00000000NyEAI",
      "methodName": "TestAccountDescriptionUpdated",
      "name": "UpdateAccountDescriptionFlow",
      "namespace": null,
      "seeAllData": true,
      "time": 9
    }
  ],
  "totalTime": 1470
}
```

> Tooling API 신규/변경 object 중 Development: `SandboxInfo`의 `IsNonPreview` field(전환 중 non-preview sandbox 생성), `ApexTestResult`의 `TestCategory`/`TestName`/`TestNamespace` field(test category·class·namespace별 결과 쿼리, v65.0 도입).

### GraphQL API

- import path `lightning/uiGraphQLApi` → `lightning/graphql`. 구 path도 동작하나 optional fields·dynamic query construction은 새 path 필요(Mobile Offline 시에만 구 path).
- **Optional fields** — 새 directive `@optional`로 field(parent/child relationship 포함) 마킹. 접근 불가 field가 있어도 query 성공.
- **Dynamic query construction** — `gql` tagged template literal 내 JS string interpolation으로 run-time dynamic query(referential integrity는 자동 보존 안 됨).
- **objectInfos picklist** — `objectInfos`를 새 `objectInfoInputs` argument로 쿼리. metadata만 받으려면 `objectInfoInputs` 생략 또는 `apiName`만 제공.

```graphql
# PDF 원문 발췌 — salesforce_winter26_release_notes.pdf (인쇄 p.468)
query optional {
  uiapi {
    query {
      User {
        edges {
          node {
            Id
            EmployeeNumber @optional {
              value
            }
          }
        }
      }
    }
  }
}
```

```javascript
// PDF 원문 발췌 — salesforce_winter26_release_notes.pdf (인쇄 p.469)
import { LightningElement, track, wire } from 'lwc';
import { gql, graphql } from 'lightning/graphql';
export default class DynamicGraphQLQuery extends LightningElement {
  @track objectName = 'Account';
  get resolvedQuery() {
    return gql`
      query {
        uiapi {
          query {
            ${this.objectName} {
              edges {
                node {
                  Id
                  Name
                }
              }
            }
          }
        }
      }
    `;
  }
  @wire(graphql, { query: '$resolvedQuery', variables: {} })
  result;
  get data() {
    return this.result?.data ? JSON.stringify(this.result.data, null, 2) : '';
  }
}
```

---

## 거버너 한도 변경

> researcher가 `heap`/`governor`/`limit`/`queueable`/`AsyncInfo`/`16 MB` 전수 grep으로 확인한 결과, 본 Development 범위에서 거버너 한도 관련 변경은 **정확히 아래만** 존재한다.

1. **External Services binary callout — heap 우회(≤16 MB)** — heap limit에 묶이지 않고 ContentDocument ID 포인터로 binary file을 upload/download. 수치 한도 변경이 아니라 **heap 우회 메커니즘**이며, binary file 크기 상한은 **16 MB**다.
2. **External Services Limits API 6개 추가** — 외부 서비스 사용량 가시성(v65.0+):

   | OrgLimit |
   |---|
   | `ExternalServicesActiveObjects` |
   | `ExternalServicesActiveOperations` |
   | `ExternalServicesObjectProperties` |
   | `ExternalServicesObjects` |
   | `ExternalServicesOperations` |
   | `ExternalServicesRegistrations` |

   > 참고: External Services **수치 한도 자체의 증가**(활성 오브젝트 1,250→3,000, 활성 오퍼레이션 1,250→3,000, 등록 150→700)는 Admin/Setup 영역에 정리돼 있다 — [[Winter '26]] 의 "External Services" 절 및 [[External Services]] 노트 참조.

3. **Data Export 다운로드 rate limit** — 파일 1개씩, 다운로드 시작 간 60초 대기(거버너 한도가 아니라 다운로드 정책, Summer '25부터).

> **fabrication 방지 확인:** `AsyncInfo`, queueable depth(`getMaximumQueueableStackDepth` 등), heap 수치 한도 관련 변경은 본 릴리즈 Development 범위에 **변경 없음**(grep 0건). 근거 없는 거버너/queueable 수치 한도 변경을 추가하지 않는다.

---

## 관련 노트

- [[Winter '26]] — 상위 허브
- [[Winter '26/Platform]] — 형제 스포크(Admin·Security·Flow·DevOps·Architecture)
- [[Winter '26/Clouds]] — 형제 스포크(Sales·Service·Commerce·Data 360·Analytics·Industries)
- [[Winter '26/Agentforce]] — 형제 스포크(Agentforce·Einstein AI)
- [[Winter '26/Release Updates]] — 형제 스포크(강제 적용 시점 맵)
- [[Winter '26/index]] — 폴더 인덱스
- [[SLDS LWC 디자인 시스템]] — SLDS 2 GA, styling hook, dark mode
- [[테스트 전략]] · [[Flowtesting Namespace]] — Test Discovery/Runner API(Apex+Flow 통합 실행)
- [[Batch Apex]] — Test Discovery/Runner API를 이용한 CI 자동화
- [[External Services]] — binary callout(16MB)·Limits API·한도 증가
- [[Release MOC]]
