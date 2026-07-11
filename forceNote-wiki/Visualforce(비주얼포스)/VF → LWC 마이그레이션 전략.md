---
tags: [visualforce, lwc, migration, decision, strategy, keep-vf, renderAs-pdf]
source: salesforce_pages_developers_guide.pdf (Visualforce Developer Guide, v67.0 Summer '26) — 조합 결정 노트. keep-VF 근거는 [[Salesforce 앱 개발 — LEX·모바일·AppExchange]]·[[페이지 출력 제어 — HTML·PDF·SLDS]](둘 다 Tier 2 동일 PDF)에서 인용, 이관 매핑은 [[VF AJAX 패턴 → LWC 대응]]·[[JavaScript·Remoting·LMS across DOM]] 등 기존 위키 노트를 라우팅
created: 2026-07-11
aliases: [VF to LWC migration, Visualforce to LWC, VF LWC 마이그레이션, 비주얼포스 LWC 전환, keep VF, VF 유지 결정, VF 이관 전략, leaf-first VF, renderAs pdf 유지 결정]
---

# VF → LWC 마이그레이션 전략

> Visualforce 페이지를 Lightning Web Component로 옮길지 **VF로 남길지 결정**하고, 옮기기로 한 것의 데이터접근·로직을 LWC로 매핑하며, 공존 상태에서 leaf-first로 점진 전환하는 **결정·매핑·전략** 노트 — 개별 메커니즘 상세는 각 패턴 노트에 위임한다.

> [!note] 레거시 안내 — Visualforce는 Salesforce Classic 기반 레거시 마크업 프레임워크다. 신규 UI는 LWC 우선이지만, VF에는 LWC로 대체 불가한 서버측 기능(PDF 렌더·이메일 템플릿)이 남아 있어 "전부 옮긴다"가 항상 옳은 답은 아니다. 이 노트는 그 경계를 정의한다.

---

## 이 노트의 소관 (위임 경계)

이 노트는 **"무엇을 남기고, 무엇을 어떻게 옮기고, 어디부터 옮기나"** 라는 결정·매핑·순서만 다룬다. 각 항목의 메커니즘 본문은 다음 노트가 보유한다.

| 위임 주제 | 소관 노트 |
|---|---|
| `apex:actionPoller`·`actionFunction`·`actionSupport`·`reRender`·`actionStatus` 이관 | [[VF AJAX 패턴 → LWC 대응]] |
| `@RemoteAction`·Remote Objects·JavaScript Remoting 원본 동작 | [[JavaScript·Remoting·LMS across DOM]] |
| 공존기 VF↔LWC DOM 통신 (LMS `sforce.one` / `$MessageChannel`) | [[JavaScript·Remoting·LMS across DOM]] · [[Lightning Message Service]] |
| VF 페이지에 LWC 임베드 (공존기 렌더) | [[Lightning Out — Visualforce·외부 페이지에 LWC 임베드]] |
| `renderAs="pdf"`·`getContentAsPDF()` PDF 렌더 메커니즘 | [[페이지 출력 제어 — HTML·PDF·SLDS]] |
| 모바일/LEX 컨테이너 제약·미지원 컴포넌트 전수 | [[Salesforce 앱 개발 — LEX·모바일·AppExchange]] |
| LWC 측 Apex 호출(wire/imperative)·LDS 데이터 접근 | [[Wire vs Imperative 선택]] · [[getRecord 패턴]] · [[uiRecordApi]] |

> 대칭 참조: 이 노트는 [[Aura → LWC 마이그레이션]]·[[Aura vs LWC]]의 결정 노트 구조를 따르되, 프레임워크 짝이 다르다. Aura↔LWC는 **같은 Lightning 런타임·상호운용 레이어**를 공유하지만, VF↔LWC는 **서버 렌더링(POSTBACK·view state) ↔ 클라이언트 렌더링**이라는 근본 모델 전환이라는 점이 핵심 차이다.

---

## (a) keep-VF 결정 매트릭스 — 언제 VF를 남기나 vs 옮기나

먼저 **"전부 LWC로 옮긴다"가 항상 옳지 않다.** LWC에 **직접 등가가 없는 서버측 VF 기능**이 있기 때문이다. 아래는 남길지/옮길지 결정 기준이다.

| VF 기능 | 결정 | 근거 (Tier 2) |
|---|---|---|
| **PDF 렌더** (`<apex:page renderAs="pdf">` · `PageReference.getContentAsPDF()`) | ✅ **VF 유지** | LWC에는 서버측 PDF 렌더링 서비스에 대응하는 API가 없다. VF의 PDF 렌더는 문서·이메일 첨부·Chatter post 생성의 정본 경로. → [[페이지 출력 제어 — HTML·PDF·SLDS]] §7 |
| **Visualforce 이메일 템플릿** | ✅ **VF 유지** | 이메일 템플릿은 VF 마크업 기반이며 LWC는 이메일 템플릿 렌더 대상이 아니다. → [[이메일·차트·맵·Flow·템플릿]] |
| **표준 버튼/페이지 오버라이드 일부** | ⚠️ **조건부 유지** | 일부 오버라이드는 VF만 지원. 앱(모바일)에서는 **표준 list/tab 컨트롤 오버라이드가 미지원**이고, 오버라이드 VF에 "Available for Lightning Experience…" 옵션이 없으면 버튼이 사라진다. → [[Salesforce 앱 개발 — LEX·모바일·AppExchange]] §5.1 |
| **모바일 앱 컨텍스트의 PDF·구조 컴포넌트** | ❌ **VF로 두더라도 모바일에선 못 씀** | 모바일 앱 컨테이너는 `renderAs="PDF"`, `<apex:relatedList>`·`<apex:enhancedList>` 등을 **미지원**. 모바일 UX가 목표면 오히려 LWC로 옮겨야 한다. → 미지원 컴포넌트 전수는 [[Salesforce 앱 개발 — LEX·모바일·AppExchange]] §8.1 |
| **인터랙티브 UI·폼·목록·레코드 편집** | ➡️ **LWC로 이관** | 반응형·모바일·오프라인·Jest 테스트·표준 웹 기술의 이점. 신규 기능은 무조건 LWC ([[Aura vs LWC]]의 "Always choose LWC" 원칙과 동일) |
| **뷰스테이트 왕복이 성능 병목인 페이지** | ➡️ **LWC로 이관** | VF는 `<apex:form>`·`<apex:inputField>`가 매 요청 view state를 왕복시켜 응답을 늦춘다. LWC는 데이터만 주고받아 이 왕복이 없다 |

> ⚠️ keep-VF 근거의 두 축은 **"LWC에 등가 API가 없다"**(PDF·이메일 템플릿)와 **"플랫폼이 오버라이드를 VF로만 받는다"**(표준 버튼 오버라이드 일부)다. 이 둘이 아니라면 기본값은 **LWC로 이관**이다. "지금 잘 돌아가니 그냥 둔다"는 유지 사유가 아니다 — [[Aura vs LWC]]의 "Aura 유지보수 함정"과 동형으로, VF에 기능을 계속 얹으면 전환 비용만 누적된다.

---

## (b) 데이터접근·로직 이관 매핑

옮기기로 한 페이지의 서버 연동을 LWC 모델로 바꾼다. VF의 **서버 중심 4종 데이터 경로**(standardController · 커스텀 컨트롤러 · `@RemoteAction` · Remote Objects)가 LWC의 **wire/imperative + LDS** 로 재편된다.

| Visualforce 데이터/로직 | LWC 대응 | 소관 노트 |
|---|---|---|
| `standardController="Account"` (레코드 CRUD 자동 바인딩) | **LDS** — `@wire(getRecord)` / `lightning-record-form` | [[getRecord 패턴]] · [[LDS 개념 (Lightning Data Service)]] · [[Record Form 선택]] |
| **커스텀 컨트롤러 / 컨트롤러 확장 로직** | **`@AuraEnabled` Apex** (import 후 wire 또는 imperative) | [[@salesforce Modules 레퍼런스]] · [[Wire vs Imperative 선택]] |
| **`@RemoteAction`** (JS에서 직접 Apex AJAX 호출) | **`@AuraEnabled` + imperative** Apex import | [[Imperative 호출 패턴]] · (VF 원본 [[JavaScript·Remoting·LMS across DOM]]) |
| **Remote Objects** (`<apex:remoteObjects>` · `SObjectModel` CRUD) | **`uiRecordApi`** (`createRecord`/`updateRecord`/`deleteRecord`) 또는 `@wire(getRecord)` | [[uiRecordApi]] · [[getRecord 패턴]] |
| **view state** (`<apex:form>` 서버 상태 왕복) | **반응형 프로퍼티** (클라이언트 상태 — 서버 왕복 없음) | (아래 코드 예시) |
| **`actionFunction` / `reRender`** (JS 트리거 서버 액션 + 부분 리렌더) | **imperative 호출 + 자동 반응형 리렌더**, 서버 재조회는 `refreshApex()` | [[VF AJAX 패턴 → LWC 대응]] (전수 매핑) |
| 공존기 VF↔LWC 통신 (`sforce.one` / `$MessageChannel`) | **Lightning Message Service** (`lightning/messageService`) | [[Lightning Message Service]] |

### 매핑 예시 — `@RemoteAction` → `@AuraEnabled` imperative

```javascript
// 구조 예시 — 실제 동작 코드 아님 (시그니처·모델 대조용, 전수 패턴은 위임 노트 참조)
// [BEFORE] Visualforce — @RemoteAction + JS remoting 호출 + callback
//   Apex:  @RemoteAction global static Account getAccount(String name) { ... }
//   Page:  Visualforce.remoting.Manager.invokeAction(
//            '{!$RemoteAction.AccountRemoter.getAccount}', name,
//            function(result, event){ if(event.status){ /* result 사용 */ } });

// [AFTER] LWC — @AuraEnabled Apex를 import 후 imperative 호출 (Promise)
//   Apex:  @AuraEnabled(cacheable=true) public static Account getAccount(String name) { ... }
import getAccount from '@salesforce/apex/AccountController.getAccount';

export default class AccountViewer extends LightningElement {
    account;                                    // 반응형 프로퍼티 = VF view state 대체

    async handleSearch(name) {
        this.account = await getAccount({ name }); // apex:param 순서 → 이름 있는 인자 객체
    }                                            // 대입만으로 참조 부분 자동 리렌더 (reRender 불필요)
}
```

> **핵심 전환 3가지.** ① `@RemoteAction`의 status/exception 분기 callback → **Promise** `.then()/.catch()`(또는 `async/await`). ② `apex:param` **순서 바인딩** → **이름 있는 인자 객체**. ③ `reRender="target"`으로 지정하던 부분 갱신 → **반응형 프로퍼티 대입만으로 자동**. 오버로딩 금지·`static`·`global/public` 같은 `@RemoteAction` 제약은 이관 후 사라지고, 대신 `@AuraEnabled`(캐시 원하면 `cacheable=true`) 규칙을 따른다.

---

## (c) 단계적 이관 전략 — leaf-first + VF 셸 유지

[[Aura → LWC 마이그레이션]]의 leaf-first 원칙과 **일관**되게, VF도 **한 번에 한 조각씩 공존 상태에서** 옮긴다. 단 VF는 Aura와 포함방향 제약이 다르므로 순서 결정 기준도 다르다.

### 순서 결정 — 무엇부터 옮기나

1. **독립적 leaf 화면부터.** 다른 VF 페이지·컨트롤러 상태에 얽히지 않은 **말단 기능**(단일 폼·조회 위젯·목록 카드)을 먼저 LWC로 만든다. view state·`@RemoteAction` 결합이 적을수록 이관 리스크가 낮다.
2. **페이지 레이아웃에 임베드된 VF 조각.** 레코드 상세에 얹힌 VF 인라인 페이지는 LWC 컴포넌트로 교체하고 App Builder로 배치. LDS(`getRecord`)로 standardController 데이터 접근을 대체한다.
3. **컨테이너/탭 수준 페이지는 마지막.** 여러 자식 기능을 묶는 상위 VF 페이지는 그 아래 조각이 전부 LWC로 바뀐 뒤에 옮긴다.

### 무엇을 남기나

위 **(a) keep-VF 매트릭스**에서 ✅로 판정된 것(PDF 렌더·이메일 템플릿·필수 오버라이드)은 **옮기지 않고 VF 셸로 유지**한다. 즉 마이그레이션의 목표는 "VF 0개"가 아니라 **"인터랙티브 UI는 LWC, 서버측 문서 생성은 VF"** 로 소관을 가르는 것이다.

### 공존기 통신 — VF와 LWC를 어떻게 잇나

전환 중에는 VF와 LWC가 한 org·한 Lightning 페이지에 함께 산다. 두 가지 연결 경로가 있고, 둘 다 소관 노트에 위임한다.

| 공존 시나리오 | 방법 | 위임 |
|---|---|---|
| **한 Lightning 페이지 안에서 VF↔LWC가 데이터를 주고받아야 함** (형제·원거리) | **Lightning Message Service** — VF는 `sforce.one.publish/subscribe` + `$MessageChannel`, LWC는 `lightning/messageService`. 같은 채널, 다른 API 표면 | [[JavaScript·Remoting·LMS across DOM]] · [[Lightning Message Service]] |
| **아직 남은 VF 페이지 안에서 새 LWC를 렌더** (부모 VF ⊃ 자식 LWC) | **Lightning Out** — `apex:includeLightning` + `ltng:outApp` 의존성 앱 + `$Lightning.createComponent`. 속성·메서드·이벤트는 표준 DOM API로 상호운용 | [[Lightning Out — Visualforce·외부 페이지에 LWC 임베드]] |

> ⚠️ **LMS는 iframe 안 VF에서 동작하지 않는다** — `<apex:iframe>`·표준 `<iframe>`으로 LEX에 임베드된 VF 페이지, Salesforce Classic, Setup 미리보기에서는 LMS가 동작하지 않는다. 공존 통신을 설계하기 전 이 제약을 확인한다 (전수는 [[JavaScript·Remoting·LMS across DOM]]의 "LMS in VF — Considerations and Limitations").

---

## Aura 마이그레이션과의 대조 (한눈에)

| 축 | Aura → LWC | VF → LWC (이 노트) |
|---|---|---|
| 근본 관계 | 같은 Lightning 런타임·상호운용 레이어 공유 | **서버 렌더링(POSTBACK·view state) → 클라이언트 렌더링** 모델 전환 |
| 포함 방향 | Aura ⊃ LWC (역불가) → leaf-first 강제 | VF ⊃ LWC (Lightning Out) → leaf-first 권장 |
| 데이터 경로 전환 | `@AuraEnabled` Apex 유지 (wire/imperative) | standardController/`@RemoteAction`/Remote Objects → LDS + wire/imperative |
| "남기는" 사유 | LWC 미지원 기능 필요 시에만 | **PDF 렌더·이메일 템플릿·필수 오버라이드**(LWC 등가 API 부재) |
| 공존 통신 | 부모-자식 임베딩 / LMS | Lightning Out / LMS(`sforce.one`) |

---

## 관련 노트

- [[Aura → LWC 마이그레이션]] — 대칭 결정 노트 (프레임워크 짝은 다름 — Aura는 런타임 공유, VF는 모델 전환)
- [[Aura vs LWC]] — "Always choose LWC" 원칙·leaf-first 순서의 원본
- [[VF AJAX 패턴 → LWC 대응]] — `actionPoller`·`actionFunction`·`actionSupport`·`reRender`·`actionStatus` 이관 전수 (이 노트가 위임)
- [[JavaScript·Remoting·LMS across DOM]] — `@RemoteAction`·Remote Objects·`sforce.one` LMS 원본 메커니즘
- [[Lightning Out — Visualforce·외부 페이지에 LWC 임베드]] — 공존기 VF 안에 LWC 렌더
- [[Lightning Message Service]] — 공존기 VF↔LWC 크로스 DOM 통신 (LWC 측 API)
- [[페이지 출력 제어 — HTML·PDF·SLDS]] — `renderAs="pdf"`·`getContentAsPDF()` (keep-VF 근거 ①)
- [[Salesforce 앱 개발 — LEX·모바일·AppExchange]] — 모바일 미지원 컴포넌트·표준 오버라이드 제약 (keep-VF 근거 ②·③)
- [[Wire vs Imperative 선택]] · [[getRecord 패턴]] · [[uiRecordApi]] · [[@salesforce Modules 레퍼런스]] — LWC 측 데이터접근 대응
- [[이메일·차트·맵·Flow·템플릿]] — VF 이메일 템플릿 (keep-VF)
