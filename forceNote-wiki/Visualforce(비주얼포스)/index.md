---
tags: [index, visualforce, vf, legacy]
created: 2026-06-22
---

# Visualforce(비주얼포스) — 로컬 인덱스

> Visualforce Developer Guide v67.0 Summer '26 전수 — Salesforce Classic 기반 태그형 마크업 UI 프레임워크. **Part A**(개념·컨트롤러·동적 VF·JS Remoting·베스트 프랙티스 11노트) + **Part B**(`apex:`/비-`apex:` 표준 컴포넌트 레퍼런스 5노트), 총 16노트.
>
> ℹ️ Visualforce는 레거시 기술이다. 신규 UI 개발은 [[LWC MOC|LWC]]·[[Aura(오라)/index|Aura]] 권장 — 단 PDF 렌더·표준 페이지/버튼 오버라이드·이메일 템플릿·기존 자산 유지보수엔 여전히 유효.

**상위:** [[00 Home]]

---

## Part A — 개념·컨트롤러·확장

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Visualforce 개요 — 도구·퀵스타트]] | Visualforce란?·마크업/컨트롤러 구조·개발 도구(Development Mode)·퀵스타트 예제 (Ch1–3) | #reference |
| [[페이지 출력 제어 — HTML·PDF·SLDS]] | 스타일·SLDS(`apex:slds`·`lightningStylesheets`)·custom doctype/MIME·PDF 렌더(`renderAs="pdf"`·`getContentAsPDF()`) (Ch4) | #reference |
| [[표준 컨트롤러·표준 리스트 컨트롤러]] | 코드 없이 표준 동작 부여 — `standardController`(단일)·`recordSetVar` 표준 리스트 컨트롤러(집합·pagination) | #reference |
| [[커스텀 컨트롤러·컨트롤러 확장|커스텀 컨트롤러·컨트롤러 확장 (Visualforce)]] | Apex로 페이지 로직 직접 구현(custom controller)·확장(extension) — 생성자·action/getter/setter·실행순서·보안·transient·테스트 | #reference |
| [[버튼·링크 오버라이드·Static Resource·커스텀 컴포넌트|Visualforce — 버튼·링크·탭 오버라이드 · Static Resource · 커스텀 컴포넌트]] | 표준 버튼/링크/탭 오버라이드·`$Resource` Static Resource·재사용 `<apex:component>` (Ch9–11) | #reference |
| [[동적 Visualforce — 바인딩·동적 컴포넌트]] | 런타임 결정 — 동적 바인딩(`{!ref[expr]}`·필드 모를 때)·동적 컴포넌트(`Component.Apex.*`·타입 모를 때)·field set | #reference |
| [[이메일·차트·맵·Flow·템플릿|Visualforce — 이메일 · 차트 · 맵 · Flow · 템플릿]] | 이메일 발송·이메일 템플릿·`apex:chart`·`apex:map`·`flow:interview` 임베드·`apex:composition` 재사용 (Ch14–18) | #reference |
| [[Salesforce 앱 개발 — LEX·모바일·AppExchange]] | `one.app` iframe 제약·`sforce.one` 네비게이션·모바일 Known Issues·SLDS·AppExchange managed package VF 제약 (Ch19–20) | #reference |
| [[JavaScript·Remoting·LMS across DOM|JavaScript · Remoting · LMS across the DOM (Visualforce)]] | `$Component` DOM 참조·JS 라이브러리·JavaScript Remoting(`@RemoteAction`)·Lightning message service(`sforce.one`) | #pattern |
| [[Visualforce 베스트 프랙티스]] | View State 관리·성능·컴포넌트·컨트롤러·보안 권고 (Ch23 + Appendix B Security Tips) | #pattern |
| [[Global Variables·함수·표현식 연산자|Visualforce Global Variables · 함수 · 표현식 연산자]] | `{! }` 표현식 — 전역 변수($User·$Action·$Resource 등)·formula 함수 80개·연산자 (Appendix A) | #reference |
| [[Lightning Out — Visualforce·외부 페이지에 LWC 임베드]] | `apex:includeLightning`·`$Lightning.use`/`createComponent`·`ltng:outApp`(styled/Unstyled)·`aura:dependency` 의존성 앱으로 VF·외부 비-Salesforce 페이지에 LWC 임베드 | #reference |
| [[VF AJAX 패턴 → LWC 대응]] | `actionPoller`·`actionFunction`·`actionSupport`·`reRender`·`actionStatus`를 LWC로 이관 — 주기 폴링은 `setInterval`+imperative Apex(해제 `disconnectedCallback`), 가능하면 `lightning/empApi` Platform Events 푸시로 전환 | #migration |
| [[VF → LWC 마이그레이션 전략]] | VF 페이지를 옮길지 남길지 keep-VF 결정 매트릭스(PDF 렌더·이메일 템플릿·표준 오버라이드는 유지)·데이터접근 이관 매핑(`@RemoteAction`→`@AuraEnabled`·RemoteObjects→`uiRecordApi`/wire·standardController→LDS)·leaf-first 점진 전환 전략 | #migration |

---

## Part B — 표준 컴포넌트 레퍼런스 (Ch24)

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[apex 컴포넌트 — 페이지·레이아웃 구조]] | `apex:page`·`pageBlock`·`panel*`·`tabPanel`·`toolbar`·`composition`·`form` 등 페이지 골격·템플릿·레이아웃 23개 + attribute 전수 | #reference |
| [[apex 컴포넌트 — 입력·폼|Visualforce 표준 컴포넌트 레퍼런스 — 입력·폼 (27개)]] | `input*`·`select*`·`commandButton/Link`·`output*`·`pageMessages` 등 입력·폼 27개 + attribute 전수 | #reference |
| [[apex 컴포넌트 — 출력·데이터·반복·차트]] | `dataTable`·`pageBlockTable`·`repeat`·`relatedList`·`chart`·`*Series`·`map` 등 출력·반복·차팅·맵 28개 + attribute 전수 | #reference |
| [[apex 컴포넌트 — AJAX·액션·Remote Objects·기타]] | `action*`(Function/Support/Poller/Region/Status)·`remoteObject*`·`dynamicComponent`·`iframe`·`includeLightning` 등 17개 + attribute 전수 | #reference |
| [[비-apex 표준 컴포넌트 — chatter·support·liveAgent·기타]] | `chatter:*`·`liveAgent`·`support:*`·`messaging:*`·`knowledge:*`·`flow:*`·`wave:*` 등 비-`apex:` 57개 + attribute 전수 | #reference |

---

## 빠른 선택

- Visualforce가 처음이다 / 페이지 만드는 법 → [[Visualforce 개요 — 도구·퀵스타트]]
- VF 페이지를 PDF로 내보내거나 SLDS로 Lightning 정렬 → [[페이지 출력 제어 — HTML·PDF·SLDS]]
- 코드 없이 표준 save/edit/delete/리스트 페이징 → [[표준 컨트롤러·표준 리스트 컨트롤러]]
- Apex로 페이지 로직 직접 구현·표준 컨트롤러 확장 → [[커스텀 컨트롤러·컨트롤러 확장|커스텀 컨트롤러·컨트롤러 확장 (Visualforce)]]
- 표준 버튼/탭을 VF로 오버라이드·정적 리소스·재사용 컴포넌트 → [[버튼·링크 오버라이드·Static Resource·커스텀 컴포넌트|Visualforce — 버튼·링크·탭 오버라이드 · Static Resource · 커스텀 컴포넌트]]
- 런타임에 필드/컴포넌트 결정·fieldset → [[동적 Visualforce — 바인딩·동적 컴포넌트]]
- VF로 이메일·차트·맵·Flow 임베드·페이지 템플릿화 → [[이메일·차트·맵·Flow·템플릿|Visualforce — 이메일 · 차트 · 맵 · Flow · 템플릿]]
- VF를 Lightning Experience·모바일·AppExchange에서 동작 → [[Salesforce 앱 개발 — LEX·모바일·AppExchange]]
- VF에서 JS·Remoting으로 Apex 직접 호출·DOM 경계 통신 → [[JavaScript·Remoting·LMS across DOM|JavaScript · Remoting · LMS across the DOM (Visualforce)]]
- 느린 VF 페이지·view state·보안 최적화 → [[Visualforce 베스트 프랙티스]]
- `{! }` 표현식의 전역 변수·함수·연산자 레퍼런스 → [[Global Variables·함수·표현식 연산자|Visualforce Global Variables · 함수 · 표현식 연산자]]
- VF 페이지나 외부 사이트에 LWC를 임베드 → [[Lightning Out — Visualforce·외부 페이지에 LWC 임베드]]
- `actionPoller`/`actionFunction`/`reRender` 등 VF AJAX를 LWC로 옮기려면 → [[VF AJAX 패턴 → LWC 대응]]
- VF 페이지를 LWC로 옮길지 남길지 결정하고 데이터접근·로직 이관을 매핑하려면 → [[VF → LWC 마이그레이션 전략]]
- 특정 `apex:` 태그 속성을 찾는다 → 레이아웃 [[apex 컴포넌트 — 페이지·레이아웃 구조]] · 입력 [[apex 컴포넌트 — 입력·폼|Visualforce 표준 컴포넌트 레퍼런스 — 입력·폼 (27개)]] · 출력/데이터 [[apex 컴포넌트 — 출력·데이터·반복·차트]] · AJAX [[apex 컴포넌트 — AJAX·액션·Remote Objects·기타]]
- `chatter:`/`liveAgent`/`messaging:`/`knowledge:` 등 비-`apex:` 컴포넌트 → [[비-apex 표준 컴포넌트 — chatter·support·liveAgent·기타]]

---

## 관련 폴더

- 신규 UI 권장 프레임워크 → [[LWC MOC|LWC]] · [[Aura(오라)/index|Aura(오라)]]
- VF 컨트롤러에서 쓰는 Apex 언어/SOQL/보안 → [[Apex MOC|Apex]]
- VF에 임베드하는 Flow → [[Flow MOC|Flow]]
- VF 보안(XSS·CRUD/FLS·CSRF) → [[Security(보안)/index|Security(보안)]]
