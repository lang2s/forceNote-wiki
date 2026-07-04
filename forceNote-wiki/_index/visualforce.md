---
tags: [index, search, navigation, visualforce]
created: 2026-06-22
---

# SEARCH INDEX — Visualforce(비주얼포스) (Visualforce Developer Guide v67.0 Summer '26)
> Visualforce — Salesforce Classic 기반의 태그형 마크업 UI 프레임워크(레거시). 개념·컨트롤러·동적 VF·JS Remoting·베스트 프랙티스 11노트(Part A) + `apex:`/비-`apex:` 표준 컴포넌트 레퍼런스 5노트(Part B), 총 16노트.
> 루트 라우터: `00 SEARCH_INDEX.md` · 다른 샤드는 라우터에서 이동.
>
> ℹ️ Visualforce는 레거시 기술이다. 신규 UI 개발은 LWC(`_index/frontend.md`)·Aura 권장 — 단 PDF 렌더·표준 페이지/버튼 오버라이드·이메일 템플릿·기존 자산 유지보수엔 여전히 유효.

---

## Part A — 개념·컨트롤러·확장 (11노트)

### 개요·도구·퀵스타트

| 키워드 | 파일 |
|---|---|
| Visualforce 개요, apex:page, Visualforce 퀵스타트, VF 개발 도구, Development Mode, Visualforce vs LWC, 마크업 컨트롤러 구조, Visualforce가 뭐야, Visualforce 페이지 처음 만들기, VF 페이지 시작하기 | `Visualforce(비주얼포스)/Visualforce 개요 — 도구·퀵스타트.md` |

### 페이지 출력 제어 — HTML·PDF·SLDS

| 키워드 | 파일 |
|---|---|
| renderAs pdf, PageReference.getContentAsPDF, Visualforce PDF 렌더링, lightningStylesheets, apex:slds, docType contentType, custom doctype, MIME type, Visualforce 스타일링, VF에서 PDF 만들기, Visualforce 페이지를 PDF로, VF SLDS 적용하는 법 | `Visualforce(비주얼포스)/페이지 출력 제어 — HTML·PDF·SLDS.md` |

### 컨트롤러

| 키워드 | 파일 |
|---|---|
| standardController, recordSetVar, 표준 컨트롤러, 표준 리스트 컨트롤러, Standard Controller, Standard List Controller, Visualforce pagination, 페이지네이션, 리스트뷰 필터, save edit delete 내장 동작, 코드 없이 VF 페이지 만들기, 표준 컨트롤러로 리스트 페이징 | `Visualforce(비주얼포스)/표준 컨트롤러·표준 리스트 컨트롤러.md` |
| 커스텀 컨트롤러, 컨트롤러 확장, custom controller, controller extensions, with sharing Visualforce, transient, read-only mode, 생성자 규약, action getter setter, VF에 Apex 로직 붙이기, 표준 컨트롤러 확장하는 법, Visualforce 커스텀 페이지네이션 | `Visualforce(비주얼포스)/커스텀 컨트롤러·컨트롤러 확장.md` |

### 오버라이드·재사용·동적·통합

| 키워드 | 파일 |
|---|---|
| Visualforce 오버라이드, 버튼 링크 탭 오버라이드, Static Resource, $Resource, URLFOR, apex:component, 커스텀 Visualforce 컴포넌트, 표준 버튼 VF로 바꾸기, 정적 리소스 참조, 재사용 컴포넌트 만들기, VF 페이지로 버튼 오버라이드 | `Visualforce(비주얼포스)/버튼·링크 오버라이드·Static Resource·커스텀 컴포넌트.md` |
| 동적 Visualforce 바인딩, 동적 컴포넌트, dynamic binding, dynamic component, Component.Apex, reference[expression], field set, fieldset, 런타임에 필드 결정, 객체 타입 모를 때 VF, 동적으로 컴포넌트 생성, VF에서 fieldset 쓰기 | `Visualforce(비주얼포스)/동적 Visualforce — 바인딩·동적 컴포넌트.md` |
| Visualforce 이메일 템플릿, messaging emailTemplate, apex:chart, apex:map, flow:interview, apex:composition, apex:include, 템플릿 재사용, VF로 이메일 보내기, Visualforce 차트, VF에 Flow 임베드, VF 이메일 템플릿 만들기 | `Visualforce(비주얼포스)/이메일·차트·맵·Flow·템플릿.md` |
| Visualforce Lightning Experience, sforce.one, one.app iframe, VF 모바일 앱, Salesforce 모바일 앱 확장, AppExchange managed package VF, CSP 도메인, 커스텀 액션, VF를 모바일에서 쓰기, Lightning Experience에서 Visualforce, VF AppExchange 패키지 제약 | `Visualforce(비주얼포스)/Salesforce 앱 개발 — LEX·모바일·AppExchange.md` |
| JavaScript Remoting, @RemoteAction, Visualforce.remoting.invokeAction, $Component, JS 라이브러리 포함, includeScript, Lightning message service, sforce.one publish subscribe, LMS across DOM, VF에서 Apex 메서드 직접 호출, Remoting으로 비동기 호출, VF DOM 경계 통신 | `Visualforce(비주얼포스)/JavaScript·Remoting·LMS across DOM.md` |
| Visualforce 베스트 프랙티스, View State 관리, view state 줄이기, VF 성능 최적화, Visualforce 보안 팁, transient 키워드, VF 컨트롤러 모범사례, Visualforce 페이지 느릴 때, 뷰 스테이트가 너무 클 때, VF 보안 권고 | `Visualforce(비주얼포스)/Visualforce 베스트 프랙티스.md` |
| Visualforce Global Variables, $User, $Action, $Resource, $ObjectType, $Label, $Setup, VF 표현식 함수, formula 함수, VF 연산자, 머지 필드, expression operators, VF 표현식에서 쓸 수 있는 변수, $Action 종류, Visualforce formula 함수 목록 | `Visualforce(비주얼포스)/Global Variables·함수·표현식 연산자.md` |
| Lightning Out, apex:includeLightning, $Lightning.use, $Lightning.createComponent, ltng:outApp, ltng:outAppUnstyled, aura:dependency, LWC in Visualforce, Lightning components for Visualforce, embed LWC in VF page, embed LWC external site, lightningEndPointURI, authToken, VF에 LWC 임베드, Visualforce에서 LWC 사용, 라이트닝 아웃, 외부 웹페이지에 LWC 넣기, 의존성 앱, VF와 LWC 상호운용, Visualforce에서 LWC 메서드 호출·이벤트 수신, VF에 라이트닝 웹 컴포넌트 임베드하는 법, 비-Salesforce 사이트에 LWC 올리기 | `Visualforce(비주얼포스)/Lightning Out — Visualforce·외부 페이지에 LWC 임베드.md` |

---

## Part B — 표준 컴포넌트 레퍼런스 (5노트)

### apex: 네임스페이스 컴포넌트

| 키워드 | 파일 |
|---|---|
| apex:page, apex:pageBlock, apex:pageBlockSection, apex:panelGrid, apex:panelBar, apex:tabPanel, apex:toolbar, apex:composition, apex:insert, apex:define, apex:form, 페이지 레이아웃 컴포넌트, 페이지 골격 템플릿, 23개 컴포넌트, VF 페이지 구조 태그, pageBlock 쓰는 법 | `Visualforce(비주얼포스)/apex 컴포넌트 — 페이지·레이아웃 구조.md` |
| apex:inputField, apex:inputText, apex:inputTextarea, apex:selectList, apex:selectOption, apex:selectRadio, apex:selectCheckboxes, apex:commandButton, apex:commandLink, apex:outputField, apex:outputText, apex:outputLabel, apex:pageMessages, 입력 폼 컴포넌트, 27개 입력 컴포넌트, VF 폼 만들기, inputField vs inputText | `Visualforce(비주얼포스)/apex 컴포넌트 — 입력·폼.md` |
| apex:dataTable, apex:pageBlockTable, apex:repeat, apex:column, apex:dataList, apex:relatedList, apex:chart, apex:barSeries, apex:lineSeries, apex:pieSeries, apex:map, apex:mapMarker, 출력 데이터 반복 차트, 28개 컴포넌트, VF 테이블 만들기, repeat 반복 출력, Visualforce 차트 컴포넌트 | `Visualforce(비주얼포스)/apex 컴포넌트 — 출력·데이터·반복·차트.md` |
| apex:actionFunction, apex:actionSupport, apex:actionPoller, apex:actionRegion, apex:actionStatus, apex:remoteObjects, apex:remoteObjectModel, apex:remoteObjectField, apex:dynamicComponent, apex:canvasApp, apex:scontrol, apex:stylesheet, apex:includeScript, apex:includeLightning, apex:slds, apex:flash, apex:iframe, AJAX 액션 컴포넌트, Remote Objects, 17개 컴포넌트, VF 부분 새로고침, 폴링으로 자동 갱신 | `Visualforce(비주얼포스)/apex 컴포넌트 — AJAX·액션·Remote Objects·기타.md` |

### 비-apex: 네임스페이스 컴포넌트

| 키워드 | 파일 |
|---|---|
| chatter:feed, chatter:follow, chatter:userPhotoUpload, chatteranswers, liveAgent 컴포넌트, support:caseFeed, support:portalPublisher, messaging:emailTemplate, messaging:htmlEmailBody, knowledge:articleList, knowledge:articleRendererToolbar, ideas, flow:interview, site, social:profileViewer, topics, wave:dashboard, Analytics Wave, 57개 비-apex 컴포넌트, Chatter 피드 컴포넌트, VF 이메일 템플릿 태그, liveAgent 채팅 컴포넌트 | `Visualforce(비주얼포스)/비-apex 표준 컴포넌트 — chatter·support·liveAgent·기타.md` |
